"""N27: real first-entry S3337 forced-phone component, silent offline native host.

Direct entry with fresh original BOOT/new-game state and the supported seed1
replay option; no campaign claim, injected story/item/row/response state,
original-x86 oracle, GUI, output device, fault, sanitizer or mutation runner.
A separate labeled taskbar guard case supplies only unit input/state.
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


class NativeForcedPhoneTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform != 'darwin':
            raise unittest.SkipTest('Actual native Forced-phone integration requires macOS')
        source = WORK / 'analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Owner-local game descriptor unavailable')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Owner-local game installation unavailable')
        temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-forced-phone-app-')
        cls.addClassCleanup(temp.cleanup)
        build = Path(temp.name)
        app_source = os.environ.get('BLACKMOOR_NATIVE_FORCED_PHONE_APP_SOURCE')
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
        cls.executable = build / 'native-forced-phone-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   '-I' + str(native_project / 'src'),
                   str(PROJECT / 'tests/native_forced_phone_glue_test.mm')]
        if app_source:
            command += ['-DNATIVE_FORCED_PHONE_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
        # The pre-N27 app lacks phone fields. Explicit RED-only mode keeps
        # the common real voice/deferred-request assertion; ordinary source
        # overrides still run both complete current-source component cases.
        if os.environ.get('BLACKMOOR_NATIVE_FORCED_PHONE_BASELINE') == '1':
            command += ['-DNATIVE_FORCED_PHONE_BASELINE=1']
        command += [str(native_project / 'src' / (module + '.mm')) for module in
                    ('macos_platform', 'macos_audio', 'scene_inspector')]
        command += objects + ['-framework', 'AppKit', '-framework', 'Foundation',
                              '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                              '-L' + str(prefix / 'lib'), '-lavformat', '-lavcodec', '-lavutil',
                              '-lswscale', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'),
                              '-o', str(cls.executable)]
        cls.compile(command)
        source_path = Path(app_source).resolve() if app_source else native_project / 'src/blackmoor_app.mm'
        print('FORCED_PHONE_BUILD executable_sha256=' + hashlib.sha256(cls.executable.read_bytes()).hexdigest() +
              ' app_sha256=' + hashlib.sha256(source_path.read_bytes()).hexdigest())

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError('Forced-phone app fixture compilation failed:\n' + result.stderr)

    def component(self, case):
        result = subprocess.run([str(self.executable), str(self.game), case],
                                capture_output=True, text=True, timeout=60)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_first_entry_forced_phone_original_frame_and_retained_call_crops(self):
        self.component('frame')

    def test_first_entry_forced_phone_real_pickup_farewell_and_return_cleanup(self):
        self.component('flow')

    def test_taskbar_manual_or_unavailable_phone_request_preserves_unhandled_state(self):
        self.component('request-guard')


if __name__ == '__main__':
    unittest.main()
