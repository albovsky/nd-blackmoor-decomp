# RT-46: raw 0x33 secondary video with hotspots

Owner thread: Claude Sonnet (cloud). Follows RT-44 (PR 108), whose handoff left raw 0x33 open (3 scenes, 678 asm lines in the arm's method). Raw 0x33 is the only type without a handler in those 3 scenes (`scene-action-coverage.json`). Pattern: RT-36 (raw 0x2d, PR 102) for the media host ops, RT-44 for the oracle shape (real dispatcher 0x427a50, gate mode 1) and the binding.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

Recovered from the disassembly (`llvm-objdump -d -M intel`); the full map of the handler, its pure callees and the body layout is the comment at the top of `src/action_family_33_runtime.h`.

* Loader arm `0x40c186` (A-33.1, `src/action_family_33.[ch]`): body = 113 + 6 * count_6d + 66 * count_6f bytes, then the generic 16-byte dependency records.
* Dispatcher arm of `0x427a50`: gate `0x423f57(deps, 1)`, then `0x42c221(row word)`.
* Pure callees ported with the handler: `0x42ca22` (event flags), `0x42e72c` (page flip), `0x42d215` (frame advance), `0x42caa8` + `0x42cecd` (hotspot rectangles and request cells). Saved-scene push `0x42e560` is `scene_stack_push` (RT-28), reached here as host op `A33_OP_PUSH_SCENE`.
* Host ops (media, threads, surfaces, stream lock, tick): `A33Op` in the header, one per original call in the original order. The reader thread proc `0x44cde2` is host behaviour (`src/avf_player.[ch]`, SECONDARY_VIDEO); the app has no media backend yet, so phase 0 is refused as UNSUPPORTED in the app (as RT-36).
* Debug flag `0x63a4cd` is modelled as 0.

## Native implementation

* `src/action_family_33_runtime.[ch]`: parser, `A33State` (the process globals), `a33_step` (phases 0, 1, 2 and the callees).
* `src/session_bindings_a33.[ch]`: binding (PENDING with the kernel's phase; phase 2 requests the scene change, then COMPLETED), the pre-gate request clear, the pointer-cascade row (request dword + rectangle words).
* `src/blackmoor_app.mm`: `bindings[40]`, declared count 41 (renumbered at merge if RT-45 lands first); module trio in `scripts/build_native_app.sh`; `scripts/build_action_family_33_runtime.sh`.

## Verification

Unit: `tests/action_family_33_runtime_test.c`, `tests/test_action_family_33_runtime.py` (plain, sanitizers, source mutants). Oracle: `tests/action_family_33_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher with raw 0x33 rows built by the real loader, the pure callees run as original x86, every media call a hook that maps to one `A33Op`.
