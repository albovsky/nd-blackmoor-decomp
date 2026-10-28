#!/usr/bin/env python3
"""Write tasks/fl77-exceptions.json: the pending functions that are not tested equivalent, each with a reason code and a note.

    python3 tasks/fl77/make_exceptions.py [--write]

Every pending function that is not tested equivalent must be named here (CRT/MFC by rule from tasks/fl66-partial.json and the FL-68 handoff, Mac-port rows in MAC_ROWS); an unlisted one stops the script,
so the list cannot silently fall behind the ledger. Rerun after any change to tasks/fl66-tested-equivalent.json or tasks/fl67-infeasible.json, then build_function_ledger.py --write.
"""
import json
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parents[2]
ledger = json.loads((OUT / "function-ledger.json").read_text())
partial = json.loads((OUT / "tasks/fl66-partial.json").read_text())
TE = set(ledger["tested_equivalent"]["vas"])

REASONS = {
    "impossible_direction_unproved": "Every instruction runs on the original bytes and the translation agrees on all scenarios; the one jump direction left is impossible by construction, and the prover (run with the scenarios) did not discharge it.",
    "needs_frame_assumption_in_prover": "Coverage is full except a direction that is impossible in the original, but a frame object is handed to a library call, so the prover's frame assumption is off; it would clear with a stated assumption that such a call writes only inside the object.",
    "needs_alias_model_in_prover": "A direction needs a pointer into the stack or an overlap between two pointers. Glib kept the no-alias assumption, but the prover has no alias model yet (a lea address reaches only cells at or above it, calls havoc those).",
    "prover_window_times_out": "Scenarios cover everything that can run; the remaining directions are provably impossible in principle (loops and copies of equal data) but every prover window times out.",
    "needs_loop_invariants": "Only a crash path is left; the forward window loses a frame cell at counting-loop headers, so it needs loop invariant entries (tests/fl73_invariants.json).",
    "needs_callee_footprint_model": "One direction is infeasible by reading the code, but the proof needed a callee-footprint model that was removed after review found gaps.",
    "partial_coverage_gate_not_built": "Scenarios cover part of the function; the remaining code sits behind a gate whose state was not built (see the note for the coverage reached).",
    "no_scenarios_yet": "No scenario run reached more than the entry of this large function (or every run timed out); coverage is zero or negligible.",
    "census_unsplit_floor": "The census left this span unsplit (a floor), and the lifter refuses its jump tables into code, so it cannot be ported or tested.",
    "original_faults_on_every_scenario": "The original faults on every generated scenario, so there is nothing to compare against.",
    "translation_mismatch_open": "New scenarios disagree between the translation and the original; the translation has a defect that has not been fixed.",
    "needs_multi_cell_or_aliased_state": "The search reached everything except a few jump directions that need three or more cells to line up (a pointer aliasing the function's own pushes, wrapped address arithmetic, tail jumps with moved stacks), and the prover answers reachable.",
}

# Mac-port (Game + Vorbis) rows: va -> (reason code, note). Filled from the FL-75 and FL-77 handoffs.
MAC_ROWS = {
    "0x4090ab": ("no_scenarios_yet", "4,446-byte function; no scenario got past the entry (0 of 1,421 instructions)."),
    "0x40b34a": ("partial_coverage_gate_not_built", "Large loader with two switches (0x40b4ff, 0x40bab7); baseline 1,568 of 5,261 instructions and 87 of 362 directions, the hand-built switch state was not finished."),
    "0x413187": ("no_scenarios_yet", "0 of 1,123 instructions; every search run timed out."),
    "0x418e52": ("needs_frame_assumption_in_prover", "Left: the je at 0x419886 taken. Eight lea of frame objects are passed to member calls."),
    "0x425b8b": ("no_scenarios_yet", "0 of 246 instructions; every search run timed out."),
    "0x448d11": ("no_scenarios_yet", "0 of 647 instructions; no scenario got past the entry."),
    "0x456516": ("needs_alias_model_in_prover", "Left: the jns at 0x456a0b fall-through. Needs a pointer into the stack (19 lea of frame addresses)."),
    "0x471722": ("needs_alias_model_in_prover", "One direction needs the `this` pointer aliased onto the record table (the only wild store is at 0x472063); a large dispatcher, and the solver ran out of memory."),
    "0x47c0f0": ("needs_alias_model_in_prover", "758 of 758 instructions; one direction needs pointer overlap (3 KB function)."),
    "0x48f181": ("impossible_direction_unproved", "1,076 of 1,076 instructions and 145 of 146 directions; the jump at 0x48f3a2 taken is impossible by construction. check --prove ran for 722 s with the committed scenarios and did not discharge it."),
    "0x49d945": ("needs_loop_invariants", "Crash path (idiv [ebp-0x70] at 0x49e06b), paired with 0x4a0ec3; the forward window loses the frame cell at three counting-loop headers."),
    "0x4a14c6": ("needs_callee_footprint_model", "One direction left; a copy is compared against its own source."),
    "0x4ba56a": ("prover_window_times_out", "71 of 98 directions from feasible gates; the function copies this+0x1bc..0x1c8 to this+0x1cc..0x1d8 and compares them. check --prove times out at 1,500 s (scenarios in tasks/fl76/out/0x4ba56a.json)."),
    "0x4e812f": ("prover_window_times_out", "10 directions and 39 instructions left, behind loops at 0x4e8212 and 0x4e851f; every window times out."),
    "0x4f7207": ("needs_frame_assumption_in_prover", "Left: the jne at 0x4f74da fall-through (0x4f74e0). A frame buffer is handed to sprintf."),
    "0x496410": ("partial_coverage_gate_not_built", "24 KB function; baseline 366 of 4,985 instructions and 10 of 534 directions."),
    "0x4c1716": ("partial_coverage_gate_not_built", "Best search reached 495 of 1,019 instructions and 68 of 160 directions; the rest needs hand-built state."),
    "0x4e5fdb": ("partial_coverage_gate_not_built", "Hand-built recipes reached 221 of 365 instructions and 18 of 32 directions (scenarios not committed); the long-string and second-switch cases are open."),
    "0x4f0059": ("partial_coverage_gate_not_built", "Baseline 165 of 2,237 instructions and 31 of 510 directions; searches timed out."),
}

CRT_RULES = {
    "0x50ed50": ("census_unsplit_floor", "memmove: the census span is a floor and the lifter refuses its jump tables."),
    "0x50fa90": ("census_unsplit_floor", "memcpy: the census span is a floor and the lifter refuses its jump tables."),
    "0x510eda": ("original_faults_on_every_scenario", "The original faults on every scenario."),
    "0x510f3b": ("original_faults_on_every_scenario", "The original faults on every scenario."),
}


def cover(va):
    p = partial.get("partial", {}).get(va)
    if not p:
        return ""
    return " Coverage reached: %d of %d instructions, %d of %d jump directions." % (*p["instructions"], *p["directions"])


def main(write):
    rows, used = {}, set()
    pend = [e for e in ledger["entries"] if e["status"] == "pending" and e["va"] not in TE]
    for e in pend:
        va, region = e["va"], e["region"]
        if region == "crt_mfc":
            if va in CRT_RULES:
                reason, note = CRT_RULES[va]
            elif va in partial.get("mismatch", {}):
                reason, note = "translation_mismatch_open", "A scenario found by the search disagrees with the translation."
            else:
                reason, note = "needs_multi_cell_or_aliased_state", "Partial coverage; the remaining directions need several cells aligned." + cover(va)
        else:
            if va not in MAC_ROWS:
                sys.exit("Mac-port row %s is pending, not tested equivalent and has no entry in MAC_ROWS" % va)
            reason, note = MAC_ROWS[va]
            if "instructions" not in note:      # the notes written by hand carry their own, newer figures
                note += cover(va)
        rows[va] = {"reason": reason, "note": note}
        used.add(reason)
    stale = set(MAC_ROWS) - {e["va"] for e in pend}
    if stale:
        print("note: MAC_ROWS names rows that are no longer pending:", " ".join(sorted(stale)))
    doc = {"schema": "blackmoor-documented-exceptions/1",
           "rule": {"id": "X-DOC-EXCEPTION", "text": "The project stopped work on this pending function and recorded why. It is never ported, never tested equivalent and never added to the verified count. Approved by Glib on Oct 28, 2026 (stop the ledger tail)."},
           "reasons": {k: REASONS[k] for k in sorted(used)},
           "rows": {k: rows[k] for k in sorted(rows, key=lambda v: int(v, 16))}}
    text = json.dumps(doc, indent=1, ensure_ascii=False) + "\n"
    print("%d exceptions: %s" % (len(rows), ", ".join("%s %d" % (k, sum(1 for r in rows.values() if r["reason"] == k)) for k in sorted(used))))
    if write:
        (OUT / "tasks/fl77-exceptions.json").write_text(text)


if __name__ == "__main__":
    main("--write" in sys.argv)
