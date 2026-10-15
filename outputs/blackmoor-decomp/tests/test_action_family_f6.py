"""Fixtures for raw 0xf6's fixed body and successful allocation model.

The original loader arm (0x4109f8 -> 0x45ddd0) allocates and copies a fixed
4,934-byte body. These tests make no lifecycle, dependency evaluation or
gameplay assertions. Build output goes to a unique temporary directory.
"""
import ctypes as C
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
BODY_BYTES = OBJECT_BYTES = 4934
OK, ARGUMENT, BODY, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('body', C.c_uint8 * BODY_BYTES),
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


def body_fixture(tail=0, seed=7):
    # Distinct bytes everywhere, high bits and no NUL anywhere: the original
    # loader is a blind fixed copy (no count, string scan or NUL requirement).
    body = bytes(((i * 131 + (i >> 8) * 17 + seed) % 255) + 1 for i in range(BODY_BYTES))
    return body + bytes((i * 19 + seed) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_f6_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_f6_decode.restype = C.c_int
    lib.action_family_f6_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_f6_body_length.restype = C.c_int
    lib.action_family_f6_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
                                              C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_f6_construct.restype = C.c_int
    return lib


class ActionFamilyF6Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-F6.1.tests-', dir='/private/tmp')
        run = subprocess.run([str(PROJECT / 'scripts/build_action_family_f6.sh')],
                             env=dict(os.environ, BUILD_DIR=cls.directory.name),
                             capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamilyf6.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length):
        return [(Decoded(), lambda out: self.lib.action_family_f6_decode(raw, length, C.byref(out))),
                (C.c_size_t(), lambda out: self.lib.action_family_f6_body_length(raw, length, C.byref(out))),
                (Constructed(), lambda out: self.lib.action_family_f6_construct(raw, length, 50, 0xf60001, C.byref(out)))]

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
        self.assertEqual(self.lib.action_family_f6_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual(bytes(d.body), bytes(BODY_BYTES))
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_count, d.dependency_bytes),
                         (4934, 4934, 0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 4934)

    def test_every_body_byte_is_preserved_in_place(self):
        for seed in (7, 131, 250):
            body = body_fixture(seed=seed)
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_f6_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual(bytes(d.body), body)
        # first and last bytes, each bit independently
        for index in (0, 1, 2, 4932, 4933):
            for bit in range(8):
                body = bytearray(BODY_BYTES)
                body[index] = 1 << bit
                raw, d = storage(bytes(body)), Decoded()
                self.assertEqual(self.lib.action_family_f6_decode(raw, len(body), C.byref(d)), OK)
                self.assertEqual(bytes(d.body), bytes(body))

    def test_no_loader_nul_or_count_requirement(self):
        for value in (0x00, 0x01, 0x7f, 0x80, 0xff):
            body = bytes([value]) * BODY_BYTES
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_f6_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual(bytes(d.body), body)
            self.assertEqual(d.body_bytes, 4934)

    def test_dependency_view_and_count_width(self):
        for count in (0, 1, 9, 255, 256, 257, 65535, 65536, 65537):
            raw, d = storage(body_fixture(tail=count)), Decoded()
            self.assertEqual(self.lib.action_family_f6_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.body_bytes, d.available_body_bytes),
                             (count, count * 16, 4934, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 4934)
            if count:
                raw[4934] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[4934])

    def test_body_length(self):
        for count in (0, 1, 256, 65536):
            raw = storage(body_fixture(tail=count))
            n = C.c_size_t(123)
            self.assertEqual(self.lib.action_family_f6_body_length(raw, len(raw), C.byref(n)), OK)
            self.assertEqual(n.value, 4934)

    def test_every_short_body_is_atomic(self):
        for n in range(BODY_BYTES):
            self.assert_rejected(bytes(n), BODY)

    def test_just_below_and_at_minimum(self):
        self.assert_rejected(bytes(4933), BODY)
        raw = storage(bytes(4934))
        n = C.c_size_t()
        self.assertEqual(self.lib.action_family_f6_body_length(raw, 4934, C.byref(n)), OK)
        self.assertEqual(n.value, 4934)

    def test_ragged_tails_are_atomic(self):
        for n in tuple(range(1, 41)) + (255, 257, 4079, 4081, 4095, 4097, 65537):
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_tail_modulus_boundaries(self):
        # multiples of 16 pass on both sides of 4096 and 2**16 rows; one byte off fails
        for n in (4080, 4096, 4112, 16 * 255, 16 * 256, 16 * 65536):
            raw, d = storage(body_fixture() + bytes(n)), Decoded()
            self.assertEqual(self.lib.action_family_f6_decode(raw, 4934 + n, C.byref(d)), OK)
            self.assertEqual(d.dependency_count, n // 16)
            self.assert_rejected(body_fixture() + bytes(n + 1), TAIL)
            self.assert_rejected(body_fixture() + bytes(n + 15), TAIL)

    def test_constructor_entire_allocation(self):
        body = body_fixture(tail=2)
        raw, out = storage(body), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_f6_construct(raw, len(body), 50, 0xf60001, C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), body[:4934])
        self.assertEqual((out.payload_offset_before, out.payload_offset_after, out.result_slot_handle,
                          out.allocation_bytes, out.raw_type, out.runtime_type),
                         (50, 50 + 0x1346, 0xf60001, 4934, 0xf6, 0xf6))
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes, out.dependency_count,
                          out.dependency_bytes), (4934, 4966, 2, 32))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 4934)

    def test_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xffffecba, 0xffffecbb, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_f6_construct(raw, 4934, offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + 0x1346) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_f6_construct(raw, 4934, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        for out, call in self.calls(None, 4934):
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            self.assertEqual(call(out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        raw = storage(body_fixture())
        self.assertEqual(self.lib.action_family_f6_decode(raw, 4934, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_f6_body_length(raw, 4934, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_f6_construct(raw, 4934, 0, 1, None), ARGUMENT)

    def test_wrapped_input_spans_are_atomic(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        for ptr, length in ((C.cast(huge, C.POINTER(C.c_uint8)), 4934), (raw, huge)):
            for out, call in self.calls(ptr, length):
                C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
                self.assertEqual(call(out), BOUNDS)
                self.assertEqual(bytes(out), before)

    def test_wrapped_output_spans(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        self.assertEqual(self.lib.action_family_f6_decode(raw, 4934, C.cast(huge, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_f6_body_length(raw, 4934, C.cast(huge, C.POINTER(C.c_size_t))), BOUNDS)
        self.assertEqual(self.lib.action_family_f6_construct(raw, 4934, 0, 1, C.cast(huge, C.POINTER(Constructed))), BOUNDS)

    def test_overlap_and_adjacency(self):
        n = BODY_BYTES
        for kind, func, extra in ((Decoded, self.lib.action_family_f6_decode, ()),
                                 (C.c_size_t, self.lib.action_family_f6_body_length, ()),
                                 (Constructed, self.lib.action_family_f6_construct, (50, 1))):
            for delta in (-(n - 1), -1, 0, 1, C.sizeof(kind) - 1):
                backing = (C.c_uint8 * (n * 2 + C.sizeof(kind)))()
                C.memset(backing, 0xa5, len(backing)); before = bytes(backing)
                out = C.cast(C.addressof(backing) + n, C.POINTER(kind))
                raw = C.cast(C.addressof(out.contents) + delta, C.POINTER(C.c_uint8))
                self.assertEqual(func(raw, n, *extra, out), OVERLAP)
                self.assertEqual(bytes(backing), before)
            for after in (True, False):
                backing = (C.c_uint8 * (n + C.sizeof(kind)))()
                raw_address = C.addressof(backing) + (C.sizeof(kind) if after else 0)
                out_address = C.addressof(backing) + (0 if after else n)
                raw = C.cast(raw_address, C.POINTER(C.c_uint8))
                C.memmove(raw, body_fixture(), n)
                out = C.cast(out_address, C.POINTER(kind))
                self.assertEqual(func(raw, n, *extra, out), OK)


if __name__ == '__main__':
    unittest.main()
