# FL-51 handoff (rows below 0x480000, round seven: the x87 unit)

Ledger 2,064 (main after PR 175) -> 2,079 alone, **2,137 ported of 4,188** on top of FL-48 (PR 176, 2,122). Of the 337 + 31 = 368 translated rows below 0x480000, 259 are credited (244 before, +15) and 109 held; 8 more x87 rows were lifted and then refused (below). Same rulings as FL-49/FL-50: every mutant killed on seeds where the unmutated port matches the original, identical -O2 code, or a reviewed row-specific written reason; wall-clock timeouts and SIGKILLs never count; hang kills only under the step budget max(100 x unmutated steps, 200,000). No new written reasons were needed this round (the 15 new credits rest on kills and the existing -O2 equivalence records, `tasks/fl51-equivalence.json`).

## What was added

- **x87 lifting** (`scripts/lift_function.py`, `src/original_methods_fl40_x87.h`): fld/fild/fst/fstp/fist(p) widths, the add/sub/mul/div family with the reversed (`r`) and popping forms, fcom/fcomp/fcompp, fnstsw, fchs/fabs/fsqrt/fxch and the constants. The model runs on the host x87 unit (inline asm) and is made to match the oracle (Unicorn/QEMU 5): Win32 control word 0x27f, no exception flags except ZE for a zero divisor, no NaN quieting on memory-format conversions.
- **Callee FPU effects:** a callee that leaves a value in st(0) (net +1), pops one (-1) or none (0) is classified by a CFG walk (`fpu_net`) or the curated `LIBRARY_FPU_NET` table (0x50df94, 0x50e104, 0x50e054 +1; 0x50ce04 -1; 0x50ccec +1). Both sides stub it the same way (`fld qword [FPSLOT]; ret N` / `fstp st(0); ret N` patched into the Unicorn callee). **After the diff review:** library thunks are followed (0x50de00 jumps to code that uses the x87 unit and is now refused, which removes rows 0x44753b and 0x47d788 from the liftable set), indirect calls other than through the import table and conditional jumps out of the callee's span are refused, and `fsincos`/`fptan`/`fxtract` count as push, `fpatan`/`fyl2x`/`fyl2xp1` as pop.
- **World** (`tests/fl40_world.py`): float seeds (numbers >= 100000, "style 7") fill memory with float bit patterns; 8-byte stores are logged as two dwords; FPU trace registers; jump tables with any byte register as index.
- **Mutation operators for the x87 statements** (`tests/fl40_mutation_check.py`): operation swap, operand-order swap for sub/div, load/store width swaps, fstp<->fst, compare operand swap, a stack-index shift on every `FL40_FST(fp, n)` of an arithmetic, compare or fchs statement (one mutant per occurrence), a dropped fchs, narrower integer loads. The review found that fchs lines and register-form arithmetic had no index mutants; they were added and the 15 credited rows were re-checked (`tasks/fl51-mutation-log.txt`, last lines): no new survivors, kill counts up by 3 to 16 per row.
- 31 new rows in `src/original_methods_fl40.c`, `tests/fl40_corpus.json` (+121 hardening seeds), the regenerated `tests/test_fl40_differential.py` (x87 tests skip on a non-x86 host).

## The 15 credited rows

0x44bed5 0x44bf14 0x44bf4b 0x44bf8b 0x44bfb2 0x44bfe5 0x44c00a 0x44c033 0x44c05c 0x44c08a 0x44c0b8 0x44c0e6 0x44c114 0x44c1a3 0x44c223 (the 0x44bed5.. family: vector length and dot-product helpers).

- **`scripts/fl44_ranges.py`** now refuses a function that stores from the x87 unit to memory (the integer slot analysis cannot see a float written into a frame slot; `tests/test_fl44_ranges.py` caught it on 0x44a32c).

## Model assumptions to know about

- Win32 control word 0x27f (53-bit significand, round to nearest, exceptions masked, as the game runs). The model follows the oracle, not the hardware, on: sticky exception flags other than ZE (never set), signalling NaNs on fld/fst (not quieted), PE/UE/OE/IE. This shows only for code that reads the low byte of `fnstsw` or sees a NaN; none of the credited rows does.
- The model is exact on x86 hosts only; the differential tests skip elsewhere. The mutation check and oracle have no such guard: on a non-x86 host they would drop scenarios where the unmutated port already differs.
- Style 7 (float-bit memory) applies to every row whose seed number is >= 100000; no non-x87 row has such seeds.
- Callee effects are the CFG analysis or the curated table (see above); the oracle cannot test a callee because callees are stubbed.

## Left for the next lower-address thread (the remaining x87 rows)

Credited: 15 above. Held with survivors:

- **0x40af5d 0x40afaf 0x40b001 0x40b053 0x40b0a5 0x40b0f7 0x40b149 0x40b19b 0x40b1ed 0x40b23f** (82-byte clones, 77 mutants, 2 survivors each, one open): a width survivor in the `repe cmpsb` loop. Needs a seed where the first byte matches and the second differs (a cheap search was not found; the sibling rescue ran out of memory in the fork pool, see `tasks/fl51-rescue-sib.txt`, not committed).
- 0x472f0a (26 mutants, 2 survivors: `mov ebp, esp` register and drop).
- 0x44a32c (181 mutants / 26 survivors), 0x45133d (393 / 104).
- Refused after the review (removed from the corpus): 0x4348b0 (592 / 15; callee chain 0x50cdce too long), 0x45468e (261 / 34), 0x469259 (215 / 62), 0x469374 (258 / 91) with an indirect call in a callee.
- Not mutation-checked: 0x4523b5, 0x46a98e, 0x473ac5 (a run was started and stopped after 2 hours). Refused, never checked: 0x4477d1 and 0x46ab7f (callee with an indirect call), 0x44753b and 0x47d788 (callee 0x51397b uses the x87 unit).
- Lifted but coverage incomplete (not in the corpus): 0x44fc9b 0x44b641 0x4516c7 0x47bb56 0x4090ab 0x44ffa3 0x4163b4 0x450678 0x41e647.
- The refused rows can be brought back: add the real net of 0x51397b, 0x4c3efb, 0x4c4067, 0x4f80d3, 0x4f684a, 0x4f6b74 to `LIBRARY_FPU_NET` (or teach `fpu_net` indirect calls through a table) once read from the bytes.
- Held rows overall: 109 (93 older plus the above). Five large rows never checked (FL-50 list).

## Regeneration order after a merge of main

Same as FL-49/FL-50. New this round: `record_function_execution.py run --root <repo> --trace-dir work/analysis/FL-51/traces --only fl40_original_oracle` then `collect --write --merge` (a plain `collect --write` would drop every other script's run); the oracle docstring was edited so its hash changes and the FL-40 run is replaced. The pinned binutils bootstrap took 1 minute here (download from old-releases.ubuntu.com).

## Lessons

`fl46_driver.py --rescue` without `--corpus` rewrites the whole main corpus with stale content; always use a corpus copy and merge the seeds by hand. A mutation run past 2 hours is killed; run big rows in `--window` slices. The Sonnet diff review found a latent thunk misclassification and three missing mutation operators; all fixed before credit.
