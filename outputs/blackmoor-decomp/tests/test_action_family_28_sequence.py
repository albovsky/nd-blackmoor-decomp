"""A-28.3.2 controller contract and callback-order regressions."""
import ctypes as c
from pathlib import Path
import subprocess
import unittest

BUILD_DIR = Path(__file__).resolve().parents[1] / "build"
LIBRARY = BUILD_DIR / "libactionfamily28.dylib"
DIVISION_FIXTURE_SOURCE = Path(__file__).with_name(
    "action_family_28_x87_division_fixture.c")
DIVISION_FIXTURE_LIBRARY = BUILD_DIR / "libactionfamily28_x87_division_fixture.dylib"
OK, ARGUMENT, BODY, UNSUPPORTED, BOUNDS, MEMORY, CALLBACK = range(7)
CW_DOUBLE, CW_EXTENDED = 0x027F, 0x037F
FAIL_NONE, FAIL_TICK, FAIL_BLEND, FAIL_PUMP = range(4)


class Rect(c.Structure):
    _fields_ = [(name, c.c_int32) for name in ("left", "top", "right", "bottom")]


class Capture(c.Structure):
    _fields_ = [("data", c.POINTER(c.c_uint8)), ("byte_length", c.c_size_t)]


class SequenceState(c.Structure):
    _fields_ = [
        ("subtype", c.c_uint8), ("busy", c.c_uint8),
        ("render_guard", c.c_uint8), ("redraw_flag", c.c_uint8),
        ("sequence_budget_ms", c.c_int16), ("pause_ms", c.c_int16),
        ("target_rect", Rect), ("source_capture", Capture),
        ("destination_capture", Capture),
        ("capture_width_pixels", c.c_size_t),
        ("capture_height_pixels", c.c_size_t),
        ("capture_stride_pixels", c.c_size_t),
        ("capture_offset_x_pixels", c.c_size_t),
        ("capture_offset_y_pixels", c.c_size_t),
        ("primary_target", c.c_uint8), ("stage", c.c_uint32),
        ("scene_state", c.c_uint32), ("finalizer_global_5831c8", c.c_uint32),
        ("finalizer_global_5831c6", c.c_uint16),
    ]


class SequenceFrame(c.Structure):
    _fields_ = [
        ("frame_index", c.c_uint32), ("weight", c.c_double),
        ("x87_control_word", c.c_uint16), ("target_rect", Rect),
        ("source_capture", Capture), ("destination_capture", Capture),
        ("capture_width_pixels", c.c_size_t),
        ("capture_height_pixels", c.c_size_t),
        ("capture_stride_pixels", c.c_size_t),
        ("capture_offset_x_pixels", c.c_size_t),
        ("capture_offset_y_pixels", c.c_size_t),
        ("primary_target", c.c_uint8),
    ]


GetTick = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
BlendPresent = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(SequenceFrame))
SystemPump = c.CFUNCTYPE(c.c_int, c.c_void_p)


class Callbacks(c.Structure):
    _fields_ = [("context", c.c_void_p), ("get_tick_count", GetTick),
                ("blend_present", BlendPresent), ("system_audio_pump", SystemPump)]


class Report(c.Structure):
    _fields_ = [
        ("selected_frame_count", c.c_int32),
        ("planned_frame_count", c.c_uint32),
        ("first_frame_elapsed_ms", c.c_uint32),
        ("get_tick_calls", c.c_uint32),
        ("blend_present_calls", c.c_uint32),
        ("system_audio_pump_calls", c.c_uint32),
        ("completed_frame_count", c.c_uint32),
        ("failed_frame_index", c.c_uint32),
        ("failed_callback", c.c_uint8),
        ("completion_committed", c.c_uint8),
        ("callback_status", c.c_int32),
    ]


class Harness:
    def __init__(self, ticks, fail_at=None):
        self.ticks = list(ticks)
        self.tick_index = 0
        self.events = []
        self.fail_at = fail_at
        self.frames = []

        @GetTick
        def get_tick(_context, out):
            self.events.append(("tick", self.tick_index))
            if self.fail_at == (FAIL_TICK, self.tick_index):
                return 101 + self.tick_index
            value = self.ticks[min(self.tick_index, len(self.ticks) - 1)]
            self.tick_index += 1
            out[0] = value
            return 0

        @BlendPresent
        def blend(_context, frame_ptr):
            frame = frame_ptr.contents
            snapshot = {
                "frame_index": frame.frame_index,
                "weight": frame.weight,
                "cw": frame.x87_control_word,
                "rect": tuple(getattr(frame.target_rect, key)
                               for key in ("left", "top", "right", "bottom")),
                "source": c.cast(frame.source_capture.data, c.c_void_p).value,
                "destination": c.cast(frame.destination_capture.data, c.c_void_p).value,
                "source_bytes": frame.source_capture.byte_length,
                "destination_bytes": frame.destination_capture.byte_length,
                "capture": (frame.capture_width_pixels, frame.capture_height_pixels,
                            frame.capture_stride_pixels, frame.capture_offset_x_pixels,
                            frame.capture_offset_y_pixels),
                "primary": frame.primary_target,
            }
            self.events.append(("blend", frame.frame_index))
            self.frames.append(snapshot)
            if self.fail_at == (FAIL_BLEND, frame.frame_index):
                return 201 + frame.frame_index
            return 0

        @SystemPump
        def pump(_context):
            call_index = sum(event[0] == "pump" for event in self.events)
            self.events.append(("pump", call_index))
            if self.fail_at == (FAIL_PUMP, call_index):
                return 301 + call_index
            return 0

        self.callbacks = Callbacks(None, get_tick, blend, pump)


def fixture_state(subtype=2, budget=4, pause=0):
    first = (c.c_uint32 * 6)(1, 2, 3, 4, 5, 6)
    second = (c.c_uint32 * 6)(7, 8, 9, 10, 11, 12)
    state = SequenceState()
    state.subtype, state.busy = subtype, 1
    state.render_guard, state.redraw_flag = 1, 0
    state.sequence_budget_ms, state.pause_ms = budget, pause
    state.target_rect = Rect(10, 20, 11, 20)  # original 0x4477d1 is inclusive
    state.source_capture = Capture(c.cast(first, c.POINTER(c.c_uint8)), c.sizeof(first))
    state.destination_capture = Capture(c.cast(second, c.POINTER(c.c_uint8)), c.sizeof(second))
    state.capture_width_pixels, state.capture_height_pixels = 2, 1
    state.capture_stride_pixels = 2
    state.capture_offset_x_pixels = state.capture_offset_y_pixels = 0
    state.primary_target = 1
    state.stage, state.scene_state = 2, 4
    state.finalizer_global_5831c8, state.finalizer_global_5831c6 = 99, 77
    return state, first, second


def configure(lib):
    lib.action_family28_sequence_weight_for_cw.argtypes = [
        c.c_uint32, c.c_uint32, c.c_uint16, c.POINTER(c.c_double)]
    lib.action_family28_run_sequence.argtypes = [
        c.POINTER(SequenceState), c.POINTER(Callbacks), c.c_uint16,
        c.POINTER(Report)]
    return lib


def snapshot_state(state):
    return bytes(state)


class SequenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = configure(c.CDLL(str(LIBRARY)))
        subprocess.run([
            "xcrun", "--sdk", "macosx", "clang", "-std=c11", "-Wall",
            "-Wextra", "-Wpedantic", "-Werror", "-fPIC", "-dynamiclib",
            str(DIVISION_FIXTURE_SOURCE), "-o", str(DIVISION_FIXTURE_LIBRARY)],
            check=True, capture_output=True, text=True)
        cls.division_lib = c.CDLL(str(DIVISION_FIXTURE_LIBRARY))
        cls.division_lib.action_family28_test_divide_one_third.argtypes = [
            c.c_uint, c.POINTER(c.c_uint64), c.POINTER(c.c_uint64),
            c.POINTER(c.c_int32)]
        cls.division_lib.action_family28_test_divide_one_third.restype = c.c_int

    def run_sequence(self, state, harness, cw=CW_EXTENDED):
        report = Report()
        status = self.lib.action_family28_run_sequence(
            c.byref(state), c.byref(harness.callbacks), cw, c.byref(report))
        return status, report

    def test_first_frame_count_then_later_frame_and_pump_order(self):
        state, _first, _second = fixture_state()
        harness = Harness([100, 102])
        status, report = self.run_sequence(state, harness, CW_DOUBLE)
        self.assertEqual(status, OK)
        self.assertEqual(harness.events, [
            ("tick", 0), ("blend", 0), ("tick", 1), ("pump", 0),
            ("blend", 1), ("pump", 1)])
        self.assertEqual((report.selected_frame_count, report.planned_frame_count,
                          report.first_frame_elapsed_ms), (2, 2, 2))
        self.assertEqual([frame["frame_index"] for frame in harness.frames], [0, 1])
        self.assertEqual(harness.frames[0]["weight"], 1.0)
        self.assertEqual([frame["cw"] for frame in harness.frames], [CW_DOUBLE] * 2)
        self.assertEqual(harness.frames[0]["rect"], (10, 20, 11, 20))
        self.assertEqual(harness.frames[0]["primary"], 1)
        self.assertEqual((report.get_tick_calls, report.blend_present_calls,
                          report.system_audio_pump_calls, report.completed_frame_count),
                         (2, 2, 2, 2))
        self.assertEqual((state.busy, state.render_guard, state.redraw_flag), (0, 0, 1))
        self.assertEqual((state.finalizer_global_5831c8, state.finalizer_global_5831c6), (1, 0))
        self.assertEqual(report.completion_committed, 1)

    def test_division_normalizes_before_rounding_at_both_x87_precisions(self):
        for precision, expected_significand, expected_exponent in (
                (53, 0x15555555555555, -54),
                (64, 0xAAAAAAAAAAAAAAAB, -65)):
            with self.subTest(precision=precision):
                high, low, exponent = c.c_uint64(), c.c_uint64(), c.c_int32()
                self.assertEqual(
                    self.division_lib.action_family28_test_divide_one_third(
                        precision, c.byref(high), c.byref(low),
                        c.byref(exponent)), 0)
                self.assertEqual(high.value, 0)
                self.assertEqual(low.value, expected_significand)
                self.assertEqual(exponent.value, expected_exponent)

        for control_word in (CW_DOUBLE, CW_EXTENDED):
            weight = c.c_double()
            self.assertEqual(self.lib.action_family28_sequence_weight_for_cw(
                3, 5, control_word, c.byref(weight)), OK)
            self.assertEqual(weight.value.hex(), "0x1.43515738086b8p-2")

    def test_curve_cw_is_explicit_and_changes_the_original_precision_boundary(self):
        double_weight, extended_weight = c.c_double(), c.c_double()
        self.assertEqual(self.lib.action_family28_sequence_weight_for_cw(
            1, 3, CW_DOUBLE, c.byref(double_weight)), OK)
        self.assertEqual(self.lib.action_family28_sequence_weight_for_cw(
            1, 3, CW_EXTENDED, c.byref(extended_weight)), OK)
        self.assertEqual(double_weight.value.hex(), "0x1.7f2c27709c918p-1")
        self.assertEqual(extended_weight.value.hex(), "0x1.7f2c27709c917p-1")
        unchanged = c.c_double(42.0)
        self.assertEqual(self.lib.action_family28_sequence_weight_for_cw(
            1, 3, 0x017F, c.byref(unchanged)), UNSUPPORTED)
        self.assertEqual(unchanged.value, 42.0)

    def test_subtype3_pause_swap_and_conditional_scene_transition(self):
        state, first, second = fixture_state(subtype=3, budget=4, pause=2)
        original_source = c.cast(state.source_capture.data, c.c_void_p).value
        original_destination = c.cast(state.destination_capture.data, c.c_void_p).value
        harness = Harness([1000, 1002, 1002, 1003, 1004])
        status, report = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual(harness.events, [
            ("tick", 0), ("blend", 0), ("tick", 1), ("pump", 0),
            ("blend", 1), ("pump", 1), ("tick", 2), ("tick", 3),
            ("pump", 2), ("tick", 4)])
        self.assertEqual((state.busy, state.render_guard, state.redraw_flag), (1, 1, 0))
        self.assertEqual((state.stage, state.scene_state), (1, 1))
        self.assertEqual(c.cast(state.source_capture.data, c.c_void_p).value,
                         original_destination)
        self.assertEqual(c.cast(state.destination_capture.data, c.c_void_p).value,
                         original_source)
        self.assertEqual((state.source_capture.byte_length, state.destination_capture.byte_length),
                         (c.sizeof(second), c.sizeof(first)))
        self.assertEqual(report.completion_committed, 1)

    def test_unrecognized_subtype_keeps_stack_initialized_zero_weight(self):
        state, _, _ = fixture_state(subtype=7, budget=4)
        harness = Harness([100, 102])
        status, report = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual((report.selected_frame_count, report.planned_frame_count), (2, 2))
        self.assertEqual([frame["weight"] for frame in harness.frames], [0.0, 0.0])
        self.assertEqual(report.completion_committed, 1)

    def test_zero_elapsed_and_negative_wrapped_elapsed_preserve_original_count_rules(self):
        state, _, _ = fixture_state(budget=4)
        harness = Harness([77, 77])
        status, report = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual((report.selected_frame_count, report.planned_frame_count), (30, 30))
        self.assertEqual(len(harness.frames), 30)

        state, _, _ = fixture_state(budget=4)
        harness = Harness([100, 97])  # DWORD delta 0xfffffffd => signed -3; 4 / -3 -> -1
        status, report = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual((report.first_frame_elapsed_ms, report.selected_frame_count,
                          report.planned_frame_count, len(harness.frames)),
                         (0xFFFFFFFD, -1, 1, 1))

    def test_signed_negative_pause_uses_wrapped_unsigned_deadline(self):
        state, _, _ = fixture_state(subtype=1, budget=4, pause=-2)
        harness = Harness([100, 102, 102, 102])
        status, report = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual(harness.events[-2:], [("tick", 2), ("tick", 3)])
        self.assertEqual(report.system_audio_pump_calls, 2)

    def test_capture_spans_expose_three_dword_pixels_and_reject_short_storage(self):
        state, first, second = fixture_state()
        harness = Harness([10, 12])
        status, _ = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual(harness.frames[0]["source_bytes"], c.sizeof(first))
        self.assertEqual(harness.frames[0]["destination_bytes"], c.sizeof(second))
        self.assertEqual(harness.frames[0]["capture"], (2, 1, 2, 0, 0))

        state, _, _ = fixture_state()
        state.destination_capture.byte_length -= 1
        before = snapshot_state(state)
        harness = Harness([10, 12])
        status, report = self.run_sequence(state, harness)
        self.assertEqual((status, bytes(state), harness.events), (BOUNDS, before, []))
        self.assertEqual(report.completion_committed, 0)

    def test_full_canvas_capture_keeps_tight_stride_and_independent_crop_origin(self):
        state, _, _ = fixture_state()
        first = (c.c_uint32 * 36)(*range(36))
        second = (c.c_uint32 * 36)(*range(36, 72))
        state.source_capture = Capture(c.cast(first, c.POINTER(c.c_uint8)), c.sizeof(first))
        state.destination_capture = Capture(c.cast(second, c.POINTER(c.c_uint8)), c.sizeof(second))
        state.capture_width_pixels, state.capture_height_pixels = 4, 3
        state.capture_stride_pixels = 4
        state.capture_offset_x_pixels, state.capture_offset_y_pixels = 1, 1
        harness = Harness([10, 12])
        status, _ = self.run_sequence(state, harness)
        self.assertEqual(status, OK)
        self.assertEqual(harness.frames[0]["capture"], (4, 3, 4, 1, 1))
        self.assertEqual(harness.frames[0]["rect"], (10, 20, 11, 20))

        state, _, _ = fixture_state()
        state.capture_stride_pixels = state.capture_width_pixels + 1
        before = snapshot_state(state)
        harness = Harness([10, 12])
        status, _ = self.run_sequence(state, harness)
        self.assertEqual((status, bytes(state), harness.events), (BOUNDS, before, []))

        state, _, _ = fixture_state()
        first = (c.c_uint32 * 36)()
        second = (c.c_uint32 * 36)()
        state.source_capture = Capture(c.cast(first, c.POINTER(c.c_uint8)), c.sizeof(first) - 1)
        state.destination_capture = Capture(c.cast(second, c.POINTER(c.c_uint8)), c.sizeof(second))
        state.capture_width_pixels, state.capture_height_pixels = 4, 3
        state.capture_stride_pixels = 4
        state.capture_offset_x_pixels, state.capture_offset_y_pixels = 1, 1
        before = snapshot_state(state)
        harness = Harness([10, 12])
        status, _ = self.run_sequence(state, harness)
        self.assertEqual((status, bytes(state), harness.events), (BOUNDS, before, []))

    def test_pointer_span_overflow_is_rejected_without_dereference(self):
        state, _, _ = fixture_state()
        top = (1 << (c.sizeof(c.c_void_p) * 8)) - 1
        state.source_capture.data = c.cast(c.c_void_p(top - 11), c.POINTER(c.c_uint8))
        before = snapshot_state(state)
        harness = Harness([10, 12])
        status, _ = self.run_sequence(state, harness)
        self.assertEqual((status, bytes(state), harness.events), (BOUNDS, before, []))

    def test_each_callback_failure_aborts_before_final_state_writes_and_reports_prefix(self):
        failures = [
            ((FAIL_TICK, 0), 0, FAIL_TICK, 0xFFFFFFFF),
            ((FAIL_BLEND, 0), 0, FAIL_BLEND, 0),
            ((FAIL_TICK, 1), 1, FAIL_TICK, 0),
            ((FAIL_PUMP, 0), 1, FAIL_PUMP, 0),
            ((FAIL_BLEND, 1), 1, FAIL_BLEND, 1),
            ((FAIL_PUMP, 1), 2, FAIL_PUMP, 1),
        ]
        for fail_at, completed_frames, failed_callback, failed_frame in failures:
            with self.subTest(fail_at=fail_at):
                state, _, _ = fixture_state()
                before = snapshot_state(state)
                harness = Harness([100, 102], fail_at=fail_at)
                status, report = self.run_sequence(state, harness)
                self.assertEqual(status, CALLBACK)
                self.assertEqual(bytes(state), before)
                self.assertEqual(report.completion_committed, 0)
                self.assertEqual(report.completed_frame_count, completed_frames)
                expected_planned = 0 if fail_at in (
                    (FAIL_TICK, 0), (FAIL_BLEND, 0), (FAIL_TICK, 1)) else 2
                self.assertEqual(report.planned_frame_count, expected_planned)
                self.assertEqual(report.failed_callback, failed_callback)
                self.assertEqual(report.failed_frame_index, failed_frame)
                self.assertNotEqual(report.callback_status, 0)

    def test_pause_callback_failures_do_not_synthesize_completion_or_retry(self):
        # After 2 frames, callbacks are: tick(start pause) at index 2,
        # tick(poll) at index 3, then pump 2 if still before deadline.
        for fail_at, failed_callback in [((FAIL_TICK, 2), FAIL_TICK),
                                         ((FAIL_TICK, 3), FAIL_TICK),
                                         ((FAIL_PUMP, 2), FAIL_PUMP)]:
            with self.subTest(fail_at=fail_at):
                state, _, _ = fixture_state(subtype=1, budget=4, pause=2)
                before = snapshot_state(state)
                harness = Harness([100, 102, 102, 103, 104], fail_at=fail_at)
                status, report = self.run_sequence(state, harness)
                self.assertEqual(status, CALLBACK)
                self.assertEqual(bytes(state), before)
                self.assertEqual(report.failed_callback, failed_callback)
                self.assertEqual(report.completed_frame_count, 2)
                self.assertEqual(report.completion_committed, 0)

    def test_invalid_mode_or_geometry_is_atomic(self):
        for mode in (0x017F, 0x047F):
            state, _, _ = fixture_state()
            before = snapshot_state(state)
            harness = Harness([100, 102])
            status, _ = self.run_sequence(state, harness, mode)
            self.assertEqual((status, bytes(state), harness.events), (UNSUPPORTED, before, []))
        for field, value in [("capture_offset_x_pixels", 1),
                             ("capture_stride_pixels", 1),
                             ("target_rect", Rect(12, 20, 11, 20))]:
            state, _, _ = fixture_state()
            setattr(state, field, value)
            before = snapshot_state(state)
            harness = Harness([100, 102])
            status, _ = self.run_sequence(state, harness)
            self.assertEqual((status, bytes(state), harness.events), (BOUNDS, before, []))


if __name__ == "__main__":
    unittest.main()
