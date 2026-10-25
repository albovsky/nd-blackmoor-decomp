"""NATIVE-08: actual static AVF background glue, no oracle imports.

All modules are freshly built in scratch storage. Resources are read in place;
fixture CDVideo entries are temporary links or synthetic invalid input only.
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


class NativeAvfBackgroundTests(unittest.TestCase):
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
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-native-avf-background-')
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
        cls.executable = build / 'native-avf-background'
        command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                   '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-O2',
                   '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   str(PROJECT / 'tests/native_avf_background_glue_test.mm')]
        app_source = os.environ.get('BLACKMOOR_NATIVE_AVF_BACKGROUND_APP_SOURCE')
        if app_source:
            command += ['-DNATIVE_AVF_BACKGROUND_APP_SOURCE="' + str(Path(app_source).resolve()) + '"']
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
            raise RuntimeError('AVF background fixture compilation failed:\n' + result.stderr)

    def component(self, media, mode):
        result = subprocess.run([str(self.executable), '--background', str(self.game), str(media), mode],
                                capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def media_tree(self, name):
        directory = Path(self.temp.name) / name
        (directory / 'CDVideo').mkdir(parents=True)
        return directory

    def test_casefolded_avf_name_loads_exact_pixels(self):
        directory = self.media_tree('casefold-avf')
        (directory / 'CDVideo/hal_STAIRlock_PUZ.AvF').symlink_to(self.game / 'CDVideo/HAL_StairLock_PUZ.avf')
        self.component(directory, 'avf')

    def test_casefolded_bik_wins_and_present_invalid_bik_never_falls_back(self):
        for invalid in (False, True):
            with self.subTest(invalid_bik=invalid):
                directory = self.media_tree('bik-invalid' if invalid else 'bik-first')
                (directory / 'CDVideo/HAL_StairLock_PUZ.avf').symlink_to(self.game / 'CDVideo/HAL_StairLock_PUZ.avf')
                bik = directory / 'CDVideo/hal_STAIRlock_PUZ.BiK'
                if invalid:
                    bik.write_bytes(b'not a BIK container')  # synthetic invalid input
                else:
                    bik.symlink_to(self.game / 'CDVideo/BLU_AlarmClockCU.bik')
                self.component(directory, 'reject' if invalid else 'bik')

    def test_ambiguous_bik_and_avf_are_refused(self):
        probe = self.media_tree('case-sensitivity-probe') / 'probe'
        probe.touch()
        try:
            probe.with_name('PROBE').touch(exist_ok=False)
        except FileExistsError:
            self.skipTest('Case-insensitive filesystem cannot represent two ASCII-case variants; BIK/AVF ambiguity requires a case-sensitive filesystem')
        for extension in ('bik', 'avf'):
            with self.subTest(extension=extension):
                directory = self.media_tree('ambiguous-' + extension)
                video = directory / 'CDVideo'
                source = self.game / ('CDVideo/BLU_AlarmClockCU.bik' if extension == 'bik'
                                      else 'CDVideo/HAL_StairLock_PUZ.avf')
                (video / ('HAL_StairLock_PUZ.' + extension)).symlink_to(source)
                (video / ('hal_stairlock_puz.' + extension.upper())).symlink_to(source)
                if extension == 'bik':
                    (video / 'HAL_StairLock_PUZ.avf').symlink_to(self.game / 'CDVideo/HAL_StairLock_PUZ.avf')
                self.component(directory, 'reject')

    def test_real_multiframe_and_synthetic_invalid_avf_are_explicitly_refused(self):
        multi = None
        for path in (self.game / 'CDVideo').iterdir():
            if path.suffix.lower() != '.avf':
                continue
            with path.open('rb') as stream:
                header = stream.read(33)
            if len(header) == 33 and int.from_bytes(header[0x15:0x17], 'little', signed=True) > 1:
                multi = path
                break
        self.assertIsNotNone(multi, 'The owner corpus should contain a multiframe AVF fidget')
        for invalid in (False, True):
            with self.subTest(invalid_avf=invalid):
                directory = self.media_tree('invalid-avf' if invalid else 'multiframe-avf')
                avf = directory / 'CDVideo/HAL_StairLock_PUZ.avf'
                if invalid:
                    avf.write_bytes(b'not an AVF container')  # synthetic invalid input
                else:
                    avf.symlink_to(multi)
                self.component(directory, 'reject')

    def test_real_static_avf_pixels_and_bik_roundtrip(self):
        asset = self.game / 'CDVideo/HAL_StairLock_PUZ.avf'
        self.assertEqual(hashlib.sha256(asset.read_bytes()).hexdigest(),
                         '6dfff5282a76f73749751daa7f720d2f867485ac183fe42a1333aea43898fbc6')
        self.component(self.game, 'roundtrip')

    def test_actual_stairs_route_loads_static_avf_and_retains_d0_input_limit(self):
        log = Path(self.temp.name) / 'stairs-avf-route.log'
        args = [str(self.executable), '--inspect-live-session', '--live-click-row', '34',
                '--live-nav', '2010:left:3', '--live-scene-row', '2010:8',
                '--live-scene-row', '2006:2', '--live-scene-row', '2007:1',
                '--live-scene-row', '3301:5', '--live-scene-row', '3302:11', '--live-scene-row', '3370:1']
        for scene in range(3371, 3380):
            args += ['--live-scene-row', f'{scene}:2']
        args += ['--live-scene-row', '3380:3', '--live-ticks', '4000', '--rand-seed', '1', '--mute',
                 '--game-dir', str(self.game), '--log', str(log)]
        result = subprocess.run(args, capture_output=True, text=True, timeout=180)
        contents = log.read_text() if log.is_file() else ''
        transition = re.search(r'^scene_transition_applied source=3380 target=3395\b', contents, re.MULTILINE)
        decoded = re.search(r'^scene_static_avf_open width=620 height=375 frames=1 decoded_bytes=465000\b', contents, re.MULTILINE)
        end = re.search(r'^live_session_end scene=3395\b[^\n]*\bstatus=0\b', contents, re.MULTILINE)
        summary = f'AVF_ROUTE decoded={int(decoded is not None)} entered3395={int(transition is not None)} end_ok={int(end is not None)}'
        print(summary)
        self.assertEqual(result.returncode, 0, summary + '\n' + result.stderr[-500:])
        self.assertIsNotNone(decoded, summary)
        self.assertIsNotNone(transition, summary)
        self.assertIsNotNone(end, summary)
        self.assertIn('native_audio_output_muted=1', contents, summary)
        self.assertIn('pointer_scan_limit status=3', contents[transition.end():], summary)
        for error in ('scene_transition_error', 'scene_session_blocked', 'session_frozen', 'scene_media_error'):
            self.assertNotIn(error, contents, summary)


if __name__ == '__main__':
    unittest.main()
