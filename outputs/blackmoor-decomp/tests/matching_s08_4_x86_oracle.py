#!/usr/bin/env python3
"""Compare candidate and original input-consumer x86 with full ABI context."""
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
ORIGINAL_EXTENTS = {
    "field0": (0x4DAF3F, 47, "_FUN_004daf3f"),
    "field4": (0x4DAF6E, 49, "_FUN_004daf6e"),
}
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x1000
STACK_BASE = 0x01000000
STACK_SIZE = 0x20000
RETURN_SENTINEL = 0x30000000
CANDIDATE_BASE = 0x60000000
U32_MAX = 0xFFFFFFFF
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise OracleError(f"cannot load module at {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def fixture(seed: int) -> bytes:
    return bytes((seed * 73 + index * 29 + 7) & 0xFF for index in range(FIXTURE_SIZE))


def put_u32(data: bytearray, offset: int, value: int) -> None:
    struct.pack_into("<I", data, offset, value & U32_MAX)


def parse_object(path: Path) -> Any:
    verifier = load_module("s08_4_x86_object_verifier", PROJECT / "scripts/verify_matches.py")
    return verifier._parse_coff_object(path.read_bytes())


def install_object(machine: Any, object_path: Path, base: int) -> dict[str, int]:
    obj = parse_object(object_path)
    sections = [section for section in obj.sections if section.name == ".text"]
    if len(sections) != 1 or sections[0].relocation_count:
        raise OracleError("candidate object must have one relocation-free .text section")
    section = sections[0]
    raw = obj.data[section.raw_pointer:section.raw_pointer + section.raw_size]
    if not raw:
        raise OracleError("candidate object .text is empty")
    machine.uc.mem_write(base, raw)
    addresses: dict[str, int] = {}
    for method, (_va, size, symbol_name) in ORIGINAL_EXTENTS.items():
        symbols = [symbol for symbol in obj.symbols if symbol.name == symbol_name]
        if len(symbols) != 1:
            raise OracleError(f"candidate symbol {symbol_name} is missing or ambiguous")
        symbol = symbols[0]
        if not 1 <= symbol.section_number <= len(obj.sections):
            raise OracleError(f"candidate symbol {symbol_name} has no section")
        if obj.sections[symbol.section_number - 1].name != ".text":
            raise OracleError(f"candidate symbol {symbol_name} is outside .text")
        if symbol.value + size > section.raw_size:
            raise OracleError(f"candidate symbol {symbol_name} extent is outside .text")
        addresses[method] = base + symbol.value
    return addresses


def call_detail(machine: Any, address: int, method: str, initial: bytes,
                eflags: int, case_id: str) -> dict[str, Any]:
    from unicorn.x86_const import (
        UC_X86_REG_EAX,
        UC_X86_REG_EBP,
        UC_X86_REG_EBX,
        UC_X86_REG_ECX,
        UC_X86_REG_EDI,
        UC_X86_REG_EDX,
        UC_X86_REG_EFLAGS,
        UC_X86_REG_EIP,
        UC_X86_REG_ESI,
        UC_X86_REG_ESP,
    )

    if method not in ORIGINAL_EXTENTS:
        raise OracleError(f"unknown method {method}")
    if len(initial) != FIXTURE_SIZE:
        raise OracleError(f"{method} case {case_id} state size is {len(initial)}, expected {FIXTURE_SIZE}")

    machine.uc.mem_write(FIXTURE_BASE, bytes(FIXTURE_SIZE))
    machine.uc.mem_write(FIXTURE_BASE, initial)
    stack_pointer = STACK_BASE + STACK_SIZE - 0x100
    stack_canary = 0xC0DEC0DE
    stack_words = (RETURN_SENTINEL,)
    machine.uc.mem_write(stack_pointer, struct.pack("<I", stack_words[0]))
    machine.uc.mem_write(stack_pointer + 4, struct.pack("<I", stack_canary))
    register_values = {
        UC_X86_REG_EAX: 0xA5A5A5A5,
        UC_X86_REG_EBX: 0xB16B00B5,
        UC_X86_REG_ECX: FIXTURE_BASE,
        UC_X86_REG_EDX: 0xD2D2D2D2,
        UC_X86_REG_ESI: 0x51A51A51,
        UC_X86_REG_EDI: 0xD1D1D1D1,
        UC_X86_REG_EBP: 0xE5E5E5E5,
        UC_X86_REG_ESP: stack_pointer,
        UC_X86_REG_EFLAGS: eflags | 0x2,
        UC_X86_REG_EIP: address,
    }
    for register, value in register_values.items():
        machine.uc.reg_write(register, value)
    try:
        machine.uc.emu_start(address, RETURN_SENTINEL, timeout=5_000_000, count=50_000)
    except Exception as exc:
        raise OracleError(f"{method} case {case_id} trapped: {exc}") from exc
    if machine.uc.reg_read(UC_X86_REG_EIP) != RETURN_SENTINEL:
        raise OracleError(f"{method} case {case_id} did not return through its caller sentinel")
    after = bytes(machine.uc.mem_read(FIXTURE_BASE, FIXTURE_SIZE))
    final_stack = bytes(machine.uc.mem_read(stack_pointer - 8, 16))
    actual = {
        "state": after,
        "eax": machine.uc.reg_read(UC_X86_REG_EAX),
        "ebx": machine.uc.reg_read(UC_X86_REG_EBX),
        "ecx": machine.uc.reg_read(UC_X86_REG_ECX),
        "edx": machine.uc.reg_read(UC_X86_REG_EDX),
        "esi": machine.uc.reg_read(UC_X86_REG_ESI),
        "edi": machine.uc.reg_read(UC_X86_REG_EDI),
        "ebp": machine.uc.reg_read(UC_X86_REG_EBP),
        "esp": machine.uc.reg_read(UC_X86_REG_ESP),
        "eflags": machine.uc.reg_read(UC_X86_REG_EFLAGS),
        "eip": machine.uc.reg_read(UC_X86_REG_EIP),
        "stack_canary": struct.unpack("<I", machine.uc.mem_read(stack_pointer + 4, 4))[0],
        "stack_redzone": final_stack,
    }
    if actual["esp"] != stack_pointer + 4:
        raise OracleError(f"{method} case {case_id} ESP delta {actual['esp'] - stack_pointer}, expected 4")
    if actual["ebp"] != 0xE5E5E5E5:
        raise OracleError(f"{method} case {case_id} did not restore EBP")
    if actual["stack_canary"] != stack_canary:
        raise OracleError(f"{method} case {case_id} damaged its caller stack canary")
    if actual["ebx"] != 0xB16B00B5 or actual["esi"] != 0x51A51A51 or actual["edi"] != 0xD1D1D1D1:
        raise OracleError(f"{method} case {case_id} damaged a callee-saved register")
    return actual


def compare_pair(machine: Any, candidate_addresses: dict[str, int], method: str,
                 initial: bytes, flags: int, case_id: str) -> None:
    original_va = ORIGINAL_EXTENTS[method][0]
    original = call_detail(machine, original_va, method, initial, flags, f"{case_id}-original")
    candidate = call_detail(machine, candidate_addresses[method], method, initial, flags, f"{case_id}-candidate")
    for key in ("state", "eax", "ebx", "ecx", "edx", "esi", "edi", "ebp", "esp", "eflags", "eip", "stack_canary", "stack_redzone"):
        if candidate[key] != original[key]:
            if key == "state":
                differences = [i for i, pair in enumerate(zip(original[key], candidate[key])) if pair[0] != pair[1]]
                raise OracleError(f"{method} case {case_id} state differs at {len(differences)} bytes; offsets={differences[:12]}")
            raise OracleError(f"{method} case {case_id} {key} differs")


def mutation_catches(executable: Path, source_path: Path, machine: Any,
                     original_harness: Any, temp: Path) -> dict[str, bool]:
    source = source_path.read_text(encoding="utf-8")
    checks = {
        "wrong_clear": ("movl $0, 0x0c(%edx)", "movl $0, 0x08(%edx)"),
        "wrong_result": ("movl $1, %eax", "movl $2, %eax"),
    }
    result: dict[str, bool] = {}
    for index, (name, (needle, replacement)) in enumerate(checks.items()):
        if needle not in source:
            raise OracleError(f"cannot isolate {name} assembly mutation")
        mutant_source = temp / f"{name}.s"
        mutant_object = temp / f"{name}.obj"
        mutant_source.write_text(source.replace(needle, replacement, 1), encoding="utf-8")
        run([str(GAS), "--32", "-o", str(mutant_object), str(mutant_source)])
        addresses = install_object(machine, mutant_object, CANDIDATE_BASE + 0x2000 + index * 0x2000)
        initial = bytearray(fixture(250 + index))
        put_u32(initial, 0x00, 0x80000000)
        put_u32(initial, 0x08, 0x11223344)
        put_u32(initial, 0x0C, 0xAABBCCDD)
        flags = 0x246
        original = call_detail(machine, ORIGINAL_EXTENTS["field0"][0], "field0", bytes(initial), flags, f"{name}-original")
        mutant = call_detail(machine, addresses["field0"], "field0", bytes(initial), flags, f"{name}-mutant")
        detected = any(mutant[key] != original[key] for key in ("state", "eax", "eflags", "esp"))
        if not detected:
            raise OracleError(f"deliberate {name} assembly mutant escaped original-x86 comparison")
        result[f"{name}_detected"] = detected
    return result


def compare_candidate(executable: Path, object_path: Path, report_path: Path) -> dict[str, Any]:
    original_hash = sha256(executable.read_bytes())
    if original_hash != ORIGINAL_SHA256:
        raise OracleError(f"original executable hash mismatch: {original_hash}")
    if not GAS.is_file():
        raise OracleError(f"pinned assembler missing at {GAS}")

    auditor = load_module("s08_4_x86_oracle_auditor", PROJECT / "scripts/audit_matching_s08_4_x86.py")
    audit_report = auditor.audit(
        executable, object_path, PROJECT / "src/matching_s08_4_x86.s", include_compiler_probe=False
    )
    if audit_report["classification"] != "explicit_reconstructed_assembly_source":
        raise OracleError("candidate assembly is not bound to the reviewed source/object/manifest")
    harness = load_module("s08_4_original_machine_harness", PROJECT / "tests/matching_s08_2_original_oracle.py")
    machine = harness.X86Machine(executable)
    candidate_addresses = install_object(machine, object_path, CANDIDATE_BASE)

    comparisons_by_method = {method: 0 for method in ORIGINAL_EXTENTS}
    values = (0, 1, 2, 0x7FFFFFFF, 0x80000000, U32_MAX)
    flags_values = (0x202, 0x246, 0x293)
    case = 0
    for method, (va, size, symbol) in ORIGINAL_EXTENTS.items():
        for primary in values:
            for companion in values:
                state = bytearray(fixture(case))
                field_offset = 0 if method == "field0" else 4
                companion_offset = 0x0C if method == "field0" else 0x10
                put_u32(state, field_offset, primary)
                put_u32(state, companion_offset, companion)
                put_u32(state, 0x04 if method == "field0" else 0x00, U32_MAX - case)
                flags = flags_values[case % len(flags_values)]
                compare_pair(machine, candidate_addresses, method, bytes(state), flags, f"matrix-{case}")
                comparisons_by_method[method] += 1
                case += 1

        # A first call clears the pair; the repeated call returns zero and writes nothing.
        state = bytearray(fixture(300 + case))
        put_u32(state, 0 if method == "field0" else 4, U32_MAX)
        put_u32(state, 0x0C if method == "field0" else 0x10, 0x80000000)
        compare_pair(machine, candidate_addresses, method, bytes(state), 0x202, f"repeat-{method}-first")
        after_first = bytearray(state)
        after_first[0 if method == "field0" else 4:4 if method == "field0" else 8] = b"\x00" * 4
        after_first[0x0C if method == "field0" else 0x10:0x10 if method == "field0" else 0x14] = b"\x00" * 4
        compare_pair(machine, candidate_addresses, method, bytes(after_first), 0x246, f"repeat-{method}-second")
        comparisons_by_method[method] += 2

    with tempfile.TemporaryDirectory(prefix="s08-4-x86-mutants-") as directory:
        mutation_report = mutation_catches(executable, PROJECT / "src/matching_s08_4_x86.s", machine, harness, Path(directory))

    count = sum(comparisons_by_method.values())
    report = {
        "slice": "S08-4-candidate-x86-vs-original-x86",
        "status": "candidate_x86_matches_original_selected_functions",
        "original_sha256": original_hash,
        "source_sha256": sha256((PROJECT / "src/matching_s08_4_x86.s").read_bytes()),
        "object_sha256": sha256(object_path.read_bytes()),
        "manifest_sha256": sha256((PROJECT / "matches_s08_4_x86.json").read_bytes()),
        "function_index_sha256": sha256((PROJECT / "function-index.json").read_bytes()),
        "assembler_sha256": sha256(GAS.read_bytes()),
        "original_candidate_comparisons": count,
        "candidate_original_mismatches": 0,
        "comparisons_by_method": comparisons_by_method,
        "compared_state_bytes_per_call": FIXTURE_SIZE,
        "compared_context": ["complete state bytes", "EAX", "EBX", "ECX", "EDX", "ESI", "EDI", "EBP", "ESP", "EFLAGS", "EIP", "caller stack canary", "stack redzone"],
        "expected_stack_delta": 4,
        "return_contract": "implicit ECX receiver; no stack arguments; full-width EAX 0/1; plain ret",
        "mutation_detection": mutation_report,
        "contains_original_byte_values": False,
        "whole_executable_rebuilt": False,
    }
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--object", type=Path, default=PROJECT / "build/matching_s08_4_x86.obj")
    parser.add_argument("--report", type=Path, default=PROJECT / "build/matching_s08_4_x86-oracle.json")
    args = parser.parse_args()
    try:
        report = compare_candidate(args.original, args.object, args.report)
    except (OSError, RuntimeError, ValueError, KeyError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-4 x86 original/candidate oracle failed: {detail}", file=sys.stderr)
        return 1
    print(
        f"S08-4 x86 oracle: {report['original_candidate_comparisons']} calls, "
        f"{report['candidate_original_mismatches']} mismatches; EFLAGS/ESP/canaries and "
        f"wrong-clear/result mutants checked."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
