#!/usr/bin/env python3
"""Exercise the native AVAudioEngine adapter through its C ABI in offline mode."""

from __future__ import annotations

import ctypes
import math
import pathlib
import subprocess
import threading
import time
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]


class MacAudioRender(ctypes.Structure):
    _fields_ = [
        ("sample_rate", ctypes.c_uint32),
        ("channels", ctypes.c_uint32),
        ("frame_count", ctypes.c_uint64),
        ("interleaved_pcm", ctypes.POINTER(ctypes.c_float)),
    ]


class MacAudioTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        subprocess.run([str(PROJECT / "scripts/build_macos_audio.sh")], check=True)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libmacos_audio.dylib"))
        lib = cls.library
        lib.mac_audio_host_open.argtypes = [
            ctypes.c_int, ctypes.c_uint32, ctypes.c_uint32,
            ctypes.POINTER(ctypes.c_void_p), ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.mac_audio_host_open.restype = ctypes.c_int
        lib.mac_audio_host_close.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_size_t]
        lib.mac_audio_host_close.restype = ctypes.c_int
        lib.mac_audio_play.argtypes = [
            ctypes.c_void_p, ctypes.c_uint32, ctypes.POINTER(ctypes.c_float),
            ctypes.c_uint64, ctypes.c_uint32, ctypes.c_uint32, ctypes.c_float,
            ctypes.c_int, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.mac_audio_play.restype = ctypes.c_int
        lib.mac_audio_stop.argtypes = [ctypes.c_void_p, ctypes.c_uint32, ctypes.c_char_p, ctypes.c_size_t]
        lib.mac_audio_stop.restype = ctypes.c_int
        lib.mac_audio_set_gain.argtypes = [ctypes.c_void_p, ctypes.c_uint32, ctypes.c_float,
                                           ctypes.c_char_p, ctypes.c_size_t]
        lib.mac_audio_set_gain.restype = ctypes.c_int
        lib.mac_audio_is_playing.argtypes = [ctypes.c_void_p, ctypes.c_uint32,
                                             ctypes.POINTER(ctypes.c_int), ctypes.c_char_p,
                                             ctypes.c_size_t]
        lib.mac_audio_is_playing.restype = ctypes.c_int
        lib.mac_audio_host_render_offline.argtypes = [ctypes.c_void_p, ctypes.c_uint32,
                                                       ctypes.POINTER(MacAudioRender), ctypes.c_char_p,
                                                       ctypes.c_size_t]
        lib.mac_audio_host_render_offline.restype = ctypes.c_int
        lib.mac_audio_render_destroy.argtypes = [ctypes.POINTER(MacAudioRender)]
        lib.mac_audio_render_destroy.restype = None

    def setUp(self) -> None:
        self.host = ctypes.c_void_p()
        self.error = ctypes.create_string_buffer(512)

    def open_offline(self) -> None:
        status = self.library.mac_audio_host_open(1, 48000, 2, ctypes.byref(self.host),
                                                  self.error, ctypes.sizeof(self.error))
        if status != 0:
            self.skipTest("AVAudioEngine offline mode unavailable in this process: " +
                          self.error.value.decode(errors="replace"))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))

    def tearDown(self) -> None:
        if self.host:
            status = self.library.mac_audio_host_close(self.host, self.error, ctypes.sizeof(self.error))
            self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
            self.host = ctypes.c_void_p()
            # AVAudioEngine tears down its real-time/manual-render graph on
            # internal queues after stop; let that cleanup settle before the
            # next independent host in the test process is created.
            time.sleep(0.05)

    def play(self, slot: int, pcm: list[float], *, channels: int = 2,
             rate: int = 48000, gain: float = 1.0, loop: bool = False) -> int:
        source = (ctypes.c_float * len(pcm))(*pcm)
        status = self.library.mac_audio_play(
            self.host, slot, source, len(pcm) // channels, channels, rate,
            gain, int(loop), self.error, ctypes.sizeof(self.error),
        )
        return status

    def render(self, frames: int) -> list[float]:
        result = MacAudioRender()
        status = self.library.mac_audio_host_render_offline(
            self.host, frames, ctypes.byref(result), self.error, ctypes.sizeof(self.error)
        )
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        try:
            self.assertEqual((result.sample_rate, result.channels, result.frame_count),
                             (48000, 2, frames))
            return list(result.interleaved_pcm[: frames * 2])
        finally:
            self.library.mac_audio_render_destroy(ctypes.byref(result))

    def is_playing(self, slot: int) -> bool:
        result = ctypes.c_int()
        status = self.library.mac_audio_is_playing(self.host, slot, ctypes.byref(result),
                                                    self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        return bool(result.value)

    def test_offline_mode_preserves_stereo_order_gain_and_owned_copy(self) -> None:
        self.open_offline()
        pcm = [0.2, -0.6, -0.4, 0.8, 0.7, -0.1, 0.0, 0.3]
        source = (ctypes.c_float * len(pcm))(*pcm)
        status = self.library.mac_audio_play(self.host, 1, source, 4, 2, 48000, 0.5, 0,
                                             self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        for index in range(len(pcm)):
            source[index] = 0.0
        rendered = self.render(4)
        for actual, expected in zip(rendered, [sample * 0.5 for sample in pcm]):
            self.assertAlmostEqual(actual, expected, delta=1e-5)

    def test_slots_mix_and_gain_can_change(self) -> None:
        self.open_offline()
        source_frame_count = 4096
        slot_two_samples = [0.1 + index * 0.0001 for index in range(source_frame_count)]
        slot_three_samples = [0.2 + index * 0.0001 for index in range(source_frame_count)]
        slot_two_pcm = [sample for value in slot_two_samples for sample in (value, value)]
        slot_three_pcm = [sample for value in slot_three_samples for sample in (value, -value)]

        self.assertEqual(self.play(2, slot_two_pcm, gain=0.5), 0)
        self.assertEqual(self.play(3, slot_three_pcm, gain=0.25), 0)
        self.assertTrue(self.is_playing(2))
        self.assertTrue(self.is_playing(3))

        # AVAudioEngine can expose one newly attached player before the other
        # contributes to manual-rendered PCM. Establish readiness from a full
        # mixed block instead of assuming a fixed warm-up duration.
        startup_frame_limit = 512
        probe_frame_count = 8
        initial_gain = 0.5
        slot_three_gain = 0.25
        slot_two_index = 0
        slot_three_index = 0
        slot_two_started = False
        slot_three_started = False
        initial_mixed_streak = 0
        initial_mix_ready = False
        rendered_frames = 0

        def consume_initial_gain(block: list[float]) -> None:
            nonlocal slot_two_index, slot_three_index
            nonlocal slot_two_started, slot_three_started
            nonlocal initial_mixed_streak, initial_mix_ready

            for frame in range(len(block) // 2):
                left = block[2 * frame]
                right = block[2 * frame + 1]
                slot_two_value = (left + right) / (2.0 * initial_gain)
                slot_three_value = (left - right) / (2.0 * slot_three_gain)
                has_slot_two = abs(slot_two_value) > 1e-5
                has_slot_three = abs(slot_three_value) > 1e-5

                if has_slot_two:
                    self.assertLess(slot_two_index, source_frame_count)
                    self.assertAlmostEqual(
                        slot_two_value, slot_two_samples[slot_two_index], delta=2e-5
                    )
                    slot_two_index += 1
                    slot_two_started = True
                elif slot_two_started and slot_two_index < source_frame_count:
                    self.fail("slot 2 became silent before its scheduled PCM was rendered")

                if has_slot_three:
                    self.assertLess(slot_three_index, source_frame_count)
                    self.assertAlmostEqual(
                        slot_three_value, slot_three_samples[slot_three_index], delta=2e-5
                    )
                    slot_three_index += 1
                    slot_three_started = True
                elif slot_three_started and slot_three_index < source_frame_count:
                    self.fail("slot 3 became silent before its scheduled PCM was rendered")

                if has_slot_two and has_slot_three:
                    initial_mixed_streak += 1
                    if initial_mixed_streak >= 16:
                        initial_mix_ready = True
                else:
                    initial_mixed_streak = 0

        while rendered_frames < startup_frame_limit and not initial_mix_ready:
            frame_count = min(probe_frame_count, startup_frame_limit - rendered_frames)
            consume_initial_gain(self.render(frame_count))
            rendered_frames += frame_count
        self.assertTrue(
            initial_mix_ready,
            f"both slots did not produce 16 consecutive mixed frames within "
            f"{startup_frame_limit} rendered frames",
        )

        status = self.library.mac_audio_set_gain(
            self.host, 2, 0.25, self.error, ctypes.sizeof(self.error)
        )
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))

        # AVAudioPlayerNode applies a live volume change over rendered frames.
        # Require a full post-change block from PCM before checking the rest of
        # the finite source buffers.
        gain_change_frame_limit = 512
        changed_gain_streak = 0
        changed_gain_ready = False
        after_gain_frames = 0

        def consume_changed_gain(block: list[float]) -> None:
            nonlocal slot_two_index, slot_three_index
            nonlocal changed_gain_streak, changed_gain_ready

            for frame in range(len(block) // 2):
                self.assertLess(slot_two_index, source_frame_count)
                self.assertLess(slot_three_index, source_frame_count)
                left = block[2 * frame]
                right = block[2 * frame + 1]
                slot_two_value = slot_two_samples[slot_two_index]
                slot_three_value = slot_three_samples[slot_three_index]
                gain_from_left = (left - slot_three_gain * slot_three_value) / slot_two_value
                gain_from_right = (right + slot_three_gain * slot_three_value) / slot_two_value
                self.assertAlmostEqual(gain_from_left, gain_from_right, delta=3e-5)
                observed_gain = (gain_from_left + gain_from_right) / 2.0
                self.assertGreaterEqual(observed_gain, 0.2499)
                self.assertLessEqual(observed_gain, 0.5001)
                self.assertAlmostEqual(
                    left,
                    observed_gain * slot_two_value + slot_three_gain * slot_three_value,
                    delta=3e-5,
                )
                self.assertAlmostEqual(
                    right,
                    observed_gain * slot_two_value - slot_three_gain * slot_three_value,
                    delta=3e-5,
                )
                slot_two_index += 1
                slot_three_index += 1

                if abs(observed_gain - 0.25) <= 1e-5:
                    changed_gain_streak += 1
                    if changed_gain_streak >= 16:
                        changed_gain_ready = True
                else:
                    changed_gain_streak = 0

        while after_gain_frames < gain_change_frame_limit and not changed_gain_ready:
            frame_count = min(probe_frame_count, gain_change_frame_limit - after_gain_frames)
            consume_changed_gain(self.render(frame_count))
            after_gain_frames += frame_count
            rendered_frames += frame_count
        self.assertTrue(
            changed_gain_ready,
            f"slot 2 gain did not settle to 0.25 within {gain_change_frame_limit} "
            "post-change rendered frames",
        )

        # Completion is driven by rendered PCM and the adapter's real callback;
        # keep rendering within a source-length-derived bound until both slots
        # report completion, then verify every indexed source frame appeared.
        completion_frame_limit = source_frame_count + 512
        while self.is_playing(2) or self.is_playing(3):
            self.assertLess(
                rendered_frames,
                completion_frame_limit,
                "finite playback did not complete within the source-length bound",
            )
            frame_count = min(probe_frame_count, completion_frame_limit - rendered_frames)
            block = self.render(frame_count)
            rendered_frames += frame_count
            for frame in range(frame_count):
                left = block[2 * frame]
                right = block[2 * frame + 1]
                has_slot_two = slot_two_index < source_frame_count
                has_slot_three = slot_three_index < source_frame_count
                if has_slot_two and has_slot_three:
                    expected_two = slot_two_samples[slot_two_index]
                    expected_three = slot_three_samples[slot_three_index]
                    self.assertAlmostEqual(
                        left, 0.25 * expected_two + 0.25 * expected_three, delta=3e-5
                    )
                    self.assertAlmostEqual(
                        right, 0.25 * expected_two - 0.25 * expected_three, delta=3e-5
                    )
                    slot_two_index += 1
                    slot_three_index += 1
                elif has_slot_two:
                    expected = 0.25 * slot_two_samples[slot_two_index]
                    self.assertAlmostEqual(left, expected, delta=3e-5)
                    self.assertAlmostEqual(right, expected, delta=3e-5)
                    slot_two_index += 1
                elif has_slot_three:
                    expected = 0.25 * slot_three_samples[slot_three_index]
                    self.assertAlmostEqual(left, expected, delta=3e-5)
                    self.assertAlmostEqual(right, -expected, delta=3e-5)
                    slot_three_index += 1
                else:
                    self.assertLess(max(abs(left), abs(right)), 1e-6)

        self.assertFalse(self.is_playing(2))
        self.assertFalse(self.is_playing(3))
        self.assertEqual(slot_two_index, source_frame_count)
        self.assertEqual(slot_three_index, source_frame_count)

    def test_native_sample_rate_conversion_and_slot_format_reconfiguration(self) -> None:
        self.open_offline()
        self.assertEqual(self.play(6, [0.25, -0.5] * 256, rate=24000), 0)
        resampled = self.render(128)
        for frame in range(50, 60):
            self.assertAlmostEqual(resampled[2 * frame], 0.25, delta=0.005)
            self.assertAlmostEqual(resampled[2 * frame + 1], -0.5, delta=0.005)

        self.assertEqual(self.play(6, [0.125, 0.375] * 64, rate=48000), 0)
        changed_format = self.render(8)
        for frame in range(8):
            self.assertAlmostEqual(changed_format[2 * frame], 0.125, delta=1e-5)
            self.assertAlmostEqual(changed_format[2 * frame + 1], 0.375, delta=1e-5)

    def test_stop_and_loop_use_player_node_graph(self) -> None:
        self.open_offline()
        self.assertEqual(self.play(4, [0.3, -0.3] * 256), 0)
        active = self.render(16)
        self.assertTrue(any(abs(value) > 0.01 for value in active))
        status = self.library.mac_audio_stop(self.host, 4, self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        self.assertFalse(self.is_playing(4))
        silence = self.render(32)
        self.assertTrue(all(abs(value) < 1e-6 for value in silence), max(map(abs, silence)))

        self.assertEqual(self.play(5, [0.2, -0.4, 0.6, -0.8], loop=True), 0)
        self.assertTrue(self.is_playing(5))

        # A newly attached player can return successful silent manual-render
        # blocks before its graph contribution is observable. Use rendered PCM
        # itself as readiness, with a strict frame bound rather than a delay or
        # the host's logical active flag.
        startup_frame_limit = 512
        probe_frame_count = 128
        rendered_frames = 0
        captured: list[float] = []
        first_active_frame: int | None = None
        while rendered_frames < startup_frame_limit and first_active_frame is None:
            frame_count = min(probe_frame_count, startup_frame_limit - rendered_frames)
            block = self.render(frame_count)
            block_start = rendered_frames
            captured.extend(block)
            for frame in range(frame_count):
                if max(abs(block[2 * frame]), abs(block[2 * frame + 1])) > 0.1:
                    first_active_frame = block_start + frame
                    break
            rendered_frames += frame_count

        if first_active_frame is None:
            self.fail(f"loop produced no audible PCM within {startup_frame_limit} rendered frames")

        # Keep a full post-readiness window so the loop pattern is checked on
        # actual output, even when readiness arrives near the end of a probe.
        verification_frame_count = 128
        while rendered_frames - first_active_frame < verification_frame_count:
            frame_count = min(probe_frame_count,
                              first_active_frame + verification_frame_count - rendered_frames)
            captured.extend(self.render(frame_count))
            rendered_frames += frame_count

        window_start = first_active_frame * 2
        repeated = captured[window_start:window_start + verification_frame_count * 2]
        active_frames = [frame for frame in range(verification_frame_count)
                         if max(abs(repeated[2 * frame]), abs(repeated[2 * frame + 1])) > 0.1]
        self.assertEqual(len(active_frames), verification_frame_count)
        first = active_frames[0]
        phase = 0 if abs(repeated[2 * first] - 0.2) < 1e-5 else 1
        for offset in range(verification_frame_count):
            frame = first + offset
            expected_left = [0.2, 0.6][(phase + offset) % 2]
            expected_right = [-0.4, -0.8][(phase + offset) % 2]
            self.assertAlmostEqual(repeated[2 * frame], expected_left, delta=1e-5)
            self.assertAlmostEqual(repeated[2 * frame + 1], expected_right, delta=1e-5)
        self.assertTrue(self.is_playing(5))
        status = self.library.mac_audio_stop(self.host, 5, self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        self.assertFalse(self.is_playing(5))
        stopped = self.render(32)
        self.assertTrue(all(abs(value) < 1e-6 for value in stopped), max(map(abs, stopped)))

    def test_offline_data_rendered_completion_clears_only_current_slot_generation(self) -> None:
        self.open_offline()
        self.assertEqual(self.play(8, [0.25, -0.25] * 8), 0)
        self.assertTrue(self.is_playing(8))
        self.render(16)
        deadline = time.monotonic() + 1.0
        while self.is_playing(8) and time.monotonic() < deadline:
            time.sleep(0.005)
        self.assertFalse(self.is_playing(8), "AVAudioPlayerNode rendered-completion callback did not arrive")

        self.assertEqual(self.play(9, [0.1, 0.1] * 128), 0)
        self.assertEqual(self.play(9, [0.3, -0.2] * 128), 0)
        self.render(16)
        self.assertTrue(self.is_playing(9), "stale replaced-buffer completion stopped its new generation")

    def test_bad_parameters_thread_affinity_and_mode_errors(self) -> None:
        status = self.library.mac_audio_host_open(0, 0, 0, ctypes.byref(self.host),
                                                   self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 0, self.error.value.decode(errors="replace"))
        self.assertNotEqual(self.play(1, [math.nan, 0.0]), 0)
        self.assertNotEqual(self.play(1, [0.0, 0.0], gain=1.1), 0)
        self.assertNotEqual(self.play(1, [0.0, 0.0], rate=192001), 0)
        source = (ctypes.c_float * 2)(0.0, 0.0)
        self.assertNotEqual(self.library.mac_audio_play(
            self.host, 1, source, 1, 2, 48000, 1.0, 2, self.error,
            ctypes.sizeof(self.error)), 0)

        statuses: list[int] = []
        worker = threading.Thread(target=lambda: statuses.append(
            self.library.mac_audio_is_playing(self.host, 1, ctypes.byref(ctypes.c_int()),
                                              self.error, ctypes.sizeof(self.error))))
        worker.start()
        worker.join(timeout=2)
        self.assertEqual(statuses, [2])

        render = MacAudioRender()
        status = self.library.mac_audio_host_render_offline(self.host, 4, ctypes.byref(render),
                                                             self.error, ctypes.sizeof(self.error))
        self.assertEqual(status, 6)


if __name__ == "__main__":
    unittest.main(verbosity=2)
