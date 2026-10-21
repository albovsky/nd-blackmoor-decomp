"""FL-36 (batch e): direct C tests of the GAME.EXE functions in src/original_methods_fl36e.c.

tests/fl36e_direct_test.c links src/original_methods_fl36e.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl36e_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl36e_direct_test.c'
KERNELS = ['original_methods_fl36e.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl36e_fixtures as fx
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


class Fl36eDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl36e_direct_test'
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

    def test_402945_empty_method_args(self):
        """FL-36e: direct test of m402945_empty_method_args (original 0x402945)"""
        self.check('test_m402945_empty_method_args')

    def test_40338e_empty_method_args(self):
        """FL-36e: direct test of m40338e_empty_method_args (original 0x40338e)"""
        self.check('test_m40338e_empty_method_args')

    def test_4033ab_call_two_return_const(self):
        """FL-36e: direct test of m4033ab_call_two_return_const (original 0x4033ab)"""
        self.check('test_m4033ab_call_two_return_const')

    def test_404b0c_empty_method_args(self):
        """FL-36e: direct test of m404b0c_empty_method_args (original 0x404b0c)"""
        self.check('test_m404b0c_empty_method_args')

    def test_404b19_call_two_return_const(self):
        """FL-36e: direct test of m404b19_call_two_return_const (original 0x404b19)"""
        self.check('test_m404b19_call_two_return_const')

    def test_407c8a_empty_method_args(self):
        """FL-36e: direct test of m407c8a_empty_method_args (original 0x407c8a)"""
        self.check('test_m407c8a_empty_method_args')

    def test_407d70_call_two_return_const(self):
        """FL-36e: direct test of m407d70_call_two_return_const (original 0x407d70)"""
        self.check('test_m407d70_call_two_return_const')

    def test_40905e_empty_method_args(self):
        """FL-36e: direct test of m40905e_empty_method_args (original 0x40905e)"""
        self.check('test_m40905e_empty_method_args')

    def test_40907b_call_two_return_const(self):
        """FL-36e: direct test of m40907b_call_two_return_const (original 0x40907b)"""
        self.check('test_m40907b_call_two_return_const')

    def test_414cb0_destruct_base_set_vtable(self):
        """FL-36e: direct test of m414cb0_destruct_base_set_vtable (original 0x414cb0)"""
        self.check('test_m414cb0_destruct_base_set_vtable')

    def test_423450_init_vtable_ret_self(self):
        """FL-36e: direct test of m423450_init_vtable_ret_self (original 0x423450)"""
        self.check('test_m423450_init_vtable_ret_self')

    def test_423467_init_vtable_ret_self(self):
        """FL-36e: direct test of m423467_init_vtable_ret_self (original 0x423467)"""
        self.check('test_m423467_init_vtable_ret_self')

    def test_4234b5_forward_call(self):
        """FL-36e: direct test of m4234b5_forward_call (original 0x4234b5)"""
        self.check('test_m4234b5_forward_call')

    def test_426b5d_call_global_object(self):
        """FL-36e: direct test of m426b5d_call_global_object (original 0x426b5d)"""
        self.check('test_m426b5d_call_global_object')

    def test_426b7e_call_global_object(self):
        """FL-36e: direct test of m426b7e_call_global_object (original 0x426b7e)"""
        self.check('test_m426b7e_call_global_object')

    def test_43772f_init_vtable_ret_self(self):
        """FL-36e: direct test of m43772f_init_vtable_ret_self (original 0x43772f)"""
        self.check('test_m43772f_init_vtable_ret_self')

    def test_43eb3a_destruct_base_set_vtable(self):
        """FL-36e: direct test of m43eb3a_destruct_base_set_vtable (original 0x43eb3a)"""
        self.check('test_m43eb3a_destruct_base_set_vtable')

    def test_43ef10_init_vtable_ret_self(self):
        """FL-36e: direct test of m43ef10_init_vtable_ret_self (original 0x43ef10)"""
        self.check('test_m43ef10_init_vtable_ret_self')

    def test_43ef27_init_vtable_ret_self(self):
        """FL-36e: direct test of m43ef27_init_vtable_ret_self (original 0x43ef27)"""
        self.check('test_m43ef27_init_vtable_ret_self')

    def test_445f40_forward_call(self):
        """FL-36e: direct test of m445f40_forward_call (original 0x445f40)"""
        self.check('test_m445f40_forward_call')

    def test_447d4b_set_field_const(self):
        """FL-36e: direct test of m447d4b_set_field_const (original 0x447d4b)"""
        self.check('test_m447d4b_set_field_const')

    def test_447e27_destruct_base_set_vtable(self):
        """FL-36e: direct test of m447e27_destruct_base_set_vtable (original 0x447e27)"""
        self.check('test_m447e27_destruct_base_set_vtable')

    def test_447e62_set_field_arg(self):
        """FL-36e: direct test of m447e62_set_field_arg (original 0x447e62)"""
        self.check('test_m447e62_set_field_arg')

    def test_44883f_init_vtable_ret_self(self):
        """FL-36e: direct test of m44883f_init_vtable_ret_self (original 0x44883f)"""
        self.check('test_m44883f_init_vtable_ret_self')

    def test_44885e_forward_call(self):
        """FL-36e: direct test of m44885e_forward_call (original 0x44885e)"""
        self.check('test_m44885e_forward_call')

    def test_44afb7_destruct_base_set_vtable(self):
        """FL-36e: direct test of m44afb7_destruct_base_set_vtable (original 0x44afb7)"""
        self.check('test_m44afb7_destruct_base_set_vtable')

    def test_44be90_init_vtable_ret_self(self):
        """FL-36e: direct test of m44be90_init_vtable_ret_self (original 0x44be90)"""
        self.check('test_m44be90_init_vtable_ret_self')

    def test_44bea7_init_vtable_ret_self(self):
        """FL-36e: direct test of m44bea7_init_vtable_ret_self (original 0x44bea7)"""
        self.check('test_m44bea7_init_vtable_ret_self')

    def test_454d8a_set_word(self):
        """FL-36e: direct test of m454d8a_set_word (original 0x454d8a)"""
        self.check('test_m454d8a_set_word')

    def test_456dab_set_two_words(self):
        """FL-36e: direct test of m456dab_set_two_words (original 0x456dab)"""
        self.check('test_m456dab_set_two_words')

    def test_46401a_set_word(self):
        """FL-36e: direct test of m46401a_set_word (original 0x46401a)"""
        self.check('test_m46401a_set_word')

    def test_4674ff_init_vtable_ret_self(self):
        """FL-36e: direct test of m4674ff_init_vtable_ret_self (original 0x4674ff)"""
        self.check('test_m4674ff_init_vtable_ret_self')

    def test_46b73e_set_two_words(self):
        """FL-36e: direct test of m46b73e_set_two_words (original 0x46b73e)"""
        self.check('test_m46b73e_set_two_words')

    def test_470e71_set_two_words(self):
        """FL-36e: direct test of m470e71_set_two_words (original 0x470e71)"""
        self.check('test_m470e71_set_two_words')

    def test_4712b0_empty_method_args(self):
        """FL-36e: direct test of m4712b0_empty_method_args (original 0x4712b0)"""
        self.check('test_m4712b0_empty_method_args')

    def test_4782be_set_two_words(self):
        """FL-36e: direct test of m4782be_set_two_words (original 0x4782be)"""
        self.check('test_m4782be_set_two_words')

    def test_488d6a_destruct_base_set_vtable(self):
        """FL-36e: direct test of m488d6a_destruct_base_set_vtable (original 0x488d6a)"""
        self.check('test_m488d6a_destruct_base_set_vtable')

    def test_48d119_set_word(self):
        """FL-36e: direct test of m48d119_set_word (original 0x48d119)"""
        self.check('test_m48d119_set_word')

    def test_493ad8_set_field_const(self):
        """FL-36e: direct test of m493ad8_set_field_const (original 0x493ad8)"""
        self.check('test_m493ad8_set_field_const')

    def test_4a7ddc_set_two_words(self):
        """FL-36e: direct test of m4a7ddc_set_two_words (original 0x4a7ddc)"""
        self.check('test_m4a7ddc_set_two_words')

    def test_4ab459_set_word(self):
        """FL-36e: direct test of m4ab459_set_word (original 0x4ab459)"""
        self.check('test_m4ab459_set_word')

    def test_4b5c48_set_word(self):
        """FL-36e: direct test of m4b5c48_set_word (original 0x4b5c48)"""
        self.check('test_m4b5c48_set_word')

    def test_4bf3a4_get_field(self):
        """FL-36e: direct test of m4bf3a4_get_field (original 0x4bf3a4)"""
        self.check('test_m4bf3a4_get_field')

    def test_4c0c40_get_field(self):
        """FL-36e: direct test of m4c0c40_get_field (original 0x4c0c40)"""
        self.check('test_m4c0c40_get_field')

    def test_4caeef_init_vtable_ret_self(self):
        """FL-36e: direct test of m4caeef_init_vtable_ret_self (original 0x4caeef)"""
        self.check('test_m4caeef_init_vtable_ret_self')

    def test_4cc927_destruct_base_set_vtable(self):
        """FL-36e: direct test of m4cc927_destruct_base_set_vtable (original 0x4cc927)"""
        self.check('test_m4cc927_destruct_base_set_vtable')

    def test_4d3705_call_global_object(self):
        """FL-36e: direct test of m4d3705_call_global_object (original 0x4d3705)"""
        self.check('test_m4d3705_call_global_object')

    def test_4d3714_call_global_object(self):
        """FL-36e: direct test of m4d3714_call_global_object (original 0x4d3714)"""
        self.check('test_m4d3714_call_global_object')

    def test_4d3c1d_get_field(self):
        """FL-36e: direct test of m4d3c1d_get_field (original 0x4d3c1d)"""
        self.check('test_m4d3c1d_get_field')

    def test_4d51ea_empty_method_args(self):
        """FL-36e: direct test of m4d51ea_empty_method_args (original 0x4d51ea)"""
        self.check('test_m4d51ea_empty_method_args')

    def test_4d52a6_forward_call(self):
        """FL-36e: direct test of m4d52a6_forward_call (original 0x4d52a6)"""
        self.check('test_m4d52a6_forward_call')

    def test_4dae66_get_field(self):
        """FL-36e: direct test of m4dae66_get_field (original 0x4dae66)"""
        self.check('test_m4dae66_get_field')

    def test_4dae77_get_field(self):
        """FL-36e: direct test of m4dae77_get_field (original 0x4dae77)"""
        self.check('test_m4dae77_get_field')

    def test_4daef1_get_field(self):
        """FL-36e: direct test of m4daef1_get_field (original 0x4daef1)"""
        self.check('test_m4daef1_get_field')

    def test_4daf02_set_field_arg(self):
        """FL-36e: direct test of m4daf02_set_field_arg (original 0x4daf02)"""
        self.check('test_m4daf02_set_field_arg')

    def test_4daf18_get_field(self):
        """FL-36e: direct test of m4daf18_get_field (original 0x4daf18)"""
        self.check('test_m4daf18_get_field')

    def test_4daf29_set_field_arg(self):
        """FL-36e: direct test of m4daf29_set_field_arg (original 0x4daf29)"""
        self.check('test_m4daf29_set_field_arg')

    def test_4db377_forward_call(self):
        """FL-36e: direct test of m4db377_forward_call (original 0x4db377)"""
        self.check('test_m4db377_forward_call')

    def test_4dd3f6_forward_call(self):
        """FL-36e: direct test of m4dd3f6_forward_call (original 0x4dd3f6)"""
        self.check('test_m4dd3f6_forward_call')

    def test_4e0742_set_field_const(self):
        """FL-36e: direct test of m4e0742_set_field_const (original 0x4e0742)"""
        self.check('test_m4e0742_set_field_const')

    def test_4e2940_set_field_arg(self):
        """FL-36e: direct test of m4e2940_set_field_arg (original 0x4e2940)"""
        self.check('test_m4e2940_set_field_arg')

    def test_4e2956_get_field(self):
        """FL-36e: direct test of m4e2956_get_field (original 0x4e2956)"""
        self.check('test_m4e2956_get_field')

    def test_4e2967_get_field(self):
        """FL-36e: direct test of m4e2967_get_field (original 0x4e2967)"""
        self.check('test_m4e2967_get_field')

    def test_4e2978_set_field_const(self):
        """FL-36e: direct test of m4e2978_set_field_const (original 0x4e2978)"""
        self.check('test_m4e2978_set_field_const')

    def test_4e2990_set_field_arg(self):
        """FL-36e: direct test of m4e2990_set_field_arg (original 0x4e2990)"""
        self.check('test_m4e2990_set_field_arg')

    def test_4e29a6_get_field(self):
        """FL-36e: direct test of m4e29a6_get_field (original 0x4e29a6)"""
        self.check('test_m4e29a6_get_field')

    def test_4e40fb_forward_call_arg(self):
        """FL-36e: direct test of m4e40fb_forward_call_arg (original 0x4e40fb)"""
        self.check('test_m4e40fb_forward_call_arg')

    def test_4e4114_forward_call_arg(self):
        """FL-36e: direct test of m4e4114_forward_call_arg (original 0x4e4114)"""
        self.check('test_m4e4114_forward_call_arg')

    def test_4e779f_forward_call_arg(self):
        """FL-36e: direct test of m4e779f_forward_call_arg (original 0x4e779f)"""
        self.check('test_m4e779f_forward_call_arg')

    def test_4e89b9_forward_call_arg(self):
        """FL-36e: direct test of m4e89b9_forward_call_arg (original 0x4e89b9)"""
        self.check('test_m4e89b9_forward_call_arg')

    def test_4e89d2_forward_call_arg(self):
        """FL-36e: direct test of m4e89d2_forward_call_arg (original 0x4e89d2)"""
        self.check('test_m4e89d2_forward_call_arg')

    def test_4e9e6c_set_field_const(self):
        """FL-36e: direct test of m4e9e6c_set_field_const (original 0x4e9e6c)"""
        self.check('test_m4e9e6c_set_field_const')

    def test_4ebd53_forward_call_arg(self):
        """FL-36e: direct test of m4ebd53_forward_call_arg (original 0x4ebd53)"""
        self.check('test_m4ebd53_forward_call_arg')

    def test_4ebd6c_forward_call_arg(self):
        """FL-36e: direct test of m4ebd6c_forward_call_arg (original 0x4ebd6c)"""
        self.check('test_m4ebd6c_forward_call_arg')

    def test_4ee602_get_field(self):
        """FL-36e: direct test of m4ee602_get_field (original 0x4ee602)"""
        self.check('test_m4ee602_get_field')

    def test_4ee630_get_field(self):
        """FL-36e: direct test of m4ee630_get_field (original 0x4ee630)"""
        self.check('test_m4ee630_get_field')

    def test_4ef4c9_set_field_arg(self):
        """FL-36e: direct test of m4ef4c9_set_field_arg (original 0x4ef4c9)"""
        self.check('test_m4ef4c9_set_field_arg')

    def test_4ef4df_get_field(self):
        """FL-36e: direct test of m4ef4df_get_field (original 0x4ef4df)"""
        self.check('test_m4ef4df_get_field')

    def test_4ef516_get_field(self):
        """FL-36e: direct test of m4ef516_get_field (original 0x4ef516)"""
        self.check('test_m4ef516_get_field')

    def test_4f0046_forward_call(self):
        """FL-36e: direct test of m4f0046_forward_call (original 0x4f0046)"""
        self.check('test_m4f0046_forward_call')

    def test_exact_size_buffers(self):
        """FL-36e: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
