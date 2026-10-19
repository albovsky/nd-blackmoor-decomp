"""FL-27 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl27a.c.

tests/fl27a_direct_test.c links src/original_methods_fl27a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl27a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl27a_direct_test.c'
KERNELS = ['original_methods_fl27a.c']
EXPECTED = [
    'test_m4de1f5_clear_flags',
    'test_m4de214_clear_flags_thunk',
    'test_m4de2d8_reset_caption',
    'test_m449d90_file_exists',
    'test_m44c479_wait_state',
    'test_m4bee2c_get_field',
    'test_m4bef85_bink_wait',
    'test_m4bee5f_bink_summary',
    'test_m4befc8_bink_do_frame',
    'test_m4bef11_bink_goto',
    'test_m4bf098_bink_copy_to_buffer',
    'test_m4bf10f_bink_next',
    # EXPECTED-END
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


class Fl27aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl27a_direct_test'
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

    def test_4de1f5_clear_flags(self):
        """FL-27a: direct test of m4de1f5_clear_flags"""
        self.check('test_m4de1f5_clear_flags')

    def test_4de214_clear_flags_thunk(self):
        """FL-27a: direct test of m4de214_clear_flags_thunk"""
        self.check('test_m4de214_clear_flags_thunk')

    def test_4de2d8_reset_caption(self):
        """FL-27a: direct test of m4de2d8_reset_caption"""
        self.check('test_m4de2d8_reset_caption')

    def test_449d90_file_exists(self):
        """FL-27a: direct test of m449d90_file_exists"""
        self.check('test_m449d90_file_exists')

    def test_44c479_wait_state(self):
        """FL-27a: direct test of m44c479_wait_state"""
        self.check('test_m44c479_wait_state')

    def test_4bee2c_get_field(self):
        """FL-27a: direct test of m4bee2c_get_field"""
        self.check('test_m4bee2c_get_field')

    def test_4bef85_bink_wait(self):
        """FL-27a: direct test of m4bef85_bink_wait"""
        self.check('test_m4bef85_bink_wait')

    def test_4bee5f_bink_summary(self):
        """FL-27a: direct test of m4bee5f_bink_summary"""
        self.check('test_m4bee5f_bink_summary')

    def test_4befc8_bink_do_frame(self):
        """FL-27a: direct test of m4befc8_bink_do_frame"""
        self.check('test_m4befc8_bink_do_frame')

    def test_4bef11_bink_goto(self):
        """FL-27a: direct test of m4bef11_bink_goto"""
        self.check('test_m4bef11_bink_goto')

    def test_4bf098_bink_copy_to_buffer(self):
        """FL-27a: direct test of m4bf098_bink_copy_to_buffer"""
        self.check('test_m4bf098_bink_copy_to_buffer')

    def test_4bf10f_bink_next(self):
        """FL-27a: direct test of m4bf10f_bink_next"""
        self.check('test_m4bf10f_bink_next')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-27a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
