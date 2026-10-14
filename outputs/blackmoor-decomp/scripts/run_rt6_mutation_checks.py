#!/usr/bin/env python3
"""RT-6 mutation check for the executor candidate and the session pointer boundary.

    python3 outputs/blackmoor-decomp/scripts/run_rt6_mutation_checks.py [--report PATH]

Each mutation edits a private copy of the project (src, scripts, tests), rebuilds
libsceneexecutor and libscenesession from it, and runs the executor, session and
session-pointer unit suites against the copy. A mutation that no test detects is
a survivor and fails the run.
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-6-mutation-checks.json"
SUITES = ["test_scene_executor", "test_scene_executor_extension",
          "test_scene_session", "test_scene_session_pointer"]

E = "scene_executor.c"
S = "scene_session.c"

MUTATIONS = [
    ("executor_ignores_candidate_valid_flag", E,
     "        frame_input->activation_candidate_valid &&\n", ""),
    ("executor_activates_without_accepted_event", E,
     "    if (frame_input->hotspot_activation_event &&\n        frame_input->activation_candidate_valid",
     "    if (frame_input->activation_candidate_valid"),
    ("executor_ignores_modal_gate", E,
     "        if (!frame_input->modal_event_active &&\n", "        if (1 &&\n"),
    ("executor_candidate_beyond_count_accepted", E,
     "            candidate < executor->action_count &&\n            candidate < SCENE_EXECUTOR_MAX_ACTIONS &&\n",
     "            candidate < SCENE_EXECUTOR_MAX_ACTIONS &&\n"),
    ("executor_only_builtin_hotspots_accept", E,
     "            {\n                /* 0x43bff8: 0x42405a(root)",
     "            if (candidate_action.type != 0x6a && candidate_action.type != 0x15) { } else {\n                /* 0x43bff8: 0x42405a(root)"),
    ("executor_never_stores_phase_two", E,
     "                    executor->states[candidate].phase = 2u;\n                }\n            }\n        }\n    }\n\n    /* The original loader bakes",
     "                    (void)0;\n                }\n            }\n        }\n    }\n\n    /* The original loader bakes"),
    ("session_keeps_prepare_supplied_activation", S,
     "        frame_input.hotspot_activation_event = 0u;\n        frame_input.activation_candidate_valid = 0u;",
     "        frame_input.activation_candidate_valid = 0u;"),
    ("session_never_sets_candidate_valid", S,
     "            frame_input.activation_candidate_valid = 1u;\n            frame_input.activation_candidate = candidate;",
     "            frame_input.activation_candidate = candidate;"),
    ("session_no_reset_on_replacement", S,
     "    if (session->pointer_bound &&\n        session->pointer.reset(session->pointer.context) != SESSION_INPUT_OK) {",
     "    if (0) {"),
    ("session_reset_after_failed_executor_build", S,
     "    status = build_executor(session, scene, &candidate, failure);\n    if (status != SCENE_EXECUTOR_OK) {\n        return status == SCENE_EXECUTOR_ERR_MEMORY\n                   ? SCENE_SESSION_ERR_MEMORY : SCENE_SESSION_ERR_EXECUTOR;\n    }\n    /* Latch",
     "    if (session->pointer_bound) (void)session->pointer.reset(session->pointer.context);\n    status = build_executor(session, scene, &candidate, failure);\n    if (status != SCENE_EXECUTOR_OK) {\n        return status == SCENE_EXECUTOR_ERR_MEMORY\n                   ? SCENE_SESSION_ERR_MEMORY : SCENE_SESSION_ERR_EXECUTOR;\n    }\n    /* Latch"),
    ("session_scans_after_transition", S,
     "        session->transition_pending = 1;\n        session->transition = local.executor.transition;",
     "        session->transition_pending = 1;\n        if (session->pointer_bound) (void)pointer_scan(session);\n        session->transition = local.executor.transition;"),
    ("session_scan_ignores_external_rows", S,
     "        } else if (session->pointer.external_row != NULL &&", "        } else if (0 &&"),
    ("session_scan_offers_inactive_rows", S,
     "SCENE_EXECUTOR_OK && hotspot.active && hotspot.rectangle_valid) {",
     "SCENE_EXECUTOR_OK && hotspot.rectangle_valid) {"),
    ("session_invalid_consume_status_ignored", S,
     "        if (pointer_status != SESSION_INPUT_OK &&\n            pointer_status != SESSION_INPUT_LIMIT_CURSOR_GEOMETRY &&\n            pointer_status != SESSION_INPUT_LIMIT_PRIORITY_PATH) {\n            block_missing(&failure, SCENE_SESSION_STAGE_POINTER,",
     "        if (0) {\n            block_missing(&failure, SCENE_SESSION_STAGE_POINTER,"),
    ("session_limit_still_activates", S,
     "        if (pointer_status != SESSION_INPUT_OK) {\n            /* A projection limit consumed the edge; nothing may activate. */\n            frame_input.hotspot_activation_event = 0u;\n        }",
     "        if (pointer_status != SESSION_INPUT_OK) {\n            frame_input.hotspot_activation_event = 1u;\n        }"),
    ("session_bind_skips_reset", S,
     "    if (host->reset(host->context) != SESSION_INPUT_OK) {\n        return SCENE_SESSION_ERR_ARGUMENT;\n    }\n    session->pointer = *host;",
     "    session->pointer = *host;"),
    ("session_candidate_not_reported_from_consume", S,
     "        session->pointer_result.candidate_at_consume = candidate;", "        session->pointer_result.candidate_at_consume = -1;"),
]


def run(command, cwd, timeout=900):
    return subprocess.run(command, cwd=cwd, capture_output=True, text=True, timeout=timeout)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", default=str(DEFAULT_REPORT))
    arguments = parser.parse_args()
    results = []
    survivors = []
    for name, filename, old, new in MUTATIONS:
        with tempfile.TemporaryDirectory(prefix="rt6-mutation-") as directory:
            # Tests locate ROOT/work two levels above the project directory.
            (Path(directory) / "outputs").mkdir()
            (Path(directory) / "work").symlink_to(ROOT / "work")
            copy = Path(directory) / "outputs" / "blackmoor-decomp"
            shutil.copytree(PROJECT, copy, ignore=shutil.ignore_patterns(
                "build", "*.app", "*.zip", "__pycache__"))
            target = copy / "src" / filename
            text = target.read_text()
            if text.count(old) != 1:
                results.append({"mutation": name, "status": "invalid-anchor",
                                "occurrences": text.count(old)})
                survivors.append(name)
                print(f"{name}: INVALID ANCHOR ({text.count(old)} occurrences)")
                continue
            target.write_text(text.replace(old, new))
            detected_by = []
            built = True
            for script in ("build_scene_executor.sh", "build_scene_session.sh"):
                build = run([str(copy / "scripts" / script), "--test-hooks"], copy)
                if build.returncode:
                    built = False
                    detected_by.append(f"compile:{script}")
                    break
            if built:
                for suite in SUITES:
                    outcome = run([sys.executable, "-m", "unittest", suite],
                                  copy / "tests")
                    if outcome.returncode:
                        detected_by.append(suite)
            status = "detected" if detected_by else "SURVIVED"
            if not detected_by:
                survivors.append(name)
            results.append({"mutation": name, "file": filename, "status": status,
                            "detected_by": detected_by})
            print(f"{name}: {status} {detected_by}")
    report = {"slice": "RT-6", "mutants": len(MUTATIONS),
              "detected": len(MUTATIONS) - len(survivors),
              "survivors": survivors, "results": results}
    Path(arguments.report).write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("mutants", "detected", "survivors")}))
    return 1 if survivors else 0


if __name__ == "__main__":
    raise SystemExit(main())
