#!/usr/bin/env python3
"""Compare the native startup menu with original x86 menu selector 0x4da430.

This executes only GAME.EXE's menu input function. The harness installs the
real MENU hit/state rectangles from decoded BOOT, then narrowly stubs cursor,
clock, sound and menu-render endpoints. It does not initialize or run the
original game, dispatch selected menu commands, or compare scene/save logic.

Use the repository's isolated oracle interpreter (Unicorn 2.1.4):

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/startup_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import struct
import sys
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_startup_menu import (
    StartupMenuConfig,
    StartupMenuFrame,
    StartupMenuInput,
    build_library,
    load_library,
)


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_BOOT = ROOT / "work/analysis/cif-boot-native.bin"
DEFAULT_NATIVE = ROOT / "outputs/blackmoor-decomp/build/libstartupmenu.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/startup-menu-oracle.json"

MENU_SELECTION_VA = 0x4DA430
MENU_SELECTION_END = 0x4DAD11
MENU_HIT_TABLE_VA = 0x5AFD05
MENU_PRESSED_TABLE_VA = 0x5AFD95
MENU_DISABLED_TABLE_VA = 0x5AFE25
MENU_HOVER_TABLE_VA = 0x5AFEB5
MENU_DISABLED_FLAGS_VA = 0x5AFF79
MENU_STATE_VA = 0x5AFF4D
MENU_ARMED_VA = 0x5AFF51
MENU_SELECTED_VA = 0x5AFF55
MENU_HOVERED_VA = 0x5AFF57
MENU_DEADLINE_VA = 0x5AFF49
MOUSE_OBJECT_VA = 0x5830A6
MOUSE_MOVE_GUARD_VA = 0x5830D6
MOUSE_PREVIOUS_X_VA = 0x5830EA
MOUSE_PREVIOUS_Y_VA = 0x5830EE
DISPLAY_WIDTH_VA = 0x63988B
DISPLAY_HEIGHT_VA = 0x63988D
MOUSE_WIDTH_TABLE_VA = 0x5B3790
MOUSE_HEIGHT_TABLE_VA = 0x5B3792
MOUSE_OFFSET_X_TABLE_VA = 0x5B30CC
MOUSE_OFFSET_Y_TABLE_VA = 0x5B30D0
LAYOUT_X_VA = 0x5B44F0
LAYOUT_Y_VA = 0x5B44F4
CLICK_FEEDBACK_MS_VA = 0x5B0282

IAT_GET_CURSOR_POS = 0x52A484
IAT_GET_TICK_COUNT = 0x52A23C
IAT_GET_SYSTEM_METRICS = 0x52A498
IAT_SET_CURSOR_POS = 0x52A488
SOUND_START_VA = 0x4FB2E3
SOUND_COMPLETE_VA = 0x4F6334
MENU_RENDER_VA = 0x4CF7E0

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
RETURN_SENTINEL = 0x30000000
HOOK_BASE = 0x70000000
HOOK_SIZE = 0x10000
HOOK_GET_CURSOR = HOOK_BASE + 0x100
HOOK_GET_TICK = HOOK_BASE + 0x200
HOOK_GET_METRICS = HOOK_BASE + 0x300
HOOK_SET_CURSOR = HOOK_BASE + 0x400

MENU_TABLES = (
    (MENU_HIT_TABLE_VA, 55),
    (MENU_PRESSED_TABLE_VA, 199),
    (MENU_DISABLED_TABLE_VA, 343),
    (MENU_HOVER_TABLE_VA, 487),
)


class OracleFailure(RuntimeError):
    pass


class HiffChunkInfo(ctypes.Structure):
    _fields_ = [
        ("data_index", ctypes.c_size_t),
        ("header_offset", ctypes.c_size_t),
        ("payload_offset", ctypes.c_size_t),
        ("padded_extent_size", ctypes.c_size_t),
        ("payload_size", ctypes.c_uint32),
        ("id", ctypes.c_char * 5),
    ]


class EngineBootMenuInfo(ctypes.Structure):
    _fields_ = [
        ("chunk", HiffChunkInfo),
        ("chunk_index", ctypes.c_size_t),
        ("raw", ctypes.POINTER(ctypes.c_uint8)),
        ("raw_size", ctypes.c_size_t),
        ("first_image_filename", ctypes.c_char * 34),
        ("first_image_nominal_width", ctypes.c_uint16),
        ("first_image_nominal_height", ctypes.c_uint16),
    ]


def u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def s16(machine: Any, address: int) -> int:
    return struct.unpack("<h", machine.mem_read(address, 2))[0]


def ret_from_hook(machine: Any, cleanup_bytes: int = 0) -> None:
    from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP

    esp = machine.reg_read(UC_X86_REG_ESP)
    return_address = u32(machine, esp)
    machine.reg_write(UC_X86_REG_ESP, esp + 4 + cleanup_bytes)
    machine.reg_write(UC_X86_REG_EIP, return_address)


def extract_menu_raw(library: ctypes.CDLL, boot_bytes: bytes) -> bytes:
    storage = (ctypes.c_uint8 * len(boot_bytes)).from_buffer_copy(boot_bytes)
    error = ctypes.create_string_buffer(512)
    library.engine_boot_open_memory.argtypes = [
        ctypes.c_void_p,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_char),
        ctypes.c_size_t,
    ]
    library.engine_boot_open_memory.restype = ctypes.c_void_p
    library.engine_boot_get_menu.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(EngineBootMenuInfo),
    ]
    library.engine_boot_get_menu.restype = ctypes.c_int
    library.engine_boot_close.argtypes = [ctypes.c_void_p]
    library.engine_boot_close.restype = None
    boot = library.engine_boot_open_memory(
        ctypes.cast(storage, ctypes.c_void_p), len(boot_bytes), error, len(error)
    )
    if not boot:
        raise OracleFailure(error.value.decode("utf-8", "replace"))
    try:
        info = EngineBootMenuInfo()
        status = library.engine_boot_get_menu(boot, ctypes.byref(info))
        if status != 0:
            raise OracleFailure(f"engine_boot_get_menu returned {status}")
        if info.raw_size < 631:
            raise OracleFailure(f"real MENU record is only {info.raw_size} bytes")
        return ctypes.string_at(info.raw, info.raw_size)
    finally:
        library.engine_boot_close(boot)


class NativeMenu:
    def __init__(self, library: ctypes.CDLL, boot_bytes: bytes, disabled_mask: int):
        self.library = library
        storage = (ctypes.c_uint8 * len(boot_bytes)).from_buffer_copy(boot_bytes)
        error = ctypes.create_string_buffer(512)
        library.engine_boot_open_memory.argtypes = [
            ctypes.c_void_p,
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_char),
            ctypes.c_size_t,
        ]
        library.engine_boot_open_memory.restype = ctypes.c_void_p
        library.engine_boot_close.argtypes = [ctypes.c_void_p]
        library.engine_boot_close.restype = None
        library.startup_menu_create.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(StartupMenuConfig),
            ctypes.c_uint32,
            ctypes.POINTER(ctypes.c_char),
            ctypes.c_size_t,
        ]
        library.startup_menu_create.restype = ctypes.c_void_p
        library.startup_menu_destroy.argtypes = [ctypes.c_void_p]
        library.startup_menu_destroy.restype = None
        library.startup_menu_step.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(StartupMenuInput),
            ctypes.POINTER(StartupMenuFrame),
        ]
        library.startup_menu_step.restype = ctypes.c_int
        boot = library.engine_boot_open_memory(
            ctypes.cast(storage, ctypes.c_void_p), len(boot_bytes), error, len(error)
        )
        if not boot:
            raise OracleFailure(error.value.decode("utf-8", "replace"))
        config = StartupMenuConfig(disabled_mask, 0)
        self.handle = library.startup_menu_create(
            boot, ctypes.byref(config), 0, error, len(error)
        )
        library.engine_boot_close(boot)
        if not self.handle:
            raise OracleFailure(error.value.decode("utf-8", "replace"))
        self.tick = 0
        # Skip both recovered logo stages through their original click edge.
        self.step(pressed=True)
        self.step(pressed=True)

    def close(self) -> None:
        if self.handle:
            self.library.startup_menu_destroy(self.handle)
            self.handle = None

    def step(
        self,
        *,
        x: int = 0,
        y: int = 0,
        down: bool = False,
        pressed: bool = False,
        sound_complete: bool = True,
        tick: int | None = None,
    ) -> StartupMenuFrame:
        if tick is None:
            self.tick += 1
            tick = self.tick
        else:
            self.tick = tick
        event = StartupMenuInput(
            tick,
            x,
            y,
            1,
            int(down),
            int(pressed),
            0,
            int(sound_complete),
        )
        frame = StartupMenuFrame()
        status = self.library.startup_menu_step(
            self.handle, ctypes.byref(event), ctypes.byref(frame)
        )
        if status != 0:
            raise OracleFailure(f"startup_menu_step returned {status}")
        return frame


class OriginalMenu:
    def __init__(self, pe: PEImage, menu_raw: bytes, disabled_mask: int):
        from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        from unicorn.x86_const import (
            UC_X86_REG_EBP,
            UC_X86_REG_EFLAGS,
        )

        self._uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self._uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self._uc.mem_write(pe.image_base, pe.image)
        self._uc.mem_map(STACK_BASE, STACK_SIZE)
        self._uc.mem_map(HOOK_BASE, HOOK_SIZE)
        self._uc.mem_map(RETURN_SENTINEL, 0x1000)
        self._uc.mem_write(RETURN_SENTINEL, b"\xCC")
        self._menu_raw = menu_raw
        self._disabled_mask = disabled_mask
        self._cursor_x = 0
        self._cursor_y = 0
        self._tick_ms = 0
        self._sound_complete = True
        self._api_calls: dict[str, int] = {}
        self._instruction_count = 0
        self._uc.mem_write(IAT_GET_CURSOR_POS, struct.pack("<I", HOOK_GET_CURSOR))
        self._uc.mem_write(IAT_GET_TICK_COUNT, struct.pack("<I", HOOK_GET_TICK))
        self._uc.mem_write(IAT_GET_SYSTEM_METRICS, struct.pack("<I", HOOK_GET_METRICS))
        self._uc.mem_write(IAT_SET_CURSOR_POS, struct.pack("<I", HOOK_SET_CURSOR))
        self._uc.hook_add(UC_HOOK_CODE, self._hook_code)
        self._reset(disabled_mask)

    @property
    def api_calls(self) -> dict[str, int]:
        return dict(self._api_calls)

    @property
    def instruction_count(self) -> int:
        return self._instruction_count

    def _write16(self, address: int, value: int) -> None:
        self._uc.mem_write(address, struct.pack("<H", value & 0xFFFF))

    def _write32(self, address: int, value: int) -> None:
        self._uc.mem_write(address, struct.pack("<I", value & 0xFFFFFFFF))

    def _reset(self, disabled_mask: int) -> None:
        uc = self._uc
        # Four original MENU rectangle tables are copied from the decoded BOOT
        # payload using the exact 0x4d9df3 global layout.
        for destination, source in MENU_TABLES:
            for index in range(9):
                start = source + index * 16
                uc.mem_write(destination + index * 16, self._menu_raw[start:start + 16])
        for index in range(9):
            self._write32(
                MENU_DISABLED_FLAGS_VA + index * 4,
                1 if disabled_mask & (1 << index) else 0,
            )
        self._write32(MENU_STATE_VA, 0)
        self._write32(MENU_ARMED_VA, 0)
        self._write16(MENU_SELECTED_VA, 0xFFFF)
        self._write16(MENU_HOVERED_VA, 0xFFFF)
        self._write32(MENU_DEADLINE_VA, 0)
        self._write16(CLICK_FEEDBACK_MS_VA, 0)
        # Reproduce the menu's selected 640x480 coordinate mode while keeping
        # all recovered hit rectangles inside the cursor clamp.
        self._write32(LAYOUT_X_VA, 4)
        self._write32(LAYOUT_Y_VA, 1)
        self._write16(DISPLAY_WIDTH_VA, 640)
        self._write16(DISPLAY_HEIGHT_VA, 480)
        mode_index = 1 * 2 + 4 * 4
        self._write16(MOUSE_WIDTH_TABLE_VA + mode_index * 2, 24)
        self._write16(MOUSE_HEIGHT_TABLE_VA + mode_index * 2, 32)
        mode_offset = 4 * 16 + 1 * 8
        self._write32(MOUSE_OFFSET_X_TABLE_VA + mode_offset, 0)
        self._write32(MOUSE_OFFSET_Y_TABLE_VA + mode_offset, 0)
        self._write32(MOUSE_OBJECT_VA + 0x0C, 0)
        self._write32(MOUSE_MOVE_GUARD_VA, 0)
        self._write32(MOUSE_PREVIOUS_X_VA, 0)
        self._write32(MOUSE_PREVIOUS_Y_VA, 0)

    def reset(self, disabled_mask: int) -> None:
        self._disabled_mask = disabled_mask
        self._reset(disabled_mask)

    def _hook_code(self, machine: Any, address: int, _size: int, _user_data: Any) -> None:
        from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_ESP

        self._instruction_count += 1
        if address == HOOK_GET_CURSOR:
            esp = machine.reg_read(UC_X86_REG_ESP)
            output = u32(machine, esp + 4)
            machine.mem_write(output, struct.pack("<ii", self._cursor_x, self._cursor_y))
            machine.reg_write(UC_X86_REG_EAX, 1)
            self._api_calls["GetCursorPos"] = self._api_calls.get("GetCursorPos", 0) + 1
            ret_from_hook(machine, 4)
        elif address == HOOK_GET_TICK:
            machine.reg_write(UC_X86_REG_EAX, self._tick_ms)
            self._api_calls["GetTickCount"] = self._api_calls.get("GetTickCount", 0) + 1
            ret_from_hook(machine)
        elif address == HOOK_GET_METRICS:
            machine.reg_write(UC_X86_REG_EAX, 0)
            self._api_calls["GetSystemMetrics"] = self._api_calls.get("GetSystemMetrics", 0) + 1
            ret_from_hook(machine, 4)
        elif address == HOOK_SET_CURSOR:
            machine.reg_write(UC_X86_REG_EAX, 1)
            self._api_calls["SetCursorPos"] = self._api_calls.get("SetCursorPos", 0) + 1
            ret_from_hook(machine, 8)
        elif address == SOUND_START_VA:
            self._api_calls["sound_start"] = self._api_calls.get("sound_start", 0) + 1
            ret_from_hook(machine, 4)
        elif address == SOUND_COMPLETE_VA:
            machine.reg_write(UC_X86_REG_EAX, 0 if self._sound_complete else 1)
            self._api_calls["sound_complete"] = self._api_calls.get("sound_complete", 0) + 1
            ret_from_hook(machine, 4)
        elif address == MENU_RENDER_VA:
            self._api_calls["menu_render"] = self._api_calls.get("menu_render", 0) + 1
            # Rendering is a surface operation outside the selector under test.
            ret_from_hook(machine)

    def step(
        self,
        *,
        x: int = 0,
        y: int = 0,
        down: bool = False,
        sound_complete: bool = True,
        tick: int = 0,
    ) -> dict[str, int]:
        from unicorn.x86_const import (
            UC_X86_REG_EBP,
            UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP,
            UC_X86_REG_ESP,
        )

        self._cursor_x = x
        self._cursor_y = y
        self._tick_ms = tick & 0xFFFFFFFF
        self._sound_complete = sound_complete
        # Preserve 0x4da430's previous-cursor globals and movement guard across
        # calls. A repeated point is a stationary poll; a changed point follows
        # the original guarded coordinate-update path.
        self._write32(MOUSE_OBJECT_VA + 0x0C, 2 if down else 0)
        self._uc.mem_write(STACK_TOP - 4, struct.pack("<I", RETURN_SENTINEL))
        self._uc.reg_write(UC_X86_REG_ESP, STACK_TOP - 4)
        self._uc.reg_write(UC_X86_REG_EBP, 0)
        self._uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        self._uc.reg_write(UC_X86_REG_EIP, MENU_SELECTION_VA)
        try:
            self._uc.emu_start(
                MENU_SELECTION_VA,
                RETURN_SENTINEL,
                timeout=10_000_000,
                count=200_000,
            )
        except Exception as exc:
            raise OracleFailure(f"original 0x4da430 trapped at x={x}, y={y}: {exc}") from exc
        eip = self._uc.reg_read(UC_X86_REG_EIP)
        esp = self._uc.reg_read(UC_X86_REG_ESP)
        if eip != RETURN_SENTINEL or esp != STACK_TOP:
            raise OracleFailure(
                f"0x4da430 failed to return: EIP=0x{eip:08x}, ESP=0x{esp:08x}"
            )
        return {
            "stage": u32(self._uc, MENU_STATE_VA),
            "hover_armed": u32(self._uc, MENU_ARMED_VA),
            "hovered_button": s16(self._uc, MENU_HOVERED_VA),
            "pressed_button": s16(self._uc, MENU_SELECTED_VA),
            "deadline_ms": u32(self._uc, MENU_DEADLINE_VA),
        }


def rect_from_menu(raw: bytes, index: int) -> tuple[int, int, int, int]:
    return struct.unpack_from("<4i", raw, 55 + index * 16)


def menu_points(raw: bytes) -> list[tuple[str, int, int, int]]:
    points: list[tuple[str, int, int, int]] = []
    for index in range(9):
        left, top, right, bottom = rect_from_menu(raw, index)
        cx = (left + right) // 2
        cy = (top + bottom) // 2
        points.extend(
            [
                (f"button-{index}-top-left", left, top, index),
                (f"button-{index}-bottom-right", right, bottom, index),
                (f"button-{index}-bottom-plus-10", cx, bottom + 10, index),
                (f"button-{index}-left-outside", left - 1, cy, -1),
                (f"button-{index}-right-outside", right + 1, cy, -1),
                (f"button-{index}-top-outside", cx, top - 1, -1),
                (f"button-{index}-bottom-plus-11", cx, bottom + 11, -1),
            ]
        )
    return points


def compare_menu_step(
    label: str,
    original: OriginalMenu,
    native: NativeMenu,
    *,
    x: int,
    y: int,
    down: bool = False,
    sound_complete: bool = True,
    tick: int,
) -> dict[str, Any]:
    expected = original.step(
        x=x, y=y, down=down, sound_complete=sound_complete, tick=tick
    )
    actual = native.step(
        x=x,
        y=y,
        down=down,
        sound_complete=sound_complete,
        tick=tick,
    )
    original_public = {
        "hovered_button": expected["hovered_button"],
        "pressed_button": expected["pressed_button"],
        "command_ready": expected["stage"] == 3,
    }
    native_public = {
        "hovered_button": actual.hovered_button,
        "pressed_button": actual.pressed_button,
        "command_ready": bool(actual.command_ready),
    }
    for field in ("hovered_button", "pressed_button", "command_ready"):
        if original_public[field] != native_public[field]:
            raise OracleFailure(
                f"{label}: {field} mismatch: original={original_public[field]}, "
                f"native={native_public[field]}"
            )
    return {
        "label": label,
        "x": x,
        "y": y,
        "down": down,
        "original": original_public,
        "native": native_public,
        "match": True,
    }


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    if not args.boot.is_file():
        raise OracleFailure(f"decoded original BOOT unavailable: {args.boot}")
    requested_native_library = args.native_library.resolve()
    if not requested_native_library.is_file():
        if requested_native_library == DEFAULT_NATIVE.resolve():
            build_library()
        else:
            raise OracleFailure(
                f"requested native library unavailable: {requested_native_library}"
            )
    pe = PEImage.parse_and_map(args.exe)
    exe_hash = hashlib.sha256(pe.data).hexdigest()
    if exe_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {exe_hash}")
    native_hash = hashlib.sha256(requested_native_library.read_bytes()).hexdigest()
    boot_bytes = args.boot.read_bytes()
    library = load_library(requested_native_library)
    loaded_native_library = Path(library._name).resolve()
    if loaded_native_library != requested_native_library:
        raise OracleFailure(
            f"requested native library {requested_native_library} but loaded {loaded_native_library}"
        )
    menu_raw = extract_menu_raw(library, boot_bytes)
    if len(menu_raw) != 631:
        raise OracleFailure(f"expected real BOOT MENU payload size 631, got {len(menu_raw)}")
    original = OriginalMenu(pe, menu_raw, disabled_mask=0)

    results: list[dict[str, Any]] = []
    native = NativeMenu(library, boot_bytes, disabled_mask=0)
    try:
        # All nine enabled hitboxes: inclusive edges, ordinary points, and the
        # original bottom-edge +10 y-hotspot extension.
        for number, (label, x, y, expected_button) in enumerate(menu_points(menu_raw)):
            # Reset native hover arming by leaving every button before each
            # independent point; recreate the original menu-init globals.
            original.reset(disabled_mask=0)
            native.step(x=0, y=0, tick=number * 10)
            row = compare_menu_step(
                label,
                original,
                native,
                x=x,
                y=y,
                tick=number * 10 + 1,
            )
            if row["original"]["hovered_button"] != expected_button:
                raise OracleFailure(
                    f"{label}: oracle point unexpectedly hit "
                    f"{row['original']['hovered_button']}, expected {expected_button}"
                )
            results.append(row)

        # Every enabled button follows the original arm-then-held-selection path.
        for index in range(9):
            left, top, right, bottom = rect_from_menu(menu_raw, index)
            x, y = (left + right) // 2, (top + bottom) // 2
            original.reset(disabled_mask=0)
            native.close()
            native = NativeMenu(library, boot_bytes, disabled_mask=0)
            original.step(x=x, y=y, tick=10_000 + index * 10)
            native.step(x=x, y=y, tick=10_000 + index * 10)
            first = compare_menu_step(
                f"button-{index}-arming",
                original,
                native,
                x=x,
                y=y,
                tick=10_001 + index * 10,
            )
            selected = compare_menu_step(
                f"button-{index}-press",
                original,
                native,
                x=x,
                y=y,
                down=True,
                tick=10_002 + index * 10,
            )
            if selected["original"]["pressed_button"] != index:
                raise OracleFailure(f"button-{index} failed original selection")
            results.extend((first, selected))

        # Disabled flags 3/4 are host-session state. A disabled hit preserves
        # the one shared hover-arm latch but cannot request a button.
        disabled_mask = (1 << 3) | (1 << 4)
        original.reset(disabled_mask)
        native.close()
        native = NativeMenu(library, boot_bytes, disabled_mask=disabled_mask)
        left1, top1, right1, bottom1 = rect_from_menu(menu_raw, 1)
        x1, y1 = (left1 + right1) // 2, (top1 + bottom1) // 2
        original.step(x=x1, y=y1, tick=20_000)
        native.step(x=x1, y=y1, tick=20_000)
        results.append(compare_menu_step(
            "disabled-mask-arm-first-enabled",
            original,
            native,
            x=x1,
            y=y1,
            tick=20_001,
        ))
        left3, top3, right3, bottom3 = rect_from_menu(menu_raw, 3)
        x3, y3 = (left3 + right3) // 2, (top3 + bottom3) // 2
        disabled = compare_menu_step(
            "disabled-continue-hit",
            original,
            native,
            x=x3,
            y=y3,
            down=True,
            tick=20_002,
        )
        results.append(disabled)
        results.append(compare_menu_step(
            "disabled-continue-stationary-poll",
            original,
            native,
            x=x3,
            y=y3,
            tick=20_003,
        ))
        left2, top2, right2, bottom2 = rect_from_menu(menu_raw, 2)
        x2, y2 = (left2 + right2) // 2, (top2 + bottom2) // 2
        selected_across_disabled = compare_menu_step(
            "arm-preserved-through-disabled-rect",
            original,
            native,
            x=x2,
            y=y2,
            down=True,
            tick=20_004,
        )
        if selected_across_disabled["original"]["pressed_button"] != 2:
            raise OracleFailure("original did not preserve shared arm across disabled rect")
        results.append(selected_across_disabled)

        # Leaving every rectangle resets the arm; the next held update over a
        # button only arms, and a later held update selects.
        original.reset(disabled_mask=0)
        native.close()
        native = NativeMenu(library, boot_bytes, disabled_mask=0)
        original.step(x=x1, y=y1, tick=21_000)
        native.step(x=x1, y=y1, tick=21_000)
        results.append(compare_menu_step(
            "arm-before-leave",
            original,
            native,
            x=x1,
            y=y1,
            tick=21_001,
        ))
        results.append(compare_menu_step(
            "leave-all-rectangles-clears-arm",
            original,
            native,
            x=0,
            y=0,
            tick=21_002,
        ))
        results.append(compare_menu_step(
            "outside-stationary-poll",
            original,
            native,
            x=0,
            y=0,
            tick=21_003,
        ))
        not_selected = compare_menu_step(
            "held-entry-after-leave-only-rearms",
            original,
            native,
            x=x2,
            y=y2,
            down=True,
            tick=21_004,
        )
        if not_selected["original"]["pressed_button"] != -1:
            raise OracleFailure("original selected immediately after arm reset")
        results.append(not_selected)
        selected_after_rearm = compare_menu_step(
            "press-after-rearm-selects",
            original,
            native,
            x=x2,
            y=y2,
            down=True,
            tick=21_005,
        )
        if selected_after_rearm["original"]["pressed_button"] != 2:
            raise OracleFailure("original failed selection after rearming")
        results.append(selected_after_rearm)

        # Once selected, moving to another hitbox does not alter the selection.
        original.reset(disabled_mask=0)
        native.close()
        native = NativeMenu(library, boot_bytes, disabled_mask=0)
        original.step(x=x1, y=y1, tick=22_000)
        native.step(x=x1, y=y1, tick=22_000)
        original.step(x=x1, y=y1, down=True, tick=22_001)
        native.step(x=x1, y=y1, down=True, tick=22_001)
        moved_pressed = compare_menu_step(
            "pending-selection-locks-button-across-pointer-move",
            original,
            native,
            x=x2,
            y=y2,
            down=True,
            sound_complete=False,
            tick=22_002,
        )
        if moved_pressed["original"]["pressed_button"] != 1:
            raise OracleFailure("original pressed-button latch changed after pointer move")
        results.append(moved_pressed)

        # The global delay is zero in GAME.EXE BSS. Verify strict deadline
        # comparison and sound completion independently before dispatch.
        original.reset(disabled_mask=0)
        native.close()
        native = NativeMenu(library, boot_bytes, disabled_mask=0)
        original.step(x=x1, y=y1, tick=30_000)
        native.step(x=x1, y=y1, tick=30_000)
        original.step(x=x1, y=y1, down=True, tick=30_001)
        native.step(x=x1, y=y1, down=True, tick=30_001)
        at_deadline = compare_menu_step(
            "deadline-equal-does-not-dispatch",
            original,
            native,
            x=x1,
            y=y1,
            sound_complete=True,
            tick=30_001,
        )
        if at_deadline["original"]["command_ready"]:
            raise OracleFailure("original dispatches at exact deadline")
        results.append(at_deadline)
        waiting_sound = compare_menu_step(
            "after-deadline-waits-for-click-sound",
            original,
            native,
            x=x1,
            y=y1,
            sound_complete=False,
            tick=30_002,
        )
        if waiting_sound["original"]["command_ready"]:
            raise OracleFailure("original dispatches before click sound completion")
        results.append(waiting_sound)
        dispatch = compare_menu_step(
            "after-deadline-and-sound-ready",
            original,
            native,
            x=x1,
            y=y1,
            sound_complete=True,
            tick=30_002,
        )
        if not dispatch["original"]["command_ready"]:
            raise OracleFailure("original failed to expose command after both gates")
        results.append(dispatch)
    finally:
        native.close()

    code_offset = pe.va_to_file_offset(MENU_SELECTION_VA, MENU_SELECTION_END - MENU_SELECTION_VA)
    result_digest = hashlib.sha256(
        json.dumps(results, sort_keys=True, separators=(",", ":")).encode("utf-8")
    ).hexdigest()
    return {
        "scope": "original x86 menu hit/hover/press/deadline selector only; no command dispatch or complete startup",
        "original_executable": str(args.exe),
        "original_sha256": exe_hash,
        "original_function_va": f"0x{MENU_SELECTION_VA:08x}",
        "original_function_range": f"0x{MENU_SELECTION_VA:08x}..0x{MENU_SELECTION_END:08x}",
        "original_code_sha256": hashlib.sha256(
            pe.data[code_offset:code_offset + MENU_SELECTION_END - MENU_SELECTION_VA]
        ).hexdigest(),
        "native_library_path": str(requested_native_library),
        "native_library_loaded_path": str(loaded_native_library),
        "native_library_sha256": native_hash,
        "real_boot_menu_payload_size": len(menu_raw),
        "real_menu_rectangle_tables": {"hit": 55, "pressed": 199, "disabled": 343, "hover": 487},
        "disabled_mask_cases": [0, (1 << 3) | (1 << 4)],
        "compared_fields": ["hovered_button", "pressed_button", "command_ready"],
        "compared_steps": len(results),
        "mismatches": 0,
        "result_digest": result_digest,
        "results": results,
        "oracle_execution": {
            "engine": "original GAME.EXE PE32 code under Unicorn 2.1.4",
            "original_instruction_count": original.instruction_count,
            "hooked_platform_and_audio_calls": original.api_calls,
            "coordinate_setup": "identity logical mapping in selected 640x480 menu mode; cursor clamp dimensions 24x32 leave all tested hit coordinates unclamped",
            "stubs": [
                "GetCursorPos returns requested logical test point",
                "GetTickCount returns requested 32-bit tick",
                "GetSystemMetrics returns 0 for SM_SWAPBUTTON",
                "SetCursorPos is a no-op success",
                "0x4fb2e3 click-start audio call returns without playback",
                "0x4f6334 click-sound completion returns the requested complete/incomplete state",
                "0x4cf7e0 menu surface draw is skipped",
            ],
            "excluded": [
                "0x4d9df3 original menu/resource initialization; relevant globals and all four rectangle tables are seeded from its verified BOOT-derived data",
                "0x4da430 state-3 command dispatch (credits/new game/load/continue/setup/help/promo/exit), which invokes downstream engine behaviors",
                "full Windows input, cursor graphics, audio, surface renderer and game loop",
            ],
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--boot", type=Path, default=DEFAULT_BOOT)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except Exception as exc:
        print(f"startup_original_oracle: {exc}", file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in report.items() if key != "results"}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
