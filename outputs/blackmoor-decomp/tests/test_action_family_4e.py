"""Fixtures for the isolated raw-0x4e decoder/constructor; no live runtime."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
BODY_BYTES = OBJECT_BYTES = 31
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Entry(C.Structure):
    _fields_ = [('option_00', C.c_uint8), ('word_0', C.c_uint16)]


class Decoded(C.Structure):
    _fields_ = [('option_00', C.c_uint8), ('entries', Entry * 10),
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


def body_fixture(option=0x21, word=0x1234, tail=0):
    return bytes([option]) + b''.join(bytes([(option + i * 19) & 255]) +
        struct.pack('<H', (word + i * 257) & 65535) for i in range(10)) + \
        bytes((i * 19 + 7) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_4e_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_4e_decode.restype = C.c_int
    lib.action_family_4e_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_4e_body_length.restype = C.c_int
    lib.action_family_4e_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_4e_construct.restype = C.c_int
    return lib


class ActionFamily4ETests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-4E.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily4e.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_4e.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def call(self, raw, length, out):
        if isinstance(out, Decoded):
            return self.lib.action_family_4e_decode(raw, length, C.byref(out))
        if isinstance(out, Constructed):
            return self.lib.action_family_4e_construct(raw, length, 50, 0x4e0001, C.byref(out))
        return self.lib.action_family_4e_body_length(raw, length, C.byref(out))

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out in (Decoded(), Constructed(), C.c_size_t()):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.call(raw, len(data), out), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_body_and_body_length(self):
        raw = storage(bytes(31))
        d, size = Decoded(), C.c_size_t()
        self.assertEqual(self.call(raw, 31, d), OK)
        self.assertEqual(self.call(raw, 31, size), OK)
        self.assertEqual((d.option_00, d.body_bytes, d.available_body_bytes, size.value), (0, 31, 31, 31))
        self.assertEqual((d.dependency_count, d.dependency_bytes), (0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 31)

    def test_fixed_ten_entries_no_count_limits(self):
        # Signed-looking words and all byte endpoints are data, never counts.
        for option in (0, 1, 99, 100, 127, 128, 255):
            for word in (0, 1, 0x7fff, 0x8000, 0xffff):
                data = bytes([option]) + (bytes([option]) + struct.pack('<H', word)) * 10
                raw, d = storage(data), Decoded()
                self.assertEqual(self.call(raw, 31, d), OK)
                self.assertEqual(d.option_00, option)
                self.assertEqual([(e.option_00, e.word_0) for e in d.entries], [(option, word)] * 10)
                self.assertEqual(d.body_bytes, 31)

    def test_each_field_offset_and_little_endian(self):
        data = bytes(range(31))
        raw, d = storage(data), Decoded()
        self.assertEqual(self.call(raw, 31, d), OK)
        for i, e in enumerate(d.entries):
            self.assertEqual((e.option_00, e.word_0),
                             (data[1+3*i], struct.unpack_from('<H', data, 2+3*i)[0]))

    def test_dependency_view_and_extents(self):
        for count in (0, 1, 9, 256, 65536):
            data = body_fixture(tail=count)
            raw, d, size = storage(data), Decoded(), C.c_size_t()
            self.assertEqual(self.call(raw, len(data), d), OK)
            self.assertEqual(self.call(raw, len(data), size), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.available_body_bytes, size.value),
                             (count, count * 16, len(data), 31))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 31)
            if count:
                raw[31] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[31])

    def test_all_short_bodies_are_atomic(self):
        for n in range(31):
            self.assert_rejected(bytes(n), BODY)

    def test_all_partial_tail_residues_are_atomic(self):
        for n in range(1, 41):
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_constructor_complete_allocation(self):
        data = body_fixture(0xfe, 0x8001, 1)
        raw, out = storage(data), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.call(raw, len(data), out), OK)
        self.assertEqual(bytes(out.object_bytes), data[:31])
        self.assertEqual((out.body_bytes_consumed, out.payload_offset_before,
            out.payload_offset_after, out.output_handle, out.result_slot_handle,
            out.output_allocation_bytes), (31, 50, 81, 0x4e0001, 0x4e0001, 31))
        self.assertEqual((out.dependency_count, out.dependency_bytes, out.available_body_bytes), (1, 16, 47))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 31)

    def test_unsigned_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xffffffe0, 0xffffffe1, 0xfffffffe, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_4e_construct(raw, 31, offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + 31) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_4e_construct(raw, 31, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers_are_atomic(self):
        raw = storage(body_fixture())
        for out in (Decoded(), Constructed(), C.c_size_t()):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.call(None, 31, out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        self.assertEqual(self.lib.action_family_4e_decode(raw, 31, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_4e_body_length(raw, 31, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_4e_construct(raw, 31, 0, 1, None), ARGUMENT)

    def test_input_output_overlap_is_atomic(self):
        for cls, call in ((Decoded, self.lib.action_family_4e_decode),
                          (Constructed, self.lib.action_family_4e_construct),
                          (C.c_size_t, self.lib.action_family_4e_body_length)):
            for input_delta, output_delta in ((0,0), (1,0), (0,1), (C.sizeof(cls)-1,0), (0,30)):
                block = (C.c_uint8 * (C.sizeof(cls) + 64))()
                C.memset(block, 0xa5, C.sizeof(block))
                raw = C.cast(C.addressof(block) + input_delta, C.POINTER(C.c_uint8))
                out = C.cast(C.addressof(block) + output_delta, C.POINTER(cls))
                before = bytes(block)
                args = (raw, 31, out) if cls is not Constructed else (raw, 31, 0, 1, out)
                self.assertEqual(call(*args), OVERLAP)
                self.assertEqual(bytes(block), before)

    def test_adjacent_spans_are_allowed(self):
        for cls in (Decoded, Constructed, C.c_size_t):
            block = (C.c_uint8 * (C.sizeof(cls) + 31))()
            raw = C.cast(C.addressof(block) + C.sizeof(cls), C.POINTER(C.c_uint8))
            out = cls.from_buffer(block)
            self.assertEqual(self.call(raw, 31, out), OK)

    def test_wrapped_spans_reject_without_access(self):
        max_address = C.c_void_p(-1).value
        raw = storage(body_fixture())
        bad_raw = C.cast(max_address, C.POINTER(C.c_uint8))
        for cls in (Decoded, Constructed, C.c_size_t):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            for p, n in ((bad_raw, 31), (raw, C.c_size_t(-1).value)):
                self.assertEqual(self.call(p, n, out), BOUNDS)
                self.assertEqual(bytes(out), before)
            bad_out = C.cast(max_address, C.POINTER(cls))
            call = self.lib.action_family_4e_decode if cls is Decoded else (
                self.lib.action_family_4e_construct if cls is Constructed else self.lib.action_family_4e_body_length)
            args = (raw, 31, bad_out) if cls is not Constructed else (raw, 31, 0, 1, bad_out)
            self.assertEqual(call(*args), BOUNDS)


if __name__ == '__main__':
    unittest.main()
