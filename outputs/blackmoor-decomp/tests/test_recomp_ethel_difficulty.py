"""Finite Ethel source/output mode guards; synthetic saves, no native child."""
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import check_route
import ethel_live as ethel
sys.path.pop(0)


class EthelDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'synthetic.SAV'

    def fixture(self, mode, completed=False, changes=()):
        route = 'ethel-interrogation' if completed else 'right-fire-panel'
        _, one, _ = check_route.crest_prerequisite_configuration(route)
        data = bytearray(170770)
        scene, held = (3428, -1) if completed else (3141, 4)
        for value, offset in ((mode, 0x9034), (held, 0x10e), (scene, 0x21642),
                              (scene, 0x21646), (0, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        for fmt, offset, value in (('<I', 0x2430, 926), ('<H', 0x2434, 26),
                                   ('<H', 0x2436, 15), ('<H', 0x2438, 3), *changes):
            struct.pack_into(fmt, data, offset, value)
        self.save.write_bytes(data)
        return self.save

    def test_explicit_original_modes_and_legacy_junior_source_default(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                state = ethel.source_state(self.fixture(mode), expected_difficulty=mode)
                self.assertEqual((state['difficulty'], state['held']), (mode, 4))
        with self.assertRaises(ValueError):
            ethel.source_state(self.fixture(2))
        self.assertEqual(ethel.source_state(self.fixture(0))['difficulty'], 0)

    def test_rejects_unsupported_and_mismatched_source_mode(self):
        for actual, expected in ((1, 1), (1, 0), (1, 2), (0, 2), (2, 0)):
            with self.subTest(actual=actual, expected=expected):
                with self.assertRaises(ValueError):
                    ethel.source_state(self.fixture(actual), expected_difficulty=expected)

    def test_senior_source_keeps_partial_fire_item_quest_and_clock_gates(self):
        for change in (('<h', 0x10e, -1), ('<I', 0x1ee6 + 4*1150, 0),
                       ('<I', 0x1ee6 + 4*2154, 1), ('<I', 0x1ee6 + 4*1972, 1),
                       ('<H', 0x2438, 4), ('<H', 0x2436, 14)):
            with self.subTest(change=change):
                with self.assertRaises(ValueError):
                    ethel.source_state(self.fixture(2, changes=(change,)), expected_difficulty=2)

    def test_output_preserves_mode_and_requires_ethel_truth_safe_state(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                self.assertEqual(ethel.output_state(self.fixture(mode, completed=True), mode)['difficulty'], mode)
                with self.assertRaisesRegex(ValueError, 'save state/flags'):
                    ethel.output_state(self.fixture(2 - mode, completed=True), mode)
        with self.assertRaises(ValueError):
            ethel.output_state(self.fixture(1, completed=True), 1)
        for change in (('<I', 0x1ee6 + 4*2154, 0), ('<I', 0x1ee6 + 4*1972, 1),
                       ('<h', 0x10e, 4), ('<h', 0x21642, 3500)):
            with self.subTest(change=change):
                with self.assertRaisesRegex(ValueError, 'save state/flags'):
                    ethel.output_state(self.fixture(2, completed=True, changes=(change,)), 2)


if __name__ == '__main__':
    unittest.main()
