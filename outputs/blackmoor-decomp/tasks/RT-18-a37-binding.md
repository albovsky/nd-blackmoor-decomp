# RT-18: bind raw 0x37 "Static overlay" rows to the COverlay runtime (S6452 row 0, the tutorial's next stop)

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-16-a0b-runtime` (52ff897, contains RT-13/14/15/16). After RT-16 the tutorial chain stops at S6452 row 0: `scene_session_blocked stage=3 provider=action-kernel action=0 type=0x37 detail=1`.

## What exists

- Raw 0x37 loader arm `0x40c446` calls the constructor `0x4895cc` (A-37.2, `src/action_family_37.[ch]`) and then stores the row type `0x36` (`0x40c47b`), exactly like raw 0x36 (arm `0x40c3dd`..`0x40c3fa` -> `0x488e9c`) and raw 0x38 (arm `0x40c404`, `0x48905b`). All three feed the dispatcher arm `0x4280b4` and `COverlay::Process` `0x4899ca`, which RT-14 recovered and ported (`src/action_family_36_runtime.[ch]`, `src/session_bindings_a36.[ch]`, oracle `tests/action_family_36_runtime_original_oracle.py`).
- The executor and session discriminate by the raw type (`SceneActionInfo.type`), and the RT-14 binding only claims raw 0x36.

## Outcome

1. Recover from the original what differs between the 0x37 and the 0x36 image (constructor defaults `0x48945b`: marker +0x29 = 1, event index +0x39 = 0xffff, expected +0x3b = 0, option +0x25 = 2, flag +0x21 = 2, sound +0x79 "NO SOUND", one primary and one secondary record with hot word 2, nothing written outside the 0xABA zeroed allocation), whether a 0x37 row can be hit-tested at all, what draws it, and which Process arms it reaches. Corpus survey: all 4,308 raw 0x37 rows (layers 10/11, plain or keyed blit, never AUTOTEXT, never a sound name, never marker 2); the tutorial rows (S6405..S6409 TUT_Next_OVL / BLU_AlarmClock_OVL / BLU_ToBedSideB_OVL, S6452).
2. Bind raw 0x37 rows to the RT-14 kernel: constructor image from `action_family_37_construct`, handler for runtime type 0x36 reached by raw type 0x37, the executor's dependency gate mode for the row (original runtime type 0x36 -> mode 1; `0x40c47b`), and the app registration/logging. Raw 0x36 stays bit-identical; raw 0x38 stays unbound (explicit unsupported stop).
3. Unsupported variants (a name that selects AUTOTEXT surfaces, a sound name, marker 2 in a 0x37 image if one ever occurs) are rejected explicitly and listed, never drawn wrong.
4. Oracle: original-x86 (Unicorn). The original constructor `0x4895cc` builds the image inside the RT-14 harness machine; the native binding image is compared with it byte for byte; then registration (`0x4899ca` phases 0/1/2), the hit test `0x4897cd`, the draw callback `0x48a3db` and the finish helper run on those images with the RT-14 hook set, comparing state and ordered effects after every step. Mutation check running the oracle and the native tests; ASan/UBSan driver.
5. Live (test-hooks build): the tutorial chain from RT-16 passes S6452 row 0; follow the next stops while each fix is small and describe a large one (row, type, provider, needs).
6. `--live-click-row 34` unchanged.

## Ownership
New RT-18 files (`tests/test_action_family_37_runtime.py`, `tests/action_family_37_runtime_original_oracle.py`, sanitizer driver, mutation check), `scripts/build_action_family_36_runtime.sh` only if sources change, minimal edits to `src/action_family_36_runtime.[ch]`, `src/session_bindings_a36.[ch]`, `src/scene_executor.c` (gate type only), `src/blackmoor_app.mm` (small, localized: RT-17 edits the pointer code), `tests/test_native_app.py`. Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-18.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
Failing tests first; addresses cited; unverified listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice (after `build_action_family_28.sh`, `_97.sh`, `build_condition_extra.sh`, `build_world_clock.sh` once); `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-18.handoff.json`. Commit early and often; no push.
