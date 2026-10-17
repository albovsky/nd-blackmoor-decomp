"""RT-22: inventory view (open, hover, pick up, put back) kernel tests.

Original facts under test (GAME.EXE, SHA-256 afd337a2...485c45):
 * hover 0x4e89eb/0x4e8bb4: hot := -1, event 0x2717 while nothing is held (0x2718
   otherwise), first slot whose rectangle contains the pointer wins
   (x in [left+11, right], y in [top+10, bottom-10]); slots before it are
   un-highlighted, slots after it are untouched;
 * click 0x4e8e78: pick up = held := hot, remove from the list (0x4ea06c), sound 0x17,
   close when view byte +0x7011 is set; put back = add(held, 1), held := -1, sound 0x14;
 * the read/examine and use branches are recovered as conditions only.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

import test_action_family_78_runtime as t78
from test_action_family_78_runtime import (
    World78, Model78, Host78, SoundFn, UiFn, CAPACITY, OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST)

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / 'build/libinventoryview_runtime.dylib'
BOOT = ROOT / 'work/analysis/cif-boot-native.bin'
UNMODELED, TAB = 5, 6

t78.EFFECT_NAMES.update({0x40: 'pick', 0x41: 'put', 0x42: 'view_sound', 0x43: 'close'})

CloseFn = c.CFUNCTYPE(c.c_int, c.c_void_p)


def library_path():
    return Path(os.environ.get('INVVIEW_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'INVVIEW_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_inventory_view_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class Layout(c.Structure):
    _fields_ = [('relative', c.c_int32), ('slot_flag', c.c_uint8), ('close_flag', c.c_uint8),
                ('first_tab', c.c_int32), ('rect', (c.c_int32 * 4) * 16)]


class View(c.Structure):
    _fields_ = [(n, c.c_int32) for n in
                ('screen_state', 'mode', 'tab', 'tab_applied', 'page', 'hot', 'event',
                 'cursor_variant')] + [('slot_item', c.c_int32 * 16), ('slot_lit', c.c_int32 * 16)]


class ItemData(c.Structure):
    _fields_ = [('kind', c.POINTER(c.c_int16)), ('text', c.POINTER(c.c_int16)),
                ('aux_a', c.POINTER(c.c_uint32)), ('aux_b', c.POINTER(c.c_uint32)),
                ('aux_count', c.c_size_t)]


class ViewHost(c.Structure):
    _fields_ = [('inventory', Host78), ('request_sound', SoundFn), ('close_view', CloseFn),
                ('context', c.c_void_p), ('examine', c.c_void_p)]   # RT-43: NULL keeps the UNMODELED read branch


class ClickResult(c.Structure):
    _fields_ = [(n, c.c_uint8) for n in
                ('gate_open', 'handled', 'picked', 'put_back', 'closed', 'sound_requests',
                 'removed', 'added')]

    def tuple(self):
        return tuple(getattr(self, n) for n, _ in self._fields_)


def uiiv_chunk():
    data = BOOT.read_bytes()
    pos = 12
    while pos + 8 <= len(data):
        tag, size = data[pos:pos + 4], int.from_bytes(data[pos + 4:pos + 8], 'big')
        if tag == b'UIIV':
            return data[pos + 8:pos + 8 + size]
        pos += 8 + size + (size & 1)
    raise AssertionError('no UIIV chunk')


def inv_chunk():
    data = BOOT.read_bytes()
    pos = 12
    while pos + 8 <= len(data):
        tag, size = data[pos:pos + 4], int.from_bytes(data[pos + 4:pos + 8], 'big')
        if tag == b'INV\x00':
            return data[pos + 8:pos + 8 + size]
        pos += 8 + size + (size & 1)
    raise AssertionError('no INV chunk')


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.inventory_view_layout_from_uiiv.argtypes = [c.c_char_p, c.c_size_t, c.c_int32, c.c_int32,
                                                    c.POINTER(Layout)]
    lib.inventory_view_items_from_inv.argtypes = [c.c_char_p, c.c_size_t, c.POINTER(c.c_int16),
                                                  c.POINTER(c.c_int16)]
    lib.inventory_view_init.argtypes = [c.POINTER(View)]
    lib.inventory_view_rebuild.argtypes = [c.POINTER(View), c.POINTER(t78.Model),
                                           c.POINTER(c.c_char_p)]
    lib.inventory_view_open.argtypes = [c.POINTER(View), c.POINTER(Layout), c.POINTER(c.c_int)]
    lib.inventory_view_hover.argtypes = [c.POINTER(View), c.POINTER(Layout), c.c_int32, c.c_int32,
                                         c.c_int16, c.c_int, c.POINTER(c.c_int)]
    lib.inventory_view_cursor_choice.argtypes = [c.c_int16, c.c_int32, c.c_int32,
                                                 c.POINTER(c.c_int32), c.POINTER(c.c_int32)]
    lib.inventory_view_cursor_hotspot.argtypes = [c.c_char_p, c.c_size_t, c.c_int32, c.c_int32,
                                                  c.POINTER(c.c_int32), c.POINTER(c.c_int32)]
    lib.inventory_view_slot_hit.argtypes = [c.POINTER(Layout), c.c_size_t, c.c_int32, c.c_int32]
    lib.inventory_view_click.argtypes = [c.POINTER(View), c.POINTER(Layout), c.POINTER(ItemData),
                                         c.POINTER(Model78), c.POINTER(ViewHost), c.c_int,
                                         c.POINTER(ClickResult), c.POINTER(c.c_char_p)]
    lib.inventory_view_close.argtypes = [c.POINTER(View)]
    return lib


class Fixture:
    """An open inventory view over a World78, with the real UIIV layout (origin 10,10)."""
    def __init__(self, lib, items=(), held=-1, kind=None, text=None, aux_a=None, aux_b=None,
                 providers=True, close_status=0, view_sound_status=0, **world_kw):
        self.lib = lib
        self.world = World78(items, held=held, providers=providers, mode=2, slot_flag=1,
                             **world_kw)
        self.layout = Layout()
        assert lib.inventory_view_layout_from_uiiv(uiiv_chunk(), 2860, 10, 10,
                                                   c.byref(self.layout)) == 0
        self.view = View()
        lib.inventory_view_init(c.byref(self.view))
        self.kind = (c.c_int16 * 70)(*(kind or [0] * 70))
        self.text = (c.c_int16 * 70)(*(text or [0] * 70))
        self.aux_a = (c.c_uint32 * 70)(*(aux_a or [0] * 70))
        self.aux_b = (c.c_uint32 * 70)(*(aux_b or [0] * 70))
        self.data = ItemData(c.cast(self.kind, c.POINTER(c.c_int16)),
                             c.cast(self.text, c.POINTER(c.c_int16)),
                             c.cast(self.aux_a, c.POINTER(c.c_uint32)),
                             c.cast(self.aux_b, c.POINTER(c.c_uint32)), 70)
        self.closed_calls = 0
        log = self.world.log
        status = [close_status, view_sound_status]

        @SoundFn
        def view_sound(_ctx, slot):
            log.append(('view_sound_call', slot))
            return status[1]

        @CloseFn
        def close_view(_ctx):
            log.append(('close_call',))
            return status[0]

        self.keep = (view_sound, close_view)
        self.host = ViewHost(self.world.host, view_sound if providers else SoundFn(),
                             close_view if providers else CloseFn(), None)
        self.rebuild()

    def rebuild(self):
        failure = c.c_char_p()
        return self.lib.inventory_view_rebuild(c.byref(self.view), c.byref(self.world.model.inventory),
                                               c.byref(failure))

    def open(self):
        opened = c.c_int()
        status = self.lib.inventory_view_open(c.byref(self.view), c.byref(self.layout),
                                              c.byref(opened))
        return status, opened.value

    def hover(self, x, y, frame_consumed=0):
        ran = c.c_int()
        status = self.lib.inventory_view_hover(c.byref(self.view), c.byref(self.layout), x, y,
                                               self.world.held.value, frame_consumed, c.byref(ran))
        return status, ran.value

    def center(self, slot):
        r = self.layout.rect[slot]
        return (r[0] + r[2]) // 2, (r[1] + r[3]) // 2

    def click(self, frame_consumed=0, with_host=True):
        result, failure = ClickResult(), c.c_char_p()
        status = self.lib.inventory_view_click(
            c.byref(self.view), c.byref(self.layout), c.byref(self.data),
            c.byref(self.world.model), c.byref(self.host) if with_host else None,
            frame_consumed, c.byref(result), c.byref(failure))
        return status, result, failure.value


class LayoutTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_real_uiiv_layout_with_the_view_origin(self):
        layout = Layout()
        self.assertEqual(self.lib.inventory_view_layout_from_uiiv(uiiv_chunk(), 2860, 10, 10,
                                                                  c.byref(layout)), 0)
        self.assertEqual((layout.relative, layout.slot_flag, layout.close_flag, layout.first_tab),
                         (1, 1, 1, 100))
        self.assertEqual(list(layout.rect[0]), [27, 74, 88, 133])   # 17,64,78,123 + 10
        self.assertEqual(list(layout.rect[5]), [99, 144, 160, 203])
        self.assertEqual(list(layout.rect[15]), [243, 284, 304, 343])

    def test_unrelated_origin_is_added_to_the_rectangles(self):
        layout = Layout()
        self.lib.inventory_view_layout_from_uiiv(uiiv_chunk(), 2860, -3, 7, c.byref(layout))
        self.assertEqual(list(layout.rect[0]), [14, 71, 75, 130])

    def test_relative_flag_zero_keeps_the_rectangles(self):
        chunk = bytearray(uiiv_chunk())
        chunk[0x67:0x6b] = b'\0\0\0\0'
        layout = Layout()
        self.lib.inventory_view_layout_from_uiiv(bytes(chunk), 2860, 10, 10, c.byref(layout))
        self.assertEqual(list(layout.rect[0]), [17, 64, 78, 123])

    def test_layout_rejects_short_chunk_and_nulls(self):
        layout = Layout()
        self.assertEqual(self.lib.inventory_view_layout_from_uiiv(uiiv_chunk(), 2859, 0, 0,
                                                                  c.byref(layout)), ARGUMENT)
        self.assertEqual(self.lib.inventory_view_layout_from_uiiv(None, 2860, 0, 0,
                                                                  c.byref(layout)), ARGUMENT)

    def test_item_records_give_the_kind_and_text_words(self):
        kind, text = (c.c_int16 * 70)(), (c.c_int16 * 70)()
        self.assertEqual(self.lib.inventory_view_items_from_inv(inv_chunk(), 25727, kind, text), 0)
        self.assertEqual((kind[23], text[23]), (0, 0))      # Tutorial01
        self.assertEqual(self.lib.inventory_view_items_from_inv(inv_chunk(), 25726, kind, text),
                         ARGUMENT)

    def test_slot_hit_margins(self):
        layout = Layout()
        self.lib.inventory_view_layout_from_uiiv(uiiv_chunk(), 2860, 10, 10, c.byref(layout))
        hit = lambda x, y: self.lib.inventory_view_slot_hit(c.byref(layout), 0, x, y)   # noqa: E731
        # rect 27,74,88,133: x in [38, 88], y in [84, 123]
        self.assertEqual([hit(37, 100), hit(38, 100), hit(88, 100), hit(89, 100)], [0, 1, 1, 0])
        self.assertEqual([hit(60, 83), hit(60, 84), hit(60, 123), hit(60, 124)], [0, 1, 1, 0])
        self.assertEqual(self.lib.inventory_view_slot_hit(c.byref(layout), 16, 60, 100), 0)

    def test_slot_hit_margin_adds_wrap_in_32_bits_like_the_original(self):
        # left + 11 and bottom - 10 are 32-bit add/sub; they wrap instead of being UB.
        layout = Layout()
        layout.rect[0][:] = [0x7fffffff, 0, 0x7fffffff, 100]
        hit = lambda x, y: self.lib.inventory_view_slot_hit(c.byref(layout), 0, x, y)   # noqa: E731
        # left + 11 wraps to INT32_MIN + 10 = -0x7ffffff6
        self.assertEqual([hit(-0x7ffffff7, 50), hit(-0x7ffffff6, 50), hit(0x7fffffff, 50)], [0, 1, 1])
        layout.rect[0][:] = [0, 0, 100, -0x7ffffffe]     # bottom - 10 wraps to 0x7ffffff8
        self.assertEqual([hit(50, 0x7ffffff8), hit(50, 0x7ffffff9)], [1, 0])


class ViewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_rebuild_fills_slots_from_the_list_and_clears_the_rest(self):
        f = Fixture(self.lib, [23, 5, 9])
        self.assertEqual(list(f.view.slot_item), [23, 5, 9] + [-1] * 13)

    def test_rebuild_sign_extends_list_words_and_stops_at_the_count(self):
        f = Fixture(self.lib, [0xffff, 4, 8], count=2)
        self.assertEqual(list(f.view.slot_item[:4]), [-1, 4, -1, -1])

    def test_rebuild_limits_slots_to_one_page(self):
        f = Fixture(self.lib, list(range(20)))
        self.assertEqual(list(f.view.slot_item), list(range(16)))

    def test_rebuild_refuses_tab_lists_that_are_not_modelled(self):
        f = Fixture(self.lib, [1])
        f.view.tab = 0x65
        self.assertEqual(f.rebuild(), TAB)

    def test_open_enters_state_three_mode_two_with_the_first_tab(self):
        f = Fixture(self.lib, [23])
        self.assertEqual(f.open(), (OK, 1))
        self.assertEqual((f.view.screen_state, f.view.mode, f.view.tab, f.view.tab_applied),
                         (3, 2, 100, 100))
        self.assertEqual(f.open(), (OK, 0))     # state already 3: nothing happens

    def test_hover_requires_the_open_view(self):
        f = Fixture(self.lib, [23])
        self.assertEqual(f.hover(*f.center(0)), (OK, 0))
        self.assertEqual(f.view.hot, -1)

    def test_hover_picks_the_first_hit_and_leaves_later_slots_alone(self):
        f = Fixture(self.lib, [23, 5, 9])
        f.open()
        f.view.slot_lit[2] = 1                         # stale highlight behind the hit
        f.view.slot_lit[0] = 1
        self.assertEqual(f.hover(*f.center(1)), (OK, 1))
        self.assertEqual((f.view.hot, f.view.event, f.view.cursor_variant), (5, 0x2717, 1))
        self.assertEqual(list(f.view.slot_lit[:3]), [0, 1, 1])   # 0 cleared, 2 untouched

    def test_hover_miss_and_inactive_slots(self):
        f = Fixture(self.lib, [23])
        f.open()
        f.hover(*f.center(1))                           # slot 1 is empty (-1)
        self.assertEqual(f.view.hot, -1)
        f.hover(0, 0)
        self.assertEqual((f.view.hot, f.view.event), (-1, 0x2717))

    def test_hover_resets_the_cursor_variant_before_the_scan(self):
        # RT-22 oracle finding: 0x4ee2a9 stores variant 0 into 0x5b44f4 on every path
        # before the hover (or the frame control) looks at the pointer; only a hit sets 1.
        f = Fixture(self.lib, [23])
        f.open()
        f.hover(*f.center(0))
        self.assertEqual(f.view.cursor_variant, 1)
        f.hover(0, 0)                                   # a miss: the stale 1 must go
        self.assertEqual(f.view.cursor_variant, 0)
        f.hover(*f.center(0))
        self.assertEqual(f.view.cursor_variant, 1)
        f.hover(*f.center(0), frame_consumed=1)         # consumed: 0x4ee2a9 ran, scan did not
        self.assertEqual(f.view.cursor_variant, 0)
        f.view.cursor_variant = 1
        f.view.mode = 0                                 # gate closed: 0x4ee2a9 never ran
        f.hover(0, 0)
        self.assertEqual(f.view.cursor_variant, 1)

    def test_hover_consumed_by_the_frame_changes_nothing(self):
        f = self.opened_one()
        f.view.hot = 77
        self.assertEqual(f.hover(*f.center(0), frame_consumed=1), (OK, 0))
        self.assertEqual(f.view.hot, 77)

    def opened_one(self):
        f = Fixture(self.lib, [23])
        f.open()
        return f

    def test_cursor_choice_and_hotspot(self):
        index, variant = c.c_int32(), c.c_int32()
        for held, override, flag, expect in ((-1, 0, 0, 4), (-1, 1, 1, 4), (5, 1, 0, 4),
                                             (5, 0, 1, 9), (23, 0, 0, 60)):
            self.lib.inventory_view_cursor_choice(held, override, flag, c.byref(index),
                                                  c.byref(variant))
            self.assertEqual((index.value, variant.value), (expect, 0))
        data = BOOT.read_bytes()
        pos = 12
        while data[pos:pos + 4] != b'CURS':
            size = int.from_bytes(data[pos + 4:pos + 8], 'big')
            pos += 8 + size + (size & 1)
        curs = data[pos + 8:pos + 8 + 8580]
        dx, dy = c.c_int32(), c.c_int32()
        self.assertEqual(self.lib.inventory_view_cursor_hotspot(curs, 8580, 4, 0, c.byref(dx),
                                                                c.byref(dy)), 0)
        self.assertEqual((dx.value, dy.value), (9, 9))
        self.assertEqual(self.lib.inventory_view_cursor_hotspot(curs, 8580, 107, 0, c.byref(dx),
                                                                c.byref(dy)), ARGUMENT)
        self.assertEqual(self.lib.inventory_view_cursor_hotspot(curs, 8579, 4, 0, c.byref(dx),
                                                                c.byref(dy)), ARGUMENT)

    def test_hover_event_follows_the_held_item(self):
        f = Fixture(self.lib, [5], held=23)
        f.open()
        f.hover(*f.center(0))
        self.assertEqual((f.view.hot, f.view.event), (5, 0x2718))


class ClickTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def opened(self, items, **kw):
        f = Fixture(self.lib, items, **kw)
        f.open()
        return f

    def test_pick_up_the_tutorial_item(self):
        f = self.opened([23])
        f.hover(*f.center(0))
        status, r, _ = f.click()
        self.assertEqual(status, OK)
        held, count, words, presence = f.world.snapshot()
        self.assertEqual((held, count, presence[23]), (23, 0, 0))
        self.assertEqual(r.tuple(), (1, 1, 1, 0, 1, 1, 1, 0))
        # held is stored first, then 0x4ea06c (count, list not copied for an empty result,
        # presence, rebuild), then the sound request and the close.
        names = f.world.names()
        self.assertEqual(names[:4], ['pick', 'held', 'visit', 'count79'])
        self.assertEqual(names[-4:], ['view_sound', 'view_sound_call', 'close', 'close_call'])
        self.assertIn(('view_sound_call', 0x17), f.world.log)
        rebuild = f.world.calls('rebuild_call')[0]
        self.assertEqual(rebuild[2][0], 23)              # held already stored at the rebuild
        self.assertEqual((f.view.screen_state, f.view.mode, f.view.tab), (0, 0, -1))
        self.assertTrue(f.world.guards_intact())

    def test_pick_up_the_middle_item_compacts_the_list(self):
        f = self.opened([3, 23, 9])
        f.hover(*f.center(1))
        status, r, _ = f.click()
        held, count, words, presence = f.world.snapshot()
        self.assertEqual((status, held, count), (OK, 23, 2))
        self.assertEqual(list(words[:3]), [3, 9, 9])     # stale last word stays
        self.assertEqual((presence[3], presence[9], presence[23]), (1, 1, 0))

    def test_close_flag_zero_keeps_the_view_open(self):
        f = self.opened([23])
        f.layout.close_flag = 0
        f.hover(*f.center(0))
        status, r, _ = f.click()
        self.assertEqual((status, r.closed, f.view.screen_state), (OK, 0, 3))
        self.assertNotIn('close', f.world.names())

    def test_click_without_a_hit_does_nothing(self):
        f = self.opened([23])
        f.hover(0, 0)
        status, r, _ = f.click()
        self.assertEqual((status, r.tuple()), (OK, (1, 0, 0, 0, 0, 0, 0, 0)))
        self.assertEqual(f.world.log, [])
        self.assertEqual(f.world.held.value, -1)

    def test_click_while_the_view_is_closed_or_consumed_is_ignored(self):
        f = Fixture(self.lib, [23])
        f.hover(*f.center(0))
        self.assertEqual(f.click()[1].tuple(), (0,) * 8)
        f.open()
        f.hover(*f.center(0))
        status, r, _ = f.click(frame_consumed=1)
        self.assertEqual((status, r.tuple(), f.world.log), (OK, (0,) * 8, []))

    def test_aux_flag_blocks_the_pick_up(self):
        aux = [0] * 70
        aux[23] = 1
        f = self.opened([23], aux_a=aux)
        f.hover(*f.center(0))
        status, r, _ = f.click()
        self.assertEqual((status, r.handled, f.world.held.value, f.world.log), (OK, 0, -1, []))

    def test_put_back_adds_the_item_last_in_the_open_view(self):
        f = self.opened([5], held=23)
        f.hover(*f.center(0))
        self.assertEqual(f.view.event, 0x2718)
        status, r, _ = f.click()
        held, count, words, presence = f.world.snapshot()
        self.assertEqual((status, held, count, presence[23]), (OK, -1, 2, 1))
        self.assertEqual(list(words[:3]), [5, 23, 0xffff])   # +0x7010 set, mode 2: item LAST
        self.assertEqual(r.tuple(), (1, 1, 0, 1, 0, 1, 0, 1))
        # add(held, 1): add_flagged, its own sound 0x17, count, list, presence, rebuild
        # (no UI animation in mode 2), then held := -1 and the view's sound 0x14.
        self.assertEqual(f.world.names(), [
            'put', 'add_flagged', 'sound', 'sound_call', 'count', 'list', 'presence', 'rebuild',
            'rebuild_call', 'held', 'view_sound', 'view_sound_call'])
        self.assertEqual(f.world.calls('view_sound_call'), [('view_sound_call', 0x14)])
        self.assertEqual(f.world.calls('ui_call'), [])

    def test_put_back_in_view_mode_3_puts_the_item_first_and_animates(self):
        # The add step reads the live view mode (+0x764c): only mode 2 with +0x7010 set
        # puts the item last, and only a mode other than 2 requests the UI animation
        # (found by the RT-22 oracle: the mutation "mode forced to 2" survived the unit tests).
        f = self.opened([5], held=23)
        f.view.mode = 3
        f.hover(*f.center(0))
        status, r, _ = f.click()
        self.assertEqual(status, OK)
        self.assertEqual(list(f.world.snapshot()[2][:3]), [23, 5, 0xffff])
        self.assertEqual(f.world.calls('ui_call'), [('ui_call', 1, 1, 0)])
        self.assertEqual(r.tuple(), (1, 1, 0, 1, 0, 1, 0, 1))

    def test_put_back_with_slot_flag_zero_puts_the_item_first(self):
        f = self.opened([5], held=23)
        f.layout.slot_flag = 0
        f.hover(*f.center(0))
        f.click()
        self.assertEqual(list(f.world.snapshot()[2][:3]), [23, 5, 0xffff])

    def test_put_back_of_a_listed_item_is_a_silent_add_then_clears_held(self):
        f = self.opened([23, 5], held=23)
        f.hover(*f.center(0))
        status, r, _ = f.click()
        self.assertEqual((status, f.world.held.value, f.world.snapshot()[1]), (OK, -1, 2))
        self.assertEqual(f.world.names(), ['put', 'add_flagged', 'duplicate', 'held', 'view_sound',
                                           'view_sound_call'])
        self.assertEqual(r.added, 0)

    def test_read_branch_is_reported_unmodeled_without_effects(self):
        kind, text = [0] * 70, [0] * 70
        kind[23], text[23] = 3, 5
        f = self.opened([23], kind=kind, text=text)
        f.hover(*f.center(0))
        status, r, why = f.click()
        self.assertEqual((status, f.world.log, f.world.held.value), (UNMODELED, [], -1))
        self.assertIn(b'0x4ea269', why)

    def test_read_branch_conditions(self):
        for text_word, aux, expect in ((0, 0, OK), (0x270f, 0, OK), (5, 1, OK), (5, 0, UNMODELED)):
            kind, text, aux_a = [0] * 70, [0] * 70, [0] * 70
            kind[23], text[23], aux_a[23] = 3, text_word, aux
            f = self.opened([23], kind=kind, text=text, aux_a=aux_a)
            f.hover(*f.center(0))
            self.assertEqual(f.click()[0], expect, (text_word, aux))

    def test_use_branch_is_reported_unmodeled(self):
        aux_a, aux_b = [0] * 70, [0] * 70
        aux_a[23] = aux_b[23] = 1
        f = self.opened([23], aux_a=aux_a, aux_b=aux_b)
        f.hover(*f.center(0))
        status, _, why = f.click()
        self.assertEqual((status, f.world.log), (UNMODELED, []))
        self.assertIn(b'0x4e8f6d', why)

    def test_rejections_leave_the_state_untouched(self):
        # hot item outside the 70-entry tables
        f = self.opened([23])
        f.view.hot = 70
        self.assertEqual(f.click()[0], BOUNDS)
        # presence array too small for the picked id: the remove step rejects, held restored
        f = self.opened([23], held=-1)
        f.world.model.inventory.presence_capacity = 10
        f.hover(*f.center(0))
        status, _, _ = f.click()
        self.assertEqual((status, f.world.held.value, f.world.log), (BOUNDS, -1, [('pick', 23), ('held', 23)]))
        self.assertEqual(f.world.snapshot()[1], 1)

    def test_missing_providers_are_unsupported_before_any_effect(self):
        f = self.opened([23], providers=False)
        f.hover(*f.center(0))
        status, _, _ = f.click()
        self.assertEqual((status, f.world.held.value, f.world.log), (UNSUPPORTED, -1, []))
        f = self.opened([5], held=23, providers=False)
        f.hover(*f.center(0))
        self.assertEqual(f.click()[0], UNSUPPORTED)
        self.assertEqual(f.world.held.value, 23)

    def test_provider_failures_keep_earlier_effects(self):
        f = self.opened([23], rebuild_status=1)
        f.hover(*f.center(0))
        status, _, _ = f.click()
        self.assertEqual((status, f.world.held.value), (HOST, 23))   # no rollback
        f = self.opened([23], view_sound_status=1)
        f.hover(*f.center(0))
        self.assertEqual(f.click()[0], HOST)
        f = self.opened([23], close_status=1)
        f.hover(*f.center(0))
        self.assertEqual(f.click()[0], HOST)
        self.assertEqual(f.view.screen_state, 0)

    def test_null_arguments(self):
        f = self.opened([23])
        self.assertEqual(f.click(with_host=False)[0], ARGUMENT)


if __name__ == '__main__':
    unittest.main()
