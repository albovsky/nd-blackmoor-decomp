# FL-67 handoff: Mac-port functions to "tested equivalent" (2026-10-27 PDT, cloud thread)

Goal of the thread: clear the remaining Mac-port functions (Game + Vorbis, 2,685) to "ported" or "tested equivalent". Verified (strict) stays 2,210 of 4,188 and was never touched.

## Where it stands

After the batch 6 PR (the one that adds this file): whole ledger tested equivalent 1,600 (70 of them by z3 proof), translated only 250. Mac port: ported 2,209, tested equivalent 325, pending 151.

PRs: 226 (prover and tier), 229, 231 (evidence regeneration), 236 (batch 3, +44), 239 (batch 4, +13), 240 (batch 5, +8), and batch 6 (+3). Details of the tier: `tasks/fl66-handoff.md` and the memory note `fl67-infeasibility-tier`.

## What works, in order of yield

1. `python3 scripts/fl68_search.py ROWS --out tasks/fl66/scen/NAME.json --budget-s 90..150 --seed N` (goal-directed scenario search against the original bytes), then `python3 scripts/fl66_tested.py check ROWS --redo --prove --timeout 900`, then `merge --write`. Works on both pools now (FL-68 added callee-return and callee-store moves to the fl40 world). A pass over all partial rows gives about 10 to 15 percent of them; yield falls with each pass.
2. The z3 proof pass for rows that miss only a few items (about 70 rows credited this way). It stalls on rows with big loops.
3. Regenerate in the PR: `extract_function_evidence.py --write`, `build_function_ledger.py --write`, `function_names.py write`, `decomp-progress/fixtures/function-ledger/make_fixture.py`; then `test_function_ledger` (about 11 min), `test_function_names`, `test_fl66_tested_equivalent`, `test_fl67_infeasible`.

## What did not work

- Retrying a stuck proof on the cone of influence of one target (FL-68's suggestion): tried on seven rows (0x450dd5 0x4b05ae 0x4bf9bb 0x49c889 0x4bb775 0x4bbb3e 0x4cf9f4), cleared none. The solver still returns unknown, or the loop shape is unsupported.
- Seed sweeps, `fl68_model.py` (z3 model to scenario), longer budgets on rows the search had already saturated.

## What is left (151 Mac-port rows)

- FL-69 holds five rows whose translation disagrees with the original (0x4c88c7 0x4f2710 0x423021 0x42c221 0x42d35a) and 23 stuck rows listed at the end of `tasks/fl68-handoff.md`.
- About 100 rows have a prover answer of "sat" for a missing direction (the direction is reachable) but no scenario reaches it. They need a smarter generator (for example solver models that respect pointer ranges and loop bounds), not more random search.
- A few big rows are bounded by the prover's memory cap (`FL67_MEM_MB`, default 3500): one row (0x51f067) used the whole cap.

## Best idea for the next tool: prover model to runnable scenario, with range constraints and a repair loop

The prover (`scripts/fl67_infeasible.py`) already builds an exact path condition for every missing instruction and untaken direction, and answers "sat" for about 100 rows, which means a start state exists. `scripts/fl68_model.py` turned such a model into a scenario but failed because raw z3 models wrap pointers and set loop counters to huge values. Next steps:
1. Add domain constraints to the query before asking for a model: every cell used as a pointer lies inside one mapped scenario region and is aligned; every loop counter or length is at most 16; start registers are in the ranges the real callers use (esp inside the stack region, ecx a heap pointer for methods).
2. Turn the model into overrides of (seed, cell, value) pairs, run the original in Unicorn, and check which target it reached.
3. If the run diverges from the predicted path, take the first diverging branch, add that observed branch outcome as a constraint (or block that model), and solve again (a counterexample-guided repair loop, usually 2 to 5 rounds).
4. Feed every scenario that reaches a new item into `tasks/fl66/scen/` and run `fl66_tested.py check ROWS --redo --prove`. Callee returns need the same treatment through STUB_OVR (world 41 and now world 40).
Start with the rows that miss one or two directions (about 25 rows) to prove the loop works before the large dispatchers.

## Gotchas

- z3's memory cap is per process; a query that reaches it leaves the rest of that process without memory. The soundness oracle test therefore runs each row in its own process.
- Never run `pkill -f` in the same shell as other commands (it kills the shell). Use `pgrep -f '[f]l66_tested.py check'` in monitors so the check does not match itself.
- Background shards can die silently after one row; compare the log counts with the row lists.
- Codex-app commits to `src/blackmoor_app.mm` make `function-evidence.json` stale on main; regenerate in every PR.
- Untracked working data (never commit): `tasks/fl66/rows/`, `tasks/fl66/scen/`, `tasks/fl67/`, root `work/`.
