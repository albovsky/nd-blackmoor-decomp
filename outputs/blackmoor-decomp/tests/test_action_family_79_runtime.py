"""RT-13: raw 0x79 "Remove Inventory Item, No Hotspot" runtime and session binding.

Runtime facts under test (original 0x429486 arm, 0x4eac4c, 0x4ea06c):
 * only the FIRST list entry equal to the sign-extended id is removed, the
   kept entries are compacted in order, only the kept entries are copied back
   (stale words beyond the new count survive), presence[id] becomes 0;
 * the view rebuild (0x4e812f) runs after those and BEFORE the held-item
   clear; not found means no rebuild and no list/presence effect;
 * the held item is cleared whenever it equals the id, found or not;
 * completion is a direct store independent of subtype, phase untouched.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

import session_binding_support as session

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily79_runtime.dylib'
OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST = range(5)
CAPACITY = 70
GUARD = 8
PRESENCE_GUARD = 0x5a5a5a5a
ITEM_GUARD = 0xa5a5
STALE = 0xbeef


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('A79_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'A79_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_79_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class Model(c.Structure):
    _fields_ = [('held_item', c.POINTER(c.c_int16)), ('item_count', c.POINTER(c.c_int16)),
                ('items', c.POINTER(c.c_uint16)), ('item_capacity', c.c_size_t),
                ('presence', c.POINTER(c.c_int32)), ('presence_capacity', c.c_size_t)]


RebuildFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16)
ObserveFn = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.c_int32)
VISIT, COUNT, LIST, PRESENCE, REBUILD, HELD, COMPLETE = range(1, 8)
EFFECT_NAMES = {VISIT: 'visit', COUNT: 'count', LIST: 'list', PRESENCE: 'presence',
                REBUILD: 'rebuild', HELD: 'held', COMPLETE: 'complete'}


class Host(c.Structure):
    _fields_ = [('context', c.c_void_p), ('rebuild_view', RebuildFn),
                ('observe', ObserveFn)]


class Result(c.Structure):
    _fields_ = [('found', c.c_uint8), ('rebuild_called', c.c_uint8),
                ('held_cleared', c.c_uint8), ('completed', c.c_uint8),
                ('found_index', c.c_int32)]


class World:
    """The four modeled arrays with guard words after each, plus an ordered
    event log shared with the rebuild provider (so the snapshot proves what
    the original's 0x4e812f would observe)."""
    def __init__(self, items=(), held=-1, presence=None, count=None, rebuild_status=0,
                 provider=True):
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
        self.events = []
        self.observed = []
        self.rebuild_status = rebuild_status

        @RebuildFn
        def rebuild(_ctx, removed):
            self.events.append(('rebuild', removed, self.snapshot()))
            return self.rebuild_status

        @ObserveFn
        def observe(_ctx, effect, value):
            self.observed.append((EFFECT_NAMES[effect], value))

        self.rebuild = rebuild
        self.observe = observe
        self.model = Model(c.pointer(self.held), c.pointer(self.count),
                           c.cast(self.items, c.POINTER(c.c_uint16)), CAPACITY,
                           c.cast(self.presence, c.POINTER(c.c_int32)), CAPACITY)
        self.host = Host(None, rebuild if provider else RebuildFn(), observe)

    def snapshot(self):
        return (self.held.value, self.count.value,
                tuple(self.items[:CAPACITY]), tuple(self.presence[:CAPACITY]))

    def guards_intact(self):
        return (all(self.items[i] == ITEM_GUARD for i in range(CAPACITY, CAPACITY + GUARD)) and
                all(self.presence[i] == PRESENCE_GUARD for i in range(CAPACITY, CAPACITY + GUARD)))


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.action79_visit.argtypes = [c.c_uint16, c.POINTER(Model), c.POINTER(Host),
                                   c.POINTER(Result), c.POINTER(c.c_char_p)]
    lib.action79_visit.restype = c.c_int
    return lib


def visit(lib, word, world, with_host=True, model=None):
    result, failure = Result(), c.c_char_p()
    status = lib.action79_visit(word, c.byref(model or world.model),
                                c.byref(world.host) if with_host else None,
                                c.byref(result), c.byref(failure))
    return status, result, failure.value


def padded(values, count):
    """Expected list words: kept entries first, stale words after."""
    return tuple(list(values) + [0xffff] * (CAPACITY - len(values)))[:CAPACITY]


class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_absent_item_has_no_list_presence_or_rebuild_effect(self):
        w = World([3, 7, 9])
        before = w.snapshot()
        status, r, _ = visit(self.lib, 5, w)
        self.assertEqual(status, OK)
        self.assertEqual((r.found, r.rebuild_called, r.held_cleared, r.completed, r.found_index),
                         (0, 0, 0, 1, -1))
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(w.events, [])

    def test_empty_inventory_is_the_new_game_state(self):
        w = World([])
        before = w.snapshot()
        status, r, _ = visit(self.lib, 0, w)
        self.assertEqual((status, r.found, r.completed), (OK, 0, 1))
        self.assertEqual(w.snapshot(), before)

    def test_first_middle_last_and_only_entry(self):
        for items, word, kept in (([4, 6, 8], 4, [6, 8]), ([4, 6, 8], 6, [4, 8]),
                                  ([4, 6, 8], 8, [4, 6]), ([6], 6, [])):
            with self.subTest(items=items, word=word):
                w = World(items, presence=items)
                status, r, _ = visit(self.lib, word, w)
                self.assertEqual(status, OK)
                self.assertEqual((r.found, r.rebuild_called, r.found_index),
                                 (1, 1, items.index(word)))
                held, count, words, presence = w.snapshot()
                self.assertEqual(count, len(kept))
                self.assertEqual(list(words[:count]), kept)
                self.assertEqual(presence[word], 0)
                for other in items:
                    if other != word:
                        self.assertEqual(presence[other], 1)
                self.assertTrue(w.guards_intact())

    def test_stale_words_beyond_new_count_are_preserved(self):
        # 0x4ea1a3 copies only 2*outcount bytes back: [a,b,c] minus b is [a,c,c].
        w = World([10, 11, 12, 13])
        visit(self.lib, 11, w)
        _, count, words, _ = w.snapshot()
        self.assertEqual((count, list(words[:4])), (3, [10, 12, 13, 13]))
        w = World([10, 11, 12, 13])
        visit(self.lib, 10, w)
        _, count, words, _ = w.snapshot()
        self.assertEqual((count, list(words[:4])), (3, [11, 12, 13, 13]))

    def test_only_first_duplicate_is_removed_and_the_other_kept(self):
        w = World([5, 9, 5, 2, 5])
        status, r, _ = visit(self.lib, 5, w)
        _, count, words, presence = w.snapshot()
        self.assertEqual((status, r.found_index, count), (OK, 0, 4))
        self.assertEqual(list(words[:4]), [9, 5, 2, 5])
        self.assertEqual(presence[5], 0)  # presence[id] is cleared even though a copy remains

    def test_rebuild_sees_committed_list_and_presence_but_the_old_held_item(self):
        w = World([4, 6, 8], held=6)
        status, r, _ = visit(self.lib, 6, w)
        self.assertEqual((status, r.held_cleared), (OK, 1))
        self.assertEqual(len(w.events), 1)
        kind, removed, (held, count, words, presence) = w.events[0]
        self.assertEqual((kind, removed, held, count), ('rebuild', 6, 6, 2))
        self.assertEqual(list(words[:3]), [4, 8, 8])
        self.assertEqual(presence[6], 0)
        self.assertEqual(w.held.value, -1)

    def test_effect_order_matches_the_original_store_order(self):
        # 0x4ea17f count, 0x4ea1a3 list copy, 0x4ea1b0 presence, 0x4ea1be rebuild,
        # then 0x4eac88 held, 0x4eac9b completion.
        w = World([4, 6, 8], held=6)
        visit(self.lib, 6, w)
        self.assertEqual(w.observed, [('visit', 6), ('count', 2), ('list', 2), ('presence', 6),
                                      ('rebuild', 6), ('held', -1), ('complete', 1)])
        w = World([6], held=3)  # nothing left to copy back: no list event
        visit(self.lib, 6, w)
        self.assertEqual(w.observed, [('visit', 6), ('count', 0), ('presence', 6),
                                      ('rebuild', 6), ('complete', 1)])
        w = World([4], held=9)  # not found, held differs: visit then completion only
        visit(self.lib, 7, w)
        self.assertEqual(w.observed, [('visit', 7), ('complete', 1)])
        w = World([4], held=7)  # not found, held matches: held clear is independent
        visit(self.lib, 7, w)
        self.assertEqual(w.observed, [('visit', 7), ('held', -1), ('complete', 1)])

    def test_failures_report_only_effects_that_happened(self):
        w = World([4, 6], held=6, rebuild_status=1)
        visit(self.lib, 6, w)
        self.assertEqual(w.observed, [('visit', 6), ('count', 1), ('list', 1), ('presence', 6),
                                      ('rebuild', 6)])
        w = World([4, 6], held=6)
        w.host.rebuild_view = RebuildFn()
        visit(self.lib, 6, w)
        self.assertEqual(w.observed, [])  # rejected before the visit began

    def test_held_item_cleared_only_on_signed_word_equality(self):
        for held, word, cleared in ((6, 6, 1), (7, 6, 0), (-1, 0xffff, 1), (-1, 0, 0),
                                    (0, 0, 1), (0x7fff, 0x7fff, 1), (-32768, 0x8000, 1)):
            with self.subTest(held=held, word=word):
                w = World([], held=held)
                status, r, _ = visit(self.lib, word, w)
                self.assertEqual(status, OK)
                self.assertEqual(r.held_cleared, cleared)
                self.assertEqual(w.held.value, -1 if cleared else held)

    def test_held_item_is_cleared_even_when_the_item_is_not_in_the_list(self):
        w = World([1, 2], held=9)
        status, r, _ = visit(self.lib, 9, w)
        self.assertEqual((status, r.found, r.rebuild_called, r.held_cleared), (OK, 0, 0, 1))
        self.assertEqual(w.held.value, -1)
        self.assertEqual(w.events, [])

    def test_negative_count_scans_nothing_but_still_clears_held_and_completes(self):
        w = World([3, 3], held=3, count=-5)
        before = list(w.items)
        status, r, _ = visit(self.lib, 3, w)
        self.assertEqual((status, r.found, r.held_cleared, r.completed), (OK, 0, 1, 1))
        self.assertEqual(w.count.value, -5)
        self.assertEqual(list(w.items), before)

    def test_entries_beyond_the_count_are_never_matched(self):
        w = World([1, 2, 3], count=2)
        status, r, _ = visit(self.lib, 3, w)
        self.assertEqual((status, r.found), (OK, 0))
        self.assertEqual(w.count.value, 2)

    def test_full_capacity_inventory(self):
        w = World(list(range(CAPACITY)))
        status, r, _ = visit(self.lib, CAPACITY - 1, w)
        self.assertEqual((status, r.found_index), (OK, CAPACITY - 1))
        self.assertEqual(w.count.value, CAPACITY - 1)
        self.assertTrue(w.guards_intact())
        w = World(list(range(CAPACITY)))
        status, r, _ = visit(self.lib, 0, w)
        self.assertEqual((status, w.count.value, w.items[0]), (OK, CAPACITY - 1, 1))
        self.assertEqual(w.items[CAPACITY - 1], CAPACITY - 1)  # stale last word
        self.assertTrue(w.guards_intact())

    def test_rejections_change_nothing_and_never_call_the_provider(self):
        cases = []
        w = World([1, 2, 3], held=2)
        w.count.value = CAPACITY + 1  # original would scan the adjacent arrays
        cases.append(('count above capacity', w, 2, BOUNDS))
        w = World([1, CAPACITY + 5, 3], held=-1)
        cases.append(('id outside presence', w, CAPACITY + 5, BOUNDS))
        w = World([1, 0xfffe, 3], held=-1)  # -2
        cases.append(('negative id outside presence', w, 0xfffe, BOUNDS))
        w = World([1, 2, 3], held=2)
        cases.append(('missing rebuild provider', w, 2, UNSUPPORTED))
        for name, w, word, expected in cases:
            with self.subTest(name):
                before = w.snapshot()
                status, r, why = visit(self.lib, word, w, with_host=(name != 'missing rebuild provider'))
                if name == 'missing rebuild provider':
                    w.host.rebuild_view = RebuildFn()
                    status, r, why = visit(self.lib, word, w)
                self.assertEqual(status, expected)
                self.assertTrue(why)
                self.assertEqual((r.found, r.rebuild_called, r.held_cleared, r.completed), (0, 0, 0, 0))
                self.assertEqual(w.snapshot(), before)
                self.assertEqual(w.events, [])
                self.assertTrue(w.guards_intact())

    def test_missing_provider_is_irrelevant_when_nothing_is_found(self):
        w = World([1, 2], held=7)
        w.host.rebuild_view = RebuildFn()
        status, r, _ = visit(self.lib, 7, w)
        self.assertEqual((status, r.found, r.held_cleared, r.completed), (OK, 0, 1, 1))
        # No host at all behaves the same when nothing needs the provider.
        status, r, _ = visit(self.lib, 9, w, with_host=False)
        self.assertEqual((status, r.completed), (OK, 1))

    def test_null_arguments_and_model_pointers(self):
        w = World([1])
        result, failure = Result(), c.c_char_p()
        self.assertEqual(self.lib.action79_visit(1, None, c.byref(w.host), c.byref(result), None), ARGUMENT)
        self.assertEqual(self.lib.action79_visit(1, c.byref(w.model), c.byref(w.host), None, None), ARGUMENT)
        for field in ('held_item', 'item_count', 'items', 'presence'):
            broken = Model.from_buffer_copy(w.model)
            setattr(broken, field, None)
            status, _, why = visit(self.lib, 1, w, model=broken)
            self.assertEqual(status, ARGUMENT, field)
            self.assertTrue(why)
            self.assertEqual(w.events, [])
        self.assertEqual(w.snapshot()[1], 1)

    def test_small_capacities_are_checked_against_the_actual_arrays(self):
        w = World([1, 2, 3, 4])
        small = Model.from_buffer_copy(w.model)
        small.item_capacity = 3  # count 4 does not fit
        status, _, _ = visit(self.lib, 1, w, model=small)
        self.assertEqual(status, BOUNDS)
        w = World([1, 2, 3, 4])
        small = Model.from_buffer_copy(w.model)
        small.presence_capacity = 3  # removing id 3 would write outside
        status, _, _ = visit(self.lib, 3, w, model=small)
        self.assertEqual(status, BOUNDS)
        status, r, _ = visit(self.lib, 1, w, model=small)  # id 1 is inside
        self.assertEqual((status, r.found), (OK, 1))

    def test_host_failure_keeps_the_committed_model_and_skips_the_held_clear(self):
        for rebuild_status in (1, -1, 255):
            with self.subTest(rebuild_status=rebuild_status):
                w = World([4, 6, 8], held=6, rebuild_status=rebuild_status)
                status, r, why = visit(self.lib, 6, w)
                self.assertEqual(status, HOST)
                self.assertTrue(why)
                self.assertEqual((r.found, r.rebuild_called, r.held_cleared, r.completed), (1, 1, 0, 0))
                held, count, words, presence = w.snapshot()
                self.assertEqual((held, count, presence[6]), (6, 2, 0))
                self.assertEqual(list(words[:3]), [4, 8, 8])
                self.assertEqual(len(w.events), 1)

    def test_repeated_visits_are_independent_and_idempotent_for_the_list(self):
        w = World([4, 6], held=4)
        for _ in range(2):
            status, r, _ = visit(self.lib, 4, w)
            self.assertEqual(status, OK)
        self.assertEqual(len(w.events), 1)  # second visit found nothing
        self.assertEqual((w.count.value, w.held.value), (1, -1))


Config = session.SessionConfig
CaptionFn = c.CFUNCTYPE(None)


class BindHost(c.Structure):
    _fields_ = [('model', Model), ('view', Host)]


class Fixture:
    def __init__(self, test, lib, actions, world=None, **world_options):
        self.lib = lib
        self.world = world or World([4, 6, 8], **world_options)
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world()
        self.host = BindHost(self.world.model, self.world.host)
        self.binding = lib.session_a79_create(c.byref(self.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a79_begin_scene(self.binding, self.scene), 0)
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a79_handler', lib))
        self.bindings = (session.Binding * 1)(session.Binding(0x79, 11, handler, self.binding))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6400,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        self.keep = [prepare, media, handler]
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a79_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)

    def tick(self):
        out = session.SceneSessionTickResult()
        return self.lib.scene_session_tick(self.session, c.byref(out)), out

    def state(self, index=0):
        out = session.RuntimeState()
        assert self.lib.scene_session_get_action_state(self.session, index, c.byref(out)) == 0
        return out.completed, out.phase


def word(value):
    return session.i16(value if value < 0x8000 else value - 0x10000)


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        cls.lib.session_a79_create.argtypes = [c.POINTER(BindHost)]
        cls.lib.session_a79_create.restype = c.c_void_p
        cls.lib.session_a79_destroy.argtypes = [c.c_void_p]
        cls.lib.session_a79_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
        cls.lib.session_a79_begin_scene.restype = c.c_int
        cls.lib.session_a79_handler.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo), c.POINTER(session.RuntimeState),
            c.POINTER(session.HandlerResult)]
        cls.lib.session_a79_handler.restype = c.c_int
        cls.lib.session_a79_failure.argtypes = [c.c_void_p]
        cls.lib.session_a79_failure.restype = c.c_char_p
        cls.lib.session_a79_item_word.argtypes = [c.c_void_p, c.c_size_t]
        cls.lib.session_a79_item_word.restype = c.c_int32
        cls.lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo)]

    def test_true_gate_visit_removes_completes_directly_and_keeps_phase(self):
        for subtype in (0, 1, 2, 3, 255):
            with self.subTest(subtype=subtype):
                f = Fixture(self, self.lib, [session.action(0x79, subtype, word(6))], held=6)
                self.assertEqual(f.tick()[0], session.SESSION_OK)
                self.assertEqual(f.state(), (1, 0))
                self.assertEqual(f.world.snapshot()[1], 2)
                self.assertEqual(f.world.held.value, -1)
                self.assertEqual(len(f.world.events), 1)
                # Completed rows are never revisited, whatever the subtype.
                self.assertEqual(f.tick()[0], session.SESSION_OK)
                self.assertEqual(len(f.world.events), 1)

    def test_binding_records_the_load_time_item_word(self):
        f = Fixture(self, self.lib, [session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0)),
                                     session.action(0x79, 1, word(0xfffe))])
        self.assertEqual(self.lib.session_a79_item_word(f.binding, 0), -1)
        self.assertEqual(self.lib.session_a79_item_word(f.binding, 1), 0xfffe)
        self.assertEqual(self.lib.session_a79_item_word(f.binding, 2), -1)

    def test_false_gate_has_no_effect_then_true_gate_runs_once(self):
        deps = session.flag_gate(3)
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(8), (deps,))], held=8)
        before = f.world.snapshot()
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.snapshot(), before)
        self.assertEqual(f.world.events, [])
        f.flags[3] = 1
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(len(f.world.events), 1)
        self.assertEqual(f.world.held.value, -1)
        self.assertEqual(f.world.snapshot()[1], 2)

    def test_false_gate_subtype_two_is_not_a_reset_for_this_family(self):
        f = Fixture(self, self.lib, [session.action(0x79, 2, word(8), (session.flag_gate(3),))])
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.state(), (1, 0))
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.state(), (1, 0))

    def test_two_rows_apply_in_act_order_in_one_pass_with_flag_between(self):
        rows = [session.action(0x79, 1, word(4)),
                session.action(0x61, 1, session.i16(5) + session.i16(1) + session.i16(-1) + session.i16(0)),
                session.action(0x79, 1, word(8), (session.flag_gate(5),))]
        f = Fixture(self, self.lib, rows, held=8)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual([f.state(i)[0] for i in range(3)], [1, 1, 1])
        self.assertEqual([e[1] for e in f.world.events], [4, 8])
        # Each rebuild sees every earlier removal of the same pass.
        self.assertEqual((f.world.events[0][2][1], list(f.world.events[0][2][2][:2])), (2, [6, 8]))
        self.assertEqual((f.world.events[1][2][1], list(f.world.events[1][2][2][:1])), (1, [6]))
        self.assertEqual(f.world.snapshot()[1], 1)
        self.assertEqual(f.world.held.value, -1)

    def test_duplicate_rows_for_the_same_item_remove_one_entry_each(self):
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(4)), session.action(0x79, 1, word(4))],
                    world=World([4, 4, 5]))
        f.tick()
        self.assertEqual((f.world.count.value, list(f.world.items[:2])), (1, [5, 5]))
        self.assertEqual(len(f.world.events), 2)

    def test_missing_rebuild_provider_blocks_only_when_the_item_is_found(self):
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(6))], held=6, provider=False)
        before = f.world.snapshot()
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x79))
        self.assertEqual(result.failure.detail_status, 1)
        self.assertIn(b'rebuild', self.lib.session_a79_failure(f.binding))
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.snapshot(), before)
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(9))], held=9, provider=False)
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual((f.state(), f.world.held.value), ((1, 0), -1))

    def test_host_failure_blocks_without_completing_or_clearing_held(self):
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(6))], held=6, rebuild_status=1)
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.world.held.value, 6)
        self.assertEqual(f.world.snapshot()[1], 2)  # committed: the original has no rollback
        self.assertIn(b'rebuild', self.lib.session_a79_failure(f.binding))

    def test_bounds_rejection_blocks_without_effects(self):
        w = World([4, 6, 8], held=6)
        w.count.value = CAPACITY + 3
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(6))], world=w)
        before = w.snapshot()
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))
        self.assertEqual(w.snapshot(), before)
        self.assertEqual(f.state(), (0, 0))
        self.assertIn(b'bounds', self.lib.session_a79_failure(f.binding))

    def test_dependency_tail_row_uses_the_two_byte_prefix(self):
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(4), (session.flag_gate(1),))])
        self.assertEqual(self.lib.session_a79_item_word(f.binding, 0), 4)

    def test_handler_rejects_foreign_rows_and_bad_arguments(self):
        f = Fixture(self, self.lib, [session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0)),
                                     session.action(0x79, 1, word(4))])
        action = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for index in (0, 99):
            self.assertEqual(self.lib.session_a79_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(f.world.events, [])
        self.assertEqual(self.lib.session_a79_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_scene_reload_replaces_rows_and_a_new_scene_without_rows_is_valid(self):
        f = Fixture(self, self.lib, [session.action(0x79, 1, word(4))])
        other, owner = session.open_scene(self.lib, [session.action(0x79, 1, word(8)),
                                                      session.action(0x79, 1, word(9))])
        self.assertEqual(self.lib.session_a79_begin_scene(f.binding, other), 0)
        self.assertEqual([self.lib.session_a79_item_word(f.binding, i) for i in range(3)], [8, 9, -1])
        empty, owner2 = session.open_scene(self.lib, [])
        self.assertEqual(self.lib.session_a79_begin_scene(f.binding, empty), 0)
        self.assertEqual(self.lib.session_a79_item_word(f.binding, 0), -1)
        self.assertNotEqual(self.lib.session_a79_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(other)
        self.lib.scene_resource_close(empty)
        del owner, owner2


if __name__ == '__main__':
    unittest.main()
