"""FL-36 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl36b.c.

tests/fl36b_direct_test.c links src/original_methods_fl36b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl36b_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl36b_direct_test.c'
KERNELS = ['original_methods_fl36b.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl36b_fixtures as fx
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


class Fl36bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl36b_direct_test'
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

    def test_40104e_get_constant(self):
        """FL-36b: direct test of m40104e_get_constant (original 0x40104e)"""
        self.check('test_m40104e_get_constant')

    def test_4010b0_get_constant(self):
        """FL-36b: direct test of m4010b0_get_constant (original 0x4010b0)"""
        self.check('test_m4010b0_get_constant')

    def test_40148a_get_constant(self):
        """FL-36b: direct test of m40148a_get_constant (original 0x40148a)"""
        self.check('test_m40148a_get_constant')

    def test_40167f_get_constant(self):
        """FL-36b: direct test of m40167f_get_constant (original 0x40167f)"""
        self.check('test_m40167f_get_constant')

    def test_402952_get_constant(self):
        """FL-36b: direct test of m402952_get_constant (original 0x402952)"""
        self.check('test_m402952_get_constant')

    def test_4030aa_get_constant(self):
        """FL-36b: direct test of m4030aa_get_constant (original 0x4030aa)"""
        self.check('test_m4030aa_get_constant')

    def test_40339b_get_constant(self):
        """FL-36b: direct test of m40339b_get_constant (original 0x40339b)"""
        self.check('test_m40339b_get_constant')

    def test_4033cb_get_constant(self):
        """FL-36b: direct test of m4033cb_get_constant (original 0x4033cb)"""
        self.check('test_m4033cb_get_constant')

    def test_404aba_get_constant(self):
        """FL-36b: direct test of m404aba_get_constant (original 0x404aba)"""
        self.check('test_m404aba_get_constant')

    def test_404b39_get_constant(self):
        """FL-36b: direct test of m404b39_get_constant (original 0x404b39)"""
        self.check('test_m404b39_get_constant')

    def test_405b62_get_constant(self):
        """FL-36b: direct test of m405b62_get_constant (original 0x405b62)"""
        self.check('test_m405b62_get_constant')

    def test_407baa_get_constant(self):
        """FL-36b: direct test of m407baa_get_constant (original 0x407baa)"""
        self.check('test_m407baa_get_constant')

    def test_407c97_get_constant(self):
        """FL-36b: direct test of m407c97_get_constant (original 0x407c97)"""
        self.check('test_m407c97_get_constant')

    def test_407d90_get_constant(self):
        """FL-36b: direct test of m407d90_get_constant (original 0x407d90)"""
        self.check('test_m407d90_get_constant')

    def test_408a1a_get_constant(self):
        """FL-36b: direct test of m408a1a_get_constant (original 0x408a1a)"""
        self.check('test_m408a1a_get_constant')

    def test_40906b_get_constant(self):
        """FL-36b: direct test of m40906b_get_constant (original 0x40906b)"""
        self.check('test_m40906b_get_constant')

    def test_40909b_get_constant(self):
        """FL-36b: direct test of m40909b_get_constant (original 0x40909b)"""
        self.check('test_m40909b_get_constant')

    def test_414527_get_constant(self):
        """FL-36b: direct test of m414527_get_constant (original 0x414527)"""
        self.check('test_m414527_get_constant')

    def test_41a4be_empty_method(self):
        """FL-36b: direct test of m41a4be_empty_method (original 0x41a4be)"""
        self.check('test_m41a4be_empty_method')

    def test_41be0a_get_constant(self):
        """FL-36b: direct test of m41be0a_get_constant (original 0x41be0a)"""
        self.check('test_m41be0a_get_constant')

    def test_4229fa_get_constant(self):
        """FL-36b: direct test of m4229fa_get_constant (original 0x4229fa)"""
        self.check('test_m4229fa_get_constant')

    def test_426510_get_constant(self):
        """FL-36b: direct test of m426510_get_constant (original 0x426510)"""
        self.check('test_m426510_get_constant')

    def test_43eb1a_get_constant(self):
        """FL-36b: direct test of m43eb1a_get_constant (original 0x43eb1a)"""
        self.check('test_m43eb1a_get_constant')

    def test_43eb2a_get_constant(self):
        """FL-36b: direct test of m43eb2a_get_constant (original 0x43eb2a)"""
        self.check('test_m43eb2a_get_constant')

    def test_43ef00_get_constant(self):
        """FL-36b: direct test of m43ef00_get_constant (original 0x43ef00)"""
        self.check('test_m43ef00_get_constant')

    def test_446f67_get_constant(self):
        """FL-36b: direct test of m446f67_get_constant (original 0x446f67)"""
        self.check('test_m446f67_get_constant')

    def test_447e17_get_constant(self):
        """FL-36b: direct test of m447e17_get_constant (original 0x447e17)"""
        self.check('test_m447e17_get_constant')

    def test_447e78_empty_method(self):
        """FL-36b: direct test of m447e78_empty_method (original 0x447e78)"""
        self.check('test_m447e78_empty_method')

    def test_448853_empty_method(self):
        """FL-36b: direct test of m448853_empty_method (original 0x448853)"""
        self.check('test_m448853_empty_method')

    def test_448871_empty_method(self):
        """FL-36b: direct test of m448871_empty_method (original 0x448871)"""
        self.check('test_m448871_empty_method')

    def test_44afa7_get_constant(self):
        """FL-36b: direct test of m44afa7_get_constant (original 0x44afa7)"""
        self.check('test_m44afa7_get_constant')

    def test_44d087_get_constant(self):
        """FL-36b: direct test of m44d087_get_constant (original 0x44d087)"""
        self.check('test_m44d087_get_constant')

    def test_44e025_get_constant(self):
        """FL-36b: direct test of m44e025_get_constant (original 0x44e025)"""
        self.check('test_m44e025_get_constant')

    def test_44e6e7_get_constant(self):
        """FL-36b: direct test of m44e6e7_get_constant (original 0x44e6e7)"""
        self.check('test_m44e6e7_get_constant')

    def test_44e80b_empty_method(self):
        """FL-36b: direct test of m44e80b_empty_method (original 0x44e80b)"""
        self.check('test_m44e80b_empty_method')

    def test_44f4ea_get_constant(self):
        """FL-36b: direct test of m44f4ea_get_constant (original 0x44f4ea)"""
        self.check('test_m44f4ea_get_constant')

    def test_454d0a_get_constant(self):
        """FL-36b: direct test of m454d0a_get_constant (original 0x454d0a)"""
        self.check('test_m454d0a_get_constant')

    def test_456506_get_constant(self):
        """FL-36b: direct test of m456506_get_constant (original 0x456506)"""
        self.check('test_m456506_get_constant')

    def test_456c87_get_constant(self):
        """FL-36b: direct test of m456c87_get_constant (original 0x456c87)"""
        self.check('test_m456c87_get_constant')

    def test_457bc8_get_constant(self):
        """FL-36b: direct test of m457bc8_get_constant (original 0x457bc8)"""
        self.check('test_m457bc8_get_constant')

    def test_457efa_get_constant(self):
        """FL-36b: direct test of m457efa_get_constant (original 0x457efa)"""
        self.check('test_m457efa_get_constant')

    def test_4595e1_get_constant(self):
        """FL-36b: direct test of m4595e1_get_constant (original 0x4595e1)"""
        self.check('test_m4595e1_get_constant')

    def test_459a6a_get_constant(self):
        """FL-36b: direct test of m459a6a_get_constant (original 0x459a6a)"""
        self.check('test_m459a6a_get_constant')

    def test_45ae5e_get_constant(self):
        """FL-36b: direct test of m45ae5e_get_constant (original 0x45ae5e)"""
        self.check('test_m45ae5e_get_constant')

    def test_45b36a_get_constant(self):
        """FL-36b: direct test of m45b36a_get_constant (original 0x45b36a)"""
        self.check('test_m45b36a_get_constant')

    def test_45d2b6_get_constant(self):
        """FL-36b: direct test of m45d2b6_get_constant (original 0x45d2b6)"""
        self.check('test_m45d2b6_get_constant')

    def test_45dc0a_get_constant(self):
        """FL-36b: direct test of m45dc0a_get_constant (original 0x45dc0a)"""
        self.check('test_m45dc0a_get_constant')

    def test_460f16_get_constant(self):
        """FL-36b: direct test of m460f16_get_constant (original 0x460f16)"""
        self.check('test_m460f16_get_constant')

    def test_4617a7_get_constant(self):
        """FL-36b: direct test of m4617a7_get_constant (original 0x4617a7)"""
        self.check('test_m4617a7_get_constant')

    def test_463b00_get_constant(self):
        """FL-36b: direct test of m463b00_get_constant (original 0x463b00)"""
        self.check('test_m463b00_get_constant')

    def test_463f9a_get_constant(self):
        """FL-36b: direct test of m463f9a_get_constant (original 0x463f9a)"""
        self.check('test_m463f9a_get_constant')

    def test_4657d7_get_constant(self):
        """FL-36b: direct test of m4657d7_get_constant (original 0x4657d7)"""
        self.check('test_m4657d7_get_constant')

    def test_465a87_get_constant(self):
        """FL-36b: direct test of m465a87_get_constant (original 0x465a87)"""
        self.check('test_m465a87_get_constant')

    def test_465bd3_empty_method(self):
        """FL-36b: direct test of m465bd3_empty_method (original 0x465bd3)"""
        self.check('test_m465bd3_empty_method')

    def test_466e04_get_constant(self):
        """FL-36b: direct test of m466e04_get_constant (original 0x466e04)"""
        self.check('test_m466e04_get_constant')

    def test_468dda_get_constant(self):
        """FL-36b: direct test of m468dda_get_constant (original 0x468dda)"""
        self.check('test_m468dda_get_constant')

    def test_46ab6f_get_constant(self):
        """FL-36b: direct test of m46ab6f_get_constant (original 0x46ab6f)"""
        self.check('test_m46ab6f_get_constant')

    def test_46b50a_get_constant(self):
        """FL-36b: direct test of m46b50a_get_constant (original 0x46b50a)"""
        self.check('test_m46b50a_get_constant')

    def test_46dea0_get_constant(self):
        """FL-36b: direct test of m46dea0_get_constant (original 0x46dea0)"""
        self.check('test_m46dea0_get_constant')

    def test_46e5ea_get_constant(self):
        """FL-36b: direct test of m46e5ea_get_constant (original 0x46e5ea)"""
        self.check('test_m46e5ea_get_constant')

    def test_470a63_get_constant(self):
        """FL-36b: direct test of m470a63_get_constant (original 0x470a63)"""
        self.check('test_m470a63_get_constant')

    def test_470cfa_get_constant(self):
        """FL-36b: direct test of m470cfa_get_constant (original 0x470cfa)"""
        self.check('test_m470cfa_get_constant')

    def test_472a4c_get_constant(self):
        """FL-36b: direct test of m472a4c_get_constant (original 0x472a4c)"""
        self.check('test_m472a4c_get_constant')

    def test_47575a_get_constant(self):
        """FL-36b: direct test of m47575a_get_constant (original 0x47575a)"""
        self.check('test_m47575a_get_constant')

    def test_4778cf_get_constant(self):
        """FL-36b: direct test of m4778cf_get_constant (original 0x4778cf)"""
        self.check('test_m4778cf_get_constant')

    def test_47817a_get_constant(self):
        """FL-36b: direct test of m47817a_get_constant (original 0x47817a)"""
        self.check('test_m47817a_get_constant')

    def test_47ac23_get_constant(self):
        """FL-36b: direct test of m47ac23_get_constant (original 0x47ac23)"""
        self.check('test_m47ac23_get_constant')

    def test_47d477_get_constant(self):
        """FL-36b: direct test of m47d477_get_constant (original 0x47d477)"""
        self.check('test_m47d477_get_constant')

    def test_47d677_empty_method(self):
        """FL-36b: direct test of m47d677_empty_method (original 0x47d677)"""
        self.check('test_m47d677_empty_method')

    def test_47df47_get_constant(self):
        """FL-36b: direct test of m47df47_get_constant (original 0x47df47)"""
        self.check('test_m47df47_get_constant')

    def test_47e1da_get_constant(self):
        """FL-36b: direct test of m47e1da_get_constant (original 0x47e1da)"""
        self.check('test_m47e1da_get_constant')

    def test_481ca9_get_constant(self):
        """FL-36b: direct test of m481ca9_get_constant (original 0x481ca9)"""
        self.check('test_m481ca9_get_constant')

    def test_4820fa_get_constant(self):
        """FL-36b: direct test of m4820fa_get_constant (original 0x4820fa)"""
        self.check('test_m4820fa_get_constant')

    def test_483ac9_get_constant(self):
        """FL-36b: direct test of m483ac9_get_constant (original 0x483ac9)"""
        self.check('test_m483ac9_get_constant')

    def test_483eea_get_constant(self):
        """FL-36b: direct test of m483eea_get_constant (original 0x483eea)"""
        self.check('test_m483eea_get_constant')

    def test_4876dd_get_constant(self):
        """FL-36b: direct test of m4876dd_get_constant (original 0x4876dd)"""
        self.check('test_m4876dd_get_constant')

    def test_487a9a_get_constant(self):
        """FL-36b: direct test of m487a9a_get_constant (original 0x487a9a)"""
        self.check('test_m487a9a_get_constant')

    def test_487bcc_empty_method(self):
        """FL-36b: direct test of m487bcc_empty_method (original 0x487bcc)"""
        self.check('test_m487bcc_empty_method')

    def test_4889e0_get_constant(self):
        """FL-36b: direct test of m4889e0_get_constant (original 0x4889e0)"""
        self.check('test_m4889e0_get_constant')

    def test_488d5a_get_constant(self):
        """FL-36b: direct test of m488d5a_get_constant (original 0x488d5a)"""
        self.check('test_m488d5a_get_constant')

    def test_48a3cb_get_constant(self):
        """FL-36b: direct test of m48a3cb_get_constant (original 0x48a3cb)"""
        self.check('test_m48a3cb_get_constant')

    def test_48a68a_get_constant(self):
        """FL-36b: direct test of m48a68a_get_constant (original 0x48a68a)"""
        self.check('test_m48a68a_get_constant')

    def test_48b720_get_constant(self):
        """FL-36b: direct test of m48b720_get_constant (original 0x48b720)"""
        self.check('test_m48b720_get_constant')

    def test_48ba97_get_constant(self):
        """FL-36b: direct test of m48ba97_get_constant (original 0x48ba97)"""
        self.check('test_m48ba97_get_constant')

    def test_48bc9b_empty_method(self):
        """FL-36b: direct test of m48bc9b_empty_method (original 0x48bc9b)"""
        self.check('test_m48bc9b_empty_method')

    def test_48cc60_get_constant(self):
        """FL-36b: direct test of m48cc60_get_constant (original 0x48cc60)"""
        self.check('test_m48cc60_get_constant')

    def test_48cfe7_get_constant(self):
        """FL-36b: direct test of m48cfe7_get_constant (original 0x48cfe7)"""
        self.check('test_m48cfe7_get_constant')

    def test_48dec7_get_constant(self):
        """FL-36b: direct test of m48dec7_get_constant (original 0x48dec7)"""
        self.check('test_m48dec7_get_constant')

    def test_48e20a_get_constant(self):
        """FL-36b: direct test of m48e20a_get_constant (original 0x48e20a)"""
        self.check('test_m48e20a_get_constant')

    def test_49026c_get_constant(self):
        """FL-36b: direct test of m49026c_get_constant (original 0x49026c)"""
        self.check('test_m49026c_get_constant')

    def test_4904ea_get_constant(self):
        """FL-36b: direct test of m4904ea_get_constant (original 0x4904ea)"""
        self.check('test_m4904ea_get_constant')

    def test_494f14_empty_method(self):
        """FL-36b: direct test of m494f14_empty_method (original 0x494f14)"""
        self.check('test_m494f14_empty_method')

    def test_49c45c_get_constant(self):
        """FL-36b: direct test of m49c45c_get_constant (original 0x49c45c)"""
        self.check('test_m49c45c_get_constant')

    def test_49c52a_get_constant(self):
        """FL-36b: direct test of m49c52a_get_constant (original 0x49c52a)"""
        self.check('test_m49c52a_get_constant')

    def test_4a1bc7_get_constant(self):
        """FL-36b: direct test of m4a1bc7_get_constant (original 0x4a1bc7)"""
        self.check('test_m4a1bc7_get_constant')

    def test_4a35c7_get_constant(self):
        """FL-36b: direct test of m4a35c7_get_constant (original 0x4a35c7)"""
        self.check('test_m4a35c7_get_constant')

    def test_4a370a_get_constant(self):
        """FL-36b: direct test of m4a370a_get_constant (original 0x4a370a)"""
        self.check('test_m4a370a_get_constant')

    def test_4a5eda_get_constant(self):
        """FL-36b: direct test of m4a5eda_get_constant (original 0x4a5eda)"""
        self.check('test_m4a5eda_get_constant')

    def test_4a630a_get_constant(self):
        """FL-36b: direct test of m4a630a_get_constant (original 0x4a630a)"""
        self.check('test_m4a630a_get_constant')

    def test_4a64ae_empty_method(self):
        """FL-36b: direct test of m4a64ae_empty_method (original 0x4a64ae)"""
        self.check('test_m4a64ae_empty_method')

    def test_4a7a19_get_constant(self):
        """FL-36b: direct test of m4a7a19_get_constant (original 0x4a7a19)"""
        self.check('test_m4a7a19_get_constant')

    def test_4a7bfa_get_constant(self):
        """FL-36b: direct test of m4a7bfa_get_constant (original 0x4a7bfa)"""
        self.check('test_m4a7bfa_get_constant')

    def test_4a9b1b_get_constant(self):
        """FL-36b: direct test of m4a9b1b_get_constant (original 0x4a9b1b)"""
        self.check('test_m4a9b1b_get_constant')

    def test_4a9ea7_get_constant(self):
        """FL-36b: direct test of m4a9ea7_get_constant (original 0x4a9ea7)"""
        self.check('test_m4a9ea7_get_constant')

    def test_4aaef5_get_constant(self):
        """FL-36b: direct test of m4aaef5_get_constant (original 0x4aaef5)"""
        self.check('test_m4aaef5_get_constant')

    def test_4ab327_get_constant(self):
        """FL-36b: direct test of m4ab327_get_constant (original 0x4ab327)"""
        self.check('test_m4ab327_get_constant')

    def test_4ac488_get_constant(self):
        """FL-36b: direct test of m4ac488_get_constant (original 0x4ac488)"""
        self.check('test_m4ac488_get_constant')

    def test_4ac85a_get_constant(self):
        """FL-36b: direct test of m4ac85a_get_constant (original 0x4ac85a)"""
        self.check('test_m4ac85a_get_constant')

    def test_4afa0e_get_constant(self):
        """FL-36b: direct test of m4afa0e_get_constant (original 0x4afa0e)"""
        self.check('test_m4afa0e_get_constant')

    def test_4afcba_get_constant(self):
        """FL-36b: direct test of m4afcba_get_constant (original 0x4afcba)"""
        self.check('test_m4afcba_get_constant')

    def test_4afdfe_empty_method(self):
        """FL-36b: direct test of m4afdfe_empty_method (original 0x4afdfe)"""
        self.check('test_m4afdfe_empty_method')

    def test_4b371c_get_constant(self):
        """FL-36b: direct test of m4b371c_get_constant (original 0x4b371c)"""
        self.check('test_m4b371c_get_constant')

    def test_4b3bda_get_constant(self):
        """FL-36b: direct test of m4b3bda_get_constant (original 0x4b3bda)"""
        self.check('test_m4b3bda_get_constant')

    def test_4b5838_get_constant(self):
        """FL-36b: direct test of m4b5838_get_constant (original 0x4b5838)"""
        self.check('test_m4b5838_get_constant')

    def test_4b5b0a_get_constant(self):
        """FL-36b: direct test of m4b5b0a_get_constant (original 0x4b5b0a)"""
        self.check('test_m4b5b0a_get_constant')

    def test_4b7041_get_constant(self):
        """FL-36b: direct test of m4b7041_get_constant (original 0x4b7041)"""
        self.check('test_m4b7041_get_constant')

    def test_4b7177_get_constant(self):
        """FL-36b: direct test of m4b7177_get_constant (original 0x4b7177)"""
        self.check('test_m4b7177_get_constant')

    def test_4b7ddd_get_constant(self):
        """FL-36b: direct test of m4b7ddd_get_constant (original 0x4b7ddd)"""
        self.check('test_m4b7ddd_get_constant')

    def test_4c0f60_get_constant(self):
        """FL-36b: direct test of m4c0f60_get_constant (original 0x4c0f60)"""
        self.check('test_m4c0f60_get_constant')

    def test_4cc917_get_constant(self):
        """FL-36b: direct test of m4cc917_get_constant (original 0x4cc917)"""
        self.check('test_m4cc917_get_constant')

    def test_4d3b0a_get_constant(self):
        """FL-36b: direct test of m4d3b0a_get_constant (original 0x4d3b0a)"""
        self.check('test_m4d3b0a_get_constant')

    def test_4d3b8a_empty_method(self):
        """FL-36b: direct test of m4d3b8a_empty_method (original 0x4d3b8a)"""
        self.check('test_m4d3b8a_empty_method')

    def test_4d3d3d_empty_method(self):
        """FL-36b: direct test of m4d3d3d_empty_method (original 0x4d3d3d)"""
        self.check('test_m4d3d3d_empty_method')

    def test_4d4192_get_constant(self):
        """FL-36b: direct test of m4d4192_get_constant (original 0x4d4192)"""
        self.check('test_m4d4192_get_constant')

    def test_4d51f7_get_constant(self):
        """FL-36b: direct test of m4d51f7_get_constant (original 0x4d51f7)"""
        self.check('test_m4d51f7_get_constant')

    def test_4d529b_empty_method(self):
        """FL-36b: direct test of m4d529b_empty_method (original 0x4d529b)"""
        self.check('test_m4d529b_empty_method')

    def test_4dbf0a_get_constant(self):
        """FL-36b: direct test of m4dbf0a_get_constant (original 0x4dbf0a)"""
        self.check('test_m4dbf0a_get_constant')

    def test_4dd3eb_empty_method(self):
        """FL-36b: direct test of m4dd3eb_empty_method (original 0x4dd3eb)"""
        self.check('test_m4dd3eb_empty_method')

    def test_4f003b_empty_method(self):
        """FL-36b: direct test of m4f003b_empty_method (original 0x4f003b)"""
        self.check('test_m4f003b_empty_method')

    def test_exact_size_buffers(self):
        """FL-36b: every port on heap buffers of exactly the size the original touches (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_exact_size_buffers')



if __name__ == '__main__':
    unittest.main()
