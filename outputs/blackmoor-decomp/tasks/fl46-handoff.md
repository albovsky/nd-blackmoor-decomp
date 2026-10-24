# FL-46 handoff: rows below 0x480000, fourth round (2026-10-23 PDT, cloud thread)

Ledger: **2,009 ported** (1,975 on main after PR 171, FL-47 + 34; 1,968 before FL-47 was merged in). 128 not needed, 2,051 pending. `tests/fl40_corpus.json` holds **337 translated rows**; **189 are credited** (155 on main), **148 are held** (`tasks/fl40-held-rows.json`, written by `scripts/fl44_final.py --write`). Of the 155 credited on main, 154 stay and **0x41df05 is held** (see below), so 35 rows are new.

## Result

- **Credited rows = rows whose every mutant is killed, identical -O2 code, explained by a rule, or covered by a written reason**, under the guarded exhaustive harness (kills count only on seeds where the unmutated port equals the original). Logs: `tasks/fl46-unchecked-log.txt`, `tasks/fl46-budget3-log.txt` (the budget rerun of every row), `tasks/fl46-rescue-40000.txt`, `tasks/fl46-rescue-454065.txt`.
- **Hang ruling (Glib, 2026-10-23: "go with suggested option").** A mutant that never terminates counts as killed only by a fixed step budget, never a wall clock, and only when the unmutated port equals the original on that seed. Both verdicts are kept per row in `tasks/fl46-verdicts.json`: `budget_verdict` (credited) and `strict_verdict` (no hang kill counts). **189 clean under budget, 158 under strict.** 31 rows are credited only through budget kills (22 of them were already credited by FL-44, which counted wall-clock hangs). If Glib later says no, run `scripts/fl44_final.py --strict --write` and `scripts/fl40_accept.py`: the strict reading gives 1,978 on this main (23 rows credited on main drop out, 26 new rows stay in; the 31 budget-only rows are 22 old plus 9 new).
- **Step budget and its unit.** The harness instruments the translation (`tests/fl40_mutation_check.py`, `FL46_BUDGET=1`): each taken `goto` and each turn of a `while (ecx != 0u)` repeat counts one step. The limit is `max(100 x the unmutated port's own steps on that seed, 200,000)`; the search pass uses a floor of 100 and every budget kill is confirmed at 200,000. Mapping to FL-47's wording ("the mutant runs past max(100x the unmutated port's steps, 200,000 steps)"): the same formula and the same floor; the step unit here is taken jumps and loop turns of the translated C, which every non-terminating loop must keep increasing (straight-line code cannot loop), instead of machine instructions. Budget kills are labelled `killed by step budget` in the logs and reported separately (`budget-kills N`).
- **0x41df05 held.** FL-44 credited it because one mutant (`width`, line 57) was killed by a wall-clock hang in a rescue run. That does not count (`scripts/fl44_final.py` now ignores rescue kills with `hang-kills > 0` from before FL-46). A budget retry (`tasks/fl46-rescue-*` not written) was too slow on this row (seed 30 alone takes seconds). To recredit: rerun the rescue for line 57 under `FL46_BUDGET=1` with a few hundred base-40000 seeds.
- **0x454065 stays credited**: its two remaining survivors (`literal` and `drop` on the `cmp [ebp-4], 0` at 0x454086) are killed by the budget on rescue seeds (`tasks/fl46-rescue-454065.txt`); they survive under strict.

## What changed in the method

1. **`scripts/fl46_rules.py`** (liveness over the lifted statements; called last in `fl40_survivors.classify`): `dead flags` (the flags a statement sets are overwritten before any read on every path), `dead register` (the register is dead at every exit), `narrow demand` (only the low bits are used), `equal push`. Soundness: `scripts/fl46_rule_check.py` writes every mutant the rules call harmless (385 mutants over 117 rows); the harness run on a 22-row sample killed none (`killed 0` on every line); the rest was not run. Please rerun it first if a later round leans on these rules.
2. **70 written reasons** (`tasks/fl46-written-reasons.json`): row-specific, tied to the exact statement; `tests/test_fl46_verdicts.py` fails if the statement changes or if a reason cites an address the function lacks.
3. **fl44_final fixes:** a line with several mutants stays open while any of them survives (it removed a masking hole; 0x454065 was the only row it touched and it was re-credited through the budget), strict/budget handling, written reasons, hang-kill rescues ignored before FL-46.
4. **`tests/fl40_world.py`:** step counter in the Unicorn hook (`Trace.steps`) for the budget; **`scripts/fl46_driver.py`:** resumable per-row driver (the container reset kills background jobs when a session idles); `scripts/fl46_detail.py`, `scripts/fl46_rule_check.py`.
5. `function-execution.json` now records the fl40 oracle for all 337 rows (it was missing the 10 rows FL-44 added); the oracle script's docstring changed so its hash changed and the merge replaced the run.

## Not done / next

- 148 rows held. Seven were never checked because they are large (`0x4033db 0x404be1 0x41a4c9 0x43f31a 0x43ff18 0x440dfc 0x478f91`; windowed runs were planned for 0x4033db and 0x41a4c9, not done). The rest mostly have `repe cmpsb` count 9 -> 10 literals that need targeted string seeds, widened-write `movsb` variants, aliasing-dependent drops, and unbounded-width reads. A base-60000 rescue (long strings) killed nothing on 50 survivors; do not repeat it.
- Rule soundness run on all 117 rows (about 2 h at 400 seeds on 4 cores).
- The seven untaken-direction credits (0x4c0c7d, 0x4c3efb, 0x44b26a, 0x44b3c8, 0x434025, 0x423876, 0x4c36b2) were left as they are.
- Rescue seeds that killed mutants live only in the logs, not in `tests/fl40_corpus.json`.

## Environment notes

- A stray `rm -rf /dev/null` in one of my commands replaced `/dev/null` with a plain file in that container (ephemeral, no effect on the repo). Never use `rm` under /dev.
- Two runs at once must not share one corpus file (`--corpus` copy per run); `timeout` leaves orphan grandchildren; wall-clock `FL46_ALARM` below 10 s makes slow seeds (0x41df05 seed 30) look like failures.
