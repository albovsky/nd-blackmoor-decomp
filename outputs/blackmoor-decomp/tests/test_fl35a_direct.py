"""FL-35 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl35a.c.

tests/fl35a_direct_test.c links src/original_methods_fl35a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function ; the Unicorn comparison against the original bytes is in
tests/test_fl35a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl35a_direct_test.c'
KERNELS = ['original_methods_fl35a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl35a_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_exact_size_buffers', 'test_sweep_bounded']


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


class Fl35aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl35a_direct_test'
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

    def test_40a5c1_read_tag_word(self):
        """FL-35a: direct test of m40a5c1_read_tag_word (original 0x40a5c1)"""
        self.check('test_m40a5c1_read_tag_word')

    def test_40a6b7_read_tag_word(self):
        """FL-35a: direct test of m40a6b7_read_tag_word (original 0x40a6b7)"""
        self.check('test_m40a6b7_read_tag_word')

    def test_40a709_read_tag_word(self):
        """FL-35a: direct test of m40a709_read_tag_word (original 0x40a709)"""
        self.check('test_m40a709_read_tag_word')

    def test_40a75b_read_tag_word(self):
        """FL-35a: direct test of m40a75b_read_tag_word (original 0x40a75b)"""
        self.check('test_m40a75b_read_tag_word')

    def test_40a7ad_read_tag_word(self):
        """FL-35a: direct test of m40a7ad_read_tag_word (original 0x40a7ad)"""
        self.check('test_m40a7ad_read_tag_word')

    def test_40a7ff_read_tag_word(self):
        """FL-35a: direct test of m40a7ff_read_tag_word (original 0x40a7ff)"""
        self.check('test_m40a7ff_read_tag_word')

    def test_40a851_read_tag_word(self):
        """FL-35a: direct test of m40a851_read_tag_word (original 0x40a851)"""
        self.check('test_m40a851_read_tag_word')

    def test_40a8a3_read_tag_word(self):
        """FL-35a: direct test of m40a8a3_read_tag_word (original 0x40a8a3)"""
        self.check('test_m40a8a3_read_tag_word')

    def test_40a8f5_read_tag_word(self):
        """FL-35a: direct test of m40a8f5_read_tag_word (original 0x40a8f5)"""
        self.check('test_m40a8f5_read_tag_word')

    def test_40a947_read_tag_word(self):
        """FL-35a: direct test of m40a947_read_tag_word (original 0x40a947)"""
        self.check('test_m40a947_read_tag_word')

    def test_40a999_read_tag_word(self):
        """FL-35a: direct test of m40a999_read_tag_word (original 0x40a999)"""
        self.check('test_m40a999_read_tag_word')

    def test_40a9eb_read_tag_word(self):
        """FL-35a: direct test of m40a9eb_read_tag_word (original 0x40a9eb)"""
        self.check('test_m40a9eb_read_tag_word')

    def test_40aa3d_read_tag_word(self):
        """FL-35a: direct test of m40aa3d_read_tag_word (original 0x40aa3d)"""
        self.check('test_m40aa3d_read_tag_word')

    def test_40aa8f_read_tag_word(self):
        """FL-35a: direct test of m40aa8f_read_tag_word (original 0x40aa8f)"""
        self.check('test_m40aa8f_read_tag_word')

    def test_40aae1_read_tag_word(self):
        """FL-35a: direct test of m40aae1_read_tag_word (original 0x40aae1)"""
        self.check('test_m40aae1_read_tag_word')

    def test_40ab33_read_tag_word(self):
        """FL-35a: direct test of m40ab33_read_tag_word (original 0x40ab33)"""
        self.check('test_m40ab33_read_tag_word')

    def test_40ab85_read_tag_word(self):
        """FL-35a: direct test of m40ab85_read_tag_word (original 0x40ab85)"""
        self.check('test_m40ab85_read_tag_word')

    def test_40abd7_read_tag_word(self):
        """FL-35a: direct test of m40abd7_read_tag_word (original 0x40abd7)"""
        self.check('test_m40abd7_read_tag_word')

    def test_40ac29_read_tag_word(self):
        """FL-35a: direct test of m40ac29_read_tag_word (original 0x40ac29)"""
        self.check('test_m40ac29_read_tag_word')

    def test_40ac7b_read_tag_word(self):
        """FL-35a: direct test of m40ac7b_read_tag_word (original 0x40ac7b)"""
        self.check('test_m40ac7b_read_tag_word')

    def test_40accd_read_tag_word(self):
        """FL-35a: direct test of m40accd_read_tag_word (original 0x40accd)"""
        self.check('test_m40accd_read_tag_word')

    def test_40ad1f_read_tag_word(self):
        """FL-35a: direct test of m40ad1f_read_tag_word (original 0x40ad1f)"""
        self.check('test_m40ad1f_read_tag_word')

    def test_40ad71_read_tag_word(self):
        """FL-35a: direct test of m40ad71_read_tag_word (original 0x40ad71)"""
        self.check('test_m40ad71_read_tag_word')

    def test_40adc3_read_tag_word(self):
        """FL-35a: direct test of m40adc3_read_tag_word (original 0x40adc3)"""
        self.check('test_m40adc3_read_tag_word')

    def test_40ae15_read_tag_word(self):
        """FL-35a: direct test of m40ae15_read_tag_word (original 0x40ae15)"""
        self.check('test_m40ae15_read_tag_word')

    def test_40ae67_read_tag_word(self):
        """FL-35a: direct test of m40ae67_read_tag_word (original 0x40ae67)"""
        self.check('test_m40ae67_read_tag_word')

    def test_40aeb9_read_tag_word(self):
        """FL-35a: direct test of m40aeb9_read_tag_word (original 0x40aeb9)"""
        self.check('test_m40aeb9_read_tag_word')

    def test_40af0b_read_tag_word(self):
        """FL-35a: direct test of m40af0b_read_tag_word (original 0x40af0b)"""
        self.check('test_m40af0b_read_tag_word')

    def test_exact_size_buffers(self):
        """FL-35a: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')

    def test_sweep_bounded(self):
        """FL-35a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
