"""FL-23 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl23b.c.

tests/fl23b_direct_test.c links src/original_methods_fl23b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the twelve click handlers of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl23b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl23b_direct_test.c'
KERNELS = ['original_methods_fl23b.c']
EXPECTED = [
    'test_m4a1efd_click_2760',
    'test_m4ba4f2_click_276a',
    'test_m46957d_click_272e',
    'test_m4b45ed_click_2739',
    'test_m473ffc_click_27a1',
    'test_m48e851_click_27b8_27b9',
    'test_m45e587_click_27ec_27ef',
    'test_m48ab49_click_2756_2757',
    'test_m4ab899_click_27ce_27d0',
    'test_m4574e4_click_27bc_27be',
    'test_m47a03c_click_279c_279d',
    'test_m4b2a9e_click_2792_2793',
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


class Fl23bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl23b_direct_test'
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

    def test_4a1efd_click_2760(self):
        """FL-23b: direct test of m4a1efd_click_2760"""
        self.check('test_m4a1efd_click_2760')

    def test_4ba4f2_click_276a(self):
        """FL-23b: direct test of m4ba4f2_click_276a"""
        self.check('test_m4ba4f2_click_276a')

    def test_46957d_click_272e(self):
        """FL-23b: direct test of m46957d_click_272e"""
        self.check('test_m46957d_click_272e')

    def test_4b45ed_click_2739(self):
        """FL-23b: direct test of m4b45ed_click_2739"""
        self.check('test_m4b45ed_click_2739')

    def test_473ffc_click_27a1(self):
        """FL-23b: direct test of m473ffc_click_27a1"""
        self.check('test_m473ffc_click_27a1')

    def test_48e851_click_27b8_27b9(self):
        """FL-23b: direct test of m48e851_click_27b8_27b9"""
        self.check('test_m48e851_click_27b8_27b9')

    def test_45e587_click_27ec_27ef(self):
        """FL-23b: direct test of m45e587_click_27ec_27ef"""
        self.check('test_m45e587_click_27ec_27ef')

    def test_48ab49_click_2756_2757(self):
        """FL-23b: direct test of m48ab49_click_2756_2757"""
        self.check('test_m48ab49_click_2756_2757')

    def test_4ab899_click_27ce_27d0(self):
        """FL-23b: direct test of m4ab899_click_27ce_27d0"""
        self.check('test_m4ab899_click_27ce_27d0')

    def test_4574e4_click_27bc_27be(self):
        """FL-23b: direct test of m4574e4_click_27bc_27be"""
        self.check('test_m4574e4_click_27bc_27be')

    def test_47a03c_click_279c_279d(self):
        """FL-23b: direct test of m47a03c_click_279c_279d"""
        self.check('test_m47a03c_click_279c_279d')

    def test_4b2a9e_click_2792_2793(self):
        """FL-23b: direct test of m4b2a9e_click_2792_2793"""
        self.check('test_m4b2a9e_click_2792_2793')


if __name__ == '__main__':
    unittest.main()
