"""FL-36 (batch f): direct C tests of the GAME.EXE functions in src/original_methods_fl36f.c.

tests/fl36f_direct_test.c links src/original_methods_fl36f.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl36f_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl36f_direct_test.c'
KERNELS = ['original_methods_fl36f.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl36f_fixtures as fx
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


class Fl36fDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl36f_direct_test'
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

    def test_401420_new_and_construct(self):
        """FL-36f: direct test of m401420_new_and_construct (original 0x401420)"""
        self.check('test_m401420_new_and_construct')

    def test_403040_new_and_construct(self):
        """FL-36f: direct test of m403040_new_and_construct (original 0x403040)"""
        self.check('test_m403040_new_and_construct')

    def test_404a50_new_and_construct(self):
        """FL-36f: direct test of m404a50_new_and_construct (original 0x404a50)"""
        self.check('test_m404a50_new_and_construct')

    def test_407b40_new_and_construct(self):
        """FL-36f: direct test of m407b40_new_and_construct (original 0x407b40)"""
        self.check('test_m407b40_new_and_construct')

    def test_4089b0_new_and_construct(self):
        """FL-36f: direct test of m4089b0_new_and_construct (original 0x4089b0)"""
        self.check('test_m4089b0_new_and_construct')

    def test_4144c0_new_and_construct(self):
        """FL-36f: direct test of m4144c0_new_and_construct (original 0x4144c0)"""
        self.check('test_m4144c0_new_and_construct')

    def test_414537_construct_base_set_vtable(self):
        """FL-36f: direct test of m414537_construct_base_set_vtable (original 0x414537)"""
        self.check('test_m414537_construct_base_set_vtable')

    def test_41bda0_new_and_construct(self):
        """FL-36f: direct test of m41bda0_new_and_construct (original 0x41bda0)"""
        self.check('test_m41bda0_new_and_construct')

    def test_43eab0_new_and_construct(self):
        """FL-36f: direct test of m43eab0_new_and_construct (original 0x43eab0)"""
        self.check('test_m43eab0_new_and_construct')

    def test_446f00_new_and_construct(self):
        """FL-36f: direct test of m446f00_new_and_construct (original 0x446f00)"""
        self.check('test_m446f00_new_and_construct')

    def test_447db0_new_and_construct(self):
        """FL-36f: direct test of m447db0_new_and_construct (original 0x447db0)"""
        self.check('test_m447db0_new_and_construct')

    def test_44af40_new_and_construct(self):
        """FL-36f: direct test of m44af40_new_and_construct (original 0x44af40)"""
        self.check('test_m44af40_new_and_construct')

    def test_44d020_new_and_construct(self):
        """FL-36f: direct test of m44d020_new_and_construct (original 0x44d020)"""
        self.check('test_m44d020_new_and_construct')

    def test_44d097_construct_base_set_vtable(self):
        """FL-36f: direct test of m44d097_construct_base_set_vtable (original 0x44d097)"""
        self.check('test_m44d097_construct_base_set_vtable')

    def test_44e680_new_and_construct(self):
        """FL-36f: direct test of m44e680_new_and_construct (original 0x44e680)"""
        self.check('test_m44e680_new_and_construct')

    def test_44e6f7_construct_base_set_vtable(self):
        """FL-36f: direct test of m44e6f7_construct_base_set_vtable (original 0x44e6f7)"""
        self.check('test_m44e6f7_construct_base_set_vtable')

    def test_454ca0_new_and_construct(self):
        """FL-36f: direct test of m454ca0_new_and_construct (original 0x454ca0)"""
        self.check('test_m454ca0_new_and_construct')

    def test_454d1a_construct_base_set_vtable(self):
        """FL-36f: direct test of m454d1a_construct_base_set_vtable (original 0x454d1a)"""
        self.check('test_m454d1a_construct_base_set_vtable')

    def test_456c20_new_and_construct(self):
        """FL-36f: direct test of m456c20_new_and_construct (original 0x456c20)"""
        self.check('test_m456c20_new_and_construct')

    def test_456c97_construct_base_set_vtable(self):
        """FL-36f: direct test of m456c97_construct_base_set_vtable (original 0x456c97)"""
        self.check('test_m456c97_construct_base_set_vtable')

    def test_457e90_new_and_construct(self):
        """FL-36f: direct test of m457e90_new_and_construct (original 0x457e90)"""
        self.check('test_m457e90_new_and_construct')

    def test_457f0a_construct_base_set_vtable(self):
        """FL-36f: direct test of m457f0a_construct_base_set_vtable (original 0x457f0a)"""
        self.check('test_m457f0a_construct_base_set_vtable')

    def test_459a00_new_and_construct(self):
        """FL-36f: direct test of m459a00_new_and_construct (original 0x459a00)"""
        self.check('test_m459a00_new_and_construct')

    def test_459a7a_construct_base_set_vtable(self):
        """FL-36f: direct test of m459a7a_construct_base_set_vtable (original 0x459a7a)"""
        self.check('test_m459a7a_construct_base_set_vtable')

    def test_45b300_new_and_construct(self):
        """FL-36f: direct test of m45b300_new_and_construct (original 0x45b300)"""
        self.check('test_m45b300_new_and_construct')

    def test_45b37a_construct_base_set_vtable(self):
        """FL-36f: direct test of m45b37a_construct_base_set_vtable (original 0x45b37a)"""
        self.check('test_m45b37a_construct_base_set_vtable')

    def test_45dba0_new_and_construct(self):
        """FL-36f: direct test of m45dba0_new_and_construct (original 0x45dba0)"""
        self.check('test_m45dba0_new_and_construct')

    def test_45dc1a_construct_base_set_vtable(self):
        """FL-36f: direct test of m45dc1a_construct_base_set_vtable (original 0x45dc1a)"""
        self.check('test_m45dc1a_construct_base_set_vtable')

    def test_461740_new_and_construct(self):
        """FL-36f: direct test of m461740_new_and_construct (original 0x461740)"""
        self.check('test_m461740_new_and_construct')

    def test_4617b7_construct_base_set_vtable(self):
        """FL-36f: direct test of m4617b7_construct_base_set_vtable (original 0x4617b7)"""
        self.check('test_m4617b7_construct_base_set_vtable')

    def test_463f30_new_and_construct(self):
        """FL-36f: direct test of m463f30_new_and_construct (original 0x463f30)"""
        self.check('test_m463f30_new_and_construct')

    def test_463faa_construct_base_set_vtable(self):
        """FL-36f: direct test of m463faa_construct_base_set_vtable (original 0x463faa)"""
        self.check('test_m463faa_construct_base_set_vtable')

    def test_465a20_new_and_construct(self):
        """FL-36f: direct test of m465a20_new_and_construct (original 0x465a20)"""
        self.check('test_m465a20_new_and_construct')

    def test_465a97_construct_base_set_vtable(self):
        """FL-36f: direct test of m465a97_construct_base_set_vtable (original 0x465a97)"""
        self.check('test_m465a97_construct_base_set_vtable')

    def test_468d70_new_and_construct(self):
        """FL-36f: direct test of m468d70_new_and_construct (original 0x468d70)"""
        self.check('test_m468d70_new_and_construct')

    def test_468dea_construct_base_set_vtable(self):
        """FL-36f: direct test of m468dea_construct_base_set_vtable (original 0x468dea)"""
        self.check('test_m468dea_construct_base_set_vtable')

    def test_46b4a0_new_and_construct(self):
        """FL-36f: direct test of m46b4a0_new_and_construct (original 0x46b4a0)"""
        self.check('test_m46b4a0_new_and_construct')

    def test_46b51a_construct_base_set_vtable(self):
        """FL-36f: direct test of m46b51a_construct_base_set_vtable (original 0x46b51a)"""
        self.check('test_m46b51a_construct_base_set_vtable')

    def test_46e580_new_and_construct(self):
        """FL-36f: direct test of m46e580_new_and_construct (original 0x46e580)"""
        self.check('test_m46e580_new_and_construct')

    def test_470c90_new_and_construct(self):
        """FL-36f: direct test of m470c90_new_and_construct (original 0x470c90)"""
        self.check('test_m470c90_new_and_construct')

    def test_470d0a_construct_base_set_vtable(self):
        """FL-36f: direct test of m470d0a_construct_base_set_vtable (original 0x470d0a)"""
        self.check('test_m470d0a_construct_base_set_vtable')

    def test_4756f0_new_and_construct(self):
        """FL-36f: direct test of m4756f0_new_and_construct (original 0x4756f0)"""
        self.check('test_m4756f0_new_and_construct')

    def test_47576a_construct_base_set_vtable(self):
        """FL-36f: direct test of m47576a_construct_base_set_vtable (original 0x47576a)"""
        self.check('test_m47576a_construct_base_set_vtable')

    def test_478110_new_and_construct(self):
        """FL-36f: direct test of m478110_new_and_construct (original 0x478110)"""
        self.check('test_m478110_new_and_construct')

    def test_47818a_construct_base_set_vtable(self):
        """FL-36f: direct test of m47818a_construct_base_set_vtable (original 0x47818a)"""
        self.check('test_m47818a_construct_base_set_vtable')

    def test_47d410_new_and_construct(self):
        """FL-36f: direct test of m47d410_new_and_construct (original 0x47d410)"""
        self.check('test_m47d410_new_and_construct')

    def test_47d487_construct_base_set_vtable(self):
        """FL-36f: direct test of m47d487_construct_base_set_vtable (original 0x47d487)"""
        self.check('test_m47d487_construct_base_set_vtable')

    def test_47e170_new_and_construct(self):
        """FL-36f: direct test of m47e170_new_and_construct (original 0x47e170)"""
        self.check('test_m47e170_new_and_construct')

    def test_47e1ea_construct_base_set_vtable(self):
        """FL-36f: direct test of m47e1ea_construct_base_set_vtable (original 0x47e1ea)"""
        self.check('test_m47e1ea_construct_base_set_vtable')

    def test_482090_new_and_construct(self):
        """FL-36f: direct test of m482090_new_and_construct (original 0x482090)"""
        self.check('test_m482090_new_and_construct')

    def test_48210a_construct_base_set_vtable(self):
        """FL-36f: direct test of m48210a_construct_base_set_vtable (original 0x48210a)"""
        self.check('test_m48210a_construct_base_set_vtable')

    def test_483e80_new_and_construct(self):
        """FL-36f: direct test of m483e80_new_and_construct (original 0x483e80)"""
        self.check('test_m483e80_new_and_construct')

    def test_483efa_construct_base_set_vtable(self):
        """FL-36f: direct test of m483efa_construct_base_set_vtable (original 0x483efa)"""
        self.check('test_m483efa_construct_base_set_vtable')

    def test_487a30_new_and_construct(self):
        """FL-36f: direct test of m487a30_new_and_construct (original 0x487a30)"""
        self.check('test_m487a30_new_and_construct')

    def test_487aaa_construct_base_set_vtable(self):
        """FL-36f: direct test of m487aaa_construct_base_set_vtable (original 0x487aaa)"""
        self.check('test_m487aaa_construct_base_set_vtable')

    def test_488cf0_new_and_construct(self):
        """FL-36f: direct test of m488cf0_new_and_construct (original 0x488cf0)"""
        self.check('test_m488cf0_new_and_construct')

    def test_48a620_new_and_construct(self):
        """FL-36f: direct test of m48a620_new_and_construct (original 0x48a620)"""
        self.check('test_m48a620_new_and_construct')

    def test_48a69a_construct_base_set_vtable(self):
        """FL-36f: direct test of m48a69a_construct_base_set_vtable (original 0x48a69a)"""
        self.check('test_m48a69a_construct_base_set_vtable')

    def test_48ba30_new_and_construct(self):
        """FL-36f: direct test of m48ba30_new_and_construct (original 0x48ba30)"""
        self.check('test_m48ba30_new_and_construct')

    def test_48baa7_construct_base_set_vtable(self):
        """FL-36f: direct test of m48baa7_construct_base_set_vtable (original 0x48baa7)"""
        self.check('test_m48baa7_construct_base_set_vtable')

    def test_48cf80_new_and_construct(self):
        """FL-36f: direct test of m48cf80_new_and_construct (original 0x48cf80)"""
        self.check('test_m48cf80_new_and_construct')

    def test_48cff7_construct_base_set_vtable(self):
        """FL-36f: direct test of m48cff7_construct_base_set_vtable (original 0x48cff7)"""
        self.check('test_m48cff7_construct_base_set_vtable')

    def test_48e1a0_new_and_construct(self):
        """FL-36f: direct test of m48e1a0_new_and_construct (original 0x48e1a0)"""
        self.check('test_m48e1a0_new_and_construct')

    def test_48e21a_construct_base_set_vtable(self):
        """FL-36f: direct test of m48e21a_construct_base_set_vtable (original 0x48e21a)"""
        self.check('test_m48e21a_construct_base_set_vtable')

    def test_490480_new_and_construct(self):
        """FL-36f: direct test of m490480_new_and_construct (original 0x490480)"""
        self.check('test_m490480_new_and_construct')

    def test_49c4c0_new_and_construct(self):
        """FL-36f: direct test of m49c4c0_new_and_construct (original 0x49c4c0)"""
        self.check('test_m49c4c0_new_and_construct')

    def test_4a1b60_new_and_construct(self):
        """FL-36f: direct test of m4a1b60_new_and_construct (original 0x4a1b60)"""
        self.check('test_m4a1b60_new_and_construct')

    def test_4a1bd7_construct_base_set_vtable(self):
        """FL-36f: direct test of m4a1bd7_construct_base_set_vtable (original 0x4a1bd7)"""
        self.check('test_m4a1bd7_construct_base_set_vtable')

    def test_4a36a0_new_and_construct(self):
        """FL-36f: direct test of m4a36a0_new_and_construct (original 0x4a36a0)"""
        self.check('test_m4a36a0_new_and_construct')

    def test_4a371a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4a371a_construct_base_set_vtable (original 0x4a371a)"""
        self.check('test_m4a371a_construct_base_set_vtable')

    def test_4a62a0_new_and_construct(self):
        """FL-36f: direct test of m4a62a0_new_and_construct (original 0x4a62a0)"""
        self.check('test_m4a62a0_new_and_construct')

    def test_4a631a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4a631a_construct_base_set_vtable (original 0x4a631a)"""
        self.check('test_m4a631a_construct_base_set_vtable')

    def test_4a7b90_new_and_construct(self):
        """FL-36f: direct test of m4a7b90_new_and_construct (original 0x4a7b90)"""
        self.check('test_m4a7b90_new_and_construct')

    def test_4a7c0a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4a7c0a_construct_base_set_vtable (original 0x4a7c0a)"""
        self.check('test_m4a7c0a_construct_base_set_vtable')

    def test_4a9e40_new_and_construct(self):
        """FL-36f: direct test of m4a9e40_new_and_construct (original 0x4a9e40)"""
        self.check('test_m4a9e40_new_and_construct')

    def test_4a9eb7_construct_base_set_vtable(self):
        """FL-36f: direct test of m4a9eb7_construct_base_set_vtable (original 0x4a9eb7)"""
        self.check('test_m4a9eb7_construct_base_set_vtable')

    def test_4ab2c0_new_and_construct(self):
        """FL-36f: direct test of m4ab2c0_new_and_construct (original 0x4ab2c0)"""
        self.check('test_m4ab2c0_new_and_construct')

    def test_4ab337_construct_base_set_vtable(self):
        """FL-36f: direct test of m4ab337_construct_base_set_vtable (original 0x4ab337)"""
        self.check('test_m4ab337_construct_base_set_vtable')

    def test_4ac7f0_new_and_construct(self):
        """FL-36f: direct test of m4ac7f0_new_and_construct (original 0x4ac7f0)"""
        self.check('test_m4ac7f0_new_and_construct')

    def test_4ac86a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4ac86a_construct_base_set_vtable (original 0x4ac86a)"""
        self.check('test_m4ac86a_construct_base_set_vtable')

    def test_4afc50_new_and_construct(self):
        """FL-36f: direct test of m4afc50_new_and_construct (original 0x4afc50)"""
        self.check('test_m4afc50_new_and_construct')

    def test_4afcca_construct_base_set_vtable(self):
        """FL-36f: direct test of m4afcca_construct_base_set_vtable (original 0x4afcca)"""
        self.check('test_m4afcca_construct_base_set_vtable')

    def test_4b3b70_new_and_construct(self):
        """FL-36f: direct test of m4b3b70_new_and_construct (original 0x4b3b70)"""
        self.check('test_m4b3b70_new_and_construct')

    def test_4b3bea_construct_base_set_vtable(self):
        """FL-36f: direct test of m4b3bea_construct_base_set_vtable (original 0x4b3bea)"""
        self.check('test_m4b3bea_construct_base_set_vtable')

    def test_4b5aa0_new_and_construct(self):
        """FL-36f: direct test of m4b5aa0_new_and_construct (original 0x4b5aa0)"""
        self.check('test_m4b5aa0_new_and_construct')

    def test_4b5b1a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4b5b1a_construct_base_set_vtable (original 0x4b5b1a)"""
        self.check('test_m4b5b1a_construct_base_set_vtable')

    def test_4b7110_new_and_construct(self):
        """FL-36f: direct test of m4b7110_new_and_construct (original 0x4b7110)"""
        self.check('test_m4b7110_new_and_construct')

    def test_4b7187_construct_base_set_vtable(self):
        """FL-36f: direct test of m4b7187_construct_base_set_vtable (original 0x4b7187)"""
        self.check('test_m4b7187_construct_base_set_vtable')

    def test_4cc8b0_new_and_construct(self):
        """FL-36f: direct test of m4cc8b0_new_and_construct (original 0x4cc8b0)"""
        self.check('test_m4cc8b0_new_and_construct')

    def test_4d3aa0_new_and_construct(self):
        """FL-36f: direct test of m4d3aa0_new_and_construct (original 0x4d3aa0)"""
        self.check('test_m4d3aa0_new_and_construct')

    def test_4d3b1a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4d3b1a_construct_base_set_vtable (original 0x4d3b1a)"""
        self.check('test_m4d3b1a_construct_base_set_vtable')

    def test_4dbea0_new_and_construct(self):
        """FL-36f: direct test of m4dbea0_new_and_construct (original 0x4dbea0)"""
        self.check('test_m4dbea0_new_and_construct')

    def test_4dbf1a_construct_base_set_vtable(self):
        """FL-36f: direct test of m4dbf1a_construct_base_set_vtable (original 0x4dbf1a)"""
        self.check('test_m4dbf1a_construct_base_set_vtable')

    def test_4de150_construct_base_set_vtable(self):
        """FL-36f: direct test of m4de150_construct_base_set_vtable (original 0x4de150)"""
        self.check('test_m4de150_construct_base_set_vtable')

    def test_4e7630_construct_base_set_vtable(self):
        """FL-36f: direct test of m4e7630_construct_base_set_vtable (original 0x4e7630)"""
        self.check('test_m4e7630_construct_base_set_vtable')

    def test_exact_size_buffers(self):
        """FL-36f: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
