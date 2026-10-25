# FL-53 handoff (rows below 0x480000, round eight)

Ledger 2,137 (main after PR 177) -> **2,157 ported of 4,188**. Of 368 translated rows below 0x480000, 279 are credited (259 before, +20) and 89 held. Same rulings as FL-49 to FL-51: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, a rule or a reviewed row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget max(100 x unmutated steps, 200,000). No new written reasons this round.

## The 20 credited rows

- **10 `repe cmpsb` clones** 0x40af5d 0x40afaf 0x40b001 0x40b053 0x40b0a5 0x40b0f7 0x40b149 0x40b19b 0x40b1ed 0x40b23f: new rule `carry only` (`carry_only` in `scripts/fl46_rules.py`, called from `scripts/fl40_survivors.py classify` and `scripts/fl46_rule_check.py`). In `{ uint32_t a_ = RD8(x), b_ = RD8(y), r_; FL40_SUB/ADD(a_, b_, 0u, r_, 8); }` a wider read changes only `cf` (FL40_ADD/FL40_SUB mask the result to 8 bits, take `of` from bit 7 and zf sf pf from the masked result), and the rule requires that `cf` is read nowhere in the function and the carry-in is the constant 0u. It covers C loops, which the liveness analysis skips. Like `masked read` it assumes that no real read reaches the top of the model's address space. Soundness check (`fl46_rule_check.py`, then the harness `--rescue --base 40000 --seeds 300` on the claimed lines, 46 rows): zero kills. The Sonnet diff review confirmed the algebra, the mutation operator (one widening per line, never a narrowing) and the cf-reader list; its tightening (the statement must end in `); }`) was applied.
- **10 rows by targeted seeds** (`scripts/fl49_targeted.py`; 7 of them were `ecx -= 1` drops in inlined `rep movsd` or other single survivors): 0x426428 0x433c60 0x44551b 0x4456e1 0x445b26 0x447e83 0x455b2e 0x466247 0x46f907 0x43d6be. Seeds are in `tests/fl40_corpus.json`; the full exhaustive recheck under `FL46_BUDGET=1` is `tasks/fl53-mutation-log.txt` (listed in `scripts/fl44_final.py`). A few appended seeds are duplicates of existing ones (0x43d6be, 0x478e7b, 0x466247): harmless, the seed count in the acceptance note is slightly high.

## Left for the next lower-address thread

- 89 held rows (`tasks/fl40-held-rows.json`). 0x41c29a: its targeted seeds cleared the survivor but the exhaustive recheck ran past an hour twice and was stopped; rerun it in `--window` slices (202 mutants). 0x46e823 and 0x478e7b: the full run has more survivors than the targeted search covered. Rows with 4-8 survivors where the search found nothing: 0x425f25 0x42e34e 0x44a32c 0x44c384 0x43ef3b 0x4540bd 0x45432f 0x467b9e 0x478684 (0x45ea4a has one left). Seeds found for 0x42e34e 0x44a32c 0x43ef3b 0x4540bd 0x45432f 0x45ea4a are not applied (their rows are not clean yet).
- Not attempted this round: the x87 leftovers of `tasks/fl51-handoff.md` (refused callee rows, 9 incomplete-coverage rows, 0x4523b5 0x46a98e 0x473ac5) and the 8 never-checked large rows (0x4033db 0x404be1 0x43f31a 0x43ff18 0x4523b5 0x46a98e 0x473ac5 0x478f91).
- Open questions for Glib are unchanged (assumption-based reasons, seven credits with an untaken jump direction).

## Lessons

- `fl49_targeted.py` is cheap on rows with 1-3 survivors (seconds to minutes) and hopeless on rows with dozens; order the rows by survivor count and cap the run, a few heavy rows otherwise hold all four workers for an hour.
- A survivor that differs only in a dead flag needs a rule, not a seed: the clone rows had no killing seed to find.
- Regeneration: `fl40_accept.py`, oracle record (edit the oracle docstring so its hash changes: `run --only fl40_original_oracle`, `collect --write --merge`), evidence, accept, evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, all ten audits (pinned binutils from old-releases.ubuntu.com, bootstrap script about a minute), ledger.
