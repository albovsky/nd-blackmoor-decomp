"""Focused saved-mode timer selection; reuse the indexed ghost fixture unchanged."""
import copy
import importlib.util
from pathlib import Path
import struct
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('ghost_mode_checker', ROOT / 'recomp/route_tools/check_route.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)
spec = importlib.util.spec_from_file_location('retained_ghost_fixture', Path(__file__).with_name('test_recomp_route_check.py'))
fixtures = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fixtures)


class GhostDifficultyTimerTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.GhostRouteResultTests(
            'test_accepts_four_coherent_legs_and_separates_clock_diagnostics')
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def hunt(self, mode):
        save, frames = self.fixture.frames('ghost-hunt')
        data = bytearray(save.read_bytes())
        struct.pack_into('<h', data, 0x9034, mode)
        save.write_bytes(data)
        if mode == 2:
            for frame in frames:
                if frame['flags'].pop(2039, 0):
                    frame['flags'][2040] = 1
        return save, frames

    def verify(self, save, frames):
        return checker.verify(self.fixture.observed_log(save, frames), save, 'ghost-hunt')

    def test_saved_modes_select_their_original_active_timer(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                save, frames = self.hunt(mode)
                result = self.verify(save, frames)
                self.assertEqual((result['scene'], result['view']), (4111, 0))
                self.assertTrue(set(range(1162, 1175)) <= set(result['flags_one']))

    def test_rejects_unsupported_saved_mode(self):
        for mode in (1, -1):
            with self.subTest(mode=mode):
                save, frames = self.hunt(mode)
                with self.assertRaisesRegex(ValueError, 'difficulty'):
                    self.verify(save, frames)

    def test_senior_rejects_junior_or_both_active_flags(self):
        for both in (False, True):
            with self.subTest(both=both):
                save, frames = self.hunt(2)
                for frame in frames[2:30]:
                    frame['flags'][2039] = 1
                    if not both:
                        frame['flags'].pop(2040, None)
                with self.assertRaisesRegex(ValueError, 'hunt failure'):
                    self.verify(save, frames)
        save, frames = self.hunt(2)
        extra = copy.deepcopy(frames[3])
        extra['scene'] = 3131
        extra['flags'][2039] = 1
        frames.insert(4, extra)
        with self.assertRaisesRegex(ValueError, 'hunt failure'):
            self.verify(save, frames)

    def test_senior_start_clear_scope_and_all13_guards_remain(self):
        for failure in ('start', 'reward', 'scope', 'ghost'):
            with self.subTest(failure=failure):
                save, frames = self.hunt(2)
                if failure == 'start':
                    frames[2]['flags'].pop(2040)
                elif failure == 'reward':
                    frames[30]['flags'][2040] = 1
                elif failure == 'scope':
                    frames[-1]['scope'] = '338-341,1000-2039,2041-2230'
                else:
                    for frame in frames:
                        frame['flags'].pop(1170, None)
                with self.assertRaises(ValueError):
                    self.verify(save, frames)


if __name__ == '__main__':
    unittest.main()
