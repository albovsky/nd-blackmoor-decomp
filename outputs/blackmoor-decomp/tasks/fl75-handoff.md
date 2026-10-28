# FL-75 handoff: prover extensions for the last Mac-port rows (2026-10-28 PDT, cloud thread)

Goal: clear the Mac-port pending rows that FL-72 was not working on, by making the infeasibility prover (T-EQ-INFEASIBLE) handle irreducible-looking loops, big graphs and crash paths. Strict "verified" is unchanged (2,210 of 4,188). Credit is "tested equivalent" (Unicorn scenarios, every instruction and both jump directions) or T-EQ-INFEASIBLE (z3 proof of the ORIGINAL bytes, one proof per missing item).

## Result

Nine Mac-port rows cleared (PR 259). Whole ledger: verified/ported 2,210 of 4,188 (unchanged), tested equivalent 1,714 (was 1,686 before FL-75; FL-76 batches 1 to 3 added 19), of which proved infeasible 96 (was 88: seven from this PR, 0x416fb6 from FL-76). Mac-port view (Game + Vorbis, 2,685): ported 2,209, tested equivalent 439, pending 37.

- Proved (T-EQ-INFEASIBLE, every missing item refuted by z3): 0x44b641, 0x44ffa3, 0x4bbb3e, 0x417b04, 0x4b4a68, 0x45c18f, 0x4a0ec3 (crash-path row). 0x4a14c6 was proved too, but only with a callee-footprint model that I removed (see below), so it is pending again.
- Tested equivalent by scenarios only: 0x4a6c61 (112/112 directions), 0x4867bd (94/94).
- All 96 proved rows re-proved with the final prover (`tasks/fl73/tools/reprove_all.py`): still hold. Run `reprove_all.py` with at most one other heavy job (z3 can run out of memory). A z3 out-of-memory error during `check --prove` now leaves the row partial (`prove_leftovers`).
- Soundness: `tests.test_fl71_window` compares the windows with the full analysis. The new esp/ebp relation makes a window stronger than the full analysis on `gen_loop_moves_esp` (both targets are really unreachable); the test now lists those two explicitly (`STRONGER`).
- Loop plans: the plan used to be found by a 3 s sink check, which flipped between runs on a busy machine (0x44b641 was proved or open depending on load). `tests/fl75_plans.json` now gives the starting plan per function; numeric bounds are still checked (`sink_unsat`) and bumped when too small. Added for 0x44b641.

## Prover changes (read before touching the provers)

All in `scripts/fl67_infeasible.py`, `scripts/fl71_window.py`, assumptions are spelled out in `RULE_TEXT2` of `scripts/fl66_tested.py` (the committed manifest carries that text).

- **Jump tables are cut at their range check** (`Analysis.tighten`): a table read past `cmp X, K; ja/jae` is cut to K+1 cells. Reading the whole table ran into the next switch's table and made fake "irreducible loops" (0x44b641). The cut is not trusted: `verify_escapes` has z3 prove the index is within the kept cells at the jump (`Unsupported` otherwise). If the tight run raises, `prove_row` retries with the loose tables.
- **OR atoms in loop invariants** (`tests/fl73_invariants.json`, `{"or": [atoms]}`), used for a word counter that could wrap in 0x44b641.
- **Frame assumption per window.** The SPLIT assumption (frame slots out of reach of other pointers and callees) was whole-function and switched off by any `lea reg, [ebp-K]`. Now `Analysis.frame_safe(S, region)` allows it in a window when no frame-address instruction is in the window or can reach its start. The whole-function pass is unchanged.
- **Callee return bounds** (`Machine.ret_bound`): a direct callee whose straight-line bytes end `and eax, K; ret` (0 <= K < 2^31) returns at most K (real rand, 0x50cd50, returns <= 0x7fff).
- **Forward "every run that takes it faults later" windows** (`fl71_window.prove_faults`, `forward_region`, `run_forward`, plus `stack_delta` and `relate` which tie esp to ebp from the pushes, pops and calls so a push cannot alias a local). A backward window from a dominator to the target and a forward window from the target to the rets are solved together; unsat means no run takes the item and reaches a ret without a fault (access >= 0xfff00000, div by zero, quotient overflow). Whole-function symbolic runs of the crash-path rows ran z3 out of memory; the windows do not. Cleared the crash-path row 0x4a0ec3.
- **Removed: callee write footprints.** I first modelled `lea R,[ebp-K]; push R; call C` with a callee C that provably writes only through its pointer argument, so a function that forms a frame address keeps the frame assumption (it proved 0x4a14c6). Codex found 13 soundness gaps in that analysis over five rounds (returned pointer, entry-register alias, pointer forwarded to a second callee, partial register writes, reads of the saved ebp, loads through the pointer, teardown order, aliases made between the push and the call, `lea`-derived pointers, implicit stack writes after an `add esp`). Each fix exposed the next, for one row, so I dropped it; the module is kept as a record in `tasks/fl75/rejected/fl75_footprint.py` and is imported nowhere. A sound version needs full esp tracking with callee pop counts and tracking of every value derived from the pointer. 0x4a14c6 stays pending (its whole-function proof also runs z3 out of memory).
- Other Codex findings, all fixed with tests that fail without the fix: `run_window(want_state=True)` returned the arrival state before the invariant and table checks; a forward window counted only `ret` as completion, so a tail jump out of the body looked like "always faults"; `stack_delta` kept the esp/ebp tie past `leave` / `pop ebp`; windows and dominators used the cut jump tables, so a block reachable only through a discarded cell looked unreachable (windows now use the whole tables, `from_analysis`).
- Hardening from an independent audit: invariant facts are guarded by the header's arrival condition (`Implies(ic[node], inv)`), so they no longer constrain runs that skip the header; `stack_delta` gives no relation behind a 16-bit push/pop, `enter`, `pusha`/`popa`, `pushf`/`popf` or a write to sp/bp. Known and accepted: a path that never terminates counts as "faults later" (scenarios are terminating runs); `frame_escapes` does not flag `push ebp; pop eax`, `pushad` or `enter` (unchanged from before this PR).
- Gotchas: `stack_delta` gives no value for a block that ends in `ret` (conservative, only loses a fact). Keep window prover changes tested with `tests.test_fl71_window` and `tests.test_fl67_infeasible`; re-prove all rows with `tasks/fl73/tools/reprove_all.py OUT`.

## Scenario work

0x4bbb3e: callee stores between two reads (`tasks/fl75/eq1.py`, scenarios in `tasks/fl74/scenarios.json`). 0x45c18f, 0x4a6c61, 0x4867bd: equal strings for `repe cmpsb` at the gate PCs (`cmpeq.py`), 12 pages of string for the long loop in 0x4867bd; then proved or covered. The scenarios are in `tasks/fl75/scenarios.json`. `tasks/fl75/addscen.py` merges new ones, `dbgrun.py` runs one with a PC trace, `allreads.py`/`hits.py` list reads.

## Still open

- **0x4a14c6**: needs the callee-footprint idea done soundly (see above) or a loop/size argument; pending.
- **0x49d945** (crash path): three error-path directions (0x49da7c, 0x49db1c, 0x49dbc5 fall-through) and the instructions behind them (0x49da7e..0x49daa7, 0x49db1e..0x49db47, 0x49dbc7..0x49dbf0). In the original they crash later at `idiv dword [ebp-0x70]` (0x49e06b) after the diagnostics helper 0x4c97b4 returns (it is not noreturn), but the forward window crosses three counting loops whose generalised headers lose the frame cell, so z3 says sat. A loop invariant (`tests/fl73_invariants.json`: the counter cells keep a zero) for those loops is the next idea. These error paths would be a user-facing crash in the Mac port, so a decision is also needed on whether the port should mimic the crash.
- Prover rows handed over by FL-76 (scenarios complete, only impossible directions left): 0x47b767, 0x4e0e2b, 0x4e812f, 0x4ba56a (see `tasks/fl76-handoff.md`).
- Parked on the no-alias question for Glib: 0x456516, 0x471722, 0x47c0f0.
- FL-77 works on the other scenario rows; it sends any row that needs the prover.

## Follow-up after PR 259: prover rows from FL-76 and FL-77 (2026-10-28 PDT)

Five more rows proved (T-EQ-INFEASIBLE): 0x4a2180, 0x420c17, 0x4a4f58 (FL-77 scenarios in `tasks/fl77/out/`), 0x47b767, 0x4e0e2b (FL-76 scenarios in `tasks/fl76/out/`). Prover changes, each with a test that fails without it (`Fl75` in `tests/test_fl67_infeasible.py`):

- **SEH prologue keeps the frame assumption** (`seh_registration` in `scripts/fl67_infeasible.py`): `mov dword ptr fs:[0], esp` was treated as handing out a frame address, which switched the frame assumption off for every MSVC function with an exception frame (0x420c17). It is exempt when the function reads fs:[0] only before it (the saved chain head). Modelling assumption: the chain is read by exception dispatch, which the prover treats like a fault; text added to `RULE_TEXT2`.
- **Windows execute past the target when a loop invariant was assumed** (`run_window`): a target inside a loop used to stop the window before the loop-closing blocks, so the invariant could not be proved inductive and the window was refused. Now the rest of the window runs and the invariant is checked (0x4e0e2b: `i >= 0` at the header 0x4e0f16, `tests/fl73_invariants.json`).
- **esp is tied to ebp at a generalised loop header** (`run_window`, `run_forward`): the freshened esp lost its relation to ebp, so a push in the body could "alias" a frame slot. When `stack_delta` knows the value at the header, `Implies(arrival, esp == ebp + delta)` is added.
- **Jump-table cuts in windows are validated up front** (`validate_cuts` in `scripts/fl71_window.py`): the window graph and dominators use the cut tables only when each cut is proved for a start state at a dominator of the jump (first-violation argument in the docstring); otherwise the whole tables are used (the PR 259 behaviour). The cut keeps the graph reducible in big switch functions (0x4e812f).
- **Plan hint for 0x4a4f58** (`tests/fl75_plans.json`): `gen` for every loop header except the 4-iteration zeroing loop at 0x4a56aa (5 unrollings), so the whole-function run no longer runs out of memory.
- A z3 out-of-memory error during `check --prove` leaves the row partial instead of an error (kept from PR 259).

Audit hardening (Sonnet slice review, all fixed with tests): `seh_registration` also requires that no branch of the function targets an address from the entry up to the registration (the prologue runs once, in address order, so a read can never run after the registration) and rejects any fs-prefixed instruction other than the allowed ones; `from_analysis` clears the `stack_delta` cache and the facts of the validation windows when it falls back to the whole tables. Known and accepted: exception dispatch that resumes in the function (a filter returning CONTINUE_EXECUTION) and catch continuations have no CFG edges, as before.

Numbers after the follow-up (main d73cb15 plus this PR): verified 2,210 of 4,188 (unchanged), tested equivalent 1,729 (proved 102), Mac-port view (Game + Vorbis, 2,685): ported 2,209, tested equivalent 454, pending 22: 0x4090ab 0x40b34a 0x413187 0x41e647 0x425b8b 0x448d11 0x4899ca 0x496410 0x4c1716 0x4e4cb6 0x4e5fdb 0x4f0059 (FL-77, scenario work) and 0x418e52 0x456516 0x471722 0x47c0f0 0x48f181 0x49d945 0x4a14c6 0x4ba56a 0x4e812f 0x4f7207 (prover).

Glib answered "yes, keep the no-alias assumption" at 1:11 PM PDT on Oct 28. The prover's frame assumption (frame slots are out of reach of stores through other pointers and of callees) is the part of it that applies, and it stays switched off for a function that forms a frame address with `lea` (see below), so the rows that need more are still open:

**0x4f7207** and **0x418e52** pass a frame buffer or local objects to library or member calls (`lea edx,[ebp-0x40]; push edx; call sprintf`), so the frame assumption is off; both gaps prove at once if the assumption is forced (`prove_target` with `frame_safe` stubbed), so they only need a decision: do we accept "a formatted-output or member call that is given a frame address writes only inside the buffer and keeps no copy"? I did not assume it (it is the no-alias question, now covering library calls). **0x4e812f**: irreducible loop at 0x4e851f in the cut graph is gone, but every window times out (STEP_MS) and nothing proves; it needs the loops summarised. **0x4ba56a**: check times out at 1500 s. **0x49d945** unchanged.
- **0x456516, 0x471722, 0x47c0f0**: their last directions need a pointer into the stack (0x456516: `push eax` must change the cell read through a loaded pointer). A window with the frame assumption would rule it out, but the function forms frame addresses, so the assumption is off for it. Using the approved no-alias assumption here means a model in which a frame address formed by `lea` reaches only the cells at or above it, calls havoc those cells, and no copy of it is read back from memory: the same design space as the removed footprint model, so it needs its own PR with the audit that PR 259 needed.
- **0x48f181** (FL-77): one direction impossible by construction (0x48f3a2 taken); not run yet.

## Documented exceptions: Mac-port rows still pending after this thread (stopped at Glib's request, 1:41 PM PDT Oct 28)

Every row below has complete scenario coverage except the items named; each gap is impossible in the original, but the prover cannot show it without the stated model. No new rows were started after the stop.

| Row | What is left | Why it is not cleared | What would clear it |
| --- | --- | --- | --- |
| 0x4f7207 | `jne` 0x4f74da fall-through (0x4f74e0) | frame buffer handed to `sprintf` (`lea edx,[ebp-0x40]; push edx`), so the frame assumption is off; with it forced on, the gap proves at once | assumption that a library call given a frame object writes only inside it (not the no-alias question) |
| 0x418e52 | `je` 0x419886 taken | 8 `lea` of frame objects passed to member calls; same | same |
| 0x456516 | `jns` 0x456a0b fall-through | needs a pointer into the stack; frame addresses are formed (19 `lea`), so the assumption is off | alias model: a `lea` address reaches only cells at or above it, calls havoc those, no copy read back from memory |
| 0x471722, 0x47c0f0 | one direction each | need pointer overlap (same as 0x456516); large dispatcher / 3 KB function | same alias model |
| 0x48f181 | `je`/`jcc` 0x48f3a2 taken | FL-77 scenario file `tasks/fl77/out/0x48f181.json`; check not run | run `check --prove` with that file |
| 0x4e812f | 10 directions, 39 instructions (loops at 0x4e851f) | the cut graph is reducible now but every window times out | loop summaries for the 0x4e8212 / 0x4e851f loops, or a longer window budget |
| 0x4ba56a | 71 of 98 directions from feasible gates | `check --prove` times out at 1500 s; scenarios in `tasks/fl76/out/0x4ba56a.json` | smaller windows; copy of `this+0x1bc..0x1c8` to `this+0x1cc..0x1d8` is the equality to exploit |
| 0x49d945 | crash path (`idiv [ebp-0x70]` at 0x49e06b) | forward window loses the frame cell at three counting-loop headers | loop invariant entries in `tests/fl73_invariants.json` for those loops |
| 0x4a14c6 | one direction | needed the removed callee-footprint model | sound footprint model (see above) |

FL-77's own rows (0x4090ab 0x40b34a 0x413187 0x41e647 0x425b8b 0x448d11 0x4899ca 0x496410 0x4c1716 0x4e4cb6 0x4e5fdb 0x4f0059) are in its handoff.
