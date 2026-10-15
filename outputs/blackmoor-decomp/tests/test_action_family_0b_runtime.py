"""RT-16: raw 0x0b "scene change" hotspot runtime and session binding.

Written before the implementation. Runtime facts under test (original loader
arm 0x40b7d4, dispatcher arm 0x427ba4 (gate mode 1), handler 0x42ae73, pointer
cascade 0x4f0059 case 0x4f221e):

 * the loader builds a 0x28-byte payload from the 24-byte typed body: word 0
   (cursor word) -> +0, body+2 (target) -> +2, body+4 -> +4, body+6 -> +8, the
   four rectangle dwords body+8..+23 -> +0x18..+0x27, then +6 := 0, +0xa := 0,
   +0xe := 0, +0x12 := 1 and the frame word +0x16 := 0;
 * handler phase 0 stores 0x5bb1ca := 1, the low words of the four rectangle
   dwords into the row rectangle cells, phase := 1, then runs phase 1;
 * phase 1 stores request := 1 when the payload frame word (0) equals the
   selector 0x5bb50b, else request := 0 (a single store, no clear first);
 * phase 2 stores the completion byte directly, copies payload +2/+4/+6/+8/
   +0xa/+0xe/+0x12 into the scene-change cells and sets 0x583999 := 4;
 * any other phase value has no effect.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

import session_binding_support as session
import test_action_family_17_runtime as t17
import test_scene_session_pointer as pointer

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily0b_runtime.dylib'
OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST = range(5)
Slot, World, Host, Result, Cursor = t17.Slot, t17.World, t17.Host, t17.Result, t17.Cursor
SURFACE_NONE, SURFACE_DEFAULT, SURFACE_HELD = range(3)
S6403_ROW2 = bytes.fromhex('0900' '0419' '0400' '0100' '01000000' '45010000' '6b020000' '76010000')


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('A0B_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'A0B_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_0b_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class Payload(c.Structure):
    _fields_ = [('cursor', c.c_int16), ('target', c.c_int16), ('word_04', c.c_int16),
                ('word_06', c.c_int16), ('word_08', c.c_int16), ('dword_0a', c.c_int32),
                ('dword_0e', c.c_int32), ('dword_12', c.c_int32), ('frame', c.c_int16),
                ('rect', c.c_int32 * 4)]

    def tuple(self):
        return (self.cursor, self.target, self.word_04, self.word_06, self.word_08, self.dword_0a,
                self.dword_0e, self.dword_12, self.frame, tuple(self.rect))


def body(cursor=9, target=6404, frame=4, word6=1, rect=(1, 325, 619, 374)):
    """Typed 0x0b body: cursor word, target, frame word, word, four rectangle dwords."""
    return (t17.i16(cursor) + t17.i16(target) + t17.i16(frame) + t17.i16(word6) +
            b''.join(t17.i32(v) for v in rect))


def image(p):
    """The 0x28-byte payload object exactly as the loader leaves it."""
    return (t17.i16(p.cursor) + t17.i16(p.target) + t17.i16(p.word_04) + t17.i16(p.word_06) +
            t17.i16(p.word_08) + t17.i32(p.dword_0a) + t17.i32(p.dword_0e) + t17.i32(p.dword_12) +
            t17.i16(p.frame) + b''.join(t17.i32(v) for v in p.rect))


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.action0b_load.argtypes = [c.c_char_p, c.c_size_t, c.POINTER(Payload),
                                  c.POINTER(c.c_char_p)]
    lib.action0b_load.restype = c.c_int
    lib.action0b_step.argtypes = [c.POINTER(Payload), c.c_uint32, c.POINTER(Slot),
                                  c.POINTER(World), c.POINTER(Host), c.POINTER(Result)]
    lib.action0b_step.restype = c.c_int
    lib.action0b_hover_cursor.argtypes = [c.POINTER(Payload), c.c_int16, c.POINTER(Cursor)]
    lib.action0b_hover_cursor.restype = c.c_int
    return lib


def load(lib, data):
    payload, why = Payload(), c.c_char_p()
    status = lib.action0b_load(data, len(data), c.byref(payload), c.byref(why))
    return status, payload, why.value


class Case(t17.Case):
    """One kernel call with an ordered effect log (the RT-15 harness, 0x0b entry point)."""
    def __init__(self, lib, data, phase, selector=0, slot=None, world=None, host=True):
        super().__init__(lib, data, phase, selector, slot, world, host)
        status, self.payload, _ = load(lib, data)
        assert status == OK, status

    def run(self):
        result = Result()
        status = self.lib.action0b_step(c.byref(self.payload), self.phase, c.byref(self.slot),
                                        c.byref(self.world),
                                        c.byref(self.host) if self.with_host else None,
                                        c.byref(result))
        return status, result


class LoaderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_s6403_row2_payload_matches_the_loader_layout(self):
        status, p, _ = load(self.lib, S6403_ROW2)
        self.assertEqual(status, OK)
        self.assertEqual(p.tuple(), (9, 6404, 4, 0, 1, 0, 0, 1, 0, (1, 325, 619, 374)))
        self.assertEqual(len(image(p)), 0x28)

    def test_each_body_field_lands_where_the_loader_puts_it(self):
        data = body(cursor=-3, target=-7, frame=11, word6=-13, rect=(-1, 70000, -2 ** 31, 2 ** 31 - 1))
        status, p, _ = load(self.lib, data)
        self.assertEqual(status, OK)
        # word 6 of the body goes to +8, +6 is the loader's zero, +4 is body word 2.
        self.assertEqual(p.tuple(), (-3, -7, 11, 0, -13, 0, 0, 1, 0,
                                     (-1, 70000, -2 ** 31, 2 ** 31 - 1)))

    def test_loader_constants_do_not_depend_on_the_body(self):
        for filler in (b'\x00', b'\xff', b'\xa5'):
            status, p, _ = load(self.lib, filler * 24)
            self.assertEqual(status, OK)
            self.assertEqual((p.word_06, p.dword_0a, p.dword_0e, p.dword_12, p.frame),
                             (0, 0, 0, 1, 0))

    def test_rejections_have_a_reason_and_leave_the_payload_untouched(self):
        good = body()
        for name, data in (('empty', b''), ('short', good[:23]), ('long', good + b'\0'),
                           ('prefix only', good[:8])):
            with self.subTest(name=name):
                p, why = Payload(cursor=77), c.c_char_p()
                status = self.lib.action0b_load(data or b'\0', len(data), c.byref(p), c.byref(why))
                self.assertEqual(status, BOUNDS)
                self.assertTrue(why.value)
                self.assertEqual(p.cursor, 77)

    def test_null_arguments_are_rejected(self):
        good, p, why = body(), Payload(), c.c_char_p()
        self.assertEqual(self.lib.action0b_load(None, 24, c.byref(p), c.byref(why)), ARGUMENT)
        self.assertEqual(self.lib.action0b_load(good, 24, None, c.byref(why)), ARGUMENT)
        self.assertEqual(self.lib.action0b_load(good, 24, c.byref(p), None), OK)


class KernelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_phase_zero_registers_stores_the_rectangle_then_requests(self):
        case = Case(self.lib, S6403_ROW2, 0, selector=0)
        status, result = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log, [('start_flag', 1), ('left', 1), ('top', 325), ('right', 619),
                                    ('bottom', 374), ('phase', 1), ('request', 1)])
        self.assertEqual(case.state()[0], (1, 1, 325, 619, 374, 0))
        self.assertEqual(case.world.start_flag_5bb1ca, 1)
        self.assertEqual(case.world.mode_583999, 3)
        self.assertEqual((result.phase_after, result.matched_record, result.finished,
                          result.requested), (1, -1, 0, 1))

    def test_phase_one_is_a_single_request_store_and_leaves_the_rectangle(self):
        for selector, expect in ((0, 1), (1, 0), (4, 0), (-1, 0), (0x7fff, 0), (-32768, 0)):
            with self.subTest(selector=selector):
                case = Case(self.lib, S6403_ROW2, 1, selector=selector,
                            slot=Slot(request=5, left=11, top=12, right=13, bottom=14, done=0))
                status, result = case.run()
                self.assertEqual(status, OK)
                self.assertEqual(case.log, [('request', expect)])
                self.assertEqual(case.state()[0], (expect, 11, 12, 13, 14, 0))
                self.assertEqual(case.world.start_flag_5bb1ca, -5)
                self.assertEqual((result.phase_after, result.requested), (1, expect))

    def test_phase_zero_without_a_match_still_stores_a_cleared_request(self):
        case = Case(self.lib, S6403_ROW2, 0, selector=4)
        status, result = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log[-2:], [('phase', 1), ('request', 0)])
        self.assertEqual(case.state()[0], (0, 1, 325, 619, 374, 0))
        self.assertEqual(result.requested, 0)

    def test_rectangle_cells_are_the_low_words_of_the_payload_dwords(self):
        data = body(rect=(0x12345, -70000, 0x8000, 0xffff))
        case = Case(self.lib, data, 0, selector=0)
        status, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.state()[0][1:5], (t17.s16(0x12345), t17.s16(-70000), -32768, -1))

    def test_finish_phase_copies_the_payload_in_order_and_requests_the_scene_change(self):
        case = Case(self.lib, S6403_ROW2, 2, selector=0,
                    slot=Slot(request=1, left=1, top=2, right=3, bottom=4, done=0))
        status, result = case.run()
        self.assertEqual(status, OK)
        # +2 target (sign-extended dword), +4, +6 (loader zero), +8, +0xa, +0xe, +0x12 (loader one)
        self.assertEqual(case.log, [('done', 1), ('xfer_5bb57b', 6404), ('xfer_5bb599', 4),
                                    ('xfer_5bb595', 0), ('xfer_5c39ff', 1), ('xfer_5bb59b', 0),
                                    ('xfer_5bb59f', 0), ('xfer_5bb5a3', 1), ('mode', 4)])
        slot, world = case.state()
        self.assertEqual(slot, (1, 1, 2, 3, 4, 1))      # request and rectangle untouched
        self.assertEqual(world, (-5, 4, 6404, 4, 0, 1, 0, 0, 1))
        self.assertEqual((result.phase_after, result.finished), (2, 1))

    def test_finish_target_is_sign_extended_and_the_cursor_word_is_not_copied(self):
        case = Case(self.lib, body(cursor=17, target=-1234, frame=-5, word6=-6), 2)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual((case.world.xfer_5bb57b, case.world.xfer_5bb599, case.world.xfer_5c39ff),
                         (-1234, -5, -6))
        self.assertNotIn(17, [v for _, v in case.log])

    def test_other_phases_do_nothing(self):
        for phase in (3, 4, 7, 0xffffffff):
            with self.subTest(phase=phase):
                case = Case(self.lib, S6403_ROW2, phase, selector=0)
                before = case.state()
                status, result = case.run()
                self.assertEqual(status, OK)
                self.assertEqual(case.log, [])
                self.assertEqual(case.state(), before)
                self.assertEqual((result.phase_after, result.finished, result.requested),
                                 (phase, 0, 0))

    def test_finish_maps_each_payload_field_to_its_own_scene_change_cell(self):
        # A payload with distinct values (the loader only produces zero, zero, one for the dwords).
        case = Case(self.lib, S6403_ROW2, 2)
        case.payload = Payload(cursor=1, target=2, word_04=3, word_06=4, word_08=5, dword_0a=6,
                               dword_0e=7, dword_12=8, frame=9, rect=(10, 11, 12, 13))
        status, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual([v for n, v in case.log if n.startswith('xfer')], [2, 3, 4, 5, 6, 7, 8])
        self.assertEqual(case.state()[1], (-5, 4, 2, 3, 4, 5, 6, 7, 8))

    def test_phase_one_compares_the_payload_frame_word_with_the_selector(self):
        case = Case(self.lib, S6403_ROW2, 1, selector=-9)
        case.payload = Payload(frame=-9)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual(case.log, [('request', 1)])

    def test_null_arguments_are_rejected_and_the_observer_is_optional(self):
        p, slot, world, result = Payload(), Slot(), World(), Result()
        for args in ((None, c.byref(slot), c.byref(world), c.byref(result)),
                     (c.byref(p), None, c.byref(world), c.byref(result)),
                     (c.byref(p), c.byref(slot), None, c.byref(result)),
                     (c.byref(p), c.byref(slot), c.byref(world), None)):
            self.assertEqual(self.lib.action0b_step(args[0], 0, args[1], args[2], None, args[3]),
                             ARGUMENT)
        case = Case(self.lib, S6403_ROW2, 0, selector=0, host=False)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual(case.log, [])
        self.assertEqual(case.state()[0], (1, 1, 325, 619, 374, 0))


class CursorTests(unittest.TestCase):
    """Cascade case 0x4f221e (type 0x0b): payload word 0 is the cursor index."""
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def hover(self, cursor_word, held):
        status, p, _ = load(self.lib, body(cursor=cursor_word))
        self.assertEqual(status, OK)
        out = Cursor(-99, -99, -99, -99, -99)
        return self.lib.action0b_hover_cursor(c.byref(p), held, c.byref(out)), out

    def test_without_a_held_item_every_cursor_word_is_the_index(self):
        for word in (0, 1, 3, 4, 9, 0x1a, 0x1b, 0x7fff, -1, -32768):
            with self.subTest(word=word):
                status, out = self.hover(word, -1)
                self.assertEqual(status, OK)
                self.assertEqual((out.cursor_index, out.variant, out.table_offset, out.held_flag,
                                  out.surface), (word, 1, word * 32 + 16, 0, SURFACE_NONE))

    def test_a_held_item_keeps_words_four_to_0x1a_and_sets_the_flag(self):
        for word in (4, 5, 9, 0x1a):
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

    def test_null_arguments_are_rejected(self):
        status, p, _ = load(self.lib, body())
        out = Cursor(7, 7, 7, 7, 7)
        self.assertEqual(self.lib.action0b_hover_cursor(None, -1, c.byref(out)), ARGUMENT)
        self.assertEqual(self.lib.action0b_hover_cursor(c.byref(p), -1, None), ARGUMENT)
        self.assertEqual((out.cursor_index, out.surface), (7, 7))


# ---------------------------------------------------------------- binding

def configure(lib):
    # The session / pointer entry points shared with the RT-15 tests (the library links the
    # RT-15 binding as well, for the oracle's mixed scenes).
    t17.configure(lib)
    lib.session_a0b_create.argtypes = [c.POINTER(t17.BindHost)]
    lib.session_a0b_create.restype = c.c_void_p
    lib.session_a0b_destroy.argtypes = [c.c_void_p]
    lib.session_a0b_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
    lib.session_a0b_begin_scene.restype = c.c_int
    lib.session_a0b_handler.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo),
                                        c.POINTER(session.RuntimeState),
                                        c.POINTER(session.HandlerResult)]
    lib.session_a0b_handler.restype = c.c_int
    lib.session_a0b_pre_gate.argtypes = [c.c_void_p, c.c_size_t, c.c_void_p, c.c_void_p]
    lib.session_a0b_pre_gate.restype = None
    lib.session_a0b_pointer_row.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(pointer.InputHotspot)]
    lib.session_a0b_pointer_row.restype = c.c_int
    lib.session_a0b_hover_cursor.argtypes = [c.c_void_p, c.c_size_t, c.c_int16, c.POINTER(Cursor)]
    lib.session_a0b_hover_cursor.restype = c.c_int
    lib.session_a0b_slot.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Slot)]
    lib.session_a0b_slot.restype = c.c_int
    lib.session_a0b_failure.argtypes = [c.c_void_p]
    lib.session_a0b_failure.restype = c.c_char_p
    lib.session_a0b_payload.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Payload)]
    lib.session_a0b_payload.restype = c.c_int
    lib.session_a0b_row_count.argtypes = [c.c_void_p]
    lib.session_a0b_row_count.restype = c.c_size_t


class Fixture:
    def __init__(self, test, lib, actions, rig=None, with_pre_gate=True, pointer_rows=False):
        self.lib = lib
        self.test = test
        self.rig = rig or t17.Rig17(selector=0)
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world()
        self.binding = lib.session_a0b_create(c.byref(self.rig.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a0b_begin_scene(self.binding, self.scene), 0)
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a0b_handler', lib))
        self.bindings = (session.Binding * 1)(session.Binding(0x0b, 11, handler, self.binding))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6403,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        if with_pre_gate:
            test.assertEqual(lib.scene_session_set_pre_gate(
                self.session, 0x0b, c.cast(lib.session_a0b_pre_gate, c.c_void_p), self.binding), 0)
        self.keep = [prepare, media, handler]
        self.rig0b_pointer = None
        if pointer_rows:
            self.rig0b_pointer = pointer.Rig(lib)

            @pointer.ExternalFn
            def external(_ctx, index, row):
                return lib.session_a0b_pointer_row(self.binding, index, row)

            self.keep.append(external)
            self.rig0b_pointer.host.external_row = external
            self.rig0b_pointer.bind(self.session)
            self.rig0b_pointer.ctx.cursor = pointer.Rect(300, 340, 300, 340)
        self.rig.lib, self.rig.session = lib, self.session
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a0b_destroy(self.binding)
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
        self.test.assertEqual(self.lib.session_a0b_slot(self.binding, index, c.byref(out)), 0)
        return out.request, out.left, out.top, out.right, out.bottom, out.done

    def row(self, index=0):
        out = pointer.InputHotspot()
        if not self.lib.session_a0b_pointer_row(self.binding, index, c.byref(out)):
            return None
        r = out.rectangle
        return out.index, r.left, r.top, r.right, r.bottom, out.active


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        configure(cls.lib)

    def row_action(self, deps=(), subtype=1, **kw):
        return session.action(0x0b, subtype, body(**kw), deps)

    def test_first_tick_registers_and_exports_the_rectangle_for_selector_zero(self):
        f = Fixture(self, self.lib, [self.row_action()])
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(f.rig.start_flag, 1)
        self.assertEqual(f.slot(), (1, 1, 325, 619, 374, 0))
        self.assertEqual(f.row(), (0, 1, 325, 619, 374, 1))
        self.assertEqual(f.row(1), None)
        self.assertEqual(f.rig.transitions, [])
        self.assertEqual([e for e in f.rig.effects if e[0] == 0][:2],
                         [(0, 'request', 0), (0, 'start_flag', 1)])

    def test_a_nonzero_selector_keeps_the_row_out_of_the_pointer_scan(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=4))
        f.tick()
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(f.row(), None)
        self.assertEqual(f.slot(), (0, 1, 325, 619, 374, 0))   # the rectangle is stored anyway
        f.rig.selector = 0
        f.tick()
        self.assertEqual(f.row(), (0, 1, 325, 619, 374, 1))
        f.rig.selector = -1
        f.tick()
        self.assertEqual(f.row(), None)

    def test_pre_gate_clears_the_request_before_a_false_gate(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))])
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), (0, 1, 325, 619, 374, 1))
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.row(), None)         # cleared although the handler did not run
        self.assertEqual(f.state(), (0, 1))
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), (0, 1, 325, 619, 374, 1))

    def test_false_gate_from_the_start_exports_nothing_and_does_not_start(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))])
        f.tick()
        self.assertEqual((f.state(), f.row(), f.rig.start_flag), ((0, 0), None, 0))

    def test_finish_completes_directly_whatever_the_subtype(self):
        for subtype in (0, 1, 2, 3, 255):
            with self.subTest(subtype=subtype):
                f = Fixture(self, self.lib, [self.row_action(subtype=subtype)])
                f.tick()
                self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
                status, _ = f.tick()
                self.assertEqual(status, session.SESSION_TRANSITION)
                self.assertEqual(f.state(), (1, 2))

    def test_accepted_candidate_requests_the_s6404_scene_change(self):
        f = Fixture(self, self.lib, [self.row_action()])
        f.tick()
        self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.state(), (1, 2))               # completion byte, phase stays 2
        self.assertEqual(f.rig.transitions, [(6404, (4, 0, 1), (0, 0, 1))])
        self.assertEqual(f.slot()[5], 1)
        pending = session.SceneTransitionRequest()
        self.assertEqual(self.lib.scene_session_get_pending_transition(f.session, c.byref(pending)), 1)
        self.assertEqual((pending.target_scene, tuple(pending.opaque_words),
                          tuple(pending.opaque_dwords)), (6404, (4, 0, 1), (0, 0, 1)))

    def test_the_finishing_pass_clears_the_request_and_never_restores_it(self):
        f = Fixture(self, self.lib, [self.row_action()])
        f.tick()
        self.assertEqual(f.row(), (0, 1, 325, 619, 374, 1))
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        f.tick()
        self.assertEqual(f.slot(), (0, 1, 325, 619, 374, 1))
        self.assertEqual(f.row(), None)

    def test_full_pointer_flow_hover_click_and_transition(self):
        f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
        f.tick()
        f.tick()
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, 0)
        self.assertEqual(f.rig0b_pointer.scanned, [(0, 1, 325, 619, 374)])
        f.rig0b_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.rig.transitions[0][0], 6404)
        self.assertEqual(f.state(), (1, 2))

    def test_click_outside_the_rectangle_does_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
        f.rig0b_pointer.ctx.cursor = pointer.Rect(300, 100, 300, 100)
        f.tick()
        f.tick()
        f.rig0b_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual((f.state(), f.rig.transitions), ((0, 1), []))

    def test_the_rectangle_edges_are_inclusive(self):
        for x, y, hit in ((1, 325, True), (619, 374, True), (0, 325, False), (1, 324, False),
                          (620, 374, False), (619, 375, False)):
            with self.subTest(x=x, y=y):
                f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
                f.rig0b_pointer.ctx.cursor = pointer.Rect(x, y, x, y)
                f.tick()
                f.tick()
                result = pointer.PointerResult()
                self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
                self.assertEqual(result.candidate_after_scan, 0 if hit else -1)

    def test_a_decoy_row_before_and_the_hotspot_row_after(self):
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()])
        f.tick()
        self.assertEqual((f.row(0), f.row(1)), (None, (1, 1, 325, 619, 374, 1)))
        self.assertEqual(f.state(1), (0, 1))

    def test_two_rows_keep_separate_slots_and_the_first_hit_wins(self):
        f = Fixture(self, self.lib, [self.row_action(rect=(0, 0, 100, 100), target=6500),
                                     self.row_action(rect=(50, 50, 200, 200), target=6501)],
                    pointer_rows=True)
        f.rig0b_pointer.ctx.cursor = pointer.Rect(60, 60, 60, 60)
        f.tick()
        f.tick()
        self.assertEqual((f.row(0), f.row(1)), ((0, 0, 0, 100, 100, 1), (1, 50, 50, 200, 200, 1)))
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, 0)

    def test_missing_transition_provider_blocks_at_phase_two_without_effects(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=0, transition=False))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x0b))
        self.assertEqual(f.state(), (0, 2))
        self.assertEqual(f.slot()[5], 0)
        self.assertIn(b'transition', self.lib.session_a0b_failure(f.binding))

    def test_transition_refusal_blocks_and_commits_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()],
                    rig=t17.Rig17(selector=0, transition_status=1))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))  # handler error
        self.assertEqual((f.state(), f.slot()[5]), ((0, 2), 0))
        self.assertIn(b'refused', self.lib.session_a0b_failure(f.binding))

    def test_missing_world_provider_blocks_before_any_effect(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=t17.Rig17(selector=0, load=False))
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_type), (session.SESSION_BLOCKED, 0x0b))
        self.assertEqual((f.state(), f.slot()), ((0, 0), (0, 0, 0, 0, 0, 0)))
        self.assertIn(b'world', self.lib.session_a0b_failure(f.binding))

    def test_hover_cursor_is_the_body_word(self):
        f = Fixture(self, self.lib, [self.row_action(cursor=9)])
        cursor = Cursor()
        self.assertEqual(self.lib.session_a0b_hover_cursor(f.binding, 0, -1, c.byref(cursor)), 0)
        self.assertEqual((cursor.cursor_index, cursor.table_offset), (9, 9 * 32 + 16))
        self.assertEqual(self.lib.session_a0b_hover_cursor(f.binding, 0, 5, c.byref(cursor)), 0)
        self.assertEqual((cursor.cursor_index, cursor.held_flag, cursor.surface),
                         (9, 1, SURFACE_DEFAULT))
        self.assertEqual(self.lib.session_a0b_hover_cursor(f.binding, 7, -1, c.byref(cursor)),
                         ARGUMENT)

    def test_the_shared_parser_already_refuses_wrong_sized_bodies(self):
        # The binding's own 24-byte check (kernel loader) is defense in depth: a scene whose
        # typed 0x0b body is not 24 bytes never reaches it because scene_resource refuses it.
        for length in (0, 23, 25):
            with self.subTest(length=length):
                action = session.action(0x0b, 1, (body() + bytes(8))[:length])
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
            self.assertEqual(self.lib.session_a0b_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(self.lib.session_a0b_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_hover_cursor_is_read_from_the_rows_own_payload(self):
        f = Fixture(self, self.lib, [self.row_action(cursor=9), self.row_action(cursor=5),
                                     self.row_action(cursor=0x1a)])
        cursor = Cursor()
        for row, word in ((0, 9), (1, 5), (2, 0x1a)):
            self.assertEqual(self.lib.session_a0b_hover_cursor(f.binding, row, -1, c.byref(cursor)), 0)
            self.assertEqual(cursor.cursor_index, word)
        payload = Payload()
        self.assertEqual(self.lib.session_a0b_payload(f.binding, 1, c.byref(payload)), 0)
        self.assertEqual(payload.tuple()[:3], (5, 6404, 4))

    def test_scene_reload_replaces_rows(self):
        f = Fixture(self, self.lib, [self.row_action()])
        f.tick()
        other, owner = session.open_scene(self.lib, [self.row_action(rect=(9, 8, 7, 6))])
        self.assertEqual(self.lib.session_a0b_begin_scene(f.binding, other), 0)
        self.assertEqual(f.row(), None)          # slots are reset with the scene
        self.lib.scene_resource_close(other)
        empty, owner2 = session.open_scene(self.lib, [])
        self.assertEqual(self.lib.session_a0b_begin_scene(f.binding, empty), 0)
        self.assertEqual(self.lib.session_a0b_row_count(f.binding), 0)
        self.assertNotEqual(self.lib.session_a0b_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(empty)
        del owner, owner2


class StubSceneTests(unittest.TestCase):
    def test_a_failing_begin_scene_keeps_the_previous_rows(self):
        # begin_scene can only fail for a scene the shared parser never produces, so the
        # contract is checked against a stub scene resource (tests/session_bindings_a0b_stub_scene.c).
        src = PROJECT / 'src'
        output = PROJECT / 'build/session_bindings_a0b_stub_scene_plain'
        output.parent.mkdir(exist_ok=True)
        subprocess.run(['xcrun', 'clang', '-arch', 'arm64', '-std=c11', '-Wall', '-Wextra',
                        '-Wpedantic', '-Werror', '-O1', '-g', '-I', str(src),
                        str(src / 'action_family_0b_runtime.c'), str(src / 'action_family_17_runtime.c'),
                        str(src / 'session_bindings_a0b.c'),
                        str(PROJECT / 'tests/session_bindings_a0b_stub_scene.c'), '-o', str(output)],
                       check=True, capture_output=True)
        result = subprocess.run([str(output)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('stub_scene_failing_begins=3 rows_kept=3', result.stdout)


if __name__ == '__main__':
    unittest.main()
