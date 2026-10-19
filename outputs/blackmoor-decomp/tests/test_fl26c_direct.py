"""FL-26 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl26c.c.

tests/fl26c_direct_test.c links src/original_methods_fl26c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the functions of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl26c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl26c_direct_test.c'
KERNELS = ['original_methods_fl26c.c']
EXPECTED = [
    'test_kind_0_unused_and_out_of_range',
    'test_kind_1',
    'test_kind_0xb',
    'test_table_kinds_2_and_3',
    'test_kind_0x11',
    'test_word_kinds_0xf_0xc_0x10',
    'test_kind_9',
    'test_kinds_4_and_5',
    'test_record_kinds_0xd_0xe_0x16',
    'test_kind_6',
    'test_kind_0x14',
    'test_kind_0x15',
    'test_partial_reads_reject',
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


class Fl26cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl26c_direct_test'
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

    def test_kind_0_unused_and_out_of_range(self):
        """FL-26c: direct test of m424346_node_condition: kinds 0, the unused kinds 7/8/0xa/0x12/0x13 and the out-of-range kinds"""
        self.check('test_kind_0_unused_and_out_of_range')

    def test_kind_1(self):
        """FL-26c: direct test of m424346_node_condition: kind 1"""
        self.check('test_kind_1')

    def test_kind_0xb(self):
        """FL-26c: direct test of m424346_node_condition: kind 0xb"""
        self.check('test_kind_0xb')

    def test_table_kinds_2_and_3(self):
        """FL-26c: direct test of m424346_node_condition: kinds 2 and 3"""
        self.check('test_table_kinds_2_and_3')

    def test_kind_0x11(self):
        """FL-26c: direct test of m424346_node_condition: kind 0x11"""
        self.check('test_kind_0x11')

    def test_word_kinds_0xf_0xc_0x10(self):
        """FL-26c: direct test of m424346_node_condition: kinds 0xf, 0xc and 0x10"""
        self.check('test_word_kinds_0xf_0xc_0x10')

    def test_kind_9(self):
        """FL-26c: direct test of m424346_node_condition: kind 9"""
        self.check('test_kind_9')

    def test_kinds_4_and_5(self):
        """FL-26c: direct test of m424346_node_condition: kinds 4 and 5"""
        self.check('test_kinds_4_and_5')

    def test_record_kinds_0xd_0xe_0x16(self):
        """FL-26c: direct test of m424346_node_condition: kinds 0xd, 0xe and 0x16"""
        self.check('test_record_kinds_0xd_0xe_0x16')

    def test_kind_6(self):
        """FL-26c: direct test of m424346_node_condition: kind 6"""
        self.check('test_kind_6')

    def test_kind_0x14(self):
        """FL-26c: direct test of m424346_node_condition: kind 0x14"""
        self.check('test_kind_0x14')

    def test_kind_0x15(self):
        """FL-26c: direct test of m424346_node_condition: kind 0x15"""
        self.check('test_kind_0x15')

    def test_partial_reads_reject(self):
        """FL-26c: a read that fails in the middle of the node stops the call before any host call or store"""
        self.check('test_partial_reads_reject')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-26c: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
