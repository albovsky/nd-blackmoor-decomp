"""FL-39 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl39b.c.

tests/fl39b_direct_test.c links src/original_methods_fl39b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39b_direct_test.c'
KERNELS = ['original_methods_fl39b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39b_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS]


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


class Fl39bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39b_direct_test'
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

    def test_484110_clone_record(self):
        """FL-39b: direct test of m484110_clone_record (original 0x484110)"""
        self.check('test_m484110_clone_record')

    def test_487bd7_clone_record(self):
        """FL-39b: direct test of m487bd7_clone_record (original 0x487bd7)"""
        self.check('test_m487bd7_clone_record')

    def test_48a865_clone_record(self):
        """FL-39b: direct test of m48a865_clone_record (original 0x48a865)"""
        self.check('test_m48a865_clone_record')

    def test_48d12d_clone_record(self):
        """FL-39b: direct test of m48d12d_clone_record (original 0x48d12d)"""
        self.check('test_m48d12d_clone_record')

    def test_493b7a_clone_record(self):
        """FL-39b: direct test of m493b7a_clone_record (original 0x493b7a)"""
        self.check('test_m493b7a_clone_record')

    def test_4a3a33_clone_record(self):
        """FL-39b: direct test of m4a3a33_clone_record (original 0x4a3a33)"""
        self.check('test_m4a3a33_clone_record')

    def test_4a64b9_clone_record(self):
        """FL-39b: direct test of m4a64b9_clone_record (original 0x4a64b9)"""
        self.check('test_m4a64b9_clone_record')

    def test_4a7e50_clone_record(self):
        """FL-39b: direct test of m4a7e50_clone_record (original 0x4a7e50)"""
        self.check('test_m4a7e50_clone_record')

    def test_4ab46d_clone_record(self):
        """FL-39b: direct test of m4ab46d_clone_record (original 0x4ab46d)"""
        self.check('test_m4ab46d_clone_record')

    def test_4acbf1_clone_record(self):
        """FL-39b: direct test of m4acbf1_clone_record (original 0x4acbf1)"""
        self.check('test_m4acbf1_clone_record')

    def test_4afe09_clone_record(self):
        """FL-39b: direct test of m4afe09_clone_record (original 0x4afe09)"""
        self.check('test_m4afe09_clone_record')

    def test_4b3ddf_clone_record(self):
        """FL-39b: direct test of m4b3ddf_clone_record (original 0x4b3ddf)"""
        self.check('test_m4b3ddf_clone_record')

    def test_4b72cf_clone_record(self):
        """FL-39b: direct test of m4b72cf_clone_record (original 0x4b72cf)"""
        self.check('test_m4b72cf_clone_record')

    def test_4b80d9_clone_record(self):
        """FL-39b: direct test of m4b80d9_clone_record (original 0x4b80d9)"""
        self.check('test_m4b80d9_clone_record')

    def test_4ba2bd_clone_record(self):
        """FL-39b: direct test of m4ba2bd_clone_record (original 0x4ba2bd)"""
        self.check('test_m4ba2bd_clone_record')

    def test_4e9a2c_clone_record(self):
        """FL-39b: direct test of m4e9a2c_clone_record (original 0x4e9a2c)"""
        self.check('test_m4e9a2c_clone_record')

    def test_4e9add_clone_record(self):
        """FL-39b: direct test of m4e9add_clone_record (original 0x4e9add)"""
        self.check('test_m4e9add_clone_record')

    def test_4e9b87_clone_record(self):
        """FL-39b: direct test of m4e9b87_clone_record (original 0x4e9b87)"""
        self.check('test_m4e9b87_clone_record')

    def test_4e9cdf_clone_record(self):
        """FL-39b: direct test of m4e9cdf_clone_record (original 0x4e9cdf)"""
        self.check('test_m4e9cdf_clone_record')

    def test_4fcda1_clone_record(self):
        """FL-39b: direct test of m4fcda1_clone_record (original 0x4fcda1)"""
        self.check('test_m4fcda1_clone_record')
