# RT-27: raw 0x4f compare-and-set-event-flag runtime

Owner thread: Claude Sonnet (cloud). Follows RT-23 to RT-26. Raw 0x4f was the top remaining type in `scene-action-coverage.json` after RT-26: 57 scenes, 815 records, 50 scenes where it is the only missing type. It is pure game state (no host provider).

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader, case 0x4f of `0x40b34a`: `0x44b1b4` allocates 10 bytes (`0x51dc43(0xa)`), copies them from the row body, advances the source by 10.
* Dispatcher arm `0x428133` of `0x427a50`, after `0x423f57(deps, 1)` (gate mode 1): `0x44b641(row)` with ECX = the object at `0x637fb1`. Every path ends in the generic `0x42ba3a(row)` (subtype 1 completes the row, subtype 2 clears it and resets the dependencies `0x423d33`, every subtype clears the phase word).
* `0x44b641`: body = attribute `A` (b0), mode (b1), operator (b2), operands b3..b7, int16 flag index (b8..b9, -1 = none). The action values are the 30 int16 at `0x58c959` followed by 10 float32 at `0x58c995`, all 9999 after `0x44aff2` (`ActionCoreWorld.short_values/float_values`). `A` above 39 (debug off): no flag. The value of `A` is read as `(float)int16` (slots 0..29) or the float32 (30..39); its bit pattern equal to `0x461c3c00` (9999.0f, unset): no flag. Then, by mode (any other mode: no flag):
  * mode 0: slots 30..39 ascending, skipping unset slots and `A` itself; mode 1: slots 0..29 the same way; per slot the operator tests `cur OP other` (0 `==`, 1 `<`, 2 `>`, 3 `>=`, 4 `<=`; others skip), except that operators 3 and 4 compare against the BYTE `body[3 + slot]` (a bug-shaped read that leaves the 10-byte body from slot 7);
  * mode 2: operands b3..b7 in order, 99 = unused, each a slot index (`v <= 29` int16, else the float table at `0x58c91d + 4v`, which for `v >= 40` is other memory), unset slots skipped, operators 0..4 as above (no self exclusion);
  * mode 3: operands in order as literals `(float)v` (99 = unused) for operators 0..4; operators 5, 6, 7 (`==`, `>=`, `<=`) compare against `(float)(b3 * b4 / 100.0)` (`fild`/`fmul`/`fdiv dword [0x52cbec]` = 100.0f at control word 0x027f, one `fstp dword`) and only at the first operand position, then the scan ends; a first operand of 99 skips the whole row; other operators skip.
  * compare = x87 `fcomp` + `fnstsw`: `==` tests C3, `<` C0, `>` neither, `>=` not C0, `<=` C0 or C3; an unordered pair (NaN) sets both.
  * the scan stops at the first match; when it matched and the flag index is not -1 the dword `0x585801 + 4 * flag` := 1 (never cleared).
* Corpus (decoded scene resources): 57 scenes, 815 rows, all subtype 1 and mode 3, operators 0 (782), 1 (13), 2 (19), 3 (1), 68 rows with one dependency record, attributes 0..2, 7, 10..16, 19..25, 29..34, flag indexes 1000..1588.

## Native implementation

`src/action_family_4f.[ch]` (decoder and kernel on the `ActionCoreWorld`), `src/session_bindings_a4f.[ch]` (executor handler: always COMPLETED with phase 0), registration in `src/blackmoor_app.mm` (`bindings[20]`, count 21, provider ACTION_KERNEL; gate mode 1 is already in `scene_conditions_gate_mode_for_type`).

## Verification

* `tests/action_family_4f_runtime_test.c`: 14 unit cases (ASan/UBSan clean), 17 unit mutants caught (`tests/test_action_family_4f.py`).
* `tests/action_family_4f_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` runs 0x4f rows under Unicorn against the native binding; 146 scenarios (the 815 real bodies against random worlds, an operator grid for every mode, a percent sweep, NaN/inf/-0.0, edge attributes, gates with a same-tick flag chain, subtypes, 70 random scenarios), compared after every tick: visited rows against a sequential gate model, completion/phase/reset, the first 1,600 event flags and the 40 action values; 27 of 27 native mutants caught.
* `tests/action_family_4f_runtime_corpus.c`: all 815 corpus rows decode and run through the binding.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* Known differences, refused natively before any state change and counted by the oracle, never counted as passes: K1 modes 0/1 with operators 3/4 reading `body[3 + slot]` outside the body, K2 mode 2 with an operator up to 4 and an operand of 40 or more (other than 99) reading past the value tables (a larger operator skips the compare and runs as the original does), K3 a flag index below -1 or beyond the native table (the original writes through it unchecked). No corpus row has any of them.
* The debug flag `0x63a4cd` is modelled as 0 (the original logs and aborts on an attribute above 39 or an unset attribute with it set).
* The oracle builds the 10-byte body in memory (the scene loader `0x40b34a` is not run), and the dependency records of the 68 corpus rows with a tail are not replayed (the gate is shared, verified code).
* Whether the real game keeps the action values that rows compare (written by 0x4d set-value rows and by the world initializer) in step with `ActionCoreWorld` during play is outside this slice.
