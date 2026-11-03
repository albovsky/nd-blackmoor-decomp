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


class ColumnContinuationResultTests(unittest.TestCase):
    # Small synthetic observations follow the accepted m14 -> m17 traces.
    records = {
        'jupiter-column': ('m15', ((2633, 0, -1), (2605, 8, -1), (2605, 5, -1),
                                  (2631, 0, -1), (2631, 0, 6), (2681, 0, -1),
                                  (2631, 0, -1), (2631, 0, -1)), {1436: 5, 1981: 5}),
        'moon-key': ('m16', ((2631, 0, -1), (2605, 5, -1), (2605, 0, -1), (3345, 0, -1),
                            (2010, 1, -1), (2010, 3, -1), (2082, 0, -1), (2082, 0, 12),
                            (2083, 0, -1), (2085, 0, -1), (2090, 0, -1), (2087, 0, -1),
                            (2088, 0, -1), (2087, 0, 11), (2087, 0, -1), (2083, 0, -1),
                            (2018, 0, -1), (2010, 3, -1), (2010, 3, -1)),
                     {1259: 3, 2077: 8, 1996: 9, 2019: 11, 2092: 11}),
        'moon-column': ('m17', ((2010, 3, -1), (2605, 5, -1), (2605, 15, -1),
                               (2626, 0, -1), (2626, 0, 11), (2684, 0, -1),
                               (2626, 0, -1), (2626, 0, -1)), {1597: 5, 1994: 5}),
    }

    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)

    def frames(self, route):
        name, states, transitions = self.records[route]
        save = Path(self.folder.name) / (name + '.SAV')
        save.write_bytes(bytes(170770))
        prior = {1160, 1541, 1782, 1892, 1906, 1963, 1980, 1993, 2000, 2002, 2015, 2036, 2037}
        if route != 'jupiter-column':
            prior |= {1436, 1981}
        if route == 'moon-column':
            prior |= {1259, 1996, 2019, 2077, 2092}
        frames = []
        for index, (scene, view, held) in enumerate(states):
            flags = {f: 1 for f in prior}
            flags.update({f: 1 for f, first in transitions.items() if index >= first})
            frames.append({'scene': scene, 'view': view, 'held': held, 'flags': flags,
                           'scope': '1000-2230'})
        return save, frames

    def observed_log(self, save, frames):
        log = ''
        for frame in frames:
            log += ('  STATE requested_scene=%d art_scene=%d view=%d held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (frame['scene'], frame['scene'], frame['view'], frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in sorted(frame['flags'].items()))))
        return log + ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\%s  [virtual 800000 ms]\n'
                      'RESULT {"stopped":"stop requested <52a4c0"}\n' % save.name)

    def test_accepts_original_transitions_and_safe_checkpoints(self):
        for route, (name, states, _) in self.records.items():
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(save, frames), save, route)
                self.assertEqual((result['scene'], result['view']), states[-1][:2])
                self.assertTrue(result['telescope_complete'])
                self.assertTrue({1961, 1999, 2070} <= set(result['flags_zero']))

    def test_requires_actual_held_jupiter_key_lens_and_moon_key(self):
        for route, index in (('jupiter-column', 4), ('moon-key', 7),
                             ('moon-key', 13), ('moon-column', 4)):
            with self.subTest(route=route, index=index):
                save, frames = self.frames(route)
                frames[index]['held'] = -1
                with self.assertRaisesRegex(ValueError, 'ordered'):
                    checker.verify(self.observed_log(save, frames), save, route)

    def test_rejects_preexisting_or_missing_original_progression(self):
        for route, index, flag, value in (
                ('jupiter-column', 3, 1981, 1), ('jupiter-column', 5, 1436, 0),
                ('moon-key', 7, 2077, 1), ('moon-key', 11, 2092, 0),
                ('moon-column', 4, 1994, 1), ('moon-column', 5, 1597, 0)):
            with self.subTest(route=route, flag=flag, value=value):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'pre/post'):
                    checker.verify(self.observed_log(save, frames), save, route)

    def test_requires_scope_retained_prerequisites_and_unmet_columns(self):
        for route in self.records:
            for failure in ('scope', 'retained', 'progression'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'scope':
                        frames[-1]['scope'] = '1000-2069,2071-2230'
                        reason = 'every required event'
                    elif failure == 'retained':
                        frames[0]['flags'][1980] = 0
                        reason = 'prerequisite flag'
                    else:
                        frames[1]['flags'][1999] = 1
                        reason = 'progression flag'
                    with self.assertRaisesRegex(ValueError, reason):
                        checker.verify(self.observed_log(save, frames), save, route)

    def test_requires_ordered_win_and_final_safe_observations(self):
        for route, win in (('jupiter-column', 5), ('moon-key', 10), ('moon-column', 5)):
            with self.subTest(route=route, failure='order'):
                save, frames = self.frames(route)
                frames[win], frames[win + 1] = frames[win + 1], frames[win]
                with self.assertRaisesRegex(ValueError, 'ordered'):
                    checker.verify(self.observed_log(save, frames), save, route)
            with self.subTest(route=route, failure='safe'):
                save, frames = self.frames(route)
                # An earlier inventory/room shot must not hide the final state.
                frames.insert(-2, dict(frames[-2]))
                frames[-1]['held'] = 11
                with self.assertRaisesRegex(ValueError, 'safe state'):
                    checker.verify(self.observed_log(save, frames), save, route)


class ColumnContinuationInputTests(unittest.TestCase):
    def test_public_legs_reproduce_exact_inputs_and_parameterize_only_save_tail(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('column_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, anchor, menu_at, save_at in (
                (story.leg_jupiter_column, 'm15', '47f42005408fe847d5a805a13db4a12fb8777be2892a7e11669ac1bc9f84b6bf',
                 'S2633.CIF', 175000, 193000),
                (story.leg_moon_key, 'm16', '11e34f389bff961eb03c3820b2ee26efeb383ceb29c8bad42263c059a360a10b',
                 'S2631.CIF', 725000, 743000),
                (story.leg_moon_column, 'm17', 'd78a583c31b6cf0c259a80f813967f240ff69ffdad6392a406449e5f8fe8be28',
                 'S2010.CIF', 289500, 307500)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'columns')])
                self.assertEqual(leg(save='columns'), expected)
                self.assertLess(len(actual.split(';')) + 7, 512)


class GhostRouteResultTests(unittest.TestCase):
    # Handwritten compact observations from the accepted four-leg sequence.
    prior = {1160, 1259, 1436, 1541, 1597, 1782, 1892, 1906, 1963, 1980,
             1981, 1993, 1994, 1996, 2000, 2002, 2015, 2019, 2036, 2037, 2077, 2092}
    nigel = {1573, 1677, 1682, 1692, 1701, 1823, 1985, 2069}
    captures = ((2354, 2351, 1174), (2325, 2325, 1173), (2694, 2694, 1172),
                (2693, 2693, 1171), (3432, 3432, 1163), (3433, 3433, 1164),
                (3431, 3431, 1162), (2691, 2691, 1169), (3434, 3434, 1165),
                (3435, 3435, 1166), (3436, 3436, 1167), (3437, 3437, 1168), (2692, 2692, 1170))
    routes = ('nigel-computer', 'night-wait', 'goggles', 'ghost-hunt')

    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)

    def frames(self, route):
        number = self.routes.index(route) + 18
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        prior = set(self.prior)
        held = {}
        if route == 'nigel-computer':
            states = ((2626, 0), (2605, 15), (2605, 6), (4101, 0), (4112, 0),
                      (1300, 0), (1304, 0), (1305, 0), (1306, 0), (1319, 0),
                      (1307, 0), (1311, 0), (4112, 0), (4160, 0), (4165, 0),
                      (4160, 0), (4111, 0), (4111, 0))
            phases = {1573: 6, 1701: 8, 1677: 9, 1682: 11, 1692: 13, 2069: 13, 1823: 14, 1985: 14}
        elif route == 'night-wait':
            states = ((4111, 0),) * 3
            prior |= self.nigel
            phases = {}
        elif route == 'goggles':
            states = ((4111, 0), (4105, 10), (2605, 19), (3308, 0), (3471, 0),
                      (3473, 0), (3369, 0), (3368, 0), (3473, 0), (2605, 5),
                      (4111, 0), (4111, 0), (4111, 0), (4111, 0))
            prior |= self.nigel
            phases = {1893: 4, 1788: 6}
            held = {11: 21}
        else:
            states = [(4111, 0), (4165, 0), (4111, 0)]
            states += [(scene, 0) for first, second, _ in self.captures for scene in (first, second)]
            states += [(4111, 0), (4178, 0), (4160, 0), (4111, 0), (4111, 0)]
            prior |= self.nigel | {1788, 1893}
            phases = {2063: 2, 1958: 28, 1947: 30}
            phases.update({flag: 4 + 2 * i for i, (_, _, flag) in enumerate(self.captures)})
        frames = []
        for index, (scene, view) in enumerate(states):
            flags = {f: 1 for f in prior}
            flags.update({f: 1 for f, first in phases.items() if index >= first})
            if route == 'ghost-hunt' and 2 <= index < 30:
                flags.update({1192: 1, 2039: 1})
            clock = (1, 12, 24) if route == 'nigel-computer' else (2, 1, 0)
            if route == 'night-wait':
                clock = (1, 12, 24) if index == 0 else (2, 0, 28 + index)
            frames.append({'scene': scene, 'view': view, 'held': held.get(index, -1),
                           'flags': flags, 'scope': '338-341,1000-2230', 'clock': clock})
        return save, frames

    def observed_log(self, save, frames):
        log = ''
        for index, frame in enumerate(frames):
            day, hour, minute = frame['clock']
            total = hour * 60 + minute
            raw = dict(frame['flags'])
            raw.update({338: (total & 65535) << 16,
                        339: (total >> 16) | (minute << 16),
                        340: (day << 16) | hour, 341: 123456 + index * 20})
            log += ('  STATE requested_scene=%d art_scene=%d view=%d held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (frame['scene'], frame['scene'], frame['view'], frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in sorted(raw.items()) if pair[1])))
        return log + ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\%s  [virtual 15000000 ms]\n'
                      'RESULT {"stopped":"stop requested <52a4c0"}\n' % save.name)

    def test_accepts_four_coherent_legs_and_separates_clock_diagnostics(self):
        for route in self.routes:
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(save, frames), save, route)
                self.assertEqual((result['scene'], result['view']), (4111, 0))
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))
                if route != 'nigel-computer':
                    self.assertEqual(result['clock_diagnostics']['day'], 2)
                    self.assertLess(result['clock_diagnostics']['hour'], 4)
                if route == 'ghost-hunt':
                    self.assertTrue(set(range(1162, 1175)) <= set(result['flags_one']))

    def test_requires_actual_goggles_instead_of_another_held_item(self):
        save, frames = self.frames('goggles')
        frames[11]['held'] = 11
        with self.assertRaisesRegex(ValueError, 'ordered'):
            checker.verify(self.observed_log(save, frames), save, 'goggles')

    def test_rejects_preexisting_or_missing_original_progression(self):
        for route, index, flag, value in (
                ('nigel-computer', 0, 1985, 1), ('nigel-computer', 11, 1682, 0),
                ('goggles', 0, 1893, 1), ('goggles', 6, 1788, 0),
                ('ghost-hunt', 0, 1958, 1), ('ghost-hunt', 30, 1947, 0)):
            with self.subTest(route=route, flag=flag):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'pre/post'):
                    checker.verify(self.observed_log(save, frames), save, route)

    def test_refuses_partial_hunt_despite_clean_reward_shaped_log(self):
        for missing in ((1170,), (1170, 1171)):
            with self.subTest(missing=missing):
                save, frames = self.frames('ghost-hunt')
                for frame in frames:
                    for flag in missing:
                        frame['flags'].pop(flag, None)
                with self.assertRaisesRegex(ValueError, 'pre/post'):
                    checker.verify(self.observed_log(save, frames), save, 'ghost-hunt')

    def test_requires_failure_zero_and_original_timer_start_and_clear(self):
        for route in self.routes:
            with self.subTest(route=route, failure='failed'):
                save, frames = self.frames(route)
                frames[1]['flags'][2040] = 1
                with self.assertRaisesRegex(ValueError, 'hunt failure'):
                    checker.verify(self.observed_log(save, frames), save, route)
        for index, flag, value in ((2, 2039, 0), (-1, 1192, 1)):
            with self.subTest(index=index, flag=flag):
                save, frames = self.frames('ghost-hunt')
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'hunt timer'):
                    checker.verify(self.observed_log(save, frames), save, 'ghost-hunt')

    def test_requires_failure_scope_and_retained_column_prerequisites(self):
        for route in self.routes:
            for failure in ('scope', 'retained'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'scope':
                        frames[-1]['scope'] = '338-341,1000-2039,2041-2230'
                        reason = 'every required event'
                    else:
                        frames[0]['flags'][1994] = 0
                        reason = 'prerequisite flag'
                    with self.assertRaisesRegex(ValueError, reason):
                        checker.verify(self.observed_log(save, frames), save, route)

    def test_requires_observed_original_clock_and_night_transition(self):
        for route in ('night-wait', 'goggles', 'ghost-hunt'):
            for failure in ('scope', 'daylight'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'scope':
                        frames[-1]['scope'] = '1000-2230'
                        reason = 'clock diagnostics'
                    else:
                        frames[-1]['clock'] = (2, 4, 0)
                        reason = 'night gate'
                    with self.assertRaisesRegex(ValueError, reason):
                        checker.verify(self.observed_log(save, frames), save, route)
        save, frames = self.frames('night-wait')
        frames[0]['clock'] = (2, 0, 0)
        with self.assertRaisesRegex(ValueError, 'day transition'):
            checker.verify(self.observed_log(save, frames), save, 'night-wait')

    def test_requires_scene_order_and_final_two_safe_observations(self):
        for route, index in (('nigel-computer', 8), ('goggles', 6), ('ghost-hunt', 3)):
            with self.subTest(route=route, failure='order'):
                save, frames = self.frames(route)
                frames[index], frames[index + 1] = frames[index + 1], frames[index]
                with self.assertRaisesRegex(ValueError, 'ordered'):
                    checker.verify(self.observed_log(save, frames), save, route)
        for route in self.routes:
            with self.subTest(route=route, failure='safe'):
                save, frames = self.frames(route)
                frames.insert(-2, dict(frames[-2]))
                frames[-1]['held'] = 11
                with self.assertRaisesRegex(ValueError, 'safe state'):
                    checker.verify(self.observed_log(save, frames), save, route)


class GhostRouteInputTests(unittest.TestCase):
    def test_four_public_legs_reproduce_accepted_inputs_and_parameterize_saves(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('ghost_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, anchor, menu_at, save_at in (
                (story.leg_nigel_computer, 'm18', '52c545579227030215cd10953a84f2984ffb8f211d6843f176970214fa9d3051',
                 'S2626.CIF', 1124000, 1142000),
                (story.leg_night_wait, 'm19', '41bbb3250aa75634704ba849e4ef0f2a6aa9c0f47bc57d71eab02c29748ad30e',
                 'S4111.CIF', 14520000, 14538000),
                (story.leg_goggles, 'm20', '8d58cb0b2d783007dadb99d0d5ffa085f8979b8dcb6ec4abacef09a06b30b6ec',
                 'S4111.CIF', 306000, 324000),
                (story.leg_ghost_hunt, 'm21', 'bd72dd8e706fe3c999704b892e826971edc75ecc87d220e520c58ff14097f33b',
                 'S4172.CIF', 320000, 338000)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'ghost')])
                self.assertEqual(leg(save='ghost'), expected)
                self.assertLess(len(actual.split(';')) + 7, 512)


class PassageRouteResultTests(unittest.TestCase):
    prior = GhostRouteResultTests.prior | GhostRouteResultTests.nigel | set(range(1162, 1175)) | {1788, 1893, 1947, 1958, 2063}
    routes = ('afternoon-door', 'linda-passage', 'bul-key')

    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)

    def frames(self, route):
        save = Path(self.folder.name) / ('m%d.SAV' % (22 + self.routes.index(route)))
        save.write_bytes(bytes(170770))
        prior = set(self.prior)
        if route == 'afternoon-door':
            states = ((4111, 0), (2605, 19), (3329, 0), (3360, 0),
                      (3360, 0), (3360, 0), (3360, 0))
            phases = {2058: 4}
        elif route == 'linda-passage':
            states = ((3360, 0), (4408, 0), (1114, 0), (4408, 0),
                      (4410, 2), (4410, 10), (2605, 5), (4408, 0),
                      (1139, 0), (1120, 0), (1142, 0), (1124, 0),
                      (1127, 0), (4408, 0), (4408, 0))
            prior.add(2058)
            phases = {1496: 2, 2156: 6, 1494: 8, 1498: 12}
        else:
            states = ((4408, 0), (4410, 2), (4410, 10), (3510, 0),
                      (3510, 4), (1200, 0), (1252, 0), (1261, 0),
                      (1258, 0), (1259, 0), (1264, 0), (1218, 0),
                      (3510, 4), (3510, 4), (3510, 4), (3510, 4))
            prior |= {2058, 1496, 2156, 1494, 1498}
            phases = {1404: 6, 1435: 7, 1405: 9}
        frames = []
        for index, (scene, view) in enumerate(states):
            flags = {f: 1 for f in prior}
            flags.update({f: 1 for f, first in phases.items() if index >= first})
            if route == 'bul-key' and index == 8:
                flags[1969] = 1
            art = 4408 if route == 'linda-passage' and scene in (1114, 1139, 1120, 1142, 1124, 1127) else scene
            clock = (2, 14, 30) if route == 'linda-passage' else (2, 16, 0)
            if route == 'afternoon-door':
                clock = (2, 1, 9) if index < len(states) - 2 else (2, 14, 10 + index - (len(states) - 2))
            frames.append({'scene': scene, 'art': art, 'view': view,
                           'held': 7 if route == 'bul-key' and index == 13 else -1,
                           'flags': flags, 'scope': '338-341,1000-2230', 'clock': clock})
        return save, frames

    def observed_log(self, save, frames, opened=None):
        log = ''
        if opened is None:
            opened = (3610, 3635, 1258, 1259, 1264, 1218)
        for index, frame in enumerate(frames):
            if save.name == 'm24.SAV':
                for slot, scene in zip((8, 8, 8, 9, 10, 11), opened):
                    if slot == index:
                        log += '  FILE open C:\\GAME\\Ciftree\\S%d.CIF  [virtual %d ms]\n' % (scene, 1000 + index)
            day, hour, minute = frame['clock']
            total = hour * 60 + minute
            raw = dict(frame['flags'])
            raw.update({338: (total & 65535) << 16, 339: (total >> 16) | (minute << 16),
                        340: (day << 16) | hour, 341: 123456 + index * 20})
            log += ('  STATE requested_scene=%d art_scene=%d view=%d held_item=%d\n'
                    '  RC_FLAGS %s\n  FLAGS %s\n' %
                    (frame['scene'], frame['art'], frame['view'], frame['held'], frame['scope'],
                     ' '.join('%d=%d' % pair for pair in sorted(raw.items()) if pair[1])))
        return log + ('  FILE open C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\%s  [virtual 16000000 ms]\n'
                      'RESULT {"stopped":"stop requested <52a4c0"}\n' % save.name)

    def test_accepts_observed_passage_and_actual_bul_results(self):
        for route, final in (('afternoon-door', (3360, 0)), ('linda-passage', (4408, 0)),
                             ('bul-key', (3510, 4))):
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(save, frames), save, route)
                self.assertEqual((result['scene'], result['view']), final)
                self.assertTrue(result['telescope_complete'])
                self.assertEqual(result['clock_diagnostics']['day'], 2)
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))

    def test_requires_original_door_linda_wager_and_reward_transitions(self):
        for route, index, flag, value in (
                ('afternoon-door', 0, 2058, 1), ('afternoon-door', 4, 2058, 0),
                ('linda-passage', 0, 1494, 1), ('linda-passage', 12, 1498, 0),
                ('bul-key', 0, 1405, 1), ('bul-key', 7, 1435, 0),
                ('bul-key', 9, 1405, 0)):
            with self.subTest(route=route, flag=flag, value=value):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'pre/post'):
                    checker.verify(self.observed_log(save, frames), save, route)

    def test_requires_real_key7_and_original_pickup_scene(self):
        for failure in ('held', 'pickup'):
            with self.subTest(failure=failure):
                save, frames = self.frames('bul-key')
                if failure == 'held':
                    frames[13]['held'] = 17
                else:
                    frames[10]['scene'] = frames[10]['art'] = 1259
                with self.assertRaisesRegex(ValueError, 'ordered'):
                    checker.verify(self.observed_log(save, frames), save, 'bul-key')

    def test_transient_1969_can_clear_while_durable_reward_remains(self):
        save, frames = self.frames('bul-key')
        frames[8]['flags'].pop(1969)
        result = checker.verify(self.observed_log(save, frames), save, 'bul-key')
        self.assertIn(1405, result['flags_one'])
        self.assertNotIn(1969, result['flags_one'])
        self.assertIn(1969, result['flags_zero'])
        frames[-1]['flags'][1969] = 1
        with self.assertRaisesRegex(ValueError, 'transient Bul win'):
            checker.verify(self.observed_log(save, frames), save, 'bul-key')

    def test_requires_ordered_authored_bul_win_and_reward_scene_opens(self):
        save, frames = self.frames('bul-key')
        for opened in ((3610, 1258, 1259, 1264, 1218), (3635, 3610, 1258, 1259, 1264, 1218)):
            with self.subTest(opened=opened):
                with self.assertRaisesRegex(ValueError, 'authored Bul win'):
                    checker.verify(self.observed_log(save, frames, opened), save, 'bul-key')

    def test_requires_unmet_scope_retained_ghost_reward_and_final_safe_state(self):
        for route in self.routes:
            for failure in ('scope', 'retained', 'safe'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'scope':
                        frames[-1]['scope'] = '338-341,1000-1970,1972-2230'
                        reason = 'every required event'
                    elif failure == 'retained':
                        frames[0]['flags'][1958] = 0
                        reason = 'prerequisite flag'
                    else:
                        frames.insert(-2, dict(frames[-2]))
                        frames[-1]['held'] = 7
                        reason = 'safe state'
                    with self.assertRaisesRegex(ValueError, reason):
                        checker.verify(self.observed_log(save, frames), save, route)

    def test_linda_caption_requires_its_recorded_retained_room_art(self):
        save, frames = self.frames('linda-passage')
        frames[2]['art'] = 1114
        with self.assertRaisesRegex(ValueError, 'art scene'):
            checker.verify(self.observed_log(save, frames), save, 'linda-passage')

    def test_requires_actual_afternoon_clock_diagnostics_and_wait(self):
        for route in self.routes:
            for failure in ('scope', 'gate'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'scope':
                        frames[-1]['scope'] = '1000-2230'
                        reason = 'clock diagnostics'
                    else:
                        frames[-1]['clock'] = (2, 21, 0)
                        reason = 'afternoon gate'
                    with self.assertRaisesRegex(ValueError, reason):
                        checker.verify(self.observed_log(save, frames), save, route)
        save, frames = self.frames('afternoon-door')
        for frame in frames:
            frame['clock'] = (2, 14, 0)
        with self.assertRaisesRegex(ValueError, 'observed night window'):
            checker.verify(self.observed_log(save, frames), save, 'afternoon-door')


class PassageRouteInputTests(unittest.TestCase):
    def test_public_legs_preserve_exact_junior_input_and_parameterize_save(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('passage_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, anchor, menu_at, save_at in (
                (story.leg_afternoon_door, 'm22', '8dc20964d71c5a598ce31f2f983ac1019b36ca63806f9366174060575c45e37f',
                 'S4111.CIF', 15736000, 15754000),
                (story.leg_linda_passage, 'm23', '58017eb5804483c30c7dbe3ad7e2c9bf05e1fac6c7f93315d57f8c5bb97cf730',
                 'S3360.CIF', 755000, 773000)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'passage')])
                self.assertEqual(leg(save='passage'), expected)
                self.assertLess(len(actual.split(';')) + 7, 512)

    def test_bul_start_is_only_the_exercised_wager_prefix_and_refuses_save(self):
        spec = importlib.util.spec_from_file_location('bul_start_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        actual = story.leg_bul_start()
        self.assertEqual(len(actual.split(';')), 71)
        self.assertTrue(actual.endswith('S4408.CIF+326000:shot:0,0'))
        self.assertNotIn('319,123', actual)
        self.assertNotIn('S1259.CIF', actual)
        with self.assertRaisesRegex(ValueError, 'ends inside Bul'):
            story.leg_bul_start(save='m24')


class PostKeyRouteTests(unittest.TestCase):
    prior = PassageRouteResultTests.prior | {2058, 1494, 1496, 1498, 2156, 1404, 1435, 1405}
    opens = {'slide-ball': (1420, 1400, 1401, 3310, 3360, 3361, 3330, 3344, 3425, 3420, 2676, 3215),
             'saturn-column': (3420, 3421, 3426, 2677, 2620, 2685, 2620)}

    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)

    def frames(self, route):
        save = Path(self.folder.name) / ('m25.SAV' if route == 'slide-ball' else 'm26.SAV')
        save.write_bytes(bytes(170770))
        prior = set(self.prior)
        if route == 'slide-ball':
            states = ((3510, 4), (1400, 0), (1401, 0), (3310, 0),
                      (3360, 0), (3361, 0), (3330, 0), (3344, 0),
                      (3425, 0), (2676, 0), (3215, 0), (3215, 0),
                      (3215, 0), (3215, 0), (3215, 0))
            phases = {1562: 1, 1971: 5, 1575: 9, 1844: 9, 2050: 11}
            held = {4: 7, 12: 3}
        else:
            prior |= {1562, 1971, 1575, 1844, 2050}
            states = ((3215, 0), (3420, 0), (3421, 0), (2677, 0),
                      (2677, 0), (2620, 0), (2685, 0), (2620, 0), (2620, 0))
            phases = {1970: 3, 1820: 6, 2005: 6}
            held = {4: 16, 5: 16}
        frames = []
        for index, (scene, view) in enumerate(states):
            flags = {f: 1 for f in prior}
            flags.update({f: 1 for f, phase in phases.items() if index >= phase})
            frames.append({'scene': scene, 'art': scene, 'view': view,
                           'held': held.get(index, -1), 'flags': flags,
                           'scope': '338-341,1000-2230', 'clock': (2, 16, 0)})
        return save, frames

    def observed_log(self, route, save, frames, opened=None):
        # Ordinary resource-order records and the existing observation encoder.
        scenes = self.opens[route] if opened is None else opened
        prefix = ''.join('  FILE open C:\\GAME\\Ciftree\\S%d.CIF  [virtual %d ms]\n' % (scene, 1000 + i)
                         for i, scene in enumerate(scenes))
        return prefix + PassageRouteResultTests.observed_log(self, save, frames, opened=())

    def test_accepts_both_observed_routes_and_keeps_1005_out_of_requirements(self):
        for route, final in (('slide-ball', 3215), ('saturn-column', 2620)):
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(route, save, frames), save, route)
                self.assertEqual((result['scene'], result['view']), (final, 0))
                self.assertEqual(result['clock_diagnostics']['day'], 2)
                self.assertNotIn(1005, result['flags_one'])
                self.assertNotIn(1005, result['flags_zero'])
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))

    def test_rejects_preexisting_or_missing_original_phase_flags(self):
        for route, index, flag, value in (('slide-ball', 0, 1562, 1),
                ('slide-ball', 0, 1971, 1), ('slide-ball', 5, 1971, 0),
                ('slide-ball', 9, 1844, 0), ('slide-ball', 11, 2050, 0),
                ('saturn-column', 0, 1970, 1), ('saturn-column', 5, 1820, 1),
                ('saturn-column', 6, 2005, 0)):
            with self.subTest(route=route, flag=flag, index=index):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'phase|pre/post'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_real_key_ball_and_saturn_item_and_matching_art(self):
        for route, index, field, value in (('slide-ball', 4, 'held', 17),
                ('slide-ball', 12, 'held', 7), ('slide-ball', 1, 'art', 4408),
                ('saturn-column', 4, 'held', 21), ('saturn-column', 5, 'held', 3),
                ('saturn-column', 1, 'art', 2676)):
            with self.subTest(route=route, index=index, field=field):
                save, frames = self.frames(route)
                frames[index][field] = value
                with self.assertRaisesRegex(ValueError, 'ordered|art|held'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_ordered_authored_slide_hit_and_column_resources(self):
        for route, opened in (('slide-ball', (1420, 1400, 1401, 3310, 3360, 3361, 3330, 3344, 3425, 2676, 3215)),
                ('saturn-column', (3420, 3421, 2677, 2620, 2685, 2620)),
                ('saturn-column', (3420, 3426, 3421, 2677, 2620, 2685, 2620))):
            with self.subTest(route=route, opened=opened):
                save, frames = self.frames(route)
                with self.assertRaisesRegex(ValueError, 'authored scene'):
                    checker.verify(self.observed_log(route, save, frames, opened), save, route)

    def test_nonselected_extra_observation_still_enforces_retained_zeros_and_scope(self):
        for route in ('slide-ball', 'saturn-column'):
            for failure in ('retained', 'unmet', 'timer', 'scope'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    extra = dict(frames[0], scene=9998, art=9998, flags=dict(frames[0]['flags']))
                    if failure == 'retained':
                        extra['flags'][1958] = 0
                    elif failure == 'unmet':
                        extra['flags'][1961] = 1
                    elif failure == 'timer':
                        extra['flags'][1192] = 1
                    else:
                        extra['scope'] = '338-341,1000-1960,1962-2230'
                    frames.insert(1, extra)
                    with self.assertRaisesRegex(ValueError, 'prerequisite|unexpected post-key|every required'):
                        checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_final_clear_pair_and_valid_afternoon_diagnostics(self):
        for route in ('slide-ball', 'saturn-column'):
            for failure in ('held', 'gate', 'clock_scope'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'held':
                        frames[-1]['held'] = 3
                    elif failure == 'gate':
                        frames[-1]['clock'] = (2, 21, 0)
                    else:
                        frames[-1]['scope'] = '1000-2230'
                    with self.assertRaisesRegex(ValueError, 'safe|afternoon|clock'):
                        checker.verify(self.observed_log(route, save, frames), save, route)


class PostKeyRouteInputTests(unittest.TestCase):
    def test_exact_exercised_fragments_and_save_name_only_parameterization(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('post_key_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, count, anchor, menu_at, save_at in (
                (story.leg_slide_ball, 'm25', '997d7a93df511ef9225c2379d49637443b5497031de0aa96d1a7b73e94d2eae8',
                 159, 'S3510.CIF', 529000, 547000),
                (story.leg_saturn_column, 'm26', 'dc065ebbd5c903b602c40d265d0edecb10c4f8ff10842b8da00c0bb6f69ccfef',
                 143, 'HAL_SLIDE_ANIM.BIK', 158000, 176000)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                self.assertEqual(len(actual.split(';')), count)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'postkey')])
                self.assertEqual(leg(save='postkey'), expected)
                self.assertLess(count + 7, 512)


class DragonLightRouteTests(unittest.TestCase):
    prior = PostKeyRouteTests.prior | {1562, 1971, 1575, 1844, 2050, 1970, 1820, 2005}
    opens = {'dragon-passage': (3332, 3338, 3339, 3342, 3343, 3417, 3418, 2903, 3326),
             'glyph-request': (1216, 1217, 1280, 1281, 3585, 3513, 3562, 3513, 3522, 3510)}
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        save = Path(self.folder.name) / ('m27.SAV' if route == 'dragon-passage' else 'm28.SAV')
        save.write_bytes(bytes(170770))
        prior = set(self.prior)
        if route == 'dragon-passage':
            # Two pre-lever3332 frames occur before the distinct2078 rise.
            states = ((2620, 0), (3332, 0), (3332, 0), (3332, 0),
                      (3342, 0), (3343, 0), (3417, 0), (3418, 0), (3326, 0), (3326, 0))
            phases = {2078: 3, 1997: 4, 1925: 5, 1865: 5}
        else:
            prior |= {1997, 2078, 1925, 1865}
            states = ((3326, 0), (3510, 0), (3510, 4), (1217, 0),
                      (3585, 0), (3562, 0), (3513, 0), (3510, 4), (3510, 4))
            phases = {1791: 3, 1349: 4, 1418: 4, 1408: 4, 1361: 5, 1388: 5}
        frames = []
        for index, (scene, view) in enumerate(states):
            flags = {f: 1 for f in prior}
            flags.update({f: 1 for f, phase in phases.items() if index >= phase})
            frames.append({'scene': scene, 'art': scene, 'view': view, 'held': -1,
                           'flags': flags, 'scope': '338-341,1000-2230', 'clock': (2, 16, 30)})
        return save, frames

    def test_accepts_distinct_dragon_phases_and_only_pending_glyph_request(self):
        for route, final in (('dragon-passage', (3326, 0)), ('glyph-request', (3510, 4))):
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(route, save, frames), save, route)
                self.assertEqual((result['scene'], result['view']), final)
                self.assertTrue({2001, 1357, 1804} <= set(result['flags_zero']))
                if route == 'glyph-request':
                    self.assertTrue(result['glyph_pending'])
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))

    def test_requires_source_zeros_and_separate_early_lever_request_exit_phases(self):
        for route, index, flag, value in (('dragon-passage', 0, 1997, 1),
                ('dragon-passage', 3, 2078, 0), ('dragon-passage', 3, 1997, 1),
                ('dragon-passage', 5, 1865, 0), ('glyph-request', 0, 1408, 1),
                ('glyph-request', 3, 1349, 1), ('glyph-request', 4, 1361, 1),
                ('glyph-request', 5, 1388, 0)):
            with self.subTest(route=route, index=index, flag=flag):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaisesRegex(ValueError, 'ordered|phase|pre/post'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_refuses_false_glyph_or_light_reward_and_any_held_item(self):
        for field, value in (('2001', 1), ('1357', 1), ('1804', 1), ('held', 4)):
            with self.subTest(field=field):
                save, frames = self.frames('glyph-request')
                if field == 'held':
                    frames[-1]['held'] = value
                else:
                    frames[-1]['flags'][int(field)] = value
                with self.assertRaisesRegex(ValueError, 'unexpected|holds'):
                    checker.verify(self.observed_log('glyph-request', save, frames), save, 'glyph-request')

    def test_requires_exact_art_and_authored_win_darkness_rules_exit_resources(self):
        for route in ('dragon-passage', 'glyph-request'):
            for failure in ('art', 'resource'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    opened = list(self.opens[route])
                    if failure == 'art':
                        frames[4]['art'] = 4408
                    else:
                        opened.remove(3339 if route == 'dragon-passage' else 1281)
                    with self.assertRaisesRegex(ValueError, 'art|authored scene'):
                        checker.verify(self.observed_log(route, save, frames, opened), save, route)

    def test_extra_nonselected_frame_still_requires_scope_retained_and_failure_zeros(self):
        for route in ('dragon-passage', 'glyph-request'):
            for failure in ('retained', 'failure', 'scope'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    extra = dict(frames[0], scene=9998, art=9998, flags=dict(frames[0]['flags']))
                    if failure == 'retained':
                        extra['flags'][2005] = 0
                    elif failure == 'failure':
                        extra['flags'][2040] = 1
                    else:
                        extra['scope'] = '338-341,1000-1960,1962-2230'
                    frames.insert(1, extra)
                    with self.assertRaisesRegex(ValueError, 'prerequisite|unexpected|every required'):
                        checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_safe_final_pair_and_observed_clock_gate(self):
        for route in ('dragon-passage', 'glyph-request'):
            for failure in ('safe', 'gate', 'clock_scope'):
                with self.subTest(route=route, failure=failure):
                    save, frames = self.frames(route)
                    if failure == 'safe':
                        frames[-1]['view'] = 3
                    elif failure == 'gate':
                        frames[-1]['clock'] = (2, 21, 0)
                    else:
                        frames[-1]['scope'] = '1000-2230'
                    with self.assertRaisesRegex(ValueError, 'ordered|safe|clock'):
                        checker.verify(self.observed_log(route, save, frames), save, route)


class DragonLightRouteInputTests(unittest.TestCase):
    def test_exact_exercised_fragments_and_save_name_only_parameterization(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('dragon_light_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for leg, name, digest, count, anchor, menu_at, save_at in (
                (story.leg_dragon_passage, 'm27', 'e9b1b7ad2e9a91ddab83bae04b5393970b9237b0db6da640d5204ba4ed824a5a',
                 121, 'S2620.CIF', 262000, 280000),
                (story.leg_glyph_request, 'm28', '0944f1819901148f8e5dfde32777ddc97183ac88aef8a2a6dcbf868ce9dc4d7d',
                 106, 'S3585.CIF', 62000, 80000)):
            with self.subTest(save=name):
                actual = leg(save=name)
                self.assertEqual(hashlib.sha256((actual + '\n').encode()).hexdigest(), digest)
                self.assertEqual(len(actual.split(';')), count)
                expected = ';'.join([leg(), story.menu_to_save_screen(anchor, menu_at),
                                      story.save_tail(anchor, save_at, 'request')])
                self.assertEqual(leg(save='request'), expected)
                self.assertLess(count + 7, 512)


class GlyphWinRouteTests(unittest.TestCase):
    prior = DragonLightRouteTests.prior | {1997, 2078, 1925, 1865, 1349, 1408, 1791, 1361, 1388}
    opens = {'glyph-win': (3588, 1299, 1294, 1945, 3510)}
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, win_scene=1294):
        save = Path(self.folder.name) / 'm29.SAV'
        save.write_bytes(bytes(170770))
        states = ((3510, 4), (3588, 0), (win_scene, 0), (1945, 0),
                  (3510, 4), (3510, 4), (3510, 4))
        times = ((16, 32), (17, 0), (20, 30), (20, 32), (20, 33), (21, 0), (21, 1))
        frames = []
        for index, ((scene, view), (hour, minute)) in enumerate(zip(states, times)):
            flags = {f: 1 for f in self.prior}
            if index < 3:
                flags[1418] = 1
            if index >= 2:
                flags[2001] = 1
            if index >= 3:
                flags[1357] = 1
            frames.append({'scene': scene, 'art': scene, 'view': view, 'held': 4 if index == 4 else -1,
                           'flags': flags, 'scope': '338-341,1000-2230', 'clock': (2, hour, minute)})
        return save, frames

    def test_accepts_real_win_pickup4_and_late_clock_without_1299_state(self):
        for scene in (1294, 1295):
            with self.subTest(win_scene=scene):
                save, frames = self.frames(scene)
                log = self.observed_log('glyph-win', save, frames, (3588, 1299, scene, 1945, 3510))
                result = checker.verify(log, save, 'glyph-win')
                self.assertTrue(result['glyph_win'] and result['light_reward_earned'])
                self.assertIn(1418, result['flags_zero'])
                self.assertNotIn(1945, result['flags_one'])
                self.assertEqual(result['clock_diagnostics']['hour'], 21)

    def test_refuses_repeat_early_clear_false_reward_wrong_item_and_art(self):
        for index, field, value in ((0, 2001, 1), (0, 1357, 1), (1, 1418, 0),
                                   (2, 1357, 1), (3, 1357, 0), (4, 'held', 21), (2, 'art', 3588)):
            with self.subTest(index=index, field=field):
                save, frames = self.frames()
                if isinstance(field, int):
                    frames[index]['flags'][field] = value
                else:
                    frames[index][field] = value
                with self.assertRaisesRegex(ValueError, 'phase|reward|ordered|item|art'):
                    checker.verify(self.observed_log('glyph-win', save, frames), save, 'glyph-win')

    def test_requires_every_observation_scope_retained_zero_source_gate_opens_and_finish(self):
        for failure in ('scope', 'retained', 'later', 'source_clock', 'stop', 'win_resource', 'final_safe'):
            with self.subTest(failure=failure):
                save, frames = self.frames()
                opened = self.opens['glyph-win']
                if failure in ('scope', 'retained', 'later'):
                    extra = dict(frames[0], scene=9998, art=9998, flags=dict(frames[0]['flags']))
                    if failure == 'scope':
                        extra['scope'] = '338-341,1000-1803,1805-2230'
                    elif failure == 'retained':
                        extra['flags'][2005] = 0
                    else:
                        extra['flags'][1804] = 1
                    frames.insert(1, extra)
                elif failure == 'source_clock':
                    frames[0]['clock'] = (2, 15, 32)
                elif failure == 'win_resource':
                    opened = (3588, 1294, 1945, 3510)
                elif failure == 'final_safe':
                    frames[-1]['held'] = 4
                log = self.observed_log('glyph-win', save, frames, opened)
                if failure == 'stop':
                    log = log.replace('stop requested', 'message loop idle')
                with self.assertRaisesRegex(ValueError, 'required|prerequisite|unexpected|clock|authored|safe|requested stop'):
                    checker.verify(log, save, 'glyph-win')


class WordPrerequisiteRouteTests(unittest.TestCase):
    prior = GlyphWinRouteTests.prior | {2001, 1357}
    opens = {
        'lit-word-clue': (3332, 3338, 3339, 3342, 3343, 3498, 2902, 2910, 2942, 2964, 4375, 4389),
        'loulou-barber': (3058, 2903, 3326, 3334, 3335, 3440, 1502, 1503, 1506, 1552, 3335),
        'loulou-morning': (3335,),
        'drake-magic': (2332, 1000, 1067, 1068, 1071, 1092, 2332),
        'loulou-answer': (3334, 3335, 3336, 1500, 1556, 1557, 1558, 3335),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        stages = {
            'lit-word-clue': (30, ((3510, 4), (3332, 0), (3342, 0), (3343, 0), (2910, 0),
                                   (2942, 0), (2942, 0), (4389, 0), (4389, 0)),
                              {2041: 4, 2232: 6, 1818: 7, 1836: 7}),
            'loulou-barber': (31, ((4389, 0), (3058, 0), (3326, 0), (3334, 0), (1502, 0),
                                  (1503, 0), (1506, 0), (1552, 0), (3335, 0), (3335, 0)),
                              {1569: 4, 1467: 7}),
            'loulou-morning': (32, ((3335, 0), (3335, 0), (3335, 0)), {}),
            'drake-magic': (34, ((3335, 0), (2300, 3), (2300, 19), (2332, 0), (1000, 0),
                                (1067, 0), (1071, 0), (2332, 0), (2332, 0)), {1525: 5, 1526: 6}),
            'loulou-answer': (35, ((2332, 0), (3334, 0), (3336, 0), (1500, 0), (1558, 0),
                                  (3335, 0), (3335, 0)), {1465: 4, 1476: 4, 1774: 4}),
        }
        number, states, phases = stages[route]
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        retained = set(self.prior)
        if route in ('drake-magic', 'loulou-answer'):
            retained.add(1514)
        for name, (_, _, earlier) in stages.items():
            if name == route:
                break
            retained |= earlier.keys()
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in retained}
            flags.update({f: 1 for f, phase in phases.items() if i >= phase})
            art = 3440 if route == 'loulou-barber' and scene in (1502, 1503, 1506, 1552) else scene
            if route == 'loulou-answer' and scene in (1500, 1558):
                art = 3336
            held = 4 if ((route == 'lit-word-clue' and i >= 4) or
                         (route == 'loulou-barber' and i < 4)) else -1
            clock = {'lit-word-clue': (2, 16, 43 + i), 'loulou-barber': (2, 17, 3 + i),
                     'loulou-morning': (2, 17, 23) if i == 0 else (3, 8, 23 + i),
                     'drake-magic': (3, 8, 23 + i), 'loulou-answer': (3, 8, 41 + i)}[route]
            frames.append({'scene': scene, 'art': art, 'view': view, 'held': held,
                           'flags': flags, 'scope': '338-341,1000-2250', 'clock': clock})
        return save, frames

    def test_accepts_observed_prerequisite_phases_without_word_lock_win(self):
        for route in self.opens:
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(route, save, frames), save, route)
                self.assertFalse(result['word_lock_won'])
                self.assertTrue({1984, 2018, 1804, 2042} <= set(result['flags_zero']))
                self.assertEqual(1514 in result['flags_one'], route in ('drake-magic', 'loulou-answer'))
        self.assertNotIn(1475, result['flags_one'])
        self.assertNotIn(1479, result['flags_one'])

    def test_refuses_premature_or_missing_authored_progression(self):
        cases = (('lit-word-clue', 0, 1818, 1), ('lit-word-clue', 4, 2041, 0),
                 ('loulou-barber', 6, 1467, 1), ('loulou-barber', 4, 1569, 0),
                 ('drake-magic', 4, 1525, 1), ('drake-magic', 6, 1526, 0),
                 ('loulou-answer', 3, 1465, 1), ('loulou-answer', 4, 1476, 0))
        for route, index, flag, value in cases:
            with self.subTest(route=route, flag=flag, value=value):
                save, frames = self.frames(route)
                frames[index]['flags'][flag] = value
                with self.assertRaises(ValueError):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_refuses_wrong_light_dialogue_art_or_final_item(self):
        for route, index, field, value in (('lit-word-clue', -1, 'held', -1),
                ('loulou-barber', 0, 'held', -1), ('loulou-barber', 4, 'art', 1502),
                ('loulou-answer', 4, 'art', 1558), ('drake-magic', -1, 'held', 4)):
            with self.subTest(route=route, index=index, field=field):
                save, frames = self.frames(route)
                frames[index][field] = value
                with self.assertRaisesRegex(ValueError, 'held|light|art'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_rejects_nonselected_bad_observation_not_hidden_by_final_pair(self):
        for failure in ('scope', 'retained', 'word_win', 'timer', 'phase_backwards'):
            with self.subTest(failure=failure):
                route = 'loulou-answer'
                save, frames = self.frames(route)
                extra = dict(frames[4], scene=9998, art=9998, flags=dict(frames[4]['flags']))
                if failure == 'scope':
                    extra['scope'] = '338-341,1000-1513,1515-2250'
                elif failure == 'retained':
                    extra['flags'][2005] = 0
                elif failure == 'word_win':
                    extra['flags'][2018] = 1
                elif failure == 'timer':
                    extra['flags'][1192] = 1
                else:
                    extra['flags'][1465] = 0
                frames.insert(5, extra)
                with self.assertRaisesRegex(ValueError, 'required|retained|progression|monotone'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_source_gate_morning_arrival_and_monotone_clock(self):
        for failure in ('source', 'night_arrival', 'backwards', 'clock_scope'):
            with self.subTest(failure=failure):
                route = 'loulou-morning'
                save, frames = self.frames(route)
                if failure == 'source':
                    frames[0]['clock'] = (2, 21, 23)
                elif failure == 'night_arrival':
                    for frame in frames[1:]:
                        frame['clock'] = (3, 3, 30)
                elif failure == 'backwards':
                    frames[-1]['clock'] = (3, 8, 0)
                else:
                    frames[0]['scope'] = '338-340,1000-2250'
                with self.assertRaisesRegex(ValueError, 'clock|morning'):
                    checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_real_dialogue_opens_order_safe_pair_and_own_stop(self):
        for failure in ('drake_open', 'loulou_open', 'missing_answer', 'reordered', 'final_pair', 'stop'):
            with self.subTest(failure=failure):
                route = 'drake-magic' if failure == 'drake_open' else 'loulou-answer'
                save, frames = self.frames(route)
                opened = self.opens[route]
                if failure in ('drake_open', 'loulou_open'):
                    missing = 1068 if failure == 'drake_open' else 1556
                    opened = tuple(n for n in opened if n != missing)
                elif failure == 'missing_answer':
                    del frames[4]
                elif failure == 'reordered':
                    frames[3], frames[4] = frames[4], frames[3]
                elif failure == 'final_pair':
                    frames[-1]['scene'] = 3336
                log = self.observed_log(route, save, frames, opened)
                if failure == 'stop':
                    log = log.replace('stop requested', 'message loop idle')
                with self.assertRaisesRegex(ValueError, 'ordered|authored|safe|requested stop'):
                    checker.verify(log, save, route)


class WordPrerequisiteInputTests(unittest.TestCase):
    def test_retained_event_bodies_and_save_name_only_parameterization(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('word_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        expected = (
            ('lit_word_clue', 'm30', 189, 'ae4fdb574da6d1bdaeaa665db42cf581599f6bb57430958ce3e9a57c440b7d53'),
            ('loulou_barber', 'm31', 131, '8d3c38940e9c119ad08badfa403032099fbe1f23a35b80c21cebf97a7a53ef8d'),
            ('loulou_morning', 'm32', 26, '31fb45cf4e0053b0d3c09a1b1950c877de92482ce6504d8d33280573e9863830'),
            ('drake_magic', 'm34', 170, '4af23a6bde2483ffaf7961715f244e023948f01be238276803acd1a746fa3e33'),
            ('loulou_answer', 'm35', 131, '843e2597868c8fa1175ec041c30528125f1348b604439c2d54105ef83231103c'))
        for name, save, count, digest in expected:
            with self.subTest(leg=name):
                leg = getattr(story, 'leg_' + name)
                payload = leg(save)
                self.assertEqual(hashlib.sha256(payload.encode()).hexdigest(), digest)
                self.assertEqual(len(payload.split(';')), count)
                self.assertLessEqual(count, 512)
                self.assertTrue(payload.startswith(leg() + ';'))
                typed = leg(save + 'x')
                name_start = payload.index(':key:77')
                self.assertEqual(payload[:name_start], typed[:name_start])
                self.assertNotIn('key:88', payload)
                self.assertIn('key:88', typed)


class ReplacementWordLockTests(unittest.TestCase):
    prior = WordPrerequisiteRouteTests.prior | {1514, 1818, 1836, 2232, 1569, 1467,
                                               1525, 1526, 1465, 1476, 1774}
    opens = {
        'light-depletion': (2910, 3175, 3180, 3181, 2942, 3058, 2903, 3326, 3334, 3335),
        'paid-light-request': (3345, 3346, 3500, 3505, 3510, 1200, 1282, 1281, 3585, 3513, 3522, 3510),
        'repeat-glyph-win': (3588, 1299, 1295, 1949, 3510),
        'word-lock': (2910, 2942, 4375, 4389, 4376, 4377, 4378, 4379, 4380, 4387),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        states = {
            'light-depletion': ((3335, 0), (3332, 0), (3342, 0), (3343, 0), (2910, 0), (3175, 0),
                                (2912, 0), (2933, 0), (2933, 0), (2942, 0), (3058, 0), (3326, 0), (3335, 0), (3335, 0)),
            'paid-light-request': ((3335, 0), (3335, 0), (3335, 0), (3345, 0), (3346, 0), (3505, 0),
                                   (3510, 4), (1200, 0), (3585, 0), (3513, 0), (3510, 4), (3510, 4)),
            'repeat-glyph-win': ((3510, 4), (3588, 0), (1295, 0), (1949, 0), (3510, 4), (3510, 4), (3510, 4)),
            'word-lock': ((3510, 4), (3332, 0), (3342, 0), (3343, 0), (2910, 0), (2942, 0), (4376, 0),
                          (4377, 0), (4378, 0), (4379, 0), (4380, 0), (4387, 0), (4387, 0)),
        }[route]
        number = {'light-depletion': 36, 'paid-light-request': 37, 'repeat-glyph-win': 38, 'word-lock': 39}[route]
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        held = {'light-depletion': {4: 4, 5: 4, 6: 4, 7: 4}, 'paid-light-request': {1: 5},
                'repeat-glyph-win': {4: 4}, 'word-lock': {4: 4, 5: 4}}[route]
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in self.prior}
            if route == 'light-depletion':
                flags.update({1809: int(i >= 5), 2041: int(i < 6), 2042: int(6 <= i < 8)})
                minutes = 8*60 + 59 + i
            elif route == 'paid-light-request':
                flags.update({1809: 1, 1418: int(i >= 8)})
                minutes = 9*60 + 22 if i == 0 else 14*60 + 23 + i
            elif route == 'repeat-glyph-win':
                flags.update({1418: int(i < 3), 1809: int(i < 3)})
                minutes = 14*60 + 38 + i
            else:
                phases = {2041: 4, 1984: 7, 1967: 8, 1966: 9, 1977: 10, 2018: 11, 1979: 11}
                flags.update({f: int(i >= phase) for f, phase in phases.items()})
                minutes = 14*60 + 59 + i
            frames.append({'scene': scene, 'art': scene, 'view': view, 'held': held.get(i, -1),
                           'flags': flags, 'scope': '338-341,1000-2250', 'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_depletion_paid_used5_fresh_repeat_and_all_five_word_stages(self):
        for route in self.opens:
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(route, save, frames), save, route)
                self.assertEqual(result['word_lock_won'], route == 'word-lock')
                self.assertIn(2001, result['flags_one'])
                if route == 'word-lock':
                    self.assertTrue({1984, 1967, 1966, 1977, 2018, 1979} <= set(result['flags_one']))
                    self.assertIn(1972, result['flags_zero'])

    def test_refuses_false_phase_item_stage_extra_failure_missing_win_open_and_finish(self):
        cases = (('light-depletion', 0, 'flag', 1809, 1), ('light-depletion', 6, 'flag', 2042, 0),
                 ('light-depletion', 8, 'held', 0, 4), ('paid-light-request', 1, 'held', 0, -1),
                 ('paid-light-request', 7, 'flag', 1418, 1), ('repeat-glyph-win', 2, 'flag', 1809, 0),
                 ('repeat-glyph-win', 4, 'held', 0, 5), ('word-lock', 8, 'flag', 1984, 0),
                 ('word-lock', 11, 'flag', 1979, 0), ('word-lock', 6, 'art', 0, 4389))
        for route, index, field, flag, value in cases:
            with self.subTest(route=route, index=index, field=field, flag=flag):
                save, frames = self.frames(route)
                if field == 'flag':
                    frames[index]['flags'][flag] = value
                else:
                    frames[index][field] = value
                with self.assertRaises(ValueError):
                    checker.verify(self.observed_log(route, save, frames), save, route)
        for failure in ('extra', 'scope', 'win_open', 'source_clock', 'finish'):
            route = 'word-lock' if failure in ('extra', 'scope') else 'repeat-glyph-win'
            save, frames = self.frames(route)
            opened = self.opens[route]
            if failure in ('extra', 'scope'):
                extra = dict(frames[0], scene=9998, art=9998, flags=dict(frames[0]['flags']))
                if failure == 'extra':
                    extra['flags'][1972] = 1
                else:
                    extra['scope'] = '338-341,1000-1971,1973-2250'
                frames.insert(1, extra)
            elif failure == 'win_open':
                opened = (3588, 1295, 1949, 3510)
            elif failure == 'source_clock':
                frames[0]['clock'] = (3, 13, 38)
            log = self.observed_log(route, save, frames, opened)
            if failure == 'finish':
                log = log.replace('stop requested', 'message loop idle')
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(log, save, route)

    def test_exact_input_fragments_87_wheel_clicks_and_name_only_save_tail(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('word_lock_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        expected = (('light_depletion', 'm36', 238, 'b0274d785d13d95e1141120e6ec79ec956c1d3aca36ce869e55f1811e66f72c1'),
                    ('paid_light_request', 'm37', 98, 'ac5dc7bf051928d1317e78d6d7fe23dd38f0e683846f5d9b3850522a9c595060'),
                    ('word_lock', 'm39', 365, '740200c1bc5483eaf5efadb82197e03d8eecbb5a2ed0f3c918d129f5289115b7'))
        for name, save, count, digest in expected:
            leg = getattr(story, 'leg_' + name)
            payload = leg(save)
            self.assertEqual(hashlib.sha256(payload.encode()).hexdigest(), digest)
            self.assertEqual(len(payload.split(';')), count)
            self.assertLessEqual(count + 7, 512)
            self.assertTrue(payload.startswith(leg() + ';'))
            self.assertIn(':key:88', leg(save + 'x'))
        wheels = [event for event in story.leg_word_lock().split(';') if ':click:' in event and ',271,600' in event]
        self.assertEqual(len(wheels), 87)


class CrestPrerequisiteTests(unittest.TestCase):
    prior = ReplacementWordLockTests.prior | {2041, 1984, 1967, 1966, 1977, 2018, 1979}
    partial = {1150, 1154, 1156, 1157, 1158, 1808, 2060}
    opens = {
        'right-fire-panel': (4366, 2942, 3053, 2943, 2944, 2945, 3060, 3199, 3140, 3141, 3143, 3155, 3126, 3158),
        'ethel-interrogation': (3199, 3060, 2903, 3326, 3364, 1404, 1425, 1405, 1426, 1406, 1427, 1407, 1490, 1491, 3428),
        'linda-curse': (3350, 3351, 4400, 4405, 4410, 1100, 1128, 1129, 1130, 1131, 1132, 1146, 1133, 1191, 4408),
        'gargoyle-inspect': (4412, 4410, 4406, 4407, 3312, 3323, 3324, 3366, 3410),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        states = {
            'right-fire-panel': ((4387, 0), (2942, 0), (2943, 0), (2944, 0), (2945, 0), (3060, 0),
                                 (3199, 0), (3141, 0), (3141, 0), (3141, 0), (3141, 0), (3141, 0)),
            'ethel-interrogation': ((3141, 0), (3060, 0), (3326, 0), (1405, 0), (1406, 0), (1407, 0), (3428, 0), (3428, 0)),
            'linda-curse': ((3428, 0), (3318, 0), (3350, 0), (3351, 0), (4410, 3), (4412, 0), (4408, 0),
                            (1146, 0), (1133, 0), (4408, 0), (4408, 0)),
            'gargoyle-inspect': ((4408, 0), (4412, 0), (4410, 2), (4406, 0), (4407, 0), (3312, 0), (3323, 0),
                                 (3324, 0), (3366, 0), (3366, 0), (3410, 0), (3410, 0), (3410, 0)),
        }[route]
        number = {'right-fire-panel': 40, 'ethel-interrogation': 41, 'linda-curse': 42, 'gargoyle-inspect': 43}[route]
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        up = {'right-fire-panel': {1808: 7, 2060: 8, 1154: 8, 1150: 9, 1157: 9, 1156: 10, 1158: 10},
              'ethel-interrogation': {2154: 4}, 'linda-curse': {1492: 7}, 'gargoyle-inspect': {1786: 8, 1783: 10}}[route]
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in self.prior}
            if route != 'right-fire-panel':
                flags.update({f: 1 for f in self.partial})
            if route == 'linda-curse':
                flags[2154] = int(i == 0)
            if route == 'gargoyle-inspect':
                flags[1492] = 1
            flags.update({f: int(i >= phase) for f, phase in up.items()})
            if route == 'right-fire-panel':
                flags.update({1155: int(i == 7), 1159: int(7 <= i < 9)})
            held = 4 if ((route == 'right-fire-panel' and i > 0) or (route == 'ethel-interrogation' and i < 3)) else -1
            art = 4408 if route == 'linda-curse' and scene in (1146, 1133) else scene
            minutes = {'right-fire-panel': 15*60+19, 'ethel-interrogation': 15*60+26,
                       'linda-curse': 15*60+42, 'gargoyle-inspect': 15*60+58}[route] + i
            frames.append({'scene': scene, 'art': art, 'view': view, 'held': held, 'flags': flags,
                           'scope': '338-341,1000-2250', 'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_four_observed_chains_and_all_resource_authored_linda_byes(self):
        for route in self.opens:
            save, frames = self.frames(route)
            choices = (1190, 1191, 1192) if route == 'linda-curse' else (None,)
            for choice in choices:
                opened = tuple(choice if n == 1191 else n for n in self.opens[route]) if choice else self.opens[route]
                with self.subTest(route=route, bye=choice):
                    result = checker.verify(self.observed_log(route, save, frames, opened), save, route)
                    self.assertIn(2018, result['flags_one'])
                    self.assertIn(1972, result['flags_zero'])
                    self.assertIn(2059, result['flags_zero'])
                    self.assertNotIn(1491, result['flags_one'])
        # The3053 transition is required as a resource, not as a sampled frame.
        save, frames = self.frames('right-fire-panel')
        frames.insert(2, dict(frames[1], scene=3053, art=3053))
        checker.verify(self.observed_log('right-fire-panel', save, frames), save, 'right-fire-panel')

    def test_refuses_wrong_original_phase_false_unlock_bad_extra_scope_art_and_bye(self):
        for route, i, field, value in (('right-fire-panel', 9, 1150, 0), ('right-fire-panel', 8, 1155, 1),
                ('right-fire-panel', 10, 1972, 1), ('ethel-interrogation', 3, 2154, 1),
                ('linda-curse', 1, 2154, 1), ('linda-curse', 0, 1925, 0), ('linda-curse', 7, 1492, 0),
                ('gargoyle-inspect', 10, 1783, 0), ('gargoyle-inspect', 10, 1974, 1), ('gargoyle-inspect', 0, 2014, 1)):
            with self.subTest(route=route, index=i, flag=field):
                save, frames = self.frames(route)
                frames[i]['flags'][field] = value
                with self.assertRaises(ValueError):
                    checker.verify(self.observed_log(route, save, frames), save, route)
        for failure in ('extra_failure', 'scope', 'art', 'bad_bye', 'missing_door_resource', 'finish'):
            route = 'linda-curse'
            save, frames = self.frames(route)
            opened = self.opens[route]
            if failure in ('extra_failure', 'scope'):
                extra = dict(frames[1], scene=9998, art=9998, flags=dict(frames[1]['flags']))
                if failure == 'extra_failure':
                    extra['flags'][2059] = 1
                else:
                    extra['scope'] = '338-341,1000-2058,2060-2250'
                frames.insert(2, extra)
            elif failure == 'art':
                frames[7]['art'] = 1146
            elif failure == 'bad_bye':
                opened = tuple(1193 if n == 1191 else n for n in opened)
            elif failure == 'missing_door_resource':
                opened = tuple(n for n in opened if n != 1100)
            log = self.observed_log(route, save, frames, opened)
            if failure == 'finish':
                log = log.replace('stop requested', 'message loop idle')
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(log, save, route)

    def test_exact_static_inputs_and_retained_four_live_batches_without_manual_gap_joining(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('crest_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for name, save, count, digest in (('right_fire_panel', 'm40', 55, 'd040ede193f3c9ce54910b57f8f7d51b433f150e4a77bef501ae21a03f24ea00'),
                ('linda_curse', 'm42', 62, '82ee1e88a22cea6fabc3762ce285d9cfbf4025bba77b69b42749fc71189255e8'), ('gargoyle_inspect', 'm43', 65, '635123b5f1b24b07689479c0495daa161a56cbfba9ff2d6566730420be264ed5')):
            payload = getattr(story, 'leg_' + name)(save)
            self.assertEqual(hashlib.sha256(payload.encode()).hexdigest(), digest)
            self.assertEqual(len(payload.split(';')), count)
            self.assertTrue(payload.startswith(getattr(story, 'leg_' + name)() + ';'))
        payloads = (story.load_save_prefix() + ';' + story.leg_ethel_start(), story.ethel_curiosity_payload(),
                    story.ethel_bye_payload(), story.ethel_save_payload('m41'))
        self.assertEqual([len(payload.split(';')) for payload in payloads], [118, 3, 3, 22])
        for payload, digest in zip(payloads, ('34e4afcf69b99850aa21ad5c9461b1b4c8d4f46f839123f2552cb0edb7537a2f', '30110135be52304ce8ec01a42ec97971acadf4426811a81f3aa8073089a61ec9', 'bd5bdd22602916de35d53dcfc3b446fb89a9692552d97489784163a45ad0c262', '84d9ef531b4c568cbdd45fd84b7abb1b63f53fd1daf94bdc2160728f84dc10fa')):
            self.assertEqual(hashlib.sha256(payload.encode()).hexdigest(), digest)
        self.assertEqual(story.ethel_reload_payload(), 'S3428.CIF+12000:move:315,180;S3428.CIF+14000:shot:0,0')
        with self.assertRaisesRegex(ValueError, 'live prefix'):
            story.leg_ethel_start('m41')

    def test_ethel_readonly_preflight_and_reload_refuse_incomplete_wrong_item_or_flag(self):
        import struct
        from types import SimpleNamespace
        import sys
        tools = str(MODULE.parent)
        sys.path.insert(0, tools)
        try:
            import ethel_live as ethel
        finally:
            sys.path.remove(tools)
        _, one, zero = checker.crest_prerequisite_configuration('right-fire-panel')
        data = bytearray(170770)
        for value, offset in ((0, 0x9034), (4, 0x10e), (3141, 0x21642), (3141, 0x21646), (0, 0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one:
            struct.pack_into('<I', data, 0x1ee6 + 4*flag, 1)
        for fmt, offset, value in (('<I', 0x2430, 926), ('<H', 0x2434, 26), ('<H', 0x2436, 15), ('<H', 0x2438, 3)):
            struct.pack_into(fmt, data, offset, value)
        source = Path(self.folder.name) / 'synthetic.SAV'
        source.write_bytes(data)
        self.assertEqual(ethel.source_state(source)['held'], 4)
        for fmt, offset, value in (('<h', 0x9034, 2), ('<h', 0x10e, -1), ('<I', 0x1ee6 + 4*1150, 0),
                ('<I', 0x1ee6 + 4*2154, 1), ('<I', 0x1ee6 + 4*1972, 1)):
            changed = bytearray(data)
            struct.pack_into(fmt, changed, offset, value)
            source.write_bytes(changed)
            with self.assertRaises(ValueError):
                ethel.source_state(source)
        _, one, zero = checker.crest_prerequisite_configuration('ethel-interrogation')
        def observations():
            flags = {f: 1 for f in one}
            flags.update({338: 944 << 16, 339: 44 << 16, 340: (3 << 16) | 15, 341: 0})
            return [{'state': [3428, 3428, 0, -1], 'scope': ethel.rc_flags(), 'flags': dict(flags)} for _ in range(2)]
        ethel.verify_reload(SimpleNamespace(observations=observations()))
        for failure in ('incomplete', 'item', 'flag', 'scope'):
            frames = observations()
            if failure == 'incomplete':
                frames.pop()
            elif failure == 'item':
                frames[-1]['state'][3] = 4
            elif failure == 'flag':
                frames[0]['flags'][2154] = 0
            else:
                frames[0]['scope'] = '338-341,1000-2153,2155-2250'
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                ethel.verify_reload(SimpleNamespace(observations=frames))


class TypingCrestRouteTests(unittest.TestCase):
    prior = CrestPrerequisiteTests.prior | CrestPrerequisiteTests.partial | {1492, 1783, 1786}
    opens = {
        'corbin-portrait': (3410, 4112, 4108, 4109, 4110, 2619, 2616, 2605, 2627, 2629, 2741),
        'typing-crest': (1300, 1340, 1343, 4134, 4135, 4136, 4137, 4138, 4120, 4114, 4115, 4116, 4114, 6200),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        if route == 'corbin-portrait':
            states = ((3410, 0), (3311, 0), (3312, 0), (3313, 0), (2610, 0), (2611, 0), (2612, 0),
                      (2605, 5), (2615, 0), (2617, 0), (2618, 0), (4101, 0), (4112, 0),
                      (4108, 0), (4109, 0), (4110, 0), (2619, 0), (2616, 0), (2605, 12),
                      (2627, 0), (2629, 0), (2741, 0), (2741, 0))
            phases = {1863: 20}
            number = 45
        else:
            states = ((2741, 0), (2629, 0), (2605, 4), (4112, 0), (1300, 0), (1340, 0),
                      (1343, 0), (4138, 0), (4120, 0), (4114, 0), (4115, 0), (4116, 0),
                      (4114, 0), (6200, 0), (4114, 0), (4114, 0))
            phases = {2088: 5, 2014: 6}
            number = 47
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in self.prior}
            flags.update({f: int(i >= phase) for f, phase in phases.items()})
            if route == 'typing-crest':
                flags.update({1863: 1, 1672: int(i < 7)})
            minutes = (16*60 + 14 + i) if route == 'corbin-portrait' or i < 7 else (3*60 + 15 + i-7)
            frames.append({'scene': scene, 'art': scene, 'view': view, 'held': -1, 'flags': flags,
                           'scope': '338-341,1000-2250', 'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_portrait_and_firsttime_win_only_with_authored_reset_and_real_examination(self):
        for route in self.opens:
            save, frames = self.frames(route)
            result = checker.verify(self.observed_log(route, save, frames), save, route)
            self.assertEqual(result['typing_won'], route == 'typing-crest')
            self.assertIn(1687, result['flags_zero'])
            self.assertIn(1974, result['flags_zero'])
        self.assertIn(1672, result['flags_zero'])
        self.assertTrue({2014, 2088, 1863} <= set(result['flags_one']))

    def test_refuses_abandon_false_win_held2_wrong_reset_and_nonselected_bad_observation(self):
        for failure in ('abandon', 'early_win', 'held2', 'wrong_reset', 'early_reset', 'second_reset',
                        'no_reset', 'missing_examine', 'extra_failure', 'scope', 'stop'):
            save, frames = self.frames('typing-crest')
            opened = self.opens['typing-crest']
            if failure == 'abandon':
                frames[5]['flags'][1687] = 1
            elif failure == 'early_win':
                frames[0]['flags'][2014] = 1
            elif failure == 'held2':
                frames[13]['held'] = 2
            elif failure == 'wrong_reset':
                frames[7]['clock'] = (3, 3, 14)
            elif failure == 'early_reset':
                frames[5]['clock'] = (3, 3, 15)
            elif failure == 'second_reset':
                frames[-1]['clock'] = (3, 3, 15)
            elif failure == 'no_reset':
                for i, frame in enumerate(frames[7:]):
                    frame['clock'] = (3, 16, 21+i)
            elif failure == 'missing_examine':
                opened = tuple(n for n in opened if n != 6200)
            elif failure in ('extra_failure', 'scope'):
                extra = dict(frames[1], scene=9998, art=9998, flags=dict(frames[1]['flags']))
                if failure == 'extra_failure':
                    extra['flags'][1974] = 1
                else:
                    extra['scope'] = '338-341,1000-1973,1975-2250'
                frames.insert(2, extra)
            log = self.observed_log('typing-crest', save, frames, opened)
            if failure == 'stop':
                log = log.replace('stop requested', 'message loop idle')
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(log, save, 'typing-crest')

    def test_exact_shortcut_firstentry_and_proven_reward_payloads_without_abandoned_setup(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('typing_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        self.assertEqual(hashlib.sha256(story.leg_corbin_portrait('m45').encode()).hexdigest(), '3026b7fefff5623f9a602273ca7cd8dd9703a7ec6691038bc02447ddd75ac976')
        start = story.leg_typing_start()
        self.assertEqual(hashlib.sha256(start.encode()).hexdigest(), '49bc3112b416e2d56db84e6f1c3961ecc12a230dff42fb6821c065586d234775')
        self.assertEqual(len(start.split(';')), 48)
        self.assertNotIn(':click:605,32', start)
        with self.assertRaisesRegex(ValueError, 'live prefix'):
            story.leg_typing_start('m46')
        for name, digest in (('typing_continue_payload', 'd411c8b396438d35305bb2c8895fb65c8fa86e62713d206214f5cffb4c7560fe'), ('typing_pickup_payload', '0cbce1aa9f167836ef4f9f16bf9a285d39b613963536f2fe660c85a61a9eac43'),
                             ('typing_flip_bag_payload', '031c1290805da9a70d352c8731693e21cfc5bc42b11c042086e89e7bc07a5490'), ('typing_examine_payload', 'c1c1e66349cece940ca006db8958d074ce532f625a99b4ca5825bde8a0a51f75'),
                             ('typing_close_payload', 'ae7549a8bedf88f99ad0a4788f515ab8b8c6a44950cfc8b97ae2f22dcc6a27f4'), ('typing_reload_payload', '2b77a602391f281de1ae2dc46e5283eaf5114b89e9c387b31da9ae567cd48b6b')):
            self.assertEqual(hashlib.sha256(getattr(story, name)().encode()).hexdigest(), digest)


class OilRuneRouteTests(unittest.TestCase):
    prior = TypingCrestRouteTests.prior | {1863, 2014, 2088, 2062}
    opens = {
        'oil-gargoyle': (4106, 4398, 1900, 1902, 1903, 1904, 2619, 3366,
                         3401, 3402, 3403, 3404, 3405, 3367, 3406, 3415, 3416),
        'rune-passage': (3499, 2900, 2965, 2966, 2967, 2968, 3175, 3176, 2968,
                         3063, 3171, 3063, 3170, 3194, 3195, 3050),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        if route == 'oil-gargoyle':
            states = ((4114, 0), (4112, 0), (4108, 0), (4109, 0), (4106, 0), (1900, 0),
                      (2619, 0), (2616, 0), (2605, 19), (2606, 0), (2607, 0), (2608, 0),
                      (2609, 0), (3321, 0), (3322, 0), (3323, 0), (3324, 0), (3366, 0),
                      (3401, 0), (3402, 0), (3403, 0), (3404, 0), (3405, 0), (3367, 0),
                      (3416, 0), (3416, 0), (3416, 0))
            phases, number = {1944: 6, 1974: 24, 1877: 24}, 48
        else:
            states = ((3416, 0), (3171, 0), (3170, 0), (3170, 0), (3170, 0), (3170, 0),
                      (3170, 0), (3170, 0), (3195, 0), (3050, 0), (3050, 0))
            phases, number = {1864: 1, 2042: 1, 2081: 2, 2003: 8}, 49
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in self.prior}
            flags.update({f: int(i >= phase) for f, phase in phases.items()})
            if route == 'rune-passage':
                # Literal observed3175 flicker sound raises1809 before3171;
                # keep this independent of the checker's phase configuration.
                flags.update({1944: 1, 1974: 1, 1877: 1, 2041: int(i == 0), 1809: int(i > 0)})
            minutes = 3*60 + 17 + i
            frames.append({'scene': scene, 'art': scene, 'view': view,
                           'held': 4 if route == 'rune-passage' and i else -1,
                           'flags': flags, 'scope': '338-341,1000-2250',
                           'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_actual_oil_open_and_rune_win_with_retained_firsttime_state(self):
        for route, scene in (('oil-gargoyle', 3416), ('rune-passage', 3050)):
            save, frames = self.frames(route)
            result = checker.verify(self.observed_log(route, save, frames), save, route)
            self.assertEqual((result['scene'], result['view']), (scene, 0))
            self.assertEqual(result['rune_won'], route == 'rune-passage')
            self.assertTrue({1944, 1974, 1877, 2062, 2014, 2088} <= set(result['flags_one']))
            self.assertTrue({1672, 1687, 1972} <= set(result['flags_zero']))
            self.assertIn(1809, result['flags_one'] if route == 'rune-passage' else result['flags_zero'])
            self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))
            # No unexercised clock window is imposed on these two puzzle legs.
            for i, frame in enumerate(frames):
                frame['clock'] = (5, 4, i)
            checker.verify(self.observed_log(route, save, frames), save, route)

    def test_refuses_preexisting_or_reordered_oil_gargoyle_light_and_rune_phases(self):
        for route, index, flag, value in (
                ('oil-gargoyle', 0, 1944, 1), ('oil-gargoyle', 23, 1974, 1),
                ('oil-gargoyle', 24, 1877, 0), ('oil-gargoyle', 6, 2062, 0),
                ('rune-passage', 0, 1864, 1), ('rune-passage', 0, 1809, 1),
                ('rune-passage', 1, 1809, 0), ('rune-passage', 4, 1809, 0),
                ('rune-passage', 1, 2041, 1),
                ('rune-passage', 1, 2042, 0), ('rune-passage', 1, 2081, 1),
                ('rune-passage', 7, 2003, 1), ('rune-passage', 8, 2003, 0)):
            save, frames = self.frames(route)
            frames[index]['flags'][flag] = value
            with self.subTest(route=route, flag=flag, index=index), self.assertRaises(ValueError):
                checker.verify(self.observed_log(route, save, frames), save, route)

    def test_refuses_false_held_crest_missing_win_bad_extra_scope_or_clock_and_unsafe_end(self):
        for failure in ('held2', 'missing_light', 'art', 'view', 'win_open', 'flicker_open', 'safe_pair',
                        'extra_failure', 'extra_scope', 'clock_backwards', 'clock_scope', 'stop'):
            route = 'oil-gargoyle' if failure == 'held2' else 'rune-passage'
            save, frames = self.frames(route)
            opened = self.opens[route]
            if failure == 'held2':
                frames[18]['held'] = 2
            elif failure == 'missing_light':
                frames[1]['held'] = -1
            elif failure == 'art':
                frames[1]['art'] = 3416
            elif failure == 'view':
                frames[1]['view'] = 1
            elif failure == 'win_open':
                opened = tuple(s for s in opened if s != 3194)
            elif failure == 'flicker_open':
                opened = tuple(s for s in opened if s != 3175)
            elif failure == 'safe_pair':
                frames[-1]['held'] = -1
            elif failure in ('extra_failure', 'extra_scope'):
                extra = dict(frames[1], scene=9998, art=9998, flags=dict(frames[1]['flags']))
                if failure == 'extra_failure':
                    extra['flags'][1687] = 1
                else:
                    extra['scope'] = '338-341,1000-1973,1975-2250'
                frames.insert(2, extra)
            elif failure == 'clock_backwards':
                frames[-1]['clock'] = (3, 3, 15)
            elif failure == 'clock_scope':
                frames[1]['scope'] = '338-340,1000-2250'
            log = self.observed_log(route, save, frames, opened)
            if failure == 'stop':
                log = log.replace('stop requested', 'message loop idle')
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(log, save, route)

    def test_exact_exercised_oil_and_six_rune_inputs_with_parameterized_ui_save(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('oil_rune_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for function, name, size, digest, anchor, menu, tail in (
                (story.leg_oil_gargoyle, 'm48', 95, 'dd7910c200ad249c6ff3dabbb7490fee7ab1d33bef60a8378ea5edd026c3446b', 'S4114.CIF', 378000, 396000),
                (story.leg_rune_passage, 'm49', 59, '9793115d8a8c59f4d603b886d394da3b2b4c20cf2057f38ab01b0110e0fd7dd8', 'S3416.CIF', 154000, 172000)):
            body = function(name)
            self.assertEqual(hashlib.sha256(body.encode()).hexdigest(), digest)
            self.assertEqual(len(body.split(';')), size)
            self.assertEqual(function('x9'), ';'.join((function(), story.menu_to_save_screen(anchor, menu), story.save_tail(anchor, tail, 'x9'))))


class RuneLightRouteTests(unittest.TestCase):
    prior = (OilRuneRouteTests.prior - {2041}) | {1570, 1944, 1974, 1877, 1864, 2003, 2081}
    opens = {
        'rune-light-wait': (3021, 3022, 3023, 3024, 3025, 3067, 3048, 2901, 3311,
                            3312, 3313, 3314, 3315, 3316, 3317, 3334, 3335, 6200, 3335),
        'rune-light-replacement': (3318, 3319, 3320, 3321, 3322, 3323, 3324, 3305,
                                   3345, 3346, 3500, 3505, 3510, 1200, 1282, 1281, 3585,
                                   3588, 1299, 1295, 1949, 3510),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        if route == 'rune-light-wait':
            states = ((3050, 0), (3021, 0), (3022, 0), (3023, 0), (3024, 0), (3025, 0),
                      (3067, 0), (3048, 0), (3311, 0), (3312, 0), (3313, 0), (3314, 0),
                      (3315, 0), (3316, 0), (3317, 0), (3334, 0), (3335, 0), (3335, 0),
                      (3335, 0), (3335, 0), (3335, 0), (3335, 0))
            number = 50
        else:
            states = ((3335, 0), (3318, 0), (3319, 0), (3320, 0), (3321, 0), (3322, 0),
                      (3323, 0), (3324, 0), (3305, 0), (3345, 0), (3346, 0), (3505, 0),
                      (3510, 4), (1200, 0), (1200, 0), (1200, 0), (3585, 0),
                      (3588, 0), (1295, 0), (1949, 0), (3510, 4), (3510, 4), (3510, 4))
            number = 51
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        frames = []
        for i, (scene, view) in enumerate(states):
            flags = {f: 1 for f in self.prior}
            if route == 'rune-light-wait':
                # Literal actual source1,3311still1,3312clear before the wait.
                flags.update({2042: int(i < 8), 1514: int(i < 9), 1809: 1})
                held = 4 if i < 8 else 5 if i >= 18 else -1
                minutes = 222+i if i < 20 else 14*60+35+i-20
            else:
                flags.update({1514: 0, 1809: int(i < 19), 1418: int(16 <= i < 19)})
                held = 5 if i < 13 else 4 if i == 20 else -1
                minutes = 14*60+36+i
            frames.append({'scene': scene, 'art': scene, 'view': view, 'held': held, 'flags': flags,
                           'scope': '338-341,1000-2250', 'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_safe_used5_wait_and_direct_paid_fresh_light_without_abandonment(self):
        for route in self.opens:
            save, frames = self.frames(route)
            result = checker.verify(self.observed_log(route, save, frames), save, route)
            self.assertEqual(result['fresh_light_earned'], route == 'rune-light-replacement')
            self.assertIn(1514, result['flags_zero'])
            self.assertTrue({1864, 2003, 2081, 2014, 1974, 1570} <= set(result['flags_one']))
            self.assertTrue({1672, 1687, 1972, 2158} <= set(result['flags_zero']))

    def test_refuses_false_depletion_1514_phase_old_win_wrong_item_scope_or_door_clock(self):
        for failure in ('early1514', 'missing1514clear', 'missing2042clear', 'missing5', 'no_new1299',
                        'early_pending', 'pending_not_cleared', 'old1809', 'fake4', 'extra_failure', 'scope', 'door_clock'):
            route = 'rune-light-wait' if failure in ('early1514', 'missing1514clear', 'missing2042clear', 'missing5') else 'rune-light-replacement'
            save, frames = self.frames(route)
            opened = self.opens[route]
            if failure == 'early1514':
                frames[8]['flags'][1514] = 0
            elif failure == 'missing1514clear':
                frames[9]['flags'][1514] = 1
            elif failure == 'missing2042clear':
                frames[8]['flags'][2042] = 1
            elif failure == 'missing5':
                frames[18]['held'] = -1
            elif failure == 'no_new1299':
                opened = tuple(scene for scene in opened if scene != 1299)
            elif failure == 'early_pending':
                frames[0]['flags'][1418] = 1
            elif failure == 'pending_not_cleared':
                frames[19]['flags'][1418] = 1
            elif failure == 'old1809':
                frames[19]['flags'][1809] = 1
            elif failure == 'fake4':
                frames[20]['held'] = 5
            elif failure == 'extra_failure':
                extra = dict(frames[1], scene=9998, art=9998, flags=dict(frames[1]['flags']))
                extra['flags'][1972] = 1
                frames.insert(2, extra)
            elif failure == 'scope':
                frames[1]['scope'] = '338-341,1000-1569,1571-2250'
            elif failure == 'door_clock':
                for frame in frames:
                    frame['clock'] = (3, 13, 59)
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log(route, save, frames, opened), save, route)

    def test_preserves_wait_body_and_rebased_request_only_without_pending_exit_or_save(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('rune_light_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        body = story.leg_rune_light_wait('m50')
        self.assertEqual(hashlib.sha256((body+'\n').encode()).hexdigest(), '80cc9c24c48595e80d9fb936cc8940c83bb638338dbf3f4f7316ae9ce1ff6f11')
        self.assertEqual(len(body.split(';')), 84)
        self.assertIn('S3050.CIF+13082000:shot:0,0', body)
        start = story.leg_rune_light_start()
        self.assertEqual(hashlib.sha256(start.encode()).hexdigest(), '5b638d96f628e0004e17713a228fabc740d454c7178e5ac75bbccb21ebe343bd')
        self.assertEqual(len(start.split(';')), 57)
        self.assertIn('S3335.CIF+228000:click:150,399,600', start)
        self.assertNotIn(':click:310,355', start)
        with self.assertRaisesRegex(ValueError, 'live prefix'):
            story.leg_rune_light_start('m51')


class FireAlchemyEntryTests(unittest.TestCase):
    prior = (RuneLightRouteTests.prior - {1514, 1809, 2041}) | {1510, 1932, 1935}
    fire = set(range(1148, 1160)) | {1804, 1875, 1972, 2059}
    opens = {
        'fire-phosphorus': (3506, 3507, 3303, 3304, 3366, 3415, 3416, 3499, 2900, 2965, 2969, 3050, 3198,
                            3111, 3112, 3116, 3124, 3128, 2963, 3036, 3061, 3095, 3096, 3037),
        'moving-room-entry': (3037, 3056, 4300, 4302, 4303, 4301, 4304, 4305, 3046),
        'alchemy-snake-clue': (3190, 3046),
        'nigel-library': (3047, 3055, 4300, 4302, 4303, 4301, 4304, 4305, 3038, 2901,
                           3311, 3312, 2605, 4100, 4101, 4112),
        # Literal observed1392, independent of the permitted original variant set.
        'nigel-snake': (1300, 1371, 1392, 4112),
        'alchemy-return': (4399, 2619, 3366, 3415, 3416, 3499, 2900, 2969, 3050, 2963,
                           3036, 3037, 4300, 4302, 4303, 4301, 4304, 4305, 3046),
    }
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log

    def frames(self, route):
        prior = set(self.prior)
        if route == 'fire-phosphorus':
            scenes = (3510, 3401, 3402, 3403, 3404, 3405, 3367, 3416, 3198,
                      3111, 3111, 3111, 3111, 2963, 3096, 3096, 3037, 3037)
            phases = {1148: 10, 1155: 10, 2059: 10, 1149: 11, 1153: 11,
                      1151: 12, 1152: 13, 1159: 13, 1972: 13, 1804: 14, 1875: 14}
            rooms = (0,) * 18
            held = (-1,) * 8 + (4,) * 7 + (-1, 13, 13)
            number = 52
        else:
            prior |= self.fire
            if route == 'moving-room-entry':
                scenes = (3037, 3056, 4300, 4302, 4302, 4303, 4302, 4303, 4302, 3046, 3046)
                phases, rooms, number = {2073: 6, 1989: 9}, (0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2), 53
            else:
                prior |= {1989, 2073}
                if route == 'alchemy-snake-clue':
                    scenes, phases, rooms, number = (3046, 3190, 3046, 3046), {1922: 1}, (2,) * 4, 54
                else:
                    prior.add(1922)
                    if route == 'nigel-library':
                        scenes, phases, rooms, number = (3046, 4302, 4302, 3038, 4112, 4112), {1514: 4, 1672: 4}, (2, 3, 0, 0, 0, 0), 55
                    else:
                        prior |= {1514, 1672}
                        if route == 'nigel-snake':
                            scenes, phases, rooms, number = (4112, 1300, 1371, 1371, 4112, 4112), {1694: 2}, (0,) * 6, 56
                        else:
                            prior.add(1694)
                            scenes = (4112, 3401, 3402, 3403, 3404, 3405, 3367, 3416, 3056,
                                      4300, 4302, 4302, 4303, 4302, 4303, 4302, 3046, 3046)
                            phases, rooms, number = {}, (0,) * 13 + (1, 1, 2, 2, 2), 57
            if route in ('nigel-snake', 'alchemy-return'):
                prior |= {1563, 1679}
            held = ((13, -1, -1, -1, -1, -1) if route == 'nigel-snake' else
                    (-1,) * 8 + (13,) * 10 if route == 'alchemy-return' else (13,) * len(scenes))
        save = Path(self.folder.name) / ('m%d.SAV' % number)
        save.write_bytes(bytes(170770))
        frames = []
        for i, scene in enumerate(scenes):
            flags = {f: 1 for f in prior}
            flags.update({f: int(i >= phase) for f, phase in phases.items()})
            flags.update({1510+j: int(j == rooms[i]) for j in range(4)})
            if route == 'fire-phosphorus':
                flags[2041] = int(8 <= i < 14)
            # Literal retained m53/m57 pulse; m55's inverse passage follows
            # the same original4300 setter and3038 clearer.
            flags[2137] = int((number == 53 and 2 <= i < 9) or
                              (number == 55 and 1 <= i < 3) or
                              (number == 57 and 9 <= i < 16))
            minutes = 15*60 + i
            frames.append({'scene': scene, 'art': scene, 'view': 4 if i == 0 and number == 52 else 0,
                           'held': held[i], 'flags': flags, 'scope': '338-341,1000-2250',
                           'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_six_bounded_legs_without_claiming_alchemy_win(self):
        for route in self.opens:
            with self.subTest(route=route):
                save, frames = self.frames(route)
                result = checker.verify(self.observed_log(route, save, frames), save, route)
                self.assertFalse(result['alchemy_won'])
                self.assertEqual(result['alchemy_knowledge_ready'], route == 'alchemy-return')
                self.assertTrue({1932, 1935, 2014, 2003} <= set(result['flags_one']))
                self.assertTrue({1687, 1960, 2053, 2132} <= set(result['flags_zero']))
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))

    def test_requires_two_panel_win_retained_fire1514zero_and_effective_1875_phase(self):
        for index, flag, value in ((0, 1514, 1), (1, 1514, 1), (17, 1514, 1), (0, 1875, 1), (14, 1875, 0),
                                   (9, 2059, 1), (10, 1155, 0), (12, 1972, 1), (13, 1972, 0),
                                   (8, 2041, 0), (14, 2041, 1)):
            save, frames = self.frames('fire-phosphorus')
            frames[index]['flags'][flag] = value
            with self.subTest(index=index, flag=flag), self.assertRaises(ValueError):
                checker.verify(self.observed_log('fire-phosphorus', save, frames), save, 'fire-phosphorus')
        save, frames = self.frames('fire-phosphorus')
        for frame in frames:
            frame['clock'] = (3, 23, 0)
        # Clock alone cannot run a scene-local3312 action that was never loaded.
        checker.verify(self.observed_log('fire-phosphorus', save, frames), save, 'fire-phosphorus')

    def test_requires_original_room_turns_clue_and_nigel_knowledge(self):
        for route, index, updates in (
                ('moving-room-entry', 6, {1511: 0, 1512: 1}),
                ('moving-room-entry', 7, {1510: 1}),
                ('moving-room-entry', 6, {2073: 0}), ('moving-room-entry', 9, {1989: 0}),
                ('alchemy-snake-clue', 0, {1922: 1}), ('alchemy-snake-clue', 1, {1922: 0}),
                ('nigel-library', 1, {1513: 0, 1510: 1}), ('nigel-library', 4, {1672: 0}),
                ('nigel-library', 0, {1514: 1}), ('nigel-library', 3, {1514: 1}),
                ('nigel-library', 4, {1514: 0}),
                ('nigel-snake', 0, {1694: 1}), ('nigel-snake', 1, {1694: 1}),
                ('nigel-snake', 2, {1694: 0}), ('nigel-snake', 0, {1704: 1}),
                ('nigel-snake', 0, {1679: 0}), ('nigel-snake', 2, {1698: 1}),
                ('nigel-snake', 0, {1563: 0}), ('nigel-snake', 0, {1683: 1}),
                ('moving-room-entry', 0, {2137: 1}), ('moving-room-entry', 2, {2137: 0}),
                ('moving-room-entry', 8, {2137: 2}), ('moving-room-entry', 9, {2137: 1}),
                ('nigel-library', 0, {2137: 1}), ('nigel-library', 1, {2137: 0}),
                ('nigel-library', 3, {2137: 1}), ('alchemy-return', 8, {2137: 1}),
                ('alchemy-return', 9, {2137: 0}), ('alchemy-return', 16, {2137: 1})):
            save, frames = self.frames(route)
            frames[index]['flags'].update(updates)
            with self.subTest(route=route, index=index), self.assertRaises(ValueError):
                checker.verify(self.observed_log(route, save, frames), save, route)

    def test_requires_real13_safe_pair_scope_and_every_extra_observation(self):
        for failure in ('held', 'art', 'safe_pair', 'scope', 'extra_failure', 'extra_retained', 'missing_resource'):
            save, frames = self.frames('alchemy-return')
            opened = self.opens['alchemy-return']
            if failure == 'held':
                frames[8]['held'] = -1
            elif failure == 'art':
                frames[8]['art'] = 3046
            elif failure == 'safe_pair':
                frames[-1]['view'] = 1
            elif failure == 'missing_resource':
                opened = tuple(s for s in opened if s != 4301)
            else:
                extra = dict(frames[0], scene=9998, art=9998, flags=dict(frames[0]['flags']))
                if failure == 'scope':
                    extra['scope'] = '338-341,1000-1693,1695-2250'
                elif failure == 'extra_failure':
                    extra['flags'][2132] = 1
                else:
                    extra['flags'][1935] = 0
                frames.insert(1, extra)
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log('alchemy-return', save, frames, opened), save, 'alchemy-return')

    def test_accepts_original_bye_variants_and_refuses_other_voice_or_closed_npc_window(self):
        save, frames = self.frames('nigel-snake')
        for bye in (1390, 1391, 1392, 1393):
            checker.verify(self.observed_log('nigel-snake', save, frames, (1300, 1371, bye, 4112)), save, 'nigel-snake')
        with self.assertRaisesRegex(ValueError, 'authored scene'):
            checker.verify(self.observed_log('nigel-snake', save, frames, (1300, 1371, 1394, 4112)), save, 'nigel-snake')
        for route in ('nigel-library', 'nigel-snake'):
            save, frames = self.frames(route)
            for frame in frames:
                frame['clock'] = (3, 22, 0)
            with self.assertRaisesRegex(ValueError, 'presence window'):
                checker.verify(self.observed_log(route, save, frames), save, route)

    def test_exact_retained_fragments_explicit_daytime_delta_and_composed_ui_save(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('fire_alchemy_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        for function, name, size, digest, anchor, menu, tail in (
                (story.leg_fire_phosphorus, 'm52', 164, '638abfd09b637726f9ed3195cfc8070c17a8ad7e3cde9bcb6045804dce752018', 'S3510.CIF', 400000, 418000),
                (story.leg_moving_room_entry, 'm53', 53, '6ca877a6fadd76e78bb33e7d946f8a85bf85216296a40cafd3b2adade804dffe', 'S3037.CIF', 165000, 183000),
                (story.leg_alchemy_snake_clue, 'm54', 30, '5dafe1cbe30ea27b0932650de78ab43973e0db5cb1803b40eed228f3eaa6ace5', 'S3046.CIF', 67000, 85000),
                (story.leg_nigel_library, 'm55', 142, 'dd88c6cfb4e2c02103b00528160bbad83201a60508819cb9d536ad0f9429b852', 'S3046.CIF', 372500, 390500),
                (story.leg_nigel_snake, 'm56', 46, '592e58f4ef42bbedece6621cf6683c91f3908cc31026613bcf9f3d4fc4033566', 'S4112.CIF', 245000, 263000),
                (story.leg_alchemy_return, 'm57', 174, '32be847f405089c1b67dd462e0d4402aed4a038b4a4dc693538a81d0617e3771', 'S3037.CIF', 166000, 184000)):
            body = function(name)
            with self.subTest(route=function.__name__):
                self.assertEqual(hashlib.sha256((body+'\n').encode()).hexdigest(), digest)
                self.assertEqual(len(body.split(';')), size)
                self.assertEqual(function('x9'), ';'.join((function(), story.menu_to_save_screen(anchor, menu), story.save_tail(anchor, tail, 'x9'))))
        self.assertIn('S3046.CIF+289500:move:328,163', story.leg_nigel_library())
        self.assertIn('S4112.CIF+80000:move:150,459;S4112.CIF+81000:click:150,459,600', story.leg_nigel_snake())
        self.assertIn('S4112.CIF+185500:move:22,456;S4112.CIF+190000:shot:0,0', story.leg_nigel_snake())
        self.assertIn('S4112.CIF+200000:move:150,438;S4112.CIF+201000:click:150,438,600', story.leg_nigel_snake())


class AlchemyWinTests(unittest.TestCase):
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log
    opens = {'alchemy-win': (3190, 3196, 3193, 3054)}

    def frames(self):
        # Literal source phase from the prior public chapter; new phases below
        # are independent of the candidate checker's configuration.
        _, entry = FireAlchemyEntryTests.frames(self, 'alchemy-return')
        source = dict(entry[-1]['flags'])
        save = Path(self.folder.name) / 'm58.SAV'
        save.write_bytes(bytes(170770))
        frames = []
        for i, scene in enumerate((3046, 3046, 3196, 3196, 3196, 3196, 3196, 3054, 3054)):
            flags = dict(source)
            flags.update({1960: int(i >= 7), 2053: int(i >= 7), 2132: 0})
            frames.append({'scene': scene, 'art': scene, 'view': 0, 'held': 13,
                           'flags': flags, 'scope': '338-341,1000-2250',
                           'clock': (3, 16, 20+i)})
        return save, frames

    # The source fixture's helper accesses these literal earlier-stage sets.
    prior = FireAlchemyEntryTests.prior
    fire = FireAlchemyEntryTests.fire

    def test_accepts_new_alchemy_reward_and_safe_return_without_later_lab_rewards(self):
        save, frames = self.frames()
        result = checker.verify(self.observed_log('alchemy-win', save, frames), save, 'alchemy-win')
        self.assertEqual((result['scene'], result['view']), (3054, 0))
        self.assertTrue(result['alchemy_won'])
        self.assertTrue(result['alchemy_knowledge_ready'])
        self.assertTrue({1694, 1960, 2053} <= set(result['flags_one']))
        self.assertTrue({1959, 1973, 2004, 2017, 2052, 2132} <= set(result['flags_zero']))
        self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))

    def test_requires_new_win_instead_of_generic_finish_or_an_already_won_source(self):
        for phase, flag, value in ((0, 1960, 1), (0, 2053, 1), (2, 1960, 1),
                                   (7, 1960, 0), (8, 2053, 0), (8, 2132, 1)):
            save, frames = self.frames()
            frames[phase]['flags'][flag] = value
            with self.subTest(phase=phase, flag=flag), self.assertRaises(ValueError):
                checker.verify(self.observed_log('alchemy-win', save, frames), save, 'alchemy-win')

    def test_requires_all_recipe_observations_and_original_win_resource(self):
        for failure in ('missing_round', 'missing_win', 'wrong_order', 'explosion', 'bottom_exit'):
            save, frames = self.frames()
            opened = self.opens['alchemy-win']
            if failure == 'missing_round':
                frames.pop(5)
            elif failure == 'missing_win':
                opened = (3190, 3196, 3054)
            elif failure == 'wrong_order':
                opened = (3190, 3193, 3196, 3054)
            elif failure == 'explosion':
                opened = (3190, 3196, 3191, 3192, 6301, 3193, 3054)
            else:
                opened = (3190, 3196, 3049, 3046, 3193, 3054)
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log('alchemy-win', save, frames, opened), save, 'alchemy-win')

    def test_checks_extra_observations_real_item_full_scope_and_retained_flags(self):
        for field, value in (('held', -1), ('art', 3046), ('scope', '338-341,1000-1693,1695-2250'),
                             (1694, 0), (1510, 1), (1959, 1), (2132, 1), (1960, 2)):
            save, frames = self.frames()
            extra = dict(frames[2], scene=9998, art=9998, flags=dict(frames[2]['flags']))
            if isinstance(field, int):
                extra['flags'][field] = value
            else:
                extra[field] = value
            frames.insert(3, extra)
            with self.subTest(field=field), self.assertRaises(ValueError):
                checker.verify(self.observed_log('alchemy-win', save, frames), save, 'alchemy-win')

    def test_requires_final_safe_pair_and_valid_clock_but_no_nigel_time_window(self):
        for failure in ('safe_scene', 'safe_view', 'backwards_clock', 'clock_scope'):
            save, frames = self.frames()
            if failure == 'safe_scene':
                frames[-1]['scene'] = frames[-1]['art'] = 3046
            elif failure == 'safe_view':
                frames[-1]['view'] = 1
            elif failure == 'backwards_clock':
                frames[-1]['clock'] = (3, 16, 0)
            else:
                frames[-1]['scope'] = '338-340,1000-2250'
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log('alchemy-win', save, frames), save, 'alchemy-win')
        save, frames = self.frames()
        for frame in frames:
            frame['clock'] = (3, 23, 0)
        checker.verify(self.observed_log('alchemy-win', save, frames), save, 'alchemy-win')

    def test_exact_exercised_continuous_body_and_only_parameterized_save_tail(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('alchemy_win_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(story)
        self.assertTrue(hasattr(story, 'leg_alchemy_win'), 'missing alchemy-win ordinary input route')
        body = story.leg_alchemy_win('s63')
        self.assertEqual(hashlib.sha256((body+'\n').encode()).hexdigest(),
                         '2ea235e3436451f1e67e01dd058496c40a36eb3ed6a65ae89465f875e589fa32')
        self.assertEqual(len(body.split(';')), 71)
        self.assertEqual(story.leg_alchemy_win('m58'), ';'.join((story.leg_alchemy_win(),
                         story.menu_to_save_screen('S3196.CIF', 153000),
                         story.save_tail('S3196.CIF', 171000, 'm58'))))
        # Three distinct releases on key10 in round2 must remain three strokes.
        for offset in (49000, 52000, 55000):
            self.assertIn('S3196.CIF+%d:click:156,236,600' % offset, body)



class LabMouldTests(unittest.TestCase):
    setUp = PostKeyRouteTests.setUp
    observed_log = PostKeyRouteTests.observed_log
    opens = {'lab-entry': (2908, 3800, 3804),
             'mould-shape': (3805, 3808, 3803, 3801, 3803)}
    retained = set(range(1148, 1160)) | {1512, 1514, 1694, 1804, 1922, 1960,
                    1875, 1972, 1989, 2003, 2014, 2018, 2053, 2059, 2156, 2159}
    # Historical23 strokes, followed by the effective-resource2163 correction.
    order = (2147, 2148, 2149, 2151, 2162, 2164, 2165, 2167, 2170, 2172, 2173,
             2176, 2178, 2179, 2181, 2182, 2183, 2185, 2186, 2187, 2189, 2190, 2191, 2163)

    def frames(self, route):
        scenes = ((3054, 3804, 3804, 3804) if route == 'lab-entry' else
                  (3804, 3805, 3808, 3803) + (3801,)*27 + (3803,)*2)
        save = Path(self.folder.name) / ('m59.SAV' if route == 'lab-entry' else 'm60.SAV')
        save.write_bytes(bytes(170770))
        frames = []
        for i, scene in enumerate(scenes):
            flags = {f: 1 for f in self.retained}
            if route == 'mould-shape':
                flags.update({1876: int(i >= 2), 1888: int(i >= 4), 2234: int(i >= 6)})
                flags.update({f: int(i >= 6+j) for j, f in enumerate(self.order)})
            minutes = 16*60+29+i
            frames.append({'scene': scene, 'art': scene, 'view': 0, 'held': 13,
                           'flags': flags, 'scope': '338-341,1000-2250',
                           'clock': (3, minutes//60, minutes%60)})
        return save, frames

    def test_accepts_serial_lab_and_corrected_mould_without_aeolus_or_forge_claim(self):
        for route, final in (('lab-entry', 3804), ('mould-shape', 3803)):
            save, frames = self.frames(route)
            result = checker.verify(self.observed_log(route, save, frames), save, route)
            with self.subTest(route=route):
                self.assertEqual((result['scene'], result['view']), (final, 0))
                self.assertTrue(result['alchemy_won'])
                self.assertEqual(result['mould_prepared'], route == 'mould-shape')
                self.assertTrue({1959, 1965, 1973, 1999, 2004, 2017, 2052} <= set(result['flags_zero']))
                self.assertFalse(set(range(338, 342)) & (set(result['flags_one']) | set(result['flags_zero'])))
        self.assertTrue(set(self.order) <= set(result['flags_one']))
        self.assertNotIn(2163, result['flags_zero'])
        self.assertEqual(len(set(self.order)), 24)

    def test_requires_empty_source_every_authored_bar_and_explicit_new2163_phase(self):
        for index, flag, value in ((0, 2147, 1), (5, 2163, 1), (6, 2147, 0),
                (8, 2149, 0), (28, 2191, 0), (28, 2163, 1), (29, 2163, 0),
                (32, 2163, 0), (20, 2150, 1), (32, 2192, 1), (7, 2147, 0)):
            save, frames = self.frames('mould-shape')
            frames[index]['flags'][flag] = value
            with self.subTest(index=index, flag=flag), self.assertRaises(ValueError):
                checker.verify(self.observed_log('mould-shape', save, frames), save, 'mould-shape')
        save, frames = self.frames('lab-entry')
        frames[-1]['flags'][2163] = 1
        with self.assertRaises(ValueError):
            checker.verify(self.observed_log('lab-entry', save, frames), save, 'lab-entry')

    def test_requires_original_lab_observation_feedback_and_pending_future_gates(self):
        for index, flag, value in ((0, 1876, 1), (2, 1876, 0), (3, 1888, 1),
                (4, 1888, 0), (5, 2234, 1), (6, 2234, 0), (30, 1959, 1),
                (31, 1973, 1), (32, 2004, 1), (32, 1098, 1), (32, 2067, 1)):
            save, frames = self.frames('mould-shape')
            frames[index]['flags'][flag] = value
            with self.subTest(index=index, flag=flag), self.assertRaises(ValueError):
                checker.verify(self.observed_log('mould-shape', save, frames), save, 'mould-shape')

    def test_requires_ordered_resources_all_bar_captures_and_actual_safe_final_pair(self):
        for failure in ('missing_resource', 'wrong_order', 'missing_correction_capture', 'safe_pair'):
            save, frames = self.frames('mould-shape');opened = self.opens['mould-shape']
            if failure == 'missing_resource':
                opened = (3805, 3803, 3801, 3803)
            elif failure == 'wrong_order':
                opened = (3805, 3803, 3808, 3801, 3803)
            elif failure == 'missing_correction_capture':
                frames.pop(29)
            else:
                frames[-1]['scene'] = frames[-1]['art'] = 3801
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log('mould-shape', save, frames, opened), save, 'mould-shape')

    def test_extra_observations_enforce_scope_prerequisites_real13_and_clock(self):
        for failure in ('scope', 'held', 'art', 'retained', 'future', 'local_binary', 'clock'):
            save, frames = self.frames('mould-shape')
            extra = dict(frames[2], scene=9998, art=9998, flags=dict(frames[2]['flags']))
            if failure == 'scope': extra['scope'] = '338-341,1000-2162,2164-2250'
            elif failure == 'held': extra['held'] = -1
            elif failure == 'art': extra['art'] = 3801
            elif failure == 'retained': extra['flags'][1960] = 0
            elif failure == 'future': extra['flags'][2004] = 1
            elif failure == 'local_binary': extra['flags'][1005] = 2
            else: extra['clock'] = (3, 16, 0)
            frames.insert(3, extra)
            with self.subTest(failure=failure), self.assertRaises(ValueError):
                checker.verify(self.observed_log('mould-shape', save, frames), save, 'mould-shape')

    def test_retained_continuous_inputs_have_only_save_name_and_one_sourced_bar_delta(self):
        import hashlib
        spec = importlib.util.spec_from_file_location('lab_mould_story', MODULE.with_name('story_route.py'))
        story = importlib.util.module_from_spec(spec);spec.loader.exec_module(story)
        self.assertTrue(hasattr(story, 'leg_lab_entry'), 'missing ordinary lab-entry route')
        self.assertTrue(hasattr(story, 'leg_mould_shape'), 'missing ordinary mould-shape route')
        self.assertEqual(hashlib.sha256((story.leg_lab_entry('s64')+'\n').encode()).hexdigest(),
                         'd6205060273a97b15b455f9159604a808e74b9f089ec414848ee8329c28e9769')
        body = story.leg_mould_shape('s65')
        correction = ('S3801.CIF+192000:move:325,76', 'S3801.CIF+193000:click:325,76,600',
                      'S3801.CIF+195500:shot:0,0')
        tokens = body.split(';')
        for token in correction:
            self.assertEqual(tokens.count(token), 1)
            tokens.remove(token)
        self.assertEqual(hashlib.sha256((';'.join(tokens)+'\n').encode()).hexdigest(),
                         '318a2ec5fb0f19275ab2d33dc59f7134def432df585a1d98451c4f7d2e19b36c')
        for function, save, anchor, menu, tail in (
                (story.leg_lab_entry, 'm59', 'S3054.CIF', 75000, 93000),
                (story.leg_mould_shape, 'm60', 'S3801.CIF', 235000, 253000)):
            self.assertEqual(function(save), ';'.join((function(), story.menu_to_save_screen(anchor, menu),
                                                       story.save_tail(anchor, tail, save))))


if __name__ == '__main__':
    unittest.main()
