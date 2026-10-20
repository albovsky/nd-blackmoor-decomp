"""FL-32 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl32c.c.

tests/fl32c_direct_test.c links src/original_methods_fl32c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl32c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl32c_direct_test.c'
KERNELS = ['original_methods_fl32c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl32c_fixtures as fx
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


class Fl32cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl32c_direct_test'
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

    def test_44e78e_release_entry(self):
        """FL-32c: direct test of m44e78e_release_entry (original 0x44e78e)"""
        self.check('test_m44e78e_release_entry')

    def test_44e7d7_mark_entry(self):
        """FL-32c: direct test of m44e7d7_mark_entry (original 0x44e7d7)"""
        self.check('test_m44e7d7_mark_entry')

    def test_44e95b_offset_rect(self):
        """FL-32c: direct test of m44e95b_offset_rect (original 0x44e95b)"""
        self.check('test_m44e95b_offset_rect')

    def test_43edac_default_after_query(self):
        """FL-32c: direct test of m43edac_default_after_query (original 0x43edac)"""
        self.check('test_m43edac_default_after_query')

    def test_43ee69_filter_message(self):
        """FL-32c: direct test of m43ee69_filter_message (original 0x43ee69)"""
        self.check('test_m43ee69_filter_message')

    def test_4db090_normalize_state(self):
        """FL-32c: direct test of m4db090_normalize_state (original 0x4db090)"""
        self.check('test_m4db090_normalize_state')

    def test_4de53e_report(self):
        """FL-32c: direct test of m4de53e_report (original 0x4de53e)"""
        self.check('test_m4de53e_report')

    def test_4ea229_clear_pending(self):
        """FL-32c: direct test of m4ea229_clear_pending (original 0x4ea229)"""
        self.check('test_m4ea229_clear_pending')

    def test_4fb2a6_check_slot(self):
        """FL-32c: direct test of m4fb2a6_check_slot (original 0x4fb2a6)"""
        self.check('test_m4fb2a6_check_slot')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-32c: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
