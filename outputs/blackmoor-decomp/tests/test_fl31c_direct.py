"""FL-31 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl31c.c.

tests/fl31c_direct_test.c links src/original_methods_fl31c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the eight ported functions of batch c); the Unicorn comparison against the original bytes is in
tests/test_fl31c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl31c_direct_test.c'
KERNELS = ['original_methods_fl31c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl31c_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_sweep_bounded']


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


class Fl31cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl31c_direct_test'
        built = build(binary)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=120)
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

    def test_4e2faa_release_cells(self):
        """FL-31c: direct test of m4e2faa_release_cells (original 0x4e2faa)"""
        self.check('test_m4e2faa_release_cells')

    def test_4c2790_new_record(self):
        """FL-31c: direct test of m4c2790_new_record (original 0x4c2790)"""
        self.check('test_m4c2790_new_record')

    def test_4eba54_retarget_words(self):
        """FL-31c: direct test of m4eba54_retarget_words (original 0x4eba54)"""
        self.check('test_m4eba54_retarget_words')

    def test_4edb97_release_members(self):
        """FL-31c: direct test of m4edb97_release_members (original 0x4edb97)"""
        self.check('test_m4edb97_release_members')

    def test_4db870_load_cursor(self):
        """FL-31c: direct test of m4db870_load_cursor (original 0x4db870)"""
        self.check('test_m4db870_load_cursor')

    def test_47cd90_pick_variant_a(self):
        """FL-31c: direct test of m47cd90_pick_variant_a (original 0x47cd90)"""
        self.check('test_m47cd90_pick_variant_a')

    def test_47ce6f_pick_variant_b(self):
        """FL-31c: direct test of m47ce6f_pick_variant_b (original 0x47ce6f)"""
        self.check('test_m47ce6f_pick_variant_b')

    def test_47cf4e_pick_variant_c(self):
        """FL-31c: direct test of m47cf4e_pick_variant_c (original 0x47cf4e)"""
        self.check('test_m47cf4e_pick_variant_c')

    def test_sweep_bounded(self):
        """FL-31b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
