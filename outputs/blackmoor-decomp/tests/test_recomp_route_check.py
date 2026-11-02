"""Small, device-free checks for false-positive route reports."""
import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE = Path(__file__).resolve().parents[1] / 'recomp/route_tools/check_route.py'
spec = importlib.util.spec_from_file_location('recomp_route_check', MODULE)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class RouteResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm7.SAV'
        self.save.write_bytes(bytes(170770))
        self.log = '\n'.join(
            '  STATE requested_scene=%d art_scene=%d view=%d held_item=-1\n'
            '  RC_FLAGS 1309,1834,1843,1905-1906,1949,1953,1980,1993,2036-2037\n'
            '  FLAGS 1834=1 1843=1 1905=1 1949=1 1953=1 1993=1' % (scene, scene, view)
            for scene, view in ((2010, 0), (2014, 0), (2026, 0), (2010, 2)))
        self.log += '\n  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m7.SAV  [virtual 240000 ms]\n'
        self.log += 'RESULT {"stopped":"stop requested <52a4c0", "first_data_file":"C:\\GAME\\Ciftree"}\n'

    def test_accepts_observed_route_and_checkpoint(self):
        result = checker.verify(self.log, self.save)
        self.assertEqual((result['scene'], result['view']), (2010, 2))
        self.assertFalse(result['telescope_complete'])

    def test_refuses_missed_turn_despite_clean_process_exit(self):
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.log.replace('view=0', 'view=1'), self.save)

    def test_refuses_unobserved_zero_and_wrong_chart_flag(self):
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.log.replace('2036-2037', '2036'), self.save)
        with self.assertRaisesRegex(ValueError, 'prerequisite flag'):
            checker.verify(self.log.replace('1953=1', '1953=2'), self.save)

    def test_refuses_runtime_abort_and_missing_checkpoint(self):
        with self.assertRaisesRegex(ValueError, 'requested stop'):
            checker.verify(self.log.replace('stop requested', 'not lifted'), self.save)
        with self.assertRaisesRegex(ValueError, 'did not open'):
            checker.verify(self.log, self.save.with_name('different.SAV'))
        self.save.write_bytes(b'')
        with self.assertRaisesRegex(ValueError, 'unexpected length'):
            checker.verify(self.log, self.save)


class JaneJigsawResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm9.SAV'
        self.save.write_bytes(bytes(170770))
        self.log = '\n'.join(
            '  STATE requested_scene=%d art_scene=%d view=%d held_item=-1\n'
            '  RC_FLAGS 1309,1424,1567,1570,1905-1906,1980,1993,2036-2037\n'
            '  FLAGS 1424=1 1567=1 1570=1 1905=1 1993=1%s' %
            (scene, scene, view, ' 1980=1' if scene != 3575 else '')
            for scene, view in ((3575, 0), (1234, 0), (3510, 4)))
        self.log += '\n  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m9.SAV  [virtual 650000 ms]\n'
        self.log += 'RESULT {"stopped":"stop requested <52a4c0"}\n'

    def test_accepts_observed_jigsaw_win_and_room_checkpoint(self):
        result = checker.verify(self.log, self.save, route='jane-jigsaw')
        self.assertEqual((result['scene'], result['view']), (3510, 4))
        self.assertIn(1980, result['flags_one'])
        self.assertFalse(result['telescope_complete'])

    def test_refuses_room_return_without_loan_win_flag(self):
        with self.assertRaisesRegex(ValueError, 'prerequisite flag'):
            checker.verify(self.log.replace(' 1980=1', ''), self.save,
                           route='jane-jigsaw')

    def test_refuses_checkpoint_while_still_in_conversation(self):
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.log.replace('requested_scene=3510',
                                            'requested_scene=1234'), self.save,
                           route='jane-jigsaw')

    def test_refuses_a_preexisting_loan_win(self):
        with self.assertRaisesRegex(ValueError, 'before the loan win'):
            checker.verify(self.log.replace('1993=1', '1993=1 1980=1', 1),
                           self.save, route='jane-jigsaw')


class TelescopeUseResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm10.SAV'
        self.save.write_bytes(bytes(170770))
        self.log = ''
        for i, (scene, view, held) in enumerate(((3507, 0, -1), (1605, 0, -1),
                                                (2078, 0, 12), (2081, 0, -1),
                                                (2010, 19, -1))):
            self.log += ('  STATE requested_scene=%d art_scene=%d view=%d held_item=%d\n'
                         '  RC_FLAGS 1309,1424,1567,1570,1574,1905-1906,1980,1993,2036-2037\n'
                         '  FLAGS 1424=1 1567=1 1570=1 1905=1 1980=1 1993=1 2037=1%s%s\n' %
                         (scene, scene, view, held,
                          ' 1574=1 2036=1' if i else '',
                          ' 1309=1 1906=1' if i >= 3 else ''))
        self.log += '  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m10.SAV  [virtual 490000 ms]\n'
        self.log += 'RESULT {"stopped":"stop requested <52a4c0"}\n'

    def test_accepts_lens_installation_filtered_view_and_room_save(self):
        result = checker.verify(self.log, self.save, route='telescope-use')
        self.assertEqual((result['scene'], result['view']), (2010, 19))
        self.assertTrue(result['telescope_complete'])

    def test_refuses_preexisting_telescope_completion(self):
        with self.assertRaisesRegex(ValueError, 'already complete'):
            checker.verify(self.log.replace('  FLAGS ', '  FLAGS 1906=1 ', 3),
                           self.save, route='telescope-use')

    def test_refuses_use_without_held_lens(self):
        with self.assertRaisesRegex(ValueError, 'lens is not held'):
            checker.verify(self.log.replace('held_item=12', 'held_item=-1'),
                           self.save, route='telescope-use')

    def test_refuses_filtered_view_without_installation_flag(self):
        with self.assertRaisesRegex(ValueError, 'installation flag'):
            checker.verify(self.log.replace(' 1309=1', ''), self.save,
                           route='telescope-use')

    def test_refuses_unobserved_installation_or_missing_delivery(self):
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.log.replace('1309,', ''), self.save,
                           route='telescope-use')
        with self.assertRaisesRegex(ValueError, 'prerequisite flag'):
            checker.verify(self.log.replace(' 2036=1', ''), self.save,
                           route='telescope-use')


class SeedlingsResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm11.SAV'
        self.save.write_bytes(bytes(170770))
        self.observations = []
        for scene, won in ((2348, False), (2347, True), (2347, True)):
            self.observations.append(
                '  STATE requested_scene=%d art_scene=%d view=0 held_item=-1\n'
                '  RC_FLAGS 1160,1535,1541,1838-1839,1906,1968,1980,1993,2002,2036-2037,2080\n'
                '  FLAGS 1535=1 1838=1 1839=1 1906=1 1968=1 1980=1 1993=1 2036=1 2037=1 2080=1%s\n' %
                (scene, scene, ' 2002=1' if won else ''))
        self.tail = ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m11.SAV  [virtual 1150404 ms]\n'
                     'RESULT {"stopped":"stop requested <52a4c0"}\n')
        self.log = ''.join(self.observations) + self.tail

    def test_accepts_observed_packing_win_and_safe_checkpoint(self):
        result = checker.verify(self.log, self.save, route='seedlings')
        self.assertEqual((result['scene'], result['view']), (2347, 0))
        self.assertIn(2002, result['flags_one'])
        self.assertEqual(result['flags_zero'], [1160, 1541])
        self.assertTrue(result['telescope_complete'])

    def test_refuses_missing_win_or_preexisting_completion(self):
        with self.assertRaisesRegex(ValueError, 'win was not observed'):
            checker.verify(self.log.replace(' 2002=1', '', 1), self.save,
                           route='seedlings')
        log = self.log.replace('  FLAGS ', '  FLAGS 2002=1 ', 1)
        with self.assertRaisesRegex(ValueError, 'already complete'):
            checker.verify(log, self.save, route='seedlings')

    def test_refuses_reordered_or_missing_safe_room_observation(self):
        log = ''.join((self.observations[1], self.observations[0],
                       self.observations[2])) + self.tail
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(log, self.save, route='seedlings')
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(''.join(self.observations[:2]) + self.tail,
                           self.save, route='seedlings')
        log = ''.join(self.observations[:2]) + self.observations[2].replace(
            'held_item=-1', 'held_item=5') + self.tail
        with self.assertRaisesRegex(ValueError, 'not safe'):
            checker.verify(log, self.save, route='seedlings')

    def test_refuses_unobserved_flags_and_unexercised_progression(self):
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.log.replace('2002,', ''), self.save,
                           route='seedlings')
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.log.replace('1541,', ''), self.save,
                           route='seedlings')
        with self.assertRaisesRegex(ValueError, 'progression flag'):
            checker.verify(self.log.replace('  FLAGS ', '  FLAGS 1160=1 '),
                           self.save, route='seedlings')
        with self.assertRaisesRegex(ValueError, 'prerequisite flag'):
            checker.verify(self.log.replace(' 1906=1', ''), self.save,
                           route='seedlings')

    def test_route_reproduces_exercised_input_and_parameterizes_save_name(self):
        route_module = MODULE.with_name('story_route.py')
        route_spec = importlib.util.spec_from_file_location('recomp_story_route', route_module)
        story = importlib.util.module_from_spec(route_spec)
        route_spec.loader.exec_module(story)
        # Digest of the accepted ordinary INPUT, including its trailing newline.
        import hashlib
        actual = story.leg_seedlings(save='m11')
        self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(),
                         '3a2ad43204fec5c9d31aa318f569aa4f957a388c02ff46592f40d7f7e185d878')
        prefix = story.leg_seedlings()
        self.assertTrue(actual.startswith(prefix + ';'))
        self.assertIn('S2347.CIF+41000:click:306,194,300', prefix)
        renamed = story.leg_seedlings(save='plants')
        expected_tail = ';'.join([story.menu_to_save_screen('S2348.CIF', 250000),
                                  story.save_tail('S2348.CIF', 268000, 'plants')])
        self.assertEqual(renamed, prefix + ';' + expected_tail)


class CrankRepairResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm12.SAV'
        self.save.write_bytes(bytes(170770))
        self.frames = []
        states = ((2347, -1), (1000, -1), (1089, -1),
                  (2711, -1), (2711, 20), (2713, -1), (2702, -1), (2701, -1))
        for index, (scene, held) in enumerate(states):
            # Synthetic non-boolean values exercise the clock distinction.
            flags = {338: 7, 339: 11, 340: 13, 341: 17,
                     1906: 1, 2002: 1}
            if index >= 2:
                flags[1541] = 1
            if index >= 5:
                flags[1160] = 1
            if index >= 6:
                flags[1782] = 1
            self.frames.append({'scene': scene, 'held': held,
                                'scope': '338-341,1160,1541,1782,1906,1963,2002',
                                'flags': flags})

    def observed_log(self):
        log = ''
        for frame in self.frames:
            scene = frame['scene']
            log += ('  STATE requested_scene=%d art_scene=%d view=0 held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (scene, scene, frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in frame['flags'].items())))
        log += '  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m12.SAV  [virtual 10952596 ms]\n'
        return log + 'RESULT {"stopped":"stop requested <52a4c0"}\n'

    def test_accepts_reward_repair_and_keypad_without_claiming_card_win(self):
        result = checker.verify(self.observed_log(), self.save, route='crank-repair')
        self.assertEqual((result['scene'], result['view']), (2701, 0))
        self.assertEqual(result['flags_one'], [1160, 1541, 1782, 1906, 2002])
        self.assertEqual(result['flags_zero'], [1963])
        self.assertTrue(result['telescope_complete'])
        self.assertEqual(checker.flag_scope('338-341,1160'), {1160})

    def test_rejects_preexisting_reward_or_repair_before_crank_use(self):
        self.frames[0]['flags'][1541] = 1
        with self.assertRaisesRegex(ValueError, 'before claim'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')
        self.frames[0]['flags'][1541] = 0
        self.frames[4]['flags'][1160] = 1
        with self.assertRaisesRegex(ValueError, 'pre/post-repair'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')

    def test_requires_actual_held_crank_and_empty_hand_at_safe_checkpoint(self):
        self.frames[4]['held'] = -1
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')
        self.frames[4]['held'] = 20
        self.frames[-1]['held'] = 20
        with self.assertRaisesRegex(ValueError, 'safe state'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')

    def test_requires_observed_card_zero_and_keypad_entrance(self):
        self.frames[-1]['scope'] = self.frames[-1]['scope'].replace(',1963', '')
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')
        self.frames[-1]['scope'] += ',1963'
        self.frames[-1]['flags'][1963] = 1
        with self.assertRaisesRegex(ValueError, 'progression flag'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')
        self.frames[-1]['flags'][1963] = 0
        self.frames[-1]['flags'][1782] = 0
        with self.assertRaisesRegex(ValueError, 'prerequisite flag'):
            checker.verify(self.observed_log(), self.save, route='crank-repair')


class BettyKeyResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm13.SAV'
        self.save.write_bytes(bytes(170770))
        self.frames = []
        for index, (scene, held) in enumerate(((2701, -1), (2702, -1), (2704, -1),
                                               (2711, -1), (2711, 19),
                                               (2700, -1), (2700, -1))):
            flags = {1160: 1, 1541: 1, 1782: 1, 1906: 1, 2002: 1}
            if index >= 3:
                flags[1963] = 1
            self.frames.append({'scene': scene, 'held': held, 'flags': flags,
                                'scope': '1160,1541,1782,1906,1963,2002'})

    def observed_log(self):
        log = ''
        for frame in self.frames:
            log += ('  STATE requested_scene=%d art_scene=%d view=0 held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (frame['scene'], frame['scene'], frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in frame['flags'].items())))
        return log + ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m13.SAV  [virtual 3530000 ms]\n'
                      'RESULT {"stopped":"stop requested <52a4c0"}\n')

    def test_accepts_observed_prize_key_and_safe_room(self):
        result = checker.verify(self.observed_log(), self.save, route='betty-key')
        self.assertEqual((result['scene'], result['view']), (2700, 0))
        self.assertIn(1963, result['flags_one'])

    def test_rejects_preexisting_or_missing_original_prize_flag(self):
        self.frames[2]['flags'][1963] = 1
        with self.assertRaisesRegex(ValueError, 'pre/post-win'):
            checker.verify(self.observed_log(), self.save, route='betty-key')
        self.frames[2]['flags'][1963] = 0
        self.frames[3]['flags'][1963] = 0
        with self.assertRaisesRegex(ValueError, 'pre/post-win'):
            checker.verify(self.observed_log(), self.save, route='betty-key')

    def test_requires_actual_key_and_observed_safe_checkpoint(self):
        self.frames[4]['held'] = -1
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.observed_log(), self.save, route='betty-key')
        self.frames[4]['held'] = 19
        self.frames[-1]['held'] = 19
        with self.assertRaisesRegex(ValueError, 'safe state'):
            checker.verify(self.observed_log(), self.save, route='betty-key')
        self.frames[-1]['held'] = -1
        self.frames[0]['scope'] = self.frames[0]['scope'].replace(',1963', '')
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.observed_log(), self.save, route='betty-key')


class VenusColumnResultTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.save = Path(self.folder.name) / 'm14.SAV'
        self.save.write_bytes(bytes(170770))
        self.frames = []
        for index, (scene, view, held) in enumerate(((2700, 0, -1), (2605, 16, -1),
                                                    (2649, 0, -1), (2649, 0, 19),
                                                    (2686, 0, -1), (2633, 0, -1),
                                                    (2633, 0, -1))):
            flags = {1160: 1, 1541: 1, 1782: 1, 1906: 1, 1963: 1, 2002: 1}
            if index >= 4:
                flags.update({1892: 1, 2000: 1, 2015: 1})
            self.frames.append({'scene': scene, 'view': view, 'held': held, 'flags': flags,
                                'scope': '1160,1541,1782,1892,1906,1961,1963,1999,2000,2002,2015,2070'})

    def observed_log(self):
        log = ''
        for frame in self.frames:
            log += ('  STATE requested_scene=%d art_scene=%d view=%d held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (frame['scene'], frame['scene'], frame['view'], frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in frame['flags'].items())))
        return log + ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m14.SAV  [virtual 260000 ms]\n'
                      'RESULT {"stopped":"stop requested <52a4c0"}\n')

    def test_accepts_actual_key_use_task_and_safe_room(self):
        result = checker.verify(self.observed_log(), self.save, route='venus-column')
        self.assertEqual((result['scene'], result['view']), (2633, 0))
        self.assertTrue({1892, 2000, 2015} <= set(result['flags_one']))
        self.assertEqual(result['flags_zero'], [1961, 1999, 2070])

    def test_rejects_missing_key_or_false_completion_transition(self):
        self.frames[3]['held'] = -1
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.observed_log(), self.save, route='venus-column')
        self.frames[3]['held'] = 19
        self.frames[2]['flags'][2000] = 1
        with self.assertRaisesRegex(ValueError, 'pre/post-key-use'):
            checker.verify(self.observed_log(), self.save, route='venus-column')
        self.frames[2]['flags'][2000] = 0
        self.frames[4]['flags'][1892] = 0
        with self.assertRaisesRegex(ValueError, 'pre/post-key-use'):
            checker.verify(self.observed_log(), self.save, route='venus-column')

    def test_rejects_unobserved_zero_extra_progression_and_unsafe_checkpoint(self):
        self.frames[-1]['scope'] = self.frames[-1]['scope'].replace(',2070', '')
        with self.assertRaisesRegex(ValueError, 'every required event'):
            checker.verify(self.observed_log(), self.save, route='venus-column')
        self.frames[-1]['scope'] += ',2070'
        self.frames[4]['flags'][1999] = 1
        with self.assertRaisesRegex(ValueError, 'progression flag'):
            checker.verify(self.observed_log(), self.save, route='venus-column')
        self.frames[4]['flags'][1999] = 0
        self.frames[-1]['held'] = 19
        with self.assertRaisesRegex(ValueError, 'safe state'):
            checker.verify(self.observed_log(), self.save, route='venus-column')


class VenusKeyInputTests(unittest.TestCase):
    def test_public_legs_reproduce_accepted_fragments_and_parameterize_save(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('venus_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, anchor, menu_at, save_at in (
                (story.leg_betty_key, 'm13', '05f5524373caf2527584dd829192a2d5de63013dc1a9f9219577ed8b9489c8a9',
                 'S2702.CIF', 3470000, 3488000),
                (story.leg_venus_column, 'm14', 'd14780efffd5505256b404fcd15bae0a3f372edc909cbe034c84f6b3aac19c29',
                 'S2700.CIF', 210000, 228000)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'venus')])
                self.assertEqual(leg(save='venus'), expected)
                self.assertLess(len(actual.split(';')) + 7, 512)  # original-menu load prefix


if __name__ == '__main__':
    unittest.main()
