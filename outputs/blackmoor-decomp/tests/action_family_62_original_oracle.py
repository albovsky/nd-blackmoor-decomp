#!/usr/bin/env python3
"""Compare the A-62 reducer with original GAME.EXE x86 handler code.

The oracle maps the pinned PE32 image into Unicorn and executes FUN_0042ea87,
FUN_0042ba3a, and (for the empty-tree reset fixture) FUN_00423d33. A separate
dispatcher fixture executes FUN_00427a50 through its real dependency gate.
This slice makes no audio, GUI, file, or operating-system calls, so it installs
no platform hooks. It does not execute the resource constructor: the typed
body length is pinned independently to 0x40b34a's original count/stride code
and exhaustively reconciled with all extracted scene records.

Run with the isolated interpreter (Unicorn 2.1.4):

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/action_family_62_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up, sha256
from test_action_family_62 import (
    Backend,
    Decoded,
    Input,
    Result,
    bytes_buffer,
    make_body,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/slices/A-62-original-oracle.json"

HANDLER_VA = 0x42EA87
DISPATCHER_VA = 0x427A50
STARTED_VA = 0x5BB1CA
SELECTOR_VA = 0x5BB50B
ACTION_TYPE_VA = 0x5BB5E3
ACTION_BODY_POINTER_VA = 0x5BB5E5
ACTION_DONE_VA = 0x5BB625
ACTION_REQUEST_VA = 0x5BB626
ACTION_RESPONSE_VA = 0x5BB62A
ACTION_PHASE_VA = 0x5BB632
ACTION_ACTIVE_VA = 0x5BB638
ACTION_DEPENDENCY_VA = 0x5BB5E9
ACTION_STRIDE = 0x8D
EVENT_FLAGS_VA = 0x585801
SCENE_ACTION_COUNT_VA = 0x5C39E3
GAME_STATE_VA = 0x583999

STACK_BASE = 0x1000
STACK_SIZE = 0x20000
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x10000
BODY_VA = FIXTURE_BASE + 0x1000
DEPENDENCY_NODE_VA = FIXTURE_BASE + 0x2000
CALLER_OBJECT_VA = FIXTURE_BASE + 0x4000
RETURN_SENTINEL = FIXTURE_BASE + 0xF000
ACTION_INDEX = 0

INITIAL_REQUEST = 0x12345678
INITIAL_STARTED = 0x76543210
INITIAL_RESPONSE = (91, 92, 93, 94)
INITIAL_EVENT_FLAGS = {3: 0x33333333, 4: 0x44444444}


class OracleFailure(RuntimeError):
    pass


def read_i32(machine: Any, address: int) -> int:
    return struct.unpack("<i", machine.mem_read(address, 4))[0]


def read_u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def read_i16(machine: Any, address: int) -> int:
    return struct.unpack("<h", machine.mem_read(address, 2))[0]


class OriginalA62Oracle:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_MODE_32, Uc
            from unicorn.x86_const import (
                UC_X86_REG_EBP,
                UC_X86_REG_ECX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESP,
            )
        except ImportError as exc:
            raise OracleFailure(
                "Unicorn 2.x required; use work/tools/oracle-python/bin/python"
            ) from exc

        self._ebp = UC_X86_REG_EBP
        self._ecx = UC_X86_REG_ECX
        self._eflags = UC_X86_REG_EFLAGS
        self._eip = UC_X86_REG_EIP
        self._esp = UC_X86_REG_ESP
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(FIXTURE_BASE, FIXTURE_SIZE)
        self.uc.mem_write(RETURN_SENTINEL, b"\xcc")
        self.boundary_hooks: list[str] = []

    def call(self, address: int, arguments: tuple[int, ...] = (), *, this: int = 0) -> None:
        stack_pointer = STACK_BASE + STACK_SIZE - 0x100
        frame = (RETURN_SENTINEL, *arguments)
        self.uc.mem_write(stack_pointer, struct.pack(f"<{len(frame)}I", *frame))
        self.uc.reg_write(self._esp, stack_pointer)
        self.uc.reg_write(self._ebp, 0)
        self.uc.reg_write(self._ecx, this)
        self.uc.reg_write(self._eflags, 0x202)
        self.uc.reg_write(self._eip, address)
        try:
            self.uc.emu_start(address, RETURN_SENTINEL,
                              timeout=5_000_000, count=2_000_000)
        except Exception as exc:
            raise OracleFailure(f"GAME.EXE trapped at 0x{address:08x}: {exc}") from exc
        if self.uc.reg_read(self._eip) != RETURN_SENTINEL:
            raise OracleFailure(
                f"GAME.EXE did not return from 0x{address:08x}; "
                f"EIP=0x{self.uc.reg_read(self._eip):08x}"
            )

    def prepare(self, body: bytes, *, phase: int, subtype: int = 1,
                completed: int = 0, selector: int = 7,
                dep_root: int = 0, dep_has_children: int = 0,
                false_event_dependency: bool = False) -> dict[str, Any]:
        row = ACTION_INDEX * ACTION_STRIDE
        dep = ACTION_DEPENDENCY_VA + row
        self.uc.mem_write(BODY_VA, body)
        self.uc.mem_write(ACTION_TYPE_VA + row, bytes((0x62, subtype)))
        self.uc.mem_write(ACTION_BODY_POINTER_VA + row, struct.pack("<I", BODY_VA))
        self.uc.mem_write(ACTION_DONE_VA + row, bytes((completed & 0xFF,)))
        self.uc.mem_write(ACTION_REQUEST_VA + row, struct.pack("<I", INITIAL_REQUEST))
        self.uc.mem_write(ACTION_PHASE_VA + row, struct.pack("<i", phase))
        self.uc.mem_write(ACTION_ACTIVE_VA + row, struct.pack("<I", 0))
        self.uc.mem_write(STARTED_VA, struct.pack("<I", INITIAL_STARTED))
        self.uc.mem_write(SELECTOR_VA, struct.pack("<h", selector))
        self.uc.mem_write(dep, struct.pack("<I", dep_root))
        self.uc.mem_write(dep + 4, struct.pack(
            "<I", DEPENDENCY_NODE_VA if false_event_dependency else 0
        ))
        self.uc.mem_write(dep + 0x18, struct.pack(
            "<I", 1 if false_event_dependency else 0
        ))
        self.uc.mem_write(dep + 0x34, struct.pack("<I", dep_has_children))
        if false_event_dependency:
            node = bytearray(0x40)
            struct.pack_into("<I", node, 0x00, 2)  # dependency branch kind
            struct.pack_into("<h", node, 0x10, 2)   # event-flag equality opcode
            struct.pack_into("<h", node, 0x12, 3)   # event-flag index
            struct.pack_into("<h", node, 0x14, 0)   # value that deliberately mismatches
            self.uc.mem_write(DEPENDENCY_NODE_VA, bytes(node))
        for word, value in enumerate(INITIAL_RESPONSE):
            self.uc.mem_write(ACTION_RESPONSE_VA + row + word * 2,
                              struct.pack("<h", value))
        for event_id, value in INITIAL_EVENT_FLAGS.items():
            self.uc.mem_write(EVENT_FLAGS_VA + event_id * 4,
                              struct.pack("<i", value))
        return {
            "phase": phase,
            "completed": completed & 0xFF,
            "request": INITIAL_REQUEST,
            "started": INITIAL_STARTED,
            "response": INITIAL_RESPONSE,
            "event_flags": dict(INITIAL_EVENT_FLAGS),
            "dep_root": dep_root,
            "dep_has_children": dep_has_children,
        }

    def run_handler(self, **case: Any) -> dict[str, Any]:
        body = case.pop("body")
        state_before = self.prepare(body, **case)
        self.call(HANDLER_VA, (ACTION_INDEX,))
        return self.read_state(state_before)

    def run_dispatcher(self, **case: Any) -> dict[str, Any]:
        body = case.pop("body")
        state_before = self.prepare(body, **case)
        self.uc.mem_write(SCENE_ACTION_COUNT_VA, struct.pack("<h", 1))
        self.uc.mem_write(GAME_STATE_VA, struct.pack("<i", 3))
        self.call(DISPATCHER_VA, (), this=CALLER_OBJECT_VA)
        return self.read_state(state_before)

    def read_state(self, before: dict[str, Any]) -> dict[str, Any]:
        row = ACTION_INDEX * ACTION_STRIDE
        state = {
            "phase": struct.unpack("<i", self.uc.mem_read(ACTION_PHASE_VA + row, 4))[0],
            "completed": self.uc.mem_read(ACTION_DONE_VA + row, 1)[0],
            "request": read_u32(self.uc, ACTION_REQUEST_VA + row),
            "started": read_u32(self.uc, STARTED_VA),
            "response": tuple(
                read_i16(self.uc, ACTION_RESPONSE_VA + row + word * 2)
                for word in range(4)
            ),
            "event_flags": {
                event_id: read_i32(self.uc, EVENT_FLAGS_VA + event_id * 4)
                for event_id in INITIAL_EVENT_FLAGS
            },
            "dep_root": read_u32(self.uc, ACTION_DEPENDENCY_VA + row),
        }
        return state


def bind_library(path: Path):
    library = c.CDLL(str(path.resolve()))
    library.action_family_62_decode.argtypes = [
        c.c_uint8, c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)
    ]
    library.action_family_62_decode.restype = c.c_int
    library.action_family_62_step.argtypes = [
        c.POINTER(Decoded), c.POINTER(Input), c.POINTER(Backend), c.POINTER(Result)
    ]
    library.action_family_62_step.restype = c.c_int
    return library


def native_step(library: Any, body: bytes, *, phase: int, subtype: int = 1,
                eligible: bool = True, completed: int = 0,
                selector: int = 7, dep_root: int = 0,
                dep_has_children: int = 0) -> dict[str, Any]:
    storage = bytes_buffer(body)
    decoded = Decoded()
    status = library.action_family_62_decode(0x62, storage, len(body), c.byref(decoded))
    if status != 0:
        raise OracleFailure(f"native decoder rejected fixture: {status}")
    input_value = Input(subtype, int(eligible), completed, 0, phase, selector)
    result = Result()
    status = library.action_family_62_step(
        c.byref(decoded), c.byref(input_value), None, c.byref(result)
    )
    if status != 0:
        raise OracleFailure(f"native handler rejected fixture: {status}")

    state = {
        "phase": phase,
        "completed": completed & 0xFF,
        "request": INITIAL_REQUEST,
        "started": INITIAL_STARTED,
        "response": INITIAL_RESPONSE,
        "event_flags": dict(INITIAL_EVENT_FLAGS),
        "dep_root": dep_root,
        "dep_has_children": dep_has_children,
    }
    if result.phase_written:
        state["phase"] = result.phase_after
    if result.start_global_written:
        state["started"] = result.start_global_value
    if result.request_written:
        state["request"] = result.request_value
    if result.response_written:
        state["response"] = tuple(result.response_words)
    if result.completion_written:
        state["completed"] = result.completed_after
    for i in range(result.event_write_count):
        item = result.event_writes[i]
        if item.event_id not in state["event_flags"]:
            raise OracleFailure(f"fixture event id {item.event_id} was not provisioned")
        state["event_flags"][item.event_id] = item.value
    if result.dependency_reset_requested and dep_has_children == 0:
        # FUN_00423d33 writes its root flag to one for an empty tree.
        state["dep_root"] = 1
    return state


def normalize(state: dict[str, Any]) -> dict[str, Any]:
    return {
        "phase": state["phase"],
        "completed": state["completed"],
        "request": state["request"],
        "started": state["started"],
        "response": list(state["response"]),
        "event_flags": {str(k): v for k, v in state["event_flags"].items()},
        "dep_root": state["dep_root"],
    }


def run(args: argparse.Namespace) -> dict[str, Any]:
    data = args.exe.read_bytes()
    digest = sha256(data)
    if digest != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE hash mismatch: {digest}")
    pe = PEImage.parse_and_map(args.exe)
    subprocess.run([str(PROJECT / "scripts/build_action_family_62.sh")], check=True)
    library = bind_library(PROJECT / "build/libactionfamily62.dylib")

    fixtures = [
        {
            "name": "phase0_match_second_entry",
            "body": make_body(entries=((1, 5, 1, 2, 3, 4, 5, 6, 7),
                                       (7, -1, 12, -2, 13, -3, 14, -4, 15))),
            "phase": 0, "subtype": 1, "selector": 7,
        },
        {
            "name": "phase0_no_match",
            "body": make_body(entries=((1, 5, 1, 2, 3, 4, 5, 6, 7),)),
            "phase": 0, "subtype": 1, "selector": 9,
        },
        {
            "name": "phase1_match",
            "body": make_body(entries=((7, -11, 12, -13, 14, -15, 16, -17, 18),)),
            "phase": 1, "subtype": 1, "selector": 7,
        },
        {
            "name": "phase1_no_match",
            "body": make_body(entries=((1, 5, 1, 2, 3, 4, 5, 6, 7),)),
            "phase": 1, "subtype": 1, "selector": 7,
        },
        {
            "name": "phase2_below_threshold_subtype1_writes_two_flags",
            "body": make_body(event_pairs=((3, -301), (4, 302)), threshold=34),
            "phase": 2, "subtype": 1,
        },
        {
            "name": "phase2_below_threshold_subtype2_empty_tree_reset",
            "body": make_body(event_pairs=((3, 41), (-1, 42)), threshold=0),
            "phase": 2, "subtype": 2, "dep_root": 0,
        },
        {
            "name": "phase2_at_threshold_rearms_and_preserves_request",
            "body": make_body(event_pairs=((3, 41), (4, 42)), threshold=35),
            "phase": 2, "subtype": 1, "completed": 0x7F,
        },
        {
            "name": "phase2_other_subtype_keeps_handler_completion",
            "body": make_body(threshold=34),
            "phase": 2, "subtype": 3, "completed": 0x7F,
        },
        {
            "name": "unknown_phase_noop",
            "body": make_body(),
            "phase": 3, "subtype": 1, "completed": 0x7F,
        },
    ]

    machine_results = []
    for case in fixtures:
        parameters = {k: v for k, v in case.items() if k not in {"name", "body"}}
        original = OriginalA62Oracle(pe).run_handler(body=case["body"], **parameters)
        native = native_step(library, case["body"], **parameters)
        if normalize(native) != normalize(original):
            raise OracleFailure(
                f"{case['name']} mismatch:\n"
                f"native={normalize(native)}\noriginal={normalize(original)}"
            )
        machine_results.append({"name": case["name"], "state": normalize(original)})

    # The original dispatcher clears the pending flag before evaluating the
    # dependency gate. A false gate skips FUN_0042ea87, preserving phase/done,
    # while this dispatcher-level clear is outside the pure action kernel.
    blocked_case = {
        "body": make_body(entries=((7, 1, 2, 3, 4, 5, 6, 7, 8),)),
        "phase": 0, "subtype": 1, "selector": 7, "dep_root": 1,
        "dep_has_children": 1, "false_event_dependency": True,
    }
    blocked = OriginalA62Oracle(pe).run_dispatcher(**blocked_case)
    if (blocked["phase"] != 0 or blocked["completed"] != 0 or
            blocked["request"] != 0 or blocked["started"] != INITIAL_STARTED):
        raise OracleFailure(f"false dependency dispatcher fixture changed unexpected fields: {blocked}")

    true_case = {
        "body": make_body(entries=((7, 10, 20, 30, 40, 50, 60, 70, 80),)),
        "phase": 0, "subtype": 1, "selector": 7, "dep_root": 1,
    }
    dispatched = OriginalA62Oracle(pe).run_dispatcher(**true_case)
    native_dispatched = native_step(library, true_case["body"], **{
        k: v for k, v in true_case.items() if k != "body"
    })
    if normalize(native_dispatched) != normalize(dispatched):
        raise OracleFailure(
            "true dependency dispatcher branch differs:\n"
            f"native={normalize(native_dispatched)}\noriginal={normalize(dispatched)}"
        )

    report = {
        "original_sha256": digest,
        "original_entrypoints": {
            "constructor": "0x40b34a",
            "dispatcher": "0x427a50",
            "dependency_gate": "0x423f57",
            "handler": "0x42ea87",
            "completion": "0x42ba3a",
            "dependency_reset": "0x423d33",
        },
        "platform_boundary_hooks": [],
        "fixtures_compared": len(machine_results) + 1,
        "original_fixture_executions": len(machine_results) + 2,
        "handler_fixture_results": machine_results,
        "dispatcher_true_gate": normalize(dispatched),
        "dispatcher_false_gate": {
            "state": normalize(blocked),
            "boundary_note": (
                "FUN_00427a50 clears the request dword before FUN_00423f57; "
                "a deliberately false event-flag dependency makes FUN_00423f57 reject "
                "the row, so it does not call FUN_0042ea87. Kernel false-gate input "
                "is therefore a no-op and does not duplicate this executor prelude."
            ),
        },
        "fixture_limits": [
            "The original action constructor was not invoked; typed-body size is proven from its x86 instructions and corpus reconciliation.",
            "Subtype 2 and selectors with multiple entries are synthetic runtime fixtures; corpus has subtype 1 and count 1 only.",
            "The dependency reset fixture uses an empty tree. FUN_00423d33's nonempty recursive branch is not modeled by this A-62 kernel.",
            "The 0x63 sibling body/runtime is explicitly outside this family module.",
        ],
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
        print(f"A-62 oracle failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({
        "fixtures_compared": report["fixtures_compared"],
        "original_fixture_executions": report["original_fixture_executions"],
        "platform_boundary_hooks": report["platform_boundary_hooks"],
        "original_sha256": report["original_sha256"],
        "report": str(args.report),
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
