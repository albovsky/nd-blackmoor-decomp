"""Four silent integration checks of the actual guest-thread host, without GAME.EXE."""
import hashlib
import os
from pathlib import Path
import shlex
import subprocess
import sys
import unittest


PROJECT = Path(__file__).resolve().parents[1]
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', PROJECT.parents[1] / 'work'))


class RecompThreadTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build = WORK / 'recomp-threads-tests'
        build.mkdir(parents=True, exist_ok=True)
        cls.executable = build / 'recomp-threads-fixture'
        compiler = shlex.split(os.environ.get('CC', 'xcrun clang' if sys.platform == 'darwin' else 'cc'))
        modules = ['rc_core', 'rc_win32', 'rc_threads', 'rc_ddraw', 'rc_dsound', 'rc_bink']
        command = compiler + ['-std=gnu11', '-O1', '-g', '-Wall', '-Wextra',
                              '-Wno-unused-parameter', '-I' + str(PROJECT / 'src'),
                              '-I' + str(PROJECT / 'recomp'),
                              str(PROJECT / 'tests/recomp_threads_fixture.c')]
        command += [str(PROJECT / 'recomp' / (module + '.c')) for module in modules]
        command += ['-pthread', '-lm', '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=60)
        if result.returncode:
            raise AssertionError('Guest-thread fixture build failed:\n' + result.stdout + result.stderr)
        print('RECOMP_THREADS native_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest())

    def run_fixture(self, scenario):
        result = subprocess.run([str(self.executable), scenario], capture_output=True,
                                text=True, timeout=15)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'RECOMP_THREADS ' + scenario + ' ok')

    def test_suspended_startup_ready_release_and_suspend_counts(self):
        self.run_fixture('startup')

    def test_guest_stack_tls_tib_seh_and_x87_are_isolated(self):
        self.run_fixture('isolation')

    def test_recursive_critical_section_releases_only_after_outer_leave(self):
        self.run_fixture('critical-section')

    def test_completion_exit_thread_and_close_running_handle(self):
        self.run_fixture('completion')


if __name__ == '__main__':
    unittest.main()
