"""FL-37: direct C tests of the GAME.EXE functions in src/original_methods_fl37.c.

tests/fl37_direct_test.c links src/original_methods_fl37.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

One direct case per function (the 57 ported flag toggles); the Unicorn comparison against the original bytes is in
tests/test_fl37_differential.py.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl37_direct_test.c'
KERNELS = ['original_methods_fl37.c']
sys_path = str(Path(__file__).resolve().parent)
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, sys_path)
import fl37_fixtures as fx
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


class Fl37Direct(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl37_direct_test'
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

    def test_406b3f_toggle_5e353e(self):
        """FL-37: direct test of m406b3f_toggle_5e353e (original 0x406b3f)"""
        self.check('test_m406b3f_toggle_5e353e')

    def test_406b86_toggle_5e3542(self):
        """FL-37: direct test of m406b86_toggle_5e3542 (original 0x406b86)"""
        self.check('test_m406b86_toggle_5e3542')

    def test_406bcd_toggle_5e3546(self):
        """FL-37: direct test of m406bcd_toggle_5e3546 (original 0x406bcd)"""
        self.check('test_m406bcd_toggle_5e3546')

    def test_406c14_toggle_5e354a(self):
        """FL-37: direct test of m406c14_toggle_5e354a (original 0x406c14)"""
        self.check('test_m406c14_toggle_5e354a')

    def test_406c5b_toggle_5e354e(self):
        """FL-37: direct test of m406c5b_toggle_5e354e (original 0x406c5b)"""
        self.check('test_m406c5b_toggle_5e354e')

    def test_406ca2_toggle_5e3552(self):
        """FL-37: direct test of m406ca2_toggle_5e3552 (original 0x406ca2)"""
        self.check('test_m406ca2_toggle_5e3552')

    def test_406ce9_toggle_5e3556(self):
        """FL-37: direct test of m406ce9_toggle_5e3556 (original 0x406ce9)"""
        self.check('test_m406ce9_toggle_5e3556')

    def test_406d30_toggle_5e355a(self):
        """FL-37: direct test of m406d30_toggle_5e355a (original 0x406d30)"""
        self.check('test_m406d30_toggle_5e355a')

    def test_406d77_toggle_5e355e(self):
        """FL-37: direct test of m406d77_toggle_5e355e (original 0x406d77)"""
        self.check('test_m406d77_toggle_5e355e')

    def test_406dbe_toggle_5e3562(self):
        """FL-37: direct test of m406dbe_toggle_5e3562 (original 0x406dbe)"""
        self.check('test_m406dbe_toggle_5e3562')

    def test_406e05_toggle_5e3566(self):
        """FL-37: direct test of m406e05_toggle_5e3566 (original 0x406e05)"""
        self.check('test_m406e05_toggle_5e3566')

    def test_406e4c_toggle_5e356a(self):
        """FL-37: direct test of m406e4c_toggle_5e356a (original 0x406e4c)"""
        self.check('test_m406e4c_toggle_5e356a')

    def test_406e93_toggle_5e356e(self):
        """FL-37: direct test of m406e93_toggle_5e356e (original 0x406e93)"""
        self.check('test_m406e93_toggle_5e356e')

    def test_406eda_toggle_5e3572(self):
        """FL-37: direct test of m406eda_toggle_5e3572 (original 0x406eda)"""
        self.check('test_m406eda_toggle_5e3572')

    def test_406f21_toggle_5e3576(self):
        """FL-37: direct test of m406f21_toggle_5e3576 (original 0x406f21)"""
        self.check('test_m406f21_toggle_5e3576')

    def test_406f68_toggle_5e357a(self):
        """FL-37: direct test of m406f68_toggle_5e357a (original 0x406f68)"""
        self.check('test_m406f68_toggle_5e357a')

    def test_406faf_toggle_5e357e(self):
        """FL-37: direct test of m406faf_toggle_5e357e (original 0x406faf)"""
        self.check('test_m406faf_toggle_5e357e')

    def test_406ff6_toggle_5e3582(self):
        """FL-37: direct test of m406ff6_toggle_5e3582 (original 0x406ff6)"""
        self.check('test_m406ff6_toggle_5e3582')

    def test_40703d_toggle_5e3586(self):
        """FL-37: direct test of m40703d_toggle_5e3586 (original 0x40703d)"""
        self.check('test_m40703d_toggle_5e3586')

    def test_407084_toggle_5e358a(self):
        """FL-37: direct test of m407084_toggle_5e358a (original 0x407084)"""
        self.check('test_m407084_toggle_5e358a')

    def test_4070cb_toggle_5e358e(self):
        """FL-37: direct test of m4070cb_toggle_5e358e (original 0x4070cb)"""
        self.check('test_m4070cb_toggle_5e358e')

    def test_407112_toggle_5e3592(self):
        """FL-37: direct test of m407112_toggle_5e3592 (original 0x407112)"""
        self.check('test_m407112_toggle_5e3592')

    def test_407159_toggle_5e3596(self):
        """FL-37: direct test of m407159_toggle_5e3596 (original 0x407159)"""
        self.check('test_m407159_toggle_5e3596')

    def test_4071a0_toggle_5e359a(self):
        """FL-37: direct test of m4071a0_toggle_5e359a (original 0x4071a0)"""
        self.check('test_m4071a0_toggle_5e359a')

    def test_4071e7_toggle_5e359e(self):
        """FL-37: direct test of m4071e7_toggle_5e359e (original 0x4071e7)"""
        self.check('test_m4071e7_toggle_5e359e')

    def test_40722e_toggle_5e35a2(self):
        """FL-37: direct test of m40722e_toggle_5e35a2 (original 0x40722e)"""
        self.check('test_m40722e_toggle_5e35a2')

    def test_407275_toggle_5e35a6(self):
        """FL-37: direct test of m407275_toggle_5e35a6 (original 0x407275)"""
        self.check('test_m407275_toggle_5e35a6')

    def test_4072bc_toggle_5e35aa(self):
        """FL-37: direct test of m4072bc_toggle_5e35aa (original 0x4072bc)"""
        self.check('test_m4072bc_toggle_5e35aa')

    def test_407303_toggle_5e35ae(self):
        """FL-37: direct test of m407303_toggle_5e35ae (original 0x407303)"""
        self.check('test_m407303_toggle_5e35ae')

    def test_40734a_toggle_5e35b2(self):
        """FL-37: direct test of m40734a_toggle_5e35b2 (original 0x40734a)"""
        self.check('test_m40734a_toggle_5e35b2')

    def test_407391_toggle_5e35b6(self):
        """FL-37: direct test of m407391_toggle_5e35b6 (original 0x407391)"""
        self.check('test_m407391_toggle_5e35b6')

    def test_4073d8_toggle_5e35ba(self):
        """FL-37: direct test of m4073d8_toggle_5e35ba (original 0x4073d8)"""
        self.check('test_m4073d8_toggle_5e35ba')

    def test_40741f_toggle_5e35be(self):
        """FL-37: direct test of m40741f_toggle_5e35be (original 0x40741f)"""
        self.check('test_m40741f_toggle_5e35be')

    def test_407466_toggle_5e35c2(self):
        """FL-37: direct test of m407466_toggle_5e35c2 (original 0x407466)"""
        self.check('test_m407466_toggle_5e35c2')

    def test_4074ad_toggle_5e35c6(self):
        """FL-37: direct test of m4074ad_toggle_5e35c6 (original 0x4074ad)"""
        self.check('test_m4074ad_toggle_5e35c6')

    def test_4074f4_toggle_5e35ca(self):
        """FL-37: direct test of m4074f4_toggle_5e35ca (original 0x4074f4)"""
        self.check('test_m4074f4_toggle_5e35ca')

    def test_40753b_toggle_5e35ce(self):
        """FL-37: direct test of m40753b_toggle_5e35ce (original 0x40753b)"""
        self.check('test_m40753b_toggle_5e35ce')

    def test_407582_toggle_5e35d2(self):
        """FL-37: direct test of m407582_toggle_5e35d2 (original 0x407582)"""
        self.check('test_m407582_toggle_5e35d2')

    def test_4075c9_toggle_5e35d6(self):
        """FL-37: direct test of m4075c9_toggle_5e35d6 (original 0x4075c9)"""
        self.check('test_m4075c9_toggle_5e35d6')

    def test_407610_toggle_5e35da(self):
        """FL-37: direct test of m407610_toggle_5e35da (original 0x407610)"""
        self.check('test_m407610_toggle_5e35da')

    def test_407657_toggle_5e35de(self):
        """FL-37: direct test of m407657_toggle_5e35de (original 0x407657)"""
        self.check('test_m407657_toggle_5e35de')

    def test_40769e_toggle_5e35e2(self):
        """FL-37: direct test of m40769e_toggle_5e35e2 (original 0x40769e)"""
        self.check('test_m40769e_toggle_5e35e2')

    def test_4076e5_toggle_5e35e6(self):
        """FL-37: direct test of m4076e5_toggle_5e35e6 (original 0x4076e5)"""
        self.check('test_m4076e5_toggle_5e35e6')

    def test_40772c_toggle_5e35ea(self):
        """FL-37: direct test of m40772c_toggle_5e35ea (original 0x40772c)"""
        self.check('test_m40772c_toggle_5e35ea')

    def test_407773_toggle_5e35ee(self):
        """FL-37: direct test of m407773_toggle_5e35ee (original 0x407773)"""
        self.check('test_m407773_toggle_5e35ee')

    def test_4077ba_toggle_5e35f2(self):
        """FL-37: direct test of m4077ba_toggle_5e35f2 (original 0x4077ba)"""
        self.check('test_m4077ba_toggle_5e35f2')

    def test_407801_toggle_5e35f6(self):
        """FL-37: direct test of m407801_toggle_5e35f6 (original 0x407801)"""
        self.check('test_m407801_toggle_5e35f6')

    def test_407848_toggle_5e35fa(self):
        """FL-37: direct test of m407848_toggle_5e35fa (original 0x407848)"""
        self.check('test_m407848_toggle_5e35fa')

    def test_40788f_toggle_5e35fe(self):
        """FL-37: direct test of m40788f_toggle_5e35fe (original 0x40788f)"""
        self.check('test_m40788f_toggle_5e35fe')

    def test_4078d6_toggle_5e3602(self):
        """FL-37: direct test of m4078d6_toggle_5e3602 (original 0x4078d6)"""
        self.check('test_m4078d6_toggle_5e3602')

    def test_40791d_toggle_5e3606(self):
        """FL-37: direct test of m40791d_toggle_5e3606 (original 0x40791d)"""
        self.check('test_m40791d_toggle_5e3606')

    def test_407964_toggle_5e360a(self):
        """FL-37: direct test of m407964_toggle_5e360a (original 0x407964)"""
        self.check('test_m407964_toggle_5e360a')

    def test_4079ab_toggle_5e360e(self):
        """FL-37: direct test of m4079ab_toggle_5e360e (original 0x4079ab)"""
        self.check('test_m4079ab_toggle_5e360e')

    def test_4079f2_toggle_5e3612(self):
        """FL-37: direct test of m4079f2_toggle_5e3612 (original 0x4079f2)"""
        self.check('test_m4079f2_toggle_5e3612')

    def test_407a39_toggle_5e3616(self):
        """FL-37: direct test of m407a39_toggle_5e3616 (original 0x407a39)"""
        self.check('test_m407a39_toggle_5e3616')

    def test_407a80_toggle_5e361a(self):
        """FL-37: direct test of m407a80_toggle_5e361a (original 0x407a80)"""
        self.check('test_m407a80_toggle_5e361a')

    def test_407ac7_toggle_5e361e(self):
        """FL-37: direct test of m407ac7_toggle_5e361e (original 0x407ac7)"""
        self.check('test_m407ac7_toggle_5e361e')

    # CASES-END

    def test_sweep_bounded(self):
        """FL-37: bounded random sweep over every port (meant for the sanitiser builds; checks that it runs)"""
        self.check('test_sweep_bounded')


if __name__ == '__main__':
    unittest.main()
