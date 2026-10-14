# RT-6: wire the recovered pointer producer (`session_input`) into the live session

Branch: `claude/rt-6-pointer-integration`, from root's `claude/hungry-matsumoto-8ab8eb` once RT-2 and RT-4 are merged into it. Owner: a `slice-implementer`.

## Background

RT-2 delivered `src/session_input.[ch]` (original WM_MOUSEMOVE/LBUTTONDOWN/UP/DBLCLK wrappers and latch, the consume at 0x4daf3f, the mode/modal/range guards at 0x43b1a6 and 0x43bfb6, and the 0x4f0059 transform with an inclusive first-hit generic scan), checked against the original under Unicorn, reviewed twice. The app still feeds the executor a provisional pointer inline in `prepare_native_session_tick` (window coordinates minus the scene viewport origin; any release activates), and `scene_executor.c` still keeps its own pending-candidate cache and scans hotspots without a `break` (the last overlapping hit wins; the original takes the first).

Read first: `work/analysis/slices/RT-2.recovery.md`, `RT-2.handoff.json`, the RT-2 review notes carried in this packet's findings below, `src/session_input.h`, `src/scene_executor.[ch]`, `src/scene_session.[ch]`, `src/session_exit.[ch]` (RT-5 clears the latch block through its own `session_exit_clear_latches`; reconcile it with `session_input_init`), `src/session_bindings_a62.[ch]` (the 0x62 accept path `scene_executor_accept_action_candidate`), and the `pointer()`/`prepare_native_session_tick` code in `src/blackmoor_app.mm`.

Review findings of RT-2 that this slice must honour:
- The module's activation needs one global candidate (original `0x5c39e5`). The executor currently has two (its own pending hotspot candidate and the 0x62 accept path) and a last-hit bug; replace them with one candidate owned by the input module, consumed by the executor's hotspot phase handling and the 0x62 accept.
- Call `session_input_init` on scene replacement (the latch constructor 0x4dad60 runs from the loaders and also sets `[0x5c39e5] = -1`, `[0x5c39e9] = 0`).
- The cursor sprite size, hot point and scroll are unrecovered. Supply them from one explicitly named provisional struct that sets `geometry_ready`, with values that make the S0 numbers identical to today's (`x-10, y-10`, hot (0,0), scroll 0), and say so in the log and handoff. Set `priority_clear` only after verifying the S0 guards (`[0x5a4c18]==0`, bytes at `0x5b5158`, `0x5b61af`, `0x5b615e` equal 0).
- A macOS clickCount of 2 must map to the module's DBLCLK; feed MOVE/DOWN/UP/DBLCLK straight from `pointer()`; drop the app's `primary_released` and per-update edge clearing for the session path (the startup menu path keeps its own).

## Outcome

1. The live S0 click goes through `session_input` end to end and still enters S5900 (`--inspect-live-session --live-click-row 34` unchanged in outcome), with the log showing the module's decision instead of the inline formula.
2. A single candidate in the executor/session path, first-hit order, shared by `0x6a`/raw `0x15` hotspot actions and the 0x62 accept; remove the redundant cache with tests proving no double phase-2 in one frame.
3. A scripted double-click regression: DOWN, UP, tick, DBLCLK, UP, tick must reject the second activation, in the native app run as well as in unit tests.
4. S5900 row 7 (0x62): with the recovered pointer path wired, report what the scripted live run does (it needs a hover over the row's rectangle `(0,0)-(10,10)` in transformed cursor space; try it and report; do not invent a gesture the original would not accept).

## Ownership

`src/blackmoor_app.mm` (pointer feed, `prepare_native_session_tick`, scene-replacement hook; no refactors), `src/scene_executor.[ch]`, `src/scene_session.[ch]`, `src/session_bindings_a62.[ch]` (only the accept call site), `tests/test_scene_executor.py`, `tests/test_scene_session.py`, `tests/test_native_app.py`, new tests, the build script module list, `work/analysis/slices/RT-6.*`. Read-only: `session_input`, `session_exit`, kernels, `live_audio`. Propose changes to read-only modules instead.

## Acceptance

Failing tests first (executor-level overlap/first-hit, one-candidate invariant, double click, session replacement reset). Existing suites keep their baseline results (build the per-module libraries first), warning-clean under `-Wall -Wextra -Wpedantic -Werror`. Mutation check on the new executor/session logic and an ASan/UBSan run. Handoff `work/analysis/slices/RT-6.handoff.json` with commit, baseline, files, commands, results, hashes and an unverified list. Never modify GAME.EXE or the install. Commit only owned files; end messages with `Co-Authored-By: Claude Sonnet <noreply@anthropic.com>`.
