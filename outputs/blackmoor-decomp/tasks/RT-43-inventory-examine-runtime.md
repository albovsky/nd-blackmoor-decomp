# RT-43: inventory examine step 0x4ea269 (fills the saved-scene record raw 0x7d reads)

Owner thread: Claude Sonnet (cloud). Follows RT-41 (raw 0x7d, PR 105) and RT-22 (inventory view). RT-41's record `0x5c3a1b..0x5c3a30` is filled only by the saver `0x4eb70f`, which the examine step calls; until now the view's read branch stopped as UNMODELED, so a raw 0x7d row stopped the executor with a handler error in the app. With this slice the click on an examinable item runs end to end natively: save, select, remove, sound, scene request, close; the 0x7d return then has a record to pop.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* The view click `0x4e8e78` branch (a) at `0x4e8e97..0x4e8f2a`: item kind word (view `+0x77e`, record `+0x30`) == 3, text word (`+0x780`, record `+0x32`) not 0 and not 0x270f, aux dword `0x583ced[hot] == 0` -> `0x4ea269(hot, 1, 1)` (thiscall on `0x571442`, `ret 0xc`), then `0x4e8e78` returns 1.
* `0x4ea269(item, take, sound)` is 0x4ea269..0x4ea35e (two callers: the click above and the action handler `0x4eaca8` at `0x4ead4d`, with sound 0; that action type is not ported yet). In order:
  1. `movsx word [0x583f1d] != -1` (a pending examined item): `0x4e9e84(selector, 1)` puts it back (RT-19 add step with flag 1: sound 0x17, rebuild, UI animation `0x4e0559(1,1,0)` when the view mode is not 2);
  2. the selector read AGAIN is -1 (the add never writes it, so this is the complement of 1): the saver `0x4eb70f(2)` copies the running scene's words into the second record (word type 2; the third dword `0x5c3a2d` is never written, `0x5bb5af` overwrites the second);
  3. `word [0x583f1d] := (movsx word take == 1 ? item : -1)`;
  4. `0x4ea06c(item)` removes the item from the list (RT-13 remove step, rebuild);
  5. when the sound dword is nonzero, `0x4fb2e3(0x17)`;
  6. the scene request words: `dword [0x5bb57b] := movsx word [view + item*0x16d + 0x780]`, words `[0x5bb599] = [0x5bb595] = 0`, `word [0x5c39ff] := word [view + item*0x16d + 0x782]`, dwords `[0x5bb59b] = [0x5bb59f] = 0`, `[0x5bb5a3] = 1`, `dword [0x583999] := 4` (engine mode: scene change). Unlike the pop `0x4eb5f2` it writes neither `0x5bb57f` nor the start flag `0x5bb1ca`;
  7. the view close `0x4e7d04` (teardown `0x4edb97`, reset `0x4e7bf3`, screen state `0x583204 := 0`, `0x4d36ed`).
* The item word indexes the records with its sign; the native refuses an item outside 0..69. Real data (BOOT INV chunk): 11 examinable items (2, 10, 14, 28, 30, 33, 36, 37, 38, 39, 46), scenes 6200..6270, record word `+0x34` always 1.
* The game initializer's view constructor stores -1 into `0x583f1d` (`0x4e7e42`); only `0x429539`, `0x4ea2b1` and `0x4ea2ba` write it afterwards.

## Native implementation

* `src/inventory_examine_runtime.[ch]`: `inventory_examine` (the whole step; a dry run of the add and remove steps on private copies refuses before step 1 commits anything; a provider failure after that is `INVVIEW_ERR_HOST` without rollback), `inventory_examine_words_from_inv` (the record `+0x34` words), the effect markers `INVEXAM_EFFECT_*` and the request struct handed to the host as one scene change.
* `src/inventory_view_runtime.[ch]`: `InventoryViewHost.examine` (appended last; the ABI of the existing fields is unchanged). When set, branch (a) of `inventory_view_click` calls the step with `(hot, 1, 1)` and the live view mode/slot flag; when NULL the click reports UNMODELED as before.
* `src/scene_session.[ch]`: `scene_session_request_external_transition`, a scene change requested between ticks by the host's own input path (the click is not a scene action). It stores the pending transition exactly as a handler's request does after the tick; the next tick returns `TRANSITION_PENDING` without running anything.
* App glue (`src/blackmoor_app.mm`, NOT compiled in the cloud): `inv_examine` configuration (selector `new_game.opaque_selector`, record `scene_restore_slot`, `inv_flag782`, the 0x6e `native_a6e_load_current` words, `native_examine_scene_change`), set before every click. No new action binding slot: this slice adds none (slot 39 stays free).

## Verification

* `tests/test_inventory_examine_runtime.py`: 24 cases (save path and put-back path with exact effect order and record fields, selector 0, sign extension, take/sound variants, bounds and dry-run refusals before any effect, missing providers, host failures, click integration, the real INV chunk words); `tests/test_scene_session.py::test_external_transition_...`.
* `tests/inventory_examine_runtime_mutation_check.py`: 34 source mutants (the examine kernel and the click hook), all killed by the unit tests; 27 also by the oracle's quick matrix (the 7 survivors are provider-absence and host-refusal paths that the oracle, which always supplies working providers, cannot reach).
* `tests/inventory_examine_runtime_original_oracle.py`: the REAL original runs under Unicorn from the click gate `0x4e8dc8` (so `0x4e8f0e -> 0x4ea269` runs for real) and from a direct entry of `0x4ea269` with every take word and sound dword, with the real add `0x4e9e84`, saver `0x4eb70f`, remove `0x4ea06c`, rebuild `0x4e812f`, UI animation `0x4e0559` and close `0x4e7d04`. 2,663 cases, 2,635 parity (2,565 examine runs: 1,018 with a pending item added back, 1,547 saving; 70 neighbouring RT-22 clicks), 28 unsafe states refused by the native step before any effect, 0 mismatches; compared: ordered events, inventory cells, view state, the 22-byte record, byte windows of every global the step writes, the `0x4e8e78` return value and flags, write footprint, registers, stack balance.
* `tests/inventory_view_runtime_sanitize.c` runs 20,000 rounds (a third with a forced examine) under ASan/UBSan; the RT-22 unit tests and quick oracle still pass.

## Limits

* The macOS glue is not compiled or run in the cloud (only the new block was syntax-checked against stand-in types).
* The text page of the examined item (scene 6200..6270) is only requested as a scene change; whether those scenes then run natively depends on their own actions.
* The start flag `0x5bb1ca` and `0x5bb57f` are untouched, as in the original; the loader's consumption of the request words, the sound manager, the teardown and `0x4d36ed` are host effects, not compared.
* The use branch `0x4e8f6d` is still UNMODELED. The action handler `0x4eaca8` (second caller, item and take from the row, sound 0) is not ported: the step is ready for it (`inventory_examine(..., sound=0)`).
* The glue offers the step only when the session can take the scene change at once (not blocked, no transition pending, exit state running); otherwise the click is reported UNMODELED with no effect, because a refused scene-change request after the item moved would be an ERR_HOST with the earlier effects committed.
* A negative scene word is sign-extended as in the original; the app's transition would then fail. Real INV data only holds 6200..6270.
