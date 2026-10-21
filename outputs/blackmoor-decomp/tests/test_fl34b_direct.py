"""FL-34 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl34b.c.

tests/fl34b_direct_test.c links src/original_methods_fl34b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the ten ported flag toggles of batch b); the Unicorn comparison against the original bytes is in
tests/test_fl34b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl34b_direct_test.c'
KERNELS = ['original_methods_fl34b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl34b_fixtures as fx
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


class Fl34bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl34b_direct_test'
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

    def test_4067a5_toggle_5e350a(self):
        """FL-34b: direct test of m4067a5_toggle_5e350a (original 0x4067a5)"""
        self.check('test_m4067a5_toggle_5e350a')

    def test_4068c0_toggle_5e351a(self):
        """FL-34b: direct test of m4068c0_toggle_5e351a (original 0x4068c0)"""
        self.check('test_m4068c0_toggle_5e351a')

    def test_406907_toggle_5e351e(self):
        """FL-34b: direct test of m406907_toggle_5e351e (original 0x406907)"""
        self.check('test_m406907_toggle_5e351e')

    def test_40694e_toggle_5e3522(self):
        """FL-34b: direct test of m40694e_toggle_5e3522 (original 0x40694e)"""
        self.check('test_m40694e_toggle_5e3522')

    def test_406995_toggle_5e3526(self):
        """FL-34b: direct test of m406995_toggle_5e3526 (original 0x406995)"""
        self.check('test_m406995_toggle_5e3526')

    def test_4069dc_toggle_5e352a(self):
        """FL-34b: direct test of m4069dc_toggle_5e352a (original 0x4069dc)"""
        self.check('test_m4069dc_toggle_5e352a')

    def test_406a23_toggle_5e352e(self):
        """FL-34b: direct test of m406a23_toggle_5e352e (original 0x406a23)"""
        self.check('test_m406a23_toggle_5e352e')

    def test_406a6a_toggle_5e3532(self):
        """FL-34b: direct test of m406a6a_toggle_5e3532 (original 0x406a6a)"""
        self.check('test_m406a6a_toggle_5e3532')

    def test_406ab1_toggle_5e3536(self):
        """FL-34b: direct test of m406ab1_toggle_5e3536 (original 0x406ab1)"""
        self.check('test_m406ab1_toggle_5e3536')

    def test_406af8_toggle_5e353a(self):
        """FL-34b: direct test of m406af8_toggle_5e353a (original 0x406af8)"""
        self.check('test_m406af8_toggle_5e353a')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-34b: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
