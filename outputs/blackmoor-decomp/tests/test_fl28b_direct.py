"""FL-28 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl28b.c.

tests/fl28b_direct_test.c links src/original_methods_fl28b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl28b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl28b_direct_test.c'
KERNELS = ['original_methods_fl28b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl28b_fixtures as fx
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


class Fl28bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl28b_direct_test'
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

    def test_41e043_find_free_slot(self):
        """FL-28b: direct test of m41e043_find_free_slot (original 0x41e043)"""
        self.check('test_m41e043_find_free_slot')

    def test_42e493_take_pending(self):
        """FL-28b: direct test of m42e493_take_pending (original 0x42e493)"""
        self.check('test_m42e493_take_pending')

    def test_41de29_clear_slots(self):
        """FL-28b: direct test of m41de29_clear_slots (original 0x41de29)"""
        self.check('test_m41de29_clear_slots')

    def test_41e250_release_slot(self):
        """FL-28b: direct test of m41e250_release_slot (original 0x41e250)"""
        self.check('test_m41e250_release_slot')

    def test_4edfaf_centre_rect(self):
        """FL-28b: direct test of m4edfaf_centre_rect (original 0x4edfaf)"""
        self.check('test_m4edfaf_centre_rect')

    def test_41e0b4_add_slot(self):
        """FL-28b: direct test of m41e0b4_add_slot (original 0x41e0b4)"""
        self.check('test_m41e0b4_add_slot')

    def test_4205c1_run_entries(self):
        """FL-28b: direct test of m4205c1_run_entries (original 0x4205c1)"""
        self.check('test_m4205c1_run_entries')

    def test_4209e8_run_small_entries(self):
        """FL-28b: direct test of m4209e8_run_small_entries (original 0x4209e8)"""
        self.check('test_m4209e8_run_small_entries')

    def test_4f6ef4_advance_record(self):
        """FL-28b: direct test of m4f6ef4_advance_record (original 0x4f6ef4)"""
        self.check('test_m4f6ef4_advance_record')

    def test_41c544_init_record(self):
        """FL-28b: direct test of m41c544_init_record (original 0x41c544)"""
        self.check('test_m41c544_init_record')

    def test_41fa11_add_entry(self):
        """FL-28b: direct test of m41fa11_add_entry (original 0x41fa11)"""
        self.check('test_m41fa11_add_entry')

    def test_422a0a_draw_marked(self):
        """FL-28b: direct test of m422a0a_draw_marked (original 0x422a0a)"""
        self.check('test_m422a0a_draw_marked')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-28b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
