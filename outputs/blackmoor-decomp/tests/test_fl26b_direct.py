"""FL-26 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl26b.c.

tests/fl26b_direct_test.c links src/original_methods_fl26b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl26b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl26b_direct_test.c'
KERNELS = ['original_methods_fl26b.c']
EXPECTED = [
    'test_m423fbb_leaf_word',
    'test_m4eb107_item_use_feedback',
    'test_m42406d_propagate',
    'test_m424201_walk',
    'test_m42ea87_record_state',
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


class Fl26bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl26b_direct_test'
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

    def test_423fbb_leaf_word(self):
        """FL-26b: direct test of m423fbb_leaf_word"""
        self.check('test_m423fbb_leaf_word')

    def test_4eb107_item_use_feedback(self):
        """FL-26b: direct test of m4eb107_item_use_feedback"""
        self.check('test_m4eb107_item_use_feedback')

    def test_42406d_propagate(self):
        """FL-26b: direct test of m42406d_propagate"""
        self.check('test_m42406d_propagate')

    def test_424201_walk(self):
        """FL-26b: direct test of m424201_walk"""
        self.check('test_m424201_walk')

    def test_42ea87_record_state(self):
        """FL-26b: direct test of m42ea87_record_state"""
        self.check('test_m42ea87_record_state')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-26b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
