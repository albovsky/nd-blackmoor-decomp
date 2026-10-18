"""FL-11: direct C tests of the static raw 0xda kernel helpers reset_work, step_check and caption_pick.

tests/fl11_da_direct_test.c includes src/action_family_da_runtime.c as a translation unit and calls the static functions of the
original GAME.EXE routines 0x45ba0b, 0x45bcc1 and 0x45be7f directly. It prints one PASS/FAIL line per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl11_da_direct_test.c'
EXPECTED = ['test_reset_work', 'test_step_check', 'test_caption_pick']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlElevenDaDirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl11_da_direct_test'
        cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(TEST_C),
               '-o', str(binary)]
        built = subprocess.run(cmd, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        done = subprocess.run([str(binary)], capture_output=True, text=True)
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

    def test_reset_work(self):
        """FL-11: direct test of reset_work (original 0x45ba0b)"""
        self.check('test_reset_work')

    def test_step_check(self):
        """FL-11: direct test of step_check (original 0x45bcc1)"""
        self.check('test_step_check')

    def test_caption_pick(self):
        """FL-11: direct test of caption_pick (original 0x45be7f)"""
        self.check('test_caption_pick')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
