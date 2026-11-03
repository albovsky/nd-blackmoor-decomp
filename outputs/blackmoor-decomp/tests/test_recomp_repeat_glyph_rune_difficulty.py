"""Finite post-rune repeat mode guards; synthetic save metadata only."""
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


class RuneRepeatGlyphDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'synthetic.SAV'

    def fixture(self, mode, *, completed=False, first_paid=False, changes=()):
        route = 'rune-light-replacement' if completed else 'rune-light-wait'
        _, one, _ = check_route.rune_light_configuration(route)
        scene, view, held = (3510, 4, -1) if completed else (3335, 0, 5)
        bag = {2, 6, 7, 11, 12, 16, 17, 19, 20, 21} | ({4} if completed else set())
        if first_paid:
            _, one, _ = check_route.word_lock_configuration('paid-light-request')
            scene, view, held, bag = 3510, 4, -1, {5}
        data = bytearray(170770)
        for value, offset in ((mode, 0x9034), (held, 0x10e), (scene, 0x21642),
                              (scene, 0x21646), (view, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        for item in bag:
            struct.pack_into('<I', data, 0x2ba + 4*item, 1)
        for fmt, offset, value in (('<I', 0x2430, 876), ('<H', 0x2434, 36),
                                   ('<H', 0x2436, 14), ('<H', 0x2438, 3), *changes):
            struct.pack_into(fmt, data, offset, value)
        self.save.write_bytes(data)
        return self.save

    def test_explicit_rune_modes_and_legacy_junior_default(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                source = self.fixture(mode)
                state = repeat.source_state(source, 'rune-passage', expected_difficulty=mode)
                self.assertEqual(state['difficulty'], mode)
                self.assertEqual(state['inventory'], {4: 0, 5: 0, 13: 0})
                self.assertEqual(repeat.rune_source_state(source, expected_difficulty=mode), state)
        self.assertEqual(repeat.source_state(self.fixture(0), 'rune-passage')['difficulty'], 0)
        with self.assertRaises(ValueError):
            repeat.source_state(self.fixture(2), 'rune-passage')

    def test_invalid_modes_mismatches_and_first_paid_shape_still_refused(self):
        for actual, expected in ((1, 1), (1, 0), (1, 2), (0, 2), (2, 0), (2, True)):
            with self.subTest(actual=actual, expected=expected), self.assertRaises(ValueError):
                repeat.source_state(self.fixture(actual), 'rune-passage', expected_difficulty=expected)
        for mode in (0, 2):
            with self.subTest(mode=mode):
                source = self.fixture(mode, first_paid=True)
                self.assertEqual(repeat.source_state(source, expected_difficulty=mode)['difficulty'], mode)
                with self.assertRaises(ValueError):
                    repeat.source_state(source, 'rune-passage', expected_difficulty=mode)

    def test_senior_retains_held_bag_crest_flags_and_afternoon_clock_guards(self):
        for change in (('<h', 0x10e, -1), ('<I', 0x2ba + 4*2, 0),
                       ('<I', 0x2ba + 4*5, 1), ('<I', 0x2ba + 4*8, 1),
                       ('<I', 0x1ee6 + 4*1514, 1), ('<I', 0x1ee6 + 4*2003, 0),
                       ('<I', 0x1ee6 + 4*1972, 1), ('<H', 0x2438, 4),
                       ('<H', 0x2436, 13), ('<I', 0x2430, 877)):
            with self.subTest(change=change), self.assertRaises(ValueError):
                repeat.source_state(self.fixture(2, changes=(change,)), 'rune-passage', expected_difficulty=2)
        self.save.write_bytes(b'')
        with self.assertRaises(ValueError):
            repeat.source_state(self.save, 'rune-passage', expected_difficulty=2)

    def test_rune_output_matches_source_mode_and_keeps_fresh4_crest2_gates(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                self.assertEqual(repeat.output_state(self.fixture(mode, completed=True), mode, 'rune-passage')['difficulty'], mode)
                with self.assertRaises(ValueError):
                    repeat.output_state(self.fixture(2-mode, completed=True), mode, 'rune-passage')
        for change in (('<I', 0x2ba + 4*4, 0), ('<I', 0x2ba + 4*5, 1),
                       ('<I', 0x2ba + 4*13, 1), ('<I', 0x2ba + 4*2, 0),
                       ('<I', 0x1ee6 + 4*1418, 1), ('<I', 0x1ee6 + 4*1809, 1),
                       ('<I', 0x1ee6 + 4*1514, 1)):
            with self.subTest(change=change), self.assertRaises(ValueError):
                repeat.output_state(self.fixture(2, completed=True, changes=(change,)), 2, 'rune-passage')
        with self.assertRaises(ValueError):
            repeat.output_state(self.fixture(1, completed=True), 1, 'rune-passage')


if __name__ == '__main__':
    unittest.main()
