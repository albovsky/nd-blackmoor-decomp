# RT-42: raw 0x47 journal entry add

Owner thread: Claude Sonnet (cloud). Follows RT-40 (PR 104). After PR 104, 2,031 of 2,078 scenes had every action type handled. Raw 0x7d is RT-41 (binding slot 37). By `scene-action-coverage.json` the top unhandled type left was raw 0x47 (4 scenes, 139 rows, sole blocker in 3 scenes), which takes the count to 2,034.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader `0x411a22`: the row's pData is a fresh 0x27-byte copy of the raw body (`scene_resource.c` fixed length 39). Body: +0 kind word (3, 4 or 5), +2 a 33-byte NUL-terminated name (also the AUTOTEXT key), +0x23 a code word, +0x25 a link-value word. The real corpus: 139 rows in scenes 2874 to 2877, all subtype 1, kind 3 (65 rows) and kind 4 (74 rows), `CURJnn` names.
* Dispatcher `0x427a50`, arm `0x428515` (the jump-table slot for type 0x47), gate `0x423f57` mode 0, then the appender `0x412787` as a thiscall on the text owner `0x619a41`; every path ends with the generic completion `0x42ba3a(row)`.
* Appender: table `t = kind - 3` (three tables: names `0x5957cb + 0x3390 t + 0x21 j`, code words `0x59f27b + 0x320 t + 2j`, count words `0x59fbdb + 2t`, link values `0x59fbe1 + 0x320 t + 2j`, 400 entries each). For each stored entry j below the count: an entry with the same name (exact byte compare) ends the visit with no add; otherwise the AUTOTEXT lookup `0x423259(0x619a6b, name)` runs (once per non-matching entry, it is loop invariant) and a miss ends the visit too. After the loop a full table (count 400) reports "AUTOTEXT error - too many list entries on page" through `0x52139c` and the original then writes entry 400 (which aliases the next table's entry 0) and a count of 401. Otherwise: strcpy of the name (the rest of the 33-byte entry keeps what it held), code word stored, link value stored (`+0x25` word when the code is >= 10 or == 7, else 9999), count + 1, then kind 4 calls `0x4e0559(0x570508, 2, 1, 0)` and kind 3 calls it with slot 1, which set dword `0x5a1afc` and dword `0x5a1b00 + 4 slot` (kind 5 sets nothing).
* These are the "link" tables the text writer of RT-32/RT-34 (`0x413187` with table index 0) fills and reads: table 0 here is the same memory as `A44TextResult.link_count/link_value`. The app does not wire the two yet.

## Native implementation

* `src/action_family_47_runtime.[ch]`: the kernel (`a47_decode`, `a47_step` over `A47Tables`). Nothing changes unless the visit returns OK (the lookup runs before any store). Native safety differences: a kind outside 3..5 (the original indexes memory outside the tables), a name without a NUL inside its 33 bytes and a full table (the original overruns) are errors that change nothing.
* `src/session_bindings_a47.[ch]`: the binding (owns the tables and the page-2 flags, lookup through the host, handler returns COMPLETED with phase 0 for every outcome; a visit that needs the lookup while none is bound is UNSUPPORTED before any effect; `session_a47_reset` empties the tables).
* `src/blackmoor_app.mm`: `bindings[37]`, declared count 38, handler with logging, host lookup (raw 0x51's AUTOTEXT lookup); `scripts/build_native_app.sh` module pair; `scripts/build_action_family_47_runtime.sh`. RT-41 (raw 0x7d) was assigned slot 37 but had not merged; leaving 37 empty makes `scene_session_create` fail (null callback) and breaks the map script, so this slice fills 37 and RT-41 takes 38 (count 39) when it merges.

## Verification

* `tests/action_family_47_runtime_test.c` (7 unit cases, ASan/UBSan clean) and `tests/test_action_family_47_runtime.py` (plain, sanitizers, 25 kernel and 10 binding source mutants, executor and corpus drivers, 2 executor mutants).
* `tests/action_family_47_runtime_executor.c`: the production executor (gate mode 0, subtype 1 completes, subtype 2 stays open and finds its own entry on the next visit).
* `tests/action_family_47_runtime_corpus.c`: the 139 real rows through the binding.
* `tests/action_family_47_runtime_original_oracle.py` (+ `_oracle_driver.c`): the real loader `0x411a22`, dispatcher `0x427a50`, appender `0x412787` and flag setter `0x4e0559` run under Unicorn from random table states against the native binding; the ordered lookup calls, count writes, flag setter calls, the full table memory (names with their stale bytes, codes, counts, links, flags), the row cells and the original's write footprint are compared; `--mutations` re-runs the quick set against 31 planted native mutants. See the PR and the handoff in `COORDINATION-STATUS.md` for the final counts.

## Limits

* The macOS glue is not compiled or run in the cloud (only the new glue block was syntax-checked against stand-in types).
* The journal tables are not yet shared with the text writer's link table (RT-34), and there is no new-game reset call in the app (`session_a47_reset` exists).
* The AUTOTEXT lookup behind `0x423259` is replaced in the oracle (found = nonzero pointer); only its control flow is compared. The scene loader `0x40b34a` is not run (rows are built in memory around the original `0x411a22`).
* A full table is an error natively (the original reports and overruns; the oracle checks that exactly those rows reach `0x52139c` and ends the scenario there).
