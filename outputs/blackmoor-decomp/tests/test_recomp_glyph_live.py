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
import repeat_glyph_live as repeat
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


class RepeatGlyphInputTests(unittest.TestCase):
    def test_preflight_requires_paid_junior_used5_without_later_word_progression(self):
        _, one, zero = check_route.word_lock_configuration('paid-light-request')
        data = bytearray(170770)
        for value, offset in ((0, 0x9034), (-1, 0x10e), (3510, 0x21642), (3510, 0x21646), (4, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        struct.pack_into('<I', data, 0x2ba + 4*5, 1)
        for fmt, offset, value in (('<I', 0x2430, 14*60+38), ('<H', 0x2434, 38), ('<H', 0x2436, 14), ('<H', 0x2438, 3)):
            struct.pack_into(fmt, data, offset, value)
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / 'synthetic.SAV'
            source.write_bytes(data)
            self.assertEqual(repeat.source_state(source)['inventory'], {4: 0, 5: 1, 13: 0})
            for fmt, offset, value in (('<h', 0x9034, 2), ('<I', 0x2ba + 4*5, 0),
                    ('<I', 0x2ba + 4*4, 1), ('<I', 0x1ee6 + 4*1809, 0),
                    ('<I', 0x1ee6 + 4*1418, 0), ('<I', 0x1ee6 + 4*2001, 0), ('<I', 0x1ee6 + 4*2018, 1)):
                changed = bytearray(data)
                struct.pack_into(fmt, changed, offset, value)
                source.write_bytes(changed)
                with self.assertRaisesRegex(ValueError, 'first-paid pending Junior'):
                    repeat.source_state(source)

    def test_exact_first_paid_operator_payloads_and_retained_reload_prefix(self):
        for payload, digest in ((repeat.caption_payload(), 'c50f2e849cb05ab38e91f82484fe3543458471bfdfec9519fc66edc97e5fa086'),
                (repeat.bye_payload(), '8de547a400c20980c9f5f5dd0664db0f6d7839ac3f6e992270822b8cadaa33d4'),
                (repeat.inventory_payload(), '26908e7ba49e0d00ff855601461ec87094e9fb692962d3ba09b44148067d819f'),
                (repeat.save_payload('m38'), '89a0534c1e89ba265d58aa1629d415a310cbd567634ffcc5c615b3c9d6c001b8')):
            self.assertEqual(hashlib.sha256(payload.encode()).hexdigest(), digest)
        self.assertTrue(repeat.reload_payload().endswith('S3510.CIF+73000:move:320,60;S3510.CIF+76000:shot:0,0'))
        self.assertEqual(repeat.save_payload('m38').split('24000:key:')[0], repeat.save_payload('m381').split('24000:key:')[0])
        self.assertIs(repeat.send, glyph.send)
        with self.assertRaises(ValueError):
            repeat.save_payload('continue')

    def test_old2001_and_handoff_without_new_board_win_are_not_fresh_win_proof(self):
        def opened(*scenes):
            return ''.join('  FILE open C:\\GAME\\Ciftree\\S%d.CIF  [virtual %d ms]\n' % (scene, i+1)
                           for i, scene in enumerate(scenes))
        old = '  FLAGS 1357=1 2001=1\n'
        for scenes in ((), (3588,), (1295, 1949), (1299, 3588), (3588, 1295, 1949)):
            self.assertFalse(repeat.has_fresh_win(old + opened(*scenes)))
        self.assertTrue(repeat.has_fresh_win(old + opened(3588, 1299, 1295, 1949)))

    def test_reload_requires_actual4_clear_pending_scope_and_final_safe_pair(self):
        from types import SimpleNamespace
        _, one, zero = check_route.word_lock_configuration('repeat-glyph-win')
        def observations():
            raw = {f: 1 for f in one}
            raw.update({338: (14*60+59) << 16, 339: 59 << 16, 340: (3 << 16) | 14, 341: 0})
            return [{'state': [3510, 3510, 4, held], 'scope': repeat.rc_flags(), 'flags': dict(raw)}
                    for held in (-1, -1, 4, -1, -1)]
        repeat.verify_reload(SimpleNamespace(observations=observations()))
        for failure in ('used5', 'pending', 'scope', 'safe_pair'):
            frames = observations()
            if failure == 'used5':
                frames[2]['state'][3] = 5
            elif failure == 'pending':
                frames[1]['flags'][1809] = 1
            elif failure == 'scope':
                frames[1]['scope'] = '338-341,1000-1808,1810-2250'
            else:
                frames[-1]['state'][3] = 4
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                repeat.verify_reload(SimpleNamespace(observations=frames))


if __name__ == '__main__':
    unittest.main()
