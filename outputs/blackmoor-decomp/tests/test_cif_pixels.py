"""Tests for the recovered in-place pixel conversion and host RGBA adapter."""

from __future__ import annotations

import ctypes
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY_PATH = PROJECT / "build/libcifpixels.dylib"


class PixelFormat(ctypes.Structure):
    _fields_ = [
        ("enabled", ctypes.c_uint32),
        ("shifts", ctypes.c_uint8 * 3),
        ("channel_bits", ctypes.c_int8 * 3),
    ]


def load_library() -> ctypes.CDLL:
    if not LIBRARY_PATH.is_file():
        raise unittest.SkipTest(f"pixel library is not built: {LIBRARY_PATH}")
    library = ctypes.CDLL(str(LIBRARY_PATH))
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    format_ptr = ctypes.POINTER(PixelFormat)
    library.cif_pixels_convert_555.argtypes = [byte_ptr, ctypes.c_uint32, format_ptr]
    library.cif_pixels_convert_555.restype = None
    library.cif_pixels_rgb555_to_rgba.argtypes = [
        byte_ptr,
        ctypes.c_size_t,
        byte_ptr,
        ctypes.c_size_t,
    ]
    library.cif_pixels_rgb555_to_rgba.restype = ctypes.c_int
    return library


def make_format(
    *,
    enabled: int = 1,
    shifts: tuple[int, int, int] = (0, 5, 10),
    channel_bits: tuple[int, int, int] = (5, 5, 5),
) -> PixelFormat:
    value = PixelFormat()
    value.enabled = enabled
    value.shifts[:] = shifts
    value.channel_bits[:] = channel_bits
    return value


def run_conversion(library: ctypes.CDLL, raw: bytes, pixel_format: PixelFormat) -> bytes:
    storage = (ctypes.c_uint8 * len(raw)).from_buffer_copy(raw)
    library.cif_pixels_convert_555(storage, len(raw), ctypes.byref(pixel_format))
    return bytes(storage)


def reference_transform(raw: bytes, pixel_format: PixelFormat) -> bytes:
    """Small independent scalar transcription of the documented x86 behavior."""
    result = bytearray(raw)
    if pixel_format.enabled == 0:
        return bytes(result)

    for offset in range(0, len(raw) - 1, 2):
        source = raw[offset] | (raw[offset + 1] << 8)
        red = (source >> 10) & 0x1F
        green = (source >> 5) & 0x1F
        blue = source & 0x1F
        red_bits = pixel_format.channel_bits[2]
        green_bits = pixel_format.channel_bits[1]
        blue_bits = pixel_format.channel_bits[0]

        if red_bits == 5:
            if green_bits == 5:
                if blue_bits != 5:
                    blue = (blue << 1) & 0xFF
            else:
                green = (green << 1) & 0xFF
        else:
            red = (red << 1) & 0xFF

        shifts = pixel_format.shifts
        packed = (
            (red << (shifts[2] & 0x1F))
            | (green << (shifts[1] & 0x1F))
            | (blue << (shifts[0] & 0x1F))
        ) & 0xFFFF
        result[offset] = packed & 0xFF
        result[offset + 1] = packed >> 8
    return bytes(result)


class PixelConversionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.library = load_library()

    def test_rgb555_format_covers_all_65536_input_words(self) -> None:
        raw = b"".join(value.to_bytes(2, "little") for value in range(1 << 16))
        fmt = make_format(shifts=(0, 5, 10), channel_bits=(5, 5, 5))
        actual = run_conversion(self.library, raw, fmt)
        self.assertEqual(actual, reference_transform(raw, fmt))
        self.assertEqual(actual[: 0x8000 * 2], raw[: 0x8000 * 2])
        # Bit 15 is outside RGB555 and is discarded by the original extraction.
        self.assertEqual(actual[0x8000 * 2 : 0x8000 * 2 + 2], b"\0\0")

    def test_rgb565_format_matches_scalar_reference_for_all_words(self) -> None:
        raw = b"".join(value.to_bytes(2, "little") for value in range(1 << 16))
        fmt = make_format(shifts=(0, 5, 11), channel_bits=(5, 6, 5))
        self.assertEqual(
            run_conversion(self.library, raw, fmt),
            reference_transform(raw, fmt),
        )

    def test_disabled_format_and_odd_trailing_byte_are_untouched(self) -> None:
        raw = b"\x1f\x7c\x00\x80\xaa"
        fmt = make_format(
            enabled=0,
            shifts=(255, 32, 31),
            channel_bits=(4, 6, 7),
        )
        self.assertEqual(run_conversion(self.library, raw, fmt), raw)

    def test_original_nested_channel_priority(self) -> None:
        word = b"\xff\xff"
        cases = [
            ((4, 5, 5), (0, 5, 10)),  # red==5, green==5: double blue
            ((5, 4, 5), (0, 5, 10)),  # red==5, green!=5: double green
            ((5, 5, 4), (0, 5, 10)),  # red!=5: double red
        ]
        for channel_bits, shifts in cases:
            with self.subTest(channel_bits=channel_bits):
                fmt = make_format(shifts=shifts, channel_bits=channel_bits)
                self.assertEqual(
                    run_conversion(self.library, word, fmt),
                    reference_transform(word, fmt),
                )

    def test_shift_count_mask_ushort_truncation_and_odd_tail(self) -> None:
        raw = b"\xff\xff\x00\x7c\x5a"
        fmt = make_format(
            shifts=(255, 32, 223),
            channel_bits=(6, 5, -128),
        )
        actual = run_conversion(self.library, raw, fmt)
        self.assertEqual(actual, reference_transform(raw, fmt))
        self.assertEqual(actual[-1], 0x5A)

    def test_rgba_adapter_expands_rgb555_primaries(self) -> None:
        raw = b"\x00\x7c\xe0\x03\x1f\x00"
        output = (ctypes.c_uint8 * 12)()
        source = (ctypes.c_uint8 * len(raw)).from_buffer_copy(raw)
        status = self.library.cif_pixels_rgb555_to_rgba(
            source, len(raw), output, len(output)
        )
        self.assertEqual(status, 1)
        self.assertEqual(
            bytes(output),
            bytes((255, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255)),
        )

    def test_rgba_adapter_rejects_short_output(self) -> None:
        raw = (ctypes.c_uint8 * 2)(0, 0)
        output = (ctypes.c_uint8 * 3)()
        self.assertEqual(
            self.library.cif_pixels_rgb555_to_rgba(raw, 2, output, len(output)),
            0,
        )


if __name__ == "__main__":
    unittest.main()
