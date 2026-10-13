"""Tests for the recovered original startup and menu controller."""

from __future__ import annotations

import ctypes
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / "build/libstartupmenu.dylib"
REAL_BOOT = ROOT / "work/analysis/cif-boot-native.bin"

STARTUP_MENU_OK = 0
PARTNER_SPLASH = 0
COMPANY_LOGO = 1
MAIN_MENU = 2
COMMAND_PENDING = 3

BUTTON_NORMAL = 0
BUTTON_HOVER = 1
BUTTON_PRESSED = 2
BUTTON_DISABLED = 3

COMMAND_NONE = 0
COMMAND_CREDITS = 1
COMMAND_NEW_GAME = 2
COMMAND_LOAD = 3
COMMAND_CONTINUE = 4
COMMAND_SETUP = 5
COMMAND_HELP = 6
COMMAND_PROMO = 7
COMMAND_SECOND_CHANCE = 8
COMMAND_EXIT_GAME = 9


class StartupMenuRect(ctypes.Structure):
    _fields_ = [
        ("left", ctypes.c_int32),
        ("top", ctypes.c_int32),
        ("right", ctypes.c_int32),
        ("bottom", ctypes.c_int32),
    ]

    def values(self) -> tuple[int, int, int, int]:
        return self.left, self.top, self.right, self.bottom


class StartupMenuConfig(ctypes.Structure):
    _fields_ = [
        ("disabled_button_mask", ctypes.c_uint16),
        ("click_feedback_ms", ctypes.c_uint32),
    ]


class StartupMenuInput(ctypes.Structure):
    _fields_ = [
        ("tick_ms", ctypes.c_uint32),
        ("logical_x", ctypes.c_int32),
        ("logical_y", ctypes.c_int32),
        ("pointer_valid", ctypes.c_int),
        ("primary_down", ctypes.c_int),
        ("primary_pressed", ctypes.c_int),
        ("primary_released", ctypes.c_int),
        ("click_sound_complete", ctypes.c_int),
    ]


class StartupMenuButtonFrame(ctypes.Structure):
    _fields_ = [
        ("index", ctypes.c_uint8),
        ("command", ctypes.c_int),
        ("visual", ctypes.c_int),
        ("hit_rect", StartupMenuRect),
        ("source_rect", StartupMenuRect),
        ("destination_rect", StartupMenuRect),
    ]


class StartupMenuFrame(ctypes.Structure):
    _fields_ = [
        ("stage", ctypes.c_int),
        ("resource_name", ctypes.c_char_p),
        ("background_source", StartupMenuRect),
        ("background_destination", StartupMenuRect),
        ("has_background", ctypes.c_int),
        ("full_screen_image", ctypes.c_int),
        ("buttons", StartupMenuButtonFrame * 9),
        ("button_count", ctypes.c_size_t),
        ("hovered_button", ctypes.c_int),
        ("pressed_button", ctypes.c_int),
        ("requested_command", ctypes.c_int),
        ("command_ready", ctypes.c_int),
    ]


def build_library() -> None:
    result = subprocess.run(
        [str(PROJECT / "scripts/build_startup_menu.sh")],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr or result.stdout)


def load_library(path: Path | None = None) -> ctypes.CDLL:
    requested_path = LIBRARY if path is None else Path(path)
    if not requested_path.is_file():
        if requested_path.resolve() == LIBRARY.resolve():
            build_library()
        else:
            raise FileNotFoundError(f"startup menu library does not exist: {requested_path}")
    resolved_path = requested_path.resolve()
    library = ctypes.CDLL(str(resolved_path))
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
    return library


class StartupMenuTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def test_load_library_uses_requested_nondefault_path(self) -> None:
        with tempfile.TemporaryDirectory(prefix="startup-menu-library-") as tmpdir:
            alternate_path = Path(tmpdir) / "alternate-startup-menu.dylib"
            shutil.copy2(LIBRARY, alternate_path)
            library = load_library(alternate_path)
            self.assertEqual(Path(library._name).resolve(), alternate_path.resolve())
            self.assertTrue(library.startup_menu_step.argtypes)
            self.assertIsNotNone(library.startup_menu_step.restype)

    def test_load_library_rejects_missing_nondefault_path(self) -> None:
        with tempfile.TemporaryDirectory(prefix="startup-menu-missing-") as tmpdir:
            missing_path = Path(tmpdir) / "does-not-exist.dylib"
            with self.assertRaisesRegex(FileNotFoundError, "does not exist"):
                load_library(missing_path)

    def create_menu(
        self,
        *,
        initial_tick: int = 0,
        disabled_mask: int = (1 << 3) | (1 << 4),
        feedback_ms: int = 0,
    ) -> int:
        if not REAL_BOOT.is_file():
            self.skipTest(f"decoded original BOOT is unavailable: {REAL_BOOT}")
        data = REAL_BOOT.read_bytes()
        storage = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        error = ctypes.create_string_buffer(256)
        boot = self.library.engine_boot_open_memory(
            ctypes.cast(storage, ctypes.c_void_p), len(data), error, len(error)
        )
        self.assertTrue(boot, error.value.decode("utf-8", "replace"))
        config = StartupMenuConfig(disabled_mask, feedback_ms)
        menu = self.library.startup_menu_create(
            boot, ctypes.byref(config), initial_tick, error, len(error)
        )
        self.library.engine_boot_close(boot)
        self.assertTrue(menu, error.value.decode("utf-8", "replace"))
        return menu

    def step(
        self,
        menu: int,
        *,
        tick: int,
        x: int = 0,
        y: int = 0,
        pointer: bool = False,
        down: bool = False,
        pressed: bool = False,
        released: bool = False,
        sound_complete: bool = True,
    ) -> StartupMenuFrame:
        event = StartupMenuInput(
            tick,
            x,
            y,
            int(pointer),
            int(down),
            int(pressed),
            int(released),
            int(sound_complete),
        )
        frame = StartupMenuFrame()
        self.assertEqual(
            self.library.startup_menu_step(menu, ctypes.byref(event), ctypes.byref(frame)),
            STARTUP_MENU_OK,
        )
        return frame

    def enter_main_menu(self, menu: int) -> StartupMenuFrame:
        partner = self.step(menu, tick=1, pressed=True)
        self.assertEqual(partner.stage, COMPANY_LOGO)
        company = self.step(menu, tick=2, pressed=True)
        self.assertEqual(company.stage, MAIN_MENU)
        return company

    def test_logo_threshold_is_strictly_greater_than_4000_ms(self) -> None:
        menu = self.create_menu(initial_tick=100)
        try:
            self.assertEqual(self.step(menu, tick=4100).stage, PARTNER_SPLASH)
            company = self.step(menu, tick=4101)
            self.assertEqual(company.stage, COMPANY_LOGO)
            self.assertEqual(company.resource_name, b"LOGO")
            self.assertEqual(company.full_screen_image, 1)
            self.assertEqual(self.step(menu, tick=8101).stage, COMPANY_LOGO)
            main = self.step(menu, tick=8102)
            self.assertEqual(main.stage, MAIN_MENU)
            self.assertEqual(main.resource_name, b"MAIN")
        finally:
            self.library.startup_menu_destroy(menu)

    def test_logo_elapsed_time_uses_unsigned_wraparound(self) -> None:
        initial = 0xFFFFFF00
        menu = self.create_menu(initial_tick=initial)
        try:
            at_4000 = (initial + 4000) & 0xFFFFFFFF
            at_4001 = (initial + 4001) & 0xFFFFFFFF
            self.assertEqual(self.step(menu, tick=at_4000).stage, PARTNER_SPLASH)
            self.assertEqual(self.step(menu, tick=at_4001).stage, COMPANY_LOGO)
            self.assertEqual(self.step(menu, tick=(at_4001 + 4000) & 0xFFFFFFFF).stage,
                             COMPANY_LOGO)
            self.assertEqual(self.step(menu, tick=(at_4001 + 4001) & 0xFFFFFFFF).stage,
                             MAIN_MENU)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_click_skips_each_logo(self) -> None:
        menu = self.create_menu(initial_tick=1000)
        try:
            self.assertEqual(self.step(menu, tick=1001, pressed=True).stage, COMPANY_LOGO)
            self.assertEqual(self.step(menu, tick=1002, down=True).stage, COMPANY_LOGO)
            self.assertEqual(self.step(menu, tick=1003, pressed=True).stage, MAIN_MENU)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_real_menu_record_rectangles_and_asset_names(self) -> None:
        menu = self.create_menu()
        try:
            frame = self.enter_main_menu(menu)
            self.assertEqual(frame.resource_name, b"MAIN")
            self.assertEqual(frame.has_background, 1)
            self.assertEqual(frame.background_source.values(), (0, 0, 639, 479))
            self.assertEqual(frame.background_destination.values(), (0, 0, 639, 479))
            self.assertEqual(frame.button_count, 9)
            destination_rects = [
                (198, 271, 357, 295),
                (193, 33, 385, 57),
                (146, 83, 404, 107),
                (150, 129, 383, 153),
                (140, 176, 381, 200),
                (165, 223, 375, 251),
                (192, 412, 367, 436),
                (198, 317, 342, 345),
                (157, 363, 400, 392),
            ]
            pressed_rects = [
                (455, 507, 614, 531),
                (1, 507, 193, 531),
                (195, 507, 453, 531),
                (1, 585, 234, 609),
                (236, 585, 477, 609),
                (1, 667, 211, 695),
                (213, 663, 388, 687),
                (479, 589, 623, 617),
                (390, 680, 633, 709),
            ]
            disabled_rects = [
                (455, 533, 614, 557),
                (1, 533, 193, 557),
                (195, 533, 453, 557),
                (1, 611, 234, 635),
                (236, 611, 477, 635),
                (1, 697, 211, 725),
                (213, 689, 388, 713),
                (479, 619, 623, 647),
                (390, 711, 633, 740),
            ]
            hover_rects = [
                (455, 481, 614, 505),
                (1, 481, 193, 505),
                (195, 481, 453, 505),
                (1, 559, 234, 583),
                (236, 559, 477, 583),
                (1, 637, 211, 665),
                (213, 637, 388, 661),
                (479, 559, 623, 587),
                (390, 649, 633, 678),
            ]
            for index, expected in enumerate(destination_rects):
                button = frame.buttons[index]
                self.assertEqual(button.hit_rect.values(), expected)
                self.assertEqual(button.destination_rect.values(), expected)
            self.assertEqual(
                frame.buttons[1].hit_rect.values(), destination_rects[1]
            )
            # All three state-source tables are decoded from their original
            # MENU offsets, while normal copies reuse the destination RECT.
            hover = self.step(menu, tick=10, x=250, y=45, pointer=True)
            self.assertEqual(
                [button.source_rect.values() for button in hover.buttons],
                [disabled_rects[i] if i in (3, 4) else hover_rects[i] if i == 1 else destination_rects[i]
                 for i in range(9)],
            )
            pressed = self.step(menu, tick=11, x=250, y=45, pointer=True, down=True)
            self.assertEqual(
                [button.source_rect.values() for button in pressed.buttons],
                [disabled_rects[i] if i in (3, 4) else pressed_rects[i] if i == 1 else destination_rects[i]
                 for i in range(9)],
            )
            self.assertEqual(frame.buttons[1].command, COMMAND_NEW_GAME)
            self.assertEqual(frame.buttons[0].command, COMMAND_CREDITS)
            self.assertEqual(frame.buttons[2].command, COMMAND_LOAD)
            self.assertEqual(frame.buttons[3].command, COMMAND_CONTINUE)
            self.assertEqual(frame.buttons[4].command, COMMAND_SECOND_CHANCE)
            self.assertEqual(frame.buttons[5].command, COMMAND_SETUP)
            self.assertEqual(frame.buttons[6].command, COMMAND_EXIT_GAME)
            self.assertEqual(frame.buttons[7].command, COMMAND_HELP)
            self.assertEqual(frame.buttons[8].command, COMMAND_PROMO)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_button_hitbox_inclusive_edges_and_original_ten_pixel_hotspot(self) -> None:
        menu = self.create_menu()
        try:
            self.enter_main_menu(menu)
            cases = [
                ((193, 33), 1),
                ((385, 57), 1),
                ((192, 45), -1),
                ((386, 45), -1),
                ((250, 32), -1),
                ((250, 67), 1),
                ((250, 68), -1),
            ]
            for tick, (point, expected) in enumerate(cases, start=10):
                frame = self.step(menu, tick=tick, x=point[0], y=point[1], pointer=True)
                self.assertEqual(frame.hovered_button, expected, f"point={point}")
        finally:
            self.library.startup_menu_destroy(menu)

    def test_render_plan_selects_hover_pressed_and_disabled_sources(self) -> None:
        menu = self.create_menu()
        try:
            self.enter_main_menu(menu)
            hover = self.step(menu, tick=10, x=250, y=45, pointer=True)
            self.assertEqual(hover.buttons[1].visual, BUTTON_HOVER)
            self.assertEqual(hover.buttons[1].source_rect.values(), (1, 481, 193, 505))
            self.assertEqual(hover.buttons[1].destination_rect.values(), (193, 33, 385, 57))
            self.assertEqual(hover.buttons[3].visual, BUTTON_DISABLED)
            self.assertEqual(hover.buttons[3].source_rect.values(), (1, 611, 234, 635))
            self.assertEqual(hover.buttons[4].visual, BUTTON_DISABLED)

            pressed = self.step(menu, tick=11, x=250, y=45, pointer=True, down=True)
            self.assertEqual(pressed.buttons[1].visual, BUTTON_PRESSED)
            self.assertEqual(pressed.buttons[1].source_rect.values(), (1, 507, 193, 531))
            self.assertEqual(pressed.command_ready, 0)

            moved = self.step(menu, tick=12, x=250, y=95, pointer=True,
                              sound_complete=False)
            self.assertEqual(moved.hovered_button, 1)
            self.assertEqual(moved.buttons[1].visual, BUTTON_PRESSED)
            self.assertEqual(moved.buttons[2].visual, BUTTON_NORMAL)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_original_hover_arm_is_shared_across_buttons_and_disabled_rects(self) -> None:
        menu = self.create_menu()
        try:
            self.enter_main_menu(menu)
            self.step(menu, tick=10, x=250, y=45, pointer=True)
            disabled = self.step(menu, tick=11, x=250, y=140, pointer=True)
            self.assertEqual(disabled.hovered_button, -1)
            self.assertEqual(disabled.buttons[3].visual, BUTTON_DISABLED)
            selected = self.step(menu, tick=12, x=250, y=95, pointer=True, down=True)
            self.assertEqual(selected.pressed_button, 2)
            self.assertEqual(selected.buttons[2].visual, BUTTON_PRESSED)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_click_request_waits_for_strict_deadline_and_sound_completion(self) -> None:
        menu = self.create_menu(feedback_ms=5)
        try:
            self.enter_main_menu(menu)
            self.step(menu, tick=10, x=250, y=45, pointer=True)
            pending = self.step(menu, tick=20, x=250, y=45, pointer=True, down=True)
            self.assertEqual(pending.command_ready, 0)
            self.assertEqual(
                self.step(menu, tick=25, sound_complete=True).command_ready,
                0,
                "the original deadline comparison is strictly less-than",
            )
            waiting = self.step(menu, tick=26, sound_complete=False)
            self.assertEqual(waiting.command_ready, 0)
            ready = self.step(menu, tick=27, sound_complete=True)
            self.assertEqual(ready.stage, COMMAND_PENDING)
            self.assertEqual(ready.command_ready, 1)
            self.assertEqual(ready.requested_command, COMMAND_NEW_GAME)
        finally:
            self.library.startup_menu_destroy(menu)

    def test_disabled_continue_buttons_cannot_be_hovered_or_requested(self) -> None:
        menu = self.create_menu()
        try:
            self.enter_main_menu(menu)
            frame = self.step(menu, tick=10, x=250, y=140, pointer=True, down=True)
            self.assertEqual(frame.hovered_button, -1)
            self.assertEqual(frame.buttons[3].visual, BUTTON_DISABLED)
            self.assertEqual(frame.buttons[4].visual, BUTTON_DISABLED)
            self.assertEqual(frame.command_ready, 0)
        finally:
            self.library.startup_menu_destroy(menu)


if __name__ == "__main__":
    unittest.main()
