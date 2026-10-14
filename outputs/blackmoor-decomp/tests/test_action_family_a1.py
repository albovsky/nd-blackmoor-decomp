"""Synthetic fixtures for A-A1.1; no original resource bytes are embedded."""
import ctypes as C
import struct
import subprocess
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
MAX_OBJECT = 32767


class Decoded(C.Structure):
    _fields_ = [('name', C.c_uint8 * 33), ('option_21', C.c_uint16),
                ('word_23', C.c_uint32), ('option_27', C.c_uint16),
                ('option_29', C.c_uint16), ('option_2b', C.c_uint8),
                ('option_2c', C.c_uint16), ('option_2e', C.c_uint16),
                ('option_30', C.c_uint8), ('text_selector', C.c_int16),
                ('text_key', C.c_uint8 * 33), ('inline_text', C.c_void_p),
                ('inline_text_bytes', C.c_size_t), ('dependency_records', C.c_void_p),
                ('dependency_count', C.c_size_t), ('body_bytes', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * MAX_OBJECT),
                ('allocation_bytes', C.c_size_t), ('dependency_records', C.c_void_p),
                ('dependency_count', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32)]


def fixture(selector=0, tails=0, name=b'synthetic', text=None):
    n = 84 if selector == -1 else 51 + max(selector, 0)
    b = bytearray(n + tails * 16)
    b[:len(name)] = name
    struct.pack_into('<HIHHBHHBh', b, 33, 0x8123, 0xfedcba98, 0x8001,
                     0x7fff, 0xfe, 0xffff, 0x8765, 0x80, selector)
    if selector == -1:
        b[51:55] = b'KEY\0'
    elif selector > 0:
        b[51:51+selector] = text if text is not None else b'x' * selector
    for i in range(n, len(b)):
        b[i] = (i * 37 + 11) & 255
    return bytes(b)


def storage(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(b)


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_a1_decode.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_a1_decode.restype = C.c_int
    lib.action_family_a1_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p,
        C.c_size_t, C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_a1_construct.restype = C.c_int
    return lib


class FamilyA1Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / 'scripts/build_action_family_a1.sh')], check=True,
                       stdout=subprocess.DEVNULL)
        cls.lib = load_native(PROJECT / 'build/libactionfamilya1.dylib')

    def reject(self, b, expected=None):
        src = storage(b)
        for typ in (Decoded, Constructed):
            out = typ()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            if typ is Decoded:
                status = self.lib.action_family_a1_decode(src, len(b), C.byref(out))
            else:
                status = self.lib.action_family_a1_construct(src, len(b), None, 0,
                                                            50, 1, C.byref(out))
            self.assertNotEqual(status, 0)
            if expected is not None:
                self.assertEqual(status, expected)
            self.assertEqual(bytes(out), before)

    def test_inline_minimum_and_borrowed_tail(self):
        src = storage(fixture(tails=3))
        d = Decoded()
        self.assertEqual(self.lib.action_family_a1_decode(src, len(src), C.byref(d)), 0)
        self.assertEqual((d.body_bytes, d.dependency_count, d.dependency_bytes), (51, 3, 48))
        self.assertEqual(d.dependency_records, C.addressof(src)+51)
        self.assertEqual((d.option_21, d.word_23, d.option_27, d.option_29,
                          d.option_2b, d.option_2c, d.option_2e, d.option_30),
                         (0x8123, 0xfedcba98, 0x8001, 0x7fff, 0xfe, 0xffff, 0x8765, 0x80))

    def test_inline_maximum(self):
        src = storage(fixture(9999, 2))
        d = Decoded()
        self.assertEqual(self.lib.action_family_a1_decode(src, len(src), C.byref(d)), 0)
        self.assertEqual((d.body_bytes, d.inline_text_bytes), (10050, 9999))
        self.assertEqual(C.string_at(d.inline_text, 9999), b'x' * 9999)

    def test_key_form(self):
        src = storage(fixture(-1, 4))
        d = Decoded()
        self.assertEqual(self.lib.action_family_a1_decode(src, len(src), C.byref(d)), 0)
        self.assertEqual((d.body_bytes, d.text_selector, d.dependency_count), (84, -1, 4))
        self.assertEqual(bytes(d.text_key), b'KEY'+bytes(30))

    def test_every_short_prefix(self):
        for n in range(51):
            self.reject(fixture()[:n])

    def test_truncated_key(self):
        for n in range(51, 84):
            self.reject(fixture(-1)[:n])

    def test_truncated_inline(self):
        self.reject(fixture(99)[:-1])

    def test_misaligned_tails(self):
        for n in range(1, 16):
            self.reject(fixture()+bytes(n))
            self.reject(fixture(-1)+bytes(n))

    def test_negative_and_overflow_counts(self):
        for n in (-32768, -2, 10000, 32767):
            self.reject(fixture(n))

    def test_unterminated_names_and_keys(self):
        b = bytearray(fixture()); b[:33] = b'x'*33; self.reject(b)
        b = bytearray(fixture(-1)); b[51:84] = b'x'*33; self.reject(b)

    def test_null_and_zero_handle(self):
        d, out = Decoded(), Constructed()
        src = storage(fixture())
        self.assertNotEqual(self.lib.action_family_a1_decode(None, 51, C.byref(d)), 0)
        self.assertNotEqual(self.lib.action_family_a1_decode(src, 51, None), 0)
        before = bytes(out)
        self.assertNotEqual(self.lib.action_family_a1_construct(src, 51, None, 0, 0, 0, C.byref(out)), 0)
        self.assertEqual(bytes(out), before)

    def test_overlap_and_address_wrap(self):
        arena = (C.c_uint8 * 40000)()
        C.memmove(arena, fixture(), 51)
        before = bytes(arena)
        self.assertNotEqual(self.lib.action_family_a1_decode(arena, 51, C.cast(arena, C.POINTER(Decoded))), 0)
        self.assertNotEqual(self.lib.action_family_a1_construct(arena, 51, None, 0, 50, 1,
                           C.cast(arena, C.POINTER(Constructed))), 0)
        self.assertEqual(bytes(arena), before)
        d = Decoded()
        self.assertNotEqual(self.lib.action_family_a1_decode(arena, C.c_size_t(-1).value, C.byref(d)), 0)
        self.assertNotEqual(self.lib.action_family_a1_decode(C.c_void_p(C.c_size_t(-16).value), 51, C.byref(d)), 0)

    def test_constructor_inline_and_wrap(self):
        for n in (0, 1, 9999):
            src = storage(fixture(n, 2))
            out = Constructed()
            self.assertEqual(self.lib.action_family_a1_construct(src, len(src), None, 0,
                             0xfffffff0, 0x1234, C.byref(out)), 0)
            self.assertEqual(out.allocation_bytes, 175+n)
            self.assertEqual(out.payload_offset_after, (0xfffffff0+51+n) & 0xffffffff)
            self.assertEqual(out.result_slot_handle, 0x1234)
            self.assertEqual(struct.unpack_from('<H', bytes(out.object_bytes), 0xaa)[0], n+3 if n else 0)
            if n:
                self.assertEqual(bytes(out.object_bytes[172:172+n+3]), b'x'*n+b'<e>')

    def test_constructor_resolved_text_limits(self):
        src = storage(fixture(-1))
        for n in (0, 1, 32591):
            text = storage(b'z'*n) if n else None
            out = Constructed()
            self.assertEqual(self.lib.action_family_a1_construct(src, len(src), text, n, 50, 7, C.byref(out)), 0)
            self.assertEqual(out.allocation_bytes, n+176)
            self.assertEqual(bytes(out.object_bytes[172:172+n+4]), b'z'*n+b'<e>\0')

    def test_resolved_text_rejections_atomic(self):
        src = storage(fixture(-1))
        out = Constructed()
        C.memset(C.byref(out), 0x69, C.sizeof(out)); before = bytes(out)
        for text, n in ((None, 1), (storage(b'z'*32592), 32592),
                        (storage(b'a\0b'), 3), (C.byref(out), 1)):
            self.assertNotEqual(self.lib.action_family_a1_construct(src, len(src), text, n, 50, 1, C.byref(out)), 0)
            self.assertEqual(bytes(out), before)


if __name__ == '__main__':
    unittest.main()
