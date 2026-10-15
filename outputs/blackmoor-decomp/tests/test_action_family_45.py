#!/usr/bin/env python3
"""Synthetic fixtures for the bounded raw45 decoder and inline-loader model."""
import ctypes as C
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, COUNT, TAIL, BOUNDS, OVERLAP = range(7)
PREFIX, MAX_COUNT, MAX_OBJECT = 196, 10, 236


class Entry(C.Structure):
    _fields_ = [('word_0', C.c_uint16), ('word_1', C.c_uint16)]


class Decoded(C.Structure):
    _fields_ = [('raw_type', C.c_uint8), ('runtime_type', C.c_uint8),
                ('words', C.c_uint16 * 97), ('entry_count', C.c_uint16),
                ('entries', Entry * MAX_COUNT), ('dependency_records', C.c_void_p),
                ('dependency_count', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('body_bytes', C.c_size_t), ('dependency_bytes', C.c_size_t)]


class Constructed(C.Structure):
    _fields_ = [('object_bytes', C.c_uint8 * MAX_OBJECT),
                ('dependency_records', C.c_void_p), ('dependency_count', C.c_size_t),
                ('dependency_bytes', C.c_size_t), ('available_body_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t), ('payload_offset_before', C.c_uint32),
                ('payload_offset_after', C.c_uint32), ('output_handle', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('output_allocation_bytes', C.c_uint32)]


def storage(data):
    return (C.c_uint8 * max(1, len(data)))(*data)


def body_fixture(count=0, tail=0, salt=7):
    words = [(i * 997 + salt * 257) & 65535 for i in range(97)]
    entries = [(i * 193 + salt * 113) & 65535 for i in range(max(0, count) * 2)]
    return (struct.pack('<97Hh', *words, count) +
            struct.pack('<' + 'H' * len(entries), *entries) +
            bytes((i * 19 + salt) & 255 for i in range(tail * 16)))


def load_native(path):
    lib = C.CDLL(str(path))
    lib.action_family_45_decode.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Decoded)]
    lib.action_family_45_decode.restype = C.c_int
    lib.action_family_45_construct.argtypes = [C.POINTER(C.c_uint8), C.c_size_t,
        C.c_uint32, C.c_uint32, C.POINTER(Constructed)]
    lib.action_family_45_construct.restype = C.c_int
    return lib


class ActionFamily45Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-45.1.tests-',
            dir=PROJECT.parents[1] / 'work/analysis/slices')
        path = Path(cls.directory.name) / 'libactionfamily45.dylib'
        run = subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
            '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC',
            '-dynamiclib', str(PROJECT / 'src/action_family_45.c'), '-o', str(path)],
            capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(path)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def invoke(self, cls, raw, length, out, offset=50, handle=0x450001):
        if cls is Decoded:
            return self.lib.action_family_45_decode(raw, length, out)
        return self.lib.action_family_45_construct(raw, length, offset, handle, out)

    def assert_rejected(self, data, status):
        raw = storage(data)
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(self.invoke(cls, raw, len(data), C.byref(out)), status)
            self.assertEqual(bytes(out), before)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def test_all_valid_counts_and_neutral_fields(self):
        for count in range(11):
            for tail in (0, 1, 9):
                data = body_fixture(count, tail)
                raw, d = storage(data), Decoded()
                self.assertEqual(self.invoke(Decoded, raw, len(data), C.byref(d)), OK)
                typed = 196 + 4 * count
                self.assertEqual((d.raw_type, d.runtime_type, d.entry_count), (0x45, 0x45, count))
                self.assertEqual(list(d.words), list(struct.unpack_from('<97H', data)))
                for i in range(count):
                    self.assertEqual((d.entries[i].word_0, d.entries[i].word_1),
                                     struct.unpack_from('<HH', data, 196 + i * 4))
                self.assertEqual(bytes(d.entries)[count * 4:], bytes((10 - count) * 4))
                self.assertEqual((d.body_bytes, d.available_body_bytes, d.dependency_count,
                    d.dependency_bytes, d.dependency_records),
                    (typed, len(data), tail, tail * 16, C.addressof(raw) + typed))

    def test_constructor_whole_object_and_wrap(self):
        for count in range(11):
            data = body_fixture(count, 2, 193)
            raw = storage(data)
            typed = 196 + 4 * count
            for offset in (0, 50, 0xfffffffe, 0xffffffff):
                out = Constructed()
                C.memset(C.byref(out), 0xa5, C.sizeof(out))
                self.assertEqual(self.invoke(Constructed, raw, len(data), C.byref(out), offset), OK)
                self.assertEqual(bytes(out.object_bytes)[:typed], data[:typed])
                self.assertEqual(bytes(out.object_bytes)[typed:], bytes(236 - typed))
                self.assertEqual((out.body_bytes_consumed, out.payload_offset_before,
                    out.payload_offset_after, out.output_allocation_bytes, out.output_handle,
                    out.result_slot_handle), (typed, offset, (offset + typed) & 0xffffffff,
                                              typed, 0x450001, 0x450001))
                self.assertEqual((out.dependency_records, out.dependency_count, out.dependency_bytes,
                    out.available_body_bytes), (C.addressof(raw) + typed, 2, 32, len(data)))

    def test_all_prefix_truncations_are_atomic(self):
        for n in range(196):
            self.assert_rejected(body_fixture()[:n], BODY)

    def test_counted_body_truncations_are_atomic(self):
        for count in range(1, 11):
            data = body_fixture(count)
            for n in range(196, len(data)):
                self.assert_rejected(data[:n], BODY)

    def test_negative_overflow_and_large_counts_are_atomic(self):
        for bits in (11, 12, 49, 8191, 8192, 0x7fff, 0x8000, 0xffce, 0xffff):
            data = body_fixture()[:194] + struct.pack('<H', bits) + bytes(64)
            self.assert_rejected(data, COUNT)

    def test_partial_tails_are_atomic(self):
        for count in (0, 1, 10):
            for tail in range(1, 41):
                if tail % 16:
                    self.assert_rejected(body_fixture(count) + bytes(tail), TAIL)

    def test_borrowed_dependency_and_large_tail(self):
        data = body_fixture(10, 4096)
        raw, d = storage(data), Decoded()
        self.assertEqual(self.invoke(Decoded, raw, len(data), C.byref(d)), OK)
        self.assertEqual((d.dependency_count, d.dependency_bytes), (4096, 65536))
        raw[236] ^= 0xff
        self.assertEqual(C.c_uint8.from_address(d.dependency_records).value, raw[236])

    def test_null_and_zero_handle_are_atomic(self):
        raw = storage(body_fixture())
        for cls in (Decoded, Constructed):
            out = cls(); C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            self.assertEqual(self.invoke(cls, None, 196, C.byref(out)), ARGUMENT)
            self.assertEqual(bytes(out), before)
            self.assertEqual(self.invoke(cls, raw, 196, None), ARGUMENT)
        out = Constructed(); C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
        self.assertEqual(self.invoke(Constructed, raw, 196, C.byref(out), handle=0), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_overlap_both_directions_is_atomic(self):
        for cls in (Decoded, Constructed):
            for raw_at, out_at in ((0, 0), (1, 0), (0, 1), (C.sizeof(cls) - 1, 0), (0, 195)):
                block = (C.c_uint8 * (C.sizeof(cls) + 400))()
                C.memset(block, 0xa5, C.sizeof(block)); before = bytes(block)
                raw = C.cast(C.addressof(block) + raw_at, C.POINTER(C.c_uint8))
                out = C.cast(C.addressof(block) + out_at, C.POINTER(cls))
                self.assertEqual(self.invoke(cls, raw, 196, out), OVERLAP)
                self.assertEqual(bytes(block), before)

    def test_adjacent_spans_allowed(self):
        for cls in (Decoded, Constructed):
            for raw_at, out_at in ((C.sizeof(cls), 0), (0, 200)):
                block = (C.c_uint8 * (C.sizeof(cls) + 400))()
                C.memmove(C.addressof(block) + raw_at, body_fixture(), 196)
                raw = C.cast(C.addressof(block) + raw_at, C.POINTER(C.c_uint8))
                out = C.cast(C.addressof(block) + out_at, C.POINTER(cls))
                self.assertEqual(self.invoke(cls, raw, 196, out), OK)

    def test_wrapped_spans_reject_without_access(self):
        raw = storage(body_fixture())
        bad_raw = C.cast(C.c_void_p(-1), C.POINTER(C.c_uint8))
        for cls in (Decoded, Constructed):
            out = cls(); C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            for p, n in ((bad_raw, 196), (raw, C.c_size_t(-1).value)):
                self.assertEqual(self.invoke(cls, p, n, C.byref(out)), BOUNDS)
                self.assertEqual(bytes(out), before)
            bad_out = C.cast(C.c_void_p(-1), C.POINTER(cls))
            self.assertEqual(self.invoke(cls, raw, 196, bad_out), BOUNDS)


if __name__ == '__main__':
    unittest.main()
