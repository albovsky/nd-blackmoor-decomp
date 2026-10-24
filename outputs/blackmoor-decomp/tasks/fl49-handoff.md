# FL-49 handoff (rows below 0x480000, round five)

Ledger 2,011 (main after PR 172) -> **2,059 ported of 4,188**. Of the 337 translated rows below 0x480000, 239 are credited (191 before, +48) and 98 are held. All credits follow Glib's rulings: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, or a row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget (labelled separately).

## What was added

- `scripts/fl49_targeted.py`: for each surviving mutant of a held row, builds scenarios around the mutated instruction by overriding memory cells (and, with `FL49_NEIGHBOURS=1`, the bytes next to a read, plus equal-strings and next-byte scenarios for `cmps`). Scenarios that make the mutant differ and keep the unmutated port equal to the original are appended to `tests/fl40_corpus.json` as `[seed, [[addr, size, value], ...]]` (about 65 new seeds on about 40 rows). Options: `--held`, `--rows`, `--only`, `--detail`, `--seeds`, `--jobs`, `--out`, `--resume`, `--apply`. The neighbour pass is slow; run it on a few rows only.
- `FL49_DETAIL=1` in `tests/fl40_mutation_check.py`: prints one `DETAIL` line per surviving mutant (kind, line, statement text), so a writer sees exactly which mutants are open.
- `scripts/fl49_assemble_reasons.py`: merges Sonnet writer files with independent Sonnet reviewer files into `tasks/fl49-written-reasons.json`. Only reviewer-"confirmed" reasons are kept; `statement` is refilled from the current line. 263 confirmed reasons in 70 rows. `scripts/fl44_final.py` and `tests/test_fl46_verdicts.py` load every `tasks/fl4*-written-reasons.json`.
- Rechecks: `tasks/fl49-recheck-log.txt`, `fl49-recheck2-log.txt`, `fl49-recheck3-log.txt` (added to `LOGS` in `fl44_final.py`).
- `tasks/fl40-blockers.json`: rationales for 0x42639d (20 ids) and 0x45741d (1 id).
- `tests/fl40_original_oracle.py` docstring edit (changes the oracle script hash so `record_function_execution.py` replaces the FL-40 run).

## Accepted assumptions in the written reasons

ecx, edx and flags are scratch at return; frame slots are written only by explicit ebp-relative instructions; extra reads are side-effect-free. Reasons must be 80+ characters and cite only instruction addresses inside the function.

## Open items for the next lower-address thread

- 98 held rows in `tasks/fl40-held-rows.json`. Classes: mutants the harness cannot show (stub model preserves flags across calls, so flag-only differences after calls are invisible), not-equivalent mutants with no killing seed found, and rows whose reasons the reviewer rejected.
- 7 large rows never mutation-checked: 0x4033db 0x404be1 0x41a4c9 0x43f31a 0x43ff18 0x440dfc 0x478f91.
- Rule soundness: the liveness rules were rechecked on 85 of 172 rows (`tasks/fl49-rule-check-log.txt`). No real disproof. The one flagged line, 0x41df05 register mutant 27, was a wall-clock hang on a known-slow row (the mutant is zf-equivalent); rerun it with `FL46_STRICT_HANG=1`. The other 87 rows are unchecked.
- Reviewers were lenient (almost every writer reason was confirmed). The next thread should spot-check a sample of `tasks/fl49-written-reasons.json` against the asm, especially reasons that depend on the "extra reads are side-effect-free" assumption.
- Seven credits with an untaken jump direction (0x4c0c7d, 0x4c3efb, 0x44b26a, 0x44b3c8, 0x434025, 0x423876, 0x4c36b2) stay credited unless Glib drops them.

## Regeneration order after a merge of main

accept (`fl40_accept.py`), record oracle, `extract_function_evidence.py --write`, accept again, evidence again, `build_function_ledger.py --write --blockers-reviewed tasks/fl40-blockers.json`, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), refresh, audits, then the ledger build once more (batch-report hashes) and every `--check`.

## Container lessons

Background jobs die when the turn ends: use `run_in_background` with Monitor, and resumable drivers (`--resume`). Install unicorn, capstone, pytest and pefile first. Never `pkill -f` a pattern that appears in your own command line; use a bracketed pattern.

## Diff review (one Sonnet reviewer) and what was done

- **Fixed:** 12 reasons that cited an address outside their own function. Their callee-dependent claims ("the callee stores only to its own frame") cannot be checked by the oracle, which stubs callees. They were dropped, which put 0x445c8a and 0x478684 back to held (239 clean). `tests/test_fl46_verdicts.py` now fails on any outside address except the two jump-table bases (0x4453a7, 0x44550b) read by the function's own jump, and on a reason without a 40+ character review. `fl44_final.py` counts a reason only with a review and 80+ characters after whitespace is collapsed. The test also requires every hang-kill line of the FL-49 recheck logs to say "killed by step budget".
- **Not fixed (tool hygiene, no credit effect):** `fl49_targeted.py` counts any child death (alarm, OOM kill, uncaught error) as a killing scenario for its corpus seeds (the recheck, not this tool, decides credit); a `StopIteration` in the pool can truncate output silently before `--apply`; `--apply` is not idempotent (a second run appends the same seeds again); `fl49_assemble_reasons.py` matches reviews to writers by (row, kind, line) only.
- **Open for Glib/next thread:** about 78 of the reasons rest on a stated assumption ("argument pointer does not alias the frame", "slot written only by explicit stores"). These are the cases the oracle cannot test. They were accepted under the same wording FL-46 used, but a stricter reading would drop them.
- The 50 acceptances added in this round carry the FL-40 date string (2026-10-22) and reviewer text because `fl40_accept.py` has them fixed; the real rule set is the one in this file.
