"""FL-24 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl24a.c.

tests/fl24a_direct_test.c links src/original_methods_fl24a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl24a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl24a_direct_test.c'
KERNELS = ['original_methods_fl24a.c']
EXPECTED = [
    'test_m4d3bef_reset_flags',
    'test_m44edfb_click_2785_2787',
    'test_m4cb3ab_store_flag',
    'test_m44eab1_hit_test',
    'test_m46ebff_click_27c2_27c3',
    'test_m4571e1_hit_test',
    'test_m47b4aa_hit_test',
    'test_m4a6574_hit_test',
    'test_m465c99_hit_test',
    'test_m482724_click_27b5_27b6',
    'test_m470ffe_hit_test',
]


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


def build(output, test_c=TEST_C, src_dir=SRC, extra=()):
    cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-ffp-contract=off', '-g', *extra, f'-I{src_dir}', str(test_c),
           *[str(src_dir / name) for name in KERNELS], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl24aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl24a_direct_test'
        built = build(binary)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
        cls.returncode = done.returncode
        cls.results = {}
        for line in done.stdout.splitlines():
            status, _, rest = line.partition(' ')
            if status in ('PASS', 'FAIL'):
                name, _, message = rest.partition(': ')
                cls.results[name] = (status, message)

    def check(self, name):
        self.assertIn(name, self.results)
        self.assertEqual(self.results[name], ('PASS', ''), self.results[name])

    def test_every_case_ran_and_the_binary_passed(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertEqual(self.returncode, 0)

    def test_4d3bef_reset_flags(self):
        """FL-24a: direct test of m4d3bef_reset_flags"""
        self.check('test_m4d3bef_reset_flags')

    def test_44edfb_click_2785_2787(self):
        """FL-24a: direct test of m44edfb_click_2785_2787"""
        self.check('test_m44edfb_click_2785_2787')

    def test_4cb3ab_store_flag(self):
        """FL-24a: direct test of m4cb3ab_store_flag"""
        self.check('test_m4cb3ab_store_flag')

    def test_44eab1_hit_test(self):
        """FL-24a: direct test of m44eab1_hit_test"""
        self.check('test_m44eab1_hit_test')

    def test_46ebff_click_27c2_27c3(self):
        """FL-24a: direct test of m46ebff_click_27c2_27c3"""
        self.check('test_m46ebff_click_27c2_27c3')


    def test_4571e1_hit_test(self):
        """FL-24a: direct test of m4571e1_hit_test"""
        self.check('test_m4571e1_hit_test')

    def test_47b4aa_hit_test(self):
        """FL-24a: direct test of m47b4aa_hit_test"""
        self.check('test_m47b4aa_hit_test')


    def test_4a6574_hit_test(self):
        """FL-24a: direct test of m4a6574_hit_test"""
        self.check('test_m4a6574_hit_test')


    def test_465c99_hit_test(self):
        """FL-24a: direct test of m465c99_hit_test"""
        self.check('test_m465c99_hit_test')


    def test_482724_click_27b5_27b6(self):
        """FL-24a: direct test of m482724_click_27b5_27b6"""
        self.check('test_m482724_click_27b5_27b6')


    def test_470ffe_hit_test(self):
        """FL-24a: direct test of m470ffe_hit_test"""
        self.check('test_m470ffe_hit_test')


if __name__ == '__main__':
    unittest.main()
