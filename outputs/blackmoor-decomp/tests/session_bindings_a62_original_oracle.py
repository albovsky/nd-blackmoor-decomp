#!/usr/bin/env python3
"""RT-3 oracle: native 0x62 session binding vs the original dispatcher x86.

Each sequence drives the unmodified FUN_00427a50 dispatcher (which clears the
request dword, evaluates the dependency gate FUN_00423f57 and calls
FUN_0042ea87) over several consecutive ticks in Unicorn, and drives the real
native scene session + session_bindings_a62 over the same ticks. State is
compared after EVERY tick: phase, completion, request, the four response
words, the start flag DAT_005bb1ca and the event flags. Selector changes, gate
flips and the 0x43c054 candidate store (phase := 2) are applied to both sides
between ticks.

No platform-boundary hooks are installed: the dispatcher and handler run
unmodified; only fixture memory (action slot, selector, event flags and the
hand-built false-gate dependency node of the A-62 oracle) is written.

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/session_bindings_a62_original_oracle.py
"""

from __future__ import annotations

import argparse
import json
import struct
import sys
import unittest
from pathlib import Path
from typing import Any

import action_family_62_original_oracle as base_oracle
from action_family_62_original_oracle import (
    ACTION_DONE_VA, ACTION_INDEX, ACTION_PHASE_VA, ACTION_REQUEST_VA,
    ACTION_RESPONSE_VA, ACTION_STRIDE, DEFAULT_EXE, DISPATCHER_VA,
    EVENT_FLAGS_VA, GAME_STATE_VA, SCENE_ACTION_COUNT_VA, SELECTOR_VA,
    STARTED_VA, CALLER_OBJECT_VA, OracleFailure, OriginalA62Oracle, read_i16,
    read_i32, read_u32)
from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, sha256
from test_action_family_62 import make_body

import session_binding_support as s
import test_session_bindings_a62 as native

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-3-a62-session-original-oracle.json"

EVENT_IDS = (3, 4, 5, 6)
GATE_CLOSED = 0x33333333  # event 3 != 0 makes the hand-built node false
GATE_OPEN = 0
INITIAL_FLAGS = {3: GATE_CLOSED, 4: 0x44444444, 5: 0x55555555, 6: 0x66666666}

ENTRY_A = (0, 10, 0, 20, 0, 30, 0, 40, 0)     # selector 0 -> (10, 20, 30, 40)
ENTRY_B = (7, -1, 0, -2, 0, -3, 0, -4, 0)     # selector 7 -> (-1, -2, -3, -4)


class OriginalSequence(OriginalA62Oracle):
    """One 0x62 row ticked repeatedly through the original dispatcher."""

    def begin(self, body: bytes, *, subtype: int, gated: bool, selector: int):
        self.prepare(body, phase=0, subtype=subtype, completed=0,
                     selector=selector, dep_root=1,
                     dep_has_children=1 if gated else 0,
                     false_event_dependency=gated)
        for event_id, value in INITIAL_FLAGS.items():
            self.uc.mem_write(EVENT_FLAGS_VA + event_id * 4,
                              struct.pack("<i", value))
        self.uc.mem_write(SCENE_ACTION_COUNT_VA, struct.pack("<h", 1))

    def tick(self, *, selector: int, gate_open: bool | None, force_phase2: bool):
        self.uc.mem_write(SELECTOR_VA, struct.pack("<h", selector))
        if gate_open is not None:
            value = GATE_OPEN if gate_open else GATE_CLOSED
            self.uc.mem_write(EVENT_FLAGS_VA + 3 * 4, struct.pack("<i", value))
        if force_phase2:
            self.uc.mem_write(ACTION_PHASE_VA + ACTION_INDEX * ACTION_STRIDE,
                              struct.pack("<i", 2))
        self.uc.mem_write(GAME_STATE_VA, struct.pack("<i", 3))
        self.call(DISPATCHER_VA, (), this=CALLER_OBJECT_VA)
        row = ACTION_INDEX * ACTION_STRIDE
        return {
            "phase": read_i32(self.uc, ACTION_PHASE_VA + row),
            "completed": self.uc.mem_read(ACTION_DONE_VA + row, 1)[0],
            "request": read_u32(self.uc, ACTION_REQUEST_VA + row),
            "response": [read_i16(self.uc, ACTION_RESPONSE_VA + row + w * 2)
                         for w in range(4)],
            "started": read_u32(self.uc, STARTED_VA),
            "flags": {str(e): read_i32(self.uc, EVENT_FLAGS_VA + e * 4)
                      for e in EVENT_IDS},
        }


class NativeSequence:
    def __init__(self, lib, body: bytes, *, subtype: int, gated: bool,
                 selector: int):
        self.test = unittest.TestCase()
        deps = (s.flag_gate(3, GATE_OPEN),) if gated else ()
        self.fixture = native.A62Fixture(
            self.test, lib, [s.action(0x62, subtype, body, deps)],
            selector=selector)
        for event_id, value in INITIAL_FLAGS.items():
            self.fixture.flags[event_id] = value
        self.started = base_oracle.INITIAL_STARTED

    def tick(self, *, selector: int, gate_open: bool | None, force_phase2: bool):
        f = self.fixture
        f.selector = selector
        if gate_open is not None:
            f.flags[3] = GATE_OPEN if gate_open else GATE_CLOSED
        if force_phase2:
            self.test.assertEqual(f.lib.scene_session_accept_action_candidate(
                f.session, 0), 0)
        before = len(f.start_flag_writes)
        status, _result = f.tick()
        if status != s.SESSION_OK:
            raise OracleFailure(f"native session tick returned {status}")
        if len(f.start_flag_writes) > before:
            self.started = f.start_flag_writes[-1]
        completed, phase = f.state()
        request, response = f.target()
        return {
            "phase": phase, "completed": completed, "request": request,
            "response": list(response), "started": self.started,
            "flags": {str(e): f.flags[e] for e in EVENT_IDS},
        }

    def close(self):
        self.fixture.close()


def sequences() -> list[dict[str, Any]]:
    two_entries = make_body(event_pairs=((5, 11), (6, 22)), threshold=0,
                            entries=(ENTRY_A, ENTRY_B))
    plan = [
        # selector, gate_open (None: unchanged), force_phase2
        (0, True, False), (0, None, False), (7, None, False), (99, None, False),
        (0, None, False), (0, False, False), (0, False, False),
        # Candidate store while the gate is closed: the dispatcher skips the
        # row, phase 2 waits, and the first open tick completes it.
        (0, False, True), (0, False, False), (0, True, False),
        (0, None, False), (0, None, False),
    ]
    return [
        {"name": "subtype1_gated_selector_gate_phase2", "body": two_entries,
         "subtype": 1, "gated": True, "initial_selector": 0, "plan": plan},
        {"name": "subtype1_threshold35_stays_pending",
         "body": make_body(event_pairs=((5, 11), (6, 22)), threshold=35,
                           entries=(ENTRY_A,)),
         "subtype": 1, "gated": False, "initial_selector": 0,
         "plan": [(0, None, False), (0, None, True), (0, None, False),
                  (0, None, True), (0, None, False)]},
        {"name": "subtype1_threshold34_completes",
         "body": make_body(event_pairs=((5, 11), (-1, 22)), threshold=34,
                           entries=(ENTRY_A,)),
         "subtype": 1, "gated": False, "initial_selector": 0,
         "plan": [(0, None, False), (0, None, True), (0, None, False)]},
        {"name": "subtype2_reopens_and_republishes",
         "body": make_body(event_pairs=((5, 11), (6, 22)), threshold=0,
                           entries=(ENTRY_A,)),
         "subtype": 2, "gated": False, "initial_selector": 0,
         "plan": [(0, None, False), (0, None, True), (0, None, False),
                  (0, None, False), (0, None, True), (0, None, False)]},
        {"name": "subtype3_direct_completion",
         "body": make_body(event_pairs=((5, 11), (6, 22)), threshold=0,
                           entries=(ENTRY_A,)),
         "subtype": 3, "gated": False, "initial_selector": 0,
         "plan": [(0, None, False), (0, None, True), (0, None, False)]},
        {"name": "negative_selector_and_suppressed_event_pair",
         "body": make_body(event_pairs=((-1, 9), (6, 22)), threshold=0,
                           entries=((-5, 11, 0, 12, 0, 13, 0, 14, 0),)),
         "subtype": 1, "gated": False, "initial_selector": -5,
         "plan": [(-5, None, False), (-5, None, True), (-5, None, False)]},
    ]


def run(args: argparse.Namespace) -> dict[str, Any]:
    data = args.exe.read_bytes()
    digest = sha256(data)
    if digest != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE hash mismatch: {digest}")
    pe = PEImage.parse_and_map(args.exe)
    lib = s.load_library(s.build_library())
    compared = 0
    results = []
    for case in sequences():
        original = OriginalSequence(pe)
        original.begin(case["body"], subtype=case["subtype"], gated=case["gated"],
                       selector=case["initial_selector"])
        mirror = NativeSequence(lib, case["body"], subtype=case["subtype"],
                                gated=case["gated"],
                                selector=case["initial_selector"])
        steps = []
        try:
            for index, (selector, gate, force) in enumerate(case["plan"]):
                want = original.tick(selector=selector, gate_open=gate,
                                     force_phase2=force)
                got = mirror.tick(selector=selector, gate_open=gate,
                                  force_phase2=force)
                compared += 1
                if want != got:
                    raise OracleFailure(
                        f"{case['name']} step {index} (selector={selector} "
                        f"gate={gate} force_phase2={force}) mismatch:\n"
                        f"original={want}\nnative  ={got}")
                steps.append({"step": index, "selector": selector,
                              "gate_open": gate, "force_phase2": force,
                              "state": want})
        finally:
            mirror.close()
        results.append({"name": case["name"], "steps": steps})
    report = {
        "original_sha256": digest,
        "original_entrypoints": {
            "dispatcher": "0x427a50", "dependency_gate": "0x423f57",
            "handler": "0x42ea87", "completion": "0x42ba3a",
            "request_clear": "0x427a50 prologue (store to slot+0x43)"},
        "platform_boundary_hooks": [],
        "fixture_memory_writes": [
            "action slot 0 (type, subtype, body pointer, done byte, request, "
            "phase, active word, dependency header and hand-built false-gate node)",
            "selector word 0x5bb50b, start flag 0x5bb1ca, event flags 3..6, "
            "row count 0x5c39e3, game state 0x583999",
            "phase dword := 2 for the candidate store (0x43c054)"],
        "sequences": len(results),
        "ticks_compared": compared,
        "mismatches": 0,
        "compared_fields": ["phase", "completed", "request", "response[4]",
                            "start flag", "event flags 3..6"],
        "results": results,
        "limits": [
            "Dependency trees are the A-62 oracle's hand-built single event-flag "
            "node (gate fixtures) or empty (all others); nonempty recursive "
            "reset (subtype 2 with children) is not modeled.",
            "The candidate store and selector changes are fixture pokes; the "
            "cursor scan 0x4f0059 and input paths are not executed here."],
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    return report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except Exception as exc:
        print(f"RT-3 A-62 session oracle failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({k: report[k] for k in (
        "sequences", "ticks_compared", "mismatches", "platform_boundary_hooks",
        "original_sha256")}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
