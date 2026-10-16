"""Behavioral tests for the isolated live-world clock kernel.

Build the owned module first with scripts/build_world_clock.sh, then run this
file with unittest. The ctypes views intentionally mirror existing
WorldInitState/ActionCoreWorld storage; this module must not introduce another
copy of those scalar values.
"""
from __future__ import annotations

import ctypes as c
from pathlib import Path
import struct
import unittest


ROOT = Path(__file__).resolve().parents[3]
LIBRARY = ROOT / "outputs/blackmoor-decomp/build/libworldclock.dylib"
RECORD_SIZE = 0x106
RECORD_COUNT = 10
RECORD_BYTES = RECORD_SIZE * RECORD_COUNT

CLOCK_OK = 0
CLOCK_ERR_BOUNDS = 2
CLOCK_ERR_UNSUPPORTED_OPCODE = 4
CLOCK_ERR_HOST_UNAVAILABLE = 5
CLOCK_ERR_CAPTION_UNAVAILABLE = 6
CLOCK_ERR_CONTINUATION = 8

TRIGGER_NONE = 0
TRIGGER_EVENT_FLAG = 3
TRIGGER_SOUND_DESCRIPTOR = 4
TRIGGER_SOUND_CHANNEL_PLAY = 5
TRIGGER_CAPTION_LOOKUP = 6
TRIGGER_CAPTION_PRESENT = 7

EFFECT_LOAD_SOUND_DESCRIPTOR = 1
EFFECT_PLAY_SOUND_CHANNEL = 2
EFFECT_SHOW_CAPTION = 3
CAPTION_FROM_RESOLVER = 1
CAPTION_FROM_FALLBACK = 2
HOST_OK = 0
HOST_RETURNED_FAILURE_IGNORED = 1
HOST_UNAVAILABLE = 2
RESOLVER_FOUND = 0
RESOLVER_NOT_FOUND = 1
RESOLVER_UNAVAILABLE = 2

CONTINUE_NORMAL_POST_CLOCK = 0x43B13D
CONTINUE_OFFMODE_CLEANUP = 0x43AB41


class I32Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_int32)), ("count", c.c_size_t)]


class U16Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_uint16)), ("count", c.c_size_t)]


class U32Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_uint32)), ("count", c.c_size_t)]


class WorldInitInventory(c.Structure):
    _fields_ = [
        ("selected_item_candidate", c.POINTER(c.c_int16)),
        ("opaque_selector_583f1d", c.POINTER(c.c_int16)),
        ("selector_words_583a2b", U16Span),
        ("presence_583bd5", I32Span),
        ("item_ids_583a31", U16Span),
        ("item_ids_583abd", U16Span),
        ("item_ids_583b49", U16Span),
        ("auxiliary_583ced", U32Span),
        ("auxiliary_583e05", U32Span),
    ]


class WorldInitClock(c.Structure):
    _fields_ = [
        ("run_start_tick", c.c_uint32),
        ("run_elapsed_ticks", c.c_uint32),
        ("run_display_word_0", c.c_uint16),
        ("run_display_word_1", c.c_uint16),
        ("run_display_word_2", c.c_uint16),
        ("scene_elapsed_ticks", c.c_uint32),
        ("scene_display_word_0", c.c_uint16),
        ("scene_display_word_1", c.c_uint16),
        ("scene_display_word_2", c.c_uint16),
        ("total_minutes", c.c_int32),
        ("configured_minute", c.c_int16),
        ("configured_hour", c.c_int16),
        ("day_counter", c.c_int16),
        ("next_update_tick", c.c_uint32),
        ("first_day_event_hour", c.c_int16),
        ("first_day_event_flag_id", c.c_int16),
        ("previous_tick_5d", c.c_uint32),
        ("previous_tick_61", c.c_uint32),
        ("update_interval_ms", c.c_int16),
    ]


class WorldInitStartTuple(c.Structure):
    _fields_ = [
        ("scene_id", c.c_int32),
        ("coordinate_word_a", c.c_int16),
        ("coordinate_word_b", c.c_int16),
        ("source", c.c_uint8),
    ]


class ActionCoreWorld(c.Structure):
    _fields_ = [
        ("short_values", c.c_int16 * 30),
        ("float_values", c.c_float * 10),
        ("difficulty", c.c_int16),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
    ]


class WorldInitState(c.Structure):
    _fields_ = [
        ("action_core", c.POINTER(ActionCoreWorld)),
        ("opaque_state_dwords_5839b1", I32Span),
        ("scene_visit_counts_587b2d", U16Span),
        ("inventory", WorldInitInventory),
        ("time_records_585d65", c.POINTER(c.c_uint8)),
        ("time_records_size", c.c_size_t),
        ("clock", WorldInitClock),
        ("start_tuple", WorldInitStartTuple),
        ("forced_scene_mirror_63a4ed", c.c_int32),
    ]


class WorldClockSession(c.Structure):
    _fields_ = [
        ("world", c.POINTER(WorldInitState)),
        ("outside_window_flag_5bb20a", c.c_int16),
        ("time_window_start_5b0284", c.c_int16),
        ("time_window_end_5b0286", c.c_int16),
        ("captions_enabled_5bb202", c.c_uint8),
        ("reserved", c.c_uint8 * 3),
    ]


class WorldClockEffect(c.Structure):
    _fields_ = [
        ("kind", c.c_int),
        ("record_index", c.c_uint32),
        ("caption_source", c.c_uint32),
        ("sound_channel", c.c_uint16),
        ("reserved", c.c_uint16),
        ("sound_descriptor", c.c_uint8 * 49),
        ("text", c.c_void_p),
        ("text_length", c.c_size_t),
    ]


EmitCallback = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(WorldClockEffect))
ResolveCallback = c.CFUNCTYPE(
    c.c_int,
    c.c_void_p,
    c.c_void_p,
    c.c_size_t,
    c.POINTER(c.c_void_p),
    c.POINTER(c.c_size_t),
)


class WorldClockEffectSink(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("emit", EmitCallback),
        ("resolve_caption", ResolveCallback),
    ]


class WorldClockResult(c.Structure):
    _fields_ = [
        ("status", c.c_int32),
        ("trigger", c.c_int32),
        ("continuation_va", c.c_uint32),
        ("delta_ms", c.c_uint32),
        ("record_index", c.c_uint16),
        ("pair_index", c.c_uint16),
        ("event_flag_id", c.c_int32),
        ("effects_attempted", c.c_uint32),
        ("ignored_host_failures", c.c_uint32),
        ("partial_state_committed", c.c_uint8),
        ("reserved", c.c_uint8 * 3),
    ]


class Fixture:
    def __init__(self, *, flag_count=32, record_bytes=RECORD_BYTES):
        self.flags = (c.c_int32 * flag_count)()
        self.core = ActionCoreWorld()
        self.core.event_flags = c.cast(self.flags, c.POINTER(c.c_int32))
        self.core.event_flag_count = flag_count
        self.records = (c.c_uint8 * record_bytes)()
        self.state = WorldInitState()
        self.state.action_core = c.pointer(self.core)
        self.state.time_records_585d65 = c.cast(
            self.records, c.POINTER(c.c_uint8)
        )
        self.state.time_records_size = record_bytes
        self.clock = self.state.clock
        self.clock.run_start_tick = 100
        self.clock.next_update_tick = 10000
        self.clock.update_interval_ms = 1000
        self.clock.previous_tick_5d = 100
        self.clock.previous_tick_61 = 100
        self.clock.first_day_event_flag_id = -1
        self.session = WorldClockSession()
        self.session.world = c.pointer(self.state)
        self.session.time_window_start_5b0284 = 0
        self.session.time_window_end_5b0286 = 24 * 60 - 1

    def put_record(self, index, *, status=0, elapsed=0, target=0, done=0,
                   sound=b"NO SOUND", sound_channel=0, sound_field_23=0,
                   sound_mode=0, sound_control=0, sound_scalar_2d=0,
                   sound_scalar_2f=0, pairs=(), caption=b"", fallback=b""):
        raw = bytearray(RECORD_SIZE)
        struct.pack_into("<i", raw, 0, status)
        struct.pack_into("<I", raw, 4, elapsed & 0xFFFFFFFF)
        struct.pack_into("<i", raw, 0x14, done)
        struct.pack_into("<i", raw, 0x18, target)
        raw[0x28:0x28 + min(len(sound), 0x21)] = sound[:0x21]
        struct.pack_into("<H", raw, 0x49, sound_channel)
        struct.pack_into("<H", raw, 0x4B, sound_field_23)
        struct.pack_into("<H", raw, 0x4D, sound_mode)
        struct.pack_into("<I", raw, 0x51, sound_control)
        struct.pack_into("<h", raw, 0x55, sound_scalar_2d)
        struct.pack_into("<h", raw, 0x57, sound_scalar_2f)
        raw[0x59:0x59 + min(len(caption), 0x20)] = caption[:0x20]
        raw[0x7A:0x7A + min(len(fallback), 0x20)] = fallback[:0x20]
        for pair_index in range(10):
            struct.pack_into("<h", raw, 0xDE + pair_index * 4, -1)
        for pair_index, (flag_id, value) in enumerate(pairs[:10]):
            struct.pack_into("<h", raw, 0xDE + pair_index * 4, flag_id)
            struct.pack_into("<h", raw, 0xE0 + pair_index * 4, value)
        c.memmove(c.addressof(self.records) + index * RECORD_SIZE,
                  bytes(raw), RECORD_SIZE)

    def record(self, index):
        start = index * RECORD_SIZE
        return bytes(self.records[start:start + RECORD_SIZE])


class SinkRecorder:
    def __init__(self, *, emit_result=HOST_OK, resolver_result=RESOLVER_NOT_FOUND,
                 resolved_text=b""):
        self.emit_result = emit_result
        self.resolver_result = resolver_result
        self.resolved_text = resolved_text
        self.events = []
        self.resolve_calls = []
        self._resolved_storage = None

        def emit(_context, effect_ptr):
            effect = effect_ptr.contents
            raw = (c.string_at(effect.text, effect.text_length)
                   if effect.text and effect.text_length else b"")
            self.events.append((effect.kind, effect.record_index,
                                effect.caption_source, effect.sound_channel,
                                bytes(effect.sound_descriptor), raw))
            return self.emit_result

        def resolve(_context, key_ptr, key_length, out_ptr, out_length):
            key = c.string_at(key_ptr, key_length)
            self.resolve_calls.append(key)
            if self.resolver_result == RESOLVER_FOUND:
                self._resolved_storage = c.create_string_buffer(self.resolved_text)
                out_ptr[0] = c.cast(self._resolved_storage, c.c_void_p)
                out_length[0] = len(self.resolved_text)
            else:
                out_ptr[0] = None
                out_length[0] = 0
            return self.resolver_result

        self.emit_callback = EmitCallback(emit)
        self.resolve_callback = ResolveCallback(resolve)
        self.sink = WorldClockEffectSink(
            None, self.emit_callback, self.resolve_callback
        )


class WorldClockTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            raise AssertionError(
                "Build the owned module with outputs/blackmoor-decomp/"
                "scripts/build_world_clock.sh before running this suite"
            )
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.world_clock_update_normal.argtypes = [
            c.POINTER(WorldClockSession), c.c_uint32,
            c.POINTER(WorldClockEffectSink), c.POINTER(WorldClockResult)
        ]
        cls.lib.world_clock_update_normal.restype = c.c_int
        cls.lib.world_clock_update_offmode.argtypes = [
            c.POINTER(WorldClockSession), c.c_uint32, c.c_int,
            c.POINTER(WorldClockResult)
        ]
        cls.lib.world_clock_update_offmode.restype = c.c_int
        cls.lib.world_clock_condition_read.argtypes = [
            c.POINTER(WorldInitState), c.c_uint16, c.POINTER(c.c_int32)
        ]
        cls.lib.world_clock_condition_read.restype = c.c_int

    def invoke_normal(self, fixture, now, recorder=None):
        result = WorldClockResult()
        sink_ptr = c.byref(recorder.sink) if recorder is not None else None
        status = self.lib.world_clock_update_normal(
            c.byref(fixture.session), now, sink_ptr, c.byref(result)
        )
        return status, result

    def test_normal_delta_updates_borrowed_clock_and_active_records(self):
        fixture = Fixture()
        fixture.clock.run_elapsed_ticks = 3_780_100
        fixture.clock.scene_elapsed_ticks = 9_000
        fixture.put_record(0, status=1, elapsed=3_780_100)
        fixture.put_record(1, status=5, elapsed=20)
        fixture.put_record(2, status=6, elapsed=30)
        fixture.put_record(3, status=2, elapsed=500)
        status, result = self.invoke_normal(fixture, 1_501)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(result.delta_ms, 1_401)
        self.assertEqual(fixture.clock.run_start_tick, 1_501)
        self.assertEqual(fixture.clock.run_elapsed_ticks, 3_781_501)
        self.assertEqual(fixture.clock.scene_elapsed_ticks, 10_401)
        self.assertEqual(tuple(fixture.clock.run_display_word_0
                               for _ in (0,)), (1,))
        self.assertEqual((fixture.clock.run_display_word_1,
                          fixture.clock.run_display_word_2), (3, 1))
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 4)[0],
                         3_781_501)
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 8)[0], 1)
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 12)[0], 3)
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 16)[0], 1)
        self.assertEqual(struct.unpack_from("<I", fixture.record(1), 4)[0], 1_421)
        self.assertEqual(struct.unpack_from("<I", fixture.record(2), 4)[0], 1_431)
        self.assertEqual(struct.unpack_from("<I", fixture.record(3), 4)[0], 500)
        self.assertEqual(result.continuation_va, CONTINUE_NORMAL_POST_CLOCK)

    def test_civil_clock_due_once_rollover_skips_first_day_event_then_sets_it(self):
        fixture = Fixture()
        fixture.clock.configured_minute = 59
        fixture.clock.configured_hour = 23
        fixture.clock.day_counter = 0
        fixture.clock.next_update_tick = 1_000
        fixture.clock.update_interval_ms = 5_000
        fixture.clock.first_day_event_hour = 0
        fixture.clock.first_day_event_flag_id = 7
        fixture.session.time_window_start_5b0284 = 480
        fixture.session.time_window_end_5b0286 = 1_000

        status, first = self.invoke_normal(fixture, 1_000)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(fixture.clock.next_update_tick, 6_000)
        self.assertEqual((fixture.clock.configured_hour,
                          fixture.clock.configured_minute,
                          fixture.clock.day_counter,
                          fixture.clock.total_minutes), (0, 0, 1, 0))
        self.assertEqual(fixture.flags[7], 0)
        self.assertEqual(fixture.session.outside_window_flag_5bb20a, 1)

        status, second = self.invoke_normal(fixture, 1_001)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(fixture.flags[7], 1)
        self.assertEqual(fixture.clock.total_minutes, 0)
        self.assertEqual(second.continuation_va, CONTINUE_NORMAL_POST_CLOCK)

    def test_status5_and_status6_completion_order_flags_sound_caption_reset(self):
        """Status 5 completion runs reset_completed_record (0x433bd2) on the whole record, byte for byte."""
        fixture = Fixture()
        fixture.put_record(
            0, status=5, elapsed=0, target=100, done=0, sound=b"NO SOUND",
            pairs=((2, -7), (-1, 999), (4, 0)), caption=b"missing-key",
            fallback=b"Fallback caption",
        )
        fixture.put_record(
            1, status=6, elapsed=0, target=100, done=0, sound=b"bell.wav",
            sound_channel=13, sound_field_23=0x3344, sound_mode=2,
            sound_control=0x89ABCDEF, sound_scalar_2d=75,
            sound_scalar_2f=-23,
        )
        fixture.session.captions_enabled_5bb202 = 1
        recorder = SinkRecorder(resolver_result=RESOLVER_NOT_FOUND)

        status, result = self.invoke_normal(fixture, 200, recorder)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(fixture.flags[2], -7)
        self.assertEqual(fixture.flags[4], 0)
        self.assertEqual(recorder.resolve_calls, [b"missing-key"])
        descriptor = fixture.record(1)[0x28:0x28 + 49]
        self.assertEqual(recorder.events, [
            (EFFECT_SHOW_CAPTION, 0, CAPTION_FROM_FALLBACK, 0,
             bytes(49), b"Fallback caption<n><e>"),
            (EFFECT_LOAD_SOUND_DESCRIPTOR, 1, 0, 13, descriptor, b""),
            (EFFECT_PLAY_SOUND_CHANNEL, 1, 0, 13, bytes(49), b""),
        ])
        self.assertEqual(descriptor[0x21:0x23], b"\x0d\x00")
        self.assertEqual(descriptor[0x23:0x25], b"\x44\x33")
        self.assertEqual(descriptor[0x25:0x27], b"\x02\x00")
        self.assertEqual(descriptor[0x29:0x2d], b"\xef\xcd\xab\x89")
        self.assertEqual(descriptor[0x2d:0x31], b"K\x00\xe9\xff")
        reset = fixture.record(0)
        self.assertEqual(reset[:4], b"\0\0\0\0")
        expected_reset = bytearray(RECORD_SIZE)
        expected_reset[0x28:0x31] = b"NO SOUND\0"
        for pair_index in range(10):
            struct.pack_into("<h", expected_reset, 0xDE + pair_index * 4, -1)
        self.assertEqual(reset, bytes(expected_reset))
        self.assertEqual(struct.unpack_from("<h", reset, 0xDE)[0], -1)
        completed6 = fixture.record(1)
        self.assertEqual(struct.unpack_from("<i", completed6, 0)[0], 1)
        self.assertEqual(struct.unpack_from("<i", completed6, 0x14)[0], 1)
        self.assertEqual(result.effects_attempted, 3)

    def test_caption_resolved_text_and_disabled_caption_do_not_call_resolver(self):
        fixture = Fixture()
        fixture.put_record(0, status=6, target=10, sound=b"NO SOUND",
                           caption=b"AUTO-KEY", fallback=b"Fallback")
        fixture.session.captions_enabled_5bb202 = 1
        recorder = SinkRecorder(resolver_result=RESOLVER_FOUND,
                                resolved_text=b"Resolved caption")
        status, _result = self.invoke_normal(fixture, 110, recorder)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(recorder.resolve_calls, [b"AUTO-KEY"])
        self.assertEqual(recorder.events, [
            (EFFECT_SHOW_CAPTION, 0, CAPTION_FROM_RESOLVER, 0,
             bytes(49), b"Resolved caption<n><e>")
        ])

        fixture = Fixture()
        fixture.put_record(0, status=6, target=10, sound=b"NO SOUND",
                           caption=b"AUTO-KEY", fallback=b"Fallback")
        fixture.session.captions_enabled_5bb202 = 0
        recorder = SinkRecorder(resolver_result=RESOLVER_UNAVAILABLE)
        status, _result = self.invoke_normal(fixture, 110, recorder)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(recorder.resolve_calls, [])
        self.assertEqual(recorder.events, [])

    def test_flag_pair_bounds_failure_keeps_original_order_partial_prefix(self):
        fixture = Fixture(flag_count=4)
        fixture.put_record(0, status=5, target=100, pairs=((2, -7), (9, 4)))
        status, result = self.invoke_normal(fixture, 200)
        self.assertEqual(status, CLOCK_ERR_BOUNDS)
        self.assertEqual(result.trigger, TRIGGER_EVENT_FLAG)
        self.assertEqual((result.record_index, result.pair_index,
                          result.event_flag_id), (0, 1, 9))
        self.assertEqual(fixture.flags[2], -7)
        record = fixture.record(0)
        self.assertEqual(struct.unpack_from("<i", record, 0x14)[0], 1)
        self.assertEqual(struct.unpack_from("<h", record, 0xDE)[0], 2)
        self.assertEqual(struct.unpack_from("<h", record, 0xE2)[0], 9)
        self.assertEqual(result.partial_state_committed, 1)

    def test_missing_sound_sink_stops_at_exact_host_boundary_after_prefix(self):
        fixture = Fixture()
        fixture.put_record(0, status=5, target=100, sound=b"bell.wav")
        status, result = self.invoke_normal(fixture, 200)
        self.assertEqual(status, CLOCK_ERR_HOST_UNAVAILABLE)
        self.assertEqual(result.trigger, TRIGGER_SOUND_DESCRIPTOR)
        self.assertEqual(result.record_index, 0)
        record = fixture.record(0)
        self.assertEqual(struct.unpack_from("<i", record, 0x14)[0], 1)
        self.assertEqual(struct.unpack_from("<h", record, 0xDE)[0], -1)
        self.assertEqual(fixture.clock.scene_elapsed_ticks, 0)
        self.assertEqual(struct.unpack_from("<i", fixture.record(1), 0)[0], 0)

    def test_missing_caption_lookup_stops_after_completion_prefix(self):
        fixture = Fixture()
        fixture.put_record(0, status=6, target=100, sound=b"NO SOUND",
                           pairs=((2, 5),), caption=b"AUTO-KEY")
        fixture.session.captions_enabled_5bb202 = 1
        recorder = SinkRecorder()
        recorder.sink.resolve_caption = ResolveCallback()

        status, result = self.invoke_normal(fixture, 200, recorder)
        self.assertEqual(status, CLOCK_ERR_CAPTION_UNAVAILABLE)
        self.assertEqual(result.trigger, TRIGGER_CAPTION_LOOKUP)
        self.assertEqual(fixture.flags[2], 5)
        self.assertEqual(struct.unpack_from("<i", fixture.record(0), 0x14)[0], 1)
        self.assertEqual(struct.unpack_from("<h", fixture.record(0), 0xDE)[0], -1)
        self.assertEqual(fixture.clock.scene_elapsed_ticks, 0)
        self.assertEqual(recorder.events, [])

    def test_caption_copy_capacity_is_a_typed_safe_port_boundary(self):
        fixture = Fixture()
        fixture.put_record(0, status=6, target=10, sound=b"NO SOUND",
                           caption=b"AUTO-KEY")
        fixture.session.captions_enabled_5bb202 = 1
        recorder = SinkRecorder(resolver_result=RESOLVER_FOUND,
                                resolved_text=b"x" * 98)

        status, result = self.invoke_normal(fixture, 110, recorder)
        self.assertEqual(status, CLOCK_ERR_BOUNDS)
        self.assertEqual(result.trigger, TRIGGER_CAPTION_PRESENT)
        self.assertEqual(result.record_index, 0)
        self.assertEqual(recorder.resolve_calls, [b"AUTO-KEY"])
        self.assertEqual(recorder.events, [])
        self.assertEqual(struct.unpack_from("<i", fixture.record(0), 0x14)[0], 1)
        self.assertEqual(fixture.clock.scene_elapsed_ticks, 0)

    def test_host_return_failures_are_ignored_when_original_ignores_them(self):
        fixture = Fixture()
        fixture.put_record(0, status=6, target=100, sound=b"bell.wav",
                           caption=b"CAPTION", fallback=b"Fallback")
        fixture.session.captions_enabled_5bb202 = 1
        recorder = SinkRecorder(
            emit_result=HOST_RETURNED_FAILURE_IGNORED,
            resolver_result=RESOLVER_FOUND,
            resolved_text=b"Resolved",
        )
        status, result = self.invoke_normal(fixture, 200, recorder)
        self.assertEqual(status, CLOCK_OK)
        self.assertEqual(result.ignored_host_failures, 3)
        self.assertEqual(struct.unpack_from("<i", fixture.record(0), 0)[0], 1)
        self.assertEqual([event[0] for event in recorder.events],
                         [EFFECT_LOAD_SOUND_DESCRIPTOR,
                          EFFECT_PLAY_SOUND_CHANNEL,
                          EFFECT_SHOW_CAPTION])

    def test_offmode_pause_subtract_clamps_and_leaves_display_completion_untouched(self):
        fixture = Fixture()
        fixture.clock.run_elapsed_ticks = 200
        fixture.clock.scene_elapsed_ticks = 50
        fixture.clock.previous_tick_5d = 500
        fixture.put_record(0, status=1, elapsed=100)
        fixture.put_record(1, status=5, elapsed=200, target=1)
        before_display = fixture.record(0)[8:20]

        result = WorldClockResult()
        status = self.lib.world_clock_update_offmode(
            c.byref(fixture.session), 800, 0, c.byref(result)
        )
        self.assertEqual(status, CLOCK_ERR_CONTINUATION)
        self.assertEqual(result.continuation_va, CONTINUE_OFFMODE_CLEANUP)
        self.assertEqual(result.delta_ms, 300)
        self.assertEqual(fixture.clock.previous_tick_61, 800)
        self.assertEqual(fixture.clock.run_elapsed_ticks, 0)
        self.assertEqual(fixture.clock.scene_elapsed_ticks, 0)
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 4)[0], 0)
        self.assertEqual(fixture.record(0)[8:20], before_display)
        self.assertEqual(struct.unpack_from("<i", fixture.record(1), 0)[0], 5)
        self.assertEqual(struct.unpack_from("<i", fixture.record(1), 0x14)[0], 0)

        status = self.lib.world_clock_update_offmode(
            c.byref(fixture.session), 900, 1, c.byref(result)
        )
        self.assertEqual(status, CLOCK_ERR_CONTINUATION)
        self.assertEqual(fixture.clock.previous_tick_61, 900)
        self.assertEqual(fixture.clock.run_elapsed_ticks, 0)

    def test_offmode_equal_saved_mark_does_not_subtract(self):
        fixture = Fixture()
        fixture.clock.previous_tick_5d = 800
        fixture.clock.run_elapsed_ticks = 55
        fixture.put_record(0, status=6, elapsed=17)
        result = WorldClockResult()
        status = self.lib.world_clock_update_offmode(
            c.byref(fixture.session), 800, 0, c.byref(result)
        )
        self.assertEqual(status, CLOCK_ERR_CONTINUATION)
        self.assertEqual(result.delta_ms, 0)
        self.assertEqual(fixture.clock.run_elapsed_ticks, 55)
        self.assertEqual(struct.unpack_from("<I", fixture.record(0), 4)[0], 17)

    def test_live_condition_reads_share_clock_and_opcode3_is_explicit(self):
        fixture = Fixture()
        fixture.clock.run_elapsed_ticks = 0x80000000
        fixture.clock.scene_elapsed_ticks = 0x7FFFFFFF
        fixture.clock.total_minutes = -1
        out = c.c_int32(12345)
        self.assertEqual(self.lib.world_clock_condition_read(
            c.byref(fixture.state), 4, c.byref(out)), CLOCK_OK)
        self.assertEqual(out.value, -0x80000000)
        self.assertEqual(self.lib.world_clock_condition_read(
            c.byref(fixture.state), 5, c.byref(out)), CLOCK_OK)
        self.assertEqual(out.value, 0x7FFFFFFF)
        self.assertEqual(self.lib.world_clock_condition_read(
            c.byref(fixture.state), 6, c.byref(out)), CLOCK_OK)
        self.assertEqual(out.value, -1)
        out.value = 12345
        self.assertEqual(self.lib.world_clock_condition_read(
            c.byref(fixture.state), 3, c.byref(out)),
            CLOCK_ERR_UNSUPPORTED_OPCODE)
        self.assertEqual(out.value, 12345)

    def test_short_record_view_fails_before_clock_mutation(self):
        fixture = Fixture(record_bytes=RECORD_BYTES - 1)
        fixture.clock.run_elapsed_ticks = 42
        clock_before = bytes(fixture.state.clock)
        result = WorldClockResult()
        status = self.lib.world_clock_update_normal(
            c.byref(fixture.session), 500, None, c.byref(result)
        )
        self.assertEqual(status, CLOCK_ERR_BOUNDS)
        self.assertEqual(bytes(fixture.state.clock), clock_before)


if __name__ == "__main__":
    unittest.main()
