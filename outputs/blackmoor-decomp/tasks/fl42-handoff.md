# FL-42 handoff: lower-address ports, exhaustive recheck of FL-40 (2026-10-22 PDT, cloud thread)

Ledger: **1,909 ported** (1,873 on main after PR 166 -> **+36 net**: 48 new rows, 12 FL-40 rows back to pending). 128 not needed, 2,151 pending. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only).

## What was done

- **More translated rows.** The row generator (`scripts/fl40_generate.py`) now builds the whole other string for `repe cmpsb` (the guided search had no way to make a 9-byte string compare equal): 8 of the 93 incomplete rows became complete. The 57 rows that the old weak mutation pass dropped were regenerated (all complete). `scripts/fl42_merge.py` merged these 65 rows into `src/original_methods_fl40.c`, `tests/fl40_corpus.json` (now 327 rows) and `tests/test_fl40_differential.py`.
- **Exhaustive mutation check.** On Glib's rule (machine-translated ports count only if they pass the strict check) every mutant (`--per-row 100000`, not a sample of 30 or 60) was run on all 185 candidate rows, FL-40's 110 included: 27,676 mutants; survivors are classified by `tests/fl40_equiv_check.py` (identical `cc -O2` code) and `scripts/fl40_survivors.py`, then retried against new seeds (`--rescue`, style-6 seeds >= 20000). 0x4033db (1,674 mutants) needs `--window lo:hi` slices to fit the compiler; it has many width survivors and stays pending.
- **New explained-survivor rule** (`scripts/fl40_survivors.py`, `available_copies`): a dropped reload `reg = RD32(ebp+k)` is harmless when a forward dataflow over the statements shows reg already equals that frame slot on every path (a call kills eax, ecx, edx; a function that takes a slot's address, uses esp-relative locals, or stores through an indexed ebp address kills all facts). 467 survivors in the exhaustive run rest on it, so a reviewer of the next slice should look at that rule first. A Sonnet review found no counterexample in the real functions; the latent holes it listed were closed.
- **World fix.** Native memory now mirrors the pages the original run maps for the call stubs and the return address (a pointer into them used to read random page data on the native side, so on 15 rows the unmutated port differed from the original on style-6 seeds and "killed" every mutant). 13 of those 15 rows fail the redone check and are pending; the differential suite (328 tests) passes.
- Acceptances: class `native_oracle_verified`, note starts "Machine-translated". Survivors file: `tasks/fl40-survivors.json`; held rows with their remaining statements: `tasks/fl40-held-rows.json` (181 rows).

## Pending rows below 0x480000 after this slice

181 translated rows are held (survivors the checks cannot explain, mostly narrower reads of 32-bit values: `width` 300+; also shifts `shr`/`sar` of string lengths, which are equivalent below 2^31 but unproven). 85 rows are still incomplete (an untaken direction or unreached instructions; `tests/fl40_pending.json`; several have an untaken direction that is provably dead, for example `mov edx,1; and edx,1; test edx,edx; je`). Not liftable and coordinator exclusions as in `tasks/fl40-handoff.md`.

## Next steps, in order

1. **Guard the mutation harness**: kills should count only on seeds where the unmutated port matches the original (FL-43 added one). This slice instead verifies every saved killer seed with the differential suite and redid the 15 rows where it mattered; kills by timeout are not saved to the corpus and rest on the harness alone.
2. Range reasoning for width survivors (loop counters bounded by their compare, string lengths below 2^31): each needs a row-specific written reason or a killing seed.
3. The incomplete rows: add string-scan children (`repne scasb`) and dead-direction analysis.

Verification on the final tree: `extract_function_evidence.py --check`, `build_function_ledger.py --check`, `function_names.py check`, `annotate_machine.py check`, `tests.test_function_names`, the ten asm batch audits (10 of 10 accepted), `tests/fl40_original_oracle.py` (exit 0, 327 rows), `tests.test_fl40_differential` (328 tests).
