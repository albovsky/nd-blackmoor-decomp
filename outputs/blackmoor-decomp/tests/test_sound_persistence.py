"""RT-11: recovered fresh-entry reset, continuation survival, offline only."""
import ctypes as c
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import session_exit_support as exit_support
import test_live_audio as audio

PROJECT = Path(__file__).resolve().parents[1]


class Plan(c.Structure):
    _fields_ = [('channels', c.c_uint16 * 15), ('count', c.c_size_t)]


def configure(lib):
    lib.session_exit_plan_audio.argtypes = [c.POINTER(exit_support.Exit), c.c_uint16,
                                           c.POINTER(Plan)]
    lib.session_exit_plan_audio.restype = c.c_int


class SoundPersistenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory(prefix='rt11-')
        cls.directory = Path(cls.tmp.name)
        result = subprocess.run([str(PROJECT / 'scripts/build_session_exit.sh')],
                                capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(result.stdout + result.stderr)
        cls.lib = exit_support.load_library(PROJECT / 'build/libsessionexit.dylib')
        configure(cls.lib)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_every_transition_word_and_channel(self):
        for flag in (0, 1, 2, -1, -32768, 32767):
            for channel in range(32):
                x = exit_support.new_exit(self.lib, state=1)
                x.g.scene_request_flag = flag
                self.assertEqual(self.lib.session_exit_begin_load(c.byref(x)), 0)
                plan = Plan()
                self.assertEqual(self.lib.session_exit_plan_audio(c.byref(x), channel,
                                                                 c.byref(plan)), 0)
                self.assertEqual(list(plan.channels)[:plan.count],
                                 [channel, *range(14)] if flag == 0 else [])
                self.assertEqual(x.g.scene_request_flag, flag)

    def test_rejects_invalid_state_and_channel_without_effects(self):
        for state in (0, 1, 4, 99):
            x = exit_support.new_exit(self.lib, state=state)
            plan = Plan()
            self.assertEqual(self.lib.session_exit_plan_audio(c.byref(x), 19,
                                                             c.byref(plan)), 2)
            self.assertEqual(plan.count, 0)
        x = exit_support.new_exit(self.lib, state=2)
        self.assertEqual(self.lib.session_exit_plan_audio(c.byref(x), 32, c.byref(Plan())), 1)
        self.assertEqual(self.lib.session_exit_plan_audio(None, 19, c.byref(Plan())), 1)
        self.assertEqual(self.lib.session_exit_plan_audio(c.byref(x), 19, None), 1)

    def test_real_provider_transition_scenarios(self):
        result = audio.build('lib')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        tree = self.directory / 'game'
        audio.build_fixture_tree(tree)
        binary = self.directory / 'persistence'
        result = subprocess.run([
            'xcrun', 'clang', '-arch', 'arm64', '-std=gnu17', '-Wall', '-Wextra', '-Werror',
            '-O1', '-g', '-fsanitize=address,undefined', '-I' + str(PROJECT / 'src'),
            str(PROJECT / 'tests/sound_persistence_test.c'),
            '-L' + str(PROJECT / 'build'), '-lliveaudio', '-lmacos_audio', '-lhis_audio',
            '-lsessionexit', '-Wl,-rpath,' + str(PROJECT / 'build'), '-o', str(binary)],
            capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        result = subprocess.run([str(binary), str(tree)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn('RT-11 scenarios passed', result.stdout)


if __name__ == '__main__':
    unittest.main()
