"""Fixtures for raw 0x0c's isolated body/copy model; no runtime semantics."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, TAIL, COUNT, BOUNDS, OVERLAP, CAPACITY, INDEX = range(9)


class Decoded(C.Structure):
    _fields_ = [('words', C.c_uint16 * 4), ('count_18', C.c_int16),
                ('records_18', C.POINTER(C.c_uint8)),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes', C.c_size_t),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


class Record18(C.Structure):
    _fields_ = [('words', C.c_uint16 * 9)]


class Constructed(C.Structure):
    _fields_ = [('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes_consumed', C.c_size_t),
                ('allocation_bytes', C.c_size_t), ('payload_offset_before', C.c_uint32),
                ('payload_offset_after', C.c_uint32), ('result_slot_handle', C.c_uint32),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def body_fixture(count=1, tail=0):
    prefix = struct.pack('<5H', 0x8001, 0x1234, 0xffff, 0x0102, count)
    records = b''.join(struct.pack('<9H', *((row * 101 + word * 13 + 1) & 0xffff
                                           for word in range(9))) for row in range(count))
    return prefix + records + bytes((i * 19 + 7) & 255 for i in range(tail * 16))


def load_native(path):
    lib = C.CDLL(str(path))
    raw_args = [C.POINTER(C.c_uint8), C.c_size_t]
    lib.action_family_0c_decode.argtypes = raw_args + [C.POINTER(Decoded)]
    lib.action_family_0c_body_length.argtypes = raw_args + [C.POINTER(C.c_size_t)]
    lib.action_family_0c_record18_at.argtypes = raw_args + [C.c_size_t, C.POINTER(Record18)]
    lib.action_family_0c_construct.argtypes = raw_args + [C.c_uint32, C.c_uint32,
        C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Constructed)]
    for name in ('decode', 'body_length', 'record18_at', 'construct'):
        getattr(lib, 'action_family_0c_' + name).restype = C.c_int
    return lib


class ActionFamily0cTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-0C.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        env = dict(os.environ, BUILD_DIR=cls.directory.name)
        run = subprocess.run([str(PROJECT / 'scripts/build_action_family_0c.sh')],
                             env=env, capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily0c.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def assert_rejected(self, data, status, length=None):
        raw = storage(data)
        image = storage(b'\xcd' * max(1, len(data)))
        n = len(data) if length is None else length
        outputs = [Decoded(), C.c_size_t(), Record18(), Constructed()]
        for out, name in zip(outputs, ('decode', 'body_length', 'record18_at', 'construct')):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            args = [raw, n]
            if name == 'record18_at': args += [0]
            if name == 'construct': args += [50, 1, image, len(image)]
            args += [C.byref(out)]
            self.assertEqual(getattr(self.lib, 'action_family_0c_' + name)(*args), status)
            self.assertEqual(bytes(out), before)
            self.assertEqual(bytes(image), b'\xcd' * len(image))
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_minimum_and_maximum_unwrapped_body(self):
        for count, expected in ((0, 10), (1, 28), (1819, 32752)):
            raw = storage(body_fixture(count))
            d, size = Decoded(), C.c_size_t()
            self.assertEqual(self.lib.action_family_0c_decode(raw, len(raw), C.byref(d)), OK)
            self.assertEqual(self.lib.action_family_0c_body_length(raw, len(raw), C.byref(size)), OK)
            self.assertEqual((d.count_18, d.body_bytes, size.value), (count, expected, expected))
            self.assertEqual((d.dependency_count, d.dependency_bytes), (0, 0))
            self.assertEqual((d.raw_type, d.runtime_type), (12, 12))

    def test_prefix_words_preserve_all_bits(self):
        raw = storage(body_fixture(0))
        d = Decoded()
        self.assertEqual(self.lib.action_family_0c_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual(list(d.words), [0x8001, 0x1234, 0xffff, 0x0102])

    def test_borrowed_table_and_dependency_views(self):
        raw = storage(body_fixture(3, 9))
        d = Decoded()
        self.assertEqual(self.lib.action_family_0c_decode(raw, len(raw), C.byref(d)), OK)
        self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_bytes,
                          d.dependency_count), (64, 208, 144, 9))
        self.assertEqual(pointer(d.records_18), C.addressof(raw) + 10)
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 64)
        raw[64] ^= 255
        self.assertEqual(d.dependency_records[0], raw[64])

    def test_record_words_and_index_validation(self):
        raw = storage(body_fixture(3))
        out = Record18()
        self.assertEqual(self.lib.action_family_0c_record18_at(raw, len(raw), 2, C.byref(out)), OK)
        self.assertEqual(list(out.words), [203, 216, 229, 242, 255, 268, 281, 294, 307])
        for index in (3, C.c_size_t(-1).value):
            before = bytes(out)
            self.assertEqual(self.lib.action_family_0c_record18_at(raw, len(raw), index, C.byref(out)), INDEX)
            self.assertEqual(bytes(out), before)

    def test_short_prefix_and_table_are_atomic(self):
        data = body_fixture(3)
        for n in range(64): self.assert_rejected(data[:n], BODY)

    def test_ragged_tail_is_atomic(self):
        for tail in range(1, 41):
            if tail % 16: self.assert_rejected(body_fixture(1) + bytes(tail), TAIL)

    def test_negative_and_wrapped_counts_are_safety_rejections(self):
        for count in (1820, 3641, 32767, 32768, 65535):
            data = bytearray(body_fixture(0))
            struct.pack_into('<H', data, 8, count)
            self.assert_rejected(bytes(data), COUNT)

    def test_constructor_copies_exact_allocation_and_cursor(self):
        raw = storage(body_fixture(3, 2))
        image = storage(b'\xcd' * 80)
        out = Constructed()
        self.assertEqual(self.lib.action_family_0c_construct(raw, len(raw), 50, 0x0c0001,
                         image, len(image), C.byref(out)), OK)
        self.assertEqual(bytes(image), bytes(raw)[:64] + b'\xcd' * 16)
        self.assertEqual((out.body_bytes_consumed, out.allocation_bytes, out.payload_offset_before,
                          out.payload_offset_after, out.result_slot_handle), (64, 64, 50, 114, 0x0c0001))
        self.assertEqual((out.raw_type, out.runtime_type), (12, 12))
        self.assertEqual((out.dependency_count, out.dependency_bytes, out.available_body_bytes), (2, 32, 96))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + 64)

    def test_unsigned_offset_wrap(self):
        raw = storage(body_fixture(0)); image = storage(bytes(10)); out = Constructed()
        for offset, expected in ((0, 10), (50, 60), (0xfffffff6, 0), (0xffffffff, 9)):
            self.assertEqual(self.lib.action_family_0c_construct(raw, 10, offset, 1, image, 10, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, expected)

    def test_capacity_and_zero_handle_are_atomic(self):
        raw = storage(body_fixture(1)); image = storage(b'\xcd' * 28); out = Constructed()
        C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
        for cap, handle, expected in ((27, 1, CAPACITY), (28, 0, ARGUMENT)):
            self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, handle, image, cap, C.byref(out)), expected)
            self.assertEqual(bytes(out), before); self.assertEqual(bytes(image), b'\xcd' * 28)

    def test_null_pointers_are_atomic(self):
        raw = storage(body_fixture(0)); image = storage(bytes(10)); out = Constructed()
        d, size, row = Decoded(), C.c_size_t(), Record18()
        for name, extra, result in (('decode', [], d), ('body_length', [], size), ('record18_at', [0], row)):
            call = getattr(self.lib, 'action_family_0c_' + name)
            self.assertEqual(call(None, 10, *extra, C.byref(result)), ARGUMENT)
            self.assertEqual(call(raw, 10, *extra, None), ARGUMENT)
        for p, obj, result in ((None, image, C.byref(out)), (raw, None, C.byref(out)), (raw, image, None)):
            self.assertEqual(self.lib.action_family_0c_construct(p, 10, 50, 1, obj, 10, result), ARGUMENT)

    def test_overlap_and_adjacent_spans(self):
        for cls, name, extra in ((Decoded, 'decode', []), (C.c_size_t, 'body_length', []),
                                 (Record18, 'record18_at', [0])):
            block = storage(bytes(C.sizeof(cls) + 28))
            out = C.cast(block, C.POINTER(cls))
            raw = C.cast(C.addressof(block) + 1, C.POINTER(C.c_uint8))
            before = bytes(block)
            self.assertEqual(getattr(self.lib, 'action_family_0c_' + name)(raw, 28, *extra, out), OVERLAP)
            self.assertEqual(bytes(block), before)
            raw = C.cast(C.addressof(block) + C.sizeof(cls), C.POINTER(C.c_uint8))
            C.memmove(raw, body_fixture(1), 28)
            self.assertEqual(getattr(self.lib, 'action_family_0c_' + name)(raw, 28, *extra, out), OK)
        raw = storage(body_fixture(1)); image = storage(bytes(28)); out = Constructed()
        self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, 1, raw, 28, C.byref(out)), OVERLAP)
        obj = C.cast(C.byref(out), C.POINTER(C.c_uint8))
        before = bytes(out)
        self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, 1, obj, C.sizeof(out), C.byref(out)), OVERLAP)
        self.assertEqual(bytes(out), before)
        result = C.cast(raw, C.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, 1, image, 28, result), OVERLAP)

    def test_wrapped_spans_reject_before_access(self):
        raw = storage(body_fixture(1)); image = storage(bytes(28)); out = Constructed(); d = Decoded()
        bad = C.cast(C.c_void_p(-1).value, C.POINTER(C.c_uint8))
        for p, n in ((bad, 28), (raw, C.c_size_t(-1).value)):
            self.assertEqual(self.lib.action_family_0c_decode(p, n, C.byref(d)), BOUNDS)
            self.assertEqual(self.lib.action_family_0c_construct(p, n, 50, 1, image, 28, C.byref(out)), BOUNDS)
        self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, 1, bad, 28, C.byref(out)), BOUNDS)
        self.assertEqual(self.lib.action_family_0c_construct(raw, 28, 50, 1, image, C.c_size_t(-1).value, C.byref(out)), BOUNDS)
        self.assertEqual(self.lib.action_family_0c_decode(raw, 28, C.cast(bad, C.POINTER(Decoded))), BOUNDS)


if __name__ == '__main__': unittest.main()
