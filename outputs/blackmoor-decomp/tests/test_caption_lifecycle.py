"""S05-2 caption lifecycle: ctypes bindings, recording backend and unit tests."""

from __future__ import annotations

import ctypes as c
import struct
import unittest
from pathlib import Path

import test_caption_layout as layout

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libcaptionlifecycle.dylib"

OK, ERR_ARGUMENT, ERR_FORMAT, ERR_UNSUPPORTED, ERR_FATAL, ERR_BACKEND = range(6)
BOX_BYTES = 0x995
SCTB_BYTES = 0x300
SLIDER = 0x4B7
OPAQUE, KEYED = 1, 2


class Rect(c.Structure):
    _fields_ = [("left", c.c_int32), ("top", c.c_int32), ("right", c.c_int32),
                ("bottom", c.c_int32)]

    def tuple(self):
        return (self.left, self.top, self.right, self.bottom)


class LifeGlobals(c.Structure):
    _fields_ = [
        ("framed_layer_enabled", c.c_int32), ("caption_layer_enabled", c.c_int32),
        ("caption_restore_layer", c.c_int32), ("caption_clear_counter", c.c_int16),
        ("first_render_level", c.c_int16), ("popup_gate", c.c_int32),
        ("popup_aux", c.c_int32), ("modal_input", c.c_int32), ("overlay_ui", c.c_int32),
        ("framed_clear_request", c.c_int32), ("framed_clear_counter", c.c_int16),
        ("convo_restore_layer", c.c_int32), ("scroll_fraction", c.c_float),
        ("scroll_src", Rect), ("taskbar_mode", c.c_int32), ("scene_request", c.c_int32),
        ("scene_request_flag", c.c_int32), ("engine_state", c.c_int32),
        ("mouse_vk", c.c_int32 * 2), ("input_cursor", c.c_int32 * 2),
        ("mouse_down", c.c_uint8 * 2), ("cursor_rect", Rect), ("cursor_type", c.c_int32),
        ("cursor_variant", c.c_int32), ("cursor_override", c.c_int32),
        ("held_item", c.c_int32), ("cursor_alt", c.c_int32), ("cursor_surface", c.c_uint32),
        ("default_cursor_surface", c.c_uint32), ("item_cursor_surface", c.c_uint32),
        ("cursor_src_index", c.c_int32), ("cursor_layer_enabled", c.c_int32),
        ("cursor_hot", c.c_int32 * 2), ("slider_cursor_scene", c.c_int32),
        ("timed_armed", c.c_int32), ("timed_deadline", c.c_uint32),
        ("game_clock", c.c_uint32),
    ]


class Taskbar(c.Structure):
    _fields_ = [("saved_surface", c.c_uint32), ("area_src", Rect), ("area_dst", Rect),
                ("cc_rect", Rect)]


class Blit(c.Structure):
    _fields_ = [("kind", c.c_int), ("surface", c.c_uint32), ("src", Rect), ("dst", Rect),
                ("label", c.c_char_p)]


class CursorGeometry(c.Structure):
    _fields_ = [("hot_dx", c.c_int32), ("hot_dy", c.c_int32), ("rect_dx", c.c_int32),
                ("rect_dy", c.c_int32), ("width", c.c_int16), ("height", c.c_int16)]


LOAD_IMAGE = c.CFUNCTYPE(c.c_uint32, c.c_void_p, c.c_char_p, c.c_char_p)
SOUND = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8))
UNSOUND = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(c.c_uint8))
PLAY = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16)
KEY = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32)
POS = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(c.c_int32), c.POINTER(c.c_int32))
GEOM = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32, c.c_int32, c.POINTER(CursorGeometry))
BLIT = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(Blit))
WRITE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t)
SIMPLE = c.CFUNCTYPE(c.c_int, c.c_void_p)
FATAL = c.CFUNCTYPE(None, c.c_void_p, c.c_char_p)


class Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("load_image", LOAD_IMAGE), ("load_sound", SOUND),
                ("unload_sound", UNSOUND), ("play_sound", PLAY), ("key_down", KEY),
                ("cursor_pos", POS), ("cursor_geometry", GEOM), ("blit", BLIT),
                ("write_framed_text", WRITE), ("convo_restore", SIMPLE), ("fatal", FATAL)]


class Lifecycle(c.Structure):
    _fields_ = [("box", c.c_uint8 * BOX_BYTES), ("g", LifeGlobals),
                ("shared", c.POINTER(layout.Globals)),
                ("geometry", c.POINTER(layout.Geometry)),
                ("view_origin", c.c_int32 * 2), ("taskbar", Taskbar)]


def bind(path: Path = LIBRARY):
    lib = c.CDLL(str(path))
    P, B = c.POINTER(Lifecycle), c.POINTER(Backend)
    for name in ("caption_ctb_init", "caption_ctb_close", "caption_ctb_poll",
                 "caption_ctb_hover", "caption_ctb_click", "caption_ctb_draw",
                 "caption_scene_reset", "caption_taskbar_restore_cc",
                 "caption_taskbar_restore_area"):
        getattr(lib, name).argtypes = [P, B]
        getattr(lib, name).restype = c.c_int
    lib.caption_ctb_load_chunk.argtypes = [P, B, c.POINTER(c.c_uint8), c.c_size_t]
    lib.caption_ctb_open.argtypes = [P, B, c.c_int32, c.POINTER(c.c_uint8), c.c_size_t]
    lib.caption_main_loop_flags.argtypes = [P]
    lib.caption_clear_step.argtypes = [P]
    lib.caption_clear_step.restype = None
    lib.caption_framed_clear_step.argtypes = [P]
    lib.caption_framed_clear_step.restype = None
    lib.caption_clear_slot_step.argtypes = [P, c.c_int16, c.POINTER(c.c_int)]
    lib.caption_timed_dismiss.argtypes = [P]
    lib.caption_timed_dismiss.restype = None
    lib.caption_timed_arm.argtypes = [P, c.c_int16]
    lib.caption_timed_arm.restype = None
    lib.caption_present_layers.argtypes = [P, B, c.c_uint32, c.c_uint32, c.POINTER(Rect)]
    lib.caption_lifecycle_status_string.restype = c.c_char_p
    return lib


def cursor_tables(type_: int, variant: int) -> tuple[int, int, int, int, int, int]:
    """Deterministic fixture values for the CURS-derived cursor tables."""
    return (3 + type_ % 5, 2 + variant, -1 - (type_ % 3), -2, 20 + type_ % 7, 18 + variant)


class Script:
    """Scripted host: input, image handles and failures, shared by both sides."""

    def __init__(self, cursor=(300, 450), left_down=False, fail_image=None,
                 writer_fails=False):
        self.cursor = list(cursor)
        self.left_down = left_down
        self.fail_image = fail_image
        self.writer_fails = writer_fails
        self.handles: dict[tuple[str, str], int] = {}

    def handle_for(self, name: str, purpose: str) -> int:
        if self.fail_image and name == self.fail_image:
            return 0
        key = (name, purpose)
        if key not in self.handles:
            self.handles[key] = 0x70000000 + 0x100 * (len(self.handles) + 1)
        return self.handles[key]


class RecordingBackend:
    def __init__(self, script: Script):
        self.script = script
        self.events: list[tuple] = []
        self.struct = Backend(
            None, LOAD_IMAGE(self._load), SOUND(self._sound), UNSOUND(self._unsound),
            PLAY(self._play), KEY(self._key), POS(self._pos), GEOM(self._geom),
            BLIT(self._blit), WRITE(self._write), SIMPLE(self._convo), FATAL(self._fatal))

    def _load(self, _ctx, name, purpose):
        handle = self.script.handle_for(name.decode(), purpose.decode())
        self.events.append(("load_image", name.decode(), purpose.decode(), handle))
        return handle

    def _sound(self, _ctx, descriptor):
        self.events.append(("load_sound", bytes(descriptor[:33]).split(b"\0")[0].decode()))
        return 0

    def _unsound(self, _ctx, descriptor):
        self.events.append(("unload_sound",))

    def _play(self, _ctx, channel):
        self.events.append(("play_sound", channel))
        return 0

    def _key(self, _ctx, vk):
        return 1 if (vk == 1 and self.script.left_down) else 0

    def _pos(self, _ctx, x, y):
        x[0], y[0] = self.script.cursor

    def _geom(self, _ctx, type_, variant, out):
        hx, hy, rx, ry, w, h = cursor_tables(type_, variant)
        out[0] = CursorGeometry(hx, hy, rx, ry, w, h)
        return 0

    def _blit(self, _ctx, blit):
        b = blit[0]
        self.events.append(("blit", b.kind, b.surface, b.src.tuple(), b.dst.tuple()))
        return 0

    def _write(self, _ctx, text, capacity):
        raw = bytes(text[:capacity])
        self.events.append(("write_framed", raw.split(b"\0")[0]))
        return 1 if self.script.writer_fails else 0

    def _convo(self, _ctx):
        self.events.append(("convo_restore",))
        return 0

    def _fatal(self, _ctx, message):
        self.events.append(("fatal",))


def make_life(data: layout.ShippedData, geometry: layout.Geometry, shared=None):
    life = Lifecycle()
    life.shared = c.pointer(shared or layout.Globals())
    life.geometry = c.pointer(geometry)
    life.g.mouse_vk[0], life.g.mouse_vk[1] = 1, 2
    life.g.held_item = -1
    life.g.default_cursor_surface = 0x60000010
    life.g.item_cursor_surface = 0x60000020
    life.g.cursor_rect = Rect(300, 450, 310, 460)
    life.taskbar = Taskbar(0x60000030, Rect(0, 0, 639, 90), Rect(0, 389, 639, 479),
                           Rect(10, 400, 629, 424))
    return life


class LifecycleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file() or not layout.LIBRARY.is_file():
            raise unittest.SkipTest("build caption_lifecycle and caption_layout first")
        try:
            cls.data = layout.ShippedData()
        except Exception as exc:  # noqa: BLE001
            raise unittest.SkipTest(f"shipped data unavailable: {exc}")
        cls.lib = bind()
        lay = layout.bind()
        cls.fmt, cls.fonts, cls.geometry = layout.native_context(lay, cls.data)
        boot = cls.data.load_bytes(b"BOOT")
        cls.sctb = layout.hiff_chunks(boot)[b"SCTB"]

    def boot(self, script=None):
        script = script or Script()
        life = make_life(self.data, self.geometry)
        backend = RecordingBackend(script)
        sctb = layout.buf(self.sctb)
        self.assertEqual(self.lib.caption_ctb_load_chunk(c.byref(life), c.byref(backend.struct),
                                                         sctb, len(self.sctb)), OK)
        self.assertEqual(self.lib.caption_ctb_init(c.byref(life), c.byref(backend.struct)), OK)
        return life, backend

    def field(self, life, offset):
        return struct.unpack_from("<i", bytes(life.box), offset)[0]

    def test_shipped_sctb_has_slider_and_no_button(self):
        life, backend = self.boot()
        self.assertEqual(self.field(life, 0x15F), 0)
        self.assertEqual(self.field(life, 0x252), 1)
        self.assertEqual(bytes(life.box[0x2C:0x3C]).split(b"\0")[0], b"UIConvoPopup_OVL")
        # Boot: init sets modal input, loads the slider art, poll loads the popup.
        self.assertEqual(life.g.modal_input, 1)
        self.assertEqual([e[2] for e in backend.events if e[0] == "load_image"],
                         ["UI Slider", "UI Button restore", "UI Popup"])
        self.assertEqual(self.field(life, 0x4AF), 5)

    def test_open_close_s5900_curl00(self):
        life, backend = self.boot()
        text = layout.buf(b"<n><e>\0", 16)
        self.assertEqual(self.lib.caption_ctb_open(c.byref(life), c.byref(backend.struct), 2,
                                                   text, 16), OK)
        shared = life.shared[0]
        self.assertEqual((shared.framed_ready, shared.frame_open, life.g.framed_layer_enabled,
                          life.g.first_render_level, life.g.taskbar_mode,
                          self.field(life, 0x991)), (1, 1, 1, 1, 2, 2))
        self.assertIn(("write_framed", b"<n><e>"), backend.events)
        for _ in range(3):  # wait-mode 0: the box never closes itself
            self.assertEqual(self.lib.caption_ctb_poll(c.byref(life), c.byref(backend.struct)), OK)
            self.assertEqual(life.shared[0].frame_open, 1)
        self.assertEqual(self.field(life, 0x4AF), 2)
        self.assertEqual(self.lib.caption_ctb_close(c.byref(life), c.byref(backend.struct)), OK)
        self.assertEqual((life.shared[0].framed_ready, life.shared[0].frame_open,
                          life.g.framed_layer_enabled, self.field(life, 0x991),
                          life.g.taskbar_mode), (0, 0, 0, 0, 1))

    def test_empty_text_skips_writer(self):
        life, backend = self.boot()
        self.assertEqual(self.lib.caption_ctb_open(c.byref(life), c.byref(backend.struct), 2,
                                                   layout.buf(b"\0"), 1), OK)
        self.assertNotIn("write_framed", [e[0] for e in backend.events])

    def test_writer_failure_is_fatal_before_state(self):
        life, backend = self.boot(Script(writer_fails=True))
        status = self.lib.caption_ctb_open(c.byref(life), c.byref(backend.struct), 2,
                                           layout.buf(b"x<n>\0"), 5)
        self.assertEqual((status, life.shared[0].frame_open), (ERR_FATAL, 0))

    def test_image_failure_is_fatal_in_source_order(self):
        script = Script(fail_image="UIConvoPopup_OVL")
        life = make_life(self.data, self.geometry)
        backend = RecordingBackend(script)
        self.lib.caption_ctb_load_chunk(c.byref(life), c.byref(backend.struct),
                                        layout.buf(self.sctb), len(self.sctb))
        self.assertEqual(self.lib.caption_ctb_init(c.byref(life), c.byref(backend.struct)),
                         ERR_FATAL)
        self.assertEqual(backend.events[-1], ("fatal",))
        # The slider art shares the popup sheet name, so the failure happens in
        # slider init (0x4ef89b), before init reaches the modal-input write.
        self.assertEqual(backend.events[-2][:3], ("load_image", "UIConvoPopup_OVL", "UI Slider"))
        self.assertEqual((life.g.modal_input, struct.unpack_from("<i", bytes(life.box), 0x2C + 0)[0]
                          != 0), (0, True))

    def test_short_chunk_is_rejected_without_reading(self):
        life = make_life(self.data, self.geometry)
        backend = RecordingBackend(Script())
        self.assertEqual(self.lib.caption_ctb_load_chunk(c.byref(life), c.byref(backend.struct),
                                                         layout.buf(self.sctb), 0x2FF), ERR_FATAL)
        self.assertEqual(bytes(life.box), bytes(BOX_BYTES))

    def test_button_config_is_unsupported(self):
        sctb = bytearray(self.sctb)
        struct.pack_into("<i", sctb, 0x15F - 0x2C, 1)
        life = make_life(self.data, self.geometry)
        backend = RecordingBackend(Script())
        self.lib.caption_ctb_load_chunk(c.byref(life), c.byref(backend.struct),
                                        layout.buf(bytes(sctb)), len(sctb))
        self.assertEqual(self.lib.caption_ctb_init(c.byref(life), c.byref(backend.struct)),
                         ERR_UNSUPPORTED)

    def test_caption_two_frame_clear_and_layers(self):
        life, backend = self.boot()
        sh = life.shared[0]
        sh.caption_visible_flag = 1
        self.lib.caption_main_loop_flags(c.byref(life))
        self.assertEqual(life.g.caption_layer_enabled, 1)
        sh = life.shared[0]
        sh.caption_finish_flag = 1
        life.shared[0] = sh
        life.g.caption_clear_counter = -1
        self.lib.caption_main_loop_flags(c.byref(life))
        self.assertEqual((life.g.caption_layer_enabled, life.g.caption_restore_layer,
                          life.shared[0].caption_visible_flag, life.shared[0].caption_finish_flag,
                          life.g.caption_clear_counter), (0, 1, 0, 1, 0))
        self.lib.caption_main_loop_flags(c.byref(life))
        self.assertEqual((life.g.caption_restore_layer, life.shared[0].caption_finish_flag,
                          life.g.caption_clear_counter), (0, 0, -1))

    def test_timed_dismiss_unsigned_and_wrap(self):
        life, _ = self.boot()
        life.g.game_clock = 0xFFFFFFF0
        self.lib.caption_timed_arm(c.byref(life), 0x20)
        self.assertEqual(life.g.timed_deadline, 0x10)
        self.lib.caption_timed_dismiss(c.byref(life))
        # Wrapped deadline is already "before" the clock: dismiss immediately.
        self.assertEqual((life.g.timed_armed, life.shared[0].caption_finish_flag), (0, 1))

    def test_status_strings(self):
        self.assertEqual(self.lib.caption_lifecycle_status_string(ERR_FATAL),
                         b"original fatal path")


if __name__ == "__main__":
    unittest.main()
