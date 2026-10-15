"""RT-17: fixture tests for the view-navigation producer (session_navigation).

Written from the disassembly of GAME.EXE before the oracle comparison; the
expected values below are hand-derived from the instruction semantics cited in
src/session_navigation.h and re-checked, case by case, by
session_navigation_original_oracle.py (original x86 under Unicorn).
"""
from __future__ import annotations

import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

from test_session_input import Rect, State, Context, Hotspot, load_api

PROJECT = Path(__file__).resolve().parents[1]


class NavGlobals(c.Structure):
    _fields_ = [(name, c.c_int16) for name in (
        'selector', 'frame_min', 'frame_max', 'step', 'mode', 'arrow_width', 'arrow_height',
        'hover_delay', 'key_delay', 'scroll_step')] + [
        (name, c.c_int32) for name in (
            'scroll', 'scroll_end', 'image_bottom', 'nav_allowed', 'auto_move', 'frames_cached',
            'cursor_mode', 'state')] + [('gate_deadline', c.c_uint32)]


class NavBands(c.Structure):
    _fields_ = [(name, c.c_int32) for name in ('x1', 'y1', 'x2', 'y2')]


class NavPointer(c.Structure):
    _fields_ = [('hot_x', c.c_int32), ('hot_y', c.c_int32), ('selected_item', c.c_int32)]


class NavZoneGeometry(c.Structure):
    _fields_ = [('view', Rect), ('bands', NavBands), ('hot_x', c.c_int32), ('hot_y', c.c_int32)]


class NavCursor(c.Structure):
    _fields_ = [('index', c.c_int32), ('variant', c.c_int32)]


class NavEffect(c.Structure):
    _fields_ = [('cell', c.c_int32), ('value', c.c_int64)]


NAV_EFFECT_MAX = 12
CELL_NAMES = {1: 'state', 2: 'cursor_index', 3: 'cursor_variant', 4: 'surface', 5: 'table',
              6: 'layer', 7: 'selector', 8: 'scroll', 9: 'scroll_end', 10: 'dirty', 11: 'deadline'}


def effect_list(result):
    return [(CELL_NAMES[result.effects[i].cell], result.effects[i].value)
            for i in range(result.effect_count)]


class NavZoneResult(c.Structure):
    _fields_ = [('state', c.c_int32), ('claimed', c.c_uint8), ('surface_default', c.c_uint8),
                ('cursor', NavCursor), ('table_offset', c.c_uint32), ('layer_flag', c.c_uint8),
                ('effect_count', c.c_uint8), ('effects', NavEffect * NAV_EFFECT_MAX)]


class NavKeys(c.Structure):
    _fields_ = [(name, c.c_uint8) for name in (
        'f1d', 'f1e', 'f15', 'f16', 'f13', 'f14', 'f27', 'f28', 'f25', 'f26')]


class NavStepResult(c.Structure):
    _fields_ = [('entered', c.c_uint8), ('view_dirty', c.c_uint8), ('selector_changed', c.c_uint8),
                ('selector_before', c.c_int16), ('effect_count', c.c_uint8),
                ('effects', NavEffect * NAV_EFFECT_MAX)]


class NavScanResult(c.Structure):
    _fields_ = [('candidate', c.c_int32), ('state', c.c_int32), ('claimed_by_zone', c.c_uint8),
                ('zone', NavZoneResult), ('zone_evaluated', c.c_uint8)]


def load_navigation(path):
    lib = load_api(path)
    lib.session_navigation_zone.argtypes = [c.POINTER(NavGlobals), c.POINTER(NavZoneGeometry),
                                            c.POINTER(NavCursor), c.POINTER(NavZoneResult)]
    lib.session_navigation_step.argtypes = [c.POINTER(NavGlobals), c.POINTER(NavKeys), c.c_uint32,
                                            c.c_uint32, c.POINTER(NavStepResult)]
    lib.session_input_scan_priority.argtypes = [c.POINTER(State), c.POINTER(Context),
                                                c.POINTER(Hotspot), c.c_size_t,
                                                c.POINTER(Hotspot), c.c_size_t]
    lib.session_navigation_scan.argtypes = [
        c.POINTER(State), c.POINTER(Context), c.POINTER(NavGlobals), c.POINTER(NavBands),
        c.POINTER(NavPointer), c.POINTER(NavCursor), c.POINTER(Hotspot), c.c_size_t,
        c.POINTER(Hotspot), c.c_size_t, c.POINTER(NavScanResult)]
    lib.session_navigation_member_type.argtypes = [c.c_uint8]
    lib.session_navigation_member_type.restype = c.c_int
    lib.session_navigation_member_type_count.restype = c.c_size_t
    lib.session_navigation_members_idle.argtypes = [c.POINTER(c.c_uint8), c.c_size_t]
    lib.session_navigation_members_idle.restype = c.c_int
    for name in ('zone', 'step', 'scan'):
        getattr(lib, 'session_navigation_' + name).restype = c.c_int
    lib.session_input_scan_priority.restype = c.c_int
    return lib


def build_library():
    env = dict(os.environ)
    subprocess.run([str(PROJECT / 'scripts/build_session_navigation.sh')], check=True,
                   env=env, stdout=subprocess.DEVNULL)
    return Path(env.get('NAV_OUTPUT', PROJECT / 'build/libsession_navigation.dylib'))


VIEW = Rect(10, 10, 629, 384)
# BSUM words 0x5b0260 = 30 and 0x5b0262 = 40 (fixture values; the corpus value is logged by the app).
BANDS = NavBands(10 + 30 - 1, 10 + 40 - 1, 629 - 30 + 1, 384 - 40 + 1)


def globals_(**kw):
    values = dict(selector=1, frame_min=0, frame_max=19, step=1, mode=1, arrow_width=15,
                  arrow_height=15, hover_delay=400, key_delay=66, scroll_step=10, scroll=0,
                  scroll_end=374, image_bottom=374, nav_allowed=1, auto_move=1, frames_cached=1,
                  cursor_mode=0, state=0, gate_deadline=0)
    values.update(kw)
    return NavGlobals(**values)


class SessionNavigationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.api = load_navigation(build_library())

    def zone(self, x, y, cursor=(0, 0), **kw):
        g = globals_(**kw)
        geo = NavZoneGeometry(VIEW, BANDS, x, y)
        out = NavZoneResult()
        self.assertEqual(self.api.session_navigation_zone(c.byref(g), c.byref(geo),
                                                          c.byref(NavCursor(*cursor)),
                                                          c.byref(out)), 0)
        return out

    def step(self, g, tick, now=None, keys=None):
        out = NavStepResult()
        self.assertEqual(self.api.session_navigation_step(
            c.byref(g), c.byref(keys or NavKeys()), tick, tick if now is None else now,
            c.byref(out)), 0)
        return out

    # -- zones (0x4f18fa..0x4f1e73)
    def test_horizontal_bands_and_arrow_cursors(self):
        left = self.zone(20, 100)
        self.assertEqual((left.state, left.claimed, left.cursor.index, left.surface_default), (1, 1, 0xe, 1))
        right = self.zone(610, 100)
        self.assertEqual((right.state, right.claimed, right.cursor.index), (2, 1, 0xf))
        self.assertEqual(right.table_offset, 0xf * 32)
        alt_left = self.zone(20, 100, key_delay=0x4d)
        alt_right = self.zone(610, 100, key_delay=0x4d)
        self.assertEqual((alt_left.cursor.index, alt_right.cursor.index), (0x11, 0x10))
        # The variant survives into the table offset while a zone is hit.
        held = self.zone(20, 100, cursor=(0, 1))
        self.assertEqual(held.table_offset, 0xe * 32 + 16)

    def test_band_edges_are_inclusive(self):
        self.assertEqual(self.zone(BANDS.x1, 100).state, 1)
        self.assertEqual(self.zone(BANDS.x1 + 1, 100).state, 0)
        self.assertEqual(self.zone(BANDS.x2, 100).state, 2)
        self.assertEqual(self.zone(BANDS.x2 - 1, 100).state, 0)
        self.assertEqual(self.zone(20, BANDS.y1).state, 1)
        self.assertEqual(self.zone(20, BANDS.y1 - 1).state, 0)
        self.assertEqual(self.zone(20, BANDS.y2).state, 1)
        self.assertEqual(self.zone(20, BANDS.y2 + 1).state, 0)

    def test_no_zone_leaves_the_generic_loop_and_resets_the_variant(self):
        out = self.zone(300, 200, cursor=(5, 1))
        self.assertEqual((out.state, out.claimed, out.cursor.index, out.cursor.variant), (0, 0, 5, 0))
        self.assertEqual(out.table_offset, 5 * 32)

    def test_zone_gates(self):
        self.assertEqual(self.zone(20, 100, nav_allowed=0).state, 0)
        self.assertEqual(self.zone(20, 100, arrow_width=0).state, 0)
        self.assertEqual(self.zone(20, 100, mode=0).state, 0)
        self.assertEqual(self.zone(20, 100, mode=2, selector=19).state, 0)   # at max, no +step
        self.assertEqual(self.zone(20, 100, mode=2, selector=18).state, 1)
        self.assertEqual(self.zone(610, 100, mode=2, selector=0).state, 0)   # at min, no -step
        self.assertEqual(self.zone(610, 100, mode=2, selector=1).state, 2)
        self.assertEqual(self.zone(20, 100, mode=1, selector=19).state, 1)   # wrap mode always

    def test_vertical_zones_need_scroll_room(self):
        self.assertEqual(self.zone(300, 12).state, 0)
        self.assertEqual(self.zone(300, 12, scroll=5).state, 3)
        self.assertEqual(self.zone(300, 12, scroll=5).cursor.index, 0)
        self.assertEqual(self.zone(300, 380).state, 0)
        self.assertEqual(self.zone(300, 380, scroll_end=300).state, 4)
        self.assertEqual(self.zone(300, 380, arrow_height=0, scroll_end=300).state, 0)

    def test_corners(self):
        self.assertEqual(self.zone(20, 12, scroll=5).state, 5)
        self.assertEqual(self.zone(610, 12, scroll=5).state, 6)
        self.assertEqual(self.zone(20, 380, scroll_end=300).state, 7)
        self.assertEqual(self.zone(610, 380, scroll_end=300).state, 8)
        self.assertEqual(self.zone(20, 12, scroll=0).state, 0)

    def test_entry_state_is_honoured(self):
        out = self.zone(300, 200, state=1, nav_allowed=0)
        self.assertEqual((out.state, out.claimed, out.cursor.index), (1, 1, 0xe))

    # -- tick step (0x43c133..0x43c941)
    def test_step_moves_selector_and_arms_the_deadline(self):
        g = globals_(state=1, selector=1)
        out = self.step(g, tick=1000, now=1003)
        self.assertEqual((out.entered, out.selector_changed, g.selector, g.gate_deadline), (1, 1, 2, 1403))
        # Inside the deadline nothing happens.
        again = self.step(g, tick=1403)
        self.assertEqual((again.entered, g.selector, g.gate_deadline), (0, 2, 1403))
        later = self.step(g, tick=1404, now=1404)
        self.assertEqual((later.entered, g.selector, g.gate_deadline), (1, 3, 1804))

    def test_step_gates(self):
        for name, value in (('state', 0), ('auto_move', 0), ('hover_delay', 0x14d), ('cursor_mode', 2),
                            ('cursor_mode', 5)):
            g = globals_(state=1, **{name: value} if name != 'state' else {})
            if name == 'state':
                g.state = 0
            out = self.step(g, tick=1000)
            self.assertEqual((out.entered, g.selector, g.gate_deadline), (0, 1, 0), name)
        # Modes 0, 1 and 6 do not block the step (only 2..5 are UI modes).
        for mode in (0, 1, 6, -1):
            g = globals_(state=1, cursor_mode=mode)
            self.assertEqual(self.step(g, tick=1000).entered, 1)

    def test_wrap_and_clamp_at_the_ends(self):
        g = globals_(state=1, selector=19)
        self.step(g, 1000)
        self.assertEqual(g.selector, 0)           # mode 1 wraps to min
        g = globals_(state=2, selector=0)
        self.step(g, 1000)
        self.assertEqual(g.selector, 19)
        g = globals_(state=1, selector=19, mode=2)
        out = self.step(g, 1000)
        self.assertEqual((g.selector, out.view_dirty), (19, 0))
        g = globals_(state=1, selector=19, mode=0)
        self.step(g, 1000)
        self.assertEqual(g.selector, 19)
        g = globals_(state=1, selector=19, mode=5)  # other modes leave an out-of-range value
        self.step(g, 1000)
        self.assertEqual(g.selector, 20)

    def test_selector_word_arithmetic(self):
        g = globals_(state=1, selector=32767, frame_max=32767, frame_min=-32768, step=1)
        self.step(g, 1000)
        self.assertEqual(g.selector, -32768)       # 16-bit add wraps; -32768 > max is false
        g = globals_(state=1, selector=3, step=-1)
        self.step(g, 1000)
        self.assertEqual(g.selector, 2)

    def test_scroll_states(self):
        g = globals_(state=3, scroll=5, scroll_end=300)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.scroll_end, out.view_dirty), (0, 295, 1))   # 5 - 10 < 0: end -= 10 + (-5)
        g = globals_(state=3, scroll=50, scroll_end=300)
        self.step(g, 1000)
        self.assertEqual((g.scroll, g.scroll_end), (40, 290))
        g = globals_(state=4, scroll=0, scroll_end=370)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.scroll_end, out.view_dirty), (4, 374, 1))
        g = globals_(state=4, scroll=0, scroll_end=374)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.scroll_end, out.view_dirty), (0, 374, 1))

    def test_corner_states_move_both(self):
        g = globals_(state=5, scroll=50, scroll_end=300, selector=2)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.selector, out.view_dirty), (40, 3, 0))
        g = globals_(state=6, scroll=50, scroll_end=300, selector=0)
        out = self.step(g, 1000)
        self.assertEqual((g.selector, out.view_dirty), (19, 0))
        g = globals_(state=7, scroll=0, scroll_end=300, selector=19, mode=2)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.selector, out.view_dirty), (10, 19, 1))
        g = globals_(state=8, scroll=0, scroll_end=300, selector=0, mode=0)
        out = self.step(g, 1000)
        self.assertEqual((g.scroll, g.selector, out.view_dirty), (10, 0, 1))

    def test_out_of_range_state_only_updates_the_deadline(self):
        g = globals_(state=9)
        out = self.step(g, 1000, now=1001)
        self.assertEqual((out.entered, g.selector, g.gate_deadline), (1, 1, 1401))

    def test_key_flags_choose_the_gate_and_the_delay(self):
        # A key group enters through 0x43c1f4 and then skips the AutoMove/0x14d gates.
        g = globals_(state=1, auto_move=0, hover_delay=0x14d)
        self.assertEqual(self.step(g, 1000).entered, 0)
        g = globals_(state=1, auto_move=0, hover_delay=0x14d)
        self.assertEqual(self.step(g, 1000, keys=NavKeys(f1d=1)).entered, 1)
        self.assertEqual(g.gate_deadline, 1000 + 0x14d)          # 0x58321d group uses [0x5bb2ce]
        g = globals_(state=1, auto_move=0, frames_cached=0)
        self.assertEqual(self.step(g, 1000, keys=NavKeys(f1e=1)).entered, 0)   # needs the 0x5a4c20 cache
        g = globals_(state=1, auto_move=0, frames_cached=1)
        out = self.step(g, 1000, keys=NavKeys(f1e=1))
        self.assertEqual((out.entered, g.gate_deadline), (1, 1000 + 66))

    # -- cascade pipeline
    def run_scan(self, x, y, rows=(), priority=(), nav=None, **ctx):
        state = State()
        self.assertEqual(self.api.session_input_init(c.byref(state)), 0)
        context = Context(VIEW, Rect(x, y, x, y), 0, 0, 0, ctx.get('mode', 0), 0, ctx.get('disabled', 0),
                          1, ctx.get('clear', 1), -1, -1)
        g = nav or globals_()
        cursor = NavCursor(0, 0)
        out = NavScanResult()
        arr = (Hotspot * max(len(rows), 1))(*rows)
        pri = (Hotspot * max(len(priority), 1))(*priority)
        status = self.api.session_navigation_scan(
            c.byref(state), c.byref(context), c.byref(g), c.byref(BANDS), c.byref(NavPointer(x, y, -1)),
            c.byref(cursor), pri, len(priority), arr, len(rows), c.byref(out))
        return status, state.candidate, g, cursor, out

    def test_zone_returns_before_the_generic_loop(self):
        row = Hotspot(3, Rect(0, 0, 640, 480), 1)
        status, candidate, g, cursor, out = self.run_scan(20, 100, rows=[row])
        self.assertEqual((status, candidate, g.state, out.claimed_by_zone, cursor.index), (0, -1, 1, 1, 0xe))
        status, candidate, g, cursor, out = self.run_scan(300, 200, rows=[row])
        self.assertEqual((status, candidate, g.state, out.claimed_by_zone), (0, 3, 0, 0))

    def test_priority_rows_win_before_the_zone(self):
        row = Hotspot(9, Rect(0, 0, 640, 480), 1)
        status, candidate, g, cursor, out = self.run_scan(20, 100, priority=[row])
        self.assertEqual((status, candidate, g.state, out.zone_evaluated), (0, 9, 0, 0))

    def test_unmodelled_members_stop_before_the_zone(self):
        status, candidate, g, cursor, out = self.run_scan(20, 100, clear=0)
        self.assertEqual(status, 3)   # SESSION_INPUT_LIMIT_PRIORITY_PATH
        # Outside the viewport the overlap guard returns before the members.
        status, candidate, g, cursor, out = self.run_scan(700, 100, clear=0)
        self.assertEqual((status, candidate, g.state), (0, -1, 0))

    def test_ui_modes_and_disabled_producer_clear_the_state(self):
        for ctx in ({'mode': 3}, {'disabled': 1}):
            status, candidate, g, cursor, out = self.run_scan(20, 100, nav=globals_(state=1), **ctx)
            self.assertEqual((status, candidate, g.state, out.zone_evaluated), (0, -1, 0, 0), ctx)

    def test_outside_the_viewport_is_no_zone(self):
        for x, y in ((9, 100), (630, 100), (20, 9), (20, 385)):
            status, candidate, g, cursor, out = self.run_scan(x, y)
            self.assertEqual((status, candidate, g.state, out.zone_evaluated), (0, -1, 0, 0), (x, y))

    def test_member_type_table(self):
        listed = sorted(t for t in range(256) if self.api.session_navigation_member_type(t))
        self.assertEqual(len(listed), self.api.session_navigation_member_type_count())
        self.assertEqual(len(listed), 49)
        for t in (0x0a, 0x0b, 0x15, 0x17, 0x1d, 0x36, 0x37, 0x62, 0x97, 0x9f, 0xa1):
            self.assertNotIn(t, listed)           # types of the tutorial scenes S6400..S6404
        for t in (0x72, 0x77, 0x1c, 0xd9, 0xaa, 0xf6):
            self.assertIn(t, listed)
        types = (c.c_uint8 * 3)(0x0a, 0x17, 0x36)
        self.assertEqual(self.api.session_navigation_members_idle(types, 3), 1)
        types = (c.c_uint8 * 3)(0x0a, 0xd9, 0x36)
        self.assertEqual(self.api.session_navigation_members_idle(types, 3), 0)
        self.assertEqual(self.api.session_navigation_members_idle(None, 0), 1)
        self.assertEqual(self.api.session_navigation_members_idle(None, 2), 0)

    def test_member_type_table_matches_the_derived_members(self):
        path = PROJECT.parents[1] / 'work/analysis/slices/RT-17.cascade-members.json'
        if not path.exists():
            self.skipTest('private derivation evidence not present')
        import json
        data = json.loads(path.read_text())
        expected = {int(t, 16) for m in data['members'] for t in m['runtime_types']} - {0x36}
        expected |= {0x72, 0x73, 0x74, 0x75, 0x76, 0x77}
        listed = {t for t in range(256) if self.api.session_navigation_member_type(t)}
        self.assertEqual(listed, expected)

    def test_held_item_prelude_resets_or_selects_the_cursor(self):
        state = State()
        self.api.session_input_init(c.byref(state))
        context = Context(VIEW, Rect(300, 200, 300, 200), 0, 0, 0, 0, 0, 0, 1, 1, -1, -1)
        for item, expected in ((-1, (0, 0)), (4, (0x29, 1))):
            g = globals_()
            cursor = NavCursor(7, 1)
            out = NavScanResult()
            self.api.session_navigation_scan(c.byref(state), c.byref(context), c.byref(g), c.byref(BANDS),
                                             c.byref(NavPointer(300, 200, item)), c.byref(cursor),
                                             None, 0, None, 0, c.byref(out))
            # State 0 tail clears the variant after the prelude.
            self.assertEqual((cursor.index, 0 if item == -1 else 0), (expected[0], 0))
            self.assertEqual(cursor.variant, 0)

    def test_malformed_rows_are_rejected_before_any_mutation(self):
        # Review fix P2-2: the generic rows are validated up front, not on the second scan call.
        bad_sets = {
            'unsorted': [Hotspot(0, Rect(0, 0, 9, 9), 1), Hotspot(5, Rect(0, 0, 9, 9), 1),
                         Hotspot(9, Rect(0, 0, 9, 9), 1), Hotspot(1, Rect(0, 0, 9, 9), 1)],
            'duplicate': [Hotspot(3, Rect(0, 0, 9, 9), 1), Hotspot(3, Rect(0, 0, 9, 9), 1)],
            'index_240': [Hotspot(240, Rect(0, 0, 9, 9), 1)],
            'negative': [Hotspot(-1, Rect(0, 0, 9, 9), 1)],
            'rect_outside_short': [Hotspot(2, Rect(0, 0, 40000, 9), 1)],
        }
        for mode in (0, 3):        # a normal tick and a UI-mode tick take different early paths
            for name, rows in bad_sets.items():
                state = State()
                self.api.session_input_init(c.byref(state))
                state.candidate = 55
                context = Context(VIEW, Rect(20, 100, 20, 100), 0, 0, 0, mode, 0, 0, 1, 1, -1, -1)
                g = globals_(state=7)
                cursor = NavCursor(5, 1)
                out = NavScanResult()
                arr = (Hotspot * len(rows))(*rows)
                status = self.api.session_navigation_scan(
                    c.byref(state), c.byref(context), c.byref(g), c.byref(BANDS),
                    c.byref(NavPointer(20, 100, -1)), c.byref(cursor), None, 0, arr, len(rows),
                    c.byref(out))
                self.assertEqual(status, 1, (name, mode))
                self.assertEqual((state.candidate, g.state, cursor.index, cursor.variant),
                                 (55, 7, 5, 1), (name, mode))
        # excluded slots and priority indices are validated as well
        for excluded, priority in ((240, None), (-2, None), (-1, Hotspot(240, Rect(0, 0, 9, 9), 1))):
            state = State()
            self.api.session_input_init(c.byref(state))
            state.candidate = 55
            context = Context(VIEW, Rect(20, 100, 20, 100), 0, 0, 0, 0, 0, 0, 1, 1, excluded, -1)
            g = globals_(state=7)
            pri = (Hotspot * 1)(priority) if priority is not None else None
            status = self.api.session_navigation_scan(
                c.byref(state), c.byref(context), c.byref(g), c.byref(BANDS),
                c.byref(NavPointer(20, 100, -1)), c.byref(NavCursor(0, 0)), pri,
                1 if pri is not None else 0, None, 0, c.byref(NavScanResult()))
            self.assertEqual((status, state.candidate, g.state), (1, 55, 7))

    def test_invalid_arguments(self):
        out = NavZoneResult()
        self.assertEqual(self.api.session_navigation_zone(None, None, None, c.byref(out)), 1)
        self.assertEqual(self.api.session_navigation_step(None, None, 0, 0, None), 1)


class OriginalOracleSmokeTest(unittest.TestCase):
    """The quick original-x86 comparison (zones, step sequences, cascade pipeline)."""

    def test_quick_oracle_against_the_original_executable(self):
        original = PROJECT.parents[1] / 'work/original/GAME.EXE'
        if not original.is_file():
            self.skipTest('original executable unavailable')
        try:
            import unicorn  # noqa: F401
        except ImportError:
            self.skipTest('Unicorn unavailable; use work/tools/oracle-python/bin/python')
        build_library()
        import sys
        result = subprocess.run([sys.executable, str(PROJECT / 'tests/session_navigation_original_oracle.py'),
                                 '--quick', '--no-report'], capture_output=True, text=True, timeout=600,
                                cwd=str(PROJECT / 'tests'))
        self.assertEqual(result.returncode, 0, result.stderr[-2000:])
        self.assertIn('"mismatches": 0', result.stdout)


if __name__ == '__main__':
    unittest.main()
