"""FL-39 (batch e): direct C tests of the GAME.EXE functions in src/original_methods_fl39e.c.

tests/fl39e_direct_test.c links src/original_methods_fl39e.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39e_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39e_direct_test.c'
KERNELS = ['original_methods_fl39e.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39e_fixtures as fx
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


class Fl39eDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39e_direct_test'
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

    def test_487b1a_init_fields5(self):
        """FL-39e: direct test of m487b1a_init_fields5 (original 0x487b1a)"""
        self.check('test_m487b1a_init_fields5')

    def test_48e2f5_release_word(self):
        """FL-39e: direct test of m48e2f5_release_word (original 0x48e2f5)"""
        self.check('test_m48e2f5_release_word')

    def test_49c5f0_zero_fields11(self):
        """FL-39e: direct test of m49c5f0_zero_fields11 (original 0x49c5f0)"""
        self.check('test_m49c5f0_zero_fields11')

    def test_4a1b12_get_constant(self):
        """FL-39e: direct test of m4a1b12_get_constant (original 0x4a1b12)"""
        self.check('test_m4a1b12_get_constant')

    def test_4a1c47_init_fields11(self):
        """FL-39e: direct test of m4a1c47_init_fields11 (original 0x4a1c47)"""
        self.check('test_m4a1c47_init_fields11')

    def test_4a1cb1_release_word(self):
        """FL-39e: direct test of m4a1cb1_release_word (original 0x4a1cb1)"""
        self.check('test_m4a1cb1_release_word')

    def test_4ab3a7_init_fields5(self):
        """FL-39e: direct test of m4ab3a7_init_fields5 (original 0x4ab3a7)"""
        self.check('test_m4ab3a7_init_fields5')

    def test_4ae452_copy_sub_dword(self):
        """FL-39e: direct test of m4ae452_copy_sub_dword (original 0x4ae452)"""
        self.check('test_m4ae452_copy_sub_dword')

    def test_4ae495_copy_sub_dword(self):
        """FL-39e: direct test of m4ae495_copy_sub_dword (original 0x4ae495)"""
        self.check('test_m4ae495_copy_sub_dword')

    def test_4c87ba_fill_stride(self):
        """FL-39e: direct test of m4c87ba_fill_stride (original 0x4c87ba)"""
        self.check('test_m4c87ba_fill_stride')

    def test_4c8872_fill_stride(self):
        """FL-39e: direct test of m4c8872_fill_stride (original 0x4c8872)"""
        self.check('test_m4c8872_fill_stride')

    def test_4cca42_forward_struct(self):
        """FL-39e: direct test of m4cca42_forward_struct (original 0x4cca42)"""
        self.check('test_m4cca42_forward_struct')

    def test_4cca6f_forward_struct(self):
        """FL-39e: direct test of m4cca6f_forward_struct (original 0x4cca6f)"""
        self.check('test_m4cca6f_forward_struct')

    def test_4ccd25_get_constant(self):
        """FL-39e: direct test of m4ccd25_get_constant (original 0x4ccd25)"""
        self.check('test_m4ccd25_get_constant')

    def test_4d0b68_log_loop(self):
        """FL-39e: direct test of m4d0b68_log_loop (original 0x4d0b68)"""
        self.check('test_m4d0b68_log_loop')

    def test_4d0c57_log_loop(self):
        """FL-39e: direct test of m4d0c57_log_loop (original 0x4d0c57)"""
        self.check('test_m4d0c57_log_loop')

    def test_4d3728_log_three(self):
        """FL-39e: direct test of m4d3728_log_three (original 0x4d3728)"""
        self.check('test_m4d3728_log_three')

    def test_4d37af_log_three(self):
        """FL-39e: direct test of m4d37af_log_three (original 0x4d37af)"""
        self.check('test_m4d37af_log_three')

    def test_4de227_call_pair(self):
        """FL-39e: direct test of m4de227_call_pair (original 0x4de227)"""
        self.check('test_m4de227_call_pair')

    def test_4de413_call_unless_01(self):
        """FL-39e: direct test of m4de413_call_unless_01 (original 0x4de413)"""
        self.check('test_m4de413_call_unless_01')

    def test_4de584_call_unless_01(self):
        """FL-39e: direct test of m4de584_call_unless_01 (original 0x4de584)"""
        self.check('test_m4de584_call_unless_01')

    def test_4de66e_destroy_subobjects(self):
        """FL-39e: direct test of m4de66e_destroy_subobjects (original 0x4de66e)"""
        self.check('test_m4de66e_destroy_subobjects')

    def test_4e053f_set_field_sx(self):
        """FL-39e: direct test of m4e053f_set_field_sx (original 0x4e053f)"""
        self.check('test_m4e053f_set_field_sx')

    def test_4e1113_log_guarded(self):
        """FL-39e: direct test of m4e1113_log_guarded (original 0x4e1113)"""
        self.check('test_m4e1113_log_guarded')

    def test_4e1157_log_guarded(self):
        """FL-39e: direct test of m4e1157_log_guarded (original 0x4e1157)"""
        self.check('test_m4e1157_log_guarded')

    def test_4e7700_call_pair(self):
        """FL-39e: direct test of m4e7700_call_pair (original 0x4e7700)"""
        self.check('test_m4e7700_call_pair')

    def test_4e7a10_call_unless_01(self):
        """FL-39e: direct test of m4e7a10_call_unless_01 (original 0x4e7a10)"""
        self.check('test_m4e7a10_call_unless_01')

    def test_4eda7c_destroy_subobjects(self):
        """FL-39e: direct test of m4eda7c_destroy_subobjects (original 0x4eda7c)"""
        self.check('test_m4eda7c_destroy_subobjects')

    def test_4ee5b8_store_global(self):
        """FL-39e: direct test of m4ee5b8_store_global (original 0x4ee5b8)"""
        self.check('test_m4ee5b8_store_global')

    def test_4ee5dd_store_global(self):
        """FL-39e: direct test of m4ee5dd_store_global (original 0x4ee5dd)"""
        self.check('test_m4ee5dd_store_global')

    def test_4ee616_set_field_sx(self):
        """FL-39e: direct test of m4ee616_set_field_sx (original 0x4ee616)"""
        self.check('test_m4ee616_set_field_sx')

    def test_4f872e_forward_fields(self):
        """FL-39e: direct test of m4f872e_forward_fields (original 0x4f872e)"""
        self.check('test_m4f872e_forward_fields')

    def test_4f88ad_forward_fields(self):
        """FL-39e: direct test of m4f88ad_forward_fields (original 0x4f88ad)"""
        self.check('test_m4f88ad_forward_fields')

    def test_4fc909_check_trace(self):
        """FL-39e: direct test of m4fc909_check_trace (original 0x4fc909)"""
        self.check('test_m4fc909_check_trace')

    def test_4fc97d_check_trace(self):
        """FL-39e: direct test of m4fc97d_check_trace (original 0x4fc97d)"""
        self.check('test_m4fc97d_check_trace')
