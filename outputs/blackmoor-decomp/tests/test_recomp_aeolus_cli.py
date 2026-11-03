import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

TOOLS=Path(__file__).resolve().parents[1]/'recomp/route_tools'


class AeolusCliTests(unittest.TestCase):
    def module(self):
        source=TOOLS/'aeolus_live.py'
        self.assertTrue('def argument_parser(' in source.read_text(),'missing public caller-path CLI')
        sys.path.insert(0,str(TOOLS))
        try:
            spec=importlib.util.spec_from_file_location('aeolus_cli_candidate',source)
            module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
            return module
        finally:sys.path.remove(str(TOOLS))

    def fixture(self,module):
        _,one,zero=module.check_route.alchemy_win_configuration()
        _,lab_one,lab_zero=module.check_route.lab_mould_configuration('mould-shape')
        flags={str(f):int(f in one|lab_one)for f in one|zero|lab_one|lab_zero}
        inv=[0]*40;inv[10]=1
        profile={'source_sha256':'a'*64,'state':[3803,3803,0,13],'difficulty':0,
                 'flags':flags,'inventory40':inv,'clock':{'day':3,'hour':16,'minute':47},
                 'logged_fixed_one':sorted(lab_one),'logged_source_zero':sorted(lab_zero),
                 'win_flags':[1098,1099,1100,1101,1959,2052]}
        manifest={'version':'aeolus-profile-v1','native_sha256':'b'*64,
                  'game_exe_sha256':module.io.ORIGINAL_SHA256,'source_sha256':'a'*64,
                  'atlas_sha256':'c'*64,'profile':profile,
                  'seed_pins':{key:'d'*64 for key in ('GAME.EXE','Game.ini','Ciftree/CIFTREE.DAT','Ciftree/s3876.CIF')}}
        manifest['seed_pins']['GAME.EXE']=module.io.ORIGINAL_SHA256
        args=SimpleNamespace(native_sha256='b'*64,game_exe_sha256=module.io.ORIGINAL_SHA256,
                             source_sha256='a'*64,atlas_sha256='c'*64)
        return manifest,args

    def test_cli_requires_paths_and_explicit_hashes(self):
        module=self.module()
        with self.assertRaises(SystemExit),patch('sys.stderr'):
            module.argument_parser().parse_args([])
        actions={a.dest for a in module.argument_parser()._actions}
        self.assertTrue({'native','native_sha256','game_exe','game_exe_sha256','game_data',
                         'source_save','source_sha256','profile_manifest','profile_manifest_sha256',
                         'atlas','atlas_sha256','output'}<=actions)

    def test_profile_manifest_cannot_omit_or_relax_saved_mould_win_or_inventory_contract(self):
        module=self.module();manifest,args=self.fixture(module)
        module.validate_manifest(manifest,args)
        for change in ('empty_flags','old23','missing_scope','wrong_win','missing10','held','nonbinary'):
            bad=copy.deepcopy(manifest);p=bad['profile']
            if change=='empty_flags':p['flags']={}
            elif change=='old23':p['flags']['2163']=0
            elif change=='missing_scope':p['logged_source_zero'].remove(2004)
            elif change=='wrong_win':p['win_flags']=[2052]
            elif change=='missing10':p['inventory40'][10]=0
            elif change=='held':p['state'][3]=-1
            else:p['inventory40'][20]=2
            with self.subTest(change=change),self.assertRaises(ValueError):module.validate_manifest(bad,args)

    def test_explicit_native_source_and_atlas_pins_cannot_be_mixed(self):
        module=self.module();manifest,args=self.fixture(module)
        for field in ('native_sha256','game_exe_sha256','source_sha256','atlas_sha256'):
            bad=copy.deepcopy(manifest);bad[field]='e'*64
            with self.subTest(field=field),self.assertRaises(ValueError):module.validate_manifest(bad,args)
        args.native_sha256=module.io.ORIGINAL_SHA256
        with self.assertRaises(ValueError):module.validate_manifest(manifest,args)

    def test_manifest_hash_and_relative_seed_paths_are_checked(self):
        module=self.module();manifest,args=self.fixture(module)
        with tempfile.TemporaryDirectory() as directory:
            path=Path(directory)/'profile.json';path.write_text(json.dumps(manifest))
            args.profile_manifest=path;args.profile_manifest_sha256=module.sha(path)
            self.assertEqual(module.load_manifest(args),manifest)
            args.profile_manifest_sha256='0'*64
            with self.assertRaises(ValueError):module.load_manifest(args)
        for name in ('../GAME.EXE','/absolute/GAME.EXE'):
            bad=copy.deepcopy(manifest);bad['seed_pins'][name]=bad['seed_pins'].pop('GAME.EXE')
            with self.subTest(name=name),self.assertRaises(ValueError):module.validate_manifest(bad,args)

    def test_new_output_must_preserve_existing_evidence_and_stay_outside_inputs(self):
        module=self.module()
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);source=root/'saves/source.SAV';seed=root/'data';original=root/'original/GAME.EXE'
            source.parent.mkdir();seed.mkdir();original.parent.mkdir()
            existing=root/'prior';existing.mkdir();sentinel=existing/'receipt.json';sentinel.write_text('keep')
            for output in (existing,source.parent/'new',seed/'new',original.parent/'new'):
                with self.subTest(output=output),self.assertRaises(ValueError):
                    module.validate_output(output,source,seed,original)
            module.validate_output(root/'new-run',source,seed,original)
            self.assertEqual(sentinel.read_text(),'keep')

    def test_bad_cli_hash_refuses_before_session_or_output_creation(self):
        module=self.module();manifest,args=self.fixture(module)
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);native=root/'native';native.write_bytes(b'finite fake host data; never executed')
            original=root/'GAME.EXE';original.write_bytes(b'finite fake original data; never executed')
            atlas=root/'atlas.json';atlas.write_text('{}');profile=root/'profile.json';profile.write_text(json.dumps(manifest))
            source=root/'source.SAV';source.write_bytes(b'finite fake source; never loaded');seed=root/'seed';seed.mkdir()
            output=root/'new-output'
            argv=['--native',str(native),'--native-sha256','0'*64,'--game-exe',str(original),
                  '--game-exe-sha256',module.io.ORIGINAL_SHA256,'--game-data',str(seed),
                  '--source-save',str(source),'--source-sha256','a'*64,
                  '--profile-manifest',str(profile),'--profile-manifest-sha256',module.sha(profile),
                  '--atlas',str(atlas),'--atlas-sha256','c'*64,'--output',str(output)]
            with patch.object(module.transport,'Session') as session,patch('sys.stderr'):
                self.assertEqual(module.main(argv),4);session.assert_not_called()
            self.assertFalse(output.exists())

    def test_output_rejects_case_aliases_of_protected_directories(self):
        module=self.module()
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            source=root/'Saves/source.SAV';seed=root/'Data';original=root/'Original/GAME.EXE'
            for protected in (source.parent,seed,original.parent):protected.mkdir()
            alias=root/'data'
            if not alias.exists() or not alias.samefile(seed):
                self.skipTest('filesystem is case-sensitive')
            for name in ('saves','data','original'):
                output=(root/name/'new'/'nested-run').resolve()
                with self.subTest(name=name),self.assertRaises(ValueError):
                    module.validate_output(output,source,seed,original)
                self.assertFalse(output.exists())


if __name__=='__main__':unittest.main()
