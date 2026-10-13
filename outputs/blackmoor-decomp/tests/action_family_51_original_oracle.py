#!/usr/bin/env python3
"""Compare raw action 0x51 (AT_MULTI_TEXTBOX_WRITE) with original GAME.EXE.

Two original code blocks run under Unicorn inside a synthetic stack frame:

* loader case 0x51 of 0x40b34a (0x40caac until the switch exit 0x410a68), with
  the shipped AUTOTEXT table built by the original initializer/insert code at
  its real object address 0x619a6b and looked up by the original 0x423259;
* executor case 0x51 of 0x427a50 (0x4281d3 until the switch exit 0x42a9a9),
  with the real completion routine 0x42ba3a.

Only host boundaries are intercepted: malloc (bounded arena), the dependency
gate, caption layout/drawing, the frame text box, sound-channel status,
GetTickCount, dependency reset and fatal/error reporting. Each interception is
listed in the report. This is per-action evidence, not a scene or game
equivalence claim.

Run from the workspace root with:

    work/tools/oracle-python/bin/python \\
        outputs/blackmoor-decomp/tests/action_family_51_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
from dataclasses import dataclass
import hashlib
import json
import struct
import sys
from pathlib import Path
from typing import Any, Iterable

from autotext_original_oracle import (
    ALLOC_LIMIT,
    ALLOCATOR_VA,
    RESOURCE_PATH as AUTOTEXT_RESOURCE,
    EXPECTED_EXE_SHA256,
    EXPECTED_RESOURCE_SHA256,
    INSERT_VA,
    KEY_VA,
    MAX_VALUE_BUFFER,
    TABLE_INIT_VA,
    VALUE_VA,
    OriginalAutoText,
    OracleError,
    _read_cvtx_payload,
    parse_entries,
)
from hiff_original_oracle import DEFAULT_EXE, sha256
import test_action_family_51 as native


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_NATIVE = PROJECT / "build/libactionfamily51.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/slices/A-51.validation.json"
DEFAULT_MARKDOWN = ROOT / "work/analysis/slices/A-51.validation.md"

LOADER_CASE_VA = 0x40CAAC
LOADER_CASE_END_VA = 0x40CF87
LOADER_EXIT_VA = 0x410A68
EXECUTOR_CASE_VA = 0x4281D3
EXECUTOR_CASE_END_VA = 0x42842C
EXECUTOR_EXIT_VA = 0x42A9A9
COMPLETION_VA = 0x42BA3A
COMPLETION_END_VA = 0x42BABF

AUTOTEXT_TABLE_VA = 0x619A6B
SLOT_INDEX_VA = 0x5C39E3
SCENE_ID_VA = 0x5BB57B
SLOT_TYPE_VA = 0x5BB5E3
SLOT_SUBTYPE_VA = 0x5BB5E4
SLOT_PAYLOAD_VA = 0x5BB5E5
SLOT_DEPS_VA = 0x5BB5E9
SLOT_DONE_VA = 0x5BB625
SLOT_PHASE_VA = 0x5BB632
DEBUG_LOG_VA = 0x63A4CD
TIMER_DEADLINE_VA = 0x5BB226
FRAME_TEXT_FLAG_VA = 0x5B1606
CAPTION_FINISH_FLAG_VA = 0x5B1602
CAPTION_HANDLE_VA = 0x5D03B3
CAPTION_OBJECT = 0x619A05
FRAME_TEXT_OBJECT = 0x61F864
SOUND_OBJECT = 0x5CF1EB
DEPENDENCY_OBJECT = 0x63786D
GET_TICK_COUNT_IAT = 0x52A23C

SPRINTF_VA = 0x50CA3E
MESSAGE_VA = 0x52139C
DEBUG_PRINT_VA = 0x44A2B7
QUIT_VA = 0x4C97B4
ALLOC_ERROR_VA = 0x42639D
GATE_VA = 0x423F57
LAYOUT_VA = 0x448D11
FRAME_OPEN_VA = 0x4DE24F
FRAME_CLOSE_VA = 0x4DE2D8
CHANNEL_STATUS_VA = 0x4F6334
DEPENDENCY_RESET_VA = 0x423D33

STUB_BASE = 0x31000000
TICK_STUB_VA = STUB_BASE + 0x10
BODY_BASE = 0x40000000
BODY_SIZE = 0x20000
FRAME_EBP = 0x1000C000
CAPTION_HANDLE = 0x0BADC0DE
FILL = 0xA5


@dataclass
class LoaderCase:
    label: str
    body: bytes
    corpus: str | None = None
    note: str = ""
    # Native status required when the original loader quits.
    fatal_status: int | None = None


@dataclass
class ExecutorCase:
    label: str
    payload: bytes
    phase: int
    subtype: int = 1
    eligible: int = 1
    completed: int = 0
    lines: int = 1
    playing: int = 0
    ticks: tuple[int, ...] = ()
    world: tuple[int, int, int] = (0, 7, 0)
    corpus: str | None = None


class OriginalAction51(OriginalAutoText):
    """Original x86 machine with the AUTOTEXT table at its game address."""

    def __init__(self, executable: Path) -> None:
        super().__init__(executable)
        from unicorn import UC_HOOK_CODE, UC_PROT_ALL

        self.machine.mem_map(STUB_BASE, 0x1000, UC_PROT_ALL)
        self.machine.mem_write(STUB_BASE, b"\xCC" * 0x1000)
        self.machine.mem_map(BODY_BASE, BODY_SIZE, UC_PROT_ALL)
        self.machine.mem_write(GET_TICK_COUNT_IAT, struct.pack("<I", TICK_STUB_VA))
        self.machine.mem_write(DEBUG_LOG_VA, b"\0\0")
        self.machine.mem_write(CAPTION_HANDLE_VA, struct.pack("<I", CAPTION_HANDLE))
        self.events: list[tuple[Any, ...]] = []
        self.allocations: list[tuple[int, int]] = []
        self.gate = 1
        self.lines = 1
        self.playing = 0
        self.ticks: list[int] = []
        self.fail_allocation = False
        self.handlers = {
            MESSAGE_VA: (0xC, self._on_message),
            DEBUG_PRINT_VA: (0, self._on_debug),
            QUIT_VA: (0, self._on_quit),
            ALLOC_ERROR_VA: (8, self._on_alloc_error),
            GATE_VA: (8, self._on_gate),
            LAYOUT_VA: (0x10, self._on_layout),
            FRAME_OPEN_VA: (8, self._on_frame_open),
            FRAME_CLOSE_VA: (0, self._on_frame_close),
            CHANNEL_STATUS_VA: (4, self._on_channel),
            DEPENDENCY_RESET_VA: (4, self._on_dependency_reset),
            TICK_STUB_VA: (0, self._on_tick),
        }
        for address in self.handlers:
            self.machine.hook_add(UC_HOOK_CODE, self._on_boundary,
                                  begin=address, end=address)

    # The parent allocator zero-fills; record sizes, fill with a pattern and
    # model malloc failure for sizes the 16-bit loader arithmetic made huge.
    def _on_code(self, uc: Any, address: int, _size: int, _user: Any) -> None:
        if address != ALLOCATOR_VA:
            return
        esp = uc.reg_read(self._reg["ESP"])
        requested = struct.unpack("<I", uc.mem_read(esp + 4, 4))[0]
        start = (self._allocator_cursor + 3) & ~3
        if requested == 0 or start + requested > ALLOC_LIMIT:
            self.allocations.append((0, requested))
            uc.reg_write(self._reg["EAX"], 0)
        else:
            uc.mem_write(start, bytes([FILL]) * requested)
            self._allocator_cursor = start + requested
            self.allocations.append((start, requested))
            uc.reg_write(self._reg["EAX"], start)
        self._return_from_intercepted_call(uc)

    def _arg(self, index: int) -> int:
        esp = self.machine.reg_read(self._reg["ESP"])
        return struct.unpack("<I", self.machine.mem_read(esp + 4 + 4 * index, 4))[0]

    def _c_string(self, address: int, limit: int = 0x10000) -> bytes:
        data = bytearray()
        while len(data) < limit:
            chunk = bytes(self.machine.mem_read(address + len(data), 0x100))
            end = chunk.find(b"\0")
            if end >= 0:
                return bytes(data + chunk[:end])
            data += chunk
        raise OracleError(f"unterminated original string at 0x{address:08x}")

    def _on_boundary(self, uc: Any, address: int, _size: int, _user: Any) -> None:
        pop, handler = self.handlers[address]
        value = handler()
        if value is not None:
            uc.reg_write(self._reg["EAX"], value & 0xFFFFFFFF)
        esp = uc.reg_read(self._reg["ESP"])
        return_address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
        uc.reg_write(self._reg["ESP"], esp + 4 + pop)
        uc.reg_write(self._reg["EIP"], return_address)

    def _on_message(self) -> int:
        self.events.append(("message", self._c_string(self._arg(0))))
        return 0

    def _on_debug(self) -> int:
        self.events.append(("debug", self._c_string(self._arg(0))))
        return 0

    def _on_quit(self) -> int:
        self.events.append(("quit",))
        return 0

    def _on_alloc_error(self) -> int:
        self.events.append(("allocation_error",))
        return 0

    def _on_gate(self) -> int:
        self.events.append(("gate", self._arg(0), self._arg(1),
                            self.machine.reg_read(self._reg["ECX"])))
        return self.gate

    def _on_layout(self) -> int:
        ecx = self.machine.reg_read(self._reg["ECX"])
        handle, text, width, measure = (self._arg(index) for index in range(4))
        if ecx != CAPTION_OBJECT or handle != CAPTION_HANDLE or width != 0xFFFFFFFF:
            raise OracleError(f"unexpected 0x448d11 call: ecx=0x{ecx:x} handle=0x{handle:x}")
        text_bytes = self._c_string(text)
        if measure == 1:
            self.events.append(("measure", text_bytes))
            return self.lines & 0xFFFF
        if measure != 0:
            raise OracleError(f"unexpected 0x448d11 mode {measure}")
        self.events.append(("write_caption", text_bytes))
        return 0

    def _on_frame_open(self) -> int:
        if self.machine.reg_read(self._reg["ECX"]) != FRAME_TEXT_OBJECT:
            raise OracleError("0x4de24f called on an unexpected object")
        self.events.append(("open_frame_text", self._arg(0), self._c_string(self._arg(1))))
        return 0

    def _on_frame_close(self) -> int:
        if self.machine.reg_read(self._reg["ECX"]) != FRAME_TEXT_OBJECT:
            raise OracleError("0x4de2d8 called on an unexpected object")
        self.events.append(("close_frame_text",))
        return 0

    def _on_channel(self) -> int:
        if self.machine.reg_read(self._reg["ECX"]) != SOUND_OBJECT:
            raise OracleError("0x4f6334 called on an unexpected object")
        channel = struct.unpack("<i", struct.pack("<I", self._arg(0)))[0]
        self.events.append(("is_channel_playing", channel))
        return self.playing

    def _on_tick(self) -> int:
        value = self.ticks.pop(0) if self.ticks else 0
        self.events.append(("tick_count", value))
        return value

    def _on_dependency_reset(self) -> int:
        ecx = self.machine.reg_read(self._reg["ECX"])
        tree = self._arg(0)
        if ecx != DEPENDENCY_OBJECT or tree != SLOT_DEPS_VA:
            raise OracleError(f"unexpected 0x423d33 call: ecx=0x{ecx:x} tree=0x{tree:x}")
        self.events.append(("reset_dependencies", tree))
        return 0

    def install_table(self, entries: list[dict[str, Any]],
                      extra: Iterable[tuple[bytes, bytes]] = ()) -> None:
        self._call(TABLE_INIT_VA, (), AUTOTEXT_TABLE_VA, "caption table init")
        rows = [(entry["key_field"], entry["raw_value"]) for entry in entries]
        rows.extend((key.ljust(33, b"\0"), value) for key, value in extra)
        for key_field, raw_value in rows:
            if len(raw_value) >= MAX_VALUE_BUFFER:
                raise OracleError("table value exceeds the original 40000-byte buffer")
            self.machine.mem_write(KEY_VA, key_field)
            self.machine.mem_write(VALUE_VA, bytes(MAX_VALUE_BUFFER))
            self.machine.mem_write(VALUE_VA, raw_value)
            self._call(INSERT_VA, (KEY_VA, VALUE_VA), AUTOTEXT_TABLE_VA,
                       "caption entry insert")

    def _run_block(self, start: int, stop: int, label: str) -> None:
        self._hook_error = None
        frame = bytes([0xCC]) * 0x800
        self.machine.mem_write(FRAME_EBP - 0x600, frame)
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI"):
            self.machine.reg_write(self._reg[name], 0)
        self.machine.reg_write(self._reg["EBP"], FRAME_EBP)
        self.machine.reg_write(self._reg["ESP"], FRAME_EBP - 0x600)
        self.machine.reg_write(self._reg["EFLAGS"], 0x202)

    def run_loader(self, body: bytes) -> dict[str, Any]:
        self.events = []
        self.allocations = []
        self._run_block(LOADER_CASE_VA, LOADER_EXIT_VA, "loader")
        self.machine.mem_write(BODY_BASE, bytes(BODY_SIZE))
        self.machine.mem_write(BODY_BASE, body)
        self.machine.mem_write(FRAME_EBP - 0x20, struct.pack("<I", BODY_BASE))
        self.machine.mem_write(FRAME_EBP - 0xCC, struct.pack("<I", 0))
        self.machine.mem_write(SLOT_INDEX_VA, struct.pack("<h", 0))
        self.machine.mem_write(SCENE_ID_VA, struct.pack("<I", 5900))
        self.machine.mem_write(SLOT_PAYLOAD_VA, struct.pack("<I", 0xDEADBEEF))
        self._emulate(LOADER_CASE_VA, LOADER_EXIT_VA, "loader case 0x51")
        cursor = struct.unpack("<I", self.machine.mem_read(FRAME_EBP - 0x20, 4))[0]
        consumed = struct.unpack("<I", self.machine.mem_read(FRAME_EBP - 0xCC, 4))[0]
        pointer = struct.unpack("<I", self.machine.mem_read(SLOT_PAYLOAD_VA, 4))[0]
        fatal = any(event[0] == "quit" for event in self.events)
        payload = b""
        if not fatal:
            matches = [size for start, size in self.allocations if start == pointer]
            if len(matches) != 1:
                raise OracleError("loader payload pointer does not match one allocation")
            payload = bytes(self.machine.mem_read(pointer, matches[0]))
        return {
            "advance": cursor - BODY_BASE,
            "consumed": consumed,
            "fatal": fatal,
            "payload": payload,
            "events": [event for event in self.events if event[0] != "debug"],
        }

    def run_executor(self, case: ExecutorCase) -> dict[str, Any]:
        self.events = []
        self.allocations = []
        self.gate = case.eligible
        self.lines = case.lines
        self.playing = case.playing
        self.ticks = list(case.ticks)
        self._run_block(EXECUTOR_CASE_VA, EXECUTOR_EXIT_VA, "executor")
        pointer = BODY_BASE + 0x100
        self.machine.mem_write(BODY_BASE, bytes(0x2000))
        self.machine.mem_write(pointer, case.payload)
        self.machine.mem_write(FRAME_EBP - 0x11C, struct.pack("<h", 0))
        self.machine.mem_write(SLOT_TYPE_VA, bytes([0x51, case.subtype]))
        self.machine.mem_write(SLOT_PAYLOAD_VA, struct.pack("<I", pointer))
        self.machine.mem_write(SLOT_DONE_VA, bytes([case.completed]))
        self.machine.mem_write(SLOT_PHASE_VA, struct.pack("<I", case.phase))
        deadline, frame_flag, caption_flag = case.world
        self.machine.mem_write(TIMER_DEADLINE_VA, struct.pack("<I", deadline))
        self.machine.mem_write(FRAME_TEXT_FLAG_VA, struct.pack("<i", frame_flag))
        self.machine.mem_write(CAPTION_FINISH_FLAG_VA, struct.pack("<i", caption_flag))
        self._emulate(EXECUTOR_CASE_VA, EXECUTOR_EXIT_VA, "executor case 0x51")
        gate_events = [event for event in self.events if event[0] == "gate"]
        if len(gate_events) != 1 or gate_events[0][1:] != (SLOT_DEPS_VA, 0, DEPENDENCY_OBJECT):
            raise OracleError(f"unexpected dependency gate call: {gate_events}")
        return {
            "phase": struct.unpack("<I", self.machine.mem_read(SLOT_PHASE_VA, 4))[0],
            "completed": self.machine.mem_read(SLOT_DONE_VA, 1)[0],
            "payload": bytes(self.machine.mem_read(pointer, len(case.payload))),
            "world": (
                struct.unpack("<I", self.machine.mem_read(TIMER_DEADLINE_VA, 4))[0],
                struct.unpack("<i", self.machine.mem_read(FRAME_TEXT_FLAG_VA, 4))[0],
                struct.unpack("<i", self.machine.mem_read(CAPTION_FINISH_FLAG_VA, 4))[0],
            ),
            "calls": [event for event in self.events
                      if event[0] not in ("gate", "reset_dependencies")],
            "reset_dependencies": any(event[0] == "reset_dependencies" for event in self.events),
        }

    def _emulate(self, start: int, stop: int, label: str) -> None:
        try:
            self.machine.emu_start(start, stop, timeout=20_000_000, count=5_000_000)
        except Exception as exc:  # noqa: BLE001 - Unicorn raises UcError
            eip = self.machine.reg_read(self._reg["EIP"])
            raise OracleError(f"original {label} trapped at 0x{eip:08x}: {exc}") from exc
        if self._hook_error:
            raise OracleError(self._hook_error)
        eip = self.machine.reg_read(self._reg["EIP"])
        if eip != stop:
            raise OracleError(f"original {label} stopped at 0x{eip:08x}")
        esp = self.machine.reg_read(self._reg["ESP"])
        if esp != FRAME_EBP - 0x600:
            raise OracleError(f"original {label} unbalanced stack: ESP=0x{esp:08x}")


def corpus_cases() -> list[tuple[str, int, bytes]]:
    return [(name, index, raw) for name, index, _subtype, raw in native.corpus_records()]


def loader_cases(corpus: list[tuple[str, int, bytes]]) -> list[LoaderCase]:
    cases = [LoaderCase(f"corpus-{name}-{index}", raw, corpus=f"{name}#{index}")
             for name, index, raw in corpus]
    header = native.header
    cases.extend([
        LoaderCase("auto-text-case-folded-key", native.auto_text_body(b"mdm57a", renderer=0)),
        LoaderCase("auto-text-missing-key", native.auto_text_body(b"ZZNOPE", wait=2,
                                                                 milliseconds=77)),
        LoaderCase("auto-text-empty-key", native.auto_text_body(b"")),
        LoaderCase("auto-text-key-with-trailing-bytes",
                   header(selector=-1) + b"EATING\0garbage".ljust(33, b"\x7f")),
        LoaderCase("auto-text-32-byte-key-missing", native.auto_text_body(b"K" * 32)),
        LoaderCase("auto-text-max-record", native.auto_text_body(b"A51MAX")),
        LoaderCase("auto-text-allocation-overflow", native.auto_text_body(b"A51OVER"),
                   note="(short)(strlen+16) is negative; original malloc fails",
                   fatal_status=native.ERR_LIMIT),
        LoaderCase("inline-empty", header(renderer=2, selector=0)),
        LoaderCase("inline-unterminated", native.inline_body(b"abc", renderer=1)),
        LoaderCase("inline-max", header(selector=9999) + bytes(range(256)) * 39 + bytes(15)),
        LoaderCase("inline-limit-fatal", header(selector=10000) + bytes(10000),
                   fatal_status=native.ERR_BODY),
        LoaderCase("inline-selector-minus-two", header(selector=-2) + bytes(64),
                   note="original builds a malformed record; native rejects"),
    ])
    return cases


EXTRA_TABLE = ((b"A51MAX", b"m" * 32751), (b"A51OVER", b"o" * 32752))


def native_loader(library: Any, autotext: native.AutoTextLibrary,
                  extra: dict[bytes, bytes], body: bytes) -> dict[str, Any]:
    class Lookup:
        def __init__(self) -> None:
            self.held = None
            self.callback = native.LOOKUP(self.lookup)

        def lookup(self, context, key, key_length, text, text_length):
            name = bytes(key[:key_length])
            for extra_key, value in extra.items():
                if name.upper() == extra_key.upper():
                    self.held = native.buffer(value)
                    text[0] = c.cast(self.held, c.POINTER(c.c_uint8))
                    text_length[0] = len(value)
                    return native.LOOKUP_FOUND
            return autotext.callback(context, key, key_length, text, text_length)

    lookup = Lookup()
    length = c.c_size_t()
    status = library.action_family_51_body_length(native.buffer(body), len(body),
                                                  c.byref(length))
    if status != native.OK:
        return {"status": status, "advance": 0, "payload": b""}
    status, payload, decoded = native.decode(library, body[:length.value], lookup)
    if status != native.OK:
        return {"status": status, "advance": 0, "payload": b""}
    return {"status": status, "advance": decoded.body_length, "payload": bytes(payload),
            "source": decoded.source}


def executor_cases(records: list[tuple[str, bytes]]) -> list[ExecutorCase]:
    def payload(renderer: int, wait: int, channel: int = 12, milliseconds: int = 500,
                text: bytes = b"Line one<n>Line two") -> bytes:
        body = native.header(renderer, wait, channel, milliseconds, -1)
        return body[:10] + struct.pack("<H", len(text) + 3) + text + b"<e>\0"

    cases: list[ExecutorCase] = []
    for renderer in (0, 1, 2, 3):
        for wait in (0, 1, 2, 5):
            for lines in ((1, 2, 3, 40) if renderer == 0 else (1,)):
                for outcome in (0, 1):
                    ticks = (1000, 1000 + 600 * outcome) if wait == 2 else ()
                    cases.append(ExecutorCase(
                        f"start-r{renderer}-w{wait}-l{lines}-o{outcome}",
                        payload(renderer, wait), phase=0, lines=lines,
                        playing=1 - outcome, ticks=ticks))
    for wait in (0, 1, 2, 5):
        for outcome in (0, 1):
            cases.append(ExecutorCase(
                f"wait-w{wait}-o{outcome}", payload(2, wait), phase=1,
                playing=1 - outcome, ticks=(1500 + outcome,), world=(1500, 7, 0)))
    cases.append(ExecutorCase("wait-timer-wraps-on-start", payload(2, 2, milliseconds=100),
                              phase=0, ticks=(0xFFFFFFF0, 0xFFFFFFF0)))
    cases.append(ExecutorCase("wait-shared-deadline", payload(1, 2), phase=1,
                              ticks=(10,), world=(9, 3, 1)))
    for renderer in (0, 1, 2, 3):
        for subtype in (0, 1, 2):
            for completed in (0, 1):
                cases.append(ExecutorCase(
                    f"finish-r{renderer}-s{subtype}-c{completed}", payload(renderer, 1),
                    phase=2, subtype=subtype, completed=completed))
    for phase in (0, 1, 2, 3, 7):
        cases.append(ExecutorCase(f"gate-closed-p{phase}", payload(0, 2), phase=phase,
                                  subtype=2, eligible=0, completed=1))
    cases.append(ExecutorCase("phase-out-of-range", payload(0, 2), phase=3))
    cases.append(ExecutorCase("signed-channel", payload(2, 1, channel=-3), phase=1,
                              playing=0))

    # Every corpus record through start, wait and finish.
    for label, record in records:
        cases.append(ExecutorCase(f"{label}-start", record, phase=0, lines=2,
                                  playing=1, ticks=(5000, 5000), corpus=label))
        cases.append(ExecutorCase(f"{label}-start-long", record, phase=0, lines=3,
                                  playing=0, ticks=(5000, 0xFFFFFFFF), corpus=label))
        cases.append(ExecutorCase(f"{label}-wait", record, phase=1, playing=0,
                                  ticks=(0xFFFFFFFF,), corpus=label))
        cases.append(ExecutorCase(f"{label}-finish", record, phase=2, corpus=label))
    return cases


def native_executor(library: Any, case: ExecutorCase) -> dict[str, Any]:
    record = native.buffer(case.payload)
    backend = native.RecordingBackend(lines=case.lines, playing=case.playing,
                                      ticks=case.ticks)
    world = native.World(*case.world)
    status, result, world, backend = native.step(
        library, record, phase=case.phase, subtype=case.subtype,
        eligible=case.eligible, completed=case.completed, world=world, backend=backend)
    if status != native.OK:
        raise OracleError(f"native step failed for {case.label}: status {status}")
    return {
        "phase": result.phase,
        "completed": result.completed,
        "payload": bytes(record[:len(case.payload)]),
        "world": (world.timer_deadline, world.frame_text_flag, world.caption_finish_flag),
        "calls": backend.calls,
        "reset_dependencies": bool(result.reset_dependencies),
    }


def code_hash(pe: Any, start: int, end: int) -> str:
    """SHA-256 of the mapped .text bytes for a VA range."""
    offset = start - pe.image_base
    return hashlib.sha256(pe.image[offset:offset + end - start]).hexdigest()


def describe(value: Any) -> Any:
    if isinstance(value, bytes):
        return value.hex()
    if isinstance(value, (list, tuple)):
        return [describe(item) for item in value]
    return value


def run(args: argparse.Namespace) -> dict[str, Any]:
    for path in (args.exe, args.native_library, native.SCENE_LIBRARY,
                 native.AUTOTEXT_LIBRARY, AUTOTEXT_RESOURCE):
        if not path.is_file():
            raise OracleError(f"required input unavailable: {path}")
    resource = AUTOTEXT_RESOURCE.read_bytes()
    if sha256(resource) != EXPECTED_RESOURCE_SHA256:
        raise OracleError("AUTOTEXT resource hash mismatch")
    entries = parse_entries(_read_cvtx_payload(resource))
    machine = OriginalAction51(args.exe)
    if sha256(machine.pe.data) != EXPECTED_EXE_SHA256:
        raise OracleError("GAME.EXE hash mismatch")
    machine.install_table(entries, EXTRA_TABLE)
    library = native.bind(args.native_library)
    autotext = native.AutoTextLibrary()
    extra = dict(EXTRA_TABLE)

    corpus = corpus_cases()
    if len(corpus) != 97:
        raise OracleError(f"expected 97 corpus 0x51 records, found {len(corpus)}")

    loader_results: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []
    divergences: list[dict[str, Any]] = []
    corpus_payloads: list[tuple[str, bytes]] = []
    sources = {"inline": 0, "auto_text": 0, "missing_auto_text": 0}
    for case in loader_cases(corpus):
        original = machine.run_loader(case.body)
        mine = native_loader(library, autotext, extra, case.body)
        if case.label == "inline-selector-minus-two":
            divergences.append({
                "case": case.label,
                "original_advance": original["advance"],
                "original_fatal": original["fatal"],
                "original_payload_hex": original["payload"].hex(),
                "native_status": mine["status"],
                "reason": case.note,
            })
            continue
        if original["fatal"]:
            same = (case.fatal_status is not None and mine["status"] == case.fatal_status
                    and original["advance"] == 0)
        else:
            same = (mine["status"] == native.OK and
                    original["advance"] == mine["advance"] == original["consumed"] and
                    original["payload"] == mine["payload"])
        entry = {
            "case": case.label,
            "corpus": case.corpus,
            "body_bytes": original["advance"],
            "fatal": original["fatal"],
            "payload_bytes": len(original["payload"]),
            "payload_sha256": hashlib.sha256(original["payload"]).hexdigest(),
            "original_events": describe(original["events"]),
            "native_status": mine["status"],
        }
        loader_results.append(entry)
        if not same:
            mismatches.append({**entry, "native_advance": mine["advance"],
                               "original_payload_hex": original["payload"].hex(),
                               "native_payload_hex": mine["payload"].hex()})
        if case.corpus is not None:
            corpus_payloads.append((case.corpus, original["payload"]))
            sources[("inline", "auto_text", "missing_auto_text")[mine["source"]]] += 1

    executor_results: list[dict[str, Any]] = []
    branch_hits: set[str] = set()
    for case in executor_cases(corpus_payloads):
        original = machine.run_executor(case)
        mine = native_executor(library, case)
        keys = ("phase", "completed", "payload", "world", "calls", "reset_dependencies")
        diff = [key for key in keys if original[key] != mine[key]]
        executor_results.append({
            "case": case.label,
            "phase_before": case.phase,
            "phase_after": original["phase"],
            "calls": describe(original["calls"]),
        })
        for call in original["calls"]:
            branch_hits.add(call[0])
        if original["reset_dependencies"]:
            branch_hits.add("reset_dependencies")
        if diff:
            mismatches.append({
                "case": case.label,
                "fields": diff,
                "original": describe([original[key] for key in diff]),
                "native": describe([mine[key] for key in diff]),
            })

    pe = machine.pe
    report = {
        "scope": "raw action 0x51 loader record construction and executor visit; "
                 "not a scene, renderer, or full-game comparison",
        "original_sha256": sha256(pe.data),
        "autotext_resource_sha256": sha256(resource),
        "native_library_sha256": hashlib.sha256(
            args.native_library.resolve().read_bytes()).hexdigest(),
        "original_execution": "original GAME.EXE PE32 x86 code blocks under Unicorn 2.1.4",
        "native_execution": "ARM64 macOS C shared library",
        "code_ranges": [
            {"name": "loader case 0x51 (0x40b34a)", "start": hex(LOADER_CASE_VA),
             "end_exclusive": hex(LOADER_CASE_END_VA),
             "sha256": code_hash(pe, LOADER_CASE_VA, LOADER_CASE_END_VA),
             "boundary_basis": "jump-table target 0x410ca4[0x410e9c[0x47]] to next case label"},
            {"name": "executor case 0x51 (0x427a50)", "start": hex(EXECUTOR_CASE_VA),
             "end_exclusive": hex(EXECUTOR_CASE_END_VA),
             "sha256": code_hash(pe, EXECUTOR_CASE_VA, EXECUTOR_CASE_END_VA),
             "boundary_basis": "jump-table target 0x42a9b4[0x42aba4[0x47]] to next case label"},
            {"name": "completion 0x42ba3a", "start": hex(COMPLETION_VA),
             "end_exclusive": hex(COMPLETION_END_VA),
             "sha256": code_hash(pe, COMPLETION_VA, COMPLETION_END_VA),
             "boundary_basis": "function entry to byte after ret"},
        ],
        "original_code_left_real": [
            "0x40caac..0x40cf87 loader case: body cursor, key copy, record build",
            "0x423097 / 0x423142 AUTOTEXT table init and insert at 0x619a6b",
            "0x423259 AUTOTEXT lookup (hash, ASCII case folding)",
            "0x50ca3e sprintf for the missing-key message",
            "0x4281d3..0x42842c executor case: renderer select, waits, finish",
            "0x42ba3a completion (phase reset, subtype 1/2 completion flag)",
        ],
        "intercepted_boundaries": {
            "0x51dc43": "malloc: bounded arena filled with 0xa5; returns 0 for sizes "
                        "outside the arena (models failure of negative 16-bit sizes). "
                        "Size 0 also returns 0, unlike MSVC; only unsupported selectors "
                        "-15..-13 could request it",
            "0x423f57": "dependency gate result (shared scene_dependencies kernel)",
            "0x448d11": "caption layout: line-count measure (mode 1) and draw (mode 0)",
            "0x4de24f / 0x4de2d8": "frame text box open (mode 2) and close",
            "0x4f6334": "sound-channel playing status",
            "GetTickCount (IAT 0x52a23c)": "scripted tick values",
            "0x423d33": "dependency-tree reset after subtype-2 completion",
            "0x52139c / 0x44a2b7 / 0x42639d / 0x4c97b4": "error message, debug log, "
                "allocation error report, PostQuitMessage (fatal)",
        },
        "controlled_globals": {
            "0x63a4cd": "0 (debug logging off)",
            "0x5c39e3": "slot index 0",
            "0x5d03b3": "sentinel caption handle",
        },
        "corpus": {
            "records": len(corpus),
            "sources": sources,
            "subtypes": sorted({_s for _n, _i, _s, _r in native.corpus_records()}),
        },
        "loader_cases": len(loader_results),
        "executor_cases": len(executor_results),
        "executor_boundary_calls_observed": sorted(branch_hits),
        "loader": loader_results,
        "executor": executor_results,
        "intentional_divergences": divergences,
        "mismatches": mismatches,
        "unverified": [
            "AUTOTEXT text longer than 40000 bytes: unreachable with the shipped CVTX "
            "loader (values are below 40000); native ERR_LIMIT follows the disassembly",
            "renderer behaviour inside 0x448d11 and 0x4de24f/0x4de2d8 (caption layout "
            "and frame text box belong to S05/UI work). These are stubbed without side "
            "effects here, so their own writes to 0x5b1602/0x5b1606 and caption-object "
            "state are not compared",
            "the 0x5b1606 and 0x5b1602 flags' consumers",
            "wait mode 0 completion: no path in this handler; whether another "
            "system ends such actions is outside this packet",
            "debug-mode (0x63a4cd != 0) logging and message boxes",
        ],
    }
    return report


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# A-51 original-code validation",
        "",
        report["scope"] + ".",
        "",
        f"- Original `GAME.EXE`: `{report['original_sha256']}`",
        f"- AUTOTEXT resource: `{report['autotext_resource_sha256']}`",
        f"- Native library: `{report['native_library_sha256']}`",
        f"- Loader cases: {report['loader_cases']}; executor cases: "
        f"{report['executor_cases']}; mismatches: {len(report['mismatches'])}",
        f"- Corpus: {report['corpus']['records']} records; sources "
        f"{report['corpus']['sources']}; subtypes {report['corpus']['subtypes']}",
        f"- Executor boundaries observed: {', '.join(report['executor_boundary_calls_observed'])}",
        "",
        "## Code hashes",
        "",
    ]
    for item in report["code_ranges"]:
        lines.append(f"- `{item['start']}..{item['end_exclusive']}` {item['name']}: "
                     f"`{item['sha256']}`")
    lines += ["", "## Original code left real", ""]
    lines += [f"- {item}" for item in report["original_code_left_real"]]
    lines += ["", "## Intercepted boundaries", ""]
    lines += [f"- `{key}`: {value}" for key, value in report["intercepted_boundaries"].items()]
    lines += ["", "## Intentional divergences", ""]
    for item in report["intentional_divergences"]:
        lines.append(f"- `{item['case']}`: {item['reason']}. Original advance "
                     f"{item['original_advance']}, fatal {item['original_fatal']}; "
                     f"native status {item['native_status']}.")
    lines += ["", "## Unverified", ""]
    lines += [f"- {item}" for item in report["unverified"]]
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--markdown-report", type=Path, default=DEFAULT_MARKDOWN)
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleError, OSError, ValueError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    args.markdown_report.write_text(render_markdown(report), encoding="utf-8")
    print(f"Loader cases: {report['loader_cases']}; executor cases: "
          f"{report['executor_cases']}; mismatches: {len(report['mismatches'])}")
    print(f"Wrote {args.report}")
    if report["mismatches"]:
        print(json.dumps(report["mismatches"][:5], indent=2), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
