"""FL-29 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl29c.c.

tests/fl29c_direct_test.c links src/original_methods_fl29c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl29c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl29c_direct_test.c'
KERNELS = ['original_methods_fl29c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl29c_fixtures as fx
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


class Fl29cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl29c_direct_test'
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

    def test_4bf19a_bink_goto(self):
        """FL-29c: direct test of m4bf19a_bink_goto (original 0x4bf19a)"""
        self.check('test_m4bf19a_bink_goto')

    def test_434814_copy_name(self):
        """FL-29c: direct test of m434814_copy_name (original 0x434814)"""
        self.check('test_m434814_copy_name')

    def test_4471ca_copy_record15(self):
        """FL-29c: direct test of m4471ca_copy_record15 (original 0x4471ca)"""
        self.check('test_m4471ca_copy_record15')

    def test_45b4ae_copy_record_b8e(self):
        """FL-29c: direct test of m45b4ae_copy_record_b8e (original 0x45b4ae)"""
        self.check('test_m45b4ae_copy_record_b8e')

    def test_461903_copy_record_357(self):
        """FL-29c: direct test of m461903_copy_record_357 (original 0x461903)"""
        self.check('test_m461903_copy_record_357')

    def test_4b5c5c_copy_record_39f(self):
        """FL-29c: direct test of m4b5c5c_copy_record_39f (original 0x4b5c5c)"""
        self.check('test_m4b5c5c_copy_record_39f')

    def test_45bbd8_roll_rects(self):
        """FL-29c: direct test of m45bbd8_roll_rects (original 0x45bbd8)"""
        self.check('test_m45bbd8_roll_rects')

    def test_4630a3_select_action(self):
        """FL-29c: direct test of m4630a3_select_action (original 0x4630a3)"""
        self.check('test_m4630a3_select_action')

    def test_43423d_find_name_a(self):
        """FL-29c: direct test of m43423d_find_name_a (original 0x43423d)"""
        self.check('test_m43423d_find_name_a')

    def test_4344bf_find_name_b(self):
        """FL-29c: direct test of m4344bf_find_name_b (original 0x4344bf)"""
        self.check('test_m4344bf_find_name_b')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-29c: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
