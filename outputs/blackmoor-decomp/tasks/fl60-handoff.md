# FL-60 handoff (rows at or above 0x480000, round thirteen): rule recheck, then an automated verification pass

Ledger 2,186 (main after PR 199) -> **2,189 ported of 4,188** (+3 upper rows: 0x4de2d8, 0x4e94a9, 0x488e54; every mutant killed, identical -O2 code, or explained by a sound rule; no written reasons). **Translated, unverified: about 1,779** (1,548 upper in `translated/original_methods_fl41_translated.c`, 117 in FL-57's table, 111 lower in `src/original_methods_fl56_unverified.c`, 3 FL-59 hand ports). Not port credits.

## Part 1: the `same value` soundness bug (FL-58 finding)

Cause: `stmt()` in `scripts/fl40_survivors.py`, `scripts/fl41_survivors.py` (and `stmt_full`) and `scripts/fl46_rules.py` cut a line at its FIRST `/*`. A call to an import is `esp -= 4u; WR32(esp, ret);  /* call [DLL!name] */ FL41_CALL(0x...); ...  /* 0x...: call ... */`, so the call was hidden from the BARRIER test and `same value` excused dropping a frame-slot reload across a call (0x4db147 line 14). Fix: remove every `/* ... */` span. Regression test `tests/test_fl60_survivor_rules.py`.

Sweep (`scripts/fl60_rule_sweep.py`, `scripts/fl60_soundness_all.py`, result `tasks/fl60-rule-sweep.json`): every compiling mutant of the 157 corpus rows (then 160), classified as if no seed had killed any, before and after the fix.
- **Class changes caused by the fix: 4 mutants** (0x4ba13d lines 17 and 19, 0x4db0d6 line 16, 0x4db147 line 14, all `same value` -> unexplained). None is a survivor in the definitive log of its row (a corpus seed kills each), so **no credit rested on them: 0 demotions**.
- Lower corpus (`fl44_final.py`, 376 rows): 285 clean before and after the fix, 0 changes.
- Of the 1,973 mutants any rule calls harmless, 7 are listed as killed only in the very first FL-41 log (`tasks/fl41-mutation-log.txt`): 0x494ccc (lines 25, 26, 36), 0x4c9b25 (19), 0x4c9ca0 (18), 0x4d51c0 (11, 12). Rerun with the current harness and corpus (`FL48_ONLY`), all 7 survive, so no seed of the current corpus contradicts their rules (`repeat`, `cleanup`). Left as is.
- Independent Sonnet diff review: fix correct and complete, no rule becomes more permissive. Known, pre-existing: `cleanup_ok` excuses any `literal` mutant on a call line, including a changed call target (its other conditions hold; not touched here).

## Part 2: automated pass

FL-58's untried candidates (182 of the 214 strict-lift game rows): **166 fail the full-coverage gate** (`scripts/fl58_add_rows.py`: every instruction and both directions of every jump must run on the kept seeds; closing the gap is a directed search, not allowed in this pass; FL-61's concolic generator is the way forward). 16 entered the corpus (with 5 rows FL-58 had stopped). Pipeline as in FL-58 (`fl52_pipe.py` with a 20 minute cap per row, `fl58_harden.py` killers, second pass, `fl52_merge.py`, `fl41_o2_classify.py`, `fl58_classify.py`): logs `tasks/fl52/v60*`, `tasks/fl60-mutation-log.txt`, `tasks/fl60-survivors.json`, `tasks/fl60-o2-identical.json`, `tasks/fl60-added.json`.
- **Clean (credited): 0x4de2d8 (74 bytes, 39 mutants all killed), 0x4e94a9 (24 bytes), 0x488e54 (72 bytes).** 0x4de2d8 needed reviewed A-51 blockers (`tasks/fl60-blockers.json`).
- Unexplained survivors (back to translated): 0x4ee572 (4), 0x4e06c0 (5), 0x4b450f (8), 0x4fb1c6 (10), 0x4e45be (17), 0x4c3c5d (7), 0x49d755 (8), 0x4bbe46 (16).
- Hit the per-row cap, no result (back to translated): 0x4e023b, 0x491972, 0x490598, 0x48905b, 0x494f1f (all over 300 bytes, four over 1,000).

## Part 3: yield by row size (strict-lift candidates, FL-58 and FL-60 together)

| body bytes | candidates | entered the corpus (full coverage) | credited |
|---|---|---|---|
| under 100 | 17 | 14 | 8 |
| 100 to 299 | 45 | 18 | 0 |
| 300 to 599 | 48 | 9 | 0 |
| 600 to 999 | 37 | 2 | 0 |
| 1,000 and up | 67 | 5 | 0 |
| total | 214 | 48 | 8 |

Reading: below 100 bytes about half of the candidates are credited automatically; from 100 bytes up, 0 of 197. Two walls: (1) the coverage gate (the quick seeds miss an instruction or a jump direction in 166 of 182 untried rows; mid-size and large rows almost never reach full coverage), (2) 4 to 17 unexplained survivors on the rows that do enter (median about 8). Mid-size rows therefore need coverage generation (FL-61) first, then killing scenarios or reasons; plain automation will not bank them.

## Regeneration (done)

Merged main (FL-59, PR 202) once. Oracle docstring row count (160), `record_function_execution.py run --only fl41_original_oracle` (about 3 min), `collect --write --merge`, `fl41_accept.py --reviewer ... --blockers-reviewed tasks/fl60-blockers.json`, evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, audits of batches 003 to 006 (pinned binutils 2.43.1 in `work/tools/s08-binutils-2.43.1`; archive from old-releases.ubuntu.com `binutils_2.43.1.orig.tar.xz`, `scripts/bootstrap_matching_s08_2_gas.sh`, about 8 min), evidence and ledger again. Needs `pip install unicorn capstone` in a fresh container.

## Lessons

- Do not run `fl58_harden.py` on a row set that includes a big row: it writes the corpus only at the end, one big row blocks the others (I killed it and applied the killers from the log).
- Credited rows must leave `tests/fl41_translated.json` and `translated/original_methods_fl41_translated.c` (`test_fl55_translated` fails otherwise).
- Never type rm; no background job can be interrupted from Python, kill explicit pids.
