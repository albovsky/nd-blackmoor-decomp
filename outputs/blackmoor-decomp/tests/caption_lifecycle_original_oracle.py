#!/usr/bin/env python3
"""Compare the S05-2 caption lifecycle with original GAME.EXE code.

Original code runs unmodified under Unicorn on the real object address
0x61f864 and real globals:

* CScrollTextBox / CUIPopup / CUISlider methods: 0x4de394 load chunk,
  0x4de227 init (0x4edcb1, 0x4eeb23, 0x4ef89b, 0x4ee6c7), 0x4de24f open,
  0x4de2d8 close, 0x4de4f9 poll (0x4ee6c7, 0x4de440), 0x4de322 hover
  (0x4ee2a9, 0x4ef2d1), 0x4de413 click, 0x4de584 draw (0x4ee86f, 0x4eff03);
* caption/framed clear 0x42ae0a, 0x42ad90, 0x42ad27; timed dismiss 0x4ea361;
* the main-loop caption block 0x43d0b4..0x43d12a;
* the timed-dismiss arming block 0x4e93ae..0x4e93d5;
* InitStaticSceneData's caption/frame block 0x438da2..0x438f53;
* RenderMainDisplay 0x4cf9f4 over a layer table holding layers 8..11, with
  0x4d3714 -> 0x4e1157 CUITaskBar::RestoreCCTextBox.

Intercepted boundaries (recorded and compared): sheet load 0x4c2790, blits
0x4c5377 / 0x4c5d4b, the S05-1 writer 0x448d11, sound load/play/unload
0x4fb77a / 0x4fb2e3 / 0x4fba69, GetAsyncKeyState / GetCursorPos /
SetCursorPos imports, the conversation restore layer callback 0x4d3705,
report/quit 0x4264e8 / 0x42639d / 0x52139c / 0x4c97b4, and the compositor's
non-caption UI calls 0x4e11ed / 0x4e6658 / 0x447c36 / 0x4c4c2b.

Run from the workspace root:

    work/tools/oracle-python/bin/python \\
        outputs/blackmoor-decomp/tests/caption_lifecycle_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import sys
from pathlib import Path
from typing import Any, Callable

from autotext_original_oracle import EXPECTED_EXE_SHA256
from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256
import test_caption_layout as layout
import test_caption_lifecycle as fx

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_REPORT = ROOT / "work/analysis/slices/S05-2.validation.json"
DEFAULT_MARKDOWN = ROOT / "work/analysis/slices/S05-2.validation.md"

BOX = 0x61F864
TBOX = 0x5B0A12
VIEW_ORIGIN = 0x583186
TASKBAR = 0x570508
CONVO_OBJECT = 0x571442
LAYER_TABLE = 0x5D1591
LAYER_STRIDE = 0x4A
CAPTION_SRC = 0x5B15F2
FRAMED_DST = 0x5B0227
CURSOR_HOT = 0x5B30CC
CURSOR_OFFSET = 0x5B3E40
CURSOR_SIZE = 0x5B3AE8
IAT = {"GetAsyncKeyState": 0x52A4B4, "GetCursorPos": 0x52A484, "SetCursorPos": 0x52A488,
       "GetTickCount": 0x52A23C}

# (field, address, struct format, count)
GLOBALS = [
    ("framed_layer_enabled", 0x5D17F5, "i"), ("caption_layer_enabled", 0x5D1889, "i"),
    ("caption_restore_layer", 0x5D18D3, "i"), ("caption_clear_counter", 0x5B160A, "h"),
    ("first_render_level", 0x5BB1C4, "h"), ("popup_gate", 0x55CD94, "i"),
    ("popup_aux", 0x63AA10, "i"), ("modal_input", 0x5839A9, "i"), ("overlay_ui", 0x583204, "i"),
    ("framed_clear_request", 0x5B15C8, "i"), ("framed_clear_counter", 0x5B15D4, "h"),
    ("convo_restore_layer", 0x5D183F, "i"), ("scroll_fraction", 0x5B0A78, "f"),
    ("taskbar_mode", TASKBAR + 0xF2A, "i"), ("scene_request", 0x5BB57B, "i"),
    ("scene_request_flag", 0x5C39FF, "i"), ("engine_state", 0x583999, "i"),
    ("cursor_type", 0x5B44F0, "i"), ("cursor_variant", 0x5B44F4, "i"),
    ("cursor_override", 0x5C39E9, "i"), ("held_item", 0x583A29, "i"), ("cursor_alt", 0x5B44F8, "i"),
    ("cursor_surface", 0x5D162D, "I"), ("default_cursor_surface", 0x5D0377, "I"),
    ("item_cursor_surface", 0x571AD3, "I"), ("cursor_layer_enabled", 0x5D1639, "i"),
    ("slider_cursor_scene", 0x5C39E5, "i"), ("timed_armed", CONVO_OBJECT + 0x8256, "i"),
    ("timed_deadline", CONVO_OBJECT + 0x8286, "I"), ("game_clock", 0x585D37, "I"),
]
ARRAYS = [("mouse_vk", 0x5830C6, "i", 2), ("input_cursor", 0x5830BE, "i", 2),
          ("mouse_down", 0x58321D, "B", 2), ("cursor_hot", 0x5C3A5B, "i", 2)]
RECTS = [("scroll_src", 0x5B0A7E), ("cursor_rect", 0x583102)]
SHARED = [("caption_finish_flag", 0x5B1602, "i"), ("caption_visible_flag", 0x5B1606, "i"),
          ("framed_ready", 0x5B15D6, "i"), ("framed_scroll_lines", 0x5B0A7C, "h"),
          ("frame_open", 0x5A161F, "B")]

HOOKS = {
    0x4C2790: 0x10, 0x4C5377: 0x14, 0x4C5D4B: 0x14, 0x448D11: 0x10, 0x4FB77A: 0x4,
    0x4FBA69: 0x4, 0x4FB2E3: 0x4, 0x4D3705: 0x0, 0x4264E8: 0x4, 0x42639D: 0x8,
    0x52139C: 0xC, 0x4C97B4: 0x0, 0x4E11ED: 0x0, 0x4E6658: 0x0, 0x447C36: 0x0,
    0x4C4C2B: 0x0, 0x4C2DFB: 0x4,
}
STUBS = {"GetAsyncKeyState": 4, "GetCursorPos": 4, "SetCursorPos": 8, "GetTickCount": 0}

STACK, STACK_SIZE = 0x10000000, 0x80000
FRAME = STACK + 0x40000
HEAP, HEAP_SIZE = 0x20000000, 0x01000000
STUB_BASE = 0x31000000
SENTINEL = 0x3F000000


class OracleError(RuntimeError):
    pass


class Original:
    def __init__(self, exe: Path, script: fx.Script, data: layout.ShippedData) -> None:
        from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL, Uc
        from unicorn import x86_const

        self.x = x86_const
        self.pe = PEImage.parse_and_map(exe)
        if sha256(self.pe.data) != EXPECTED_EXE_SHA256:
            raise OracleError("GAME.EXE identity mismatch")
        uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(self.pe.image_base, (self.pe.size_of_image + 0xFFF) & ~0xFFF, UC_PROT_ALL)
        uc.mem_write(self.pe.image_base, self.pe.image)
        for base, size in ((STACK, STACK_SIZE), (HEAP, HEAP_SIZE), (STUB_BASE, 0x1000),
                           (SENTINEL, 0x1000)):
            uc.mem_map(base, size, UC_PROT_ALL)
        uc.mem_write(SENTINEL, b"\xCC" * 0x1000)
        self.uc = uc
        self.script = script
        self.data = data
        self.cursor = HEAP
        self.events: list[tuple] = []
        self.stubs: dict[int, str] = {}
        for i, (name, address) in enumerate(IAT.items()):
            stub = STUB_BASE + 0x10 * i
            uc.mem_write(address, struct.pack("<I", stub))
            self.stubs[stub] = name
            uc.hook_add(UC_HOOK_CODE, self._stub, begin=stub, end=stub)
        for address in HOOKS:
            uc.hook_add(UC_HOOK_CODE, self._hook, begin=address, end=address)
        # Cursor tables (types 0..0x3f, variants 0..1) shared with the native fixture.
        for t in range(0x40):
            for v in range(2):
                hx, hy, rx, ry, w, h = fx.cursor_tables(t, v)
                uc.mem_write(CURSOR_HOT + t * 16 + v * 8, struct.pack("<ii", hx, hy))
                uc.mem_write(CURSOR_OFFSET + t * 16 + v * 8, struct.pack("<ii", rx, ry))
                uc.mem_write(CURSOR_SIZE + t * 8 + v * 4, struct.pack("<hh", w, h))
        uc.mem_write(DEBUG_FLAG, b"\0\0")

    # -- helpers -----------------------------------------------------------
    def r(self, a, n):
        return bytes(self.uc.mem_read(a, n))

    def w(self, a, d):
        self.uc.mem_write(a, d)

    def reg(self, name):
        return self.uc.reg_read(getattr(self.x, f"UC_X86_REG_{name}"))

    def setreg(self, name, value):
        self.uc.reg_write(getattr(self.x, f"UC_X86_REG_{name}"), value & 0xFFFFFFFF)

    def arg(self, i):
        return struct.unpack("<I", self.r(self.reg("ESP") + 4 + 4 * i, 4))[0]

    def cstr(self, a, limit=512):
        return self.r(a, limit).split(b"\0")[0]

    def rect(self, a):
        return struct.unpack("<4i", self.r(a, 16))

    def alloc(self, data: bytes) -> int:
        a = (self.cursor + 15) & ~15
        self.cursor = a + len(data) + 16
        self.w(a, data)
        return a

    def _return(self, value, pop):
        esp = self.reg("ESP")
        ret = struct.unpack("<I", self.r(esp, 4))[0]
        self.setreg("EAX", value)
        self.setreg("ESP", esp + 4 + pop)
        self.setreg("EIP", ret)

    def _stub(self, uc, address, _size, _user):
        name = self.stubs[address]
        value = 0
        if name == "GetAsyncKeyState":
            value = 0x8000 if (self.arg(0) == 1 and self.script.left_down) else 0
        elif name == "GetCursorPos":
            self.w(self.arg(0), struct.pack("<ii", *self.script.cursor))
            value = 1
        elif name == "SetCursorPos":
            self.events.append(("set_cursor", self.arg(0), self.arg(1)))
            value = 1
        else:
            value = 0
        self._return(value, STUBS[name])

    def _hook(self, uc, address, _size, _user):
        value = 0
        if address == 0x4C2790:
            name = self.cstr(self.arg(1)).decode()
            if len(name) > 0x18:
                name = name[:0x18]
            purpose = self.cstr(self.arg(3)).decode()
            value = self.script.handle_for(name, purpose)
            self.events.append(("load_image", name, purpose, value))
            if value == 0:
                self.events.append(("fatal",))
        elif address in (0x4C5377, 0x4C5D4B):
            kind = fx.OPAQUE if address == 0x4C5377 else fx.KEYED
            self.events.append(("blit", kind, self.arg(0), self.rect(self.arg(2)),
                                self.rect(self.arg(3))))
        elif address == 0x448D11:
            self.events.append(("write_framed", self.cstr(self.arg(1))))
        elif address == 0x4FB77A:
            self.events.append(("load_sound", self.cstr(self.arg(0)).decode()))
        elif address == 0x4FBA69:
            self.events.append(("unload_sound",))
        elif address == 0x4FB2E3:
            self.events.append(("play_sound", struct.unpack("<h", struct.pack("<H", self.arg(0) & 0xFFFF))[0]))
        elif address == 0x4D3705:
            self.events.append(("convo_restore",))
        elif address in (0x4264E8, 0x42639D, 0x52139C, 0x4C97B4):
            if not self.events or self.events[-1] != ("fatal",):
                self.events.append(("fatal",))
        elif address == 0x4C2DFB:
            self.events.append(("free_image",))
        # compositor non-caption UI calls are not recorded
        self._return(value, HOOKS[address])

    # -- execution -----------------------------------------------------------
    def call(self, entry, args=(), this=None, pop_args=True, limit=20_000_000):
        esp = STACK + STACK_SIZE - 0x200
        self.w(esp, struct.pack("<I" + "I" * len(args), SENTINEL, *[a & 0xFFFFFFFF for a in args]))
        for name in ("EAX", "EBX", "EDX", "ESI", "EDI", "EBP"):
            self.setreg(name, 0)
        self.setreg("ECX", this if this is not None else 0)
        self.setreg("ESP", esp)
        self.uc.emu_start(entry, SENTINEL, count=limit)
        if self.reg("EIP") != SENTINEL:
            raise OracleError(f"0x{entry:x} did not return")

    def block(self, start, stop, locals_=None, limit=20_000_000):
        self.w(FRAME - 0x1000, b"\xCC" * 0x1000)
        for off, value in (locals_ or {}).items():
            self.w(FRAME + off, struct.pack("<I", value & 0xFFFFFFFF))
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI"):
            self.setreg(name, 0)
        self.setreg("EBP", FRAME)
        self.setreg("ESP", FRAME - 0x1000)
        self.uc.emu_start(start, stop, count=limit)
        if self.reg("EIP") != stop:
            raise OracleError(f"block 0x{start:x} stopped at 0x{self.reg('EIP'):x}")

    # -- state transfer --------------------------------------------------------
    def load(self, life: fx.Lifecycle, geometry: layout.Geometry) -> None:
        self.w(BOX, bytes(life.box))
        g = life.g
        for name, addr, fmt in GLOBALS:
            self.w(addr, struct.pack("<" + fmt, getattr(g, name)))
        for name, addr, fmt, n in ARRAYS:
            self.w(addr, struct.pack("<" + fmt * n, *getattr(g, name)))
        for name, addr in RECTS:
            self.w(addr, struct.pack("<4i", *getattr(g, name).tuple()))
        self.w(0x5D1631, struct.pack("<I", 0x5B160C + 4 * g.cursor_src_index))
        sh = life.shared[0]
        for name, addr, fmt in SHARED:
            self.w(addr, struct.pack("<" + fmt, getattr(sh, name)))
        self.w(TBOX, bytes(geometry.tbox))
        self.w(VIEW_ORIGIN, struct.pack("<ii", *life.view_origin))
        t = life.taskbar
        self.w(TASKBAR + 0x74F, struct.pack("<I", t.saved_surface))
        self.w(TASKBAR + 0x25, struct.pack("<4i", *t.area_src.tuple()))
        self.w(TASKBAR + 0x35, struct.pack("<4i", *t.area_dst.tuple()))
        self.w(TASKBAR + 0x55, struct.pack("<4i", *t.cc_rect.tuple()))

    def state(self) -> dict[str, Any]:
        out: dict[str, Any] = {"box": self.r(BOX, fx.BOX_BYTES)}
        for name, addr, fmt in GLOBALS:
            out[name] = struct.unpack("<" + fmt, self.r(addr, struct.calcsize(fmt)))[0]
        for name, addr, fmt, n in ARRAYS:
            out[name] = struct.unpack("<" + fmt * n, self.r(addr, struct.calcsize(fmt) * n))
        for name, addr in RECTS:
            out[name] = self.rect(addr)
        out["cursor_src_index"] = (struct.unpack("<I", self.r(0x5D1631, 4))[0] - 0x5B160C) // 4
        for name, addr, fmt in SHARED:
            out["shared." + name] = struct.unpack("<" + fmt, self.r(addr, struct.calcsize(fmt)))[0]
        return out


DEBUG_FLAG = 0x63A4CD


def native_state(life: fx.Lifecycle) -> dict[str, Any]:
    g = life.g
    out: dict[str, Any] = {"box": bytes(life.box)}
    for name, _addr, fmt in GLOBALS:
        v = getattr(g, name)
        if fmt == "f":
            v = struct.unpack("<f", struct.pack("<f", v))[0]
        out[name] = v
    for name, _addr, _fmt, n in ARRAYS:
        out[name] = tuple(getattr(g, name))
    for name, _addr in RECTS:
        out[name] = getattr(g, name).tuple()
    out["cursor_src_index"] = g.cursor_src_index
    sh = life.shared[0]
    for name, _addr, _fmt in SHARED:
        out["shared." + name] = getattr(sh, name)
    return out


class Pair:
    """Runs one scripted sequence on original and native side by side."""

    def __init__(self, exe, lib, data, geometry, sctb, script):
        self.exe, self.lib, self.data, self.geometry, self.sctb = exe, lib, data, geometry, sctb
        self.script = script
        self.orig = Original(exe, script, data)
        self.life = fx.make_life(data, geometry)
        self.backend = fx.RecordingBackend(script)
        self.orig.load(self.life, geometry)
        self.sctb_addr = self.orig.alloc(sctb)
        self.steps: list[dict[str, Any]] = []
        self.mismatches: list[dict[str, Any]] = []

    def step(self, label: str, original: Callable[[], None], native: Callable[[], int],
             compare_state: bool = True) -> int:
        self.orig.events = []
        self.backend.events = []
        original()
        status = native()
        o_state, n_state = self.orig.state(), native_state(self.life)
        o_events, n_events = self.orig.events, self.backend.events
        fatal = any(e[0] == "fatal" for e in o_events)
        diff = []
        if fatal:
            # The original continues after posting quit; compare up to the report.
            cut = next(i for i, e in enumerate(o_events) if e[0] == "fatal") + 1
            if o_events[:cut] != n_events[:cut] or status != fx.ERR_FATAL:
                diff.append("fatal")
        else:
            if o_events != n_events:
                diff.append("events")
            if compare_state:
                diff += [k for k in o_state if o_state[k] != n_state[k]]
        entry = {"step": label, "status": status, "events": len(o_events), "fatal": fatal}
        self.steps.append(entry)
        if diff:
            detail = {"step": label, "fields": diff, "status": status}
            if "box" in diff:
                ob, nb = o_state["box"], n_state["box"]
                detail["box_offsets"] = [hex(i) for i in range(len(ob)) if ob[i] != nb[i]][:20]
            if "events" in diff or "fatal" in diff:
                detail["original_events"] = [str(e) for e in o_events][:12]
                detail["native_events"] = [str(e) for e in n_events][:12]
            for k in diff:
                if k not in ("box", "events", "fatal"):
                    detail[k] = [str(o_state.get(k)), str(n_state.get(k))]
            self.mismatches.append(detail)
        return status

    # -- method wrappers --------------------------------------------------------
    def P(self):
        return c.byref(self.life), c.byref(self.backend.struct)

    def load_chunk(self, length=None):
        length = len(self.sctb) if length is None else length
        buf = layout.buf(self.sctb)
        return self.step(f"load_chunk({length})",
                         lambda: self.orig.call(0x4DE394, (self.sctb_addr, length), this=BOX),
                         lambda: self.lib.caption_ctb_load_chunk(*self.P(), buf, length))

    def init(self):
        return self.step("init", lambda: self.orig.call(0x4DE227, this=BOX),
                         lambda: self.lib.caption_ctb_init(*self.P()))

    def open(self, mode, text):
        addr = self.orig.alloc(text + b"\0" * 8)
        buf = layout.buf(text + b"\0" * 8)
        return self.step(f"open({mode},{text[:12]!r})",
                         lambda: self.orig.call(0x4DE24F, (mode, addr), this=BOX),
                         lambda: self.lib.caption_ctb_open(*self.P(), mode, buf, len(text) + 8))

    def method(self, name, address, native):
        return self.step(name, lambda: self.orig.call(address, this=BOX),
                         lambda: native(*self.P()))

    def close(self):
        return self.method("close", 0x4DE2D8, self.lib.caption_ctb_close)

    def poll(self):
        return self.method("poll", 0x4DE4F9, self.lib.caption_ctb_poll)

    def hover(self):
        return self.method("hover", 0x4DE322, self.lib.caption_ctb_hover)

    def click(self):
        return self.method("click", 0x4DE413, self.lib.caption_ctb_click)

    def draw(self):
        return self.method("draw", 0x4DE584, self.lib.caption_ctb_draw)

    def main_loop(self):
        return self.step("main_loop_flags", lambda: self.orig.block(0x43D0B4, 0x43D12A),
                         lambda: self.lib.caption_main_loop_flags(c.byref(self.life)))

    def clear_slot(self, slot):
        done = c.c_int()
        before = self.orig.r(0x5BB625 + slot * 0x8D, 1)
        def orig():
            self.orig.call(0x42AD90, (slot,))
        status = self.step(f"clear_slot({slot})", orig,
                           lambda: self.lib.caption_clear_slot_step(c.byref(self.life), slot,
                                                                    c.byref(done)))
        after = self.orig.r(0x5BB625 + slot * 0x8D, 1)
        if (after != before) != bool(done.value) or (done.value and after != b"\x01"):
            self.mismatches.append({"step": f"clear_slot({slot}) done flag",
                                    "fields": ["slot_done"]})
        self.orig.w(0x5BB625 + slot * 0x8D, before)
        return status

    def arm(self, delay):
        def orig():
            self.orig.w(CONVO_OBJECT + 0x69D, struct.pack("<h", delay))
            self.orig.block(0x4E93AE, 0x4E93D5, {-0x80: CONVO_OBJECT})
        return self.step(f"timed_arm({delay})", orig,
                         lambda: self.lib.caption_timed_arm(c.byref(self.life), delay) or 0)

    def dismiss(self):
        return self.step("timed_dismiss",
                         lambda: self.orig.call(0x4EA361, this=CONVO_OBJECT),
                         lambda: self.lib.caption_timed_dismiss(c.byref(self.life)) or 0)

    def scene_reset(self):
        return self.step("scene_reset", lambda: self.orig.block(0x438DA2, 0x438F53),
                         lambda: self.lib.caption_scene_reset(*self.P()))

    def present(self, caption_surface=0x60000100, framed_surface=0x60000200):
        o = self.orig
        bsum_rect = struct.unpack_from("<4i", self.data.bsum, FRAMED_DST - 0x5B0113)
        native_dst = fx.Rect(*bsum_rect)

        def orig():
            # Layer 2 is the cursor layer whose fields (0x5d162d / 0x5d1631 /
            # 0x5d1639) are compared state: keep it, but hide it while the
            # compositor runs (native presents only the caption layers).
            cursor_entry = o.r(LAYER_TABLE + 2 * LAYER_STRIDE, LAYER_STRIDE)
            o.w(LAYER_TABLE, bytes(LAYER_STRIDE * 0x40))
            o.w(FRAMED_DST, struct.pack("<4i", *bsum_rect))
            o.w(CAPTION_SRC, o.r(TBOX + 0x28, 16))
            g = self.life.g
            def entry(i, z, cb, surface, src, dst, enabled, kind):
                base = LAYER_TABLE + i * LAYER_STRIDE
                o.w(base, struct.pack("<iIIIIii", z, cb, surface, src, dst, enabled, 1))
                o.w(base + 0x1C, struct.pack("<h", kind))
            entry(8, 0x12, 0, framed_surface, 0x5B0A7E, FRAMED_DST, g.framed_layer_enabled, 1)
            entry(9, 0x11, 0x4D3705, 0, 0, 0, g.convo_restore_layer, 1)
            entry(10, 0x12, 0, caption_surface, CAPTION_SRC, TASKBAR + 0x55,
                  g.caption_layer_enabled, 2)
            entry(11, 0x11, 0x4D3714, 0, 0, 0, g.caption_restore_layer, 1)
            o.w(0x583204, struct.pack("<i", 0))
            o.w(0x5BB22A, struct.pack("<i", 0))
            o.call(0x4CF9F4)
            o.w(LAYER_TABLE + 2 * LAYER_STRIDE, cursor_entry)

        def native():
            status = self.lib.caption_ctb_draw(*self.P()) if self.life.shared[0].frame_open else 0
            if status:
                return status
            return self.lib.caption_present_layers(*self.P(), caption_surface, framed_surface,
                                                   c.byref(native_dst))
        return self.step("present", orig, native, compare_state=False)


def sctb_variant(sctb: bytes, **fields) -> bytes:
    """Copy of SCTB with fields changed; offsets are SCTB-relative."""
    out = bytearray(sctb)
    for offset, value in fields.values():
        if isinstance(value, bytes):
            out[offset:offset + len(value)] = value
        elif isinstance(value, tuple):
            struct.pack_into("<%di" % len(value), out, offset, *value)
        else:
            struct.pack_into("<i", out, offset, value)
    return bytes(out)


# SCTB offsets: popup field F -> F - 0x2c; slider field F -> 0x22a + F - 0x18.
def SL(field):
    return 0x22A + field - 0x18


def sequences(lib, exe, data, geometry, sctb):
    results = []

    def run(name, fn, script=None, chunk=None, view=(0, 0)):
        pair = Pair(exe, lib, data, geometry, chunk or sctb, script or fx.Script())
        pair.life.view_origin[0], pair.life.view_origin[1] = view
        pair.orig.load(pair.life, geometry)
        fn(pair)
        results.append((name, pair))

    def drag_through(p, lines, moves, horizontal=False):
        p.load_chunk(); p.init(); p.poll(); p.poll(); p.scene_reset()
        p.open(2, b"Scroll<n><e>")
        sh = p.life.shared[0]; sh.framed_scroll_lines = lines
        p.orig.load(p.life, p.geometry)
        p.poll()
        thumb = struct.unpack_from("<4i", bytes(p.life.box), fx.SLIDER + 0x13E)
        hot = fx.cursor_tables(4, 0)
        x = thumb[0] + 6 - hot[0]
        y = thumb[1] + 6 - hot[1]
        p.life.g.cursor_rect = fx.Rect(x, y, x + 5, y + 5)
        p.life.g.modal_input = 0
        p.orig.load(p.life, p.geometry)
        p.hover()
        p.script.left_down = True
        p.script.cursor = [x, y]
        p.poll()
        for d in moves:
            nx, ny = (x + d, y) if horizontal else (x, y + d)
            p.script.cursor = [nx, ny]
            p.life.g.cursor_rect = fx.Rect(nx, ny, nx + 5, ny + 5)
            p.orig.w(0x583102, struct.pack("<4i", nx, ny, nx + 5, ny + 5))
            p.hover(); p.poll(); p.draw()
        p.script.left_down = False
        p.poll(); p.draw()

    def boot(p):
        p.load_chunk(); p.init(); p.poll(); p.poll()

    def s5900(p):
        boot(p)
        p.open(2, b"<n><e>")            # S5900 action 11, CURL00 = "<n>"
        for _ in range(4):
            p.poll(); p.main_loop()
        p.draw(); p.present()
        p.scene_reset()                 # dismissal owner: scene change
        p.poll(); p.present()

    def nsht01(p):
        boot(p)
        sh = p.life.shared[0]
        sh.caption_visible_flag = 1     # as left by the S05-1 caption draw
        p.orig.load(p.life, p.geometry)
        p.main_loop(); p.present()
        sh = p.life.shared[0]; sh.caption_finish_flag = 1
        p.orig.load(p.life, p.geometry)
        for _ in range(3):
            p.main_loop(); p.present()

    def drag(p):
        boot(p)
        p.scene_reset()
        p.open(2, b"Long framed text<n><e>")
        sh = p.life.shared[0]; sh.framed_scroll_lines = 901
        p.orig.load(p.life, p.geometry)
        p.poll()
        thumb = struct.unpack_from("<4i", bytes(p.life.box), fx.SLIDER + 0x13E)
        hot = fx.cursor_tables(4, 0)
        x = thumb[0] + 6 - hot[0]
        y = thumb[1] + 6 - hot[1]
        p.life.g.cursor_rect = fx.Rect(x, y, x + 5, y + 5)
        p.life.g.modal_input = 0
        p.orig.load(p.life, p.geometry)
        p.hover()
        p.script.left_down = True
        p.script.cursor = [x, y]
        p.poll()                         # drag starts
        for dy in (8, 20, 40, 400, -30, -900):
            # The cursor system moves the cursor layer rect with the mouse.
            p.script.cursor = [x, y + dy]
            p.life.g.cursor_rect = fx.Rect(x, y + dy, x + 5, y + dy + 5)
            p.orig.w(0x583102, struct.pack("<4i", x, y + dy, x + 5, y + dy + 5))
            p.hover(); p.poll(); p.draw(); p.present()
        p.script.left_down = False
        p.poll(); p.poll(); p.draw(); p.present()

    def hover_cases(p):
        boot(p)
        p.open(2, b"x<n><e>")
        p.poll()
        p.hover()                        # modal input from init blocks hover
        p.life.g.modal_input = 0
        p.life.g.cursor_rect = fx.Rect(5000, 5000, 5005, 5005)
        p.orig.load(p.life, p.geometry)
        p.hover()                        # outside the popup
        for held, alt, override in ((-1, 0, 0), (3, 0, 0), (3, 1, 0), (-1, 0, 1)):
            p.life.g.held_item, p.life.g.cursor_alt = held, alt
            p.life.g.cursor_override = override
            p.life.g.cursor_rect = fx.Rect(100, 420, 104, 424)
            p.orig.load(p.life, p.geometry)
            p.hover(); p.click()

    def repeated(p):
        boot(p)
        for mode in (2, 3, 2):
            p.open(mode, b"again<n><e>")
            p.poll(); p.draw()
            p.open(mode, b"reopen while open<n><e>")
            p.poll(); p.close(); p.close(); p.poll(); p.draw()
        p.open(2, b"")                   # empty text: writer skipped

    def clears(p):
        boot(p)
        for flags in ((1, 0), (1, 1), (0, 1)):
            sh = p.life.shared[0]
            sh.caption_visible_flag, sh.caption_finish_flag = flags
            p.orig.load(p.life, p.geometry)
            for _ in range(3):
                p.main_loop()
        p.life.g.framed_clear_request = 1
        sh = p.life.shared[0]; sh.framed_ready = 1
        p.orig.load(p.life, p.geometry)
        for _ in range(3):
            p.main_loop(); p.present()
        for slot in (0, 5):
            sh = p.life.shared[0]; sh.caption_finish_flag = 1
            p.orig.load(p.life, p.geometry)
            p.clear_slot(slot); p.clear_slot(slot); p.clear_slot(slot)

    def timer(p):
        boot(p)
        p.dismiss()                      # stale: not armed
        for clock, delay in ((1000, 200), (0xFFFFFFF0, 0x20), (5, -10)):
            p.life.g.game_clock = clock
            p.orig.load(p.life, p.geometry)
            p.arm(delay); p.dismiss()
            p.life.g.game_clock = (clock + 300) & 0xFFFFFFFF
            p.orig.load(p.life, p.geometry)
            p.dismiss(); p.main_loop()

    def fatal_image(p):
        p.load_chunk(); p.init()

    def short_chunk(p):
        pass

    def hover_edges(p):
        p.load_chunk(); p.init(); p.poll(); p.poll()
        p.open(2, b"x<n><e>")
        p.poll()
        thumb = struct.unpack_from("<4i", bytes(p.life.box), fx.SLIDER + 0x13E)
        hot = fx.cursor_tables(4, 0)
        points = [(thumb[0] + 4, thumb[1] + 8), (thumb[0] + 5, thumb[1] + 8),
                  (thumb[2] + 5, thumb[1] + 8), (thumb[2] + 6, thumb[1] + 8),
                  (thumb[0] + 6, thumb[1] + 4), (thumb[0] + 6, thumb[1] + 5),
                  (thumb[0] + 6, thumb[3] + 10), (thumb[0] + 6, thumb[3] + 11)]
        for hx, hy in points:
            x, y = hx - hot[0], hy - hot[1]
            p.life.g.cursor_rect = fx.Rect(x, y, x + 5, y + 5)
            p.life.g.modal_input = 0
            p.orig.load(p.life, p.geometry)
            p.hover()

    for orientation, direction, track, bg, thumb_src in (
            (1, 3, None, None, None),
            (0, 0, (18, 393, 100, 416), (0, 0, 82, 23), (19, 12, 33, 35)),
            (0, 1, (18, 393, 100, 416), (0, 0, 82, 23), (19, 12, 33, 35)),
            (0, 0, (18, 393, 32, 416), (0, 0, 14, 23), (19, 12, 33, 35))):
        changes = {"o": (SL(0xCE), orientation), "d": (SL(0xD2), direction)}
        if track:
            changes.update(t=(SL(0xAE), track), b=(SL(0x9E), bg), s=(SL(0x5E), thumb_src))
        chunk = sctb_variant(sctb, **changes)
        moves = (6, 25, 70, -200) if orientation == 0 else (8, 30, 400, -30)
        run(f"slider_o{orientation}_d{direction}" + ("_filled" if track and track[2] == 32 else ""),
            lambda p, m=moves, h=orientation == 0: drag_through(p, 901, m, h), chunk=chunk)
    run("scroll_clamp_exact_920", lambda p: drag_through(p, 920, (60, 400)))
    run("scroll_clamp_921", lambda p: drag_through(p, 921, (60, 400)))
    run("hover_edges", hover_edges)
    run("relative_rects_view_origin",
        lambda p: drag_through(p, 901, (10, 40)),
        chunk=sctb_variant(sctb, r=(0x93 - 0x2C, 1), sr=(SL(0xBE), 1)), view=(10, 11))
    run("sound_and_scene",
        lambda p: (p.load_chunk(), p.init(), p.poll(), p.poll(), p.open(2, b"s<n><e>"),
                   p.poll(), p.poll()),
        chunk=sctb_variant(sctb, n=(0x9B - 0x2C, b"TESTSND\0"), sc=(0x51 - 0x2C, b"\x10\x27")))

    def timer_equal(p):
        p.load_chunk(); p.init()
        p.life.g.game_clock = 500
        p.orig.load(p.life, p.geometry)
        p.arm(100)
        for clock in (599, 600, 601):
            p.life.g.game_clock = clock
            p.orig.load(p.life, p.geometry)
            p.dismiss()
    run("timed_dismiss_equal", timer_equal)

    run("boot", boot)
    run("s5900_action11_curl00", s5900)
    run("s0_nsht01_caption_layers", nsht01)
    run("slider_drag_scroll", drag)
    run("hover_cursor_modal", hover_cases)
    run("repeated_open_close", repeated)
    run("caption_framed_slot_clears", clears)
    run("timed_dismiss_wrap_stale", timer)
    run("fatal_missing_popup_sheet", fatal_image, fx.Script(fail_image="UIConvoPopup_OVL"))
    return results


def run(args) -> dict[str, Any]:
    data = layout.ShippedData()
    lay = layout.bind()
    fmt, fonts, geometry = layout.native_context(lay, data)
    sctb = layout.hiff_chunks(data.load_bytes(b"BOOT"))[b"SCTB"]
    lib = fx.bind(args.native_library)
    results = sequences(lib, args.exe, data, geometry, sctb)
    report_sequences = []
    mismatches = []
    steps = 0
    for name, pair in results:
        steps += len(pair.steps)
        report_sequences.append({"sequence": name, "steps": pair.steps})
        mismatches += [{"sequence": name, **m} for m in pair.mismatches]
    pe = PEImage.parse_and_map(args.exe)
    return {
        "scope": "S05-2 caption/framed lifecycle: CScrollTextBox, CUIPopup, CUISlider, "
                 "caption clears, timed dismiss, main-loop block, scene reset, compositor layers",
        "original_sha256": sha256(pe.data),
        "native_library_sha256": hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
        "sctb_sha256": hashlib.sha256(sctb).hexdigest(),
        "tbox_sha256": hashlib.sha256(bytes(geometry.tbox)).hexdigest(),
        "sequences": len(results),
        "steps": steps,
        "mismatches": mismatches,
        "results": report_sequences,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=fx.LIBRARY)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleError, OSError, ValueError, RuntimeError) as exc:
        print(f"oracle error: {exc}", file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=1, default=str) + "\n")
    print(f"sequences {report['sequences']} steps {report['steps']} "
          f"mismatches {len(report['mismatches'])}")
    if report["mismatches"]:
        print(json.dumps(report["mismatches"][:5], indent=1, default=str)[:5000], file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
