"""Device-free tests of the recompiled app's asynchronous PCM16 WAV capture."""
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest
import wave


PROJECT = Path(__file__).resolve().parents[1]


class RecompAudioCaptureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which("clang++") or shutil.which("c++")
        if compiler is None:
            raise RuntimeError("C++17 compiler required for WAV capture tests")
        temp_root = "/private/tmp" if Path("/private/tmp").is_dir() else None
        scratch = tempfile.TemporaryDirectory(prefix="blackmoor-recomp-audio-", dir=temp_root)
        cls.addClassCleanup(scratch.cleanup)
        cls.root = Path(scratch.name)
        cls.fixture = cls.root / "capture-fixture"
        subprocess.run([
            compiler, "-std=c++17", "-O2", "-Wall", "-Wextra", "-Wpedantic", "-Werror", "-pthread",
            "-DRC_AUDIO_CAPTURE_TESTING",
            "-I", str(PROJECT / "recomp"), str(PROJECT / "recomp/audio_capture.cpp"),
            str(PROJECT / "tests/recomp_audio_capture_fixture.cpp"), "-o", str(cls.fixture),
        ], check=True, capture_output=True, text=True, timeout=30)

    def run_capture(self, mode):
        path = self.root / (mode + ".wav")
        subprocess.run([str(self.fixture), mode, str(path)], check=True, capture_output=True, text=True, timeout=10)
        return path

    def assert_wav(self, path, expected):
        data = path.read_bytes()
        self.assertEqual(len(data), 44 + len(expected))
        self.assertEqual(struct.unpack_from("<I", data, 4)[0], len(data) - 8)
        self.assertEqual(struct.unpack_from("<I", data, 28)[0], 44100 * 4)
        self.assertEqual(struct.unpack_from("<I", data, 40)[0], len(expected))
        with wave.open(str(path), "rb") as stream:
            self.assertEqual((stream.getnchannels(), stream.getsampwidth(), stream.getframerate()), (2, 2, 44100))
            self.assertEqual(stream.getnframes(), len(expected) // 4)
            self.assertEqual(stream.readframes(stream.getnframes() + 1), expected)

    def test_pcm_extrema_channels_silence_and_ring_wrap_are_exact(self):
        pcm = struct.pack("<6h", -32768, 32767, -1, 1, 0, 0) * 32
        self.assert_wav(self.run_capture("wrap"), pcm)

    def test_finish_and_destructor_drain_pending_frames(self):
        pcm = struct.pack("<16384h", *(i - 32768 for i in range(16384)))
        for mode in ("drain", "destructor"):
            with self.subTest(mode=mode):
                self.assert_wav(self.run_capture(mode), pcm)

    def test_finish_drains_final_append_after_writer_observed_empty_queue(self):
        self.assert_wav(self.run_capture("finish-race"),
                        struct.pack("<6h", 101, -202, 303, -404, 505, -606))

    def test_empty_capture_is_a_finalized_zero_frame_wav(self):
        self.assert_wav(self.run_capture("empty"), b"")

    def test_overflow_fails_and_preserves_only_the_accepted_prefix(self):
        self.assert_wav(self.run_capture("overflow"), struct.pack("<2h", 123, -456))

    def test_invalid_arguments_and_open_failure_report_errors(self):
        self.assertFalse(self.run_capture("invalid").exists())
        absent = self.root / "absent-parent" / "capture.wav"
        subprocess.run([str(self.fixture), "bad-path", str(absent)], check=True, capture_output=True, text=True, timeout=10)
        self.assertFalse(absent.exists())


if __name__ == "__main__":
    unittest.main()
