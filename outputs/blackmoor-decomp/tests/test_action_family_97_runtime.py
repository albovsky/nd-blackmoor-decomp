"""RT-8: selected raw-97 allocation, lifecycle and session binding contracts."""
import ctypes as c
from pathlib import Path
import struct
import subprocess
import unittest

import test_action_family_97 as loader
import test_action_sound as sound
import session_binding_support as session

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = PROJECT / 'build/libactionfamily97_runtime.dylib'


class Input(c.Structure):
    _fields_ = [('phase', c.c_uint32), ('subtype', c.c_uint8),
                ('completed', c.c_uint8), ('captions', c.c_uint8)]


class Result(c.Structure):
    _fields_ = [('phase', c.c_uint32), ('completed', c.c_uint8),
                ('direct', c.c_uint8), ('finish', c.c_uint8),
                ('reset', c.c_uint8), ('transition', c.c_uint8),
                ('request', sound.Transition)]


def bind():
    lib = loader.bind(LIBRARY)
    lib.action97_runtime_step.argtypes = [c.POINTER(c.c_uint8), c.c_size_t,
        c.POINTER(Input), c.POINTER(sound.Backend), c.POINTER(Result),
        c.POINTER(c.c_char_p)]
    lib.action97_runtime_step.restype = c.c_int
    return lib


def construct(lib, raw=None, seed=1, lookup=None):
    raw = raw if raw is not None else loader.body(words=(13, 1, 75, 75, 0, 9999))
    src, out, payload = loader.buffer(raw), loader.Constructed(), (c.c_uint8 * 32767)()
    status = lib.action_family_97_construct(src, len(raw), seed, 50,
        lookup.callback if lookup else loader.LOOKUP(), None, payload, len(payload), c.byref(out))
    if status != 0:
        raise AssertionError(('constructor', status))
    return loader.buffer(bytes(payload[:out.allocation_bytes])), out


def step(lib, payload, phase=0, subtype=1, completed=0, captions=1, recorder=None):
    recorder = recorder or sound.Recorder()
    inp, out, failure = Input(phase, subtype, completed, captions), Result(), c.c_char_p()
    status = lib.action97_runtime_step(payload, len(payload), c.byref(inp),
        c.byref(recorder.backend), c.byref(out), c.byref(failure))
    return status, out, failure.value, recorder


class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_97_runtime.sh')],
                       check=True, capture_output=True)
        cls.lib = bind()

    def test_wait_finish_and_no_reselection(self):
        p, selected = construct(self.lib, loader.body((b'one', b'two'), (b'', b''),
                                  words=(13, 1, 75, 75, 0, 9999)))
        before = bytes(p)
        r = sound.Recorder()
        for phase, playing, expected in [(0, 1, (1, 0, 0)), (1, 1, (1, 0, 0)),
                                         (1, 0, (2, 0, 0)), (2, 0, (0, 1, 1))]:
            r.still_playing = playing
            status, out, _, _ = step(self.lib, p, phase, recorder=r)
            self.assertEqual(status, 0)
            self.assertEqual((out.phase, out.completed, out.finish), expected)
        self.assertEqual(bytes(p), before)
        self.assertEqual(r.plays, [13])
        self.assertEqual(r.unloads, [13])
        self.assertEqual(r.commands[0][0], (b'one', b'two')[selected.selected_index])

    def test_direct_completion_control_zero_for_every_subtype(self):
        p, _ = construct(self.lib, loader.body(words=(12, 0, 100, 100, 0, 9999)))
        for subtype in (0, 1, 2, 3, 255):
            status, out, _, r = step(self.lib, p, subtype=subtype)
            self.assertEqual((status, out.phase, out.completed, out.direct, out.finish),
                             (0, 0, 1, 1, 0))
            self.assertEqual(r.unloads, [])

    def test_caption_uses_already_resolved_text_and_one_marker(self):
        lookup = loader.DictionaryLookup({b'KEY': b'caption'})
        p, _ = construct(self.lib, loader.body(entries=((b'KEY',),),
                              words=(13, 1, 100, 100, 0, 9999)), lookup=lookup)
        status, _, _, r = step(self.lib, p)
        self.assertEqual(status, 0)
        self.assertEqual(r.captions, [(0, b'caption<e>', b'')])
        self.assertEqual(r.keys, [])
        self.assertEqual(lookup.calls, [b'KEY'])

    def test_inline_nul_and_empty_autotext(self):
        for raw, lookup, expected in [
            (loader.body(entries=(b'a\0b',), words=(13, 1, 100, 100, 0, 9999)), None, b'a'),
            (loader.body(entries=((b'K',),), words=(13, 1, 100, 100, 0, 9999)),
             loader.DictionaryLookup({b'K': b''}), b'<e>')]:
            p, _ = construct(self.lib, raw, lookup=lookup)
            self.assertEqual(step(self.lib, p)[3].captions, [(0, expected, b'')])

    def test_missing_caption_or_audio_callback_preflights_before_effects(self):
        p, _ = construct(self.lib, loader.body(entries=(b'text',), words=(13, 1, 75, 75, 0, 9999)))
        for field, empty in [('play_sound', sound.ChannelFn()), ('load_sound', sound.LoadFn()),
                             ('present_caption', sound.PresentFn())]:
            r = sound.Recorder()
            setattr(r.backend, field, empty)
            status, _, why, _ = step(self.lib, p, recorder=r)
            self.assertEqual(status, 3)
            self.assertTrue(why)
            self.assertEqual((r.captions, r.commands, r.plays), ([], [], []))

    def test_disabled_captions_do_not_need_writer(self):
        p, _ = construct(self.lib, loader.body(entries=(b'text',), words=(13, 1, 75, 75, 0, 9999)))
        r = sound.Recorder()
        r.backend.present_caption = sound.PresentFn()
        self.assertEqual(step(self.lib, p, captions=0, recorder=r)[0], 0)

    def test_mode_one_bypasses_query_and_unload(self):
        p, _ = construct(self.lib, loader.body(words=(13, 1, 75, 75, 1, 9999)))
        r = sound.Recorder()
        r.backend.is_playing, r.backend.unload_sound = sound.QueryFn(), sound.ChannelFn()
        self.assertEqual(step(self.lib, p, 1, recorder=r)[1].phase, 2)
        self.assertEqual(step(self.lib, p, 2, recorder=r)[1].finish, 1)

    def test_finish_subtypes_and_transition_defaults(self):
        p, _ = construct(self.lib, loader.body(words=(13, 1, 75, 75, 0, 42)))
        for subtype, completed, reset in [(1, 1, 0), (2, 0, 1), (0, 1, 0), (3, 1, 0)]:
            status, out, _, _ = step(self.lib, p, 2, subtype, completed=1)
            self.assertEqual((status, out.phase, out.completed, out.finish, out.reset),
                             (0, 0, completed, 1, reset))
            self.assertEqual((out.transition, out.request.target_scene,
                              list(out.request.opaque_words), list(out.request.opaque_dwords)),
                             (1, 42, [0, 0, 1], [0, 0, 0]))
            self.assertEqual((out.request.scene_flag_value, out.request.engine_state_value), (1, 4))

    def test_load_failure_skips_play_and_advances(self):
        p, _ = construct(self.lib)
        r = sound.Recorder()
        r.load_result = sound.BACKEND_NO_RESOURCE
        status, out, _, _ = step(self.lib, p, recorder=r)
        self.assertEqual((status, out.phase, r.plays), (0, 1, []))

    def test_unknown_phase_has_no_effect(self):
        p, _ = construct(self.lib)
        status, out, _, r = step(self.lib, p, 99, completed=1)
        self.assertEqual((status, out.phase, out.completed), (0, 99, 1))
        self.assertEqual((r.commands, r.queries, r.unloads), ([], [], []))

    def test_bad_payload_and_channel_are_rejected(self):
        p, _ = construct(self.lib)
        self.assertEqual(step(self.lib, loader.buffer(bytes(p[:171])))[0], 2)
        struct.pack_into('<H', p, 33, 32)
        self.assertEqual(step(self.lib, p)[0], 3)


CaptionConfigFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8))
TransitionFn = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(sound.Transition))


class Host(c.Structure):
    _fields_ = [('sound', sound.Backend), ('lookup', loader.LOOKUP),
                ('lookup_context', c.c_void_p), ('random_state', c.POINTER(c.c_uint32)),
                ('captions_enabled', CaptionConfigFn), ('transition', TransitionFn)]


class Fixture:
    def __init__(self, test, lib, actions, *, random=True, lookup=None, transition=True):
        self.lib = lib
        self.scene, self.owner = session.open_scene(lib, actions)
        self.flags, self.world, self.conditions = session.make_world()
        self.seed, self.recorder, self.transitions = c.c_uint32(1), sound.Recorder(), []
        self.session = c.c_void_p()

        @CaptionConfigFn
        def config(_ctx, value):
            value[0] = 1
            return 0

        @TransitionFn
        def change(_ctx, effect):
            e = effect.contents
            self.transitions.append((e.target_scene, list(e.opaque_words), list(e.opaque_dwords)))
            request = session.SceneTransitionRequest()
            request.target_scene = e.target_scene
            request.opaque_words[:] = e.opaque_words[:]
            request.opaque_dwords[:] = e.opaque_dwords[:]
            return lib.scene_session_request_transition(self.session, c.byref(request))

        self.host = Host(self.recorder.backend, lookup.callback if lookup else loader.LOOKUP(),
                         None, c.pointer(self.seed) if random else None,
                         config, change if transition else TransitionFn())
        self.binding = lib.session_a97_create(c.byref(self.host))
        test.assertTrue(self.binding)
        test.assertEqual(lib.session_a97_begin_scene(self.binding, self.scene), 0)

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a97_handler', lib))
        self.bindings = (session.Binding * 1)(session.Binding(0x97, 7, handler, self.binding))
        self.session_config = session.SessionConfig(scene=self.scene, scene_id=4700,
            action_core_world=c.pointer(self.world), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=1,
            prepare_tick=prepare, advance_media_one=media)
        test.assertEqual(lib.scene_session_create(c.byref(self.session_config), c.byref(self.session),
                          c.byref(session.SceneSessionFailure())), 0)
        self.keep = [config, change, prepare, media, handler, lookup]
        test.addCleanup(self.close)

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a97_destroy(self.binding)
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
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_97_runtime.sh')],
                       check=True, capture_output=True)
        cls.lib = session.load_library(LIBRARY)
        cls.lib.session_a97_create.argtypes = [c.POINTER(Host)]
        cls.lib.session_a97_create.restype = c.c_void_p
        cls.lib.session_a97_destroy.argtypes = [c.c_void_p]
        cls.lib.session_a97_begin_scene.argtypes = [c.c_void_p, c.c_void_p]
        cls.lib.session_a97_handler.argtypes = [c.c_void_p, c.c_size_t,
            c.POINTER(session.SceneActionInfo), c.POINTER(session.RuntimeState),
            c.POINTER(session.HandlerResult)]
        cls.lib.session_a97_failure.argtypes = [c.c_void_p]
        cls.lib.session_a97_failure.restype = c.c_char_p
        cls.lib.session_a97_selected.argtypes = [c.c_void_p, c.c_size_t]
        cls.lib.scene_session_request_transition.argtypes = [c.c_void_p,
            c.POINTER(session.SceneTransitionRequest)]

    def fixture(self, subtype=1, deps=b'', **options):
        raw = options.pop('raw', loader.body((b'one', b'two'), (b'', b''),
                                             words=(13, 1, 75, 75, 0, 9999)))
        return Fixture(self, self.lib, [session.action(0x97, subtype, raw, (deps,) if deps else ())], **options)

    def test_selection_happens_before_false_dependencies_and_persists(self):
        raw = loader.body((b'one', b'two'), (b'', b''), words=(13, 0, 75, 75, 0, 9999))
        f = Fixture(self, self.lib, [session.action(0x97, 1, raw, (session.flag_gate(3),)),
                                   session.action(0x97, 1, raw)])
        after_two = ((1 * 214013 + 2531011) * 214013 + 2531011) & 0xffffffff
        self.assertEqual(f.seed.value, after_two)
        selected = self.lib.session_a97_selected(f.binding, 0)
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 0))
        f.flags[3] = 1
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(f.recorder.commands[-1][0], (b'one', b'two')[selected])
        self.assertEqual(f.seed.value, after_two)

    def test_subtype_two_false_gate_clears_phase(self):
        f = self.fixture(subtype=2, deps=session.flag_gate(3))
        f.flags[3] = 1
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 1))
        f.flags[3] = 0
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (0, 0))
        self.assertEqual(f.recorder.queries, [])

    def test_subtype_one_false_gate_preserves_phase(self):
        f = self.fixture(deps=session.flag_gate(3))
        f.flags[3] = 1
        f.tick()
        f.flags[3] = 0
        f.tick()
        self.assertEqual(f.state(), (0, 1))

    def test_subtype_two_finish_rearms_and_keeps_selection(self):
        f = self.fixture(subtype=2)
        selected = self.lib.session_a97_selected(f.binding, 0)
        f.recorder.still_playing = 0
        for expected in [(0, 1), (0, 2), (0, 0), (0, 1)]:
            self.assertEqual(f.tick()[0], 0)
            self.assertEqual(f.state(), expected)
        self.assertEqual(self.lib.session_a97_selected(f.binding, 0), selected)
        self.assertEqual(len(f.recorder.commands), 2)

    def test_missing_random_and_lookup_are_named_blockers(self):
        for options, text in [({'random': False}, b'CRT random state'),
                ({'raw': loader.body(entries=((b'KEY',),), words=(13, 1, 75, 75, 0, 9999))}, b'AUTOTEXT')]:
            f = self.fixture(**options)
            status, result = f.tick()
            self.assertEqual((status, result.failure.provider, result.failure.action_index), (2, 7, 0))
            self.assertIn(text, self.lib.session_a97_failure(f.binding))
            self.assertEqual(f.recorder.commands, [])

    def test_marked_selection_needs_no_rng(self):
        f = self.fixture(random=False, raw=loader.body((b'*one',), (b'',), words=(13, 0, 75, 75, 0, 9999)))
        self.assertEqual(f.tick()[0], 0)
        self.assertEqual(f.state(), (1, 0))
        self.assertEqual(f.seed.value, 1)

    def test_transition_preserves_tuple_and_stops_later_actions(self):
        raw = loader.body(words=(13, 1, 75, 75, 0, 42))
        f = Fixture(self, self.lib, [session.action(0x97, 1, raw),
                    session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                   session.i16(-1) + session.i16(0), (session.flag_gate(3),))])
        f.recorder.still_playing = 0
        f.tick(); f.tick()
        f.flags[3] = 1
        self.assertEqual(f.tick()[0], 1)
        self.assertEqual(f.transitions, [(42, [0, 0, 1], [0, 0, 0])])
        self.assertEqual(f.flags[4], 0)

    def test_missing_transition_is_checked_before_unload(self):
        f = self.fixture(transition=False, raw=loader.body(words=(13, 1, 75, 75, 0, 42)))
        f.recorder.still_playing = 0
        f.tick(); f.tick()
        self.assertEqual(f.tick()[0], 2)
        self.assertEqual(f.recorder.unloads, [])
        self.assertIn(b'transition provider', self.lib.session_a97_failure(f.binding))

    def test_scene_reload_consumes_new_selection_draw(self):
        f = self.fixture()
        seed = f.seed.value
        self.assertEqual(self.lib.session_a97_begin_scene(f.binding, f.scene), 0)
        self.assertEqual(f.seed.value, (seed * 214013 + 2531011) & 0xffffffff)


if __name__ == '__main__':
    unittest.main()
