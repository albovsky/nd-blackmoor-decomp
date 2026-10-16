# RT-28: raw 0x6e save-the-running-scene runtime

Owner thread: Claude Sonnet (cloud). Follows RT-23 to RT-27. Raw 0x6e was the top remaining type in `scene-action-coverage.json` after RT-27: 48 scenes, 68 records, 46 scenes where it is the only missing type. It touches game state only (no host provider except the running scene's words).

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40e250` of `0x40b34a` (A-6E.1): one byte is copied into a 1-byte allocation; the dependency tail follows. The byte is never read afterwards.
* Dispatcher arm `0x42916f` of `0x427a50`: `0x423f57(deps, 0)` (gate mode 0, the default), and for a true gate `0x42e560(2)`, then the row's completion byte `[0x5bb625 + row * 0x8d] := 1` directly (`0x4291aa`). The generic completion `0x42ba3a` and the dependency reset `0x423d33` never run, whatever the subtype, and the phase word is not written: the executor disposition is `DIRECT_COMPLETED` with the phase it was given.
* `0x42e560(arg)` (cdecl, 22-byte record at `0x5c3a05`): `[0x5c3a05] := word [0x5bb57b]`, `[0x5c3a07] := word [0x5bb57f]`, `[0x5c3a09] := word [0x5bb50b]`, `[0x5c3a0b] := word [0x5bb593]`, `[0x5c3a0d] := low word of arg`, `[0x5c3a0f] := dword [0x5bb5a7]`, `[0x5c3a13] := dword [0x5bb5ab]` and then `[0x5c3a13] := dword [0x5bb5af]` (the second store wins; `0x5c3a17` is never written by the push). A second push overwrites the first: it is one record, not a stack.
* The game initializer (`0x436fe4..0x437008`) sets the five words to 9999, 9999, 0, 0, 2 and leaves the dwords alone; process start is all zero.
* The running scene's words: after a successful load `0x439ec4` copies `0x5bb57b` into `0x5bb57f` and `0x439f20..0x439f64` copies the transition words `0x5bb599 -> 0x5bb50b`, `0x5bb595 -> 0x5bb593`, `0x5bb59b -> 0x5bb5a7`, `0x5bb59f -> 0x5bb5ab`, `0x5bb5a3 -> 0x5bb5af`; three zero dwords become `0x5bb5af = 1` (`0x439f73..0x439f8e`).
* The pair is the pop `0x42e493` (raw 0x6f and two other callers), which reads the record back (and has quirks of its own: the scene is read from `0x5c3a07` twice). It is the next family and is not in this slice.
* Corpus (decoded scene resources): 48 scenes, 68 rows, all subtype 1, body byte always 0, every row with one dependency record.

## Native implementation

`src/scene_stack.[ch]` (the record, the push, the initializer words), `src/session_bindings_a6e.[ch]` (executor handler: `DIRECT_COMPLETED`, phase unchanged; the running scene's words come from a required host callback, `UNSUPPORTED` before any effect without it), registration `bindings[21]` in `src/blackmoor_app.mm` (count 22, provider ACTION_KERNEL; the gate mode is the default 0), `scripts/build_action_family_6e_runtime.sh`. The app keeps the transition words of the last successful scene load (`loaded_words`) and supplies them as above.

## Verification

* `tests/action_family_6e_runtime_test.c`: 8 unit cases (ASan/UBSan clean), 13 unit mutants caught (`tests/test_action_family_6e_runtime.py`).
* `tests/action_family_6e_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` runs 0x6e rows under Unicorn against the native binding (82 scenarios: the 68 real bodies, subtypes 0..3/4/255, gates behind event records, a false gate, world mode 4, offset rows, a second push, 60 random scenarios), compared after every tick: which rows were visited (observed `0x42e560` entries against a gate model), completion byte and phase of every row, that `0x42ba3a` and `0x423d33` never ran, the 22 record bytes and that the source globals did not change. Also `0x42e560` itself called 240 times with random words and full 32-bit arguments, and the initializer window `0x436fe4..0x437011` executed against `scene_stack_slot_init_words`. 18 of 18 native mutants caught.
* `tests/action_family_6e_runtime_corpus.c`: all 68 corpus rows run through the binding. `tests/action_family_6e_runtime_executor.c` (run by `test_action_family_6e_runtime.py`): the production scene executor drives synthetic 0x6e rows (gate on an event flag, DIRECT_COMPLETED bookkeeping, no revisit) with the real binding; one executor mutant caught.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* The load-time copy `0x439f20..0x439f64` is skipped when the restore flag `0x5e32b5` is set (the app has no restore path, so this is not modelled).
* Where the running scene's words come from is the host provider's claim: the app uses the loaded scene id for both scene words, the live selector (the mirror of `nav.selector`; the original changes `0x5bb50b` in the navigation block `0x43c2b7..0x43c87f`) for `0x5bb50b`, and the last load's transition request for the rest; a scene entered without a transition (the first) has no request and gets zero words (unverified). The oracle writes the seven source globals directly.
* Nothing reads the record back yet: the pop `0x42e493` (raw 0x6f) is the next family, so a saved scene cannot be returned to until it lands. The existing `scene_stack_pop` callback of the 0x3f runtime is still unbound.
* The oracle builds the row in memory (the scene loader `0x40b34a` is not run) and replays the 68 corpus rows with a stand-in dependency record on flags 1000..1013 (and without).
* Debug flag `0x63a4cd` is modelled as 0.
