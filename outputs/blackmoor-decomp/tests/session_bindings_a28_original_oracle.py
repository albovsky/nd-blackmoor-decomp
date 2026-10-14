#!/usr/bin/env python3
"""RT-5 oracle: native 0x28 session binding vs the original dispatcher x86.

Each sequence drives the unmodified dispatcher FUN_00427a50 (which tests the
done byte, clears the request dword, runs the real dependency gate 0x423f57
with mode 0 and calls the leaf 0x44727a, which in phase 2 calls 0x42ba3a) over
several ticks in Unicorn, and drives the real scene session with
session_bindings_a28 over the same ticks. State is compared after EVERY tick:
row phase and done byte, the effect object's busy byte, rectangle (+0x1d..),
stage (+0x2d) and 21 payload bytes. Gate flips and external controller
completion (busy := 0) are applied to both sides between ticks.

Hooks: none. The dispatcher, the dependency evaluator, the leaf, 0x4473a9 and
0x42ba3a run unmodified; only fixture memory is written (action slot 0, the
hand-built single event-flag dependency node of the A-62 oracle, event flags,
row count, game state 0x583999, VIEW rectangle 0x583186, effect object).

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/session_bindings_a28_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import json
import struct
import sys
import unittest
from pathlib import Path
from typing import Any

from action_family_62_original_oracle import (
    ACTION_DONE_VA, ACTION_INDEX, ACTION_PHASE_VA, ACTION_STRIDE, ACTION_TYPE_VA,
    CALLER_OBJECT_VA, DEFAULT_EXE, DISPATCHER_VA, EVENT_FLAGS_VA, GAME_STATE_VA,
    SCENE_ACTION_COUNT_VA, OracleFailure, OriginalA62Oracle, read_i32, read_u32)
from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, sha256

import session_binding_support as sbs
import session_exit_support as s
import test_session_bindings_a28 as native_tests

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-5-a28-session-original-oracle.json"
OBJ = 0x6198D7
GATE_CLOSED, GATE_OPEN = 0x33333333, 0
VIEW = s.VIEW


class OriginalSequence(OriginalA62Oracle):
    def begin(self, body: bytes, *, subtype: int, gated: bool, busy: int,
              rect: tuple[int, int, int, int]):
        self.prepare(body, phase=0, subtype=subtype, completed=0, selector=0,
                     dep_root=1, dep_has_children=1 if gated else 0,
                     false_event_dependency=gated)
        row = ACTION_INDEX * ACTION_STRIDE
        self.uc.mem_write(ACTION_TYPE_VA + row, bytes((0x28, subtype)))
        self.uc.mem_write(EVENT_FLAGS_VA + 3 * 4, struct.pack("<I", GATE_CLOSED))
        self.uc.mem_write(SCENE_ACTION_COUNT_VA, struct.pack("<h", 1))
        self.uc.mem_write(0x583186, struct.pack("<4i", *VIEW))
        self.uc.mem_write(OBJ, bytes(0x80))
        self.uc.mem_write(OBJ + 0x1C, bytes((busy,)))
        self.uc.mem_write(OBJ + 0x1D, struct.pack("<4i", *rect))
        self.uc.mem_write(OBJ + 0x2D, struct.pack("<I", 123))
        self.uc.mem_write(OBJ + 0x49, b"z" * 21)

    def tick(self, *, gate_open, clear_busy):
        if gate_open is not None:
            self.uc.mem_write(EVENT_FLAGS_VA + 3 * 4, struct.pack(
                "<I", GATE_OPEN if gate_open else GATE_CLOSED))
        if clear_busy:
            self.uc.mem_write(OBJ + 0x1C, bytes((0,)))
        self.uc.mem_write(GAME_STATE_VA, struct.pack("<i", 3))
        self.call(DISPATCHER_VA, (), this=CALLER_OBJECT_VA)
        return self.state()

    def state(self):
        row = ACTION_INDEX * ACTION_STRIDE
        return {
            "phase": read_i32(self.uc, ACTION_PHASE_VA + row),
            "completed": self.uc.mem_read(ACTION_DONE_VA + row, 1)[0],
            "busy": self.uc.mem_read(OBJ + 0x1C, 1)[0],
            "rect": list(struct.unpack("<4i", self.uc.mem_read(OBJ + 0x1D, 16))),
            "stage": read_u32(self.uc, OBJ + 0x2D),
            "payload": bytes(self.uc.mem_read(OBJ + 0x49, 21)).hex(),
        }


class NativeSequence:
    def __init__(self, lib, body: bytes, *, subtype: int, gated: bool, busy: int,
                 rect: tuple[int, int, int, int]):
        self.test = unittest.TestCase()
        deps = (sbs.flag_gate(3, GATE_OPEN),) if gated else ()
        self.fixture = native_tests.A28Fixture.__new__(native_tests.A28Fixture)
        build_fixture(self.fixture, self.test, lib, subtype, body, deps, busy, rect)

    def tick(self, *, gate_open, clear_busy):
        f = self.fixture
        if gate_open is not None:
            f.flags[3] = GATE_OPEN if gate_open else GATE_CLOSED
        if clear_busy:
            f.exit.effect.busy = 0
        status, _result = f.tick()
        if status != sbs.SESSION_OK:
            raise OracleFailure(f"native session tick returned {status}")
        completed, phase = f.row()
        e = f.exit.effect
        return {"phase": phase, "completed": completed, "busy": e.busy,
                "rect": [e.current_rect.left, e.current_rect.top, e.current_rect.right,
                         e.current_rect.bottom],
                "stage": e.sequence_counter, "payload": bytes(e.active_payload).hex()}

    def close(self):
        self.fixture.close()


def build_fixture(f, test, lib, subtype, body, deps, busy, rect):
    """A28Fixture with an explicit dependency tuple and effect geometry."""
    s.configure_a28(lib)
    f.test, f.lib = test, lib
    f.scene, f.owner = sbs.open_scene(lib, [sbs.action(0x28, subtype, body, deps)])
    f.flags, f.world, f.conditions = sbs.make_world(16)
    f.flags[3] = GATE_CLOSED
    f.exit = s.Exit()
    view = s.Rect(*VIEW)
    test.assertEqual(lib.session_exit_init(c.byref(f.exit), c.byref(view)), 0)
    f.exit.effect.busy = busy
    f.exit.effect.current_rect = s.Rect(*rect)
    f.exit.effect.sequence_counter = 123
    f.exit.effect.active_payload[:] = b"z" * 21
    f.binding = lib.session_a28_create(c.byref(f.exit))

    @sbs.PrepareFn
    def prepare(_c, _cond, _frame, _failure):
        return sbs.CALLBACK_OK

    @sbs.MediaFn
    def media(_c, _frame, _failure):
        return sbs.CALLBACK_OK

    handler = sbs.ActionFn(("session_a28_handler", lib))
    bindings = (sbs.Binding * 1)(sbs.Binding(type=0x28, provider=9, callback=handler,
                                             context=f.binding))
    config = sbs.SessionConfig(
        scene=f.scene, scene_id=5900, action_core_world=c.pointer(f.world),
        conditions=c.pointer(f.conditions), action_bindings=bindings,
        action_binding_count=1, prepare_tick=prepare, advance_media_one=media,
        provider_context=None)
    f.session = c.c_void_p()
    failure = sbs.SceneSessionFailure()
    test.assertEqual(lib.scene_session_create(c.byref(config), c.byref(f.session),
                                              c.byref(failure)), 0)
    f.keep = (prepare, media, handler, bindings, config)


def sequences() -> list[dict[str, Any]]:
    zero_rect = s.payload(2, 500, 2000)
    offset_rect = s.payload(1, 100, 0, (5, 6, 700, 800))
    equal_edge = s.payload(3, 50, 7, (4, 9, 4, 9))       # left==right: full canvas
    plan = [(None, False), (None, False), (None, False), (None, True),
            (None, False), (None, False)]
    gated_plan = [(False, False), (True, False), (None, False), (None, False),
                  (False, False), (None, True), (True, False), (None, False)]
    out = []
    for subtype in (1, 2, 3, 4):
        for name, body in (("zero_rect", zero_rect), ("offset_rect", offset_rect),
                           ("equal_edge", equal_edge)):
            for busy in (0, 1):
                out.append({"name": f"sub{subtype}_{name}_busy{busy}", "body": body,
                            "subtype": subtype, "gated": False, "busy": busy,
                            "rect": (100, 200, 300, 400), "plan": plan})
            out.append({"name": f"sub{subtype}_{name}_gated", "body": body,
                        "subtype": subtype, "gated": True, "busy": 0,
                        "rect": (-5, 2**31 - 1, 300, 0), "plan": gated_plan})
    return out


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
                       busy=case["busy"], rect=case["rect"])
        mirror = NativeSequence(lib, case["body"], subtype=case["subtype"],
                                gated=case["gated"], busy=case["busy"], rect=case["rect"])
        steps = []
        try:
            for index, (gate, clear) in enumerate(case["plan"]):
                want = original.tick(gate_open=gate, clear_busy=clear)
                got = mirror.tick(gate_open=gate, clear_busy=clear)
                compared += 1
                if want != got:
                    raise OracleFailure(
                        f"{case['name']} step {index} (gate={gate} clear_busy={clear}) "
                        f"mismatch:\noriginal={want}\nnative  ={got}")
                steps.append({"step": index, "gate_open": gate, "clear_busy": clear,
                              "state": want})
        finally:
            mirror.close()
        results.append({"name": case["name"], "steps": steps})
    report = {
        "original_sha256": digest,
        "original_entrypoints": {
            "dispatcher": "0x427a50", "dependency_gate": "0x423f57 (mode 0)",
            "leaf": "0x44727a", "stage_reset": "0x4473a9", "completion": "0x42ba3a"},
        "platform_boundary_hooks": [],
        "fixture_memory_writes": [
            "action slot 0 (type 0x28, subtype, body pointer, done byte, request, phase, "
            "active word, dependency header and hand-built false-gate node)",
            "event flag 3, row count 0x5c39e3, game state 0x583999, VIEW 0x583186",
            "effect object 0x6198d7 (busy, rectangle, stage, payload sentinel)"],
        "sequences": len(results), "ticks_compared": compared, "mismatches": 0,
        "compared_fields": ["phase", "completed", "busy", "rect[4]", "stage", "payload[21]"],
        "results": results,
        "limits": [
            "Dependency trees are the A-62 oracle's hand-built single event-flag node or "
            "empty; nonempty recursive reset (subtype 2 with children) is not modeled.",
            "The leaf's 0x4473a9 is the whole stage reset; the controller is covered by "
            "session_exit_original_oracle.py."],
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
    except Exception as exc:  # noqa: BLE001
        print(f"RT-5 A-28 session oracle failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({k: report[k] for k in (
        "sequences", "ticks_compared", "mismatches", "platform_boundary_hooks",
        "original_sha256")}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
