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

    def test_actual_app_update_uses_one_sticky_persistent_session_boundary(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'session.log'
            result = subprocess.run([str(self.executable), '--inspect-session-boundary',
                                     '--game-dir', str(self.game), '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stderr)
            contents = log.read_text()
            self.assertIn('scene_session_created scene=0 generation=1 ui_phone_rows=12', contents)
            self.assertIn('caption_runtime_initialized fonts=18 tbox=98 sctb=768 task=1867 view_bytes=48 view_origin=10,10 format=RGB555 caption_surface=623x201/250446 framed_surface=578x1001/1157156 saved_surface=Frame', contents)
            self.assertIn('autotext_entries=1258', contents)
            self.assertIn('clock=world-clock-normal+timer-records post-clock-gates=guarded pointer_transform=unverified caption_writer=bound-RGB555 caption_transfer=bound-RGB555-Frame-plus-decoded-background audio_provider=live-audio', contents)
            self.assertNotIn('scene_session_blocked', contents)
            self.assertIn('scene_clock_tick ', contents)
            self.assertIn('scene_session_media_eos frame=0', contents)
            self.assertIn('caption_action_lookup result=found key_bytes=6 text_bytes=185 raw_bytes=185', contents)
            self.assertIn('live_audio loaded stem=NSHT01 channel=13 frames=494792', contents)
            self.assertIn('scene_action_sound row=31 phase=0 kernel_status=0 captions=1 dispatch_argument=1 boundary=kernel', contents)
            self.assertIn('scene_action_sound row=31 phase=1 kernel_status=0 captions=1 dispatch_argument=1 boundary=kernel', contents)
            self.assertIn('caption_action_writer kind=1 bytes=185 status=0', contents)
            self.assertIn('label=CUITaskBar::RestoreCCTextBox', contents)
            self.assertIn('label=RenderMainDisplay() ZRENDER layer 10', contents)
            self.assertIn('caption_composition_pixels tick=1 attempts=2 successes=2 cc_rect=10,392,629,417 frame_equal=12687 frame_different=3433 caption_non_key=3433', contents)
            self.assertEqual(contents.count('caption_composition_pixels tick='), 2)
            self.assertEqual(contents.count('caption_transfer_applied tick=1'), 2)
            self.assertIn('scene_session_probe status=0 provider=none tick_index=2 tick_count=2 generation=1 media_attempted=1 dispatch_attempted=1 same_path=app-update', contents)
            self.assertIn('stopped failure=0', contents)


class NativeCaptionTransferTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        source = WORKSPACE / 'work/analysis/game-source.json'
        if not source.is_file():
            raise unittest.SkipTest('Supply the original GOG game descriptor')
        cls.game = Path(json.loads(source.read_text())['game_dir'])
        if not (cls.game / 'Game.ini').is_file():
            raise unittest.SkipTest('Original game files unavailable')
        build = subprocess.run([str(PROJECT / 'scripts/build_native_app.sh'),
                                '--test-hooks'],
                               capture_output=True, text=True)
        if build.returncode:
            raise RuntimeError(build.stdout + build.stderr)
        cls.executable = PROJECT / 'Blackmoor Reconstruction Test.app/Contents/MacOS/BlackmoorNative'

    def run_session_probe(self, *extra_args):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'caption.log'
        result = subprocess.run([
            str(self.executable), '--inspect-session-boundary',
            '--game-dir', str(self.game), '--log', str(log), *extra_args
        ], capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stderr)
        return log.read_text()

    def test_synthetic_accepted_click_completes_s5900_row_7_and_stops_at_a28(self):
        # Stand-in for the RT-2 pointer path: one synthetic accepted event.
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'synthetic.log'
        result = subprocess.run([str(self.executable), '--inspect-live-session',
                                 '--live-click-row', '34', '--test-a62-accept',
                                 '--game-dir', str(self.game), '--log', str(log)],
                                capture_output=True, text=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stderr)
        contents = log.read_text()
        self.assertIn('test_a62_synthetic_accept result=phase2 row=7 coordinates=5,5 '
                      'pointer_path=not-implemented(RT-2)', contents)
        # Row 7 completes (event 1000 opens rows 8-10); row 8 (0x28) is the
        # next explicit blocker, before any scene change to S4700.
        self.assertIn('scene_session_blocked stage=3 provider=action-family-28 '
                      'action=8 type=0x28', contents)
        self.assertIn('live_session_end scene=5900', contents)
        self.assertNotIn('target=5907', contents)

    def test_failed_layer_transfer_retains_applied_restore_prefix(self):
        contents = self.run_session_probe('--test-caption-fail-blit', '2')
        self.assertIn('caption_transfer_applied tick=1 attempt=1 success=1 kind=1', contents)
        self.assertIn('caption_transfer_test_injected_failure attempt=2', contents)
        self.assertIn('caption_transfer_failed tick=1 attempt=2 successes=1 kind=2', contents)
        self.assertIn('label=RenderMainDisplay() ZRENDER layer 10', contents)
        self.assertIn('caption_composition_blocked lifecycle_status=', contents)
        self.assertIn('partial_backbuffer_prefix_preserved=1 retry=disabled', contents)
        self.assertIn('caption_composition_pixels tick=1 attempts=2 successes=1 '
                      'cc_rect=10,392,629,417 frame_equal=16120 frame_different=0', contents)
        self.assertIn('caption_non_key=3433', contents)
        self.assertNotIn('caption_transfer_applied tick=1 attempt=3', contents)

    def test_injected_scene_reset_restores_taskbar_area_and_keeps_owners(self):
        contents = self.run_session_probe('--test-caption-reset-after-compose')
        self.assertIn('caption_transfer_applied tick=1 attempt=1 success=1', contents)
        self.assertIn('caption_transfer_applied tick=1 attempt=2 success=2', contents)
        self.assertIn('label=CUITaskBar::RestoreTaskbarArea()', contents)
        self.assertIn('caption_injected_reset_probe injected=1 actual_scene_replacement=0 '
                      'reset_api=caption_scene_reset reset=0 flags=0 draw=0 owners_stable=1 '
                      'flags_reset=1 area_frame_matches=60800/60800', contents)
        self.assertIn('order=RestoreCCTextBox,caption-layer,scene-reset-RestoreTaskbarArea,post-reset-layers', contents)
        self.assertIn('caption_composition_pixels tick=1 attempts=3 successes=3 '
                      'cc_rect=10,392,629,417 frame_equal=16120 frame_different=0', contents)
        self.assertIn('caption_layer=0 reset_layer=0', contents)

    def test_reseeded_current_scene_frame_retains_active_caption_pixels(self):
        contents = self.run_session_probe('--test-caption-reseed-visible')
        self.assertIn('caption_reseed_probe provider=seed-current-Frame-and-decoded-background '
                      'second_scene_session_tick=0 seeds=2->3 flags=0 draw=0 '
                      'caption_retained=1 pixels_retained=1', contents)
        self.assertIn('frame_different=3433 caption_non_key=3433', contents)
        self.assertIn('owner_stable=1', contents)
        self.assertIn('caption_transfer_applied tick=1 attempt=3 success=3', contents)

    def test_missing_configuration_fails_without_gameplay_success(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'startup.log'
            result = subprocess.run([str(self.executable), '--inspect-startup',
                                     '--game-dir', directory, '--log', str(log)],
                                    capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 1)
            contents = log.read_text()
            self.assertIn('Cannot read original game configuration', contents)
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

    def run_live(self, *extra_args, allowed_codes=(0,)):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'live.log'
        result = subprocess.run([str(self.executable), '--inspect-live-session',
                                 '--live-click-row', '34', *extra_args,
                                 '--game-dir', str(self.game), '--log', str(log)],
                                capture_output=True, text=True, timeout=120)
        self.assertIn(result.returncode, allowed_codes, result.stderr)
        return log.read_text()

    def test_live_session_runs_s5900_through_a62_a51_and_the_timer_into_s5907(self):
        # RT-4: the dependency leaves are wired, so the run no longer stops at
        # opcode 17; it ends when Open_A completes and its action-sound row
        # asks for a scene transition the app does not yet apply (exit code 1).
        contents = self.run_live(allowed_codes=(1,))
        ordered = ('scene_conditions_binding status=0 rand=msvc-crt-lcg',
                   'live_audio loaded stem=NSHT01 channel=13',
                   'live_session_hover row=34 rect=388,225,492,284',
                   'live_session_click row=34',
                   'scene_parsed name=S5900',
                   'scene_transition_applied source=0 target=5900 generation=2',
                   # Row 7 (0x62): selector from the scene-change frame word,
                   # then the phase-0 start flag store at 0x42eb04.
                   'scene_a62_selector scene=5900 value=0 source=scene-change-frame-word',
                   'scene_a62_start_flag DAT_005bb1ca=1 writer=0x42eb04',
                   # Row 11 (0x51): AUTOTEXT key CURL00 into the frame text box.
                   'scene_a51_open_frame_text mode=2 bytes=6 status=0 detail=ok',
                   # Rows 12/14 (0x9f) start their sounds; row 13 follows the
                   # timer-5 gate into S5907.
                   'live_audio loaded stem=carstart channel=4',
                   'live_audio loaded stem=Traffic channel=9',
                   'scene_session_transition_pending source=5900 target=5907',
                   'scene_parsed name=S5907',
                   'scene_transition_applied source=5900 target=5907 generation=3',
                   'scene_a62_selector scene=5907 value=0',
                   'scene_a51_open_frame_text mode=2 bytes=51 status=0 detail=ok',
                   'live_audio loaded stem=Open_A channel=13',
                   'live_session_scene_changed from=5900 to=5907',
                   # New stop: S5907 row 5 (0x9f Open_A) completes and its phase-2
                   # step carries a scene transition (effect.has_transition).
                   'scene_action_sound row=5 phase=2',
                   'scene_session_error status=5',
                   'scene_conditions_stats leaves=',
                   'live_session_end scene=5907 ticks=')
        position = 0
        for evidence in ordered:
            found = contents.find(evidence, position)
            self.assertNotEqual(found, -1, evidence)
            position = found
        # Wait mode 0: the row opens the frame text box once and never completes.
        # Closing the box on scene replacement (original 0x4381f4/0x43dbe3 call
        # 0x4de2d8 on 0x61f864) is NOT modelled yet; this test deliberately does
        # not pin that gap.
        self.assertEqual(contents.count('scene_a51_open_frame_text mode=2 bytes=6 '), 1)
        self.assertNotIn('provider=action-family-62', contents)
        # Row 6 (opcode 17, channel 4 idle) was queried once per tick while
        # carstart plays; the gate never reports an unavailable provider.
        self.assertIn('status=5 provider=action-sound stage=3 action=5 type=0x9f detail=2',
                      contents.split('live_session_end ', 1)[1])
        self.assertNotIn('provider=dependency-provider', contents)
        self.assertNotIn('scene_session_dependency_failure', contents)
        queries = int(contents.split('scene_conditions_stats ', 1)[1]
                      .split('sound_queries=', 1)[1].split()[0])
        self.assertGreater(queries, 20)
        self.assertIn('sound_manager_error=0x3e8', contents)

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
                             'scene_inspect transition_current_frame=owned-decoded-background width=620 height=375 frame=0 bytes=930000 composition=not-included',
                             'scene_parsed name=S5900',
                             'background=OPEN_A',
                             'scene_a28_prefix row=0 type=0x64 subtype=1 payload_kind=1 body_bytes=5 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=1 type=0x82 subtype=1 payload_kind=1 body_bytes=41 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=2 type=0x82 subtype=1 payload_kind=1 body_bytes=41 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=3 type=0x82 subtype=1 payload_kind=1 body_bytes=41 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=4 type=0x1d subtype=1 payload_kind=1 body_bytes=8 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=5 type=0x1d subtype=1 payload_kind=1 body_bytes=8 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=6 type=0x1d subtype=1 payload_kind=1 body_bytes=8 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_prefix row=7 type=0x62 subtype=1 payload_kind=3 body_bytes=30 dependency_records=0 dispatch=not-run-by-handoff-inspector',
                             'scene_a28_entry_gate action=8 subtype=1 dependency=0 event_flag_1000=0 clock_minutes=1080 visit_span_count=10001 status=pre-dispatch-snapshot-only',
                             'scene_a28_capture_pair current_scene=0 current_frame=0 target_scene=5900 target_frame=0 source_view=0,0,619,374 target_view=10,10,629,384 crop=0,0 canvas=620x375 capture_bytes_each=2790000 scope=decoded-background-only original-composed-framebuffer=not-represented',
                             'scene_a28_execution=not-run reason=successor-scene-dispatch-not-integrated gate=not-evaluated-after-prefix entry_gate_known=1 entry_gate=0',
                             'incomplete_game=1',
                             'stopped failure=0'):
                self.assertIn(evidence, contents)
            self.assertLess(contents.index('audio_completed'), contents.index('transition_target'))
            self.assertLess(contents.index('transition_current_frame'),
                            contents.index('scene_a28_capture_pair'))
            self.assertLess(contents.index('scene_parsed name=S5900'),
                            contents.index('scene_a28_capture_pair'))
            self.assertLess(contents.index('scene_a28_prefix row=7'),
                            contents.index('scene_a28_entry_gate'))
            self.assertLess(contents.index('scene_a28_entry_gate'),
                            contents.index('scene_a28_capture_pair'))

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
