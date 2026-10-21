"""FL-34 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl34a.c.

tests/fl34a_direct_test.c links src/original_methods_fl34a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the 21 ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl34a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl34a_direct_test.c'
KERNELS = ['original_methods_fl34a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl34a_fixtures as fx
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


class Fl34aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl34a_direct_test'
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

    def test_402962_toggle_5e60d6(self):
        """FL-34a: direct test of m402962_toggle_5e60d6 (original 0x402962)"""
        self.check('test_m402962_toggle_5e60d6')

    def test_402a7e_toggle_5e60e6(self):
        """FL-34a: direct test of m402a7e_toggle_5e60e6 (original 0x402a7e)"""
        self.check('test_m402a7e_toggle_5e60e6')

    def test_402ac5_toggle_5e60ea(self):
        """FL-34a: direct test of m402ac5_toggle_5e60ea (original 0x402ac5)"""
        self.check('test_m402ac5_toggle_5e60ea')

    def test_402b0c_toggle_5e60ee(self):
        """FL-34a: direct test of m402b0c_toggle_5e60ee (original 0x402b0c)"""
        self.check('test_m402b0c_toggle_5e60ee')

    def test_402b53_toggle_5e60f2(self):
        """FL-34a: direct test of m402b53_toggle_5e60f2 (original 0x402b53)"""
        self.check('test_m402b53_toggle_5e60f2')

    def test_402b9a_toggle_5e60f6(self):
        """FL-34a: direct test of m402b9a_toggle_5e60f6 (original 0x402b9a)"""
        self.check('test_m402b9a_toggle_5e60f6')

    def test_402be1_toggle_5e60fa(self):
        """FL-34a: direct test of m402be1_toggle_5e60fa (original 0x402be1)"""
        self.check('test_m402be1_toggle_5e60fa')

    def test_402c28_toggle_5e60fe(self):
        """FL-34a: direct test of m402c28_toggle_5e60fe (original 0x402c28)"""
        self.check('test_m402c28_toggle_5e60fe')

    def test_402c6f_toggle_5e6102(self):
        """FL-34a: direct test of m402c6f_toggle_5e6102 (original 0x402c6f)"""
        self.check('test_m402c6f_toggle_5e6102')

    def test_402cb6_toggle_5e6106(self):
        """FL-34a: direct test of m402cb6_toggle_5e6106 (original 0x402cb6)"""
        self.check('test_m402cb6_toggle_5e6106')

    def test_402cfd_toggle_5e610a(self):
        """FL-34a: direct test of m402cfd_toggle_5e610a (original 0x402cfd)"""
        self.check('test_m402cfd_toggle_5e610a')

    def test_402d44_toggle_5e610e(self):
        """FL-34a: direct test of m402d44_toggle_5e610e (original 0x402d44)"""
        self.check('test_m402d44_toggle_5e610e')

    def test_402d8b_toggle_5e6112(self):
        """FL-34a: direct test of m402d8b_toggle_5e6112 (original 0x402d8b)"""
        self.check('test_m402d8b_toggle_5e6112')

    def test_402dd2_toggle_5e6116(self):
        """FL-34a: direct test of m402dd2_toggle_5e6116 (original 0x402dd2)"""
        self.check('test_m402dd2_toggle_5e6116')

    def test_402e19_toggle_5e611a(self):
        """FL-34a: direct test of m402e19_toggle_5e611a (original 0x402e19)"""
        self.check('test_m402e19_toggle_5e611a')

    def test_402e60_toggle_5e611e(self):
        """FL-34a: direct test of m402e60_toggle_5e611e (original 0x402e60)"""
        self.check('test_m402e60_toggle_5e611e')

    def test_402ea7_toggle_5e6122(self):
        """FL-34a: direct test of m402ea7_toggle_5e6122 (original 0x402ea7)"""
        self.check('test_m402ea7_toggle_5e6122')

    def test_402eee_toggle_5e6126(self):
        """FL-34a: direct test of m402eee_toggle_5e6126 (original 0x402eee)"""
        self.check('test_m402eee_toggle_5e6126')

    def test_402f35_toggle_5e612a(self):
        """FL-34a: direct test of m402f35_toggle_5e612a (original 0x402f35)"""
        self.check('test_m402f35_toggle_5e612a')

    def test_402f7c_toggle_5e612e(self):
        """FL-34a: direct test of m402f7c_toggle_5e612e (original 0x402f7c)"""
        self.check('test_m402f7c_toggle_5e612e')

    def test_402fc3_toggle_5e6132(self):
        """FL-34a: direct test of m402fc3_toggle_5e6132 (original 0x402fc3)"""
        self.check('test_m402fc3_toggle_5e6132')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-34a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
