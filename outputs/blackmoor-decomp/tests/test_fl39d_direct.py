"""FL-39 (batch d): direct C tests of the GAME.EXE functions in src/original_methods_fl39d.c.

tests/fl39d_direct_test.c links src/original_methods_fl39d.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function; the Unicorn comparison against the original bytes is in
tests/test_fl39d_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl39d_direct_test.c'
KERNELS = ['original_methods_fl39d.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl39d_fixtures as fx
EXPECTED = ['test_m%s_%s' % (k, fx.NAMES[k]) for k in fx.KEYS]


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


class Fl39dDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl39d_direct_test'
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

    def test_48217a_lifted(self):
        """FL-39d: direct test of m48217a_lifted (original 0x48217a)"""
        self.check('test_m48217a_lifted')

    def test_4821ab_lifted(self):
        """FL-39d: direct test of m4821ab_lifted (original 0x4821ab)"""
        self.check('test_m4821ab_lifted')

    def test_487dcf_lifted(self):
        """FL-39d: direct test of m487dcf_lifted (original 0x487dcf)"""
        self.check('test_m487dcf_lifted')

    def test_488e54_lifted(self):
        """FL-39d: direct test of m488e54_lifted (original 0x488e54)"""
        self.check('test_m488e54_lifted')

    def test_48a70a_lifted(self):
        """FL-39d: direct test of m48a70a_lifted (original 0x48a70a)"""
        self.check('test_m48a70a_lifted')

    def test_48aa66_lifted(self):
        """FL-39d: direct test of m48aa66_lifted (original 0x48aa66)"""
        self.check('test_m48aa66_lifted')

    def test_48e28a_lifted(self):
        """FL-39d: direct test of m48e28a_lifted (original 0x48e28a)"""
        self.check('test_m48e28a_lifted')

    def test_4911ca_lifted(self):
        """FL-39d: direct test of m4911ca_lifted (original 0x4911ca)"""
        self.check('test_m4911ca_lifted')

    def test_491422_lifted(self):
        """FL-39d: direct test of m491422_lifted (original 0x491422)"""
        self.check('test_m491422_lifted')

    def test_491885_lifted(self):
        """FL-39d: direct test of m491885_lifted (original 0x491885)"""
        self.check('test_m491885_lifted')

    def test_4921a1_lifted(self):
        """FL-39d: direct test of m4921a1_lifted (original 0x4921a1)"""
        self.check('test_m4921a1_lifted')

    def test_493a54_lifted(self):
        """FL-39d: direct test of m493a54_lifted (original 0x493a54)"""
        self.check('test_m493a54_lifted')

    def test_493af0_lifted(self):
        """FL-39d: direct test of m493af0_lifted (original 0x493af0)"""
        self.check('test_m493af0_lifted')

    def test_493b2e_lifted(self):
        """FL-39d: direct test of m493b2e_lifted (original 0x493b2e)"""
        self.check('test_m493b2e_lifted')

    def test_493c34_lifted(self):
        """FL-39d: direct test of m493c34_lifted (original 0x493c34)"""
        self.check('test_m493c34_lifted')

    def test_495a5b_lifted(self):
        """FL-39d: direct test of m495a5b_lifted (original 0x495a5b)"""
        self.check('test_m495a5b_lifted')

    def test_49c46c_lifted(self):
        """FL-39d: direct test of m49c46c_lifted (original 0x49c46c)"""
        self.check('test_m49c46c_lifted')

    def test_49c68a_lifted(self):
        """FL-39d: direct test of m49c68a_lifted (original 0x49c68a)"""
        self.check('test_m49c68a_lifted')

    def test_4a1d14_lifted(self):
        """FL-39d: direct test of m4a1d14_lifted (original 0x4a1d14)"""
        self.check('test_m4a1d14_lifted')

    def test_4a1e93_lifted(self):
        """FL-39d: direct test of m4a1e93_lifted (original 0x4a1e93)"""
        self.check('test_m4a1e93_lifted')

    def test_4a1fd1_lifted(self):
        """FL-39d: direct test of m4a1fd1_lifted (original 0x4a1fd1)"""
        self.check('test_m4a1fd1_lifted')

    def test_4a378a_lifted(self):
        """FL-39d: direct test of m4a378a_lifted (original 0x4a378a)"""
        self.check('test_m4a378a_lifted')

    def test_4a39c4_lifted(self):
        """FL-39d: direct test of m4a39c4_lifted (original 0x4a39c4)"""
        self.check('test_m4a39c4_lifted')

    def test_4a3beb_lifted(self):
        """FL-39d: direct test of m4a3beb_lifted (original 0x4a3beb)"""
        self.check('test_m4a3beb_lifted')

    def test_4a63dc_lifted(self):
        """FL-39d: direct test of m4a63dc_lifted (original 0x4a63dc)"""
        self.check('test_m4a63dc_lifted')

    def test_4a7994_lifted(self):
        """FL-39d: direct test of m4a7994_lifted (original 0x4a7994)"""
        self.check('test_m4a7994_lifted')

    def test_4a7c7a_lifted(self):
        """FL-39d: direct test of m4a7c7a_lifted (original 0x4a7c7a)"""
        self.check('test_m4a7c7a_lifted')

    def test_4a7d1d_lifted(self):
        """FL-39d: direct test of m4a7d1d_lifted (original 0x4a7d1d)"""
        self.check('test_m4a7d1d_lifted')

    def test_4a7df9_lifted(self):
        """FL-39d: direct test of m4a7df9_lifted (original 0x4a7df9)"""
        self.check('test_m4a7df9_lifted')

    def test_4a8007_lifted(self):
        """FL-39d: direct test of m4a8007_lifted (original 0x4a8007)"""
        self.check('test_m4a8007_lifted')

    def test_4a9f63_lifted(self):
        """FL-39d: direct test of m4a9f63_lifted (original 0x4a9f63)"""
        self.check('test_m4a9f63_lifted')

    def test_4ab706_lifted(self):
        """FL-39d: direct test of m4ab706_lifted (original 0x4ab706)"""
        self.check('test_m4ab706_lifted')

    def test_4accab_lifted(self):
        """FL-39d: direct test of m4accab_lifted (original 0x4accab)"""
        self.check('test_m4accab_lifted')

    def test_4ad1e5_lifted(self):
        """FL-39d: direct test of m4ad1e5_lifted (original 0x4ad1e5)"""
        self.check('test_m4ad1e5_lifted')

    def test_4b3c5a_lifted(self):
        """FL-39d: direct test of m4b3c5a_lifted (original 0x4b3c5a)"""
        self.check('test_m4b3c5a_lifted')

    def test_4b3f98_lifted(self):
        """FL-39d: direct test of m4b3f98_lifted (original 0x4b3f98)"""
        self.check('test_m4b3f98_lifted')

    def test_4b450f_lifted(self):
        """FL-39d: direct test of m4b450f_lifted (original 0x4b450f)"""
        self.check('test_m4b450f_lifted')

    def test_4b72a9_lifted(self):
        """FL-39d: direct test of m4b72a9_lifted (original 0x4b72a9)"""
        self.check('test_m4b72a9_lifted')

    def test_4b9e3b_lifted(self):
        """FL-39d: direct test of m4b9e3b_lifted (original 0x4b9e3b)"""
        self.check('test_m4b9e3b_lifted')

    def test_4ba07f_lifted(self):
        """FL-39d: direct test of m4ba07f_lifted (original 0x4ba07f)"""
        self.check('test_m4ba07f_lifted')

    def test_4ba262_lifted(self):
        """FL-39d: direct test of m4ba262_lifted (original 0x4ba262)"""
        self.check('test_m4ba262_lifted')

    def test_4ba486_lifted(self):
        """FL-39d: direct test of m4ba486_lifted (original 0x4ba486)"""
        self.check('test_m4ba486_lifted')

    def test_4be2c6_lifted(self):
        """FL-39d: direct test of m4be2c6_lifted (original 0x4be2c6)"""
        self.check('test_m4be2c6_lifted')

    def test_4bed70_lifted(self):
        """FL-39d: direct test of m4bed70_lifted (original 0x4bed70)"""
        self.check('test_m4bed70_lifted')

    def test_4bf63b_lifted(self):
        """FL-39d: direct test of m4bf63b_lifted (original 0x4bf63b)"""
        self.check('test_m4bf63b_lifted')

    def test_4bf8a7_lifted(self):
        """FL-39d: direct test of m4bf8a7_lifted (original 0x4bf8a7)"""
        self.check('test_m4bf8a7_lifted')

    def test_4c139a_lifted(self):
        """FL-39d: direct test of m4c139a_lifted (original 0x4c139a)"""
        self.check('test_m4c139a_lifted')

    def test_4c4b12_lifted(self):
        """FL-39d: direct test of m4c4b12_lifted (original 0x4c4b12)"""
        self.check('test_m4c4b12_lifted')

    def test_4c4c2b_lifted(self):
        """FL-39d: direct test of m4c4c2b_lifted (original 0x4c4c2b)"""
        self.check('test_m4c4c2b_lifted')

    def test_4c9428_lifted(self):
        """FL-39d: direct test of m4c9428_lifted (original 0x4c9428)"""
        self.check('test_m4c9428_lifted')

    def test_4c9b66_lifted(self):
        """FL-39d: direct test of m4c9b66_lifted (original 0x4c9b66)"""
        self.check('test_m4c9b66_lifted')

    def test_4c9c10_lifted(self):
        """FL-39d: direct test of m4c9c10_lifted (original 0x4c9c10)"""
        self.check('test_m4c9c10_lifted')

    def test_4ca92e_lifted(self):
        """FL-39d: direct test of m4ca92e_lifted (original 0x4ca92e)"""
        self.check('test_m4ca92e_lifted')

    def test_4caec0_lifted(self):
        """FL-39d: direct test of m4caec0_lifted (original 0x4caec0)"""
        self.check('test_m4caec0_lifted')

    def test_4caff5_lifted(self):
        """FL-39d: direct test of m4caff5_lifted (original 0x4caff5)"""
        self.check('test_m4caff5_lifted')

    def test_4cca0e_lifted(self):
        """FL-39d: direct test of m4cca0e_lifted (original 0x4cca0e)"""
        self.check('test_m4cca0e_lifted')

    def test_4ccc50_lifted(self):
        """FL-39d: direct test of m4ccc50_lifted (original 0x4ccc50)"""
        self.check('test_m4ccc50_lifted')

    def test_4cd645_lifted(self):
        """FL-39d: direct test of m4cd645_lifted (original 0x4cd645)"""
        self.check('test_m4cd645_lifted')

    def test_4d00d2_lifted(self):
        """FL-39d: direct test of m4d00d2_lifted (original 0x4d00d2)"""
        self.check('test_m4d00d2_lifted')

    def test_4d3723_lifted(self):
        """FL-39d: direct test of m4d3723_lifted (original 0x4d3723)"""
        self.check('test_m4d3723_lifted')

    def test_4d3b95_lifted(self):
        """FL-39d: direct test of m4d3b95_lifted (original 0x4d3b95)"""
        self.check('test_m4d3b95_lifted')

    def test_4d3c9a_lifted(self):
        """FL-39d: direct test of m4d3c9a_lifted (original 0x4d3c9a)"""
        self.check('test_m4d3c9a_lifted')

    def test_4d3cba_lifted(self):
        """FL-39d: direct test of m4d3cba_lifted (original 0x4d3cba)"""
        self.check('test_m4d3cba_lifted')

    def test_4d3ced_lifted(self):
        """FL-39d: direct test of m4d3ced_lifted (original 0x4d3ced)"""
        self.check('test_m4d3ced_lifted')

    def test_4d4043_lifted(self):
        """FL-39d: direct test of m4d4043_lifted (original 0x4d4043)"""
        self.check('test_m4d4043_lifted')

    def test_4d4645_lifted(self):
        """FL-39d: direct test of m4d4645_lifted (original 0x4d4645)"""
        self.check('test_m4d4645_lifted')

    def test_4d47b0_lifted(self):
        """FL-39d: direct test of m4d47b0_lifted (original 0x4d47b0)"""
        self.check('test_m4d47b0_lifted')

    def test_4d56e2_lifted(self):
        """FL-39d: direct test of m4d56e2_lifted (original 0x4d56e2)"""
        self.check('test_m4d56e2_lifted')

    def test_4d57e8_lifted(self):
        """FL-39d: direct test of m4d57e8_lifted (original 0x4d57e8)"""
        self.check('test_m4d57e8_lifted')

    def test_4d5834_lifted(self):
        """FL-39d: direct test of m4d5834_lifted (original 0x4d5834)"""
        self.check('test_m4d5834_lifted')

    def test_4d6787_lifted(self):
        """FL-39d: direct test of m4d6787_lifted (original 0x4d6787)"""
        self.check('test_m4d6787_lifted')

    def test_4d794d_lifted(self):
        """FL-39d: direct test of m4d794d_lifted (original 0x4d794d)"""
        self.check('test_m4d794d_lifted')

    def test_4d79c7_lifted(self):
        """FL-39d: direct test of m4d79c7_lifted (original 0x4d79c7)"""
        self.check('test_m4d79c7_lifted')

    def test_4d8f8d_lifted(self):
        """FL-39d: direct test of m4d8f8d_lifted (original 0x4d8f8d)"""
        self.check('test_m4d8f8d_lifted')

    def test_4d912a_lifted(self):
        """FL-39d: direct test of m4d912a_lifted (original 0x4d912a)"""
        self.check('test_m4d912a_lifted')

    def test_4d920c_lifted(self):
        """FL-39d: direct test of m4d920c_lifted (original 0x4d920c)"""
        self.check('test_m4d920c_lifted')

    def test_4d9d70_lifted(self):
        """FL-39d: direct test of m4d9d70_lifted (original 0x4d9d70)"""
        self.check('test_m4d9d70_lifted')

    def test_4db066_lifted(self):
        """FL-39d: direct test of m4db066_lifted (original 0x4db066)"""
        self.check('test_m4db066_lifted')

    def test_4db780_lifted(self):
        """FL-39d: direct test of m4db780_lifted (original 0x4db780)"""
        self.check('test_m4db780_lifted')

    def test_4db817_lifted(self):
        """FL-39d: direct test of m4db817_lifted (original 0x4db817)"""
        self.check('test_m4db817_lifted')

    def test_4dbc77_lifted(self):
        """FL-39d: direct test of m4dbc77_lifted (original 0x4dbc77)"""
        self.check('test_m4dbc77_lifted')

    def test_4dbfbf_lifted(self):
        """FL-39d: direct test of m4dbfbf_lifted (original 0x4dbfbf)"""
        self.check('test_m4dbfbf_lifted')

    def test_4dd28d_lifted(self):
        """FL-39d: direct test of m4dd28d_lifted (original 0x4dd28d)"""
        self.check('test_m4dd28d_lifted')

    def test_4dd409_lifted(self):
        """FL-39d: direct test of m4dd409_lifted (original 0x4dd409)"""
        self.check('test_m4dd409_lifted')

    def test_4de009_lifted(self):
        """FL-39d: direct test of m4de009_lifted (original 0x4de009)"""
        self.check('test_m4de009_lifted')

    def test_4de0cf_lifted(self):
        """FL-39d: direct test of m4de0cf_lifted (original 0x4de0cf)"""
        self.check('test_m4de0cf_lifted')

    def test_4de4f9_lifted(self):
        """FL-39d: direct test of m4de4f9_lifted (original 0x4de4f9)"""
        self.check('test_m4de4f9_lifted')

    def test_4de6d7_lifted(self):
        """FL-39d: direct test of m4de6d7_lifted (original 0x4de6d7)"""
        self.check('test_m4de6d7_lifted')

    def test_4de6fc_lifted(self):
        """FL-39d: direct test of m4de6fc_lifted (original 0x4de6fc)"""
        self.check('test_m4de6fc_lifted')

    def test_4e01b3_lifted(self):
        """FL-39d: direct test of m4e01b3_lifted (original 0x4e01b3)"""
        self.check('test_m4e01b3_lifted')

    def test_4e023b_lifted(self):
        """FL-39d: direct test of m4e023b_lifted (original 0x4e023b)"""
        self.check('test_m4e023b_lifted')

    def test_4e0377_lifted(self):
        """FL-39d: direct test of m4e0377_lifted (original 0x4e0377)"""
        self.check('test_m4e0377_lifted')

    def test_4e0619_lifted(self):
        """FL-39d: direct test of m4e0619_lifted (original 0x4e0619)"""
        self.check('test_m4e0619_lifted')

    def test_4e06c0_lifted(self):
        """FL-39d: direct test of m4e06c0_lifted (original 0x4e06c0)"""
        self.check('test_m4e06c0_lifted')

    def test_4e119b_lifted(self):
        """FL-39d: direct test of m4e119b_lifted (original 0x4e119b)"""
        self.check('test_m4e119b_lifted')

    def test_4e1c9f_lifted(self):
        """FL-39d: direct test of m4e1c9f_lifted (original 0x4e1c9f)"""
        self.check('test_m4e1c9f_lifted')

    def test_4e2913_lifted(self):
        """FL-39d: direct test of m4e2913_lifted (original 0x4e2913)"""
        self.check('test_m4e2913_lifted')

    def test_4e29b7_lifted(self):
        """FL-39d: direct test of m4e29b7_lifted (original 0x4e29b7)"""
        self.check('test_m4e29b7_lifted')

    def test_4e2dd3_lifted(self):
        """FL-39d: direct test of m4e2dd3_lifted (original 0x4e2dd3)"""
        self.check('test_m4e2dd3_lifted')

    def test_4e35e8_lifted(self):
        """FL-39d: direct test of m4e35e8_lifted (original 0x4e35e8)"""
        self.check('test_m4e35e8_lifted')

    def test_4e364a_lifted(self):
        """FL-39d: direct test of m4e364a_lifted (original 0x4e364a)"""
        self.check('test_m4e364a_lifted')

    def test_4e3691_lifted(self):
        """FL-39d: direct test of m4e3691_lifted (original 0x4e3691)"""
        self.check('test_m4e3691_lifted')

    def test_4e36fc_lifted(self):
        """FL-39d: direct test of m4e36fc_lifted (original 0x4e36fc)"""
        self.check('test_m4e36fc_lifted')

    def test_4e3772_lifted(self):
        """FL-39d: direct test of m4e3772_lifted (original 0x4e3772)"""
        self.check('test_m4e3772_lifted')

    def test_4e3a64_lifted(self):
        """FL-39d: direct test of m4e3a64_lifted (original 0x4e3a64)"""
        self.check('test_m4e3a64_lifted')

    def test_4e40a6_lifted(self):
        """FL-39d: direct test of m4e40a6_lifted (original 0x4e40a6)"""
        self.check('test_m4e40a6_lifted')

    def test_4e49e2_lifted(self):
        """FL-39d: direct test of m4e49e2_lifted (original 0x4e49e2)"""
        self.check('test_m4e49e2_lifted')

    def test_4e7970_lifted(self):
        """FL-39d: direct test of m4e7970_lifted (original 0x4e7970)"""
        self.check('test_m4e7970_lifted')

    def test_4e79ca_lifted(self):
        """FL-39d: direct test of m4e79ca_lifted (original 0x4e79ca)"""
        self.check('test_m4e79ca_lifted')

    def test_4e7c72_lifted(self):
        """FL-39d: direct test of m4e7c72_lifted (original 0x4e7c72)"""
        self.check('test_m4e7c72_lifted')

    def test_4e7dad_lifted(self):
        """FL-39d: direct test of m4e7dad_lifted (original 0x4e7dad)"""
        self.check('test_m4e7dad_lifted')

    def test_4e8d72_lifted(self):
        """FL-39d: direct test of m4e8d72_lifted (original 0x4e8d72)"""
        self.check('test_m4e8d72_lifted')

    def test_4e94a9_lifted(self):
        """FL-39d: direct test of m4e94a9_lifted (original 0x4e94a9)"""
        self.check('test_m4e94a9_lifted')

    def test_4ea1cb_lifted(self):
        """FL-39d: direct test of m4ea1cb_lifted (original 0x4ea1cb)"""
        self.check('test_m4ea1cb_lifted')

    def test_4ea361_lifted(self):
        """FL-39d: direct test of m4ea361_lifted (original 0x4ea361)"""
        self.check('test_m4ea361_lifted')

    def test_4eb5f2_lifted(self):
        """FL-39d: direct test of m4eb5f2_lifted (original 0x4eb5f2)"""
        self.check('test_m4eb5f2_lifted')

    def test_4eb9c8_lifted(self):
        """FL-39d: direct test of m4eb9c8_lifted (original 0x4eb9c8)"""
        self.check('test_m4eb9c8_lifted')

    def test_4eda10_lifted(self):
        """FL-39d: direct test of m4eda10_lifted (original 0x4eda10)"""
        self.check('test_m4eda10_lifted')

    def test_4edae5_lifted(self):
        """FL-39d: direct test of m4edae5_lifted (original 0x4edae5)"""
        self.check('test_m4edae5_lifted')

    def test_4ee517_lifted(self):
        """FL-39d: direct test of m4ee517_lifted (original 0x4ee517)"""
        self.check('test_m4ee517_lifted')

    def test_4ee572_lifted(self):
        """FL-39d: direct test of m4ee572_lifted (original 0x4ee572)"""
        self.check('test_m4ee572_lifted')

    def test_4ee598_lifted(self):
        """FL-39d: direct test of m4ee598_lifted (original 0x4ee598)"""
        self.check('test_m4ee598_lifted')

    def test_4ee5f2_lifted(self):
        """FL-39d: direct test of m4ee5f2_lifted (original 0x4ee5f2)"""
        self.check('test_m4ee5f2_lifted')

    def test_4ee9bb_lifted(self):
        """FL-39d: direct test of m4ee9bb_lifted (original 0x4ee9bb)"""
        self.check('test_m4ee9bb_lifted')

    def test_4eead0_lifted(self):
        """FL-39d: direct test of m4eead0_lifted (original 0x4eead0)"""
        self.check('test_m4eead0_lifted')

    def test_4ef3ed_lifted(self):
        """FL-39d: direct test of m4ef3ed_lifted (original 0x4ef3ed)"""
        self.check('test_m4ef3ed_lifted')

    def test_4ef4f0_lifted(self):
        """FL-39d: direct test of m4ef4f0_lifted (original 0x4ef4f0)"""
        self.check('test_m4ef4f0_lifted')

    def test_4f67be_lifted(self):
        """FL-39d: direct test of m4f67be_lifted (original 0x4f67be)"""
        self.check('test_m4f67be_lifted')

    def test_4f6810_lifted(self):
        """FL-39d: direct test of m4f6810_lifted (original 0x4f6810)"""
        self.check('test_m4f6810_lifted')

    def test_4f8a17_lifted(self):
        """FL-39d: direct test of m4f8a17_lifted (original 0x4f8a17)"""
        self.check('test_m4f8a17_lifted')

    def test_4fafc7_lifted(self):
        """FL-39d: direct test of m4fafc7_lifted (original 0x4fafc7)"""
        self.check('test_m4fafc7_lifted')

    def test_4fb018_lifted(self):
        """FL-39d: direct test of m4fb018_lifted (original 0x4fb018)"""
        self.check('test_m4fb018_lifted')

    def test_4fb071_lifted(self):
        """FL-39d: direct test of m4fb071_lifted (original 0x4fb071)"""
        self.check('test_m4fb071_lifted')

    def test_4fb086_lifted(self):
        """FL-39d: direct test of m4fb086_lifted (original 0x4fb086)"""
        self.check('test_m4fb086_lifted')

    def test_4fb1c6_lifted(self):
        """FL-39d: direct test of m4fb1c6_lifted (original 0x4fb1c6)"""
        self.check('test_m4fb1c6_lifted')

    def test_4fb737_lifted(self):
        """FL-39d: direct test of m4fb737_lifted (original 0x4fb737)"""
        self.check('test_m4fb737_lifted')

    def test_4fba86_lifted(self):
        """FL-39d: direct test of m4fba86_lifted (original 0x4fba86)"""
        self.check('test_m4fba86_lifted')

    def test_4fbd7e_lifted(self):
        """FL-39d: direct test of m4fbd7e_lifted (original 0x4fbd7e)"""
        self.check('test_m4fbd7e_lifted')

    def test_4fce90_lifted(self):
        """FL-39d: direct test of m4fce90_lifted (original 0x4fce90)"""
        self.check('test_m4fce90_lifted')
