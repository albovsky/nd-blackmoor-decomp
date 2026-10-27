# FL-71 handoff: dispatchers and stuck Mac-port rows (2026-10-27 PDT, cloud thread)

Goal: clear the Mac-port rows FL-69 held, with a solver that treats callee stores as inputs. Strict "verified" stays 2,210 of 4,188 (never touched).

## Result

One PR (245, merged): 0x4272b2 tested equivalent (91/91 instructions, 20/20 directions); 0x41f5b1 and 0x48ae05 tested equivalent by proof (T-EQ-INFEASIBLE). Whole ledger after merging FL-70 PR 244: 1,627 tested equivalent (1,630 after FL-70's PR 246). Mac-port view on main: ported 2,209, tested equivalent 355, pending 121 of 2,685. Nothing else cleared: the other rows moved but did not finish (below).

## New tools

- `scripts/fl71_solve.py ROW --out F [--budget-s N] [--solver-ms N] [--scen F ...]`: FL-70's replay solver where each of the first 40 callee calls also gets a symbolic extra store (`STUB_WR`, enable/address/value symbols kept off the image, stack, stub pages and the function's own code). Solving pins every input group to the parent's value (`z3.substitute`) and releases 1 to 3 relevant groups, so z3 never faces a free 32-bit product.
- `scripts/fl71_window.py`: dominator-window infeasibility proofs. For an untaken direction or unexecuted instruction, take a dominator S of its block, run only the blocks between S and the target from a fully generalised state at S, and ask z3 whether the target is reachable. Sound by the "last visit of S" argument (see the module docstring). `fl67_infeasible.prove_row` tries it first and runs the whole-function analysis only for what is left; a row proved by windows alone stores `plan: {}`. It cleared 0x41f5b1 and 0x48ae05 where the full analysis timed out.
- `scripts/fl68_sites.py` reads the multi-line call form; `tests/fl68_sites.json` has 0x4272b2. `tests/test_fl71_window.py` has 7 tests.
- `tasks/fl71-scenarios.json`: the scenarios the solver found for the unfinished rows (pass as `--scen`), 0x43a7ca 65, 0x4f2710 26, 0x4933ff 11, 0x47ac33 9, 0x47bb56 7, 0x427a50 2, 0x4477d1 2.

## Where the open rows stand (instructions, directions)

- 0x4f2710: 635/798, 67/76 (was 592, 61 under FL-69). A 40-minute continuation was cut off by a container restart. Window proofs on its 163 leftovers ran over 9 minutes without finishing.
- 0x4933ff: 435/453, 32/38. Six untaken directions (0x493622, 0x493678, 0x49375e, 0x493806, 0x493828, 0x49384b); window proofs say unknown or sat for all, 30 minutes of solving added nothing. The flip at 0x493622 needs a nonzero shifted/masked value whose shifts and masks come from `.data` bytes at 0x5d2f19..0x5d2f1f; z3 answers differ from run to run (6.9 s sat, then unknown at 21 s), and one child diverged at the `rep stosd` at 0x493482 because the model changed the grid size.
- 0x47ac33: 178/351, 18/24 after 30 minutes; about 100 s per run. 0x4477d1: 113/176, 8/10; its two untaken directions (0x44796a, 0x447aa0) have no scenario and every window says sat; `--prove` ran out of z3 memory when three provers ran at once.
- 0x47bb56 (293/334), 0x49251f (unmapped reads on every seed), 0x47c0f0 (758/758 but one direction needs an aliasing scenario), 0x482a08, 0x4a8d28: not improved. The dispatchers: 0x43a7ca 1,081/2,335 in 25 minutes; 0x435015, 0x45f0e6, 0x471722, 0x49e455, 0x49f86a, 0x4a0365, 0x427a50 not run beyond the FL-69 numbers. The crash-path pair 0x4a0ec3 and 0x49d945 stays pending.

## Lessons

- z3 verdicts are time-flaky on products and shifts; a longer budget re-asks the same goals and sometimes wins. The in-loop `--solver-ms 2500` default is too tight for rep goals (about 3 s); use 4000 to 6000.
- A solved model does not always reproduce: check the first divergence of parent and child traces (the `rep` handling is the usual cause).
- At most two solver processes plus one prover at a time (4 cores, 15 GB); three provers at 3,500 MB each killed 0x4477d1 with `out of memory`. The per-row check timeout is 900 s (`--timeout`), too short for `--prove` on big rows; run `fl71_window.py ROW --targets FILE` on its own with `FL71_VERBOSE=1` (targets from the uncovered list of `fl66_tested.py check`).
- Review the PR comments before merging: Codex found two real P2 issues (the FL-40 world has no `stub_filter`; the window module's `Unsupported` is another class when `fl67_infeasible.py` runs as `__main__`). Both fixed.
- Build the progress map AFTER merging main into the branch (my first map predated PR 244 and had to be corrected).
