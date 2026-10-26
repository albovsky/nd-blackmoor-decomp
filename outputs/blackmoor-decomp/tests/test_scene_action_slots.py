"""Pure NO_ART_SCENE slot policy; normal C checks, no assets or host services."""
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class SceneActionSlotsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required for scene action slot checks')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-action-slots-')
        cls.addClassCleanup(cls.temp.cleanup)
        cls.executable = Path(cls.temp.name) / 'scene-action-slots-test'
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   '-O2', '-I' + str(PROJECT / 'src'),
                   str(PROJECT / 'src/scene_action_slots.c'),
                   str(PROJECT / 'tests/scene_action_slots_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            raise RuntimeError('Slot-policy compilation failed:\n' + result.stdout + result.stderr)
        print('SCENE_ACTION_SLOTS_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest())

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name],
                                capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS scene_action_slots ' + name)

    def test_current_runtime_retirement_matrix_and_overlay_condition(self):
        self.check_case('matrix')

    def test_source_owners_runtime36_and_occupied_type0_keep_their_slots(self):
        self.check_case('stable')

    def test_first_internal_hole_order_and_trailing_vacancy_trim(self):
        self.check_case('holes')

    def test_per_incoming_high_water_guard_precedes_hole_search(self):
        self.check_case('capacity')

    def test_empty_source_zero_incoming_and_complete_retirement(self):
        self.check_case('empty')

    def test_argument_and_limit_errors_clear_the_whole_output(self):
        self.check_case('arguments')


if __name__ == '__main__':
    unittest.main()
