"""Unit tests for the isolated original action-state handlers."""

from __future__ import annotations

import ctypes as c
import math
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactioncore.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_BODY = 2
ERR_EVENT_FLAG_BOUNDS = 3
ERR_UNSUPPORTED = 4


class ActionCoreWorld(c.Structure):
    _fields_ = [
        ("short_values", c.c_int16 * 30),
        ("float_values", c.c_float * 10),
        ("difficulty", c.c_int16),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
    ]


class ActionCoreAction(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("eligible", c.c_uint8),
        ("completed_before", c.c_uint8),
        ("phase_before", c.c_uint32),
        ("body", c.POINTER(c.c_uint8)),
        ("body_length", c.c_size_t),
    ]


class ActionCoreActionResult(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("completed", c.c_uint8),
        ("reset_dependencies", c.c_uint8),
        ("phase", c.c_uint32),
    ]


def bytes_buffer(data: bytes):
    return (c.c_uint8 * len(data)).from_buffer_copy(data)


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


class ActionCoreTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            subprocess.run([str(PROJECT / "scripts/build_action_core.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_core_initialize_values.argtypes = [
            c.POINTER(ActionCoreWorld)
        ]
        cls.lib.action_core_initialize_values.restype = c.c_int
        cls.lib.action_core_apply_set_value.argtypes = [
            c.POINTER(ActionCoreWorld), c.POINTER(c.c_uint8), c.c_size_t
        ]
        cls.lib.action_core_apply_set_value.restype = c.c_int
        cls.lib.action_core_apply_event_flags.argtypes = [
            c.POINTER(ActionCoreWorld), c.POINTER(c.c_uint8), c.c_size_t, c.c_size_t
        ]
        cls.lib.action_core_apply_event_flags.restype = c.c_int
        cls.lib.action_core_apply_difficulty.argtypes = [
            c.POINTER(ActionCoreWorld), c.POINTER(c.c_uint8), c.c_size_t
        ]
        cls.lib.action_core_apply_difficulty.restype = c.c_int
        cls.lib.action_core_finish_action.argtypes = [
            c.c_uint8, c.c_uint8, c.POINTER(ActionCoreActionResult)
        ]
        cls.lib.action_core_finish_action.restype = c.c_int
        cls.lib.action_core_dispatch.argtypes = [
            c.POINTER(ActionCoreWorld), c.POINTER(ActionCoreAction), c.c_size_t,
            c.POINTER(ActionCoreActionResult)
        ]
        cls.lib.action_core_dispatch.restype = c.c_int

    def world(self, flag_count=16):
        flags = (c.c_int32 * flag_count)(*([0x12345678] * flag_count))
        world = ActionCoreWorld()
        world.event_flags = flags
        world.event_flag_count = flag_count
        return world, flags

    def test_initialize_values_writes_all_sentinels_and_preserves_other_state(self):
        """Covers action_core_initialize_values (0x44aff2)."""
        world, flags = self.world(8)
        world.short_values[:] = [index - 15 for index in range(30)]
        world.float_values[:] = [float(index) + 0.25 for index in range(10)]
        world.difficulty = -1234
        original_flags = list(flags)
        original_pointer = c.cast(world.event_flags, c.c_void_p).value
        original_count = world.event_flag_count

        self.assertEqual(
            self.lib.action_core_initialize_values(c.byref(world)), OK
        )

        self.assertEqual(list(world.short_values), [9999] * 30)
        self.assertEqual(list(world.float_values), [9999.0] * 10)
        self.assertEqual(world.difficulty, -1234)
        self.assertEqual(list(flags), original_flags)
        self.assertEqual(c.cast(world.event_flags, c.c_void_p).value,
                         original_pointer)
        self.assertEqual(world.event_flag_count, original_count)
        self.assertEqual(
            c.string_at(c.addressof(world), 100),
            bytes.fromhex("0f27" * 30 + "003c1c46" * 10),
        )

        world.event_flags = c.POINTER(c.c_int32)()
        world.event_flag_count = 7
        self.assertEqual(
            self.lib.action_core_initialize_values(c.byref(world)), OK
        )
        self.assertFalse(bool(world.event_flags))
        self.assertEqual(world.event_flag_count, 7)

    def test_initialize_values_rejects_null_world(self):
        self.assertEqual(self.lib.action_core_initialize_values(None), ERR_ARGUMENT)

    def test_set_value_short_add_wraps_and_sentinel_replaces(self):
        world, _flags = self.world()
        world.short_values[0] = 32760
        body = bytes_buffer(bytes((0, 0)) + i16(20))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.short_values[0], -32756)

        world.short_values[29] = 9999
        body = bytes_buffer(bytes((29, 0)) + i16(-4))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.short_values[29], -4)

    def test_set_value_short_and_float_modes_and_float_sentinel(self):
        world, _flags = self.world()
        world.short_values[3] = 11
        body = bytes_buffer(bytes((3, 7)) + i16(-2))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.short_values[3], -2)

        world.float_values[0] = 2.5
        body = bytes_buffer(bytes((30, 0)) + i16(-3))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.float_values[0], -0.5)
        world.float_values[9] = 9999.0
        body = bytes_buffer(bytes((39, 0)) + i16(12))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.float_values[9], 12.0)

    def test_set_value_preserves_ieee_nan_and_infinity_behavior(self):
        world, _flags = self.world()
        world.float_values[0] = math.inf
        body = bytes_buffer(bytes((30, 0)) + i16(-1))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertTrue(math.isinf(world.float_values[0]))
        world.float_values[1] = math.nan
        body = bytes_buffer(bytes((31, 0)) + i16(1))
        self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertTrue(math.isnan(world.float_values[1]))

    def test_set_value_index_40_and_above_is_original_noop(self):
        world, _flags = self.world()
        world.short_values[0] = 5
        world.float_values[9] = 7.0
        for index in (40, 255):
            body = bytes_buffer(bytes((index, 0)) + i16(100))
            self.assertEqual(self.lib.action_core_apply_set_value(c.byref(world), body, 4), OK)
        self.assertEqual(world.short_values[0], 5)
        self.assertEqual(world.float_values[9], 7.0)

    def test_event_flag_pairs_skip_minus_one_and_sign_extend_values(self):
        world, flags = self.world(8)
        pairs = b"".join((i16(index) + i16(value)) for index, value in
                          ((0, -32768), (-1, 42), (7, -1234), (3, 32767)))
        self.assertEqual(
            self.lib.action_core_apply_event_flags(c.byref(world), bytes_buffer(pairs),
                                                   len(pairs), 4),
            OK,
        )
        self.assertEqual((flags[0], flags[7], flags[3]), (-32768, -1234, 32767))
        self.assertEqual(flags[1], 0x12345678)

    def test_event_flag_batch_rejects_bad_later_index_without_partial_write(self):
        world, flags = self.world(4)
        pairs = i16(1) + i16(7) + i16(4) + i16(8)
        self.assertEqual(
            self.lib.action_core_apply_event_flags(c.byref(world), bytes_buffer(pairs),
                                                   len(pairs), 2),
            ERR_EVENT_FLAG_BOUNDS,
        )
        self.assertEqual(list(flags), [0x12345678] * 4)
        negative_index = i16(-2) + i16(9)
        self.assertEqual(
            self.lib.action_core_apply_event_flags(
                c.byref(world), bytes_buffer(negative_index), len(negative_index), 1
            ),
            ERR_EVENT_FLAG_BOUNDS,
        )
        self.assertEqual(list(flags), [0x12345678] * 4)

    def test_difficulty_update_is_atomic_and_optionally_writes_flag(self):
        world, flags = self.world(3)
        body = bytes_buffer(i16(-123) + i16(2) + i16(-300))
        self.assertEqual(self.lib.action_core_apply_difficulty(c.byref(world), body, 6), OK)
        self.assertEqual(world.difficulty, -123)
        self.assertEqual(flags[2], -300)

        body = bytes_buffer(i16(9) + i16(-1) + i16(77))
        self.assertEqual(self.lib.action_core_apply_difficulty(c.byref(world), body, 6), OK)
        self.assertEqual(world.difficulty, 9)
        before = list(flags)
        body = bytes_buffer(i16(100) + i16(3) + i16(77))
        self.assertEqual(
            self.lib.action_core_apply_difficulty(c.byref(world), body, 6),
            ERR_EVENT_FLAG_BOUNDS,
        )
        self.assertEqual(world.difficulty, 9)
        self.assertEqual(list(flags), before)
        invalid_negative = bytes_buffer(i16(-8) + i16(-2) + i16(77))
        self.assertEqual(
            self.lib.action_core_apply_difficulty(c.byref(world), invalid_negative, 6),
            ERR_EVENT_FLAG_BOUNDS,
        )
        self.assertEqual(world.difficulty, 9)
        self.assertEqual(list(flags), before)

    def test_post_completion_subtypes(self):
        result = ActionCoreActionResult()
        self.assertEqual(self.lib.action_core_finish_action(1, 0, c.byref(result)), OK)
        self.assertEqual((result.completed, result.phase, result.reset_dependencies), (1, 0, 0))
        self.assertEqual(self.lib.action_core_finish_action(2, 1, c.byref(result)), OK)
        self.assertEqual((result.completed, result.phase, result.reset_dependencies), (0, 0, 1))
        self.assertEqual(self.lib.action_core_finish_action(7, 1, c.byref(result)), OK)
        self.assertEqual((result.completed, result.phase, result.reset_dependencies), (1, 0, 0))

    def make_action(self, action_type, subtype, data, *, eligible=True,
                    completed=False, phase=9):
        storage = bytes_buffer(data) if data else None
        pointer = c.cast(storage, c.POINTER(c.c_uint8)) if storage is not None else None
        action = ActionCoreAction(
            action_type, subtype, int(eligible), int(completed), phase,
            pointer, len(data)
        )
        return action, storage

    def test_dispatch_is_ordered_and_preserves_ineligible_actions(self):
        world, flags = self.world(8)
        first, keep_first = self.make_action(0x61, 0, i16(2) + i16(10) + i16(2) + i16(20))
        skipped, keep_skipped = self.make_action(
            0x71, 1, i16(100) + i16(1) + i16(99), eligible=False,
            completed=False, phase=17
        )
        second, keep_second = self.make_action(0x6B, 2, i16(2) + i16(30) +
            b"".join(i16(-1) + i16(0) for _ in range(9)))
        actions = (ActionCoreAction * 3)(first, skipped, second)
        results = (ActionCoreActionResult * 3)()
        self.assertEqual(self.lib.action_core_dispatch(c.byref(world), actions, 3, results), OK)
        self.assertEqual(flags[2], 30)
        self.assertEqual((results[0].recognized, results[0].applied, results[0].completed,
                          results[0].phase), (1, 1, 0, 0))
        self.assertEqual((results[1].recognized, results[1].applied, results[1].completed,
                          results[1].phase), (1, 0, 0, 17))
        self.assertEqual((results[2].recognized, results[2].applied, results[2].completed,
                          results[2].reset_dependencies), (1, 1, 0, 1))
        self.assertTrue(all(x is not None for x in (keep_first, keep_skipped, keep_second)))

    def test_dispatch_reports_eligible_unknown_type_to_owner(self):
        world, flags = self.world(8)
        action, keep_action = self.make_action(0xFE, 1, b"opaque")
        actions = (ActionCoreAction * 1)(action)
        results = (ActionCoreActionResult * 1)()
        self.assertEqual(self.lib.action_core_dispatch(c.byref(world), actions, 1, results),
                         ERR_UNSUPPORTED)
        self.assertEqual(list(flags), [0x12345678] * 8)
        self.assertEqual(results[0].recognized, 0)
        self.assertTrue(keep_action is not None)

    def test_difficulty_action_forces_completion_and_preserves_phase(self):
        world, flags = self.world(8)
        skip_flag, keep_skip = self.make_action(
            0x71, 2, i16(-120) + i16(-1) + i16(500), phase=19
        )
        write_flag, keep_write = self.make_action(
            0x71, 2, i16(77) + i16(4) + i16(-301), phase=23
        )
        actions = (ActionCoreAction * 2)(skip_flag, write_flag)
        results = (ActionCoreActionResult * 2)()
        self.assertEqual(self.lib.action_core_dispatch(c.byref(world), actions, 2, results), OK)
        self.assertEqual(world.difficulty, 77)
        self.assertEqual(flags[4], -301)
        self.assertEqual((results[0].completed, results[0].phase,
                          results[0].reset_dependencies), (1, 19, 0))
        self.assertEqual((results[1].completed, results[1].phase,
                          results[1].reset_dependencies), (1, 23, 0))
        self.assertTrue(keep_skip is not None and keep_write is not None)

    def test_dispatch_preflights_all_actions_before_state_writes(self):
        world, flags = self.world(4)
        valid, keep_valid = self.make_action(0x61, 1, i16(0) + i16(14) + i16(-1) + i16(0))
        invalid, keep_invalid = self.make_action(0x6B, 1,
            i16(1) + i16(23) + b"".join(i16(-1) + i16(0) for _ in range(8)) +
            i16(4) + i16(9))
        actions = (ActionCoreAction * 2)(valid, invalid)
        results = (ActionCoreActionResult * 2)()
        self.assertEqual(self.lib.action_core_dispatch(c.byref(world), actions, 2, results),
                         ERR_EVENT_FLAG_BOUNDS)
        self.assertEqual(list(flags), [0x12345678] * 4)
        self.assertTrue(keep_valid is not None and keep_invalid is not None)

    def test_dispatch_accepts_zero_actions(self):
        world, _flags = self.world()
        self.assertEqual(self.lib.action_core_dispatch(c.byref(world), None, 0, None), OK)


if __name__ == "__main__":
    unittest.main()
