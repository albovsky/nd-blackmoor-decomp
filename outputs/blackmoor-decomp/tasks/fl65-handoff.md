# FL-65 handoff (upper rows, round sixteen): the cell engine, known flags and unobserved bits on the upper classifier

Ledger 2,205 (main after FL-64, PR 211/212) -> **2,210 verified ported of 4,188** (+5 upper rows: 0x495536, 0x4fb0bf, 0x4a67f3, 0x4e0559, 0x4ef2d1). Every mutant of each is killed by a seed or explained by a sound automatic rule; no hand-written survivor reasons, no hang kills outside the step budget. **Translated, unverified: about 1,758.** Not port credits.

## What was built

- `scripts/fl41_survivors.py`: `classify(..., cells=None, fn=None)`. `main()` computes `cells` with `fl65_cells.explore` (env `FL65_CELLS=0` disables it) and applies FL-64's `cell_width_ok` / `folded_ok`. `known_compare_ok` now collects EVERY earlier compare-and-jump exclusion on the same cell.
- `scripts/fl65_cells.py`: a copy of the FL-64 explorer that also records the flag tuples (cf, zf, sf, of) seen before each instruction; rule `known flags` (`flags_known_ok`). `cond_of` was reordered so `!=` parses.
- `scripts/fl65_diff.py`: rule `unobserved bits`. Difference propagation over the original instructions (which bits of which registers/flags can still differ between original and mutant), with a z3 per-bit initial difference for `reg = expr;` statements. Statements that touch the FPU, helpers or memory through a pointer return None (never explained). A load dropped through a pointer is refused unless the address is a frame slot or a constant.
- `scripts/fl65_goals.py`: directed killer generator on the FL-61 shadow. Goals: a register changed by the probe instruction, bits above the low byte/half, sign, and the original/mutant jump conditions disagreeing; each solved together with the path conditions (plus one of the next 4 jumps either way). Killed all 3 survivors of 0x4a67f3 in about 2 s.
- `scripts/fl45_ranges.py`: `LOW8` branch, so `xor r,r; mov r8,[m]` gives the register [0,255].
- `scripts/fl60_soundness_all.py` also globs `tasks/fl65/*.txt`.
- Helpers: `fl65_classify.sh`, `fl65_reclass.sh`, `fl65_runrows.sh`, `fl65_one.sh TAG LOG[:BUDGETLOG]`, `fl65_unexpl.py`.

## Soundness evidence

- Sweep (`fl60_rule_sweep.py synth` then `classify`, `fl60_soundness_all.py`): 190 rows, 2,477 mutants called harmless by a rule, none of them killed by a real run except the 7 old `repeat`/`cleanup` contradictions (0x494ccc x3, 0x4c9b25, 0x4c9ca0, 0x4d51c0 x2) already known from FL-63.
- The first sweep found `unobserved bits` wrongly clearing x87 rows 0x4ccacf, 0x4ccb50, 0x4ccbd0 (FPU statements fell back to "flags only"). Fixed.
- `tests/test_fl65_flags.py`: flag facts replayed on the original bytes (131 rows, about 101k tuples, 0 violations). `tests/test_fl65_diff.py`: 10 unit tests.
- Independent Sonnet review found 5 bugs in `fl65_diff.py`: `pop` with a differing esp, `esp += 4u` missing from the compound-assign regex, `sahf` must keep the OF difference, `jecxz/jcxz/loop` branching on a differing ecx, `not` on a memory operand with a differing address, and KeyError treated as Observed. All fixed with unit tests. It also raised the no-fault caveat (a dropped load may have faulted). `fl65_cells`, the fl45 change and the survivor hook were judged sound.

## Result

Clean: 0x495536 (unobserved bits), 0x4fb0bf (killers plus unobserved bits), 0x4a67f3 (value-goal killers), 0x4e0559 (known flags + FL-64 cell range), 0x4ef2d1 (value goals plus generalised known compare). 0x4e0559 and 0x4ef2d1 carry reviewed-blocker receipts in `tasks/fl65-blockers.json` (A-83.1, RT-12, RT-22: gaps in the app around the caller).

## Left (back to "translated, unverified", scenarios saved in `tasks/fl62-covered-rows.json`)

Unexplained survivor counts: 0x4ebe90 88, 0x4ec087 27, 0x4ca81e 19, 0x4a2069 12 (not reclassified with the final rules), 0x4be504 8, 0x4d4074 7, 0x4ebd85 5 (final mutation 174 of 192 killed), 0x4b2c32 3, 0x4e78c2 3, 0x4eaca8 3, 0x48ad26 2 (`rep cmpsb` lines without addresses), 0x4a1fd1 2 (counter-bound width: needs a trip-count rule). Most are `drop cmp` or jg->ja jumps that need relational reasoning (a value range of the compared registers across the loop), or genuine differences no scenario has killed yet. The mutation passes for 0x4a2069 and 0x4be504 produced no output in this thread's time.

## Next ideas

1. A relational rule for `drop cmp` / jg->ja (interval + sign of both compare operands from the cell engine).
2. A trip-count rule for loop-counter widths (0x4a1fd1).
3. Run `fl65_goals.py` with more seeds on the six large rows; give each a fresh definitive mutation log first.

## Regeneration chain used

Oracle docstring row count (178), `record_function_execution.py run --only fl41_original_oracle` (about 3.5 min), `collect --write --merge`, `fl41_accept.py --reviewer ... --blockers-reviewed tasks/fl65-blockers.json` (run it again after adding a blocker receipt: existing acceptances are updated), evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, the ten audits, evidence and ledger again, `--check`. Test edits go BEFORE the last evidence run. The ledger takes more than 2 minutes: run it detached.

## Lessons

- A cited test file edit (here `test_fl52_x87.py`, census floor now 191) changes evidence hashes: rerun evidence and ledger before `test_function_ledger`.
- Do not commit `tasks/fl65/sweep` and `sweep2` (about 16 MB each run; reproducible with `fl60_rule_sweep.py`). Two early commits of this branch did carry them by mistake; they are untracked in the last commits.
- This container has no pytest: run tests with `python3 -m unittest discover -s tests -p FILE`; `test_record_function_execution.py` must run as a script.
- Background jobs die when the container restarts; the mutation passes are resumable from their logs.
