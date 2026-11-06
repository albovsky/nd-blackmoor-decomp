"""Owned GAME.EXE icon extraction: synthetic malformed inputs and opt-in native conversion."""
from __future__ import annotations

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

PROJECT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('build_game_icon', PROJECT / 'recomp/build_game_icon.py')
icon = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = icon
SPEC.loader.exec_module(icon)


def dib(size):
    xor = ((size * 4 + 31) // 32) * 4 * size
    mask = ((size + 31) // 32) * 4 * size
    header = struct.pack('<IiiHHIIiiII', 40, size, size * 2, 1, 4, 0, xor, 0, 0, 0, 0)
    palette = b''.join(bytes((n * 16, 0, 255 - n * 16, 0)) for n in range(16))
    return header + palette + bytes([0x12]) * xor + bytes(mask)


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
    def test_group_and_ico_preserve_original_sized_payloads(self):
        group, payloads = resources()
        images = icon.parse_group(group, payloads)
        self.assertEqual([image.size for image in images], [32, 16])
        ico = icon.make_ico(images)
        self.assertEqual(struct.unpack_from('<HHH', ico), (0, 1, 2))
        for n, image in enumerate(images):
            entry = struct.unpack_from('<BBBBHHII', ico, 6 + 16 * n)
            self.assertEqual(entry[:6], (image.size, image.size, 16, 0, 1, 4))
            self.assertEqual(ico[entry[7]:entry[7] + entry[6]], payloads[n + 1])

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
            subprocess.run(['/usr/bin/iconutil', '-c', 'iconset', str(output), '-o', str(decoded)], check=True, capture_output=True)
            for name, size in icon.ICONSET_SIZES:
                self.assertEqual(icon.png_size(decoded / name), (size, size))
            before = output.read_bytes()
            with patch.object(icon, 'run_tool', side_effect=icon.IconError('conversion failed')):
                with self.assertRaisesRegex(icon.IconError, 'conversion failed'):
                    icon.convert_icons(icon.parse_group(group, payloads), output)
            self.assertEqual(output.read_bytes(), before)

    @unittest.skipUnless(os.environ.get('BLACKMOOR_ICON_EXE'), 'set BLACKMOOR_ICON_EXE for owner-original conversion')
    def test_owned_original_conversion(self):
        with tempfile.TemporaryDirectory() as scratch:
            output = Path(scratch) / 'AppIcon.icns'
            icon.build_icon(Path(os.environ['BLACKMOOR_ICON_EXE']), output)
            self.assertEqual(output.read_bytes()[:4], b'icns')


if __name__ == '__main__':
    unittest.main()
