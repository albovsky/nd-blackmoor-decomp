"""FL-33 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl33a.c.

tests/fl33a_direct_test.c links src/original_methods_fl33a.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the eight ported functions of batch a); the Unicorn comparison against the original bytes is in
tests/test_fl33a_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl33a_direct_test.c'
KERNELS = ['original_methods_fl33a.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl33a_fixtures as fx
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


class Fl33aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl33a_direct_test'
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

    def test_4dae88_set_cursor(self):
        """FL-33a: direct test of m4dae88_set_cursor (original 0x4dae88)"""
        self.check('test_m4dae88_set_cursor')

    def test_473117_mark_entry(self):
        """FL-33a: direct test of m473117_mark_entry (original 0x473117)"""
        self.check('test_m473117_mark_entry')

    def test_4234dd_push_pair(self):
        """FL-33a: direct test of m4234dd_push_pair (original 0x4234dd)"""
        self.check('test_m4234dd_push_pair')

    def test_4c7623_draw_frame(self):
        """FL-33a: direct test of m4c7623_draw_frame (original 0x4c7623)"""
        self.check('test_m4c7623_draw_frame')

    def test_4bf3b8_set_text(self):
        """FL-33a: direct test of m4bf3b8_set_text (original 0x4bf3b8)"""
        self.check('test_m4bf3b8_set_text')

    def test_4db993_move_cursor(self):
        """FL-33a: direct test of m4db993_move_cursor (original 0x4db993)"""
        self.check('test_m4db993_move_cursor')

    def test_47d24e_report_fields(self):
        """FL-33a: direct test of m47d24e_report_fields (original 0x47d24e)"""
        self.check('test_m47d24e_report_fields')

    def test_4c7070_rotate_image(self):
        """FL-33a: direct test of m4c7070_rotate_image (original 0x4c7070)"""
        self.check('test_m4c7070_rotate_image')

    def test_sweep_bounded(self):
        """FL-33a: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
