"""Finite device-free checks for the shared INPUT driver; no guest executes."""
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import sys
import unittest

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
MODULE = PROJECT / 'recomp'
HEADERS = PROJECT / 'src'


class InputScriptTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        retained = os.environ.get('BLACKMOOR_INPUT_SCRIPT_TEST_OUT')
        if retained:
            cls.build = Path(retained)
            cls.build.mkdir(parents=True, exist_ok=False)
        else:
            cls.temporary = tempfile.TemporaryDirectory(prefix='blackmoor-scripted-input-')
            cls.addClassCleanup(cls.temporary.cleanup)
            cls.build = Path(cls.temporary.name)
        cls.executable = cls.build / 'input-script-fixture'
        compiler = shlex.split(os.environ.get('CC', 'xcrun clang' if sys.platform == 'darwin' else 'cc'))
        command = compiler + ['-std=gnu11', '-O2', '-Wall', '-Wextra', '-Werror',
                              '-I' + str(MODULE), '-I' + str(HEADERS),
                              str(HERE / 'recomp_input_script_fixture.c'),
                              str(MODULE / 'rc_input_script.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        (cls.build / 'build.log').write_text(result.stdout + result.stderr)
        if result.returncode:
            raise AssertionError('fixture build failed:\n' + result.stdout + result.stderr)
        files = cls.build / 'files'
        files.mkdir(exist_ok=True)
        (files / 'valid.input').write_bytes(b' \n100:move:-3,0x20\n')
        (files / 'empty.input').write_bytes(b'')
        (files / 'nul.input').write_bytes(b'100:move:1,2\x00;200:key:65\n')
        (files / 'oversize.input').write_bytes(b' ' * 65537)
        inputs = [HERE / 'recomp_input_script_fixture.c', Path(__file__),
                  MODULE / 'rc_input_script.c', MODULE / 'rc_input_script.h']
        receipt = {'command': command, 'build_exit_code': result.returncode,
                   'sha256': {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs},
                   'native_sha256': hashlib.sha256(cls.executable.read_bytes()).hexdigest(),
                   'max_polls_per_scenario': 128, 'process_timeout_seconds': 2,
                   'game_executed': False, 'worker_threads': 0}
        (cls.build / 'build.json').write_text(json.dumps(receipt, indent=2) + '\n')
        print('INPUT_SCRIPT native_sha256=' + receipt['native_sha256'])

    def run_fixture(self, scenario):
        args = [str(self.executable), scenario]
        if scenario == 'files':
            args.append(str(self.build / 'files'))
        result = subprocess.run(args, capture_output=True, text=True, timeout=2)
        (self.build / (scenario + '.log')).write_text(result.stdout + result.stderr)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertRegex(result.stdout.strip(), '^INPUT_SCRIPT ' + scenario + r' ok polls=\d+$')
        print(result.stdout.strip())

    def test_mixed_trace_late_anchor_spacing_and_default_tail(self):
        self.run_fixture('mixed')

    def test_completion_requires_delivery_success_and_script_tail_stop(self):
        self.run_fixture('completion')

    def test_parser_bounds_and_atomic_refusal(self):
        self.run_fixture('parser')

    def test_file_parser_newline_empty_nul_and_size(self):
        self.run_fixture('files')


if __name__ == '__main__':
    unittest.main()
