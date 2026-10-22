# FL-41 handoff, part 1: operator-level recheck of the FL-39 batch d rows

Cloud thread, 2026-10-22 PDT. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, never committed).

## Why

FL-39 credited 127 machine-translated rows (`fl39d`, symbols `m<va>_lifted` in `src/original_methods_fl39d.c`). Its mutation check took up to three mutants per function and never mutated
the arithmetic and compare instructions of the lifted code in a systematic way (and 95 of its 415 mutants survived). FL-40's review found the same gap in its own check. This
slice mutates **every** operator site of all 139 lifter rows (the 127 credited and the 12 that were already pending).

## What was run

`tests/fl41_operator_mutation_check.py fl39d` makes one mutation per function per round, at every site of the operators `+ - & | ^ << >> == != < > <= >=`, the sign casts and the compare/add/sub constants (not `*` and not `?:`), rebuilds, and runs the direct C test and the Unicorn
differential test; a mutant is killed when either fails (a hang or a crash counts as killed, and the offending function is taken out of the group so the others are still
judged). Mutation kinds: binary operators (`+ - & | ^ << >> == != < > <= >=`, each to its counterpart or negation), sign casts (`int8/16/32_t` <-> unsigned, the movsx/movzx and signed/unsigned
jump distinction), and the constant operand of compares and of add/sub immediates (`cmpconst`, `aluimm`).

- 2,320 mutants in total (2,099 operator and cast, 221 compare and immediate constants); the direct binary was built `-O0` for speed in this pass (`--kinds op,cast,literal,cmpconst,aluimm --opt -O0`). A hang or crash counts as a kill, and the JSON does not break kills down by reason. The 7 explained survivors: the register is not read after the failed equality on the not-equal path and is redefined on the equal path.
- 1,749 killed; 433 survivors compile to **identical `gcc -O2` code** (dead or masked, the FL-40 standard); 7 are explained one by one (sign extension of a 16-bit value that is only compared for equality with a constant below 0x8000); **131 are unexplained**.
- Before the survivors were counted, the fixtures were strengthened: `tests/fl41_boundary_recipes.py` made up to 40 extra recipes per row (28 for `0x4accab`) (values at the edges of their width and next to the constants the function compares with; the original bytes run each one, a recipe the port reads out of the fixture regions or disagrees on is dropped), written to `tests/fl39d_boundary_recipes.json` and appended to the recipes by `tests/fl39d_fixtures.py`. This killed 24 mutants that had survived and found the next item.
- **`0x4c4c2b`** (credited by FL-39): with a plausible boundary input the original passes uninitialised stack words as call arguments; the port passes zeros. Same class as the `0x4e45be` stack-residue blocker. The row is pending.
- `tests/fl41_mutant_fuzz.py` looked for a scenario that tells each of the 131 unexplained survivors from the port (the row recipes, 400 boundary and 200 random scenarios per survivor, port against mutant, every observable compared): 110 are **indistinguishable** (sign-extension, index-cast and sub-register-merge mutants whose effect never reaches memory, a call argument or the return value; 90 of them in the 26 newly pending rows), 17 can only be told apart where the port and the original disagree or fault (16 in `0x4c4c2b`, 1 in already-pending `0x4a1fd1`), 4 were killed by a new scenario (rows that were already pending). "No scenario found" is evidence, not an explanation, so by the FL-40 rule (identical `-O2` code or a written per-survivor reason) these rows are not credited.

## Result

**27 credited rows go back to pending** (the 12 FL-39 had already left pending stay pending): `0x48a70a` `0x495a5b` `0x4a378a` `0x4a3beb` `0x4a8007` `0x4a9f63` `0x4accab` `0x4b3f98` `0x4be2c6` `0x4c4b12` `0x4c4c2b` `0x4c9428` `0x4cd645` `0x4d912a` `0x4dd28d` `0x4de009` `0x4e0619` `0x4e35e8` `0x4e364a` `0x4e40a6` `0x4eb9c8` `0x4f67be` `0x4f6810` `0x4fafc7` `0x4fb018` `0x4fb086` `0x4fb737`. Their ports and tests stay in the repo and are green; only the credit is withdrawn (`scripts/fl41_prune_recheck.py` reads `tasks/fl41-fl39d-recheck.json`, removes them from the port acceptances and from `tasks/fl39d-acceptances.json`; safe to rerun after merging main). Ledger: **1,744 ported** (1,771 before), 128 not needed, 2,316 pending.
Per-row detail (counts, every explained and unexplained survivor with its source line and the scenario search result): `tasks/fl41-fl39d-recheck.json`; guard test: `tests/test_fl41_recheck.py`.

To credit a row again, either write the per-survivor reason into the row's `explained` list (with the evidence) or re-port it with a lifter whose check has no survivors (part 2 of this slice does that for rows at or above 0x480000).

## Not done in this part

The pass over every other integer literal (store values, offsets; 3,200 sites) was still running when this was written. Its survivors are handled in part 2.

# FL-41 handoff, part 2: new rows at or above 0x480000 (`src/original_methods_fl41.c`)

Cloud thread, 2026-10-22 PDT. Ledger: 1,854 (main after FL-40, PR 165) -> **1,873 ported** (+19). Glib's ruling (2026-10-22): machine-translated ports count, labelled "Machine-translated", only rows that pass the strict mutation check; the bar was kept.

## What was built
- `scripts/lift_fl41.py` (FL-40's instruction-level lifter, census flipped to rows at or above 0x480000), `src/original_methods_fl41.h`, `tests/fl41_world.py` (deterministic world, recording stubs for callees), `scripts/fl41_generate.py` (seed search on the ORIGINAL bytes under Unicorn until every instruction runs and both directions of every conditional jump are taken; resumable with `--cache`), `tests/fl41_original_oracle.py` (original bytes only), `tests/test_fl41_differential.py` (translation against the original on every seed).
- `tests/fl41_mutation_check.py`: mutants of the translation (flipped jumps, changed literals, add/sub and shift swaps, operand swaps, access widths, dropped statements, wrong registers); killed by the corpus, then 40 extra seeds, then hardening seeds (`--harden` adds the killing seed to the corpus). `--per-row N` samples N mutants per row; **the credit rests on the exhaustive run (`--per-row 100000`, every mutant site)**, not on the 30-mutant sample (see below).
- `scripts/fl41_o2_classify.py` and `scripts/fl41_survivors.py`: a survivor is explained only if (a) `gcc -O2` gives identical assembly for the mutant and the translation (a (kind, line) with several mutants counts only if all are identical), (b) a same-value reload of a frame slot on straight-line code (`reg = RD32(ebp + k)` right after `WR32(ebp + k, reg)` or the same load, no call, label, jump, write to the register or store that could hit the slot in between; **a store through another register is assumed not to point into the function's own frame, and a change of ebp between the two is not checked**), or (c) a callee-pop or frame adjustment that every return path undoes (the classes `cleanup` and `frame`; their checks are weak, see the review notes; none of the 19 accepted rows uses them). Anything else keeps the row out. A first classifier also accepted a "local width" class (a narrower read of a frame local that the seeds never show); it is evidence, not an equivalence, and was dropped.
- `scripts/fl41_prune.py` takes the unexplained, unhardened and diverging rows out of the source, corpus and tests (listed in `tests/fl41_pending.json`); `scripts/fl41_accept.py` writes the acceptances (class `native_oracle_verified`, note starts "Machine-translated"; it also drops the acceptance of a row that left the set).
- Logs: `tasks/fl41-mutation-log.txt` (exhaustive, the 66 rows left after the sample), `tasks/fl41-mutation-log-sample.txt` (30 mutants per row, the 190 rows checked first), `tasks/fl41-survivors.json` (per row: survivors with kind, verdict, statement and line index in the row's text; rows pruned in the first pass are listed by id and their statements are in the sample log), `tasks/fl41-o2-identical.json`.

## Numbers
- Pool: 418 pending game rows at or above 0x480000; the lifter handled 323 (the others use floating point, indirect calls and the like), 20 of those stay out (the coordinator's exclusions and the 12 FL-39 rows whose ports stay in `src/original_methods_fl39d.c`). The input search on the remaining 303 gave **197 complete** (every instruction, both jump directions) and 106 not complete (104 coverage, 2 emulator errors).
- Sample check (30 mutants per row, 5,680 mutants, hardened): 66 rows had every survivor explained, 121 an unexplained one, 7 could not be hardened (emulator memory error, `UC_ERR_NOMEM`), 3 differ between translation and original on a hardening seed (`0x482248`, `0x4ac498`, `0x4adae8`: real divergences). The diff review then showed that 30 per row covers only 11% of the mutant sites (and that nine of the 66 were rows part 1 had withdrawn after an exhaustive pass), so the 66 were rechecked exhaustively.
- Exhaustive check of the 66 (17,198 mutants, 16,124 killed, the rest classified): **19 rows accepted** (63 survivors in them: 27 identical -O2 code, 36 same-value reloads); 47 held with an unexplained survivor. None of the nine FL-39 rows passes; they stay pending.
- FL-40 (merged, PR 165) used the same 30-mutant sample. Its 110 rows were not rechecked here; a recheck with `--per-row 100000` on `tests/fl40_mutation_check.py` is the same work and would show whether the same gap exists there.
- No accepted row has an old slice blocker.

## Not done
- The pass over every other integer literal of the 100 FL-39 batch d rows that stay credited (store values and offsets, about 3,200 sites) was not finished; those rows were checked on operators, sign casts and compare/add/sub constants (part 1).
- The 7 unhardened rows (`tests/fl41_pending.json`, status "mutation check incomplete") and the 121 + 47 held rows.
- Callees are recording stubs and their bytes-popped comes from the callee's own `ret N`, used by both sides; callee flags are not modelled. Some undefined flags follow Unicorn, not hardware; no accepted branch consumes one directly.
