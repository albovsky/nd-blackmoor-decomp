"""Original saved-mode selection for the unsolved glyph-request exit."""
import struct
import unittest

import test_recomp_route_check as routes


SENIOR_OPENS = (1216, 1217, 1280, 1281, 3585, 3571, 3580, 3510)


class GlyphRequestDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.fixture = routes.DragonLightRouteTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def case(self, mode, senior_path, opened=None):
        save, frames = self.fixture.frames('glyph-request')
        data = bytearray(save.read_bytes())
        struct.pack_into('<h', data, 0x9034, mode)
        save.write_bytes(data)
        if senior_path:
            for index, scene in ((5, 3571), (6, 3580)):
                frames[index].update(scene=scene, art=scene)
            if opened is None:
                opened = SENIOR_OPENS
        return save, self.fixture.observed_log('glyph-request', save, frames, opened)

    def test_accepts_each_original_saved_mode_path(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                save, log = self.case(mode, mode == 2)
                result = routes.checker.verify(log, save, 'glyph-request')
                self.assertTrue(result['glyph_pending'])
                self.assertEqual((result['scene'], result['view']), (3510, 4))
                self.assertTrue({2001, 1357, 1804} <= set(result['flags_zero']))

    def test_rejects_unsupported_saved_mode(self):
        save, log = self.case(1, False)
        with self.assertRaisesRegex(ValueError, 'difficulty'):
            routes.checker.verify(log, save, 'glyph-request')

    def test_rejects_the_other_modes_exit_path(self):
        for mode, senior_path in ((0, True), (2, False)):
            with self.subTest(mode=mode):
                save, log = self.case(mode, senior_path)
                with self.assertRaisesRegex(ValueError, 'ordered route observations'):
                    routes.checker.verify(log, save, 'glyph-request')

    def test_requires_each_original_senior_transition_open(self):
        for missing in (3571, 3580):
            with self.subTest(missing=missing):
                opened = tuple(scene for scene in SENIOR_OPENS if scene != missing)
                save, log = self.case(2, True, opened)
                with self.assertRaisesRegex(ValueError, 'scene opens'):
                    routes.checker.verify(log, save, 'glyph-request')


if __name__ == '__main__':
    unittest.main()
