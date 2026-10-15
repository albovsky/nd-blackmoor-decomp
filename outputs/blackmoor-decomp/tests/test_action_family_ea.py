"""Fixtures for raw 0xea's fixed 3,847-byte body and successful allocation model.

The original loader arm (0x410893 -> 0x484110) mallocs exactly 0xf07 bytes and
copies 0x3c1 DWORDs, one WORD and one BYTE from the raw body: a fixed, opaque
copy with no count, string scan or field decision. No lifecycle, dependency
evaluation or gameplay assertions are made here.
"""
import ctypes as C
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
BODY_BYTES = OBJECT_BYTES = 3847
DEPENDENCY_BYTES = 16
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('byte', C.c_uint8 * BODY_BYTES),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * OBJECT_BYTES),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('allocation_bytes', C.c_uint32),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(first=0x12, tail=0, seed=7):
    # Every byte position carries a position-dependent value (period > 255 via
    # the high index byte), with high bits set and no NUL terminator guarantee:
    # the original loader is a fixed copy, with no count or NUL scan.
    body = bytes(((i * 131 + seed * 7 + (i >> 8) * 29) ^ 0x81) & 255
                 for i in range(BODY_BYTES))
    body = bytes([first]) + body[1:]
    return body + bytes((i * 19 + seed) & 255 for i in range(tail * DEPENDENCY_BYTES))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_ea_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_ea_decode.restype = C.c_int
    lib.action_family_ea_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_ea_body_length.restype = C.c_int
    lib.action_family_ea_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
                                              C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_ea_construct.restype = C.c_int
    return lib


class ActionFamilyEaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Unique temp dir outside the canonical evidence tree.
        cls.directory = tempfile.TemporaryDirectory(prefix='A-EA.1.tests-', dir='/private/tmp')
        run = subprocess.run([str(PROJECT / 'scripts/build_action_family_ea.sh')],
                             env=dict(os.environ, BUILD_DIR=cls.directory.name),
                             capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamilyea.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length):
        return [(Decoded(), lambda out: self.lib.action_family_ea_decode(raw, length, C.byref(out))),
                (C.c_size_t(), lambda out: self.lib.action_family_ea_body_length(raw, length, C.byref(out))),
                (Constructed(), lambda out: self.lib.action_family_ea_construct(raw, length, 50, 0xea0001, C.byref(out)))]

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out, call in self.calls(raw, len(data)):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_body(self):
        raw = storage(bytes(BODY_BYTES))
        d = Decoded()
        self.assertEqual(self.lib.action_family_ea_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual(bytes(d.byte), bytes(BODY_BYTES))
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_count, d.dependency_bytes),
                         (3847, 3847, 0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 3847)

    def test_every_byte_offset(self):
        body = body_fixture(seed=131)
        raw, d = storage(body), Decoded()
        self.assertEqual(self.lib.action_family_ea_decode(raw, len(body), C.byref(d)), OK)
        self.assertEqual(bytes(d.byte), body)
        # A single changed byte at every position (including the WORD at
        # 3844..3845 and the final odd byte 3846 copied by MOVSB).
        for position in range(BODY_BYTES):
            changed = bytearray(body)
            changed[position] ^= 0xff
            raw = storage(bytes(changed))
            self.assertEqual(self.lib.action_family_ea_decode(raw, len(changed), C.byref(d)), OK)
            self.assertEqual(bytes(d.byte), bytes(changed))

    def test_arbitrary_bit_patterns_are_data(self):
        for fill in (0x00, 0x01, 0x7f, 0x80, 0xff):
            body = bytes([fill]) * BODY_BYTES
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_ea_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual(bytes(d.byte), body)
            self.assertEqual(d.body_bytes, 3847)

    def test_dependency_view_and_count_width(self):
        for count in (0, 1, 2, 9, 256, 65536):
            raw, d = storage(body_fixture(tail=count)), Decoded()
            self.assertEqual(self.lib.action_family_ea_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.body_bytes, d.available_body_bytes),
                             (count, count * 16, 3847, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 3847)
            if count:
                raw[3847] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[3847])

    def test_body_length(self):
        for count in (0, 1, 2, 256):
            raw = storage(body_fixture(tail=count))
            n = C.c_size_t(123)
            self.assertEqual(self.lib.action_family_ea_body_length(raw, len(raw), C.byref(n)), OK)
            self.assertEqual(n.value, 3847)

    def test_every_short_body_is_atomic(self):
        for n in range(BODY_BYTES):
            self.assert_rejected(bytes(n), BODY)

    def test_off_by_one_boundaries(self):
        self.assert_rejected(body_fixture()[:3846], BODY)
        self.assert_rejected(body_fixture() + b'\0', TAIL)
        raw, d = storage(body_fixture(tail=1)), Decoded()
        self.assertEqual(self.lib.action_family_ea_decode(raw, 3847 + 16, C.byref(d)), OK)

    def test_ragged_tails_are_atomic(self):
        for n in list(range(1, 41)) + [255, 257, 4095, 4097]:
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_tail_modulus_is_sixteen_for_large_tails(self):
        # The modulus must not be dropped, narrowed or limited to small tails.
        for n in (8, 24, 4096 + 8, 4096 + 16, 4088, 65536 * 16 + 8, 65536 * 16 + 16):
            raw = storage(body_fixture() + bytes(n))
            d = Decoded()
            self.assertEqual(self.lib.action_family_ea_decode(raw, 3847 + n, C.byref(d)),
                             OK if n % 16 == 0 else TAIL, n)

    def test_constructor_entire_allocation(self):
        body = body_fixture(tail=2)
        raw, out = storage(body), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_ea_construct(raw, len(body), 50, 0xea0001, C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), body[:3847])
        self.assertEqual((out.payload_offset_before, out.payload_offset_after, out.result_slot_handle,
                          out.allocation_bytes, out.raw_type, out.runtime_type),
                         (50, 50 + 3847, 0xea0001, 3847, 0xea, 0xea))
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes, out.dependency_count,
                          out.dependency_bytes), (3847, 3847 + 32, 2, 32))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 3847)

    def test_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xfffff0f8, 0xfffff0f9, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_ea_construct(raw, 3847, offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + 3847) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_ea_construct(raw, 3847, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        for out, call in self.calls(None, 3847):
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            self.assertEqual(call(out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        raw = storage(body_fixture())
        self.assertEqual(self.lib.action_family_ea_decode(raw, 3847, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_ea_body_length(raw, 3847, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_ea_construct(raw, 3847, 0, 1, None), ARGUMENT)

    def test_wrapped_input_spans_are_atomic(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        for ptr, length in ((C.cast(huge, C.POINTER(C.c_uint8)), 3847), (raw, huge)):
            for out, call in self.calls(ptr, length):
                C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
                self.assertEqual(call(out), BOUNDS)
                self.assertEqual(bytes(out), before)

    def test_wrapped_output_spans(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        self.assertEqual(self.lib.action_family_ea_decode(raw, 3847, C.cast(huge, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_ea_body_length(raw, 3847, C.cast(huge, C.POINTER(C.c_size_t))), BOUNDS)
        self.assertEqual(self.lib.action_family_ea_construct(raw, 3847, 0, 1, C.cast(huge, C.POINTER(Constructed))), BOUNDS)

    def test_overlap_and_adjacency(self):
        for kind, func, extra in ((Decoded, self.lib.action_family_ea_decode, ()),
                                 (C.c_size_t, self.lib.action_family_ea_body_length, ()),
                                 (Constructed, self.lib.action_family_ea_construct, (50, 1))):
            for delta in (-3846, -1, 0, 1, C.sizeof(kind) - 1):
                backing = (C.c_uint8 * (3847 * 2 + C.sizeof(kind)))()
                C.memset(backing, 0xa5, len(backing)); before = bytes(backing)
                out = C.cast(C.addressof(backing) + 3847, C.POINTER(kind))
                raw = C.cast(C.addressof(out.contents) + delta, C.POINTER(C.c_uint8))
                self.assertEqual(func(raw, 3847, *extra, out), OVERLAP)
                self.assertEqual(bytes(backing), before)
            for after in (True, False):
                backing = (C.c_uint8 * (3847 + C.sizeof(kind)))()
                raw_address = C.addressof(backing) + (C.sizeof(kind) if after else 0)
                out_address = C.addressof(backing) + (0 if after else 3847)
                raw = C.cast(raw_address, C.POINTER(C.c_uint8))
                C.memmove(raw, body_fixture(), 3847)
                out = C.cast(out_address, C.POINTER(kind))
                self.assertEqual(func(raw, 3847, *extra, out), OK)


if __name__ == '__main__':
    unittest.main()
