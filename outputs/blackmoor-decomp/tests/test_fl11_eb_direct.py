"""FL-11: direct C tests of the static raw 0xeb kernel helpers translate, follow_pointer, rotate_piece and multi_pick.

tests/fl11_eb_direct_test.c includes src/action_family_eb_runtime.c as a translation unit and calls the static functions of the
original GAME.EXE routines 0x47e52f, 0x47f275, 0x47fa11 and 0x47fb76 directly. It prints one PASS/FAIL line per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl11_eb_direct_test.c'
EXPECTED = ['test_translate', 'test_follow_pointer', 'test_rotate_piece', 'test_multi_pick']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlElevenEbDirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl11_eb_direct_test'
        cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(TEST_C), '-lm',
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

    def test_translate(self):
        """FL-11: direct test of translate (original 0x47e52f)"""
        self.check('test_translate')

    def test_follow_pointer(self):
        """FL-11: direct test of follow_pointer (original 0x47f275)"""
        self.check('test_follow_pointer')

    def test_rotate_piece(self):
        """FL-11: direct test of rotate_piece (original 0x47fa11)"""
        self.check('test_rotate_piece')

    def test_multi_pick(self):
        """FL-11: direct test of multi_pick (original 0x47fb76)"""
        self.check('test_multi_pick')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
