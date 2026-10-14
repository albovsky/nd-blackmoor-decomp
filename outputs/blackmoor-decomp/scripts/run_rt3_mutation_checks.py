#!/usr/bin/env python3
"""RT-3 mutation checks: deliberately break one rule at a time in a COPY of
the sources, rebuild the binding library from the copy, and require that the
unit tests or the original-x86 oracle fail. The production sources are never
modified. Run with the oracle interpreter so the oracle can execute:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/scripts/run_rt3_mutation_checks.py
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
REPORT = ROOT / "work/analysis/slices/RT-3-mutation-checks.json"

MUTATIONS = [
    ('executor_pre_gate_never_runs', 'scene_executor.c', [
        ('        run_pre_gate(executor, index, &action);\n',
         '        if (0) run_pre_gate(executor, index, &action);\n'),
    ]),
    ('executor_pre_gate_only_for_eligible_rows', 'scene_executor.c', [
        ('        run_pre_gate(executor, index, &action);\n',
         ''),
        ('            continue;\n        }\n\n        if (action.type == SCENE_ACTION_CHANGE_SCENE) {\n            if (action.typed_body == NULL',
         '            continue;\n        }\n        run_pre_gate(executor, index, &action);\n\n        if (action.type == SCENE_ACTION_CHANGE_SCENE) {\n            if (action.typed_body == NULL'),
    ]),
    ('executor_accept_candidate_stores_phase_1', 'scene_executor.c', [
        ('    executor->states[action_index].phase = 2u;\n    return SCENE_EXECUTOR_OK;\n',
         '    executor->states[action_index].phase = 1u;\n    return SCENE_EXECUTOR_OK;\n'),
    ]),
    ('a62_pre_gate_does_not_clear_request', 'session_bindings_a62.c', [
        ('    binding->targets[action_index].request_pending = 0u;\n}\n',
         '    (void)binding;\n}\n'),
    ]),
    ('a62_selector_ignored_defaults_to_zero', 'session_bindings_a62.c', [
        ('    memset(&input, 0, sizeof(input));\n    input.subtype = action->subtype;\n',
         '    selector = 0;\n    memset(&input, 0, sizeof(input));\n    input.subtype = action->subtype;\n'),
    ]),
    ('a62_completion_always_direct', 'session_bindings_a62.c', [
        ('    } else if (action->subtype == 1u || action->subtype == 2u) {\n        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;',
         '    } else if (0) {\n        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
    ]),
    ('a62_event_range_check_removed', 'session_bindings_a62.c', [
        ('        if (id < 0 || (size_t)id >= binding->world->event_flag_count) {',
         '        if (0 && (id < 0 || (size_t)id >= binding->world->event_flag_count)) {'),
    ]),
    ('a62_start_flag_written_every_visit', 'session_bindings_a62.c', [
        ('    if (step.start_global_written != 0u) {\n        binding->start_flag_5bb1ca = (int32_t)step.start_global_value;',
         '    if (1) {\n        binding->start_flag_5bb1ca = (int32_t)step.start_global_value;'),
    ]),
    ('a62_response_words_cleared_on_miss', 'session_bindings_a62.c', [
        ('    if (step.response_written != 0u) {\n        memcpy(target.response_words, step.response_words,\n               sizeof(target.response_words));\n    }',
         '    if (step.response_written != 0u) {\n        memcpy(target.response_words, step.response_words,\n               sizeof(target.response_words));\n    } else if (step.request_written != 0u) {\n        memset(target.response_words, 0, sizeof(target.response_words));\n    }'),
    ]),
    ('a62_second_event_pair_dropped', 'session_bindings_a62.c', [
        ('    for (pair = 0u; pair < step.event_write_count; ++pair) {\n        binding->world->event_flags[',
         '    for (pair = 0u; pair < (step.event_write_count > 1u ? 1u : step.event_write_count); ++pair) {\n        binding->world->event_flags['),
    ]),
    ('a51_completion_always_direct_and_phase_kept', 'session_bindings_a51.c', [
        ('        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;\n        result->phase = 0u;',
         '        result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;\n        result->phase = 0u;'),
    ]),
    ('a51_world_not_stored_back', 'session_bindings_a51.c', [
        ('    if (binding->host.store_world != NULL) {',
         '    if (0 && binding->host.store_world != NULL) {'),
    ]),
    ('a51_world_reset_on_begin_scene', 'session_bindings_a51.c', [
        ('    binding->last_kernel_status = ACTION_FAMILY_51_OK;\n    return SESSION_A51_OK;',
         '    memset(&binding->world, 0, sizeof(binding->world));\n    binding->last_kernel_status = ACTION_FAMILY_51_OK;\n    return SESSION_A51_OK;'),
    ]),
    ('a51_unsupported_row_is_not_a_named_blocker', 'session_bindings_a51.c', [
        ('    if (row->state == SESSION_A51_ROW_UNSUPPORTED) {',
         '    if (0 && row->state == SESSION_A51_ROW_UNSUPPORTED) {'),
    ]),
]

TEST_COMMANDS = [
    ("unit_a62", ["python3", "-m", "unittest", "discover", "-s", "tests",
                  "-p", "test_session_bindings_a62.py"]),
    ("unit_a51", ["python3", "-m", "unittest", "discover", "-s", "tests",
                  "-p", "test_session_bindings_a51.py"]),
    ("oracle_a62", [sys.executable, "tests/session_bindings_a62_original_oracle.py",
                    "--report", os.devnull]),
]


def run_suite(library: Path) -> dict[str, bool]:
    env = dict(os.environ, SESSION_BINDINGS_LIBRARY=str(library))
    outcome = {}
    for name, command in TEST_COMMANDS:
        done = subprocess.run(command, cwd=PROJECT, env=env,
                              capture_output=True, text=True)
        outcome[name] = done.returncode == 0
    return outcome


def main() -> int:
    baseline_lib = PROJECT / "build/libsessionbindings.dylib"
    subprocess.run([str(PROJECT / "scripts/build_session_bindings.sh")],
                   check=True, capture_output=True)
    baseline = run_suite(baseline_lib)
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
                    print(f"{name}: anchor not unique/found in {filename}", file=sys.stderr)
                    return 1
                text = text.replace(old, new)
            target.write_text(text)
            library = work / "libmutated.dylib"
            env = dict(os.environ, SESSION_BINDINGS_SRC=str(work / "src"),
                       SESSION_BINDINGS_OUTPUT=str(library))
            env.pop("SESSION_BINDINGS_LIBRARY", None)
            built = subprocess.run([str(PROJECT / "scripts/build_session_bindings.sh")],
                                   env=env, capture_output=True, text=True)
            if built.returncode != 0:
                print(f"{name}: mutated build failed:\n{built.stderr[-800:]}", file=sys.stderr)
                return 1
            outcome = run_suite(library)
            detected_by = [k for k, passed in outcome.items() if not passed]
            if not detected_by:
                survivors += 1
            results.append({"mutation": name, "file": filename,
                            "detected_by": detected_by})
    report = {"baseline_passes": baseline, "mutations": len(results),
              "survivors": survivors, "results": results}
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"mutations": len(results), "survivors": survivors}))
    for item in results:
        print(f"  {item['mutation']}: {', '.join(item['detected_by']) or 'SURVIVED'}")
    return 0 if survivors == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
