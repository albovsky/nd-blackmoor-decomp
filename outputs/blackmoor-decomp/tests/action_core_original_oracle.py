#!/usr/bin/env python3
"""Compare the native action-state core with selected original x86 handlers.

The harness enters GAME.EXE's original dispatcher 0x427a50 under Unicorn. It
only compares action types 0x4d, 0x61, 0x6b and 0x71 with seeded action/world
state. The dependency eligibility leaf 0x423f57 is stubbed to a controlled
answer. Type 0x42ba3a completion and subtype-2 dependency reset remain original
code when reached. This is leaf-family evidence, not a scene scheduler or a
full-game equivalence claim.

Run from the workspace root with the isolated original-code interpreter:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/action_core_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
from dataclasses import dataclass
import hashlib
import json
import random
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any, Iterable

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_action_core import (
    ActionCoreAction,
    ActionCoreActionResult,
    ActionCoreWorld,
    ERR_UNSUPPORTED,
    OK,
    bytes_buffer,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_NATIVE = PROJECT / "build/libactioncore.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/action-core-validation.json"

DISPATCHER_VA = 0x427A50
DEPENDENCY_GATE_VA = 0x423F57
SET_VALUE_VA = 0x44B26A
COMPLETION_VA = 0x42BA3A
DEPENDENCY_RESET_VA = 0x423D33

ACTION_COUNT_VA = 0x5C39E3
ENGINE_PHASE_VA = 0x583999
EVENT_FLAGS_VA = 0x585801
DIFFICULTY_VA = 0x58C94F
SHORT_VALUES_VA = 0x58C959
FLOAT_VALUES_BASE_VA = 0x58C91D
ACTION_TYPE_BASE_VA = 0x5BB5E3
ACTION_COMPLETED_BASE_VA = 0x5BB625
ACTION_PHASE_BASE_VA = 0x5BB632
ACTION_DEPENDENCY_BASE_VA = 0x5BB5E9
ACTION_STRIDE = 0x8D
DEBUG_LOG_VA = 0x63A4CD

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
BODY_BASE = 0x20000000
BODY_SIZE = 0x40000
RETURN_SENTINEL = 0x30000000
ACTION_BODY_BASE = BODY_BASE + 0x1000
EVENT_FLAG_COUNT = 64


class OracleFailure(RuntimeError):
    pass


@dataclass(frozen=True)
class CoreAction:
    type: int
    subtype: int
    body: bytes
    eligible: bool = True
    completed_before: int = 0
    phase_before: int = 0


@dataclass(frozen=True)
class WorldSeed:
    short_values: tuple[int, ...]
    float_values: tuple[float, ...]
    difficulty: int
    event_flags: tuple[int, ...]


def i16(value: int) -> bytes:
    return struct.pack("<h", value)


def u32(machine: Any, address: int) -> int:
    return struct.unpack("<I", machine.mem_read(address, 4))[0]


def signed32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value if value < 0x80000000 else value - 0x100000000


def state_seed(rng: random.Random) -> WorldSeed:
    return WorldSeed(
        tuple(rng.randrange(-32768, 32768) for _ in range(30)),
        tuple(float(rng.randrange(-8000, 8001) / 4) for _ in range(10)),
        rng.randrange(-32768, 32768),
        tuple(rng.randrange(-0x80000000, 0x80000000)
              for _ in range(EVENT_FLAG_COUNT)),
    )


def action_cases() -> Iterable[tuple[str, WorldSeed, tuple[CoreAction, ...]]]:
    rng = random.Random(0x44B26A)

    # Boundary-focused SET VALUE cases, including both sentinels and the
    # original index>=40 no-op path when debug logging is off.
    boundary_rows = [
        (0, 0, 32760, 20),
        (29, 0, 9999, -7),
        (30, 0, 2.5, -3),
        (39, 0, 9999.0, 12),
        (7, 1, -123, 32767),
        (40, 0, 0, 12),
        (255, 1, 0, -99),
    ]
    for case_number, (index, mode, initial, value) in enumerate(boundary_rows):
        seed = state_seed(rng)
        shorts = list(seed.short_values)
        floats = list(seed.float_values)
        if index < 30:
            shorts[index] = int(initial)
        elif index < 40:
            floats[index - 30] = float(initial)
        seed = WorldSeed(tuple(shorts), tuple(floats), seed.difficulty, seed.event_flags)
        action = CoreAction(0x4D, 1, bytes((index, mode)) + i16(value))
        yield f"set-boundary-{case_number}", seed, (action,)

    for number in range(48):
        seed = state_seed(rng)
        index = rng.randrange(40)
        mode = rng.choice((0, 1, 7))
        shorts = list(seed.short_values)
        floats = list(seed.float_values)
        if index < 30:
            shorts[index] = rng.choice((9999, 32767, -32768, rng.randrange(-500, 501)))
        else:
            floats[index - 30] = rng.choice((9999.0, -1234.5, 0.25, float(rng.randrange(-500, 501))))
        seed = WorldSeed(tuple(shorts), tuple(floats), seed.difficulty, seed.event_flags)
        action = CoreAction(0x4D, rng.choice((0, 1, 2, 7)),
                            bytes((index, mode)) + i16(rng.randrange(-32768, 32768)))
        yield f"set-seeded-{number}", seed, (action,)

    # Fixed two- and ten-pair flag batches. Duplicates deliberately test the
    # original ascending write order; -1 pairs are ignored.
    for action_type, pair_count, family in ((0x61, 2, "flags-2"), (0x6B, 10, "flags-10")):
        for number in range(32):
            seed = state_seed(rng)
            pairs: list[tuple[int, int]] = []
            duplicate_target = rng.randrange(EVENT_FLAG_COUNT)
            for pair in range(pair_count):
                index = -1 if pair % 4 == 0 else rng.randrange(EVENT_FLAG_COUNT)
                if pair_count > 2 and pair in (1, pair_count - 1):
                    index = duplicate_target
                pairs.append((index, rng.randrange(-32768, 32768)))
            body = b"".join(i16(index) + i16(value) for index, value in pairs)
            action = CoreAction(action_type, rng.choice((0, 1, 2, 7)), body)
            yield f"{family}-seeded-{number}", seed, (action,)

    for number in range(24):
        seed = state_seed(rng)
        flag_index = -1 if number % 3 == 0 else rng.randrange(EVENT_FLAG_COUNT)
        body = i16(rng.randrange(-32768, 32768)) + i16(flag_index) + i16(
            rng.randrange(-32768, 32768)
        )
        action = CoreAction(0x71, rng.choice((0, 1, 2, 7)), body)
        yield f"difficulty-seeded-{number}", seed, (action,)

    # Eligibility is controlled at the original dependency leaf; the second
    # action observes the first action's later write because the original
    # dispatcher iterates its action table in ascending order.
    seed = state_seed(rng)
    ordered = (
        CoreAction(0x61, 1, i16(3) + i16(101) + i16(3) + i16(-202)),
        CoreAction(0x6B, 2, i16(3) + i16(303) +
                   b"".join(i16(-1) + i16(0) for _ in range(8)) + i16(3) + i16(-404)),
        CoreAction(0x71, 1, i16(-9) + i16(3) + i16(505)),
        CoreAction(0x4D, 7, bytes((31, 0)) + i16(-1), eligible=False,
                   completed_before=0, phase_before=17),
    )
    yield "ordered-multiple-actions-and-ineligible", seed, ordered

    # A completed action is skipped by the original outer dispatcher before
    # it reaches the dependency gate.
    completed = CoreAction(0x4D, 1, bytes((0, 0)) + i16(50),
                           eligible=False, completed_before=1, phase_before=91)
    yield "already-completed-action-skipped", state_seed(rng), (completed,)


class OriginalActionDispatcher:
    def __init__(self, pe: PEImage):
        try:
            from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, Uc
        except ImportError as exc:
            raise OracleFailure("Unicorn 2.x required; use work/tools/oracle-python/bin/python") from exc
        from unicorn.x86_const import UC_X86_REG_EAX

        self._eax = UC_X86_REG_EAX
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.mem_map(BODY_BASE, BODY_SIZE)
        self.uc.mem_map(RETURN_SENTINEL, 0x1000)
        self.uc.mem_write(RETURN_SENTINEL, b"\xCC")
        self._eligibility: list[bool] = []
        self._gate_calls = 0
        self._uc_hook = self.uc.hook_add(UC_HOOK_CODE, self._hook_code)

    @staticmethod
    def _return_from_gate(machine: Any) -> None:
        from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EIP

        esp = machine.reg_read(UC_X86_REG_ESP)
        return_address = u32(machine, esp)
        machine.reg_write(UC_X86_REG_ESP, esp + 8)  # return address + thiscall arg
        machine.reg_write(UC_X86_REG_EIP, return_address)

    def _hook_code(self, machine: Any, address: int, _size: int, _user_data: Any) -> None:
        if address != DEPENDENCY_GATE_VA:
            return
        outcome = self._eligibility.pop(0) if self._eligibility else False
        machine.reg_write(self._eax, int(outcome))
        self._gate_calls += 1
        self._return_from_gate(machine)

    def invoke(self, seed: WorldSeed, actions: tuple[CoreAction, ...]) -> dict[str, Any]:
        from unicorn.x86_const import (
            UC_X86_REG_EBP,
            UC_X86_REG_ECX,
            UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP,
            UC_X86_REG_ESP,
        )

        if len(seed.short_values) != 30 or len(seed.float_values) != 10:
            raise OracleFailure("oracle seed does not match the verified slot counts")
        if len(seed.event_flags) != EVENT_FLAG_COUNT:
            raise OracleFailure("oracle seed has an unexpected caller event-flag capacity")
        if len(actions) > 20:
            raise OracleFailure("oracle input exceeds the controlled action-table fixture")

        uc = self.uc
        uc.mem_write(SHORT_VALUES_VA,
                     struct.pack("<30h", *seed.short_values))
        uc.mem_write(FLOAT_VALUES_BASE_VA + 30 * 4,
                     struct.pack("<10f", *seed.float_values))
        uc.mem_write(DIFFICULTY_VA, struct.pack("<h", seed.difficulty))
        uc.mem_write(EVENT_FLAGS_VA,
                     struct.pack("<64i", *seed.event_flags))
        uc.mem_write(ACTION_COUNT_VA, struct.pack("<H", len(actions)))
        uc.mem_write(ENGINE_PHASE_VA, struct.pack("<i", 3))
        uc.mem_write(DEBUG_LOG_VA, b"\0")
        self._eligibility = []
        self._gate_calls = 0

        for index, action in enumerate(actions):
            record = index * ACTION_STRIDE
            body_address = ACTION_BODY_BASE + index * 0x100
            uc.mem_write(ACTION_TYPE_BASE_VA + record,
                         bytes((action.type & 0xFF, action.subtype & 0xFF)))
            uc.mem_write(ACTION_TYPE_BASE_VA + record + 2,
                         struct.pack("<I", body_address))
            uc.mem_write(body_address, action.body)
            uc.mem_write(ACTION_COMPLETED_BASE_VA + record,
                         bytes((action.completed_before & 0xFF,)))
            uc.mem_write(ACTION_PHASE_BASE_VA + record,
                         struct.pack("<I", action.phase_before & 0xFFFFFFFF))
            # FUN_00423d33 sees word 13 equal to zero and takes its bounded
            # dependency-record reset branch if subtype 2 reaches completion.
            dependency = ACTION_DEPENDENCY_BASE_VA + record
            uc.mem_write(dependency, bytes(0x38))
            if (action.type in (0x4D, 0x61, 0x6B, 0x71) and
                    not action.completed_before):
                self._eligibility.append(action.eligible)

        uc.mem_write(STACK_TOP - 4, struct.pack("<I", RETURN_SENTINEL))
        uc.reg_write(UC_X86_REG_ESP, STACK_TOP - 4)
        uc.reg_write(UC_X86_REG_EBP, 0)
        uc.reg_write(UC_X86_REG_ECX, 0)
        uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        uc.reg_write(UC_X86_REG_EIP, DISPATCHER_VA)
        try:
            uc.emu_start(DISPATCHER_VA, RETURN_SENTINEL,
                         timeout=10_000_000, count=2_000_000)
        except Exception as exc:
            raise OracleFailure(f"original dispatcher trapped: {exc}") from exc
        if (uc.reg_read(UC_X86_REG_EIP) != RETURN_SENTINEL or
                uc.reg_read(UC_X86_REG_ESP) != STACK_TOP):
            raise OracleFailure(
                "original dispatcher did not return normally: "
                f"EIP=0x{uc.reg_read(UC_X86_REG_EIP):08x}, "
                f"ESP=0x{uc.reg_read(UC_X86_REG_ESP):08x}"
            )
        if self._eligibility:
            raise OracleFailure(f"original dispatcher skipped {len(self._eligibility)} gate outcomes")

        action_results = []
        for index in range(len(actions)):
            record = index * ACTION_STRIDE
            action_results.append({
                "completed": uc.mem_read(ACTION_COMPLETED_BASE_VA + record, 1)[0],
                "phase": u32(uc, ACTION_PHASE_BASE_VA + record),
                "dependency_reset_marker": u32(uc, ACTION_DEPENDENCY_BASE_VA + record),
            })
        return {
            "short_values": list(struct.unpack("<30h", uc.mem_read(SHORT_VALUES_VA, 60))),
            "float_bits": [
                struct.pack("<f", value).hex()
                for value in struct.unpack("<10f", uc.mem_read(FLOAT_VALUES_BASE_VA + 30 * 4, 40))
            ],
            "difficulty": struct.unpack("<h", uc.mem_read(DIFFICULTY_VA, 2))[0],
            "event_flags": list(struct.unpack("<64i", uc.mem_read(EVENT_FLAGS_VA, 64 * 4))),
            "actions": action_results,
        }


def native_invoke(library: c.CDLL, seed: WorldSeed,
                  actions: tuple[CoreAction, ...]) -> dict[str, Any]:
    flags = (c.c_int32 * EVENT_FLAG_COUNT)(*seed.event_flags)
    world = ActionCoreWorld()
    world.short_values[:] = seed.short_values
    world.float_values[:] = seed.float_values
    world.difficulty = seed.difficulty
    world.event_flags = flags
    world.event_flag_count = EVENT_FLAG_COUNT

    backing: list[Any] = []
    views: list[ActionCoreAction] = []
    for action in actions:
        body = bytes_buffer(action.body) if action.body else None
        backing.append(body)
        body_pointer = c.cast(body, c.POINTER(c.c_uint8)) if body is not None else None
        views.append(ActionCoreAction(
            action.type,
            action.subtype,
            int(action.eligible),
            action.completed_before,
            action.phase_before,
            body_pointer,
            len(action.body),
        ))
    view_array = (ActionCoreAction * len(views))(*views) if views else None
    result_array = (ActionCoreActionResult * len(views))() if views else None
    status = library.action_core_dispatch(
        c.byref(world), view_array, len(views), result_array
    )
    if status == ERR_UNSUPPORTED:
        raise OracleFailure("oracle sample unexpectedly includes unsupported action type")
    if status != OK:
        raise OracleFailure(f"native action_core_dispatch failed with status {status}")

    return {
        "short_values": list(world.short_values),
        "float_bits": [struct.pack("<f", value).hex() for value in world.float_values],
        "difficulty": world.difficulty,
        "event_flags": list(flags),
        "actions": [
            {
                "completed": result_array[index].completed,
                "phase": result_array[index].phase,
                "dependency_reset_marker": int(result_array[index].reset_dependencies),
            }
            for index in range(len(views))
        ],
    }


def build_library() -> None:
    subprocess.run([str(PROJECT / "scripts/build_action_core.sh")], check=True)


def bind_library(path: Path) -> c.CDLL:
    library = c.CDLL(str(path.resolve()))
    library.action_core_dispatch.argtypes = [
        c.POINTER(ActionCoreWorld), c.POINTER(ActionCoreAction), c.c_size_t,
        c.POINTER(ActionCoreActionResult)
    ]
    library.action_core_dispatch.restype = c.c_int
    return library


def function_range_hash(pe: PEImage, start: int, end: int) -> str:
    offset = pe.va_to_file_offset(start, end - start)
    return hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest()


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    native_path = args.native_library.resolve()
    if not native_path.is_file():
        if native_path == DEFAULT_NATIVE.resolve():
            build_library()
        else:
            raise OracleFailure(f"requested native library unavailable: {native_path}")

    pe = PEImage.parse_and_map(args.exe)
    original_hash = hashlib.sha256(pe.data).hexdigest()
    if original_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {original_hash}")
    library = bind_library(native_path)
    oracle = OriginalActionDispatcher(pe)
    results: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []
    counts: dict[str, int] = {}
    cases = list(action_cases())
    for number, (label, seed, actions) in enumerate(cases, 1):
        original = oracle.invoke(seed, actions)
        native = native_invoke(library, seed, actions)
        counts[label.split("-", 1)[0]] = counts.get(label.split("-", 1)[0], 0) + 1
        if original != native:
            mismatch = {
                "case": number,
                "label": label,
                "actions": [
                    {"type": f"0x{action.type:02x}", "subtype": action.subtype,
                     "eligible": action.eligible, "body_hex": action.body.hex()}
                    for action in actions
                ],
                "original": original,
                "native": native,
            }
            mismatches.append(mismatch)
            if len(mismatches) >= 10:
                break
        results.append({"label": label, "action_count": len(actions)})

    code_ranges = [
        {"name": "0x427a50 original action dispatcher", "start": "0x427a50",
         "end_exclusive": "0x42acad",
         "sha256": function_range_hash(pe, DISPATCHER_VA, 0x42ACAD)},
        {"name": "0x44b26a set-value handler", "start": "0x44b26a",
         "end_exclusive": "0x44b3c8",
         "sha256": function_range_hash(pe, SET_VALUE_VA, 0x44B3C8)},
        {"name": "0x42ba3a completion helper", "start": "0x42ba3a",
         "end_exclusive": "0x42babf",
         "sha256": function_range_hash(pe, COMPLETION_VA, 0x42BABF)},
        {"name": "0x423d33 dependency-reset helper", "start": "0x423d33",
         "end_exclusive": "0x423da2",
         "sha256": function_range_hash(pe, DEPENDENCY_RESET_VA, 0x423DA2)},
        {"name": "0x423f57 eligibility helper (hooked)", "start": "0x423f57",
         "end_exclusive": "0x423fbb",
         "sha256": function_range_hash(pe, DEPENDENCY_GATE_VA, 0x423FBB)},
    ]
    report = {
        "scope": (
            "selected state-editing handlers 0x4d/0x61/0x6b/0x71 entered via original "
            "0x427a50 dispatcher; not a whole-scene or full-game comparison"
        ),
        "original_sha256": original_hash,
        "native_library_sha256": hashlib.sha256(native_path.read_bytes()).hexdigest(),
        "original_engine": "GAME.EXE PE32 x86, executed under Unicorn 2.1.4",
        "native_engine": "ARM64 macOS C shared library",
        "code_ranges": code_ranges,
        "controlled_hook": {
            "address": "0x423f57",
            "behavior": "returns seeded eligibility values; dependency evaluation is excluded",
        },
        "original_paths_left_real": [
            "0x427a50 switch branches for action types 0x4d, 0x61, 0x6b, and 0x71",
            "0x44b26a SET VALUE handler",
            "0x42ba3a completion behavior",
            "0x423d33 subtype-2 reset branch for a fixture whose field 13 is zero",
        ],
        "compared_cases": len(results),
        "case_groups": counts,
        "mismatches": mismatches,
        "float_scope": (
            "finite exactly representable initial values and signed-16 deltas only; "
            "NaN/Infinity are covered by native IEEE smoke assertions, not original-oracle claims"
        ),
        "event_flag_capacity_scope": (
            "64-entry oracle fixture; the native count checks caller storage bounds, "
            "not a claim about the original event-flag table capacity"
        ),
        "native_invalid_input_policy": (
            "index -1 skips; any other negative or index >= caller count returns an explicit "
            "bounds error before the action/dispatch writes. This safe native input policy "
            "does not claim the original performed equivalent bounds checks."
        ),
        "excluded": [
            "dependency expression evaluation, action timing, full scene dispatch, and unknown action implementations",
            "original debug-log side effects for SET VALUE indices >= 40",
            "full-game behavior, scene/runtime ownership, rendering, audio, phone controls, and UI",
        ],
        "limitations": [
            "the 0x423f57 dependency result is controlled by the harness",
            "oracle cases exercise only the selected action families and bounded fixtures",
            "this report does not establish original event-flag allocation capacity",
        ],
    }
    if mismatches:
        raise OracleFailure(json.dumps(report, indent=2))
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    try:
        report = run(args)
    except Exception as exc:
        print(f"action_core_original_oracle: {exc}", file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in report.items()
                      if key not in ("code_ranges", "mismatches")}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
