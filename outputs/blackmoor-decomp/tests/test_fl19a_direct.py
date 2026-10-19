"""FL-19 batch a: direct C tests of the GAME.EXE methods in src/original_methods_fl19a.c.

tests/fl19a_direct_test.c links src/original_methods_fl19a.c (and the FL-18/17/16 sources its header builds on) and prints one PASS/FAIL
line per case; every test below checks one of them. Expected values come from the original's disassembly, not from the native code.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl19a_direct_test.c'
KERNELS = ['original_methods_fl19a.c']
EXPECTED = [
    'test_m4ceb3b_reset_state',
    'test_m423f57_load_entry',
    'test_m4cecf7_init_descriptor',
    'test_m4ea269_select_piece',
    'test_m4ccdab_reset_object',
    'test_m47e2a5_release_surfaces',
    'test_m423259_find_by_name',
    'test_m4e89eb_layout_slots',
    'test_m4e444d_find_name',
    'test_m4b617a_arm_piece',
    'test_m4ccff5_free_piece',
    'test_m48d1e8_hit_test',
    'test_m475da4_hit_test',
    'test_m4ee2a9_hit_slots',
    'test_m48bd91_hit_test',
    ]


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


def build(output, test_c=TEST_C, src_dir=SRC, kernels=KERNELS, extra=()):
    cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', *extra, f'-I{src_dir}', str(test_c),
           *[str(src_dir / name) for name in kernels], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl19aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl19a_direct_test'
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

    def test_reset_state_4ceb3b(self):
        """FL-19: direct test of m4ceb3b_reset_state (original 0x4ceb3b)"""
        self.check('test_m4ceb3b_reset_state')

    def test_load_entry_423f57(self):
        """FL-19: direct test of m423f57_load_entry (original 0x423f57)"""
        self.check('test_m423f57_load_entry')

    def test_init_descriptor_4cecf7(self):
        """FL-19: direct test of m4cecf7_init_descriptor (original 0x4cecf7)"""
        self.check('test_m4cecf7_init_descriptor')

    def test_select_piece_4ea269(self):
        """FL-19: direct test of m4ea269_select_piece (original 0x4ea269)"""
        self.check('test_m4ea269_select_piece')

    def test_reset_object_4ccdab(self):
        """FL-19: direct test of m4ccdab_reset_object (original 0x4ccdab)"""
        self.check('test_m4ccdab_reset_object')

    def test_release_surfaces_47e2a5(self):
        """FL-19: direct test of m47e2a5_release_surfaces (original 0x47e2a5)"""
        self.check('test_m47e2a5_release_surfaces')

    def test_find_by_name_423259(self):
        """FL-19: direct test of m423259_find_by_name (original 0x423259)"""
        self.check('test_m423259_find_by_name')

    def test_layout_slots_4e89eb(self):
        """FL-19: direct test of m4e89eb_layout_slots (original 0x4e89eb)"""
        self.check('test_m4e89eb_layout_slots')

    def test_find_name_4e444d(self):
        """FL-19: direct test of m4e444d_find_name (original 0x4e444d)"""
        self.check('test_m4e444d_find_name')

    def test_arm_piece_4b617a(self):
        """FL-19: direct test of m4b617a_arm_piece (original 0x4b617a)"""
        self.check('test_m4b617a_arm_piece')

    def test_free_piece_4ccff5(self):
        """FL-19: direct test of m4ccff5_free_piece (original 0x4ccff5)"""
        self.check('test_m4ccff5_free_piece')

    def test_hit_test_48d1e8(self):
        """FL-19: direct test of m48d1e8_hit_test (original 0x48d1e8)"""
        self.check('test_m48d1e8_hit_test')

    def test_hit_test_475da4(self):
        """FL-19: direct test of m475da4_hit_test (original 0x475da4)"""
        self.check('test_m475da4_hit_test')

    def test_hit_slots_4ee2a9(self):
        """FL-19: direct test of m4ee2a9_hit_slots (original 0x4ee2a9)"""
        self.check('test_m4ee2a9_hit_slots')

    def test_hit_test_48bd91(self):
        """FL-19: direct test of m48bd91_hit_test (original 0x48bd91)"""
        self.check('test_m48bd91_hit_test')


if __name__ == '__main__':
    unittest.main()
