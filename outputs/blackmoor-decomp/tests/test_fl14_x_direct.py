"""FL-14 group x: direct C tests of the score / time display setters and resets, the typing quiz key / click / invalidate /
new-game reset / character helper, the password character filter, the scene restore saver and the 0xd0 / 0xd1 invalidate methods.

tests/fl14_x_direct_test.c includes src/action_family_f5_runtime.c as a translation unit (for the static char_allowed) and is
linked with the other kernels it calls; it prints one PASS/FAIL line per case.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl14_x_direct_test.c'
KERNELS = ['score_time_display.c', 'action_family_76_runtime.c', 'action_family_7d_runtime.c', 'action_family_78_runtime.c', 'action_family_79_runtime.c', 'action_family_d0_runtime.c',
           'action_family_d1_runtime.c']
EXPECTED = ['test_std_reset_score', 'test_std_reset_clock', 'test_std_enable_score', 'test_std_enable_clock',
            'test_std_set_score', 'test_std_set_clock', 'test_tqz_world_new_game', 'test_tqz_invalidate', 'test_tqz_key',
            'test_tqz_click', 'test_char_allowed', 'test_pwd_char_accepted', 'test_scene_restore_slot_save',
            'test_d1_invalidate', 'test_d0_invalidate']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


def build(output, test_c=TEST_C, src_dir=SRC):
    cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', f'-I{src_dir}', str(test_c),
           *[str(src_dir / name) for name in KERNELS], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl14XDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl14_x_direct_test'
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

    def test_std_reset_score_445f53(self):
        """FL-14: direct test of std_reset_score (original 0x445f53)"""
        self.check('test_std_reset_score')

    def test_std_reset_clock_445fc5(self):
        """FL-14: direct test of std_reset_clock (original 0x445fc5)"""
        self.check('test_std_reset_clock')

    def test_std_enable_score_446532(self):
        """FL-14: direct test of std_enable_score (original 0x446532)"""
        self.check('test_std_enable_score')

    def test_std_enable_clock_446548(self):
        """FL-14: direct test of std_enable_clock (original 0x446548)"""
        self.check('test_std_enable_clock')

    def test_std_set_score_44655e(self):
        """FL-14: direct test of std_set_score (original 0x44655e; the native bounds guard is native-only)"""
        self.check('test_std_set_score')

    def test_std_set_clock_446598(self):
        """FL-14: direct test of std_set_clock (original 0x446598; the native bounds guard is native-only)"""
        self.check('test_std_set_clock')

    def test_tqz_world_new_game_4b8087(self):
        """FL-14: direct test of tqz_world_new_game (original 0x4b8087)"""
        self.check('test_tqz_world_new_game')

    def test_tqz_invalidate_4b80a5(self):
        """FL-14: direct test of tqz_invalidate (original 0x4b80a5)"""
        self.check('test_tqz_invalidate')

    def test_tqz_key_4b8193(self):
        """FL-14: direct test of tqz_key (original 0x4b8193)"""
        self.check('test_tqz_key')

    def test_tqz_click_4b82cd(self):
        """FL-14: direct test of tqz_click (original 0x4b82cd)"""
        self.check('test_tqz_click')

    def test_char_allowed_4b8520(self):
        """FL-14: direct test of char_allowed (original 0x4b8520)"""
        self.check('test_char_allowed')

    def test_pwd_char_accepted_437ea1(self):
        """FL-14: direct test of pwd_char_accepted (original 0x437ea1)"""
        self.check('test_pwd_char_accepted')

    def test_scene_restore_slot_save_4eb70f(self):
        """FL-14: direct test of scene_restore_slot_save (original 0x4eb70f)"""
        self.check('test_scene_restore_slot_save')

    def test_d1_invalidate_4b5c11(self):
        """FL-14: direct test of d1_invalidate (original 0x4b5c11)"""
        self.check('test_d1_invalidate')

    def test_d0_invalidate_48d0e5(self):
        """FL-14: direct test of d0_invalidate (original 0x48d0e5)"""
        self.check('test_d0_invalidate')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
