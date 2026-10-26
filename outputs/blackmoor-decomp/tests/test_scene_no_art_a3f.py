"""Staged A3f ownership via valid synthetic metadata; no assets or output devices.

The retained-arena case checks the provider's supplied-plan contract. Canonical
NO_ART policy retires all runtime 3f/3e, covered separately. Public image and
lifecycle queries establish ownership behavior; no allocator frees are hooked.
"""
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


def name(value):
    return value.encode('ascii').ljust(33, b'\0')


def sound_body(stem, key='KEY'):
    return name(stem) + word(85) + name(key) + bytes((20, 20, 0)) + word(9999) + word(0) + word(0) + word(0)


def cel_body():
    return (name('cel_header') + name('layerA') + name('') + word(1) + name('cel_sound') +
            word(85) + name('KEY') + bytes((20, 20, 0)) + word(9999) + word(0) + word(0) + word(0))


def action(kind, body):
    return b'synthetic'.ljust(48, b'\0') + bytes((kind, 1)) + body


def chunk(kind, body):
    return kind + len(body).to_bytes(4, 'big') + body + (b'\0' if len(body) & 1 else b'')


def scene(actions):
    summary = bytearray(126)
    summary[:8] = b'A3fTest\0'
    summary[50:63] = b'NO_ART_SCENE\0'
    summary[83:92] = b'NO SOUND\0'
    payload = b'SCEN' + chunk(b'TSUM', bytes(summary))
    payload += b''.join(chunk(b'ACT\0', item) for item in actions)
    return b'DATA' + len(payload).to_bytes(4, 'big') + payload


class SceneNoArtA3fTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-no-art-a3f-')
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        cls.executable = build / 'scene-no-art-a3f'
        core = Path(os.environ.get('BLACKMOOR_SCENE_NO_ART_CORE_PROJECT', PROJECT)).resolve()
        modules = ('hiff', 'scene_resource', 'action_family_3f', 'action_family_3e',
                   'action_family_3f_runtime', 'session_bindings_a3f', 'scene_action_slots')
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror',
                   '-O2', '-I' + str(core / 'src')]
        command += [str(core / 'src' / (module + '.c')) for module in modules]
        command += [str(PROJECT / 'tests/scene_no_art_a3f_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError('A3f no-art compilation failed:\n' + (result.stdout + result.stderr)[:4000])
        cls.paths = [build / name for name in ('source.scen', 'incoming.scen', 'long.scen', 'cel.scen')]
        cls.paths[0].write_bytes(scene([action(0x3f, sound_body('sourceA')),
                                      action(0x4d, bytes((0, 1)) + word(7)),
                                      action(0x3f, sound_body('sourceB'))]))
        cls.paths[1].write_bytes(scene([action(0x3f, sound_body('newA'))]))
        cls.paths[2].write_bytes(scene([action(0x3f, sound_body('newA')),
                                      action(0x3f, sound_body('newB', 'LONG'))]))
        cls.paths[3].write_bytes(scene([action(0x3e, cel_body())]))
        print('SCENE_NO_ART_A3F_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest() + ' core=' + str(core))

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name, *(str(path) for path in self.paths)],
                                capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS scene_no_art_a3f ' + name)

    def test_provider_plan_contract_keeps_surviving_arena_manager_and_world(self):
        self.check_case('retained')

    def test_canonical_retirement_handles_incomplete_and_already_released_rows(self):
        self.check_case('retired')

    def test_failed_discarded_and_stale_preparation_leave_live_ownership_intact(self):
        self.check_case('inert')

    def test_active_cel_retirement_refuses_before_mutation_and_normal_cleanup_runs(self):
        self.check_case('cel')


    def test_busy_sound_conversation_retirement_refuses_before_construction(self):
        self.check_case('busy')


if __name__ == '__main__':
    unittest.main()
