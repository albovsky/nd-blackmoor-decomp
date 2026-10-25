"""Normal app-receiver regression; no device, assets, faults or sanitizer runs."""
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class NativeDisplayAppTests(unittest.TestCase):
    def test_outside_press_cannot_reuse_taskbar_hover_but_owned_release_clears(self):
        if sys.platform != 'darwin':
            self.skipTest('Native app receiver requires macOS')
        # Refresh production objects first: no stale-object dependency.
        built = subprocess.run(['bash', str(PROJECT / 'scripts/build_native_app.sh')],
                               capture_output=True, text=True, timeout=180)
        self.assertEqual(built.returncode, 0, built.stderr)
        inventory = re.search(r'^for module in (.+); do$',
                              (PROJECT / 'scripts/build_native_app.sh').read_text(), re.MULTILINE)
        self.assertIsNotNone(inventory)
        prefix = Path(os.environ.get('FFMPEG_PREFIX', '/opt/homebrew'))
        with tempfile.TemporaryDirectory(prefix='native-display-app-') as temporary:
            executable = Path(temporary) / 'display-glue'
            command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                       '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                       '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                       str(PROJECT / 'tests/native_display_app_glue_test.mm')]
            command += [str(PROJECT / 'src' / (module + '.mm')) for module in
                        ('macos_platform', 'macos_audio', 'scene_inspector')]
            command += [str(PROJECT / 'build/native-app' / (module + '.o'))
                        for module in shlex.split(inventory.group(1))]
            command += ['-framework', 'AppKit', '-framework', 'Foundation',
                        '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                        '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                        '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                        '-o', str(executable)]
            compiled = subprocess.run(command, capture_output=True, text=True, timeout=180)
            self.assertEqual(compiled.returncode, 0, compiled.stderr)
            result = subprocess.run([str(executable)], capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('outside_cases=6 release_ownership=6 passed=1', result.stdout)
