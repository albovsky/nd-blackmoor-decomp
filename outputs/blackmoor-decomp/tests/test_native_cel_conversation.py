"""NATIVE20: actual Jane CEL component; silent offline native host only."""
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


class NativeCelConversationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('Actual native CEL integration requires macOS')
        source = WORK / 'analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Owner-local game descriptor unavailable')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Owner-local game installation unavailable')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-cel-app-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_CEL_APP_SOURCE')
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
        cls.executable = build / 'native-cel-conversation-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_cel_conversation_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_CEL_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('CEL app fixture compilation failed:\n' + result.stderr)

    def test_actual_s1200_cel_conversation(self):
        for captions in ('on', 'off'):
            with self.subTest(captions=captions):
                result = subprocess.run([str(self.executable), str(self.game), captions],
                                        capture_output=True, text=True, timeout=60)
                print(result.stdout.strip())
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == '__main__':
    unittest.main()
