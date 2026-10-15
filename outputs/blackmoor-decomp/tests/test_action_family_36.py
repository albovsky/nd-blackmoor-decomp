"""Fixtures for A-36.1's isolated body/constructor, not gameplay."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
PREFIX, OBJECT_BYTES = 172, 0xaba
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP, COUNT, ALLOCATION = range(8)


class Decoded(C.Structure):
    _fields_ = [('prefix_bytes', C.c_uint8 * PREFIX), ('option_29', C.c_uint16),
        ('word_2b', C.c_int16), ('word_33', C.c_int16), ('word_35', C.c_int16),
        ('word_aa', C.c_int16), ('primary_records', C.POINTER(C.c_uint8)),
        ('primary_count', C.c_size_t), ('secondary_records', C.POINTER(C.c_uint8)),
        ('secondary_count', C.c_size_t), ('dependency_records', C.POINTER(C.c_uint8)),
        ('dependency_count', C.c_size_t), ('available_body_bytes', C.c_size_t),
        ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t)]


class OwnerLinks(C.Structure):
    _fields_ = [(name, C.c_uint32) for name in ('output_handle', 'result_slot_handle',
        'owner_slot_1c_handle', 'owner_slot_20_handle', 'output_allocation_bytes')]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * OBJECT_BYTES),
        ('dependency_records', C.POINTER(C.c_uint8)), ('dependency_count', C.c_size_t),
        ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
        ('body_bytes_consumed', C.c_size_t), ('payload_offset_before', C.c_uint32),
        ('payload_offset_after', C.c_uint32), ('owner_links', OwnerLinks)]


def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def pointer(value):
    return C.cast(value, C.c_void_p).value


def narrow(value):
    return (value + 32768) % 65536 - 32768


def body_fixture(primary=3, secondary=2, mode=1, start=5, end=None, tail=0):
    prefix = bytearray((i * 17 + 3) & 255 for i in range(PREFIX))
    end = narrow(start + primary - 1) if end is None else end
    struct.pack_into('<Hh', prefix, 0x29, mode, primary)
    struct.pack_into('<hh', prefix, 0x33, start, end)
    struct.pack_into('<h', prefix, 0xaa, secondary)
    count = narrow(end - start + 1) if mode == 2 else primary
    return bytes(prefix) + bytes((i * 31 + 7) & 255 for i in range(max(count, 0) * 16)) + \
        bytes((i * 23 + 11) & 255 for i in range(max(secondary, 0) * 38)) + bytes(tail * 16)


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_36_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_36_decode.restype = C.c_int
    lib.action_family_36_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_36_body_length.restype = C.c_int
    lib.action_family_36_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.POINTER(C.c_uint8), C.c_size_t, C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_36_construct.restype = C.c_int
    return lib


class ActionFamily36Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-36.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily36.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_36.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)
        cls.seed = storage(bytes((i * 29 + 19) & 255 for i in range(OBJECT_BYTES)))

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, n, out):
        if isinstance(out, Decoded):
            return self.lib.action_family_36_decode(raw, n, C.byref(out))
        if isinstance(out, C.c_size_t):
            return self.lib.action_family_36_body_length(raw, n, C.byref(out))
        return self.lib.action_family_36_construct(raw, n, self.seed, OBJECT_BYTES, 50, 0x360001, C.byref(out))

    def assert_rejected(self, data, status):
        raw = storage(data)
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.calls(raw, len(data), out), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw), data)

    def check_valid(self, data, primary, secondary, tail):
        raw, d, c, n = storage(data), Decoded(), Constructed(), C.c_size_t(999)
        typed = PREFIX + primary * 16 + secondary * 38
        for out in (d, c, n):
            self.assertEqual(self.calls(raw, len(data), out), OK)
        self.assertEqual(bytes(d.prefix_bytes), data[:PREFIX])
        self.assertEqual((d.option_29, d.word_2b, d.word_33, d.word_35, d.word_aa),
            (struct.unpack_from('<H', data, 0x29)[0], struct.unpack_from('<h', data, 0x2b)[0],
             *struct.unpack_from('<hh', data, 0x33), secondary))
        self.assertEqual((pointer(d.primary_records), d.primary_count, pointer(d.secondary_records),
            d.secondary_count, pointer(d.dependency_records), d.dependency_count, d.body_bytes,
            d.available_body_bytes, d.dependency_bytes), (C.addressof(raw) + PREFIX, primary,
            C.addressof(raw) + PREFIX + primary * 16, secondary, C.addressof(raw) + typed,
            tail, typed, len(data), tail * 16))
        expected = bytearray(bytes(self.seed))
        expected[:PREFIX + primary * 16] = data[:PREFIX + primary * 16]
        expected[0x6ec:0x6ec + secondary * 38] = data[PREFIX + primary * 16:typed]
        self.assertEqual(bytes(c.object_bytes), bytes(expected))
        self.assertEqual((n.value, c.body_bytes_consumed, c.payload_offset_after), (typed, typed, 50 + typed))
        self.assertEqual(tuple(getattr(c.owner_links, name) for name, _ in OwnerLinks._fields_),
                         (0x360001, 0x360001, 0x360001, 0x360001, OBJECT_BYTES))
        self.assertEqual((pointer(c.dependency_records), c.dependency_count, c.dependency_bytes,
            c.available_body_bytes, c.payload_offset_before),
            (C.addressof(raw) + typed, tail, tail * 16, len(data), 50))
        self.assertEqual(bytes(raw), data)
        return raw, d

    def test_minimum_and_maximum_tables(self):
        for p, s in ((0, 0), (1, 1), (100, 25), (100, 0), (0, 25)):
            self.check_valid(body_fixture(p, s), p, s, 0)

    def test_both_primary_count_branches(self):
        for mode in (0, 1, 2, 3, 0x8000, 0xffff):
            self.check_valid(body_fixture(7, 3, mode=mode, tail=2), 7, 3, 2)

    def test_endpoint_difference_narrows_to_signed_word(self):
        for start, end, count in ((-32768, 32767, 0), (32767, -32768, 2),
                                  (-32768, -32669, 100), (0, -1, 0)):
            self.check_valid(body_fixture(99, 1, mode=2, start=start, end=end), count, 1, 0)

    def test_signed_negative_and_over_capacity_counts(self):
        for p in (-32768, -1, 101, 32767):
            self.assert_rejected(body_fixture(p, 0), COUNT)
        for s in (-32768, -1, 26, 32767):
            self.assert_rejected(body_fixture(0, s), COUNT)
        for start, end in ((0, 32767), (100, 98), (-32768, -32668)):
            self.assert_rejected(body_fixture(0, 0, mode=2, start=start, end=end), COUNT)

    def test_unused_direct_count_can_be_negative(self):
        self.check_valid(body_fixture(-1, 0, mode=2, start=0, end=0), 1, 0, 0)

    def test_prefix_is_binary_and_does_not_require_nul(self):
        data = bytearray(body_fixture(0, 0))
        data[:33] = b'X' * 33
        data[0x79:0x9a] = b'Y' * 33
        self.check_valid(bytes(data), 0, 0, 0)

    def test_every_short_prefix(self):
        for n in range(PREFIX):
            self.assert_rejected(body_fixture(0, 0)[:n], BODY)

    def test_short_tables(self):
        data = body_fixture(4, 3)
        for n in range(PREFIX, len(data)):
            self.assert_rejected(data[:n], BODY)

    def test_fractional_dependency_tails(self):
        for n in range(1, 41):
            if n % 16:
                self.assert_rejected(body_fixture(1, 1) + bytes(n), TAIL)

    def test_borrowed_views(self):
        raw, d = self.check_valid(body_fixture(1, 1, tail=1), 1, 1, 1)
        for p, off in ((d.primary_records, PREFIX), (d.secondary_records, PREFIX + 16),
                       (d.dependency_records, PREFIX + 16 + 38)):
            raw[off] ^= 255
            self.assertEqual(p[0], raw[off])

    def test_constructor_unsigned_cursor_wrap(self):
        data = body_fixture(1, 1)
        raw, out = storage(data), Constructed()
        for offset in (0, 50, 0xffffffff, 0xfffffffe):
            self.assertEqual(self.lib.action_family_36_construct(raw, len(data), self.seed, OBJECT_BYTES,
                offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + len(data)) & 0xffffffff)

    def test_allocation_and_zero_handle_rejections(self):
        raw, out = storage(body_fixture(0, 0)), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        for length in (0, OBJECT_BYTES - 1, OBJECT_BYTES + 1, C.c_size_t(-1).value):
            self.assertEqual(self.lib.action_family_36_construct(raw, len(raw), self.seed, length,
                0, 1, C.byref(out)), ALLOCATION)
            self.assertEqual(bytes(out), before)
        self.assertEqual(self.lib.action_family_36_construct(raw, len(raw), self.seed, OBJECT_BYTES,
            0, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_arguments(self):
        raw = storage(body_fixture(0, 0))
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            self.assertEqual(self.calls(None, len(raw), out), ARGUMENT)
        self.assertEqual(self.lib.action_family_36_decode(raw, len(raw), None), ARGUMENT)
        self.assertEqual(self.lib.action_family_36_body_length(raw, len(raw), None), ARGUMENT)
        self.assertEqual(self.lib.action_family_36_construct(raw, len(raw), self.seed, OBJECT_BYTES,
            0, 1, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_36_construct(raw, len(raw), None, OBJECT_BYTES,
            0, 1, C.byref(Constructed())), ARGUMENT)

    def test_overlaps_and_wrapped_spans(self):
        raw = storage(body_fixture(0, 0))
        bad = C.cast(C.c_void_p(-1), C.POINTER(C.c_uint8))
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            for p, n in ((bad, PREFIX), (raw, C.c_size_t(-1).value)):
                self.assertEqual(self.calls(p, n, out), BOUNDS)
                self.assertEqual(bytes(out), before)
            block = (C.c_uint8 * (C.sizeof(out) + PREFIX))()
            for delta in (0, 1, C.sizeof(out) - 1):
                C.memset(block, 0xa5, C.sizeof(block))
                p = C.cast(C.addressof(block) + delta, C.POINTER(C.c_uint8))
                dest = C.cast(block, C.POINTER(cls))
                snapshot = bytes(block)
                if cls is Decoded:
                    status = self.lib.action_family_36_decode(p, PREFIX, dest)
                elif cls is Constructed:
                    status = self.lib.action_family_36_construct(p, PREFIX, self.seed, OBJECT_BYTES, 0, 1, dest)
                else:
                    status = self.lib.action_family_36_body_length(p, PREFIX, dest)
                self.assertEqual(status, OVERLAP)
                self.assertEqual(bytes(block), snapshot)
        c = Constructed()
        self.assertEqual(self.lib.action_family_36_construct(raw, PREFIX, bad, OBJECT_BYTES,
            0, 1, C.byref(c)), BOUNDS)
        aliased = C.cast(C.byref(c), C.POINTER(C.c_uint8))
        self.assertEqual(self.lib.action_family_36_construct(raw, PREFIX, aliased, OBJECT_BYTES,
            0, 1, C.byref(c)), OVERLAP)

    def test_inputs_may_alias_each_other(self):
        raw = storage(body_fixture(0, 0) + bytes(OBJECT_BYTES - PREFIX))
        c = Constructed()
        self.assertEqual(self.lib.action_family_36_construct(raw, PREFIX, raw, OBJECT_BYTES,
            0, 1, C.byref(c)), OK)
        self.assertEqual(bytes(c.object_bytes), bytes(raw))


if __name__ == '__main__':
    unittest.main()
