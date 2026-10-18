"""FL-13: direct tests of the raw 0xea Onebuild puzzle kernel helpers that FL-11 rejected as merged.

tests/fl13_ea_direct_test.c includes src/action_family_ea_runtime.c and calls each per-original wrapper itself; this
module builds it and checks one PASS line per original function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl13_ea_direct_test.c'


def compiler():
    # Same convention as tests/test_fl11_ea_direct.py: xcrun is only for the macOS build scripts.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def build(output, test_c=TEST_C, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', f'-I{src_dir}',
           str(test_c), '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl13EaDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        binary = Path(cls.tmp.name) / 'fl13_ea_direct'
        built = build(binary)
        assert built.returncode == 0, built.stderr
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
        cls.code = done.returncode
        cls.results = {}
        for line in done.stdout.splitlines():
            status, _, rest = line.partition(' ')
            if status in ('PASS', 'FAIL'):
                name, _, message = rest.partition(': ')
                cls.results[name] = (status, message)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def check(self, name):
        self.assertIn(name, self.results)
        status, message = self.results[name]
        self.assertEqual(status, 'PASS', message)

    def test_top_piece_placed_0x484622(self):
        """FL-13: direct test of top_piece_placed (original 0x484622)."""
        self.check('top_piece_placed')

    def test_top_piece_unplaced_0x4846c2(self):
        """FL-13: direct test of top_piece_unplaced (original 0x4846c2)."""
        self.check('top_piece_unplaced')

    def test_pick_sound_0x485ca1(self):
        """FL-13: direct test of pick_sound (original 0x485ca1)."""
        self.check('pick_sound')

    def test_drop_sound_0x485d52(self):
        """FL-13: direct test of drop_sound (original 0x485d52)."""
        self.check('drop_sound')

    def test_rotate_sound_0x485f12(self):
        """FL-13: direct test of rotate_sound (original 0x485f12)."""
        self.check('rotate_sound')

    def test_bad_drop_feedback_0x485fb6(self):
        """FL-13: direct test of bad_drop_feedback (original 0x485fb6)."""
        self.check('bad_drop_feedback')

    def test_good_drop_feedback_0x48633c(self):
        """FL-13: direct test of good_drop_feedback (original 0x48633c)."""
        self.check('good_drop_feedback')

    def test_all_cases_ran_and_exit_zero(self):
        """FL-13: every direct case printed a result and the binary exited 0."""
        self.assertEqual(len(self.results), 7)
        self.assertEqual(self.code, 0)


if __name__ == '__main__':
    unittest.main()
