"""Finite metadata/gate regressions; no game, assets or native process."""
import copy
import importlib.util
from pathlib import Path
import unittest

MODULE = Path(__file__).resolve().parents[1] / 'recomp/route_tools/betty_live.py'
spec = importlib.util.spec_from_file_location('betty_live', MODULE)
betty = importlib.util.module_from_spec(spec)
spec.loader.exec_module(betty)


def source():
    flags = {str(f): 1 for f in (1160, 1541, 1782, 1906, 2002)}
    flags.update({'1781': 0, '1963': 0, '1998': 0, '2127': 1, '2163': 1})
    return {'difficulty': 2, 'scene': 2701, 'art': 2701, 'view': 0, 'held': -1,
            'progression': flags,
            'clock': {'day': 1, 'hour': 7, 'minute': 27, 'total_minutes': 447},
            'ordered_bag': [20, 12, 6, 17],
            'item_presence': {str(i): int(i in (20, 12, 6, 17)) for i in range(40)}}


def profile():
    return {'version': 1, 'name': 'senior', 'difficulty': 2,
            'native_sha256': 'a' * 64, 'source_sha256': 'b' * 64, 'source': source(),
            'origin_chain': [{'file': 'origin/receipt.json', 'sha256': 'c' * 64}],
            'helpers': {name: 'd' * 64 for name in
                        ('bul_live.py', 'story_route.py', 'check_route.py', 'capture_receipts.py')},
            'input_files': {name: 'e' * 64 for name in betty.INPUT_NAMES},
            'seed_pins': {'GAME.EXE': 'f' * 64}, 'external_programs': []}


class BettyProfileGateTests(unittest.TestCase):
    def test_explicit_profiles_refuse_mode1_and_mismatched_names(self):
        for name, mode in (('junior', 0), ('senior', 2)):
            p = profile()
            p['name'], p['difficulty'], p['source']['difficulty'] = name, mode, mode
            betty.validate_profile(p)
        for mode in (1, True):
            p = profile()
            p['difficulty'] = p['source']['difficulty'] = mode
            with self.assertRaises(ValueError):
                betty.validate_profile(p)
        p = profile()
        p['name'] = 'junior'
        with self.assertRaises(ValueError):
            betty.validate_profile(p)

    def test_requires_accepted_newgame_lineage_and_all_carried_fields(self):
        p = profile()
        row = {'accepted': True, 'protected_inputs_unchanged': True,
               'native_sha256': p['native_sha256'], 'no_incoming_save': True,
               'origin_source': None,
               'stages': [{'source_sha256': None, 'output_sha256': p['source_sha256'],
                           'state': copy.deepcopy(p['source'])}]}
        betty.validate_lineage([row], p)
        for change in ('no_incoming_save', 'accepted', 'protected_inputs_unchanged'):
            bad = copy.deepcopy(row)
            bad[change] = False
            with self.assertRaises(ValueError):
                betty.validate_lineage([bad], p)
        bad = copy.deepcopy(row)
        bad['stages'][0]['state']['progression']['1502'] = 1
        with self.assertRaises(ValueError):
            betty.validate_lineage([bad], p)

    def test_live_scope_excludes_saved_board_and_pose_fields(self):
        s = source()
        flags = {int(k): v for k, v in s['progression'].items() if int(k) in betty.LIVE_QUEST_FLAGS}
        flags.update({338: 447 << 16, 339: 27 << 16, 340: (1 << 16) | 7})
        observation = {'state': [2701, 2701, 0, -1], 'scope': betty.RC_FLAGS, 'flags': flags}
        betty.live(observation, {'source': s}, 1440 + 447, won=0)
        bad = copy.deepcopy(observation)
        bad['scope'] += ',2127'
        with self.assertRaises(ValueError):
            betty.live(bad, {'source': s}, 1440 + 447)
        bad = copy.deepcopy(observation)
        bad['flags'][1160] = 0
        with self.assertRaises(ValueError):
            betty.live(bad, {'source': s}, 1440 + 447)

    def test_only_authored_completion_and_real19_delta_is_accepted(self):
        s = source()
        out = copy.deepcopy(s)
        out.update(scene=2700, art=2700)
        for f in (1781, 1963, 1998):
            out['progression'][str(f)] = 1
        out['item_presence']['19'] = 1
        out['ordered_bag'].append(19)
        betty.check_saved(out, s, output=True)
        bad = copy.deepcopy(out)
        bad['progression']['2127'] = 0
        with self.assertRaises(ValueError):
            betty.check_saved(bad, s, output=True)
        bad = copy.deepcopy(out)
        bad['progression']['1781'] = 0
        with self.assertRaises(ValueError):
            betty.check_saved(bad, s, output=True)

    def test_reward_gate_needs_original_win_and_settled_scene(self):
        for state, flag, expected in ((2704, 0, 'pending'), (2709, 1, 'settling'),
                                      (2710, 1, 'settling'), (2711, 1, 'win')):
            self.assertEqual(betty.outcome({'state': [state, state, 0, -1], 'flags': {1963: flag}}), expected)
        for state, flag in ((2711, 0), (2703, 0), (2704, 1)):
            with self.assertRaises(ValueError):
                betty.outcome({'state': [state, state, 0, -1], 'flags': {1963: flag}})

    def test_allows_only_byte_identical_original_config_copy(self):
        import tempfile
        with tempfile.TemporaryDirectory() as folder:
            game = Path(folder)
            original = game / 'Game.ini'
            original.write_bytes(b'synthetic fixture configuration')
            seeds = {'Game.ini': betty.io.digest(original)}
            saves = game / betty.SAVE_DIR
            saves.mkdir(parents=True)
            source = saves / 'm12.SAV'
            source.write_bytes(b'fixture, never passed to native')
            allowed = {str(source.relative_to(game))}
            copied = saves / 'GAME.INI'
            copied.write_bytes(original.read_bytes())
            betty.verify_clone_inventory(game, seeds, allowed)
            copied.write_bytes(b'changed configuration')
            with self.assertRaisesRegex(ValueError, 'configuration'):
                betty.verify_clone_inventory(game, seeds, allowed)
            copied.write_bytes(original.read_bytes())
            (game / 'unknown.CIF').write_bytes(b'unknown override')
            with self.assertRaisesRegex(ValueError, 'inventory'):
                betty.verify_clone_inventory(game, seeds, allowed)
