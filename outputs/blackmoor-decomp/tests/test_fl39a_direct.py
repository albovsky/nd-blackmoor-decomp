"""FL-39 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl39a.c.

tests/fl39a_direct_test.c links src/original_methods_fl39a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39a_direct_test.c'
KERNELS = ['original_methods_fl39a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39a_fixtures as fx
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


class Fl39aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39a_direct_test'
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

    def test_48220e_mark_entry(self):
        """FL-39a: direct test of m48220e_mark_entry (original 0x48220e)"""
        self.check('test_m48220e_mark_entry')

    def test_487b4f_release_entry(self):
        """FL-39a: direct test of m487b4f_release_entry (original 0x487b4f)"""
        self.check('test_m487b4f_release_entry')

    def test_487b98_mark_entry(self):
        """FL-39a: direct test of m487b98_mark_entry (original 0x487b98)"""
        self.check('test_m487b98_mark_entry')

    def test_48a7e5_release_entry(self):
        """FL-39a: direct test of m48a7e5_release_entry (original 0x48a7e5)"""
        self.check('test_m48a7e5_release_entry')

    def test_48a82e_mark_entry(self):
        """FL-39a: direct test of m48a82e_mark_entry (original 0x48a82e)"""
        self.check('test_m48a82e_mark_entry')

    def test_48e393_mark_entry(self):
        """FL-39a: direct test of m48e393_mark_entry (original 0x48e393)"""
        self.check('test_m48e393_mark_entry')

    def test_490547_destroy_with_frame(self):
        """FL-39a: direct test of m490547_destroy_with_frame (original 0x490547)"""
        self.check('test_m490547_destroy_with_frame')

    def test_493a10_mark_entry(self):
        """FL-39a: direct test of m493a10_mark_entry (original 0x493a10)"""
        self.check('test_m493a10_mark_entry')

    def test_49c59f_destroy_with_frame(self):
        """FL-39a: direct test of m49c59f_destroy_with_frame (original 0x49c59f)"""
        self.check('test_m49c59f_destroy_with_frame')

    def test_4a1ce0_mark_entry(self):
        """FL-39a: direct test of m4a1ce0_mark_entry (original 0x4a1ce0)"""
        self.check('test_m4a1ce0_mark_entry')

    def test_4a3910_mark_entry(self):
        """FL-39a: direct test of m4a3910_mark_entry (original 0x4a3910)"""
        self.check('test_m4a3910_mark_entry')

    def test_4a6477_mark_entry(self):
        """FL-39a: direct test of m4a6477_mark_entry (original 0x4a6477)"""
        self.check('test_m4a6477_mark_entry')

    def test_4a7da5_mark_entry(self):
        """FL-39a: direct test of m4a7da5_mark_entry (original 0x4a7da5)"""
        self.check('test_m4a7da5_mark_entry')

    def test_4a9fcb_mark_entry(self):
        """FL-39a: direct test of m4a9fcb_mark_entry (original 0x4a9fcb)"""
        self.check('test_m4a9fcb_mark_entry')

    def test_4ab3dc_release_entry(self):
        """FL-39a: direct test of m4ab3dc_release_entry (original 0x4ab3dc)"""
        self.check('test_m4ab3dc_release_entry')

    def test_4ab425_mark_entry(self):
        """FL-39a: direct test of m4ab425_mark_entry (original 0x4ab425)"""
        self.check('test_m4ab425_mark_entry')

    def test_4acbba_mark_entry(self):
        """FL-39a: direct test of m4acbba_mark_entry (original 0x4acbba)"""
        self.check('test_m4acbba_mark_entry')

    def test_4afd7e_release_entry(self):
        """FL-39a: direct test of m4afd7e_release_entry (original 0x4afd7e)"""
        self.check('test_m4afd7e_release_entry')

    def test_4afdc7_mark_entry(self):
        """FL-39a: direct test of m4afdc7_mark_entry (original 0x4afdc7)"""
        self.check('test_m4afdc7_mark_entry')

    def test_4b3d4d_release_entry(self):
        """FL-39a: direct test of m4b3d4d_release_entry (original 0x4b3d4d)"""
        self.check('test_m4b3d4d_release_entry')

    def test_4b3da2_mark_entry(self):
        """FL-39a: direct test of m4b3da2_mark_entry (original 0x4b3da2)"""
        self.check('test_m4b3da2_mark_entry')

    def test_4b7229_release_entry(self):
        """FL-39a: direct test of m4b7229_release_entry (original 0x4b7229)"""
        self.check('test_m4b7229_release_entry')

    def test_4b7272_mark_entry(self):
        """FL-39a: direct test of m4b7272_mark_entry (original 0x4b7272)"""
        self.check('test_m4b7272_mark_entry')

    def test_4ba22e_mark_entry(self):
        """FL-39a: direct test of m4ba22e_mark_entry (original 0x4ba22e)"""
        self.check('test_m4ba22e_mark_entry')

    def test_4cafc1_mark_entry(self):
        """FL-39a: direct test of m4cafc1_mark_entry (original 0x4cafc1)"""
        self.check('test_m4cafc1_mark_entry')

    def test_4dbf6e_destroy_with_frame(self):
        """FL-39a: direct test of m4dbf6e_destroy_with_frame (original 0x4dbf6e)"""
        self.check('test_m4dbf6e_destroy_with_frame')

    def test_4de1a4_destroy_with_frame(self):
        """FL-39a: direct test of m4de1a4_destroy_with_frame (original 0x4de1a4)"""
        self.check('test_m4de1a4_destroy_with_frame')

    def test_4e7684_destroy_with_frame(self):
        """FL-39a: direct test of m4e7684_destroy_with_frame (original 0x4e7684)"""
        self.check('test_m4e7684_destroy_with_frame')
