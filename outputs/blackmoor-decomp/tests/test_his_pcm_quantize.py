#!/usr/bin/env python3
"""Portable native tests for the isolated HIS float-to-PCM quantizer."""

from __future__ import annotations

import ctypes
import pathlib
import subprocess
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]


class HisPcmQuantizerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        subprocess.run([str(PROJECT / "scripts/build_his_pcm_quantize.sh")], check=True)
        cls.library = ctypes.CDLL(str(PROJECT / "build/libhis_pcm_quantize.dylib"))
        cls.library.his_pcm_quantize_planar.argtypes = [
            ctypes.POINTER(ctypes.POINTER(ctypes.c_float)),
            ctypes.c_uint32,
            ctypes.c_uint64,
            ctypes.c_uint32,
            ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_uint64),
        ]
        cls.library.his_pcm_quantize_planar.restype = ctypes.c_int
        cls.library.his_pcm_quantize_status_string.argtypes = [ctypes.c_int]
        cls.library.his_pcm_quantize_status_string.restype = ctypes.c_char_p

    def quantize(self, planes: list[list[float]], bits: int,
                 capacity: int | None = None) -> tuple[int, int, bytes]:
        channels = len(planes)
        self.assertGreater(channels, 0)
        frames = len(planes[0])
        self.assertTrue(all(len(plane) == frames for plane in planes))
        native_planes = [(ctypes.c_float * frames)(*plane) for plane in planes]
        plane_pointers = (ctypes.POINTER(ctypes.c_float) * channels)(
            *(ctypes.cast(plane, ctypes.POINTER(ctypes.c_float)) for plane in native_planes)
        )
        full_capacity = frames * channels * (bits // 8)
        output_capacity = full_capacity if capacity is None else capacity
        storage = (ctypes.c_uint8 * max(output_capacity, 1))()
        written = ctypes.c_uint64(99)
        status = self.library.his_pcm_quantize_planar(
            plane_pointers, channels, frames, bits, storage, output_capacity,
            ctypes.byref(written),
        )
        return status, written.value, bytes(storage[:output_capacity])

    def test_original_8_bit_unsigned_extrema_and_channel_interleave(self) -> None:
        status, frames, output = self.quantize(
            [[-2.0, -1.0, 0.0, 1.0, 2.0],
             [0.25, -0.25, 0.5, -0.5, 0.0]],
            8,
        )
        self.assertEqual((status, frames), (0, 5))
        self.assertEqual(output, bytes((0, 160, 0, 96, 128, 192, 255, 64, 255, 128)))

    def test_original_16_bit_signed_little_endian_extrema_and_interleave(self) -> None:
        status, frames, output = self.quantize(
            [[-2.0, -1.0, 0.0, 1.0, 2.0],
             [0.25, -0.25, 0.5, -0.5, 0.0]],
            16,
        )
        self.assertEqual((status, frames), (0, 5))
        self.assertEqual(
            output,
            bytes.fromhex("00 80 00 20 00 80 00 e0 00 00 00 40 ff 7f 00 c0 ff 7f 00 00"),
        )

    def test_capacity_limits_output_to_whole_interleaved_frames(self) -> None:
        status, frames, output = self.quantize(
            [[-1.0, 0.0, 1.0], [1.0, 0.0, -1.0]], 16, capacity=5
        )
        self.assertEqual((status, frames), (0, 1))
        self.assertEqual(output[:4], bytes.fromhex("00 80 ff 7f"))

    def test_halfway_values_round_to_even_for_positive_and_negative_samples(self) -> None:
        samples8 = [0.5 / 128.0, 1.5 / 128.0, 2.5 / 128.0,
                    -0.5 / 128.0, -1.5 / 128.0, -2.5 / 128.0]
        status, frames, output = self.quantize([samples8], 8)
        self.assertEqual((status, frames), (0, 6))
        self.assertEqual(output, bytes((128, 130, 130, 128, 126, 126)))

        samples16 = [0.5 / 32768.0, 1.5 / 32768.0, 2.5 / 32768.0,
                     -0.5 / 32768.0, -1.5 / 32768.0, -2.5 / 32768.0]
        status, frames, output = self.quantize([samples16], 16)
        self.assertEqual((status, frames), (0, 6))
        self.assertEqual(output, bytes.fromhex("00 00 02 00 02 00 00 00 fe ff fe ff"))

    def test_nonfinite_and_positive_x87_integer_overflow_select_minimum(self) -> None:
        status, frames, output = self.quantize(
            [[float("nan"), float("inf"), -float("inf"), 65536.0]], 16
        )
        self.assertEqual((status, frames), (0, 4))
        self.assertEqual(output, bytes.fromhex("00 80 00 80 00 80 00 80"))

        status, frames, output = self.quantize(
            [[float("nan"), float("inf"), -float("inf"), 16777216.0]], 8
        )
        self.assertEqual((status, frames), (0, 4))
        self.assertEqual(output, bytes((0, 0, 0, 0)))

    def test_rejects_invalid_format_channels_and_empty_output_space(self) -> None:
        status, frames, _ = self.quantize([[0.0]], 24)
        self.assertEqual((status, frames), (1, 0))
        status, frames, _ = self.quantize([[0.0], [0.0], [0.0]], 8)
        self.assertEqual((status, frames), (1, 0))
        status, frames, _ = self.quantize([[0.0]], 16, capacity=1)
        self.assertEqual((status, frames), (2, 0))

    def test_null_source_plane_is_rejected(self) -> None:
        output = (ctypes.c_uint8 * 4)()
        null_plane = ctypes.POINTER(ctypes.c_float)()
        plane_pointers = (ctypes.POINTER(ctypes.c_float) * 1)(null_plane)
        written = ctypes.c_uint64(99)
        status = self.library.his_pcm_quantize_planar(
            plane_pointers, 1, 2, 16, output, len(output), ctypes.byref(written)
        )
        self.assertEqual((status, written.value), (1, 0))


if __name__ == "__main__":
    unittest.main(verbosity=2)
