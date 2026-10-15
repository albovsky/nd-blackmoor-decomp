"""RT-6: the recovered pointer producer (session_input) wired through the session.

Written before the session binding existed. The checks pin the sequencing and
the single-candidate rule; the pointer decisions themselves (latch, consume,
transform, first-hit scan) are session_input's and are compared with the
original x86 in RT-2. Every wrapper below calls the real session_input
functions from the same library the session is linked in; nothing here
reimplements a decision.

Sequencing under test (43a7ca / 4d3073 / 4f0059):
  prepare -> media -> [4daf3f consume + activation candidate] -> dispatch
          -> [4d3073 candidate = -1, 4f0059 scan over the exported rows]
"""
from __future__ import annotations

import ctypes as c
import unittest

import test_scene_executor as exe
import test_scene_session as base

i16, action = base.i16, base.action
SESSION_OK, SESSION_TRANSITION, SESSION_BLOCKED = 0, 1, 2
STAGE_POINTER, PROVIDER_POINTER = 5, 5
INPUT_OK, INPUT_LIMIT_GEOMETRY, INPUT_LIMIT_PRIORITY = 0, 2, 3
MOVE, DOWN, UP, DBLCLK = 0, 1, 2, 3
HANDLER_OK = 0
HANDLER_PENDING = 0


class Rect(c.Structure):
    _fields_ = [(name, c.c_int32) for name in ("left", "top", "right", "bottom")]


class InputState(c.Structure):
    _fields_ = [("latch", c.c_uint8 * 32), ("candidate", c.c_int32)]


class InputContext(c.Structure):
    _fields_ = [("viewport", Rect), ("cursor", Rect)] + [
        (name, c.c_int32) for name in ("hot_x", "hot_y", "scroll_y", "cursor_mode")
    ] + [(name, c.c_uint32) for name in ("modal_event", "producer_disabled",
                                        "geometry_ready", "priority_clear")] + [
        ("excluded_0", c.c_int32), ("excluded_1", c.c_int32)]


class InputHotspot(c.Structure):
    _fields_ = [("index", c.c_int32), ("rectangle", Rect), ("active", c.c_uint32)]


class PointerResult(c.Structure):
    _fields_ = [
        ("tick_index", c.c_uint64),
        ("consume_status", c.c_int32),
        ("scan_status", c.c_int32),
        ("candidate_at_consume", c.c_int32),
        ("candidate_after_scan", c.c_int32),
        ("scan_rows", c.c_uint32),
        ("activation_event", c.c_uint8),
        ("activation_candidate_valid", c.c_uint8),
    ]


ConsumeFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(base.SceneExecutorFrameInput),
                        c.POINTER(c.c_int32))
ScanFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(InputHotspot), c.c_size_t,
                     c.POINTER(c.c_int32))
ResetFn = c.CFUNCTYPE(c.c_int, c.c_void_p)
ExternalFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_size_t, c.POINTER(InputHotspot))


class PointerHost(c.Structure):
    _fields_ = [("context", c.c_void_p), ("consume", ConsumeFn), ("scan", ScanFn),
                ("reset", ResetFn), ("external_row", ExternalFn)]


RECT = (10, 20, 30, 40)


class Rig:
    """Host side: the input state, the geometry snapshot and the thin wrappers
    the app uses (consume = session_input_tick, scan = candidate reset to -1
    plus session_input_scan, reset = session_input_init)."""

    def __init__(self, lib, external_rows=()):
        self.lib = lib
        self.state = InputState()
        lib.session_input_init(c.byref(self.state))
        self.ctx = InputContext(Rect(0, 0, 639, 479), Rect(20, 30, 20, 30),
                                0, 0, 0, 0, 0, 0, 1, 1, -1, -1)
        self.external_rows = dict(external_rows)
        self.calls = []
        self.consume_override = None
        self.on_consume = None
        rig = self

        def consume(_ctx, frame, candidate):
            rig.calls.append("consume")
            if rig.on_consume is not None:
                rig.on_consume()
            if rig.consume_override is not None:
                return rig.consume_override
            status = lib.session_input_tick(c.byref(rig.state), c.byref(rig.ctx), frame)
            candidate[0] = rig.state.candidate
            return status

        def scan(_ctx, rows, count, candidate):
            rig.calls.append("scan")
            lib.session_input_publish_candidate(c.byref(rig.state), -1)  # 4d3073
            status = lib.session_input_scan(c.byref(rig.state), c.byref(rig.ctx), rows, count)
            rig.scanned = [(rows[i].index, rows[i].rectangle.left, rows[i].rectangle.top,
                            rows[i].rectangle.right, rows[i].rectangle.bottom)
                           for i in range(count)]
            candidate[0] = rig.state.candidate
            return status

        def reset(_ctx):
            rig.calls.append("reset")
            return lib.session_input_init(c.byref(rig.state))

        def external(_ctx, index, row):
            rect = rig.external_rows.get(index)
            if rect is None:
                return 0
            row[0].index = index
            row[0].rectangle = Rect(*rect)
            row[0].active = 1
            return 1

        self.scanned = []
        self.host = PointerHost(None, ConsumeFn(consume), ScanFn(scan), ResetFn(reset),
                                ExternalFn(external))

    def bind(self, session):
        status = self.lib.scene_session_bind_pointer(session, c.byref(self.host))
        assert status == 0, status

    def feed(self, event):
        assert self.lib.session_input_feed(c.byref(self.state), event, 0, 20, 30, None, None) == 0

    def click(self):
        self.feed(DOWN)
        self.feed(UP)

    def latch_edge(self):
        return self.state.latch[0]


class SessionPointerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        base.SceneSessionTests.setUpClass.__func__(cls)
        lib = cls.lib
        lib.scene_session_bind_pointer.argtypes = [c.c_void_p, c.POINTER(PointerHost)]
        lib.scene_session_bind_pointer.restype = c.c_int
        lib.scene_session_get_pointer_result.argtypes = [c.c_void_p, c.POINTER(PointerResult)]
        lib.scene_session_get_pointer_result.restype = c.c_int
        lib.session_input_init.argtypes = [c.POINTER(InputState)]
        lib.session_input_feed.argtypes = [c.POINTER(InputState), c.c_int, c.c_uint32,
                                           c.c_int32, c.c_int32, c.c_void_p, c.c_void_p]
        lib.session_input_tick.argtypes = [c.POINTER(InputState), c.POINTER(InputContext),
                                           c.c_void_p]
        lib.session_input_scan.argtypes = [c.POINTER(InputState), c.POINTER(InputContext),
                                           c.c_void_p, c.c_size_t]
        lib.session_input_publish_candidate.argtypes = [c.POINTER(InputState), c.c_int32]
        for name in ("init", "feed", "tick", "scan", "publish_candidate"):
            getattr(lib, "session_input_" + name).restype = c.c_int

    open_scene = base.SceneSessionTests.open_scene
    make_world = base.SceneSessionTests.make_world
    create_session = base.SceneSessionTests.create_session

    # -- scene builders ----------------------------------------------------
    @staticmethod
    def hotspot(flag, value, rect=RECT):
        return action(0x6A, 2, exe.hotspot_6a_body(0, rect, ((flag, value),)))

    @staticmethod
    def request_row():
        return action(0x62, 1, base.SceneSessionTests.a62_body())

    def start(self, actions, *, external_rows=(), prepare_extra=None, media_block=None,
              bind=True, bindings=True):
        scene, owner = self.open_scene(actions)
        flags, world, conditions = self.make_world()
        rig = Rig(self.lib, external_rows)
        visits = []

        @base.ActionFn
        def handler(_context, index, _info, before, result):
            visits.append((index, before.contents.phase))
            result.contents.disposition = HANDLER_PENDING
            result.contents.phase = 1
            return HANDLER_OK

        @base.PrepareFn
        def prepare(_context, _conditions, frame, _failure):
            if prepare_extra is not None:
                prepare_extra(frame)
            return base.CALLBACK_OK

        @base.MediaFn
        def media(_context, _frame, _failure):
            return base.CALLBACK_BLOCKED if media_block and media_block[0] else base.CALLBACK_OK

        bound = ([base.Binding(type=0x62, provider=base.PROVIDER_A62, callback=handler,
                               context=None)] if bindings else None)
        session, initial, binding_array = self.create_session(
            scene, world, conditions, prepare=prepare, media=media, bindings=bound)
        if bind:
            rig.bind(session)
        self.addCleanup(lambda: (self.lib.scene_session_destroy(session),
                                 self.lib.scene_resource_close(scene)))
        self._keep = getattr(self, "_keep", []) + [
            (owner, prepare, media, handler, initial, binding_array, rig, world, conditions, flags)]
        return session, flags, rig, visits

    def tick(self, session, expected=SESSION_OK):
        result = base.SceneSessionTickResult()
        self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)), expected)
        pointer = PointerResult()
        self.assertEqual(self.lib.scene_session_get_pointer_result(session, c.byref(pointer)), 0)
        return result, pointer

    def phase(self, session, index):
        state = base.RuntimeState()
        self.assertEqual(self.lib.scene_session_get_action_state(
            session, index, c.byref(state)), 0)
        return state.phase

    # -- first hit, one candidate, no double phase 2 -----------------------
    def test_overlapping_hotspots_activate_the_first_row_not_the_last(self):
        # The executor's own scan used to keep the LAST overlapping hit; the
        # original generic loop returns at the first (0x4f2305..0x4f2390).
        session, flags, rig, _visits = self.start([
            self.hotspot(1, 5), self.hotspot(2, 9)])
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.candidate_after_scan, 0)
        self.assertEqual(pointer.scan_rows, 2)
        rig.click()
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.activation_event, pointer.candidate_at_consume), (1, 0))
        self.assertEqual((flags[1], flags[2]), (5, 0))
        self.assertEqual(self.phase(session, 1), 1)

    def test_one_candidate_is_shared_by_hotspot_and_request_rows_without_double_phase_two(self):
        # Row 0 is a 0x62 request row (external rectangle), row 1 a 0x6a
        # hotspot over the same rectangle. One release produces exactly one
        # phase-2 store, on the first row in index order.
        session, flags, rig, visits = self.start(
            [self.request_row(), self.hotspot(2, 9)], external_rows={0: RECT})
        self.tick(session)
        self.assertEqual(visits, [(0, 0)])
        rig.click()
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.activation_event, pointer.candidate_at_consume), (1, 0))
        self.assertEqual(visits, [(0, 0), (0, 2)])  # phase 2 visit on the same tick
        self.assertEqual((flags[2], self.phase(session, 1)), (0, 1))

        # Reversed order: the hotspot wins, the request row never sees phase 2.
        session2, flags2, rig2, visits2 = self.start(
            [self.hotspot(2, 9), self.request_row()], external_rows={1: RECT})
        self.tick(session2)
        rig2.click()
        self.tick(session2)
        self.assertEqual(flags2[2], 9)
        self.assertEqual([phase for _index, phase in visits2], [0, 1])  # never 2

    def test_scan_offers_exported_and_external_rows_in_ascending_order(self):
        # Row 2 is a hotspot whose frame never matches (not exported).
        never = action(0x6A, 2, exe.hotspot_6a_body(9, RECT, ((3, 1),)))
        session, _flags, rig, _visits = self.start(
            [self.hotspot(1, 5), self.request_row(), never, self.hotspot(2, 9, (50, 60, 70, 80))],
            external_rows={1: (0, 0, 5, 5)})
        _result, pointer = self.tick(session)
        self.assertEqual(rig.scanned, [(0, *RECT), (1, 0, 0, 5, 5), (3, 50, 60, 70, 80)])
        self.assertEqual(pointer.scan_rows, 3)

    def test_inactive_hotspot_with_a_remembered_rectangle_is_not_offered(self):
        # Once the dependency gate closes the row is inactive although its
        # rectangle is still valid; the original request dword (+0x43) is zero
        # then, so 4f0059 must not hit it.
        gate = base.SceneSessionTests.flag_gate(5)
        row = action(0x6A, 2, exe.hotspot_6a_body(0, RECT, ((1, 5),)), (gate,))
        session, flags, rig, _visits = self.start([row])
        flags[5] = 1
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.scan_rows, pointer.candidate_after_scan), (1, 0))
        flags[5] = 0
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.scan_rows, pointer.candidate_after_scan), (0, -1))

    def test_no_candidate_when_cursor_is_outside_every_rectangle(self):
        session, flags, rig, _visits = self.start([self.hotspot(1, 5)])
        rig.ctx.cursor = Rect(300, 300, 300, 300)
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.candidate_after_scan, -1)
        rig.click()  # no candidate at message time -> no edge at all
        self.assertEqual(rig.latch_edge(), 0)
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.activation_event, flags[1]), (0, 0))

    # -- double click --------------------------------------------------------
    def test_double_click_sequence_rejects_the_second_activation(self):
        # DOWN, UP, tick, DBLCLK, UP, tick (the request row stays a candidate,
        # so the second UP would latch an edge if DBLCLK did not inhibit it).
        session, _flags, rig, visits = self.start(
            [self.request_row()], external_rows={0: RECT})
        self.tick(session)
        rig.click()
        _result, first = self.tick(session)
        self.assertEqual((first.activation_event, first.candidate_after_scan), (1, 0))
        self.assertEqual(visits[-1], (0, 2))
        rig.feed(DBLCLK)
        rig.feed(UP)
        self.assertEqual(rig.latch_edge(), 0)
        before = len(visits)
        _result, second = self.tick(session)
        self.assertEqual((second.activation_event, second.candidate_at_consume), (0, 0))
        self.assertEqual(visits[before:], [(0, 1)])  # no phase-2 visit
        # Control: a fresh DOWN clears the inhibit and the next release counts.
        rig.click()
        _result, third = self.tick(session)
        self.assertEqual(third.activation_event, 1)
        self.assertEqual(visits[-1], (0, 2))

    def test_hotspot_that_rearms_needs_a_hover_tick_between_double_click_halves(self):
        session, flags, rig, _visits = self.start([self.hotspot(1, 5)])
        self.tick(session)
        rig.click()
        _result, first = self.tick(session)
        self.assertEqual((first.activation_event, flags[1]), (1, 5))
        flags[1] = 0
        self.tick(session)  # hotspot re-arms and is hit again
        rig.feed(DBLCLK)
        rig.feed(UP)
        _result, second = self.tick(session)
        self.assertEqual((second.activation_event, flags[1]), (0, 0))

    # -- scene replacement -----------------------------------------------------
    def test_scene_replacement_resets_the_latch_and_the_candidate(self):
        session, _flags, rig, visits = self.start(
            [self.request_row()], external_rows={0: RECT})
        self.tick(session)
        rig.click()
        self.assertEqual((rig.latch_edge(), rig.state.candidate), (1, 0))
        replacement, replacement_owner = self.open_scene([self.request_row()])
        self.addCleanup(lambda: self.lib.scene_resource_close(replacement))
        self.assertEqual(self.lib.scene_session_replace_scene(
            session, replacement, 11, c.byref(base.SceneSessionFailure())), 0)
        self.assertEqual("reset", rig.calls[-1])
        self.assertEqual(bytes(rig.state.latch), bytes(32))
        self.assertEqual(rig.state.candidate, -1)
        visits.clear()
        _result, pointer = self.tick(session)
        # The pending release belonged to the old scene: nothing activates, and
        # the new scene's scan found its own candidate afterwards.
        self.assertEqual((pointer.activation_event, pointer.candidate_at_consume), (0, -1))
        self.assertEqual(visits, [(0, 0)])
        self.assertEqual(pointer.candidate_after_scan, 0)
        self.assertTrue(replacement_owner)

    def test_a_failed_candidate_replacement_leaves_the_input_state_alone(self):
        session, _flags, rig, _visits = self.start(
            [self.request_row()], external_rows={0: RECT})
        self.tick(session)
        rig.click()
        before = (bytes(rig.state.latch), rig.state.candidate)
        resets = rig.calls.count("reset")
        # A resource whose executor cannot be built fails the replacement;
        # nothing about the old scene may be disturbed.
        bad, bad_owner = self.open_scene([action(0x63, 0, b"opaque")])
        self.addCleanup(lambda: self.lib.scene_resource_close(bad))
        status = self.lib.scene_session_replace_scene(
            session, bad, 12, c.byref(base.SceneSessionFailure()))
        self.assertNotEqual(status, 0)
        self.assertEqual((bytes(rig.state.latch), rig.state.candidate), before)
        self.assertEqual(rig.calls.count("reset"), resets)
        self.assertTrue(bad_owner)

    # -- consume boundary --------------------------------------------------------
    def test_consume_precedes_dispatch_and_follows_a_successful_media_step(self):
        order = []
        session, _flags, rig, visits = self.start(
            [self.request_row()], external_rows={0: RECT})
        rig.on_consume = lambda: order.append(("consume", len(visits)))
        self.tick(session)
        rig.click()
        self.tick(session)
        # Tick 1 consumed before its dispatcher visited the row (0 visits yet),
        # tick 2 consumed after the visits of tick 1.
        self.assertEqual(order, [("consume", 0), ("consume", 1)])
        self.assertEqual(visits, [(0, 0), (0, 2)])

    def test_prepare_or_media_failure_does_not_reach_the_consumer(self):
        block = [False]
        session, _flags, rig, _visits = self.start(
            [self.request_row()], external_rows={0: RECT}, media_block=block)
        self.tick(session)
        rig.click()
        self.assertEqual(rig.latch_edge(), 1)
        block[0] = True
        result, pointer = self.tick(session, SESSION_BLOCKED)
        self.assertEqual(result.failure.stage, base.STAGE_MEDIA)
        self.assertEqual(rig.latch_edge(), 1)  # the release edge was not consumed
        self.assertEqual(pointer.consume_status, -1)
        self.assertEqual(rig.calls.count("consume"), 1)

    def test_modal_event_blocks_activation_but_still_consumes_the_edge(self):
        session, flags, rig, _visits = self.start([self.hotspot(1, 5)])
        self.tick(session)
        rig.click()
        rig.ctx.modal_event = 1
        _result, pointer = self.tick(session)
        # session_input_tick reports the event; the executor's modal gate
        # (43bfd3) rejects it. The edge is gone either way.
        self.assertEqual((pointer.activation_event, flags[1]), (1, 0))
        self.assertEqual(rig.latch_edge(), 0)
        rig.ctx.modal_event = 0
        self.tick(session)
        self.tick(session)
        self.assertEqual(flags[1], 0)  # no deferred replay

    def test_projection_limit_consumes_the_edge_and_clears_the_candidate(self):
        session, flags, rig, _visits = self.start([self.hotspot(1, 5)])
        self.tick(session)
        rig.click()
        rig.ctx.geometry_ready = 0
        result, pointer = self.tick(session)
        self.assertEqual(result.status, SESSION_OK)
        self.assertEqual((pointer.consume_status, pointer.scan_status),
                         (INPUT_LIMIT_GEOMETRY, INPUT_LIMIT_GEOMETRY))
        self.assertEqual((pointer.activation_event, flags[1]), (0, 0))
        self.assertEqual(pointer.candidate_after_scan, -1)
        self.assertEqual(rig.latch_edge(), 0)
        # Restoring readiness cannot replay the lost click.
        rig.ctx.geometry_ready = 1
        _result, pointer = self.tick(session)
        self.assertEqual((pointer.activation_event, flags[1]), (0, 0))

    def test_priority_limit_leaves_no_stale_candidate_for_the_next_release(self):
        session, flags, rig, _visits = self.start([self.hotspot(1, 5)])
        self.tick(session)
        self.assertEqual(rig.state.candidate, 0)
        rig.ctx.priority_clear = 0
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.scan_status, INPUT_LIMIT_PRIORITY)
        self.assertEqual(rig.state.candidate, -1)
        rig.click()
        self.assertEqual(rig.latch_edge(), 0)
        self.assertEqual(flags[1], 0)

    def test_scan_is_not_reached_when_the_tick_ends_in_a_transition(self):
        raw = action(0x15, 1, exe.raw_15_scene_hotspot(0x1900, RECT))
        session, _flags, rig, _visits = self.start([raw], bindings=False)
        self.tick(session)
        self.assertEqual(rig.state.candidate, 0)
        rig.click()
        scans = rig.calls.count("scan")
        result, pointer = self.tick(session, SESSION_TRANSITION)
        self.assertEqual(result.executor.transition.target_scene, 0x1900)
        self.assertEqual(rig.calls.count("scan"), scans)
        self.assertEqual((pointer.activation_event, pointer.scan_status), (1, -1))

    def test_bound_session_ignores_pointer_members_supplied_by_prepare(self):
        def forge(frame):
            frame.contents.hotspot_activation_event = 1
            frame.contents.activation_candidate_valid = 1
            frame.contents.activation_candidate = 0
            frame.contents.pointer_valid = 1

        session, flags, rig, _visits = self.start([self.hotspot(1, 5)], prepare_extra=forge)
        self.tick(session)
        self.tick(session)
        self.assertEqual(flags[1], 0)

        # A host whose consume leaves the frame untouched still cannot inherit
        # the forged event: the session reports what it hands the executor.
        session3, flags3, rig3, _visits3 = self.start(
            [self.hotspot(1, 5)], prepare_extra=forge)
        rig3.consume_override = INPUT_OK
        _result, pointer = self.tick(session3)
        self.assertEqual((pointer.activation_event, pointer.activation_candidate_valid), (0, 0))
        self.assertEqual(flags3[1], 0)

        # Without a bound input module the frame passes through unchanged (the
        # legacy host contract): the same forged event activates row 0.
        session2, flags2, _rig2, _visits2 = self.start(
            [self.hotspot(1, 5)], prepare_extra=forge, bind=False)
        self.tick(session2)
        self.tick(session2)
        self.assertEqual(flags2[1], 5)

    def test_invalid_input_module_status_freezes_at_the_pointer_boundary(self):
        session, _flags, rig, _visits = self.start([self.hotspot(1, 5)])
        rig.consume_override = 1
        result, pointer = self.tick(session, SESSION_BLOCKED)
        self.assertEqual((result.failure.stage, result.failure.provider,
                          result.failure.detail_status),
                         (STAGE_POINTER, PROVIDER_POINTER, 1))
        self.assertEqual(result.dispatch_attempted, 0)
        self.assertEqual(pointer.consume_status, 1)

    def test_binding_validates_its_arguments_and_resets_the_module(self):
        session, _flags, rig, _visits = self.start([self.hotspot(1, 5)], bind=False)
        rig.state.candidate = 7
        incomplete = PointerHost(None, ConsumeFn(), ScanFn(), ResetFn(), ExternalFn())
        self.assertNotEqual(self.lib.scene_session_bind_pointer(session, c.byref(incomplete)), 0)
        self.assertNotEqual(self.lib.scene_session_bind_pointer(session, None), 0)
        self.assertEqual(self.lib.scene_session_bind_pointer(session, c.byref(rig.host)), 0)
        self.assertEqual(rig.state.candidate, -1)  # bind runs the latch constructor
        self.assertEqual(rig.calls[-1], "reset")


if __name__ == "__main__":
    unittest.main()
