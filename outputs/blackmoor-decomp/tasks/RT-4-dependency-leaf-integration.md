# RT-4: integrate the recovered dependency leaves (opcodes 11-15, 17, 20, 21) into the live session

Branch: `claude/rt-4-dependency-leaves`, from root's `claude/hungry-matsumoto-8ab8eb` after RT-3 is collected. Owner: a `slice-implementer`.

## Where the live game stops

After RT-3 the scripted run (`--inspect-live-session --live-click-row 34`) reaches S5907 and stops at `scene_session_blocked ... provider=dependency-provider action=6 type=0x9f detail=6`: that row's dependency tree contains opcode 17 and `scene_conditions` evaluates only opcodes 0-6, 9 and the tree markers. The leaf kernel `src/condition_extra.[ch]` (S06-2, reviewed, original-oracle checked on 390 leaf comparisons) already implements opcodes 11, 12, 13, 14, 15, 17, 20 and 21 but is not wired into tree evaluation or the session. In the current corpus the nested-action leaves are op11:1, op13:66, op15:1, op17:23, so this unblocks many scenes, not just one.

Read: `work/analysis/slices/S06-2-condition-extra-recovery-20261013.md` (truth tables, address windows, sound-query boundary), `src/condition_extra.h`, `src/scene_conditions.[ch]`, `src/scene_dependencies.[ch]`, `src/scene_executor.c` (how a tree is evaluated and reset per row, `scene_conditions_reset`), `src/scene_session.[ch]`, `src/world_clock.h` (the timer records opcodes 13/14 read), `src/live_audio.h`, and the RT-3 handoff for the executor/session hooks it added.

## Outcome

1. Evaluate the S06-2 leaves inside the same tree reduction the executor already runs, with the exact source-order effects: the selected-item leaf's executor+0x614 mode and the owning-root +0x24 slot (opcode 11), the per-leaf valid flag and persisted random sample (opcode 20, raw MSVC `rand()` 0..32767 then `% 100`; the app must supply a source-faithful generator, not `arc4random`; document the CRT LCG you choose and that its seed is unproven), the post-tree store `0x5c3a47 = (tree result == 0)` by the wrapper at 0x423f57 (opcode 21 reads it), reset behaviour at 0x423d33.. (clears opcode-20 valid), and the timer-record reads for opcodes 13/14 from the live `WorldInitState`.
2. Bind opcode 17's sound query (original 0x4f6334) to the live audio provider through `ConditionExtraSoundQueryFn`. The helper's full boundary, including its sound-manager mutations, is described in the recovery note; implement what is proven, and return `HOST_UNAVAILABLE` for anything not, never a default false.
3. Give the session a typed provider for the evaluation mode word (`evaluation_mode_614`) and `context_58c94f` with sourced values or an explicit unavailable.
4. Re-run the live script, report the new stop, and keep going only while the next blocker is inside this slice's scope.

## Ownership

You may edit `src/scene_conditions.[ch]`, `src/scene_dependencies.[ch]` if the tree walk lives there, `src/scene_executor.[ch]` / `src/scene_session.[ch]` for the integration, new `src/session_bindings_conditions.[ch]` for app-side providers, `src/blackmoor_app.mm` only to register providers (no refactors), the module list in `scripts/build_native_app.sh`, tests, and `work/analysis/slices/RT-4.*`. `condition_extra`, `world_clock`, `live_audio`, `action_*` are read-only; propose changes instead. Do not touch pointer input (RT-2) or the 0x28 effect path.

## Acceptance

- Failing tests first: tree-level cases for every leaf (including nested AND/OR with `or_after`, the executor+0x614 modes, opcode-20 persistence across ticks and its reset, opcode-21 after a tree, opcode 17 with a fake and the real offline audio host). Extend the existing original dependency oracle (`tests/dependency_original_oracle.py`, `tests/conditions_nested_original_oracle.py`) so whole-tree results for the 58 nested corpus actions are compared against the original under Unicorn, with enumerated hooks only for OS/host boundaries. The S06-2 note says there are zero native whole-tree comparisons today; closing that is part of this slice.
- Mutation check and an ASan/UBSan run on bounded malformed trees.
- Existing suites still pass (build the per-module libraries first; run `python3 -m unittest discover -s tests`). Warning-clean under `-Wall -Wextra -Wpedantic -Werror`.
- Handoff `work/analysis/slices/RT-4.handoff.json`: commit, baseline, files, commands, results, hashes, hooks, unverified list, and the new live stop. Never modify GAME.EXE or the install. Commit only owned files; end messages with `Co-Authored-By: Claude Sonnet <noreply@anthropic.com>`.
