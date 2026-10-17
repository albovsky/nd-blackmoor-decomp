# RT-44: raw 0x4e float value recomputation

Owner thread: Claude Sonnet (cloud). Follows RT-42 (PR 106). After PR 106, 2,038 of 2,078 scenes had every action type handled. By `scene-action-coverage.json` the next ranked families were raw 0x33, 0x4e, 0xea and 0xf6 (3 scenes each). Sizing (asm lines of the dispatcher arm's method): 0x4e 268, 0x33 678 (three phases, a 0x46-byte player object built through a constructor and virtual calls, a hotspot table, video surfaces, about fifteen unported callees), 0xea 1122, 0xf6 2387 (both draw through the 0x4fb... and 0x45e... helpers). Only 0x4e is small enough for a slice of this kind; 0x33, 0xea and 0xf6 are puzzle-sized and stay in the handoff.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader `0x44b102` (decoded since A-4E.1): 31-byte copy. Body: +0 target byte, then ten triples (selector byte at 1+3i, signed amount word at 2+3i).
* Dispatcher `0x427a50`, arm `0x4280f9` (type 0x4e), gate `0x423f57` mode 1, then the method `0x44b3c8` on `0x637fb1`; the method ends in the generic completion `0x42ba3a(row)` on every path.
* Method: a target outside 30..39 changes nothing (with the debug flag `0x63a4cd` set it first logs and reports through `0x52139c`; the shipped default is 0). Otherwise the float value slot `0x58c995 + 4 (target - 30)` is cleared to 0.0f and each triple adds a term, re-reading the slot every time (a triple can name the target itself): selector 99 none; selector 0..29 `amount / 100 * int16 slot` (the slot 9999 is "unset" and gives 0); 30..39 the same with a float slot (bit-equal to `9999.0f`, or unordered, gives 0); 100 the amount itself; any other selector is reported (`0x50ca3e` then `0x52139c`, "AT_SET_VALUE_COMBO, index out of range for value to combine") and gives 0. The x87 runs at 53-bit precision (control word 0x27f in the shipped process): the amount and the slots are floats, `amount / 100` and the product are rounded to double, the term is stored as a float, and the sum is rounded to double and stored as a float.
* The value slots are the ones the world initializer `0x44aff2` fills with 9999 (`ActionCoreWorld` short/float values, shared with raw 0x4f, RT-27).

## Native implementation

* `src/action_family_4e_runtime.[ch]`: the kernel (`action_family_4e_runtime_visit` over `ActionCoreWorld`, using the A-4E.1 decoder).
* `src/session_bindings_a4e.[ch]`: the binding (COMPLETED with phase 0 for every outcome, including an out-of-range target; a body the decoder rejects is a handler error).
* `src/blackmoor_app.mm`: `bindings[40]`, declared count 41 (slot 39 is held by RT-43), handler with logging; module trio in `scripts/build_native_app.sh`; `scripts/build_action_family_4e_runtime.sh`.

## Verification

* `tests/action_family_4e_runtime_test.c` (10 unit cases, ASan/UBSan clean, including rounding witnesses where `a * slot / 100` would round to a different float) and `tests/test_action_family_4e_runtime.py` (plain, sanitizers, source mutants on kernel and binding, executor and corpus drivers, 2 executor mutants).
* `tests/action_family_4e_runtime_executor.c`: the production executor (gate mode 1, subtype 1 completes, subtype 2 stays open and is recomputed from zero each tick).
* `tests/action_family_4e_runtime_corpus.c`: the 18 real rows (3 scenes) through the binding.
* `tests/action_family_4e_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real loader `0x44b102`, dispatcher `0x427a50` and method `0x44b3c8` run under Unicorn from random value states (unset markers, NaN, infinities, denormals, signed zeros, random bit patterns); the whole 160-byte value area, the selector reports, the row cells and the original's write footprint are compared; `--mutations` re-runs the quick set against planted native mutants. See the PR and the handoff in `COORDINATION-STATUS.md` for the final counts.

## Limits

* The macOS glue is not compiled or run in the cloud.
* The debug flag `0x63a4cd` is modelled as 0.
* The scene loader `0x40b34a` is not run (rows are built in memory around the original `0x44b102`); the corpus rows' real dependency records are replayed behind the stand-in event record (the gate is shared verified code).
* The report 0x52139c is a modal error in the original; the app logs it.
