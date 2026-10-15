# RT-12: raw action 0x83 runtime in the live session

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer; one independent `slice-reviewer` afterwards. Base: current `main` (the 0x83 parser layout from A-83.1 is merged, PR 21).

## Where the live game stops

The scripted run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`, offline audio, no window) now plays S0 -> S5900 -> S5907 -> S5901..S5906 -> S4700 (the Bink cinematic, 0x97 rows) -> S4710 -> S4701 -> S4711 -> S4800..S4802 -> S4712 -> S4803..S4807 and stops loading S4808 at row 6, raw type 0x83 (`scene_transition_error ... provider=scene-resource action=6 type=0x83` before PR 21; after it the stop is the missing runtime handler). The corpus has only 9 raw-0x83 rows, so this slice is small but it is the next wall.

## What exists

A-83.1 (`src/action_family_83.[ch]`, `work/analysis/slices/A-83.1-discovery.md`, `A-83.1.handoff.json`): fixed 74-byte typed body (neutral `word_N` fields), loader inline arm `0x40e995..0x40ea5e` (74-byte malloc, 18 DWORD + 1 WORD copy, no field is examined), dependency tail via `0x424aa8` (one corpus row has a 16-byte tail). Runtime: dispatcher `0x427a50` arm `0x4296f8..0x429747`: gate `0x423f57`, handler `0x4e72fb` (calls lookup `0x4e444d` and refresh `0x4e0559`), completion byte `action+0x72 = 1` at `0x42973b`. A-83.1's follow-up children are A-83.2 runtime/lifecycle, A-83.3 dependencies, A-83.4 string/field consumers and rendering/host effects, A-83.5 subtype behaviour (corpus: subtype 1 only). Unresolved there: the handler's word0 zero/nonzero branches were never executed, the release function for the allocation is unidentified, nonzero/reused action slots.

## Outcome

Take the live run past S4808 row 6 as far as the recovered evidence honestly allows:

1. **Recover** the 0x83 runtime (A-83.2 plus the parts of A-83.4 the nine corpus rows need): `0x4e72fb`, `0x4e444d`, `0x4e0559`, what the runtime strings at object +2 / +0x23 name (resource, text, caption, hotspot? check against the nine rows and what scene S4808 does with it), signed field uses, the dependency tail gate for the one row that has one, completion, and any session-visible effect (refresh, event flags, transition, sound, caption). Cite addresses; original-x86 oracle for the lifecycle with every hook enumerated (OS/allocation/host only), as the RT-7/8/9 oracles do. Say what the nine real rows select (word0 branches) and prove every branch the corpus reaches against the original; list the ones it does not.
2. **Implement** `src/action_family_83_runtime.[ch]` and `src/session_bindings_a83.[ch]` following `session_bindings_a35.[ch]`, `session_bindings_a97.[ch]`, `session_bindings_a51.[ch]`; reuse existing providers through typed host callbacks; unbound providers report UNSUPPORTED before any effect.
3. **Register** in `src/blackmoor_app.mm` (bindings array, minimal) and `scripts/build_native_app.sh`.
4. **Drive the live run**, report the new stop row/provider with log lines. Every unproven step is an explicit named blocker; never default an unknown input to zero or skip a row silently. Windows/audio devices are not used; the owner does the window pass.

Use RT-8's review as a checklist for oracle strength: the reviewers found that binding-level selection/RNG wiring, host failure paths, effect ORDER (one merged event log compared against the original's hook order) and the mutation check itself were the weak points. Cover them from the start.

## Ownership

You may edit: new `src/action_family_83_runtime.[ch]`, `src/session_bindings_a83.[ch]`, `scripts/build_action_family_83_runtime.sh`, new tests/oracle files; minimally `src/blackmoor_app.mm`, `src/scene_session.[ch]`, `src/scene_executor.[ch]` (only what evidence requires), `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_scene_session.py`. Do not edit other families' kernels, `scene_resource.c`, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-12.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance

- Failing tests first, baseline recorded; every provider cited to original addresses; unproven items listed.
- `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes; run it twice after a fresh merge (a cached parser library is stale on the first run); build clean under `-Wall -Wextra -Wpedantic -Werror`.
- Mutation check that runs the oracle and the binding tests and kills wrong gate, completion, ordering and selection rules.
- Handoff `work/analysis/slices/RT-12.handoff.json` (commit, baseline, files, commands, results, hashes, unverified list, new live stop). Commit only owned files on your branch, no push; message ends `Co-Authored-By: Codex <noreply@openai.com>`, no model identifiers.
