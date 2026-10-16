# RT-37: raw 0x65 SAVE_CONTINUE, raw 0x68 start timer, raw 0x69 clear timer

Owner thread: Claude Sonnet (cloud). Follows RT-34/RT-35. After PR 99, 1,999 of 2,078 scenes had every action type handled. By scenes unblocked the next ranked types (raw 0x2d excluded, RT-36 owns it) were 0x65 (6), 0x69 (5), 0x4b (5), 0x1b (4), 0x7d (4); 0x68 shares one clear routine with 0x69 and is a three-line arm, so 0x65, 0x68 and 0x69 land together: +14 scenes (1,999 to 2,013). Raw 0x45 (9 scenes, 32 records) operates on the same timer table with seven sub-cases and is the next family on it.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arms `0x40d116` (0x65), `0x40d364` (0x68), `0x40d428` (0x69) of `0x40b34a` (A-65.1, A-68.1, A-69.1): one byte is copied into a 1-byte allocation; the dependency tail follows. `src/scene_resource.c` already registers the one-byte bodies.
* Dispatcher `0x427a50`, all three arms use gate mode 0 (`0x423f57(deps, 0)`):
  * 0x65, arm `0x4285fd`: for a true gate `ecx = 0x5e2e70; push 0; push 0x545630 ("SAVE CONTINUE"); call 0x4d7a15` (the whole-game save writer, `ret 8`), then the completion byte `[0x5bb625 + row * 0x8d] := 1` (`0x42863f`). The result is ignored; the body byte is never read.
  * 0x68, arm `0x4286d8`: `n = (unsigned byte) body[0]`; `0x433bd2(0x585d65 + n * 0x106)`; `dword [0x585d65 + n * 0x106] := 1` (`0x428744`); completion byte := 1 (`0x428751`).
  * 0x69, arm `0x42875d`: `0x433bd2(0x585d65 + n * 0x106)`; completion byte := 1 (`0x4287c0`).
  * The generic completion `0x42ba3a` and the dependency reset `0x423d33` never run and the phase word is not written, whatever the subtype: executor disposition `DIRECT_COMPLETED` with the phase it was given.
* `0x433bd2`: zeroes the 0x106 bytes (0x41 dwords and a word), stores 0xffff in the ten words at `+0xde + 4k`, copies the string `NO SOUND` (NUL included) to `+0x28`. The table at `0x585d65` is the world's timer record table (`WorldInitState.time_records_585d65`, 10 records of 262 bytes; `0x4246bb` and the clock read `+0` as the state and `+4` as the elapsed time). 0x68 therefore starts a timer (state 1), 0x69 clears one.
* Corpus (decoded scene resources): 21 scenes, 24 rows, all subtype 1: 7 x 0x65 (body byte always 0, no tail), 10 x 0x68 (timers 1..8, 3 with a dependency tail), 7 x 0x69 (timers 3, 4, 6).

## Native implementation

`src/session_bindings_a65_a68_a69.[ch]`: one binding object, three executor handlers (`session_a65_handler`, `session_a68_handler`, `session_a69_handler`, each `DIRECT_COMPLETED`, phase unchanged) and the clear kernel `session_timer_record_clear` (0x433bd2). Two required host callbacks: `time_record(index)` returns the authoritative record (the app passes `new_game.view.time_records_585d65`, NULL past the 10 records) and `save_game(name, report_failure)` is the save routine boundary. A missing callback is UNSUPPORTED before any effect. Registration `bindings[30..32]` in `src/blackmoor_app.mm` (count 33, provider ACTION_KERNEL), `scripts/build_action_family_65_68_69_runtime.sh`, module added to `scripts/build_native_app.sh`.

## Verification

* `tests/action_family_65_68_69_runtime_test.c`: 5 unit cases (ASan/UBSan clean), 20 unit mutants caught (`tests/test_action_family_65_68_69_runtime.py`).
* `tests/action_family_65_68_69_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` runs the rows under Unicorn against the native binding (138 scenarios, 356 dispatcher calls, 2,024 rows visited: the 24 real rows with and without a stand-in dependency record, every subtype, all ten timers for 0x68 and 0x69, ordering on one record, gates behind event records, a false gate, world mode 4, offset rows, re-arm, 60 random scenarios). Compared after every tick: which rows entered each arm and ran its effect (observed `0x433bd2` / `0x4d7a15` entries, in order) against the open-row and gate model; for 0x65 that the save call received ECX `0x5e2e70`, the 14 bytes `SAVE CONTINUE\0` and 0; the native effect log; every byte of the original's timer records (randomly pre-filled) against a model that applies the native clear kernel, and the native host's ten records against the same model; completion byte and phase of every row, and that `0x42ba3a` and `0x423d33` never ran. 0 mismatches, 26 of 26 native mutants caught. The result JSON is private (`work/analysis/slices/RT-37.oracle-result.json`).
* `tests/action_family_65_68_69_runtime_corpus.c`: all 24 corpus rows run through the binding. `tests/action_family_65_68_69_runtime_executor.c` (run by `test_action_family_65_68_69_runtime.py`): the production scene executor drives synthetic rows (a gated start, a subtype-2 clear, a save) with the real binding; one executor mutant caught.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud; the new functions were only syntax-checked on a mock.
* The save routine `0x4d7a15` (the game state it writes, the file naming) is NOT ported: the app's save callback logs the request and persists nothing, so the Continue entry has no file to load. The oracle replaces `0x4d7a15` by a recorder.
* One native safety difference: a 0x68/0x69 body byte of 10 or more indexes a record past the port's table; the original clears that record anyway (the oracle checks it against the model over 8 such indexes), the native binding refuses UNSUPPORTED before any effect. The corpus uses 1..8.
* Readers of the timer table (condition leaves, the clock, the task list UI) belong to other slices; this slice only writes the records they read. The oracle builds the rows in memory (the scene loader `0x40b34a` is not run); the 3 corpus 0x68 rows with a dependency tail are replayed behind stand-in records.
* Debug flag `0x63a4cd` is modelled as 0.
