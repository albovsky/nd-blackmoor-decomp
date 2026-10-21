"""FL-32 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl32a.c.

tests/fl32a_direct_test.c links src/original_methods_fl32a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl32a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl32a_direct_test.c'
KERNELS = ['original_methods_fl32a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl32a_fixtures as fx
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


class Fl32aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl32a_direct_test'
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

    def test_40425d_read_text_cc(self):
        """FL-32a: direct test of m40425d_read_text_cc (original 0x40425d)"""
        self.check('test_m40425d_read_text_cc')

    def test_404298_read_text_10c(self):
        """FL-32a: direct test of m404298_read_text_10c (original 0x404298)"""
        self.check('test_m404298_read_text_10c')

    def test_4042d3_read_text_1cc(self):
        """FL-32a: direct test of m4042d3_read_text_1cc (original 0x4042d3)"""
        self.check('test_m4042d3_read_text_1cc')

    def test_4029a9_toggle_5e60da(self):
        """FL-32a: direct test of m4029a9_toggle_5e60da (original 0x4029a9)"""
        self.check('test_m4029a9_toggle_5e60da')

    def test_4029f0_toggle_5e60de(self):
        """FL-32a: direct test of m4029f0_toggle_5e60de (original 0x4029f0)"""
        self.check('test_m4029f0_toggle_5e60de')

    def test_402a37_toggle_5e60e2(self):
        """FL-32a: direct test of m402a37_toggle_5e60e2 (original 0x402a37)"""
        self.check('test_m402a37_toggle_5e60e2')

    def test_4067eb_toggle_5e350e(self):
        """FL-32a: direct test of m4067eb_toggle_5e350e (original 0x4067eb)"""
        self.check('test_m4067eb_toggle_5e350e')

    def test_406832_toggle_5e3512(self):
        """FL-32a: direct test of m406832_toggle_5e3512 (original 0x406832)"""
        self.check('test_m406832_toggle_5e3512')

    def test_406879_toggle_5e3516(self):
        """FL-32a: direct test of m406879_toggle_5e3516 (original 0x406879)"""
        self.check('test_m406879_toggle_5e3516')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-32a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
