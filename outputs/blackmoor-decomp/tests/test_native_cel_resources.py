"""Normal native CAL resource checks; no target/oracle, device or fault runs."""
import json
from pathlib import Path
import subprocess
import struct
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parent.parent


def literal_stream(data):
    plain = bytearray()
    for start in range(0, len(data), 8):
        group = data[start:start + 8]
        plain.append((1 << len(group)) - 1)
        plain.extend(group)
    return bytes((value + index) & 255 for index, value in enumerate(plain))


def synthetic_resources(directory, original):
    """Valid invented images, including a cross-load retained-ring reference."""
    (directory / 'CIFTREE.DAT').symlink_to(original / 'CIFTREE.DAT')
    sheet = bytearray(42 + 2 * 140)
    sheet[:20] = b'XSHEET WayneSikes\0\0\0'
    struct.pack_into('<HHI', sheet, 34, 2, 1, 77)
    sheet[42:45] = b'F0\0'
    sheet[182:185] = b'F1\0'
    compressed = literal_stream(sheet)
    header = bytearray(81)
    header[:20] = b'CIF FILE WayneSikes\0'
    struct.pack_into('<HH', header, 24, 2, 1)
    header[67] = 2
    struct.pack_into('<I', header, 68, len(sheet))
    struct.pack_into('<I', header, 76, len(compressed))
    header[80] = 3
    (directory / 'sHeEt.CiF').write_bytes(header + compressed)

    tree = bytearray(2080 + 2 * 94)
    tree[:20] = b'CIF TREE WayneSikes\0'
    struct.pack_into('<HHHBB', tree, 24, 2, 1, 2, 2, 1)
    tree[32:2080] = b'\xff' * 2048
    first = struct.pack('<6H', 1, 2, 3, 4, 5, 6)
    # Flag 0, ring offset 0xfee, length 12, then counter obfuscation.
    streams = [literal_stream(first), bytes((0, 0xef, 0xfb))]
    for index, (name, stream) in enumerate(zip((b'F0', b'F1'), streams)):
        offset = 2080 + index * 94
        tree[offset:offset + len(name)] = name
        struct.pack_into('<HIH', tree, offset + 33, index, len(tree), 0xffff)
        struct.pack_into('<8i3HBB', tree, offset + 41,
                         1, 0, 2, 1, -8, -3, -7, -2, 3, 6, 2, 16, 2)
        struct.pack_into('<I', tree, offset + 81, len(first))
        struct.pack_into('<I', tree, offset + 89, len(stream))
        tree[offset + 93] = 2
        struct.pack_into('<H', tree, 32 + (sum(name) & 1023) * 2, index)
        tree.extend(stream)
    (directory / 'mOtIoN.CaL').write_bytes(tree)


class NativeCelResourcesTests(unittest.TestCase):
    def test_owned_jane_frames_and_release_boundaries(self):
        # Catches missing CAL lookup, wrong rectangles/pitch, aliased ownership,
        # stale handles, and leaked headers/layers. Expectations are independent
        # static metadata from the owned game's XSHEET/CAL records.
        self.assertTrue((PROJECT / 'src/native_cel_resources.h').is_file(),
                        'native CAL resource API is missing')
        descriptor = WORKSPACE / 'work/analysis/game-source.json'
        self.assertTrue(descriptor.is_file(), 'owned game descriptor is required')
        game = Path(json.loads(descriptor.read_text())['game_dir'])
        directory = next(p for p in game.iterdir() if p.name.upper() == 'CIFTREE')
        with tempfile.TemporaryDirectory(prefix='native-cel-check-') as temporary:
            binary = Path(temporary) / 'check'
            synthetic = Path(temporary) / 'synthetic'
            synthetic.mkdir()
            synthetic_resources(synthetic, directory)
            sources = ['native_cel_resources.c', 'game_resources.c', 'cif_archive.c',
                       'cif_image.c', 'cif_pixels.c']
            result = subprocess.run(['cc', '-std=c11', '-O2', '-Wall', '-Wextra', '-Wpedantic',
                '-Werror', '-I', str(PROJECT / 'src'),
                str(PROJECT / 'tests/native_cel_resources_test.c'),
                *[str(PROJECT / 'src' / source) for source in sources], '-o', str(binary)],
                text=True, capture_output=True, check=False)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            result = subprocess.run([str(binary), str(directory), str(synthetic)], text=True,
                                    capture_output=True, check=False)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('native cel resource checks passed', result.stdout)


if __name__ == '__main__':
    unittest.main()
