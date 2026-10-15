"""Synthetic fixtures for A-33.1; no resource data or gameplay claims."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP, COUNT, CAPACITY = range(8)


class Decoded(C.Structure):
    _fields_ = [('raw_type', C.c_uint8), ('runtime_type', C.c_uint8),
                ('count_6d', C.c_uint16), ('count_6f', C.c_uint16),
                ('typed_body', C.POINTER(C.c_uint8)), ('body_bytes', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.POINTER(C.c_uint8)),
                ('body_bytes_consumed', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('output_handle', C.c_uint32), ('result_slot_handle', C.c_uint32),
                ('output_allocation_bytes', C.c_uint32)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(a=0, b=0, tail=0):
    n = 113 + 6 * a + 66 * b
    raw = bytearray((i * 29 + 7) & 255 for i in range(n + 16 * tail))
    struct.pack_into('<HH', raw, 109, a, b)
    return bytes(raw)


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_33_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_33_decode.restype = C.c_int
    lib.action_family_33_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_33_body_length.restype = C.c_int
    lib.action_family_33_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Constructed)]
    lib.action_family_33_construct.restype = C.c_int
    return lib


class ActionFamily33Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-33.1.tests-', dir='/private/tmp')
        path = Path(cls.directory.name) / 'libactionfamily33.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_33.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def assert_rejected(self, body, status):
        raw, arena = storage(body), storage(bytes([0xcd]) * 32768)
        d, out, n = Decoded(), Constructed(), C.c_size_t(0x5a5a)
        C.memset(C.byref(d), 0xa5, C.sizeof(d))
        C.memset(C.byref(out), 0x96, C.sizeof(out))
        before = bytes(d), bytes(out), bytes(arena)
        self.assertEqual(self.lib.action_family_33_decode(raw, len(body), C.byref(d)), status)
        self.assertEqual(self.lib.action_family_33_body_length(raw, len(body), C.byref(n)), status)
        self.assertEqual(self.lib.action_family_33_construct(raw, len(body), 50, 0x33001,
            arena, len(arena), C.byref(out)), status)
        self.assertEqual((bytes(d), bytes(out), bytes(arena)), before)
        self.assertEqual(n.value, 0x5a5a)
        self.assertEqual(bytes(raw)[:len(body)], body)

    def test_minimum_and_observed_count_pairs(self):
        for a, b in ((0, 0), (0, 1), (0, 5), (4, 1), (1, 0), (2, 3)):
            for tails in (0, 1, 9, 1000):
                with self.subTest(a=a, b=b, tails=tails):
                    body = body_fixture(a, b, tails)
                    raw, d, n = storage(body), Decoded(), C.c_size_t()
                    typed = 113 + 6*a + 66*b
                    self.assertEqual(self.lib.action_family_33_decode(raw, len(body), C.byref(d)), OK)
                    self.assertEqual(self.lib.action_family_33_body_length(raw, len(body), C.byref(n)), OK)
                    self.assertEqual((d.raw_type, d.runtime_type, d.count_6d, d.count_6f), (0x33, 0x33, a, b))
                    self.assertEqual((d.body_bytes, n.value, pointer(d.typed_body)), (typed, typed, C.addressof(raw)))
                    self.assertEqual((d.dependency_count, d.dependency_bytes, d.available_body_bytes),
                                     (tails, tails*16, len(body)))
                    self.assertEqual(pointer(d.dependency_records), C.addressof(raw)+typed)

    def test_maximum_non_narrowing_counts(self):
        for a, b in ((5442, 0), (0, 494), (8, 494), (5431, 1)):
            raw, d = storage(body_fixture(a, b)), Decoded()
            self.assertEqual(self.lib.action_family_33_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual(d.body_bytes, 113 + 6*a + 66*b)

    def test_wide_tail_counts_and_modulus(self):
        # Counts are full size_t values (no 8/16-bit truncation) and the 16-byte
        # modulus applies above 4096 bytes as well as below it.
        for tails in (255, 256, 257, 4095, 4096, 4097, 65535, 65536, 65537):
            body = body_fixture(1, 1, tails)
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_33_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes), (tails, 16*tails))
        for extra in (1, 8, 15):
            for tails in (0, 255, 256, 255*16 + 1, 4097):
                self.assert_rejected(body_fixture(1, 1, tails) + bytes(extra), TAIL)

    def test_all_short_prefixes(self):
        body = body_fixture()
        for n in range(113):
            self.assert_rejected(body[:n], BODY)

    def test_short_variable_bodies(self):
        body = body_fixture(4, 1)
        for n in range(113, 203):
            self.assert_rejected(body[:n], BODY)

    def test_fractional_tails(self):
        for n in range(1, 16):
            self.assert_rejected(body_fixture(1, 1) + bytes(n), TAIL)

    def test_negative_and_narrowed_counts(self):
        # Even positive wrapped original lengths are deliberately rejected.
        for a, b in ((0x8000, 0), (0xffff, 0), (0, 0x8000), (0, 0xffff),
                     (5443, 0), (0, 495), (5442, 1), (10923, 0), (32767, 32767),
                     (0xffff, 2), (0xfffa, 10)):
            body = bytearray(body_fixture())
            struct.pack_into('<HH', body, 109, a, b)
            self.assert_rejected(bytes(body), COUNT)

    def test_whole_constructor_copy_and_offset_wrap(self):
        for a, b in ((0, 0), (4, 1), (0, 5), (8, 494)):
            body = body_fixture(a, b, 2)
            raw, n = storage(body), 113+6*a+66*b
            for offset in (0, 50, 0xfffffff0, 0xffffffff):
                arena, out = storage(bytes([0xcd]) * (n+16)), Constructed()
                self.assertEqual(self.lib.action_family_33_construct(raw, len(body), offset,
                    0x33001, arena, n+16, C.byref(out)), OK)
                self.assertEqual(bytes(arena), body[:n]+bytes([0xcd])*16)
                self.assertEqual((pointer(out.object_bytes), out.body_bytes_consumed,
                    out.output_allocation_bytes), (C.addressof(arena), n, n))
                self.assertEqual((out.output_handle, out.result_slot_handle), (0x33001, 0x33001))
                self.assertEqual((out.payload_offset_before, out.payload_offset_after),
                                 (offset, (offset+n) & 0xffffffff))
                self.assertEqual((pointer(out.dependency_records), out.dependency_count,
                    out.dependency_bytes, out.available_body_bytes), (C.addressof(raw)+n, 2, 32, len(body)))

    def test_small_object_capacity_is_transactional(self):
        raw, arena, out = storage(body_fixture(4, 1)), storage(bytes([0xcd])*203), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out), bytes(arena)
        for n in (0, 112, 202):
            self.assertEqual(self.lib.action_family_33_construct(raw, len(raw), 50, 1,
                arena, n, C.byref(out)), CAPACITY)
            self.assertEqual((bytes(out), bytes(arena)), before)

    def test_null_and_zero_handle(self):
        raw, d, n, out, arena = storage(body_fixture()), Decoded(), C.c_size_t(), Constructed(), storage(bytes(113))
        self.assertEqual(self.lib.action_family_33_decode(None, 113, C.byref(d)), ARGUMENT)
        self.assertEqual(self.lib.action_family_33_decode(raw, 113, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_33_body_length(raw, 113, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_33_body_length(None, 113, C.byref(n)), ARGUMENT)
        for handle, dest, result in ((0, arena, C.byref(out)), (1, None, C.byref(out)), (1, arena, None)):
            self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, handle,
                dest, 113, result), ARGUMENT)

    def test_overlap_and_adjacency(self):
        raw = storage(body_fixture()+bytes(128))
        d = C.cast(raw, C.POINTER(Decoded))
        self.assertEqual(self.lib.action_family_33_decode(raw, 113, d), OVERLAP)
        n = C.cast(raw, C.POINTER(C.c_size_t))
        self.assertEqual(self.lib.action_family_33_body_length(raw, 113, n), OVERLAP)
        out, arena = Constructed(), storage(bytes(113))
        self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, 1, raw, 113, C.byref(out)), OVERLAP)
        self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, 1, arena, 113,
            C.cast(arena, C.POINTER(Constructed))), OVERLAP)
        adjacent = C.cast(C.byref(raw, 113), C.POINTER(C.c_uint8))
        self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, 1, adjacent, 113, C.byref(out)), OK)

    def test_wrapped_spans_before_reads(self):
        raw, d, arena, out = storage(body_fixture()), Decoded(), storage(bytes(113)), Constructed()
        bad = C.cast(C.c_void_p(C.c_size_t(-1).value-3), C.POINTER(C.c_uint8))
        self.assertEqual(self.lib.action_family_33_decode(bad, 113, C.byref(d)), BOUNDS)
        self.assertEqual(self.lib.action_family_33_decode(raw, C.c_size_t(-1).value, C.byref(d)), BOUNDS)
        self.assertEqual(self.lib.action_family_33_decode(raw, 113, C.cast(bad, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, 1, bad, 113, C.byref(out)), BOUNDS)
        self.assertEqual(self.lib.action_family_33_construct(raw, 113, 50, 1, arena, 113,
            C.cast(bad, C.POINTER(Constructed))), BOUNDS)


if __name__ == '__main__':
    unittest.main()
