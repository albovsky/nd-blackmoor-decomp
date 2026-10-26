"""Borrowed action metadata views and compact executor origins; normal C only."""
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


def dependency(index):
    return b''.join(word(value) for value in (2, index, 1, 0, 0, 0, 0, 0))


def action(description, kind, body, flag):
    return description.encode('ascii').ljust(48, b'\0') + bytes((kind, 1)) + body + dependency(flag)


def chunk(kind, body):
    return kind + len(body).to_bytes(4, 'big') + body + (b'\0' if len(body) & 1 else b'')


def scene(title, actions):
    summary = bytearray(126)
    encoded = title.encode('ascii') + b'\0'
    summary[:len(encoded)] = encoded
    summary[50:61] = b'background\0'
    summary[83:92] = b'NO SOUND\0'
    summary[116:126] = b''.join(word(value) for value in (0, 1, 2, 3, 4))
    payload = b'SCEN' + chunk(b'TSUM', bytes(summary))
    payload += b''.join(chunk(b'ACT\0', item) for item in actions)
    return b'DATA' + len(payload).to_bytes(4, 'big') + payload


class SceneActionViewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-action-view-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        cls.executable = build / 'scene-action-view'
        core = Path(os.environ.get('BLACKMOOR_SCENE_ACTION_VIEW_CORE_PROJECT', PROJECT)).resolve()
        modules = ('hiff', 'scene_resource', 'scene_conditions', 'action_core',
                   'action_family_64', 'scene_executor', 'scene_action_slots')
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2',
                   '-DSCENE_EXECUTOR_TEST_HOOKS', '-I' + str(core / 'src')]
        command += [str(core / 'src' / (module + '.c')) for module in modules]
        command += [str(PROJECT / 'tests/scene_action_view_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError('Action-view compilation failed:\n' + (result.stdout + result.stderr)[:4000])
        cls.paths = [build / name for name in ('source-a.scen', 'source-b.scen')]
        cls.paths[0].write_bytes(scene('ViewA', [
            action('a0', 0x4d, bytes((0, 1)) + word(11), 0),
            action('a1', 0x95, bytes((70, 2, 3)), 1),
            action('a2', 0x4d, bytes((1, 1)) + word(22), 2),
        ]))
        cls.paths[1].write_bytes(scene('ViewB', [
            action('b0', 0x95, bytes((90, 1, 0)), 0),
            action('b1', 0x4d, bytes((2, 1)) + word(33), 1),
        ]))
        print('SCENE_ACTION_VIEW_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest() + ' core=' + str(core))

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name, *(str(path) for path in self.paths)],
                                capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS scene_action_view ' + name)

    def test_reordered_compacted_metadata_and_nested_flattened_provenance(self):
        self.check_case('nested')

    def test_explicit_holes_and_invalid_view_requests_preserve_sources(self):
        self.check_case('holes')

    def test_compact_executor_retains_original_origin_and_tree_after_view_close(self):
        self.check_case('executor')


if __name__ == '__main__':
    unittest.main()
