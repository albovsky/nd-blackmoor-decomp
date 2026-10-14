"""RT-5: scene-exit state machine, effect controller and ClearSceneData blocks.

Expected values come from the disassembly of GAME.EXE (addresses in the
comments); the original-x86 oracle in session_exit_original_oracle.py compares
the same routines against the unmodified original code.
"""

from __future__ import annotations

import ctypes as c
import struct
import unittest

import test_action_family_28_sequence as seq
import test_caption_layout as layout
import test_caption_lifecycle as life_tests
import session_exit_support as s
from session_exit_support import (
    BOUNDARY_CAPTURE_DESTINATION, BOUNDARY_CAPTURE_SOURCE, BOUNDARY_NESTED,
    BOUNDARY_RUN_SEQUENCE, CAPTURE_DESTINATION, CAPTURE_SOURCE, ERR_HOST,
    ERR_UNSUPPORTED, OK, STATE_EXIT, STATE_INTRO, STATE_LOAD, STATE_RUN,
    RecordingHost, StepInfo, new_exit)

SEQ_2_FRAMES = [("seq", "tick", 0), ("seq", "blend", 0), ("seq", "tick", 1),
                ("seq", "pump", 0), ("seq", "blend", 1), ("seq", "pump", 1)]


class SessionExitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = s.load_library(s.build_library())

    def gate(self, x, host):
        info = StepInfo()
        status = self.lib.session_exit_effect_gate(c.byref(x), c.byref(host.host()),
                                                   c.byref(info))
        return status, info

    # --- init / request -------------------------------------------------
    def test_init_is_cold_state_with_image_popup_flag(self):
        x = s.Exit()
        view = s.Rect(*s.VIEW)
        self.assertEqual(self.lib.session_exit_init(c.byref(x), c.byref(view)), OK)
        # 0x583999 starts in the run state for the native app; DAT_0055cd94 has
        # the image value 1 (.data at 0x55cd94 holds 01 00 00 00).
        self.assertEqual((x.g.game_state, x.g.load_game_flag, x.g.popup_flag),
                         (STATE_RUN, 0, 1))
        self.assertEqual((x.effect.busy, x.effect.sequence_counter), (0, 0))
        self.assertEqual((x.effect.full_canvas.left, x.effect.full_canvas.bottom),
                         (10, 384))
        self.assertEqual(self.lib.session_exit_init(None, c.byref(view)), 1)

    def test_request_transition_is_case_0a(self):
        x = new_exit(self.lib, state=STATE_RUN)
        req = s.TransitionRequest(4700, (c.c_int16 * 3)(11, 22, 33), (c.c_int32 * 3)(1, 2, 3))
        self.assertEqual(self.lib.session_exit_request_transition(c.byref(x), c.byref(req)), OK)
        # 0x427d31: 5bb57b = target; 0x427d8f: word 5c39ff = body+6; 0x427dee: state 4
        self.assertEqual((x.g.scene_request, x.g.scene_request_flag, x.g.game_state),
                         (4700, 33, STATE_EXIT))

    # --- gate (0x447c36) -------------------------------------------------
    def test_gate_truth_table_matches_reviewed_predicate(self):
        for kind in range(0, 6):
            for state in (1, 2, 3, 4):
                for stage in range(0, 4):
                    for busy in (0, 1):
                        x = new_exit(self.lib, kind=kind, busy=busy, stage=stage, state=state)
                        host = RecordingHost(self.lib, x)
                        want = 0
                        if busy:
                            if kind == 1:
                                want = state == 4
                            elif kind in (2, 3):
                                want = (state == 4 and stage == 0) or \
                                    (state == 3 and stage in (1, 2))
                        # Direct gate only: stop before the controller by failing the
                        # first boundary, so only the decision is compared.
                        host.fail = BOUNDARY_NESTED
                        status, info = self.gate(x, host)
                        with self.subTest(kind=kind, state=state, stage=stage, busy=busy):
                            self.assertEqual(bool(info.controller_ran) or status == ERR_HOST,
                                             bool(want))
                            if not want:
                                self.assertEqual(host.events, [])
                                self.assertEqual(status, OK)

    # --- controller stages ----------------------------------------------
    def test_stage0_type2_captures_source_then_hands_state_to_the_loader(self):
        x = new_exit(self.lib, kind=2, stage=0, state=STATE_EXIT)
        host = RecordingHost(self.lib, x)
        status, info = self.gate(x, host)
        self.assertEqual(status, OK)
        self.assertEqual(info.controller_ran, 1)
        # 0x447422..0x447460: modal flag, 0x4d36ed, 0x43dbd5, state 3, nested tick,
        # state 4, capture into +0x31.
        self.assertEqual(host.events, [("nested_tick", STATE_RUN),
                                       ("capture", CAPTURE_SOURCE, STATE_EXIT)])
        g = x.g
        self.assertEqual((g.modal_input, g.redraw_request, g.redraw_counter,
                          g.first_render_level), (1, 1, 0, 1))
        # 0x4474ad: stage 1, and state 4 -> 1 (0x4474c0)
        self.assertEqual((x.effect.sequence_counter, g.game_state), (1, STATE_LOAD))
        self.assertEqual(x.effect.busy, 1)

    def test_stage0_type1_and_type3_clear_destination_and_enter_stage2(self):
        for kind in (1, 3):
            with self.subTest(kind=kind):
                x = new_exit(self.lib, kind=kind, stage=0, state=STATE_EXIT)
                host = RecordingHost(self.lib, x)
                status, info = self.gate(x, host)
                self.assertEqual((status, info.controller_ran), (OK, 1))
                self.assertEqual(host.events, [
                    ("nested_tick", STATE_RUN), ("capture", CAPTURE_SOURCE, STATE_EXIT),
                    ("clear_destination",)])
                self.assertEqual((x.effect.sequence_counter, x.g.game_state), (2, STATE_EXIT))

    def test_stage0_for_a_type_outside_the_switch_leaves_stage_unchanged(self):
        x = new_exit(self.lib, kind=7, stage=0, state=STATE_EXIT)
        host = RecordingHost(self.lib, x)
        info = StepInfo()
        self.assertEqual(self.lib.session_exit_controller(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual(host.events, [("nested_tick", STATE_RUN),
                                       ("capture", CAPTURE_SOURCE, STATE_EXIT)])
        self.assertEqual((x.effect.sequence_counter, x.g.game_state), (0, STATE_EXIT))

    def test_stage1_type2_captures_destination_then_runs_the_sequence(self):
        x = new_exit(self.lib, kind=2, stage=1, state=STATE_RUN, budget=4, pause=7,
                     rect=(10, 20, 11, 20))
        x.g.modal_input, x.g.cursor_layer = 1, 0
        host = RecordingHost(self.lib, x)
        status, info = self.gate(x, host)
        self.assertEqual((status, info.controller_ran), (OK, 1))
        self.assertEqual(host.events, [("capture", CAPTURE_DESTINATION, STATE_RUN),
                                       ("run_sequence", 2, 2, STATE_RUN)] + SEQ_2_FRAMES)
        self.assertEqual(host.sequence_state_in["budget"], 4)
        self.assertEqual(host.sequence_state_in["pause"], 7)
        self.assertEqual(host.sequence_state_in["rect"], (10, 20, 11, 20))
        self.assertEqual((host.sequence_state_in["render_guard"],
                          host.sequence_state_in["redraw_flag"], host.sequence_state_in["busy"]),
                         (1, 0, 1))
        # 0x447793: busy 0, 5839a9 0, 5d1639 1
        self.assertEqual((x.effect.busy, x.g.modal_input, x.g.cursor_layer), (0, 0, 1))
        self.assertEqual((x.g.redraw_request, x.g.redraw_counter), (1, 0))
        self.assertEqual(x.effect.sequence_counter, 2)

    def test_stage1_type3_is_rewritten_to_type2_before_the_capture(self):
        x = new_exit(self.lib, kind=3, stage=1, state=STATE_RUN)
        host = RecordingHost(self.lib, x)
        status, _ = self.gate(x, host)
        self.assertEqual(status, OK)
        self.assertEqual(x.effect.active_payload[0], 2)
        self.assertEqual(host.events[:2], [("capture", CAPTURE_DESTINATION, STATE_RUN),
                                           ("run_sequence", 2, 2, STATE_RUN)])
        self.assertEqual(x.effect.busy, 0)

    def test_stage2_type3_swaps_and_returns_to_stage1_without_completing(self):
        x = new_exit(self.lib, kind=3, stage=2, state=STATE_RUN, pause=0)
        x.g.modal_input, x.g.cursor_layer = 1, 0
        host = RecordingHost(self.lib, x, ticks=(100, 102, 102, 103, 104))
        status, _ = self.gate(x, host)
        self.assertEqual(status, OK)
        self.assertEqual(host.events[0], ("run_sequence", 3, 2, STATE_RUN))
        self.assertEqual((x.effect.sequence_counter, x.effect.busy, x.g.modal_input,
                          x.g.cursor_layer, x.g.game_state), (1, 1, 1, 0, STATE_RUN))

    def test_stage2_type3_in_state4_moves_the_loader_state(self):
        # Unreachable through the gate; the controller applies 0x447787 when called.
        x = new_exit(self.lib, kind=3, stage=2, state=STATE_EXIT, pause=0)
        host = RecordingHost(self.lib, x, ticks=(100, 102, 102, 103, 104))
        info = StepInfo()
        self.assertEqual(self.lib.session_exit_controller(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual((x.effect.sequence_counter, x.g.game_state), (1, STATE_LOAD))

    def test_stage3_clears_busy_and_stage_above_3_does_nothing(self):
        x = new_exit(self.lib, kind=2, stage=3, state=STATE_RUN)
        host = RecordingHost(self.lib, x)
        info = StepInfo()
        self.assertEqual(self.lib.session_exit_controller(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual((x.effect.busy, host.events), (0, []))
        x = new_exit(self.lib, kind=2, stage=4, state=STATE_RUN)
        before = bytes(x)
        self.assertEqual(self.lib.session_exit_controller(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual(bytes(x), before)

    def test_host_failure_stops_with_state_written_so_far(self):
        x = new_exit(self.lib, kind=2, stage=0, state=STATE_EXIT)
        host = RecordingHost(self.lib, x, fail=BOUNDARY_NESTED)
        status, info = self.gate(x, host)
        self.assertEqual((status, info.failed_boundary), (ERR_HOST, BOUNDARY_NESTED))
        self.assertEqual(host.events, [("nested_tick", STATE_RUN)])
        self.assertEqual((x.g.game_state, x.g.modal_input, x.effect.sequence_counter),
                         (STATE_RUN, 1, 0))
        x = new_exit(self.lib, kind=2, stage=0, state=STATE_EXIT)
        host = RecordingHost(self.lib, x, fail=BOUNDARY_CAPTURE_SOURCE)
        status, info = self.gate(x, host)
        self.assertEqual((status, info.failed_boundary), (ERR_HOST, BOUNDARY_CAPTURE_SOURCE))
        self.assertEqual((x.g.game_state, x.effect.sequence_counter), (STATE_EXIT, 0))
        x = new_exit(self.lib, kind=2, stage=1, state=STATE_RUN)
        host = RecordingHost(self.lib, x, fail=BOUNDARY_CAPTURE_DESTINATION)
        status, info = self.gate(x, host)
        self.assertEqual((status, info.failed_boundary), (ERR_HOST, BOUNDARY_CAPTURE_DESTINATION))
        self.assertEqual((x.effect.sequence_counter, x.effect.busy), (1, 1))
        x = new_exit(self.lib, kind=2, stage=2, state=STATE_RUN)
        host = RecordingHost(self.lib, x, fail=BOUNDARY_RUN_SEQUENCE)
        status, info = self.gate(x, host)
        self.assertEqual((status, info.failed_boundary), (ERR_HOST, BOUNDARY_RUN_SEQUENCE))
        self.assertEqual((x.effect.busy, x.g.modal_input), (1, 0))

    # --- exit handler (0x43d227) ----------------------------------------
    def state4(self, x, host):
        info = StepInfo()
        status = self.lib.session_exit_state4(c.byref(x), c.byref(host.host()), c.byref(info))
        return status, info

    def test_state4_unsupported_branches_change_nothing(self):
        for kwargs, reason in (({"load_game": 1}, s.UNSUPPORTED_LOAD_GAME),
                               ({"popup": 0}, s.UNSUPPORTED_SUMMARY)):
            x = new_exit(self.lib, kind=2, **kwargs)
            before = bytes(x)
            host = RecordingHost(self.lib, x)
            status, info = self.state4(x, host)
            self.assertEqual((status, info.unsupported), (ERR_UNSUPPORTED, reason))
            self.assertEqual((bytes(x), host.events), (before, []))

    def test_state4_without_a_queued_effect_goes_straight_to_the_loader(self):
        x = new_exit(self.lib, busy=0)
        host = RecordingHost(self.lib, x)
        status, info = self.state4(x, host)
        self.assertEqual((status, info.controller_ran, x.g.game_state, host.events),
                         (OK, 0, STATE_LOAD, []))

    def test_state4_type2_runs_setup_and_the_controller_moves_state_to_1(self):
        x = new_exit(self.lib, kind=2)
        host = RecordingHost(self.lib, x)
        status, info = self.state4(x, host)
        self.assertEqual((status, info.controller_ran, x.g.game_state), (OK, 1, STATE_LOAD))
        self.assertEqual(len(host.events), 2)

    def test_state4_without_diagnostics_gives_the_same_state_as_with_them(self):
        for kind, pause in ((1, 0), (2, 0)):
            a = new_exit(self.lib, kind=kind, pause=pause)
            b = new_exit(self.lib, kind=kind, pause=pause)
            host_a = RecordingHost(self.lib, a, ticks=(100, 102, 102, 103))
            host_b = RecordingHost(self.lib, b, ticks=(100, 102, 102, 103))
            self.state4(a, host_a)
            self.assertEqual(self.lib.session_exit_state4(
                c.byref(b), c.byref(host_b.host()), None), OK)
            self.assertEqual((bytes(a), host_a.events), (bytes(b), host_b.events), kind)

    def test_state4_type1_takes_three_ticks_before_the_load(self):
        x = new_exit(self.lib, kind=1, pause=0)
        host = RecordingHost(self.lib, x, ticks=(100, 102, 102, 103))
        status, info = self.state4(x, host)
        self.assertEqual((status, info.controller_ran, x.g.game_state,
                          x.effect.sequence_counter), (OK, 1, STATE_EXIT, 2))
        status, info = self.state4(x, host)
        self.assertEqual((status, info.controller_ran, x.g.game_state, x.effect.busy),
                         (OK, 1, STATE_EXIT, 0))
        status, info = self.state4(x, host)
        self.assertEqual((status, info.controller_ran, x.g.game_state), (OK, 0, STATE_LOAD))

    def test_render_pass_runs_the_gate_in_state3(self):
        x = new_exit(self.lib, kind=2, stage=1, state=STATE_RUN)
        host = RecordingHost(self.lib, x)
        info = StepInfo()
        self.assertEqual(self.lib.session_exit_render_pass(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual((info.controller_ran, x.effect.busy), (1, 0))

    def test_full_type2_exit_then_successor_first_tick(self):
        # The sequence the packet describes: exit tick (setup), load tick,
        # intro tick, successor state-3 render pass (target capture + frames).
        x = new_exit(self.lib, kind=2, state=STATE_RUN)
        req = s.TransitionRequest(4700, (c.c_int16 * 3)(0, 0, 0), (c.c_int32 * 3)())
        self.assertEqual(self.lib.session_exit_request_transition(c.byref(x), c.byref(req)), OK)
        host = RecordingHost(self.lib, x)
        self.assertEqual(self.state4(x, host)[0], OK)
        self.assertEqual(x.g.game_state, STATE_LOAD)
        self.assertEqual(self.lib.session_exit_begin_load(c.byref(x)), OK)
        self.assertEqual(x.g.game_state, STATE_INTRO)    # word 5c39ff == 0
        self.assertEqual(self.lib.session_exit_clear_latches(c.byref(x)), OK)
        self.assertEqual(self.lib.session_exit_finish_intro(c.byref(x)), OK)
        self.assertEqual(x.g.game_state, STATE_RUN)
        info = StepInfo()
        self.assertEqual(self.lib.session_exit_render_pass(
            c.byref(x), c.byref(host.host()), c.byref(info)), OK)
        self.assertEqual(info.controller_ran, 1)
        self.assertEqual(x.effect.busy, 0)
        names = [e[0] for e in host.events]
        self.assertEqual(names[:4], ["nested_tick", "capture", "capture", "run_sequence"])

    # --- load-state helpers ---------------------------------------------
    def test_begin_load_picks_state2_or_3_from_the_transition_word(self):
        x = new_exit(self.lib, state=STATE_LOAD)
        x.g.scene_request_flag = 0
        self.assertEqual(self.lib.session_exit_begin_load(c.byref(x)), OK)
        self.assertEqual(x.g.game_state, STATE_INTRO)
        x.g.game_state = STATE_LOAD
        x.g.scene_request_flag = -1       # movsx word, any nonzero value
        self.assertEqual(self.lib.session_exit_begin_load(c.byref(x)), OK)
        self.assertEqual(x.g.game_state, STATE_RUN)

    # --- ClearSceneData blocks -------------------------------------------
    def test_clear_latches_block(self):
        x = new_exit(self.lib)
        for name in ("scene_request_flag", "cursor_override", "latch_5c39ed",
                     "latch_5c39f1", "latch_5c39f5", "latch_5c39f9",
                     "exit_hold_63a5c0", "exit_hold_63a5c4"):
            setattr(x.g, name, 7)
        x.g.input_latch = 5
        x.g.first_render_level = 0
        x.g.scene_request = 4700
        self.assertEqual(self.lib.session_exit_clear_latches(c.byref(x)), OK)
        g = x.g
        self.assertEqual((g.scene_request_flag, g.cursor_override, g.latch_5c39ed,
                          g.latch_5c39f1, g.latch_5c39f5, g.latch_5c39f9), (0,) * 6)
        # 0x43e410: 5c39e5 = -1; 0x43e41a call 0x43dbd5: word 5bb1c4 = 1; 0x43e41f/0x43e429
        self.assertEqual((g.input_latch, g.first_render_level, g.exit_hold_63a5c0,
                          g.exit_hold_63a5c4), (-1, 1, 0, 0))
        self.assertEqual(g.scene_request, 4700)     # not part of the block


class ClearCaptionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = s.load_library(s.build_library())
        cls.lib.session_exit_clear_caption.argtypes = [
            c.POINTER(s.Exit), c.POINTER(life_tests.Lifecycle), c.POINTER(life_tests.Backend)]
        cls.lib.session_exit_clear_caption.restype = c.c_int

    def make(self, frame_height=1001, view=(40, 340)):
        geometry = layout.Geometry()
        struct.pack_into("<i", geometry.tbox, 0x04, view[0])    # 0x5b0a16
        struct.pack_into("<i", geometry.tbox, 0x0c, view[1])    # 0x5b0a1e
        geometry.framed_surface_height = frame_height           # 0x5b0a76
        shared = layout.Globals()
        life = life_tests.make_life(None, geometry, shared)
        life.shared[0].frame_open = 1
        life.shared[0].framed_ready = 1
        life.shared[0].caption_finish_flag = 1
        life.shared[0].caption_visible_flag = 1
        life.shared[0].framed_scroll_lines = 123
        life.g.framed_clear_request = 1
        life.g.framed_clear_counter = 9
        life.g.caption_clear_counter = 8
        life.g.scroll_fraction = 0.5
        life.g.scroll_src = life_tests.Rect(1, 2, 3, 4)
        life.g.framed_layer_enabled = 1
        script = life_tests.Script()
        backend = life_tests.RecordingBackend(script)
        return life, backend, geometry, shared

    def test_clear_caption_block_order_and_untouched_counters(self):
        life, backend, geometry, shared = self.make()
        x = new_exit(self.lib)
        x.g.framed_flag_5b15da, x.g.saved_flag_5bb1da, x.g.redraw_request = 1, 1, 1
        status = self.lib.session_exit_clear_caption(c.byref(x), c.byref(life),
                                                     c.byref(backend.struct))
        self.assertEqual(status, OK)
        # 0x43e1c2 closes the frame text box first: the taskbar area restore blit.
        self.assertEqual([e[0] for e in backend.events], ["blit"])
        self.assertEqual(life.shared[0].frame_open, 0)
        self.assertEqual(life.g.framed_layer_enabled, 0)
        # 0x43e1c7..0x43e1de: word 5b0a76 - ((5b0a1e - 5b0a16) + 1) = 1001 - 301
        self.assertEqual(life.shared[0].framed_scroll_lines, 700)
        sh = life.shared[0]
        self.assertEqual((sh.caption_finish_flag, sh.caption_visible_flag, sh.framed_ready),
                         (0, 0, 0))
        self.assertEqual(life.g.framed_clear_request, 0)
        self.assertEqual((x.g.framed_flag_5b15da, x.g.saved_flag_5bb1da, x.g.redraw_request),
                         (0, 0, 0))
        # InitStaticSceneData-only writes are NOT part of ClearSceneData.
        self.assertEqual((life.g.framed_clear_counter, life.g.caption_clear_counter), (9, 8))
        self.assertEqual(life.g.scroll_fraction, 0.5)
        self.assertEqual(life.g.scroll_src.tuple(), (1, 2, 3, 4))

    def test_scroll_lines_wrap_to_16_bits_like_the_word_store(self):
        life, backend, _g, _s = self.make(frame_height=-3, view=(0, 10))
        x = new_exit(self.lib)
        self.assertEqual(self.lib.session_exit_clear_caption(
            c.byref(x), c.byref(life), c.byref(backend.struct)), OK)
        # movsx(-3) - 11 = -14
        self.assertEqual(life.shared[0].framed_scroll_lines, -14)

    def test_failed_close_stops_before_any_flag_write(self):
        life, backend, _g, _s = self.make()
        backend.script.fail = True
        backend.struct.blit = life_tests.BLIT(lambda _c, _b: 1)
        x = new_exit(self.lib)
        status = self.lib.session_exit_clear_caption(c.byref(x), c.byref(life),
                                                     c.byref(backend.struct))
        self.assertNotEqual(status, OK)
        self.assertEqual(life.shared[0].caption_visible_flag, 1)
        self.assertEqual(life.g.framed_clear_request, 1)

    def test_argument_validation(self):
        x = new_exit(self.lib)
        self.assertNotEqual(self.lib.session_exit_clear_caption(c.byref(x), None, None), OK)


if __name__ == "__main__":
    unittest.main()
