# RT-15: raw 0x17 "multiframe scene hotspot" runtime (S6401 row 6), the tutorial's next stop

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-14-static-overlay` (RT-14, raw 0x36 overlays, not yet on `main`). Owner bug report (Glib, real window, 2026-10-14): the tutorial is not clickable; RT-13 (0x79) and RT-14 (0x36) moved the stop forward. The Next button of S6400 (overlay row 17) now reaches S6401, which blocks at row 6.

## The stop

`BlackmoorNative --inspect-live-session --live-click-row 32 --live-scene-row 6400:17 --live-ticks 3000 --log <new path>` ends with `scene_session_blocked stage=3 provider=action-kernel action=6 type=0x17 detail=1`. S6401 row 6 is raw 0x17, "MF HS scene - gallery -> main gallery" (typed 112 bytes, five frame records, three dependency records, subtype 1). Decoder: A-17.1 (`src/action_family_17.[ch]`, merged). Raw 0x16 (decoder A-16.1) shares the loader arm 0x40b98f and, as recovered here, the runtime handler.

## Recovered so far (to be confirmed against the disassembly in the evidence files)

- Dispatcher `0x427a50`: runtime type 0x16 -> arm `0x427bdd` (gate `0x423f57` mode 1), types 0x17/0x18/0x19 -> arm `0x427c15` (mode 0); both call the handler `0x42b07e(row)`.
- `0x42b07e`: phase 0 stores `0x5bb1ca := 1` and phase := 1 and falls into phase 1. Phase 1 clears the row request dword (`0x5bb626`) and scans the 18-byte records at body+22 (count = signed word at body+0x14) for the first whose word 0 equals the selector `0x5bb50b`; a hit sets the request dword to 1 and copies record words +2/+6/+10/+14 into the row rectangle words `0x5bb62a/2c/2e/30` (left, top, right, bottom). Phase 2 stores the completion byte (`0x5bb625`) directly and copies the 20-byte prefix into the scene-change cells exactly as the `0x0a` arm does, then sets `0x583999 := 4`.
- The hit is found by the generic row loop of the pointer cascade `0x4f0059` (the request dword and rectangle words are the same cells RT-6 already scans); the candidate is accepted by the `0x43bfb6` block like every row type. Hover cursor: `0x4f1ff3` (types 0x17..0x19) selects cursor index `0x40b2d0(type)`; type 0x16 takes the default path.

## Outcome

1. Pure kernel `src/action_family_17_runtime.[ch]` (state in, ordered effects out), executor binding `src/session_bindings_a17.[ch]` (handler, pre-gate request clear, pointer row export, scene-change request), registered in `blackmoor_app.mm` and `scripts/build_native_app.sh`. Types 0x16, 0x17, 0x18, 0x19 share the code; only 0x17 is required and verified live.
2. Original-x86 oracles (Unicorn, enumerated hooks, ordered effect log): the dispatcher arms with the real handler, the cursor-index function `0x40b2d0`, and the hit/cursor fragment of the cascade. Decoy cases, a mutation check that runs the oracle and the binding tests, ASan/UBSan on bounded malformed input.
3. Live: S6401 no longer blocks at row 6; a scripted click on the hotspot (`--live-scene-row 6401:6`) does what the original does; report the next stop. `--live-click-row 34` unchanged.

## Ownership
New `src/action_family_17_runtime.[ch]`, `src/session_bindings_a17.[ch]`, `scripts/build_action_family_17_runtime.sh`, tests/oracles. Minimal edits to `src/blackmoor_app.mm`, `scripts/build_native_app.sh`, `tests/test_native_app.py`. Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-15.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
Failing tests first; addresses cited; unverified listed; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice; `-Wall -Wextra -Wpedantic -Werror`; handoff `work/analysis/slices/RT-15.handoff.json`. Commit early and often; no push.
