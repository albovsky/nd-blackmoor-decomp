"""Fixtures for raw 0x76's fixed 575-byte body and successful allocation model.

The original inline loader arm (0x40dff4) allocates 0x23f bytes and copies 0x8f
DWORDs, one WORD and one BYTE without examining any body field. No lifecycle,
dependency evaluation or gameplay assertions are made here.
Scratch builds go to a unique directory under /private/tmp.
"""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
BODY = 575
BODY_BYTES = OBJECT_BYTES = BODY
WORD_COUNT = BODY // 2   # 287 little-endian words at body+0..573; byte_574 is the 575th byte
OK, ARGUMENT, BODY_ERR, TAIL, BOUNDS, OVERLAP = range(6)


class Decoded(C.Structure):
    _fields_ = [('word', C.c_uint16 * WORD_COUNT), ('byte_574', C.c_uint8),
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


def body_fixture(word_0=0x1234, tail=0, seed=7):
    # Deliberately distinct fields, high bits and unterminated byte spans:
    # the original loader is a fixed copy, with no body count or NUL scan.
    words = [word_0] + [((i * 0x531 + seed) ^ 0x8100) & 0xffff
                        for i in range(1, WORD_COUNT)]
    return (struct.pack(f'<{WORD_COUNT}H', *words) + bytes([(seed * 29 + 3) & 255]) +
            bytes((i * 19 + seed) & 255 for i in range(tail * 16)))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_76_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_76_decode.restype = C.c_int
    lib.action_family_76_body_length.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(C.c_size_t)]
    lib.action_family_76_body_length.restype = C.c_int
    lib.action_family_76_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
                                              C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_76_construct.restype = C.c_int
    return lib


class ActionFamily76Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-76.1.tests-', dir='/private/tmp')
        run = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_76.sh')],
                             env=dict(os.environ, BUILD_DIR=cls.directory.name),
                             capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily76.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length):
        return [(Decoded(), lambda out: self.lib.action_family_76_decode(raw, length, C.byref(out))),
                (C.c_size_t(), lambda out: self.lib.action_family_76_body_length(raw, length, C.byref(out))),
                (Constructed(), lambda out: self.lib.action_family_76_construct(raw, length, 50, 0x760001, C.byref(out)))]

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out, call in self.calls(raw, len(data)):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_body(self):
        raw = storage(bytes(BODY))
        d = Decoded()
        self.assertEqual(self.lib.action_family_76_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual(list(d.word), [0] * WORD_COUNT)
        self.assertEqual(d.byte_574, 0)
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_count, d.dependency_bytes),
                         (BODY, BODY, 0, 0))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + BODY)

    def test_every_word_and_little_endian(self):
        for seed in (131, 7, 255):
            body = body_fixture(seed=seed)
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_76_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual(tuple(d.word), struct.unpack(f'<{WORD_COUNT}H', body[:2 * WORD_COUNT]))
            self.assertEqual(d.byte_574, body[574])

    def test_signed_looking_maximum_words_are_not_counts(self):
        for word in (0, 1, 0x7fff, 0x8000, 0xffff):
            body = struct.pack('<H', word) * WORD_COUNT + bytes([word & 255])
            raw, d = storage(body), Decoded()
            self.assertEqual(self.lib.action_family_76_decode(raw, len(body), C.byref(d)), OK)
            self.assertEqual(tuple(d.word), (word,) * WORD_COUNT)
            self.assertEqual(d.byte_574, word & 255)
            self.assertEqual(d.body_bytes, BODY)

    def test_no_loader_nul_requirement(self):
        raw, d = storage(b'\xff' * BODY), Decoded()
        self.assertEqual(self.lib.action_family_76_decode(raw, BODY, C.byref(d)), OK)
        self.assertEqual(tuple(d.word), (0xffff,) * WORD_COUNT)
        self.assertEqual(d.byte_574, 0xff)

    def test_dependency_view_and_count_width(self):
        for count in (0, 1, 9, 255, 256, 257, 65535, 65536, 65537):
            raw, d = storage(body_fixture(tail=count)), Decoded()
            self.assertEqual(self.lib.action_family_76_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.body_bytes, d.available_body_bytes),
                             (count, count * 16, BODY, len(raw)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + BODY)
            if count:
                raw[BODY] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[BODY])

    def test_tail_modulus_boundaries(self):
        for tail in (8, 24, 4088, 4095, 4096, 4097, 4104, 65536 * 16 + 8):
            data = body_fixture() + bytes(tail)
            if tail % 16:
                self.assert_rejected(data, TAIL)
            else:
                raw, d = storage(data), Decoded()
                self.assertEqual(self.lib.action_family_76_decode(raw, len(data), C.byref(d)), OK)
                self.assertEqual(d.dependency_count, tail // 16)

    def test_body_length(self):
        for count in (0, 1, 256, 65536):
            raw = storage(body_fixture(tail=count))
            n = C.c_size_t(123)
            self.assertEqual(self.lib.action_family_76_body_length(raw, len(raw), C.byref(n)), OK)
            self.assertEqual(n.value, BODY)

    def test_observed_corpus_body_lengths(self):
        # Corpus raw body: 575 bytes, one record (resource 2529 action 7), no dependency tail.
        for length, rows in ((575, 0), (591, 1)):
            raw, d = storage(body_fixture(tail=rows)), Decoded()
            self.assertEqual(len(raw), length)
            self.assertEqual(self.lib.action_family_76_decode(raw, length, C.byref(d)), OK)
            self.assertEqual((d.body_bytes, d.dependency_count, d.dependency_bytes), (575, rows, 16 * rows))
            n = C.c_size_t()
            self.assertEqual(self.lib.action_family_76_body_length(raw, length, C.byref(n)), OK)
            self.assertEqual(n.value, 575)

    def test_trailing_odd_byte_is_neutral_data(self):
        for value in (0, 1, 0x7f, 0x80, 0xff):
            body = bytearray(body_fixture())
            body[574] = value
            raw, d = storage(bytes(body)), Decoded()
            self.assertEqual(self.lib.action_family_76_decode(raw, BODY, C.byref(d)), OK)
            self.assertEqual(d.byte_574, value)
            self.assertEqual(d.body_bytes, BODY)

    def test_every_short_body_is_atomic(self):
        for n in range(BODY):
            self.assert_rejected(bytes(n), BODY_ERR)

    def test_short_totals_that_are_row_multiples_are_atomic(self):
        self.assert_rejected(bytes(BODY - 14), BODY_ERR)
        self.assert_rejected(bytes(BODY - 16), BODY_ERR)

    def test_ragged_tails_are_atomic(self):
        for n in list(range(1, 41)) + [1023, 1025, 4095, 4097]:
            if n % 16:
                self.assert_rejected(body_fixture() + bytes(n), TAIL)

    def test_constructor_entire_allocation(self):
        body = body_fixture(tail=2)
        raw, out = storage(body), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_76_construct(raw, len(body), 50, 0x760001, C.byref(out)), OK)
        self.assertEqual(bytes(out.object_bytes), body[:BODY])
        self.assertEqual((out.payload_offset_before, out.payload_offset_after, out.result_slot_handle,
                          out.allocation_bytes, out.raw_type, out.runtime_type),
                         (50, 50 + BODY, 0x760001, BODY, 0x76, 0x76))
        self.assertEqual((out.body_bytes_consumed, out.available_body_bytes, out.dependency_count,
                          out.dependency_bytes), (BODY, BODY + 32, 2, 32))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + BODY)

    def test_offset_wrap(self):
        raw = storage(body_fixture())
        for offset in (0, 50, 0xffffffff - BODY + 1, 0xffffffff - BODY + 2, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_76_construct(raw, BODY, offset, 1, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + BODY) & 0xffffffff)

    def test_zero_handle_is_atomic(self):
        raw, out = storage(body_fixture()), Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_76_construct(raw, BODY, 50, 0, C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        for out, call in self.calls(None, BODY):
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            self.assertEqual(call(out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        raw = storage(body_fixture())
        self.assertEqual(self.lib.action_family_76_decode(raw, BODY, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_76_body_length(raw, BODY, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_76_construct(raw, BODY, 0, 1, None), ARGUMENT)

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
        self.assertEqual(self.lib.action_family_76_decode(raw, BODY, C.cast(huge, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_76_body_length(raw, BODY, C.cast(huge, C.POINTER(C.c_size_t))), BOUNDS)
        self.assertEqual(self.lib.action_family_76_construct(raw, BODY, 0, 1, C.cast(huge, C.POINTER(Constructed))), BOUNDS)

    def test_overlap_and_adjacency(self):
        for kind, func, extra in ((Decoded, self.lib.action_family_76_decode, ()),
                                 (C.c_size_t, self.lib.action_family_76_body_length, ()),
                                 (Constructed, self.lib.action_family_76_construct, (50, 1))):
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
