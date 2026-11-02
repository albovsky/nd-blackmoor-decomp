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


if __name__ == '__main__':
    unittest.main()
