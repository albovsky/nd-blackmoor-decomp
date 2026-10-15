"""RT-22 follow-up: the task bar and its inventory button (0x570508, chunk TASK).

Original facts under test (GAME.EXE, SHA-256 afd337a2...485c45):
 * layout: chunk +0x31 bounds, five 0x162-byte records at +0x61 (rect at +0x96.., origin added
   only with the relative flag +0xa6, delay +0xba, sound +0xbe/+0xdf);
 * hover 0x4e075a/0x4e22fd: bar-bounds cursor (4, 0), hot point added, inclusive rectangle test,
   first hit wins, state 1 on a hit, back to 0 on a miss, event 0x27d8 and variant 1 with the
   cursor flag, nothing for pressed or disabled buttons;
 * click 0x4e0978/0x4e26fc: hovered + no pending flag + state 0/1 -> state 2, deadline =
   now + delay, sound requested; a hovered locked button swallows the click;
 * process 0x4e0e2b/0x4e29ec/0x4e2913: first call loads, the next call starts the buttons, a
   press completes strictly after its deadline and once its sound is idle, the flag byte
   (button 1 -> 0x583232) lasts until the next process call;
 * locks 0x4e18e5: kind 1 locks, kind 2 unlocks a locked button, kind 0 locks while the scene
   request is inside any [lo, hi] range (the all-zero power-on table locks scene 0 only).
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / 'build/libinventorybutton_runtime.dylib'
BOOT = ROOT / 'work/analysis/cif-boot-native.bin'
OK, ARGUMENT, FORMAT, HOST = 0, 1, 2, 3
EVENT_BUTTON = 0x27d8


def library_path():
    return Path(os.environ.get('INVBUTTON_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'INVBUTTON_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_inventory_button_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class ButtonLayout(c.Structure):
    _fields_ = [('id', c.c_int32), ('rect', c.c_int32 * 4), ('relative', c.c_int32),
                ('hover_changes_state', c.c_int32), ('cursor_flag', c.c_int32),
                ('initial_state', c.c_int32), ('delay_ms', c.c_uint32), ('has_sound', c.c_uint8),
                ('sound_name', c.c_char * 10), ('sound_slot', c.c_uint16)]


class Layout(c.Structure):
    _fields_ = [('bounds', c.c_int32 * 4), ('button', ButtonLayout * 5)]


class Lock(c.Structure):
    _fields_ = [('kind', c.c_int32), ('lo', c.c_int16 * 50), ('hi', c.c_int16 * 50)]


class Button(c.Structure):
    _fields_ = [('state', c.c_int32), ('stage', c.c_int32), ('hovered', c.c_uint8),
                ('click_flag', c.c_uint8), ('deadline', c.c_uint32)]


class Bar(c.Structure):
    _fields_ = [('state', c.c_int32), ('button', Button * 5), ('lock', Lock * 5),
                ('flag', c.c_uint8 * 5), ('event', c.c_int32), ('cursor_index', c.c_int32),
                ('cursor_variant', c.c_int32), ('hover_id', c.c_int32)]


HotspotFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32, c.c_int32, c.POINTER(c.c_int32),
                        c.POINTER(c.c_int32))
SoundFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_char_p, c.c_uint16)
BusyFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16, c.POINTER(c.c_int))


class Host(c.Structure):
    _fields_ = [('hotspot', HotspotFn), ('request_sound', SoundFn), ('sound_busy', BusyFn),
                ('context', c.c_void_p)]


class HoverResult(c.Structure):
    _fields_ = [('ran', c.c_uint8), ('cursor_index', c.c_int32), ('cursor_variant', c.c_int32),
                ('cursor_forced', c.c_uint8), ('x', c.c_int32), ('y', c.c_int32),
                ('hit', c.c_int32), ('event', c.c_int32)]


class ClickResult(c.Structure):
    _fields_ = [('ran', c.c_uint8), ('pressed', c.c_int32), ('locked_click', c.c_int32),
                ('sound_requested', c.c_uint8)]


class ProcessResult(c.Structure):
    _fields_ = [('loaded', c.c_uint8), ('flags_cleared', c.c_uint8), ('flag_set', c.c_uint8 * 5),
                ('completed', c.c_uint8 * 5)]


def task_chunk():
    data = BOOT.read_bytes()
    pos = 12
    while pos + 8 <= len(data):
        tag, size = data[pos:pos + 4], int.from_bytes(data[pos + 4:pos + 8], 'big')
        if tag == b'TASK':
            return data[pos + 8:pos + 8 + size]
        pos += 8 + size + (size & 1)
    raise AssertionError('no TASK chunk')


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.taskbar_layout_from_task.argtypes = [c.c_char_p, c.c_size_t, c.c_int32, c.c_int32,
                                             c.POINTER(Layout)]
    lib.taskbar_init.argtypes = [c.POINTER(Bar), c.POINTER(Layout)]
    lib.taskbar_apply_locks.argtypes = [c.POINTER(Bar), c.c_int16]
    lib.taskbar_hover.argtypes = [c.POINTER(Bar), c.POINTER(Layout), c.POINTER(c.c_int32),
                                  c.POINTER(Host), c.POINTER(HoverResult)]
    lib.taskbar_click.argtypes = [c.POINTER(Bar), c.POINTER(Layout), c.c_uint32, c.POINTER(Host),
                                  c.POINTER(ClickResult)]
    lib.taskbar_process.argtypes = [c.POINTER(Bar), c.POINTER(Layout), c.c_int16, c.c_uint32,
                                    c.POINTER(Host), c.POINTER(ProcessResult)]
    return lib


class Fixture:
    """The real TASK chunk, origin (10, 10), a host recording sounds and a settable busy flag."""
    def __init__(self, lib, chunk=None, hot=(9, 9), sound_fail=False):
        self.lib = lib
        self.sounds = []
        self.busy = 0
        self.hot_calls = []
        self.layout = Layout()
        data = chunk if chunk is not None else task_chunk()
        assert lib.taskbar_layout_from_task(data, len(data), 10, 10, c.byref(self.layout)) == OK
        self.bar = Bar()
        assert lib.taskbar_init(c.byref(self.bar), c.byref(self.layout)) == OK
        self.hot = hot

        def hotspot(_ctx, index, variant, dx, dy):
            self.hot_calls.append((index, variant))
            dx[0], dy[0] = self.hot
            return 0

        def sound(_ctx, name, slot):
            self.sounds.append((name, slot))
            return 1 if sound_fail else 0

        def busy(_ctx, slot, out):
            out[0] = self.busy
            return 0

        self._cb = (HotspotFn(hotspot), SoundFn(sound), BusyFn(busy))
        self.host = Host(self._cb[0], self._cb[1], self._cb[2], None)

    def hover(self, x, y, w=1, h=1):
        rect = (c.c_int32 * 4)(x, y, x + w - 1, y + h - 1)
        r = HoverResult()
        status = self.lib.taskbar_hover(c.byref(self.bar), c.byref(self.layout), rect,
                                        c.byref(self.host), c.byref(r))
        return status, r

    def click(self, now):
        r = ClickResult()
        status = self.lib.taskbar_click(c.byref(self.bar), c.byref(self.layout), now,
                                        c.byref(self.host), c.byref(r))
        return status, r

    def process(self, now, scene=6410):
        r = ProcessResult()
        status = self.lib.taskbar_process(c.byref(self.bar), c.byref(self.layout), scene, now,
                                          c.byref(self.host), c.byref(r))
        return status, r

    def start(self, scene=6410):
        """The first two process calls of the game: load, then start the buttons."""
        assert self.process(0, scene)[0] == OK
        assert self.process(1, scene)[0] == OK

    def center(self, i):
        r = self.layout.button[i].rect
        return (r[0] + r[2]) // 2 - self.hot[0], (r[1] + r[3]) // 2 - self.hot[1]


class TaskbarLayoutTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_real_chunk_layout(self):
        fx = Fixture(self.lib)
        self.assertEqual(list(fx.layout.bounds), [0, 385, 639, 479])
        self.assertEqual([tuple(b.rect) for b in fx.layout.button],
                         [(21, 424, 125, 472), (182, 419, 243, 479), (290, 419, 351, 479),
                          (399, 419, 460, 479), (514, 424, 618, 472)])
        for i, b in enumerate(fx.layout.button):
            self.assertEqual((b.id, b.relative, b.hover_changes_state, b.cursor_flag,
                              b.initial_state, b.delay_ms, b.has_sound, b.sound_name,
                              b.sound_slot), (i, 0, 1, 1, 0, 200, 1, b'Click01', 3))

    def test_relative_flag_adds_the_origin_and_no_sound_name_clears_the_sound(self):
        chunk = bytearray(task_chunk())
        base = 0x61 + 0x162   # record 1
        chunk[base + 0xa6] = 1
        chunk[base + 0xbe:base + 0xc7] = b'NO SOUND\x00'
        chunk[0x61 + 3 * 0x162 + 0xbe:0x61 + 3 * 0x162 + 0xc7] = b'NO XOUND\x00'   # not the marker
        chunk[0x61 + 4 * 0x162 + 0xbe:0x61 + 4 * 0x162 + 0xc7] = b'NO SOUND\x01'   # NUL matters
        fx = Fixture(self.lib, bytes(chunk))
        self.assertEqual(tuple(fx.layout.button[1].rect), (192, 429, 253, 489))
        self.assertEqual(tuple(fx.layout.button[2].rect), (290, 419, 351, 479))
        self.assertEqual([b.has_sound for b in fx.layout.button], [1, 0, 1, 1, 1])

    def test_short_chunk_and_null_arguments_are_rejected(self):
        out = Layout()
        chunk = task_chunk()
        self.assertEqual(self.lib.taskbar_layout_from_task(chunk, len(chunk) - 1, 0, 0,
                                                           c.byref(out)), FORMAT)
        self.assertEqual(self.lib.taskbar_layout_from_task(None, 0, 0, 0, c.byref(out)), ARGUMENT)
        self.assertEqual(self.lib.taskbar_layout_from_task(chunk, len(chunk), 0, 0, None), ARGUMENT)
        self.assertEqual(self.lib.taskbar_init(None, c.byref(out)), ARGUMENT)


class TaskbarHoverTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_hover_does_nothing_until_the_bar_is_running(self):
        fx = Fixture(self.lib)
        x, y = fx.center(1)
        status, r = fx.hover(x, y)
        self.assertEqual((status, r.ran, r.hit, r.event), (OK, 0, -1, -1))
        self.assertEqual(fx.bar.button[1].hovered, 0)

    def test_hit_on_the_inventory_button_sets_state_event_and_cursor(self):
        fx = Fixture(self.lib)
        fx.start()
        x, y = fx.center(1)
        status, r = fx.hover(x, y)
        self.assertEqual((status, r.ran, r.hit, r.event), (OK, 1, 1, EVENT_BUTTON))
        self.assertEqual((r.cursor_index, r.cursor_variant, r.cursor_forced), (4, 1, 1))
        self.assertEqual((r.x, r.y), (x + 9, y + 9))
        self.assertEqual(fx.hot_calls[-1], (4, 0))      # the hot point is taken after the bar cursor
        self.assertEqual((fx.bar.button[1].state, fx.bar.button[1].hovered), (1, 1))
        self.assertEqual(fx.bar.hover_id, 1)

    def test_rectangle_is_inclusive_and_uses_the_hot_point(self):
        fx = Fixture(self.lib, hot=(0, 0))
        fx.start()
        for x, y, hit in ((182, 419, 1), (243, 479, 1), (181, 450, -1), (244, 450, -1),
                          (200, 418, -1)):
            with self.subTest(x=x, y=y):
                self.assertEqual(fx.hover(x, y)[1].hit, hit)

    def test_cursor_outside_the_bar_bounds_keeps_the_previous_cursor(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.cursor_index, fx.bar.cursor_variant = 7, 1
        status, r = fx.hover(100, 100)
        self.assertEqual((r.cursor_forced, r.cursor_index, r.hit), (0, 7, -1))
        self.assertEqual(fx.hot_calls[-1], (7, 1))
        # a cursor rectangle that sticks out of the bottom of the bar is not "inside"
        status, r = fx.hover(200, 470, 1, 20)
        self.assertEqual(r.cursor_forced, 0)

    def test_bar_bounds_are_inclusive_on_every_side(self):
        fx = Fixture(self.lib)
        fx.start()
        for (x, y, w, h), forced in (((0, 385, 1, 1), 1), ((639, 479, 1, 1), 1),
                                     ((639, 450, 2, 1), 0), ((100, 479, 1, 2), 0),
                                     ((0, 384, 1, 1), 0), ((-1, 400, 1, 1), 0)):
            with self.subTest(rect=(x, y, w, h)):
                self.assertEqual(fx.hover(x, y, w, h)[1].cursor_forced, forced)

    def test_miss_returns_a_hovered_button_to_normal(self):
        fx = Fixture(self.lib)
        fx.start()
        x, y = fx.center(1)
        fx.hover(x, y)
        self.assertEqual(fx.bar.button[1].state, 1)
        status, r = fx.hover(5, 5)
        self.assertEqual((r.hit, fx.bar.button[1].state, fx.bar.button[1].hovered), (-1, 0, 0))
        self.assertEqual(r.event, -1)

    def test_pressed_and_disabled_buttons_never_report_a_hit(self):
        fx = Fixture(self.lib)
        fx.start()
        x, y = fx.center(1)
        for state in (2, 4):
            with self.subTest(state=state):
                fx.bar.button[1].state = state
                fx.bar.button[1].hovered = 1
                self.assertEqual(fx.hover(x, y)[1].hit, -1)
                self.assertEqual((fx.bar.button[1].state, fx.bar.button[1].hovered), (state, 0))

    def test_locked_button_hits_without_changing_state(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.button[1].state = 3
        x, y = fx.center(1)
        r = fx.hover(x, y)[1]
        self.assertEqual((r.hit, r.event, fx.bar.button[1].state), (1, EVENT_BUTTON, 3))

    def test_first_overlapping_button_wins_and_later_ones_are_not_tested(self):
        chunk = bytearray(task_chunk())
        base = 0x61 + 2 * 0x162                    # record 2 gets record 1's rectangle
        chunk[base + 0x96:base + 0xa6] = chunk[0x61 + 0x162 + 0x96:0x61 + 0x162 + 0xa6]
        fx = Fixture(self.lib, bytes(chunk), hot=(0, 0))
        fx.start()
        fx.bar.button[3].hovered = 1               # a stale flag behind the hit survives
        r = fx.hover(200, 450)[1]
        self.assertEqual(r.hit, 1)
        self.assertEqual((fx.bar.button[2].hovered, fx.bar.button[3].hovered), (0, 1))

    def test_hover_without_a_host_hotspot_is_rejected(self):
        fx = Fixture(self.lib)
        fx.start()
        host = Host()
        rect = (c.c_int32 * 4)(1, 1, 1, 1)
        r = HoverResult()
        self.assertEqual(self.lib.taskbar_hover(c.byref(fx.bar), c.byref(fx.layout), rect,
                                                c.byref(host), c.byref(r)), ARGUMENT)


class TaskbarClickAndProcessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def press_inventory(self, fx, now=100):
        x, y = fx.center(1)
        self.assertEqual(fx.hover(x, y)[1].hit, 1)
        status, r = fx.click(now)
        self.assertEqual(status, OK)
        return r

    def test_click_without_a_running_bar_or_a_hover_does_nothing(self):
        fx = Fixture(self.lib)
        r = fx.click(10)[1]
        self.assertEqual((r.ran, r.pressed), (0, -1))
        fx.start()
        r = fx.click(10)[1]
        self.assertEqual((r.ran, r.pressed, r.locked_click), (1, -1, -1))
        self.assertEqual(fx.sounds, [])

    def test_press_sets_state_deadline_and_requests_the_sound(self):
        fx = Fixture(self.lib)
        fx.start()
        r = self.press_inventory(fx, now=1000)
        self.assertEqual((r.pressed, r.sound_requested), (1, 1))
        self.assertEqual((fx.bar.button[1].state, fx.bar.button[1].deadline), (2, 1200))
        self.assertEqual(fx.sounds, [(b'Click01', 3)])
        self.assertEqual(sum(fx.bar.flag), 0)

    def test_second_click_while_pressed_or_with_a_pending_flag_is_ignored(self):
        fx = Fixture(self.lib)
        fx.start()
        self.press_inventory(fx)
        x, y = fx.center(1)
        fx.bar.button[1].hovered = 1                # a stale flag, as the loop leaves it
        self.assertEqual(fx.click(101)[1].pressed, -1)
        fx.bar.button[1].state, fx.bar.button[1].click_flag = 0, 1
        self.assertEqual(fx.click(102)[1].pressed, -1)
        self.assertEqual(len(fx.sounds), 1)

    def test_locked_button_swallows_the_click_without_a_press(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.button[1].state = 3
        x, y = fx.center(1)
        fx.hover(x, y)
        r = fx.click(5)[1]
        self.assertEqual((r.pressed, r.locked_click), (-1, 1))
        self.assertEqual((fx.bar.button[1].state, fx.sounds), (3, []))

    def test_press_completes_strictly_after_the_deadline_and_sets_the_inventory_flag(self):
        fx = Fixture(self.lib)
        fx.start()
        self.press_inventory(fx, now=1000)
        for now in (1100, 1199, 1200):              # not yet: needs now > deadline
            status, r = fx.process(now)
            self.assertEqual((status, sum(r.flag_set), fx.bar.button[1].state), (OK, 0, 2))
        status, r = fx.process(1201)
        self.assertEqual((status, list(r.completed), list(r.flag_set)), (OK, [0, 1, 0, 0, 0], [0, 1, 0, 0, 0]))
        self.assertEqual((fx.bar.button[1].state, list(fx.bar.flag)), (0, [0, 1, 0, 0, 0]))
        # the byte lasts until the next process call, which clears it and sets nothing
        status, r = fx.process(1300)
        self.assertEqual((sum(r.flag_set), list(fx.bar.flag), r.flags_cleared), (0, [0] * 5, 1))

    def test_busy_sound_defers_completion(self):
        fx = Fixture(self.lib)
        fx.start()
        self.press_inventory(fx, now=0)
        fx.busy = 1
        self.assertEqual(sum(fx.process(500)[1].flag_set), 0)
        self.assertEqual(fx.bar.button[1].state, 2)
        fx.busy = 0
        self.assertEqual(list(fx.process(501)[1].flag_set), [0, 1, 0, 0, 0])

    def test_first_two_process_calls_load_and_start_the_buttons(self):
        fx = Fixture(self.lib)
        status, r = fx.process(0)
        self.assertEqual((status, r.loaded, fx.bar.state, fx.bar.button[1].stage), (OK, 1, 1, 0))
        status, r = fx.process(1)
        self.assertEqual((r.loaded, fx.bar.button[1].stage), (0, 1))
        # a press made before the buttons started cannot complete in the stage-0 call
        x, y = fx.center(1)
        fx.hover(x, y)
        fx.bar.button[2].stage = 0
        fx.click(1)
        fx.bar.button[1].stage = 0
        fx.bar.button[1].deadline = 0
        self.assertEqual(sum(fx.process(10)[1].flag_set), 0)
        self.assertEqual(sum(fx.process(11)[1].flag_set), 1)

    def test_each_button_produces_its_own_flag_byte(self):
        for i in range(5):
            with self.subTest(button=i):
                fx = Fixture(self.lib, hot=(0, 0))
                fx.start()
                x, y = fx.center(i)
                self.assertEqual(fx.hover(x, y)[1].hit, i)
                self.assertEqual(fx.click(0)[1].pressed, i)
                fx.process(300)
                expected = [0] * 5
                expected[i] = 1
                self.assertEqual(list(fx.bar.flag), expected)

    def test_failed_sound_request_is_a_host_error_after_the_press(self):
        fx = Fixture(self.lib, sound_fail=True)
        fx.start()
        x, y = fx.center(1)
        fx.hover(x, y)
        self.assertEqual(fx.click(0)[0], HOST)

    def test_state_two_clears_the_flags_only(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.state = 2
        fx.bar.flag[1] = 1
        status, r = fx.process(5)
        self.assertEqual((status, list(fx.bar.flag), r.flags_cleared, sum(r.flag_set)), (OK, [0] * 5, 1, 0))


class TaskbarLockTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def locked(self, fx):
        return [fx.bar.button[i].state == 3 for i in range(5)]

    def test_power_on_table_locks_scene_zero_only(self):
        fx = Fixture(self.lib)
        fx.start(scene=0)
        self.assertEqual(self.locked(fx), [True] * 5)
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), 6410)
        self.assertEqual(self.locked(fx), [False] * 5)
        self.assertEqual([fx.bar.button[i].state for i in range(5)], [0] * 5)

    def test_kind_one_locks_kind_two_unlocks_only_locked_buttons(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.lock[1].kind = 1
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), 6410)
        self.assertEqual(self.locked(fx), [False, True, False, False, False])
        fx.bar.lock[1].kind = 2
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), 6410)
        self.assertEqual(self.locked(fx), [False] * 5)
        fx.bar.button[1].state = 1                  # kind 2 leaves an unlocked button alone
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), 6410)
        self.assertEqual(fx.bar.button[1].state, 1)

    def test_ranges_are_inclusive_signed_and_release_when_left(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.lock[1].lo[3], fx.bar.lock[1].hi[3] = 6410, 6412
        for scene, expect in ((6409, False), (6410, True), (6412, True), (6413, False)):
            with self.subTest(scene=scene):
                fx.lib.taskbar_apply_locks(c.byref(fx.bar), scene)
                self.assertEqual(fx.bar.button[1].state == 3, expect)
        fx.bar.lock[1].lo[3], fx.bar.lock[1].hi[3] = -5, -1
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), -3)
        self.assertEqual(fx.bar.button[1].state, 3)

    def test_apply_locks_overrides_a_pressed_button_like_the_original(self):
        fx = Fixture(self.lib)
        fx.start()
        fx.bar.lock[1].kind = 1
        fx.bar.button[1].state = 2
        fx.lib.taskbar_apply_locks(c.byref(fx.bar), 6410)
        self.assertEqual(fx.bar.button[1].state, 3)


if __name__ == '__main__':
    unittest.main()
