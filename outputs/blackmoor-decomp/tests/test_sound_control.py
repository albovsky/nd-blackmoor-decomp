#!/usr/bin/env python3
"""Portable checks for recovered DirectSound command/state behavior."""

from __future__ import annotations

import ctypes as C
import math
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libsoundcontrol.dylib"

OK = 0
ERR_ARGUMENT = 1
ERR_UNSUPPORTED = 2
HOST_OK = 0
HOST_ERROR = 1
HOST_UNSUPPORTED = 2
UPDATE_NONE = 0
UPDATE_RESTART = 1
UPDATE_RANDOM_REPEAT = 2


class Channel(C.Structure):
    _fields_ = [
        ("volume_category", C.c_uint16),
        ("volume_update_state", C.c_uint16),
        ("raw_flags", C.c_uint16),
        ("reserved", C.c_uint16),
        ("raw_control", C.c_uint32),
        ("first_scalar", C.c_float),
        ("second_scalar", C.c_float),
        ("first_attenuation", C.c_int32),
        ("second_attenuation", C.c_int32),
        ("resource_ready", C.c_uint32),
        ("stream_state", C.c_uint32),
        ("update_gate_287", C.c_uint32),
        ("update_gate_16e", C.c_uint32),
        ("update_gate_172", C.c_uint32),
        ("buffer_available", C.c_uint32),
        ("repeat_marker", C.c_uint32),
        ("repeat_min", C.c_int32),
        ("repeat_max", C.c_int32),
        ("repeat_delay", C.c_uint32),
        ("repeat_due_tick", C.c_uint32),
    ]


class State(C.Structure):
    _fields_ = [
        ("channels", Channel * 32),
        ("master", C.c_float * 4),
        ("device_ready", C.c_uint32),
        ("device_state", C.c_uint32),
        ("device_error", C.c_uint32),
        ("host_result", C.c_int32),
    ]


class Result(C.Structure):
    _fields_ = [
        ("original_error", C.c_uint32),
        ("play_flags", C.c_uint32),
        ("tick", C.c_uint32),
        ("repeat_delay", C.c_uint32),
        ("repeat_due_tick", C.c_uint32),
        ("play_attempted", C.c_uint32),
        ("played", C.c_uint32),
        ("update_kind", C.c_uint32),
    ]


class MasterResult(C.Structure):
    _fields_ = [
        ("updated_channels", C.c_uint32),
        ("volume_calls", C.c_uint32),
        ("failed_channel", C.c_uint16),
        ("has_failed_channel", C.c_uint16),
        ("original_error", C.c_uint32),
    ]


PlayFn = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_uint16, C.c_uint32,
                     C.POINTER(C.c_int32))
VolumeFn = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_uint16, C.c_int32,
                       C.POINTER(C.c_int32))
TickFn = C.CFUNCTYPE(C.c_uint32, C.c_void_p)
RandomFn = C.CFUNCTYPE(C.c_uint32, C.c_void_p)
FadeFn = C.CFUNCTYPE(None, C.c_void_p, C.c_uint16)


class Host(C.Structure):
    _fields_ = [
        ("context", C.c_void_p),
        ("play_buffer", PlayFn),
        ("set_first_attenuation", VolumeFn),
        ("tick_count", TickFn),
        ("random_value", RandomFn),
        ("fade_stage_1", FadeFn),
        ("fade_stage_2", FadeFn),
        ("fade_stage_3", FadeFn),
    ]


class Recorder:
    def __init__(self):
        self.play_status = HOST_OK
        self.volume_status = HOST_OK
        self.host_result = 0
        self.tick = 0
        self.random = 0
        self.events: list[tuple] = []

        @PlayFn
        def play(_context, channel, flags, host_result):
            self.events.append(("play", channel, flags))
            host_result[0] = self.host_result
            return self.play_status

        @VolumeFn
        def volume(_context, channel, attenuation, host_result):
            self.events.append(("volume", channel, attenuation))
            host_result[0] = self.host_result
            return self.volume_status

        @TickFn
        def tick_count(_context):
            self.events.append(("tick", self.tick))
            return self.tick

        @RandomFn
        def random_value(_context):
            self.events.append(("random", self.random))
            return self.random

        def fade(name):
            @FadeFn
            def call(_context, channel):
                self.events.append((name, channel))
            return call

        self.callbacks = [play, volume, tick_count, random_value,
                          fade("fade1"), fade("fade2"), fade("fade3")]
        self.host = Host(None, *self.callbacks)


class SoundControlTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_sound_control.sh")], check=True)
        cls.lib = C.CDLL(str(LIBRARY))
        cls.lib.sound_control_initialize_categories.argtypes = [C.POINTER(C.c_uint8)]
        cls.lib.sound_control_initialize_categories.restype = C.c_int
        cls.lib.sound_control_calculate_attenuation.argtypes = [
            C.c_float, C.c_float, C.c_uint16, C.POINTER(C.c_int32)
        ]
        cls.lib.sound_control_calculate_attenuation.restype = C.c_int
        cls.lib.sound_control_play.argtypes = [
            C.POINTER(State), C.c_uint16, C.POINTER(Host), C.POINTER(Result)
        ]
        cls.lib.sound_control_play.restype = C.c_int
        cls.lib.sound_control_update.argtypes = [
            C.POINTER(State), C.c_uint16, C.POINTER(Host), C.POINTER(Result)
        ]
        cls.lib.sound_control_update.restype = C.c_int
        cls.lib.sound_control_set_master_absolute.argtypes = [
            C.POINTER(State), C.c_uint16, C.c_uint16, C.c_uint16,
            C.POINTER(Host), C.POINTER(MasterResult)
        ]
        cls.lib.sound_control_set_master_absolute.restype = C.c_int

    def state(self):
        state = State()
        state.device_ready = 1
        for channel in state.channels:
            channel.resource_ready = 1
            channel.buffer_available = 1
        return state

    def play(self, state, index, recorder):
        result = Result()
        status = self.lib.sound_control_play(
            C.byref(state), index, C.byref(recorder.host), C.byref(result)
        )
        return status, result

    def update(self, state, index, recorder):
        result = Result()
        status = self.lib.sound_control_update(
            C.byref(state), index, C.byref(recorder.host), C.byref(result)
        )
        return status, result

    def test_channel_categories_match_original_32_slot_initializer(self):
        values = (C.c_uint8 * 32)()
        self.assertEqual(self.lib.sound_control_initialize_categories(values), OK)
        self.assertEqual(list(values), [
            1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 3, 3,
            3, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1, 0, 2,
        ])

    def test_attenuation_keeps_independent_scalars_and_supported_x87_cw(self):
        first = C.c_int32()
        second = C.c_int32()
        for cw in (0x023F, 0x027F):
            self.assertEqual(self.lib.sound_control_calculate_attenuation(
                0.75, 0.85, cw, C.byref(first)), OK)
            self.assertEqual(self.lib.sound_control_calculate_attenuation(
                0.25, 0.85, cw, C.byref(second)), OK)
            self.assertEqual(first.value, -1035)
            self.assertNotEqual(first.value, second.value)
        self.assertEqual(self.lib.sound_control_calculate_attenuation(
            0.5, 0.5, 0x033F, C.byref(first)), ERR_UNSUPPORTED)
        self.assertEqual(self.lib.sound_control_calculate_attenuation(
            math.nan, 1.0, 0x023F, C.byref(first)), ERR_ARGUMENT)

    def test_play_flags_keep_raw_control_stream_state_and_flags_separate(self):
        """sound_control_play, the Play wrapper (original 0x4f6059): loop flag and gate clear."""
        cases = [
            (1, 0, 0, 0),
            (0, 1, 0, 1),
            (0, 0, 0, 0),
            (1, 0x100, 0, 1),
            (1, 0, 1, 1),
            (0, 0x100, 1, 1),
        ]
        for control, flags, stream, expected in cases:
            with self.subTest(control=control, flags=flags, stream=stream):
                state, recorder = self.state(), Recorder()
                channel = state.channels[13]
                channel.raw_control = control
                channel.raw_flags = flags
                channel.stream_state = stream
                channel.update_gate_287 = 7
                status, result = self.play(state, 13, recorder)
                self.assertEqual(status, OK)
                self.assertEqual(result.play_flags, expected)
                self.assertEqual(result.played, 1)
                self.assertEqual(channel.update_gate_287, 0)
                self.assertEqual(recorder.events[-1], ("play", 13, expected))

    def test_play_errors_preserve_original_codes_and_ordered_state(self):
        """sound_control_play (original 0x4f6059): error words 0x3ea, 0x3ef, 0x403 and their state."""
        state, recorder = self.state(), Recorder()
        state.device_ready = 0
        status, result = self.play(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.original_error, 0x3EA)
        self.assertEqual((state.device_state, state.device_error), (0, 0x3EA))
        self.assertEqual(recorder.events, [])

        state, recorder = self.state(), Recorder()
        state.channels[13].resource_ready = 0
        status, result = self.play(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.original_error, 0x3EF)
        self.assertEqual(recorder.events, [])

        state, recorder = self.state(), Recorder()
        recorder.play_status = HOST_ERROR
        recorder.host_result = -1
        status, result = self.play(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.original_error, 0x403)
        self.assertEqual(state.host_result, -1)
        self.assertEqual((state.device_state, state.device_error), (0, 0x403))
        self.assertEqual(recorder.events, [("play", 13, 0)])

    def test_update_restart_random_repeat_wrap_and_false_gates(self):
        """sound_control_update, the channel update (original 0x4f55d5): restart, random repeat, gates."""
        state, recorder = self.state(), Recorder()
        ch = state.channels[13]
        ch.raw_control = 0
        recorder.tick = 0xFFFFFFF8
        status, result = self.update(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.update_kind, UPDATE_RESTART)
        self.assertEqual(
            (result.original_error, result.play_flags,
             result.play_attempted, result.played),
            (0, 0, 1, 1),
        )
        self.assertEqual(recorder.events[:2], [("tick", 0xFFFFFFF8), ("play", 13, 0)])

        state, recorder = self.state(), Recorder()
        ch = state.channels[13]
        ch.raw_control = 0
        ch.raw_flags = 0x10
        ch.repeat_min = 10
        ch.repeat_max = 20
        recorder.tick = 0xFFFFFFF8
        recorder.random = 23
        status, result = self.update(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.update_kind, UPDATE_RANDOM_REPEAT)
        self.assertEqual((ch.repeat_marker, ch.repeat_delay, ch.repeat_due_tick), (1, 13, 5))
        self.assertEqual((result.repeat_delay, result.repeat_due_tick), (13, 5))
        self.assertEqual(recorder.events, [("tick", 0xFFFFFFF8), ("random", 23)])

        state, recorder = self.state(), Recorder()
        ch = state.channels[13]
        ch.raw_control = 0
        ch.raw_flags = 0x10
        ch.repeat_min = 12
        ch.repeat_max = 12
        recorder.tick = 33
        status, result = self.update(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(ch.repeat_delay, 0)
        self.assertEqual(ch.repeat_due_tick, 33)
        self.assertEqual(recorder.events, [("tick", 33)])

        for field in ("update_gate_287", "update_gate_16e", "update_gate_172", "stream_state"):
            with self.subTest(gate=field):
                state, recorder = self.state(), Recorder()
                ch = state.channels[13]
                ch.raw_control = 0
                ch.raw_flags = 0x30
                setattr(ch, field, 1)
                status, result = self.update(state, 13, recorder)
                self.assertEqual(status, OK)
                self.assertEqual(result.update_kind, UPDATE_NONE)
                self.assertEqual(recorder.events, [("tick", 0)])

    def test_update_restart_result_fields_cover_original_failures(self):
        """sound_control_update (original 0x4f55d5): the restart's failure words through the Play wrapper."""
        cases = (
            ("device-not-ready", "device", 0x3EA, 0, 0),
            ("resource-not-ready", "resource", 0x3EF, 0, 0),
            ("buffer-missing", "buffer", 0x3EF, 0, 0),
            ("play-hresult-failure", "hresult", 0x403, 1, 0),
        )
        for name, failure, expected_error, expected_attempted, expected_played in cases:
            with self.subTest(failure=name):
                state, recorder = self.state(), Recorder()
                channel = state.channels[13]
                channel.raw_control = 0
                if failure == "device":
                    state.device_ready = 0
                elif failure == "resource":
                    channel.resource_ready = 0
                elif failure == "buffer":
                    channel.buffer_available = 0
                else:
                    recorder.play_status = HOST_ERROR
                    recorder.host_result = -1
                status, result = self.update(state, 13, recorder)
                self.assertEqual(status, OK)
                self.assertEqual(result.update_kind, UPDATE_RESTART)
                self.assertEqual(result.original_error, expected_error)
                self.assertEqual(
                    (result.play_flags, result.play_attempted, result.played),
                    (0, expected_attempted, expected_played),
                )
                self.assertEqual(state.device_error, expected_error)
                self.assertEqual(state.device_state, 0)
                self.assertEqual(recorder.events[0], ("tick", 0))
                self.assertEqual(
                    [event for event in recorder.events if event[0] == "play"],
                    [("play", 13, 0)] if expected_attempted else [],
                )

    def test_update_restart_preserves_result_on_unsupported_host(self):
        state, recorder = self.state(), Recorder()
        channel = state.channels[13]
        channel.raw_control = 0
        recorder.play_status = HOST_UNSUPPORTED
        status, result = self.update(state, 13, recorder)
        self.assertEqual(status, ERR_UNSUPPORTED)
        self.assertEqual(result.update_kind, UPDATE_RESTART)
        self.assertEqual(
            (result.original_error, result.play_flags,
             result.play_attempted, result.played),
            (0, 0, 1, 0),
        )
        self.assertEqual((state.device_error, state.device_state, state.host_result),
                         (0x3E8, 1, 0))
        self.assertEqual(recorder.events, [("tick", 0), ("play", 13, 0)])

    def test_update_orders_fade_boundaries_before_restart(self):
        """sound_control_update (original 0x4f55d5): the three fade stages run before the restart."""
        state, recorder = self.state(), Recorder()
        state.channels[13].raw_control = 0
        state.channels[13].raw_flags = 0x20
        status, result = self.update(state, 13, recorder)
        self.assertEqual(status, OK)
        self.assertEqual(result.update_kind, UPDATE_RESTART)
        self.assertEqual(recorder.events, [
            ("tick", 0), ("fade1", 13), ("fade2", 13), ("fade3", 13),
            ("play", 13, 0),
        ])

    def test_master_volume_clamps_and_refreshes_each_matching_active_channel(self):
        state, recorder = self.state(), Recorder()
        state.master[0] = 0.5
        for index, category, active, one, two in (
            (1, 0, 1, 0.75, 0.25), (2, 0, 1, 0.25, 0.75),
            (3, 1, 1, 0.5, 0.5), (4, 0, 0, 0.9, 0.1),
        ):
            channel = state.channels[index]
            channel.volume_category = category
            channel.volume_update_state = active
            channel.first_scalar, channel.second_scalar = one, two
            channel.buffer_available = 1
        result = MasterResult()
        status = self.lib.sound_control_set_master_absolute(
            C.byref(state), 0, 125, 0x023F,
            C.byref(recorder.host), C.byref(result)
        )
        self.assertEqual(status, OK)
        self.assertEqual(state.master[0], 1.0)
        self.assertEqual((result.updated_channels, result.volume_calls), (2, 2))
        self.assertNotEqual(state.channels[1].first_attenuation,
                            state.channels[1].second_attenuation)
        self.assertNotEqual(state.channels[2].first_attenuation,
                            state.channels[2].second_attenuation)
        self.assertEqual(recorder.events, [
            ("volume", 1, state.channels[1].first_attenuation),
            ("volume", 2, state.channels[2].first_attenuation),
        ])
        self.assertEqual(state.channels[3].first_attenuation, 0)
        self.assertEqual(state.channels[4].first_attenuation, 0)

    def test_master_volume_host_failures_keep_original_error_and_state_order(self):
        state, recorder = self.state(), Recorder()
        channel = state.channels[13]
        channel.volume_category = 0
        channel.volume_update_state = 1
        channel.first_scalar = 0.75
        channel.second_scalar = 0.25
        recorder.volume_status = HOST_ERROR
        recorder.host_result = -1
        result = MasterResult()
        status = self.lib.sound_control_set_master_absolute(
            C.byref(state), 0, 75, 0x023F,
            C.byref(recorder.host), C.byref(result)
        )
        self.assertEqual(status, OK)
        self.assertEqual(result.volume_calls, 1)
        self.assertEqual((result.has_failed_channel, result.failed_channel), (1, 13))
        self.assertEqual((state.host_result, state.device_state, state.device_error),
                         (-1, 0, 0x408))
        self.assertEqual(recorder.events, [
            ("volume", 13, channel.first_attenuation),
        ])

        state, recorder = self.state(), Recorder()
        state.device_ready = 0
        channel = state.channels[13]
        channel.volume_category = 0
        channel.volume_update_state = 1
        channel.first_scalar = 0.75
        channel.second_scalar = 0.25
        result = MasterResult()
        status = self.lib.sound_control_set_master_absolute(
            C.byref(state), 0, 75, 0x023F,
            C.byref(recorder.host), C.byref(result)
        )
        self.assertEqual(status, OK)
        self.assertEqual((state.device_state, state.device_error), (0, 0x3EA))
        self.assertEqual(result.original_error, 0x3EA)
        self.assertEqual(recorder.events, [])


if __name__ == "__main__":
    unittest.main()
