"""FL-14 group y: direct C tests of 13 small functions of the raw 0xda, 0xd3, 0xe4, 0xeb, 0xea, 0xd8 and 0xaa kernels.

Each tests/fl14_y_<family>_direct_test.c includes its src/action_family_<family>_runtime.c as a translation unit (the families
share static helper names, so they cannot share one) and calls the static or public function against values derived from the
original GAME.EXE pseudocode: real_name 0x45be3f, bul_invalidate 0x45b477, cpz_invalidate 0x4618ab, cpz_grid_reset 0x4618df,
e4r_invalidate 0x4758e8, eb_invalidate 0x47e440, rect_valid 0x47e99e, near_unplaced 0x47ec06, ea_invalidate 0x4840d9,
rect_valid 0x484f0d, d8_mark_dirty 0x48bc38, d8_press 0x48c148 and alc_invalidate 0x44d19d. Each prints one PASS/FAIL line per
function; the wrapper runs every binary once and reports one unittest method per function.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
# family -> expected test names printed by tests/fl14_y_<family>_direct_test.c
FAMILIES = {
    'da': ['test_real_name_45be3f', 'test_bul_invalidate_45b477'],
    'd3': ['test_cpz_grid_reset_4618df', 'test_cpz_invalidate_4618ab'],
    'e4': ['test_e4r_invalidate_4758e8'],
    'eb': ['test_rect_valid_47e99e', 'test_near_unplaced_47ec06', 'test_eb_invalidate_47e440'],
    'ea': ['test_rect_valid_484f0d', 'test_ea_invalidate_4840d9'],
    'd8': ['test_d8_mark_dirty_48bc38', 'test_d8_press_48c148'],
    'aa': ['test_alc_invalidate_44d19d'],
}


def compiler():
    # The repo scripts call `xcrun --sdk macosx clang` on macOS; where xcrun is absent use clang, cc or gcc.
    if os.environ.get('CC'):
        return [os.environ['CC']]
    if shutil.which('xcrun'):
        return ['xcrun', '--sdk', 'macosx', 'clang']
    return [shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')]


class Fl14YDirect(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)
        cls.results = {}
        cls.returncodes = {}
        for family in FAMILIES:
            source = PROJECT / f'tests/fl14_y_{family}_direct_test.c'
            binary = Path(cls.directory.name) / f'fl14_y_{family}_direct_test'
            cmd = [*compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-g', str(source), '-lm',
                   '-o', str(binary)]
            built = subprocess.run(cmd, capture_output=True, text=True)
            if built.returncode != 0:
                raise AssertionError(built.stderr)
            done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60)
            cls.returncodes[family] = done.returncode
            for line in done.stdout.splitlines():
                status, _, rest = line.partition(' ')
                if status in ('PASS', 'FAIL'):
                    name, _, message = rest.partition(': ')
                    cls.results[(family, name)] = (status, message)

    def check(self, family, name):
        self.assertIn((family, name), self.results)
        self.assertEqual(self.results[(family, name)], ('PASS', ''), self.results[(family, name)])
        self.assertEqual(self.returncodes[family], 0)

    def test_real_name_45be3f(self):
        """FL-14: direct test of real_name (original 0x45be3f)"""
        self.check('da', 'test_real_name_45be3f')

    def test_bul_invalidate_45b477(self):
        """FL-14: direct test of bul_invalidate (original 0x45b477)"""
        self.check('da', 'test_bul_invalidate_45b477')

    def test_cpz_grid_reset_4618df(self):
        """FL-14: direct test of cpz_grid_reset (original 0x4618df)"""
        self.check('d3', 'test_cpz_grid_reset_4618df')

    def test_cpz_invalidate_4618ab(self):
        """FL-14: direct test of cpz_invalidate (original 0x4618ab)"""
        self.check('d3', 'test_cpz_invalidate_4618ab')

    def test_e4r_invalidate_4758e8(self):
        """FL-14: direct test of e4r_invalidate (original 0x4758e8)"""
        self.check('e4', 'test_e4r_invalidate_4758e8')

    def test_rect_valid_47e99e(self):
        """FL-14: direct test of rect_valid (original 0x47e99e)"""
        self.check('eb', 'test_rect_valid_47e99e')

    def test_near_unplaced_47ec06(self):
        """FL-14: direct test of near_unplaced (original 0x47ec06)"""
        self.check('eb', 'test_near_unplaced_47ec06')

    def test_eb_invalidate_47e440(self):
        """FL-14: direct test of eb_invalidate (original 0x47e440)"""
        self.check('eb', 'test_eb_invalidate_47e440')

    def test_rect_valid_484f0d(self):
        """FL-14: direct test of rect_valid (original 0x484f0d)"""
        self.check('ea', 'test_rect_valid_484f0d')

    def test_ea_invalidate_4840d9(self):
        """FL-14: direct test of ea_invalidate (original 0x4840d9)"""
        self.check('ea', 'test_ea_invalidate_4840d9')

    def test_d8_mark_dirty_48bc38(self):
        """FL-14: direct test of d8_mark_dirty (original 0x48bc38)"""
        self.check('d8', 'test_d8_mark_dirty_48bc38')

    def test_d8_press_48c148(self):
        """FL-14: direct test of d8_press (original 0x48c148)"""
        self.check('d8', 'test_d8_press_48c148')

    def test_alc_invalidate_44d19d(self):
        """FL-14: direct test of alc_invalidate (original 0x44d19d)"""
        self.check('aa', 'test_alc_invalidate_44d19d')

    def test_all_cases_reported(self):
        for family, names in FAMILIES.items():
            self.assertEqual(sorted(name for fam, name in self.results if fam == family), sorted(names))
            self.assertEqual(self.returncodes[family], 0)
        self.assertTrue(all(status == 'PASS' for status, _ in self.results.values()))


if __name__ == '__main__':
    unittest.main()
