# FL-48 handoff (rows at or above 0x480000, round six)

Ledger 2,064 (main after PR 175) -> **2,122 ported of 4,188** (+58 upper-address machine-translated rows; `src/original_methods_fl41.c` now holds 134 rows, 76 before). 34 rows of this slice stay held (`tasks/fl48-held-list.json`, reasons in `tests/fl41_pending.json`). Same rulings as FL-46/49: every mutant killed on a seed where the unmutated port matches the original, identical -O2 code, a proven no-op or range rule, or a row-specific written reason confirmed by an independent reviewer; wall-clock timeouts, SIGKILLs and crashes never count; a mutant that does not terminate counts only under the step budget max(100 x unmutated steps, 200,000); no written reason may rely on what a callee does.

Credited: 0x482248 0x482595 0x48b730 0x48e3ca 0x48ea24 0x49027c 0x490d50 0x495a5b 0x49e24d 0x4a3884 0x4a8697 0x4a8bf2 0x4aaf05 0x4ac498 0x4ae96c 0x4afa1e 0x4b4676 0x4bb3de 0x4bf1f0 0x4c0f70 0x4c4b12 0x4c609b 0x4c71f9 0x4c952f 0x4d040a 0x4d0952 0x4d341d 0x4d4410 0x4d4803 0x4d5316 0x4d58eb 0x4d5c54 0x4d65e9 0x4d6705 0x4d6824 0x4d696d 0x4d8618 0x4d9632 0x4dbb13 0x4dbcd0 0x4dd471 0x4e18e5 0x4e1b79 0x4e22fd 0x4e2522 0x4e3093 0x4e3ede 0x4e4a3a 0x4e77b8 0x4e8622 0x4e97ad 0x4eaf2a 0x4ebb5b 0x4ee0d4 0x4ee6c7 0x4ef52a 0x4f57e3 0x4f6624.

Held: 0x48905b 0x489722 0x48efe8 0x494f1f 0x49d1be 0x49d55d 0x4a0d73 0x4a10f1 0x4a4c15 0x4a5eea 0x4ae178 0x4aef4a 0x4af96e 0x4b0f9f 0x4bf8c2 0x4c4c2b 0x4c558b 0x4c5770 0x4c5976 0x4c5d4b 0x4c6c2a 0x4c6e4d 0x4c7ce8 0x4c8408 0x4c8757 0x4c880f 0x4d0275 0x4d5f91 0x4d8fb6 0x4d940a 0x4d9df3 0x4e6548 0x4ea3a0 0x4faa03.

## What was added

- **Harness (`tests/fl41_world.py`, `tests/fl41_mutation_check.py`):** callee-store override `STUB_WR` (a callee stub may also store a dword at a chosen address; applied on both the original under Unicorn and the native side), page caps (40,000 pages native, 30,000 in the original) and `gc.collect` against runaway scenarios, `agrees()` now runs the unmutated translation in a forked child with an alarm (a timeout makes the seed divergent: it kills nothing), `FL48_ALARM`, `FL48_ONLY` (recheck named mutants), `FL48_SAFETY` (strict-scenario wall-clock safety, default 60 s), `FL48_INSTR_LIMIT`.
- **Scripts:** `fl48_onerow.py` (one row per process, no Pool: the Pool wedges when a worker is killed), `fl48_lab.py` (build and save a killing scenario; `--stubwrite`), `fl48_apply.py`, `fl48_only.py`, `fl48_packet.py`, `fl48_grid.py`, `fl48_rules.py`, `fl48_assemble_reasons.py` (writer + independent reviewer -> `tasks/fl48-written-reasons.json`, 265 confirmed reasons in 39 rows; the 16 held rows' reasons are in `tasks/fl48-written-reasons-held-rows.json`).
- `scripts/fl41_survivors.py` classes: 'written reason' and a per-mutant map in its JSON; `scripts/fl45_prune.py` messages.
- ~320 killing scenarios added to `tests/fl41_corpus.json` (labs A to DD), `tests/test_fl48_reasons.py` (statements, addresses, ident required, and the step-budget check: every mutant the budget rerun did not kill is classified), `tasks/fl48-blockers.json` (6 caller-side blockers).
- Logs: `tasks/fl48-mutation-log-*.txt` (rounds), `tasks/fl48-merged-e.txt` (merged, with the step-budget survivors), `tasks/fl48-budget-log-*.txt` (step-budget rerun of 1,508 hang-listed mutants in 64 rows), `tasks/fl48-budget2-log-*.txt` (a rerun of the 76 left over, 60 s alarm), `tasks/fl48-survivors-5.json`, `tasks/fl48-survivors-final.json`.

## Findings worth knowing

- The diff review found a bug in my own merge of the budget survivors (a negative `killed` count made `fl41_survivors.py` skip the row's line, and a 'killed only by an extra seed' label hid hang kills): six rows that looked clean were held (0x48905b 0x48efe8 0x4aef4a 0x4c4c2b 0x4c5d4b 0x4af96e). `scripts/fl41_survivors.py` still silently skips a line it cannot parse; `tests/test_fl48_reasons.py::StepBudget` now guards the credited rows.
- A mutant listed as hang-killed in a normal run is usually a slow scenario on which the unmutated port also misbehaves; the strict rerun then finds no difference and no budget hit (the 76 left over with a 60 s alarm and 0x4c5770 with 600 s: still alive). Those need a written reason or a killing scenario.
- Callee-store kills (`--stubwrite`) settled most "a callee could rewrite this frame cell" rejections.
- Not killable in the default harness: 0x494f1f width mutants (a 16-bit loop counter needs 65,536 iterations, beyond `FL48_INSTR_LIMIT` 4M; 12M works), 0x4d940a (needs `this` to land on the loop's own stores).
- Six rows are too large or slow (about 560 mutants between them): 0x49d1be 0x4c6c2a 0x4c6e4d 0x4d5f91 0x4d9df3 0x4ea3a0.

## Open questions for Glib

- About 80 written reasons rest on a stated assumption (an argument pointer does not alias the function's own frame or a global it writes; frame slots change only through explicit stores; 4-byte-aligned entry stack; no scan of 2^31 bytes). A stricter reading could drop them. Recommendation: keep (FL-46/49 precedent).
- Seven credits with an untaken jump direction from earlier rounds (see FL-49 notes).

## Regeneration order (used here)

fl45_prune -> `fl41_accept.py --reviewer ... --blockers-reviewed tasks/fl48-blockers.json` -> commit -> `record_function_execution.py run --only fl41_original_oracle` in a scratch worktree (the oracle docstring row count changes its hash), `collect --write --merge` -> `extract_function_evidence.py --write` -> accept -> evidence -> `build_function_ledger.py --write` -> `function_names.py write` -> `annotate_machine.py annotate` (plain, `--named`, `--derived --named`) -> `refresh` -> 10 `audit_tool_assisted.py` batches (needs the pinned binutils 2.43.1) -> ledger again -> every `--check`. Editing a cited test file (here `tests/test_fl46_verdicts.py`) changes its evidence hash: rerun evidence and ledger.

## Left for the next upper-address thread

- The 34 held rows. Start with the small ones: the budget-surviving mutants of 0x4c5976 0x4a0d73 0x4a4c15 0x4d0275 0x4d8fb6 0x4bf8c2 0x4ae178 0x4a5eea 0x4a10f1 (1 to 2 each) need a written reason or a killing scenario; `tasks/fl48-budget2-log-*.txt` lists them.
- Rows with x87 code wait for FL-51's floating-point model.
