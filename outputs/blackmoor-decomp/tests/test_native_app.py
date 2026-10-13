"""Headless integration through original assets, menu request and scene loading.

This does not test macOS UI interaction or claim gameplay equivalence.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parents[1]


class NativeAppIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        source = WORKSPACE / 'work/analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Supply the original GOG game descriptor')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Original game files unavailable')
        build = subprocess.run([str(PROJECT / 'scripts/build_native_app.sh')],
                               capture_output=True, text=True)
        if build.returncode:
            raise RuntimeError(build.stdout + build.stderr)
        cls.executable = PROJECT / 'Blackmoor Reconstruction.app/Contents/MacOS/BlackmoorNative'

    def test_original_assets_menu_request_and_first_scene(self):
        configuration = self.game / 'Game.ini'
        original_hash = hashlib.sha256(configuration.read_bytes()).hexdigest()
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'startup.log'
            result = subprocess.run([str(self.executable), '--inspect-startup',
                                     '--game-dir', str(self.game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stderr)
            contents = log.read_text()
            for evidence in ('BOOT bytes=69442 source=external-CIF',
                             'stage=0 resource=her_logo_splash',
                             'stage=1 resource=LOGO', 'stage=2 resource=MAIN',
                             'headless_input=NewGame', 'command_requested=2',
                             'scene_parsed name=S0', 'actions=38',
                             'scene_frame_decoded width=620 height=375',
                             'scene_preview viewport=10,10,629,384 actions=not-executed audio=absent',
                             'original-Bink-equivalence=unverified',
                             'stopped failure=0'):
                self.assertIn(evidence, contents)
        self.assertEqual(hashlib.sha256(configuration.read_bytes()).hexdigest(), original_hash)

    def test_missing_configuration_fails_without_gameplay_success(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'startup.log'
            result = subprocess.run([str(self.executable), '--inspect-startup',
                                     '--game-dir', directory, '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 1)
            contents = log.read_text()
            self.assertIn('Cannot read original external-CIF configuration', contents)
            self.assertNotIn('scene_parsed', contents)

    def test_corrupt_background_fails_after_new_game_without_preview_success(self):
        with tempfile.TemporaryDirectory() as directory:
            game = Path(directory)
            (game / 'Game.ini').symlink_to(self.game / 'Game.ini')
            (game / 'Ciftree').symlink_to(self.game / 'Ciftree')
            (game / 'CDVideo').mkdir()
            (game / 'CDVideo/diff.bik').write_bytes(b'not a Bink file')
            log = game / 'startup.log'
            result = subprocess.run([str(self.executable), '--inspect-startup',
                                     '--game-dir', str(game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 1)
            contents = log.read_text()
            self.assertIn('command_requested=2', contents)
            self.assertIn('scene_setup_failed', contents)
            self.assertNotIn('scene_preview viewport=', contents)
            self.assertNotIn('stopped failure=0', contents)

    def test_actual_action_kernel_applies_phone_and_controls_then_stops_at_missing_sound(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'actions.log'
            result = subprocess.run([str(self.executable), '--inspect-actions',
                                     '--game-dir', str(self.game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 1)
            contents = log.read_text()
            self.assertIn('action_kernel status=6 failed_index=31 failed_type=0x9f actions_applied=31', contents)
            self.assertIn('action_values_initial shorts=9999 floats=9999', contents)
            self.assertIn('action_ui phone_contacts=2', contents)
            self.assertIn('phone_contact index=0 name=Mrs. Petrov', contents)
            self.assertIn('phone_contact index=1 name=Ned Nickerson', contents)
            for group in (1, 2, 3):
                self.assertIn(f'control_group index={group} first_range=0,0 code=13', contents)
            self.assertIn('control_group index=3 first_range=0,0 code=13 availability=1', contents)
            self.assertIn('seed=analysis-only', contents)
            self.assertNotIn('stopped failure=0', contents)

    def test_scene_fixture_uses_real_caption_audio_and_resource_transition(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'scene-runtime.log'
            result = subprocess.run([str(self.executable), '--inspect-scene-runtime',
                                     '--game-dir', str(self.game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stderr)
            contents = log.read_text()
            for evidence in ('new_game_initialized scene=0 coordinate_words=0,0 source=0 clock=18:00',
                             'scene_video_open width=620 height=375 frames=1 rate=15/1',
                             'mode=0 pacing=native-FFmpeg-timestamps BinkWait-parity=unverified',
                             'clock_minutes=1080 phone_rows=12',
                             'video_start=forward frame=0 pacing=native-timestamp-advancement',
                             'caption=1 bytes=185 terminator=<e>',
                             'destination=diagnostic-recorder renderer=unimplemented',
                             'sound_loaded stem=NSHT01 channel=13 frames=494792',
                             'attenuation_mB=-1035',
                             'audio_completed frames_rendered=',
                             'device=offline completion=DataRendered',
                             'fixture_hotspot=34',
                             'input=hover-then-accepted-primary-release',
                             'transition_target=5900 difficulty=0 phone_rows=12',
                             'scene_parsed name=S5900',
                             'background=OPEN_A', 'incomplete_game=1',
                             'stopped failure=0'):
                self.assertIn(evidence, contents)
            self.assertLess(contents.index('audio_completed'), contents.index('transition_target'))

    def test_scene_fixture_missing_sound_cannot_report_transition_success(self):
        with tempfile.TemporaryDirectory() as directory:
            game = Path(directory)
            for name in ('Game.ini', 'Ciftree', 'CDVideo'):
                (game / name).symlink_to(self.game / name)
            (game / 'CDSound').mkdir()
            log = game / 'scene-runtime.log'
            result = subprocess.run([str(self.executable), '--inspect-scene-runtime',
                                     '--game-dir', str(game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 1, result.stderr)
            contents = log.read_text()
            self.assertIn('scene_inspect executor_error=', contents)
            self.assertNotIn('audio_completed', contents)
            self.assertNotIn('transition_target=', contents)
            self.assertNotIn('scene_parsed name=S5900', contents)
            self.assertIn('stopped failure=1', contents)


if __name__ == '__main__':
    unittest.main()
