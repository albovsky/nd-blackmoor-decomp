"""FL-21 (batch a): direct C tests of the GAME.EXE functions in src/original_methods_fl21a.c.

tests/fl21a_direct_test.c links src/original_methods_fl21a.c and prints one PASS/FAIL line per case; every test below checks one of
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
TEST_C = PROJECT / 'tests/fl21a_direct_test.c'
KERNELS = ['original_methods_fl21a.c']
EXPECTED = [
    'test_m4cb586_visit',
    'test_m42caa8_clip_rect',
    'test_m462c39_pointer_move',
    'test_m484f42_pointer_move',
    'test_m48d914_step_scene',
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


class Fl21aDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl21a_direct_test'
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

    def test_visit_4cb586(self):
        """FL-21a: direct test of m4cb586_visit (original 0x4cb586)"""
        self.check('test_m4cb586_visit')

    def test_clip_rect_42caa8(self):
        """FL-21a: direct test of m42caa8_clip_rect (original 0x42caa8)"""
        self.check('test_m42caa8_clip_rect')

    def test_pointer_move_462c39(self):
        """FL-21a: direct test of m462c39_pointer_move (original 0x462c39)"""
        self.check('test_m462c39_pointer_move')

    def test_pointer_move_484f42(self):
        """FL-21a: direct test of m484f42_pointer_move (original 0x484f42)"""
        self.check('test_m484f42_pointer_move')

    def test_step_scene_48d914(self):
        """FL-21a: direct test of m48d914_step_scene (original 0x48d914)"""
        self.check('test_m48d914_step_scene')

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
