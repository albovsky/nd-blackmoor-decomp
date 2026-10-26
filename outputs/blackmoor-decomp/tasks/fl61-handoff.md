# FL-61 handoff: automated coverage generator for the lower translated rows

Ledger unchanged by this thread: **2,189 verified ported of 4,188** (main after PR 204/205), about 1,779 translated, unverified. FL-61 banked **0 rows**. What it adds is the tooling: a concolic coverage generator, boundary and compare-goal scenario makers, and one new sound survivor rule. FL-62 ported the generator to the upper rows (`scripts/fl62_concolic.py`) and did get rows clean there.

## What was built (all in `outputs/blackmoor-decomp`)

- `scripts/fl61_concolic.py`: runs the original x86 bytes in Unicorn with a z3 shadow of the input-dependent state (start registers, stack arguments, bytes at or above 0x537000, seed pages, TIB). It flips every untaken jump direction (generational search, cone-of-influence slicing, best-first alternating with FIFO, repair flips on faulting runs, store-pin moves) and writes children as `(seed, overrides)`, the corpus format. Every child is validated by real execution and by the native comparison; the shadow is never trusted. `fl56_add_rows.py ROW --scen FILE` takes the output.
  - Run: `python3 -u scripts/fl61_concolic.py ROW [ROW ...] --budget-s 120 --out FILE --report FILE` (or `--all --shard i/n`).
  - **Compare goals:** `--cmp-goals FILE [--cmp-seeds N]` writes scenarios that make the operands of each compare equal or one apart (`a == b`, `a == b +- 1`). These kill the mutants that turn a compare into its neighbour (a borrow flipped, `jg` into `jge`), which a coverage search never asks for. It killed `literal 63` on 0x44ecaf.
- `scripts/fl61_boundary.py ROW... --out FILE [--cap N] [--stub-parents N] [--regs] [--seed S]`: for each corpus scenario, finds the cells the original reads before it writes them and sets one of them to a boundary value of its width (zero, one, sign and carry edges, the row's constants and their neighbours, the cell +-1, and "decorated" constants that match in the low byte or half but not above it, which kills narrower-read mutants). `--stub-parents` also uses seeds from 40000 on as parents (callee stubs then return boundary values); `--regs` also varies one start register.
- `tests/fl40_mutation_check.py --scen FILE`: a survivor is retried on those scenarios; killers are appended to the corpus. `tests/fl40_world.py run_original(..., watch=...)` is the Unicorn hook the generator uses.
- `scripts/fl40_survivors.py`: new rule **`forwarded store`** (FL-62's `global_forward_ok`, ported to the lower text): a narrower read of a global right after a store of a small constant to the same global on the same straight line (no label, call or aliasing store between). **Soundness sweep** (`tasks/fl61/forward-sweep.txt`): all 44 lines in 12 corpus rows where the rule fires, run as real mutants against the corpus plus 300 fresh seeds in the stub-boundary style (`--base 40000`): **0 killed**. Unit tests in `tests/test_fl61_concolic.py`.
- `tests/test_fl61_concolic.py` (5 tests; the real-row test needs Unicorn, z3 and the private original).
- Nine rows with full coverage were first added to the fl40 pipeline with `fl56_add_rows.py` (0x411b16 0x45eadc 0x45bbd8 0x44ecaf 0x467c0e 0x447eaf 0x4336ad 0x46c41e 0x41bbd9) and the differential tests passed (386), but a row in the verified corpus has to be accepted or held (`tests/test_fl46_verdicts.py`, `tests/test_fl56_unverified.py` fail otherwise: 4 failures in the `tests/test_fl*.py` run), and none was clean. **They are not in this PR.** Their coverage scenarios are in `tasks/fl61/scen-*.json` (per pass, keyed by row) and re-enter with `python3 scripts/fl56_add_rows.py ROW --scen tasks/fl61/scen-passN-i.json`.
- Logs and scenario files: `tasks/fl61/`.

## Coverage results (111 lower rows)

| result | rows |
|---|---|
| full coverage (every instruction, both directions of every jump) | 23 |
| partial | 50 (7 of them have every instruction run and one direction left) |
| refused at setup (strict lifter: indirect calls, recursion, callees not in the ledger, inline helpers) | 37 |
| not searched | 1 |

By body size: under 200 bytes 1 of 4 full; 200 to 399 3 of 12; 400 to 799 5 of 19; 800 and up 14 of 76 (one row, 0x427a50, was not searched). Full-coverage rows: 0x45eadc(154) 0x45bbd8(233) 0x44ecaf(332) 0x467c0e(337) 0x41bbd9(455) 0x447eaf(469) 0x4336ad(526) 0x46c41e(651) 0x4129da(735) 0x42b510(874) 0x411b16(1038) 0x478a2c(1087) 0x419955(1110) 0x472a5c(1131) 0x44efcd(1309) 0x45764a(1406) 0x46ee20(1680) 0x466e14(1682) 0x4313e3(1895) 0x458e55(1908) 0x460f26(2018) 0x43dbe3(2156) 0x441d74(7524). Seconds to a couple of minutes each.

Rows with one impossible direction (same compare repeated on unchanged operands, e.g. 0x44e9ae `jg` at 0x44ea6d, 0x42e693) need a new proof kind in `fl56_untaken` before they can be credited; this is the open Glib question about untaken-direction credits.

## Why nothing was banked

Coverage is the easy part. The exhaustive mutation check leaves survivors that no scenario can reach:

- **0x44ecaf (332 bytes):** 28 survivors after the first check; 18 identical -O2 code; 4 explained by `forwarded store`; boundary, decorated and compare-goal scenarios killed 5 more. **1 left:** `mov cx, [ebp+0xc]` literal `0xffff0001` on a register that is a constant folded from the stored globals (bit 0 is always 0). That needs a constant-folding rule.
- **0x467c0e (337 bytes):** 14 left, all 32-bit object-field reads (`[edx+0x264]`) narrowed to 16 bits: whenever the upper half is non-zero the original faults on the index it feeds, so no scenario shows the difference. Needs a range rule.
- **0x45eadc, 0x45bbd8:** survivors are 16-bit reads of frame locals (`[ebp-8]`, `[ebp-0x14]`) and 16-bit adds. The rescue (3,000 boundary scenarios per row) did not finish in 80 minutes (step-budget kills of loop-counter mutants dominate) and was stopped past the cap. Their unexplained survivor lists: `tasks/fl61/survivors-small2.json`.
- 0x411b16: 26 unexplained after the first check; the boundary rescue (2,500 scenarios against 26 mutants) did not finish in 50 minutes.

This matches FL-60's yield table: rows of 100+ bytes almost never clear. Every lower row is 153 bytes or more.

## Recommendations

1. Do not spend more effort on lower-half hand rules. Yield per row is near zero above ~150 bytes.
2. Run the generator on any new lower row only through `fl56_add_rows.py` so the corpus keeps its coverage; do not run the long boundary rescue on rows over ~500 bytes.
3. Useful sound rules still missing (each would clear specific survivors, all automatable): constant folding of registers loaded from forwarded stores; an index-range rule for object-field reads that feed an index; a loop-counter-width rule. Each needs its own soundness sweep like the one above.
4. The rescue is slow because step-budget kills of hanging mutants are run against every scenario; capping scenarios to those that reach the mutated line first would speed it up a lot.

## Operating notes

- A fresh container needs `pip install unicorn capstone z3-solver` and the private tarball extracted into `work/` at the repo root.
- Never `pkill -f` or `xargs kill` from a command line that contains the pattern (kills the shell); use `pgrep -f '^python3 -u scripts/fl61'` and kill PIDs.
- The cloud container restarted three times in this thread and killed background runs. Output files of the mutation checker are written only at the end of a row; keep a Monitor armed on long runs.
