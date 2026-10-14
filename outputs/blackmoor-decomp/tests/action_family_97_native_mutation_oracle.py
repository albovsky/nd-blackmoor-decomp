#!/usr/bin/env python3
"""Compile deliberate bad C reconstructions and require x86 oracle failure."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
SOURCE = PROJECT / "src/action_family_97.c"
ORACLE = PROJECT / "tests/action_family_97_original_oracle.py"
EVIDENCE = ROOT / "work/analysis/slices"

MUTATIONS = {
    "wrong-runtime-word-destination": (
        "put32(p + 0x27u, d->word_23);", "put32(p + 0x26u, d->word_23);",
        "whole object mismatch"),
    "wrong-body-consumption": (
        "value.body_bytes_consumed = decoded.body_bytes;",
        "value.body_bytes_consumed = decoded.body_bytes - 1u;",
        "cursor, normalization or selection mismatch"),
    "wrong-random-state-rule": (
        "random_state_before * UINT32_C(214013)",
        "random_state_before * UINT32_C(214014)",
        ("whole object mismatch", "cursor, normalization or selection mismatch")),
    "wrong-selected-name-offset": (
        "memcpy(payload, value.names_after[(size_t)selected], 33u);",
        "memcpy(payload, value.names_after[0], 33u);",
        "whole object mismatch"),
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    source = SOURCE.read_text()
    results = []
    with tempfile.TemporaryDirectory(prefix="action97-mutants-") as tmp:
        directory = Path(tmp)
        for label, (before, after, diagnostic) in MUTATIONS.items():
            if source.count(before) != 1:
                raise RuntimeError(f"mutation anchor changed: {label}")
            changed = source.replace(before, after)
            mutant = directory / (label + ".c")
            library = directory / (label + ".dylib")
            mutant.write_text(changed)
            compile_command = ["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64", "-std=c11",
                "-Wall", "-Wextra", "-Wpedantic", "-Werror", "-O2", "-fPIC", "-dynamiclib",
                "-I", str(PROJECT / "src"), str(mutant), "-o", str(library)]
            subprocess.run(compile_command, check=True, capture_output=True)
            command = [sys.executable, "-u", str(ORACLE), "--native-library", str(library),
                "--first-record-only", "--result", str(directory / (label + ".json"))]
            run = subprocess.run(command, capture_output=True, text=True)
            log = EVIDENCE / ("A-97.1.mutant-" + label + ".log")
            log.write_text(run.stdout + run.stderr)
            diagnostics = (diagnostic,) if isinstance(diagnostic, str) else diagnostic
            found = next((d for d in diagnostics if d in run.stderr), None)
            if run.returncode != 1 or found is None:
                raise RuntimeError(f"oracle failed to detect {label} through expected diagnostic: exit={run.returncode}")
            results.append(dict(label=label, detected=True, exit_code=run.returncode,
                diagnostic=found, source_sha256=sha(changed.encode()),
                library_sha256=sha(library.read_bytes()), log_sha256=sha(log.read_bytes()),
                fixture="first corpus record, original selection among five alternatives",
                compile_command=compile_command, oracle_command=command))
    report = dict(compiled_mutants=len(results), detected=len(results),
        baseline_source_sha256=sha(SOURCE.read_bytes()),
        oracle_sha256=sha(ORACLE.read_bytes()), mutations=results,
        scope="compiled constructor offsets, body consumption, selection-state rule")
    (EVIDENCE / "A-97.1.mutations.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("compiled_mutants", "detected")}))


if __name__ == "__main__":
    main()
