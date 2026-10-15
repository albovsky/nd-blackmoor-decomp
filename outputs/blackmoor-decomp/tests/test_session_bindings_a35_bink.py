"""RT-9 host split: due stages; decode/audio; rect; next, with no game decisions."""
import subprocess
import unittest
import tempfile
import oracle_support
from test_live_audio import build_fixture_tree
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]

def run(command):
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode:
        raise AssertionError(f'{command[0]} exited {result.returncode}: ' +
                             result.stdout[-2000:] + result.stderr[-4000:])

class BinkBindingTests(unittest.TestCase):
    def test_host_protocol(self):
        run(['sh', str(BASE / 'scripts/build_session_bindings_a35_bink_test.sh')])
        run([str(BASE / 'build/session_bindings_a35_bink_test')])

    def test_original_bink_controller_quick_oracle(self):
        oracle_python = oracle_support.require_oracle_python(
            BASE.parents[1] / 'work/tools/oracle-python/bin/python')
        with tempfile.TemporaryDirectory() as directory:
            run([str(oracle_python),
                 str(BASE / 'tests/action_family_35_bink_original_oracle.py'),
                 '--quick', '--report', str(Path(directory) / 'oracle.json')])

    def test_movie_bus_preserves_scene_channels(self):
        subprocess.run(['sh', str(BASE / 'scripts/build_live_audio.sh'), 'lib'], check=True,
                       capture_output=True, text=True)
        binary = BASE / 'build/live_audio_movie_test'
        subprocess.run(['xcrun', 'clang', '-arch', 'arm64', '-std=gnu17', '-Wall', '-Wextra',
                        '-Werror', '-O1', '-g', '-I' + str(BASE / 'src'),
                        str(BASE / 'tests/live_audio_movie_test.c'), '-L' + str(BASE / 'build'),
                        '-lliveaudio', '-lmacos_audio', '-lhis_audio',
                        '-Wl,-rpath,' + str(BASE / 'build'), '-o', str(binary)],
                       check=True, capture_output=True, text=True)
        with tempfile.TemporaryDirectory() as directory:
            build_fixture_tree(Path(directory))
            run([str(binary), directory])

if __name__ == '__main__':
    unittest.main()
