"""Source-bound original Junior/Senior clocks for the first lit word clue."""
import struct
import unittest

import test_recomp_route_check as routes


class LitWordClockTests(unittest.TestCase):
    def setUp(self):
        self.fixture = routes.WordPrerequisiteRouteTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def case(self, mode, hour, route='lit-word-clue', change=None):
        save, frames = self.fixture.frames(route)
        if route == 'lit-word-clue':
            for index, frame in enumerate(frames):
                frame['clock'] = (2, hour, 3 + index)
        if change:
            change(frames)
        data = bytearray(save.read_bytes())
        struct.pack_into('<h', data, 0x9034, mode)
        save.write_bytes(data)
        return save, self.fixture.observed_log(route, save, frames)

    def test_accepts_each_frozen_original_mode_clock(self):
        for mode, hour in ((0, 16), (2, 17)):
            with self.subTest(mode=mode, hour=hour):
                save, log = self.case(mode, hour)
                result = routes.checker.verify(log, save, 'lit-word-clue')
                self.assertEqual(result['clock_diagnostics']['hour'], hour)
                self.assertFalse(result['word_lock_won'])
                self.assertTrue({1818, 1836, 2041, 2232} <= set(result['flags_one']))

    def test_refuses_other_mode_clock_and_unsupported_mode(self):
        for mode, hour in ((0, 17), (2, 16), (1, 16), (1, 17)):
            with self.subTest(mode=mode, hour=hour):
                save, log = self.case(mode, hour)
                with self.assertRaisesRegex(ValueError, 'clock gate|difficulty'):
                    routes.checker.verify(log, save, 'lit-word-clue')

    def test_other_prerequisite_source_clocks_are_unchanged(self):
        for route in ('loulou-barber', 'loulou-morning', 'drake-magic', 'loulou-answer'):
            with self.subTest(route=route):
                save, log = self.case(2, 17, route)
                self.assertFalse(routes.checker.verify(log, save, route)['word_lock_won'])

    def test_senior_clock_keeps_phase_light_and_monotone_guards(self):
        changes = (
            lambda f: f[4]['flags'].update({2041: 0}),
            lambda f: f[-1].update(held=-1),
            lambda f: f[-1].update(clock=(2, 17, 1)),
            lambda f: f[-1]['flags'].update({2018: 1}),
        )
        for index, change in enumerate(changes):
            with self.subTest(change=index):
                save, log = self.case(2, 17, change=change)
                with self.assertRaises(ValueError):
                    routes.checker.verify(log, save, 'lit-word-clue')


if __name__ == '__main__':
    unittest.main()
