#!/usr/bin/env python3
"""RT-4 mutation checks: deliberately break one rule at a time in a COPY of the
sources, rebuild the affected libraries from the copy, and require that the
unit suites or the original-x86 whole-tree oracle fail. The production sources
are never modified. Run with the oracle interpreter:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/scripts/run_rt4_mutation_checks.py
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
REPORT = ROOT / "work/analysis/slices/RT-4-mutation-checks.json"
ORACLE_LIMIT = "800"

CLANG = ["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64", "-std=c11", "-Wall",
         "-Wextra", "-Wpedantic", "-Werror", "-O1", "-g", "-fPIC", "-dynamiclib"]

# (name, file, [(anchor, replacement)])  -- every anchor must match exactly once.
MUTATIONS = [
    # ---- tree (scene_conditions.c) ----
    ("reset_keeps_random_evaluated_flag", "scene_conditions.c", [
        ("            tree->runtime[index].random_cache_valid_2c = 0u;\n", "")]),
    ("reset_clears_selected_item_slot", "scene_conditions.c", [
        ("    for (index = 0u; index < tree->node_count; ++index) {\n        tree->nodes[index].status = 0;\n",
         "    tree->selected_leaf = NULL;\n    for (index = 0u; index < tree->node_count; ++index) {\n        tree->nodes[index].status = 0;\n")]),
    ("leaf_status_not_preset_to_retained", "scene_conditions.c", [
        ("    int32_t status = node->status;\n    int provider_status = 0;\n",
         "    int32_t status = 0;\n    int provider_status = 0;\n")]),
    ("threshold_seconds_term_dropped", "scene_conditions.c", [
        ("    value += (uint32_t)seconds_word * UINT32_C(1000);\n",
         "    value += (uint32_t)seconds_word * UINT32_C(0);\n")]),
    ("threshold_table_word_ignored", "scene_conditions.c", [
        ("scene_condition_make_threshold(tree->nodes[index].fields, word);",
         "scene_condition_make_threshold(tree->nodes[index].fields, tree->nodes[index].fields[6]);")]),
    ("adjacent_selected_item_preflight_removed", "scene_conditions.c", [
        ("records[record_index + 1u].opcode == 11u && record->fields[3] == 0) {",
         "records[record_index + 1u].opcode == 11u && record->fields[3] == 77) {")]),
    ("evaluation_mode_not_forwarded", "scene_conditions.c", [
        ("        request.evaluation_mode = context->evaluation_mode;\n",
         "        request.evaluation_mode = 0;\n")]),
    ("empty_tree_does_not_notify", "scene_conditions.c", [
        ("        if (extension != NULL && extension->tree_evaluated != NULL) {\n            extension->tree_evaluated(extension->context, 1);\n        }\n",
         "")]),
    ("gate_mode_table_drops_0x62", "scene_conditions.c", [
        ("    case 0x62: case 0x63: case 0x6a:", "    case 0x63: case 0x6a:")]),
    # ---- binding (session_bindings_conditions.c) ----
    ("post_tree_store_polarity_inverted", "session_bindings_conditions.c", [
        ("binding->global_5c3a47 = root_status == 0 ? 1 : 0;", "binding->global_5c3a47 = root_status != 0 ? 1 : 0;")]),
    ("pass_start_stores_zero", "session_bindings_conditions.c", [
        ("        binding->global_5c3a47 = 1;                    /* 0x43cf25 */",
         "        binding->global_5c3a47 = 0;                    /* 0x43cf25 */")]),
    ("prior_gate_reads_zero", "session_bindings_conditions.c", [
        ("    session.previous_global_5c3a47 = binding->global_5c3a47;",
         "    session.previous_global_5c3a47 = 0;")]),
    ("sidecar_not_copied_back", "session_bindings_conditions.c", [
        ("    memcpy(request->runtime, &runtime, sizeof(runtime));\n", "")]),
    ("context_word_ignored", "session_bindings_conditions.c", [
        ("        session.context_58c94f = value;", "        session.context_58c94f = 0; (void)value;")]),
    ("channel_bounds_widened", "session_bindings_conditions.c", [
        ("(uint32_t)channel >= SESSION_CONDITIONS_CHANNEL_COUNT", "(uint32_t)channel >= 64u")]),
    ("pause_gates_or_instead_of_and", "session_bindings_conditions.c", [
        ("record->gate_172 == 0u && record->gate_16e == 0u ? 1 : 0",
         "record->gate_172 == 0u || record->gate_16e == 0u ? 1 : 0")]),
    ("missing_resource_error_code_wrong", "session_bindings_conditions.c", [
        ("manager->error_3c2 = 0x3efu;", "manager->error_3c2 = 0x3e8u;")]),
    ("get_status_hresult_not_recorded", "session_bindings_conditions.c", [
        ("    manager->host_result_3ca = record->get_status_hresult;   /* GetStatus */\n", "")]),
    ("crt_rand_multiplier_off_by_one", "session_bindings_conditions.c", [
        ("UINT32_C(0x343fd)", "UINT32_C(0x343fc)")]),
    # ---- kernel (condition_extra.c) ----
    ("random_sample_modulo_99", "condition_extra.c", [
        ("sample = raw_value % 100u;", "sample = raw_value % 99u;")]),
    ("random_evaluated_flag_never_set", "condition_extra.c", [
        ("    runtime->random_cache_valid_2c = 1u;\n    *status_out = runtime->random_sample_30",
         "    *status_out = runtime->random_sample_30")]),
    ("timer_pending_status_not_active", "condition_extra.c", [
        ("record_status != TIMER_PAUSED &&\n        record_status != TIMER_PENDING) {",
         "record_status != TIMER_PAUSED) {")]),
    ("prior_gate_polarity_inverted", "condition_extra.c", [
        ("*status_out = session->previous_global_5c3a47 != 0 ? 1 : 0;",
         "*status_out = session->previous_global_5c3a47 == 0 ? 1 : 0;")]),
    ("selected_item_mode_ignored", "condition_extra.c", [
        ("    if (session->evaluation_mode_614 != 0) {\n        *status_out = 1;",
         "    if (0) {\n        *status_out = 1;")]),
    ("selected_item_slot_cleared_by_any_miss", "condition_extra.c", [
        ("        if (*session->selected_dependency_leaf == leaf_identity) {", "        if (1) {")]),
    ("bsum_variable_word_always_zero", "session_bindings_conditions.c", [
        ("    *value = (int16_t)(uint16_t)((uint16_t)bsum[offset] |\n                                 ((uint16_t)bsum[offset + 1] << 8));\n",
         "    *value = 0;\n")]),
    ("bsum_variable_word_offset_off_by_two", "session_bindings_conditions.c", [
        ("offset = 2 * (int32_t)index - 9618;", "offset = 2 * (int32_t)index - 9616;")]),
    ("audio_control_zero_refusal_removed", "session_bindings_conditions_audio.c", [
        ("info.started != 0u && info.control_word == 0u", "info.started != 0u && info.control_word == 77u")]),
    ("audio_unloaded_channel_reported_loaded", "session_bindings_conditions_audio.c", [
        ("    if (info.loaded == 0u) {", "    if (0 && info.loaded == 0u) {")]),
    ("app_variable_word_provider_stubbed_to_zero", "blackmoor_app.mm", [
        ("    return session_conditions_bsum_variable_word(summary.bsum_raw, ENGINE_BOOT_BSUM_SIZE,\n                                                 index, value);",
         "    if (value == nullptr || index < 5000 || index > 5003) return 0;\n    *value = 0;\n    return 1;")]),
    ("app_context_provider_ignores_difficulty", "blackmoor_app.mm", [
        ("    *value = app->new_game.action_core.difficulty;\n    return CONDITION_EXTRA_HOST_OK;",
         "    *value = 0;\n    return CONDITION_EXTRA_HOST_OK;")]),
    ("app_channel_provider_always_unavailable", "blackmoor_app.mm", [
        ("    return session_conditions_live_audio_channel_record(app->live_audio, channel, record);",
         "    (void)channel; (void)record; return CONDITION_EXTRA_HOST_UNAVAILABLE;")]),
    # ---- executor / session ----
    ("candidate_tree_evaluated_without_item_leaves", "scene_executor.c", [
        ("                if (decision->chain_count == 0u) {\n                    decision->accepted = 1u;\n                } else {",
         "                if (0) {\n                    decision->accepted = 1u;\n                } else {")]),
    ("candidate_accepts_on_gate_without_label", "scene_executor.c", [
        ("decision->accepted = decision->label != -1 ? 1u : 0u;", "decision->accepted = 1u;")]),
    ("candidate_check_uses_mode_one", "scene_executor.c", [
        ("                        tree, &dispatch_state, executor->condition_extension, 0,\n                        &candidate_eligible",
         "                        tree, &dispatch_state, executor->condition_extension, 1,\n                        &candidate_eligible")]),
    ("executor_pass_notice_never_sent", "scene_executor.c", [
        ("        executor->condition_extension->pass_started(\n            executor->condition_extension->context);\n", "        (void)0;\n")]),
    ("executor_mode_always_zero", "scene_executor.c", [
        ("            scene_conditions_gate_mode_for_type(\n                (uint8_t)action_runtime_type(&action)),", "            0,")]),
    ("executor_host_unavailable_is_a_hard_error", "scene_executor.c", [
        (" ||\n                   condition_status == SCENE_CONDITION_ERR_HOST_UNAVAILABLE", "")]),
    ("executor_does_not_arm_thresholds", "scene_executor.c", [
        ("            scene_conditions_resolve_thresholds(executor->conditions[tree_index],\n                                                executor->condition_extension);\n",
         "            (void)tree_index;\n")]),
    ("session_does_not_reapply_extension", "scene_session.c", [
        ("    status = scene_executor_set_condition_extension(\n        *out_executor, session->condition_extension);\n",
         "    status = SCENE_EXECUTOR_OK;\n")]),
    ("session_host_unavailable_not_dependency_provider", "scene_session.c", [
        ("        if (session->condition_failure.opcode != 0u &&\n", "        if (0 && session->condition_failure.opcode != 0u &&\n")]),
]


def build_mutant(work: Path) -> dict[str, Path]:
    src = work / "src"
    libs = {
        "conditions": work / "libsessionconditions.dylib",
        "executor": work / "libsceneexecutor.dylib",
        "session": work / "libscenesession.dylib",
    }
    common = ["hiff.c", "scene_resource.c", "scene_conditions.c", "action_core.c",
              "action_family_64.c"]
    jobs = {
        "conditions": (["scene_conditions.c", "condition_extra.c", "session_bindings_conditions.c"], []),
        "executor": (common + ["scene_executor.c"], ["-DSCENE_EXECUTOR_TEST_HOOKS"]),
        "session": (common + ["world_clock.c", "action_ui.c", "scene_executor.c", "scene_session.c"],
                    ["-DSCENE_EXECUTOR_TEST_HOOKS"]),
    }
    for name, (sources, flags) in jobs.items():
        command = CLANG + flags + ["-I", str(src)] + [str(src / s) for s in sources] + ["-o", str(libs[name])]
        built = subprocess.run(command, capture_output=True, text=True)
        if built.returncode != 0:
            raise RuntimeError(f"mutant build failed ({name}):\n{built.stderr[-1500:]}")
    return libs


def suites(libs: dict[str, Path] | None):
    env_extra = {}
    if libs is not None:
        env_extra = {
            "SCENE_CONDITIONS_LIBRARY": str(libs["conditions"]),
            "SESSION_CONDITIONS_LIBRARY": str(libs["conditions"]),
            "RT4_EXECUTOR_LIBRARY": str(libs["executor"]),
            "RT4_SESSION_LIBRARY": str(libs["session"]),
        }
    conditions = str(libs["conditions"]) if libs else str(PROJECT / "build/libsessionconditions.dylib")
    return env_extra, [
        ("tree_unit", ["python3", "-m", "unittest", "test_scene_conditions_extension"]),
        ("binding_unit", ["python3", "-m", "unittest", "test_session_bindings_conditions"]),
        ("executor_unit", ["python3", "-m", "unittest", "test_scene_executor_extension"]),
        ("session_unit", ["python3", "-m", "unittest", "test_scene_session_extension"]),
        ("whole_tree_oracle", [sys.executable, "conditions_extra_tree_original_oracle.py",
                               "--native-library", conditions, "--limit", ORACLE_LIMIT,
                               "--no-report"]),
    ]


def build_audio_fixture(work: Path) -> Path:
    src = work / "src"
    fixture = work / "session_conditions_audio_fixture"
    command = ["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64", "-mmacosx-version-min=27.0",
               "-std=gnu17", "-Wall", "-Wextra", "-Werror", "-O1", "-g", "-I", str(src),
               str(PROJECT / "tests/session_conditions_audio_fixture.c"),
               str(src / "scene_conditions.c"), str(src / "condition_extra.c"),
               str(src / "session_bindings_conditions.c"),
               str(src / "session_bindings_conditions_audio.c"),
               f"-L{PROJECT / 'build'}", "-lliveaudio", "-lmacos_audio", "-lhis_audio",
               f"-Wl,-rpath,{PROJECT / 'build'}", "-Wl,-rpath,/opt/homebrew/lib", "-o", str(fixture)]
    built = subprocess.run(command, capture_output=True, text=True)
    if built.returncode != 0:
        raise RuntimeError(f"audio fixture build failed:\n{built.stderr[-1500:]}")
    return fixture


def run_audio_fixture(fixture: Path) -> bool:
    sys.path.insert(0, str(PROJECT / "tests"))
    import test_live_audio as live  # noqa: PLC0415
    with tempfile.TemporaryDirectory() as tmp:
        live.build_fixture_tree(Path(tmp))
        done = subprocess.run([str(fixture), tmp], capture_output=True, text=True, timeout=120)
    return done.returncode == 0 and done.stdout.count(" PASS") == 4


def build_app(work: Path) -> Path:
    # The build script derives its project directory from its own location.
    shutil.copytree(PROJECT / "scripts", work / "scripts")
    built = subprocess.run([str(work / "scripts/build_native_app.sh"), "--test-hooks"],
                           capture_output=True, text=True)
    if built.returncode != 0:
        raise RuntimeError(f"mutant app build failed:\n{built.stderr[-1500:]}")
    return work / "Blackmoor Reconstruction Test.app/Contents/MacOS/BlackmoorNative"


APP_TESTS = ["test_native_app.NativeCaptionTransferTests.test_condition_providers_read_boot_bsum_difficulty_and_live_audio"]


def run_suites(libs, work: Path | None = None, mutated_file: str = ""):
    env_extra, commands = suites(libs)
    env = dict(os.environ, **env_extra)
    outcome = {}
    for name, command in commands:
        done = subprocess.run(command, cwd=PROJECT / "tests", env=env, capture_output=True, text=True)
        outcome[name] = done.returncode == 0
    if work is None:                                  # baseline: production artifacts
        fixture = PROJECT / "build/session_conditions_audio_fixture"
        outcome["audio_fixture"] = run_audio_fixture(fixture)
        done = subprocess.run(["python3", "-m", "unittest", *APP_TESTS], cwd=PROJECT / "tests",
                              capture_output=True, text=True)
        outcome["app_providers"] = done.returncode == 0
    else:
        if mutated_file.startswith("session_bindings_conditions"):
            outcome["audio_fixture"] = run_audio_fixture(build_audio_fixture(work))
        if mutated_file == "blackmoor_app.mm":
            executable = build_app(work)
            done = subprocess.run(["python3", "-m", "unittest", *APP_TESTS], cwd=PROJECT / "tests",
                                  env=dict(env, RT4_NATIVE_EXECUTABLE=str(executable)),
                                  capture_output=True, text=True)
            outcome["app_providers"] = done.returncode == 0
    return outcome


def main() -> int:
    subprocess.run([str(PROJECT / "scripts/build_session_conditions.sh")], check=True,
                   capture_output=True)
    subprocess.run([str(PROJECT / "scripts/build_scene_conditions.sh")], check=True,
                   capture_output=True)
    baseline = run_suites(None)
    if not all(baseline.values()):
        print(f"unmutated suite must pass first: {baseline}", file=sys.stderr)
        return 1
    results = []
    survivors = 0
    with tempfile.TemporaryDirectory() as scratch:
        for name, filename, pairs in MUTATIONS:
            work = Path(scratch) / name
            shutil.copytree(PROJECT / "src", work / "src")
            target = work / "src" / filename
            text = target.read_text()
            for old, new in pairs:
                if text.count(old) != 1:
                    print(f"{name}: anchor not unique/found in {filename}: {old[:60]!r}", file=sys.stderr)
                    return 1
                text = text.replace(old, new)
            target.write_text(text)
            libs = build_mutant(work)
            outcome = run_suites(libs, work, filename)
            detected_by = [k for k, passed in outcome.items() if not passed]
            if not detected_by:
                survivors += 1
            results.append({"mutation": name, "file": filename, "detected_by": detected_by})
            shutil.rmtree(work)
    report = {"baseline_passes": baseline, "oracle_case_limit": int(ORACLE_LIMIT),
              "mutations": len(results), "survivors": survivors, "results": results}
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"mutations": len(results), "survivors": survivors}))
    for item in results:
        print(f"  {item['mutation']}: {', '.join(item['detected_by']) or 'SURVIVED'}")
    return 0 if survivors == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
