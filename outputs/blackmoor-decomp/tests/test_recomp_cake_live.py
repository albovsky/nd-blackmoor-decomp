"""Finite Cake metadata and ordinary-input checks; no assets, game or process."""
import copy
from pathlib import Path
import sys
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import cake_live as cake
sys.path.pop(0)


def source_metadata(profile):
    expected = cake.PROFILES[profile]['state']
    return dict(difficulty=expected['difficulty'], scene=3510, art=3510, view=4, held=-1,
                clock_diagnostics=dict(expected['clock']), owned_cake_items={'0': False, '1': False},
                progression={1338: 0, 1502: 0, 1503: 0, 1567: 1})


class CakePreflightTests(unittest.TestCase):
    def test_both_exact_profiles_reject_wrong_difficulty_clock_or_completed_source(self):
        for profile in ('junior', 'senior'):
            state = source_metadata(profile)
            self.assertTrue(cake.validate_profile_state(state, cake.PROFILES[profile]))
            changed_states = []
            for field, value in (('difficulty', 1), ('view', 8), ('held', 1)):
                changed = copy.deepcopy(state)
                changed[field] = value
                changed_states.append(changed)
            changed = copy.deepcopy(state)
            changed['clock_diagnostics']['minute'] += 1
            changed_states.append(changed)
            changed = copy.deepcopy(state)
            changed['owned_cake_items']['1'] = True
            changed_states.append(changed)
            changed = copy.deepcopy(state)
            changed['progression'][1338] = 1
            changed_states.append(changed)
            for changed in changed_states:
                with self.subTest(profile=profile, changed=changed):
                    with self.assertRaises(ValueError):
                        cake.validate_profile_state(changed, cake.PROFILES[profile])
        with self.assertRaises(ValueError):
            cake.validate_profile_state(source_metadata('junior'), cake.PROFILES['senior'])

    def test_only_exact_authored_auxiliary_may_accompany_required_output(self):
        required = {'source.SAV': 'a' * 64, 'cake32.SAV': 'b' * 64}
        for extra in ({}, {cake.AUTHORED_AUXILIARY: 'c' * 64}):
            record = cake.classify_save_hashes(dict(required, **extra), required)
            self.assertEqual(record['required_saves'], required)
            self.assertFalse(record['auxiliary_is_canonical'])
            self.assertFalse(record['auxiliary_used_as_input'])
        for observed, expected in (
                ({'source.SAV': 'a' * 64}, required),
                (dict(required, **{'other.SAV': 'c' * 64}), required),
                (dict(required, **{'cake32.SAV': 'c' * 64}), required),
                ({cake.AUTHORED_AUXILIARY: 'c' * 64}, {cake.AUTHORED_AUXILIARY: 'c' * 64}),
                (dict(required, **{'hicontinuecheat.sav': 'c' * 64}), required)):
            with self.assertRaises(ValueError):
                cake.classify_save_hashes(observed, expected)

    def test_shared_helpers_match_exercised_source_versions(self):
        versions = cake.verify_shared_helpers()
        self.assertEqual(versions['bul_live.py'], cake.IO_SHA256)
        self.assertEqual(versions['story_api_sha256'], cake.STORY_API_SHA256)

    def test_right_hover_and_park_preserve_single_original_panorama_step(self):
        self.assertEqual(cake.right_turn(),
                         '1:move:620,200;101:move:320,60;2501:shot:0,0')
        self.assertNotIn(':click:', cake.right_turn())
        self.assertNotIn(':key:', cake.right_turn())

    def test_original_load_and_relative_save_keep_hover_and_hold_pacing(self):
        prefix = cake.story_route.load_save_prefix()
        self.assertEqual(len(prefix.split(';')), 7)
        self.assertTrue(prefix.startswith('MAIN.CIF+1400:move:275,95;MAIN.CIF+2400:click:275,95,800;'))
        steps = cake.relative_save('cake32').split(';')
        self.assertTrue(all(step.split(':', 1)[0].isdigit() for step in steps))
        self.assertEqual([int(step.split(':', 1)[0]) for step in steps[:4]], [1000, 2000, 6000, 7000])
        self.assertTrue(steps[-1].endswith(':shot:0,0'))
        self.assertIn(':key:67', ';'.join(steps))

    def test_continuation_requires_finish_bake_pickup_and_return_in_order(self):
        scenes = (3510, 3520, 3554, 3563, 3554, 3601, 3600,
                  3602, 3604, 3605, 3606, 3607, 3554, 3520)
        def log(sequence):
            return '\n'.join(f'FILE open C:\\game\\S{scene}.CIF' for scene in sequence)
        self.assertEqual(cake.original_path_check(log(scenes))['observed'], list(scenes))
        for incomplete in (scenes[:7], scenes[:10] + scenes[11:], scenes[:-1]):
            with self.assertRaises(ValueError):
                cake.original_path_check(log(incomplete))


if __name__ == '__main__':
    unittest.main()
