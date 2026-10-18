"""FL-18: direct C tests of the small GAME.EXE methods in src/original_methods_fl18.c.

tests/fl18_direct_test.c links src/original_methods_fl18.c (and the FL-16 methods it calls) and prints one PASS/FAIL line per
case; every method below checks one of them. Expected values come from the original's disassembly, not from the native code.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl18_direct_test.c'
KERNELS = ['original_methods_fl18.c', 'original_methods_fl17.c', 'original_methods_fl16.c']
EXPECTED = [
    'test_m4c924d_count_up',
    'test_m4121b8_start_piece',
    'test_m4e7bf3_close_slots',
    'test_m4b7051_draw_list',
    'test_m4b7f3b_reset',
    'test_m4b7ff4_release',
    'test_m4e7253_store_record',
    'test_m4e8dc8_check_slots',
    'test_m45b7a8_arm_hotspot',
    'test_m4b81ff_hit_test',
    'test_m423b51_reset_record',
    'test_m4cc79a_draw_rects',
    'test_m4b6097_arm_hotspot',
    'test_m4b8d5e_expire_slots',
    'test_m410f99_init_entry',
    'test_m44d624_arm_timer',
    'test_m4631d1_check_piece',
    'test_m41632b_free_buffers',
    'test_m4c08d3_shift_rects',
    'test_m4c0774_open_piece',
    'test_m4d07e7_draw_texts',
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


class Fl18Direct(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl18_direct_test'
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

    def test_count_up_4c924d(self):
        """FL-18: direct test of m4c924d_count_up (original 0x4c924d)"""
        self.check('test_m4c924d_count_up')

    def test_start_piece_4121b8(self):
        """FL-18: direct test of m4121b8_start_piece (original 0x4121b8)"""
        self.check('test_m4121b8_start_piece')

    def test_close_slots_4e7bf3(self):
        """FL-18: direct test of m4e7bf3_close_slots (original 0x4e7bf3)"""
        self.check('test_m4e7bf3_close_slots')

    def test_draw_list_4b7051(self):
        """FL-18: direct test of m4b7051_draw_list (original 0x4b7051)"""
        self.check('test_m4b7051_draw_list')

    def test_reset_4b7f3b(self):
        """FL-18: direct test of m4b7f3b_reset (original 0x4b7f3b)"""
        self.check('test_m4b7f3b_reset')

    def test_release_4b7ff4(self):
        """FL-18: direct test of m4b7ff4_release (original 0x4b7ff4)"""
        self.check('test_m4b7ff4_release')

    def test_store_record_4e7253(self):
        """FL-18: direct test of m4e7253_store_record (original 0x4e7253)"""
        self.check('test_m4e7253_store_record')

    def test_check_slots_4e8dc8(self):
        """FL-18: direct test of m4e8dc8_check_slots (original 0x4e8dc8)"""
        self.check('test_m4e8dc8_check_slots')

    def test_arm_hotspot_45b7a8(self):
        """FL-18: direct test of m45b7a8_arm_hotspot (original 0x45b7a8)"""
        self.check('test_m45b7a8_arm_hotspot')

    def test_hit_test_4b81ff(self):
        """FL-18: direct test of m4b81ff_hit_test (original 0x4b81ff)"""
        self.check('test_m4b81ff_hit_test')

    def test_reset_record_423b51(self):
        """FL-18: direct test of m423b51_reset_record (original 0x423b51)"""
        self.check('test_m423b51_reset_record')

    def test_draw_rects_4cc79a(self):
        """FL-18: direct test of m4cc79a_draw_rects (original 0x4cc79a)"""
        self.check('test_m4cc79a_draw_rects')

    def test_arm_hotspot_4b6097(self):
        """FL-18: direct test of m4b6097_arm_hotspot (original 0x4b6097)"""
        self.check('test_m4b6097_arm_hotspot')

    def test_expire_slots_4b8d5e(self):
        """FL-18: direct test of m4b8d5e_expire_slots (original 0x4b8d5e)"""
        self.check('test_m4b8d5e_expire_slots')

    def test_init_entry_410f99(self):
        """FL-18: direct test of m410f99_init_entry (original 0x410f99)"""
        self.check('test_m410f99_init_entry')

    def test_arm_timer_44d624(self):
        """FL-18: direct test of m44d624_arm_timer (original 0x44d624)"""
        self.check('test_m44d624_arm_timer')

    def test_check_piece_4631d1(self):
        """FL-18: direct test of m4631d1_check_piece (original 0x4631d1)"""
        self.check('test_m4631d1_check_piece')

    def test_free_buffers_41632b(self):
        """FL-18: direct test of m41632b_free_buffers (original 0x41632b)"""
        self.check('test_m41632b_free_buffers')

    def test_shift_rects_4c08d3(self):
        """FL-18: direct test of m4c08d3_shift_rects (original 0x4c08d3)"""
        self.check('test_m4c08d3_shift_rects')

    def test_open_piece_4c0774(self):
        """FL-18: direct test of m4c0774_open_piece (original 0x4c0774)"""
        self.check('test_m4c0774_open_piece')

    def test_draw_texts_4d07e7(self):
        """FL-18: direct test of m4d07e7_draw_texts (original 0x4d07e7)"""
        self.check('test_m4d07e7_draw_texts')


if __name__ == '__main__':
    unittest.main()
