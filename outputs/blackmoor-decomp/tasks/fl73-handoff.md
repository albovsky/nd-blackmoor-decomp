# FL-73 handoff: hardest Mac-port dispatcher rows (2026-10-27 to 10-28 PDT, cloud thread)

Goal: clear the Mac-port rows FL-71 held. Strict "verified" is unchanged (2,210 of 4,188). Credit is "tested equivalent" (translation matches the original x86 under Unicorn, every instruction run, both directions of every jump) or T-EQ-INFEASIBLE (z3 proof).

## Result (PRs 249, 250, 252, all merged)

- PR 249: 0x4477d1, 0x47bb56, 0x482a08, 0x4a8d28, 0x427a50 tested equivalent; 0x47ac33 and 0x4933ff by proof.
- PR 250: 0x49251f, 0x49f86a, 0x4a0365, 0x49e455.
- PR 252: 0x45f0e6, 0x435015, 0x4f2710 tested equivalent; 0x43a7ca tested equivalent (2,329 of 2,335 instructions run, the last 6 instructions and 2 directions proved with a loop invariant).
- Whole ledger: 1,668 tested equivalent, verified/ported 2,210 (unchanged). Mac-port view (Game + Vorbis, 2,685): ported 2,209, tested equivalent 393, pending 83.

## Method that worked

Random and solver search stalled on these rows. What cleared them was building the game state a gate needs by hand: globals, struct fields, callee returns, callee stores between two reads of one cell, equal strings for `repe cmpsb`, 40 KB strings. Loop: list the untaken directions (`tasks/fl73/tools/un.py`, instruction limit 200000 like fl66), read the gate (`disx.py`), craft a scenario, then `fl66_tested.py check ROW --redo [--prove] --scen F`, `merge --write`, evidence, ledger, names, targeted tests.

Tools in `tasks/fl73/tools/`: `insp.py`, `un.py`, `disx.py`, `gsweep.py` (env REQ, SAMPLE, ZR), `stubret.py` (set a stub's return at a call PC), `wrat.py` (callee store at a computed address), `cmpeq.py` (make `repe cmpsb` strings equal), `bigstr.py` (1 KB override cells; JSON ints over 4,300 digits fail), `grid.py`, `onehot.py`, `craft.py`, `diverge.py`, `winv.py` (one window with the error), `reprove_all.py` (re-prove every manifest row).

Gotchas: a cell read twice needs a callee store between the reads. A debug flag read in many places (0x63a4cd in 0x4f2710) adds callee calls when set and shifts every later stub return, so re-search. Use the same INSTRUCTION_LIMIT (200000) as fl66 or coverage does not count. Never `pkill -f` (it kills the shell); kill by PID. `FL67_MEM_MB` raises the z3 memory cap.

## Prover changes (read this before touching the provers)

- Loop invariants: `tests/fl73_invariants.json` plus `Analysis.verify_invariants` in `scripts/fl67_infeasible.py` and `fl71_window.run_window`. A hand-written invariant (slot vs constant, or slot vs slot) is assumed at a generalised loop header and then proved by z3 (satisfiable, initiation on each entry edge, consecution on each back edge), otherwise `Unsupported`. Used for 0x43a7ca at 0x43b697 and 0x43b6b7. Tests: class `Invariants` in `tests/test_fl67_infeasible.py`.
- **Bug found and fixed:** the frame window pass added in PR 249 treated ebp-relative addresses as `mem` and esp-relative as `frm`, although a window start has independent s_ebp and s_esp, so it could call a reachable jump impossible. `tests/test_fl71_window.py` caught it, but PRs 249 and 250 had not run that test. `has_frame_term` now counts `s_ebp`, `s_esp` and the fresh `sp<N>` symbols. All 84 proved rows were re-proved with the fix and still hold. Run `tests.test_fl71_window` and `tests.test_fl67_infeasible` after any prover edit.

## Still open

- 0x471722: one direction that needs the `this` pointer aliased onto the record table; the only wild store is at 0x472063. Not provable infeasible (it is reachable in principle).
- 0x47c0f0: 758/758 instructions but one direction needs the same kind of aliasing; the flow breaks when the pointer overlaps `this`.
- Crash-path pair 0x4a0ec3 and 0x49d945 stays pending. FL-72 holds the rest of the pending Mac-port rows.
- Codex review was out of usage on PR 252 (no findings); the earlier PRs had the same limit.
