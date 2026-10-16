# RT-30: raw 0x67 start-flag runtime

Owner thread: Claude Sonnet (cloud). Follows RT-23 to RT-28. Raw 0x67 was the top remaining type in `scene-action-coverage.json` after RT-28 by scenes unblocked: 25 scenes, 27 records, 24 scenes where it is the only missing type. It touches no game state except one process-wide flag.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40d29f` of `0x40b34a` (A-67.1): one byte is copied into a 1-byte allocation; the dependency tail follows. The byte is never read afterwards. `src/scene_resource.c` already registers the one-byte body (`known_body_length`).
* Dispatcher arm `0x428692` of `0x427a50`: `0x423f57(deps, 0)` (gate mode 0, the default). For a true gate: `dword [0x5bb1ca] := 1` (`0x4286b5`), then the row's completion byte `[0x5bb625 + row * 0x8d] := 1` directly (`0x4286cc`). The generic completion `0x42ba3a` and the dependency reset `0x423d33` never run, whatever the subtype, and the phase word is not written: the executor disposition is `DIRECT_COMPLETED` with the phase it was given. A false gate changes nothing.
* `0x5bb1ca` is the process-wide start flag the other row handlers already write (0x0b, 0x0c, 0x17, 0x3f, 0x62 in this repo; the frame step `0x43a7ca` and others read it). It is stored, not or-ed: any previous value becomes 1.
* Corpus (decoded scene resources): 25 scenes, 27 rows, all subtype 1, body byte always 0, no dependency record on any row (A-67.1 census, re-run by the corpus driver).

## Native implementation

`src/session_bindings_a67.[ch]` (executor handler: `DIRECT_COMPLETED`, phase unchanged; the flag sink is a required host callback, `UNSUPPORTED` before any effect without it), registration `bindings[22]` in `src/blackmoor_app.mm` (count 23, provider ACTION_KERNEL; the gate mode is the default 0; the host callback writes `app->start_flag_5bb1ca`, the same variable the 0x62 callback writes), `scripts/build_action_family_67_runtime.sh`, module added to `scripts/build_native_app.sh`.

## Verification

* `tests/action_family_67_runtime_test.c`: 3 unit cases (ASan/UBSan clean), 9 unit mutants caught (`tests/test_action_family_67_runtime.py`).
* `tests/action_family_67_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` runs 0x67 rows under Unicorn against the native binding (91 scenarios: the 27 real bodies with and without a stand-in dependency record, subtypes 0..4/255, every body byte class one row at a time, gates behind event records, a false gate, world mode 4, offset rows, re-arm, initial flag values 0, 1, 2, 7, 0x7fffffff, 0x80000000, 0xffffffff, 60 random scenarios), compared after every tick: which rows entered the arm (observed 0x428692) and which stored the flag (observed 0x4286b5) against the open-row and gate model, completion byte and phase of every row, that `0x42ba3a` and `0x423d33` never ran, and the dword at `0x5bb1ca` against the native flag. 13 of 13 native mutants caught.
* `tests/action_family_67_runtime_corpus.c`: all 27 corpus rows run through the binding. `tests/action_family_67_runtime_executor.c` (run by `test_action_family_67_runtime.py`): the production scene executor drives synthetic 0x67 rows (gate on an event flag, DIRECT_COMPLETED bookkeeping, no revisit) with the real binding; one executor mutant caught.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* Whoever reads `0x5bb1ca` afterwards is host behaviour: in this app the flag is shared with the other families' worlds (copied in and out around their kernels), and what the frame step does with it (`0x43a7ca` conditional reads at `0x43b53b`, `0x43b740`, `0x43b871`, `0x43b961`) is not modelled by this slice.
* The oracle builds the row in memory (the scene loader `0x40b34a` is not run) and replays the 27 corpus rows with and without a stand-in dependency record; real corpus rows carry none.
* Debug flag `0x63a4cd` is modelled as 0.
