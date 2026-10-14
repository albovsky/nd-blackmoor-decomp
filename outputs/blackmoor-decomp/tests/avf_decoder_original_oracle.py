#!/usr/bin/env python3
"""Compare the native AVF decoder with the original GAME.EXE routines.

Original code that runs unmodified under Unicorn:

* 0x414ceb open (signature/version check, table copy, frame bytes);
* 0x41546f single-buffer reader, 0x4156ea double-buffer reader and
  0x415176 random-access chunk getter;
* everything they reach on valid input: 0x4150af scratch allocation,
  0x4159db chunk read, 0x415db9 LZSS, 0x50c920 stack probe, 0x416af3
  command expansion, 0x43ef77 fill and 0x4c7314 display conversion;
* 0x4c2f02..0x4c31f0, which derives the display conversion parameters
  (object 0x5cf659 +0x38a8/+0x38c0/+0x38c8) from channel masks.

Host boundaries (each recorded): operator new 0x51dc43 and delete 0x51dc6c,
the five file-mapping imports used by 0x414ceb/0x415011, and the fatal
report paths 0x50ca3e / 0x42639d / 0x52139c / 0x4264e8 / 0x4c97b4, which
stop the call and classify it as fatal. Code hooks at 0x4c7314 (entry) and
0x416084 (LZSS epilogue) only observe.

Every frame of every installed AVF file is decoded by each reader in two
display formats (5/5/5: no conversion; 5/6/5: conversion) and compared with
the native library: frame bytes, flags, toggle, last index, predecessor,
LZSS end state (produced, counter, ring, consumed input) and the
conversion-call trace. Synthetic fixtures cover the command branches that no
installed file uses.

    work/tools/oracle-python/bin/python \\
        outputs/blackmoor-decomp/tests/avf_decoder_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import os
import struct
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent))
from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256  # noqa: E402
from autotext_original_oracle import EXPECTED_EXE_SHA256  # noqa: E402
import test_avf_decoder as fx  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_REPORT = ROOT / "work/analysis/slices/S03-1.validation.json"
GAME_SOURCE = ROOT / "work/analysis/game-source.json"

OPEN, CLOSE, SINGLE, DOUBLE, GET_CHUNK = 0x414CEB, 0x415011, 0x41546F, 0x4156EA, 0x415176
CONVERT, LZSS_RETURN = 0x4C7314, 0x416084
NEW, DELETE = 0x51DC43, 0x51DC6C
FATAL = {0x50CA3E: 0, 0x42639D: 8, 0x52139C: 12, 0x4264E8: 4, 0x4C97B4: 0}
IMPORTS = {  # IAT slot: (name, stdcall argument bytes)
    0x52A2BC: ("CreateFileA", 0x1C),
    0x52A2C0: ("CreateFileMappingA", 0x18),
    0x52A2C4: ("MapViewOfFile", 0x14),
    0x52A2B4: ("UnmapViewOfFile", 0x4),
    0x52A2B8: ("CloseHandle", 0x4),
}
GFX_OBJECT = 0x5CF659
CALLER_ECX = 0x5E2DBE   # `this` used by every original caller of the readers
CODE_WINDOWS = {
    "open_0x414ceb": (0x414CEB, 0x415011),
    "close_0x415011": (0x415011, 0x4150AF),
    "alloc_0x4150af": (0x4150AF, 0x415113),
    "get_chunk_0x415176": (0x415176, 0x41546F),
    "single_0x41546f": (0x41546F, 0x4156EA),
    "double_0x4156ea": (0x4156EA, 0x4159DB),
    "read_0x4159db": (0x4159DB, 0x415A61),
    "lzss_0x415db9": (0x415DB9, 0x41608B),
    "expand_0x416af3": (0x416AF3, 0x416E60),
    "fill_0x43ef77": (0x43EF77, 0x43EFB6),
    "convert_0x4c7314": (0x4C7314, 0x4C7481),
    "format_0x4c2f02": (0x4C2F02, 0x4C31F0),
    "stack_probe_0x50c920": (0x50C920, 0x50C94F),
}
# Unreferenced duplicate of 0x4159db/0x415db9 writing to a caller buffer.
UNREACHABLE = {"read_to_0x415a61": (0x415A61, 0x415AEA), "lzss_to_0x415aea": (0x415AEA, 0x415DB9)}

STACK, STACK_SIZE = 0x10000000, 0x100000
PERSIST, PERSIST_SIZE = 0x20000000, 0x1000000
ARENAS = (0x22000000, 0x24000000)
ARENA_SIZE = 0x2000000
VIEW, VIEW_SIZE = 0x30000000, 0x200000
OBJECT = 0x38000000
FLAG_WORD = OBJECT + 0x800
STUBS = 0x39000000
SENTINEL = 0x3F000000
ALLOC_FILL = 0xCD
BUFFER_FILL = 0x5A
STACK_FILL = 0xA7

FORMATS = {  # display channel masks (red, green, blue)
    "rgb555": (0x7C00, 0x03E0, 0x001F),
    "rgb565": (0xF800, 0x07E0, 0x001F),
}


class OracleError(RuntimeError):
    pass


class Fatal(Exception):
    pass


class Original:
    def __init__(self, exe: Path, masks: tuple[int, int, int]) -> None:
        from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL, Uc
        from unicorn import x86_const as x

        self.x = x
        self.pe = PEImage.parse_and_map(exe)
        if sha256(self.pe.data) != EXPECTED_EXE_SHA256:
            raise OracleError("GAME.EXE identity mismatch")
        uc = Uc(UC_ARCH_X86, UC_MODE_32)
        base = self.pe.image_base
        uc.mem_map(base, (self.pe.size_of_image + 0xFFF) & ~0xFFF, UC_PROT_ALL)
        uc.mem_write(base, self.pe.image)
        for addr, size in ((STACK, STACK_SIZE), (PERSIST, PERSIST_SIZE), (ARENAS[0], ARENA_SIZE),
                           (ARENAS[1], ARENA_SIZE), (VIEW, VIEW_SIZE), (OBJECT, 0x1000),
                           (STUBS, 0x1000), (SENTINEL, 0x1000)):
            uc.mem_map(addr, size, UC_PROT_ALL)
        uc.mem_write(SENTINEL, b"\xCC" * 0x1000)
        self.uc = uc
        self.stub_names: dict[int, tuple[str, int]] = {}
        for k, (slot, info) in enumerate(sorted(IMPORTS.items())):
            stub = STUBS + 0x10 * k
            uc.mem_write(slot, struct.pack("<I", stub))
            self.stub_names[stub] = info
        for addr in [NEW, DELETE, *FATAL, *self.stub_names]:
            uc.hook_add(UC_HOOK_CODE, self._host, begin=addr, end=addr)
        uc.hook_add(UC_HOOK_CODE, self._observe_convert, begin=CONVERT, end=CONVERT)
        uc.hook_add(UC_HOOK_CODE, self._observe_lzss, begin=LZSS_RETURN, end=LZSS_RETURN)
        self.cursor = {"persist": PERSIST, 0: ARENAS[0], 1: ARENAS[1]}
        self.arena: Any = "persist"
        self.events: list[tuple] = []
        self.converts: list[tuple[int, int]] = []
        self.lzss: dict[str, Any] | None = None
        self.file_size = 0
        self._format(masks)

    # -- helpers -----------------------------------------------------------
    def r(self, addr: int, n: int) -> bytes:
        return bytes(self.uc.mem_read(addr, n))

    def w(self, addr: int, data: bytes) -> None:
        self.uc.mem_write(addr, data)

    def u32(self, addr: int) -> int:
        return struct.unpack("<I", self.r(addr, 4))[0]

    def reg(self, name: str) -> int:
        return self.uc.reg_read(getattr(self.x, f"UC_X86_REG_{name}"))

    def setreg(self, name: str, value: int) -> None:
        self.uc.reg_write(getattr(self.x, f"UC_X86_REG_{name}"), value & 0xFFFFFFFF)

    def arg(self, i: int) -> int:
        return self.u32(self.reg("ESP") + 4 + 4 * i)

    def alloc(self, size: int) -> int:
        limit = PERSIST + PERSIST_SIZE if self.arena == "persist" else ARENAS[self.arena] + ARENA_SIZE
        start = (self.cursor[self.arena] + 15) & ~15
        if size > 0x7FFFFFFF or start + size > limit:
            return 0  # operator new failure path of the original
        self.cursor[self.arena] = start + size
        self.w(start, bytes((ALLOC_FILL,)) * size)
        return start

    def use_arena(self, arena: Any) -> None:
        self.arena = arena
        if arena != "persist":
            self.cursor[arena] = ARENAS[arena]

    def _format(self, masks: tuple[int, int, int]) -> None:
        frame = STACK + STACK_SIZE // 2
        self.w(frame - 0x200, b"\0" * 0x200)
        red, green, blue = masks
        for offset, value in ((-0x88, GFX_OBJECT), (-0x28, red), (-0x24, green), (-0x20, blue)):
            self.w(frame + offset, struct.pack("<i", value))
        self.setreg("EBP", frame)
        self.setreg("ESP", frame - 0x200)
        self.uc.emu_start(0x4C2F02, 0x4C31F0, count=1_000_000)
        if self.reg("EIP") != 0x4C31F0:
            raise OracleError("pixel-format block did not finish")
        self.format = {
            "enabled": self.u32(GFX_OBJECT + 0x38A8),
            "shifts": list(self.r(GFX_OBJECT + 0x38C0, 3)),
            "bits": list(self.r(GFX_OBJECT + 0x38C8, 3)),
        }

    # -- hooks -------------------------------------------------------------
    def _return(self, value: int, pop: int) -> None:
        esp = self.reg("ESP")
        ret = self.u32(esp)
        self.setreg("EAX", value)
        self.setreg("ESP", esp + 4 + pop)
        self.setreg("EIP", ret)

    def _host(self, uc, address, _size, _user) -> None:
        if address == NEW:
            size = self.arg(0)
            ptr = self.alloc(size)
            self.events.append(("new", size))
            self._return(ptr, 0)
        elif address == DELETE:
            self.events.append(("delete",))
            self._return(0, 0)
        elif address in FATAL:
            self.events.append(("fatal", hex(address)))
            self.fatal = True
            uc.emu_stop()
        else:
            name, pop = self.stub_names[address]
            value = {"CreateFileA": 0x100, "CreateFileMappingA": 0x200,
                     "MapViewOfFile": VIEW}.get(name, 1)
            self.events.append(("import", name))
            self._return(value, pop)

    def _observe_convert(self, uc, address, _size, _user) -> None:
        self.converts.append((self.arg(0), self.arg(1)))

    def _observe_lzss(self, uc, address, _size, _user) -> None:
        ebp = self.reg("EBP")
        self.lzss = {
            "produced": self.u32(ebp - 0x18),
            "counter": self.r(ebp - 0x10, 1)[0],
            "ring_position": self.u32(ebp - 0x8),
            "input_position": struct.unpack("<i", self.r(ebp - 0x24, 4))[0],
            "flag_bits": self.u32(ebp - 0x4),
            "ring": self.r(ebp - 0x103C, fx.RING),
        }

    # -- calls -------------------------------------------------------------
    def call(self, function: int, args: list[int], ecx: int = CALLER_ECX) -> int:
        esp = STACK + STACK_SIZE - 0x100
        # A known pattern in the probed stack exposes the 18 ring bytes the
        # original never initializes.
        self.w(STACK + STACK_SIZE - 0x8000, bytes((STACK_FILL,)) * 0x7F00)
        self.w(esp, struct.pack(f"<{len(args) + 1}I", SENTINEL, *args))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.setreg(name, 0)
        self.setreg("ECX", ecx)
        self.setreg("ESP", esp)
        self.fatal = False
        self.converts = []
        self.lzss = None
        self.uc.emu_start(function, SENTINEL, count=400_000_000)
        if self.fatal:
            raise Fatal(self.events[-1][1])
        if self.reg("EIP") != SENTINEL:
            raise OracleError(f"0x{function:x} stopped at 0x{self.reg('EIP'):x}")
        return self.reg("EAX")

    def reopen(self, data: bytes) -> None:
        """Re-open after a fatal call (its error path already ran 0x415011),
        keeping the reader buffers and mode (+0x172..+0x1cc)."""
        kept = self.r(OBJECT + 0x172, 0x5A)
        self.open(data, fresh=False)
        self.w(OBJECT + 0x172, kept)

    def open(self, data: bytes, path: bytes = b"CDVideo\\fixture.avf",
             fresh: bool = True) -> dict[str, Any]:
        if len(data) > VIEW_SIZE:
            raise OracleError("file larger than the view window")
        self.w(VIEW, data + bytes(VIEW_SIZE - len(data)))
        self.file_size = len(data)
        self.w(OBJECT, b"\0" * 0x800)
        self.w(OBJECT + 0x4D, path + b"\0")
        self.use_arena("persist")
        if fresh:
            self.cursor["persist"] = PERSIST
        self.events = []
        self.call(OPEN, [OBJECT])
        count = struct.unpack("<h", self.r(OBJECT + 0x15, 2))[0]
        table = self.u32(OBJECT + 0x21)
        return {
            "header": self.r(OBJECT, fx.HEADER_BYTES),
            "table": self.r(table, count * fx.RECORD_BYTES) if count > 0 else b"",
            "frame_bytes": struct.unpack("<i", self.r(OBJECT + 0x41, 4))[0],
            "last_index": struct.unpack("<i", self.r(OBJECT + 0x45, 4))[0],
            "previous": self.u32(OBJECT + 0x49),
            "view": self.u32(OBJECT + 0x2D),
            "imports": [e[1] for e in self.events if e[0] == "import"],
        }

    def setup_buffers(self, frame_bytes: int, double: bool) -> None:
        self.use_arena("persist")
        self.buffers = [self.alloc(frame_bytes), self.alloc(frame_bytes) if double else 0]
        for ptr in self.buffers:
            if ptr:
                self.w(ptr, bytes((BUFFER_FILL,)) * frame_bytes)
        self.w(OBJECT + 0x172, struct.pack("<I", 1 if double else 0))
        self.w(OBJECT + 0x17A, struct.pack("<II", *self.buffers))
        self.w(OBJECT + 0x182, b"\0" * 4)
        self.w(OBJECT + 0x18A, b"\0\0")
        self.w(OBJECT + 0x1C8, struct.pack("<I", frame_bytes))

    def reset(self) -> None:
        """Post-open reader state: 0x414ceb resets +0x45/+0x49, 0x4161d1 the
        flags and the stream starts (0x4bf710, 0x4dc2f8) the toggle."""
        self.w(OBJECT + 0x45, struct.pack("<iI", -1, 0))
        self.w(OBJECT + 0x182, b"\0" * 4)  # as 0x4161d1 does
        self.w(OBJECT + 0x18A, b"\0\0")

    def state(self) -> dict[str, Any]:
        return {
            "last_index": struct.unpack("<i", self.r(OBJECT + 0x45, 4))[0],
            "flags": list(struct.unpack("<HH", self.r(OBJECT + 0x182, 4))),
            "toggle": struct.unpack("<H", self.r(OBJECT + 0x18A, 2))[0],
            "previous": self.u32(OBJECT + 0x49),
            "scratch": self.u32(OBJECT + 0x35),
        }

    def reader(self, function: int, index: int) -> None:
        self.w(OBJECT + 0x1C2, struct.pack("<h", index))
        self.use_arena(0)
        self.events = []
        self.call(function, [OBJECT])

    def get_chunk(self, index: int, arena: int, flags: int | None, previous: int = 0,
                  previous_index: int = 0) -> int:
        if flags is not None:
            self.w(FLAG_WORD, struct.pack("<H", flags))
        self.use_arena(arena)
        self.events = []
        return self.call(GET_CHUNK, [OBJECT, index & 0xFFFF,
                                     FLAG_WORD if flags is not None else 0, previous,
                                     previous_index & 0xFFFF])


# -- native side ------------------------------------------------------------------
class CifFormat(c.Structure):
    _fields_ = [("enabled", c.c_uint32), ("shifts", c.c_uint8 * 3), ("bits", c.c_int8 * 3)]


class Native:
    def __init__(self, lib: c.CDLL, cif: c.CDLL, data: bytes, fmt: dict[str, Any]) -> None:
        self.lib = lib
        self.raw = fx.ubuf(data)
        self.file = fx.AvfFile()
        self.status = lib.avf_open(self.raw, len(data), c.byref(self.file))
        self.converts: list[tuple[int, int]] = []
        self.cif = cif
        self.format = CifFormat(fmt["enabled"], (c.c_uint8 * 3)(*fmt["shifts"]),
                                (c.c_int8 * 3)(*[b - 256 if b > 127 else b for b in fmt["bits"]]))
        self.callback = fx.CONVERT(self._convert) if fmt["enabled"] else fx.CONVERT()

    def _convert(self, _context, pixels, byte_count) -> None:
        self.converts.append((c.addressof(pixels.contents), byte_count))
        self.cif.cif_pixels_convert_555(pixels, byte_count, c.byref(self.format))

    def stream(self, double: bool) -> None:
        fb = self.file.frame_bytes
        self.buffers = [(c.c_uint8 * fb)(*([BUFFER_FILL] * fb)) for _ in range(2 if double else 1)]
        self.scratch = (c.c_uint8 * max(1, self.file.max_unpacked))()
        self.st = fx.AvfStream()
        status = self.lib.avf_stream_init(
            c.byref(self.st), c.byref(self.file), self.buffers[0],
            self.buffers[1] if double else None, fb, self.scratch, self.file.max_unpacked,
            self.callback, None)
        if status != fx.OK:
            raise OracleError(f"native stream init failed: {status}")

    def state(self) -> dict[str, Any]:
        return {"last_index": self.st.last_index, "flags": [self.st.flags[0], self.st.flags[1]],
                "toggle": self.st.toggle}


def lzss_view(state: fx.AvfLzssState) -> dict[str, Any]:
    return {"produced": state.produced, "counter": state.counter,
            "ring_position": state.ring_position, "input_position": state.input_position,
            "flag_bits": state.flag_bits, "ring": bytes(state.ring),
            "defined": bytes(state.ring_defined)}


def compare_lzss(original: dict | None, native: dict | None) -> list[str]:
    if original is None or native is None:
        return [] if original is None and native is None else ["lzss presence"]
    diffs = [k for k in ("produced", "counter", "ring_position", "input_position", "flag_bits")
             if original[k] != native[k]]
    ring_o, ring_n, defined = original["ring"], native["ring"], native["defined"]
    if any(defined[i] and ring_o[i] != ring_n[i] for i in range(fx.RING)):
        diffs.append("ring")
    return diffs


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()[:16]


# -- runner ----------------------------------------------------------------------
class Runner:
    def __init__(self, original: Original, lib: c.CDLL, cif: c.CDLL, fmt_name: str) -> None:
        self.o = original
        self.lib = lib
        self.cif = cif
        self.fmt_name = fmt_name
        self.counts: dict[str, int] = {}
        self.mismatches: list[dict[str, Any]] = []
        self.branch: dict[str, int] = {}
        self.hosts: dict[str, int] = {}

    def count(self, key: str, n: int = 1) -> None:
        self.counts[key] = self.counts.get(key, 0) + n

    def mismatch(self, where: str, detail: Any) -> None:
        self.mismatches.append({"format": self.fmt_name, "where": where, "detail": detail})

    def note_hosts(self) -> None:
        for event in self.o.events:
            key = event[0] if event[0] != "import" else f"import:{event[1]}"
            self.hosts[key] = self.hosts.get(key, 0) + 1

    def open(self, name: str, data: bytes) -> tuple[dict | None, Native]:
        native = Native(self.lib, self.cif, data, self.o.format)
        try:
            opened = self.o.open(data)
        except Fatal as exc:
            if native.status == fx.OK:
                self.mismatch(f"{name}:open", f"original fatal {exc}, native OK")
            self.count("open_fatal")
            return None, native
        self.note_hosts()
        self.count("open")
        if native.status != fx.OK:
            self.mismatch(f"{name}:open", f"native {fx.STATUS[native.status]}")
            return None, native
        f = native.file
        records = bytes(data[fx.HEADER_BYTES:fx.HEADER_BYTES + f.frame_count * fx.RECORD_BYTES])
        problems = []
        if opened["header"] != data[:fx.HEADER_BYTES]:
            problems.append("header copy")
        if opened["table"] != records:
            problems.append("table copy")
        if opened["frame_bytes"] != f.frame_bytes:
            problems.append("frame bytes")
        if (opened["last_index"], opened["previous"]) != (-1, 0):
            problems.append("reset state")
        if problems:
            self.mismatch(f"{name}:open", problems)
        return opened, native

    def check(self, where: str, original: dict, native: dict) -> None:
        diffs = [k for k in original if k not in ("lzss",) and original[k] != native.get(k)]
        diffs += compare_lzss(original.get("lzss"), native.get("lzss"))
        self.count("compared")
        if diffs:
            self.mismatch(where, {k: [str(original.get(k))[:80], str(native.get(k))[:80]]
                                  for k in diffs if k in original} or diffs)

    def record_type(self, native: Native, index: int) -> str:
        record = fx.AvfRecord()
        if self.lib.avf_record(c.byref(native.file), index, c.byref(record)) != fx.OK:
            return "range"
        if record.packed_bytes == 0 and record.unpacked_bytes == 0:
            return f"empty{record.type}"
        return f"type{record.type}"

    def native_converts(self, native: Native, buffers: dict[int, int]) -> list:
        out = []
        for address, count in native.converts:
            slot = None
            for name, (base, size) in buffers.items():
                if base <= address < base + max(size, 1) or address == base:
                    slot, offset = name, address - base
            out.append((slot, offset if slot is not None else address, count))
        return out

    def original_converts(self, buffers: dict[Any, tuple[int, int]]) -> list:
        out = []
        if not self.o.format["enabled"]:
            # +0x38a8 == 0: 0x4c7314 returns at once; the native passes no hook.
            self.count("convert_noop_calls", len(self.o.converts))
            return out
        for address, count in self.o.converts:
            if count < 2:
                continue  # converts nothing; the native hook omits these calls
            slot = None
            for name, (base, size) in buffers.items():
                if base <= address < base + max(size, 1) or address == base:
                    slot, offset = name, address - base
            out.append((slot, offset if slot is not None else address, count))
        return out

    # -- single / double -------------------------------------------------------
    def readers(self, name: str, data: bytes, order: list[int], double: bool) -> None:
        opened, native = self.open(name, data)
        if opened is None:
            return
        fb = native.file.frame_bytes
        self.o.setup_buffers(fb, double)
        native.stream(double)
        mode = "double" if double else "single"
        function = DOUBLE if double else SINGLE
        slots = 2 if double else 1
        skipping = closed = False
        for step, index in enumerate(order):
            if index is None:  # reset/replay marker
                if closed:
                    self.o.reopen(data)
                    closed = False
                self.o.reset()
                self.lib.avf_stream_reset(c.byref(native.st))
                skipping = False
                continue
            if skipping:
                self.count(f"{mode}_skipped_after_failure")
                continue
            kind = self.record_type(native, index)
            where = f"{name}:{mode}:{step}:frame{index}:{kind}"
            native.converts = []
            state = fx.AvfLzssState()
            written = c.c_int(-1)
            if double:
                status = self.lib.avf_decode_double(c.byref(native.st), index,
                                                    c.byref(written), c.byref(state))
            else:
                status = self.lib.avf_decode_single(c.byref(native.st), index, c.byref(state))
            try:
                self.o.reader(function, index)
            except Fatal as exc:
                self.count(f"{mode}_fatal")
                if status == fx.OK:
                    self.mismatch(where, f"original fatal {exc}, native OK")
                else:
                    self.count(f"fatal_vs_{fx.STATUS[status]}")
                # A fatal call closes the original stream; resume after the next reset.
                skipping = closed = True
                continue
            self.note_hosts()
            if status != fx.OK:
                self.mismatch(where, f"original OK, native {fx.STATUS[status]}")
                skipping = True
                continue
            buffers_o = {k: (self.o.buffers[k], fb) for k in range(slots)}
            buffers_n = {k: (c.addressof(native.buffers[k]), fb) for k in range(slots)}
            ostate = self.o.state()
            original = {
                "frames": [digest(self.o.r(self.o.buffers[k], fb)) for k in range(slots)],
                "flags": ostate["flags"][:slots] if double else ostate["flags"][:1],
                "toggle": ostate["toggle"], "last_index": ostate["last_index"],
                "converts": self.original_converts(buffers_o),
                "lzss": self.o.lzss,
            }
            nstate = native.state()
            nat = {
                "frames": [digest(bytes(native.buffers[k])) for k in range(slots)],
                "flags": nstate["flags"][:slots] if double else nstate["flags"][:1],
                "toggle": nstate["toggle"], "last_index": nstate["last_index"],
                "converts": self.native_converts(native, buffers_n),
                "lzss": lzss_view(state) if self.o.lzss is not None else None,
            }
            self.check(where, original, nat)
            self.count(f"{mode}:{kind}")

    # -- random access chunk ---------------------------------------------------
    def chunks(self, name: str, data: bytes, plan: list[tuple]) -> None:
        """plan: (index, override_from_step or None, override_index[, null_flags]).

        A None index is a reset; after a failure the plan resumes at the next reset.

        Each decoding call gets a fresh buffer: the original allocates from the
        arena not holding the predecessor, the native side uses the matching
        one of two caller buffers. Results are named by the step producing them.
        """
        opened, native = self.open(name, data)
        if opened is None:
            return
        fb = native.file.frame_bytes
        native.stream(False)
        size = max(fb, native.file.max_unpacked, 1)
        outs = [(c.c_uint8 * size)(), (c.c_uint8 * size)()]
        latest_o: dict[int, Any] = {0: None}
        latest_n: dict[int, Any] = {0: None}
        results_o: dict[int, int] = {}
        results_n: dict[int, int] = {}
        sizes_n: dict[int, int] = {}
        data_steps = 0
        skipping = closed = False
        for step, entry in enumerate(plan):
            index, override_step, override_index = entry[:3]
            null_flags = len(entry) > 3 and entry[3]
            if index is None:
                if closed:
                    self.o.reopen(data)
                    closed = False
                self.o.reset()
                self.lib.avf_stream_reset(c.byref(native.st))
                skipping = False
                continue
            if skipping:
                self.count("chunk_skipped_after_failure")
                continue
            kind = self.record_type(native, index)
            fresh = kind.startswith("type")
            arena = data_steps & 1
            where = f"{name}:chunk:{step}:frame{index}:{kind}"
            out = outs[arena]
            c.memset(out, ALLOC_FILL, size)
            native.converts = []
            prev_o = results_o.get(override_step, 0) if override_step is not None else 0
            prev_n = results_n.get(override_step, 0) if override_step is not None else 0
            prev_ptr = c.cast(prev_n, c.POINTER(c.c_uint8)) if prev_n else None
            flags = c.c_uint16(0x100)
            result = c.POINTER(c.c_uint8)()
            result_bytes = c.c_size_t(0)
            state = fx.AvfLzssState()
            status = self.lib.avf_get_chunk(
                c.byref(native.st), index, out, size, prev_ptr,
                sizes_n.get(override_step, 0) if override_step is not None else 0,
                override_index, None if null_flags else c.byref(flags), c.byref(result),
                c.byref(result_bytes), c.byref(state))
            try:
                address = self.o.get_chunk(index, arena, None if null_flags else 0x100, prev_o,
                                           override_index)
            except Fatal as exc:
                self.count("chunk_fatal")
                if status == fx.OK:
                    self.mismatch(where, f"original fatal {exc}, native OK")
                else:
                    self.count(f"fatal_vs_{fx.STATUS[status]}")
                skipping = closed = True
                continue
            self.note_hosts()
            if status != fx.OK:
                self.mismatch(where, f"original OK, native {fx.STATUS[status]}")
                skipping = True
                continue
            n_address = c.addressof(result.contents) if result else 0
            length = result_bytes.value
            in_arena = ARENAS[arena] <= address < ARENAS[arena] + ARENA_SIZE
            ostate = self.o.state()
            allocations = [e[1] for e in self.o.events if e[0] == "new"]
            original = {
                # The result is the last allocation of a decoding call.
                "result_bytes": allocations[-1] if fresh and allocations else None,
                "result_step": step if fresh and in_arena else latest_o.get(address, "foreign"),
                "result": digest(self.o.r(address, length)) if fresh else None,
                "flags": None if null_flags else struct.unpack("<H", self.o.r(FLAG_WORD, 2))[0],
                "last_index": ostate["last_index"],
                "converts": self.original_converts({"out": (address, length)}),
                "lzss": self.o.lzss,
            }
            nat = {
                "result_bytes": length if fresh else None,
                "result_step": step if fresh and n_address == c.addressof(out)
                else latest_n.get(n_address, "foreign"),
                "result": digest(bytes((c.c_uint8 * length).from_address(n_address)))
                if fresh else None,
                "flags": None if null_flags else flags.value,
                "last_index": native.st.last_index,
                "converts": self.native_converts(native, {"out": (n_address, length)}),
                "lzss": lzss_view(state) if self.o.lzss is not None else None,
            }
            if fresh:
                latest_o[address] = step
                latest_n[n_address] = step
                data_steps += 1
            original["previous_step"] = latest_o.get(ostate["previous"], "foreign")
            nat["previous_step"] = latest_n.get(
                c.cast(native.st.chunk_previous, c.c_void_p).value or 0, "foreign")
            results_o[step], results_n[step], sizes_n[step] = address, n_address, length
            self.check(where, original, nat)
            self.count(f"chunk:{kind}")



# -- fixtures ----------------------------------------------------------------------
def synthetic_fixtures() -> dict[str, dict[str, Any]]:
    """Command/record variants absent from the installed corpus."""
    W, H = 16, 6
    fb_pixels = W * H
    key = fx.frame_pixels(W, H, 3)
    key2 = fx.frame_pixels(W, H, 11)
    copy_long = fx.cmd_copy(5, [(k * 977) & 0xFFFF for k in range(40)])
    full = (fx.cmd_fill(0x1234, 0, fb_pixels) + fx.cmd_copy(1, [7, 8, 9]) +
            fx.cmd_repeat([0x2222, 0x3333, 0x4444], [10, 30, 50]) +
            fx.cmd_copy(fb_pixels - 1, [0x7FFF]))
    delta_all = (fx.cmd_copy(2, [0x0101, 0x0202, 0x0303]) + copy_long +
                 fx.cmd_fill(0x5555, 60, 7) + fx.cmd_fill(0x6666, 70, 0) +
                 fx.cmd_repeat([0x0A0A], [0, 1, 2]) + fx.cmd_repeat([], [3]) +
                 fx.cmd_repeat([0x0B0B, 0x0C0C], [80, 90], 2) +
                 fx.cmd_repeat([1, 2, 3], [], -1))
    corner = (fx.cmd_copy(4, [0xABCD], 0x80000001) + fx.cmd_fill(0x1111, 0x80000003, 2) +
              fx.cmd_fill(0x2222, 9, -0x80000000) + fx.cmd_fill(0x3333, 12, -0x7FFFFFFE) +
              fx.cmd_copy(20, [], 0) + fx.cmd_copy(0x80000000 + 30, [0x4444, 0x4545]))
    overlap = fx.cmd_fill(0x0F0F, 10, 20) + fx.cmd_copy(15, [0x7070] * 10) + \
        fx.cmd_repeat([0x0E0E] * 4, [12, 14, 16])
    lit_end = fx.lzss_tokens([("lit", b) for b in key[:7]])[:-1]  # stream ends at a literal
    fixtures: dict[str, dict[str, Any]] = {}

    def add(name: str, frames: list, width: int = W, height: int = H, *,
            readers: bool = True, chunk_plan: list | None = None,
            formats: tuple[str, ...] = tuple(FORMATS), unpacked: dict | None = None,
            **kw) -> None:
        data = bytearray(fx.build_avf(width, height, frames, **kw))
        for index, value in (unpacked or {}).items():  # declared-size overrides
            struct.pack_into("<I", data, fx.HEADER_BYTES + index * fx.RECORD_BYTES + 0xA, value)
        fixtures[name] = {"data": bytes(data), "readers": readers, "chunk_plan": chunk_plan,
                          "formats": formats}

    add("type1_full", [(1, full, None), (1, overlap, None), (1, corner, None)])
    add("type2_chain", [(0, key, None), (2, delta_all, None), (2, overlap, None),
                        (2, None, None), (2, corner, None), (0, key2, None),
                        (2, fx.cmd_fill(0x4321, 0, fb_pixels), None)])
    add("mixed_empty", [(0, None, None), (0, key, None), (1, None, None), (2, None, None),
                        (3, None, None), (2, fx.cmd_copy(0, [9]), None), (1, full, None)])
    add("short_key", [(0, key[: 2 * W], None), (2, fx.cmd_fill(1, 0, 3), None)])
    add("lzss_variants", [
        (0, key, fx.lzss_literals(key)),
        (0, key2, fx.lzss_compress(key2)),
        (0, bytes(fb_pixels * 2), None),
        (0, b"     AB" + b"AB" * 6 + bytes(fb_pixels * 2 - 19),
         fx.lzss_tokens([("match", 0, 5), ("lit", 0x41), ("lit", 0x42),
                         ("match", (fx.RING_START + 5) & 0xFFF, 12)] +
                        [("lit", 0)] * (fb_pixels * 2 - 19))),
        (0, key[:6], lit_end),
        (0, key[:7], fx.lzss_tokens([("lit", b) for b in key[:7]]) + b"\x33"),
    ])
    # Reviewer cases: original-safe inputs, each run only where the original
    # stays inside its allocations.
    add("neg_fill_unconverted", [(0, key, None),
                                 (2, fx.cmd_fill(7, 0, -1) +
                                  fx.cmd_fill(8, 0x40000000, 0x80000005), None)],
        formats=("rgb555",))
    add("key_larger_than_frame", [(0, fx.frame_pixels(4, 2, 2), None)], width=2, height=2,
        readers=False)
    add("lzss_longer_than_declared", [(0, fx.frame_pixels(4, 2, 1), None)], width=4,
        height=2, unpacked={0: 8}, chunk_plan=[])
    add("lzss_shorter_than_declared", [(0, fx.frame_pixels(4, 1, 1), None),
                                       (2, fx.cmd_fill(3, 1, 2), None)],
        width=4, height=2, unpacked={0: 10}, chunk_plan=[(0, None, 0)])
    add("odd_dims", [(0, fx.frame_pixels(7, 3, 5), None), (2, fx.cmd_copy(20, [1]), None)],
        width=7, height=3)
    # Fatal in the original; the native rejects the same calls.
    add("delta_first", [(2, fx.cmd_fill(1, 0, 1), None)])
    add("type3_data", [(0, key, None), (3, fx.cmd_fill(1, 0, 1), None)])
    add("compression1", [(0, None, None), (0, key, None)], compression=1)
    add("signature", [(0, key, None)], signature=b"AVF WayneSikex\0")
    add("version", [(0, key, None)], version=(1, 0))
    return fixtures


def corpus_files() -> list[Path]:
    game = Path(json.loads(GAME_SOURCE.read_text())["game_dir"])
    files = sorted(p for p in (game / "CDVideo").iterdir() if p.suffix.lower() == ".avf")
    return files


def build_native(source: Path, out: Path, extra_flags: list[str] | None = None) -> None:
    subprocess.run(["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64", "-std=c11", "-O2",
                    "-fPIC", "-dynamiclib", "-I", str(PROJECT / "src"), *(extra_flags or []),
                    str(source), "-o", str(out)], check=True, capture_output=True)


def bind_cif(tmp: Path) -> c.CDLL:
    out = tmp / "libcifpixels_oracle.dylib"
    build_native(PROJECT / "src/cif_pixels.c", out)
    cif = c.CDLL(str(out))
    cif.cif_pixels_convert_555.argtypes = [c.POINTER(c.c_uint8), c.c_uint32,
                                           c.POINTER(CifFormat)]
    cif.cif_pixels_convert_555.restype = None
    return cif


def plans(n: int) -> dict[str, Any]:
    forward = list(range(n))
    replay = forward + [None] + list(reversed(forward)) + [None] + forward
    return {"single": replay, "double": replay,
            "chunk": [(i, None, 0) for i in forward] + [(None, None, 0)] +
            [(i, None, 0) for i in reversed(forward)] + [(None, None, 0)] +
            [(i, None, 0) for i in forward]}


def run_case(runner: Runner, name: str, data: bytes, n: int, chunk_plan=None,
             readers: bool = True) -> None:
    p = plans(n)
    if readers:
        runner.readers(name, data, p["single"], False)
        runner.readers(name, data, p["double"], True)
    plan = p["chunk"] if chunk_plan is None else chunk_plan
    if plan:
        runner.chunks(name, data, plan)


MUTATIONS = {
    "lzss_counter_skip": ("        hi = (uint8_t)(src[input] - counter);\n        ++counter;",
                          "        hi = (uint8_t)(src[input] - counter);"),
    "lzss_length": ("length = ((uint32_t)hi & 0xfu) + 3u;", "length = ((uint32_t)hi & 0xfu) + 2u;"),
    "lzss_offset_bits": ("(((uint32_t)hi & 0xf0u) << 4)", "(((uint32_t)hi & 0x70u) << 4)"),
    "delta_no_span_convert": ("                if (type == AVF_TYPE_DELTA) {\n"
                              "                    convert_span(stream, dst + offset, (uint32_t)bytes);",
                              "                if (0) {\n"
                              "                    convert_span(stream, dst + offset, (uint32_t)bytes);"),
    "fill_one_short": ("for (k = 0; k < fill_bytes; k += 2u)", "for (k = 2; k < fill_bytes; k += 2u)"),
    "delta_no_predecessor_copy": ("        memmove(dst, previous, frame_bytes);", "        (void)0;"),
}


def run(args: argparse.Namespace) -> dict[str, Any]:
    started = time.time()
    lib_path = Path(args.native_library)
    lib = fx.bind(lib_path)
    tmp = Path(tempfile.mkdtemp(prefix="avf-oracle-"))
    cif = bind_cif(tmp)
    files = corpus_files()
    if args.limit:
        files = files[: args.limit]
    corpus_meta = []
    report_formats = {}
    fixtures = synthetic_fixtures()
    for fmt_name, masks in FORMATS.items():
        original = Original(Path(args.exe), masks)
        runner = Runner(original, lib, cif, fmt_name)
        for path in files:
            data = path.read_bytes()
            n = struct.unpack_from("<h", data, 0x15)[0]
            if fmt_name == "rgb555":
                corpus_meta.append({"file": path.name, "bytes": len(data), "sha256": sha256(data),
                                    "frames": n})
            run_case(runner, path.name, data, n)
        if not args.corpus_only:
            for name, fixture in fixtures.items():
                if fmt_name not in fixture["formats"]:
                    continue
                n = struct.unpack_from("<h", fixture["data"], 0x15)[0]
                chunk_plan = fixture["chunk_plan"]
                if name == "type2_chain":
                    # After a reset: frame 0, then frame 2 with frame 0's result
                    # named as predecessor index 1 (override path); after a
                    # second reset, an override pointer with index 0 and an
                    # index with a NULL pointer (both ignored), then NULL flags.
                    chunk_plan = ([(i, None, 0) for i in range(n)] + [(None, None, 0)] +
                                  [(0, None, 0), (2, n + 1, 1), (3, None, 0), (4, None, 0)] +
                                  [(None, None, 0), (0, None, 0), (1, n + 6, 0),
                                   (2, None, 9), (3, None, 0, True), (4, None, 0, True)])
                elif name == "short_key":
                    # Type 2 after a short key would over-read the original's
                    # predecessor allocation; the native rejects it (unit test).
                    chunk_plan = [(0, None, 0)]
                run_case(runner, f"fixture:{name}", fixture["data"], n, chunk_plan,
                         fixture["readers"])
        report_formats[fmt_name] = {
            "display_format": original.format,
            "counts": dict(sorted(runner.counts.items())),
            "host_boundaries": dict(sorted(runner.hosts.items())),
            "mismatches": runner.mismatches[:50],
            "mismatch_count": len(runner.mismatches),
        }
        print(f"{fmt_name}: compared {runner.counts.get('compared', 0)} "
              f"mismatches {len(runner.mismatches)}", flush=True)
    pe = PEImage.parse_and_map(Path(args.exe))

    def window(a: int, b: int) -> str:
        return hashlib.sha256(pe.image[a - pe.image_base:b - pe.image_base]).hexdigest()

    report = {
        "slice": "S03-1",
        "original_exe_sha256": sha256(pe.data),
        "code_windows": {k: {"range": [hex(a), hex(b)], "sha256": window(a, b)}
                         for k, (a, b) in CODE_WINDOWS.items()},
        "unreachable_windows": {k: {"range": [hex(a), hex(b)], "sha256": window(a, b)}
                                for k, (a, b) in UNREACHABLE.items()},
        "native_library": str(lib_path.relative_to(ROOT)) if lib_path.is_relative_to(ROOT)
        else str(lib_path),
        "native_library_sha256": sha256(lib_path.read_bytes()),
        "native_source_sha256": {p: sha256((PROJECT / p).read_bytes())
                                 for p in ("src/avf_decoder.c", "src/avf_decoder.h")},
        "oracle_sha256": sha256(Path(__file__).read_bytes()),
        "fixtures_sha256": sha256((PROJECT / "tests/test_avf_decoder.py").read_bytes()),
        "corpus": {"files": len(corpus_meta), "frames": sum(m["frames"] for m in corpus_meta),
                   "entries": corpus_meta},
        "synthetic_fixtures": {k: {"sha256": sha256(v["data"]), "formats": list(v["formats"]),
                                   "readers": v["readers"],
                                   "chunk_plan": "default" if v["chunk_plan"] is None
                                   else len(v["chunk_plan"])} for k, v in fixtures.items()}
        if not args.corpus_only else {},
        "formats": report_formats,
        "total_mismatches": sum(v["mismatch_count"] for v in report_formats.values()),
        "elapsed_seconds": round(time.time() - started, 1),
    }
    if args.mutations:
        report["mutations"] = run_mutations(args, tmp)
    return report


def inventory(lib: c.CDLL) -> dict[str, Any]:
    """Coverage matrix of the installed corpus (no pixel data is stored)."""
    rows = []
    totals: dict[str, int] = {}
    for path in corpus_files():
        data = path.read_bytes()
        native = Native(lib, None, data, {"enabled": 0, "shifts": [0, 0, 0], "bits": [5, 5, 5]})
        f = native.file
        row: dict[str, Any] = {
            "file": path.name, "bytes": len(data), "sha256": sha256(data),
            "open": fx.STATUS[native.status], "signature": data[:15].decode("latin-1"),
            "version": list(struct.unpack_from("<hh", data, 0x10)),
            "frames": f.frame_count, "width": f.width, "height": f.height,
            "bits_per_pixel": f.bits_per_pixel, "header_1c": f.header_1c,
            "compression": f.compression, "frame_bytes": f.frame_bytes,
            "table_end": fx.HEADER_BYTES + f.frame_count * fx.RECORD_BYTES,
        }
        kinds: dict[str, int] = {}
        ends: dict[str, int] = {}
        issues: list[str] = []
        expected_offset = row["table_end"]
        last_end = row["table_end"]
        packed_total = 0
        for index in range(f.frame_count):
            record = fx.AvfRecord()
            lib.avf_record(c.byref(f), index, c.byref(record))
            empty = record.packed_bytes == 0 and record.unpacked_bytes == 0
            kind = f"empty{record.type}" if empty else f"type{record.type}"
            kinds[kind] = kinds.get(kind, 0) + 1
            if record.index != index:
                issues.append(f"frame {index}: record index {record.index}")
            if record.reserved:
                issues.append(f"frame {index}: reserved {record.reserved:#x}")
            if empty:
                continue
            if record.offset != expected_offset:
                issues.append(f"frame {index}: offset {record.offset} != {expected_offset}")
            expected_offset = record.offset + record.packed_bytes
            last_end = max(last_end, expected_offset)
            packed_total += record.packed_bytes
            chunk = data[record.offset:record.offset + record.packed_bytes]
            plain, end = fx.lzss_reference(chunk)
            ends[end] = ends.get(end, 0) + 1
            state = fx.AvfLzssState()
            status = lib.avf_lzss_expand(fx.ubuf(chunk), len(chunk), None,
                                         record.unpacked_bytes, c.byref(state))
            if status != fx.OK or state.produced != record.unpacked_bytes:
                issues.append(f"frame {index}: lzss {fx.STATUS[status]} produced "
                              f"{state.produced} of {record.unpacked_bytes}")
            if len(plain) != record.unpacked_bytes:
                issues.append(f"frame {index}: reference produced {len(plain)}")
            if record.type == 0 and record.unpacked_bytes != f.frame_bytes:
                issues.append(f"frame {index}: key frame of {record.unpacked_bytes} bytes")
        row.update({
            "records": kinds, "lzss_end": ends, "packed_bytes": packed_total,
            "max_unpacked": f.max_unpacked, "trailing_bytes": len(data) - last_end,
            "delta_dependencies": kinds.get("type2", 0) + kinds.get("empty2", 0),
            "working_memory_bytes": {
                "single": f.frame_bytes + f.max_unpacked,
                "double": 2 * f.frame_bytes + f.max_unpacked,
                "original_stack_lzss": 0x1058},
            "issues": issues,
        })
        rows.append(row)
        for k, v in kinds.items():
            totals[k] = totals.get(k, 0) + v
        totals["frames"] = totals.get("frames", 0) + f.frame_count
        totals["files"] = totals.get("files", 0) + 1
    return {"totals": totals, "files": rows,
            "notes": ["record +0x0 (index) and +0xf (reserved) are not read by the original",
                      "header +0x1c is not read by the decoder routines; S03-2 owns timing"]}


def run_mutations(args: argparse.Namespace, tmp: Path) -> dict[str, Any]:
    source = (PROJECT / "src/avf_decoder.c").read_text()
    results = {}
    for name, (old, new) in MUTATIONS.items():
        if source.count(old) != 1:
            results[name] = "pattern not found"
            continue
        path = tmp / f"mut_{name}.c"
        path.write_text(source.replace(old, new))
        lib_path = tmp / f"libavf_{name}.dylib"
        build_native(path, lib_path, ["-w"])
        sub = argparse.Namespace(**{**vars(args), "native_library": str(lib_path),
                                    "mutations": False, "limit": 2, "corpus_only": False})
        report = run(sub)
        results[name] = report["total_mismatches"]
        print(f"mutation {name}: {results[name]} mismatches", flush=True)
    return results


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--exe", default=str(DEFAULT_EXE))
    parser.add_argument("--native-library", default=str(PROJECT / "build/libavfdecoder.dylib"))
    parser.add_argument("--report", default=str(DEFAULT_REPORT))
    parser.add_argument("--limit", type=int, default=0, help="first N corpus files only")
    parser.add_argument("--corpus-only", action="store_true")
    parser.add_argument("--mutations", action="store_true")
    parser.add_argument("--no-write", action="store_true")
    parser.add_argument("--inventory", metavar="JSON",
                        help="write the corpus coverage matrix and exit")
    args = parser.parse_args()
    if args.inventory:
        result = inventory(fx.bind(Path(args.native_library)))
        Path(args.inventory).write_text(json.dumps(result, indent=1) + "\n")
        print(json.dumps(result["totals"]))
        return 0
    report = run(args)
    text = json.dumps(report, indent=1, default=str)
    if not args.no_write:
        Path(args.report).write_text(text + "\n")
    print(json.dumps({k: report[k] for k in ("total_mismatches", "elapsed_seconds")}))
    print(json.dumps({f: v["counts"] for f, v in report["formats"].items()}, indent=1))
    return 0 if report["total_mismatches"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
