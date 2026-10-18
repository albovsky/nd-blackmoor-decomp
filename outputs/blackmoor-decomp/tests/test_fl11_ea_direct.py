"""FL-11: direct tests of the static helpers of the raw 0xea Onebuild puzzle kernel.

tests/fl11_ea_direct_test.c includes src/action_family_ea_runtime.c and calls each helper itself; this module builds it
and checks one PASS line per original function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl11_ea_direct_test.c'


def compiler():
    # Same convention as tests/test_action_family_eb_runtime.py: xcrun is only for the macOS build scripts.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def build(output, test_c=TEST_C, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', f'-I{src_dir}',
           str(test_c), '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl11EaDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        binary = Path(cls.tmp.name) / 'fl11_ea_direct'
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

    def test_translate_0x4841cb(self):
        """FL-11: direct test of translate (original 0x4841cb)."""
        self.check('translate')

    def test_piece_init_0x48421e(self):
        """FL-11: direct test of piece_init (original 0x48421e)."""
        self.check('piece_init')

    def test_set_layer_0x484935(self):
        """FL-11: direct test of set_layer (original 0x484935)."""
        self.check('set_layer')

    def test_clamp_rect_0x484caf(self):
        """FL-11: direct test of clamp_rect (original 0x484caf)."""
        self.check('clamp_rect')

    def test_follow_pointer_0x484d87(self):
        """FL-11: direct test of follow_pointer (original 0x484d87)."""
        self.check('follow_pointer')

    def test_rotate_piece_0x4853b0(self):
        """FL-11: direct test of rotate_piece (original 0x4853b0)."""
        self.check('rotate_piece')

    def test_inside_area_0x4866b4(self):
        """FL-11: direct test of inside_area (original 0x4866b4)."""
        self.check('inside_area')

    def test_check_solved_0x486725(self):
        """FL-11: direct test of check_solved (original 0x486725)."""
        self.check('check_solved')

    def test_all_cases_ran_and_exit_zero(self):
        """FL-11: every direct case printed a result and the binary exited 0."""
        self.assertEqual(len(self.results), 8)
        self.assertEqual(self.code, 0)


if __name__ == '__main__':
    unittest.main()
