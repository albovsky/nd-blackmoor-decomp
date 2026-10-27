# FL-69 handoff: the 5 mismatched Game rows and the stuck Mac-port rows

Ledger after this PR: **verified 2,210, tested equivalent 1,603 (71 by proof), translated only 247** of 4,188 (main before: 1,597 tested equivalent).

## The 5 "mismatched" rows: three different causes, only one was a translation defect

- **0x4c88c7**: a real lifter bug. `jump_table` in `scripts/lift_fl41.py` took the FIRST `mov dl, byte [reg + table]` of the 14-instruction window, which belonged to the previous dispatch block, so the table was cut to 13 of 27 entries (and 7 of 13, 27 of 53 for the other two jumps). Now takes the NEAREST read. A scan of every row of the FL-55b/FL-57 tables (`jump_table` before/after) found this was the only row affected. Row re-lifted with `scripts/fl68_relift.py --pool fl41`. Full coverage by `fl62_concolic.py`; tested equivalent.
- **0x4f2710, 0x42c221, 0x42d35a**: harness gaps, not translation defects. Their indirect calls (`call [reg+off]`) were not registered as sites, so the original ran garbage at a wild pointer while the translation called the host. `tests/fl40_world.py` now plays registered sites exactly like the fl41 world (`site_hook`, `row_info(..., sites)`), `scripts/fl66_tested.py` passes them for world 40, `scripts/fl68_sites.py` reads the `FL40_CALL` text too, and `tests/fl68_sites.json` has the three rows. 0x42c221 and 0x42d35a are tested equivalent; 0x4f2710 is at 592/798 instructions, 61/76 directions (no mismatch on any scenario).
- **0x423021**: self-recursive row; in the fl40 world the entry stub swallowed the row's own first instruction (coverage 1/41). Same fix as FL-68's fl41 world (`entered`). The 2 leftover items (`je` after `mov edx,1; and edx,1`; a re-read of a cell with no write in between) are proved unreachable by the FL-67 prover (tier T-EQ-INFEASIBLE).

## Tool changes (`scripts/fl68_search.py`, `scripts/fl62_concolic.py`)

- fl62 concolic reads the sites of `tests/fl68_sites.json`, so fl62 now covers rows with registered indirect calls (0x42c221 went 361 -> 462/470 instructions from this alone).
- New search move classes: a callee that stores into ANY global the run reads (also one the function cleared itself, any width), and compare flips played as a callee store (`gflips`, 20 calls x 120 cells x 2 values). 0x42c221 needed the 11th of 13 callee calls to set a word; the old limit was the first 6 calls and dword input cells only.
- A compare on a register loaded from memory just before it (`movsx edx, word [g]; test edx, edx`) is traced to the loaded cell (`read_pcs`).
- Every kept scenario is a parent for the goal-directed classes; a Unicorn mapping error (UC_ERR_NOMEM) in a wild scenario is a fault, not a crash of the search.
- Class order is flips, flips as callee stores, then returns/cells/registers, then callee stores to globals.

## The 23 stuck Mac-port rows after a 4 to 5 minute concolic + search pass each

- Cleared (2): 0x46cda0 (1,070/1,070), 0x431b5a (912/912).
- Still partial (kept as is): 0x47bb56 293/334 (33/38 dirs), 0x48ae05 555/583 (61/68), 0x4933ff 435/453 (32/38), 0x4a8d28 686/878 (57/72), 0x482a08 1,004/1,012 (129/132; prover out of memory), 0x47c0f0 758/758 (73/74; prover gives up, as before), 0x4a0ec3 142/154 (11/12; prover out of memory, crash path), 0x49d945 563/599 (73/76; crash path: divide by zero in the original), 0x43a7ca 1,081/2,335, 0x435015 513/2,089.
- Not run this thread: 0x45f0e6 0x471722 0x49e455 0x49f86a 0x4a0365 0x427a50 (large dispatchers), 0x41f5b1 0x47ac33 (prover timeouts), 0x4272b2, 0x49251f, 0x4477d1.
- The dispatchers need a concolic engine that models callee stores (a callee write is a symbolic input) and indirect-call sites; fl62 now takes sites but still refuses rows whose callees' x87 effect it cannot read (0x4f2710).

## Running it

- `FL66_CACHE=<dir> python3 scripts/fl62_concolic.py ROW --budget-s 300 --out F --report R` then `python3 scripts/fl68_search.py ROW --scen F --out G --budget-s 300` then `python3 scripts/fl66_tested.py check --redo --scen F --scen G ROW`; use `--prove` only for small rows (z3 ran out of memory on four of them and the child dies with exit -6, which leaves an `error` row result: re-check without `--prove`).
- Do not run two long searches and the pool compile at once on a 4-CPU container with 15 GB (a search died with UC_ERR_NOMEM; now a fault).
