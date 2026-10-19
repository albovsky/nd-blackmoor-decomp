# FL-25 packet: session input handlers, third pass (the 19 larger handlers)

Read first: `tasks/FL-24-session-input-handlers-2.md` (same bar, same file shapes, same rules, same "Per function" items 1 to 6 and "Environment and rules"; this packet only changes the list and the numbering), the FL-24 handoff in `COORDINATION-STATUS.md`, `tasks/fl24a-handoff.md` / `tasks/fl24b-handoff.md`. Copy the shape of `src/original_methods_fl24a.c/.h`, `tests/fl24a_direct_test.c`, `tests/fl24a_differential_shim.c`, `tests/test_fl24a_differential.py`, `tests/test_fl24a_direct.py`, `tests/fl24a_fixtures.py`, `tests/fl24a_original_oracle.py`, `tests/fl24a_mutation_check.py`, `tasks/fl24a-acceptances.json`. The differential test also requires both directions of every conditional jump (allowlist of untaken edges with a reason, as FL-24).

## Why

The 19 handlers below are the remaining unblocked session-input rows with `executed_partial` windows (778 to 1,909 bytes). The existing oracle runs only their first bytes; new oracle scenarios must walk the whole body (every code byte executed) before a port is credited.

## Batches (span in bytes; smallest first; commit after each function that is complete)

- Batch a (`fl25a`): 0x45e1ca (778), 0x464792 (803), 0x4a835c (827), 0x45841e (896), 0x4b5d17 (896), 0x45565f (943), 0x473206 (1099), 0x4712bd (1125), 0x4b2250 (1735), 0x46bca9 (1909).
- Batch b (`fl25b`): 0x47b767 (786), 0x455180 (827), 0x4cb058 (851), 0x4a3f40 (896), 0x4588ad (901), 0x4a8818 (986), 0x4aa3d2 (1100), 0x46c6a9 (1506), 0x4a44c0 (1877).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl25aWorld`, `Fl25bWorld`), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list, nor the receipt blockers `0x469057`, `0x4897cd`, `0x4b42d3`, `0x4e0978`, nor `0x4f0059`, `0x43a7ca`, `0x4d3073`, `0x4477d1`.

## What differs from FL-24

- These are big: go function by function, smallest first, commit each finished function (port, direct test, differential, oracle scenario, acceptance entry). If a function's fixtures cannot reach every code byte, or the body calls something that changes `self` in a way you cannot script, drop it with a written reason; the default is to land finished ports and send the rest back to the pool.
- Several functions (0x4b2250, 0x4a44c0, 0x46bca9, 0x46c6a9) likely contain loops, jump tables or nested guards; every switch arm, loop exit and out-of-range default arm must be reached by fixtures and ported. Share one fixtures module per batch; keep the oracle script one summary line per function with a digest, exit 0 only if every assigned and finished function is fully covered.
- The batch handoff file `tasks/fl25<x>-handoff.md` follows the FL-24 shape (ported, dropped with reason, divergences and unverified branches, hooks, test commands/results, oracle instruction coverage per function, mutation survivors, branch and commit).
