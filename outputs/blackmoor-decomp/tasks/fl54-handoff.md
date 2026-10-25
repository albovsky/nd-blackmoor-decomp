# FL-54 handoff (rows below 0x480000, round nine)

Ledger 2,165 (main after PR 185, FL-52) -> **2,171 ported of 4,188** (+6 lower rows). Of 368 translated rows below 0x480000, 285 are credited (279 before, +6) and 83 held. Same rulings as FL-49 to FL-53: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, a rule or a reviewed row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget max(100 x unmutated steps, 200,000).

## The 6 credited rows

- 0x4554bb and 0x464ab5 (the pair of `mov edx/eax, [0x5b44f0/f4]` width mutants): killed by two hand-built scenarios that make `this` point into the data (`this` = 0x5b44ba or 0x5b44be, the field at this+0x38 holding 0x5b44f2 or 0x5b44f6), so that the 16-bit store through the field overwrites the high half of the global that the mutant reads narrower. Seeds are in `tests/fl40_corpus.json`.
- 0x44a116 and 0x43da93: killed by start-register scenarios found by the new `scripts/fl54_regseeds.py` (see below).
- 0x445c8a (1 survivor) and 0x472f0a (2 survivors, `ebp = esp` dead because `pop ebp` rewrites ebp): `tasks/fl54-written-reasons.json`, written by one Sonnet and confirmed by an independent Sonnet; the diff review checked both against the function text. 0x445c8a rests on the frame-slot-written-only-by-explicit-stores assumption (Glib's open assumption question).
- The exhaustive recheck under `FL46_BUDGET=1` is `tasks/fl54-mutation-log.txt` (listed in `scripts/fl44_final.py` and pinned by `tests/test_fl46_verdicts.py`).

## New in the toolchain

- `REG_OVERRIDE` in `tests/fl40_world.py`: an override at `0xffff0000 + 4 * i` (eax ecx edx ebx esi edi ebp) sets that START register of a seed, on both the original and the native side; memory overrides ignore these addresses. A seed's own `this` is always aligned and in its region, so mutants that keep a masked bit, read only the low word of a saved `this` or count in 8 or 16 bits were never told apart before.
- `scripts/fl54_regseeds.py`: for the first N corpus seeds, vary one start register (+-1..4, ^1, bit patterns above 8/16 bits, 0, 1, -1) and in a second stage also one cell of each mutated instruction's memory operand; a scenario counts only if the original does not fault and the unmutated translation agrees. It and the hand-built pair added 64 start-register seeds to the corpus; the exhaustive recheck, not the script, decides credit (the script counts only a written `1` from the child as a kill since the diff review).
- `scripts/fl54_packet.py`: reading packet per row for writers (translation plus every mutant of each survivor line).
- Sonnet writer verdicts (29 rows, 67 survivor statements, `/home/user/scratch/writers`, not committed): almost all "not equivalent" with a concrete input; useful as a map of what a killing scenario must look like (see below).

## Left for the next lower-address thread

- 83 held rows (`tasks/fl40-held-rows.json`). Closest: 0x45ea4a (1: needs edx = eax = 3 and the word at [ecx+eax+0x142] = 1), 0x45150e (1: borrow-in at 0x4515aa with [ptr] == [this+0x3c], ptr overlapping this+0x138), 0x46e823 (4, loop `add ecx, 1` / `ecx -= 1` counters), 0x45432f, 0x467d5f, 0x467e70 (1 each: an odd `this` AND the constructed equalities that reach the mov; shifting the override cells by the same offset did not give an agreeing scenario, they need a purpose-built scenario), 0x4540bd (6), 0x41c29a (4 after its windowed recheck of 202 mutants; two survivors are on `add ax, 1`).
- 0x478e7b: its survivors are wall-clock hang kills (the loop never ends when the byte limit is 1 or more); a scenario with that limit set and the step-budget confirmation would count, `tests/fl40_mutation_check.py` currently lists them as survivors.
- 0x467b9e and 0x458c9b need huge scenarios (65,536-iteration counter, a 40,000-byte string); 0x4523b5 (24+ survivors, 2 seeds), 0x46a98e (1 seed), 0x473ac5, 0x4033db 0x404be1 0x43f31a 0x43ff18 0x478f91 are still never checked or hopeless.
- Open questions for Glib are unchanged (assumption-based reasons, seven credits with an untaken jump direction).

## Lessons

- The held list is "survivors after rules, rescue runs and written reasons". A fresh exhaustive log of a held row lists many more survivors than the held list shows; always judge a row through `scripts/fl44_final.py` (add the new log to LOGS and to `tests/test_fl46_verdicts.py`), not by the raw log.
- Targeted seeds that kill only by hang (fl49_targeted counts any child death as a kill) are not credit; the budget rerun decides.
- A mutant that keeps a bit of a masked register needs a start-register scenario; memory-cell search cannot reach it.
- Regeneration order (worked first time): oracle docstring edit, `record_function_execution.py run --only fl40_original_oracle`, `collect --write --merge`, evidence, `fl40_accept.py --reviewer ... --blockers-reviewed tasks/fl54-blockers.json` (a runtime blocker receipt is needed when a credited row is named by an RT item: 0x43da93), evidence, ledger, `function_names.py write`, `annotate_machine.py annotate` (plain, `--named`, `--derived --named`), `refresh`, ten audits (pinned binutils from old-releases.ubuntu.com in `work/tools/s08-binutils-2.43.1`, bootstrap script about 90 s), evidence and ledger again, every `--check`.
- Suite: 375 files, 131 failed under load on the branch; 126 fail identically on a clean-main worktree, 5 runtime files (d3, da, eb, ee, f5) timed out under load and were rerun alone.
- An accidental `rm -f /dev/null` (a stray command in a longer line) removed the device node in the cloud container and could not be repaired (the move was denied); no repo files were affected.
