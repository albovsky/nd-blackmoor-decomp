"""Synthetic fixtures for raw 0x1b; no original resource bytes or strings."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, COUNT, TAIL, BOUNDS, OVERLAP = range(7)


class Decoded(C.Structure):
    _fields_ = [('raw_type', C.c_uint8), ('runtime_type', C.c_uint8),
                ('primary_count', C.c_int16), ('secondary_count', C.c_int16),
                ('fixed_words', C.c_uint16 * 5), ('fixed_dwords', C.c_uint32 * 3),
                ('primary_records', C.POINTER(C.c_uint8)), ('primary_bytes', C.c_size_t),
                ('secondary_records', C.POINTER(C.c_uint8)), ('secondary_bytes', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)), ('dependency_count', C.c_size_t),
                ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * 34),
                ('primary_records', C.POINTER(C.c_uint8)), ('primary_bytes', C.c_size_t),
                ('secondary_records', C.POINTER(C.c_uint8)), ('secondary_bytes', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)), ('dependency_count', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('owner_field_1c', C.c_uint32),
                ('owner_field_20', C.c_uint32), ('owner_field_24', C.c_uint32),
                ('output_allocation_bytes', C.c_uint32), ('primary_allocation_bytes', C.c_uint32),
                ('secondary_allocation_bytes', C.c_uint32), ('allocation_count', C.c_uint32)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(primary=1, secondary=1, tail=0):
    first = bytes((i * 13 + 17) & 255 for i in range(primary * 22))
    fixed = struct.pack('<5H3I', 0, 1, 0x7fff, 0x8000, 0xffff,
                        0x12345678, 0x80000001, 0xffffffff)
    last = bytes((i * 19 + 31) & 255 for i in range(secondary * 18))
    return struct.pack('<H', primary) + first + fixed + struct.pack('<H', secondary) + last + bytes(tail * 16)


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_1b_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_1b_decode.restype = C.c_int
    lib.action_family_1b_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_1b_body_length.restype = C.c_int
    lib.action_family_1b_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_1b_construct.restype = C.c_int
    return lib


class ActionFamily1bTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Unique scratch outside the canonical evidence tree.
        cls.directory = tempfile.TemporaryDirectory(prefix='A-1B.1.tests-', dir='/private/tmp')
        path = Path(cls.directory.name) / 'libactionfamily1b.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_1b.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length, d, c, n):
        return [(self.lib.action_family_1b_decode, (raw, length, d)),
                (self.lib.action_family_1b_construct, (raw, length, 50, 0x30005000,
                    0x31000000, 0x32000000, c)),
                (self.lib.action_family_1b_body_length, (raw, length, n))]

    def assert_rejected(self, data, status):
        raw = storage(data)
        d, c, n = Decoded(), Constructed(), C.c_size_t()
        for value in (d, c, n):
            C.memset(C.byref(value), 0xa5, C.sizeof(value))
        before = (bytes(d), bytes(c), bytes(n))
        for call, args in self.calls(raw, len(data), C.byref(d), C.byref(c), C.byref(n)):
            self.assertEqual(call(*args), status)
        self.assertEqual((bytes(d), bytes(c), bytes(n)), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_and_little_endian_fields(self):
        data = body_fixture(0, 0)
        raw, d = storage(data), Decoded()
        self.assertEqual(self.lib.action_family_1b_decode(raw, len(data), C.byref(d)), OK)
        self.assertEqual((d.raw_type, d.runtime_type, d.primary_count, d.secondary_count), (27, 27, 0, 0))
        self.assertEqual(list(d.fixed_words), [0, 1, 0x7fff, 0x8000, 0xffff])
        self.assertEqual(list(d.fixed_dwords), [0x12345678, 0x80000001, 0xffffffff])
        self.assertEqual((d.body_bytes, d.dependency_count), (26, 0))

    def test_count_domains_and_borrowed_views(self):
        for p, s, t in [(0, 0, 0), (1, 1, 2), (2, 3, 9), (255, 256, 0),
                        (32767, 0, 1), (0, 32767, 1), (32767, 32767, 0)]:
            raw = storage(body_fixture(p, s, t))
            d, n = Decoded(), C.c_size_t()
            self.assertEqual(self.lib.action_family_1b_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual(self.lib.action_family_1b_body_length(raw, len(raw), C.byref(n)), OK)
            extent = 26 + 22 * p + 18 * s
            self.assertEqual((d.primary_count, d.secondary_count, d.body_bytes, n.value), (p, s, extent, extent))
            self.assertEqual((pointer(d.primary_records), d.primary_bytes), (C.addressof(raw) + 2, p * 22))
            self.assertEqual((pointer(d.secondary_records), d.secondary_bytes),
                             (C.addressof(raw) + 26 + 22 * p, s * 18))
            self.assertEqual((pointer(d.dependency_records), d.dependency_count, d.dependency_bytes,
                              d.available_body_bytes), (C.addressof(raw) + extent, t, t * 16, len(raw)))
            if p:
                raw[2] ^= 255
                self.assertEqual(d.primary_records[0], raw[2])

    def test_every_short_prefix_is_atomic(self):
        for p, s in [(0, 0), (1, 1), (2, 3)]:
            data = body_fixture(p, s)
            for n in range(len(data)):
                self.assert_rejected(data[:n], BODY)

    def test_negative_and_unsigned_overflow_counts(self):
        for bits in (0x8000, 0xffff):
            self.assert_rejected(struct.pack('<H', bits), COUNT)
            data = bytearray(body_fixture(0, 0))
            struct.pack_into('<H', data, 24, bits)
            self.assert_rejected(bytes(data), COUNT)
        self.assert_rejected(struct.pack('<H', 32767) + bytes(24), BODY)
        data = bytearray(body_fixture(0, 0)); struct.pack_into('<H', data, 24, 32767)
        self.assert_rejected(bytes(data), BODY)

    def test_fractional_tails_are_atomic(self):
        for n in range(1, 41):
            if n % 16:
                self.assert_rejected(body_fixture(2, 3) + bytes(n), TAIL)

    def test_constructor_complete_object_and_owner_links(self):
        for p, s in [(0, 0), (1, 1), (2, 3)]:
            data = body_fixture(p, s, 2); raw = storage(data); c = Constructed()
            self.assertEqual(self.lib.action_family_1b_construct(raw, len(data), 50,
                0x30005000, 0x31000000, 0x32000000, C.byref(c)), OK)
            expected = (struct.pack('<HI', p, 0x31000000) + data[2+22*p:24+22*p] +
                        struct.pack('<HI', s, 0x32000000))
            self.assertEqual(bytes(c.object_bytes), expected)
            self.assertEqual((c.result_slot_handle, c.owner_field_1c, c.owner_field_20,
                c.owner_field_24), (0x30005000, 0x30005000, 0x31000000, 0x32000000))
            self.assertEqual((c.output_allocation_bytes, c.primary_allocation_bytes,
                c.secondary_allocation_bytes, c.allocation_count), (34, 22*p, 18*s, 3))
            extent = 26 + 22*p + 18*s
            self.assertEqual((c.body_bytes_consumed, c.payload_offset_before, c.payload_offset_after),
                             (extent, 50, 50+extent))
            self.assertEqual((pointer(c.primary_records), c.primary_bytes,
                pointer(c.secondary_records), c.secondary_bytes),
                (C.addressof(raw)+2, 22*p, C.addressof(raw)+26+22*p, 18*s))
            self.assertEqual((pointer(c.dependency_records), c.dependency_count,
                c.dependency_bytes, c.available_body_bytes), (C.addressof(raw)+extent, 2, 32, len(data)))

    def test_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xfffffffe, 0xffffffff):
            c = Constructed()
            self.assertEqual(self.lib.action_family_1b_construct(raw, len(raw), offset, 1, 2, 3, C.byref(c)), OK)
            self.assertEqual(c.payload_offset_after, (offset + 66) & 0xffffffff)

    def test_invalid_model_handles_are_atomic(self):
        raw, c = storage(body_fixture()), Constructed()
        C.memset(C.byref(c), 0xa5, C.sizeof(c)); before = bytes(c)
        for handles in [(0, 2, 3), (1, 0, 3), (1, 2, 0)]:
            self.assertEqual(self.lib.action_family_1b_construct(raw, len(raw), 50,
                *handles, C.byref(c)), ARGUMENT)
            self.assertEqual(bytes(c), before)
        for handles in [(0xffffffff, 2, 3), (1, 0xffffffff, 3), (1, 2, 0xffffffff)]:
            self.assertEqual(self.lib.action_family_1b_construct(raw, len(raw), 50,
                *handles, C.byref(c)), BOUNDS)
            self.assertEqual(bytes(c), before)

    def test_null_and_wrapped_spans(self):
        raw = storage(body_fixture()); d, c, n = Decoded(), Constructed(), C.c_size_t()
        maxaddr = C.c_void_p(-1).value
        for ptr, length, status in [(None, 66, ARGUMENT),
            (C.cast(maxaddr, C.POINTER(C.c_uint8)), 66, BOUNDS), (raw, C.c_size_t(-1).value, BOUNDS)]:
            for value in (d, c, n): C.memset(C.byref(value), 0xa5, C.sizeof(value))
            before = (bytes(d), bytes(c), bytes(n))
            for call, args in self.calls(ptr, length, C.byref(d), C.byref(c), C.byref(n)):
                self.assertEqual(call(*args), status)
            self.assertEqual((bytes(d), bytes(c), bytes(n)), before)
        for call, args in self.calls(raw, 66, None, None, None): self.assertEqual(call(*args), ARGUMENT)
        for call, args in self.calls(raw, 66, C.cast(maxaddr, C.POINTER(Decoded)),
                C.cast(maxaddr, C.POINTER(Constructed)), C.cast(maxaddr, C.POINTER(C.c_size_t))):
            self.assertEqual(call(*args), BOUNDS)

    def test_overlap_and_adjacency(self):
        for cls, method in [(Decoded, self.lib.action_family_1b_decode),
                            (Constructed, self.lib.action_family_1b_construct),
                            (C.c_size_t, self.lib.action_family_1b_body_length)]:
            for delta in (0, 1, C.sizeof(cls)-1, C.sizeof(cls)):
                block = (C.c_uint8 * (C.sizeof(cls)+66))()
                raw = C.cast(C.addressof(block)+delta, C.POINTER(C.c_uint8))
                C.memmove(raw, body_fixture(), 66)
                out = C.cast(block, C.POINTER(cls)); before = bytes(block)
                args = (raw, 66, 50, 1, 2, 3, out) if cls is Constructed else (raw, 66, out)
                self.assertEqual(method(*args), OK if delta == C.sizeof(cls) else OVERLAP)
                if delta < C.sizeof(cls): self.assertEqual(bytes(block), before)


if __name__ == '__main__':
    unittest.main()
