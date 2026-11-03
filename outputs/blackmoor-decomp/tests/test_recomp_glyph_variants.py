"""Finite goal/input/observation guards only; no game, assets or native child."""
import hashlib
from pathlib import Path
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import check_route
import glyph_live as glyph
sys.path.pop(0)


class GlyphVariantTests(unittest.TestCase):
    def test_default_input_is_exact_and_hard_changes_only_button_and_scene_anchor(self):
        standard = glyph.board_prefix()
        self.assertEqual(hashlib.sha256((standard + '\n').encode()).hexdigest(),
                         '530a01dd5d99eed87ab1819e32092a42dd97c73cf183bbc686e069aeb517d3cd')
        self.assertEqual(glyph.board_prefix('standard'), standard)
        self.assertEqual(glyph.board_prefix('hard'),
                         standard.replace('480,152', '480,213').replace('S3588.CIF', 'S3589.CIF'))
        easy, hard = glyph.goal_profile(), glyph.goal_profile('hard')
        self.assertEqual((easy['scene'], easy['time_limit_seconds'], easy['target_score']), (3588, 61, 2500))
        self.assertEqual((hard['scene'], hard['time_limit_seconds'], hard['target_score']), (3589, 41, 5000))
        with self.assertRaises(ValueError):
            glyph.goal_profile('unreviewed')

    def test_changed_effective_source_is_refused_before_any_session(self):
        with tempfile.TemporaryDirectory() as folder:
            seed = Path(folder)
            (seed / 'Ciftree').mkdir()
            (seed / 'Ciftree/CIFTREE.DAT').write_bytes(b'synthetic wrong archive; no original bytes')
            with self.assertRaisesRegex(ValueError, 'scene/time/target source container'):
                glyph.verify_goal_assets(seed, 'hard')

    def test_explicit_hard_scene_keeps_real_win_and_phase_requirements(self):
        expected, positive, negative = check_route.glyph_win_configuration(3589)
        normal, normal_positive, normal_negative = check_route.glyph_win_configuration()
        self.assertEqual(expected[1], (3589, 0))
        self.assertEqual(normal[1], (3588, 0))
        self.assertEqual((positive, negative), (normal_positive, normal_negative))
        observations = []
        for index, (scene, view) in enumerate(expected):
            flags = {flag: 1 for flag in positive - {2001, 1357}}
            flags.update({1418: int(index < 3), 2001: int(index >= 2), 1357: int(index >= 3)})
            state = (scene, scene, view, 4 if index == 4 else -1)
            observations.append((state, positive | negative, flags))
        clocks = [(check_route.CLOCK_OVERLAP_DIAGNOSTICS,
                   {'total_minutes': 960, 'hour': 16, 'minute': 0, 'day': 2})]
        def log(scenes):
            return ''.join(f'  FILE open C:\\GAME\\S{scene}.CIF  [virtual {i+1} ms]\n'
                           for i, scene in enumerate(scenes))
        hard_log = log([3589, 1299, 1294, 1945, 3510])
        check_route.verify_glyph_win_observations(hard_log, observations, observations,
                                                clocks, positive, negative, glyph_scene=3589)
        with self.assertRaisesRegex(ValueError, 'ordered glyph-win'):
            check_route.verify_glyph_win_observations(hard_log, observations, observations,
                                                    clocks, positive, negative)
        with self.assertRaisesRegex(ValueError, 'ordered glyph-win'):
            check_route.verify_glyph_win_observations(log([3589, 1294, 1945, 3510]), observations,
                                                    observations, clocks, positive, negative, glyph_scene=3589)
        observations[0][2][2001] = 1
        with self.assertRaises(ValueError):
            check_route.verify_glyph_win_observations(hard_log, observations, observations,
                                                    clocks, positive, negative, glyph_scene=3589)


if __name__ == '__main__':
    unittest.main()
