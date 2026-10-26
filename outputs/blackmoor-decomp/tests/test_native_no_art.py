"""NATIVE-15: actual app no-art room retention with muted offline audio.

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


class NativeNoArtTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-no-art-app-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_NO_ART_APP_SOURCE')
        native_project = Path(app_source).resolve().parent.parent if app_source else PROJECT
        inventory = re.search(r'^for module in (.+); do$',
                              (native_project / 'scripts/build_native_app.sh').read_text(), re.MULTILINE)
        if inventory is None:
            raise RuntimeError('Production native module inventory unavailable')
        prefix = Path(os.environ.get('FFMPEG_PREFIX', '/opt/homebrew'))
        font_override = os.environ.get('BLACKMOOR_NATIVE_NO_ART_FONT_SOURCE')
        font_source = Path(font_override).resolve() if font_override else native_project / 'src/native_conversation_caption.c'
        if not font_source.is_file():
            raise RuntimeError('Conversation font module source unavailable')
        objects = []
        for module in shlex.split(inventory.group(1)):
            output = build / (module + '.o')
            module_source = font_source if module == 'native_conversation_caption' else native_project / 'src' / (module + '.c')
            cls.compile(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
                         '-mmacosx-version-min=27.0', '-std=c11', '-O2',
                         '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                         '-I' + str(prefix / 'include'), '-c',
                         str(module_source), '-o', str(output)])
            objects.append(str(output))
        cls.executable = build / 'native-no-art-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_no_art_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_NO_ART_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)
        source_path = Path(app_source).resolve() if app_source else native_project / 'src/blackmoor_app.mm'
        print('NO_ART_BUILD executable_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest() +
              ' app_sha256=' + hashlib.sha256(source_path.read_bytes()).hexdigest() +
              ' caption_sha256=' + hashlib.sha256(font_source.read_bytes()).hexdigest() +
              ' font_override=' + str(bool(font_override)))

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('No-art app fixture compilation failed:\n' + result.stderr)

    def component(self, mode):
        result = subprocess.run([str(self.executable), '--no-art-component', str(self.game), mode],
                                capture_output=True, text=True, timeout=120)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_actual_pointer_loads_no_art_scene_and_retains_live_movie(self):
        self.component('first')

    def test_natural_greeting_retires_conversations_and_reuses_first_hole(self):
        self.component('cleanup')

    def test_actual_response_voice_reaches_next_no_art_scene(self):
        self.component('response')

    def test_normal_art_return_preserves_movie_and_skips_incoming_constructor(self):
        self.component('normal-art-return')

    def test_busy_greeting_refuses_no_art_retirement_before_commit(self):
        self.component('busy-refusal')

    def test_host_stop_after_no_art_cleans_sources_and_allows_reentry(self):
        self.component('host-stop-cleanup')

    def test_actual_slot3_component_retains_movie_and_maps_new_providers(self):
        self.component('slot3-return')


    def test_unstarted_d2_refuses_normal_load_before_clear(self):
        self.component('unstarted-refusal')


if __name__ == '__main__':
    unittest.main()
