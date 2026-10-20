"""FL-29 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl29b.c.

tests/fl29b_direct_test.c links src/original_methods_fl29b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ported functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl29b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl29b_direct_test.c'
KERNELS = ['original_methods_fl29b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl29b_fixtures as fx
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


class Fl29bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl29b_direct_test'
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

    def test_4ee69e_forward_if_set(self):
        """FL-29b: direct test of m4ee69e_forward_if_set (original 0x4ee69e)"""
        self.check('test_m4ee69e_forward_if_set')

    def test_423aae_chain_end(self):
        """FL-29b: direct test of m423aae_chain_end (original 0x423aae)"""
        self.check('test_m423aae_chain_end')

    def test_4fccf2_store_percent(self):
        """FL-29b: direct test of m4fccf2_store_percent (original 0x4fccf2)"""
        self.check('test_m4fccf2_store_percent')

    def test_423a30_free_cell(self):
        """FL-29b: direct test of m423a30_free_cell (original 0x423a30)"""
        self.check('test_m423a30_free_cell')

    def test_42e72c_toggle_state(self):
        """FL-29b: direct test of m42e72c_toggle_state (original 0x42e72c)"""
        self.check('test_m42e72c_toggle_state')

    def test_4e9c2f_copy_six(self):
        """FL-29b: direct test of m4e9c2f_copy_six (original 0x4e9c2f)"""
        self.check('test_m4e9c2f_copy_six')

    def test_4e45be_find_row(self):
        """FL-29b: direct test of m4e45be_find_row (original 0x4e45be)"""
        self.check('test_m4e45be_find_row')

    def test_437dcd_note_key(self):
        """FL-29b: direct test of m437dcd_note_key (original 0x437dcd)"""
        self.check('test_m437dcd_note_key')

    def test_4e4337_load_blocks(self):
        """FL-29b: direct test of m4e4337_load_blocks (original 0x4e4337)"""
        self.check('test_m4e4337_load_blocks')

    def test_411a22_alloc_copy(self):
        """FL-29b: direct test of m411a22_alloc_copy (original 0x411a22)"""
        self.check('test_m411a22_alloc_copy')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-29b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
