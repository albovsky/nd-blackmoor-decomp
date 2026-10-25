"""NATIVE-04: real S2186 route and an explicit app ownership boundary.

Fresh native modules and the actual app source are built in temporary storage.
The normal app entry reads original resources in place and uses offline audio;
there are no injected candidates, latches, phases, frames or game flags.
"""
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


class NativeInteractiveVideoTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-iv-app-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        inventory = re.search(r'^for module in (.+); do$',
                              (PROJECT / 'scripts/build_native_app.sh').read_text(), re.MULTILINE)
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
                         str(PROJECT / 'src' / (module + '.c')), '-o', str(output)])
            objects.append(str(output))
        cls.executable = build / 'native-iv-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_interactive_video_glue_test.mm')]
        command += [str(PROJECT / 'src' / (module + '.mm')) for module in
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
            raise RuntimeError('IV app fixture compilation failed:\n' + result.stderr)

    def test_real_iv_hover_release_sets_flag_and_follows_dependent_scene_transition(self):
        log = Path(self.temp.name) / 'newton-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:1', '--live-scene-row', '2010:7',
                '--live-scene-row', '2011:5', '--live-scene-row', '2019:3',
                '--live-click-at', '2186:330,160', '--live-ticks', '2450', '--rand-seed', '1',
                '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=150)
        contents = log.read_text() if log.is_file() else ''
        active = re.search(r'^scene_a1c_active\b[^\n]*\brow=6\b[^\n]*\bphase=1\b', contents, re.MULTILINE)
        hover = re.search(r'^scene_a1c_pointer\b[^\n]*\bcandidate=(?:10160|10162|0x27b0|0x27b2)\b',
                          contents, re.MULTILINE)
        release = re.search(r'^scene_a1c_release\b[^\n]*\bflag=1000\b[^\n]*\bvalue=1\b', contents, re.MULTILINE)
        # Original S2186 row 7 is raw 0x0a, target 2188, gated by flag 1000=1.
        transition = re.search(r'^scene_transition_applied source=2186 target=2188\b', contents, re.MULTILINE)
        ends = [line for line in contents.splitlines() if line.startswith('live_session_end ')]
        summary = (f'IV_ROUTE active={int(active is not None)} hover={int(hover is not None)} '
                   f'flag={int(release is not None)} dependent_transition={int(transition is not None)} '
                   f'waits={contents.count("scene_a1c_wait ")} end={ends[-1] if ends else "absent"}')
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertIsNotNone(active, summary + '\nIV never activated through the actual A35/1c bindings')
        self.assertIsNotNone(hover, summary + '\nActual IV hover never published an original candidate')
        self.assertIsNotNone(release, summary + '\nActual primary release did not store flag 1000=1')
        self.assertIsNotNone(transition, summary + '\nReal flag-dependent row did not enter S2188')
        self.assertLess(active.start(), hover.start(), summary)
        self.assertLess(hover.start(), release.start(), summary)
        self.assertLess(release.start(), transition.start(), summary)
        self.assertIn('live_click_at_up scene=2186 pointer=330,160', contents, summary)
        through_transition = contents[:transition.end()]
        self.assertNotIn('scene_session_blocked', through_transition, summary)
        self.assertNotIn('session_frozen', through_transition, summary)

    def test_single_iv_owner_projects_but_opaque_earlier_owner_remains_limited(self):
        result = subprocess.run([str(self.executable), '--unknown-owner', str(self.game)],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == '__main__':
    unittest.main()
