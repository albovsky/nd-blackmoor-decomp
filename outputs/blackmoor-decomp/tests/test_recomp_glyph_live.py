"""Finite synthetic glyph input tests; no game, assets or native child."""
import hashlib
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import bul_live as io
import check_route
import glyph_live as glyph
import glyph_pixels as pixels
sys.path.pop(0)


def synthetic_board():
    data = bytearray([32]) * (640 * 480 * 3)
    keys = {}
    for index in range(35):
        row, col = divmod(index, 7)
        kind = index % 25
        color = bytes((3 + 7*kind, 5 + 9*kind, 7 + 8*kind))
        tile = color * (34 * 34)
        keys[hashlib.sha256(tile).hexdigest()] = {'reference': 'ignored metadata'}
        for y in range(68 + 41*row, 68 + 41*row + 34):
            start = (y * 640 + 75 + 41*col) * 3
            data[start:start + 34*3] = color * 34
    return data, {'tile_hashes': keys, 'sources': ['never opened']}


class GlyphInputTests(unittest.TestCase):
    def test_pinned_atlas_and_closed_native_capture_classify_all_cells(self):
        data, atlas = synthetic_board()
        with tempfile.TemporaryDirectory() as folder:
            atlas_path, capture = Path(folder) / 'atlas.json', Path(folder) / 'capture.ppm'
            atlas_path.write_text(json.dumps(atlas))
            capture.write_bytes(b'P6 640 480 255\n' + data)
            known = pixels.load_atlas(atlas_path, io.digest(atlas_path))
            board, hashes = pixels.read_board(capture, known)
            self.assertEqual([len(row) for row in board], [7] * 5)
            self.assertEqual(len({value for row in board for value in row}), 25)
            self.assertEqual(board[0][0], board[3][4])
            self.assertTrue({value for row in hashes for value in row} <= known)

    def test_wrong_atlas_pin_schema_unknown_and_truncated_crops_refuse(self):
        data, atlas = synthetic_board()
        with tempfile.TemporaryDirectory() as folder:
            atlas_path, capture = Path(folder) / 'atlas.json', Path(folder) / 'capture.ppm'
            atlas_path.write_text(json.dumps(atlas))
            with self.assertRaisesRegex(ValueError, 'SHA-256'):
                pixels.load_atlas(atlas_path, '0' * 64)
            known = pixels.load_atlas(atlas_path, io.digest(atlas_path))
            for invalid in ({'tile_hashes': dict(list(atlas['tile_hashes'].items())[:-1])},
                            {'tile_hashes': dict(list(atlas['tile_hashes'].items())[:-1], invalid={})}):
                atlas_path.write_text(json.dumps(invalid))
                with self.assertRaisesRegex(ValueError, '25 SHA-256'):
                    pixels.load_atlas(atlas_path, io.digest(atlas_path))
            data[(68 * 640 + 75) * 3] = 255
            capture.write_bytes(b'P6 640 480 255\n' + data)
            with self.assertRaisesRegex(ValueError, 'unknown actual tile'):
                pixels.read_board(capture, known)
            capture.write_bytes(b'P6 640 480 255\n' + data[:-1])
            with self.assertRaisesRegex(ValueError, 'closed 640x480'):
                pixels.read_board(capture, known)

    def test_preserved_events_prefix_and_name_only_operator_save_timing(self):
        events = pixels.events({'swaps': [[[0, 0], [1, 2]], [[3, 4], [2, 6]]]})
        clicks = [event for event in events if event['kind'] == 'click']
        self.assertEqual([event['after_ms'] for event in clicks], [150, 650, 1350, 1850])
        self.assertEqual([event['hold_ms'] for event in clicks], [250] * 4)
        self.assertTrue(glyph.event_payload(events).startswith('50:move:92,85;150:click:92,85,250;'))
        self.assertEqual(hashlib.sha256((glyph.board_prefix() + '\n').encode()).hexdigest(),
                         '530a01dd5d99eed87ab1819e32092a42dd97c73cf183bbc686e069aeb517d3cd')
        original = glyph.inventory_save_payload('m29')
        self.assertEqual(hashlib.sha256(original.encode()).hexdigest(), 'b851e99af7872e302a55632f94831fe6b4a2ab77bbe558746e64ca58be0b93ad')
        named = glyph.inventory_save_payload('m301')
        self.assertEqual(original.split('36101:key:', 1)[0], named.split('36101:key:', 1)[0])
        self.assertTrue(named.endswith('43201:shot:0,0'))
        with self.assertRaises(ValueError):
            glyph.inventory_save_payload('continue')

    def test_first_time_source_refuses_repeat_senior_and_missing_request(self):
        _, one, zero = check_route.dragon_light_configuration('glyph-request')
        data = bytearray(170770)
        for name, value, offset in (('difficulty', 0, 0x9034), ('held', -1, 0x10e),
                ('scene', 3510, 0x21642), ('art', 3510, 0x21646), ('view', 4, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        for fmt, offset, value in (('<I', 0x2430, 16*60+32), ('<H', 0x2434, 32),
                                   ('<H', 0x2436, 16), ('<H', 0x2438, 2)):
            struct.pack_into(fmt, data, offset, value)
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / 'synthetic.SAV'
            source.write_bytes(data)
            self.assertEqual(glyph.source_state(source)['difficulty'], 0)
            for fmt, offset, value in (('<I', 0x1ee6 + 4*2001, 1), ('<I', 0x1ee6 + 4*1357, 1),
                                      ('<I', 0x1ee6 + 4*1418, 0), ('<h', 0x9034, 2)):
                changed = bytearray(data)
                struct.pack_into(fmt, changed, offset, value)
                source.write_bytes(changed)
                with self.assertRaisesRegex(ValueError, 'first-time pending Junior'):
                    glyph.source_state(source)

    def test_explicit_scope_preserves_bul_default_and_complete_glyph_union(self):
        _, one, zero = check_route.passage_configuration('bul-key')
        expected = ','.join(map(str, sorted(one | zero | set(range(338, 342)))))
        self.assertEqual(io.flag_scope(), expected)
        custom = glyph.rc_flags()
        self.assertEqual(io.flag_scope(custom), custom)
        _, glyph_one, glyph_zero = check_route.glyph_win_configuration()
        self.assertEqual(check_route.flag_scope(custom), glyph_one | glyph_zero)
        self.assertIn(1357, check_route.flag_scope(custom))
        self.assertNotIn(1357, check_route.flag_scope(expected))
        with self.assertRaises(ValueError):
            io.flag_scope('')


if __name__ == '__main__':
    unittest.main()
