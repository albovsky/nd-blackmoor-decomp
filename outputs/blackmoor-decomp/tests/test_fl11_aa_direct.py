"""FL-11: direct C test of write_alarm, the native form of the raw 0xaa Alarm Clock helper (original 0x44d946).

tests/fl11_aa_direct_test.c includes src/action_family_aa_runtime.c as a translation unit and calls write_alarm directly.
It prints one PASS/FAIL line.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
TEST_C = PROJECT / 'tests/fl11_aa_direct_test.c'
EXPECTED = ['test_write_alarm']


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class FlElevenAaDirectTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl11_aa_direct_test'
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

    def test_write_alarm(self):
        """FL-11: direct test of write_alarm (original 0x44d946)"""
        self.assertIn('test_write_alarm', self.results)
        self.assertEqual(self.results['test_write_alarm'], ('PASS', ''), self.results['test_write_alarm'])
        self.assertEqual(self.returncode, 0)

    def test_all_cases_reported(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))
        self.assertEqual(self.returncode, 0)


if __name__ == '__main__':
    unittest.main()
