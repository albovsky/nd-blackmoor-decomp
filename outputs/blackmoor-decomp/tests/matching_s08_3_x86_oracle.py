#!/usr/bin/env python3
"""Execute the assembled S08-3 methods against original x86 methods."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / "work"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
SOURCE = PROJECT / "src/matching_s08_3_x86.s"
OBJECT = PROJECT / "build/matching_s08_3_x86.obj"
AUDITOR = PROJECT / "scripts/audit_matching_s08_3_x86.py"
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
CANDIDATE_BASE = 0x60000000
U32_MAX = 0xFFFFFFFF
EXPECTED = {
    "move": (0x4DAF9F, 36, "_FUN_004daf9f"),
    "down": (0x4DAFC3, 61, "_FUN_004dafc3"),
    "up": (0x4DB000, 79, "_FUN_004db000"),
}


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise OracleError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def install_object(machine: Any, object_path: Path, suffix: int = 0x2000) -> dict[str, int]:
    verifier = load_module("s08_3_x86_oracle_verifier", PROJECT / "scripts/verify_matches.py")
    obj = verifier._parse_coff_object(object_path.read_bytes())
    result: dict[str, int] = {}
    for index, (method, (_va, size, symbol_name)) in enumerate(EXPECTED.items()):
        code, _offset, _symbol = obj.symbol_bytes(symbol_name, size)
        target = CANDIDATE_BASE + suffix + index * 0x1000
        machine.uc.mem_write(target, code)
        result[method] = target
    return result


def call_detail(machine: Any, method: str, address: int, initial: bytes,
                arg0: int, arg1: int, guard: int) -> dict[str, Any]:
    from unicorn.x86_const import (
        UC_X86_REG_EAX,
        UC_X86_REG_EBP,
        UC_X86_REG_EBX,
        UC_X86_REG_ECX,
        UC_X86_REG_EDI,
        UC_X86_REG_EDX,
        UC_X86_REG_EFLAGS,
        UC_X86_REG_ESI,
        UC_X86_REG_ESP,
    )
    from matching_s08_2_original_oracle import (
        FIXTURE_BASE,
        RETURN_SENTINEL,
        STACK_BASE,
        STACK_SIZE,
    )

    machine.uc.mem_write(0x005C39E5, struct.pack("<I", guard & U32_MAX))
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
    _eax, delta, after = machine.call(
        address,
        FIXTURE_BASE,
        (RETURN_SENTINEL, arg0 & U32_MAX, arg1 & U32_MAX),
        initial,
    )
    if delta != 12:
        raise OracleError(f"{method} stack delta is {delta}, expected ret-8 delta 12")
    if machine.uc.reg_read(UC_X86_REG_ESP) != stack_pointer + 12:
        raise OracleError(f"{method} returned with incorrect ESP")
    if machine.uc.reg_read(UC_X86_REG_EBP) != 0:
        raise OracleError(f"{method} did not restore EBP")
    for register, value in register_canaries.items():
        if machine.uc.reg_read(register) != value:
            raise OracleError(f"{method} changed a callee-saved register")
    if struct.unpack("<I", machine.uc.mem_read(stack_pointer + 12, 4))[0] != stack_canary:
        raise OracleError(f"{method} damaged its caller stack canary")
    return {
        "bytes": after,
        "esp_delta": delta,
        "eax": machine.uc.reg_read(UC_X86_REG_EAX),
        "ecx": machine.uc.reg_read(UC_X86_REG_ECX),
        "edx": machine.uc.reg_read(UC_X86_REG_EDX),
        "eflags": machine.uc.reg_read(UC_X86_REG_EFLAGS),
    }


def compare_call(machine: Any, candidate_addresses: dict[str, int], method: str,
                 initial: bytes, arg0: int, arg1: int, guard: int, case_id: str) -> None:
    original_va = EXPECTED[method][0]
    original = call_detail(machine, method, original_va, initial, arg0, arg1, guard)
    candidate = call_detail(machine, method, candidate_addresses[method], initial, arg0, arg1, guard)
    for key in ("bytes", "esp_delta", "eax", "ecx", "edx", "eflags"):
        if candidate[key] != original[key]:
            if key == "bytes":
                differences = [i for i, pair in enumerate(zip(original[key], candidate[key])) if pair[0] != pair[1]]
                raise OracleError(
                    f"{method} case {case_id} state differs at {len(differences)} bytes; offsets={differences[:12]}"
                )
            raise OracleError(f"{method} case {case_id} {key} differs")


def run_x86_oracle(executable: Path, object_path: Path, report_path: Path) -> dict[str, Any]:
    original_hash = sha256(executable.read_bytes())
    if original_hash != ORIGINAL_SHA256:
        raise OracleError(f"original executable hash mismatch: {original_hash}")
    if not GAS.is_file() or not object_path.is_file():
        raise OracleError("pinned assembler and candidate object must be present")

    auditor = load_module("s08_3_x86_oracle_audit", AUDITOR)
    auditor.validate_object(object_path)
    base = load_module("s08_3_input_oracle_cases", PROJECT / "tests/input_latch_original_oracle.py")
    harness = load_module("s08_3_original_x86_machine", PROJECT / "tests/matching_s08_2_original_oracle.py")
    machine = harness.X86Machine(executable)
    candidate_addresses = install_object(machine, object_path)

    cases_by_method = {method: 0 for method in EXPECTED}
    move_cases = [
        (0, 0x100, 0, 0),
        (1, 0x100, U32_MAX, 0x80000000),
        (2, 0x100, 0x7FFFFFFF, U32_MAX),
        (3, 0x14, 0xA17C3501, 0x13579BDF),
        (4, 0x14, 0x01010101, U32_MAX),
        (5, 0x200, 0x80000000, 1),
    ]
    for index, (seed, point_offset, x, y) in enumerate(move_cases):
        initial = base.initial_move_fixture(seed, point_offset, x, y)
        compare_call(machine, candidate_addresses, "move", initial, 0x0BADF00D + index,
                    0x20000000 + point_offset, U32_MAX, str(index))
        cases_by_method["move"] += 1

    down_values = (0, 1, 2, 0x80000000, U32_MAX)
    for index, value in enumerate(down_values):
        initial = base.initial_latch_fixture(index + 10, 0xAABBCCDD, 0x10203040, value, 0x55667788)
        compare_call(machine, candidate_addresses, "down", initial, U32_MAX - index, 0xDEADBEEF, 0, str(index))
        cases_by_method["down"] += 1

    guard_values = (U32_MAX, 0, 1, 0x80000000)
    latch_values = (0, 1, 2, 0x80000000, U32_MAX)
    block_values = (0, 1, 0x80000000, U32_MAX)
    case_index = 0
    for blocked in block_values:
        for guard in guard_values:
            for field_00 in latch_values:
                for field_0c in latch_values:
                    initial = base.initial_latch_fixture(case_index + 30, field_00, blocked, field_0c, 0xA1B2C3D4)
                    compare_call(machine, candidate_addresses, "up", initial, case_index,
                                 0xDEADBEEF, guard, str(case_index))
                    cases_by_method["up"] += 1
                    case_index += 1

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
        current = base.initial_latch_fixture(sequence_index + 90, 0, 0, 0, 0xDEADBEEF)
        for step_index, (method, point_offset, arg0, arg1, guard) in enumerate(sequence):
            state = bytearray(current)
            if method == "move":
                base.put_u32(state, point_offset, arg0)
                base.put_u32(state, point_offset + 4, arg1)
                current = bytes(state)
                point_arg = 0x20000000 + point_offset
            else:
                point_arg = arg1
            compare_call(machine, candidate_addresses, method, current, arg0, point_arg,
                         guard, f"sequence-{sequence_index}-step-{step_index}")
            cases_by_method[method] += 1
            interleaving_steps += 1

    wrong_store, wrong_guard = run_mutation_checks(executable, machine)
    if not wrong_store or not wrong_guard:
        raise OracleError("deliberate wrong-store or wrong-guard x86 mutant was not detected")

    return {
        "slice": "S08-3-assembled-x86-original-oracle",
        "status": "reviewed_assembly_matches_original_x86_abi_and_state",
        "original_sha256": original_hash,
        "assembly_source_sha256": sha256(SOURCE.read_bytes()),
        "assembly_object_sha256": sha256(object_path.read_bytes()),
        "assembler_sha256": sha256(GAS.read_bytes()),
        "function_count": len(EXPECTED),
        "compared_bytes_per_case": 0x1000,
        "original_candidate_comparisons": sum(cases_by_method.values()),
        "candidate_original_mismatches": 0,
        "comparisons_by_method": cases_by_method,
        "interleaving_steps": interleaving_steps,
        "compared_context": ["all 4096 state bytes", "ESP/ret8", "EAX", "ECX", "EDX", "EFLAGS", "EBP", "EBX/ESI/EDI canaries", "caller stack canary"],
        "wrong_store_mutant_detected": wrong_store,
        "wrong_guard_mutant_detected": wrong_guard,
        "contains_original_byte_values": False,
    }


def run_mutation_checks(executable: Path, machine: Any) -> tuple[bool, bool]:
    base = load_module("s08_3_mutation_cases", PROJECT / "tests/input_latch_original_oracle.py")
    source_text = SOURCE.read_text(encoding="utf-8")
    wrong_store_text = source_text.replace("movl %edx, 0x18(%eax)", "movl %edx, 0x1c(%eax)", 1)
    wrong_guard_text = source_text.replace("cmpl $-1, 0x005c39e5", "cmpl $0, 0x005c39e5", 1)
    if wrong_store_text == source_text or wrong_guard_text == source_text:
        raise OracleError("unable to apply a discriminating assembly mutant")
    with tempfile.TemporaryDirectory(prefix="s08-3-x86-mutants-") as directory:
        temp = Path(directory)
        mutant_objects = []
        for index, mutated_source in enumerate((wrong_store_text, wrong_guard_text)):
            source_path = temp / f"mutant-{index}.s"
            object_path = temp / f"mutant-{index}.obj"
            source_path.write_text(mutated_source, encoding="utf-8")
            subprocess.run([str(GAS), "--32", "-o", str(object_path), str(source_path)], check=True, capture_output=True)
            mutant_objects.append(object_path)

        # Store mutant: point X must differ from the prior state, so a wrong
        # destination cannot be masked by the same input and old value.
        initial = base.initial_move_fixture(0x13, 0x100, 0x12345678, 0x89ABCDEF)
        wrong_store_addresses = install_object(machine, mutant_objects[0], suffix=0x8000)
        original = call_detail(machine, "move", EXPECTED["move"][0], initial, 0xAA, 0x20000100, U32_MAX)
        mutant = call_detail(machine, "move", wrong_store_addresses["move"], initial, 0xAA, 0x20000100, U32_MAX)
        wrong_store_detected = mutant["bytes"] != original["bytes"]

        # Sentinel mutant: zero is a valid non-sentinel guard value. With a
        # clear primary latch the original must set it, while the mutant skips.
        initial = base.initial_latch_fixture(0x17, 0, 0, 1, 0xDEADBEEF)
        wrong_guard_addresses = install_object(machine, mutant_objects[1], suffix=0xC000)
        original = call_detail(machine, "up", EXPECTED["up"][0], initial, 0x11, 0x22, 0)
        mutant = call_detail(machine, "up", wrong_guard_addresses["up"], initial, 0x11, 0x22, 0)
        wrong_guard_detected = mutant["bytes"] != original["bytes"]
    return wrong_store_detected, wrong_guard_detected


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--object", type=Path, default=OBJECT)
    parser.add_argument("--report", type=Path, default=PROJECT / "build/matching_s08_3_x86-oracle.json")
    args = parser.parse_args()
    try:
        sys.path.insert(0, str(PROJECT / "tests"))
        report = run_x86_oracle(args.original.resolve(), args.object.resolve(), args.report.resolve())
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-3 x86 oracle failed: {detail}", file=sys.stderr)
        return 1
    print(
        "S08-3 original/candidate x86 oracle passed: "
        f"{report['original_candidate_comparisons']} calls / {report['compared_bytes_per_case']} state bytes; "
        "all state/register/ABI checks exact; wrong-store and wrong-guard mutants detected."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
