"""RT-5: type-0x28 session binding (the 0x44727a leaf), driven through the
real scene session. The scenes are synthetic but shaped like S5900 row 8: one
0x28 row (21-byte payload, one event-flag dependency record)."""

from __future__ import annotations

import ctypes as c
import unittest

import session_binding_support as sbs
import session_exit_support as s
from session_exit_support import payload

BUSY_VIEW = (10, 10, 629, 384)


class A28Fixture:
    def __init__(self, test, lib, subtype=1, body=None, gate_flag=3,
                 gate_value=1, flag_count=16, busy=0):
        s.configure_a28(lib)
        self.test, self.lib = test, lib
        body = payload(2, 500, 2000) if body is None else body
        deps = (sbs.flag_gate(gate_flag, gate_value),) if gate_flag is not None else ()
        self.scene, self.owner = sbs.open_scene(
            lib, [sbs.action(0x28, subtype, body, deps)])
        self.flags, self.world, self.conditions = sbs.make_world(flag_count)
        self.exit = s.Exit()
        view = s.Rect(*BUSY_VIEW)
        test.assertEqual(lib.session_exit_init(c.byref(self.exit), c.byref(view)), 0)
        self.exit.effect.busy = busy
        self.binding = lib.session_a28_create(c.byref(self.exit))
        test.assertTrue(self.binding)

        @sbs.PrepareFn
        def prepare(_c, _cond, _frame, _failure):
            return sbs.CALLBACK_OK

        @sbs.MediaFn
        def media(_c, _frame, _failure):
            return sbs.CALLBACK_OK

        handler = sbs.ActionFn(("session_a28_handler", lib))
        binding = sbs.Binding(type=0x28, provider=9, callback=handler,
                              context=self.binding)
        bindings = (sbs.Binding * 1)(binding)
        config = sbs.SessionConfig(
            scene=self.scene, scene_id=5900,
            action_core_world=c.pointer(self.world),
            conditions=c.pointer(self.conditions),
            action_bindings=bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media, provider_context=None)
        self.session = c.c_void_p()
        failure = sbs.SceneSessionFailure()
        test.assertEqual(lib.scene_session_create(
            c.byref(config), c.byref(self.session), c.byref(failure)), 0)
        self.keep = (prepare, media, handler, bindings, config)

    def tick(self):
        result = sbs.SceneSessionTickResult()
        status = self.lib.scene_session_tick(self.session, c.byref(result))
        return status, result

    def row(self):
        value = sbs.RuntimeState()
        self.test.assertEqual(self.lib.scene_session_get_action_state(
            self.session, 0, c.byref(value)), 0)
        return value.completed, value.phase

    def effect(self):
        e = self.exit.effect
        r = e.current_rect
        return {"busy": e.busy, "stage": e.sequence_counter,
                "rect": (r.left, r.top, r.right, r.bottom),
                "payload": bytes(e.active_payload)}

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a28_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)


class SessionBindingsA28Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = s.load_library(s.build_library())

    def make(self, **kwargs):
        fixture = A28Fixture(self, self.lib, **kwargs)
        self.addCleanup(fixture.close)
        return fixture

    def open_gate(self, f):
        f.flags[3] = 1

    def test_closed_gate_leaves_row_and_effect_untouched(self):
        f = self.make()
        before = f.effect()
        status, _ = f.tick()
        self.assertEqual(status, sbs.SESSION_OK)
        self.assertEqual((f.row(), f.effect()), ((0, 0), before))

    def test_phase0_queues_the_effect_and_enters_phase2(self):
        f = self.make()
        self.open_gate(f)
        status, result = f.tick()
        self.assertEqual(status, sbs.SESSION_OK)
        self.assertEqual(result.executor.actions_applied, 1)
        self.assertEqual(f.row(), (0, 2))
        e = f.effect()
        self.assertEqual(e["busy"], 1)
        self.assertEqual(e["stage"], 0)
        self.assertEqual(e["payload"], payload(2, 500, 2000))
        # zero-sized body rectangle expands to the full VIEW canvas (0x447303)
        self.assertEqual(e["rect"], BUSY_VIEW)

    def test_phase2_completes_the_row_without_ending_the_effect(self):
        f = self.make()
        self.open_gate(f)
        f.tick()
        f.tick()
        self.assertEqual(f.row(), (1, 0))
        self.assertEqual(f.effect()["busy"], 1)       # the visual sequence is not over

    def test_busy_object_defers_the_queue(self):
        f = self.make(busy=1)
        f.exit.effect.active_payload[:] = payload(3, 9, 9)
        f.exit.effect.sequence_counter = 2
        self.open_gate(f)
        before = f.effect()
        for _ in range(3):
            status, _ = f.tick()
            self.assertEqual(status, sbs.SESSION_OK)
            self.assertEqual((f.row(), f.effect()), ((0, 0), before))
        f.exit.effect.busy = 0                          # the controller finished
        f.tick()
        self.assertEqual(f.row(), (0, 2))
        self.assertEqual(f.effect()["payload"], payload(2, 500, 2000))

    def test_nonzero_rect_offsets_the_current_rect(self):
        f = self.make(body=payload(1, 100, 0, (5, 6, 700, 800)))
        f.exit.effect.current_rect = s.Rect(100, 200, 300, 400)
        self.open_gate(f)
        f.tick()
        # 0x447331..0x447373: left += body left, top += body top, right = view
        # left + body right, bottom = view top + body bottom
        self.assertEqual(f.effect()["rect"], (105, 206, 10 + 700, 10 + 800))

    def test_subtype2_resets_dependencies_and_requeues(self):
        f = self.make(subtype=2)
        self.open_gate(f)
        f.tick()
        self.assertEqual(f.row(), (0, 2))
        f.tick()
        self.assertEqual(f.row(), (0, 0))               # not completed, phase 0
        f.exit.effect.busy = 0
        f.tick()                                        # dependency reset: gate open again?
        # 0x42ba3a subtype 2 calls 0x423d33 (dependency reset); the event flag
        # gate itself is unaffected, so the row queues again.
        self.assertEqual(f.row(), (0, 2))

    def test_subtype3_only_clears_the_phase(self):
        f = self.make(subtype=3)
        self.open_gate(f)
        f.tick()
        f.tick()
        self.assertEqual(f.row(), (0, 0))

    def test_wrong_type_and_null_arguments_are_errors(self):
        lib = self.lib
        s.configure_a28(lib)
        x = s.Exit()
        binding = lib.session_a28_create(c.byref(x))
        self.addCleanup(lib.session_a28_destroy, binding)
        handler = lib.session_a28_handler
        handler.argtypes = [c.c_void_p, c.c_size_t, c.c_void_p, c.c_void_p, c.c_void_p]
        handler.restype = c.c_int
        self.assertEqual(handler(binding, 0, None, None, None), 2)   # HANDLER_ERROR
        self.assertEqual(handler(None, 0, None, None, None), 2)
        self.assertFalse(lib.session_a28_create(None))
        self.assertEqual(lib.session_a28_failure_string(2), b"invalid 0x28 body")


if __name__ == "__main__":
    unittest.main()
