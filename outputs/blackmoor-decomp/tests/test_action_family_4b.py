"""Fixtures first for A-4B.1. All embedded text is synthetic."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = PROJECT.parents[1] / 'work/analysis/slices'
MAX_OBJECT = 32767
MAX_RESOLVED = 32761


class Decoded(C.Structure):
    _fields_ = [('text_selector', C.c_int16), ('text_key', C.c_uint8 * 33),
                ('inline_text', C.c_void_p), ('inline_text_bytes', C.c_size_t),
                ('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * MAX_OBJECT),
                ('allocation_bytes', C.c_size_t), ('dependency_records', C.c_void_p),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32)]


def fixture(selector=0, tails=0, text=None, key=b'KEY', key_padding=0):
    prefix = struct.pack('<h', selector)
    if selector == -1:
        if len(key) > 32:
            raise ValueError('synthetic key too long')
        prefix += key + b'\0' + bytes([key_padding]) * (32 - len(key))
    elif selector >= 0:
        inline = bytes((i * 37 + 11) & 255 for i in range(selector)) if text is None else text
        if len(inline) != selector:
            raise ValueError('synthetic inline length mismatch')
        prefix += inline
    return prefix + bytes((i * 17 + 3) & 255 for i in range(tails * 16))


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_4b_decode.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_4b_decode.restype = C.c_int
    lib.action_family_4b_body_length.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_4b_body_length.restype = C.c_int
    lib.action_family_4b_construct.argtypes = [C.c_void_p, C.c_size_t, C.c_void_p,
        C.c_size_t, C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_4b_construct.restype = C.c_int
    return lib


class Family4BTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-4B.1.unit-', dir=PRIVATE)
        cls.addClassCleanup(cls.directory.cleanup)
        subprocess.run([str(PROJECT / 'scripts/build_action_family_4b.sh')], check=True,
                       env=dict(os.environ, BUILD_DIR=cls.directory.name), stdout=subprocess.DEVNULL)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily4b.dylib')

    def reject(self, body, expected=None):
        raw = storage(body)
        decoded, constructed, length = Decoded(), Constructed(), C.c_size_t(123456)
        for out in (decoded, constructed):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(decoded), bytes(constructed), length.value
        statuses = (self.lib.action_family_4b_decode(raw, len(body), C.byref(decoded)),
                    self.lib.action_family_4b_construct(raw, len(body), None, 0, 50, 7,
                                                      C.byref(constructed)),
                    self.lib.action_family_4b_body_length(raw, len(body), C.byref(length)))
        for status in statuses:
            self.assertNotEqual(status, 0)
            if expected is not None:
                self.assertEqual(status, expected)
        self.assertEqual((bytes(decoded), bytes(constructed), length.value), before)
        self.assertEqual(bytes(raw)[:len(body)], body)

    def test_inline_minimum_and_dependency_view(self):
        raw = storage(fixture(0, 3))
        d, n = Decoded(), C.c_size_t()
        self.assertEqual(self.lib.action_family_4b_decode(raw, len(raw), C.byref(d)), 0)
        self.assertEqual(self.lib.action_family_4b_body_length(raw, len(raw), C.byref(n)), 0)
        self.assertEqual((d.text_selector, d.body_bytes, n.value, d.dependency_count,
                          d.dependency_bytes, d.available_body_bytes), (0, 2, 2, 3, 48, 50))
        self.assertEqual((d.inline_text, d.inline_text_bytes), (C.addressof(raw) + 2, 0))
        self.assertEqual(d.dependency_records, C.addressof(raw) + 2)
        self.assertEqual(bytes(d.text_key), bytes(33))

    def test_inline_maximum_and_unaligned_source(self):
        body = fixture(9999, 2)
        backing = storage(b'!' + body)
        ptr = C.addressof(backing) + 1
        d = Decoded()
        self.assertEqual(self.lib.action_family_4b_decode(ptr, len(body), C.byref(d)), 0)
        self.assertEqual((d.body_bytes, d.inline_text_bytes, d.dependency_count), (10001, 9999, 2))
        self.assertEqual(C.string_at(d.inline_text, 9999), body[2:10001])

    def test_key_form_and_padding(self):
        raw = storage(fixture(-1, 4, key_padding=0xfe))
        d = Decoded()
        self.assertEqual(self.lib.action_family_4b_decode(raw, len(raw), C.byref(d)), 0)
        self.assertEqual((d.text_selector, d.body_bytes, d.dependency_count), (-1, 35, 4))
        self.assertEqual(bytes(d.text_key), b'KEY' + bytes(30))
        self.assertEqual((d.inline_text, d.inline_text_bytes), (None, 0))
        self.assertEqual(d.dependency_records, C.addressof(raw) + 35)
        for key in (b'', b'k' * 32):
            raw = storage(fixture(-1, key=key))
            self.assertEqual(self.lib.action_family_4b_decode(raw, len(raw), C.byref(d)), 0)
            self.assertEqual(bytes(d.text_key), key + bytes(33 - len(key)))

    def test_every_short_body(self):
        for selector in (0, 1, 19, -1):
            body = fixture(selector)
            for length in range(len(body)):
                self.reject(body[:length], 2)

    def test_short_maximum_inline(self):
        self.reject(fixture(9999)[:-1], 2)

    def test_every_fractional_tail(self):
        for selector in (0, 9, -1):
            for tail in range(1, 16):
                self.reject(fixture(selector) + bytes(tail), 5)

    def test_negative_and_overflow_selectors(self):
        for n in (-32768, -99, -2, 10000, 32767):
            self.reject(struct.pack('<h', n), 3)

    def test_unterminated_key(self):
        self.reject(b'\xff\xff' + b'k' * 33, 4)

    def test_constructor_inline_complete_image(self):
        for text in (b'', b'a', b'a\0b', bytes(range(256)), b'x' * 9999):
            raw = storage(fixture(len(text), 2, text=text))
            out = Constructed()
            self.assertEqual(self.lib.action_family_4b_construct(raw, len(raw), None, 0,
                50, 0x4b000001, C.byref(out)), 0)
            expected = struct.pack('<H', len(text) + 3) + text + b'<e>'
            self.assertEqual(bytes(out.object_bytes[:out.allocation_bytes]), expected)
            self.assertEqual(out.allocation_bytes, len(text) + 5)
            self.assertEqual((out.body_bytes_consumed, out.payload_offset_after,
                out.result_slot_handle), (len(text) + 2, len(text) + 52, 0x4b000001))
            self.assertEqual(out.dependency_count, 2)
            self.assertEqual(out.dependency_records, C.addressof(raw) + len(text) + 2)

    def test_constructor_key_complete_image_and_maximum(self):
        raw = storage(fixture(-1, 1))
        for text in (b'', b'z', b'text', b'z' * MAX_RESOLVED):
            resolved = storage(text) if text else None
            out = Constructed()
            self.assertEqual(self.lib.action_family_4b_construct(raw, len(raw), resolved, len(text),
                50, 7, C.byref(out)), 0)
            expected = struct.pack('<H', len(text) + 3) + text + b'<e>\0'
            self.assertEqual(bytes(out.object_bytes[:out.allocation_bytes]), expected)
            self.assertEqual(out.allocation_bytes, len(text) + 6)
            self.assertEqual((out.body_bytes_consumed, out.payload_offset_after), (35, 85))

    def test_constructor_offset_wrap(self):
        for selector in (0, 9999, -1):
            raw = storage(fixture(selector))
            out = Constructed()
            for before in (0, 50, 0xfffffffe, 0xffffffff):
                self.assertEqual(self.lib.action_family_4b_construct(raw, len(raw), None, 0,
                    before, 7, C.byref(out)), 0)
                self.assertEqual(out.payload_offset_after, (before + out.body_bytes_consumed) & 0xffffffff)

    def test_bad_resolved_text_is_atomic(self):
        raw = storage(fixture(-1))
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        for data, n in ((None, 1), (storage(b'a\0b'), 3),
                         (storage(b'x' * (MAX_RESOLVED + 1)), MAX_RESOLVED + 1),
                         (storage(b'x' * 40000), 40000)):
            self.assertNotEqual(self.lib.action_family_4b_construct(raw, len(raw), data, n,
                50, 7, C.byref(out)), 0)
            self.assertEqual(bytes(out), before)
        raw = storage(fixture(0))
        self.assertNotEqual(self.lib.action_family_4b_construct(raw, len(raw), storage(b'x'), 1,
            50, 7, C.byref(out)), 0)
        self.assertEqual(bytes(out), before)

    def test_null_inputs_outputs_and_handle(self):
        raw = storage(fixture())
        d, out, n = Decoded(), Constructed(), C.c_size_t(12345)
        for obj in (d, out):
            C.memset(C.byref(obj), 0xa5, C.sizeof(obj))
        before = bytes(d), bytes(out), n.value
        for p in (None, raw):
            if p is None:
                self.assertEqual(self.lib.action_family_4b_decode(p, 2, C.byref(d)), 1)
                self.assertEqual(self.lib.action_family_4b_body_length(p, 2, C.byref(n)), 1)
                self.assertEqual(self.lib.action_family_4b_construct(p, 2, None, 0, 50, 7, C.byref(out)), 1)
            else:
                self.assertEqual(self.lib.action_family_4b_decode(p, 2, None), 1)
                self.assertEqual(self.lib.action_family_4b_body_length(p, 2, None), 1)
                self.assertEqual(self.lib.action_family_4b_construct(p, 2, None, 0, 50, 7, None), 1)
        self.assertEqual(self.lib.action_family_4b_construct(raw, 2, None, 0, 50, 0, C.byref(out)), 1)
        self.assertEqual((bytes(d), bytes(out), n.value), before)

    def test_wrapped_spans_before_read_or_mutation(self):
        maximum = C.c_size_t(-1).value
        raw = storage(fixture())
        d, out, n = Decoded(), Constructed(), C.c_size_t(42)
        C.memset(C.byref(d), 0xa5, C.sizeof(d)); C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(d), bytes(out), n.value
        for pointer, length in ((maximum - 1, 4), (raw, maximum)):
            self.assertEqual(self.lib.action_family_4b_decode(pointer, length, C.byref(d)), 6)
            self.assertEqual(self.lib.action_family_4b_body_length(pointer, length, C.byref(n)), 6)
            self.assertEqual(self.lib.action_family_4b_construct(pointer, length, None, 0, 50, 7, C.byref(out)), 6)
        self.assertEqual((bytes(d), bytes(out), n.value), before)
        key = storage(fixture(-1))
        self.assertEqual(self.lib.action_family_4b_construct(key, 35, maximum - 1, 4,
            50, 7, C.byref(out)), 6)
        self.assertEqual(bytes(out), before[1])

    def test_input_output_overlap_is_atomic(self):
        raw = storage(fixture(-1) + bytes(C.sizeof(Constructed) + 32))
        before = bytes(raw)
        self.assertEqual(self.lib.action_family_4b_decode(raw, 35, C.cast(raw, C.POINTER(Decoded))), 7)
        self.assertEqual(self.lib.action_family_4b_body_length(raw, 35, C.cast(raw, C.POINTER(C.c_size_t))), 7)
        self.assertEqual(self.lib.action_family_4b_construct(raw, 35, None, 0, 50, 7,
            C.cast(raw, C.POINTER(Constructed))), 7)
        self.assertEqual(bytes(raw), before)
        # A raw span ending at out is nonoverlapping; aliasing text with out is not.
        out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
        self.assertEqual(self.lib.action_family_4b_construct(raw, 35, C.byref(out), 1,
            50, 7, C.byref(out)), 7)
        self.assertEqual(bytes(out), before)

    def test_resolved_text_can_borrow_input(self):
        raw = storage(fixture(-1))
        out = Constructed()
        self.assertEqual(self.lib.action_family_4b_construct(raw, 35, C.addressof(raw) + 2, 3,
            50, 7, C.byref(out)), 0)
        self.assertEqual(bytes(out.object_bytes[:out.allocation_bytes]), b'\x06\0KEY<e>\0')

    def test_dependency_count_is_not_narrowed(self):
        raw = storage(fixture(0, 65536))
        d = Decoded()
        self.assertEqual(self.lib.action_family_4b_decode(raw, len(raw), C.byref(d)), 0)
        self.assertEqual(d.dependency_count, 65536)


if __name__ == '__main__':
    unittest.main()
