#!/usr/bin/env python3
"""Compare the bounded native clock kernel with original GAME.EXE x86.

The original frame routine runs at 0x43a7ca. Only GetTickCount, input/UI
entrypoints, resource caption lookup, sound platform calls, and caption
presentation are hooked. The clock arithmetic, timer-record dispatch,
dependency-flag writes, NO SOUND comparison, caption branch, and
0x433bd2 record reset execute as original machine code.
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

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
TESTS = PROJECT / "tests"
EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_OUT = ROOT / "work/analysis/slices/S06-1-clock-kernel-oracle-20261013.json"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"

sys.path.insert(0, str(TESTS))
from cif_original_oracle import PEImage, align_up
from test_world_clock import (
    CAPTION_FROM_FALLBACK,
    CAPTION_FROM_RESOLVER,
    CLOCK_ERR_CONTINUATION,
    CLOCK_ERR_HOST_UNAVAILABLE,
    CLOCK_OK,
    CONTINUE_OFFMODE_CLEANUP,
    EFFECT_LOAD_SOUND_DESCRIPTOR,
    EFFECT_PLAY_SOUND_CHANNEL,
    EFFECT_SHOW_CAPTION,
    HOST_RETURNED_FAILURE_IGNORED,
    RESOLVER_FOUND,
    RESOLVER_NOT_FOUND,
    Fixture,
    SinkRecorder,
    TRIGGER_SOUND_DESCRIPTOR,
)

from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
from unicorn.x86_const import (
    UC_X86_REG_EAX,
    UC_X86_REG_EBP,
    UC_X86_REG_ECX,
    UC_X86_REG_EFLAGS,
    UC_X86_REG_EIP,
    UC_X86_REG_ESP,
)

TICK_IAT = 0x52A23C
STACK = 0x10000000
STACK_SIZE = 0x20000
STACK_TOP = STACK + STACK_SIZE - 0x100
RETURN_VA = 0x70002000
EXTRA_BASE = 0x70000000
EXTRA_SIZE = 0x4000
TICK_STUB = EXTRA_BASE + 0x100
RESOLVED_TEXT = EXTRA_BASE + 0x1000
STOP_NORMAL = 0x43B13D
STOP_OFFMODE = 0x43AB78
STOP_SOUND_DESCRIPTOR = 0x4FB77A
EVENT_FLAGS = 0x585801
TIME_RECORDS = 0x585D65
RECORD_SIZE = 0x106
RECORD_COUNT = 10

CODE_WINDOWS = {
    "frame_clock_tick_entry": (0x43A7CA, 0x43A7DB),
    "frame_mode_pause_and_normal_delta": (0x43AA09, 0x43AC06),
    "frame_record_update_and_completion": (0x43AC06, 0x43AF3F),
    "frame_scene_civil_clock_and_window": (0x43AF3F, 0x43B142),
    "timer_record_reset_helper": (0x433BD2, 0x433C51),
    "timer_sound_channel_play_wrapper": (0x4FB2E3, 0x4FB397),
    "condition_opcode4_run_elapsed_read": (0x42468D, 0x424692),
    "condition_opcode5_scene_elapsed_read": (0x4247CD, 0x4247D3),
}
DATA_WINDOWS = {
    "caption_suffix_fallback": (0x547214, 8),
    "caption_suffix_resolver": (0x54721C, 8),
}

SCENARIOS = [
    {
        "name": "status5 no-sound flag pairs and fallback caption",
        "mode": "normal",
        "now": 200,
        "records": [{
            "index": 0, "status": 5, "elapsed": 0, "target": 100,
            "sound": b"NO SOUND", "sound_channel": 0,
            "pairs": ((2, -7), (-1, 91), (4, 0)),
            "caption": b"missing-key", "fallback": b"Fallback caption",
        }],
        "captions": True,
        "resolver": "not_found",
    },
    {
        "name": "status6 sound resolved caption and ignored host returns",
        "mode": "normal",
        "now": 200,
        "records": [{
            "index": 1, "status": 6, "elapsed": 0, "target": 100,
            "sound": b"bell.wav", "sound_channel": 13,
            "sound_field_23": 0x3344, "sound_mode": 2,
            "sound_control": 0x89ABCDEF, "sound_scalar_2d": 75,
            "sound_scalar_2f": -23, "pairs": (),
            "caption": b"AUTO-KEY", "fallback": b"unused fallback",
        }],
        "captions": True,
        "resolver": "found",
        "resolved_text": b"Localized caption",
    },
    {
        "name": "status5 sound with captions disabled",
        "mode": "normal",
        "now": 200,
        "records": [{
            "index": 0, "status": 5, "elapsed": 0, "target": 100,
            "sound": b"chime.ogg", "sound_channel": 5,
            "sound_field_23": 0x1122, "sound_mode": 1,
            "sound_control": 0x01020304, "sound_scalar_2d": -7,
            "sound_scalar_2f": 29, "pairs": (),
            "caption": b"AUTO-KEY", "fallback": b"disabled fallback",
        }],
        "captions": False,
        "resolver": "unavailable",
    },
    {
        "name": "status5 non-due threshold only updates elapsed",
        "mode": "normal",
        "now": 200,
        "records": [{
            "index": 0, "status": 5, "elapsed": 0, "target": 250,
            "sound": b"bell.wav", "sound_channel": 1,
            "sound_field_23": 0x5566, "sound_mode": 3,
            "sound_control": 0xA1B2C3D4, "sound_scalar_2d": 12,
            "sound_scalar_2f": -19, "pairs": (),
            "caption": b"", "fallback": b"",
        }],
        "captions": False,
        "resolver": "unavailable",
    },
    {
        "name": "missing native sound host preserves original pre-call prefix",
        "mode": "normal",
        "now": 200,
        "stop_at_va": STOP_SOUND_DESCRIPTOR,
        "native_host_missing": True,
        "records": [{
            "index": 0, "status": 6, "elapsed": 0, "target": 100,
            "sound": b"bell.wav", "sound_channel": 9,
            "sound_field_23": 0x7788, "sound_mode": 4,
            "sound_control": 0xF1E2D3C4, "sound_scalar_2d": 31,
            "sound_scalar_2f": -32,
            "pairs": ((3, 21),), "caption": b"unused-key",
            "fallback": b"unused fallback",
        }],
        "captions": True,
        "resolver": "unavailable",
    },
    {
        "name": "normal midnight due update defers day-one flag to next frame",
        "mode": "normal",
        "now": 1000,
        "clock": {"minute": 59, "hour": 23, "day": 0,
                  "deadline": 1000, "interval": 5000,
                  "first_day_hour": 0, "first_day_flag": 17},
        "captions": False,
        "resolver": "unavailable",
    },
    {
        "name": "offmode pause subtract and restore guard suppress",
        "mode": "offmode",
        "now": 2000,
        "clock": {"run_elapsed": 1000, "scene_elapsed": 200,
                  "pause_tick": 1500, "restore_guard": 0},
        "records": [{
            "index": 0, "status": 1, "elapsed": 1300, "target": 500,
            "sound": b"NO SOUND", "sound_channel": 0, "pairs": (),
        }],
        "captions": False,
        "resolver": "unavailable",
    },
    {
        "name": "offmode restore guard prevents pause subtraction",
        "mode": "offmode",
        "now": 2000,
        "clock": {"run_elapsed": 1000, "scene_elapsed": 200,
                  "pause_tick": 1500, "restore_guard": 1},
        "records": [{
            "index": 0, "status": 1, "elapsed": 1300, "target": 500,
            "sound": b"NO SOUND", "sound_channel": 0, "pairs": (),
        }],
        "captions": False,
        "resolver": "unavailable",
    },
    {
        "name": "offmode equal pause mark does not subtract",
        "mode": "offmode",
        "now": 2000,
        "clock": {"run_elapsed": 1000, "scene_elapsed": 200,
                  "pause_tick": 2000, "restore_guard": 0},
        "records": [{
            "index": 0, "status": 1, "elapsed": 1300, "target": 500,
            "sound": b"NO SOUND", "sound_channel": 0, "pairs": (),
        }],
        "captions": False,
        "resolver": "unavailable",
    },
]


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_u32(machine: Uc, address: int) -> int:
    return int.from_bytes(machine.mem_read(address, 4), "little")


def read_i16(machine: Uc, address: int) -> int:
    return int.from_bytes(machine.mem_read(address, 2), "little", signed=True)


def write_u32(machine: Uc, address: int, value: int) -> None:
    machine.mem_write(address, (value & 0xFFFFFFFF).to_bytes(4, "little"))


def write_i16(machine: Uc, address: int, value: int) -> None:
    machine.mem_write(address, (value & 0xFFFF).to_bytes(2, "little"))


def c_string(machine: Uc, address: int, limit: int = 0x1000) -> bytes:
    result = bytearray()
    for offset in range(limit):
        byte = machine.mem_read(address + offset, 1)[0]
        if byte == 0:
            return bytes(result)
        result.append(byte)
    raise RuntimeError(f"unterminated controlled string at 0x{address:x}")


def make_fixture(scenario: dict[str, Any]) -> Fixture:
    fixture = Fixture()
    clock_spec = scenario.get("clock", {})
    fixture.clock.run_start_tick = 100
    fixture.clock.run_elapsed_ticks = clock_spec.get("run_elapsed", 0)
    fixture.clock.scene_elapsed_ticks = clock_spec.get("scene_elapsed", 0)
    fixture.clock.run_display_word_0 = 0
    fixture.clock.run_display_word_1 = 0
    fixture.clock.run_display_word_2 = 0
    fixture.clock.scene_display_word_0 = 0
    fixture.clock.scene_display_word_1 = 0
    fixture.clock.scene_display_word_2 = 0
    fixture.clock.total_minutes = 0
    fixture.clock.configured_minute = clock_spec.get("minute", 34)
    fixture.clock.configured_hour = clock_spec.get("hour", 12)
    fixture.clock.day_counter = clock_spec.get("day", 0)
    fixture.clock.next_update_tick = clock_spec.get("deadline", 10_000)
    fixture.clock.update_interval_ms = clock_spec.get("interval", 1000)
    fixture.clock.first_day_event_hour = clock_spec.get("first_day_hour", 0)
    fixture.clock.first_day_event_flag_id = clock_spec.get("first_day_flag", -1)
    fixture.clock.previous_tick_5d = clock_spec.get("pause_tick", 0)
    fixture.clock.previous_tick_61 = 0
    fixture.session.captions_enabled_5bb202 = int(scenario.get("captions", False))
    fixture.session.outside_window_flag_5bb20a = 0
    fixture.session.time_window_start_5b0284 = 0
    fixture.session.time_window_end_5b0286 = 1439

    for spec in scenario.get("records", []):
        fixture.put_record(
            spec["index"], status=spec.get("status", 0),
            elapsed=spec.get("elapsed", 0), target=spec.get("target", 0),
            done=spec.get("done", 0), sound=spec.get("sound", b"NO SOUND"),
            sound_channel=spec.get("sound_channel", 0),
            sound_field_23=spec.get("sound_field_23", 0),
            sound_mode=spec.get("sound_mode", 0),
            sound_control=spec.get("sound_control", 0),
            sound_scalar_2d=spec.get("sound_scalar_2d", 0),
            sound_scalar_2f=spec.get("sound_scalar_2f", 0),
            pairs=spec.get("pairs", ()),
            caption=spec.get("caption", b""),
            fallback=spec.get("fallback", b""),
        )
    return fixture


def set_field(address: int, value: int, width: int) -> None:
    if width == 4:
        original_machine.mem_write(address, (value & 0xFFFFFFFF).to_bytes(4, "little"))
    elif width == 2:
        write_i16(original_machine, address, value)
    else:
        raise AssertionError(width)


def snapshot_machine(machine: Uc, event_ids: list[int]) -> dict[str, Any]:
    records = bytes(machine.mem_read(TIME_RECORDS, RECORD_COUNT * RECORD_SIZE))
    return {
        "clock": {
            "run_start": read_u32(machine, 0x585D33),
            "run_elapsed": read_u32(machine, 0x585D37),
            "run_display": [read_i16(machine, address)
                            for address in (0x585D3B, 0x585D3D, 0x585D3F)],
            "scene_elapsed": read_u32(machine, 0x585D41),
            "scene_display": [read_i16(machine, address)
                              for address in (0x585D45, 0x585D47, 0x585D49)],
            "minute": read_i16(machine, 0x585D4F),
            "hour": read_i16(machine, 0x585D51),
            "day": read_i16(machine, 0x585D53),
            "total": int.from_bytes(machine.mem_read(0x585D4B, 4), "little", signed=True),
            "deadline": read_u32(machine, 0x585D55),
            "window": read_i16(machine, 0x5BB20A),
            "previous_tick_61": read_u32(machine, 0x585D61),
        },
        "records_hex": [records[i * RECORD_SIZE:(i + 1) * RECORD_SIZE].hex()
                        for i in range(RECORD_COUNT)],
        "flags": [int.from_bytes(machine.mem_read(EVENT_FLAGS + i * 4, 4),
                                  "little", signed=True)
                  for i in event_ids],
    }


def snapshot_native(fixture: Fixture, event_ids: list[int]) -> dict[str, Any]:
    clock = fixture.clock
    records = bytes(fixture.records)
    return {
        "clock": {
            "run_start": clock.run_start_tick,
            "run_elapsed": clock.run_elapsed_ticks,
            "run_display": [clock.run_display_word_0, clock.run_display_word_1,
                            clock.run_display_word_2],
            "scene_elapsed": clock.scene_elapsed_ticks,
            "scene_display": [clock.scene_display_word_0,
                              clock.scene_display_word_1,
                              clock.scene_display_word_2],
            "minute": clock.configured_minute,
            "hour": clock.configured_hour,
            "day": clock.day_counter,
            "total": clock.total_minutes,
            "deadline": clock.next_update_tick,
            "window": fixture.session.outside_window_flag_5bb20a,
            "previous_tick_61": clock.previous_tick_61,
        },
        "records_hex": [records[i * RECORD_SIZE:(i + 1) * RECORD_SIZE].hex()
                        for i in range(RECORD_COUNT)],
        "flags": [fixture.flags[i] for i in event_ids],
    }


def run_original(pe: PEImage, fixture: Fixture, scenario: dict[str, Any],
                 event_ids: list[int]) -> tuple[dict[str, Any], list[tuple], list[bytes]]:
    global original_machine
    original_machine = Uc(UC_ARCH_X86, UC_MODE_32)
    original_machine.mem_map(pe.image_base, align_up(pe.size_of_image))
    original_machine.mem_write(pe.image_base, pe.image)
    original_machine.mem_map(STACK, STACK_SIZE)
    original_machine.mem_map(EXTRA_BASE, EXTRA_SIZE)
    original_machine.mem_write(TICK_IAT, TICK_STUB.to_bytes(4, "little"))
    original_machine.mem_write(STACK_TOP - 4, RETURN_VA.to_bytes(4, "little"))
    original_machine.reg_write(UC_X86_REG_ESP, STACK_TOP - 4)
    original_machine.reg_write(UC_X86_REG_EBP, STACK + 0x10000)
    original_machine.reg_write(UC_X86_REG_EFLAGS, 0x202)

    c = fixture.clock
    values32 = [
        (0x583985, 14 if scenario["mode"] == "normal" else 0),
        (0x5E32B5, scenario.get("clock", {}).get("restore_guard", 0)),
        (0x585D33, c.run_start_tick),
        (0x585D37, c.run_elapsed_ticks),
        (0x585D41, c.scene_elapsed_ticks),
        (0x585D4B, c.total_minutes),
        (0x585D55, c.next_update_tick),
        (0x585D5D, c.previous_tick_5d),
        (0x585D61, c.previous_tick_61),
        (0x5BB202, fixture.session.captions_enabled_5bb202),
    ]
    for address, value in values32:
        write_u32(original_machine, address, value)
    write_i16(original_machine, 0x585D3B, c.run_display_word_0)
    write_i16(original_machine, 0x585D3D, c.run_display_word_1)
    write_i16(original_machine, 0x585D3F, c.run_display_word_2)
    write_i16(original_machine, 0x585D45, c.scene_display_word_0)
    write_i16(original_machine, 0x585D47, c.scene_display_word_1)
    write_i16(original_machine, 0x585D49, c.scene_display_word_2)
    write_i16(original_machine, 0x585D4F, c.configured_minute)
    write_i16(original_machine, 0x585D51, c.configured_hour)
    write_i16(original_machine, 0x585D53, c.day_counter)
    write_i16(original_machine, 0x585D59, c.first_day_event_hour)
    write_i16(original_machine, 0x585D5B, c.first_day_event_flag_id)
    write_i16(original_machine, 0x5B0280, c.update_interval_ms)
    write_i16(original_machine, 0x5B0284, fixture.session.time_window_start_5b0284)
    write_i16(original_machine, 0x5B0286, fixture.session.time_window_end_5b0286)
    write_i16(original_machine, 0x5BB20A, fixture.session.outside_window_flag_5bb20a)
    original_machine.mem_write(TIME_RECORDS, bytes(fixture.records))
    for index, value in enumerate(fixture.flags):
        write_u32(original_machine, EVENT_FLAGS + index * 4, value)
    for address in (0x583220, 0x58321F, 0x583229, 0x583232,
                    0x583233, 0x583234):
        original_machine.mem_write(address, b"\0")

    resolver_kind = scenario.get("resolver", "unavailable")
    resolved_bytes = scenario.get("resolved_text", b"")
    original_machine.mem_write(RESOLVED_TEXT, resolved_bytes + b"\0")
    events: list[tuple] = []
    resolver_calls: list[bytes] = []
    current_record = [-1]
    stop_va = scenario.get(
        "stop_at_va",
        STOP_NORMAL if scenario["mode"] == "normal" else STOP_OFFMODE,
    )
    stop_seen: list[int] = []
    tick_reads: list[int] = []

    def ret_from_call(uc: Uc, pop_bytes: int, eax: int = 0) -> None:
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = read_u32(uc, esp)
        uc.reg_write(UC_X86_REG_EAX, eax & 0xFFFFFFFF)
        uc.reg_write(UC_X86_REG_ESP, esp + 4 + pop_bytes)
        uc.reg_write(UC_X86_REG_EIP, ret)

    def on_code(uc: Uc, address: int, _size: int, _user: Any) -> None:
        if address == stop_va:
            stop_seen.append(address)
            uc.emu_stop()
            return
        if address == 0x43AC2F:
            record_pointer = uc.reg_read(UC_X86_REG_ECX)
            if TIME_RECORDS <= record_pointer < TIME_RECORDS + RECORD_COUNT * RECORD_SIZE:
                current_record[0] = (record_pointer - TIME_RECORDS) // RECORD_SIZE
            return
        if address == TICK_STUB:
            tick_reads.append(scenario["now"])
            ret_from_call(uc, 0, scenario["now"])
            return
        if address in (0x43D7F0, 0x4DADFF, 0x4F52A9,
                       0x4D36ED, 0x4E812F, 0x4FB086, 0x4FC05D):
            ret_from_call(uc, 0, 0)
            return
        if address == 0x4FB77A:
            esp = uc.reg_read(UC_X86_REG_ESP)
            descriptor_pointer = read_u32(uc, esp + 4)
            record_index = ((descriptor_pointer - TIME_RECORDS - 0x28) //
                            RECORD_SIZE)
            if not 0 <= record_index < RECORD_COUNT:
                raise AssertionError(
                    f"sound descriptor pointer outside timer records: "
                    f"0x{descriptor_pointer:x}"
                )
            descriptor = bytes(uc.mem_read(descriptor_pointer, 49))
            channel = int.from_bytes(descriptor[0x21:0x23], "little")
            events.append((EFFECT_LOAD_SOUND_DESCRIPTOR, record_index, 0,
                           channel, descriptor, b""))
            ret_from_call(uc, 4, 1)  # caller ignores the original return value
            return
        if address == 0x4FB2E3:
            esp = uc.reg_read(UC_X86_REG_ESP)
            channel = int.from_bytes(uc.mem_read(esp + 4, 2), "little")
            events.append((EFFECT_PLAY_SOUND_CHANNEL, current_record[0], 0,
                           channel, bytes(49), b""))
            ret_from_call(uc, 4, 1)  # caller ignores the original return value
            return
        if address == 0x423259:
            esp = uc.reg_read(UC_X86_REG_ESP)
            key_pointer = read_u32(uc, esp + 4)
            key = c_string(uc, key_pointer)
            resolver_calls.append(key)
            return_value = RESOLVED_TEXT if resolver_kind == "found" else 0
            ret_from_call(uc, 4, return_value)
            return
        if address == 0x448D11:
            esp = uc.reg_read(UC_X86_REG_ESP)
            text_pointer = read_u32(uc, esp + 8)
            text = c_string(uc, text_pointer)
            caption_source = (CAPTION_FROM_RESOLVER
                              if resolver_kind == "found" and
                              text == resolved_bytes + b"<n><e>"
                              else CAPTION_FROM_FALLBACK)
            events.append((EFFECT_SHOW_CAPTION, current_record[0],
                           caption_source, 0, bytes(49), text))
            ret_from_call(uc, 16, 1)  # caption helper's result is ignored
            return

    original_machine.hook_add(UC_HOOK_CODE, on_code)
    original_machine.emu_start(0x43A7CA, 0, timeout=30_000_000,
                               count=10_000_000)
    if stop_seen != [stop_va]:
        raise RuntimeError(
            f"{scenario['name']}: did not reach 0x{stop_va:x}; "
            f"eip=0x{original_machine.reg_read(UC_X86_REG_EIP):x}"
        )
    if tick_reads != [scenario["now"]]:
        raise RuntimeError(f"{scenario['name']}: unexpected tick reads {tick_reads}")

    snap = snapshot_machine(original_machine, event_ids)
    return snap, events, resolver_calls


def run_native(fixture: Fixture, scenario: dict[str, Any]):
    if scenario["mode"] == "offmode":
        result = test_world_clock.WorldClockResult()
        status = test_world_clock.WorldClockTests.lib.world_clock_update_offmode(
            c.byref(fixture.session), scenario["now"],
            scenario.get("clock", {}).get("restore_guard", 0), c.byref(result)
        )
        return status, result, [], []
    resolver_status = (RESOLVER_FOUND if scenario.get("resolver") == "found"
                       else RESOLVER_NOT_FOUND)
    if scenario.get("native_host_missing"):
        result = test_world_clock.WorldClockResult()
        status = test_world_clock.WorldClockTests.lib.world_clock_update_normal(
            c.byref(fixture.session), scenario["now"], None, c.byref(result)
        )
        return status, result, [], []
    recorder = SinkRecorder(
        emit_result=HOST_RETURNED_FAILURE_IGNORED,
        resolver_result=resolver_status,
        resolved_text=scenario.get("resolved_text", b""),
    )
    result = test_world_clock.WorldClockResult()
    status = test_world_clock.WorldClockTests.lib.world_clock_update_normal(
        c.byref(fixture.session), scenario["now"], c.byref(recorder.sink),
        c.byref(result)
    )
    return status, result, recorder.events, recorder.resolve_calls


def load_native_library():
    path = PROJECT / "build/libworldclock.dylib"
    if not path.is_file():
        raise RuntimeError(f"missing native library; run {PROJECT}/scripts/build_world_clock.sh")
    test_world_clock.WorldClockTests.lib = c.CDLL(str(path))
    lib = test_world_clock.WorldClockTests.lib
    lib.world_clock_update_normal.argtypes = [
        c.POINTER(test_world_clock.WorldClockSession), c.c_uint32,
        c.POINTER(test_world_clock.WorldClockEffectSink),
        c.POINTER(test_world_clock.WorldClockResult)
    ]
    lib.world_clock_update_normal.restype = c.c_int
    lib.world_clock_update_offmode.argtypes = [
        c.POINTER(test_world_clock.WorldClockSession), c.c_uint32, c.c_int,
        c.POINTER(test_world_clock.WorldClockResult)
    ]
    lib.world_clock_update_offmode.restype = c.c_int


def code_window_hashes(pe: PEImage) -> dict[str, dict[str, Any]]:
    result = {}
    for name, (begin, end) in CODE_WINDOWS.items():
        file_offset = pe.va_to_file_offset(begin, end - begin)
        raw = pe.data[file_offset:file_offset + end - begin]
        result[name] = {
            "start_va": hex(begin), "end_va_exclusive": hex(end),
            "length": len(raw), "sha256": sha(raw),
        }
    return result


def data_window_hashes(pe: PEImage) -> dict[str, dict[str, Any]]:
    result = {}
    for name, (begin, length) in DATA_WINDOWS.items():
        file_offset = pe.va_to_file_offset(begin, length)
        raw = pe.data[file_offset:file_offset + length]
        result[name] = {
            "start_va": hex(begin), "length": len(raw),
            "bytes_hex": raw.hex(), "sha256": sha(raw),
        }
    return result


def compare_scenarios(pe: PEImage) -> dict[str, Any]:
    comparisons = []
    assertions = 0
    for scenario in SCENARIOS:
        fixture = make_fixture(scenario)
        event_ids = sorted({index for index in range(len(fixture.flags))
                            if fixture.flags[index] != 0} |
                           {flag_id for record in scenario.get("records", [])
                            for flag_id, _ in record.get("pairs", [])
                            if flag_id >= 0} |
                           ({scenario.get("clock", {}).get("first_day_flag", -1)}
                            if scenario.get("mode") == "normal" else set()))
        event_ids = [index for index in event_ids if 0 <= index < len(fixture.flags)]
        original, original_events, original_resolves = run_original(
            pe, fixture, scenario, event_ids
        )
        native_status, native_result, native_events, native_resolves = run_native(
            fixture, scenario
        )
        native = snapshot_native(fixture, event_ids)

        if scenario["mode"] == "offmode":
            if native_status != CLOCK_ERR_CONTINUATION:
                raise AssertionError(f"{scenario['name']}: wrong native offmode status")
            if native_result.continuation_va != CONTINUE_OFFMODE_CLEANUP:
                raise AssertionError(f"{scenario['name']}: wrong offmode boundary")
            # The native clock kernel stops before post-arithmetic external
            # cleanup; compare only state that precedes those calls.
            for key in ("run_start", "run_elapsed", "scene_elapsed",
                        "previous_tick_61"):
                if native["clock"][key] != original["clock"][key]:
                    raise AssertionError(
                        f"{scenario['name']}: {key} native={native['clock'][key]} "
                        f"original={original['clock'][key]}"
                    )
            native_records = native["records_hex"]
            original_records = original["records_hex"]
            for index in range(RECORD_COUNT):
                n = bytearray.fromhex(native_records[index])
                o = bytearray.fromhex(original_records[index])
                n[8:20] = o[8:20]  # pause path must preserve display bytes
                if n != o:
                    raise AssertionError(
                        f"{scenario['name']}: record {index} differs after pause path"
                    )
            assertions += 1 + RECORD_COUNT
        elif scenario.get("native_host_missing"):
            if native_status != CLOCK_ERR_HOST_UNAVAILABLE:
                raise AssertionError(
                    f"{scenario['name']}: missing host status {native_status}"
                )
            if native_result.trigger != TRIGGER_SOUND_DESCRIPTOR:
                raise AssertionError(
                    f"{scenario['name']}: missing host trigger {native_result.trigger}"
                )
            if native["clock"] != original["clock"]:
                raise AssertionError(
                    f"{scenario['name']}: pre-sound clock prefix mismatch"
                )
            if native["records_hex"] != original["records_hex"]:
                raise AssertionError(
                    f"{scenario['name']}: pre-sound timer-record prefix mismatch"
                )
            if native["flags"] != original["flags"]:
                raise AssertionError(
                    f"{scenario['name']}: pre-sound event-flag prefix mismatch"
                )
            if (native_events or native_resolves or original_events or
                    original_resolves or native_result.effects_attempted != 0 or
                    native_result.partial_state_committed != 1):
                raise AssertionError(
                    f"{scenario['name']}: call-boundary side effects mismatch"
                )
            assertions += 6
        else:
            if native_status != CLOCK_OK:
                raise AssertionError(
                    f"{scenario['name']}: native status {native_status}"
                )
            if native["clock"] != original["clock"]:
                raise AssertionError(
                    f"{scenario['name']}: clock mismatch\n"
                    f"native={native['clock']}\noriginal={original['clock']}"
                )
            if native["records_hex"] != original["records_hex"]:
                for index, (left, right) in enumerate(zip(
                    native["records_hex"], original["records_hex"]
                )):
                    if left != right:
                        raise AssertionError(
                            f"{scenario['name']}: timer record {index} differs"
                        )
            if native["flags"] != original["flags"]:
                raise AssertionError(
                    f"{scenario['name']}: event flag mismatch "
                    f"native={native['flags']} original={original['flags']}"
                )
            if native_events != original_events:
                raise AssertionError(
                    f"{scenario['name']}: host event mismatch "
                    f"native={native_events} original={original_events}"
                )
            if native_resolves != original_resolves:
                raise AssertionError(
                    f"{scenario['name']}: caption resolver inputs mismatch "
                    f"native={native_resolves} original={original_resolves}"
                )
            if native_result.continuation_va != STOP_NORMAL:
                raise AssertionError(f"{scenario['name']}: wrong normal continuation")
            assertions += 5
        comparisons.append({
            "name": scenario["name"],
            "mode": scenario["mode"],
            "now": scenario["now"],
            "original_stop_va": hex(scenario.get(
                "stop_at_va",
                STOP_NORMAL if scenario["mode"] == "normal" else STOP_OFFMODE,
            )),
            "original_equals_native": True,
            "original_host_events": [
                {"kind": event[0], "record": event[1],
                 "caption_source": event[2], "sound_channel": event[3],
                 "descriptor_hex": event[4].hex(), "text_hex": event[5].hex()}
                for event in original_events
            ],
            "native_host_events": [
                {"kind": event[0], "record": event[1],
                 "caption_source": event[2], "sound_channel": event[3],
                 "descriptor_hex": event[4].hex(), "text_hex": event[5].hex()}
                for event in native_events
            ],
            "host_events_equal": native_events == original_events,
            "caption_resolver_inputs_hex": [value.hex()
                                            for value in original_resolves],
            "native_status": native_status,
            "native_continuation": hex(native_result.continuation_va),
        })

    return {"scenarios_executed": len(comparisons),
            "component_assertions": assertions,
            "comparisons": comparisons}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()
    load_native_library()
    pe = PEImage.parse_and_map(EXE)
    exe_hash = sha(pe.data)
    if exe_hash != EXPECTED_EXE_SHA256:
        raise SystemExit(f"GAME.EXE hash mismatch: {exe_hash}")

    comparisons = compare_scenarios(pe)
    hashes = {
        relative: sha((ROOT / relative).read_bytes())
        for relative in (
            "outputs/blackmoor-decomp/src/world_clock.h",
            "outputs/blackmoor-decomp/src/world_clock.c",
            "outputs/blackmoor-decomp/tests/test_world_clock.py",
            "outputs/blackmoor-decomp/tests/world_clock_original_oracle.py",
            "outputs/blackmoor-decomp/scripts/build_world_clock.sh",
            "outputs/blackmoor-decomp/src/world_init.h",
            "outputs/blackmoor-decomp/src/world_init.c",
            "outputs/blackmoor-decomp/src/action_core.h",
            "outputs/blackmoor-decomp/unverified-pseudocode/43a7ca.c.txt",
            "outputs/blackmoor-decomp/unverified-pseudocode/4fb77a.c.txt",
            "outputs/blackmoor-decomp/unverified-pseudocode/4fb2e3.c.txt",
        )
    }
    native_path = PROJECT / "build/libworldclock.dylib"
    hashes[str(native_path.relative_to(ROOT))] = sha(native_path.read_bytes())
    payload = {
        "schema": "blackmoor.s06-1-world-clock-kernel-oracle.v1",
        "executable": {"path": "work/original/GAME.EXE",
                       "sha256": exe_hash, "size_bytes": len(pe.data),
                       "image_base": hex(pe.image_base),
                       "unicorn": "2.1.4"},
        "code_windows": code_window_hashes(pe),
        "data_windows": data_window_hashes(pe),
        "native_comparison": comparisons,
        "controlled_hooks": [
            {"va": "IAT 0x52a23c", "purpose": "deterministic GetTickCount"},
            {"va": "0x43d7f0/0x4dadff", "purpose": "frame control and keyboard entry"},
            {"va": "0x4f52a9/0x4d36ed/0x4e812f/0x4fb086/0x4fc05d",
             "purpose": "offmode pump and caller-owned cleanup boundaries"},
            {"va": "0x4fb77a/0x4fb2e3",
             "purpose": "load exact 49-byte sound descriptor then play its uint16 channel; nonzero returns ignored by original caller"},
            {"va": "0x423259",
             "purpose": "caption/resource lookup boundary, controlled found/not-found result"},
            {"va": "0x448d11",
             "purpose": "caption presentation boundary; nonzero return used and ignored; suffix bytes are observable here"},
            {"va": "0x4fb77a",
             "purpose": "one original scenario stops at descriptor-load call entry to compare native unavailable-host prefix"},
            {"va": "0x43b13d/0x43ab78",
             "purpose": "stop before normal post-clock controller call, or after offmode arithmetic and original cleanup"},
        ],
        "unhooked_source_logic": [
            "0x43a7ca frame gates and sampled tick use",
            "0x43ab7d normal delta, display, records, completion and civil clock",
            "0x516530 NO SOUND comparison",
            "event flag writes",
            "0x433bd2 status-5 record reset",
            "caption suffix writes from 0x547214/0x54721c bytes <n><e> before 0x448d11",
        ],
        "assertions_passed": comparisons["component_assertions"],
        "input_sha256": hashes,
        "limits": [
            "The original oracle does not execute the post-clock 0x4d3c31/0x4d3d48 Boot-session controller path.",
            "Sound/resource/caption host helpers are controlled boundaries; their internal playback/rendering effects are not compared.",
            "Offmode native path deliberately stops before source cleanup calls at 0x43ab41; the original comparison checks only its preceding arithmetic and record prefix.",
            "Unicorn comparisons do not establish Windows process timing, full scene scheduling, live gameplay integration, or whole-game equivalence.",
            "Opcode-3's indexed table remains explicitly unsupported; no table extent or live producer was recovered.",
            "The native caption boundary preserves the original <n><e> suffix, but returns a bounds error when the copied source text would exceed the original 104-byte local buffer; this is a deliberate safe-port divergence from stack-overflowing original inputs.",
            "For the missing-host comparison, original execution is stopped at 0x4fb77a descriptor-load call entry and native returns its typed unavailable-host result at the same committed pre-call prefix."
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({
        "output": str(args.output),
        "executable_sha256": exe_hash,
        "scenarios": comparisons["scenarios_executed"],
        "component_assertions": comparisons["component_assertions"],
        "code_windows": len(payload["code_windows"]),
        "hashes": len(hashes),
    }, indent=2))


if __name__ == "__main__":
    # Delay binding the imported test module's library name until a caller
    # invokes run_native; main installs it before running the comparisons.
    import test_world_clock
    main()
