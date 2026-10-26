# FL-64 handoff (lower rows, round fifteen): sound survivor rules built on an explicit-state value engine

Ledger 2,202 (main after FL-63, PR 210) -> **2,205 verified ported of 4,188** (+3 lower rows: 0x467c0e, 0x44ecaf, 0x45bbd8). Every mutant of each is killed by a seed or explained by a sound rule; no written reasons, no hang kills outside the step budget. **Translated, unverified: about 1,763.** Not port credits.

## What was built

- `scripts/fl64_cells.py`: an explicit-state value engine (`explore(va, size)` -> `Facts` with `.reads`, `.sizes`, `.regs`, `.states`, or None with the reason in `LAST['why']`). It tracks, per instruction, the set of values of every register and of every memory operand read, over concrete numbers and symbolic bases (`('s', name, offset)` for a start register or an argument slot, `('lo', bits, v)` for a known low part). Cells are frame slots, object fields (symbolic base plus offset), globals. Equality refinement on `je`/`jne` after a `cmp` (bounds stored in a field and tested earlier). State cap 60,000, otherwise the row is refused. It rests on the same frame no-alias assumption as FL-48/49/52 (a store through a pointer does not change a frame slot); the open question for Glib about that assumption is unchanged.
- `scripts/fl64_rules.py`: `explain(kind, lines, n, row, variants, ranges, proofs, cells)`.
  - `lower_rules`: FL-41's classifier with FL-45's interval ranges, reused on the lower rows (FL40_ renamed to FL41_ in the text and in the mutant line).
  - `cell range` (`cell_width_ok`): a narrower read (RD32 -> RD16/RD8, RD16 -> RD8) of a cell whose value in every reachable state is below the narrow limit. Covers loop counters, object-field bounds, stored constants.
  - `folded constant` (`folded_ok`): the register operands of a pure statement are one of a few known constants (or known low parts) in every reachable state, and a z3 query shows the mutated statement computes the same value for every value of the rest.
  - A (kind, line) from a lower log carries no mutant id, so a line is explained only when EVERY variant the checker builds for it is explained.
- `scripts/fl40_survivors.py --fl64` and `scripts/fl44_final.py` (lazy `fl64_ctx` fallback, `fl64-mutation-log.txt` in `LOGS`, pinned in `tests/test_fl46_verdicts.py`).
- `scripts/fl64_sweep.py`: corpus-wide soundness sweep of the rules against every lower log. `tests/test_fl64_cells.py`: Unicorn replay of the original bytes on corpus seeds against the engine's sets (`--world 40|41`).
- `scripts/fl61_boundary.py`: `0x101` added to the edge sizes for 2 and 4 bytes.

## Soundness evidence

- Sweep (`scripts/fl64_sweep.py --jobs 3 --rows ...`): 370 lower rows, **2,101 mutants explained by the new rules, 0 of them killed by any real run**. Row 0x425f25 is excluded (the first sweep hung on it, a pool worker was lost); it carries no credit from these rules.
- Unicorn replay: world 40, 239 rows checked (141 skipped by the engine), about 2.0 M value checks, 0 violations (before the review fixes; rerun result in the PR).
- Independent Sonnet review (code only, no conclusion): no unsound verdict. It found two engine holes, both fixed here: symbolic offsets were not wrapped modulo 2^32 (`add reg, -4` gave +0xfffffffc, so a store missed a cell it overwrote; now `wrap()`), and `jp`/`jnp`/`jcxz`/`jecxz`/`loop*` were not followed (now the row is refused). A throwaway differential fuzz of about 3,000 random programs and 600 single-instruction cases against Unicorn found no register or memory mismatch.
- Process fragility the reviewer noted: the variants of a line are regenerated with the checker's `Random(va)` and `mutants()`; if `mutants()` changes, old logs stop matching.

## Result

The three rows had full coverage and only `width` and constant-folded `literal` survivors. After scenario work (boundary, compare-goals, one aliasing seed from `tasks/fl64/scen-alias.json`, committed in `tests/fl40_corpus.json`) every other survivor was killed and the rest are explained: 0x467c0e 31 explained, 0x44ecaf 19, 0x45bbd8 8; final exhaustive log `tasks/fl64-mutation-log.txt`, classification `tasks/fl64/surv-final.json`. The 91 held lower rows are unchanged: their survivors are mostly reads the engine cannot bound or rows without full coverage.

## For FL-65 (upper rows)

- The upper classifier is `scripts/fl41_survivors.py`. Hook the engine in the way `fl40_survivors.fl64_context` does (it builds the engine facts, ranges and proofs for a row); `fl64_rules.cell_width_ok` and `folded_ok` need only `lines`, the variants and `cells`, and use `FS.read_change` after the FL40_->FL41_ rename, so for upper rows skip `to41`.
- Run the sweep over the upper logs before any credit, then reclassify the FL-62/FL-63 upper survivors.
- Engine refusals: `LAST['why']` says why (more than 60,000 states, esp/ebp-indexed operand, a conditional transfer it does not follow).

## Regeneration chain used

Oracle docstring edit (FL-64 added to the first line), `record_function_execution.py run --only fl40_original_oracle` (about 90 s), `collect --write --merge`, evidence, `fl40_accept.py --reviewer ...` (80 characters), evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, `audit_tool_assisted.py asm/batch-0NN.json --report asm/batch-0NN-report.json` for all ten batches (pinned binutils: archive from old-releases.ubuntu.com into `work/tools/s08-binutils-2.43.1/`, `scripts/bootstrap_matching_s08_2_gas.sh`), evidence and ledger again, `build_function_ledger.py --check`.

## Lessons

- `tests/test_fl46_verdicts.py` takes about 6 GB; running it beside a multiprocessing job got the replay OOM-killed (exit 137). Run it alone.
- A multiprocessing pool silently hangs when a worker is OOM-killed; print per-row progress and give the sweep a per-row alarm.
- Rows that are not accepted must stay in `tasks/fl40-held-rows.json` or `tests/test_fl46_verdicts.py` fails (`test_acceptance_exactly_for_the_rows_that_are_not_held`); run acceptance before that test.
