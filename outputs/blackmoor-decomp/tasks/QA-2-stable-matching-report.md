# QA-2: stable committed matching report

Owner: slice-implementer (Sonnet). Root: Claude Opus. Branch `claude/qa-2-stable-matching-report`, worktree `.claude/worktrees/qa-2-matching-report`, cut from origin/main `9ba189a`.

## Problem

`outputs/blackmoor-decomp/scripts/build_matches.sh` runs `scripts/verify_matches.py ... --report outputs/blackmoor-decomp/matching-report.json`. The verifier writes `original`, `manifest` and each `functions[].object` as resolved absolute paths (`_empty_report` and `_validated_manifest` call `Path.resolve()`). The committed report currently carries another checkout's paths (`/Users/albovsky/Documents/Codex/...`), so every run of `script/build_all_native_checks.sh` (and the QA-1 runner `script/run_test_suite.sh`, PR 29, not yet merged) leaves the tracked file dirty. Only the path strings differ between runs.

## Fix (chosen by root)

Record those paths relative to the workspace root (the repository root), opt-in, so that only the committed report changes form:

1. `scripts/verify_matches.py`: add an optional `--path-root DIR` argument. When given, the written report records `original`, `manifest` and every `functions[].object` relative to `DIR`, POSIX separators, computed from the absolute but **unresolved** path (`os.path.abspath`, not `Path.resolve()`), so a worktree whose `work/` is a symlink still gives `work/original/GAME.EXE`. A path outside `DIR` falls back to its `os.path.relpath` (may contain `..`); never fail on that. Without `--path-root` the output is byte-identical to today, because several auditors (`audit_matching_s08*.py`, `audit_tool_assisted.py`, `decomp-progress/generate.py`) import or run the verifier and some of their outputs are pinned by SHA-256. Keep the change confined to report writing; the verifier must still read the object and original from their real paths.
2. `scripts/build_matches.sh`: pass `--path-root "$workspace"` where `$workspace` is the repository root (two levels above `outputs/blackmoor-decomp`).
3. Regenerate `outputs/blackmoor-decomp/matching-report.json` with the new build (one-time content change: paths become `work/original/GAME.EXE`, `outputs/blackmoor-decomp/matches.json`, `outputs/blackmoor-decomp/build/initial_functions.obj`). Every non-path field must stay identical; show that with a JSON diff in your receipt.
4. Readers: `progress-map/generate.py` `resolve_manifest` already accepts a relative `manifest` (tries `project / raw` first). Confirm with a run or test that `validate_matching` returns valid for the new report. Check `decomp-progress`, status docs, README and any test that reads `matching-report.json` or the verifier's path fields, and keep them working. Do not regenerate `progress-map/snapshot.json` or other generated docs unless a test fails without it; if the snapshot pins the old report SHA-256, say so in the receipt and leave it to root.
5. Tests: one focused test in `outputs/blackmoor-decomp/tests/test_verify_matches.py` (extend the existing file) that `--path-root` yields relative, symlink-preserving paths and that omitting it leaves the absolute form unchanged. No other new tests.

## Owned files

`outputs/blackmoor-decomp/scripts/verify_matches.py`, `outputs/blackmoor-decomp/scripts/build_matches.sh`, `outputs/blackmoor-decomp/matching-report.json`, `outputs/blackmoor-decomp/tests/test_verify_matches.py`, and `progress-map/generate.py` only if a reader truly needs a change. README wording only if it states the absolute form.

## Acceptance

- `script/build_all_native_checks.sh` exits 0, and afterwards `git status --porcelain` is empty (run it twice).
- `cd outputs/blackmoor-decomp/tests && python3 -m unittest test_verify_matches` passes; `outputs/blackmoor-decomp/progress-map/test_progress_map.py` passes.
- Report the full-suite command root will run: root merges this branch with `origin/claude/suite-baseline` (PR 29) and runs `script/run_test_suite.sh -v`; you need not run the full suite yourself, but you may.
- Never modify GAME.EXE or anything under `work/original`. Commit only owned files plus this packet, with the attribution line root gives you. Do not push.
