"""Owned GAME.EXE icon extraction: synthetic malformed inputs and opt-in native conversion."""
from __future__ import annotations

import hashlib
import importlib.util
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import zlib

PROJECT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('build_game_icon', PROJECT / 'recomp/build_game_icon.py')
icon = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = icon
SPEC.loader.exec_module(icon)


# Hand-authored RGB palette and top/middle/bottom patterns exercise both nibbles,
# every palette entry, bottom-up rows, high-bit-first masks and mask row padding.
PALETTE = ((3, 17, 239), (240, 11, 31), (61, 200, 4), (125, 43, 219),
           (72, 155, 201), (208, 92, 14), (19, 231, 107), (183, 6, 142),
           (44, 78, 99), (151, 193, 52), (226, 119, 67), (87, 34, 176),
           (168, 214, 133), (12, 103, 248), (198, 65, 158), (113, 247, 22))


def dib(size):
    xor_stride = size // 2
    mask_stride = 4
    header = struct.pack('<IiiHHIIiiII', 40, size, size * 2, 1, 4, 0, xor_stride * size, 0, 0, 0, 0)
    palette = b''.join(bytes((b, g, r, index * 13)) for index, (r, g, b) in enumerate(PALETTE))
    repeat = size // 16
    xor_rows = [bytes.fromhex('f0 e1 d2 c3 b4 a5 96 87') * repeat]
    xor_rows += [b'\x4b' * xor_stride] * (size - 2)
    xor_rows += [bytes.fromhex('01 23 45 67 89 ab cd ef') * repeat]
    padding = b'\xff' * (mask_stride - size // 8)
    mask_rows = [bytes.fromhex('01 80') * repeat + padding]
    mask_rows += [bytes.fromhex('55 aa') * repeat + padding] * (size - 2)
    mask_rows += [bytes.fromhex('a5 3c') * repeat + padding]
    return header + palette + b''.join(xor_rows) + b''.join(mask_rows)


def expected_pixels(size):
    # Expectations are explicit display-order indices/mask bits, not a DIB decoder.
    top = tuple(range(16))
    middle = (4, 11) * 8
    bottom = (15, 0, 14, 1, 13, 2, 12, 3, 11, 4, 10, 5, 9, 6, 8, 7)
    top_mask = (1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0)
    middle_mask = (0, 1) * 4 + (1, 0) * 4
    bottom_mask = (0,) * 7 + (1, 1) + (0,) * 7
    rows = [(top, top_mask)] + [(middle, middle_mask)] * (size - 2) + [(bottom, bottom_mask)]
    return bytes(channel for indices, mask in rows
                 for index, hidden in zip(indices * (size // 16), mask * (size // 16))
                 for channel in (*PALETTE[index], 0 if hidden else 255))


def dib_pixels(image):
    # Independent source oracle: expand whole packed rows, reverse row lists,
    # and read the AND row as a bit string rather than address each source pixel.
    size = image.size
    palette = [tuple(image.data[offset:offset + 3][::-1]) for offset in range(40, 104, 4)]
    xor_stride = size // 2
    mask_start = 104 + xor_stride * size
    rows = []
    for row in range(size):
        packed = image.data[104 + row * xor_stride:104 + (row + 1) * xor_stride]
        indices = [index for value in packed for index in divmod(value, 16)]
        mask = ''.join(f'{value:08b}' for value in image.data[mask_start + row * 4:mask_start + row * 4 + 4])
        rows.append(bytes(channel for index, hidden in zip(indices, mask)
                          for channel in (*palette[index], 0 if hidden == '1' else 255)))
    return b''.join(reversed(rows))


def png_pixels(data):
    # Test-only PNG reader checks CRCs and reconstructs native PNG row filters;
    # it does not call the production DIB decoder or a native image decoder.
    assert data[:8] == b'\x89PNG\r\n\x1a\n'
    offset = 8
    compressed = bytearray()
    while offset < len(data):
        length, tag = struct.unpack_from('>I4s', data, offset)
        payload = data[offset + 8:offset + 8 + length]
        assert zlib.crc32(tag + payload) == struct.unpack_from('>I', data, offset + 8 + length)[0]
        if tag == b'IHDR':
            width, height, bits, color, compression, filtering, interlace = struct.unpack('>IIBBBBB', payload)
            assert bits == 8 and color in (2, 6) and (compression, filtering, interlace) == (0, 0, 0)
        elif tag == b'IDAT':
            compressed.extend(payload)
        offset += length + 12
        if tag == b'IEND':
            break
    assert offset == len(data)
    channels = 4 if color == 6 else 3
    stride = width * channels
    raw = zlib.decompress(compressed)
    assert len(raw) == (stride + 1) * height
    previous = [0] * stride
    pixels = bytearray()
    for y in range(height):
        start = y * (stride + 1)
        kind = raw[start]
        assert kind in range(5)
        row = list(raw[start + 1:start + 1 + stride])
        for x in range(stride):
            left = row[x - channels] if x >= channels else 0
            up = previous[x]
            upper_left = previous[x - channels] if x >= channels else 0
            paeth = min((left, up, upper_left), key=lambda value: abs(left + up - upper_left - value))
            predictor = (0, left, up, (left + up) // 2, paeth)[kind]
            row[x] = (row[x] + predictor) % 256
        for x in range(0, stride, channels):
            pixels.extend(row[x:x + 3])
            pixels.append(row[x + 3] if channels == 4 else 255)
        previous = row
    return width, height, bytes(pixels)


def assert_pixels(case, png, expected, size, *, check_rgb=True):
    width, height, actual = png_pixels(png)
    case.assertEqual((width, height), (size, size))
    for offset in range(0, len(expected), 4):
        case.assertEqual(actual[offset + 3], expected[offset + 3], ('alpha', size, offset // 4))
        if check_rgb and expected[offset + 3]:
            case.assertEqual(actual[offset:offset + 3], expected[offset:offset + 3], ('RGB', size, offset // 4))


def decode_icns(output, destination):
    subprocess.run(['/usr/bin/iconutil', '-c', 'iconset', str(output), '-o', str(destination)], check=True, capture_output=True)


def resources():
    icons = {1: dib(32), 2: dib(16)}
    group = struct.pack('<HHH', 0, 1, 2)
    for size, resource_id in ((32, 1), (16, 2)):
        group += struct.pack('<BBBBHHIH', size, size, 16, 0, 1, 4, len(icons[resource_id]), resource_id)
    return group, icons


def fake_pe(group, icons, language=1033):
    payloads = {100: group, **{200 + key: value for key, value in icons.items()}}
    def resource(kind, entries):
        names = []
        for resource_id, offset in entries:
            leaf = NS(id=language, data=NS(struct=NS(OffsetToData=offset, Size=len(payloads[offset]))))
            names.append(NS(id=resource_id, directory=NS(entries=[leaf])))
        return NS(id=kind, directory=NS(entries=names))
    return NS(DIRECTORY_ENTRY_RESOURCE=NS(entries=[resource(14, [(128, 100)]), resource(3, [(i, 200 + i) for i in icons])]),
              get_data=lambda offset, size: payloads[offset][:size])


class IconParsingTests(unittest.TestCase):
    def test_group_preserves_original_sized_payloads(self):
        group, payloads = resources()
        images = icon.parse_group(group, payloads)
        self.assertEqual([image.size for image in images], [32, 16])
        self.assertEqual([image.data for image in images], [payloads[1], payloads[2]])
        for image in images:
            self.assertEqual(dib_pixels(image), expected_pixels(image.size))

    def test_rgba_png_matches_hand_specified_palette_rows_and_mask(self):
        for image in icon.parse_group(*resources()):
            with self.subTest(size=image.size):
                width, height, rgba = png_pixels(icon.make_png(image))
                self.assertEqual((width, height), (image.size, image.size))
                self.assertEqual(rgba, expected_pixels(image.size))

    def test_resource_selection_requires_exact_group_and_language(self):
        group, payloads = resources()
        self.assertEqual(icon.extract_icons(fake_pe(group, payloads)), icon.parse_group(group, payloads))
        with self.assertRaisesRegex(icon.IconError, '1033'):
            icon.extract_icons(fake_pe(group, payloads, language=0))
        missing = fake_pe(group, payloads)
        missing.DIRECTORY_ENTRY_RESOURCE.entries[0].directory.entries[0].id = 129
        with self.assertRaisesRegex(icon.IconError, '128'):
            icon.extract_icons(missing)
        duplicate = fake_pe(group, payloads)
        duplicate.DIRECTORY_ENTRY_RESOURCE.entries.append(duplicate.DIRECTORY_ENTRY_RESOURCE.entries[0])
        with self.assertRaisesRegex(icon.IconError, 'ambiguous'):
            icon.extract_icons(duplicate)

    def test_rejects_malformed_group(self):
        group, payloads = resources()
        variants = [b'', group[:5], group[:-1], group + b'x']
        for offset, value in ((0, 1), (2, 2), (4, 0), (6, 0), (7, 16), (8, 0), (9, 1), (10, 0), (12, 8), (14, 1), (18, 2)):
            changed = bytearray(group)
            changed[offset] = value
            variants.append(bytes(changed))
        for bad in variants:
            with self.subTest(group=bad.hex()):
                with self.assertRaises(icon.IconError):
                    icon.parse_group(bad, payloads)

    def test_rejects_missing_truncated_or_inconsistent_icon(self):
        group, payloads = resources()
        with self.assertRaisesRegex(icon.IconError, 'resource 1'):
            icon.parse_group(group, {2: payloads[2]})
        variants = [b'', payloads[1][:-1], payloads[1] + b'x']
        for offset, value in ((0, 39), (4, 31), (8, 32), (12, 2), (14, 8), (16, 1), (20, 1), (32, 17)):
            changed = bytearray(payloads[1])
            changed[offset] = value
            variants.append(bytes(changed))
        for bad in variants:
            with self.subTest(header=bad[:40].hex()):
                with self.assertRaises(icon.IconError):
                    icon.parse_group(group, {1: bad, 2: payloads[2]})

    def test_wrong_original_hash_stops_before_parser_or_output(self):
        with tempfile.TemporaryDirectory() as scratch:
            exe = Path(scratch) / 'GAME.EXE'
            exe.write_bytes(b'not the owned original')
            output = Path(scratch) / 'new' / 'AppIcon.icns'
            with patch.object(icon, 'extract_icons', side_effect=AssertionError('must not parse')):
                with self.assertRaisesRegex(icon.IconError, 'SHA-256'):
                    icon.build_icon(exe, output)
            self.assertFalse(output.parent.exists())
            result = subprocess.run([sys.executable, str(PROJECT / 'recomp/build_game_icon.py'), '--exe', str(exe), '--output', str(output)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 1)
            self.assertIn('SHA-256', result.stderr)
            self.assertNotIn('Traceback', result.stderr)

    def test_truncated_pe_resource_is_rejected(self):
        group, payloads = resources()
        pe = fake_pe(group, payloads)
        original = pe.get_data
        pe.get_data = lambda offset, size: original(offset, size)[:-1]
        with self.assertRaisesRegex(icon.IconError, 'truncated'):
            icon.extract_icons(pe)


@unittest.skipUnless(sys.platform == 'darwin', 'native sips/iconutil require macOS')
class NativeConversionTests(unittest.TestCase):
    def test_synthetic_conversion_and_atomic_failure(self):
        group, payloads = resources()
        with tempfile.TemporaryDirectory() as scratch:
            output = Path(scratch) / 'AppIcon.icns'
            icon.convert_icons(icon.parse_group(group, payloads), output)
            self.assertGreater(output.stat().st_size, 8)
            self.assertEqual(output.read_bytes()[:4], b'icns')
            decoded = Path(scratch) / 'decoded.iconset'
            decode_icns(output, decoded)
            for name, size in icon.ICONSET_SIZES:
                width, height, rgba = png_pixels((decoded / name).read_bytes())
                self.assertEqual((width, height), (size, size))
                self.assertIn(0, set(rgba[3::4]))
                self.assertIn(255, set(rgba[3::4]))
            # iconutil's small-image roundtrip clears trailing blue bytes for
            # some arbitrary palettes (observed last 1/3 pixels at 16/32px).
            # The varied stdlib PNG test checks every RGBA byte; here every
            # synthetic alpha is exact. The hash-pinned owner test below checks
            # every final visible RGB and alpha, including all edge pixels.
            # This helper does not promise generic final-ICNS RGB losslessness.
            for size in (16, 32):
                assert_pixels(self, (decoded / f'icon_{size}x{size}.png').read_bytes(),
                              expected_pixels(size), size, check_rgb=False)
            before = output.read_bytes()
            with patch.object(icon, 'run_tool', side_effect=icon.IconError('conversion failed')):
                with self.assertRaisesRegex(icon.IconError, 'conversion failed'):
                    icon.convert_icons(icon.parse_group(group, payloads), output)
            self.assertEqual(output.read_bytes(), before)

    @unittest.skipUnless(os.environ.get('BLACKMOOR_ICON_EXE'), 'set BLACKMOOR_ICON_EXE for owner-original conversion')
    def test_owned_original_conversion(self):
        with tempfile.TemporaryDirectory() as scratch:
            output = Path(scratch) / 'AppIcon.icns'
            exe = Path(os.environ['BLACKMOOR_ICON_EXE'])
            before = hashlib.sha256(exe.read_bytes()).hexdigest()
            self.assertEqual(before, icon.ORIGINAL_SHA256)
            icon.build_icon(exe, output)
            import pefile
            with pefile.PE(str(exe)) as pe:
                images = icon.extract_icons(pe)
            decoded = Path(scratch) / 'decoded.iconset'
            decode_icns(output, decoded)
            for image in images:
                expected = dib_pixels(image)
                colors = {expected[n:n + 3] for n in range(0, len(expected), 4) if expected[n + 3]}
                self.assertGreater(len(colors), 1)
                assert_pixels(self, (decoded / f'icon_{image.size}x{image.size}.png').read_bytes(), expected, image.size)
            self.assertEqual(hashlib.sha256(exe.read_bytes()).hexdigest(), before)


if __name__ == '__main__':
    unittest.main()
