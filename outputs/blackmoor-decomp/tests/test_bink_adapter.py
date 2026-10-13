#!/usr/bin/env python3
"""Native first-frame adapter checks against the installed game assets."""

from __future__ import annotations

import ctypes
import hashlib
import json
import pathlib
import subprocess
import tempfile
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
FFMPEG = pathlib.Path("/opt/homebrew/bin/ffmpeg")


class BinkFrame(ctypes.Structure):
    _fields_ = [
        ("width", ctypes.c_uint32),
        ("height", ctypes.c_uint32),
        ("stride", ctypes.c_uint32),
        ("rgba", ctypes.POINTER(ctypes.c_uint8)),
    ]


class BinkAdapterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        subprocess.run([str(PROJECT / "scripts/build_bink_adapter.sh")], check=True)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libbink_adapter.dylib"))
        cls.decode = cls.library.bink_adapter_decode_first_frame
        cls.decode.argtypes = [
            ctypes.c_char_p,
            ctypes.POINTER(BinkFrame),
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.decode.restype = ctypes.c_int
        cls.destroy = cls.library.bink_adapter_destroy
        cls.destroy.argtypes = [ctypes.POINTER(BinkFrame)]
        cls.destroy.restype = None

        source = json.loads((REPOSITORY / "work/analysis/game-source.json").read_text())
        cls.game_dir = pathlib.Path(source["game_dir"])

    def decode_frame(self, path: pathlib.Path) -> tuple[int, BinkFrame, str, bytes]:
        frame = BinkFrame()
        error = ctypes.create_string_buffer(512)
        status = self.decode(
            str(path).encode(), ctypes.byref(frame), error, ctypes.sizeof(error)
        )
        payload = b""
        if status == 0:
            payload = ctypes.string_at(frame.rgba, frame.stride * frame.height)
        return status, frame, error.value.decode(errors="replace"), payload

    def test_scene_backgrounds_match_ffmpeg_cli_rgba(self) -> None:
        for name in ("diff", "OPEN_A", "toast"):
            with self.subTest(name=name):
                path = self.game_dir / "CDVideo" / f"{name}.bik"
                if not path.is_file() or not FFMPEG.is_file():
                    self.skipTest("installed Blackmoor assets or Homebrew FFmpeg are unavailable")

                status, frame, error, payload = self.decode_frame(path)
                self.assertEqual(status, 0, error)
                try:
                    self.assertEqual((frame.width, frame.height), (620, 375))
                    self.assertEqual(frame.stride, frame.width * 4)
                    self.assertEqual(len(payload), frame.stride * frame.height)
                    cli = subprocess.run(
                        [
                            str(FFMPEG),
                            "-v",
                            "error",
                            "-i",
                            str(path),
                            "-map",
                            "0:v:0",
                            "-frames:v",
                            "1",
                            "-f",
                            "rawvideo",
                            "-pix_fmt",
                            "rgba",
                            "-",
                        ],
                        check=True,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                    )
                    self.assertEqual(payload, cli.stdout)
                    print(f"{name}: RGBA SHA-256 {hashlib.sha256(payload).hexdigest()}")
                finally:
                    self.destroy(ctypes.byref(frame))

    def test_invalid_and_missing_inputs_fail_with_empty_frame(self) -> None:
        missing = PROJECT / "build/does-not-exist.bik"
        with tempfile.NamedTemporaryFile(prefix="invalid-bink-", suffix=".bik") as bad:
            bad.write(b"not a Bink stream")
            bad.flush()
            for path in (missing, pathlib.Path(bad.name)):
                with self.subTest(path=path):
                    status, frame, error, _ = self.decode_frame(path)
                    self.assertNotEqual(status, 0)
                    self.assertEqual((frame.width, frame.height, frame.stride), (0, 0, 0))
                    self.assertFalse(bool(frame.rgba))
                    self.assertTrue(error)
                    self.destroy(ctypes.byref(frame))

    def test_remote_url_is_rejected_as_non_file_input(self) -> None:
        status, frame, error, _ = self.decode_frame(pathlib.Path("https://example.invalid/a.bik"))
        self.assertNotEqual(status, 0)
        self.assertFalse(bool(frame.rgba))
        self.assertTrue(error)
        self.destroy(ctypes.byref(frame))


if __name__ == "__main__":
    unittest.main(verbosity=2)
