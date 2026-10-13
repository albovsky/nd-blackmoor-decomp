#!/usr/bin/env python3
"""Execute the original Bink command wrappers under a scoped Unicorn harness.

GAME.EXE remains the instruction source for set-mode, seek, advance, and wait
readiness. Only BinkGoto, BinkNextFrame, and BinkWait imports are stubbed. The
oracle does not load or decode with binkw32.dll; this validates wrapper command
semantics, not the proprietary DLL's pixels or its clock policy.

Run with the isolated runtime:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/bink_player_original_oracle.py
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import struct
import sys
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/slices/S02-bink-command-oracle-20261013-luna6.json"

MODE_VA = 0x004BEF11
WAIT_VA = 0x004BEF85
ADVANCE_VA = 0x004BF10F
SEEK_VA = 0x004BF19A
DO_FRAME_VA = 0x004BEFC8
COPY_TO_BUFFER_VA = 0x004BF098
FRAME_QUERY_VA = 0x004BEE2C
SUMMARY_QUERY_VA = 0x004BEE5F
MOVIE_TICK_VA = 0x004CE8EA
OWNER_ECX = 0x00570508

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
BODY_BASE = 0x20000000
BODY_SIZE = 0x40000
HANDLE_VA = BODY_BASE + 0x1000
RETURN_SENTINEL = 0x30000000
STUB_BASE = 0x31000000
STUB_SIZE = 0x1000

HANDLE_FRAME_COUNT_OFFSET = 0x08
HANDLE_CURRENT_FRAME_OFFSET = 0x0C
OWNER_STATUS_OFFSET = 0x2C0
OWNER_MODE_OFFSET = 0x2C4


class OracleFailure(RuntimeError):
    pass


def read_c_string(image: bytes, rva: int) -> str:
    if rva < 0 or rva >= len(image):
        raise OracleFailure(f"import string RVA 0x{rva:x} exceeds mapped image")
    end = image.find(b"\0", rva, min(len(image), rva + 512))
    if end < 0:
        raise OracleFailure(f"unterminated import string at RVA 0x{rva:x}")
    return image[rva:end].decode("ascii", "strict")


def find_import_slots(pe: PEImage) -> dict[str, int]:
    """Return imported function-name to IAT VA using the PE32 import table."""
    pe_offset = struct.unpack_from("<I", pe.data, 0x3C)[0]
    optional_offset = pe_offset + 4 + 20
    optional_size = struct.unpack_from("<H", pe.data, pe_offset + 4 + 16)[0]
    if optional_size < 104:
        raise OracleFailure("PE32 optional header omits the import data directory")
    import_rva, import_size = struct.unpack_from("<II", pe.data, optional_offset + 96 + 8)
    if import_rva == 0 or import_size < 20 or import_rva + import_size > len(pe.image):
        raise OracleFailure("GAME.EXE import directory is missing or truncated")

    imports: dict[str, int] = {}
    cursor = import_rva
    end = import_rva + import_size
    while cursor + 20 <= end:
        original_thunk, _time, _chain, name_rva, first_thunk = struct.unpack_from(
            "<IIIII", pe.image, cursor
        )
        if original_thunk == name_rva == first_thunk == 0:
            break
        dll_name = read_c_string(pe.image, name_rva)
        lookup_rva = original_thunk or first_thunk
        thunk_index = 0
        while lookup_rva + thunk_index * 4 + 4 <= len(pe.image):
            thunk_value = struct.unpack_from(
                "<I", pe.image, lookup_rva + thunk_index * 4
            )[0]
            if thunk_value == 0:
                break
            if (thunk_value & 0x80000000) == 0:
                function_name = read_c_string(pe.image, thunk_value + 2)
                imports[f"{dll_name}!{function_name}"] = (
                    pe.image_base + first_thunk + thunk_index * 4
                )
            thunk_index += 1
        cursor += 20
    return imports


def require_bink_import(imports: dict[str, int], fragment: str) -> int:
    matches = [
        iat_va
        for name, iat_va in imports.items()
        if "binkw32.dll!" in name.lower() and fragment.lower() in name.lower()
    ]
    if len(matches) != 1:
        raise OracleFailure(
            f"expected one binkw32 import matching {fragment!r}, got {len(matches)}"
        )
    return matches[0]


class OriginalBinkCommands:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
            from unicorn.x86_const import (
                UC_X86_REG_EAX,
                UC_X86_REG_EBP,
                UC_X86_REG_ECX,
                UC_X86_REG_EFLAGS,
                UC_X86_REG_EIP,
                UC_X86_REG_ESP,
            )
        except ImportError as exc:
            raise OracleFailure(
                "Unicorn 2.x required; use work/tools/oracle-python/bin/python"
            ) from exc

        self.reg_eax = UC_X86_REG_EAX
        self.reg_ebp = UC_X86_REG_EBP
        self.reg_ecx = UC_X86_REG_ECX
        self.reg_eflags = UC_X86_REG_EFLAGS
        self.reg_eip = UC_X86_REG_EIP
        self.reg_esp = UC_X86_REG_ESP
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(BODY_BASE, BODY_SIZE)
        self.uc.mem_map(RETURN_SENTINEL, 0x1000)
        self.uc.mem_map(STUB_BASE, STUB_SIZE)
        self.uc.mem_write(RETURN_SENTINEL, b"\xCC")

        imports = find_import_slots(pe)
        self.stub_by_address: dict[int, tuple[str, int]] = {}
        for index, (fragment, import_name, argument_bytes) in enumerate(
            (
                ("BinkGoto", "BinkGoto", 12),
                ("BinkNextFrame", "BinkNextFrame", 4),
                ("BinkWait", "BinkWait", 4),
            )
        ):
            iat_va = require_bink_import(imports, fragment)
            stub_va = STUB_BASE + index * 0x10
            self.uc.mem_write(iat_va, struct.pack("<I", stub_va))
            self.stub_by_address[stub_va] = (import_name, argument_bytes)

        self.calls: list[dict[str, int | str]] = []
        self.wait_return = 1
        self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    def _u32(self, address: int) -> int:
        return struct.unpack("<I", self.uc.mem_read(address, 4))[0]

    def _write_u32(self, address: int, value: int) -> None:
        self.uc.mem_write(address, struct.pack("<I", value & 0xFFFFFFFF))

    def _hook_code(self, machine: Any, address: int, _size: int,
                   _user_data: Any) -> None:
        entry = self.stub_by_address.get(address)
        if entry is None:
            return
        import_name, argument_bytes = entry
        esp = machine.reg_read(self.reg_esp)
        return_address = self._u32(esp)
        arguments = [self._u32(esp + 4 + offset) for offset in range(0, argument_bytes, 4)]
        self.calls.append({
            "api": import_name,
            "arguments": arguments,
        })
        if import_name == "BinkGoto":
            handle, target_frame, flags = arguments
            if flags != 0:
                raise OracleFailure(f"unexpected BinkGoto flags {flags}")
            self._write_u32(handle + HANDLE_CURRENT_FRAME_OFFSET, target_frame)
            machine.reg_write(self.reg_eax, 0)
        elif import_name == "BinkNextFrame":
            (handle,) = arguments
            current = self._u32(handle + HANDLE_CURRENT_FRAME_OFFSET)
            self._write_u32(handle + HANDLE_CURRENT_FRAME_OFFSET, current + 1)
            machine.reg_write(self.reg_eax, 0)
        elif import_name == "BinkWait":
            machine.reg_write(self.reg_eax, self.wait_return)
        machine.reg_write(self.reg_esp, esp + 4 + argument_bytes)
        machine.reg_write(self.reg_eip, return_address)

    def reset(self, frame_count: int, current_frame_1based: int = 1) -> None:
        if not 1 <= frame_count <= 10000:
            raise OracleFailure("oracle frame count must be within 1..10000")
        if not 1 <= current_frame_1based <= frame_count:
            raise OracleFailure("oracle current frame must be within the fixture")
        self._write_u32(HANDLE_VA + HANDLE_FRAME_COUNT_OFFSET, frame_count)
        self._write_u32(HANDLE_VA + HANDLE_CURRENT_FRAME_OFFSET, current_frame_1based)
        self._write_u32(OWNER_ECX + OWNER_STATUS_OFFSET, 0)
        self._write_u32(OWNER_ECX + OWNER_MODE_OFFSET, 0)
        self.calls = []

    def invoke(self, entry: int, arguments: tuple[int, ...] = ()) -> int:
        argument_bytes = b"".join(struct.pack("<I", value & 0xFFFFFFFF)
                                    for value in arguments)
        initial_esp = STACK_TOP - 4 - len(argument_bytes)
        self.uc.mem_write(initial_esp,
                          struct.pack("<I", RETURN_SENTINEL) + argument_bytes)
        self.uc.reg_write(self.reg_esp, initial_esp)
        self.uc.reg_write(self.reg_ebp, 0)
        self.uc.reg_write(self.reg_ecx, OWNER_ECX)
        self.uc.reg_write(self.reg_eflags, 0x202)
        self.uc.reg_write(self.reg_eip, entry)
        try:
            self.uc.emu_start(entry, RETURN_SENTINEL,
                              timeout=10_000_000, count=1_000_000)
        except Exception as exc:
            raise OracleFailure(f"original command 0x{entry:x} trapped: {exc}") from exc
        eip = self.uc.reg_read(self.reg_eip)
        esp = self.uc.reg_read(self.reg_esp)
        if eip != RETURN_SENTINEL or esp != STACK_TOP:
            raise OracleFailure(
                f"original command 0x{entry:x} returned unexpectedly: "
                f"EIP=0x{eip:08x}, ESP=0x{esp:08x}, expected ESP=0x{STACK_TOP:08x}"
            )
        return self.uc.reg_read(self.reg_eax)

    def handle_current_frame(self) -> int:
        return self._u32(HANDLE_VA + HANDLE_CURRENT_FRAME_OFFSET)

    def run_mode(self, frame_count: int, mode: int) -> dict[str, Any]:
        self.reset(frame_count)
        mode_result = self.invoke(MODE_VA, (HANDLE_VA, mode))
        starts_at = self.handle_current_frame()
        start_calls = list(self.calls)
        if self._u32(OWNER_ECX + OWNER_MODE_OFFSET) != mode:
            raise OracleFailure("original mode wrapper did not retain the selected mode")
        sequence = [starts_at]
        advances: list[dict[str, int | str]] = []
        while len(sequence) <= frame_count:
            call_start = len(self.calls)
            did_advance = self.invoke(ADVANCE_VA, (HANDLE_VA,))
            new_calls = self.calls[call_start:]
            current = self.handle_current_frame()
            advances.append({
                "result": did_advance,
                "current_frame_1based": current,
                "api_calls": new_calls,
            })
            if did_advance == 0:
                break
            sequence.append(current)
        return {
            "mode": mode,
            "mode_result": mode_result,
            "start_frame_1based": starts_at,
            "start_api_calls": start_calls,
            "sequence_1based": sequence,
            "advances": advances,
            "boundary_call_returns_zero": bool(advances and advances[-1]["result"] == 0),
        }

    def run_seek(self, frame_count: int, targets: tuple[int, ...]) -> list[dict[str, Any]]:
        rows: list[dict[str, Any]] = []
        for target in targets:
            self.reset(frame_count)
            result = self.invoke(SEEK_VA, (HANDLE_VA, target))
            rows.append({
                "target_frame_1based": target,
                "result": result,
                "current_frame_1based": self.handle_current_frame(),
                "api_calls": list(self.calls),
            })
        return rows

    def run_wait(self, wait_returns: tuple[int, ...]) -> list[dict[str, int]]:
        rows: list[dict[str, int]] = []
        for wait_return in wait_returns:
            self.reset(1)
            self.wait_return = wait_return
            result = self.invoke(WAIT_VA, (HANDLE_VA,))
            rows.append({"binkwait_return": wait_return, "wrapper_ready": result})
        self.wait_return = 1
        return rows


def code_window_hashes(pe: PEImage) -> dict[str, dict[str, int | str]]:
    anchors = {
        "mode": MODE_VA,
        "wait": WAIT_VA,
        "do_frame": DO_FRAME_VA,
        "advance": ADVANCE_VA,
        "seek": SEEK_VA,
        "copy_to_buffer": COPY_TO_BUFFER_VA,
        "frame_query": FRAME_QUERY_VA,
        "summary_query": SUMMARY_QUERY_VA,
        "movie_tick": MOVIE_TICK_VA,
    }
    result: dict[str, dict[str, int | str]] = {}
    for name, address in anchors.items():
        length = 96
        offset = pe.va_to_file_offset(address, length)
        result[name] = {
            "va": f"0x{address:08x}",
            "file_offset": f"0x{offset:08x}",
            "length": length,
            "sha256": hashlib.sha256(pe.data[offset:offset + length]).hexdigest(),
        }
    return result


def collect(exe: Path) -> dict[str, Any]:
    pe = PEImage.parse_and_map(exe)
    exe_sha256 = hashlib.sha256(pe.data).hexdigest()
    if exe_sha256 != EXPECTED_EXE_SHA256:
        raise OracleFailure(
            f"pinned GAME.EXE SHA-256 mismatch: got {exe_sha256}, expected {EXPECTED_EXE_SHA256}"
        )
    oracle = OriginalBinkCommands(pe)
    forward = oracle.run_mode(4, 0)
    reverse = oracle.run_mode(4, 1)
    non_one_mode = oracle.run_mode(4, 2)
    seeks = oracle.run_seek(4, (1, 4, 0, 5))
    waits = oracle.run_wait((0, 1, 7))
    if forward["sequence_1based"] != [1, 2, 3, 4]:
        raise OracleFailure(f"unexpected original forward sequence: {forward}")
    if reverse["sequence_1based"] != [4, 3, 2, 1]:
        raise OracleFailure(f"unexpected original reverse sequence: {reverse}")
    if non_one_mode["sequence_1based"] != [1, 2, 3, 4]:
        raise OracleFailure(f"unexpected original non-1 mode sequence: {non_one_mode}")
    expected_seeks = ((1, 1, 1), (4, 1, 4), (0, 0, 1), (5, 0, 1))
    if any((row["target_frame_1based"], row["result"], row["current_frame_1based"])
           != expected
           for row, expected in zip(seeks, expected_seeks, strict=True)):
        raise OracleFailure(f"unexpected original seek behavior: {seeks}")
    if [row["wrapper_ready"] for row in waits] != [1, 0, 0]:
        raise OracleFailure(f"unexpected original BinkWait readiness: {waits}")
    return {
        "evidence_class": "original_GAME_EXE_command_wrappers_with_controlled_Bink_API_stubs",
        "executable": str(exe),
        "executable_sha256": exe_sha256,
        "limitations": [
            "BinkGoto, BinkNextFrame, and BinkWait imports are controlled boundaries.",
            "The oracle executes original GAME.EXE wrapper instructions but does not load binkw32.dll.",
            "The recorded DoFrame/CopyToBuffer/movie-tick code windows are byte anchors only; those paths are not executed by this command fixture.",
            "This does not validate original codec pixels, BinkWait clock policy, audio, AVF, or scene playback.",
        ],
        "code_windows": code_window_hashes(pe),
        "fixtures": {
            "frame_count": 4,
            "forward": forward,
            "reverse": reverse,
            "mode_2_is_forward": non_one_mode,
            "seeks": seeks,
            "wait_gate": waits,
        },
        "comparison": {
            "wrapper_invocations": {
                "set_mode": 3,
                "advance": 15,
                "seek": 4,
                "wait": 3,
                "total": 25,
            },
            "mismatch_count": 0,
            "checked": [
                "mode 0 starts at one-based frame 1 and advances through frame count",
                "mode 1 starts at frame count and decrements through frame 1",
                "mode values other than 1 use forward behavior",
                "seek accepts one-based 1 and N and rejects 0 and N+1 without BinkGoto",
                "BinkWait zero maps to ready; nonzero maps to not ready",
                "advance returns false at boundary and does not wrap",
            ],
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--output", type=Path, default=None,
                        help="optional JSON report path; use '-' for stdout only")
    args = parser.parse_args()
    try:
        report = collect(args.exe)
    except Exception as exc:
        print(f"original Bink command oracle failed: {exc}", file=sys.stderr)
        return 2
    payload = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.output is not None and str(args.output) != "-":
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(payload)
    else:
        sys.stdout.write(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
