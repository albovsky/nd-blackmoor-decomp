"""FL-39 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl39c.c.

tests/fl39c_direct_test.c links src/original_methods_fl39c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39c_direct_test.c'
KERNELS = ['original_methods_fl39c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39c_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS]


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


class Fl39cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39c_direct_test'
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

    def test_4a3aec_clamp_rect(self):
        """FL-39c: direct test of m4a3aec_clamp_rect (original 0x4a3aec)"""
        self.check('test_m4a3aec_clamp_rect')

    def test_4a7f08_clamp_rect(self):
        """FL-39c: direct test of m4a7f08_clamp_rect (original 0x4a7f08)"""
        self.check('test_m4a7f08_clamp_rect')

    def test_4ada0d_check_bytes(self):
        """FL-39c: direct test of m4ada0d_check_bytes (original 0x4ada0d)"""
        self.check('test_m4ada0d_check_bytes')

    def test_4ada56_check_bytes(self):
        """FL-39c: direct test of m4ada56_check_bytes (original 0x4ada56)"""
        self.check('test_m4ada56_check_bytes')

    def test_4ada9f_check_bytes(self):
        """FL-39c: direct test of m4ada9f_check_bytes (original 0x4ada9f)"""
        self.check('test_m4ada9f_check_bytes')

    def test_4b3e99_clamp_rect(self):
        """FL-39c: direct test of m4b3e99_clamp_rect (original 0x4b3e99)"""
        self.check('test_m4b3e99_clamp_rect')

    def test_4be3d3_check_bytes(self):
        """FL-39c: direct test of m4be3d3_check_bytes (original 0x4be3d3)"""
        self.check('test_m4be3d3_check_bytes')

    def test_4be410_check_bytes(self):
        """FL-39c: direct test of m4be410_check_bytes (original 0x4be410)"""
        self.check('test_m4be410_check_bytes')

    def test_4be44d_check_bytes(self):
        """FL-39c: direct test of m4be44d_check_bytes (original 0x4be44d)"""
        self.check('test_m4be44d_check_bytes')

    def test_4be48a_check_bytes(self):
        """FL-39c: direct test of m4be48a_check_bytes (original 0x4be48a)"""
        self.check('test_m4be48a_check_bytes')

    def test_4be4c7_check_bytes(self):
        """FL-39c: direct test of m4be4c7_check_bytes (original 0x4be4c7)"""
        self.check('test_m4be4c7_check_bytes')

    def test_4be619_alloc_zero(self):
        """FL-39c: direct test of m4be619_alloc_zero (original 0x4be619)"""
        self.check('test_m4be619_alloc_zero')

    def test_4bf542_alloc_zero(self):
        """FL-39c: direct test of m4bf542_alloc_zero (original 0x4bf542)"""
        self.check('test_m4bf542_alloc_zero')

    def test_4cb8d5_get_via_out(self):
        """FL-39c: direct test of m4cb8d5_get_via_out (original 0x4cb8d5)"""
        self.check('test_m4cb8d5_get_via_out')

    def test_4cb8fa_get_via_out(self):
        """FL-39c: direct test of m4cb8fa_get_via_out (original 0x4cb8fa)"""
        self.check('test_m4cb8fa_get_via_out')

    def test_4cb91f_get_via_out(self):
        """FL-39c: direct test of m4cb91f_get_via_out (original 0x4cb91f)"""
        self.check('test_m4cb91f_get_via_out')

    def test_4cc70f_alloc_zero(self):
        """FL-39c: direct test of m4cc70f_alloc_zero (original 0x4cc70f)"""
        self.check('test_m4cc70f_alloc_zero')

    def test_4d9910_alloc_zero(self):
        """FL-39c: direct test of m4d9910_alloc_zero (original 0x4d9910)"""
        self.check('test_m4d9910_alloc_zero')

    def test_4de394_copy_block(self):
        """FL-39c: direct test of m4de394_copy_block (original 0x4de394)"""
        self.check('test_m4de394_copy_block')

    def test_4e2d63_destroy_vector(self):
        """FL-39c: direct test of m4e2d63_destroy_vector (original 0x4e2d63)"""
        self.check('test_m4e2d63_destroy_vector')

    def test_4e3525_set_field_forward(self):
        """FL-39c: direct test of m4e3525_set_field_forward (original 0x4e3525)"""
        self.check('test_m4e3525_set_field_forward')

    def test_4e37bd_call_three_zero(self):
        """FL-39c: direct test of m4e37bd_call_three_zero (original 0x4e37bd)"""
        self.check('test_m4e37bd_call_three_zero')

    def test_4e37f8_call_three_zero(self):
        """FL-39c: direct test of m4e37f8_call_three_zero (original 0x4e37f8)"""
        self.check('test_m4e37f8_call_three_zero')

    def test_4e3833_call_three_zero(self):
        """FL-39c: direct test of m4e3833_call_three_zero (original 0x4e3833)"""
        self.check('test_m4e3833_call_three_zero')

    def test_4e7843_copy_block(self):
        """FL-39c: direct test of m4e7843_copy_block (original 0x4e7843)"""
        self.check('test_m4e7843_copy_block')

    def test_4e7b37_destroy_vector(self):
        """FL-39c: direct test of m4e7b37_destroy_vector (original 0x4e7b37)"""
        self.check('test_m4e7b37_destroy_vector')

    def test_4e7d2e_copy_block(self):
        """FL-39c: direct test of m4e7d2e_copy_block (original 0x4e7d2e)"""
        self.check('test_m4e7d2e_copy_block')

    def test_4e8994_set_field_forward(self):
        """FL-39c: direct test of m4e8994_set_field_forward (original 0x4e8994)"""
        self.check('test_m4e8994_set_field_forward')

    def test_4eb8fe_destroy_vector(self):
        """FL-39c: direct test of m4eb8fe_destroy_vector (original 0x4eb8fe)"""
        self.check('test_m4eb8fe_destroy_vector')

    def test_4ebd2e_set_field_forward(self):
        """FL-39c: direct test of m4ebd2e_set_field_forward (original 0x4ebd2e)"""
        self.check('test_m4ebd2e_set_field_forward')

    def test_4fcd4d_forward_word(self):
        """FL-39c: direct test of m4fcd4d_forward_word (original 0x4fcd4d)"""
        self.check('test_m4fcd4d_forward_word')

    def test_4fcd69_forward_word(self):
        """FL-39c: direct test of m4fcd69_forward_word (original 0x4fcd69)"""
        self.check('test_m4fcd69_forward_word')

    def test_4fcd85_forward_word(self):
        """FL-39c: direct test of m4fcd85_forward_word (original 0x4fcd85)"""
        self.check('test_m4fcd85_forward_word')
