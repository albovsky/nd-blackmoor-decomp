"""RT-14: the overlay hit test (0x4897cd) runs BEFORE the generic row scan.

The pointer cascade 0x4f0059 calls the overlay manager's hit test at 0x4f104f
and returns at the first hit, so an overlay hot rectangle wins over any generic
row (and over the excluded special slots, which only the generic loop checks).
session_input_scan_priority takes those rows as a separate ordered list.
"""
import ctypes as c
from pathlib import Path
import subprocess
import unittest

import test_session_input as base

PROJECT = Path(__file__).resolve().parents[1]


def load():
    import os
    lib = base.load_api(Path(os.environ.get('SESSION_INPUT_LIBRARY', PROJECT / 'build/libsession_input.dylib')))
    lib.session_input_scan_priority.argtypes = [
        c.POINTER(base.State), c.POINTER(base.Context), c.POINTER(base.Hotspot), c.c_size_t,
        c.POINTER(base.Hotspot), c.c_size_t]
    lib.session_input_scan_priority.restype = c.c_int
    return lib


def spot(index, left, top, right, bottom, active=1):
    return base.Hotspot(index, base.Rect(left, top, right, bottom), active)


class PriorityScanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        import os
        if 'SESSION_INPUT_LIBRARY' not in os.environ:
            subprocess.run([str(PROJECT / 'scripts/build_session_input.sh')], check=True,
                           capture_output=True)
        cls.api = load()

    def setUp(self):
        self.state = base.State()
        self.assertEqual(self.api.session_input_init(c.byref(self.state)), 0)
        # context(440, 255): viewport 10,10..; hot (0,0): the projected pointer is (430, 245).
        self.ctx = base.context()

    def scan(self, priority, generic):
        p = (base.Hotspot * max(len(priority), 1))(*priority)
        g = (base.Hotspot * max(len(generic), 1))(*generic)
        return self.api.session_input_scan_priority(
            c.byref(self.state), c.byref(self.ctx), p if priority else None, len(priority),
            g if generic else None, len(generic))

    def test_priority_hit_beats_an_earlier_generic_row(self):
        self.assertEqual(self.scan([spot(9, 420, 235, 440, 255)], [spot(2, 400, 200, 500, 300)]), 0)
        self.assertEqual(self.state.candidate, 9)

    def test_priority_miss_falls_through_to_the_generic_scan(self):
        self.assertEqual(self.scan([spot(9, 0, 0, 5, 5)], [spot(2, 400, 200, 500, 300)]), 0)
        self.assertEqual(self.state.candidate, 2)

    def test_priority_rows_are_tried_in_the_given_order_not_by_index(self):
        both = [spot(7, 420, 235, 440, 255), spot(3, 420, 235, 440, 255)]
        self.scan(both, [])
        self.assertEqual(self.state.candidate, 7)
        self.scan(list(reversed(both)), [])
        self.assertEqual(self.state.candidate, 3)

    def test_same_row_may_appear_with_several_rectangles(self):
        self.scan([spot(4, 0, 0, 5, 5), spot(4, 420, 235, 440, 255)], [])
        self.assertEqual(self.state.candidate, 4)

    def test_inclusive_edges_and_inactive_rows(self):
        self.scan([spot(5, 430, 245, 430, 245)], [])
        self.assertEqual(self.state.candidate, 5)
        self.scan([spot(5, 431, 245, 440, 245)], [])
        self.assertEqual(self.state.candidate, -1)
        self.scan([spot(5, 420, 235, 440, 255, active=0)], [])
        self.assertEqual(self.state.candidate, -1)

    def test_priority_hit_on_an_excluded_slot_is_not_the_priority_limit(self):
        self.ctx.excluded_0 = 9
        self.assertEqual(self.scan([spot(9, 420, 235, 440, 255)], []), 0)
        self.assertEqual(self.state.candidate, 9)
        # The generic loop still hands excluded slots to their special handler.
        self.assertEqual(self.scan([], [spot(9, 420, 235, 440, 255)]), 3)

    def test_priority_rows_are_ignored_when_the_scan_clears_the_candidate(self):
        self.ctx.cursor_mode = 3
        self.scan([spot(9, 420, 235, 440, 255)], [])
        self.assertEqual(self.state.candidate, -1)
        self.ctx.cursor_mode = 0
        self.ctx.producer_disabled = 1
        self.scan([spot(9, 420, 235, 440, 255)], [])
        self.assertEqual(self.state.candidate, -1)

    def test_invalid_rows_change_nothing(self):
        self.state.candidate = 77
        self.assertEqual(self.scan([spot(240, 0, 0, 1, 1)], []), 1)
        self.assertEqual(self.scan([spot(-1, 0, 0, 1, 1)], []), 1)
        self.assertEqual(self.scan([spot(1, 0, 0, 40000, 1)], []), 1)
        self.assertEqual(self.scan([], [spot(5, 0, 0, 1, 1), spot(5, 0, 0, 1, 1)]), 1)
        self.assertEqual(self.state.candidate, 77)
        self.assertEqual(self.api.session_input_scan_priority(
            c.byref(self.state), c.byref(self.ctx), None, 3, None, 0), 1)

    def test_geometry_limits_apply_to_the_priority_path(self):
        self.ctx.geometry_ready = 0
        self.state.candidate = 77
        self.assertEqual(self.scan([spot(9, 420, 235, 440, 255)], []), 2)
        self.assertEqual(self.state.candidate, 77)

    def test_plain_scan_is_the_priority_scan_without_priority_rows(self):
        rows = (base.Hotspot * 1)(spot(2, 400, 200, 500, 300))
        self.assertEqual(self.api.session_input_scan(c.byref(self.state), c.byref(self.ctx), rows, 1), 0)
        self.assertEqual(self.state.candidate, 2)


if __name__ == '__main__':
    unittest.main()
