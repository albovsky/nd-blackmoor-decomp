"""RT-4: dependency leaves 11..21 through real trees, the real condition_extra
kernel and the session-conditions binding.

Everything here is native-only (host callbacks are Python fakes). The
original-x86 comparison lives in conditions_extra_tree_original_oracle.py.
Build with scripts/build_session_conditions.sh first.
"""
from __future__ import annotations

import ctypes as c
import os
from pathlib import Path
import struct
import unittest

import test_condition_extra as ce
import test_scene_conditions_extension as tx

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = Path(os.environ.get("SESSION_CONDITIONS_LIBRARY") or
               PROJECT / "build/libsessionconditions.dylib")

HOST_OK, HOST_UNAVAILABLE, HOST_PARTIAL = 0, 1, 2
OK, ERR_BOUNDS, ERR_UNSUPPORTED, ERR_HOST_UNAVAILABLE, ERR_PROVIDER = 0, 5, 6, 7, 8
EXTRA_ERR_ARGUMENT, EXTRA_ERR_HOST_FAILURE, EXTRA_ERR_DEBUG_FATAL = 1, 5, 6
RECORD_SIZE = ce.RECORD_SIZE

ChannelFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16,
                        c.c_void_p)
RandomFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
ContextFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_int16))
VariableFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int16))


class ChannelRecord(c.Structure):
    _fields_ = [
        ("device_ready_1a0", c.c_uint32),
        ("resource_ready_162", c.c_uint32),
        ("buffer_available_28f", c.c_uint32),
        ("repeat_marker_19e", c.c_uint32),
        ("gate_16e", c.c_uint32),
        ("gate_172", c.c_uint32),
        ("get_status_hresult", c.c_int32),
        ("get_status_flags", c.c_uint32),
    ]


class Manager(c.Structure):
    _fields_ = [("state_3be", c.c_uint32), ("error_3c2", c.c_uint32),
                ("host_result_3ca", c.c_int32)]


class Host(c.Structure):
    _fields_ = [("context", c.c_void_p), ("channel_record", ChannelFn),
                ("next_random", RandomFn), ("read_context_58c94f", ContextFn),
                ("read_variable_word", VariableFn)]


class Config(c.Structure):
    _fields_ = [("world", c.POINTER(ce.WorldInitState)),
                ("clock", c.POINTER(ce.WorldClockSession)),
                ("host", Host), ("debug_enabled_63a4cd", c.c_int32)]


class Stats(c.Structure):
    _fields_ = [("leaf_evaluations", c.c_uint64), ("sound_queries", c.c_uint64),
                ("random_draws", c.c_uint64), ("passes_started", c.c_uint64),
                ("trees_evaluated", c.c_uint64)]


class CrtRand(c.Structure):
    _fields_ = [("holdrand", c.c_uint32)]


def msvc_rand_reference(seed):
    state = seed & 0xFFFFFFFF
    while True:
        state = (state * 214013 + 2531011) & 0xFFFFFFFF
        yield (state >> 16) & 0x7FFF


def record(opcode, index=0, condition=0, or_after=0, rest=(0, 0, 0, 0)):
    return tx.record(opcode, index, condition, or_after, rest)


class Fixture:
    """Binding + borrowed world + fake host."""

    def __init__(self, test, *, debug=0, with_channel=True, with_random=True,
                 with_context=True):
        self.test = test
        lib = test.lib
        self.fixture = ce.Fixture()
        self.channel = ChannelRecord(1, 1, 1, 0, 0, 0, 0, 1)
        self.channel_unavailable = False
        self.channel_calls = []
        self.random_values = []
        self.random_calls = 0
        self.random_status = HOST_OK
        self.context_value = 0
        self.context_status = HOST_OK
        self.context_calls = 0
        self.variables = {}
        self.variable_reads = []

        def variable_fn(_ctx, index, out):
            self.variable_reads.append(index)
            if self.variables.get(index) is None:
                return 0
            out[0] = self.variables[index]
            return 1

        def channel_fn(_ctx, channel, out):
            self.channel_calls.append(channel)
            if self.channel_unavailable:
                return HOST_UNAVAILABLE
            c.memmove(out, c.byref(self.channel), c.sizeof(ChannelRecord))
            return HOST_OK

        def random_fn(_ctx, out):
            self.random_calls += 1
            if self.random_status != HOST_OK:
                return self.random_status
            out[0] = self.random_values.pop(0)
            return HOST_OK

        def context_fn(_ctx, out):
            self.context_calls += 1
            if self.context_status != HOST_OK:
                return self.context_status
            out[0] = self.context_value
            return HOST_OK

        self.fns = (ChannelFn(channel_fn), RandomFn(random_fn), ContextFn(context_fn),
                    VariableFn(variable_fn))
        config = Config()
        config.world = c.pointer(self.fixture.world)
        config.clock = c.pointer(self.fixture.clock)
        config.host.channel_record = self.fns[0] if with_channel else ChannelFn()
        config.host.next_random = self.fns[1] if with_random else RandomFn()
        config.host.read_context_58c94f = self.fns[2] if with_context else ContextFn()
        config.host.read_variable_word = self.fns[3]
        config.debug_enabled_63a4cd = debug
        status = c.c_int(-1)
        self.binding = lib.session_conditions_create(c.byref(config), c.byref(status))
        test.assertEqual(status.value, 0)
        test.assertTrue(self.binding)
        test.addCleanup(lib.session_conditions_destroy, self.binding)
        self.extension = c.cast(lib.session_conditions_extension(self.binding),
                                c.POINTER(tx.Extension))

    def tree(self, records):
        tree = c.c_void_p()
        array = (tx.SceneDependencyInfo * len(records))(*records) if records else None
        self.test.assertEqual(self.test.lib.scene_conditions_build(
            array, len(records), c.byref(tree)), 0)
        self.test.addCleanup(self.test.lib.scene_conditions_destroy, tree)
        return tree

    def state(self, selected=-1):
        s = tx.SceneConditionState()
        s.selected_inventory_item = selected
        flags = (c.c_int32 * 4)()
        s.event_flags = flags
        s.event_flag_count = 4
        self.test._keep.append(flags)
        return s

    def evaluate(self, tree, *, mode=0, selected=-1):
        answer = c.c_int(-9)
        unsupported = c.c_uint16(0xFFFF)
        failure = tx.Failure()
        state = self.state(selected)
        status = self.test.lib.scene_conditions_evaluate_ex(
            tree, c.byref(state), self.extension, mode, c.byref(answer),
            c.byref(unsupported), c.byref(failure))
        return status, answer.value, unsupported.value, failure

    def global_5c3a47(self):
        return self.test.lib.session_conditions_global_5c3a47(self.binding)

    def manager(self):
        m = Manager()
        self.test.assertEqual(self.test.lib.session_conditions_get_sound_manager(
            self.binding, c.byref(m)), 0)
        return (m.state_3be, m.error_3c2, m.host_result_3ca)

    def stats(self):
        s = Stats()
        self.test.assertEqual(self.test.lib.session_conditions_get_stats(
            self.binding, c.byref(s)), 0)
        return s

    def pass_started(self):
        ext = self.extension.contents
        ext.pass_started(ext.context)


class SessionConditionsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            raise unittest.SkipTest("Build with scripts/build_session_conditions.sh first")
        lib = c.CDLL(str(LIBRARY))
        cls.lib = lib
        lib.scene_conditions_build.argtypes = [
            c.POINTER(tx.SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)]
        lib.scene_conditions_build.restype = c.c_int
        lib.scene_conditions_destroy.argtypes = [c.c_void_p]
        lib.scene_conditions_reset.argtypes = [c.c_void_p]
        lib.scene_conditions_evaluate_ex.argtypes = [
            c.c_void_p, c.POINTER(tx.SceneConditionState), c.POINTER(tx.Extension),
            c.c_int32, c.POINTER(c.c_int), c.POINTER(c.c_uint16), c.POINTER(tx.Failure)]
        lib.scene_conditions_evaluate_ex.restype = c.c_int
        lib.scene_conditions_selected_item_label.argtypes = [
            c.c_void_p, c.POINTER(c.c_int32)]
        lib.scene_conditions_selected_item_label.restype = c.c_int
        lib.session_conditions_create.argtypes = [c.POINTER(Config), c.POINTER(c.c_int)]
        lib.session_conditions_create.restype = c.c_void_p
        lib.session_conditions_destroy.argtypes = [c.c_void_p]
        lib.session_conditions_extension.argtypes = [c.c_void_p]
        lib.session_conditions_extension.restype = c.c_void_p
        lib.session_conditions_global_5c3a47.argtypes = [c.c_void_p]
        lib.session_conditions_global_5c3a47.restype = c.c_int32
        lib.session_conditions_set_global_5c3a47.argtypes = [c.c_void_p, c.c_int32]
        lib.session_conditions_get_sound_manager.argtypes = [c.c_void_p, c.POINTER(Manager)]
        lib.session_conditions_get_sound_manager.restype = c.c_int
        lib.session_conditions_get_stats.argtypes = [c.c_void_p, c.POINTER(Stats)]
        lib.session_conditions_get_stats.restype = c.c_int
        lib.session_conditions_query_channel_record.argtypes = [
            c.POINTER(ChannelRecord), c.POINTER(Manager)]
        lib.session_conditions_query_channel_record.restype = c.c_int
        lib.session_conditions_crt_rand_init.argtypes = [c.POINTER(CrtRand)]
        lib.session_conditions_crt_srand.argtypes = [c.POINTER(CrtRand), c.c_uint32]
        lib.session_conditions_crt_rand.argtypes = [c.POINTER(CrtRand)]
        lib.session_conditions_crt_rand.restype = c.c_uint32
        lib.session_conditions_crt_rand_host.argtypes = [c.c_void_p, c.POINTER(c.c_uint32)]
        lib.session_conditions_crt_rand_host.restype = c.c_int
        lib.session_conditions_bsum_variable_word.argtypes = [
            c.c_char_p, c.c_size_t, c.c_int16, c.POINTER(c.c_int16)]
        lib.session_conditions_bsum_variable_word.restype = c.c_int
        lib.session_conditions_status_string.argtypes = [c.c_int]
        lib.session_conditions_status_string.restype = c.c_char_p

    def setUp(self):
        self._keep = []

    # -- creation ---------------------------------------------------------
    def test_create_reports_status_and_rejects_null_config(self):
        status = c.c_int(-1)
        self.assertFalse(self.lib.session_conditions_create(None, c.byref(status)))
        self.assertEqual(status.value, 1)
        f = Fixture(self)
        s = f.stats()
        self.assertEqual((s.leaf_evaluations, s.sound_queries, s.random_draws,
                          s.passes_started, s.trees_evaluated), (0, 0, 0, 0, 0))
        self.assertEqual(f.global_5c3a47(), 0)
        self.assertEqual(f.manager(), (0, 0, 0))

    # -- opcode 12 ----------------------------------------------------------
    def test_opcode12_reads_the_live_outside_window_word(self):
        f = Fixture(self)
        tree = f.tree([record(12, -1)])
        f.fixture.clock.outside_window_flag_5bb20a = -1
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        f.fixture.clock.outside_window_flag_5bb20a = 1
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))

    # -- opcodes 13 / 14 -----------------------------------------------------
    def test_timer_leaves_read_the_live_records_and_never_a_snapshot(self):
        f = Fixture(self)
        before = f.tree([record(13, 2, 1)])
        after = f.tree([record(14, 2, 1)])
        f.fixture.put_timer(2, 1, 0)
        self.assertEqual(f.evaluate(before)[:2], (OK, 1))
        self.assertEqual(f.evaluate(after)[:2], (OK, 0))
        f.fixture.put_timer(2, 1, 250)         # mutated by the world clock later
        self.assertEqual(f.evaluate(before)[:2], (OK, 0))
        self.assertEqual(f.evaluate(after)[:2], (OK, 1))
        f.fixture.put_timer(2, 2, 250)         # inactive status: both false
        self.assertEqual(f.evaluate(before)[:2], (OK, 0))
        self.assertEqual(f.evaluate(after)[:2], (OK, 0))
        for active in (5, 6):
            f.fixture.put_timer(2, active, 0)
            self.assertEqual(f.evaluate(before)[:2], (OK, 1))

    def test_timer_index_outside_the_record_table_is_rejected_not_read(self):
        f = Fixture(self)
        for index in (10, 11, 32767, -1):
            status, answer, _u, failure = f.evaluate(f.tree([record(13, index, 1)]))
            self.assertEqual((status, answer), (ERR_BOUNDS, 0), index)
            self.assertEqual(failure.opcode, 13)

    def test_variable_seconds_threshold_uses_the_host_table_word(self):
        f = Fixture(self)
        f.variables = {5000: 3}
        before = f.tree([record(13, 2, 1, 0, (0, 1, 5000, 500))])
        after = f.tree([record(14, 2, 1, 0, (0, 1, 5000, 500))])
        threshold = 60_000 + 3000 + 500
        f.fixture.put_timer(2, 1, threshold)
        self.assertEqual(f.evaluate(before)[:2], (OK, 1))      # elapsed <= threshold
        self.assertEqual(f.evaluate(after)[:2], (OK, 0))
        f.fixture.put_timer(2, 1, threshold + 1)
        self.assertEqual(f.evaluate(before)[:2], (OK, 0))
        self.assertEqual(f.evaluate(after)[:2], (OK, 1))
        self.assertEqual(f.variable_reads, [5000, 5000])        # once per tree

    # -- BOOT BSUM variable table (review P1) -----------------------------------
    BSUM_PATH = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/0053.bin"

    def bsum_word(self, bsum, index):
        out = c.c_int16(0)
        ok = self.lib.session_conditions_bsum_variable_word(bsum, len(bsum), index, c.byref(out))
        return (ok, out.value) if ok else (0, None)

    def test_bsum_variable_word_maps_table_index_to_the_copied_boot_chunk(self):
        # word index i is BSUM byte 2*i - 9618 (0x5b0113 - 0x5adb81 = 9618)
        bsum = bytearray(402)
        for offset, word in ((0, -2), (382, 300), (384, 180), (386, 1500), (388, 60), (400, -32768)):
            bsum[offset:offset + 2] = struct.pack("<h", word)
        bsum = bytes(bsum)
        self.assertEqual(self.bsum_word(bsum, 5000), (1, 300))
        self.assertEqual(self.bsum_word(bsum, 5001), (1, 180))
        self.assertEqual(self.bsum_word(bsum, 5002), (1, 1500))
        self.assertEqual(self.bsum_word(bsum, 5003), (1, 60))
        self.assertEqual(self.bsum_word(bsum, 4809), (1, -2))          # first byte of the chunk
        self.assertEqual(self.bsum_word(bsum, 5009), (1, -32768))      # last whole word
        for outside in (4808, 5010, 5100, 32767, -1, -32768):
            self.assertEqual(self.bsum_word(bsum, outside), (0, None), outside)
        self.assertEqual(self.lib.session_conditions_bsum_variable_word(None, 0, 5000, None), 0)

    def test_corpus_timer_thresholds_come_from_the_real_boot_bsum(self):
        if not self.BSUM_PATH.is_file():
            self.skipTest("work/analysis/hiff-resources/0053.bin (BOOT) not present")
        data = self.BSUM_PATH.read_bytes()
        at = data.find(b"BSUM")
        self.assertEqual(int.from_bytes(data[at + 4:at + 8], "big"), 402)
        bsum = data[at + 8:at + 8 + 402]
        self.assertEqual([self.bsum_word(bsum, i)[1] for i in range(5000, 5004)], [300, 180, 1500, 60])
        f = Fixture(self)
        f.variables = {i: self.bsum_word(bsum, i)[1] for i in range(5000, 5004)}
        before = f.tree([record(13, 1, 1, 0, (0, 0, 5000, 0))])
        after = f.tree([record(14, 1, 1, 0, (0, 0, 5000, 0))])
        # Review counterexample: timer 1 active, 120000 ms elapsed. The
        # threshold is 300 s = 300000 ms, so "not yet elapsed" (13) is true.
        f.fixture.put_timer(1, 1, 120000)
        self.assertEqual(f.evaluate(before)[:2], (OK, 1))
        self.assertEqual(f.evaluate(after)[:2], (OK, 0))
        for variable, seconds in ((5001, 180), (5002, 1500), (5003, 60)):
            for op, edge, expect in ((13, seconds * 1000, 1), (13, seconds * 1000 + 1, 0),
                                     (14, seconds * 1000, 0), (14, seconds * 1000 + 1, 1)):
                g = Fixture(self)
                g.variables = f.variables
                g.fixture.put_timer(1, 1, edge)
                got = g.evaluate(g.tree([record(op, 1, 1, 0, (0, 0, variable, 0))]))[:2]
                self.assertEqual(got, (OK, expect), (op, variable, edge))

    def test_unsourced_variable_word_blocks_the_timer_leaf_not_a_default(self):
        f = Fixture(self)
        f.variables = {5001: None}
        status, answer, _u, failure = f.evaluate(f.tree([record(13, 2, 1, 0, (0, 0, 5001, 0))]))
        self.assertEqual((status, answer, failure.opcode, failure.provider_status),
                         (ERR_HOST_UNAVAILABLE, 0, 13, 5001))

    # -- opcode 15 ----------------------------------------------------------
    def test_context_leaf_uses_the_host_context_word(self):
        f = Fixture(self)
        tree = f.tree([record(15, 0, 7)])
        f.context_value = 7
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        f.context_value = -7
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))

    def test_context_leaf_without_a_provider_is_host_unavailable(self):
        f = Fixture(self, with_context=False)
        status, answer, _u, failure = f.evaluate(f.tree([record(15, 0, 0)]))
        self.assertEqual((status, answer, failure.opcode), (ERR_HOST_UNAVAILABLE, 0, 15))
        f2 = Fixture(self)
        f2.context_status = HOST_UNAVAILABLE
        status = f2.evaluate(f2.tree([record(15, 0, 0)]))[0]
        self.assertEqual(status, ERR_HOST_UNAVAILABLE)

    def test_context_is_not_read_for_other_opcodes(self):
        f = Fixture(self)
        f.evaluate(f.tree([record(12, 0), record(21)]))
        self.assertEqual(f.context_calls, 0)

    # -- opcode 11 -----------------------------------------------------------
    def test_selected_item_leaf_modes_and_slot(self):
        f = Fixture(self)
        tree = f.tree([record(11, 5)])
        label = c.c_int32(0)
        # mode 0, item selected: true and the tree owns the slot.
        self.assertEqual(f.evaluate(tree, mode=0, selected=5)[:2], (OK, 1))
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, 5)
        # mode 0, another item selected: false and the slot clears (it was ours).
        self.assertEqual(f.evaluate(tree, mode=0, selected=2)[:2], (OK, 0))
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 0)
        # mode 1: true regardless, slot cleared.
        self.assertEqual(f.evaluate(tree, mode=0, selected=5)[:2], (OK, 1))
        self.assertEqual(f.evaluate(tree, mode=1, selected=2)[:2], (OK, 1))
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 0)

    def test_selected_item_slot_is_not_cleared_by_a_different_owner(self):
        f = Fixture(self)
        tree = f.tree([record(11, 5, 0, 1), record(11, 6)])   # adjacent 11s need an OR link
        label = c.c_int32(0)
        # Item 6 selected: the second leaf owns the slot; the first (miss)
        # must not clear it even though it runs before.
        self.assertEqual(f.evaluate(tree, selected=6)[:2], (OK, 1))   # OR-joined
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, 6)

    # -- opcode 17 -----------------------------------------------------------
    def test_sound_query_active_and_idle_channel(self):
        f = Fixture(self)
        want_playing = f.tree([record(17, 4, 1)])
        want_idle = f.tree([record(17, 4, 0)])
        f.channel.get_status_flags = 1
        self.assertEqual(f.evaluate(want_playing)[:2], (OK, 1))
        self.assertEqual(f.evaluate(want_idle)[:2], (OK, 0))
        self.assertEqual(f.manager(), (0, 0x3E8, 0))
        f.channel.get_status_flags = 0
        self.assertEqual(f.evaluate(want_playing)[:2], (OK, 0))
        self.assertEqual(f.evaluate(want_idle)[:2], (OK, 1))
        self.assertEqual(f.channel_calls, [4, 4, 4, 4])
        self.assertEqual(f.stats().sound_queries, 4)

    def test_sound_query_other_expected_values_are_false(self):
        f = Fixture(self)
        for expected in (2, -1, 7):
            self.assertEqual(f.evaluate(f.tree([record(17, 4, expected)]))[:2], (OK, 0))

    def test_sound_query_manager_mutations_follow_the_original(self):
        f = Fixture(self)
        tree = f.tree([record(17, 3, 0)])
        f.channel.device_ready_1a0 = 0
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        self.assertEqual(f.manager(), (0, 0x3EA, 0))
        f.channel.device_ready_1a0 = 1
        f.channel.resource_ready_162 = 0
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        self.assertEqual(f.manager(), (0, 0x3EF, 0))
        f.channel.resource_ready_162 = 1
        f.channel.buffer_available_28f = 0
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        f.channel.buffer_available_28f = 1
        f.channel.get_status_hresult = -2147467259
        f.channel.get_status_flags = 1
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        self.assertEqual(f.manager(), (0, 0x40A, -2147467259))

    def test_sound_query_repeat_marker_branch_uses_the_pause_gates(self):
        f = Fixture(self)
        tree = f.tree([record(17, 1, 1)])
        f.channel.repeat_marker_19e = 1
        f.channel.get_status_flags = 0           # ignored in this branch
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        f.channel.gate_16e = 1
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))
        f.channel.gate_16e, f.channel.gate_172 = 0, 5
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))

    def test_sound_query_unavailable_commits_nothing_and_never_defaults_false(self):
        f = Fixture(self)
        tree = f.tree([record(17, 4, 0)])            # would be TRUE if defaulted to idle
        f.channel_unavailable = True
        status, answer, _u, failure = f.evaluate(tree)
        self.assertEqual((status, answer, failure.opcode), (ERR_HOST_UNAVAILABLE, 0, 17))
        self.assertEqual(f.manager(), (0, 0, 0))
        f2 = Fixture(self, with_channel=False)
        self.assertEqual(f2.evaluate(f2.tree([record(17, 4, 0)]))[0], ERR_HOST_UNAVAILABLE)

    def test_sound_query_channel_outside_the_table_is_rejected(self):
        f = Fixture(self)
        for channel in (32, 33, 32767):
            status = f.evaluate(f.tree([record(17, channel, 1)]))[0]
            self.assertEqual(status, ERR_HOST_UNAVAILABLE, channel)
        self.assertEqual(f.evaluate(f.tree([record(17, -1, 1)]))[0], ERR_BOUNDS)
        self.assertEqual(f.channel_calls, [])

    def test_query_channel_record_helper_is_the_pure_decision(self):
        manager = Manager(9, 9, 9)
        rec = ChannelRecord(1, 1, 1, 0, 0, 0, 0, 1)
        self.assertEqual(self.lib.session_conditions_query_channel_record(
            c.byref(rec), c.byref(manager)), 1)
        self.assertEqual((manager.state_3be, manager.error_3c2, manager.host_result_3ca),
                         (9, 0x3E8, 0))
        self.assertEqual(self.lib.session_conditions_query_channel_record(None, None), 0)

    # -- opcode 20 -----------------------------------------------------------
    def test_random_leaf_draws_once_caches_and_rerolls_after_reset(self):
        f = Fixture(self)
        f.random_values = [12345, 777]
        tree = f.tree([record(20, 0, 46)])
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))            # 12345 % 100 = 45 < 46
        self.assertEqual(f.random_calls, 1)
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))            # cached: retained
        self.assertEqual(f.random_calls, 1)
        self.lib.scene_conditions_reset(tree)
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))            # 777 % 100 = 77 >= 46
        self.assertEqual(f.random_calls, 2)
        self.assertEqual(f.stats().random_draws, 2)

    def test_random_leaf_threshold_edges_and_sample_modulo(self):
        for raw, threshold, expected in ((0, 1, 1), (99, 100, 1), (99, 99, 0),
                                         (32767, 68, 1), (32767, 67, 0), (32767, 100, 1),
                                         (100, 1, 1), (4242, 43, 1), (4242, 42, 0)):
            f = Fixture(self)
            f.random_values = [raw]
            self.assertEqual(f.evaluate(f.tree([record(20, 0, threshold)]))[:2],
                             (OK, expected), (raw, threshold))

    def test_random_source_unavailable_or_out_of_range_never_invents_a_sample(self):
        f = Fixture(self, with_random=False)
        self.assertEqual(f.evaluate(f.tree([record(20, 0, 50)]))[0], ERR_HOST_UNAVAILABLE)
        f = Fixture(self)
        f.random_status = HOST_UNAVAILABLE
        tree = f.tree([record(20, 0, 50)])
        self.assertEqual(f.evaluate(tree)[0], ERR_HOST_UNAVAILABLE)
        f.random_status = HOST_OK
        f.random_values = [10]
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))            # nothing was cached
        f = Fixture(self)
        f.random_values = [32768]
        status, _a, _u, failure = f.evaluate(f.tree([record(20, 0, 50)]))
        self.assertEqual((status, failure.provider_status), (ERR_PROVIDER, EXTRA_ERR_HOST_FAILURE))

    def test_random_condition_outside_one_to_hundred_is_a_debug_stop_only_when_enabled(self):
        for condition in (0, 101, -5):
            f = Fixture(self, debug=0)
            f.random_values = [10]
            self.assertEqual(f.evaluate(f.tree([record(20, 0, condition)]))[0], OK)
            f = Fixture(self, debug=1)
            f.random_values = [10]
            status, _a, _u, failure = f.evaluate(f.tree([record(20, 0, condition)]))
            self.assertEqual((status, failure.provider_status), (ERR_PROVIDER, EXTRA_ERR_DEBUG_FATAL))

    def test_random_leaf_keeps_its_retained_status_through_or_reduction(self):
        # (A OR R): once R is cached true, a later tick with A false stays true
        # even though R is not re-rolled.
        f = Fixture(self)
        f.random_values = [10]
        tree = f.tree([record(12, 1, 0, 1), record(20, 0, 50)])
        f.fixture.clock.outside_window_flag_5bb20a = 0
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        self.assertEqual(f.random_calls, 1)

    # -- opcode 21 and the 0x5c3a47 global -------------------------------------
    def test_pass_start_sets_the_global_and_every_tree_stores_root_equals_zero(self):
        f = Fixture(self)
        self.assertEqual(f.global_5c3a47(), 0)
        f.pass_started()
        self.assertEqual(f.global_5c3a47(), 1)
        true_tree = f.tree([record(12, 0)])
        false_tree = f.tree([record(12, 1)])
        f.fixture.clock.outside_window_flag_5bb20a = 0
        f.evaluate(true_tree)
        self.assertEqual(f.global_5c3a47(), 0)
        f.evaluate(false_tree)
        self.assertEqual(f.global_5c3a47(), 1)
        f.evaluate(f.tree([]))                 # empty tree: root 1 -> store 0
        self.assertEqual(f.global_5c3a47(), 0)
        self.assertEqual((f.stats().passes_started, f.stats().trees_evaluated), (1, 3))

    def test_prior_gate_leaf_reads_the_previous_rows_result(self):
        f = Fixture(self)
        gate = f.tree([record(21)])
        f.fixture.clock.outside_window_flag_5bb20a = 0
        f.pass_started()                      # global := 1
        self.assertEqual(f.evaluate(gate)[:2], (OK, 1))
        # The wrapper stored (root == 0) = 0 after that true tree.
        self.assertEqual(f.global_5c3a47(), 0)
        self.assertEqual(f.evaluate(gate)[:2], (OK, 0))     # reads 0 -> false
        self.assertEqual(f.global_5c3a47(), 1)               # false tree stored 1
        self.assertEqual(f.evaluate(gate)[:2], (OK, 1))

    def test_global_is_not_stored_when_a_tree_fails(self):
        f = Fixture(self, with_channel=False)
        f.pass_started()
        status = f.evaluate(f.tree([record(17, 1, 1)]))[0]
        self.assertEqual(status, ERR_HOST_UNAVAILABLE)
        self.assertEqual(f.global_5c3a47(), 1)
        self.assertEqual(f.stats().trees_evaluated, 0)

    def test_set_global_for_tests_and_new_game_state(self):
        f = Fixture(self)
        self.lib.session_conditions_set_global_5c3a47(f.binding, -9)
        self.assertEqual(f.global_5c3a47(), -9)
        self.assertEqual(f.evaluate(f.tree([record(21)]))[:2], (OK, 1))

    # -- unsupported opcodes ---------------------------------------------------
    def test_opcodes_without_a_recovered_leaf_stay_unsupported(self):
        f = Fixture(self)
        for opcode in (7, 8, 10, 16, 22, 23, 100):   # 18/19 are the group markers
            status, answer, unsupported, failure = f.evaluate(f.tree([record(opcode)]))
            self.assertEqual((status, answer, unsupported, failure.opcode),
                             (ERR_UNSUPPORTED, 0, opcode, opcode), opcode)
        self.assertEqual(f.evaluate(f.tree([record(3, 0, 0)]))[0], ERR_BOUNDS)

    # -- whole trees -------------------------------------------------------------
    def test_nested_tree_mixes_builtin_and_extension_leaves_in_source_order(self):
        f = Fixture(self)
        f.random_values = [10]
        f.context_value = 3
        records = [record(12, 0), record(0x12), record(15, 0, 3, 1),
                   record(20, 0, 50), record(0x13), record(21)]
        tree = f.tree(records)
        f.fixture.clock.outside_window_flag_5bb20a = 0
        f.pass_started()
        self.assertEqual(f.evaluate(tree)[:2], (OK, 1))
        f.context_value = 4                  # inner group (15 OR 20): 20 is cached true
        self.lib.scene_conditions_reset(tree)
        f.random_values = [90]
        self.assertEqual(f.evaluate(tree)[:2], (OK, 0))
        self.assertEqual(f.random_calls, 2)

    # -- CRT rand --------------------------------------------------------------
    def test_crt_rand_matches_the_msvc_sequence_for_seed_one(self):
        g = CrtRand()
        self.lib.session_conditions_crt_rand_init(c.byref(g))
        self.assertEqual(g.holdrand, 1)
        values = [self.lib.session_conditions_crt_rand(c.byref(g)) for _ in range(10)]
        self.assertEqual(values, [41, 18467, 6334, 26500, 19169, 15724, 11478,
                                  29358, 26962, 24464])

    def test_crt_rand_follows_the_original_lcg_for_other_seeds(self):
        for seed in (0, 1, 12345, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 1_700_000_000):
            g = CrtRand()
            self.lib.session_conditions_crt_srand(c.byref(g), seed)
            reference = msvc_rand_reference(seed)
            for _ in range(64):
                value = self.lib.session_conditions_crt_rand(c.byref(g))
                self.assertEqual(value, next(reference))
                self.assertLessEqual(value, 32767)

    def test_crt_rand_host_callback_and_null_checks(self):
        g = CrtRand()
        self.lib.session_conditions_crt_srand(c.byref(g), 1)
        out = c.c_uint32(0)
        self.assertEqual(self.lib.session_conditions_crt_rand_host(c.byref(g), c.byref(out)), HOST_OK)
        self.assertEqual(out.value, 41)
        self.assertEqual(self.lib.session_conditions_crt_rand_host(None, c.byref(out)), HOST_UNAVAILABLE)
        self.assertEqual(self.lib.session_conditions_crt_rand_host(c.byref(g), None), HOST_UNAVAILABLE)

    def test_status_strings(self):
        self.assertEqual(self.lib.session_conditions_status_string(0), b"ok")
        self.assertNotEqual(self.lib.session_conditions_status_string(99), b"")


if __name__ == "__main__":
    unittest.main()
