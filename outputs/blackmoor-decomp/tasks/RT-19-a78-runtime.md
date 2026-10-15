# RT-19: raw 0x78 "Add Inventory Item, No Hot Spot" runtime (S6453 row 4), the tutorial's next stop

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-18-a37-binding` (01ac70e; RT-13..RT-17 via main plus RT-18's raw 0x37 overlay binding). After RT-18 the tutorial chain stops at S6453 row 4: `scene_session_blocked stage=3 provider=action-kernel action=4 type=0x78 detail=1`. Raw 0x78 has 466 corpus rows (typed 6-byte body, 85 without and 381 with dependency records); the parser boundary exists in `scene_resource.c` (case 0x78, loader `0x4e9c2f` advances by 6) and is not edited here.

## What exists

- RT-13 (`src/action_family_79_runtime.[ch]`, `src/session_bindings_a79.[ch]`): the inventory model (held item 0x583a29, signed count word 0x583a2b, item word list 0x583a31, presence dwords 0x583bd5), the item remove step `0x4ea06c` and the view rebuild provider (`0x4e812f`, requested, not modeled). Raw 0x78 is its sibling and shares all of it.
- Recovered by the previous worker, to be confirmed in the bytes: loader arm `0x40e56a` -> constructor `0x4e9c2f` (6-byte object, view `0x571442`); dispatcher arm `0x42944b` (jump table maps runtime 0x78 there, gate `0x423f57` mode 0); handler `0x4eaadc(row)` driving the view methods `0x4e8d96` (return the held item to the list) and `0x4e9e84(item, flag)` (add), `0x4ea06c(item)` (remove).

## Outcome

1. Recover the complete runtime of the row: three body words (item, "take in hand" flag, "swap" flag), the `0x4eaadc` decision tree, `0x4e9e84` (duplicate search, sound request `0x4fb2e3(0x17)` when flag != 0, scratch layout choice by view byte +0x7010 and view dword +0x764c, count/list/presence stores, `0x4e812f`, UI animation `0x4e0559` on `0x570508` outside view mode 2), `0x4e8d96`, completion store.
2. Pure kernel `src/action_family_78_runtime.[ch]` reusing the RT-13 model, remove step and rebuild provider (a small refactor of RT-13 exposes `0x4ea06c` as a function of its own); `src/session_bindings_a78.[ch]` (executor binding, DIRECT_COMPLETED), registered in `blackmoor_app.mm` and `scripts/build_native_app.sh`. The sound request and the UI animation are requests the app logs and reports as not played / not rendered (no effect-sound backend, no UI button table); they never block the session.
3. Original-x86 oracle (Unicorn) with enumerated hooks and an ordered, merged effect log, decoy cases, a mutation check that runs the oracle and the native tests, an ASan/UBSan driver, like RT-13.
4. Live (test-hooks build): `--inspect-live-session --live-click-row 32 --live-scene-row 6400:17 --live-scene-row 6401:6 --live-nav 6401:left --live-scene-row 6402:3 --live-scene-row 6403:2 --live-scene-row 6404:3 --live-scene-row 6451:0 --live-scene-row 6452:1 --live-scene-row 6405:7 --live-ticks 6000 --log <new path>` no longer blocks at S6453 row 4; follow the next stops while each fix is small and describe a large one exactly (row, type, provider, needs). `--live-click-row 34` unchanged.

## Ownership
New RT-19 files (`src/action_family_78_runtime.[ch]`, `src/session_bindings_a78.[ch]`, `scripts/build_action_family_78_runtime.sh`, tests/oracles), minimal edits to `src/action_family_79_runtime.[ch]` (expose the shared remove step), `src/blackmoor_app.mm` (small, localized), `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_record_playable_status.py` (type constants only). Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-19.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
Failing tests first; addresses cited; unverified listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice (after `build_action_family_28.sh`, `_97.sh`, `build_condition_extra.sh`, `build_world_clock.sh` once, then `scripts/build_native_app.sh`); `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-19.handoff.json`. Commit early and often; no push.
