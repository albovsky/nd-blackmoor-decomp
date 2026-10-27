"""Retained-summary exit branch; ordinary local C calls, no original runner."""
import ctypes as c
from pathlib import Path
import tempfile
import unittest

import session_exit_support as s


class NativePopupExitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        temp = tempfile.TemporaryDirectory(prefix='blackmoor-popup-exit-')
        cls.addClassCleanup(temp.cleanup)
        cls.lib = s.load_library(s.build_library(Path(temp.name) / 'exit.dylib'))
        cls.step = cls.lib.session_exit_state4_retained
        cls.step.argtypes = [c.POINTER(s.Exit), c.POINTER(s.Host), c.c_int, c.POINTER(s.StepInfo)]
        cls.step.restype = c.c_int

    def test_classified_retained_summaries_keep_the_original_effect_gate(self):
        for summary in (1, 2):
            for busy in (0, 1):
                with self.subTest(summary=summary, busy=busy):
                    x = s.new_exit(self.lib, kind=2, busy=busy, load_game=1, popup=0)
                    host = s.RecordingHost(self.lib, x)
                    info = s.StepInfo()
                    self.assertEqual(self.step(c.byref(x), c.byref(host.host()), summary, c.byref(info)), s.OK)
                    self.assertEqual((x.g.game_state, x.g.load_game_flag, x.g.popup_flag), (s.STATE_LOAD, 1, 0))
                    self.assertEqual(info.controller_ran, busy)
                    self.assertEqual(len(host.events), 2 if busy else 0)

    def test_other_summary_kinds_still_refuse_before_effects(self):
        x = s.new_exit(self.lib, kind=2, load_game=1)
        before = bytes(x)
        host = s.RecordingHost(self.lib, x)
        info = s.StepInfo()
        self.assertEqual(self.step(c.byref(x), c.byref(host.host()), 0, c.byref(info)), s.ERR_UNSUPPORTED)
        self.assertEqual((bytes(x), host.events, info.unsupported), (before, [], s.UNSUPPORTED_SUMMARY))


if __name__ == '__main__':
    unittest.main()
