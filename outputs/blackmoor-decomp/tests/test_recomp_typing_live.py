"""Finite synthetic typing-tool tests; no OCR process, game, assets or native child."""
import hashlib
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest
from types import SimpleNamespace

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import bul_live as io
import check_route
import typing_ocr as ocr
import typing_live as typing
sys.path.pop(0)


def geometry():
    return [[30+100*(i%5), 20+90*(i//5), 91+100*(i%5), 95+90*(i//5)] for i in range(20)]


class TypingToolTests(unittest.TestCase):
    def test_geometry_pin_bounds_and_proven_threshold5x_mosaic(self):
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder) / 'geometry.json'
            p.write_text(json.dumps({'position_rects': geometry(), 'source': 'ignored metadata'}))
            rects = ocr.load_geometry(p, io.digest(p))
            with self.assertRaisesRegex(ValueError, 'SHA-256'):
                ocr.load_geometry(p, '0'*64)
            bad = geometry()
            bad[0] = [-1, 20, 91, 95]
            p.write_text(json.dumps({'position_rects': bad}))
            with self.assertRaisesRegex(ValueError, 'outside capture'):
                ocr.load_geometry(p, io.digest(p))
        rgb = bytearray([255]) * (640*480*3)
        l, t, r, b = rects[0]
        x, y = (l+r)//2-2, (t+b)//2-2
        i = (y*640+x)*3
        rgb[i:i+3] = bytes((29, 0, 2))
        rgb[i+3:i+6] = bytes((30, 0, 0))
        pgm = ocr.mosaic(rgb, rects)
        header = b'P5\n180 3200\n255\n'
        self.assertTrue(pgm.startswith(header))
        pixels = pgm[len(header):]
        self.assertEqual(len(pixels), 180*3200)
        self.assertEqual(pixels[20*180+30:20*180+40], bytes([0])*5 + bytes([255])*5)
        with self.assertRaisesRegex(ValueError, 'incomplete'):
            ocr.mosaic(rgb[:-1], rects)

    def test_tsv_confidence_ascii_ambiguity_slots_and_exact120ms_vks(self):
        header = '\t'.join(ocr.TSV_HEADER)
        def row(text, confidence=90, top=20):
            return '\t'.join(map(str, [5,1,1,1,1,1,30,top,40,100,confidence,text]))
        text = '\n'.join([header, row('z'), row('lll', top=180), row('Il'), row('5'), row('?'),
                           row('a', 44), row('a', 'nan'), row('ß'), row('a', top=4000)])
        values = ocr.parse_tsv(text)
        self.assertEqual([(v['slot'], v['vk']) for v in values], [(0,90), (1,76)])
        self.assertEqual(ocr.key_payload(values), '1:move:635,385;100:key:90;220:key:76;1500:shot:0,0')
        letters = [{'vk': vk} for vk in (80,89,74,70,86,68,70,85)]
        self.assertEqual(ocr.key_payload(letters), '1:move:635,385;100:key:80;220:key:89;340:key:74;460:key:70;580:key:86;700:key:68;820:key:70;940:key:85;1660:shot:0,0')
        with self.assertRaisesRegex(ValueError, 'header'):
            ocr.parse_tsv('unexpected header')
        with self.assertRaisesRegex(ValueError, 'VKs'):
            ocr.key_payload([{'vk': 97}])

    def test_readonly_firsttime_preflight_refuses_abandon_senior_owned2_and_missing_portrait(self):
        _, one, zero = check_route.typing_crest_configuration('corbin-portrait')
        data = bytearray(170770)
        for value, offset in ((0,0x9034),(-1,0x10e),(2741,0x21642),(2741,0x21646),(0,0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one | {1672}:
            struct.pack_into('<I', data, 0x1ee6+4*flag, 1)
        for fmt, offset, value in (('<I',0x2430,974),('<H',0x2434,14),('<H',0x2436,16),('<H',0x2438,3)):
            struct.pack_into(fmt, data, offset, value)
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder) / 'synthetic.SAV'
            p.write_bytes(data)
            self.assertEqual(typing.source_state(p)['difficulty'], 0)
            for fmt, offset, value in (('<h',0x9034,2),('<I',0x2ba+4*2,1),('<I',0x1ee6+4*1863,0),
                    ('<I',0x1ee6+4*1687,1),('<I',0x1ee6+4*2088,1),('<I',0x1ee6+4*2014,1)):
                changed = bytearray(data)
                struct.pack_into(fmt, changed, offset, value)
                p.write_bytes(changed)
                with self.assertRaisesRegex(ValueError, 'first-time Junior'):
                    typing.source_state(p)

    def test_reload_requires_examination_and_safe_noheld2_complete_scopes(self):
        _, one, zero = check_route.typing_crest_configuration('typing-crest')
        def observations():
            values = {f: 1 for f in one}
            values.update({338:195<<16,339:15<<16,340:(3<<16)|3,341:0})
            return [{'state':[scene,scene,0,-1], 'scope':typing.rc_flags(), 'flags':dict(values)}
                    for scene in (4114,4114,6200,4114,4114)]
        typing.verify_reload(SimpleNamespace(observations=observations()))
        for failure in ('no_examination','held2','failed','scope','unsafe'):
            frames = observations()
            if failure == 'no_examination':
                frames[2]['state'] = [4114,4114,0,-1]
            elif failure == 'held2':
                frames[2]['state'][3] = 2
            elif failure == 'failed':
                frames[0]['flags'][1687] = 1
            elif failure == 'scope':
                frames[0]['scope'] = '338-341,1000-2013,2015-2250'
            else:
                frames[-1]['state'] = [6200,6200,0,-1]
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                typing.verify_reload(SimpleNamespace(observations=frames))


if __name__ == '__main__':
    unittest.main()
