"""Fixtures for raw 0x2d's count-driven body and its successful allocation model.

FUN_004cd243 (called from loader arm 0x40c0e0 with this = 0x63821d) copies a
39-byte header, then entry_count 49-byte entries each followed by
record35_count * 35 bytes, then record34_count * 34 bytes. Both counts and the
per-entry count are signed 16-bit words. No lifecycle, dependency evaluation or
gameplay assertions are made here. Scratch builds go to a unique directory
under /private/tmp.
"""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
HEADER, ENTRY_FILE, ENTRY_OBJECT, REC35, REC34 = 39, 49, 53, 35, 34
OK, ARGUMENT, BODY_ERR, COUNT, TAIL, BOUNDS, OVERLAP, CAPACITY, INDEX = range(9)


class Decoded(C.Structure):
    _fields_ = [('name', C.c_uint8 * 33), ('word_21', C.c_uint16),
                ('entry_count', C.c_int16), ('record34_count', C.c_int16),
                ('entries', C.POINTER(C.c_uint8)), ('entries_bytes', C.c_size_t),
                ('record35_total', C.c_size_t),
                ('records_34', C.POINTER(C.c_uint8)), ('records_34_bytes', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t), ('body_bytes', C.c_size_t),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


class Entry(C.Structure):
    _fields_ = [('name', C.c_uint8 * 33), ('word_21', C.c_uint16), ('word_23', C.c_uint16),
                ('dword_25', C.c_uint32), ('dword_29', C.c_uint32), ('word_2d', C.c_uint16),
                ('record35_count', C.c_int16), ('records_35', C.POINTER(C.c_uint8)),
                ('records_35_bytes', C.c_size_t)]


class Record35(C.Structure):
    _fields_ = [('bytes', C.c_uint8 * REC35)]


class Record34(C.Structure):
    _fields_ = [('bytes', C.c_uint8 * REC34)]


class Constructed(C.Structure):
    _fields_ = [('allocation_count', C.c_size_t), ('image_bytes', C.c_size_t),
                ('body_bytes_consumed', C.c_size_t),
                ('dependency_records', C.POINTER(C.c_uint8)),
                ('dependency_count', C.c_size_t), ('dependency_bytes', C.c_size_t),
                ('available_body_bytes', C.c_size_t),
                ('payload_offset_before', C.c_uint32), ('payload_offset_after', C.c_uint32),
                ('result_slot_handle', C.c_uint32), ('owner_header_handle', C.c_uint32),
                ('owner_entry_table_handle', C.c_uint32), ('owner_group_handle', C.c_uint32),
                ('owner_action_index', C.c_int32),
                ('raw_type', C.c_uint8), ('runtime_type', C.c_uint8)]


def storage(data):
    return (C.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')


def pointer(value):
    return C.cast(value, C.c_void_p).value


def typed_length(ns, groups):
    return HEADER + sum(ENTRY_FILE + REC35 * n for n in ns) + REC34 * groups


def make_body(ns, groups=0, *, word21=0x1234, seed=7, tail=0, entry_count=None, group_count=None):
    """Deliberately distinct bytes everywhere; spans are never NUL-terminated."""
    body = bytearray(((i * 13 + seed) | 1) & 255 for i in range(33))
    body += struct.pack('<Hhh', word21, len(ns) if entry_count is None else entry_count,
                        groups if group_count is None else group_count)
    for i, n in enumerate(ns):
        body += bytes(((i * 29 + j * 7 + seed) | 1) & 255 for j in range(33))
        body += struct.pack('<HHIIHh', (0x8000 + i * 3) & 0xffff, 0xff00 | i & 255,
                            0x80000001 + i, 0xfffffffe - i, 0x7fff - i, n)
        body += bytes((i * 41 + j * 5 + seed + 1) & 255 for j in range(REC35 * max(n, 0)))
    body += bytes((j * 3 + seed + 2) & 255 for j in range(REC34 * max(groups, 0)))
    body += bytes((i * 19 + seed) & 255 for i in range(tail * 16))
    return bytes(body)


def expected_image(body, handles):
    entries, groups = struct.unpack_from('<hh', body, 0x23)
    image, subs, cur = bytearray(body[:HEADER]), [], HEADER
    table = bytearray()
    for i in range(entries):
        n = struct.unpack_from('<h', body, cur + 0x2f)[0]
        table += body[cur:cur + ENTRY_FILE] + struct.pack('<I', handles[2 + i])
        subs.append(body[cur + ENTRY_FILE:cur + ENTRY_FILE + REC35 * n])
        cur += ENTRY_FILE + REC35 * n
    return bytes(image + table + b''.join(subs) + body[cur:cur + REC34 * groups])


def load_native(path):
    lib = C.CDLL(str(path))
    p8, sz = C.POINTER(C.c_uint8), C.c_size_t
    lib.action_family_2d_decode.argtypes = [p8, sz, C.POINTER(Decoded)]
    lib.action_family_2d_body_length.argtypes = [p8, sz, C.POINTER(sz)]
    lib.action_family_2d_entry_at.argtypes = [p8, sz, sz, C.POINTER(Entry)]
    lib.action_family_2d_record35_at.argtypes = [p8, sz, sz, sz, C.POINTER(Record35)]
    lib.action_family_2d_record34_at.argtypes = [p8, sz, sz, C.POINTER(Record34)]
    lib.action_family_2d_construct.argtypes = [p8, sz, C.c_uint32, C.c_int16, C.POINTER(C.c_uint32), sz,
                                              p8, sz, C.POINTER(Constructed)]
    for name in ('decode', 'body_length', 'entry_at', 'record35_at', 'record34_at', 'construct'):
        getattr(lib, f'action_family_2d_{name}').restype = C.c_int
    return lib


def handle_array(count, base=0x6a0000):
    return (C.c_uint32 * max(1, count))(*[base + 0x40 * k + 1 for k in range(count)])


class ActionFamily2DTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix='A-2D.1.tests-', dir='/private/tmp')
        prebuilt = os.environ.get('A2D_NATIVE_LIBRARY')   # mutation checks load a compiled mutant
        if prebuilt:
            cls.lib = load_native(prebuilt)
            return
        run = subprocess.run([str(PROJECT / 'scripts/build_action_family_2d.sh')],
                             env=dict(os.environ, BUILD_DIR=cls.directory.name),
                             capture_output=True, text=True)
        if run.returncode:
            cls.directory.cleanup()
            raise RuntimeError('fixture build failed: ' + run.stderr)
        cls.lib = load_native(Path(cls.directory.name) / 'libactionfamily2d.dylib')

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def calls(self, raw, length):
        big = (C.c_uint8 * 4096)()
        return [(Decoded(), lambda out: self.lib.action_family_2d_decode(raw, length, C.byref(out))),
                (C.c_size_t(), lambda out: self.lib.action_family_2d_body_length(raw, length, C.byref(out))),
                (Entry(), lambda out: self.lib.action_family_2d_entry_at(raw, length, 0, C.byref(out))),
                (Record35(), lambda out: self.lib.action_family_2d_record35_at(raw, length, 0, 0, C.byref(out))),
                (Record34(), lambda out: self.lib.action_family_2d_record34_at(raw, length, 0, C.byref(out))),
                (Constructed(), lambda out: self.lib.action_family_2d_construct(
                    raw, length, 50, 3, handle_array(8), 8, big, len(big), C.byref(out)))]

    def assert_rejected(self, data, status):
        raw = storage(data)
        for out, call in self.calls(raw, len(data)):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), status, type(out).__name__)
            self.assertEqual(bytes(out), before, type(out).__name__)
        self.assertEqual(bytes(raw)[:len(data)], data)

    def decode_ok(self, body):
        raw, d = storage(body), Decoded()
        self.assertEqual(self.lib.action_family_2d_decode(raw, len(body), C.byref(d)), OK)
        return raw, d

    def test_constants(self):
        self.assertEqual((HEADER, ENTRY_FILE, ENTRY_OBJECT, REC35, REC34), (0x27, 0x31, 0x35, 0x23, 0x22))

    def test_minimum_header_only_body(self):
        body = make_body([], 0)
        self.assertEqual(len(body), 39)
        raw, d = self.decode_ok(body)
        self.assertEqual((d.entry_count, d.record34_count, d.body_bytes, d.available_body_bytes,
                          d.dependency_count, d.dependency_bytes, d.entries_bytes, d.record35_total,
                          d.raw_type, d.runtime_type), (0, 0, 39, 39, 0, 0, 0, 0, 0x2d, 0x2d))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + 39)
        self.assertEqual(bytes(d.name), body[:33])
        self.assertEqual(d.word_21, 0x1234)

    def test_header_fields_and_borrowed_views(self):
        body = make_body([2, 0, 3], 4, word21=0xfedc)
        raw, d = self.decode_ok(body)
        self.assertEqual((d.word_21, d.entry_count, d.record34_count), (0xfedc, 3, 4))
        self.assertEqual((d.record35_total, d.entries_bytes, d.records_34_bytes),
                         (5, 3 * 49 + 5 * 35, 4 * 34))
        self.assertEqual(pointer(d.entries), C.addressof(raw) + 39)
        self.assertEqual(pointer(d.records_34), C.addressof(raw) + 39 + d.entries_bytes)
        self.assertEqual(d.body_bytes, typed_length([2, 0, 3], 4))
        self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + d.body_bytes)

    def test_name_span_needs_no_nul(self):
        for fill in (0x00, 0xff, 0x41):
            body = bytes([fill]) * 33 + make_body([1], 1)[33:]
            raw, d = self.decode_ok(body)
            self.assertEqual(bytes(d.name), bytes([fill]) * 33)

    def test_all_entry_fields_and_records(self):
        ns = [3, 0, 1, 4]
        body = make_body(ns, 2, seed=91)
        raw = storage(body)
        cur = 39
        for index, n in enumerate(ns):
            e = Entry()
            self.assertEqual(self.lib.action_family_2d_entry_at(raw, len(body), index, C.byref(e)), OK)
            self.assertEqual(bytes(e.name), body[cur:cur + 33])
            self.assertEqual((e.word_21, e.word_23, e.dword_25, e.dword_29, e.word_2d, e.record35_count),
                             struct.unpack_from('<HHIIHh', body, cur + 33))
            self.assertEqual(e.records_35_bytes, 35 * n)
            self.assertEqual(pointer(e.records_35), C.addressof(raw) + cur + 49)
            for r in range(n):
                rec = Record35()
                self.assertEqual(self.lib.action_family_2d_record35_at(raw, len(body), index, r, C.byref(rec)), OK)
                start = cur + 49 + 35 * r
                self.assertEqual(bytes(rec.bytes), body[start:start + 35])
            cur += 49 + 35 * n
        for r in range(2):
            rec = Record34()
            self.assertEqual(self.lib.action_family_2d_record34_at(raw, len(body), r, C.byref(rec)), OK)
            self.assertEqual(bytes(rec.bytes), body[cur + 34 * r:cur + 34 * r + 34])

    def test_accessor_index_errors_are_atomic(self):
        body = make_body([1, 0], 1)
        raw = storage(body)
        for call, kinds in ((lambda o: self.lib.action_family_2d_entry_at(raw, len(body), 2, C.byref(o)), Entry),
                            (lambda o: self.lib.action_family_2d_entry_at(raw, len(body), 2 ** 64 - 1, C.byref(o)), Entry),
                            (lambda o: self.lib.action_family_2d_record35_at(raw, len(body), 2, 0, C.byref(o)), Record35),
                            (lambda o: self.lib.action_family_2d_record35_at(raw, len(body), 0, 1, C.byref(o)), Record35),
                            (lambda o: self.lib.action_family_2d_record35_at(raw, len(body), 1, 0, C.byref(o)), Record35),
                            (lambda o: self.lib.action_family_2d_record34_at(raw, len(body), 1, C.byref(o)), Record34)):
            out = kinds()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), INDEX)
            self.assertEqual(bytes(out), before)

    def test_observed_corpus_shapes(self):
        # Raw body lengths seen in the corpus: 6793 (40 entries, 136 records, one 34-byte
        # record) twice, and 1144 (9 entries of 2 records, one 34-byte record).
        ns = ([3, 4, 3, 3, 4, 3, 4, 4, 3, 4, 3, 3, 3, 4, 4, 3, 3, 4, 3, 3] * 2)
        self.assertEqual((sum(ns), len(ns), typed_length(ns, 1)), (136, 40, 6793))
        raw, d = self.decode_ok(make_body(ns, 1))
        self.assertEqual((d.body_bytes, d.dependency_count, d.entry_count, d.record35_total), (6793, 0, 40, 136))
        self.assertEqual(typed_length([2] * 9, 1), 1144)
        raw, d = self.decode_ok(make_body([2] * 9, 1))
        self.assertEqual((d.body_bytes, d.dependency_count), (1144, 0))

    def test_maximum_counts(self):
        # entry_count = 32767 (empty entries), one 32767-record entry, 32767 34-byte records.
        for ns, groups in (([0] * 32767, 0), ([32767], 0), ([], 32767)):
            body = make_body(ns, groups)
            raw, d = self.decode_ok(body)
            self.assertEqual(d.body_bytes, len(body))
            n = C.c_size_t()
            self.assertEqual(self.lib.action_family_2d_body_length(raw, len(body), C.byref(n)), OK)
            self.assertEqual(n.value, len(body))

    def test_negative_and_sign_bit_counts_are_atomic(self):
        for bad in (-1, -2, -32768, 0x8000 - 0x10000):
            self.assert_rejected(make_body([1], 1, entry_count=bad), COUNT)
            self.assert_rejected(make_body([1], 1, group_count=bad), COUNT)
            self.assert_rejected(make_body([bad]), COUNT)
            self.assert_rejected(make_body([1, 2, bad], 1), COUNT)
        # header counts are rejected before an overlong body is considered
        self.assert_rejected(make_body([1], 1, entry_count=-1)[:39], COUNT)

    def test_counts_beyond_data_are_atomic(self):
        self.assert_rejected(make_body([1], 0, entry_count=2), BODY_ERR)
        self.assert_rejected(make_body([1], 0, group_count=1), BODY_ERR)
        self.assert_rejected(make_body([1], 1, entry_count=32767), BODY_ERR)
        self.assert_rejected(make_body([1], 1, group_count=32767), BODY_ERR)
        body = bytearray(make_body([1, 1], 1))
        struct.pack_into('<h', body, 39 + 0x2f, 5)       # entry 0 claims 5 records
        self.assert_rejected(bytes(body)[:39 + 49 + 5 * 35 + 49 + 35 + 34 - 1], BODY_ERR)
        body = bytearray(make_body([1, 1], 1))
        struct.pack_into('<h', body, 39 + 49 + 35 + 0x2f, 32767)
        self.assert_rejected(bytes(body), BODY_ERR)

    def test_every_short_prefix_is_atomic(self):
        for ns, groups in (([2, 0, 3], 2), ([], 0), ([0], 0)):
            body = make_body(ns, groups)
            for n in range(len(body)):
                self.assert_rejected(body[:n], BODY_ERR)

    def test_zero_length_and_header_cut(self):
        self.assert_rejected(b'', BODY_ERR)
        self.assert_rejected(bytes(38), BODY_ERR)

    def test_dependency_view_and_count_width(self):
        for count in (0, 1, 9, 255, 256, 257, 65535, 65536, 65537):
            body = make_body([1, 2], 1, tail=count)
            raw, d = self.decode_ok(body)
            base = typed_length([1, 2], 1)
            self.assertEqual((d.dependency_count, d.dependency_bytes, d.body_bytes, d.available_body_bytes),
                             (count, count * 16, base, len(body)))
            self.assertEqual(pointer(d.dependency_records), C.addressof(raw) + base)
            if count:
                raw[base] ^= 0xff
                self.assertEqual(d.dependency_records[0], raw[base])

    def test_tail_modulus_boundaries(self):
        base = make_body([1, 2], 1)
        for tail in (1, 8, 15, 17, 24, 4088, 4095, 4096, 4097, 4104, 65536 * 16 + 8):
            data = base + bytes(tail)
            if tail % 16:
                self.assert_rejected(data, TAIL)
            else:
                raw, d = self.decode_ok(data)
                self.assertEqual(d.dependency_count, tail // 16)

    def test_ragged_tails_are_atomic(self):
        base = make_body([3], 2)
        for n in list(range(1, 41)) + [1023, 1025, 4095, 4097]:
            if n % 16:
                self.assert_rejected(base + bytes(n), TAIL)

    def test_body_length(self):
        for ns, groups, tail in (([], 0, 0), ([3, 4], 1, 2), ([0] * 5, 7, 65536)):
            body = make_body(ns, groups, tail=tail)
            n = C.c_size_t(123)
            self.assertEqual(self.lib.action_family_2d_body_length(storage(body), len(body), C.byref(n)), OK)
            self.assertEqual(n.value, typed_length(ns, groups))

    def test_construct_image_and_metadata(self):
        ns, groups = [3, 0, 1, 4], 2
        body = make_body(ns, groups, seed=44, tail=2)
        raw, out = storage(body), Constructed()
        handles = handle_array(3 + len(ns), base=0x71000)
        image = (C.c_uint8 * 4096)(*[0xee] * 4096)
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        self.assertEqual(self.lib.action_family_2d_construct(raw, len(body), 50, 7, handles, 7, image, 4096,
                                                             C.byref(out)), OK)
        expect = expected_image(body, list(handles))
        self.assertEqual(out.image_bytes, len(expect))
        self.assertEqual(len(expect), 39 + 53 * 4 + 35 * 8 + 34 * 2)
        self.assertEqual(bytes(image)[:len(expect)], expect)
        self.assertEqual(bytes(image)[len(expect):], b'\xee' * (4096 - len(expect)))
        typed = typed_length(ns, groups)
        self.assertEqual((out.allocation_count, out.body_bytes_consumed, out.available_body_bytes,
                          out.dependency_count, out.dependency_bytes, out.payload_offset_before,
                          out.payload_offset_after, out.raw_type, out.runtime_type),
                         (7, typed, len(body), 2, 32, 50, 50 + typed, 0x2d, 0x2d))
        self.assertEqual((out.result_slot_handle, out.owner_header_handle, out.owner_entry_table_handle,
                          out.owner_group_handle, out.owner_action_index),
                         (handles[0], handles[0], handles[1], handles[6], 7))
        self.assertEqual(pointer(out.dependency_records), C.addressof(raw) + typed)
        self.assertEqual(bytes(raw)[:len(body)], body)

    def test_construct_empty_blocks_and_zero_counts(self):
        for ns, groups in (([], 0), ([0], 0), ([0, 0], 3), ([], 5)):
            body = make_body(ns, groups)
            raw, out = storage(body), Constructed()
            handles, image = handle_array(3 + len(ns)), (C.c_uint8 * 2048)()
            self.assertEqual(self.lib.action_family_2d_construct(raw, len(body), 0, 0, handles, 3 + len(ns),
                                                                 image, 2048, C.byref(out)), OK)
            self.assertEqual(bytes(image)[:out.image_bytes], expected_image(body, list(handles)))

    def test_construct_offset_wrap_and_index_sign(self):
        body = make_body([1], 1)
        typed = typed_length([1], 1)
        raw = storage(body)
        for offset in (0, 50, 0xffffffff - typed + 1, 0xffffffff - typed + 2, 0xffffffff):
            out = Constructed()
            self.assertEqual(self.lib.action_family_2d_construct(raw, len(body), offset, 3, handle_array(4), 4,
                                                                 (C.c_uint8 * 1024)(), 1024, C.byref(out)), OK)
            self.assertEqual(out.payload_offset_after, (offset + typed) & 0xffffffff)
        for index, extended in ((0, 0), (15, 15), (32767, 32767), (-1, -1), (-32768, -32768)):
            out = Constructed()
            self.assertEqual(self.lib.action_family_2d_construct(raw, len(body), 0, index, handle_array(4), 4,
                                                                 (C.c_uint8 * 1024)(), 1024, C.byref(out)), OK)
            self.assertEqual(out.owner_action_index, extended)

    def test_construct_argument_and_capacity_are_atomic(self):
        body = make_body([2, 1], 1)
        raw = storage(body)
        need = len(expected_image(body, [1] * 5))
        cases = []
        zero = handle_array(5)
        zero[3] = 0
        cases.append((zero, 5, need, ARGUMENT))
        cases.append((handle_array(4), 4, need, ARGUMENT))
        cases.append((handle_array(6), 6, need, ARGUMENT))
        cases.append((handle_array(5), 5, need - 1, CAPACITY))
        cases.append((handle_array(5), 5, 0, CAPACITY))
        cases.append((None, 5, need, ARGUMENT))
        cases.append((handle_array(5), 5, need, OK))
        for handles, count, capacity, status in cases:
            image = (C.c_uint8 * (need + 8))(*[0xa5] * (need + 8))
            out = Constructed()
            C.memset(C.byref(out), 0x5a, C.sizeof(out))
            before_out, before_image = bytes(out), bytes(image)
            self.assertEqual(self.lib.action_family_2d_construct(
                raw, len(body), 50, 1, handles, count, image, capacity, C.byref(out)), status)
            if status != OK:
                self.assertEqual((bytes(out), bytes(image)), (before_out, before_image))
        image = (C.c_uint8 * 16)()
        out = Constructed()
        before = bytes(out)
        self.assertEqual(self.lib.action_family_2d_construct(raw, len(body), 50, 1, handle_array(5), 5, None, 16,
                                                             C.byref(out)), ARGUMENT)
        self.assertEqual(bytes(out), before)

    def test_null_pointers(self):
        for out, call in self.calls(None, 39):
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            self.assertEqual(call(out), ARGUMENT)
            self.assertEqual(bytes(out), before)
        raw = storage(make_body([1], 1))
        self.assertEqual(self.lib.action_family_2d_decode(raw, 200, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_2d_body_length(raw, 200, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_2d_entry_at(raw, 200, 0, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_2d_record35_at(raw, 200, 0, 0, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_2d_record34_at(raw, 200, 0, None), ARGUMENT)
        self.assertEqual(self.lib.action_family_2d_construct(raw, 200, 0, 1, handle_array(4), 4,
                                                             (C.c_uint8 * 512)(), 512, None), ARGUMENT)

    def test_wrapped_input_spans_are_atomic(self):
        raw = storage(make_body([1], 1))
        huge = C.c_size_t(-1).value
        for ptr, length in ((C.cast(huge, C.POINTER(C.c_uint8)), 39), (raw, huge)):
            for out, call in self.calls(ptr, length):
                C.memset(C.byref(out), 0xa5, C.sizeof(out))
                before = bytes(out)
                self.assertEqual(call(out), BOUNDS)
                self.assertEqual(bytes(out), before)

    def test_wrapped_output_spans(self):
        raw = storage(make_body([1], 1))
        huge = C.c_size_t(-1).value
        n = len(raw)
        self.assertEqual(self.lib.action_family_2d_decode(raw, n, C.cast(huge, C.POINTER(Decoded))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_body_length(raw, n, C.cast(huge, C.POINTER(C.c_size_t))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_entry_at(raw, n, 0, C.cast(huge, C.POINTER(Entry))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_record35_at(raw, n, 0, 0, C.cast(huge, C.POINTER(Record35))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_record34_at(raw, n, 0, C.cast(huge, C.POINTER(Record34))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_construct(raw, n, 0, 1, handle_array(4), 4,
                                                             (C.c_uint8 * 512)(), 512,
                                                             C.cast(huge, C.POINTER(Constructed))), BOUNDS)
        self.assertEqual(self.lib.action_family_2d_construct(raw, n, 0, 1, handle_array(4), 4,
                                                             C.cast(huge, C.POINTER(C.c_uint8)), 512,
                                                             C.byref(Constructed())), BOUNDS)

    def test_overlap_and_adjacency(self):
        body = make_body([1], 1)
        n = len(body)
        funcs = ((Decoded, lambda r, o: self.lib.action_family_2d_decode(r, n, o)),
                 (C.c_size_t, lambda r, o: self.lib.action_family_2d_body_length(r, n, o)),
                 (Entry, lambda r, o: self.lib.action_family_2d_entry_at(r, n, 0, o)),
                 (Record35, lambda r, o: self.lib.action_family_2d_record35_at(r, n, 0, 0, o)),
                 (Record34, lambda r, o: self.lib.action_family_2d_record34_at(r, n, 0, o)),
                 (Constructed, lambda r, o: self.lib.action_family_2d_construct(
                     r, n, 0, 1, handle_array(4), 4, (C.c_uint8 * 512)(), 512, o)))
        for kind, func in funcs:
            for delta in (-(n - 1), -1, 0, 1, C.sizeof(kind) - 1):
                backing = (C.c_uint8 * (n * 2 + C.sizeof(kind)))()
                C.memset(backing, 0xa5, len(backing))
                before = bytes(backing)
                out = C.cast(C.addressof(backing) + n, C.POINTER(kind))
                raw = C.cast(C.addressof(out.contents) + delta, C.POINTER(C.c_uint8))
                self.assertEqual(func(raw, out), OVERLAP)
                self.assertEqual(bytes(backing), before)
            for after in (True, False):
                backing = (C.c_uint8 * (n + C.sizeof(kind)))()
                raw_address = C.addressof(backing) + (C.sizeof(kind) if after else 0)
                out_address = C.addressof(backing) + (0 if after else n)
                raw = C.cast(raw_address, C.POINTER(C.c_uint8))
                C.memmove(raw, body, n)
                out = C.cast(out_address, C.POINTER(kind))
                self.assertEqual(func(raw, out), OK)

    def test_construct_image_and_handle_overlap(self):
        body = make_body([1], 1)
        n = len(body)
        raw = storage(body)
        # image overlapping input
        backing = (C.c_uint8 * 1024)()
        C.memmove(backing, body, n)
        out = Constructed()
        self.assertEqual(self.lib.action_family_2d_construct(
            C.cast(backing, C.POINTER(C.c_uint8)), n, 0, 1, handle_array(4), 4,
            C.cast(C.addressof(backing) + 10, C.POINTER(C.c_uint8)), 512, C.byref(out)), OVERLAP)
        # image overlapping the output struct
        both = (C.c_uint8 * 2048)()
        out_view = C.cast(both, C.POINTER(Constructed))
        self.assertEqual(self.lib.action_family_2d_construct(
            raw, n, 0, 1, handle_array(4), 4, C.cast(both, C.POINTER(C.c_uint8)), 1024, out_view), OVERLAP)
        # handles overlapping the image
        image = (C.c_uint8 * 1024)()
        handles = C.cast(image, C.POINTER(C.c_uint32))
        for i in range(4):
            handles[i] = 0x1000 + i
        self.assertEqual(self.lib.action_family_2d_construct(
            raw, n, 0, 1, handles, 4, C.cast(image, C.POINTER(C.c_uint8)), 1024, C.byref(Constructed())), OVERLAP)


if __name__ == '__main__':
    unittest.main()
