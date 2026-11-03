"""Device-free Senior jigsaw route and earned-win checks."""
import importlib.util
import struct
import tempfile
import unittest
from pathlib import Path

MODULE = Path(__file__).resolve().parents[1] / 'recomp/route_tools/check_route.py'
spec = importlib.util.spec_from_file_location('senior_jigsaw_check', MODULE)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class SeniorJaneJigsawResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 's9.SAV'
        data = bytearray(170770)
        struct.pack_into('<h', data, 0x9034, 2)
        for flag in (1424, 1567, 1570, 1905, 1980, 1993):
            struct.pack_into('<I', data, 0x1ee6 + 4 * flag, 1)
        self.save.write_bytes(data)
        self.frames = [(1237, 1237, 0, 0), (3575, 3575, 0, 0),
                       (1234, 3578, 0, 0), (1234, 1234, 0, 1),
                       (3510, 3510, 4, 1), (3510, 3510, 4, 1)]

    def log(self, frames=None):
        out = []
        for scene, art, view, win in self.frames if frames is None else frames:
            out += ['  STATE requested_scene=%d art_scene=%d view=%d held_item=-1' % (scene, art, view),
                    '  RC_FLAGS 1309,1424,1567,1570,1905-1906,1980,1993,2036-2037',
                    '  FLAGS 1424=1 1567=1 1570=1 1905=1 1993=1%s' % (' 1980=1' if win else '')]
        out += ['  FILE open C:\\GAME\\Ciftree\\S%d.CIF  [virtual %d ms]' % (scene, i)
                for i, scene in enumerate((1237, 3575, 3578, 1234, 3510))]
        out += ['  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\s9.SAV  [virtual 650000 ms]',
                'RESULT {"stopped":"stop requested <52a4c0"}']
        return '\n'.join(out) + '\n'

    def test_accepts_raw_pending_art_then_stable_senior_win(self):
        result = checker.verify(self.log(), self.save, route='jane-jigsaw-senior')
        self.assertEqual((result['scene'], result['view']), (3510, 4))

    def test_pending_frame_alone_cannot_substitute_for_stable_win(self):
        frames = self.frames[:3] + self.frames[4:]
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.log(frames), self.save, route='jane-jigsaw-senior')
        frames = self.frames.copy()
        frames[2] = (1234, 3578, 0, 1)
        with self.assertRaisesRegex(ValueError, 'pending art'):
            checker.verify(self.log(frames), self.save, route='jane-jigsaw-senior')

    def test_requires_original_mode2_and_saved_loan(self):
        original = self.save.read_bytes()
        for mode in (0, 1):
            with self.subTest(mode=mode):
                data = bytearray(original)
                struct.pack_into('<h', data, 0x9034, mode)
                self.save.write_bytes(data)
                with self.assertRaisesRegex(ValueError, 'mode2'):
                    checker.verify(self.log(), self.save, route='jane-jigsaw-senior')
        data = bytearray(original)
        struct.pack_into('<I', data, 0x1ee6 + 4 * 1980, 0)
        self.save.write_bytes(data)
        with self.assertRaisesRegex(ValueError, 'saved Senior'):
            checker.verify(self.log(), self.save, route='jane-jigsaw-senior')

    def test_requires_original_win_open_scope_and_safe_return(self):
        for log in (self.log().replace('\\S3578.CIF', '\\S3579.CIF'),
                    self.log().replace('2036-2037', '2036'),
                    self.log(self.frames[:-1])):
            with self.subTest(log=log):
                with self.assertRaises(ValueError):
                    checker.verify(log, self.save, route='jane-jigsaw-senior')

    def test_recorded_senior_body_and_right_release_pairs(self):
        import hashlib
        module = MODULE.with_name('story_route.py')
        spec = importlib.util.spec_from_file_location('senior_jigsaw_story', module)
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        body = story.leg_jane_jigsaw_senior('s9')
        self.assertEqual(hashlib.sha256((body + '\n').encode()).hexdigest(),
                         '119bc9451a1c84d459e8134f3e4b63b256c0060d30d2b0e120827111caf2648a')
        self.assertEqual(len(body.split(';')), 260)
        self.assertEqual(sum(':pointer:' in s and s.endswith(',2') for s in body.split(';')), 29)
        self.assertEqual(sum(':pointer:' in s and s.endswith(',0') for s in body.split(';')), 29)


if __name__ == "__main__":
    unittest.main()
