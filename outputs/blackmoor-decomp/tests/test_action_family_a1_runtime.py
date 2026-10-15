"""RT-21: raw 0xa1 "Sound" object construction, lifecycle (event store) and session binding.

Synthetic fixtures only; the corpus and original-x86 comparisons live in
action_family_a1_runtime_original_oracle.py.
"""
import ctypes as c
import os
from pathlib import Path
import struct
import subprocess
import unittest

import test_action_family_97 as loader
import test_action_family_97_runtime as rt97
import test_action_sound as sound
import session_binding_support as session

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamilya1_runtime.dylib'
MAX_OBJECT = 32767
MISSING_PREFIX = b'Game Error (please contact Tech Support) missing auto text: '


def library_path():
    # Mutation checks supply a separately compiled library; never rebuild it.
    return Path(os.environ.get('AA1_RUNTIME_LIBRARY', LIBRARY))


def build_library():
    if 'AA1_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_a1_runtime.sh')],
                       check=True, capture_output=True)
    return library_path()


def a1_body(name=b'NSHT14', channel=13, control=1, first=85, second=85, mode=0,
            scene=9999, event=-1, event_value=1, key=b'NSHT14', text=None, tails=()):
    """Typed raw-0xa1 body: key form (84 bytes) or inline form (51 + len(text))."""
    selector = -1 if text is None else len(text)
    raw = bytearray(84 if selector == -1 else 51 + len(text))
    raw[:len(name)] = name
    struct.pack_into('<HIhhBhhBh', raw, 0x21, channel, control, first, second, mode,
                     scene, event, event_value, selector)
    if selector == -1:
        raw[51:51 + len(key)] = key
    else:
        raw[51:] = text
    return bytes(raw) + b''.join(tails)


class ObjectResult(c.Structure):
    _fields_ = [('bytes', c.c_uint8 * MAX_OBJECT), ('length', c.c_size_t),
                ('key_missing', c.c_uint8)]


class EventTable(c.Structure):
    _fields_ = [('flags', c.POINTER(c.c_int32)), ('count', c.c_size_t)]


class StepResult(c.Structure):
    _fields_ = [('visit', rt97.Result), ('event_stored', c.c_uint8),
                ('event_id', c.c_int16), ('event_value', c.c_int32),
                ('event_previous', c.c_int32)]


def bind():
    lib = session.load_library(build_library())
    lib.action_a1_runtime_construct.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
        loader.LOOKUP, c.c_void_p, c.POINTER(ObjectResult)]
    lib.action_a1_runtime_construct.restype = c.c_int
    lib.action_sound_object_step.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
        c.POINTER(rt97.Input), c.POINTER(sound.Backend), c.POINTER(EventTable),
        c.POINTER(StepResult), c.POINTER(c.c_char_p)]
    lib.action_sound_object_step.restype = c.c_int
    lib.session_aa1_create.argtypes = [c.POINTER(Host)]
    lib.session_aa1_create.restype = c.c_void_p
    lib.session_aa1_destroy.argtypes = [c.c_void_p]
    lib.session_aa1_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
    lib.session_aa1_handler.argtypes = [c.c_void_p, c.c_size_t,
        c.POINTER(session.SceneActionInfo), c.POINTER(session.RuntimeState),
        c.POINTER(session.HandlerResult)]
    lib.session_aa1_failure.argtypes = [c.c_void_p]
    lib.session_aa1_failure.restype = c.c_char_p
    lib.session_aa1_row.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(RowInfo)]
    lib.session_aa1_row.restype = c.c_int
    lib.scene_session_request_transition.argtypes = [c.c_void_p,
        c.POINTER(session.SceneTransitionRequest)]
    lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t,
        c.POINTER(session.SceneActionInfo)]
    lib.scene_session_get_pending_transition.argtypes = [c.c_void_p,
        c.POINTER(session.SceneTransitionRequest)]
    return lib


def construct(lib, raw, lookup=None):
    out = ObjectResult()
    status = lib.action_a1_runtime_construct(loader.buffer(raw), len(raw),
        lookup.callback if lookup else loader.LOOKUP(), None, c.byref(out))
    return status, out


def make_object(test, lib, raw=None, lookup=None):
    status, out = construct(lib, raw if raw is not None else a1_body(), lookup)
    test.assertEqual(status, 0)
    return loader.buffer(bytes(out.bytes[:out.length])), out


def step(lib, payload, phase=0, subtype=1, completed=0, captions=1, recorder=None, table=None):
    recorder = recorder or rt97.Recorder()
    inp, out, failure = rt97.Input(phase, subtype, completed, captions), StepResult(), c.c_char_p()
    status = lib.action_sound_object_step(payload, len(payload), c.byref(inp),
        c.byref(recorder.backend), c.byref(table) if table is not None else None,
        c.byref(out), c.byref(failure))
    return status, out, failure.value, recorder


class Events:
    """An event table plus the ordered recorder log, one merged timeline."""
    def __init__(self, count=2300):
        self.flags = (c.c_int32 * count)()
        self.table = EventTable(c.cast(self.flags, c.POINTER(c.c_int32)), count)


class ConstructTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    def test_key_form_resolves_autotext_once_and_appends_marker(self):
        lookup = loader.DictionaryLookup({b'nsht14': b'Hello there'})
        status, out = construct(self.lib, a1_body(), lookup)
        self.assertEqual((status, out.key_missing), (0, 0))
        self.assertEqual(lookup.calls, [b'NSHT14'])
        self.assertEqual(out.length, 176 + len(b'Hello there'))
        self.assertEqual(bytes(out.bytes[0xac:0xac + 14]), b'Hello there<e>')
        self.assertEqual(struct.unpack_from('<H', bytes(out.bytes), 0xaa)[0], 14)

    def test_event_fields_land_at_a5_and_a7(self):
        status, out = construct(self.lib, a1_body(event=1747, event_value=1, scene=6409),
                                loader.DictionaryLookup({b'NSHT14': b'x'}))
        self.assertEqual(status, 0)
        obj = bytes(out.bytes)
        self.assertEqual(struct.unpack_from('<hB', obj, 0xa5)[0], 1747)
        self.assertEqual(obj[0xa7], 1)
        self.assertEqual(struct.unpack_from('<h', obj, 0x91)[0], 6409)
        # Constructor defaults shared with the 0x9f/0x97 object (0x410f99).
        self.assertEqual((struct.unpack_from('<H', obj, 0x97)[0], struct.unpack_from('<H', obj, 0xa8)[0]), (1, 2))

    def test_inline_form_needs_no_lookup(self):
        lookup = loader.DictionaryLookup()
        status, out = construct(self.lib, a1_body(text=b'inline words'), lookup)
        self.assertEqual((status, out.length, lookup.calls), (0, 175 + 12, []))
        self.assertEqual(bytes(out.bytes[0xac:0xac + 15]), b'inline words<e>')

    def test_empty_inline_text_has_no_marker_and_zero_count(self):
        status, out = construct(self.lib, a1_body(text=b''))
        self.assertEqual((status, out.length), (0, 175))
        self.assertEqual(struct.unpack_from('<H', bytes(out.bytes), 0xaa)[0], 0)

    def test_missing_key_uses_the_original_game_error_text(self):
        lookup = loader.DictionaryLookup()
        status, out = construct(self.lib, a1_body(key=b'NOPE_KEY'), lookup)
        self.assertEqual((status, out.key_missing), (0, 1))
        expected = MISSING_PREFIX + b'NOPE_KEY' + b'<n>'
        self.assertEqual(bytes(out.bytes[0xac:0xac + len(expected) + 3]), expected + b'<e>')
        self.assertEqual(out.length, 176 + len(expected))

    def test_failed_or_absent_lookup_is_a_named_status_and_leaves_output_alone(self):
        for lookup in (loader.DictionaryLookup(status=2), None):
            out = ObjectResult()
            c.memset(c.byref(out), 0xa5, c.sizeof(out))
            before = bytes(out)
            status = self.lib.action_a1_runtime_construct(loader.buffer(a1_body()), 84,
                lookup.callback if lookup else loader.LOOKUP(), None, c.byref(out))
            self.assertEqual(status, 3)    # lookup unavailable
            self.assertEqual(bytes(out), before)

    def test_malformed_bodies_are_rejected_without_writes(self):
        for raw in (b'', bytes(50), a1_body()[:83], a1_body(name=b'x' * 33),
                    a1_body(text=b'abc')[:-1]):
            out = ObjectResult()
            c.memset(c.byref(out), 0x5a, c.sizeof(out))
            before = bytes(out)
            status = self.lib.action_a1_runtime_construct(loader.buffer(raw), len(raw),
                loader.DictionaryLookup({b'NSHT14': b'x'}).callback, None, c.byref(out))
            self.assertNotEqual(status, 0)
            self.assertEqual(bytes(out), before)


class StepTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        build_library()
        cls.lib = bind()

    lookup_rows = {b'NSHT14': b'caption', b'NSHT': b'caption'}

    def obj(self, **kw):
        return make_object(self.test_state_dummy, self.lib,
                           a1_body(**kw), loader.DictionaryLookup(self.lookup_rows))[0]

    def setUp(self):
        self.test_state_dummy = self

    def test_event_store_sits_between_caption_and_load_and_the_object_is_not_modified(self):
        p = self.obj(event=1747, event_value=1)
        ev = Events()
        ev.flags[1747] = 9
        r = rt97.Recorder()
        before = bytes(p)
        status, out, _, _ = step(self.lib, p, 0, recorder=r, table=ev.table)
        self.assertEqual(status, 0)
        self.assertEqual((out.event_stored, out.event_id, out.event_value, out.event_previous),
                         (1, 1747, 1, 9))
        self.assertEqual(ev.flags[1747], 1)
        self.assertEqual(r.events, [('caption', b'caption<e>'), ('load', 13), ('play', 13)])
        self.assertEqual((out.visit.phase, out.visit.completed, out.visit.direct), (1, 0, 0))
        self.assertEqual(bytes(p), before)

    def test_event_is_stored_when_the_caption_is_disabled_and_value_zero_clears(self):
        p = self.obj(event=1155, event_value=0)
        ev = Events()
        ev.flags[1155] = 1
        r = rt97.Recorder()
        r.backend.present_caption = sound.PresentFn()    # not needed with captions off
        status, out, _, _ = step(self.lib, p, 0, captions=0, recorder=r, table=ev.table)
        self.assertEqual(status, 0)
        self.assertEqual(ev.flags[1155], 0)
        self.assertEqual(r.events, [('load', 13), ('play', 13)])

    def test_event_minus_one_stores_nothing_and_needs_no_table(self):
        p = self.obj(event=-1)
        status, out, _, _ = step(self.lib, p, 0, table=None)
        self.assertEqual((status, out.event_stored, out.visit.phase), (0, 0, 1))

    def test_direct_completion_needs_scene_9999_event_minus_one_and_control_zero(self):
        for kw, direct in (
                (dict(control=0, scene=9999, event=-1), 1),
                (dict(control=0, scene=9999, event=1000), 0),     # 0x433502: event != -1
                (dict(control=0, scene=42, event=-1), 0),
                (dict(control=1, scene=9999, event=-1), 0),
                (dict(control=0, scene=9999, event=0), 0)):       # event 0 is a real id
            with self.subTest(**kw):
                p = self.obj(**kw)
                ev = Events()
                status, out, _, _ = step(self.lib, p, 0, table=ev.table)
                self.assertEqual(status, 0)
                self.assertEqual((out.visit.direct, out.visit.completed, out.visit.phase),
                                 (direct, direct, 0 if direct else 1))
                self.assertEqual(out.event_stored, int(kw['event'] != -1))

    def test_event_table_missing_or_too_small_is_checked_before_any_effect(self):
        p = self.obj(event=1747)
        for table in (None, Events(1747).table, Events(0).table):
            r = rt97.Recorder()
            status, out, why, _ = step(self.lib, p, 0, completed=1, recorder=r, table=table)
            self.assertEqual(status, sound.ERR_UNSUPPORTED)
            self.assertIn(b'event', why)
            self.assertEqual((out.visit.phase, out.visit.completed, out.event_stored), (0, 1, 0))
            self.assertEqual(r.events, [])
        # Phases 1 and 2 never touch the table.
        for phase in (1, 2):
            self.assertEqual(step(self.lib, p, phase, table=None)[0], 0)

    def test_negative_event_id_other_than_minus_one_is_rejected(self):
        p = self.obj(event=-2)
        ev = Events()
        r = rt97.Recorder()
        status, _, why, _ = step(self.lib, p, 0, recorder=r, table=ev.table)
        self.assertEqual(status, sound.ERR_UNSUPPORTED)
        self.assertIn(b'event', why)
        self.assertEqual((r.events, list(ev.flags[:4])), ([], [0, 0, 0, 0]))

    def test_event_survives_a_load_failure_and_a_caption_failure_precedes_it(self):
        p = self.obj(event=1000)
        for field, status_value, stored, events in (
                ('load', sound.BACKEND_ERROR, 1, [('caption', b'caption<e>'), ('load', 13)]),
                ('caption', sound.BACKEND_ERROR, 0, [('caption', b'caption<e>')])):
            ev = Events()
            r = rt97.Recorder()
            setattr(r, field + '_result', status_value)
            status, out, _, _ = step(self.lib, p, 0, recorder=r, table=ev.table)
            self.assertEqual(status, sound.ERR_BACKEND)
            self.assertEqual(ev.flags[1000], stored)
            self.assertEqual(r.events, events)

    def test_load_no_resource_still_stores_the_event_and_advances_without_play(self):
        p = self.obj(event=1000)
        ev = Events()
        r = rt97.Recorder()
        r.load_result = sound.BACKEND_NO_RESOURCE
        status, out, _, _ = step(self.lib, p, 0, recorder=r, table=ev.table)
        self.assertEqual((status, out.visit.phase, ev.flags[1000], r.plays), (0, 1, 1, []))

    def test_phase_one_and_two_match_the_raw_97_lifecycle_and_never_store(self):
        p = self.obj(event=1747, scene=6409)
        ev = Events()
        r = rt97.Recorder()
        r.still_playing = 0
        for phase, expected in ((1, (2, 0, 0)), (2, (0, 1, 1))):
            status, out, _, _ = step(self.lib, p, phase, recorder=r, table=ev.table)
            self.assertEqual(status, 0)
            self.assertEqual((out.visit.phase, out.visit.completed, out.visit.finish), expected)
            self.assertEqual(out.event_stored, 0)
        self.assertEqual(ev.flags[1747], 0)
        self.assertEqual(r.events, [('query', 13), ('unload', 13)])

    def test_transition_tuple_is_the_constructor_default_and_follows_unload_order(self):
        p = self.obj(event=1000, scene=6409)
        status, out, _, r = step(self.lib, p, 2, completed=0)
        self.assertEqual(status, 0)
        v = out.visit
        self.assertEqual((v.transition, v.request.target_scene, list(v.request.opaque_words),
                          list(v.request.opaque_dwords)), (1, 6409, [0, 0, 1], [0, 0, 0]))
        self.assertEqual((v.request.scene_flag_value, v.request.engine_state_value), (1, 4))
        self.assertEqual(r.events, [('unload', 13)])

    def test_subtype_two_resets_dependencies_on_finish(self):
        p = self.obj()
        status, out, _, _ = step(self.lib, p, 2, subtype=2, completed=1)
        self.assertEqual((status, out.visit.completed, out.visit.reset, out.visit.finish), (0, 0, 1, 1))

    def test_raw_97_wrapper_still_refuses_a_non_default_event(self):
        # RT-8's entry point is unchanged: its constructor can only produce event -1.
        p = self.obj(event=1000)
        inp, out, failure = rt97.Input(0, 1, 0, 1), rt97.Result(), c.c_char_p()
        self.lib.action97_runtime_step.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
            c.POINTER(rt97.Input), c.POINTER(sound.Backend), c.POINTER(rt97.Result),
            c.POINTER(c.c_char_p)]
        status = self.lib.action97_runtime_step(p, len(p), c.byref(inp),
            c.byref(rt97.Recorder().backend), c.byref(out), c.byref(failure))
        self.assertEqual(status, sound.ERR_UNSUPPORTED)
        self.assertIn(b'event', failure.value)


CaptionConfigFn = rt97.CaptionConfigFn
TransitionFn = rt97.TransitionFn
LoadEventsFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(EventTable))
EventStoredFn = c.CFUNCTYPE(None, c.c_void_p, c.c_size_t, c.c_int16, c.c_int32, c.c_int32)


class Host(c.Structure):
    _fields_ = [('sound', sound.Backend), ('lookup', loader.LOOKUP),
                ('lookup_context', c.c_void_p), ('captions_enabled', CaptionConfigFn),
                ('transition', TransitionFn), ('load_events', LoadEventsFn),
                ('event_stored', EventStoredFn)]


class RowInfo(c.Structure):
    _fields_ = [('present', c.c_uint8), ('stem', c.c_char * 34), ('channel', c.c_uint16),
                ('event_id', c.c_int16), ('event_value', c.c_uint8),
                ('transition_scene', c.c_int16), ('mode', c.c_uint8),
                ('key_missing', c.c_uint8)]


class Fixture:
    def __init__(self, test, lib, actions, *, lookup=None, captions=1, config_status=0,
                 transition=True, transition_result=None, events=True, event_count=16,
                 observe=True, recorder=None):
        self.lib = lib
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.world, self.conditions = session.make_world()
        self.recorder, self.transitions, self.observed = recorder or rt97.Recorder(), [], []
        self.ev = Events(event_count)
        self.config_calls = 0
        self.session = c.c_void_p()

        @CaptionConfigFn
        def config(_ctx, value):
            self.config_calls += 1
            value[0] = captions if captions is not None else 0
            return config_status

        @TransitionFn
        def change(_ctx, effect):
            e = effect.contents
            self.transitions.append((e.target_scene, list(e.opaque_words), list(e.opaque_dwords)))
            if transition_result is not None:
                return transition_result
            request = session.SceneTransitionRequest()
            request.target_scene = e.target_scene
            request.opaque_words[:] = e.opaque_words[:]
            request.opaque_dwords[:] = e.opaque_dwords[:]
            return lib.scene_session_request_transition(self.session, c.byref(request))

        @LoadEventsFn
        def load_events(_ctx, out):
            out[0] = self.ev.table
            return 0

        @EventStoredFn
        def stored(_ctx, row, event_id, value, previous):
            self.observed.append((row, event_id, value, previous))

        self.host = Host(self.recorder.backend, lookup.callback if lookup else loader.LOOKUP(),
                         None, config if captions is not None else CaptionConfigFn(),
                         change if transition else TransitionFn(),
                         load_events if events else LoadEventsFn(),
                         stored if observe else EventStoredFn())
        self.binding = lib.session_aa1_create(c.byref(self.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_aa1_begin_scene(self.binding, self.scene), 0)

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_aa1_handler', lib))
        self.bindings = (session.Binding * 1)(session.Binding(0xa1, 7, handler, self.binding))
        self.session_config = session.SessionConfig(scene=self.scene, scene_id=6408,
            action_core_world=c.pointer(self.world), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.session_config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        self.keep = [config, change, prepare, media, handler, lookup, load_events, stored]
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_aa1_destroy(self.binding)
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
        build_library()
        cls.lib = bind()

    rows = {b'NSHT14': b'caption'}

    def lookup(self):
        return loader.DictionaryLookup(self.rows)

    def fixture(self, subtype=1, deps=b'', raw=None, **options):
        options.setdefault('lookup', self.lookup())
        return Fixture(self, self.lib, [session.action(
            0xa1, subtype, raw if raw is not None else a1_body(scene=6409, event=3),
            (deps,) if deps else ())], **options)

    def test_full_lifecycle_stores_the_event_once_and_requests_the_transition(self):
        f = self.fixture()
        f.recorder.still_playing = 1
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual((f.ev.flags[3], f.observed), (1, [(0, 3, 1, 0)]))
        self.assertEqual(f.recorder.events, [('caption', b'caption<e>'), ('load', 13), ('play', 13)])
        self.assertEqual(f.tick()[0], 0)                          # still playing
        self.assertEqual((f.state(), f.recorder.queries), ((0, 1), [13]))
        f.recorder.still_playing = 0
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 2))
        status, _ = f.tick()
        self.assertEqual(status, 1)                                # SESSION_TRANSITION
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(f.transitions, [(6409, [0, 0, 1], [0, 0, 0])])
        self.assertEqual(f.recorder.unloads, [13])
        self.assertEqual(f.observed, [(0, 3, 1, 0)])               # exactly one store

    def test_autotext_is_resolved_at_scene_construction_not_per_visit(self):
        lookup = self.lookup()
        f = self.fixture(lookup=lookup, deps=session.flag_gate(5))
        self.assertEqual(lookup.calls, [b'NSHT14'])                # before any gate is evaluated
        f.tick(); f.flags[5] = 1
        f.tick(); f.tick()
        self.assertEqual(lookup.calls, [b'NSHT14'])
        self.assertEqual(self.lib.session_aa1_begin_scene(f.binding, f.scene), 0)
        self.assertEqual(lookup.calls, [b'NSHT14', b'NSHT14'])      # a scene reload resolves again

    def test_row_info_reports_the_constructed_fields(self):
        f = self.fixture()
        info = RowInfo()
        self.assertEqual(self.lib.session_aa1_row(f.binding, 0, c.byref(info)), 1)
        self.assertEqual((info.stem, info.channel, info.event_id, info.event_value,
                          info.transition_scene, info.mode, info.key_missing),
                         (b'NSHT14', 13, 3, 1, 6409, 0, 0))
        self.assertEqual(self.lib.session_aa1_row(f.binding, 5, c.byref(info)), 0)

    def test_missing_key_row_is_built_with_the_game_error_caption(self):
        f = self.fixture(lookup=loader.DictionaryLookup(), raw=a1_body(key=b'GONE', scene=9999, event=-1))
        info = RowInfo()
        self.assertEqual(self.lib.session_aa1_row(f.binding, 0, c.byref(info)), 1)
        self.assertEqual(info.key_missing, 1)
        f.tick()
        self.assertEqual(f.recorder.captions, [(0, MISSING_PREFIX + b'GONE<n><e>', b'')])

    def test_event_id_zero_is_a_real_flag_not_a_sentinel(self):
        f = self.fixture(raw=a1_body(scene=9999, event=0, event_value=1, control=0))
        f.tick()
        self.assertEqual((f.ev.flags[0], f.state()), (1, (0, 1)))   # event != -1: no direct completion

    def test_direct_completion_without_event_completes_in_one_visit(self):
        f = self.fixture(raw=a1_body(scene=9999, event=-1, control=0))
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(f.recorder.unloads, [])

    def test_false_gate_subtype_two_clears_phase_and_completion_subtype_one_keeps_them(self):
        for subtype, expected in ((2, (0, 0)), (1, (0, 1))):
            with self.subTest(subtype=subtype):
                f = self.fixture(subtype=subtype, deps=session.flag_gate(5))
                f.flags[5] = 1
                f.tick()
                self.assertEqual(f.state(), (0, 1))
                f.flags[5] = 0
                f.tick()
                self.assertEqual(f.state(), expected)

    def test_subtype_two_finish_rearms_and_stores_the_event_again(self):
        f = self.fixture(subtype=2, raw=a1_body(scene=9999, event=3, event_value=1))
        f.recorder.still_playing = 0
        for expected in ((0, 1), (0, 2), (0, 0), (0, 1)):
            self.assertEqual(f.tick()[0], 0)
            self.assertEqual(f.state(), expected)
        self.assertEqual([o[:3] for o in f.observed], [(0, 3, 1), (0, 3, 1)])

    def test_key_row_without_a_lookup_provider_is_a_named_blocker_inline_rows_still_run(self):
        f = Fixture(self, self.lib, [session.action(0xa1, 1, a1_body(scene=9999, event=-1)),
                                    session.action(0xa1, 1, a1_body(text=b'hi', scene=9999, event=-1))])
        status, result = f.tick()
        self.assertEqual((status, result.failure.provider, result.failure.action_index), (2, 7, 0))
        self.assertIn(b'AUTOTEXT', self.lib.session_aa1_failure(f.binding))
        self.assertEqual(f.recorder.events, [])
        info = RowInfo()
        self.assertEqual(self.lib.session_aa1_row(f.binding, 1, c.byref(info)), 1)

    def test_failing_lookup_provider_is_a_named_blocker(self):
        f = self.fixture(lookup=loader.DictionaryLookup(status=2))
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_BLOCKED)
        self.assertIn(b'AUTOTEXT', self.lib.session_aa1_failure(f.binding))

    def test_missing_event_provider_or_range_blocks_before_effects_and_keeps_state(self):
        for options in ({'events': False}, {'event_count': 3}):
            with self.subTest(options=options):
                f = self.fixture(**options)
                status, result = f.tick()
                self.assertEqual((status, result.failure.detail_status), (session.SESSION_BLOCKED, 1))
                self.assertEqual(f.state(), (0, 0))
                self.assertEqual((f.recorder.events, f.observed), ([], []))
                self.assertIn(b'event', self.lib.session_aa1_failure(f.binding))

    def test_event_less_row_does_not_need_the_event_provider(self):
        f = self.fixture(events=False, raw=a1_body(scene=9999, event=-1))
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 1))

    def test_missing_or_failing_caption_config_preserves_state(self):
        for options in ({'captions': None}, {'config_status': 1}):
            with self.subTest(options=options):
                f = self.fixture(**options)
                status, result = f.tick()
                self.assertEqual((status, result.failure.detail_status), (session.SESSION_BLOCKED, 1))
                self.assertEqual((f.state(), f.recorder.events, f.observed), ((0, 0), [], []))
                self.assertIn(b'caption configuration', self.lib.session_aa1_failure(f.binding))

    def test_disabled_captions_still_store_and_play(self):
        r = rt97.Recorder()
        r.backend.present_caption = sound.PresentFn()
        f = self.fixture(captions=0, recorder=r)
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual((f.ev.flags[3], r.events), (1, [('load', 13), ('play', 13)]))

    def test_missing_transition_provider_is_checked_before_unload(self):
        f = self.fixture(transition=False)
        f.recorder.still_playing = 0
        f.tick(); f.tick()
        self.assertEqual(f.tick()[0], 2)
        self.assertEqual(f.recorder.unloads, [])
        self.assertIn(b'transition provider', self.lib.session_aa1_failure(f.binding))

    def test_transition_rejection_keeps_the_action_state_and_unload_has_happened(self):
        for rejection in (1, -1):
            with self.subTest(rejection=rejection):
                f = self.fixture(transition_result=rejection)
                f.recorder.still_playing = 0
                f.tick(); f.tick()
                status, result = f.tick()
                self.assertEqual((status, result.failure.detail_status), (5, 2))
                self.assertEqual(f.state(), (0, 2))
                self.assertEqual(f.recorder.unloads, [13])
                self.assertIn(b'transition rejected', self.lib.session_aa1_failure(f.binding))

    def test_backend_failures_do_not_commit_session_state(self):
        for field, phase in (('caption', 0), ('load', 0), ('play', 0), ('query', 1), ('unload', 2)):
            for backend_status, handler_status in ((sound.BACKEND_UNSUPPORTED, 1),
                                                   (sound.BACKEND_ERROR, 2)):
                with self.subTest(field=field, backend_status=backend_status):
                    f = self.fixture()
                    f.recorder.still_playing = 0
                    for _ in range(phase):
                        self.assertEqual(f.tick()[0], 0)
                    setattr(f.recorder, field + '_result', backend_status)
                    status, result = f.tick()
                    self.assertEqual(status, session.SESSION_BLOCKED if handler_status == 1 else 5)
                    self.assertEqual(f.state(), (0, phase))
                    self.assertEqual(f.transitions, [])
                    self.assertIn(field.encode(), self.lib.session_aa1_failure(f.binding))

    def test_other_types_and_out_of_range_rows_are_rejected_by_the_handler(self):
        f = self.fixture()
        action = session.SceneActionInfo()
        self.assertEqual(self.lib.scene_resource_action_at(f.scene, 0, c.byref(action)), 0)
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        self.assertEqual(self.lib.session_aa1_handler(f.binding, 9, c.byref(action),
                         c.byref(before), c.byref(out)), 2)
        action.type = 0x97
        self.assertEqual(self.lib.session_aa1_handler(f.binding, 0, c.byref(action),
                         c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))


if __name__ == '__main__':
    unittest.main()
