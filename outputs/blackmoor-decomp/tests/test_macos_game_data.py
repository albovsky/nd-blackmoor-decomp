"""Finite Foundation-only startup data tests: synthetic files, no game/GUI/audio."""
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

HERE=Path(__file__).resolve().parent
START=Path(os.environ.get('BLACKMOOR_REPOSITORY',Path.cwd())).resolve()
ROOT=next((p for p in(START,*START.parents,HERE,*HERE.parents)
           if(p/'outputs/blackmoor-decomp/recomp/macos_recomp.mm').is_file()),None)
HELPERS=Path(os.environ.get('BLACKMOOR_GAME_DATA_HELPER_DIR',ROOT/'outputs/blackmoor-decomp/recomp'if ROOT else HERE))

class GameDataTests(unittest.TestCase):
    binary=None
    @classmethod
    def prepare(cls):
        if cls.binary:return cls.binary
        output=Path(tempfile.mkdtemp(prefix='blackmoor-data-check-'))
        fixture=HERE/'macos_game_data_fixture.mm';source=HELPERS/'macos_game_data.mm';header=HELPERS/'macos_game_data.h'
        command=shlex.split(os.environ.get('CXX','xcrun --sdk macosx clang++'))+[
            '-std=c++17','-fobjc-arc','-Wall','-Wextra','-O1','-I'+str(HELPERS),
            str(fixture),str(source),'-framework','Foundation','-o',str(output/'fixture')]
        pins={str(p):hashlib.sha256(p.read_bytes()).hexdigest()for p in(fixture,source,header)}
        built=subprocess.run(command,capture_output=True,text=True,timeout=60)
        (output/'build.log').write_text(built.stdout+built.stderr)
        (output/'build-receipt.json').write_text(json.dumps({'command':command,'returncode':built.returncode,'inputs':pins,
          'game_GUI_audio_devices':False},indent=2)+'\n')
        if built.returncode:raise AssertionError(built.stdout+built.stderr)
        cls.binary=output/'fixture';return cls.binary
    def run_mode(self,mode):
        self.assertTrue((HELPERS/'macos_game_data.mm').is_file(),'Missing default-data helper: current startup selects original GOG path')
        result=subprocess.run([str(self.prepare()),mode],capture_output=True,text=True,timeout=30)
        (self.binary.parent/(mode+'.log')).write_text(result.stdout+result.stderr)
        print(result.stdout,end='')
        self.assertEqual(result.returncode,0,result.stdout+result.stderr)
        self.assertIn('failures=0',result.stdout)
    def test_default_copy_and_reuse_preserve_source_and_do_not_import_saves(self):self.run_mode('default')
    def test_explicit_arg_env_precedence_stays_in_place(self):self.run_mode('explicit')
    def test_wrong_source_and_incomplete_cache_fail_closed(self):self.run_mode('wrong-incomplete')
    def test_wrong_completed_cache_is_not_silently_replaced(self):self.run_mode('tamper')
    def test_aliases_symlinks_and_copy_failure_never_touch_original(self):self.run_mode('aliases-failure')
    def test_competing_publication_reuses_only_completed_winner(self):self.run_mode('competing')
    def test_folder_validation_messages_and_remembered_known_priority(self):self.run_mode('validation')
    def test_resolved_executable_hash_is_verified_on_every_route(self):self.run_mode('executable')
    def test_unwritable_save_directories_are_refused_with_their_path(self):self.run_mode('save-dir')


class StartupProtectionTests(unittest.TestCase):
    """Clearing a conflicting remembered seed must never admit cached startup."""
    @classmethod
    def setUpClass(cls):
        parent = os.environ.get('BLACKMOOR_GAME_DATA_STARTUP_EVIDENCE')
        cls.output = Path(tempfile.mkdtemp(prefix='startup-protection-', dir=parent))
        cls.binary = cls.output / 'fixture'
        fixture = HERE / 'macos_startup_protection_fixture.mm'
        inputs = [Path(__file__), fixture, HELPERS / 'macos_recomp.mm',
                  HELPERS / 'macos_game_data.mm', HELPERS / 'macos_game_data.h',
                  HELPERS / 'audio_capture.cpp', HELPERS / 'audio_capture.h']
        command = shlex.split(os.environ.get('CXX', 'xcrun --sdk macosx clang++')) + [
            '-std=c++17', '-fobjc-arc', '-O1', '-ffunction-sections', '-fdata-sections',
            '-I' + str(HELPERS), '-I' + str(ROOT / 'outputs/blackmoor-decomp/src'),
            str(fixture), str(HELPERS / 'macos_game_data.mm'), str(HELPERS / 'audio_capture.cpp'),
            '-framework', 'Foundation', '-framework', 'AppKit', '-framework', 'AVFAudio',
            '-Wl,-dead_strip', '-o', str(cls.binary)]
        build = subprocess.run(command, capture_output=True, text=True, timeout=60)
        (cls.output / 'build.log').write_text(build.stdout + build.stderr)
        receipt = {'command': command, 'returncode': build.returncode,
                   'inputs_sha256': {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs},
                   'real_preferences_guest_GUI_audio': False}
        if build.returncode == 0:
            receipt['native_sha256'] = hashlib.sha256(cls.binary.read_bytes()).hexdigest()
        (cls.output / 'build-receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
        if build.returncode:
            raise AssertionError(build.stdout + build.stderr)
        print('STARTUP_PROTECTION private_output=' + str(cls.output))

    @staticmethod
    def inventory(root):
        return {str(path.relative_to(root)): (path.stat().st_mode,
                    hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None)
                for path in [root, *sorted(root.rglob('*'))]}

    def run_startup(self, mode):
        root = self.output / mode
        original = root / 'owned-parent/custom-original'
        for directory in ('Ciftree', 'CDSound', 'CDVideo'):
            (original / directory).mkdir(parents=True, exist_ok=True)
        for name, value in {'GAME.EXE': b'abc', 'Game.ini': b'original=1\n',
                            'Ciftree/CIFTREE.DAT': b'archive', 'CDVideo/movie.bin': b'movie'}.items():
            (original / name).write_bytes(value)
        before = self.inventory(original)
        remembered = root / 'missing-original' if mode == 'stale' else original
        saves = {'nested': original / 'new-saves', 'ancestor': original.parent}.get(mode, root / 'safe-saves')
        command = [str(self.binary), '--mute', '--background', str(root), str(original), str(remembered), str(saves)]
        environment = dict(os.environ)
        for key in ('BLACKMOOR_GAME_DIR', 'GAME_EXE'):
            environment.pop(key, None)
        result = subprocess.run(command, env=environment, capture_output=True, text=True, timeout=30)
        (root / 'run.log').write_text(result.stdout + result.stderr)
        (root / 'run-receipt.json').write_text(json.dumps({'command': command, 'returncode': result.returncode}, indent=2) + '\n')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        observation = json.loads(result.stdout)
        (root / 'observation.json').write_text(json.dumps(observation, indent=2) + '\n')
        self.assertEqual(self.inventory(original), before, 'startup modified the remembered original')
        self.assertTrue(observation['cache_created'])
        self.assertTrue(observation['remembered_retained'], result.stderr)
        self.assertEqual(observation['preference_removals'], 0)
        self.assertFalse(observation['real_guest_GUI_audio'])
        return observation, result.stderr, saves

    def assert_overlap_refused(self, mode):
        observation, error, saves = self.run_startup(mode)
        self.assertEqual(observation['application_return'], 2, error)
        self.assertEqual(observation['selection_calls'], 0)
        self.assertEqual(observation['gate_calls'], 0)
        self.assertEqual(observation['guest_boundaries'], 0)
        self.assertIn('GAME_DATA: ', error)
        self.assertIn('overlap', error.lower())
        self.assertIn(str(saves), error)
        self.assertIn(str(self.output / mode / 'owned-parent/custom-original'), error)
        if mode == 'nested':
            self.assertFalse(saves.exists(), 'refusal created a save directory inside the original')

    def test_remembered_original_refuses_nested_save_before_cached_selection(self):
        self.assert_overlap_refused('nested')

    def test_remembered_original_refuses_ancestor_save_before_cached_selection(self):
        self.assert_overlap_refused('ancestor')

    def assert_cache_reused(self, mode):
        observation, error, saves = self.run_startup(mode)
        self.assertEqual(observation['application_return'], -1, error)
        self.assertEqual(observation['selection_calls'], 1)
        self.assertEqual(observation['gate_calls'], 1)
        self.assertEqual(observation['guest_boundaries'], 1)
        self.assertEqual(observation['selected_directory'], observation['cache_directory'])
        self.assertTrue(saves.is_dir())

    def test_safe_save_reuses_completed_cache_and_reaches_guest_boundary(self):
        self.assert_cache_reused('safe')

    def test_missing_remembered_source_still_reuses_completed_cache(self):
        self.assert_cache_reused('stale')

if __name__=='__main__':unittest.main()
