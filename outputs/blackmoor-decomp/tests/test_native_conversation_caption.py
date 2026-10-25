"""NATIVE-12: actual app conversation captions with muted offline audio.

Build fresh normal production modules. These are S1800/S1807 components using
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


class NativeConversationCaptionTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-conversation-caption-app-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_CONVERSATION_APP_SOURCE')
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
        cls.executable = build / 'native-conversation-caption-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_conversation_caption_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_CONVERSATION_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)
        source_path = Path(app_source).resolve() if app_source else native_project / 'src/blackmoor_app.mm'
        print('CONVO_BUILD executable_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest() +
              ' app_sha256=' + hashlib.sha256(source_path.read_bytes()).hexdigest())

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('Conversation app fixture compilation failed:\n' + result.stderr)

    def component(self, mode):
        result = subprocess.run([str(self.executable), '--conversation-component', str(self.game), mode],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_real_enabled_caption_starts_s1800_row9(self):
        self.component('start')

    def test_real_muted_voice_busy_gate_then_natural_completion_releases_surfaces(self):
        self.component('sound')

    def test_scene_replacement_clears_active_caption_and_reentry_rebuilds_it(self):
        self.component('reset')

    def test_original_primary_response_row_is_explicitly_unsupported_before_effects(self):
        self.component('unsupported')


if __name__ == '__main__':
    unittest.main()
