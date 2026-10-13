#!/usr/bin/env python3
"""Bounded timed Bink playback checks against installed samples and FFmpeg."""

from __future__ import annotations

import ctypes
import hashlib
import json
import os
import pathlib
import subprocess
import tempfile
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
FFMPEG = pathlib.Path("/opt/homebrew/bin/ffmpeg")
BASE_NS = 1_000_000_000


class BinkPlayerInfo(ctypes.Structure):
    _fields_ = [
        ("width", ctypes.c_uint32),
        ("height", ctypes.c_uint32),
        ("total_frames", ctypes.c_uint32),
        ("frame_rate_num", ctypes.c_int32),
        ("frame_rate_den", ctypes.c_int32),
        ("time_base_num", ctypes.c_int32),
        ("time_base_den", ctypes.c_int32),
        ("decoded_frame_storage_bytes", ctypes.c_uint64),
    ]


class BinkPlayerFrame(ctypes.Structure):
    _fields_ = [
        ("rgba", ctypes.POINTER(ctypes.c_uint8)),
        ("rgba_bytes", ctypes.c_size_t),
        ("width", ctypes.c_uint32),
        ("height", ctypes.c_uint32),
        ("stride", ctypes.c_uint32),
        ("current_frame", ctypes.c_int32),
        ("pts_ns", ctypes.c_int64),
        ("duration_ns", ctypes.c_int64),
        ("is_terminal", ctypes.c_uint8),
    ]


class BinkPlayerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        build_script = PROJECT / "scripts/build_bink_player.sh"
        if not build_script.is_file():
            raise AssertionError("S02 build script has not been implemented")
        build_environment = os.environ.copy()
        build_environment["BINK_PLAYER_TESTING"] = "1"
        subprocess.run([str(build_script)], check=True, env=build_environment)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libbink_player.dylib"))
        cls.open_player = cls.library.bink_player_open
        cls.open_player.argtypes = [
            ctypes.c_char_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.POINTER(BinkPlayerInfo),
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.open_player.restype = ctypes.c_int
        cls.set_mode = cls.library.bink_player_set_mode
        cls.set_mode.argtypes = [
            ctypes.c_void_p,
            ctypes.c_int32,
            ctypes.c_uint64,
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.set_mode.restype = ctypes.c_int
        cls.seek = cls.library.bink_player_seek
        cls.seek.argtypes = [
            ctypes.c_void_p,
            ctypes.c_uint32,
            ctypes.c_uint64,
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.seek.restype = ctypes.c_int
        cls.advance = cls.library.bink_player_advance
        cls.advance.argtypes = [
            ctypes.c_void_p,
            ctypes.c_uint64,
            ctypes.POINTER(BinkPlayerFrame),
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.advance.restype = ctypes.c_int
        cls.close = cls.library.bink_player_close
        cls.close.argtypes = [ctypes.c_void_p]
        cls.close.restype = None
        cls.test_buffer_accounting = cls.library.bink_player_test_buffer_accounting
        cls.test_buffer_accounting.argtypes = [
            ctypes.c_uint64,
            ctypes.c_uint64,
            ctypes.c_int,
            ctypes.c_uint64,
            ctypes.POINTER(ctypes.c_uint64),
        ]
        cls.test_buffer_accounting.restype = ctypes.c_int

        game_source = json.loads((REPOSITORY / "work/analysis/game-source.json").read_text())
        cls.video_dir = pathlib.Path(game_source["game_dir"]) / "CDVideo"

    def open(self, clip: pathlib.Path) -> tuple[ctypes.c_void_p, BinkPlayerInfo]:
        player = ctypes.c_void_p()
        info = BinkPlayerInfo()
        error = ctypes.create_string_buffer(512)
        status = self.open_player(
            str(clip).encode(),
            ctypes.byref(player),
            ctypes.byref(info),
            error,
            ctypes.sizeof(error),
        )
        self.assertEqual(status, 0, error.value.decode(errors="replace"))
        self.assertTrue(player.value)
        return player, info

    def call_mode(self, player: ctypes.c_void_p, mode: int, now_ns: int = BASE_NS) -> None:
        error = ctypes.create_string_buffer(512)
        status = self.set_mode(
            player, mode, now_ns, error, ctypes.sizeof(error)
        )
        self.assertEqual(status, 0, error.value.decode(errors="replace"))

    def call_seek(
        self, player: ctypes.c_void_p, frame_1based: int, now_ns: int = BASE_NS
    ) -> int:
        error = ctypes.create_string_buffer(512)
        return self.seek(player, frame_1based, now_ns, error, ctypes.sizeof(error))

    def call_advance(
        self, player: ctypes.c_void_p, now_ns: int
    ) -> tuple[int, BinkPlayerFrame, str]:
        frame = BinkPlayerFrame()
        error = ctypes.create_string_buffer(512)
        status = self.advance(
            player, now_ns, ctypes.byref(frame), error, ctypes.sizeof(error)
        )
        return status, frame, error.value.decode(errors="replace")

    @staticmethod
    def rgba(frame: BinkPlayerFrame) -> bytes:
        if not frame.rgba:
            return b""
        return ctypes.string_at(frame.rgba, frame.rgba_bytes)

    def test_retained_budget_counts_avbuffer_backing_and_extended_refs(self) -> None:
        used = ctypes.c_uint64()
        status = self.test_buffer_accounting(
            128 * 1024, 0, 0, 64 * 1024, ctypes.byref(used)
        )
        self.assertEqual(status, -6, "large backing allocation must exceed the cap")

        backing_bytes = 128 * 1024 + 64 * 1024
        status = self.test_buffer_accounting(
            128 * 1024, 64 * 1024, 0, backing_bytes, ctypes.byref(used)
        )
        self.assertEqual(status, 0, "primary plus extended AVBuffers fit exactly")
        self.assertEqual(used.value, backing_bytes)

        shared_bytes = 96 * 1024
        status = self.test_buffer_accounting(
            shared_bytes, 0, 1, shared_bytes, ctypes.byref(used)
        )
        self.assertEqual(status, 0, "same AVBuffer identity is charged once")
        self.assertEqual(used.value, shared_bytes)

    def test_diff_and_open_a_first_frame_match_ffmpeg_rgba(self) -> None:
        for name in ("diff", "OPEN_A"):
            with self.subTest(name=name):
                clip = self.video_dir / f"{name}.bik"
                if not clip.is_file() or not FFMPEG.is_file():
                    self.skipTest("installed game assets or Homebrew FFmpeg are unavailable")
                player, info = self.open(clip)
                try:
                    self.assertEqual((info.width, info.height, info.total_frames), (620, 375, 1))
                    self.assertEqual((info.frame_rate_num, info.frame_rate_den), (15, 1))
                    self.call_mode(player, 0)
                    status, frame, error = self.call_advance(player, BASE_NS)
                    self.assertEqual(status, 0, error)
                    self.assertEqual(frame.current_frame, 0)
                    self.assertEqual(frame.pts_ns, 0)
                    self.assertEqual((frame.width, frame.height, frame.stride), (620, 375, 2480))
                    self.assertEqual(frame.rgba_bytes, frame.stride * frame.height)
                    self.assertEqual(frame.is_terminal, 1)
                    cli = subprocess.run(
                        [
                            str(FFMPEG),
                            "-v", "error", "-i", str(clip), "-map", "0:v:0",
                            "-frames:v", "1", "-f", "rawvideo", "-pix_fmt", "rgba", "-",
                        ],
                        check=True,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                    ).stdout
                    actual = self.rgba(frame)
                    self.assertEqual(actual, cli)
                    print(f"{name}: RGBA SHA-256 {hashlib.sha256(actual).hexdigest()}")
                    status, _frame, error = self.call_advance(player, BASE_NS + 1)
                    self.assertEqual(status, 2, error)
                finally:
                    self.close(player)

    def test_opener_metadata_pacing_and_complete_sequences_both_directions(self) -> None:
        clip = self.video_dir / "EXT_OpnCin_ANIM.bik"
        if not clip.is_file():
            self.skipTest("installed opening cinematic is unavailable")
        player, info = self.open(clip)
        try:
            self.assertEqual((info.width, info.height, info.total_frames), (620, 375, 504))
            self.assertEqual((info.frame_rate_num, info.frame_rate_den), (15, 1))
            self.assertEqual((info.time_base_num, info.time_base_den), (1, 15))
            self.assertLessEqual(info.decoded_frame_storage_bytes, 256 * 1024 * 1024)
            print(
                "EXT_OpnCin_ANIM: "
                f"{info.total_frames} frames, "
                f"{info.decoded_frame_storage_bytes} unique retained AVBuffer payload bytes"
            )

            self.call_mode(player, 0)
            status, frame, error = self.call_advance(player, BASE_NS)
            self.assertEqual(status, 0, error)
            self.assertEqual((frame.current_frame, frame.pts_ns), (0, 0))
            interval_ns = frame.duration_ns
            self.assertGreater(interval_ns, 0)
            status, not_due, error = self.call_advance(player, BASE_NS + interval_ns - 1)
            self.assertEqual(status, 1, error)
            self.assertFalse(not_due.rgba)
            status, frame, error = self.call_advance(player, BASE_NS + interval_ns)
            self.assertEqual(status, 0, error)
            self.assertEqual(frame.current_frame, 1)
            self.assertEqual(frame.pts_ns, interval_ns)

            forward = [0, frame.current_frame]
            previous_pts = frame.pts_ns
            last_forward: BinkPlayerFrame | None = None
            while True:
                status, frame, error = self.call_advance(player, BASE_NS + 60_000_000_000)
                if status == 2:
                    break
                self.assertEqual(status, 0, error)
                self.assertGreater(frame.pts_ns, previous_pts)
                self.assertEqual(frame.current_frame, forward[-1] + 1)
                forward.append(frame.current_frame)
                previous_pts = frame.pts_ns
                last_forward = frame
            self.assertEqual(forward, list(range(504)))
            self.assertIsNotNone(last_forward)
            self.assertTrue(last_forward.is_terminal)

            self.call_mode(player, 1, 2_000_000_000)
            status, frame, error = self.call_advance(player, 2_000_000_000)
            self.assertEqual(status, 0, error)
            self.assertEqual(frame.current_frame, 503)
            reverse = [frame.current_frame]
            previous_pts = frame.pts_ns
            last_reverse: BinkPlayerFrame | None = None
            while True:
                status, frame, error = self.call_advance(player, 62_000_000_000)
                if status == 2:
                    break
                self.assertEqual(status, 0, error)
                self.assertLess(frame.pts_ns, previous_pts)
                self.assertEqual(frame.current_frame, reverse[-1] - 1)
                reverse.append(frame.current_frame)
                previous_pts = frame.pts_ns
                last_reverse = frame
            self.assertEqual(reverse, list(range(503, -1, -1)))
            self.assertIsNotNone(last_reverse)
            self.assertTrue(last_reverse.is_terminal)
        finally:
            self.close(player)

    def test_invalid_inputs_fail_without_publishing_player_or_info(self) -> None:
        missing = PROJECT / "build/no-such-bink.bik"
        with tempfile.NamedTemporaryFile(prefix="bad-bink-", suffix=".bik") as corrupt:
            corrupt.write(b"not a Bink stream")
            corrupt.flush()
            for path, expected in (
                (missing, -2),
                (pathlib.Path(corrupt.name), -3),
                (pathlib.Path("https://example.invalid/video.bik"), -2),
            ):
                with self.subTest(path=path):
                    player = ctypes.c_void_p()
                    info = BinkPlayerInfo()
                    error = ctypes.create_string_buffer(512)
                    status = self.open_player(
                        str(path).encode(),
                        ctypes.byref(player),
                        ctypes.byref(info),
                        error,
                        ctypes.sizeof(error),
                    )
                    self.assertEqual(status, expected, error.value.decode(errors="replace"))
                    self.assertFalse(player.value)
                    self.assertEqual(
                        (info.width, info.height, info.total_frames, info.decoded_frame_storage_bytes),
                        (0, 0, 0, 0),
                    )

    def test_seek_is_one_based_range_checked_and_never_loops(self) -> None:
        clip = self.video_dir / "EXT_OpnCin_ANIM.bik"
        if not clip.is_file():
            self.skipTest("installed opening cinematic is unavailable")
        player, info = self.open(clip)
        try:
            self.call_mode(player, 0)
            self.assertEqual(self.call_seek(player, 0), -6)
            self.assertEqual(self.call_seek(player, info.total_frames + 1), -6)
            status, frame, error = self.call_advance(player, BASE_NS)
            self.assertEqual(status, 0, error)
            self.assertEqual(frame.current_frame, 0)

            self.assertEqual(self.call_seek(player, info.total_frames, BASE_NS + 100), 0)
            status, frame, error = self.call_advance(player, BASE_NS + 100)
            self.assertEqual(status, 0, error)
            self.assertEqual(frame.current_frame, 503)
            self.assertTrue(frame.is_terminal)
            self.assertEqual(self.call_advance(player, BASE_NS + 101)[0], 2)

            self.call_mode(player, 1, BASE_NS + 200)
            self.assertEqual(self.call_seek(player, 1, BASE_NS + 300), 0)
            status, frame, error = self.call_advance(player, BASE_NS + 300)
            self.assertEqual(status, 0, error)
            self.assertEqual(frame.current_frame, 0)
            self.assertTrue(frame.is_terminal)
            self.assertEqual(self.call_advance(player, BASE_NS + 301)[0], 2)
        finally:
            self.close(player)


if __name__ == "__main__":
    unittest.main(verbosity=2)
