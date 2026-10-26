"""NATIVE-14: actual app random-movie media with muted offline audio.

Build fresh normal production modules. This is an S4408 component using
real BOOT/new-game resources, not a complete story-route claim. No oracle,
window, output device, injected story/inventory flags or row phases.
"""
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


class NativeRandomMovieTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('Actual native app integration requires macOS')
        source = WORK / 'analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Owner-local game descriptor unavailable')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Owner-local game installation unavailable')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-random-movie-app-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_RANDOM_MOVIE_APP_SOURCE')
        native_project = Path(app_source).resolve().parent.parent if app_source else PROJECT
        inventory = re.search(r'^for module in (.+); do$',
                              (native_project / 'scripts/build_native_app.sh').read_text(), re.MULTILINE)
        if inventory is None:
            raise RuntimeError('Production native module inventory unavailable')
        prefix = Path(os.environ.get('FFMPEG_PREFIX', '/opt/homebrew'))
        objects = []
        for module in shlex.split(inventory.group(1)):
            output = build / (module + '.o')
            cls.compile(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
                         '-mmacosx-version-min=27.0', '-std=c11', '-O2',
                         '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                         '-I' + str(prefix / 'include'), '-c',
                         str(native_project / 'src' / (module + '.c')), '-o', str(output)])
            objects.append(str(output))
        cls.executable = build / 'native-random-movie-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_random_movie_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_RANDOM_MOVIE_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)
        source_path = Path(app_source).resolve() if app_source else native_project / 'src/blackmoor_app.mm'
        print('RANDOM_MOVIE_BUILD executable_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest() +
              ' app_sha256=' + hashlib.sha256(source_path.read_bytes()).hexdigest())

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('Random-movie app fixture compilation failed:\n' + result.stderr)

    def component(self, mode):
        result = subprocess.run([str(self.executable), '--random-movie-component', str(self.game), mode],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_actual_s4408_starts_and_decodes_native_random_movie(self):
        self.component('start')

    def test_weighted_delay_holds_final_pixels_then_repicks_without_replay(self):
        self.component('hold')

    def test_controlled_selector_hides_and_restores_retained_movie_surface(self):
        self.component('selector')

    def test_actual_bottom_pointer_stops_retires_releases_and_allows_reentry(self):
        self.component('stop')

    def test_all_three_sets_and_49_assets_match_silent_bink_contract(self):
        self.component('corpus')

    def test_valid_avf_audio_and_bad_bounds_refuse_before_effects_with_probe_priority(self):
        self.component('preflight')

    def test_active_popup_transition_refuses_before_any_clear_and_preserves_source_scene(self):
        self.component('active-transition')


if __name__ == '__main__':
    unittest.main()
