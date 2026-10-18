"""FL-11: direct C tests of type_is, grid_setup, cell_rect and solved_scan, the native forms of the raw 0xd3 helpers.

tests/fl11_d3_direct_test.c includes src/action_family_d3_runtime.c as a translation unit and calls the static functions
directly with synthetic bodies. It prints one PASS/FAIL line per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl11_d3_direct_test.c'
EXPECTED = ['test_cell_rect', 'test_grid_setup', 'test_solved_scan', 'test_type_is']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlElevenD3DirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl11_d3_direct_test'
        cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(TEST_C), '-lm',
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

    def test_type_is(self):
        """FL-11: direct test of type_is (original 0x461d4b)"""
        self.check('test_type_is')

    def test_grid_setup(self):
        """FL-11: direct test of grid_setup (original 0x462577)"""
        self.check('test_grid_setup')

    def test_cell_rect(self):
        """FL-11: direct test of cell_rect (original 0x462b84)"""
        self.check('test_cell_rect')

    def test_solved_scan(self):
        """FL-11: direct test of solved_scan (original 0x4632bf)"""
        self.check('test_solved_scan')

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
