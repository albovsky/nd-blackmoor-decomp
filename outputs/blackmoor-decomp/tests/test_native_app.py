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

    def test_synthetic_accepted_click_runs_the_s5900_exit_effect_and_stops_at_s4700(self):
        # Stand-in for the RT-2 pointer path: one synthetic accepted event.
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'synthetic.log'
        result = subprocess.run([str(self.executable), '--inspect-live-session',
                                 '--live-click-row', '34', '--test-a62-accept',
                                 '--game-dir', str(self.game), '--log', str(log)],
                                capture_output=True, text=True, timeout=120)
        # The successor S4700 cannot be created (opaque 0x35 row): an explicit stop.
        self.assertEqual(result.returncode, 1, result.stderr)
        contents = log.read_text()
        ordered = (
            'test_a62_synthetic_accept result=phase2 row=7 coordinates=5,5 '
            'pointer_path=not-implemented(RT-2)',
            # Rows 8-10 run in one pass: row 8 queues the effect (0x44727a), row 10
            # requests the scene change and ends the pass.
            'scene_session_transition_pending source=5900 target=4700',
            'scene_exit_requested state=4 effect_busy=1 effect_type=2 effect_stage=0',
            # State 4 (0x43d227): effect type 2 stage 0 captures the source and
            # hands the loader state over (state 1).
            'scene_exit_capture which=source status=0 canvas=620x375',
            'scene_exit_state4 status=0 controller_ran=1 stage_before=0 effect_busy=1 '
            'effect_type=2 state_after=1',
            'scene_load_state next_state=3 transition_word_5c39ff=1',
            'scene_clear_caption status=0',
            'scene_parsed name=S4700',
            'scene_transition_error source=5900 target=4700 detail=session-replace '
            'status=5 provider=scene-resource action=3 type=0x35 detail_status=6',
            'stopped failure=1')
        position = 0
        for evidence in ordered:
            found = contents.find(evidence, position)
            self.assertNotEqual(found, -1, evidence)
            position = found
        self.assertNotIn('provider=action-family-28', contents)
        self.assertNotIn('scene_exit_sequence', contents)   # the successor never ticked

    def test_exit_effect_continues_into_the_successors_first_tick(self):
        # Test hook: load S5907 (which the executor can create) for the S5900 ->
        # S4700 request so the queued type-2 effect can be followed to its end.
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'redirect.log'
        result = subprocess.run([str(self.executable), '--inspect-live-session',
                                 '--live-click-row', '34', '--test-a62-accept',
                                 '--test-exit-redirect', '4700:5907',
                                 '--game-dir', str(self.game), '--log', str(log)],
                                capture_output=True, text=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stderr)
        contents = log.read_text()
        ordered = (
            'scene_exit_capture which=source status=0',
            'scene_exit_state4 status=0 controller_ran=1 stage_before=0',
            'test_exit_redirect requested=4700 loaded=5907',
            'scene_transition_applied source=5900 target=5907',
            # First successor tick: target capture, then the A-28 frame loop.
            'scene_exit_capture which=destination status=0',
            'scene_exit_sequence type=2 status=0',
            'scene_exit_render_pass status=0 controller_ran=1 stage_before=1 effect_busy=0')
        position = 0
        for evidence in ordered:
            found = contents.find(evidence, position)
            self.assertNotEqual(found, -1, evidence)
            position = found
        self.assertIn('completion=1 x87_cw=0x027f(unverified) curve=non-bit-exact', contents)

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

    def run_live(self, *extra_args, returncode=0):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        log = Path(directory.name) / 'live.log'
        result = subprocess.run([str(self.executable), '--inspect-live-session',
                                 '--live-click-row', '34', *extra_args,
                                 '--game-dir', str(self.game), '--log', str(log)],
                                capture_output=True, text=True, timeout=120)
        self.assertEqual(result.returncode, returncode, result.stderr)
        return log.read_text()

    def test_live_session_runs_s5900_through_a62_a51_and_the_timer_into_s5907(self):
        contents = self.run_live()
        ordered = ('live_audio loaded stem=NSHT01 channel=13',
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
                   'scene_exit_requested state=4 effect_busy=0',
                   'scene_exit_state4 status=0 controller_ran=0 stage_before=0 effect_busy=0',
                   # ClearSceneData (0x43dbe3): the frame text box opened by row 11
                   # is closed (0x4de2d8) and the caption flags are cleared before
                   # the target resource loads.
                   'scene_clear_caption status=0',
                   'scene_parsed name=S5907',
                   'scene_transition_applied source=5900 target=5907 generation=3',
                   'live_session_scene_changed from=5900 to=5907',
                   'scene_a62_selector scene=5907 value=0',
                   'scene_a51_open_frame_text mode=2 bytes=51 status=0 detail=ok',
                   'live_audio loaded stem=Open_A channel=13',
                   # New stop: S5907 row 6 (0x9f) is gated by dependency opcode 17.
                   'scene_session_blocked stage=3 provider=dependency-provider '
                   'action=6 type=0x9f detail=6',
                   'live_session_end scene=5907')
        position = 0
        for evidence in ordered:
            found = contents.find(evidence, position)
            self.assertNotEqual(found, -1, evidence)
            position = found
        # Wait mode 0: the row opens the frame text box once and never completes;
        # the box is then closed by the scene clear.
        self.assertEqual(contents.count('scene_a51_open_frame_text mode=2 bytes=6 '), 1)
        self.assertIn('frame_open=0 caption_visible=0 caption_finish=0 framed_ready=0', contents)
        self.assertIn('scene_clear_latches order=0x5c39ff', contents)
        self.assertNotIn('provider=action-family-62', contents)

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
                             # RT-5: the 0x28 row belongs to the OUTGOING scene (S0 has
                             # none), so no S5900 row is paired with the S0 -> S5900 change.
                             'scene_a28_scan outgoing_scene=0 rows=38 type28_rows=0 successor_scene=5900 pairing=outgoing-row(RT-5)',
                             'scene_a28_handoff=not-applicable no-type-28-row-in-outgoing-scene outgoing_scene=0',
                             'incomplete_game=1',
                             'stopped failure=0'):
                self.assertIn(evidence, contents)
            self.assertLess(contents.index('audio_completed'), contents.index('transition_target'))
            self.assertLess(contents.index('transition_current_frame'),
                            contents.index('scene_a28_scan'))
            self.assertLess(contents.index('scene_parsed name=S5900'),
                            contents.index('scene_a28_scan'))
            self.assertNotIn('scene_a28_capture_pair', contents)
            self.assertNotIn('scene_a28_prefix', contents)

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
