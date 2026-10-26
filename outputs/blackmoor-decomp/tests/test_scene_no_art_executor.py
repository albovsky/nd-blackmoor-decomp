"""Fresh executable checks for sparse retained ACTs; no assets, ctypes or devices."""
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


def word(value):
    return int(value).to_bytes(2, 'little', signed=True)


def dependency(index, expected, or_after=0):
    return b''.join(word(value) for value in (2, index, expected, or_after, 0, 0, 0, 0))


def action(kind, body, dependencies=(), subtype=1):
    return b'synthetic'.ljust(48, b'\0') + bytes((kind, subtype)) + body + b''.join(dependencies)


def chunk(kind, body):
    return kind + len(body).to_bytes(4, 'big') + body + (b'\0' if len(body) & 1 else b'')


def scene(actions):
    summary = bytearray(126)
    summary[:10] = b'NoArtTest\0'
    summary[50:63] = b'NO_ART_SCENE\0'
    summary[83:92] = b'NO SOUND\0'
    payload = b'SCEN' + chunk(b'TSUM', bytes(summary))
    payload += b''.join(chunk(b'ACT\0', item) for item in actions)
    return b'DATA' + len(payload).to_bytes(4, 'big') + payload


class SceneNoArtExecutorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-no-art-executor-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        cls.executable = build / 'scene-no-art-executor'
        core = Path(os.environ.get('BLACKMOOR_SCENE_NO_ART_CORE_PROJECT', PROJECT)).resolve()
        modules = ('hiff', 'scene_resource', 'scene_conditions', 'action_core',
                   'action_family_64', 'scene_executor', 'scene_action_slots')
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   '-O2', '-DSCENE_EXECUTOR_TEST_HOOKS', '-I' + str(core / 'src')]
        command += [str(core / 'src' / (module + '.c')) for module in modules]
        command += [str(PROJECT / 'tests/scene_no_art_executor_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            raise RuntimeError('No-art executor compilation failed:\n' + (result.stdout + result.stderr)[:4000])
        cls.paths = [build / name for name in ('source.scen', 'incoming.scen', 'single.scen', 'unsupported.scen')]
        cls.paths[0].write_bytes(scene([
            action(0x95, bytes(3), (dependency(0, 1, 1), dependency(1, 1), dependency(2, 1))),
            action(0x0a, bytes(20), (dependency(3, 1),)),
            action(0x4d, bytes((0, 1)) + word(41)),
            action(0x95, bytes(3)),
        ]))
        cls.paths[1].write_bytes(scene([
            action(0x95, bytes(3), (dependency(0, 1),)), action(0x95, bytes(3)),
        ]))
        cls.paths[2].write_bytes(scene([action(0x95, bytes(3))]))
        # A valid opaque ACT is parsed, but cannot safely build dependencies.
        cls.paths[3].write_bytes(scene([action(0xff, b'opaque')]))
        print('SCENE_NO_ART_EXECUTOR_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest() + ' core=' + str(core))

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name, *(str(path) for path in self.paths)],
                                capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS scene_no_art_executor ' + name)

    def test_retained_state_cached_conditions_and_ascending_global_dispatch(self):
        self.check_case('retained')

    def test_true_erase_trailing_trim_repeated_append_and_cleanup(self):
        self.check_case('erase')

    def test_bad_plan_unsupported_incoming_and_discard_leave_source_unchanged(self):
        self.check_case('prepare')

    def test_dispatch_invalidates_preparation_before_commit(self):
        self.check_case('stale')


if __name__ == '__main__':
    unittest.main()
