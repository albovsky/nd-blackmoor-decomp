"""NATIVE-06/07: alarm callbacks, muted audio timing and real S2175 routes.

Fresh native modules and the actual app source are built in temporary storage.
The normal app entry reads original resources in place and uses offline audio;
Ordinary components sink sound; audio components use production callbacks and
the muted offline backend. Input and the real clock binding run unchanged.
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


class NativeAlarmClockTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-alarm-app-')
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
        cls.executable = build / 'native-alarm-glue'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_alarm_clock_glue_test.mm')]
        app_source = os.environ.get('BLACKMOOR_NATIVE_ALARM_APP_SOURCE')
        if app_source:
            command += ['-DNATIVE_ALARM_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
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
            raise RuntimeError('Alarm app fixture compilation failed:\n' + result.stderr)

    def component(self, mode):
        result = subprocess.run([str(self.executable), '--clock-component', str(self.game), mode],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_alarm_mode_hour_steps_time_mode_and_press_delay(self):
        self.component('controls')

    def test_accepted_edge_survives_candidate_clearing_callback_interleaving(self):
        self.component('retained')

    def test_cancel_completes_real_clock_row_and_inactive_clock_falls_through(self):
        self.component('cancel')

    def test_clock_miss_updates_over_before_generic_fallthrough(self):
        self.component('miss')

    def test_each_original_priority_guard_refuses_clock_hover(self):
        self.component('guards')

    def test_unknown_possible_owner_remains_explicitly_limited(self):
        self.component('unknown')

    def test_ui_mode_and_disabled_producer_do_not_hover_clock(self):
        self.component('ui')

    def test_real_muted_audio_gates_final_sound_until_natural_completion(self):
        self.component('audio')

    def test_cancel_unloads_real_clock_audio(self):
        self.component('audio-cancel')

    def test_missing_descriptor_and_shared_channel_refresh_use_real_backend(self):
        self.component('audio-shared')

    def test_actual_alarm_and_set_gestures_reach_real_wake_scene(self):
        log = Path(self.temp.name) / 'alarm-set-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:11', '--live-scene-row', '2010:9',
                '--live-scene-row', '2013:3', '--live-click-at', '2020:472,217',
                '--live-click-at', '2175:117,216', '--live-click-at', '2175:259,265',
                '--live-ticks', '3400', '--rand-seed', '1', '--mute',
                '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=180)
        contents = log.read_text() if log.is_file() else ''
        alarm_up = contents.find('live_click_at_up scene=2175 pointer=117,216')
        set_up = contents.find('live_click_at_up scene=2175 pointer=259,265')
        wake = re.search(r'^scene_transition_applied source=2175 target=2176\b', contents, re.MULTILINE)
        transitions = re.findall(r'^scene_transition_applied source=(\d+) target=(\d+)\b', contents, re.MULTILINE)
        # Report actual subsequent scenes; their identities are not a fixture
        # shortcut or a predeclared outcome of the wake sequence.
        after_clock = [target for source, target in transitions[
            next((i for i, pair in enumerate(transitions) if pair == ('2175', '2176')), len(transitions)):]]
        summary = (f'CLOCK_WAKE alarm_up={int(alarm_up >= 0)} set_up={int(set_up >= 0)} '
                   f'entered2176={int(wake is not None)} reached_after_clock={after_clock}')
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertGreaterEqual(alarm_up, 0, summary)
        self.assertGreater(set_up, alarm_up, summary + '\nSecond queued actual gesture never fired')
        self.assertIsNotNone(wake, summary + '\nClock did not request its real Set target')
        self.assertLess(set_up, wake.start(), summary)
        self.assertRegex(contents, r'scene_aaa_click row=3 button=1\b', summary)
        self.assertRegex(contents, r'scene_aaa_click row=3 button=6\b', summary)
        self.assertIn('native_audio_output_muted=1', contents, summary)
        # The real installed clips must resolve through the app's provider;
        # accepting NO_RESOURCE must not make this real-data route vacuous.
        self.assertEqual(contents.count('scene_aaa_sound call=0x4fb77a native_status=0'), 2, summary)
        self.assertEqual(contents.count('scene_aaa_sound channel=9 call=0x4fb2e3 native_status=0'), 3, summary)
        self.assertEqual(contents.count('scene_aaa_sound call=0x4fba69 native_status=0'), 2, summary)
        self.assertIn('scene_aaa_sound channel=9 call=0x4fb2e3 native_status=0', contents[set_up:], summary)
        self.assertNotRegex(contents, r'(?m)^scene_aaa_sound .*native_status=[1-9]\d*', summary)
        for error in ('scene_session_blocked', 'session_frozen', 'scene_aaa_click_error', 'scene_aaa_pointer_error'):
            self.assertNotIn(error, contents, summary)

    def test_real_cancel_returns_to_bedroom_through_actual_transition(self):
        metadata = subprocess.run([str(self.executable), '--clock-metadata', str(self.game)],
                                  capture_output=True, text=True, timeout=30)
        self.assertEqual(metadata.returncode, 0, metadata.stdout + metadata.stderr)
        coordinates = re.search(r'window=(\d+),(\d+)', metadata.stdout)
        self.assertIsNotNone(coordinates, metadata.stdout)
        print(metadata.stdout.strip())
        x, y = coordinates.groups()
        # Actual app default geometry is a 1x1 cursor with hotspot 0,0.
        # Metadata adds the real viewport origin 10,10 to the Cancel centre.
        click = f'2175:{x},{y}'
        log = Path(self.temp.name) / 'alarm-cancel-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:11', '--live-scene-row', '2010:9',
                '--live-scene-row', '2013:3', '--live-click-at', '2020:472,217',
                '--live-click-at', click, '--live-ticks', '3000', '--rand-seed', '1', '--mute',
                '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=180)
        contents = log.read_text() if log.is_file() else ''
        entered = re.search(r'^scene_transition_applied source=2020 target=2175\b', contents, re.MULTILINE)
        pressed = re.search(r'^scene_aaa_click row=3 button=8\b', contents, re.MULTILINE)
        returned = re.search(r'^scene_transition_applied source=2175 target=2020\b', contents, re.MULTILINE)
        summary = (f'CLOCK_ROUTE entered={int(entered is not None)} cancel={int(pressed is not None)} '
                   f'returned={int(returned is not None)} click={click}')
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertIsNotNone(entered, summary + '\nRoute never reached actual alarm scene')
        self.assertIn(f'live_click_at_up scene=2175 pointer={x},{y}', contents, summary)
        self.assertIsNotNone(pressed, summary + '\nActual Cancel release did not reach the clock')
        self.assertIsNotNone(returned, summary + '\nReal Cancel block did not return to S2020')
        self.assertLess(entered.start(), pressed.start(), summary)
        self.assertLess(pressed.start(), returned.start(), summary)
        through_transition = contents[:returned.end()]
        for error in ('scene_session_blocked', 'session_frozen', 'scene_aaa_click_error', 'scene_aaa_pointer_error'):
            self.assertNotIn(error, through_transition, summary)


if __name__ == '__main__':
    unittest.main()
