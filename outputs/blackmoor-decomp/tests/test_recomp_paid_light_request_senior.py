"""Saved-mode selection for the already-instructed paid glyph exit only."""
import struct
import unittest

import test_recomp_route_check as routes


SENIOR_OPENS = (3345, 3346, 3500, 3505, 3510, 1200, 1282, 1281, 3585, 3580, 3522, 3510)


class PaidLightRequestDifficultyTests(unittest.TestCase):
    def setUp(self):
        self.fixture = routes.ReplacementWordLockTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def case(self, mode, senior_path, opened=None):
        save, frames = self.fixture.frames('paid-light-request')
        data = bytearray(save.read_bytes())
        struct.pack_into('<h', data, 0x9034, mode)
        save.write_bytes(data)
        if senior_path:
            frames[9].update(scene=3580, art=3580)
            if opened is None:
                opened = SENIOR_OPENS
        return save, frames, self.fixture.observed_log('paid-light-request', save, frames, opened)

    def test_accepts_junior_default_and_senior_paid_path_without_first_time_instructions(self):
        for mode in (0, 2):
            with self.subTest(mode=mode):
                save, _, log = self.case(mode, mode == 2)
                result = routes.checker.verify(log, save, 'paid-light-request')
                self.assertEqual((result['scene'], result['view']), (3510, 4))
                self.assertTrue({1388, 1418, 1809, 2001, 1357} <= set(result['flags_one']))
                self.assertTrue({2041, 2042} <= set(result['flags_zero']))
                if mode == 2:
                    self.assertNotIn('\\S3571.CIF', log)

    def test_rejects_unsupported_mode_and_the_other_modes_paid_exit(self):
        save, _, log = self.case(1, False)
        with self.assertRaisesRegex(ValueError, 'difficulty'):
            routes.checker.verify(log, save, 'paid-light-request')
        for mode, senior_path in ((0, True), (2, False)):
            save, _, log = self.case(mode, senior_path)
            with self.subTest(mode=mode), self.assertRaisesRegex(ValueError, 'ordered route observations'):
                routes.checker.verify(log, save, 'paid-light-request')

    def test_requires_both_senior_exit_opens_including_the_shared3522(self):
        for missing in (3580, 3522):
            opened = tuple(scene for scene in SENIOR_OPENS if scene != missing)
            save, _, log = self.case(2, True, opened)
            with self.subTest(missing=missing), self.assertRaisesRegex(ValueError, 'scene opens'):
                routes.checker.verify(log, save, 'paid-light-request')

    def test_keeps_used5_phase_prerequisites_and_the_existing_source_hour_guard(self):
        for change in ('used5', 'early1418', 'first_instructions', 'source_hour'):
            save, frames, _ = self.case(2, True)
            if change == 'used5':
                frames[1]['held'] = -1
            elif change == 'early1418':
                frames[7]['flags'][1418] = 1
            elif change == 'first_instructions':
                frames[0]['flags'][1388] = 0
            else:
                frames[0]['clock'] = (3, 8, 22)
            log = self.fixture.observed_log('paid-light-request', save, frames, SENIOR_OPENS)
            with self.subTest(change=change), self.assertRaises(ValueError):
                routes.checker.verify(log, save, 'paid-light-request')

    def test_reads_mode_only_from_a_complete_original_length_save(self):
        for length in (0, 0x9034, 0x9035, 170769, 170771):
            save, _, log = self.case(2, True)
            save.write_bytes(bytes(length))
            with self.subTest(length=length), self.assertRaisesRegex(ValueError, 'length'):
                routes.checker.verify(log, save, 'paid-light-request')


if __name__ == '__main__':
    unittest.main()
