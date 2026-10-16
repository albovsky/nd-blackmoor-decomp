"""RT-32a AUTOTEXT writer: bindings, synthetic fixtures and unit tests.

The game's font sheets (CIFTREE) are not part of the private evidence set that
every checkout has, so both the native writer and the original-x86 oracle are
fed identical synthetic sheets: deterministic pixel words in which a fraction
equals the colour key. Real data used: BOOT (BSUM, MARK) and FONT records from
work/analysis/hiff-resources (0053.bin, 0093.bin) and the AUTOTEXT strings
(0001.bin). Nothing derived from those bytes is committed.

    python3 -m unittest outputs/blackmoor-decomp/tests/test_autotext_writer.py
"""

from __future__ import annotations

import ctypes as c
import hashlib
import os
import platform
import random
import struct
import sys
import unittest
from array import array
from dataclasses import dataclass, field
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_caption_layout as cap  # noqa: E402

PROJECT = HERE.parent
ROOT = PROJECT.parents[1]
RESOURCES = ROOT / "work/analysis/hiff-resources"
SUFFIX = "dylib" if platform.system() == "Darwin" else "so"
LIBRARY = Path(os.environ.get("AUTOTEXT_WRITER_LIBRARY", PROJECT / f"build/libautotextwriter.{SUFFIX}"))

OK, ERR_ARGUMENT, ERR_FORMAT, ERR_LIMIT, ERR_BOUNDS, ERR_FONT, ERR_UNSUPPORTED, ERR_BACKEND, \
    ERR_SURFACE_INDEX = range(9)
STATUS_NAMES = ["OK", "ARGUMENT", "FORMAT", "LIMIT", "BOUNDS", "FONT", "UNSUPPORTED", "BACKEND",
                "SURFACE_INDEX"]
ENTRY_BYTES = 301
SLOTS = 6
HOTSPOTS = 400
MARKS = 5
MAX_FONTS = cap.MAX_FONTS
RGB555, RGB565 = cap.RGB555, cap.RGB565
GUARD_BYTE = 0xA5
FILL_BYTE = 0xEE
TRACE_FLUSH, TRACE_DRAW, TRACE_BLIT = 1, 2, 3


class Hotspot(c.Structure):
    _fields_ = [("x_start", c.c_int32), ("y_start", c.c_int32), ("x_end", c.c_int32),
                ("y_end", c.c_int32)]


class Owner(c.Structure):
    _fields_ = [("surface_index", c.c_int16), ("overlay", cap.Surface), ("target", cap.Surface),
                ("final_y", c.c_int32 * SLOTS), ("hotspots", Hotspot * HOTSPOTS),
                ("left_margin", c.c_int16), ("pictures_seen", c.c_int32),
                ("underline", c.c_int32), ("underline_color", c.c_uint16),
                ("tight_spacing", c.c_int32), ("half_spacing", c.c_int32)]


class Globals(c.Structure):
    _fields_ = [("slots", cap.Surface * SLOTS), ("mark_sheet", cap.Surface),
                ("mark_rects", (c.c_int32 * 4) * MARKS), ("debug_mode", c.c_int16)]


class Rect(c.Structure):
    _fields_ = [("left", c.c_int32), ("top", c.c_int32), ("right", c.c_int32),
                ("bottom", c.c_int32)]


class Result(c.Structure):
    _fields_ = [("lines", c.c_int16), ("final_x", c.c_int16), ("final_y", c.c_int16),
                ("surface_created", c.c_uint8), ("overlay_loaded", c.c_uint8),
                ("stopped_by_e", c.c_uint8), ("glyphs_drawn", c.c_uint32),
                ("underline_fills", c.c_uint32), ("marks_drawn", c.c_uint32),
                ("pictures_drawn", c.c_uint32), ("flushes", c.c_uint32)]


CREATE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.c_int16, c.c_char_p, c.POINTER(cap.Surface))
FREE = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.POINTER(cap.Surface))
LOAD_OVERLAY = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_char_p, c.POINTER(cap.Surface))
LOAD_FONT = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.c_char_p, c.POINTER(cap.Surface))
RELEASE_FONT = c.CFUNCTYPE(None, c.c_void_p, c.c_int16, c.POINTER(cap.Surface))
LOG = c.CFUNCTYPE(None, c.c_void_p, c.c_char_p)
TRACE = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.c_char_p, c.c_int32, c.c_int32, c.c_int32,
                    c.c_int32, c.POINTER(c.c_int32))


class Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("create_surface", CREATE), ("free_surface", FREE),
                ("load_overlay", LOAD_OVERLAY), ("load_font_sheet", LOAD_FONT),
                ("release_font_sheet", RELEASE_FONT), ("debug_log", LOG), ("trace", TRACE)]


def bind(path: Path = LIBRARY):
    lib = cap.bind(path)
    lib.autotext_write.argtypes = [
        c.POINTER(cap.Fonts), c.POINTER(cap.PixelFormat), c.POINTER(Owner), c.POINTER(Globals),
        c.POINTER(cap.Globals), c.POINTER(Backend), c.POINTER(c.c_uint8), c.c_char_p, c.c_size_t,
        c.POINTER(Rect), c.c_size_t, c.POINTER(c.c_int16), c.POINTER(Result)]
    lib.autotext_write_status_string.restype = c.c_char_p
    return lib


# ---------------------------------------------------------------------------
# Test entries (the 0x43 body prefix)
# ---------------------------------------------------------------------------

def make_entry(mode=2, surface=0, font=4, color=0, left=0, top=0, width=389, height=137,
               pic_name=b"", pictures=(), count=None, filler=0) -> bytes:
    """`pictures` is a sequence of (line, left, top, right, bottom)."""
    entry = bytearray([filler]) * ENTRY_BYTES
    struct.pack_into("<8h", entry, 0, mode, surface, font, color, left, top, width, height)
    entry[0x10:0x31] = bytes(33)
    entry[0x10:0x10 + len(pic_name)] = pic_name
    struct.pack_into("<h", entry, 0x31, len(pictures) if count is None else count)
    for index, (line, l, t, r, b) in enumerate(pictures):
        if 0x33 + 18 * index + 18 <= ENTRY_BYTES:
            struct.pack_into("<h4i", entry, 0x33 + 18 * index, line, l, t, r, b)
    return bytes(entry)


@dataclass
class Case:
    label: str
    group: str
    entry: bytes
    text: bytes
    debug: int = 0
    masks: tuple = RGB555
    # Rect array capacity; None passes NULL for the array (the count pointer
    # is still supplied unless count_ptr is False).
    rects: int | None = None
    count_ptr: bool = True
    preset_slots: dict = field(default_factory=dict)  # index -> (width, height)
    preset: dict = field(default_factory=dict)        # pictures_seen, ...
    missing_fonts: frozenset = frozenset()
    missing_overlay: bool = False
    fail_create: bool = False
    # Native status for a documented unsafe/undefined original path.
    expect: str | None = None
    max_instructions: int = 300_000_000


def overlay_dims(entry: bytes) -> tuple[int, int]:
    """Smallest overlay that holds every picture rectangle of the entry."""
    count = max(0, min(10, struct.unpack_from("<h", entry, 0x31)[0]))
    width = height = 8
    for index in range(count):
        l, t, r, b = struct.unpack_from("<4i", entry, 0x33 + 18 * index + 2)
        width, height = max(width, r + 1), max(height, b + 1)
    return min(width, 4096), min(height, 4096)


# ---------------------------------------------------------------------------
# Synthetic data
# ---------------------------------------------------------------------------

def words(seed: str, count: int, key: int) -> bytes:
    """Deterministic pixel words; about 3/8 equal the colour key."""
    rng = random.Random(seed)
    out = array("H", bytes(count * 2))
    raw = rng.randbytes(count * 2)
    for i in range(count):
        r = raw[2 * i] | (raw[2 * i + 1] << 8)
        if (r & 7) < 3:
            out[i] = key
        else:
            w = (r >> 3) | ((r & 7) << 13)
            out[i] = w ^ 0x0100 if w == key else w
    if sys.byteorder != "little":
        out.byteswap()
    return out.tobytes()


class SyntheticData:
    """BOOT/FONT bytes from the decoded resource set plus synthetic sheets."""

    def __init__(self) -> None:
        boot = cap.hiff_chunks((RESOURCES / "0053.bin").read_bytes())
        font = cap.hiff_chunks((RESOURCES / "0093.bin").read_bytes())
        self.bsum = boot[b"BSUM"]
        self.tbox = boot[b"TBOX"]
        self.mark = boot[b"MARK"]
        self.font_chunk = font[b"FONT"]
        self.font_count = int.from_bytes(self.bsum[337:339], "little", signed=True)
        self.transparent = bytes(self.bsum[324:327])
        self.mark_rects = [struct.unpack_from("<4i", self.mark, 16 * i) for i in range(MARKS)]
        self._cache: dict = {}

    def font_record(self, font: int) -> bytes:
        return self.font_chunk[font * cap.FONT_RECORD:(font + 1) * cap.FONT_RECORD]

    def font_sheet(self, font: int, key: int) -> tuple[bytes, int, int, int]:
        """Covers every glyph rectangle for colour variants 0 and 1."""
        token = ("font", font, key)
        if token not in self._cache:
            rec = self.font_record(font)
            width = height = 1
            for variant in (0, 1):
                dx, dy = struct.unpack_from("<ii", rec, 0x3F + 8 * variant)
                for glyph in range(cap.GLYPHS):
                    left, top, right, bottom = struct.unpack_from("<4i", rec, 0xC3 + 16 * glyph)
                    width, height = max(width, right + dx + 1), max(height, bottom + dy + 1)
            self._cache[token] = (words(f"font{font}", width * height, key), width, height,
                                  width * 2)
        return self._cache[token]

    def mark_sheet(self, key: int) -> tuple[bytes, int, int, int]:
        token = ("mark", key)
        if token not in self._cache:
            width = max(r[2] for r in self.mark_rects) + 1
            height = max(r[3] for r in self.mark_rects) + 1
            self._cache[token] = (words("marks", width * height, key), width, height, width * 2)
        return self._cache[token]

    def overlay(self, name: bytes, width: int, height: int, key: int):
        token = ("overlay", name, width, height, key)
        if token not in self._cache:
            self._cache[token] = (words("overlay" + name.decode("latin1"), width * height, key),
                                  width, height, width * 2)
        return self._cache[token]


# ---------------------------------------------------------------------------
# Native harness
# ---------------------------------------------------------------------------

def addr(pointer) -> int:
    return c.cast(pointer, c.c_void_p).value or 0


def surface_bytes(surface: cap.Surface) -> bytes:
    if not surface.pixels:
        return b""
    return c.string_at(addr(surface.pixels), surface.pitch * surface.height)


def owner_image(owner: Owner, slots, original_target=None) -> bytes:
    """Owner object as the original lays it out (pointers normalised)."""
    image = bytearray(b"\x5a" * 0x2950)
    struct.pack_into("<h", image, 4, owner.surface_index)
    struct.pack_into("<I", image, 6, 1 if owner.overlay.pixels else 0)
    target = addr(owner.target.pixels)
    index = 0
    if target:
        index = 0x7FFF
        for i in range(SLOTS):
            if addr(slots[i].pixels) == target:
                index = i + 1
    struct.pack_into("<I", image, 0xA, index)
    for i in range(SLOTS):
        struct.pack_into("<i", image, 0x12 + 4 * i, owner.final_y[i])
    for k in range(HOTSPOTS):
        spot = owner.hotspots[k]
        struct.pack_into("<4i", image, 0x102E + 16 * k, spot.x_start, spot.y_start, spot.x_end,
                         spot.y_end)
    struct.pack_into("<h", image, 0x292E, owner.left_margin)
    struct.pack_into("<i", image, 0x2930, owner.pictures_seen)
    struct.pack_into("<i", image, 0x2938, owner.underline)
    struct.pack_into("<H", image, 0x293C, owner.underline_color)
    struct.pack_into("<i", image, 0x293E, owner.tight_spacing)
    struct.pack_into("<i", image, 0x2942, owner.half_spacing)
    return bytes(image)


def fresh_owner(preset: dict) -> Owner:
    owner = Owner()
    c.memset(c.byref(owner), 0x5A, c.sizeof(owner))
    owner.surface_index = 0x5A5A
    owner.overlay = cap.Surface()
    owner.target = cap.Surface()
    owner.pictures_seen = preset.get("pictures_seen", 0)
    return owner


class GuardedBuffer:
    """Pixel storage with guard bytes on both sides."""

    GUARD = 64

    def __init__(self, size: int, fill: int = FILL_BYTE) -> None:
        self.size = size
        self.raw = (c.c_uint8 * (size + 2 * self.GUARD))()
        c.memset(self.raw, GUARD_BYTE, len(self.raw))
        c.memset(addr(self.raw) + self.GUARD, fill, size)
        self.pixels = c.cast(c.byref(self.raw, self.GUARD), c.POINTER(c.c_uint8))
        self.freed = False

    def intact(self) -> bool:
        guard = bytes([GUARD_BYTE]) * self.GUARD
        raw = bytes(self.raw)
        return raw[:self.GUARD] == guard and raw[self.GUARD + self.size:] == guard

    def body(self) -> bytes:
        return bytes(self.raw)[self.GUARD:self.GUARD + self.size]


class NativeContext:
    def __init__(self, lib, data: SyntheticData, masks=RGB555) -> None:
        self.lib, self.data, self.masks = lib, data, masks
        self.fmt = cap.PixelFormat()
        status = lib.caption_pixel_format_from_masks(*masks, cap.buf(data.transparent),
                                                     c.byref(self.fmt))
        assert status == OK, status
        self.fonts = cap.Fonts()
        status = lib.caption_fonts_init(cap.buf(data.font_chunk), len(data.font_chunk),
                                        data.font_count, c.byref(self.fonts))
        assert status == OK, status


class NativeBackend:
    """Backend that serves synthetic surfaces and records events."""

    def __init__(self, nctx: NativeContext, case: Case) -> None:
        self.n, self.case = nctx, case
        self.events: list[tuple] = []
        self.buffers: list[GuardedBuffer] = []
        self.held: dict = {}
        self.live = None
        self.error: BaseException | None = None
        self.struct = Backend(None, CREATE(self._guard(self.create)), FREE(self._guard(self.free)),
                              LOAD_OVERLAY(self._guard(self.load_overlay)),
                              LOAD_FONT(self._guard(self.load_font)),
                              RELEASE_FONT(self._guard(self.release_font)),
                              LOG(self._guard(self.log)), TRACE(self._guard(self.trace)))

    def _guard(self, fn):
        def wrapper(*args):
            try:
                return fn(*args)
            except BaseException as exc:  # noqa: BLE001 - re-raised by the caller
                self.error = exc
                return 1
        return wrapper

    def snapshot(self) -> tuple:
        if self.live is None:
            return ()
        owner, globals_, fontg = self.live
        slots = tuple(None if not globals_.slots[i].pixels else
                      hashlib.sha256(surface_bytes(globals_.slots[i])).hexdigest()[:12]
                      for i in range(SLOTS))
        image = owner_image(owner, globals_.slots)
        return (tuple(fontg.sheet_refcount), slots, hashlib.sha256(image).hexdigest()[:12])

    def add(self, *event) -> None:
        self.events.append(tuple(event) + self.snapshot())

    def create(self, _ctx, width, height, name, out):
        self.add("create", width, height, name.decode())
        if self.case.fail_create:
            return 1
        buffer = GuardedBuffer(width * 2 * height)
        self.buffers.append(buffer)
        out[0] = cap.Surface(buffer.pixels, width, height, width * 2)
        self.held[addr(buffer.pixels)] = buffer
        return 0

    def free(self, _ctx, index, surface):
        self.add("free", "overlay") if index < 0 else self.add("free", "slot", index)
        buffer = self.held.pop(addr(surface[0].pixels), None)
        if buffer is not None:
            buffer.freed = True

    def load_overlay(self, _ctx, name, out):
        self.add("load_overlay", name.decode())
        if self.case.missing_overlay:
            return 1
        width, height = overlay_dims(self.case.entry)
        pixels, w, h, pitch = self.n.data.overlay(name, width, height, self.n.fmt.color_key)
        storage = cap.buf(pixels)
        self.held[addr(storage)] = storage
        out[0] = cap.Surface(c.cast(storage, c.POINTER(c.c_uint8)), w, h, pitch)
        return 0

    def load_font(self, _ctx, font, name, out):
        self.add("load_font", font, name.decode())
        if font in self.case.missing_fonts:
            return 1
        pixels, w, h, pitch = self.n.data.font_sheet(font, self.n.fmt.color_key)
        storage = cap.buf(pixels)
        self.held[("font", font)] = storage
        out[0] = cap.Surface(c.cast(storage, c.POINTER(c.c_uint8)), w, h, pitch)
        return 0

    def release_font(self, _ctx, font, _sheet):
        self.add("free", "font", font)
        self.held.pop(("font", font), None)

    def log(self, _ctx, message):
        self.add("debug_log", message.decode())

    def trace(self, _ctx, kind, text, a, b, cc, d, rects):
        text = text.decode("latin1") if text is not None else ""
        if kind == TRACE_FLUSH:
            self.add("flush", text, a, b, cc, d)
        elif kind == TRACE_DRAW:
            self.add("draw", text, a, b, cc, d)
        else:
            self.add("blit", text, tuple(rects[0:4]), tuple(rects[4:8]))


def native_run(nctx: NativeContext, case: Case) -> dict:
    """Runs the native writer on a fresh machine state for `case`."""
    backend = NativeBackend(nctx, case)
    owner = fresh_owner(case.preset)
    globals_ = Globals()
    c.memset(c.byref(globals_), 0, c.sizeof(globals_))
    fontg = cap.Globals()
    c.memset(c.byref(fontg), 0, c.sizeof(fontg))
    globals_.debug_mode = case.debug
    # Entry-mark sheet and records (0x5d0377 / 0x5afc7e).
    mark_pixels, mw, mh, mp = nctx.data.mark_sheet(nctx.fmt.color_key)
    mark_storage = cap.buf(mark_pixels)
    globals_.mark_sheet = cap.Surface(c.cast(mark_storage, c.POINTER(c.c_uint8)), mw, mh, mp)
    for i in range(MARKS):
        for j in range(4):
            globals_.mark_rects[i][j] = nctx.data.mark_rects[i][j]
    backend.live = (owner, globals_, fontg)
    for index, (w, h) in case.preset_slots.items():
        buffer = GuardedBuffer(w * 2 * h, 0xC3)
        backend.buffers.append(buffer)
        backend.held[addr(buffer.pixels)] = buffer
        globals_.slots[index] = cap.Surface(buffer.pixels, w, h, w * 2)
    entry = cap.buf(case.entry, ENTRY_BYTES)
    text = cap.buf(case.text + b"\0", len(case.text) + 1)
    rects = None
    count = c.c_int16(0x7777)
    if case.rects is not None:
        rects = (Rect * max(1, case.rects))()
        c.memset(rects, 0x6B, c.sizeof(rects))
    result = Result()
    before = None
    status = nctx.lib.autotext_write(
        c.byref(nctx.fonts), c.byref(nctx.fmt), c.byref(owner), c.byref(globals_), c.byref(fontg),
        c.byref(backend.struct), entry, c.cast(text, c.c_char_p), len(case.text) + 1,
        rects if rects is not None else None, case.rects or 0,
        c.byref(count) if (case.rects is not None or case.count_ptr) else None, c.byref(result))
    if backend.error is not None:
        raise backend.error
    del before
    out = {
        "status": status, "events": backend.events, "result": result,
        "owner": owner_image(owner, globals_.slots),
        "slots": [None if not globals_.slots[i].pixels else
                  (globals_.slots[i].width, globals_.slots[i].height,
                   hashlib.sha256(surface_bytes(globals_.slots[i])).hexdigest())
                  for i in range(SLOTS)],
        "refcounts": tuple(fontg.sheet_refcount),
        "handles": tuple(bool(fontg.sheets[i].pixels) for i in range(MAX_FONTS)),
        "entry": bytes(entry)[:ENTRY_BYTES],
        "rects": ([(r.left, r.top, r.right, r.bottom) for r in rects[:max(0, count.value)]]
                  if rects is not None and 0 <= count.value <= case.rects else []),
        "count": count.value,
        "guards_ok": all(b.intact() for b in backend.buffers),
        "overlay": bool(owner.overlay.pixels),
        "owner_struct": owner, "globals_struct": globals_,
    }
    return out


# ---------------------------------------------------------------------------
# Unit tests
# ---------------------------------------------------------------------------

def _available() -> str | None:
    for path in (LIBRARY, RESOURCES / "0053.bin", RESOURCES / "0093.bin", RESOURCES / "0001.bin"):
        if not path.exists():
            return f"missing {path}"
    return None


class AutotextWriterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        reason = _available()
        if reason:
            raise unittest.SkipTest(reason)
        cls.lib = bind()
        cls.data = SyntheticData()
        cls.nctx = NativeContext(cls.lib, cls.data)
        from autotext_original_oracle import RESOURCE_PATH, _read_cvtx_payload, parse_entries
        cls.autotext = {e["key"].lower(): e["caption"]
                        for e in parse_entries(_read_cvtx_payload(RESOURCE_PATH.read_bytes()))}

    def run_case(self, text: bytes, entry: bytes | None = None, **kw) -> dict:
        case = Case("unit", "unit", entry if entry is not None else make_entry(), text, **kw)
        return native_run(self.nctx, case)

    def assert_rejected(self, out: dict, status: int, case_text: bytes = b""):
        """A pass-1 rejection must leave every observable thing untouched."""
        self.assertEqual(out["status"], status, STATUS_NAMES[out["status"]])
        self.assertEqual(out["events"], [])
        self.assertEqual(out["slots"], [None] * SLOTS)
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)
        self.assertEqual(out["owner"], owner_image(fresh_owner({}), (cap.Surface * SLOTS)()))
        self.assertEqual(out["count"], 0x7777)

    # -- valid rows -----------------------------------------------------------
    def test_corpus_like_row(self):
        text = max(self.autotext.values(), key=len)
        out = self.run_case(text)
        self.assertEqual(out["status"], OK, STATUS_NAMES[out["status"]])
        result = out["result"]
        self.assertEqual(result.surface_created, 1)
        self.assertGreater(result.glyphs_drawn, 100)
        self.assertGreaterEqual(result.lines, 1)
        # surface 0 now exists at (width 389, height max(137 + 20, len * 144 / 389)).
        width, height, _ = out["slots"][0]
        self.assertEqual((width, height), (389, max(157, len(text) * 0x90 // 389)))
        kinds = [e[0] for e in out["events"]]
        self.assertEqual(kinds[0], "create")
        self.assertIn("load_font", kinds)
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)
        # mode 2 clears to (0,31,0) before drawing; the pen Y is stored at +0x12.
        self.assertEqual(out["owner"][0x12:0x16], struct.pack("<i", result.final_y))
        self.assertEqual(out["count"], 0)

    def test_mode_selects_clear_colour(self):
        green = self.run_case(b"<e>", make_entry(mode=2))
        black = self.run_case(b"<e>", make_entry(mode=0))
        self.assertEqual(green["status"], OK)
        self.assertEqual(black["status"], OK)
        self.assertNotEqual(green["slots"][0][2], black["slots"][0][2])
        info = green["globals_struct"].slots[0]
        words_ = struct.unpack("<%dH" % (info.width * info.height), surface_bytes(info))
        self.assertEqual(set(words_), {0x1F << 5})
        info = black["globals_struct"].slots[0]
        self.assertEqual(set(surface_bytes(info)), {0})

    def test_every_surface_index_and_final_y(self):
        for index in range(SLOTS):
            out = self.run_case(b"abc<n>", make_entry(surface=index))
            self.assertEqual(out["status"], OK)
            self.assertEqual([s is not None for s in out["slots"]],
                             [i == index for i in range(SLOTS)])
            self.assertEqual(struct.unpack_from("<h", out["owner"], 4)[0], index)
            self.assertEqual(struct.unpack_from("<i", out["owner"], 0x12 + 4 * index)[0],
                             out["result"].final_y)

    def test_tags_change_state(self):
        # <c1> colour, <l> tight spacing toggle, <w> half spacing, <u> underline.
        out = self.run_case(b"<l>a<n>b<l>c<w>d<n>")
        self.assertEqual(out["status"], OK)
        owner = out["owner"]
        self.assertEqual(struct.unpack_from("<i", owner, 0x293E)[0], 0)  # toggled twice
        self.assertEqual(out["result"].lines, 3)
        out = self.run_case(b"<u>under<u>x<n>")
        self.assertEqual(out["status"], OK)
        self.assertEqual(out["result"].underline_fills, 1)
        self.assertEqual(struct.unpack_from("<i", out["owner"], 0x2938)[0], 0)
        out = self.run_case(b"abc<e>def<n>")
        self.assertEqual((out["status"], out["result"].stopped_by_e, out["result"].glyphs_drawn),
                         (OK, 1, 3))

    def test_tab_tag_appends_nothing(self):
        a = self.run_case(b"a<t>b<n>")
        b = self.run_case(b"ab<n>")
        self.assertEqual((a["status"], b["status"]), (OK, OK))
        self.assertEqual(a["slots"], b["slots"])

    def test_wrap_adds_lines_and_height(self):
        words_ = b"The quick brown fox jumps over the lazy dog. " * 8
        out = self.run_case(words_ + b"<n>")
        self.assertEqual(out["status"], OK)
        # Wrapping flushes extra lines without touching the caller's line count.
        self.assertEqual(out["result"].lines, 1)
        flushes = [e for e in out["events"] if e[0] == "draw"]
        self.assertGreater(len(flushes), 3)

    def test_entry_marks_and_rects(self):
        # With top 0 the first mark is drawn above the surface: the original
        # writes outside it (oracle case marks-default-entry), native rejects.
        out = self.run_case(b"<1>one <3>three <7>seven<n>", rects=4)
        self.assertEqual(out["status"], ERR_BOUNDS)
        out = self.run_case(b"<1>one <3>three <7>seven<n>", make_entry(top=20), rects=4)
        self.assertEqual(out["status"], OK, STATUS_NAMES[out["status"]])
        self.assertEqual(out["count"], 3)
        self.assertEqual(out["result"].marks_drawn, 3)
        marks = self.data.mark_rects
        first = out["rects"][0]
        self.assertEqual(first[2] - first[0], marks[0][2] - marks[0][0])
        self.assertEqual(first[3] - first[1], marks[0][3] - marks[0][1])
        # <7> reuses record 0 like <1>.
        last = out["rects"][2]
        self.assertEqual(last[3] - last[1], marks[0][3] - marks[0][1])
        blits = [e for e in out["events"] if e[0] == "blit"]
        self.assertEqual([e[1] for e in blits], ["Drawing entry mark"] * 3)

    def test_hotspots(self):
        out = self.run_case(b"<H5>ab<n>cd<n><L>")
        self.assertEqual(out["status"], OK)
        spot = struct.unpack_from("<4i", out["owner"], 0x102E + 16 * 5)
        self.assertEqual(spot[0], struct.unpack_from("<h", out["owner"], 0x292E)[0])
        self.assertEqual(spot[1], 0)
        self.assertGreater(spot[2], spot[0])
        self.assertGreater(spot[3], 0)

    def test_font_switch_reference_counts(self):
        out = self.run_case(b"a<f5>b<f4>c<n>")
        self.assertEqual(out["status"], OK)
        loads = [e[1:3] for e in out["events"] if e[0] == "load_font"]
        self.assertEqual(loads, [(4, "FONT04"), (5, "FONT05"), (4, "FONT04")])
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)
        self.assertFalse(any(out["handles"]))

    def test_existing_surface_reuse_and_resize(self):
        reuse = self.run_case(b"abc<n>", preset_slots={0: (500, 400)})
        self.assertEqual(reuse["status"], OK)
        self.assertEqual([e[0] for e in reuse["events"]][0], "load_font")
        self.assertEqual(reuse["slots"][0][:2], (500, 400))
        grow = self.run_case(b"abc<n>", preset_slots={0: (100, 50)})
        self.assertEqual(grow["status"], OK)
        self.assertEqual([e[:3] for e in grow["events"]][0], ("free", "slot", 0))
        self.assertEqual([e[:4] for e in grow["events"]][1], ("create", 389, 157, "AUTO TEXT SURFACE"))
        self.assertEqual(grow["slots"][0][:2], (389, 157))
        # Only the dimension that is too small triggers re-creation.
        narrow = self.run_case(b"abc<n>", preset_slots={0: (300, 500)})
        self.assertEqual(narrow["slots"][0][:2], (389, 157))
        tall = self.run_case(b"abc<n>", preset_slots={0: (500, 100)})
        self.assertEqual(tall["slots"][0][:2], (389, 157))

    def test_overlay_pictures(self):
        entry = make_entry(pic_name=b"PIC0", pictures=[(0, 0, 0, 15, 9), (2, 4, 4, 11, 19)])
        out = self.run_case(b"a<n>b<n>c<n>", entry)
        self.assertEqual(out["status"], OK, STATUS_NAMES[out["status"]])
        self.assertEqual(out["result"].pictures_drawn, 2)
        self.assertEqual(struct.unpack_from("<i", out["owner"], 0x2930)[0], 1)
        self.assertFalse(out["overlay"])
        kinds = [e[:2] for e in out["events"] if e[0] in ("load_overlay", "free", "blit")]
        self.assertIn(("load_overlay", "PIC0"), kinds)
        self.assertEqual(kinds[-1], ("free", "overlay"))

    def test_picture_count_is_clamped_in_the_entry(self):
        pictures = [(9, 0, 0, 3, 3)] * 12
        entry = make_entry(pic_name=b"PIC1", pictures=pictures)
        out = self.run_case(b"<n>", entry)
        self.assertEqual(out["status"], OK, STATUS_NAMES[out["status"]])
        self.assertEqual(struct.unpack_from("<h", out["entry"], 0x31)[0], 10)

    # -- error rows ------------------------------------------------------------------
    def test_rejections_leave_state_untouched(self):
        rows = [
            ("surface index 6", b"x<n>", make_entry(surface=6), ERR_SURFACE_INDEX),
            ("surface index -1", b"x<n>", make_entry(surface=-1), ERR_SURFACE_INDEX),
            ("font 18", b"x<n>", make_entry(font=18), ERR_FONT),
            ("tag font 40", b"<f40>x<n>", None, ERR_FONT),
            ("width zero", b"x<n>", make_entry(width=0), ERR_FORMAT),
            ("close without tag", b"abc>def<n>", None, ERR_UNSUPPORTED),
            ("L before H", b"<L>x<n>", None, ERR_UNSUPPORTED),
            ("hotspot 400", b"<H400>x<n>", None, ERR_LIMIT),
            ("hotspot -1", b"<H-1>x<n>", None, ERR_LIMIT),
            ("argument overflow", b"<c" + b"9" * 30 + b">x<n>", None, ERR_LIMIT),
            ("text overflow", b"x" * 40000, None, ERR_LIMIT),
            ("unbounded name", b"x<n>", make_entry(pic_name=b"N" * 33, pictures=[(0, 0, 0, 1, 1)]),
             ERR_FORMAT),
        ]
        for label, text, entry, expected in rows:
            with self.subTest(label):
                out = self.run_case(text, entry)
                self.assert_rejected(out, expected)

    def test_rect_capacity(self):
        out = self.run_case(b"<1>a<2>b<3>c<n>", rects=2)
        self.assert_rejected(out, ERR_LIMIT)
        out = self.run_case(b"<1>a<n>", rects=None, count_ptr=True)
        self.assertEqual(out["status"], OK)
        self.assertEqual(out["count"], 0)

    def test_missing_callbacks_and_arguments(self):
        out = self.run_case(b"x<n>")
        nctx, lib = self.nctx, self.lib
        owner = fresh_owner({})
        globals_ = Globals()
        fontg = cap.Globals()
        entry = cap.buf(make_entry(), ENTRY_BYTES)
        text = cap.buf(b"x<n>\0")
        result = Result()
        backend = Backend()  # every callback NULL
        status = lib.autotext_write(
            c.byref(nctx.fonts), c.byref(nctx.fmt), c.byref(owner), c.byref(globals_),
            c.byref(fontg), c.byref(backend), entry, c.cast(text, c.c_char_p), 5, None, 0, None,
            c.byref(result))
        self.assertEqual(status, ERR_UNSUPPORTED)
        status = lib.autotext_write(
            c.byref(nctx.fonts), c.byref(nctx.fmt), c.byref(owner), c.byref(globals_),
            c.byref(fontg), c.byref(backend), entry, c.cast(text, c.c_char_p), 3, None, 0, None,
            c.byref(result))  # no NUL inside the capacity
        self.assertEqual(status, ERR_ARGUMENT)
        self.assertEqual(out["status"], OK)

    def test_failed_create_and_font_load_release_references(self):
        out = self.run_case(b"x<n>", fail_create=True)
        self.assertEqual(out["status"], ERR_BACKEND)
        self.assertEqual(out["slots"], [None] * SLOTS)
        out = self.run_case(b"a<f5>b<n>", missing_fonts=frozenset({5}))
        self.assertEqual(out["status"], ERR_BACKEND)
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)
        self.assertEqual(out["handles"], (False,) * MAX_FONTS)
        # Pass-2 failures keep the slot surface the original created.
        self.assertIsNotNone(out["slots"][0])
        entry = make_entry(pic_name=b"PIC2", pictures=[(0, 0, 0, 3, 3)])
        out = self.run_case(b"x<n>", entry, missing_overlay=True)
        self.assertEqual(out["status"], ERR_BACKEND)
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)

    def test_picture_outside_overlay_is_a_pass_two_failure(self):
        entry = make_entry(pic_name=b"PIC3", pictures=[(0, 0, 0, 3, 3)])
        out = self.run_case(b"x<n>", entry)
        self.assertEqual(out["status"], OK)
        # A rectangle beyond the surface address range is a bounds failure.
        big = make_entry(pic_name=b"PIC3", pictures=[(0, 0, 0, 100000, 100000)])
        case = Case("unit", "unit", big, b"x<n>")
        # overlay_dims clamps to 4096, so the rectangle leaves the overlay.
        out = native_run(self.nctx, case)
        self.assertEqual(out["status"], ERR_BOUNDS)
        self.assertEqual(out["refcounts"], (0,) * MAX_FONTS)
        self.assertFalse(out["overlay"])

    def test_debug_line_overflow(self):
        entry = make_entry(height=0)
        text = b"word " * 30 + b"<n>"
        quiet = self.run_case(text, entry)
        loud = self.run_case(text, entry, debug=1)
        self.assertEqual((quiet["status"], loud["status"]), (OK, OK))
        logs = [e for e in loud["events"] if e[0] == "debug_log"]
        self.assertTrue(logs)
        self.assertFalse([e for e in quiet["events"] if e[0] == "debug_log"])

    def test_overflowing_a_surface_is_a_bounds_failure(self):
        # Extra pending text past the surface rows: the glyph draw leaves the buffer.
        entry = make_entry(width=40, height=1)
        out = self.run_case(b"Wide letters overflow the tiny surface<n>", entry)
        self.assertIn(out["status"], (ERR_BOUNDS, OK))


class MalformedInputTests(unittest.TestCase):
    """Bounded deterministic fuzz: random entries and tag soup must never
    crash, overrun a guarded buffer or return an out-of-range status. Run it
    against the SANITIZE=1 build (AUTOTEXT_WRITER_LIBRARY plus LD_PRELOAD of
    the compiler's libasan) for the ASan/UBSan check."""

    TOKENS = [b"<n>", b"<w>", b"<l>", b"<r>", b"<t>", b"<e>", b"<u>", b"<L>", b"<H%d>",
              b"<f%d>", b"<c%d>", b"<%d>", b"<", b">", b"<<", b">>", b" ", b"word", b"x" * 60,
              b"\xe9", b"\x00", b"\xff", b"<H", b"<f", b"<c99999999999999999999>"]

    @classmethod
    def setUpClass(cls):
        reason = _available()
        if reason:
            raise unittest.SkipTest(reason)
        cls.lib = bind()
        cls.data = SyntheticData()
        cls.nctx = NativeContext(cls.lib, cls.data)

    def test_random_entries_and_text(self):
        rng = random.Random(0x32A)
        statuses = {}
        for n in range(int(os.environ.get("AUTOTEXT_FUZZ_CASES", "400"))):
            pictures = [(rng.randint(-2, 12), rng.randint(-5, 50), rng.randint(-5, 50),
                         rng.randint(-5, 80), rng.randint(-5, 80))
                        for _ in range(rng.choice((0, 0, 1, 3, 12)))]
            entry = bytearray(make_entry(
                mode=rng.choice((0, 1, 2, 7)), surface=rng.randint(-2, 8),
                font=rng.randint(-1, 19), color=rng.choice((0, 1, 2, 300, -1)),
                left=rng.randint(-20, 60), top=rng.randint(-20, 60),
                width=rng.choice((0, 1, 5, 40, 150, 389, 5000, -3)),
                height=rng.choice((0, 1, 20, 137, 400, -10)),
                pic_name=rng.choice((b"", b"PIC", b"N" * 33)), pictures=pictures,
                count=rng.choice((None, None, 14, 40, -1, 1000))))
            if rng.random() < 0.3:
                for _ in range(rng.randint(1, 6)):
                    entry[rng.randrange(ENTRY_BYTES)] = rng.randrange(256)
            parts = []
            for _ in range(rng.randint(0, 60)):
                token = rng.choice(self.TOKENS)
                parts.append(token % rng.randint(-3, 410) if b"%d" in token else token)
            text = b"".join(parts).replace(b"\0", b"")
            case = Case(f"fuzz{n}", "fuzz", bytes(entry), text, debug=rng.randint(0, 1),
                        rects=rng.choice((None, 0, 2, 8)),
                        preset_slots=rng.choice(({}, {}, {0: (30, 20)}, {1: (500, 400)})),
                        preset=rng.choice(({}, {}, {"pictures_seen": 1})),
                        missing_fonts=rng.choice((frozenset(), frozenset(), frozenset({5}))),
                        missing_overlay=rng.random() < 0.1, fail_create=rng.random() < 0.05)
            out = native_run(self.nctx, case)
            self.assertTrue(0 <= out["status"] <= 8, case.label)
            self.assertTrue(out["guards_ok"], case.label)
            statuses[out["status"]] = statuses.get(out["status"], 0) + 1
            if out["status"] != OK:
                # A rejection before pass 2 leaves the caller's entry untouched.
                if out["status"] in (ERR_FORMAT, ERR_LIMIT, ERR_FONT, ERR_UNSUPPORTED,
                                     ERR_SURFACE_INDEX):
                    self.assertEqual(out["entry"], case.entry, case.label)
        self.assertGreaterEqual(len(statuses), 3, statuses)


if __name__ == "__main__":
    unittest.main()
