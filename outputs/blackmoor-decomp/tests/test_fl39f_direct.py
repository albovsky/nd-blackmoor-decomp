"""FL-39 (batch f): direct C tests of the GAME.EXE functions in src/original_methods_fl39f.c.

tests/fl39f_direct_test.c links src/original_methods_fl39f.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39f_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39f_direct_test.c'
KERNELS = ['original_methods_fl39f.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39f_fixtures as fx
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


class Fl39fDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39f_direct_test'
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

    def test_48ef40_advance_slot(self):
        """FL-39f: direct test of m48ef40_advance_slot (original 0x48ef40)"""
        self.check('test_m48ef40_advance_slot')

    def test_4904fa_construct_record(self):
        """FL-39f: direct test of m4904fa_construct_record (original 0x4904fa)"""
        self.check('test_m4904fa_construct_record')

    def test_49192b_clear_block(self):
        """FL-39f: direct test of m49192b_clear_block (original 0x49192b)"""
        self.check('test_m49192b_clear_block')

    def test_495608_check_object(self):
        """FL-39f: direct test of m495608_check_object (original 0x495608)"""
        self.check('test_m495608_check_object')

    def test_49c53a_construct_record(self):
        """FL-39f: direct test of m49c53a_construct_record (original 0x49c53a)"""
        self.check('test_m49c53a_construct_record')

    def test_49cf80_fill_cells(self):
        """FL-39f: direct test of m49cf80_fill_cells (original 0x49cf80)"""
        self.check('test_m49cf80_fill_cells')

    def test_4a0c7f_count_nonempty(self):
        """FL-39f: direct test of m4a0c7f_count_nonempty (original 0x4a0c7f)"""
        self.check('test_m4a0c7f_count_nonempty')

    def test_4ac8da_init_record(self):
        """FL-39f: direct test of m4ac8da_init_record (original 0x4ac8da)"""
        self.check('test_m4ac8da_init_record')

    def test_4beeb3_bind_buffer(self):
        """FL-39f: direct test of m4beeb3_bind_buffer (original 0x4beeb3)"""
        self.check('test_m4beeb3_bind_buffer')

    def test_4c9cdd_find_zero_record(self):
        """FL-39f: direct test of m4c9cdd_find_zero_record (original 0x4c9cdd)"""
        self.check('test_m4c9cdd_find_zero_record')

    def test_4d52b9_init_record(self):
        """FL-39f: direct test of m4d52b9_init_record (original 0x4d52b9)"""
        self.check('test_m4d52b9_init_record')

    def test_4d6ad1_start_timer(self):
        """FL-39f: direct test of m4d6ad1_start_timer (original 0x4d6ad1)"""
        self.check('test_m4d6ad1_start_timer')

    def test_4d8f0a_release_list(self):
        """FL-39f: direct test of m4d8f0a_release_list (original 0x4d8f0a)"""
        self.check('test_m4d8f0a_release_list')

    def test_4dc13f_copy_counted(self):
        """FL-39f: direct test of m4dc13f_copy_counted (original 0x4dc13f)"""
        self.check('test_m4dc13f_copy_counted')

    def test_4de5f0_construct_record(self):
        """FL-39f: direct test of m4de5f0_construct_record (original 0x4de5f0)"""
        self.check('test_m4de5f0_construct_record')

    def test_4e0410_construct_record(self):
        """FL-39f: direct test of m4e0410_construct_record (original 0x4e0410)"""
        self.check('test_m4e0410_construct_record')

    def test_4e069c_copy_in(self):
        """FL-39f: direct test of m4e069c_copy_in (original 0x4e069c)"""
        self.check('test_m4e069c_copy_in')

    def test_4e1c50_construct_record(self):
        """FL-39f: direct test of m4e1c50_construct_record (original 0x4e1c50)"""
        self.check('test_m4e1c50_construct_record')

    def test_4e4428_copy_in(self):
        """FL-39f: direct test of m4e4428_copy_in (original 0x4e4428)"""
        self.check('test_m4e4428_copy_in')

    def test_4e498d_set_name(self):
        """FL-39f: direct test of m4e498d_set_name (original 0x4e498d)"""
        self.check('test_m4e498d_set_name')

    def test_4e7a70_construct_record(self):
        """FL-39f: direct test of m4e7a70_construct_record (original 0x4e7a70)"""
        self.check('test_m4e7a70_construct_record')

    def test_4eb77d_fill_name_table(self):
        """FL-39f: direct test of m4eb77d_fill_name_table (original 0x4eb77d)"""
        self.check('test_m4eb77d_fill_name_table')

    def test_4eb870_construct_record(self):
        """FL-39f: direct test of m4eb870_construct_record (original 0x4eb870)"""
        self.check('test_m4eb870_construct_record')

    def test_4ec005_copy_checked(self):
        """FL-39f: direct test of m4ec005_copy_checked (original 0x4ec005)"""
        self.check('test_m4ec005_copy_checked')

    def test_4fa8d2_check_name(self):
        """FL-39f: direct test of m4fa8d2_check_name (original 0x4fa8d2)"""
        self.check('test_m4fa8d2_check_name')

    def test_4fa980_construct_record(self):
        """FL-39f: direct test of m4fa980_construct_record (original 0x4fa980)"""
        self.check('test_m4fa980_construct_record')
