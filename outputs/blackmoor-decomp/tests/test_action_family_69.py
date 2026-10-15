"""Fixtures for raw0x69's one-byte body and allocation; no runtime effects."""
import ctypes as C
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OBJECT_BYTES = 1
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('option_00', C.c_uint8),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * OBJECT_BYTES),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('output_handle', C.c_uint32), ('result_slot_handle', C.c_uint32),
                ('output_allocation_bytes', C.c_uint32)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(option=0x7e, tail=0):
    return bytes([option]) + bytes((i * 19 + 7) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_69_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_69_decode.restype = C.c_int
    lib.action_family_69_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_69_body_length.restype = C.c_int
    lib.action_family_69_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_69_construct.restype = C.c_int
    return lib


class ActionFamily69Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-69.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily69.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_69.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def invoke(self, cls, raw, length, out):
        if cls is Decoded:
            return self.lib.action_family_69_decode(raw, length, out)
        if cls is C.c_size_t:
            return self.lib.action_family_69_body_length(raw, length, out)
        return self.lib.action_family_69_construct(raw, length, 50, 0x690001, out)

    def assert_rejected(self, data, status):
        raw = storage(data)
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(cls, raw, len(data), C.byref(out)), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_body(self):
        raw = storage(body_fixture(0))
        d = Decoded()
        self.assertEqual(self.invoke(Decoded, raw, 1, C.byref(d)), OK)
        self.assertEqual((d.option_00, d.body_bytes, d.available_body_bytes), (0, 1, 1))
        self.assertEqual((d.dependency_count, d.dependency_bytes), (0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 1)

    def test_all_byte_patterns_are_data_not_counts(self):
        # No count, negative-count or count-overflow encodings exist in this body.
        for option in range(256):
            raw = storage(body_fixture(option, 2))
            d = Decoded()
            self.assertEqual(self.invoke(Decoded, raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.option_00, d.body_bytes), (option, 1))

    def test_body_length(self):
        for count in (0, 1, 9, 1000, 65537):
            raw = storage(body_fixture(tail=count))
            length = C.c_size_t(0xa5)
            self.assertEqual(self.invoke(C.c_size_t, raw, len(raw), C.byref(length)), OK)
            self.assertEqual(length.value, 1)

    def test_dependency_view_and_extents(self):
        for count in (0, 1, 9, 1000, 65537):
            raw = storage(body_fixture(tail=count))
            d = Decoded()
            self.assertEqual(self.invoke(Decoded, raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.available_body_bytes),
                             (count, count * 16, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 1)
            if count:
                raw[1] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[1])

    def test_short_body_is_atomic(self):
        self.assert_rejected(b'', BODY)

    def test_misaligned_tail_is_atomic(self):
        for n in range(1, 41):
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_constructor_complete_allocation(self):
        raw = storage(body_fixture(0xb1, 1))
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), b'\xb1')
        self.assertEqual((out.body_bytes_consumed, out.payload_offset_before,
            out.payload_offset_after, out.output_handle, out.result_slot_handle,
            out.output_allocation_bytes), (1, 50, 51, 0x690001, 0x690001, 1))
        self.assertEqual((out.dependency_count, out.dependency_bytes, out.available_body_bytes),
                         (1, 16, 17))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 1)

    def test_unsigned_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xfffffffe, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_69_construct(raw, 1, offset, 1,
                                                               C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + 1) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw = storage(body_fixture())
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_69_construct(raw, 1, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers_are_atomic(self):
        raw = storage(body_fixture())
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(cls, None, 1, C.byref(out)), ARGUMENT)
            self.assertEqual(bytes(out), before)
            self.assertEqual(self.invoke(cls, raw, 1, None), ARGUMENT)

    def test_overlap_both_directions_is_atomic(self):
        for cls in (Decoded, Constructed, C.c_size_t):
            for out_delta, in_delta in ((0, 0), (0, 1), (0, C.sizeof(cls) - 1), (8, 0)):
                block = (C.c_uint8 * (C.sizeof(cls) + 64))()
                C.memset(block, 0xa5, C.sizeof(block))
                raw = C.cast(C.addressof(block) + in_delta, C.POINTER(C.c_uint8))
                out = C.cast(C.addressof(block) + out_delta, C.POINTER(cls))
                length = 17 if out_delta else 1
                before = bytes(block)
                self.assertEqual(self.invoke(cls, raw, length, out), OVERLAP)
                self.assertEqual(bytes(block), before)

    def test_adjacent_spans_are_allowed(self):
        for cls in (Decoded, Constructed, C.c_size_t):
            for input_first in (False, True):
                block = (C.c_uint8 * (C.sizeof(cls) + 8))()
                in_delta, out_delta = (7, 8) if input_first else (C.sizeof(cls), 0)
                raw = C.cast(C.addressof(block) + in_delta, C.POINTER(C.c_uint8))
                raw[0] = 0xfe
                out = C.cast(C.addressof(block) + out_delta, C.POINTER(cls))
                self.assertEqual(self.invoke(cls, raw, 1, out), OK)

    def test_wrapped_spans_reject_without_access(self):
        max_address = C.c_void_p(-1).value
        raw = storage(body_fixture())
        bad_raw = C.cast(max_address, C.POINTER(C.c_uint8))
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            for p, n in ((bad_raw, 1), (raw, C.c_size_t(-1).value)):
                self.assertEqual(self.invoke(cls, p, n, C.byref(out)), BOUNDS)
                self.assertEqual(bytes(out), before)
            self.assertEqual(self.invoke(cls, raw, 1, C.cast(max_address, C.POINTER(cls))), BOUNDS)


if __name__ == '__main__':
    unittest.main()
