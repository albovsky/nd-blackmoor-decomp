#!/usr/bin/env python3
"""Execute original sound control routines from the pinned x86 GAME.EXE.

Only Windows/DirectSound/HIS/tick/CRT seams are hooked. The recovered command
branches and attenuation/setter math execute as original x86 instructions in
Unicorn; this is not a Windows game launch or audible-output check.
"""

from __future__ import annotations

import argparse
import ctypes as C
import hashlib
import json
import struct
import subprocess
import sys
from collections import Counter
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, sha256
from test_sound_control import (
    ERR_ARGUMENT, ERR_UNSUPPORTED, HOST_ERROR, HOST_OK, HOST_UNSUPPORTED,
    UPDATE_NONE, UPDATE_RANDOM_REPEAT, UPDATE_RESTART,
    MasterResult, Recorder, Result, SoundControlTests, State, Channel,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/slices/S04-1-original-oracle.json"

CSOUND = 0x5C3A67
CDIRECTSOUND = 0x5CF1EB
DEBUG = 0x63A4CD
SLOT_STRIDE = 0x5BB

STACK = 0x1000
STACK_BYTES = 0x20000
DATA = 0x20000000
DATA_BYTES = 0x20000
STUB = 0x30000000
STUB_BYTES = 0x10000
RETURN = STUB
BUFFER = DATA + 0x8000
VTABLE = DATA + 0x9000
PATH = DATA + 0x1000

TICK = STUB + 0x1000
RANDOM = 0x50CD50
PLAY = STUB + 0x1010
SET_VOLUME = STUB + 0x1020
VOLUME_HELPER = 0x4F684A
HIS_LOAD = 0x4F379C
FADE_1 = 0x4F9F92
FADE_2 = 0x4F8F94
FADE_3 = 0x4F9040

WINDOWS = {
    "channel_category_init": (0x4FAA03, 0x4FAD50),
    "update_restart_random": (0x4F55D5, 0x4F572B),
    "play_flags_and_hresult": (0x4F6059, 0x4F61E7),
    "attenuation_and_his_call": (0x4FADC4, 0x4FAF98),
    "master_absolute": (0x4FCCF2, 0x4FCD4D),
    "master_clamp_and_active_refresh": (0x4FCB5C, 0x4FCCF2),
    "directsound_volume_wrapper": (0x4F684A, 0x4F6A7E),
}


class OracleFailure(RuntimeError):
    pass


def u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def i32(machine: Any, address: int) -> int:
    return struct.unpack("<i", machine.mem_read(address, 4))[0]


def u16(machine: Any, address: int) -> int:
    return struct.unpack("<H", machine.mem_read(address, 2))[0]


def f32(machine: Any, address: int) -> float:
    return struct.unpack("<f", machine.mem_read(address, 4))[0]


def put_u32(machine: Any, address: int, value: int) -> None:
    machine.mem_write(address, struct.pack("<I", value & 0xFFFFFFFF))


def put_i32(machine: Any, address: int, value: int) -> None:
    machine.mem_write(address, struct.pack("<i", value))


def put_u16(machine: Any, address: int, value: int) -> None:
    machine.mem_write(address, struct.pack("<H", value & 0xFFFF))


def put_f32(machine: Any, address: int, value: float) -> None:
    machine.mem_write(address, struct.pack("<f", value))


def slot_address(channel: int) -> int:
    return CSOUND + 4 + channel * SLOT_STRIDE


class OriginalSoundControlOracle:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
            from unicorn.x86_const import (
                UC_X86_REG_EAX, UC_X86_REG_EBP, UC_X86_REG_ECX,
                UC_X86_REG_EFLAGS, UC_X86_REG_EIP, UC_X86_REG_ESP,
                UC_X86_REG_FPCW,
            )
        except ImportError as exc:
            raise OracleFailure(
                "Unicorn 2.x is required; use work/tools/oracle-python/bin/python"
            ) from exc

        self.eax = UC_X86_REG_EAX
        self.ebp = UC_X86_REG_EBP
        self.ecx = UC_X86_REG_ECX
        self.eflags = UC_X86_REG_EFLAGS
        self.eip = UC_X86_REG_EIP
        self.esp = UC_X86_REG_ESP
        self.fpcw = UC_X86_REG_FPCW
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 0xFFF) & ~0xFFF)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK, STACK_BYTES)
        self.uc.mem_map(DATA, DATA_BYTES)
        self.uc.mem_map(STUB, STUB_BYTES)
        self.uc.mem_write(RETURN, b"\xcc")

        table = bytearray(0x54)
        struct.pack_into("<I", table, 0x30, PLAY)
        struct.pack_into("<I", table, 0x3C, SET_VOLUME)
        self.uc.mem_write(VTABLE, bytes(table))
        self.uc.mem_write(BUFFER, struct.pack("<I", VTABLE))
        self.uc.mem_write(PATH, b"oracle.his\0")
        self.uc.mem_write(0x52A23C, struct.pack("<I", TICK))
        self.uc.mem_write(CDIRECTSOUND + 0x1A0, struct.pack("<I", 1))
        self.uc.mem_write(CDIRECTSOUND + 0x3CE, struct.pack("<I", CSOUND + 4))
        self.uc.mem_write(DEBUG, b"\0\0")
        self.tick_value = 0
        self.random_value = 0
        self.play_hresult = 0
        self.volume_hresult = 0
        self.trace: list[tuple] = []
        self.loaded_trace: list[dict[str, Any]] = []
        self.current_volume_channel = 0
        self.uc.hook_add(UC_HOOK_CODE, self._hook)

    def _return_hook(self, pop_bytes: int = 0) -> None:
        esp = self.uc.reg_read(self.esp)
        ret = u32(self.uc, esp)
        self.uc.reg_write(self.esp, esp + 4 + pop_bytes)
        self.uc.reg_write(self.eip, ret)

    def _hook(self, machine: Any, address: int, _size: int, _user: Any) -> None:
        if address == VOLUME_HELPER:
            self.current_volume_channel = u32(
                machine, machine.reg_read(self.esp) + 4
            ) & 0xFFFF
        elif address == TICK:
            self.trace.append(("tick", self.tick_value))
            machine.reg_write(self.eax, self.tick_value)
            self._return_hook()
        elif address == RANDOM:
            self.trace.append(("random", self.random_value))
            machine.reg_write(self.eax, self.random_value)
            self._return_hook()
        elif address == PLAY:
            esp = machine.reg_read(self.esp)
            channel_buffer = u32(machine, esp + 4)
            flags = u32(machine, esp + 16)
            channel = None
            for index in range(32):
                if u32(machine, slot_address(index) + 0x28F) == channel_buffer:
                    channel = index
                    break
            if channel is None:
                raise OracleFailure("DirectSound Play received an unknown buffer")
            self.trace.append(("play", channel, flags))
            machine.reg_write(self.eax, self.play_hresult & 0xFFFFFFFF)
            self._return_hook(16)
        elif address == SET_VOLUME:
            esp = machine.reg_read(self.esp)
            buffer = u32(machine, esp + 4)
            attenuation = struct.unpack("<i", machine.mem_read(esp + 8, 4))[0]
            channel = self.current_volume_channel
            if not buffer:
                raise OracleFailure("DirectSound SetVolume received a null buffer")
            self.trace.append(("volume", channel, attenuation))
            machine.reg_write(self.eax, self.volume_hresult & 0xFFFFFFFF)
            self._return_hook(8)
        elif address == HIS_LOAD:
            esp = machine.reg_read(self.esp)
            channel = u32(machine, esp + 4) & 0xFFFF
            self.loaded_trace.append({
                "channel": channel,
                "first_scalar": f32(machine, CSOUND + 0x138 + channel * SLOT_STRIDE),
                "second_scalar": f32(machine, CSOUND + 0x13C + channel * SLOT_STRIDE),
                "first_attenuation": i32(machine, CSOUND + 0x140 + channel * SLOT_STRIDE),
                "second_attenuation": i32(machine, CSOUND + 0x144 + channel * SLOT_STRIDE),
                "category": struct.unpack(
                    "<h", machine.mem_read(CSOUND + 0x10C + channel * SLOT_STRIDE, 2)
                )[0],
                "control": u32(machine, CSOUND + 0x134 + channel * SLOT_STRIDE),
            })
            machine.reg_write(self.eax, 1)
            self._return_hook(4)
        elif address in (FADE_1, FADE_2, FADE_3):
            esp = machine.reg_read(self.esp)
            channel = u32(machine, esp + 4) & 0xFFFF
            stage = {FADE_1: "fade1", FADE_2: "fade2", FADE_3: "fade3"}[address]
            self.trace.append((stage, channel))
            self._return_hook(8 if address == FADE_3 else 4)

    def call_this(self, address: int, this_pointer: int,
                  arguments: tuple[int, ...] = (), control_word: int = 0x023F) -> int:
        esp = STACK + STACK_BYTES - 0x100
        words = (RETURN, *(value & 0xFFFFFFFF for value in arguments))
        self.uc.mem_write(esp, struct.pack(f"<{len(words)}I", *words))
        self.uc.reg_write(self.esp, esp)
        self.uc.reg_write(self.ebp, 0)
        self.uc.reg_write(self.ecx, this_pointer)
        self.uc.reg_write(self.eflags, 0x202)
        self.uc.reg_write(self.fpcw, control_word)
        self.uc.reg_write(self.eip, address)
        try:
            self.uc.emu_start(address, RETURN, timeout=15_000_000,
                              count=8_000_000)
        except Exception as exc:
            raise OracleFailure(f"original code trapped at 0x{address:08x}: {exc}") from exc
        if self.uc.reg_read(self.eip) != RETURN:
            raise OracleFailure(
                f"original code did not return from 0x{address:08x}; "
                f"EIP=0x{self.uc.reg_read(self.eip):08x}"
            )
        return self.uc.reg_read(self.eax)

    def seed_slot(self, channel: int, *, control: int = 1, flags: int = 0,
                  resource_ready: int = 1, stream: int = 0, buffer: bool = True,
                  gate_287: int = 0, gate_16e: int = 0, gate_172: int = 0,
                  repeat_min: int = 0, repeat_max: int = 0,
                  repeat_marker: int = 0, repeat_delay: int = 0,
                  repeat_due: int = 0) -> None:
        slot = slot_address(channel)
        put_u32(self.uc, slot + 0x130, control)
        put_u16(self.uc, slot + 0x12C, flags)
        put_u32(self.uc, slot + 0x162, resource_ready)
        put_u32(self.uc, slot + 0x166, stream)
        put_u32(self.uc, slot + 0x287, gate_287)
        put_u32(self.uc, slot + 0x16E, gate_16e)
        put_u32(self.uc, slot + 0x172, gate_172)
        put_u32(self.uc, slot + 0x28F, BUFFER if buffer else 0)
        put_u32(self.uc, slot + 0x19E, repeat_marker)
        put_i32(self.uc, slot + 0x1AA, repeat_min)
        put_i32(self.uc, slot + 0x1AE, repeat_max)
        put_u32(self.uc, slot + 0x1A2, repeat_delay)
        put_u32(self.uc, slot + 0x1A6, repeat_due)


def native_binding():
    subprocess.run([str(PROJECT / "scripts/build_sound_control.sh")], check=True)
    test_fixture = SoundControlTests()
    test_fixture.setUpClass()
    return test_fixture


def original_play_trace(oracle: OriginalSoundControlOracle,
                        fixture: SoundControlTests) -> dict[str, Any]:
    cases = [
        {"control": 1, "flags": 0, "stream": 0},
        {"control": 0, "flags": 1, "stream": 0},
        {"control": 1, "flags": 0x100, "stream": 0},
        {"control": 1, "flags": 0, "stream": 1},
        {"control": 0, "flags": 0x101, "stream": 1},
        {"control": 1, "flags": 0, "stream": 0, "resource": 0},
        {"control": 1, "flags": 0, "stream": 0, "buffer": False},
        {"control": 1, "flags": 0, "stream": 0, "device_ready": 0},
        {"control": 1, "flags": 0, "stream": 0, "play_hresult": -1},
    ]
    comparisons = []
    for case in cases:
        oracle.trace.clear()
        oracle.play_hresult = case.get("play_hresult", 0)
        put_u32(oracle.uc, CDIRECTSOUND + 0x1A0, case.get("device_ready", 1))
        oracle.seed_slot(13, control=case["control"], flags=case["flags"],
                         stream=case["stream"],
                         resource_ready=case.get("resource", 1),
                         buffer=case.get("buffer", True), gate_287=9)
        original_return = oracle.call_this(0x4F6059, CDIRECTSOUND, (13,))
        original = {
            "return": int(original_return != 0),
            "error": u32(oracle.uc, CDIRECTSOUND + 0x3C2),
            "device_state": u32(oracle.uc, CDIRECTSOUND + 0x3BE),
            "gate_287": u32(oracle.uc, slot_address(13) + 0x287),
            "flags": oracle.trace[0][2] if oracle.trace and oracle.trace[0][0] == "play" else None,
        }
        state = fixture.state()
        slot = state.channels[13]
        slot.raw_control = case["control"]
        slot.raw_flags = case["flags"]
        slot.stream_state = case["stream"]
        slot.resource_ready = case.get("resource", 1)
        slot.buffer_available = int(case.get("buffer", True))
        slot.update_gate_287 = 9
        state.device_ready = case.get("device_ready", 1)
        recorder = Recorder()
        recorder.play_status = HOST_ERROR if case.get("play_hresult", 0) else HOST_OK
        recorder.host_result = case.get("play_hresult", 0)
        native_status, native_result = fixture.play(state, 13, recorder)
        native = {
            "status": native_status,
            "return": native_result.played,
            "error": state.device_error,
            "device_state": state.device_state,
            "gate_287": slot.update_gate_287,
            "flags": native_result.play_flags if native_result.play_attempted else None,
        }
        expected_error = original["error"]
        if original["return"] == 0 and expected_error == 0x3E8:
            raise OracleFailure(f"unexpected unclassified original Play failure: {case}")
        if native["return"] != original["return"] or native["flags"] != original["flags"] or \
                native["error"] != expected_error or native["device_state"] != original["device_state"] or \
                native["gate_287"] != original["gate_287"]:
            raise OracleFailure(f"Play mismatch for {case}: original={original}, native={native}")
        comparisons.append({"case": case, "original": original, "native": native})
    return {"cases": len(comparisons), "comparisons": comparisons}


def original_update_trace(oracle: OriginalSoundControlOracle,
                          fixture: SoundControlTests) -> dict[str, Any]:
    cases = [
        {"name": "control-one-no-restart", "control": 1, "flags": 0},
        {"name": "control-zero-restart", "control": 0, "flags": 0},
        {"name": "random-modulo-and-tick-wrap", "control": 0, "flags": 0x10,
         "minimum": 10, "maximum": 20, "tick": 0xFFFFFFF8, "random": 23},
        {"name": "nonpositive-range", "control": 0, "flags": 0x10,
         "minimum": 12, "maximum": 11, "tick": 33},
        {"name": "false-gate-prevents-restart", "control": 0, "flags": 0x30,
         "gate_287": 1},
        {"name": "fade-hooks-before-restart", "control": 0, "flags": 0x20},
        {"name": "gate-16e-prevents-restart", "control": 0, "flags": 0x30,
         "gate_16e": 1},
        {"name": "gate-172-prevents-restart", "control": 0, "flags": 0x30,
         "gate_172": 1},
        {"name": "stream-state-prevents-restart", "control": 0, "flags": 0x30,
         "stream": 1},
        {"name": "control-one-fade-without-restart", "control": 1, "flags": 0x20},
        {"name": "random-range-exactly-zero", "control": 0, "flags": 0x10,
         "minimum": 7, "maximum": 7, "tick": 100, "random": 5},
        {"name": "restart-device-not-ready", "control": 0, "flags": 0,
         "device_ready": 0},
        {"name": "restart-resource-not-ready", "control": 0, "flags": 0,
         "resource": 0},
        {"name": "restart-buffer-missing", "control": 0, "flags": 0,
         "buffer": False},
        {"name": "restart-play-hresult-failure", "control": 0, "flags": 0,
         "play_hresult": -1},
    ]
    comparisons = []
    for case in cases:
        oracle.trace.clear()
        oracle.tick_value = case.get("tick", 0)
        oracle.random_value = case.get("random", 0)
        oracle.play_hresult = 0
        oracle.play_hresult = case.get("play_hresult", 0)
        put_u32(oracle.uc, CDIRECTSOUND + 0x1A0,
                case.get("device_ready", 1))
        put_u32(oracle.uc, CDIRECTSOUND + 0x3BE, 0)
        oracle.seed_slot(13, control=case["control"], flags=case["flags"],
                         resource_ready=case.get("resource", 1),
                         buffer=case.get("buffer", True),
                         gate_287=case.get("gate_287", 0),
                         gate_16e=case.get("gate_16e", 0),
                         gate_172=case.get("gate_172", 0),
                         stream=case.get("stream", 0),
                         repeat_min=case.get("minimum", 0),
                         repeat_max=case.get("maximum", 0))
        oracle.call_this(0x4F55D5, CDIRECTSOUND, (13,))
        slot = slot_address(13)
        original = {
            "trace": list(oracle.trace),
            "error": u32(oracle.uc, CDIRECTSOUND + 0x3C2),
            "device_state": u32(oracle.uc, CDIRECTSOUND + 0x3BE),
            "repeat_marker": u32(oracle.uc, slot + 0x19E),
            "repeat_delay": u32(oracle.uc, slot + 0x1A2),
            "repeat_due": u32(oracle.uc, slot + 0x1A6),
        }
        original_play = next(
            (event for event in original["trace"] if event[0] == "play"), None
        )
        expected_result = {
            "original_error": 0 if original["error"] == 0x3E8 else original["error"],
            "play_flags": original_play[2] if original_play is not None else 0,
            "play_attempted": int(original_play is not None),
            "played": int(original_play is not None and original["error"] == 0x3E8),
        }
        state = fixture.state()
        native_slot = state.channels[13]
        native_slot.raw_control = case["control"]
        native_slot.raw_flags = case["flags"]
        native_slot.update_gate_287 = case.get("gate_287", 0)
        native_slot.update_gate_16e = case.get("gate_16e", 0)
        native_slot.update_gate_172 = case.get("gate_172", 0)
        native_slot.stream_state = case.get("stream", 0)
        native_slot.repeat_min = case.get("minimum", 0)
        native_slot.repeat_max = case.get("maximum", 0)
        native_slot.resource_ready = case.get("resource", 1)
        native_slot.buffer_available = int(case.get("buffer", True))
        state.device_ready = case.get("device_ready", 1)
        recorder = Recorder()
        recorder.play_status = HOST_ERROR if case.get("play_hresult", 0) else HOST_OK
        recorder.host_result = case.get("play_hresult", 0)
        recorder.tick = oracle.tick_value
        recorder.random = oracle.random_value
        native_status, native_result = fixture.update(state, 13, recorder)
        native = {
            "trace": list(recorder.events),
            "status": native_status,
            "kind": native_result.update_kind,
            "error": state.device_error,
            "result": {
                "original_error": native_result.original_error,
                "play_flags": native_result.play_flags,
                "play_attempted": native_result.play_attempted,
                "played": native_result.played,
            },
            "device_state": state.device_state,
            "repeat_marker": native_slot.repeat_marker,
            "repeat_delay": native_slot.repeat_delay,
            "repeat_due": native_slot.repeat_due_tick,
        }
        if native["trace"] != original["trace"] or native["error"] != original["error"] or \
                native["device_state"] != original["device_state"] or \
                native["repeat_marker"] != original["repeat_marker"] or \
                native["repeat_delay"] != original["repeat_delay"] or \
                native["repeat_due"] != original["repeat_due"] or \
                native["result"] != expected_result:
            raise OracleFailure(f"Update mismatch for {case['name']}: original={original}, native={native}")
        comparisons.append({"case": case, "original": original, "native": native})
    return {"cases": len(comparisons), "comparisons": comparisons}


def original_attenuation_trace(oracle: OriginalSoundControlOracle,
                               fixture: SoundControlTests) -> dict[str, Any]:
    cases = [
        {"first": 0.75, "second": 0.25, "master": 0.85},
        {"first": 0.0, "second": 1.0, "master": 0.0},
        {"first": 1.0, "second": 0.5, "master": 1.0},
        {"first": 0.4999, "second": 0.5001, "master": 0.3333},
        {"first": 0.123456, "second": 0.876543, "master": 0.731234},
    ]
    comparisons = []
    for cw in (0x023F, 0x027F):
        for case in cases:
            channel = 13
            oracle.loaded_trace.clear()
            oracle.seed_slot(channel, control=1, flags=0, resource_ready=1,
                             stream=0, buffer=True)
            put_u16(oracle.uc, CSOUND + 0x10C + channel * SLOT_STRIDE, 0)
            put_u32(oracle.uc, CDIRECTSOUND + 0x1A0, 1)
            put_f32(oracle.uc, CSOUND + 0xB764, case["master"])
            put_f32(oracle.uc, CSOUND + 0x138 + channel * SLOT_STRIDE, case["first"])
            put_f32(oracle.uc, CSOUND + 0x13C + channel * SLOT_STRIDE, case["second"])
            oracle.call_this(0x4FADC4, CSOUND, (PATH, channel), control_word=cw)
            observed = oracle.loaded_trace[-1]
            first = C.c_int32()
            second = C.c_int32()
            native_first_status = fixture.lib.sound_control_calculate_attenuation(
                case["first"], case["master"], cw, C.byref(first)
            )
            native_second_status = fixture.lib.sound_control_calculate_attenuation(
                case["second"], case["master"], cw, C.byref(second)
            )
            if native_first_status != 0 or native_second_status != 0 or \
                    first.value != observed["first_attenuation"] or \
                    second.value != observed["second_attenuation"]:
                raise OracleFailure(
                    f"attenuation mismatch cw={cw:#x} case={case}: original={observed}, "
                    f"native=({native_first_status},{first.value},{native_second_status},{second.value})"
                )
            comparisons.append({"cw": f"0x{cw:04x}", "case": case,
                                "original": observed,
                                "native": [first.value, second.value]})
    return {"cases": len(comparisons), "comparisons": comparisons}


def original_master_trace(oracle: OriginalSoundControlOracle,
                          fixture: SoundControlTests) -> dict[str, Any]:
    channels = [1, 2, 3, 4]
    source_channels = (
        (1, 0, 1, 0.75, 0.25),
        (2, 0, 1, 0.25, 0.75),
        (3, 1, 1, 0.5, 0.5),
        (4, 0, 0, 0.9, 0.1),
    )
    cases = [
        {"name": "active-independent-scalars", "percent": 75},
        {"name": "percent-clamps-to-one", "percent": 125},
        {"name": "volume-hresult-failure", "percent": 75, "hresult": -1},
        {"name": "device-not-ready", "percent": 75, "device_ready": 0},
        {"name": "missing-channel-buffer", "percent": 75, "missing": 1},
    ]
    comparisons = []
    for case in cases:
        category = 0
        percent = case["percent"]
        oracle.trace.clear()
        oracle.volume_hresult = case.get("hresult", 0)
        put_u32(oracle.uc, CDIRECTSOUND + 0x1A0, case.get("device_ready", 1))
        put_u32(oracle.uc, CDIRECTSOUND + 0x3BE, 0)
        for channel in range(32):
            put_u16(oracle.uc, CSOUND + 0x10C + channel * SLOT_STRIDE, 3)
            put_u16(oracle.uc, CSOUND + 0x132 + channel * SLOT_STRIDE, 0)
            put_f32(oracle.uc, CSOUND + 0x138 + channel * SLOT_STRIDE, 0.0)
            put_f32(oracle.uc, CSOUND + 0x13C + channel * SLOT_STRIDE, 0.0)
            put_u32(oracle.uc, slot_address(channel) + 0x28F, 0)
        for channel, channel_category, active, first, second in source_channels:
            oracle.seed_slot(channel, buffer=(channel != case.get("missing", -1)))
            put_u16(oracle.uc, CSOUND + 0x10C + channel * SLOT_STRIDE, channel_category)
            put_u16(oracle.uc, CSOUND + 0x132 + channel * SLOT_STRIDE, active)
            put_f32(oracle.uc, CSOUND + 0x138 + channel * SLOT_STRIDE, first)
            put_f32(oracle.uc, CSOUND + 0x13C + channel * SLOT_STRIDE, second)
        oracle.call_this(0x4FCCF2, CSOUND, (percent, category), control_word=0x023F)
        original_master = f32(oracle.uc, CSOUND + 0xB764 + category * 4)
        original_channels = {
            ch: {
                "first": i32(oracle.uc, CSOUND + 0x140 + ch * SLOT_STRIDE),
                "second": i32(oracle.uc, CSOUND + 0x144 + ch * SLOT_STRIDE),
            }
            for ch in channels
        }
        original = {
            "master": original_master,
            "channels": original_channels,
            "trace": list(oracle.trace),
            "device_error": u32(oracle.uc, CDIRECTSOUND + 0x3C2),
            "device_state": u32(oracle.uc, CDIRECTSOUND + 0x3BE),
            "host_result": i32(oracle.uc, CDIRECTSOUND + 0x3CA),
        }

        state = fixture.state()
        state.device_ready = case.get("device_ready", 1)
        for channel, channel_category, active, first, second in source_channels:
            slot = state.channels[channel]
            slot.volume_category = channel_category
            slot.volume_update_state = active
            slot.first_scalar, slot.second_scalar = first, second
            if channel == case.get("missing", -1):
                slot.buffer_available = 0
        state.master[category] = 0.85
        recorder = Recorder()
        recorder.volume_status = HOST_ERROR if case.get("hresult", 0) else HOST_OK
        recorder.host_result = case.get("hresult", 0)
        native_result = MasterResult()
        status = fixture.lib.sound_control_set_master_absolute(
            C.byref(state), category, percent, 0x023F,
            C.byref(recorder.host), C.byref(native_result)
        )
        native = {
            "status": status,
            "master": state.master[category],
            "channels": {
                ch: {"first": state.channels[ch].first_attenuation,
                     "second": state.channels[ch].second_attenuation}
                for ch in channels
            },
            "trace": recorder.events,
            "device_error": state.device_error,
            "device_state": state.device_state,
            "host_result": state.host_result,
            "volume_calls": native_result.volume_calls,
        }
        original_volume_trace = [
            event for event in original["trace"] if event[0] == "volume"
        ]
        if not math_isclose(native["master"], original_master) or \
                native["channels"] != original_channels or \
                native["trace"] != original_volume_trace or \
                native["device_error"] != original["device_error"] or \
                native["device_state"] != original["device_state"] or \
                native["host_result"] != original["host_result"]:
            raise OracleFailure(
                f"master setter mismatch for {case['name']}: "
                f"original={original}, native={native}"
            )
        comparisons.append({"case": case, "original": original, "native": native})
    return {"cases": len(comparisons), "comparisons": comparisons}


def math_isclose(left: float, right: float) -> bool:
    return abs(left - right) <= 1e-7


def scan_scene_commands() -> dict[str, Any]:
    resource_library = PROJECT / "build/libsceneresource.dylib"
    if not resource_library.is_file():
        subprocess.run([str(PROJECT / "scripts/build_scene_resource.sh")], check=True)
    class SceneActionInfo(C.Structure):
        _fields_ = [
            ("description", C.c_char * 49),
            ("type", C.c_uint8),
            ("subtype", C.c_uint8),
            ("payload_kind", C.c_int),
            ("raw_body", C.POINTER(C.c_uint8)),
            ("raw_body_length", C.c_size_t),
            ("typed_body", C.POINTER(C.c_uint8)),
            ("typed_body_length", C.c_size_t),
            ("dependency_records", C.POINTER(C.c_uint8)),
            ("dependency_count", C.c_size_t),
        ]

    parser_library = C.CDLL(str(resource_library))
    parser_library.scene_resource_open_memory.argtypes = [
        C.c_void_p, C.c_size_t, C.c_char_p, C.c_size_t,
    ]
    parser_library.scene_resource_open_memory.restype = C.c_void_p
    parser_library.scene_resource_close.argtypes = [C.c_void_p]
    parser_library.scene_resource_action_count.argtypes = [C.c_void_p]
    parser_library.scene_resource_action_count.restype = C.c_size_t
    parser_library.scene_resource_action_at.argtypes = [
        C.c_void_p, C.c_size_t, C.POINTER(SceneActionInfo),
    ]
    parser_library.scene_resource_action_at.restype = C.c_int

    category_sets = {
        0: {12, 13, 30},
        1: {0, 1, 2, 26, 27, 29, 19},
        2: {3, 4, 5, 6, 7, 8, 9, 10, 11, 20, 24, 25, 23, 22, 21, 31, 18, 17},
    }

    def category_for(channel: int) -> int:
        for category, channels in category_sets.items():
            if channel in channels:
                return category
        return 3

    corpus_directory = ROOT / "work/analysis/hiff-resources"
    paths = sorted(corpus_directory.glob("*.bin"))
    corpus_digest = hashlib.sha256()
    parsed = 0
    parse_errors = 0
    command_count = 0
    scene_count = 0
    control_modes: Counter[tuple[int, int]] = Counter()
    categories: Counter[int] = Counter()
    scalar_pairs: Counter[tuple[int, int]] = Counter()
    unequal_scalars = 0
    control_counts: Counter[int] = Counter()
    mode_counts: Counter[int] = Counter()
    s0_commands: list[dict[str, int]] = []

    for path in paths:
        data = path.read_bytes()
        corpus_digest.update(path.name.encode("ascii") + b"\0")
        corpus_digest.update(hashlib.sha256(data).digest())
        raw = C.create_string_buffer(data)
        error = C.create_string_buffer(256)
        scene = parser_library.scene_resource_open_memory(
            raw, len(data), error, len(error)
        )
        if not scene:
            parse_errors += 1
            continue
        parsed += 1
        count = parser_library.scene_resource_action_count(scene)
        in_scene = 0
        for action_index in range(count):
            action = SceneActionInfo()
            if parser_library.scene_resource_action_at(
                scene, action_index, C.byref(action)
            ) != 0 or action.type != 0x9F:
                continue
            body = C.string_at(action.typed_body, action.typed_body_length)
            if len(body) < 48:
                raise OracleFailure(f"short parsed 0x9f body in scene {path.stem}")
            channel = struct.unpack_from("<H", body, 33)[0]
            control = struct.unpack_from("<I", body, 35)[0]
            first_percent, second_percent = struct.unpack_from("<hh", body, 39)
            mode = body[43]
            category = category_for(channel)
            command_count += 1
            in_scene += 1
            control_modes[(control, mode)] += 1
            control_counts[control] += 1
            mode_counts[mode] += 1
            categories[category] += 1
            scalar_pairs[(first_percent, second_percent)] += 1
            if first_percent != second_percent:
                unequal_scalars += 1
            if path.stem == "0800":
                s0_commands.append({
                    "action_index": action_index,
                    "channel": channel,
                    "category": category,
                    "control": control,
                    "first_percent": first_percent,
                    "second_percent": second_percent,
                    "mode": mode,
                })
        if in_scene:
            scene_count += 1
        parser_library.scene_resource_close(scene)

    return {
        "corpus_files": len(paths),
        "parser_successes": parsed,
        "parser_rejections": parse_errors,
        "parsed_0x9f_commands": command_count,
        "scenes_with_0x9f": scene_count,
        "raw_control_counts": {str(key): value for key, value in sorted(control_counts.items())},
        "mode_counts": {str(key): value for key, value in sorted(mode_counts.items())},
        "control_mode_counts": {
            f"{control}:{mode}": count
            for (control, mode), count in sorted(control_modes.items())
        },
        "category_counts": {str(key): value for key, value in sorted(categories.items())},
        "unequal_scalar_commands": unequal_scalars,
        "distinct_raw_scalar_pairs": len(scalar_pairs),
        "top_scalar_pairs": [
            {"first_percent": pair[0], "second_percent": pair[1], "count": count}
            for pair, count in scalar_pairs.most_common(12)
        ],
        "s0_0800_commands": s0_commands,
        "private_input_corpus_digest_sha256": corpus_digest.hexdigest(),
        "parser_source_sha256": {
            "scene_resource.c": sha256((PROJECT / "src/scene_resource.c").read_bytes()),
            "hiff.c": sha256((PROJECT / "src/hiff.c").read_bytes()),
        },
    }


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"GAME.EXE missing: {args.exe}")
    pe = PEImage.parse_and_map(args.exe)
    if sha256(pe.data) != EXPECTED_EXE_SHA256:
        raise OracleFailure("pinned original GAME.EXE SHA-256 does not match")
    fixture = native_binding()
    oracle = OriginalSoundControlOracle(pe)

    hashes = {}
    for name, (start, end) in WINDOWS.items():
        offset = pe.va_to_file_offset(start, end - start)
        hashes[name] = {
            "start_va": f"0x{start:08x}", "end_va_exclusive": f"0x{end:08x}",
            "length": end - start,
            "sha256": hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest(),
        }

    report = {
        "original_sha256": sha256(pe.data),
        "x87_control_words": ["0x023f startup raw", "0x027f semantic PC=53/RN"],
        "code_windows": hashes,
        "hook_list": [
            {"address": "0x52a23c -> injected stub", "meaning": "GetTickCount"},
            {"address": "0x50cd50", "meaning": "CRT rand result"},
            {"address": "0x4f379c", "meaning": "HIS loader/resource buffer success only"},
            {"address": "DirectSound vtable +0x30", "meaning": "Play HRESULT boundary"},
            {"address": "DirectSound vtable +0x3c", "meaning": "SetVolume HRESULT boundary"},
            {"address": "0x4f9f92, 0x4f8f94, 0x4f9040", "meaning": "fade bodies"},
        ],
        "coverage": {
            "play": original_play_trace(oracle, fixture),
            "update": original_update_trace(oracle, fixture),
            "attenuation": original_attenuation_trace(oracle, fixture),
            "master_volume": original_master_trace(oracle, fixture),
        },
        "actual_scene_command_corpus": scan_scene_commands(),
        "limits": [
            "Unicorn executes isolated x86 functions from the pinned PE; this does not launch Windows or produce sound.",
            "DirectSound HRESULTs, GetTickCount, CRT rand, HIS decode/load, and fade bodies are deterministic hooks.",
            "The native attenuation API is limited to observed x87 precision=53 and round-to-nearest; other PC/RC modes are unsupported.",
            "Raw channel flags at slot+0x12c are distinct from raw control at slot+0x130.",
            "Mode-1 lifecycle, fade algorithms, streaming completion, pan, and decoder/PCM parity remain separate open work.",
        ],
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
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
        print(f"sound-control oracle failure: {exc}", file=sys.stderr)
        return 1
    summary = {
        "original_sha256": report["original_sha256"],
        "counts": {key: report["coverage"][key]["cases"]
                   for key in ("play", "update", "attenuation")},
        "master_volume_cases": report["coverage"]["master_volume"]["cases"],
        "window_count": len(report["code_windows"]),
        "report": str(args.report),
    }
    print(json.dumps(summary, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
