#!/usr/bin/env python3
"""Exhaustively compare FUN004c7314 with the native pixel transform.

The oracle maps GAME.EXE as a PE image and enters only the x86 function at
0x4c7314 under Unicorn. It neither launches the game nor uses renderer code.

Example::

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/pixel_original_oracle.py \\
      --exe work/original/GAME.EXE \\
      --native-library outputs/blackmoor-decomp/build/libcifpixels.dylib \\
      --report work/analysis/pixel-validation-report.json
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import struct
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence


ROOT = Path(__file__).resolve().parents[3]
TESTS_DIR = ROOT / "outputs/blackmoor-decomp/tests"
sys.path.insert(0, str(TESTS_DIR))

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up  # noqa: E402


FUNCTION_VA = 0x4C7314
NEXT_FUNCTION_VA = 0x4C7481
CALLER_VA = 0x418E52
THIS_ADDRESS = 0x20000000
PIXELS_ADDRESS = 0x21000000
SENTINEL_ADDRESS = 0x51000000
STACK_BASE = 0x1000
STACK_SIZE = 0xF000
PAGE_SIZE = 0x1000
BYTE_COUNT = (1 << 16) * 2 + 1
ODD_TAIL = 0xA5


@dataclass(frozen=True)
class FormatCase:
    name: str
    enabled: int
    shifts: tuple[int, int, int]  # Original object offsets 0x38c0..0x38c2.
    channel_bits: tuple[int, int, int]  # Signed bytes at 0x38c8..0x38ca.


CASES: tuple[FormatCase, ...] = (
    FormatCase("rgb555", 1, (0, 5, 10), (5, 5, 5)),
    FormatCase("rgb565", 1, (0, 5, 11), (5, 6, 5)),
    FormatCase("disabled", 0, (255, 32, 223), (4, 6, 7)),
    # Red and green are both 5, so only this case doubles blue.
    FormatCase("blue_else_if", 1, (0, 5, 10), (4, 5, 5)),
    # Red is 5 and green is not 5, so this case doubles green.
    FormatCase("green_else_if", 1, (0, 5, 10), (4, 6, 5)),
    # Red is not 5, so the outer else doubles red regardless of other fields.
    FormatCase("red_else_if", 1, (31, 32, 255), (6, 4, 6)),
    # Keep the doubled red component visible in the packed RGB555 result.
    FormatCase("red_else_if_visible", 1, (0, 5, 10), (6, 4, 6)),
    # A nonzero all-bits-set flag is enabled; signed non-5 red also doubles.
    FormatCase("red_else_if_signed_enabled", 0xFFFFFFFF, (0, 5, 10), (-1, 5, -128)),
    # Shift counts are masked to five bits; the final result truncates to u16.
    FormatCase("shift_mask_and_truncation", 1, (255, 32, 223), (5, 5, 5)),
    # The byte values 0x80/0xff compare as signed negative values, not 5.
    FormatCase("signed_channel_bits", 1, (1, 33, 254), (-1, 5, -128)),
    # All channels overlap after shifting, so the original uses bitwise OR.
    FormatCase("overlapping_fields", 1, (0, 0, 0), (4, 6, 5)),
)


class PixelFormat(ctypes.Structure):
    _fields_ = [
        ("enabled", ctypes.c_uint32),
        ("shifts", ctypes.c_uint8 * 3),
        ("channel_bits", ctypes.c_int8 * 3),
    ]


def make_input() -> bytes:
    # Includes each possible 16-bit input exactly once and an odd trailing byte.
    return struct.pack("<65536H", *range(1 << 16)) + bytes((ODD_TAIL,))


class OriginalPixelOracle:
    def __init__(self, executable: Path):
        try:
            from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_PROT_ALL
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_ECX,
                UC_X86_REG_EDI,
                UC_X86_REG_EDX,
                UC_X86_REG_EIP,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_ESI,
                UC_X86_REG_ESP,
            )
        except ImportError as exc:
            raise RuntimeError(
                "Unicorn 2.x is required; use work/tools/oracle-python/bin/python"
            ) from exc

        data = executable.read_bytes()
        actual_hash = hashlib.sha256(data).hexdigest()
        if actual_hash != EXPECTED_EXE_SHA256:
            raise RuntimeError(
                f"GAME.EXE SHA-256 mismatch: {actual_hash} != {EXPECTED_EXE_SHA256}"
            )
        self.image = PEImage.parse_and_map(executable)
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.registers = {
            "eax": UC_X86_REG_EAX,
            "ebp": UC_X86_REG_EBP,
            "ecx": UC_X86_REG_ECX,
            "edi": UC_X86_REG_EDI,
            "edx": UC_X86_REG_EDX,
            "eip": UC_X86_REG_EIP,
            "eflags": UC_X86_REG_EFLAGS,
            "esi": UC_X86_REG_ESI,
            "esp": UC_X86_REG_ESP,
        }

        mapped_image_size = align_up(self.image.size_of_image, PAGE_SIZE)
        self.uc.mem_map(self.image.image_base, mapped_image_size, UC_PROT_ALL)
        self.uc.mem_write(self.image.image_base, self.image.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        self.uc.mem_map(THIS_ADDRESS, 0x4000, UC_PROT_ALL)
        self.uc.mem_map(PIXELS_ADDRESS, align_up(BYTE_COUNT, PAGE_SIZE), UC_PROT_ALL)
        self.uc.mem_map(SENTINEL_ADDRESS, PAGE_SIZE, UC_PROT_ALL)

        self.file_offset = self.image.va_to_file_offset(
            FUNCTION_VA, NEXT_FUNCTION_VA - FUNCTION_VA
        )

    def run(self, raw: bytes, fmt: FormatCase) -> bytes:
        if len(raw) != BYTE_COUNT:
            raise ValueError("oracle input must contain all uint16 words plus one byte")

        self.uc.mem_write(THIS_ADDRESS + 0x38A8, struct.pack("<I", fmt.enabled))
        self.uc.mem_write(THIS_ADDRESS + 0x38C0, bytes(fmt.shifts))
        self.uc.mem_write(
            THIS_ADDRESS + 0x38C8,
            bytes(value & 0xFF for value in fmt.channel_bits),
        )
        self.uc.mem_write(PIXELS_ADDRESS, raw)

        stack_pointer = STACK_BASE + STACK_SIZE - 0x20
        frame = struct.pack(
            "<III", SENTINEL_ADDRESS, PIXELS_ADDRESS, len(raw)
        )
        self.uc.mem_write(stack_pointer, frame)
        self.uc.reg_write(self.registers["eax"], 0)
        self.uc.reg_write(self.registers["ebp"], 0)
        self.uc.reg_write(self.registers["ecx"], THIS_ADDRESS)
        self.uc.reg_write(self.registers["edi"], 0)
        self.uc.reg_write(self.registers["edx"], 0)
        self.uc.reg_write(self.registers["eflags"], 0x202)
        self.uc.reg_write(self.registers["esi"], 0)
        self.uc.reg_write(self.registers["esp"], stack_pointer)

        self.uc.emu_start(
            FUNCTION_VA,
            SENTINEL_ADDRESS,
            timeout=30_000_000,
            count=10_000_000,
        )
        if self.uc.reg_read(self.registers["eip"]) != SENTINEL_ADDRESS:
            raise RuntimeError(f"oracle did not return for format {fmt.name}")
        return bytes(self.uc.mem_read(PIXELS_ADDRESS, len(raw)))


def bind_native(path: Path) -> ctypes.CDLL:
    if not path.is_file():
        raise RuntimeError(f"native pixel library does not exist: {path}")
    library = ctypes.CDLL(str(path))
    library.cif_pixels_convert_555.argtypes = [
        ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_uint32,
        ctypes.POINTER(PixelFormat),
    ]
    library.cif_pixels_convert_555.restype = None
    return library


def run_native(library: ctypes.CDLL, raw: bytes, fmt: FormatCase) -> bytes:
    storage_bytes = bytearray(raw)
    storage = (ctypes.c_uint8 * len(storage_bytes)).from_buffer(storage_bytes)
    pixel_format = PixelFormat()
    pixel_format.enabled = fmt.enabled
    pixel_format.shifts[:] = fmt.shifts
    pixel_format.channel_bits[:] = fmt.channel_bits
    library.cif_pixels_convert_555(
        storage, len(storage_bytes), ctypes.byref(pixel_format)
    )
    return bytes(storage_bytes)


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--exe", type=Path, default=ROOT / "work/original/GAME.EXE"
    )
    parser.add_argument(
        "--native-library",
        type=Path,
        default=ROOT / "outputs/blackmoor-decomp/build/libcifpixels.dylib",
    )
    parser.add_argument(
        "--report",
        type=Path,
        default=ROOT / "work/analysis/pixel-validation-report.json",
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    raw = make_input()
    oracle = OriginalPixelOracle(args.exe)
    native = bind_native(args.native_library)
    results: list[dict[str, object]] = []

    for fmt in CASES:
        expected = oracle.run(raw, fmt)
        actual = run_native(native, raw, fmt)
        matches = actual == expected
        result: dict[str, object] = {
            "name": fmt.name,
            "enabled": fmt.enabled,
            "shifts_bgr": list(fmt.shifts),
            "signed_channel_bits_bgr": list(fmt.channel_bits),
            "pixels": 1 << 16,
            "input_bytes": len(raw),
            "odd_tail_preserved": expected[-1] == ODD_TAIL,
            "original_sha256": hashlib.sha256(expected).hexdigest(),
            "native_sha256": hashlib.sha256(actual).hexdigest(),
            "byte_exact_match": matches,
        }
        results.append(result)
        print(
            f"{fmt.name}: {'MATCH' if matches else 'MISMATCH'}; "
            f"{result['pixels']} words, odd tail preserved={result['odd_tail_preserved']}"
        )
        if not matches:
            mismatch = next(i for i, pair in enumerate(zip(expected, actual)) if pair[0] != pair[1])
            result["first_mismatch_offset"] = mismatch
            result["first_mismatch_original"] = expected[mismatch]
            result["first_mismatch_native"] = actual[mismatch]

    report: dict[str, object] = {
        "original_sha256": EXPECTED_EXE_SHA256,
        "pe_image_base": f"0x{oracle.image.image_base:x}",
        "caller_type2_va": f"0x{CALLER_VA:x}",
        "transform_va": f"0x{FUNCTION_VA:x}",
        "function_pseudocode_evidence_id": "ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e",
        "next_function_va": f"0x{NEXT_FUNCTION_VA:x}",
        "file_offset": f"0x{oracle.file_offset:x}",
        "function_range_bytes": NEXT_FUNCTION_VA - FUNCTION_VA,
        "input_domain": "all 65536 little-endian uint16 values plus trailing 0xa5",
        "case_count": len(CASES),
        "compared_words_total": len(CASES) * (1 << 16),
        "cases": results,
        "all_cases_match": all(bool(item["byte_exact_match"]) for item in results),
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"Report: {args.report}")
    return 0 if report["all_cases_match"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
