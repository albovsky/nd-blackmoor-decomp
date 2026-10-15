"""RT-17 review fix P2-1: the navigation step moves the selector BEFORE the ACT dispatcher.

The original stores [0x5c3a51] := selector at 0x43cf1e and calls the dispatcher at 0x43cf2f in the
same tick that stepped the selector (0x43c251..0x43c941, 0x43cc61..0x43cf2f). Native sets the frame
input in the prepare callback, so the pointer consume (where the app runs the step) must refresh
frame->current_frame itself. This test pins the session contract that makes that possible: a frame
the consume callback writes is the frame the executor dispatches with in the same tick, so a
frame-keyed 0x6a hotspot (scene_executor.c: record frame == current_frame) becomes hot, and is
exported to the same tick's cascade scan, without waiting one tick. The app-side half (the consume
wrapper refreshing the frame and the caption backbuffer) is asserted through the live log by the
rt17 tests in test_native_app.py.
"""
from __future__ import annotations

import ctypes as c
import unittest

import test_scene_executor as exe
import test_scene_session as base
import test_scene_session_pointer as sp

action = base.action


class FrameStepContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        sp.SessionPointerTests.setUpClass.__func__(cls)

    open_scene = sp.SessionPointerTests.open_scene
    make_world = sp.SessionPointerTests.make_world
    create_session = sp.SessionPointerTests.create_session
    start = sp.SessionPointerTests.start
    tick = sp.SessionPointerTests.tick

    def session_with_frame(self, prepare_frame, consume_frame):
        """A 0x6a hotspot keyed to frame 2. prepare gives `prepare_frame`; the consume callback
        (the app's navigation step) rewrites it to `consume_frame` when that is not None."""
        hotspot = action(0x6A, 2, exe.hotspot_6a_body(2, sp.RECT, ()))

        def prepare_extra(frame):
            frame.contents.current_frame = prepare_frame

        session, _flags, rig, _visits = self.start([hotspot], prepare_extra=prepare_extra, bind=False)
        # A detached function-pointer copy: the field itself is overwritten below.
        original = sp.ConsumeFn(c.cast(rig.host.consume, c.c_void_p).value)
        # Overwriting the field would drop the only reference to the Rig's callback: keep it.
        self._wrapped = getattr(self, "_wrapped", []) + [dict(rig.host._objects)]

        def consume(context, frame, candidate):
            status = original(context, frame, candidate)
            if consume_frame is not None:
                frame.contents.current_frame = consume_frame
            return status

        wrapped = sp.ConsumeFn(consume)
        rig.host.consume = wrapped
        self._wrapped = getattr(self, "_wrapped", []) + [wrapped, original]
        rig.bind(session)
        return session

    def test_frame_written_by_consume_reaches_the_dispatcher_of_the_same_tick(self):
        session = self.session_with_frame(prepare_frame=1, consume_frame=2)
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.scan_rows, 1)             # the hotspot is hot after ONE tick

    def test_without_the_consume_refresh_the_hotspot_lags_a_tick(self):
        session = self.session_with_frame(prepare_frame=1, consume_frame=None)
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.scan_rows, 0)             # stale frame 1: the old behaviour

    def test_frame_other_than_the_records_keeps_the_hotspot_cold(self):
        session = self.session_with_frame(prepare_frame=2, consume_frame=3)
        _result, pointer = self.tick(session)
        self.assertEqual(pointer.scan_rows, 0)             # moved off frame 2 before dispatch


if __name__ == "__main__":
    unittest.main()
