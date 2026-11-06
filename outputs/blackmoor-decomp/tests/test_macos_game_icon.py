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


def png_chunk(tag, payload):
    return struct.pack('>I', len(payload)) + tag + payload + struct.pack('>I', zlib.crc32(tag + payload))


def native_png(size, rgba, *, color=6, filters=(0,)):
    """Independent test encoder, including inverse row filters and RGB input."""
    channels = 4 if color == 6 else 3
    pixels = rgba if channels == 4 else bytes(value for n, value in enumerate(rgba) if n % 4 != 3)
    stride = size * channels
    raw = bytearray()
    previous = bytes(stride)
    for y in range(size):
        row = pixels[y * stride:(y + 1) * stride]
        kind = filters[y % len(filters)]
        raw.append(kind)
        for x, value in enumerate(row):
            left = row[x - channels] if x >= channels else 0
            up = previous[x]
            upper_left = previous[x - channels] if x >= channels else 0
            paeth = min((left, up, upper_left), key=lambda candidate: abs(left + up - upper_left - candidate))
            raw.append((value - (0, left, up, (left + up) // 2, paeth)[kind]) % 256)
        previous = row
    header = struct.pack('>IIBBBBB', size, size, 8, color, 0, 0, 0)
    return b'\x89PNG\r\n\x1a\n' + png_chunk(b'IHDR', header) + png_chunk(b'IDAT', zlib.compress(raw)) + png_chunk(b'IEND', b'')


def conversion_images():
    # A controlled blue=0 palette makes the native trailing-blue defect harmless
    # without excluding any pixel. The full varied palette remains in PNG tests
    # and the explicit native-rejection test below.
    group, payloads = resources()
    for key, value in payloads.items():
        data = bytearray(value)
        for offset in range(40, 104, 4):
            data[offset] = 0
        payloads[key] = bytes(data)
    return icon.parse_group(group, payloads)


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


class NativePngTests(unittest.TestCase):
    def test_rgb_rgba_and_all_five_filters(self):
        for size in (16, 32):
            expected = expected_pixels(size)
            for color in (2, 6):
                with self.subTest(size=size, color=color):
                    data = native_png(size, expected, color=color, filters=(0, 1, 2, 3, 4))
                    opaque = bytes(value if n % 4 != 3 else 255 for n, value in enumerate(expected))
                    self.assertEqual(icon.decode_png(data, size), expected if color == 6 else opaque)

    def test_rejects_unsupported_and_malformed_native_pngs(self):
        size = 16
        rgba = expected_pixels(size)
        header = struct.pack('>IIBBBBB', size, size, 8, 6, 0, 0, 0)
        raw = b''.join(b'\0' + rgba[y * size * 4:(y + 1) * size * 4] for y in range(size))
        compressed = zlib.compress(raw)
        signature = b'\x89PNG\r\n\x1a\n'
        end = png_chunk(b'IEND', b'')
        def assemble(ihdr=header, payload=compressed):
            return signature + png_chunk(b'IHDR', ihdr) + png_chunk(b'IDAT', payload) + end
        valid = assemble()
        cases = [
            ('signature', b'not a PNG', 'signature'),
            ('truncated', valid[:-1], 'length|truncated'),
            ('CRC', valid[:-1] + bytes([valid[-1] ^ 1]), 'CRC'),
            ('trailing', valid + b'x', 'trailing'),
            ('oversized', signature + bytes(1024 * 1024), 'limit'),
            ('chunk length', signature + struct.pack('>I4s', 0xffffffff, b'IHDR'), 'length|truncated'),
            ('missing end', valid[:-12], 'IEND'),
            ('missing data', signature + png_chunk(b'IHDR', header) + end, 'IDAT'),
            ('short header', assemble(header[:-1]), 'IHDR'),
            ('duplicate header', signature + png_chunk(b'IHDR', header) + valid[8:], 'IHDR'),
            ('critical chunk', valid[:33] + png_chunk(b'ABCD', b'') + valid[33:], 'critical'),
            ('invalid type', valid[:33] + png_chunk(b'AB1D', b'') + valid[33:], 'type'),
            ('reserved type bit', valid[:33] + png_chunk(b'abcd', b'') + valid[33:], 'type'),
            ('missing header', signature + png_chunk(b'IDAT', compressed) + end, 'IHDR'),
            ('transparency chunk', valid[:33] + png_chunk(b'tRNS', bytes(6)) + valid[33:], 'transparency'),
            ('nonconsecutive data', signature + png_chunk(b'IHDR', header) + png_chunk(b'IDAT', compressed[:5])
             + png_chunk(b'tEXt', b'key\0value') + png_chunk(b'IDAT', compressed[5:]) + end, 'IDAT'),
            ('invalid end', valid[:-12] + png_chunk(b'IEND', b'x'), 'IEND'),
            ('bad zlib', assemble(payload=b'not zlib'), 'decompression'),
            ('truncated zlib', assemble(payload=compressed[:-1]), 'decompression'),
            ('trailing zlib', assemble(payload=compressed + b'x'), 'decompression'),
            ('short pixels', assemble(payload=zlib.compress(raw[:-1])), 'decompression'),
            ('long pixels', assemble(payload=zlib.compress(raw + b'x')), 'decompression'),
            ('bounded inflate', assemble(payload=zlib.compress(bytes(1000000))), 'decompression'),
            ('filter', assemble(payload=zlib.compress(b'\5' + raw[1:])), 'filter'),
        ]
        for index, value, label in ((0, 17, 'dimensions'), (2, 16, 'encoding'), (3, 3, 'encoding'),
                                    (4, 1, 'encoding'), (5, 1, 'encoding'), (6, 1, 'encoding')):
            fields = [size, size, 8, 6, 0, 0, 0]
            fields[index] = value
            cases.append((label + str(index), assemble(struct.pack('>IIBBBBB', *fields)), label))
        for label, data, message in cases:
            with self.subTest(case=label):
                with self.assertRaisesRegex(icon.IconError, 'PNG.*(' + message + ')'):
                    icon.decode_png(data, size)
        # Native ancillary metadata is permitted, with its CRC still checked.
        metadata = valid[:33] + png_chunk(b'tEXt', b'key\0value') + valid[33:]
        self.assertEqual(icon.decode_png(metadata, size), rgba)


@unittest.skipUnless(sys.platform == 'darwin', 'native sips/iconutil require macOS')
class NativeConversionTests(unittest.TestCase):
    def test_synthetic_conversion_and_atomic_failure(self):
        images = conversion_images()
        with tempfile.TemporaryDirectory() as scratch:
            output = Path(scratch) / 'AppIcon.icns'
            icon.convert_icons(images, output)
            self.assertGreater(output.stat().st_size, 8)
            self.assertEqual(output.read_bytes()[:4], b'icns')
            decoded = Path(scratch) / 'decoded.iconset'
            decode_icns(output, decoded)
            for name, size in icon.ICONSET_SIZES:
                width, height, rgba = png_pixels((decoded / name).read_bytes())
                self.assertEqual((width, height), (size, size))
                self.assertIn(0, set(rgba[3::4]))
                self.assertIn(255, set(rgba[3::4]))
            for image in images:
                assert_pixels(self, (decoded / f'icon_{image.size}x{image.size}.png').read_bytes(),
                              dib_pixels(image), image.size)
            before = output.read_bytes()
            with patch.object(icon, 'run_tool', side_effect=icon.IconError('conversion failed')):
                with self.assertRaisesRegex(icon.IconError, 'conversion failed'):
                    icon.convert_icons(images, output)
            self.assertEqual(output.read_bytes(), before)

    def test_correct_size_wrong_native_pixels_are_refused_atomically(self):
        images = conversion_images()
        original_tool = icon.run_tool
        for size in (16, 32):
            for corruption in ('alpha', 'RGB', 'CRC'):
                with self.subTest(size=size, corruption=corruption), tempfile.TemporaryDirectory() as scratch:
                    output = Path(scratch) / 'AppIcon.icns'
                    before = b'existing icon must survive a failed build'
                    output.write_bytes(before)
                    def corrupt(command):
                        original_tool(command)
                        if command[:3] == ['/usr/bin/iconutil', '-c', 'iconset']:
                            expected = dib_pixels(next(image for image in images if image.size == size))
                            wrong = bytearray(expected)
                            visible = next(n for n in range(0, len(wrong), 4) if wrong[n + 3])
                            if corruption != 'CRC':
                                wrong[visible + (3 if corruption == 'alpha' else 0)] ^= 1
                            data = native_png(size, wrong)
                            if corruption == 'CRC':
                                data = data[:-1] + bytes([data[-1] ^ 1])
                            path = Path(command[-1]) / f'icon_{size}x{size}.png'
                            path.write_bytes(data)
                    with patch.object(icon, 'run_tool', side_effect=corrupt):
                        with self.assertRaisesRegex(icon.IconError, 'pixel mismatch|PNG.*CRC'):
                            icon.convert_icons(images, output)
                    self.assertEqual(output.read_bytes(), before)

    def test_varied_native_palette_is_refused_if_roundtrip_changes_pixels(self):
        images = icon.parse_group(*resources())
        original_tool = icon.run_tool
        mismatches = []
        def observe(command):
            original_tool(command)
            if command[:3] == ['/usr/bin/iconutil', '-c', 'iconset']:
                for image in images:
                    actual = png_pixels((Path(command[-1]) / f'icon_{image.size}x{image.size}.png').read_bytes())[2]
                    expected = expected_pixels(image.size)
                    mismatches.extend(n for n in range(0, len(expected), 4)
                                      if actual[n + 3] != expected[n + 3] or expected[n + 3] and actual[n:n + 3] != expected[n:n + 3])
        with tempfile.TemporaryDirectory() as scratch:
            output = Path(scratch) / 'AppIcon.icns'
            before = b'preserve prior icon on actual native palette corruption'
            output.write_bytes(before)
            error = None
            with patch.object(icon, 'run_tool', side_effect=observe):
                try:
                    icon.convert_icons(images, output)
                except icon.IconError as caught:
                    error = caught
            if mismatches:
                # macOS 27.2: native iconutil clears trailing blue bytes for this
                # palette (last 1/3 pixels at 16/32px). The production gate must
                # reject every such discrepancy, including those edge pixels.
                self.assertIsNotNone(error, 'native corruption was silently published')
                self.assertIn('pixel mismatch', str(error))
                self.assertEqual(output.read_bytes(), before)
            else:
                # A future native tool may fix the defect; accept only exact pixels.
                self.assertIsNone(error)
                decoded = Path(scratch) / 'decoded.iconset'
                decode_icns(output, decoded)
                for image in images:
                    assert_pixels(self, (decoded / f'icon_{image.size}x{image.size}.png').read_bytes(),
                                  expected_pixels(image.size), image.size)

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
