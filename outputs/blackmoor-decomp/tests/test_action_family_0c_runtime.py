"""RT-20: raw 0x0c "multi-frame scene-change hotspot" runtime and session binding.

Written before the implementation. Runtime facts under test (original loader arm
0x40bafd, dispatcher arm 0x427c4e (gate mode 0), handler 0x42b2e4, pointer
cascade 0x4f0059 case 0x4f2033):

 * the loader copies the typed body verbatim: four words (the cursor word, the
   target scene, the word the target scene starts with, a word), a signed count
   at +8 and count 18-byte records at +10 (word frame, four dwords);
 * handler phase 0 stores 0x5bb1ca := 1 and the row phase := 1, then runs phase 1
   in the same call;
 * phase 1 clears the row request dword (0x5bb626), then scans the records for the
   FIRST whose frame word equals the selector 0x5bb50b (both sign-extended); a
   hit stores request := 1 and the low words of the four rectangle dwords into the
   row rectangle words;
 * phase 2 stores the completion byte directly, then 0x5bb57b := sext(+2),
   0x5bb599 := word +4, 0x5c39ff := word +6, 0x5bb595 := 0, 0x5bb59b := 0,
   0x5bb59f := 0, 0x5bb5a3 := 1, and sets the engine mode 0x583999 := 4;
 * any other phase value has no effect.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

import session_binding_support as session
import test_action_family_0b_runtime as t0b
import test_action_family_17_runtime as t17
import test_scene_session_pointer as pointer

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily0c_runtime.dylib'
OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST = range(5)
Slot, World, Host, Result, Cursor = t17.Slot, t17.World, t17.Host, t17.Result, t17.Cursor
SURFACE_NONE, SURFACE_DEFAULT, SURFACE_HELD = range(3)

# S2010 row 5 (resource 1385): cursor word 0, target 2008, entry word 0, word 1, five records.
S2010_ROW5_RECORDS = [(4, 3, 2, 200, 114), (5, 117, 15, 292, 108), (6, 233, 18, 422, 105),
                      (7, 354, 14, 550, 103), (8, 470, 4, 619, 98)]


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('A0C_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'A0C_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_0c_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


def body(cursor=0, target=2008, entry=0, word6=1, records=S2010_ROW5_RECORDS, count=None, extra=b''):
    """Typed 0x0c body: cursor word, target scene, entry word, word, signed count, records.
    A record is (frame, left, top, right, bottom): a word then four dwords."""
    out = (t17.i16(cursor) + t17.i16(target) + t17.i16(entry) + t17.i16(word6) +
           t17.i16(len(records) if count is None else count))
    for frame, left, top, right, bottom in records:
        out += t17.i16(frame) + b''.join(t17.i32(v) for v in (left, top, right, bottom))
    return out + extra


S2010_ROW5 = body()


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.action0c_step.argtypes = [c.c_char_p, c.c_size_t, c.c_uint32, c.POINTER(Slot),
                                  c.POINTER(World), c.POINTER(Host), c.POINTER(Result),
                                  c.POINTER(c.c_char_p)]
    lib.action0c_step.restype = c.c_int
    lib.action0c_validate_body.argtypes = [c.c_char_p, c.c_size_t, c.POINTER(c.c_char_p)]
    lib.action0c_validate_body.restype = c.c_int
    lib.action0c_hover_cursor.argtypes = [c.c_char_p, c.c_size_t, c.c_int16, c.POINTER(Cursor)]
    lib.action0c_hover_cursor.restype = c.c_int
    return lib


class Case(t17.Case):
    """One kernel call with an ordered effect log (the RT-15 harness, 0x0c entry point)."""
    def run(self, data=None, length=None):
        result, why = Result(), c.c_char_p()
        raw = self.data if data is None else data
        status = self.lib.action0c_step(raw, len(raw) if length is None else length, self.phase,
                                        c.byref(self.slot), c.byref(self.world),
                                        c.byref(self.host) if self.with_host else None,
                                        c.byref(result), c.byref(why))
        return status, result, why.value


class KernelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_phase_zero_starts_then_scans_in_the_same_call(self):
        case = Case(self.lib, S2010_ROW5, 0, selector=5)
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log, [('start_flag', 1), ('phase', 1), ('request', 0),
                                    ('request', 1), ('left', 117), ('top', 15), ('right', 292),
                                    ('bottom', 108)])
        self.assertEqual(case.state()[0], (1, 117, 15, 292, 108, 0))
        self.assertEqual(case.world.start_flag_5bb1ca, 1)
        self.assertEqual(case.world.mode_583999, 3)
        self.assertEqual((result.phase_after, result.matched_record, result.finished,
                          result.requested), (1, 1, 0, 1))

    def test_phase_one_clears_the_request_first_and_has_no_start_or_phase_store(self):
        case = Case(self.lib, S2010_ROW5, 1, selector=8,
                    slot=Slot(request=1, left=1, top=2, right=3, bottom=4, done=0))
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual([name for name, _ in case.log],
                         ['request', 'request', 'left', 'top', 'right', 'bottom'])
        self.assertEqual(case.log[:2], [('request', 0), ('request', 1)])
        self.assertEqual(case.state()[0], (1, 470, 4, 619, 98, 0))
        self.assertEqual(case.world.start_flag_5bb1ca, -5)
        self.assertEqual((result.phase_after, result.matched_record), (1, 4))

    def test_no_matching_frame_leaves_a_cleared_request_and_the_stale_rectangle(self):
        for selector in (0, 1, 3, 9, -1, 1002):
            with self.subTest(selector=selector):
                case = Case(self.lib, S2010_ROW5, 1, selector=selector,
                            slot=Slot(request=1, left=11, top=12, right=13, bottom=14, done=0))
                status, result, _ = case.run()
                self.assertEqual(status, OK)
                self.assertEqual(case.log, [('request', 0)])
                self.assertEqual(case.state()[0], (0, 11, 12, 13, 14, 0))
                self.assertEqual((result.matched_record, result.requested), (-1, 0))

    def test_first_of_duplicate_frames_wins_and_scan_stops(self):
        records = [(5, 1, 2, 3, 4), (5, 10, 20, 30, 40), (5, 100, 200, 300, 400)]
        case = Case(self.lib, body(records=records), 1, selector=5)
        status, result, _ = case.run()
        self.assertEqual((status, result.matched_record), (OK, 0))
        self.assertEqual(case.state()[0], (1, 1, 2, 3, 4, 0))
        self.assertEqual([name for name, _ in case.log].count('request'), 2)

    def test_frame_words_compare_as_sign_extended_words(self):
        records = [(-2, 1, 2, 3, 4), (0x7fff, 5, 6, 7, 8), (-32768, 9, 10, 11, 12),
                   (-32767, 13, 14, 15, 16), (1, 17, 18, 19, 20)]
        for selector, expect in ((-2, 0), (0x7fff, 1), (-32768, 2), (-32767, 3), (1, 4),
                                 (2, -1), (-3, -1)):
            with self.subTest(selector=selector):
                case = Case(self.lib, body(records=records), 1, selector=selector)
                status, result, _ = case.run()
                self.assertEqual((status, result.matched_record), (OK, expect))

    def test_rectangle_cells_are_the_low_words_of_the_record_dwords(self):
        record = (9, 0x12345, -70000, 0x8000, 0xffff)
        case = Case(self.lib, body(records=[record]), 1, selector=9)
        status, _, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.state()[0][1:5], (t17.s16(0x12345), t17.s16(-70000), -32768, -1))

    def test_finish_phase_stores_in_the_original_order_and_requests_the_scene_change(self):
        # 0x42b47d..: done byte, 5bb57b := sext(+2), 5bb599 := +4, 5c39ff := +6, then the constants
        # 5bb595 := 0, 5bb59b := 0, 5bb59f := 0, 5bb5a3 := 1 and the mode.
        data = body(cursor=3, target=2008, entry=-4, word6=7)
        case = Case(self.lib, data, 2, selector=5,
                    slot=Slot(request=1, left=1, top=2, right=3, bottom=4, done=0))
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log, [('done', 1), ('xfer_5bb57b', 2008), ('xfer_5bb599', -4),
                                    ('xfer_5c39ff', 7), ('xfer_5bb595', 0), ('xfer_5bb59b', 0),
                                    ('xfer_5bb59f', 0), ('xfer_5bb5a3', 1), ('mode', 4)])
        slot, world = case.state()
        self.assertEqual(slot, (1, 1, 2, 3, 4, 1))      # request and rectangle untouched
        self.assertEqual(world, (-5, 4, 2008, -4, 0, 7, 0, 0, 1))
        self.assertEqual((result.phase_after, result.finished), (2, 1))

    def test_finish_does_not_depend_on_the_records_or_the_selector(self):
        for records in ([], S2010_ROW5_RECORDS, [(1, 1, 1, 1, 1)] * 3):
            for selector in (0, 5, -7):
                with self.subTest(records=len(records), selector=selector):
                    case = Case(self.lib, body(records=records), 2, selector=selector)
                    status, _, _ = case.run()
                    self.assertEqual(status, OK)
                    self.assertEqual(case.world.xfer_5bb57b, 2008)

    def test_finish_target_is_sign_extended_and_the_cursor_word_is_not_copied(self):
        case = Case(self.lib, body(cursor=17, target=-1234, entry=-5, word6=-6), 2)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual((case.world.xfer_5bb57b, case.world.xfer_5bb599, case.world.xfer_5c39ff),
                         (-1234, -5, -6))
        self.assertNotIn(17, [v for _, v in case.log])

    def test_other_phases_do_nothing(self):
        for phase in (3, 4, 7, 0xffffffff):
            with self.subTest(phase=phase):
                case = Case(self.lib, S2010_ROW5, phase, selector=5)
                before = case.state()
                status, result, _ = case.run()
                self.assertEqual(status, OK)
                self.assertEqual(case.log, [])
                self.assertEqual(case.state(), before)
                self.assertEqual((result.phase_after, result.finished, result.requested),
                                 (phase, 0, 0))

    def test_empty_record_list_is_valid(self):
        case = Case(self.lib, body(records=[]), 0, selector=3)
        status, result, _ = case.run()
        self.assertEqual((status, result.matched_record), (OK, -1))
        self.assertEqual(case.log, [('start_flag', 1), ('phase', 1), ('request', 0)])

    def test_maximum_count_is_scanned_to_the_last_record(self):
        records = [(i % 1000 + 5000, i, i, i, i) for i in range(1819)]
        records[-1] = (77, 1, 2, 3, 4)
        case = Case(self.lib, body(records=records), 1, selector=77)
        status, result, _ = case.run()
        self.assertEqual((status, result.matched_record), (OK, 1818))

    def test_the_corpus_shapes_of_the_count_all_validate(self):
        for count in (3, 4, 5, 6, 7, 20):
            with self.subTest(count=count):
                data = body(records=[(i, 1, 2, 3, 4) for i in range(count)])
                self.assertEqual(len(data), 10 + 18 * count)
                why = c.c_char_p()
                self.assertEqual(self.lib.action0c_validate_body(data, len(data), c.byref(why)), OK)

    def test_rejections_change_nothing_and_have_a_reason(self):
        good = S2010_ROW5
        cases = {
            'short prefix': (good[:9], BOUNDS),
            'empty': (b'', BOUNDS),
            'count negative': (body(records=[], count=-1), BOUNDS),
            'count past the maximum': (body(records=[], count=1820), BOUNDS),
            'count past the data': (body(records=S2010_ROW5_RECORDS[:2], count=3), BOUNDS),
            'ragged record': (good[:-1], BOUNDS),
            'trailing bytes': (good + b'\0', BOUNDS),
        }
        for name, (data, expect) in cases.items():
            for phase in (0, 1, 2):
                with self.subTest(name=name, phase=phase):
                    case = Case(self.lib, data, phase, selector=5)
                    before = case.state()
                    status, _, why = case.run(data=data if data else b'\0', length=len(data))
                    self.assertEqual(status, expect)
                    self.assertTrue(why)
                    self.assertEqual(case.log, [])
                    self.assertEqual(case.state(), before)

    def test_counts_past_the_maximum_and_negative_counts_are_rejected_even_with_a_matching_length(self):
        # 1819 is the largest count whose 10 + 18 * n fits a signed 16-bit size (A-0C.1).
        for count, ok in ((1819, True), (1820, False), (0x7fff, False), (0x8000, False),
                          (0xffff, False)):
            with self.subTest(count=count):
                data = body(records=[], count=(count if count < 0x8000 else count - 0x10000))
                data += bytes(18 * count)
                self.assertEqual(len(data), 10 + 18 * count)
                case = Case(self.lib, data, 1, selector=5)
                status, _, why = case.run()
                self.assertEqual(status, OK if ok else BOUNDS, why)
                if not ok:
                    self.assertEqual(case.log, [])

    def test_null_arguments_are_rejected(self):
        slot = Slot(); world = World(); result = Result(); why = c.c_char_p()
        for args in ((None, 10), (S2010_ROW5, 0)):
            self.assertNotEqual(self.lib.action0c_step(args[0], args[1], 0, c.byref(slot),
                                c.byref(world), None, c.byref(result), c.byref(why)), OK)
        for slot_ptr, world_ptr, result_ptr in ((None, c.byref(world), c.byref(result)),
                                                (c.byref(slot), None, c.byref(result)),
                                                (c.byref(slot), c.byref(world), None)):
            self.assertEqual(self.lib.action0c_step(S2010_ROW5, len(S2010_ROW5), 0, slot_ptr,
                                                    world_ptr, None, result_ptr, c.byref(why)),
                             ARGUMENT)
        self.assertEqual(self.lib.action0c_validate_body(None, 10, c.byref(why)), ARGUMENT)

    def test_observer_is_optional(self):
        case = Case(self.lib, S2010_ROW5, 0, selector=5, host=False)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual(case.log, [])
        self.assertEqual(case.state()[0], (1, 117, 15, 292, 108, 0))


class CursorTests(unittest.TestCase):
    """Cascade case 0x4f2033 (type 0x0c): body word 0 is the cursor index (as 0x4f221e for 0x0b)."""
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def hover(self, cursor_word, held):
        data = body(cursor=cursor_word)
        out = Cursor(-99, -99, -99, -99, -99)
        return self.lib.action0c_hover_cursor(data, len(data), held, c.byref(out)), out

    def test_without_a_held_item_every_cursor_word_is_the_index(self):
        for word in (0, 1, 3, 4, 8, 11, 0x1a, 0x1b, 0x7fff, -1, -32768):
            with self.subTest(word=word):
                status, out = self.hover(word, -1)
                self.assertEqual(status, OK)
                self.assertEqual((out.cursor_index, out.variant, out.table_offset, out.held_flag,
                                  out.surface), (word, 1, word * 32 + 16, 0, SURFACE_NONE))

    def test_a_held_item_keeps_words_four_to_0x1a_and_sets_the_flag(self):
        for word in (4, 5, 8, 11, 0x1a):
            with self.subTest(word=word):
                status, out = self.hover(word, 5)
                self.assertEqual(status, OK)
                self.assertEqual((out.cursor_index, out.variant, out.table_offset, out.held_flag,
                                  out.surface), (word, 1, word * 32 + 16, 1, SURFACE_DEFAULT))

    def test_a_held_item_overrides_words_outside_four_to_0x1a(self):
        for word in (0, 1, 2, 3, 0x1b, 0x1c, -1, 100):
            for held in (0, 5, 40, -2):
                with self.subTest(word=word, held=held):
                    status, out = self.hover(word, held)
                    self.assertEqual(status, OK)
                    self.assertEqual((out.cursor_index, out.held_flag, out.surface),
                                     (held + 0x25, 0, SURFACE_HELD))
                    self.assertEqual(out.table_offset, (held + 0x25) * 32 + 16)

    def test_rejections_and_null_arguments(self):
        out = Cursor(7, 7, 7, 7, 7)
        data = S2010_ROW5
        self.assertEqual(self.lib.action0c_hover_cursor(None, 10, -1, c.byref(out)), ARGUMENT)
        self.assertEqual(self.lib.action0c_hover_cursor(data, len(data), -1, None), ARGUMENT)
        self.assertEqual(self.lib.action0c_hover_cursor(data, len(data) - 1, -1, c.byref(out)), BOUNDS)
        self.assertEqual((out.cursor_index, out.surface), (7, 7))


# ---------------------------------------------------------------- binding

def configure(lib):
    t17.configure(lib)
    lib.session_a0c_create.argtypes = [c.POINTER(t17.BindHost)]
    lib.session_a0c_create.restype = c.c_void_p
    lib.session_a0c_destroy.argtypes = [c.c_void_p]
    lib.session_a0c_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
    lib.session_a0c_begin_scene.restype = c.c_int
    lib.session_a0c_handler.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo),
                                        c.POINTER(session.RuntimeState),
                                        c.POINTER(session.HandlerResult)]
    lib.session_a0c_handler.restype = c.c_int
    lib.session_a0c_pre_gate.argtypes = [c.c_void_p, c.c_size_t, c.c_void_p, c.c_void_p]
    lib.session_a0c_pre_gate.restype = None
    lib.session_a0c_pointer_row.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(pointer.InputHotspot)]
    lib.session_a0c_pointer_row.restype = c.c_int
    lib.session_a0c_hover_cursor.argtypes = [c.c_void_p, c.c_size_t, c.c_int16, c.POINTER(Cursor)]
    lib.session_a0c_hover_cursor.restype = c.c_int
    lib.session_a0c_slot.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Slot)]
    lib.session_a0c_slot.restype = c.c_int
    lib.session_a0c_failure.argtypes = [c.c_void_p]
    lib.session_a0c_failure.restype = c.c_char_p
    lib.session_a0c_row_count.argtypes = [c.c_void_p]
    lib.session_a0c_row_count.restype = c.c_size_t
    lib.session_a0c_row_info.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(RowInfo)]
    lib.session_a0c_row_info.restype = c.c_int
    lib.session_a0c_body.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(c.c_size_t)]
    lib.session_a0c_body.restype = c.c_void_p
    # the 0x0b binding is linked into the library for the mixed-scene tests
    t0b.configure(lib)


class RowInfo(c.Structure):
    _fields_ = [('cursor_word', c.c_int16), ('target', c.c_int16), ('entry_word', c.c_int16),
                ('word_06', c.c_int16), ('count', c.c_int16)]

    def tuple(self):
        return (self.cursor_word, self.target, self.entry_word, self.word_06, self.count)


class Fixture:
    def __init__(self, test, lib, actions, rig=None, with_pre_gate=True, pointer_rows=False,
                 with_0b=False):
        self.lib = lib
        self.test = test
        self.rig = rig or t17.Rig17(selector=0)
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world()
        self.binding = lib.session_a0c_create(c.byref(self.rig.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a0c_begin_scene(self.binding, self.scene), 0)
        self.binding_0b = None
        if with_0b:
            self.binding_0b = lib.session_a0b_create(c.byref(self.rig.host))
            test.assertEqual(lib.session_a0b_begin_scene(self.binding_0b, self.scene), 0)
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a0c_handler', lib))
        handler_0b = session.ActionFn(('session_a0b_handler', lib))
        entries = [session.Binding(0x0c, 11, handler, self.binding)]
        if with_0b:
            entries.append(session.Binding(0x0b, 11, handler_0b, self.binding_0b))
        self.bindings = (session.Binding * len(entries))(*entries)
        self.config = session.SessionConfig(scene=self.scene, scene_id=2010,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=len(entries),
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        if with_pre_gate:
            test.assertEqual(lib.scene_session_set_pre_gate(
                self.session, 0x0c, c.cast(lib.session_a0c_pre_gate, c.c_void_p), self.binding), 0)
            if with_0b:
                test.assertEqual(lib.scene_session_set_pre_gate(
                    self.session, 0x0b, c.cast(lib.session_a0b_pre_gate, c.c_void_p),
                    self.binding_0b), 0)
        self.keep = [prepare, media, handler, handler_0b]
        self.rig_pointer = None
        if pointer_rows:
            self.rig_pointer = pointer.Rig(lib)

            @pointer.ExternalFn
            def external(_ctx, index, row):
                return lib.session_a0c_pointer_row(self.binding, index, row)

            self.keep.append(external)
            self.rig_pointer.host.external_row = external
            self.rig_pointer.bind(self.session)
            self.rig_pointer.ctx.cursor = pointer.Rect(250, 60, 250, 60)
        self.rig.lib, self.rig.session = lib, self.session
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a0c_destroy(self.binding)
        if self.binding_0b:
            self.lib.session_a0b_destroy(self.binding_0b)
        self.lib.scene_resource_close(self.scene)

    def tick(self):
        out = session.SceneSessionTickResult()
        return self.lib.scene_session_tick(self.session, c.byref(out)), out

    def state(self, index=0):
        out = session.RuntimeState()
        assert self.lib.scene_session_get_action_state(self.session, index, c.byref(out)) == 0
        return out.completed, out.phase

    def slot(self, index=0):
        out = Slot()
        self.test.assertEqual(self.lib.session_a0c_slot(self.binding, index, c.byref(out)), 0)
        return out.request, out.left, out.top, out.right, out.bottom, out.done

    def row(self, index=0):
        out = pointer.InputHotspot()
        if not self.lib.session_a0c_pointer_row(self.binding, index, c.byref(out)):
            return None
        r = out.rectangle
        return out.index, r.left, r.top, r.right, r.bottom, out.active


FRAME5 = (0, 117, 15, 292, 108, 1)      # row tuple of the frame-5 record on row 0


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        configure(cls.lib)

    def row_action(self, deps=(), subtype=1, **kw):
        return session.action(0x0c, subtype, body(**kw), deps)

    def test_first_tick_registers_and_exports_the_selected_frame_rectangle(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5))
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(f.rig.start_flag, 1)
        self.assertEqual(f.slot(), (1, 117, 15, 292, 108, 0))
        self.assertEqual(f.row(), FRAME5)
        self.assertEqual(f.row(1), None)
        self.assertEqual(f.rig.transitions, [])

    def test_effects_arrive_in_the_original_store_order_with_the_owning_row(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5))
        f.tick()
        self.assertEqual(f.rig.effects, [
            (0, 'request', 0),      # 0x427ad4 prologue clear (pre-gate)
            (0, 'start_flag', 1), (0, 'phase', 1), (0, 'request', 0), (0, 'request', 1),
            (0, 'left', 117), (0, 'top', 15), (0, 'right', 292), (0, 'bottom', 108)])
        f.rig.effects.clear()
        f.tick()                                    # phase 1 visit: pre-gate clear, then the scan
        self.assertEqual(f.rig.effects, [
            (0, 'request', 0), (0, 'request', 0), (0, 'request', 1), (0, 'left', 117),
            (0, 'top', 15), (0, 'right', 292), (0, 'bottom', 108)])

    def test_exported_rectangle_follows_the_selector_each_tick(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=4))
        f.tick()
        for selector, rect in ((4, (3, 2, 200, 114)), (7, (354, 14, 550, 103)),
                               (8, (470, 4, 619, 98))):
            f.rig.selector = selector
            f.tick()
            self.assertEqual(f.row(), (0, *rect, 1))
        f.rig.selector = 99
        f.tick()
        self.assertEqual(f.row(), None)
        self.assertEqual(f.state(), (0, 1))

    def test_pre_gate_clears_the_request_before_a_false_gate(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))],
                    rig=t17.Rig17(selector=5))
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), FRAME5)
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.row(), None)         # cleared although the handler did not run
        self.assertEqual(f.state(), (0, 1))
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), FRAME5)

    def test_pre_gate_only_touches_rows_this_binding_owns(self):
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()], rig=t17.Rig17(selector=5))
        f.tick()
        info, state = session.SceneActionInfo(), session.RuntimeState(0, 0)
        before = list(f.rig.effects)
        for index in (0, 2, 99):        # a foreign row, one past the end, far out of range
            self.lib.session_a0c_pre_gate(f.binding, index, c.byref(info), c.byref(state))
        self.lib.session_a0c_pre_gate(None, 1, c.byref(info), c.byref(state))
        self.assertEqual(f.rig.effects, before)
        self.assertEqual(f.slot(1), (1, 117, 15, 292, 108, 0))      # the owned row's slot is intact
        self.lib.session_a0c_pre_gate(f.binding, 1, c.byref(info), c.byref(state))
        self.assertEqual(f.slot(1), (0, 117, 15, 292, 108, 0))      # an owned row is cleared
        self.assertEqual(f.rig.effects[len(before):], [(1, 'request', 0)])

    def test_false_gate_from_the_start_exports_nothing_and_does_not_start(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))],
                    rig=t17.Rig17(selector=5))
        f.tick()
        self.assertEqual((f.state(), f.row(), f.rig.start_flag), ((0, 0), None, 0))

    def test_gate_mode_for_type_0x0c_is_zero(self):
        self.lib.scene_conditions_gate_mode_for_type.argtypes = [c.c_uint8]
        self.lib.scene_conditions_gate_mode_for_type.restype = c.c_int32
        self.assertEqual(self.lib.scene_conditions_gate_mode_for_type(0x0c), 0)   # arm 0x427c4e

    def test_finish_completes_directly_whatever_the_subtype(self):
        # 0x42b487 stores the completion byte itself: no 0x42ba3a, so subtype 2 does not clear
        # it again and dependencies are not reset.
        for subtype in (0, 1, 2, 3, 255):
            with self.subTest(subtype=subtype):
                row = session.action(0x0c, subtype, S2010_ROW5)
                f = Fixture(self, self.lib, [row], rig=t17.Rig17(selector=5))
                f.tick()
                self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
                status, _ = f.tick()
                self.assertEqual(status, session.SESSION_TRANSITION)
                self.assertEqual(f.state(), (1, 2))

    def test_accepted_candidate_requests_the_target_scene_change(self):
        f = Fixture(self, self.lib, [self.row_action(target=2009, entry=3, word6=1)],
                    rig=t17.Rig17(selector=5))
        f.tick()
        self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.state(), (1, 2))               # completion byte, phase stays 2
        self.assertEqual(f.rig.transitions, [(2009, (3, 0, 1), (0, 0, 1))])
        self.assertEqual(f.slot()[5], 1)
        pending = session.SceneTransitionRequest()
        self.assertEqual(self.lib.scene_session_get_pending_transition(f.session, c.byref(pending)), 1)
        self.assertEqual((pending.target_scene, tuple(pending.opaque_words),
                          tuple(pending.opaque_dwords)), (2009, (3, 0, 1), (0, 0, 1)))

    def test_the_finishing_pass_clears_the_request_and_never_restores_it(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5))
        f.tick()
        self.assertEqual(f.row(), FRAME5)
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        f.tick()
        self.assertEqual(f.slot(), (0, 117, 15, 292, 108, 1))
        self.assertEqual(f.row(), None)

    def test_full_pointer_flow_hover_click_and_transition(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5), pointer_rows=True)
        f.tick()
        f.tick()
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, 0)
        self.assertEqual(f.rig_pointer.scanned, [(0, 117, 15, 292, 108)])
        f.rig_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.rig.transitions[0][0], 2008)
        self.assertEqual(f.state(), (1, 2))

    def test_click_outside_the_rectangle_does_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5), pointer_rows=True)
        f.rig_pointer.ctx.cursor = pointer.Rect(500, 300, 500, 300)
        f.tick()
        f.tick()
        f.rig_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual((f.state(), f.rig.transitions), ((0, 1), []))

    def test_the_rectangle_edges_are_inclusive(self):
        for x, y, hit in ((117, 15, True), (292, 108, True), (116, 15, False), (117, 14, False),
                          (293, 108, False), (292, 109, False)):
            with self.subTest(x=x, y=y):
                f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5),
                            pointer_rows=True)
                f.rig_pointer.ctx.cursor = pointer.Rect(x, y, x, y)
                f.tick()
                f.tick()
                result = pointer.PointerResult()
                self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
                self.assertEqual(result.candidate_after_scan, 0 if hit else -1)

    def test_a_record_for_another_frame_is_not_hot(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=8), pointer_rows=True)
        f.tick()
        f.tick()
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, -1)          # (250, 60) is in frame 5's rect

    def test_a_decoy_row_before_and_the_hotspot_row_after(self):
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()], rig=t17.Rig17(selector=5))
        f.tick()
        self.assertEqual((f.row(0), f.row(1)), (None, (1, 117, 15, 292, 108, 1)))
        self.assertEqual(f.state(1), (0, 1))

    def test_seven_rows_like_s2010_keep_separate_slots_and_the_first_hit_wins(self):
        rows = [self.row_action(target=2008 + i, records=[(5, 100 * i, 10, 100 * i + 90, 80)])
                for i in range(7)]
        f = Fixture(self, self.lib, rows, rig=t17.Rig17(selector=5), pointer_rows=True)
        f.rig_pointer.ctx.cursor = pointer.Rect(150, 20, 150, 20)
        f.tick()
        f.tick()
        self.assertEqual([f.row(i) for i in (0, 1, 2)],
                         [(0, 0, 10, 90, 80, 1), (1, 100, 10, 190, 80, 1), (2, 200, 10, 290, 80, 1)])
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, 1)           # row 1 holds (150, 20) first
        self.lib.scene_session_accept_action_candidate(f.session, 1)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.rig.transitions[0][0], 2009)
        self.assertEqual([f.state(i) for i in range(3)], [(0, 1), (1, 2), (0, 1)])

    def test_missing_transition_provider_blocks_at_phase_two_without_effects(self):
        f = Fixture(self, self.lib, [self.row_action()],
                    rig=t17.Rig17(selector=5, transition=False))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        f.rig.effects.clear()
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x0c))
        self.assertEqual(f.state(), (0, 2))
        self.assertEqual(f.slot()[5], 0)
        self.assertEqual(f.rig.effects, [(0, 'request', 0)])       # only the pre-gate clear ran
        self.assertIn(b'transition', self.lib.session_a0c_failure(f.binding))

    def test_transition_refusal_blocks_and_commits_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()],
                    rig=t17.Rig17(selector=5, transition_status=1))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))  # handler error
        self.assertEqual((f.state(), f.slot()[5]), ((0, 2), 0))
        self.assertIn(b'refused', self.lib.session_a0c_failure(f.binding))

    def test_missing_world_provider_blocks_before_any_effect(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5, load=False))
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_type), (session.SESSION_BLOCKED, 0x0c))
        self.assertEqual((f.state(), f.slot()), ((0, 0), (0, 0, 0, 0, 0, 0)))
        self.assertIn(b'world', self.lib.session_a0c_failure(f.binding))
        self.assertEqual(f.rig.start_flag, 0)

    def test_hover_cursor_is_read_from_the_rows_own_body(self):
        f = Fixture(self, self.lib, [self.row_action(cursor=0), self.row_action(cursor=8),
                                     self.row_action(cursor=11)])
        cursor = Cursor()
        for row, word in ((0, 0), (1, 8), (2, 11)):
            self.assertEqual(self.lib.session_a0c_hover_cursor(f.binding, row, -1, c.byref(cursor)), 0)
            self.assertEqual((cursor.cursor_index, cursor.table_offset), (word, word * 32 + 16))
        self.assertEqual(self.lib.session_a0c_hover_cursor(f.binding, 1, 5, c.byref(cursor)), 0)
        self.assertEqual((cursor.cursor_index, cursor.held_flag, cursor.surface),
                         (8, 1, SURFACE_DEFAULT))
        self.assertEqual(self.lib.session_a0c_hover_cursor(f.binding, 7, -1, c.byref(cursor)), ARGUMENT)

    def test_row_info_and_body_expose_the_copied_typed_body(self):
        f = Fixture(self, self.lib, [self.row_action(cursor=8, target=2009, entry=3, word6=1)])
        info = RowInfo()
        self.assertEqual(self.lib.session_a0c_row_info(f.binding, 0, c.byref(info)), 0)
        self.assertEqual(info.tuple(), (8, 2009, 3, 1, 5))
        length = c.c_size_t()
        pointer_ = self.lib.session_a0c_body(f.binding, 0, c.byref(length))
        self.assertEqual(length.value, 100)
        self.assertEqual(c.string_at(pointer_, 100), body(cursor=8, target=2009, entry=3, word6=1))
        self.assertEqual(self.lib.session_a0c_row_info(f.binding, 1, c.byref(info)), ARGUMENT)

    def test_dependency_records_are_not_part_of_the_typed_body(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3), session.flag_gate(4)))])
        length = c.c_size_t()
        self.assertTrue(self.lib.session_a0c_body(f.binding, 0, c.byref(length)))
        self.assertEqual(length.value, 100)

    def test_the_shared_parser_refuses_bodies_with_a_wrong_count(self):
        # The binding's own check is defence in depth: a scene whose typed 0x0c body does not hold
        # count records never reaches it, scene_resource refuses it.
        for count in (6, -1, 1820):
            with self.subTest(count=count):
                action = session.action(0x0c, 1, body(count=count))
                with self.assertRaises(AssertionError):
                    session.open_scene(self.lib, [action])

    def test_handler_checks_the_row_and_rejects_foreign_rows_and_bad_arguments(self):
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()])
        action = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for index in (0, 99):
            self.assertEqual(self.lib.session_a0c_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(self.lib.session_a0c_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_binding_selection_each_type_reaches_only_its_own_binding(self):
        # A raw 0x0b row and a raw 0x0c row in one scene, each registered to its own binding:
        # the 0x0b rectangle (frame word 0 against selector 0) and the 0x0c rectangle (frame 5)
        # must come from the right kernels, and each handler rejects the other's row.
        row_0b = session.action(0x0b, 1, t0b.body())
        f = Fixture(self, self.lib, [row_0b, self.row_action()], rig=t17.Rig17(selector=0),
                    with_0b=True)
        f.tick()
        self.assertEqual(f.state(0), (0, 1))
        self.assertEqual(f.state(1), (0, 1))
        self.assertEqual(f.slot(1), (0, 0, 0, 0, 0, 0))       # selector 0: no frame-0 record on 0x0c
        slot = t0b.Slot()
        self.assertEqual(self.lib.session_a0b_slot(f.binding_0b, 0, c.byref(slot)), 0)
        self.assertEqual((slot.request, slot.left, slot.right), (1, 1, 619))
        a0b_action, a0c_action = session.SceneActionInfo(), session.SceneActionInfo()
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(a0b_action)), 0)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 1, c.byref(a0c_action)), 0)
        before, out = session.RuntimeState(0, 0), session.HandlerResult(0, 0)
        self.assertEqual(self.lib.session_a0c_handler(f.binding, 0, c.byref(a0b_action),
                          c.byref(before), c.byref(out)), 2)
        self.assertEqual(self.lib.session_a0b_handler(f.binding_0b, 1, c.byref(a0c_action),
                          c.byref(before), c.byref(out)), 2)
        # An owned index with the other family's action info is refused too (the type is checked
        # against the scene row, not only the index), and nothing is written.
        effects_before = list(f.rig.effects)
        self.assertEqual(self.lib.session_a0c_handler(f.binding, 1, c.byref(a0b_action),
                          c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (0, 0))
        self.assertEqual(f.slot(1), (0, 0, 0, 0, 0, 0))
        self.assertEqual(f.rig.effects, effects_before)

    def test_scene_reload_replaces_rows(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=5))
        f.tick()
        other, owner = session.open_scene(self.lib, [self.row_action(records=[(9, 1, 2, 3, 4)])])
        self.assertEqual(self.lib.session_a0c_begin_scene(f.binding, other), 0)
        self.assertEqual(f.row(), None)          # slots are reset with the scene
        self.lib.scene_resource_close(other)
        empty, owner2 = session.open_scene(self.lib, [])
        self.assertEqual(self.lib.session_a0c_begin_scene(f.binding, empty), 0)
        self.assertEqual(self.lib.session_a0c_row_count(f.binding), 0)
        self.assertNotEqual(self.lib.session_a0c_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(empty)
        del owner, owner2


class StubSceneTests(unittest.TestCase):
    def test_a_failing_begin_scene_keeps_the_previous_rows(self):
        # begin_scene can only fail for a scene the shared parser never produces, so the
        # contract is checked against a stub scene resource (tests/session_bindings_a0c_stub_scene.c).
        src = PROJECT / 'src'
        output = PROJECT / 'build/session_bindings_a0c_stub_scene_plain'
        output.parent.mkdir(exist_ok=True)
        # Mutation checks substitute a mutated copy of either source.
        runtime = os.environ.get('A0C_STUB_RUNTIME_C', str(src / 'action_family_0c_runtime.c'))
        binding = os.environ.get('A0C_STUB_BINDING_C', str(src / 'session_bindings_a0c.c'))
        subprocess.run(['xcrun', 'clang', '-arch', 'arm64', '-std=c11', '-Wall', '-Wextra',
                        '-Wpedantic', '-Werror', '-O1', '-g', '-I', str(src), runtime, binding,
                        str(PROJECT / 'tests/session_bindings_a0c_stub_scene.c'), '-o', str(output)],
                       check=True, capture_output=True)
        result = subprocess.run([str(output)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('stub_scene_failing_begins=4 rows_kept=3', result.stdout)


if __name__ == '__main__':
    unittest.main()
