"""RT-2 tests written before session_input.[ch]; original-layout producer contract."""
from __future__ import annotations
import ctypes as c
from pathlib import Path
import subprocess
import sys
import json
import hashlib
import unittest

PROJECT = Path(__file__).resolve().parents[1]

class Rect(c.Structure):
    _fields_ = [(name, c.c_int32) for name in ('left', 'top', 'right', 'bottom')]

class State(c.Structure):
    _fields_ = [('latch', c.c_uint8 * 32), ('candidate', c.c_int32)]

class Context(c.Structure):
    _fields_ = [('viewport', Rect), ('cursor', Rect)] + [
        (name, c.c_int32) for name in ('hot_x', 'hot_y', 'scroll_y', 'cursor_mode')
    ] + [(name, c.c_uint32) for name in ('modal_event', 'producer_disabled',
                                        'geometry_ready', 'priority_clear')] + [
        ('excluded_0', c.c_int32), ('excluded_1', c.c_int32)]

class Frame(c.Structure):
    _fields_ = [(name, c.c_int32) for name in ('current_frame', 'pointer_x', 'pointer_y')] + [
        (name, c.c_uint8) for name in ('pointer_valid', 'cursor_context_allowed',
                                     'modal_event_active', 'hotspot_activation_event')]

class Hotspot(c.Structure):
    _fields_ = [('index', c.c_int32), ('rectangle', Rect), ('active', c.c_uint32)]

TAIL = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.c_uint32, c.c_int32, c.c_int32)


def load_api(path):
    lib = c.CDLL(str(path))
    lib.session_input_init.argtypes = [c.POINTER(State)]
    lib.session_input_feed.argtypes = [c.POINTER(State), c.c_int, c.c_uint32,
                                      c.c_int32, c.c_int32, TAIL, c.c_void_p]
    lib.session_input_tick.argtypes = [c.POINTER(State), c.POINTER(Context), c.POINTER(Frame)]
    lib.session_input_scan.argtypes = [c.POINTER(State), c.POINTER(Context),
                                      c.POINTER(Hotspot), c.c_size_t]
    lib.session_input_publish_candidate.argtypes = [c.POINTER(State), c.c_int32]
    for name in ('init', 'feed', 'tick', 'scan', 'publish_candidate'):
        getattr(lib, 'session_input_' + name).restype = c.c_int
    return lib


def context(x=440, y=255):
    # Explicit composed-cursor snapshot; no inference of sprite geometry from messages.
    return Context(Rect(10, 10, 629, 384), Rect(x, y, x + 15, y + 15),
                   0, 0, 0, 0, 0, 0, 1, 1, -1, -1)


def word(state, offset):
    return int.from_bytes(bytes(state.latch[offset:offset + 4]), 'little')


class SessionInputTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run([str(PROJECT / 'scripts/build_session_input.sh')], check=True)
        cls.api = load_api(PROJECT / 'build/libsession_input.dylib')

    def setUp(self):
        self.state = State()
        self.assertEqual(self.api.session_input_init(c.byref(self.state)), 0)
        self.ctx = context()
        self.effects = []
        self.tail = TAIL(lambda _, kind, flags, x, y: self.effects.append(
            (kind, flags, x, y, bytes(self.state.latch))))

    def feed(self, kind, x=440, y=255):
        self.assertEqual(self.api.session_input_feed(c.byref(self.state), kind, 0,
                                                     x, y, self.tail, None), 0)

    def tick(self):
        f = Frame(7, 9, 9, 9, 9, 9, 9)
        self.assertEqual(self.api.session_input_tick(c.byref(self.state), c.byref(self.ctx),
                                                     c.byref(f)), 0)
        self.assertEqual(f.current_frame, 7)
        return f

    def scan(self, *spots):
        rows = (Hotspot * len(spots))(*spots)
        self.assertEqual(self.api.session_input_scan(c.byref(self.state), c.byref(self.ctx),
                                                     rows, len(rows)), 0)

    def arm(self):
        self.scan(Hotspot(34, Rect(388, 225, 492, 284), 1))
        self.assertEqual(self.state.candidate, 34)

    def test_viewport_offset_hot_point_scroll(self):
        self.ctx.hot_x, self.ctx.hot_y, self.ctx.scroll_y = 3, -2, 19
        f = self.tick()
        self.assertEqual((f.pointer_x, f.pointer_y), (433, 262))
        self.assertEqual(f.pointer_valid, 1)

    def test_outside_and_inclusive_sprite_overlap(self):
        self.ctx.cursor = Rect(-6, 10, 9, 25)
        self.assertEqual(self.tick().pointer_valid, 0)
        self.ctx.cursor.right = 10
        self.assertEqual(self.tick().pointer_valid, 1)
        # Validity uses sprite intersection, not the hot point or nonnegative messages.
        self.ctx.hot_x = -100
        self.assertLess(self.tick().pointer_x, 0)
        self.assertEqual(self.tick().pointer_valid, 1)

    def test_move_without_button_raw_coordinates_tail_order(self):
        self.feed(0, -123, 456)
        self.assertEqual((word(self.state, 24), word(self.state, 28)),
                         (0xffffff85, 456))
        self.assertEqual(self.effects[0][-1], bytes(self.state.latch))
        self.assertEqual(self.tick().hotspot_activation_event, 0)
        # Tick uses the displayed cursor snapshot, not the WM_MOUSEMOVE latch.
        self.assertEqual(self.tick().pointer_x, 430)

    def test_down_without_up(self):
        self.arm(); self.feed(1)
        self.assertEqual(word(self.state, 12), 1)
        self.assertEqual(self.tick().hotspot_activation_event, 0)
        self.assertEqual(word(self.state, 12), 1)

    def test_up_without_down_requires_candidate_not_down(self):
        self.feed(2)
        self.assertEqual(self.tick().hotspot_activation_event, 0)
        self.arm(); self.feed(2)
        self.assertEqual(word(self.state, 12), 0)
        self.assertEqual(self.tick().hotspot_activation_event, 1)

    def test_release_outside_retains_candidate_until_cursor_scan(self):
        self.arm(); self.feed(1); self.feed(0, 0, 0); self.feed(2, 0, 0)
        # Message coordinates do not re-hit-test or clear the retained candidate.
        self.ctx.cursor = Rect(0, 0, 15, 15)
        self.assertEqual(self.tick().hotspot_activation_event, 1)
        self.scan(Hotspot(34, Rect(388, 225, 492, 284), 1))
        self.assertEqual(self.state.candidate, -1)
        self.feed(2)
        self.assertEqual(self.tick().hotspot_activation_event, 0)

    def test_cursor_mode_and_modal_consume_before_guards(self):
        for mode in (0, 1, 2, 3, 4, 5, 6, -1):
            self.arm(); self.feed(2); self.ctx.cursor_mode = mode
            f = self.tick()
            self.assertEqual(f.cursor_context_allowed, int(mode not in (2, 3, 4, 5)))
            self.assertEqual(f.hotspot_activation_event, int(mode not in (2, 3, 4, 5)))
            self.assertEqual(word(self.state, 0), 0)
            self.ctx.cursor_mode = 0
        self.arm(); self.feed(2); self.ctx.modal_event = 0xffffffff
        f = self.tick()
        self.assertEqual((f.hotspot_activation_event, f.modal_event_active), (1, 1))
        self.assertEqual(self.tick().hotspot_activation_event, 0)

    def test_edge_clear_and_repeated_release(self):
        self.arm(); self.feed(1); self.feed(2); self.feed(2)
        self.assertEqual((word(self.state, 0), word(self.state, 12)), (1, 2))
        self.assertEqual(self.tick().hotspot_activation_event, 1)
        self.assertEqual((word(self.state, 0), word(self.state, 12)), (0, 0))
        self.assertEqual(self.tick().hotspot_activation_event, 0)
        self.feed(2)
        self.assertEqual(self.tick().hotspot_activation_event, 1)

    def test_down_cancels_unconsumed_release_and_inhibit(self):
        self.arm(); self.feed(2); self.feed(1)
        self.assertEqual(self.tick().hotspot_activation_event, 0)
        self.state.latch[8] = 1
        self.feed(2)
        self.assertEqual(self.tick().hotspot_activation_event, 0)

    def test_first_hit_and_excluded_slots(self):
        a = Hotspot(3, Rect(430, 245, 430, 245), 1)
        b = Hotspot(5, Rect(0, 0, 600, 300), 1)
        self.scan(a, b)
        self.assertEqual(self.state.candidate, 3)
        self.ctx.excluded_0 = 3
        rows = (Hotspot * 2)(a, b)
        self.assertEqual(self.api.session_input_scan(c.byref(self.state), c.byref(self.ctx),
                                                     rows, 2), 3)
        self.assertEqual(self.state.candidate, 3)
        a.active = 0
        self.scan(a, b)
        self.assertEqual(self.state.candidate, 5)
        self.ctx.producer_disabled = 1
        self.scan(a, b)
        self.assertEqual(self.state.candidate, -1)

    def test_named_limits_are_atomic_and_do_not_consume(self):
        self.arm(); self.feed(2)
        for field, status in (('geometry_ready', 2), ('priority_clear', 3)):
            setattr(self.ctx, field, 0)
            before = bytes(self.state)
            f = Frame(5, 6, 7, 8, 9, 10, 11)
            old = bytes(f)
            self.assertEqual(self.api.session_input_tick(c.byref(self.state), c.byref(self.ctx),
                                                         c.byref(f)), status)
            self.assertEqual((bytes(self.state), bytes(f)), (before, old))
            setattr(self.ctx, field, 1)
        self.assertEqual(self.tick().hotspot_activation_event, 1)

    def test_malformed_arguments_and_rectangles(self):
        self.assertEqual(self.api.session_input_init(None), 1)
        self.assertEqual(self.api.session_input_feed(c.byref(self.state), 77, 0, 0, 0,
                                                     self.tail, None), 1)
        before = bytes(self.state)
        rows = (Hotspot * 2)(Hotspot(5, Rect(0, 0, 999999, 999999), 1),
                             Hotspot(4, Rect(0, 0, 1, 1), 1))
        self.assertEqual(self.api.session_input_scan(c.byref(self.state), c.byref(self.ctx),
                                                     rows, 2), 1)
        self.assertEqual(bytes(self.state), before)

    def test_wrapping_coordinate_arithmetic(self):
        self.ctx.cursor = Rect(2147483640, 0, 2147483647, 15)
        self.ctx.viewport = Rect(-2147483648, 0, 2147483647, 50)
        self.ctx.hot_x = 100
        self.assertEqual(self.tick().pointer_x, 92)

def run_sanitizer():
    evidence = PROJECT.parents[1] / 'work/analysis/slices'
    source = evidence / 'RT-2.sanitizer.c'
    binary = evidence / 'RT-2.sanitizer'
    source.write_text(r"""
#include "session_input.h"
#include <assert.h>
#include <limits.h>
#include <stdint.h>
#include <string.h>
static uint32_t seed = 0x525432;
static uint32_t random_word(void) {
    seed ^= seed << 13; seed ^= seed >> 17; seed ^= seed << 5; return seed;
}
static int32_t signed_word(void) {
    uint32_t u = random_word(); int32_t s; memcpy(&s, &u, 4); return s;
}
int main(void) {
    SessionInputState state, before;
    SessionInputContext context;
    SceneExecutorFrameInput frame, old_frame;
    SessionInputHotspot spots[241];
    assert(session_input_init(NULL) == SESSION_INPUT_INVALID_ARGUMENT);
    assert(session_input_init(&state) == 0);
    for (size_t n = 0; n < 50000; ++n) {
        memset(&context, 0, sizeof(context));
        context.viewport = (SessionInputRect){10, 10, 629, 384};
        int32_t x = signed_word(), y = signed_word();
        context.cursor = (SessionInputRect){x, y, x, y};
        context.hot_x = signed_word(); context.hot_y = signed_word();
        context.scroll_y = signed_word(); context.cursor_mode = signed_word();
        context.modal_event = random_word(); context.producer_disabled = random_word() % 2;
        context.geometry_ready = random_word() % 2; context.priority_clear = random_word() % 2;
        context.excluded_0 = -1; context.excluded_1 = -1;
        if (n % 5 == 0) context.cursor = (SessionInputRect){440,255,455,270};
        if (n % 11 == 0) context.viewport.left = INT32_MAX;
        if (n % 13 == 0) context.cursor_mode = (int32_t)(random_word() % 7);
        if (n % 3 == 0) assert(session_input_publish_candidate(&state, (int32_t)(random_word() % 242) - 1) == 0);
        if (n % 7 == 0) state.latch[8] = (uint8_t)(random_word() % 2);
        before = state;
        int event = (int)(random_word() % 6) - 1;
        int status = session_input_feed(&state, (SessionInputEvent)event,
                                       random_word(), x, y, NULL, NULL);
        if (status != 0) assert(memcmp(&state, &before, sizeof(state)) == 0);
        memset(&frame, 0x7a, sizeof(frame)); old_frame = frame; before = state;
        status = session_input_tick(&state, &context, &frame);
        assert(frame.current_frame == old_frame.current_frame);
        if (status != 0) {
            assert(memcmp(&state, &before, sizeof(state)) == 0);
            assert(memcmp(&frame, &old_frame, sizeof(frame)) == 0);
        }
        size_t count = random_word() % 242;
        for (size_t i = 0; i < 241; ++i) {
            spots[i].index = (int32_t)i;
            spots[i].rectangle = (SessionInputRect){-32768,-32768,32767,32767};
            spots[i].active = random_word();
        }
        if (n % 17 == 0) spots[0].index = -1;
        if (n % 19 == 0) spots[0].rectangle.left = INT32_MIN;
        before = state;
        status = session_input_scan(&state, &context, spots, count);
        if (status != 0) assert(memcmp(&state, &before, sizeof(state)) == 0);
        before = state;
        status = session_input_tick(&state, &context, (SceneExecutorFrameInput *)&state);
        assert(status == SESSION_INPUT_INVALID_ARGUMENT);
        assert(memcmp(&state, &before, sizeof(state)) == 0);
        assert(session_input_tick(NULL, &context, &frame) == SESSION_INPUT_INVALID_ARGUMENT);
        assert(session_input_scan(&state, NULL, spots, 0) == SESSION_INPUT_INVALID_ARGUMENT);
        assert(session_input_publish_candidate(NULL, 0) == SESSION_INPUT_INVALID_ARGUMENT);
    }
    return 0;
}
""")
    command = ['xcrun', 'clang', '-std=c11', '-O1', '-g', '-Wall', '-Wextra',
               '-Wpedantic', '-Werror', '-fsanitize=address,undefined',
               '-fno-sanitize-recover=all', '-I', str(PROJECT / 'src'), str(source),
               *[str(PROJECT / 'src' / name) for name in
                 ('session_input.c', 'input_latch.c', 'input_consume.c')],
               '-o', str(binary)]
    subprocess.run(command, check=True, capture_output=True, text=True)
    result = subprocess.run([str(binary)], check=True, capture_output=True, text=True)
    if result.stderr:
        raise RuntimeError(result.stderr)
    report = {'iterations': 50000, 'sanitizers': ['address', 'undefined'],
              'errors': 0, 'command': command,
              'runner_source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest()}
    (evidence / 'RT-2.sanitizer.json').write_text(json.dumps(report, indent=2) + '\n')
    print('RT-2 ASan/UBSan: 50000 bounded malformed iterations, no errors')


if __name__ == '__main__':
    if sys.argv[1:] == ['--sanitize']:
        run_sanitizer()
    else:
        unittest.main()
