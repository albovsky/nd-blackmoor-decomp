#!/usr/bin/env python3
"""Compare native nested condition trees with GAME.EXE's x86 loader/runtime.

The original executable is mapped as a PE image and entered at dependency
loader 0x424aa8, evaluator wrapper 0x423f57, and reset 0x423d33. The loader,
leaf evaluator, branch reducer, and reset traversal execute as original x86.
Only the allocator, the debug tree printer, and the malformed-input stop point
are intercepted. No game loop or Windows API is started.
"""

from __future__ import annotations

import argparse
import collections
import ctypes as c
import hashlib
import itertools
import json
from pathlib import Path
import random
import struct
import sys
from typing import Iterable, Sequence

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up


ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_SCENE_DIR = ROOT / "work/analysis/hiff-resources"
DEFAULT_NATIVE_LIBRARY = PROJECT / "build/libsceneconditions.dylib"
DEFAULT_SCENE_LIBRARY = PROJECT / "build/libsceneresource.dylib"
DEFAULT_JSON_REPORT = ROOT / "work/analysis/conditions-nested-validation.json"
DEFAULT_MARKDOWN_REPORT = ROOT / "work/analysis/conditions-nested-validation.md"

ORIGINAL_LOADER = 0x424AA8
ORIGINAL_EVALUATOR = 0x423F57
ORIGINAL_RESET = 0x423D33
ORIGINAL_BAD_TREE_LABEL = 0x425B40
ORIGINAL_DEBUG_TREE_PRINTER = 0x425B8B
ORIGINAL_ALLOCATOR = 0x51DC43
RETURN_SENTINEL = 0x30000000
STACK_TOP = 0x10008000
ENGINE_THIS = 0x20001000
ACTION_STORAGE = 0x20002000
RECORD_STORAGE = 0x20003000
ARENA_START = 0x20010000
ARENA_END = 0x20200000
CONDITION_LIMITS = {0, 1, 2, 3, 4, 5, 6, 9}


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


class SceneDependencyInfo(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("or_after", c.c_int16),
        ("raw_bytes", c.POINTER(c.c_uint8)),
        ("fields", c.c_int16 * 8),
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


# Read-only mirrors of the private structures in scene_conditions.c. They let
# this oracle compare the native tree's topology with the original linked tree
# without changing the production ABI or adding a test-only native entry point.
class NativeConditionNode(c.Structure):
    _fields_ = [
        ("kind", c.c_int),
        ("parent", c.c_size_t),
        ("first_child", c.c_size_t),
        ("last_child", c.c_size_t),
        ("next_sibling", c.c_size_t),
        ("child_count", c.c_size_t),
        ("opcode", c.c_int16),
        ("fields", c.c_int16 * 8),
        ("or_after", c.c_int16),
        ("status", c.c_int32),
        ("time_value", c.c_int32),
        ("time_end_value", c.c_int32),
        ("source_record", c.c_size_t),
    ]


class NativeConditionTree(c.Structure):
    _fields_ = [
        ("nodes", c.POINTER(NativeConditionNode)),
        ("node_count", c.c_size_t),
        ("record_count", c.c_size_t),
        ("root", c.c_size_t),
        # RT-4 private additions (sidecars, opcode-11 slot, threshold state).
        ("runtime", c.c_void_p),
        ("selected_leaf", c.c_void_p),
        ("threshold_state", c.c_void_p),
        ("thresholds_armed", c.c_int),
    ]


def signed32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value if value < 0x80000000 else value - 0x100000000


def minutes(first: int, second: int) -> int:
    return signed32(first * 60 + second)


def milliseconds(fields: Sequence[int]) -> int:
    return signed32(fields[4] * 3_600_000 + fields[5] * 60_000 +
                    fields[6] * 1_000 + fields[7])


def dependency_record(fields: Sequence[int]) -> SceneDependencyInfo:
    if len(fields) != 8:
        raise ValueError("dependency records must contain eight signed words")
    row = tuple(int(value) for value in fields)
    record = SceneDependencyInfo()
    record.opcode = row[0] & 0xFFFF
    record.or_after = row[3]
    record.fields[:] = row
    return record


def open_scene_library(path: Path):
    lib = c.CDLL(str(path.resolve()))
    lib.scene_resource_open_memory.argtypes = [
        c.c_void_p, c.c_size_t, c.c_char_p, c.c_size_t
    ]
    lib.scene_resource_open_memory.restype = c.c_void_p
    lib.scene_resource_close.argtypes = [c.c_void_p]
    lib.scene_resource_action_count.argtypes = [c.c_void_p]
    lib.scene_resource_action_count.restype = c.c_size_t
    lib.scene_resource_action_at.argtypes = [
        c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)
    ]
    lib.scene_resource_action_at.restype = c.c_int
    lib.scene_resource_dependency_at.argtypes = [
        c.c_void_p, c.c_size_t, c.c_size_t, c.POINTER(SceneDependencyInfo)
    ]
    lib.scene_resource_dependency_at.restype = c.c_int
    return lib


def parsed_nested_actions(scene_dir: Path, scene_library: Path):
    lib = open_scene_library(scene_library)
    parsed_files = 0
    actions = []
    for path in sorted(scene_dir.glob("*.bin")):
        data = path.read_bytes()
        storage = (c.c_uint8 * len(data)).from_buffer_copy(data)
        error = c.create_string_buffer(256)
        scene = lib.scene_resource_open_memory(storage, len(data), error, len(error))
        if not scene:
            continue
        parsed_files += 1
        try:
            for action_index in range(lib.scene_resource_action_count(scene)):
                action = SceneActionInfo()
                if lib.scene_resource_action_at(scene, action_index, c.byref(action)) != 0:
                    raise RuntimeError(f"could not read action {action_index} from {path.name}")
                rows = []
                for dependency_index in range(action.dependency_count):
                    record = SceneDependencyInfo()
                    status = lib.scene_resource_dependency_at(
                        scene, action_index, dependency_index, c.byref(record)
                    )
                    if status != 0:
                        raise RuntimeError(
                            f"could not read dependency {dependency_index} from {path.name}"
                        )
                    rows.append(tuple(int(value) for value in record.fields))
                if any(row[0] == 0x12 for row in rows):
                    description = action.description.decode("utf-8", "replace").rstrip("\0")
                    actions.append({
                        "case_id": f"{path.name}:action-{action_index}:{description}",
                        "resource": path.name,
                        "action_index": action_index,
                        "description": description,
                        "rows": rows,
                    })
        finally:
            lib.scene_resource_close(scene)
    return parsed_files, actions


def normalize_marker(value: int) -> int:
    return int(value == 1)


def expected_topology(rows: Sequence[Sequence[int]]):
    root = {"kind": 1, "marker": 0, "fields": None, "children": []}
    stack = [root]
    openers = []
    marker_mismatches = []
    for index, source_row in enumerate(rows):
        row = tuple(int(value) for value in source_row)
        if row[0] == 0x12:
            node = {"kind": 1, "marker": normalize_marker(row[3]),
                    "fields": row, "children": []}
            stack[-1]["children"].append(node)
            stack.append(node)
            openers.append((index, row[3]))
        elif row[0] == 0x13:
            if len(stack) == 1:
                raise ValueError("unmatched close record")
            opener_index, opener_marker = openers.pop()
            if normalize_marker(opener_marker) != normalize_marker(row[3]):
                marker_mismatches.append({
                    "open_index": opener_index,
                    "close_index": index,
                    "open_marker": opener_marker,
                    "close_marker": row[3],
                })
            stack.pop()
        else:
            stack[-1]["children"].append({
                "kind": 2, "marker": normalize_marker(row[3]),
                "fields": row, "children": [],
            })
    if len(stack) != 1:
        raise ValueError("unmatched open record")
    return root, marker_mismatches


def topology_tuple(node):
    if node["kind"] == 1:
        return ("branch", node["marker"],
                tuple(topology_tuple(child) for child in node["children"]))
    # Compare effective runtime marker plus the remaining leaf fields. The
    # original stores its boolean marker in this slot; native also exposes the
    # raw source record in fields[], so that storage difference is reported
    # separately rather than being confused with tree topology.
    fields = list(node["fields"])
    fields[3] = node["marker"]
    return ("leaf", tuple(fields))


def leaf_marker_storage_differences(expected_nodes, original_nodes, native_nodes,
                                    path=()):
    if not (len(expected_nodes) == len(original_nodes) == len(native_nodes)):
        raise RuntimeError("cannot map leaf storage: child counts differ")
    differences = []
    for child_index, (expected, original, native) in enumerate(
        zip(expected_nodes, original_nodes, native_nodes)
    ):
        child_path = path + (child_index,)
        if not (expected["kind"] == original["kind"] == native["kind"]):
            raise RuntimeError("cannot map leaf storage: node kinds differ")
        if expected["kind"] == 1:
            differences.extend(leaf_marker_storage_differences(
                expected["children"], original["children"], native["children"],
                child_path,
            ))
            continue
        source_marker = int(expected["fields"][3])
        original_marker_slot = int(original["fields"][3])
        native_marker_slot = int(native["fields"][3])
        expected_effective_marker = normalize_marker(source_marker)
        original_effective_marker = int(original["marker"])
        native_effective_marker = int(native["marker"])
        if (original_marker_slot != source_marker or native_marker_slot != source_marker or
            original_effective_marker != expected_effective_marker or
            native_effective_marker != expected_effective_marker):
            differences.append({
                "child_path": list(child_path),
                "source_record_marker": source_marker,
                "original_tree_marker_slot": original_marker_slot,
                "native_fields_marker_slot": native_marker_slot,
                "expected_effective_marker": expected_effective_marker,
                "original_effective_marker": original_effective_marker,
                "native_effective_marker": native_effective_marker,
                "original_slot_matches_raw_source": original_marker_slot == source_marker,
                "native_fields_retain_raw_source": native_marker_slot == source_marker,
                "effective_markers_match": (
                    original_effective_marker == native_effective_marker ==
                    expected_effective_marker
                ),
            })
    return differences


def original_preflight_reason(rows: Sequence[Sequence[int]]) -> str | None:
    open_count = sum(row[0] == 0x12 for row in rows)
    close_count = sum(row[0] == 0x13 for row in rows)
    if open_count != close_count:
        return "open_close_count"
    for index, row in enumerate(rows):
        if row[0] == 0x12 and any(
            index + distance < len(rows) and rows[index + distance][0] == 0x13
            for distance in (1, 2)
        ):
            return "fewer_than_two_enclosed_source_records"
    _tree, marker_mismatches = expected_topology(rows)
    if marker_mismatches:
        return "booleanized_open_close_marker_mismatch"
    return None


class OriginalMachine:
    """One Unicorn machine that executes original x86 dependency routines."""

    def __init__(self, executable: Path):
        from unicorn import UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, Uc
        from unicorn.x86_const import (
            UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP, UC_X86_REG_ESP,
        )

        self._regs = (UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_EFLAGS,
                     UC_X86_REG_EIP, UC_X86_REG_ESP)
        self._Uc = Uc
        self._hook_code = UC_HOOK_CODE
        self._reg_eax, self._reg_ecx, self._reg_eflags, self._reg_eip, self._reg_esp = self._regs
        self.pe = PEImage.parse_and_map(executable)
        self.executable_sha256 = hashlib.sha256(self.pe.data).hexdigest()
        if self.executable_sha256 != EXPECTED_EXE_SHA256:
            raise ValueError(f"GAME.EXE identity mismatch: {self.executable_sha256}")
        self.machine = Uc(UC_ARCH_X86, UC_MODE_32)
        self.machine.mem_map(self.pe.image_base, align_up(self.pe.size_of_image))
        self.machine.mem_write(self.pe.image_base, self.pe.image)
        self.machine.mem_map(0x10000000, 0x10000)
        self.machine.mem_map(0x20000000, 0x200000)
        self.machine.mem_map(0x30000000, 0x1000)
        self.arena_cursor = ARENA_START
        self.allocator_calls = 0
        self.debug_printer_calls = 0
        self.bad_tree_stops = 0
        self._hook_error = None
        self.machine.hook_add(self._hook_code, self._on_code,
                              begin=ORIGINAL_ALLOCATOR, end=ORIGINAL_ALLOCATOR)
        self.machine.hook_add(self._hook_code, self._on_code,
                              begin=ORIGINAL_DEBUG_TREE_PRINTER,
                              end=ORIGINAL_DEBUG_TREE_PRINTER)
        self.machine.hook_add(self._hook_code, self._on_code,
                              begin=ORIGINAL_BAD_TREE_LABEL,
                              end=ORIGINAL_BAD_TREE_LABEL)

    def _return_from_intercepted_call(self, uc):
        sp = uc.reg_read(self._reg_esp)
        return_address = struct.unpack("<I", uc.mem_read(sp, 4))[0]
        uc.reg_write(self._reg_esp, sp + 4)
        uc.reg_write(self._reg_eip, return_address)

    def _on_code(self, uc, address, _size, _user_data):
        if address == ORIGINAL_ALLOCATOR:
            sp = uc.reg_read(self._reg_esp)
            requested = struct.unpack("<I", uc.mem_read(sp + 4, 4))[0]
            start = (self.arena_cursor + 3) & ~3
            end = start + requested
            if requested == 0 or end > ARENA_END:
                self._hook_error = f"bounded arena exhausted for {requested} bytes"
                uc.emu_stop()
                return
            uc.mem_write(start, b"\0" * requested)
            self.arena_cursor = end
            self.allocator_calls += 1
            uc.reg_write(self._reg_eax, start)
            self._return_from_intercepted_call(uc)
        elif address == ORIGINAL_DEBUG_TREE_PRINTER:
            self.debug_printer_calls += 1
            self._return_from_intercepted_call(uc)
        elif address == ORIGINAL_BAD_TREE_LABEL:
            self.bad_tree_stops += 1
            uc.emu_stop()

    def call(self, address: int, args: Sequence[int], ecx: int) -> tuple[int, bool]:
        from unicorn import UcError

        self._hook_error = None
        words = [RETURN_SENTINEL, *[value & 0xFFFFFFFF for value in args]]
        self.machine.mem_write(STACK_TOP, struct.pack("<" + "I" * len(words), *words))
        self.machine.reg_write(self._reg_esp, STACK_TOP)
        self.machine.reg_write(self._reg_ecx, ecx)
        self.machine.reg_write(self._reg_eflags, 0x202)
        self.machine.reg_write(self._reg_eip, address)
        try:
            self.machine.emu_start(address, RETURN_SENTINEL,
                                   timeout=5_000_000, count=2_000_000)
        except UcError as error:
            eip = self.machine.reg_read(self._reg_eip)
            if self._hook_error is not None:
                raise RuntimeError(self._hook_error) from error
            raise RuntimeError(f"x86 call 0x{address:x} failed at 0x{eip:x}: {error}") from error
        if self._hook_error is not None:
            raise RuntimeError(self._hook_error)
        eip = self.machine.reg_read(self._reg_eip)
        if address == ORIGINAL_LOADER and eip == ORIGINAL_BAD_TREE_LABEL:
            return 0, False
        if eip != RETURN_SENTINEL:
            raise RuntimeError(f"x86 call 0x{address:x} stopped at 0x{eip:x}")
        return self.machine.reg_read(self._reg_eax), True

    def load(self, rows: Sequence[Sequence[int]]) -> tuple[bool, int]:
        self.arena_cursor = ARENA_START
        self.machine.mem_write(ENGINE_THIS, b"\0" * 0x700)
        self.machine.mem_write(ACTION_STORAGE, b"\0" * 0x100)
        self.machine.mem_write(RECORD_STORAGE, b"\0" * (max(1, len(rows)) * 16))
        self.machine.mem_write(0x0063A4CD, b"\0")  # suppress diagnostic logging
        if rows:
            raw = b"".join(struct.pack("<8h", *row) for row in rows)
            self.machine.mem_write(RECORD_STORAGE, raw)
        end = RECORD_STORAGE + 16 * len(rows)
        _result, accepted = self.call(
            ORIGINAL_LOADER,
            [ACTION_STORAGE, RECORD_STORAGE, end, RECORD_STORAGE],
            ENGINE_THIS,
        )
        return accepted, ACTION_STORAGE + 0x36

    def evaluate(self, root: int, state: "ConditionValues") -> int:
        state.write_original_globals(self.machine)
        result, accepted = self.call(ORIGINAL_EVALUATOR, [root, 0], ENGINE_THIS)
        if not accepted:
            raise RuntimeError("original evaluator did not return")
        return c.c_int32(result).value

    def reset(self, root: int) -> None:
        _result, accepted = self.call(ORIGINAL_RESET, [root], ENGINE_THIS)
        if not accepted:
            raise RuntimeError("original reset did not return")

    def i32(self, address: int) -> int:
        return struct.unpack("<i", self.machine.mem_read(address, 4))[0]

    def u32(self, address: int) -> int:
        return struct.unpack("<I", self.machine.mem_read(address, 4))[0]

    def original_topology(self, branch_address: int):
        all_statuses = []

        def walk_branch(address: int):
            status = self.i32(address)
            all_statuses.append(status)
            child_count = self.u32(address + 0x18)
            node_address = self.u32(address + 4)
            children = []
            seen = 0
            while node_address != 0:
                if seen > 512:
                    raise RuntimeError("original sibling chain exceeds loader bound")
                kind = self.u32(node_address)
                fields = struct.unpack("<8h", self.machine.mem_read(node_address + 0x10, 16))
                marker = normalize_marker(fields[3])
                node_status = self.i32(node_address + 4)
                all_statuses.append(node_status)
                if kind == 1:
                    child_branch = self.u32(node_address + 0x44)
                    if child_branch == 0:
                        raise RuntimeError("original branch node has no child branch")
                    descendants = walk_branch(child_branch)
                    children.append({
                        "kind": 1, "marker": marker, "fields": fields,
                        "children": descendants, "status": node_status,
                    })
                elif kind == 2:
                    children.append({
                        "kind": 2, "marker": marker, "fields": fields,
                        "children": [], "status": node_status,
                    })
                else:
                    raise RuntimeError(f"unexpected original node kind {kind}")
                node_address = self.u32(node_address + 0x38)
                seen += 1
            if seen != child_count:
                raise RuntimeError(
                    f"original branch child count says {child_count}, linked {seen} nodes"
                )
            return children

        children = walk_branch(branch_address)
        return children, all_statuses


class ConditionValues:
    def __init__(self, rows: Sequence[Sequence[int]], variant: str, seed: int):
        rng = random.Random(seed)
        maxima = {"inventory": 0, "flags": 0, "values": 0, "visits": 0}
        for row in rows:
            if row[0] == 1:
                maxima["inventory"] = max(maxima["inventory"], row[1])
            elif row[0] == 2:
                maxima["flags"] = max(maxima["flags"], row[1])
            elif row[0] == 3:
                maxima["values"] = max(maxima["values"], row[1])
            elif row[0] == 9:
                maxima["visits"] = max(maxima["visits"], row[4])
        if min(maxima.values()) < 0 or max(maxima.values()) > 8191:
            raise ValueError(f"state index exceeds bounded oracle globals: {maxima}")
        self.inventory = [rng.choice((0, 1, 2)) for _ in range(maxima["inventory"] + 1)]
        self.flags = [rng.choice((-2, -1, 0, 1, 2)) for _ in range(maxima["flags"] + 1)]
        self.values = [rng.choice((-2, -1, 0, 1, 2)) for _ in range(maxima["values"] + 1)]
        self.visits = [rng.choice((-2, -1, 0, 1, 2)) for _ in range(maxima["visits"] + 1)]
        self.selected = -1
        self.timer4 = rng.randrange(-10_000, 10_000_001)
        self.timer5 = rng.randrange(-10_000, 10_000_001)
        self.clock = rng.randrange(-10, 1_451)
        if variant == "zero":
            self.inventory = [0] * len(self.inventory)
            self.flags = [0] * len(self.flags)
            self.values = [0] * len(self.values)
            self.visits = [0] * len(self.visits)
            self.selected = 0
            self.timer4 = 0
            self.timer5 = 0
            self.clock = 0
        elif variant in ("target", "inverse"):
            self._set_target_state(rows, inverse=(variant == "inverse"))
        elif variant != "mixed":
            raise ValueError(f"unknown condition state variant: {variant}")

    def _set_target_state(self, rows: Sequence[Sequence[int]], inverse: bool):
        for row in rows:
            opcode = row[0]
            if opcode == 1:
                index, expected = row[1], row[2]
                if expected in (0, 1):
                    self.inventory[index] = (1 - expected) if inverse else expected
                else:
                    self.inventory[index] = 0
                self.selected = -1
            elif opcode in (2, 3):
                values = self.flags if opcode == 2 else self.values
                expected = row[2]
                values[row[1]] = expected + 1 if inverse else expected
            elif opcode in (4, 5):
                threshold = milliseconds(row)
                if opcode == 4:
                    self.timer4 = signed32(threshold - 1 if inverse else threshold)
                else:
                    self.timer5 = signed32(threshold - 1 if inverse else threshold)
            elif opcode == 6:
                expected = row[2]
                start = minutes(row[4], row[5])
                end = minutes(row[6], row[7])
                if expected == 0:
                    self.clock = start - 1 if inverse else start
                elif expected == 1:
                    self.clock = start + 1 if inverse else start
                elif expected == 2:
                    self.clock = start + 1 if inverse else start
                elif expected == 3:
                    if end < start:
                        self.clock = (start + 60) % 1440 if not inverse else end + 60
                    else:
                        self.clock = start - 1 if inverse else start
            elif opcode == 9:
                index, limit, comparison = row[4], row[5], row[7]
                if comparison == 1:
                    self.visits[index] = limit if inverse else limit - 1
                elif comparison == 2:
                    self.visits[index] = limit if inverse else limit + 1
                elif comparison == 3:
                    self.visits[index] = limit + 1 if inverse else limit

    def native(self):
        inventory = (c.c_int32 * len(self.inventory))(*self.inventory)
        flags = (c.c_int32 * len(self.flags))(*self.flags)
        values = (c.c_int32 * len(self.values))(*self.values)
        visits = (c.c_int16 * len(self.visits))(*self.visits)
        state = SceneConditionState(
            inventory, len(self.inventory), self.selected,
            flags, len(self.flags), values, len(self.values),
            visits, len(self.visits), self.timer4, self.timer5, self.clock,
        )
        return state, (inventory, flags, values, visits)

    def write_original_globals(self, machine):
        def packed_i32(values):
            return struct.pack("<" + "i" * len(values), *values)

        machine.mem_write(0x00583BD5, packed_i32(self.inventory))
        machine.mem_write(0x00585801, packed_i32(self.flags))
        machine.mem_write(0x00581A71, packed_i32(self.values))
        machine.mem_write(0x00587B2D,
                          struct.pack("<" + "h" * len(self.visits), *self.visits))
        machine.mem_write(0x00583A29, struct.pack("<i", self.selected))
        machine.mem_write(0x00585D37, struct.pack("<i", self.timer4))
        machine.mem_write(0x00585D41, struct.pack("<i", self.timer5))
        machine.mem_write(0x00585D4B, struct.pack("<i", self.clock))


def native_library(path: Path):
    lib = c.CDLL(str(path.resolve()))
    lib.scene_conditions_build.argtypes = [
        c.POINTER(SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)
    ]
    lib.scene_conditions_build.restype = c.c_int
    lib.scene_conditions_destroy.argtypes = [c.c_void_p]
    lib.scene_conditions_reset.argtypes = [c.c_void_p]
    lib.scene_conditions_evaluate.argtypes = [
        c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(c.c_int),
        c.POINTER(c.c_uint16),
    ]
    lib.scene_conditions_evaluate.restype = c.c_int
    return lib


def native_topology(tree_pointer: c.c_void_p):
    tree = c.cast(tree_pointer, c.POINTER(NativeConditionTree)).contents
    if c.sizeof(NativeConditionNode) != 88 or c.sizeof(NativeConditionTree) != 64:
        raise RuntimeError("private native condition layout changed; refresh read-only mirror")
    if tree.node_count > 513 or tree.root >= tree.node_count:
        raise RuntimeError("native condition tree metadata exceeds oracle bounds")
    statuses = []

    def walk_branch(branch_index: int):
        children = []
        node_index = tree.nodes[branch_index].first_child
        seen = 0
        while node_index != c.c_size_t(-1).value:
            node = tree.nodes[node_index]
            marker = normalize_marker(node.or_after)
            statuses.append(int(node.status))
            if node.kind == 1:
                descendants = walk_branch(node_index)
                children.append({
                    "kind": 1, "marker": marker, "fields": tuple(node.fields),
                    "children": descendants, "status": int(node.status),
                })
            elif node.kind == 2:
                children.append({
                    "kind": 2, "marker": marker, "fields": tuple(node.fields),
                    "children": [], "status": int(node.status),
                })
            else:
                raise RuntimeError(f"unexpected native node kind {node.kind}")
            node_index = node.next_sibling
            seen += 1
            if seen > tree.node_count:
                raise RuntimeError("native sibling chain exceeds node count")
        if seen != tree.nodes[branch_index].child_count:
            raise RuntimeError("native child count differs from sibling chain")
        return children

    root_status = int(tree.nodes[tree.root].status)
    statuses.append(root_status)
    children = walk_branch(tree.root)
    return children, statuses, int(tree.record_count), int(tree.node_count)


def native_evaluate(lib, tree: c.c_void_p, values: ConditionValues) -> int:
    state, _arrays = values.native()
    output = c.c_int(-99)
    unsupported = c.c_uint16(0)
    status = lib.scene_conditions_evaluate(
        tree, c.byref(state), c.byref(output), c.byref(unsupported)
    )
    if status != 0:
        raise RuntimeError(
            f"native evaluation error {status}, opcode {unsupported.value}"
        )
    return int(output.value)


def topology_signature(children):
    return topology_tuple({"kind": 1, "marker": 0, "children": children})[2]


def synthetic_cases():
    def row(opcode, index=0, condition=0, marker=0, extra=(0, 0, 0, 0)):
        return (opcode, index, condition, marker, *extra)

    edge_shapes = []
    for name, opener, closer, expected_accept in (
        ("canonical_and", 0, 0, True),
        ("canonical_or", 1, 1, True),
        ("noncanonical_false_pair_2_to_0", 2, 0, True),
        ("noncanonical_false_pair_minus1_to_0", -1, 0, True),
        ("noncanonical_false_pair_2_to_2", 2, 2, True),
        ("true_marker_mismatch_1_to_0", 1, 0, False),
        ("true_marker_mismatch_0_to_1", 0, 1, False),
    ):
        edge_shapes.append({
            "case_id": name,
            "rows": [row(0x12, marker=opener), row(2, 0, 1),
                     row(2, 1, 0), row(0x13, marker=closer)],
            "expected_original_accept": expected_accept,
            "kind": "marker_pair",
        })
    edge_shapes.extend((
        {
            "case_id": "empty_group_preflight",
            "rows": [row(0x12), row(0x13)],
            "expected_original_accept": False,
            "kind": "source_record_arity",
        },
        {
            "case_id": "one_leaf_group_preflight",
            "rows": [row(0x12), row(2, 0, 1), row(0x13)],
            "expected_original_accept": False,
            "kind": "source_record_arity",
        },
        {
            "case_id": "outer_branch_with_one_nested_branch_child",
            "rows": [row(0x12), row(0x12), row(2, 0, 1), row(2, 1, 0),
                     row(0x13), row(0x13)],
            "expected_original_accept": True,
            "kind": "source_record_arity",
        },
    ))

    truth_tables = []
    # Root is A AND (B OR C) AND D. This checks that the inner OR stays
    # inside its own branch while the root combines the branch with AND.
    truth_tables.append({
        "case_id": "synthetic_root_and_nested_or",
        "rows": [row(2, 0, 1), row(0x12), row(2, 1, 1, 1),
                 row(2, 2, 1), row(0x13), row(2, 3, 1)],
        "truth_indices": (0, 1, 2, 3),
    })
    # Root is A OR (B AND C) OR D. Branch marker and leaf markers must
    # reduce at the correct sibling level.
    truth_tables.append({
        "case_id": "synthetic_root_or_nested_and",
        "rows": [row(2, 0, 1, 1), row(0x12, marker=1), row(2, 1, 1),
                 row(2, 2, 1), row(0x13, marker=1), row(2, 3, 1)],
        "truth_indices": (0, 1, 2, 3),
    })
    # Two nested levels test that each branch closes back to its own parent.
    truth_tables.append({
        "case_id": "synthetic_three_level_scope",
        "rows": [row(2, 0, 1), row(0x12), row(2, 1, 1, 1),
                 row(0x12, marker=1), row(2, 2, 1), row(2, 3, 1),
                 row(0x13, marker=1), row(2, 4, 1), row(0x13)],
        "truth_indices": (0, 1, 2, 3, 4),
    })
    # Inputs 2 and -1 must not act as OR links; only value 1 does. The enclosing
    # branch makes this a nested reducer comparison. Full storage is compared
    # separately so booleanization differences remain visible.
    truth_tables.append({
        "case_id": "synthetic_nested_raw_leaf_or_markers",
        "rows": [row(0x12), row(2, 0, 1, 2), row(2, 1, 1, -1),
                 row(2, 2, 1, 1), row(2, 3, 1), row(0x13)],
        "truth_indices": (0, 1, 2, 3),
    })
    return edge_shapes, truth_tables


def original_code_ranges(pe: PEImage):
    windows = [
        ("reset_entry", 0x423D33, 0x423DA2),
        ("reset_traversal_window", 0x423DA2, 0x423F57),
        ("evaluate_wrapper_window", 0x423F57, 0x42406D),
        ("branch_reducer_window", 0x42406D, 0x424201),
        ("recursive_evaluator_window", 0x424201, 0x424346),
        ("leaf_evaluator_window", 0x424346, 0x424AA8),
        ("dependency_loader_window", 0x424AA8, 0x425B8B),
    ]
    result = []
    for name, start, end in windows:
        offset = pe.va_to_file_offset(start, end - start)
        result.append({
            "name": name,
            "start_va": f"0x{start:08x}",
            "end_va_exclusive": f"0x{end:08x}",
            "byte_count": end - start,
            "sha256": hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest(),
            "range_basis": "from recovered entry VA to next recovered entry VA; a code window, not an asserted compiler function size",
        })
    return result


def evaluate_native_case(lib, rows):
    record_array = (SceneDependencyInfo * len(rows))(
        *(dependency_record(row) for row in rows)
    )
    tree = c.c_void_p()
    status = lib.scene_conditions_build(record_array, len(rows), c.byref(tree))
    return status, tree


def compare_case(machine: OriginalMachine, lib, rows, case_id: str,
                 evaluate: bool, variants: Sequence[str], seed: int):
    expected, marker_mismatches = expected_topology(rows)
    preflight = original_preflight_reason(rows)
    original_accepted, original_root = machine.load(rows)
    record_array = (SceneDependencyInfo * len(rows))(
        *(dependency_record(row) for row in rows)
    ) if rows else None
    native_tree = c.c_void_p()
    native_status = lib.scene_conditions_build(
        record_array, len(rows), c.byref(native_tree)
    )
    native_accepted = native_status == 0 and bool(native_tree.value)
    result = {
        "case_id": case_id,
        "record_count": len(rows),
        "original_preflight_reason": preflight,
        "original_accepted": original_accepted,
        "native_status": native_status,
        "native_accepted": native_accepted,
        "marker_mismatch_count": len(marker_mismatches),
    }
    if preflight is not None and original_accepted:
        raise AssertionError(f"original accepted {case_id} despite predicted {preflight}")
    if preflight is None and not original_accepted:
        raise AssertionError(f"original rejected {case_id} without predicted preflight failure")
    if original_accepted != native_accepted:
        result["constructor_outcome_mismatch"] = True
    else:
        result["constructor_outcome_mismatch"] = False
    if original_accepted and native_accepted:
        original_nodes, original_branch_statuses = machine.original_topology(original_root)
        native_nodes, native_statuses, native_record_count, native_node_count = native_topology(native_tree)
        expected_children = expected["children"]
        expected_signature = topology_signature(expected_children)
        original_signature = topology_signature(original_nodes)
        native_signature = topology_signature(native_nodes)
        marker_storage_differences = leaf_marker_storage_differences(
            expected_children, original_nodes, native_nodes,
        )
        result.update({
            "original_topology_matches_records": original_signature == expected_signature,
            "native_topology_matches_records": native_signature == expected_signature,
            "original_native_topology_matches": original_signature == native_signature,
            "native_record_count": native_record_count,
            "native_node_count": native_node_count,
            "leaf_marker_storage_differences": marker_storage_differences,
            "effective_leaf_marker_mismatch_count": sum(
                not item["effective_markers_match"] for item in marker_storage_differences
            ),
            "native_leaf_source_marker_mismatch_count": sum(
                not item["native_fields_retain_raw_source"]
                for item in marker_storage_differences
            ),
        })
        if original_signature != expected_signature or native_signature != expected_signature:
            result["topology_mismatch"] = True
        else:
            result["topology_mismatch"] = False
        if evaluate:
            comparisons = []
            for variant_index, variant in enumerate(variants):
                values = ConditionValues(rows, variant, seed + variant_index)
                original_result = machine.evaluate(original_root, values)
                native_result = native_evaluate(lib, native_tree, values)
                comparisons.append({
                    "variant": variant,
                    "original": original_result,
                    "native": native_result,
                    "match": original_result == native_result,
                })
            # Both reset implementations run after the same evaluation history.
            machine.reset(original_root)
            lib.scene_conditions_reset(native_tree)
            original_reset_statuses = machine.original_topology(original_root)[1]
            _nodes, native_reset_statuses, _records, _count = native_topology(native_tree)
            result["original_reset_all_zero"] = all(value == 0 for value in original_reset_statuses)
            result["native_reset_all_zero"] = all(value == 0 for value in native_reset_statuses)
            after_reset_values = ConditionValues(rows, "target", seed + len(variants) + 17)
            original_after_reset = machine.evaluate(original_root, after_reset_values)
            native_after_reset = native_evaluate(lib, native_tree, after_reset_values)
            comparisons.append({
                "variant": "target_after_reset",
                "original": original_after_reset,
                "native": native_after_reset,
                "match": original_after_reset == native_after_reset,
            })
            result["evaluation_comparisons"] = comparisons
            result["evaluation_mismatch_count"] = sum(not item["match"] for item in comparisons)
            result["reset_status_mismatch"] = not (
                result["original_reset_all_zero"] and result["native_reset_all_zero"]
            )
    elif native_tree.value:
        lib.scene_conditions_destroy(native_tree)
        native_tree = c.c_void_p()
    if native_tree.value:
        lib.scene_conditions_destroy(native_tree)
    return result


def supported_for_evaluation(rows: Sequence[Sequence[int]]) -> tuple[bool, str | None]:
    unsupported = sorted({row[0] for row in rows if row[0] not in (0x12, 0x13) and row[0] not in CONDITION_LIMITS})
    if unsupported:
        return False, "unsupported_leaf_opcode:" + ",".join(str(value) for value in unsupported)
    for row in rows:
        if row[0] == 6 and row[2] not in (0, 1, 2, 3):
            return False, "unsupported_opcode_6_comparison"
        if row[0] == 9 and row[7] not in (1, 2, 3):
            return False, "unsupported_opcode_9_comparison"
        if row[0] in (1, 2, 3) and row[1] < 0:
            return False, "negative_state_index"
        if row[0] == 9 and row[4] < 0:
            return False, "negative_scene_visit_index"
    return True, None


def range_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(args):
    machine = OriginalMachine(args.exe)
    lib = native_library(args.native_library)
    parsed_file_count, actual_actions = parsed_nested_actions(args.scene_dir, args.scene_library)
    if not actual_actions:
        raise RuntimeError(f"no nested actions found under {args.scene_dir}")

    edge_cases, synthetic_truth_tables = synthetic_cases()
    actual_results = []
    synthetic_edge_results = []
    synthetic_truth_results = []
    actual_eval_cases = 0
    actual_excluded = collections.Counter()
    evaluated_leaf_counts = collections.Counter()

    for action in actual_actions:
        rows = action["rows"]
        can_evaluate, exclusion_reason = supported_for_evaluation(rows)
        if can_evaluate:
            actual_eval_cases += 1
            evaluated_leaf_counts.update(
                str(row[0]) for row in rows if row[0] not in (0x12, 0x13)
            )
        else:
            actual_excluded[exclusion_reason] += 1
        result = compare_case(
            machine, lib, rows, action["case_id"], can_evaluate,
            ("zero", "mixed", "target", "inverse") if can_evaluate else (),
            seed=0x424AA8 + len(actual_results),
        )
        if not can_evaluate:
            result["evaluation_excluded_reason"] = exclusion_reason
        actual_results.append(result)

    for case_index, case in enumerate(edge_cases):
        result = compare_case(
            machine, lib, case["rows"], case["case_id"], False, (),
            seed=0x424AA8 + 1000 + case_index,
        )
        result["kind"] = case["kind"]
        result["expected_original_accept"] = case["expected_original_accept"]
        if result["original_accepted"] != case["expected_original_accept"]:
            raise AssertionError(f"unexpected original constructor result for {case['case_id']}")
        synthetic_edge_results.append(result)

    synthetic_truth_comparisons = 0
    for case_index, case in enumerate(synthetic_truth_tables):
        rows = case["rows"]
        result = compare_case(
            machine, lib, rows, case["case_id"], False, (), seed=0x424AA8 + 2000 + case_index
        )
        if not result["original_accepted"] or not result["native_accepted"]:
            raise AssertionError(f"valid synthetic tree failed to build: {case['case_id']}")
        record_array = (SceneDependencyInfo * len(rows))(
            *(dependency_record(row) for row in rows)
        )
        tree = c.c_void_p()
        status = lib.scene_conditions_build(record_array, len(rows), c.byref(tree))
        if status != 0 or not tree.value:
            raise AssertionError(f"could not rebuild synthetic tree: {case['case_id']}")
        try:
            case_comparisons = 0
            mismatches = []
            for bits in itertools.product((0, 1), repeat=len(case["truth_indices"])):
                flags = [0] * (max(case["truth_indices"]) + 1)
                for index, bit in zip(case["truth_indices"], bits):
                    flags[index] = bit
                values = ConditionValues(rows, "zero", seed=0x6000 + case_index * 100 + case_comparisons)
                values.flags = flags
                original_value = machine.evaluate(ACTION_STORAGE + 0x36, values)
                native_value = native_evaluate(lib, tree, values)
                synthetic_truth_comparisons += 1
                case_comparisons += 1
                if original_value != native_value:
                    mismatches.append({
                        "bits": list(bits), "original": original_value,
                        "native": native_value,
                    })
            result["truth_table_rows"] = case_comparisons
            result["truth_table_mismatches"] = mismatches
            result["truth_table_mismatch_count"] = len(mismatches)
        finally:
            lib.scene_conditions_destroy(tree)
        synthetic_truth_results.append(result)

    actual_topology_mismatches = [
        item for item in actual_results
        if item.get("topology_mismatch") or item.get("constructor_outcome_mismatch")
    ]
    actual_evaluation_mismatches = [
        {"case_id": item["case_id"], "comparisons": item.get("evaluation_comparisons", [])}
        for item in actual_results if item.get("evaluation_mismatch_count", 0)
    ]
    actual_reset_mismatches = [
        item["case_id"] for item in actual_results if item.get("reset_status_mismatch")
    ]
    synthetic_marker_mismatches = [
        item for item in synthetic_edge_results
        if item["original_accepted"] != item["native_accepted"]
    ]
    synthetic_edge_topology_mismatches = [
        item for item in synthetic_edge_results
        if item.get("topology_mismatch") or item.get("constructor_outcome_mismatch")
    ]
    synthetic_truth_mismatches = [
        {"case_id": item["case_id"], "mismatches": item.get("truth_table_mismatches", [])}
        for item in synthetic_truth_results if item.get("truth_table_mismatch_count", 0)
    ]
    synthetic_truth_topology_mismatches = [
        {
            "case_id": item["case_id"],
            "topology_mismatch": item.get("topology_mismatch", False),
            "constructor_outcome_mismatch": item.get("constructor_outcome_mismatch", False),
        }
        for item in synthetic_truth_results
        if item.get("topology_mismatch") or item.get("constructor_outcome_mismatch")
    ]
    actual_leaf_marker_storage_differences = [
        {"case_id": item["case_id"], "differences": item["leaf_marker_storage_differences"]}
        for item in actual_results if item.get("leaf_marker_storage_differences")
    ]
    synthetic_leaf_marker_storage_differences = [
        {"case_id": item["case_id"], "differences": item["leaf_marker_storage_differences"]}
        for item in (*synthetic_edge_results, *synthetic_truth_results)
        if item.get("leaf_marker_storage_differences")
    ]
    leaf_marker_semantics_mismatches = [
        {"case_id": item["case_id"],
         "mismatch_count": item.get("effective_leaf_marker_mismatch_count", 0)}
        for item in (*actual_results, *synthetic_edge_results, *synthetic_truth_results)
        if item.get("effective_leaf_marker_mismatch_count", 0)
    ]
    native_leaf_source_marker_mismatches = [
        {"case_id": item["case_id"],
         "mismatch_count": item.get("native_leaf_source_marker_mismatch_count", 0)}
        for item in (*actual_results, *synthetic_edge_results, *synthetic_truth_results)
        if item.get("native_leaf_source_marker_mismatch_count", 0)
    ]

    code_ranges = original_code_ranges(machine.pe)
    report = {
        "scope": "original x86 nested dependency loader, supported-leaf evaluator, branch reducer, and reset comparison",
        "original_executable_sha256": machine.executable_sha256,
        "native_conditions_library_sha256": range_sha256(args.native_library),
        "scene_resource_library_sha256": range_sha256(args.scene_library),
        "original_code_ranges": code_ranges,
        "oracle_setup": {
            "execution": "Unicorn maps the identified PE image; it does not launch GAME.EXE or call Windows APIs",
            "unmodified_original_paths": [
                "0x424aa8 dependency tree construction",
                "0x423f57 evaluation wrapper",
                "0x424201 recursive tree evaluation",
                "0x42406d sibling OR reduction",
                "0x424346 supported leaf evaluation",
                "0x423d33 reset entry and 0x423da2 reset traversal",
                "0x4237f7 leaf-node initializer and 0x4236d6 branch initializer",
            ],
            "intercepts": [
                {"va": "0x51dc43", "purpose": "bounded zero-filled bump allocator for original 0x4c-byte and 0x1c-byte nodes; arena 0x20010000..0x20200000, cursor reset for each constructor call"},
                {"va": "0x425b8b", "purpose": "skip side-effect-free debug tree printer"},
                {"va": "0x425b40", "purpose": "stop only at the original malformed-tree error label before diagnostic/termination calls"},
            ],
            "not_stubbed": ["gate evaluator", "branch reducer", "leaf evaluator", "constructor links", "reset traversal"],
            "excluded_evaluation_paths": [
                "nested actual actions with leaf opcodes outside 0, 1, 2, 3, 4, 5, 6, 9 are topology-tested but not evaluated",
                "game loop, Windows APIs, action execution, and unrelated engine dependencies",
            ],
        },
        "original_loader_preflight": {
            "rule": "a close opcode 0x13 at opener index +1 or +2 reaches the original malformed-tree path; marker pairs are compared after each marker is normalized by == 1",
            "synthetic_outcomes": synthetic_edge_results,
        },
        "actual_scene_records": {
            "scene_files_parsed": parsed_file_count,
            "nested_actions_found": len(actual_actions),
            "topology_cases_compared": len(actual_results),
            "original_constructor_rejections": sum(
                not item["original_accepted"] for item in actual_results
            ),
            "native_constructor_rejections": sum(
                not item["native_accepted"] for item in actual_results
            ),
            "constructor_outcome_mismatches": sum(
                item.get("constructor_outcome_mismatch", False) for item in actual_results
            ),
            "normalized_marker_pair_mismatches": sum(
                item["marker_mismatch_count"] for item in actual_results
            ),
            "supported_evaluation_actions": actual_eval_cases,
            "evaluation_exclusions": dict(actual_excluded),
            "supported_leaf_occurrences": dict(evaluated_leaf_counts),
            "state_variants_per_supported_action": 4,
            "evaluation_comparisons": sum(
                len(item.get("evaluation_comparisons", [])) for item in actual_results
            ),
            "topology_mismatches": actual_topology_mismatches,
            "evaluation_mismatches": actual_evaluation_mismatches,
            "reset_mismatches": actual_reset_mismatches,
        },
        "leaf_marker_storage_differential": {
            "description": "Original tree node slot stores (source marker == 1); native node.or_after stores the same effective boolean while native fields[3] retains the raw source marker. This private-layout difference is reported separately from effective topology.",
            "actual_scene_cases_with_storage_difference": actual_leaf_marker_storage_differences,
            "synthetic_cases_with_storage_difference": synthetic_leaf_marker_storage_differences,
            "effective_marker_mismatches": leaf_marker_semantics_mismatches,
            "native_raw_source_marker_mismatches": native_leaf_source_marker_mismatches,
            "private_object_byte_or_layout_parity_claimed": False,
        },
        "synthetic_truth_tables": {
            "cases": [
                {key: value for key, value in item.items()
                 if key not in ("evaluation_comparisons",)}
                for item in synthetic_truth_results
            ],
            "compared_assignments": synthetic_truth_comparisons,
            "mismatches": synthetic_truth_mismatches,
            "topology_mismatches": synthetic_truth_topology_mismatches,
        },
        "synthetic_edge_topology_mismatches": synthetic_edge_topology_mismatches,
        "construction_metrics": {
            "original_allocator_intercepts": machine.allocator_calls,
            "debug_tree_printer_intercepts": machine.debug_printer_calls,
            "malformed_tree_error_stops": machine.bad_tree_stops,
        },
        "result_digest": hashlib.sha256(json.dumps({
            "actual": actual_results,
            "edges": synthetic_edge_results,
            "truth": synthetic_truth_results,
        }, sort_keys=True, separators=(",", ":")).encode()).hexdigest(),
    }
    report["status"] = "pass" if not (
        actual_topology_mismatches or actual_evaluation_mismatches or
        actual_reset_mismatches or synthetic_marker_mismatches or
        synthetic_edge_topology_mismatches or synthetic_truth_topology_mismatches or
        synthetic_truth_mismatches or leaf_marker_semantics_mismatches or
        native_leaf_source_marker_mismatches
    ) else "mismatch"
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    markdown = [
        "# Nested dependency original oracle",
        "",
        f"Status: **{report['status']}**",
        "",
        f"GAME.EXE SHA-256: `{report['original_executable_sha256']}`",
        f"Native library SHA-256: `{report['native_conditions_library_sha256']}`",
        "",
        f"The original loader accepted and built all {len(actual_results)} parsed nested actions. "
        f"Native and original normalized topology matched for {len(actual_results) - len(actual_topology_mismatches)}. "
        f"Of those, {actual_eval_cases} used only supported leaves and were evaluated across "
        f"{report['actual_scene_records']['evaluation_comparisons']} state comparisons, including "
        "re-evaluation without reset and evaluation after both reset paths.",
        "",
        f"Synthetic marker and arity outcomes: {len(synthetic_edge_results)} cases; "
        f"constructor acceptance mismatches: {len(synthetic_marker_mismatches)}. "
        f"Nested truth tables: {synthetic_truth_comparisons} assignments; "
        f"mismatches: {len(synthetic_truth_mismatches)}.",
        f"Synthetic constructor/truth-table topology mismatches: "
        f"{len(synthetic_edge_topology_mismatches) + len(synthetic_truth_topology_mismatches)}.",
        f"Leaf marker storage differences are recorded separately: "
        f"{sum(len(item['differences']) for item in actual_leaf_marker_storage_differences)} "
        f"actual and {sum(len(item['differences']) for item in synthetic_leaf_marker_storage_differences)} "
        "synthetic. The original stores `marker == 1` in its tree slot; native `fields[3]` "
        "retains the raw source marker while native `or_after` stores the effective boolean. "
        "The oracle makes no private object byte/layout parity claim.",
        "",
        "Original code windows and byte hashes:",
        "",
        "| Window | VA range (end exclusive) | Bytes | SHA-256 |",
        "| --- | --- | ---: | --- |",
        *[
            f"| {item['name']} | `{item['start_va']}..{item['end_va_exclusive']}` | "
            f"{item['byte_count']} | `{item['sha256']}` |"
            for item in code_ranges
        ],
        "",
        "The original code executed in Unicorn includes loader `0x424aa8`, branch reducer `0x42406d`, "
        "leaf/tree evaluation `0x423f57`/`0x424201`/`0x424346`, and reset `0x423d33`/`0x423da2`. "
        "Only allocator `0x51dc43` and debug printer `0x425b8b` are skipped on accepted inputs. "
        "The malformed-tree hook stops at `0x425b40` only for constructor rejection cases.",
        "",
        "One-leaf groups are explicitly included: the original loader rejects a close at opener offset +2, "
        "while an outer branch with one nested branch child is accepted when its enclosed source-record "
        "sequence extends beyond that preflight window.",
        "",
        "Detailed hashes, counts, exclusions, and mismatch records are in `conditions-nested-validation.json`.",
    ]
    args.markdown_report.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_report.write_text("\n".join(markdown) + "\n")
    print(json.dumps({
        "status": report["status"],
        "original_executable_sha256": report["original_executable_sha256"],
        "native_conditions_library_sha256": report["native_conditions_library_sha256"],
        "parsed_nested_actions": len(actual_results),
        "supported_evaluation_actions": actual_eval_cases,
        "evaluation_comparisons": report["actual_scene_records"]["evaluation_comparisons"],
        "evaluation_mismatches": len(actual_evaluation_mismatches),
        "topology_mismatches": len(actual_topology_mismatches),
        "synthetic_constructor_edges": len(synthetic_edge_results),
        "synthetic_constructor_mismatches": len(synthetic_marker_mismatches),
        "synthetic_topology_mismatches": (
            len(synthetic_edge_topology_mismatches) + len(synthetic_truth_topology_mismatches)
        ),
        "synthetic_truth_assignments": synthetic_truth_comparisons,
        "synthetic_truth_mismatches": len(synthetic_truth_mismatches),
        "report": str(args.report),
    }, sort_keys=True))
    return report["status"] == "pass"


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--scene-dir", type=Path, default=DEFAULT_SCENE_DIR)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE_LIBRARY)
    parser.add_argument("--scene-library", type=Path, default=DEFAULT_SCENE_LIBRARY)
    parser.add_argument("--report", type=Path, default=DEFAULT_JSON_REPORT)
    parser.add_argument("--markdown-report", type=Path, default=DEFAULT_MARKDOWN_REPORT)
    args = parser.parse_args(argv)
    return 0 if run(args) else 1


if __name__ == "__main__":
    raise SystemExit(main())
