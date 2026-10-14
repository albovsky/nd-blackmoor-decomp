"""Synthetic fixtures for A-2E.1; no original resource bytes."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OBJECT_BYTES = 15
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('option_00', C.c_uint8), ('word', C.c_uint16 * 7),
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
    return (C.c_uint8 * len(data)).from_buffer_copy(data)


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(word=0x1234, tail=0, option=0xa7):
    return struct.pack('<B7H', option, *[(word + i * 7919) & 65535 for i in range(7)]) + bytes(
        (i * 19 + 7) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_2e_decode.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p]
    lib.action_family_2e_decode.restype = C.c_int
    lib.action_family_2e_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_uint32, C.c_uint32, C.c_void_p]
    lib.action_family_2e_construct.restype = C.c_int
    return lib


class ActionFamily2eTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-2E.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily2e.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_2e.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def invoke(self, cls, raw, length, out, offset=50, handle=0x2e0001):
        if cls is Decoded:
            return self.lib.action_family_2e_decode(raw, length, out)
        return self.lib.action_family_2e_construct(raw, length, offset, handle, out)

    def reject(self, data, expected):
        raw = storage(data)
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(cls, raw, len(data), C.byref(out)), expected)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw), data)

    def test_minimum_body_and_little_endian_fields(self):
        raw = storage(body_fixture())
        d = Decoded()
        self.assertEqual(self.invoke(Decoded, raw, len(raw), C.byref(d)), OK)
        self.assertEqual(list(d.word), list(struct.unpack('<7H', bytes(raw[1:15]))))
        self.assertEqual(d.option_00, 0xa7)
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_bytes, d.dependency_count),
                         (15, 15, 0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 15)

    def test_bit_patterns_are_data_not_counts(self):
        # No count field exists. Signed-looking words and bytes are retained.
        for word in (0, 1, 0x7fff, 0x8000, 0xffff):
            for option in (0, 127, 128, 255):
                raw = storage(body_fixture(word, 0, option))
                d, c = Decoded(), Constructed()
                self.assertEqual(self.invoke(Decoded, raw, len(raw), C.byref(d)), OK)
                self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(c)), OK)
                self.assertEqual((d.word[0], d.option_00, d.body_bytes), (word, option, 15))
                self.assertEqual(bytes(c.object_bytes), bytes(raw))

    def test_dependency_counts_and_borrowed_view(self):
        for count in (0, 1, 9, 1000, 4096):
            raw = storage(body_fixture(tail=count))
            for cls in (Decoded, Constructed):
                out = cls()
                self.assertEqual(self.invoke(cls, raw, len(raw), C.byref(out)), OK)
                self.assertEqual((out.dependency_count, out.dependency_bytes, out.available_body_bytes),
                                 (count, count * 16, len(raw)))
                self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 15)
                if count:
                    raw[15] ^= 255
                    self.assertEqual(out.dependency_records[0], raw[15])

    def test_every_short_body_is_atomic(self):
        for length in range(15):
            self.reject(bytes(length), BODY)

    def test_fractional_tails_are_atomic(self):
        for count in (0, 1, 17):
            for residue in range(1, 16):
                self.reject(body_fixture(tail=count) + bytes(residue), TAIL)

    def test_complete_constructor_image_and_constants(self):
        raw = storage(body_fixture(tail=1))
        c = Constructed()
        self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(c)), OK)
        self.assertEqual(bytes(c.object_bytes), bytes(raw[:15]))
        self.assertEqual((c.body_bytes_consumed, c.payload_offset_before, c.payload_offset_after,
            c.output_handle, c.result_slot_handle, c.output_allocation_bytes),
            (15, 50, 65, 0x2e0001, 0x2e0001, 15))

    def test_dword_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xfffffff0, 0xfffffff1, 0xffffffff):
            c = Constructed()
            self.assertEqual(self.invoke(Constructed, raw, 15, C.byref(c), offset), OK)
            self.assertEqual(c.payload_offset_after, (offset + 15) & 0xffffffff)

    def test_null_pointers_and_zero_handle_are_atomic(self):
        raw = storage(body_fixture())
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(cls, None, 15, C.byref(out)), ARGUMENT)
            self.assertEqual(self.invoke(cls, raw, 15, None), ARGUMENT)
            if cls is Constructed:
                self.assertEqual(self.invoke(cls, raw, 15, C.byref(out), handle=0), ARGUMENT)
            self.assertEqual(bytes(out), before)

    def test_overlap_both_directions_is_atomic(self):
        for cls in (Decoded, Constructed):
            for raw_offset, out_offset in ((64, 64), (64, 65), (65, 64), (64, 78),
                                          (64 + C.sizeof(cls) - 1, 64)):
                area = storage(bytes(512))
                C.memmove(C.addressof(area) + raw_offset, body_fixture(), 15)
                before = bytes(area)
                self.assertEqual(self.invoke(cls, C.addressof(area) + raw_offset, 15,
                    C.addressof(area) + out_offset), OVERLAP)
                self.assertEqual(bytes(area), before)

    def test_adjacent_spans(self):
        for cls in (Decoded, Constructed):
            for raw_offset, out_offset in ((64, 79), (64 + C.sizeof(cls), 64)):
                area = storage(bytes(512))
                C.memmove(C.addressof(area) + raw_offset, body_fixture(), 15)
                self.assertEqual(self.invoke(cls, C.addressof(area) + raw_offset, 15,
                    C.addressof(area) + out_offset), OK)

    def test_wrapped_spans_are_atomic(self):
        raw = storage(body_fixture())
        top = C.c_size_t(-1).value
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            for p, length, dst in ((top - 3, 15, C.byref(out)),
                    (raw, top, C.byref(out)), (raw, 15, top - 3)):
                self.assertEqual(self.invoke(cls, p, length, dst), BOUNDS)
                self.assertEqual(bytes(out), before)


if __name__ == '__main__':
    unittest.main()
