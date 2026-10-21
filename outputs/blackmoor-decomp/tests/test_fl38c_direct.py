"""FL-38 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl38c.c.

tests/fl38c_direct_test.c links src/original_methods_fl38c.c and prints one PASS/FAIL line per case; every test below checks one of them. Expected values come from the original's
disassembly, not from the native code. One direct case per function; the Unicorn comparison against the original bytes is in tests/test_fl38c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl38c_direct_test.c'
KERNELS = ['original_methods_fl38c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl38c_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_exact_size_buffers']


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


class Fl38cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl38c_direct_test'
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

    def test_40430e_read_word_setting(self):
        """FL-38c: direct test of m40430e_read_word_setting (original 0x40430e)"""
        self.check('test_m40430e_read_word_setting')

    def test_404349_read_word_setting(self):
        """FL-38c: direct test of m404349_read_word_setting (original 0x404349)"""
        self.check('test_m404349_read_word_setting')

    def test_40492f_read_word_setting(self):
        """FL-38c: direct test of m40492f_read_word_setting (original 0x40492f)"""
        self.check('test_m40492f_read_word_setting')

    def test_40496a_read_word_setting(self):
        """FL-38c: direct test of m40496a_read_word_setting (original 0x40496a)"""
        self.check('test_m40496a_read_word_setting')

    def test_4049a5_read_word_setting(self):
        """FL-38c: direct test of m4049a5_read_word_setting (original 0x4049a5)"""
        self.check('test_m4049a5_read_word_setting')

    def test_4049e0_read_word_setting(self):
        """FL-38c: direct test of m4049e0_read_word_setting (original 0x4049e0)"""
        self.check('test_m4049e0_read_word_setting')

    def test_40893f_read_word_setting(self):
        """FL-38c: direct test of m40893f_read_word_setting (original 0x40893f)"""
        self.check('test_m40893f_read_word_setting')

    def test_4043b6_read_time_setting(self):
        """FL-38c: direct test of m4043b6_read_time_setting (original 0x4043b6)"""
        self.check('test_m4043b6_read_time_setting')

    def test_40445a_read_time_setting(self):
        """FL-38c: direct test of m40445a_read_time_setting (original 0x40445a)"""
        self.check('test_m40445a_read_time_setting')

    def test_4044fe_read_time_setting(self):
        """FL-38c: direct test of m4044fe_read_time_setting (original 0x4044fe)"""
        self.check('test_m4044fe_read_time_setting')

    def test_4045a2_read_time_setting(self):
        """FL-38c: direct test of m4045a2_read_time_setting (original 0x4045a2)"""
        self.check('test_m4045a2_read_time_setting')

    def test_404646_read_time_setting(self):
        """FL-38c: direct test of m404646_read_time_setting (original 0x404646)"""
        self.check('test_m404646_read_time_setting')

    def test_4046ea_read_time_setting(self):
        """FL-38c: direct test of m4046ea_read_time_setting (original 0x4046ea)"""
        self.check('test_m4046ea_read_time_setting')

    def test_454f29_shift_rect(self):
        """FL-38c: direct test of m454f29_shift_rect (original 0x454f29)"""
        self.check('test_m454f29_shift_rect')

    def test_457071_shift_rect(self):
        """FL-38c: direct test of m457071_shift_rect (original 0x457071)"""
        self.check('test_m457071_shift_rect')

    def test_458137_shift_rect(self):
        """FL-38c: direct test of m458137_shift_rect (original 0x458137)"""
        self.check('test_m458137_shift_rect')

    def test_46453b_shift_rect(self):
        """FL-38c: direct test of m46453b_shift_rect (original 0x46453b)"""
        self.check('test_m46453b_shift_rect')

    def test_466db1_shift_rect(self):
        """FL-38c: direct test of m466db1_shift_rect (original 0x466db1)"""
        self.check('test_m466db1_shift_rect')

    def test_479d98_shift_rect(self):
        """FL-38c: direct test of m479d98_shift_rect (original 0x479d98)"""
        self.check('test_m479d98_shift_rect')

    def test_4465fd_new_zeroed(self):
        """FL-38c: direct test of m4465fd_new_zeroed (original 0x4465fd)"""
        self.check('test_m4465fd_new_zeroed')

    def test_4547bc_new_zeroed(self):
        """FL-38c: direct test of m4547bc_new_zeroed (original 0x4547bc)"""
        self.check('test_m4547bc_new_zeroed')

    def test_454f7c_clamp_to_bounds(self):
        """FL-38c: direct test of m454f7c_clamp_to_bounds (original 0x454f7c)"""
        self.check('test_m454f7c_clamp_to_bounds')

    def test_46458e_clamp_to_bounds(self):
        """FL-38c: direct test of m46458e_clamp_to_bounds (original 0x46458e)"""
        self.check('test_m46458e_clamp_to_bounds')

    def test_46b855_clamp_to_bounds(self):
        """FL-38c: direct test of m46b855_clamp_to_bounds (original 0x46b855)"""
        self.check('test_m46b855_clamp_to_bounds')

    def test_exact_size_buffers(self):
        """FL-38c: every port on heap buffers of exactly the bytes the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')


if __name__ == '__main__':
    unittest.main()
