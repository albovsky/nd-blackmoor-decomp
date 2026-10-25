"""Master mute: fresh native host, process-local defaults and offline PCM only."""
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class NativeAudioMuteTests(unittest.TestCase):
    def test_master_mute_silences_game_and_movie_slots_without_stalling_completion(self):
        with tempfile.TemporaryDirectory(prefix='blackmoor-mute-') as directory:
            executable = Path(directory) / 'native-audio-mute'
            command = ['xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64',
                       '-mmacosx-version-min=27.0', '-std=c++17', '-fobjc-arc', '-fblocks',
                       '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2',
                       str(PROJECT / 'tests/native_audio_mute_test.mm'),
                       str(PROJECT / 'src/macos_audio.mm'),
                       '-framework', 'Foundation', '-framework', 'AVFAudio',
                       '-o', str(executable)]
            compiled = subprocess.run(command, capture_output=True, text=True, timeout=60)
            self.assertEqual(compiled.returncode, 0, compiled.stdout + compiled.stderr)
            run = subprocess.run([str(executable)], capture_output=True, text=True, timeout=30)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            self.assertIn('MUTE muted=1 ordinary_peak=0.000000 movie_peak=0.000000 natural_completion=2', run.stdout)
            self.assertIn('MUTE muted=0 ordinary_peak=', run.stdout)
            self.assertEqual(run.stdout.count('natural_completion=2'), 2)
            print(run.stdout.strip())


if __name__ == '__main__':
    unittest.main()
