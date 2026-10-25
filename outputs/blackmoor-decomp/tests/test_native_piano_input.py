"""NATIVE-09/10: actual native app piano input, built fresh in temporary storage.

Components read S3395 through the owner-local canonical game descriptor and sink
rendering, text and finish transition effects. Named audio cases use real
production D0 callbacks with a muted offline graph. Normal muted routes use
production app providers. No oracle modules are imported.
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


class NativePianoInputTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-piano-app-')
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
        cls.executable = build / 'native-piano-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_piano_input_glue_test.mm')]
        app_source = os.environ.get('BLACKMOOR_NATIVE_PIANO_APP_SOURCE')
        if app_source:
            command += ['-DNATIVE_PIANO_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
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
            raise RuntimeError('Piano app fixture compilation failed:\n' + result.stderr)

    def component(self, mode):
        result = subprocess.run([str(self.executable), '--piano-component', str(self.game), mode],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_real_key_sound_busy_and_500ms_stop_unload(self):
        self.component('audio-key')

    def test_real_key_clip_finishes_naturally_without_bypassing_release_deadline(self):
        self.component('audio-natural')

    def test_actual_solution_silent_win_delay_flag_and_cleanup(self):
        self.component('audio-solve')

    def test_missing_descriptor_and_shared_channel_refresh_use_real_provider(self):
        self.component('audio-shared')

    def test_real_key_hover_release_and_sequence_effects_follow_ACT(self):
        self.component('key')

    def test_real_exit_finishes_and_inactive_piano_falls_through(self):
        self.component('exit')

    def test_same_tick_move_off_retains_key_for_release_then_scans_miss(self):
        self.component('retained')

    def test_private_guarded_projection_preserves_release_edge(self):
        self.component('projection')

    def test_miss_falls_through_and_preserves_held_item_cursor(self):
        self.component('miss')

    def test_each_original_priority_guard_rejects_piano_input(self):
        self.component('guards')

    def test_unknown_and_duplicate_owners_remain_explicitly_limited(self):
        self.component('owners')

    def test_ui_modes_disabled_and_outside_pointer_reject_hover(self):
        self.component('ui')

    def test_real_muted_route_plays_key_and_leaves_piano(self):
        metadata = subprocess.run([str(self.executable), '--piano-component', str(self.game), 'metadata'],
                                  capture_output=True, text=True, timeout=30)
        self.assertEqual(metadata.returncode, 0, metadata.stdout + metadata.stderr)
        coordinates = re.search(r'key_window=(\d+),(\d+) exit_window=(\d+),(\d+) target=(\d+)', metadata.stdout)
        self.assertIsNotNone(coordinates, metadata.stdout)
        print(metadata.stdout.splitlines()[0])
        key_x, key_y, exit_x, exit_y, target = coordinates.groups()
        log = Path(self.temp.name) / 'piano-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:3']
        route = [(2010, 8), (2006, 2), (2007, 1), (3301, 5), (3302, 11), (3370, 1)]
        route += [(scene, 2) for scene in range(3371, 3380)] + [(3380, 3)]
        for scene, row in route:
            args += ['--live-scene-row', f'{scene}:{row}']
        args += ['--live-click-at', f'3395:{key_x},{key_y}',
                 '--live-click-at', f'3395:{exit_x},{exit_y}', '--live-ticks', '5000',
                 '--rand-seed', '1', '--mute', '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=180)
        contents = log.read_text() if log.is_file() else ''
        entered = re.search(r'^scene_transition_applied source=3380 target=3395\b', contents, re.MULTILINE)
        key = re.search(r'^scene_ad0_key row=\d+ key=0\b', contents, re.MULTILINE)
        returned = re.search(r'^scene_transition_applied source=3395 target=' + target + r'\b', contents, re.MULTILINE)
        summary = (f'PIANO_ROUTE entered={int(entered is not None)} key={int(key is not None)} '
                   f'exit={int(returned is not None)} status={result.returncode}')
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertIsNotNone(entered, summary)
        self.assertIsNotNone(key, summary)
        self.assertIsNotNone(returned, summary)
        self.assertLess(entered.start(), key.start(), summary)
        self.assertLess(key.start(), returned.start(), summary)
        self.assertIn(f'live_click_at_up scene=3395 pointer={key_x},{key_y}', contents, summary)
        self.assertIn(f'live_click_at_up scene=3395 pointer={exit_x},{exit_y}', contents, summary)
        self.assertIn('native_audio_output_muted=1', contents, summary)
        for error in ('scene_session_blocked', 'session_frozen', 'scene_ad0_click_error',
                      'scene_ad0_pointer_error', 'session_input_error'):
            self.assertNotIn(error, contents, summary)

    def test_normal_muted_app_plays_real_solution_and_reaches_solved_scene(self):
        metadata = subprocess.run([str(self.executable), '--piano-component', str(self.game), 'metadata'],
                                  capture_output=True, text=True, timeout=30)
        self.assertEqual(metadata.returncode, 0, metadata.stdout + metadata.stderr)
        solution = re.search(r'^PIANO_SOLUTION length=(\d+) keys=([\d,]+)$', metadata.stdout, re.MULTILINE)
        points = {int(key): (x, y) for key, x, y in re.findall(
            r'^PIANO_KEY_METADATA key=(\d+) window=(\d+),(\d+)', metadata.stdout, re.MULTILINE)}
        solved = re.search(r'^PIANO_BLOCK kind=solved target=(\d+) .* flag=(\d+) value=(\d+)$',
                           metadata.stdout, re.MULTILINE)
        self.assertIsNotNone(solution, metadata.stdout)
        self.assertIsNotNone(solved, metadata.stdout)
        keys = [int(key) for key in solution.group(2).split(',')]
        self.assertEqual(len(keys), int(solution.group(1)), metadata.stdout)
        self.assertEqual((solved.group(1), solved.group(2), solved.group(3)), ('3396', '2013', '1'))
        log = Path(self.temp.name) / 'piano-solve-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:3']
        route = [(2010, 8), (2006, 2), (2007, 1), (3301, 5), (3302, 11), (3370, 1)]
        route += [(scene, 2) for scene in range(3371, 3380)] + [(3380, 3)]
        for scene, row in route:
            args += ['--live-scene-row', f'{scene}:{row}']
        for key in keys:
            x, y = points[key]
            args += ['--live-click-at', f'3395:{x},{y}']
        args += ['--live-ticks', '5000', '--rand-seed', '1', '--mute',
                 '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=180)
        contents = log.read_text() if log.is_file() else ''
        entered = re.search(r'^scene_transition_applied source=3380 target=3395\b', contents, re.MULTILINE)
        transition = re.search(r'^scene_transition_applied source=3395 target=3396\b', contents, re.MULTILINE)
        played = [int(key) for key in re.findall(r'^scene_ad0_key row=1 key=(\d+)\b', contents, re.MULTILINE)]
        summary = (f'PIANO_SOLVE_ROUTE entered={int(entered is not None)} keys={played} '
                   f'target3396={int(transition is not None)} status={result.returncode}')
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertIsNotNone(entered, summary)
        self.assertIsNotNone(transition, summary)
        self.assertEqual(played, keys, summary)
        self.assertRegex(contents, re.compile(r'^scene_ad0_event_flag index=2013 value=1$', re.MULTILINE), summary)
        self.assertLess(entered.start(), transition.start(), summary)
        self.assertEqual(contents.count('scene_ad0_sound call=0x4fb77a native_status=0'), len(keys), summary)
        self.assertEqual(contents.count('scene_ad0_sound channel=8 call=0x4fb2e3 native_status=0'), len(keys), summary)
        self.assertEqual(contents.count('scene_ad0_sound call=0x4fba69 native_status=0'), len(keys), summary)
        self.assertIn('native_audio_output_muted=1', contents, summary)
        for error in ('scene_session_blocked', 'session_frozen', 'scene_ad0_click_error',
                      'scene_ad0_pointer_error', 'scene_ad0_blocker', 'session_input_error'):
            self.assertNotIn(error, contents, summary)
        self.assertNotRegex(contents, r'(?m)^scene_ad0_sound .*native_status=[1-9]\d*', summary)


if __name__ == '__main__':
    unittest.main()
