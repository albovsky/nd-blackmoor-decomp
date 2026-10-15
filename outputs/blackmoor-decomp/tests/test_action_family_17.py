"""Synthetic A-17.1 fixtures; no executable/resource bytes are embedded."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
MAX_COUNT = 1819


class Decoded(C.Structure):
    _fields_ = [('words', C.c_uint16 * 10), ('count', C.c_int16),
        ('records', C.c_void_p), ('dependency_records', C.c_void_p),
        ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
        ('available_body_bytes', C.c_size_t), ('body_bytes', C.c_size_t),
        ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


class Constructed(C.Structure):
    _fields_ = [('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
        ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
        ('body_bytes_consumed', C.c_size_t), ('allocation_bytes', C.c_size_t),
        ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
        ('result_slot_handle', C.c_uint32), ('raw_type', C.c_uint8),
        ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def body_fixture(count=3, tail=0):
    body = bytearray((i * 37 + 11) & 255 for i in range(22 + 18 * count + tail))
    struct.pack_into('<h', body, 20, count)
    return bytes(body)


def load_native(path):
    lib = C.CDLL(str(path))
    for name in ('decode', 'body_length'):
        fn = getattr(lib, 'action_family_17_' + name)
        fn.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p]
        fn.restype = C.c_int
    lib.action_family_17_construct.argtypes = [C.c_void_p, C.c_size_t,
        C.c_uint32, C.c_uint32, C.c_void_p, C.c_size_t, C.c_void_p]
    lib.action_family_17_construct.restype = C.c_int
    return lib


class ActionFamily17Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-17.1.tests-',
            dir=ROOT / 'work/analysis/slices')
        subprocess.run([str(PROJECT / 'scripts/build_action_family_17.sh')],
            env=dict(os.environ, BUILD_DIR=cls.directory.name), check=True, capture_output=True)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily17.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def reject(self, data, expected):
        raw = storage(data)
        decoded, model, length = Decoded(), Constructed(), C.c_size_t(0xabcdef)
        arena = storage(b'\xa6' * 32764)
        for out in (decoded, model):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = (bytes(decoded), bytes(model), bytes(arena), bytes(raw))
        self.assertEqual(self.lib.action_family_17_decode(raw, len(data), C.byref(decoded)), expected)
        self.assertEqual(self.lib.action_family_17_body_length(raw, len(data), C.byref(length)), expected)
        self.assertEqual(self.lib.action_family_17_construct(raw, len(data), 50, 1,
            arena, len(arena), C.byref(model)), expected)
        self.assertEqual((bytes(decoded), bytes(model), bytes(arena), bytes(raw)), before)
        self.assertEqual(length.value, 0xabcdef)

    def test_decode_fields_and_borrowed_views(self):
        data = body_fixture(3, 32); raw = storage(data); d = Decoded()
        self.assertEqual(self.lib.action_family_17_decode(raw, len(data), C.byref(d)), 0)
        self.assertEqual(tuple(d.words), struct.unpack_from('<10H', data))
        self.assertEqual(d.count, 3)
        self.assertEqual((d.raw_type, d.runtime_type), (0x17, 0x17))
        self.assertEqual(d.records, C.addressof(raw) + 22)
        self.assertEqual(d.dependency_records, C.addressof(raw) + 76)
        self.assertEqual((d.body_bytes, d.dependency_count, d.dependency_bytes,
                          d.available_body_bytes), (76, 2, 32, 108))
        raw[76] ^= 1
        self.assertEqual(C.c_uint8.from_address(d.dependency_records).value, raw[76])

    def test_minimum_and_maximum_counts(self):
        for n in (0, 1, MAX_COUNT):
            raw = storage(body_fixture(n)); d = Decoded(); length = C.c_size_t()
            self.assertEqual(self.lib.action_family_17_decode(raw, len(raw), C.byref(d)), 0)
            self.assertEqual(self.lib.action_family_17_body_length(raw, len(raw), C.byref(length)), 0)
            self.assertEqual((d.count, d.body_bytes, length.value), (n, 22 + 18*n, 22 + 18*n))

    def test_all_prefix_truncations(self):
        for n in range(22):
            self.reject(body_fixture(0)[:n], 2)

    def test_each_record_truncation(self):
        data = body_fixture(3)
        for n in range(22, len(data)):
            self.reject(data[:n], 2)

    def test_signed_and_narrowing_overflow_counts(self):
        for n in (1820, 32767, 0x8000, 0xffff, 3640, 3641, 3642):
            raw = bytearray(body_fixture(0)); struct.pack_into('<H', raw, 20, n)
            self.reject(bytes(raw), 3)

    def test_declared_maximum_count_short(self):
        raw = bytearray(body_fixture(0)); struct.pack_into('<H', raw, 20, MAX_COUNT)
        self.reject(bytes(raw), 2)

    def test_all_ragged_tails(self):
        for tail in range(1, 41):
            if tail % 16:
                self.reject(body_fixture(1, tail), 4)

    def test_constructor_complete_copy_and_cursor_wrap(self):
        for n in (0, 3, MAX_COUNT):
            raw = storage(body_fixture(n, 16)); typed = 22 + 18*n
            arena = storage(b'\xa6' * (typed + 17)); model = Constructed()
            self.assertEqual(self.lib.action_family_17_construct(raw, len(raw), 0xfffffff0,
                0x12345678, arena, len(arena), C.byref(model)), 0)
            self.assertEqual(bytes(arena), bytes(raw)[:typed] + b'\xa6'*17)
            self.assertEqual((model.body_bytes_consumed, model.allocation_bytes), (typed, typed))
            self.assertEqual((model.payload_offset_before, model.payload_offset_after),
                             (0xfffffff0, (0xfffffff0 + typed) & 0xffffffff))
            self.assertEqual((model.result_slot_handle, model.raw_type, model.runtime_type),
                             (0x12345678, 0x17, 0x17))
            self.assertEqual(model.dependency_records, C.addressof(raw) + typed)
            self.assertEqual((model.dependency_count, model.dependency_bytes,
                model.available_body_bytes), (1, 16, len(raw)))

    def test_null_arguments(self):
        raw = storage(body_fixture()); d = Decoded(); m = Constructed(); a = storage(b'\xa6'*76)
        self.assertEqual(self.lib.action_family_17_decode(None, 76, C.byref(d)), 1)
        self.assertEqual(self.lib.action_family_17_decode(raw, 76, None), 1)
        self.assertEqual(self.lib.action_family_17_body_length(raw, 76, None), 1)
        for args in ((None,76,50,1,a,76,C.byref(m)), (raw,76,50,0,a,76,C.byref(m)),
                     (raw,76,50,1,None,76,C.byref(m)), (raw,76,50,1,a,76,None)):
            before = bytes(a), bytes(m)
            self.assertEqual(self.lib.action_family_17_construct(*args), 1)
            self.assertEqual((bytes(a),bytes(m)), before)

    def test_capacity_rejection_is_atomic(self):
        raw = storage(body_fixture()); a = storage(b'\xa6'*76); m = Constructed()
        C.memset(C.byref(m), 0xa5, C.sizeof(m)); before = bytes(a), bytes(m)
        self.assertEqual(self.lib.action_family_17_construct(raw,76,50,1,a,75,C.byref(m)), 7)
        self.assertEqual((bytes(a),bytes(m)), before)

    def test_overlap_rejections_are_atomic(self):
        buf = storage(b'\xa5'*512); raw = storage(body_fixture()); m = Constructed()
        for fn, args in ((self.lib.action_family_17_decode, (buf,76,buf)),
            (self.lib.action_family_17_body_length,(buf,76,C.byref(buf,20))),
            (self.lib.action_family_17_construct,(buf,76,50,1,buf,76,C.byref(m))),
            (self.lib.action_family_17_construct,(raw,76,50,1,buf,76,buf)),
            (self.lib.action_family_17_construct,(buf,76,50,1,C.byref(buf,128),76,buf))):
            before = bytes(buf), bytes(raw), bytes(m)
            self.assertEqual(fn(*args), 6)
            self.assertEqual((bytes(buf), bytes(raw), bytes(m)), before)

    def test_integer_address_wrap_rejected_before_read(self):
        top = C.c_void_p(-8); raw = storage(body_fixture()); d = Decoded(); m = Constructed()
        self.assertEqual(self.lib.action_family_17_decode(top,76,C.byref(d)), 5)
        self.assertEqual(self.lib.action_family_17_decode(raw,76,top), 5)
        self.assertEqual(self.lib.action_family_17_body_length(top,76,C.byref(C.c_size_t())), 5)
        self.assertEqual(self.lib.action_family_17_construct(raw,76,50,1,top,76,C.byref(m)), 5)


if __name__ == '__main__':
    unittest.main()
