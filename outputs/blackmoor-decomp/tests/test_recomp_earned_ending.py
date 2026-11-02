"""Finite input checks; no native process, original data or GUI is opened."""
import importlib.util
import hashlib
from pathlib import Path
import sys
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp' / 'route_tools'
sys.path.insert(0, str(TOOLS))
spec = importlib.util.spec_from_file_location('earned_ending_route', TOOLS / 'earned_ending_route.py')
ending = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ending)


class EarnedEndingInputTests(unittest.TestCase):
    def test_real_key_use_and_timed_escape_precede_story_closing(self):
        steps = ending.leg_earned_ending().split(';')
        self.assertEqual(len(steps), 38)
        self.assertEqual(steps[:2], ['S3844.CIF+12000:move:331,199',
                                    'S3844.CIF+13000:click:331,199,600'])
        self.assertIn('S3909.CIF+100:move:311,355', steps)
        self.assertIn('S3909.CIF+200:click:311,355,80', steps)
        self.assertLess(steps.index('S3909.CIF+200:click:311,355,80'),
                        steps.index('S1940.CIF+16000:shot:0,0'))

    def test_post_win_walk_and_award_keep_the_original_anchors(self):
        steps = ending.leg_earned_ending().split(';')
        self.assertEqual([s for s in steps if s.startswith('S3940.CIF') and ':click:' in s],
                         ['S3940.CIF+6100:click:504,171,300',
                          'S3940.CIF+10100:click:504,131,300',
                          'S3940.CIF+14100:click:416,224,300',
                          'S3940.CIF+18100:click:416,224,300'])
        self.assertEqual([s for s in steps if s.startswith('S6517.CIF') and ':click:' in s],
                         ['S6517.CIF+3000:click:300,200,600',
                          'S6517.CIF+11000:click:300,200,600'])
        self.assertEqual(steps[-2:], ['S6562.CIF+18000:shot:0,0',
                                     'S6562.CIF+21000:shot:0,0'])

    def test_load_prefix_is_optional_and_uses_the_selected_save_row(self):
        body = ending.leg_earned_ending()
        self.assertEqual(hashlib.sha256((ending.earned_ending_input() + '\n').encode()).hexdigest(),
                         'e5b53faca002963e8b541563077b0a2194625d2206ab9c6437158ed65cb075f0')
        self.assertEqual(ending.earned_ending_input(False), body)
        loaded = ending.earned_ending_input(slot_y=148)
        self.assertEqual(len(loaded.split(';')), 45)
        self.assertTrue(loaded.endswith(';' + body))
        self.assertIn('MAIN.CIF+9000:move:300,148', loaded)
        self.assertIn('MAIN.CIF+10000:click:300,148,800', loaded)

    def test_ending_cannot_create_a_checkpoint_after_the_credits(self):
        for name in ('after-ending', ''):
            with self.subTest(name=name), self.assertRaises(ValueError):
                ending.leg_earned_ending(name)


if __name__ == '__main__':
    unittest.main()
