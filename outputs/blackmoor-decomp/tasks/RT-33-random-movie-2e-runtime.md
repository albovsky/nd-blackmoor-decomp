# RT-33: raw 0x2e random-movie control runtime

Owner thread: Claude Sonnet (cloud). Follows RT-30 to RT-31. Raw 0x2e and 0xd1 were next in the `scene-action-coverage.json` ranking after 0x43/0x94 (0x2e: 10 scenes, 10 records, 8 where it is the only missing type; 0xd1: 11 scenes, 11 records, 11 sole). The brief asked for both; 0xd1 is the large one (below), so this slice lands 0x2e alone.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40c114` (A-2E.1): `0x4cd645` copies 15 bytes; the dependency tail follows. `src/action_family_2e.[ch]` already decodes it.
* Dispatcher arm `0x427f62` of `0x427a50`: `0x423f57(deps, 0)` (gate mode 0), then `0x4ced84(row)` on the random-movie object at `0x63821d`.
* Handler `0x4ced84` (the debug text names it `RANDOMMOVIE_ProcessPlayRandomMovie`): stores the row in `+0x242` and the signed body byte in `+0x23a`, then only if `+0x216` (the object is active) is nonzero acts on the mode: 0 = `0x4ceb3b` (the random-movie stop: releases the movie set through `0x4cd218`, which frees heap blocks, destroys a video object and resets the object) and then the same block as mode 1; 1 = `[0x585801 + 4 * sext(word 9)] := sext(word 11)` unless word 9 is -1, then, unless scene word 1 is 9999, the scene-change cells (`0x5bb57b` sext word 1, `0x5bb599` word 3, `0x5bb595` word 5, `0x5c39ff` word 7, `0x5bb59b`/`0x5bb59f` zero, `0x5bb5a3` one, engine mode `0x583999` := 4), then `0x5bb1ca := (word 13 != 1)`, `+0x1de := 2`, `+0x206 := 0`; 2 = `+0x1de := 0` (or `3` and `+0x25a := 0` if `+0x25a` was set), `+0x206 := 1`; other values do nothing. Every path ends with the completion byte of the row at `+0x242` set directly (`0x4cf019`): no `0x42ba3a`, no dependency reset, phase untouched, whatever the subtype.
* `+0x216` is written 1 only by `0x4cd7f4`, inside raw 0x2d (`0x4cd6ff`, not bound yet), so in the running game the object is inactive and a 0x2e row only stores the row and the mode and completes. Corpus (decoded scene resources): 10 rows in 10 scenes, all subtype 1, modes 0 (6 rows), 1 (2), 2 (2); only two scenes (S3336, S4408) also carry a 0x2d row.
* Mode 0 on an active object is the one path not modelled. In the original `0x4ceb3b` resets the object (`0x4ccdab` sets `+0x242 := -1`), so the handler's own final completion store lands at row -1 (`0x5bb598`) and the 0x2e row is revisited on the next pass with the object inactive. That belongs with raw 0x2d (the object model).

## Native implementation

`src/session_bindings_a2e.[ch]` (executor handler: `DIRECT_COMPLETED`, phase unchanged). The object fields it touches live in the binding (`SessionA2EMovie`, `session_a2e_movie/set_movie`, shared with the future 0x2d binding). Providers are needed only on the active paths: the start-flag sink and the transition request for mode 1 (`UNSUPPORTED` before any effect when missing), the borrowed `ActionCoreWorld` event flag table for the variable store (an index outside the table is a handler error before any effect). Active mode 0 is `UNSUPPORTED` before any effect (including the row and mode stores). Registration `bindings[25]` in `src/blackmoor_app.mm` (count 26, provider ACTION_KERNEL), `scripts/build_action_family_2e_runtime.sh`, modules added to `scripts/build_native_app.sh`.

## Verification

* `tests/action_family_2e_runtime_test.c`: 9 unit cases (ASan/UBSan clean) and 17 source mutants caught (`tests/test_action_family_2e_runtime.py`); executor-level case with the production scene executor (`tests/action_family_2e_runtime_executor.c`, 1 executor mutant); corpus run of the 10 decoded rows inactive and active (`tests/action_family_2e_runtime_corpus.c`).
* `tests/action_family_2e_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` and handler `0x4ced84` run 0x2e rows under Unicorn against the native binding: the 10 corpus rows, every body mode byte 0..255, the object inactive and active in eight states (active values 1, 2, 0x100, -1, 0x80000000; `+0x25a` 0, 1, -1, 0x7fffffff), scene word / flag index / value / start-flag word edge values, flag stores that change a later row's gate inside the same pass, the scene change that ends the pass (engine mode 4), the active mode-0 stop, gates, mode 4, offset rows, subtypes and 80 random scenarios. Compared per pass: which rows entered the arm and the handler, every store to the object, the event flag table, the start flag, the scene-change cells and the completion bytes as an ordered list, the request the host received, the whole event table, the object fields, every row's completion byte and phase, that `0x42ba3a` and `0x423d33` never ran, and that nothing else wrote to the object, the row table or the cells. 36 of 36 native mutants caught.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* Active mode 0 (`0x4ceb3b`, the movie set release) and everything raw 0x2d does to the object are not modelled; the object stays inactive in the app.
* The oracle builds rows in memory (the scene loader `0x40b34a` is not run); the 10 corpus rows are replayed without their dependency records (two carry one) and behind a stand-in event record. Frame-step readers of the object (`0x4383ed`, `0x4394fb`) and the readers of the cells the handler writes are host behaviour outside this slice. Debug flag `0x63a4cd` is modelled as 0.

## Why not raw 0xd1 in the same slice

`0xd1` (A-D1.1: 927-byte body, handler `0x4b64a9` on the object at `0x61d449`, gate mode 0) is the Turning Puzzle: a phase 0/1/2 state machine with a six-case inner machine (`+0x274`), a per-tile geometry helper (`0x4b6355`), a process-list slot with the per-frame callback `0x4b7051` (input and drawing through `0x4b70e0..0x4b7229`), a CIFTREE surface load (`0x4c2790` "Turning Puzzle Surface"), sound calls (`0x4fb77a`, `0x4fb2e3`, `0x4fba69`, `0x4f6334`), `GetTickCount` timing and scene/variable transfers at the finish. It is the size of the Mouselight puzzle (RT-24) and needs its own slice and oracle.
