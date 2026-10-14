from __future__ import annotations

import ctypes as c
import subprocess
import unittest
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / "build/libsceneexecutor.dylib"

OK = 0
ERR_FORMAT = 4
ERR_UNSUPPORTED = 6
ERR_EXTERNAL = 8
ERR_STATE_MISMATCH = 9
STEP_IDLE = 0
STEP_PROCESSED = 1
STEP_TRANSITION = 2
STEP_STOPPED = 3
HANDLER_PENDING = 0
HANDLER_COMPLETED = 1
HANDLER_ERROR = 2
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


class TransitionRequest(c.Structure):
    _fields_ = [
        ("target_scene", c.c_int16),
        ("opaque_words", c.c_int16 * 3),
        ("opaque_dwords", c.c_int32 * 3),
    ]


class StepInfo(c.Structure):
    _fields_ = [
        ("kind", c.c_int),
        ("actions_considered", c.c_size_t),
        ("actions_applied", c.c_size_t),
        ("failed_action_index", c.c_size_t),
        ("failed_action_type", c.c_uint8),
        ("detail_status", c.c_int),
        ("transition", TransitionRequest),
    ]


class FrameInput(c.Structure):
    _fields_ = [
        ("current_frame", c.c_int32),
        ("pointer_x", c.c_int32),
        ("pointer_y", c.c_int32),
        ("pointer_valid", c.c_uint8),
        ("cursor_context_allowed", c.c_uint8),
        ("modal_event_active", c.c_uint8),
        ("hotspot_activation_event", c.c_uint8),
    ]


class HotspotState(c.Structure):
    _fields_ = [
        ("left", c.c_int32),
        ("top", c.c_int32),
        ("right", c.c_int32),
        ("bottom", c.c_int32),
        ("active", c.c_uint8),
        ("rectangle_valid", c.c_uint8),
        ("runtime_type", c.c_uint8),
    ]


class ActionFamily64World(c.Structure):
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


TickFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))


class ActionFamily64Backend(c.Structure):
    _fields_ = [("context", c.c_void_p), ("get_tick_count", TickFn)]


HandlerFn = c.CFUNCTYPE(
    c.c_int,
    c.c_void_p,
    c.c_size_t,
    c.POINTER(SceneActionInfo),
    c.POINTER(RuntimeState),
    c.POINTER(HandlerResult),
)


class Handler(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("callback", HandlerFn),
        ("context", c.c_void_p),
    ]


def i16(value: int) -> bytes:
    return int(value).to_bytes(2, "little", signed=True)


def i32(value: int) -> bytes:
    return int(value).to_bytes(4, "little", signed=True)


def condition(opcode: int, index: int = 0, expected: int = 0,
              or_after: int = 0) -> bytes:
    fields = (opcode, index, expected, or_after, 0, 0, 0, 0)
    return b"".join(i16(field) for field in fields)


def action(action_type: int, subtype: int, body: bytes,
           dependencies: tuple[bytes, ...] = (), description: bytes = b"test") -> bytes:
    header = description[:48].ljust(48, b"\0") + bytes((action_type, subtype))
    return header + body + b"".join(dependencies)


def chunk(identifier: bytes, payload: bytes) -> bytes:
    value = identifier + len(payload).to_bytes(4, "big") + payload
    return value + (b"\0" if len(payload) & 1 else b"")


def scene_bytes(actions: list[bytes]) -> bytes:
    tsum = bytearray(126)
    tsum[:9] = b"Executor\0"
    tsum[50:61] = b"background\0"
    tsum[83:89] = b"sound\0"
    chunks = [chunk(b"TSUM", bytes(tsum))]
    chunks.extend(chunk(b"ACT\0", item) for item in actions)
    body = b"SCEN" + b"".join(chunks)
    return b"DATA" + len(body).to_bytes(4, "big") + body


def hotspot_6a_body(frame: int, rect: tuple[int, int, int, int],
                    flag_pairs: tuple[tuple[int, int], ...] = ()) -> bytes:
    pairs = list(flag_pairs[:10])
    pairs.extend([(-1, 0)] * (10 - len(pairs)))
    frame_record = i16(frame) + i16(rect[0]) + i16(0) + i16(rect[1]) + \
        i16(0) + i16(rect[2]) + i16(0) + i16(rect[3]) + i16(0)
    return b"".join(i16(index) + i16(value) for index, value in pairs) + \
        i16(1) + frame_record


def raw_15_scene_hotspot(target: int,
                         rect: tuple[int, int, int, int]) -> bytes:
    return bytes((0x0D, 0xFE)) + i16(target) + b"".join(i32(value) for value in rect)


class SceneExecutorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run(
            [str(PROJECT / "scripts/build_scene_executor.sh"), "--test-hooks"],
            check=True,
        )
        cls.lib = c.CDLL(str(LIBRARY))
        cls.lib.scene_resource_open_memory.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t
        ]
        cls.lib.scene_resource_open_memory.restype = c.c_void_p
        cls.lib.scene_resource_close.argtypes = [c.c_void_p]
        cls.lib.scene_executor_create.argtypes = [
            c.c_void_p, c.POINTER(ActionCoreWorld), c.c_size_t,
            c.POINTER(c.c_void_p), c.POINTER(c.c_size_t)
        ]
        cls.lib.scene_executor_create.restype = c.c_int
        cls.lib.scene_executor_destroy.argtypes = [c.c_void_p]
        cls.lib.scene_executor_bind_action64_runtime.argtypes = [
            c.c_void_p, c.POINTER(ActionFamily64World),
            c.POINTER(ActionFamily64Backend)
        ]
        cls.lib.scene_executor_bind_action64_runtime.restype = c.c_int
        cls.lib.scene_executor_step.argtypes = [
            c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(Handler),
            c.c_size_t, c.POINTER(StepInfo)
        ]
        cls.lib.scene_executor_step.restype = c.c_int
        cls.lib.scene_executor_step_frame.argtypes = [
            c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(Handler),
            c.c_size_t, c.POINTER(FrameInput), c.POINTER(StepInfo)
        ]
        cls.lib.scene_executor_step_frame.restype = c.c_int
        cls.lib.scene_executor_get_action_state.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(RuntimeState)
        ]
        cls.lib.scene_executor_get_action_state.restype = c.c_int
        cls.lib.scene_executor_get_hotspot_state.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(HotspotState)
        ]
        cls.lib.scene_executor_get_hotspot_state.restype = c.c_int
        cls.lib.scene_executor_test_condition_node_status.argtypes = [
            c.c_void_p, c.c_size_t, c.c_size_t, c.POINTER(c.c_int32)
        ]
        cls.lib.scene_executor_test_condition_node_status.restype = c.c_int
        cls.lib.scene_executor_request_transition.argtypes = [
            c.c_void_p, c.POINTER(TransitionRequest)
        ]
        cls.lib.scene_executor_request_transition.restype = c.c_int
        cls.lib.scene_resource_action_at.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)
        ]
        cls.lib.scene_resource_action_at.restype = c.c_int

    def open_scene(self, actions):
        data = scene_bytes(actions)
        storage = (c.c_uint8 * len(data)).from_buffer_copy(data)
        error = c.create_string_buffer(256)
        scene = self.lib.scene_resource_open_memory(storage, len(data), error, len(error))
        self.assertTrue(scene, error.value.decode("utf-8", "replace"))
        return scene, storage

    def world(self, flags=None):
        initial = flags if flags is not None else [0] * 8
        array = (c.c_int32 * len(initial))(*initial)
        world = ActionCoreWorld()
        world.event_flags = array
        world.event_flag_count = len(initial)
        return world, array

    @staticmethod
    def condition_state(world, flags=None):
        state = SceneConditionState()
        state.event_flags = flags if flags is not None else world.event_flags
        state.event_flag_count = world.event_flag_count
        return state

    def create_executor(self, scene, world, max_actions=0):
        executor = c.c_void_p()
        failed_index = c.c_size_t((1 << (c.sizeof(c.c_size_t) * 8)) - 1)
        status = self.lib.scene_executor_create(
            scene, c.byref(world), max_actions, c.byref(executor), c.byref(failed_index)
        )
        return status, executor, failed_index.value

    def step(self, executor, state, handlers=None):
        info = StepInfo()
        handler_array = (Handler * len(handlers))(*handlers) if handlers else None
        status = self.lib.scene_executor_step(
            executor, c.byref(state), handler_array, len(handlers or []), c.byref(info)
        )
        return status, info

    def step_frame(self, executor, state, frame_input, handlers=None):
        info = StepInfo()
        handler_array = (Handler * len(handlers))(*handlers) if handlers else None
        status = self.lib.scene_executor_step_frame(
            executor, c.byref(state), handler_array, len(handlers or []),
            c.byref(frame_input), c.byref(info)
        )
        return status, info

    def action_state(self, executor, index):
        state = RuntimeState()
        self.assertEqual(self.lib.scene_executor_get_action_state(
            executor, index, c.byref(state)), OK)
        return state

    def hotspot_state(self, executor, index):
        state = HotspotState()
        self.assertEqual(self.lib.scene_executor_get_hotspot_state(
            executor, index, c.byref(state)), OK)
        return state

    def condition_node_status(self, executor, action_index, node_index):
        status = c.c_int32()
        self.assertEqual(self.lib.scene_executor_test_condition_node_status(
            executor, action_index, node_index, c.byref(status)), OK)
        return status.value

    @staticmethod
    def frame(frame=0, x=0, y=0, *, pointer=False, context=False,
              modal=False, activation=False):
        return FrameInput(frame, x, y, int(pointer), int(context), int(modal),
                          int(activation))

    def test_public_runtime_and_handler_result_abi_layout_is_unchanged(self):
        self.assertEqual([name for name, _kind in RuntimeState._fields_],
                         ["completed", "phase"])
        self.assertEqual([name for name, _kind in HandlerResult._fields_],
                         ["disposition", "phase"])
        self.assertEqual(c.sizeof(RuntimeState), 8)
        self.assertEqual(c.sizeof(HandlerResult), 8)

    def test_action64_clock_write_is_visible_to_later_time_dependency_same_pass(self):
        clock_write = action(0x64, 1, bytes((1,)) + i16(1) + i16(30))
        time_gate_fields = (6, 0, 0, 0, 1, 30, 0, 0)
        time_gate = b"".join(i16(value) for value in time_gate_fields)
        gated_difficulty = action(
            0x71, 2, i16(42) + i16(-1) + i16(0), (time_gate,)
        )
        scene, _storage = self.open_scene([clock_write, gated_difficulty])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        clock_world = ActionFamily64World()
        tick_values = [100]
        tick_calls = []

        @TickFn
        def tick(_context, out_tick):
            tick_calls.append(len(tick_calls))
            out_tick[0] = tick_values.pop(0)
            return 0

        backend = ActionFamily64Backend(None, tick)
        self.assertEqual(self.lib.scene_executor_bind_action64_runtime(
            executor, c.byref(clock_world), c.byref(backend)), OK)
        try:
            state = self.condition_state(world)
            status, info = self.step(executor, state)
            self.assertEqual((status, info.actions_applied), (OK, 2))
            self.assertEqual((clock_world.clock_value_585d51,
                              clock_world.clock_value_585d4f,
                              clock_world.clock_total_585d4b,
                              clock_world.clock_deadline_585d55),
                             (1, 30, 90, 100))
            self.assertEqual(world.difficulty, 42)
            self.assertEqual(len(tick_calls), 1)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_action64_active_controller_uses_two_ticks_and_subtype_two_resets_dependencies(self):
        clock_action = action(0x64, 2, bytes((3,)) + i16(0) + i16(0),
                              (condition(2, 0, 1),))
        scene, _storage = self.open_scene([clock_action])
        world, flags = self.world()
        flags[0] = 1
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        clock_world = ActionFamily64World()
        clock_world.clock_value_585d51 = 5
        clock_world.clock_value_585d4f = 15
        clock_world.clock_total_585d4b = 315
        clock_world.deadline_offset_5b0280 = 20
        clock_world.timer_controller_active_001c = 1
        ticks = iter((100, 120))
        tick_calls = []

        @TickFn
        def tick(_context, out_tick):
            tick_calls.append(1)
            out_tick[0] = next(ticks)
            return 0

        backend = ActionFamily64Backend(None, tick)
        self.assertEqual(self.lib.scene_executor_bind_action64_runtime(
            executor, c.byref(clock_world), c.byref(backend)), OK)
        try:
            status, info = self.step(executor, self.condition_state(world))
            runtime = self.action_state(executor, 0)
            self.assertEqual((status, info.actions_applied,
                              runtime.completed, runtime.phase), (OK, 1, 0, 0))
            self.assertEqual((clock_world.timer_controller_tick_0456,
                              clock_world.timer_controller_flag_0326_0061c6ad,
                              clock_world.clock_total_585d4b,
                              clock_world.clock_deadline_585d55),
                             (95, 1, 315, 140))
            self.assertEqual(len(tick_calls), 2)
            self.assertEqual(self.condition_node_status(executor, 0, 0), 0)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_action64_tick_failure_does_not_commit_clock_or_action_state(self):
        clock_action = action(0x64, 1, bytes((3,)) + i16(0) + i16(0))
        scene, _storage = self.open_scene([clock_action])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        clock_world = ActionFamily64World()
        clock_world.clock_value_585d51 = 6
        clock_world.clock_value_585d4f = 20
        clock_world.clock_total_585d4b = 380
        clock_world.timer_controller_active_001c = 1
        before = bytes(clock_world)
        calls = []

        @TickFn
        def failing_tick(_context, out_tick):
            calls.append(1)
            if len(calls) == 2:
                return 2
            out_tick[0] = 500
            return 0

        backend = ActionFamily64Backend(None, failing_tick)
        self.assertEqual(self.lib.scene_executor_bind_action64_runtime(
            executor, c.byref(clock_world), c.byref(backend)), OK)
        try:
            status, info = self.step(executor, self.condition_state(world))
            runtime = self.action_state(executor, 0)
            self.assertEqual((status, info.actions_applied,
                              info.failed_action_index, info.detail_status),
                             (ERR_EXTERNAL, 0, 0, 4))
            self.assertEqual((runtime.completed, runtime.phase), (0, 0))
            self.assertEqual(bytes(clock_world), before)
            self.assertEqual(len(calls), 2)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_6a_hotspot_needs_cached_hit_then_accepted_event_and_is_repeatable(self):
        rect = (10, 20, 30, 40)
        body = hotspot_6a_body(0, rect, ((2, 7),))
        scene, _storage = self.open_scene([action(0x6A, 2, body)])
        world, flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            # The frame match exports the rectangle, but does not run effects.
            status, info = self.step_frame(executor, state, self.frame())
            hotspot = self.hotspot_state(executor, 0)
            self.assertEqual((status, info.actions_applied), (OK, 1))
            self.assertEqual((hotspot.active, hotspot.rectangle_valid,
                              hotspot.runtime_type), (1, 1, 0x6A))
            self.assertEqual((hotspot.left, hotspot.top,
                              hotspot.right, hotspot.bottom), rect)
            self.assertEqual((flags[2], self.action_state(executor, 0).phase),
                             (0, 1))

            # A hover scan caches a candidate. Repeating the same cursor scan
            # without an accepted event cannot activate it.
            hit = self.frame(x=rect[0], y=rect[1], pointer=True, context=True)
            status, info = self.step_frame(executor, state, hit)
            self.assertEqual((status, info.actions_applied), (OK, 1))
            self.assertEqual((flags[2], self.action_state(executor, 0).phase),
                             (0, 1))

            # The next accepted input event consumes the cached candidate
            # before this tick's dispatcher; phase 2 effects run this tick.
            activation = self.frame(activation=True)
            status, info = self.step_frame(executor, state, activation)
            runtime = self.action_state(executor, 0)
            self.assertEqual((status, info.actions_applied), (OK, 1))
            self.assertEqual((flags[2], runtime.completed, runtime.phase),
                             (7, 0, 0))

            # Subtype 2 reset returns the hotspot to phase 0 so it can re-arm.
            status, _ = self.step_frame(executor, state, self.frame())
            runtime = self.action_state(executor, 0)
            self.assertEqual(status, OK)
            self.assertEqual((runtime.completed, runtime.phase), (0, 1))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_6a_frame_gate_modal_gate_dependencies_and_candidate_expiry(self):
        rect = (10, 20, 30, 40)
        body = hotspot_6a_body(3, rect, ((1, 5),))
        scene, _storage = self.open_scene([
            action(0x6A, 2, body, (condition(2, 0, 1),))
        ])
        world, flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            status, _ = self.step_frame(
                executor, state,
                self.frame(2, x=20, y=30, pointer=True, context=True),
            )
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 0)

            # Frame 3 is a match but the condition blocks the executor.
            status, _ = self.step_frame(
                executor, state,
                self.frame(3, x=20, y=30, pointer=True, context=True),
            )
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 0)

            flags[0] = 1
            status, _ = self.step_frame(
                executor, state,
                self.frame(3, x=rect[2], y=rect[3], pointer=True, context=True),
            )
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 1)

            # RT-4 review (0x43bff8..0x43c054): a hotspot without opcode-11
            # leaves has an empty chain (0x42405a == 0), so the accepted event
            # stores phase 2 WITHOUT re-evaluating the tree. The dependency is
            # false now, so the row pass does not run the phase-2 effects yet.
            flags[0] = 0
            status, _ = self.step_frame(
                executor, state, self.frame(3, activation=True)
            )
            self.assertEqual(status, OK)
            self.assertEqual((flags[1], self.action_state(executor, 0).phase),
                             (0, 2))
            # Once the gate opens the pending phase 2 runs its effects.
            flags[0] = 1
            status, _ = self.step_frame(executor, state, self.frame(3))
            self.assertEqual(status, OK)
            self.assertEqual(flags[1], 5)
            flags[1] = 0
            status, _ = self.step_frame(executor, state, self.frame(3))
            self.assertEqual((status, self.action_state(executor, 0).phase), (OK, 1))
            flags[0] = 0

            # Pointer geometry is ignored outside the caller-supplied cursor
            # context even when the rectangle itself is active.
            status, _ = self.step_frame(
                executor, state,
                self.frame(3, x=rect[2], y=rect[3], pointer=True, context=False),
            )
            self.assertEqual(status, OK)
            status, _ = self.step_frame(executor, state,
                                        self.frame(3, activation=True))
            self.assertEqual(status, OK)
            self.assertEqual((flags[1], self.action_state(executor, 0).phase),
                             (0, 1))

            # Restore eligibility and recapture the inclusive bottom-right
            # edge, then block the next event with the modal guard.
            flags[0] = 1
            status, _ = self.step_frame(
                executor, state,
                self.frame(3, x=rect[2], y=rect[3], pointer=True, context=True),
            )
            self.assertEqual(status, OK)
            status, _ = self.step_frame(
                executor, state, self.frame(3, modal=True, activation=True)
            )
            self.assertEqual(status, OK)
            self.assertEqual(self.action_state(executor, 0).phase, 1)
            status, _ = self.step_frame(executor, state,
                                        self.frame(3, activation=True))
            self.assertEqual(status, OK)
            self.assertEqual((flags[1], self.action_state(executor, 0).phase),
                             (0, 1))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_raw_15_hotspot_with_dependencies_uses_typed_body_boundary(self):
        raw_body = raw_15_scene_hotspot(6400, (10, 20, 30, 40))
        scene, _storage = self.open_scene([
            action(0x15, 1, raw_body, (condition(2, 0, 1),))
        ])
        world, flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            status, _ = self.step_frame(executor, state, self.frame())
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 0)
            flags[0] = 1
            status, _ = self.step_frame(executor, state,
                self.frame(0, x=10, y=20, pointer=True, context=True))
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 1)
            status, info = self.step_frame(executor, state, self.frame(0, activation=True))
            self.assertEqual((status, info.kind, info.transition.target_scene),
                             (OK, STEP_TRANSITION, 6400))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_raw_15_0d_scene_hotspot_keeps_raw_body_and_delays_transition(self):
        raw_rect = (65546, -65516, 196638, -65496)
        rect = (10, 20, 30, 40)
        raw_body = raw_15_scene_hotspot(0x1900, raw_rect)
        scene, _storage = self.open_scene([action(0x15, 1, raw_body)])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            raw_action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(
                scene, 0, c.byref(raw_action)), OK)
            self.assertEqual(raw_action.type, 0x15)
            self.assertEqual(raw_action.raw_body_length, 20)
            self.assertEqual(c.string_at(raw_action.raw_body, 20), raw_body)

            state = self.condition_state(world)
            # Phase 0 exports the raw-body rectangle then uses loader frame 0.
            status, info = self.step_frame(executor, state, self.frame(1))
            hotspot = self.hotspot_state(executor, 0)
            self.assertEqual((status, info.kind), (OK, STEP_PROCESSED))
            self.assertEqual((self.action_state(executor, 0).phase,
                              hotspot.active, hotspot.rectangle_valid,
                              hotspot.runtime_type), (1, 0, 1, 0x0D))
            self.assertEqual((hotspot.left, hotspot.top,
                              hotspot.right, hotspot.bottom), rect)

            # Phase 1 now matches frame zero; matching still only exposes the
            # rectangle and never synthesizes phase 2.
            status, _ = self.step_frame(
                executor, state,
                self.frame(0, x=rect[0], y=rect[1], pointer=True, context=True),
            )
            self.assertEqual(status, OK)
            self.assertEqual(self.hotspot_state(executor, 0).active, 1)
            self.assertEqual(self.action_state(executor, 0).phase, 1)

            status, idle = self.step_frame(
                executor, state,
                self.frame(0, x=rect[0], y=rect[1], pointer=True, context=True),
            )
            self.assertEqual((status, idle.kind), (OK, STEP_PROCESSED))
            self.assertEqual(self.action_state(executor, 0).phase, 1)

            status, transition = self.step_frame(
                executor, state, self.frame(0, activation=True)
            )
            self.assertEqual((status, transition.kind,
                              transition.actions_applied),
                             (OK, STEP_TRANSITION, 1))
            self.assertEqual(transition.transition.target_scene, 0x1900)
            self.assertEqual(list(transition.transition.opaque_words), [0, 0, 1])
            self.assertEqual(list(transition.transition.opaque_dwords), [0, 0, 1])
            self.assertEqual(self.action_state(executor, 0).completed, 1)
            status, stopped = self.step_frame(executor, state, self.frame())
            self.assertEqual((status, stopped.kind), (OK, STEP_STOPPED))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_raw_15_phase_zero_enters_phase_one_and_checks_frame_immediately(self):
        rect = (391, 75, 490, 138)
        raw_body = raw_15_scene_hotspot(0x1900, rect)
        scene, _storage = self.open_scene([action(0x15, 1, raw_body)])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            status, _ = self.step_frame(executor, state, self.frame(0))
            hotspot = self.hotspot_state(executor, 0)
            self.assertEqual(status, OK)
            self.assertEqual(self.action_state(executor, 0).phase, 1)
            self.assertEqual((hotspot.active, hotspot.rectangle_valid), (1, 1))
            self.assertEqual((hotspot.left, hotspot.top,
                              hotspot.right, hotspot.bottom), rect)

            status, _ = self.step_frame(executor, state, self.frame(1))
            self.assertEqual(status, OK)
            self.assertEqual(self.action_state(executor, 0).phase, 1)
            self.assertEqual(self.hotspot_state(executor, 0).active, 0)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_external_handler_transition_request_commits_after_success_only(self):
        rows = [action(0x82, 1, bytes(41)),
                action(0x4D, 1, bytes((0, 1)) + i16(123))]
        scene, _storage = self.open_scene(rows)
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        request = TransitionRequest()
        request.target_scene = -9
        request.opaque_words[:] = [2, -3, 4]
        request.opaque_dwords[:] = [0x1020304, -5, 6]
        callback_status = []
        calls = []

        @HandlerFn
        def handler(_context, _index, _action_info, _state_before, result):
            calls.append(1)
            callback_status.append(self.lib.scene_executor_request_transition(
                executor, c.byref(request)
            ))
            if len(calls) == 1:
                return HANDLER_ERROR
            result.contents.disposition = HANDLER_PENDING
            return 0

        registry = Handler(0x82, handler, None)
        try:
            state = self.condition_state(world)
            status, failed = self.step(executor, state, [registry])
            self.assertEqual((status, failed.kind, failed.failed_action_index),
                             (ERR_EXTERNAL, STEP_IDLE, 0))
            self.assertEqual(self.action_state(executor, 0).phase, 0)
            self.assertEqual(world.short_values[0], 0)

            status, transitioned = self.step(executor, state, [registry])
            self.assertEqual((status, transitioned.kind,
                              transitioned.actions_applied),
                             (OK, STEP_TRANSITION, 1))
            self.assertEqual(transitioned.transition.target_scene, -9)
            self.assertEqual(list(transitioned.transition.opaque_words),
                             [2, -3, 4])
            self.assertEqual(list(transitioned.transition.opaque_dwords),
                             [0x1020304, -5, 6])
            self.assertEqual(world.short_values[0], 0)
            self.assertEqual(callback_status, [OK, OK])
            status, stopped = self.step(executor, state, [registry])
            self.assertEqual((status, stopped.kind), (OK, STEP_STOPPED))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_9f_subtype_two_blocked_pass_preserves_latched_dependency_results(self):
        body = bytearray(48)
        body[46:48] = i16(0)
        scene, _storage = self.open_scene([
            action(0x9F, 2, bytes(body), (
                condition(2, 0, 1, 1),
                condition(2, 1, 1),
                condition(2, 2, 1),
            ))
        ])
        world, flags = self.world([1, 0, 1])
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)

        @HandlerFn
        def pending(_context, _index, _action_info, _state_before, result):
            result.contents.disposition = HANDLER_PENDING
            result.contents.phase = 17
            return 0

        registry = Handler(0x9F, pending, None)
        try:
            state = self.condition_state(world)
            status, _ = self.step(executor, state, [registry])
            self.assertEqual(status, OK)
            self.assertEqual(self.action_state(executor, 0).phase, 17)
            self.assertEqual([self.condition_node_status(executor, 0, node)
                              for node in (1, 2, 3)], [1, 1, 1])

            flags[2] = 0
            status, info = self.step(executor, state, [registry])
            runtime = self.action_state(executor, 0)
            self.assertEqual((status, info.actions_applied,
                              runtime.completed, runtime.phase), (OK, 0, 0, 0))
            # The condition evaluator retains the OR-latched source results;
            # the original blocked path clears only completion and phase.
            self.assertEqual([self.condition_node_status(executor, 0, node)
                              for node in (1, 2, 3)], [1, 1, 0])
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_9f_subtype_one_keeps_phase_when_dependency_is_blocked(self):
        body = bytearray(48)
        body[46:48] = i16(0)
        scene, _storage = self.open_scene([
            action(0x9F, 1, bytes(body), (condition(2, 0, 1),))
        ])
        world, flags = self.world()
        flags[0] = 1
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)

        @HandlerFn
        def pending(_context, _index, _action_info, _state_before, result):
            result.contents.disposition = HANDLER_PENDING
            result.contents.phase = 17
            return 0

        registry = Handler(0x9F, pending, None)
        try:
            state = self.condition_state(world)
            status, _ = self.step(executor, state, [registry])
            self.assertEqual(status, OK)
            flags[0] = 0
            status, info = self.step(executor, state, [registry])
            runtime = self.action_state(executor, 0)
            self.assertEqual((status, info.actions_applied,
                              runtime.completed, runtime.phase),
                             (OK, 0, 0, 17))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_same_pass_flag_write_unlocks_later_difficulty_in_table_order(self):
        flag_writer = action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0))
        gated_difficulty = action(
            0x71, 2, i16(42) + i16(-1) + i16(0), (condition(2, 0, 1),)
        )
        scene, _storage = self.open_scene([flag_writer, gated_difficulty])
        world, flags = self.world()
        status, executor, failed_index = self.create_executor(scene, world)
        self.assertEqual((status, failed_index),
                         (OK, c.c_size_t(-1).value))
        try:
            state = self.condition_state(world)
            status, info = self.step(executor, state)
            self.assertEqual((status, info.kind, info.actions_applied),
                             (OK, STEP_PROCESSED, 2))
            self.assertEqual((flags[0], world.difficulty), (1, 42))
            self.assertEqual(self.action_state(executor, 1).completed, 1)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_reverse_order_dependency_observes_flag_on_following_tick(self):
        gated_difficulty = action(
            0x71, 1, i16(17) + i16(-1) + i16(0), (condition(2, 0, 1),)
        )
        flag_writer = action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0))
        scene, _storage = self.open_scene([gated_difficulty, flag_writer])
        world, flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            status, first = self.step(executor, state)
            self.assertEqual(status, OK)
            self.assertEqual((first.kind, first.actions_applied), (STEP_PROCESSED, 1))
            self.assertEqual((flags[0], world.difficulty), (1, 0))
            status, second = self.step(executor, state)
            self.assertEqual(status, OK)
            self.assertEqual((second.kind, second.actions_applied), (STEP_PROCESSED, 1))
            self.assertEqual(world.difficulty, 17)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_subtype_two_repeats_core_effect_and_resets_phase(self):
        # SET_VALUE: slot 0, add mode, signed increment 2.
        repeating = action(0x4D, 2, bytes((0, 0)) + i16(2))
        scene, _storage = self.open_scene([repeating])
        world, _flags = self.world()
        world.short_values[0] = 1
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            state = self.condition_state(world)
            for expected in (3, 5):
                status, info = self.step(executor, state)
                self.assertEqual((status, info.actions_applied), (OK, 1))
                self.assertEqual(world.short_values[0], expected)
                runtime = self.action_state(executor, 0)
                self.assertEqual((runtime.completed, runtime.phase), (0, 0))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_or_dependency_scene_change_preserves_payload_and_stops_the_pass(self):
        change_body = i16(-123) + i16(4) + i16(-5) + i16(6) + \
            i32(-0x1234567) + i32(0x1020304) + i32(-7)
        change = action(0x0A, 1, change_body,
                        (condition(2, 0, 1, 1), condition(2, 1, 1)))
        later = action(0x4D, 1, bytes((0, 1)) + i16(900))
        scene, _storage = self.open_scene([change, later])
        world, _flags = self.world([0, 1] + [0] * 6)
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            status, info = self.step(executor, self.condition_state(world))
            self.assertEqual((status, info.kind, info.actions_applied),
                             (OK, STEP_TRANSITION, 1))
            self.assertEqual(info.transition.target_scene, -123)
            self.assertEqual(list(info.transition.opaque_words), [4, -5, 6])
            self.assertEqual(list(info.transition.opaque_dwords),
                             [-0x1234567, 0x1020304, -7])
            self.assertEqual(self.action_state(executor, 0).completed, 1)
            self.assertEqual(self.action_state(executor, 1).completed, 0)
            self.assertEqual(world.short_values[0], 0)
            status, stopped = self.step(executor, self.condition_state(world))
            self.assertEqual((status, stopped.kind, stopped.actions_applied),
                             (OK, STEP_STOPPED, 0))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_unknown_typed_action_without_handler_is_explicit_and_inert(self):
        # Type 0x15 has a recovered body boundary but no execution handler yet.
        scene, _storage = self.open_scene([action(0x15, 1, bytes(range(20)))])
        world, flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        try:
            status, info = self.step(executor, self.condition_state(world))
            self.assertEqual((status, info.failed_action_index,
                              info.failed_action_type), (ERR_UNSUPPORTED, 0, 0x15))
            self.assertEqual((info.actions_applied, world.difficulty, list(flags)),
                             (0, 0, [0] * 8))
            self.assertEqual(self.action_state(executor, 0).completed, 0)
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_registered_external_handler_advances_phase_then_completes(self):
        scene, _storage = self.open_scene([action(0x15, 1, bytes(range(20)))])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        calls = []

        @HandlerFn
        def handler(_context, index, action_info, state_before, result):
            calls.append((index, action_info.contents.type,
                          state_before.contents.phase))
            if len(calls) == 1:
                result.contents.disposition = HANDLER_PENDING
                result.contents.phase = 9
            else:
                result.contents.disposition = HANDLER_COMPLETED
                result.contents.phase = 0
            return 0

        registry = Handler(0x15, handler, None)
        try:
            state = self.condition_state(world)
            status, first = self.step(executor, state, [registry])
            self.assertEqual((status, first.kind), (OK, STEP_PROCESSED))
            self.assertEqual((self.action_state(executor, 0).completed,
                              self.action_state(executor, 0).phase), (0, 9))
            status, second = self.step(executor, state, [registry])
            self.assertEqual((status, second.kind), (OK, STEP_PROCESSED))
            self.assertEqual((self.action_state(executor, 0).completed,
                              self.action_state(executor, 0).phase), (1, 0))
            self.assertEqual(calls, [(0, 0x15, 0), (0, 0x15, 9)])
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_external_completion_preserves_handler_supplied_phase(self):
        scene, _storage = self.open_scene([action(0x15, 1, bytes(range(20)))])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)

        @HandlerFn
        def handler(_context, _index, _action_info, _state_before, result):
            result.contents.disposition = HANDLER_COMPLETED
            result.contents.phase = 23
            return 0

        registry = Handler(0x15, handler, None)
        try:
            status, info = self.step(executor, self.condition_state(world), [registry])
            self.assertEqual((status, info.kind), (OK, STEP_PROCESSED))
            runtime = self.action_state(executor, 0)
            self.assertEqual((runtime.completed, runtime.phase), (1, 23))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_direct_external_completion_ignores_repeat_subtype_and_preserves_phase(self):
        scene, _storage = self.open_scene([action(0x82, 2, bytes(41))])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        calls = []

        @HandlerFn
        def handler(_context, _index, _action_info, _state_before, result):
            calls.append(1)
            result.contents.disposition = HANDLER_DIRECT_COMPLETED
            result.contents.phase = 23
            return 0

        registry = Handler(0x82, handler, None)
        try:
            state = self.condition_state(world)
            status, first = self.step(executor, state, [registry])
            self.assertEqual((status, first.actions_applied), (OK, 1))
            runtime = self.action_state(executor, 0)
            self.assertEqual((runtime.completed, runtime.phase), (1, 23))
            status, second = self.step(executor, state, [registry])
            self.assertEqual((status, second.actions_applied), (OK, 0))
            self.assertEqual(calls, [1])
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_opaque_action_fails_creation_without_fake_eligibility(self):
        scene, _storage = self.open_scene([action(0xFE, 1, b"opaque")])
        world, _flags = self.world()
        status, executor, failed_index = self.create_executor(scene, world)
        self.assertEqual((status, executor.value, failed_index),
                         (ERR_UNSUPPORTED, None, 0))
        self.lib.scene_resource_close(scene)

    def test_invalid_dependency_tree_fails_creation_and_cleans_partial_state(self):
        # A close record without an opener is a malformed condition encoding.
        malformed = action(0x4D, 1, bytes((0, 1)) + i16(3), (condition(0x13),))
        scene, _storage = self.open_scene([malformed])
        world, _flags = self.world()
        status, executor, failed_index = self.create_executor(scene, world)
        self.assertEqual((status, executor.value, failed_index), (ERR_FORMAT, None, 0))
        self.lib.scene_resource_close(scene)

    def test_truncated_fixed_body_is_rejected_by_resource_parser(self):
        raw = scene_bytes([action(0x4D, 1, b"\x00\x01\x02")])
        storage = (c.c_uint8 * len(raw)).from_buffer_copy(raw)
        error = c.create_string_buffer(256)
        scene = self.lib.scene_resource_open_memory(storage, len(raw), error, len(error))
        self.assertFalse(scene)
        self.assertIn(b"invalid ACT", error.value)

    def test_event_flag_view_must_borrow_the_world_storage(self):
        scene, _storage = self.open_scene([action(0x4D, 1, bytes((0, 1)) + i16(3))])
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        other_flags = (c.c_int32 * 8)(*([0] * 8))
        try:
            status, info = self.step(executor, self.condition_state(world, other_flags))
            self.assertEqual((status, info.actions_applied), (ERR_STATE_MISMATCH, 0))
        finally:
            self.lib.scene_executor_destroy(executor)
            self.lib.scene_resource_close(scene)

    def test_default_action_cap_is_120_and_explicit_cap_can_be_240(self):
        actions = [action(0x4D, 1, bytes((0, 1)) + i16(1)) for _ in range(121)]
        scene, _storage = self.open_scene(actions)
        world, _flags = self.world()
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, 3)
        self.assertFalse(executor.value)
        status, executor, _ = self.create_executor(scene, world, 240)
        self.assertEqual(status, OK)
        self.lib.scene_executor_destroy(executor)
        self.lib.scene_resource_close(scene)

    def test_real_s0_action_table_can_build_without_scene_specific_rules(self):
        path = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/0800.bin"
        raw = path.read_bytes()
        storage = (c.c_uint8 * len(raw)).from_buffer_copy(raw)
        error = c.create_string_buffer(256)
        scene = self.lib.scene_resource_open_memory(storage, len(raw), error, len(error))
        self.assertTrue(scene, error.value.decode("utf-8", "replace"))
        world, _flags = self.world()
        status, executor, failed_index = self.create_executor(scene, world)
        self.assertEqual((status, failed_index), (OK, c.c_size_t(-1).value))
        self.lib.scene_executor_destroy(executor)
        self.lib.scene_resource_close(scene)


if __name__ == "__main__":
    unittest.main()
