"""Normal-art slot policy: synthetic metadata, strict normal C subprocesses."""
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class SceneNormalActionSlotsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-normal-action-slots-')
        cls.addClassCleanup(cls.temp.cleanup)
        cls.executable = Path(cls.temp.name) / 'normal-action-slots'
        core = Path(os.environ.get('BLACKMOOR_NORMAL_ACTION_SLOTS_CORE_PROJECT', PROJECT)).resolve()
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2',
                   '-I' + str(core / 'src'), str(core / 'src/scene_action_slots.c'),
                   str(PROJECT / 'tests/scene_normal_action_slots_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError('Normal slot-policy compilation failed:\n' + (result.stdout + result.stderr)[:4000])
        print('SCENE_NORMAL_ACTION_SLOTS_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest() + ' core=' + str(core))

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name], capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS scene_normal_action_slots ' + name)

    def test_normal_clear_retains_nonzero_d2_slot_and_maps_source_order(self):
        self.check_case('mapping')

    def test_interspersed_constructor_skips_and_999_resource_index_map(self):
        self.check_case('skips')

    def test_120_high_water_guard_runs_before_each_resource_even_a_skip(self):
        self.check_case('capacity')

    def test_zero_resources_trim_and_invalid_inputs_clear_all_output(self):
        self.check_case('empty')


if __name__ == '__main__':
    unittest.main()
