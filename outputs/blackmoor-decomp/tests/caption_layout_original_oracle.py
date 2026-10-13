#!/usr/bin/env python3
"""Compare the S05 caption renderer with original GAME.EXE code.

Original code that runs unmodified under Unicorn:

* 0x436bba..0x436cfa: per-font glyph size table and sheet refcount reset;
* 0x437300..0x437360: text-box surface sizes from TBOX;
* 0x4c2f02..0x4c3150: pixel format and colour key from channel masks;
* 0x448d11 and everything it calls (0x44887c layout, 0x4d3836 width,
  0x4d214b glyph map, 0x4d270b glyph draw, 0x4c5b3a blit, 0x4c46d1 clear,
  0x4c9340 colour scan, 0x4c924d/0x4c92c5 refcounts, CRT strstr/atoi/ctype).

The frame-box close 0x4de2d8 -> 0x4de214 -> 0x4de1f5 also runs as original
code; only its two taskbar calls 0x4e053f / 0x4e1113 are intercepted.

Intercepted boundaries (each recorded): font sheet load 0x4c2790 (a missing
sheet reproduces its report + quit path) and free 0x4c2dfb, taskbar calls
0x4e053f / 0x4e1113, taskbar restore 0x4e1157, error message
0x52139c / 0x42639d, PostQuitMessage wrapper 0x4c97b4 and debug log 0x44a2b7.
Font sheets are the shipped FONT CIF images converted by the validated
0x4c7314 port; both sides receive identical sheet pixels.

Run from the workspace root:

    work/tools/oracle-python/bin/python \\
        outputs/blackmoor-decomp/tests/caption_layout_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import sys
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from autotext_original_oracle import (EXPECTED_EXE_SHA256, RESOURCE_PATH as AUTOTEXT_PATH,
                                      _read_cvtx_payload, parse_entries)
from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256
import test_caption_layout as fx

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_REPORT = ROOT / "work/analysis/slices/S05.validation.json"
DEFAULT_MARKDOWN = ROOT / "work/analysis/slices/S05.validation.md"

WRITER_VA = 0x448D11
TEXT_BOX_OBJECT = 0x619A05
GFX_OBJECT = 0x5CF659
FRAME_OBJECT = 0x61F864
TASKBAR_OBJECT = 0x570508
FONT_TABLE = 0x5A4C24
FONT_COUNT = 0x5B0264
SHEET_REFCOUNT = 0x5AFBDA
SHEET_HANDLES = 0x5D032F
TBOX = 0x5B0A12
TRANSPARENT = 0x5B0257
BYTES_PER_PIXEL = 0x639895
BITS_PER_PIXEL = 0x639893
DEBUG_FLAG = 0x63A4CD
FRAME_OPEN = 0x5A161F
CAPTION_FINISH = 0x5B1602
CAPTION_VISIBLE = 0x5B1606
FRAMED_READY = 0x5B15D6
FRAMED_SCROLL = 0x5B0A7C
SURFACE_SIZES = (0x5B0A74, 0x5B0A76, 0x5B15EE, 0x5B15F0)

HOOKS = {
    0x4C2790: 0x10,  # load sheet
    0x4C2DFB: 0x4,   # free sheet
    0x4E053F: 0x4,   # taskbar mode (called by the real frame close 0x4de2d8)
    0x4E1113: 0x0,   # taskbar update (called by the real frame close 0x4de2d8)
    0x4E1157: 0x0,   # restore taskbar CC text box
    0x52139C: 0xC,   # message box
    0x42639D: 0x8,   # error report
    0x4C97B4: 0x0,   # quit
    0x44A2B7: 0x0,   # debug log (cdecl)
}

STACK = 0x10000000
STACK_SIZE = 0x80000
FRAME_EBP = STACK + 0x40000
HEAP = 0x20000000
HEAP_SIZE = 0x04000000
TARGET = 0x30000000
TARGET_SIZE = 0x00800000
SENTINEL = 0x3F000000
GUARD_WORD = 0xA5A5


class OracleError(RuntimeError):
    pass


@dataclass
class Case:
    label: str
    text: bytes
    mode: int
    measure: int
    group: str
    capacity_extra: int = 8
    frame_open: int = 0
    debug: int = 0
    masks: tuple[int, int, int] = fx.RGB555
    max_instructions: int = 300_000_000
    # Native status for paths whose original behaviour is undefined.
    intentional_status: int | None = None
    preset: dict[str, Any] = field(default_factory=dict)
    missing_sheets: frozenset[int] = frozenset()


class Original:
    def __init__(self, exe: Path, data: fx.ShippedData, masks: tuple[int, int, int]) -> None:
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
        for addr, size in ((STACK, STACK_SIZE), (HEAP, HEAP_SIZE), (TARGET, TARGET_SIZE),
                           (SENTINEL, 0x1000)):
            uc.mem_map(addr, size, UC_PROT_ALL)
        uc.mem_write(SENTINEL, b"\xCC" * 0x1000)
        self.uc = uc
        self.cursor = HEAP
        self.events: list[tuple] = []
        for address in HOOKS:
            uc.hook_add(UC_HOOK_CODE, self._hook, begin=address, end=address)
        uc.hook_add(UC_HOOK_CODE, self._observe_close, begin=0x4DE2D8, end=0x4DE2D8)
        self.missing: frozenset[int] = frozenset()
        self.sheet_ptrs: dict[int, int] = {}
        self._boot(masks)

    # -- helpers -----------------------------------------------------------
    def alloc(self, size: int, fill: bytes = b"\0") -> int:
        start = (self.cursor + 15) & ~15
        if start + size > HEAP + HEAP_SIZE:
            raise OracleError("oracle heap exhausted")
        self.cursor = start + size
        self.uc.mem_write(start, (fill * (size // len(fill) + 1))[:size])
        return start

    def r(self, addr: int, n: int) -> bytes:
        return bytes(self.uc.mem_read(addr, n))

    def w(self, addr: int, data: bytes) -> None:
        self.uc.mem_write(addr, data)

    def cstr(self, addr: int) -> bytes:
        out = bytearray()
        while len(out) < 4096:
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
        return struct.unpack("<I", self.r(self.reg("ESP") + 4 + 4 * i, 4))[0]

    def block(self, start: int, stop: int, locals_: dict[int, int] | None = None) -> None:
        self.w(FRAME_EBP - 0x1000, b"\xCC" * 0x1000)
        for offset, value in (locals_ or {}).items():
            self.w(FRAME_EBP + offset, struct.pack("<I", value & 0xFFFFFFFF))
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI"):
            self.setreg(name, 0)
        self.setreg("EBP", FRAME_EBP)
        self.setreg("ESP", FRAME_EBP - 0x1000)
        self.uc.emu_start(start, stop, count=50_000_000)
        if self.reg("EIP") != stop:
            raise OracleError(f"block 0x{start:x} stopped at 0x{self.reg('EIP'):x}")

    def _boot(self, masks: tuple[int, int, int]) -> None:
        d = self.data
        self.w(FONT_TABLE, d.font_chunk)
        self.w(FONT_COUNT, struct.pack("<h", d.font_count))
        self.block(0x436BBA, 0x436CFA)
        self.w(TBOX, d.tbox)
        self.block(0x437300, 0x437360)
        self.w(TRANSPARENT, d.transparent)
        red, green, blue = masks
        self.block(0x4C2F02, 0x4C3150, {-0x88: GFX_OBJECT, -0x28: red, -0x24: green,
                                        -0x20: blue})
        self.w(BYTES_PER_PIXEL, struct.pack("<h", 2))
        self.w(BITS_PER_PIXEL, struct.pack("<h", 16))
        self.format = {
            "shifts": list(self.r(GFX_OBJECT + 0x38C0, 3)),
            "masks": list(self.r(GFX_OBJECT + 0x38C4, 3)),
            "bits": list(self.r(GFX_OBJECT + 0x38C8, 3)),
            "color_key": struct.unpack("<H", self.r(GFX_OBJECT + 0x38D0, 2))[0],
        }
        self.glyph_sizes = self.r(0x5ADB3A, 0x1D0 * fx.MAX_FONTS)
        self.surface_sizes = [struct.unpack("<h", self.r(a, 2))[0] for a in SURFACE_SIZES]

    # -- hooks -------------------------------------------------------------
    def _observed(self) -> tuple:
        """State a callback would see at this instant (callback-time check)."""
        pixels = None
        if self.target_bytes:
            pixels = hashlib.sha256(self.r(TARGET, self.target_bytes)).hexdigest()[:16]
        return (pixels, struct.unpack("<i", self.r(CAPTION_VISIBLE, 4))[0],
                struct.unpack("<i", self.r(CAPTION_FINISH, 4))[0], self.r(FRAME_OPEN, 1)[0],
                struct.unpack("<18h", self.r(SHEET_REFCOUNT, 36)))

    def _observe_close(self, uc, address, _size, _user) -> None:
        if self.reg("ECX") != FRAME_OBJECT:
            raise OracleError("0x4de2d8 on unexpected object")
        self.events.append(("close_frame_text",) + self._observed())

    def _hook(self, uc, address, _size, _user) -> None:
        pop = HOOKS[address]
        value = 0
        if address == 0x4C2790:
            name = self.cstr(self.arg(1))
            font = (self.arg(1) - FONT_TABLE) // fx.FONT_RECORD
            fmt = fx.PixelFormat((c.c_uint8 * 3)(*self.format["shifts"]),
                                 (c.c_uint8 * 3)(*self.format["masks"]),
                                 (c.c_uint8 * 3)(*self.format["bits"]),
                                 self.format["color_key"])
            sheet = None if font in self.missing else self.data.sheet(name, fmt)
            self.events.append(("load", font, name) + self._observed())
            if sheet is not None:
                pixels, width, height, pitch = sheet
                pix = self.sheet_ptrs.get(hash((name, pixels)))
                if pix is None:
                    pix = self.alloc(len(pixels))
                    self.w(pix, pixels)
                    self.sheet_ptrs[hash((name, pixels))] = pix
                obj = self.alloc(0x59)
                self.w(obj, struct.pack("<I", pix))
                self.w(obj + 0x2B, struct.pack("<hhh", width, height, pitch))
                value = obj
            else:
                # 0x4c287c..0x4c2889: report, quit, return 0.
                self.events += [("load_failed", font), ("error",), ("quit",)]
        elif address == 0x4C2DFB:
            handle = self.arg(0)
            self.events.append(("release", (handle - SHEET_HANDLES) // 4))
            self.w(handle, b"\0\0\0\0")
        elif address in (0x4E053F, 0x4E1113):
            if self.reg("ECX") != TASKBAR_OBJECT:
                raise OracleError("taskbar call on unexpected object")
            self.ui_calls.append(hex(address))
        elif address == 0x4E1157:
            if self.reg("ECX") != TASKBAR_OBJECT:
                raise OracleError("0x4e1157 on unexpected object")
            self.events.append(("restore_caption_box",) + self._observed())
        elif address == 0x52139C:
            self.events.append(("message", self.cstr(self.arg(0))))
        elif address == 0x42639D:
            self.events.append(("error",))
        elif address == 0x4C97B4:
            self.events.append(("quit",))
        elif address == 0x44A2B7:
            self.events.append(("debug_log",))
        esp = self.reg("ESP")
        ret = struct.unpack("<I", self.r(esp, 4))[0]
        self.setreg("EAX", value)
        self.setreg("ESP", esp + 4 + pop)
        self.setreg("EIP", ret)

    # -- writer ------------------------------------------------------------
    def reset(self, case: Case) -> None:
        self.w(SHEET_REFCOUNT, bytes(2 * fx.MAX_FONTS))
        self.w(SHEET_HANDLES, bytes(4 * fx.MAX_FONTS))
        for addr in (CAPTION_FINISH, CAPTION_VISIBLE, FRAMED_READY):
            self.w(addr, struct.pack("<i", case.preset.get(hex(addr), 0)))
        self.w(FRAMED_SCROLL, struct.pack("<h", case.preset.get("scroll", 0)))
        self.w(FRAME_OPEN, bytes([case.frame_open]))
        self.w(DEBUG_FLAG, struct.pack("<h", case.debug))
        self.w(TEXT_BOX_OBJECT, b"\x5a" * 0x40)  # writer must initialize what it reads

    def write(self, case: Case, width: int, height: int) -> dict[str, Any]:
        self.events = []
        self.ui_calls: list[str] = []
        self.missing = case.missing_sheets
        capacity = len(case.text) + 1 + case.capacity_extra
        text = self.alloc(capacity + 64, b"\xEE")
        self.w(text, case.text + b"\0")
        surface = 0
        guard = 0
        self.target_bytes = 0
        if not case.measure:
            surface = self.alloc(0x59)
            guard = width * height * 2
            self.w(TARGET, struct.pack("<H", GUARD_WORD) * guard)
            self.target_bytes = guard
            self.w(surface, struct.pack("<I", TARGET))
            self.w(surface + 0x2B, struct.pack("<hhh", width, height, width * 2))
        esp = STACK + STACK_SIZE - 0x100
        self.w(esp, struct.pack("<IIIII", SENTINEL, surface, text, case.mode & 0xFFFFFFFF,
                                case.measure))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.setreg(name, 0)
        self.setreg("ECX", TEXT_BOX_OBJECT)
        self.setreg("ESP", esp)
        terminated = True
        try:
            self.uc.emu_start(WRITER_VA, SENTINEL, count=case.max_instructions)
        except Exception as exc:  # noqa: BLE001 - original faulted
            return {"terminated": True, "trapped": f"0x{self.reg('EIP'):x}: {exc}",
                    "events": self.events}
        if self.reg("EIP") != SENTINEL:
            terminated = False
        out: dict[str, Any] = {"terminated": terminated, "events": self.events}
        if terminated and self.reg("ESP") != esp + 4 + 0x10:
            raise OracleError(f"{case.label}: unbalanced stack")
        out["lines"] = struct.unpack("<h", struct.pack("<H", self.reg("EAX") & 0xFFFF))[0]
        out["text"] = self.r(text, capacity)
        if not case.measure:
            total = self.r(TARGET, guard * 2)
            out["pixels"] = total[:guard]
            out["outside_surface"] = total[guard:] != struct.pack("<H", GUARD_WORD) * (guard // 2)
        box = self.r(TEXT_BOX_OBJECT, 0x3C)
        out["box"] = (struct.unpack_from("<i", box, 0x10)[0], struct.unpack_from("<h", box, 0x2C)[0],
                      struct.unpack_from("<i", box, 0x2E)[0], struct.unpack_from("<H", box, 0x32)[0],
                      struct.unpack_from("<i", box, 0x34)[0], struct.unpack_from("<i", box, 0x38)[0])
        out["globals"] = (
            struct.unpack("<i", self.r(CAPTION_FINISH, 4))[0],
            struct.unpack("<i", self.r(CAPTION_VISIBLE, 4))[0],
            struct.unpack("<i", self.r(FRAMED_READY, 4))[0],
            struct.unpack("<h", self.r(FRAMED_SCROLL, 2))[0],
            self.r(FRAME_OPEN, 1)[0],
            struct.unpack("<18h", self.r(SHEET_REFCOUNT, 36)),
            tuple(v != 0 for v in struct.unpack("<18I", self.r(SHEET_HANDLES, 72))),
        )
        return out


def native_run(lib, data, fmt, fonts, geometry, case: Case, width: int, height: int):
    backend = fx.SheetBackend(data, fmt, missing=case.missing_sheets)
    globals_ = fx.Globals()
    globals_.frame_open = case.frame_open
    globals_.caption_finish_flag = case.preset.get(hex(CAPTION_FINISH), 0)
    globals_.caption_visible_flag = case.preset.get(hex(CAPTION_VISIBLE), 0)
    globals_.framed_ready = case.preset.get(hex(FRAMED_READY), 0)
    globals_.framed_scroll_lines = case.preset.get("scroll", 0)
    box = fx.TextBox(0x5A5A5A5A, 0x5A5A, 0x5A5A5A5A, 0x5A5A, 0x5A5A5A5A, 0x5A5A5A5A)
    surface = pixels = None
    if not case.measure:
        surface, pixels = fx.make_surface(width, height, GUARD_WORD)
    backend.observe_pixels = pixels
    backend.observe_globals = globals_
    status, result, box, globals_, text = fx.native_write(
        lib, fmt, fonts, geometry, backend, case.text, case.mode, case.measure,
        surface=surface, globals_=globals_, box=box,
        capacity=len(case.text) + 1 + case.capacity_extra, debug=case.debug)
    out = {
        "status": status, "lines": result.lines, "text": text, "events": backend.events,
        "box": (box.too_long_reported, box.left_margin, box.underline, box.underline_color,
                box.tight_spacing, box.half_spacing),
        "globals": (globals_.caption_finish_flag, globals_.caption_visible_flag,
                    globals_.framed_ready, globals_.framed_scroll_lines, globals_.frame_open,
                    tuple(globals_.sheet_refcount),
                    tuple(bool(globals_.sheets[i].pixels) for i in range(fx.MAX_FONTS))),
        "glyphs": result.glyphs_drawn,
    }
    if pixels is not None:
        out["pixels"] = bytes(pixels)
    return out


EXPECTED_FAILURE = {
    "nonterminating": fx.ERR_UNSUPPORTED,
    "outside_surface": fx.ERR_BOUNDS,
    "fatal_too_long": fx.ERR_TOO_LONG,
}


def compare(case: Case, original: dict, native: dict) -> tuple[str, list[str]]:
    """Returns (outcome, differing fields)."""
    if case.intentional_status is not None:
        return "intentional", ([] if native["status"] == case.intentional_status else ["status"])
    if any(e[0] == "load_failed" for e in original["events"]):
        # The original reports, posts quit and later blits from a null sheet.
        return "fatal_missing_sheet", ([] if native["status"] == fx.ERR_BACKEND else ["status"])
    if original.get("trapped"):
        return "trapped", ([] if native["status"] == fx.ERR_LIMIT else ["status"])
    if not original["terminated"]:
        return "nonterminating", ([] if native["status"] == fx.ERR_UNSUPPORTED else ["status"])
    if any(e[0] == "quit" for e in original["events"]):
        # Native rejects before drawing; the original may already have drawn
        # past the surface before its end-of-text check.
        ok = case.mode == -2 and native["status"] == fx.ERR_TOO_LONG
        return "fatal_too_long", ([] if ok else ["status"])
    if original.get("outside_surface"):
        return "outside_surface", ([] if native["status"] == fx.ERR_BOUNDS else ["status"])
    if native["status"] != fx.OK:
        return "ok", ["status"]
    diff = [k for k in ("lines", "text", "box", "globals", "events") if original[k] != native[k]]
    if not case.measure and original["pixels"] != native["pixels"]:
        diff.append("pixels")
    return "ok", diff


def synthetic_cases(entries: dict[bytes, bytes]) -> list[Case]:
    nsht = entries[b"NSHT01"]
    words = b"The quick brown fox jumps over the lazy dog, again and again. "
    cases = [
        Case("nsht01-caption", nsht, -1, 0, "acceptance"),
        Case("nsht01-measure", nsht, -1, 1, "acceptance"),
        Case("curl00-framed", entries[b"CURL00"], -2, 0, "acceptance"),
        Case("curl00-measure", entries[b"CURL00"], -1, 1, "acceptance"),
        Case("a51-inline-1600-5", b"<f1>Rotate plants by right-clicking on them.<n>", -1, 0,
             "acceptance"),
        Case("a51-inline-framed", b"<f1>Rotate plants by right-clicking on them.<n>", -2, 0,
             "acceptance"),
        Case("missing-caption-fallback", b"Missing closed captioning text string<h><n><o>", -1, 0,
             "markup"),
        Case("no-terminator-appended", b"Hello world<n>", -1, 0, "markup"),
        Case("no-terminator-exact-capacity", b"Hello<n>", -1, 0, "markup", capacity_extra=3),
        Case("embedded-nul", b"Before<n>\0After<n>", -1, 0, "markup"),
        Case("text-after-last-break-not-drawn", b"one<n>two<e>", -1, 0, "markup"),
        Case("colors", b"<c0>plain <c1>tinted<n><c0>back<n>", -1, 0, "markup"),
        Case("fonts", b"<f1>one <f5>five <f9>nine<n><f0>zero <f13>thirteen<n>", -2, 0, "markup"),
        Case("underline", b"plain <u>under line<u> after<n>", -1, 0, "markup"),
        Case("underline-trailing-space", b"<u>under <u>x<n>", -1, 0, "markup"),
        Case("underline-c1", b"<c1><u>tinted underline<u><n>", -1, 0, "markup"),
        Case("tight-and-half", b"a<n>b<l>c<n>d<l>e<w>f<n>g<n>", -2, 0, "markup"),
        Case("right-align", b"left<r>right side<n>", -2, 0, "markup"),
        Case("tab", b"a<t>b<t>c<n>", -1, 0, "markup"),
        Case("unknown-tags", b"<h>x<o>y<d>z<v>w<q>q<n>", -1, 0, "markup"),
        Case("stray-close-repeats-tag", b"<n>abc>def<n>", -1, 0, "markup"),
        Case("stray-close-before-tag", b"abc>def<n>", -1, 0, "markup",
             intentional_status=fx.ERR_UNSUPPORTED),
        Case("nested-open-resets-tag", b"ab<f<n>cd<n>", -1, 0, "markup"),
        Case("atoi-whitespace-sign", b"<f +5>x<c -0>y<n>", -1, 0, "markup"),
        Case("unclosed-tag-at-end", b"abc<n>def<f", -1, 0, "markup"),
        Case("latin1-and-unmapped", bytes([0x43, 0x61, 0x66, 0xE9, 0x20, 0x80, 0xA1, 0xBF, 0xFF,
                                           0x7E, 0x40, 0x22, 0x5C, 0x23, 0x24, 0x7B, 0x7D, 0x5F])
             + b"<n>", -1, 0, "markup"),
        Case("all-ascii-unbroken", bytes(range(0x20, 0x3C)) + bytes(range(0x3F, 0x7F)) + b"<n>",
             -2, 0, "wrap", max_instructions=20_000_000),
        Case("all-ascii-spaced", b" ".join(bytes([v]) for v in list(range(0x21, 0x3C)) +
                                           list(range(0x3F, 0x7F))) + b"<n>", -2, 0, "markup"),
        Case("all-mapped-high-bytes", b" ".join(bytes([v]) for v in (
            0x80, 0xA1, 0xBF, 0xC0, 0xC4, 0xC5, 0xC9, 0xD1, 0xD6, 0xDC, 0xDF, 0xE0, 0xE1, 0xE2,
            0xE4, 0xE5, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xF1, 0xF3, 0xF4, 0xF6, 0xF9,
            0xFA, 0xFC)) + b"<n>", -2, 0, "markup"),
        Case("explicit-font-mode", b"explicit font five<n>", 5, 0, "markup"),
        Case("explicit-font-measure", words * 4 + b"<n>", 1, 1, "markup"),
        Case("wrap-measure-2", words * 2 + b"<n>", -1, 1, "wrap"),
        Case("wrap-measure-3", words * 4 + b"<n>", -1, 1, "wrap"),
        Case("wrap-draw-3", words * 4 + b"<n>", -1, 0, "wrap"),
        Case("wrap-framed", words * 30 + b"<n>", -2, 0, "wrap"),
        Case("wrap-segments", b"<c1>" + words + b"<c0>" + words + b"<c1>" + words + b"<n>", -1,
             0, "wrap"),
        Case("leading-space-word", b" " + b"x" * 400 + b"<n>", -1, 1, "wrap",
             max_instructions=20_000_000),
        Case("word-wider-than-box", b"x" * 400 + b"<n>", -1, 1, "wrap",
             max_instructions=20_000_000),
        Case("caption-overflow-surface", words * 60 + b"<n>", -1, 0, "bounds"),
        Case("text-buffer-overflow", words * 600 + b"<n>", -2, 0, "bounds"),
        Case("framed-too-long-overdrawn", (words * 4 + b"<n>") * 40, -2, 0, "bounds"),
        Case("framed-74-lines-fatal", b"x<n>" * 74, -2, 0, "bounds"),
        Case("framed-73-lines-scroll", b"x<n>" * 73, -2, 0, "bounds"),
        Case("frame-open-is-closed", b"closes frame<n>", -1, 0, "flags", frame_open=1,
             preset={hex(FRAMED_READY): 1}),
        Case("frame-open-framed-write", b"reopen<n>", -2, 0, "flags", frame_open=1,
             preset={hex(FRAMED_READY): 1}),
        Case("missing-font-sheet-draw", b"a<f5>b<n>", -1, 0, "fonts",
             missing_sheets=frozenset({5})),
        Case("missing-font-sheet-measure", b"x<n>", -1, 1, "fonts",
             missing_sheets=frozenset({9})),
        Case("frame-open-measure", b"closes frame<n>", -1, 1, "flags", frame_open=1),
        Case("flags-caption-preset", b"x<n>", -1, 0, "flags",
             preset={hex(CAPTION_FINISH): 1, hex(CAPTION_VISIBLE): 0}),
        Case("flags-measure-preserves", b"x<n>", -1, 1, "flags",
             preset={hex(CAPTION_FINISH): 1, hex(CAPTION_VISIBLE): 1}),
        Case("flags-framed", b"x<n>", -2, 0, "flags",
             preset={hex(CAPTION_FINISH): 1, "scroll": 7}),
        Case("debug-too-many-lines", words * 8 + b"<n>", -1, 0, "flags", debug=1),
        Case("empty", b"", -1, 0, "markup"),
        Case("only-terminator", b"<e>", -2, 0, "markup"),
    ]
    for masks_case in ("nsht01", "underline", "colors"):
        base = next(cs for cs in cases if cs.label.startswith(masks_case))
        cases.append(Case(base.label + "-rgb565", base.text, base.mode, base.measure,
                          "rgb565", masks=fx.RGB565))
    return cases


def run(args: argparse.Namespace) -> dict[str, Any]:
    data = fx.ShippedData()
    lib = fx.bind(args.native_library)
    entries = parse_entries(_read_cvtx_payload(AUTOTEXT_PATH.read_bytes()))
    by_key = {e["key"]: e["caption"] for e in entries}
    cases = synthetic_cases(by_key)
    corpus = [e for e in entries if args.corpus_limit is None or e["index"] < args.corpus_limit]
    for e in corpus:
        cases.append(Case(f"autotext-{e['index']}-measure", e["caption"], -1, 1, "corpus-measure"))
        cases.append(Case(f"autotext-{e['index']}-caption", e["caption"], -1, 0, "corpus-caption"))
        if e["index"] % args.framed_stride == 0:
            cases.append(Case(f"autotext-{e['index']}-framed", e["caption"], -2, 0,
                              "corpus-framed"))

    machines: dict[tuple, Original] = {}
    contexts: dict[tuple, Any] = {}
    results: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []
    outcomes: dict[str, int] = {}
    groups: dict[str, int] = {}
    boot_checks: list[str] = []
    started = time.time()
    for case in cases:
        if case.masks not in machines:
            machines[case.masks] = Original(args.exe, data, case.masks)
            fmt, fonts, geometry = fx.native_context(lib, data, case.masks)
            contexts[case.masks] = (fmt, fonts, geometry)
            m = machines[case.masks]
            native_sizes = bytes(c.string_at(c.addressof(fonts.glyph_size),
                                             fx.GLYPHS * 4 * fx.MAX_FONTS))
            if (list(fmt.shifts), list(fmt.masks), list(fmt.channel_bits), fmt.color_key) != \
                    (m.format["shifts"], m.format["masks"], m.format["bits"], m.format["color_key"]):
                mismatches.append({"case": f"pixel-format-{case.masks}", "fields": ["format"]})
            # 0x5adb3a uses 4-byte stride per glyph inside 0x1d0-byte rows.
            orig_sizes = bytearray()
            for f in range(fx.MAX_FONTS):
                row = m.glyph_sizes[f * 0x1D0:(f + 1) * 0x1D0]
                orig_sizes += row[:fx.GLYPHS * 4]
            if bytes(orig_sizes) != native_sizes:
                mismatches.append({"case": f"glyph-sizes-{case.masks}", "fields": ["glyph_size"]})
            if m.surface_sizes != [geometry.framed_surface_width, geometry.framed_surface_height,
                                   geometry.caption_surface_width,
                                   geometry.caption_surface_height]:
                mismatches.append({"case": "surface-sizes", "fields": ["surface_sizes"]})
            boot_checks.append(f"masks {['0x%x' % v for v in case.masks]}: format, 18x115 glyph "
                               "sizes and 4 surface sizes compared")
        m = machines[case.masks]
        fmt, fonts, geometry = contexts[case.masks]
        if case.mode == -2:
            width, height = geometry.framed_surface_width, geometry.framed_surface_height
        else:
            width, height = geometry.caption_surface_width, geometry.caption_surface_height
        m.reset(case)
        original = m.write(case, width, height)
        native = native_run(lib, data, fmt, fonts, geometry, case, width, height)
        outcome, diff = compare(case, original, native)
        outcomes[outcome] = outcomes.get(outcome, 0) + 1
        groups[case.group] = groups.get(case.group, 0) + 1
        entry = {"case": case.label, "group": case.group, "mode": case.mode,
                 "measure": case.measure, "outcome": outcome, "lines": original.get("lines"),
                 "native_status": native["status"], "glyphs": native["glyphs"]}
        if original.get("trapped"):
            entry["original_trap"] = original["trapped"]
        if not case.measure and "pixels" in original:
            entry["pixels_sha256"] = hashlib.sha256(original["pixels"]).hexdigest()
        results.append(entry)
        if diff:
            mismatches.append({"case": case.label, "fields": diff, "outcome": outcome,
                               "original": {k: (original[k] if k not in ("pixels", "text")
                                                else hashlib.sha256(original[k]).hexdigest())
                                            for k in diff if k in original and k != "status"},
                               "native": {k: (native[k] if k not in ("pixels", "text")
                                              else hashlib.sha256(native[k]).hexdigest())
                                          for k in diff if k in native}})
    m = next(iter(machines.values()))
    return {
        "scope": "original 0x448d11 caption/framed text writer and its layout, glyph, blit, "
                 "clear, scan and font-refcount code vs native caption_layout.c",
        "original_sha256": sha256(m.pe.data),
        "native_library_sha256": hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
        "autotext_sha256": sha256(AUTOTEXT_PATH.read_bytes()),
        "boot_bsum_sha256": hashlib.sha256(data.bsum).hexdigest(),
        "tbox_sha256": hashlib.sha256(data.tbox).hexdigest(),
        "font_chunk_sha256": hashlib.sha256(data.font_chunk).hexdigest(),
        "cases": len(results),
        "groups": groups,
        "outcomes": outcomes,
        "boot_checks": boot_checks,
        "seconds": round(time.time() - started, 1),
        "results": results,
        "mismatches": mismatches,
    }


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# S05 caption layout original-code validation",
        "",
        report["scope"] + ".",
        "",
        f"- Original `GAME.EXE`: `{report['original_sha256']}`",
        f"- Native library: `{report['native_library_sha256']}`",
        f"- AUTOTEXT `{report['autotext_sha256']}`, BSUM `{report['boot_bsum_sha256']}`, "
        f"TBOX `{report['tbox_sha256']}`, FONT `{report['font_chunk_sha256']}`",
        f"- Cases: {report['cases']}; mismatches: {len(report['mismatches'])}",
        f"- Groups: {report['groups']}",
        f"- Outcomes: {report['outcomes']}",
        "",
        "Outcome meanings: `ok` compares lines, pixels, caller text, box fields, globals and "
        "backend events; `nonterminating` (original exceeded its instruction budget) expects "
        "native ERR_UNSUPPORTED; `outside_surface` (original wrote past the surface) expects "
        "ERR_BOUNDS; `trapped` (original faulted on its 5000-byte stack buffer) expects "
        "ERR_LIMIT; `fatal_too_long` (original quit) expects ERR_TOO_LONG; `intentional` is a "
        "documented undefined original path.",
        "",
        "## Boot checks",
        "",
    ]
    lines += [f"- {item}" for item in report["boot_checks"]]
    lines += ["", "## Non-ok outcomes", ""]
    lines += [f"- `{r['case']}`: {r['outcome']} (native status {r['native_status']})"
              for r in report["results"] if r["outcome"] != "ok"]
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=fx.LIBRARY)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--markdown-report", type=Path, default=DEFAULT_MARKDOWN)
    parser.add_argument("--corpus-limit", type=int, default=None)
    parser.add_argument("--framed-stride", type=int, default=1)
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleError, OSError, ValueError, RuntimeError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=1, default=str) + "\n")
    args.markdown_report.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_report.write_text(render_markdown(report))
    print(f"cases {report['cases']} outcomes {report['outcomes']} mismatches "
          f"{len(report['mismatches'])} in {report['seconds']}s")
    if report["mismatches"]:
        print(json.dumps(report["mismatches"][:6], indent=1, default=str)[:4000], file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
