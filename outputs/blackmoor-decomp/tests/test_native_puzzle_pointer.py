"""NATIVE-02: offline regression through the actual native app input callbacks.

The complete owner-local S4376/S4377 resources are read in place and hash checked. All
objects and executables are built in a temporary directory; no bundles, source
pins, coverage/ledger outputs or shared build directories are written.
"""
from __future__ import annotations

import hashlib
import json
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
RESOURCES = {
    4376: (2622, '3a1237be948adf4f9e4212ff9cb4ffda65e5ab366bf62675dfe6c1f075312599'),
    4377: (2623, '95d22215c6770efea94247cfaf1b6c34b79ec1187f05b871d735394db1c2aab6'),
}


class NativePuzzlePointerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('The actual native app glue requires macOS')
        cls.scenes = {}
        for scene_id, (resource, digest) in RESOURCES.items():
            scene = WORK / f'analysis/hiff-resources/{resource:04d}.bin'
            if not scene.is_file():
                raise unittest.SkipTest(f'Owner-local S{scene_id} resource unavailable')
            if hashlib.sha256(scene.read_bytes()).hexdigest() != digest:
                raise RuntimeError(f'Owner-local S{scene_id} resource does not match the pinned corpus')
            cls.scenes[scene_id] = scene
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
        scene_id = 4377 if kind == 'scene4377' else 4376
        args = [str(self.executable), str(self.scenes[scene_id]), kind]
        if kind == 'audio':
            source = WORK / 'analysis/game-source.json'
            if not source.is_file():
                self.skipTest('Owner-local game source descriptor unavailable')
            args.append(json.loads(source.read_text())['game_dir'])
        result = subprocess.run(args,
                                capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())

    def test_real_d1_tile_hover_and_primary_release_turn_the_tile(self):
        self.run_fixture('real')

    def test_d1_miss_preserves_guarded_generic_fallthrough(self):
        self.run_fixture('miss')

    def test_real_audio_busy_gates_then_unblocks_the_pointer_release(self):
        self.run_fixture('audio')

    def test_unimplemented_earlier_receiver_keeps_an_explicit_priority_limit(self):
        self.run_fixture('unknown')

    def test_real_exit_release_dispatches_phase2_and_completes_the_puzzle(self):
        self.run_fixture('exit')

    def test_same_tick_move_off_tile_releases_the_retained_previous_hover(self):
        self.run_fixture('stale')

    def test_s4377_with_real_builtin61_handles_hover_miss_and_release(self):
        self.run_fixture('scene4377')

    def test_each_nonzero_original_guard_blocks_d1_hover_and_release(self):
        self.run_fixture('guard')

    def test_corrupted_active_row_reports_explicit_host_scan_error(self):
        self.run_fixture('invalid-row')


if __name__ == '__main__':
    unittest.main()
