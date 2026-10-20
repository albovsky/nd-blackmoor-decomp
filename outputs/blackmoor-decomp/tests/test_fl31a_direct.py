"""FL-31 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl31a.c.

tests/fl31a_direct_test.c links src/original_methods_fl31a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl31a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl31a_direct_test.c'
KERNELS = ['original_methods_fl31a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl31a_fixtures as fx
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


class Fl31aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl31a_direct_test'
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

    def test_47b200_construct(self):
        """FL-31a: direct test of m47b200_construct (original 0x47b200)"""
        self.check('test_m47b200_construct')

    def test_47b3bc_mark_entry(self):
        """FL-31a: direct test of m47b3bc_mark_entry (original 0x47b3bc)"""
        self.check('test_m47b3bc_mark_entry')

    def test_47d640_mark_entry(self):
        """FL-31a: direct test of m47d640_mark_entry (original 0x47d640)"""
        self.check('test_m47d640_mark_entry')

    def test_47b709_set_selector(self):
        """FL-31a: direct test of m47b709_set_selector (original 0x47b709)"""
        self.check('test_m47b709_set_selector')

    def test_47ba79_expire_links(self):
        """FL-31a: direct test of m47ba79_expire_links (original 0x47ba79)"""
        self.check('test_m47ba79_expire_links')

    def test_47badf_check_range(self):
        """FL-31a: direct test of m47badf_check_range (original 0x47badf)"""
        self.check('test_m47badf_check_range')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-31a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
