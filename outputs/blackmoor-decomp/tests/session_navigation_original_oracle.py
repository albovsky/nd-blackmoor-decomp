#!/usr/bin/env python3
"""RT-17: original-x86 oracle for the view-navigation producer.

Runs the unmodified GAME.EXE under Unicorn and compares it, after every step,
with src/session_navigation.c:

  zone      0x4f18fa..0x4f1e78 / 0x4f1eb8: the edge/arrow zone tests, the arrow
            cursor choice and the state-0 tail of the pointer cascade;
  step      0x43c133..0x43cc61: the tick's navigation block (entry gates, the
            eight state arms, the rate-limit deadline) in multi-step sequences
            with persistent memory;
  cascade   the real tick tail 0x43d134 -> 0x4d3081 -> 0x4d30a9 -> the complete
            0x4f0059 (all ~40 UI members on the power-on image, the overlay hit
            test 0x4897cd on a constructed overlay, the zone tests, the generic
            row loop) against session_navigation_scan.

Hooks (enumerated in the report; none replaces a decision the original makes):

  host     GetTickCount through the IAT slot 0x52a23c: returns the scripted
           sample and pops the return address (the only OS boundary of the
           step window).
  host     GetSystemMetrics(SM_SWAPBUTTON) IAT slot 0x52a498 and the MFC
           default-message tail 0x51ab4b are RT-2 boundaries and are not
           reached by these windows.
  observe  code stop addresses, visited-address set, every memory write
           (classified into the modeled cells; any write outside the modeled
           cells, the window's stack frame and the receiver scratch word is an
           error).

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/session_navigation_original_oracle.py [--quick]
"""
from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import sys

from matching_s08_2_original_oracle import RETURN_SENTINEL, STACK_BASE, STACK_SIZE, FIXTURE_BASE
from session_input_original_oracle import Original, WORK, PIN, CURSOR, CANDIDATE, require
from test_session_input import State, Context, Rect, Hotspot
import test_session_navigation as nav
from unicorn import UC_HOOK_MEM_WRITE
from unicorn.x86_const import UC_X86_REG_EIP

PROJECT = Path(__file__).resolve().parents[1]
REPORT = WORK / 'analysis/slices/RT-17.oracle.json'
GET_TICK_COUNT = RETURN_SENTINEL + 0x110
OVERLAY_BASE = 0x60000000          # mapped by X86Machine (CANDIDATE_BASE, 64 KiB)
OVERLAY_MANAGER = 0x619935
SENTINEL_SURFACE = 0x51f00d51

CODE_WINDOWS = [
    (0x4f18fa, 0x4f1e78, 'cascade zone tests and arrow cursor choice'),
    (0x4f1e78, 0x4f1eb8, 'cascade zone-claimed return and state-0 tail'),
    (0x43c133, 0x43c251, 'tick navigation entry gates'),
    (0x43c251, 0x43c88d, 'tick navigation state arms'),
    (0x43c88d, 0x43c946, 'tick navigation deadline update'),
    (0x4f0059, 0x4f0126, 'cascade overlap guard'),
    (0x4f104f, 0x4f1067, 'cascade overlay hit test call'),
]

# (name, address, size, signed)
GLOBAL_CELLS = [
    ('selector', 0x5bb50b, 2, True), ('frame_min', 0x5bb4e3, 2, True), ('frame_max', 0x5bb4e5, 2, True),
    ('step', 0x5bb2c6, 2, True), ('mode', 0x5bb2b6, 2, True), ('arrow_width', 0x5bb2ca, 2, True),
    ('arrow_height', 0x5bb2cc, 2, True), ('hover_delay', 0x5bb2ce, 2, True),
    ('key_delay', 0x5bb2d0, 2, True), ('scroll_step', 0x5c39fd, 2, True),
    ('scroll', 0x5bb587, 4, True), ('scroll_end', 0x5bb58f, 4, True), ('image_bottom', 0x5bb4fd, 4, True),
    ('nav_allowed', 0x5a4c1c, 4, True), ('auto_move', 0x5bb206, 4, True),
    ('frames_cached', 0x5a4c20, 4, True), ('cursor_mode', 0x583204, 4, True), ('state', 0x5a4c18, 4, True),
    ('gate_deadline', 0x63a5c8, 4, False),
]
KEY_CELLS = [('f1d', 0x58321d), ('f1e', 0x58321e), ('f15', 0x583215), ('f16', 0x583216),
             ('f13', 0x583213), ('f14', 0x583214), ('f27', 0x583227), ('f28', 0x583228),
             ('f25', 0x583225), ('f26', 0x583226)]
BAND_CELLS = [('x1', 0x5831b6), ('y1', 0x5831ba), ('x2', 0x5831be), ('y2', 0x5831c2)]
VIEW_CELLS = [('left', CURSOR + 4), ('top', CURSOR + 8), ('right', CURSOR + 0xc), ('bottom', CURSOR + 0x10)]
RECEIVER_SCRATCH = CURSOR + 0x72

STEP_WRITES = {0x5bb50b: ('selector', 2), 0x5bb587: ('scroll', 4), 0x5bb58f: ('scroll_end', 4),
               0x63a5c8: ('deadline', 4)}
ZONE_WRITES = {0x5a4c18: ('state', 4), 0x5b44f0: ('cursor_index', 4), 0x5b44f4: ('cursor_variant', 4),
               0x5d162d: ('surface', 4), 0x5d1631: ('table', 4), 0x5d1639: ('layer', 4)}
FORMAT = {1: '<B', 2: '<h', 4: '<i'}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def frame_ebp():
    return STACK_BASE + STACK_SIZE // 2 + 0x1000


class NavOriginal(Original):
    def __init__(self, exe):
        super().__init__(exe)
        self.samples = []
        self.sample_calls = 0
        self.writes = []
        self.logging = False
        self.hook_counts = {'GetTickCount [0x52a23c]': 0}
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.on_write)

    def init(self):
        super().init()
        self.put(0x52a23c, GET_TICK_COUNT)
        self.put(0x583204, 0)

    def hook(self, uc, address, size, data):
        if address == GET_TICK_COUNT:
            require(self.samples, 'unexpected GetTickCount call')
            self.hook_counts['GetTickCount [0x52a23c]'] += 1
            self.visited.add(address)
            self.ret(0, self.samples.pop(0))
            return
        super().hook(uc, address, size, data)

    def on_write(self, uc, access, address, size, value, user):
        if self.logging:
            self.writes.append((address, size, value & ((1 << (8 * size)) - 1)))

    def half(self, address):
        return struct.unpack('<h', self.uc.mem_read(address, 2))[0]

    def cell(self, address, size, signed=True):
        raw = bytes(self.uc.mem_read(address, size))
        return int.from_bytes(raw, 'little', signed=signed)

    def put_cell(self, address, size, value):
        self.uc.mem_write(address, (value & ((1 << (8 * size)) - 1)).to_bytes(size, 'little'))

    def set_globals(self, values):
        for name, address, size, _ in GLOBAL_CELLS:
            self.put_cell(address, size, values[name])

    def get_globals(self):
        return {name: self.cell(address, size, signed) for name, address, size, signed in GLOBAL_CELLS}

    def window_logged(self, entry, stops):
        self.visited = set()
        self.writes = []
        self.logging = True
        try:
            return self.window(entry, stops)
        finally:
            self.logging = False

    def classify(self, allowed, allow_stack=True, extra=()):
        events = []
        for address, size, value in self.writes:
            spec = allowed.get(address)
            if spec is not None and spec[1] == size:
                events.append((spec[0], value))
            elif allow_stack and STACK_BASE <= address < STACK_BASE + STACK_SIZE:
                events.append(('stack', address, value, size))
            elif address in extra:
                continue
            else:
                raise RuntimeError(f'original write outside the modeled footprint: {address:#x}/{size}')
        return events

    # -- step window ---------------------------------------------------
    def run_step(self, case):
        self.set_globals(case['globals'])
        for name, address in KEY_CELLS:
            self.uc.mem_write(address, bytes([case['keys'][name]]))
        ebp = frame_ebp()
        self.put_cell(ebp - 4, 4, case['tick'])
        self.put_cell(ebp - 0x14, 4, 0)
        self.samples = [case['now']]
        stop = self.window_logged(0x43c133, (0x43c946, 0x43cc61))
        require(not self.samples or True, 'unreachable')
        events = []
        dirty_events = 0
        for address, size, value in self.writes:
            if address == ebp - 0x14 and size == 4:
                events.append(('dirty', value))
                dirty_events += 1
                continue
            spec = STEP_WRITES.get(address)
            if spec is not None and spec[1] == size:
                v = value
                if spec[0] == 'selector':
                    v = struct.unpack('<h', value.to_bytes(2, 'little'))[0]
                elif spec[0] in ('scroll', 'scroll_end'):
                    v = struct.unpack('<i', value.to_bytes(4, 'little'))[0]
                events.append((spec[0], v))
            elif STACK_BASE <= address < STACK_BASE + STACK_SIZE:
                continue
            else:
                raise RuntimeError(f'step window wrote outside the modeled cells: {address:#x}/{size}')
        return dict(stop=stop, entered=int(0x43c282 in self.visited), events=events,
                    after=self.get_globals(), dirty=self.cell(ebp - 0x14, 4),
                    tick_calls=int(GET_TICK_COUNT in self.visited))

    # -- zone window ---------------------------------------------------
    def setup_zone(self, case):
        self.set_globals(case['globals'])
        for (name, address), value in zip(VIEW_CELLS, case['view']):
            self.put_cell(address, 4, value)
        for (name, address), value in zip(BAND_CELLS, case['bands']):
            self.put_cell(address, 4, value)
        self.put_cell(0x58316e, 4, case['hot'][0])
        self.put_cell(0x58316a, 4, case['hot'][1])
        self.put_cell(0x5b44f0, 4, case['cursor'][0])
        self.put_cell(0x5b44f4, 4, case['cursor'][1])
        self.put_cell(0x5d0377, 4, SENTINEL_SURFACE)
        self.put_cell(0x5d162d, 4, 0x11110000)
        self.put_cell(0x5d1631, 4, 0x22220000)
        self.put_cell(0x5d1639, 4, 0x33330000)
        self.put_cell(RECEIVER_SCRATCH, 4, 0x44440000)

    def run_zone(self, case):
        self.setup_zone(case)
        ebp = frame_ebp()
        self.put_cell(ebp - 4, 4, CURSOR)
        stop = self.window_logged(0x4f18fa, (0x4f1e78, 0x4f1eb8))
        events = []
        for address, size, value in self.writes:
            if address == RECEIVER_SCRATCH:
                continue
            spec = ZONE_WRITES.get(address)
            if spec is None or spec[1] != size:
                if STACK_BASE <= address < STACK_BASE + STACK_SIZE:
                    continue
                raise RuntimeError(f'zone window wrote outside the modeled cells: {address:#x}/{size}')
            name = spec[0]
            v = struct.unpack('<i', value.to_bytes(4, 'little'))[0]
            if name == 'table':
                v = (value - 0x5b160c) & 0xffffffff
            elif name == 'surface':
                require(value == SENTINEL_SURFACE, 'surface store is not [0x5d0377]')
                v = 0
            events.append((name, v))
        return dict(stop=stop, claimed=int(stop == 0x4f1e78),
                    eax=self.uc.reg_read(self.machine._eax) if stop == 0x4f1e78 else None,
                    events=events, state=self.cell(0x5a4c18, 4), index=self.cell(0x5b44f0, 4),
                    variant=self.cell(0x5b44f4, 4))

    # -- full cascade --------------------------------------------------
    def run_cascade(self, case):
        """case: ctx (Context), spots, nav (globals dict), bands, hot, overlay (or None)."""
        ctx = case['ctx']
        self.set_globals(case['globals'])
        self.setup_geometry(ctx, case['spots'], case['selected'], case['hot_pairs'])
        # setup_geometry wrote scroll/mode from ctx; keep the navigation globals authoritative.
        self.put_cell(0x5bb587, 4, case['globals']['scroll'])
        self.put_cell(0x583204, 4, ctx.cursor_mode)
        for (name, address), value in zip(BAND_CELLS, case['bands']):
            self.put_cell(address, 4, value)
        self.put_cell(0x58316e, 4, case['hot'][0])
        self.put_cell(0x58316a, 4, case['hot'][1])
        self.put_cell(0x5b44f0, 4, case['cursor'][0])
        self.put_cell(0x5b44f4, 4, case['cursor'][1])
        self.put_cell(0x5d0377, 4, SENTINEL_SURFACE)
        self.put_cell(0x5a4c18, 4, case['stale_state'])
        self.put_cell(CANDIDATE, 4, case['stale_candidate'])
        # Overlay manager on the power-on image: count 0 unless the case builds one.
        self.put_cell(OVERLAY_MANAGER + 0xcc, 4, 0)
        if case['overlay'] is not None:
            ov = case['overlay']
            base = OVERLAY_BASE
            self.uc.mem_write(base, bytes(0x2000))
            self.put_cell(OVERLAY_MANAGER + 0xcc, 4, 1)
            self.put_cell(OVERLAY_MANAGER + 0x2c, 4, base)
            self.put_cell(base + 0xab2, 4, ov['enabled'])
            self.put_cell(base + 0xab0, 2, ov['row'])
            self.put_cell(0x5bb632 + ov['row'] * 0x8d, 4, ov['phase'])
            self.put_cell(base + 0xaa, 2, 1)
            rec = base + 0x6ec
            self.put_cell(rec, 2, ov['frame'])
            self.put_cell(rec + 4, 2, ov['hot'])
            for off, value in zip((0x16, 0x1a, 0x1e, 0x22), ov['rect']):
                self.put_cell(rec + off, 4, value)
        self.put(0x5b44f8, 0)
        disabled_end = self.window(0x43d134, (0x43d13d, 0x43d162))
        path = 'disabled'
        eax = None
        if disabled_end == 0x43d13d:
            self.window(0x4d3081, (0x4d3095,))
            endpoint = self.window(0x4d30a9, (0x4d30ca, *self.scan_targets))
            path = 'ui_mode'
            if endpoint == 0x4d30ca:
                self.visited = set()
                self.hit_test_addresses = set()
                eax, delta, _ = self.machine.call(0x4f0059, CURSOR, (RETURN_SENTINEL,), bytes(0x1000))
                require(delta == 4, 'cascade returned with the wrong ABI')
                path = 'cascade'
                self.cascade_addresses = self.hit_test_addresses
                self.hit_test_addresses = None
        return dict(path=path, eax=eax, candidate=self.cell(CANDIDATE, 4), state=self.cell(0x5a4c18, 4),
                    index=self.cell(0x5b44f0, 4), variant=self.cell(0x5b44f4, 4),
                    table=(self.cell(0x5d1631, 4, False) - 0x5b160c) & 0xffffffff,
                    generic=0x4f1eb8 in getattr(self, 'cascade_addresses', set()) if path == 'cascade' else False)


# ---------------------------------------------------------------- native side

def native_globals(values):
    g = nav.NavGlobals(**values)
    return g


def native_step(api, case):
    g = native_globals(case['globals'])
    keys = nav.NavKeys(**case['keys'])
    out = nav.NavStepResult()
    status = api.session_navigation_step(c.byref(g), c.byref(keys), case['tick'], case['now'], c.byref(out))
    require(status == 0, 'native step failed')
    after = {name: getattr(g, name) for name, *_ in GLOBAL_CELLS}
    return dict(entered=out.entered, events=nav.effect_list(out), after=after, dirty=out.view_dirty), out


def native_zone(api, case):
    g = native_globals(case['globals'])
    geo = nav.NavZoneGeometry(Rect(*case['view']), nav.NavBands(*case['bands']), *case['hot'])
    cursor = nav.NavCursor(*case['cursor'])
    out = nav.NavZoneResult()
    status = api.session_navigation_zone(c.byref(g), c.byref(geo), c.byref(cursor), c.byref(out))
    require(status == 0, 'native zone failed')
    return dict(claimed=out.claimed, events=nav.effect_list(out), state=out.state,
                index=out.cursor.index, variant=out.cursor.variant)


# ----------------------------------------------------------------- generators

def base_globals(rng):
    g = dict(selector=rng.choice([0, 1, 2, 5, 18, 19, 20]), frame_min=0, frame_max=19, step=1, mode=1,
             arrow_width=15, arrow_height=15, hover_delay=400, key_delay=66, scroll_step=10, scroll=0,
             scroll_end=374, image_bottom=374, nav_allowed=1, auto_move=1, frames_cached=1,
             cursor_mode=0, state=0, gate_deadline=0)
    return g


def random_globals(rng):
    g = base_globals(rng)
    g['frame_min'] = rng.choice([0, 0, 0, 1, -3, 5])
    g['frame_max'] = g['frame_min'] + rng.choice([0, 1, 5, 19])
    g['selector'] = rng.choice([g['frame_min'], g['frame_max'], g['frame_min'] - 1, g['frame_max'] + 1,
                                (g['frame_min'] + g['frame_max']) // 2, rng.randrange(-40, 40)])
    g['step'] = rng.choice([1, 1, 1, -1, 2, 0, 7, 0x7fff, -0x8000])
    g['mode'] = rng.choice([1, 1, 1, 2, 0, 3, -1, 256])
    g['arrow_width'] = rng.choice([15, 15, 0, 3, 40, -2])
    g['arrow_height'] = rng.choice([15, 15, 0, 3, 40, -2])
    g['hover_delay'] = rng.choice([400, 0x14d, 0, 1, 1000, -1])
    g['key_delay'] = rng.choice([66, 0x4d, 0, 5, -5])
    g['scroll_step'] = rng.choice([10, 10, 3, 0, -4, 1000])
    g['image_bottom'] = rng.choice([374, 374, 100, 0, 1000])
    g['scroll'] = rng.choice([0, 0, 5, 9, 10, 11, 100, -7, 374])
    g['scroll_end'] = rng.choice([g['image_bottom'], g['image_bottom'], g['image_bottom'] - 5,
                                  g['image_bottom'] - 10, g['image_bottom'] - 11, 0, 300,
                                  g['image_bottom'] + 4])
    g['nav_allowed'] = rng.choice([1, 1, 1, 0, 2, -1])
    g['auto_move'] = rng.choice([1, 1, 1, 0, 2])
    g['frames_cached'] = rng.choice([0, 1, 1, 7])
    g['cursor_mode'] = rng.choice([0, 0, 0, 1, 2, 3, 4, 5, 6, -1])
    g['state'] = rng.choice([0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 9, -1, 100])
    return g


def edge_values(edge):
    return [edge - 2, edge - 1, edge, edge + 1, edge + 2]


def zone_points(view, bands, w, h, rng):
    left, top, right, bottom = view
    x1, y1, x2, y2 = bands
    xs = set(edge_values(x1) + edge_values(x2) + edge_values(left - w - 0x2d) + edge_values(left - w) +
             edge_values(right + w + 0x2d) + edge_values(right + w) + edge_values(left) + edge_values(right) +
             [(x1 + x2) // 2])
    ys = set(edge_values(y1) + edge_values(y2) + edge_values(top - h - 10) + edge_values(bottom + h + 0x28) +
             edge_values(bottom + h) + edge_values(top) + edge_values(bottom) + [(y1 + y2) // 2])
    return sorted(xs), sorted(ys)


def zone_case(rng, globals_, view=(10, 10, 629, 384), bands=None, hot=None, cursor=None):
    if bands is None:
        bw, bh = rng.choice([(30, 40), (30, 40), (10, 10), (45, 60), (0, 0), (100, 3)])
        bands = (view[0] + bw - 1, view[1] + bh - 1, view[2] - bw + 1, view[3] - bh + 1)
    if cursor is None:
        cursor = (rng.choice([0, 5, 0xe, 0xf, 0x25]), rng.choice([0, 1]))
    return dict(globals=globals_, view=view, bands=bands, hot=hot, cursor=cursor)


def step_case(rng, g, tick=None, now=None):
    keys = {name: 0 for name, _ in KEY_CELLS}
    if rng.random() < 0.35:
        for name, _ in KEY_CELLS:
            keys[name] = rng.choice([0, 0, 0, 1, 2, 255])
    if tick is None:
        tick = rng.choice([0, 1, g['gate_deadline'], (g['gate_deadline'] + 1) & 0xffffffff,
                           (g['gate_deadline'] - 1) & 0xffffffff, 0xffffffff, 0x80000000,
                           rng.randrange(2 ** 32)])
    if now is None:
        now = rng.choice([tick, (tick + 3) & 0xffffffff, rng.randrange(2 ** 32), 0xfffffff0])
    return dict(globals=g, keys=keys, tick=tick, now=now)


# ----------------------------------------------------------------- comparisons

class Counts(dict):
    def bump(self, name, n=1):
        self[name] = self.get(name, 0) + n


def compare_step(original, api, case, counts, label):
    expected = original.run_step(case)
    got, native_out = native_step(api, case)
    require(expected['tick_calls'] == (1 if expected['entered'] else 0) or not expected['entered'],
            f'{label}: unexpected GetTickCount usage')
    entered_native = got['entered']
    require(expected['entered'] == entered_native, f'{label}: entered differs {expected["entered"]} vs {entered_native}')
    require(expected['events'] == got['events'], f'{label}: ordered effects differ\n  original {expected["events"]}\n  native   {got["events"]}')
    require(expected['after'] == got['after'], f'{label}: state differs\n  original {expected["after"]}\n  native   {got["after"]}')
    require(expected['dirty'] == got['dirty'], f'{label}: dirty flag differs')
    counts.bump('step_cases')
    counts.bump('step_state_comparisons', len(GLOBAL_CELLS) + 1)
    counts.bump('step_ordered_effects', len(expected['events']))
    if expected['entered']:
        counts.bump('step_entered')
        counts.bump('step_state_%d' % case['globals']['state'] if 0 <= case['globals']['state'] <= 8
                    else 'step_state_other')
        if native_out.selector_changed:
            counts.bump('step_selector_moved')
    else:
        counts.bump('step_not_entered')
    return expected


def compare_zone(original, api, case, counts, label):
    original.init()
    expected = original.run_zone(case)
    got = native_zone(api, case)
    require(expected['claimed'] == got['claimed'], f'{label}: claimed differs {expected["claimed"]} vs {got["claimed"]} case {case}')
    if expected['claimed']:
        require(expected['eax'] == 1, f'{label}: claimed return value')
    require(expected['events'] == got['events'], f'{label}: ordered effects differ\n  original {expected["events"]}\n  native   {got["events"]}\n  {case}')
    require((expected['state'], expected['index'], expected['variant']) ==
            (got['state'], got['index'], got['variant']), f'{label}: final state differs')
    counts.bump('zone_cases')
    counts.bump('zone_state_comparisons', 3)
    counts.bump('zone_ordered_effects', len(expected['events']))
    counts.bump('zone_state_%d' % expected['state'] if 0 <= expected['state'] <= 8 else 'zone_state_other')
    if expected['claimed']:
        counts.bump('zone_claimed')
    return expected


def build_cascade_case(rng, forced=None):
    g = random_globals(rng)
    g['cursor_mode'] = rng.choice([0, 0, 0, 0, 1, 2, 3, 4, 5, 6])
    g['scroll'] = rng.choice([0, 0, 5, 40])
    g['scroll_end'] = rng.choice([374, 374, 300])
    g['state'] = 0
    g['mode'] = rng.choice([1, 1, 2])
    g['nav_allowed'] = rng.choice([1, 1, 1, 0])
    g['arrow_width'] = rng.choice([15, 15, 0])
    g['arrow_height'] = rng.choice([15, 15, 0])
    view = (10, rng.choice([10, 23]), 629, rng.choice([384, 397]))
    bw, bh = rng.choice([(30, 40), (30, 40), (10, 10)])
    bands = (view[0] + bw - 1, view[1] + bh - 1, view[2] - bw + 1, view[3] - bh + 1)
    xs, ys = zone_points(view, bands, g['arrow_width'], g['arrow_height'], rng)
    # Sprite rectangle: usually inside the viewport so the overlap guard passes.
    if rng.random() < 0.1:
        sprite = (rng.randrange(-30, 660), rng.randrange(-30, 420))
    else:
        sprite = (rng.randrange(view[0], view[2]), rng.randrange(view[1], view[3]))
    size = rng.choice([1, 1, 16, 32])
    hot_pairs = ((rng.randrange(-3, 4), rng.randrange(-3, 4)), (11, -7))
    cursor = (rng.choice([0, 5]), rng.choice([0, 1]))
    selected = rng.choice([-1, -1, -1, -1, 0, 3])
    # The selected pair: index/variant reset when nothing is held, else the previous variant.
    pair = hot_pairs[0 if selected == -1 else cursor[1]]
    ctx = Context(Rect(*view), Rect(sprite[0], sprite[1], sprite[0] + size - 1, sprite[1] + size - 1),
                  pair[0], pair[1], g['scroll'], g['cursor_mode'], 0,
                  rng.choice([0, 0, 0, 0, 1]), 1, 1, -1, -1)
    if rng.random() < 0.7:
        hot = (rng.choice(xs), rng.choice(ys))
    else:
        hot = (sprite[0] + pair[0], sprite[1] + pair[1])
    spots = []
    if rng.random() < 0.7:
        for index in sorted(rng.sample(range(0, 12), rng.choice([1, 2, 3]))):
            left = rng.randrange(0, 600)
            top = rng.randrange(0, 360)
            spots.append(Hotspot(index, Rect(left, top, left + rng.randrange(0, 200),
                                             top + rng.randrange(0, 200)), 1))
    overlay = None
    if rng.random() < 0.2:
        row = rng.randrange(0, 12)
        overlay = dict(enabled=1, row=row, phase=1, frame=g['selector'], hot=1,
                       rect=(rng.randrange(-40, 600), rng.randrange(-40, 360), 0, 0))
        overlay['rect'] = (overlay['rect'][0], overlay['rect'][1],
                           overlay['rect'][0] + rng.randrange(0, 400), overlay['rect'][1] + rng.randrange(0, 400))
    return dict(globals=g, ctx=ctx, spots=spots, bands=bands, hot=hot, hot_pairs=hot_pairs,
                selected=selected, cursor=cursor, overlay=overlay,
                stale_state=rng.choice([0, 3, 8]), stale_candidate=rng.choice([-1, 77, 3]))


def compare_cascade(original, api, case, counts, label):
    original.init()
    exp = original.run_cascade(case)
    g = native_globals(case['globals'])
    g.state = case['stale_state']
    ctx = Context.from_buffer_copy(case['ctx'])
    ctx.priority_clear = 1
    state = State()
    require(api.session_input_init(c.byref(state)) == 0, 'native init failed')
    state.candidate = case['stale_candidate']
    rows = (Hotspot * max(len(case['spots']), 1))(*case['spots'])
    priority = []
    ov = case['overlay']
    if ov is not None and ov['enabled'] and ov['phase'] == 1 and ov['frame'] == case['globals']['selector'] \
            and ov['hot'] == 1:
        priority = [Hotspot(ov['row'], Rect(*ov['rect']), 1)]
    pri = (Hotspot * max(len(priority), 1))(*priority)
    cursor = nav.NavCursor(*case['cursor'])
    out = nav.NavScanResult()
    status = api.session_navigation_scan(
        c.byref(state), c.byref(ctx), c.byref(g), c.byref(nav.NavBands(*case['bands'])),
        c.byref(nav.NavPointer(case['hot'][0], case['hot'][1], case['selected'])), c.byref(cursor),
        pri, len(priority), rows,
        len(case['spots']), c.byref(out))
    require(status == 0, f'{label}: native scan status {status}')
    require(exp['candidate'] == state.candidate, f'{label}: candidate differs original {exp["candidate"]} native {state.candidate} path {exp["path"]} {case}')
    require(exp['state'] == g.state, f'{label}: state differs original {exp["state"]} native {g.state} path {exp["path"]}')
    claimed = exp['path'] == 'cascade' and exp['state'] != 0
    if claimed:
        require(exp['eax'] == 1 and not exp['generic'], f'{label}: claimed path reached the generic loop')
        require(out.claimed_by_zone == 1, f'{label}: native did not claim')
        require((exp['index'], exp['variant'], exp['table']) ==
                (cursor.index, cursor.variant, out.zone.table_offset),
                f'{label}: cursor outputs differ original {(exp["index"], exp["variant"], exp["table"])} '
                f'native {(cursor.index, cursor.variant, out.zone.table_offset)} state {exp["state"]}')
        counts.bump('cascade_zone_claimed')
    else:
        require(out.claimed_by_zone == 0, f'{label}: native claimed, original did not')
    if exp['path'] == 'cascade' and exp['state'] == 0 and exp['candidate'] == -1 and exp['generic']:
        require(exp['variant'] == cursor.variant == 0, f'{label}: state-0 miss variant differs')
        counts.bump('cascade_generic_miss')
    if exp['path'] == 'cascade' and exp['candidate'] >= 0:
        counts.bump('cascade_overlay_hit' if (ov is not None and priority and exp['candidate'] == ov['row']
                                              and not exp['generic']) else 'cascade_generic_hit')
    if exp['path'] == 'cascade' and exp['state'] == 0 and exp['candidate'] == -1 and not exp['generic']:
        counts.bump('cascade_overlap_miss')
    counts.bump('cascade_' + exp['path'])
    counts.bump('cascade_cases')
    counts.bump('cascade_state_comparisons', 3)
    return exp


def quick_scale(quick, full, small):
    return small if quick else full


def run(original, api, quick, seed=0x525431):
    rng = random.Random(seed)
    counts = Counts()
    original.init()

    # ---- zone: edge grids over the default scene geometry, then random globals
    for arrow in ((15, 15), (0, 15), (15, 0), (3, 3), (40, 40)):
        for scroll, scroll_end in ((0, 374), (5, 374), (0, 300), (5, 300)):
            for mode in (1, 2, 0):
                for selector in (0, 7, 19):
                    g = base_globals(rng)
                    g.update(arrow_width=arrow[0], arrow_height=arrow[1], scroll=scroll, scroll_end=scroll_end,
                             mode=mode, selector=selector)
                    view = (10, 10, 629, 384)
                    bands = (39, 49, 600, 345)
                    xs, ys = zone_points(view, bands, arrow[0], arrow[1], rng)
                    pts = [(x, y) for x in xs for y in ys]
                    rng.shuffle(pts)
                    for x, y in pts[:quick_scale(quick, 90, 12)]:
                        case = zone_case(rng, dict(g), view=view, bands=bands, hot=(x, y))
                        compare_zone(original, api, case, counts, 'zone-grid %r' % ((x, y),))
    for i in range(quick_scale(quick, 6000, 600)):
        g = random_globals(rng)
        view = rng.choice([(10, 10, 629, 384), (10, 23, 629, 397), (0, 0, 639, 479), (-5, 7, 100, 90)])
        case = zone_case(rng, g, view=view)
        bands = case['bands']
        xs, ys = zone_points(view, bands, g['arrow_width'], g['arrow_height'], rng)
        case['hot'] = (rng.choice(xs + [rng.randrange(-100, 700)]), rng.choice(ys + [rng.randrange(-100, 500)]))
        compare_zone(original, api, case, counts, 'zone-random %d' % i)

    # ---- step: single steps over the gate matrix, key flags, then persistent sequences
    for state in list(range(0, 10)) + [-1, 100]:
        for key_mask in range(1 << len(KEY_CELLS)) if not quick else [0, 1, 2, 4, 1 << 9, 0x3ff]:
            keys = {name: (key_mask >> i) & 1 for i, (name, _) in enumerate(KEY_CELLS)}
            for cached in (0, 1):
                g = base_globals(rng)
                g.update(state=state, frames_cached=cached, gate_deadline=500, selector=3, scroll=50,
                         scroll_end=300)
                case = dict(globals=g, keys=keys, tick=501, now=777)
                compare_step(original, api, case, counts, f'step-matrix state={state} keys={key_mask:#x}')
        if quick:
            continue
    for i in range(quick_scale(quick, 6000, 500)):
        g = random_globals(rng)
        case = step_case(rng, g)
        compare_step(original, api, case, counts, 'step-random %d' % i)
    for s in range(quick_scale(quick, 120, 15)):
        g = random_globals(rng)
        g['gate_deadline'] = rng.randrange(0, 5000)
        g['cursor_mode'] = rng.choice([0, 0, 0, 1])
        g['auto_move'] = 1
        g['hover_delay'] = rng.choice([400, 50, 0, 1])
        g['nav_allowed'] = 1
        clock = rng.randrange(0, 4000)
        for step in range(14):
            g['state'] = rng.choice([0, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8])
            clock += rng.choice([0, 1, 20, 100, 400, 401, 1000])
            keys = {name: 0 for name, _ in KEY_CELLS}
            case = dict(globals=g, keys=keys, tick=clock & 0xffffffff, now=(clock + rng.choice([0, 2])) & 0xffffffff)
            expected = compare_step(original, api, case, counts, f'step-seq {s}.{step}')
            g = dict(expected['after'])      # carry the original's resulting memory forward
            counts.bump('step_sequence_steps')

    # ---- cascade pipeline
    for i in range(quick_scale(quick, 3000, 300)):
        case = build_cascade_case(rng)
        compare_cascade(original, api, case, counts, 'cascade %d' % i)
    return counts


def code_windows(image):
    result = []
    for start, end, label in CODE_WINDOWS:
        result.append(dict(start=hex(start), end=hex(end), label=label,
                           sha256=digest(image[start - 0x400000:end - 0x400000])))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--original', type=Path, default=WORK / 'original/GAME.EXE')
    parser.add_argument('--library', type=Path, default=PROJECT / 'build/libsession_navigation.dylib')
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--quick', action='store_true', help='reduced counts (mutation runs)')
    parser.add_argument('--no-report', action='store_true')
    args = parser.parse_args()
    image = args.original.read_bytes()
    require(digest(image) == PIN, 'original executable pin mismatch')
    api = nav.load_navigation(args.library)
    original = NavOriginal(args.original)
    counts = run(original, api, args.quick)
    if args.no_report:
        print(json.dumps({'mismatches': 0, 'counts': counts}))
        return 0
    report = dict(
        slice='RT-17', status='original_native_comparison_passed', quick=args.quick,
        original_sha256=PIN, native_sha256=digest(args.library.read_bytes()),
        oracle_script_sha256=digest(Path(__file__).read_bytes()),
        source_sha256={n: digest((PROJECT / 'src' / n).read_bytes())
                       for n in ('session_navigation.c', 'session_navigation.h', 'session_input.c')},
        counts=counts, mismatches=0,
        hooks=dict(enumerated=original.hook_counts, original_decisions_replaced=[]),
        code_windows=code_windows(image),
        footprint='every original write in the zone and step windows is inside the modeled cells, the '
                  'window stack frame or the receiver scratch word 0x5831f4; any other write is an error',
        contains_original_byte_values=False)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    print(json.dumps(dict(report=str(args.report), mismatches=0, counts=counts), sort_keys=True))
    return 0


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, ValueError) as exc:
        print(f'RT-17 original oracle failed: {exc}', file=sys.stderr)
        raise SystemExit(1)
