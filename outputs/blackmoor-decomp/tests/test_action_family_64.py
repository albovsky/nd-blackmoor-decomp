"""Behavioral tests for the isolated original action-family 0x64 kernel."""

from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libactionfamily64.dylib"
OK = 0
ERR_ARGUMENT = 1
ERR_BODY = 2
ERR_UNSUPPORTED = 3
ERR_BACKEND = 4


class Decoded(c.Structure):
    _fields_ = [("operation", c.c_uint8), ("value_1", c.c_int16),
                ("value_2", c.c_int16)]


class World(c.Structure):
    _fields_ = [
        ("clock_value_585d51", c.c_int16),
        ("clock_value_585d4f", c.c_int16),
        ("clock_total_585d4b", c.c_int32),
        ("clock_deadline_585d55", c.c_uint32),
        ("deadline_offset_5b0280", c.c_int16),
        ("timer_controller_active_001c", c.c_uint32),
        ("timer_controller_tick_0456", c.c_uint32),
        ("timer_controller_flag_0326_0061c6ad", c.c_uint8),
    ]


class Action(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("eligible", c.c_uint8),
        ("completed_before", c.c_uint8),
        ("phase_before", c.c_uint32),
        ("body", c.POINTER(c.c_uint8)),
        ("body_length", c.c_size_t),
    ]


TickCallback = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))


class Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("get_tick_count", TickCallback)]


class Result(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("completion_valid", c.c_uint8),
        ("completed", c.c_uint8),
        ("reset_dependencies", c.c_uint8),
        ("phase", c.c_uint32),
        ("world", World),
    ]


def bytes_buffer(data: bytes):
    return (c.c_uint8 * len(data)).from_buffer_copy(data) if data else None


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


def original_body(operation: int, value_1: int = 0, value_2: int = 0) -> bytes:
    return bytes((operation,)) + i16(value_1) + i16(value_2)


class TickSource:
    def __init__(self, values, fail_at=None, status=1):
        self.values = list(values)
        self.calls = 0
        self.fail_at = fail_at
        self.status = status
        self.callback = TickCallback(self.get)

    def get(self, _context, value_out):
        self.calls += 1
        if self.fail_at == self.calls:
            return self.status
        if not self.values:
            return 2
        value_out[0] = self.values.pop(0)
        return 0

    def backend(self):
        return Backend(None, self.callback)


class ActionFamily64Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        built = subprocess.run(
            [str(PROJECT / "scripts/build_action_family_64.sh")],
            text=True, capture_output=True,
        )
        if built.returncode != 0:
            raise AssertionError(
                f"action-family 0x64 build failed before behavior tests:\n{built.stdout}{built.stderr}"
            )
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.action_family64_decode.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded), c.POINTER(c.c_size_t)
        ]
        cls.lib.action_family64_decode.restype = c.c_int
        cls.lib.action_family64_step.argtypes = [
            c.POINTER(Action), c.POINTER(World), c.POINTER(Backend), c.POINTER(Result)
        ]
        cls.lib.action_family64_step.restype = c.c_int

    @staticmethod
    def initial_world():
        return World(2, 58, -123, 0x12345678, -7, 0, 0xAABBCCDD, 0x5A)

    def decode(self, raw):
        body = bytes_buffer(raw)
        decoded = Decoded()
        consumed = c.c_size_t(999)
        status = self.lib.action_family64_decode(
            body, len(raw), c.byref(decoded), c.byref(consumed)
        )
        return status, decoded, consumed.value

    def step(self, raw, world=None, *, operation_subtype=1, eligible=1,
             completed_before=0, phase_before=17, ticks=(100,)):
        world = world or self.initial_world()
        body = bytes_buffer(raw)
        action = Action(0x64, operation_subtype, eligible, completed_before,
                        phase_before, body, len(raw))
        result = Result()
        source = TickSource(ticks)
        status = self.lib.action_family64_step(
            c.byref(action), c.byref(world), c.byref(source.backend()), c.byref(result)
        )
        return status, world, result, source

    def test_decode_reads_unaligned_signed_words_and_requires_exactly_five_bytes(self):
        raw = bytes.fromhex("01 00 80 ff 7f")
        status, decoded, consumed = self.decode(raw)
        self.assertEqual(status, OK)
        self.assertEqual((decoded.operation, decoded.value_1, decoded.value_2),
                         (1, -32768, 32767))
        self.assertEqual(consumed, 5)

        for malformed in (raw[:4], raw + b"\0"):
            decoded = Decoded(0xEE, -12, 34)
            consumed = c.c_size_t(77)
            status = self.lib.action_family64_decode(
                bytes_buffer(malformed), len(malformed), c.byref(decoded), c.byref(consumed)
            )
            self.assertEqual(status, ERR_BODY)
            self.assertEqual((decoded.operation, decoded.value_1, decoded.value_2),
                             (0xEE, -12, 34))
            self.assertEqual(consumed.value, 77)

    def test_all_seven_corpus_bodies_decode_to_original_operation_and_values(self):
        bodies = [
            original_body(1, 3, 15), original_body(1, 3, 15),
            original_body(1, 3, 15), original_body(1, 3, 15),
            original_body(1, 3, 15), original_body(1, 17, 58),
            original_body(1, 18, 0),
        ]
        self.assertEqual(len(bodies), 7)
        for body in bodies:
            self.assertEqual(len(body), 5)
            status, decoded, consumed = self.decode(body)
            self.assertEqual(status, OK)
            self.assertEqual(decoded.operation, 1)
            self.assertEqual(consumed, 5)
        self.assertEqual([(self.decode(body)[1].value_1,
                           self.decode(body)[1].value_2) for body in bodies],
                         [(3, 15)] * 5 + [(17, 58), (18, 0)])

    def test_mode_one_sets_clock_and_finishes_subtype_one(self):
        status, _before, result, source = self.step(original_body(1, 3, 15), ticks=(100,))
        self.assertEqual(status, OK)
        self.assertEqual(source.calls, 1)
        self.assertEqual((result.world.clock_value_585d51,
                          result.world.clock_value_585d4f,
                          result.world.clock_total_585d4b,
                          result.world.clock_deadline_585d55), (3, 15, 195, 93))
        self.assertEqual((result.completed, result.reset_dependencies, result.phase), (1, 0, 0))
        self.assertEqual(result.applied, 1)
        self.assertEqual(result.world.timer_controller_flag_0326_0061c6ad, 0x5A)

    def test_mode_two_adds_signed_words_with_int16_wrap(self):
        world = self.initial_world()
        world.clock_value_585d51 = 32760
        world.clock_value_585d4f = -32760
        status, _before, result, _source = self.step(
            original_body(2, 20, -20), world=world, ticks=(0xFFFFFFFF,)
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.world.clock_value_585d51,
                          result.world.clock_value_585d4f,
                          result.world.clock_total_585d4b), (-32756, 32756, -1932604))
        self.assertEqual(result.world.clock_deadline_585d55, 0xFFFFFFF8)

    def test_mode_three_active_controller_uses_two_ordered_tick_reads(self):
        world = self.initial_world()
        world.timer_controller_active_001c = 1
        status, _before, result, source = self.step(
            original_body(3, 123, -456), world=world, ticks=(0xFFFFFFF2, 0x10)
        )
        self.assertEqual(status, OK)
        self.assertEqual(source.calls, 2)
        self.assertEqual(result.world.timer_controller_tick_0456, 0xFFFFFFED)
        self.assertEqual(result.world.timer_controller_flag_0326_0061c6ad, 1)
        self.assertEqual(result.world.clock_deadline_585d55, 9)
        self.assertEqual((result.world.clock_value_585d51,
                          result.world.clock_value_585d4f), (2, 58))

    def test_mode_three_inactive_controller_skips_first_tick_read_but_sets_flag(self):
        world = self.initial_world()
        status, _before, result, source = self.step(original_body(3), world=world, ticks=(0x10,))
        self.assertEqual(status, OK)
        self.assertEqual(source.calls, 1)
        self.assertEqual(result.world.timer_controller_tick_0456, 0xAABBCCDD)
        self.assertEqual(result.world.timer_controller_flag_0326_0061c6ad, 1)

    def test_modes_four_five_and_six_reset_the_shared_controller_byte(self):
        world = self.initial_world()
        for operation, first, second, want_clock in (
            (4, 99, 88, (2, 58)),
            (5, 9, 11, (9, 11)),
            (6, 1, 5, (3, 63)),
        ):
            world.clock_value_585d51, world.clock_value_585d4f = 2, 58
            world.timer_controller_flag_0326_0061c6ad = 0x7F
            status, _before, result, source = self.step(
                original_body(operation, first, second), world=world, ticks=(27,)
            )
            self.assertEqual(status, OK)
            self.assertEqual(source.calls, 1)
            self.assertEqual((result.world.clock_value_585d51,
                              result.world.clock_value_585d4f), want_clock)
            self.assertEqual(result.world.timer_controller_flag_0326_0061c6ad, 0)
            self.assertEqual(result.world.clock_total_585d4b, want_clock[0] * 60 + want_clock[1])

    def test_zero_and_unknown_operations_still_recompute_deadline_and_finish(self):
        for operation in (0, 7, 255):
            status, _before, result, source = self.step(
                original_body(operation, 100, -200),
                operation_subtype=0, completed_before=0, phase_before=88, ticks=(123,)
            )
            self.assertEqual(status, OK)
            self.assertEqual(source.calls, 1)
            self.assertEqual((result.world.clock_value_585d51,
                              result.world.clock_value_585d4f), (2, 58))
            self.assertEqual(result.world.clock_total_585d4b, 178)
            self.assertEqual(result.world.clock_deadline_585d55, 116)
            self.assertEqual((result.completed, result.reset_dependencies, result.phase), (0, 0, 0))

    def test_subtype_two_clears_completion_requests_reset_and_resets_phase(self):
        status, _before, result, _source = self.step(
            original_body(1, 4, 5), operation_subtype=2,
            completed_before=0, phase_before=77, ticks=(10,)
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.completed, result.reset_dependencies, result.phase), (0, 1, 0))

    def test_nonstandard_subtype_preserves_completion_but_resets_phase(self):
        status, _before, result, _source = self.step(
            original_body(1, 4, 5), operation_subtype=7,
            completed_before=0, phase_before=77, ticks=(10,)
        )
        self.assertEqual(status, OK)
        self.assertEqual((result.completed, result.reset_dependencies, result.phase), (0, 0, 0))

    def test_false_eligibility_preserves_world_and_lifecycle_without_tick_call(self):
        world = self.initial_world()
        before = c.string_at(c.addressof(world), c.sizeof(world))
        action = Action(0x64, 2, 0, 0, 41, bytes_buffer(original_body(1, 8, 9)), 5)
        source = TickSource(())
        backend = source.backend()
        result = Result()
        status = self.lib.action_family64_step(
            c.byref(action), c.byref(world), c.byref(backend), c.byref(result)
        )
        self.assertEqual(status, OK)
        self.assertEqual(source.calls, 0)
        self.assertEqual(c.string_at(c.addressof(result.world), c.sizeof(World)), before)
        self.assertEqual((result.applied, result.completed, result.reset_dependencies,
                          result.phase), (0, 0, 0, 41))

    def test_malformed_body_is_rejected_before_clock_backend_or_world_change(self):
        world = self.initial_world()
        before = c.string_at(c.addressof(world), c.sizeof(world))
        action = Action(0x64, 1, 1, 0, 9, bytes_buffer(b"\x01\x02\x03\x04"), 4)
        source = TickSource((100,))
        backend = source.backend()
        result = Result()
        status = self.lib.action_family64_step(
            c.byref(action), c.byref(world), c.byref(backend), c.byref(result)
        )
        self.assertEqual(status, ERR_BODY)
        self.assertEqual(source.calls, 0)
        self.assertEqual(c.string_at(c.addressof(world), c.sizeof(world)), before)

    def test_failed_second_tick_read_does_not_commit_partial_clock_or_controller_writes(self):
        world = self.initial_world()
        world.timer_controller_active_001c = 1
        before = c.string_at(c.addressof(world), c.sizeof(world))
        action = Action(0x64, 1, 1, 0, 7, bytes_buffer(original_body(3)), 5)
        source = TickSource((100,), fail_at=2, status=2)
        backend = source.backend()
        result = Result()
        status = self.lib.action_family64_step(
            c.byref(action), c.byref(world), c.byref(backend), c.byref(result)
        )
        self.assertEqual(status, ERR_BACKEND)
        self.assertEqual(source.calls, 2)
        self.assertEqual(c.string_at(c.addressof(world), c.sizeof(world)), before)

    def test_wrong_family_is_rejected_without_world_mutation(self):
        world = self.initial_world()
        before = c.string_at(c.addressof(world), c.sizeof(world))
        action = Action(0x63, 1, 1, 0, 7, bytes_buffer(original_body(1, 3, 15)), 5)
        source = TickSource((100,))
        backend = source.backend()
        result = Result()
        status = self.lib.action_family64_step(
            c.byref(action), c.byref(world), c.byref(backend), c.byref(result)
        )
        self.assertEqual(status, ERR_UNSUPPORTED)
        self.assertEqual(source.calls, 0)
        self.assertEqual(c.string_at(c.addressof(world), c.sizeof(world)), before)


if __name__ == "__main__":
    unittest.main()
