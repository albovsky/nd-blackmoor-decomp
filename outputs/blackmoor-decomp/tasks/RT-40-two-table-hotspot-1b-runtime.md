# RT-40: raw 0x1b two-table scene-change hotspot

Owner thread: Claude Sonnet (cloud). Follows RT-39 and the RT-36 merge (PR 102). After PR 102, 2,027 of 2,078 scenes had every action type handled. Raw 0x1b (4 rows, 4 scenes, each the sole blocker of its scene) takes that to 2,031. Raw 0x7d (`0x4eb5f2`) was not folded in: it is its own slice and binding slot 37.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader constructor `0x414692` (A-1B.1; `src/action_family_1b.c`): a 34-byte row object: +0 primary count, +2 primary array (22-byte records), +6 five fixed words, +0x10 three fixed dwords, +0x1c secondary count, +0x1e secondary array (18-byte records: selector word, four dwords left/top/right/bottom).
* Dispatcher `0x427a50`, arm `0x427c87`, gate `0x423f57` mode 1. For a true gate the arm calls the object method `0x414947` (806 bytes, no calls) on the static object `0x6385db` with the row index. The method stores the completion byte itself: the arm never calls the generic completion `0x42ba3a`. The request dword `0x5bb626` is cleared by the prologue at `0x427ad4` for every non-done row before the gate.
* Phase 0: start flag `0x5bb1ca := 1`, phase := 1, then phase 1 in the same call. Phase 1: request := 0; the first secondary record whose selector word equals the world selector `0x5bb50b` (both sign-extended) sets request := 1 and copies the low words of its four dwords to the row rectangle words. Phase 2: completion byte := 1 directly (phase stays 2); the first primary record whose key equals the held item `0x583a29` supplies the scene-change cells, with no hit the object's fixed words and dwords do; then the engine mode `0x583999 := 4`. Any other phase has no effect.
* Pointer cascade: the generic row loop `0x4f1eb8..0x4f257b` hit-tests a row whose request dword is nonzero against the rectangle words; its type-0x1b case `0x4f22ad` gives the hover cursor (no held item: the object's first fixed word; else held item + 0x25 on the held surface; variant 1).
* Corpus: 4 rows in 4 scenes.

## Native implementation

* `src/action_family_1b_runtime.[ch]`: the kernel (`action1b_step`, `action1b_hover_cursor`) with the ordered effect stream of RT-15/16 (`Action17Effect`).
* `src/session_bindings_a1b.[ch]`: the binding (begin scene decodes every raw 0x1b body, handler, pre-gate request clear, pointer row, hover cursor). Phase 2 asks the host for a scene-change request (`SceneTransitionRequest`) and answers DIRECT_COMPLETED with phase 2; without a transition callback or world provider the visit is UNSUPPORTED before any effect; a refused request is an ERROR and does not commit the completion byte.
* `src/blackmoor_app.mm`: `bindings[36]`, count 37, pre-gate registration, world loader (selector `selector_entry_frame`, held item from the inventory view), pointer row, hover cursor, hotspot draw chain; module trio added to `scripts/build_native_app.sh`. Slot 37 is reserved for 0x7d.

## Verification

* `tests/action_family_1b_runtime_test.c` (4 unit cases, ASan/UBSan clean) and `tests/test_action_family_1b_runtime.py` (plain, sanitizers, 12 kernel/binding source mutants, 3 executor mutants).
* `tests/action_family_1b_runtime_executor.c`: the production executor (pre-gate, gate mode 1, accepted-release candidate to phase 2 and the transition).
* `tests/action_family_1b_runtime_corpus.c`: the 4 real rows through the binding.
* `tests/action_family_1b_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real dispatcher `0x427a50` with the real method `0x414947` runs under Unicorn against the native binding; the ordered store stream, per-row cells, scratch cells, object immutability and read extents, and 600 cascade cases (hit-test and hover cursor) are compared. 0 mismatches; see the PR for the final counts and mutant tally.

## Limits

* The macOS glue is not compiled or run in the cloud (only the new glue block was syntax-checked against stand-in types).
* The cursor sprite is not drawn by the app; the hover cursor selection is logged.
* The oracle builds the rows in memory (the scene loader `0x40b34a` is not run).
* Native difference: a row whose A-1B.1 body the decoder rejects fails the scene load; a failing begin keeps the previous scene's rows.
