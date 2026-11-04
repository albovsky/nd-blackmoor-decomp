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
    def test_resolved_executable_hash_is_verified_on_every_route(self):self.run_mode('executable')
    def test_unwritable_save_directories_are_refused_with_their_path(self):self.run_mode('save-dir')

if __name__=='__main__':unittest.main()
