"""RT-3: type-0x51 session binding, driven through the real scene session.

The renderer, sound and clock effects are Python callbacks standing in for the
host; the kernel (action_family_51) and the executor are the real C code. The
S5900 row 11 shape (frame text box, AUTOTEXT key CURL00, wait mode 0) is the
anchor case.
"""

from __future__ import annotations

import ctypes as c
import unittest

import session_binding_support as s
from session_binding_support import (
    ActionFn, Binding, MediaFn, PrepareFn, RuntimeState, SceneSessionFailure,
    SceneSessionTickResult, SessionConfig, action, flag_gate, i16, i32,
    make_world, open_scene)

LOOKUP_FOUND, LOOKUP_NOT_FOUND, LOOKUP_ERROR = 0, 1, 2
K_ERR_BODY, K_ERR_LIMIT, K_ERR_UNSUPPORTED, K_ERR_BACKEND = 2, 3, 4, 5
ROW_NOT_A51, ROW_READY, ROW_UNSUPPORTED = 0, 1, 2
SESSION_ERR_EXECUTOR = 5

U8P = c.POINTER(c.c_uint8)
MeasureFn = c.CFUNCTYPE(c.c_int, c.c_void_p, U8P, c.c_size_t, c.POINTER(c.c_int16))
WriteFn = c.CFUNCTYPE(c.c_int, c.c_void_p, U8P, c.c_size_t)
OpenFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32, U8P, c.c_size_t)
CloseFn = c.CFUNCTYPE(c.c_int, c.c_void_p)
PlayingFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int))
TickFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
LookupFn = c.CFUNCTYPE(c.c_int, c.c_void_p, U8P, c.c_size_t,
                       c.POINTER(U8P), c.POINTER(c.c_size_t))


class World51(c.Structure):
    _fields_ = [("timer_deadline", c.c_uint32), ("frame_text_flag", c.c_int32),
                ("caption_finish_flag", c.c_int32)]


WorldHookFn = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(World51))


class Backend51(c.Structure):
    _fields_ = [("context", c.c_void_p), ("measure_caption_lines", MeasureFn),
                ("write_caption", WriteFn), ("open_frame_text", OpenFn),
                ("close_frame_text", CloseFn), ("is_channel_playing", PlayingFn),
                ("tick_count", TickFn)]


class Host51(c.Structure):
    _fields_ = [("backend", Backend51), ("lookup", LookupFn),
                ("lookup_context", c.c_void_p), ("world_context", c.c_void_p),
                ("load_world", WorldHookFn), ("store_world", WorldHookFn)]


def body51(renderer, wait, channel, wait_ms, selector, tail):
    """Typed 0x51 body: five header words, selector, then key/text bytes."""
    head = i16(renderer) + i16(wait) + i16(channel) + i32(wait_ms)
    return head + i16(selector) + tail


def auto_key(key: bytes) -> bytes:
    return key.ljust(33, b"\0")


# S5900 row 11, byte for byte.
S5900_ROW11 = body51(1, 0, 13, 8000, -1, auto_key(b"CURL00"))


class Host:
    """Records every host effect in order."""

    def __init__(self, autotext=None):
        self.log = []
        self.autotext = {b"CURL00": b"<n>"} if autotext is None else autotext
        self.lines = 3
        self.playing = 1
        self.now = 1000
        self.fail = None
        self.lookups = 0
        self.keep = []
        # When set, models the app: the caption backends mutate the shared
        # flags directly, and load/store mirror them (0x5b1602 / 0x5b1606).
        self.shared = None

    def make(self, *, with_lookup=True):
        host = Host51()

        @MeasureFn
        def measure(_c, text, length, out):
            self.log.append(("measure", bytes(text[:length])))
            if self.fail == "measure":
                return 1
            out[0] = self.lines
            return 0

        @WriteFn
        def write(_c, text, length):
            self.log.append(("write", bytes(text[:length])))
            if self.shared is not None:  # caption writer: finish=0, visible=1
                self.shared["finish"], self.shared["visible"] = 0, 1
            return 1 if self.fail == "write" else 0

        @OpenFn
        def open_frame(_c, mode, text, length):
            self.log.append(("open", mode, bytes(text[:length])))
            return 1 if self.fail == "open" else 0

        @CloseFn
        def close_frame(_c):
            self.log.append(("close",))
            return 0

        @PlayingFn
        def playing(_c, channel, out):
            self.log.append(("playing", channel))
            out[0] = self.playing
            return 0

        @TickFn
        def tick(_c, out):
            self.log.append(("tick", self.now))
            out[0] = self.now
            return 0

        @LookupFn
        def lookup(_c, key, key_length, text, text_length):
            self.lookups += 1
            name = bytes(key[:key_length])
            if self.fail == "lookup":
                return LOOKUP_ERROR
            if name not in self.autotext:
                return LOOKUP_NOT_FOUND
            value = self.autotext[name]
            self.value_buffer = (c.c_uint8 * (len(value) + 1))(*value, 0)
            text[0] = c.cast(self.value_buffer, U8P)
            text_length[0] = len(value)
            return LOOKUP_FOUND

        @WorldHookFn
        def load_world(_c, world):
            self.log.append(("load_world",))
            if self.shared is not None:
                world.contents.frame_text_flag = self.shared["visible"]
                world.contents.caption_finish_flag = self.shared["finish"]

        @WorldHookFn
        def store_world(_c, world):
            self.log.append(("store_world", world.contents.frame_text_flag,
                             world.contents.timer_deadline))
            if self.shared is not None:
                self.shared["visible"] = world.contents.frame_text_flag
                self.shared["finish"] = world.contents.caption_finish_flag

        host.backend = Backend51(None, measure, write, open_frame, close_frame,
                                 playing, tick)
        host.lookup = lookup if with_lookup else LookupFn()
        host.load_world = load_world
        host.store_world = store_world
        self.keep += [measure, write, open_frame, close_frame, playing, tick,
                      lookup, load_world, store_world]
        return host

    def effects(self):
        return [entry for entry in self.log
                if entry[0] not in ("load_world", "store_world")]


class A51Fixture:
    def __init__(self, test, lib, actions, host, *, with_lookup=True):
        self.test, self.lib, self.host = test, lib, host
        self.scene, self.scene_owner = open_scene(lib, actions)
        self.flags, self.world, self.conditions = make_world()
        self.host_struct = host.make(with_lookup=with_lookup)
        lib.session_a51_create.argtypes = [c.POINTER(Host51)]
        lib.session_a51_create.restype = c.c_void_p
        lib.session_a51_destroy.argtypes = [c.c_void_p]
        lib.session_a51_begin_scene.argtypes = [
            c.c_void_p, c.c_void_p, c.POINTER(c.c_size_t), c.POINTER(c.c_int)]
        lib.session_a51_begin_scene.restype = c.c_int
        lib.session_a51_last_kernel_status.argtypes = [c.c_void_p]
        lib.session_a51_last_kernel_status.restype = c.c_int
        lib.session_a51_row_state.argtypes = [c.c_void_p, c.c_size_t]
        lib.session_a51_row_state.restype = c.c_int
        lib.session_a51_record_renderer.argtypes = [c.c_void_p, c.c_size_t]
        lib.session_a51_record_renderer.restype = c.c_int
        lib.session_a51_world.argtypes = [c.c_void_p]
        lib.session_a51_world.restype = c.POINTER(World51)
        self.binding = lib.session_a51_create(c.byref(self.host_struct))
        test.assertTrue(self.binding)
        self.failed_row = c.c_size_t(99)
        self.kernel_status = c.c_int(-1)
        self.begin_status = lib.session_a51_begin_scene(
            self.binding, self.scene, c.byref(self.failed_row),
            c.byref(self.kernel_status))

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return s.CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return s.CALLBACK_OK

        handler = ActionFn(("session_a51_handler", lib))
        bindings = (Binding * 1)(Binding(type=0x51, provider=s.PROVIDER_CAPTION,
                                         callback=handler, context=self.binding))
        config = SessionConfig(
            scene=self.scene, scene_id=5900,
            action_core_world=c.pointer(self.world),
            conditions=c.pointer(self.conditions),
            action_bindings=bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media, provider_context=None)
        self.session = c.c_void_p()
        status = lib.scene_session_create(c.byref(config), c.byref(self.session),
                                          c.byref(SceneSessionFailure()))
        test.assertEqual(status, 0)
        self.keep = [prepare, media, handler, bindings, config]

    def rebind_session(self):
        self.lib.scene_session_destroy(self.session)
        bindings = (Binding * 1)(Binding(type=0x51, provider=s.PROVIDER_CAPTION,
                                         callback=self.keep[2],
                                         context=self.binding))
        config = self.keep[4]
        config.action_bindings = bindings
        self.keep.append(bindings)
        self.session = c.c_void_p()
        status = self.lib.scene_session_create(
            c.byref(config), c.byref(self.session), c.byref(SceneSessionFailure()))
        self.test.assertEqual(status, 0)

    def tick(self):
        result = SceneSessionTickResult()
        status = self.lib.scene_session_tick(self.session, c.byref(result))
        return status, result

    def state(self, row=0):
        value = RuntimeState()
        self.test.assertEqual(self.lib.scene_session_get_action_state(
            self.session, row, c.byref(value)), 0)
        return value.completed, value.phase

    def world51(self):
        return self.lib.session_a51_world(self.binding).contents

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a51_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)


class SessionBindingsA51Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = s.load_library(s.build_library())

    def make(self, actions, host=None, **kwargs):
        host = host or Host()
        fixture = A51Fixture(self, self.lib, actions, host, **kwargs)
        self.addCleanup(fixture.close)
        return fixture

    # ---- S5900 row 11 ---------------------------------------------------------

    def test_s5900_row_11_opens_frame_text_box_once_and_never_completes(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        self.assertEqual(fixture.begin_status, 0)
        self.assertEqual(host.lookups, 1)
        for tick in range(5):
            status, _ = fixture.tick()
            self.assertEqual(status, s.SESSION_OK)
        # One open with mode 2 and the AUTOTEXT value plus the "<e>" marker;
        # wait mode 0 never completes, so nothing else is ever called.
        self.assertEqual(host.effects(), [("open", 2, b"<n><e>")])
        self.assertEqual(fixture.state(), (0, 1))
        self.assertEqual(fixture.world51().frame_text_flag, 0)
        self.assertEqual(host.lookups, 1)  # records are built once per scene
        self.assertEqual(self.lib.session_a51_record_renderer(fixture.binding, 0), 1)

    def test_world_hooks_wrap_every_kernel_step(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        fixture.tick()
        kinds = [entry[0] for entry in host.log]
        self.assertEqual(kinds, ["load_world", "open", "load_world", "store_world"])
        # The store sees the kernel's clear of 0x5b1606 (frame_text_flag).
        self.assertEqual(host.log[-1][1], 0)

    # ---- renderer selection and persistent record -------------------------------

    def test_auto_renderer_is_chosen_once_and_the_choice_persists(self):
        host = Host()
        host.lines = 3  # more than two lines selects the frame text box
        fixture = self.make([action(0x51, 1, body51(
            0, 0, 0, 0, -1, auto_key(b"CURL00")))], host)
        self.assertEqual(self.lib.session_a51_record_renderer(fixture.binding, 0), 0)
        fixture.tick()
        fixture.tick()
        self.assertEqual(host.effects(), [("measure", b"<n><e>"),
                                          ("open", 2, b"<n><e>")])
        self.assertEqual(self.lib.session_a51_record_renderer(fixture.binding, 0), 1)

    def test_auto_renderer_with_short_text_writes_the_caption(self):
        host = Host()
        host.lines = 2
        fixture = self.make([action(0x51, 1, body51(
            0, 0, 0, 0, -1, auto_key(b"CURL00")))], host)
        fixture.tick()
        self.assertEqual(host.effects(), [("measure", b"<n><e>"),
                                          ("write", b"<n><e>")])
        self.assertEqual(self.lib.session_a51_record_renderer(fixture.binding, 0), 2)

    def test_backend_side_effects_on_the_shared_caption_flags_survive_the_store(self):
        # After a timed dismiss the shared state is finish=1, visible=0. The
        # caption writer clears finish and sets visible (0x448d11); the
        # binding must not copy its pre-step snapshot back over that.
        host = Host()
        host.lines = 2
        host.shared = {"finish": 1, "visible": 0}
        fixture = self.make([action(0x51, 1, body51(
            0, 0, 0, 0, -1, auto_key(b"CURL00")))], host)
        fixture.tick()
        self.assertEqual(host.shared, {"finish": 0, "visible": 1})

    def test_missing_autotext_key_uses_the_original_error_message(self):
        host = Host(autotext={})
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        fixture.tick()
        (kind, mode, text), = host.effects()
        self.assertEqual((kind, mode), ("open", 2))
        self.assertEqual(
            text, b"Game Error (please contact Tech Support) missing auto text: "
                  b"CURL00<n><e>")

    def test_inline_text_is_read_as_a_c_string_and_needs_no_autotext(self):
        # The loader appends "<e>" after the counted bytes without a NUL of its
        # own, so the inline text carries its NUL inside the count.
        fixture = self.make([action(0x51, 1, body51(2, 0, 0, 0, 6, b"hello\0"))])
        fixture.tick()
        self.assertEqual(fixture.host.effects(), [("write", b"hello")])
        self.assertEqual(fixture.host.lookups, 0)

    def test_inline_text_without_a_nul_is_rejected_not_read_past_the_record(self):
        # The original reads past its allocation here; native code refuses.
        fixture = self.make([action(0x51, 1, body51(2, 0, 0, 0, 5, b"hello"))])
        status, _ = fixture.tick()
        self.assertEqual(status, SESSION_ERR_EXECUTOR)
        self.assertEqual(self.lib.session_a51_last_kernel_status(fixture.binding), K_ERR_BODY)
        self.assertEqual(fixture.host.effects(), [])

    # ---- wait modes and completion ----------------------------------------------

    def test_timer_wait_completes_on_a_later_visit_after_the_deadline(self):
        host = Host()
        fixture = self.make([action(0x51, 1, body51(2, 2, 0, 500, 3, b"hi\0"))], host)
        host.now = 1000
        fixture.tick()
        self.assertEqual(fixture.world51().timer_deadline, 1500)
        self.assertEqual(fixture.state(), (0, 1))
        host.now = 1500  # unsigned "now > deadline": equal does not finish
        fixture.tick()
        self.assertEqual(fixture.state(), (0, 1))
        host.now = 1501
        fixture.tick()
        self.assertEqual(fixture.state(), (0, 2))
        fixture.tick()  # the finish visit completes the row (subtype 1)
        self.assertEqual(fixture.state(), (1, 0))

    def test_sound_wait_finishes_when_the_channel_stops_and_closes_the_frame_box(self):
        host = Host()
        fixture = self.make([action(0x51, 1, body51(1, 1, 13, 0, 3, b"hi\0"))], host)
        host.playing = 1
        fixture.tick()
        self.assertEqual(fixture.state(), (0, 1))
        host.playing = 0
        fixture.tick()
        self.assertEqual(fixture.state(), (0, 2))
        fixture.tick()
        self.assertEqual(fixture.state(), (1, 0))
        self.assertIn(("close",), host.effects())

    def test_subtype_two_finish_reopens_the_row_and_resets_dependencies(self):
        host = Host()
        gate = flag_gate(3)
        rows = [action(0x51, 2, body51(2, 2, 0, 0, 3, b"hi\0")),
                action(0x61, 1, i16(9) + i16(5) + i16(-1) + i16(0), (gate,))]
        fixture = self.make(rows, host)
        fixture.flags[3] = 1
        host.now = 10
        fixture.tick()
        host.now = 11
        fixture.tick()
        fixture.tick()
        self.assertEqual(fixture.state(0), (0, 0))

    # ---- explicit blockers and failures -------------------------------------------

    def test_missing_autotext_provider_is_a_named_blocker_at_the_row(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host, with_lookup=False)
        self.assertEqual(fixture.begin_status, 0)
        self.assertEqual(self.lib.session_a51_row_state(fixture.binding, 0), ROW_UNSUPPORTED)
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_BLOCKED)
        self.assertEqual((result.failure.provider, result.failure.action_index,
                          result.failure.action_type), (s.PROVIDER_CAPTION, 0, 0x51))
        self.assertEqual(self.lib.session_a51_last_kernel_status(fixture.binding),
                         K_ERR_UNSUPPORTED)
        self.assertEqual(host.effects(), [])

    def test_unbound_renderer_callback_is_unsupported_before_any_effect(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        # The binding keeps a copy of the host struct: re-create it without
        # the frame-text callback and run the same scene through it.
        fixture.host_struct.backend.open_frame_text = OpenFn()
        self.lib.session_a51_destroy(fixture.binding)
        fixture.binding = self.lib.session_a51_create(c.byref(fixture.host_struct))
        self.assertEqual(self.lib.session_a51_begin_scene(
            fixture.binding, fixture.scene, None, None), 0)
        # The session still holds the previous binding as handler context;
        # build a fresh session around the new one.
        fixture.rebind_session()
        status, result = fixture.tick()
        self.assertEqual(status, s.SESSION_BLOCKED)
        self.assertEqual(result.failure.action_index, 0)
        self.assertEqual(host.effects(), [])
        self.assertEqual(fixture.state(), (0, 0))

    def test_backend_failure_is_an_executor_error_not_a_silent_skip(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        host.fail = "open"
        status, _ = fixture.tick()
        self.assertEqual(status, SESSION_ERR_EXECUTOR)
        self.assertEqual(fixture.state(), (0, 0))

    def test_autotext_lookup_error_makes_begin_scene_fail_the_scene(self):
        host = Host()
        host.fail = "lookup"
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        self.assertEqual(fixture.begin_status, 3)
        self.assertEqual(fixture.failed_row.value, 0)
        self.assertEqual(fixture.kernel_status.value, K_ERR_BACKEND)

    def test_false_dependency_gate_skips_the_row_without_any_effect(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11, (flag_gate(3),))], host)
        fixture.tick()
        self.assertEqual(host.effects(), [])
        self.assertEqual(fixture.state(), (0, 0))
        fixture.flags[3] = 1
        fixture.tick()
        self.assertEqual(host.effects(), [("open", 2, b"<n><e>")])

    def test_world_globals_persist_across_scene_replacement(self):
        # 0x5bb226 (the shared timed-wait deadline) is a process global: a new
        # scene's record table must not reset it.
        host = Host()
        fixture = self.make([action(0x51, 1, body51(2, 2, 0, 500, 3, b"hi\0"))], host)
        host.now = 1000
        fixture.tick()
        self.assertEqual(fixture.world51().timer_deadline, 1500)
        other, other_owner = open_scene(self.lib, [action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0))])
        try:
            self.assertEqual(self.lib.session_a51_begin_scene(
                fixture.binding, other, None, None), 0)
            self.assertEqual(fixture.world51().timer_deadline, 1500)
        finally:
            self.lib.scene_resource_close(other)
            self.assertTrue(other_owner)

    def test_begin_scene_replaces_records_for_the_next_scene(self):
        host = Host()
        fixture = self.make([action(0x51, 1, S5900_ROW11)], host)
        other, other_owner = open_scene(self.lib, [action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0))])
        try:
            self.assertEqual(self.lib.session_a51_begin_scene(
                fixture.binding, other, None, None), 0)
            self.assertEqual(self.lib.session_a51_row_state(fixture.binding, 0), ROW_NOT_A51)
            self.assertEqual(self.lib.session_a51_record_renderer(fixture.binding, 0), -1)
        finally:
            self.lib.scene_resource_close(other)
            self.assertTrue(other_owner)


if __name__ == "__main__":
    unittest.main()
