# FL-62 handoff (rows at or above 0x480000, round fourteen): FL-61's concolic coverage generator on the upper rows

Ledger 2,189 (main after PR 204; merged as PR 207) -> **2,197 ported of 4,188** (+8 upper rows: 0x4a1e93, 0x4ba262, 0x4be2c6, 0x4bf297, 0x4d57e8, 0x4de322, 0x4e1305, 0x4e8d72). Every mutant of each is killed, has identical -O2 code, or is explained by a sound rule; no written reasons. **Translated, unverified: about 1,771** (every pending row still has a translation). Not port credits.

Credits by row size: 36 bytes (1), 76 (1), 91 (1), 106 (1), 114 (1), 126 (1), 161 (1), 223 (1). Six of the eight are 100 bytes or more; FL-60's plain automation credited 0 of 197 rows from 100 bytes up. 0x4e1305 needed one reviewed A-51/RT-22 blocker rationale (`tasks/fl62-blockers.json`).

## What was built

- `scripts/fl62_concolic.py`: FL-61's generator on the FL-41/FL-58 world (callee stubs, import slots, `__EH_prolog`). Start registers are overridable (`REG_OVERRIDE` 0xffff0000+4*idx), callee-stub results (`STUB_OVR`) and stub stores (`STUB_WR`) are overridable; output is the corpus scenario format `[seed, [[address, size, value], ...]]`.
- `scripts/fl62_add_rows.py` puts a translated row into the corpus once the kept seeds plus generated scenarios reach full coverage (every instruction runs, both directions of every jump). `scripts/fl62_bank.py` settles the rows afterwards: clean rows stay, others go back to translated, unverified and their complete-coverage scenarios are kept in `tasks/fl62-covered-rows.json` (61 rows) so a later round starts from full coverage.
- `scripts/fl62_boundary.py`, `fl62_target.py`, `fl62_onerow.py`, `fl62_pipe.py`, `fl62_classify.sh`, `fl62_status.sh`, `fl62_stagec.sh`, `fl62_runrows.sh`: the per-row pipeline. Stage A is the exhaustive mutation check without generated boundary scenarios; stage B adds boundary scenarios only for rows with unexplained survivors; stage C targets individual survivors with a z3 search (`fl62_target.py`). Hang-listed mutants are rerun under the step budget. `fl62_status.sh TAG` prints the clean and unexplained rows from the finished logs.
- Two new sound survivor rules in `scripts/fl41_survivors.py`, each swept over the whole corpus and reviewed by an independent Sonnet (holes found in the second review were fixed and tested, `tests/test_fl62_forward_rule.py`, 15 tests):
  - `forwarded store`: a dropped reload of a cell that the same block stored just before (no barrier, no partial write between).
  - `known compare`: a jump whose condition is decided by a compare against a known constant on the same register (`known_compare_safe`, strict `JUMP_STMT`, rejects ebp changes and partial register writes).
- `tests/fl41_world.py`: `REG_OVERRIDE`, `watch` hook, `trace.read_pcs`. `tests/fl41_mutation_check.py`: `--scen`, `agrees()` guard so a kill counts only where the unmutated translation equals the original.

## Coverage and yield

The 166 rows FL-60 refused for incomplete coverage were searched smallest first: 110 searched, **72 reached full coverage**; 56 remain unsearched (the biggest). The shard stuck on 0x4ae178 for 90 minutes was skipped (pre-seeded as skipped in the out/report files).

Of the 72 covered rows: 30 got a definitive mutation log, 8 are clean, 22 have unexplained survivors, the rest were not finished. Unexplained rows and their survivor counts (stage C included): 0x48e93e 1, 0x4a1f59 1, 0x4d31ef 1, 0x4d3eba 1, 0x4dd28d 2, 0x4a1fd1 3, 0x4a67f3 3, 0x4e0559 4, 0x495536 6, 0x48ad26 7, 0x4e78c2 8, 0x4eaca8 8, 0x4be504 9, 0x4fb0bf 9, 0x4a2069 12, 0x4b2c32 12, 0x4d4074 12, 0x4ebd85 15, 0x4ef2d1 21, 0x4ca81e 30, 0x4ec087 51, 0x4ebe90 88. The first seven (1 to 3 survivors) are the best next targets: each is probably one equivalent mutant that needs value-flow reasoning.

Reading: coverage is no longer the wall for mid-size rows; survivors are. What is left are mostly equivalent mutants (a changed constant or flag that no later instruction can observe) that need either a value-flow rule (what is live after this point) or a directed killing scenario. Larger rows (above about 300 bytes) mostly time out under the 20-minute row cap or carry dozens of survivors.

## Ideas for the next round

1. A liveness-based `dead flag/dead register` rule built on the same region scan as `known compare`; sweep and review it like the other two.
2. Run stage C (`fl62_target.py`) on the seven rows with at most 3 survivors first.
3. The 56 unsearched rows: run `fl62_concolic.py --all --shard i/n --skip-reports tasks/fl62/report-a0.json,tasks/fl62/report-a1.json,tasks/fl62/report-a2.json` with a lower per-row budget; skip rows that stall more than 20 minutes.

## Regeneration chain used (for the next credit PR)

Oracle docstring row count (168), `record_function_execution.py run --only fl41_original_oracle` (about 3 min), `collect --write --merge`, `fl41_accept.py --reviewer ... [--blockers-reviewed tasks/flNN-blockers.json]` (the reviewer text is limited to 80 characters), `extract_function_evidence.py --write`, `build_function_ledger.py --write`, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, then **all ten batches**: `python3 scripts/audit_tool_assisted.py --report asm/batch-NNN-report.json asm/batch-NNN.json` (needs the pinned assembler from `scripts/bootstrap_matching_s08_2_gas.sh`, about 8 min, in `work/tools/s08-binutils-2.43.1`), then evidence and ledger once more.

## Lessons

- The ledger caps the reviewer text at 80 characters; an overlong one fails as "invalid text" with no field name.
- Never type rm; no background job can be interrupted from Python, kill explicit pids. Jobs die when the container restarts; the pipeline is resumable from out/report files.
- Do not commit `tasks/fl62/sweep` and `sweep2` (about 16 MB of rule-sweep output, reproducible with `fl60_rule_sweep.py`).
