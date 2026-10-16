#!/usr/bin/env python3
"""Fixture tests for the recovered AVF decoder (src/avf_decoder.[ch]).

Builds a native library with scripts/build_avf_decoder.sh (or uses
AVF_DECODER_LIBRARY) and drives it through ctypes with synthetic AVF files.
The helpers here (obfuscated LZSS encoder, AVF builder, command encoders) are
shared with avf_decoder_original_oracle.py, which runs the same fixtures and
the installed corpus through the original x86 routines.

    python3 outputs/blackmoor-decomp/tests/test_avf_decoder.py
"""

from __future__ import annotations

import ctypes as c
import os
import shutil
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
BUILD_SCRIPT = PROJECT / "scripts/build_avf_decoder.sh"
LIBRARY = Path(os.environ.get("AVF_DECODER_LIBRARY",
                              PROJECT / "build/libavfdecoder.dylib"))
SIGNATURE = b"AVF WayneSikes\0"
HEADER_BYTES = 0x21
RECORD_BYTES = 0x13
RING = 0x1000
RING_START = 0xFEE

OK, ARGUMENT, SIGNATURE_ERR, VERSION, TRUNCATED, RANGE, SEQUENCE, CORRUPT, UNSUPPORTED = range(9)
STATUS = ["OK", "ARGUMENT", "SIGNATURE", "VERSION", "TRUNCATED", "RANGE", "SEQUENCE",
          "CORRUPT", "UNSUPPORTED"]


# -- encoders -----------------------------------------------------------------
def lzss_tokens(tokens: list[tuple], tail: bytes = b"") -> bytes:
    """Encode ('lit', byte) / ('match', ring_offset, length 3..18) tokens.

    Every stored byte is (value + k) & 0xff where k counts the bytes before
    it, the inverse of the original's running counter. `tail` adds raw plain
    bytes after the last group (also obfuscated), e.g. a lone match byte.
    """
    plain = bytearray()
    for start in range(0, len(tokens), 8):
        group = tokens[start:start + 8]
        flags = 0
        body = bytearray()
        for bit, token in enumerate(group):
            if token[0] == "lit":
                flags |= 1 << bit
                body.append(token[1])
            else:
                _, offset, length = token
                if not 3 <= length <= 18 or not 0 <= offset < RING:
                    raise ValueError(token)
                body += bytes((offset & 0xFF, ((offset >> 4) & 0xF0) | (length - 3)))
        if len(group) < 8:
            # Unused trailing bits select a match, so the stream ends at the
            # first absent match byte, as in the shipped files.
            pass
        plain.append(flags)
        plain += body
    plain += tail
    return bytes((value + index) & 0xFF for index, value in enumerate(plain))


def lzss_literals(data: bytes) -> bytes:
    return lzss_tokens([("lit", b) for b in data])


def lzss_compress(data: bytes) -> bytes:
    """Greedy compressor using the original ring layout (for larger fixtures)."""
    ring = bytearray(b" " * RING)
    defined = [True] * RING_START + [False] * (RING - RING_START)
    position = RING_START
    tokens: list[tuple] = []
    index = 0
    while index < len(data):
        best_len, best_off = 0, 0
        limit = min(18, len(data) - index)
        if limit >= 3:
            for off in range(RING):
                if not defined[off]:
                    continue
                n = 0
                # Overlapping copies read bytes this same match writes.
                sim = {}
                while n < limit:
                    p = (off + n) & 0xFFF
                    value = sim.get(p, ring[p]) if p not in sim else sim[p]
                    if not defined[p] and p not in sim:
                        break
                    if value != data[index + n]:
                        break
                    sim[(position + n) & 0xFFF] = value
                    n += 1
                if n > best_len:
                    best_len, best_off = n, off
                    if n == limit:
                        break
        if best_len >= 3:
            tokens.append(("match", best_off, best_len))
            step = best_len
        else:
            tokens.append(("lit", data[index]))
            step = 1
        for value in data[index:index + step]:
            ring[position] = value
            defined[position] = True
            position = (position + 1) & 0xFFF
        index += step
    return lzss_tokens(tokens)


def lzss_reference(src: bytes) -> tuple[bytes, str]:
    """Independent model of 0x415db9, used only by the fixture tests."""
    ring = bytearray(b" " * RING_START + bytes(RING - RING_START))
    out = bytearray()
    r, counter, i, flags, n = RING_START, 0, -1, 0, len(src)
    while True:
        flags >>= 1
        if not flags & 0x100:
            i += 1
            if i == n:
                return bytes(out), "flag"
            flags = 0xFF00 | ((src[i] - counter) & 0xFF)
            counter = (counter + 1) & 0xFF
        if flags & 1:
            i += 1
            if i == n:
                return bytes(out), "literal"
            value = (src[i] - counter) & 0xFF
            counter = (counter + 1) & 0xFF
            out.append(value)
            ring[r] = value
            r = (r + 1) & 0xFFF
            continue
        i += 1
        if i == n:
            return bytes(out), "match_first"
        lo = (src[i] - counter) & 0xFF
        counter = (counter + 1) & 0xFF
        i += 1
        if i == n:
            return bytes(out), "match_second"
        hi = (src[i] - counter) & 0xFF
        counter = (counter + 1) & 0xFF
        offset = lo | ((hi & 0xF0) << 4)
        for k in range((hi & 0xF) + 3):
            value = ring[(offset + k) & 0xFFF]
            out.append(value)
            ring[r] = value
            r = (r + 1) & 0xFFF


def cmd_copy(pixel: int, words: list[int], count: int | None = None) -> bytes:
    count = len(words) if count is None else count
    return b" " + struct.pack("<II", pixel & 0xFFFFFFFF, count & 0xFFFFFFFF) + \
        struct.pack(f"<{len(words)}H", *words)


def cmd_fill(value: int, pixel: int, count: int) -> bytes:
    return b"@" + struct.pack("<HII", value, pixel & 0xFFFFFFFF, count & 0xFFFFFFFF)


def cmd_repeat(words: list[int], pixels: list[int], runs: int | None = None) -> bytes:
    runs = len(pixels) if runs is None else runs
    return b"\x80" + struct.pack("<BI", len(words), runs & 0xFFFFFFFF) + \
        struct.pack(f"<{len(words)}H", *words) + \
        struct.pack(f"<{len(pixels)}I", *(p & 0xFFFFFFFF for p in pixels))


def build_avf(width: int, height: int, frames: list[tuple[int, bytes | None, int | None]],
              *, bpp: int = 16, compression: int = 2, version: tuple[int, int] = (2, 0),
              signature: bytes = SIGNATURE, count: int | None = None) -> bytes:
    """frames: (type, plain payload or None for an empty record, packed override)."""
    count = len(frames) if count is None else count
    header = bytearray(signature.ljust(16, b"\0")[:16])
    header += struct.pack("<hh", *version) + b"\0"
    header += struct.pack("<hhhB", count, width, height, bpp)
    header += struct.pack("<I", 66) + bytes((compression,))
    assert len(header) == HEADER_BYTES
    table = bytearray()
    chunks = bytearray()
    data_start = HEADER_BYTES + RECORD_BYTES * len(frames)
    for index, (kind, payload, packed_override) in enumerate(frames):
        if payload is None:
            table += struct.pack("<HIIIBI", index, 0, 0, 0, kind, 0)
            continue
        packed = lzss_compress(payload) if packed_override is None else packed_override
        if isinstance(packed_override, int):
            raise TypeError
        table += struct.pack("<HIIIBI", index, data_start + len(chunks), len(packed),
                             len(payload), kind, 0)
        chunks += packed
    return bytes(header + table + chunks)


def words(data: bytes) -> list[int]:
    return list(struct.unpack(f"<{len(data) // 2}H", data))


# -- ctypes binding -------------------------------------------------------------
CONVERT = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(c.c_uint8), c.c_uint32)


class AvfFile(c.Structure):
    _fields_ = [("data", c.POINTER(c.c_uint8)), ("size", c.c_size_t),
                ("frame_count", c.c_int16), ("width", c.c_int16), ("height", c.c_int16),
                ("bits_per_pixel", c.c_uint8), ("header_1c", c.c_uint32),
                ("compression", c.c_uint8), ("frame_bytes", c.c_uint32),
                ("max_unpacked", c.c_uint32)]


class AvfRecord(c.Structure):
    _fields_ = [("index", c.c_uint16), ("offset", c.c_uint32), ("packed_bytes", c.c_uint32),
                ("unpacked_bytes", c.c_uint32), ("type", c.c_uint8), ("reserved", c.c_uint32)]


class AvfStream(c.Structure):
    _fields_ = [("file", c.POINTER(AvfFile)), ("last_index", c.c_int32),
                ("toggle", c.c_uint16), ("flags", c.c_uint16 * 2),
                ("buffers", c.POINTER(c.c_uint8) * 2), ("buffer_bytes", c.c_size_t),
                ("scratch", c.POINTER(c.c_uint8)), ("scratch_bytes", c.c_size_t),
                ("chunk_previous", c.POINTER(c.c_uint8)),
                ("chunk_previous_bytes", c.c_size_t),
                ("convert", CONVERT), ("convert_context", c.c_void_p)]


class AvfLzssState(c.Structure):
    _fields_ = [("ring", c.c_uint8 * RING), ("ring_defined", c.c_uint8 * RING),
                ("ring_position", c.c_uint32), ("counter", c.c_uint8),
                ("flag_bits", c.c_uint32), ("input_position", c.c_int32),
                ("produced", c.c_uint32)]


def build_library() -> Path:
    if "AVF_DECODER_LIBRARY" not in os.environ:
        subprocess.run(["sh", str(BUILD_SCRIPT)], check=True, capture_output=True)
    return LIBRARY


def bind(path: Path) -> c.CDLL:
    lib = c.CDLL(str(path))
    u8p = c.POINTER(c.c_uint8)
    lib.avf_open.argtypes = [u8p, c.c_size_t, c.POINTER(AvfFile)]
    lib.avf_record.argtypes = [c.POINTER(AvfFile), c.c_int32, c.POINTER(AvfRecord)]
    lib.avf_lzss_expand.argtypes = [u8p, c.c_uint32, u8p, c.c_size_t, c.POINTER(AvfLzssState)]
    lib.avf_stream_init.argtypes = [c.POINTER(AvfStream), c.POINTER(AvfFile), u8p, u8p,
                                    c.c_size_t, u8p, c.c_size_t, CONVERT, c.c_void_p]
    lib.avf_stream_reset.argtypes = [c.POINTER(AvfStream)]
    lib.avf_stream_reset.restype = None
    lib.avf_decode_single.argtypes = [c.POINTER(AvfStream), c.c_int16, c.POINTER(AvfLzssState)]
    lib.avf_decode_double.argtypes = [c.POINTER(AvfStream), c.c_int16, c.POINTER(c.c_int),
                                      c.POINTER(AvfLzssState)]
    lib.avf_get_chunk.argtypes = [c.POINTER(AvfStream), c.c_int16, u8p, c.c_size_t, u8p,
                                  c.c_size_t, c.c_int16, c.POINTER(c.c_uint16),
                                  c.POINTER(u8p), c.POINTER(c.c_size_t),
                                  c.POINTER(AvfLzssState)]
    lib.avf_status_name.argtypes = [c.c_int]
    lib.avf_status_name.restype = c.c_char_p
    for name in ("avf_open", "avf_record", "avf_lzss_expand", "avf_stream_init",
                 "avf_decode_single", "avf_decode_double", "avf_get_chunk"):
        getattr(lib, name).restype = c.c_int
    return lib


def ubuf(data: bytes) -> c.Array:
    return (c.c_uint8 * max(1, len(data))).from_buffer_copy(data or b"\0")


class Session:
    """One native stream over an in-memory file, keeping every buffer alive."""

    def __init__(self, lib: c.CDLL, data: bytes, *, fill: int = 0x5A,
                 convert: bool = False, buffer_bytes: int | None = None,
                 scratch_bytes: int | None = None):
        self.lib = lib
        self.raw = ubuf(data)
        self.file = AvfFile()
        self.status = lib.avf_open(self.raw, len(data), c.byref(self.file))
        if self.status != OK:
            return
        frame = self.file.frame_bytes
        size = frame if buffer_bytes is None else buffer_bytes
        self.buffers = [(c.c_uint8 * max(1, size))(*([fill] * size)) for _ in range(2)]
        scratch = self.file.max_unpacked if scratch_bytes is None else scratch_bytes
        self.scratch = (c.c_uint8 * max(1, scratch))()
        self.calls: list[tuple[int, int, int]] = []
        self.callback = CONVERT(self._convert) if convert else CONVERT()
        self.stream = AvfStream()
        self.init_status = lib.avf_stream_init(
            c.byref(self.stream), c.byref(self.file), self.buffers[0], self.buffers[1], size,
            self.scratch, scratch, self.callback, None)

    def _convert(self, _context, pixels, byte_count):
        address = c.addressof(pixels.contents)
        slot, offset = -1, address
        for index, buffer in enumerate(self.buffers + list(getattr(self, "extra", []))):
            base = c.addressof(buffer)
            if base <= address < base + c.sizeof(buffer) or (address == base):
                slot, offset = index, address - base
        self.calls.append((slot, offset, byte_count))
        # A visible, non-idempotent transform exposes repeated conversion.
        view = (c.c_uint16 * (byte_count // 2)).from_address(address)
        for k in range(byte_count // 2):
            view[k] = (view[k] + 1) & 0xFFFF

    def buffer(self, slot: int) -> bytes:
        return bytes(self.buffers[slot])[:self.file.frame_bytes]

    def single(self, index: int, state: AvfLzssState | None = None) -> int:
        return self.lib.avf_decode_single(c.byref(self.stream), index,
                                          c.byref(state) if state is not None else None)

    def double(self, index: int) -> tuple[int, int]:
        written = c.c_int(-1)
        status = self.lib.avf_decode_double(c.byref(self.stream), index, c.byref(written), None)
        return status, written.value

    def chunk(self, index: int, out: c.Array, override: c.Array | None = None,
              override_bytes: int = 0, override_index: int = 0, flags: int = 0):
        flag_word = c.c_uint16(flags)
        result = c.POINTER(c.c_uint8)()
        result_bytes = c.c_size_t(0)
        status = self.lib.avf_get_chunk(
            c.byref(self.stream), index, out, c.sizeof(out), override, override_bytes,
            override_index, c.byref(flag_word), c.byref(result), c.byref(result_bytes), None)
        address = c.addressof(result.contents) if result else 0
        return status, flag_word.value, address, result_bytes.value

    def snapshot(self) -> tuple:
        s = self.stream
        return (s.last_index, s.toggle, s.flags[0], s.flags[1],
                bytes(self.buffers[0]), bytes(self.buffers[1]),
                c.cast(s.chunk_previous, c.c_void_p).value, s.chunk_previous_bytes)


def frame_pixels(width: int, height: int, seed: int) -> bytes:
    return struct.pack(f"<{width * height}H",
                       *(((i * 37 + seed * 101) ^ (i >> 3)) & 0x7FFF
                         for i in range(width * height)))


class AvfDecoderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.lib = bind(build_library())

    # -- container ---------------------------------------------------------------
    def test_open_reads_header_fields(self) -> None:
        data = build_avf(4, 3, [(0, frame_pixels(4, 3, 1), None), (0, None, None)])
        s = Session(self.lib, data)
        self.assertEqual(s.status, OK)
        f = s.file
        self.assertEqual((f.frame_count, f.width, f.height, f.bits_per_pixel), (2, 4, 3, 16))
        self.assertEqual((f.compression, f.frame_bytes, f.max_unpacked, f.header_1c),
                         (2, 24, 24, 66))
        record = AvfRecord()
        self.assertEqual(self.lib.avf_record(c.byref(f), 1, c.byref(record)), OK)
        self.assertEqual((record.index, record.packed_bytes, record.unpacked_bytes), (1, 0, 0))
        self.assertEqual(self.lib.avf_record(c.byref(f), 2, c.byref(record)), RANGE)
        self.assertEqual(self.lib.avf_record(c.byref(f), -1, c.byref(record)), RANGE)

    def test_open_rejections(self) -> None:
        good = build_avf(2, 2, [(0, frame_pixels(2, 2, 0), None)])
        cases = {
            "signature": (build_avf(2, 2, [(0, None, None)], signature=b"AVF WayneSikez\0"),
                          SIGNATURE_ERR),
            "version": (build_avf(2, 2, [(0, None, None)], version=(3, 0)), VERSION),
            "subversion": (build_avf(2, 2, [(0, None, None)], version=(2, 1)), VERSION),
            "short header": (good[:0x20], TRUNCATED),
            "short table": (good[:HEADER_BYTES + RECORD_BYTES - 1], TRUNCATED),
            "negative count": (build_avf(2, 2, [], count=-1), CORRUPT),
            "zero width": (build_avf(0, 2, [(0, None, None)]), CORRUPT),
            "negative height": (build_avf(2, -2, [(0, None, None)]), CORRUPT),
            "bpp 8": (build_avf(2, 2, [(0, None, None)], bpp=8), UNSUPPORTED),
        }
        for name, (data, expected) in cases.items():
            with self.subTest(name):
                self.assertEqual(Session(self.lib, data).status, expected)
        self.assertEqual(Session(self.lib, build_avf(2, 2, [])).status, OK)

    def test_chunk_outside_file_fails_at_decode(self) -> None:
        payload = frame_pixels(2, 2, 3)
        data = build_avf(2, 2, [(0, payload, None)])
        s = Session(self.lib, data[:-1])
        self.assertEqual(s.status, OK)  # the original maps first, reads later
        before = s.snapshot()
        self.assertEqual(s.single(0), TRUNCATED)
        self.assertEqual(s.snapshot(), before)

    def test_compression_byte_checked_only_for_data(self) -> None:
        data = build_avf(2, 2, [(0, None, None), (0, frame_pixels(2, 2, 1), None)],
                         compression=1)
        s = Session(self.lib, data)
        self.assertEqual(s.status, OK)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.stream.flags[0], 0xC)
        self.assertEqual(s.single(1), UNSUPPORTED)

    # -- LZSS --------------------------------------------------------------------
    def lzss(self, src: bytes, capacity: int, dry: bool = False):
        state = AvfLzssState()
        out = (c.c_uint8 * max(1, capacity))(*([0xEE] * capacity))
        status = self.lib.avf_lzss_expand(ubuf(src), len(src), None if dry else out,
                                          capacity, c.byref(state))
        return status, bytes(out)[:state.produced], state

    def test_lzss_literals_and_counter_wrap(self) -> None:
        plain = bytes(range(256)) * 3 + b"tail"
        src = lzss_literals(plain)
        status, out, state = self.lzss(src, len(plain))
        self.assertEqual(status, OK)
        self.assertEqual(out, plain)
        self.assertEqual(state.produced, len(plain))
        self.assertEqual(state.input_position, len(src))
        self.assertEqual(state.counter, len(src) & 0xFF)
        self.assertEqual(state.ring_position, (RING_START + len(plain)) & 0xFFF)

    def test_lzss_initial_spaces_and_overlap(self) -> None:
        # Match into the space-filled ring, then an overlapping self-copy.
        tokens = [("match", 0, 5), ("lit", 0x41), ("lit", 0x42),
                  ("match", (RING_START + 5) & 0xFFF, 12)]
        src = lzss_tokens(tokens)
        status, out, state = self.lzss(src, 64)
        self.assertEqual(status, OK)
        self.assertEqual(out, b"     AB" + b"AB" * 6)
        self.assertEqual(out, lzss_reference(src)[0])
        ring = bytes(state.ring)
        self.assertEqual(ring[RING_START:], out[:RING - RING_START])
        self.assertEqual(ring[0], out[RING - RING_START])
        self.assertEqual(bytes(state.ring_defined)[RING_START:], b"\1" * (RING - RING_START))
        self.assertEqual(state.ring_position, 1)

    def test_lzss_terminations(self) -> None:
        body = lzss_tokens([("lit", 1), ("lit", 2), ("match", 0, 3)])
        cases = {
            "flag": lzss_tokens([("lit", 9)] * 8),
            "match_first": body,
            "match_second": body + bytes(((0x10 + len(body)) & 0xFF,)),
        }
        for name, src in cases.items():
            with self.subTest(name):
                expected, end = lzss_reference(src)
                self.assertEqual(end, name)
                status, out, state = self.lzss(src, 64)
                self.assertEqual(status, OK)
                self.assertEqual(out, expected)
                self.assertEqual(state.input_position, len(src))
        literal_end = lzss_tokens([("lit", 9)] * 3)[:-1]
        self.assertEqual(lzss_reference(lzss_tokens([("lit", 9)] * 3))[1], "match_first")
        status, out, state = self.lzss(literal_end, 64)
        self.assertEqual((status, out), (OK, b"\x09\x09"))
        self.assertEqual(lzss_reference(literal_end)[1], "literal")
        self.assertEqual(self.lzss(b"", 4)[0], OK)

    def test_lzss_counts_second_match_byte(self) -> None:
        body = lzss_tokens([("lit", 1), ("match", 0, 3)])
        src = body + b"\x00"
        state = self.lzss(src, 16)[2]
        self.assertEqual(state.counter, len(src) & 0xFF)

    def test_lzss_rejects_overflow_and_undefined_ring(self) -> None:
        src = lzss_literals(b"abcdef")
        status, out, _ = self.lzss(src, 5)
        self.assertEqual(status, CORRUPT)
        self.assertEqual(self.lzss(src, 6)[0], OK)
        undefined = lzss_tokens([("match", RING_START + 2, 3)])
        self.assertEqual(self.lzss(undefined, 16)[0], CORRUPT)
        # Bytes become defined once written, including within one match.
        defined = lzss_tokens([("lit", 7), ("match", RING_START, 6)])
        status, out, _ = self.lzss(defined, 16)
        self.assertEqual((status, out), (OK, b"\x07" * 7))

    def test_lzss_dry_run_matches_output_length(self) -> None:
        src = lzss_compress(frame_pixels(8, 8, 2))
        status, _, state = self.lzss(src, 128, dry=True)
        self.assertEqual((status, state.produced), (OK, 128))

    # -- type 0 ------------------------------------------------------------------
    def test_key_frame_single(self) -> None:
        """avf_decode_single (0x41546f): key frames decode into the single buffer."""
        pixels = [frame_pixels(4, 2, k) for k in range(2)]
        data = build_avf(4, 2, [(0, pixels[0], None), (0, pixels[1], None)])
        s = Session(self.lib, data, convert=True)
        state = AvfLzssState()
        self.assertEqual(s.single(1, state), OK)
        self.assertEqual(s.buffer(0), bytes(struct.pack("<8H", *[(w + 1) & 0xFFFF
                                                                  for w in words(pixels[1])])))
        self.assertEqual(s.calls, [(0, 0, 16)])
        self.assertEqual((s.stream.flags[0], s.stream.last_index), (1, 1))
        self.assertEqual(state.produced, 16)

    def test_key_frame_output_length_rules(self) -> None:
        # Shorter than the frame: the tail keeps the previous frame.
        data = build_avf(4, 2, [(0, frame_pixels(4, 1, 0), None)])
        s = Session(self.lib, data)
        before = s.snapshot()
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.buffer(0)[8:], before[4][8:16])
        # LZSS shorter than declared: single mode converts the declared size.
        lying = bytearray(data)
        struct.pack_into("<I", lying, HEADER_BYTES + 0xA, 10)
        s = Session(self.lib, bytes(lying), convert=True)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.calls, [(0, 0, 10)])
        # LZSS longer than declared but inside the frame (reviewer case 2).
        long_out = build_avf(4, 2, [(0, frame_pixels(4, 2, 1), None)])
        long_out = bytearray(long_out)
        struct.pack_into("<I", long_out, HEADER_BYTES + 0xA, 8)
        s = Session(self.lib, bytes(long_out), convert=True)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.buffer(0), bytes(struct.pack(
            "<8H", *([(w + 1) & 0xFFFF for w in words(frame_pixels(4, 2, 1))[:4]] +
                     words(frame_pixels(4, 2, 1))[4:]))))
        # Output past the frame, or a declared size past it, is rejected.
        past = build_avf(2, 2, [(0, frame_pixels(4, 2, 1), None)])
        for declared in (8, 16):
            mutated = bytearray(past)
            struct.pack_into("<I", mutated, HEADER_BYTES + 0xA, declared)
            s = Session(self.lib, bytes(mutated))
            before = s.snapshot()
            with self.subTest(declared=declared):
                self.assertEqual(s.single(0), CORRUPT)
                self.assertEqual(s.double(0)[0], CORRUPT)
                self.assertEqual(s.snapshot(), before)

    def test_key_declared_size_versus_conversion_extent(self) -> None:
        # Root review P2: the original decompresses into the frame (bounded by
        # frame_bytes) and 0x4c7314 converts (declared >> 1) words, doing
        # nothing when conversion is disabled. 2x2 frame = 8 bytes whose LZSS
        # expands to 8 bytes; only the declared size is patched.
        payload = frame_pixels(2, 2, 3)
        base = build_avf(2, 2, [(0, payload, None)])

        def patched(declared: int) -> bytes:
            data = bytearray(base)
            struct.pack_into("<I", data, HEADER_BYTES + 0xA, declared)
            return bytes(data)

        def bumped(count: int) -> bytes:
            head = [(w + 1) & 0xFFFF for w in words(payload)[:count]]
            return struct.pack("<4H", *(head + words(payload)[count:]))

        # (declared, conversion hook present, expected status, converted words)
        cases = [
            (16, False, OK, 0), (0x1000, False, OK, 0), (9, False, OK, 0),
            (9, True, OK, 4), (8, True, OK, 4), (1, True, OK, 0),
            (16, True, CORRUPT, 0), (10, True, CORRUPT, 0), (17, True, CORRUPT, 0),
            (0x1000, True, CORRUPT, 0),
        ]
        for declared, hooked, expected, converted in cases:
            for reader in ("single", "double"):
                with self.subTest(declared=declared, hooked=hooked, reader=reader):
                    s = Session(self.lib, patched(declared), convert=hooked)
                    before = s.snapshot()
                    if reader == "single":
                        status, slot = s.single(0), 0
                    else:
                        status, written = s.double(0)
                        slot = 1
                        self.assertEqual(written, 1 if expected == OK else -1)
                    self.assertEqual(status, expected)
                    if expected != OK:
                        # Validate before any write: nothing visible changed.
                        self.assertEqual(s.snapshot(), before)
                        self.assertEqual(s.calls, [])
                        continue
                    self.assertEqual(s.buffer(slot), bumped(converted))
                    self.assertEqual(s.buffer(1 - slot), bytes([0x5A]) * 8)
                    self.assertEqual(s.stream.flags[slot], 1)
                    self.assertEqual(s.stream.last_index, 0)
                    expected_calls = [(slot, 0, declared)] if converted else []
                    self.assertEqual(s.calls, expected_calls)
        # A failed declared-size check keeps the prefix of earlier successes.
        two = build_avf(2, 2, [(0, payload, None), (0, payload, None)])
        data = bytearray(two)
        struct.pack_into("<I", data, HEADER_BYTES + RECORD_BYTES + 0xA, 16)
        s = Session(self.lib, bytes(data), convert=True)
        self.assertEqual(s.single(0), OK)
        before, calls = s.snapshot(), list(s.calls)
        self.assertEqual(s.single(1), CORRUPT)
        self.assertEqual(s.snapshot(), before)
        self.assertEqual(s.calls, calls)

    def test_get_chunk_key_larger_than_frame(self) -> None:
        # GetChunk allocates unpacked_bytes, so a large key record is valid there.
        payload = frame_pixels(4, 2, 2)
        data = build_avf(2, 2, [(0, payload, None)])
        s = Session(self.lib, data)
        out = (c.c_uint8 * 16)()
        status, flags, address, size = s.chunk(0, out)
        self.assertEqual((status, flags, size), (OK, 1, 16))
        self.assertEqual(bytes(out), payload)
        self.assertEqual(s.single(0), CORRUPT)
        short = (c.c_uint8 * 15)()
        self.assertEqual(Session(self.lib, data).chunk(0, short)[0], ARGUMENT)

    # -- type 1 ------------------------------------------------------------------
    def test_type1_commands_keep_uncovered_pixels_and_convert_once(self) -> None:
        stream = (cmd_copy(1, [0x1111, 0x2222]) + cmd_fill(0x0707, 4, 3) +
                  cmd_repeat([0x0A0A, 0x0B0B, 0x0C0C], [8, 12]))
        data = build_avf(4, 4, [(1, stream, None)])
        s = Session(self.lib, data, fill=0, convert=True)
        self.assertEqual(s.single(0), OK)
        expected = [0] * 16
        expected[1:3] = [0x1111, 0x2222]
        expected[4:7] = [0x0707] * 3
        expected[8:11] = [0x0A0A, 0x0B0B, 0x0C0C]
        expected[12:15] = [0x0A0A, 0x0B0B, 0x0C0C]
        self.assertEqual(words(s.buffer(0)), [(w + 1) & 0xFFFF for w in expected])
        self.assertEqual(s.calls, [(0, 0, 32)])
        self.assertEqual(s.stream.flags[0], 2)

    def test_type1_over_previous_frame_double_converts_stale_pixels(self) -> None:
        key = frame_pixels(2, 2, 4)
        data = build_avf(2, 2, [(0, key, None), (1, cmd_fill(0x10, 0, 1), None)])
        s = Session(self.lib, data, convert=True)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.single(1), OK)
        once = [(w + 1) & 0xFFFF for w in words(key)]
        self.assertEqual(words(s.buffer(0)), [0x11] + [(w + 1) & 0xFFFF for w in once[1:]])

    # -- type 2 ------------------------------------------------------------------
    def test_type2_requires_decoded_predecessor(self) -> None:
        key = frame_pixels(3, 1, 6)
        data = build_avf(3, 1, [(0, key, None), (2, cmd_copy(2, [0x7777]), None)])
        s = Session(self.lib, data)
        before = s.snapshot()
        self.assertEqual(s.single(1), SEQUENCE)
        self.assertEqual(s.snapshot(), before)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.single(1), OK)
        self.assertEqual(words(s.buffer(0)), words(key)[:2] + [0x7777])
        self.assertEqual(s.stream.flags[0], 4)
        # Replaying the delta needs index 0 to be the last decoded frame again.
        self.assertEqual(s.single(1), SEQUENCE)
        s.lib.avf_stream_reset(c.byref(s.stream))
        self.assertEqual(s.single(1), SEQUENCE)

    def test_type2_converts_each_span(self) -> None:
        key = bytes(8)
        stream = (cmd_copy(0, [5]) + cmd_fill(9, 1, 2) + cmd_repeat([3], [3, 0]))
        data = build_avf(4, 1, [(0, key, None), (2, stream, None)])
        s = Session(self.lib, data, convert=True)
        self.assertEqual(s.single(0), OK)
        s.calls.clear()
        self.assertEqual(s.single(1), OK)
        self.assertEqual(s.calls, [(0, 0, 2), (0, 2, 4), (0, 6, 2), (0, 0, 2)])
        self.assertEqual(words(s.buffer(0)), [4, 10, 10, 4])

    def test_empty_record_keeps_buffer_and_sets_flags(self) -> None:
        key = frame_pixels(2, 1, 1)
        data = build_avf(2, 1, [(0, key, None), (2, None, None), (2, cmd_copy(0, [1]), None)])
        s = Session(self.lib, data)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.single(1), OK)
        self.assertEqual((s.stream.flags[0], s.stream.last_index), (0xC, 1))
        self.assertEqual(s.buffer(0), key)
        self.assertEqual(s.single(2), OK)
        self.assertEqual(words(s.buffer(0)), [1, words(key)[1]])

    def test_empty_record_still_requires_delta_sequence(self) -> None:
        data = build_avf(2, 1, [(0, bytes(4), None), (2, None, None)])
        self.assertEqual(Session(self.lib, data).single(1), SEQUENCE)

    def test_unknown_record_type(self) -> None:
        data = build_avf(2, 1, [(3, cmd_fill(1, 0, 2), None), (3, None, None)])
        s = Session(self.lib, data)
        before = s.snapshot()
        self.assertEqual(s.single(0), UNSUPPORTED)
        self.assertEqual(s.snapshot(), before)
        self.assertEqual(s.single(1), OK)  # empty records never inspect the type
        self.assertEqual(s.stream.flags[0], 0xC)

    # -- double buffer -----------------------------------------------------------
    def test_double_buffer_toggle_and_predecessor(self) -> None:
        """avf_decode_double (0x4156ea): the buffer toggles only on a non-empty success."""
        key = frame_pixels(2, 2, 8)
        data = build_avf(2, 2, [(0, key, None), (2, cmd_fill(0x1234, 3, 1), None),
                                (2, None, None), (2, cmd_fill(0x4321, 0, 1), None),
                                (1, cmd_fill(0x5555, 1, 1), None)])
        s = Session(self.lib, data, fill=0x33)
        self.assertEqual(s.double(0), (OK, 1))
        self.assertEqual((s.stream.toggle, s.stream.flags[1]), (1, 1))
        self.assertEqual(s.buffer(1), key)
        self.assertEqual(s.double(1), (OK, 0))
        self.assertEqual(words(s.buffer(0)), words(key)[:3] + [0x1234])
        self.assertEqual((s.stream.toggle, s.stream.flags[0]), (0, 4))
        self.assertEqual(s.double(2), (OK, 1))
        self.assertEqual((s.stream.toggle, s.stream.flags[1]), (0, 0xC))
        self.assertEqual(s.double(3), (OK, 1))
        self.assertEqual(words(s.buffer(1)), [0x4321] + words(key)[1:3] + [0x1234])
        # Type 1 writes over the older buffer without copying the predecessor.
        self.assertEqual(s.double(4), (OK, 0))
        self.assertEqual(words(s.buffer(0)), words(key)[:1] + [0x5555] + words(key)[2:3] +
                         [0x1234])

    # -- random access chunk -----------------------------------------------------
    def test_get_chunk_sequence(self) -> None:
        """avf_get_chunk (0x415176): key frame, then deltas after their predecessor."""
        key = frame_pixels(2, 2, 9)
        data = build_avf(2, 2, [(0, key, None), (2, cmd_fill(1, 2, 2), None), (2, None, None),
                                (1, cmd_copy(0, [8, 8]), None)])
        s = Session(self.lib, data, convert=True)
        a = (c.c_uint8 * 8)(*([0x44] * 8))
        b = (c.c_uint8 * 8)(*([0x44] * 8))
        s.extra = [a, b]
        status, flags, address, size = s.chunk(1, a)
        self.assertEqual(status, SEQUENCE)
        status, flags, address, size = s.chunk(0, a, flags=0x100)
        self.assertEqual((status, flags, address, size), (OK, 0x101, c.addressof(a), 8))
        self.assertEqual(words(bytes(a)), [(w + 1) & 0xFFFF for w in words(key)])
        status, flags, address, size = s.chunk(1, b)
        self.assertEqual((status, flags, address, size), (OK, 4, c.addressof(b), 8))
        self.assertEqual(words(bytes(b))[2:], [2, 2])
        status, flags, address, size = s.chunk(2, a)
        self.assertEqual((status, flags, address, size), (OK, 0xC, c.addressof(b), 8))
        status, flags, address, size = s.chunk(3, a)
        self.assertEqual((status, flags, address, size), (OK, 2, c.addressof(a), 8))
        self.assertEqual(words(bytes(a))[:2], [9, 9])

    def test_get_chunk_override_predecessor(self) -> None:
        data = build_avf(2, 1, [(0, bytes(4), None), (2, cmd_copy(1, [6]), None)])
        s = Session(self.lib, data)
        prior = (c.c_uint8 * 4)(1, 0, 2, 0)
        out = (c.c_uint8 * 4)()
        # A zero override index disables the override (original param_5 == 0).
        self.assertEqual(s.chunk(1, out, prior, 4, 0)[0], SEQUENCE)
        data2 = build_avf(2, 1, [(0, bytes(4), None), (0, bytes(4), None),
                                 (2, cmd_copy(1, [6]), None)])
        s2 = Session(self.lib, data2)
        status, flags, address, size = s2.chunk(2, out, prior, 4, 1)
        self.assertEqual((status, flags, size), (OK, 4, 4))
        self.assertEqual(words(bytes(out)), [1, 6])
        short = (c.c_uint8 * 2)()
        self.assertEqual(s2.chunk(2, out, short, 2, 1)[0], CORRUPT)

    # -- command-stream corner cases ---------------------------------------------
    def test_command_corner_cases(self) -> None:
        key = bytes(range(16))
        cases = {
            # Bit 31 of the copy count is ignored by every use in 0x416af3.
            "copy count bit31": (cmd_copy(0, [0xABCD], 0x80000001), OK,
                                 [0xABCD] + words(key)[1:]),
            # 32-bit pointer arithmetic wraps the doubled pixel offset.
            "offset wrap": (cmd_fill(0x1111, 0x80000002, 1), OK,
                            words(key)[:2] + [0x1111] + words(key)[3:]),
            "fill zero": (cmd_fill(0x1111, 99, 0), OK, words(key)),
            "repeat no runs": (cmd_repeat([1, 2], [], 0), OK, words(key)),
            "repeat negative runs": (cmd_repeat([1, 2], [], -3), OK, words(key)),
        }
        for kind in (1, 2):
            for name, (stream, status, expected) in cases.items():
                with self.subTest(kind=kind, case=name):
                    data = build_avf(8, 1, [(0, key, None), (kind, stream, None)])
                    s = Session(self.lib, data)
                    self.assertEqual(s.single(0), OK)
                    self.assertEqual(s.single(1), status)
                    self.assertEqual(words(s.buffer(0)), expected)

    def test_negative_fill_count(self) -> None:
        """fill16 (0x43ef77) stores nothing for a zero or negative signed count."""
        key = bytes(8)
        # Type 1 ignores it; type 2 converts (count & 0x7fffffff) pixels, which
        # 0x4c7314 skips when conversion is disabled (no hook).
        cases = ((1, -1, True, OK), (2, -1, True, CORRUPT), (2, -1, False, OK),
                 (2, -0x7FFFFFFE, True, OK), (2, -0x80000000, True, OK),
                 (2, 0x7FFFFFFF, False, CORRUPT))
        for kind, count, hook, status in cases:
            with self.subTest(kind=kind, count=count, hook=hook):
                data = build_avf(4, 1, [(0, key, None), (kind, cmd_fill(7, 0, count), None)])
                s = Session(self.lib, data, convert=hook)
                self.assertEqual(s.single(0), OK)
                s.calls.clear()
                self.assertEqual(s.single(1), status)
                if status == OK and kind == 2:
                    # 0x4c7314 converts nothing below two bytes; such calls are omitted.
                    converted = (count << 1) & 0xFFFFFFFF
                    self.assertEqual(s.calls, [(0, 0, converted)] if hook and converted >= 2
                                     else [])
        # Out-of-frame offset with nothing to fill or convert is accepted.
        data = build_avf(4, 1, [(0, key, None), (2, cmd_fill(7, 0x40000000, -0x7FFFFFFB), None)])
        s = Session(self.lib, data)
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.single(1), OK)

    def test_malformed_command_streams_change_nothing(self) -> None:
        key = frame_pixels(4, 1, 2)
        bad = {
            "unknown command": (b"\x41" + bytes(10), UNSUPPORTED),
            "copy past frame": (cmd_copy(3, [1, 2]), CORRUPT),
            "copy past stream": (cmd_copy(0, [1, 2], 3), CORRUPT),
            "copy header cut": (cmd_copy(0, [1])[:6], CORRUPT),
            "fill past frame": (cmd_fill(1, 2, 3), CORRUPT),
            "fill negative offset": (cmd_fill(1, -1, 1), CORRUPT),
            "fill header cut": (cmd_fill(1, 0, 1)[:10], CORRUPT),
            "repeat past frame": (cmd_repeat([1, 2], [0, 3]), CORRUPT),
            "repeat offsets cut": (cmd_repeat([1], [0, 1])[:-1], CORRUPT),
            "valid then bad": (cmd_fill(9, 0, 4) + b"\x00", UNSUPPORTED),
        }
        for kind in (1, 2):
            for name, (stream, status) in bad.items():
                with self.subTest(kind=kind, case=name):
                    data = build_avf(4, 1, [(0, key, None), (kind, stream, None)])
                    s = Session(self.lib, data, convert=True)
                    self.assertEqual(s.single(0), OK)
                    before = s.snapshot()
                    calls = list(s.calls)
                    self.assertEqual(s.single(1), status)
                    self.assertEqual(s.snapshot(), before)
                    self.assertEqual(s.calls, calls)

    def test_buffers_and_scratch_capacity(self) -> None:
        data = build_avf(4, 1, [(0, bytes(8), None), (2, cmd_fill(1, 0, 4), None)])
        self.assertEqual(Session(self.lib, data, buffer_bytes=7).init_status, ARGUMENT)
        s = Session(self.lib, data, scratch_bytes=4)
        self.assertEqual(s.init_status, OK)  # scratch is needed only for types 1/2
        self.assertEqual(s.single(0), OK)
        self.assertEqual(s.single(1), ARGUMENT)
        out = (c.c_uint8 * 7)()
        self.assertEqual(Session(self.lib, data).chunk(0, out)[0], ARGUMENT)

    def test_status_names(self) -> None:
        self.assertEqual([self.lib.avf_status_name(k).decode() for k in range(9)], STATUS)
        self.assertEqual(self.lib.avf_status_name(99).decode(), "UNKNOWN")


SANITIZER_DRIVER = r"""
#include "avf_decoder.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint8_t *slurp(const char *path, size_t *size) {
    FILE *f = fopen(path, "rb"); long n; uint8_t *data;
    if (!f) return NULL;
    fseek(f, 0, SEEK_END); n = ftell(f); fseek(f, 0, SEEK_SET);
    data = malloc(n ? (size_t)n : 1); *size = fread(data, 1, (size_t)n, f); fclose(f);
    return data;
}

static void bump(void *ctx, uint8_t *p, uint32_t n) {
    (void)ctx; for (uint32_t i = 0; i + 1 < n; i += 2) p[i] ^= 1;
}

int main(int argc, char **argv) {
    unsigned long total = 0, ok = 0, opened = 0;
    for (int a = 1; a < argc; ++a) {
        size_t size = 0; uint8_t *exact = slurp(argv[a], &size), *data;
        AvfFile file; AvfStream st; AvfStatus s;
        if (!exact) return 2;
        data = malloc(size ? size : 1); memcpy(data, exact, size); free(exact);
        s = avf_open(data, size, &file);
        if (s == AVF_OK) {
            ++opened;
            size_t fb = file.frame_bytes, sb = file.max_unpacked;
            uint8_t *b0 = malloc(fb), *b1 = malloc(fb), *sc = malloc(sb ? sb : 1);
            uint8_t *o0 = malloc(fb > sb ? fb : (sb ? sb : 1)), *o1 = malloc(fb > sb ? fb : (sb ? sb : 1));
            size_t ob = fb > sb ? fb : (sb ? sb : 1);
            AvfLzssState lz;
            memset(b0, 0x5a, fb); memset(b1, 0x5a, fb); memset(o0, 0x5a, ob); memset(o1, 0x5a, ob);
            if (avf_stream_init(&st, &file, b0, b1, fb, sc, sb, bump, NULL) == AVF_OK) {
                for (int pass = 0; pass < 3; ++pass) {
                    for (int16_t i = -1; i <= file.frame_count; ++i) {
                        const uint8_t *r; size_t rb; uint16_t fl = 0; int w; AvfStatus d;
                        if (pass == 0) d = avf_decode_single(&st, i, &lz);
                        else if (pass == 1) d = avf_decode_double(&st, i, &w, &lz);
                        else d = avf_get_chunk(&st, i, (i & 1) ? o1 : o0, ob, NULL, 0, 0, &fl, &r, &rb, &lz);
                        total += d; ok += d == AVF_OK;
                    }
                    avf_stream_reset(&st);
                }
            }
            free(b0); free(b1); free(sc); free(o0); free(o1);
        }
        for (uint32_t cut = 0; cut < 64 && cut < size; ++cut) {
            AvfLzssState lz; uint8_t out[64];
            total += avf_lzss_expand(data + size - cut - 1, cut, out, sizeof out, &lz);
        }
        free(data);
    }
    printf("sanitizer-ok files=%d opened=%lu decodes_ok=%lu status_sum=%lu\n",
           argc - 1, opened, ok, total);
    return 0;
}
"""


def malformed_corpus() -> dict[str, bytes]:
    """Bounded malformed inputs for the sanitizer run (no game bytes)."""
    key = frame_pixels(4, 2, 1)
    good = build_avf(4, 2, [(0, key, None), (2, cmd_fill(1, 0, 8), None),
                            (1, cmd_repeat([1, 2], [0, 6]), None), (2, None, None)])
    out: dict[str, bytes] = {"good": good}
    for cut in (0, 1, 0x20, 0x21, 0x22, HEADER_BYTES + RECORD_BYTES * 4 - 1,
                HEADER_BYTES + RECORD_BYTES * 4 + 3, len(good) - 1):
        out[f"cut{cut}"] = good[:cut]
    big = bytearray(good)
    struct.pack_into("<h", big, 0x15, 0x7FFF)
    out["count_overflow"] = bytes(big)
    for field, value in ((0x2, 0xFFFFFFF0), (0x6, 0x7FFFFFFF), (0xA, 0xFFFFFFFF),
                         (0xA, 0x80000000), (0xE, 2)):
        mutated = bytearray(good)
        struct.pack_into("<I" if field != 0xE else "<B", mutated, HEADER_BYTES + field, value)
        out[f"record0_{field:x}_{value:x}"] = bytes(mutated)
    dims = bytearray(good)
    struct.pack_into("<hh", dims, 0x17, 0x7FFF, 0x7FFF)
    out["huge_frame"] = bytes(dims)
    streams = [cmd_copy(0x7FFFFFFF, [1]), cmd_copy(0, [1], 0xFFFFFFFF), cmd_fill(1, 0, -1),
               cmd_fill(1, 0x7FFFFFFF, 0x7FFFFFFF), cmd_repeat([1] * 255, [0], 0x7FFFFFFF),
               b"\x80\x01", b" ", b"@", b"\x13" * 9,
               lzss_tokens([("match", RING_START + 4, 18)])]
    for k, stream in enumerate(streams):
        for kind in (1, 2):
            frames = [(0, key, None), (kind, stream if k < len(streams) - 1 else bytes(4),
                                       None if k < len(streams) - 1 else stream)]
            out[f"stream{k}_t{kind}"] = build_avf(4, 2, frames)
    return out


class AvfSanitizerTests(unittest.TestCase):
    def test_asan_ubsan_driver(self) -> None:
        clang = shutil.which("clang") or "/usr/bin/clang"
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            (tmp_path / "driver.c").write_text(SANITIZER_DRIVER)
            exe = tmp_path / "driver"
            subprocess.run(
                [clang, "-std=c11", "-g", "-O1", "-Wall", "-Wextra", "-Werror",
                 "-fsanitize=address,undefined", "-fno-sanitize-recover=all",
                 "-I", str(PROJECT / "src"), str(tmp_path / "driver.c"),
                 str(PROJECT / "src/avf_decoder.c"), "-o", str(exe)],
                check=True, capture_output=True)
            paths = []
            for name, data in malformed_corpus().items():
                path = tmp_path / f"{name}.avf"
                path.write_bytes(data)
                paths.append(str(path))
            extra = os.environ.get("AVF_SANITIZER_FILES", "")
            paths += [p for p in extra.split(os.pathsep) if p]
            result = subprocess.run([str(exe), *paths], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(result.returncode, 0, result.stderr[-4000:])
            self.assertIn("sanitizer-ok", result.stdout)
            if extra:
                print("\n" + result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
