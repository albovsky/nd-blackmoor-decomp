"""Drake hook0: real S1087 response component, silent offline native host.

Direct entry with fresh original BOOT/new-game state and the supported seed1
replay option; no campaign claim, injected story/item/row/response state,
original-x86 oracle, GUI, output device, fault, sanitizer or mutation runner.
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


class NativeDrakeChoiceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('Actual native Drake integration requires macOS')
        source = WORK / 'analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Owner-local game descriptor unavailable')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Owner-local game installation unavailable')
        temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-drake-choices-app-')
        cls.addClassCleanup(temp.cleanup)
        build = Path(temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_DRAKE_CHOICES_APP_SOURCE')
        native_project = Path(app_source).resolve().parent.parent if app_source else PROJECT
        # A source snapshot in /private/tmp still uses this checkout's current
        # production module inventory for a meaningful old-app runtime RED.
        if app_source and not (native_project / 'scripts/build_native_app.sh').is_file():
            native_project = PROJECT
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
        cls.executable = build / 'native-drake-choices-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   '-I' + str(native_project / 'src'),
                   str(PROJECT / 'tests/native_drake_choices_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_DRAKE_CHOICES_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)
        source_path = Path(app_source).resolve() if app_source else native_project / 'src/blackmoor_app.mm'
        print('DRAKE_CHOICES_BUILD executable_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest() +
              ' app_sha256=' + hashlib.sha256(source_path.read_bytes()).hexdigest())

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('Drake choice app fixture compilation failed:\n' + result.stderr)

    def component(self, case):
        result = subprocess.run([str(self.executable), str(self.game), case],
                                capture_output=True, text=True, timeout=60)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_direct_entry_drake_preview_preserves_shared_rng_and_live_state(self):
        self.component('preview')

    def test_direct_entry_drake_non_cel_voice_pointer_choice_and_following_cel(self):
        self.component('follow')


if __name__ == '__main__':
    unittest.main()
