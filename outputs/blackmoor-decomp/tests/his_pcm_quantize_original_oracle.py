#!/usr/bin/env python3
"""Compare the isolated native HIS quantizer with GAME.EXE machine code.

The original converter is entered at 0x4fe2d0.  Only the planar-queue reader
(0x4ff9a0), channel metadata lookup (0x4fe290), and queue-consume routine
(0x4ffa00) are stubbed.  The conversion loops, x87 FISTP operations, clamps,
and interleave writes execute from the hash-verified GAME.EXE image.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import struct
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

from cif_original_oracle import (
    DEFAULT_EXE,
    EXPECTED_EXE_SHA256,
    PAGE_SIZE,
    PEImage,
    STACK_BASE,
    STACK_SIZE,
    align_up,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_LIBRARY = PROJECT / "build/libhis_pcm_quantize.dylib"
CONVERTER_START = 0x4FE2D0
CONVERTER_STOP = 0x4FE62E
PLANAR_READ_VA = 0x4FF9A0
CHANNEL_INFO_VA = 0x4FE290
PLANAR_CONSUME_VA = 0x4FFA00
X87_CONTROL_WORD = 0x037F  # all exceptions masked, round-to-nearest-even

DATA_BASE = 0x20000000
OBJECT_VA = DATA_BASE
CHANNEL_INFO_DATA_VA = DATA_BASE + 0x1000
PLANE_POINTERS_VA = DATA_BASE + 0x2000
PLANE_DATA_VA = DATA_BASE + 0x4000
OUTPUT_VA = DATA_BASE + 0x10000
SENTINEL_VA = 0x51000000


class OracleError(RuntimeError):
    """Failure in the bounded original-machine-code oracle."""


@dataclass(frozen=True)
class OracleOutput:
    return_bytes: int
    frames_written: int
    output: bytes


class OriginalHisConverter:
    def __init__(self, exe_path: Path = DEFAULT_EXE) -> None:
        try:
            from unicorn import Uc, UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_EBX,
                UC_X86_REG_ECX,
                UC_X86_REG_EDI,
                UC_X86_REG_EDX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESP,
                UC_X86_REG_ESI,
                UC_X86_REG_FPCW,
            )
        except ImportError as exc:
            raise OracleError(
                "Unicorn 2.x is required; run with work/tools/oracle-python/bin/python"
            ) from exc

        self._reg = {
            "eax": UC_X86_REG_EAX,
            "ebp": UC_X86_REG_EBP,
            "ebx": UC_X86_REG_EBX,
            "ecx": UC_X86_REG_ECX,
            "edi": UC_X86_REG_EDI,
            "edx": UC_X86_REG_EDX,
            "eflags": UC_X86_REG_EFLAGS,
            "eip": UC_X86_REG_EIP,
            "esp": UC_X86_REG_ESP,
            "esi": UC_X86_REG_ESI,
            "fpcw": UC_X86_REG_FPCW,
        }
        self.pe = PEImage.parse_and_map(exe_path.resolve())
        digest = hashlib.sha256(self.pe.data).hexdigest()
        if digest != EXPECTED_EXE_SHA256:
            raise OracleError(f"GAME.EXE SHA-256 mismatch: {digest}")
        self.exe_sha256 = digest
        self.converter_file_offset = self.pe.va_to_file_offset(
            CONVERTER_START, CONVERTER_STOP - CONVERTER_START
        )
        self.converter_bytes = self.pe.data[
            self.converter_file_offset : self.converter_file_offset + CONVERTER_STOP - CONVERTER_START
        ]

        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(
            self.pe.image_base & ~(PAGE_SIZE - 1),
            align_up(self.pe.image_base + self.pe.size_of_image)
            - (self.pe.image_base & ~(PAGE_SIZE - 1)),
            UC_PROT_ALL,
        )
        self.uc.mem_write(self.pe.image_base, self.pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        self.uc.mem_map(DATA_BASE, 0x20000, UC_PROT_ALL)
        self.uc.mem_map(SENTINEL_VA, PAGE_SIZE, UC_PROT_ALL)

        def return_from_stub(uc, result: int | None = None) -> None:
            esp = uc.reg_read(self._reg["esp"])
            return_address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
            if result is not None:
                uc.reg_write(self._reg["eax"], result & 0xFFFFFFFF)
            uc.reg_write(self._reg["esp"], esp + 4)
            uc.reg_write(self._reg["eip"], return_address)

        def planar_read(uc, _address, _size, _user_data) -> None:
            esp = uc.reg_read(self._reg["esp"])
            frame_pointer = struct.unpack("<I", uc.mem_read(esp + 8, 4))[0]
            uc.mem_write(frame_pointer, struct.pack("<I", PLANE_POINTERS_VA))
            return_from_stub(uc, self._frame_count)

        def channel_info(uc, _address, _size, _user_data) -> None:
            return_from_stub(uc, CHANNEL_INFO_DATA_VA)

        def planar_consume(uc, _address, _size, _user_data) -> None:
            return_from_stub(uc)

        self.uc.hook_add(UC_HOOK_CODE, planar_read, begin=PLANAR_READ_VA, end=PLANAR_READ_VA)
        self.uc.hook_add(UC_HOOK_CODE, channel_info, begin=CHANNEL_INFO_VA, end=CHANNEL_INFO_VA)
        self.uc.hook_add(UC_HOOK_CODE, planar_consume, begin=PLANAR_CONSUME_VA, end=PLANAR_CONSUME_VA)

    def convert(
        self,
        planes: Sequence[Sequence[float]],
        bits_per_sample: int,
        output_capacity: int | None = None,
    ) -> OracleOutput:
        channels = len(planes)
        if channels not in (1, 2):
            raise ValueError("oracle fixtures require mono or stereo")
        frame_count = len(planes[0])
        if frame_count < 1 or any(len(plane) != frame_count for plane in planes):
            raise ValueError("oracle fixtures must have equally-sized nonempty planes")
        if bits_per_sample not in (8, 16):
            raise ValueError("the original HIS path is tested at 8 or 16 bits")
        bytes_per_sample = bits_per_sample // 8
        full_capacity = frame_count * channels * bytes_per_sample
        if output_capacity is None:
            output_capacity = full_capacity
        if not 1 <= output_capacity <= 0x7FFFFFFF:
            raise ValueError("oracle output capacity must fit a positive signed int")

        self._frame_count = frame_count
        self.uc.mem_write(OBJECT_VA + 0x58, struct.pack("<I", 3))
        self.uc.mem_write(OBJECT_VA + 0x50, bytes(8))
        self.uc.mem_write(CHANNEL_INFO_DATA_VA + 4, struct.pack("<I", channels))
        plane_addresses = []
        for channel, samples in enumerate(planes):
            plane_address = PLANE_DATA_VA + channel * align_up(frame_count * 4)
            plane_addresses.append(plane_address)
            encoded = struct.pack(f"<{frame_count}f", *samples)
            self.uc.mem_write(plane_address, encoded)
        self.uc.mem_write(
            PLANE_POINTERS_VA,
            struct.pack(f"<{channels}I", *plane_addresses),
        )
        self.uc.mem_write(OUTPUT_VA, bytes(output_capacity))

        esp = STACK_BASE + STACK_SIZE - 0x100
        signed_flag = 1 if bits_per_sample == 16 else 0
        args = (
            SENTINEL_VA,
            OBJECT_VA,
            OUTPUT_VA,
            output_capacity,
            0,  # production param4: native-endian layout branch
            bytes_per_sample,
            signed_flag,
            0,  # optional status output pointer
        )
        self.uc.mem_write(esp, struct.pack("<8I", *args))
        for name in ("eax", "ebx", "ecx", "edx", "esi", "edi", "ebp"):
            self.uc.reg_write(self._reg[name], 0)
        self.uc.reg_write(self._reg["esp"], esp)
        self.uc.reg_write(self._reg["eip"], CONVERTER_START)
        self.uc.reg_write(self._reg["eflags"], 0x202)
        self.uc.reg_write(self._reg["fpcw"], X87_CONTROL_WORD)
        try:
            self.uc.emu_start(CONVERTER_START, SENTINEL_VA, timeout=2_000_000, count=4_000_000)
        except Exception as exc:
            raise OracleError(f"GAME.EXE converter emulation failed: {exc}") from exc
        if self.uc.reg_read(self._reg["eip"]) != SENTINEL_VA:
            raise OracleError(
                f"converter stopped at EIP 0x{self.uc.reg_read(self._reg['eip']):08x}"
            )
        return_bytes = self.uc.reg_read(self._reg["eax"])
        bytes_per_frame = channels * bytes_per_sample
        frames_written = min(frame_count, output_capacity // bytes_per_frame)
        expected_bytes = frames_written * bytes_per_frame
        if return_bytes != expected_bytes:
            raise OracleError(f"original returned {return_bytes} bytes; expected {expected_bytes}")
        output = bytes(self.uc.mem_read(OUTPUT_VA, expected_bytes))
        return OracleOutput(return_bytes, frames_written, output)


def native_convert(library_path: Path, planes: Sequence[Sequence[float]], bits: int,
                   capacity: int | None = None) -> OracleOutput:
    library = ctypes.CDLL(str(library_path))
    library.his_pcm_quantize_planar.argtypes = [
        ctypes.POINTER(ctypes.POINTER(ctypes.c_float)), ctypes.c_uint32,
        ctypes.c_uint64, ctypes.c_uint32, ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint64),
    ]
    library.his_pcm_quantize_planar.restype = ctypes.c_int
    channels = len(planes)
    frame_count = len(planes[0])
    arrays = [(ctypes.c_float * frame_count)(*plane) for plane in planes]
    pointers = (ctypes.POINTER(ctypes.c_float) * channels)(
        *(ctypes.cast(array, ctypes.POINTER(ctypes.c_float)) for array in arrays)
    )
    full_capacity = frame_count * channels * (bits // 8)
    capacity = full_capacity if capacity is None else capacity
    output = (ctypes.c_uint8 * max(capacity, 1))()
    frames_written = ctypes.c_uint64()
    status = library.his_pcm_quantize_planar(
        pointers, channels, frame_count, bits, output, capacity,
        ctypes.byref(frames_written),
    )
    if status not in (0, 2):
        raise OracleError(f"native quantizer returned unexpected status {status}")
    byte_count = frames_written.value * channels * (bits // 8)
    return OracleOutput(byte_count, frames_written.value, bytes(output[:byte_count]))


def test_vectors() -> list[tuple[str, list[list[float]], int, int | None]]:
    # Every value is serialized to the same binary32 representation used by
    # the original FPU loads and the native implementation's float interface.
    positive_ties = [(index + 0.5) / 128.0 for index in (0, 1, 2)]
    negative_ties = [-(index + 0.5) / 128.0 for index in (0, 1, 2)]
    ties16_pos = [(index + 0.5) / 32768.0 for index in (0, 1, 2)]
    ties16_neg = [-(index + 0.5) / 32768.0 for index in (0, 1, 2)]
    representative = [
        -float("inf"), -65536.0, -2.0, -1.0, -0.75, -0.5, -0.25,
        -0.0, 0.0, 0.25, 0.5, 0.75, 1.0, 2.0, 65536.0,
        float("inf"), float("nan"),
    ]
    return [
        ("8-bit-stereo-extrema-specials", [representative, list(reversed(representative))], 8, None),
        ("16-bit-stereo-extrema-specials", [representative, list(reversed(representative))], 16, None),
        ("8-bit-nearest-even-ties", [positive_ties + negative_ties], 8, None),
        ("16-bit-nearest-even-ties", [ties16_pos + ties16_neg], 16, None),
        ("8-bit-int32-conversion-boundary",
         [[16777215.0, 16777216.0, -16777215.0, -16777216.0]], 8, None),
        ("16-bit-int32-conversion-boundary",
         [[65535.99609375, 65536.0, -65535.99609375, -65536.0]], 16, None),
        ("16-bit-stereo-whole-frame-capacity", [[-1.0, 0.0, 1.0], [1.0, 0.0, -1.0]], 16, 5),
        ("8-bit-mono-whole-frame-capacity", [[-1.0, 0.0, 1.0]], 8, 2),
    ]


def run(library_path: Path, exe_path: Path = DEFAULT_EXE) -> dict[str, object]:
    library_path = library_path.resolve()
    if not library_path.is_file():
        subprocess.run([str(PROJECT / "scripts/build_his_pcm_quantize.sh")], check=True)
    oracle = OriginalHisConverter(exe_path)
    cases = []
    for label, planes, bits, capacity in test_vectors():
        original = oracle.convert(planes, bits, capacity)
        native = native_convert(library_path, planes, bits, capacity)
        if original != native:
            raise AssertionError(
                f"{label} mismatch: original={original!r}; native={native!r}"
            )
        cases.append({
            "case": label,
            "bits_per_sample": bits,
            "channels": len(planes),
            "frames_input": len(planes[0]),
            "frames_written": original.frames_written,
            "output_bytes": original.return_bytes,
            "output_sha256": hashlib.sha256(original.output).hexdigest(),
            "byte_match": True,
        })
    return {
        "exe_sha256": oracle.exe_sha256,
        "converter_va": f"0x{CONVERTER_START:08x}",
        "converter_file_offset": oracle.converter_file_offset,
        "converter_byte_length": len(oracle.converter_bytes),
        "converter_code_sha256": hashlib.sha256(oracle.converter_bytes).hexdigest(),
        "native_library": str(library_path),
        "native_library_sha256": hashlib.sha256(library_path.read_bytes()).hexdigest(),
        "x87_control_word": f"0x{X87_CONTROL_WORD:04x}",
        "stubbed_external_boundaries": [
            f"0x{PLANAR_READ_VA:08x}", f"0x{CHANNEL_INFO_VA:08x}",
            f"0x{PLANAR_CONSUME_VA:08x}",
        ],
        "case_count": len(cases),
        "cases": cases,
        "scope": "float-to-PCM machine-code comparison only; no HIS/Ogg decoder parity claim",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--library", type=Path, default=DEFAULT_LIBRARY)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--json", type=Path, help="write compact JSON evidence here")
    args = parser.parse_args()
    evidence = run(args.library, args.exe)
    rendered = json.dumps(evidence, indent=2, sort_keys=True)
    print(rendered)
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(rendered + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
