"""FL-31 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl31b.c.

tests/fl31b_direct_test.c links src/original_methods_fl31b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl31b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl31b_direct_test.c'
KERNELS = ['original_methods_fl31b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl31b_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_sweep_bounded']


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


class Fl31bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl31b_direct_test'
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

    def test_4c946b_call_slot(self):
        """FL-31b: direct test of m4c946b_call_slot (original 0x4c946b)"""
        self.check('test_m4c946b_call_slot')

    def test_4ee673_forward_if_set(self):
        """FL-31b: direct test of m4ee673_forward_if_set (original 0x4ee673)"""
        self.check('test_m4ee673_forward_if_set')

    def test_4daeb5_read_cursor(self):
        """FL-31b: direct test of m4daeb5_read_cursor (original 0x4daeb5)"""
        self.check('test_m4daeb5_read_cursor')

    def test_4dadff_poll_keys(self):
        """FL-31b: direct test of m4dadff_poll_keys (original 0x4dadff)"""
        self.check('test_m4dadff_poll_keys')

    def test_420b9e_report_name(self):
        """FL-31b: direct test of m420b9e_report_name (original 0x420b9e)"""
        self.check('test_m420b9e_report_name')

    def test_47d1c3_alloc_zeroed(self):
        """FL-31b: direct test of m47d1c3_alloc_zeroed (original 0x47d1c3)"""
        self.check('test_m47d1c3_alloc_zeroed')

    def test_4fc878_activate_record(self):
        """FL-31b: direct test of m4fc878_activate_record (original 0x4fc878)"""
        self.check('test_m4fc878_activate_record')

    def test_47d4f7_reset_fields(self):
        """FL-31b: direct test of m47d4f7_reset_fields (original 0x47d4f7)"""
        self.check('test_m47d4f7_reset_fields')

    def test_47d59b_release_fields(self):
        """FL-31b: direct test of m47d59b_release_fields (original 0x47d59b)"""
        self.check('test_m47d59b_release_fields')

    def test_sweep_bounded(self):
        """FL-31b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
