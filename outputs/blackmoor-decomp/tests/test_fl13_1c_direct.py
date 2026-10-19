"""FL-13: direct test of the entry search of the raw 0x1c interactive video kernel.

tests/fl13_1c_direct_test.c includes src/action_family_1c_runtime.c and calls the static helper; this module builds it and
checks one PASS line per original function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl13_1c_direct_test.c'


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def build(output, test_c=TEST_C, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', f'-I{src_dir}',
           str(test_c), '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl13OneCDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        binary = Path(cls.tmp.name) / 'fl13_1c_direct'
        built = build(binary)
        assert built.returncode == 0, built.stderr
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
        cls.code = done.returncode
        cls.results = {}
        for line in done.stdout.splitlines():
            status, _, rest = line.partition(' ')
            if status in ('PASS', 'FAIL'):
                name, _, message = rest.partition(': ')
                cls.results[name] = (status, message)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def check(self, name):
        self.assertIn(name, self.results)
        status, message = self.results[name]
        self.assertEqual(status, 'PASS', message)

    def test_find_entry_0x4cb944(self):
        """FL-13: direct test of find_entry (original 0x4cb944)."""
        self.check('find_entry')

    def test_all_cases_ran_and_exit_zero(self):
        """FL-13: every direct case printed a result and the binary exited 0."""
        self.assertEqual(len(self.results), 1)
        self.assertEqual(self.code, 0)


if __name__ == '__main__':
    unittest.main()
