# RT-21: raw 0xa1 "Sound" runtime (S6408 row 4), the tutorial's next stop

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-19-a78-runtime` (43c790b, RT-13..RT-19). After RT-19 the tutorial chain stops at `scene_session_blocked stage=3 provider=action-kernel action=4 type=0xa1 detail=1` (S6408 row 4). Raw 0xa1 is typed 84 bytes (key form) or 51+n bytes (inline form), 565 corpus rows, subtype 1 only.

## What exists

- A-A1.1 (`src/action_family_a1.[ch]`, `work/analysis/slices/A-A1.1*`): decoder and oracle-verified constructor image (loader arm `0x40f069` shared with raw 0x9f, constructor `0x410f99`; runtime type stays 0xa1, text selector at body +0x31).
- RT-8 (`src/action_family_97_runtime.[ch]`, `src/session_bindings_a97.[ch]`): the lifecycle visit `0x432d1a(row, 1, 0)` of the runtime 0x9f sound object, fed by the app's live-audio provider; it only accepts event field `+0xa5 == -1` (the raw-97 constructor default).
- The dispatcher maps runtime 0xa1 and runtime 0x9f to the same arm `0x4297be` (jump table `0x42a9b4`, byte map `0x42aba4`).

## Outcome

1. Recover from the bytes what raw 0xa1 changes against 0x9f/0x97 at runtime (the object's event word `+0xa5` and value byte `+0xa7` come from body `+0x2e`/`+0x30`; effects of a non-default event id on phase 0 and on the direct-completion test), survey the 565 rows (event ids, scene transitions, channels, text kinds) and the rows of the tutorial scenes S6408/S6409.
2. Implement the visit by extending the RT-8 lifecycle only where evidence requires (event store through a typed host callback, direct-completion predicate), no second sound engine; a loader-order binding that builds each 0xa1 object once per scene from the A-A1.1 constructor (AUTOTEXT resolved at construction, as the original does) and serves the executor; register in `blackmoor_app.mm` and `scripts/build_native_app.sh`.
3. Original-x86 oracle (Unicorn, enumerated hooks, ordered effect log including the event table), decoys, a mutation check that runs oracle and native tests, ASan/UBSan on bounded malformed input.
4. Live (production build): the chain recorded in `work/analysis/slices/RT-19.live-final.log` passes S6408 row 4; report the next stop, offline audio only. `--live-click-row 34` unchanged.

## Ownership
New RT-21 files (`src/action_family_a1_runtime.[ch]`, `src/session_bindings_aa1.[ch]`, `scripts/build_action_family_a1_runtime.sh`, tests/oracles), minimal edits to `src/action_family_97_runtime.[ch]` (shared visit), `src/scene_executor.c` (false-gate subtype-2 branch of the shared arm), `src/blackmoor_app.mm` (small, localized), `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_record_playable_status.py` (type constants only). Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-21.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device. Number RT-20 belongs to another thread.

## Acceptance
Failing tests first; addresses cited; unverified listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice (after `build_action_family_28.sh`, `_97.sh`, `build_condition_extra.sh`, `build_world_clock.sh` once, then `scripts/build_native_app.sh`); `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-21.handoff.json`. Commit early and often; no push.
