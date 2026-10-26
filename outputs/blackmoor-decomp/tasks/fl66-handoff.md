# FL-66 handoff: the "tested equivalent" ledger tier

Ledger (main after FL-65): **2,210 verified ported of 4,188**, unchanged by this thread. This thread adds a SECOND tier inside `pending`: **tested equivalent**, reported as `verified X, tested equivalent Y, translated only Z` (`python3 scripts/fl66_tested.py status`). The tier is never added to the verified count.

## Definition (what the PR body also states)

A pending function is tested equivalent when its committed translation (`src/original_methods_fl40.c` held rows, `src/original_methods_fl56_unverified.c`, `translated/original_methods_fl41_translated.c`, `translated/original_methods_fl57_translated.c`):

1. runs, on the scenarios kept for it, **every instruction** of the original function and takes **both directions of every conditional jump** (jcc, jecxz, loop; measured on the ORIGINAL bytes under Unicorn, `fl40_generate.covers` / `fl41_generate.covers`), and
2. **equals the original on every scenario it was run on**: final registers (and x87 state), the ordered log of written memory, the ordered callee calls and their arguments, the return. A native fault or any difference makes the row a `mismatch` (a translation defect), never counted. A scenario on which the original itself faults is skipped (it adds no coverage and is not compared).

No mutation check is run. Known limits (independent Sonnet review): eflags and reads are not compared directly (only through their effect on the compared items); coverage counts jcc/jecxz/loop only, not rep-string zero vs non-zero counts or indirect-jump targets; the hash pins the row text, not the shared header/helper code of the C file.

## What was built

- `scripts/fl66_tested.py`: `check` / `gen` (per row subprocess with a timeout, sharded `--shard i/n`, resumable; results in `tasks/fl66/rows/<va>.json`, not committed), `merge --write` (writes `tasks/fl66-tested-equivalent.json`, `tests/fl66_scenarios.json`, `tasks/fl66-partial.json`, `tasks/fl66-partial-scenarios.json`; a row that became ported on main drops out), `status`, `replay`. `gen` runs `fl62_concolic.py` (upper) or `fl61_concolic.py` (lower) when the known scenarios (every corpus/pending/translated table and every `tasks/fl6x/*.json` scenario file) do not reach full coverage, then checks again.
- Ledger: `decomp-progress/function_ledger.py` reads the manifest as an optional pinned input and writes a top-level `tested_equivalent` object (rule `T-EQ-COVERED`, count, addresses). Validation: every address is a PENDING function, every row shows full coverage, the scenario counts match, and the committed translation text still hashes to the recorded `translation_sha256`, so editing a translation makes the ledger stale. `scripts/build_function_ledger.py` prints the tier beside the status counts.
- Map: `decomp-progress/generate.py` + `template.html`: a fourth "Tested equivalent" tile, a hatched segment per region bar, a status filter and a pill in the table, a caveat line, and a line in `REPORT.md`.
- `tests/test_fl66_tested_equivalent.py`: manifest/scenarios/ledger agree, tier is pending and never ported, full coverage per row, translation hash, a replay of a 24-row sample (Unicorn), and a deliberately broken translation (a push moving esp by 8) is caught as a mismatch.

## How to continue

- Fresh container: `pip install unicorn capstone z3-solver`; extract the private tarball into `work/` at the repo root (the tarball has `analysis/` and `original/` at its top: `mkdir work` and `tar -C work`).
- `FL66_CACHE=<dir> python3 -u scripts/fl66_tested.py gen --pool upper --shard i/4 --budget-s 60 --timeout 600` (pools: held, lower, upper, upper57). The first run compiles the pool's C file (about a minute for the 10 MB upper file; the `.so` is cached by file hash under `FL66_CACHE`). Do not `git stash -u` while shards run (they write under `tasks/fl66/`).
- After a batch: `merge --write`, `extract_function_evidence.py --write`, `build_function_ledger.py --write`, `function_names.py write`, `function_names.py check`, then `tests/test_function_ledger.py`, `tests/test_function_names.py`, `tests/test_fl66_tested_equivalent.py`. Regenerate the fixture ledger with `decomp-progress/fixtures/function-ledger/make_fixture.py` if the ledger's input list changes.
- `decomp-progress/test_progress.py FunctionLedgerTests` fails in setUpClass on main with `evidence stale; rerun record_playable_status.py` (Codex app commits changed the registration sources); it is not caused by FL-66. The map recipe (`record_playable_status.py --seed` in a scratch clone) works.

## Batch 2 (PR after 216)

Tested equivalent 1,101 -> 1,274 (upper 1,122-ish rows through the bigger rows, 24 of the 117 upper57 rows). About 414 rows are partial: about 60 miss exactly one jump direction after a complete search and a rerun with a larger budget gains nothing (an unsigned-overflow `jb`/`jae` pair, a `je` after a null read that faults, solver limits); about 190 larger upper rows were still being searched when this batch was cut. The lower rows (fl61 generator) gave nothing new. Rerunning: `scripts/fl66_tested.py gen --pool upper --shard i/4 --budget-s 90` skips rows that already have a result; `--redo` replaces one.
