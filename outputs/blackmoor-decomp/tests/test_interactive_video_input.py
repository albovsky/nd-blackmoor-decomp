"""Normal synthetic checks for the recovered IV hover/release boundary.

No original code/resources, devices, sanitizer children or fault fixtures.
The C helper is compiled in temporary storage and failures use unittest exits.
"""
import ctypes as c
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BOUNDS, HOST, STALE = range(5)
NONE, RECTANGLE, OUTER = range(3)
STANDARD, HELD_ITEM = range(2)


class Rect(c.Structure):
    _fields_ = [('d', c.c_int32 * 6)]


class Entry(c.Structure):
    _fields_ = [('id', c.c_int16), ('count', c.c_int16), ('byte_4', c.c_uint8),
                ('word_5', c.c_int16), ('word_7', c.c_int16), ('rects', c.POINTER(Rect))]


class Iv(c.Structure):
    _fields_ = [('name', c.c_uint8 * 33), ('count', c.c_int32), ('entries', c.POINTER(Entry))]


class Object(c.Structure):
    _fields_ = [('body', c.POINTER(c.c_uint8)), ('iv', c.POINTER(Iv)), ('slot', c.c_int16),
                ('armed', c.c_int32), ('changed', c.c_int32), ('record', c.POINTER(Entry)),
                ('word_152', c.c_int16), ('last_index', c.c_int32), ('dword_14e', c.c_int32),
                ('dword_154', c.c_int32), ('dword_158', c.c_int32), ('origin_present', c.c_int32),
                ('scan_index', c.c_int32)]


class State(c.Structure):
    _fields_ = [('generation', c.c_uint64), ('object', c.POINTER(Object)), ('iv', c.POINTER(Iv)),
                ('body', c.POINTER(c.c_uint8)), ('entry_index', c.c_size_t),
                ('rectangle_index', c.c_size_t), ('selection', c.c_uint32)]


class View(c.Structure):
    _fields_ = [('object', c.POINTER(Object)), ('body_length', c.c_size_t),
                ('generation', c.c_uint64), ('player_rectangle', c.c_int32 * 4)]


class World(c.Structure):
    _fields_ = [('held_item', c.c_int16), ('cursor_index', c.c_int32),
                ('cursor_variant', c.c_uint32), ('cursor_source', c.c_int32),
                ('cursor_table_offset', c.c_uint32), ('cursor_enabled', c.c_uint32),
                ('candidate', c.c_int32), ('event_flags', c.POINTER(c.c_int32)),
                ('event_flag_count', c.c_size_t)]


RESTORE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16)


class Host(c.Structure):
    _fields_ = [('context', c.c_void_p), ('restore_held_item', RESTORE)]


class Result(c.Structure):
    _fields_ = [('hit', c.c_uint32), ('candidate', c.c_int32), ('rectangle_index', c.c_int32),
                ('flag_written', c.c_uint32), ('flag_index', c.c_int16), ('flag_value', c.c_int32)]


def rectangle(bounds, flag=0, cursor=1):
    packed = (flag & 0xffff) | ((cursor & 0xffff) << 16)
    return Rect((c.c_int32 * 6)(0, *bounds, c.c_int32(packed).value))


class Fixture:
    def __init__(self, api):
        self.api = api
        data = bytearray(105)
        for i, value in enumerate((9, 11, 12, 13, 14)):
            struct.pack_into('<h', data, 0x5f + 2 * i, value)
        for i, pair in enumerate(((100, 7), (101, -3), (102, 9))):
            struct.pack_into('<hh', data, 0x23 + 4 * i, *pair)
        self.body = (c.c_uint8 * 105).from_buffer_copy(data)
        self.rects0 = (Rect * 2)(rectangle((10, 20, 30, 40)),
                                  rectangle((10, 20, 35, 45), 1, 2))
        self.rects1 = (Rect * 1)(rectangle((50, 50, 60, 60), 2, 0))
        self.entries = (Entry * 2)(Entry(0, 2, 1, 1, 2, self.rects0),
                                    Entry(1, 1, 1, 2, 3, self.rects1))
        self.iv = Iv((c.c_uint8 * 33)(), 2, self.entries)
        self.object = Object()
        self.object.body = self.body
        self.object.iv = c.pointer(self.iv)
        self.object.armed = self.object.origin_present = 1
        self.object.record = c.pointer(self.entries[0])
        self.object.word_152 = 3
        self.object.dword_154 = 0x12345678
        self.object.dword_158 = 0x23456789
        self.view = View(c.pointer(self.object), 105, 42, (c.c_int32 * 4)(0, 0, 100, 100))
        self.flags = (c.c_int32 * 128)()
        self.world = World(3, 77, 9, STANDARD, 0x777, 0, 55, self.flags, len(self.flags))
        self.state = State()
        api.interactive_video_input_reset(c.byref(self.state), 42)
        self.host = Host(None, RESTORE())
        self.result = Result()

    def hover(self, x=10, y=20):
        return self.api.interactive_video_input_hover(c.byref(self.state), c.byref(self.view),
            c.byref(self.world), c.byref(self.host), x, y, c.byref(self.result))

    def release(self):
        return self.api.interactive_video_input_release(c.byref(self.state), c.byref(self.view),
            c.byref(self.world), c.byref(self.result))

    def put_word(self, offset, value):
        raw = struct.pack('<h', value)
        self.body[offset], self.body[offset + 1] = raw


class InteractiveVideoInputTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-iv-input-')
        cls.addClassCleanup(cls.temp.cleanup)
        library = Path(cls.temp.name) / 'libivinput.dylib'
        compiled = subprocess.run(['cc', '-std=c11', '-O2', '-Wall', '-Wextra', '-Wpedantic', '-Werror',
            '-fPIC', '-shared', str(PROJECT / 'src/interactive_video_input.c'), '-o', str(library)],
            capture_output=True, text=True, timeout=30)
        if compiled.returncode:
            raise RuntimeError(compiled.stderr)
        cls.api = c.CDLL(str(library))
        cls.api.interactive_video_input_reset.argtypes = [c.POINTER(State), c.c_uint64]
        cls.api.interactive_video_input_reset.restype = None
        cls.api.interactive_video_input_hover.argtypes = [c.POINTER(State), c.POINTER(View),
            c.POINTER(World), c.POINTER(Host), c.c_int16, c.c_int16, c.POINTER(Result)]
        cls.api.interactive_video_input_release.argtypes = [c.POINTER(State), c.POINTER(View),
            c.POINTER(World), c.POINTER(Result)]
        cls.api.interactive_video_input_hover.restype = c.c_int
        cls.api.interactive_video_input_release.restype = c.c_int

    def test_first_rectangle_inclusive_edges_set_cursor_and_candidate(self):
        for point in ((10, 20), (30, 40)):
            with self.subTest(point=point):
                f = Fixture(self.api)
                self.assertEqual(f.hover(*point), OK)
                self.assertEqual((f.result.hit, f.result.rectangle_index, f.world.candidate), (1, 0, 0x27b0))
                self.assertEqual((f.world.cursor_index, f.world.cursor_variant, f.world.cursor_source,
                                  f.world.cursor_table_offset, f.world.cursor_enabled), (11, 1, STANDARD, 368, 1))
                self.assertEqual(f.release(), OK)
                self.assertEqual((f.flags[100], f.flags[101]), (7, 0))
                self.assertEqual((f.object.dword_154, f.object.dword_158), (0x12345678, 0x23456789))

    def test_retained_rectangle_survives_record_change_and_ignores_candidate(self):
        f = Fixture(self.api)
        self.assertEqual(f.hover(35, 45), OK)  # second rectangle only
        f.object.record = c.pointer(f.entries[1])
        f.world.candidate = -1
        self.assertEqual(f.release(), OK)
        self.assertEqual((f.result.flag_written, f.result.flag_index, f.result.flag_value), (1, 101, -3))
        self.assertEqual((f.flags[100], f.flags[101], f.flags[102]), (0, -3, 0))
        f.flags[101] = 0
        self.assertEqual(f.release(), OK)  # release does not consume the retained selection
        self.assertEqual(f.flags[101], -3)

    def test_outer_fallback_uses_current_record_flag_and_standard_cursor(self):
        f = Fixture(self.api)
        f.put_word(0x5f + 4, 200)
        self.assertEqual(f.hover(100, 100), OK)
        self.assertEqual((f.result.hit, f.world.candidate, f.state.selection, f.object.dword_14e), (1, 0x27b2, OUTER, 1))
        self.assertEqual((f.world.cursor_index, f.world.cursor_variant, f.world.cursor_source), (200, 0, STANDARD))
        f.object.record = c.pointer(f.entries[1])
        self.assertEqual(f.release(), OK)
        self.assertEqual((f.flags[101], f.flags[102]), (0, 9))

    def test_miss_clears_retained_selection_without_changing_cursor_or_candidate(self):
        f = Fixture(self.api)
        self.assertEqual(f.hover(), OK)
        self.assertEqual(f.hover(101, 101), OK)
        self.assertEqual((f.result.hit, f.state.selection, f.object.dword_14e), (0, NONE, 0))
        self.assertEqual((f.world.candidate, f.world.cursor_index), (0x27b0, 11))
        self.assertEqual(f.release(), OK)
        self.assertEqual(sum(f.flags), 0)

    def test_no_cursor_or_flag_selector_does_not_fall_back_to_outer_action(self):
        f = Fixture(self.api)
        f.rects0[0] = rectangle((10, 20, 30, 40), -1, -1)
        self.assertEqual(f.hover(), OK)
        self.assertEqual((f.world.candidate, f.world.cursor_index, f.world.cursor_variant), (0x27b0, 77, 9))
        self.assertEqual(f.release(), OK)
        self.assertEqual((f.result.flag_written, sum(f.flags)), (0, 0))

    def test_held_item_restore_precedes_later_origin_guard_and_cursor_selection(self):
        f = Fixture(self.api)
        f.world.held_item = 5
        f.put_word(0x5f, 200)
        f.put_word(0x5f + 2, 200)
        calls = []
        def restore(_, item):
            calls.append((item, f.state.selection, f.world.candidate, f.world.cursor_index))
            return 0
        f.restore = RESTORE(restore)
        f.host.restore_held_item = f.restore
        f.object.origin_present = 0
        self.assertEqual(f.hover(), OK)
        self.assertEqual(calls, [(3, NONE, 55, 77)])
        self.assertEqual(f.world.held_item, 3)
        f.object.origin_present = 1
        self.assertEqual(f.hover(), OK)
        self.assertEqual(len(calls), 1)
        self.assertEqual((f.world.cursor_index, f.world.cursor_source, f.world.candidate), (40, HELD_ITEM, 0x27b0))

    def test_restore_host_is_required_only_on_exact_branch_and_failure_is_explicit(self):
        f = Fixture(self.api)
        f.world.held_item = 5
        self.assertEqual(f.hover(), OK)  # cursor[0] is not 200
        f.put_word(0x5f, 200)
        self.assertEqual(f.hover(), HOST)
        self.assertEqual((f.world.held_item, f.state.selection), (5, NONE))
        f.restore = RESTORE(lambda *_: 1)
        f.host.restore_held_item = f.restore
        self.assertEqual(f.hover(), HOST)
        self.assertEqual(f.world.held_item, 5)
        f.object.word_152 = -1
        self.assertEqual(f.hover(), OK)  # saved -1 excludes restore

    def test_original_armed_record_body_origin_release_guards_remain_noops(self):
        for field, value in (('armed', 0), ('record', c.POINTER(Entry)()),
                             ('body', c.POINTER(c.c_uint8)()), ('origin_present', 0)):
            with self.subTest(field=field):
                f = Fixture(self.api)
                self.assertEqual(f.hover(), OK)
                setattr(f.object, field, value)
                self.assertEqual(f.release(), OK)
                self.assertEqual(sum(f.flags), 0)

    def test_lifetime_generation_and_owner_changes_refuse_stale_release(self):
        f = Fixture(self.api)
        self.assertEqual(f.hover(), OK)
        f.view.generation += 1
        self.assertEqual(f.release(), STALE)
        self.assertEqual(sum(f.flags), 0)
        self.api.interactive_video_input_reset(c.byref(f.state), 43)
        self.assertEqual(f.release(), OK)
        self.assertEqual(f.hover(), OK)
        replacement = Iv((c.c_uint8 * 33)(), 2, f.entries)
        f.object.iv = c.pointer(replacement)
        self.assertEqual(f.release(), STALE)

    def test_native_bounds_refuse_malformed_selectors_and_flag_span(self):
        f = Fixture(self.api)
        f.rects0[0] = rectangle((10, 20, 30, 40), 0, 5)
        self.assertEqual(f.hover(), BOUNDS)
        self.assertEqual((f.state.selection, f.world.candidate), (NONE, 55))
        for selector in (-2, 15):
            with self.subTest(flag_selector=selector):
                f = Fixture(self.api)
                f.rects0[0] = rectangle((10, 20, 30, 40), selector, 1)
                self.assertEqual(f.hover(), OK)
                self.assertEqual(f.release(), BOUNDS)
                self.assertEqual(sum(f.flags), 0)
        f = Fixture(self.api)
        self.assertEqual(f.hover(), OK)
        f.world.event_flag_count = 100
        self.assertEqual(f.release(), BOUNDS)
        self.assertEqual(sum(f.flags), 0)
        f.put_word(0x23, -1)
        self.assertEqual(f.release(), OK)
        self.assertEqual(f.result.flag_written, 0)


if __name__ == '__main__':
    unittest.main()
