"""FL-27 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl27b.c.

tests/fl27b_direct_test.c links src/original_methods_fl27b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl27b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl27b_direct_test.c'
KERNELS = ['original_methods_fl27b.c']
EXPECTED = [
    'test_m449bff_resume_thread',
    'test_m449a94_stop_thread',
    'test_m4bf773_release_player',
    'test_m4161d1_alloc_buffers',
    'test_m4c2c3a_make_record',
    'test_m4c0d3f_present_rect',
    'test_m4c5377_blit_rows',
    'test_m4c04e3_start_movie',
    'test_m415db9_unpack',
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


class Fl27bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl27b_direct_test'
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

    def test_449bff_resume_thread(self):
        """FL-27b: direct test of m449bff_resume_thread"""
        self.check('test_m449bff_resume_thread')

    def test_449a94_stop_thread(self):
        """FL-27b: direct test of m449a94_stop_thread"""
        self.check('test_m449a94_stop_thread')

    def test_4bf773_release_player(self):
        """FL-27b: direct test of m4bf773_release_player"""
        self.check('test_m4bf773_release_player')

    def test_4161d1_alloc_buffers(self):
        """FL-27b: direct test of m4161d1_alloc_buffers"""
        self.check('test_m4161d1_alloc_buffers')

    def test_4c2c3a_make_record(self):
        """FL-27b: direct test of m4c2c3a_make_record"""
        self.check('test_m4c2c3a_make_record')

    def test_4c0d3f_present_rect(self):
        """FL-27b: direct test of m4c0d3f_present_rect"""
        self.check('test_m4c0d3f_present_rect')

    def test_4c5377_blit_rows(self):
        """FL-27b: direct test of m4c5377_blit_rows"""
        self.check('test_m4c5377_blit_rows')

    def test_4c04e3_start_movie(self):
        """FL-27b: direct test of m4c04e3_start_movie"""
        self.check('test_m4c04e3_start_movie')

    def test_415db9_unpack(self):
        """FL-27b: direct test of m415db9_unpack"""
        self.check('test_m415db9_unpack')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-27b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
