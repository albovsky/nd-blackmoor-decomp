"""Shared ctypes harness for the RT-3 session-binding tests.

Reuses the verified ctypes mirrors of the scene-session ABI from
test_scene_session (no TestCase is imported, so nothing is collected twice)
and loads the separate binding library.
"""

from __future__ import annotations

import ctypes as c
import os
import subprocess
from pathlib import Path

import test_scene_session as base

PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_LIBRARY = PROJECT / "build/libsessionbindings.dylib"

i16 = base.i16
i32 = base.i32
action = base.action
scene_bytes = base.scene_bytes

SessionConfig = base.SessionConfig
Binding = base.Binding
PrepareFn = base.PrepareFn
MediaFn = base.MediaFn
ActionFn = base.ActionFn
PreGateFn = base.PreGateFn
ActionCoreWorld = base.ActionCoreWorld
SceneConditionState = base.SceneConditionState
SceneSessionFailure = base.SceneSessionFailure
SceneSessionTickResult = base.SceneSessionTickResult
SceneActionInfo = base.SceneActionInfo
RuntimeState = base.RuntimeState
HandlerResult = base.HandlerResult
SceneTransitionRequest = base.SceneTransitionRequest
SceneExecutorFrameInput = base.SceneExecutorFrameInput

SESSION_OK = base.SESSION_OK
SESSION_TRANSITION = base.SESSION_TRANSITION
SESSION_BLOCKED = base.SESSION_BLOCKED
CALLBACK_OK = base.CALLBACK_OK
STAGE_DISPATCH = base.STAGE_DISPATCH
PROVIDER_A62 = base.PROVIDER_A62
PROVIDER_ACTION_SOUND = base.PROVIDER_ACTION_SOUND
PROVIDER_CAPTION = base.PROVIDER_CAPTION

HANDLER_OK = base.HANDLER_OK
HANDLER_PENDING = 0
HANDLER_COMPLETED = 1
HANDLER_RESET = 2
HANDLER_DIRECT_COMPLETED = base.HANDLER_DIRECT_COMPLETED

SelectorFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_int16))
StartFlagFn = c.CFUNCTYPE(None, c.c_void_p, c.c_int32)


class A62Host(c.Structure):
    _fields_ = [("context", c.c_void_p),
                ("current_selector", SelectorFn),
                ("set_start_flag", StartFlagFn)]


class A62Target(c.Structure):
    _fields_ = [("request_pending", c.c_uint32),
                ("response_words", c.c_int16 * 4)]


class A62ScanRequest(c.Structure):
    _fields_ = [("coordinate_a", c.c_int32), ("coordinate_b", c.c_int32),
                ("reserved_index_a", c.c_int32), ("reserved_index_b", c.c_int32),
                ("cursor_command", c.c_int32)]


class A62ScanResult(c.Structure):
    _fields_ = [("candidate_action_index", c.c_int32),
                ("candidate_found", c.c_uint8), ("candidate_route", c.c_uint8)]


class A62AcceptInput(c.Structure):
    _fields_ = [("candidate_action_index", c.c_int32),
                ("suppression_value", c.c_int32),
                ("action_control_word_at_plus_0x30", c.c_int32),
                ("dependency_ready", c.c_int32),
                ("dependency_child_index", c.c_int32)]


class A62AcceptResult(c.Structure):
    _fields_ = [("candidate_considered", c.c_uint8),
                ("dependency_check_required", c.c_uint8),
                ("phase2_requested", c.c_uint8),
                ("child_request_required", c.c_uint8),
                ("dependency_feedback_required", c.c_uint8),
                ("child_index", c.c_int32)]


def build_library(output: Path | None = None, cflags: str = "") -> Path:
    prebuilt = os.environ.get("SESSION_BINDINGS_LIBRARY")
    if prebuilt:  # mutation checks supply their own already-built library
        return Path(prebuilt)
    env = dict(os.environ)
    target = output or DEFAULT_LIBRARY
    env["SESSION_BINDINGS_OUTPUT"] = str(target)
    env["SESSION_BINDINGS_CFLAGS"] = cflags
    subprocess.run([str(PROJECT / "scripts/build_session_bindings.sh")],
                   check=True, env=env, capture_output=True)
    return target


def load_library(path: Path) -> c.CDLL:
    lib = c.CDLL(str(path))
    lib.scene_resource_open_memory.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t]
    lib.scene_resource_open_memory.restype = c.c_void_p
    lib.scene_resource_close.argtypes = [c.c_void_p]
    lib.scene_session_create.argtypes = [
        c.POINTER(SessionConfig), c.POINTER(c.c_void_p),
        c.POINTER(SceneSessionFailure)]
    lib.scene_session_create.restype = c.c_int
    lib.scene_session_destroy.argtypes = [c.c_void_p]
    lib.scene_session_tick.argtypes = [c.c_void_p, c.POINTER(SceneSessionTickResult)]
    lib.scene_session_tick.restype = c.c_int
    lib.scene_session_get_action_state.argtypes = [
        c.c_void_p, c.c_size_t, c.POINTER(RuntimeState)]
    lib.scene_session_get_action_state.restype = c.c_int
    lib.scene_session_replace_scene.argtypes = [
        c.c_void_p, c.c_void_p, c.c_int32, c.POINTER(SceneSessionFailure)]
    lib.scene_session_replace_scene.restype = c.c_int
    lib.scene_session_get_pending_transition.argtypes = [
        c.c_void_p, c.POINTER(SceneTransitionRequest)]
    lib.scene_session_get_pending_transition.restype = c.c_int
    lib.scene_session_set_pre_gate.argtypes = [
        c.c_void_p, c.c_uint8, c.c_void_p, c.c_void_p]
    lib.scene_session_set_pre_gate.restype = c.c_int
    lib.scene_session_accept_action_candidate.argtypes = [c.c_void_p, c.c_size_t]
    lib.scene_session_accept_action_candidate.restype = c.c_int
    return lib


def open_scene(lib, actions):
    raw = scene_bytes(actions)
    owner = (c.c_uint8 * len(raw)).from_buffer_copy(raw)
    error = c.create_string_buffer(256)
    scene = lib.scene_resource_open_memory(owner, len(raw), error, len(error))
    assert scene, error.value.decode()
    return scene, owner


def make_world(flag_count=16):
    flags = (c.c_int32 * flag_count)()
    world = ActionCoreWorld()
    world.event_flags = flags
    world.event_flag_count = len(flags)
    conditions = SceneConditionState()
    conditions.event_flags = flags
    conditions.event_flag_count = len(flags)
    return flags, world, conditions


def flag_gate(flag_id, value=1):
    """Dependency record: opcode 2 (event flag) == value."""
    return b"".join(i16(v) for v in (2, flag_id, value, 0, 0, 0, 0, 0))


def a62_body(entries, *, ids=(-1, -1), values=(0, 0), threshold=0):
    """0x62 typed body: 12-byte prefix plus 18-byte entries (nine words)."""
    body = (i16(ids[0]) + i16(values[0]) + i16(ids[1]) + i16(values[1]) +
            i16(threshold) + i16(len(entries)))
    for entry in entries:
        assert len(entry) == 9
        body += b"".join(i16(v) for v in entry)
    return body
