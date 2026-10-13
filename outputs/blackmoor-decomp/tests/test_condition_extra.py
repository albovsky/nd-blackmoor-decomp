"""Behavioral tests for the recovered dependency leaf opcodes 11..21.

Build with scripts/build_condition_extra.sh before running this file. The
ctypes structures mirror the public borrowed-state API and existing
WorldInitState/WorldClockSession storage; conditions 0..6 and 9 remain owned by
scene_conditions.
"""
from __future__ import annotations

import ctypes as c
from pathlib import Path
import struct
import unittest


ROOT = Path(__file__).resolve().parents[3]
LIBRARY = ROOT / "outputs/blackmoor-decomp/build/libconditionextra.dylib"
RECORD_SIZE = 0x106
RECORD_COUNT = 10
RECORD_BYTES = RECORD_SIZE * RECORD_COUNT

OK = 0
ERR_ARGUMENT = 1
ERR_BOUNDS = 2
ERR_UNSUPPORTED = 3
ERR_HOST_UNAVAILABLE = 4
ERR_HOST_FAILURE = 5
ERR_DEBUG_FATAL = 6

HOST_OK = 0
HOST_UNAVAILABLE = 1
HOST_FAILURE = 2


class SceneDependencyInfo(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("or_after", c.c_int16),
        ("raw_bytes", c.POINTER(c.c_uint8)),
        ("fields", c.c_int16 * 8),
    ]


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


class SceneConditionState(c.Structure):
    _fields_ = [
        ("inventory_presence", c.POINTER(c.c_int32)),
        ("inventory_count", c.c_size_t),
        ("selected_inventory_item", c.c_int32),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
        ("value_table", c.POINTER(c.c_int32)),
        ("value_count", c.c_size_t),
        ("scene_visit_counts", c.POINTER(c.c_int16)),
        ("scene_visit_count", c.c_size_t),
        ("timer_4_value", c.c_int32),
        ("timer_5_value", c.c_int32),
        ("time_of_day_minutes", c.c_int32),
    ]


class ConditionExtraNodeRuntime(c.Structure):
    _fields_ = [
        ("runtime_threshold_20", c.c_int32),
        ("random_cache_valid_2c", c.c_uint32),
        ("random_sample_30", c.c_int32),
    ]


class ConditionExtraResult(c.Structure):
    _fields_ = [
        ("status", c.c_int32),
        ("trigger", c.c_int32),
        ("random_raw_value", c.c_uint32),
        ("random_calls", c.c_uint32),
        ("host_calls", c.c_uint32),
        ("partial_state_committed", c.c_uint8),
        ("reserved", c.c_uint8 * 3),
    ]


SoundCallback = c.CFUNCTYPE(
    c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int32)
)
RandomCallback = c.CFUNCTYPE(
    c.c_int, c.c_void_p, c.POINTER(c.c_uint32)
)


class ConditionExtraSession(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("condition_state", c.POINTER(SceneConditionState)),
        ("world", c.POINTER(WorldInitState)),
        ("clock", c.POINTER(WorldClockSession)),
        ("context_58c94f", c.c_int16),
        ("evaluation_mode_614", c.c_int32),
        ("previous_global_5c3a47", c.c_int32),
        ("debug_enabled_63a4cd", c.c_int32),
        ("selected_dependency_leaf", c.POINTER(c.c_void_p)),
        ("sound_query", SoundCallback),
        ("next_random", RandomCallback),
    ]


def open_library():
    if not LIBRARY.exists():
        raise AssertionError(
            f"missing condition-extra library; build with {ROOT}/outputs/"
            "blackmoor-decomp/scripts/build_condition_extra.sh"
        )
    lib = c.CDLL(str(LIBRARY))
    lib.condition_extra_node_initialize.argtypes = [
        c.POINTER(ConditionExtraNodeRuntime)
    ]
    lib.condition_extra_node_reset.argtypes = [
        c.POINTER(ConditionExtraNodeRuntime)
    ]
    lib.condition_extra_evaluate_leaf.argtypes = [
        c.POINTER(SceneDependencyInfo), c.c_void_p,
        c.POINTER(ConditionExtraNodeRuntime), c.POINTER(ConditionExtraSession),
        c.POINTER(c.c_int32), c.POINTER(ConditionExtraResult),
    ]
    lib.condition_extra_evaluate_leaf.restype = c.c_int
    return lib


class Fixture:
    def __init__(self):
        self.flags = (c.c_int32 * 16)()
        self.core = ActionCoreWorld()
        self.core.event_flags = c.cast(self.flags, c.POINTER(c.c_int32))
        self.core.event_flag_count = len(self.flags)
        self.records = (c.c_uint8 * RECORD_BYTES)()
        self.world = WorldInitState()
        self.world.action_core = c.pointer(self.core)
        self.world.time_records_585d65 = c.cast(
            self.records, c.POINTER(c.c_uint8)
        )
        self.world.time_records_size = len(self.records)
        self.clock = WorldClockSession()
        self.clock.world = c.pointer(self.world)
        self.condition = SceneConditionState()
        self.condition.selected_inventory_item = -1
        self.owner = c.c_void_p()
        self.session = ConditionExtraSession()
        self.session.condition_state = c.pointer(self.condition)
        self.session.world = c.pointer(self.world)
        self.session.clock = c.pointer(self.clock)
        self.session.selected_dependency_leaf = c.pointer(self.owner)

    def record(self, opcode, *, index=0, condition=0, raw=(0, 0, 0, 0)):
        row = SceneDependencyInfo()
        row.opcode = opcode
        row.fields[:] = (opcode, index, condition, 0, *raw)
        return row

    def put_timer(self, index, status, elapsed):
        struct.pack_into("<iI", self.records, index * RECORD_SIZE,
                         status, elapsed & 0xFFFFFFFF)

    def eval(self, record, identity=0x12345000, runtime=None, prior=-77):
        runtime = runtime or ConditionExtraNodeRuntime()
        status_out = c.c_int32(prior)
        result = ConditionExtraResult()
        code = LIB.condition_extra_evaluate_leaf(
            c.byref(record), c.c_void_p(identity), c.byref(runtime),
            c.byref(self.session), c.byref(status_out), c.byref(result)
        )
        return code, status_out.value, result, runtime


class ConditionExtraTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        global LIB
        LIB = open_library()

    def test_opcode11_tracks_selected_leaf_only_in_mode_zero(self):
        f = Fixture()
        leaf = f.record(11, index=7)
        identity = c.c_void_p(0x12345000)
        f.condition.selected_inventory_item = 7
        code, status, _, _ = f.eval(leaf, identity.value)
        self.assertEqual((code, status, f.owner.value), (OK, 1, identity.value))

        f.condition.selected_inventory_item = 2
        code, status, _, _ = f.eval(leaf, identity.value)
        self.assertEqual((code, status, f.owner.value), (OK, 0, None))
        f.owner.value = 0x77770000
        code, status, _, _ = f.eval(leaf, identity.value)
        self.assertEqual((code, status, f.owner.value), (OK, 0, 0x77770000))

        f.session.evaluation_mode_614 = 1
        code, status, _, _ = f.eval(leaf, identity.value)
        self.assertEqual((code, status, f.owner.value), (OK, 1, None))

    def test_opcode12_reads_current_clock_session_flag(self):
        f = Fixture()
        leaf = f.record(12, index=-1)
        f.clock.outside_window_flag_5bb20a = -1
        self.assertEqual(f.eval(leaf)[:2], (OK, 1))
        f.clock.outside_window_flag_5bb20a = 0
        self.assertEqual(f.eval(leaf)[:2], (OK, 0))

    def test_opcodes13_and14_use_live_records_and_zero_loader_threshold(self):
        f = Fixture()
        before = f.record(13, index=2, condition=1, raw=(0, 0, 5000, 0))
        after = f.record(14, index=2, condition=1, raw=(0, 0, 5000, 0))
        runtime = ConditionExtraNodeRuntime()
        LIB.condition_extra_node_initialize(c.byref(runtime))
        self.assertEqual(runtime.runtime_threshold_20, 0)
        f.put_timer(2, 5, 0)
        self.assertEqual(f.eval(before, runtime=runtime)[:2], (OK, 1))
        self.assertEqual(f.eval(after, runtime=runtime)[:2], (OK, 0))
        f.put_timer(2, 6, 0xFFFFFFFF)
        self.assertEqual(f.eval(before, runtime=runtime)[:2], (OK, 1))
        self.assertEqual(f.eval(after, runtime=runtime)[:2], (OK, 0))
        f.put_timer(2, 2, 0xFFFFFFFF)
        self.assertEqual(f.eval(before, runtime=runtime)[:2], (OK, 0))
        self.assertEqual(f.eval(after, runtime=runtime)[:2], (OK, 0))

    def test_opcodes13_and14_truth_table_uses_signed_live_elapsed_and_runtime_threshold(self):
        f = Fixture()
        runtime = ConditionExtraNodeRuntime()
        LIB.condition_extra_node_initialize(c.byref(runtime))
        for status_code in (1, 5, 6):
            f.put_timer(3, status_code, 0)
            for elapsed in (-1, 0, 1):
                for threshold in (-1, 0, 1):
                    f.put_timer(3, status_code, elapsed)
                    runtime.runtime_threshold_20 = threshold
                    before = f.record(13, index=3, condition=-32768,
                                      raw=(111, 222, -300, 444))
                    after = f.record(14, index=3, condition=32767,
                                     raw=(-111, -222, 300, -444))
                    self.assertEqual(
                        f.eval(before, runtime=runtime)[:2],
                        (OK, int(elapsed <= threshold)),
                        ("opcode 13", status_code, elapsed, threshold),
                    )
                    self.assertEqual(
                        f.eval(after, runtime=runtime)[:2],
                        (OK, int(elapsed > threshold)),
                        ("opcode 14", status_code, elapsed, threshold),
                    )

        for status_code in (0, 2, 3, 4, 7):
            for opcode in (13, 14):
                f.put_timer(3, status_code, 1)
                runtime.runtime_threshold_20 = 0
                leaf = f.record(opcode, index=3)
                self.assertEqual(
                    f.eval(leaf, runtime=runtime)[:2], (OK, 0),
                    (opcode, status_code),
                )

    def test_opcodes13_and14_reject_invalid_record_extent_without_output_write(self):
        f = Fixture()
        leaf = f.record(13, index=10)
        code, status, result, _ = f.eval(leaf, prior=73)
        self.assertEqual((code, status), (ERR_BOUNDS, 73))
        self.assertEqual(result.partial_state_committed, 0)
        f.world.time_records_size = 9 * RECORD_SIZE + 7
        leaf = f.record(14, index=9)
        code, status, _, _ = f.eval(leaf, prior=42)
        self.assertEqual((code, status), (ERR_BOUNDS, 42))

    def test_opcode15_compares_signed_context_value_to_field_two(self):
        f = Fixture()
        f.session.context_58c94f = -3
        self.assertEqual(f.eval(f.record(15, index=99, condition=-3))[:2], (OK, 1))
        self.assertEqual(f.eval(f.record(15, index=99, condition=3))[:2], (OK, 0))

    def test_opcode17_distinguishes_sound_false_from_unavailable(self):
        f = Fixture()
        calls = []

        @SoundCallback
        def sound(_context, channel, result_out):
            calls.append(channel)
            result_out[0] = 0
            return HOST_OK

        f.session.sound_query = sound
        leaf = f.record(17, index=4, condition=0)
        code, status, result, _ = f.eval(leaf)
        self.assertEqual((code, status), (OK, 1))
        self.assertEqual((calls, result.host_calls), ([4], 1))

        @SoundCallback
        def unavailable(_context, _channel, _result_out):
            return HOST_UNAVAILABLE

        f.session.sound_query = unavailable
        code, status, result, _ = f.eval(leaf, prior=91)
        self.assertEqual((code, status), (ERR_HOST_UNAVAILABLE, 91))
        self.assertEqual(result.partial_state_committed, 0)

    def test_opcode17_condition_one_requires_observed_sound_true(self):
        f = Fixture()

        @SoundCallback
        def sound(_context, _channel, result_out):
            result_out[0] = 1
            return HOST_OK

        f.session.sound_query = sound
        leaf = f.record(17, index=0, condition=1)
        self.assertEqual(f.eval(leaf)[:2], (OK, 1))
        leaf = f.record(17, index=0, condition=0)
        self.assertEqual(f.eval(leaf)[:2], (OK, 0))

    def test_opcode17_partial_host_failure_preserves_status_and_reports_prefix(self):
        f = Fixture()

        @SoundCallback
        def partial(_context, channel, result_out):
            self.assertEqual(channel, 6)
            result_out[0] = 1
            return HOST_FAILURE

        f.session.sound_query = partial
        code, status, result, _ = f.eval(f.record(17, index=6, condition=1), prior=91)
        self.assertEqual((code, status), (ERR_HOST_FAILURE, 91))
        self.assertEqual((result.host_calls, result.partial_state_committed), (1, 1))

    def test_opcode20_consumes_one_raw_rand_caches_modulo_and_reset_clears_only_valid(self):
        f = Fixture()
        draws = [99, 100]
        calls = []

        @RandomCallback
        def next_random(_context, value_out):
            calls.append(1)
            value_out[0] = draws.pop(0)
            return HOST_OK

        f.session.next_random = next_random
        leaf = f.record(20, condition=50)
        runtime = ConditionExtraNodeRuntime()
        LIB.condition_extra_node_initialize(c.byref(runtime))
        code, status, result, _ = f.eval(leaf, runtime=runtime)
        self.assertEqual((code, status), (OK, 0))
        self.assertEqual((runtime.random_cache_valid_2c,
                          runtime.random_sample_30, result.random_raw_value,
                          result.random_calls, calls), (1, 99, 99, 1, [1]))
        leaf.fields[2] = 100
        code, status, result, _ = f.eval(leaf, runtime=runtime, prior=73)
        self.assertEqual((code, status, result.random_calls, calls), (OK, 73, 0, [1]))
        LIB.condition_extra_node_reset(c.byref(runtime))
        self.assertEqual((runtime.random_cache_valid_2c, runtime.random_sample_30), (0, 99))
        leaf.fields[2] = 100
        code, status, result, _ = f.eval(leaf, runtime=runtime)
        self.assertEqual((code, status, result.random_calls, result.random_raw_value), (OK, 1, 1, 100))

    def test_opcode20_debug_fatal_reports_random_prefix_without_status_commit(self):
        f = Fixture()
        draws = [123]

        @RandomCallback
        def next_random(_context, value_out):
            value_out[0] = draws.pop(0)
            return HOST_OK

        f.session.next_random = next_random
        f.session.debug_enabled_63a4cd = 1
        runtime = ConditionExtraNodeRuntime()
        LIB.condition_extra_node_initialize(c.byref(runtime))
        leaf = f.record(20, condition=0)
        code, status, result, _ = f.eval(leaf, runtime=runtime, prior=88)
        self.assertEqual((code, status), (ERR_DEBUG_FATAL, 88))
        self.assertEqual((runtime.random_cache_valid_2c, runtime.random_sample_30,
                          result.random_raw_value, result.random_calls,
                          result.partial_state_committed), (0, 23, 123, 1, 1))

    def test_opcode20_unavailable_partial_and_out_of_domain_random_boundaries(self):
        f = Fixture()
        runtime = ConditionExtraNodeRuntime()
        LIB.condition_extra_node_initialize(c.byref(runtime))
        leaf = f.record(20, condition=50)

        code, status, result, _ = f.eval(leaf, runtime=runtime, prior=44)
        self.assertEqual((code, status), (ERR_HOST_UNAVAILABLE, 44))
        self.assertEqual((result.host_calls, result.random_calls,
                          result.partial_state_committed), (0, 0, 0))

        @RandomCallback
        def partial(_context, _value_out):
            return HOST_FAILURE

        f.session.next_random = partial
        code, status, result, _ = f.eval(leaf, runtime=runtime, prior=55)
        self.assertEqual((code, status), (ERR_HOST_FAILURE, 55))
        self.assertEqual((result.host_calls, result.random_calls,
                          result.partial_state_committed,
                          runtime.random_cache_valid_2c,
                          runtime.random_sample_30), (1, 1, 1, 0, 0))

        @RandomCallback
        def invalid_domain(_context, value_out):
            value_out[0] = 32768
            return HOST_OK

        f.session.next_random = invalid_domain
        code, status, result, _ = f.eval(leaf, runtime=runtime, prior=66)
        self.assertEqual((code, status), (ERR_HOST_FAILURE, 66))
        self.assertEqual((result.random_raw_value, result.random_calls,
                          result.partial_state_committed,
                          runtime.random_cache_valid_2c,
                          runtime.random_sample_30), (32768, 1, 1, 0, 0))

    def test_opcode21_reads_prior_global_without_writing_it(self):
        f = Fixture()
        leaf = f.record(21)
        f.session.previous_global_5c3a47 = 0
        self.assertEqual(f.eval(leaf)[:2], (OK, 0))
        self.assertEqual(f.session.previous_global_5c3a47, 0)
        f.session.previous_global_5c3a47 = 1
        self.assertEqual(f.eval(leaf)[:2], (OK, 1))
        self.assertEqual(f.session.previous_global_5c3a47, 1)

    def test_unobserved_and_unknown_opcodes_remain_unsupported(self):
        f = Fixture()
        for opcode in (3, 16, 22, 0xFFFF):
            leaf = f.record(opcode)
            code, status, _, _ = f.eval(leaf, prior=37)
            self.assertEqual((code, status), (ERR_UNSUPPORTED, 37), opcode)


if __name__ == "__main__":
    unittest.main()
