#!/usr/bin/env python3
"""Compare reconstructed accessor semantics with six isolated original x86 functions.

The harness enters only the six pinned leaf functions in Unicorn. It also
executes compiler-generated cdecl mutants under the original thiscall caller
register/stack setup to demonstrate both field and calling-convention failures.
No original instruction bytes are written to reports.
"""
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
EXPECTED_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
STACK_BASE = 0x01000000
STACK_SIZE = 0x20000
FIXTURE_BASE = 0x20000000
FIXTURE_SIZE = 0x1000
RETURN_SENTINEL = 0x30000000
CANDIDATE_BASE = 0x60000000
FUNCTIONS = [
    (0x4DAE66, 0x18, "FUN_004dae66", False),
    (0x4DAE77, 0x1C, "FUN_004dae77", False),
    (0x4DAEF1, 0x0C, "FUN_004daef1", False),
    (0x4DAF02, 0x0C, "FUN_004daf02", True),
    (0x4DAF18, 0x10, "FUN_004daf18", False),
    (0x4DAF29, 0x10, "FUN_004daf29", True),
]


class OracleError(RuntimeError):
    pass


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_verifier() -> Any:
    path = PROJECT / "scripts/verify_matches.py"
    spec = importlib.util.spec_from_file_location("matching_s08_2_verify", path)
    if spec is None or spec.loader is None:
        raise OracleError("unable to load the existing COFF verifier")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, capture_output=True, text=True)


def seed_bytes(case_index: int, size: int = 0x100) -> bytes:
    return bytes((case_index * 73 + index * 29 + 7) & 0xFF for index in range(size))


class X86Machine:
    def __init__(self, executable: Path) -> None:
        try:
            from cif_original_oracle import PEImage, align_up
            from unicorn import Uc, UC_ARCH_X86, UC_MODE_32
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_ECX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESP,
            )
        except ImportError as exc:
            raise OracleError("Unicorn 2.1.x is required; use work/tools/oracle-python/bin/python") from exc
        self.pe = PEImage.parse_and_map(executable)
        self._align_up = align_up
        self._eax = UC_X86_REG_EAX
        self._ebp = UC_X86_REG_EBP
        self._ecx = UC_X86_REG_ECX
        self._eflags = UC_X86_REG_EFLAGS
        self._eip = UC_X86_REG_EIP
        self._esp = UC_X86_REG_ESP
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(self.pe.image_base, align_up(self.pe.size_of_image))
        self.uc.mem_write(self.pe.image_base, self.pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(FIXTURE_BASE, FIXTURE_SIZE)
        self.uc.mem_map(RETURN_SENTINEL, 0x1000)
        self.uc.mem_map(CANDIDATE_BASE, 0x10000)
        self.uc.mem_write(RETURN_SENTINEL, b"\xcc")

    def install_coff_text(self, object_path: Path) -> dict[str, int]:
        verifier = load_verifier()
        obj = verifier._parse_coff_object(object_path.read_bytes())
        result: dict[str, int] = {}
        for name in ("_cdecl_get", "_cdecl_set"):
            candidates = [symbol for symbol in obj.symbols if symbol.name == name]
            if len(candidates) != 1:
                raise OracleError(f"expected exactly one generated mutant symbol {name}")
            symbol = candidates[0]
            if not 1 <= symbol.section_number <= len(obj.sections):
                raise OracleError(f"mutant symbol {name} has no code section")
            section = obj.sections[symbol.section_number - 1]
            if section.relocation_count:
                raise OracleError("cdecl mutant text unexpectedly contains relocations")
            raw = obj.data[section.raw_pointer:section.raw_pointer + section.raw_size]
            if not raw:
                raise OracleError("cdecl mutant text section is empty")
            self.uc.mem_write(CANDIDATE_BASE, raw)
            result[name] = CANDIDATE_BASE + symbol.value
        return result

    def call(self, address: int, receiver: int, stack_words: tuple[int, ...], fixture: bytes) -> tuple[int, int, bytes]:
        if len(fixture) > FIXTURE_SIZE:
            raise OracleError("fixture exceeds its mapped page")
        self.uc.mem_write(FIXTURE_BASE, bytes(FIXTURE_SIZE))
        self.uc.mem_write(FIXTURE_BASE, fixture)
        sp = STACK_BASE + STACK_SIZE - 0x100
        self.uc.mem_write(sp, struct.pack(f"<{len(stack_words)}I", *stack_words))
        self.uc.reg_write(self._esp, sp)
        self.uc.reg_write(self._ebp, 0)
        self.uc.reg_write(self._ecx, receiver)
        self.uc.reg_write(self._eflags, 0x202)
        self.uc.reg_write(self._eax, 0xA5A5A5A5)
        self.uc.reg_write(self._eip, address)
        try:
            self.uc.emu_start(address, RETURN_SENTINEL, timeout=5_000_000, count=50_000)
        except Exception as exc:
            raise OracleError(f"x86 function at 0x{address:08x} trapped: {exc}") from exc
        if self.uc.reg_read(self._eip) != RETURN_SENTINEL:
            raise OracleError(f"x86 function at 0x{address:08x} did not return")
        eax = self.uc.reg_read(self._eax)
        delta = self.uc.reg_read(self._esp) - sp
        after = bytes(self.uc.mem_read(FIXTURE_BASE, len(fixture)))
        return eax, delta, after


def compile_native(source: Path, output: Path) -> None:
    run([
        "xcrun", "clang", "-dynamiclib", "-std=c11", "-O0",
        "-fno-stack-protector", "-fno-builtin", "-Wno-ignored-attributes",
        str(source), "-o", str(output),
    ])


def configure_host_function(library: ctypes.CDLL, name: str, is_setter: bool) -> Any:
    function = getattr(library, name)
    function.argtypes = [ctypes.c_void_p, ctypes.c_uint32] if is_setter else [ctypes.c_void_p]
    function.restype = None if is_setter else ctypes.c_uint32
    return function


def call_native(function: Any, is_setter: bool, fixture: bytes, value: int) -> tuple[int | None, bytes]:
    buffer = ctypes.create_string_buffer(fixture, len(fixture))
    if is_setter:
        function(buffer, value)
        result = None
    else:
        result = int(function(buffer))
    return result, bytes(buffer.raw)


def build_cdecl_mutant(temp: Path) -> tuple[Path, dict[str, int]]:
    source = temp / "cdecl_mutants.c"
    source.write_text(
        "#include <stdint.h>\n"
        "uint32_t cdecl_get(const unsigned char *self) { return *(const uint32_t *)(self + 0x18); }\n"
        "void cdecl_set(unsigned char *self, uint32_t value) { *(uint32_t *)(self + 0x0c) = value; }\n",
        encoding="utf-8",
    )
    obj = temp / "cdecl_mutants.obj"
    run([
        "xcrun", "clang", "-target", "i686-pc-windows-msvc", "-std=c11", "-O0",
        "-fno-omit-frame-pointer", "-fno-stack-protector", "-fno-builtin",
        "-c", str(source), "-o", str(obj),
    ])
    return obj, {}


def audit(executable: Path, report_path: Path) -> dict[str, Any]:
    original_data = executable.read_bytes()
    actual_sha = sha256(original_data)
    if actual_sha != EXPECTED_SHA256:
        raise OracleError(f"original executable hash mismatch: {actual_sha}")
    with tempfile.TemporaryDirectory(prefix="s08-2-oracle-") as directory:
        temp = Path(directory)
        native_library = temp / "libmatching_s08.dylib"
        compile_native(PROJECT / "src/matching_s08.c", native_library)
        native = ctypes.CDLL(str(native_library))
        functions = {
            name: configure_host_function(native, name, is_setter)
            for _va, _offset, name, is_setter in FUNCTIONS
        }
        machine = X86Machine(executable)
        comparisons: list[dict[str, Any]] = []
        case_count = 0
        mismatch_count = 0
        for case_index in range(3):
            seed = seed_bytes(case_index)
            for va, offset, name, is_setter in FUNCTIONS:
                value = (0xA17C3501 + case_index * 0x10203) & 0xFFFFFFFF
                stack_words = (RETURN_SENTINEL, value) if is_setter else (RETURN_SENTINEL,)
                eax, stack_delta, original_after = machine.call(va, FIXTURE_BASE, stack_words, seed)
                native_result, native_after = call_native(functions[name], is_setter, seed, value)
                expected_delta = 8 if is_setter else 4
                agrees = original_after == native_after
                if not is_setter:
                    agrees = agrees and native_result == eax
                if stack_delta != expected_delta:
                    raise OracleError(f"original {name} stack cleanup was {stack_delta}, expected {expected_delta}")
                case_count += 1
                mismatch_count += int(not agrees)
        # A single-field offset mutant must disagree on a buffer with distinct words.
        c_source = (PROJECT / "src/matching_s08.c").read_text(encoding="utf-8")
        wrong_field_source = temp / "wrong_field.c"
        needle = "self + 0x18"
        if c_source.count(needle) != 1:
            raise OracleError("unable to isolate the getter field-offset mutant")
        wrong_field_source.write_text(c_source.replace(needle, "self + 0x1c", 1), encoding="utf-8")
        wrong_library_path = temp / "libwrong_field.dylib"
        compile_native(wrong_field_source, wrong_library_path)
        wrong_library = ctypes.CDLL(str(wrong_library_path))
        wrong_getter = configure_host_function(wrong_library, "FUN_004dae66", False)
        seed = seed_bytes(2)
        original_eax, _delta, _after = machine.call(0x4DAE66, FIXTURE_BASE, (RETURN_SENTINEL,), seed)
        wrong_result, _wrong_after = call_native(wrong_getter, False, seed, 0)
        wrong_field_detected = wrong_result != original_eax

        cdecl_object, _ = build_cdecl_mutant(temp)
        cdecl_symbols = machine.install_coff_text(cdecl_object)
        fixture = bytearray(seed_bytes(1, FIXTURE_SIZE))
        decoy = FIXTURE_BASE + 0x100
        decoy_value = 0xF0E1D2C3
        struct.pack_into("<I", fixture, 0x100 + 0x18, decoy_value)
        original_eax, original_get_delta, _ = machine.call(0x4DAE66, FIXTURE_BASE, (RETURN_SENTINEL, decoy), bytes(fixture))
        mutant_eax, mutant_get_delta, _ = machine.call(cdecl_symbols["_cdecl_get"], FIXTURE_BASE, (RETURN_SENTINEL, decoy), bytes(fixture))
        cdecl_get_detected = mutant_eax != original_eax and mutant_get_delta == original_get_delta

        fixture = seed_bytes(1, FIXTURE_SIZE)
        thiscall_value = decoy
        cdecl_value = 0xBADC0FFE
        original_after = machine.call(0x4DAF02, FIXTURE_BASE, (RETURN_SENTINEL, thiscall_value), fixture)
        _eax, original_set_delta, original_after_bytes = original_after
        _eax, cdecl_set_delta, cdecl_after_bytes = machine.call(
            cdecl_symbols["_cdecl_set"], FIXTURE_BASE,
            (RETURN_SENTINEL, thiscall_value, cdecl_value), fixture,
        )
        original_set_detected = (
            original_after_bytes != cdecl_after_bytes
            and original_set_delta == 8
            and cdecl_set_delta == 4
            and original_after_bytes[0x0C:0x10] != fixture[0x0C:0x10]
            and cdecl_after_bytes[0x0C:0x10] == fixture[0x0C:0x10]
            and struct.unpack_from("<I", cdecl_after_bytes, 0x100 + 0x0C)[0] == cdecl_value
        )
        if mismatch_count or not wrong_field_detected or not cdecl_get_detected or not original_set_detected:
            raise OracleError(
                "source/oracle comparison or mutant detection failed: "
                f"mismatches={mismatch_count}, field_mutant={wrong_field_detected}, "
                f"cdecl_getter={cdecl_get_detected}, cdecl_setter={original_set_detected}"
            )
    return {
        "slice": "S08-2-x86-getter-matching-oracle",
        "status": "original_native_semantics_match_mutants_detected",
        "original_sha256": actual_sha,
        "original_native_cases": case_count,
        "original_native_mismatches": mismatch_count,
        "functions": [
            {"va": va, "name": name, "field_offset": offset, "kind": "setter" if is_setter else "getter", "cases": 3}
            for va, offset, name, is_setter in FUNCTIONS
        ],
        "original_stack_cleanup": {"getter_bytes": 4, "setter_bytes": 8},
        "wrong_field_mutant_detected": wrong_field_detected,
        "cdecl_getter_mutant_detected": cdecl_get_detected,
        "cdecl_setter_mutant_detected": original_set_detected,
        "oracle": "Unicorn 2.1.4; only the six pinned original leaf functions were executed",
        "native_host": "Apple Silicon arm64; thiscall attribute is ignored by this host ABI, so tests compare semantic memory effects",
        "boundary_hooks": [],
        "contains_original_byte_values": False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", type=Path, default=ROOT / "work/original/GAME.EXE")
    parser.add_argument("--report", type=Path, default=ROOT / "work/analysis/slices/S08-2-oracle.json")
    args = parser.parse_args()
    sys.path.insert(0, str(PROJECT / "tests"))
    try:
        report = audit(args.original.resolve(), args.report.resolve())
        args.report.resolve().parent.mkdir(parents=True, exist_ok=True)
        args.report.resolve().write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        detail = exc.stderr if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"S08-2 original oracle failed: {detail}", file=sys.stderr)
        return 1
    print("S08-2 original oracle passed: 18 source comparisons; field and cdecl calling-convention mutants detected.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
