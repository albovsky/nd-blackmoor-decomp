"""RT-3: type-0x62 session binding, driven through the real scene session.

The scenes are synthetic but shaped like S5900 rows 7-10 (one 0x62 row whose
completion event gates later rows). Pointer input is never produced here: the
candidate is built with the reviewed interaction reducers and stored through
scene_session_accept_action_candidate, the narrow interface RT-2 will use.
"""

from __future__ import annotations

import ctypes as c
import unittest

import session_binding_support as s
from session_binding_support import (
    A62AcceptInput, A62AcceptResult, A62Host, A62ScanRequest, A62ScanResult,
    A62Target, ActionFn, Binding, MediaFn, PrepareFn, PreGateFn, RuntimeState,
    SceneSessionFailure, SceneSessionTickResult, SelectorFn, SessionConfig,
    StartFlagFn, a62_body, action, flag_gate, i16, make_world, open_scene)

# S5900 row 7 entry: selector word 0, response words (w1, w3, w5, w7).
S5900_ENTRY = (0, 0, 0, 0, 0, 10, 0, 10, 0)

ROW_OK = 0
FAIL_NONE, FAIL_SELECTOR, FAIL_BODY, FAIL_EVENT_RANGE = 0, 1, 2, 3
FAIL_ROW_RANGE, FAIL_DISPOSITION = 4, 5


class A62Fixture:
    """Session + binding for one synthetic scene."""

    def __init__(self, test, lib, actions, *, selector=0, selector_ok=True,
                 flag_count=16):
        self.test, self.lib = test, lib
        self.scene, self.scene_owner = open_scene(lib, actions)
        self.flags, self.world, self.conditions = make_world(flag_count)
        self.selector = selector
        self.selector_ok = selector_ok
        self.selector_calls = 0
        self.start_flag_writes = []
        self.keep = []

        @SelectorFn
        def current_selector(_context, out):
            self.selector_calls += 1
            if not self.selector_ok:
                return 1
            out[0] = self.selector
            return 0

        @StartFlagFn
        def set_start_flag(_context, value):
            self.start_flag_writes.append(value)

        host = A62Host(None, current_selector, set_start_flag)
        lib.session_a62_create.argtypes = [c.POINTER(s.ActionCoreWorld), c.POINTER(A62Host)]
        lib.session_a62_create.restype = c.c_void_p
        lib.session_a62_destroy.argtypes = [c.c_void_p]
        lib.session_a62_begin_scene.argtypes = [c.c_void_p, c.c_size_t]
        lib.session_a62_begin_scene.restype = c.c_int
        lib.session_a62_get_target.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(A62Target)]
        lib.session_a62_get_target.restype = c.c_int
        lib.session_a62_start_flag.argtypes = [c.c_void_p]
        lib.session_a62_start_flag.restype = c.c_int32
        lib.session_a62_last_failure.argtypes = [c.c_void_p]
        lib.session_a62_last_failure.restype = c.c_int
        lib.session_a62_scan_candidate.argtypes = [
            c.c_void_p, c.POINTER(A62ScanRequest), c.POINTER(A62ScanResult)]
        lib.session_a62_scan_candidate.restype = c.c_int
        self.binding = lib.session_a62_create(c.byref(self.world), c.byref(host))
        test.assertTrue(self.binding)
        count = len(actions)
        test.assertEqual(lib.session_a62_begin_scene(self.binding, count), 0)
        self.keep += [current_selector, set_start_flag, host]

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return s.CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return s.CALLBACK_OK

        handler = ActionFn(("session_a62_handler", lib))
        binding = Binding(type=0x62, provider=s.PROVIDER_A62, callback=handler,
                          context=self.binding)
        bindings = (Binding * 1)(binding)
        config = SessionConfig(
            scene=self.scene, scene_id=5900,
            action_core_world=c.pointer(self.world),
            conditions=c.pointer(self.conditions),
            action_bindings=bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media,
            provider_context=None)
        self.session = c.c_void_p()
        failure = SceneSessionFailure()
        status = lib.scene_session_create(c.byref(config), c.byref(self.session),
                                          c.byref(failure))
        test.assertEqual(status, 0)
        self.pre_gate = PreGateFn(("session_a62_pre_gate", lib))
        test.assertEqual(lib.scene_session_set_pre_gate(
            self.session, 0x62, c.cast(self.pre_gate, c.c_void_p),
            self.binding), 0)
        self.keep += [prepare, media, handler, bindings, config]

    def tick(self):
        result = SceneSessionTickResult()
        status = self.lib.scene_session_tick(self.session, c.byref(result))
        return status, result

    def state(self, row=0):
        value = RuntimeState()
        self.test.assertEqual(self.lib.scene_session_get_action_state(
            self.session, row, c.byref(value)), 0)
        return value.completed, value.phase

    def target(self, row=0):
        value = A62Target()
        self.test.assertEqual(self.lib.session_a62_get_target(
            self.binding, row, c.byref(value)), 0)
        return value.request_pending, tuple(value.response_words)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a62_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)


class SessionBindingsA62Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = s.load_library(s.build_library())

    def make(self, actions, **kwargs):
        fixture = A62Fixture(self, self.lib, actions, **kwargs)
        self.addCleanup(fixture.close)
        return fixture

    @staticmethod
    def s5900_shape(**body_kwargs):
        kwargs = dict(ids=(3, -1), values=(1, 1))
        kwargs.update(body_kwargs)
        return [
            action(0x62, 1, a62_body([S5900_ENTRY], **kwargs)),
            # Rows 8-10 are gated by the completion event of row 7.
            action(0x61, 1, i16(9) + i16(5) + i16(-1) + i16(0), (flag_gate(3),)),
        ]

    # ---- selector provenance ------------------------------------------------

    def test_unprovable_selector_is_a_named_blocker_and_changes_nothing(self):
        fixture = self.make(self.s5900_shape(), selector_ok=False)
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_BLOCKED)
        self.assertEqual(result.failure.stage, s.STAGE_DISPATCH)
        self.assertEqual(result.failure.provider, s.PROVIDER_A62)
        self.assertEqual((result.failure.action_index, result.failure.action_type), (0, 0x62))
        self.assertEqual(fixture.lib.session_a62_last_failure(fixture.binding), FAIL_SELECTOR)
        self.assertEqual(fixture.selector_calls, 1)
        self.assertEqual(fixture.state(), (0, 0))
        self.assertEqual(fixture.target(), (0, (0, 0, 0, 0)))
        self.assertEqual(fixture.start_flag_writes, [])
        self.assertEqual(fixture.lib.session_a62_start_flag(fixture.binding), 0)

    def test_selector_provider_is_not_consulted_for_phase_two(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        self.assertEqual(fixture.selector_calls, 1)
        fixture.selector_ok = False  # phase 2 never reads DAT_005bb50b
        self.assertEqual(fixture.lib.scene_session_accept_action_candidate(
            fixture.session, 0), 0)
        status, _result = fixture.tick()
        self.assertEqual(status, s.SESSION_OK)
        self.assertEqual(fixture.selector_calls, 1)

    # ---- phase 0/1: start flag, request and response publication -----------

    def test_first_visit_sets_start_flag_publishes_request_and_response_words(self):
        fixture = self.make(self.s5900_shape())
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_OK)
        # Row 0 applied; the gated 0x61 row is skipped by its dependency.
        self.assertEqual(result.executor.actions_applied, 1)
        self.assertEqual(fixture.state(), (0, 1))
        self.assertEqual(fixture.target(), (1, (0, 0, 10, 10)))
        self.assertEqual(fixture.start_flag_writes, [1])
        self.assertEqual(fixture.lib.session_a62_start_flag(fixture.binding), 1)
        self.assertEqual(list(fixture.flags), [0] * 16)

    def test_phase_one_clears_then_republishes_and_start_flag_is_phase_zero_only(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        status, _ = fixture.tick()
        self.assertEqual(status, s.SESSION_OK)
        self.assertEqual(fixture.state(), (0, 1))
        self.assertEqual(fixture.target(), (1, (0, 0, 10, 10)))
        self.assertEqual(fixture.start_flag_writes, [1])  # not rewritten at phase 1

    def test_selector_miss_clears_request_but_retains_old_response_words(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        fixture.selector = 7  # no entry has word 0 == 7
        fixture.tick()
        self.assertEqual(fixture.target(), (0, (0, 0, 10, 10)))
        self.assertEqual(fixture.state(), (0, 1))

    def test_selector_is_compared_as_signed_sixteen_bit(self):
        entry = (-5, 11, 0, 12, 0, 13, 0, 14, 0)
        fixture = self.make([action(0x62, 1, a62_body([entry]))], selector=-5)
        fixture.tick()
        self.assertEqual(fixture.target(), (1, (11, 12, 13, 14)))

    def test_first_matching_entry_wins(self):
        first = (4, 1, 0, 2, 0, 3, 0, 4, 0)
        second = (4, 9, 0, 9, 0, 9, 0, 9, 0)
        fixture = self.make([action(0x62, 1, a62_body([first, second]))], selector=4)
        fixture.tick()
        self.assertEqual(fixture.target(), (1, (1, 2, 3, 4)))

    # ---- dispatcher pre-gate -------------------------------------------------

    def test_false_dependency_gate_still_clears_the_request(self):
        body = a62_body([S5900_ENTRY], ids=(3, -1), values=(1, 1))
        fixture = self.make([action(0x62, 1, body, (flag_gate(5),))])
        fixture.flags[5] = 1
        fixture.tick()
        self.assertEqual(fixture.target(), (1, (0, 0, 10, 10)))
        fixture.flags[5] = 0
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_OK)
        self.assertEqual(result.executor.actions_applied, 0)  # handler skipped
        self.assertEqual(fixture.target(), (0, (0, 0, 10, 10)))
        self.assertEqual(fixture.state(), (0, 1))  # phase/completion untouched
        self.assertEqual(fixture.selector_calls, 1)

    # ---- synthetic accepted event: phase 2 -----------------------------------

    def scan_and_accept(self, fixture, a, b):
        request = A62ScanRequest(a, b, -1, -1, 0)
        scan = A62ScanResult()
        self.assertEqual(self.lib.session_a62_scan_candidate(
            fixture.binding, c.byref(request), c.byref(scan)), 0)
        if not scan.candidate_found:
            return scan, None
        self.lib.action_family_62_interaction_accept.argtypes = [
            c.POINTER(A62AcceptInput), c.POINTER(A62AcceptResult)]
        self.lib.action_family_62_interaction_accept.restype = c.c_int
        accept = A62AcceptResult()
        self.assertEqual(self.lib.action_family_62_interaction_accept(
            c.byref(A62AcceptInput(scan.candidate_action_index, 0, 0, 0, -1)),
            c.byref(accept)), 0)
        return scan, accept

    def test_synthetic_accepted_click_completes_row_and_opens_the_gated_rows(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        scan, accept = self.scan_and_accept(fixture, 5, 5)
        self.assertEqual((scan.candidate_found, scan.candidate_action_index), (1, 0))
        self.assertEqual(scan.candidate_route, 1)
        self.assertEqual(accept.phase2_requested, 1)
        self.assertEqual(self.lib.scene_session_accept_action_candidate(
            fixture.session, scan.candidate_action_index), 0)
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_OK)
        # Event 3 = 1 (id -1 pair suppressed); row completes with phase 0, and
        # the same pass already sees flag 3 for the gated row that follows.
        self.assertEqual(fixture.flags[3], 1)
        self.assertEqual(fixture.flags[9], 5)
        self.assertEqual(fixture.state(0), (1, 0))
        self.assertEqual(fixture.state(1), (1, 0))
        self.assertEqual(fixture.target(), (0, (0, 0, 10, 10)))
        self.assertEqual(result.executor.actions_applied, 2)

    def test_click_outside_the_published_rectangle_finds_no_candidate(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        scan, _ = self.scan_and_accept(fixture, 11, 5)
        self.assertEqual(scan.candidate_found, 0)
        scan, _ = self.scan_and_accept(fixture, 5, -1)
        self.assertEqual(scan.candidate_found, 0)
        # Bounds are inclusive on both edges.
        scan, _ = self.scan_and_accept(fixture, 10, 0)
        self.assertEqual(scan.candidate_found, 1)

    def test_scan_after_pre_gate_clear_finds_nothing(self):
        body = a62_body([S5900_ENTRY], ids=(3, -1), values=(1, 1))
        fixture = self.make([action(0x62, 1, body, (flag_gate(5),))])
        fixture.flags[5] = 1
        fixture.tick()
        fixture.flags[5] = 0
        fixture.tick()
        scan, _ = self.scan_and_accept(fixture, 5, 5)
        self.assertEqual(scan.candidate_found, 0)

    def test_threshold_at_or_above_35_stays_pending_at_phase_one(self):
        fixture = self.make(self.s5900_shape(threshold=35))
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        fixture.tick()
        self.assertEqual(fixture.state(), (0, 1))
        self.assertEqual(fixture.flags[3], 0)

    def test_threshold_34_completes(self):
        fixture = self.make(self.s5900_shape(threshold=34))
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        fixture.tick()
        self.assertEqual(fixture.state(), (1, 0))

    def test_both_event_pairs_are_written_in_order_and_minus_one_is_skipped(self):
        fixture = self.make([action(0x62, 1, a62_body(
            [S5900_ENTRY], ids=(3, 3), values=(1, 6)))])
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        fixture.tick()
        self.assertEqual(fixture.flags[3], 6)  # second pair wins, source order

    def test_subtype_two_completes_without_completion_and_resets_dependencies(self):
        gate = flag_gate(3)
        rows = [action(0x62, 2, a62_body([S5900_ENTRY], ids=(3, -1), values=(1, 0))),
                action(0x61, 1, i16(9) + i16(5) + i16(-1) + i16(0), (gate,))]
        fixture = self.make(rows)
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        fixture.tick()
        self.assertEqual(fixture.flags[3], 1)
        self.assertEqual(fixture.state(0), (0, 0))  # subtype 2 reopens the row
        self.assertEqual(fixture.flags[9], 5)
        self.assertEqual(fixture.target(0)[0], 0)

    def test_other_subtype_completes_directly(self):
        fixture = self.make([action(0x62, 0, a62_body(
            [S5900_ENTRY], ids=(3, -1), values=(1, 0)))])
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        fixture.tick()
        self.assertEqual(fixture.state(), (1, 0))

    # ---- explicit rejections --------------------------------------------------

    def test_event_id_outside_the_flag_view_rejects_the_whole_visit(self):
        # The original indexes 0x585801 unchecked. Native code refuses and
        # applies nothing, not even the in-range first pair.
        fixture = self.make([action(0x62, 1, a62_body(
            [S5900_ENTRY], ids=(3, 40), values=(1, 1)))])
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        status, result = fixture.tick()
        self.assertEqual(status, 5)  # SCENE_SESSION_ERR_EXECUTOR (handler error)
        self.assertEqual(self.lib.session_a62_last_failure(fixture.binding), FAIL_EVENT_RANGE)
        self.assertEqual(list(fixture.flags), [0] * 16)
        self.assertEqual(fixture.state(), (0, 2))
        # The dispatcher's own request clear (pre-gate) precedes the refused
        # visit; the response words are untouched.
        self.assertEqual(fixture.target(), (0, (0, 0, 10, 10)))

    def test_negative_event_id_other_than_minus_one_is_rejected(self):
        fixture = self.make([action(0x62, 1, a62_body(
            [S5900_ENTRY], ids=(-2, -1), values=(1, 1)))])
        fixture.tick()
        self.lib.scene_session_accept_action_candidate(fixture.session, 0)
        status, _ = fixture.tick()
        self.assertEqual(status, 5)
        self.assertEqual(self.lib.session_a62_last_failure(fixture.binding), FAIL_EVENT_RANGE)

    def test_begin_scene_clears_rows_and_bounds_the_table(self):
        fixture = self.make(self.s5900_shape())
        fixture.tick()
        self.assertEqual(fixture.target()[0], 1)
        self.assertEqual(self.lib.session_a62_begin_scene(fixture.binding, 1), 0)
        self.assertEqual(fixture.target(), (0, (0, 0, 0, 0)))
        value = A62Target()
        self.assertNotEqual(self.lib.session_a62_get_target(
            fixture.binding, 1, c.byref(value)), 0)
        self.assertNotEqual(self.lib.session_a62_begin_scene(fixture.binding, 241), 0)


if __name__ == "__main__":
    unittest.main()
