"""Persistent ownership, tick ordering, freeze and transition-boundary tests."""

from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libscenesession.dylib"

SESSION_OK = 0
SESSION_TRANSITION = 1
SESSION_BLOCKED = 2
CALLBACK_OK = 0
CALLBACK_BLOCKED = 1
PROVIDER_NONE = 0
PROVIDER_WORLD_CLOCK = 1
PROVIDER_MEDIA = 4
PROVIDER_ACTION_SOUND = 7
PROVIDER_A62 = 10
PROVIDER_CAPTION = 8
STAGE_PREPARE = 1
STAGE_MEDIA = 2
STAGE_DISPATCH = 3
EXECUTOR_OK = 0
EXECUTOR_UNSUPPORTED = 6
HANDLER_OK = 0
HANDLER_PENDING = 0
HANDLER_DIRECT_COMPLETED = 3


class ActionCoreWorld(c.Structure):
    _fields_ = [
        ("short_values", c.c_int16 * 30),
        ("float_values", c.c_float * 10),
        ("difficulty", c.c_int16),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
    ]


class SceneConditionState(c.Structure):
    _fields_ = [
        ("inventory_presence", c.POINTER(c.c_int32)),
        ("inventory_count", c.c_size_t),
        ("selected_inventory_item", c.c_int32),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
        ("value_table", c.POINTER(c.c_int32)),
        ("value_count", c.c_size_t),
        ("scene_visit_counts", c.POINTER(c.c_int16)),
        ("scene_visit_count", c.c_size_t),
        ("timer_4_value", c.c_int32),
        ("timer_5_value", c.c_int32),
        ("time_of_day_minutes", c.c_int32),
    ]


class SceneExecutorFrameInput(c.Structure):
    _fields_ = [
        ("current_frame", c.c_int32),
        ("pointer_x", c.c_int32),
        ("pointer_y", c.c_int32),
        ("pointer_valid", c.c_uint8),
        ("cursor_context_allowed", c.c_uint8),
        ("modal_event_active", c.c_uint8),
        ("hotspot_activation_event", c.c_uint8),
        ("activation_candidate_valid", c.c_uint8),
        ("activation_candidate", c.c_int32),
    ]


class SceneTransitionRequest(c.Structure):
    _fields_ = [
        ("target_scene", c.c_int16),
        ("opaque_words", c.c_int16 * 3),
        ("opaque_dwords", c.c_int32 * 3),
    ]


class SceneExecutorStepInfo(c.Structure):
    _fields_ = [
        ("kind", c.c_int),
        ("actions_considered", c.c_size_t),
        ("actions_applied", c.c_size_t),
        ("failed_action_index", c.c_size_t),
        ("failed_action_type", c.c_uint8),
        ("detail_status", c.c_int),
        ("transition", SceneTransitionRequest),
    ]


class SceneSessionFailure(c.Structure):
    _fields_ = [
        ("stage", c.c_int),
        ("provider", c.c_int),
        ("action_index", c.c_size_t),
        ("action_type", c.c_uint8),
        ("detail_status", c.c_int),
    ]


class SceneSessionTickResult(c.Structure):
    _fields_ = [
        ("status", c.c_int),
        ("failure", SceneSessionFailure),
        ("executor", SceneExecutorStepInfo),
        ("tick_index", c.c_uint64),
        ("scene_generation", c.c_uint64),
        ("prepare_attempted", c.c_uint8),
        ("prepare_succeeded", c.c_uint8),
        ("media_attempted", c.c_uint8),
        ("media_succeeded", c.c_uint8),
        ("dispatch_attempted", c.c_uint8),
        ("dispatch_succeeded", c.c_uint8),
    ]


class ActionUIControlGroup(c.Structure):
    _fields_ = [
        ("state", c.c_int32),
        ("starts", c.c_int16 * 50),
        ("ends", c.c_int16 * 50),
        ("codes", c.c_int32 * 50),
        ("availability", c.c_int32),
        ("flags", c.c_int32 * 3),
    ]


class ActionUIWorld(c.Structure):
    _fields_ = [
        ("phone_records", c.POINTER(c.c_uint8 * 41)),
        ("phone_count", c.c_size_t),
        ("phone_capacity", c.c_size_t),
        ("nls_mode", c.c_uint8),
        ("controls", ActionUIControlGroup * 5),
    ]


class SceneActionInfo(c.Structure):
    _fields_ = [
        ("description", c.c_char * 49),
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("payload_kind", c.c_int),
        ("raw_body", c.POINTER(c.c_uint8)),
        ("raw_body_length", c.c_size_t),
        ("typed_body", c.POINTER(c.c_uint8)),
        ("typed_body_length", c.c_size_t),
        ("dependency_records", c.POINTER(c.c_uint8)),
        ("dependency_count", c.c_size_t),
    ]


class RuntimeState(c.Structure):
    _fields_ = [("completed", c.c_uint8), ("phase", c.c_uint32)]


class HandlerResult(c.Structure):
    _fields_ = [("disposition", c.c_int), ("phase", c.c_uint32)]


class Action64World(c.Structure):
    _fields_ = [
        ("clock_value_585d51", c.c_int16),
        ("clock_value_585d4f", c.c_int16),
        ("clock_total_585d4b", c.c_int32),
        ("clock_deadline_585d55", c.c_uint32),
        ("deadline_offset_5b0280", c.c_int16),
        ("timer_controller_active_001c", c.c_uint32),
        ("timer_controller_tick_0456", c.c_uint32),
        ("timer_controller_flag_0326_0061c6ad", c.c_uint8),
    ]


Action64TickFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
WorldCommitFn = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(Action64World))


class Action64Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("get_tick_count", Action64TickFn)]


PrepareFn = c.CFUNCTYPE(c.c_int, c.c_void_p,
                         c.POINTER(SceneConditionState),
                         c.POINTER(SceneExecutorFrameInput),
                         c.POINTER(SceneSessionFailure))
MediaFn = c.CFUNCTYPE(c.c_int, c.c_void_p,
                      c.POINTER(SceneExecutorFrameInput),
                      c.POINTER(SceneSessionFailure))
ActionFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_size_t,
                       c.POINTER(SceneActionInfo), c.POINTER(RuntimeState),
                       c.POINTER(HandlerResult))


PreGateFn = c.CFUNCTYPE(None, c.c_void_p, c.c_size_t,
                        c.POINTER(SceneActionInfo), c.POINTER(RuntimeState))


class Binding(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("provider", c.c_int),
        ("callback", ActionFn),
        ("context", c.c_void_p),
    ]


class SessionConfig(c.Structure):
    _fields_ = [
        ("scene", c.c_void_p),
        ("scene_id", c.c_int32),
        ("action_core_world", c.POINTER(ActionCoreWorld)),
        ("conditions", c.POINTER(SceneConditionState)),
        ("action64_world", c.POINTER(Action64World)),
        ("action64_backend", c.POINTER(Action64Backend)),
        ("initial_phone_rows", c.POINTER(c.c_uint8 * 41)),
        ("initial_phone_count", c.c_size_t),
        ("action_bindings", c.POINTER(Binding)),
        ("action_binding_count", c.c_size_t),
        ("prepare_tick", PrepareFn),
        ("advance_media_one", MediaFn),
        ("provider_context", c.c_void_p),
        ("action64_world_commit_observer", WorldCommitFn),
        ("action64_world_commit_context", c.c_void_p),
    ]


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


def i32(value: int) -> bytes:
    return int(value).to_bytes(4, "little", signed=True)


def action(action_type: int, subtype: int, body: bytes,
           dependencies: tuple[bytes, ...] = ()) -> bytes:
    return (b"session test".ljust(48, b"\0") +
            bytes((action_type, subtype)) + body + b"".join(dependencies))


def chunk(identifier: bytes, payload: bytes) -> bytes:
    value = identifier + len(payload).to_bytes(4, "big") + payload
    return value + (b"\0" if len(payload) & 1 else b"")


def scene_bytes(actions: list[bytes]) -> bytes:
    tsum = bytearray(126)
    tsum[:8] = b"Session\0"
    tsum[50:61] = b"background\0"
    tsum[83:89] = b"sound\0"
    body = b"SCEN" + b"".join([chunk(b"TSUM", bytes(tsum))] +
                               [chunk(b"ACT\0", item) for item in actions])
    return b"DATA" + len(body).to_bytes(4, "big") + body


def phone(key: bytes, name: bytes) -> bytes:
    assert len(key) == 11 and len(name) < 20
    return b"\x0a\x00" + key + name + bytes(20 - len(name)) + b"\x33" * 8


class SceneSessionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_scene_session.sh")], check=True)
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.scene_resource_open_memory.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t
        ]
        cls.lib.scene_resource_open_memory.restype = c.c_void_p
        cls.lib.scene_resource_close.argtypes = [c.c_void_p]
        cls.lib.scene_session_create.argtypes = [
            c.POINTER(SessionConfig), c.POINTER(c.c_void_p),
            c.POINTER(SceneSessionFailure)
        ]
        cls.lib.scene_session_create.restype = c.c_int
        cls.lib.scene_session_destroy.argtypes = [c.c_void_p]
        cls.lib.scene_session_tick.argtypes = [
            c.c_void_p, c.POINTER(SceneSessionTickResult)
        ]
        cls.lib.scene_session_tick.restype = c.c_int
        cls.lib.scene_session_get_action_state.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(RuntimeState)
        ]
        cls.lib.scene_session_replace_scene.argtypes = [
            c.c_void_p, c.c_void_p, c.c_int32, c.POINTER(SceneSessionFailure)
        ]
        cls.lib.scene_session_replace_scene.restype = c.c_int
        cls.lib.scene_session_get_action_ui.argtypes = [c.c_void_p]
        cls.lib.scene_session_get_action_ui.restype = c.POINTER(ActionUIWorld)
        cls.lib.scene_session_get_pending_transition.argtypes = [
            c.c_void_p, c.POINTER(SceneTransitionRequest)
        ]
        cls.lib.scene_session_get_pending_transition.restype = c.c_int
        cls.lib.scene_session_scene_generation.argtypes = [c.c_void_p]
        cls.lib.scene_session_scene_generation.restype = c.c_uint64
        cls.lib.scene_session_tick_count.argtypes = [c.c_void_p]
        cls.lib.scene_session_tick_count.restype = c.c_uint64

    def open_scene(self, actions):
        raw = scene_bytes(actions)
        owner = (c.c_uint8 * len(raw)).from_buffer_copy(raw)
        error = c.create_string_buffer(256)
        scene = self.lib.scene_resource_open_memory(owner, len(raw), error, len(error))
        self.assertTrue(scene, error.value.decode())
        return scene, owner

    def make_world(self):
        flags = (c.c_int32 * 16)()
        world = ActionCoreWorld()
        world.event_flags = flags
        world.event_flag_count = len(flags)
        conditions = SceneConditionState()
        conditions.event_flags = flags
        conditions.event_flag_count = len(flags)
        return flags, world, conditions

    def create_session(self, scene, world, conditions, *, prepare, media,
                       initial_rows=None, bindings=None, action64_world=None,
                       action64_backend=None, world_commit_observer=None,
                       world_commit_context=None):
        row_type = c.c_uint8 * 41
        if initial_rows:
            initial = (row_type * len(initial_rows)).from_buffer_copy(b"".join(initial_rows))
        else:
            initial = None
        binding_array = (Binding * len(bindings))(*bindings) if bindings else None
        config = SessionConfig(
            scene=scene,
            scene_id=10,
            action_core_world=c.pointer(world),
            conditions=c.pointer(conditions),
            action64_world=(c.pointer(action64_world)
                            if action64_world is not None else None),
            action64_backend=(c.pointer(action64_backend)
                              if action64_backend is not None else None),
            initial_phone_rows=c.cast(initial, c.POINTER(row_type)) if initial else None,
            initial_phone_count=len(initial_rows or []),
            action_bindings=binding_array,
            action_binding_count=len(bindings or []),
            prepare_tick=prepare,
            advance_media_one=media,
            provider_context=None,
            action64_world_commit_observer=(world_commit_observer
                                            if world_commit_observer is not None
                                            else WorldCommitFn()),
            action64_world_commit_context=world_commit_context,
        )
        session = c.c_void_p()
        failure = SceneSessionFailure()
        status = self.lib.scene_session_create(c.byref(config), c.byref(session),
                                               c.byref(failure))
        self.assertEqual(status, 0, (failure.stage, failure.provider, failure.detail_status))
        self.assertTrue(session.value)
        return session, initial, binding_array

    def test_missing_clock_provider_freezes_once_before_media_or_dispatch(self):
        # With no prepare callback, the session must expose the unresolved
        # clock boundary and never call media/ACT on subsequent ticks.
        scene, scene_owner = self.open_scene([action(0x61, 1, i16(0) + i16(9) + i16(-1) + i16(0))])
        _flags, world, conditions = self.make_world()
        counts = {"media": 0}

        @MediaFn
        def media(_context, _frame, _failure):
            counts["media"] += 1
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=PrepareFn(), media=media)
        try:
            first = SceneSessionTickResult()
            second = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(first)), SESSION_BLOCKED)
            self.assertEqual(first.failure.stage, STAGE_PREPARE)
            self.assertEqual(first.failure.provider, PROVIDER_WORLD_CLOCK)
            self.assertEqual(first.prepare_attempted, 1)
            self.assertEqual(first.prepare_succeeded, 0)
            self.assertEqual(first.media_attempted, 0)
            self.assertEqual(first.dispatch_attempted, 0)
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(second)), SESSION_BLOCKED)
            self.assertEqual(second.tick_index, first.tick_index)
            self.assertEqual(self.lib.scene_session_tick_count(session), 1)
            self.assertEqual(counts["media"], 0)
            self.assertEqual(list(world.event_flags[:1]), [0])
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(scene_owner)

    def test_prepare_cannot_replace_authoritative_event_flag_storage(self):
        scene, owner = self.open_scene([
            action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0))
        ])
        flags, world, conditions = self.make_world()
        replacement_flags = (c.c_int32 * len(flags))()
        counts = {"media": 0}

        @PrepareFn
        def prepare(_context, state, _frame, _failure):
            state.contents.event_flags = replacement_flags
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            counts["media"] += 1
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media)
        try:
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_BLOCKED)
            self.assertEqual((result.failure.stage, result.failure.provider),
                             (STAGE_PREPARE, 14))  # host storage invariant
            self.assertEqual(result.media_attempted, 0)
            self.assertEqual(result.dispatch_attempted, 0)
            self.assertEqual(counts["media"], 0)
            self.assertEqual(list(flags[:1]), [0])
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner)

    def test_action64_commit_observer_precedes_later_time_gated_row(self):
        clock_write = action(0x64, 1, bytes((1,)) + i16(1) + i16(30))
        # Opcode 6, comparison >=, boundary 01:30. The A-64 row changes the
        # same-pass dispatch clock from zero to 90 minutes before this row.
        time_gate = b"".join(i16(value) for value in (6, 0, 0, 0, 0, 1, 30, 0))
        gated_caption = action(0x51, 1, bytes(10) + i16(0), (time_gate,))
        scene, owner = self.open_scene([clock_write, gated_caption])
        _flags, world, conditions = self.make_world()
        calls = {"tick": 0, "mirror": [], "caption": []}

        @Action64TickFn
        def tick(_context, out_tick):
            calls["tick"] += 1
            out_tick[0] = 100
            return 0

        clock_world = Action64World()
        clock_world.deadline_offset_5b0280 = -7
        backend = Action64Backend(None, tick)

        @WorldCommitFn
        def mirror(_context, updated):
            value = updated.contents
            calls["mirror"].append((value.clock_value_585d51,
                                    value.clock_value_585d4f,
                                    value.clock_total_585d4b,
                                    value.clock_deadline_585d55))

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return CALLBACK_OK

        @ActionFn
        def caption(_context, _index, _action, before, result):
            calls["caption"].append((list(calls["mirror"][-1]),
                                     before.contents.phase))
            result.contents.disposition = HANDLER_DIRECT_COMPLETED
            result.contents.phase = before.contents.phase
            return HANDLER_OK

        binding = Binding(type=0x51, provider=PROVIDER_CAPTION,
                          callback=caption, context=None)
        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media,
            bindings=[binding], action64_world=clock_world,
            action64_backend=backend, world_commit_observer=mirror)
        try:
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(result.executor.actions_applied, 2)
            self.assertEqual(calls["tick"], 1)
            self.assertEqual(calls["mirror"], [(1, 30, 90, 93)])
            self.assertEqual(calls["caption"], [([1, 30, 90, 93], 0)])
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner)

    def test_action64_observer_survives_scene_replacement_and_respects_gate(self):
        empty_scene, empty_owner = self.open_scene([])
        gated_clock = action(0x64, 1,
                             bytes((1,)) + i16(1) + i16(30),
                             (i16(2) + i16(0) + i16(1) + i16(0) + bytes(8),))
        accepted_clock = action(0x64, 1,
                                bytes((1,)) + i16(1) + i16(30))
        target_scene, target_owner = self.open_scene([gated_clock, accepted_clock])
        flags, world, conditions = self.make_world()
        clock_world = Action64World()
        ticks = []

        @Action64TickFn
        def tick(_context, out_tick):
            ticks.append(1)
            out_tick[0] = 100
            return 0

        backend = Action64Backend(None, tick)
        commits = []

        @WorldCommitFn
        def mirror(_context, updated):
            commits.append(updated.contents.clock_total_585d4b)

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            empty_scene, world, conditions, prepare=prepare, media=media,
            action64_world=clock_world, action64_backend=backend,
            world_commit_observer=mirror)
        try:
            failure = SceneSessionFailure()
            self.assertEqual(self.lib.scene_session_replace_scene(
                session, target_scene, 11, c.byref(failure)), 0)
            self.lib.scene_resource_close(empty_scene)
            empty_scene = None
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            # Event flag 0 is zero, so the first row is rejected before the
            # host tick source. The second row proves the observer/context was
            # rebound to the replacement executor and survives the old scene.
            self.assertEqual(result.executor.actions_applied, 1)
            self.assertEqual(ticks, [1])
            self.assertEqual(commits, [90])
            self.assertEqual(flags[0], 0)
        finally:
            self.lib.scene_session_destroy(session)
            if empty_scene:
                self.lib.scene_resource_close(empty_scene)
            self.lib.scene_resource_close(target_scene)
            self.assertTrue(empty_owner and target_owner)

    def test_same_session_pending_action_phase_survives_two_ticks(self):
        scene, scene_owner = self.open_scene([action(0x51, 1, bytes(10) + i16(0))])
        _flags, world, conditions = self.make_world()
        calls = {"prepare": 0, "media": 0, "handler": 0}

        @PrepareFn
        def prepare(_context, _conditions, frame, _failure):
            calls["prepare"] += 1
            frame.contents.current_frame = calls["prepare"]
            return CALLBACK_OK

        @MediaFn
        def media(_context, frame, _failure):
            calls["media"] += 1
            frame.contents.current_frame += 100
            return CALLBACK_OK

        @ActionFn
        def handler(_context, _index, _action, before, result):
            calls["handler"] += 1
            if before.contents.phase == 0:
                result.contents.disposition = HANDLER_PENDING
                result.contents.phase = 7
            else:
                result.contents.disposition = HANDLER_DIRECT_COMPLETED
                result.contents.phase = before.contents.phase
            return HANDLER_OK

        binding = Binding(type=0x51, provider=PROVIDER_CAPTION,
                          callback=handler, context=None)
        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media,
            bindings=[binding])
        try:
            first = SceneSessionTickResult()
            second = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(first)), SESSION_OK)
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(second)), SESSION_OK)
            self.assertEqual((first.tick_index, second.tick_index), (1, 2))
            self.assertEqual((first.scene_generation, second.scene_generation), (1, 1))
            self.assertEqual(first.executor.actions_applied, 1)
            self.assertEqual(second.executor.actions_applied, 1)
            state = RuntimeState()
            self.assertEqual(self.lib.scene_session_get_action_state(session, 0, c.byref(state)), 0)
            self.assertEqual((state.completed, state.phase), (1, 7))
            self.assertEqual(calls, {"prepare": 2, "media": 2, "handler": 2})
            third = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(third)), SESSION_OK)
            self.assertEqual(calls["handler"], 2)
            self.assertEqual(self.lib.scene_session_tick_count(session), 3)
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(scene_owner)

    def test_missing_media_provider_blocks_after_prepare_before_dispatch(self):
        scene, owner = self.open_scene([action(0x61, 1,
                                               i16(0) + i16(23) + i16(-1) + i16(0))])
        flags, world, conditions = self.make_world()
        calls = {"prepare": 0}

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            calls["prepare"] += 1
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=MediaFn())
        try:
            first = SceneSessionTickResult()
            second = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(first)), SESSION_BLOCKED)
            self.assertEqual(first.failure.stage, STAGE_MEDIA)
            self.assertEqual(first.failure.provider, PROVIDER_MEDIA)
            self.assertEqual(first.prepare_succeeded, 1)
            self.assertEqual(first.media_attempted, 1)
            self.assertEqual(first.dispatch_attempted, 0)
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(second)), SESSION_BLOCKED)
            self.assertEqual(calls["prepare"], 1)
            self.assertEqual(flags[0], 0)
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner)

    def test_failed_candidate_replacement_keeps_old_executor_live(self):
        scene, old_owner = self.open_scene([action(0x51, 1, bytes(10) + i16(0))])
        opaque_scene, bad_owner = self.open_scene([action(0x63, 0, b"opaque")])
        _flags, world, conditions = self.make_world()
        calls = {"handler": 0}

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return CALLBACK_OK

        @ActionFn
        def handler(_context, _index, _action, before, result):
            calls["handler"] += 1
            if before.contents.phase == 0:
                result.contents.disposition = HANDLER_PENDING
                result.contents.phase = 9
            else:
                result.contents.disposition = HANDLER_DIRECT_COMPLETED
                result.contents.phase = 9
            return HANDLER_OK

        binding = Binding(type=0x51, provider=PROVIDER_CAPTION,
                          callback=handler, context=None)
        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media,
            bindings=[binding])
        try:
            first = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(first)), SESSION_OK)
            state = RuntimeState()
            self.assertEqual(self.lib.scene_session_get_action_state(session, 0, c.byref(state)), 0)
            self.assertEqual((state.completed, state.phase), (0, 9))
            failure = SceneSessionFailure()
            self.assertNotEqual(self.lib.scene_session_replace_scene(
                session, opaque_scene, 12, c.byref(failure)), 0)
            self.assertEqual(failure.provider, 13)  # scene-resource parser/executor bound
            self.assertEqual(self.lib.scene_session_scene_generation(session), 1)
            second = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(second)), SESSION_OK)
            self.assertEqual(calls["handler"], 2)
            self.assertEqual(self.lib.scene_session_get_action_state(session, 0, c.byref(state)), 0)
            self.assertEqual((state.completed, state.phase), (1, 9))
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.lib.scene_resource_close(opaque_scene)
            self.assertTrue(old_owner and bad_owner)

    def test_partial_world_effect_survives_first_unresolved_eligible_action(self):
        set_flag = action(0x61, 1,
                          i16(0) + i16(17) + i16(-1) + i16(0))
        sound = action(0x9F, 0, bytes(46) + b"\0\0")
        scene, owner = self.open_scene([set_flag, sound])
        flags, world, conditions = self.make_world()
        counts = {"prepare": 0, "media": 0}

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            counts["prepare"] += 1
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            counts["media"] += 1
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media)
        try:
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)), SESSION_BLOCKED)
            self.assertEqual(result.failure.stage, STAGE_DISPATCH)
            self.assertEqual(result.failure.provider, PROVIDER_ACTION_SOUND)
            self.assertEqual(result.failure.action_index, 1)
            self.assertEqual(result.failure.action_type, 0x9F)
            self.assertEqual(result.executor.actions_applied, 1)
            self.assertEqual(flags[0], 17)
            first_action = RuntimeState()
            self.assertEqual(self.lib.scene_session_get_action_state(
                session, 0, c.byref(first_action)), 0)
            self.assertEqual(first_action.completed, 1)
            before = (counts["prepare"], counts["media"], flags[0])
            repeated = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(repeated)), SESSION_BLOCKED)
            self.assertEqual((counts["prepare"], counts["media"], flags[0]), before)
            self.assertEqual(repeated.failure.action_index, 1)
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner)

    def test_ui_state_survives_scene_executor_replacement_and_old_scene_close(self):
        initial = phone(b"i" * 11, b"Initial")
        inserted = phone(b"n" * 11, b"New number")
        scene, old_owner = self.open_scene([action(0x82, 0, inserted)])
        replacement, new_owner = self.open_scene([])
        _flags, world, conditions = self.make_world()

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return CALLBACK_OK

        session, initial_owner, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media,
            initial_rows=[initial])
        try:
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)), SESSION_OK)
            ui = self.lib.scene_session_get_action_ui(session).contents
            self.assertEqual(ui.phone_count, 2)
            self.assertEqual(self.lib.scene_session_replace_scene(
                session, replacement, 11, c.byref(SceneSessionFailure())), 0)
            self.assertEqual(self.lib.scene_session_scene_generation(session), 2)
            self.assertEqual(self.lib.scene_session_get_action_ui(session).contents.phone_count, 2)
            # The old scene may be destroyed after replace_scene returns; later
            # ticks must use the new executor and retained process UI state.
            self.lib.scene_resource_close(scene)
            scene = None
            result2 = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result2)), SESSION_OK)
            self.assertEqual(result2.scene_generation, 2)
            self.assertEqual(self.lib.scene_session_get_action_ui(session).contents.phone_count, 2)
        finally:
            self.lib.scene_session_destroy(session)
            if scene:
                self.lib.scene_resource_close(scene)
            self.lib.scene_resource_close(replacement)
            self.assertTrue(old_owner and new_owner and initial_owner)

    def test_transition_preserves_entire_tuple_and_stops_repeated_tick(self):
        body = i16(5900) + i16(2) + i16(-3) + i16(4) + i32(0x12345678) + i32(-99) + i32(77)
        scene, owner = self.open_scene([action(0x0A, 0, body)])
        _flags, world, conditions = self.make_world()
        calls = {"prepare": 0, "media": 0}

        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            calls["prepare"] += 1
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            calls["media"] += 1
            return CALLBACK_OK

        session, _initial, _bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media)
        target_scene, target_owner = self.open_scene([])
        try:
            first = SceneSessionTickResult()
            second = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(first)), SESSION_TRANSITION)
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(second)), SESSION_TRANSITION)
            self.assertEqual(calls, {"prepare": 1, "media": 1})
            request = SceneTransitionRequest()
            self.assertEqual(self.lib.scene_session_get_pending_transition(session, c.byref(request)), 1)
            self.assertEqual(request.target_scene, 5900)
            self.assertEqual(list(request.opaque_words), [2, -3, 4])
            self.assertEqual(list(request.opaque_dwords), [0x12345678, -99, 77])
            failure = SceneSessionFailure()
            self.assertEqual(self.lib.scene_session_replace_scene(
                session, target_scene, 5899, c.byref(failure)), 3)
            self.assertEqual(failure.provider, 13)
            self.assertEqual(self.lib.scene_session_get_pending_transition(
                session, c.byref(request)), 1)
            self.assertEqual(self.lib.scene_session_replace_scene(
                session, target_scene, 5900, c.byref(failure)), 0)
            self.assertEqual(self.lib.scene_session_scene_generation(session), 2)
            self.assertEqual(self.lib.scene_session_get_pending_transition(
                session, c.byref(request)), 0)
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.lib.scene_resource_close(target_scene)
            self.assertTrue(owner and target_owner)

    # ---- RT-3: type-0x62 pre-gate request clear and candidate accept -------

    @staticmethod
    def a62_body(selector_word=0):
        # 12-byte prefix (ids -1/-1, threshold 0, count 1) + one 18-byte entry.
        return (i16(-1) + i16(0) + i16(-1) + i16(0) + i16(0) + i16(1) +
                i16(selector_word) + bytes(16))

    @staticmethod
    def flag_gate(flag_id, value=1):
        return b"".join(i16(v) for v in (2, flag_id, value, 0, 0, 0, 0, 0))

    def a62_session(self, scene, world, conditions, handler):
        @PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return CALLBACK_OK

        @MediaFn
        def media(_context, _frame, _failure):
            return CALLBACK_OK

        binding = Binding(type=0x62, provider=PROVIDER_A62, callback=handler,
                          context=None)
        session, initial, bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media,
            bindings=[binding])
        self.lib.scene_session_set_pre_gate.argtypes = [
            c.c_void_p, c.c_uint8, PreGateFn, c.c_void_p]
        self.lib.scene_session_set_pre_gate.restype = c.c_int
        self.lib.scene_session_accept_action_candidate.argtypes = [
            c.c_void_p, c.c_size_t]
        self.lib.scene_session_accept_action_candidate.restype = c.c_int
        return session, (prepare, media, binding, initial, bindings)

    def test_pre_gate_runs_before_the_dependency_gate_of_its_type_only(self):
        # 0x427a50 clears the row's request dword before it evaluates the
        # dependency tree, so a false gate still leaves the clear behind.
        scene, owner = self.open_scene([
            action(0x62, 1, self.a62_body(), (self.flag_gate(5),)),
            action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0)),
        ])
        flags, world, conditions = self.make_world()
        order = []

        @ActionFn
        def handler(_context, index, _action, before, result):
            order.append(("handler", index, before.contents.phase))
            result.contents.disposition = HANDLER_PENDING
            result.contents.phase = 1
            return HANDLER_OK

        @PreGateFn
        def pre_gate(_context, index, info, state):
            order.append(("pre", index, info.contents.type,
                          state.contents.completed, state.contents.phase))

        session, keep = self.a62_session(scene, world, conditions, handler)
        try:
            self.assertEqual(self.lib.scene_session_set_pre_gate(
                session, 0x62, pre_gate, None), 0)
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            # Gate false: pre-gate ran, handler did not; the 0x61 row is not a
            # registered type and never reaches the hook.
            self.assertEqual(order, [("pre", 0, 0x62, 0, 0)])
            self.assertEqual(list(flags[:1]), [7])
            flags[5] = 1
            order.clear()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(order, [("pre", 0, 0x62, 0, 0),
                                     ("handler", 0, 0)])
            order.clear()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(order, [("pre", 0, 0x62, 0, 1),
                                     ("handler", 0, 1)])
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner and keep)

    def test_pre_gate_skips_completed_rows_and_survives_scene_replacement(self):
        scene, owner = self.open_scene([action(0x62, 1, self.a62_body())])
        replacement, replacement_owner = self.open_scene([
            action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0)),
            action(0x62, 1, self.a62_body()),
        ])
        _flags, world, conditions = self.make_world()
        order = []

        @ActionFn
        def handler(_context, index, _action, before, result):
            order.append(("handler", index))
            result.contents.disposition = HANDLER_DIRECT_COMPLETED
            result.contents.phase = 0
            return HANDLER_OK

        @PreGateFn
        def pre_gate(_context, index, _info, _state):
            order.append(("pre", index))

        session, keep = self.a62_session(scene, world, conditions, handler)
        try:
            self.assertEqual(self.lib.scene_session_set_pre_gate(
                session, 0x62, pre_gate, None), 0)
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(order, [("pre", 0), ("handler", 0)])
            order.clear()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(order, [])  # completed rows get no request clear
            self.assertEqual(self.lib.scene_session_replace_scene(
                session, replacement, 11, c.byref(SceneSessionFailure())), 0)
            self.lib.scene_resource_close(scene)
            scene = None
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(order, [("pre", 1), ("handler", 1)])
            # Duplicate type registrations and null callbacks are rejected.
            self.assertNotEqual(self.lib.scene_session_set_pre_gate(
                session, 0x62, PreGateFn(), None), 0)
        finally:
            self.lib.scene_session_destroy(session)
            if scene:
                self.lib.scene_resource_close(scene)
            self.lib.scene_resource_close(replacement)
            self.assertTrue(owner and replacement_owner and keep)

    def test_accept_candidate_stores_phase_two_for_the_next_handler_visit(self):
        # 0x43c054 stores 2 into the candidate row's phase dword; the handler
        # then runs with that phase on the same scene tick that follows.
        scene, owner = self.open_scene([action(0x62, 1, self.a62_body())])
        _flags, world, conditions = self.make_world()
        seen = []

        @ActionFn
        def handler(_context, _index, _action, before, result):
            seen.append(before.contents.phase)
            if before.contents.phase == 2:
                result.contents.disposition = HANDLER_DIRECT_COMPLETED
                result.contents.phase = 0
            else:
                result.contents.disposition = HANDLER_PENDING
                result.contents.phase = 1
            return HANDLER_OK

        session, keep = self.a62_session(scene, world, conditions, handler)
        try:
            result = SceneSessionTickResult()
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(self.lib.scene_session_accept_action_candidate(session, 0), 0)
            state = RuntimeState()
            self.assertEqual(self.lib.scene_session_get_action_state(
                session, 0, c.byref(state)), 0)
            self.assertEqual((state.completed, state.phase), (0, 2))
            self.assertEqual(self.lib.scene_session_tick(session, c.byref(result)),
                             SESSION_OK)
            self.assertEqual(seen, [0, 2])
            self.assertEqual(self.lib.scene_session_get_action_state(
                session, 0, c.byref(state)), 0)
            self.assertEqual((state.completed, state.phase), (1, 0))
            # Out-of-range rows are rejected without touching any state.
            self.assertNotEqual(self.lib.scene_session_accept_action_candidate(session, 1), 0)
        finally:
            self.lib.scene_session_destroy(session)
            self.lib.scene_resource_close(scene)
            self.assertTrue(owner and keep)


if __name__ == "__main__":
    unittest.main()
