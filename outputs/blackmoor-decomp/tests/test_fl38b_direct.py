"""FL-38 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl38b.c.

tests/fl38b_direct_test.c links src/original_methods_fl38b.c and prints one PASS/FAIL line per case; every test below checks one of them. Expected values come from the original's
disassembly, not from the native code. One direct case per function; the Unicorn comparison against the original bytes is in tests/test_fl38b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl38b_direct_test.c'
KERNELS = ['original_methods_fl38b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl38b_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_exact_size_buffers']


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


class Fl38bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl38b_direct_test'
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

    def test_44d1d1_clone_record(self):
        """FL-38b: direct test of m44d1d1_clone_record (original 0x44d1d1)"""
        self.check('test_m44d1d1_clone_record')

    def test_456fb6_clone_record(self):
        """FL-38b: direct test of m456fb6_clone_record (original 0x456fb6)"""
        self.check('test_m456fb6_clone_record')

    def test_45807c_clone_record(self):
        """FL-38b: direct test of m45807c_clone_record (original 0x45807c)"""
        self.check('test_m45807c_clone_record')

    def test_464100_clone_record(self):
        """FL-38b: direct test of m464100_clone_record (original 0x464100)"""
        self.check('test_m464100_clone_record')

    def test_465bde_clone_record(self):
        """FL-38b: direct test of m465bde_clone_record (original 0x465bde)"""
        self.check('test_m465bde_clone_record')

    def test_46b79a_clone_record(self):
        """FL-38b: direct test of m46b79a_clone_record (original 0x46b79a)"""
        self.check('test_m46b79a_clone_record')

    def test_47314b_clone_record(self):
        """FL-38b: direct test of m47314b_clone_record (original 0x47314b)"""
        self.check('test_m47314b_clone_record')

    def test_4782db_clone_record(self):
        """FL-38b: direct test of m4782db_clone_record (original 0x4782db)"""
        self.check('test_m4782db_clone_record')

    def test_475964_clone_record(self):
        """FL-38b: direct test of m475964_clone_record (original 0x475964)"""
        self.check('test_m475964_clone_record')

    def test_44fbe3_clone_record(self):
        """FL-38b: direct test of m44fbe3_clone_record (original 0x44fbe3)"""
        self.check('test_m44fbe3_clone_record')

    def test_467688_clone_record(self):
        """FL-38b: direct test of m467688_clone_record (original 0x467688)"""
        self.check('test_m467688_clone_record')

    def test_468f9f_clone_record(self):
        """FL-38b: direct test of m468f9f_clone_record (original 0x468f9f)"""
        self.check('test_m468f9f_clone_record')

    def test_47e477_clone_record(self):
        """FL-38b: direct test of m47e477_clone_record (original 0x47e477)"""
        self.check('test_m47e477_clone_record')

    def test_44e8a2_clone_record(self):
        """FL-38b: direct test of m44e8a2_clone_record (original 0x44e8a2)"""
        self.check('test_m44e8a2_clone_record')

    def test_454e70_clone_record(self):
        """FL-38b: direct test of m454e70_clone_record (original 0x454e70)"""
        self.check('test_m454e70_clone_record')

    def test_459c10_clone_record(self):
        """FL-38b: direct test of m459c10_clone_record (original 0x459c10)"""
        self.check('test_m459c10_clone_record')

    def test_45ddd0_clone_record(self):
        """FL-38b: direct test of m45ddd0_clone_record (original 0x45ddd0)"""
        self.check('test_m45ddd0_clone_record')

    def test_47b3f0_clone_record(self):
        """FL-38b: direct test of m47b3f0_clone_record (original 0x47b3f0)"""
        self.check('test_m47b3f0_clone_record')

    def test_exact_size_buffers(self):
        """FL-38b: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')


if __name__ == '__main__':
    unittest.main()
