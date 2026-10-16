# RT-29: raw 0x6f return-to-the-saved-scene runtime

Owner thread: Claude Sonnet (cloud). Follows RT-28 (the push). Raw 0x6f was 25 records in 24 scenes (21 scenes where it was the only missing type); it is the pop that pairs with 0x6e.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40e314` of `0x40b34a` (A-6F.1): one byte is copied; the dependency tail follows. The byte is never read afterwards.
* Dispatcher arm `0x4291b6` of `0x427a50`: `0x423f57(deps, 0)` (gate mode 0), and for a true gate `call 0x42e493` (no arguments) then the row's completion byte `[0x5bb625 + row * 0x8d] := 1` directly (`0x4291ec`). Like 0x6e: the generic completion `0x42ba3a` and the dependency reset `0x423d33` never run, whatever the subtype, and the phase word is untouched: executor disposition `DIRECT_COMPLETED` with the phase it was given.
* The pop `0x42e493` (cdecl, no arguments): if `movsx word [0x5c3a05] == 9999` it logs through `0x52139c` / `0x4c97b4` (an error path: a message box through `0x52139c`, then a quit request through `0x4c97b4`; what the pop does after those calls returns is not modelled). Otherwise `[0x5bb57b] := [0x5bb57f] := movsx word [0x5c3a07]` (the scene is read from `0x5c3a07` twice; `0x5c3a05` is only the empty test), `[0x5bb599] := word [0x5c3a09]`, `[0x5bb595] := word [0x5c3a0b]`, `[0x5bb59b] := dword [0x5c3a0f]`, `[0x5bb59f] := dword [0x5c3a13]`, `[0x5bb5a3] := dword [0x5c3a17]`, `[0x5c39ff] := 1`, `[0x5bb1ca] := (movsx word [0x5c3a0d] == 1 ? 0 : 1)`, `[0x583999] := 4` (engine mode: scene change), and finally `word [0x5c3a05] := word [0x5c3a07] := 9999` (the record is empty again). The other words of the record keep their values. These globals are the scene-change request words that the loader copies at the next load (`0x439f20..0x439f64`): the same set a 0x3f/0x36 transition carries (`0x5c39ff` is the third word).
* The dispatcher loop head requires mode 3 at every row (`0x427a8e`), so after a pop no later row of the same pass is visited; the executor's transition request stops the pass the same way.
* Corpus (decoded scene resources): 24 scenes, 25 rows, all subtype 1, body byte always 0, every row with one dependency record.

## Native implementation

`src/scene_stack.[ch]` gain `scene_stack_pop` (fills a `SceneStackPop` with the values above and empties the record; the empty record, the original's fatal path, returns `SCENE_STACK_POP_EMPTY` before any change), `src/session_bindings_a6f.[ch]` (executor handler: pops a copy of the shared record, hands the scene-change request and the pop result to a required host callback, commits the record only if the host accepted it, `DIRECT_COMPLETED`, phase unchanged; an empty record is `HANDLER_ERROR` before any effect), registration `bindings[22]` in `blackmoor_app.mm` (count 23, provider ACTION_KERNEL, the app forwards the request to `scene_session_request_transition` and keeps the start flag), `scripts/build_action_family_6f_runtime.sh`, `scripts/build_native_app.sh` (module list).

## Verification

* `tests/action_family_6f_runtime_test.c`: 9 unit cases (ASan/UBSan clean with gcc), including a 0x6e push then 0x6f pop round trip through both bindings; 22 unit mutants caught (`tests/test_action_family_6f_runtime.py`).
* `tests/action_family_6f_runtime_executor.c` (run by the same Python test): the production scene executor drives synthetic 0x6e/0x6f rows (gates on event flags, DIRECT_COMPLETED bookkeeping, the pass ends after the pop's transition, the stopped executor visits nothing next tick); one executor mutant caught.
* `tests/action_family_6f_runtime_corpus.c`: all 25 corpus rows run through the binding.
* Original-x86 oracle `tests/action_family_6f_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` (arms `0x4291b6` and `0x42916f`, real loader `0x424aa8`, gate `0x423f57`, real pop `0x42e493` and push `0x42e560`) runs 0x6f and 0x6e rows against the native bindings. Memory windows around the destination globals are seeded with random bytes and compared byte for byte after every tick (a byte may differ from its pre-tick value only where the pop writes it, and then the native pop result must match). See the receipt numbers in COORDINATION-STATUS.md.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* An empty record is the original's error path (message box, then a quit request; the code after the calls is not modelled, and if they return the original would carry on with the completion byte set and mode unchanged); the native handler refuses it (`HANDLER_ERROR`, nothing changes). No corpus scene can pop before a push unless a restored/loaded state fills the record (unknown), so whether the live game ever reaches it is unverified.
* The scene load that follows mode 4 is the app's existing transition path (`perform_session_transition`); the pop only builds the request. The load-time copy of the request words is skipped by the restore flag `0x5e32b5`, which the app does not model.
* The pop's other callers in the original (the 0x3e/0x3f finish paths) use the existing `scene_stack_pop` host callback of the 0x3e/0x3f runtime, which stays unbound in the app; wiring it to `scene_stack_pop` is a small follow-up.
* The oracle builds rows in memory (the scene loader `0x40b34a` is not run) and replays the 25 corpus rows with and without a stand-in dependency record. Debug flag `0x63a4cd` is modelled as 0.
