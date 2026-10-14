"""A-97.1 fixtures: bounded values, constructor image, transactional errors."""
import ctypes as c
from pathlib import Path
import struct
import unittest

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionfamily97.dylib"
OK, ARGUMENT, BODY, COUNT, NAME, SELECTOR, TAIL, BOUNDS, OVERLAP, LOOKUP_ERROR, CAPACITY = range(11)
LOOKUP = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t,
                     c.POINTER(c.POINTER(c.c_uint8)), c.POINTER(c.c_size_t))


class Entry(c.Structure):
    _fields_ = [("selector", c.c_int16), ("bytes", c.POINTER(c.c_uint8)),
                ("length", c.c_size_t), ("body_offset", c.c_size_t)]


class Decoded(c.Structure):
    _fields_ = [("raw_type", c.c_uint8), ("runtime_type", c.c_uint8),
                ("count", c.c_int16), ("names", (c.c_uint8 * 33) * 9),
                ("word_21", c.c_uint16), ("word_23", c.c_uint32),
                ("word_27", c.c_uint16), ("word_29", c.c_uint16),
                ("option_2b", c.c_uint8), ("word_2c", c.c_uint16),
                ("entries", Entry * 9),
                ("dependency_records", c.POINTER(c.c_uint8)),
                ("dependency_count", c.c_size_t), ("available_body_bytes", c.c_size_t),
                ("body_bytes", c.c_size_t), ("dependency_bytes", c.c_size_t)]


class Constructed(c.Structure):
    _fields_ = [("names_after", (c.c_uint8 * 33) * 9),
                ("selected_index", c.c_uint16), ("selector", c.c_int16),
                ("raw_type", c.c_uint8), ("runtime_type", c.c_uint8),
                ("random_advanced", c.c_uint8),
                ("random_state_before", c.c_uint32), ("random_state_after", c.c_uint32),
                ("payload_offset_before", c.c_uint32), ("payload_offset_after", c.c_uint32),
                ("allocation_bytes", c.c_size_t), ("body_bytes_consumed", c.c_size_t),
                ("dependency_records", c.POINTER(c.c_uint8)),
                ("dependency_count", c.c_size_t), ("dependency_bytes", c.c_size_t)]


def bind(path=LIBRARY):
    lib = c.CDLL(str(path))
    lib.action_family_97_decode.argtypes = [c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)]
    lib.action_family_97_decode.restype = c.c_int
    lib.action_family_97_body_length.argtypes = [c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(c.c_size_t)]
    lib.action_family_97_body_length.restype = c.c_int
    lib.action_family_97_construct.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
        c.c_uint32, c.c_uint32, LOOKUP, c.c_void_p, c.POINTER(c.c_uint8),
        c.c_size_t, c.POINTER(Constructed)]
    lib.action_family_97_construct.restype = c.c_int
    return lib


def buffer(data):
    return (c.c_uint8 * max(1, len(data))).from_buffer_copy(data or b"\0")


def body(names=(b"one",), entries=(b"",), tail=0,
         words=(0xFEDC, 0x89ABCDEF, 0x8123, 0x4567, 0xEF, 0xABCD)):
    if len(names) != len(entries):
        raise ValueError("fixture cardinality")
    raw = bytearray(struct.pack("<h", len(names)))
    for name in names:
        if len(name) > 32:
            raise ValueError("name too long")
        raw += name + bytes(33 - len(name))
    raw += struct.pack("<HIHHBH", *words)
    for value in entries:
        if isinstance(value, tuple):
            key = value[0]
            raw += struct.pack("<h", -1) + key + bytes(33 - len(key))
        else:
            raw += struct.pack("<h", len(value)) + value
    raw += bytes((i * 31 + 9) & 255 for i in range(tail * 16))
    return bytes(raw)


class DictionaryLookup:
    def __init__(self, rows=None, status=None):
        self.rows = rows or {}
        self.status = status
        self.calls = []
        self.held = None
        self.callback = LOOKUP(self.lookup)

    def lookup(self, _context, key, length, text, text_length):
        key = bytes(key[:length])
        self.calls.append(key)
        if self.status is not None:
            return self.status
        values = [v for k, v in self.rows.items() if k.upper() == key.upper()]
        if not values:
            return 1
        self.held = buffer(values[0])
        text[0] = c.cast(self.held, c.POINTER(c.c_uint8))
        text_length[0] = len(values[0])
        return 0


class Action97Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = bind()

    def decode(self, raw):
        source, out = buffer(raw), Decoded()
        status = self.lib.action_family_97_decode(source, len(raw), c.byref(out))
        return status, out, source

    def construct(self, raw, seed=1, offset=50, lookup=None, capacity=32767):
        source, out = buffer(raw), Constructed()
        payload = (c.c_uint8 * max(1, capacity))()
        status = self.lib.action_family_97_construct(source, len(raw), seed, offset,
            lookup.callback if lookup else LOOKUP(), None, payload, capacity, c.byref(out))
        return status, out, bytes(payload[:out.allocation_bytes]), source

    def assert_rejected(self, raw, expected):
        source, out, state = buffer(raw), Decoded(), Constructed()
        c.memset(c.byref(out), 0xA5, c.sizeof(out))
        c.memset(c.byref(state), 0xB6, c.sizeof(state))
        before, state_before = bytes(out), bytes(state)
        payload = buffer(bytes([0xC7]) * 32767)
        lookup = DictionaryLookup()
        self.assertEqual(self.lib.action_family_97_decode(source, len(raw), c.byref(out)), expected)
        self.assertEqual(bytes(out), before)
        self.assertEqual(self.lib.action_family_97_construct(source, len(raw), 1, 50,
            lookup.callback, None, payload, len(payload), c.byref(state)), expected)
        self.assertEqual(bytes(state), state_before)
        self.assertEqual(bytes(payload), bytes([0xC7]) * 32767)
        self.assertEqual(lookup.calls, [])
        self.assertEqual(bytes(source)[:len(raw)], raw)

    def test_valid_minimum_and_maximum_counts(self):
        for n in (1, 9):
            raw = body(tuple(f"n{i}".encode() for i in range(n)), tuple(b"" for _ in range(n)), tail=3)
            status, out, source = self.decode(raw)
            self.assertEqual(status, OK)
            self.assertEqual((out.raw_type, out.runtime_type, out.count), (0x97, 0x9F, n))
            self.assertEqual(out.body_bytes, 15 + 35 * n)
            self.assertEqual((out.dependency_count, out.dependency_bytes), (3, 48))
            self.assertEqual(c.cast(out.dependency_records, c.c_void_p).value, c.addressof(source) + out.body_bytes)
            self.assertEqual((out.word_21, out.word_23, out.word_27, out.word_29, out.option_2b, out.word_2c),
                             (0xFEDC, 0x89ABCDEF, 0x8123, 0x4567, 0xEF, 0xABCD))

    def test_variable_entries_and_borrowed_views(self):
        raw = body((b"a", b"b", b"c"), (b"x\0yz", (b"KEY",), b""), tail=2)
        status, out, source = self.decode(raw)
        self.assertEqual(status, OK)
        self.assertEqual([e.selector for e in out.entries[:3]], [4, -1, 0])
        self.assertEqual([e.length for e in out.entries[:3]], [4, 33, 0])
        for e in out.entries[:3]:
            self.assertEqual(c.cast(e.bytes, c.c_void_p).value, c.addressof(source) + e.body_offset + 2)
        length = c.c_size_t()
        self.assertEqual(self.lib.action_family_97_body_length(source, len(raw), c.byref(length)), OK)
        self.assertEqual(length.value, out.body_bytes)

    def test_all_truncated_prefixes(self):
        raw = body((b"a", b"b"), ((b"key",), b"0123456789"))
        for i in range(len(raw)):
            with self.subTest(length=i):
                self.assert_rejected(raw[:i], BODY)

    def test_zero_negative_and_overlarge_counts(self):
        for count in (0, -1, -32768, 10, 32767):
            raw = bytearray(body())
            struct.pack_into("<h", raw, 0, count)
            self.assert_rejected(bytes(raw), COUNT)

    def test_unsupported_negative_selector(self):
        raw = bytearray(body())
        struct.pack_into("<h", raw, 48, -2)
        self.assert_rejected(bytes(raw), SELECTOR)

    def test_tail_remainders(self):
        for remainder in range(1, 16):
            self.assert_rejected(body() + bytes(remainder), TAIL)

    def test_names_and_keys_need_bounded_terminator(self):
        raw = bytearray(body())
        raw[2:35] = b"Q" * 33
        self.assert_rejected(bytes(raw), NAME)
        raw = bytearray(body(entries=((b"key",),)))
        raw[50:83] = b"Q" * 33
        self.assert_rejected(bytes(raw), NAME)

    def test_signed_entry_sum_overflow(self):
        raw = body((b"a", b"b"), (b"x" * 16382, b"y" * 16382))
        self.assert_rejected(raw, BOUNDS)
        raw = body(entries=(b"x" * 32766,))
        self.assert_rejected(raw, BOUNDS)

    def test_null_and_address_overflow(self):
        out = Decoded()
        self.assertEqual(self.lib.action_family_97_decode(None, 0, c.byref(out)), ARGUMENT)
        src = buffer(body())
        self.assertEqual(self.lib.action_family_97_decode(src, len(src), None), ARGUMENT)
        c.memset(c.byref(out), 0xA5, c.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_97_decode(src, c.c_size_t(-1).value, c.byref(out)), BOUNDS)
        self.assertEqual(bytes(out), before)

    def test_overlapping_outputs(self):
        raw = body()
        backing = buffer(raw + bytes(c.sizeof(Decoded) + 64))
        before = bytes(backing)
        out = c.cast(backing, c.POINTER(Decoded))
        self.assertEqual(self.lib.action_family_97_decode(backing, len(raw), out), OVERLAP)
        self.assertEqual(bytes(backing), before)
        state = Constructed()
        self.assertEqual(self.lib.action_family_97_construct(backing, len(raw), 1, 50,
            LOOKUP(), None, backing, len(backing), c.byref(state)), OVERLAP)
        self.assertEqual(bytes(backing), before)
        payload = c.cast(c.byref(state), c.POINTER(c.c_uint8))
        self.assertEqual(self.lib.action_family_97_construct(backing, len(raw), 1, 50,
            LOOKUP(), None, payload, c.sizeof(state), c.byref(state)), OVERLAP)

    def test_constructor_random_and_defaults(self):
        raw = body((b"a", b"b", b"c"), (b"", b"", b""))
        status, out, image, _ = self.construct(raw, offset=0xFFFFFFF0)
        self.assertEqual(status, OK)
        seed = (1 * 214013 + 2531011) & 0xFFFFFFFF
        self.assertEqual(out.selected_index, ((seed >> 16) & 32767) % 3)
        self.assertEqual((out.random_state_after, out.random_advanced), (seed, 1))
        self.assertEqual(out.payload_offset_after, (0xFFFFFFF0 + len(raw)) & 0xFFFFFFFF)
        self.assertEqual(len(image), 172)
        self.assertEqual(struct.unpack_from("<H", image, 33)[0], 0xFEDC)
        self.assertEqual(struct.unpack_from("<I", image, 39)[0], 0x89ABCDEF)
        self.assertEqual([struct.unpack_from("<I", image, i)[0] for i in (47, 51, 91, 95)], [500, 2000, 1000, 10])
        self.assertEqual(image[165:170], b"\xff\xff\x01\x02\0")

    def test_last_star_wins_and_preserves_post_nul_padding(self):
        raw = bytearray(body((b"*first", b"*last"), (b"", b"")))
        raw[10:35] = bytes([0xA7]) * 25
        status, out, image, source = self.construct(bytes(raw))
        self.assertEqual(status, OK)
        self.assertEqual((out.selected_index, out.random_advanced, out.random_state_after), (1, 0, 1))
        self.assertEqual(bytes(out.names_after[0])[:10], b"first\0\0\0" + bytes([0xA7]) * 2)
        self.assertEqual(image[:5], b"last\0")
        self.assertEqual(bytes(source), bytes(raw))

    def test_inline_and_auto_text_whole_image(self):
        status, out, image, _ = self.construct(body(entries=(b"abc",)))
        self.assertEqual(status, OK)
        self.assertEqual((out.selector, out.allocation_bytes), (3, 178))
        self.assertEqual(image[170:], b"\x06\0abc<e>")
        lookup = DictionaryLookup({b"KEY": b"hello"})
        status, out, image, _ = self.construct(body(entries=((b"key",),)), lookup=lookup)
        self.assertEqual(status, OK)
        self.assertEqual(lookup.calls, [b"key"])
        self.assertEqual(image[170:], b"\x08\0hello<e>\0")

    def test_auto_text_missing_and_embedded_nul(self):
        lookup = DictionaryLookup()
        status, out, image, _ = self.construct(body(entries=((b"missing",),)), lookup=lookup)
        self.assertEqual(status, OK)
        self.assertEqual(image[172:-1], b"Game Error (please contact Tech Support) missing auto text: missing<n><e>")
        lookup = DictionaryLookup({b"key": b"a\0ignored"})
        status, out, image, _ = self.construct(body(entries=((b"key",),)), lookup=lookup)
        self.assertEqual(status, OK)
        self.assertEqual(image[172:], b"a<e>\0")

    def test_constructor_errors_are_transactional(self):
        for raw, lookup, capacity, expected in [
            (body(), None, 171, CAPACITY),
            (body(entries=(b"x" * 32593,)), None, 32767, BOUNDS),
            (body(entries=((b"key",),)), None, 32767, LOOKUP_ERROR),
            (body(entries=((b"key",),)), DictionaryLookup(status=2), 32767, LOOKUP_ERROR),
            (body(entries=((b"key",),)), DictionaryLookup({b"key": b"x" * 32592}), 32767, BOUNDS),
        ]:
            src, state, payload = buffer(raw), Constructed(), buffer(bytes([0xCD]) * 32767)
            c.memset(c.byref(state), 0xA6, c.sizeof(state))
            before = bytes(state)
            self.assertEqual(self.lib.action_family_97_construct(src, len(raw), 1, 50,
                lookup.callback if lookup else LOOKUP(), None, payload, capacity, c.byref(state)), expected)
            self.assertEqual(bytes(state), before)
            self.assertEqual(bytes(payload), bytes([0xCD]) * 32767)

    def test_size_query_and_maximum_safe_allocation(self):
        raw = body(entries=(b"x" * 32592,))
        src, out = buffer(raw), Constructed()
        self.assertEqual(self.lib.action_family_97_construct(src, len(raw), 1, 50,
            LOOKUP(), None, None, 0, c.byref(out)), OK)
        self.assertEqual(out.allocation_bytes, 32767)
        status, out, image, _ = self.construct(raw)
        self.assertEqual(status, OK)
        self.assertEqual(len(image), 32767)

    def test_boundary_query_errors_and_overlap(self):
        raw = body()
        source = buffer(raw)
        length = c.c_size_t(0xABCDEF)
        self.assertEqual(self.lib.action_family_97_body_length(source, len(raw) - 1, c.byref(length)), BODY)
        self.assertEqual(length.value, 0xABCDEF)
        self.assertEqual(self.lib.action_family_97_body_length(source, len(raw), None), ARGUMENT)
        self.assertEqual(self.lib.action_family_97_body_length(None, 0, c.byref(length)), ARGUMENT)
        target = c.cast(c.byref(source, 8), c.POINTER(c.c_size_t))
        self.assertEqual(self.lib.action_family_97_body_length(source, len(raw), target), OVERLAP)
        self.assertEqual(bytes(source), raw)

    def test_constructor_null_and_partial_overlap(self):
        raw = body()
        backing = buffer(raw + bytes(c.sizeof(Constructed) + 64))
        state = Constructed()
        for source, length, payload, capacity, out in (
            (None, 0, None, 0, c.byref(state)),
            (backing, len(raw), None, 1, c.byref(state)),
            (backing, len(raw), None, 0, None),
        ):
            self.assertEqual(self.lib.action_family_97_construct(source, length, 1, 50,
                LOOKUP(), None, payload, capacity, out), ARGUMENT)
        target = c.cast(c.byref(backing, len(raw) - 1), c.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_97_construct(backing, len(raw), 1, 50,
            LOOKUP(), None, None, 0, target), OVERLAP)
        self.assertEqual(self.lib.action_family_97_construct(backing, c.c_size_t(-1).value, 1, 50,
            LOOKUP(), None, None, 0, c.byref(state)), BOUNDS)
        self.assertEqual(bytes(backing)[:len(raw)], raw)

    def test_lookup_span_validation_and_output_overlap(self):
        raw = body(entries=((b"key",),))
        source, state = buffer(raw), Constructed()
        payload = buffer(bytes([0xCD]) * 512)
        c.memset(c.byref(state), 0xB6, c.sizeof(state))
        before = bytes(state)
        def call(pointer, length, expected):
            def callback(_ctx, _key, _key_len, text, text_length):
                text[0] = c.cast(pointer, c.POINTER(c.c_uint8))
                text_length[0] = length
                return 0
            lookup = LOOKUP(callback)
            self.assertEqual(self.lib.action_family_97_construct(source, len(raw), 1, 50,
                lookup, None, payload, len(payload), c.byref(state)), expected)
            self.assertEqual(bytes(state), before)
            self.assertEqual(bytes(payload), bytes([0xCD]) * 512)
        call(payload, 5, OVERLAP)
        call(c.byref(state), 5, OVERLAP)
        call(payload, c.c_size_t(-1).value, BOUNDS)
        call(None, 1, LOOKUP_ERROR)

    def test_maximum_safe_auto_text_allocation(self):
        lookup = DictionaryLookup({b"key": b"x" * 32591})
        status, out, image, _ = self.construct(body(entries=((b"key",),)), lookup=lookup)
        self.assertEqual(status, OK)
        self.assertEqual(out.allocation_bytes, 32767)
        self.assertEqual(image[-4:], b"<e>\0")


if __name__ == "__main__":
    unittest.main()
