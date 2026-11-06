# QA-005 — Preserve remembered installation save protection

Owner authorization: current authorizing Codex chat, 2026-11-05: “Fix QA-005, verify it, and get it merged. Leave QA-004 alone.” Root of that chat owns publication and merge. Delegates prepare code, frozen candidates and evidence only. The earlier full-suite gate remains required. No further permission question is needed for this authorized fix/verification/publication.

Baseline: 01a77df429e3c202ac96f2d6a9b737a91a650a1c, current origin/main (PR #352 merged). Branch: codex/fix-qa005-save-protection. Worktree is isolated; root's original checkout and pre-existing untracked files must stay unchanged.

Read AGENTS.md, PROJECT-SPEC.md and WORK-SLICES.md. This packet designates the implementation worker as sole integration editor for the owned startup files in this isolated branch. No other shared runtime/parser/dispatcher edits are authorized.

## Problem and direction

A custom original installation outside known paths is remembered. A completed private data clone exists. --save-dir inside that custom original makes startup destination validation fail; macos_recomp.mm clears the remembered value and removes it from protected_seed_directories. Cached clone startup then succeeds and creates a save directory inside the original. Actual current-startup QA fixture reproduced2/2; safe control2/2. Prior evidence immutable:
/Users/albovsky/Projects/nd-blackmoor-decomp/work/qa/2026-11-04/followup-verification-1793814085173015000/BUGS.md
and REPORT.md, save-folder-startup-probe.mm, save-folder-build.json, overlap-1/result.json, overlap-2/result.json, safe-control/result.json.

Fix the root cause minimally: preserve protection of the remembered installation even when it becomes ineligible as a discovery seed, or clearly refuse the conflicting destination before clearing the preference. Preserve valid remembered/known/dialog discovery, explicit --game-dir and --exe, offline reuse of valid completed cache, executable verification after final choice, and existing error prefixes. An unsafe overlap should exit2 with a useful GAME_DATA/SAVE_DIR message before creating anything in the original. Do not gratuitously reject unrelated safe paths or weaken tests.

## Owned files

- outputs/blackmoor-decomp/recomp/macos_recomp.mm (startup only)
- existing outputs/blackmoor-decomp/tests/test_macos_game_data.py and macos_game_data_fixture.mm if appropriate
- a narrowly scoped new startup regression test/fixture beside them when needed to exercise actual app startup rather than only helper behavior
- outputs/blackmoor-decomp/function-evidence.json and function-ledger.json (root-generated source fingerprints and fixture registration only; function entries and counts must remain unchanged)
- this packet (root owns initial wording; update only if needed for final evidence)

Do not modify macos_game_data API or other production files unless root explicitly agrees after evidence. Do not touch QA-004, piano logic, GAME.EXE, work/gamedata, work/original, original source record or prior QA evidence. Never commit game assets, saves, generated build artifacts or raw resource dumps.

## Implementation/verification acceptance

1. Add meaningful executable regression of actual startup ordering, synthetic fixture files where possible. Prove regression fails against baseline and passes with fix. A helper-only test that already passes on baseline is insufficient. Prefer reusing repo fixture patterns; no new test frameworks.
2. Cover original nested save destination, ancestor overlap, safe destination and stale/missing remembered source + completed cache. Existing tests cover aliases, hash and permissions; ensure no regressions. No need to multiply every coordinate/path permutation.
3. Run test_macos_game_data and test_recomp_save_files. Always record exact commands/counts/exits, source hash and unverified branches. Root will independently build app, rerun the frozen QA reproducer adapted only in new scratch, run normal save/load and canonical full suite, and obtain independent frozen-commit slice-reviewer review before merge.
4. Keep tests deterministic, finite, silent and hidden. No AppKit focus or real preferences. All actual game launches must have --mute --background and fresh scratch --game-dir/--save-dir. Do not run a real chooser GUI; use existing hidden fixtures. Never use computer use or output-device audio.
5. ASan/UBSan/mutation checks from generic slice template apply proportionally: existing startup fixture red/green proves mutation sensitivity; no original-x86 oracle is needed for this host-only policy change. Record limits rather than inventing irrelevant checks.
6. Never type the shell deletion command, never chain commands or use pipes; one command per line and each shell variable setup on its own line.
7. Prepare code and evidence only. Do not push, publish PR/comments, merge, or modify main. Do not commit until root asks; return a patch/worktree handoff with staged/unstaged diff and receipts. Root handles conventional commit without AI attribution per current desktop instructions.

Write only uniquely named new evidence under the root-provided work/qa/2026-11-05/qa005-fix-* folder. Do not overwrite any earlier QA evidence. Root authorization receipt and paths are available in /private/tmp/blackmoor-qa005-active.json.
