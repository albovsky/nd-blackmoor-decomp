# FL-70 handoff: solver-guided scenarios for the Mac-port rows (2026-10-27 PDT, cloud thread)

Goal: use a z3 model to build runnable scenarios for the Mac-port (Game + Vorbis) rows whose missing direction the FL-67 prover calls reachable ("sat") but no random or guided search reached. Strict "verified" stays 2,210 of 4,188 and was never touched.

## Result

Three PRs: 243 (+8 rows), 244 (+10), and the batch 3 PR that adds this file (+3). Whole ledger tested equivalent 1,606 -> 1,627 (74 by proof), translated only 223. Mac-port view: ported 2,209, tested equivalent 352, pending 124 of 2,685 (was 145).

New credits: 0x4fc341 0x45eadc 0x437774 0x45a07b 0x49c889 0x4c5976 0x4348b0 0x4bb775 (PR 243); 0x4b777d 0x42fc70 0x476a25 0x47a416 0x4889f0 0x455cc3 0x488319 0x4d1898 0x4e6658 and 0x4e075a by proof (PR 244); 0x4e412d, and 0x4b2ce6 and 0x426d0f by proof (batch 3).

New mismatch: 0x40105e (scenarios from the solver show the translation disagreeing with the original; not credited; hand it to whoever holds translation defects, same as FL-69's five rows).

## The tool: `scripts/fl70_solve.py`

`python3 scripts/fl70_solve.py ROWS --out FILE.json --budget-s 300` (one process per shard; a row that blows the z3 memory kills the whole process, so keep shards to 40 rows and relaunch minus the culprit; 0x467eb0 did this).

Loop per row: run the ORIGINAL bytes in Unicorn (`tests/fl40_world.py` / `fl41_world.py`) and record every instruction; replay that exact path through the FL-67 prover's instruction semantics (`Replay(Machine)`: exact z3 memory split into a stack-frame array and a heap array, callee returns as symbols `stk<k>_<reg>`, `rep` strings unrolled up to 64, x87 raises Resync and the replay restarts after it); for each uncovered jump direction ask z3 for a model that flips it at one occurrence of the jump, with soft constraints keeping the parent's inputs and hard range constraints on pointers; turn the model into overrides (start registers, input cells, stub eax/ecx/edx, stub stores); run the child on the original and repeat on every child that covers something new. Coverage is only against the original; the translation is compared afterwards by `fl66_tested.py check ROWS --redo --prove --scen FILE`, as for every generator.

Lessons: split the memory into frame and heap arrays (100x faster); put the goal position before the final stop constraint for `rep` loops; evaluate model cells found through `select_indices`, not the defaults; flip up to 3 occurrences of a loop jump; order base scenarios by "executes the jump of an uncovered direction"; `Solver` with soft literals plus unsat-core dropping beats Optimize. Also in this thread: `scripts/fl67_infeasible.py` unrolls `rep stos/movs` with a constant count exactly (sound, `CHECKER_VERSION` unchanged), and `fl66_tested.py` runs `--scen` files first (the 4,000-scenario cap used to cut them off).

Pipeline for credit: pack the scenario files (all `--out` JSONs of rows with lists of `[seed, overrides]`) into one `scen-all.json`, then `FL66_EARLY=1 python3 scripts/fl66_tested.py check ROWS --redo --prove --scen scen-all.json`, then `merge --write`, regenerate evidence, ledger, names, fixture, run `test_function_names`, `test_fl66_tested_equivalent`, `test_fl67_infeasible`, `test_function_ledger`.

## What is left (124 Mac-port rows)

- FL-71 holds the dispatchers and stuck near-miss rows (see `tasks/fl69-handoff.md`).
- One direction short, solver and prover both stuck: 0x4d7162 (`0x4d7496` taken; needs `[this+0x956a] == -1` right after an earlier check that must pass; prover answers unknown), 0x4c62f0 (`0x4c6500` taken is "sat", `0x4c6509` fall-through), 0x4af225 (5 directions, 4 instructions), 0x4bbb3e (5 directions). Each looks like a two-iteration loop interaction or a chained pointer check that the one-flip repair cannot line up. Idea not tried: let the solver flip two jumps at once (two occurrences of the same loop jump in one model) and ask for the first loop pass to leave a specific cell value.
- 0x4e3cd7 needs a string longer than 0x9c40 bytes (a special goal: constrain `strlen` result). 0x45e6bd needs a second loop iteration with a changed register.
- Rows that fault or hang on every seed (zero coverage), and the crash-path rows 0x4a0ec3 and 0x49d945 (divide by zero after the missing path).
- About 40 rows where the solver reached most but not all (instructions 150 to 300 short): mostly big loops with calls whose results feed later checks; they need callee-write modelling beyond `STUB_WR`.
- Throughput: the solver runs a few hundred scenarios per row in 300 s; a longer budget (600 to 1,200 s) on the near-complete rows is the cheapest next try.

## Gotchas

- Run at most two solver shards at once on the 4 cores shared with checks and tests.
- Never use `pkill -f` in a shell with other commands; use `pgrep -af` to see what runs.
- Untracked scratch (never commit): `tasks/fl66/`, `tasks/fl70/`, root `work/`.
