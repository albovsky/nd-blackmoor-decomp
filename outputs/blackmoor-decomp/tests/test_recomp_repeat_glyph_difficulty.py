"""Finite first-paid repeat glyph mode guards; synthetic saves only."""
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import check_route
import repeat_glyph_live as repeat
sys.path.pop(0)


class RepeatGlyphDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'synthetic.SAV'

    def fixture(self, mode, completed=False, changes=()):
        route = 'repeat-glyph-win' if completed else 'paid-light-request'
        _, one, _ = check_route.word_lock_configuration(route)
        data = bytearray(170770)
        for value, offset in ((mode, 0x9034), (-1, 0x10e), (3510, 0x21642),
                              (3510, 0x21646), (4, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        struct.pack_into('<I', data, 0x2ba + 4*(4 if completed else 5), 1)
        for fmt, offset, value in (('<I', 0x2430, 878), ('<H', 0x2434, 38),
                                   ('<H', 0x2436, 14), ('<H', 0x2438, 3), *changes):
            struct.pack_into(fmt, data, offset, value)
        self.save.write_bytes(data)
        return self.save

    def test_explicit_original_first_paid_modes_and_legacy_junior_default(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                state = repeat.source_state(self.fixture(mode), expected_difficulty=mode)
                self.assertEqual(state['difficulty'], mode)
                self.assertEqual(state['inventory'], {4: 0, 5: 1, 13: 0})
        with self.assertRaisesRegex(ValueError, 'first-paid pending Junior'):
            repeat.source_state(self.fixture(2))
        self.assertEqual(repeat.source_state(self.fixture(0))['difficulty'], 0)

    def test_refuses_unsupported_mismatched_and_unbound_rune_senior_modes(self):
        for actual, expected in ((1, 1), (1, 0), (1, 2), (0, 2), (2, 0)):
            with self.subTest(actual=actual, expected=expected):
                with self.assertRaises(ValueError):
                    repeat.source_state(self.fixture(actual), expected_difficulty=expected)
        with self.assertRaises(ValueError):
            repeat.source_state(self.fixture(2), 'rune-passage', expected_difficulty=2)

    def test_senior_still_requires_paid_pending_used5_and_exact_clock_gate(self):
        for change in (('<I', 0x2ba + 4*5, 0), ('<I', 0x2ba + 4*4, 1),
                       ('<I', 0x1ee6 + 4*1809, 0), ('<I', 0x1ee6 + 4*1418, 0),
                       ('<I', 0x1ee6 + 4*2001, 0), ('<h', 0x10e, 5), ('<H', 0x2438, 4)):
            with self.subTest(change=change):
                with self.assertRaises(ValueError):
                    repeat.source_state(self.fixture(2, changes=(change,)), expected_difficulty=2)

    def test_output_preserves_mode_reward_and_actual_fresh4_replacing_used5(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                self.assertEqual(repeat.output_state(self.fixture(mode, completed=True), mode)['difficulty'], mode)
                with self.assertRaisesRegex(ValueError, 'save state/reward'):
                    repeat.output_state(self.fixture(2 - mode, completed=True), mode)
        with self.assertRaises(ValueError):
            repeat.output_state(self.fixture(1, completed=True), 1)
        for change in (('<I', 0x2ba + 4*4, 0), ('<I', 0x2ba + 4*5, 1),
                       ('<I', 0x2ba + 4*13, 1), ('<I', 0x1ee6 + 4*1418, 1),
                       ('<I', 0x1ee6 + 4*1809, 1)):
            with self.subTest(change=change):
                with self.assertRaises(ValueError):
                    repeat.output_state(self.fixture(2, completed=True, changes=(change,)), 2)


if __name__ == '__main__':
    unittest.main()
