# FL-68 handoff: the CRT/MFC rows of the tested-equivalent tier

Scope: the 280 CRT/MFC rows that were still pending after FL-66 (277 translated but partial, 3 without a translation). Reported as `verified X, tested equivalent Y, translated only Z` (`python3 scripts/fl66_tested.py status`).

## Batch 1 (this PR): tested equivalent 1,315 -> 1,446 (+131 CRT/MFC rows)

- `scripts/fl68_search.py`: goal-directed scenario search on the ORIGINAL bytes (Unicorn only; the translation is compared afterwards by `fl66_tested.py check`). Moves: compare flips (cell, register, callee return or start register set to the other operand of a compare in front of an untaken jump), boundary values of input cells, start registers, callee returns, then random pairs. Works where the concolic generators (fl61/fl62) stop at "Unsupported indirect call" (about 90 of the 277 rows). Run `gc.freeze()` after loading tables: `W.run_original` calls `gc.collect()` per run and a big heap made every run cost 0.15 s (now 20 ms).
- Harness fixes found by it (all in `tests/fl41_world.py` / `scripts/lift_fl41.py` / `scripts/fl66_tested.py`):
  - indirect calls and tail `jmp`s through a register or pointer that the FL-58 driver did not register as sites: `tests/fl68_sites.json` (built by `scripts/fl68_sites.py` from the translation text), and `site_hook` plays a `jmp` site as a tail call (no return address pushed or logged);
  - self-recursive rows (the entry is also a callee stub): the first instruction at the entry is the row itself;
  - import thunks (`jmp [slot]`) as callees: the pop count was guessed from the first `ret` after the thunk (16 for most); it is now the import's own stdcall argument count, or the followed `jmp` target. Seven rows re-translated by `scripts/fl68_relift.py` (replaces only those rows in the FL-57 file and table);
  - `__chkstk` (0x50c920) is a row now: pool `fl68`, `tests/fl68_rows.json`.
- `fl66_tested.py merge` keeps the committed partial/mismatch/error lists of earlier batches (their per-row result files are not committed) and only replaces the rows of the results directory. `FL66_ROWS` and `FL66_SCEN` pick the results and scenario directories (this thread used `tasks/fl68/rows`, `tasks/fl68/scen`, not committed).

## Batch 2: tested equivalent 1,446 -> 1,471 (incl. 21 by proof)

- Tail jumps out of a function that has extra words pushed (x87 math wrappers, `push edx ... jmp 0x513ccb`): `scripts/fl68_tailfix.py` rewrites the translation to restore `esp` from the entry value before the tail call (`esp0_`), and `tests/fl41_world.py` plays such a stub as a return to the row's own return address (`jump_out`, `play(..., base=)`). 19 rows patched; the rows that now reach full coverage are tested equivalent.
- Harness fixes: `0x51cab3` calls the lifted `__EH_prolog3` (uses the TIB), its table row now says `fs: true`; x87 C1 (round-up flag) is set by the hardware x87 under the translation and never by Unicorn, so `tests/fl41_world.py` masks C1 in the compared status word of rows that never read it (`c1_free`).
- `fl68_search.py` has a depth-two phase: a register or callee-return move that adds no coverage but makes the run read other cells (a null pointer reads cell 4) is explored with cell and compare moves on top of it.

## Batch 3 and final state (this thread stopped here: Glib moved it to the Mac-port rows)

- Tested equivalent 1,527 of 4,188 (was 1,315 before FL-68); CRT/MFC (1,503): tested equivalent 1,275, not needed 128, ported 1, pending 99 (was 280 pending).
- `fl68_search.py` gained: callee-store moves (a callee that sets a global the function reads again after the call), displacement constants of `lea`/arithmetic operands (`lea esi,[eax+0x20000]` needs a cell of 0xfffe0000), cell-equals-cell moves, near-stack pointer values, and a deeper second step (compare flips are unfiltered, edge moves sampled). That pass alone took 23 of the 119 partial rows to full coverage; run it on any pending row before reaching for a prover.
- `scripts/fl68_model.py` (z3 model to scenario) is an experiment that did NOT work: the prover's models wrap pointers around 2^32 or run loops hundreds of thousands of times, and the original faults or hangs on them. Not used for any credit.
- Mismatches (translation defects, not credited): 0x50c635 (an unwinder that loads `esp` from memory and `jmp eax`), 0x50c82b, 0x51f4ec (new scenarios from the search disagree with the translation; look at them with a row-vs-original diff).

### The 99 CRT/MFC rows still pending, and why
- 0x50ed50 (memmove) and 0x50fa90 (memcpy): the census left the span unsplit (a floor), and the lifter refuses their jump tables into code.
- The rest are rows where the search reached everything except a few jump directions that need three or more cells to line up (a pointer aliasing the function's own pushes with a key that equals a table entry and a count of one, wrapped address arithmetic, tail jumps with moved stacks) or whose original faults on every scenario (0x510eda, 0x510f3b). The FL-67 prover answers "reachable" for these, so they cannot be proved away. Ideas not tried: a real concolic engine with memory aliasing for the search, hand-written scenarios for the biggest rows (0x5110a9 is 1,825 bytes with 192 jump directions).
- Addresses: 0x50c635 0x50c82b 0x50c992 0x50d0bc 0x50d1f0 0x50d550 0x50d805 0x50df9d 0x50e05d 0x50e10d 0x50e28d 0x50e3de 0x50eb20 0x50ebca 0x50ed50 0x50f085 0x50f1d9 0x50f253 0x50f462 0x50f72d 0x50fa90 0x510375 0x5105b1 0x510764 0x510909 0x510ac9 0x510d20 0x510eda 0x510f3b 0x5110a9 0x511a1a 0x51249c 0x512675 0x5129a0 0x512d28 0x51332e 0x51384a 0x513bd7 0x513cbe 0x513ccb 0x514250 0x5145fe 0x514755 0x514893 0x514f8e 0x5152b9 0x515a64 0x515aa0 0x515b32 0x515c62 0x515e1e 0x516530 0x516810 0x516f69 0x5174bb 0x51779c 0x518a16 0x518b98 0x518caf 0x518d76 0x519009 0x519229 0x519561 0x519cc0 0x51a643 0x51aa23 0x51acc6 0x51aea1 0x51b257 0x51b2f1 0x51ba27 0x51c22e 0x51ce72 0x51d75b 0x51dc43 0x51de51 0x51e140 0x51eb41 0x51ebf8 0x51ee80 0x51ef5c 0x51f207 0x51f4ec 0x51f8c4 0x51fcc6 0x51ff98 0x52178e 0x521942 0x521972 0x521bed 0x522135 0x522d82 0x522ed0 0x5232d1 0x5236ae 0x523ad6 0x52401f 0x5242c7 0x5265e4

## What is left (written after batch 1; see above for the final state) (CRT/MFC pending after batch 1: see `status`)

- Directions that cannot be taken (`jb` then `jae` after an unsigned add, a compare against an immediate that is never zero, ...): wait for the FL-67 T-EQ-INFEASIBLE rule, then apply it to the partial rows; do not build a second one.
- Tail jumps to another function while the row has extra words pushed (`push edx; ... jmp 0x513ccb` in the x87 math wrappers): the callee stub returns to the pushed word, so the original runs on into garbage; the translation ends. Needs the stub to know the extra stack height.
- Fragments entered mid-function and rows whose original faults on every scenario.
- 0x50ed50 (memmove) and 0x50fa90 (memcpy): the census left the span unsplit (a floor: cannot be ported or not needed) and the lifter refuses them (jump tables into code).
