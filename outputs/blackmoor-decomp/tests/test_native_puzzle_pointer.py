"""NATIVE-02: offline regression through the actual native app input callbacks.

The complete owner-local S4376 resource is read in place and hash checked. All
objects and executables are built in a temporary directory; no bundles, source
pins, coverage/ledger outputs or shared build directories are written.
"""
from __future__ import annotations

import hashlib
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', PROJECT.parents[1] / 'work'))
RESOURCE_SHA256 = '3a1237be948adf4f9e4212ff9cb4ffda65e5ab366bf62675dfe6c1f075312599'


class NativePuzzlePointerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('The actual native app glue requires macOS')
        cls.scene = WORK / 'analysis/hiff-resources/2622.bin'
        if not cls.scene.is_file():
            raise unittest.SkipTest('Owner-local S4376 resource unavailable')
        if hashlib.sha256(cls.scene.read_bytes()).hexdigest() != RESOURCE_SHA256:
            raise RuntimeError('Owner-local S4376 resource does not match the pinned corpus')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-d1-pointer-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        # Use the production native module inventory, compiling fresh into our
        # own temporary directory rather than borrowing potentially stale .o's.
        script = (PROJECT / 'scripts/build_native_app.sh').read_text()
        inventory = re.search(r'^for module in (.+); do$', script, re.MULTILINE)
        if inventory is None:
            raise RuntimeError('Cannot locate production native module inventory')
        modules = shlex.split(inventory.group(1))
        prefix = Path(os.environ.get('FFMPEG_PREFIX', '/opt/homebrew'))
        objects = []
        for module in modules:
            output = build / (module + '.o')
            cls.compile(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
                         '-mmacosx-version-min=27.0', '-std=c11', '-O2',
                         '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                         '-I' + str(prefix / 'include'), '-c',
                         str(PROJECT / 'src' / (module + '.c')), '-o', str(output)])
            objects.append(str(output))
        cls.executable = build / 'native-d1-pointer'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_d1_pointer_glue_test.mm')]
        command += [str(PROJECT / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects
        command += ['-framework', 'AppKit', '-framework', 'Foundation',
                    '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                    '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                    '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                    '-o', str(cls.executable)]
        cls.compile(command)

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('Native pointer fixture compile failed:\n' + result.stderr)

    def run_fixture(self, kind):
        result = subprocess.run([str(self.executable), str(self.scene), kind],
                                capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_real_d1_tile_hover_and_primary_release_turn_the_tile(self):
        self.run_fixture('real')

    def test_d1_miss_preserves_guarded_generic_fallthrough(self):
        self.run_fixture('miss')

    def test_unimplemented_earlier_receiver_keeps_an_explicit_priority_limit(self):
        self.run_fixture('unknown')


if __name__ == '__main__':
    unittest.main()
