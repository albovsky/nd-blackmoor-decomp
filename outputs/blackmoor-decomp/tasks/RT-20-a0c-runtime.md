# RT-20: raw 0x0c runtime (S2010 row 5), the next stop after RT-12

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-12-a83-final` (RT-12, raw 0x83 runtime, commit 130f250).

## Where the live game stops

`--inspect-live-session --live-click-row 34 --live-ticks 3000 --rand-seed 1` (offline audio, no window, no computer use) now passes S4808 (the 0x83 phone-list rows apply) and hands over to S2010 (13 actions). It stops at `scene_session_blocked stage=3 provider=action-kernel action=5 type=0x0c detail=1 effects_before_block=2` and `session_frozen scene=2010 generation=24 row=5 type=0x0c ... "action type 0x0c at row 5 has no native runtime yet"`.

## What exists

A-0C.1 (`src/action_family_0c.[ch]`, `tasks/A-0C-action-0c.md`, `work/analysis/slices/A-0C.*`): typed body decoder for raw 0x0c, 43 corpus records, merged. The runtime was never recovered. Do not re-decode the body; build on the merged module. Loader arm and dispatcher arm are listed in the A-0C.1 evidence; find the runtime handler through the dispatcher `0x427a50` and trace it with REA/Ghidra and the original bytes (local REA skill: `work/tools/rea/node_modules/rea-agents/skills/reverse-engineer-anything/SKILL.md`).

## Outcome

1. Recover the 0x0c runtime handler (gate, phases, completion byte, every global/cell it reads or writes, host effects such as sound, caption, scene change, hotspot request) with cited addresses. Say what the corpus rows at S2010 row 5 (and the 43 corpus rows overall) select, prove every branch the corpus reaches against the original, list the ones it does not.
2. Implement a pure kernel `src/action_family_0c_runtime.[ch]` and binding `src/session_bindings_a0c.[ch]` following `session_bindings_a83.[ch]`, `session_bindings_a0b.[ch]`, `session_bindings_a17.[ch]` (reuse existing cell/effect/host types); unbound providers report UNSUPPORTED before any effect, never default an unknown input to zero.
3. Original-x86 oracle (Unicorn, every hook enumerated, ordered effect log compared with the original's hook order), decoy scenarios, multi-row sequences, a mutation check that runs the oracle and the binding tests, ASan/UBSan on bounded malformed input. Cover binding-level selection wiring, host failure paths and effect order from the start (RT-8/RT-12 review lessons).
4. Register in `src/blackmoor_app.mm` (bindings array, minimal) and `scripts/build_native_app.sh`; update live-stop pins in tests only as far as the new stop requires.
5. Rerun the headless live run, report the new stop (scene, row, raw type, provider, log lines). Every unproven step is an explicit named blocker.

## Ownership

New `src/action_family_0c_runtime.[ch]`, `src/session_bindings_a0c.[ch]`, `scripts/build_action_family_0c_runtime.sh`, tests/oracles. Minimal edits to `src/blackmoor_app.mm`, `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_scene_session.py`. Not `scene_resource.c`, other families' kernels, the tutorial click path (RT-13/14/15/16/17/18 area: raw 0x79, 0x36, 0x37, 0x16/0x17, 0x0b, navigation), opaque decoders, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-20.*`. Never modify `work/original`, the GOG install or GAME.EXE.

## Acceptance

Failing tests first, baseline recorded; addresses cited; unverified items listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice (run the build_action_family_28/_97/build_condition_extra/build_world_clock scripts once in a fresh worktree); `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-20.handoff.json` (commit, baseline, files, commands, results, hashes, unverified list, new live stop). Commit early and often (commit after each green piece); no push.
