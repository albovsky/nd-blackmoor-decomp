"""Fixtures for raw 0x20's fixed 8-byte body and successful allocation model.

The original arm (inline in loader 0x40b34a at 0x40bd12) calls malloc(8),
stores the pointer in the action slot (row+0x32), copies exactly two DWORDs
from the cursor and advances the consumed offset and the cursor by 8. It
examines no body field. No lifecycle, dependency evaluation or gameplay
assertions are made here. Scratch builds go to a unique directory under
/private/tmp.
"""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
BODY = 8
BODY_BYTES = OBJECT_BYTES = BODY
OK, ARGUMENT, BODY_ERR, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('dword_0', C.c_uint32), ('dword_4', C.c_uint32),
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


def body_fixture(dword_0=0x12345678, dword_4=0x9abcdef0, tail=0, seed=7):
    # The original loader is a fixed two-DWORD copy: no count, signedness or NUL scan.
    return (struct.pack('<II', dword_0, dword_4) +
            bytes((i * 19 + seed) & 255 for i in range(tail * 16)))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_20_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_20_decode.restype = C.c_int
    lib.action_family_20_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_20_body_length.restype = C.c_int
    lib.action_family_20_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
                                              C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_20_construct.restype = C.c_int
    return lib


class ActionFamily20Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-20.1.tests-', dir='/private/tmp')
        run = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_20.sh')],
                             env=dict(os.environ, BUILD_DIR=cls.directory.name),
                             capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily20.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length):
        return [(Decoded(), lambda out: self.lib.action_family_20_decode(raw, length, C.byref(out))),
                (C.c_size_t(), lambda out: self.lib.action_family_20_body_length(raw, length, C.byref(out))),
                (Constructed(), lambda out: self.lib.action_family_20_construct(raw, length, 50, 0x200001, C.byref(out)))]

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out, call in self.calls(raw, len(data)):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_constants(self):
        # arm 0x40bd12: push 8 / call malloc; two DWORD MOV pairs; ADD 8 twice.
        self.assertEqual((BODY, OBJECT_BYTES), (8, 8))

    def test_minimum_body(self):
        raw = storage(bytes(BODY))
        d = Decoded()
        self.assertEqual(self.lib.action_family_20_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual((d.dword_0, d.dword_4), (0, 0))
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_count, d.dependency_bytes),
                         (BODY, BODY, 0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + BODY)

    def test_little_endian(self):
        raw, d = storage(bytes([1, 2, 3, 4, 5, 6, 7, 8])), Decoded()
        self.assertEqual(self.lib.action_family_20_decode(raw, 8, C.byref(d)), OK)
        self.assertEqual((d.dword_0, d.dword_4), (0x04030201, 0x08070605))

    def test_every_byte_position_and_value(self):
        # Each of the 8 body bytes lands in exactly its own place; no other byte moves.
        for position in range(BODY):
            for value in range(256):
                body = bytearray(0x5a for _ in range(BODY))
                body[position] = value
                raw, d, c = storage(bytes(body)), Decoded(), Constructed()
                self.assertEqual(self.lib.action_family_20_decode(raw, BODY, C.byref(d)), OK)
                self.assertEqual((d.dword_0, d.dword_4), struct.unpack('<II', bytes(body)))
                self.assertEqual(self.lib.action_family_20_construct(raw, BODY, 50, 1, C.byref(c)), OK)
                self.assertEqual(bytes(c.object_bytes), bytes(body))

    def test_dword_boundary_values_are_data_not_counts(self):
        values = (0, 1, 0x7fff, 0x8000, 0xffff, 0x10000, 0x7fffffff, 0x80000000, 0xffffffff)
        for a in values:
            for b in values:
                raw, d, c, n = storage(struct.pack('<II', a, b)), Decoded(), Constructed(), C.c_size_t()
                self.assertEqual(self.lib.action_family_20_decode(raw, 8, C.byref(d)), OK)
                self.assertEqual((d.dword_0, d.dword_4, d.body_bytes), (a, b, BODY))
                self.assertEqual(self.lib.action_family_20_body_length(raw, 8, C.byref(n)), OK)
                self.assertEqual(n.value, BODY)
                self.assertEqual(self.lib.action_family_20_construct(raw, 8, 50, 1, C.byref(c)), OK)
                self.assertEqual(bytes(c.object_bytes), struct.pack('<II', a, b))

    def test_no_loader_nul_requirement(self):
        raw, d = storage(b'\xff' * BODY), Decoded()
        self.assertEqual(self.lib.action_family_20_decode(raw, BODY, C.byref(d)), OK)
        self.assertEqual((d.dword_0, d.dword_4), (0xffffffff, 0xffffffff))

    def test_dependency_view_and_count_width(self):
        for count in (0, 1, 9, 255, 256, 257, 65535, 65536, 65537):
            raw, d = storage(body_fixture(tail=count)), Decoded()
            self.assertEqual(self.lib.action_family_20_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.body_bytes, d.available_body_bytes),
                             (count, count * 16, BODY, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + BODY)
            if count:
                raw[BODY] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[BODY])

    def test_tail_modulus_boundaries(self):
        # 4095/4096/4097 and 8-byte multiples that are not 16-byte multiples.
        for tail in (8, 24, 4088, 4095, 4096, 4097, 4104, 65536 * 16 + 8):
            data = body_fixture() + bytes(tail)
            if tail % 16:
                self.assert_rejected(data, TAIL)
            else:
                raw, d = storage(data), Decoded()
                self.assertEqual(self.lib.action_family_20_decode(raw, len(data), C.byref(d)), OK)
                self.assertEqual(d.dependency_count, tail // 16)

    def test_body_length(self):
        for count in (0, 1, 256, 65536):
            raw = storage(body_fixture(tail=count))
            n = C.c_size_t(123)
            self.assertEqual(self.lib.action_family_20_body_length(raw, len(raw), C.byref(n)), OK)
            self.assertEqual(n.value, BODY)

    def test_observed_corpus_body_lengths(self):
        # Corpus raw bodies: both records are exactly 8 bytes (no dependency tail);
        # the 24-byte shape (one tail row) is synthetic and proves the 16-byte split.
        for length, rows in ((8, 0), (24, 1)):
            raw, d = storage(body_fixture(tail=rows)), Decoded()
            self.assertEqual(len(raw), length)
            self.assertEqual(self.lib.action_family_20_decode(raw, length, C.byref(d)), OK)
            self.assertEqual((d.body_bytes, d.dependency_count, d.dependency_bytes), (8, rows, 16 * rows))
            n = C.c_size_t()
            self.assertEqual(self.lib.action_family_20_body_length(raw, length, C.byref(n)), OK)
            self.assertEqual(n.value, 8)

    def test_every_short_body_is_atomic(self):
        for n in range(BODY):
            self.assert_rejected(bytes(n), BODY_ERR)

    def test_ragged_tails_are_atomic(self):
        for n in list(range(1, 41)) + [1023, 1025, 4095, 4097]:
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_constructor_entire_allocation(self):
        body = body_fixture(0xdeadbeef, 0x0badf00d, tail=2)
        raw, out = storage(body), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_20_construct(raw, len(body), 50, 0x200001, C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), body[:BODY])
        self.assertEqual((out.payload_offset_before, out.payload_offset_after, out.result_slot_handle,
                          out.allocation_bytes, out.raw_type, out.runtime_type),
                         (50, 50 + BODY, 0x200001, BODY, 0x20, 0x20))
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes, out.dependency_count,
                          out.dependency_bytes), (BODY, BODY + 32, 2, 32))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + BODY)

    def test_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xffffffff - BODY + 1, 0xffffffff - BODY + 2, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_20_construct(raw, BODY, offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + BODY) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_20_construct(raw, BODY, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        for out, call in self.calls(None, BODY):
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            self.assertEqual(call(out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        raw = storage(body_fixture())
        self.assertEqual(self.lib.action_family_20_decode(raw, BODY, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_20_body_length(raw, BODY, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_20_construct(raw, BODY, 0, 1, None), ARGUMENT)

    def test_wrapped_input_spans_are_atomic(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        for ptr, length in ((C.cast(huge, C.POINTER(C.c_uint8)), BODY), (raw, huge)):
            for out, call in self.calls(ptr, length):
                C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
                self.assertEqual(call(out), BOUNDS)
                self.assertEqual(bytes(out), before)

    def test_wrapped_output_spans(self):
        raw = storage(body_fixture())
        huge = C.c_size_t(-1).value
        self.assertEqual(self.lib.action_family_20_decode(raw, BODY, C.cast(huge, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_20_body_length(raw, BODY, C.cast(huge, C.POINTER(C.c_size_t))), BOUNDS)
        self.assertEqual(self.lib.action_family_20_construct(raw, BODY, 0, 1, C.cast(huge, C.POINTER(Constructed))), BOUNDS)

    def test_overlap_and_adjacency(self):
        for kind, func, extra in ((Decoded, self.lib.action_family_20_decode, ()),
                                 (C.c_size_t, self.lib.action_family_20_body_length, ()),
                                 (Constructed, self.lib.action_family_20_construct, (50, 1))):
            for delta in (-(BODY - 1), -1, 0, 1, C.sizeof(kind) - 1):
                backing = (C.c_uint8 * (BODY * 2 + C.sizeof(kind)))()
                C.memset(backing, 0xa5, len(backing)); before = bytes(backing)
                out = C.cast(C.addressof(backing) + BODY, C.POINTER(kind))
                raw = C.cast(C.addressof(out.contents) + delta, C.POINTER(C.c_uint8))
                self.assertEqual(func(raw, BODY, *extra, out), OVERLAP)
                self.assertEqual(bytes(backing), before)
            for after in (True, False):
                backing = (C.c_uint8 * (BODY + C.sizeof(kind)))()
                raw_address = C.addressof(backing) + (C.sizeof(kind) if after else 0)
                out_address = C.addressof(backing) + (0 if after else BODY)
                raw = C.cast(raw_address, C.POINTER(C.c_uint8))
                C.memmove(raw, body_fixture(), BODY)
                out = C.cast(out_address, C.POINTER(kind))
                self.assertEqual(func(raw, BODY, *extra, out), OK)


if __name__ == '__main__':
    unittest.main()
