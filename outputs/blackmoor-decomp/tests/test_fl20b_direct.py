"""FL-20 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl20b.c.

tests/fl20b_direct_test.c links src/original_methods_fl20b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl20b_direct_test.c'
KERNELS = ['original_methods_fl20b.c']
EXPECTED = [
    'test_m446688_draw_digits',
    'test_m48d5f4_confirm_pick',
    'test_m48cc70_draw_slots',
    # EXPECTED-END
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


class Fl20bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl20b_direct_test'
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

    def test_draw_digits_446688(self):
        """FL-20b: direct test of m446688_draw_digits (original 0x446688)"""
        self.check('test_m446688_draw_digits')

    def test_confirm_pick_48d5f4(self):
        """FL-20b: direct test of m48d5f4_confirm_pick (original 0x48d5f4)"""
        self.check('test_m48d5f4_confirm_pick')

    def test_draw_slots_48cc70(self):
        """FL-20b: direct test of m48cc70_draw_slots (original 0x48cc70)"""
        self.check('test_m48cc70_draw_slots')

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
