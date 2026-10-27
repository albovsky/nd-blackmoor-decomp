"""NATIVE-23: silent, ordinary owner-local AVF ownership checks only."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', PROJECT.parents[1] / 'work'))
CLIPS = {
    'JAN_fidget.avf': '75e80344fe432dd28cfff9f75eb807f9da2ece13801686a8595ff3e9b9fcdfcb',
    'CON_fidget.avf': '9f7d8c461b2e7a04094d6c962d08261cd8002acaf9b08c8c6aa4c74cb7838036',
    'Nigel_Fidget.avf': '336bac148eb734a2afa3f3d929afebac938c3bee9342f2dcf72d79299fdf45f3',
}


class NativeSecondaryVideoTests(unittest.TestCase):
    def test_actual_avf_sets_hidden_slots_and_lifetimes(self):
        descriptor = WORK / 'analysis/game-source.json'
        if not descriptor.is_file():
            self.skipTest('Owner-local game descriptor unavailable')
        game = Path(json.loads(descriptor.read_text())['game_dir'])
        for name, digest in CLIPS.items():
            clip = game / 'CDVideo' / name
            if not clip.is_file():
                self.skipTest('Owner-local secondary AVF unavailable: ' + name)
            self.assertEqual(hashlib.sha256(clip.read_bytes()).hexdigest(), digest, name)
            print('SECONDARY_VIDEO ' + name + ' sha256=' + digest)
        with tempfile.TemporaryDirectory(prefix='blackmoor-secondary-video-') as temp:
            executable = Path(temp) / 'secondary-video'
            command = ['xcrun', 'clang', '-std=c11', '-O2', '-Wall', '-Wextra',
                       '-Wpedantic', '-Werror', '-I' + str(PROJECT / 'src'),
                       str(PROJECT / 'tests/native_secondary_video_test.c'),
                       str(PROJECT / 'src/native_secondary_video.c'),
                       str(PROJECT / 'src/avf_decoder.c'), '-o', str(executable)]
            built = subprocess.run(command, capture_output=True, text=True, timeout=60)
            self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
            print('SECONDARY_VIDEO native_sha256=' + hashlib.sha256(executable.read_bytes()).hexdigest())
            result = subprocess.run([str(executable), str(game)], capture_output=True,
                                    text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            print(result.stdout.strip())


if __name__ == '__main__':
    unittest.main()
