"""FL-36 (batch c): direct C tests of the GAME.EXE functions in src/original_methods_fl36c.c.

tests/fl36c_direct_test.c links src/original_methods_fl36c.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl36c_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl36c_direct_test.c'
KERNELS = ['original_methods_fl36c.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl36c_fixtures as fx
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


class Fl36cDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl36c_direct_test'
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

    def test_401032_init_vtable_call(self):
        """FL-36c: direct test of m401032_init_vtable_call (original 0x401032)"""
        self.check('test_m401032_init_vtable_call')

    def test_4014f5_init_vtable_call(self):
        """FL-36c: direct test of m4014f5_init_vtable_call (original 0x4014f5)"""
        self.check('test_m4014f5_init_vtable_call')

    def test_40168f_set_mode_call(self):
        """FL-36c: direct test of m40168f_set_mode_call (original 0x40168f)"""
        self.check('test_m40168f_set_mode_call')

    def test_4016ac_set_mode_call(self):
        """FL-36c: direct test of m4016ac_set_mode_call (original 0x4016ac)"""
        self.check('test_m4016ac_set_mode_call')

    def test_4016c9_set_mode_call(self):
        """FL-36c: direct test of m4016c9_set_mode_call (original 0x4016c9)"""
        self.check('test_m4016c9_set_mode_call')

    def test_4016e6_set_mode_call(self):
        """FL-36c: direct test of m4016e6_set_mode_call (original 0x4016e6)"""
        self.check('test_m4016e6_set_mode_call')

    def test_401703_set_mode_call(self):
        """FL-36c: direct test of m401703_set_mode_call (original 0x401703)"""
        self.check('test_m401703_set_mode_call')

    def test_401720_set_mode_call(self):
        """FL-36c: direct test of m401720_set_mode_call (original 0x401720)"""
        self.check('test_m401720_set_mode_call')

    def test_40173d_set_mode_call(self):
        """FL-36c: direct test of m40173d_set_mode_call (original 0x40173d)"""
        self.check('test_m40173d_set_mode_call')

    def test_40175a_set_mode_call(self):
        """FL-36c: direct test of m40175a_set_mode_call (original 0x40175a)"""
        self.check('test_m40175a_set_mode_call')

    def test_401777_set_mode_call(self):
        """FL-36c: direct test of m401777_set_mode_call (original 0x401777)"""
        self.check('test_m401777_set_mode_call')

    def test_401794_set_mode_call(self):
        """FL-36c: direct test of m401794_set_mode_call (original 0x401794)"""
        self.check('test_m401794_set_mode_call')

    def test_4017b1_set_mode_call(self):
        """FL-36c: direct test of m4017b1_set_mode_call (original 0x4017b1)"""
        self.check('test_m4017b1_set_mode_call')

    def test_4017ce_set_mode_call(self):
        """FL-36c: direct test of m4017ce_set_mode_call (original 0x4017ce)"""
        self.check('test_m4017ce_set_mode_call')

    def test_4017eb_set_mode_call(self):
        """FL-36c: direct test of m4017eb_set_mode_call (original 0x4017eb)"""
        self.check('test_m4017eb_set_mode_call')

    def test_401808_set_mode_call(self):
        """FL-36c: direct test of m401808_set_mode_call (original 0x401808)"""
        self.check('test_m401808_set_mode_call')

    def test_401825_set_mode_call(self):
        """FL-36c: direct test of m401825_set_mode_call (original 0x401825)"""
        self.check('test_m401825_set_mode_call')

    def test_401842_set_mode_call(self):
        """FL-36c: direct test of m401842_set_mode_call (original 0x401842)"""
        self.check('test_m401842_set_mode_call')

    def test_40185f_set_mode_call(self):
        """FL-36c: direct test of m40185f_set_mode_call (original 0x40185f)"""
        self.check('test_m40185f_set_mode_call')

    def test_40187c_set_mode_call(self):
        """FL-36c: direct test of m40187c_set_mode_call (original 0x40187c)"""
        self.check('test_m40187c_set_mode_call')

    def test_401899_set_mode_call(self):
        """FL-36c: direct test of m401899_set_mode_call (original 0x401899)"""
        self.check('test_m401899_set_mode_call')

    def test_4018b6_set_mode_call(self):
        """FL-36c: direct test of m4018b6_set_mode_call (original 0x4018b6)"""
        self.check('test_m4018b6_set_mode_call')

    def test_4018d3_set_mode_call(self):
        """FL-36c: direct test of m4018d3_set_mode_call (original 0x4018d3)"""
        self.check('test_m4018d3_set_mode_call')

    def test_4018f0_set_mode_call(self):
        """FL-36c: direct test of m4018f0_set_mode_call (original 0x4018f0)"""
        self.check('test_m4018f0_set_mode_call')

    def test_40190d_set_mode_call(self):
        """FL-36c: direct test of m40190d_set_mode_call (original 0x40190d)"""
        self.check('test_m40190d_set_mode_call')

    def test_40192a_set_mode_call(self):
        """FL-36c: direct test of m40192a_set_mode_call (original 0x40192a)"""
        self.check('test_m40192a_set_mode_call')

    def test_401947_set_mode_call(self):
        """FL-36c: direct test of m401947_set_mode_call (original 0x401947)"""
        self.check('test_m401947_set_mode_call')

    def test_401964_set_mode_call(self):
        """FL-36c: direct test of m401964_set_mode_call (original 0x401964)"""
        self.check('test_m401964_set_mode_call')

    def test_401981_set_mode_call(self):
        """FL-36c: direct test of m401981_set_mode_call (original 0x401981)"""
        self.check('test_m401981_set_mode_call')

    def test_40199e_set_mode_call(self):
        """FL-36c: direct test of m40199e_set_mode_call (original 0x40199e)"""
        self.check('test_m40199e_set_mode_call')

    def test_4019bb_set_mode_call(self):
        """FL-36c: direct test of m4019bb_set_mode_call (original 0x4019bb)"""
        self.check('test_m4019bb_set_mode_call')

    def test_4019d8_set_mode_call(self):
        """FL-36c: direct test of m4019d8_set_mode_call (original 0x4019d8)"""
        self.check('test_m4019d8_set_mode_call')

    def test_4019f5_set_mode_call(self):
        """FL-36c: direct test of m4019f5_set_mode_call (original 0x4019f5)"""
        self.check('test_m4019f5_set_mode_call')

    def test_401a12_set_mode_call(self):
        """FL-36c: direct test of m401a12_set_mode_call (original 0x401a12)"""
        self.check('test_m401a12_set_mode_call')

    def test_401a2f_set_mode_call(self):
        """FL-36c: direct test of m401a2f_set_mode_call (original 0x401a2f)"""
        self.check('test_m401a2f_set_mode_call')

    def test_401a4c_set_mode_call(self):
        """FL-36c: direct test of m401a4c_set_mode_call (original 0x401a4c)"""
        self.check('test_m401a4c_set_mode_call')

    def test_401a69_set_mode_call(self):
        """FL-36c: direct test of m401a69_set_mode_call (original 0x401a69)"""
        self.check('test_m401a69_set_mode_call')

    def test_401a86_set_mode_call(self):
        """FL-36c: direct test of m401a86_set_mode_call (original 0x401a86)"""
        self.check('test_m401a86_set_mode_call')

    def test_401aa3_set_mode_call(self):
        """FL-36c: direct test of m401aa3_set_mode_call (original 0x401aa3)"""
        self.check('test_m401aa3_set_mode_call')

    def test_401ac0_set_mode_call(self):
        """FL-36c: direct test of m401ac0_set_mode_call (original 0x401ac0)"""
        self.check('test_m401ac0_set_mode_call')

    def test_401add_set_mode_call(self):
        """FL-36c: direct test of m401add_set_mode_call (original 0x401add)"""
        self.check('test_m401add_set_mode_call')

    def test_401afa_set_mode_call(self):
        """FL-36c: direct test of m401afa_set_mode_call (original 0x401afa)"""
        self.check('test_m401afa_set_mode_call')

    def test_401b17_set_mode_call(self):
        """FL-36c: direct test of m401b17_set_mode_call (original 0x401b17)"""
        self.check('test_m401b17_set_mode_call')

    def test_401b34_set_mode_call(self):
        """FL-36c: direct test of m401b34_set_mode_call (original 0x401b34)"""
        self.check('test_m401b34_set_mode_call')

    def test_401b51_set_mode_call(self):
        """FL-36c: direct test of m401b51_set_mode_call (original 0x401b51)"""
        self.check('test_m401b51_set_mode_call')

    def test_401b6e_set_mode_call(self):
        """FL-36c: direct test of m401b6e_set_mode_call (original 0x401b6e)"""
        self.check('test_m401b6e_set_mode_call')

    def test_401b8b_set_mode_call(self):
        """FL-36c: direct test of m401b8b_set_mode_call (original 0x401b8b)"""
        self.check('test_m401b8b_set_mode_call')

    def test_401ba8_set_mode_call(self):
        """FL-36c: direct test of m401ba8_set_mode_call (original 0x401ba8)"""
        self.check('test_m401ba8_set_mode_call')

    def test_401bc5_set_mode_call(self):
        """FL-36c: direct test of m401bc5_set_mode_call (original 0x401bc5)"""
        self.check('test_m401bc5_set_mode_call')

    def test_401be2_set_mode_call(self):
        """FL-36c: direct test of m401be2_set_mode_call (original 0x401be2)"""
        self.check('test_m401be2_set_mode_call')

    def test_401bff_set_mode_call(self):
        """FL-36c: direct test of m401bff_set_mode_call (original 0x401bff)"""
        self.check('test_m401bff_set_mode_call')

    def test_404af0_init_vtable_call(self):
        """FL-36c: direct test of m404af0_init_vtable_call (original 0x404af0)"""
        self.check('test_m404af0_init_vtable_call')

    def test_41458b_init_vtable_call(self):
        """FL-36c: direct test of m41458b_init_vtable_call (original 0x41458b)"""
        self.check('test_m41458b_init_vtable_call')

    def test_414ccf_init_vtable_call(self):
        """FL-36c: direct test of m414ccf_init_vtable_call (original 0x414ccf)"""
        self.check('test_m414ccf_init_vtable_call')

    def test_437710_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m437710_init_vtable_call_ret_self (original 0x437710)"""
        self.check('test_m437710_init_vtable_call_ret_self')

    def test_43eb59_init_vtable_call(self):
        """FL-36c: direct test of m43eb59_init_vtable_call (original 0x43eb59)"""
        self.check('test_m43eb59_init_vtable_call')

    def test_445df0_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m445df0_init_vtable_call_ret_self (original 0x445df0)"""
        self.check('test_m445df0_init_vtable_call_ret_self')

    def test_445e0f_init_vtable_call(self):
        """FL-36c: direct test of m445e0f_init_vtable_call (original 0x445e0f)"""
        self.check('test_m445e0f_init_vtable_call')

    def test_447d10_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m447d10_init_vtable_call_ret_self (original 0x447d10)"""
        self.check('test_m447d10_init_vtable_call_ret_self')

    def test_447d2f_init_vtable_call(self):
        """FL-36c: direct test of m447d2f_init_vtable_call (original 0x447d2f)"""
        self.check('test_m447d2f_init_vtable_call')

    def test_447e46_init_vtable_call(self):
        """FL-36c: direct test of m447e46_init_vtable_call (original 0x447e46)"""
        self.check('test_m447e46_init_vtable_call')

    def test_448820_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m448820_init_vtable_call_ret_self (original 0x448820)"""
        self.check('test_m448820_init_vtable_call_ret_self')

    def test_449a78_init_vtable_call(self):
        """FL-36c: direct test of m449a78_init_vtable_call (original 0x449a78)"""
        self.check('test_m449a78_init_vtable_call')

    def test_44afd6_init_vtable_call(self):
        """FL-36c: direct test of m44afd6_init_vtable_call (original 0x44afd6)"""
        self.check('test_m44afd6_init_vtable_call')

    def test_44d0eb_init_vtable_call(self):
        """FL-36c: direct test of m44d0eb_init_vtable_call (original 0x44d0eb)"""
        self.check('test_m44d0eb_init_vtable_call')

    def test_44e74b_init_vtable_call(self):
        """FL-36c: direct test of m44e74b_init_vtable_call (original 0x44e74b)"""
        self.check('test_m44e74b_init_vtable_call')

    def test_44f650_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m44f650_init_vtable_call_ret_self (original 0x44f650)"""
        self.check('test_m44f650_init_vtable_call_ret_self')

    def test_44f66f_init_vtable_call(self):
        """FL-36c: direct test of m44f66f_init_vtable_call (original 0x44f66f)"""
        self.check('test_m44f66f_init_vtable_call')

    def test_454d6e_init_vtable_call(self):
        """FL-36c: direct test of m454d6e_init_vtable_call (original 0x454d6e)"""
        self.check('test_m454d6e_init_vtable_call')

    def test_456ceb_init_vtable_call(self):
        """FL-36c: direct test of m456ceb_init_vtable_call (original 0x456ceb)"""
        self.check('test_m456ceb_init_vtable_call')

    def test_457f5e_init_vtable_call(self):
        """FL-36c: direct test of m457f5e_init_vtable_call (original 0x457f5e)"""
        self.check('test_m457f5e_init_vtable_call')

    def test_459ace_init_vtable_call(self):
        """FL-36c: direct test of m459ace_init_vtable_call (original 0x459ace)"""
        self.check('test_m459ace_init_vtable_call')

    def test_45b3ce_init_vtable_call(self):
        """FL-36c: direct test of m45b3ce_init_vtable_call (original 0x45b3ce)"""
        self.check('test_m45b3ce_init_vtable_call')

    def test_45dc6e_init_vtable_call(self):
        """FL-36c: direct test of m45dc6e_init_vtable_call (original 0x45dc6e)"""
        self.check('test_m45dc6e_init_vtable_call')

    def test_46180b_init_vtable_call(self):
        """FL-36c: direct test of m46180b_init_vtable_call (original 0x46180b)"""
        self.check('test_m46180b_init_vtable_call')

    def test_463ffe_init_vtable_call(self):
        """FL-36c: direct test of m463ffe_init_vtable_call (original 0x463ffe)"""
        self.check('test_m463ffe_init_vtable_call')

    def test_465aeb_init_vtable_call(self):
        """FL-36c: direct test of m465aeb_init_vtable_call (original 0x465aeb)"""
        self.check('test_m465aeb_init_vtable_call')

    def test_4674e0_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4674e0_init_vtable_call_ret_self (original 0x4674e0)"""
        self.check('test_m4674e0_init_vtable_call_ret_self')

    def test_468e3e_init_vtable_call(self):
        """FL-36c: direct test of m468e3e_init_vtable_call (original 0x468e3e)"""
        self.check('test_m468e3e_init_vtable_call')

    def test_46b56e_init_vtable_call(self):
        """FL-36c: direct test of m46b56e_init_vtable_call (original 0x46b56e)"""
        self.check('test_m46b56e_init_vtable_call')

    def test_470d5e_init_vtable_call(self):
        """FL-36c: direct test of m470d5e_init_vtable_call (original 0x470d5e)"""
        self.check('test_m470d5e_init_vtable_call')

    def test_4757be_init_vtable_call(self):
        """FL-36c: direct test of m4757be_init_vtable_call (original 0x4757be)"""
        self.check('test_m4757be_init_vtable_call')

    def test_4781de_init_vtable_call(self):
        """FL-36c: direct test of m4781de_init_vtable_call (original 0x4781de)"""
        self.check('test_m4781de_init_vtable_call')

    def test_47b21f_init_vtable_call(self):
        """FL-36c: direct test of m47b21f_init_vtable_call (original 0x47b21f)"""
        self.check('test_m47b21f_init_vtable_call')

    def test_47d4db_init_vtable_call(self):
        """FL-36c: direct test of m47d4db_init_vtable_call (original 0x47d4db)"""
        self.check('test_m47d4db_init_vtable_call')

    def test_47e23e_init_vtable_call(self):
        """FL-36c: direct test of m47e23e_init_vtable_call (original 0x47e23e)"""
        self.check('test_m47e23e_init_vtable_call')

    def test_48215e_init_vtable_call(self):
        """FL-36c: direct test of m48215e_init_vtable_call (original 0x48215e)"""
        self.check('test_m48215e_init_vtable_call')

    def test_483f4e_init_vtable_call(self):
        """FL-36c: direct test of m483f4e_init_vtable_call (original 0x483f4e)"""
        self.check('test_m483f4e_init_vtable_call')

    def test_487afe_init_vtable_call(self):
        """FL-36c: direct test of m487afe_init_vtable_call (original 0x487afe)"""
        self.check('test_m487afe_init_vtable_call')

    def test_488d89_init_vtable_call(self):
        """FL-36c: direct test of m488d89_init_vtable_call (original 0x488d89)"""
        self.check('test_m488d89_init_vtable_call')

    def test_48a6ee_init_vtable_call(self):
        """FL-36c: direct test of m48a6ee_init_vtable_call (original 0x48a6ee)"""
        self.check('test_m48a6ee_init_vtable_call')

    def test_48bafb_init_vtable_call(self):
        """FL-36c: direct test of m48bafb_init_vtable_call (original 0x48bafb)"""
        self.check('test_m48bafb_init_vtable_call')

    def test_48d04b_init_vtable_call(self):
        """FL-36c: direct test of m48d04b_init_vtable_call (original 0x48d04b)"""
        self.check('test_m48d04b_init_vtable_call')

    def test_48e26e_init_vtable_call(self):
        """FL-36c: direct test of m48e26e_init_vtable_call (original 0x48e26e)"""
        self.check('test_m48e26e_init_vtable_call')

    def test_4a1c2b_init_vtable_call(self):
        """FL-36c: direct test of m4a1c2b_init_vtable_call (original 0x4a1c2b)"""
        self.check('test_m4a1c2b_init_vtable_call')

    def test_4a376e_init_vtable_call(self):
        """FL-36c: direct test of m4a376e_init_vtable_call (original 0x4a376e)"""
        self.check('test_m4a376e_init_vtable_call')

    def test_4a636e_init_vtable_call(self):
        """FL-36c: direct test of m4a636e_init_vtable_call (original 0x4a636e)"""
        self.check('test_m4a636e_init_vtable_call')

    def test_4a7c5e_init_vtable_call(self):
        """FL-36c: direct test of m4a7c5e_init_vtable_call (original 0x4a7c5e)"""
        self.check('test_m4a7c5e_init_vtable_call')

    def test_4a9f0b_init_vtable_call(self):
        """FL-36c: direct test of m4a9f0b_init_vtable_call (original 0x4a9f0b)"""
        self.check('test_m4a9f0b_init_vtable_call')

    def test_4ab38b_init_vtable_call(self):
        """FL-36c: direct test of m4ab38b_init_vtable_call (original 0x4ab38b)"""
        self.check('test_m4ab38b_init_vtable_call')

    def test_4ac8be_init_vtable_call(self):
        """FL-36c: direct test of m4ac8be_init_vtable_call (original 0x4ac8be)"""
        self.check('test_m4ac8be_init_vtable_call')

    def test_4afd1e_init_vtable_call(self):
        """FL-36c: direct test of m4afd1e_init_vtable_call (original 0x4afd1e)"""
        self.check('test_m4afd1e_init_vtable_call')

    def test_4b3c3e_init_vtable_call(self):
        """FL-36c: direct test of m4b3c3e_init_vtable_call (original 0x4b3c3e)"""
        self.check('test_m4b3c3e_init_vtable_call')

    def test_4b5b6e_init_vtable_call(self):
        """FL-36c: direct test of m4b5b6e_init_vtable_call (original 0x4b5b6e)"""
        self.check('test_m4b5b6e_init_vtable_call')

    def test_4b71db_init_vtable_call(self):
        """FL-36c: direct test of m4b71db_init_vtable_call (original 0x4b71db)"""
        self.check('test_m4b71db_init_vtable_call')

    def test_4b7f00_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4b7f00_init_vtable_call_ret_self (original 0x4b7f00)"""
        self.check('test_m4b7f00_init_vtable_call_ret_self')

    def test_4b7f1f_init_vtable_call(self):
        """FL-36c: direct test of m4b7f1f_init_vtable_call (original 0x4b7f1f)"""
        self.check('test_m4b7f1f_init_vtable_call')

    def test_4b9e00_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4b9e00_init_vtable_call_ret_self (original 0x4b9e00)"""
        self.check('test_m4b9e00_init_vtable_call_ret_self')

    def test_4b9e1f_init_vtable_call(self):
        """FL-36c: direct test of m4b9e1f_init_vtable_call (original 0x4b9e1f)"""
        self.check('test_m4b9e1f_init_vtable_call')

    def test_4bed99_init_vtable_call(self):
        """FL-36c: direct test of m4bed99_init_vtable_call (original 0x4bed99)"""
        self.check('test_m4bed99_init_vtable_call')

    def test_4bf600_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4bf600_init_vtable_call_ret_self (original 0x4bf600)"""
        self.check('test_m4bf600_init_vtable_call_ret_self')

    def test_4bf61f_init_vtable_call(self):
        """FL-36c: direct test of m4bf61f_init_vtable_call (original 0x4bf61f)"""
        self.check('test_m4bf61f_init_vtable_call')

    def test_4caed0_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4caed0_init_vtable_call_ret_self (original 0x4caed0)"""
        self.check('test_m4caed0_init_vtable_call_ret_self')

    def test_4cc946_init_vtable_call(self):
        """FL-36c: direct test of m4cc946_init_vtable_call (original 0x4cc946)"""
        self.check('test_m4cc946_init_vtable_call')

    def test_4ccd8f_init_vtable_call(self):
        """FL-36c: direct test of m4ccd8f_init_vtable_call (original 0x4ccd8f)"""
        self.check('test_m4ccd8f_init_vtable_call')

    def test_4d3b6e_init_vtable_call(self):
        """FL-36c: direct test of m4d3b6e_init_vtable_call (original 0x4d3b6e)"""
        self.check('test_m4d3b6e_init_vtable_call')

    def test_4d5260_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4d5260_init_vtable_call_ret_self (original 0x4d5260)"""
        self.check('test_m4d5260_init_vtable_call_ret_self')

    def test_4d527f_init_vtable_call(self):
        """FL-36c: direct test of m4d527f_init_vtable_call (original 0x4d527f)"""
        self.check('test_m4d527f_init_vtable_call')

    def test_4d58b0_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4d58b0_init_vtable_call_ret_self (original 0x4d58b0)"""
        self.check('test_m4d58b0_init_vtable_call_ret_self')

    def test_4d58cf_init_vtable_call(self):
        """FL-36c: direct test of m4d58cf_init_vtable_call (original 0x4d58cf)"""
        self.check('test_m4d58cf_init_vtable_call')

    def test_4db260_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4db260_init_vtable_call_ret_self (original 0x4db260)"""
        self.check('test_m4db260_init_vtable_call_ret_self')

    def test_4db27f_init_vtable_call(self):
        """FL-36c: direct test of m4db27f_init_vtable_call (original 0x4db27f)"""
        self.check('test_m4db27f_init_vtable_call')

    def test_4dd3b0_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4dd3b0_init_vtable_call_ret_self (original 0x4dd3b0)"""
        self.check('test_m4dd3b0_init_vtable_call_ret_self')

    def test_4dd3cf_init_vtable_call(self):
        """FL-36c: direct test of m4dd3cf_init_vtable_call (original 0x4dd3cf)"""
        self.check('test_m4dd3cf_init_vtable_call')

    def test_4e1c83_init_vtable_call(self):
        """FL-36c: direct test of m4e1c83_init_vtable_call (original 0x4e1c83)"""
        self.check('test_m4e1c83_init_vtable_call')

    def test_4ee980_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4ee980_init_vtable_call_ret_self (original 0x4ee980)"""
        self.check('test_m4ee980_init_vtable_call_ret_self')

    def test_4ee99f_init_vtable_call(self):
        """FL-36c: direct test of m4ee99f_init_vtable_call (original 0x4ee99f)"""
        self.check('test_m4ee99f_init_vtable_call')

    def test_4f0000_init_vtable_call_ret_self(self):
        """FL-36c: direct test of m4f0000_init_vtable_call_ret_self (original 0x4f0000)"""
        self.check('test_m4f0000_init_vtable_call_ret_self')

    def test_4f001f_init_vtable_call(self):
        """FL-36c: direct test of m4f001f_init_vtable_call (original 0x4f001f)"""
        self.check('test_m4f001f_init_vtable_call')

    def test_4fa9e7_init_vtable_call(self):
        """FL-36c: direct test of m4fa9e7_init_vtable_call (original 0x4fa9e7)"""
        self.check('test_m4fa9e7_init_vtable_call')

    def test_exact_size_buffers(self):
        """FL-36c: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
