#!/usr/bin/env python3
"""Native HIS audio checks against supplied files and FFmpeg's CLI output."""

from __future__ import annotations

import ctypes
import hashlib
import json
import os
import pathlib
import struct
import subprocess
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
FFMPEG_PREFIX = pathlib.Path(os.environ.get("FFMPEG_PREFIX", "/opt/homebrew"))
FFMPEG = FFMPEG_PREFIX / "bin/ffmpeg"


class HisAudio(ctypes.Structure):
    _fields_ = [
        ("sample_rate", ctypes.c_uint32),
        ("channels", ctypes.c_uint32),
        ("frame_count", ctypes.c_uint64),
        ("interleaved_pcm", ctypes.POINTER(ctypes.c_float)),
    ]


class HisAudioTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (FFMPEG_PREFIX / "include/libavformat/avformat.h").is_file():
            raise unittest.SkipTest("Homebrew FFmpeg development headers are unavailable")
        subprocess.run([str(PROJECT / "scripts/build_his_audio.sh")], check=True)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libhis_audio.dylib"))
        cls.decode_memory = cls.library.his_audio_decode_memory
        cls.decode_memory.argtypes = [
            ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t,
            ctypes.POINTER(HisAudio),
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.decode_memory.restype = ctypes.c_int
        cls.decode_file = cls.library.his_audio_decode_file
        cls.decode_file.argtypes = [
            ctypes.c_char_p,
            ctypes.POINTER(HisAudio),
            ctypes.c_char_p,
            ctypes.c_size_t,
        ]
        cls.decode_file.restype = ctypes.c_int
        cls.destroy = cls.library.his_audio_destroy
        cls.destroy.argtypes = [ctypes.POINTER(HisAudio)]
        cls.destroy.restype = None

        source = json.loads((REPOSITORY / "work/analysis/game-source.json").read_text())
        cls.game_dir = pathlib.Path(source["game_dir"])

    def decode_bytes(self, data: bytes) -> tuple[int, HisAudio, str, bytes]:
        source = (ctypes.c_uint8 * len(data)).from_buffer_copy(data)
        audio = HisAudio()
        error = ctypes.create_string_buffer(512)
        status = self.decode_memory(
            source, len(data), ctypes.byref(audio), error, ctypes.sizeof(error)
        )
        payload = b""
        if status == 0:
            payload = ctypes.string_at(
                audio.interleaved_pcm,
                audio.frame_count * audio.channels * ctypes.sizeof(ctypes.c_float),
            )
        return status, audio, error.value.decode(errors="replace"), payload

    def decode_path(self, path: pathlib.Path) -> tuple[int, HisAudio, str, bytes]:
        audio = HisAudio()
        error = ctypes.create_string_buffer(512)
        status = self.decode_file(
            str(path).encode(), ctypes.byref(audio), error, ctypes.sizeof(error)
        )
        payload = b""
        if status == 0:
            payload = ctypes.string_at(
                audio.interleaved_pcm,
                audio.frame_count * audio.channels * ctypes.sizeof(ctypes.c_float),
            )
        return status, audio, error.value.decode(errors="replace"), payload

    def ffmpeg_pcm(self, wrapper: bytes, sample_rate: int, channels: int) -> bytes:
        result = subprocess.run(
            [
                str(FFMPEG),
                "-v",
                "error",
                "-f",
                "ogg",
                "-i",
                "pipe:0",
                "-map",
                "0:a:0",
                "-ar",
                str(sample_rate),
                "-ac",
                str(channels),
                "-f",
                "f32le",
                "-acodec",
                "pcm_f32le",
                "pipe:1",
            ],
            input=wrapper[30:],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        return result.stdout

    def test_real_ogg_his_matches_ffmpeg_cli(self) -> None:
        cases = (
            ("Ndsig.his", True),
            ("NSHT01.his", False),
            ("Pot02.HIS", False),
            ("Icant.his", False),
        )
        for name, use_file_api in cases:
            with self.subTest(name=name):
                path = self.game_dir / "CDSound" / name
                if not path.is_file():
                    path = next(
                        (candidate for candidate in (self.game_dir / "CDSound").iterdir()
                         if candidate.name.lower() == name.lower()),
                        path,
                    )
                if not path.is_file() or not FFMPEG.is_file():
                    self.skipTest("supplied Blackmoor HIS assets or FFmpeg CLI are unavailable")
                wrapper = path.read_bytes()
                if use_file_api:
                    status, audio, error, decoded = self.decode_path(path)
                else:
                    status, audio, error, decoded = self.decode_bytes(wrapper)
                self.assertEqual(status, 0, error)
                try:
                    self.assertEqual(wrapper[:4], b"HIS\0")
                    self.assertEqual(wrapper[30:34], b"OggS")
                    sample_rate = struct.unpack_from("<I", wrapper, 12)[0]
                    channels = struct.unpack_from("<H", wrapper, 10)[0]
                    expected_bytes = struct.unpack_from("<I", wrapper, 24)[0]
                    bytes_per_frame = struct.unpack_from("<H", wrapper, 20)[0]
                    self.assertEqual(audio.sample_rate, sample_rate)
                    self.assertEqual(audio.channels, channels)
                    self.assertEqual(audio.frame_count, expected_bytes // bytes_per_frame)
                    cli = self.ffmpeg_pcm(wrapper, sample_rate, channels)
                    self.assertGreaterEqual(len(cli), len(decoded))
                    self.assertEqual(decoded, cli[: len(decoded)])
                    print(
                        f"{name}: {audio.sample_rate} Hz, {audio.channels} channel(s), "
                        f"{audio.frame_count} frames, PCM SHA-256 {hashlib.sha256(decoded).hexdigest()}"
                    )
                finally:
                    self.destroy(ctypes.byref(audio))

    def test_real_pcm_his_formats_decode_to_interleaved_float(self) -> None:
        cases = ("CardFlip05.HIS", "ComputerGameBeep01.HIS", "Pot02.HIS")
        for name in cases:
            with self.subTest(name=name):
                path = self.game_dir / "CDSound" / name
                if not path.is_file():
                    path = next(
                        (candidate for candidate in (self.game_dir / "CDSound").iterdir()
                         if candidate.name.lower() == name.lower()),
                        path,
                    )
                if not path.is_file():
                    self.skipTest("supplied Blackmoor HIS assets are unavailable")
                wrapper = path.read_bytes()
                if struct.unpack_from("<H", wrapper, 28)[0] != 1:
                    continue
                status, audio, error, decoded = self.decode_bytes(wrapper)
                self.assertEqual(status, 0, error)
                try:
                    channels = struct.unpack_from("<H", wrapper, 10)[0]
                    sample_rate = struct.unpack_from("<I", wrapper, 12)[0]
                    bits_per_sample = struct.unpack_from("<H", wrapper, 22)[0]
                    declared_bytes = struct.unpack_from("<I", wrapper, 24)[0]
                    self.assertEqual((audio.sample_rate, audio.channels), (sample_rate, channels))
                    self.assertEqual(audio.frame_count, declared_bytes // (channels * bits_per_sample // 8))
                    self.assertEqual(len(decoded), audio.frame_count * channels * 4)
                    if bits_per_sample == 8:
                        expected_first = (wrapper[30] - 128) / 128.0
                    else:
                        sample = struct.unpack_from("<h", wrapper, 30)[0]
                        expected_first = sample / 32768.0
                    self.assertAlmostEqual(struct.unpack_from("<f", decoded, 0)[0], expected_first)
                    print(
                        f"{name}: {sample_rate} Hz, {channels} channel(s), "
                        f"{bits_per_sample}-bit PCM source, {audio.frame_count} frames"
                    )
                finally:
                    self.destroy(ctypes.byref(audio))

    def test_malformed_headers_and_payload_lengths_fail_cleanly(self) -> None:
        path = self.game_dir / "CDSound" / "Ndsig.his"
        if not path.is_file():
            self.skipTest("supplied Blackmoor HIS asset is unavailable")
        valid = path.read_bytes()
        broken = []

        wrong_version = bytearray(valid)
        wrong_version[4:8] = struct.pack("<I", 3)
        broken.append(("unsupported version", bytes(wrong_version)))
        broken.append(("short header", valid[:29]))
        truncated_ogg = bytearray(valid[:-1])
        broken.append(("truncated declared stream", bytes(truncated_ogg)))
        oversized_pcm = bytearray(valid)
        oversized_pcm[24:28] = struct.pack("<I", 0xFFFFFFFE)
        broken.append(("oversized decoded length", bytes(oversized_pcm)))
        misaligned_pcm = bytearray(valid)
        misaligned_pcm[24:28] = struct.pack("<I", 0xFFFFFFFF)
        broken.append(("misaligned decoded length", bytes(misaligned_pcm)))
        bad_ogg_magic = bytearray(valid)
        bad_ogg_magic[30:34] = b"NOPE"
        broken.append(("wrong Ogg signature", bytes(bad_ogg_magic)))
        pcm_path = self.game_dir / "CDSound" / "CardFlip05.HIS"
        if not pcm_path.is_file():
            pcm_path = next(
                (candidate for candidate in (self.game_dir / "CDSound").iterdir()
                 if candidate.name.lower() == "cardflip05.his"),
                pcm_path,
            )
        if pcm_path.is_file():
            broken.append(("truncated raw PCM", pcm_path.read_bytes()[:-1]))

        for label, data in broken:
            with self.subTest(case=label):
                status, audio, error, decoded = self.decode_bytes(data)
                self.assertNotEqual(status, 0)
                self.assertEqual((audio.sample_rate, audio.channels, audio.frame_count), (0, 0, 0))
                self.assertFalse(bool(audio.interleaved_pcm))
                self.assertEqual(decoded, b"")
                self.assertTrue(error)
                self.destroy(ctypes.byref(audio))


if __name__ == "__main__":
    unittest.main(verbosity=2)
