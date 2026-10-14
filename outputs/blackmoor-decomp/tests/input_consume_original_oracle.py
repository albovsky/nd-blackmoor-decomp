#!/usr/bin/env python3
"""Compare the native input consumers/interleavings with original x86 methods."""
from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import struct
import subprocess
import tempfile
from pathlib import Path
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x1000
RETURN_SENTINEL = 0x30000000
GLOBAL_5C39E5 = 0x005C39E5
U32_MAX = 0xFFFFFFFF
METHODS = {
    "field0": {"va": 0x4DAF3F, "offset": 0, "companion": 0x0C, "ret_bytes": 0},
    "field4": {"va": 0x4DAF6E, "offset": 4, "companion": 0x10, "ret_bytes": 0},
    "down": {"va": 0x4DAFC3, "ret_bytes": 8},
    "up": {"va": 0x4DB000, "ret_bytes": 8},
}


class StateView(ctypes.Structure):
    _fields_ = [("bytes", ctypes.POINTER(ctypes.c_uint8)), ("length", ctypes.c_size_t)]


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def load_original_harness() -> Any:
    import matching_s08_2_original_oracle as harness
    return harness


def compile_native(sources: list[Path], output: Path) -> None:
    run([
        "xcrun", "clang", "-dynamiclib", "-std=c11", "-O0", "-Wall", "-Wextra", "-Werror",
        "-fno-stack-protector", "-fno-builtin", "-I", str(PROJECT / "src"),
        *(str(source) for source in sources), "-o", str(output),
    ])


def configure_native(library_path: Path) -> tuple[Any, dict[str, Any]]:
    library = ctypes.CDLL(str(library_path))
    functions: dict[str, Any] = {}
    for name in ("input_consume_field0", "input_consume_field4"):
        function = getattr(library, name)
        function.argtypes = [ctypes.POINTER(StateView), ctypes.POINTER(ctypes.c_uint32)]
        function.restype = ctypes.c_int
        functions[name] = function
    down = library.input_latch_down
    down.argtypes = [ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32]
    down.restype = ctypes.c_int
    functions["down"] = down
    up = library.input_latch_up
    up.argtypes = [ctypes.POINTER(StateView), ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
    up.restype = ctypes.c_int
    functions["up"] = up
    return library, functions


def fixture(seed: int) -> bytes:
    return bytes((seed * 73 + index * 29 + 7) & 0xFF for index in range(FIXTURE_SIZE))


def put_u32(data: bytearray, offset: int, value: int) -> None:
    struct.pack_into("<I", data, offset, value & U32_MAX)


def original_call(machine: Any, method: str, initial: bytes,
                  arg0: int = 0xA1B2C3D4, arg1: int = 0x55667788,
                  guard: int = U32_MAX) -> tuple[int, bytes]:
    metadata = METHODS[method]
    machine.uc.mem_write(GLOBAL_5C39E5, struct.pack("<I", guard & U32_MAX))
    if method in ("field0", "field4"):
        stack_words = (RETURN_SENTINEL,)
    else:
        stack_words = (RETURN_SENTINEL, arg0 & U32_MAX, arg1 & U32_MAX)
    eax, delta, after = machine.call(metadata["va"], FIXTURE_BASE, stack_words, initial)
    expected_delta = 4 + metadata["ret_bytes"]
    if delta != expected_delta:
        raise OracleError(f"original {method} stack delta {delta}, expected {expected_delta}")
    if len(after) != FIXTURE_SIZE:
        raise OracleError(f"original {method} returned a truncated state snapshot")
    return eax, after


def native_call(functions: dict[str, Any], method: str, initial: bytes,
                arg0: int = 0xA1B2C3D4, arg1: int = 0x55667788,
                guard: int = U32_MAX) -> tuple[int | None, bytes]:
    storage = ctypes.create_string_buffer(initial, len(initial))
    pointer = ctypes.cast(ctypes.addressof(storage), ctypes.POINTER(ctypes.c_uint8))
    view = StateView(pointer, len(initial))
    if method in ("field0", "field4"):
        result = ctypes.c_uint32(0xA5A5A5A5)
        status = functions[f"input_consume_{method}"](ctypes.byref(view), ctypes.byref(result))
        if status != 0:
            raise OracleError(f"native {method} adapter status {status}")
        raw_return: int | None = int(result.value)
    elif method == "down":
        status = functions["down"](ctypes.byref(view), arg0 & U32_MAX, arg1 & U32_MAX)
        if status != 0:
            raise OracleError(f"native down adapter status {status}")
        raw_return = None
    elif method == "up":
        status = functions["up"](ctypes.byref(view), arg0 & U32_MAX, arg1 & U32_MAX, guard & U32_MAX)
        if status != 0:
            raise OracleError(f"native up adapter status {status}")
        raw_return = None
    else:
        raise OracleError(f"unknown native method {method}")
    return raw_return, bytes(storage.raw)


def compare_step(machine: Any, functions: dict[str, Any], method: str, initial: bytes,
                 case_id: str, arg0: int = 0xA1B2C3D4, arg1: int = 0x55667788,
                 guard: int = U32_MAX) -> tuple[int | None, bytes]:
    original_eax, original_after = original_call(machine, method, initial, arg0, arg1, guard)
    native_return, native_after = native_call(functions, method, initial, arg0, arg1, guard)
    if original_after != native_after:
        differences = [i for i, pair in enumerate(zip(original_after, native_after)) if pair[0] != pair[1]]
        raise OracleError(f"{method} case {case_id} differs at {len(differences)} bytes; offsets={differences[:12]}")
    if method in ("field0", "field4") and native_return != original_eax:
        raise OracleError(f"{method} case {case_id} raw EAX {native_return} != original {original_eax}")
    return native_return, native_after


def compare_sequence(machine: Any, functions: dict[str, Any], initial: bytes,
                     sequence: list[tuple[str, int, int, int]], label: str,
                     counts: dict[str, int]) -> bytes:
    current = initial
    for index, (method, arg0, arg1, guard) in enumerate(sequence):
        _raw, current = compare_step(
            machine, functions, method, current, f"{label}-{index}", arg0, arg1, guard
        )
        counts[method] += 1
    return current


def compare_frame_chain(machine: Any, functions: dict[str, Any], initial: bytes,
                        label: str, counts: dict[str, int]) -> tuple[bytes, bool]:
    first, current = compare_step(machine, functions, "field0", initial, f"{label}-field0")
    counts["field0"] += 1
    second_called = first == 0
    if second_called:
        _second, current = compare_step(machine, functions, "field4", current, f"{label}-field4")
        counts["field4"] += 1
    return current, second_called


def run_mutation_checks(machine: Any, functions: dict[str, Any], temp: Path) -> dict[str, bool]:
    source_text = (PROJECT / "src/input_consume.c").read_text(encoding="utf-8")
    clear_needle = "write_u32_le(bytes + 0x0c, 0);"
    if source_text.count(clear_needle) != 1:
        raise OracleError("cannot isolate wrong-clear native mutant")
    wrong_clear_source = temp / "wrong-clear.c"
    wrong_clear_source.write_text(source_text.replace(clear_needle, "write_u32_le(bytes + 0x08, 0);", 1), encoding="utf-8")
    wrong_clear_library = temp / "libwrong-clear.dylib"
    compile_native([PROJECT / "src/input_latch.c", wrong_clear_source], wrong_clear_library)
    _wrong_clear_lib, wrong_clear_functions = configure_native(wrong_clear_library)

    result_needle = "raw_return = read_u32_le(bytes) != 0 ? 1u : 0u;"
    if source_text.count(result_needle) != 1:
        raise OracleError("cannot isolate wrong-result native mutant")
    wrong_result_source = temp / "wrong-result.c"
    wrong_result_source.write_text(source_text.replace(result_needle, "raw_return = read_u32_le(bytes) != 0 ? 2u : 0u;", 1), encoding="utf-8")
    wrong_result_library = temp / "libwrong-result.dylib"
    compile_native([PROJECT / "src/input_latch.c", wrong_result_source], wrong_result_library)
    _wrong_result_lib, wrong_result_functions = configure_native(wrong_result_library)

    fixture_bytes = bytearray(fixture(201))
    put_u32(fixture_bytes, 0x00, 0x80000000)
    put_u32(fixture_bytes, 0x08, 0x11223344)
    put_u32(fixture_bytes, 0x0C, 0xAABBCCDD)
    original_eax, original_after = original_call(machine, "field0", bytes(fixture_bytes))
    wrong_clear_return, wrong_clear_after = native_call(wrong_clear_functions, "field0", bytes(fixture_bytes))
    wrong_clear_detected = wrong_clear_after != original_after or wrong_clear_return != original_eax

    wrong_result_return, wrong_result_after = native_call(wrong_result_functions, "field0", bytes(fixture_bytes))
    wrong_result_detected = wrong_result_after != original_after or wrong_result_return != original_eax
    if not wrong_clear_detected or not wrong_result_detected:
        raise OracleError("native deliberate wrong-clear/wrong-result mutation escaped differential oracle")
    return {"wrong_clear_detected": wrong_clear_detected, "wrong_result_detected": wrong_result_detected}


def compare_original_native(executable: Path, report_path: Path) -> dict[str, Any]:
    original_bytes = executable.read_bytes()
    original_hash = sha256(original_bytes)
    if original_hash != ORIGINAL_SHA256:
        raise OracleError(f"original executable hash mismatch: {original_hash}")
    harness = load_original_harness()
    machine = harness.X86Machine(executable)

    with tempfile.TemporaryDirectory(prefix="s08-4-native-oracle-") as directory:
        temp = Path(directory)
        library_path = temp / "libinput-kernels.dylib"
        compile_native(
            [PROJECT / "src/input_latch.c", PROJECT / "src/input_consume.c"],
            library_path,
        )
        library, functions = configure_native(library_path)
        counts = {name: 0 for name in METHODS}
        values = (0, 1, 2, 0x7FFFFFFF, 0x80000000, U32_MAX)
        case_number = 0

        # Every branch value is paired with every noncanonical companion value.
        for method in ("field0", "field4"):
            primary_offset = METHODS[method]["offset"]
            companion_offset = METHODS[method]["companion"]
            for primary in values:
                for companion in values:
                    state = bytearray(fixture(case_number))
                    put_u32(state, primary_offset, primary)
                    put_u32(state, companion_offset, companion)
                    put_u32(state, 0x04 if method == "field0" else 0x00, U32_MAX - case_number)
                    compare_step(machine, functions, method, bytes(state), f"matrix-{case_number}")
                    counts[method] += 1
                    case_number += 1

        # Repeated calls verify that the first nonzero consume clears the pair.
        for method in ("field0", "field4"):
            state = bytearray(fixture(150 + counts[method]))
            put_u32(state, METHODS[method]["offset"], 0xFFFFFFFF)
            put_u32(state, METHODS[method]["companion"], 0x80000000)
            _first, after_first = compare_step(machine, functions, method, bytes(state), f"repeat-{method}-0")
            counts[method] += 1
            second, after_second = compare_step(machine, functions, method, after_first, f"repeat-{method}-1")
            counts[method] += 1
            if second != 0 or after_second != after_first:
                raise OracleError(f"{method} repeated call did not return zero without further writes")

        # Both consumers run in both explicit orders against full state snapshots.
        for order_index, order in enumerate((("field0", "field4"), ("field4", "field0"))):
            state = bytearray(fixture(170 + order_index))
            put_u32(state, 0x00, 0x80000000)
            put_u32(state, 0x04, U32_MAX)
            put_u32(state, 0x0C, 0x12345678)
            put_u32(state, 0x10, 0x87654321)
            compare_sequence(
                machine, functions, bytes(state),
                [(order[0], 0, 0, U32_MAX), (order[1], 0, 0, U32_MAX)],
                f"order-{order_index}", counts,
            )

        # Accepted down/up methods interleave with both new consumers.
        sequences = [
            [("down", 0x11111111, 0x22222222, U32_MAX),
             ("field0", 0, 0, U32_MAX), ("field4", 0, 0, U32_MAX),
             ("up", 0x33333333, 0x44444444, 0),
             ("field0", 0, 0, U32_MAX), ("field4", 0, 0, U32_MAX)],
            [("up", 0xDEADBEEF, 0xCAFEBABE, U32_MAX),
             ("field4", 0, 0, U32_MAX), ("down", U32_MAX, 0x80000000, U32_MAX),
             ("field0", 0, 0, U32_MAX), ("up", 1, 2, 0),
             ("field4", 0, 0, U32_MAX)],
            [("down", 0, 0, U32_MAX), ("down", U32_MAX, U32_MAX, U32_MAX),
             ("up", 0, 0, 1), ("field0", 0, 0, U32_MAX),
             ("field4", 0, 0, U32_MAX)],
        ]
        interleaving_steps = 0
        for sequence_index, sequence in enumerate(sequences):
            state = bytearray(fixture(190 + sequence_index))
            put_u32(state, 0x00, 0x80000000)
            put_u32(state, 0x04, U32_MAX)
            put_u32(state, 0x08, sequence_index)
            put_u32(state, 0x0C, 1)
            put_u32(state, 0x10, 0x10203040 + sequence_index)
            compare_sequence(machine, functions, bytes(state), sequence, f"interleave-{sequence_index}", counts)
            interleaving_steps += len(sequence)

        # Frame-dispatch behavior is first-result short-circuit, then field4 only on zero.
        frame_short_circuit_cases = 0
        for index, field0_value in enumerate((1, 0)):
            state = bytearray(fixture(230 + index))
            put_u32(state, 0x00, field0_value)
            put_u32(state, 0x04, U32_MAX)
            put_u32(state, 0x0C, 0x13579BDF)
            put_u32(state, 0x10, 0x2468ACE0)
            after, second_called = compare_frame_chain(machine, functions, bytes(state), f"frame-{index}", counts)
            if second_called != (field0_value == 0):
                raise OracleError("native frame chain did not preserve first-result short circuit")
            if field0_value != 0 and int.from_bytes(after[4:8], "little") != U32_MAX:
                raise OracleError("field4 changed when the first consumer short-circuited the frame chain")
            frame_short_circuit_cases += 1

        mutations = run_mutation_checks(machine, functions, temp)
        report = {
            "slice": "S08-4-native-input-consumers-vs-original-x86",
            "original_sha256": original_hash,
            "native_library_sha256": sha256(library_path.read_bytes()),
            "native_original_comparisons": sum(counts.values()),
            "native_original_mismatches": 0,
            "comparisons_by_method": counts,
            "full_state_bytes_per_comparison": FIXTURE_SIZE,
            "full_state_bytes_compared": sum(counts.values()) * FIXTURE_SIZE,
            "interleaving_steps": interleaving_steps,
            "frame_short_circuit_cases": frame_short_circuit_cases,
            "frame_short_circuit": {
                "field0_nonzero_skips_field4": True,
                "field0_zero_calls_field4": True,
            },
            "mutation_detection": mutations,
            "return_contract": "native adapter status separate from original full-width EAX 0/1",
            "contains_original_byte_values": False,
            "unverified_branches": [
                "Upstream native frame wrappers remain outside this isolated kernel oracle.",
                "Original source/compiler provenance and whole-executable matching remain open.",
            ],
        }
        # Keep live library references until all native comparison calls finish.
        _ = library

    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--report", type=Path, default=PROJECT / "build/input_consume_original_oracle.json")
    args = parser.parse_args()
    try:
        report = compare_original_native(args.original, args.report)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-4 native/original oracle failed: {detail}")
        return 1
    print(
        f"S08-4 native/original oracle: {report['native_original_comparisons']} calls, "
        f"{report['full_state_bytes_compared']} state bytes compared, "
        f"{report['native_original_mismatches']} mismatches; "
        f"wrong-clear/result mutants detected={all(report['mutation_detection'].values())}."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
