"""Exercise credentialed packaging transitions with fake external signing services.

Bundle closure and real DMG construction are covered by test_macos_package. These
tests never use a keychain, credentials, network, original game or GUI.
"""
import json
import io
import os
from contextlib import redirect_stdout
from pathlib import Path
import plistlib
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from test_macos_package import bundle


class SigningWorkflowTests(unittest.TestCase):
    identity = 'A' * 40
    name = 'Developer ID Application: Packaging Fixture (ABCDE12345)'

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.stage = self.root / 'stage.app'
        (self.stage / 'Contents/MacOS').mkdir(parents=True)
        (self.stage / 'Contents/Frameworks').mkdir()
        (self.stage / 'Contents/MacOS/BlackmoorRecompiled').write_text('test executable')
        (self.stage / 'Contents/Frameworks/libavutil.61.dylib').write_bytes(bundle.MACHO_MAGICS[0])
        (self.stage / 'Contents/Info.plist').write_bytes(plistlib.dumps({
            'CFBundleExecutable': 'BlackmoorRecompiled', 'CFBundleVersion': 'test'}))
        self.out = self.root / 'out'
        self.out.mkdir()
        self.calls = []
        self.notary_status = 'Accepted'
        self.signature_runtime = True
        self.assessment_code = 0

    def fake_run(self, args, **kwargs):
        args = list(map(str, args))
        self.calls.append(args)
        stdout = ''
        stderr = ''
        code = 0
        if args[0] == 'security':
            stdout = f'  1) {self.identity} "{self.name}"\n  2) {"B" * 40} "Apple Development: Fixture (OTHER12345)"\n     2 valid identities found\n'
        elif args[0] == 'ditto':
            if '-c' in args:
                Path(args[-1]).write_text('test zip')
            else:
                shutil.copytree(args[-2], args[-1])
        elif args[0] == 'codesign' and '--display' in args:
            flags = 'flags=0x10000(runtime)' if self.signature_runtime else 'flags=0x0(none)'
            stderr = f'{flags}\nAuthority={self.name}\nTeamIdentifier=ABCDE12345\n'
        elif args[:3] == ['xcrun', 'notarytool', 'submit']:
            stdout = json.dumps({'status': self.notary_status, 'id': 'fake-submission'})
        elif args[:2] == ['hdiutil', 'create']:
            Path(args[-1]).write_text('test DMG')
        elif args[0] == 'spctl':
            code = self.assessment_code
        return subprocess.CompletedProcess(args, code, stdout, stderr)

    def run_package(self):
        arguments = bundle.build_parser().parse_args([
            'package', '--app', str(self.stage), '--out-dir', str(self.out),
            '--ffmpeg-prefix', str(self.root)])
        with patch.dict(os.environ, BLACKMOOR_SIGN_IDENTITY=self.identity, BLACKMOOR_NOTARY_PROFILE='fixture-profile'), \
             patch.object(bundle, 'run', side_effect=self.fake_run), \
             patch.object(bundle, 'bundle_dependencies', return_value=['libavutil.61.dylib']), \
             patch.object(bundle, 'copy_ffmpeg_licenses'), \
             patch.object(bundle, 'verify_bundle', return_value=[]), \
             patch.object(bundle, 'attach_and_verify_dmg', return_value=[]), \
             patch.object(bundle, 'load_ffmpeg_record', return_value={'version': 'fixture'}), \
             redirect_stdout(io.StringIO()):
            return bundle.package_command(arguments)

    def test_only_exact_developer_id_names_or_hashes_are_accepted(self):
        with patch.object(bundle, 'run', side_effect=self.fake_run):
            for good in (self.identity, self.identity.lower(), self.name):
                self.assertTrue(bundle.sign_identity_available(good))
            for wrong in ('valid', 'ABCDE12345', 'Apple Development: Fixture (OTHER12345)', 'B' * 40):
                self.assertFalse(bundle.sign_identity_available(wrong), wrong)

    def test_accepted_app_and_dmg_are_stapled_in_order_after_inside_out_signing(self):
        self.assertEqual(self.run_package(), 0)
        manifest = json.loads((self.out / 'package-manifest.json').read_text())
        self.assertTrue(manifest['notarized'] and manifest['hardened_runtime'])
        signs = [a for a in self.calls if a[0] == 'codesign' and '--sign' in a]
        self.assertTrue(signs[0][-1].endswith('.dylib'))
        self.assertIn('/Contents/MacOS/', signs[1][-1])
        self.assertTrue(signs[2][-1].endswith('.app'))
        for args in signs[:3]:
            self.assertIn('runtime', args)
            self.assertNotIn('--entitlements', args)
        steps = [a for a in self.calls if a[:3] == ['xcrun', 'notarytool', 'submit']
                 or a[:3] == ['xcrun', 'stapler', 'staple'] or a[:3] == ['xcrun', 'stapler', 'validate']]
        self.assertEqual([a[2] for a in steps], ['submit', 'staple', 'validate', 'submit', 'staple', 'validate'])
        self.assertTrue(steps[0][3].endswith('.zip'))
        self.assertTrue(steps[3][3].endswith('.dmg'))
        self.assertTrue(all('--wait' in a for a in (steps[0], steps[3])))

    def test_invalid_notary_status_never_staples_or_makes_a_dmg(self):
        self.notary_status = 'Invalid'
        with self.assertRaisesRegex(bundle.BundleError, 'Invalid'):
            self.run_package()
        self.assertFalse(any(a[:3] == ['xcrun', 'stapler', 'staple'] for a in self.calls))
        self.assertFalse(list(self.out.glob('*.dmg')))
        self.assertFalse((self.out / 'package-manifest.json').exists())

    def test_missing_runtime_signature_prevents_any_notary_upload(self):
        self.signature_runtime = False
        with self.assertRaisesRegex(bundle.BundleError, 'hardened runtime'):
            self.run_package()
        self.assertFalse(any(a[:3] == ['xcrun', 'notarytool', 'submit'] for a in self.calls))

    def test_gatekeeper_rejection_never_reports_a_completed_notarized_package(self):
        self.assessment_code = 3
        with self.assertRaisesRegex(bundle.BundleError, 'Gatekeeper'):
            self.run_package()
        self.assertFalse((self.out / 'package-manifest.json').exists())

    def test_toolchain_fingerprint_is_required_for_cache_reuse(self):
        directory = self.root / bundle.FFMPEG_PREFIX_LICENSE_SUBDIR
        directory.mkdir(parents=True)
        record = {'source_sha256': 'source', 'configure_command': 'configure'}
        path = directory / 'BUILD-INFO.json'
        args = bundle.build_parser().parse_args(['ffmpeg-stamp-matches', '--prefix', str(self.root),
            '--sha256', 'source', '--configure', 'configure', '--build-fingerprint', 'sdk-one'])
        path.write_text(json.dumps(record))
        self.assertEqual(bundle.ffmpeg_stamp_matches(args), 1)
        record['build_fingerprint'] = 'sdk-one'
        path.write_text(json.dumps(record))
        self.assertEqual(bundle.ffmpeg_stamp_matches(args), 0)
        args.build_fingerprint = 'sdk-two'
        self.assertEqual(bundle.ffmpeg_stamp_matches(args), 1)
