"""FL-36 (batch d): direct C tests of the GAME.EXE functions in src/original_methods_fl36d.c.

tests/fl36d_direct_test.c links src/original_methods_fl36d.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl36d_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl36d_direct_test.c'
KERNELS = ['original_methods_fl36d.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl36d_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS] + ['test_exact_size_buffers']


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


class Fl36dDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl36d_direct_test'
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

    def test_401100_scalar_deleting_dtor(self):
        """FL-36d: direct test of m401100_scalar_deleting_dtor (original 0x401100)"""
        self.check('test_m401100_scalar_deleting_dtor')

    def test_401190_scalar_deleting_dtor(self):
        """FL-36d: direct test of m401190_scalar_deleting_dtor (original 0x401190)"""
        self.check('test_m401190_scalar_deleting_dtor')

    def test_401c40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m401c40_scalar_deleting_dtor (original 0x401c40)"""
        self.check('test_m401c40_scalar_deleting_dtor')

    def test_403010_scalar_deleting_dtor(self):
        """FL-36d: direct test of m403010_scalar_deleting_dtor (original 0x403010)"""
        self.check('test_m403010_scalar_deleting_dtor')

    def test_404a20_scalar_deleting_dtor(self):
        """FL-36d: direct test of m404a20_scalar_deleting_dtor (original 0x404a20)"""
        self.check('test_m404a20_scalar_deleting_dtor')

    def test_407b10_scalar_deleting_dtor(self):
        """FL-36d: direct test of m407b10_scalar_deleting_dtor (original 0x407b10)"""
        self.check('test_m407b10_scalar_deleting_dtor')

    def test_408980_scalar_deleting_dtor(self):
        """FL-36d: direct test of m408980_scalar_deleting_dtor (original 0x408980)"""
        self.check('test_m408980_scalar_deleting_dtor')

    def test_40b2a0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m40b2a0_scalar_deleting_dtor (original 0x40b2a0)"""
        self.check('test_m40b2a0_scalar_deleting_dtor')

    def test_414490_scalar_deleting_dtor(self):
        """FL-36d: direct test of m414490_scalar_deleting_dtor (original 0x414490)"""
        self.check('test_m414490_scalar_deleting_dtor')

    def test_414c80_scalar_deleting_dtor(self):
        """FL-36d: direct test of m414c80_scalar_deleting_dtor (original 0x414c80)"""
        self.check('test_m414c80_scalar_deleting_dtor')

    def test_416e60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m416e60_scalar_deleting_dtor (original 0x416e60)"""
        self.check('test_m416e60_scalar_deleting_dtor')

    def test_41a480_scalar_deleting_dtor(self):
        """FL-36d: direct test of m41a480_scalar_deleting_dtor (original 0x41a480)"""
        self.check('test_m41a480_scalar_deleting_dtor')

    def test_422fb0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m422fb0_scalar_deleting_dtor (original 0x422fb0)"""
        self.check('test_m422fb0_scalar_deleting_dtor')

    def test_425f70_scalar_deleting_dtor(self):
        """FL-36d: direct test of m425f70_scalar_deleting_dtor (original 0x425f70)"""
        self.check('test_m425f70_scalar_deleting_dtor')

    def test_4273f0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4273f0_scalar_deleting_dtor (original 0x4273f0)"""
        self.check('test_m4273f0_scalar_deleting_dtor')

    def test_434880_scalar_deleting_dtor(self):
        """FL-36d: direct test of m434880_scalar_deleting_dtor (original 0x434880)"""
        self.check('test_m434880_scalar_deleting_dtor')

    def test_438120_scalar_deleting_dtor(self):
        """FL-36d: direct test of m438120_scalar_deleting_dtor (original 0x438120)"""
        self.check('test_m438120_scalar_deleting_dtor')

    def test_43eed0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m43eed0_scalar_deleting_dtor (original 0x43eed0)"""
        self.check('test_m43eed0_scalar_deleting_dtor')

    def test_43f1e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m43f1e0_scalar_deleting_dtor (original 0x43f1e0)"""
        self.check('test_m43f1e0_scalar_deleting_dtor')

    def test_446ed0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m446ed0_scalar_deleting_dtor (original 0x446ed0)"""
        self.check('test_m446ed0_scalar_deleting_dtor')

    def test_447ce0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m447ce0_scalar_deleting_dtor (original 0x447ce0)"""
        self.check('test_m447ce0_scalar_deleting_dtor')

    def test_447d80_scalar_deleting_dtor(self):
        """FL-36d: direct test of m447d80_scalar_deleting_dtor (original 0x447d80)"""
        self.check('test_m447d80_scalar_deleting_dtor')

    def test_4487f0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4487f0_scalar_deleting_dtor (original 0x4487f0)"""
        self.check('test_m4487f0_scalar_deleting_dtor')

    def test_449770_scalar_deleting_dtor(self):
        """FL-36d: direct test of m449770_scalar_deleting_dtor (original 0x449770)"""
        self.check('test_m449770_scalar_deleting_dtor')

    def test_449d60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m449d60_scalar_deleting_dtor (original 0x449d60)"""
        self.check('test_m449d60_scalar_deleting_dtor')

    def test_44be60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m44be60_scalar_deleting_dtor (original 0x44be60)"""
        self.check('test_m44be60_scalar_deleting_dtor')

    def test_44c2b0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m44c2b0_scalar_deleting_dtor (original 0x44c2b0)"""
        self.check('test_m44c2b0_scalar_deleting_dtor')

    def test_44e650_scalar_deleting_dtor(self):
        """FL-36d: direct test of m44e650_scalar_deleting_dtor (original 0x44e650)"""
        self.check('test_m44e650_scalar_deleting_dtor')

    def test_44f620_scalar_deleting_dtor(self):
        """FL-36d: direct test of m44f620_scalar_deleting_dtor (original 0x44f620)"""
        self.check('test_m44f620_scalar_deleting_dtor')

    def test_454c70_scalar_deleting_dtor(self):
        """FL-36d: direct test of m454c70_scalar_deleting_dtor (original 0x454c70)"""
        self.check('test_m454c70_scalar_deleting_dtor')

    def test_456bf0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m456bf0_scalar_deleting_dtor (original 0x456bf0)"""
        self.check('test_m456bf0_scalar_deleting_dtor')

    def test_457e60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m457e60_scalar_deleting_dtor (original 0x457e60)"""
        self.check('test_m457e60_scalar_deleting_dtor')

    def test_4599d0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4599d0_scalar_deleting_dtor (original 0x4599d0)"""
        self.check('test_m4599d0_scalar_deleting_dtor')

    def test_45b2d0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m45b2d0_scalar_deleting_dtor (original 0x45b2d0)"""
        self.check('test_m45b2d0_scalar_deleting_dtor')

    def test_45db70_scalar_deleting_dtor(self):
        """FL-36d: direct test of m45db70_scalar_deleting_dtor (original 0x45db70)"""
        self.check('test_m45db70_scalar_deleting_dtor')

    def test_461710_scalar_deleting_dtor(self):
        """FL-36d: direct test of m461710_scalar_deleting_dtor (original 0x461710)"""
        self.check('test_m461710_scalar_deleting_dtor')

    def test_463f00_scalar_deleting_dtor(self):
        """FL-36d: direct test of m463f00_scalar_deleting_dtor (original 0x463f00)"""
        self.check('test_m463f00_scalar_deleting_dtor')

    def test_4659f0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4659f0_scalar_deleting_dtor (original 0x4659f0)"""
        self.check('test_m4659f0_scalar_deleting_dtor')

    def test_4674b0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4674b0_scalar_deleting_dtor (original 0x4674b0)"""
        self.check('test_m4674b0_scalar_deleting_dtor')

    def test_468d40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m468d40_scalar_deleting_dtor (original 0x468d40)"""
        self.check('test_m468d40_scalar_deleting_dtor')

    def test_46b470_scalar_deleting_dtor(self):
        """FL-36d: direct test of m46b470_scalar_deleting_dtor (original 0x46b470)"""
        self.check('test_m46b470_scalar_deleting_dtor')

    def test_46e550_scalar_deleting_dtor(self):
        """FL-36d: direct test of m46e550_scalar_deleting_dtor (original 0x46e550)"""
        self.check('test_m46e550_scalar_deleting_dtor')

    def test_470c60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m470c60_scalar_deleting_dtor (original 0x470c60)"""
        self.check('test_m470c60_scalar_deleting_dtor')

    def test_472ed0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m472ed0_scalar_deleting_dtor (original 0x472ed0)"""
        self.check('test_m472ed0_scalar_deleting_dtor')

    def test_4756c0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4756c0_scalar_deleting_dtor (original 0x4756c0)"""
        self.check('test_m4756c0_scalar_deleting_dtor')

    def test_4780e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4780e0_scalar_deleting_dtor (original 0x4780e0)"""
        self.check('test_m4780e0_scalar_deleting_dtor')

    def test_47b1d0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m47b1d0_scalar_deleting_dtor (original 0x47b1d0)"""
        self.check('test_m47b1d0_scalar_deleting_dtor')

    def test_47d3e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m47d3e0_scalar_deleting_dtor (original 0x47d3e0)"""
        self.check('test_m47d3e0_scalar_deleting_dtor')

    def test_47e140_scalar_deleting_dtor(self):
        """FL-36d: direct test of m47e140_scalar_deleting_dtor (original 0x47e140)"""
        self.check('test_m47e140_scalar_deleting_dtor')

    def test_482060_scalar_deleting_dtor(self):
        """FL-36d: direct test of m482060_scalar_deleting_dtor (original 0x482060)"""
        self.check('test_m482060_scalar_deleting_dtor')

    def test_483e50_scalar_deleting_dtor(self):
        """FL-36d: direct test of m483e50_scalar_deleting_dtor (original 0x483e50)"""
        self.check('test_m483e50_scalar_deleting_dtor')

    def test_487a00_scalar_deleting_dtor(self):
        """FL-36d: direct test of m487a00_scalar_deleting_dtor (original 0x487a00)"""
        self.check('test_m487a00_scalar_deleting_dtor')

    def test_488cc0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m488cc0_scalar_deleting_dtor (original 0x488cc0)"""
        self.check('test_m488cc0_scalar_deleting_dtor')

    def test_48a5f0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m48a5f0_scalar_deleting_dtor (original 0x48a5f0)"""
        self.check('test_m48a5f0_scalar_deleting_dtor')

    def test_48ba00_scalar_deleting_dtor(self):
        """FL-36d: direct test of m48ba00_scalar_deleting_dtor (original 0x48ba00)"""
        self.check('test_m48ba00_scalar_deleting_dtor')

    def test_48cf50_scalar_deleting_dtor(self):
        """FL-36d: direct test of m48cf50_scalar_deleting_dtor (original 0x48cf50)"""
        self.check('test_m48cf50_scalar_deleting_dtor')

    def test_48e170_scalar_deleting_dtor(self):
        """FL-36d: direct test of m48e170_scalar_deleting_dtor (original 0x48e170)"""
        self.check('test_m48e170_scalar_deleting_dtor')

    def test_490450_scalar_deleting_dtor(self):
        """FL-36d: direct test of m490450_scalar_deleting_dtor (original 0x490450)"""
        self.check('test_m490450_scalar_deleting_dtor')

    def test_49c490_scalar_deleting_dtor(self):
        """FL-36d: direct test of m49c490_scalar_deleting_dtor (original 0x49c490)"""
        self.check('test_m49c490_scalar_deleting_dtor')

    def test_4a1b30_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4a1b30_scalar_deleting_dtor (original 0x4a1b30)"""
        self.check('test_m4a1b30_scalar_deleting_dtor')

    def test_4a3670_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4a3670_scalar_deleting_dtor (original 0x4a3670)"""
        self.check('test_m4a3670_scalar_deleting_dtor')

    def test_4a6270_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4a6270_scalar_deleting_dtor (original 0x4a6270)"""
        self.check('test_m4a6270_scalar_deleting_dtor')

    def test_4a7b60_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4a7b60_scalar_deleting_dtor (original 0x4a7b60)"""
        self.check('test_m4a7b60_scalar_deleting_dtor')

    def test_4a9e10_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4a9e10_scalar_deleting_dtor (original 0x4a9e10)"""
        self.check('test_m4a9e10_scalar_deleting_dtor')

    def test_4ab290_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4ab290_scalar_deleting_dtor (original 0x4ab290)"""
        self.check('test_m4ab290_scalar_deleting_dtor')

    def test_4ac7c0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4ac7c0_scalar_deleting_dtor (original 0x4ac7c0)"""
        self.check('test_m4ac7c0_scalar_deleting_dtor')

    def test_4afc20_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4afc20_scalar_deleting_dtor (original 0x4afc20)"""
        self.check('test_m4afc20_scalar_deleting_dtor')

    def test_4b3b40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4b3b40_scalar_deleting_dtor (original 0x4b3b40)"""
        self.check('test_m4b3b40_scalar_deleting_dtor')

    def test_4b5a70_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4b5a70_scalar_deleting_dtor (original 0x4b5a70)"""
        self.check('test_m4b5a70_scalar_deleting_dtor')

    def test_4b70e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4b70e0_scalar_deleting_dtor (original 0x4b70e0)"""
        self.check('test_m4b70e0_scalar_deleting_dtor')

    def test_4b7ed0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4b7ed0_scalar_deleting_dtor (original 0x4b7ed0)"""
        self.check('test_m4b7ed0_scalar_deleting_dtor')

    def test_4b9dd0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4b9dd0_scalar_deleting_dtor (original 0x4b9dd0)"""
        self.check('test_m4b9dd0_scalar_deleting_dtor')

    def test_4bed40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4bed40_scalar_deleting_dtor (original 0x4bed40)"""
        self.check('test_m4bed40_scalar_deleting_dtor')

    def test_4bf5d0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4bf5d0_scalar_deleting_dtor (original 0x4bf5d0)"""
        self.check('test_m4bf5d0_scalar_deleting_dtor')

    def test_4c0f30_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4c0f30_scalar_deleting_dtor (original 0x4c0f30)"""
        self.check('test_m4c0f30_scalar_deleting_dtor')

    def test_4cae90_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4cae90_scalar_deleting_dtor (original 0x4cae90)"""
        self.check('test_m4cae90_scalar_deleting_dtor')

    def test_4cc880_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4cc880_scalar_deleting_dtor (original 0x4cc880)"""
        self.check('test_m4cc880_scalar_deleting_dtor')

    def test_4ccd40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4ccd40_scalar_deleting_dtor (original 0x4ccd40)"""
        self.check('test_m4ccd40_scalar_deleting_dtor')

    def test_4cf7b0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4cf7b0_scalar_deleting_dtor (original 0x4cf7b0)"""
        self.check('test_m4cf7b0_scalar_deleting_dtor')

    def test_4d42b0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4d42b0_scalar_deleting_dtor (original 0x4d42b0)"""
        self.check('test_m4d42b0_scalar_deleting_dtor')

    def test_4d5230_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4d5230_scalar_deleting_dtor (original 0x4d5230)"""
        self.check('test_m4d5230_scalar_deleting_dtor')

    def test_4d5880_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4d5880_scalar_deleting_dtor (original 0x4d5880)"""
        self.check('test_m4d5880_scalar_deleting_dtor')

    def test_4d9d40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4d9d40_scalar_deleting_dtor (original 0x4d9d40)"""
        self.check('test_m4d9d40_scalar_deleting_dtor')

    def test_4dbca0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4dbca0_scalar_deleting_dtor (original 0x4dbca0)"""
        self.check('test_m4dbca0_scalar_deleting_dtor')

    def test_4dd380_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4dd380_scalar_deleting_dtor (original 0x4dd380)"""
        self.check('test_m4dd380_scalar_deleting_dtor')

    def test_4de120_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4de120_scalar_deleting_dtor (original 0x4de120)"""
        self.check('test_m4de120_scalar_deleting_dtor')

    def test_4de5c0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4de5c0_scalar_deleting_dtor (original 0x4de5c0)"""
        self.check('test_m4de5c0_scalar_deleting_dtor')

    def test_4e03e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4e03e0_scalar_deleting_dtor (original 0x4e03e0)"""
        self.check('test_m4e03e0_scalar_deleting_dtor')

    def test_4e1c20_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4e1c20_scalar_deleting_dtor (original 0x4e1c20)"""
        self.check('test_m4e1c20_scalar_deleting_dtor')

    def test_4e2cb0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4e2cb0_scalar_deleting_dtor (original 0x4e2cb0)"""
        self.check('test_m4e2cb0_scalar_deleting_dtor')

    def test_4e7600_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4e7600_scalar_deleting_dtor (original 0x4e7600)"""
        self.check('test_m4e7600_scalar_deleting_dtor')

    def test_4e7a40_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4e7a40_scalar_deleting_dtor (original 0x4e7a40)"""
        self.check('test_m4e7a40_scalar_deleting_dtor')

    def test_4eb840_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4eb840_scalar_deleting_dtor (original 0x4eb840)"""
        self.check('test_m4eb840_scalar_deleting_dtor')

    def test_4ed9e0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4ed9e0_scalar_deleting_dtor (original 0x4ed9e0)"""
        self.check('test_m4ed9e0_scalar_deleting_dtor')

    def test_4ee950_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4ee950_scalar_deleting_dtor (original 0x4ee950)"""
        self.check('test_m4ee950_scalar_deleting_dtor')

    def test_4effd0_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4effd0_scalar_deleting_dtor (original 0x4effd0)"""
        self.check('test_m4effd0_scalar_deleting_dtor')

    def test_4f2610_scalar_deleting_dtor(self):
        """FL-36d: direct test of m4f2610_scalar_deleting_dtor (original 0x4f2610)"""
        self.check('test_m4f2610_scalar_deleting_dtor')

    def test_exact_size_buffers(self):
        """FL-36d: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
