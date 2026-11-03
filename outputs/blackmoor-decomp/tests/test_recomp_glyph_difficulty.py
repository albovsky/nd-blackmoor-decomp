"""Finite first-time glyph mode guards using synthetic saves only."""
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import check_route
import glyph_live as glyph
sys.path.pop(0)


class GlyphDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'synthetic.SAV'

    def fixture(self, mode, completed=False, changes=()):
        configuration = (check_route.glyph_win_configuration() if completed else
                         check_route.dragon_light_configuration('glyph-request'))
        _, one, _ = configuration
        data = bytearray(170770)
        for value, offset in ((mode, 0x9034), (-1, 0x10e), (3510, 0x21642),
                              (3510, 0x21646), (4, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        for fmt, offset, value in (('<I', 0x2430, 1008), ('<H', 0x2434, 48),
                                   ('<H', 0x2436, 16), ('<H', 0x2438, 2), *changes):
            struct.pack_into(fmt, data, offset, value)
        self.save.write_bytes(data)
        return self.save

    def test_explicit_original_modes_and_legacy_junior_default(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                path = self.fixture(mode)
                self.assertEqual(glyph.source_state(path, expected_difficulty=mode)['difficulty'], mode)
        with self.assertRaisesRegex(ValueError, 'first-time pending Junior'):
            glyph.source_state(self.fixture(2))
        self.assertEqual(glyph.source_state(self.fixture(0))['difficulty'], 0)

    def test_rejects_unsupported_or_mismatched_source_mode(self):
        for actual, expected in ((1, 1), (1, 0), (1, 2), (0, 2), (2, 0)):
            with self.subTest(actual=actual, expected=expected):
                with self.assertRaises(ValueError):
                    glyph.source_state(self.fixture(actual), expected_difficulty=expected)

    def test_senior_still_requires_first_time_pending_source_and_clock(self):
        for change in (('<I', 0x1ee6 + 4*2001, 1), ('<I', 0x1ee6 + 4*1357, 1),
                       ('<I', 0x1ee6 + 4*1418, 0), ('<h', 0x10e, 4), ('<H', 0x2438, 3)):
            with self.subTest(change=change):
                with self.assertRaises(ValueError):
                    glyph.source_state(self.fixture(2, changes=(change,)), expected_difficulty=2)

    def test_output_preserves_mode_and_requires_the_real_reward(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                self.assertEqual(glyph.output_state(self.fixture(mode, completed=True), mode)['difficulty'], mode)
                with self.assertRaisesRegex(ValueError, 'save state/reward'):
                    glyph.output_state(self.fixture(2 - mode, completed=True), mode)
        with self.assertRaises(ValueError):
            glyph.output_state(self.fixture(1, completed=True), 1)
        for flag, value in ((2001, 0), (1357, 0), (1418, 1)):
            with self.subTest(flag=flag):
                with self.assertRaisesRegex(ValueError, 'save state/reward'):
                    glyph.output_state(self.fixture(2, completed=True, changes=(('<I', 0x1ee6 + 4*flag, value),)), 2)


if __name__ == '__main__':
    unittest.main()
