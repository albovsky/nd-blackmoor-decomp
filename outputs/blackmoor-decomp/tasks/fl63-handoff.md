# FL-63 handoff (rows at or above 0x480000, round fifteen): survivor kills and the `movsx` proof gap

Ledger 2,197 (main after PR 207/208) -> **2,202 ported of 4,188** (+5 upper rows: 0x48e93e, 0x4a1f59, 0x4d31ef, 0x4d3eba, 0x4dd28d). Every mutant of each is killed, has identical -O2 code, or is explained by a sound rule; no written reasons. **Translated, unverified: about 1,766** (every pending row still has a translation). Not port credits.

## What was found

- **Proof gap in `scripts/fl43_equiv.py`:** `Function.transfer` ended the facts about memory at any mnemonic that starts with `movs`, `stos`, `cmps`, `scas`, `lods` or `rep` (`STRING_OPS`), so every `movsx` threw away the "this register already holds that load" facts and `drop`/`repeat` proofs after it failed. New `is_string_op` (exact `movs/stos/cmps/scas/lods/ins/outs` x `b/w/d`, plus the `rep*` prefixes). `scripts/fl63_equiv_diff.py` compares old and new proofs on every corpus row: 10 rows change, all gains (0x488da5 0x489722 0x49027c 0x4a1fd1 0x4aaf05 0x4ac498 0x4d040a 0x4d0952 0x4d4410 0x4dd28d), none lost. Soundness: synthetic sweep of those rows (`fl60_rule_sweep.py synth/classify`, `fl60_soundness_all.py`: 84 mutants called harmless, 0 killed by a real seed run); `tests/test_fl47_equiv.py` on the 10 rows checked 3.18 M facts dynamically, 0 wrong; independent Sonnet review: SOUND (it noted `insb/outsb` without `rep` were not caught by either test; they are in the exact set now); `tests/test_fl63_string_ops.py`.
- **Target generator gaps (`scripts/fl62_target.py`):** the cell window next to a survivor was 6 statements back and 0 forward, so a cell read one statement earlier (0x4d3eba: the word that `jg` vs `jge` tells apart) or later (0x4a67f3: the byte after an `xor`) was never varied; and the random cap could drop the near-cell scenarios when the wide families were on. New `--window N --forward N`, near-cell scenarios first, `--shift` (the pointer in ecx moved by 1, 2, 3 bytes with every cell in its region moved along, for partial-register mutants that keep the low bits of `this`) and `--all-cells` (every cell the run reads). `--all-cells` and `--shift` are slow on rows with hang-listed mutants (0x4a1fd1 stalled over an hour): use them on small rows only.
- The previous round's killers had left the corpus with the rows, so each row first re-ran the hardening pass (`fl63_runrows.sh`), then the pooled old scenario files plus new targets (`fl63_pool.py`), then `fl63_classify.sh`.

## Coverage search (priority 2)

`fl62_concolic.py --all` with a 90 s budget per row: 29 of the 56 unsearched rows done (shard 0: 15, shard 1: 14), **none reached full coverage** (reports `tasks/fl63/report-b0.json`, `report-b1.json`; scenarios `conc-0.json`, `conc-1.json`). The first two rows at 240 s were also incomplete. These are the largest rows; this path has not paid. Remaining 27 rows unsearched.

## Left over

- 0x4a67f3 (3 unexplained survivors, all the same `xor ecx, ecx` at 0x4a68a7: needs an index word at [this+0x1e] of 2 or more so ecx has bits above the low byte, and a zero byte at [eax+0x2ce]) and 0x4a1fd1 (2: `mov edx, [ebp-8]` width). Both are out of the corpus again (covered scenarios in `tasks/fl62-covered-rows.json`); re-add with `fl62_add_rows.py ROW --scen` then `fl62_target.py --all-cells` (4a67f3 only).
- The other 15 unexplained upper rows of the FL-62 list (6 to 88 survivors).

## Regeneration chain used

Merge main once; oracle docstring row count (173); `record_function_execution.py run --only fl41_original_oracle` (~5 min) and `collect --write --merge`; `fl41_accept.py --reviewer ...` (80-char cap); `extract_function_evidence.py --write`; `build_function_ledger.py --write`; `function_names.py write`; `annotate_machine.py annotate` (plain, `--named`, `--derived --named`) and `refresh`; all ten `audit_tool_assisted.py --report asm/batch-NNN-report.json asm/batch-NNN.json` (binutils bootstrap ~10 min); evidence and ledger once more, then `--check`. Targeted tests: `test_fl41_differential` (174 tests, 5 min) plus the function-names/ledger/xrefs, `test_fl43..63` modules.
