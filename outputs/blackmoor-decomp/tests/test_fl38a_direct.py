"""FL-38 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl38a.c.

tests/fl38a_direct_test.c links src/original_methods_fl38a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl38a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl38a_direct_test.c'
KERNELS = ['original_methods_fl38a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl38a_fixtures as fx
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


class Fl38aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl38a_direct_test'
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

    def test_414c6d_get_constant(self):
        """FL-38a: direct test of m414c6d_get_constant (original 0x414c6d)"""
        self.check('test_m414c6d_get_constant')

    def test_447cc4_get_constant(self):
        """FL-38a: direct test of m447cc4_get_constant (original 0x447cc4)"""
        self.check('test_m447cc4_get_constant')

    def test_4487de_get_constant(self):
        """FL-38a: direct test of m4487de_get_constant (original 0x4487de)"""
        self.check('test_m4487de_get_constant')

    def test_44be44_get_constant(self):
        """FL-38a: direct test of m44be44_get_constant (original 0x44be44)"""
        self.check('test_m44be44_get_constant')

    def test_4542b5_check_no_sound_call(self):
        """FL-38a: direct test of m4542b5_check_no_sound_call (original 0x4542b5)"""
        self.check('test_m4542b5_check_no_sound_call')

    def test_4542f2_check_no_sound_call(self):
        """FL-38a: direct test of m4542f2_check_no_sound_call (original 0x4542f2)"""
        self.check('test_m4542f2_check_no_sound_call')

    def test_45441d_check_no_sound_call(self):
        """FL-38a: direct test of m45441d_check_no_sound_call (original 0x45441d)"""
        self.check('test_m45441d_check_no_sound_call')

    def test_454de6_release_surface_clear_call_tail(self):
        """FL-38a: direct test of m454de6_release_surface_clear_call_tail (original 0x454de6)"""
        self.check('test_m454de6_release_surface_clear_call_tail')

    def test_454e39_guard_set_table_flag(self):
        """FL-38a: direct test of m454e39_guard_set_table_flag (original 0x454e39)"""
        self.check('test_m454e39_guard_set_table_flag')

    def test_456d2e_release_surface_call_tail(self):
        """FL-38a: direct test of m456d2e_release_surface_call_tail (original 0x456d2e)"""
        self.check('test_m456d2e_release_surface_call_tail')

    def test_456d77_guard_set_table_flag(self):
        """FL-38a: direct test of m456d77_guard_set_table_flag (original 0x456d77)"""
        self.check('test_m456d77_guard_set_table_flag')

    def test_457fc2_release_surface_clear_call_tail(self):
        """FL-38a: direct test of m457fc2_release_surface_clear_call_tail (original 0x457fc2)"""
        self.check('test_m457fc2_release_surface_clear_call_tail')

    def test_458045_guard_set_table_flag(self):
        """FL-38a: direct test of m458045_guard_set_table_flag (original 0x458045)"""
        self.check('test_m458045_guard_set_table_flag')

    def test_459b87_release_surface_call_tail(self):
        """FL-38a: direct test of m459b87_release_surface_call_tail (original 0x459b87)"""
        self.check('test_m459b87_release_surface_call_tail')

    def test_45dd4d_release_surface_call_tail(self):
        """FL-38a: direct test of m45dd4d_release_surface_call_tail (original 0x45dd4d)"""
        self.check('test_m45dd4d_release_surface_call_tail')

    def test_464076_release_surface_clear_call_tail(self):
        """FL-38a: direct test of m464076_release_surface_clear_call_tail (original 0x464076)"""
        self.check('test_m464076_release_surface_clear_call_tail')

    def test_4640c9_guard_set_table_flag(self):
        """FL-38a: direct test of m4640c9_guard_set_table_flag (original 0x4640c9)"""
        self.check('test_m4640c9_guard_set_table_flag')

    def test_465b9f_guard_set_table_flag(self):
        """FL-38a: direct test of m465b9f_guard_set_table_flag (original 0x465b9f)"""
        self.check('test_m465b9f_guard_set_table_flag')

    def test_467651_guard_set_table_flag(self):
        """FL-38a: direct test of m467651_guard_set_table_flag (original 0x467651)"""
        self.check('test_m467651_guard_set_table_flag')

    def test_468f19_release_surface_call_tail(self):
        """FL-38a: direct test of m468f19_release_surface_call_tail (original 0x468f19)"""
        self.check('test_m468f19_release_surface_call_tail')

    def test_468f68_guard_set_table_flag(self):
        """FL-38a: direct test of m468f68_guard_set_table_flag (original 0x468f68)"""
        self.check('test_m468f68_guard_set_table_flag')

    def test_46b707_guard_set_table_flag(self):
        """FL-38a: direct test of m46b707_guard_set_table_flag (original 0x46b707)"""
        self.check('test_m46b707_guard_set_table_flag')

    def test_46e7a6_release_surface_call_tail(self):
        """FL-38a: direct test of m46e7a6_release_surface_call_tail (original 0x46e7a6)"""
        self.check('test_m46e7a6_release_surface_call_tail')

    def test_46e7ef_guard_set_table_flag(self):
        """FL-38a: direct test of m46e7ef_guard_set_table_flag (original 0x46e7ef)"""
        self.check('test_m46e7ef_guard_set_table_flag')

    def test_470ddc_release_surface_call_tail(self):
        """FL-38a: direct test of m470ddc_release_surface_call_tail (original 0x470ddc)"""
        self.check('test_m470ddc_release_surface_call_tail')

    def test_47823e_release_surface_call_tail(self):
        """FL-38a: direct test of m47823e_release_surface_call_tail (original 0x47823e)"""
        self.check('test_m47823e_release_surface_call_tail')

    def test_478287_guard_set_table_flag(self):
        """FL-38a: direct test of m478287_guard_set_table_flag (original 0x478287)"""
        self.check('test_m478287_guard_set_table_flag')

    def test_exact_size_buffers(self):
        """FL-38a: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
