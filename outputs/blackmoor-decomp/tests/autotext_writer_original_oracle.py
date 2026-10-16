#!/usr/bin/env python3
"""Compare the native AUTOTEXT writer with the original GAME.EXE code (RT-32a).

Original code that runs unmodified under Unicorn:

* 0x436bba..0x436cfa: per-font glyph size table and sheet refcount reset;
* 0x4c2f02..0x4c3150: pixel format and colour key from channel masks;
* 0x413187 (AUTOTEXT writer, thiscall on the owner object 0x619a41) and
  everything it calls: 0x412db8 line flusher, 0x4d3836 width, 0x4d214b glyph
  map, 0x4d270b glyph draw, 0x4c5b3a keyed blit, 0x4c46d1 clear, 0x4c9340
  colour scan, 0x4c924d / 0x4c92c5 font-sheet refcount, 0x4c2a8d surface
  create, 0x4c2dfb surface free, 0x4c2e5b, CRT atoi / ctype / sprintf.

Intercepted boundaries (every one is recorded as an event or a number):

* 0x51dc43 operator new / 0x51dc6c operator delete (allocation);
* 0x4c2790 surface load (font sheets and the "AutoText Overlays Surface"
  picture): returns synthetic surfaces; a missing one reproduces the
  report + quit path of 0x4c287c..0x4c2889 (returns 0);
* 0x52139c message box, 0x42639d error report, 0x4c97b4 PostQuitMessage
  wrapper (fatal paths), 0x4264e8 debug log.

Observed without altering execution: 0x4c2a8d, 0x4c2dfb, 0x412db8, 0x4d270b,
0x4c5b3a (from the writer). Font sheets, overlay and entry-mark sheet are
deterministic synthetic pixels given identically to both sides (the real
CIFTREE sheets are not part of the private evidence set); BOOT FONT / MARK
records and the AUTOTEXT strings are real.

Run from the repository root:

    python3 outputs/blackmoor-decomp/tests/autotext_writer_original_oracle.py
    python3 .../autotext_writer_original_oracle.py --mutants
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_autotext_writer as fx  # noqa: E402
from autotext_original_oracle import (EXPECTED_EXE_SHA256, RESOURCE_PATH as AUTOTEXT_PATH,  # noqa: E402
                                      _read_cvtx_payload, parse_entries)
from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256  # noqa: E402

ROOT = fx.ROOT
PROJECT = fx.PROJECT
SLICES = ROOT / "work/analysis/slices"

WRITER_VA = 0x413187
WRITER_END = 0x414411
FLUSHER_VA = 0x412DB8
OWNER = 0x619A41
OWNER_SIZE = 0x2950
GFX_OBJECT = 0x5CF659
FONT_TABLE = 0x5A4C24
FONT_COUNT = 0x5B0264
SHEET_REFCOUNT = 0x5AFBDA
SHEET_HANDLES = 0x5D032F
SLOT_TABLE = 0x5D0397
MARK_SHEET_GLOBAL = 0x5D0377
MARK_TABLE = 0x5AFC7E
TRANSPARENT = 0x5B0257
BYTES_PER_PIXEL = 0x639895
BITS_PER_PIXEL = 0x639893
DEBUG_FLAG = 0x63A4CD
SPRINTF_BUFFER = 0x63888B
CODE_WINDOWS = [
    (0x413187, 0x41440E), (0x412DB8, 0x413187), (0x4C5B3A, 0x4C5C54), (0x4C2A8D, 0x4C2BFB),
    (0x4C2DFB, 0x4C2E5B), (0x4C2E5B, 0x4C2E97),
]

HOOKS = {  # intercepted: address -> bytes the callee pops
    0x51DC43: 0x0,   # operator new (cdecl)
    0x51DC6C: 0x0,   # operator delete (cdecl)
    0x4C2790: 0x10,  # surface load (font sheet / overlay)
    0x52139C: 0xC,   # message box
    0x42639D: 0x8,   # error report
    0x4C97B4: 0x0,   # quit
    0x4264E8: 0x4,   # debug log
}
OBSERVED = (0x4C2A8D, 0x4C2DFB, FLUSHER_VA, 0x4D270B, 0x4C5B3A)

STACK = 0x10000000
STACK_SIZE = 0x80000
HEAP = 0x20000000
HEAP_SIZE = 0x08000000
PERSIST = HEAP
CASE_HEAP = HEAP + 0x01000000
SENTINEL = 0x3F000000
ISO_BASE = 0x40000000
ISO_STRIDE = 0x00800000
GUARD = 64


class OracleError(RuntimeError):
    pass


class Original:
    def __init__(self, exe: Path, data: fx.SyntheticData, masks) -> None:
        from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL, Uc
        from unicorn import x86_const as x

        self.x = x
        self.data = data
        self.pe = PEImage.parse_and_map(exe)
        if sha256(self.pe.data) != EXPECTED_EXE_SHA256:
            raise OracleError("GAME.EXE identity mismatch")
        uc = Uc(UC_ARCH_X86, UC_MODE_32)
        base = self.pe.image_base
        uc.mem_map(base, (self.pe.size_of_image + 0xFFF) & ~0xFFF, UC_PROT_ALL)
        uc.mem_write(base, self.pe.image)
        for addr, size in ((STACK, STACK_SIZE), (HEAP, HEAP_SIZE), (SENTINEL, 0x1000)):
            uc.mem_map(addr, size, UC_PROT_ALL)
        uc.mem_write(SENTINEL, b"\xCC" * 0x1000)
        self.uc = uc
        self.persist_cursor = PERSIST
        self.cursor = CASE_HEAP
        self.allocs: list[tuple[int, int]] = []
        self.iso: dict[Any, int] = {}
        self.iso_next = 0
        self.events: list[tuple] = []
        self.hook_counts: dict[int, int] = {a: 0 for a in list(HOOKS) + list(OBSERVED)}
        self.fail_next_alloc = False
        self.case = None
        self.target_note = None
        for address in HOOKS:
            uc.hook_add(UC_HOOK_CODE, self._hook, begin=address, end=address)
        for address in OBSERVED:
            uc.hook_add(UC_HOOK_CODE, self._observe, begin=address, end=address)
        self.format: dict[str, Any] = {}
        self._boot(masks)

    # -- helpers -----------------------------------------------------------
    def r(self, addr: int, n: int) -> bytes:
        return bytes(self.uc.mem_read(addr, n))

    def w(self, addr: int, data: bytes) -> None:
        self.uc.mem_write(addr, data)

    def u32(self, addr: int) -> int:
        return struct.unpack("<I", self.r(addr, 4))[0]

    def s16(self, addr: int) -> int:
        return struct.unpack("<h", self.r(addr, 2))[0]

    def cstr(self, addr: int) -> bytes:
        out = bytearray()
        while len(out) < 70000:
            chunk = self.r(addr + len(out), 64)
            end = chunk.find(b"\0")
            if end >= 0:
                return bytes(out + chunk[:end])
            out += chunk
        raise OracleError("unterminated string")

    def reg(self, name: str) -> int:
        return self.uc.reg_read(getattr(self.x, f"UC_X86_REG_{name}"))

    def setreg(self, name: str, value: int) -> None:
        self.uc.reg_write(getattr(self.x, f"UC_X86_REG_{name}"), value & 0xFFFFFFFF)

    def arg(self, i: int) -> int:
        return self.u32(self.reg("ESP") + 4 + 4 * i)

    def sarg16(self, i: int) -> int:
        return struct.unpack("<h", struct.pack("<H", self.arg(i) & 0xFFFF))[0]

    def alloc(self, size: int, fill: int = 0xEE, persist: bool = False, guard: bool = True) -> int:
        pad = GUARD if guard else 0
        cursor = self.persist_cursor if persist else self.cursor
        start = (cursor + pad + 15) & ~15
        end = start + size + pad
        limit = CASE_HEAP if persist else HEAP + HEAP_SIZE
        if end > limit:
            raise OracleError("oracle heap exhausted")
        if persist:
            self.persist_cursor = end
        else:
            self.cursor = end
        if pad:
            self.w(start - pad, bytes([fx.GUARD_BYTE]) * pad)
            self.w(start + size, bytes([fx.GUARD_BYTE]) * pad)
            if not persist:
                self.allocs.append((start, size))
        self.w(start, bytes([fill]) * size)
        return start

    def iso_map(self, token, data: bytes) -> int:
        """Maps `data` ending at a page boundary with unmapped neighbours, so
        a read past either end faults instead of returning neighbouring bytes."""
        from unicorn import UC_PROT_ALL

        if token in self.iso:
            return self.iso[token]
        base = ISO_BASE + self.iso_next * ISO_STRIDE
        self.iso_next += 1
        size = (len(data) + 0xFFF) & ~0xFFF
        self.uc.mem_map(base, size, UC_PROT_ALL)
        start = base + size - len(data)
        self.w(start, data)
        self.iso[token] = start
        self.iso_maps = getattr(self, "iso_maps", []) + [(base, size)]
        return start

    def release_iso(self) -> None:
        for base, size in getattr(self, "iso_maps", []):
            self.uc.mem_unmap(base, size)
        self.iso_maps = []
        self.iso = {}
        self.iso_next = 0

    def block(self, start: int, stop: int, locals_: dict[int, int] | None = None) -> None:
        frame = STACK + 0x40000
        self.w(frame - 0x1000, b"\xCC" * 0x1000)
        for offset, value in (locals_ or {}).items():
            self.w(frame + offset, struct.pack("<I", value & 0xFFFFFFFF))
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI"):
            self.setreg(name, 0)
        self.setreg("EBP", frame)
        self.setreg("ESP", frame - 0x1000)
        self.uc.emu_start(start, stop, count=50_000_000)
        if self.reg("EIP") != stop:
            raise OracleError(f"block 0x{start:x} stopped at 0x{self.reg('EIP'):x}")

    def call(self, address: int, ecx: int, args: list[int], max_instructions=50_000_000) -> int:
        """Calls an original function (stdcall/thiscall callee-pops) and returns EAX."""
        esp = STACK + STACK_SIZE - 0x800
        self.w(esp, struct.pack("<I", SENTINEL) + b"".join(struct.pack("<I", a & 0xFFFFFFFF)
                                                          for a in args))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.setreg(name, 0)
        self.setreg("ECX", ecx)
        self.setreg("ESP", esp)
        self.uc.emu_start(address, SENTINEL, count=max_instructions)
        if self.reg("EIP") != SENTINEL:
            raise OracleError(f"call 0x{address:x} did not return")
        return self.reg("EAX")

    def _boot(self, masks) -> None:
        d = self.data
        self.w(FONT_TABLE, d.font_chunk)
        self.w(FONT_COUNT, struct.pack("<h", d.font_count))
        self.block(0x436BBA, 0x436CFA)
        self.w(TRANSPARENT, d.transparent)
        red, green, blue = masks
        self.block(0x4C2F02, 0x4C3150, {-0x88: GFX_OBJECT, -0x28: red, -0x24: green, -0x20: blue})
        self.w(BYTES_PER_PIXEL, struct.pack("<h", 2))
        self.w(BITS_PER_PIXEL, struct.pack("<h", 16))
        self.format = {
            "shifts": list(self.r(GFX_OBJECT + 0x38C0, 3)),
            "masks": list(self.r(GFX_OBJECT + 0x38C4, 3)),
            "bits": list(self.r(GFX_OBJECT + 0x38C8, 3)),
            "color_key": struct.unpack("<H", self.r(GFX_OBJECT + 0x38D0, 2))[0],
        }
        self.glyph_sizes = self.r(0x5ADB3A, 0x1D0 * fx.MAX_FONTS)
        self.w(MARK_TABLE, d.mark)
        pixels, width, height, pitch = d.mark_sheet(self.format["color_key"])
        obj = self.alloc(0x59, persist=True, guard=False)
        self.w(obj, struct.pack("<I", self.iso_map(("mark",), pixels)))
        self.w(obj + 0x2B, struct.pack("<hhh", width, height, pitch))
        self.w(MARK_SHEET_GLOBAL, struct.pack("<I", obj))
        self.mark_iso = list(self.iso.items())

    # -- state snapshots -------------------------------------------------------
    def slot_info(self, index: int):
        ptr = self.u32(SLOT_TABLE + 4 * index)
        if not ptr:
            return None
        pixels, = struct.unpack("<I", self.r(ptr, 4))
        width, height, pitch = struct.unpack("<hhh", self.r(ptr + 0x2B, 6))
        return ptr, pixels, width, height, pitch

    def owner_image(self) -> bytes:
        image = bytearray(self.r(OWNER, OWNER_SIZE))
        overlay = struct.unpack_from("<I", image, 6)[0]
        struct.pack_into("<I", image, 6, 1 if overlay else 0)
        target = struct.unpack_from("<I", image, 0xA)[0]
        index = 0
        if target:
            index = 0x7FFF
            for i in range(fx.SLOTS):
                if self.u32(SLOT_TABLE + 4 * i) == target:
                    index = i + 1
        struct.pack_into("<I", image, 0xA, index)
        return bytes(image)

    def snapshot(self) -> tuple:
        refs = struct.unpack("<18h", self.r(SHEET_REFCOUNT, 36))
        slots = []
        for i in range(fx.SLOTS):
            info = self.slot_info(i)
            if info is None:
                slots.append(None)
            else:
                _, pixels, width, height, pitch = info
                slots.append(hashlib.sha256(self.r(pixels, pitch * height)).hexdigest()[:12])
        return (tuple(refs), tuple(slots), hashlib.sha256(self.owner_image()).hexdigest()[:12])

    def add(self, *event) -> None:
        self.events.append(tuple(event) + self.snapshot())

    # -- hooks ---------------------------------------------------------------
    def _observe(self, uc, address, _size, _user) -> None:
        self.hook_counts[address] += 1
        ret = self.u32(self.reg("ESP"))
        if address == 0x4C2A8D:
            self.add("create", self.sarg16(0), self.sarg16(1), self.cstr(self.arg(3)).decode())
        elif address == 0x4C2DFB:
            pointer = self.arg(0)
            if SLOT_TABLE <= pointer < SLOT_TABLE + 4 * fx.SLOTS:
                self.add("free", "slot", (pointer - SLOT_TABLE) // 4)
            elif pointer == OWNER + 6:
                self.add("free", "overlay")
            elif SHEET_HANDLES <= pointer < SHEET_HANDLES + 4 * fx.MAX_FONTS:
                self.add("free", "font", (pointer - SHEET_HANDLES) // 4)
            else:
                raise OracleError(f"0x4c2dfb on unexpected pointer 0x{pointer:x}")
        elif address == FLUSHER_VA:
            if self.reg("ECX") != OWNER:
                raise OracleError("0x412db8 on unexpected object")
            self.add("flush", self.cstr(self.arg(0)).decode("latin1"), self.sarg16(1),
                     self.s16(self.arg(6)), self.s16(self.arg(3)), self.s16(self.arg(7)))
        elif address == 0x4D270B:
            if FLUSHER_VA <= ret < WRITER_VA:
                font = (self.arg(1) - FONT_TABLE) // fx.cap.FONT_RECORD
                self.add("draw", self.cstr(self.arg(0)).decode("latin1"), font, self.sarg16(3),
                         self.sarg16(4), self.sarg16(7))
        elif address == 0x4C5B3A:
            if WRITER_VA <= ret < WRITER_END:
                self.add("blit", self.cstr(self.arg(4)).decode(),
                         struct.unpack("<4i", self.r(self.arg(2), 16)),
                         struct.unpack("<4i", self.r(self.arg(3), 16)))

    def _hook(self, uc, address, _size, _user) -> None:
        self.hook_counts[address] += 1
        pop = HOOKS[address]
        value = 0
        if address == 0x51DC43:
            size = self.arg(0)
            if self.fail_next_alloc:
                self.fail_next_alloc = False
                self.events.append(("alloc_failed", size))
            else:
                value = self.alloc(size)
        elif address == 0x51DC6C:
            pass
        elif address == 0x4C2790:
            desc = self.cstr(self.arg(3))
            name = self.cstr(self.arg(1))
            if desc == b"AutoText Overlays Surface":
                self.add("load_overlay", name.decode())
                if not self.case.missing_overlay:
                    width, height = fx.overlay_dims(self.case.entry)
                    pixels, w, h, pitch = self.data.overlay(name, width, height,
                                                            self.format["color_key"])
                    value = self.make_surface(("overlay", name, w, h), pixels, w, h, pitch)
                else:
                    self.events += [("load_failed", "overlay"), ("error",), ("quit",)]
            else:
                font = (self.arg(1) - FONT_TABLE) // fx.cap.FONT_RECORD
                self.add("load_font", font, name.decode())
                if font not in self.case.missing_fonts:
                    pixels, w, h, pitch = self.data.font_sheet(font, self.format["color_key"])
                    value = self.make_surface(("font", font), pixels, w, h, pitch)
                else:
                    self.events += [("load_failed", font), ("error",), ("quit",)]
        elif address == 0x52139C:
            self.events.append(("message", self.cstr(self.arg(0))))
        elif address == 0x42639D:
            self.events.append(("error",))
        elif address == 0x4C97B4:
            self.events.append(("quit",))
        elif address == 0x4264E8:
            self.add("debug_log", self.cstr(self.arg(0)).decode())
        esp = self.reg("ESP")
        ret = struct.unpack("<I", self.r(esp, 4))[0]
        self.setreg("EAX", value)
        self.setreg("ESP", esp + 4 + pop)
        self.setreg("EIP", ret)

    def make_surface(self, token, pixels: bytes, width: int, height: int, pitch: int) -> int:
        obj = self.alloc(0x59, guard=False)
        self.w(obj, struct.pack("<I", self.iso_map(token, pixels)))
        self.w(obj + 0x2B, struct.pack("<hhh", width, height, pitch))
        self.w(obj + 0x35, struct.pack("<4i", 0, 0, width - 1, height - 1))
        return obj

    # -- one case ------------------------------------------------------------
    def reset(self, case: fx.Case) -> None:
        self.case = case
        self.release_iso()
        for token, start in self.mark_iso:
            pass
        # The entry-mark sheet mapping is persistent: map it again.
        pixels, width, height, pitch = self.data.mark_sheet(self.format["color_key"])
        obj = self.u32(MARK_SHEET_GLOBAL)
        self.w(obj, struct.pack("<I", self.iso_map(("mark",), pixels)))
        self.cursor = CASE_HEAP
        self.allocs = []
        self.events = []
        self.fail_next_alloc = False
        self.w(SHEET_REFCOUNT, bytes(2 * fx.MAX_FONTS))
        self.w(SHEET_HANDLES, bytes(4 * fx.MAX_FONTS))
        self.w(SLOT_TABLE, bytes(4 * fx.SLOTS))
        self.w(DEBUG_FLAG, struct.pack("<h", case.debug))
        self.w(OWNER, b"\x5a" * OWNER_SIZE)
        self.w(OWNER + 6, bytes(8))
        self.w(OWNER + 0x2930, struct.pack("<i", case.preset.get("pictures_seen", 0)))
        for index, (width, height) in case.preset_slots.items():
            obj = self.call(0x4C2A8D, GFX_OBJECT, [width, height, 6, self.alloc_string(
                b"AUTO TEXT SURFACE")])
            pixels = self.u32(obj)
            self.w(pixels, b"\xC3" * (width * 2 * height))
            self.w(SLOT_TABLE + 4 * index, struct.pack("<I", obj))
        self.events = []
        self.allocs = [a for a in self.allocs]  # preset surfaces keep their guards checked

    def alloc_string(self, text: bytes) -> int:
        return self.alloc(len(text) + 1, 0) and self._string(text)

    def _string(self, text: bytes) -> int:
        address = self.alloc(len(text) + 1, 0, guard=False)
        self.w(address, text + b"\0")
        return address

    def run(self, case: fx.Case) -> dict[str, Any]:
        self.reset(case)
        entry = self.alloc(fx.ENTRY_BYTES)
        self.w(entry, case.entry)
        text = self.alloc(len(case.text) + 1)
        self.w(text, case.text + b"\0")
        rects = count = 0
        if case.rects is not None:
            rects = self.alloc(max(1, case.rects) * 16, 0x6B)
        if case.rects is not None or case.count_ptr:
            count = self.alloc(2)
            self.w(count, struct.pack("<H", 0x7777))
        esp = STACK + STACK_SIZE - 0x800
        self.w(esp, struct.pack("<IIIII", SENTINEL, entry, text, rects, count))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.setreg(name, 0)
        self.setreg("ECX", OWNER)
        self.setreg("ESP", esp)
        self.fail_next_alloc = case.fail_create
        outcome: dict[str, Any] = {"terminated": True, "trapped": None}
        try:
            self.uc.emu_start(WRITER_VA, SENTINEL, count=case.max_instructions)
        except Exception as exc:  # noqa: BLE001 - the original faulted
            outcome["trapped"] = f"0x{self.reg('EIP'):x}: {exc}"
        if outcome["trapped"] is None and self.reg("EIP") != SENTINEL:
            outcome["terminated"] = False
        if outcome["trapped"] is None and outcome["terminated"] and \
                self.reg("ESP") != esp + 4 + 0x10:
            raise OracleError(f"{case.label}: unbalanced stack")
        outcome["events"] = self.events
        outcome["owner"] = self.owner_image()
        slots = []
        for i in range(fx.SLOTS):
            info = self.slot_info(i)
            if info is None:
                slots.append(None)
            else:
                _, pixels, width, height, pitch = info
                slots.append((width, height,
                              hashlib.sha256(self.r(pixels, pitch * height)).hexdigest()))
        outcome["slots"] = slots
        outcome["refcounts"] = tuple(struct.unpack("<18h", self.r(SHEET_REFCOUNT, 36)))
        outcome["handles"] = tuple(v != 0 for v in struct.unpack("<18I",
                                                               self.r(SHEET_HANDLES, 72)))
        outcome["entry"] = self.r(entry, fx.ENTRY_BYTES)
        n = struct.unpack("<h", self.r(count, 2))[0] if count else 0x7777
        outcome["count"] = n if count else 0x7777
        outcome["rects"] = ([struct.unpack("<4i", self.r(rects + 16 * i, 16)) for i in range(n)]
                            if rects and 0 <= n <= case.rects else [])
        outcome["overlay"] = bool(self.u32(OWNER + 6))
        outcome["guards_ok"] = all(
            self.r(a - GUARD, GUARD) == bytes([fx.GUARD_BYTE]) * GUARD and
            self.r(a + s, GUARD) == bytes([fx.GUARD_BYTE]) * GUARD for a, s in self.allocs)
        outcome["fatal"] = [e for e in self.events if e[0] in ("error", "quit", "message",
                                                               "load_failed", "alloc_failed")]
        outcome["events"] = [e for e in self.events if e[0] not in (
            "error", "quit", "message", "load_failed", "alloc_failed")]
        return outcome


# ---------------------------------------------------------------------------
# Cases
# ---------------------------------------------------------------------------

def normalise(native: dict) -> dict:
    return native


def compare(case: fx.Case, original: dict, native: dict) -> tuple[str, list[str]]:
    """Returns (outcome, differing fields)."""
    status = native["status"]
    name = fx.STATUS_NAMES[status]
    unsafe = []
    if original["trapped"]:
        unsafe.append("trapped")
    if not original["terminated"]:
        unsafe.append("nonterminating")
    if original["fatal"]:
        unsafe.append("fatal")
    if not original["guards_ok"]:
        unsafe.append("outside_surface")
    if case.expect is not None:
        outcome = "expected_" + case.expect.lower()
        diff = []
        if name != case.expect:
            diff.append(f"status {name} != {case.expect}")
        if case.expect in ("LIMIT", "FORMAT", "FONT", "UNSUPPORTED", "SURFACE_INDEX", "ARGUMENT"):
            if native["events"] != [] or native["slots"] != [None] * fx.SLOTS or \
                    native["refcounts"] != (0,) * fx.MAX_FONTS or native["count"] != 0x7777 or \
                    native["entry"] != case.entry:
                diff.append("pass-1 rejection changed state")
        return outcome + (":" + "+".join(unsafe) if unsafe else ""), diff
    if unsafe:
        # The original overran, faulted or never ended: the native writer must
        # have rejected the input explicitly (documented separately).
        label = "unsafe_original_native_rejects:" + "+".join(unsafe)
        if status == fx.OK:
            return "unexpected_" + label, ["original unsafe but native accepted: " +
                                           ",".join(unsafe)]
        return label, []
    if status != fx.OK:
        return "ok", [f"native status {name}"]
    diff = []
    for key in ("events", "owner", "slots", "refcounts", "handles", "entry", "count", "rects",
                "overlay"):
        if original[key] != native[key]:
            diff.append(key)
    if not native["guards_ok"]:
        diff.append("native guard bytes")
    return "ok", diff


def build_cases(data: fx.SyntheticData, entries: dict[bytes, bytes], corpus_rows: list[dict]):
    words = b"The quick brown fox jumps over the lazy dog, again and again. "
    E = fx.make_entry
    C = fx.Case
    cases: list[fx.Case] = []
    for row in corpus_rows:
        cases.append(C(f"corpus-{row['resource_index']}-{row['key']}", "corpus", row["prefix"],
                       row["text"]))
        # Same text on every other surface slot, pre-existing smaller surface.
    cases += [
        C("corpus-reuse-big-slot", "resize", corpus_rows[1]["prefix"], corpus_rows[1]["text"],
          preset_slots={0: (500, 400)}),
        C("corpus-resize-small-slot", "resize", corpus_rows[1]["prefix"], corpus_rows[1]["text"],
          preset_slots={0: (100, 50)}),
        C("corpus-resize-narrow-only", "resize", corpus_rows[1]["prefix"], corpus_rows[1]["text"],
          preset_slots={0: (300, 500)}),
        C("corpus-resize-short-only", "resize", corpus_rows[1]["prefix"], corpus_rows[1]["text"],
          preset_slots={0: (500, 100)}),
        C("corpus-debug", "resize", corpus_rows[2]["prefix"], corpus_rows[2]["text"], debug=1),
    ]
    # every surface index
    for index in range(6):
        cases.append(C(f"surface-{index}", "surfaces", E(surface=index), words + b"<n>"))
        cases.append(C(f"surface-{index}-mode0-preset", "surfaces", E(surface=index, mode=0),
                       b"short<n>", preset_slots={index: (389, 157)}))
    # every font, both colour variants
    for font in range(data.font_count):
        for color in (0, 1):
            cases.append(C(f"font{font}-c{color}", "fonts",
                           E(font=font, color=color, width=420, height=200),
                           b"Hello, World! 0123456789 (a+b)=c; 'x' _y_ {z} <n>"
                           b"Cafe \xe9\xe8\xe0 fin<n>"))
    # tags
    tag_texts = {
        "n-w": b"one<n>two<w>three<n>four<n>",
        "l-tight": b"a<n>b<l>c<n>d<l>e<n>f<n>",
        "r-align": b"left<r>right side<n>next<n>",
        "r-nonempty": b"abc<r>def<n>",
        "c-colors": b"<c0>plain <c1>tinted<n><c0>back<n>",
        "f-switch": b"<f4>four <f5>five <f1>one<n><f0>zero <f13>thirteen<n>",
        "f-at-line-gt-0": b"first<n><f5>second<n>",
        "u-underline": b"plain <u>under line<u> after<n>",
        "u-twice": b"<u>x<u>y<u>z<u><n>",
        "u-colored": b"<c1><u>tinted underline<u><n>",
        "t-tab": b"a<t>b<t>c<n>",
        "e-stop": b"stop here<e> never drawn<n>",
        "unknown-tags": b"<h>x<o>y<d>z<v>w<q>q<n>",
        "stray-close-repeats-tag": b"<n>abc>def<n>",
        "nested-open-resets-tag": b"ab<f<n>cd<n>",
        "atoi-whitespace-sign": b"<f +5>x<c -0>y<n>",
        "unclosed-tag-at-end": b"abc<n>def<f",
        "empty": b"",
        "only-terminator": b"<e>",
        "latin1-unmapped": bytes([0x43, 0x61, 0x66, 0xE9, 0x20, 0x80, 0xA1, 0xBF, 0xFF, 0x7E,
                                  0x40, 0x22, 0x5C, 0x23, 0x24, 0x7B, 0x7D, 0x5F]) + b"<n>",
        "all-ascii-spaced": b" ".join(bytes([v]) for v in list(range(0x21, 0x3C)) +
                                       list(range(0x3F, 0x7F))) + b"<n>",
        "all-mapped-high": b" ".join(bytes([v]) for v in (
            0x80, 0xA1, 0xBF, 0xC0, 0xC4, 0xC5, 0xC9, 0xD1, 0xD6, 0xDC, 0xDF, 0xE0, 0xE1, 0xE2,
            0xE4, 0xE5, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xF1, 0xF3, 0xF4, 0xF6, 0xF9,
            0xFA, 0xFC)) + b"<n>",
        "hotspots": b"<H3>first<n><L>between<H7>x y<n><L><H3>again<n><L>",
        "hotspot-after-mark": b"<2>marked <H0>text<n><L>",
        "hotspot-multi": b"<H1>a<n>b<n><L><H2>c<n><L>",
    }
    for label, text in tag_texts.items():
        cases.append(C(f"tag-{label}", "tags", E(top=12, width=300, height=200), text))
    # wrapping
    narrow = E(width=120, height=80)
    cases += [
        C("wrap-draw", "wrap", E(), words * 4 + b"<n>"),
        C("wrap-narrow", "wrap", narrow, words * 3 + b"<n>"),
        C("wrap-segments", "wrap", E(), b"<c1>" + words + b"<c0>" + words + b"<c1>" + words
          + b"<n>"),
        C("wrap-leading-space", "wrap", E(), b" " + b"x" * 30 + b"<n>"),
        C("wrap-long-word", "wrap", E(), b"x" * 120 + b" y<n>"),
        C("wrap-margins", "wrap", E(left=17, top=9, width=250, height=90), words * 2 + b"<n>"),
        C("wrap-newline-then-wrap", "wrap", E(), b"a<n>" + words * 2 + b"<n>b<n>"),
        C("wrap-long-text-height", "wrap", E(width=200, height=40), words * 12 + b"<n>"),
        C("wrap-half-spacing", "wrap", E(), words + b"<w>" + words + b"<w><n>"),
        C("wrap-tight", "wrap", E(), b"<l>" + words * 2 + b"<n>"),
        C("wrap-right-then-text", "wrap", E(), b"abc<r>" + words + b"<n>"),
    ]
    # y limit (flusher stops) with and without debug logging
    tiny = E(width=120, height=-14)  # height_arg = 6: stops after the first line
    cases += [
        C("ylimit-silent", "ylimit", tiny, words * 3 + b"<n>"),
        C("ylimit-debug", "ylimit", tiny, words * 3 + b"<n>", debug=1),
        C("ylimit-debug-tags", "ylimit", E(width=150, height=10), (words + b"<n>") * 6, debug=1),
    ]
    # sweep the y limit across every value so the pen lands exactly on it
    for height in range(-12, 70, 1):
        cases.append(C(f"ylimit-sweep-{height}", "ylimit",
                       E(top=0, width=300, height=height), b"a<n>b<n>c<n>d<n>"))
    for height in range(-12, 40, 3):
        cases.append(C(f"ylimit-debug-sweep-{height}", "ylimit",
                       E(top=0, width=300, height=height), b"a<n>b<n>c<n>d<n>", debug=1))
    # entry marks and rects
    mark_entry = E(top=20, left=3, width=300, height=200)
    cases += [
        C("marks-default-entry", "marks", E(), b"<1>one <3>three <7>seven<n>", rects=4,
          expect="BOUNDS"),
        C("marks-one", "marks", mark_entry, b"<1>text after the mark<n>", rects=4),
        C("marks-all", "marks", mark_entry, b"<1>a<2>b<3>c<4>d<5>e<7>f<n>", rects=8),
        C("marks-no-rects", "marks", mark_entry, b"<3>no rect array<n>"),
        C("marks-count-only", "marks", mark_entry, b"<3>x<n>", rects=None, count_ptr=True),
        C("marks-line1", "marks", mark_entry, b"line zero<n><2>mark on line one<n><4>again<n>",
          rects=3),
        C("marks-with-wrap", "marks", mark_entry, b"<1>" + words * 2 + b"<n><2>" + words + b"<n>",
          rects=2),
        C("marks-then-hotspot", "marks", mark_entry, b"<H1><1>mark<n><L>", rects=1),
        C("marks-line0-top0", "marks", E(top=0, width=300, height=200), b"<1>x<n>",
          rects=1),
    ]
    # pictures
    pic0 = E(top=6, pic_name=b"PICTURE0", pictures=[(0, 2, 2, 41, 31)], width=300, height=200)
    pic_multi = E(top=6, pic_name=b"PICTURE1", width=300, height=300,
                  pictures=[(0, 0, 0, 19, 14), (0, 3, 3, 12, 20), (1, 5, 5, 30, 44),
                            (3, 8, 8, 18, 12), (200, 0, 0, 5, 5)])
    pic_clamp = E(top=6, pic_name=b"PICTURE2", width=300, height=400,
                  pictures=[(i % 3, 0, 0, 7, 7) for i in range(12)])
    cases += [
        C("pic-line0", "pictures", pic0, b"text beside the picture<n>second<n>"),
        C("pic-multi", "pictures", pic_multi, b"zero<n>one<n>two<n>three<n>four<n>"),
        C("pic-tail-only", "pictures", E(pic_name=b"P3", pictures=[(5, 0, 0, 9, 9)], width=300,
                                          height=200), b"a<n>b<n>"),
        C("pic-clamp-to-10", "pictures", pic_clamp, b"a<n>b<n>c<n>d<n>"),
        C("pic-font-change-at-top", "pictures", pic0, b"<f5>after font<n>"),
        C("pic-empty-text", "pictures", pic0, b""),
        C("pic-with-marks", "pictures", E(top=20, pic_name=b"P4", pictures=[(0, 0, 0, 19, 19)],
                                          width=300, height=200), b"<1>m<n>b<n>", rects=2),
        C("pic-name-empty-no-load", "pictures", E(pictures=[(0, 0, 0, 3, 3)]), b"x<n>"),
        C("pic-persisted-flag-no-pictures", "pictures", E(), b"a<n>b<n>",
          preset={"pictures_seen": 1}),
        C("pic-flag-with-count-no-overlay", "pictures", E(pictures=[(0, 0, 0, 3, 3)]), b"x<n>",
          preset={"pictures_seen": 1}, expect="UNSUPPORTED"),
        C("pic-missing-overlay", "pictures", pic0, b"x<n>", missing_overlay=True,
          expect="BACKEND"),
        C("pic-outside-overlay", "pictures", E(top=6, pic_name=b"P5", pictures=[
            (0, 0, 0, 5000, 5000)], width=300, height=200), b"x<n>", expect="BOUNDS",
          max_instructions=60_000_000),
        C("pic-table-too-long", "pictures", E(count=14, pictures=[]), b"x<n>",
          preset={"pictures_seen": 1}, expect="FORMAT"),
        C("pic-count-14-clamped", "pictures", E(pic_name=b"P6", count=14, pictures=[]), b"x<n>"),
    ]
    # presets and resizing
    cases += [
        C("resize-same-size", "resize", E(), b"abc<n>", preset_slots={0: (389, 157)}),
        C("resize-grow-width", "resize", E(width=500), b"abc<n>", preset_slots={0: (389, 157)}),
        C("resize-grow-height", "resize", E(height=300), b"abc<n>", preset_slots={0: (389, 157)}),
        C("resize-other-slot-untouched", "resize", E(surface=2), b"abc<n>",
          preset_slots={0: (50, 50), 2: (10, 10), 5: (30, 30)}),
        C("resize-text-driven-height", "resize", E(width=200, height=10), words * 6 + b"<n>"),
    ]
    # rgb565 variants (colour key and clear pixel differ)
    for label in ("tag-u-colored", "corpus-reuse-big-slot", "font0-c1"):
        base = next(cs for cs in cases if cs.label == label)
        cases.append(C(base.label + "-rgb565", "rgb565", base.entry, base.text,
                       masks=fx.RGB565, preset_slots=base.preset_slots))
    cases.append(C("rgb565-marks", "rgb565", mark_entry, b"<1>x<n>", rects=2, masks=fx.RGB565))
    # documented unsafe / undefined original paths: native rejects before any effect
    cases += [
        C("bad-surface-index-6", "unsafe", E(surface=6), b"x<n>", expect="SURFACE_INDEX"),
        C("bad-surface-index-neg", "unsafe", E(surface=-1), b"x<n>", expect="SURFACE_INDEX"),
        C("bad-font-entry", "unsafe", E(font=18), b"x<n>", expect="FONT"),
        C("bad-font-tag", "unsafe", E(), b"<f18>x<n>", expect="FONT"),
        C("bad-font-tag-neg", "unsafe", E(), b"<f-1>x<n>", expect="FONT"),
        C("width-zero-divides", "unsafe", E(width=0), b"x<n>", expect="FORMAT"),
        C("close-without-tag", "unsafe", E(), b"abc>def<n>", expect="UNSUPPORTED"),
        C("L-before-H", "unsafe", E(), b"<L>x<n>", expect="UNSUPPORTED"),
        C("hotspot-index-400", "unsafe", E(), b"<H400>x<n><L>", expect="LIMIT"),
        C("hotspot-index-neg", "unsafe", E(), b"<H-1>x<n>", expect="LIMIT"),
        C("tag-argument-overflow", "unsafe", E(), b"<c" + b"9" * 30 + b">x<n>", expect="LIMIT"),
        C("text-buffer-overflow", "unsafe", E(width=300, height=300), b"x" * 40000,
          expect="LIMIT", max_instructions=20_000_000),
        C("rect-capacity", "unsafe", mark_entry, b"<1>a<2>b<3>c<n>", rects=2, expect="LIMIT"),
        C("color-variant-garbage", "unsafe", E(color=300), b"x<n>", expect="UNSUPPORTED"),
        C("create-fails", "unsafe", E(), b"x<n>", fail_create=True, expect="BACKEND"),
        C("missing-font-sheet", "unsafe", E(), b"a<f5>b<n>", missing_fonts=frozenset({5}),
          expect="BACKEND"),
        C("missing-initial-font-sheet", "unsafe", E(), b"a<n>", missing_fonts=frozenset({4}),
          expect="BACKEND"),
        C("zero-height-glyph-loops-forever", "unsafe", E(width=60, height=20), b"x" * 40,
          expect="OK_OR_UNSUPPORTED", max_instructions=30_000_000),
    ]
    cases = [cs for cs in cases if cs.expect != "OK_OR_UNSUPPORTED"]
    return cases


def load_corpus() -> list[dict]:
    corpus = json.loads((SLICES / "A-43.1.corpus.json").read_text())
    entries = parse_entries(_read_cvtx_payload(AUTOTEXT_PATH.read_bytes()))
    table = {}
    for e in entries:
        table.setdefault(e["key"].lower(), e["caption"])
    rows = []
    for row in corpus["records"]:
        data = (ROOT / "work/analysis/hiff-resources" /
                f"{row['resource_index']:04d}.bin").read_bytes()
        p, n = row["act_payload_offset"], row["act_payload_length"]
        act = data[p:p + n]
        body = act[50:]
        if sha256(body[:301]) != row["prefix_sha256"]:
            raise OracleError("corpus prefix hash mismatch")
        key = body[266:299].split(b"\0")[0].lower()
        rows.append({"resource_index": row["resource_index"], "key": key.decode(),
                     "prefix": bytes(body[:301]), "text": table[key]})
    return rows, entries


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------

def run(args: argparse.Namespace) -> dict[str, Any]:
    lib = fx.bind(args.native_library)
    data = fx.SyntheticData()
    corpus_rows, entries = load_corpus()
    by_key = {e["key"]: e["caption"] for e in entries}
    cases = build_cases(data, by_key, corpus_rows)
    if args.only:
        cases = [cs for cs in cases if re.search(args.only, cs.label)]
    machines: dict[tuple, Original] = {}
    contexts: dict[tuple, fx.NativeContext] = {}
    results, mismatches = [], []
    outcomes: dict[str, int] = {}
    groups: dict[str, int] = {}
    counts = {"events": 0, "owner_bytes": 0, "pixel_bytes": 0, "state_fields": 0}
    started = time.time()
    for case in cases:
        if case.masks not in machines:
            machines[case.masks] = Original(args.exe, data, case.masks)
            contexts[case.masks] = fx.NativeContext(lib, data, case.masks)
            m, n = machines[case.masks], contexts[case.masks]
            fmt = n.fmt
            if (list(fmt.shifts), list(fmt.masks), list(fmt.channel_bits), fmt.color_key) != (
                    m.format["shifts"], m.format["masks"], m.format["bits"], m.format["color_key"]):
                mismatches.append({"case": f"pixel-format-{case.masks}", "fields": ["format"]})
            native_sizes = c.string_at(c.addressof(n.fonts.glyph_size), fx.cap.GLYPHS * 4 *
                                       fx.MAX_FONTS)
            orig_sizes = b"".join(m.glyph_sizes[f * 0x1D0:f * 0x1D0 + fx.cap.GLYPHS * 4]
                                  for f in range(fx.MAX_FONTS))
            if native_sizes != orig_sizes:
                mismatches.append({"case": f"glyph-sizes-{case.masks}", "fields": ["glyph_size"]})
        m, n = machines[case.masks], contexts[case.masks]
        original = m.run(case)
        native = fx.native_run(n, case)
        outcome, diff = compare(case, original, native)
        outcomes[outcome] = outcomes.get(outcome, 0) + 1
        groups[case.group] = groups.get(case.group, 0) + 1
        if not diff and outcome == "ok":
            counts["events"] += len(native["events"])
            counts["owner_bytes"] += len(native["owner"])
            counts["pixel_bytes"] += sum(
                (s[0] * s[1] * 2) for s in native["slots"] if s is not None)
            counts["state_fields"] += 9
        entry = {"case": case.label, "group": case.group, "outcome": outcome,
                 "native_status": fx.STATUS_NAMES[native["status"]],
                 "events": len(native["events"]),
                 "glyphs": native["result"].glyphs_drawn}
        if original["trapped"]:
            entry["original_trap"] = original["trapped"]
        results.append(entry)
        if diff:
            mismatches.append({"case": case.label, "fields": diff, "outcome": outcome,
                               "original_events": original["events"][:6],
                               "native_events": native["events"][:6]})
    m = next(iter(machines.values()))
    code = {f"0x{a:x}-0x{b:x}": sha256(m.pe.image[a - m.pe.image_base:b - m.pe.image_base])
            for a, b in CODE_WINDOWS}
    return {
        "scope": "original 0x413187 AUTOTEXT writer (+ 0x412db8 flusher and callees) vs "
                 "native autotext_writer.c",
        "original_sha256": sha256(m.pe.data),
        "native_library_sha256": hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
        "source_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in (
            PROJECT / "src/autotext_writer.c", PROJECT / "src/autotext_writer.h",
            PROJECT / "src/caption_layout.c", PROJECT / "src/caption_layout_internal.h")},
        "input_sha256": {
            "autotext": sha256(AUTOTEXT_PATH.read_bytes()),
            "boot": sha256((fx.RESOURCES / "0053.bin").read_bytes()),
            "font": sha256((fx.RESOURCES / "0093.bin").read_bytes()),
            "corpus": sha256((SLICES / "A-43.1.corpus.json").read_bytes()),
        },
        "code_windows": code,
        "hooks": {f"0x{a:x}": {"pops": HOOKS[a], "calls": sum(
            mm.hook_counts[a] for mm in machines.values())} for a in HOOKS},
        "observed": {f"0x{a:x}": sum(mm.hook_counts[a] for mm in machines.values())
                     for a in OBSERVED},
        "cases": len(results), "groups": groups, "outcomes": outcomes, "compared": counts,
        "seconds": round(time.time() - started, 1), "results": results,
        "mismatches": mismatches,
    }


MUTANTS = [
    ("mark-x-advance", "src/autotext_writer.c", "wadd(mark_width, 3)", "wadd(mark_width, 2)"),
    ("mark-seven-record", "src/autotext_writer.c", "if ((int32_t)e->k + 1 == 7) {",
     "if ((int32_t)e->k + 1 == 8) {"),
    ("picture-y-line0", "src/autotext_writer.c", "(int32_t)e->cw * 3));", "(int32_t)e->cw * 2));"),
    ("picture-tail-test", "src/autotext_writer.c", "if (e->line > picture_line(e, index)) {",
     "if (e->line >= picture_line(e, index)) {"),
    ("half-spacing", "src/autotext_writer.c", "s16((h / 9 + h) / 2)", "s16((h / 9 + h) / 3)"),
    ("ylimit-compare", "src/autotext_writer.c", "if (e->y >= e->height_arg) {",
     "if (e->y > e->height_arg) {"),
    ("wrap-compare", "src/autotext_writer.c",
     "(int32_t)e->x + width >= (int32_t)e->width_arg", "(int32_t)e->x + width > (int32_t)e->width_arg"),
    ("clear-colour", "src/autotext_writer.c", "&owner->target, 0u, 0x1fu, 0u);",
     "&owner->target, 0u, 0x1eu, 0u);"),
    ("hotspot-y", "src/autotext_writer.c", "spot->y_start = e->line == 0 ? 0 : (int32_t)e->y;",
     "spot->y_start = (int32_t)e->y;"),
    ("height-needed", "src/autotext_writer.c", "((int32_t)length * 0x90)", "((int32_t)length * 0x91)"),
    ("font-y-adjust", "src/autotext_writer.c",
     "} else if (e->line == 0 && e->last_pic_line == 0) {", "} else if (e->line == 0 && e->last_pic_line == 1) {"),
    ("pass1-hotspot-limit", "src/autotext_writer.c",
     "(size_t)e->k < AUTOTEXT_HOTSPOT_RECORDS", "(size_t)e->k <= AUTOTEXT_HOTSPOT_RECORDS"),
    ("order-final-y", "src/autotext_writer.c", "owner->final_y[owner->surface_index] = e->y;",
     "owner->final_y[owner->surface_index] = (int16_t)(e->y + 1);"),
]


def run_mutants(args: argparse.Namespace) -> dict[str, Any]:
    out_dir = Path(tempfile.mkdtemp(prefix="RT-32a.mutants-", dir=SLICES))
    report = []
    for label, rel, old, new in MUTANTS:
        source = (PROJECT / rel).read_text()
        if source.count(old) != 1:
            raise OracleError(f"mutant {label}: pattern not unique")
        work = out_dir / label
        shutil.copytree(PROJECT / "src", work / "src")
        (work / "src" / Path(rel).name).write_text(source.replace(old, new))
        library = work / f"lib{label}.so"
        build = subprocess.run(
            ["cc", "-std=c11", "-O2", "-fPIC", "-shared", str(work / "src/autotext_writer.c"),
             str(work / "src/caption_layout.c"), "-o", str(library)],
            capture_output=True, text=True)
        if build.returncode != 0:
            raise OracleError(f"mutant {label} did not compile: {build.stderr[:300]}")
        sub = argparse.Namespace(**vars(args))
        sub.native_library = library
        sub.only = args.mutant_filter
        result = run(sub)
        caught = bool(result["mismatches"])
        first = result["mismatches"][0]["case"] if caught else None
        report.append({"mutant": label, "caught": caught, "first_mismatch": first,
                       "mismatching_cases": len(result["mismatches"])})
        print(f"mutant {label}: {'caught' if caught else 'SURVIVED'} ({first})", flush=True)
    return {"mutants": report, "caught": sum(1 for m in report if m["caught"]),
            "total": len(report)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=fx.LIBRARY)
    parser.add_argument("--report", type=Path, default=SLICES / "RT-32a.oracle-report.json")
    parser.add_argument("--only", default=None, help="regex on case labels")
    parser.add_argument("--mutants", action="store_true")
    parser.add_argument("--mutant-filter", default=None)
    args = parser.parse_args()
    try:
        if args.mutants:
            report = run_mutants(args)
            args.report.with_suffix(".mutants.json").write_text(json.dumps(report, indent=1) + "\n")
            print(f"mutants caught {report['caught']}/{report['total']}")
            return 0 if report["caught"] == report["total"] else 1
        report = run(args)
    except (OracleError, OSError, ValueError, RuntimeError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=1, default=str) + "\n")
    print(f"cases {report['cases']} outcomes {report['outcomes']} mismatches "
          f"{len(report['mismatches'])} in {report['seconds']}s")
    if report["mismatches"]:
        print(json.dumps(report["mismatches"][:5], indent=1, default=str)[:6000], file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
