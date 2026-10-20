"""FL-29 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl29a.c.

tests/fl29a_direct_test.c links src/original_methods_fl29a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl29a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl29a_direct_test.c'
KERNELS = ['original_methods_fl29a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl29a_fixtures as fx
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


class Fl29aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl29a_direct_test'
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

    def test_4d39f9_find_free_entry(self):
        """FL-29a: direct test of m4d39f9_find_free_entry (original 0x4d39f9)"""
        self.check('test_m4d39f9_find_free_entry')

    def test_4c4202_check_vtable_call(self):
        """FL-29a: direct test of m4c4202_check_vtable_call (original 0x4c4202)"""
        self.check('test_m4c4202_check_vtable_call')

    def test_4c948f_find_free_slot(self):
        """FL-29a: direct test of m4c948f_find_free_slot (original 0x4c948f)"""
        self.check('test_m4c948f_find_free_slot')

    def test_4d3992_clear_entry(self):
        """FL-29a: direct test of m4d3992_clear_entry (original 0x4d3992)"""
        self.check('test_m4d3992_clear_entry')

    def test_4c92c5_count_down(self):
        """FL-29a: direct test of m4c92c5_count_down (original 0x4c92c5)"""
        self.check('test_m4c92c5_count_down')

    def test_4c9340_scan_surface(self):
        """FL-29a: direct test of m4c9340_scan_surface (original 0x4c9340)"""
        self.check('test_m4c9340_scan_surface')

    def test_4c46d1_fill_surface(self):
        """FL-29a: direct test of m4c46d1_fill_surface (original 0x4c46d1)"""
        self.check('test_m4c46d1_fill_surface')

    def test_4cb9d1_relocate_entries(self):
        """FL-29a: direct test of m4cb9d1_relocate_entries (original 0x4cb9d1)"""
        self.check('test_m4cb9d1_relocate_entries')

    def test_4895cc_init_buffer(self):
        """FL-29a: direct test of m4895cc_init_buffer (original 0x4895cc)"""
        self.check('test_m4895cc_init_buffer')

    def test_4c3efb_lock_surface(self):
        """FL-29a: direct test of m4c3efb_lock_surface (original 0x4c3efb)"""
        self.check('test_m4c3efb_lock_surface')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-29a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
