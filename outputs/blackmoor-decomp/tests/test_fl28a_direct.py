"""FL-28 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl28a.c.

tests/fl28a_direct_test.c links src/original_methods_fl28a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch c); the Unicorn comparison against the original bytes is in
tests/test_fl28a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl28a_direct_test.c'
KERNELS = ['original_methods_fl28a.c']
EXPECTED = [
    'test_m4235fd_pop',
    'test_m4fc808_clear_slot',
    'test_m4237f7_new_block',
    'test_m4236d6_new_block',
    'test_m4f80d3_play_retry',
    'test_m42356d_push',
    'test_m4fb2e3_start_slot',
    'test_m423368_hash_name',
    'test_m4f356e_unload',
    'test_m4fadc4_set_name',
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


class Fl28aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl28a_direct_test'
        built = build(binary)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=120)
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

    def test_4235fd_pop(self):
        """FL-28a: direct test of m4235fd_pop"""
        self.check('test_m4235fd_pop')

    def test_4fc808_clear_slot(self):
        """FL-28a: direct test of m4fc808_clear_slot"""
        self.check('test_m4fc808_clear_slot')

    def test_4237f7_new_block(self):
        """FL-28a: direct test of m4237f7_new_block"""
        self.check('test_m4237f7_new_block')

    def test_4236d6_new_block(self):
        """FL-28a: direct test of m4236d6_new_block"""
        self.check('test_m4236d6_new_block')

    def test_4f80d3_play_retry(self):
        """FL-28a: direct test of m4f80d3_play_retry"""
        self.check('test_m4f80d3_play_retry')

    def test_42356d_push(self):
        """FL-28a: direct test of m42356d_push"""
        self.check('test_m42356d_push')

    def test_4fb2e3_start_slot(self):
        """FL-28a: direct test of m4fb2e3_start_slot"""
        self.check('test_m4fb2e3_start_slot')

    def test_423368_hash_name(self):
        """FL-28a: direct test of m423368_hash_name"""
        self.check('test_m423368_hash_name')

    def test_4f356e_unload(self):
        """FL-28a: direct test of m4f356e_unload"""
        self.check('test_m4f356e_unload')

    def test_4fadc4_set_name(self):
        """FL-28a: direct test of m4fadc4_set_name"""
        self.check('test_m4fadc4_set_name')

    def test_sweep_bounded(self):
        """FL-28a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
