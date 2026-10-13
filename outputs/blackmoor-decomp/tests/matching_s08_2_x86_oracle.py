#!/usr/bin/env python3
"""Execute assembled S08-2 COFF functions against original x86 and semantic C."""
from __future__ import annotations

import argparse
import ctypes
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
GAS = WORK / "tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
OBJECT = PROJECT / "build/matching_s08_2_x86.obj"
SOURCE = PROJECT / "src/matching_s08_2_x86.s"
C_SOURCE = PROJECT / "src/matching_s08.c"
STACK_BASE = 0x01000000
STACK_SIZE = 0x20000
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x1000
RETURN_SENTINEL = 0x30000000
CANDIDATE_BASE = 0x60000000
EXPECTED = [
    (0x4DAE66, 0x18, "FUN_004dae66", False),
    (0x4DAE77, 0x1C, "FUN_004dae77", False),
    (0x4DAEF1, 0x0C, "FUN_004daef1", False),
    (0x4DAF02, 0x0C, "FUN_004daf02", True),
    (0x4DAF18, 0x10, "FUN_004daf18", False),
    (0x4DAF29, 0x10, "FUN_004daf29", True),
]
FUNCTION_SIZES = {
    0x4DAE66: 17,
    0x4DAE77: 17,
    0x4DAEF1: 17,
    0x4DAF02: 22,
    0x4DAF18: 17,
    0x4DAF29: 22,
}
VALUES = [0, 1, 0xA17C3501, 0xFFFFFFFF, 0x80000000, 0x13579BDF, 0x01010101]


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise OracleError(f"unable to load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def compile_assembly(source: Path, output: Path) -> None:
    run([str(GAS), "--32", "-o", str(output), str(source)])


def install_coff_functions(machine: Any, object_path: Path, suffix: int = 0) -> dict[str, int]:
    verifier = load_module("s08_2_x86_oracle_verifier", PROJECT / "scripts/verify_matches.py")
    obj = verifier._parse_coff_object(object_path.read_bytes())
    result: dict[str, int] = {}
    for index, (_va, _offset, name, _setter) in enumerate(EXPECTED):
        symbol_name = f"_{name}"
        symbol_matches = [symbol for symbol in obj.symbols if symbol.name == symbol_name]
        if len(symbol_matches) != 1:
            raise OracleError(f"expected one assembled function symbol {symbol_name}")
        code, _raw_offset, _symbol = obj.symbol_bytes(symbol_name, FUNCTION_SIZES[EXPECTED[index][0]])
        target = CANDIDATE_BASE + suffix + index * 0x1000
        machine.uc.mem_write(target, code)
        result[name] = target
    return result


def configure_native(library: ctypes.CDLL, name: str, is_setter: bool) -> Any:
    function = getattr(library, name)
    function.argtypes = [ctypes.c_void_p, ctypes.c_uint32] if is_setter else [ctypes.c_void_p]
    function.restype = None if is_setter else ctypes.c_uint32
    return function


def audit(executable: Path, report_path: Path) -> dict[str, Any]:
    original_data = executable.read_bytes()
    actual_sha = sha256(original_data)
    if actual_sha != ORIGINAL_SHA256:
        raise OracleError(f"original executable hash mismatch: {actual_sha}")
    if not GAS.is_file() or not OBJECT.is_file():
        raise OracleError("pinned GNU assembler and audited COFF object must be built first")

    base = load_module("s08_2_x86_original_oracle", PROJECT / "tests/matching_s08_2_original_oracle.py")
    audit_module = load_module("s08_2_x86_object_audit", PROJECT / "scripts/audit_matching_s08_2_x86.py")
    _verifier, _candidate_rows = audit_module.validate_object(OBJECT)

    with tempfile.TemporaryDirectory(prefix="s08-2-x86-oracle-") as directory:
        temp = Path(directory)
        native_library_path = temp / "libmatching_s08.dylib"
        base.compile_native(C_SOURCE, native_library_path)
        native_library_sha256 = sha256(native_library_path.read_bytes())
        native = ctypes.CDLL(str(native_library_path))
        semantic_functions = {
            name: configure_native(native, name, is_setter)
            for _va, _field, name, is_setter in EXPECTED
        }
        machine = base.X86Machine(executable)
        candidate_addresses = install_coff_functions(machine, OBJECT, suffix=0x2000)
        cases = 0
        for case_index, value in enumerate(VALUES):
            seed = base.seed_bytes(case_index + 11, FIXTURE_SIZE)
            for va, _field_offset, name, is_setter in EXPECTED:
                stack_words = (RETURN_SENTINEL, value) if is_setter else (RETURN_SENTINEL,)
                original_eax, original_delta, original_after = machine.call(va, FIXTURE_BASE, stack_words, seed)
                original_ebp = machine.uc.reg_read(machine._ebp)
                candidate_eax, candidate_delta, candidate_after = machine.call(
                    candidate_addresses[name], FIXTURE_BASE, stack_words, seed
                )
                candidate_ebp = machine.uc.reg_read(machine._ebp)
                semantic_eax, semantic_after = base.call_native(
                    semantic_functions[name], is_setter, seed, value
                )
                expected_delta = 8 if is_setter else 4
                if original_delta != expected_delta or candidate_delta != expected_delta:
                    raise OracleError(
                        f"{name} stack cleanup mismatch: original={original_delta}, candidate={candidate_delta}, expected={expected_delta}"
                    )
                if original_ebp != 0 or candidate_ebp != 0:
                    raise OracleError(f"{name} did not restore the incoming EBP value")
                if candidate_after != original_after or candidate_after != semantic_after:
                    raise OracleError(f"{name} memory semantics differ in case {case_index}")
                if not is_setter and (candidate_eax != original_eax or semantic_eax != original_eax):
                    raise OracleError(f"{name} return value differs in case {case_index}")
                if is_setter and candidate_eax != original_eax:
                    raise OracleError(f"{name} register effects differ in case {case_index}")
                cases += 1

        # Assemble a one-field mutation from changed source and prove the x86 oracle catches it.
        mutant_source = temp / "wrong_field.s"
        original_source = SOURCE.read_text(encoding="utf-8")
        needle = "movl 0x18(%eax), %eax"
        if original_source.count(needle) != 1:
            raise OracleError("unable to isolate the assembly wrong-field mutation")
        mutant_source.write_text(original_source.replace(needle, "movl 0x1c(%eax), %eax", 1), encoding="utf-8")
        mutant_object = temp / "wrong_field.obj"
        compile_assembly(mutant_source, mutant_object)
        mutant_addresses = install_coff_functions(machine, mutant_object, suffix=0x9000)
        seed = base.seed_bytes(19, FIXTURE_SIZE)
        original_eax, _delta, _after = machine.call(0x4DAE66, FIXTURE_BASE, (RETURN_SENTINEL,), seed)
        mutant_eax, _delta, _after = machine.call(mutant_addresses["FUN_004dae66"], FIXTURE_BASE, (RETURN_SENTINEL,), seed)
        wrong_field_detected = original_eax != mutant_eax

        # The cdecl mutants receive the original thiscall caller setup on purpose.
        cdecl_object, _ = base.build_cdecl_mutant(temp)
        cdecl_symbols = machine.install_coff_text(cdecl_object)
        fixture = bytearray(base.seed_bytes(23, FIXTURE_SIZE))
        decoy = FIXTURE_BASE + 0x100
        decoy_value = 0xF0E1D2C3
        struct.pack_into("<I", fixture, 0x100 + 0x18, decoy_value)
        original_eax, original_get_delta, _ = machine.call(
            0x4DAE66, FIXTURE_BASE, (RETURN_SENTINEL, decoy), bytes(fixture)
        )
        mutant_eax, mutant_get_delta, _ = machine.call(
            cdecl_symbols["_cdecl_get"], FIXTURE_BASE, (RETURN_SENTINEL, decoy), bytes(fixture)
        )
        cdecl_getter_detected = mutant_eax != original_eax and mutant_get_delta == original_get_delta

        fixture = base.seed_bytes(29, FIXTURE_SIZE)
        thiscall_value = decoy
        cdecl_value = 0xBADC0FFE
        original_after = machine.call(
            0x4DAF02, FIXTURE_BASE, (RETURN_SENTINEL, thiscall_value), fixture
        )
        _eax, original_set_delta, original_set_after = original_after
        _eax, mutant_set_delta, mutant_set_after = machine.call(
            cdecl_symbols["_cdecl_set"], FIXTURE_BASE,
            (RETURN_SENTINEL, thiscall_value, cdecl_value), fixture,
        )
        cdecl_setter_detected = (
            original_set_after != mutant_set_after
            and original_set_delta == 8
            and mutant_set_delta == 4
            and original_set_after[0x0C:0x10] != fixture[0x0C:0x10]
            and mutant_set_after[0x0C:0x10] == fixture[0x0C:0x10]
            and struct.unpack_from("<I", mutant_set_after, 0x100 + 0x0C)[0] == cdecl_value
        )
        if not wrong_field_detected or not cdecl_getter_detected or not cdecl_setter_detected:
            raise OracleError(
                f"mutant missed: field={wrong_field_detected}, cdecl_getter={cdecl_getter_detected}, cdecl_setter={cdecl_setter_detected}"
            )

    return {
        "slice": "S08-2-x86-assembly-oracle",
        "status": "assembled_x86_matches_original_and_semantic_C_mutants_detected",
        "original_sha256": actual_sha,
        "assembly_source_sha256": sha256(SOURCE.read_bytes()),
        "assembly_object_sha256": sha256(OBJECT.read_bytes()),
        "assembly_tool_sha256": sha256(GAS.read_bytes()),
        "assembly_tool_version": run([str(GAS), "--version"]).stdout.splitlines()[0],
        "semantic_C_source_sha256": sha256(C_SOURCE.read_bytes()),
        "native_semantic_library_sha256": native_library_sha256,
        "native_semantic_compiler": run(["xcrun", "clang", "--version"]).stdout.splitlines()[0],
        "native_semantic_compile_flags": ["-dynamiclib", "-std=c11", "-O0", "-fno-stack-protector", "-fno-builtin", "-Wno-ignored-attributes"],
        "function_count": len(EXPECTED),
        "comparison_cases": cases,
        "candidate_original_mismatches": 0,
        "candidate_native_semantic_mismatches": 0,
        "candidate_getter_stack_delta": 4,
        "candidate_setter_stack_delta": 8,
        "candidate_restored_EBP": True,
        "candidate_uses_ECX_this_and_stack_setter_argument": True,
        "wrong_field_assembly_mutant_detected": wrong_field_detected,
        "cdecl_getter_mutant_detected": cdecl_getter_detected,
        "cdecl_setter_mutant_detected": cdecl_setter_detected,
        "x86_executor": "Unicorn 2.1.4, isolated to six original and candidate leaf functions",
        "native_semantic_executor": "Apple Silicon arm64 dylib for matching_s08.c",
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--report", type=Path, default=WORK / "analysis/slices/S08-2-x86-oracle.json")
    args = parser.parse_args()
    sys.path.insert(0, str(PROJECT / "tests"))
    try:
        result = audit(args.original.resolve(), args.report.resolve())
        args.report.resolve().parent.mkdir(parents=True, exist_ok=True)
        args.report.resolve().write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-2 x86 oracle failed: {detail}", file=sys.stderr)
        return 1
    print("S08-2 x86 oracle passed: 42 assembled-function comparisons; wrong-field and cdecl mutants detected.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
