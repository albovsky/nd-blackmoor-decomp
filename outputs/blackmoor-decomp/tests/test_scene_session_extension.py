"""RT-4: the dependency-leaf extension through the persistent scene session.

Checks that the registration survives scene replacement, that the pass notice
precedes the first row each tick, that an unavailable leaf freezes the session
at the dependency provider with a readable failure record, and that without an
extension nothing changes (extension opcodes stay the old explicit blocker).
"""
from __future__ import annotations

import ctypes as c
import os
from pathlib import Path
import unittest
from unittest import mock

import test_scene_session as base
import test_scene_conditions_extension as ext_base

LeafFn, PassFn, TreeFn = ext_base.LeafFn, ext_base.PassFn, ext_base.TreeFn
Extension, Failure = ext_base.Extension, ext_base.Failure
i16, action = base.i16, base.action
PROVIDER_DEPENDENCY = 12
SESSION_OK, SESSION_BLOCKED, SESSION_ERR_EXECUTOR = 0, 2, 5
COND_UNSUPPORTED, COND_HOST_UNAVAILABLE, COND_PROVIDER = 6, 7, 8


def gate(opcode, index=0, expected=0):
    return b"".join(i16(v) for v in (opcode, index, expected, 0, 0, 0, 0, 0))


class SessionExtensionTests(unittest.TestCase):
    open_scene = base.SceneSessionTests.open_scene
    make_world = base.SceneSessionTests.make_world
    create_session = base.SceneSessionTests.create_session

    @classmethod
    def setUpClass(cls):
        # RT4_SESSION_LIBRARY aims this suite at a library built from altered sources
        # (mutation checks): skip the build step and load that file instead.
        override = os.environ.get("RT4_SESSION_LIBRARY")
        if override:
            with mock.patch.object(base, "LIBRARY", Path(override)), \
                    mock.patch.object(base.subprocess, "run"):
                base.SceneSessionTests.setUpClass.__func__(cls)
        else:
            base.SceneSessionTests.setUpClass.__func__(cls)
        lib = cls.lib
        lib.scene_session_set_condition_extension.argtypes = [
            c.c_void_p, c.POINTER(Extension)]
        lib.scene_session_set_condition_extension.restype = c.c_int
        lib.scene_session_get_condition_failure.argtypes = [
            c.c_void_p, c.POINTER(Failure)]
        lib.scene_session_get_condition_failure.restype = c.c_int

    def setUp(self):
        self.events = []
        self._keep = []

    def make_extension(self, behaviour):
        def leaf(_ctx, request, status_out, provider_status):
            req = request.contents
            self.events.append(("leaf", req.record.opcode, req.evaluation_mode))
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

    def start(self, actions, behaviour=None, register=True):
        scene, owner = self.open_scene(actions)
        flags, world, conditions = self.make_world()

        @base.PrepareFn
        def prepare(_context, _conditions, _frame, _failure):
            return 0

        @base.MediaFn
        def media(_context, _frame, _failure):
            return 0

        session, initial, bindings = self.create_session(
            scene, world, conditions, prepare=prepare, media=media)
        ext = self.make_extension(behaviour or (lambda r: (0, 1, 0)))
        if register:
            self.assertEqual(self.lib.scene_session_set_condition_extension(
                session, c.byref(ext)), 0)
        self.addCleanup(self.lib.scene_resource_close, scene)
        self.addCleanup(self.lib.scene_session_destroy, session)
        self._keep.extend([owner, flags, world, conditions, prepare, media, initial, bindings])
        return session, scene, flags, ext

    def tick(self, session):
        result = base.SceneSessionTickResult()
        status = self.lib.scene_session_tick(session, c.byref(result))
        return status, result

    def test_extension_leaf_runs_in_session_dispatch_with_pass_notice_first(self):
        session, _scene, flags, _ext = self.start(
            [action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0), (gate(17, 4, 1),))])
        status, _result = self.tick(session)
        self.assertEqual(status, SESSION_OK)
        self.assertEqual(flags[0], 7)
        self.assertEqual(self.events, [("pass",), ("leaf", 17, 0), ("tree", 1)])

    def test_without_registration_the_old_dependency_blocker_remains(self):
        session, _scene, _flags, _ext = self.start(
            [action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0), (gate(17, 4, 1),))],
            register=False)
        status, result = self.tick(session)
        self.assertEqual((status, result.failure.provider, result.failure.detail_status),
                         (SESSION_BLOCKED, PROVIDER_DEPENDENCY, COND_UNSUPPORTED))
        failure = Failure()
        self.assertEqual(self.lib.scene_session_get_condition_failure(session, c.byref(failure)), 0)
        self.assertEqual(failure.opcode, 17)

    def test_unavailable_leaf_freezes_at_the_dependency_provider_with_detail(self):
        session, _scene, flags, _ext = self.start(
            [action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0)),
             action(0x61, 1, i16(1) + i16(9) + i16(-1) + i16(0),
                    (gate(2, 0, 7), gate(17, 4, 1)))],
            behaviour=lambda r: (COND_HOST_UNAVAILABLE, None, 3))
        status, result = self.tick(session)
        self.assertEqual((status, result.failure.provider, result.failure.action_index,
                          result.failure.action_type, result.failure.detail_status),
                         (SESSION_BLOCKED, PROVIDER_DEPENDENCY, 1, 0x61, COND_HOST_UNAVAILABLE))
        self.assertEqual(flags[0], 7)             # row 0 already ran
        failure = Failure()
        self.assertEqual(self.lib.scene_session_get_condition_failure(session, c.byref(failure)), 0)
        self.assertEqual((failure.opcode, failure.record_index, failure.provider_status), (17, 1, 3))
        # Frozen: the blocker is sticky and no further leaf runs.
        before = len(self.events)
        again, _ = self.tick(session)
        self.assertEqual(again, SESSION_BLOCKED)
        self.assertEqual(len(self.events), before)

    def test_provider_failure_is_an_executor_error_at_the_dependency_provider(self):
        session, _scene, _flags, _ext = self.start(
            [action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0), (gate(20, 0, 50),))],
            behaviour=lambda r: (COND_PROVIDER, None, 6))
        status, result = self.tick(session)
        self.assertEqual((status, result.failure.provider, result.failure.detail_status),
                         (SESSION_ERR_EXECUTOR, PROVIDER_DEPENDENCY, COND_PROVIDER))

    def test_registration_is_reapplied_to_the_replacement_executor(self):
        session, _scene, _flags, _ext = self.start(
            [action(0x61, 1, i16(0) + i16(7) + i16(-1) + i16(0))])
        replacement, owner = self.open_scene(
            [action(0x61, 1, i16(1) + i16(8) + i16(-1) + i16(0), (gate(21),))])
        self.addCleanup(self.lib.scene_resource_close, replacement)
        self._keep.append(owner)
        self.assertEqual(self.lib.scene_session_replace_scene(
            session, replacement, 11, c.byref(base.SceneSessionFailure())), 0)
        self.events.clear()
        status, _ = self.tick(session)
        self.assertEqual(status, SESSION_OK)
        self.assertEqual(self.events, [("pass",), ("leaf", 21, 0), ("tree", 1)])

    def test_null_session_is_rejected(self):
        ext = self.make_extension(lambda r: (0, 1, 0))
        self.assertNotEqual(self.lib.scene_session_set_condition_extension(
            None, c.byref(ext)), 0)
        self.assertNotEqual(self.lib.scene_session_get_condition_failure(
            None, c.byref(Failure())), 0)


if __name__ == "__main__":
    unittest.main()
