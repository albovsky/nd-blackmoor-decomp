# FL-50 handoff (rows below 0x480000, round six)

Ledger 2,059 (main after PR 174) -> **2,064 ported of 4,188**. Of the 337 translated rows below 0x480000, 244 are credited (239 before, +5: 0x41608b, 0x41e33b, 0x448084, 0x459aea, 0x468e5a) and 93 are held. Same rulings as FL-49: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, or a reviewed row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget max(100 x unmutated steps, 200,000).

## What was found

- **Harness gap (fixed, `tests/fl40_mutation_check.py`, `first_mismatch`):** under `FL46_BUDGET=1` a mutant that ran over the quick budget (100 steps floor) on a scenario was only confirmed on the full budget as a hang. A mutant that then *finished* inside the full budget and differed from the original (a 16-bit loop counter that wraps after about 65,000 turns, for example 0x41608b's `add ax, 1` -> `sub ax, 1`) was thrown away and showed as a survivor. It now counts as killed by the difference. This is the definition of the ruling (a mutant inside the budget that ends differently is an ordinary kill); it adds no new kind of kill.
- Re-run of 77 of the 91 checked held rows under the fixed harness: `tasks/fl50-recheck-log.txt` (resumable: `scripts/fl46_driver.py --log ... --rows-file ...` with `FL46_BUDGET=1`). The 14 biggest rows (>= 42 unexplained survivors before: 0x415aea 0x449ef8 0x44a6f2 0x468aeb and the ones after them in the file order) were not re-run; the fix is unlikely to matter there.
- Large rows: 0x440dfc (1,410 mutants) and 0x41a4c9 (864) were checked in windows (`scripts/fl50_merge_windows.py`, log `tasks/fl50-large-log.txt`): 186 and 117 unexplained survivors, mostly width and drop mutants. Not credited. 0x4033db 0x404be1 0x43f31a 0x43ff18 0x478f91 (1,674 to 2,584 mutants) were not tried.
- **Rule soundness is done for all 172 rows**: FL-49 did 85, `tasks/fl50-rule-check-log.txt` the other 87 (249 lines, 600 seeds from base 40000, `FL46_STRICT_HANG=1`): zero kills, so no liveness rule is disproved.

## What the rest of the held rows look like

Checked one by one for the single-survivor `drop` rows: most are differences that only show if a *callee* rewrites a variable (for example 0x426c51 line 36: the dropped `test eax, eax` re-tests a word that was tested before two calls; the stale flag is the same unless a callee zeroes the word). That is not equivalent without a statement about the callee, which the rules forbid, and the oracle stubs callees, so these stay held.

## Regeneration order after a merge of main

Same as FL-49 (`fl40_accept.py --reviewer ... --blockers-reviewed tasks/fl40-blockers.json`, `extract_function_evidence.py --write`, accept, evidence, `build_function_ledger.py --write` (no `--blockers-reviewed` option on the ledger), `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, `audit_tool_assisted.py asm/batch-NNN.json --report asm/batch-NNN-report.json` for the batches whose sources changed (here 003 and 004; needs the pinned binutils 2.43.1: fetch `binutils_2.43.1.orig.tar.xz` from old-releases.ubuntu.com into `work/tools/s08-binutils-2.43.1/binutils-2.43.1.tar.xz`, run `scripts/bootstrap_matching_s08_2_gas.sh`, about 10 min), then the ledger again and every `--check`). Editing any test file changes its evidence hash: rerun `extract_function_evidence.py --write` and the ledger.

## Left for the next lower-address thread

- 93 held rows in `tasks/fl40-held-rows.json`; 5 large rows still never checked; the 14 biggest held rows were not re-run under the fixed harness.
- A real fix for the callee-dependent drops would need the stub model to let a callee write chosen values to chosen cells (a killing seed), not a written reason.
- Still open from FL-49: about 78 written reasons rest on a stated aliasing assumption; seven credits with an untaken jump direction.
