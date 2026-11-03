"""Finite metadata guards only; no native process, save fabrication or asset access."""
import copy
import unittest
from unittest.mock import patch

import test_recomp_aeolus_cli as existing


class AeolusDifficultyProfileTests(unittest.TestCase):
    def fixture(self):
        helper = existing.AeolusCliTests()
        module = helper.module()
        manifest, args = helper.fixture(module)
        return module, manifest, args

    def test_junior_default_and_explicit_senior_selection(self):
        module, manifest, args = self.fixture()
        module.validate_manifest(manifest, args)  # Existing callers need no new flag.
        self.assertEqual(module.argument_parser().get_default('profile'), 'junior')
        manifest['profile']['difficulty'] = 2
        with self.assertRaises(ValueError):
            module.validate_manifest(manifest, args)  # Senior cannot use Junior default.
        args.profile = 'senior'
        module.validate_manifest(manifest, args)
        args.profile = 'junior'
        with self.assertRaises(ValueError):
            module.validate_manifest(manifest, args)
        argv = []
        for name in ('native', 'game-exe', 'game-data', 'source-save', 'profile-manifest', 'atlas', 'output'):
            argv += ['--' + name, name]
        for name in ('native-sha256', 'game-exe-sha256', 'source-sha256', 'profile-manifest-sha256', 'atlas-sha256'):
            argv += ['--' + name, 'a' * 64]
        self.assertEqual(module.argument_parser().parse_args(argv + ['--profile', 'senior']).profile, 'senior')
        with self.assertRaises(SystemExit), patch('sys.stderr'):
            module.argument_parser().parse_args(argv + ['--profile', 'unknown'])

    def test_only_recognized_profile_and_original_difficulty_pair_is_accepted(self):
        module, manifest, args = self.fixture()
        args.profile = 'senior'
        for value in (0, 1, 3, False, '2'):
            manifest['profile']['difficulty'] = value
            with self.subTest(value=value), self.assertRaises(ValueError):
                module.validate_manifest(manifest, args)
        manifest['profile']['difficulty'] = 2
        args.profile = 'unknown'
        with self.assertRaises(ValueError):
            module.validate_manifest(manifest, args)

    def test_source_and_won_output_must_retain_the_selected_difficulty(self):
        module, manifest, _ = self.fixture()
        profile = manifest['profile']
        for difficulty in (0, 2):
            profile['difficulty'] = difficulty
            source = {key: copy.deepcopy(profile[key]) for key in
                      ('state', 'difficulty', 'flags', 'inventory40', 'clock')}
            module.guard.check_profile(source, profile, won=False)
            won = copy.deepcopy(source)
            won['state'] = [3813, 3813, 0, 13]
            won['flags'].update({str(flag): 1 for flag in profile['win_flags']})
            module.guard.check_profile(won, profile, won=True)
            for value, is_won in ((source, False), (won, True)):
                wrong = copy.deepcopy(value)
                wrong['difficulty'] = 2 if difficulty == 0 else 0
                with self.subTest(difficulty=difficulty, won=is_won), self.assertRaises(ValueError):
                    module.guard.check_profile(wrong, profile, won=is_won)

    def test_senior_keeps_correct_mould_inventory_and_all_prize_guards(self):
        module, manifest, args = self.fixture()
        args.profile = 'senior'
        manifest['profile']['difficulty'] = 2
        module.validate_manifest(manifest, args)
        for kind in ('old23', 'missing10', 'missing_scope', 'wrong_win'):
            bad = copy.deepcopy(manifest)
            profile = bad['profile']
            if kind == 'old23':
                profile['flags']['2163'] = 0
            elif kind == 'missing10':
                profile['inventory40'][10] = 0
            elif kind == 'missing_scope':
                profile['logged_source_zero'].remove(2004)
            else:
                profile['win_flags'] = [1959]
            with self.subTest(kind=kind), self.assertRaises(ValueError):
                module.validate_manifest(bad, args)
        profile = manifest['profile']
        won = {key: copy.deepcopy(profile[key]) for key in
               ('state', 'difficulty', 'flags', 'inventory40', 'clock')}
        won['state'] = [3813, 3813, 0, 13]
        won['flags'].update({str(flag): 1 for flag in profile['win_flags']})
        won['flags']['1098'] = 0
        with self.assertRaises(ValueError):
            module.guard.check_profile(won, profile, won=True)


if __name__ == '__main__':
    unittest.main()
