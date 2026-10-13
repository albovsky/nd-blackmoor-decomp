#!/usr/bin/env python3
"""Compare the native 0x64 step with original GAME.EXE dispatcher code.

The harness executes the original PE32 dispatcher and handler in Unicorn. It
controls only the dependency-result leaf and the imported GetTickCount slot;
0x42b87a, its mode helpers, 0x42ba3a, and subtype-2 dependency reset run as
original machine code. This is a bounded leaf-runtime comparison, not a
whole-scene or full-game equivalence claim.
"""

from __future__ import annotations

import argparse
import ctypes as c
from dataclasses import dataclass
import hashlib
import json
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_action_family_64 import (
    Action,
    Backend,
    Decoded,
    LIBRARY,
    OK,
    Result,
    TickSource,
    World,
    bytes_buffer,
    original_body,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/slices/A-64-original-oracle.json"
DISPATCHER_VA = 0x427A50
DEPENDENCY_GATE_VA = 0x423F57
ACTION_COUNT_VA = 0x5C39E3
ENGINE_PHASE_VA = 0x583999
DEBUG_LOG_VA = 0x63A4CD
CLOCK_VALUE_585D51_VA = 0x585D51
CLOCK_VALUE_585D4F_VA = 0x585D4F
CLOCK_TOTAL_585D4B_VA = 0x585D4B
CLOCK_DEADLINE_585D55_VA = 0x585D55
DEADLINE_OFFSET_5B0280_VA = 0x5B0280
CONTROLLER_BASE_VA = 0x61C387
CONTROLLER_ACTIVE_001C_VA = CONTROLLER_BASE_VA + 0x1C
CONTROLLER_TICK_0456_VA = CONTROLLER_BASE_VA + 0x456
CONTROLLER_FLAG_0326_VA = CONTROLLER_BASE_VA + 0x326
ACTION_TYPE_BASE_VA = 0x5BB5E3
ACTION_COMPLETED_BASE_VA = 0x5BB625
ACTION_PHASE_BASE_VA = 0x5BB632
ACTION_UNLOADED_BASE_VA = 0x5BB638
ACTION_DEPENDENCY_BASE_VA = 0x5BB5E9
ACTION_STRIDE = 0x8D
GETTICKCOUNT_IAT_VA = 0x52A23C
STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
BODY_BASE = 0x20000000
BODY_SIZE = 0x10000
RETURN_BASE = 0x30000000
RETURN_SENTINEL = RETURN_BASE
GETTICKCOUNT_STUB = RETURN_BASE + 0x1000
MAX_CASES = 240
CORPUS_0X64_RECORDS = [
    {"resource_index": 1519, "action_index": 0, "title": "BLU",
     "background": "GRE_PortraitsD", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0103000f00"},
    {"resource_index": 1537, "action_index": 0, "title": "BLU",
     "background": "BLU_NancyPOV_Off", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0103000f00"},
    {"resource_index": 1538, "action_index": 4, "title": "BLU",
     "background": "BLU_NancyPOV_Off", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0103000f00"},
    {"resource_index": 1539, "action_index": 1, "title": "BLU",
     "background": "BLU_NancyPOV_Off", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0103000f00"},
    {"resource_index": 2522, "action_index": 1, "title": "Scene description",
     "background": "LIB_typePg3_ANIM_LAST", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0103000f00"},
    {"resource_index": 2661, "action_index": 0, "title": "Scene description",
     "background": "toast", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0111003a00"},
    {"resource_index": 2743, "action_index": 0, "title": "Scene description",
     "background": "OPEN_A", "description": "bump player's clock",
     "subtype": 1, "body_hex": "0112000000"},
]


class OracleFailure(RuntimeError):
    pass


@dataclass(frozen=True)
class OracleCase:
    label: str
    operation: int
    value_1: int = 7
    value_2: int = -11
    subtype: int = 1
    eligible: bool = True
    completed_before: int = 0
    phase_before: int = 29
    engine_phase: int = 3
    unloaded: int = 0
    clock_value_585d51: int = 2
    clock_value_585d4f: int = 58
    clock_total_585d4b: int = -123456
    clock_deadline_585d55: int = 0x76543210
    deadline_offset_5b0280: int = -7
    controller_active_001c: int = 0
    controller_tick_0456: int = 0xAABBCCDD
    controller_flag_0326_0061c6ad: int = 0x5A
    ticks: tuple[int, ...] = (100,)


def i16(value: int) -> bytes:
    return struct.pack("<h", value)


def u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def i16_at(machine: Any, address: int) -> int:
    return struct.unpack("<h", machine.mem_read(address, 2))[0]


def original_cases() -> list[OracleCase]:
    cases = [
        OracleCase("operation-zero-default", 0),
        OracleCase("operation-one-corpus-s5900", 1, 3, 15),
        OracleCase("operation-two-add-wrap", 2, 20, -20,
                   clock_value_585d51=32760, clock_value_585d4f=-32760,
                   ticks=(0xFFFFFFFF,)),
        OracleCase("operation-three-active-controller", 3, 123, -456,
                   controller_active_001c=1, ticks=(0xFFFFFFF2, 0x10)),
        OracleCase("operation-three-inactive-controller", 3,
                   controller_tick_0456=0x10203040, ticks=(0x10,)),
        OracleCase("operation-four", 4, 99, 88),
        OracleCase("operation-five", 5, 9, 11),
        OracleCase("operation-six-add", 6, 1, 5),
        OracleCase("operation-seven-default", 7, 100, -200),
        OracleCase("operation-ff-default", 255, -32768, 32767,
                   deadline_offset_5b0280=32767,
                   ticks=(0xFFFFFFF0,)),
    ]
    for subtype in (1, 2, 0, 7):
        cases.append(OracleCase(f"subtype-{subtype}", 1, 4, 5, subtype=subtype))
    cases.extend((
        OracleCase("false-dependency-gate", 1, 3, 15, subtype=2,
                   eligible=False, phase_before=41),
        OracleCase("engine-not-running", 1, 3, 15, subtype=1,
                   eligible=False, engine_phase=4, phase_before=41),
        OracleCase("already-completed", 1, 3, 15, subtype=1,
                   eligible=False, completed_before=1, phase_before=41),
        OracleCase("unloaded-action", 1, 3, 15, subtype=1,
                   eligible=False, unloaded=1, phase_before=41),
    ))
    # Each 0x64 corpus record is five bytes and operation 1. Four BLU scene
    # rows, one library action, and two later scene-description records.
    corpus = ((3, 15),) * 5 + ((17, 58), (18, 0))
    for index, (first, second) in enumerate(corpus):
        cases.append(OracleCase(f"corpus-record-{index}", 1, first, second))
    if len(cases) > MAX_CASES:
        raise OracleFailure(f"oracle fixture exceeds the {MAX_CASES}-action cap")
    return cases


class OriginalActionDispatcher:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        except ImportError as exc:
            raise OracleFailure("Unicorn 2.x required; use work/tools/oracle-python/bin/python") from exc
        from unicorn.x86_const import UC_X86_REG_EAX

        self._eax = UC_X86_REG_EAX
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(BODY_BASE, BODY_SIZE)
        self.uc.mem_map(RETURN_BASE, 0x10000)
        self.uc.mem_write(RETURN_SENTINEL, b"\xCC")
        self.uc.mem_write(GETTICKCOUNT_STUB, b"\xCC")
        self._gate_outcome = False
        self._gate_calls = 0
        self._tick_values: list[int] = []
        self._tick_calls = 0
        self._uc_hook = self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    @staticmethod
    def _return_from_stdcall(machine: Any, argument_bytes: int) -> None:
        from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP

        esp = machine.reg_read(UC_X86_REG_ESP)
        return_address = u32(machine, esp)
        machine.reg_write(UC_X86_REG_ESP, esp + 4 + argument_bytes)
        machine.reg_write(UC_X86_REG_EIP, return_address)

    def _hook_code(self, machine: Any, address: int, _size: int, _user_data: Any) -> None:
        if address == DEPENDENCY_GATE_VA:
            machine.reg_write(self._eax, int(self._gate_outcome))
            self._gate_calls += 1
            self._return_from_stdcall(machine, 4)
        elif address == GETTICKCOUNT_STUB:
            if not self._tick_values:
                raise OracleFailure("original handler made an unexpected GetTickCount call")
            machine.reg_write(self._eax, self._tick_values.pop(0))
            self._tick_calls += 1
            self._return_from_stdcall(machine, 0)

    def invoke(self, case: OracleCase) -> dict[str, Any]:
        from unicorn.x86_const import (
            UC_X86_REG_EBP,
            UC_X86_REG_ECX,
            UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP,
            UC_X86_REG_ESP,
        )

        uc = self.uc
        record = 0
        body_address = BODY_BASE + 0x1000
        body = original_body(case.operation, case.value_1, case.value_2)
        self._gate_outcome = case.eligible
        self._gate_calls = 0
        handler_runs = (case.engine_phase == 3 and not case.completed_before and
                        not case.unloaded and case.eligible)
        self._tick_values = list(case.ticks) if handler_runs else []
        self._tick_calls = 0

        uc.mem_write(GETTICKCOUNT_IAT_VA,
                     struct.pack("<I", GETTICKCOUNT_STUB))
        uc.mem_write(ACTION_COUNT_VA, struct.pack("<h", 1))
        uc.mem_write(ENGINE_PHASE_VA, struct.pack("<i", case.engine_phase))
        uc.mem_write(DEBUG_LOG_VA, b"\0")
        uc.mem_write(CLOCK_VALUE_585D51_VA,
                     struct.pack("<h", case.clock_value_585d51))
        uc.mem_write(CLOCK_VALUE_585D4F_VA,
                     struct.pack("<h", case.clock_value_585d4f))
        uc.mem_write(CLOCK_TOTAL_585D4B_VA,
                     struct.pack("<i", case.clock_total_585d4b))
        uc.mem_write(CLOCK_DEADLINE_585D55_VA,
                     struct.pack("<I", case.clock_deadline_585d55))
        uc.mem_write(DEADLINE_OFFSET_5B0280_VA,
                     struct.pack("<h", case.deadline_offset_5b0280))
        uc.mem_write(CONTROLLER_ACTIVE_001C_VA,
                     struct.pack("<I", case.controller_active_001c))
        uc.mem_write(CONTROLLER_TICK_0456_VA,
                     struct.pack("<I", case.controller_tick_0456))
        uc.mem_write(CONTROLLER_FLAG_0326_VA,
                     bytes((case.controller_flag_0326_0061c6ad,)))

        uc.mem_write(ACTION_TYPE_BASE_VA + record,
                     bytes((0x64, case.subtype & 0xFF)))
        uc.mem_write(ACTION_TYPE_BASE_VA + record + 2,
                     struct.pack("<I", body_address))
        uc.mem_write(body_address, body)
        uc.mem_write(ACTION_COMPLETED_BASE_VA + record,
                     bytes((case.completed_before & 0xFF,)))
        uc.mem_write(ACTION_PHASE_BASE_VA + record,
                     struct.pack("<I", case.phase_before & 0xFFFFFFFF))
        uc.mem_write(ACTION_UNLOADED_BASE_VA + record,
                     struct.pack("<I", case.unloaded & 0xFFFFFFFF))
        dependency = ACTION_DEPENDENCY_BASE_VA + record
        # All fields zero makes the real 0x423d33 subtype-2 branch set word 0.
        uc.mem_write(dependency, bytes(0x38))

        uc.mem_write(STACK_TOP - 4, struct.pack("<I", RETURN_SENTINEL))
        uc.reg_write(UC_X86_REG_ESP, STACK_TOP - 4)
        uc.reg_write(UC_X86_REG_EBP, 0)
        uc.reg_write(UC_X86_REG_ECX, 0)
        uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        uc.reg_write(UC_X86_REG_EIP, DISPATCHER_VA)
        try:
            uc.emu_start(DISPATCHER_VA, RETURN_SENTINEL,
                         timeout=10_000_000, count=500_000)
        except OracleFailure:
            raise
        except Exception as exc:
            raise OracleFailure(f"original dispatcher trapped for {case.label}: {exc}") from exc
        if (uc.reg_read(UC_X86_REG_EIP) != RETURN_SENTINEL or
                uc.reg_read(UC_X86_REG_ESP) != STACK_TOP):
            raise OracleFailure(
                f"dispatcher did not return normally for {case.label}: "
                f"EIP=0x{uc.reg_read(UC_X86_REG_EIP):08x}, "
                f"ESP=0x{uc.reg_read(UC_X86_REG_ESP):08x}"
            )
        if self._tick_values:
            raise OracleFailure(
                f"original handler consumed fewer tick values than expected for {case.label}: "
                f"remaining={self._tick_values}"
            )
        if self._gate_calls != int(case.engine_phase == 3 and not case.completed_before and not case.unloaded):
            raise OracleFailure(
                f"unexpected dependency gate count for {case.label}: {self._gate_calls}"
            )

        return {
            "world": {
                "clock_value_585d51": i16_at(uc, CLOCK_VALUE_585D51_VA),
                "clock_value_585d4f": i16_at(uc, CLOCK_VALUE_585D4F_VA),
                "clock_total_585d4b": struct.unpack("<i", uc.mem_read(CLOCK_TOTAL_585D4B_VA, 4))[0],
                "clock_deadline_585d55": u32(uc, CLOCK_DEADLINE_585D55_VA),
                "deadline_offset_5b0280": i16_at(uc, DEADLINE_OFFSET_5B0280_VA),
                "timer_controller_active_001c": u32(uc, CONTROLLER_ACTIVE_001C_VA),
                "timer_controller_tick_0456": u32(uc, CONTROLLER_TICK_0456_VA),
                "timer_controller_flag_0326_0061c6ad": uc.mem_read(CONTROLLER_FLAG_0326_VA, 1)[0],
            },
            "action": {
                "completed": uc.mem_read(ACTION_COMPLETED_BASE_VA + record, 1)[0],
                "phase": u32(uc, ACTION_PHASE_BASE_VA + record),
                "dependency_reset_marker": u32(uc, dependency),
            },
            "gate_calls": self._gate_calls,
            "tick_calls": self._tick_calls,
        }


def native_invoke(library: c.CDLL, case: OracleCase) -> dict[str, Any]:
    body = bytes_buffer(original_body(case.operation, case.value_1, case.value_2))
    action = Action(0x64, case.subtype, int(case.eligible and case.engine_phase == 3 and
                                            not case.completed_before and not case.unloaded),
                    case.completed_before, case.phase_before, body, 5)
    world = World(
        case.clock_value_585d51,
        case.clock_value_585d4f,
        case.clock_total_585d4b,
        case.clock_deadline_585d55,
        case.deadline_offset_5b0280,
        case.controller_active_001c,
        case.controller_tick_0456,
        case.controller_flag_0326_0061c6ad,
    )
    result = Result()
    ticks = TickSource(case.ticks)
    backend = ticks.backend()
    status = library.action_family64_step(
        c.byref(action), c.byref(world), c.byref(backend), c.byref(result)
    )
    if status != OK:
        raise OracleFailure(f"native 0x64 step failed for {case.label}: status {status}")
    return {
        "world": {
            name: getattr(result.world, name)
            for name, _ctype in World._fields_
        },
        "action": {
            "completed": result.completed,
            "phase": result.phase,
            "dependency_reset_request": result.reset_dependencies,
        },
        "tick_calls": ticks.calls,
    }


def range_hash(pe: PEImage, start: int, end: int) -> str:
    offset = pe.va_to_file_offset(start, end - start)
    return hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest()


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    pe = PEImage.parse_and_map(args.exe)
    original_hash = hashlib.sha256(pe.data).hexdigest()
    if original_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {original_hash}")
    native_path = args.native_library.resolve()
    if not native_path.is_file():
        if native_path == LIBRARY.resolve():
            subprocess.run([str(PROJECT / "scripts/build_action_family_64.sh")], check=True)
        else:
            raise OracleFailure(f"native library unavailable: {native_path}")
    library = c.CDLL(str(native_path))
    library.action_family64_step.argtypes = [
        c.POINTER(Action), c.POINTER(World), c.POINTER(Backend), c.POINTER(Result)
    ]
    library.action_family64_step.restype = c.c_int
    oracle = OriginalActionDispatcher(pe)

    cases = original_cases()
    mismatches: list[dict[str, Any]] = []
    branch_counts: dict[str, int] = {}
    comparisons = []
    total_gate_calls = 0
    total_tick_calls = 0
    for case in cases:
        original = oracle.invoke(case)
        native = native_invoke(library, case)
        total_gate_calls += original["gate_calls"]
        total_tick_calls += original["tick_calls"]
        branch_counts[case.label.split("-", 1)[0]] = branch_counts.get(
            case.label.split("-", 1)[0], 0
        ) + 1
        comparable = {
            "world": original["world"],
            "action": original["action"],
            "tick_calls": original["tick_calls"],
        }
        native_comparable = {
            "world": native["world"],
            "action": {
                "completed": native["action"]["completed"],
                "phase": native["action"]["phase"],
                "dependency_reset_marker": native["action"]["dependency_reset_request"],
            },
            "tick_calls": native["tick_calls"],
        }
        if comparable != native_comparable:
            mismatches.append({
                "label": case.label,
                "operation": case.operation,
                "subtype": case.subtype,
                "eligible": case.eligible,
                "original": comparable,
                "native": native,
            })
        comparisons.append(case.label)

    # 0x64 is selected by type-0x64 minus the loader's 0x0a bias, then the
    # original byte map and jump table select 0x40d04b.
    type_map_index = 0x64 - 0x0A
    type_map_slot = pe.image[0x410E9C + type_map_index - pe.image_base]
    jump_target = struct.unpack_from(
        "<I", pe.image, 0x410CA4 + type_map_slot * 4 - pe.image_base
    )[0]
    report = {
        "scope": "bounded action-family 0x64 runtime; not whole-scene or full-game equivalence",
        "original_sha256": original_hash,
        "native_library_sha256": hashlib.sha256(native_path.read_bytes()).hexdigest(),
        "original_engine": "GAME.EXE PE32 x86 under Unicorn 2.1.4",
        "native_engine": "native ARM64 macOS C shared library",
        "loader": {
            "raw_type": "0x64",
            "type_map_index": type_map_index,
            "type_map_slot": type_map_slot,
            "constructor_target_va": hex(jump_target),
            "body_bytes": 5,
            "normalization": "byte-for-byte raw body; u8 operation@0, i16le@1, i16le@3",
            "body_case_sha256": range_hash(pe, 0x40D04B, 0x40D116),
            "corpus_records": CORPUS_0X64_RECORDS,
            "scene_resource_source_sha256": "8b5400eeafdce32d8adb68afca009ab4c240df8eafdcaaf42dfa231d4f2f4f62",
            "hiff_source_sha256": "ff70edcadda1dac3eb851d8801d6bbda2c178f7792d3dba921fa2d55aed1b97e",
            "temporary_parser_library_sha256": "a06798d4342b9724567da20c158cff0d53369a5f9256310a1850c51b0baab242",
            "corpus_scan": "2,267 extracted files scanned: 2,078 SCEN resources parsed, 189 non-SCEN resources skipped; exactly seven raw 0x64 rows, each raw body length 5 and no dependency tail",
        },
        "code_ranges": [
            {"name": "original constructor FUN_0040b34a", "start": "0x40b34a",
             "end_exclusive": "0x410ca4", "sha256": range_hash(pe, 0x40B34A, 0x410CA4)},
            {"name": "0x64 constructor case selected by table", "start": "0x40d04b",
             "end_exclusive": "0x40d116", "sha256": range_hash(pe, 0x40D04B, 0x40D116)},
            {"name": "dispatcher 0x427a50", "start": "0x427a50",
             "end_exclusive": "0x42acad", "sha256": range_hash(pe, 0x427A50, 0x42ACAD)},
            {"name": "0x64 handler 0x42b87a", "start": "0x42b87a",
             "end_exclusive": "0x42ba22", "sha256": range_hash(pe, 0x42B87A, 0x42BA22)},
            {"name": "completion helper 0x42ba3a", "start": "0x42ba3a",
             "end_exclusive": "0x42babf", "sha256": range_hash(pe, 0x42BA3A, 0x42BABF)},
            {"name": "dependency reset 0x423d33", "start": "0x423d33",
             "end_exclusive": "0x423da2", "sha256": range_hash(pe, 0x423D33, 0x423DA2)},
            {"name": "mode-3 controller getter 0x4d3c31", "start": "0x4d3c31",
             "end_exclusive": "0x4d3c42", "sha256": range_hash(pe, 0x4D3C31, 0x4D3C42)},
            {"name": "mode-3 active timer 0x4d3c5f", "start": "0x4d3c5f",
             "end_exclusive": "0x4d3c88", "sha256": range_hash(pe, 0x4D3C5F, 0x4D3C88)},
            {"name": "mode-4/5/6 latch reset 0x4d3c88", "start": "0x4d3c88",
             "end_exclusive": "0x4d3c9a", "sha256": range_hash(pe, 0x4D3C88, 0x4D3C9A)},
            {"name": "mode-3 tick mark 0x4d3d20", "start": "0x4d3d20",
             "end_exclusive": "0x4d3d3d", "sha256": range_hash(pe, 0x4D3D20, 0x4D3D3D)},
        ],
        "controlled_hooks": [
            {"address": "0x423f57", "behavior": "returns one seeded dependency result; actual 0x64 dispatch remains real"},
            {"address": "IAT slot 0x52a23c", "behavior": "GetTickCount import replaced by deterministic call-counted trampoline"},
        ],
        "original_paths_left_real": [
            "0x427a50 running/completed/unloaded checks and raw-type case 0x64",
            "0x42b87a operation switch and clock writes",
            "0x4d3c31/0x4d3c5f/0x4d3c88/0x4d3d20 controller behavior",
            "0x42ba3a subtype completion/phase handling",
            "0x423d33 subtype-2 dependency reset for zeroed original record fields",
        ],
        "native_kernel_boundary": (
            "Subtype 2 returns reset_dependencies=1; the owning scene executor performs the reset. "
            "The oracle leaves the original 0x423d33 mutation real and compares its zeroed-record "
            "marker with this explicit reset request."
        ),
        "comparison_normalization": (
            "Original 0x423d33 mutates dependency word 0 to 1 for the all-zero fixture; "
            "the family kernel returns reset_dependencies=1 at its executor boundary. "
            "That explicit request is compared to the original marker, while the original reset code remains real."
        ),
        "cases_compared": len(comparisons),
        "case_labels": comparisons,
        "branch_case_counts": branch_counts,
        "mismatches": mismatches,
        "hook_counts": {
            "dependency_gate_calls": total_gate_calls,
            "get_tick_count_reads": total_tick_calls,
            "tick_call_order": "mode 3 with controller +0x1c nonzero reads once for +0x456, then once for +0x585d55; all other eligible operations read once for +0x585d55",
        },
        "excluded": [
            "dependency expression semantics (one dependency gate result is seeded)",
            "resource loader allocation failure and debug logging",
            "full action-table scheduling beyond one slot",
            "native GUI, media, rendering, audio, and whole-game behavior",
        ],
    }
    if mismatches:
        raise OracleFailure(json.dumps(report, indent=2))
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=LIBRARY)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleFailure, OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    print(json.dumps({
        "scope": report["scope"],
        "original_sha256": report["original_sha256"],
        "native_library_sha256": report["native_library_sha256"],
        "cases_compared": report["cases_compared"],
        "branch_case_counts": report["branch_case_counts"],
        "mismatches": len(report["mismatches"]),
        "report": str(args.report),
    }, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
