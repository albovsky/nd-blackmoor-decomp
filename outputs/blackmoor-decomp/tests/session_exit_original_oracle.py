#!/usr/bin/env python3
"""RT-5 oracle: native scene-exit path vs the unmodified original x86.

Runs the real GAME.EXE routines in Unicorn: the exit handler 0x43d227 (with its
SEH prologue and the stack probe 0x50c920), the CSpecialEffect gate 0x447c36,
the stage switch 0x4473be with 0x447418 / 0x4474cf and the whole frame loop
0x44753b (x87 curve, GetTickCount arithmetic, per-frame ordering), plus the
ClearSceneData code windows 0x43e1bd..0x43e22b (caption block) and
0x43e3d5..0x43e433 (input-latch block).

Host hooks (every one enumerated; none replaces a decision the original makes):
  0x43a7ca   nested state-3 tick (recorded, skipped)
  0x447ac7   DirectDraw surface capture (recorded with its destination buffer,
             skipped; `ret 8`)
  0x4477d1   per-frame blend and present (recorded, skipped; `ret 0x14`)
  0x4f52a9   DirectSound/system pump (recorded, skipped)
  GetTickCount IAT slot 0x52a23c -> trampoline returning a scripted tick
  0x4de2d8   frame text box close (recorded, skipped; caption window only)
Observation-only code hooks (no state change): 0x447495 (the clear of the
destination capture), 0x44753b entry (subtype/stage/state), 0x447cc0 (gate
return value).

Every step compares the ordered effect list, the gate return value and the
full set of globals and object fields the routines touch.

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/session_exit_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import json
import random
import struct
import sys
from pathlib import Path
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up, sha256
import session_exit_support as s
import test_caption_layout as layout
import test_caption_lifecycle as life_tests
import test_action_family_28_sequence as seq

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-5-exit-original-oracle.json"

STACK, STACK_SIZE = 0x10000000, 0x40000
FIXTURE, FIXTURE_SIZE = 0x20000000, 0x10000
END = 0x31000000
IAT_GET_TICK = 0x52A23C
HOOK_TICK = END + 0x100
OBJ = 0x6198D7
SRC_BUF, DST_BUF = FIXTURE + 0x1000, FIXTURE + 0x2000
BACK_BUFFER = FIXTURE + 0x3000      # value of DAT_005cf665 (opaque to the code)

G_STATE, G_LOAD, G_POPUP = 0x583999, 0x5BB22A, 0x55CD94
G_MODAL, G_RENDER_LEVEL, G_CURSOR_LAYER = 0x5839A9, 0x5BB1C4, 0x5D1639
G_REDRAW, G_REDRAW_COUNTER = 0x5831C8, 0x5831C6
G_DEBUG = 0x63A4CD

HOOKS = {
    0x43A7CA: ("nested", 0), 0x447AC7: ("capture", 8), 0x4477D1: ("blend", 0x14),
    0x4F52A9: ("pump", 0), 0x4DE2D8: ("close_text", 0),
}


class OracleFailure(RuntimeError):
    pass


def r32(uc: Any, va: int) -> int:
    return struct.unpack("<I", uc.mem_read(va, 4))[0]


def r16(uc: Any, va: int) -> int:
    return struct.unpack("<H", uc.mem_read(va, 2))[0]


class OriginalExit:
    def __init__(self, pe: PEImage):
        from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        from unicorn.x86_const import (UC_X86_REG_EAX, UC_X86_REG_EBP, UC_X86_REG_ECX,
                                       UC_X86_REG_EFLAGS, UC_X86_REG_EIP, UC_X86_REG_ESP)
        self.R = dict(eax=UC_X86_REG_EAX, ebp=UC_X86_REG_EBP, ecx=UC_X86_REG_ECX,
                      eflags=UC_X86_REG_EFLAGS, eip=UC_X86_REG_EIP, esp=UC_X86_REG_ESP)
        self.uc = uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        uc.mem_write(pe.image_base, pe.image)
        uc.mem_map(STACK, STACK_SIZE)
        uc.mem_map(FIXTURE, FIXTURE_SIZE)
        uc.mem_map(END, 0x1000)
        uc.mem_map(0, 0x1000)       # fs:[0] (SEH chain head) resolves to linear 0
        uc.mem_write(IAT_GET_TICK, struct.pack("<I", HOOK_TICK))
        for va in (*HOOKS, HOOK_TICK, 0x447495, 0x44753B, 0x447CC0):
            uc.hook_add(UC_HOOK_CODE, self._hook, begin=va, end=va)
        self.events: list[tuple] = []
        self.ticks: list[int] = [0]
        self.tick_index = 0
        self.blend_index = 0
        self.pump_index = 0
        self.ran: int | None = None
        self.hook_names: set[str] = set()

    # --- hooks ------------------------------------------------------------
    def _skip(self, esp: int, pop: int) -> None:
        uc = self.uc
        uc.reg_write(self.R["eip"], r32(uc, esp))
        uc.reg_write(self.R["esp"], esp + 4 + pop)

    def _hook(self, uc: Any, addr: int, _size: int, _user: Any) -> None:
        esp = uc.reg_read(self.R["esp"])
        if addr == HOOK_TICK:
            value = self.ticks[min(self.tick_index, len(self.ticks) - 1)]
            self.events.append(("seq", "tick", self.tick_index))
            self.tick_index += 1
            uc.reg_write(self.R["eax"], value)
            self.hook_names.add("GetTickCount")
            self._skip(esp, 0)
        elif addr == 0x447495:
            self.events.append(("clear_destination",))
        elif addr == 0x44753B:
            # The scripted tick list restarts for every sequence run (the native
            # test host builds a fresh script per run_sequence call).
            self.tick_index = self.blend_index = self.pump_index = 0
            ecx = uc.reg_read(self.R["ecx"])
            self.events.append(("run_sequence", uc.mem_read(ecx + 0x49, 1)[0],
                                r32(uc, ecx + 0x2D), r32(uc, G_STATE)))
        elif addr == 0x447CC0:
            self.ran = uc.reg_read(self.R["eax"]) & 0xFFFFFFFF
        else:
            name, pop = HOOKS[addr]
            self.hook_names.add(f"0x{addr:06x}")
            if name == "nested":
                self.events.append(("nested_tick", r32(uc, G_STATE)))
            elif name == "capture":
                buffer = r32(uc, esp + 8)
                which = s.CAPTURE_SOURCE if buffer == r32(uc, OBJ + 0x31) \
                    else s.CAPTURE_DESTINATION
                if buffer not in (r32(uc, OBJ + 0x31), r32(uc, OBJ + 0x35)):
                    raise OracleFailure("capture into an unknown buffer")
                self.events.append(("capture", which, r32(uc, G_STATE)))
            elif name == "blend":
                self.events.append(("seq", "blend", self.blend_index))
                self.blend_index += 1
            elif name == "pump":
                self.events.append(("seq", "pump", self.pump_index))
                self.pump_index += 1
            elif name == "close_text":
                self.events.append(("close_text",))
            self._skip(esp, pop)

    # --- fixture ------------------------------------------------------------
    def setup(self, case: dict[str, Any]) -> None:
        uc = self.uc
        self.events, self.ran = [], None
        self.tick_index = self.blend_index = self.pump_index = 0
        self.ticks = list(case["ticks"])
        uc.mem_write(G_DEBUG, b"\0\0")
        uc.mem_write(0x5CF665, struct.pack("<I", BACK_BUFFER))
        uc.mem_write(0x583186, struct.pack("<4i", *s.VIEW))
        uc.mem_write(OBJ, bytes(0x80))
        uc.mem_write(OBJ + 0x1C, bytes([case["busy"]]))
        uc.mem_write(OBJ + 0x1D, struct.pack("<4i", *case["rect"]))
        uc.mem_write(OBJ + 0x2D, struct.pack("<I", case["stage"]))
        uc.mem_write(OBJ + 0x31, struct.pack("<II", SRC_BUF, DST_BUF))
        uc.mem_write(OBJ + 0x39, struct.pack("<IIII", s.CANVAS_W * s.CANVAS_H,
                                             s.CANVAS_W, s.CANVAS_H, s.CANVAS_W * 2))
        uc.mem_write(OBJ + 0x49, s.payload(case["kind"], case["budget"], case["pause"]))
        uc.mem_write(DST_BUF, b"\xAA" * 64)
        uc.mem_write(SRC_BUF, b"\xBB" * 64)
        uc.mem_write(G_STATE, struct.pack("<I", case["state"]))
        uc.mem_write(G_LOAD, struct.pack("<I", case.get("load_game", 0)))
        uc.mem_write(G_POPUP, struct.pack("<I", case.get("popup", 1)))
        uc.mem_write(G_MODAL, struct.pack("<I", case.get("modal", 0)))
        uc.mem_write(G_RENDER_LEVEL, struct.pack("<H", 0))
        uc.mem_write(G_CURSOR_LAYER, struct.pack("<I", case.get("cursor_layer", 0)))
        uc.mem_write(G_REDRAW, struct.pack("<I", 0))
        uc.mem_write(G_REDRAW_COUNTER, struct.pack("<H", 7))

    def call(self, va: int, this: int = 0) -> None:
        uc = self.uc
        sp = STACK + STACK_SIZE - 0x100
        uc.mem_write(sp, struct.pack("<I", END))
        uc.mem_write(0, b"\0" * 4)         # empty SEH chain
        uc.reg_write(self.R["esp"], sp)
        uc.reg_write(self.R["ebp"], 0)
        uc.reg_write(self.R["ecx"], this)
        uc.reg_write(self.R["eflags"], 0x202)
        try:
            uc.emu_start(va, END, timeout=20_000_000, count=5_000_000)
        except Exception as exc:  # noqa: BLE001
            raise OracleFailure(f"GAME.EXE trapped at 0x{va:08x}: {exc}") from exc
        if uc.reg_read(self.R["eip"]) != END:
            raise OracleFailure(f"call 0x{va:08x} did not return")

    def snapshot(self) -> dict[str, Any]:
        uc = self.uc
        return {
            "state": r32(uc, G_STATE), "busy": uc.mem_read(OBJ + 0x1C, 1)[0],
            "rect": list(struct.unpack("<4i", uc.mem_read(OBJ + 0x1D, 16))),
            "stage": r32(uc, OBJ + 0x2D),
            "payload": bytes(uc.mem_read(OBJ + 0x49, 21)).hex(),
            "modal": r32(uc, G_MODAL), "render_level": r16(uc, G_RENDER_LEVEL),
            "cursor_layer": r32(uc, G_CURSOR_LAYER), "redraw": r32(uc, G_REDRAW),
            "redraw_counter": r16(uc, G_REDRAW_COUNTER),
            "dst_zeroed": bytes(uc.mem_read(DST_BUF, 24)) == bytes(24),
        }

    def step(self, name: str, arg: int | None) -> dict[str, Any]:
        self.ran = None
        if name == "state4":
            self.call(0x43D227)
        elif name == "gate":
            self.call(0x447C36, OBJ)
        elif name == "controller":
            self.call(0x4473BE, OBJ)
        elif name == "set_state":
            self.uc.mem_write(G_STATE, struct.pack("<I", arg))
        else:
            raise OracleFailure(name)
        ran = self.ran if name != "controller" else 1
        return {"events": list(self.events), "ran": ran, **self.snapshot()}


class NativeExit:
    def __init__(self, lib: c.CDLL, case: dict[str, Any]):
        self.lib = lib
        self.x = s.new_exit(lib, kind=case["kind"], busy=case["busy"], stage=case["stage"],
                            state=case["state"], budget=case["budget"], pause=case["pause"],
                            popup=case.get("popup", 1), load_game=case.get("load_game", 0),
                            rect=tuple(case["rect"]))
        self.x.g.modal_input = case.get("modal", 0)
        self.x.g.cursor_layer = case.get("cursor_layer", 0)
        self.x.g.redraw_counter = 7
        self.host = s.RecordingHost(lib, self.x, ticks=tuple(case["ticks"]), cw=0x027F)
        self.zeroed = False

    def snapshot(self) -> dict[str, Any]:
        x = self.x
        r = x.effect.current_rect
        return {
            "state": x.g.game_state, "busy": x.effect.busy,
            "rect": [r.left, r.top, r.right, r.bottom], "stage": x.effect.sequence_counter,
            "payload": bytes(x.effect.active_payload).hex(), "modal": x.g.modal_input,
            "render_level": x.g.first_render_level, "cursor_layer": x.g.cursor_layer,
            "redraw": x.g.redraw_request, "redraw_counter": x.g.redraw_counter,
            "dst_zeroed": self.zeroed,
        }

    def step(self, name: str, arg: int | None) -> dict[str, Any]:
        info = s.StepInfo()
        self.host.events = []
        if name == "state4":
            status = self.lib.session_exit_state4(c.byref(self.x), c.byref(self.host.host()),
                                                  c.byref(info))
        elif name == "gate":
            status = self.lib.session_exit_render_pass(c.byref(self.x),
                                                        c.byref(self.host.host()), c.byref(info))
        elif name == "controller":
            status = self.lib.session_exit_controller(c.byref(self.x), c.byref(self.host.host()),
                                                      c.byref(info))
            info.controller_ran = 1       # the original call has no gate; mirror eax below
        elif name == "set_state":
            self.x.g.game_state = arg
            return {"events": [], "ran": None, **self.snapshot()}
        else:
            raise OracleFailure(name)
        if status != s.OK:
            raise OracleFailure(f"native {name} returned {status}")
        self.zeroed = self.zeroed or ("clear_destination",) in self.host.events
        return {"events": list(self.host.events), "ran": info.controller_ran,
                **self.snapshot()}


def cases() -> list[dict[str, Any]]:
    base = dict(busy=1, stage=0, state=4, budget=6, pause=0, rect=(10, 20, 11, 20),
                ticks=[100, 101, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110])
    plan2 = [("state4", None), ("set_state", 3), ("gate", None), ("gate", None)]
    plan1 = [("state4", None), ("state4", None), ("state4", None), ("gate", None)]
    plan3 = [("state4", None), ("state4", None), ("set_state", 3), ("gate", None),
             ("gate", None), ("gate", None)]
    out = []
    for kind, plan in ((2, plan2), (1, plan1), (3, plan3)):
        for budget, pause, ticks in (
                (6, 0, base["ticks"]),
                (6, 3, base["ticks"]),
                (1, 0, [100, 100, 100]),            # elapsed 0 -> 30 frames
                (500, 0, [100, 140, 141]),          # 2*40 < 500 -> 500/40 frames
                (30, 0, [100, 140, 141]),           # 2*40 >= 30 -> 2 frames
                (-5, 0, [100, 101, 102]),           # negative budget
                (6, 5, [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110])):
            out.append(dict(base, kind=kind, budget=budget, pause=pause, ticks=ticks,
                            plan=plan, name=f"type{kind}_budget{budget}_pause{pause}"))
    # Idle effect, bad types, wrong stage/state combinations.
    out.append(dict(base, kind=2, busy=0, plan=[("state4", None), ("gate", None)],
                    name="idle_effect_goes_to_loader"))
    for kind in (0, 4, 9, 255):
        out.append(dict(base, kind=kind, plan=[("state4", None), ("gate", None)],
                        name=f"unsupported_type_{kind}_gate_false"))
    for kind in (1, 2, 3):
        for stage in (0, 1, 2, 3, 4):
            for state in (3, 4):
                out.append(dict(base, kind=kind, stage=stage, state=state,
                                plan=[("gate", None), ("gate", None)],
                                name=f"direct_gate_type{kind}_stage{stage}_state{state}"))
    # The controller itself (no gate): every stage/state/type, including the
    # combinations the gate never lets through.
    for kind in (0, 1, 2, 3, 5):
        for stage in (0, 1, 2, 3, 4, 9):
            for state in (1, 2, 3, 4):
                out.append(dict(base, kind=kind, stage=stage, state=state,
                                pause=2, ticks=[100, 101, 102, 103, 104, 105, 106, 107],
                                plan=[("controller", None), ("controller", None)],
                                name=f"direct_controller_type{kind}_stage{stage}_state{state}"))
    out.append(dict(base, kind=2, stage=1, state=3, modal=1, cursor_layer=5,
                    plan=[("gate", None)], name="stage1_preserves_unrelated_guard_values"))
    out.append(dict(base, kind=2, state=4, plan=[("state4", None), ("state4", None)],
                    name="exit_handler_twice"))
    return out


LATCH_WINDOW = (0x43E3D5, 0x43E433)
CAPTION_WINDOW = (0x43E1BD, 0x43E22B)
LATCH_ADDRS = {  # name -> (address, width)
    "scene_request_flag": (0x5C39FF, 2), "cursor_override": (0x5C39E9, 4),
    "latch_5c39ed": (0x5C39ED, 4), "latch_5c39f1": (0x5C39F1, 4),
    "latch_5c39f5": (0x5C39F5, 4), "latch_5c39f9": (0x5C39F9, 4),
    "input_latch": (0x5C39E5, 4), "first_render_level": (0x5BB1C4, 2),
    "exit_hold_63a5c0": (0x63A5C0, 4), "exit_hold_63a5c4": (0x63A5C4, 4),
}


def read_signed(uc: Any, address: int, width: int) -> int:
    return int.from_bytes(bytes(uc.mem_read(address, width)), "little", signed=True)


def run_window(original: OriginalExit, window: tuple[int, int]) -> None:
    uc = original.uc
    sp = STACK + STACK_SIZE - 0x400
    uc.mem_write(sp, struct.pack("<I", END))
    uc.reg_write(original.R["esp"], sp)
    uc.reg_write(original.R["ebp"], sp - 0x200)
    uc.reg_write(original.R["eflags"], 0x202)
    try:
        uc.emu_start(window[0], window[1], timeout=5_000_000, count=100_000)
    except Exception as exc:  # noqa: BLE001
        raise OracleFailure(f"window 0x{window[0]:x} trapped: {exc}") from exc
    if uc.reg_read(original.R["eip"]) != window[1]:
        raise OracleFailure(f"window 0x{window[0]:x} stopped at "
                            f"0x{uc.reg_read(original.R['eip']):x}")


def latch_cases() -> list[dict[str, int]]:
    rng = random.Random(0x5C39)
    out = [{name: 7 for name in LATCH_ADDRS},
           {name: 0 for name in LATCH_ADDRS},
           {name: -1 for name in LATCH_ADDRS}]
    for _ in range(40):
        out.append({name: rng.choice((0, 1, -1, 0x7FFF, -0x8000, 12345))
                    for name in LATCH_ADDRS})
    return out


def caption_cases() -> list[tuple[int, int, int]]:
    rng = random.Random(0x5B0A)
    out = [(1001, 40, 340), (-3, 0, 10), (0, 5, 5), (32767, -1, 1), (-32768, 0, 0)]
    for _ in range(60):
        out.append((rng.randint(-32768, 32767), rng.randint(-2000, 2000),
                    rng.randint(-2000, 2000)))
    return out


def compare_latch_windows(pe: PEImage, lib: c.CDLL) -> int:
    compared = 0
    for case in latch_cases():
        original = OriginalExit(pe)
        original.setup(dict(kind=2, busy=0, stage=0, state=3, budget=1, pause=0,
                            rect=(0, 0, 0, 0), ticks=[0]))
        for name, (address, width) in LATCH_ADDRS.items():
            original.uc.mem_write(address, (case[name] & ((1 << (8 * width)) - 1))
                                  .to_bytes(width, "little"))
        run_window(original, LATCH_WINDOW)
        x = s.new_exit(lib)
        for name in LATCH_ADDRS:
            setattr(x.g, name, case[name] if name != "first_render_level"
                    and name != "scene_request_flag"
                    else ((case[name] + 0x8000) & 0xFFFF) - 0x8000)
        if lib.session_exit_clear_latches(c.byref(x)) != s.OK:
            raise OracleFailure("native clear_latches failed")
        for name, (address, width) in LATCH_ADDRS.items():
            want = read_signed(original.uc, address, width)
            got = getattr(x.g, name)
            compared += 1
            if want != got:
                raise OracleFailure(f"latch window {case}: {name} original {want} native {got}")
    return compared


def compare_caption_windows(pe: PEImage, lib: c.CDLL) -> int:
    lib.session_exit_clear_caption.argtypes = [
        c.POINTER(s.Exit), c.POINTER(life_tests.Lifecycle), c.POINTER(life_tests.Backend)]
    lib.session_exit_clear_caption.restype = c.c_int
    flags = {"finish": (0x5B1602, 4), "visible": (0x5B1606, 4), "clear_request": (0x5B15C8, 4),
             "ready": (0x5B15D6, 4), "flag_5b15da": (0x5B15DA, 4), "saved_5bb1da": (0x5BB1DA, 4),
             "redraw": (0x5831C8, 4), "lines": (0x5B0A7C, 2)}
    compared = 0
    for height, top, bottom in caption_cases():
        original = OriginalExit(pe)
        original.setup(dict(kind=2, busy=0, stage=0, state=3, budget=1, pause=0,
                            rect=(0, 0, 0, 0), ticks=[0]))
        uc = original.uc
        pre = {"finish": 1, "visible": 1, "clear_request": 1, "ready": 1, "flag_5b15da": 1,
               "saved_5bb1da": 1, "redraw": 1, "lines": 123}
        for name, value in pre.items():
            address, width = flags[name]
            uc.mem_write(address, value.to_bytes(width, "little"))
        uc.mem_write(0x5B0A76, (height & 0xFFFF).to_bytes(2, "little"))
        uc.mem_write(0x5B0A16, struct.pack("<i", top))
        uc.mem_write(0x5B0A1E, struct.pack("<i", bottom))
        run_window(original, CAPTION_WINDOW)

        geometry = layout.Geometry()
        struct.pack_into("<i", geometry.tbox, 0x04, top)
        struct.pack_into("<i", geometry.tbox, 0x0C, bottom)
        geometry.framed_surface_height = height
        shared = layout.Globals()
        life = life_tests.make_life(None, geometry, shared)
        sh = life.shared[0]
        sh.frame_open = 1
        sh.caption_finish_flag = sh.caption_visible_flag = sh.framed_ready = 1
        sh.framed_scroll_lines = 123
        life.g.framed_clear_request = 1
        x = s.new_exit(lib)
        x.g.framed_flag_5b15da = x.g.saved_flag_5bb1da = x.g.redraw_request = 1
        backend = life_tests.RecordingBackend(life_tests.Script())
        at_close: list[tuple] = []
        original_blit = backend._blit

        def spy(ctx, blit, sh=sh, life=life, at_close=at_close, original_blit=original_blit):
            at_close.append((sh.caption_finish_flag, sh.caption_visible_flag,
                             life.g.framed_clear_request, sh.framed_scroll_lines))
            return original_blit(ctx, blit)

        backend.struct.blit = life_tests.BLIT(spy)
        if lib.session_exit_clear_caption(c.byref(x), c.byref(life),
                                          c.byref(backend.struct)) != s.OK:
            raise OracleFailure("native clear_caption failed")
        native = {"finish": sh.caption_finish_flag, "visible": sh.caption_visible_flag,
                  "clear_request": life.g.framed_clear_request, "ready": sh.framed_ready,
                  "flag_5b15da": x.g.framed_flag_5b15da, "saved_5bb1da": x.g.saved_flag_5bb1da,
                  "redraw": x.g.redraw_request, "lines": sh.framed_scroll_lines}
        for name, (address, width) in flags.items():
            compared += 1
            want = read_signed(uc, address, width)
            if want != native[name]:
                raise OracleFailure(f"caption window h={height} t={top} b={bottom}: {name} "
                                    f"original {want} native {native[name]}")
        # The original calls 0x4de2d8 first: every flag still has its old value then.
        compared += 1
        if original.events != [("close_text",)] or at_close != [(1, 1, 1, 123)]:
            raise OracleFailure(f"close ordering differs: {original.events} {at_close}")
    return compared


REQUEST_WINDOW = (0x427CFC, 0x427E0C)
BEGIN_LOAD_WINDOW = (0x438173, 0x438194)
FINISH_INTRO_WINDOW = (0x4381C4, 0x4381CE)


def compare_request_windows(pe: PEImage, lib: c.CDLL) -> int:
    """Dispatcher case 0x0a (gate + stores) against the executor's transition request
    and session_exit_request_transition, for random 20-byte bodies."""
    import session_binding_support as sbs
    rng = random.Random(0x0A0A)
    compared = 0
    for case in range(60):
        target = rng.choice((0, 1, 5900, 4700, 32767, -1, -32768, rng.randint(-32768, 32767)))
        words = [rng.randint(-32768, 32767) for _ in range(3)]
        dwords = [rng.randint(-2**31, 2**31 - 1) for _ in range(3)]
        if case < 3:
            words, dwords = [0, 0, case], [0, 0, 1]
        body = struct.pack("<hhhhiii", target, *words, *dwords)
        original = OriginalExit(pe)
        original.setup(dict(kind=2, busy=0, stage=0, state=3, budget=1, pause=0,
                            rect=(0, 0, 0, 0), ticks=[0]))
        uc = original.uc
        row = 0
        body_va = FIXTURE + 0x4000
        uc.mem_write(body_va, body)
        uc.mem_write(0x5BB5E3 + row, bytes((0x0A, 1)))
        uc.mem_write(0x5BB5E5 + row, struct.pack("<I", body_va))
        uc.mem_write(0x5BB625 + row, b"\0")
        uc.mem_write(0x5BB5E9 + row, struct.pack("<I", 1) + bytes(0x34))   # empty dependency tree
        ebp = STACK + STACK_SIZE - 0x1000
        uc.mem_write(ebp - 0x11C, struct.pack("<h", row))
        sp = ebp - 0x400
        uc.mem_write(sp, struct.pack("<I", END))
        uc.reg_write(original.R["esp"], sp)
        uc.reg_write(original.R["ebp"], ebp)
        uc.reg_write(original.R["eflags"], 0x202)
        uc.emu_start(REQUEST_WINDOW[0], REQUEST_WINDOW[1], timeout=5_000_000, count=100_000)
        if uc.reg_read(original.R["eip"]) != REQUEST_WINDOW[1]:
            raise OracleFailure("request window did not finish")
        want = {
            "scene_request": read_signed(uc, 0x5BB57B, 4), "w0": read_signed(uc, 0x5BB599, 2),
            "w1": read_signed(uc, 0x5BB595, 2), "w2": read_signed(uc, 0x5C39FF, 2),
            "d0": read_signed(uc, 0x5BB59B, 4), "d1": read_signed(uc, 0x5BB59F, 4),
            "d2": read_signed(uc, 0x5BB5A3, 4), "state": r32(uc, G_STATE),
            "done": uc.mem_read(0x5BB625, 1)[0]}
        # Native: one 0x0a row through the real executor, then the exit request.
        sbs_lib = lib
        scene, owner = sbs.open_scene(sbs_lib, [sbs.action(0x0A, 1, body)])
        flags, world, conditions = sbs.make_world(16)

        @sbs.PrepareFn
        def prepare(_c, _cond, _frame, _failure):
            return sbs.CALLBACK_OK

        @sbs.MediaFn
        def media(_c, _frame, _failure):
            return sbs.CALLBACK_OK

        config = sbs.SessionConfig(scene=scene, scene_id=1, action_core_world=c.pointer(world),
                                   conditions=c.pointer(conditions), action_binding_count=0,
                                   prepare_tick=prepare, advance_media_one=media,
                                   provider_context=None)
        session = c.c_void_p()
        failure = sbs.SceneSessionFailure()
        if lib.scene_session_create(c.byref(config), c.byref(session), c.byref(failure)) != 0:
            raise OracleFailure("native session create failed")
        result = sbs.SceneSessionTickResult()
        status = lib.scene_session_tick(session, c.byref(result))
        request = sbs.SceneTransitionRequest()
        pending = lib.scene_session_get_pending_transition(session, c.byref(request))
        if status != sbs.SESSION_TRANSITION or not pending:
            raise OracleFailure(f"native 0x0a row did not request a transition ({status})")
        x = s.new_exit(lib, state=s.STATE_RUN)
        tr = s.TransitionRequest(request.target_scene,
                                 (c.c_int16 * 3)(*request.opaque_words),
                                 (c.c_int32 * 3)(*[0, 0, 0]))
        if lib.session_exit_request_transition(c.byref(x), c.byref(tr)) != s.OK:
            raise OracleFailure("native request failed")
        got = {"scene_request": x.g.scene_request, "w0": request.opaque_words[0],
               "w1": request.opaque_words[1], "w2": x.g.scene_request_flag,
               "d0": request.opaque_dwords[0], "d1": request.opaque_dwords[1],
               "d2": request.opaque_dwords[2], "state": x.g.game_state, "done": 1}
        lib.scene_session_destroy(session)
        lib.scene_resource_close(scene)
        for key, value in want.items():
            compared += 1
            if value != got[key]:
                raise OracleFailure(f"0x0a window case {case} body={body.hex()}: {key} "
                                    f"original {value} native {got[key]}")
    return compared


def compare_load_windows(pe: PEImage, lib: c.CDLL) -> int:
    compared = 0
    for word in (0, 1, -1, 5, 32767, -32768, 256):
        original = OriginalExit(pe)
        original.setup(dict(kind=2, busy=0, stage=0, state=1, budget=1, pause=0,
                            rect=(0, 0, 0, 0), ticks=[0]))
        original.uc.mem_write(0x5C39FF, struct.pack("<h", word))
        run_window(original, BEGIN_LOAD_WINDOW)
        x = s.new_exit(lib, state=s.STATE_LOAD)
        x.g.scene_request_flag = word
        lib.session_exit_begin_load(c.byref(x))
        compared += 1
        if r32(original.uc, G_STATE) != x.g.game_state:
            raise OracleFailure(f"begin_load word={word}: original {r32(original.uc, G_STATE)} "
                                f"native {x.g.game_state}")
        original.uc.mem_write(G_STATE, struct.pack("<I", 2))
        run_window(original, FINISH_INTRO_WINDOW)
        lib.session_exit_finish_intro(c.byref(x))
        compared += 1
        if r32(original.uc, G_STATE) != x.g.game_state:
            raise OracleFailure("finish_intro differs")
    return compared


def run(args: argparse.Namespace) -> dict[str, Any]:
    data = args.exe.read_bytes()
    digest = sha256(data)
    if digest != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE hash mismatch: {digest}")
    pe = PEImage.parse_and_map(args.exe)
    lib = s.load_library(s.build_library())
    compared = steps = event_count = 0
    results = []
    hooks: set[str] = set()
    for case in cases():
        original = OriginalExit(pe)
        original.setup(case)
        native = NativeExit(lib, case)
        for index, (name, arg) in enumerate(case["plan"]):
            want = original.step(name, arg)
            got = native.step(name, arg)
            original.events = []
            steps += 1
            event_count += len(want["events"])
            for key in want:
                compared += 1
                if want[key] != got[key]:
                    raise OracleFailure(
                        f"{case['name']} step {index} ({name}): {key} differs\n"
                        f"  original {want[key]!r}\n  native   {got[key]!r}")
        hooks |= original.hook_names
        results.append({"name": case["name"], "steps": len(case["plan"])})
    request_compared = compare_request_windows(pe, lib)
    load_compared = compare_load_windows(pe, lib)
    latch_compared = compare_latch_windows(pe, lib)
    caption_compared = compare_caption_windows(pe, lib)
    hooks.add("0x4de2d8")
    return {"slice": "RT-5", "oracle": "exit handler / effect controller / ClearSceneData windows",
            "request_window_fields_compared": request_compared,
            "load_window_fields_compared": load_compared,
            "latch_window_fields_compared": latch_compared,
            "caption_window_fields_compared": caption_compared,
            "game_exe_sha256": digest, "cases": len(results), "steps": steps,
            "fields_compared": compared, "events_compared": event_count,
            "mismatches": 0, "host_hooks": sorted(hooks),
            "observation_only_hooks": ["0x447495", "0x44753b", "0x447cc0"],
            "native_library": str(s.DEFAULT_LIBRARY.name), "results": results}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    report = run(args)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("cases", "steps", "fields_compared",
                                              "events_compared", "request_window_fields_compared",
                                              "load_window_fields_compared",
                                              "latch_window_fields_compared",
                                              "caption_window_fields_compared", "mismatches")}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
