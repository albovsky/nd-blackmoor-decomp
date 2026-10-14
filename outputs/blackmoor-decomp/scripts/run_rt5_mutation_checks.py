#!/usr/bin/env python3
"""RT-5 mutation check: deliberately broken copies of session_exit.c and
session_bindings_a28.c must be caught by the unit tests, the original-x86
oracles, or the sanitizer fixture.

    python3 outputs/blackmoor-decomp/scripts/run_rt5_mutation_checks.py [--report PATH]

Each mutation edits a private copy of src/, rebuilds libsessionexit from it,
runs the unit tests and both oracles against that library, and rebuilds the
sanitizer fixture from the copy. A mutation that nothing detects is a survivor
and fails the run.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
ORACLE_PYTHON = ROOT / "work/tools/oracle-python/bin/python"
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-5-mutation-checks.json"

M = "session_exit.c"
B = "session_bindings_a28.c"

MUTATIONS = [
    ("stage0_type2_enters_stage2", M, "x->effect.sequence_counter = 1u;               /* 0x4474b0 */",
     "x->effect.sequence_counter = 2u;"),
    ("stage0_type2_keeps_state4", M, "            x->g.game_state = SESSION_EXIT_STATE_LOAD; /* 0x4474c0 */",
     "            (void)0;"),
    ("stage0_no_state3_for_nested_tick", M,
     "    x->g.game_state = SESSION_EXIT_STATE_RUN;          /* 0x447436 */", "    (void)0;"),
    ("stage0_no_modal_input", M, "    x->g.modal_input = 1;                              /* 0x447422 */",
     "    (void)0;"),
    ("stage0_no_redraw_request", M, "    x->g.redraw_request = 1;                           /* 0x4d36f0 (call 0x4d36ed) */",
     "    (void)0;"),
    ("stage0_type3_not_cleared", M, "    case 1u:\n    case 3u:\n        if (host->clear_destination_capture",
     "    case 1u:\n        if (host->clear_destination_capture"),
    ("stage1_type3_not_rewritten", M, "payload[PAYLOAD_TYPE] = 2u;                    /* 0x447514 */",
     "(void)0;"),
    ("stage1_no_stage_advance", M, "x->effect.sequence_counter = 2u;                   /* 0x44750f / 0x447530 */",
     "(void)0;"),
    ("stage1_capture_source_instead", M, "host->capture(host->context, SESSION_EXIT_CAPTURE_DESTINATION)",
     "host->capture(host->context, SESSION_EXIT_CAPTURE_SOURCE)"),
    ("stage3_does_not_clear_busy", M, "exit_state->effect.busy = 0u;                  /* 0x4477be */",
     "(void)0;"),
    ("sequence_busy_not_read_back", M, "    x->effect.busy = state.busy;", "    (void)0;"),
    ("sequence_scene_state_not_read_back", M, "    x->g.game_state = state.scene_state;", "    (void)0;"),
    ("sequence_stage_not_read_back", M, "    x->effect.sequence_counter = state.stage;", "    (void)0;"),
    ("sequence_budget_wrong_offset", M, "#define PAYLOAD_BUDGET 1u", "#define PAYLOAD_BUDGET 3u"),
    ("gate_always_runs", M, "    if (should_run == 0u) {\n        return SESSION_EXIT_OK;\n    }",
     "    if (0) {\n        return SESSION_EXIT_OK;\n    }"),
    ("state4_allows_popup_zero", M, "    if (exit_state->g.popup_flag == 0) {               /* 0x43d26d, call 0x4ee5cd */",
     "    if (0) {"),
    ("state4_allows_load_game", M, "    if (exit_state->g.load_game_flag != 0) {", "    if (0) {"),
    ("state4_loader_state_wrong", M, "exit_state->g.game_state = SESSION_EXIT_STATE_LOAD;         /* 0x43d6a4 */",
     "exit_state->g.game_state = SESSION_EXIT_STATE_INTRO;"),
    ("begin_load_swapped", M, "? SESSION_EXIT_STATE_INTRO       /* 0x43817e */",
     "? SESSION_EXIT_STATE_RUN"),
    ("request_uses_wrong_tuple_word", M, "request->opaque_words[2];   /* 0x427d93 */",
     "request->opaque_words[1];"),
    ("latch_input_latch_zero", M, "exit_state->g.input_latch = -1;           /* 0x43e410 */",
     "exit_state->g.input_latch = 0;"),
    ("latch_render_level_missing", M, "    exit_state->g.first_render_level = 1;     /* 0x43e41a, call 0x43dbd5 */",
     "    (void)0;"),
    ("caption_visible_flag_kept", M, "    life->shared->caption_visible_flag = 0;   /* 0x43e20d: 0x5b1606 */",
     "    (void)0;"),
    ("caption_scroll_lines_off_by_one", M, "view_rows = add_i32(sub_i32(view_bottom, view_top), 1);",
     "view_rows = add_i32(sub_i32(view_bottom, view_top), 0);"),
    ("caption_close_skipped", M, "    if (caption_ctb_close(life, backend) != CAPTION_LIFECYCLE_OK) { /* 0x43e1c2 */",
     "    if (0) {"),
    ("a28_completion_not_reported", B, "        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;",
     "        result->disposition = SCENE_ACTION_HANDLER_PENDING;"),
    ("a28_world_not_committed", B, "    binding->exit_state->effect = step.world;", "    (void)0;"),
    ("a28_ineligible", B, "    input.eligible = 1u;", "    input.eligible = 0u;"),
    ("a28_phase_dropped", B, "    result->phase = step.phase;", "    result->phase = 0u;"),
    # Sanitizer sensitivity: a read past the whole CaptionGeometry object.
    ("sanitizer_tbox_view_bottom_out_of_range", M, "#define TBOX_VIEW_BOTTOM 0x0cu  /* 0x5b0a1e */",
     "#define TBOX_VIEW_BOTTOM 0x7cu"),
]


def run(command, env, cwd, timeout=900):
    return subprocess.run(command, env=env, cwd=cwd, capture_output=True, text=True,
                          timeout=timeout)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--only", help="run a single mutation by name")
    args = parser.parse_args()
    results = []
    with tempfile.TemporaryDirectory(prefix="rt5-mutation-") as scratch:
        scratch_path = Path(scratch)
        for name, filename, old, new in MUTATIONS:
            if args.only and name != args.only:
                continue
            source = (PROJECT / "src" / filename).read_text()
            if source.count(old) != 1:
                print(f"{name}: pattern not found exactly once", file=sys.stderr)
                return 2
            copy = scratch_path / name / "src"
            shutil.copytree(PROJECT / "src", copy)
            (copy / filename).write_text(source.replace(old, new))
            library = scratch_path / name / "libsessionexit.dylib"
            env = dict(os.environ, SESSION_EXIT_SRC=str(copy),
                       SESSION_EXIT_OUTPUT=str(library), SESSION_EXIT_LIBRARY=str(library))
            detected = []
            build = run([str(PROJECT / "scripts/build_session_exit.sh")], env, PROJECT)
            if build.returncode != 0:
                results.append({"mutation": name, "detected_by": ["build"],
                                "note": build.stderr[-300:]})
                continue
            unit = run([sys.executable, "-m", "unittest", "test_session_exit",
                        "test_session_bindings_a28"], env, PROJECT / "tests")
            if unit.returncode != 0:
                detected.append("unit-tests")
            for script in ("session_exit_original_oracle.py",
                           "session_bindings_a28_original_oracle.py"):
                report = scratch_path / name / (script + ".json")
                oracle = run([str(ORACLE_PYTHON), script, "--report", str(report)],
                             env, PROJECT / "tests")
                if oracle.returncode != 0:
                    detected.append(script.replace("_original_oracle.py", "-oracle"))
            sanitizer = run([str(PROJECT / "scripts/test_session_exit_sanitizers.sh")],
                            dict(env, BUILD_DIR=str(scratch_path / name / "san")), PROJECT)
            if sanitizer.returncode != 0:
                detected.append("sanitizer")
            results.append({"mutation": name, "file": filename, "detected_by": detected})
            print(f"{name}: {', '.join(detected) if detected else 'SURVIVED'}", flush=True)
    survivors = [r["mutation"] for r in results if not r["detected_by"]]
    report = {"slice": "RT-5", "mutations": len(results), "survivors": len(survivors),
              "survivor_names": survivors, "results": results}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"mutations": len(results), "survivors": len(survivors)}))
    return 1 if survivors else 0


if __name__ == "__main__":
    sys.exit(main())
