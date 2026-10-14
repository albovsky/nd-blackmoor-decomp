"""Fixtures for the isolated raw-0x79 body/constructor, not live gameplay."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OBJECT_BYTES = 2
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('word_0', C.c_uint16),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t),
                ('available_body_bytes', C.c_size_t),
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
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(word=0x1234, tail=0):
    return struct.pack('<H', word) + bytes((i * 19 + 7) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_79_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_79_decode.restype = C.c_int
    lib.action_family_79_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_79_construct.restype = C.c_int
    return lib


class ActionFamily79Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-79.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily79.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_79.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out, call in [(Decoded(), self.lib.action_family_79_decode),
                          (Constructed(), self.lib.action_family_79_construct)]:
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            args = (raw, len(data), C.byref(out)) if isinstance(out, Decoded) else (
                raw, len(data), 50, 0x790001, C.byref(out))
            self.assertEqual(call(*args), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw), data)

    def test_minimum_body(self):
        raw = storage(body_fixture(0))
        d = Decoded()
        self.assertEqual(self.lib.action_family_79_decode(raw, 2, C.byref(d)), OK)
        self.assertEqual((d.word_0, d.body_bytes, d.available_body_bytes), (0, 2, 2))
        self.assertEqual((d.dependency_count, d.dependency_bytes), (0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 2)

    def test_word_limits_are_data_not_counts(self):
        for word in (0, 1, 0x7fff, 0x8000, 0xffff):
            with self.subTest(word=word):
                raw = storage(body_fixture(word, 2))
                d = Decoded()
                self.assertEqual(self.lib.action_family_79_decode(raw, len(raw), C.byref(d)), OK)
                self.assertEqual(d.word_0, word)
                self.assertEqual(d.body_bytes, 2)

    def test_little_endian(self):
        raw = storage(b'\x01\x80')
        d = Decoded()
        self.assertEqual(self.lib.action_family_79_decode(raw, 2, C.byref(d)), OK)
        self.assertEqual(d.word_0, 0x8001)

    def test_dependency_view_and_extents(self):
        for count in (0, 1, 9, 1000):
            raw = storage(body_fixture(tail=count))
            d = Decoded()
            self.assertEqual(self.lib.action_family_79_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.available_body_bytes),
                             (count, count * 16, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 2)
            if count:
                raw[2] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[2])

    def test_short_bodies_are_atomic(self):
        for n in (0, 1):
            self.assert_rejected(bytes(n), BODY)

    def test_misaligned_tail_is_atomic(self):
        for n in range(1, 32):
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_constructor_complete_allocation(self):
        raw = storage(body_fixture(0xb17e, 1))
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_79_construct(raw, len(raw), 50, 0x790001,
                                                           C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), b'\x7e\xb1')
        self.assertEqual((out.body_bytes_consumed, out.payload_offset_before,
            out.payload_offset_after, out.output_handle, out.result_slot_handle,
            out.output_allocation_bytes), (2, 50, 52, 0x790001, 0x790001, 2))
        self.assertEqual((out.dependency_count, out.dependency_bytes, out.available_body_bytes),
                         (1, 16, 18))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 2)

    def test_unsigned_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 0xfffffffd, 0xfffffffe, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_79_construct(raw, 2, offset, 1,
                                                               C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + 2) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw = storage(body_fixture())
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_79_construct(raw, 2, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        raw = storage(body_fixture())
        d, out = Decoded(), Constructed()
        self.assertEqual(self.lib.action_family_79_decode(None, 2, C.byref(d)), ARGUMENT)
        self.assertEqual(self.lib.action_family_79_decode(raw, 2, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_79_construct(None, 2, 0, 1, C.byref(out)), ARGUMENT)
        self.assertEqual(self.lib.action_family_79_construct(raw, 2, 0, 1, None), ARGUMENT)

    def test_input_output_overlap_is_atomic(self):
        for cls in (Decoded, Constructed):
            for delta in (0, 1, 2, C.sizeof(cls) - 1):
                block = (C.c_uint8 * (C.sizeof(cls) + 32))()
                C.memset(block, 0xa5, C.sizeof(block))
                raw = C.cast(C.addressof(block) + delta, C.POINTER(C.c_uint8))
                out = C.cast(block, C.POINTER(cls))
                before = bytes(block)
                args = (raw, 2, out) if cls is Decoded else (raw, 2, 0, 1, out)
                call = self.lib.action_family_79_decode if cls is Decoded else self.lib.action_family_79_construct
                self.assertEqual(call(*args), OVERLAP)
                self.assertEqual(bytes(block), before)

    def test_adjacent_spans_are_allowed(self):
        for cls in (Decoded, Constructed):
            block = (C.c_uint8 * (C.sizeof(cls) + 2))()
            raw = C.cast(C.addressof(block) + C.sizeof(cls), C.POINTER(C.c_uint8))
            raw[0], raw[1] = 0x12, 0x34
            out = C.cast(block, C.POINTER(cls))
            args = (raw, 2, out) if cls is Decoded else (raw, 2, 0, 1, out)
            call = self.lib.action_family_79_decode if cls is Decoded else self.lib.action_family_79_construct
            self.assertEqual(call(*args), OK)

    def test_wrapped_spans_reject_without_access(self):
        max_address = C.c_void_p(-1).value
        raw = storage(body_fixture())
        bad_raw = C.cast(max_address, C.POINTER(C.c_uint8))
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            call = self.lib.action_family_79_decode if cls is Decoded else self.lib.action_family_79_construct
            for p, n in ((bad_raw, 2), (raw, C.c_size_t(-1).value)):
                args = (p, n, C.byref(out)) if cls is Decoded else (p, n, 0, 1, C.byref(out))
                self.assertEqual(call(*args), BOUNDS)
                self.assertEqual(bytes(out), before)
            bad_out = C.cast(max_address, C.POINTER(cls))
            args = (raw, 2, bad_out) if cls is Decoded else (raw, 2, 0, 1, bad_out)
            self.assertEqual(call(*args), BOUNDS)


if __name__ == '__main__':
    unittest.main()
