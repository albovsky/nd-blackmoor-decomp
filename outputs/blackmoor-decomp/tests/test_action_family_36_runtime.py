"""RT-14: raw 0x36 static overlay runtime (COverlay) and its session binding.

Facts under test (original GAME.EXE, all read from the disassembly):
 * 0x4899ca is one function: phase 0 registers and FALLS THROUGH into phase 1
   in the same call; phase 1 waits for event[+0x39] == +0x3b (index -1 never)
   or, for marker 2, for the animation end; phase 2 stops the sound, writes up
   to ten event words, optionally stores the scene-change words, sets 0x5bb1ca,
   and finishes through 0x42ba3a.
 * Registration order: list push, sound start, 0x5bb1ca := 1, redraw words,
   request clear, surface plan (cache reuse by case-insensitive name, AUTOTEXT
   globals, or a CIFTREE load into the first free cache slot), first free
   render slot 24..63, render entry, animation init, phase := 1.
 * 0x4897cd hits the first registered overlay (list order) whose row phase is 1
   and whose record has frame == selector and hot word == 1, inclusive
   bounds, before the generic row scan.
 * 0x48a3db draws every record whose frame equals the selector.
"""
import ctypes as c
import os
from pathlib import Path
import struct
import subprocess
import unittest

import session_binding_support as session

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily36_runtime.dylib'


def library_path():
    return Path(os.environ.get('A36_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    # Mutation checks supply a separately compiled library; never rebuild it.
    if 'A36_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_36_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


IMAGE_BYTES = 0xABA
OK, ARGUMENT, UNSUPPORTED, BOUNDS, HOST = range(5)
FX_NAMES = ['', 'begin', 'image_init', 'list_push', 'sound_start', 'start_flag', 'redraw',
            'request_clear', 'cache_reuse', 'autotext', 'surface_load', 'slot', 'render_store',
            'anim_init', 'phase', 'anim_step', 'sound_stop', 'event_write', 'transfer',
            'finish', 'hit', 'cursor', 'blit']
FX = {name: index for index, name in enumerate(FX_NAMES)}


class Render(c.Structure):
    _fields_ = [('layer', c.c_int32), ('callback', c.c_int32), ('surface', c.c_uint32),
                ('field_0c', c.c_int32), ('field_10', c.c_int32), ('visible', c.c_int32),
                ('active', c.c_int32), ('row', c.c_int32), ('tag', c.c_char * 16)]


class Manager(c.Structure):
    _fields_ = [('count', c.c_int32), ('list', c.c_int32 * 40), ('current_row', c.c_int32),
                ('current_record', c.c_int32), ('tick', c.c_uint32),
                ('cache', c.c_uint32 * 24), ('render', Render * 64)]


class World(c.Structure):
    _fields_ = [('events', c.POINTER(c.c_int32)), ('event_count', c.c_size_t),
                ('selector', c.c_int16), ('held_item', c.c_int16),
                ('start_flag_5bb1ca', c.c_int32), ('mode_583999', c.c_int32),
                ('xfer_5bb57b', c.c_int32),
                ('xfer_5bb599', c.c_int16), ('xfer_5bb595', c.c_int16), ('xfer_5c39ff', c.c_int16),
                ('xfer_5bb59b', c.c_int32), ('xfer_5bb59f', c.c_int32), ('xfer_5bb5a3', c.c_int32),
                ('redraw_5831c8', c.c_int32), ('redraw_5831c6', c.c_int16),
                ('view_x', c.c_int32), ('view_y', c.c_int32),
                ('background_surface', c.c_uint32), ('autotext_surface', c.c_uint32 * 3),
                ('item_flag_5b44f8', c.c_int32), ('cursor_index', c.c_int32),
                ('cursor_variant', c.c_int32), ('cursor_surface', c.c_int32),
                ('cursor_table', c.c_int32), ('cursor_layer', c.c_int32),
                ('cursor_surface_default', c.c_int32), ('cursor_surface_held', c.c_int32),
                ('candidate', c.c_int32)]


class Blit(c.Structure):
    _fields_ = [('kind', c.c_int), ('row', c.c_int), ('slot', c.c_int),
                ('source_surface', c.c_uint32), ('destination_marker', c.c_uint32),
                ('src', c.c_int32 * 4), ('dst', c.c_int32 * 4), ('label', c.c_char_p)]


LoadFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_char_p, c.POINTER(c.c_uint32))
SoundStartFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_uint16)
SoundPlayingFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_uint16, c.POINTER(c.c_int))
SoundStopFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8))
TickFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))
PhaseFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32, c.POINTER(c.c_uint32))
BlitFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(Blit))
ObserveFn = c.CFUNCTYPE(None, c.c_void_p, c.c_int, c.c_int32, c.c_int32)


class Host(c.Structure):
    _fields_ = [('context', c.c_void_p), ('load_surface', LoadFn), ('sound_start', SoundStartFn),
                ('sound_is_playing', SoundPlayingFn), ('sound_stop', SoundStopFn),
                ('tick_count', TickFn), ('row_phase', PhaseFn), ('blit', BlitFn),
                ('observe', ObserveFn)]


class Rows(c.Structure):
    _fields_ = [('images', c.POINTER(c.POINTER(c.c_uint8))), ('count', c.c_size_t)]


class StepResult(c.Structure):
    _fields_ = [('phase_after', c.c_uint32), ('registered', c.c_uint8), ('finished', c.c_uint8)]


class HotRect(c.Structure):
    _fields_ = [('row', c.c_int32), ('record', c.c_int32), ('left', c.c_int32),
                ('top', c.c_int32), ('right', c.c_int32), ('bottom', c.c_int32)]


def bind(path=None):
    lib = c.CDLL(str(path or library_path()))
    lib.overlay36_manager_reset.argtypes = [c.POINTER(Manager)]
    lib.overlay36_step.argtypes = [c.POINTER(Manager), c.POINTER(Rows), c.c_int32, c.c_uint32,
                                   c.POINTER(World), c.POINTER(Host), c.POINTER(StepResult),
                                   c.POINTER(c.c_char_p)]
    lib.overlay36_hit_test.argtypes = [c.POINTER(Manager), c.POINTER(Rows), c.c_int16, c.c_int16,
                                       c.POINTER(World), c.POINTER(Host), c.POINTER(c.c_int),
                                       c.POINTER(c.c_int32), c.POINTER(c.c_char_p)]
    lib.overlay36_hot_rects.argtypes = [c.POINTER(Manager), c.POINTER(Rows), c.c_int16,
                                        c.POINTER(Host), c.POINTER(HotRect), c.c_size_t,
                                        c.POINTER(c.c_size_t)]
    lib.overlay36_draw_slot.argtypes = [c.POINTER(Manager), c.POINTER(Rows), c.c_int,
                                        c.POINTER(World), c.POINTER(Host), c.POINTER(c.c_char_p)]
    lib.overlay36_render_layers.argtypes = [c.POINTER(Manager), c.POINTER(Rows), c.c_int32,
                                            c.c_int32, c.POINTER(World), c.POINTER(Host),
                                            c.POINTER(c.c_size_t), c.POINTER(c.c_char_p)]
    return lib


# ---- image construction (same layout as the A-36.1 constructor) -----------

def w16(buf, offset, value):
    struct.pack_into('<h', buf, offset, value)


def w32(buf, offset, value):
    struct.pack_into('<i', buf, offset, value)


def secondary(frame, primary=0, hot=0, src=(0, 0, 0, 0), dst=(0, 0, 0, 0)):
    record = bytearray(38)
    w16(record, 0, frame)
    w16(record, 2, primary)
    w16(record, 4, hot)
    for i, value in enumerate(src):
        w32(record, 6 + 4 * i, value)
    for i, value in enumerate(dst):
        w32(record, 0x16 + 4 * i, value)
    return bytes(record)


def primary_record(left=0, top=0, right=0, bottom=0):
    return struct.pack('<4i', left, top, right, bottom)


def prefix(name=b'OVL', *, layer=10, marker=1, plain=1, flag21=2, action25=2, direction=1,
           loop=1, init=0, first=0, last=0, fps=15, event=(-1, 0), transfer=(0, 0, 0, 0, 0, 0, 0),
           pairs=(), sound=b'NO SOUND', sound_word=8, primaries=1, secondaries=1):
    p = bytearray(0xAC)
    p[0:len(name)] = name
    w16(p, 0x21, flag21)
    w16(p, 0x23, plain)
    w16(p, 0x25, action25)
    w16(p, 0x27, layer)
    w16(p, 0x29, marker)
    w16(p, 0x2b, primaries)
    w16(p, 0x2d, direction)
    w16(p, 0x2f, loop)
    w16(p, 0x31, init)
    w16(p, 0x33, first)
    w16(p, 0x35, last)
    w16(p, 0x37, fps)
    w16(p, 0x39, event[0])
    w16(p, 0x3b, event[1])
    for offset, value in zip((0x3d, 0x3f, 0x41, 0x43), transfer[:4]):
        w16(p, offset, value)
    for offset, value in zip((0x45, 0x49, 0x4d), transfer[4:]):
        w32(p, offset, value)
    for i in range(10):
        w16(p, 0x51 + 4 * i, -1)
    for i, (index, value) in enumerate(pairs):
        w16(p, 0x51 + 4 * i, index)
        w16(p, 0x53 + 4 * i, value)
    p[0x79:0x79 + len(sound) + 1] = sound + b'\0'
    w16(p, 0x9a, sound_word)
    w16(p, 0xaa, secondaries)
    return bytes(p)


def raw_body(pre, primaries, secondaries, deps=b''):
    return pre + b''.join(primaries) + b''.join(secondaries) + deps


def make_image(pre, primaries, secondaries):
    image = bytearray(IMAGE_BYTES)
    image[0:0xAC] = pre
    for i, record in enumerate(primaries):
        image[0xAC + 16 * i:0xAC + 16 * (i + 1)] = record
    for i, record in enumerate(secondaries):
        image[0x6EC + 38 * i:0x6EC + 38 * (i + 1)] = record
    return image


def image_s16(image, offset):
    return struct.unpack_from('<h', image, offset)[0]


def image_u32(image, offset):
    return struct.unpack_from('<I', image, offset)[0]


def simple_image(name=b'OVL', **options):
    """One primary record, one secondary (frame 0, hot) covering 10..29 x 20..39."""
    pre_options = {k: options.pop(k) for k in list(options) if k in
                   ('layer', 'marker', 'plain', 'flag21', 'action25', 'direction', 'loop', 'init',
                    'first', 'last', 'fps', 'event', 'transfer', 'pairs', 'sound', 'sound_word')}
    primaries = options.pop('primaries', [primary_record(5, 6, 24, 25)])
    secs = options.pop('secondaries', [secondary(0, 0, 1, (0, 0, 19, 19), (10, 20, 29, 39))])
    assert not options, options
    pre = prefix(name, primaries=len(primaries), secondaries=len(secs), **pre_options)
    return make_image(pre, primaries, secs)


class Rig:
    """Manager + world + providers with an ordered shared log."""

    def __init__(self, lib, images, *, event_count=64, selector=0, held=-1, phases=None,
                 ticks=(1000,), playing=None, providers=True):
        self.lib = lib
        self.manager = Manager()
        lib.overlay36_manager_reset(c.byref(self.manager))
        self.buffers = [None if image is None else (c.c_uint8 * IMAGE_BYTES).from_buffer_copy(image)
                        for image in images]
        self.pointers = (c.POINTER(c.c_uint8) * len(images))(
            *[None if b is None else c.cast(b, c.POINTER(c.c_uint8)) for b in self.buffers])
        self.rows = Rows(self.pointers, len(images))
        self.events = (c.c_int32 * event_count)()
        self.world = World()
        self.world.events = c.cast(self.events, c.POINTER(c.c_int32))
        self.world.event_count = event_count
        self.world.selector = selector
        self.world.held_item = held
        self.world.view_x = 10
        self.world.view_y = 10
        self.world.background_surface = 0x700
        self.world.autotext_surface[:] = [0x501, 0x502, 0x503]
        self.world.cursor_surface_default = 0x1111
        self.world.cursor_surface_held = 0x2222
        self.log = []
        self.fx = []
        # One ordered trace of provider calls and kernel effects (the oracle
        # compares it with the original's ordered effects). `snapshotter`, when
        # set, is called at every provider call.
        self.trace = []
        self.snapshotter = None
        self.surface_fn = None
        self.phases = dict(phases or {})
        self.ticks = list(ticks)
        self.playing = playing
        self.next_surface = 0x100
        self.load_status = 0
        self.blit_status = 0

        def note(*entry):
            self.trace.append(('hook',) + entry + (self.snapshotter() if self.snapshotter else None,))

        @LoadFn
        def load(_ctx, name, out):
            self.log.append(('load', name))
            note('load', name)
            if self.load_status:
                return self.load_status
            if self.surface_fn is not None:
                out[0] = self.surface_fn(name)
                return 0
            out[0] = self.next_surface
            self.next_surface += 1
            return 0

        @SoundStartFn
        def sound_start(_ctx, record, word):
            self.log.append(('sound_start', bytes(record[:9]), word))
            note('sound_start', bytes(record[:9]), word)
            return 0

        @SoundPlayingFn
        def sound_playing(_ctx, word, out):
            self.log.append(('sound_playing', word))
            out[0] = 1 if self.playing is None else self.playing
            note('sound_playing', word)
            return 0

        @SoundStopFn
        def sound_stop(_ctx, record):
            self.log.append(('sound_stop', bytes(record[:9])))
            note('sound_stop', bytes(record[:9]))
            return 0

        @TickFn
        def tick(_ctx, out):
            value = self.ticks.pop(0) if len(self.ticks) > 1 else self.ticks[0]
            self.log.append(('tick', value))
            out[0] = value
            note('tick', value)
            return 0

        @PhaseFn
        def phase(_ctx, row, out):
            out[0] = self.phases.get(row, 1)
            return 0

        @BlitFn
        def blit(_ctx, op):
            o = op[0]
            self.log.append(('blit', o.kind, o.row, o.slot, o.source_surface, tuple(o.src),
                             tuple(o.dst), o.label))
            note('blit', o.kind, o.source_surface, tuple(o.src), tuple(o.dst), o.label)
            return self.blit_status

        @ObserveFn
        def observe(_ctx, effect, a, b):
            self.fx.append((FX_NAMES[effect], a, b))
            self.trace.append(('fx', FX_NAMES[effect], a, b))

        self.keep = (load, sound_start, sound_playing, sound_stop, tick, phase, blit, observe)
        self.host = Host(None, load, sound_start, sound_playing, sound_stop, tick, phase, blit,
                         observe)
        if not providers:
            self.host = Host(None, LoadFn(), SoundStartFn(), SoundPlayingFn(), SoundStopFn(),
                             TickFn(), PhaseFn(), BlitFn(), observe)

    def image(self, row):
        return bytearray(self.buffers[row])

    def step(self, row, phase):
        result, why = StepResult(), c.c_char_p()
        status = self.lib.overlay36_step(c.byref(self.manager), c.byref(self.rows), row, phase,
                                         c.byref(self.world), c.byref(self.host),
                                         c.byref(result), c.byref(why))
        return status, result, why.value

    def hit(self, x, y):
        hit, row, why = c.c_int(), c.c_int32(), c.c_char_p()
        status = self.lib.overlay36_hit_test(c.byref(self.manager), c.byref(self.rows), x, y,
                                             c.byref(self.world), c.byref(self.host),
                                             c.byref(hit), c.byref(row), c.byref(why))
        return status, hit.value, row.value, why.value

    def hot(self, selector):
        out, count = (HotRect * 16)(), c.c_size_t()
        status = self.lib.overlay36_hot_rects(c.byref(self.manager), c.byref(self.rows), selector,
                                              c.byref(self.host), out, 16, c.byref(count))
        return status, [(r.row, r.record, r.left, r.top, r.right, r.bottom)
                        for r in out[:count.value]]

    def draw(self, slot):
        why = c.c_char_p()
        return self.lib.overlay36_draw_slot(c.byref(self.manager), c.byref(self.rows), slot,
                                            c.byref(self.world), c.byref(self.host),
                                            c.byref(why)), why.value

    def render(self, lo, hi):
        drawn, why = c.c_size_t(), c.c_char_p()
        status = self.lib.overlay36_render_layers(c.byref(self.manager), c.byref(self.rows), lo,
                                                  hi, c.byref(self.world), c.byref(self.host),
                                                  c.byref(drawn), c.byref(why))
        return status, drawn.value, why.value

    def state(self):
        """Everything a rejected visit must leave untouched."""
        return (bytes(self.manager), bytes(self.world), bytes(self.events),
                tuple(bytes(b) for b in self.buffers if b is not None))


class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = bind(build_library())

    # ---- registration --------------------------------------------------

    def test_phase0_registers_in_original_order_and_continues_into_phase1(self):
        rig = Rig(self.lib, [None, simple_image(b'BLU_Key_OVL', layer=11)])
        status, result, why = rig.step(1, 0)
        self.assertEqual((status, why), (OK, b'none'))
        self.assertEqual((result.phase_after, result.registered, result.finished), (1, 1, 0))
        names = [e[0] for e in rig.fx]
        self.assertEqual(names, ['begin', 'image_init', 'list_push', 'start_flag', 'redraw',
                                 'request_clear', 'surface_load', 'slot', 'render_store', 'phase'])
        image = rig.image(1)
        self.assertEqual((image_s16(image, 0xab0), image_s16(image, 0xaa2), image_s16(image, 0xaa4)),
                         (1, 24, 0))
        self.assertEqual((image_u32(image, 0xab2), image_u32(image, 0xab6), image_u32(image, 0xaaa),
                          image_s16(image, 0xaae)), (1, 0x100, 0, 0))
        m = rig.manager
        self.assertEqual((m.count, m.list[0], m.cache[0], m.current_row), (1, 1, 0x100, 1))
        entry = m.render[24]
        self.assertEqual((entry.layer, entry.callback, entry.surface, entry.field_0c,
                          entry.field_10, entry.visible, entry.active, entry.row, entry.tag),
                         (11, 1, 0x100, 0, 0, 1, 1, 1, b'OVERLAY ZRENDER'))
        self.assertEqual((rig.world.start_flag_5bb1ca, rig.world.redraw_5831c8,
                          rig.world.redraw_5831c6), (1, 1, 0))
        self.assertEqual(rig.log, [('load', b'BLU_Key_OVL')])

    def test_second_overlay_takes_next_slot_and_cache_slot(self):
        rig = Rig(self.lib, [simple_image(b'A_OVL'), simple_image(b'B_OVL')])
        rig.step(0, 0)
        rig.step(1, 0)
        self.assertEqual((rig.manager.count, rig.manager.list[0], rig.manager.list[1]), (2, 0, 1))
        self.assertEqual((rig.manager.cache[0], rig.manager.cache[1]), (0x100, 0x101))
        self.assertEqual((rig.manager.render[24].row, rig.manager.render[25].row), (0, 1))
        self.assertEqual(image_s16(rig.image(1), 0xaa2), 25)
        self.assertEqual(image_s16(rig.image(1), 0xaa4), 1)

    def test_same_name_other_case_reuses_the_cached_surface_without_loading(self):
        rig = Rig(self.lib, [simple_image(b'Tut_Next_OVL'), simple_image(b'TUT_NEXT_ovl')])
        rig.step(0, 0)
        rig.fx.clear()
        rig.log.clear()
        status, result, _ = rig.step(1, 0)
        self.assertEqual(status, OK)
        self.assertEqual(rig.log, [])
        self.assertIn(('cache_reuse', 0, 0x100), rig.fx)
        self.assertNotIn('surface_load', [e[0] for e in rig.fx])
        self.assertEqual((image_s16(rig.image(1), 0xaa4), image_u32(rig.image(1), 0xab6)),
                         (0, 0x100))
        self.assertEqual(rig.manager.cache[1], 0)
        self.assertEqual(rig.manager.render[25].surface, 0x100)

    def test_different_name_loads_a_new_surface(self):
        rig = Rig(self.lib, [simple_image(b'A_OVL'), simple_image(b'A_OVL2')])
        rig.step(0, 0)
        rig.step(1, 0)
        self.assertEqual([e for e in rig.log if e[0] == 'load'],
                         [('load', b'A_OVL'), ('load', b'A_OVL2')])

    def test_autotext_names_use_the_global_surfaces_and_keep_cache_slot_minus_one(self):
        rig = Rig(self.lib, [simple_image(b'USE_AUTOTEXT1'), simple_image(b'USE_AUTOTEXT2'),
                             simple_image(b'USE_AUTOTEXT3')])
        for row in range(3):
            self.assertEqual(rig.step(row, 0)[0], OK)
        self.assertEqual([image_u32(rig.image(r), 0xab6) for r in range(3)], [0x501, 0x502, 0x503])
        self.assertEqual([image_s16(rig.image(r), 0xaa4) for r in range(3)], [-1, -1, -1])
        self.assertEqual(rig.log, [])
        self.assertEqual(list(rig.manager.cache), [0] * 24)

    def test_autotext_match_needs_the_terminating_nul(self):
        rig = Rig(self.lib, [simple_image(b'USE_AUTOTEXT1X')])
        rig.step(0, 0)
        self.assertEqual(rig.log, [('load', b'USE_AUTOTEXT1X')])

    def test_named_sound_starts_after_the_list_push(self):
        rig = Rig(self.lib, [simple_image(b'S_OVL', sound=b'CLICK', sound_word=0x1234)])
        status, _, _ = rig.step(0, 0)
        self.assertEqual(status, OK)
        names = [e[0] for e in rig.fx]
        self.assertLess(names.index('list_push'), names.index('sound_start'))
        self.assertLess(names.index('sound_start'), names.index('start_flag'))
        self.assertEqual(rig.log[0], ('sound_start', b'CLICK\0\0\0\0', 0x1234))

    def test_rejections_change_nothing(self):
        cases = []
        full = Rig(self.lib, [simple_image()])
        full.manager.count = 40
        cases.append(('list full', full, b'list'))
        slots = Rig(self.lib, [simple_image()])
        for i in range(24, 64):
            slots.manager.render[i].active = 1
            slots.manager.render[i].row = -1
        cases.append(('render full', slots, b'render table'))
        cache = Rig(self.lib, [simple_image()])
        for i in range(24):
            cache.manager.cache[i] = 0x900 + i
        cases.append(('cache full', cache, b'cache'))
        unterminated = Rig(self.lib, [bytearray(simple_image())])
        raw = unterminated.buffers[0]
        for i in range(33):
            raw[i] = ord('A')
        cases.append(('unterminated name', unterminated, b'terminated'))
        for name, rig, text in cases:
            with self.subTest(name):
                before = rig.state()
                status, _, why = rig.step(0, 0)
                self.assertEqual(status, BOUNDS)
                self.assertIn(text, why)
                self.assertEqual(rig.state(), before)
                self.assertEqual(rig.fx[1:], [])

    def test_missing_providers_are_explicit_and_change_nothing(self):
        for name, image in (('surface', simple_image()),
                            ('sound', simple_image(sound=b'CLICK')),
                            ('tick', simple_image(marker=2, first=0, last=3, primaries=[primary_record()] * 4))):
            with self.subTest(name):
                rig = Rig(self.lib, [image], providers=False)
                before = rig.state()
                status, _, why = rig.step(0, 0)
                self.assertEqual(status, UNSUPPORTED)
                self.assertTrue(why)
                self.assertEqual(rig.state(), before)

    def test_event_index_outside_the_array_is_rejected_before_any_effect(self):
        rig = Rig(self.lib, [simple_image(event=(100, 1))], event_count=64)
        before = rig.state()
        self.assertEqual(rig.step(0, 0)[0], BOUNDS)
        self.assertEqual(rig.state(), before)
        rig = Rig(self.lib, [simple_image(event=(-2, 1))], event_count=64)
        self.assertEqual(rig.step(0, 1)[0], BOUNDS)

    def test_load_failure_after_commit_is_a_host_error(self):
        rig = Rig(self.lib, [simple_image()])
        rig.load_status = 1
        status, _, why = rig.step(0, 0)
        self.assertEqual(status, HOST)
        self.assertIn(b'surface', why)
        self.assertEqual(rig.manager.count, 1)  # committed as in the original

    # ---- phase 1 --------------------------------------------------------

    def test_phase1_event_pair_match_requests_phase2(self):
        rig = Rig(self.lib, [simple_image(event=(7, 3))])
        rig.step(0, 0)
        rig.fx.clear()
        status, result, _ = rig.step(0, 1)
        self.assertEqual((status, result.phase_after, result.finished), (OK, 1, 0))
        rig.events[7] = 2
        self.assertEqual(rig.step(0, 1)[1].phase_after, 1)
        rig.events[7] = 3
        status, result, _ = rig.step(0, 1)
        self.assertEqual((status, result.phase_after), (OK, 2))
        self.assertEqual(rig.fx[-1], ('phase', 2, 0))

    def test_event_pair_match_is_already_taken_by_the_registering_visit(self):
        rig = Rig(self.lib, [simple_image(event=(7, 3))])
        rig.events[7] = 3
        status, result, _ = rig.step(0, 0)
        self.assertEqual((status, result.phase_after, result.registered), (OK, 2, 1))

    def test_event_value_compares_sign_extended_words(self):
        rig = Rig(self.lib, [simple_image(event=(7, -5))])
        rig.step(0, 0)
        rig.events[7] = -5
        self.assertEqual(rig.step(0, 1)[1].phase_after, 2)
        rig.events[7] = 0xfffb
        self.assertEqual(rig.step(0, 1)[1].phase_after, 1)

    def test_event_index_minus_one_never_matches_a_static_overlay(self):
        rig = Rig(self.lib, [simple_image(event=(-1, 0))])
        rig.step(0, 0)
        for _ in range(3):
            self.assertEqual(rig.step(0, 1)[1].phase_after, 1)
        self.assertEqual(list(rig.events), [0] * 64)

    def test_phases_beyond_two_do_nothing_but_the_scratch_store(self):
        rig = Rig(self.lib, [simple_image()])
        before = (bytes(rig.events), bytes(rig.buffers[0]))
        status, result, _ = rig.step(0, 3)
        self.assertEqual((status, result.phase_after, result.registered, result.finished), (OK, 3, 0, 0))
        self.assertEqual((bytes(rig.events), bytes(rig.buffers[0])), before)
        self.assertEqual(rig.manager.current_row, 0)

    # ---- phase 2 ---------------------------------------------------------

    def test_phase2_writes_events_in_order_and_finishes(self):
        image = simple_image(pairs=[(1000, 1), (-1, 5), (12, -2), (13, 7)])
        rig = Rig(self.lib, [image], event_count=1100)
        rig.step(0, 0)
        rig.fx.clear()
        status, result, _ = rig.step(0, 2)
        self.assertEqual((status, result.finished, result.phase_after), (OK, 1, 0))
        self.assertEqual((rig.events[1000], rig.events[12], rig.events[13]), (1, -2, 7))
        self.assertEqual([e[0] for e in rig.fx],
                         ['begin', 'event_write', 'event_write', 'event_write', 'start_flag',
                          'redraw', 'finish'])
        self.assertEqual([e[1:] for e in rig.fx if e[0] == 'event_write'],
                         [(1000, 1), (12, -2), (13, 7)])

    def test_phase2_start_flag_follows_word_0x21(self):
        for flag21, expected in ((1, 0), (2, 1), (0, 1), (-1, 1)):
            with self.subTest(flag21=flag21):
                rig = Rig(self.lib, [simple_image(flag21=flag21)])
                rig.step(0, 2)
                self.assertEqual(rig.world.start_flag_5bb1ca, expected)

    def test_phase2_scene_change_words_only_when_action_is_one(self):
        transfer = (9999, 3, 4, 5, 66, 77, 88)
        rig = Rig(self.lib, [simple_image(action25=1, transfer=transfer)])
        rig.step(0, 2)
        w = rig.world
        self.assertEqual((w.xfer_5bb57b, w.xfer_5bb599, w.xfer_5bb595, w.xfer_5c39ff,
                          w.xfer_5bb59b, w.xfer_5bb59f, w.xfer_5bb5a3, w.mode_583999),
                         (9999, 3, 4, 5, 66, 77, 88, 4))
        rig = Rig(self.lib, [simple_image(action25=2, transfer=transfer)])
        rig.step(0, 2)
        self.assertEqual((rig.world.xfer_5bb57b, rig.world.mode_583999), (0, 0))

    def test_phase2_stops_a_named_sound_first(self):
        rig = Rig(self.lib, [simple_image(sound=b'CLICK', pairs=[(3, 1)])])
        rig.step(0, 2)
        self.assertEqual(rig.log, [('sound_stop', b'CLICK\0\0\0\0')])
        self.assertEqual([e[0] for e in rig.fx][1], 'sound_stop')

    def test_phase2_event_index_outside_array_is_rejected_with_no_write(self):
        rig = Rig(self.lib, [simple_image(pairs=[(3, 1), (500, 1)])], event_count=64)
        before = rig.state()
        status, _, why = rig.step(0, 2)
        self.assertEqual(status, BOUNDS)
        self.assertEqual(rig.state(), before)

    # ---- marker 2 animation ---------------------------------------------

    def anim_image(self, **options):
        defaults = dict(marker=2, first=2, last=5, init=3, fps=15, direction=1, loop=2,
                        primaries=[primary_record(i, 0, i + 9, 9) for i in range(4)],
                        secondaries=[secondary(0, 0, 0, (0, 0, 9, 9), (0, 0, 9, 9))])
        defaults.update(options)
        return simple_image(b'ANIM_OVL', **defaults)

    def test_marker2_registration_initialises_frame_interval_and_deadline(self):
        rig = Rig(self.lib, [self.anim_image()], ticks=[5000])
        rig.step(0, 0)
        image = rig.image(0)
        self.assertEqual(image_s16(image, 0xaae), 3)
        self.assertEqual((image_u32(image, 0xaa6), image_u32(image, 0xaaa)), (66, 5066))
        self.assertIn(('anim_init', 66, 5066), rig.fx)

    def test_marker2_interval_is_truncated_1000_over_fps_in_the_original_float_order(self):
        for fps, interval in ((1, 1000), (8, 125), (25, 40), (30, 33), (3, 333), (1000, 1), (2000, 0), (-1, -1000),
                              (0, 0), (-4, -250)):
            with self.subTest(fps=fps):
                rig = Rig(self.lib, [self.anim_image(fps=fps)], ticks=[10])
                rig.step(0, 0)
                self.assertEqual(struct.unpack('<i', bytes(rig.image(0)[0xaa6:0xaaa]))[0], interval)

    def test_marker2_steps_forward_and_wraps_at_the_deadline_only(self):
        # Clock reads: registration init, registration's own phase-1 pass, then one per visit.
        rig = Rig(self.lib, [self.anim_image(secondaries=[secondary(9), secondary(0), secondary(0)])],
                  selector=0, ticks=[100, 101, 150, 166, 170, 232])
        rig.step(0, 0)                       # next = 100 + 66
        self.assertEqual(image_s16(rig.image(0), 0xaae), 3)
        self.assertEqual(rig.step(0, 1)[1].phase_after, 1)   # now 150 < 166: no step
        self.assertEqual(image_s16(rig.image(0), 0xaae), 3)
        rig.step(0, 1)                       # now 166 >= 166: 3 -> 4, next = 232
        self.assertEqual((image_s16(rig.image(0), 0xaae), image_u32(rig.image(0), 0xaaa)), (4, 232))
        rig.step(0, 1)                       # 170 < 232
        self.assertEqual(image_s16(rig.image(0), 0xaae), 4)
        rig.step(0, 1)                       # 232: 4 -> 5
        self.assertEqual(image_s16(rig.image(0), 0xaae), 5)

    def test_marker2_wrap_modes_forward_and_backward(self):
        for direction, loop, start, expected in ((1, 2, 5, 2), (1, 1, 5, None), (2, 2, 2, 5),
                                                 (2, 1, 2, None), (1, 2, 4, 5), (2, 2, 4, 3)):
            with self.subTest(direction=direction, loop=loop, start=start):
                rig = Rig(self.lib, [self.anim_image(direction=direction, loop=loop, init=start)],
                          ticks=[0, 0, 10000])
                rig.step(0, 0)
                status, result, _ = rig.step(0, 1)
                if expected is None:
                    self.assertEqual(result.phase_after, 2)   # reached the end with loop == 1
                else:
                    self.assertEqual(result.phase_after, 1)
                    self.assertEqual(image_s16(rig.image(0), 0xaae), expected)

    def test_marker2_end_with_a_named_sound_waits_for_the_clip(self):
        image = self.anim_image(direction=1, loop=1, init=5, sound=b'CLICK')
        rig = Rig(self.lib, [image], ticks=[0, 0, 10000], playing=1)
        rig.step(0, 0)
        self.assertEqual(rig.step(0, 1)[1].phase_after, 1)
        self.assertIn(('sound_playing', 8), rig.log)
        rig.playing = 0
        self.assertEqual(rig.step(0, 1)[1].phase_after, 2)

    def test_marker2_only_the_first_selector_matching_record_is_considered(self):
        rig = Rig(self.lib, [self.anim_image(secondaries=[secondary(4), secondary(0), secondary(0)])],
                  selector=0, ticks=[0, 0, 10000])
        rig.step(0, 0)
        rig.step(0, 1)
        self.assertEqual(image_s16(rig.image(0), 0xaae), 4)
        # One step even though two records match.

    def test_marker2_no_matching_record_leaves_the_frame_but_reads_the_clock(self):
        rig = Rig(self.lib, [self.anim_image(secondaries=[secondary(9)])], selector=0, ticks=[0, 777])
        rig.step(0, 0)
        rig.step(0, 1)
        self.assertEqual((image_s16(rig.image(0), 0xaae), rig.manager.tick), (3, 777))

    # ---- hit testing -----------------------------------------------------

    def test_hit_test_is_inclusive_and_needs_selector_hot_flag_and_phase_one(self):
        rig = Rig(self.lib, [None, simple_image()], selector=0)
        rig.step(1, 0)
        for x, y, expected in ((10, 20, 1), (29, 39, 1), (9, 20, 0), (30, 20, 0), (10, 19, 0),
                               (10, 40, 0), (-1, -1, 0)):
            with self.subTest(x=x, y=y):
                status, hit, row, _ = rig.hit(x, y)
                self.assertEqual((status, hit), (OK, expected))
                self.assertEqual(row, 1 if expected else -1)
        rig.world.selector = 1
        self.assertEqual(rig.hit(10, 20)[1], 0)
        rig.world.selector = 0
        rig.phases[1] = 0
        self.assertEqual(rig.hit(10, 20)[1], 0)
        rig.phases[1] = 2
        self.assertEqual(rig.hit(10, 20)[1], 0)

    def test_hit_test_ignores_a_non_hot_record_and_unregistered_overlays(self):
        cold = simple_image(secondaries=[secondary(0, 0, 2, (0, 0, 19, 19), (10, 20, 29, 39))])
        rig = Rig(self.lib, [cold], selector=0)
        self.assertEqual(rig.hit(10, 20)[1], 0)
        rig.step(0, 0)
        self.assertEqual(rig.hit(10, 20)[1], 0)
        self.assertEqual(rig.manager.current_row, 0)

    def test_hit_test_skips_an_overlay_whose_enabled_dword_is_zero(self):
        rig = Rig(self.lib, [simple_image()], selector=0)
        rig.step(0, 0)
        self.assertEqual(rig.hit(15, 25)[1], 1)
        rig.buffers[0][0xab2:0xab6] = bytes(4)
        self.assertEqual(rig.hit(15, 25)[1:3], (0, -1))
        self.assertEqual(rig.hot(0), (OK, []))

    def test_hit_test_prefers_list_order_not_row_order(self):
        both = [simple_image(b'LATE'), simple_image(b'EARLY')]
        rig = Rig(self.lib, both, selector=0)
        rig.step(1, 0)       # registers first
        rig.step(0, 0)
        status, hit, row, _ = rig.hit(15, 25)
        self.assertEqual((hit, row), (1, 1))

    def test_hit_stores_cursor_candidate_and_item_selection(self):
        rig = Rig(self.lib, [simple_image()], selector=0, held=-1)
        rig.step(0, 0)
        rig.hit(15, 25)
        w = rig.world
        self.assertEqual((w.cursor_index, w.cursor_variant, w.cursor_surface, w.cursor_layer,
                          w.candidate), (0, 1, 0x1111, 1, 0))
        self.assertEqual(w.cursor_table, 0x5b160c + (0 << 5) + (1 << 4))
        rig = Rig(self.lib, [simple_image()], selector=0, held=7)
        rig.step(0, 0)
        rig.hit(15, 25)
        self.assertEqual((rig.world.cursor_index, rig.world.cursor_surface), (7 + 0x25, 0x2222))
        rig = Rig(self.lib, [simple_image()], selector=0, held=7)
        rig.world.item_flag_5b44f8 = 1
        rig.world.cursor_index = 99
        rig.step(0, 0)
        rig.hit(15, 25)
        self.assertEqual(rig.world.cursor_index, 99)   # untouched while the flag is set

    def test_hit_with_no_registered_overlay_changes_nothing(self):
        rig = Rig(self.lib, [simple_image()])
        before = rig.state()
        self.assertEqual(rig.hit(15, 25)[:2], (OK, 0))
        self.assertEqual(rig.state(), before)

    def test_hot_rects_follow_the_same_filter_as_the_hit_test(self):
        secs = [secondary(0, 0, 1, (0, 0, 9, 9), (10, 20, 29, 39)),
                secondary(0, 0, 2, (0, 0, 9, 9), (1, 1, 2, 2)),
                secondary(1, 0, 1, (0, 0, 9, 9), (3, 3, 4, 4)),
                secondary(0, 0, 1, (0, 0, 9, 9), (50, 60, 70, 80))]
        rig = Rig(self.lib, [None, simple_image(secondaries=secs)], selector=0)
        rig.step(1, 0)
        self.assertEqual(rig.hot(0), (OK, [(1, 0, 10, 20, 29, 39), (1, 3, 50, 60, 70, 80)]))
        self.assertEqual(rig.hot(1), (OK, [(1, 2, 3, 3, 4, 4)]))
        self.assertEqual(rig.hot(2), (OK, []))
        rig.phases[1] = 0
        self.assertEqual(rig.hot(0), (OK, []))
        self.assertEqual(rig.hit(55, 65)[1:3], (0, -1))
        rig.phases[1] = 1
        self.assertEqual(rig.hit(55, 65)[1:3], (1, 1))

    # ---- drawing ----------------------------------------------------------

    def test_plain_overlay_draws_one_blit_per_matching_record_with_view_offset(self):
        secs = [secondary(0, 0, 1, (1, 2, 11, 12), (10, 20, 29, 39)),
                secondary(5, 0, 1, (0, 0, 1, 1), (0, 0, 1, 1)),
                secondary(0, 1, 0, (0, 0, 3, 3), (40, 41, 43, 44))]
        prims = [primary_record(100, 200, 119, 219), primary_record(300, 400, 319, 419)]
        rig = Rig(self.lib, [simple_image(primaries=prims, secondaries=secs, plain=1)], selector=0)
        rig.step(0, 0)
        rig.log.clear()
        self.assertEqual(rig.draw(24), (OK, b'none'))
        self.assertEqual(rig.log, [
            ('blit', 1, 0, 24, 0x100, (101, 202, 111, 212), (20, 30, 39, 49), b'Overlay AR plain blit'),
            ('blit', 1, 0, 24, 0x100, (300, 400, 303, 403), (50, 51, 53, 54), b'Overlay AR plain blit')])

    def test_transparent_overlay_uses_the_keyed_blit(self):
        rig = Rig(self.lib, [simple_image(plain=2)], selector=0)
        rig.step(0, 0)
        rig.log.clear()
        rig.draw(24)
        self.assertEqual([e[1] for e in rig.log], [2])
        self.assertEqual(rig.log[0][7], b'Overlay AR transparent blit')

    def test_animated_transparent_overlay_restores_the_background_first(self):
        secs = [secondary(0, 0, 0, (0, 0, 9, 9), (10, 20, 19, 29))]
        prims = [primary_record(i * 20, 0, i * 20 + 9, 9) for i in range(4)]
        rig = Rig(self.lib, [self.anim_image(plain=2, secondaries=secs, primaries=prims)],
                  selector=0, ticks=[0])
        rig.step(0, 0)
        rig.log.clear()
        rig.draw(24)
        self.assertEqual(rig.log, [
            ('blit', 1, 0, 24, 0x700, (10, 20, 19, 29), (20, 30, 29, 39),
             b'Overlay AR transparent - restore background'),
            ('blit', 2, 0, 24, 0x100, (60, 0, 69, 9), (20, 30, 29, 39), b'Overlay AR transparent blit')])

    def test_animated_plain_overlay_does_not_restore(self):
        rig = Rig(self.lib, [self.anim_image(plain=1)], selector=0, ticks=[0])
        rig.step(0, 0)
        rig.log.clear()
        rig.draw(24)
        self.assertEqual([e[1] for e in rig.log], [1])

    def test_draw_rejects_mismatched_slot_and_out_of_table_primary_before_blitting(self):
        rig = Rig(self.lib, [simple_image()], selector=0)
        rig.step(0, 0)
        rig.manager.render[30].row = 0
        rig.manager.render[30].active = 1
        rig.manager.render[30].visible = 1
        rig.manager.render[30].callback = 1
        rig.log.clear()
        self.assertEqual(rig.draw(30)[0], BOUNDS)
        self.assertEqual(rig.log, [])
        bad = simple_image(secondaries=[secondary(0, 0, 1, (0, 0, 9, 9), (0, 0, 9, 9)),
                                        secondary(0, 7, 1, (0, 0, 9, 9), (0, 0, 9, 9))])
        rig = Rig(self.lib, [bad], selector=0)
        rig.step(0, 0)
        rig.log.clear()
        status, why = rig.draw(24)
        self.assertEqual((status, rig.log), (BOUNDS, []))
        self.assertIn(b'primary', why)

    def test_draw_without_a_blit_provider_is_unsupported(self):
        rig = Rig(self.lib, [simple_image()], selector=0, providers=False)
        rig.manager.render[24].row = 0
        self.assertEqual(rig.draw(24)[0], UNSUPPORTED)

    def test_render_pass_draws_by_layer_then_slot_for_visible_active_entries_only(self):
        rig = Rig(self.lib, [simple_image(b'A', layer=11), simple_image(b'B', layer=10),
                             simple_image(b'C', layer=10), simple_image(b'D', layer=12)],
                  selector=0)
        for row in range(4):
            rig.step(row, 0)
        rig.manager.render[27].visible = 0         # D is hidden
        rig.log.clear()
        status, drawn, _ = rig.render(0, 15)
        self.assertEqual((status, drawn), (OK, 3))
        self.assertEqual([(e[2], e[3]) for e in rig.log], [(1, 25), (2, 26), (0, 24)])
        rig.log.clear()
        self.assertEqual(rig.render(11, 11)[1], 1)
        self.assertEqual([e[2] for e in rig.log], [0])

    def test_manager_reset_clears_everything(self):
        rig = Rig(self.lib, [simple_image()])
        rig.step(0, 0)
        self.lib.overlay36_manager_reset(c.byref(rig.manager))
        self.assertEqual((rig.manager.count, rig.manager.current_row, rig.manager.render[24].active,
                          rig.manager.render[24].row, rig.manager.cache[0]), (0, -1, 0, -1, 0))


# ---- binding over the real scene executor ---------------------------------

SessionHostLoad = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(World))
SessionHostStore = c.CFUNCTYPE(None, c.c_void_p, c.POINTER(World))
SessionHostTransition = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(session.SceneTransitionRequest))


class BindHost(c.Structure):
    _fields_ = [('kernel', Host), ('load_world', SessionHostLoad), ('store_world', SessionHostStore),
                ('transition', SessionHostTransition)]


class Hotspot(c.Structure):
    _fields_ = [('index', c.c_int32), ('left', c.c_int32), ('top', c.c_int32),
                ('right', c.c_int32), ('bottom', c.c_int32), ('active', c.c_uint32)]


class Fixture:
    """Real scene executor + session + the A36 binding."""

    def __init__(self, test, lib, actions, *, selector=0, event_count=2048, phases_from_session=True,
                 transition=True, tick=5000, binding_types=(0x36,)):
        self.lib = lib
        self.test = test
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.core, self.conditions = session.make_world(event_count)
        self.session = c.c_void_p()
        self.selector = selector
        self.transitions = []
        self.stores = 0
        self.start_flag = None
        self.last_world = None
        self.log = []
        self.loaded = []
        self.next_surface = 0x100

        @LoadFn
        def load(_ctx, name, out):
            self.loaded.append(name)
            out[0] = self.next_surface
            self.next_surface += 1
            return 0

        @TickFn
        def tick_fn(_ctx, out):
            out[0] = tick
            return 0

        @PhaseFn
        def phase(_ctx, row, out):
            state = session.RuntimeState()
            if lib.scene_session_get_action_state(self.session, row, c.byref(state)) != 0:
                return 1
            out[0] = state.phase
            return 0

        @BlitFn
        def blit(_ctx, op):
            o = op[0]
            self.log.append(('blit', o.kind, o.row, tuple(o.src), tuple(o.dst)))
            return 0

        @SessionHostLoad
        def load_world(_ctx, world):
            world[0].events = c.cast(self.flags, c.POINTER(c.c_int32))
            world[0].event_count = len(self.flags)
            world[0].selector = self.selector
            world[0].held_item = -1
            world[0].view_x = 10
            world[0].view_y = 10
            return 0

        @SessionHostStore
        def store_world(_ctx, world):
            self.stores += 1
            self.last_world = bytes(world[0])
            self.start_flag = world[0].start_flag_5bb1ca

        @SessionHostTransition
        def on_transition(_ctx, request):
            self.transitions.append((request[0].target_scene, list(request[0].opaque_words),
                                     list(request[0].opaque_dwords)))
            return self.lib.scene_session_request_transition(self.session, request)

        self.keep = (load, tick_fn, phase, blit, load_world, store_world, on_transition)
        self.host = BindHost(Host(None, load, SoundStartFn(), SoundPlayingFn(), SoundStopFn(), tick_fn,
                                  phase, blit, ObserveFn()), load_world, store_world,
                             on_transition if transition else SessionHostTransition())
        self.binding = lib.session_a36_create(c.byref(self.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a36_begin_scene(self.binding, self.scene), 0)

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a36_handler', lib))
        # RT-18: the same handler also serves raw 0x37 rows (binding_types=(0x36, 0x37)).
        self.bindings = (session.Binding * len(binding_types))(
            *[session.Binding(raw_type, 11, handler, self.binding) for raw_type in binding_types])
        self.config = session.SessionConfig(scene=self.scene, scene_id=6400,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=len(binding_types),
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        self.keep += (prepare, media, handler)
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a36_destroy(self.binding)
        self.lib.scene_resource_close(self.scene)

    def tick(self):
        out = session.SceneSessionTickResult()
        return self.lib.scene_session_tick(self.session, c.byref(out)), out

    def state(self, index=0):
        out = session.RuntimeState()
        assert self.lib.scene_session_get_action_state(self.session, index, c.byref(out)) == 0
        return out.completed, out.phase

    def image(self, row):
        pointer = self.lib.session_a36_image(self.binding, row)
        return bytearray(c.string_at(pointer, IMAGE_BYTES)) if pointer else None

    def priority_rows(self):
        rows, count = (Hotspot * 8)(), c.c_size_t()
        status = self.lib.session_a36_priority_rows(self.binding, rows, 8, c.byref(count))
        return status, [(r.index, r.left, r.top, r.right, r.bottom, r.active)
                        for r in rows[:count.value]]


def body(pre, primaries, secs, deps=()):
    return raw_body(pre, primaries, secs, b''.join(deps))


def overlay_action(image_kwargs=None, subtype=1, deps=(), **kwargs):
    image_kwargs = dict(image_kwargs or {})
    primaries = kwargs.pop('primaries', [primary_record(5, 6, 24, 25)])
    secs = kwargs.pop('secondaries', [secondary(0, 0, 1, (0, 0, 19, 19), (10, 20, 29, 39))])
    pre = prefix(kwargs.pop('name', b'OVL'), primaries=len(primaries), secondaries=len(secs),
                 **kwargs)
    return session.action(0x36, subtype, body(pre, primaries, secs, deps), ())


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = session.load_library(build_library())
        lib = cls.lib
        lib.session_a36_create.argtypes = [c.POINTER(BindHost)]
        lib.session_a36_create.restype = c.c_void_p
        lib.session_a36_destroy.argtypes = [c.c_void_p]
        lib.session_a36_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
        lib.session_a36_begin_scene.restype = c.c_int
        lib.session_a36_handler.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo), c.POINTER(session.RuntimeState),
            c.POINTER(session.HandlerResult)]
        lib.session_a36_handler.restype = c.c_int
        lib.session_a36_failure.argtypes = [c.c_void_p]
        lib.session_a36_failure.restype = c.c_char_p
        lib.session_a36_registered.argtypes = [c.c_void_p]
        lib.session_a36_registered.restype = c.c_size_t
        lib.session_a36_row_name.argtypes = [c.c_void_p, c.c_size_t]
        lib.session_a36_row_name.restype = c.c_char_p
        lib.session_a36_image.argtypes = [c.c_void_p, c.c_size_t]
        lib.session_a36_image.restype = c.c_void_p
        lib.session_a36_priority_rows.argtypes = [c.c_void_p, c.POINTER(Hotspot), c.c_size_t,
                                                  c.POINTER(c.c_size_t)]
        lib.session_a36_priority_rows.restype = c.c_int
        lib.session_a36_hit_test.argtypes = [c.c_void_p, c.c_int16, c.c_int16, c.POINTER(c.c_int),
                                             c.POINTER(c.c_int32)]
        lib.session_a36_hit_test.restype = c.c_int
        lib.session_a36_render.argtypes = [c.c_void_p, c.c_int32, c.c_int32, c.POINTER(c.c_size_t)]
        lib.session_a36_render.restype = c.c_int
        lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t,
                                                 c.POINTER(session.SceneActionInfo)]
        lib.scene_session_request_transition.argtypes = [c.c_void_p,
                                                         c.POINTER(session.SceneTransitionRequest)]
        lib.scene_session_request_transition.restype = c.c_int

    def test_first_tick_registers_and_leaves_the_row_pending_in_phase_one(self):
        f = Fixture(self, self.lib, [overlay_action(name=b'BLU_Key_OVL')])
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'BLU_Key_OVL'])
        self.assertEqual(f.start_flag, 1)
        # Revisited rows never register twice.
        f.tick()
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'BLU_Key_OVL'])

    def test_binding_image_is_the_a36_constructor_image(self):
        pre = prefix(b'IMG_OVL', primaries=2, secondaries=2)
        prims = [primary_record(1, 2, 3, 4), primary_record(5, 6, 7, 8)]
        secs = [secondary(0, 0, 1, (1, 2, 3, 4), (5, 6, 7, 8)), secondary(3, 1, 2)]
        f = Fixture(self, self.lib, [session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0)),
                                     session.action(0x36, 1, raw_body(pre, prims, secs))])
        self.assertIsNone(f.image(0))
        self.assertEqual(f.image(1), make_image(pre, prims, secs))
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 1), b'IMG_OVL')
        self.assertIsNone(self.lib.session_a36_row_name(f.binding, 0))

    def test_dependency_tail_rows_decode(self):
        f = Fixture(self, self.lib, [overlay_action(deps=(session.flag_gate(1),))])
        self.assertIsNotNone(f.image(0))

    def test_false_gate_does_not_register_and_true_gate_does_once(self):
        f = Fixture(self, self.lib, [overlay_action(deps=(session.flag_gate(3),))])
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 0), 0))
        f.flags[3] = 1
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 1), 1))

    def test_event_pair_match_finishes_with_subtype_one_in_the_next_pass(self):
        f = Fixture(self, self.lib, [overlay_action(event=(7, 3), pairs=[(9, 2)])])
        f.tick()
        self.assertEqual((f.state(), f.flags[9]), ((0, 1), 0))
        f.flags[7] = 3
        f.tick()                      # phase 1 -> 2 (the visit returns pending, phase 2)
        self.assertEqual((f.state(), f.flags[9]), ((0, 2), 0))
        f.tick()                      # phase 2 -> finish
        self.assertEqual((f.state(), f.flags[9], f.start_flag), ((1, 0), 2, 1))
        f.tick()
        self.assertEqual(f.state(), (1, 0))   # completed rows are not visited again

    def test_subtype_two_finish_resets_to_phase_zero_and_registers_again(self):
        f = Fixture(self, self.lib, [overlay_action(subtype=2, event=(7, 3))])
        f.tick()
        f.flags[7] = 3
        f.tick()
        f.tick()
        self.assertEqual(f.state(), (0, 0))
        f.flags[7] = 0
        f.tick()
        self.assertEqual(f.state(), (0, 1))
        # The original registers a second time (no unregister): two list entries.
        self.assertEqual(self.lib.session_a36_registered(f.binding), 2)

    def test_accepted_candidate_runs_phase_two_on_the_next_pass(self):
        f = Fixture(self, self.lib, [overlay_action(pairs=[(1000, 1)])], event_count=1100)
        f.tick()
        self.assertEqual(self.lib.scene_session_accept_action_candidate(f.session, 0), 0)
        self.assertEqual(f.state(), (0, 2))
        f.tick()
        self.assertEqual((f.state(), f.flags[1000]), ((1, 0), 1))

    def test_overlay_pair_write_drives_a_later_dependency_gated_row(self):
        gate = session.flag_gate(1000)
        scene_change = session.action(0x0a, 1, session.i16(7) + session.i16(2) + session.i16(0) +
                                      session.i16(0) + session.i32(0) * 3, (gate,))
        f = Fixture(self, self.lib, [overlay_action(name=b'TUT_Next_OVL', pairs=[(1000, 1)]),
                                     scene_change], event_count=1100)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_OK)
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)

    def test_finish_with_action_one_requests_a_scene_change_like_the_0x0a_arm(self):
        later = session.action(0x61, 1, session.i16(5) + session.i16(1) + session.i16(-1) +
                               session.i16(0), (session.flag_gate(2),))
        f = Fixture(self, self.lib, [overlay_action(action25=1, transfer=(42, 3, 4, 5, 66, 77, 88)),
                                     later])
        f.tick()
        f.flags[2] = 1
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.transitions, [(42, [3, 4, 5], [66, 77, 88])])
        # The pass ended with the request: the later (now true) row never ran.
        self.assertEqual(f.flags[5], 0)

    def test_missing_transition_provider_blocks_before_any_effect(self):
        f = Fixture(self, self.lib, [overlay_action(action25=1, transfer=(42, 3, 4, 5, 66, 77, 88),
                                                    pairs=[(9, 1)])], transition=False)
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_type), (session.SESSION_BLOCKED, 0x36))
        self.assertEqual(f.flags[9], 0)
        self.assertEqual(f.state(), (0, 2))
        self.assertIn(b'transition', self.lib.session_a36_failure(f.binding))

    def test_unsupported_sound_provider_blocks_the_row_before_registering(self):
        f = Fixture(self, self.lib, [overlay_action(sound=b'CLICK')])
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (session.SESSION_BLOCKED, 0, 0x36))
        self.assertEqual(result.failure.detail_status, 1)   # handler unsupported
        self.assertIn(b'sound', self.lib.session_a36_failure(f.binding))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 0)

    def test_priority_rows_export_hot_rectangles_only_while_phase_one(self):
        f = Fixture(self, self.lib, [overlay_action(name=b'A'), overlay_action(name=b'B', event=(7, 3)),
                                     session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0))])
        self.assertEqual(f.priority_rows(), (OK, []))
        f.tick()
        self.assertEqual(f.priority_rows(), (OK, [(0, 10, 20, 29, 39, 1), (1, 10, 20, 29, 39, 1)]))
        f.selector = 5
        self.assertEqual(f.priority_rows(), (OK, []))
        f.selector = 0
        f.flags[7] = 3
        f.tick()                       # row 1 reaches phase 2: no longer hit-testable
        self.assertEqual(f.priority_rows(), (OK, [(0, 10, 20, 29, 39, 1)]))

    def test_hit_test_entry_point_and_render_pass(self):
        f = Fixture(self, self.lib, [overlay_action(name=b'A', layer=10)])
        f.tick()
        hit, row = c.c_int(), c.c_int32()
        self.assertEqual(self.lib.session_a36_hit_test(f.binding, 15, 25, c.byref(hit), c.byref(row)), 0)
        self.assertEqual((hit.value, row.value), (1, 0))
        drawn = c.c_size_t()
        self.assertEqual(self.lib.session_a36_render(f.binding, 0, 15, c.byref(drawn)), 0)
        self.assertEqual(drawn.value, 1)
        self.assertEqual(f.log, [('blit', 1, 0, (5, 6, 24, 25), (20, 30, 39, 49))])

    def test_new_scene_resets_the_manager_and_rebuilds_the_images(self):
        f = Fixture(self, self.lib, [overlay_action(name=b'A')])
        f.tick()
        other, owner = session.open_scene(self.lib, [overlay_action(name=b'B'), overlay_action(name=b'C')])
        self.assertEqual(self.lib.session_a36_begin_scene(f.binding, other), 0)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 0)
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 1), b'C')
        self.assertIsNone(self.lib.session_a36_row_name(f.binding, 2))
        self.assertNotEqual(self.lib.session_a36_begin_scene(f.binding, None), 0)
        self.lib.scene_resource_close(other)
        del owner

    def test_handler_rejects_foreign_rows_and_bad_arguments(self):
        f = Fixture(self, self.lib, [session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                                    session.i16(-1) + session.i16(0)),
                                     overlay_action()])
        action = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        for index in (0, 99):
            self.assertEqual(self.lib.session_a36_handler(f.binding, index, c.byref(action),
                              c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))
        self.assertEqual(self.lib.session_a36_handler(None, 1, c.byref(action),
                          c.byref(before), c.byref(out)), 2)

    def test_handler_result_for_each_phase(self):
        f = Fixture(self, self.lib, [overlay_action(pairs=[(3, 1)])])
        action = session.SceneActionInfo()
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        out = session.HandlerResult(123, 456)
        before = session.RuntimeState(0, 0)
        self.assertEqual(self.lib.session_a36_handler(f.binding, 0, c.byref(action), c.byref(before),
                                                      c.byref(out)), 0)
        self.assertEqual((out.disposition, out.phase), (session.HANDLER_PENDING, 1))
        before = session.RuntimeState(0, 2)
        self.assertEqual(self.lib.session_a36_handler(f.binding, 0, c.byref(action), c.byref(before),
                                                      c.byref(out)), 0)
        self.assertEqual((out.disposition, out.phase), (session.HANDLER_COMPLETED, 0))
        before = session.RuntimeState(0, 9)
        self.assertEqual(self.lib.session_a36_handler(f.binding, 0, c.byref(action), c.byref(before),
                                                      c.byref(out)), 0)
        self.assertEqual((out.disposition, out.phase), (session.HANDLER_PENDING, 9))


if __name__ == '__main__':
    unittest.main()
