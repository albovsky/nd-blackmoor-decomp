"""Tests for the bounded 0x62 parser and recovered action-state reducer."""

from __future__ import annotations

import ctypes as c
import hashlib
import struct
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
ROOT = Path(__file__).resolve().parents[3]
LIBRARY = PROJECT / "build/libactionfamily62.dylib"
RESOURCE_LIBRARY = PROJECT / "build/libsceneresource.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_TYPE = 2
ERR_BODY = 3
ERR_COUNT = 4
ERR_BACKEND = 5
BACKEND_OK = 0


class Entry(c.Structure):
    _fields_ = [("words", c.c_int16 * 9)]


class Decoded(c.Structure):
    _fields_ = [
        ("raw_type", c.c_uint8),
        ("reserved", c.c_uint8),
        ("event_ids", c.c_int16 * 2),
        ("event_values", c.c_int16 * 2),
        ("threshold", c.c_int16),
        ("entry_count", c.c_int16),
        ("typed_body_length", c.c_size_t),
        ("raw_body", c.POINTER(c.c_uint8)),
        ("raw_body_length", c.c_size_t),
        ("dependency_bytes", c.POINTER(c.c_uint8)),
        ("dependency_length", c.c_size_t),
    ]


class Input(c.Structure):
    _fields_ = [
        ("subtype", c.c_uint8),
        ("eligible", c.c_uint8),
        ("completed_before", c.c_uint8),
        ("reserved", c.c_uint8),
        ("phase_before", c.c_int32),
        ("selector", c.c_int16),
    ]


class EventWrite(c.Structure):
    _fields_ = [("event_id", c.c_int16), ("value", c.c_int16)]


class Result(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("phase_written", c.c_uint8),
        ("phase_after", c.c_int32),
        ("start_global_written", c.c_uint8),
        ("start_global_value", c.c_uint8),
        ("request_written", c.c_uint8),
        ("request_value", c.c_uint8),
        ("response_written", c.c_uint8),
        ("response_words", c.c_int16 * 4),
        ("completion_written", c.c_uint8),
        ("completed_after", c.c_uint8),
        ("dependency_reset_requested", c.c_uint8),
        ("event_write_count", c.c_uint8),
        ("event_writes", EventWrite * 2),
    ]


ApplyResultFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(Result))


class Backend(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("apply_result_atomically", ApplyResultFn),
    ]


class SceneActionInfo(c.Structure):
    _fields_ = [
        ("description", c.c_char * 49),
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("payload_kind", c.c_int),
        ("raw_body", c.POINTER(c.c_uint8)),
        ("raw_body_length", c.c_size_t),
        ("typed_body", c.POINTER(c.c_uint8)),
        ("typed_body_length", c.c_size_t),
        ("dependency_records", c.POINTER(c.c_uint8)),
        ("dependency_count", c.c_size_t),
    ]


class SceneSummary(c.Structure):
    _fields_ = [
        ("title", c.c_char * 51),
        ("background", c.c_char * 34),
        ("audio", c.c_char * 34),
        ("raw_tail", c.c_uint8 * 10),
        ("action_count", c.c_size_t),
    ]


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


def make_body(
    *,
    event_pairs=((-1, 0), (-1, 0)),
    threshold=1,
    entries=((0, 7, 11, 0, 12, 0, 13, 0, 14),),
    tail=b"",
) -> bytes:
    body = bytearray()
    for event_id, value in event_pairs:
        body += i16(event_id) + i16(value)
    body += i16(threshold) + i16(len(entries))
    for entry in entries:
        if len(entry) != 9:
            raise ValueError("A 0x62 entry contains nine signed words")
        body += b"".join(i16(word) for word in entry)
    return bytes(body) + tail


def bytes_buffer(data: bytes):
    return (c.c_uint8 * len(data)).from_buffer_copy(data)


class ActionFamily62Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_action_family_62.sh")], check=True)
        subprocess.run([str(PROJECT / "scripts/build_scene_resource.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_family_62_decode.argtypes = [
            c.c_uint8, c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)
        ]
        cls.lib.action_family_62_decode.restype = c.c_int
        cls.lib.action_family_62_entry_at.argtypes = [
            c.POINTER(Decoded), c.c_size_t, c.POINTER(Entry)
        ]
        cls.lib.action_family_62_entry_at.restype = c.c_int
        cls.lib.action_family_62_step.argtypes = [
            c.POINTER(Decoded), c.POINTER(Input), c.POINTER(Backend), c.POINTER(Result)
        ]
        cls.lib.action_family_62_step.restype = c.c_int

        cls.resources = c.CDLL(str(RESOURCE_LIBRARY))
        cls.resources.scene_resource_open_memory.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t
        ]
        cls.resources.scene_resource_open_memory.restype = c.c_void_p
        cls.resources.scene_resource_close.argtypes = [c.c_void_p]
        cls.resources.scene_resource_action_count.argtypes = [c.c_void_p]
        cls.resources.scene_resource_action_count.restype = c.c_size_t
        cls.resources.scene_resource_action_at.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)
        ]
        cls.resources.scene_resource_action_at.restype = c.c_int

    def decode(self, body: bytes, raw_type=0x62):
        storage = bytes_buffer(body)
        decoded = Decoded()
        status = self.lib.action_family_62_decode(
            raw_type, storage, len(body), c.byref(decoded)
        )
        return status, decoded, storage

    def step(self, body: bytes, *, phase=0, subtype=1, eligible=True,
             completed=0, selector=7, backend=None):
        status, decoded, storage = self.decode(body)
        self.assertEqual(status, OK)
        input_value = Input(subtype, int(eligible), completed, 0, phase, selector)
        result = Result()
        backend_ptr = c.byref(backend) if backend is not None else None
        status = self.lib.action_family_62_step(
            c.byref(decoded), c.byref(input_value), backend_ptr, c.byref(result)
        )
        return status, result, storage, decoded

    def test_decoder_uses_signed_count_body_boundary_and_borrows_original_bytes(self):
        tail = bytes(range(32))
        body = make_body(
            event_pairs=((3, -9), (4, 17)),
            threshold=34,
            entries=((1, 7, -10, 4, 20, 6, 30, 8, -40),
                     (2, -7, 11, 12, 13, 14, 15, 16, 17)),
            tail=tail,
        )
        status, decoded, storage = self.decode(body)
        self.assertEqual(status, OK)
        self.assertEqual((decoded.event_ids[0], decoded.event_values[0]), (3, -9))
        self.assertEqual((decoded.event_ids[1], decoded.event_values[1]), (4, 17))
        self.assertEqual((decoded.threshold, decoded.entry_count), (34, 2))
        self.assertEqual(decoded.typed_body_length, 48)
        self.assertEqual(decoded.raw_body_length, len(body))
        self.assertEqual(decoded.dependency_length, len(tail))
        tail_address = c.cast(decoded.dependency_bytes, c.c_void_p).value
        self.assertEqual(c.string_at(tail_address, len(tail)), tail)
        self.assertEqual(c.addressof(storage), c.cast(decoded.raw_body, c.c_void_p).value)

    def test_decoder_rejects_sibling_type_and_malformed_counts_before_step(self):
        good = make_body()
        status, _decoded, _storage = self.decode(good, raw_type=0x63)
        self.assertEqual(status, ERR_TYPE)
        status, _decoded, _storage = self.decode(b"\0" * 11)
        self.assertEqual(status, ERR_BODY)
        status, _decoded, _storage = self.decode(b"\0" * 10 + i16(-1))
        self.assertEqual(status, ERR_COUNT)
        status, _decoded, _storage = self.decode(b"\0" * 10 + i16(2) + b"\0" * 18)
        self.assertEqual(status, ERR_BODY)
        # The original constructor stores its size in a signed short.
        self.assertEqual(self.decode(b"\0" * 10 + i16(1820) + b"\0" * 32760)[0], ERR_COUNT)

    def test_decoder_accepts_largest_signed_short_body_without_an_arbitrary_cap(self):
        count = 1819
        body = bytearray(12 + count * 18)
        body[10:12] = i16(count)
        status, decoded, _storage = self.decode(bytes(body))
        self.assertEqual(status, OK)
        self.assertEqual(decoded.entry_count, count)
        self.assertEqual(decoded.typed_body_length, 32754)

    def test_entry_accessor_preserves_all_nine_signed_words_and_bounds_index(self):
        words = (-32768, -300, -1, 0, 1, 2, 300, 32767, -7)
        status, decoded, _storage = self.decode(make_body(entries=(words,)))
        self.assertEqual(status, OK)
        entry = Entry()
        self.assertEqual(self.lib.action_family_62_entry_at(
            c.byref(decoded), 0, c.byref(entry)
        ), OK)
        self.assertEqual(list(entry.words), list(words))
        self.assertEqual(self.lib.action_family_62_entry_at(
            c.byref(decoded), 1, c.byref(entry)
        ), ERR_BODY)

    def test_invalid_decoded_view_fails_before_writing_the_result(self):
        status, decoded, _storage = self.decode(make_body())
        self.assertEqual(status, OK)
        decoded.raw_body_length = 11
        input_value = Input(1, 1, 0, 0, 0, 7)
        result = Result()
        c.memset(c.byref(result), 0xA5, c.sizeof(result))
        before = c.string_at(c.byref(result), c.sizeof(result))
        status = self.lib.action_family_62_step(
            c.byref(decoded), c.byref(input_value), None, c.byref(result)
        )
        self.assertEqual(status, ERR_BODY)
        self.assertEqual(c.string_at(c.byref(result), c.sizeof(result)), before)

    def test_phase_zero_sets_start_then_runs_selector_scan(self):
        body = make_body(entries=((7, -1, 0, -2, 0, -3, 0, -4, 0),))
        status, result, _storage, _decoded = self.step(body, phase=0)
        self.assertEqual(status, OK)
        self.assertEqual((result.recognized, result.applied), (1, 1))
        self.assertEqual((result.start_global_written, result.start_global_value), (1, 1))
        self.assertEqual((result.phase_written, result.phase_after), (1, 1))
        self.assertEqual((result.request_written, result.request_value), (1, 1))
        self.assertEqual(result.response_written, 1)
        self.assertEqual(list(result.response_words), [-1, -2, -3, -4])

    def test_phase_one_no_match_clears_request_but_preserves_phase_and_completion(self):
        body = make_body(entries=((0, 5, 1, 2, 3, 4, 5, 6, 7),))
        status, result, _storage, _decoded = self.step(
            body, phase=1, selector=7, completed=9
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.phase_written, 0)
        self.assertEqual(result.phase_after, 1)
        self.assertEqual((result.request_written, result.request_value), (1, 0))
        self.assertEqual(result.response_written, 0)
        self.assertEqual((result.completion_written, result.completed_after), (0, 9))

    def test_phase_two_under_threshold_emits_event_writes_and_subtype_one_completion(self):
        body = make_body(event_pairs=((3, -99), (-1, 7)), threshold=34)
        status, result, _storage, _decoded = self.step(
            body, phase=2, subtype=1, completed=0
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.phase_written, result.phase_after), (1, 0))
        self.assertEqual((result.request_written, result.request_value), (1, 0))
        self.assertEqual((result.completion_written, result.completed_after), (1, 1))
        self.assertEqual(result.dependency_reset_requested, 0)
        self.assertEqual(result.event_write_count, 1)
        self.assertEqual((result.event_writes[0].event_id, result.event_writes[0].value), (3, -99))

    def test_phase_two_subtype_two_requests_tree_reset_and_clears_completion(self):
        body = make_body(threshold=0)
        status, result, _storage, _decoded = self.step(
            body, phase=2, subtype=2, completed=1
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.phase_written, result.phase_after), (1, 0))
        self.assertEqual((result.completion_written, result.completed_after), (1, 0))
        self.assertEqual(result.dependency_reset_requested, 1)

    def test_phase_two_at_or_above_threshold_rearms_without_clearing_request(self):
        body = make_body(event_pairs=((3, 9), (4, 8)), threshold=35)
        status, result, _storage, _decoded = self.step(
            body, phase=2, subtype=1, completed=7
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.phase_written, result.phase_after), (1, 1))
        self.assertEqual(result.request_written, 0)
        self.assertEqual((result.completion_written, result.completed_after), (0, 7))
        self.assertEqual(result.event_write_count, 0)

    def test_false_gate_and_unknown_phase_leave_action_fields_unchanged(self):
        body = make_body()
        for phase, eligible in ((0, False), (1, False), (2, False), (3, True)):
            with self.subTest(phase=phase, eligible=eligible):
                status, result, _storage, _decoded = self.step(
                    body, phase=phase, eligible=eligible, completed=7
                )
                self.assertEqual(status, OK)
                self.assertEqual((result.applied, result.phase_written), (0, 0))
                self.assertEqual(result.phase_after, phase)
                self.assertEqual((result.completion_written, result.completed_after), (0, 7))
                self.assertEqual(result.request_written, 0)
                self.assertEqual(result.start_global_written, 0)

    def test_optional_backend_receives_one_typed_result_and_failure_is_reported(self):
        calls = []

        @ApplyResultFn
        def apply(_context, result):
            value = result.contents
            calls.append((value.phase_after, value.completed_after, value.event_write_count))
            return 9

        backend = Backend(None, apply)
        status, result, _storage, _decoded = self.step(
            make_body(event_pairs=((2, 11), (-1, 0))),
            phase=2, backend=backend,
        )
        self.assertEqual(status, ERR_BACKEND)
        self.assertEqual(calls, [(0, 1, 1)])
        self.assertEqual((result.phase_after, result.completed_after), (0, 1))

    def test_every_corpus_record_has_constructor_bounded_body_and_dependency_tail(self):
        resource_root = ROOT / "work/analysis/hiff-resources"
        self.assertTrue(resource_root.is_dir())
        scene_count = 0
        action_count = 0
        family_count = 0
        subtype_counts: dict[int, int] = {}
        count_counts: dict[int, int] = {}
        body_length_counts: dict[int, int] = {}
        tail_length_counts: dict[int, int] = {}

        for path in sorted(resource_root.glob("*.bin")):
            raw = path.read_bytes()
            storage = bytes_buffer(raw)
            error = c.create_string_buffer(256)
            scene = self.resources.scene_resource_open_memory(
                storage, len(raw), error, len(error)
            )
            if not scene:
                continue
            scene_count += 1
            try:
                count = self.resources.scene_resource_action_count(scene)
                action_count += count
                for index in range(count):
                    action = SceneActionInfo()
                    self.assertEqual(self.resources.scene_resource_action_at(
                        scene, index, c.byref(action)
                    ), 0)
                    if action.type != 0x62:
                        continue
                    family_count += 1
                    subtype_counts[action.subtype] = subtype_counts.get(action.subtype, 0) + 1
                    body = c.string_at(action.raw_body, action.raw_body_length)
                    status, decoded, _borrowed = self.decode(body)
                    self.assertEqual(status, OK, (path.name, index))
                    self.assertEqual(decoded.raw_type, 0x62)
                    self.assertEqual(decoded.typed_body_length, 12 + decoded.entry_count * 18)
                    self.assertLessEqual(decoded.typed_body_length, len(body))
                    tail_length = len(body) - decoded.typed_body_length
                    # Constructor size comes from its count field. This divisibility
                    # check is only a corpus consistency check on the separate tail.
                    self.assertEqual(tail_length % 16, 0, (path.name, index, tail_length))
                    count_counts[decoded.entry_count] = count_counts.get(decoded.entry_count, 0) + 1
                    body_length_counts[decoded.typed_body_length] = body_length_counts.get(
                        decoded.typed_body_length, 0
                    ) + 1
                    tail_length_counts[tail_length] = tail_length_counts.get(tail_length, 0) + 1
            finally:
                self.resources.scene_resource_close(scene)

        self.assertEqual((scene_count, action_count, family_count), (2078, 19612, 1802))
        self.assertEqual(subtype_counts, {1: 1802})
        self.assertEqual(count_counts, {1: 1802})
        self.assertEqual(body_length_counts, {30: 1802})
        self.assertEqual(tail_length_counts, {
            0: 660, 16: 862, 32: 178, 48: 37, 80: 34, 96: 18,
            64: 10, 144: 1, 176: 1, 288: 1,
        })


if __name__ == "__main__":
    unittest.main()
