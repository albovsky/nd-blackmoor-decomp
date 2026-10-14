"""RT-4: dependency-leaf extension wired into the scene executor.

Uses the shared helpers of test_scene_executor with a fake extension, so the
executor-owned parts are pinned without the leaf kernel: the gate mode per
runtime type (mode 1 for the 17 types of the 16 call sites, mode 0 for the
hotspot candidate check), the per-pass reset notification before the first
row, one post-tree notification per evaluated row (including empty trees and
excluding completed rows), failure mapping and the reset of the opcode-20
sidecar by dependency reset.
"""
from __future__ import annotations

import ctypes as c
import os
from pathlib import Path
import unittest
from unittest import mock

import test_scene_executor as base
import test_scene_conditions_extension as ext_base

LeafFn, PassFn, TreeFn = ext_base.LeafFn, ext_base.PassFn, ext_base.TreeFn
Extension, Failure = ext_base.Extension, ext_base.Failure

i16, action, condition = base.i16, base.action, base.condition
OK, ERR_UNSUPPORTED = 0, 6
ERR_CONDITION = 5
COND_HOST_UNAVAILABLE, COND_PROVIDER = 7, 8


class ExecutorExtensionTests(unittest.TestCase):
    open_scene = base.SceneExecutorTests.open_scene
    world = base.SceneExecutorTests.world
    condition_state = staticmethod(base.SceneExecutorTests.condition_state)
    create_executor = base.SceneExecutorTests.create_executor
    step = base.SceneExecutorTests.step
    step_frame = base.SceneExecutorTests.step_frame
    action_state = base.SceneExecutorTests.action_state
    frame = staticmethod(base.SceneExecutorTests.frame)

    @classmethod
    def setUpClass(cls):
        # RT4_EXECUTOR_LIBRARY aims this suite at a library built from altered sources
        # (mutation checks): skip the build step and load that file instead.
        override = os.environ.get("RT4_EXECUTOR_LIBRARY")
        if override:
            with mock.patch.object(base, "LIBRARY", Path(override)), \
                    mock.patch.object(base.subprocess, "run"):
                base.SceneExecutorTests.setUpClass.__func__(cls)
        else:
            base.SceneExecutorTests.setUpClass.__func__(cls)
        cls.lib.scene_executor_set_condition_extension.argtypes = [
            c.c_void_p, c.POINTER(Extension)]
        cls.lib.scene_executor_set_condition_extension.restype = c.c_int
        cls.lib.scene_executor_get_condition_failure.argtypes = [
            c.c_void_p, c.POINTER(Failure)]
        cls.lib.scene_executor_get_condition_failure.restype = c.c_int
        cls.lib.scene_executor_get_selected_item_label.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(c.c_int32)]
        cls.lib.scene_executor_get_selected_item_label.restype = c.c_int
        cls.lib.scene_executor_get_candidate_decision.argtypes = [
            c.c_void_p, c.c_void_p]
        cls.lib.scene_executor_get_candidate_decision.restype = c.c_int

    def setUp(self):
        self.events = []
        self._keep = []

    def make_extension(self, behaviour=None):
        def leaf(_ctx, request, status_out, provider_status):
            req = request.contents
            self.events.append(("leaf", req.record.opcode, req.evaluation_mode,
                                req.runtime.contents.random_cache_valid_2c))
            if behaviour is None:
                status_out[0] = 1
                return 0
            code, status, detail = behaviour(req)
            if status is not None:
                status_out[0] = status
            provider_status[0] = detail
            return code

        ext = Extension()
        ext.evaluate_leaf = LeafFn(leaf)
        ext.pass_started = PassFn(lambda _c: self.events.append(("pass",)))
        ext.tree_evaluated = TreeFn(lambda _c, root: self.events.append(("tree", root)))
        self._keep.append(ext)
        return ext

    def register(self, executor, ext):
        self.assertEqual(self.lib.scene_executor_set_condition_extension(
            executor, c.byref(ext)), OK)

    def setup_executor(self, actions, flags=None):
        scene, storage = self.open_scene(actions)
        world, flag_array = self.world(flags)
        status, executor, _ = self.create_executor(scene, world)
        self.assertEqual(status, OK)
        self.addCleanup(self.lib.scene_resource_close, scene)
        self.addCleanup(self.lib.scene_executor_destroy, executor)
        self._keep.extend([storage, flag_array, world])
        return executor, world, flag_array

    # ---------------------------------------------------------------------
    def test_extension_opcode_is_unsupported_without_an_extension(self):
        executor, world, _ = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(17, 4, 1),))])
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.detail_status, info.failed_action_type),
                         (ERR_UNSUPPORTED, 6, 0x71))

    def test_extension_leaf_gates_the_row_and_pass_notice_precedes_the_first_row(self):
        executor, world, _ = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(17, 4, 1),))])
        self.register(executor, self.make_extension(lambda r: (0, 1, 0)))
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.actions_applied, world.difficulty), (OK, 1, 5))
        self.assertEqual(self.events, [("pass",), ("leaf", 17, 0, 0), ("tree", 1)])

    def test_false_gate_notifies_zero_and_skips_the_handler(self):
        executor, world, _ = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(17, 4, 1),))])
        self.register(executor, self.make_extension(lambda r: (0, 0, 0)))
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.actions_applied, world.difficulty), (OK, 0, 0))
        self.assertEqual(self.events[-1], ("tree", 0))

    def test_every_evaluated_row_notifies_in_order_including_empty_trees(self):
        actions = [
            action(0x71, 1, i16(5) + i16(-1) + i16(0)),                       # empty tree
            action(0x71, 1, i16(6) + i16(-1) + i16(0), (condition(17, 4, 1),)),  # extension leaf
            action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0), (condition(2, 7, 1),)),  # false
        ]
        executor, world, _ = self.setup_executor(actions)
        self.register(executor, self.make_extension(lambda r: (0, 1, 0)))
        status, _ = self.step(executor, self.condition_state(world))
        self.assertEqual(status, OK)
        self.assertEqual(self.events, [("pass",), ("tree", 1), ("leaf", 17, 0, 0),
                                       ("tree", 1), ("tree", 0)])
        # Completed rows are skipped before any evaluation; row 2 is still open.
        self.events.clear()
        self.step(executor, self.condition_state(world))
        self.assertEqual(self.events, [("pass",), ("tree", 0)])

    def test_gate_mode_follows_the_runtime_type(self):
        # 0x4d (mode 1), 0x71 (mode 0), 0x6a hotspot (mode 1), raw 0x15/0x0d (mode 1)
        raw_hotspot = bytes((0x0D, 0xFE)) + i16(6400) + b"".join(
            v.to_bytes(4, "little", signed=True) for v in (10, 20, 30, 40))
        actions = [
            action(0x4D, 1, i16(0) + i16(1), (condition(11, 1),)),
            action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(11, 1),)),
            action(0x6A, 2, base.hotspot_6a_body(0, (10, 20, 30, 40)), (condition(11, 1),)),
            action(0x15, 1, raw_hotspot, (condition(11, 1),)),
        ]
        executor, world, _ = self.setup_executor(actions)
        self.register(executor, self.make_extension(lambda r: (0, 1, 0)))
        status, _ = self.step(executor, self.condition_state(world))
        self.assertEqual(status, OK)
        modes = [e[2] for e in self.events if e[0] == "leaf"]
        self.assertEqual(modes, [1, 0, 1, 1])

    # -- accepted-click candidate check (0x43bfb6..0x43c09c) ------------------
    class Decision(c.Structure):
        _fields_ = [("action_index", c.c_size_t), ("chain_count", c.c_size_t),
                    ("tree_evaluated", c.c_uint8), ("tree_satisfied", c.c_uint8),
                    ("accepted", c.c_uint8), ("reserved", c.c_uint8),
                    ("label", c.c_int32), ("first_chain_label", c.c_int32)]

    def decision(self, executor):
        value = self.Decision()
        self.assertEqual(self.lib.scene_executor_get_candidate_decision(
            executor, c.byref(value)), OK)
        return value

    def click(self, executor, state, rect=(10, 20, 30, 40)):
        self.step_frame(executor, state, self.frame())
        self.step_frame(executor, state, self.frame(x=rect[0], y=rect[1], pointer=True, context=True))
        self.events.clear()
        return self.step_frame(executor, state, self.frame(activation=True))

    @staticmethod
    def item_behaviour(selected_labels):
        """Fake opcode 11 (like the kernel, mode 0): hit sets the slot; other
        opcodes are true."""
        def behaviour(req):
            if req.record.opcode == 11:
                if req.evaluation_mode == 0 and req.record.fields[1] in selected_labels:
                    req.selected_leaf_slot[0] = req.leaf_identity
                    return 0, 1, 0
                if req.evaluation_mode != 0:
                    req.selected_leaf_slot[0] = None
                    return 0, 1, 0
                return 0, 0, 0
            return 0, 1, 0
        return behaviour

    def test_hotspot_without_item_leaves_is_accepted_with_no_tree_evaluation(self):
        rect = (10, 20, 30, 40)
        # Extension leaves that would have side effects (17: sound manager, 20: rand).
        actions = [action(0x6A, 2, base.hotspot_6a_body(0, rect),
                          (condition(17, 4, 1), condition(20, 0, 50)))]
        executor, world, _ = self.setup_executor(actions)
        self.register(executor, self.make_extension(lambda r: (0, 1, 0)))
        status, _ = self.click(executor, self.condition_state(world))
        self.assertEqual(status, OK)
        d = self.decision(executor)
        self.assertEqual((d.action_index, d.chain_count, d.tree_evaluated, d.accepted,
                          d.label, d.first_chain_label), (0, 0, 0, 1, -1, -1))
        # Nothing ran before the pass: no leaf, no 0x5c3a47 store at click time.
        self.assertEqual(self.events[0], ("pass",))

    def test_hotspot_with_item_leaf_needs_the_gate_and_a_selected_label(self):
        rect = (10, 20, 30, 40)
        for selected, expect_accept in (({7}, True), (set(), False)):
            actions = [action(0x6A, 2, base.hotspot_6a_body(0, rect, ((2, 9),)),
                              (condition(11, 7),))]
            executor, world, flags = self.setup_executor(actions)
            self.register(executor, self.make_extension(self.item_behaviour(selected)))
            status, _ = self.click(executor, self.condition_state(world))
            self.assertEqual(status, OK)
            d = self.decision(executor)
            self.assertEqual((d.chain_count, d.tree_evaluated, d.first_chain_label), (1, 1, 7))
            self.assertEqual((d.tree_satisfied, d.accepted, d.label),
                             (1, 1, 7) if expect_accept else (0, 0, -1))
            # the candidate eval ran with mode 0 before the pass; the pass uses mode 1
            self.assertEqual(self.events[0], ("leaf", 11, 0, 0))
            self.assertIn(("pass",), self.events)
            # the effects (flag 2 := 9) only run with an accepted click
            self.assertEqual(flags[2], 9 if expect_accept else 0)

    def test_or_true_tree_with_an_empty_item_slot_is_rejected(self):
        rect = (10, 20, 30, 40)
        # (item 7) OR (anything true): the tree is true but no item is selected.
        actions = [action(0x6A, 2, base.hotspot_6a_body(0, rect, ((2, 9),)),
                          (condition(11, 7, 0, 1), condition(17, 4, 1)))]
        executor, world, flags = self.setup_executor(actions)
        self.register(executor, self.make_extension(self.item_behaviour(set())))
        status, _ = self.click(executor, self.condition_state(world))
        self.assertEqual(status, OK)
        d = self.decision(executor)
        self.assertEqual((d.chain_count, d.tree_evaluated, d.tree_satisfied, d.label, d.accepted),
                         (1, 1, 1, -1, 0))
        self.assertEqual(flags[2], 0)

    def test_decision_starts_empty_and_follows_the_latest_candidate(self):
        executor, world, _ = self.setup_executor([action(0x71, 1, i16(5) + i16(-1) + i16(0))])
        d = self.decision(executor)
        self.assertEqual((d.action_index, d.chain_count, d.accepted, d.label, d.first_chain_label),
                         (2 ** 64 - 1, 0, 0, -1, -1))
        self.assertNotEqual(self.lib.scene_executor_get_candidate_decision(None, c.byref(d)), OK)

    def test_host_unavailable_is_an_explicit_blocker_with_failure_detail(self):
        actions = [
            action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(2, 0, 1),)),
            action(0x71, 1, i16(6) + i16(-1) + i16(0),
                   (condition(2, 0, 1), condition(17, 9, 1))),
        ]
        executor, world, _ = self.setup_executor(actions, flags=[1] + [0] * 7)
        self.register(executor, self.make_extension(lambda r: (COND_HOST_UNAVAILABLE, None, 42)))
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.failed_action_index, info.failed_action_type,
                          info.detail_status), (ERR_UNSUPPORTED, 1, 0x71, COND_HOST_UNAVAILABLE))
        failure = Failure()
        self.assertEqual(self.lib.scene_executor_get_condition_failure(
            executor, c.byref(failure)), OK)
        self.assertEqual((failure.opcode, failure.record_index, failure.provider_status),
                         (17, 1, 42))
        self.assertEqual(world.difficulty, 5)       # earlier row's effect remains
        self.assertNotIn(("tree", 1), self.events[-1:])

    def test_provider_failure_is_a_condition_error_not_a_blocker(self):
        executor, world, _ = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0), (condition(20, 0, 50),))])
        self.register(executor, self.make_extension(lambda r: (COND_PROVIDER, None, 6)))
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.detail_status), (ERR_CONDITION, COND_PROVIDER))

    def test_condition_failure_is_zeroed_after_a_successful_evaluation(self):
        executor, world, _ = self.setup_executor(
            [action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0), (condition(2, 7, 1),))])
        self.register(executor, self.make_extension())
        self.step(executor, self.condition_state(world))
        failure = Failure(5, 5, 5, 5)
        self.assertEqual(self.lib.scene_executor_get_condition_failure(
            executor, c.byref(failure)), OK)
        self.assertEqual((failure.opcode, failure.record_index, failure.provider_status), (0, 0, 0))

    def test_selected_item_slot_is_reachable_per_action(self):
        def behaviour(req):
            req.selected_leaf_slot[0] = req.leaf_identity
            return 0, 1, 0

        executor, world, _ = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0)),
             action(0x61, 1, i16(0) + i16(1) + i16(-1) + i16(0), (condition(11, 12),))])
        self.register(executor, self.make_extension(behaviour))
        self.step(executor, self.condition_state(world))
        label = c.c_int32(0)
        for index, expected in ((0, 0), (1, 1)):
            self.assertEqual(self.lib.scene_executor_get_selected_item_label(
                executor, index, c.byref(label)), expected)
        self.assertEqual(label.value, 12)
        self.assertEqual(self.lib.scene_executor_get_selected_item_label(
            executor, 0, c.byref(label)), 0)
        self.assertEqual(label.value, -1)
        self.assertEqual(self.lib.scene_executor_get_selected_item_label(
            executor, 9, c.byref(label)), 0)

    def test_dependency_reset_clears_the_evaluated_flag_but_a_blocked_row_keeps_it(self):
        def behaviour(req):
            req.runtime.contents.random_cache_valid_2c = 1
            return 0, 1, 0

        # 0x4d subtype 2 asks for a dependency reset after its handler.
        executor, world, _ = self.setup_executor(
            [action(0x4D, 2, i16(0) + i16(1), (condition(20, 0, 50),))])
        self.register(executor, self.make_extension(behaviour))
        for _ in range(3):
            self.step(executor, self.condition_state(world))
        valid = [e[3] for e in self.events if e[0] == "leaf"]
        self.assertEqual(valid, [0, 0, 0])

        self.events.clear()
        executor, world, flags = self.setup_executor(
            [action(0x71, 1, i16(5) + i16(-1) + i16(0),
                    (condition(2, 0, 1), condition(20, 0, 50)))])
        self.register(executor, self.make_extension(behaviour))
        for _ in range(3):                      # gate stays false: no reset
            self.step(executor, self.condition_state(world))
        valid = [e[3] for e in self.events if e[0] == "leaf"]
        self.assertEqual(valid, [0, 1, 1])

    def test_loader_thresholds_are_armed_at_the_first_step_not_at_first_evaluation(self):
        # Row 0 changes scene, so row 1 is never evaluated in this step; the
        # original bakes row 1's threshold (table word 5000) when the scene
        # loads, before any dispatch.
        body = i16(6400) + i16(0) * 3 + b"\0" * 12
        timer = b"".join(i16(v) for v in (13, 2, 1, 0, 0, 0, 5000, 0))
        executor, world, _ = self.setup_executor([
            action(0x0A, 1, body),
            action(0x71, 1, i16(5) + i16(-1) + i16(0), (timer,)),
        ])
        reads = []
        ext = self.make_extension()

        @ext_base.VarFn
        def read(_ctx, index, out):
            reads.append(index)
            out[0] = 7
            return 1

        ext.read_variable_word = read
        self._keep.append(read)
        self.register(executor, ext)
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.kind), (OK, base.STEP_TRANSITION))
        self.assertEqual(reads, [5000])
        self.step(executor, self.condition_state(world))
        self.assertEqual(reads, [5000])                    # idempotent

    def test_no_pass_notice_when_a_transition_already_stopped_the_executor(self):
        body = i16(6400) + i16(0) * 3 + b"\0" * 12
        executor, world, _ = self.setup_executor([action(0x0A, 1, body)])
        self.register(executor, self.make_extension())
        self.step(executor, self.condition_state(world))
        self.events.clear()
        status, info = self.step(executor, self.condition_state(world))
        self.assertEqual((status, info.kind), (OK, base.STEP_STOPPED))
        self.assertEqual(self.events, [])


if __name__ == "__main__":
    unittest.main()
