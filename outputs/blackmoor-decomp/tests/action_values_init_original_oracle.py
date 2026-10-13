#!/usr/bin/env python3
"""Compare ActionCore's sentinel initializer with original GAME.EXE code.

This enters original VA 0x44aff2 directly in Unicorn. The function has no
arguments, calls, or API dependencies. It compares all 100 contiguous value
bytes and verifies that the adjacent difficulty word and seeded event flags
remain unchanged. This is a narrow initializer check, not whole-game evidence.

Run from the workspace root with:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/action_values_init_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import subprocess
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_action_core import ActionCoreWorld


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_NATIVE = PROJECT / "build/libactioncore.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/action-values-init-validation.json"

INITIALIZER_VA = 0x44AFF2
SHORT_VALUES_VA = 0x58C959
FLOAT_VALUES_VA = 0x58C995
DIFFICULTY_VA = 0x58C94F
EVENT_FLAGS_VA = 0x585801
EVENT_FLAG_COUNT = 8

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
RETURN_SENTINEL = 0x30000000


class OracleFailure(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def expected_value_bytes() -> bytes:
    return struct.pack("<30h10f", *([9999] * 30), *([9999.0] * 10))


def seeded_value_bytes(case_index: int) -> bytes:
    return bytes((case_index * 71 + offset * 37 + 19) & 0xFF
                 for offset in range(100))


def signed32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value if value < 0x80000000 else value - 0x100000000


class OriginalInitializer:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        except ImportError as exc:
            raise OracleFailure(
                "Unicorn 2.x required; use work/tools/oracle-python/bin/python"
            ) from exc
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(RETURN_SENTINEL, 0x1000)
        self.uc.mem_write(RETURN_SENTINEL, b"\xCC")
        self.trace: list[tuple[int, int]] = []
        self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    def _hook_code(self, _machine: Any, address: int,
                   size: int, _user_data: Any) -> None:
        self.trace.append((address, size))

    def invoke(self, initial_values: bytes, difficulty: int,
               event_values: tuple[int, ...]) -> dict[str, Any]:
        from unicorn.x86_const import (
            UC_X86_REG_EBP,
            UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP,
            UC_X86_REG_ESP,
        )

        if len(initial_values) != 100 or len(event_values) != EVENT_FLAG_COUNT:
            raise OracleFailure("invalid fixed-size seeded oracle input")
        self.uc.mem_write(SHORT_VALUES_VA, initial_values)
        self.uc.mem_write(DIFFICULTY_VA, struct.pack("<h", difficulty))
        self.uc.mem_write(EVENT_FLAGS_VA, struct.pack("<8i", *event_values))
        self.uc.mem_write(STACK_TOP - 4, struct.pack("<I", RETURN_SENTINEL))

        self.trace.clear()
        self.uc.reg_write(UC_X86_REG_ESP, STACK_TOP - 4)
        self.uc.reg_write(UC_X86_REG_EBP, 0)
        self.uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        self.uc.reg_write(UC_X86_REG_EIP, INITIALIZER_VA)
        try:
            self.uc.emu_start(INITIALIZER_VA, RETURN_SENTINEL,
                              timeout=2_000_000, count=500_000)
        except Exception as exc:
            raise OracleFailure(f"original 0x44aff2 trapped: {exc}") from exc

        eip = self.uc.reg_read(UC_X86_REG_EIP)
        esp = self.uc.reg_read(UC_X86_REG_ESP)
        if eip != RETURN_SENTINEL or esp != STACK_TOP:
            raise OracleFailure(
                "initializer did not return normally: "
                f"EIP=0x{eip:08x}, ESP=0x{esp:08x}"
            )
        if not self.trace or any(
            address < INITIALIZER_VA or address >= INITIALIZER_VA + 0x200
            for address, _size in self.trace
        ):
            raise OracleFailure(
                "direct call entered outside the initializer's 0x200-byte code window"
            )

        code_end = max(address + size for address, size in self.trace)
        value_bytes = bytes(self.uc.mem_read(SHORT_VALUES_VA, 100))
        difficulty_bytes = bytes(self.uc.mem_read(DIFFICULTY_VA, 2))
        event_bytes = bytes(
            self.uc.mem_read(EVENT_FLAGS_VA, EVENT_FLAG_COUNT * 4)
        )
        return {
            "value_bytes": value_bytes,
            "difficulty_bytes": difficulty_bytes,
            "event_bytes": event_bytes,
            "executed_instruction_count": len(self.trace),
            "code_end_exclusive": code_end,
        }


def native_invoke(library: c.CDLL, initial_values: bytes, difficulty: int,
                  event_values: tuple[int, ...]) -> dict[str, Any]:
    flags = (c.c_int32 * EVENT_FLAG_COUNT)(*event_values)
    world = ActionCoreWorld()
    c.memmove(c.addressof(world), initial_values, len(initial_values))
    world.difficulty = difficulty
    world.event_flags = flags
    world.event_flag_count = EVENT_FLAG_COUNT
    original_pointer = c.cast(world.event_flags, c.c_void_p).value
    original_count = world.event_flag_count

    status = library.action_core_initialize_values(c.byref(world))
    if status != 0:
        raise OracleFailure(f"native initializer returned status {status}")
    return {
        "value_bytes": c.string_at(c.addressof(world), 100),
        "difficulty_bytes": struct.pack("<h", world.difficulty),
        "event_bytes": bytes(flags),
        "event_pointer_unchanged": (
            c.cast(world.event_flags, c.c_void_p).value == original_pointer
        ),
        "event_count_unchanged": world.event_flag_count == original_count,
    }


def build_library() -> None:
    subprocess.run([str(PROJECT / "scripts/build_action_core.sh")], check=True)


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    native_path = args.native_library.resolve()
    if not native_path.is_file():
        if native_path == DEFAULT_NATIVE.resolve():
            build_library()
        else:
            raise OracleFailure(f"requested native library unavailable: {native_path}")

    pe = PEImage.parse_and_map(args.exe)
    original_hash = sha256(pe.data)
    if original_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {original_hash}")
    library = c.CDLL(str(native_path))
    library.action_core_initialize_values.argtypes = [
        c.POINTER(ActionCoreWorld)
    ]
    library.action_core_initialize_values.restype = c.c_int
    oracle = OriginalInitializer(pe)

    expected = expected_value_bytes()
    case_reports: list[dict[str, Any]] = []
    code_end = 0
    instruction_count = 0
    for case_index, difficulty in enumerate((-1234, 23456), 1):
        initial_values = seeded_value_bytes(case_index)
        event_values = tuple(
            signed32(case_index * 0x1020304 + index * 0x11111111)
            for index in range(EVENT_FLAG_COUNT)
        )
        original = oracle.invoke(initial_values, difficulty, event_values)
        native = native_invoke(library, initial_values, difficulty, event_values)
        code_end = original["code_end_exclusive"]
        instruction_count = original["executed_instruction_count"]
        if original["value_bytes"] != expected:
            raise OracleFailure(f"original case {case_index} did not write expected 100 bytes")
        if native["value_bytes"] != expected:
            raise OracleFailure(f"native case {case_index} did not write expected 100 bytes")
        expected_difficulty = struct.pack("<h", difficulty)
        expected_events = struct.pack("<8i", *event_values)
        if original["difficulty_bytes"] != expected_difficulty:
            raise OracleFailure(f"original case {case_index} changed difficulty")
        if native["difficulty_bytes"] != expected_difficulty:
            raise OracleFailure(f"native case {case_index} changed difficulty")
        if original["event_bytes"] != expected_events:
            raise OracleFailure(f"original case {case_index} changed event flags")
        if native["event_bytes"] != expected_events:
            raise OracleFailure(f"native case {case_index} changed event flags")
        if not native["event_pointer_unchanged"] or not native["event_count_unchanged"]:
            raise OracleFailure(f"native case {case_index} changed event pointer/count")
        case_reports.append({
            "case": case_index,
            "difficulty_before_and_after": difficulty,
            "seeded_value_bytes_sha256": sha256(initial_values),
            "value_bytes_sha256": sha256(expected),
            "value_bytes_match_original": original["value_bytes"] == native["value_bytes"],
            "difficulty_unchanged_original_and_native": True,
            "event_flags_unchanged_original_and_native": True,
            "native_event_pointer_and_count_unchanged": True,
        })

    code_size = code_end - INITIALIZER_VA
    code_offset = pe.va_to_file_offset(INITIALIZER_VA, code_size)
    code_hash = sha256(pe.data[code_offset:code_offset + code_size])
    native_hash = sha256(native_path.read_bytes())
    return {
        "scope": (
            "direct original VA 0x44aff2 call with no function stubs; compares all "
            "100 contiguous short/float bytes and verifies difficulty/event state "
            "preservation. Not a whole-game check."
        ),
        "original_executable_sha256": original_hash,
        "original_code_window": {
            "start": f"0x{INITIALIZER_VA:08x}",
            "end_exclusive": f"0x{code_end:08x}",
            "size_bytes": code_size,
            "sha256": code_hash,
            "executed_instruction_count_per_case": instruction_count,
            "external_calls_or_stubs": 0,
        },
        "native_library_sha256": native_hash,
        "sentinel_contract": {
            "short_values_address": f"0x{SHORT_VALUES_VA:08x}",
            "short_count": 30,
            "short_value": 9999,
            "float_values_address": f"0x{FLOAT_VALUES_VA:08x}",
            "float_count": 10,
            "float_value": 9999.0,
            "float_bits_hex": "0x461c3c00",
            "compared_contiguous_value_bytes": 100,
            "difficulty_address": f"0x{DIFFICULTY_VA:08x}",
            "event_flags_address": f"0x{EVENT_FLAGS_VA:08x}",
            "native_event_pointer_and_count_unchanged": True,
        },
        "cases": case_reports,
        "case_count": len(case_reports),
        "preliminary_test_run": {
            "result": "failed_before_correction",
            "reason": (
                "The first test expectation used float 10000.0f; direct original "
                "execution and bits 0x461c3c00 establish 9999.0f. The implementation "
                "and expected value were corrected before final passing checks."
            ),
        },
        "result": "pass",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    report = run(args)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "result": report["result"],
        "cases": report["case_count"],
        "value_bytes": report["sentinel_contract"]["compared_contiguous_value_bytes"],
        "original_sha256": report["original_executable_sha256"],
        "code_window": report["original_code_window"],
        "native_library_sha256": report["native_library_sha256"],
        "report": str(args.report),
    }, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except OracleFailure as exc:
        raise SystemExit(f"ORACLE FAILURE: {exc}") from exc
