"""FL-35 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl35b.c.

tests/fl35b_direct_test.c links src/original_methods_fl35b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function ; the Unicorn comparison against the original bytes is in
tests/test_fl35b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl35b_direct_test.c'
KERNELS = ['original_methods_fl35b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl35b_fixtures as fx
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


class Fl35bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl35b_direct_test'
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

    def test_4080fc_toggle_5ec28c(self):
        """FL-35b: direct test of m4080fc_toggle_5ec28c (original 0x4080fc)"""
        self.check('test_m4080fc_toggle_5ec28c')

    def test_40812e_read_text_word(self):
        """FL-35b: direct test of m40812e_read_text_word (original 0x40812e)"""
        self.check('test_m40812e_read_text_word')

    def test_408169_read_text_word(self):
        """FL-35b: direct test of m408169_read_text_word (original 0x408169)"""
        self.check('test_m408169_read_text_word')

    def test_4081a4_read_text_word(self):
        """FL-35b: direct test of m4081a4_read_text_word (original 0x4081a4)"""
        self.check('test_m4081a4_read_text_word')

    def test_4081df_read_text_word(self):
        """FL-35b: direct test of m4081df_read_text_word (original 0x4081df)"""
        self.check('test_m4081df_read_text_word')

    def test_40821a_read_text_word(self):
        """FL-35b: direct test of m40821a_read_text_word (original 0x40821a)"""
        self.check('test_m40821a_read_text_word')

    def test_408255_read_text_word(self):
        """FL-35b: direct test of m408255_read_text_word (original 0x408255)"""
        self.check('test_m408255_read_text_word')

    def test_408290_read_text_word(self):
        """FL-35b: direct test of m408290_read_text_word (original 0x408290)"""
        self.check('test_m408290_read_text_word')

    def test_4082cb_read_text_word(self):
        """FL-35b: direct test of m4082cb_read_text_word (original 0x4082cb)"""
        self.check('test_m4082cb_read_text_word')

    def test_408306_read_text_word(self):
        """FL-35b: direct test of m408306_read_text_word (original 0x408306)"""
        self.check('test_m408306_read_text_word')

    def test_408341_read_text_word(self):
        """FL-35b: direct test of m408341_read_text_word (original 0x408341)"""
        self.check('test_m408341_read_text_word')

    def test_40837c_read_text_word(self):
        """FL-35b: direct test of m40837c_read_text_word (original 0x40837c)"""
        self.check('test_m40837c_read_text_word')

    def test_4083b7_read_text_word(self):
        """FL-35b: direct test of m4083b7_read_text_word (original 0x4083b7)"""
        self.check('test_m4083b7_read_text_word')

    def test_4083f2_read_text_word(self):
        """FL-35b: direct test of m4083f2_read_text_word (original 0x4083f2)"""
        self.check('test_m4083f2_read_text_word')

    def test_40842d_read_text_word(self):
        """FL-35b: direct test of m40842d_read_text_word (original 0x40842d)"""
        self.check('test_m40842d_read_text_word')

    def test_408468_read_text_word(self):
        """FL-35b: direct test of m408468_read_text_word (original 0x408468)"""
        self.check('test_m408468_read_text_word')

    def test_4084a3_read_text_word(self):
        """FL-35b: direct test of m4084a3_read_text_word (original 0x4084a3)"""
        self.check('test_m4084a3_read_text_word')

    def test_4084de_read_text_word(self):
        """FL-35b: direct test of m4084de_read_text_word (original 0x4084de)"""
        self.check('test_m4084de_read_text_word')

    def test_408519_read_text_word(self):
        """FL-35b: direct test of m408519_read_text_word (original 0x408519)"""
        self.check('test_m408519_read_text_word')

    def test_408554_read_text_word(self):
        """FL-35b: direct test of m408554_read_text_word (original 0x408554)"""
        self.check('test_m408554_read_text_word')

    def test_40858f_read_text_word(self):
        """FL-35b: direct test of m40858f_read_text_word (original 0x40858f)"""
        self.check('test_m40858f_read_text_word')

    def test_4085ca_read_text_word(self):
        """FL-35b: direct test of m4085ca_read_text_word (original 0x4085ca)"""
        self.check('test_m4085ca_read_text_word')

    def test_408605_read_text_word(self):
        """FL-35b: direct test of m408605_read_text_word (original 0x408605)"""
        self.check('test_m408605_read_text_word')

    def test_408640_read_text_word(self):
        """FL-35b: direct test of m408640_read_text_word (original 0x408640)"""
        self.check('test_m408640_read_text_word')

    def test_40867b_read_text_word(self):
        """FL-35b: direct test of m40867b_read_text_word (original 0x40867b)"""
        self.check('test_m40867b_read_text_word')

    def test_4086b6_read_text_word(self):
        """FL-35b: direct test of m4086b6_read_text_word (original 0x4086b6)"""
        self.check('test_m4086b6_read_text_word')

    def test_4086f1_read_text_word(self):
        """FL-35b: direct test of m4086f1_read_text_word (original 0x4086f1)"""
        self.check('test_m4086f1_read_text_word')

    def test_40872c_read_text_word(self):
        """FL-35b: direct test of m40872c_read_text_word (original 0x40872c)"""
        self.check('test_m40872c_read_text_word')

    def test_408767_read_text_word(self):
        """FL-35b: direct test of m408767_read_text_word (original 0x408767)"""
        self.check('test_m408767_read_text_word')

    def test_4087a2_read_text_word(self):
        """FL-35b: direct test of m4087a2_read_text_word (original 0x4087a2)"""
        self.check('test_m4087a2_read_text_word')

    def test_4087dd_read_text_word(self):
        """FL-35b: direct test of m4087dd_read_text_word (original 0x4087dd)"""
        self.check('test_m4087dd_read_text_word')

    def test_408818_read_text_word(self):
        """FL-35b: direct test of m408818_read_text_word (original 0x408818)"""
        self.check('test_m408818_read_text_word')

    def test_408853_read_text_word(self):
        """FL-35b: direct test of m408853_read_text_word (original 0x408853)"""
        self.check('test_m408853_read_text_word')

    def test_40888e_read_text_word(self):
        """FL-35b: direct test of m40888e_read_text_word (original 0x40888e)"""
        self.check('test_m40888e_read_text_word')

    def test_4088c9_read_text_word(self):
        """FL-35b: direct test of m4088c9_read_text_word (original 0x4088c9)"""
        self.check('test_m4088c9_read_text_word')

    def test_408904_read_text_word(self):
        """FL-35b: direct test of m408904_read_text_word (original 0x408904)"""
        self.check('test_m408904_read_text_word')

    def test_exact_size_buffers(self):
        """FL-35b: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')

    def test_sweep_bounded(self):
        """FL-35b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
