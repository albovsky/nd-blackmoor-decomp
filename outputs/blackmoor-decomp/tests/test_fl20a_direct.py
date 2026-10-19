"""FL-20 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl20a.c.

tests/fl20a_direct_test.c links src/original_methods_fl20a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl20a_direct_test.c'
KERNELS = ['original_methods_fl20a.c']
EXPECTED = [
    'test_m4d3c88_clear_flag',
    'test_m4d3c5f_set_ready',
    'test_m41c509_init_fields',
    'test_m43ec4a_forward_4db000',
    'test_m43ec85_forward_4dafc3',
    'test_m43ecc0_forward_4db04f',
    'test_m43ed71_forward_4daf9f',
    'test_m475885_release',
    'test_m4caf03_reset',
    'test_m41c770_init_fields',
    'test_m4757da_clear_grid',
    'test_m48bb86_release',
    'test_m483fb5_release_all',
    'test_m4343a2_find_name',
    'test_m44727a_start_record',
    'test_m42b87a_apply_record',
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


class Fl20aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl20a_direct_test'
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

    def test_clear_flag_4d3c88(self):
        """FL-20a: direct test of m4d3c88_clear_flag (original 0x4d3c88)"""
        self.check('test_m4d3c88_clear_flag')

    def test_set_ready_4d3c5f(self):
        """FL-20a: direct test of m4d3c5f_set_ready (original 0x4d3c5f)"""
        self.check('test_m4d3c5f_set_ready')

    def test_init_fields_41c509(self):
        """FL-20a: direct test of m41c509_init_fields (original 0x41c509)"""
        self.check('test_m41c509_init_fields')

    def test_forward_4db000_43ec4a(self):
        """FL-20a: direct test of m43ec4a_forward_4db000 (original 0x43ec4a)"""
        self.check('test_m43ec4a_forward_4db000')

    def test_forward_4dafc3_43ec85(self):
        """FL-20a: direct test of m43ec85_forward_4dafc3 (original 0x43ec85)"""
        self.check('test_m43ec85_forward_4dafc3')

    def test_forward_4db04f_43ecc0(self):
        """FL-20a: direct test of m43ecc0_forward_4db04f (original 0x43ecc0)"""
        self.check('test_m43ecc0_forward_4db04f')

    def test_forward_4daf9f_43ed71(self):
        """FL-20a: direct test of m43ed71_forward_4daf9f (original 0x43ed71)"""
        self.check('test_m43ed71_forward_4daf9f')

    def test_release_475885(self):
        """FL-20a: direct test of m475885_release (original 0x475885)"""
        self.check('test_m475885_release')

    def test_reset_4caf03(self):
        """FL-20a: direct test of m4caf03_reset (original 0x4caf03)"""
        self.check('test_m4caf03_reset')

    def test_init_fields_41c770(self):
        """FL-20a: direct test of m41c770_init_fields (original 0x41c770)"""
        self.check('test_m41c770_init_fields')

    def test_clear_grid_4757da(self):
        """FL-20a: direct test of m4757da_clear_grid (original 0x4757da)"""
        self.check('test_m4757da_clear_grid')

    def test_release_48bb86(self):
        """FL-20a: direct test of m48bb86_release (original 0x48bb86)"""
        self.check('test_m48bb86_release')

    def test_release_all_483fb5(self):
        """FL-20a: direct test of m483fb5_release_all (original 0x483fb5)"""
        self.check('test_m483fb5_release_all')

    def test_find_name_4343a2(self):
        """FL-20a: direct test of m4343a2_find_name (original 0x4343a2)"""
        self.check('test_m4343a2_find_name')

    def test_start_record_44727a(self):
        """FL-20a: direct test of m44727a_start_record (original 0x44727a)"""
        self.check('test_m44727a_start_record')

    def test_apply_record_42b87a(self):
        """FL-20a: direct test of m42b87a_apply_record (original 0x42b87a)"""
        self.check('test_m42b87a_apply_record')

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
