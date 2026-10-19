"""FL-19 (batch b): direct C tests of the GAME.EXE functions in src/original_methods_fl19b.c.

tests/fl19b_direct_test.c links src/original_methods_fl19b.c and prints one PASS/FAIL line per case; every test below checks one of
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
TEST_C = PROJECT / 'tests/fl19b_direct_test.c'
KERNELS = ['original_methods_fl19b.c']
EXPECTED = [
    'test_m44d597_press',
    'test_m41f986_init_strings',
    'test_m4d00f4_draw_list',
    'test_m447ac7_split_pixels',
    'test_m45b872_click',
    'test_m434630_find_name',
    'test_m4c7481_pack_555',
    'test_m4d3836_text_width',
    'test_m4460d6_load_layout',
    'test_m48ded7_draw_hover',
    'test_m45b5bb_pointer_move',
    'test_m4462d3_load_layout',
    'test_m412787_register_name',
    'test_m4fca60_set_channel_scalars',
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


class Fl19bDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        binary = Path(cls.directory.name) / 'fl19b_direct_test'
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

    def test_press_44d597(self):
        """FL-19b: direct test of m44d597_press (original 0x44d597)"""
        self.check('test_m44d597_press')

    def test_init_strings_41f986(self):
        """FL-19b: direct test of m41f986_init_strings (original 0x41f986)"""
        self.check('test_m41f986_init_strings')

    def test_draw_list_4d00f4(self):
        """FL-19b: direct test of m4d00f4_draw_list (original 0x4d00f4)"""
        self.check('test_m4d00f4_draw_list')

    def test_split_pixels_447ac7(self):
        """FL-19b: direct test of m447ac7_split_pixels (original 0x447ac7)"""
        self.check('test_m447ac7_split_pixels')

    def test_click_45b872(self):
        """FL-19b: direct test of m45b872_click (original 0x45b872)"""
        self.check('test_m45b872_click')

    def test_find_name_434630(self):
        """FL-19b: direct test of m434630_find_name (original 0x434630)"""
        self.check('test_m434630_find_name')

    def test_pack_555_4c7481(self):
        """FL-19b: direct test of m4c7481_pack_555 (original 0x4c7481)"""
        self.check('test_m4c7481_pack_555')

    def test_text_width_4d3836(self):
        """FL-19b: direct test of m4d3836_text_width (original 0x4d3836)"""
        self.check('test_m4d3836_text_width')

    def test_load_layout_4460d6(self):
        """FL-19b: direct test of m4460d6_load_layout (original 0x4460d6)"""
        self.check('test_m4460d6_load_layout')

    def test_draw_hover_48ded7(self):
        """FL-19b: direct test of m48ded7_draw_hover (original 0x48ded7)"""
        self.check('test_m48ded7_draw_hover')

    def test_pointer_move_45b5bb(self):
        """FL-19b: direct test of m45b5bb_pointer_move (original 0x45b5bb)"""
        self.check('test_m45b5bb_pointer_move')

    def test_load_layout_4462d3(self):
        """FL-19b: direct test of m4462d3_load_layout (original 0x4462d3)"""
        self.check('test_m4462d3_load_layout')

    def test_register_name_412787(self):
        """FL-19b: direct test of m412787_register_name (original 0x412787)"""
        self.check('test_m412787_register_name')

    def test_set_channel_scalars_4fca60(self):
        """FL-19b: direct test of m4fca60_set_channel_scalars (original 0x4fca60)"""
        self.check('test_m4fca60_set_channel_scalars')

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
