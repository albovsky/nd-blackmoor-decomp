#!/usr/bin/env python3
"""Offline Bink soundtrack extraction; no output device is opened."""

from __future__ import annotations

import ctypes
import hashlib
import json
import math
import os
import pathlib
import struct
import subprocess
import tempfile
import unittest
import wave


PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
FFMPEG_PREFIX = pathlib.Path(os.environ.get("FFMPEG_PREFIX", "/opt/homebrew"))
FFMPEG = FFMPEG_PREFIX / "bin/ffmpeg"


class BinkAudio(ctypes.Structure):
    _fields_ = [
        ("pcm", ctypes.POINTER(ctypes.c_float)),
        ("frame_count", ctypes.c_uint64),
        ("sample_rate", ctypes.c_uint32),
        ("channels", ctypes.c_uint32),
    ]


class BinkAudioTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (FFMPEG_PREFIX / "include/libavformat/avformat.h").is_file():
            raise unittest.SkipTest("Homebrew FFmpeg development headers unavailable")
        subprocess.run(["sh", str(PROJECT / "scripts/build_bink_audio.sh")], check=True)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libbink_audio.dylib"))
        cls.configure(cls.library)
        cls.decode = cls.library.bink_audio_decode_file
        cls.destroy = cls.library.bink_audio_destroy
        source = json.loads((REPOSITORY / "work/analysis/game-source.json").read_text())
        cls.game_dir = pathlib.Path(source["game_dir"])

    @staticmethod
    def configure(library: ctypes.CDLL) -> None:
        library.bink_audio_decode_file.argtypes = [
            ctypes.c_char_p, ctypes.POINTER(BinkAudio), ctypes.c_char_p, ctypes.c_size_t,
        ]
        library.bink_audio_decode_file.restype = ctypes.c_int
        library.bink_audio_destroy.argtypes = [ctypes.POINTER(BinkAudio)]
        library.bink_audio_destroy.restype = None

    def decode_path(self, path: pathlib.Path, library=None):
        library = library or self.library
        audio = BinkAudio()
        error = ctypes.create_string_buffer(512)
        status = library.bink_audio_decode_file(
            os.fsencode(path), ctypes.byref(audio), error, len(error),
        )
        return status, audio, error.value.decode(errors="replace")

    def assert_empty(self, audio: BinkAudio) -> None:
        self.assertFalse(bool(audio.pcm))
        self.assertEqual((audio.frame_count, audio.sample_rate, audio.channels), (0, 0, 0))

    def movie_path(self) -> pathlib.Path:
        path = self.game_dir / "CDVideo/EXT_OpnCin_ANIM.bik"
        if not path.is_file():
            self.skipTest("installed Blackmoor movie unavailable")
        return path

    def test_embedded_soundtrack_preserves_all_cli_pcm(self) -> None:
        # Kills dropping packets, trimming padding, resampling, or gain changes.
        if not FFMPEG.is_file():
            self.skipTest("Homebrew FFmpeg CLI unavailable")
        path = self.movie_path()
        status, audio, error = self.decode_path(path)
        try:
            self.assertEqual(status, 0, error)
            self.assertEqual(error, "")
            self.assertEqual((audio.sample_rate, audio.channels), (44100, 1))
            payload = ctypes.string_at(audio.pcm, audio.frame_count * audio.channels * 4)
            cli = subprocess.run([
                str(FFMPEG), "-v", "error", "-i", str(path), "-map", "0:a:0",
                "-f", "f32le", "-acodec", "pcm_f32le", "pipe:1",
            ], check=True, capture_output=True).stdout
            self.assertEqual(payload, cli)
            self.assertTrue(all(math.isfinite(v[0]) for v in struct.iter_unpack("<f", payload)))
            print(f"Bink soundtrack: {audio.frame_count} frames, {len(payload)} bytes, "
                  f"PCM SHA-256 {hashlib.sha256(payload).hexdigest()}")
        finally:
            self.destroy(ctypes.byref(audio))
        self.assert_empty(audio)

    def test_valid_silent_bink_is_distinct_from_decode_failure(self) -> None:
        # Kills treating absent audio as an error or inventing silent PCM.
        path = self.game_dir / "CDVideo/diff.bik"
        if not path.is_file():
            self.skipTest("installed silent Blackmoor Bink unavailable")
        status, audio, error = self.decode_path(path)
        self.assertEqual(status, 1, error)
        self.assertEqual(error, "")
        self.assert_empty(audio)
        self.destroy(ctypes.byref(audio))

    def test_missing_invalid_nonbink_and_truncated_files_fail_empty(self) -> None:
        # Kills accepting arbitrary FFmpeg-supported input or partial Bink files.
        with tempfile.TemporaryDirectory(prefix="bink-audio-") as scratch:
            root = pathlib.Path(scratch)
            invalid = root / "invalid.bik"
            invalid.write_bytes(b"not a Bink file")
            empty = root / "empty.bik"
            empty.touch()
            wav = root / "audio.wav"
            with wave.open(str(wav), "wb") as stream:
                stream.setparams((1, 2, 8000, 1, "NONE", "not compressed"))
                stream.writeframes(b"\0\0")
            truncated = root / "truncated.bik"
            with self.movie_path().open("rb") as stream:
                truncated.write_bytes(stream.read(64))
            for path in (root / "absent.bik", invalid, empty, wav, truncated, root,
                         pathlib.Path("https://example.invalid/movie.bik")):
                with self.subTest(path=path.name):
                    status, audio, error = self.decode_path(path)
                    self.assertLess(status, 0)
                    self.assertTrue(error)
                    self.assert_empty(audio)
                    self.destroy(ctypes.byref(audio))

    def test_invalid_arguments_and_short_error_buffers_are_safe(self) -> None:
        audio = BinkAudio()
        error = ctypes.create_string_buffer(1)
        error.raw = b"X"
        self.assertLess(self.decode(None, ctypes.byref(audio), error, 1), 0)
        self.assertEqual(error.raw, b"\0")
        self.assert_empty(audio)
        self.assertLess(self.decode(b"", ctypes.byref(audio), None, 0), 0)
        self.assertLess(self.decode(b"unused.bik", None, None, 0), 0)
        self.destroy(None)

    def test_tail_truncation_cannot_publish_partial_soundtrack(self) -> None:
        # FFmpeg alone can return EOF/success after partial packets or a frame boundary.
        source = self.movie_path().read_bytes()
        for cut in (1, 1000, len(source) // 2):
            with self.subTest(cut=cut):
                with tempfile.NamedTemporaryFile(prefix="bink-audio-cut-", suffix=".bik") as stream:
                    stream.write(source[:-cut])
                    stream.flush()
                    status, audio, error = self.decode_path(pathlib.Path(stream.name))
                    try:
                        self.assertLess(status, 0, "truncated Bink accepted as complete PCM")
                        self.assertTrue(error)
                        self.assert_empty(audio)
                    finally:
                        self.destroy(ctypes.byref(audio))

    def test_nonempty_output_rejected_without_losing_ownership(self) -> None:
        status, audio, error = self.decode_path(self.movie_path())
        self.assertEqual(status, 0, error)
        try:
            original = ctypes.addressof(audio.pcm.contents)
            frame_count = audio.frame_count
            status = self.decode(os.fsencode(self.movie_path()), ctypes.byref(audio), None, 0)
            self.assertEqual(status, -1)
            self.assertEqual(ctypes.addressof(audio.pcm.contents), original)
            self.assertEqual(audio.frame_count, frame_count)
        finally:
            self.destroy(ctypes.byref(audio))

    def test_foreign_signature_cannot_be_accepted_as_silent_bink(self) -> None:
        header = b"NOPE" + struct.pack("<10I", 48, 1, 4, 0, 8, 8, 15, 1, 0, 0)
        with tempfile.NamedTemporaryFile(prefix="bink-audio-magic-", suffix=".bik") as stream:
            stream.write(header + struct.pack("<2I", 52, 56) + b"\0" * 4)
            stream.flush()
            status, audio, error = self.decode_path(pathlib.Path(stream.name))
            self.assertLess(status, 0)
            self.assertTrue(error)
            self.assert_empty(audio)

    def test_repeated_decode_destroy_and_failure_cleanup(self) -> None:
        # Kills keeping decoder state or stale ownership across independent calls.
        for _ in range(8):
            status, audio, error = self.decode_path(self.movie_path())
            self.assertEqual(status, 0, error)
            self.assertGreater(audio.frame_count, 0)
            self.destroy(ctypes.byref(audio))
            self.destroy(ctypes.byref(audio))
            self.assert_empty(audio)
            self.assertLess(self.decode(b"/does/not/exist", ctypes.byref(audio), None, 0), 0)
            self.assert_empty(audio)

    def test_input_size_limit_rejects_sparse_oversized_file(self) -> None:
        # A named sparse fixture avoids allocating its contents in memory.
        with tempfile.NamedTemporaryFile(prefix="bink-audio-large-", suffix=".bik") as stream:
            stream.truncate(256 * 1024 * 1024 + 1)
            stream.flush()
            status, audio, error = self.decode_path(pathlib.Path(stream.name))
            self.assertEqual(status, -6, error)
            self.assert_empty(audio)

    def test_multiple_soundtracks_are_explicitly_unsupported(self) -> None:
        # Demuxable synthetic Bink header, rejected before decoding fake payload.
        header = b"BIKi" + struct.pack("<10I", 80, 1, 12, 0, 8, 8, 15, 1, 0, 2)
        tracks = struct.pack("<2I4H2I", 4, 4, 44100, 0x1000, 44100, 0x1000, 0, 1)
        index = struct.pack("<2I", 76, 88)
        with tempfile.NamedTemporaryFile(prefix="bink-audio-tracks-", suffix=".bik") as stream:
            stream.write(header + tracks + index + b"\0" * 12)
            stream.flush()
            status, audio, error = self.decode_path(pathlib.Path(stream.name))
            self.assertEqual(status, -7, error)
            self.assertIn("multiple", error.lower())
            self.assert_empty(audio)

    def test_pcm_limit_fails_without_publishing_partial_output(self) -> None:
        # Exercise the same production allocation guard with a small compile-time budget.
        with tempfile.TemporaryDirectory(prefix="bink-audio-bound-") as scratch:
            output = pathlib.Path(scratch) / "libbounded.dylib"
            subprocess.run([
                "xcrun", "--sdk", "macosx", "clang", "-arch", "arm64",
                "-mmacosx-version-min=" + os.environ.get("MACOSX_DEPLOYMENT_TARGET", "27.0"),
                "-std=c11", "-Wall", "-Wextra", "-Wpedantic", "-Werror",
                "-O2", "-fPIC", "-dynamiclib", "-DBINK_AUDIO_MAX_PCM_BYTES=4096",
                "-I" + str(FFMPEG_PREFIX / "include"), str(PROJECT / "src/bink_audio.c"),
                "-L" + str(FFMPEG_PREFIX / "lib"), "-lavformat", "-lavcodec",
                "-lavutil", "-lswresample", "-Wl,-rpath," + str(FFMPEG_PREFIX / "lib"),
                "-o", str(output),
            ], check=True, capture_output=True)
            library = ctypes.CDLL(str(output))
            self.configure(library)
            status, audio, error = self.decode_path(self.movie_path(), library)
            self.assertEqual(status, -6, error)
            self.assertIn("limit", error.lower())
            self.assert_empty(audio)


if __name__ == "__main__":
    unittest.main(verbosity=2)
