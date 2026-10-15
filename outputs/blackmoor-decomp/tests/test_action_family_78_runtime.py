"""RT-19: raw 0x78 "Add Inventory Item, No Hot Spot" runtime and session binding.

Runtime facts under test (original dispatcher arm 0x42944b, handler 0x4eaadc,
0x4e9e84 add, 0x4e8d96 put back, 0x4ea06c remove):
 * the object is three words: item, take-in-hand flag, swap flag;
 * take flag 0 (the plain "add"): add(item, 1) unless the held item already is
   the item; a duplicate list entry makes the add a complete no-op;
 * take flag 1, nothing held: the item leaves the list and becomes the held item;
 * take flag 1, other item held, swap flag 1: the held item goes back (add(held, 0),
   held = -1), the new item leaves the list and becomes the held item;
 * take flag 1, other item held, swap flag 0: add(item, 0) (silent), then the
   closing add(item, 1) finds the duplicate;
 * an add puts the item first unless view byte +0x7010 != 0 and view mode == 2
   (item last); it requests sound 0x17 when flag != 0 and the UI animation
   (1, 1, 0) when flag != 0 and the view mode is not 2;
 * completion is a direct store independent of subtype, phase untouched.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import session_binding_support as session
from test_action_family_79_runtime import (
    CAPACITY, GUARD, ITEM_GUARD, PRESENCE_GUARD, Model, Host, RebuildFn, ObserveFn,
    OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST)

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily78_runtime.dylib'

SoundFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16)
UiFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.c_int32, c.c_int16)

# Action79 markers first, then the Action78 ones (action_family_78_runtime.h).
EFFECT_NAMES = {1: 'visit', 2: 'count79', 3: 'list79', 4: 'presence79', 5: 'rebuild',
                6: 'held79', 7: 'complete',
                0x20: 'enter', 0x21: 'putback', 0x22: 'add', 0x23: 'add_flagged',
                0x24: 'duplicate', 0x25: 'sound', 0x26: 'count', 0x27: 'list',
                0x28: 'presence', 0x29: 'ui', 0x2a: 'held'}


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('A78_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'A78_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_78_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class View(c.Structure):
    _fields_ = [('mode', c.c_int32), ('slot_flag', c.c_uint8)]


class Model78(c.Structure):
    _fields_ = [('inventory', Model), ('view', View)]


class Host78(c.Structure):
    _fields_ = [('inventory', Host), ('request_sound', SoundFn), ('request_ui_animation', UiFn),
                ('context', c.c_void_p)]


class Object78(c.Structure):
    _fields_ = [('item_word', c.c_uint16), ('take_flag', c.c_uint16), ('swap_flag', c.c_uint16)]


class Result78(c.Structure):
    _fields_ = [(name, c.c_uint8) for name in
                ('took_in_hand', 'put_back', 'removed', 'added', 'duplicates', 'sound_requests',
                 'ui_requests', 'held_changed', 'completed')]

    def tuple(self):
        return tuple(getattr(self, name) for name, _ in self._fields_)


class World78:
    """The four modeled arrays with guard words after each (as RT-13's World), the
    view fields, and one ordered log shared by the effect observer, the rebuild
    provider and the two request providers."""
    def __init__(self, items=(), held=-1, presence=None, count=None, mode=0, slot_flag=0,
                 rebuild_status=0, sound_status=0, ui_status=0, providers=True):
        self.held = c.c_int16(held)
        self.count = c.c_int16(len(items) if count is None else count)
        self.items = (c.c_uint16 * (CAPACITY + GUARD))()
        for i in range(CAPACITY):
            self.items[i] = 0xffff
        for i, value in enumerate(items):
            self.items[i] = value & 0xffff
        for i in range(CAPACITY, CAPACITY + GUARD):
            self.items[i] = ITEM_GUARD
        self.presence = (c.c_int32 * (CAPACITY + GUARD))()
        for i in range(CAPACITY + GUARD):
            self.presence[i] = PRESENCE_GUARD if i >= CAPACITY else 0
        for value in (presence if presence is not None else items):
            if 0 <= value < CAPACITY:
                self.presence[value] = 1
        self.log = []          # ordered: effects and provider calls with snapshots
        self.rebuild_status, self.sound_status, self.ui_status = rebuild_status, sound_status, ui_status

        @RebuildFn
        def rebuild(_ctx, item):
            self.log.append(('rebuild_call', item, self.snapshot()))
            return self.rebuild_status

        @ObserveFn
        def observe(_ctx, effect, value):
            self.log.append((EFFECT_NAMES[effect], value))

        @SoundFn
        def sound(_ctx, slot):
            self.log.append(('sound_call', slot))
            return self.sound_status

        @UiFn
        def ui(_ctx, index, enable, sub):
            self.log.append(('ui_call', index, enable, sub))
            return self.ui_status

        self.keep = (rebuild, observe, sound, ui)
        self.model = Model78(Model(c.pointer(self.held), c.pointer(self.count),
                                   c.cast(self.items, c.POINTER(c.c_uint16)), CAPACITY,
                                   c.cast(self.presence, c.POINTER(c.c_int32)), CAPACITY),
                             View(mode, slot_flag))
        self.host = Host78(Host(None, rebuild if providers else RebuildFn(), observe),
                           sound if providers else SoundFn(), ui if providers else UiFn(), None)

    def snapshot(self):
        return (self.held.value, self.count.value,
                tuple(self.items[:CAPACITY]), tuple(self.presence[:CAPACITY]))

    def guards_intact(self):
        return (all(self.items[i] == ITEM_GUARD for i in range(CAPACITY, CAPACITY + GUARD)) and
                all(self.presence[i] == PRESENCE_GUARD for i in range(CAPACITY, CAPACITY + GUARD)))

    def names(self):
        return [entry[0] for entry in self.log]

    def effects(self):
        """The observer markers only (no provider calls)."""
        return [entry for entry in self.log if not entry[0].endswith('_call')]

    def calls(self, name):
        return [entry for entry in self.log if entry[0] == name]


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.action78_visit.argtypes = [c.POINTER(Object78), c.POINTER(Model78), c.POINTER(Host78),
                                   c.POINTER(Result78), c.POINTER(c.c_char_p)]
    lib.action78_visit.restype = c.c_int
    lib.action78_object_from_body.argtypes = [c.c_char_p, c.c_size_t, c.POINTER(Object78)]
    lib.action78_object_from_body.restype = c.c_int
    return lib


def visit(lib, item, take, swap, world, with_host=True, model=None):
    result, failure = Result78(), c.c_char_p()
    status = lib.action78_visit(c.byref(Object78(item & 0xffff, take, swap)),
                                c.byref(model or world.model),
                                c.byref(world.host) if with_host else None,
                                c.byref(result), c.byref(failure))
    return status, result, failure.value


def padded(values):
    return tuple(list(values) + [0xffff] * (CAPACITY - len(values)))[:CAPACITY]


class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    # ---- the plain add (take flag 0) ---------------------------------------
    def test_plain_add_puts_the_item_first_and_requests_sound_rebuild_and_animation(self):
        w = World78([3, 7])
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual(status, OK)
        held, count, words, presence = w.snapshot()
        self.assertEqual((held, count), (-1, 3))
        self.assertEqual(list(words[:4]), [5, 3, 7, 0xffff])
        self.assertEqual((presence[5], presence[3], presence[7]), (1, 1, 1))
        # 0x4e9e84: sound request before the stores, then count, list, presence,
        # rebuild, UI animation; 0x4eac3f completion last.
        self.assertEqual(w.log, [
            ('enter', 5), ('add_flagged', 5), ('sound', 0x17), ('sound_call', 0x17),
            ('count', 3), ('list', 3), ('presence', 5), ('rebuild', 5),
            ('rebuild_call', 5, (-1, 3, padded([5, 3, 7]), tuple(w.presence[:CAPACITY]))),
            ('ui', 1), ('ui_call', 1, 1, 0), ('complete', 1)])
        self.assertEqual(r.tuple(), (0, 0, 0, 1, 0, 1, 1, 0, 1))
        self.assertTrue(w.guards_intact())

    def test_add_to_an_empty_inventory(self):
        w = World78([])
        status, r, _ = visit(self.lib, 0, 0, 0, w)
        self.assertEqual(status, OK)
        self.assertEqual((w.count.value, w.items[0], w.presence[0]), (1, 0, 1))

    def test_a_duplicate_makes_the_add_a_complete_no_op(self):
        for items in ([5], [3, 5, 7], [3, 7, 5], [5, 5]):
            with self.subTest(items=items):
                w = World78(items)
                before = w.snapshot()
                status, r, _ = visit(self.lib, 5, 0, 0, w)
                self.assertEqual(status, OK)
                self.assertEqual(w.snapshot(), before)
                index = items.index(5)
                self.assertEqual(w.log, [('enter', 5), ('add_flagged', 5), ('duplicate', index),
                                         ('complete', 1)])
                self.assertEqual(r.tuple(), (0, 0, 0, 0, 1, 0, 0, 0, 1))

    def test_duplicate_matching_is_by_signed_word_and_only_inside_the_count(self):
        decoys = [0x0105, 0x8005, 0x4006, 0xff05]
        w = World78(decoys, presence=[])
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual((status, r.added, r.duplicates), (OK, 1, 0))
        self.assertEqual(list(w.snapshot()[2][:5]), [5] + decoys)
        w = World78([1, 2, 5], count=2)   # 5 sits beyond the count: not a duplicate
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual((status, r.added, w.count.value, list(w.items[:3])), (OK, 1, 3, [5, 1, 2]))

    def test_item_already_held_is_not_added(self):
        w = World78([3], held=5)
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual(status, OK)
        self.assertEqual(w.snapshot()[:2], (5, 1))
        self.assertEqual(w.log, [('enter', 5), ('complete', 1)])
        self.assertEqual(r.tuple(), (0, 0, 0, 0, 0, 0, 0, 0, 1))

    def test_held_comparison_is_signed_word_equality(self):
        for held, word, added in ((5, 5, 0), (6, 5, 1), (-1, 0xffff, 0), (-32768, 0x8000, 0),
                                  (0x7fff, 0x7fff, 0), (0, 1, 1)):
            with self.subTest(held=held, word=word):
                w = World78([], held=held, presence=[])
                if added and not 0 <= word < CAPACITY:
                    continue
                status, r, _ = visit(self.lib, word, 0, 0, w)
                self.assertEqual((status, r.added), (OK, added))

    # ---- layouts and the UI request -----------------------------------------
    def test_item_last_only_with_slot_flag_and_view_mode_two(self):
        for mode, slot_flag, last, ui in ((2, 1, True, False), (2, 0, False, False),
                                          (0, 1, False, True), (3, 1, False, True),
                                          (2, 7, True, False), (1, 255, False, True),
                                          (-1, 1, False, True), (0, 0, False, True)):
            with self.subTest(mode=mode, slot_flag=slot_flag):
                w = World78([3, 7], mode=mode, slot_flag=slot_flag)
                status, r, _ = visit(self.lib, 5, 0, 0, w)
                self.assertEqual(status, OK)
                self.assertEqual(list(w.items[:3]), [3, 7, 5] if last else [5, 3, 7])
                self.assertEqual(len(w.calls('ui_call')), 1 if ui else 0)
                self.assertEqual(r.ui_requests, 1 if ui else 0)
                self.assertEqual(len(w.calls('sound_call')), 1)

    def test_silent_add_requests_neither_sound_nor_animation(self):
        w = World78([3], held=4)
        status, r, _ = visit(self.lib, 5, 1, 0, w)   # take, no swap, other held: add(5, 0)
        self.assertEqual(status, OK)
        self.assertEqual(w.calls('sound_call'), [])
        self.assertEqual(w.calls('ui_call'), [])
        self.assertEqual(w.names()[:4], ['enter', 'add', 'count', 'list'])

    # ---- take in hand --------------------------------------------------------
    def test_take_with_nothing_held_removes_the_item_and_holds_it(self):
        w = World78([4, 6, 8], held=-1)
        status, r, _ = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, OK)
        held, count, words, presence = w.snapshot()
        self.assertEqual((held, count, list(words[:3]), presence[6]), (6, 2, [4, 8, 8], 0))
        self.assertEqual(w.names(), ['enter', 'visit', 'count79', 'list79', 'presence79',
                                     'rebuild', 'rebuild_call', 'held', 'complete'])
        self.assertEqual(w.effects()[-2:], [('held', 6), ('complete', 1)])
        self.assertEqual(r.tuple(), (1, 0, 1, 0, 0, 0, 0, 1, 1))
        # the rebuild sees the new list but still the old (empty) held item
        self.assertEqual(w.calls('rebuild_call')[0][2][0], -1)
        self.assertEqual(w.calls('sound_call'), [])

    def test_take_ignores_the_swap_flag_when_nothing_is_held(self):
        for swap in (0, 1, 2, 0xffff):
            with self.subTest(swap=swap):
                w = World78([4, 6], held=-1)
                visit(self.lib, 6, 1, swap, w)
                self.assertEqual(w.snapshot()[:2], (6, 1))

    def test_take_an_item_that_is_not_listed_still_holds_it_without_a_rebuild(self):
        w = World78([4], held=-1)
        status, r, _ = visit(self.lib, 9, 1, 1, w)
        self.assertEqual(status, OK)
        self.assertEqual(w.snapshot()[:2], (9, 1))
        self.assertEqual(w.names(), ['enter', 'visit', 'held', 'complete'])
        self.assertEqual(r.removed, 0)

    def test_any_nonzero_take_flag_counts(self):
        for take in (1, 2, 0x100, 0xffff):
            with self.subTest(take=take):
                w = World78([4], held=-1)
                visit(self.lib, 4, take, 0, w)
                self.assertEqual(w.held.value, 4)

    def test_swap_returns_the_held_item_then_takes_the_new_one(self):
        w = World78([4, 6], held=9, presence=[4, 6])
        status, r, _ = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, OK)
        held, count, words, presence = w.snapshot()
        # put back 9 (item first), then remove 6: [9, 4, 6] -> [9, 4] (stale tail 6)
        self.assertEqual((held, count, list(words[:3])), (6, 2, [9, 4, 6]))
        self.assertEqual((presence[9], presence[4], presence[6]), (1, 1, 0))
        self.assertEqual(w.names(), [
            'enter', 'putback', 'add', 'count', 'list', 'presence', 'rebuild', 'rebuild_call',
            'held', 'visit', 'count79', 'list79', 'presence79', 'rebuild', 'rebuild_call', 'held',
            'complete'])
        self.assertEqual([e for e in w.effects() if e[0] == 'held'], [('held', -1), ('held', 6)])
        self.assertEqual(w.calls('sound_call'), [])          # put back is add(held, 0)
        self.assertEqual(w.calls('ui_call'), [])
        self.assertEqual(r.tuple(), (1, 1, 1, 1, 0, 0, 0, 2, 1))

    def test_swap_with_the_same_item_held_changes_nothing(self):
        w = World78([4, 6], held=6)
        before = w.snapshot()
        status, r, _ = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, OK)
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(w.log, [('enter', 6), ('complete', 1)])

    def test_swap_when_the_held_item_is_already_listed_still_clears_held(self):
        w = World78([9, 6], held=9)
        status, r, _ = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, OK)
        # add(9, 0) is a duplicate no-op, then 6 is removed and held
        self.assertEqual((w.held.value, w.count.value, w.items[0]), (6, 1, 9))
        self.assertEqual(r.duplicates, 1)

    def test_take_without_swap_adds_silently_then_the_closing_add_is_a_duplicate(self):
        w = World78([3], held=4)
        status, r, _ = visit(self.lib, 5, 1, 0, w)
        self.assertEqual(status, OK)
        self.assertEqual((w.held.value, w.count.value, list(w.items[:2])), (4, 2, [5, 3]))
        self.assertEqual(w.names(), ['enter', 'add', 'count', 'list', 'presence', 'rebuild',
                                     'rebuild_call', 'add_flagged', 'duplicate', 'complete'])
        self.assertEqual(r.tuple(), (1, 0, 0, 1, 1, 0, 0, 0, 1))
        self.assertEqual(w.calls('sound_call'), [])   # 0x4e9e84(5, 1) found the duplicate first

    def test_take_without_swap_and_the_item_already_listed(self):
        w = World78([3, 5], held=4)
        status, r, _ = visit(self.lib, 5, 1, 0, w)
        self.assertEqual(status, OK)
        self.assertEqual(w.snapshot()[:2], (4, 2))
        self.assertEqual(r.duplicates, 2)
        self.assertEqual(w.calls('rebuild_call'), [])

    # ---- count edge cases ----------------------------------------------------
    def test_count_minus_one_stores_zero_and_copies_nothing(self):
        for mode, slot_flag in ((0, 0), (2, 1)):
            with self.subTest(mode=mode):
                w = World78([3, 3], count=-1, mode=mode, slot_flag=slot_flag, presence=[])
                before = list(w.items)
                status, r, _ = visit(self.lib, 5, 0, 0, w)
                self.assertEqual(status, OK)
                self.assertEqual((w.count.value, w.presence[5]), (0, 1))
                self.assertEqual(list(w.items), before)
                self.assertNotIn(('list', 0), w.log)
                self.assertNotIn('list', w.names())

    def test_a_full_inventory_with_room_for_one_more_fills_up(self):
        w = World78(list(range(1, CAPACITY)), presence=[])   # 69 items, 0 absent
        status, r, _ = visit(self.lib, 0, 0, 0, w)
        self.assertEqual((status, w.count.value), (OK, CAPACITY))
        self.assertEqual((w.items[0], w.items[1], w.items[CAPACITY - 1]), (0, 1, CAPACITY - 1))
        self.assertTrue(w.guards_intact())
        w = World78(list(range(1, CAPACITY)), presence=[], mode=2, slot_flag=1)
        status, r, _ = visit(self.lib, 0, 0, 0, w)
        self.assertEqual((status, w.items[CAPACITY - 1], w.items[0]), (OK, 0, 1))
        self.assertTrue(w.guards_intact())

    def test_a_full_inventory_with_the_item_listed_is_a_duplicate_not_an_overflow(self):
        w = World78(list(range(CAPACITY)))
        status, r, _ = visit(self.lib, 33, 0, 0, w)
        self.assertEqual((status, r.duplicates, w.count.value), (OK, 1, CAPACITY))
        self.assertTrue(w.guards_intact())

    # ---- rejections ----------------------------------------------------------
    def test_rejections_change_nothing_and_never_call_a_provider(self):
        cases = []
        w = World78([1, 2, 3])
        w.count.value = CAPACITY + 1
        cases.append(('count above capacity', w, 9, 0, 0, BOUNDS))
        w = World78([1, 2, 3])
        w.count.value = -2
        cases.append(('count below minus one', w, 9, 0, 0, BOUNDS))
        w = World78([], count=CAPACITY)
        for i in range(CAPACITY):
            w.items[i] = 1000 + i
        cases.append(('full inventory, new item', w, 9, 0, 0, BOUNDS))
        cases.append(('item id above the presence array', World78([1]), CAPACITY + 5, 0, 0, BOUNDS))
        cases.append(('negative item id', World78([1]), 0xfffe, 0, 0, BOUNDS))
        w = World78([1])
        cases.append(('missing rebuild provider', w, 9, 0, 0, UNSUPPORTED))
        w.host.inventory.rebuild_view = RebuildFn()
        w = World78([1])
        w.host.request_sound = SoundFn()
        cases.append(('missing sound provider', w, 9, 0, 0, UNSUPPORTED))
        w = World78([1])
        w.host.request_ui_animation = UiFn()
        cases.append(('missing UI provider', w, 9, 0, 0, UNSUPPORTED))
        for name, w, item, take, swap, expected in cases:
            with self.subTest(name):
                if name == 'missing rebuild provider':
                    w.host.inventory.rebuild_view = RebuildFn()
                before = w.snapshot()
                status, r, why = visit(self.lib, item, take, swap, w)
                self.assertEqual(status, expected)
                self.assertTrue(why)
                self.assertEqual(r.completed, 0)
                self.assertEqual(w.snapshot(), before)
                self.assertEqual(w.log, [])
                self.assertTrue(w.guards_intact())

    def test_missing_sound_and_ui_providers_matter_only_when_the_path_requests_them(self):
        # Silent add (flag 0): no sound, no animation -> neither provider is needed.
        w = World78([3], held=4)
        w.host.request_sound = SoundFn()
        w.host.request_ui_animation = UiFn()
        status, r, _ = visit(self.lib, 5, 1, 0, w)
        self.assertEqual((status, r.completed), (OK, 1))
        # View mode 2: the animation is not requested, so its provider is not needed.
        w = World78([3], mode=2)
        w.host.request_ui_animation = UiFn()
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual((status, r.completed), (OK, 1))
        # A duplicate needs no provider at all.
        w = World78([5], providers=False)
        status, r, _ = visit(self.lib, 5, 0, 0, w)
        self.assertEqual((status, r.duplicates), (OK, 1))
        status, r, _ = visit(self.lib, 5, 0, 0, w, with_host=False)
        self.assertEqual((status, r.duplicates), (OK, 1))

    def test_a_late_substep_rejection_leaves_the_earlier_substeps_unapplied(self):
        # swap: put back 9 works, but the item to take (id 100, listed) cannot be
        # removed (presence index outside the array). The whole visit is refused.
        w = World78([4, 100], held=9, presence=[4])
        before = w.snapshot()
        status, r, why = visit(self.lib, 100, 1, 1, w)
        self.assertEqual(status, BOUNDS)
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(w.log, [])
        # swap with a full inventory that does not list the held item: the put back
        # has no room, the whole visit is refused (nothing of it applied).
        w = World78([], count=CAPACITY, held=9)
        for i in range(CAPACITY):
            w.items[i] = 1000 + i
        before = w.snapshot()
        status, r, why = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, BOUNDS)
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(w.log, [])

    def test_null_arguments_and_model_pointers(self):
        w = World78([1])
        result, failure = Result78(), c.c_char_p()
        obj = Object78(1, 0, 0)
        self.assertEqual(self.lib.action78_visit(None, c.byref(w.model), c.byref(w.host),
                                                 c.byref(result), None), ARGUMENT)
        self.assertEqual(self.lib.action78_visit(c.byref(obj), None, c.byref(w.host),
                                                 c.byref(result), None), ARGUMENT)
        self.assertEqual(self.lib.action78_visit(c.byref(obj), c.byref(w.model), c.byref(w.host),
                                                 None, None), ARGUMENT)
        for field in ('held_item', 'item_count', 'items', 'presence'):
            broken = Model78.from_buffer_copy(w.model)
            setattr(broken.inventory, field, None)
            status, _, why = visit(self.lib, 1, 0, 0, w, model=broken)
            self.assertEqual(status, ARGUMENT, field)
            self.assertTrue(why)
            self.assertEqual(w.log, [])

    def test_small_capacities_are_checked_against_the_actual_arrays(self):
        w = World78([1, 2, 3, 4])
        small = Model78.from_buffer_copy(w.model)
        small.inventory.item_capacity = 4        # count 4: the added word does not fit
        status, _, _ = visit(self.lib, 9, 0, 0, w, model=small)
        self.assertEqual(status, BOUNDS)
        small.inventory.item_capacity = 3        # count 4 does not even scan
        status, _, _ = visit(self.lib, 9, 0, 0, w, model=small)
        self.assertEqual(status, BOUNDS)
        w = World78([1, 2])
        small = Model78.from_buffer_copy(w.model)
        small.inventory.presence_capacity = 9
        status, _, _ = visit(self.lib, 9, 0, 0, w, model=small)   # id 9 needs index 9
        self.assertEqual(status, BOUNDS)
        status, r, _ = visit(self.lib, 8, 0, 0, w, model=small)
        self.assertEqual((status, r.added), (OK, 1))

    # ---- provider failures ---------------------------------------------------
    def test_rebuild_failure_keeps_the_committed_list_and_skips_ui_and_completion(self):
        for rebuild_status in (1, -1, 255):
            with self.subTest(rebuild_status=rebuild_status):
                w = World78([3], rebuild_status=rebuild_status)
                status, r, why = visit(self.lib, 5, 0, 0, w)
                self.assertEqual(status, HOST)
                self.assertTrue(why)
                self.assertEqual((w.count.value, list(w.items[:2]), w.presence[5]), (2, [5, 3], 1))
                self.assertEqual(r.completed, 0)
                self.assertEqual(w.calls('ui_call'), [])
                self.assertNotIn('complete', w.names())

    def test_sound_failure_happens_before_any_store(self):
        w = World78([3], sound_status=1)
        before = w.snapshot()
        status, r, why = visit(self.lib, 5, 0, 0, w)
        self.assertEqual(status, HOST)
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(w.names(), ['enter', 'add_flagged', 'sound', 'sound_call'])

    def test_ui_failure_keeps_everything_and_skips_completion(self):
        w = World78([3], ui_status=1)
        status, r, why = visit(self.lib, 5, 0, 0, w)
        self.assertEqual(status, HOST)
        self.assertEqual((w.count.value, w.items[0]), (2, 5))
        self.assertEqual(r.completed, 0)

    def test_failure_in_the_swap_put_back_leaves_held_untouched(self):
        w = World78([4, 6], held=9, rebuild_status=1)
        status, r, _ = visit(self.lib, 6, 1, 1, w)
        self.assertEqual(status, HOST)
        self.assertEqual(w.held.value, 9)           # held = -1 follows the add in 0x4e8d96
        self.assertEqual(w.count.value, 3)

    # ---- the object ----------------------------------------------------------
    def test_object_is_three_little_endian_words_and_extra_bytes_are_ignored(self):
        obj = Object78()
        body = bytes([0x34, 0x12, 0x01, 0x00, 0xff, 0xff])
        self.assertEqual(self.lib.action78_object_from_body(body, 6, c.byref(obj)), OK)
        self.assertEqual((obj.item_word, obj.take_flag, obj.swap_flag), (0x1234, 1, 0xffff))
        body = bytes([5, 0, 0, 0, 0, 0]) + b'\xaa' * 16
        self.assertEqual(self.lib.action78_object_from_body(body, len(body), c.byref(obj)), OK)
        self.assertEqual((obj.item_word, obj.take_flag, obj.swap_flag), (5, 0, 0))
        for length in range(6):
            self.assertEqual(self.lib.action78_object_from_body(body, length, c.byref(obj)), ARGUMENT)
        self.assertEqual(self.lib.action78_object_from_body(None, 6, c.byref(obj)), ARGUMENT)
        self.assertEqual(self.lib.action78_object_from_body(body, 6, None), ARGUMENT)


Config = session.SessionConfig


class BindHost(c.Structure):
    _fields_ = [('model', Model78), ('view', Host78)]


def body78(item, take, swap):
    return b''.join((value & 0xffff).to_bytes(2, 'little') for value in (item, take, swap))


def signed(value):
    return value if value < 0x8000 else value - 0x10000


class Fixture:
    def __init__(self, test, lib, actions, world=None, **world_options):
        self.lib = lib
        self.world = world or World78([4, 6, 8], **world_options)
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world()
        self.host = BindHost(self.world.model, self.world.host)
        self.binding = lib.session_a78_create(c.byref(self.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a78_begin_scene(self.binding, self.scene), 0)
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a78_handler', lib))
        self.bindings = (session.Binding * 1)(session.Binding(0x78, 11, handler, self.binding))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6453,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        self.keep = [prepare, media, handler]
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a78_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)

    def tick(self):
        out = session.SceneSessionTickResult()
        return self.lib.scene_session_tick(self.session, c.byref(out)), out

    def state(self, index=0):
        out = session.RuntimeState()
        assert self.lib.scene_session_get_action_state(self.session, index, c.byref(out)) == 0
        return out.completed, out.phase


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        cls.lib.session_a78_create.argtypes = [c.POINTER(BindHost)]
        cls.lib.session_a78_create.restype = c.c_void_p
        cls.lib.session_a78_destroy.argtypes = [c.c_void_p]
        cls.lib.session_a78_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
        cls.lib.session_a78_begin_scene.restype = c.c_int
        cls.lib.session_a78_handler.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo), c.POINTER(session.RuntimeState),
            c.POINTER(session.HandlerResult)]
        cls.lib.session_a78_handler.restype = c.c_int
        cls.lib.session_a78_failure.argtypes = [c.c_void_p]
        cls.lib.session_a78_failure.restype = c.c_char_p
        cls.lib.session_a78_object.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Object78)]
        cls.lib.session_a78_object.restype = c.c_int
        cls.lib.session_a78_last_result.argtypes = [c.c_void_p]
        cls.lib.session_a78_last_result.restype = Result78
        cls.lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo)]

    def obj(self, fixture, row):
        out = Object78()
        found = self.lib.session_a78_object(fixture.binding, row, c.byref(out))
        return (out.item_word, out.take_flag, out.swap_flag) if found else None

    def test_true_gate_visit_adds_completes_directly_and_keeps_phase(self):
        for subtype in (0, 1, 2, 3, 255):
            with self.subTest(subtype=subtype):
                f = Fixture(self, self.lib, [session.action(0x78, subtype, body78(5, 0, 0))])
                self.assertEqual(f.tick()[0], session.SESSION_OK)
                self.assertEqual(f.state(), (1, 0))
                self.assertEqual((f.world.count.value, list(f.world.items[:4])), (4, [5, 4, 6, 8]))
                self.assertEqual(len(f.world.calls('sound_call')), 1)
                self.assertEqual(len(f.world.calls('ui_call')), 1)
                # Completed rows are never revisited, whatever the subtype.
                self.assertEqual(f.tick()[0], session.SESSION_OK)
                self.assertEqual(f.world.count.value, 4)

    def test_binding_records_the_load_time_object(self):
        f = Fixture(self, self.lib, [
            session.action(0x61, 1, session.i16(4) + session.i16(1) + session.i16(-1) + session.i16(0)),
            session.action(0x78, 1, body78(0xfffe, 1, 7)),
            session.action(0x78, 1, body78(9, 0, 0), (session.flag_gate(1),))])
        self.assertIsNone(self.obj(f, 0))
        self.assertEqual(self.obj(f, 1), (0xfffe, 1, 7))
        self.assertEqual(self.obj(f, 2), (9, 0, 0))
        self.assertIsNone(self.obj(f, 3))

    def test_false_gate_has_no_effect_then_true_gate_runs_once(self):
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(5, 0, 0),
                                                    (session.flag_gate(3),))])
        before = f.world.snapshot()
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.snapshot(), before)
        self.assertEqual(f.world.log, [])
        f.flags[3] = 1
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(f.world.count.value, 4)
        f.tick()
        self.assertEqual(f.world.count.value, 4)

    def test_false_gate_subtype_two_is_not_a_reset_for_this_family(self):
        f = Fixture(self, self.lib, [session.action(0x78, 2, body78(5, 0, 0),
                                                    (session.flag_gate(3),))])
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.state(), (1, 0))
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.state(), (1, 0))

    def test_adjacent_rows_each_use_their_own_object(self):
        # A row must read its own object, not its neighbour's.
        for order in ((5, 9), (9, 5)):
            with self.subTest(order=order):
                f = Fixture(self, self.lib, [session.action(0x78, 1, body78(w, 0, 0)) for w in order],
                            world=World78([]))
                self.assertEqual([self.obj(f, i) for i in range(3)],
                                 [(order[0], 0, 0), (order[1], 0, 0), None])
                self.assertEqual(f.tick()[0], session.SESSION_OK)
                # Each add puts its item first, so the later row ends up first.
                self.assertEqual((f.world.count.value, list(f.world.items[:2])),
                                 (2, [order[1], order[0]]))
                self.assertEqual([f.state(i)[0] for i in range(2)], [1, 1])

    def test_rows_before_a_foreign_row_and_the_closing_row_keep_their_objects(self):
        rows = [session.action(0x78, 1, body78(8, 0, 0)), session.action(0x78, 1, body78(4, 1, 0)),
                session.action(0x61, 1, session.i16(5) + session.i16(1) + session.i16(-1) + session.i16(0)),
                session.action(0x78, 3, body78(9, 0, 0))]
        f = Fixture(self, self.lib, rows, world=World78([4, 6]), held=-1)
        self.assertEqual([self.obj(f, i) for i in range(4)],
                         [(8, 0, 0), (4, 1, 0), None, (9, 0, 0)])
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        # row 0 adds 8; row 1 takes 4 (removes it, holds it); row 3 adds 9.
        self.assertEqual(f.world.held.value, 4)
        self.assertEqual((f.world.count.value, list(f.world.items[:3])), (3, [9, 8, 6]))

    def test_missing_rebuild_provider_blocks_only_when_the_add_needs_it(self):
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(5, 0, 0))], providers=False)
        before = f.world.snapshot()
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x78))
        self.assertEqual(result.failure.detail_status, 1)
        self.assertIn(b'rebuild', self.lib.session_a78_failure(f.binding))
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.snapshot(), before)
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(4, 0, 0))], providers=False)
        self.assertEqual(f.tick()[0], session.SESSION_OK)   # duplicate: nothing is requested
        self.assertEqual(f.state(), (1, 0))

    def test_host_failure_blocks_without_completing(self):
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(5, 0, 0))], rebuild_status=1)
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.count.value, 4)       # committed: the original has no rollback
        self.assertIn(b'rebuild', self.lib.session_a78_failure(f.binding))

    def test_bounds_rejection_blocks_without_effects(self):
        w = World78([4, 6, 8])
        w.count.value = CAPACITY + 3
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(5, 0, 0))], world=w)
        before = w.snapshot()
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(f.state(), (0, 0))
        self.assertIn(b'bounds', self.lib.session_a78_failure(f.binding))

    def test_last_result_reports_the_visit(self):
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(6, 1, 1))], held=9)
        f.tick()
        result = self.lib.session_a78_last_result(f.binding)
        self.assertEqual(result.tuple(), (1, 1, 1, 1, 0, 0, 0, 2, 1))
        self.assertEqual(f.world.held.value, 6)

    def test_handler_rejects_foreign_rows_and_bad_arguments(self):
        f = Fixture(self, self.lib, [session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0)),
                                     session.action(0x78, 1, body78(5, 0, 0))])
        action = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for index in (0, 99):
            self.assertEqual(self.lib.session_a78_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(f.world.log, [])
        self.assertEqual(self.lib.session_a78_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_handler_returns_direct_completion_and_the_phase_word_unchanged(self):
        f = Fixture(self, self.lib, [session.action(0x78, 2, body78(4, 0, 0))])   # duplicate
        action = session.SceneActionInfo()
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for phase in (0, 1, 2, 5, 0xffffffff):
            before, out = session.RuntimeState(0, phase), session.HandlerResult(123, 456)
            self.assertEqual(self.lib.session_a78_handler(f.binding, 0, c.byref(action),
                              c.byref(before), c.byref(out)), 0)
            self.assertEqual((out.disposition, out.phase),
                             (session.HANDLER_DIRECT_COMPLETED, phase))

    def test_scene_reload_replaces_rows_and_a_new_scene_without_rows_is_valid(self):
        f = Fixture(self, self.lib, [session.action(0x78, 1, body78(4, 0, 0))])
        other, owner = session.open_scene(self.lib, [session.action(0x78, 1, body78(8, 1, 0)),
                                                      session.action(0x78, 1, body78(9, 0, 1))])
        self.assertEqual(self.lib.session_a78_begin_scene(f.binding, other), 0)
        self.assertEqual([self.obj(f, i) for i in range(3)], [(8, 1, 0), (9, 0, 1), None])
        empty, owner2 = session.open_scene(self.lib, [])
        self.assertEqual(self.lib.session_a78_begin_scene(f.binding, empty), 0)
        self.assertIsNone(self.obj(f, 0))
        self.assertNotEqual(self.lib.session_a78_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(other)
        self.lib.scene_resource_close(empty)
        del owner, owner2


STUB_SOURCES = ('tests/action_family_79_binding_stub_scene.c', 'src/session_bindings_a78.c',
                'src/action_family_78_runtime.c', 'src/action_family_79_runtime.c')


class StubSceneTests(unittest.TestCase):
    """session_a78_begin_scene rejection of rows the scene parser would have
    refused (defence in depth: scene_resource.c admits only six bytes plus whole
    16-byte dependency records for raw 0x78). The binding is linked against a
    scriptable scene double; A78_BINDING_SOURCE / A78_RUNTIME_SOURCE let the
    mutation check substitute a mutant source."""
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.tmp.cleanup)
        sources = [PROJECT / path for path in STUB_SOURCES]
        sources[1] = Path(os.environ.get('A78_BINDING_SOURCE', sources[1]))
        sources[2] = Path(os.environ.get('A78_RUNTIME_SOURCE', sources[2]))
        library = Path(cls.tmp.name) / 'libstub78.dylib'
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
                        '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-fPIC', '-dynamiclib',
                        '-I' + str(PROJECT / 'src'), *map(str, sources), '-o', str(library)],
                       check=True, capture_output=True)
        lib = c.CDLL(str(library))
        lib.session_a78_create.argtypes = [c.POINTER(BindHost)]
        lib.session_a78_create.restype = c.c_void_p
        lib.session_a78_destroy.argtypes = [c.c_void_p]
        lib.session_a78_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
        lib.session_a78_begin_scene.restype = c.c_int
        lib.session_a78_failure.argtypes = [c.c_void_p]
        lib.session_a78_failure.restype = c.c_char_p
        lib.session_a78_object.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Object78)]
        lib.session_a78_object.restype = c.c_int
        lib.stub_scene_add.argtypes = [c.c_uint8, c.c_char_p, c.c_size_t, c.c_int]
        lib.stub_scene_add.restype = c.c_int
        cls.lib = lib

    def setUp(self):
        self.lib.stub_scene_reset()
        self.world = World78([4, 6, 8])
        self.host = BindHost(self.world.model, self.world.host)
        self.binding = self.lib.session_a78_create(c.byref(self.host))
        self.assertTrue(self.binding)
        self.addCleanup(self.lib.session_a78_destroy, self.binding)

    def scene(self, *rows):
        self.lib.stub_scene_reset()
        for kind, body, unreadable in rows:
            self.assertGreaterEqual(self.lib.stub_scene_add(kind, body, len(body), unreadable), 0)
        return self.lib.session_a78_begin_scene(self.binding, 1)  # the double ignores the handle

    def objects(self, count):
        result = []
        for i in range(count):
            out = Object78()
            result.append((out.item_word, out.take_flag, out.swap_flag)
                          if self.lib.session_a78_object(self.binding, i, c.byref(out)) else None)
        return result

    def test_wellformed_rows_load_including_whole_dependency_records(self):
        status = self.scene((0x78, bytes([4, 0, 1, 0, 0, 0]), 0), (0x61, b'\xff' * 8, 0),
                            (0x78, bytes([8, 0, 0, 0, 1, 0]) + bytes(16), 0),
                            (0x78, bytes([0xfe, 0xff, 2, 0, 3, 0]) + bytes(32), 0))
        self.assertEqual((status, self.objects(5)),
                         (OK, [(4, 1, 0), None, (8, 0, 1), (0xfffe, 2, 3), None]))
        self.assertEqual(self.lib.session_a78_failure(self.binding), b'none')

    def test_malformed_row_fails_the_scene_and_keeps_the_previous_rows(self):
        good = bytes([4, 0, 0, 0, 0, 0])
        self.assertEqual(self.scene((0x78, good, 0), (0x78, bytes([9, 0, 0, 0, 0, 0]), 0)), OK)
        for label, bad in (('five bytes', bytes(5)), ('empty', b''), ('one byte', b'\x07'),
                           ('partial dependency record', bytes(6 + 15)),
                           ('record plus one byte', bytes(6 + 17))):
            with self.subTest(label):
                status = self.scene((0x78, bytes([8, 0, 0, 0, 0, 0]), 0), (0x78, bad, 0),
                                    (0x78, bytes([6, 0, 0, 0, 0, 0]), 0))
                self.assertEqual(status, BOUNDS)
                self.assertEqual(self.lib.session_a78_failure(self.binding), b'invalid raw-0x78 scene row')
                self.assertEqual(self.objects(3), [(4, 0, 0), (9, 0, 0), None])

    def test_unreadable_row_fails_the_scene_and_keeps_the_previous_rows(self):
        self.assertEqual(self.scene((0x78, bytes(6), 0)), OK)
        status = self.scene((0x78, bytes([8, 0, 0, 0, 0, 0]), 0), (0x78, bytes([9, 0, 0, 0, 0, 0]), 1))
        self.assertEqual(status, BOUNDS)
        self.assertEqual(self.lib.session_a78_failure(self.binding), b'raw-0x78 scene row unreadable')
        self.assertEqual(self.objects(2), [(0, 0, 0), None])

    def test_a_rejected_first_scene_leaves_the_binding_with_no_rows(self):
        self.assertEqual(self.scene((0x78, b'\x01', 0)), BOUNDS)
        self.assertEqual(self.objects(2), [None, None])

    def test_a_good_scene_after_a_rejection_replaces_the_old_rows_and_clears_the_failure(self):
        self.assertEqual(self.scene((0x78, bytes(6), 0)), OK)
        self.assertEqual(self.scene((0x78, b'', 0)), BOUNDS)
        self.assertEqual(self.scene((0x78, bytes([6, 0, 0, 0, 0, 0]), 0),
                                    (0x78, bytes([10, 0, 0, 0, 0, 0]), 0)), OK)
        self.assertEqual((self.objects(3), self.lib.session_a78_failure(self.binding)),
                         ([(6, 0, 0), (10, 0, 0), None], b'none'))

    def test_foreign_rows_are_never_decoded(self):
        self.assertEqual(self.scene((0x61, b'\x01', 0), (0x78, bytes([5, 0, 0, 0, 0, 0]), 0),
                                    (0x79, b'\x01', 0)), OK)
        self.assertEqual(self.objects(4), [None, (5, 0, 0), None, None])


if __name__ == '__main__':
    unittest.main()
