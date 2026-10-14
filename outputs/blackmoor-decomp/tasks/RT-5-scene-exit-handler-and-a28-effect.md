# RT-5: the scene exit handler (0x43d227) and the queued 0x28 effect

Branch: `claude/rt-5-scene-exit`, from root's `claude/hungry-matsumoto-8ab8eb`. Owner: a `slice-implementer`.

## Why

S5900 row 8 is a `0x28` special effect (37-byte body, effect type 2). RT-3 found that its dispatcher leaf (0x44727a) only queues the payload and later completes the row; the effect itself runs in the exit path: state-4 handler `0x43d227` calls `0x447c36` (at 0x43d69b) before the next scene loads, and the effect continues in the successor's state 3 via `+0x2d`. The RT-3 reviewer judged that the effect belongs to the outgoing scene (S5900 -> S4700 for this row), so the app's `prepare_a28_handoff_frames`, which pairs the *incoming* scene's first 0x28 row with the previous frame, pairs the wrong rows. Binding the leaf alone would silently skip the effect, so the live S5900 pass cannot be correct past row 8 until the exit handler exists.

The same exit/entry functions (`0x43d227`, scene setup `0x4381f4` call at 0x438da7, `0x43dbe3` call at 0x43e1c2) also: call `0x4de2d8` on `0x61f864` (closes the frame text box), reset `0x5b15c8/0x5b15d6/0x5b15da/0x5b1602`, and set `[0x5c39e5] = -1` / `[0x5c39e9] = 0` (the input latch reset RT-2 documents). The native transition currently does none of this except the world clear and a blanket audio unload. RT-3's test deliberately does not pin the missing frame-text close.

## Outcome

Recover from the original bytes (follow `work/tools/rea/node_modules/rea-agents/skills/reverse-engineer-anything/SKILL.md`; Ghidra output is a hint, machine code is the authority) and implement, as testable native code with an original-x86 oracle where the logic is native:

1. The sequence the original runs between "scene change requested" and "next scene's first tick": state 4 handling in `0x43d227`, which of the scene-clear, caption/frame-text, sound, input-latch and action-queue resets run, in what order, and what is deferred to the successor's state 3. Implement the proven subset as a session/app transition routine replacing the current ad-hoc `perform_session_transition` steps (keep the current behaviour for anything unproven and name it).
2. The queued `0x28` effect: bind the `0x44727a` leaf (queue + later completion) in the session and run the effect at the exit boundary using the reviewed A-28 kernels and frame adapters already in the tree (`action_family_28`, `action_family28_surface`, the capture/composition code in `blackmoor_app.mm`), with the correct row and correct source/target frames. Fix `prepare_a28_handoff_frames` pairing (outgoing scene's row, current composed frame as source, successor first frame as target) if the evidence confirms the reviewer's reading. The effect timing, pump and normalization limits recorded in the A-28 receipts (`A-28.3-receipt.json`, `A-28.3.2-sequence-receipt-20261013.json`) still apply; keep the non-bit-exact x87 curve limit explicit.
3. Close the frame text box and reset the caption flags on scene replacement per the proven order (use `caption_scene_reset`; RT-3's 0x51 adapter exists in `src/session_bindings_a51.[ch]`).
4. Re-run the live script. S5900 row 8 should no longer be the stop; report the new stop. Another worker (RT-4) is wiring dependency opcodes at the same time, so S5907 row 6 (opcode 17) may still block first; use `--test-a62-accept` (test-hooks build) to reach row 8 if needed.

## Ownership

You may edit the session/app transition code (`perform_session_transition` and the functions it calls in `src/blackmoor_app.mm`, a new `src/session_exit.[ch]` module preferred for the logic), `src/scene_session.[ch]` and `src/scene_executor.[ch]` for the queue/leaf binding, a new `src/session_bindings_a28.[ch]`, the module list in `scripts/build_native_app.sh`, tests, and `work/analysis/slices/RT-5.*`. Read-only: reviewed kernels (`action_family_*`, `caption_*`, `live_audio`, `macos_*`, `scene_conditions`, `condition_extra`; RT-4 owns conditions; RT-2 owns `session_input`, which you may call but not change). Keep `blackmoor_app.mm` edits minimal and local.

## Acceptance

- Failing tests first. Original-x86 oracle for any routine whose logic you reimplement natively, comparing ordered effects, with enumerated host hooks only.
- Mutation check and ASan/UBSan on bounded inputs; existing suites pass (`python3 -m unittest discover -s tests` after building the per-module libraries); warning-clean under `-Wall -Wextra -Wpedantic -Werror`.
- The live run log shows the new behaviour; native-app tests updated to pin only what is proven.
- Handoff `work/analysis/slices/RT-5.handoff.json` with commit, baseline, files, commands, hashes, hooks, unverified list and the new live stop. Never modify GAME.EXE or the install. Commit only owned files; end messages with `Co-Authored-By: Claude Sonnet <noreply@anthropic.com>`.
