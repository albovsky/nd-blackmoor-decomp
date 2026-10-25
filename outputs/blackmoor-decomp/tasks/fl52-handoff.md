# FL-52 handoff (rows at or above 0x480000, round seven)

Ledger 2,157 (main after PR 184, FL-53) -> **2,165 ported of 4,188** (+8 upper rows). Same rulings as FL-48 to FL-53: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, a proven rule or a reviewed row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget max(100 x unmutated steps, 200,000) and are listed separately.

## The 8 credited rows

0x488da5 0x489722 0x48e776 0x48e9bf 0x4959ea 0x4a0cea 0x4a6bde 0x4af96e. The final accounting is `tasks/fl52/final2/{merged.txt,o2.json,surv.json}` (0 unexplained mutants in all 8 rows). Pure-kill rows: 0x48e9bf 0x4a0cea 0x4a6bde. Rows with reviewed written reasons (`tasks/fl52-written-reasons.json`, each reason confirmed by an independent Sonnet reviewer, who did not see my conclusion): 0x488da5 (6), 0x489722 (5), 0x48e776 (7), 0x4959ea (2), 0x4af96e (2). Several of these rest on the no-alias / "slot written only by explicit stores" assumption: they belong to Glib's open assumption question (recommendation: keep), as do the FL-48 and FL-49 reasons. 0x489722 also needed a reviewed blocker receipt (`tasks/fl52-blockers.json`: RT-14 and RT-18 items about the app's overlay and render-pass behaviour around the caller, not this function).

## New in the toolchain

- **x87 on the FL-41 stack** (ported from FL-40 after FL-51): `src/original_methods_fl41_x87.h`, x87 operators in the mutation check, float seeds from 100000, Win32 control word 0x27f, callee classification (`fpu_net`). Tests: `tests/test_fl52_x87.py` (its census assertion counts the pending x87 rows, so it drops whenever x87 rows are credited).
- `scripts/fl52_pipe.py` (resumable `FL52_TAG` pipeline: mutation log, hang list, step-budget log per row), `scripts/fl52_merge.py` (merges normal and budget logs; hang-listed mutants stay survivors unless a budget log kills them, and it aborts if the budget log accounts for neither a kill nor a survivor), `scripts/fl52_restore.py` (moves rows and their corpus entries between checkouts), `scripts/fl52_cover.py` (adds callee-return overrides to the coverage search; written, not yet used in anger), `scripts/fl48_lab.py --hang-save` (saves a scenario that kills nothing so the normal run lists the hanging mutant for the budget rerun).
- `tests/test_fl52_reasons.py` checks the written reasons (statement match, length, in-function addresses, ident exists) and the final accounting (every hang-listed mutant killed by a budget log or classified). `tests/test_fl48_reasons.py` now skips the two FL-48 rows (0x489722, 0x4af96e) that FL-52 re-checked with its own accounting.

## Left for the next upper-address thread

- Held, one unexplained mutant left: **0x4adae8** (width, line 14, a hang; reasons for the others are in `tasks/fl52-written-reasons-held-rows.json`).
- In the targeted search, not clean: 0x4a4c15 0x4b0f9f 0x48efe8 (8 scenarios, 6 mutants alive) 0x48ad26 0x4be2c6 0x4c4c2b 0x4be504.
- First-pass rows queued but not checked: 0x4c5d4b 0x4a5eea 0x48905b 0x494f1f 0x49d55d 0x4a10f1 0x4aef4a and others in `tasks/fl52/`. x87 rows: only 5 of 37 generated seeds in the second pool (`gen2`); rows with an untaken jump direction need coverage help (`fl52_cover.py`).
- The six too-large rows stay skipped (0x49d1be 0x4c6c2a 0x4c6e4d 0x4d5f91 0x4d9df3 0x4ea3a0).

## Lessons

- **Containers reset when idle** and kill background jobs: use per-row resumable scripts, push the branch early, and bank a batch as soon as a few rows are clean (a separate bank worktree holds the PR branch, pruned to the credited rows, while the working checkout keeps everything).
- Loops of 65,000 iterations need a long wall-clock safety (`FL48_SAFETY=1500`) for the step-budget rerun, otherwise the safety fires before the budget and the run reads "inconclusive hang". Rerun only the surviving idents with the long safety.
- A hang mutant is invisible to the lab (the alarm kills the process); use `--hang-save` with a scenario whose loop bound is large and also set the argument cell, otherwise the loop exits early and the scenario agrees by chance.
- The "killed only by an extra seed" label can coincide with a hang-listed mutant (also the FL-48 merge bug); `fl52_merge.py` keeps those as survivors until a budget log kills them.
- Regeneration order: `fl41_accept.py --reviewer ... --blockers-reviewed tasks/fl52-blockers.json` (it updates existing acceptances too), oracle record (the oracle docstring row count changes its hash), `collect --write --merge`, evidence, accept, evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, the ten audits (pinned binutils in `work/tools/s08-binutils-2.43.1`), ledger again, every `--check`. Editing a cited test file (`test_fl52_x87.py`) changes its evidence hash: rerun evidence and ledger.
- Full suite: 375 files, 127 fail on the branch; the same 127 fail on clean main (Mac-bound), apart from the two FL-52 test fixes above.
