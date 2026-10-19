"""FL-25 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl25a.c.

tests/fl25a_direct_test.c links src/original_methods_fl25a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl25a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl25a_direct_test.c'
KERNELS = ['original_methods_fl25a.c']
EXPECTED = [
    'test_m45e1ca_hit_test',
    'test_m464792_hit_test',
    'test_m4a835c_hit_test',
    'test_sweep_bounded',
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


class Fl25aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl25a_direct_test'
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

    def test_45e1ca_hit_test(self):
        """FL-25a: direct test of m45e1ca_hit_test"""
        self.check('test_m45e1ca_hit_test')

    def test_464792_hit_test(self):
        """FL-25a: direct test of m464792_hit_test"""
        self.check('test_m464792_hit_test')

    def test_4a835c_hit_test(self):
        """FL-25a: direct test of m4a835c_hit_test"""
        self.check('test_m4a835c_hit_test')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-25a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
