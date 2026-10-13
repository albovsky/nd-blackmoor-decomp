#!/usr/bin/env python3
"""Compare the native input latch kernel with three isolated original x86 methods."""
from __future__ import annotations

import argparse
import ctypes
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x1000
RETURN_SENTINEL = 0x30000000
STACK_BASE = 0x01000000
STACK_SIZE = 0x20000
GLOBAL_5C39E5 = 0x005C39E5
FUNCTIONS = {
    "move": {"va": 0x4DAF9F, "file_offset": 0xDAF9F, "size": 36},
    "down": {"va": 0x4DAFC3, "file_offset": 0xDAFC3, "size": 61},
    "up": {"va": 0x4DB000, "file_offset": 0xDB000, "size": 79},
}
U32_MAX = 0xFFFFFFFF


class StateView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


class PointView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise OracleError(f"unable to load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def compile_native(source: Path, output: Path) -> None:
    result = subprocess.run(
        [
            "xcrun", "clang", "-dynamiclib", "-std=c11", "-O0", "-Wall", "-Wextra", "-Werror",
            "-fno-stack-protector", "-fno-builtin", str(source), "-o", str(output),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    if result.stderr.strip():
        raise OracleError(f"native compilation emitted diagnostics: {result.stderr.strip()[:300]}")


def load_api(library_path: Path) -> tuple[Any, dict[str, Any]]:
    library = ctypes.CDLL(str(library_path))
    functions = {
        "move": library.input_latch_move,
        "down": library.input_latch_down,
        "up": library.input_latch_up,
    }
    functions["move"].argtypes = [ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.POINTER(PointView)]
    functions["move"].restype = ctypes.c_int
    functions["down"].argtypes = [ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32]
    functions["down"].restype = ctypes.c_int
    functions["up"].argtypes = [
        ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32
    ]
    functions["up"].restype = ctypes.c_int
    return library, functions


def fixture(seed: int) -> bytearray:
    return bytearray((seed * 73 + index * 29 + 7) & 0xFF for index in range(FIXTURE_SIZE))


def put_u32(data: bytearray, offset: int, value: int) -> None:
    struct.pack_into("<I", data, offset, value & U32_MAX)


def x86_call(machine: Any, method: str, initial: bytes, arg0: int, arg1: int, guard: int) -> bytes:
    from unicorn.x86_const import (
        UC_X86_REG_EBP,
        UC_X86_REG_EBX,
        UC_X86_REG_EDI,
        UC_X86_REG_ESI,
        UC_X86_REG_ESP,
    )

    if method not in FUNCTIONS:
        raise OracleError(f"unknown method {method}")
    machine.uc.mem_write(GLOBAL_5C39E5, struct.pack("<I", guard & U32_MAX))
    stack_pointer = STACK_BASE + STACK_SIZE - 0x100
    stack_canary = 0xC0DEC0DE
    machine.uc.mem_write(stack_pointer + 12, struct.pack("<I", stack_canary))
    register_canaries = {
        UC_X86_REG_EBX: 0xB16B00B5,
        UC_X86_REG_ESI: 0x51A51A51,
        UC_X86_REG_EDI: 0xD1D1D1D1,
    }
    for register, value in register_canaries.items():
        machine.uc.reg_write(register, value)
    stack_words = (RETURN_SENTINEL, arg0 & U32_MAX, arg1 & U32_MAX)
    _eax, delta, after = machine.call(
        FUNCTIONS[method]["va"], FIXTURE_BASE, stack_words, initial
    )
    if delta != 12:
        raise OracleError(f"{method} ret-8 stack delta including return address was {delta}, expected 12")
    if machine.uc.reg_read(UC_X86_REG_EBP) != 0:
        raise OracleError(f"{method} did not restore EBP")
    for register, value in register_canaries.items():
        if machine.uc.reg_read(register) != value:
            raise OracleError(f"{method} changed a callee-saved register")
    if struct.unpack("<I", machine.uc.mem_read(stack_pointer + 12, 4))[0] != stack_canary:
        raise OracleError(f"{method} damaged the caller stack canary")
    if machine.uc.reg_read(UC_X86_REG_ESP) != stack_pointer + 12:
        raise OracleError(f"{method} returned with an unexpected ESP")
    if len(after) != FIXTURE_SIZE:
        raise OracleError(f"{method} returned a truncated state snapshot")
    return after


def native_call(functions: dict[str, Any], method: str, initial: bytes, arg0: int, arg1: int, guard: int, point_offset: int = 0) -> bytes:
    storage = ctypes.create_string_buffer(initial, len(initial))
    state_pointer = ctypes.cast(ctypes.addressof(storage), ctypes.POINTER(ctypes.c_uint8))
    state = StateView(state_pointer, len(initial))
    if method == "move":
        point_pointer = ctypes.cast(
            ctypes.addressof(storage) + point_offset, ctypes.POINTER(ctypes.c_uint8)
        )
        point = PointView(point_pointer, len(initial) - point_offset)
        status = functions[method](ctypes.byref(state), arg0 & U32_MAX, ctypes.byref(point))
    elif method == "down":
        status = functions[method](ctypes.byref(state), arg0 & U32_MAX, arg1 & U32_MAX)
    else:
        status = functions[method](
            ctypes.byref(state), arg0 & U32_MAX, arg1 & U32_MAX, guard & U32_MAX
        )
    if status != 0:
        raise OracleError(f"native {method} returned adapter status {status}")
    return ctypes.string_at(ctypes.addressof(storage), len(initial))


def initial_move_fixture(seed: int, point_offset: int, x: int, y: int) -> bytes:
    data = fixture(seed)
    put_u32(data, point_offset, x)
    put_u32(data, point_offset + 4, y)
    return bytes(data)


def initial_latch_fixture(seed: int, field_00: int, field_08: int, field_0c: int, field_10: int) -> bytes:
    data = fixture(seed)
    for offset, value in ((0x00, field_00), (0x08, field_08), (0x0C, field_0c), (0x10, field_10)):
        put_u32(data, offset, value)
    return bytes(data)


def require_equal(method: str, case_id: str, original: bytes, native: bytes) -> None:
    if original != native:
        differences = [index for index, pair in enumerate(zip(original, native)) if pair[0] != pair[1]]
        raise OracleError(
            f"{method} case {case_id} differed at {len(differences)} offsets; first offsets={differences[:8]}"
        )


def compare_all(executable: Path, library_path: Path) -> dict[str, Any]:
    original = executable.read_bytes()
    actual_hash = sha256(original)
    if actual_hash != ORIGINAL_SHA256:
        raise OracleError(f"original executable hash mismatch: {actual_hash}")

    index_path = PROJECT / "function-index.json"
    index_bytes = index_path.read_bytes()
    index = json.loads(index_bytes)
    if index.get("original_sha256") != ORIGINAL_SHA256:
        raise OracleError("Ghidra function index is pinned to a different executable")
    indexed_starts = sorted(int(row["address"], 16) for row in index.get("functions", []))
    for method, row in FUNCTIONS.items():
        if row["va"] not in indexed_starts:
            raise OracleError(f"{method} is absent from the Ghidra function index")
        next_start = indexed_starts[indexed_starts.index(row["va"]) + 1]
        if next_start != row["va"] + row["size"]:
            raise OracleError(f"{method} extent no longer ends at the next Ghidra function start")
        if sha256(original[row["file_offset"]:row["file_offset"] + row["size"]]) == sha256(b""):
            raise OracleError(f"{method} original function extent is empty")

    decomp_path = WORK / "analysis/decompiled/batch-02080.json"
    decomp = json.loads(decomp_path.read_text(encoding="utf-8"))
    evidence_id = decomp.get("evidence_id")
    if not isinstance(evidence_id, str) or not evidence_id.startswith("ev_"):
        raise OracleError("Ghidra/REA decompilation evidence id is missing")

    oracle_module = load_module(
        "s08_3_original_x86_harness", PROJECT / "tests/matching_s08_2_original_oracle.py"
    )
    machine = oracle_module.X86Machine(executable)
    _library, functions = load_api(library_path)
    comparisons = {method: 0 for method in FUNCTIONS}
    windows = []

    move_cases = [
        (0, 0x100, 0, 0),
        (1, 0x100, U32_MAX, 0x80000000),
        (2, 0x100, 0x7FFFFFFF, 0xFFFFFFFF),
        (3, 0x14, 0xA17C3501, 0x13579BDF),
        (4, 0x14, 0x01010101, U32_MAX),
        (5, 0x200, 0x80000000, 1),
    ]
    for case_index, (seed, point_offset, x, y) in enumerate(move_cases):
        initial = initial_move_fixture(seed, point_offset, x, y)
        original_after = x86_call(
            machine, "move", initial, 0x0BADF00D + case_index,
            FIXTURE_BASE + point_offset, U32_MAX,
        )
        native_after = native_call(
            functions, "move", initial, 0x0BADF00D + case_index,
            FIXTURE_BASE + point_offset, U32_MAX, point_offset,
        )
        require_equal("move", str(case_index), original_after, native_after)
        comparisons["move"] += 1

    down_values = (0, 1, 2, 0x80000000, U32_MAX)
    for case_index, value in enumerate(down_values):
        initial = initial_latch_fixture(case_index + 10, 0xAABBCCDD, 0x10203040, value, 0x55667788)
        original_after = x86_call(machine, "down", initial, U32_MAX - case_index, 0xDEADBEEF, 0)
        native_after = native_call(functions, "down", initial, U32_MAX - case_index, 0xDEADBEEF, 0)
        require_equal("down", str(case_index), original_after, native_after)
        comparisons["down"] += 1

    guard_values = (U32_MAX, 0, 1, 0x80000000)
    latch_values = (0, 1, 2, 0x80000000, U32_MAX)
    block_values = (0, 1, 0x80000000, U32_MAX)
    case_index = 0
    for blocked in block_values:
        for guard in guard_values:
            for field_00 in latch_values:
                for field_0c in latch_values:
                    initial = initial_latch_fixture(
                        case_index + 30, field_00, blocked, field_0c, 0xA1B2C3D4
                    )
                    original_after = x86_call(
                        machine, "up", initial, case_index, 0xDEADBEEF, guard
                    )
                    native_after = native_call(
                        functions, "up", initial, case_index, 0xDEADBEEF, guard
                    )
                    require_equal("up", str(case_index), original_after, native_after)
                    comparisons["up"] += 1
                    case_index += 1

    # Original event sequences exercise interaction between repeated latches and moves.
    interleavings = [
        [
            ("move", 0x100, 0x13579BDF, 0x80000000, U32_MAX),
            ("down", 0, U32_MAX, 0xDEADBEEF, U32_MAX),
            ("up", 0, 0, 0xDEADBEEF, 0),
        ],
        [
            ("down", 0, 0x10, 0x20, 0),
            ("down", 0, 0x30, 0x40, 0),
            ("up", 0, U32_MAX, 0xDEADBEEF, U32_MAX),
            ("up", 0, 0, 0xDEADBEEF, 1),
        ],
        [
            ("move", 0x14, 0x11223344, 0x55667788, 0),
            ("up", 0, 1, 2, 0x80000000),
            ("move", 0x14, U32_MAX, 0x80000000, 0),
        ],
    ]
    interleaving_steps = 0
    for sequence_index, sequence in enumerate(interleavings):
        current = initial_latch_fixture(sequence_index + 90, 0, 0, 0, 0xDEADBEEF)
        for step_index, (method, point_offset, arg0, arg1, guard) in enumerate(sequence):
            state = bytearray(current)
            if method == "move":
                put_u32(state, point_offset, arg0)
                put_u32(state, point_offset + 4, arg1)
                current = bytes(state)
                point_arg = FIXTURE_BASE + point_offset
            else:
                point_arg = arg1
            original_after = x86_call(machine, method, current, arg0, point_arg, guard)
            native_after = native_call(functions, method, current, arg0, point_arg, guard, point_offset)
            require_equal(method, f"sequence-{sequence_index}-step-{step_index}", original_after, native_after)
            current = original_after
            comparisons[method] += 1
            interleaving_steps += 1

    window_rows = []
    for method, row in FUNCTIONS.items():
        code = original[row["file_offset"]:row["file_offset"] + row["size"]]
        window_rows.append({
            "method": method,
            "va": f"0x{row['va']:x}",
            "file_offset": f"0x{row['file_offset']:x}",
            "size": row["size"],
            "sha256": sha256(code),
        })
    windows.extend(window_rows)
    return {
        "slice": "S08-3-original-input-latch-oracle",
        "status": "native_kernel_matches_original_selected_methods",
        "original_sha256": actual_hash,
        "function_index_sha256": sha256(index_bytes),
        "function_index_evidence_id": evidence_id,
        "ghidra_decompilation": "work/analysis/decompiled/batch-02080.json",
        "code_windows": windows,
        "native_library_sha256": sha256(library_path.read_bytes()),
        "original_native_comparisons": sum(comparisons.values()),
        "original_native_mismatches": 0,
        "comparisons_by_method": comparisons,
        "interleaving_steps": interleaving_steps,
        "full_fixture_bytes_compared_per_step": FIXTURE_SIZE,
        "x86_abi": {
            "receiver": "ECX",
            "stack_arguments": "two DWORDs per method",
            "move_second_argument": "bounded two-DWORD point pointer; first stack DWORD ignored",
            "down_up_arguments": "both ignored and not dereferenced",
            "terminal_instruction": "ret 8",
            "esp_delta_including_return_address": 12,
            "EBP_restored": True,
            "EBX_ESI_EDI_canaries_preserved": True,
            "caller_stack_canary_preserved": True,
        },
        "unverified_branches": [
            "MFC message-wrapper side effects and shared tail 0x51ab4b remain outside this slice.",
            "Upstream viewport, scrolling, clipping, and activation-coordinate transforms remain outside this slice.",
            "The 0x5c39e5 global's semantic meaning remains unnamed.",
        ],
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--library", type=Path, default=PROJECT / "build/libinput_latch.dylib")
    parser.add_argument("--report", type=Path, default=WORK / "analysis/slices/S08-3-original-oracle.json")
    args = parser.parse_args()
    try:
        sys.path.insert(0, str(PROJECT / "tests"))
        result = compare_all(args.original.resolve(), args.library.resolve())
        args.report.resolve().parent.mkdir(parents=True, exist_ok=True)
        args.report.resolve().write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-3 original input oracle failed: {detail}", file=sys.stderr)
        return 1
    print(
        "S08-3 native/original oracle passed: "
        f"{result['original_native_comparisons']} steps / "
        f"{result['full_fixture_bytes_compared_per_step']} state bytes each; "
        "zero mismatches, ret-8 ABI and stack canaries confirmed."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
