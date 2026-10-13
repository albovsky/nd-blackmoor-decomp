#!/usr/bin/env python3
"""Compare A-62 cursor, acceptance, and selector effects with GAME.EXE x86."""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import subprocess
from pathlib import Path
from typing import Any

from action_family_62_original_oracle import (
    ACTION_BODY_POINTER_VA,
    ACTION_DEPENDENCY_VA,
    ACTION_PHASE_VA,
    ACTION_REQUEST_VA,
    ACTION_RESPONSE_VA,
    ACTION_STRIDE,
    ACTION_TYPE_VA,
    BODY_VA,
    CALLER_OBJECT_VA,
    DEFAULT_EXE,
    DEPENDENCY_NODE_VA,
    EVENT_FLAGS_VA,
    FIXTURE_BASE,
    GAME_STATE_VA,
    OriginalA62Oracle,
    SCENE_ACTION_COUNT_VA,
    STACK_BASE,
    STACK_SIZE,
    STARTED_VA,
)
from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage
from test_action_family_62 import make_body
from test_action_family_62_interaction import (
    AcceptInput,
    AcceptResult,
    NavigateInput,
    NavigateResult,
    ScanInput,
    ScanResult,
    Target,
)


PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_REPORT = PROJECT.parent.parent / "work/analysis/slices/A-62-interaction-original-oracle.json"
LIBRARY = PROJECT / "build/libactionfamily62interaction.dylib"
SELECTOR_VA = 0x5BB50B
ACTION_DONE_VA = 0x5BB625
CURSOR_VA = 0x4F0059
ACCEPT_BLOCK_START = 0x43BFB6
ACCEPT_BLOCK_STOP = 0x43C09C
SUPPRESSION_VA = 0x5C39E9
CANDIDATE_VA = 0x5C39E5
NAVIGATE_ADD_START = 0x43C2B7
NAVIGATE_SUBTRACT_START = 0x43C332
NAVIGATE_BLOCK_STOP = 0x43C88D
NAVIGATION_COMMAND_VA = 0x5A4C18
NAVIGATION_STEP_VA = 0x5BB2C6
NAVIGATION_WRAP_VA = 0x5BB2B6
SELECTOR_MIN_VA = 0x5BB4E3
SELECTOR_MAX_VA = 0x5BB4E5


class OracleFailure(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def original_code_windows(pe: PEImage) -> list[dict[str, Any]]:
    windows = (
        (0x43C2B7, 0x43C332, "selector_command_1"),
        (0x43C332, 0x43C3AD, "selector_command_2"),
        (0x4F1EF0, 0x4F257C, "cursor_candidate_scan_and_reserved_routes"),
        (0x43BFB6, 0x43C09C, "candidate_acceptance_and_dependency_decision"),
    )
    result = []
    for start, end, name in windows:
        image_offset = start - pe.image_base
        code = pe.image[image_offset:image_offset + end - start]
        result.append({
            "name": name,
            "start_va": f"0x{start:08x}",
            "end_va_exclusive": f"0x{end:08x}",
            "byte_count": len(code),
            "mapped_sha256": sha256(code),
        })
    return result


def write_i16(machine: Any, address: int, value: int) -> None:
    machine.mem_write(address, struct.pack("<h", value))


def write_i32(machine: Any, address: int, value: int) -> None:
    machine.mem_write(address, struct.pack("<i", value))


def read_i16(machine: Any, address: int) -> int:
    return struct.unpack("<h", machine.mem_read(address, 2))[0]


def read_i32(machine: Any, address: int) -> int:
    return struct.unpack("<i", machine.mem_read(address, 4))[0]


def read_u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def bind_library():
    subprocess.run(
        ["sh", str(PROJECT / "scripts/build_action_family_62_interaction.sh")],
        check=True,
    )
    library = c.CDLL(str(LIBRARY))
    library.action_family_62_interaction_scan.argtypes = [
        c.POINTER(ScanInput), c.POINTER(ScanResult)
    ]
    library.action_family_62_interaction_scan.restype = c.c_int
    library.action_family_62_interaction_accept.argtypes = [
        c.POINTER(AcceptInput), c.POINTER(AcceptResult)
    ]
    library.action_family_62_interaction_accept.restype = c.c_int
    library.action_family_62_interaction_navigate.argtypes = [
        c.POINTER(NavigateInput), c.POINTER(NavigateResult)
    ]
    library.action_family_62_interaction_navigate.restype = c.c_int
    return library


def seed_action(oracle: OriginalA62Oracle, body: bytes, *, index: int,
                phase: int, selector: int) -> int:
    row = index * ACTION_STRIDE
    body_va = BODY_VA + index * 0x100
    uc = oracle.uc
    uc.mem_write(body_va, body)
    uc.mem_write(ACTION_TYPE_VA + row, bytes((0x62, 1)))
    uc.mem_write(ACTION_BODY_POINTER_VA + row, struct.pack("<I", body_va))
    uc.mem_write(ACTION_DONE_VA + row, b"\0")
    uc.mem_write(ACTION_REQUEST_VA + row, b"\0\0\0\0")
    uc.mem_write(ACTION_PHASE_VA + row, struct.pack("<i", phase))
    uc.mem_write(ACTION_DEPENDENCY_VA + row, struct.pack("<II", 0, 0))
    for word, value in enumerate((91, 92, 93, 94)):
        write_i16(uc, ACTION_RESPONSE_VA + row + word * 2, value)
    write_i16(uc, SELECTOR_VA, selector)
    return row


def seed_cursor_transform(oracle: OriginalA62Oracle, *, action_count: int,
                          coordinate_a: int, coordinate_b: int,
                          reserved_indices=(-1, -1), cursor_command: int = 0) -> None:
    uc = oracle.uc
    # The original cursor object computes +0x5a from DAT_00583106 and +0x5e
    # from DAT_00583102 when the seeded object origin and cursor offset are 0.
    for address, value in (
        (0x583102, coordinate_b),
        (0x583106, coordinate_a),
        (0x58310A, 200),
        (0x58310E, 200),
        (0x5B44F0, 0),
        (0x5B44F4, 0),
        (0x5BB587, 0),
        (0x5A4C18, cursor_command),
        (CANDIDATE_VA, -1),
        (SUPPRESSION_VA, 0),
    ):
        write_i32(uc, address, value)
    write_i16(uc, SCENE_ACTION_COUNT_VA, action_count)
    write_i16(uc, 0x5B4E89, reserved_indices[0])
    write_i16(uc, 0x5B5100, reserved_indices[1])

    obj = CALLER_OBJECT_VA
    for offset, value in (
        (0x04, 0), (0x08, 0), (0x0C, 200), (0x10, 200),
        (0x34, 0), (0x38, 0), (0x3C, 200), (0x40, 0),
    ):
        write_i32(uc, obj + offset, value)


def original_cursor_candidate(oracle: OriginalA62Oracle, *, action_count: int,
                              coordinate_a: int, coordinate_b: int,
                              reserved_indices=(-1, -1), cursor_command: int = 0) -> dict[str, Any]:
    seed_cursor_transform(
        oracle, action_count=action_count, coordinate_a=coordinate_a,
        coordinate_b=coordinate_b, reserved_indices=reserved_indices,
        cursor_command=cursor_command,
    )
    oracle.call(CURSOR_VA, (), this=CALLER_OBJECT_VA)
    return {
        "candidate_index": read_i32(oracle.uc, CANDIDATE_VA),
        "coordinate_a": read_i32(oracle.uc, CALLER_OBJECT_VA + 0x5A),
        "coordinate_b": read_i32(oracle.uc, CALLER_OBJECT_VA + 0x5E),
        "cursor_command_after": read_i32(oracle.uc, 0x5A4C18),
        "cursor_visual_index": read_i32(oracle.uc, 0x5B44F0),
        "cursor_route_flag": read_i32(oracle.uc, 0x5B44F4),
    }


def native_cursor_candidate(library: Any, *, action_count: int,
                            candidate_request: int, response_words: tuple[int, ...],
                            coordinate_a: int, coordinate_b: int,
                            reserved_indices=(-1, -1), cursor_command: int = 0) -> int:
    targets = (Target * action_count)()
    targets[0].request_pending = candidate_request
    targets[0].response_words[:] = response_words
    scan_input = ScanInput(
        targets, action_count, coordinate_a, coordinate_b,
        reserved_indices[0], reserved_indices[1], cursor_command,
    )
    result = ScanResult()
    status = library.action_family_62_interaction_scan(
        c.byref(scan_input), c.byref(result)
    )
    if status != 0:
        raise OracleFailure(f"native cursor scanner returned {status}")
    return result.candidate_action_index


def cursor_fixture(pe: PEImage, library: Any, *, selector: int = 7,
                   entry_selector: int = 7, bounds=(10, 20, 30, 40),
                   coordinate_a: int = 20, coordinate_b: int = 20,
                   reserved_indices=(-1, -1), cursor_command: int = 0,
                   action_index: int = 0, action_count: int = 1) -> dict[str, Any]:
    oracle = OriginalA62Oracle(pe)
    # Word 0 is the selector. The runtime copies words 1,3,5,7 as the four
    # response slots; even-numbered remaining words are preserved but unused.
    entries = ((entry_selector, bounds[0], 0, bounds[1], 0,
                bounds[2], 0, bounds[3], 0),)
    body = make_body(threshold=10, entries=entries)
    row = seed_action(oracle, body, index=action_index, phase=1, selector=selector)
    oracle.call(0x42EA87, (action_index,))
    request = read_u32(oracle.uc, ACTION_REQUEST_VA + row)
    response = tuple(
        read_i16(oracle.uc, ACTION_RESPONSE_VA + row + word * 2)
        for word in range(4)
    )
    cursor = original_cursor_candidate(
        oracle, action_count=action_count, coordinate_a=coordinate_a,
        coordinate_b=coordinate_b, reserved_indices=reserved_indices,
        cursor_command=cursor_command,
    )

    native_targets = (Target * action_count)()
    native_targets[action_index].request_pending = request
    native_targets[action_index].response_words[:] = response
    scan_input = ScanInput(
        native_targets, action_count, cursor["coordinate_a"], cursor["coordinate_b"],
        reserved_indices[0], reserved_indices[1], cursor_command,
    )
    scan_result = ScanResult()
    status = library.action_family_62_interaction_scan(
        c.byref(scan_input), c.byref(scan_result)
    )
    if status != 0:
        raise OracleFailure(f"native cursor scanner returned {status}")

    expected_route = 0
    if cursor["candidate_index"] >= 0:
        if cursor["candidate_index"] == reserved_indices[0]:
            expected_route = 2
        elif cursor["candidate_index"] == reserved_indices[1]:
            expected_route = 3
        else:
            expected_route = 1
    expected_cursor_visual = (
        None if cursor_command != 0 or expected_route == 0
        else 3 if expected_route in (2, 3)
        else 10 if expected_route == 1
        else 0
    )
    return {
        "selector": selector,
        "entry_selector": entry_selector,
        "request": request,
        "response_words": response,
        "original_cursor": cursor,
        "native_candidate": scan_result.candidate_action_index,
        "native_route": scan_result.candidate_route,
        "matched": (
            scan_result.candidate_action_index == cursor["candidate_index"]
            and scan_result.candidate_route == expected_route
            and cursor["cursor_route_flag"] == int(expected_route != 0)
            and (expected_cursor_visual is None or
                 cursor["cursor_visual_index"] == expected_cursor_visual)
        ),
    }


def cursor_first_match_fixture(pe: PEImage, library: Any) -> dict[str, Any]:
    oracle = OriginalA62Oracle(pe)
    body = make_body(entries=((7, 10, 0, 20, 0, 30, 0, 40, 0),))
    rows = []
    for index in (0, 1):
        row = seed_action(oracle, body, index=index, phase=1, selector=7)
        oracle.call(0x42EA87, (index,))
        rows.append(row)
    requests = [read_u32(oracle.uc, ACTION_REQUEST_VA + row) for row in rows]
    responses = [
        tuple(read_i16(oracle.uc, ACTION_RESPONSE_VA + row + word * 2)
              for word in range(4))
        for row in rows
    ]
    cursor = original_cursor_candidate(
        oracle, action_count=2, coordinate_a=20, coordinate_b=20
    )

    targets = (Target * 2)()
    for index in range(2):
        targets[index].request_pending = requests[index]
        targets[index].response_words[:] = responses[index]
    scan_input = ScanInput(targets, 2, cursor["coordinate_a"],
                           cursor["coordinate_b"], -1, -1, 0)
    scan_result = ScanResult()
    status = library.action_family_62_interaction_scan(
        c.byref(scan_input), c.byref(scan_result)
    )
    if status != 0:
        raise OracleFailure(f"native first-match scanner returned {status}")
    return {
        "original_requests": requests,
        "original_responses": responses,
        "original_cursor": cursor,
        "native_candidate": scan_result.candidate_action_index,
        "native_route": scan_result.candidate_route,
        "matched": (
            scan_result.candidate_action_index == cursor["candidate_index"] == 0
            and scan_result.candidate_route == 1
            and cursor["cursor_route_flag"] == 1
        ),
    }


def original_accept(pe: PEImage, *, candidate: int, suppression: int,
                    control: int, dependency_ready: bool,
                    dependency_child: int = -1,
                    false_event_dependency: bool = False) -> dict[str, Any]:
    from unicorn import UC_HOOK_CODE
    from unicorn.x86_const import (
        UC_X86_REG_EBP,
        UC_X86_REG_EFLAGS,
        UC_X86_REG_EIP,
        UC_X86_REG_ESP,
    )

    oracle = OriginalA62Oracle(pe)
    uc = oracle.uc
    body = make_body(entries=((0, 7, 10, 10, 20, 20, 30, 30, 40),))
    row = seed_action(oracle, body, index=0, phase=1, selector=7)
    dep = ACTION_DEPENDENCY_VA + row
    write_i32(uc, dep + 0x30, control)
    write_i32(uc, dep + 0x24, 0)

    if false_event_dependency:
        node = bytearray(0x40)
        struct.pack_into("<I", node, 0x00, 2)
        struct.pack_into("<h", node, 0x10, 2)
        struct.pack_into("<h", node, 0x12, 3)
        struct.pack_into("<h", node, 0x14, 0)
        uc.mem_write(DEPENDENCY_NODE_VA, bytes(node))
        write_i32(uc, dep + 4, DEPENDENCY_NODE_VA)
        write_i32(uc, dep + 0x18, 1)
        write_i32(uc, dep + 0x34, 1)
    elif dependency_ready:
        write_i32(uc, dep + 4, 0)
        write_i32(uc, dep + 0x34, 0)
        if dependency_child != -1:
            child_object = FIXTURE_BASE + 0x3000
            write_i32(uc, dep + 0x24, child_object)
            write_i16(uc, child_object + 0x12, dependency_child)
    else:
        # A genuinely empty dependency list reports ready; use a false event
        # dependency fixture when testing the not-ready branch.
        raise OracleFailure("a false dependency must use its original event-tree fixture")

    write_i32(uc, CANDIDATE_VA, candidate)
    write_i32(uc, SUPPRESSION_VA, suppression)
    write_i16(uc, 0x583A29, -1)

    branch_calls: list[int] = []

    def record_boundary(machine, address, _size, _user_data):
        if address in (0x4EB107, 0x4EB184):
            branch_calls.append(address)

    uc.hook_add(UC_HOOK_CODE, record_boundary)
    ebp = STACK_BASE + STACK_SIZE - 0x200
    esp = ebp - 0x104
    uc.mem_write(ebp - 0x40, struct.pack("<i", -1))
    uc.reg_write(UC_X86_REG_EBP, ebp)
    uc.reg_write(UC_X86_REG_ESP, esp)
    uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
    uc.reg_write(UC_X86_REG_EIP, ACCEPT_BLOCK_START)
    try:
        uc.emu_start(
            ACCEPT_BLOCK_START, ACCEPT_BLOCK_STOP,
            timeout=5_000_000, count=100_000,
        )
    except Exception as exc:
        raise OracleFailure(f"original acceptance block trapped: {exc}") from exc
    if uc.reg_read(UC_X86_REG_EIP) != ACCEPT_BLOCK_STOP:
        raise OracleFailure(
            f"original acceptance block stopped at 0x{uc.reg_read(UC_X86_REG_EIP):08x}"
        )
    return {
        "phase": read_i32(uc, ACTION_PHASE_VA + row),
        "child_dispatch_seen": 0x4EB107 in branch_calls,
        "feedback_boundary_seen": 0x4EB184 in branch_calls,
        "observed_call_addresses": [hex(address) for address in branch_calls],
    }


def native_accept(library: Any, *, candidate: int, suppression: int,
                  control: int, dependency_ready: bool,
                  dependency_child: int = -1) -> dict[str, Any]:
    input_value = AcceptInput(
        candidate, suppression, control, int(dependency_ready), dependency_child
    )
    result = AcceptResult()
    status = library.action_family_62_interaction_accept(
        c.byref(input_value), c.byref(result)
    )
    if status != 0:
        raise OracleFailure(f"native acceptance reducer returned {status}")
    return {
        "candidate_considered": bool(result.candidate_considered),
        "dependency_check_required": bool(result.dependency_check_required),
        "phase2_requested": bool(result.phase2_requested),
        "child_request_required": bool(result.child_request_required),
        "child_index": result.child_index,
        "dependency_feedback_required": bool(result.dependency_feedback_required),
    }


def acceptance_fixture(pe: PEImage, library: Any, *, candidate: int = 0,
                       suppression: int = 0, control: int = 0,
                       dependency_ready: bool = True,
                       dependency_child: int = -1,
                       false_event_dependency: bool = False) -> dict[str, Any]:
    original = original_accept(
        pe, candidate=candidate, suppression=suppression, control=control,
        dependency_ready=dependency_ready, dependency_child=dependency_child,
        false_event_dependency=false_event_dependency,
    )
    native = native_accept(
        library, candidate=candidate, suppression=suppression, control=control,
        dependency_ready=dependency_ready and not false_event_dependency,
        dependency_child=dependency_child,
    )
    expected_phase2 = original["phase"] == 2
    matched = (
        native["phase2_requested"] == expected_phase2
        and native["child_request_required"] == original["child_dispatch_seen"]
        and native["dependency_feedback_required"] == original["feedback_boundary_seen"]
    )
    return {"input": {"candidate": candidate, "suppression": suppression,
                       "control": control,
                       "dependency_ready": dependency_ready,
                       "dependency_child": dependency_child,
                       "false_event_dependency": false_event_dependency},
            "original": original, "native": native, "matched": matched}


def original_navigation(pe: PEImage, *, command: int, selector: int, step: int,
                        minimum: int, maximum: int, wrap_mode: int) -> int:
    from unicorn.x86_const import (
        UC_X86_REG_EBP,
        UC_X86_REG_EFLAGS,
        UC_X86_REG_EIP,
        UC_X86_REG_ESP,
    )

    oracle = OriginalA62Oracle(pe)
    uc = oracle.uc
    write_i32(uc, NAVIGATION_COMMAND_VA, command)
    write_i16(uc, SELECTOR_VA, selector)
    write_i16(uc, NAVIGATION_STEP_VA, step)
    write_i16(uc, SELECTOR_MIN_VA, minimum)
    write_i16(uc, SELECTOR_MAX_VA, maximum)
    write_i16(uc, NAVIGATION_WRAP_VA, wrap_mode)
    start = NAVIGATE_ADD_START if command == 1 else NAVIGATE_SUBTRACT_START
    stack_pointer = STACK_BASE + STACK_SIZE - 0x100
    uc.reg_write(UC_X86_REG_ESP, stack_pointer)
    uc.reg_write(UC_X86_REG_EBP, stack_pointer - 0x80)
    uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
    uc.reg_write(UC_X86_REG_EIP, start)
    try:
        uc.emu_start(start, NAVIGATE_BLOCK_STOP,
                     timeout=5_000_000, count=100_000)
    except Exception as exc:
        raise OracleFailure(f"original navigation block trapped: {exc}") from exc
    if uc.reg_read(UC_X86_REG_EIP) != NAVIGATE_BLOCK_STOP:
        raise OracleFailure(
            f"original navigation stopped at 0x{uc.reg_read(UC_X86_REG_EIP):08x}"
        )
    return read_i16(uc, SELECTOR_VA)


def native_navigation(library: Any, *, command: int, selector: int, step: int,
                      minimum: int, maximum: int, wrap_mode: int) -> tuple[int, int]:
    input_value = NavigateInput(
        1, command, selector, step, minimum, maximum, wrap_mode, 0, 0
    )
    result = NavigateResult()
    status = library.action_family_62_interaction_navigate(
        c.byref(input_value), c.byref(result)
    )
    return status, result.selector_after


def navigation_fixture(pe: PEImage, library: Any, *, command: int,
                       selector: int, step: int, minimum: int,
                       maximum: int, wrap_mode: int) -> dict[str, Any]:
    original = original_navigation(
        pe, command=command, selector=selector, step=step,
        minimum=minimum, maximum=maximum, wrap_mode=wrap_mode,
    )
    native_status, native = native_navigation(
        library, command=command, selector=selector, step=step,
        minimum=minimum, maximum=maximum, wrap_mode=wrap_mode,
    )
    return {
        "input": {"command": command, "selector": selector, "step": step,
                  "minimum": minimum, "maximum": maximum,
                  "wrap_mode": wrap_mode},
        "original_selector_after": original,
        "native_status": native_status,
        "native_selector_after": native,
        "matched": native_status == 0 and native == original,
    }


def run() -> dict[str, Any]:
    pe = PEImage.parse_and_map(DEFAULT_EXE)
    if sha256(pe.data) != EXPECTED_EXE_SHA256:
        raise OracleFailure("pinned GAME.EXE SHA-256 mismatch")
    library = bind_library()

    cursor_cases = [
        cursor_fixture(pe, library),
        cursor_fixture(pe, library, coordinate_a=40, coordinate_b=30),
        cursor_fixture(pe, library, coordinate_a=41, coordinate_b=30),
        cursor_fixture(pe, library, entry_selector=8),
        cursor_fixture(pe, library, reserved_indices=(0, -1)),
        cursor_fixture(pe, library, reserved_indices=(-1, 0)),
        cursor_fixture(pe, library, cursor_command=1),
        cursor_fixture(pe, library, action_index=1, action_count=2),
        cursor_fixture(pe, library, bounds=(20, 20, 20, 20)),
    ]
    cursor_cases.append(cursor_first_match_fixture(pe, library))
    acceptance_cases = [
        acceptance_fixture(pe, library, control=0),
        acceptance_fixture(pe, library, control=1, dependency_child=4),
        acceptance_fixture(pe, library, control=1, dependency_child=-2),
        acceptance_fixture(pe, library, control=1, false_event_dependency=True),
        acceptance_fixture(pe, library, candidate=240, control=0),
        acceptance_fixture(pe, library, suppression=1, control=0),
    ]
    navigation_cases = [
        navigation_fixture(pe, library, command=1, selector=3, step=2,
                           minimum=0, maximum=9, wrap_mode=0),
        navigation_fixture(pe, library, command=1, selector=8, step=2,
                           minimum=0, maximum=9, wrap_mode=0),
        navigation_fixture(pe, library, command=1, selector=8, step=2,
                           minimum=0, maximum=9, wrap_mode=1),
        navigation_fixture(pe, library, command=1, selector=8, step=2,
                           minimum=0, maximum=9, wrap_mode=2),
        navigation_fixture(pe, library, command=1, selector=8, step=2,
                           minimum=0, maximum=9, wrap_mode=3),
        navigation_fixture(pe, library, command=1, selector=32767, step=1,
                           minimum=-100, maximum=100, wrap_mode=3),
        navigation_fixture(pe, library, command=2, selector=7, step=2,
                           minimum=0, maximum=9, wrap_mode=0),
        navigation_fixture(pe, library, command=2, selector=0, step=2,
                           minimum=0, maximum=9, wrap_mode=0),
        navigation_fixture(pe, library, command=2, selector=0, step=2,
                           minimum=0, maximum=9, wrap_mode=1),
        navigation_fixture(pe, library, command=2, selector=0, step=2,
                           minimum=0, maximum=9, wrap_mode=2),
        navigation_fixture(pe, library, command=2, selector=0, step=2,
                           minimum=0, maximum=9, wrap_mode=3),
        navigation_fixture(pe, library, command=2, selector=-32768, step=1,
                           minimum=-100, maximum=100, wrap_mode=3),
    ]
    return {
        "original_sha256": sha256(pe.data),
        "original_code_windows": original_code_windows(pe),
        "original_fixture_executions": (
            len(cursor_cases) + len(acceptance_cases) + len(navigation_cases)
        ),
        "cursor_fixture_count": len(cursor_cases),
        "cursor_native_matches": sum(case["matched"] for case in cursor_cases),
        "acceptance_fixture_count": len(acceptance_cases),
        "acceptance_native_matches": sum(case["matched"] for case in acceptance_cases),
        "navigation_fixture_count": len(navigation_cases),
        "navigation_native_matches": sum(case["matched"] for case in navigation_cases),
        "boundary_hooks": [
            "4eb107 was observed while original child-selection code executed; DAT_00583a29=-1 prevented UI selection effects.",
            "4eb184 was observed for rejected dependency feedback with argument -1; original early-return path executed before audio/UI output.",
        ],
        "cursor_cases": cursor_cases,
        "acceptance_cases": acceptance_cases,
        "navigation_cases": navigation_cases,
        "limits": [
            "FUN_004f0059's scene-coordinate transform is executed in the original fixtures; the C helper begins at the exact transformed coordinates +0x5a/+0x5e.",
            "Cursor sprite/assets and screen presentation are outside the C helper.",
            "The keyboard/Win32 event source and type-62 cursor styling are not implemented by this helper.",
            "The ordinary cursor route bypasses reserved rows; separate reserved-A/B branches repeat the request/bounds test and can publish those candidates. The helper tags the route but does not reproduce cursor rendering or reserved-action side effects.",
            "Navigation fixtures start at the original command-1/command-2 machine-code blocks. They prove the 16-bit arithmetic and endpoint branch, not the preceding timing gate or scene-mode dispatch.",
            "The candidate consumer's dependency provider is supplied as exact ready/child values; the false event dependency fixture executes original FUN_00423f57.",
            "This does not claim all event 0x271d behavior; that event is type-0x72-specific and excluded from A-62.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    report = run()
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    if report["cursor_native_matches"] != report["cursor_fixture_count"]:
        raise OracleFailure("one or more cursor candidate fixtures differ")
    if report["acceptance_native_matches"] != report["acceptance_fixture_count"]:
        raise OracleFailure("one or more acceptance fixtures differ")
    if report["navigation_native_matches"] != report["navigation_fixture_count"]:
        raise OracleFailure("one or more navigation fixtures differ")
    print(json.dumps({key: value for key, value in report.items()
                      if key not in ("cursor_cases", "acceptance_cases",
                                     "navigation_cases", "limits")}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
