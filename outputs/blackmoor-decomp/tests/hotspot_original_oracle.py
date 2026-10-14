#!/usr/bin/env python3
"""Compare the S0 hotspot executor slice with the original GAME.EXE.

The original PE32 dispatcher and the 0x6a/0x0d handlers run under Unicorn
2.1.4. Only the dependency-ready leaf (0x423f57) is controlled by the
harness. The action handlers, event-flag writes, subtype-2 completion/reset,
and delayed 0x0d transition writes remain original instructions. The caller's
input/cursor event path is checked by native runtime regressions and anchored
to 0x43a7ca -> 0x4d3073 -> 0x4f0059; this oracle seeds phase 2 only to compare
the action-dispatch result after that caller gate has accepted a candidate.

Run with the isolated oracle runtime:

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/hotspot_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import struct
import subprocess
from typing import Any

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_scene_executor import (
    ActionCoreWorld,
    FrameInput,
    SceneActionInfo,
    SceneExecutorTests,
    StepInfo,
    action,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_SCENE = ROOT / "work/analysis/hiff-resources/0800.bin"
DEFAULT_NATIVE = PROJECT / "build/libsceneexecutor.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/hotspot-runtime-validation.json"

DISPATCHER_VA = 0x427A50
DEPENDENCY_GATE_VA = 0x423F57
FLAG_HOTSPOT_VA = 0x42E844
SCENE_HOTSPOT_VA = 0x42AE73
COMPLETION_VA = 0x42BA3A
DEPENDENCY_RESET_VA = 0x423D33
INPUT_MESSAGE_MAP_FILE_OFFSET = 0x12C810
INPUT_MESSAGE_MAP_ROWS = (
    (0, 0x0202, 0x0043EC4A),  # WM_LBUTTONUP
    (1, 0x0201, 0x0043EC85),  # WM_LBUTTONDOWN
    (3, 0x0204, 0x0043ECFB),  # WM_RBUTTONUP
    (4, 0x0205, 0x0043ED36),  # WM_RBUTTONDOWN
    (8, 0x0203, 0x0043ECC0),  # WM_LBUTTONDBLCLK
)

ACTION_COUNT_VA = 0x5C39E3
ENGINE_STATE_VA = 0x583999
CURRENT_FRAME_VA = 0x5BB50B
EVENT_FLAGS_VA = 0x585801
ACTION_TYPE_BASE_VA = 0x5BB5E3
ACTION_COMPLETED_BASE_VA = 0x5BB625
ACTION_HOTSPOT_ACTIVE_BASE_VA = 0x5BB626
ACTION_RECT_LEFT_BASE_VA = 0x5BB62A
ACTION_PHASE_BASE_VA = 0x5BB632
ACTION_DEPENDENCY_BASE_VA = 0x5BB5E9
ACTION_STRIDE = 0x8D
ACTION_OCCUPIED_OFFSET = 0x55
DEBUG_LOG_VA = 0x63A4CD

TRANSITION_TARGET_VA = 0x5BB57B
TRANSITION_WORD_6_VA = 0x5BB595
TRANSITION_WORD_4_VA = 0x5BB599
TRANSITION_DWORD_10_VA = 0x5BB59B
TRANSITION_DWORD_14_VA = 0x5BB59F
TRANSITION_DWORD_18_VA = 0x5BB5A3
TRANSITION_WORD_8_VA = 0x5C39FF

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
BODY_BASE = 0x20000000
BODY_SIZE = 0x40000
BODY_ADDRESS = BODY_BASE + 0x1000
RETURN_SENTINEL = 0x30000000
ORACLE_FLAG_COUNT = 2300


class OracleFailure(RuntimeError):
    pass


def i16(value: int) -> bytes:
    return struct.pack("<h", value)


def u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def s32(machine: Any, address: int) -> int:
    return struct.unpack("<i", machine.mem_read(address, 4))[0]


def s16(machine: Any, address: int) -> int:
    return struct.unpack("<h", machine.mem_read(address, 2))[0]


def return_from_thiscall(machine: Any, argument_bytes: int) -> None:
    from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP

    esp = machine.reg_read(UC_X86_REG_ESP)
    return_address = u32(machine, esp)
    machine.reg_write(UC_X86_REG_ESP, esp + 4 + argument_bytes)
    machine.reg_write(UC_X86_REG_EIP, return_address)


class OriginalDispatcher:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        except ImportError as exc:
            raise OracleFailure(
                "Unicorn 2.x required; use work/tools/oracle-python/bin/python"
            ) from exc

        from unicorn.x86_const import (
            UC_X86_REG_EAX,
            UC_X86_REG_EBP,
            UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP,
            UC_X86_REG_ESP,
        )

        self.reg_eax = UC_X86_REG_EAX
        self.reg_ebp = UC_X86_REG_EBP
        self.reg_eflags = UC_X86_REG_EFLAGS
        self.reg_eip = UC_X86_REG_EIP
        self.reg_esp = UC_X86_REG_ESP
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(BODY_BASE, BODY_SIZE)
        self.uc.mem_map(RETURN_SENTINEL, 0x1000)
        self.uc.mem_write(RETURN_SENTINEL, b"\xCC")
        self.dependency_calls = 0
        self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    def _hook_code(self, machine: Any, address: int, _size: int,
                   _user_data: Any) -> None:
        if address == DEPENDENCY_GATE_VA:
            # Controlled external boundary only: the handler body, event-flag
            # writes, and transition side effects stay in original machine code.
            machine.reg_write(self.reg_eax, 1)
            self.dependency_calls += 1
            return_from_thiscall(machine, 4)

    def begin(self, action_type: int, subtype: int, payload: bytes,
              flags: list[int]) -> None:
        if len(payload) > BODY_SIZE - (BODY_ADDRESS - BODY_BASE):
            raise OracleFailure("payload exceeds the bounded oracle body area")
        if len(flags) != ORACLE_FLAG_COUNT:
            raise OracleFailure("event-flag fixture has an unexpected size")

        uc = self.uc
        uc.mem_write(EVENT_FLAGS_VA, struct.pack(f"<{len(flags)}i", *flags))
        uc.mem_write(ACTION_COUNT_VA, struct.pack("<H", 1))
        uc.mem_write(ENGINE_STATE_VA, struct.pack("<i", 3))
        uc.mem_write(DEBUG_LOG_VA, b"\0")
        uc.mem_write(ACTION_TYPE_BASE_VA, bytes((action_type, subtype)))
        uc.mem_write(ACTION_TYPE_BASE_VA + 2, struct.pack("<I", BODY_ADDRESS))
        uc.mem_write(BODY_ADDRESS, payload)
        uc.mem_write(ACTION_COMPLETED_BASE_VA, b"\0")
        uc.mem_write(ACTION_HOTSPOT_ACTIVE_BASE_VA, bytes(4))
        uc.mem_write(ACTION_PHASE_BASE_VA, bytes(4))
        uc.mem_write(ACTION_TYPE_BASE_VA + ACTION_OCCUPIED_OFFSET, b"\0")
        # The dependency pointer is a bounded empty tree. The explicit gate
        # hook controls readiness; subtype-2 reset still runs original code.
        uc.mem_write(ACTION_DEPENDENCY_BASE_VA, bytes(0x38))
        self.dependency_calls = 0

    def dispatch(self, current_frame: int, phase_override: int | None = None) -> None:
        uc = self.uc
        uc.mem_write(CURRENT_FRAME_VA, i16(current_frame))
        if phase_override is not None:
            uc.mem_write(ACTION_PHASE_BASE_VA,
                         struct.pack("<I", phase_override & 0xFFFFFFFF))
        uc.mem_write(STACK_TOP - 4, struct.pack("<I", RETURN_SENTINEL))
        uc.reg_write(self.reg_esp, STACK_TOP - 4)
        uc.reg_write(self.reg_ebp, 0)
        uc.reg_write(self.reg_eflags, 0x202)
        uc.reg_write(self.reg_eip, DISPATCHER_VA)
        try:
            uc.emu_start(DISPATCHER_VA, RETURN_SENTINEL,
                         timeout=10_000_000, count=2_000_000)
        except Exception as exc:
            raise OracleFailure(f"original dispatcher trapped: {exc}") from exc
        if (uc.reg_read(self.reg_eip) != RETURN_SENTINEL or
                uc.reg_read(self.reg_esp) != STACK_TOP):
            raise OracleFailure(
                "original dispatcher did not return normally: "
                f"EIP=0x{uc.reg_read(self.reg_eip):08x}, "
                f"ESP=0x{uc.reg_read(self.reg_esp):08x}"
            )

    def snapshot(self, flag_ids: tuple[int, ...] = ()) -> dict[str, Any]:
        uc = self.uc
        transition = {
            "target_scene": s32(uc, TRANSITION_TARGET_VA),
            # Runtime request order is payload +4, +6, +8. The original
            # globals store those values at these distinct addresses.
            "opaque_words": [s16(uc, TRANSITION_WORD_4_VA),
                             s16(uc, TRANSITION_WORD_6_VA),
                             s16(uc, TRANSITION_WORD_8_VA)],
            "opaque_dwords": [s32(uc, TRANSITION_DWORD_10_VA),
                              s32(uc, TRANSITION_DWORD_14_VA),
                              s32(uc, TRANSITION_DWORD_18_VA)],
        }
        flags = {
            str(index): s32(uc, EVENT_FLAGS_VA + index * 4)
            for index in flag_ids
        }
        return {
            "completed": uc.mem_read(ACTION_COMPLETED_BASE_VA, 1)[0],
            "phase": u32(uc, ACTION_PHASE_BASE_VA),
            "active": uc.mem_read(ACTION_HOTSPOT_ACTIVE_BASE_VA, 1)[0],
            "rectangle": [s16(uc, ACTION_RECT_LEFT_BASE_VA + offset)
                          for offset in (0, 2, 4, 6)],
            "flags": flags,
            "engine_state": s32(uc, ENGINE_STATE_VA),
            "transition": transition,
        }


def runtime_payload_from_raw_15(raw: bytes) -> bytes:
    if len(raw) != 20 or raw[0] != 0x0D:
        raise OracleFailure("expected a raw-0x15 body mapped to runtime type 0x0d")
    payload = bytearray(40)
    payload[0:2] = i16(0)                    # mapper result at internal +0
    payload[2:4] = raw[2:4]                 # target scene
    payload[4:6] = i16(0)
    payload[6:8] = i16(0)
    payload[8:10] = i16(1)
    payload[10:14] = struct.pack("<i", 0)
    payload[14:18] = struct.pack("<i", 0)
    payload[18:22] = struct.pack("<i", 1)
    payload[22:24] = i16(0)                 # loader's frame default
    payload[24:40] = raw[4:20]              # four retained raw dwords
    return bytes(payload)


def native_run(action_type: int, subtype: int, body: bytes,
               frames: list[FrameInput], flag_ids: tuple[int, ...]) -> dict[str, Any]:
    SceneExecutorTests.setUpClass()
    harness = SceneExecutorTests()
    scene_body_type = action_type
    scene_body = body
    if action_type == 0x0D:
        scene_body_type = 0x15
        scene_body = body
    scene, storage = harness.open_scene([
        action(scene_body_type, subtype, scene_body)
    ])
    flags = (c.c_int32 * ORACLE_FLAG_COUNT)(*([0] * ORACLE_FLAG_COUNT))
    world = ActionCoreWorld()
    world.event_flags = flags
    world.event_flag_count = ORACLE_FLAG_COUNT
    status, executor, failed_index = harness.create_executor(scene, world)
    if status != 0:
        harness.lib.scene_resource_close(scene)
        raise OracleFailure(
            f"native executor create failed: status={status}, index={failed_index}"
        )
    condition_state = harness.condition_state(world)
    final_info = StepInfo()
    try:
        for frame_input in frames:
            status, final_info = harness.step_frame(executor, condition_state,
                                                    frame_input)
            if status != 0:
                raise OracleFailure(f"native hotspot step failed with status {status}")
        runtime = harness.action_state(executor, 0)
        hotspot = harness.hotspot_state(executor, 0)
        transition: dict[str, Any] | None = None
        if final_info.kind == 2:
            transition = {
                "target_scene": final_info.transition.target_scene,
                "opaque_words": list(final_info.transition.opaque_words),
                "opaque_dwords": list(final_info.transition.opaque_dwords),
            }
        return {
            "completed": runtime.completed,
            "phase": runtime.phase,
            "active": hotspot.active,
            "rectangle": [hotspot.left, hotspot.top,
                          hotspot.right, hotspot.bottom],
            "flags": {str(index): flags[index] for index in flag_ids},
            "transition": transition,
            "step_kind": final_info.kind,
        }
    finally:
        harness.lib.scene_executor_destroy(executor)
        harness.lib.scene_resource_close(scene)
        # The scene borrows this buffer; retain it through close.
        del storage


def frame(frame_number: int, *, x: int = 0, y: int = 0, pointer: bool = False,
          context: bool = False, modal: bool = False,
          activation: bool = False, candidate: int | None = None) -> FrameInput:
    # RT-6: the executor keeps no hover cache; the accepted event carries the
    # host input module's retained candidate (single native row 0 here).
    return FrameInput(frame_number, x, y, int(pointer), int(context),
                      int(modal), int(activation),
                      0 if candidate is None else 1,
                      0 if candidate is None else candidate)


def original_run(pe: PEImage, action_type: int, subtype: int, payload: bytes,
                 passes: list[tuple[int, int | None]],
                 flag_ids: tuple[int, ...]) -> dict[str, Any]:
    oracle = OriginalDispatcher(pe)
    oracle.begin(action_type, subtype, payload, [0] * ORACLE_FLAG_COUNT)
    for current_frame, phase_override in passes:
        oracle.dispatch(current_frame, phase_override)
    result = oracle.snapshot(flag_ids)
    result["dependency_gate_calls"] = oracle.dependency_calls
    return result


def get_s0_hotspot_bodies(library: c.CDLL, raw_scene: bytes) -> tuple[list[tuple[int, bytes]], tuple[int, bytes]]:
    storage = (c.c_uint8 * len(raw_scene)).from_buffer_copy(raw_scene)
    error = c.create_string_buffer(512)
    library.scene_resource_open_memory.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t
    ]
    library.scene_resource_open_memory.restype = c.c_void_p
    library.scene_resource_close.argtypes = [c.c_void_p]
    library.scene_resource_action_count.argtypes = [c.c_void_p]
    library.scene_resource_action_count.restype = c.c_size_t
    library.scene_resource_action_at.argtypes = [
        c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)
    ]
    library.scene_resource_action_at.restype = c.c_int
    scene = library.scene_resource_open_memory(storage, len(raw_scene), error,
                                               len(error))
    if not scene:
        raise OracleFailure(error.value.decode("utf-8", "replace"))
    flag_hotspots: list[tuple[int, bytes]] = []
    scene_hotspot: tuple[int, bytes] | None = None
    try:
        for index in range(library.scene_resource_action_count(scene)):
            info = SceneActionInfo()
            if library.scene_resource_action_at(scene, index, c.byref(info)) != 0:
                raise OracleFailure(f"could not read S0 ACT row {index}")
            if info.type == 0x6A:
                flag_hotspots.append(
                    (index, c.string_at(info.typed_body, info.typed_body_length))
                )
            elif (info.type == 0x15 and info.raw_body_length == 20 and
                  c.string_at(info.raw_body, 1) == b"\x0d"):
                scene_hotspot = (index, c.string_at(info.raw_body, 20))
    finally:
        library.scene_resource_close(scene)
    if len(flag_hotspots) != 2 or scene_hotspot is None:
        raise OracleFailure("S0 no longer contains the recovered 0x6a/raw-0x15 rows")
    return flag_hotspots, scene_hotspot


def build_library() -> None:
    subprocess.run([str(PROJECT / "scripts/build_scene_executor.sh")],
                   cwd=ROOT, check=True)


def function_range_hash(pe: PEImage, start: int, end: int) -> str:
    offset = pe.va_to_file_offset(start, end - start)
    return hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest()


def validate_input_message_map(pe: PEImage) -> list[dict[str, Any]]:
    validated = []
    for row_index, message, callback in INPUT_MESSAGE_MAP_ROWS:
        offset = INPUT_MESSAGE_MAP_FILE_OFFSET + row_index * 24
        raw = pe.data[offset:offset + 24]
        expected = struct.pack("<6I", message, 0, 0, 0, 0x31, callback)
        if raw != expected:
            raise OracleFailure(
                f"GAME.EXE input message-map row {row_index} at file offset "
                f"0x{offset:x} changed: {raw.hex()}"
            )
        validated.append({
            "file_offset": f"0x{offset:x}",
            "message": f"0x{message:04x}",
            "callback": f"0x{callback:08x}",
            "raw_hex": raw.hex(),
        })
    return validated


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    if not args.scene.is_file():
        raise OracleFailure(f"S0 resource unavailable: {args.scene}")
    native_path = args.native_library.resolve()
    if not native_path.is_file():
        if native_path == DEFAULT_NATIVE.resolve():
            build_library()
        else:
            raise OracleFailure(f"native library unavailable: {native_path}")
    pe = PEImage.parse_and_map(args.exe)
    original_hash = hashlib.sha256(pe.data).hexdigest()
    if original_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {original_hash}")
    input_message_map = validate_input_message_map(pe)
    SceneExecutorTests.setUpClass()
    harness = SceneExecutorTests()
    flag_rows, raw_scene_row = get_s0_hotspot_bodies(
        harness.lib, args.scene.read_bytes()
    )
    comparisons: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []

    for s0_index, body in flag_rows:
        record = body[42:60]
        frame_number = struct.unpack_from("<h", record, 0)[0]
        rect = tuple(struct.unpack_from("<h", record, offset)[0]
                     for offset in (2, 6, 10, 14))
        flag_id = struct.unpack_from("<h", body, 0)[0]
        if flag_id < 0:
            raise OracleFailure(f"S0 0x6a row {s0_index} has no leading flag pair")

        cases = [
            ("phase0-frame-match", [(frame_number, None)],
             [frame(frame_number)], (frame_number, None)),
            ("phase0-frame-miss", [(frame_number + 1, None)],
             [frame(frame_number + 1)], (frame_number + 1, None)),
            ("phase1-frame-rearm", [(frame_number + 1, None),
                                     (frame_number, None)],
             [frame(frame_number + 1), frame(frame_number)],
             (frame_number, None)),
            ("phase2-accepted-candidate", [(frame_number, None),
                                           (frame_number, 1),
                                           (frame_number, 2)],
             [frame(frame_number),
              frame(frame_number, x=rect[0], y=rect[1], pointer=True,
                    context=True),
              frame(frame_number, activation=True, candidate=0)],
             (frame_number, 2)),
        ]
        for label, original_passes, native_frames, _last in cases:
            original = original_run(pe, 0x6A, 2, body, original_passes,
                                    (flag_id,))
            native = native_run(0x6A, 2, body, native_frames, (flag_id,))
            comparable_original = {key: original[key] for key in (
                "completed", "phase", "active", "rectangle", "flags"
            )}
            comparable_native = {key: native[key] for key in comparable_original}
            if comparable_original != comparable_native:
                mismatches.append({"s0_action_index": s0_index, "case": label,
                                   "original": comparable_original,
                                   "native": comparable_native})
            comparisons.append({"s0_action_index": s0_index, "case": label,
                                "flag_id": flag_id,
                                "rect": list(rect),
                                "dependency_hook_calls": original[
                                    "dependency_gate_calls"],
                                "match": comparable_original == comparable_native})

    raw_index, raw_body = raw_scene_row
    runtime_payload = runtime_payload_from_raw_15(raw_body)
    target_scene = struct.unpack_from("<h", raw_body, 2)[0]
    raw_rect = tuple(struct.unpack_from("<i", raw_body, offset)[0]
                     for offset in (4, 8, 12, 16))
    rect = tuple(struct.unpack_from("<h", raw_body, offset)[0]
                 for offset in (4, 8, 12, 16))
    raw_cases = [
        ("phase0-frame-match", [(0, None)], [frame(0)]),
        ("phase0-frame-miss", [(1, None)], [frame(1)]),
        ("phase1-frame-match", [(1, None), (0, None)],
         [frame(1), frame(0, x=rect[0], y=rect[1], pointer=True, context=True)]),
        ("phase1-frame-miss", [(0, None), (1, None)],
         [frame(0), frame(1)]),
        # Outer accepted-event path is outside this narrow original dispatcher
        # call. The third original pass seeds phase 2 after that caller gate.
        ("phase2-delayed-transition", [(0, None), (0, 2)],
         [frame(0), frame(0, x=rect[0], y=rect[1], pointer=True, context=True),
          frame(0, activation=True, candidate=0)]),
    ]
    for label, original_passes, native_frames in raw_cases:
        original = original_run(pe, 0x0D, 1, runtime_payload,
                                original_passes, ())
        native = native_run(0x0D, 1, raw_body, native_frames, ())
        if label == "phase2-delayed-transition":
            comparable_original = {
                "completed": original["completed"],
                "phase": original["phase"],
                "engine_state": original["engine_state"],
                "transition": original["transition"],
            }
            comparable_native = {
                "completed": native["completed"],
                "phase": native["phase"],
                "engine_state": 4 if native["step_kind"] == 2 else 3,
                "transition": native["transition"],
            }
        else:
            comparable_original = {key: original[key] for key in (
                "completed", "phase", "active", "rectangle"
            )}
            comparable_native = {key: native[key] for key in comparable_original}
        if comparable_original != comparable_native:
            mismatches.append({"s0_action_index": raw_index, "case": label,
                               "original": comparable_original,
                               "native": comparable_native})
        comparisons.append({"s0_action_index": raw_index, "case": label,
                            "runtime_type": "0x0d", "target_scene": target_scene,
                            "raw_rect_i32": list(raw_rect),
                            "effective_rect_i16": list(rect),
                            "dependency_hook_calls": original[
                                "dependency_gate_calls"],
                            "original": comparable_original,
                            "native": comparable_native,
                            "match": comparable_original == comparable_native})

    code_ranges = [
        ("0x427a50 dispatcher", DISPATCHER_VA, 0x42ACAD),
        ("0x42e844 0x6a hotspot", FLAG_HOTSPOT_VA, 0x42EA87),
        ("0x42ae73 0x0d hotspot", SCENE_HOTSPOT_VA, 0x42B07E),
        ("0x42ba3a generic completion", COMPLETION_VA, 0x42BABF),
        ("0x423d33 dependency reset", DEPENDENCY_RESET_VA, 0x423DA2),
        ("0x423f57 controlled dependency gate", DEPENDENCY_GATE_VA, 0x423FBB),
    ]
    report = {
        "scope": (
            "S0 action-runtime slice for the two 0x6a flag hotspots and the raw-0x15 "
            "record normalized by the loader to runtime 0x0d; not full-game equivalence"
        ),
        "original_sha256": original_hash,
        "scene_sha256": hashlib.sha256(args.scene.read_bytes()).hexdigest(),
        "native_library_sha256": hashlib.sha256(native_path.read_bytes()).hexdigest(),
        "original_engine": "GAME.EXE PE32 x86 under Unicorn 2.1.4",
        "native_engine": "native C scene executor on arm64 macOS",
        "code_ranges": [
            {"name": name, "start": f"0x{start:08x}",
             "end_exclusive": f"0x{end:08x}",
             "sha256": function_range_hash(pe, start, end)}
            for name, start, end in code_ranges
        ],
        "controlled_boundary": {
            "address": "0x423f57",
            "behavior": "returns dependency-ready for each tested dispatcher pass",
            "hooked_calls": sum(item["dependency_hook_calls"]
                                 for item in comparisons),
        },
        "original_paths_left_real": [
            "0x427a50 action dispatcher for 0x6a and runtime 0x0d",
            "0x42e844 0x6a phase, frame, rectangle, and ten-pair flag logic",
            "0x42ae73 0x0d phase, frame, and delayed transition-global writes",
            "0x42ba3a subtype-2 completion reset and 0x423d33 dependency reset",
            "original event-flag stores",
        ],
        "caller_input_gate": {
            "ordering": (
                "43a7ca consumes the WM_LBUTTONUP latch and applies the cached candidate "
                "before 0x427a50; 0x4d3073 clears and refreshes the candidate after dispatch"
            ),
            "activation_event": (
                "WM_LBUTTONUP (0x0202); its message-map callback 0x43ec4a reaches "
                "0x4db000, which consumes the original input+0 latch. WM_LBUTTONDOWN "
                "(0x0201) routes through a different callback and is not this activation event."
            ),
            "message_map_file_offset": f"0x{INPUT_MESSAGE_MAP_FILE_OFFSET:x}",
            "validated_message_map_rows": input_message_map,
            "native_regressions": [
                "hover capture alone does not activate",
                "a later accepted event activates only the cached candidate",
                "the activation bit represents the caller-verified primary-button release",
                "phase-2 effects execute in the same tick's dispatcher",
                "modal, stale-candidate, and changed-dependency guards are checked",
            ],
            "oracle_limit": (
                "the Unicorn dispatcher fixture seeds phase 2 to compare handler results; "
                "it does not execute the platform-heavy 0x43a7ca input loop"
            ),
        },
        "comparisons": comparisons,
        "mismatches": mismatches,
        "raw_0x15_normalization": {
            "retained_parser_type": "0x15",
            "runtime_type_from_body_byte_0": "0x0d",
            "target_scene_from_raw_body_plus_2": target_scene,
            "runtime_payload_size": 40,
            "payload_defaults": {
                "mapped_word_0": 0,
                "opaque_words": [0, 0, 1],
                "opaque_dwords": [0, 0, 1],
                "frame": 0,
            },
            "rectangle_storage": (
                "four raw signed dwords are retained in the constructed payload, "
                "then 0x42ae73 exports their low 16 bits as signed live hit bounds"
            ),
        },
        "limits": [
            "dependency expression evaluation is controlled true in the original fixture",
            "the original input-event/cursor path is not executed under Unicorn",
            "viewport, scroll, and cursor-sprite transforms remain a caller boundary; "
            "the executor receives the transformed scene-coordinate hot point",
            "no whole-game scene loading, rendering, audio, or user-interface equivalence is claimed",
        ],
    }
    if mismatches:
        raise OracleFailure(json.dumps(report, indent=2))
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--scene", type=Path, default=DEFAULT_SCENE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    report = run(args)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"report": str(args.report),
                      "comparisons": len(report["comparisons"]),
                      "mismatches": len(report["mismatches"]),
                      "original_sha256": report["original_sha256"]}, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except OracleFailure as exc:
        print(f"hotspot original oracle failed: {exc}")
        raise SystemExit(1)
