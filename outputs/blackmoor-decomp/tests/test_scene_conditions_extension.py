"""RT-4 tree-level tests for the extension-leaf hook in scene_conditions.

The fake provider here stands in for condition_extra so the tree mechanics can
be pinned independently of the leaf kernel: source-order delivery, preset and
retained status, per-node sidecars and their reset, the opcode-11 slot, the
evaluation mode, the post-tree notification, and failure reporting. Build with
scripts/build_scene_conditions.sh first.
"""
from __future__ import annotations

import ctypes as c
import os
from pathlib import Path
import unittest


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


class LeafRuntime(c.Structure):
    _fields_ = [
        ("runtime_threshold_20", c.c_int32),
        ("random_cache_valid_2c", c.c_uint32),
        ("random_sample_30", c.c_int32),
    ]


class LeafRequest(c.Structure):
    _fields_ = [
        ("record", SceneDependencyInfo),
        ("record_index", c.c_size_t),
        ("leaf_identity", c.c_void_p),
        ("runtime", c.POINTER(LeafRuntime)),
        ("selected_leaf_slot", c.POINTER(c.c_void_p)),
        ("state", c.POINTER(SceneConditionState)),
        ("evaluation_mode", c.c_int32),
    ]


LeafFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(LeafRequest),
                     c.POINTER(c.c_int32), c.POINTER(c.c_int))
PassFn = c.CFUNCTYPE(None, c.c_void_p)
TreeFn = c.CFUNCTYPE(None, c.c_void_p, c.c_int32)
VarFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int16))


class Extension(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("evaluate_leaf", LeafFn),
        ("pass_started", PassFn),
        ("tree_evaluated", TreeFn),
        ("read_variable_word", VarFn),
    ]


class Failure(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("reserved", c.c_uint16),
        ("record_index", c.c_size_t),
        ("provider_status", c.c_int),
    ]


def signed32(value):
    value &= 0xFFFFFFFF
    return value - (1 << 32) if value & 0x80000000 else value


OK, ERR_ARGUMENT, ERR_MEMORY, ERR_FORMAT, ERR_LIMIT, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
ERR_UNSUPPORTED, ERR_HOST_UNAVAILABLE, ERR_PROVIDER = 6, 7, 8


def record(opcode, index=0, condition=0, or_after=0, rest=(0, 0, 0, 0)):
    value = SceneDependencyInfo()
    value.opcode = opcode & 0xFFFF
    value.or_after = or_after
    value.fields[:] = [opcode, index, condition, or_after, *rest]
    return value


class ExtensionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # SCENE_CONDITIONS_LIBRARY lets the mutation checks aim this suite at a
        # library built from altered sources.
        path = Path(os.environ.get("SCENE_CONDITIONS_LIBRARY") or
                    Path(__file__).resolve().parents[1] / "build/libsceneconditions.dylib")
        if not path.is_file():
            raise unittest.SkipTest("Build scene conditions with scripts/build_scene_conditions.sh first")
        lib = c.CDLL(str(path))
        lib.scene_conditions_build.argtypes = [
            c.POINTER(SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)]
        lib.scene_conditions_build.restype = c.c_int
        lib.scene_conditions_destroy.argtypes = [c.c_void_p]
        lib.scene_conditions_reset.argtypes = [c.c_void_p]
        lib.scene_conditions_reset_traversal.argtypes = [c.c_void_p]
        lib.scene_conditions_evaluate_ex.argtypes = [
            c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(Extension),
            c.c_int32, c.POINTER(c.c_int), c.POINTER(c.c_uint16),
            c.POINTER(Failure)]
        lib.scene_conditions_evaluate_ex.restype = c.c_int
        lib.scene_conditions_gate_mode_for_type.argtypes = [c.c_uint8]
        lib.scene_conditions_gate_mode_for_type.restype = c.c_int32
        lib.scene_conditions_selected_item_label.argtypes = [
            c.c_void_p, c.POINTER(c.c_int32)]
        lib.scene_conditions_selected_item_label.restype = c.c_int
        cls.lib = lib

    def setUp(self):
        self.calls = []
        self.tree_notices = []
        self.pass_notices = 0
        self._keep = []
        self.variable_reads = []

    def build(self, records):
        tree = c.c_void_p()
        if records:
            array = (SceneDependencyInfo * len(records))(*records)
            status = self.lib.scene_conditions_build(array, len(records), c.byref(tree))
        else:
            status = self.lib.scene_conditions_build(None, 0, c.byref(tree))
        self.assertEqual(status, OK)
        self.addCleanup(self.lib.scene_conditions_destroy, tree)
        return tree

    def extension(self, behaviour):
        """behaviour(request, snapshot) -> (return_code, status or None, provider_status)."""
        def leaf(_ctx, request, status_out, provider_status):
            req = request.contents
            snapshot = {
                "opcode": req.record.opcode,
                "fields": list(req.record.fields),
                "record_index": req.record_index,
                "identity": req.leaf_identity,
                "runtime": c.addressof(req.runtime.contents),
                "slot": c.addressof(req.selected_leaf_slot.contents),
                "mode": req.evaluation_mode,
                "preset": status_out[0],
                "selected": req.state.contents.selected_inventory_item,
                "threshold": req.runtime.contents.runtime_threshold_20,
                "valid": req.runtime.contents.random_cache_valid_2c,
                "sample": req.runtime.contents.random_sample_30,
            }
            self.calls.append(snapshot)
            code, status, detail = behaviour(req, snapshot)
            if status is not None:
                status_out[0] = status
            if provider_status:
                provider_status[0] = detail
            return code

        def tree_notice(_ctx, root):
            self.tree_notices.append(root)

        def pass_notice(_ctx):
            self.pass_notices += 1

        ext = Extension()
        ext.context = None
        ext.evaluate_leaf = LeafFn(leaf)
        ext.pass_started = PassFn(pass_notice)
        ext.tree_evaluated = TreeFn(tree_notice)
        self._keep.append(ext)
        return ext

    def with_variables(self, ext, table):
        """Attach a 0x5adb81-table provider; table maps index -> word or None."""
        def read(_ctx, index, out):
            self.variable_reads.append(index)
            if table.get(index) is None:
                return 0
            out[0] = table[index]
            return 1
        ext.read_variable_word = VarFn(read)
        self._keep.append(ext.read_variable_word)
        return ext

    def state(self, selected=-1, flags=()):
        flag_array = (c.c_int32 * max(1, len(flags)))(*flags)
        self._keep.append(flag_array)
        state = SceneConditionState()
        state.selected_inventory_item = selected
        state.event_flags = flag_array
        state.event_flag_count = len(flags)
        return state

    def evaluate(self, tree, ext, mode=0, state=None):
        answer = c.c_int(-9)
        unsupported = c.c_uint16(0xFFFF)
        failure = Failure()
        state = state if state is not None else self.state()
        status = self.lib.scene_conditions_evaluate_ex(
            tree, c.byref(state), c.byref(ext) if ext is not None else None,
            mode, c.byref(answer), c.byref(unsupported), c.byref(failure))
        return status, answer.value, unsupported.value, failure

    # -- extension absent -------------------------------------------------
    def test_without_extension_extra_opcode_is_unsupported(self):
        tree = self.build([record(17, 4, 1)])
        status, answer, unsupported, _failure = self.evaluate(tree, None)
        self.assertEqual((status, answer, unsupported), (ERR_UNSUPPORTED, 0, 17))

    def test_builtin_opcodes_never_reach_the_extension(self):
        tree = self.build([record(0), record(2, 0, 1)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        status, answer, _u, _f = self.evaluate(tree, ext, state=self.state(flags=(1,)))
        self.assertEqual((status, answer), (OK, 1))
        self.assertEqual(self.calls, [])

    # -- delivery ---------------------------------------------------------
    def test_leaves_arrive_in_source_order_with_record_positions(self):
        records = [record(0x12), record(11, 5, 0, 0), record(17, 4, 1),
                   record(0x13), record(20, 0, 30), record(21)]
        tree = self.build(records)
        ext = self.extension(lambda r, s: (OK, 1, 0))
        status, answer, _u, _f = self.evaluate(tree, ext, mode=1)
        self.assertEqual((status, answer), (OK, 1))
        self.assertEqual([(x["opcode"], x["record_index"]) for x in self.calls],
                         [(11, 1), (17, 2), (20, 4), (21, 5)])
        self.assertEqual({x["mode"] for x in self.calls}, {1})
        self.assertEqual(self.calls[1]["fields"][:3], [17, 4, 1])
        self.assertEqual(len({x["identity"] for x in self.calls}), 4)
        self.assertEqual(len({x["runtime"] for x in self.calls}), 4)
        self.assertEqual(len({x["slot"] for x in self.calls}), 1)

    def test_state_is_the_callers_state_and_sidecar_starts_zeroed(self):
        tree = self.build([record(13, 0)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        self.evaluate(tree, ext, state=self.state(selected=77))
        call = self.calls[0]
        self.assertEqual((call["selected"], call["threshold"], call["valid"], call["sample"]),
                         (77, 0, 0, 0))
        self.assertEqual(call["preset"], 0)

    def test_each_tree_has_its_own_slot_and_sidecars(self):
        first = self.build([record(11, 1)])
        second = self.build([record(11, 1)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        self.evaluate(first, ext)
        self.evaluate(second, ext)
        self.assertNotEqual(self.calls[0]["slot"], self.calls[1]["slot"])
        self.assertNotEqual(self.calls[0]["runtime"], self.calls[1]["runtime"])

    def test_evaluation_mode_is_passed_per_call(self):
        tree = self.build([record(11, 1)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        self.evaluate(tree, ext, mode=0)
        self.evaluate(tree, ext, mode=1)
        self.assertEqual([x["mode"] for x in self.calls], [0, 1])

    # -- status, reduction -----------------------------------------------
    def test_leaf_status_feeds_and_or_reduction_with_nested_groups(self):
        # A AND (B OR C) AND D with B,C,D extension leaves.
        records = [record(2, 0, 1), record(0x12), record(17, 1, 1, 1),
                   record(17, 2, 1), record(0x13), record(17, 3, 1)]
        state = self.state(flags=(1,))
        for b in (0, 1):
            for cc in (0, 1):
                for d in (0, 1):
                    self.calls.clear()
                    tree = self.build(records)
                    table = {1: b, 2: cc, 3: d}
                    ext = self.extension(
                        lambda r, s, table=table: (OK, table[r.record.fields[1]], 0))
                    status, answer, _u, _f = self.evaluate(tree, ext, state=state)
                    self.assertEqual(status, OK)
                    self.assertEqual(answer, int((b or cc) and d), (b, cc, d))
                    self.assertEqual(len(self.calls), 3)

    def test_or_after_joins_extension_leaves_at_one_only(self):
        for marker, expected in ((1, 1), (0, 0), (2, 0), (-1, 0)):
            tree = self.build([record(17, 1, 1, marker), record(17, 2, 1)])
            ext = self.extension(
                lambda r, s: (OK, 1 if r.record.fields[1] == 2 else 0, 0))
            status, answer, _u, _f = self.evaluate(tree, ext)
            self.assertEqual((status, answer), (OK, expected), marker)

    def test_status_left_untouched_is_the_retained_status(self):
        tree = self.build([record(20, 0, 50)])
        phase = {"n": 0}

        def behaviour(req, snap):
            phase["n"] += 1
            return (OK, 1, 0) if phase["n"] == 1 else (OK, None, 0)

        ext = self.extension(behaviour)
        self.assertEqual(self.evaluate(tree, ext)[:2], (OK, 1))
        self.assertEqual(self.evaluate(tree, ext)[:2], (OK, 1))
        self.assertEqual([x["preset"] for x in self.calls], [0, 1])

    # -- sidecar persistence and reset -------------------------------------
    def test_sidecar_persists_across_evaluations_and_reset_clears_only_valid(self):
        tree = self.build([record(20, 0, 50)])

        def behaviour(req, snap):
            rt = req.runtime.contents
            rt.runtime_threshold_20 = 1234
            rt.random_cache_valid_2c = 1
            rt.random_sample_30 = 45
            return OK, 1, 0

        ext = self.extension(behaviour)
        self.evaluate(tree, ext)
        self.evaluate(tree, ext)
        self.assertEqual((self.calls[1]["threshold"], self.calls[1]["valid"],
                          self.calls[1]["sample"]), (1234, 1, 45))
        self.lib.scene_conditions_reset(tree)
        self.evaluate(tree, ext)
        self.assertEqual((self.calls[2]["threshold"], self.calls[2]["valid"],
                          self.calls[2]["sample"]), (1234, 0, 45))
        self.assertEqual(self.calls[2]["preset"], 0)

    def test_reset_traversal_0x423da2_zeroes_node_status_and_leaf_valid_flag(self):
        """scene_conditions_reset_traversal (0x423da2): status and +0x2c cleared, threshold and sample kept."""
        tree = self.build([record(20, 0, 50)])

        def behaviour(req, snap):
            rt = req.runtime.contents
            rt.runtime_threshold_20 = 1234
            rt.random_cache_valid_2c = 1
            rt.random_sample_30 = 45
            return OK, 1, 0

        ext = self.extension(behaviour)
        self.evaluate(tree, ext)
        self.evaluate(tree, ext)
        self.assertEqual((self.calls[1]["preset"], self.calls[1]["valid"]), (1, 1))
        self.lib.scene_conditions_reset_traversal(tree)
        self.evaluate(tree, ext)
        self.assertEqual((self.calls[2]["preset"], self.calls[2]["valid"], self.calls[2]["threshold"],
                          self.calls[2]["sample"]), (0, 0, 1234, 45))
        self.lib.scene_conditions_reset_traversal(None)

    def test_reset_entry_0x423d33_with_and_without_records(self):
        """scene_conditions_reset (0x423d33): records present -> traversal; no records -> root status 1 only."""
        tree = self.build([record(20, 0, 50)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        self.evaluate(tree, ext)
        self.lib.scene_conditions_reset(tree)
        self.evaluate(tree, ext)
        self.assertEqual(self.calls[1]["preset"], 0)
        empty = self.build([])
        self.lib.scene_conditions_reset(empty)
        self.assertEqual(self.evaluate(empty, None)[:2], (OK, 1))
        self.lib.scene_conditions_reset(None)

    def test_reset_preserves_the_selected_item_slot(self):
        tree = self.build([record(11, 9)])

        def behaviour(req, snap):
            req.selected_leaf_slot[0] = req.leaf_identity
            return OK, 1, 0

        label = c.c_int32(-5)
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 0)
        self.assertEqual(label.value, -1)
        self.evaluate(tree, self.extension(behaviour))
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, 9)
        self.lib.scene_conditions_reset(tree)
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, 9)

    def test_selected_item_label_is_signed_word(self):
        tree = self.build([record(11, -3)])

        def behaviour(req, snap):
            req.selected_leaf_slot[0] = req.leaf_identity
            return OK, 1, 0

        self.evaluate(tree, self.extension(behaviour))
        label = c.c_int32(0)
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, -3)

    # -- post-tree notification -------------------------------------------
    def test_tree_evaluated_reports_root_status_for_true_and_false_trees(self):
        tree = self.build([record(17, 1, 1)])
        self.evaluate(tree, self.extension(lambda r, s: (OK, 1, 0)))
        self.evaluate(tree, self.extension(lambda r, s: (OK, 0, 0)))
        self.assertEqual(self.tree_notices, [1, 0])

    def test_empty_tree_notifies_with_status_one_and_needs_no_state(self):
        tree = self.build([])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        answer = c.c_int(-9)
        status = self.lib.scene_conditions_evaluate_ex(
            tree, None, c.byref(ext), 0, c.byref(answer), None, None)
        self.assertEqual((status, answer.value), (OK, 1))
        self.assertEqual(self.tree_notices, [1])
        self.assertEqual(self.calls, [])

    def test_failed_evaluation_does_not_notify(self):
        tree = self.build([record(17, 1, 1)])
        self.evaluate(tree, self.extension(lambda r, s: (ERR_HOST_UNAVAILABLE, None, 0)))
        self.assertEqual(self.tree_notices, [])

    def test_missing_optional_callbacks_are_allowed(self):
        tree = self.build([record(17, 1, 1)])
        ext = self.extension(lambda r, s: (OK, 1, 0))
        ext.tree_evaluated = TreeFn()
        ext.pass_started = PassFn()
        self.assertEqual(self.evaluate(tree, ext)[:2], (OK, 1))

    def test_extension_without_leaf_callback_leaves_opcodes_unsupported(self):
        tree = self.build([record(17, 1, 1)])
        ext = Extension()
        status, _answer, unsupported, _f = self.evaluate(tree, ext)
        self.assertEqual((status, unsupported), (ERR_UNSUPPORTED, 17))

    # -- failures ---------------------------------------------------------
    def test_host_unavailable_stops_in_order_and_reports_the_record(self):
        records = [record(2, 0, 1), record(0x12), record(11, 1), record(17, 4, 1),
                   record(20, 0, 50), record(0x13)]
        tree = self.build(records)

        def behaviour(req, snap):
            if req.record.opcode == 17:
                return ERR_HOST_UNAVAILABLE, None, 77
            return OK, 1, 0

        status, answer, _u, failure = self.evaluate(
            tree, self.extension(behaviour), state=self.state(flags=(1,)))
        self.assertEqual((status, answer), (ERR_HOST_UNAVAILABLE, 0))
        self.assertEqual([x["opcode"] for x in self.calls], [11, 17])
        self.assertEqual((failure.opcode, failure.record_index, failure.provider_status),
                         (17, 3, 77))

    def test_provider_failure_and_unsupported_report_through_failure_record(self):
        tree = self.build([record(20, 0, 50)])
        status, _a, _u, failure = self.evaluate(
            tree, self.extension(lambda r, s: (ERR_PROVIDER, None, 6)))
        self.assertEqual((status, failure.opcode, failure.provider_status), (ERR_PROVIDER, 20, 6))
        tree = self.build([record(16, 0, 0)])
        status, _a, unsupported, failure = self.evaluate(
            tree, self.extension(lambda r, s: (ERR_UNSUPPORTED, None, 0)))
        self.assertEqual((status, unsupported, failure.opcode), (ERR_UNSUPPORTED, 16, 16))

    def test_failure_is_zeroed_on_success(self):
        tree = self.build([record(17, 1, 1)])
        status, _a, _u, failure = self.evaluate(
            tree, self.extension(lambda r, s: (OK, 1, 0)))
        self.assertEqual((status, failure.opcode, failure.record_index,
                          failure.provider_status), (OK, 0, 0, 0))

    def test_partial_effects_before_a_failure_remain_visible(self):
        tree = self.build([record(11, 3), record(17, 4, 1)])

        def behaviour(req, snap):
            if req.record.opcode == 11:
                req.selected_leaf_slot[0] = req.leaf_identity
                return OK, 1, 0
            return ERR_HOST_UNAVAILABLE, None, 0

        self.evaluate(tree, self.extension(behaviour))
        label = c.c_int32(0)
        self.assertEqual(self.lib.scene_conditions_selected_item_label(tree, c.byref(label)), 1)
        self.assertEqual(label.value, 3)

    # -- loader threshold (dword +0x20) and preflight -------------------------
    def test_loader_threshold_is_baked_for_every_leaf_except_opcodes_6_and_9(self):
        wrapped = (0x7FFF, 0x7FFF, 0x7FFF, -1)
        for opcode, rest, expected in (
            (13, (1, 2, 3, 4), 3_723_004),
            (14, (-1, 0, 0, 0), -3_600_000),
            (20, (0, 1, 0, 5), 60_005),
            (17, (0, 0, 4999, 0), 4_999_000),
            (21, wrapped, signed32(0x7FFF * 3_600_000 + 0x7FFF * 60_000 + 0x7FFF * 1000 - 1)),
        ):
            tree = self.build([record(opcode, 0, 0, 0, rest)])
            self.evaluate(tree, self.extension(lambda r, s: (OK, 1, 0)))
            self.assertEqual(self.calls[-1]["threshold"], expected, (opcode, rest))
        self.assertEqual(self.variable_reads, [])

    def test_timer_leaf_with_a_variable_seconds_index_reads_the_table_once_at_arming(self):
        tree = self.build([record(13, 2, 1, 0, (1, 2, 5001, 7)), record(14, 3, 1, 0, (0, 0, 5000, 0))])
        ext = self.with_variables(self.extension(lambda r, s: (OK, 1, 0)), {5001: 30, 5000: -2})
        self.assertEqual(self.variable_reads, [])           # not at build
        self.evaluate(tree, ext)
        self.evaluate(tree, ext)
        self.assertEqual(self.variable_reads, [5001, 5000])  # once per leaf
        self.assertEqual([x["threshold"] for x in self.calls[:2]],
                         [1 * 3_600_000 + 2 * 60_000 + 30 * 1000 + 7, -2000])

    def test_variable_word_is_a_signed_word_and_index_below_5000_is_direct(self):
        tree = self.build([record(13, 0, 1, 0, (0, 0, 4999, 0))])
        ext = self.with_variables(self.extension(lambda r, s: (OK, 1, 0)), {})
        self.evaluate(tree, ext)
        self.assertEqual((self.calls[0]["threshold"], self.variable_reads), (4_999_000, []))
        tree = self.build([record(13, 0, 1, 0, (0, 0, 32767, 0))])
        ext = self.with_variables(self.extension(lambda r, s: (OK, 1, 0)), {32767: -32768})
        self.evaluate(tree, ext)
        self.assertEqual(self.calls[1]["threshold"], -32_768_000)

    def test_unsourced_variable_word_makes_only_that_leaf_host_unavailable(self):
        tree = self.build([record(17, 1, 1), record(13, 2, 1, 0, (0, 0, 5002, 0))])
        ext = self.with_variables(self.extension(lambda r, s: (OK, 1, 0)), {5002: None})
        status, _a, _u, failure = self.evaluate(tree, ext)
        self.assertEqual((status, failure.opcode, failure.record_index, failure.provider_status),
                         (ERR_HOST_UNAVAILABLE, 13, 1, 5002))
        self.assertEqual([x["opcode"] for x in self.calls], [17])   # the leaf kernel never ran
        # No provider at all behaves the same.
        tree = self.build([record(14, 2, 1, 0, (0, 0, 5000, 0))])
        self.assertEqual(self.evaluate(tree, self.extension(lambda r, s: (OK, 1, 0)))[0],
                         ERR_HOST_UNAVAILABLE)

    def test_resolution_is_idempotent_and_only_armed_by_an_extension(self):
        tree = self.build([record(13, 2, 1, 0, (0, 0, 5001, 0))])
        self.evaluate(tree, None)                                   # unsupported, no arming
        self.assertEqual(self.variable_reads, [])
        ext = self.with_variables(self.extension(lambda r, s: (OK, 1, 0)), {5001: 4})
        self.evaluate(tree, ext)
        self.assertEqual(self.calls[-1]["threshold"], 4000)

    def test_adjacent_selected_item_leaves_need_an_or_marker(self):
        for marker, accepted in ((0, False), (1, True), (2, True), (-1, True)):
            tree = c.c_void_p()
            array = (SceneDependencyInfo * 2)(record(11, 1, 0, marker), record(11, 2))
            status = self.lib.scene_conditions_build(array, 2, c.byref(tree))
            self.assertEqual(status, OK if accepted else ERR_FORMAT, marker)
            if tree.value:
                self.lib.scene_conditions_destroy(tree)
        # Only *adjacent* records are checked.
        self.build([record(11, 1), record(12, 0), record(11, 2)])
        self.build([record(11, 1), record(2, 0, 1), record(11, 2)])

    # -- gate mode table --------------------------------------------------
    def test_gate_mode_table_matches_the_mode_one_call_sites(self):
        mode_one = {0x0B, 0x0D, 0x16, 0x1A, 0x1B, 0x1C, 0x33, 0x34, 0x36, 0x4D,
                    0x4E, 0x4F, 0x62, 0x63, 0x6A, 0x7A, 0x99}
        for runtime_type in range(256):
            self.assertEqual(self.lib.scene_conditions_gate_mode_for_type(runtime_type),
                             1 if runtime_type in mode_one else 0, hex(runtime_type))

    # -- argument checks --------------------------------------------------
    def test_null_arguments_are_rejected(self):
        tree = self.build([record(17, 1, 1)])
        answer = c.c_int(0)
        self.assertEqual(self.lib.scene_conditions_evaluate_ex(
            None, None, None, 0, c.byref(answer), None, None), ERR_ARGUMENT)
        self.assertEqual(self.lib.scene_conditions_evaluate_ex(
            tree, None, None, 0, None, None, None), ERR_ARGUMENT)
        self.assertEqual(self.lib.scene_conditions_evaluate_ex(
            tree, None, None, 0, c.byref(answer), None, None), ERR_ARGUMENT)
        self.assertEqual(self.lib.scene_conditions_selected_item_label(None, None), 0)


if __name__ == "__main__":
    unittest.main()
