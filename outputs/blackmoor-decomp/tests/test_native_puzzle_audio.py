"""NATIVE-01: actual native-app callbacks, original D1 descriptors and audio."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]

class NativePuzzleAudioTests(unittest.TestCase):
    def test_turning_puzzle_callbacks_render_real_clips_and_wait_for_completion(self):
        descriptor = ROOT / 'work/analysis/game-source.json'
        resources = ROOT / 'work/analysis/hiff-resources'
        if not descriptor.is_file() or not resources.is_dir():
            self.skipTest('Requires the owner install and private scene resources')
        game = json.loads(descriptor.read_text())['game_dir']
        objects = Path(os.environ.get('BLACKMOOR_NATIVE_APP_OBJECTS', PROJECT / 'build/native-app'))
        self.assertTrue((objects / 'live_audio.o').is_file(), 'Build the native app first')
        with tempfile.TemporaryDirectory() as directory:
            executable = Path(directory) / 'native-ad1-audio'
            command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                       '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc',
                       '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2',
                       str(PROJECT / 'tests/native_ad1_audio_glue_test.mm')]
            command += [str(PROJECT / ('src/' + name + '.mm')) for name in
                        ('macos_platform', 'macos_audio', 'scene_inspector')]
            command += [str(p) for p in sorted(objects.glob('*.o'))
                        if (PROJECT / 'src' / (p.stem + '.c')).is_file()]
            command += ['-framework', 'AppKit', '-framework', 'Foundation',
                        '-framework', 'CoreGraphics', '-framework', 'AVFAudio',
                        '-L/opt/homebrew/lib', '-lavformat', '-lavcodec', '-lavutil',
                        '-lswscale', '-lswresample', '-Wl,-rpath,/opt/homebrew/lib',
                        '-o', str(executable)]
            compiled = subprocess.run(command, capture_output=True, text=True)
            self.assertEqual(compiled.returncode, 0, compiled.stderr)
            run = subprocess.run([str(executable), game,
                                  *map(str, sorted(resources.glob('*.bin')))],
                                 capture_output=True, text=True, timeout=120)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            self.assertIn('rows=11 clips=20 nonzero_PCM=1 completion_gated=1', run.stdout)
            print(run.stdout.strip())
