"""S05 caption layout: shared bindings, shipped-data fixtures and unit tests."""

from __future__ import annotations

import ctypes as c
import hashlib
import json
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
import os
LIBRARY = Path(os.environ.get("CAPTION_LAYOUT_LIBRARY", PROJECT / "build/libcaptionlayout.dylib"))
RESOURCES_LIBRARY = PROJECT / "build/libgameresources.dylib"
PIXELS_LIBRARY = PROJECT / "build/libcifpixels.dylib"
GAME_SOURCE = ROOT / "work/analysis/game-source.json"

OK, ERR_ARGUMENT, ERR_FORMAT, ERR_LIMIT, ERR_BOUNDS, ERR_FONT, ERR_UNSUPPORTED, \
    ERR_BACKEND, ERR_TOO_LONG = range(9)
FONT_RECORD = 0x7F3
GLYPHS = 115
MAX_FONTS = 18
RGB555 = (0x7C00, 0x03E0, 0x001F)
RGB565 = (0xF800, 0x07E0, 0x001F)


class PixelFormat(c.Structure):
    _fields_ = [("shifts", c.c_uint8 * 3), ("masks", c.c_uint8 * 3),
                ("channel_bits", c.c_uint8 * 3), ("color_key", c.c_uint16)]


class Surface(c.Structure):
    _fields_ = [("pixels", c.POINTER(c.c_uint8)), ("width", c.c_int16),
                ("height", c.c_int16), ("pitch", c.c_int16)]


class Fonts(c.Structure):
    _fields_ = [("count", c.c_int16),
                ("records", (c.c_uint8 * FONT_RECORD) * MAX_FONTS),
                ("glyph_size", ((c.c_int16 * 2) * GLYPHS) * MAX_FONTS)]


class Geometry(c.Structure):
    _fields_ = [("tbox", c.c_uint8 * 98), ("framed_surface_width", c.c_int16),
                ("framed_surface_height", c.c_int16),
                ("caption_surface_width", c.c_int16),
                ("caption_surface_height", c.c_int16)]


class TextBox(c.Structure):
    _fields_ = [("too_long_reported", c.c_int32), ("left_margin", c.c_int16),
                ("underline", c.c_int32), ("underline_color", c.c_uint16),
                ("tight_spacing", c.c_int32), ("half_spacing", c.c_int32)]


class Globals(c.Structure):
    _fields_ = [("caption_finish_flag", c.c_int32), ("caption_visible_flag", c.c_int32),
                ("framed_ready", c.c_int32), ("framed_scroll_lines", c.c_int16),
                ("frame_open", c.c_uint8), ("sheet_refcount", c.c_int16 * MAX_FONTS),
                ("sheets", Surface * MAX_FONTS)]


LOAD = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.c_char_p, c.POINTER(Surface))
RELEASE = c.CFUNCTYPE(None, c.c_void_p, c.c_int16, c.POINTER(Surface))
SIMPLE = c.CFUNCTYPE(c.c_int, c.c_void_p)
LOG = c.CFUNCTYPE(None, c.c_void_p, c.c_char_p)


class Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("load_font_sheet", LOAD),
                ("release_font_sheet", RELEASE), ("close_frame_text", SIMPLE),
                ("restore_caption_box", SIMPLE), ("debug_log", LOG)]


class Request(c.Structure):
    _fields_ = [("text", c.POINTER(c.c_uint8)), ("text_capacity", c.c_size_t),
                ("mode", c.c_int16), ("measure", c.c_uint8), ("debug_mode", c.c_uint8)]


class Result(c.Structure):
    _fields_ = [("lines", c.c_int16), ("terminator_appended", c.c_uint8),
                ("surface_cleared", c.c_uint8), ("glyphs_drawn", c.c_uint32),
                ("underline_fills", c.c_uint32), ("pen_x", c.c_int16),
                ("pen_y", c.c_int16)]


class CifImage(c.Structure):
    _fields_ = [("name", c.c_char * 33), ("id", c.c_uint16), ("width", c.c_uint16),
                ("pitch", c.c_uint16), ("height", c.c_uint16), ("depth", c.c_uint16),
                ("pixels", c.c_void_p), ("byte_count", c.c_size_t)]


class CifPixelFormat(c.Structure):
    _fields_ = [("enabled", c.c_uint32), ("shifts", c.c_uint8 * 3),
                ("channel_bits", c.c_int8 * 3)]


def bind(path: Path = LIBRARY):
    lib = c.CDLL(str(path))
    lib.caption_pixel_format_from_masks.argtypes = [
        c.c_uint32, c.c_uint32, c.c_uint32, c.POINTER(c.c_uint8), c.POINTER(PixelFormat)]
    lib.caption_fonts_init.argtypes = [c.POINTER(c.c_uint8), c.c_size_t, c.c_int16,
                                       c.POINTER(Fonts)]
    lib.caption_geometry_init.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
                                          c.POINTER(Geometry)]
    lib.caption_font_sheet_name.argtypes = [c.POINTER(Fonts), c.c_int16]
    lib.caption_font_sheet_name.restype = c.c_char_p
    lib.caption_layout_write.argtypes = [
        c.POINTER(Fonts), c.POINTER(Geometry), c.POINTER(PixelFormat), c.POINTER(TextBox),
        c.POINTER(Globals), c.POINTER(Backend), c.POINTER(Surface), c.POINTER(Request),
        c.POINTER(Result)]
    lib.caption_status_string.restype = c.c_char_p
    return lib


def buf(data: bytes, size: int | None = None):
    size = max(1, size if size is not None else len(data))
    out = (c.c_uint8 * size)()
    c.memmove(out, data, min(len(data), size))
    return out


def hiff_chunks(record: bytes) -> dict[bytes, bytes]:
    """Top-level chunks of one decoded DATA record (first occurrence)."""
    if record[:4] != b"DATA":
        raise ValueError("not a HIFF DATA record")
    out: dict[bytes, bytes] = {}
    offset, end = 12, 8 + int.from_bytes(record[4:8], "big")
    while offset + 8 <= end:
        cid = record[offset:offset + 4]
        n = int.from_bytes(record[offset + 4:offset + 8], "big")
        out.setdefault(cid, record[offset + 8:offset + 8 + n])
        offset += 8 + n + (n & 1)
    return out


class ShippedData:
    """BOOT/FONT bytes and font sheets loaded with the game's own precedence."""

    def __init__(self) -> None:
        game = Path(json.loads(GAME_SOURCE.read_text())["game_dir"]) / "Ciftree"
        self.res = c.CDLL(str(RESOURCES_LIBRARY))
        self.res.game_resources_open.argtypes = [c.c_char_p, c.c_int, c.c_char_p, c.c_size_t]
        self.res.game_resources_open.restype = c.c_void_p
        self.res.game_resources_load_bytes.argtypes = [
            c.c_void_p, c.c_char_p, c.c_void_p, c.c_char_p, c.c_size_t]
        self.res.game_resources_load_image.argtypes = [
            c.c_void_p, c.c_char_p, c.POINTER(CifImage), c.POINTER(c.c_int), c.c_char_p,
            c.c_size_t]
        self.pix = c.CDLL(str(PIXELS_LIBRARY))
        self.pix.cif_pixels_convert_555.argtypes = [
            c.POINTER(c.c_uint8), c.c_uint32, c.POINTER(CifPixelFormat)]
        error = c.create_string_buffer(256)
        self.manager = self.res.game_resources_open(str(game).encode(), 1, error, 256)
        if not self.manager:
            raise RuntimeError(error.value.decode())
        boot = self.load_bytes(b"BOOT")
        font = self.load_bytes(b"FONT")
        boot_chunks = hiff_chunks(boot)
        self.bsum = boot_chunks[b"BSUM"]
        self.tbox = boot_chunks[b"TBOX"]
        self.font_chunk = hiff_chunks(font)[b"FONT"]
        self.font_count = int.from_bytes(self.bsum[337:339], "little", signed=True)
        self.transparent = bytes(self.bsum[324:327])
        self._sheets: dict[tuple[bytes, tuple[int, ...]], tuple[bytes, int, int, int]] = {}

    def load_bytes(self, name: bytes) -> bytes:
        class Bytes(c.Structure):
            _fields_ = [("bytes", c.POINTER(c.c_uint8)), ("length", c.c_size_t),
                        ("type", c.c_uint8), ("source", c.c_int)]
        out = Bytes()
        error = c.create_string_buffer(256)
        if self.res.game_resources_load_bytes(self.manager, name, c.byref(out), error, 256) != 1:
            raise RuntimeError(f"{name!r}: {error.value.decode()}")
        return c.string_at(out.bytes, out.length)

    def sheet(self, name: bytes, fmt: PixelFormat) -> tuple[bytes, int, int, int] | None:
        """Sheet pixels converted with the original 0x4c7314 conversion."""
        key = (name, tuple(fmt.shifts) + tuple(fmt.channel_bits))
        if key not in self._sheets:
            image = CifImage()
            source = c.c_int()
            error = c.create_string_buffer(256)
            if self.res.game_resources_load_image(self.manager, name, c.byref(image),
                                                  c.byref(source), error, 256) != 1:
                return None
            data = (c.c_uint8 * image.byte_count)()
            c.memmove(data, image.pixels, image.byte_count)
            conv = CifPixelFormat(1, (c.c_uint8 * 3)(*fmt.shifts),
                                  (c.c_int8 * 3)(*fmt.channel_bits))
            self.pix.cif_pixels_convert_555(data, image.byte_count, c.byref(conv))
            self._sheets[key] = (bytes(data), image.width, image.height, image.pitch)
        return self._sheets[key]


def native_context(lib, data: ShippedData, masks=RGB555):
    fmt = PixelFormat()
    status = lib.caption_pixel_format_from_masks(*masks, buf(data.transparent), c.byref(fmt))
    assert status == OK, status
    fonts = Fonts()
    status = lib.caption_fonts_init(buf(data.font_chunk), len(data.font_chunk),
                                    data.font_count, c.byref(fonts))
    assert status == OK, status
    geometry = Geometry()
    status = lib.caption_geometry_init(buf(data.tbox), len(data.tbox), c.byref(geometry))
    assert status == OK, status
    return fmt, fonts, geometry


class SheetBackend:
    """Native backend that serves shipped font sheets and records events."""

    def __init__(self, data: ShippedData, fmt: PixelFormat, fail_load=False,
                 fail_close=False, fail_restore=False, missing=frozenset()) -> None:
        self.data, self.fmt = data, fmt
        self.missing = missing
        self.fail_load, self.fail_close, self.fail_restore = fail_load, fail_close, fail_restore
        self.events: list[tuple] = []
        self.held: dict[int, object] = {}
        # Optional live views so events capture callback-time state.
        self.observe_pixels = None
        self.observe_globals = None
        self.struct = Backend(None, LOAD(self._load), RELEASE(self._release),
                              SIMPLE(self._close), SIMPLE(self._restore), LOG(self._log))

    def _observed(self):
        if self.observe_globals is None:
            return ()
        g = self.observe_globals
        digest = (hashlib.sha256(bytes(self.observe_pixels)).hexdigest()[:16]
                  if self.observe_pixels is not None else None)
        return (digest, g.caption_visible_flag, g.caption_finish_flag, g.frame_open,
                tuple(g.sheet_refcount))

    def _load(self, _ctx, font, name, sheet):
        self.events.append(("load", font, name) + self._observed())
        found = None if self.fail_load or font in self.missing else \
            self.data.sheet(name, self.fmt)
        if found is None:
            return 1
        pixels, width, height, pitch = found
        storage = buf(pixels)
        self.held[font] = storage
        sheet[0] = Surface(c.cast(storage, c.POINTER(c.c_uint8)), width, height, pitch)
        return 0

    def _release(self, _ctx, font, _sheet):
        self.events.append(("release", font))
        self.held.pop(font, None)

    def _close(self, _ctx):
        self.events.append(("close_frame_text",) + self._observed())
        return 1 if self.fail_close else 0

    def _log(self, _ctx, message):
        self.events.append(("debug_log",))
        self.messages = getattr(self, "messages", []) + [message]

    def _restore(self, _ctx):
        self.events.append(("restore_caption_box",) + self._observed())
        return 1 if self.fail_restore else 0


def make_surface(width: int, height: int, fill: int = 0xA5A5):
    pixels = (c.c_uint8 * (width * height * 2))()
    word = fill.to_bytes(2, "little")
    c.memmove(pixels, word * (width * height), width * height * 2)
    return Surface(c.cast(pixels, c.POINTER(c.c_uint8)), width, height, width * 2), pixels


def native_write(lib, fmt, fonts, geometry, backend, text: bytes, mode: int, measure: int,
                 surface=None, globals_=None, box=None, capacity=None, debug=0):
    capacity = capacity if capacity is not None else len(text) + 8
    # Capacity beyond the terminator carries the oracle's 0xee pattern.
    storage = buf(text + b"\0" + b"\xee" * max(0, capacity - len(text) - 1), capacity)
    request = Request(c.cast(storage, c.POINTER(c.c_uint8)), capacity, mode, measure, debug)
    box = box or TextBox()
    globals_ = globals_ or Globals()
    result = Result()
    status = lib.caption_layout_write(
        c.byref(fonts), c.byref(geometry), c.byref(fmt), c.byref(box), c.byref(globals_),
        c.byref(backend.struct), c.byref(surface) if surface is not None else None,
        c.byref(request), c.byref(result))
    return status, result, box, globals_, bytes(storage)


# ---------------------------------------------------------------------------
# Unit tests
# ---------------------------------------------------------------------------

import hashlib  # noqa: E402
import struct  # noqa: E402
import unittest  # noqa: E402


def _available() -> str | None:
    for path in (LIBRARY, RESOURCES_LIBRARY, PIXELS_LIBRARY, GAME_SOURCE):
        if not path.exists():
            return f"missing {path}"
    return None


class CaptionLayoutTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        reason = _available()
        if reason:
            raise unittest.SkipTest(reason)
        try:
            cls.data = ShippedData()
        except Exception as exc:  # noqa: BLE001
            raise unittest.SkipTest(f"shipped data unavailable: {exc}")
        cls.lib = bind()
        cls.fmt, cls.fonts, cls.geometry = native_context(cls.lib, cls.data)
        from autotext_original_oracle import RESOURCE_PATH, _read_cvtx_payload, parse_entries
        cls.autotext = {e["key"]: e["caption"]
                        for e in parse_entries(_read_cvtx_payload(RESOURCE_PATH.read_bytes()))}

    def caption_surface(self):
        return make_surface(self.geometry.caption_surface_width,
                            self.geometry.caption_surface_height)

    def framed_surface(self):
        return make_surface(self.geometry.framed_surface_width,
                            self.geometry.framed_surface_height)

    def write(self, text, mode=-1, measure=0, **kw):
        backend = kw.pop("backend", None) or SheetBackend(self.data, self.fmt)
        surface, pixels = (None, None)
        if not measure:
            surface, pixels = (self.framed_surface() if mode == -2 else self.caption_surface())
        status, result, box, globals_, stored = native_write(
            self.lib, self.fmt, self.fonts, self.geometry, backend, text, mode, measure,
            surface=surface, **kw)
        return status, result, globals_, backend, pixels, stored

    def assert_untouched(self, status, expected, globals_, backend, pixels, stored, text):
        self.assertEqual(status, expected)
        self.assertEqual(backend.events, [])
        if pixels is not None:
            self.assertEqual(bytes(pixels), b"\xa5" * len(pixels))
        self.assertEqual(stored[:len(text)], text)
        self.assertEqual(globals_.caption_visible_flag, 0)
        self.assertEqual(tuple(globals_.sheet_refcount), (0,) * MAX_FONTS)

    # -- context ------------------------------------------------------------
    def test_pixel_formats_and_color_key(self):
        fmt = PixelFormat()
        self.assertEqual(self.lib.caption_pixel_format_from_masks(
            *RGB555, buf(bytes([0, 0x1F, 0])), c.byref(fmt)), OK)
        self.assertEqual((list(fmt.shifts), list(fmt.channel_bits), fmt.color_key),
                         ([0, 5, 10], [5, 5, 5], 0x03E0))
        self.assertEqual(self.lib.caption_pixel_format_from_masks(
            *RGB565, buf(bytes([0, 0x1F, 0])), c.byref(fmt)), OK)
        self.assertEqual((list(fmt.shifts), list(fmt.channel_bits), fmt.color_key),
                         ([0, 5, 11], [5, 6, 5], 0x07C0))
        self.assertEqual(self.lib.caption_pixel_format_from_masks(
            0, 0x3E0, 0x1F, buf(b"\0\0\0"), c.byref(fmt)), ERR_ARGUMENT)
        # 0x4c304f..0x4c3089 mask the BOOT RGB before widening 6-bit channels.
        self.assertEqual(self.lib.caption_pixel_format_from_masks(
            *RGB555, buf(b"\xff\xff\xff"), c.byref(fmt)), OK)
        self.assertEqual(fmt.color_key, 0x7FFF)
        self.assertEqual(self.lib.caption_pixel_format_from_masks(
            *RGB565, buf(b"\xff\xff\xff"), c.byref(fmt)), OK)
        self.assertEqual(fmt.color_key, (0x1F << 11 | 0x7E << 5 | 0x1F) & 0xFFFF)

    def test_fonts_and_geometry_validation(self):
        fonts = Fonts()
        chunk = self.data.font_chunk
        self.assertEqual(self.lib.caption_fonts_init(buf(chunk), len(chunk) - 1, 18,
                                                     c.byref(fonts)), ERR_FORMAT)
        self.assertEqual(self.lib.caption_fonts_init(buf(chunk), len(chunk), 19,
                                                     c.byref(fonts)), ERR_FORMAT)
        broken = bytearray(chunk)
        broken[0:33] = b"X" * 33
        self.assertEqual(self.lib.caption_fonts_init(buf(bytes(broken)), len(broken), 18,
                                                     c.byref(fonts)), ERR_FORMAT)
        record = chunk[9 * FONT_RECORD:10 * FONT_RECORD]
        left, top, right, bottom = struct.unpack_from("<iiii", record, 0xC3)
        self.assertEqual(tuple(self.fonts.glyph_size[9][0]), (right - left + 1, bottom - top + 1))
        self.assertEqual(self.lib.caption_font_sheet_name(c.byref(self.fonts), 17), b"FONT09old")
        self.assertIsNone(self.lib.caption_font_sheet_name(c.byref(self.fonts), 18))
        geometry = Geometry()
        self.assertEqual(self.lib.caption_geometry_init(buf(self.data.tbox), 97,
                                                        c.byref(geometry)), ERR_FORMAT)
        self.assertEqual((self.geometry.framed_surface_width, self.geometry.framed_surface_height,
                          self.geometry.caption_surface_width,
                          self.geometry.caption_surface_height), (578, 1001, 623, 201))

    # -- acceptance texts ----------------------------------------------------
    def test_nsht01_and_curl00(self):
        status, result, globals_, backend, pixels, _ = self.write(self.autotext[b"NSHT01"], -1, 1)
        self.assertEqual((status, result.lines), (OK, 2))
        status, result, globals_, backend, pixels, _ = self.write(self.autotext[b"NSHT01"])
        self.assertEqual((status, result.lines, globals_.caption_visible_flag), (OK, 2, 1))
        self.assertGreater(result.glyphs_drawn, 100)
        self.assertEqual(backend.events, [("load", 9, b"FONT09"), ("restore_caption_box",),
                                          ("release", 9)])
        self.assertEqual(self.autotext[b"CURL00"], b"<n>")
        status, result, globals_, backend, pixels, _ = self.write(b"<n>", -2)
        self.assertEqual((status, result.lines, result.glyphs_drawn, globals_.framed_ready,
                          globals_.framed_scroll_lines), (OK, 0, 0, 1, 1))
        self.assertEqual(bytes(pixels), b"\0" * len(pixels))  # framed clears to black

    def test_caption_background_is_color_key(self):
        status, _, _, _, pixels, _ = self.write(b"<n>")
        self.assertEqual(status, OK)
        self.assertEqual(bytes(pixels), struct.pack("<H", self.fmt.color_key) * (len(pixels) // 2))

    # -- terminator and text handling ------------------------------------------
    def test_terminator_append_and_capacity(self):
        status, result, _, _, _, stored = self.write(b"Hi<n>", capacity=len(b"Hi<n>") + 4)
        self.assertEqual((status, result.terminator_appended), (OK, 1))
        self.assertEqual(stored[:9], b"Hi<n><e>\0")
        status, _, globals_, backend, pixels, stored = self.write(b"Hi<n>", capacity=len(b"Hi<n>") + 3)
        self.assert_untouched(status, ERR_LIMIT, globals_, backend, pixels, stored, b"Hi<n>")

    def test_embedded_nul_ends_text(self):
        status, a, _, _, pa, _ = self.write(b"Before<n>")
        status_b, b, _, _, pb, _ = self.write(b"Before<n>\0After<n>")
        self.assertEqual((status, status_b, a.lines, b.lines), (OK, OK, 1, 1))
        self.assertEqual(bytes(pa), bytes(pb))

    def test_text_after_last_break_is_not_drawn(self):
        status, a, _, _, pa, _ = self.write(b"one<n>two<e>")
        status_b, b, _, _, pb, _ = self.write(b"one<n>")
        self.assertEqual((status, status_b, a.glyphs_drawn, b.glyphs_drawn), (OK, OK, 3, 3))
        self.assertEqual(bytes(pa), bytes(pb))

    # -- malformed markup and limits fail before mutation ----------------------
    def test_failures_before_mutation(self):
        cases = [
            (b"abc>def<n>", ERR_UNSUPPORTED),                 # stray '>' before any tag
            (b"x" * 400 + b"<n>", ERR_UNSUPPORTED),            # word wider than the box
            (b"<f30>x<n>", ERR_FONT),                          # font beyond FONT table
            (b"<f-1>x<n>", ERR_FONT),
            (b"<c300>x<n>", ERR_UNSUPPORTED),                  # colour offsets past record
            (b"<f" + b"1" * 26 + b">x<n>", ERR_LIMIT),         # 25-byte tag buffer
            (b"word " * 1000 + b"<n>", ERR_LIMIT),             # 5000-byte text buffer
            (b"<u> <u><n>", ERR_UNSUPPORTED),                  # underline row never set
        ]
        for text, expected in cases:
            status, _, globals_, backend, pixels, stored = self.write(text)
            self.assert_untouched(status, expected, globals_, backend, pixels, stored, text)

    def test_drawing_outside_surface_releases_this_calls_sheets(self):
        text = b"The quick brown fox jumps over the lazy dog. " * 60 + b"<n>"
        status, _, globals_, backend, pixels, stored = self.write(text)
        self.assertEqual(status, ERR_BOUNDS)
        # No rollback after host-visible effects: the target shows the surface
        # as of the last host call (the cleanup release), not the 0xa5 fill.
        self.assertNotEqual(bytes(pixels), b"\xa5" * len(pixels))
        self.assertEqual(globals_.caption_visible_flag, 0)
        self.assertEqual(stored[:len(text)], text)
        self.assertEqual(backend.events, [("load", 9, b"FONT09"), ("release", 9)])
        self.assertEqual((globals_.sheet_refcount[9], bool(globals_.sheets[9].pixels)), (0, False))

    def test_pass_two_failure_keeps_performed_frame_close(self):
        g = Globals()
        g.frame_open = 1
        g.framed_ready = 1
        text = b"The quick brown fox jumps over the lazy dog. " * 60 + b"<n>"
        status, _, g, backend, pixels, _ = self.write(text, globals_=g)
        self.assertEqual(status, ERR_BOUNDS)
        self.assertEqual(backend.events, [("close_frame_text",), ("load", 9, b"FONT09"),
                                          ("release", 9)])
        self.assertEqual((g.frame_open, g.framed_ready, g.sheet_refcount[9]), (0, 0, 0))

    def test_restore_failure_releases_loaded_sheets(self):
        backend = SheetBackend(self.data, self.fmt, fail_restore=True)
        status, _, g, backend, pixels, _ = self.write(b"a<f5>b<n>", backend=backend)
        self.assertEqual(status, ERR_BACKEND)
        self.assertEqual(backend.events, [("load", 9, b"FONT09"), ("release", 9),
                                          ("load", 5, b"FONT05"), ("restore_caption_box",),
                                          ("release", 5)])
        # 0x4496ff sets 0x5b1606 before the restore call; it stays set.
        self.assertEqual((tuple(g.sheet_refcount), g.caption_visible_flag), ((0,) * MAX_FONTS, 1))
        self.assertNotEqual(bytes(pixels), b"\xa5" * len(pixels))

    def test_framed_too_long_fails_before_mutation(self):
        status, _, globals_, backend, pixels, stored = self.write(b"x<n>" * 74, -2)
        self.assert_untouched(status, ERR_TOO_LONG, globals_, backend, pixels, stored,
                              b"x<n>" * 74)
        status, result, globals_, _, _, _ = self.write(b"x<n>" * 73, -2)
        self.assertEqual((status, result.lines, globals_.framed_scroll_lines), (OK, 73, 901))

    def test_tab_count_from_tbox_is_bounded(self):
        tbox = bytearray(self.data.tbox)
        struct.pack_into("<h", tbox, 0x58, 15)
        geometry = Geometry()
        self.assertEqual(self.lib.caption_geometry_init(buf(bytes(tbox)), 98,
                                                        c.byref(geometry)), OK)
        backend = SheetBackend(self.data, self.fmt)
        surface, pixels = self.caption_surface()
        # 0x448f1c fills the tab buffer at entry, with or without <t>.
        for text in (b"a<t>b<n>", b"ab<n>"):
            status, *_ = native_write(self.lib, self.fmt, self.fonts, geometry, backend,
                                      text, -1, 0, surface=surface)
            self.assertEqual(status, ERR_FORMAT)
        self.assertEqual(backend.events, [])

    # -- flags and lifecycle -----------------------------------------------------
    def test_renderer_flags(self):
        g = Globals()
        g.caption_finish_flag = 1
        status, _, g, _, _, _ = self.write(b"x<n>", globals_=g)
        self.assertEqual((status, g.caption_finish_flag, g.caption_visible_flag), (OK, 0, 1))
        g = Globals()
        g.caption_finish_flag = 1
        status, _, g, _, _, _ = self.write(b"x<n>", -1, 1, globals_=g)
        self.assertEqual((status, g.caption_finish_flag, g.caption_visible_flag), (OK, 1, 0))
        g = Globals()
        g.caption_finish_flag = 1
        status, _, g, _, _, _ = self.write(b"x<n>", -2, globals_=g)
        self.assertEqual((status, g.caption_finish_flag, g.framed_ready), (OK, 1, 1))

    def test_open_frame_is_closed_first(self):
        g = Globals()
        g.frame_open = 1
        g.framed_ready = 1
        status, _, g, backend, _, _ = self.write(b"x<n>", -1, 1, globals_=g)
        # 0x4de2d8 clears 0x5b15d6 (0x4de302) and 0x5a161f (via 0x4de1f5).
        self.assertEqual((status, g.frame_open, g.framed_ready), (OK, 0, 0))
        self.assertEqual(backend.events[0], ("close_frame_text",))
        g = Globals()
        g.frame_open = 1
        backend = SheetBackend(self.data, self.fmt, fail_close=True)
        status, _, g, backend, pixels, _ = self.write(b"x<n>", globals_=g, backend=backend)
        self.assertEqual((status, g.frame_open), (ERR_BACKEND, 1))
        self.assertEqual(bytes(pixels), b"\xa5" * len(pixels))

    def test_missing_font_sheet_is_fatal(self):
        backend = SheetBackend(self.data, self.fmt, fail_load=True)
        status, _, g, backend, pixels, _ = self.write(b"x<n>", backend=backend)
        self.assertEqual(status, ERR_BACKEND)
        # The clear precedes the failed load and was visible to it.
        self.assertEqual(bytes(pixels), struct.pack("<H", self.fmt.color_key) * (len(pixels) // 2))
        self.assertEqual((g.caption_visible_flag, g.sheet_refcount[9]), (0, 0))
        # 0x4c2790 reports and quits on a failed load, even when measuring.
        backend = SheetBackend(self.data, self.fmt, fail_load=True)
        status, _, g, backend, _, _ = self.write(b"x<n>", -1, 1, backend=backend)
        self.assertEqual((status, g.sheet_refcount[9]), (ERR_BACKEND, 0))

    def test_sheet_refcount_persistence(self):
        backend = SheetBackend(self.data, self.fmt)
        g = Globals()
        status, *_ = native_write(self.lib, self.fmt, self.fonts, self.geometry, backend,
                                  b"<n>", -1, 1, globals_=g)
        self.assertEqual(status, OK)
        self.assertEqual(backend.events, [("load", 9, b"FONT09"), ("release", 9)])
        self.assertEqual(g.sheet_refcount[9], 0)
        # A sheet held elsewhere (refcount 1) is reused and kept.
        g = Globals()
        held = self.data.sheet(b"FONT09", self.fmt)
        storage = buf(held[0])
        g.sheets[9] = Surface(c.cast(storage, c.POINTER(c.c_uint8)), held[1], held[2], held[3])
        g.sheet_refcount[9] = 1
        backend = SheetBackend(self.data, self.fmt)
        status, *_ = native_write(self.lib, self.fmt, self.fonts, self.geometry, backend,
                                  b"x<n>", -1, 1, globals_=g)
        self.assertEqual((status, backend.events, g.sheet_refcount[9]), (OK, [], 1))

    def test_underline_row_uses_original_factor(self):
        status, result, _, _, pixels, _ = self.write(b"<u>Under<u><n>")
        self.assertEqual((status, result.underline_fills), (OK, 1))
        width = self.geometry.caption_surface_width
        rows = {i // 2 // width for i in range(0, len(pixels), 2)
                if bytes(pixels[i:i + 2]) not in (struct.pack("<H", self.fmt.color_key),)}
        # Font 9 glyphs are 12 high on baseline 12: trunc(12 * 0.9f) + 1 = 11.
        self.assertIn(11, rows)
        self.assertNotIn(13, rows)

    def test_debug_mode_too_much_text(self):
        text = b"The quick brown fox jumps over the lazy dog. " * 8 + b"<n>"
        status, result, _, backend, _, _ = self.write(text, debug=1)
        self.assertEqual(status, OK)
        self.assertIn(("debug_log",), backend.events)
        self.assertEqual(backend.messages, [b"CC Text::ProcessTextLine() - Too much Text"])

    def test_callbacks_observe_live_pixels_and_state(self):
        surface, pixels = self.caption_surface()
        g = Globals()
        g.caption_finish_flag = 1
        backend = SheetBackend(self.data, self.fmt)
        key = struct.pack("<H", self.fmt.color_key)
        seen = {}

        def load(ctx, font, name, sheet, original=backend._load):
            seen["load"] = (bytes(pixels[:4]), g.caption_finish_flag, g.sheet_refcount[font])
            return original(ctx, font, name, sheet)

        def restore(ctx):
            body = bytes(pixels)
            seen["restore"] = (body != key * (len(body) // 2), g.caption_visible_flag,
                               g.caption_finish_flag, g.sheet_refcount[9])
            return 0

        backend.struct.load_font_sheet = LOAD(load)
        backend.struct.restore_caption_box = SIMPLE(restore)
        status, result, _, g2, _ = native_write(self.lib, self.fmt, self.fonts, self.geometry,
                                                 backend, self.autotext[b"NSHT01"], -1, 0,
                                                 surface=surface, globals_=g)
        self.assertEqual(status, OK)
        # At load: cleared surface visible, 0x5b1602 already cleared, count 0.
        self.assertEqual(seen["load"], (key * 2, 0, 0))
        # At restore: glyphs visible, 0x5b1606 set, sheet still held.
        self.assertEqual(seen["restore"], (True, 1, 0, 1))

    def test_backend_writes_during_callbacks_are_kept(self):
        g = Globals()
        g.frame_open = 1
        g.caption_visible_flag = 0
        backend = SheetBackend(self.data, self.fmt)

        def close(ctx):
            g.caption_visible_flag = 7   # a host write the writer must not undo
            return 0

        backend.struct.close_frame_text = SIMPLE(close)
        status, *_ = native_write(self.lib, self.fmt, self.fonts, self.geometry, backend,
                                  b"x<n>", -1, 1, globals_=g)
        self.assertEqual((status, g.caption_visible_flag, g.frame_open), (OK, 7, 0))

    def test_callback_pixel_and_state_mutations_survive_success_and_failure(self):
        for restore_fails in (False, True):
            with self.subTest(restore_fails=restore_fails):
                surface, pixels = self.caption_surface()
                g = Globals()
                box = TextBox()
                backend = SheetBackend(self.data, self.fmt, fail_restore=restore_fails)
                observed = []

                def restore(_ctx):
                    body = bytes(pixels)
                    observed.append((body != b"\xa5" * len(body), g.caption_visible_flag,
                                     g.caption_finish_flag, box.left_margin))
                    pixels[-2:] = b"\xcd\xab"
                    g.caption_finish_flag = 0x3344
                    box.too_long_reported = 0x5566
                    return 1 if restore_fails else 0

                backend.struct.restore_caption_box = SIMPLE(restore)
                status, _, _, g, _ = native_write(
                    self.lib, self.fmt, self.fonts, self.geometry, backend, b"Visible<n>",
                    -1, 0, surface=surface, globals_=g, box=box)
                self.assertEqual(status, ERR_BACKEND if restore_fails else OK)
                self.assertEqual(observed, [(True, 1, 0, 4)])
                self.assertEqual(bytes(pixels[-2:]), b"\xcd\xab")
                self.assertEqual((g.caption_finish_flag, g.caption_visible_flag,
                                  box.too_long_reported), (0x3344, 1, 0x5566))
                self.assertEqual((g.sheet_refcount[9], bool(g.sheets[9].pixels)), (0, False))
                self.assertEqual([event[0] for event in backend.events], ["load", "release"])

    def test_missing_callbacks_rejected_before_any_call(self):
        for field, mode, measure, frame_open in (
                ("release_font_sheet", -1, 1, 0), ("load_font_sheet", -1, 1, 0),
                ("restore_caption_box", -1, 0, 0), ("restore_caption_box", 5, 0, 0),
                ("close_frame_text", -1, 1, 1)):
            backend = SheetBackend(self.data, self.fmt)
            setattr(backend.struct, field, type(getattr(backend.struct, field))())
            g = Globals()
            g.frame_open = frame_open
            surface = pixels = None
            if not measure:
                surface, pixels = self.caption_surface()
            status, _, _, g, stored = native_write(
                self.lib, self.fmt, self.fonts, self.geometry, backend, b"x<n>", mode, measure,
                surface=surface, globals_=g)
            self.assertEqual((status, backend.events), (ERR_UNSUPPORTED, []), field)
            self.assertEqual((g.frame_open, tuple(g.sheet_refcount)), (frame_open, (0,) * MAX_FONTS))
            if pixels is not None:
                self.assertEqual(bytes(pixels), b"\xa5" * len(pixels))
        # Restore is not needed for measuring or for the framed box.
        backend = SheetBackend(self.data, self.fmt)
        backend.struct.restore_caption_box = SIMPLE()
        self.assertEqual(self.write(b"x<n>", -1, 1, backend=backend)[0], OK)
        self.assertEqual(self.write(b"x<n>", -2, 0, backend=backend)[0], OK)

    def test_extreme_coordinates_fail_safely(self):
        # FONT glyph and colour rectangles and TBOX values at INT32 extremes:
        # arithmetic wraps as on x86 (no UB) and any out-of-range access is
        # rejected (run under UBSan by the S05 fix checks).
        chunk = bytearray(self.data.font_chunk)
        base = 9 * FONT_RECORD
        for glyph in range(GLYPHS):
            struct.pack_into("<iiii", chunk, base + 0xC3 + 16 * glyph,
                             -2**31, -2**31, 2**31 - 1, 2**31 - 1)
        struct.pack_into("<ii", chunk, base + 0x3F, 2**31 - 1, 2**31 - 1)
        fonts = Fonts()
        self.assertEqual(self.lib.caption_fonts_init(buf(bytes(chunk)), len(chunk), 18,
                                                     c.byref(fonts)), OK)
        self.assertEqual(tuple(fonts.glyph_size[9][0]), (0, 0))
        for measure in (1, 0):
            backend = SheetBackend(self.data, self.fmt)
            surface = pixels = None
            if not measure:
                surface, pixels = self.caption_surface()
            status, *_ = native_write(self.lib, self.fmt, fonts, self.geometry, backend,
                                      b"Hi<u>x<u><n>", -1, measure, surface=surface)
            self.assertIn(status, (OK, ERR_BOUNDS), measure)
        tbox = bytearray(self.data.tbox)
        for offset in range(0, 0x58, 4):
            struct.pack_into("<i", tbox, offset, -2**31 if offset % 8 else 2**31 - 1)
        geometry = Geometry()
        self.assertEqual(self.lib.caption_geometry_init(buf(bytes(tbox)), 98,
                                                        c.byref(geometry)), OK)
        for mode in (-1, -2):
            backend = SheetBackend(self.data, self.fmt)
            surface, pixels = self.caption_surface()
            status, *_ = native_write(self.lib, self.fmt, self.fonts, geometry, backend,
                                      b"Hi<n>", mode, 0, surface=surface)
            self.assertNotEqual(status, ERR_ARGUMENT)

    def test_status_strings(self):
        self.assertEqual(self.lib.caption_status_string(ERR_TOO_LONG), b"framed text too long")


SANITIZER_DRIVER = r"""
#include "caption_layout.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint8_t *read_file(const char *path, size_t *length)
{
    FILE *f = fopen(path, "rb");
    uint8_t *data;
    if (f == NULL) { return NULL; }
    fseek(f, 0, SEEK_END); *length = (size_t)ftell(f); fseek(f, 0, SEEK_SET);
    data = malloc(*length ? *length : 1);
    if (fread(data, 1, *length, f) != *length) { exit(2); }
    fclose(f);
    return data;
}

static uint16_t sheet_pixels[600 * 600];
static int loads, releases;
static CaptionBackendStatus load(void *c, int16_t f, const char *n, CaptionSurface *s)
{ (void)c; (void)f; (void)n; s->pixels = (uint8_t *)sheet_pixels; s->width = 600;
  s->height = 600; s->pitch = 1200; ++loads; return CAPTION_BACKEND_OK; }
static void release(void *c, int16_t f, CaptionSurface *s) { (void)c; (void)f; (void)s; ++releases; }
static CaptionBackendStatus ok(void *c) { (void)c; return CAPTION_BACKEND_OK; }
static CaptionBackendStatus fail(void *c) { (void)c; return CAPTION_BACKEND_ERROR; }

static void put32(uint8_t *p, int32_t v) { memcpy(p, &v, 4); }

int main(int argc, char **argv)
{
    size_t font_length, tbox_length;
    uint8_t *font, *tbox;
    static CaptionFonts fonts;
    CaptionGeometry geometry;
    CaptionPixelFormat format;
    const uint8_t key[3] = {0, 0x1f, 0};
    static uint16_t target_pixels[623 * 1001];
    const char *texts[] = {"Hello there, a longer caption to wrap around the box.<n>",
                           "<u>under<u> <c1>tint<c0> <f5>five<f9> tab<t>x<r>right<n>",
                           "x<n>", "<f30>bad<n>", "abc>def<n>"};
    int mode_index, text_index, variant;
    if (argc != 3) { return 2; }
    font = read_file(argv[1], &font_length);
    tbox = read_file(argv[2], &tbox_length);
    if (font == NULL || tbox == NULL) { return 2; }
    for (size_t i = 0; i < 600 * 600; ++i) { sheet_pixels[i] = (uint16_t)(i * 2654435761u >> 16); }
    caption_pixel_format_from_masks(0x7c00, 0x3e0, 0x1f, key, &format);
    for (variant = 0; variant < 3; ++variant) {
        uint8_t *f = malloc(font_length);
        uint8_t t[CAPTION_TBOX_BYTES];
        memcpy(f, font, font_length);
        memcpy(t, tbox, CAPTION_TBOX_BYTES);
        if (variant >= 1) {
            for (int g = 0; g < 115; ++g) {
                uint8_t *r = f + 9 * 0x7f3 + 0xc3 + 16 * g;
                put32(r, INT32_MIN); put32(r + 4, INT32_MIN);
                put32(r + 8, INT32_MAX); put32(r + 12, INT32_MAX);
            }
            put32(f + 9 * 0x7f3 + 0x3f, INT32_MAX); put32(f + 9 * 0x7f3 + 0x43, INT32_MAX);
        }
        if (variant == 2) {
            for (int o = 0; o < 0x58; o += 4) { put32(t + o, (o & 4) ? INT32_MIN : INT32_MAX); }
        }
        if (caption_fonts_init(f, font_length, 18, &fonts) != CAPTION_OK) { return 3; }
        if (caption_geometry_init(t, CAPTION_TBOX_BYTES, &geometry) != CAPTION_OK) { return 4; }
        for (mode_index = 0; mode_index < 3; ++mode_index) {
            int16_t mode = mode_index == 0 ? -1 : mode_index == 1 ? -2 : 5;
            for (text_index = 0; text_index < 5; ++text_index) {
                for (int measure = 0; measure < 2; ++measure) {
                    for (int restore_fails = 0; restore_fails < 2; ++restore_fails) {
                        uint8_t text[256];
                        CaptionTextBox box; CaptionGlobals globals; CaptionResult result;
                        CaptionBackend backend = {NULL, load, release, ok,
                                                  restore_fails ? fail : ok, NULL};
                        CaptionSurface target = {(uint8_t *)target_pixels, 623, 201, 1246};
                        CaptionRequest request;
                        memset(&box, 0, sizeof(box)); memset(&globals, 0, sizeof(globals));
                        globals.frame_open = (uint8_t)(text_index & 1);
                        memset(text, 0, sizeof(text));
                        strcpy((char *)text, texts[text_index]);
                        request.text = text; request.text_capacity = sizeof(text);
                        request.mode = mode; request.measure = (uint8_t)measure; request.debug_mode = 1;
                        loads = releases = 0;
                        (void)caption_layout_write(&fonts, &geometry, &format, &box, &globals,
                                                   &backend, &target, &request, &result);
                        for (int k = 0; k < 18; ++k) {
                            if (globals.sheet_refcount[k] != 0 || globals.sheets[k].pixels != NULL) {
                                fprintf(stderr, "leak font %d\n", k); return 5;
                            }
                        }
                        if (loads != releases) { fprintf(stderr, "unbalanced\n"); return 6; }
                    }
                }
            }
        }
        free(f);
    }
    puts("sanitizer driver ok");
    return 0;
}
"""


class CaptionSanitizerTests(unittest.TestCase):
    def test_asan_ubsan_driver(self):
        import shutil
        import subprocess
        import tempfile
        if shutil.which("xcrun") is None or not GAME_SOURCE.exists():
            raise unittest.SkipTest("xcrun or shipped data unavailable")
        try:
            data = ShippedData()
        except Exception as exc:  # noqa: BLE001
            raise unittest.SkipTest(f"shipped data unavailable: {exc}")
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / "driver.c").write_text(SANITIZER_DRIVER)
            (tmp / "font.bin").write_bytes(data.font_chunk)
            (tmp / "tbox.bin").write_bytes(data.tbox)
            build = subprocess.run(
                ["xcrun", "clang", "-arch", "arm64", "-std=c11", "-g", "-O1",
                 "-fsanitize=address,undefined", "-fno-sanitize-recover=all",
                 "-I", str(PROJECT / "src"), str(tmp / "driver.c"),
                 str(PROJECT / "src/caption_layout.c"), "-o", str(tmp / "driver")],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(tmp / "driver"), str(tmp / "font.bin"), str(tmp / "tbox.bin")],
                                 capture_output=True, text=True, timeout=600,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr[-3000:])
            self.assertIn("sanitizer driver ok", run.stdout)


if __name__ == "__main__":
    unittest.main()
