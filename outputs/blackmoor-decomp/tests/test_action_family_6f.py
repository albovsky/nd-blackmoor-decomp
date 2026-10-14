"""Synthetic A-6F.1 fixtures; no original resource bytes are embedded."""
import ctypes as C
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'


class Decoded(C.Structure):
    _fields_ = [('option_00', C.c_uint8),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * 1),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('allocation_bytes', C.c_uint32),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def pointer(p):
    return C.cast(p, C.c_void_p).value


def body_fixture(option=0xA7, tail=1):
    return bytes([option]) + bytes((i * 37 + 11) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_6f_decode.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p]
    lib.action_family_6f_decode.restype = C.c_int
    lib.action_family_6f_construct.argtypes = [C.c_void_p, C.c_size_t,
        C.c_uint32, C.c_uint32, C.c_void_p]
    lib.action_family_6f_construct.restype = C.c_int
    return lib


class ActionFamily6fTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-6F.1.tests-',
            dir=ROOT / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily6f.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_6f.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def invoke(self, kind, raw, length, out, offset=50, handle=0x6F123456):
        if kind is Decoded:
            return self.lib.action_family_6f_decode(raw, length, out)
        return self.lib.action_family_6f_construct(raw, length, offset, handle, out)

    def reject(self, data, expected):
        raw = storage(data)
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(kind, raw, len(data), C.byref(out)), expected)
            self.assertEqual(bytes(out), before)
            self.assertEqual(bytes(raw), data)

    def test_one_byte_body_and_borrowed_tail(self):
        data = body_fixture(tail=8)
        raw = storage(data)
        out = Decoded()
        self.assertEqual(self.lib.action_family_6f_decode(raw, len(data), C.byref(out)), 0)
        self.assertEqual(out.option_00, 0xA7)
        self.assertEqual((out.body_bytes, out.available_body_bytes,
                          out.dependency_count, out.dependency_bytes), (1, 129, 8, 128))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 1)
        raw[1] ^= 1
        self.assertEqual(out.dependency_records[0], raw[1])

    def test_all_option_encodings_are_unsigned_data(self):
        # No count exists in this family: 0x80 and 0xff are valid option bytes.
        for option in range(256):
            raw = storage(body_fixture(option, 0))
            d = Decoded()
            c = Constructed()
            self.assertEqual(self.invoke(Decoded, raw, 1, C.byref(d)), 0)
            self.assertEqual(self.invoke(Constructed, raw, 1, C.byref(c)), 0)
            self.assertEqual(d.option_00, option)
            self.assertEqual(bytes(c.object_bytes), bytes([option]))
            self.assertEqual(d.dependency_count, 0)

    def test_zero_and_large_dependency_counts(self):
        for count in (0, 1, 2, 255, 4096):
            raw = storage(body_fixture(tail=count))
            for kind in (Decoded, Constructed):
                out = kind()
                self.assertEqual(self.invoke(kind, raw, len(raw), C.byref(out)), 0)
                self.assertEqual(out.dependency_count, count)
                self.assertEqual(out.dependency_bytes, count * 16)
                self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 1)

    def test_constructor_image_slot_and_runtime_identity(self):
        data = body_fixture(0xFE, 2)
        raw = storage(data)
        out = Constructed()
        self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(out)), 0)
        self.assertEqual(bytes(out.object_bytes), b'\xfe')
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes), (1, 33))
        self.assertEqual((out.payload_offset_before, out.payload_offset_after), (50, 51))
        self.assertEqual((out.result_slot_handle, out.allocation_bytes), (0x6F123456, 1))
        self.assertEqual((out.raw_type, out.runtime_type), (0x6F, 0x6F))
        self.assertEqual((out.dependency_count, out.dependency_bytes), (2, 32))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 1)
        self.assertEqual(bytes(raw), data)

    def test_payload_offset_dword_wrap(self):
        raw = storage(body_fixture(tail=0))
        for offset in (0, 50, 0xFFFFFFFE, 0xFFFFFFFF):
            out = Constructed()
            self.assertEqual(self.invoke(Constructed, raw, 1, C.byref(out), offset=offset), 0)
            self.assertEqual(out.payload_offset_before, offset)
            self.assertEqual(out.payload_offset_after, (offset + 1) & 0xFFFFFFFF)

    def test_short_body_is_atomic(self):
        self.reject(b'', 2)

    def test_partial_dependency_records_are_atomic(self):
        for tail_count in (0, 1, 17):
            for residue in range(1, 16):
                self.reject(body_fixture(tail=tail_count) + bytes(residue), 3)

    def test_null_pointers_are_atomic(self):
        raw = storage(body_fixture())
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            for length in (0, len(raw)):
                self.assertEqual(self.invoke(kind, None, length, C.byref(out)), 1)
            self.assertEqual(self.invoke(kind, raw, len(raw), None), 1)
            self.assertEqual(bytes(out), before)

    def test_zero_allocation_handle_is_atomic(self):
        raw = storage(body_fixture())
        out = Constructed()
        C.memset(C.byref(out), 0xA6, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(out), handle=0), 1)
        self.assertEqual(bytes(out), before)

    def test_address_and_length_wrap_are_atomic(self):
        raw = storage(body_fixture())
        top = C.c_size_t(-1).value
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(kind, C.c_void_p(top - 3), 17, C.byref(out)), 4)
            self.assertEqual(self.invoke(kind, raw, len(raw), C.c_void_p(top - 3)), 4)
            self.assertEqual(self.invoke(kind, raw, top, C.byref(out)), 4)
            self.assertEqual(bytes(out), before)

    def test_overlap_both_directions_and_one_byte_intersection(self):
        data = body_fixture(tail=8)
        for kind in (Decoded, Constructed):
            for raw_offset, out_offset in ((64, 64), (64, 65), (65, 64),
                                          (64, 64 + len(data) - 1),
                                          (64 + C.sizeof(kind) - 1, 64)):
                area = storage(bytes(512))
                C.memmove(C.addressof(area) + raw_offset, data, len(data))
                before = bytes(area)
                status = self.invoke(kind, C.c_void_p(C.addressof(area) + raw_offset),
                                     len(data), C.c_void_p(C.addressof(area) + out_offset))
                self.assertEqual(status, 5)
                self.assertEqual(bytes(area), before)

    def test_adjacent_spans_are_allowed(self):
        for kind in (Decoded, Constructed):
            for raw_offset, out_offset in ((64, 65), (64 + C.sizeof(kind), 64)):
                area = storage(bytes(512))
                area[raw_offset] = 0xD3
                self.assertEqual(self.invoke(kind, C.c_void_p(C.addressof(area) + raw_offset),
                                 1, C.c_void_p(C.addressof(area) + out_offset)), 0)
                self.assertEqual(area[raw_offset], 0xD3)


if __name__ == '__main__':
    unittest.main()
