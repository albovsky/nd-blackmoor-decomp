"""FL-11: direct C tests of the static raw 0xf5 kernel functions clock_update, score_update, pick_char, pick_position and first_wave.

tests/fl11_f5_direct_test.c includes src/action_family_f5_runtime.c as a translation unit and calls the static functions of the
original GAME.EXE routines 0x4b832c, 0x4b844d, 0x4b85f6, 0x4b866e and 0x4b8783 directly. It prints one PASS/FAIL line per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl11_f5_direct_test.c'
STD_C = PROJECT / 'src/score_time_display.c'  # the shared display the kernel stores the score and clock in
EXPECTED = ['test_clock_update', 'test_score_update', 'test_pick_char', 'test_pick_position', 'test_first_wave']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlElevenF5DirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl11_f5_direct_test'
        cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(TEST_C), str(STD_C), '-lm',
               '-o', str(binary)]
        built = subprocess.run(cmd, capture_output=True, text=True)
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
        self.assertEqual(self.returncode, 0)

    def test_clock_update(self):
        """FL-11: direct test of clock_update (original 0x4b832c)"""
        self.check('test_clock_update')

    def test_score_update(self):
        """FL-11: direct test of score_update (original 0x4b844d)"""
        self.check('test_score_update')

    def test_pick_char(self):
        """FL-11: direct test of pick_char (original 0x4b85f6)"""
        self.check('test_pick_char')

    def test_pick_position(self):
        """FL-11: direct test of pick_position (original 0x4b866e)"""
        self.check('test_pick_position')

    def test_first_wave(self):
        """FL-11: direct test of first_wave (original 0x4b8783)"""
        self.check('test_first_wave')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
