"""Finite Senior input/profile checks; no native, OCR child, original assets or game."""
import copy
import hashlib
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import bul_live as io
import check_route
import typing_keycycle as senior
import typing_live as typing
sys.path.pop(0)


class SeniorTypingTests(unittest.TestCase):
    def test_exact_exercised_cycle_and_case_digit_question_key_semantics(self):
        self.assertEqual(io.digest(senior.CYCLE_PATH), '1487a40ffe72c92188d11559f90d322678a8d2e1e7bc53e946bcda69acb75179')
        steps = senior.payload().split(';')
        self.assertEqual((len(steps), steps[0], steps[-1]), (68, '1:keyup:16', '3351:shot:0,0'))
        keys = [int(s.rsplit(':', 1)[1]) for s in steps if ':key:' in s]
        self.assertEqual(keys, list(range(65, 91)) + list(range(48, 58)) + [190] + list(range(65, 91)) + [191])
        self.assertEqual([s for s in steps if 'keydown' in s or 'keyup' in s],
                         ['1:keyup:16', '1931:keydown:16', '3271:keyup:16'])
        self.assertEqual(senior.MAX_CYCLES, 24)

    def test_bound_senior_profile_refuses_wrong_identity_or_clock(self):
        profile = {'name':'senior', 'difficulty':2, 'source_sha256':'a'*64,
                   'clock':{'day':3, 'hour':8, 'minute':39, 'total_minutes':519}}
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder) / 'profile.json'
            for change in ('valid', 'mode', 'hash', 'clock'):
                value = copy.deepcopy(profile)
                if change == 'mode': value['difficulty'] = 0
                elif change == 'hash': value['source_sha256'] = 'b'*64
                elif change == 'clock': value['clock']['total_minutes'] = 1
                p.write_text(json.dumps(value))
                if change == 'valid':
                    self.assertEqual(senior.load_profile(p, io.digest(p), 'a'*64), profile)
                else:
                    with self.subTest(change=change), self.assertRaises(ValueError):
                        senior.load_profile(p, io.digest(p), 'a'*64)

    def test_explicit_senior_source_clock_does_not_relax_default_junior(self):
        _, one, _ = check_route.typing_crest_configuration('corbin-portrait')
        data = bytearray(170770)
        for value, offset in ((2,0x9034),(-1,0x10e),(2741,0x21642),(2741,0x21646),(0,0x215d2)):
            struct.pack_into('<h', data, offset, value)
        for flag in one | {1672}: struct.pack_into('<I', data, 0x1ee6+4*flag, 1)
        clock = {'day':3, 'hour':8, 'minute':39, 'total_minutes':519}
        for fmt, offset, key in (('<I',0x2430,'total_minutes'),('<H',0x2434,'minute'),('<H',0x2436,'hour'),('<H',0x2438,'day')):
            struct.pack_into(fmt, data, offset, clock[key])
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder) / 'synthetic.SAV'; p.write_bytes(data)
            with self.assertRaisesRegex(ValueError, 'first-time Junior'): typing.source_state(p)
            self.assertEqual(typing.source_state(p, 2, clock)['difficulty'], 2)
            wrong = dict(clock, minute=40, total_minutes=520)
            with self.assertRaises(ValueError): typing.source_state(p, 2, wrong)
            struct.pack_into('<I', data, 0x2ba+8, 1); p.write_bytes(data)
            with self.assertRaises(ValueError): typing.source_state(p, 2, clock)

    def test_full_original_timer_and_new1343_are_required_without_score_reads(self):
        def log(elapsed):
            return ('FILE open C:\\GAME\\Ciftree\\S1340.CIF  [virtual 1000 ms]\n'
                    f'FILE open C:\\GAME\\Ciftree\\S1343.CIF  [virtual {1000+elapsed} ms]\n')
        senior.check_full_quiz(log(60000))
        for value in (59999, 0):
            with self.subTest(value=value), self.assertRaises(ValueError): senior.check_full_quiz(log(value))
        with self.assertRaises(ValueError): senior.check_full_quiz('')


    def test_checker_clock_binding_is_explicit_senior_only_and_keeps_the_authored_reset(self):
        import test_recomp_route_check as routes
        fixture = routes.TypingCrestRouteTests()
        fixture.setUp(); self.addCleanup(fixture.doCleanups)
        save, frames = fixture.frames('typing-crest')
        data = bytearray(save.read_bytes()); struct.pack_into('<h', data, 0x9034, 2); save.write_bytes(data)
        for index in range(7): frames[index]['clock'] = (3, 8, 39+index)
        log = fixture.observed_log('typing-crest', save, frames)
        bound = {'day':3, 'hour':8, 'minute':39, 'total_minutes':519}
        self.assertEqual(check_route.verify(log, save, 'typing-crest', typing_source_clock=bound)['scene'], 4114)
        with self.assertRaisesRegex(ValueError, 'source clock'): check_route.verify(log, save, 'typing-crest')
        with self.assertRaisesRegex(ValueError, 'source clock'):
            check_route.verify(log, save, 'typing-crest', typing_source_clock=dict(bound, hour=9, total_minutes=579))
        struct.pack_into('<h', data, 0x9034, 0); save.write_bytes(data)
        with self.assertRaisesRegex(ValueError, 'Senior'):
            check_route.verify(log, save, 'typing-crest', typing_source_clock=bound)

    def test_explicit_senior_cli_needs_its_profile_and_does_not_require_ocr_inputs(self):
        from unittest.mock import patch
        argv = []
        for name in ('native', 'game-exe', 'game-data', 'source-save', 'source-profile'):
            argv += ['--' + name, name]
        for name in ('native-sha256', 'save-sha256', 'source-profile-sha256'):
            argv += ['--' + name, 'a'*64]
        args = typing.argument_parser('senior').parse_args(argv + ['--profile', 'senior'])
        self.assertIsNone(args.ocr_tool)
        self.assertEqual(args.profile, 'senior')
        with self.assertRaises(SystemExit), patch('sys.stderr'):
            typing.argument_parser().parse_args(argv)


if __name__ == '__main__': unittest.main()
