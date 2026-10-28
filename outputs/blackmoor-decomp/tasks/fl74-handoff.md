# FL-74 handoff: stuck near-miss Mac-port rows (2026-10-28 PDT, cloud thread)

FL-74 took 19 near-miss rows from FL-72 and cleared 14 of them with FL-73's method (hand-built start state for each gate). Whole ledger: **2,210 of 4,188 verified ported (unchanged)**, **1,685 tested equivalent** (was 1,668), about 165 translated only. Mac-port view (Game + Vorbis, 2,685): **ported 2,209, tested equivalent 410, pending 66**.

## Cleared
- Tested equivalent by scenarios: 0x4c62f0 0x4cf9f4 0x4d7162 0x4d812e 0x4ec4b9 0x4d6b48 0x48c1c0 0x45e6bd 0x4e0978 0x4ea3a0 0x4adb6c (plus the rows listed in `tasks/fl66-tested-equivalent.json`).
- Proved infeasible (z3): 0x4dc182 0x4e467f 0x41137f (the last one needs a 45 KB string to reach 0x41154e).
- The scenario sets are in `tasks/fl74/scenarios.json` and the per-row results in `tasks/fl66/rows/`.

## Parked (5 rows), with reasons
- 0x456516: one direction left, the fall-through of `jns` at 0x456a0b. It needs `push eax` at 0x4569f7 to change the cell read at 0x4569fb, so a pointer must point into the stack. That is an aliasing input, so it belongs to Glib's open no-alias question. A first attempt shifted overrides wrongly and hit the instruction limit.
- 0x44ffa3 and 0x4a14c6: infeasible by reading the code (a copy compared against its own source), but z3 returns unknown or runs out of memory, even with a long budget (`winlong.py`, `tac.py`).
- 0x44b641: the infeasible directions are blocked by the prover's irreducible-loop limit (loop at 0x44b98f). A loop invariant entry in `tests/fl73_invariants.json` for headers 0x44b9c0 and 0x44bafc did not help.
- 0x4bbb3e: feasible directions not yet reached.
- FL-73's 0x471722 and 0x47c0f0 were not tried: both need pointer overlap.

## Tools (tasks/fl74/)
`ctx.py` (instructions before a jump), `rd.py` (cells read at a pc, pipe to head), `eqv.py` (make two compared cells equal or different), `allret.py`, `srcset.py`, `fillptr.py`, `esiset.py` (repe cmpsb strings), `addscen.py ROW FILES` (merge into scenarios.json), `why.py` (z3 model for a sat), `winlong.py`, `tac.py`, `try.py`. `out/` is scratch and not committed.

## Lessons
1. A "copy vs its own source" compare is infeasible, so prove it rather than searching.
2. Craft at the read pc of the input cell. If the cell is re-read after a callee, use a callee store (wrat) between the reads.
3. A prover "sat" can be real: 0x45e6bd had a loop back edge, so the direction was reachable and a scenario was the right answer.
4. Overrides on cells the function writes itself have no effect.
