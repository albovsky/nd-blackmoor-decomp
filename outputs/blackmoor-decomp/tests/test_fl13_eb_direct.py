"""FL-13: direct C tests of the static raw 0xeb kernel helpers top_piece_47e8fe, top_piece_47e9d3, sound_pick_4809a7,
sound_rotate_480abe and sound_good (originals 0x47e8fe, 0x47e9d3, 0x4809a7, 0x480abe, 0x480a1d).

tests/fl13_eb_direct_test.c includes src/action_family_eb_runtime.c as a translation unit and calls the static functions directly,
checking results, host calls and stores against the original pseudocode. One PASS/FAIL line per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl13_eb_direct_test.c'
EXPECTED = ['test_top_piece_47e8fe', 'test_top_piece_47e9d3', 'test_sound_pick_4809a7', 'test_sound_rotate_480abe',
            'test_sound_good_480a1d']


def compiler():
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlThirteenEbDirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl13_eb_direct_test'
        cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(TEST_C),
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

    def test_top_piece_47e8fe(self):
        """FL-13: direct test of top_piece_47e8fe (original 0x47e8fe)"""
        self.check('test_top_piece_47e8fe')

    def test_top_piece_47e9d3(self):
        """FL-13: direct test of top_piece_47e9d3 (original 0x47e9d3)"""
        self.check('test_top_piece_47e9d3')

    def test_sound_pick_4809a7(self):
        """FL-13: direct test of sound_pick_4809a7 (original 0x4809a7)"""
        self.check('test_sound_pick_4809a7')

    def test_sound_rotate_480abe(self):
        """FL-13: direct test of sound_rotate_480abe (original 0x480abe)"""
        self.check('test_sound_rotate_480abe')

    def test_sound_good_480a1d(self):
        """FL-13: direct test of sound_good (original 0x480a1d)"""
        self.check('test_sound_good_480a1d')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
