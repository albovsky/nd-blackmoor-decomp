"""Shared ctypes harness for the RT-5 scene-exit tests and oracle.

Mirrors the C structs of session_exit.h and provides a recording host whose
callbacks produce the ordered effect list the original-x86 oracle also
produces. No TestCase is defined here, so importing it collects nothing.
"""

from __future__ import annotations

import ctypes as c
import os
import subprocess
from pathlib import Path

import session_binding_support as sbs
import test_action_family_28_sequence as seq

PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_LIBRARY = PROJECT / "build/libsessionexit.dylib"

OK, ERR_ARGUMENT, ERR_UNSUPPORTED, ERR_HOST, ERR_CAPTION = range(5)
STATE_LOAD, STATE_INTRO, STATE_RUN, STATE_EXIT = 1, 2, 3, 4
UNSUPPORTED_NONE, UNSUPPORTED_LOAD_GAME, UNSUPPORTED_SUMMARY = 0, 1, 2
(BOUNDARY_NONE, BOUNDARY_NESTED, BOUNDARY_CAPTURE_SOURCE,
 BOUNDARY_CAPTURE_DESTINATION, BOUNDARY_CLEAR_DESTINATION,
 BOUNDARY_RUN_SEQUENCE) = range(6)
CAPTURE_SOURCE, CAPTURE_DESTINATION = 0, 1

Rect = seq.Rect


class Globals(c.Structure):
    _fields_ = [
        ("game_state", c.c_uint32), ("load_game_flag", c.c_int32),
        ("popup_flag", c.c_int32), ("modal_input", c.c_int32),
        ("first_render_level", c.c_int16), ("cursor_layer", c.c_int32),
        ("redraw_request", c.c_int32), ("redraw_counter", c.c_uint16),
        ("scene_request", c.c_int32), ("scene_request_flag", c.c_int16),
        ("cursor_override", c.c_int32), ("input_latch", c.c_int32),
        ("latch_5c39ed", c.c_int32), ("latch_5c39f1", c.c_int32),
        ("latch_5c39f5", c.c_int32), ("latch_5c39f9", c.c_int32),
        ("exit_hold_63a5c0", c.c_int32), ("exit_hold_63a5c4", c.c_int32),
        ("framed_flag_5b15da", c.c_int32), ("saved_flag_5bb1da", c.c_int32),
    ]


class World(c.Structure):
    _fields_ = [("busy", c.c_uint8), ("full_canvas", Rect), ("current_rect", Rect),
                ("sequence_counter", c.c_uint32), ("active_payload", c.c_uint8 * 21)]


class Exit(c.Structure):
    _fields_ = [("g", Globals), ("effect", World)]


class StepInfo(c.Structure):
    _fields_ = [("unsupported", c.c_int), ("failed_boundary", c.c_int),
                ("controller_ran", c.c_uint8), ("stage_before", c.c_uint32)]


class TransitionRequest(c.Structure):
    _fields_ = [("target_scene", c.c_int16), ("opaque_words", c.c_int16 * 3),
                ("opaque_dwords", c.c_int32 * 3)]


NESTED = c.CFUNCTYPE(c.c_int, c.c_void_p)
CAPTURE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int)
CLEAR = c.CFUNCTYPE(c.c_int, c.c_void_p)
RUN = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(seq.SequenceState))


class Host(c.Structure):
    _fields_ = [("context", c.c_void_p), ("nested_scene_tick", NESTED),
                ("capture", CAPTURE), ("clear_destination_capture", CLEAR),
                ("run_sequence", RUN)]


VIEW = (10, 10, 629, 384)
CANVAS_W, CANVAS_H = 2, 1   # tiny capture canvas for the sequence kernel


def build_library(output: Path | None = None, cflags: str = "") -> Path:
    prebuilt = os.environ.get("SESSION_EXIT_LIBRARY")
    if prebuilt:
        return Path(prebuilt)
    env = dict(os.environ)
    target = output or DEFAULT_LIBRARY
    env["SESSION_EXIT_OUTPUT"] = str(target)
    env["SESSION_EXIT_CFLAGS"] = cflags
    subprocess.run([str(PROJECT / "scripts/build_session_exit.sh")],
                   check=True, env=env, capture_output=True)
    return target


def load_library(path: Path) -> c.CDLL:
    lib = sbs.load_library(path)     # scene resource / session entry points
    X, H, I = c.POINTER(Exit), c.POINTER(Host), c.POINTER(StepInfo)
    lib.session_exit_init.argtypes = [X, c.POINTER(Rect)]
    lib.session_exit_init.restype = c.c_int
    lib.session_exit_request_transition.argtypes = [X, c.POINTER(TransitionRequest)]
    lib.session_exit_request_transition.restype = c.c_int
    for name in ("session_exit_effect_gate", "session_exit_controller",
                 "session_exit_state4", "session_exit_render_pass"):
        getattr(lib, name).argtypes = [X, H, I]
        getattr(lib, name).restype = c.c_int
    for name in ("session_exit_begin_load", "session_exit_finish_intro",
                 "session_exit_clear_latches"):
        getattr(lib, name).argtypes = [X]
        getattr(lib, name).restype = c.c_int
    lib.session_exit_status_string.argtypes = [c.c_int]
    lib.session_exit_status_string.restype = c.c_char_p
    lib.session_exit_unsupported_string.argtypes = [c.c_int]
    lib.session_exit_unsupported_string.restype = c.c_char_p
    lib.action_family28_run_sequence.argtypes = [
        c.POINTER(seq.SequenceState), c.POINTER(seq.Callbacks), c.c_uint16,
        c.POINTER(seq.Report)]
    lib.action_family28_run_sequence.restype = c.c_int
    return lib


def payload(kind, budget=4, pause=0, rect=(0, 0, 0, 0)):
    import struct
    return struct.pack("<Bhh4i", kind, budget, pause, *rect)


def new_exit(lib, *, kind=2, busy=1, stage=0, state=STATE_EXIT, budget=4,
             pause=0, popup=1, load_game=0, rect=(10, 20, 11, 20)):
    x = Exit()
    view = Rect(*VIEW)
    assert lib.session_exit_init(c.byref(x), c.byref(view)) == OK
    x.g.game_state = state
    x.g.popup_flag = popup
    x.g.load_game_flag = load_game
    x.effect.busy = busy
    x.effect.sequence_counter = stage
    x.effect.current_rect = Rect(*rect)
    x.effect.active_payload[:] = payload(kind, budget, pause)
    return x


class RecordingHost:
    """Host whose callbacks append (name, observed state...) to `events`."""

    def __init__(self, lib, x, *, ticks=(100, 102), fail=None, cw=seq.CW_DOUBLE):
        self.lib, self.x = lib, x
        self.events = []
        self.fail = fail            # boundary id that returns nonzero
        self.ticks = ticks
        self.cw = cw
        self.sequence_harness = None
        self.sequence_status = None
        self.sequence_report = None
        self.sequence_state_in = None
        self.first = (c.c_uint32 * 6)(1, 2, 3, 4, 5, 6)
        self.second = (c.c_uint32 * 6)(7, 8, 9, 10, 11, 12)
        self.struct = Host(None, NESTED(self._nested), CAPTURE(self._capture),
                           CLEAR(self._clear), RUN(self._run))

    def _nested(self, _ctx):
        self.events.append(("nested_tick", self.x.g.game_state))
        return 11 if self.fail == BOUNDARY_NESTED else 0

    def _capture(self, _ctx, which):
        self.events.append(("capture", which, self.x.g.game_state))
        want = BOUNDARY_CAPTURE_SOURCE if which == CAPTURE_SOURCE \
            else BOUNDARY_CAPTURE_DESTINATION
        return 12 if self.fail == want else 0

    def _clear(self, _ctx):
        self.events.append(("clear_destination",))
        return 13 if self.fail == BOUNDARY_CLEAR_DESTINATION else 0

    def _run(self, _ctx, state_ptr):
        state = state_ptr.contents
        self.sequence_state_in = {
            "subtype": state.subtype, "busy": state.busy,
            "render_guard": state.render_guard, "redraw_flag": state.redraw_flag,
            "budget": state.sequence_budget_ms, "pause": state.pause_ms,
            "rect": (state.target_rect.left, state.target_rect.top,
                     state.target_rect.right, state.target_rect.bottom),
            "stage": state.stage, "scene_state": state.scene_state,
            "f5831c8": state.finalizer_global_5831c8,
            "f5831c6": state.finalizer_global_5831c6,
        }
        self.events.append(("run_sequence", state.subtype, state.stage,
                            state.scene_state))
        if self.fail == BOUNDARY_RUN_SEQUENCE:
            return 14
        state.source_capture = seq.Capture(
            c.cast(self.first, c.POINTER(c.c_uint8)), c.sizeof(self.first))
        state.destination_capture = seq.Capture(
            c.cast(self.second, c.POINTER(c.c_uint8)), c.sizeof(self.second))
        state.capture_width_pixels, state.capture_height_pixels = CANVAS_W, CANVAS_H
        state.capture_stride_pixels = CANVAS_W
        state.capture_offset_x_pixels = state.capture_offset_y_pixels = 0
        state.primary_target = 1
        harness = seq.Harness(self.ticks)
        report = seq.Report()
        status = self.lib.action_family28_run_sequence(
            c.byref(state), c.byref(harness.callbacks), self.cw, c.byref(report))
        self.sequence_harness, self.sequence_status = harness, status
        self.sequence_report = report
        self.events.extend(("seq",) + tuple(e) for e in harness.events)
        return 0 if status == 0 else 20 + status

    def host(self):
        return self.struct


def configure_a28(lib: c.CDLL) -> c.CDLL:
    lib.session_a28_create.argtypes = [c.POINTER(Exit)]
    lib.session_a28_create.restype = c.c_void_p
    lib.session_a28_destroy.argtypes = [c.c_void_p]
    lib.session_a28_last_failure.argtypes = [c.c_void_p]
    lib.session_a28_last_failure.restype = c.c_int
    lib.session_a28_failure_string.argtypes = [c.c_int]
    lib.session_a28_failure_string.restype = c.c_char_p
    return lib
