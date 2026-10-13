"""Focused fixtures for the bounded New Game and scene lifecycle kernel."""

from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libworldinit.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_BOUNDS = 2
ERR_UNSUPPORTED_TEST_MODE = 3
ERR_SCENE_ID = 4


class ActionCoreWorld(c.Structure):
    _fields_ = [
        ("short_values", c.c_int16 * 30),
        ("float_values", c.c_float * 10),
        ("difficulty", c.c_int16),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
    ]


class EngineBootStartupSettings(c.Structure):
    _fields_ = [
        ("ordinary_initial_scene", c.c_int16),
        ("ordinary_coordinate_word_a", c.c_int16),
        ("ordinary_coordinate_word_b", c.c_int16),
        ("alternate_initial_scene", c.c_int16),
        ("alternate_coordinate_word_a", c.c_int16),
        ("alternate_coordinate_word_b", c.c_int16),
        ("initial_hour", c.c_int16),
        ("initial_minute", c.c_int16),
        ("first_day_event_hour", c.c_int16),
        ("first_day_event_flag_id", c.c_int16),
        ("clock_update_interval_ms", c.c_int16),
    ]


class U16Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_uint16)), ("count", c.c_size_t)]


class I32Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_int32)), ("count", c.c_size_t)]


class U32Span(c.Structure):
    _fields_ = [("values", c.POINTER(c.c_uint32)), ("count", c.c_size_t)]


class Inventory(c.Structure):
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


class Clock(c.Structure):
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


class StartTuple(c.Structure):
    _fields_ = [
        ("scene_id", c.c_int32),
        ("coordinate_word_a", c.c_int16),
        ("coordinate_word_b", c.c_int16),
        ("source", c.c_uint8),
    ]


class StartupOverrides(c.Structure):
    _fields_ = [
        ("alternate_tuple_active", c.c_int32),
        ("forced_scene_gate_a", c.c_int32),
        ("forced_scene_gate_b", c.c_int32),
        ("forced_scene_id", c.c_int32),
        ("test_mode_enabled", c.c_int32),
    ]


class WorldInitState(c.Structure):
    _fields_ = [
        ("action_core", c.POINTER(ActionCoreWorld)),
        ("opaque_state_dwords_5839b1", I32Span),
        ("scene_visit_counts_587b2d", U16Span),
        ("inventory", Inventory),
        ("time_records_585d65", c.POINTER(c.c_uint8)),
        ("time_records_size", c.c_size_t),
        ("clock", Clock),
        ("start_tuple", StartTuple),
        ("forced_scene_mirror_63a4ed", c.c_int32),
    ]


class WorldInitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            subprocess.run([str(PROJECT / "scripts/build_world_init.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.world_init_apply_new_game.argtypes = [
            c.POINTER(WorldInitState), c.POINTER(EngineBootStartupSettings),
            c.POINTER(StartupOverrides), c.c_uint32,
        ]
        cls.lib.world_init_apply_new_game.restype = c.c_int
        cls.lib.world_init_apply_scene_clear.argtypes = [
            c.POINTER(WorldInitState), c.c_int, c.c_uint32
        ]
        cls.lib.world_init_apply_scene_clear.restype = c.c_int
        cls.lib.world_init_record_successful_scene_load.argtypes = [
            c.POINTER(WorldInitState), c.c_int32, c.c_int
        ]
        cls.lib.world_init_record_successful_scene_load.restype = c.c_int
        cls.lib.world_init_cold_zero_event_flags.argtypes = [
            c.POINTER(ActionCoreWorld)
        ]
        cls.lib.world_init_cold_zero_event_flags.restype = c.c_int
        cls.lib.world_init_reset_inventory_object_data.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t
        ]
        cls.lib.world_init_reset_inventory_object_data.restype = c.c_int

    def test_inventory_object_resets_exact_16_slot_and_fixed_fields(self):
        size = 0x828A
        object_view = (c.c_uint8 * size)(*([0xA5] * size))

        self.assertEqual(self.lib.world_init_reset_inventory_object_data(
            object_view, size
        ), OK)

        for index in range(16):
            base = 0x7FAE + index * 0x28
            self.assertEqual(bytes(object_view[base:base + 4]), b"\xff" * 4)
            self.assertEqual(bytes(object_view[base + 4:base + 8]), b"\0" * 4)

        for offset in (0x825E, 0x8256, 0x8286, 0x825A, 0x8262):
            self.assertEqual(bytes(object_view[offset:offset + 4]), b"\0" * 4)
        self.assertEqual(bytes(object_view[0x6B1C:0x6B20]), b"\xff" * 4)
        self.assertEqual(object_view[0x7FAD], 0xA5)
        self.assertEqual(object_view[0x7FB6], 0xA5)
        self.assertEqual(object_view[0x8285], 0xA5)

    def test_inventory_object_view_bounds_fail_before_mutation(self):
        size = 0x828A - 1
        object_view = (c.c_uint8 * size)(*([0x5A] * size))
        before = bytes(object_view)
        self.assertEqual(self.lib.world_init_reset_inventory_object_data(
            object_view, size
        ), ERR_BOUNDS)
        self.assertEqual(bytes(object_view), before)
        self.assertEqual(self.lib.world_init_reset_inventory_object_data(None, 0),
                         ERR_ARGUMENT)

    def make_state(self, flag_count=2300, visit_count=10001):
        flags = (c.c_int32 * flag_count)(
            *[0x12000000 + index for index in range(flag_count)]
        )
        core = ActionCoreWorld()
        core.event_flags = flags
        core.event_flag_count = flag_count
        core.short_values[:] = [index - 7 for index in range(30)]
        core.float_values[:] = [index + 0.5 for index in range(10)]
        core.difficulty = -321

        opaque = (c.c_int32 * 30)(*([0x13572468] * 30))
        visits = (c.c_uint16 * visit_count)(*([0x2345] * visit_count))
        selected = c.c_int16(23)
        opaque_selector = c.c_int16(24)
        selector_words = (c.c_uint16 * 3)(10, 11, 12)
        presence = (c.c_int32 * 70)(*([0x55AA55AA] * 70))
        ids_a = (c.c_uint16 * 70)(*([0x1111] * 70))
        ids_b = (c.c_uint16 * 70)(*([0x2222] * 70))
        ids_c = (c.c_uint16 * 70)(*([0x3333] * 70))
        aux_a = (c.c_uint32 * 70)(*([0xAAAAAAAA] * 70))
        aux_b = (c.c_uint32 * 70)(*([0xBBBBBBBB] * 70))
        records = (c.c_uint8 * 2620)(*([0xCC] * 2620))

        state = WorldInitState()
        state.action_core = c.pointer(core)
        state.opaque_state_dwords_5839b1 = I32Span(opaque, 30)
        state.scene_visit_counts_587b2d = U16Span(visits, visit_count)
        state.inventory = Inventory(
            c.pointer(selected), c.pointer(opaque_selector), U16Span(selector_words, 3),
            I32Span(presence, 70), U16Span(ids_a, 70), U16Span(ids_b, 70),
            U16Span(ids_c, 70), U32Span(aux_a, 70), U32Span(aux_b, 70),
        )
        state.time_records_585d65 = records
        state.time_records_size = 2620
        state.forced_scene_mirror_63a4ed = -1
        state.clock = Clock(
            0x11111111, 0x22222222, 1, 2, 3, 0x33333333, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 0x44444444, 0x55555555, 14,
        )
        keepalive = (flags, core, opaque, visits, selected, opaque_selector,
                     selector_words, presence, ids_a, ids_b, ids_c, aux_a, aux_b,
                     records)
        return state, keepalive

    @staticmethod
    def boot_settings():
        # Values decoded from the selected original BOOT/BSUM record.
        return EngineBootStartupSettings(0, 0, 0, 8000, 0, 0,
                                        18, 0, 3, 1668, 20000)

    @staticmethod
    def default_overrides():
        return StartupOverrides(0, 0, 0, -1, 0)

    def test_new_game_matches_cold_boot_fields_and_preserves_lower_flags(self):
        state, keepalive = self.make_state()
        flags, core, opaque, visits, selected, opaque_selector, words, presence, \
            ids_a, ids_b, ids_c, aux_a, aux_b, records = keepalive
        lower_flags = list(flags[:1000])
        settings = self.boot_settings()
        overrides = self.default_overrides()

        self.assertEqual(self.lib.world_init_apply_new_game(
            c.byref(state), c.byref(settings), c.byref(overrides), 0xFFFFFFF0), OK
        )

        self.assertEqual(list(flags[:1000]), lower_flags)
        self.assertEqual(list(flags[1000:2251]), [0] * 1251)
        self.assertEqual(flags[2251], 0x12000000 + 2251)
        self.assertEqual(list(visits), [0] * 10001)
        self.assertEqual(list(opaque), [0] * 30)
        self.assertEqual((selected.value, opaque_selector.value), (-1, -1))
        self.assertEqual(list(words), [0, 0, 0])
        self.assertEqual(list(presence), [0] * 70)
        self.assertEqual(list(ids_a), [0xFFFF] * 70)
        self.assertEqual(list(ids_b), [0xFFFF] * 70)
        self.assertEqual(list(ids_c), [0xFFFF] * 70)
        self.assertEqual(list(aux_a), [0] * 70)
        self.assertEqual(list(aux_b), [0] * 70)
        self.assertEqual(list(core.short_values), [9999] * 30)
        self.assertEqual(list(core.float_values), [9999.0] * 10)
        self.assertEqual(core.difficulty, 0)
        self.assertEqual(state.start_tuple.scene_id, 0)
        self.assertEqual(state.start_tuple.coordinate_word_a, 0)
        self.assertEqual(state.start_tuple.coordinate_word_b, 0)
        self.assertEqual(state.start_tuple.source, 0)
        self.assertEqual(state.forced_scene_mirror_63a4ed, -1)

        clock = state.clock
        self.assertEqual((clock.run_start_tick, clock.run_elapsed_ticks),
                         (0xFFFFFFF0, 0))
        self.assertEqual((clock.run_display_word_0, clock.run_display_word_1,
                          clock.run_display_word_2), (0, 0, 0))
        self.assertEqual((clock.scene_elapsed_ticks, clock.scene_display_word_0,
                          clock.scene_display_word_1, clock.scene_display_word_2),
                         (0, 0, 0, 0))
        self.assertEqual((clock.total_minutes, clock.configured_hour,
                          clock.configured_minute, clock.day_counter), (1080, 18, 0, 0))
        self.assertEqual(clock.next_update_tick, (0xFFFFFFF0 + 20000) & 0xFFFFFFFF)
        self.assertEqual((clock.first_day_event_hour, clock.first_day_event_flag_id),
                         (3, 1668))
        self.assertEqual((clock.previous_tick_5d, clock.previous_tick_61),
                         (0xFFFFFFF0, 0xFFFFFFF0))
        self.assertEqual(clock.update_interval_ms, 20000)

        for index in range(10):
            row = bytes(records[index * 262:(index + 1) * 262])
            self.assertEqual(row[:40], b"\x00" * 40)
            self.assertEqual(row[40:49], b"NO SOUND\x00")
            self.assertEqual(row[49:222], b"\x00" * (222 - 49))
            self.assertEqual(row[222:262], b"".join(
                b"\xff\xff\x00\x00" for _ in range(10)
            ))

    def test_alternate_and_forced_scene_tuple_gates(self):
        state, _keepalive = self.make_state()
        settings = EngineBootStartupSettings(-1, -22, 33, 8000, 44, -55,
                                             18, 0, 3, 1668, 20000)
        overrides = StartupOverrides(1, 1, 0, 77, 0)
        self.assertEqual(self.lib.world_init_apply_new_game(
            c.byref(state), c.byref(settings), c.byref(overrides), 123
        ), OK)
        self.assertEqual((state.start_tuple.scene_id,
                          state.start_tuple.coordinate_word_a,
                          state.start_tuple.coordinate_word_b,
                          state.start_tuple.source), (8000, 44, -55, 1))
        self.assertEqual(state.forced_scene_mirror_63a4ed, -1)

        state, _keepalive = self.make_state()
        overrides = StartupOverrides(0, 0, 9, 123456, 0)
        self.assertEqual(self.lib.world_init_apply_new_game(
            c.byref(state), c.byref(settings), c.byref(overrides), 123
        ), OK)
        self.assertEqual((state.start_tuple.scene_id,
                          state.start_tuple.coordinate_word_a,
                          state.start_tuple.coordinate_word_b,
                          state.start_tuple.source), (123456, -22, 33, 2))
        self.assertEqual(state.forced_scene_mirror_63a4ed, 123456)

    def test_test_mode_is_explicitly_unsupported_without_partial_mutation(self):
        state, keepalive = self.make_state()
        flags, core, opaque, visits, selected, opaque_selector, words, presence, \
            ids_a, ids_b, ids_c, aux_a, aux_b, records = keepalive
        before = c.string_at(c.addressof(flags), c.sizeof(flags))
        core_before = c.string_at(c.addressof(core), c.sizeof(core))
        opaque_before = bytes(opaque)
        visits_before = bytes(visits)
        records_before = bytes(records)
        state_before = c.string_at(c.addressof(state), c.sizeof(state))
        settings = self.boot_settings()
        overrides = StartupOverrides(0, 0, 0, 42, 1)
        self.assertEqual(self.lib.world_init_apply_new_game(
            c.byref(state), c.byref(settings), c.byref(overrides), 77
        ), ERR_UNSUPPORTED_TEST_MODE)
        self.assertEqual(c.string_at(c.addressof(flags), c.sizeof(flags)), before)
        self.assertEqual(c.string_at(c.addressof(core), c.sizeof(core)), core_before)
        self.assertEqual(bytes(opaque), opaque_before)
        self.assertEqual(bytes(visits), visits_before)
        self.assertEqual(bytes(records), records_before)
        self.assertEqual(c.string_at(c.addressof(state), c.sizeof(state)), state_before)

    def test_scene_clear_fresh_and_restore_clock_lifetimes(self):
        state, keepalive = self.make_state()
        flags = keepalive[0]
        run_snapshot = (state.clock.run_start_tick, state.clock.run_elapsed_ticks,
                        state.clock.run_display_word_0, state.clock.run_display_word_1,
                        state.clock.run_display_word_2, state.clock.total_minutes,
                        state.clock.day_counter, state.clock.previous_tick_61)
        flags_before = list(flags)
        self.assertEqual(self.lib.world_init_apply_scene_clear(c.byref(state), 0, 500), OK)
        self.assertEqual(list(flags[1000:1031]), [0] * 31)
        self.assertEqual(list(flags[:1000]), flags_before[:1000])
        self.assertEqual(flags[1031], flags_before[1031])
        self.assertEqual((state.clock.scene_elapsed_ticks,
                          state.clock.scene_display_word_0,
                          state.clock.scene_display_word_1,
                          state.clock.scene_display_word_2), (0, 0, 0, 0))
        self.assertEqual((state.clock.run_start_tick, state.clock.run_elapsed_ticks,
                          state.clock.run_display_word_0, state.clock.run_display_word_1,
                          state.clock.run_display_word_2, state.clock.total_minutes,
                          state.clock.day_counter, state.clock.previous_tick_61),
                         run_snapshot)

        state, keepalive = self.make_state()
        flags = keepalive[0]
        clock_before = bytes(state.clock)
        self.assertEqual(self.lib.world_init_apply_scene_clear(c.byref(state), 1, 0xFFFFFFF0), OK)
        self.assertEqual(list(flags[1000:1031]), [0] * 31)
        self.assertEqual((state.clock.scene_elapsed_ticks,
                          state.clock.scene_display_word_0,
                          state.clock.scene_display_word_1,
                          state.clock.scene_display_word_2),
                         (0x33333333, 4, 5, 6))
        self.assertEqual(state.clock.run_start_tick, 0xFFFFFFF0)
        self.assertEqual(state.clock.next_update_tick,
                         (0xFFFFFFF0 + 14) & 0xFFFFFFFF)
        self.assertEqual(state.clock.previous_tick_5d, 0xFFFFFFF0)
        self.assertEqual(state.clock.previous_tick_61,
                         int.from_bytes(clock_before[52:56], "little"))

    def test_successful_scene_load_visit_increment_wrap_restore_and_bounds(self):
        state, keepalive = self.make_state()
        visits = keepalive[3]
        visits[12] = 0xFFFF
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), 12, 0
        ), OK)
        self.assertEqual(visits[12], 0)
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), 12, 1
        ), OK)
        self.assertEqual(visits[12], 0)
        visits[13] = 0x7FFF
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), 13, 0
        ), OK)
        self.assertEqual(visits[13], 0x8000)
        self.assertEqual(int.from_bytes(bytes(visits)[26:28], "little", signed=True),
                         -32768)
        visits[9990] = 4
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), 9990, 0
        ), OK)
        self.assertEqual(visits[9990], 5)
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), 9991, 0
        ), ERR_SCENE_ID)
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(state), -1, 0
        ), ERR_SCENE_ID)

        short_state, short_keepalive = self.make_state(visit_count=12)
        before = bytes(short_keepalive[3])
        self.assertEqual(self.lib.world_init_record_successful_scene_load(
            c.byref(short_state), 12, 0
        ), ERR_BOUNDS)
        self.assertEqual(bytes(short_keepalive[3]), before)

    def test_cold_zero_uses_only_caller_supplied_event_span(self):
        flags = (c.c_int32 * 15)(*range(15))
        core = ActionCoreWorld()
        core.event_flags = flags
        core.event_flag_count = len(flags)
        self.assertEqual(self.lib.world_init_cold_zero_event_flags(c.byref(core)), OK)
        self.assertEqual(list(flags), [0] * 15)
        self.assertEqual(self.lib.world_init_cold_zero_event_flags(None), ERR_ARGUMENT)

    def test_new_game_rejects_short_spans_before_any_write(self):
        state, keepalive = self.make_state(flag_count=2250)
        flags, core, opaque, visits, _selected, _selector, _words, _presence, \
            _ids_a, _ids_b, _ids_c, _aux_a, _aux_b, records = keepalive
        before_flags = bytes(flags)
        before_core = c.string_at(c.addressof(core), c.sizeof(core))
        before_opaque = bytes(opaque)
        before_visits = bytes(visits)
        before_records = bytes(records)
        settings = self.boot_settings()
        overrides = self.default_overrides()
        self.assertEqual(self.lib.world_init_apply_new_game(
            c.byref(state), c.byref(settings), c.byref(overrides), 55
        ), ERR_BOUNDS)
        self.assertEqual(bytes(flags), before_flags)
        self.assertEqual(c.string_at(c.addressof(core), c.sizeof(core)), before_core)
        self.assertEqual(bytes(opaque), before_opaque)
        self.assertEqual(bytes(visits), before_visits)
        self.assertEqual(bytes(records), before_records)


if __name__ == "__main__":
    unittest.main()
