# RT-16: raw 0x0b "scene change" hotspot runtime (S6403 row 2), the tutorial's next stop

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-15-a17-runtime` (RT-15, raw 0x16/0x17, commit 5fe3511). The tutorial chain `--live-click-row 32 --live-scene-row 6400:17 --live-scene-row 6401:6 --live-scene-row 6402:3 --test-selector 6401:4` now reaches S6403 and blocks at `scene_session_blocked stage=3 provider=action-kernel action=2 type=0x0b detail=1`. S6403 row 2 is raw 0x0b (typed 24 bytes, no dependency record), target 6404, body words 9/4/1, rectangle 1,325,619,374. Raw 0x0b is the main navigation hotspot family (1,275 corpus rows).

## Recovered so far (to be confirmed against the disassembly in the evidence files)

- Loader arm `0x40b7d4` (jump table `0x410ca4`, byte map `0x410e9c`, type 0x0b only) builds a 0x28-byte payload: word0 -> +0 (cursor word), body+2 -> +2 (target), body+4 -> +4, body+6 -> +8, the four rectangle dwords body+8..+23 -> +0x18..+0x27; then +6 := 0, +0xa := 0, +0xe := 0, +0x12 := 1, word +0x16 := 0.
- Dispatcher arm `0x427ba4` (map `0x42aba4`, table `0x42a9b4`): gate `0x423f57` mode 1, then handler `0x42ae73(row)`. The same handler serves runtime 0x0d (arm `0x427b33`, mode 1) and 0x0e..0x14 (arm `0x427b6b`, mode 0). Raw 0x15 is the loader's wrapper for those types (arm `0x40b5f1`), the existing executor approximation.
- Handler `0x42ae73`: phase 0 stores `0x5bb1ca := 1`, the four rectangle words from payload +0x18/+0x1c/+0x20/+0x24, phase := 1, falls into phase 1; phase 1 sets request := 1 when payload word +0x16 (loader: 0) equals the selector `0x5bb50b`, else request := 0; phase 2 sets the completion byte directly, copies payload +2, +4, +6, +8, +0xa, +0xe, +0x12 into the scene-change cells `0x5bb57b`, `0x5bb599`, `0x5bb595`, `0x5c39ff`, `0x5bb59b`, `0x5bb59f`, `0x5bb5a3` and stores `0x583999 := 4`.
- Pointer: the generic row loop `0x4f1f16..` (request dword nonzero, inclusive rectangle) hits the row; the type-specific hover cursor is case `0x4f221e` (type 0x0b): payload word 0 is the cursor index, taken verbatim when no item is held, or when 3 < word < 0x1b with an item held (then `0x5b44f8 := 1`).
- The executor's 0x15 approximation compares the video's current frame with 0; the original compares the selector `0x5bb50b` with the payload frame word.

## Outcome

1. Pure kernel `src/action_family_0b_runtime.[ch]` (payload loader, handler step with ordered effects, hover cursor) built on the RT-15 cell/effect types, binding `src/session_bindings_a0b.[ch]` (handler, pre-gate request clear, pointer-row export, scene-change request) with the RT-15 host, registered in `blackmoor_app.mm` and `scripts/build_native_app.sh`.
2. Original-x86 oracles (Unicorn, enumerated hooks, ordered effect log): the loader arm `0x40b7d4`, the dispatcher arm with the real handler and gate, the hover cursor case of the cascade; decoys, 1500+ multi-row sequences, a mutation check that runs the oracle and the binding tests, ASan/UBSan on bounded malformed input.
3. Live: S6403 no longer blocks at row 2; a scripted click on its hotspot (`--live-scene-row 6403:2`) reaches S6404; report the next stop. `--live-click-row 34` unchanged.

## Ownership
New `src/action_family_0b_runtime.[ch]`, `src/session_bindings_a0b.[ch]`, `scripts/build_action_family_0b_runtime.sh`, tests/oracles. Minimal edits to `src/blackmoor_app.mm`, `scripts/build_native_app.sh`, `tests/test_native_app.py`. Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-16.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
Failing tests first; addresses cited; unverified listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice; `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-16.handoff.json`. Commit early and often; no push.
