"""RT-43: the inventory examine step 0x4ea269 (src/inventory_examine_runtime.c) and its click branch 0x4e8f0e.

Original facts under test (GAME.EXE, SHA-256 afd337a2...485c45; the original-x86 oracle is
tests/inventory_examine_runtime_original_oracle.py):
 * 0x4ea269(item, take, sound), in order: a pending selector word 0x583f1d != -1 is put back with the add step 0x4e9e84(selector, 1);
   when the selector is -1 instead, the saver 0x4eb70f(2) fills the second saved-scene record 0x5c3a1b; selector :=
   (take word == 1 ? item : -1); the remove step 0x4ea06c(item); sound 0x17 when sound != 0; the scene request words
   (0x5bb57b := the item's text word, 0x5bb599 = 0x5bb595 = 0, 0x5c39ff := the item's word at +0x34, 0x5bb59b = 0x5bb59f = 0,
   0x5bb5a3 = 1, mode 0x583999 = 4); the view close 0x4e7d04;
 * the click branch 0x4e8f0e (kind 3, text word not 0/0x270f, aux 0x583ced == 0) calls it with (hot, 1, 1) and returns 1.
"""
import ctypes as c
import os
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest

import test_action_family_78_runtime as t78
import test_inventory_view_runtime as iv

PROJECT = Path(__file__).resolve().parents[1]
BAD_ARGUMENT, UNSUPPORTED, BOUNDS, HOST = t78.ARGUMENT, t78.UNSUPPORTED, t78.BOUNDS, t78.HOST
OK = t78.OK
SELECTOR_NONE = -1

t78.EFFECT_NAMES.update({0x50: 'examine', 0x51: 'examine_save', 0x52: 'examine_selector', 0x53: 'examine_sound',
                         0x54: 'examine_scene', 0x55: 'close'})


class Current(c.Structure):
    _fields_ = [('scene_5bb57b', c.c_int32), ('scene_5bb57f', c.c_int32), ('word_5bb50b', c.c_int16),
                ('word_5bb593', c.c_int16), ('dword_5bb5a7', c.c_int32), ('dword_5bb5ab', c.c_int32),
                ('dword_5bb5af', c.c_int32)]


class Slot(c.Structure):
    _fields_ = [('marker_5c3a1b', c.c_int16), ('scene_5c3a1d', c.c_int16), ('word_5c3a1f', c.c_int16),
                ('word_5c3a21', c.c_int16), ('word_5c3a23', c.c_int16), ('dword_5c3a25', c.c_int32),
                ('dword_5c3a29', c.c_int32), ('dword_5c3a2d', c.c_int32)]


class Request(c.Structure):
    _fields_ = [('scene_5bb57b', c.c_int32), ('word_5bb599', c.c_int16), ('word_5bb595', c.c_int16),
                ('word_5c39ff', c.c_int16), ('dword_5bb59b', c.c_int32), ('dword_5bb59f', c.c_int32),
                ('dword_5bb5a3', c.c_int32), ('mode_583999', c.c_int32)]

    def tuple(self):
        return tuple(getattr(self, n) for n, _ in self._fields_)


class ExamineResult(c.Structure):
    _fields_ = [(n, c.c_uint8) for n in ('put_back', 'added', 'saved', 'removed', 'sound_requested', 'closed',
                                         'request_made')] + [('request', Request)]


LoadFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(Current))
SceneFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(Request))


class ExamineHost(c.Structure):
    _fields_ = [('context', c.c_void_p), ('load_current', LoadFn), ('scene_change', SceneFn)]


class Examine(c.Structure):
    _fields_ = [('selector', c.POINTER(c.c_int16)), ('slot', c.POINTER(Slot)), ('flag_word', c.POINTER(c.c_int16)),
                ('host', ExamineHost)]


_BUILT = {}


def library():
    """The inventory view + examine library: the Mac build script (or INVVIEW_RUNTIME_LIBRARY) when available, else a plain
    cc build of the same sources into a temporary directory (the cloud box has no xcrun). Nothing is exported to the
    environment."""
    if 'INVVIEW_RUNTIME_LIBRARY' in os.environ or shutil.which('xcrun'):
        return iv.build_library()
    if 'path' not in _BUILT:
        directory = Path(tempfile.mkdtemp(prefix='invexamine-'))
        out = directory / 'libinventoryview_runtime.so'
        src = PROJECT / 'src'
        done = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1',
                               '-fPIC', '-shared', '-I', str(src)] +
                              [str(src / n) for n in ('action_family_79_runtime.c', 'action_family_78_runtime.c',
                                                      'inventory_view_runtime.c', 'inventory_examine_runtime.c',
                                                      'action_family_7d_runtime.c')] + ['-o', str(out)],
                              capture_output=True, text=True)
        if done.returncode != 0:
            raise RuntimeError(done.stderr)
        _BUILT['path'] = out
    return _BUILT['path']


def bind(path=None):
    lib = iv.bind(path or library())
    lib.inventory_examine.argtypes = [c.POINTER(iv.View), c.POINTER(iv.ItemData), c.POINTER(t78.Model78),
                                      c.POINTER(iv.ViewHost), c.POINTER(Examine), c.c_int16, c.c_int16, c.c_int32,
                                      c.POINTER(ExamineResult), c.POINTER(c.c_char_p)]
    lib.inventory_examine_words_from_inv.argtypes = [c.c_char_p, c.c_size_t, c.POINTER(c.c_int16)]
    return lib


CURRENT = Current(0x1234, 0x2345, 0x3456 - 0x10000, 0x4567, 0x11111111, 0x22222222, 0x33333333)


class ExamineFixture(iv.Fixture):
    """An open inventory view (screen state 3, mode 2) over a World78, with the examine configuration attached."""
    def __init__(self, lib, items=(), selector=-1, text=None, w782=None, load_status=0, scene_status=0,
                 with_load=True, with_scene=True, **kw):
        super().__init__(lib, items=items, text=text or [100 + i for i in range(70)], kind=[3] * 70, **kw)
        self.view.screen_state = 3
        self.view.mode = 2
        self.selector = c.c_int16(selector)
        self.slot = Slot(9999, 9999, 7, 8, 9, 10, 11, 12)
        self.flags = (c.c_int16 * 70)(*(w782 or [5000 + i for i in range(70)]))
        self.requests, self.loads = [], 0
        log = self.world.log
        status = [load_status, scene_status]

        @LoadFn
        def load_current(_ctx, out):
            log.append(('load_call',))
            out[0] = CURRENT
            return status[0]

        @SceneFn
        def scene_change(_ctx, request):
            log.append(('scene_call', request[0].tuple()))
            self.requests.append(request[0].tuple())
            return status[1]

        self.keep = self.keep + (load_current, scene_change)
        self.status = status
        self.examine = Examine(c.pointer(self.selector), c.pointer(self.slot), c.cast(self.flags, c.POINTER(c.c_int16)),
                               ExamineHost(None, load_current if with_load else LoadFn(),
                                           scene_change if with_scene else SceneFn()))
        self.host.examine = c.cast(c.pointer(self.examine), c.c_void_p)

    def call(self, item, take=1, sound=1, with_examine=True):
        result, failure = ExamineResult(), c.c_char_p()
        self.world.model.view.mode = self.view.mode
        self.world.model.view.slot_flag = 1
        status = self.lib.inventory_examine(c.byref(self.view), c.byref(self.data), c.byref(self.world.model),
                                            c.byref(self.host), c.byref(self.examine) if with_examine else None,
                                            item, take, sound, c.byref(result), c.byref(failure))
        return status, result, failure.value

    def names(self):
        return [e[0] for e in self.world.log]

    def record(self):
        s = self.slot
        return (s.marker_5c3a1b, s.scene_5c3a1d, s.word_5c3a1f, s.word_5c3a21, s.word_5c3a23, s.dword_5c3a25,
                s.dword_5c3a29, s.dword_5c3a2d)


class ExamineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = bind()

    def fixture(self, items=(3, 5, 7), **kw):
        return ExamineFixture(self.lib, items=items, **kw)

    def test_save_path_fills_the_record_then_selects_removes_and_requests_the_scene(self):
        f = self.fixture()
        status, r, why = f.call(5)
        self.assertEqual((status, why), (OK, b'none'))
        names = f.names()
        self.assertEqual([n for n in names if not n.endswith('_call') and n != 'rebuild'],
                         ['examine', 'examine_save', 'examine_selector', 'visit', 'count79', 'list79', 'presence79',
                          'examine_sound', 'examine_scene', 'close'])
        self.assertLess(names.index('load_call'), names.index('examine_save'))
        self.assertLess(names.index('rebuild_call'), names.index('view_sound_call'))
        self.assertLess(names.index('view_sound_call'), names.index('scene_call'))
        self.assertLess(names.index('scene_call'), names.index('close_call'))
        # the record: 0x5bb57b / 0x5bb57f / 0x5bb50b / 0x5bb593 low words, type 2, 0x5bb5a7, and 0x5bb5af in the
        # second dword (the 0x5bb5ab copy is overwritten); the third dword is never written
        self.assertEqual(f.record(), (0x1234, 0x2345, 0x3456, 0x4567, 2, 0x11111111, 0x33333333, 12))
        self.assertEqual(f.selector.value, 5)
        held, count, words, presence = f.world.snapshot()
        self.assertEqual((held, count, list(words[:3]), presence[5]), (-1, 2, [3, 7, 7], 0))   # the stale third word stays
        self.assertEqual(f.requests, [(105, 0, 0, 5005, 0, 0, 1, 4)])
        self.assertEqual((f.view.screen_state, f.view.mode, f.view.tab), (0, 0, -1))
        self.assertEqual((r.put_back, r.saved, r.removed, r.sound_requested, r.closed, r.request_made),
                         (0, 1, 1, 1, 1, 1))
        self.assertEqual(r.request.tuple(), (105, 0, 0, 5005, 0, 0, 1, 4))

    def test_pending_selector_is_added_back_and_the_record_is_left_alone(self):
        f = self.fixture(items=(3, 5, 7), selector=9)
        status, r, _ = f.call(5)
        self.assertEqual(status, OK)
        self.assertNotIn('load_call', f.names())
        self.assertNotIn('examine_save', f.names())
        self.assertEqual(f.record(), (9999, 9999, 7, 8, 9, 10, 11, 12))
        self.assertEqual(f.names()[:3], ['examine', 'add_flagged', 'sound'])
        held, count, words, presence = f.world.snapshot()
        self.assertEqual((count, list(words[:3]), presence[9], presence[5]), (3, [3, 7, 9], 1, 0))   # item-last layout (mode 2, slot flag 1), then 5 removed
        self.assertEqual(f.selector.value, 5)
        self.assertEqual((r.put_back, r.added, r.saved), (1, 1, 0))
        # the add step's sound 0x17, then (mode 2: no UI request)
        self.assertEqual(f.world.calls('sound_call'), [('sound_call', 0x17)])
        self.assertEqual(f.world.calls('ui_call'), [])

    def test_selector_zero_is_a_pending_item(self):
        f = self.fixture(items=(3, 5, 7), selector=0)
        status, r, _ = f.call(5)
        self.assertEqual((status, r.put_back, r.saved), (OK, 1, 0))
        self.assertEqual(f.world.snapshot()[3][0], 1)       # presence[0]
        self.assertEqual(f.record(), (9999, 9999, 7, 8, 9, 10, 11, 12))

    def test_negative_scene_word_is_sign_extended(self):
        text = [100 + i for i in range(70)]
        text[5] = -300
        f = self.fixture(text=text)
        self.assertEqual(f.call(5)[0], OK)
        self.assertEqual(f.requests[0][0], -300)

    def test_pending_selector_already_listed_is_a_duplicate(self):
        f = self.fixture(items=(3, 9, 5), selector=9)
        status, r, _ = f.call(5)
        self.assertEqual(status, OK)
        self.assertIn('duplicate', f.names())
        self.assertEqual((r.put_back, r.added), (1, 0))
        self.assertEqual(f.world.snapshot()[1], 2)

    def test_take_word_other_than_one_clears_the_selector(self):
        for take, expected in ((1, 5), (0, -1), (2, -1), (-1, -1), (0x7fff, -1)):
            with self.subTest(take=take):
                f = self.fixture()
                status, _, _ = f.call(5, take=take)
                self.assertEqual(status, OK)
                self.assertEqual(f.selector.value, expected)

    def test_sound_zero_makes_no_request(self):
        f = self.fixture()
        status, r, _ = f.call(5, sound=0)
        self.assertEqual(status, OK)
        self.assertNotIn('examine_sound', f.names())
        self.assertEqual(f.world.calls('view_sound_call'), [])
        self.assertEqual(r.sound_requested, 0)
        f = self.fixture()
        f.call(5, sound=0x100)
        self.assertEqual(f.world.calls('view_sound_call'), [('view_sound_call', 0x17)])

    def test_item_not_in_the_list_still_saves_and_requests_the_scene(self):
        f = self.fixture(items=(3, 7))
        status, r, _ = f.call(5)
        self.assertEqual(status, OK)
        self.assertEqual((r.removed, r.saved, r.request_made), (0, 1, 1))
        self.assertEqual(f.world.snapshot()[1], 2)

    def test_items_outside_the_records_are_refused_before_any_effect(self):
        for item in (70, 100, -1, -2, 0x7fff, -0x8000):
            with self.subTest(item=item):
                f = self.fixture()
                before = f.world.snapshot()
                status, _, why = f.call(item)
                self.assertEqual(status, BOUNDS)
                self.assertEqual(f.world.log, [])
                self.assertEqual((f.world.snapshot(), f.selector.value, f.record()), (before, -1, (9999, 9999, 7, 8, 9, 10, 11, 12)))

    def test_step_refused_by_the_shared_steps_changes_nothing(self):
        # selector 70 would need a presence write past the array; the dry run refuses before the add commits
        f = self.fixture(selector=70)
        before = f.world.snapshot()
        status, _, _ = f.call(5)
        self.assertEqual(status, BOUNDS)
        self.assertEqual((f.world.log, f.world.snapshot(), f.selector.value), ([], before, 70))
        # a count above the item array: the remove step would scan past it
        f = self.fixture(count=75)
        status, _, _ = f.call(5)
        self.assertEqual((status, f.world.log, f.record()), (BOUNDS, [], (9999, 9999, 7, 8, 9, 10, 11, 12)))
        # a full list and a selector that must be inserted
        f = self.fixture(items=list(range(2, 70)) + [1, 0], selector=70)
        status, _, _ = f.call(5)
        self.assertEqual((status, f.world.log), (BOUNDS, []))

    def test_missing_providers_are_refused_before_any_effect(self):
        f = self.fixture(with_scene=False)
        self.assertEqual((f.call(5)[0], f.world.log), (UNSUPPORTED, []))
        f = self.fixture(with_load=False)
        self.assertEqual((f.call(5)[0], f.world.log), (UNSUPPORTED, []))
        f = self.fixture(with_load=False, selector=9)          # no save: the load provider is not needed
        self.assertEqual(f.call(5)[0], OK)
        f = self.fixture(providers=False)
        self.assertEqual((f.call(5)[0], f.world.log), (UNSUPPORTED, []))
        f = self.fixture(providers=False)
        self.assertEqual((f.call(5, sound=0)[0], f.world.log), (UNSUPPORTED, []))      # the remove step needs the rebuild

    def test_missing_sound_provider_is_refused_only_when_a_sound_is_asked_for(self):
        f = self.fixture()
        f.host.request_sound = iv.SoundFn()
        before = f.world.snapshot()
        self.assertEqual((f.call(5)[0], f.world.log, f.world.snapshot()), (UNSUPPORTED, [], before))
        self.assertEqual(f.call(5, sound=0)[0], OK)

    def test_load_current_failure_changes_nothing(self):
        f = self.fixture(load_status=1)
        before = f.world.snapshot()
        status, _, _ = f.call(5)
        self.assertEqual(status, HOST)
        self.assertEqual((f.world.snapshot(), f.selector.value, f.requests, f.view.screen_state), (before, -1, [], 3))

    def test_scene_change_refusal_keeps_the_earlier_effects_and_leaves_the_view_open(self):
        f = self.fixture(scene_status=1)
        status, r, _ = f.call(5)
        self.assertEqual(status, HOST)
        self.assertEqual((f.selector.value, f.world.snapshot()[1], f.record()[4], f.view.screen_state), (5, 2, 2, 3))
        self.assertNotIn('close_call', f.names())
        self.assertEqual((r.removed, r.request_made, r.closed), (1, 1, 0))

    def test_sound_failure_stops_before_the_scene_request(self):
        f = ExamineFixture(self.lib, items=(3, 5, 7), view_sound_status=1)
        status, _, _ = f.call(5)
        self.assertEqual(status, HOST)
        self.assertEqual((f.requests, f.selector.value, f.world.snapshot()[1], f.view.screen_state), ([], 5, 2, 3))

    def test_view_teardown_failure_still_closes_the_view(self):
        f = ExamineFixture(self.lib, items=(3, 5, 7), close_status=1)
        status, r, _ = f.call(5)
        self.assertEqual(status, HOST)
        self.assertEqual((f.view.screen_state, r.closed, len(f.requests)), (0, 1, 1))

    def test_null_and_missing_arguments(self):
        f = self.fixture()
        self.assertEqual(f.call(5, with_examine=False)[0], BAD_ARGUMENT)
        f.examine.selector = None
        self.assertEqual(f.call(5)[0], BAD_ARGUMENT)
        self.assertEqual(f.world.log, [])


class ClickBranchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = bind()

    def fixture(self, **kw):
        f = ExamineFixture(self.lib, items=(3, 5, 7), **kw)
        f.view.hot = 5
        f.view.event = 0x2717
        return f

    def test_read_branch_examines_with_take_and_sound(self):
        f = self.fixture()
        status, result, why = f.click()
        self.assertEqual((status, why), (OK, b'none'))
        self.assertEqual(result.tuple(), (1, 1, 0, 0, 1, 1, 1, 0))     # gate, handled, closed, one sound, removed
        self.assertEqual(f.selector.value, 5)
        self.assertEqual(f.requests, [(105, 0, 0, 5005, 0, 0, 1, 4)])
        self.assertEqual(f.view.screen_state, 0)
        self.assertEqual(f.world.calls('view_sound_call'), [('view_sound_call', 0x17)])

    def test_pending_item_adds_back_in_the_live_view_layout(self):
        f = self.fixture(selector=9)
        f.layout.slot_flag = 1                # item-last layout together with mode 2
        status, result, _ = f.click()
        self.assertEqual(status, OK)
        self.assertEqual(list(f.world.snapshot()[2][:3]), [3, 7, 9])
        self.assertEqual(result.tuple()[7], 1)

    def test_without_the_configuration_the_branch_stays_unmodeled(self):
        f = self.fixture()
        f.host.examine = None
        before = f.world.snapshot()
        status, result, why = f.click()
        self.assertEqual(status, iv.UNMODELED)
        self.assertIn(b'0x4ea269', why)
        self.assertEqual((f.world.log, f.world.snapshot(), f.selector.value), ([], before, -1))

    def test_other_clicks_do_not_examine(self):
        for kind, text, aux in ((2, 100, 0), (3, 0, 0), (3, 0x270f, 0), (3, 100, 1)):
            with self.subTest(kind=kind, text=text, aux=aux):
                f = self.fixture()
                f.kind[5], f.text[5], f.aux_a[5] = kind, text, aux
                f.click()
                self.assertEqual((f.requests, f.selector.value), ([], -1))

    def test_failure_is_reported_and_nothing_is_handled(self):
        f = self.fixture(scene_status=1)
        status, result, _ = f.click()
        self.assertEqual((status, result.handled), (HOST, 0))


class RecordWordTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = bind()

    def test_item_record_words_from_the_real_inv_chunk(self):
        inv = iv.inv_chunk()
        words = (c.c_int16 * 70)()
        self.assertEqual(self.lib.inventory_examine_words_from_inv(inv, len(inv), words), OK)
        expected = [struct.unpack_from('<h', inv, 0xb1 + 0x16d * i + 0x34)[0] for i in range(70)]
        self.assertEqual(list(words), expected)
        kind, text = (c.c_int16 * 70)(), (c.c_int16 * 70)()
        self.lib.inventory_view_items_from_inv(inv, len(inv), kind, text)
        examinable = [i for i in range(70) if kind[i] == 3 and text[i] not in (0, 0x270f)]
        self.assertEqual(examinable, [2, 10, 14, 28, 30, 33, 36, 37, 38, 39, 46])
        self.assertEqual([text[i] for i in examinable], [6200, 6215, 6205, 6210, 6260, 6235, 6240, 6245, 6250, 6270, 6255])
        self.assertEqual({words[i] for i in examinable}, {1})

    def test_short_chunk_and_nulls_are_refused(self):
        inv = iv.inv_chunk()
        words = (c.c_int16 * 70)()
        self.assertEqual(self.lib.inventory_examine_words_from_inv(inv, 25726, words), BAD_ARGUMENT)
        self.assertEqual(self.lib.inventory_examine_words_from_inv(None, 25727, words), BAD_ARGUMENT)


if __name__ == '__main__':
    unittest.main()
