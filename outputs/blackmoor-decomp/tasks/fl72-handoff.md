# FL-72 handoff: leftover Mac-port rows (2026-10-27 to 10-28 PDT, cloud thread)

Goal: clear the Mac-port pending rows (Game + Vorbis, 2,685) that FL-70 left. Strict "verified" is unchanged (2,210 of 4,188). Credit is "tested equivalent" (every instruction and both directions of every jump run on the original bytes under Unicorn, translation equal to the original on every scenario) or "by proof" (T-EQ-INFEASIBLE).

## Result (PRs 248, 251, 254, 257, all merged)

- PR 248: 15 rows. PR 251: 8 rows (0x4fa2a8 0x4cf276 0x4aa81e 0x4c334f 0x4ca5b6 0x4163b4 0x450678 0x4f438f). PR 254: 0x4695f7 0x4cd6ff 0x4b05ae. PR 257: 0x4d8dca (quicksort).
- Total 27 rows from this thread. Whole ledger after PR 257: 2,210 verified, 1,686 tested equivalent (88 by proof). Mac-port view: ported 2,209, tested equivalent 411, pending 65 of 2,685 (FL-74's PR 255 is in that count; FL-75's local clears are not).
- Rows handed off with scenario sets: `tasks/fl72/near-miss-scenarios.json` (19 rows, FL-74 cleared 14) and `tasks/fl72/near-miss-scenarios-2.json` (0x417b04 0x4b4a68 0x4867bd 0x45c18f 0x4a6c61, one or two directions short, for FL-75's prover).

## What was built

- `scripts/fl70_solve.py`: jump-table (switch) goals, `keep` constraints so solved pointer registers stay out of the override regions, length goals for long strings, hang-run replay under a short instruction limit only for rows that never finish a run.
- Never-returning callees: `tests/fl72_noreturn.json` (AfxEndThread 0x51ec84). Both worlds stop the run at such a call (`NORETURN_ESP` sentinel in `FL40_CALL`/`FL41_CALL`), `fl66_tested.py` reads the list, `fl67_infeasible.py` ends the path. Stated in RULE_TEXT2.
- `scripts/fl72_loops.py`: scenarios for thread-procedure rows that end in AfxEndThread.
- Pool `fl72` in `scripts/fl66_tested.py` (table `tests/fl72_rows.json`, hand-port source `translated/original_methods_fl59_handports.c`; `decomp-progress/function_ledger.py` now accepts that file as a tested-equivalent source).
- `tests/fl68_sites.json`: indirect-call sites for 0x40105e 0x420c17 0x4338bb 0x437614 0x44cb7d 0x4c1716 0x4ca5b6.

## Method that worked

`scripts/fl68_search.py` (goal-directed search) run ONE ROW PER PROCESS, 120 to 600 s each, seeded from all scenario files packed into one `scen-all.json`. Multi-row runs run out of memory (killed with exit 137) and some rows (0x4d812e) reach 10 GB in two minutes: watch RSS. Credit with `FL66_EARLY=1 python3 scripts/fl66_tested.py check ROW --redo --prove --scen scen-all.json`.

**Do not run `fl66_tested.py merge --write` from a local results directory on a branch that has other threads' credits**: it rebuilds `fl66-partial.json` and `fl67-infeasible.json` from local rows and drops the others' rows. For one or two rows, apply the new row to the committed manifests by hand (tested-equivalent manifest, scenarios file, remove it from `fl66-partial.json`), then regenerate evidence and ledger.

## Still pending (65 at PR 257)

Large rows where the 120 to 600 s search stops short (hundreds of instructions, tens of directions): 0x40b34a (1,611/5,261 instructions), 0x413187, 0x41e647, 0x420c17, 0x46f986, 0x480e02, 0x48f181, 0x496410, 0x4a2180, 0x4a4f58, 0x4bca71, 0x4c1716, 0x4deed7, 0x4e4cb6, 0x4ec9a2, 0x4f0059, 0x4090ab and 0x425b8b and 0x448d11 (the search finds nothing at all: first run faults or hangs).
Near-complete (all or almost all instructions, 1 to 7 directions short): 0x424aa8 (91/92), 0x439822 (139/146), 0x4381f4 (51/56), 0x467eb0 (13/14), 0x417b04, 0x4b4a68, 0x4867bd, 0x45c18f, 0x4a6c61 (with FL-75), 0x44ad41 (credit check dies with out-of-memory on its scenario set).
Parked: 0x456516, 0x471722, 0x47c0f0 (need the no-alias question answered), crash-path pair 0x4a0ec3 and 0x49d945.
Others partial after the search: 0x412234 0x416fb6 0x4181c6 0x418e52 0x4662d8 0x47b767 0x4899ca 0x491db2 0x495af3 0x4aba6d 0x4af225 0x4b8e92 0x4ba56a 0x4bf9bb 0x4c9d91 0x4d7ea4 0x4da430 0x4e0e2b 0x4e812f 0x4eeb23 0x4f3c26 0x4f4b9f 0x4f7207, plus 0x44b641 0x44ffa3 0x4a14c6 0x4bbb3e (FL-75 has cleared these locally with a stronger prover).

Next idea: FL-73's hand-built-state tools (`tasks/fl73/tools`) and FL-74's (`tasks/fl74`) on the near-complete rows. The prover rows go to FL-75.

## Gotchas

- Foreground waits longer than about 10 minutes get moved to the background; use `run_in_background` waiters and read the result file.
- `test_function_ledger` takes about 12 minutes; run it once after the last regeneration, not per attempt.
- Codex review ran normally on PRs 254 and 257 (no findings).
