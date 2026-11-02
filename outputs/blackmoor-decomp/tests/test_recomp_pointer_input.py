"""Finite pointer planner, script, and real-host async API checks; no game runs."""
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent


class PointerInputTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        retained = os.environ.get('BLACKMOOR_POINTER_TEST_OUT')
        if retained:
            cls.output = Path(retained)
            cls.output.mkdir(parents=True, exist_ok=False)
        else:
            cls.temporary = tempfile.TemporaryDirectory(prefix='blackmoor-pointer-')
            cls.addClassCleanup(cls.temporary.cleanup)
            cls.output = Path(cls.temporary.name)
        compiler = shlex.split(os.environ.get('CC', 'clang' if sys.platform == 'darwin' else 'cc'))
        common = compiler + ['-std=gnu11', '-Wall', '-Wextra', '-I' + str(PROJECT / 'src'),
                             '-I' + str(PROJECT / 'recomp'), '-I' + str(HERE)]
        cls.planner = cls.output / 'planner'
        cls.async_host = cls.output / 'async-host'
        dead_strip = '-Wl,-dead_strip' if sys.platform == 'darwin' else '-Wl,--gc-sections'
        commands = [common + ['-O2', '-Werror', str(HERE / 'recomp_pointer_fixture.c'),
                             str(PROJECT / 'recomp/rc_input_script.c'), '-o', str(cls.planner)],
                    common + ['-O1', '-Wno-unused-parameter', '-ffunction-sections', '-fdata-sections',
                              str(HERE / 'recomp_pointer_async_fixture.c'), '-pthread', '-lm', dead_strip,
                              '-o', str(cls.async_host)]]
        for i, command in enumerate(commands):
            result = subprocess.run(command, capture_output=True, text=True, timeout=30)
            (cls.output / ('build-' + str(i) + '.log')).write_text(result.stdout + result.stderr)
            if result.returncode:
                raise RuntimeError(result.stdout + result.stderr)
        paths = [Path(__file__), HERE / 'recomp_pointer_fixture.c', HERE / 'recomp_pointer_async_fixture.c',
                 HERE / 'recomp_input_script_fixture.c', PROJECT / 'recomp/rc_win32.c',
                 PROJECT / 'recomp/rc_pointer_input.h', PROJECT / 'recomp/rc_input_script.c']
        sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
        (cls.output / 'build.json').write_text(json.dumps({'commands': commands,
            'source_sha256': {str(p): sha(p) for p in paths},
            'native_sha256': {str(p): sha(p) for p in (cls.planner, cls.async_host)},
            'game_executed': False, 'gui_executed': False, 'worker_threads': 0}, indent=2) + '\n')
        print('POINTER_TEST private_output=' + str(cls.output))

    def run_case(self, executable, args, name, expected):
        result = subprocess.run([str(executable)] + args, capture_output=True, text=True, timeout=2)
        (self.output / (name + '.log')).write_text(result.stdout + result.stderr)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn(expected, result.stdout)

    def test_message_transitions_modifiers_and_signed_coordinates(self):
        self.run_case(self.planner, ['planner'], 'planner', 'planner ok plans=71 messages=122')

    def test_pointer_script_queues_right_edges_and_rejects_bad_masks(self):
        self.run_case(self.planner, ['script'], 'script', 'script ok pointer_calls=3 messages=4')

    def test_legacy_mixed_script_remains_unchanged(self):
        self.run_case(self.planner, ['legacy'], 'legacy', 'legacy ok')

    def test_actual_async_api_preserves_legacy_keys_and_timed_holds(self):
        self.run_case(self.async_host, [], 'async', 'RIGHT_POINTER_ASYNC checks=19 failures=0')


if __name__ == '__main__':
    unittest.main()
