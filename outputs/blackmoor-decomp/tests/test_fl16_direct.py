"""FL-16: direct C tests of the small GAME.EXE methods in src/original_methods_fl16.c.

tests/fl16_direct_test.c links src/original_methods_fl16.c and prints one PASS/FAIL line per case; every method below checks
one of them. Expected values come from the original's pseudocode and disassembly, not from the native code.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl16_direct_test.c'
KERNELS = ['original_methods_fl16.c']
EXPECTED = [
    'test_m4234c8_depth_reset',
    'test_m423000_init_pair',
    'test_m423097_clear_table',
    'test_m47d77d_noop',
    'test_m4ee5cd_get_global',
    'test_m4f709c_get_ready',
    'test_m4edf96_set_value',
    'test_m493a47_zero',
    'test_m434773_is_data_tag',
    'test_m4347b8_read_be32',
    'test_m43f04b_copy_rows',
    'test_m44d9b5_shift_rect',
    'test_m45b568_shift_rect',
    'test_m47e25a_reset_fields',
    'test_m4bedb5_clear_state',
    'test_m4bede7_clear_state',
    'test_m4bedfa_close_and_clear',
    'test_m4bf38c_clear_2c0',
    'test_m4c0c18_get_22a',
    'test_m4c0c2c_get_240',
    'test_m4c0c54_get_244',
    'test_m4c0c69_get_24a',
    'test_m4d3c31_get_1c',
    'test_m4e76d5_clear_991',
    'test_m4e76ed_clear_991',
    'test_m4e7ba7_view_reset',
    'test_m42e560_save_block',
    'test_m4d3d20_stamp_tick',
    'test_m4b8e42_expire_slot',
    'test_m4d3c42_set_flag',
    'test_m4e7786_forward',
    'test_m4faf98_visit',
    'test_m4ccfbd_release_surface',
    'test_m4ccd70_construct',
    'test_m4e7728_open',
    'test_m4e7757_close',
]


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


def build(output, test_c=TEST_C, src_dir=SRC, extra=()):
    cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', *extra, f'-I{src_dir}', str(test_c),
           *[str(src_dir / name) for name in KERNELS], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl16Direct(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl16_direct_test'
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

    def test_depth_reset_4234c8(self):
        """FL-16: direct test of m4234c8_depth_reset (original 0x4234c8)"""
        self.check('test_m4234c8_depth_reset')

    def test_init_pair_423000(self):
        """FL-16: direct test of m423000_init_pair (original 0x423000)"""
        self.check('test_m423000_init_pair')

    def test_clear_table_423097(self):
        """FL-16: direct test of m423097_clear_table (original 0x423097)"""
        self.check('test_m423097_clear_table')

    def test_noop_47d77d(self):
        """FL-16: direct test of m47d77d_noop (original 0x47d77d)"""
        self.check('test_m47d77d_noop')

    def test_get_global_4ee5cd(self):
        """FL-16: direct test of m4ee5cd_get_global (original 0x4ee5cd)"""
        self.check('test_m4ee5cd_get_global')

    def test_get_ready_4f709c(self):
        """FL-16: direct test of m4f709c_get_ready (original 0x4f709c)"""
        self.check('test_m4f709c_get_ready')

    def test_set_value_4edf96(self):
        """FL-16: direct test of m4edf96_set_value (original 0x4edf96)"""
        self.check('test_m4edf96_set_value')

    def test_zero_493a47(self):
        """FL-16: direct test of m493a47_zero (original 0x493a47)"""
        self.check('test_m493a47_zero')

    def test_is_data_tag_434773(self):
        """FL-16: direct test of m434773_is_data_tag (original 0x434773)"""
        self.check('test_m434773_is_data_tag')

    def test_read_be32_4347b8(self):
        """FL-16: direct test of m4347b8_read_be32 (original 0x4347b8)"""
        self.check('test_m4347b8_read_be32')

    def test_copy_rows_43f04b(self):
        """FL-16: direct test of m43f04b_copy_rows (original 0x43f04b)"""
        self.check('test_m43f04b_copy_rows')

    def test_shift_rect_44d9b5(self):
        """FL-16: direct test of m44d9b5_shift_rect (original 0x44d9b5)"""
        self.check('test_m44d9b5_shift_rect')

    def test_shift_rect_45b568(self):
        """FL-16: direct test of m45b568_shift_rect (original 0x45b568)"""
        self.check('test_m45b568_shift_rect')

    def test_reset_fields_47e25a(self):
        """FL-16: direct test of m47e25a_reset_fields (original 0x47e25a)"""
        self.check('test_m47e25a_reset_fields')

    def test_clear_state_4bedb5(self):
        """FL-16: direct test of m4bedb5_clear_state (original 0x4bedb5)"""
        self.check('test_m4bedb5_clear_state')

    def test_clear_state_4bede7(self):
        """FL-16: direct test of m4bede7_clear_state (original 0x4bede7)"""
        self.check('test_m4bede7_clear_state')

    def test_close_and_clear_4bedfa(self):
        """FL-16: direct test of m4bedfa_close_and_clear (original 0x4bedfa)"""
        self.check('test_m4bedfa_close_and_clear')

    def test_clear_2c0_4bf38c(self):
        """FL-16: direct test of m4bf38c_clear_2c0 (original 0x4bf38c)"""
        self.check('test_m4bf38c_clear_2c0')

    def test_get_22a_4c0c18(self):
        """FL-16: direct test of m4c0c18_get_22a (original 0x4c0c18)"""
        self.check('test_m4c0c18_get_22a')

    def test_get_240_4c0c2c(self):
        """FL-16: direct test of m4c0c2c_get_240 (original 0x4c0c2c)"""
        self.check('test_m4c0c2c_get_240')

    def test_get_244_4c0c54(self):
        """FL-16: direct test of m4c0c54_get_244 (original 0x4c0c54)"""
        self.check('test_m4c0c54_get_244')

    def test_get_24a_4c0c69(self):
        """FL-16: direct test of m4c0c69_get_24a (original 0x4c0c69)"""
        self.check('test_m4c0c69_get_24a')

    def test_get_1c_4d3c31(self):
        """FL-16: direct test of m4d3c31_get_1c (original 0x4d3c31)"""
        self.check('test_m4d3c31_get_1c')

    def test_clear_991_4e76d5(self):
        """FL-16: direct test of m4e76d5_clear_991 (original 0x4e76d5)"""
        self.check('test_m4e76d5_clear_991')

    def test_clear_991_4e76ed(self):
        """FL-16: direct test of m4e76ed_clear_991 (original 0x4e76ed)"""
        self.check('test_m4e76ed_clear_991')

    def test_view_reset_4e7ba7(self):
        """FL-16: direct test of m4e7ba7_view_reset (original 0x4e7ba7)"""
        self.check('test_m4e7ba7_view_reset')

    def test_save_block_42e560(self):
        """FL-16: direct test of m42e560_save_block (original 0x42e560)"""
        self.check('test_m42e560_save_block')

    def test_stamp_tick_4d3d20(self):
        """FL-16: direct test of m4d3d20_stamp_tick (original 0x4d3d20)"""
        self.check('test_m4d3d20_stamp_tick')

    def test_expire_slot_4b8e42(self):
        """FL-16: direct test of m4b8e42_expire_slot (original 0x4b8e42)"""
        self.check('test_m4b8e42_expire_slot')

    def test_set_flag_4d3c42(self):
        """FL-16: direct test of m4d3c42_set_flag (original 0x4d3c42)"""
        self.check('test_m4d3c42_set_flag')

    def test_forward_4e7786(self):
        """FL-16: direct test of m4e7786_forward (original 0x4e7786)"""
        self.check('test_m4e7786_forward')

    def test_visit_4faf98(self):
        """FL-16: direct test of m4faf98_visit (original 0x4faf98)"""
        self.check('test_m4faf98_visit')

    def test_release_surface_4ccfbd(self):
        """FL-16: direct test of m4ccfbd_release_surface (original 0x4ccfbd)"""
        self.check('test_m4ccfbd_release_surface')

    def test_construct_4ccd70(self):
        """FL-16: direct test of m4ccd70_construct (original 0x4ccd70)"""
        self.check('test_m4ccd70_construct')

    def test_open_4e7728(self):
        """FL-16: direct test of m4e7728_open (original 0x4e7728)"""
        self.check('test_m4e7728_open')

    def test_close_4e7757(self):
        """FL-16: direct test of m4e7757_close (original 0x4e7757)"""
        self.check('test_m4e7757_close')


if __name__ == '__main__':
    unittest.main()
