# RT-10: recover the 0x4f0059 edge/arrow cascade so pointer priority and hover near viewport edges are proven

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer; one independent `slice-reviewer` afterwards. Base: current `main`.

## Why

RT-2/RT-6 recovered the original pointer transform and activation (`src/session_input.[ch]`) but `ActionScanInput.priority_clear` (and hover behaviour near the viewport edges) is assumed, not proven. `src/session_input.h` says priority_clear means 0x4f0059's earlier UI/puzzle/navigation paths did not claim the pointer. In the original, before the generic hotspot scan, the cascade at `0x4f0059` consults edge/arrow cursor logic and reads globals `[0x5a4c1c]`, `[0x5bb2ca]`, `[0x5bb2cc]`, `[0x5bb6b6]`, `[0x5b0260]`, `[0x5b0262]`, `[0x5b51f6]`, `[0x5b51c6]`, `[0x5b51ab]` (see the RT-6 review notes and `work/analysis/slices/RT-2.recovery.md`, `RT-6.*`). In a real window this decides whether a click near the edge of the 3D/scene viewport turns the view (arrow cursors) or activates a hotspot, and which cursor shows.

## Outcome

1. Recover from the original (REA skill in AGENTS.md; `xcrun llvm-objdump -d --x86-asm-syntax=intel work/original/GAME.EXE`) the complete cascade at `0x4f0059`: every branch before the generic scan, which globals decide it, the edge geometry (viewport rectangle, arrow zones, the sizes involved), the cursor selection outputs (cursor id/arrow direction), and what each branch does with the click (turn, move, ignore). Hash the code ranges. List which globals are written by other, not-yet-reconstructed code and what their live values are in the opening scenes.
2. Implement it in `session_input` extension files you own (`src/session_input_edge.[ch]` or similar) with an original-x86 oracle (hooks only for OS/host boundaries, every hook enumerated) over a grid of pointer positions including all four edges, corners, inside/outside the viewport, with the relevant globals in each combination the opening scenes can produce.
3. Wire it: compute `priority_clear` and the edge cursor from the recovered cascade in the app's pointer path (`src/blackmoor_app.mm` pointer/session-tick wrappers) and expose the chosen cursor. Where a global's live producer is unrecovered, name it and use the value the opening scenes provably have, never a silent default.
4. Tests: failing first; a live scripted hover/click near each edge in S5900/S4700 in `--inspect-live-session` mode showing the cursor and activation decisions; mutation checks that kill wrong edge widths, wrong axis, off-by-one inclusive/exclusive bounds.

## Ownership
New `src/session_input_edge.[ch]`, build script, tests/oracle; minimally `src/session_input.[ch]`, `src/blackmoor_app.mm`, `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_session_input*.py`. Do not edit other families, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-10.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
Failing tests first; every branch cited to addresses; unproven globals listed; `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes (run it twice after a fresh merge: a cached parser library is stale on the first run); build clean under `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-10.handoff.json` with commit, baseline, hashes, commands, results, unverified list. Commit only owned files on your branch, no push; message ends `Co-Authored-By: Codex <noreply@openai.com>`, no model identifiers.
