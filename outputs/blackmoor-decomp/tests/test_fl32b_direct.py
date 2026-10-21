"""FL-32 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl32b.c.

tests/fl32b_direct_test.c links src/original_methods_fl32b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl32b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl32b_direct_test.c'
KERNELS = ['original_methods_fl32b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl32b_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_exact_size_buffers', 'test_sweep_bounded']


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


class Fl32bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl32b_direct_test'
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

    def test_every_case_ran_and_the_binary_passed(self):
        self.assertEqual(sorted(self.results), sorted(EXPECTED))
        self.assertEqual(self.returncode, 0)

    def test_40a613_read_tag_word(self):
        """FL-32b: direct test of m40a613_read_tag_word (original 0x40a613)"""
        self.check('test_m40a613_read_tag_word')

    def test_40a665_read_tag_word(self):
        """FL-32b: direct test of m40a665_read_tag_word (original 0x40a665)"""
        self.check('test_m40a665_read_tag_word')

    def test_4a9f27_reset_fields(self):
        """FL-32b: direct test of m4a9f27_reset_fields (original 0x4a9f27)"""
        self.check('test_m4a9f27_reset_fields')

    def test_4b71f7_reset_fields(self):
        """FL-32b: direct test of m4b71f7_reset_fields (original 0x4b71f7)"""
        self.check('test_m4b71f7_reset_fields')

    def test_4781fa_reset_fields(self):
        """FL-32b: direct test of m4781fa_reset_fields (original 0x4781fa)"""
        self.check('test_m4781fa_reset_fields')

    def test_4afd3a_reset_fields(self):
        """FL-32b: direct test of m4afd3a_reset_fields (original 0x4afd3a)"""
        self.check('test_m4afd3a_reset_fields')

    def test_4e04f3_reset_fields(self):
        """FL-32b: direct test of m4e04f3_reset_fields (original 0x4e04f3)"""
        self.check('test_m4e04f3_reset_fields')

    def test_454565_cross_product(self):
        """FL-32b: direct test of m454565_cross_product (original 0x454565)"""
        self.check('test_m454565_cross_product')

    def test_4a638a_reset_fields(self):
        """FL-32b: direct test of m4a638a_reset_fields (original 0x4a638a)"""
        self.check('test_m4a638a_reset_fields')

    # CASES-END

    def test_exact_size_buffers(self):
        """FL-32b: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')

    def test_sweep_bounded(self):
        """FL-32b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
