# FL-58 handoff (rows at or above 0x480000, round nine): seeds for the no-seed rows, then an automated verification pass

Ledger 2,181 (main after PR 188) -> **2,186 ported of 4,188**: 5 upper rows credited (0x4db0d6 0x4db10c 0x4db147 0x4db178 0x4db223), every mutant killed, covered by identical -O2 code or by a rule (`repeat`, `cleanup`), no written reasons. "Translated, unverified" upper rows: **1,551 in `translated/original_methods_fl41_translated.c`** (FL-55b table, was 1,552) **plus 117 in FL-57's table** = 1,668 of the 1,671 pending upper rows; the other 3 are 0x4d8dca, 0x50ed50, 0x50fa90 (see the FL-57 handoff).

## Part 1: the no-seed and hang rows (translated, unverified)

The 155 rows of FL-55b without a comparable seed are down to **10**; the 4 hang rows (0x4933ff 0x4a1d3a 0x4adb6c 0x4ae178) run and agree on their seeds (0x4a1d3a even has full coverage). Changes (all in `tests/fl41_world.py` / `scripts/lift_fl41.py` / `scripts/fl55_bulk.py`; credited rows are unaffected, `test_fl41_differential` passes on all 157):

- `__EH_prolog` (0x50f978) is an inline helper (`INLINE_CALLEES`): the original bytes run, the translation runs `m50f978_lifted`. Fixed 66 SEH ctor/dtor rows (it sets ebp and moves esp, which a stub cannot).
- Calls through a register or pointer (`row['sites']`, recorded by the lifter in `INDIRECT_SITES`): the original side plays them as the same recording stub as the translation (a hook at the call), with the guessed pop. Before, the original ran garbage at the random target and the seed was dropped. The guess (`indirect_cleanup`) now treats only the first K register pushes as saved registers, K being the `pop reg` run before `ret`. The guess is applied on both sides, so a wrong guess is NOT detected: rows with sites are never credited. A call target of 0xffffffff or any address from 0xfff00000 faults (0xffffffff is also the translation's divide-error marker).
- Native side patches the import slots with the stub entries, as the original does (`mov esi, [slot]` / `call esi`).
- The original run stops where the function span ends (function ends in a noreturn call such as ExitProcess; fragments); not when a callee stub starts at the span end.
- `frame` mode (ebp one dword below the return address) for function tails that read ebp before writing it, tried only when a row has no usable seed (stored per row in the table as `frame`).
- The native translation runs in a forked child with an alarm (`guarded_native`): a native loop is reported as a mismatch, not a hang of the driver. `ORIG_PAGE_LIMIT` = 1000 pages in the bulk driver (a seed that walks memory costs seconds).
- `fl55_bulk.py --merge --rows ...` updates single rows of the table and C file; the table records `sites` and `frame` per row.
- Still no seed (10, `status: no seed` in the table): 0x49251f (3,792 bytes), 0x4c492c (walks memory), 0x4cf687, 0x50c992, 0x518caf (loop driven by data), 0x519cc0 (calls a noreturn function), 0x51cab3 0x522d82 0x522ed0 (fragments that join a shared epilogue), 0x5242c7.

## Part 2: automated verification pass

`scripts/fl58_candidates.py`: a row is a candidate when it is a game row (the ledger never credits library rows; 1,259 of the translated rows are library), the strict lifter (BULK off, `__EH_prolog` allowed) gives exactly the bulk text (no pointer calls, no unknown-x87 callee, no made-up frame), and it is not in the corpus: 214 rows, 48 of them fully covered by the quick seeds. `scripts/fl58_add_rows.py` puts rows into the corpus (kept seeds plus the seeds of `tests/fl41_pending.json`; coverage must be complete): 37 rows (the coordinator's excluded list was dropped; 15 pending rows mismatch on old seeds). Then the standard pipeline, tool-first: `fl52_pipe.py` (25 min cap, `FL52_TIMEOUT`), `scripts/fl58_harden.py` (adds the checker's own killing seeds 5000-5039 / 6000+, no search), second pass, `fl52_merge.py`, `fl41_o2_classify.py`, `scripts/fl58_classify.py` (fl41_survivors with every written reason switched off).

Result of the 37: **5 clean** (credited), **19 with unexplained survivors** (0x4a1d3a 2, 0x4bf8c2 6, 0x4d5b54 17, 0x4d9302 10, 0x4e6548 9, 0x4c4c2b 13, 0x4c1451 16, 0x4dfed2 36, 0x4a0d73 19, 0x4fa127 15, 0x4f9f92 14, 0x4adae8 11, 0x4e0619 6, 0x4a0bbd 29, 0x4d912a 11, 0x4a0ac4 39, 0x4bf024, 0x4c97b4, 0x4db1ad, 0x4db1e8), 13 not finished (two 99-byte rows 0x4c8757 0x4c880f ran into the cap; 0x48efe8 0x4dfff3 0x4ae4d7 0x4a10f1 0x4d940a 0x4c3c5d 0x48905b 0x491972 0x4bbe46 0x490598 were stopped). Those rows are back in the translated table. Logs: `tasks/fl52/v58*`, merged `tasks/fl58-mutation-log.txt`, `tasks/fl58-survivors.json`, `tasks/fl58-o2-identical.json`, candidate lists `tasks/fl58-candidates.json`, `tasks/fl58-added.json`.

Findings: (1) `fl55_rule_soundness.py` on the 5 rows found one unsound rule application: `same value` calls the mutant `drop` line 14 of 0x4db147 harmless although a corpus seed kills it (hash 08669b0d). The 5 credits do not rest on it (their real survivors are `identical code`, `repeat`, `cleanup`), but earlier credits that used `same value` should be re-checked with this script. (2) Rows of the mid size (200-600 bytes) all have 5 to 40 unexplained survivors under the plain seeds; without killing scenarios or written reasons the yield of an automated pass is the small thunk-like rows only. (3) Independent Sonnet diff review: no problem for credited rows; notes: the indirect-pop guess mis-counts with an early-exit `ret` (sites rows are never credited); a fixed guard in `fl58_add_rows.py` (region/status checks before lifting).

## FL-57 x87 fixes (PR 197) checked

After merging main: none of the 1,551 table rows or the 157 corpus rows uses `fxch`, `fl57_*` helpers (fpatan, fyl2x, fsin, fcos, fprem, fscale), so nothing needed regenerating; the 5 credits are unaffected.

## Left

- 10 no-seed rows, the 3 untranslated upper rows (FL-57), the 13 unfinished and 19 unexplained verification rows, 227 game rows with incomplete coverage (need a directed search, not allowed in this pass).
- Library rows (1,259 + FL-57) can only be "translated, unverified".

## Tests run (targeted policy, no full suite)

`test_fl41_differential` (157 rows OK), `test_fl55_translated`, FL-57's `test_fl57_translated`, `test_function_names`, ledger/evidence tests, `tests/test_fl*` (see PR). Pinned binutils built under `work/tools/s08-binutils-2.43.1` (download from old-releases.ubuntu.com, `scripts/bootstrap_matching_s08_2_gas.sh`, about 6 min); audits of batches 001-010 rerun.
