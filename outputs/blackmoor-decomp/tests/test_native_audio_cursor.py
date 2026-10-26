"""NATIVE20 source cursor: fresh normal native builds and silent offline components."""
import json
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class NativeAudioCursorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-cursor-')
        cls.addClassCleanup(cls.temp.cleanup)
        directory = Path(cls.temp.name)
        sounds = directory / 'CDSound'
        sounds.mkdir()
        payload = struct.pack('<h', 4000) * 44100
        header = b'HIS\0' + struct.pack('<IHHIIHHIH', 2, 1, 1, 22050, 44100, 2, 16, len(payload), 1)
        (sounds / 'Mono.his').write_bytes(header + payload)
        stereo = bytes([150, 100]) * 32000
        stereo_header = b'HIS\0' + struct.pack('<IHHIIHHIH', 2, 1, 2, 32000, 64000, 2, 8, len(stereo), 1)
        (sounds / 'Stereo8.his').write_bytes(stereo_header + stereo)
        cls.game = directory
        flags = ['-arch', 'arm64', '-mmacosx-version-min=27.0', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2']
        prefix = Path(os.environ.get('FFMPEG_PREFIX', '/opt/homebrew'))
        objects = []
        for module in ('live_audio', 'his_audio', 'sound_control'):
            output = directory / (module + '.o')
            cls.compile(['xcrun', '--sdk', 'macosx', 'clang', *flags, '-std=c11', '-I' + str(prefix / 'include'),
                         '-c', str(PROJECT / 'src' / (module + '.c')), '-o', str(output)])
            objects.append(str(output))
        cls.exe = directory / 'cursor'
        cls.compile(['xcrun', '--sdk', 'macosx', 'clang++', *flags, '-std=c++17', '-fobjc-arc', '-fblocks',
                     str(PROJECT / 'tests/native_audio_cursor_test.mm'), str(PROJECT / 'src/macos_audio.mm'),
                     *objects, '-framework', 'Foundation', '-framework', 'AVFAudio', '-L' + str(prefix / 'lib'),
                     '-lavformat', '-lavcodec', '-lavutil', '-lswresample', '-Wl,-rpath,' + str(prefix / 'lib'), '-o', str(cls.exe)])

    @staticmethod
    def compile(command):
        result = subprocess.run(command, capture_output=True, text=True, timeout=60)
        if result.returncode:
            raise RuntimeError(result.stdout + result.stderr)

    def component(self, mode, game=None):
        args = [str(self.exe), mode] + ([] if game is None else [str(game)])
        result = subprocess.run(args, capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())

    def test_native_host_render_cursor_and_transport_generations(self):
        self.component('host')

    def test_original_mono_format_and_source_byte_position(self):
        self.component('synthetic', self.game)

    def test_custom_host_without_cursor_is_explicitly_unsupported(self):
        self.component('custom', self.game)

    def test_owner_local_jane_voice_source_cursor(self):
        path = PROJECT.parents[1] / 'work/analysis/game-source.json'
        if not path.is_file():
            self.skipTest('owner-local game descriptor unavailable')
        self.component('real', Path(json.loads(path.read_text())['game_dir']))


if __name__ == '__main__':
    unittest.main()
