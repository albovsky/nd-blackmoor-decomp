#!/usr/bin/env python3
"""Compare the native AVF playback kernel with the original GAME.EXE code.

Original code that runs unmodified under Unicorn (with the S03-1 decoder
routines it reaches):

* RANDOM_MOVIE: start 0x4cdfd3 (with 0x44c4c1 open, 0x414ceb, 0x4161d1),
  worker 0x4cf687, controller tick 0x4cd6ff state 1 -> 0x4ce602 (with
  0x4cec6c), stop 0x4ccef1 (with 0x415011, 0x41632b);
* MOVIE: worker 0x4c0c7d, controller tick 0x4bf9bb state 1 -> 0x4c0205
  (with 0x4c09fe), render callback 0x4c0d3f, stop 0x4bf773;
* PARTNER_LOGO: worker 0x4c0c7d, 0x4dc182 case 2 -> 0x4dcdd3 (with
  0x4dd28d), stop 0x4dc043;
* SECONDARY_VIDEO: worker 0x44cde2 (GetChunk 0x415176), controller tick
  0x42c221 state 1 with 0x42e72c and 0x42d215;
* handshake 0x44c479 / 0x44c4ab everywhere.

Host boundaries (each recorded, never deciding a schedule): GetTickCount
(scripted clock, one value per original call), Sleep (ends a worker
iteration), AfxEndThread, fopen probe 0x449d90 (only the .AVF candidate
exists), surface creation 0x4c2a8d/0x4c2c3a, thread object 0x4497a0, resume
0x449bff, kill 0x449a94 and the thread's deleting destructor, Bink close
0x4bedfa, surface free 0x4c2dfb, blit 0x4c5377, partner input 0x4dadff /
0x4dad60, partner sound 0x4fb2e3 / 0x4f6334, and the Boot-side frame
effects 0x4ceb8c, 0x4c0ab1, 0x4c08d3, 0x42ca22 and 0x42caa8 (recorded as
RECT/TRIGGERS events). Allocations use operator new/delete hooks over a
free-list heap filled with 0xCD.

After every operation (start, worker poll, tick, render ack, stop) the
oracle compares the kernel state with the original fields, the ordered
event and handshake traces, the number of clock samples, and the presented
pixels.

    work/tools/oracle-python/bin/python \\
        outputs/blackmoor-decomp/tests/avf_player_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import struct
import subprocess
import sys
import tempfile
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Callable

sys.path.insert(0, str(Path(__file__).resolve().parent))
import avf_decoder_original_oracle as dec  # noqa: E402
import test_avf_decoder as fx  # noqa: E402
from hiff_original_oracle import DEFAULT_EXE, PEImage, sha256  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_REPORT = ROOT / "work/analysis/slices/S03-2.validation.json"

GET_TICK_COUNT, SLEEP = 0x52A23C, 0x52A2B0
AFX_END_THREAD = 0x51EC84
ACQUIRE, RELEASE = 0x44C479, 0x44C4AB
SLOT_TABLE, SLOT_STRIDE = 0x5BB5E5, 0x8D      # controller record pointer per action slot
SLOT_STATE = 0x5BB632
CURRENT_VIEW = 0x5BB50B
HEAP, HEAP_SIZE = 0x40000000, 0x10000000
FAKE = 0x3A000000                             # fake thread vtable / surfaces
TIB = 0x3C000000
SLOT = 3                                      # action slot used by the fixtures

RANDOM_OBJ = 0x63821D
MOVIE_OBJ = 0x637FCF
PARTNER_OBJ = 0x3B000000                      # CPartnerLogo object (heap in game)

# Hooked helpers: address -> (name, stack bytes popped, event kind or None).
HELPERS = {
    0x449D90: ("fopen_probe", 0),
    0x4C2A8D: ("surface_create", 0x10),
    0x4C2C3A: ("surface_create2", 0x14),
    0x4497A0: ("thread_ctor", 0x10),
    0x449BFF: ("resume", 0),
    0x449A94: ("kill", 0),
    0x4BEDFA: ("bink_close", 4),
    0x4C2DFB: ("surface_free", 4),
    0x4C5377: ("blit", 0x14),
    0x4DADFF: ("partner_input", 0),
    0x4DAD60: ("partner_input_reset", 0),
    0x4FB2E3: ("partner_sound", 4),
    0x4F6334: ("partner_sound_busy", 4),
    0x4CEB8C: ("random_rect", 0),
    0x4C0AB1: ("movie_triggers", 0),
    0x4C08D3: ("movie_rect", 0),
    0x42CA22: ("secondary_triggers", 0),
    0x42CAA8: ("secondary_rect", 0),
    0x4D36ED: ("ui_state", 0),
    0x4BEDE7: ("bink_reset", 0),
    0x44C2E0: ("secondary_extra", 0),
    0x4C2790: ("surface_load", 0x10),
    0x4C46D1: ("surface_fill", 0x10),
}
CODE_WINDOWS = {
    "random_start_0x4cdfd3": (0x4CDFD3, 0x4CE5FF),
    "random_tick_0x4cd6ff": (0x4CD6FF, 0x4CDFD3),
    "random_step_0x4ce602": (0x4CE602, 0x4CE8EA),
    "random_index_0x4cec6c": (0x4CEC6C, 0x4CECE3),
    "random_worker_0x4cf687": (0x4CF687, 0x4CF749),
    "random_stop_0x4ccef1": (0x4CCEF1, 0x4CCFBD),
    "movie_tick_0x4bf9bb": (0x4BF9BB, 0x4C0205),
    "movie_step_0x4c0205": (0x4C0205, 0x4C04E3),
    "movie_index_0x4c09fe": (0x4C09FE, 0x4C0AB1),
    "movie_worker_0x4c0c7d": (0x4C0C7D, 0x4C0D3F),
    "movie_render_0x4c0d3f": (0x4C0D3F, 0x4C0E90),
    "movie_stop_0x4bf773": (0x4BF773, 0x4BF838),
    "partner_0x4dc182": (0x4DC182, 0x4DCDD3),
    "partner_step_0x4dcdd3": (0x4DCDD3, 0x4DD05A),
    "partner_index_0x4dd28d": (0x4DD28D, 0x4DD32A),
    "partner_stop_0x4dc043": (0x4DC043, 0x4DC0D2),
    "secondary_tick_0x42c221": (0x42C221, 0x42CA22),
    "secondary_index_0x42d215": (0x42D215, 0x42D35A),
    "secondary_swap_0x42e72c": (0x42E72C, 0x42E7A0),
    "secondary_worker_0x44cde2": (0x44CDE2, 0x44CF01),
    "handshake_0x44c479": (0x44C479, 0x44C4C1),
    "open_0x44c4c1": (0x44C4C1, 0x44C6E5),
    "buffers_0x4161d1": (0x4161D1, 0x41632B),
    "free_0x41632b": (0x41632B, 0x4163B4),
}


class Stop(Exception):
    pass


class PlayerOriginal(dec.Original):
    """The S03-1 oracle machine plus the playback host boundaries."""

    def __init__(self, exe: Path, masks=(0x7C00, 0x03E0, 0x001F)) -> None:
        super().__init__(exe, masks)
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UC_PROT_ALL
        uc = self.uc
        uc.mem_map(HEAP, HEAP_SIZE, UC_PROT_ALL)
        uc.mem_map(FAKE, 0x100000, UC_PROT_ALL)
        uc.mem_map(PARTNER_OBJ, 0x1000, UC_PROT_ALL)
        # Thread information block for the SEH prologues (fs:[0] = no frame).
        uc.mem_map(TIB, 0x1000, UC_PROT_ALL)
        uc.mem_write(TIB, struct.pack("<I", 0xFFFFFFFF))
        self._install_fs(TIB)
        self.heap_cursor = HEAP
        self.free_lists: dict[int, list[int]] = {}
        self.sizes: dict[int, int] = {}
        stubs = {GET_TICK_COUNT: ("GetTickCount", 0), SLEEP: ("Sleep", 4)}
        for k, (slot, info) in enumerate(stubs.items()):
            stub = dec.STUBS + 0x100 + 0x10 * k
            uc.mem_write(slot, struct.pack("<I", stub))
            self.stub_names[stub] = info
            uc.hook_add(UC_HOOK_CODE, self._host, begin=stub, end=stub)
        self.delete_stub = dec.STUBS + 0x200
        uc.mem_write(FAKE, struct.pack("<I", self.delete_stub))   # fake thread vtable
        for address in [*HELPERS, AFX_END_THREAD, self.delete_stub]:
            uc.hook_add(UC_HOOK_CODE, self._helper, begin=address, end=address)
        uc.hook_add(UC_HOOK_CODE, self._observe_release, begin=RELEASE, end=RELEASE)
        self.now = 0
        self.clock_used = 0
        self.trace: list[tuple] = []
        self.handshake_addresses: set[int] = set()
        self.fake_cursor = FAKE + 0x100
        self.sound_busy = 0
        self._write_hook = UC_HOOK_MEM_WRITE

    def watch_handshake(self, address: int) -> None:
        self.handshake_addresses = {address}
        self.uc.hook_add(self._write_hook, self._observe_write, begin=address, end=address + 3)

    def _install_fs(self, base: int) -> None:
        """GDT: 1 = FS data segment at `base`, 2 = flat 32-bit data for SS/DS/ES."""
        def entry(seg_base: int, limit: int, flags: int) -> int:
            access = 0x80 | 0x10 | 0x02           # present, data, writable, DPL 0
            return (limit & 0xFFFF) | ((seg_base & 0xFFFFFF) << 16) | (access << 40) | \
                (((limit >> 16) & 0xF) << 48) | (flags << 52) | (((seg_base >> 24) & 0xFF) << 56)
        gdt = TIB + 0x800
        self.uc.mem_write(gdt, struct.pack("<QQQ", 0, entry(base, 0xFFF, 0x4),
                                           entry(0, 0xFFFFF, 0xC)))
        self.uc.reg_write(self.x.UC_X86_REG_GDTR, (0, gdt, 24 - 1, 0))
        for reg in ("SS", "DS", "ES"):
            self.uc.reg_write(getattr(self.x, f"UC_X86_REG_{reg}"), 2 << 3)
        self.uc.reg_write(self.x.UC_X86_REG_FS, 1 << 3)

    # -- heap -----------------------------------------------------------------
    def alloc(self, size: int) -> int:
        size = max(1, size)
        free = self.free_lists.get(size)
        if free:
            ptr = free.pop()
        else:
            ptr = (self.heap_cursor + 15) & ~15
            if ptr + size > HEAP + HEAP_SIZE:
                return 0
            self.heap_cursor = ptr + size
        self.sizes[ptr] = size
        self.w(ptr, b"\xCD" * size)
        return ptr

    def free(self, ptr: int) -> None:
        size = self.sizes.pop(ptr, None)
        if size is not None:
            self.free_lists.setdefault(size, []).append(ptr)

    def fake(self, size: int) -> int:
        ptr = (self.fake_cursor + 15) & ~15
        self.fake_cursor = ptr + size
        return ptr

    # -- hooks ----------------------------------------------------------------
    def _host(self, uc, address, size, user) -> None:
        if address == dec.NEW:
            n = self.arg(0)
            self.events.append(("new", n))
            self._return(self.alloc(n), 0)
        elif address == dec.DELETE:
            self.free(self.arg(0))
            self.events.append(("delete",))
            self._return(0, 0)
        elif address in self.stub_names and self.stub_names[address][0] == "GetTickCount":
            self.clock_used += 1
            self._return(self.now & 0xFFFFFFFF, 0)
        elif address == 0x50CA3E:
            # sprintf into the shared message buffer: also used on normal
            # paths (thread names). Fatal paths are stopped by 0x4264e8 etc.
            self._return(0, 0)
        elif address in self.stub_names and self.stub_names[address][0] == "Sleep":
            self.trace.append(("sleep",))
            self.slept = True
            uc.emu_stop()
        else:
            super()._host(uc, address, size, user)

    def _observe_release(self, uc, address, size, user) -> None:
        if self.u32(self.reg("ESP") + 4) in self.handshake_addresses:
            self.trace.append(("release",))

    def _observe_write(self, uc, access, address, size, value, user) -> None:
        if address in self.handshake_addresses and size == 4:
            eip = self.reg("EIP")
            if RELEASE <= eip < 0x44C4C1:
                return                             # part of RELEASE
            token = {1: "acquire", 2: "halt", 0: "idle"}.get(value & 0xFFFFFFFF, f"h{value}")
            self.trace.append((token,))

    def _helper(self, uc, address, size, user) -> None:
        if address == AFX_END_THREAD:
            self.trace.append(("exit",))
            self.exited = True
            uc.emu_stop()
            return
        if address == self.delete_stub:
            self.trace.append(("delete_thread",))
            self._return(0, 4)
            return
        name, pop = HELPERS[address]
        ecx = self.reg("ECX")
        value = 0
        if name == "fopen_probe":
            path = self.cstr(self.arg(0))
            value = 1 if b".AVF" in path.upper() else 0
        elif name in ("surface_create", "surface_create2"):
            width, height = self.arg(0), self.arg(1)
            value = self.new_surface(width, height)
            self.trace.append((name, width, height))
        elif name == "surface_load":
            value = self.new_surface(8, 8)
        elif name == "thread_ctor":
            self.w(ecx, struct.pack("<I", FAKE))
            self.w(ecx + 0x36, struct.pack("<I", 1))   # CWinThread present
            self.w(ecx + 0x3E, struct.pack("<I", 0))   # exit flag
            self.thread_object = ecx
            self.trace.append(("thread",))
            value = ecx
        elif name == "resume":
            self.trace.append(("resume",))
        elif name == "kill":
            self.w(ecx + 0x3E, struct.pack("<I", 1))
            self.trace.append(("kill",))
        elif name == "random_rect":
            self.trace.append(("rect", struct.unpack("<i", self.r(ecx + 0x24A, 4))[0]))
        elif name == "movie_rect":
            self.trace.append(("rect", self.view_index(self.u32(ecx + 0x24A))))
        elif name == "movie_triggers":
            self.trace.append(("triggers", struct.unpack("<h", self.r(ecx + 0x244, 2))[0]))
        elif name == "secondary_triggers":
            self.trace.append(("triggers", struct.unpack("<h", self.r(0x5B4E00, 2))[0]))
        elif name == "secondary_rect":
            self.trace.append(("rect", struct.unpack("<h", struct.pack("<H", self.arg(0) & 0xFFFF))[0]))
        elif name == "partner_sound":
            self.trace.append(("sound", struct.unpack("<h", struct.pack("<H", self.arg(0) & 0xFFFF))[0]))
        elif name == "partner_sound_busy":
            value = self.sound_busy
        elif name == "blit":
            self.trace.append(("blit", self.cstr(self.arg(4)).decode("latin-1")))
        elif name in ("surface_free",):
            self.trace.append((name,))
        self._return(value, pop)

    def cstr(self, addr: int) -> bytes:
        out = bytearray()
        while len(out) < 512:
            b = self.r(addr + len(out), 1)
            if b == b"\0":
                break
            out += b
        return bytes(out)

    def new_surface(self, width: int, height: int) -> int:
        obj = self.fake(0x60)
        width = struct.unpack("<i", struct.pack("<I", width & 0xFFFFFFFF))[0]
        height = struct.unpack("<i", struct.pack("<I", height & 0xFFFFFFFF))[0]
        if not 0 < width <= 4096 or not 0 < height <= 4096:
            width = height = 8                 # logo/screen surfaces: size irrelevant
        size = width * height * 2
        pixels = self.alloc(size)
        self.w(obj, struct.pack("<I", pixels))
        self.w(obj + 0x23, struct.pack("<I", size))
        self.w(obj + 0x2B, struct.pack("<hh", width, height))
        return obj

    view_index: Callable[[int], int] = staticmethod(lambda ptr: ptr)

    # -- execution ------------------------------------------------------------
    def run(self, function: int, args: list[int], ecx: int, *, worker: bool = False) -> int:
        self.slept = False
        self.exited = False
        try:
            return self.call(function, args, ecx)
        except dec.OracleError:
            if worker and (self.slept or self.exited):
                return 0
            raise

    def open_view(self, data: bytes) -> None:
        self.w(dec.VIEW, data + bytes(dec.VIEW_SIZE - len(data)))


# -- native side ----------------------------------------------------------------
PRESENT = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_void_p)
FRAME_EVENT = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_void_p)
CLOCK = c.CFUNCTYPE(c.c_uint32, c.c_void_p)
LIFECYCLE = c.CFUNCTYPE(None, c.c_void_p, c.c_int)


class Presentation(c.Structure):
    _fields_ = [("generation", c.c_uint32), ("kind", c.c_int), ("pixels", c.c_void_p),
                ("bytes", c.c_size_t), ("slot", c.c_int), ("frame_index", c.c_int16)]


class FrameEvent(c.Structure):
    _fields_ = [("generation", c.c_uint32), ("kind", c.c_int), ("frame_index", c.c_int16),
                ("record", c.c_int32)]


class Host(c.Structure):
    _fields_ = [("context", c.c_void_p), ("clock", CLOCK), ("present", PRESENT),
                ("frame_event", FRAME_EVENT), ("lifecycle", LIFECYCLE)]


class Config(c.Structure):
    _fields_ = [("kind", c.c_int), ("mode", c.c_int32), ("first", c.c_int16),
                ("last", c.c_int16), ("direction", c.c_int16), ("surface_bytes", c.c_size_t),
                ("sound", c.c_int32), ("sound_id", c.c_int16), ("start_mode", c.c_int16),
                ("loop_last", c.c_int16), ("hold_last", c.c_int16), ("hold_start", c.c_int16),
                ("end_last", c.c_int16), ("present_mode", c.c_int16)]


class Gate(c.Structure):
    _fields_ = [("records", c.POINTER(c.c_int32)), ("record_count", c.c_size_t),
                ("sound_busy", c.c_int32), ("skip", c.c_int32), ("slot_current", c.c_int32)]


class Player(c.Structure):
    _fields_ = [("kind", c.c_int), ("config", Config), ("host", Host),
                ("stream", c.POINTER(fx.AvfStream)), ("slots", c.c_void_p * 2),
                ("slot_bytes", c.c_size_t), ("generation", c.c_uint32), ("running", c.c_int32),
                ("decoder_status", c.c_int), ("handshake", c.c_int32), ("exit_flag", c.c_int32),
                ("ready", c.c_int16), ("index", c.c_int16), ("delay", c.c_int32),
                ("substate", c.c_int32), ("deadline", c.c_uint32), ("presented", c.c_int32),
                ("done", c.c_int32), ("finished", c.c_int32), ("dirty", c.c_int32),
                ("shown", c.c_int32), ("visible", c.c_int32), ("record", c.c_int32),
                ("matched", c.c_int32), ("flag206", c.c_int32), ("flag20a", c.c_int32),
                ("flag21a", c.c_int32), ("started_at", c.c_uint32),
                ("secondary_mode", c.c_int32), ("slot_toggle", c.c_int16),
                ("slot_result", c.c_void_p * 2), ("slot_result_bytes", c.c_size_t * 2)]


KINDS = {"random": 0, "movie": 1, "partner": 2, "secondary": 3}
LIFE = {1: "resume", 2: "acquire", 3: "release", 4: "halt", 5: "kill", 6: "idle"}
EVENT = {1: "rect", 2: "triggers", 3: "sound", 4: "blit"}


def bind_player(path: Path) -> c.CDLL:
    lib = fx.bind(path)
    lib.avf_player_start.argtypes = [c.POINTER(Player), c.POINTER(Config),
                                     c.POINTER(fx.AvfStream), c.c_void_p, c.c_void_p,
                                     c.c_size_t, c.POINTER(Host)]
    lib.avf_player_restart.argtypes = [c.POINTER(Player), c.POINTER(Config)]
    lib.avf_player_worker_poll.argtypes = [c.POINTER(Player), c.POINTER(c.c_int)]
    lib.avf_player_tick.argtypes = [c.POINTER(Player), c.POINTER(Gate)]
    lib.avf_player_render_ack.argtypes = [c.POINTER(Player), c.c_uint32, c.POINTER(c.c_int)]
    lib.avf_player_set_secondary_mode.argtypes = [c.POINTER(Player), c.c_int32]
    lib.avf_player_stop.argtypes = [c.POINTER(Player)]
    lib.avf_player_status_name.argtypes = [c.c_int]
    lib.avf_player_status_name.restype = c.c_char_p
    for name in ("avf_player_start", "avf_player_restart", "avf_player_worker_poll",
                 "avf_player_tick", "avf_player_render_ack", "avf_player_set_secondary_mode",
                 "avf_player_stop"):
        getattr(lib, name).restype = c.c_int
    return lib


class NativeSession:
    """A native player with recording host callbacks."""

    def __init__(self, lib: c.CDLL, data: bytes, mode: int, surface_bytes: int = 0,
                 slots: bool = False) -> None:
        self.lib = lib
        self.raw = fx.ubuf(data)
        self.file = fx.AvfFile()
        if lib.avf_open(self.raw, len(data), c.byref(self.file)) != fx.OK:
            raise RuntimeError("native open failed")
        fb = self.file.frame_bytes
        self.buffers = [(c.c_uint8 * fb)(*([0xCD] * fb)) for _ in range(2)]
        self.scratch = (c.c_uint8 * max(1, self.file.max_unpacked))()
        self.stream = fx.AvfStream()
        status = lib.avf_stream_init(c.byref(self.stream), c.byref(self.file), self.buffers[0],
                                     self.buffers[1] if mode == 1 else None, fb, self.scratch,
                                     self.file.max_unpacked, fx.CONVERT(), None)
        if status != fx.OK:
            raise RuntimeError("native stream init failed")
        self.slot_bytes = max(fb, self.file.max_unpacked, 1)
        self.slot_buffers = [(c.c_uint8 * self.slot_bytes)() for _ in range(2)] if slots else None
        self.surface = bytearray(b"\xCD" * max(surface_bytes, 1))
        self.now = 0
        self.clock_used = 0
        self.trace: list[tuple] = []
        self.selected: tuple[int, int] | None = None   # (address, bytes) the surface shows
        self.host = Host(None, CLOCK(self._clock), PRESENT(self._present),
                         FRAME_EVENT(self._event), LIFECYCLE(self._life))
        self.fail_on: str | None = None
        self.player = Player()

    def _clock(self, _ctx):
        self.clock_used += 1
        return self.now & 0xFFFFFFFF

    def _present(self, _ctx, ptr):
        p = Presentation.from_address(ptr)
        if p.kind == 1:
            self.surface[:p.bytes] = bytes((c.c_uint8 * p.bytes).from_address(p.pixels))
        else:
            self.selected = (p.pixels or 0, p.bytes)
        return 1 if self.fail_on == "present" else 0

    def _event(self, _ctx, ptr):
        e = FrameEvent.from_address(ptr)
        kind = EVENT[e.kind]
        if kind in ("rect", "sound"):
            self.trace.append((kind, e.record))
        elif kind == "triggers":
            self.trace.append((kind, e.frame_index))
        else:
            self.trace.append((kind,))
        return 1 if self.fail_on == kind else 0

    def _life(self, _ctx, value):
        self.trace.append((LIFE[value],))

    def selected_digest(self) -> str | None:
        if self.selected is None or not self.selected[0]:
            return None
        return dec.digest(bytes((c.c_uint8 * self.selected[1]).from_address(self.selected[0])))


def gate_struct(records: list[int], sound_busy: int = 0, skip: int = 0,
                slot_current: int = 1) -> tuple[Gate, Any]:
    arr = (c.c_int32 * max(1, len(records)))(*records)
    return Gate(arr, len(records), sound_busy, skip, slot_current), arr


# -- schedules ------------------------------------------------------------------------
@dataclass
class Step:
    op: str                         # poll | tick | ack | stop | restart | mode
    now: int = 0                    # GetTickCount value during this step
    view: int = 1                   # current view id (0x5bb50b)
    sound_busy: int = 0
    skip: int = 0
    slot_current: int = 1
    arg: int = 0                    # secondary mode for "mode"


HOST_ONLY = ("sleep", "thread", "surface_create", "surface_create2", "surface_free",
             "delete_thread", "exit")


def normalize_trace(trace: list[tuple], kind: str) -> list[tuple]:
    """Keep handshake, lifecycle and frame-effect tokens. Host plumbing
    (thread object, surfaces, deleting destructor, Sleep) is not a kernel
    effect; MOVIE render blits are compared through `blitted`."""
    out = []
    for t in trace:
        if t[0] in HOST_ONLY:
            continue
        if t[0] == "blit":
            if kind == "movie":
                continue
            out.append(("blit",) if "PartnerAnimation" in t[1] else t)
            continue
        out.append(t)
    return out


def i16(o, addr):
    return struct.unpack("<h", o.r(addr, 2))[0]


def i32(o, addr):
    return struct.unpack("<i", o.r(addr, 4))[0]


class Controller:
    kind = ""

    def __init__(self, o: PlayerOriginal, data: bytes, cfg: dict[str, Any]) -> None:
        self.o = o
        self.data = data
        self.cfg = cfg
        w, h = struct.unpack_from("<hh", data, 0x17)
        self.frame_bytes = w * h * 2
        o.open_view(data)

    def table(self, ids: list[int], stride: int) -> int:
        base = self.o.alloc(stride * max(1, len(ids)))
        self.o.w(base, b"\0" * stride * max(1, len(ids)))
        for i, v in enumerate(ids):
            self.o.w(base + i * stride, struct.pack("<h", v))
        return base

    def surface_digest(self, surface_obj: int, size: int, chunk: int | None = None) -> str | None:
        """Digest of what the surface shows. For selecting controllers only a
        pointer to one of the CChunk frame buffers counts as a presentation;
        before the first swap the surface still shows its own allocation."""
        if not surface_obj:
            return None
        pixels = self.o.u32(surface_obj)
        if not pixels:
            return None
        if chunk is not None and pixels not in (self.o.u32(chunk + 0x17A),
                                                self.o.u32(chunk + 0x17E)):
            return None
        return dec.digest(self.o.r(pixels, size))


class RandomMovie(Controller):
    """RANDOMMOVIE object 0x63821d (CChunk at +8, H at +4)."""
    kind = "random"

    def __init__(self, o, data, cfg):
        super().__init__(o, data, cfg)
        o.watch_handshake(RANDOM_OBJ + 4)
        rec = o.alloc(0x40)
        o.w(rec, b"\0" * 0x40)
        o.w(rec + 0x21, struct.pack("<hhh", cfg["mode"], 1, len(cfg["views"])))
        seq = o.alloc(0x35)
        o.w(seq, b"fixture\0" + b"\0" * (0x35 - 8))
        o.w(seq + 0x21, struct.pack("<hh", cfg["first"], cfg["last"]))
        views = self.table(cfg["views"], 0x22)
        o.w(RANDOM_OBJ, b"\0" * 0x260)
        o.w(SLOT_TABLE + SLOT * SLOT_STRIDE, struct.pack("<I", rec))
        o.w(SLOT_STATE + SLOT * SLOT_STRIDE, struct.pack("<I", 1))
        for off, value in {0x222: rec, 0x226: seq, 0x22A: views, 0x246: 0, 0x23E: SLOT,
                           0x17A: cfg["mode"], 0x1DE: 0, 0x24A: 0xFFFFFFFF}.items():
            o.w(RANDOM_OBJ + off, struct.pack("<I", value))

    def start(self):
        if self.o.run(0x4CDFD3, [0], RANDOM_OBJ) != 1:
            raise RuntimeError("0x4cdfd3 failed")
        self.surface = self.o.u32(RANDOM_OBJ + 0x212)

    restart = start

    def poll(self):
        self.o.run(0x4CF687, [self.o.u32(RANDOM_OBJ + 0x1D6) + 0x3E], 0, worker=True)

    def tick(self, step):
        self.o.w(CURRENT_VIEW, struct.pack("<h", step.view))
        self.o.run(0x4CD6FF, [SLOT], RANDOM_OBJ)

    def stop(self):
        self.o.run(0x4CCEF1, [], RANDOM_OBJ)

    def state(self):
        o, b = self.o, RANDOM_OBJ
        return {
            "handshake": i32(o, b + 4), "ready": i16(o, b + 0x1D4), "index": i16(o, b + 0x1CA),
            "substate": i32(o, b + 0x1DA), "deadline": o.u32(b + 0x1C6),
            "presented": i32(o, b + 0x232), "done": i32(o, b + 0x20E),
            "finished": int(i32(o, b + 0x1DE) == 3), "visible": i32(o, b + 0x236),
            "record": i32(o, b + 0x24A), "flag206": i32(o, b + 0x206),
            "flag20a": i32(o, b + 0x20A), "toggle": i16(o, b + 0x192),
            "flags": [o.u32(b + 0x18A) & 0xFFFF, o.u32(b + 0x18C) & 0xFFFF],
            "last_index": i32(o, b + 8 + 0x45), "delay": i32(o, b + 0x24),
            "surface": self.surface_digest(self.surface, self.frame_bytes),
        }

    def native_state(self, n):
        p, st = n.player, n.stream
        return {
            "handshake": p.handshake, "ready": p.ready, "index": p.index, "substate": p.substate,
            "deadline": p.deadline, "presented": p.presented, "done": p.done,
            "finished": p.finished, "visible": p.visible, "record": p.record,
            "flag206": p.flag206, "flag20a": p.flag20a, "toggle": st.toggle,
            "flags": [st.flags[0], st.flags[1]], "last_index": st.last_index, "delay": p.delay,
            "surface": dec.digest(bytes(n.surface[:self.frame_bytes])),
        }

    def config(self):
        c_ = self.cfg
        return Config(0, c_["mode"], c_["first"], c_["last"], 1, self.frame_bytes, 0, 0, 0,
                      0, 0, 0, 0, 0)

    def presented_frame(self, st):
        return st["presented"]


class Movie(Controller):
    """MOVIE action object 0x637fcf (CChunk 0x637fd7, H 0x637fd3)."""
    kind = "movie"

    def __init__(self, o, data, cfg):
        super().__init__(o, data, cfg)
        o.watch_handshake(MOVIE_OBJ + 4)
        rec = o.alloc(0x200)
        o.w(rec, b"fixture\0" + b"\0" * (0x200 - 8))
        o.w(rec + 0x21, struct.pack("<h", 0))                     # AVF
        o.w(rec + 0x27, struct.pack("<hhhh", cfg["mode"], cfg["direction"], cfg["first"],
                                    cfg["last"]))
        o.w(rec + 0x37, struct.pack("<h", -1))
        o.w(rec + 0x3B, struct.pack("<h", 0))                     # no trigger records
        o.w(rec + 0x3D, bytes((len(cfg["views"]),)))
        views = rec + 0x3D + 2
        for i, v in enumerate(cfg["views"]):
            o.w(views + i * 0x22, struct.pack("<h", v))
        self.views = views
        o.view_index = lambda ptr, base=views: -1 if ptr == 0 else (ptr - base) // 0x22
        o.w(MOVIE_OBJ, b"\0" * 0x260)
        o.w(0x5C39F9, b"\0\0\0\0")
        o.w(SLOT_TABLE + SLOT * SLOT_STRIDE, struct.pack("<I", rec))
        o.w(SLOT_STATE + SLOT * SLOT_STRIDE, struct.pack("<I", 0))
        self.rec = rec

    def start(self):
        self.o.run(0x4BF9BB, [SLOT], MOVIE_OBJ)
        if self.o.u32(SLOT_STATE + SLOT * SLOT_STRIDE) != 1:
            raise RuntimeError("0x4bf9bb start failed")

    def poll(self):
        self.o.run(0x4C0C7D, [self.o.u32(MOVIE_OBJ + 0x1D6) + 0x3E], 0, worker=True)

    def tick(self, step):
        self.o.w(CURRENT_VIEW, struct.pack("<h", step.view))
        self.o.run(0x4BF9BB, [SLOT], MOVIE_OBJ)

    def ack(self):
        self.o.run(0x4C0D3F, [], MOVIE_OBJ)
        return int(any(t[0] == "blit" and t[1] == "sec movie surface" for t in self.o.trace))

    def stop(self):
        self.o.run(0x4BF773, [], MOVIE_OBJ)

    def state(self):
        o, b = self.o, MOVIE_OBJ
        return {
            "handshake": i32(o, b + 4), "ready": i16(o, b + 0x1D4), "index": i16(o, b + 0x1CA),
            "substate": i32(o, b + 0x1DA), "deadline": o.u32(b + 0x1C6),
            "presented": i16(o, b + 0x244), "done": i32(o, b + 0x21E),
            "finished": int(o.u32(SLOT_STATE + SLOT * SLOT_STRIDE) == 2),
            "dirty": i32(o, b + 0x216), "shown": i32(o, b + 0x240),
            "visible": i32(o, 0x5D19FB), "record": o.view_index(o.u32(b + 0x24A)),
            "matched": i32(o, b + 0x246), "flag21a": i32(o, b + 0x21A),
            "toggle": i16(o, b + 0x192),
            "flags": [o.u32(b + 0x18A) & 0xFFFF, o.u32(b + 0x18C) & 0xFFFF],
            "last_index": i32(o, b + 8 + 0x45), "delay": i32(o, b + 0x24),
            "surface": self.surface_digest(o.u32(b + 0x222), self.frame_bytes, b + 8),
        }

    def native_state(self, n):
        p, st = n.player, n.stream
        return {
            "handshake": p.handshake, "ready": p.ready, "index": p.index, "substate": p.substate,
            "deadline": p.deadline, "presented": p.presented, "done": p.done,
            "finished": p.finished, "dirty": p.dirty, "shown": p.shown, "visible": p.visible,
            "record": p.record, "matched": p.matched, "flag21a": p.flag21a,
            "toggle": st.toggle, "flags": [st.flags[0], st.flags[1]],
            "last_index": st.last_index, "delay": p.delay, "surface": n.selected_digest(),
        }

    def config(self):
        c_ = self.cfg
        return Config(1, c_["mode"], c_["first"], c_["last"], c_["direction"], 0, 0, 0, 0,
                      0, 0, 0, 0, 0)

    def presented_frame(self, st):
        return st["presented"]


class Partner(Controller):
    """CPartnerLogo with the animation on the MOVIE object's CChunk 0x637fd7."""
    kind = "partner"

    def __init__(self, o, data, cfg):
        super().__init__(o, data, cfg)
        o.watch_handshake(MOVIE_OBJ + 4)
        b = PARTNER_OBJ
        o.w(b, b"\0" * 0x200)
        o.w(MOVIE_OBJ, b"\0" * 0x260)
        o.w(b + 0xEE, struct.pack("<I", MOVIE_OBJ + 8))
        o.w(b + 0x90, b"fixture\0")
        o.w(b + 0xBD, b"NO SOUND\0" if not cfg["sound"] else b"fixture\0")
        o.w(b + 0xB1, struct.pack("<hhhh", 0, 0, 0, cfg["direction"]))   # +0xb1 +0xb3 +0xb5 +0xb7
        o.w(b + 0xDE, struct.pack("<h", cfg["sound_id"]))

    def start(self):
        o = self.o
        o.run(0x4DC182, [], PARTNER_OBJ)
        if o.u32(PARTNER_OBJ + 0x1C) != 1:
            raise RuntimeError("0x4dc182 case 0 failed")
        o.w(PARTNER_OBJ + 0x1C, struct.pack("<I", 2))    # case 1: music/sound setup (host)
        self.n_frames = struct.unpack_from("<h", self.data, 0x15)[0]

    def poll(self):
        self.o.run(0x4C0C7D, [self.o.u32(0x6381A5) + 0x3E], 0, worker=True)

    def tick(self, step):
        o = self.o
        o.sound_busy = step.sound_busy
        o.w(0x58321D, bytes((1 if step.skip else 0,)))
        o.run(0x4DC182, [], PARTNER_OBJ)

    def stop(self):
        self.o.run(0x4DC043, [], PARTNER_OBJ)

    def state(self):
        o, b, cc = self.o, PARTNER_OBJ, MOVIE_OBJ + 8
        return {
            "handshake": i32(o, MOVIE_OBJ + 4), "ready": i16(o, cc + 0x1CC),
            "index": i16(o, cc + 0x1C2), "substate": i32(o, 0x6381A9),
            "deadline": o.u32(cc + 0x1BE), "dirty": i32(o, 0x6381E5),
            "finished": int(o.u32(b + 0x1C) == 3), "toggle": i16(o, cc + 0x18A),
            "flags": [o.u32(cc + 0x182) & 0xFFFF, o.u32(cc + 0x184) & 0xFFFF],
            "last_index": i32(o, cc + 0x45), "delay": i32(o, cc + 0x1C),
            "started_at": o.u32(b + 0x20),
            "surface": self.surface_digest(o.u32(b + 0x4A), self.frame_bytes, cc),
        }

    def native_state(self, n):
        p, st = n.player, n.stream
        return {
            "handshake": p.handshake, "ready": p.ready, "index": p.index, "substate": p.substate,
            "deadline": p.deadline, "dirty": p.dirty, "finished": p.finished,
            "toggle": st.toggle, "flags": [st.flags[0], st.flags[1]],
            "last_index": st.last_index, "delay": p.delay, "started_at": p.started_at,
            "surface": n.selected_digest(),
        }

    def config(self):
        c_ = self.cfg
        return Config(2, 0, 0, self.n_frames - 1, c_["direction"], 0, c_["sound"],
                      c_["sound_id"], 0, 0, 0, 0, 0, 0)

    def presented_frame(self, st):
        return None


class Secondary(Controller):
    """Secondary video 0 (CChunk 0x5b4c3e, H 0x5b4c3a, worker 0x44cde2)."""
    kind = "secondary"

    def __init__(self, o, data, cfg):
        super().__init__(o, data, cfg)
        o.watch_handshake(0x5B4C3A)
        rec = o.alloc(0x200)
        o.w(rec, b"fixture\0" + b"\0" * (0x200 - 8))
        o.w(rec + 0x42, struct.pack("<hhhhhhhhhhh", 0, cfg["present_mode"], 1,
                                    cfg["start_mode"], 1, cfg["first"], cfg["loop_last"], 0,
                                    cfg["hold_last"], cfg["hold_start"], cfg["end_last"]))
        o.w(rec + 0x6D, struct.pack("<hh", 0, len(cfg["views"])))
        views = rec + 0x71
        for i, v in enumerate(cfg["views"]):
            o.w(views + i * 0x42, struct.pack("<h", v))
        for addr in (0x5B4E0C, 0x5C39F1, 0x5B4DB8, 0x5B4DBC, 0x617E9A, 0x5B5083, 0x6381A5):
            o.w(addr, b"\0\0\0\0")
        o.w(SLOT_TABLE + SLOT * SLOT_STRIDE, struct.pack("<I", rec))
        o.w(SLOT_STATE + SLOT * SLOT_STRIDE, struct.pack("<I", 0))
        o.w(0x5D03BF, b"\0" * 12)

    def start(self):
        self.o.run(0x42C221, [SLOT], 0)
        if self.o.u32(SLOT_STATE + SLOT * SLOT_STRIDE) != 1:
            raise RuntimeError("0x42c221 start failed")

    def poll(self):
        self.o.run(0x44CDE2, [self.o.u32(0x5B4E0C) + 0x3E], 0, worker=True)

    def tick(self, step):
        o = self.o
        o.w(CURRENT_VIEW, struct.pack("<h", step.view))
        o.w(0x5C39E5, struct.pack("<i", SLOT if step.slot_current else -1))
        o.run(0x42C221, [SLOT], 0)

    def set_mode(self, mode):
        self.o.w(0x5B4E14, struct.pack("<i", mode))      # 0x4f24d9

    def stop(self):
        self.o.run(0x44CB7D, [], 0)

    def slot_digests(self, sizes):
        o = self.o
        out = []
        for k in range(2):
            ptr = o.u32(0x5B4DB8 + 4 * k)
            out.append(dec.digest(o.r(ptr, sizes[k])) if ptr and sizes[k] else None)
        return out

    def state(self):
        o = self.o
        surface = o.u32(0x5D03BF)
        shown = None
        if surface and o.u32(surface):
            ptr = o.u32(surface)
            size = self.result_sizes[i16(o, 0x5B4DC8)] if hasattr(self, "result_sizes") else 0
            shown = dec.digest(o.r(ptr, size)) if size else None
        return {
            "handshake": i32(o, 0x5B4C3A), "ready": i16(o, 0x5B4E0A), "index": i16(o, 0x5B4E00),
            "substate": i32(o, 0x5B4E10), "deadline": o.u32(0x5B4DFC),
            "secondary_mode": i32(o, 0x5B4E14), "slot_toggle": i16(o, 0x5B4DC8),
            "last_index": i32(o, 0x5B4C3E + 0x45), "delay": i32(o, 0x5B4C3E + 0x1C),
            "slots": self.slot_digests(getattr(self, "result_sizes", [0, 0])),
            "surface": shown if self.cfg["present_mode"] == 2 else None,
        }

    def native_state(self, n):
        p = n.player
        self.result_sizes = [p.slot_result_bytes[0], p.slot_result_bytes[1]]
        slots = []
        for k in range(2):
            ptr, size = p.slot_result[k], p.slot_result_bytes[k]
            slots.append(dec.digest(bytes((c.c_uint8 * size).from_address(ptr)))
                         if ptr and size else None)
        return {
            "handshake": p.handshake, "ready": p.ready, "index": p.index, "substate": p.substate,
            "deadline": p.deadline, "secondary_mode": p.secondary_mode,
            "slot_toggle": p.slot_toggle, "last_index": n.stream.last_index, "delay": p.delay,
            "slots": slots,
            "surface": n.selected_digest() if self.cfg["present_mode"] == 2 else None,
        }

    def config(self):
        c_ = self.cfg
        return Config(3, 0, c_["first"], 0, 0, 0, 0, 0, c_["start_mode"], c_["loop_last"],
                      c_["hold_last"], c_["hold_start"], c_["end_last"], c_["present_mode"])

    def presented_frame(self, st):
        return None


CONTROLLERS = {"random": RandomMovie, "movie": Movie, "partner": Partner,
               "secondary": Secondary}


class Runner:
    def __init__(self, exe: Path, lib: c.CDLL) -> None:
        self.exe = exe
        self.lib = lib
        self.compared = 0
        self.mismatches: list[dict[str, Any]] = []
        self.counts: dict[str, int] = {}
        self.playback: list[dict[str, Any]] = []

    def count(self, key: str, n: int = 1) -> None:
        self.counts[key] = self.counts.get(key, 0) + n

    def compare(self, where: str, original: dict, native: dict) -> None:
        self.compared += 1
        diffs = {k: [original[k], native.get(k)] for k in original if original[k] != native.get(k)}
        if diffs:
            self.mismatches.append({"where": where, "diffs": {k: [str(v)[:120] for v in d]
                                                              for k, d in diffs.items()}})

    def case(self, kind: str, name: str, data: bytes, cfg: dict[str, Any],
             steps: list[Step], record: bool = False) -> dict[str, Any]:
        o = PlayerOriginal(self.exe)
        ctrl = CONTROLLERS[kind](o, data, cfg)
        mode = cfg.get("mode", 0) if kind in ("random", "movie") else 0
        surface_bytes = ctrl.frame_bytes if kind == "random" else 0
        n = NativeSession(self.lib, data, mode, surface_bytes, slots=(kind == "secondary"))
        o.now = n.now = steps[0].now if steps else 0
        ctrl.start()
        config = ctrl.config()
        slot0 = n.slot_buffers[0] if n.slot_buffers else None
        slot1 = n.slot_buffers[1] if n.slot_buffers else None
        status = self.lib.avf_player_start(c.byref(n.player), c.byref(config), c.byref(n.stream),
                                           slot0, slot1, n.slot_bytes if slot0 else 0,
                                           c.byref(n.host))
        log = {"decoded": [], "presented": [], "surfaces": []}
        self.after(f"{kind}:{name}:start", ctrl, n, status)
        for i, step in enumerate(steps):
            where = f"{kind}:{name}:{i}:{step.op}"
            o.now = n.now = step.now
            extra = {}
            fatal = None
            if step.op == "poll" and kind == "secondary" and n.player.ready == 0 and \
                    self.empty_record(n, n.player.index):
                # Original GetChunk returns the shown predecessor, and the next
                # refill frees it while on screen: native rejects the path.
                status = self.lib.avf_player_worker_poll(c.byref(n.player), None)
                self.compare(where, {"status": "UNSUPPORTED"},
                             {"status": self.lib.avf_player_status_name(status).decode()})
                self.count("secondary:empty_record_unsupported")
                break
            if step.op == "poll":
                index = n.player.index
                try:
                    ctrl.poll()
                except dec.Fatal as exc:      # original report + quit (decoder error)
                    fatal = str(exc)
                decoded = c.c_int(0)
                status = self.lib.avf_player_worker_poll(c.byref(n.player), c.byref(decoded))
                if decoded.value:
                    log["decoded"].append(index)
            elif step.op == "tick":
                ids = cfg["views"]
                matches = [k for k, v in enumerate(ids) if v == step.view]
                gate, keep = gate_struct(matches, step.sound_busy, step.skip, step.slot_current)
                before = (n.player.presented, n.selected, bytes(n.surface[:8]))
                ctrl.tick(step)
                status = self.lib.avf_player_tick(c.byref(n.player), c.byref(gate))
                after = (n.player.presented, n.selected, bytes(n.surface[:8]))
                if record and after != before:
                    log["presented"].append(int(n.player.index))
            elif step.op == "ack":
                extra["blitted"] = ctrl.ack()
                blitted = c.c_int(0)
                status = self.lib.avf_player_render_ack(c.byref(n.player), n.player.generation,
                                                        c.byref(blitted))
                extra["native_blitted"] = blitted.value
            elif step.op == "stop":
                ctrl.stop()
                status = self.lib.avf_player_stop(c.byref(n.player))
            elif step.op == "restart":
                ctrl.restart()
                status = self.lib.avf_player_restart(c.byref(n.player), c.byref(config))
            elif step.op == "mode":
                ctrl.set_mode(step.arg)
                status = self.lib.avf_player_set_secondary_mode(c.byref(n.player), step.arg)
            self.after(where, ctrl, n, status, extra, fatal)
            self.count(f"{kind}:{step.op}")
            if fatal:
                self.count(f"{kind}:fatal_vs_{self.lib.avf_player_status_name(status).decode()}")
                break
            if n.player.finished and step.op == "tick":
                self.count(f"{kind}:finished")
                break
        return log

    def empty_record(self, n: NativeSession, index: int) -> bool:
        record = fx.AvfRecord()
        if self.lib.avf_record(c.byref(n.file), index, c.byref(record)) != fx.OK:
            return False
        return record.packed_bytes == 0 and record.unpacked_bytes == 0

    def after(self, where: str, ctrl: Controller, n: NativeSession, status: int,
              extra: dict | None = None, fatal: str | None = None) -> None:
        o = ctrl.o
        if fatal:
            # The original reports and quits; only the classification is compared.
            o.trace.clear()
            n.trace.clear()
            self.compare(where, {"status": "DECODER"},
                         {"status": self.lib.avf_player_status_name(status).decode()})
            return
        nat = ctrl.native_state(n)
        original = ctrl.state()
        original["status"] = "OK"
        original["trace"] = normalize_trace(o.trace, ctrl.kind)
        original["clock_used"] = o.clock_used
        nat["status"] = self.lib.avf_player_status_name(status).decode()
        nat["trace"] = list(n.trace)
        nat["clock_used"] = n.clock_used
        if extra and "blitted" in extra:
            original["blitted"] = extra["blitted"]
            nat["blitted"] = extra["native_blitted"]
        if where.endswith(":stop"):
            # Deliberate lifetime divergence: the original frees the frame
            # buffers (the surface keeps a dangling pointer); the kernel
            # leaves caller-owned buffers valid for an in-flight frame.
            original.pop("surface", None)
            nat.pop("surface", None)
            self.count("stop_surface_lifetime_divergence")
        o.trace.clear()
        n.trace.clear()
        self.compare(where, original, nat)


# -- scenarios ------------------------------------------------------------------------
DELAY = 66


def nominal(kind: str, frames: int, t0: int, delay: int, view: int = 1,
            extra_advances: int = 2) -> list[Step]:
    """Worker keeps up; each frame is probed just before, at and after its
    deadline. MOVIE renders after every tick, as the game's main loop does
    (a tick clears the dirty flag, so the render ack must follow it)."""
    def tick(now: int) -> list[Step]:
        out = [Step("tick", now, view)]
        if kind == "movie":
            out.append(Step("ack", now))
        return out
    steps = [Step("poll", t0)] + tick(t0)
    t = t0
    for _ in range(frames + extra_advances):
        steps.append(Step("poll", t))
        steps += tick(t + delay - 1)
        t += delay
        steps += tick(t)
        steps += tick(t + 1)
    steps.append(Step("stop", t + 2))
    return steps


def randomized(kind: str, seed: int, length: int, t0: int, delay: int,
               views: list[int]) -> list[Step]:
    """Seeded interleavings: slow worker/consumer, duplicate polls, gate flips,
    boundary times, missing render acks, sound/skip and mode changes."""
    import random
    rng = random.Random(seed)
    t = t0
    steps = []
    other_view = max(views) + 5
    for _ in range(length):
        r = rng.random()
        t += rng.choice([0, 0, 1, delay - 1, delay, delay + 1, 2 * delay])
        if r < 0.35:
            steps.append(Step("poll", t))
        elif r < 0.85 or kind not in ("movie", "secondary"):
            view = rng.choice(views) if rng.random() < 0.8 else other_view
            steps.append(Step("tick", t, view, sound_busy=int(rng.random() < 0.3),
                              skip=int(rng.random() < 0.03), slot_current=int(rng.random() < 0.7)))
        elif kind == "movie":
            steps.append(Step("ack", t))
        else:
            steps.append(Step("mode", t, arg=rng.choice([0, 1, 2, 3])))
    steps.append(Step("stop", t + 1))
    return steps


def make_avf(width: int, height: int, n: int, kinds: str = "key") -> bytes:
    frames = []
    for k in range(n):
        if kinds == "key" or k == 0:
            frames.append((0, fx.frame_pixels(width, height, k), None))
        elif kinds == "chain":
            frames.append((2, fx.cmd_fill(0x300 + k, k % (width * height), 3), None))
        elif kinds == "delta":
            frames.append((2, fx.cmd_fill(0x100 + k, k % (width * height), 2), None) if k % 3
                          else (2, None, None))
        else:
            frames.append((1, fx.cmd_fill(0x200 + k, 0, width * height) +
                           fx.cmd_copy(k % (width * height), [k]), None))
    return fx.build_avf(width, height, frames)


def base_cfg(kind: str, n: int, **kw) -> dict[str, Any]:
    cfg = {"mode": 1, "first": 0, "last": n - 1, "direction": 1, "views": [7, 1, 9],
           "sound": 0, "sound_id": 0, "start_mode": 1, "loop_last": n - 1, "hold_last": n - 1,
           "hold_start": 0, "end_last": n - 1, "present_mode": 2}
    if kind == "partner":
        cfg["mode"] = 0
    cfg.update(kw)
    return cfg


def synthetic_cases() -> list[tuple[str, str, bytes, dict, list[Step]]]:
    cases = []
    key = make_avf(4, 2, 5)
    delta = make_avf(4, 2, 7, "delta")
    full = make_avf(4, 2, 4, "full")
    chain = make_avf(4, 2, 6, "chain")
    wrap = 0xFFFFFFFF - 2 * DELAY
    for kind in ("random", "movie", "partner", "secondary"):
        modes = [0, 1] if kind in ("random", "movie") else [0]
        for mode in modes:
            for label, data in (("key", key), ("delta", delta), ("full", full),
                                ("chain", chain)):
                n = struct.unpack_from("<h", data, 0x15)[0]
                cfg = base_cfg(kind, n, mode=mode) if kind != "partner" else base_cfg(kind, n)
                cases.append((kind, f"nominal-{label}-m{mode}", data, cfg,
                              nominal(kind, n, 1000, DELAY)))
                cases.append((kind, f"wrap-{label}-m{mode}", data, cfg,
                              nominal(kind, n, wrap, DELAY)))
                for seed in range(6):
                    cases.append((kind, f"random{seed}-{label}-m{mode}", data, cfg,
                                  randomized(kind, seed * 17 + mode, 60, 5000, DELAY,
                                             cfg["views"])))
    # Reverse play, single frame, gate never true, duplicate view records.
    n = 5
    cases.append(("movie", "reverse", key, base_cfg("movie", n, direction=2),
                  nominal("movie", n, 1000, DELAY)))
    cases.append(("movie", "one-frame", key, base_cfg("movie", n, first=2, last=2),
                  nominal("movie", 1, 1000, DELAY, extra_advances=3)))
    cases.append(("movie", "two-matches", key, base_cfg("movie", n, views=[1, 4, 1]),
                  randomized("movie", 99, 50, 2000, DELAY, [1, 4])))
    cases.append(("random", "hidden", key, base_cfg("random", n),
                  nominal("random", n, 1000, DELAY, view=3)))
    cases.append(("random", "one-frame", key, base_cfg("random", n, first=3, last=3),
                  nominal("random", 1, 1000, DELAY)))
    cases.append(("random", "restart", key, base_cfg("random", n),
                  nominal("random", 2, 1000, DELAY)[:-1] +
                  [Step("stop", 1500), Step("restart", 1500), Step("poll", 1500),
                   Step("tick", 1500), Step("poll", 1600), Step("tick", 1600),
                   Step("stop", 1700)]))
    cases.append(("partner", "reverse-sound", key, base_cfg("partner", n, direction=2, sound=1,
                                                            sound_id=12),
                  randomized("partner", 5, 70, 3000, DELAY, [1])))
    cases.append(("partner", "sound-busy", key, base_cfg("partner", n, sound=1, sound_id=3),
                  [s if s.op != "tick" else Step("tick", s.now, s.view, sound_busy=1)
                   for s in nominal("partner", n, 1000, DELAY, extra_advances=4)]))
    for start_mode, present_mode in ((1, 2), (2, 2), (1, 0)):
        cfg = base_cfg("secondary", n, start_mode=start_mode, present_mode=present_mode,
                       hold_start=2, loop_last=3, hold_last=3, end_last=4)
        cases.append(("secondary", f"modes-s{start_mode}-p{present_mode}", key, cfg,
                      randomized("secondary", start_mode * 7 + present_mode, 80, 4000, DELAY,
                                 cfg["views"])))
    return cases


def corpus_cases() -> list[tuple[str, str, bytes, dict, list[Step]]]:
    cases = []
    for path in dec.corpus_files():
        data = path.read_bytes()
        n = struct.unpack_from("<h", data, 0x15)[0]
        steps_fwd = lambda kind: nominal(kind, n, 10_000, DELAY)
        cases.append(("random", path.name, data, base_cfg("random", n, mode=1),
                      steps_fwd("random")))
        cases.append(("movie", path.name + ":fwd-single", data, base_cfg("movie", n, mode=0),
                      steps_fwd("movie")))
        cases.append(("movie", path.name + ":rev-double", data,
                      base_cfg("movie", n, mode=1, direction=2), steps_fwd("movie")))
        cases.append(("partner", path.name, data, base_cfg("partner", n), steps_fwd("partner")))
        cases.append(("secondary", path.name, data,
                      base_cfg("secondary", n, start_mode=1, present_mode=2), steps_fwd("secondary")))
    return cases


def expected_digests(lib: c.CDLL, data: bytes) -> dict[int, str]:
    """Frame digests from the pinned S03-1 decoder (sequential single mode)."""
    n = NativeSession(lib, data, 0)
    out = {}
    for k in range(n.file.frame_count):
        if lib.avf_decode_single(c.byref(n.stream), k, None) == fx.OK:
            out[k] = dec.digest(bytes(n.buffers[0]))
    return out


MUTATIONS = {
    # timing: advance one tick early / wrong delay / clock sampled once per advance
    "deadline_inclusive": ("if (p->substate != 4 || now(p) < p->deadline) {\n        return AVF_PLAYER_OK;\n    }\n    if (p->done != 0) {\n        p->finished = 1;                        /* +0x1de = 3 */",
                           "if (p->substate != 4 || now(p) <= p->deadline) {\n        return AVF_PLAYER_OK;\n    }\n    if (p->done != 0) {\n        p->finished = 1;                        /* +0x1de = 3 */"),
    "delay_plus_one": ("return now(p) + (uint32_t)p->delay;", "return now(p) + (uint32_t)p->delay + 1u;"),
    # buffer / handshake rules
    "random_ack_on_done": ("        if (p->done == 0) {\n            p->ready = 0;\n        }\n        p->substate = 4;",
                           "        p->ready = 0;\n        p->substate = 4;"),
    "movie_ack_ignores_done": ("        if (player->done == 0) {\n            player->ready = 0;\n        }",
                               "        player->ready = 0;"),
    "movie_tick_keeps_dirty": ("    p->dirty = 0;                               /* +0x216 */", "    (void)0;"),
    "worker_ignores_ready": ("if (player->ready != 0 || acquire(player) == 2) {", "if (acquire(player) == 2) {"),
    "partner_ignores_sound": ("(p->config.sound == 0 || g->sound_busy == 0)", "(1)"),
    "secondary_swap_order": ("    p->slot_toggle = (int16_t)(p->slot_toggle == 0);\n    if (p->config.present_mode == 2) {",
                             "    if (p->config.present_mode == 2) {"),
    "random_toggle_reset_on_restart": ("    begin_stream(player, 1);    /* toggle survives", "    begin_stream(player, 0);    /* toggle survives"),
}


def run_mutations(args: argparse.Namespace) -> dict[str, Any]:
    source = (PROJECT / "src/avf_player.c").read_text()
    tmp = Path(tempfile.mkdtemp(prefix="avf-player-mut-"))
    results = {}
    for name, (old, new) in MUTATIONS.items():
        if source.count(old) != 1:
            results[name] = "pattern not found"
            continue
        path = tmp / f"{name}.c"
        path.write_text(source.replace(old, new))
        lib_path = tmp / f"lib_{name}.dylib"
        subprocess.run(["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64", "-std=c11", "-O2",
                        "-w", "-dynamiclib", "-I", str(PROJECT / "src"), str(path),
                        str(PROJECT / "src/avf_decoder.c"), "-o", str(lib_path)],
                       check=True, capture_output=True)
        sub = argparse.Namespace(**{**vars(args), "native_library": str(lib_path),
                                    "synthetic_only": True, "limit": 0, "mutations": False})
        results[name] = run(sub)["mismatch_count"]
        print(f"mutation {name}: {results[name]}", flush=True)
    return results


def playback_evidence(lib: c.CDLL, kind: str, name: str, data: bytes, cfg: dict[str, Any],
                      steps: list[Step], expected: dict[int, str]) -> dict[str, Any]:
    """Native decoder-backed playback: every decoded, requested and presented
    frame, with presented pixels checked against the pinned S03-1 decoder."""
    w, h = struct.unpack_from("<hh", data, 0x17)
    fb = w * h * 2
    mode = cfg["mode"] if kind in ("random", "movie") else 0
    n = NativeSession(lib, data, mode, fb if kind == "random" else 0, slots=(kind == "secondary"))
    shown_log: list[tuple[int, str]] = []
    claimed = {"frame": None}
    original_present = n._present

    def present(ctx, ptr):
        claimed["frame"] = Presentation.from_address(ptr).frame_index
        return original_present(ctx, ptr)
    n.host.present = PRESENT(present)
    config = CONTROLLERS[kind].config(type("C", (), {"cfg": cfg, "frame_bytes": fb,
                                                    "n_frames": struct.unpack_from("<h", data, 0x15)[0]})())
    slot0 = n.slot_buffers[0] if n.slot_buffers else None
    slot1 = n.slot_buffers[1] if n.slot_buffers else None
    n.now = steps[0].now
    lib.avf_player_start(c.byref(n.player), c.byref(config), c.byref(n.stream), slot0, slot1,
                         n.slot_bytes if slot0 else 0, c.byref(n.host))
    decoded, requested, presented, problems = [], [], [], []
    for step in steps:
        n.now = step.now
        if step.op == "poll":
            requested.append(int(n.player.index))
            flag = c.c_int(0)
            lib.avf_player_worker_poll(c.byref(n.player), c.byref(flag))
            if flag.value:
                decoded.append(int(n.player.index) if kind != "secondary" else requested[-1])
        elif step.op == "tick":
            g, keep = gate_struct([k for k, v in enumerate(cfg["views"]) if v == step.view])
            claimed["frame"] = None
            before_trace = len(n.trace)
            lib.avf_player_tick(c.byref(n.player), c.byref(g))
            events = n.trace[before_trace:]
            frame = claimed["frame"]
            if kind == "random" and frame is not None:
                pixels = dec.digest(bytes(n.surface[:fb]))
            elif kind in ("movie", "partner") and (frame is not None or any(
                    t[0] in ("rect", "blit") for t in events)):
                # MOVIE presents with a RECT event (its completion only fires
                # TRIGGERS); PARTNER single-buffer frames show on BLIT.
                if frame is None:      # single buffer: the decoder writes the shown surface
                    frame = n.stream.last_index
                pixels = n.selected_digest()
            elif kind == "secondary" and frame is not None:
                pixels = dec.digest(bytes((c.c_uint8 * fb).from_address(n.selected[0])))
            else:
                continue
            presented.append(int(frame))
            if expected.get(int(frame)) != pixels:
                problems.append(int(frame))
        elif step.op == "ack":
            blitted = c.c_int(0)
            lib.avf_player_render_ack(c.byref(n.player), n.player.generation, c.byref(blitted))
        elif step.op == "stop":
            lib.avf_player_stop(c.byref(n.player))
        if n.player.finished:
            break
    frames = struct.unpack_from("<h", data, 0x15)[0]
    return {"kind": kind, "case": name, "frames": frames, "decoded": len(decoded),
            "requested": len(requested), "presented": len(presented),
            "presented_distinct": len(set(presented)), "finished": bool(n.player.finished),
            "pixel_mismatches": problems[:10], "presented_head": presented[:8],
            "presented_tail": presented[-4:]}


def run(args: argparse.Namespace) -> dict[str, Any]:
    started = time.time()
    lib = bind_player(Path(args.native_library))
    runner = Runner(Path(args.exe), lib)
    groups: dict[str, int] = {}
    cases = synthetic_cases()
    if not args.synthetic_only:
        cases += corpus_cases()
    if args.limit:
        cases = cases[: args.limit]
    for kind, name, data, cfg, steps in cases:
        before = runner.compared
        group = "corpus" if name.split(":")[0].endswith(".avf") else "synthetic"
        try:
            runner.case(kind, name, data, cfg, steps)
        except Exception as exc:          # an oracle failure is a reported mismatch
            runner.mismatches.append({"where": f"{kind}:{name}", "error": repr(exc)[:300]})
        groups[f"{group}:{kind}"] = groups.get(f"{group}:{kind}", 0) + 1
        runner.count(f"compared:{group}:{kind}", runner.compared - before)
    evidence = []
    if not args.synthetic_only and not args.limit:
        for kind, name, data, cfg, steps in corpus_cases():
            expected = expected_digests(lib, data)
            evidence.append(playback_evidence(lib, kind, name, data, cfg, steps, expected))
    pe = PEImage.parse_and_map(Path(args.exe))
    lib_path = Path(args.native_library)

    def window(a: int, b: int) -> str:
        return hashlib.sha256(pe.image[a - pe.image_base:b - pe.image_base]).hexdigest()

    playback_summary = {
        "playbacks": len(evidence),
        "pixel_mismatches": sum(len(e["pixel_mismatches"]) for e in evidence),
        "decoded": sum(e["decoded"] for e in evidence),
        "requested": sum(e["requested"] for e in evidence),
        "presented": sum(e["presented"] for e in evidence),
    }
    report = {
        "slice": "S03-2",
        "original_exe_sha256": sha256(pe.data),
        "code_windows": {k: {"range": [hex(a), hex(b)], "sha256": window(a, b)}
                         for k, (a, b) in CODE_WINDOWS.items()},
        "native_library": str(lib_path),
        "native_library_sha256": sha256(lib_path.read_bytes()),
        "native_source_sha256": {f: sha256((PROJECT / f).read_bytes()) for f in
                                 ("src/avf_player.c", "src/avf_player.h", "src/avf_decoder.c",
                                  "src/avf_decoder.h")},
        "oracle_sha256": sha256(Path(__file__).read_bytes()),
        "tests_sha256": sha256((PROJECT / "tests/test_avf_player.py").read_bytes()),
        "corpus_files": [{"file": f.name, "sha256": sha256(f.read_bytes())}
                         for f in dec.corpus_files()] if not args.synthetic_only else [],
        "evidence_classes": {
            "original_trace": "native kernel vs unmodified original controller/worker/stop code: "
                              "state fields, ordered handshake/frame-event trace, clock samples, "
                              "presented surface after every operation",
            "decoder_backed_playback": "native kernel + pinned S03-1 decoder over every installed "
                                       "file: every decoded/requested/presented frame, presented "
                                       "pixels vs independent S03-1 decode of the claimed frame",
        },
        "corpus_playback_summary": playback_summary,
        "corpus_playback": evidence,
        "cases": len(cases),
        "case_groups": dict(sorted(groups.items())),
        "compared_steps": runner.compared,
        "counts": dict(sorted(runner.counts.items())),
        "mismatch_count": len(runner.mismatches),
        "mismatches": runner.mismatches[:40],
        "elapsed_seconds": round(time.time() - started, 1),
    }
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--exe", default=str(DEFAULT_EXE))
    parser.add_argument("--native-library", default=str(PROJECT / "build/libavfplayer.dylib"))
    parser.add_argument("--report", default=str(DEFAULT_REPORT))
    parser.add_argument("--synthetic-only", action="store_true")
    parser.add_argument("--limit", type=int, default=0)
    parser.add_argument("--no-write", action="store_true")
    parser.add_argument("--mutations", action="store_true")
    args = parser.parse_args()
    report = run(args)
    if args.mutations:
        report["mutations"] = run_mutations(args)
    if not args.no_write:
        Path(args.report).write_text(json.dumps(report, indent=1, default=str) + "\n")
    print(json.dumps({k: report[k] for k in ("cases", "compared_steps", "mismatch_count",
                                              "elapsed_seconds")}))
    for m in report["mismatches"][:8]:
        print(json.dumps(m)[:600])
    return 0 if report["mismatch_count"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
