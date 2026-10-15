"""Synthetic fixtures for A-94.1. No original resource bytes are embedded."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'


class Decoded(C.Structure):
    _fields_ = [('option_00', C.c_uint8 * 33),
                ('word_21', C.c_uint32), ('word_25', C.c_uint32),
                ('word_29', C.c_uint32), ('word_2d', C.c_uint32),
                ('option_31', C.c_uint8),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * 50),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('allocation_bytes', C.c_uint32),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * max(1, len(data)))(*data)


def pointer(p):
    return C.cast(p, C.c_void_p).value


def body_fixture(words=(0x12345678, 0x90ABCDEF, 0x76543210, 0xFEDCBA09),
                 option=0xA7, tail=0, prefix=None):
    # Every byte in the 33-byte prefix is data to the original copy arm.
    if prefix is None:
        prefix = bytes((i * 19 + 7) & 255 for i in range(33))
    if len(prefix) != 33:
        raise ValueError('fixture prefix must have exactly 33 bytes')
    return prefix + struct.pack('<4I', *words) + bytes([option]) + bytes(
        (i * 37 + 11) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_94_decode.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p]
    lib.action_family_94_decode.restype = C.c_int
    lib.action_family_94_construct.argtypes = [C.c_void_p, C.c_size_t,
        C.c_uint32, C.c_uint32, C.c_void_p]
    lib.action_family_94_construct.restype = C.c_int
    return lib


class ActionFamily94Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build = PROJECT / 'scripts/build_action_family_94.sh'
        if not build.exists():
            raise AssertionError('A-94.1 decoder/build is not implemented yet')
        subprocess.run([str(build)], check=True, capture_output=True)
        cls.lib = load_native(Path(os.environ.get('BUILD_DIR', PROJECT / 'build')) /
                              'libactionfamily94.dylib')

    def invoke(self, kind, raw, length, out, offset=50, handle=0x94123456):
        if kind is Decoded:
            return self.lib.action_family_94_decode(raw, length, out)
        return self.lib.action_family_94_construct(raw, length, offset, handle, out)

    def reject(self, data, expected):
        raw = storage(data)
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(kind, raw, len(data), C.byref(out)), expected)
            self.assertEqual(bytes(out), before)
            self.assertEqual(bytes(raw)[:len(data)], data)

    def test_unaligned_little_endian_fields_and_borrowed_tail(self):
        data = body_fixture(tail=8)
        arena = storage(b'!' + data)
        raw = C.c_void_p(C.addressof(arena) + 1)
        out = Decoded()
        self.assertEqual(self.invoke(Decoded, raw, len(data), C.byref(out)), 0)
        self.assertEqual(bytes(out.option_00), data[:33])
        self.assertEqual((out.word_21, out.word_25, out.word_29, out.word_2d),
                         (0x12345678, 0x90ABCDEF, 0x76543210, 0xFEDCBA09))
        self.assertEqual(out.option_31, 0xA7)
        self.assertEqual((out.body_bytes, out.available_body_bytes,
                          out.dependency_count, out.dependency_bytes), (50, 178, 8, 128))
        self.assertEqual(pointer(out.dependency_records), raw.value + 50)
        arena[51] ^= 1
        self.assertEqual(out.dependency_records[0], arena[51])

    def test_unsigned_field_endpoints_are_data_not_counts(self):
        for word in (0, 1, 0x7FFF, 0x8000, 0xFFFF, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF):
            raw = storage(body_fixture(words=(word,) * 4))
            out = Decoded()
            self.assertEqual(self.invoke(Decoded, raw, 50, C.byref(out)), 0)
            self.assertEqual((out.word_21, out.word_25, out.word_29, out.word_2d), (word,) * 4)
            self.assertEqual((out.body_bytes, out.dependency_count), (50, 0))

    def test_prefix_and_final_byte_have_no_loader_nul_or_enum_constraint(self):
        for option in range(256):
            data = body_fixture(option=option, prefix=bytes([option]) * 33)
            raw = storage(data)
            d, c = Decoded(), Constructed()
            self.assertEqual(self.invoke(Decoded, raw, 50, C.byref(d)), 0)
            self.assertEqual(self.invoke(Constructed, raw, 50, C.byref(c)), 0)
            self.assertEqual(bytes(d.option_00), data[:33])
            self.assertEqual(d.option_31, option)
            self.assertEqual(bytes(c.object_bytes), data)

    def test_empty_and_large_dependency_counts(self):
        for count in (0, 1, 2, 255, 4096):
            raw = storage(body_fixture(tail=count))
            for kind in (Decoded, Constructed):
                out = kind()
                self.assertEqual(self.invoke(kind, raw, len(raw), C.byref(out)), 0)
                self.assertEqual((out.dependency_count, out.dependency_bytes), (count, count * 16))
                self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 50)

    def test_complete_constructor_image_slot_and_raw_runtime_identity(self):
        data = body_fixture(option=0xFE, tail=2)
        raw, out = storage(data), Constructed()
        self.assertEqual(self.invoke(Constructed, raw, len(raw), C.byref(out)), 0)
        self.assertEqual(bytes(out.object_bytes), data[:50])
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes), (50, 82))
        self.assertEqual((out.payload_offset_before, out.payload_offset_after), (50, 100))
        self.assertEqual((out.result_slot_handle, out.allocation_bytes), (0x94123456, 50))
        self.assertEqual((out.raw_type, out.runtime_type), (0x94, 0x94))
        self.assertEqual((out.dependency_count, out.dependency_bytes), (2, 32))
        self.assertEqual(bytes(raw), data)

    def test_payload_offset_dword_wrap(self):
        raw = storage(body_fixture())
        for offset, expected in ((0, 50), (50, 100), (0xFFFFFFCD, 0xFFFFFFFF),
                                 (0xFFFFFFCE, 0), (0xFFFFFFFF, 49)):
            out = Constructed()
            self.assertEqual(self.invoke(Constructed, raw, 50, C.byref(out), offset=offset), 0)
            self.assertEqual((out.payload_offset_before, out.payload_offset_after), (offset, expected))

    def test_every_short_body_is_atomic(self):
        data = body_fixture()
        for length in range(50):
            self.reject(data[:length], 2)

    def test_fractional_dependency_records_are_atomic(self):
        for count in (0, 1, 17):
            for residue in range(1, 16):
                self.reject(body_fixture(tail=count) + bytes(residue), 3)

    def test_null_pointers_are_atomic(self):
        raw = storage(body_fixture())
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            for length in (0, 50):
                self.assertEqual(self.invoke(kind, None, length, C.byref(out)), 1)
            self.assertEqual(self.invoke(kind, raw, 50, None), 1)
            self.assertEqual(bytes(out), before)

    def test_zero_allocation_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xA6, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.invoke(Constructed, raw, 50, C.byref(out), handle=0), 1)
        self.assertEqual(bytes(out), before)

    def test_wrapped_address_spans_and_size_overflow_are_atomic(self):
        raw = storage(body_fixture())
        top = C.c_size_t(-1).value
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xA6, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(kind, C.c_void_p(top - 3), 50, C.byref(out)), 4)
            self.assertEqual(self.invoke(kind, raw, 50, C.c_void_p(top - 3)), 4)
            self.assertEqual(self.invoke(kind, raw, top, C.byref(out)), 4)
            self.assertEqual(bytes(out), before)

    def test_overlap_both_directions_and_single_byte_intersection(self):
        data = body_fixture(tail=8)
        for kind in (Decoded, Constructed):
            for ro, oo in ((64, 64), (64, 65), (65, 64), (64, 64 + len(data) - 1),
                           (64 + C.sizeof(kind) - 1, 64)):
                arena = storage(bytes(1024))
                C.memmove(C.addressof(arena) + ro, data, len(data))
                before = bytes(arena)
                status = self.invoke(kind, C.c_void_p(C.addressof(arena) + ro), len(data),
                                     C.c_void_p(C.addressof(arena) + oo))
                self.assertEqual(status, 5)
                self.assertEqual(bytes(arena), before)

    def test_adjacent_spans_are_allowed(self):
        data = body_fixture()
        for kind in (Decoded, Constructed):
            for ro, oo in ((64, 114), (64 + C.sizeof(kind), 64)):
                arena = storage(bytes(1024))
                C.memmove(C.addressof(arena) + ro, data, len(data))
                self.assertEqual(self.invoke(kind, C.c_void_p(C.addressof(arena) + ro), 50,
                                 C.c_void_p(C.addressof(arena) + oo)), 0)
                self.assertEqual(bytes(arena)[ro:ro + 50], data)


if __name__ == '__main__':
    unittest.main()
