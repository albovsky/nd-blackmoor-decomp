"""FL-21 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl21b.c.

tests/fl21b_direct_test.c links src/original_methods_fl21b.c and prints one PASS/FAIL line per case; every test below checks one of
them. Expected values come from the original's disassembly, not from the native code.

Direct cases written so far: 0x4468fe and 0x47f421. The cases for 0x48569e, 0x44e035 and 0x44da08 are NOT written yet (see
tasks/fl21b-handoff.md); those three functions are covered by tests/test_fl21b_differential.py only.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/fl21b_direct_test.c'
KERNELS = ['original_methods_fl21b.c']
EXPECTED = [
    'test_m4468fe_draw_clock',
    'test_m47f421_pointer_hit',
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


class Fl21bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl21b_direct_test'
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

    def test_draw_clock_4468fe(self):
        """FL-21b: direct test of m4468fe_draw_clock (original 0x4468fe)"""
        self.check('test_m4468fe_draw_clock')

    def test_pointer_hit_47f421(self):
        """FL-21b: direct test of m47f421_pointer_hit (original 0x47f421)"""
        self.check('test_m47f421_pointer_hit')

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
