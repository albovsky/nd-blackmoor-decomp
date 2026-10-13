#!/usr/bin/env python3
"""Compare observed extra dependency leaves with original x86 0x424346.

The original leaf evaluator and the complete sound helper 0x4f6334 execute as
GAME.EXE machine code. Only its MSVC rand call and the DirectSound buffer
GetStatus vtable boundary are controlled. The fixture does not start the game,
stub the leaf handler, or skip its condition/flag/cache writes.
"""
from __future__ import annotations

import argparse
import collections
import ctypes as c
import hashlib
import json
from pathlib import Path
import struct
import sys

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up

import test_condition_extra as native_test
import conditions_nested_original_oracle as nested_oracle


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_NATIVE_LIBRARY = ROOT / "outputs/blackmoor-decomp/build/libconditionextra.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/slices/S06-2-condition-extra-original-oracle.json"
DEFAULT_FIXTURE_MANIFEST = ROOT / "work/analysis/slices/S06-2-nested-fixture-manifest-20261013.json"

LEAF_EVALUATOR = 0x424346
LEAF_END = 0x424AA8
SOUND_HELPER = 0x4F6334
SOUND_HELPER_END = 0x4F646C
RAND_ENTRY = 0x50CD50
GET_STATUS_STUB = 0x30000100
RETURN_SENTINEL = 0x30000000
STACK_TOP = 0x10008000
ENGINE_THIS = 0x20001000
NODE = 0x20010000
TREE_CONTEXT = 0x20020000
ACTION_ROOT = 0x20021000
CHANNELS = 0x20030000
SOUND_OBJECT = 0x2003F000
SOUND_VTABLE = 0x30000040
SOUND_MANAGER = 0x005CF1EB
CHANNEL_STRIDE = 0x5BB
TIME_RECORDS = 0x00585D65
TIME_RECORD_SIZE = 0x106
MAX_TIME_RECORDS = 10


class OriginalMachine:
    def __init__(self, executable: Path):
        from unicorn import Uc, UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32
        from unicorn.x86_const import (
            UC_X86_REG_EAX, UC_X86_REG_EBP, UC_X86_REG_ECX,
            UC_X86_REG_EFLAGS, UC_X86_REG_EIP, UC_X86_REG_ESP,
        )

        self.regs = {
            "eax": UC_X86_REG_EAX,
            "ebp": UC_X86_REG_EBP,
            "ecx": UC_X86_REG_ECX,
            "eflags": UC_X86_REG_EFLAGS,
            "eip": UC_X86_REG_EIP,
            "esp": UC_X86_REG_ESP,
        }
        self.pe = PEImage.parse_and_map(executable)
        digest = hashlib.sha256(self.pe.data).hexdigest()
        if digest != EXPECTED_EXE_SHA256:
            raise ValueError(f"unexpected original executable digest: {digest}")
        self.exe_sha256 = digest
        self.machine = Uc(UC_ARCH_X86, UC_MODE_32)
        self.machine.mem_map(self.pe.image_base, align_up(self.pe.size_of_image))
        self.machine.mem_write(self.pe.image_base, self.pe.image)
        self.machine.mem_map(0x10000000, 0x10000)
        self.machine.mem_map(0x20000000, 0x40000)
        self.machine.mem_map(0x30000000, 0x1000)
        self.rand_values: list[int] = []
        self.rand_calls = 0
        self.com_status_values: list[tuple[int, int]] = []

        def code_hook(uc, address, _size, _user_data):
            if address == RAND_ENTRY:
                if not self.rand_values:
                    raise RuntimeError("original rand hook exhausted its fixture")
                raw_value = self.rand_values.pop(0)
                self.rand_calls += 1
                esp = uc.reg_read(self.regs["esp"])
                return_address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
                uc.reg_write(self.regs["eax"], raw_value)
                uc.reg_write(self.regs["eip"], return_address)
                uc.reg_write(self.regs["esp"], esp + 4)
                return

            if address == GET_STATUS_STUB:
                esp = uc.reg_read(self.regs["esp"])
                return_address, _this_pointer, status_pointer = struct.unpack(
                    "<III", uc.mem_read(esp, 12)
                )
                if not self.com_status_values:
                    raise RuntimeError("DirectSound GetStatus hook exhausted fixture")
                hresult, status_word = self.com_status_values.pop(0)
                uc.mem_write(status_pointer, struct.pack("<I", status_word))
                uc.reg_write(self.regs["eax"], hresult)
                uc.reg_write(self.regs["eip"], return_address)
                uc.reg_write(self.regs["esp"], esp + 12)  # ret 8

        self.machine.hook_add(UC_HOOK_CODE, code_hook)

    def invoke(self, row, *, mode=0, selected=-1, outside=0, context=0,
               prior_global=0, timer_status=0, elapsed=0, threshold=0,
               debug=0, owner_value=0, random_values=(), sound_ready=1,
               sound_channel_active=1, sound_buffer_present=1,
               sound_uses_status_query=False, sound_paused=0,
               sound_stopped=0, com_values=(), random_cache_valid=0,
               cached_random_sample=0):
        from unicorn.x86_const import UC_X86_REG_EFLAGS

        self.rand_values = list(random_values)
        self.rand_calls = 0
        self.com_status_values = list(com_values)
        node = bytearray(0x60)
        struct.pack_into("<i", node, 4, -37)
        struct.pack_into("<hhh", node, 0x10, int(row[0]), int(row[1]), int(row[2]))
        struct.pack_into("<4h", node, 0x18, *[int(value) for value in row[4:8]])
        struct.pack_into("<i", node, 0x20, int(threshold))
        struct.pack_into("<I", node, 0x2C, random_cache_valid)
        struct.pack_into("<i", node, 0x30, cached_random_sample)
        struct.pack_into("<I", node, 0x48, TREE_CONTEXT)
        self.machine.mem_write(NODE, bytes(node))
        self.machine.mem_write(TREE_CONTEXT + 0x14, struct.pack("<I", ACTION_ROOT))
        self.machine.mem_write(ACTION_ROOT + 0x24, struct.pack("<I", owner_value))
        self.machine.mem_write(ENGINE_THIS + 0x614, struct.pack("<I", mode & 0xFFFFFFFF))
        self.machine.mem_write(0x00583A29, struct.pack("<h", selected))
        self.machine.mem_write(0x005BB20A, struct.pack("<h", outside))
        self.machine.mem_write(0x0058C94F, struct.pack("<h", context))
        self.machine.mem_write(0x005C3A47, struct.pack("<I", prior_global & 0xFFFFFFFF))
        self.machine.mem_write(0x0063A4CD, struct.pack("<h", debug))

        timer_area = bytearray(TIME_RECORD_SIZE * MAX_TIME_RECORDS)
        if int(row[0]) in (13, 14):
            if row[1] < 0 or row[1] >= MAX_TIME_RECORDS:
                raise ValueError("oracle fixture timer index must be in range")
            struct.pack_into("<iI", timer_area, int(row[1]) * TIME_RECORD_SIZE,
                             timer_status, elapsed & 0xFFFFFFFF)
        self.machine.mem_write(TIME_RECORDS, bytes(timer_area))

        channel = int(row[1]) if int(row[0]) == 17 else 0
        channel_address = CHANNELS + channel * CHANNEL_STRIDE
        self.machine.mem_write(SOUND_MANAGER + 0x1A0,
                               struct.pack("<I", sound_ready & 0xFFFFFFFF))
        self.machine.mem_write(SOUND_MANAGER + 0x3BE, struct.pack("<I", 0x7777))
        self.machine.mem_write(SOUND_MANAGER + 0x3C2, struct.pack("<I", 0x8888))
        self.machine.mem_write(SOUND_MANAGER + 0x3CA, struct.pack("<I", 0x9999))
        self.machine.mem_write(SOUND_MANAGER + 0x3CE,
                               struct.pack("<I", CHANNELS))
        channel_record = bytearray(CHANNEL_STRIDE)
        struct.pack_into("<I", channel_record, 0x162,
                         sound_channel_active & 0xFFFFFFFF)
        struct.pack_into("<I", channel_record, 0x19E,
                         0 if sound_uses_status_query else 1)
        struct.pack_into("<I", channel_record, 0x16E,
                         sound_stopped & 0xFFFFFFFF)
        struct.pack_into("<I", channel_record, 0x172,
                         sound_paused & 0xFFFFFFFF)
        struct.pack_into("<I", channel_record, 0x28F,
                         SOUND_OBJECT if sound_buffer_present else 0)
        self.machine.mem_write(channel_address, bytes(channel_record))
        vtable = bytearray(0x40)
        struct.pack_into("<I", vtable, 0x24, GET_STATUS_STUB)
        self.machine.mem_write(SOUND_VTABLE, bytes(vtable))
        self.machine.mem_write(SOUND_OBJECT, struct.pack("<I", SOUND_VTABLE))

        stack = STACK_TOP - 8
        self.machine.mem_write(stack,
                               struct.pack("<II", RETURN_SENTINEL, NODE))
        self.machine.reg_write(self.regs["esp"], stack)
        self.machine.reg_write(self.regs["ebp"], 0)
        self.machine.reg_write(self.regs["ecx"], ENGINE_THIS)
        self.machine.reg_write(UC_X86_REG_EFLAGS, 0x202)
        self.machine.emu_start(LEAF_EVALUATOR, RETURN_SENTINEL,
                               timeout=5_000_000, count=1_000_000)
        eip = self.machine.reg_read(self.regs["eip"])
        esp = self.machine.reg_read(self.regs["esp"])
        if eip != RETURN_SENTINEL or esp != stack + 8:
            raise AssertionError(
                f"original leaf did not return: EIP=0x{eip:x}, ESP=0x{esp:x}"
            )
        status = struct.unpack("<i", self.machine.mem_read(NODE + 4, 4))[0]
        cache_valid = struct.unpack("<I", self.machine.mem_read(NODE + 0x2C, 4))[0]
        cached_sample = struct.unpack("<i", self.machine.mem_read(NODE + 0x30, 4))[0]
        selected_leaf = struct.unpack("<I", self.machine.mem_read(ACTION_ROOT + 0x24, 4))[0]
        manager_error = struct.unpack(
            "<I", self.machine.mem_read(SOUND_MANAGER + 0x3BE, 4)
        )[0]
        manager_status = struct.unpack(
            "<I", self.machine.mem_read(SOUND_MANAGER + 0x3C2, 4)
        )[0]
        manager_hresult = struct.unpack(
            "<I", self.machine.mem_read(SOUND_MANAGER + 0x3CA, 4)
        )[0]
        return {
            "status": status,
            "cache_valid": cache_valid,
            "cached_sample": cached_sample,
            "selected_leaf": selected_leaf,
            "rand_calls": self.rand_calls,
            "manager_error": manager_error,
            "manager_status": manager_status,
            "manager_hresult": manager_hresult,
        }


def signed32(value: int) -> int:
    bits = value & 0xFFFFFFFF
    return bits if bits < 0x80000000 else bits - 0x100000000


def make_native_fixture():
    fixture = native_test.Fixture()
    return fixture


def compare_case(machine, lib, label, opcode, *, index=0, condition=0,
                 mode=0, selected=-1, outside=0, context=0, prior_global=0,
                 timer_status=0, elapsed=0, threshold=0, debug=0,
                 owner_value=0, random_values=(), sound_ready=1,
                 sound_channel_active=1, sound_buffer_present=1,
                 sound_uses_status_query=False, sound_paused=0,
                 sound_stopped=0, com_values=(), random_cache_valid=0,
                 cached_random_sample=0, source_row=None):
    row = (tuple(int(value) for value in source_row) if source_row is not None
           else (opcode, index, condition, 0, 0, 0, 5000, 0))
    opcode, index, condition = row[0], row[1], row[2]
    original = machine.invoke(
        row, mode=mode, selected=selected, outside=outside, context=context,
        prior_global=prior_global, timer_status=timer_status, elapsed=elapsed,
        threshold=threshold, debug=debug, owner_value=owner_value,
        random_values=random_values, sound_ready=sound_ready,
        sound_channel_active=sound_channel_active,
        sound_buffer_present=sound_buffer_present,
        sound_uses_status_query=sound_uses_status_query,
        sound_paused=sound_paused, sound_stopped=sound_stopped,
        random_cache_valid=random_cache_valid,
        cached_random_sample=cached_random_sample,
        com_values=com_values,
    )

    fixture = make_native_fixture()
    fixture.condition.selected_inventory_item = selected
    fixture.clock.outside_window_flag_5bb20a = outside
    fixture.session.context_58c94f = context
    fixture.session.evaluation_mode_614 = mode
    fixture.session.previous_global_5c3a47 = prior_global
    fixture.session.debug_enabled_63a4cd = debug
    fixture.owner.value = owner_value or None
    if opcode in (13, 14):
        fixture.put_timer(index, timer_status, elapsed)
    record = native_test.SceneDependencyInfo()
    record.opcode = opcode
    record.or_after = row[3]
    record.fields[:] = row
    runtime = native_test.ConditionExtraNodeRuntime()
    lib.condition_extra_node_initialize(c.byref(runtime))
    runtime.runtime_threshold_20 = threshold
    runtime.random_cache_valid_2c = random_cache_valid
    runtime.random_sample_30 = cached_random_sample
    native_calls = []
    callback_keepalive = []

    if opcode == 17:
        expected_available = 0
        if sound_ready != 0 and sound_channel_active != 0 and sound_buffer_present != 0:
            if sound_uses_status_query:
                if com_values:
                    expected_available = int(com_values[0][1] & 1 != 0) if com_values[0][0] == 0 else 0
            else:
                expected_available = int(sound_paused == 0 and sound_stopped == 0)

        @native_test.SoundCallback
        def sound_query(_context, channel_value, available_out):
            native_calls.append(("sound", int(channel_value)))
            available_out[0] = expected_available
            return native_test.HOST_OK

        fixture.session.sound_query = sound_query
        callback_keepalive.append(sound_query)

    if opcode == 20:
        values = list(random_values)

        @native_test.RandomCallback
        def next_random(_context, value_out):
            native_calls.append(("rand",))
            value_out[0] = values.pop(0)
            return native_test.HOST_OK

        fixture.session.next_random = next_random
        callback_keepalive.append(next_random)

    native_status = c.c_int32(-37)
    native_result = native_test.ConditionExtraResult()
    native_code = lib.condition_extra_evaluate_leaf(
        c.byref(record), c.c_void_p(NODE), c.byref(runtime),
        c.byref(fixture.session), c.byref(native_status),
        c.byref(native_result),
    )
    native = {
        "status": native_status.value,
        "cache_valid": int(runtime.random_cache_valid_2c),
        "cached_sample": int(runtime.random_sample_30),
        "selected_leaf": int(fixture.owner.value or 0),
        "rand_calls": int(native_result.random_calls),
        "code": native_code,
    }
    mismatches = []
    for key in ("status", "cache_valid", "cached_sample", "selected_leaf", "rand_calls"):
        if original[key] != native[key]:
            mismatches.append({"field": key, "original": original[key], "native": native[key]})
    return {
        "label": label,
        "opcode": opcode,
        "original": original,
        "native": native,
        "mismatches": mismatches,
    }


def fixtures(machine, lib):
    cases = []
    # Opcode 11: selected-item hit, miss, conditional clear, unrelated owner,
    # and the nonzero evaluation mode that forces true and clears the slot.
    cases.extend([
        compare_case(machine, lib, "11-selected-hit", 11, index=7, selected=7),
        compare_case(machine, lib, "11-selected-miss-clears-self", 11,
                     index=7, selected=2, owner_value=NODE),
        compare_case(machine, lib, "11-selected-miss-preserves-other", 11,
                     index=7, selected=2, owner_value=0x20022000),
        compare_case(machine, lib, "11-mode-one-forces-and-clears", 11,
                     index=7, selected=2, mode=1, owner_value=NODE),
    ])

    cases.extend([
        compare_case(machine, lib, "12-outside-flag-equal", 12, index=-2, outside=-2),
        compare_case(machine, lib, "12-outside-flag-mismatch", 12, index=1, outside=0),
    ])

    for opcode in (13, 14):
        for record_status in (1, 5, 6, 2):
            for elapsed in (-1, 0, 1):
                for threshold in (0, 1):
                    cases.append(compare_case(
                        machine, lib,
                        f"{opcode}-status{record_status}-elapsed{elapsed}-threshold{threshold}",
                        opcode, index=1, condition=1, timer_status=record_status,
                        elapsed=elapsed, threshold=threshold,
                    ))

    cases.extend([
        compare_case(machine, lib, "15-context-equal", 15, index=9, condition=-3, context=-3),
        compare_case(machine, lib, "15-context-mismatch", 15, index=9, condition=3, context=-3),
    ])

    # The original helper 0x4f6334 runs in full. The controls below change its
    # actual manager/channel fields; only the DirectSound GetStatus vtable call
    # is intercepted where required.
    cases.extend([
        compare_case(machine, lib, "17-manager-unready", 17, index=2, condition=1,
                     sound_ready=0),
        compare_case(machine, lib, "17-channel-missing", 17, index=2, condition=0,
                     sound_channel_active=0),
        compare_case(machine, lib, "17-no-status-query-playing", 17, index=2,
                     condition=1),
        compare_case(machine, lib, "17-no-status-query-paused", 17, index=2,
                     condition=0, sound_paused=1),
        compare_case(machine, lib, "17-no-status-query-stopped", 17, index=2,
                     condition=0, sound_stopped=1),
        compare_case(machine, lib, "17-getstatus-playing", 17, index=2,
                     condition=1, sound_uses_status_query=True,
                     com_values=((0, 1),)),
        compare_case(machine, lib, "17-getstatus-not-playing", 17, index=2,
                     condition=0, sound_uses_status_query=True,
                     com_values=((0, 0),)),
        compare_case(machine, lib, "17-getstatus-failed", 17, index=2,
                     condition=0, sound_uses_status_query=True,
                     com_values=((1, 1),)),
        compare_case(machine, lib, "17-nonboolean-condition", 17, index=2,
                     condition=2),
    ])

    for rand_value, condition in ((0, 0), (0, 1), (99, 100),
                                  (100, 1), (32767, 100), (12345, 101)):
        cases.append(compare_case(machine, lib,
                                  f"20-rand{rand_value}-condition{condition}",
                                  20, condition=condition,
                                  random_values=(rand_value,)))
    cases.append(compare_case(machine, lib, "20-retained-cache-no-rand", 20,
                              condition=50, random_values=(77,),
                              random_cache_valid=1, cached_random_sample=49))

    cases.extend([
        compare_case(machine, lib, "21-prior-zero", 21, prior_global=0),
        compare_case(machine, lib, "21-prior-nonzero", 21, prior_global=-5),
    ])
    return cases


def actual_nested_fixtures(machine, lib, scene_library: Path):
    """Exercise every currently excluded real nested action and its extra leaves.

    The original loader and evaluator execute complete nested actions. The
    portable kernel comparison is deliberately at each real extra leaf because
    this worker does not own scene_conditions tree-dispatch integration.
    """
    parsed_files, actions = nested_oracle.parsed_nested_actions(
        nested_oracle.DEFAULT_SCENE_DIR, scene_library
    )
    extra = {11, 12, 13, 14, 15, 17, 20, 21}
    excluded = [item for item in actions
                if not nested_oracle.supported_for_evaluation(item["rows"])[0]
                and any(row[0] in extra for row in item["rows"])]
    expected_ids = {"11", "13", "15", "17"}
    excluded_opcode_counts = collections.Counter(
        str(row[0]) for item in excluded for row in item["rows"]
        if row[0] in extra
    )
    actual_tree_results = []
    direct_cases = []
    constructor_zero_checks = 0

    for action in excluded:
        rows = action["rows"]
        machine_for_tree = nested_oracle.OriginalMachine(DEFAULT_EXE)
        accepted, root = machine_for_tree.load(rows)
        if not accepted:
            raise AssertionError(f"original rejected nested action {action['case_id']}")
        condition_values = nested_oracle.ConditionValues(
            rows, "zero", seed=20261013 + int(action["action_index"])
        )
        tree_result = machine_for_tree.evaluate(root, condition_values)
        original_children, _statuses = machine_for_tree.original_topology(root)
        leaf_addresses = original_leaf_addresses(machine_for_tree, root)
        for node_address in leaf_addresses:
            node_fields = struct.unpack(
                "<8h", machine_for_tree.machine.mem_read(node_address + 0x10, 16)
            )
            if node_fields[0] in (13, 14):
                threshold = machine_for_tree.i32(node_address + 0x20)
                if threshold != 0:
                    raise AssertionError(
                        f"original loaded timer leaf threshold is not constructor-zero: {threshold}"
                    )
                constructor_zero_checks += 1
        actual_tree_results.append({
            "case_id": action["case_id"],
            "resource": action["resource"],
            "action_index": action["action_index"],
            "root_status": tree_result,
            "original_tree_leaf_count": sum(
                1 for row in rows if row[0] not in (0x12, 0x13)
            ),
            "loader_accepted": accepted,
            "tree_children": len(original_children),
        })

        for leaf_index, row in enumerate(rows):
            if row[0] not in extra:
                continue
            state_variants = [None]
            kwargs = {}
            if row[0] in (13, 14):
                # The actual constructor leaves node+0x20 at zero, while the
                # source words stay intact in row[4..7]. Exercise elapsed
                # values on each side of that signed threshold and an inactive
                # status through the same actual raw row.
                state_variants = [
                    {"timer_status": 1, "elapsed": -1},
                    {"timer_status": 5, "elapsed": 0},
                    {"timer_status": 6, "elapsed": 1},
                    {"timer_status": 2, "elapsed": 1},
                ]
            elif row[0] == 11:
                state_variants = [
                    {"selected": int(row[1]), "mode": 0, "owner_value": 0},
                    {"selected": int(row[1]) + 1, "mode": 0, "owner_value": NODE},
                    {"selected": int(row[1]) + 1, "mode": 0,
                     "owner_value": 0x20022000},
                    {"selected": int(row[1]) + 1, "mode": 1,
                     "owner_value": NODE},
                ]
            elif row[0] == 15:
                state_variants = [
                    {"context": int(row[2])},
                    {"context": int(row[2]) + 1},
                ]
            elif row[0] == 17:
                state_variants = [
                    {"sound_paused": 0, "sound_stopped": 0},
                    {"sound_paused": 1, "sound_stopped": 0},
                ]
            else:
                state_variants = [{}]
            for variant_index, variant in enumerate(state_variants):
                kwargs = dict(variant or {})
                direct_cases.append(compare_case(
                    machine, lib,
                    f"nested:{action['case_id']}:leaf{leaf_index}:variant{variant_index}",
                    row[0], source_row=row, **kwargs
                ))

    expected_counts = {"11": 1, "13": 66, "15": 1, "17": 23}
    if (len(excluded) != 58 or dict(excluded_opcode_counts) != expected_counts
            or set(excluded_opcode_counts) != expected_ids):
        raise AssertionError(
            "nested corpus exclusion census changed: "
            f"actions={len(excluded)}, leaves={dict(excluded_opcode_counts)}"
        )
    return (parsed_files, excluded, excluded_opcode_counts, actual_tree_results,
            direct_cases, constructor_zero_checks)


def original_leaf_addresses(machine, root: int):
    """Return leaf-node addresses by walking the original loaded tree links."""
    result = []

    def walk_branch(branch_address: int):
        child_count = machine.u32(branch_address + 0x18)
        node_address = machine.u32(branch_address + 4)
        seen = 0
        while node_address:
            if seen >= 512:
                raise AssertionError("original nested tree exceeds the 512-node walk bound")
            kind = machine.u32(node_address)
            if kind == 1:
                child_branch = machine.u32(node_address + 0x44)
                if child_branch == 0:
                    raise AssertionError("original branch node has no child branch")
                walk_branch(child_branch)
            elif kind == 2:
                result.append(node_address)
            else:
                raise AssertionError(f"unexpected original node kind {kind}")
            node_address = machine.u32(node_address + 0x38)
            seen += 1
        if seen != child_count:
            raise AssertionError(
                f"original branch count {child_count} differs from linked count {seen}"
            )

    walk_branch(root)
    return result


def original_reset_probe(executable: Path, raw_rand_value: int = 12345):
    """Execute original constructor, random leaf, and reset through real x86."""
    from unicorn import UC_HOOK_CODE

    machine = nested_oracle.OriginalMachine(executable)
    random_calls = []

    def rand_hook(uc, address, _size, _user_data):
        if address != RAND_ENTRY:
            return
        esp = uc.reg_read(machine._reg_esp)
        return_address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
        uc.reg_write(machine._reg_eax, raw_rand_value)
        uc.reg_write(machine._reg_eip, return_address)
        uc.reg_write(machine._reg_esp, esp + 4)
        random_calls.append(raw_rand_value)

    machine.machine.hook_add(UC_HOOK_CODE, rand_hook)
    rows = [
        (0x12, 0, 0, 0, 0, 0, 0, 0),
        (20, 0, 50, 0, 0, 0, 0, 0),
        (0, 0, 0, 0, 0, 0, 0, 0),
        (0x13, 0, 0, 0, 0, 0, 0, 0),
    ]
    accepted, root = machine.load(rows)
    if not accepted:
        raise AssertionError("original rejected the random/reset probe tree")
    values = nested_oracle.ConditionValues(rows, "zero", seed=0x423DA2)
    tree_result = machine.evaluate(root, values)
    leaves = original_leaf_addresses(machine, root)
    random_nodes = [address for address in leaves if machine.u32(address + 0x10) == 20]
    if len(random_nodes) != 1:
        raise AssertionError(f"expected one original opcode-20 node, got {len(random_nodes)}")
    node = random_nodes[0]
    before = {
        "threshold_20": machine.i32(node + 0x20),
        "cache_valid_2c": machine.u32(node + 0x2C),
        "sample_30": machine.i32(node + 0x30),
        "status": machine.i32(node + 4),
    }
    machine.reset(root)
    after = {
        "threshold_20": machine.i32(node + 0x20),
        "cache_valid_2c": machine.u32(node + 0x2C),
        "sample_30": machine.i32(node + 0x30),
        "status": machine.i32(node + 4),
    }
    expected_sample = raw_rand_value % 100
    if (random_calls != [raw_rand_value] or before != {
            "threshold_20": 0, "cache_valid_2c": 1,
            "sample_30": expected_sample, "status": 1} or after != {
            "threshold_20": 0, "cache_valid_2c": 0,
            "sample_30": expected_sample, "status": 0}):
        raise AssertionError(
            f"original constructor/eval/reset probe mismatch: before={before}, after={after}, calls={random_calls}"
        )
    return {
        "tree_result": tree_result,
        "raw_rand_value": raw_rand_value,
        "random_calls": len(random_calls),
        "sample_30_before_and_after": expected_sample,
        "before_reset": before,
        "after_reset": after,
        "whole_tree_original_execution": True,
    }


def audit_parser_corpus(scene_dir: Path, scene_library: Path,
                        original_sha256: str, fixture_manifest_path: Path):
    """Check the rebuilt parser against unchanged raw inputs and record bounds.

    The manifest stores action identities and opcode/record positions only; it
    never copies the proprietary resource records into evidence.
    """
    input_manifest_path = ROOT / "work/analysis/hiff-resources.json"
    input_manifest = json.loads(input_manifest_path.read_text())
    expected_inputs = {
        Path(entry["path"]).name: (int(entry["size"]), str(entry["sha256"]))
        for entry in input_manifest["resources"]
    }
    paths = sorted(scene_dir.glob("*.bin"))
    if {path.name for path in paths} != set(expected_inputs):
        raise AssertionError("scene input filenames no longer match the pinned manifest")

    current_inputs = []
    input_mismatches = []
    for path in paths:
        data = path.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        size = len(data)
        current_inputs.append({"name": path.name, "size": size, "sha256": digest})
        if expected_inputs[path.name] != (size, digest):
            input_mismatches.append(path.name)
    if input_mismatches:
        raise AssertionError(f"scene inputs changed from pinned manifest: {input_mismatches[:5]}")

    lib = nested_oracle.open_scene_library(scene_library)
    parsed_scenes = 0
    rejected_scenes = 0
    action_count = 0
    typed_actions = 0
    opaque_actions = 0
    dependency_count = 0
    nested_action_count = 0
    dependency_stream = hashlib.sha256()
    opcode_counts = collections.Counter()
    nested_actions = []
    invalid_boundaries = []

    for path in paths:
        data = path.read_bytes()
        storage = (c.c_uint8 * len(data)).from_buffer_copy(data)
        error = c.create_string_buffer(256)
        scene = lib.scene_resource_open_memory(storage, len(data), error, len(error))
        if not scene:
            rejected_scenes += 1
            continue
        parsed_scenes += 1
        try:
            scene_action_count = int(lib.scene_resource_action_count(scene))
            action_count += scene_action_count
            for action_index in range(scene_action_count):
                info = nested_oracle.SceneActionInfo()
                if lib.scene_resource_action_at(scene, action_index, c.byref(info)) != 0:
                    raise AssertionError(f"parser action lookup failed: {path.name}:{action_index}")
                if int(info.payload_kind) == 0:
                    opaque_actions += 1
                else:
                    typed_actions += 1

                raw_len = int(info.raw_body_length)
                typed_len = int(info.typed_body_length)
                count = int(info.dependency_count)
                is_opaque = int(info.payload_kind) == 0
                if ((is_opaque and (typed_len != 0 or count != 0)) or
                        (not is_opaque and
                         (typed_len > raw_len or raw_len - typed_len != count * 16))):
                    invalid_boundaries.append({
                        "resource": path.name, "action_index": action_index,
                        "raw_body_length": raw_len, "typed_body_length": typed_len,
                        "dependency_count": count,
                    })
                    continue
                raw_base = c.cast(info.raw_body, c.c_void_p).value or 0
                dependency_base = c.cast(info.dependency_records, c.c_void_p).value or 0
                if count and dependency_base != raw_base + typed_len:
                    invalid_boundaries.append({
                        "resource": path.name, "action_index": action_index,
                        "reason": "dependency pointer is not typed-body end",
                    })
                    continue

                rows = []
                per_action_opcode_counts = collections.Counter()
                per_action_extra_rows = []
                for dep_index in range(count):
                    record = nested_oracle.SceneDependencyInfo()
                    if lib.scene_resource_dependency_at(
                            scene, action_index, dep_index, c.byref(record)) != 0:
                        raise AssertionError(
                            f"parser dependency lookup failed: {path.name}:{action_index}:{dep_index}"
                        )
                    expected_ptr = dependency_base + dep_index * 16
                    actual_ptr = c.cast(record.raw_bytes, c.c_void_p).value or 0
                    raw_record = c.string_at(record.raw_bytes, 16)
                    expected_fields = struct.unpack("<8h", raw_record)
                    if (actual_ptr != expected_ptr or tuple(record.fields) != expected_fields
                            or int(record.opcode) != (expected_fields[0] & 0xFFFF)):
                        invalid_boundaries.append({
                            "resource": path.name, "action_index": action_index,
                            "dependency_index": dep_index,
                            "reason": "typed dependency bytes/fields disagree",
                        })
                        break
                    dependency_stream.update(raw_record)
                    opcode = int(record.opcode)
                    rows.append(tuple(int(value) for value in record.fields))
                    opcode_counts[str(opcode)] += 1
                    per_action_opcode_counts[str(opcode)] += 1
                    if opcode in (11, 12, 13, 14, 15, 17, 20, 21):
                        per_action_extra_rows.append({
                            "record_index": dep_index, "opcode": opcode,
                        })
                    dependency_count += 1

                if any(row[0] == 0x12 for row in rows):
                    nested_action_count += 1
                    description = bytes(info.description).decode(
                        "utf-8", "replace"
                    ).rstrip("\0")
                    if not nested_oracle.supported_for_evaluation(rows)[0] and per_action_extra_rows:
                        nested_actions.append({
                            "resource": path.name,
                            "action_index": action_index,
                            "description": description,
                            "case_id": f"{path.name}:action-{action_index}:{description}",
                            "unsupported_leaf_opcodes": sorted({
                                int(row[0]) for row in rows
                                if row[0] not in nested_oracle.CONDITION_LIMITS
                                and row[0] not in (0x12, 0x13)
                            }),
                            "extra_leaf_rows": per_action_extra_rows,
                            "extra_leaf_counts": dict(sorted(
                                ((key, value) for key, value in per_action_opcode_counts.items()
                                if int(key) in (11, 12, 13, 14, 15, 17, 20, 21)),
                                key=lambda item: int(item[0])
                            )),
                        })
        finally:
            lib.scene_resource_close(scene)

    nested_actions.sort(key=lambda item: (item["resource"], item["action_index"]))
    input_manifest_digest = hashlib.sha256(json.dumps(
        current_inputs, sort_keys=True, separators=(",", ":")
    ).encode("utf-8")).hexdigest()
    current_source_commit = __import__("subprocess").check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    parser_source_hashes = {
        name: hashlib.sha256((ROOT / "outputs/blackmoor-decomp/src" / name).read_bytes()).hexdigest()
        for name in ("hiff.c", "hiff.h", "scene_resource.c", "scene_resource.h")
    }
    extra_counts = collections.Counter()
    for action in nested_actions:
        extra_counts.update({
            key: value for key, value in action["extra_leaf_counts"].items()
            if int(key) in (11, 12, 13, 14, 15, 17, 20, 21)
        })

    historical_report_path = ROOT / "outputs/blackmoor-decomp/conditions-nested-validation.json"
    historical_report = json.loads(historical_report_path.read_text())
    historical_source = historical_report.get("scene_resource_library_sha256")
    current_library_sha = hashlib.sha256(scene_library.read_bytes()).hexdigest()
    if invalid_boundaries:
        raise AssertionError(f"parser dependency boundary validation failed: {invalid_boundaries[:5]}")
    if parsed_scenes != 2078 or rejected_scenes != 189 or action_count != 19612:
        raise AssertionError(
            f"parser corpus census changed: parsed={parsed_scenes}, rejected={rejected_scenes}, actions={action_count}"
        )
    if len(nested_actions) != 58 or dict(extra_counts) != {
            "11": 1, "13": 66, "15": 1, "17": 23}:
        raise AssertionError(
            f"nested unsupported census changed: actions={len(nested_actions)}, counts={dict(extra_counts)}"
        )

    manifest = {
        "scope": "private S06-2 parser-boundary and nested-action fixture manifest; no raw resource bytes stored",
        "original_sha256": original_sha256,
        "source_commit": current_source_commit,
        "input_manifest": {
            "path": "work/analysis/hiff-resources.json",
            "archive_sha256": input_manifest["archive_sha256"],
            "file_count": len(current_inputs),
            "unchanged_count": len(current_inputs),
            "mismatch_count": len(input_mismatches),
            "current_manifest_sha256": input_manifest_digest,
        },
        "parser": {
            "source_file_sha256": parser_source_hashes,
            "library_sha256": current_library_sha,
            "all_dependency_boundaries_valid": True,
            "typed_body_end_equals_dependency_start": True,
            "each_dependency_is_16_bytes_with_matching_eight_i16_fields": True,
        },
        "corpus": {
            "parsed_scenes": parsed_scenes,
            "rejected_non_scene_inputs": rejected_scenes,
            "actions": action_count,
            "nested_actions": nested_action_count,
            "typed_actions": typed_actions,
            "opaque_actions": opaque_actions,
            "typed_dependency_records": dependency_count,
            "dependency_record_stream_sha256": dependency_stream.hexdigest(),
            "dependency_records_by_opcode": dict(sorted(
                opcode_counts.items(), key=lambda item: int(item[0])
            )),
        },
        "historical_report_reconciliation": {
            "report_path": "outputs/blackmoor-decomp/conditions-nested-validation.json",
            "report_sha256": hashlib.sha256(historical_report_path.read_bytes()).hexdigest(),
            "historical_scene_resource_library_sha256": historical_source,
            "current_scene_resource_library_sha256": current_library_sha,
            "historical_nested_actions": historical_report.get("actual_scene_records", {}).get("nested_actions_found"),
            "historical_supported_nested_actions": historical_report.get("actual_scene_records", {}).get("supported_evaluation_actions"),
            "historical_exclusions": historical_report.get("actual_scene_records", {}).get("evaluation_exclusions"),
            "note": "The checked-in historical report is retained unchanged. Its parser-library digest differs from this source-matched rebuild, so the current S06-2 manifest and oracle use this rebuild's 124 nested actions and 58 unsupported actions.",
        },
        "unsupported_nested_actions": nested_actions,
        "unsupported_nested_action_count": len(nested_actions),
        "unsupported_nested_extra_leaf_counts": dict(sorted(
            extra_counts.items(), key=lambda item: int(item[0])
        )),
    }
    fixture_manifest_path.parent.mkdir(parents=True, exist_ok=True)
    fixture_manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")
    return manifest


def code_window_hash(pe: PEImage, start: int, end: int) -> str:
    offset = pe.va_to_file_offset(start, end - start)
    return hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE_LIBRARY)
    parser.add_argument("--scene-library", type=Path,
                        default=ROOT / "outputs/blackmoor-decomp/build/libsceneresource.dylib")
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--fixture-manifest", type=Path,
                        default=DEFAULT_FIXTURE_MANIFEST)
    args = parser.parse_args()

    machine = OriginalMachine(args.exe)
    native_test.LIBRARY = args.native_library
    native_lib = native_test.open_library()
    fixture_manifest = audit_parser_corpus(
        nested_oracle.DEFAULT_SCENE_DIR, args.scene_library,
        machine.exe_sha256, args.fixture_manifest
    )
    cases = fixtures(machine, native_lib)
    (nested_parsed_files, nested_actions, nested_leaf_counts,
     nested_tree_results, nested_leaf_cases,
     constructor_zero_checks) = actual_nested_fixtures(
        machine, native_lib, args.scene_library
    )
    cases.extend(nested_leaf_cases)
    reset_probe = original_reset_probe(args.exe)
    mismatches = [case for case in cases if case["mismatches"]]
    by_opcode = collections.Counter(str(case["opcode"]) for case in cases)
    result_digest = hashlib.sha256()
    for case in cases:
        result_digest.update(struct.pack(
            "<HiiII",
            int(case["opcode"]),
            int(case["original"]["status"]),
            int(case["native"]["status"]),
            int(case["original"]["cache_valid"]),
            int(case["original"]["cached_sample"]),
        ))

    windows = [
        {"name": "leaf_node_constructor", "start_va": "0x004237f7",
         "end_va_exclusive": "0x00423876", "size": 0x423876 - 0x4237F7,
         "sha256": code_window_hash(machine.pe, 0x4237F7, 0x423876)},
        {"name": "reset_entry", "start_va": "0x00423d33",
         "end_va_exclusive": "0x00423da2", "size": 0x423DA2 - 0x423D33,
         "sha256": code_window_hash(machine.pe, 0x423D33, 0x423DA2)},
        {"name": "reset_traversal", "start_va": "0x00423da2",
         "end_va_exclusive": "0x00423f57", "size": 0x423F57 - 0x423DA2,
         "sha256": code_window_hash(machine.pe, 0x423DA2, 0x423F57)},
        {"name": "evaluation_wrapper", "start_va": "0x00423f57",
         "end_va_exclusive": "0x0042406d", "size": 0x42406D - 0x423F57,
         "sha256": code_window_hash(machine.pe, 0x423F57, 0x42406D)},
        {"name": "recursive_tree_evaluator", "start_va": "0x00424201",
         "end_va_exclusive": "0x00424346", "size": 0x424346 - 0x424201,
         "sha256": code_window_hash(machine.pe, 0x424201, 0x424346)},
        {"name": "leaf_evaluator", "start_va": "0x00424346",
         "end_va_exclusive": "0x00424aa8", "size": LEAF_END - LEAF_EVALUATOR,
         "sha256": code_window_hash(machine.pe, LEAF_EVALUATOR, LEAF_END)},
        {"name": "dependency_loader", "start_va": "0x00424aa8",
         "end_va_exclusive": "0x00425b8b", "size": 0x425B8B - 0x424AA8,
         "sha256": code_window_hash(machine.pe, 0x424AA8, 0x425B8B)},
        {"name": "sound_query_helper", "start_va": "0x004f6334",
         "end_va_exclusive": "0x004f646c", "size": SOUND_HELPER_END - SOUND_HELPER,
         "sha256": code_window_hash(machine.pe, SOUND_HELPER, SOUND_HELPER_END)},
    ]
    report = {
        "status": "pass" if not mismatches else "fail",
        "scope": "direct leaf parity plus separately reported original nested-tree executions; no native tree dispatcher claim",
        "original_sha256": machine.exe_sha256,
        "native_library_sha256": hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
        "fixture_manifest_sha256": hashlib.sha256(
            args.fixture_manifest.read_bytes()
        ).hexdigest(),
        "parser_source_commit": fixture_manifest["source_commit"],
        "parser_library_sha256": fixture_manifest["parser"]["library_sha256"],
        "parser_corpus": fixture_manifest["corpus"],
        "function_windows": windows,
        "compared_cases": len(cases),
        "comparison_scope": {
            "direct_original_vs_native_leaf_cases": len(cases),
            "actual_nested_leaf_cases_included_above": len(nested_leaf_cases),
            "original_nested_loader_and_tree_evaluator_executions": len(nested_actions),
            "native_whole_tree_comparison_cases": 0,
        },
        "by_opcode": dict(sorted(by_opcode.items(), key=lambda item: int(item[0]))),
        "actual_nested_scene_files_parsed": nested_parsed_files,
        "actual_nested_actions_loader_and_evaluator_executed": len(nested_actions),
        "actual_nested_constructor_zero_timer_threshold_checks": constructor_zero_checks,
        "actual_nested_leaf_rows_by_opcode": dict(sorted(
            nested_leaf_counts.items(), key=lambda item: int(item[0])
        )),
        "actual_nested_leaf_comparison_cases": len(nested_leaf_cases),
        "native_whole_tree_comparison_cases": 0,
        "original_constructor_evaluator_reset_probe": reset_probe,
        "actual_nested_tree_result_digest": hashlib.sha256(json.dumps(
            nested_tree_results, sort_keys=True, separators=(",", ":")
        ).encode("utf-8")).hexdigest(),
        "actual_nested_tree_sample_results": nested_tree_results[:5],
        "mismatch_count": len(mismatches),
        "mismatches": mismatches,
        "result_digest": result_digest.hexdigest(),
        "hooks": [
            {"va": "0x0050cd50", "boundary": "MSVC CRT rand result", "action": "return controlled raw value 0..32767"},
            {"va": "0x30000100", "boundary": "DirectSound buffer GetStatus vtable call", "action": "write controlled status and HRESULT; original 0x4f6334 remains live"},
        ],
        "nested_original_executor_hooks": [
            {"va": "0x51dc43", "boundary": "allocator", "action": "bounded zero-filled arena used by the existing nested oracle"},
            {"va": "0x425b8b", "boundary": "debug tree printer", "action": "skip diagnostic output only"},
            {"va": "0x425b40", "boundary": "malformed-tree diagnostic label", "action": "stop rejected constructor fixtures only; no accepted action reaches this hook"},
            {"va": "0x50cd50", "boundary": "MSVC CRT rand in reset probe", "action": "return controlled raw value 12345 while original loader/evaluator/reset execute"},
        ],
        "provenance": {
            "leaf_switch": "original machine-code jump table at 0x424a3c; complete leaf code window hash above",
            "opcode11_owner": "0x424411-0x42447c writes or conditionally clears action-root+0x24; 0x424035 reads label through that leaf pointer",
            "opcode13_14": "0x4246b2/0x424717 read record status/elapsed and node+0x20; constructor 0x4237f7 zeros the 0x4c node, loader 0x424aa8 preserves words 4..7 separately",
            "opcode17": "0x4244ab calls the original helper at 0x4f6334; only its DirectSound GetStatus virtual call is controlled",
            "opcode20": "0x424930 calls rand at 0x50cd50, stores raw%100 at node+0x30, compares it, then sets node+0x2c",
            "opcode21": "0x4249d5 reads 0x5c3a47; wrapper 0x423f57 writes it only after whole-tree evaluation",
        },
        "limits": [
            "The COM method and CRT rand result are controlled boundaries; this is not a DirectSound or CRT implementation equivalence claim.",
            "Direct leaves are evaluated; the actual scene executor and native tree callback integration are outside this slice.",
            "The standard loader path initializes node+0x20 to zero. A later writer outside the traced load/evaluate/reset paths remains an open cross-program question.",
        ],
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({key: value for key, value in report.items()
                      if key not in ("mismatches", "function_windows", "provenance", "limits")}))
    if mismatches:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
