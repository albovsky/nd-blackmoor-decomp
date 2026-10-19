"""FL-25 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl25c.c.

tests/fl25c_direct_test.c links src/original_methods_fl25c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the handlers of batch c); the Unicorn comparison against the original bytes is in
tests/test_fl25c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl25c_direct_test.c'
KERNELS = ['original_methods_fl25c.c']
EXPECTED = [
    'test_m4a8818_click_2798_279a',
    'test_m4aa3d2_click_276f_2771',
    'test_m46c6a9_click_27e2_27ea',
    'test_m4a44c0_click_274c_274f',
    # EXPECTED-END
]


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


def build(output, test_c=TEST_C, src_dir=SRC, extra=()):
    cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-ffp-contract=off', '-g', *extra, f'-I{src_dir}', str(test_c),
           *[str(src_dir / name) for name in KERNELS], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


class Fl25cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl25c_direct_test'
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


    def test_4a8818_click_2798_279a(self):
        """FL-25c: direct test of m4a8818_click_2798_279a"""
        self.check('test_m4a8818_click_2798_279a')

    def test_4aa3d2_click_276f_2771(self):
        """FL-25c: direct test of m4aa3d2_click_276f_2771"""
        self.check('test_m4aa3d2_click_276f_2771')

    def test_46c6a9_click_27e2_27ea(self):
        """FL-25c: direct test of m46c6a9_click_27e2_27ea"""
        self.check('test_m46c6a9_click_27e2_27ea')

    def test_4a44c0_click_274c_274f(self):
        """FL-25c: direct test of m4a44c0_click_274c_274f"""
        self.check('test_m4a44c0_click_274c_274f')

    # DIRECT-TESTS-END


if __name__ == '__main__':
    unittest.main()
