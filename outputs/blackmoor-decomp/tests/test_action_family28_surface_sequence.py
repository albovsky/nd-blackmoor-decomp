import ctypes as c
from pathlib import Path
import subprocess
import unittest


PROJECT = Path(__file__).resolve().parents[1]


class Rect(c.Structure):
    _fields_ = [("left", c.c_int32), ("top", c.c_int32),
                ("right", c.c_int32), ("bottom", c.c_int32)]


class PrimarySurface(c.Structure):
    _fields_ = [
        ("pixels", c.POINTER(c.c_uint8)), ("byte_length", c.c_size_t),
        ("width", c.c_size_t), ("height", c.c_size_t),
        ("pitch_bytes", c.c_size_t), ("origin_x", c.c_int32),
        ("origin_y", c.c_int32), ("channel_shifts", c.c_uint8 * 3),
        ("channel_masks", c.c_uint8 * 3), ("format", c.c_int),
        ("scope", c.c_int), ("primary_target", c.c_uint8),
        ("storage_lifetime", c.c_int),
    ]


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
        ("scene_state", c.c_uint32),
        ("finalizer_global_5831c8", c.c_uint32),
        ("finalizer_global_5831c6", c.c_uint16),
    ]


class SequenceReport(c.Structure):
    _fields_ = [
        ("selected_frame_count", c.c_int32), ("planned_frame_count", c.c_uint32),
        ("first_frame_elapsed_ms", c.c_uint32),
        ("get_tick_calls", c.c_uint32), ("blend_present_calls", c.c_uint32),
        ("system_audio_pump_calls", c.c_uint32),
        ("completed_frame_count", c.c_uint32),
        ("failed_frame_index", c.c_uint32),
        ("failed_callback", c.c_uint8), ("completion_committed", c.c_uint8),
        ("callback_status", c.c_int32),
    ]


class SurfaceSequenceReport(c.Structure):
    _fields_ = [
        ("controller", SequenceReport),
        ("blend_attempts", c.c_uint32), ("blend_successes", c.c_uint32),
        ("present_attempts", c.c_uint32), ("present_successes", c.c_uint32),
        ("graphics_tail_pump_attempts", c.c_uint32),
        ("graphics_tail_pump_successes", c.c_uint32),
        ("system_audio_pump_attempts", c.c_uint32),
        ("system_audio_pump_successes", c.c_uint32),
        ("failed_operation", c.c_int), ("callback_status", c.c_int32),
        ("controller_status", c.c_int32),
    ]


class SurfaceSequenceCallbacks(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("get_tick_count", c.c_void_p),
        ("present_primary", c.c_void_p),
        ("graphics_tail_pump", c.c_void_p),
        ("system_audio_pump", c.c_void_p),
    ]


GET_TICK = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
PRESENT = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(PrimarySurface), c.c_uint32)
FRAME_PUMP = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint32)
SYSTEM_PUMP = c.CFUNCTYPE(c.c_int, c.c_void_p)


class ActionFamily28SurfaceSequenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / "scripts/build_action_family28_surface.sh")], check=True)
        cls.lib = c.CDLL(str(PROJECT / "build/libactionfamily28surface.dylib"))
        cls.lib.action_family28_surface_run_sequence.argtypes = [
            c.POINTER(PrimarySurface), c.POINTER(SequenceState),
            c.POINTER(SurfaceSequenceCallbacks), c.c_uint16,
            c.POINTER(SurfaceSequenceReport),
        ]
        cls.lib.action_family28_surface_run_sequence.restype = c.c_int
        cls.lib.action_family28_capture_required_bytes.argtypes = [
            c.c_size_t, c.c_size_t, c.c_size_t, c.POINTER(c.c_size_t)
        ]
        cls.lib.action_family28_capture_required_bytes.restype = c.c_int

    @staticmethod
    def make_surface_and_captures():
        # Surface is an offscreen decoded-background adapter with a nonzero
        # viewport origin; source crop (0,0) differs from destination x=11.
        pixels = (c.c_uint8 * 8)(0, 0, 0, 0, 0, 0, 0, 0)
        surface = PrimarySurface(
            c.cast(pixels, c.POINTER(c.c_uint8)), len(pixels), 2, 2, 4,
            10, 20, (c.c_uint8 * 3)(11, 5, 0),
            (c.c_uint8 * 3)(31, 63, 31), 1, 1, 1, 1,
        )
        required = c.c_size_t()
        assert ActionFamily28SurfaceSequenceTests.lib.action_family28_capture_required_bytes(
            2, 2, 2, c.byref(required)) == 0
        source = (c.c_uint8 * required.value)()
        destination = (c.c_uint8 * required.value)()
        # Every source word is RGB565 green; destination words are red.
        for base in range(0, len(source), 12):
            for component, value in enumerate((0, 63, 0)):
                source[base + component * 4:base + component * 4 + 4] = \
                    value.to_bytes(4, "little")
                destination[base + component * 4:base + component * 4 + 4] = \
                    (31 if component == 0 else 0).to_bytes(4, "little")
        return pixels, surface, source, destination

    def make_state(self, source, destination, subtype=1, source_length=None):
        return SequenceState(
            subtype, 1, 1, 0, 4, 0, Rect(11, 20, 11, 21),
            Capture(c.cast(source, c.POINTER(c.c_uint8)),
                    len(source) if source_length is None else source_length),
            Capture(c.cast(destination, c.POINTER(c.c_uint8)), len(destination)),
            2, 2, 2, 0, 0, 1, 0, 4, 0, 0,
        )

    @staticmethod
    def make_callbacks(events, ticks=(100, 102, 200, 200), failures=None):
        failures = failures or {}
        context = {"tick_index": 0}

        @GET_TICK
        def get_tick(_context, out_tick):
            events.append("tick")
            index = context["tick_index"]
            context["tick_index"] += 1
            if failures.get("tick") == index:
                return 71
            if index >= len(ticks):
                return 99
            out_tick[0] = ticks[index]
            return 0

        @PRESENT
        def present(_context, surface, frame_index):
            events.append(f"present{frame_index}")
            if failures.get("present") == frame_index:
                return 72
            # Observe the already blended full-canvas surface at presentation.
            events.append("pixels:" + bytes(
                c.cast(surface.contents.pixels, c.POINTER(c.c_uint8 * 8)).contents
            ).hex())
            return 0

        @FRAME_PUMP
        def graphics_tail(_context, frame_index):
            events.append(f"tail{frame_index}")
            return 73 if failures.get("tail") == frame_index else 0

        @SYSTEM_PUMP
        def system_audio(_context):
            events.append("audio")
            return 74 if failures.get("audio") else 0

        callbacks = SurfaceSequenceCallbacks(
            None, c.cast(get_tick, c.c_void_p), c.cast(present, c.c_void_p),
            c.cast(graphics_tail, c.c_void_p), c.cast(system_audio, c.c_void_p),
        )
        return callbacks, (get_tick, present, graphics_tail, system_audio)

    def run_sequence(self, surface, state, callbacks, report=None):
        report = report or SurfaceSequenceReport()
        status = self.lib.action_family28_surface_run_sequence(
            c.byref(surface), c.byref(state), c.byref(callbacks),
            0x027F, c.byref(report),
        )
        return status, report

    @staticmethod
    def event_order(events):
        return ["pixels" if event.startswith("pixels:") else event
                for event in events]

    def test_original_order_present_tail_pump_lifetime_and_completion(self):
        pixels, surface, source, destination = self.make_surface_and_captures()
        source_before = bytes(source)
        state = self.make_state(source, destination)
        events = []
        callbacks, keepalive = self.make_callbacks(events)
        status, report = self.run_sequence(surface, state, callbacks)
        self.assertEqual(status, 0)
        self.assertEqual(self.event_order(events), [
            "tick", "present0", "pixels", "tail0", "tick", "audio",
            "present1", "pixels", "tail1", "audio", "tick", "tick",
        ])
        frames = [event.split(":", 1)[1] for event in events
                  if event.startswith("pixels:")]
        self.assertEqual(frames[0], "0000e0070000e007")
        self.assertNotEqual(frames[0], frames[1])
        self.assertEqual(report.controller.planned_frame_count, 2)
        self.assertEqual(report.controller.completed_frame_count, 2)
        self.assertEqual(report.controller.completion_committed, 1)
        self.assertEqual((report.blend_attempts, report.blend_successes), (2, 2))
        self.assertEqual((report.present_attempts, report.present_successes), (2, 2))
        self.assertEqual((report.graphics_tail_pump_attempts,
                          report.graphics_tail_pump_successes), (2, 2))
        self.assertEqual((report.system_audio_pump_attempts,
                          report.system_audio_pump_successes), (2, 2))
        self.assertEqual((state.busy, state.render_guard, state.redraw_flag), (0, 0, 1))
        self.assertEqual(bytes(pixels), bytes.fromhex(frames[1]))
        self.assertEqual(bytes(source), source_before)
        self.assertTrue(keepalive)

    def test_present_failure_reports_partial_surface_effect_without_cleanup(self):
        pixels, surface, source, destination = self.make_surface_and_captures()
        state = self.make_state(source, destination)
        events = []
        callbacks, keepalive = self.make_callbacks(events, failures={"present": 0})
        status, report = self.run_sequence(surface, state, callbacks)
        self.assertEqual(status, 5)
        self.assertEqual(self.event_order(events), ["tick", "present0"])
        self.assertEqual(report.failed_operation, 3)  # primary presentation
        self.assertEqual(report.callback_status, 72)
        self.assertEqual((report.blend_successes, report.present_attempts,
                          report.present_successes), (1, 1, 0))
        self.assertEqual(report.controller.completed_frame_count, 0)
        self.assertEqual(report.controller.completion_committed, 0)
        self.assertEqual((state.busy, state.render_guard, state.redraw_flag), (1, 1, 0))
        self.assertEqual(bytes(pixels), bytes.fromhex("0000e0070000e007"))
        self.assertTrue(keepalive)

    def test_graphics_tail_and_system_audio_failures_keep_exact_order(self):
        pixels, surface, source, destination = self.make_surface_and_captures()
        state = self.make_state(source, destination)
        events = []
        callbacks, _keepalive = self.make_callbacks(events, failures={"tail": 0})
        status, report = self.run_sequence(surface, state, callbacks)
        self.assertEqual(status, 5)
        self.assertEqual(self.event_order(events),
                         ["tick", "present0", "pixels", "tail0"])
        self.assertEqual(report.failed_operation, 4)
        self.assertEqual(report.callback_status, 73)
        self.assertEqual((report.blend_successes, report.present_successes,
                          report.graphics_tail_pump_attempts,
                          report.graphics_tail_pump_successes), (1, 1, 1, 0))

        pixels, surface, source, destination = self.make_surface_and_captures()
        state = self.make_state(source, destination)
        events = []
        callbacks, _keepalive = self.make_callbacks(events, failures={"audio": True})
        status, report = self.run_sequence(surface, state, callbacks)
        self.assertEqual(status, 5)
        self.assertEqual(self.event_order(events),
                         ["tick", "present0", "pixels", "tail0", "tick", "audio"])
        self.assertEqual(report.failed_operation, 5)
        self.assertEqual(report.callback_status, 74)
        self.assertEqual(report.controller.planned_frame_count, 2)
        self.assertEqual(report.blend_successes, 1)
        self.assertEqual(report.controller.completion_committed, 0)

    def test_type3_swaps_capture_lifetimes_only_after_successful_finalizer(self):
        pixels, surface, source, destination = self.make_surface_and_captures()
        source_address = c.addressof(source)
        destination_address = c.addressof(destination)
        state = self.make_state(source, destination, subtype=3)
        state.stage = 0
        state.scene_state = 4
        state.finalizer_global_5831c8 = 8
        state.finalizer_global_5831c6 = 9
        events = []
        callbacks, _keepalive = self.make_callbacks(events)
        status, report = self.run_sequence(surface, state, callbacks)
        self.assertEqual(status, 0)
        self.assertEqual(c.cast(state.source_capture.data, c.c_void_p).value,
                         destination_address)
        self.assertEqual(c.cast(state.destination_capture.data, c.c_void_p).value,
                         source_address)
        self.assertEqual((state.stage, state.scene_state), (1, 1))
        self.assertEqual((state.finalizer_global_5831c8,
                          state.finalizer_global_5831c6), (1, 0))
        self.assertEqual(report.controller.completion_committed, 1)

    def test_preflight_rejects_short_capture_without_ticks_surface_or_report_write(self):
        pixels, surface, source, destination = self.make_surface_and_captures()
        before_pixels = bytes(pixels)
        state = self.make_state(source, destination, source_length=len(source) - 1)
        events = []
        callbacks, _keepalive = self.make_callbacks(events)
        report = SurfaceSequenceReport()
        c.memset(c.byref(report), 0x5A, c.sizeof(report))
        before_report = bytes(report)
        status = self.lib.action_family28_surface_run_sequence(
            c.byref(surface), c.byref(state), c.byref(callbacks), 0x027F,
            c.byref(report),
        )
        self.assertEqual(status, 3)
        self.assertEqual(events, [])
        self.assertEqual(bytes(pixels), before_pixels)
        self.assertEqual(bytes(report), before_report)


if __name__ == "__main__":
    unittest.main()
