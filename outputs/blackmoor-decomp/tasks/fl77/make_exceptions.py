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
    "0x471722": ("needs_multi_cell_or_aliased_state", "Scenarios cover every instruction (1151) and 173 of 174 directions; the last, 0x4721d3 taken, needs byte [obj+0xd3b] nonzero, but the function only ever writes it 0 and clears it before the compare, so it needs a heap-field invariant or an alias of two object pointers that the prover cannot express."),
    "0x4a14c6": ("needs_callee_footprint_model", "One direction left; a copy is compared against its own source."),
    "0x4e812f": ("prover_window_times_out", "10 directions and 39 instructions left, behind loops at 0x4e8212 and 0x4e851f; every window times out."),
    "0x496410": ("partial_coverage_gate_not_built", "24 KB rasterizer; generic fuzz hits the instruction limit (about 15,700 passes of the loop at 0x4966ee). The loop exits only when [this+0x50e1] or [this+0x50e5] has bit 0x1000000 set and bits 0x10000000 and 0x20000000 clear, derived from the polygon and edge tables, so it needs a model of those tables. Baseline 366 of 4,985 instructions and 10 of 534 directions."),
}

CRT_RULES = {
    "0x50ed50": ("census_unsplit_floor", "memmove: the census span is a floor and the lifter refuses its jump tables."),
    "0x50fa90": ("census_unsplit_floor", "memcpy: the census span is a floor and the lifter refuses its jump tables."),
    "0x511a1a": ("impossible_direction_unproved", "FDIV-bug probe: the fall-through at 0x511a4d needs x - (x/y)*y above a threshold, which cannot happen with fixed .rdata constants on a correct FPU. Scenarios reach 20 of 24 instructions and 1 of 2 directions; overriding the constants reaches 24 of 24 but the translation embeds them and then differs."),
    "0x50f462": ("needs_multi_cell_or_aliased_state", "The 50f46f fall-through needs the FPU control word at entry to differ from 0x27f, which fnstcw supplies and no override can set; the 50f491 and 50f4a9 directions depend on flags left by the call to 0x513c65. Coverage 17 of 18 instructions, 4 of 10 directions."),
    "0x50df9d": ("needs_multi_cell_or_aliased_state", "x87 sqrt wrapper: the missing directions depend on the zero flag left by the caller before fnstcw, the control word from fnstcw, x87 status flags after the operation, and jumps to 0x513cbe and 0x513ccb outside the row span, whose edges the world does not record."),
    "0x50e05d": ("needs_multi_cell_or_aliased_state", "x87 cos wrapper: the missing directions depend on the zero flag left by the caller before fnstcw, the control word from fnstcw, x87 status flags after the operation, and jumps to 0x513cbe and 0x513ccb outside the row span, whose edges the world does not record."),
    "0x50e10d": ("needs_multi_cell_or_aliased_state", "x87 sin wrapper: the missing directions depend on the zero flag left by the caller before fnstcw, the control word from fnstcw, x87 status flags after the operation, and jumps to 0x513cbe and 0x513ccb outside the row span, whose edges the world does not record."),
    "0x50e28d": ("needs_multi_cell_or_aliased_state", "x87 atan2 wrapper: the missing directions depend on the zero flag left by the caller before fnstcw, the control word from fnstcw, x87 status flags after the operation, and jumps to 0x513cbe and 0x513ccb outside the row span, whose edges the world does not record."),
    "0x513cbe": ("needs_multi_cell_or_aliased_state", "Reads the control word the caller pushed at [esp]; in the test world the entry stack holds the return address there, so neither direction of the compare with 0x27f can be run."),
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
