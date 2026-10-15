"""RT-15: raw 0x17 "multiframe scene hotspot" runtime and session binding.

Written before the implementation. Runtime facts under test (original
dispatcher arms 0x427bdd (0x16, gate mode 1) and 0x427c15 (0x17..0x19, mode 0),
handler 0x42b07e, pointer cascade 0x4f0059 case 0x4f1ff3, cursor map 0x40b2d0):

 * phase 0 stores 0x5bb1ca := 1 and the row phase := 1, then falls into
   phase 1 in the same call;
 * phase 1 first clears the row request dword (0x5bb626), then scans the
   18-byte records at body+22 (count = signed word at body+0x14) for the FIRST
   whose word 0 equals the selector 0x5bb50b (both sign-extended words); a hit
   stores request := 1 and the low words of record dwords +2/+6/+10/+14 into
   the row rectangle words left/top/right/bottom (0x5bb62a/2c/2e/30);
 * phase 2 stores the completion byte directly (no 0x42ba3a, no dependency
   reset, phase stays 2), copies the 20-byte prefix into the scene-change cells
   exactly like the 0x0a arm and sets the engine mode 0x583999 := 4;
 * any other phase value has no effect.
"""
import ctypes as c
import os
from pathlib import Path
import subprocess
import unittest

import session_binding_support as session
import test_scene_session_pointer as pointer

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily17_runtime.dylib'
OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST = range(5)

(START_FLAG, PHASE, REQUEST, LEFT, TOP, RIGHT, BOTTOM, DONE, XFER_5BB57B, XFER_5BB599,
 XFER_5BB595, XFER_5C39FF, XFER_5BB59B, XFER_5BB59F, XFER_5BB5A3, MODE) = range(1, 17)
EFFECT_NAMES = {START_FLAG: 'start_flag', PHASE: 'phase', REQUEST: 'request', LEFT: 'left',
                TOP: 'top', RIGHT: 'right', BOTTOM: 'bottom', DONE: 'done',
                XFER_5BB57B: 'xfer_5bb57b', XFER_5BB599: 'xfer_5bb599',
                XFER_5BB595: 'xfer_5bb595', XFER_5C39FF: 'xfer_5c39ff',
                XFER_5BB59B: 'xfer_5bb59b', XFER_5BB59F: 'xfer_5bb59f',
                XFER_5BB5A3: 'xfer_5bb5a3', MODE: 'mode'}
SURFACE_NONE, SURFACE_DEFAULT, SURFACE_HELD = range(3)


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('A17_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'A17_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_17_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


class Slot(c.Structure):
    _fields_ = [('request', c.c_int32), ('left', c.c_int16), ('top', c.c_int16),
                ('right', c.c_int16), ('bottom', c.c_int16), ('done', c.c_uint8)]


class World(c.Structure):
    _fields_ = [('selector', c.c_int16), ('xfer_5bb599', c.c_int16),
                ('xfer_5bb595', c.c_int16), ('xfer_5c39ff', c.c_int16),
                ('start_flag_5bb1ca', c.c_int32), ('mode_583999', c.c_int32),
                ('xfer_5bb57b', c.c_int32), ('xfer_5bb59b', c.c_int32),
                ('xfer_5bb59f', c.c_int32), ('xfer_5bb5a3', c.c_int32)]


ObserveFn = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.c_int32)


class Host(c.Structure):
    _fields_ = [('context', c.c_void_p), ('observe', ObserveFn)]


class Result(c.Structure):
    _fields_ = [('phase_after', c.c_uint32), ('matched_record', c.c_int32),
                ('finished', c.c_uint8), ('requested', c.c_uint8)]


class Cursor(c.Structure):
    _fields_ = [('cursor_index', c.c_int32), ('variant', c.c_int32),
                ('table_offset', c.c_int32), ('held_flag', c.c_int32), ('surface', c.c_int32)]


def i16(value):
    return int(value).to_bytes(2, 'little', signed=True)


def i32(value):
    return int(value).to_bytes(4, 'little', signed=True)


def s16(value):
    value &= 0xffff
    return value - 0x10000 if value >= 0x8000 else value


def body(target=6402, words=(0, 0, 1), dwords=(0, 0, 1), records=(), count=None, extra=b''):
    """Typed body: ten words (the 20-byte scene-change prefix), count, records.
    A record is (frame, left, top, right, bottom): a word then four dwords."""
    prefix = i16(target) + b''.join(i16(w) for w in words) + b''.join(i32(d) for d in dwords)
    assert len(prefix) == 20
    out = prefix + i16(len(records) if count is None else count)
    for frame, left, top, right, bottom in records:
        out += i16(frame) + b''.join(i32(v) for v in (left, top, right, bottom))
    return out + extra


GALLERY = [(2, 4, 74, 110, 310), (3, 113, 106, 258, 312), (4, 243, 86, 398, 321),
           (5, 363, 98, 501, 318), (6, 493, 86, 619, 314)]  # S6401 row 6 shape


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.action17_step.argtypes = [c.c_char_p, c.c_size_t, c.c_uint32, c.POINTER(Slot),
                                  c.POINTER(World), c.POINTER(Host), c.POINTER(Result),
                                  c.POINTER(c.c_char_p)]
    lib.action17_step.restype = c.c_int
    lib.action17_hover_cursor.argtypes = [c.c_uint8, c.c_int16, c.POINTER(Cursor)]
    lib.action17_hover_cursor.restype = c.c_int
    lib.action17_cursor_index_for_type.argtypes = [c.c_uint8]
    lib.action17_cursor_index_for_type.restype = c.c_uint8
    return lib


class Case:
    """One kernel call with an ordered effect log."""
    def __init__(self, lib, data, phase, selector=0, slot=None, world=None, host=True):
        self.lib = lib
        self.data = data
        self.phase = phase
        self.slot = slot or Slot(request=-1, left=-7, top=-8, right=-9, bottom=-10, done=0)
        self.world = world or World(selector=selector, start_flag_5bb1ca=-5, mode_583999=3,
                                    xfer_5bb57b=-11, xfer_5bb599=-12, xfer_5bb595=-13,
                                    xfer_5c39ff=-14, xfer_5bb59b=-15, xfer_5bb59f=-16,
                                    xfer_5bb5a3=-17)
        self.log = []

        @ObserveFn
        def observe(_ctx, effect, value):
            self.log.append((EFFECT_NAMES[effect], value))

        self.observe = observe
        self.host = Host(None, observe)
        self.with_host = host

    def run(self, data=None, length=None):
        result, why = Result(), c.c_char_p()
        raw = self.data if data is None else data
        status = self.lib.action17_step(raw, len(raw) if length is None else length, self.phase,
                                        c.byref(self.slot), c.byref(self.world),
                                        c.byref(self.host) if self.with_host else None,
                                        c.byref(result), c.byref(why))
        return status, result, why.value

    def state(self):
        s, w = self.slot, self.world
        return ((s.request, s.left, s.top, s.right, s.bottom, s.done),
                (w.start_flag_5bb1ca, w.mode_583999, w.xfer_5bb57b, w.xfer_5bb599,
                 w.xfer_5bb595, w.xfer_5c39ff, w.xfer_5bb59b, w.xfer_5bb59f, w.xfer_5bb5a3))


class KernelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_phase_zero_starts_then_scans_in_the_same_call(self):
        case = Case(self.lib, body(records=GALLERY), 0, selector=4)
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log, [('start_flag', 1), ('phase', 1), ('request', 0),
                                    ('request', 1), ('left', 243), ('top', 86), ('right', 398),
                                    ('bottom', 321)])
        self.assertEqual(case.state()[0], (1, 243, 86, 398, 321, 0))
        self.assertEqual(case.world.start_flag_5bb1ca, 1)
        self.assertEqual(case.world.mode_583999, 3)
        self.assertEqual((result.phase_after, result.matched_record, result.finished,
                          result.requested), (1, 2, 0, 1))

    def test_phase_one_clears_the_request_first_and_has_no_start_or_phase_store(self):
        case = Case(self.lib, body(records=GALLERY), 1, selector=6,
                    slot=Slot(request=1, left=1, top=2, right=3, bottom=4, done=0))
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual([name for name, _ in case.log],
                         ['request', 'request', 'left', 'top', 'right', 'bottom'])
        self.assertEqual(case.log[:2], [('request', 0), ('request', 1)])
        self.assertEqual(case.state()[0], (1, 493, 86, 619, 314, 0))
        self.assertEqual(case.world.start_flag_5bb1ca, -5)
        self.assertEqual((result.phase_after, result.matched_record), (1, 4))

    def test_no_matching_frame_leaves_a_cleared_request_and_the_stale_rectangle(self):
        for selector in (0, 1, 7, -1, 1002):
            with self.subTest(selector=selector):
                case = Case(self.lib, body(records=GALLERY), 1, selector=selector,
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
        records = [(-2, 1, 2, 3, 4), (0x7fff, 5, 6, 7, 8), (-32768, 9, 10, 11, 12)]
        for selector, expect in ((-2, 0), (0x7fff, 1), (-32768, 2), (2, -1), (-3, -1)):
            with self.subTest(selector=selector):
                case = Case(self.lib, body(records=records), 1, selector=selector)
                status, result, _ = case.run()
                self.assertEqual((status, result.matched_record), (OK, expect))

    def test_rectangle_cells_are_the_low_words_of_the_record_dwords(self):
        # mov dx, word [rec+2/6/10/14]: only the low word of each dword is
        # stored; the pointer cascade later reads it with movsx.
        record = (9, 0x12345, -70000, 0x8000, 0xffff)
        case = Case(self.lib, body(records=[record]), 1, selector=9)
        status, _, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.state()[0][1:5], (s16(0x12345), s16(-70000), -32768, -1))

    def test_finish_phase_copies_the_prefix_in_order_and_requests_the_scene_change(self):
        data = body(target=6402, words=(-3, 4, 5), dwords=(70000, -2, 1), records=GALLERY)
        case = Case(self.lib, data, 2, selector=4,
                    slot=Slot(request=1, left=1, top=2, right=3, bottom=4, done=0))
        status, result, _ = case.run()
        self.assertEqual(status, OK)
        self.assertEqual(case.log, [('done', 1), ('xfer_5bb57b', 6402), ('xfer_5bb599', -3),
                                    ('xfer_5bb595', 4), ('xfer_5c39ff', 5),
                                    ('xfer_5bb59b', 70000), ('xfer_5bb59f', -2),
                                    ('xfer_5bb5a3', 1), ('mode', 4)])
        slot, world = case.state()
        self.assertEqual(slot, (1, 1, 2, 3, 4, 1))      # request and rectangle untouched
        self.assertEqual(world, (-5, 4, 6402, -3, 4, 5, 70000, -2, 1))
        self.assertEqual((result.phase_after, result.finished), (2, 1))

    def test_finish_target_is_sign_extended_into_the_dword_cell(self):
        case = Case(self.lib, body(target=-1234, records=GALLERY), 2)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual(case.world.xfer_5bb57b, -1234)

    def test_other_phases_do_nothing(self):
        for phase in (3, 4, 7, 0xffffffff):
            with self.subTest(phase=phase):
                case = Case(self.lib, body(records=GALLERY), phase, selector=4)
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

    def test_rejections_change_nothing_and_have_a_reason(self):
        good = body(records=GALLERY)
        cases = {
            'short prefix': (good[:21], BOUNDS),
            'empty': (b'', BOUNDS),
            'count negative': (body(records=[], count=-1), BOUNDS),
            'count past the maximum': (body(records=[], count=1820), BOUNDS),
            'count past the data': (body(records=GALLERY[:2], count=3), BOUNDS),
            'ragged record': (good[:-1], BOUNDS),
            'trailing bytes': (good + b'\0', BOUNDS),
        }
        for name, (data, expect) in cases.items():
            for phase in (0, 1, 2):
                with self.subTest(name=name, phase=phase):
                    case = Case(self.lib, data, phase, selector=4)
                    before = case.state()
                    status, _, why = case.run(data=data if data else b'\0', length=len(data))
                    self.assertEqual(status, expect)
                    self.assertTrue(why)
                    self.assertEqual(case.log, [])
                    self.assertEqual(case.state(), before)

    def test_null_arguments_are_rejected(self):
        good = body(records=GALLERY)
        slot = Slot(); world = World(); result = Result(); why = c.c_char_p()
        for args in ((None, 22), (good, 0)):
            self.assertNotEqual(self.lib.action17_step(args[0], args[1], 0, c.byref(slot),
                                c.byref(world), None, c.byref(result), c.byref(why)), OK)
        for slot_ptr, world_ptr, result_ptr in ((None, c.byref(world), c.byref(result)),
                                                (c.byref(slot), None, c.byref(result)),
                                                (c.byref(slot), c.byref(world), None)):
            self.assertEqual(self.lib.action17_step(good, len(good), 0, slot_ptr, world_ptr, None,
                                                    result_ptr, c.byref(why)), ARGUMENT)

    def test_observer_is_optional(self):
        case = Case(self.lib, body(records=GALLERY), 0, selector=4, host=False)
        self.assertEqual(case.run()[0], OK)
        self.assertEqual(case.log, [])
        self.assertEqual(case.state()[0], (1, 243, 86, 398, 321, 0))


# 0x40b2d0 (index = type - 0x0e, 12 entries, others 0)
CURSOR_BY_TYPE = {0x0e: 5, 0x0f: 8, 0x10: 9, 0x11: 10, 0x12: 11, 0x13: 6, 0x14: 7, 0x15: 0,
                  0x16: 0, 0x17: 8, 0x18: 10, 0x19: 11}


class CursorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def hover(self, runtime_type, held):
        out = Cursor(-99, -99, -99, -99, -99)
        status = self.lib.action17_hover_cursor(runtime_type, held, c.byref(out))
        return status, out

    def test_cursor_index_map_covers_every_byte(self):
        for value in range(256):
            self.assertEqual(self.lib.action17_cursor_index_for_type(value),
                             CURSOR_BY_TYPE.get(value, 0), hex(value))

    def test_types_17_to_19_use_the_map_and_keep_it_with_a_held_item(self):
        for runtime_type, index in ((0x17, 8), (0x18, 10), (0x19, 11)):
            status, free = self.hover(runtime_type, -1)
            self.assertEqual(status, OK)
            self.assertEqual((free.cursor_index, free.variant, free.table_offset, free.held_flag,
                              free.surface), (index, 1, index * 32 + 16, 0, SURFACE_NONE))
            status, held = self.hover(runtime_type, 5)
            self.assertEqual((held.cursor_index, held.variant, held.table_offset, held.held_flag,
                              held.surface), (index, 1, index * 32 + 16, 1, SURFACE_DEFAULT))

    def test_type_16_takes_the_default_path(self):
        status, free = self.hover(0x16, -1)
        self.assertEqual((status, free.cursor_index, free.surface, free.held_flag),
                         (OK, 0, SURFACE_NONE, 0))
        status, held = self.hover(0x16, 5)
        self.assertEqual((held.cursor_index, held.table_offset, held.surface),
                         (5 + 0x25, (5 + 0x25) * 32 + 16, SURFACE_HELD))
        _, negative = self.hover(0x16, -2)   # any held word other than -1 counts as held
        self.assertEqual((negative.cursor_index, negative.surface), (-2 + 0x25, SURFACE_HELD))

    def test_other_runtime_types_are_not_this_family(self):
        for runtime_type in (0x00, 0x0a, 0x0d, 0x15, 0x1a, 0x36, 0x62, 0x6a, 0xff):
            out = Cursor(7, 7, 7, 7, 7)
            self.assertEqual(self.lib.action17_hover_cursor(runtime_type, -1, c.byref(out)),
                             ARGUMENT)
            self.assertEqual((out.cursor_index, out.surface), (7, 7))
        self.assertEqual(self.lib.action17_hover_cursor(0x17, -1, None), ARGUMENT)


# ---------------------------------------------------------------- binding

LoadFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(World))
StoreFn = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(World))
TransitionFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(session.SceneTransitionRequest))


class BindHost(c.Structure):
    _fields_ = [('context', c.c_void_p), ('load_world', LoadFn), ('store_world', StoreFn),
                ('transition', TransitionFn), ('observe', ObserveFn)]


class Hotspot(c.Structure):
    _fields_ = [('index', c.c_int32), ('left', c.c_int32), ('top', c.c_int32),
                ('right', c.c_int32), ('bottom', c.c_int32), ('active', c.c_uint32)]


class Rig17:
    """Host side of the binding: selector and start flag, transition capture."""
    def __init__(self, selector=4, load=True, store=True, transition=True, transition_status=0):
        self.selector = selector
        self.start_flag = 0
        self.loads = 0
        self.stores = []
        self.transitions = []
        self.effects = []
        self.lib = None
        self.session = None       # set by the fixture; the app's callback requests the transition
        rig = self

        @LoadFn
        def load_world(_ctx, world):
            rig.loads += 1
            world.contents.selector = rig.selector
            world.contents.start_flag_5bb1ca = rig.start_flag
            world.contents.mode_583999 = 3
            return 0

        @StoreFn
        def store_world(_ctx, world):
            rig.start_flag = world.contents.start_flag_5bb1ca
            rig.stores.append((world.contents.start_flag_5bb1ca, world.contents.mode_583999))

        @TransitionFn
        def transition_fn(_ctx, request):
            r = request.contents
            rig.transitions.append((r.target_scene, tuple(r.opaque_words), tuple(r.opaque_dwords)))
            if transition_status == 0 and rig.session is not None:
                return rig.lib.scene_session_request_transition(rig.session, request)
            return transition_status

        @ObserveFn
        def observe(_ctx, effect, value):
            rig.effects.append((EFFECT_NAMES[effect], value))

        self.keep = (load_world, store_world, transition_fn, observe)
        self.host = BindHost(None, load_world if load else LoadFn(),
                             store_world if store else StoreFn(),
                             transition_fn if transition else TransitionFn(), observe)


def configure(lib):
    lib.session_a17_create.argtypes = [c.POINTER(BindHost)]
    lib.session_a17_create.restype = c.c_void_p
    lib.session_a17_destroy.argtypes = [c.c_void_p]
    lib.session_a17_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
    lib.session_a17_begin_scene.restype = c.c_int
    lib.session_a17_handler.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo),
                                        c.POINTER(session.RuntimeState),
                                        c.POINTER(session.HandlerResult)]
    lib.session_a17_handler.restype = c.c_int
    lib.session_a17_pre_gate.argtypes = [c.c_void_p, c.c_size_t, c.c_void_p, c.c_void_p]
    lib.session_a17_pre_gate.restype = None
    lib.session_a17_pointer_row.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(pointer.InputHotspot)]
    lib.session_a17_pointer_row.restype = c.c_int
    lib.session_a17_hover_cursor.argtypes = [c.c_void_p, c.c_size_t, c.c_int16, c.POINTER(Cursor)]
    lib.session_a17_hover_cursor.restype = c.c_int
    lib.session_a17_slot.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(Slot)]
    lib.session_a17_slot.restype = c.c_int
    lib.session_a17_failure.argtypes = [c.c_void_p]
    lib.session_a17_failure.restype = c.c_char_p
    lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t,
                                             c.POINTER(session.SceneActionInfo)]
    lib.scene_session_get_pointer_result.argtypes = [c.c_void_p, c.POINTER(pointer.PointerResult)]
    lib.scene_session_bind_pointer.argtypes = [c.c_void_p, c.POINTER(pointer.PointerHost)]
    lib.session_input_init.argtypes = [c.POINTER(pointer.InputState)]
    lib.session_input_feed.argtypes = [c.POINTER(pointer.InputState), c.c_int, c.c_uint32,
                                       c.c_int32, c.c_int32, c.c_void_p, c.c_void_p]
    lib.session_input_tick.argtypes = [c.POINTER(pointer.InputState),
                                       c.POINTER(pointer.InputContext), c.c_void_p]
    lib.session_input_scan.argtypes = [c.POINTER(pointer.InputState),
                                       c.POINTER(pointer.InputContext), c.c_void_p, c.c_size_t]
    lib.session_input_publish_candidate.argtypes = [c.POINTER(pointer.InputState), c.c_int32]
    for name in ('init', 'feed', 'tick', 'scan', 'publish_candidate'):
        getattr(lib, 'session_input_' + name).restype = c.c_int
    lib.scene_session_accept_action_candidate.argtypes = [c.c_void_p, c.c_size_t]
    lib.scene_session_accept_action_candidate.restype = c.c_int
    lib.scene_session_request_transition.argtypes = [c.c_void_p,
                                                     c.POINTER(session.SceneTransitionRequest)]
    lib.scene_session_request_transition.restype = c.c_int
    lib.scene_session_get_pending_transition.argtypes = [
        c.c_void_p, c.POINTER(session.SceneTransitionRequest)]
    lib.scene_session_get_pending_transition.restype = c.c_int
    lib.scene_session_set_pre_gate.argtypes = [c.c_void_p, c.c_uint8, c.c_void_p, c.c_void_p]
    lib.scene_session_set_pre_gate.restype = c.c_int


class Fixture:
    def __init__(self, test, lib, actions, rig=None, with_pre_gate=True, pointer_rows=False):
        self.lib = lib
        self.test = test
        self.rig = rig or Rig17()
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world()
        self.binding = lib.session_a17_create(c.byref(self.rig.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a17_begin_scene(self.binding, self.scene), 0)
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a17_handler', lib))
        self.bindings = (session.Binding * 2)(session.Binding(0x17, 11, handler, self.binding),
                                              session.Binding(0x16, 11, handler, self.binding))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6401,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=2,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        pre_gate = c.cast(lib.session_a17_pre_gate, c.c_void_p)
        if with_pre_gate:
            for runtime_type in (0x16, 0x17):
                test.assertEqual(lib.scene_session_set_pre_gate(
                    self.session, runtime_type, pre_gate, self.binding), 0)
        self.keep = [prepare, media, handler]
        self.rig17_pointer = None
        if pointer_rows:
            self.rig17_pointer = pointer.Rig(lib)

            @pointer.ExternalFn
            def external(_ctx, index, row):
                return lib.session_a17_pointer_row(self.binding, index, row)

            self.keep.append(external)
            self.rig17_pointer.host.external_row = external
            self.rig17_pointer.bind(self.session)
            self.rig17_pointer.ctx.cursor = pointer.Rect(300, 100, 300, 100)
        self.rig.lib, self.rig.session = lib, self.session
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a17_destroy(self.binding)
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
        self.test.assertEqual(self.lib.session_a17_slot(self.binding, index, c.byref(out)), 0)
        return out.request, out.left, out.top, out.right, out.bottom, out.done

    def row(self, index=0):
        out = pointer.InputHotspot()
        found = self.lib.session_a17_pointer_row(self.binding, index, c.byref(out))
        if not found:
            return None
        r = out.rectangle
        return out.index, r.left, r.top, r.right, r.bottom, out.active


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        configure(cls.lib)

    def row_action(self, runtime_type=0x17, records=GALLERY, deps=(), **kw):
        return session.action(runtime_type, 1, body(records=records, **kw), deps)

    def test_first_tick_registers_and_exports_the_frame_rectangle(self):
        f = Fixture(self, self.lib, [self.row_action()])
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(f.rig.start_flag, 1)
        self.assertEqual(f.slot(), (1, 243, 86, 398, 321, 0))
        self.assertEqual(f.row(), (0, 243, 86, 398, 321, 1))
        self.assertEqual(f.row(1), None)
        self.assertEqual(f.rig.transitions, [])

    def test_exported_rectangle_follows_the_selector_each_tick(self):
        f = Fixture(self, self.lib, [self.row_action()])
        f.tick()
        for selector, rect in ((2, (4, 74, 110, 310)), (6, (493, 86, 619, 314))):
            f.rig.selector = selector
            f.tick()
            self.assertEqual(f.row(), (0, *rect, 1))
        f.rig.selector = 99
        f.tick()
        self.assertEqual(f.row(), None)
        self.assertEqual(f.state(), (0, 1))

    def test_pre_gate_clears_the_request_before_a_false_gate(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))])
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), (0, 243, 86, 398, 321, 1))
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.row(), None)         # cleared although the handler did not run
        self.assertEqual(f.state(), (0, 1))
        f.flags[3] = 1
        f.tick()
        self.assertEqual(f.row(), (0, 243, 86, 398, 321, 1))

    def test_false_gate_from_the_start_exports_nothing_and_does_not_start(self):
        f = Fixture(self, self.lib, [self.row_action(deps=(session.flag_gate(3),))])
        f.tick()
        self.assertEqual((f.state(), f.row(), f.rig.start_flag), ((0, 0), None, 0))

    def test_accepted_candidate_finishes_with_the_scene_change_and_direct_completion(self):
        f = Fixture(self, self.lib, [self.row_action(target=6402, words=(7, 8, 9),
                                                    dwords=(10, 11, 12))])
        f.tick()
        self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.state(), (1, 2))               # completion byte, phase stays 2
        self.assertEqual(f.rig.transitions, [(6402, (7, 8, 9), (10, 11, 12))])
        self.assertEqual(f.slot()[5], 1)
        pending = session.SceneTransitionRequest()
        self.assertEqual(self.lib.scene_session_get_pending_transition(f.session, c.byref(pending)), 0)
        self.assertEqual((pending.target_scene, tuple(pending.opaque_words)), (6402, (7, 8, 9)))

    def test_full_pointer_flow_hover_click_and_transition(self):
        f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
        # rectangle of frame 4 is (243,86,398,321): place the cursor inside it
        f.rig17_pointer.ctx.cursor = pointer.Rect(300, 100, 300, 100)
        f.tick()
        f.tick()
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, 0)
        self.assertEqual(f.rig17_pointer.scanned, [(0, 243, 86, 398, 321)])
        f.rig17_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.rig.transitions[0][0], 6402)
        self.assertEqual(f.state(), (1, 2))

    def test_click_outside_the_frame_rectangle_does_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
        f.rig17_pointer.ctx.cursor = pointer.Rect(5, 5, 5, 5)
        f.tick()
        f.tick()
        f.rig17_pointer.click()
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.assertEqual((f.state(), f.rig.transitions), ((0, 1), []))

    def test_record_for_another_frame_is_not_hot(self):
        f = Fixture(self, self.lib, [self.row_action()], pointer_rows=True)
        f.rig.selector = 2                       # rectangle (4,74,110,310)
        f.rig17_pointer.ctx.cursor = pointer.Rect(300, 100, 300, 100)
        f.tick()
        f.tick()
        result = pointer.PointerResult()
        self.lib.scene_session_get_pointer_result(f.session, c.byref(result))
        self.assertEqual(result.candidate_after_scan, -1)

    def test_a_decoy_row_before_and_the_hotspot_row_after(self):
        # A completed earlier row of another type must not disturb the export.
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()])
        f.tick()
        self.assertEqual((f.row(0), f.row(1)), (None, (1, 243, 86, 398, 321, 1)))
        self.assertEqual(f.state(1), (0, 1))

    def test_missing_transition_provider_blocks_at_phase_two_without_effects(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=Rig17(transition=False))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x17))
        self.assertEqual(f.state(), (0, 2))
        self.assertEqual(f.slot()[5], 0)
        self.assertIn(b'transition', self.lib.session_a17_failure(f.binding))

    def test_transition_refusal_blocks_and_commits_nothing(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=Rig17(transition_status=1))
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.detail_status), (5, 2))  # handler error
        self.assertEqual((f.state(), f.slot()[5]), ((0, 2), 0))
        self.assertIn(b'refused', self.lib.session_a17_failure(f.binding))

    def test_missing_world_provider_blocks_before_any_effect(self):
        f = Fixture(self, self.lib, [self.row_action()], rig=Rig17(load=False))
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_type), (session.SESSION_BLOCKED, 0x17))
        self.assertEqual((f.state(), f.slot()), ((0, 0), (0, 0, 0, 0, 0, 0)))
        self.assertIn(b'world', self.lib.session_a17_failure(f.binding))

    def test_raw_0x16_shares_the_handler_and_the_default_cursor_path(self):
        f = Fixture(self, self.lib, [self.row_action(runtime_type=0x16, target=2351,
                                                     records=[(7, 1, 2, 30, 40), (8, 5, 6, 70, 80)])])
        f.rig.selector = 8
        f.tick()
        self.assertEqual(f.row(), (0, 5, 6, 70, 80, 1))
        cursor = Cursor()
        self.assertEqual(self.lib.session_a17_hover_cursor(f.binding, 0, -1, c.byref(cursor)), 0)
        self.assertEqual(cursor.cursor_index, 0)
        self.assertEqual(self.lib.session_a17_hover_cursor(f.binding, 7, -1, c.byref(cursor)), ARGUMENT)

    def test_hover_cursor_of_a_0x17_row_is_index_eight(self):
        f = Fixture(self, self.lib, [self.row_action()])
        cursor = Cursor()
        self.assertEqual(self.lib.session_a17_hover_cursor(f.binding, 0, -1, c.byref(cursor)), 0)
        self.assertEqual((cursor.cursor_index, cursor.table_offset), (8, 8 * 32 + 16))

    def test_handler_rejects_foreign_rows_and_bad_arguments(self):
        flag_row = session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                  session.i16(-1) + session.i16(0))
        f = Fixture(self, self.lib, [flag_row, self.row_action()])
        action = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for index in (0, 99):
            self.assertEqual(self.lib.session_a17_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(self.lib.session_a17_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_scene_reload_replaces_rows(self):
        f = Fixture(self, self.lib, [self.row_action()])
        f.tick()
        other, owner = session.open_scene(self.lib, [self.row_action(records=[(9, 1, 2, 3, 4)])])
        self.assertEqual(self.lib.session_a17_begin_scene(f.binding, other), 0)
        self.assertEqual(f.row(), None)          # slots are reset with the scene
        f.rig.selector = 9
        self.lib.scene_resource_close(other)
        empty, owner2 = session.open_scene(self.lib, [])
        self.assertEqual(self.lib.session_a17_begin_scene(f.binding, empty), 0)
        self.assertNotEqual(self.lib.session_a17_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(empty)
        del owner, owner2


if __name__ == '__main__':
    unittest.main()
