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
