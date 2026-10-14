#!/usr/bin/env python3
"""RT-4: whole-tree comparison of the native dependency tree (scene_conditions
+ condition_extra + session-conditions binding) with GAME.EXE's x86 code.

Original side: the PE image is mapped in Unicorn and the unmodified loader
0x424aa8, evaluation wrapper 0x423f57, recursive evaluator 0x424201, leaf
switch 0x424346, sibling reducer 0x42406d, reset 0x423d33/0x423da2, leaf
constructor 0x4237f7 and sound helper 0x4f6334 run as original x86.

Enumerated hooks (OS and host boundaries only):
  0x51dc43  bounded zero-filled bump allocator (original node allocation)
  0x425b8b  skip the side-effect-free debug tree printer
  0x425b40  stop at the original malformed-tree label (constructor rejection)
  0x50cd50  CRT rand(): returns the scenario's queued raw value (0..32767)
  0x30000064 DirectSound IDirectSoundBuffer::GetStatus vtable slot: returns the
            scenario channel's (HRESULT, status word)
Observation only (registers and memory untouched):
  0x4f6334  counts sound-helper entries
No decision of the original (gate, leaf, reducer, reset) is replaced.

For every comparable action in the parsed corpus that contains at least one of
the opcodes 11..15, 17, 20, 21 (the 58 nested actions and every flat one) and
for generated synthetic nested trees, a scripted multi-step history runs on
both sides: evaluations with changing live state and evaluation mode, resets
and dispatcher-pass starts. After EVERY step the oracle compares the wrapper
result, process global 0x5c3a47, every node status (pre-order), the opcode-20
evaluated flag and cached sample, the runtime threshold, the opcode-11 slot,
the sound-manager fields +0x3be/+0x3c2/+0x3ca, and the counts of rand draws
and sound-helper entries.
"""

from __future__ import annotations

import argparse
import collections
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import sys
from typing import Sequence

import conditions_nested_original_oracle as nested
from cif_original_oracle import EXPECTED_EXE_SHA256

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
DEFAULT_NATIVE_LIBRARY = PROJECT / "build/libsessionconditions.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-4-conditions-extra-tree-original-oracle.json"

EXTRA_OPCODES = {11, 12, 13, 14, 15, 17, 20, 21}
RAND_ENTRY = 0x50CD50
SOUND_HELPER = 0x4F6334
SOUND_HELPER_END = 0x4F646C
GET_STATUS_STUB = 0x30000064
SOUND_VTABLE = 0x30000040
SOUND_MANAGER = 0x005CF1EB
SOUND_OBJECTS = 0x40000000       # one 0x10-byte object per channel
CHANNELS = 0x40001000            # 32 * 0x5bb
CHANNEL_STRIDE = 0x5BB
TIME_RECORDS = 0x00585D65
TIME_RECORD_SIZE = 0x106
TIME_RECORD_COUNT = 10
GLOBAL_5C3A47 = 0x005C3A47
OUTSIDE_WINDOW = 0x005BB20A
CONTEXT_58C94F = 0x0058C94F
MODE_ADDRESS = nested.ENGINE_THIS + 0x614
MANAGER_FIELDS = ((0x3BE, "state_3be"), (0x3C2, "error_3c2"), (0x3CA, "host_result_3ca"))
CHANNEL_COUNT = 32


class NativeNode(c.Structure):
    _fields_ = nested.NativeConditionNode._fields_


class NativeRuntime(c.Structure):
    _fields_ = [("runtime_threshold_20", c.c_int32),
                ("random_cache_valid_2c", c.c_uint32),
                ("random_sample_30", c.c_int32)]


class NativeTree(c.Structure):
    _fields_ = [("nodes", c.POINTER(NativeNode)), ("node_count", c.c_size_t),
                ("record_count", c.c_size_t), ("root", c.c_size_t),
                ("runtime", c.POINTER(NativeRuntime)),
                ("selected_leaf", c.c_void_p)]


class ChannelRecord(c.Structure):
    _fields_ = [("device_ready_1a0", c.c_uint32), ("resource_ready_162", c.c_uint32),
                ("buffer_available_28f", c.c_uint32), ("repeat_marker_19e", c.c_uint32),
                ("gate_16e", c.c_uint32), ("gate_172", c.c_uint32),
                ("get_status_hresult", c.c_int32), ("get_status_flags", c.c_uint32)]


class Manager(c.Structure):
    _fields_ = [("state_3be", c.c_uint32), ("error_3c2", c.c_uint32),
                ("host_result_3ca", c.c_int32)]


class Stats(c.Structure):
    _fields_ = [(n, c.c_uint64) for n in ("leaf_evaluations", "sound_queries",
                "random_draws", "passes_started", "trees_evaluated")]


class WorldState(c.Structure):  # filled from test_condition_extra mirrors
    pass


import test_condition_extra as ce          # noqa: E402  (ctypes mirrors only)
import test_scene_conditions_extension as tx  # noqa: E402

ChannelFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16, c.c_void_p)
RandomFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
ContextFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_int16))
VariableFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int16))
VARIABLE_TABLE = 0x005ADB81


class Host(c.Structure):
    _fields_ = [("context", c.c_void_p), ("channel_record", ChannelFn),
                ("next_random", RandomFn), ("read_context_58c94f", ContextFn),
                ("read_variable_word", VariableFn)]


class Config(c.Structure):
    _fields_ = [("world", c.POINTER(ce.WorldInitState)),
                ("clock", c.POINTER(ce.WorldClockSession)),
                ("host", Host), ("debug_enabled_63a4cd", c.c_int32)]


def signed32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value if value < 0x80000000 else value - 0x100000000


# ----------------------------------------------------------------------------
# Original machine
# ----------------------------------------------------------------------------
class ExtraMachine(nested.OriginalMachine):
    def __init__(self, executable: Path):
        super().__init__(executable)
        from unicorn import UC_HOOK_CODE
        self.machine.mem_map(0x40000000, 0x10000)
        self.rand_queue: list[int] = []
        self.rand_calls = 0
        self.sound_entries = 0
        self.get_status_calls = 0
        self.channel_status: dict[int, tuple[int, int]] = {}
        self._hook_error2 = None
        self.machine.hook_add(UC_HOOK_CODE, self._extra_hook, begin=RAND_ENTRY, end=RAND_ENTRY)
        self.machine.hook_add(UC_HOOK_CODE, self._extra_hook, begin=SOUND_HELPER, end=SOUND_HELPER)
        self.machine.hook_add(UC_HOOK_CODE, self._extra_hook,
                              begin=GET_STATUS_STUB, end=GET_STATUS_STUB)
        vtable = bytearray(0x40)
        struct.pack_into("<I", vtable, 0x24, GET_STATUS_STUB)
        self.machine.mem_write(SOUND_VTABLE, bytes(vtable))
        for channel in range(CHANNEL_COUNT):
            self.machine.mem_write(SOUND_OBJECTS + channel * 0x10,
                                   struct.pack("<I", SOUND_VTABLE))

    def _extra_hook(self, uc, address, _size, _user):
        esp = uc.reg_read(self._reg_esp)
        if address == RAND_ENTRY:
            if not self.rand_queue:
                self._hook_error = "rand hook exhausted its scenario queue"
                uc.emu_stop()
                return
            value = self.rand_queue.pop(0)
            self.rand_calls += 1
            ret = struct.unpack("<I", uc.mem_read(esp, 4))[0]
            uc.reg_write(self._reg_eax, value)
            uc.reg_write(self._reg_eip, ret)
            uc.reg_write(self._reg_esp, esp + 4)
        elif address == SOUND_HELPER:
            self.sound_entries += 1
        elif address == GET_STATUS_STUB:
            ret, this_pointer, status_pointer = struct.unpack("<III", uc.mem_read(esp, 12))
            channel = (this_pointer - SOUND_OBJECTS) // 0x10
            hresult, flags = self.channel_status[channel]
            self.get_status_calls += 1
            uc.mem_write(status_pointer, struct.pack("<I", flags & 0xFFFFFFFF))
            uc.reg_write(self._reg_eax, hresult & 0xFFFFFFFF)
            uc.reg_write(self._reg_eip, ret)
            uc.reg_write(self._reg_esp, esp + 12)

    # -- scenario state --------------------------------------------------
    def write_variable_table(self, table: dict):
        for index, word in table.items():
            self.machine.mem_write(VARIABLE_TABLE + 2 * index, struct.pack("<h", word))

    def reset_world(self):
        w = self.machine.mem_write
        w(TIME_RECORDS, bytes(TIME_RECORD_SIZE * TIME_RECORD_COUNT))
        w(SOUND_MANAGER + 0x3BE, struct.pack("<III", 0, 0, 0)[:4])
        w(SOUND_MANAGER + 0x3C2, struct.pack("<I", 0))
        w(SOUND_MANAGER + 0x3CA, struct.pack("<I", 0))
        w(SOUND_MANAGER + 0x3CE, struct.pack("<I", CHANNELS))
        w(CHANNELS, bytes(CHANNEL_STRIDE * CHANNEL_COUNT))
        w(GLOBAL_5C3A47, struct.pack("<I", 0))
        self.rand_queue = []
        self.rand_calls = 0
        self.sound_entries = 0
        self.get_status_calls = 0

    def apply_scenario(self, s: "Scenario"):
        w = self.machine.mem_write
        s.values.write_original_globals(self.machine)
        w(OUTSIDE_WINDOW, struct.pack("<h", s.outside))
        w(CONTEXT_58C94F, struct.pack("<h", s.context))
        for index, (status, elapsed) in enumerate(s.timers):
            w(TIME_RECORDS + index * TIME_RECORD_SIZE,
              struct.pack("<iI", status, elapsed & 0xFFFFFFFF))
        w(SOUND_MANAGER + 0x1A0, struct.pack("<I", s.device_ready))
        w(SOUND_MANAGER + 0x3CE, struct.pack("<I", CHANNELS))
        self.channel_status = {}
        for channel, ch in s.channels.items():
            record = bytearray(CHANNEL_STRIDE)
            struct.pack_into("<I", record, 0x162, ch["resource"])
            struct.pack_into("<I", record, 0x19E, ch["marker"])
            struct.pack_into("<I", record, 0x16E, ch["gate_16e"])
            struct.pack_into("<I", record, 0x172, ch["gate_172"])
            struct.pack_into("<I", record, 0x28F,
                             SOUND_OBJECTS + channel * 0x10 if ch["buffer"] else 0)
            w(CHANNELS + channel * CHANNEL_STRIDE, bytes(record))
            self.channel_status[channel] = (ch["hresult"], ch["flags"])
        self.rand_queue = list(s.rand)
        self.rand_calls = 0
        self.sound_entries = 0
        self.get_status_calls = 0

    def wrapper(self, root: int, mode: int) -> int:
        result, accepted = self.call(nested.ORIGINAL_EVALUATOR, [root, mode], nested.ENGINE_THIS)
        if not accepted:
            raise RuntimeError("original evaluator did not return")
        return c.c_int32(result).value

    def snapshot(self, root: int) -> dict:
        nodes = []

        def walk(container: int):
            node = self.u32(container + 4)
            seen = 0
            while node:
                kind = self.u32(node)
                entry = {"kind": kind, "addr": node, "status": self.i32(node + 4)}
                if kind == 2:
                    entry.update(threshold=self.i32(node + 0x20), valid=self.u32(node + 0x2C),
                                 sample=self.i32(node + 0x30),
                                 opcode=struct.unpack("<h", self.machine.mem_read(node + 0x10, 2))[0])
                nodes.append(entry)
                if kind == 1:
                    walk(self.u32(node + 0x44))
                node = self.u32(node + 0x38)
                seen += 1
                if seen > 600:
                    raise RuntimeError("original sibling chain too long")

        walk(root)
        owner = self.u32(root + 0x24)
        leaf_addresses = [n["addr"] for n in nodes if n["kind"] == 2]
        return {
            "root_status": self.i32(root),
            "nodes": nodes,
            "owner_leaf": leaf_addresses.index(owner) if owner in leaf_addresses else (None if owner == 0 else -1),
            "global": self.u32(GLOBAL_5C3A47),
            "manager": tuple(self.u32(SOUND_MANAGER + off) for off, _ in MANAGER_FIELDS),
            "rand_calls": self.rand_calls,
            "sound_entries": self.sound_entries,
        }


# ----------------------------------------------------------------------------
# Scenario generation (shared by both sides)
# ----------------------------------------------------------------------------
class Scenario:
    def __init__(self, rows: Sequence[Sequence[int]], rng: random.Random, step_index: int):
        leaf_rows = [r for r in rows if r[0] not in (0x12, 0x13)]
        self.values = nested.ConditionValues(rows, rng.choice(("mixed", "target", "inverse", "zero")),
                                             rng.randrange(1 << 30))
        selected_candidates = [r[1] for r in leaf_rows if r[0] == 11]
        if selected_candidates:
            self.values.selected = rng.choice(selected_candidates + [-1, 32000, selected_candidates[0] ^ 1])
        context_targets = [r[2] for r in leaf_rows if r[0] == 15]
        self.context = rng.choice(context_targets + [0, 1, -1]) if context_targets else rng.choice((0, 1, -1))
        outside_targets = [r[1] for r in leaf_rows if r[0] == 12]
        self.outside = rng.choice(outside_targets + [0, 1, -1]) if outside_targets else rng.choice((0, 1))
        self.timers = []
        for _ in range(TIME_RECORD_COUNT):
            self.timers.append((rng.choice((0, 1, 2, 3, 4, 5, 6, 7, -1, 1, 5, 6)),
                                rng.choice((-1, 0, 0, 1, 2, 1000, -70000, 0x7FFFFFFF, -0x80000000))))
        self.device_ready = rng.choice((1, 1, 1, 1, 0, 2))
        self.channels = {}
        for row in leaf_rows:
            if row[0] == 17 and 0 <= row[1] < CHANNEL_COUNT:
                kind = rng.choice(("playing", "playing", "idle", "idle", "unloaded",
                                   "nobuffer", "failed", "marker", "marker_paused",
                                   "other_bits"))
                ch = {"resource": 1, "buffer": 1, "marker": 0, "gate_16e": 0, "gate_172": 0,
                      "hresult": 0, "flags": 1}
                if kind == "idle":
                    ch["flags"] = 0
                elif kind == "unloaded":
                    ch["resource"] = 0
                elif kind == "nobuffer":
                    ch["buffer"] = 0
                elif kind == "failed":
                    ch["hresult"] = signed32(0x80004005)
                elif kind == "marker":
                    ch["marker"] = rng.choice((1, 2))
                    ch["flags"] = rng.choice((0, 1))
                elif kind == "marker_paused":
                    ch["marker"] = 1
                    ch["gate_16e"], ch["gate_172"] = rng.choice(((1, 0), (0, 5), (3, 3)))
                elif kind == "other_bits":
                    ch["flags"] = rng.choice((2, 3, 0xFE, 0x100, 0x101))
                self.channels[row[1]] = ch
        self.prior_global = rng.choice((0, 1, 1, 0, 7, -1))
        self.mode = rng.choice((0, 1))
        self.reset_before = step_index > 0 and rng.random() < 0.3
        self.pass_before = rng.random() < 0.35
        draws = []
        for _ in range(64):
            draws.append(rng.choice((rng.randrange(0, 100), rng.randrange(0, 32768),
                                     32767, 0, 99, 100, 12345)))
        self.rand = draws


# ----------------------------------------------------------------------------
# Native driver
# ----------------------------------------------------------------------------
class NativeSide:
    def __init__(self, lib, rows: Sequence[Sequence[int]], table: dict):
        self.lib = lib
        self.table = table
        self.scenario: Scenario | None = None
        self.rand_queue: list[int] = []
        self.channel_calls = 0
        self.fixture = ce.Fixture()

        def channel_fn(_ctx, channel, out):
            self.channel_calls += 1
            s = self.scenario
            ch = s.channels[channel]
            record = ChannelRecord(
                s.device_ready, ch["resource"], ch["buffer"], ch["marker"], ch["gate_16e"],
                ch["gate_172"], ch["hresult"], ch["flags"])
            c.memmove(out, c.byref(record), c.sizeof(ChannelRecord))
            return 0

        def random_fn(_ctx, out):
            out[0] = self.rand_queue.pop(0)
            return 0

        def context_fn(_ctx, out):
            out[0] = self.scenario.context
            return 0

        def variable_fn(_ctx, index, out):
            if index not in self.table:
                return 0
            out[0] = self.table[index]
            return 1

        self.fns = (ChannelFn(channel_fn), RandomFn(random_fn), ContextFn(context_fn),
                    VariableFn(variable_fn))
        config = Config()
        config.world = c.pointer(self.fixture.world)
        config.clock = c.pointer(self.fixture.clock)
        config.host.channel_record = self.fns[0]
        config.host.next_random = self.fns[1]
        config.host.read_context_58c94f = self.fns[2]
        config.host.read_variable_word = self.fns[3]
        status = c.c_int(-1)
        self.binding = lib.session_conditions_create(c.byref(config), c.byref(status))
        assert status.value == 0 and self.binding
        self.extension = c.cast(lib.session_conditions_extension(self.binding), c.POINTER(tx.Extension))
        array = (tx.SceneDependencyInfo * len(rows))(*(self._record(r) for r in rows))
        self.tree = c.c_void_p()
        self.build_status = lib.scene_conditions_build(array, len(rows), c.byref(self.tree))
        self.native_tree = c.cast(self.tree, c.POINTER(NativeTree)) if self.build_status == 0 else None

    @staticmethod
    def _record(row):
        value = tx.SceneDependencyInfo()
        value.opcode = row[0] & 0xFFFF
        value.or_after = row[3]
        value.fields[:] = row
        return value

    def close(self):
        if self.build_status == 0:
            self.lib.scene_conditions_destroy(self.tree)
        self.lib.session_conditions_destroy(self.binding)

    def apply(self, s: Scenario):
        self.scenario = s
        self.rand_queue = list(s.rand)
        records = self.fixture.records
        for index, (status, elapsed) in enumerate(s.timers):
            struct.pack_into("<iI", records, index * ce.RECORD_SIZE, status, elapsed & 0xFFFFFFFF)
        self.fixture.clock.outside_window_flag_5bb20a = s.outside
        self.channel_calls = 0
        self.stats_before = self.stats()

    def stats(self) -> Stats:
        s = Stats()
        self.lib.session_conditions_get_stats(self.binding, c.byref(s))
        return s

    def pass_started(self):
        ext = self.extension.contents
        ext.pass_started(ext.context)

    def evaluate(self, s: Scenario) -> int:
        state, arrays = s.values.native()
        answer = c.c_int(-99)
        unsupported = c.c_uint16(0)
        failure = tx.Failure()
        status = self.lib.scene_conditions_evaluate_ex(
            self.tree, c.byref(state), self.extension, s.mode, c.byref(answer),
            c.byref(unsupported), c.byref(failure))
        if status != 0:
            raise RuntimeError(f"native evaluation status {status} opcode {failure.opcode} "
                               f"record {failure.record_index} detail {failure.provider_status}")
        del arrays
        return int(answer.value)

    def reset(self):
        self.lib.scene_conditions_reset(self.tree)

    def snapshot(self) -> dict:
        tree = self.native_tree.contents
        nodes = []
        leaf_nodes = []
        for index in range(tree.node_count):
            if index == tree.root:
                continue
            node = tree.nodes[index]
            entry = {"kind": node.kind, "status": int(node.status)}
            if node.kind == 2:
                rt = tree.runtime[index]
                entry.update(threshold=rt.runtime_threshold_20, valid=rt.random_cache_valid_2c,
                             sample=rt.random_sample_30, opcode=node.opcode)
                leaf_nodes.append(c.addressof(node))
            nodes.append(entry)
        owner = tree.selected_leaf
        owner_leaf = None if not owner else (leaf_nodes.index(owner) if owner in leaf_nodes else -1)
        manager = Manager()
        self.lib.session_conditions_get_stats  # keep reference
        self.lib.session_conditions_get_sound_manager(self.binding, c.byref(manager))
        stats = self.stats()
        return {
            "root_status": int(tree.nodes[tree.root].status),
            "nodes": nodes,
            "owner_leaf": owner_leaf,
            "global": self.lib.session_conditions_global_5c3a47(self.binding) & 0xFFFFFFFF,
            "manager": (manager.state_3be, manager.error_3c2, manager.host_result_3ca & 0xFFFFFFFF),
            "rand_calls": stats.random_draws - self.stats_before.random_draws,
            "sound_entries": stats.sound_queries - self.stats_before.sound_queries,
        }

    def set_global(self, value: int):
        self.lib.session_conditions_set_global_5c3a47(self.binding, value)


def native_library(path: Path):
    lib = c.CDLL(str(path.resolve()))
    lib.scene_conditions_build.argtypes = [c.POINTER(tx.SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)]
    lib.scene_conditions_build.restype = c.c_int
    lib.scene_conditions_destroy.argtypes = [c.c_void_p]
    lib.scene_conditions_reset.argtypes = [c.c_void_p]
    lib.scene_conditions_evaluate_ex.argtypes = [
        c.c_void_p, c.c_void_p, c.POINTER(tx.Extension), c.c_int32, c.POINTER(c.c_int),
        c.POINTER(c.c_uint16), c.POINTER(tx.Failure)]
    lib.scene_conditions_evaluate_ex.restype = c.c_int
    lib.session_conditions_create.argtypes = [c.POINTER(Config), c.POINTER(c.c_int)]
    lib.session_conditions_create.restype = c.c_void_p
    lib.session_conditions_destroy.argtypes = [c.c_void_p]
    lib.session_conditions_extension.argtypes = [c.c_void_p]
    lib.session_conditions_extension.restype = c.c_void_p
    lib.session_conditions_global_5c3a47.argtypes = [c.c_void_p]
    lib.session_conditions_global_5c3a47.restype = c.c_int32
    lib.session_conditions_set_global_5c3a47.argtypes = [c.c_void_p, c.c_int32]
    lib.session_conditions_get_sound_manager.argtypes = [c.c_void_p, c.POINTER(Manager)]
    lib.session_conditions_get_stats.argtypes = [c.c_void_p, c.POINTER(Stats)]
    return lib


# ----------------------------------------------------------------------------
# Corpus and synthetic trees
# ----------------------------------------------------------------------------
def corpus_actions(scene_dir: Path, scene_library: Path):
    lib = nested.open_scene_library(scene_library)
    files = 0
    actions = []
    for path in sorted(scene_dir.glob("*.bin")):
        data = path.read_bytes()
        storage = (c.c_uint8 * len(data)).from_buffer_copy(data)
        error = c.create_string_buffer(256)
        scene = lib.scene_resource_open_memory(storage, len(data), error, len(error))
        if not scene:
            continue
        files += 1
        try:
            for index in range(lib.scene_resource_action_count(scene)):
                action = nested.SceneActionInfo()
                lib.scene_resource_action_at(scene, index, c.byref(action))
                rows = []
                for dep in range(action.dependency_count):
                    record = nested.SceneDependencyInfo()
                    lib.scene_resource_dependency_at(scene, index, dep, c.byref(record))
                    rows.append(tuple(int(v) for v in record.fields))
                if any(r[0] in EXTRA_OPCODES for r in rows):
                    actions.append({"case_id": f"{path.name}:action-{index}", "rows": rows,
                                    "nested": any(r[0] == 0x12 for r in rows)})
        finally:
            lib.scene_resource_close(scene)
    return files, actions


def synthetic_trees(count: int, seed: int):
    rng = random.Random(seed)
    trees = []

    def leaf_row():
        opcode = rng.choice((11, 12, 13, 14, 15, 17, 20, 21, 2, 11, 17, 20, 13))
        marker = rng.choice((0, 0, 1, 1, 2, -1))
        if opcode == 11:
            return (11, rng.randrange(0, 6), 0, marker, 0, 0, 0, 0)
        if opcode == 12:
            return (12, rng.choice((-1, 0, 1)), 0, marker, 0, 0, 0, 0)
        if opcode in (13, 14):
            return (opcode, rng.randrange(0, TIME_RECORD_COUNT), 1, marker,
                    rng.choice((0, 0, 1, -1, 2)), rng.choice((0, 0, 3, -2)),
                    rng.choice((0, 7, 4999, 5000, 5001, 5003, 5100, -3)),
                    rng.choice((0, 0, 250, -250)))
        if opcode == 15:
            return (15, 0, rng.choice((-1, 0, 1)), marker, 0, 0, 0, 0)
        if opcode == 17:
            return (17, rng.randrange(0, CHANNEL_COUNT), rng.choice((0, 1, 1, 0, 2)), marker, 0, 0, 0, 0)
        if opcode == 20:
            return (20, 0, rng.choice((1, 25, 50, 75, 100)), marker, 0, 0, 0, 0)
        if opcode == 21:
            return (21, 0, 0, marker, 0, 0, 0, 0)
        return (2, rng.randrange(0, 4), rng.choice((0, 1)), marker, 0, 0, 0, 0)

    def build(depth):
        rows = []
        for _ in range(rng.randrange(2, 5)):
            if depth < 2 and rng.random() < 0.3:
                marker = rng.choice((0, 1))
                inner = build(depth + 1)
                rows.append((0x12, 0, 0, marker, 0, 0, 0, 0))
                rows.extend(inner)
                rows.append((0x13, 0, 0, marker, 0, 0, 0, 0))
            else:
                rows.append(leaf_row())
        return rows

    while len(trees) < count:
        rows = build(0)
        if rng.random() < 0.5:
            rows = [leaf_row()] + rows
        if len(rows) > 60:
            continue
        # the loader's own rejections (group arity, adjacent opcode-11 records)
        # are compared case by case; keep the group/marker preflight valid
        if nested.original_preflight_reason(rows) is not None:
            continue
        trees.append({"case_id": f"synthetic-{len(trees)}", "rows": rows, "nested": any(r[0] == 0x12 for r in rows)})
    return trees


# ----------------------------------------------------------------------------
# Comparison
# ----------------------------------------------------------------------------
FIELDS = ("result", "root_status", "node_statuses", "random_valid_and_sample",
          "runtime_threshold", "opcode11_slot", "global_5c3a47", "sound_manager",
          "rand_draws", "sound_helper_entries")


def compare_snapshots(original: dict, native: dict, o_result: int, n_result: int):
    mismatches = []
    o_nodes = [n for n in original["nodes"]]
    n_nodes = native["nodes"]
    checks = {
        "result": (o_result, n_result),
        "root_status": (original["root_status"], native["root_status"]),
        "node_statuses": ([(n["kind"], n["status"]) for n in o_nodes],
                          [(n["kind"], n["status"]) for n in n_nodes]),
        "random_valid_and_sample": ([(n["valid"], n["sample"]) for n in o_nodes if n["kind"] == 2],
                                    [(n["valid"], n["sample"]) for n in n_nodes if n["kind"] == 2]),
        # Opcodes 6 and 9 keep their thresholds in node->time_value (native)
        # or other node words (original); every other leaf uses +0x20.
        "runtime_threshold": ([n["threshold"] for n in o_nodes if n["kind"] == 2 and n["opcode"] not in (6, 9)],
                              [n["threshold"] for n in n_nodes if n["kind"] == 2 and n["opcode"] not in (6, 9)]),
        "opcode11_slot": (original["owner_leaf"], native["owner_leaf"]),
        "global_5c3a47": (original["global"], native["global"]),
        "sound_manager": (original["manager"], native["manager"]),
        "rand_draws": (original["rand_calls"], native["rand_calls"]),
        "sound_helper_entries": (original["sound_entries"], native["sound_entries"]),
    }
    for name, (a, b) in checks.items():
        if a != b:
            mismatches.append({"field": name, "original": a, "native": b})
    return mismatches, len(checks)


def run_case(machine: ExtraMachine, lib, case: dict, rng_seed: int, steps: int):
    rows = case["rows"]
    rng = random.Random(rng_seed)
    # Loader table 0x5adb81[idx] read when an opcode 13/14 leaf with
    # fields[6] >= 5000 is built; fixed for the case on both sides.
    table = {row[6]: rng.choice((0, 0, 1, 2, 30, -1, 100, 32767, -32768))
             for row in rows if row[0] in (13, 14) and row[6] >= 5000}
    machine.machine.mem_write(VARIABLE_TABLE, bytes(2 * 6000))
    machine.write_variable_table(table)
    accepted, root = machine.load(rows)
    comparisons = collections.Counter()
    mismatches = []
    native = NativeSide(lib, rows, table)
    comparisons["constructor_outcomes"] += 1
    if accepted != (native.build_status == 0):
        mismatches.append({"field": "constructor", "case_id": case["case_id"],
                           "original_accepted": accepted, "native_status": native.build_status})
        native.close()
        return comparisons, mismatches
    if not accepted:
        comparisons["agreed_rejections"] += 1
        native.close()
        return comparisons, mismatches
    if not case["case_id"].startswith("synthetic"):
        pass
    machine.reset_world()
    try:
        for step in range(steps):
            scenario = Scenario(rows, rng, step)
            trace = []
            if scenario.reset_before:
                machine.reset(root)
                native.reset()
                trace.append("reset")
            machine.apply_scenario(scenario)
            native.apply(scenario)
            if scenario.pass_before:
                machine.machine.mem_write(GLOBAL_5C3A47, struct.pack("<I", 1))
                native.pass_started()
                trace.append("pass")
            else:
                machine.machine.mem_write(GLOBAL_5C3A47, struct.pack("<I", scenario.prior_global & 0xFFFFFFFF))
                native.set_global(scenario.prior_global)
            trace.append(f"eval(mode={scenario.mode})")
            o_result = machine.wrapper(root, scenario.mode)
            n_result = native.evaluate(scenario)
            found, count = compare_snapshots(machine.snapshot(root), native.snapshot(), o_result, n_result)
            for name in FIELDS:
                comparisons[name] += 1
            comparisons["steps"] += 1
            for item in found:
                item.update(case_id=case["case_id"], step=step, trace=trace)
                mismatches.append(item)
            # second evaluation without any state change: retained statuses
            # and cached samples must agree again (persistence between ticks)
            trace2 = ["eval-again"]
            machine.rand_queue = list(scenario.rand[17:])
            native.rand_queue = list(scenario.rand[17:])
            machine.rand_calls = 0
            machine.sound_entries = 0
            native.stats_before = native.stats()
            o_result = machine.wrapper(root, scenario.mode)
            n_result = native.evaluate(scenario)
            found, count = compare_snapshots(machine.snapshot(root), native.snapshot(), o_result, n_result)
            for name in FIELDS:
                comparisons[name] += 1
            comparisons["steps"] += 1
            for item in found:
                item.update(case_id=case["case_id"], step=step, trace=trace + trace2)
                mismatches.append(item)
    finally:
        native.close()
    return comparisons, mismatches


def original_code_ranges(machine: ExtraMachine):
    windows = [
        ("leaf_constructor", 0x4237F7, 0x423876),
        ("reset_entry", 0x423D33, 0x423DA2),
        ("reset_traversal", 0x423DA2, 0x423F57),
        ("evaluation_wrapper", 0x423F57, 0x42406D),
        ("branch_reducer", 0x42406D, 0x424201),
        ("recursive_evaluator", 0x424201, 0x424346),
        ("leaf_switch", 0x424346, 0x424AA8),
        ("dependency_loader", 0x424AA8, 0x425B8B),
        ("sound_query_helper", SOUND_HELPER, SOUND_HELPER_END),
        ("crt_rand", 0x50CD50, 0x50CD72),
    ]
    out = []
    for name, start, end in windows:
        offset = machine.pe.va_to_file_offset(start, end - start)
        out.append({"name": name, "start_va": f"0x{start:08x}", "end_va_exclusive": f"0x{end:08x}",
                    "byte_count": end - start,
                    "sha256": hashlib.sha256(machine.pe.data[offset:offset + end - start]).hexdigest()})
    return out


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(args) -> bool:
    machine = ExtraMachine(args.exe)
    lib = native_library(args.native_library)
    files, actions = corpus_actions(args.scene_dir, args.scene_library)
    nested_count = sum(1 for a in actions if a["nested"])
    synthetic = synthetic_trees(args.synthetic, seed=0x424346)
    cases = actions + synthetic
    if args.limit:
        keep = [a for a in actions if a["nested"]][: args.limit // 2] + \
               [a for a in actions if not a["nested"]][: args.limit // 2] + synthetic[: args.limit // 4]
        cases = keep
    totals = collections.Counter()
    all_mismatches = []
    per_kind = collections.Counter()
    leaf_occurrences = collections.Counter()
    for index, case in enumerate(cases):
        comparisons, mismatches = run_case(machine, lib, case, rng_seed=0x4F6334 + index, steps=args.steps)
        totals.update(comparisons)
        all_mismatches.extend(mismatches)
        kind = "synthetic" if case["case_id"].startswith("synthetic") else \
            ("corpus_nested" if case["nested"] else "corpus_flat")
        per_kind[kind] += 1
        for row in case["rows"]:
            if row[0] in EXTRA_OPCODES:
                leaf_occurrences[row[0]] += 1
    code_ranges = original_code_ranges(machine)
    report = {
        "scope": "RT-4 whole-tree native (scene_conditions + condition_extra + session-conditions binding) vs original x86 dependency wrapper/evaluator/reset",
        "original_executable_sha256": machine.executable_sha256,
        "expected_executable_sha256": EXPECTED_EXE_SHA256,
        "native_library": str(args.native_library),
        "native_library_sha256": sha256_file(args.native_library),
        "scene_resource_library_sha256": sha256_file(args.scene_library),
        "oracle_script_sha256": sha256_file(Path(__file__)),
        "code_windows": code_ranges,
        "hooks": [
            {"va": "0x51dc43", "kind": "boundary", "purpose": "bounded zero-filled bump allocator for original node allocation"},
            {"va": "0x425b8b", "kind": "boundary", "purpose": "skip side-effect-free debug tree printer"},
            {"va": "0x425b40", "kind": "boundary", "purpose": "stop at original malformed-tree label (constructor rejection only)"},
            {"va": "0x50cd50", "kind": "boundary", "purpose": "CRT rand(): returns the scenario's queued raw value"},
            {"va": "0x30000064", "kind": "boundary", "purpose": "DirectSound GetStatus vtable slot: returns the scenario channel's (HRESULT, status)"},
            {"va": "0x4f6334", "kind": "observation", "purpose": "counts sound-helper entries; registers and memory untouched"},
        ],
        "unmodified_original_paths": [
            "0x424aa8 loader", "0x4237f7 leaf constructor", "0x423f57 wrapper incl. 0x5c3a47 store",
            "0x424201 evaluator", "0x424346 leaf switch (opcodes 0..22 incl. 11-21)",
            "0x42406d reducer", "0x423d33/0x423da2 reset", "0x4f6334 sound helper body"],
        "corpus": {
            "scene_files_parsed": files,
            "actions_with_extra_leaves": len(actions),
            "nested_actions_with_extra_leaves": nested_count,
            "flat_actions_with_extra_leaves": len(actions) - nested_count,
            "cases_compared": dict(per_kind),
            "extra_leaf_occurrences_compared": {str(k): v for k, v in sorted(leaf_occurrences.items())},
        },
        "steps_per_case": args.steps,
        "evaluation_steps": totals["steps"],
        "comparisons_by_field": {name: totals[name] for name in FIELDS},
        "constructor_outcomes_compared": totals["constructor_outcomes"],
        "constructor_agreed_rejections": totals["agreed_rejections"],
        "total_field_comparisons": sum(totals[name] for name in FIELDS),
        "mismatch_count": len(all_mismatches),
        "mismatches_first_20": all_mismatches[:20],
        "divergence_notes": [
            "native rejects timer indexes >= 10 and channels >= 32 (original reads unchecked); corpus uses timers 1..4 and channels 0..13, so no comparison hits the rejection",
            "debug-fatal path of opcode 20 (0x63a4cd != 0) is not compared: the original continues into the headless modal-error boundary",
            "the 0x5adb81 variable table is a per-case fixture on both sides; its real producer (if any) is unrecovered",
            "threshold +0x20 writers outside the loader (none found by static scan) are not modelled on either side",
        ],
    }
    report["status"] = "pass" if not all_mismatches and totals["steps"] > 0 else "mismatch"
    if not args.no_report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("status", "evaluation_steps", "total_field_comparisons",
                                              "mismatch_count", "native_library_sha256",
                                              "constructor_outcomes_compared",
                                              "constructor_agreed_rejections")} |
                     {"cases": dict(per_kind), "nested_actions": nested_count,
                      "first_mismatch": all_mismatches[0] if all_mismatches else None}, default=str))
    return report["status"] == "pass"


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=nested.DEFAULT_EXE)
    parser.add_argument("--scene-dir", type=Path, default=nested.DEFAULT_SCENE_DIR)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE_LIBRARY)
    parser.add_argument("--scene-library", type=Path, default=nested.DEFAULT_SCENE_LIBRARY)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--steps", type=int, default=6)
    parser.add_argument("--synthetic", type=int, default=300)
    parser.add_argument("--limit", type=int, default=0, help="cap cases (mutation runs)")
    parser.add_argument("--no-report", action="store_true")
    args = parser.parse_args(argv)
    return 0 if run(args) else 1


if __name__ == "__main__":
    raise SystemExit(main())
