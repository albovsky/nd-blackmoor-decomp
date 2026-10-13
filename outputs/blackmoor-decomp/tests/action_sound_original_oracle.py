#!/usr/bin/env python3
"""Compare the portable 0x9f kernel with the original 32-bit phase handler.

The harness maps the SHA-256-verified GAME.EXE into Unicorn and executes the
original 0x410f99 runtime-field copier and 0x432d1a sound-action handler. It
intercepts only resource/file lookup, caption presentation, HIS decode/load,
and DirectSound COM entry points. All phase transitions, command unpacking,
attenuation conversion, completion, and unload dispatch run in the original
machine code. The fixture supplies an already-decoded buffer at the HIS load
boundary, so this does not validate the original HIS decoder.

Run from the workspace root with the isolated Unicorn interpreter:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/action_sound_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import sys
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up, sha256
from test_action_sound import (
    Action,
    Backend,
    Recorder,
    Result,
    BACKEND_NO_RESOURCE,
    BACKEND_OK,
    OK,
    sound_body,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/action-sound-validation.json"

RUNTIME_LOADER_VA = 0x410F99
SOUND_ACTION_VA = 0x432D1A
FILE_EXISTS_VA = 0x449D90
CAPTION_UI_VA = 0x448D11
HIS_LOAD_VA = 0x4F379C

CSOUND_VA = 0x5C3A67
CDIRECTSOUND_VA = 0x5CF1EB
CAPTION_ENABLED_VA = 0x5BB202
ACTION_TYPE_BASE_VA = 0x5BB5E3
ACTION_DATA_BASE_VA = 0x5BB5E5
ACTION_DONE_BASE_VA = 0x5BB625
ACTION_PHASE_BASE_VA = 0x5BB632
DEBUG_VA = 0x63A4CD
ACTION_STRIDE = 0x8D
SOUND_CHANNEL_STRIDE = 0x5BB

STACK_BASE = 0x1000
STACK_SIZE = 0x20000
DATA_BASE = 0x20000000
DATA_SIZE = 0x20000
STUB_BASE = 0x30000000
STUB_SIZE = 0x10000
RETURN_SENTINEL = STUB_BASE
GET_STATUS_STUB = STUB_BASE + 0x1000
PLAY_STUB = STUB_BASE + 0x1010
RELEASE_STUB = STUB_BASE + 0x1020
STOP_STUB = STUB_BASE + 0x1030
POSITION_STUB = STUB_BASE + 0x1040
BUFFER_VA = DATA_BASE + 0x8000
VTABLE_VA = DATA_BASE + 0x9000
BODY_VA = DATA_BASE + 0x1000
RUNTIME_VA = DATA_BASE + 0x2000

FALLBACK_VA = 0x543310
END_MARKER_VA = 0x540A08


class OracleFailure(RuntimeError):
    pass


def read_u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def read_c_string(machine: Any, address: int, capacity: int = 4096) -> bytes:
    result = bytearray()
    for offset in range(capacity):
        value = machine.mem_read(address + offset, 1)[0]
        if value == 0:
            return bytes(result)
        result.append(value)
    raise OracleFailure(f"unterminated string at 0x{address:08x}")


class OriginalSoundOracle:
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

        self._eax = UC_X86_REG_EAX
        self._ebp = UC_X86_REG_EBP
        self._ecx = UC_X86_REG_ECX
        self._eflags = UC_X86_REG_EFLAGS
        self._eip = UC_X86_REG_EIP
        self._esp = UC_X86_REG_ESP
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(DATA_BASE, DATA_SIZE)
        self.uc.mem_map(STUB_BASE, STUB_SIZE)
        self.uc.mem_write(RETURN_SENTINEL, b"\xcc")

        self.currently_playing = False
        self.trace: dict[str, Any] = {
            "file_paths": [],
            "captions": [],
            "loads": [],
            "play_flags": [],
            "queries": [],
            "releases": 0,
            "stops": 0,
        }

        vtable = bytearray(0x54)
        struct.pack_into("<I", vtable, 0x08, RELEASE_STUB)
        struct.pack_into("<I", vtable, 0x24, GET_STATUS_STUB)
        struct.pack_into("<I", vtable, 0x30, PLAY_STUB)
        struct.pack_into("<I", vtable, 0x48, STOP_STUB)
        struct.pack_into("<I", vtable, 0x50, POSITION_STUB)
        self.uc.mem_write(VTABLE_VA, bytes(vtable))
        self.uc.mem_write(BUFFER_VA, struct.pack("<I", VTABLE_VA))
        self.uc.mem_write(STUB_BASE + 1, b"\x00")
        self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    def _return_from_hook(self, pop_bytes: int) -> None:
        esp = self.uc.reg_read(self._esp)
        return_address = read_u32(self.uc, esp)
        self.uc.reg_write(self._esp, esp + 4 + pop_bytes)
        self.uc.reg_write(self._eip, return_address)

    def _hook_code(self, machine: Any, address: int, _size: int, _user: Any) -> None:
        if address == FILE_EXISTS_VA:
            path_pointer = read_u32(machine, machine.reg_read(self._esp) + 4)
            self.trace["file_paths"].append(read_c_string(machine, path_pointer))
            machine.reg_write(self._eax, 1)
            self._return_from_hook(4)
            return

        if address == CAPTION_UI_VA:
            esp = machine.reg_read(self._esp)
            text_pointer = read_u32(machine, esp + 8)
            self.trace["captions"].append(read_c_string(machine, text_pointer))
            machine.reg_write(self._eax, 1)
            self._return_from_hook(16)
            return

        if address == HIS_LOAD_VA:
            esp = machine.reg_read(self._esp)
            channel = read_u32(machine, esp + 4) & 0xFFFF
            slot_base = read_u32(machine, CDIRECTSOUND_VA + 0x3CE)
            slot = slot_base + channel * SOUND_CHANNEL_STRIDE
            self.trace["loads"].append({
                "channel": channel,
                "path": read_c_string(machine, slot + 4),
                "first_gain": struct.unpack(
                    "<f", machine.mem_read(CSOUND_VA + 0x138 + channel * SOUND_CHANNEL_STRIDE, 4)
                )[0],
                "second_gain": struct.unpack(
                    "<f", machine.mem_read(CSOUND_VA + 0x13C + channel * SOUND_CHANNEL_STRIDE, 4)
                )[0],
                "volume_category": struct.unpack(
                    "<H", machine.mem_read(CSOUND_VA + 0x10C + channel * SOUND_CHANNEL_STRIDE, 2)
                )[0],
                "control_word": read_u32(
                    machine, CSOUND_VA + 0x134 + channel * SOUND_CHANNEL_STRIDE
                ),
                "first_attenuation": struct.unpack(
                    "<i", machine.mem_read(CSOUND_VA + 0x140 + channel * SOUND_CHANNEL_STRIDE, 4)
                )[0],
                "second_attenuation": struct.unpack(
                    "<i", machine.mem_read(CSOUND_VA + 0x144 + channel * SOUND_CHANNEL_STRIDE, 4)
                )[0],
            })
            # This is the mocked HIS-decoder/platform boundary. Make the slot
            # look like one successfully loaded ordinary (non-streaming) clip.
            machine.mem_write(slot + 0x162, struct.pack("<I", 1))
            machine.mem_write(slot + 0x166, struct.pack("<I", 0))
            machine.mem_write(slot + 0x28F, struct.pack("<I", BUFFER_VA))
            machine.reg_write(self._eax, 1)
            self._return_from_hook(4)
            return

        if address == GET_STATUS_STUB:
            esp = machine.reg_read(self._esp)
            status_pointer = read_u32(machine, esp + 8)
            machine.mem_write(status_pointer, struct.pack(
                "<I", int(self.currently_playing)
            ))
            self.trace["queries"].append(int(self.currently_playing))
            machine.reg_write(self._eax, 0)
            self._return_from_hook(8)
            return

        if address == PLAY_STUB:
            esp = machine.reg_read(self._esp)
            flags = read_u32(machine, esp + 16)
            self.trace["play_flags"].append(flags)
            machine.reg_write(self._eax, 0)
            self._return_from_hook(16)
            return

        if address == RELEASE_STUB:
            self.trace["releases"] += 1
            machine.reg_write(self._eax, 1)
            self._return_from_hook(4)
            return

        if address == STOP_STUB:
            self.trace["stops"] += 1
            machine.reg_write(self._eax, 0)
            self._return_from_hook(4)
            return

        if address == POSITION_STUB:
            machine.reg_write(self._eax, 0)
            self._return_from_hook(8)

    def call_cdecl(self, address: int, arguments: tuple[int, ...]) -> None:
        esp = STACK_BASE + STACK_SIZE - 0x100
        frame = (RETURN_SENTINEL, *arguments)
        self.uc.mem_write(esp, struct.pack(f"<{len(frame)}I", *frame))
        self.uc.reg_write(self._esp, esp)
        self.uc.reg_write(self._ebp, 0)
        self.uc.reg_write(self._ecx, 0)
        self.uc.reg_write(self._eflags, 0x202)
        self.uc.reg_write(self._eip, address)
        try:
            self.uc.emu_start(address, RETURN_SENTINEL,
                              timeout=15_000_000, count=8_000_000)
        except Exception as exc:
            raise OracleFailure(f"GAME.EXE trapped at 0x{address:08x}: {exc}") from exc
        if self.uc.reg_read(self._eip) != RETURN_SENTINEL:
            raise OracleFailure(
                f"GAME.EXE did not return from 0x{address:08x}; "
                f"EIP=0x{self.uc.reg_read(self._eip):08x}"
            )

    def initialize(self, body: bytes) -> None:
        self.uc.mem_write(BODY_VA, body)
        self.uc.mem_write(RUNTIME_VA, bytes(0x200))
        self.call_cdecl(RUNTIME_LOADER_VA,
                        (RUNTIME_VA, BODY_VA, 0xFFFFFFFF, 1))

        # Feed the original loader's proven missing-autotext result to the
        # runtime record. The fallback bytes and <e> marker are read from this
        # exact executable; caption handling itself executes at 0x432d1a.
        fallback = read_c_string(self.uc, FALLBACK_VA)
        terminator = read_c_string(self.uc, END_MARKER_VA)
        caption = fallback + terminator
        self.uc.mem_write(RUNTIME_VA + 0xAA, struct.pack("<H", len(caption)))
        self.uc.mem_write(RUNTIME_VA + 0xAC, caption + b"\0")

        # Values below are only platform/config fixture state. The original
        # action phase handler, attenuation math, DirectSound wrapper, query,
        # unload, and completion remain executable code in GAME.EXE.
        self.uc.mem_write(CDIRECTSOUND_VA + 0x1A0, struct.pack("<I", 1))
        self.uc.mem_write(CDIRECTSOUND_VA + 0x3CE, struct.pack("<I", CSOUND_VA + 4))
        self.uc.mem_write(CSOUND_VA + 0x10C + 13 * SOUND_CHANNEL_STRIDE,
                          struct.pack("<H", 0))
        self.uc.mem_write(CSOUND_VA + 0xB764, struct.pack("<f", 0.85))
        self.uc.mem_write(0x639DAE, b"\0")
        self.uc.mem_write(0x63A0BD, b"CDSound\0")
        self.uc.mem_write(CAPTION_ENABLED_VA, b"\x01")
        self.uc.mem_write(DEBUG_VA, b"\0\0")
        self.uc.mem_write(ACTION_TYPE_BASE_VA, bytes((0x9F, 1)))
        self.uc.mem_write(ACTION_DATA_BASE_VA, struct.pack("<I", RUNTIME_VA))
        self.uc.mem_write(ACTION_DONE_BASE_VA, b"\0")
        self.uc.mem_write(ACTION_PHASE_BASE_VA, struct.pack("<I", 0))

    def step(self, phase: int, playing: bool) -> tuple[int, int]:
        self.currently_playing = playing
        self.uc.mem_write(ACTION_PHASE_BASE_VA, struct.pack("<I", phase))
        self.call_cdecl(SOUND_ACTION_VA, (0, 1, RUNTIME_VA))
        new_phase = read_u32(self.uc, ACTION_PHASE_BASE_VA)
        completed = self.uc.mem_read(ACTION_DONE_BASE_VA, 1)[0]
        return new_phase, completed


def native_step(library: c.CDLL, body: bytes, phase: int,
                recorder: Recorder, completed: int = 0) -> tuple[int, int]:
    body_buffer = (c.c_uint8 * len(body)).from_buffer_copy(body)
    action = Action(0x9F, 1, 1, completed, phase, 1, 1,
                    body_buffer, len(body))
    result = Result()
    status = library.action_sound_step(
        c.byref(action), c.byref(recorder.backend), c.byref(result)
    )
    if status != OK:
        raise OracleFailure(f"native kernel failed: {status}")
    return result.phase, result.completed


def bind_library(path: Path) -> c.CDLL:
    library = c.CDLL(str(path.resolve()))
    library.action_sound_step.argtypes = [
        c.POINTER(Action), c.POINTER(Backend), c.POINTER(Result)
    ]
    library.action_sound_step.restype = c.c_int
    return library


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE missing: {args.exe}")
    pe = PEImage.parse_and_map(args.exe)
    digest = sha256(pe.data)
    if digest != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE hash mismatch: {digest}")

    library_path = PROJECT / "build/libactionsound.dylib"
    import subprocess

    subprocess.run([str(PROJECT / "scripts/build_action_sound.sh")], check=True)
    library = bind_library(library_path)

    body = sound_body()
    machine = OriginalSoundOracle(pe)
    machine.initialize(body)

    native_recorder = Recorder()
    native_recorder.resolver_result = BACKEND_NO_RESOURCE
    native_phase0 = native_step(library, body, 0, native_recorder)
    original_phase0 = machine.step(0, playing=False)

    native_recorder.still_playing = 1
    native_phase1_waiting = native_step(
        library, body, native_phase0[0], native_recorder
    )
    original_phase1_waiting = machine.step(1, playing=True)

    native_recorder.still_playing = 0
    native_phase1_finished = native_step(
        library, body, native_phase1_waiting[0], native_recorder
    )
    original_phase1_finished = machine.step(1, playing=False)

    native_phase2 = native_step(
        library, body, native_phase1_finished[0], native_recorder
    )
    original_phase2 = machine.step(2, playing=False)

    if native_phase0 != original_phase0:
        raise OracleFailure(f"phase 0 mismatch: native={native_phase0}, original={original_phase0}")
    if native_phase1_waiting != original_phase1_waiting:
        raise OracleFailure(
            f"playing wait mismatch: native={native_phase1_waiting}, "
            f"original={original_phase1_waiting}"
        )
    if native_phase1_finished != original_phase1_finished:
        raise OracleFailure(
            f"finished wait mismatch: native={native_phase1_finished}, "
            f"original={original_phase1_finished}"
        )
    if native_phase2 != original_phase2:
        raise OracleFailure(f"phase 2 mismatch: native={native_phase2}, original={original_phase2}")

    native_command = native_recorder.commands[0]
    original_command = machine.trace["loads"][0]
    expected_native_command = (
        b"NSHT01", 13, 0, 1, 75, 75, 0.75, 0.75, 0, 9999
    )
    if native_command != expected_native_command:
        raise OracleFailure(f"native command did not preserve S0 values: {native_command}")
    if (original_command["path"] != b"CDSound\\NSHT01.his" or
            original_command["channel"] != 13):
        raise OracleFailure(f"original path/load fields differ: {original_command}")
    if (original_command["control_word"] != 1 or
            original_command["volume_category"] != 0 or
            original_command["first_gain"] != 0.75 or
            original_command["second_gain"] != 0.75):
        raise OracleFailure(f"original command fields differ: {original_command}")
    if (original_command["first_attenuation"] != -1035 or
            original_command["second_attenuation"] != -1035):
        raise OracleFailure(f"original S0 attenuation did not match fixture: {original_command}")
    if machine.trace["play_flags"] != [0]:
        raise OracleFailure(f"unexpected DirectSound Play flags: {machine.trace['play_flags']}")
    if native_recorder.captions != [(
        1, b"Missing closed captioning text string<h><n><o>", b"<e>")
    ]:
        raise OracleFailure(f"native missing-caption fallback mismatch: {native_recorder.captions}")
    original_caption = b"Missing closed captioning text string<h><n><o><e>"
    if machine.trace["captions"] != [original_caption]:
        raise OracleFailure(f"original caption boundary mismatch: {machine.trace['captions']}")
    if machine.trace["file_paths"] != [b"CDSound\\NSHT01.his"]:
        raise OracleFailure(f"original path construction mismatch: {machine.trace['file_paths']}")
    if machine.trace["releases"] != 1:
        raise OracleFailure(f"expected original buffer release once: {machine.trace['releases']}")

    original_trace = {
        **machine.trace,
        "file_paths": [value.decode("ascii") for value in machine.trace["file_paths"]],
        "captions": [value.decode("ascii") for value in machine.trace["captions"]],
        "loads": [
            {**value, "path": value["path"].decode("ascii")}
            for value in machine.trace["loads"]
        ],
    }
    report = {
        "original_sha256": digest,
        "original_entrypoints": {
            "runtime_copy": "0x410f99",
            "sound_action": "0x432d1a",
            "file_lookup_boundary": "0x449d90",
            "caption_ui_boundary": "0x448d11",
            "his_decode_load_boundary": "0x4f379c",
            "directsound_play_wrapper": "0x4f80d3",
            "directsound_query_wrapper": "0x4f6334",
            "completion": "0x42ba3a",
        },
        "fixture": {
            "scene": "S0 / archive scene 0800.bin",
            "stem": "NSHT01",
            "channel": 13,
            "control_word": 1,
            "first_percent": 75,
            "second_percent": 75,
            "mode": 0,
            "transition": 9999,
            "selector": 65535,
            "caption_branch": "missing auto-text result supplied to original runtime; embedded executable fallback bytes used",
            "master_volume_category_0": 0.85,
        },
        "native": {
            "command": {
                "stem": native_command[0].decode("ascii"),
                "channel": native_command[1],
                "volume_category": native_command[2],
                "control_word": native_command[3],
                "first_percent": native_command[4],
                "second_percent": native_command[5],
                "first_gain": native_command[6],
                "second_gain": native_command[7],
                "mode": native_command[8],
                "transition": native_command[9],
            },
            "phase_results": [native_phase0, native_phase1_waiting,
                              native_phase1_finished, native_phase2],
            "caption": native_recorder.captions[0][1].decode("ascii"),
        },
        "original": {
            "loaded_command": {
                **original_command,
                "path": original_command["path"].decode("ascii"),
            },
            "phase_results": [original_phase0, original_phase1_waiting,
                              original_phase1_finished, original_phase2],
            "trace": original_trace,
            "caption": machine.trace["captions"][0].decode("ascii"),
        },
        "limitations": [
            "Unicorn emulates original GAME.EXE code, not the Windows application or native VM.",
            "The resource/file lookup, HIS decode/load result, caption UI, and DirectSound COM calls are bounded hooks.",
            "The actual HIS decoder and audio device output are not executed; no audible output is produced.",
            "The runtime record receives the proven missing-autotext fallback result. Successful autotext resource lookup is validated separately by the autotext parser/adapter.",
            "Global volume category 0 is seeded to the recovered runtime S0 value 0.85f; other volume configurations are not asserted.",
            "Unknown control-word restart/random-repeat paths and other playback modes remain unsupported by the native platform adapter.",
        ],
    }
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleFailure, OSError, ValueError, struct.error) as exc:
        print(f"oracle failure: {exc}", file=sys.stderr)
        return 1
    print(json.dumps(report, indent=2, sort_keys=True))
    print(f"Wrote {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
