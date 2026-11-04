"""Guest file replacement: a failed, short or interrupted overwrite keeps the previous file; synthetic files only, no game/GUI/audio."""
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent


class SaveFileTests(unittest.TestCase):
    def test_overwrite_is_all_or_nothing(self):
        with tempfile.TemporaryDirectory(prefix='blackmoor-save-test-') as temporary:
            binary = Path(temporary) / 'save-fixture'
            compiler = shlex.split(os.environ.get('CC', 'clang' if sys.platform == 'darwin' else 'cc'))
            dead_strip = '-Wl,-dead_strip' if sys.platform == 'darwin' else '-Wl,--gc-sections'
            command = compiler + ['-std=gnu11', '-O1', '-Wall', '-Wextra', '-Wno-unused-parameter', '-ffunction-sections', '-fdata-sections',
                                  '-I' + str(PROJECT / 'src'), '-I' + str(PROJECT / 'recomp'), '-I' + str(HERE),
                                  str(HERE / 'recomp_save_fixture.c'), '-pthread', '-lm', dead_strip, '-o', str(binary)]
            build = subprocess.run(command, capture_output=True, text=True, timeout=60)
            self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
            run = subprocess.run([str(binary)], capture_output=True, text=True, timeout=30)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            self.assertIn('failures=0', run.stdout)
            print(run.stdout, end='')


if __name__ == '__main__':
    unittest.main()
