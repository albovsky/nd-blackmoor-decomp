"""FL-17: direct C tests of the small GAME.EXE methods in src/original_methods_fl17.c.

tests/fl17_direct_test.c links src/original_methods_fl17.c (and the FL-16 methods it calls) and prints one PASS/FAIL line per
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
TEST_C = PROJECT / 'tests/fl17_direct_test.c'
KERNELS = ['original_methods_fl17.c', 'original_methods_fl16.c']
EXPECTED = [
    'test_m424035_selected_slot',
    'test_m42405a_get_control',
    'test_m42ca22_apply_event_flags',
    'test_m4d36ed_set_flags',
    'test_m4cd218_destruct',
    'test_m4fba69_forward_word',
    'test_m4fc05d_forward_global',
    'test_m4e303b_close',
    'test_m4e7d04_close',
    'test_m4eb96e_close',
    'test_m4caf8a_reset',
    'test_m4cf749_notify',
    'test_m48c0ac_accept_piece',
    'test_m415011_close_handles',
    'test_m4eac4c_use_item',
    'test_m48d067_cleanup',
    'test_m461827_cleanup',
    'test_m4b5b8a_cleanup',
    'test_m45b3ea_cleanup',
    'test_m483f6a_cleanup',
    'test_m44d107_cleanup',
    'test_m44d154_begin_scene',
    'test_m45b42e_begin_scene',
    'test_m461862_begin_scene',
    'test_m48d09c_begin_scene',
    'test_m4b5bc8_begin_scene',
    'test_m47591f_clear_block',
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


class Fl17Direct(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl17_direct_test'
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

    def test_selected_slot_424035(self):
        """FL-17: direct test of m424035_selected_slot (original 0x424035)"""
        self.check('test_m424035_selected_slot')

    def test_get_control_42405a(self):
        """FL-17: direct test of m42405a_get_control (original 0x42405a)"""
        self.check('test_m42405a_get_control')

    def test_apply_event_flags_42ca22(self):
        """FL-17: direct test of m42ca22_apply_event_flags (original 0x42ca22)"""
        self.check('test_m42ca22_apply_event_flags')

    def test_set_flags_4d36ed(self):
        """FL-17: direct test of m4d36ed_set_flags (original 0x4d36ed)"""
        self.check('test_m4d36ed_set_flags')

    def test_destruct_4cd218(self):
        """FL-17: direct test of m4cd218_destruct (original 0x4cd218)"""
        self.check('test_m4cd218_destruct')

    def test_forward_word_4fba69(self):
        """FL-17: direct test of m4fba69_forward_word (original 0x4fba69)"""
        self.check('test_m4fba69_forward_word')

    def test_forward_global_4fc05d(self):
        """FL-17: direct test of m4fc05d_forward_global (original 0x4fc05d)"""
        self.check('test_m4fc05d_forward_global')

    def test_close_4e303b(self):
        """FL-17: direct test of m4e303b_close (original 0x4e303b)"""
        self.check('test_m4e303b_close')

    def test_close_4e7d04(self):
        """FL-17: direct test of m4e7d04_close (original 0x4e7d04)"""
        self.check('test_m4e7d04_close')

    def test_close_4eb96e(self):
        """FL-17: direct test of m4eb96e_close (original 0x4eb96e)"""
        self.check('test_m4eb96e_close')

    def test_reset_4caf8a(self):
        """FL-17: direct test of m4caf8a_reset (original 0x4caf8a)"""
        self.check('test_m4caf8a_reset')

    def test_notify_4cf749(self):
        """FL-17: direct test of m4cf749_notify (original 0x4cf749)"""
        self.check('test_m4cf749_notify')

    def test_accept_piece_48c0ac(self):
        """FL-17: direct test of m48c0ac_accept_piece (original 0x48c0ac)"""
        self.check('test_m48c0ac_accept_piece')

    def test_close_handles_415011(self):
        """FL-17: direct test of m415011_close_handles (original 0x415011)"""
        self.check('test_m415011_close_handles')

    def test_use_item_4eac4c(self):
        """FL-17: direct test of m4eac4c_use_item (original 0x4eac4c)"""
        self.check('test_m4eac4c_use_item')

    def test_cleanup_48d067(self):
        """FL-17: direct test of m48d067_cleanup (original 0x48d067)"""
        self.check('test_m48d067_cleanup')

    def test_cleanup_461827(self):
        """FL-17: direct test of m461827_cleanup (original 0x461827)"""
        self.check('test_m461827_cleanup')

    def test_cleanup_4b5b8a(self):
        """FL-17: direct test of m4b5b8a_cleanup (original 0x4b5b8a)"""
        self.check('test_m4b5b8a_cleanup')

    def test_cleanup_45b3ea(self):
        """FL-17: direct test of m45b3ea_cleanup (original 0x45b3ea)"""
        self.check('test_m45b3ea_cleanup')

    def test_cleanup_483f6a(self):
        """FL-17: direct test of m483f6a_cleanup (original 0x483f6a)"""
        self.check('test_m483f6a_cleanup')

    def test_cleanup_44d107(self):
        """FL-17: direct test of m44d107_cleanup (original 0x44d107)"""
        self.check('test_m44d107_cleanup')

    def test_begin_scene_44d154(self):
        """FL-17: direct test of m44d154_begin_scene (original 0x44d154)"""
        self.check('test_m44d154_begin_scene')

    def test_begin_scene_45b42e(self):
        """FL-17: direct test of m45b42e_begin_scene (original 0x45b42e)"""
        self.check('test_m45b42e_begin_scene')

    def test_begin_scene_461862(self):
        """FL-17: direct test of m461862_begin_scene (original 0x461862)"""
        self.check('test_m461862_begin_scene')

    def test_begin_scene_48d09c(self):
        """FL-17: direct test of m48d09c_begin_scene (original 0x48d09c)"""
        self.check('test_m48d09c_begin_scene')

    def test_begin_scene_4b5bc8(self):
        """FL-17: direct test of m4b5bc8_begin_scene (original 0x4b5bc8)"""
        self.check('test_m4b5bc8_begin_scene')

    def test_clear_block_47591f(self):
        """FL-17: direct test of m47591f_clear_block (original 0x47591f)"""
        self.check('test_m47591f_clear_block')


if __name__ == '__main__':
    unittest.main()
