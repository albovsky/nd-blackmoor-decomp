"""RT-7 lifecycle contracts. Original comparison lives in the adjacent oracle."""
import ctypes as C
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import unittest

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))


def body(branch=1, mode=2, direction=1, events=(), views=(0,), effect=5,
         final=(-1, 0), policy=2, first=0, last=2):
    b = bytearray(b'fixture\0' + bytes(25))
    b += struct.pack('<13h', branch, policy, effect, mode, direction, first, last,
                     4710, 7, 8, 1, *final)
    b += struct.pack('<h', len(events))
    for event in events:
        b += struct.pack('<3h', *event)
    b += struct.pack('<h', len(views))
    for view in views:
        b += struct.pack('<h8i', view, 0, 0, 3, 2, 1, 2, 4, 4)
    return bytes(b)


FIELDS = ('phase', 'finish', 'substate', 'presented', 'dirty', 'shown',
          'flag21a', 'matched', 'record', 'active', 'modal', 'start', 'visible',
          'redraw', 'cursor', 'layers0', 'layers1', 'layers2', 'transition',
          'scene', 'frame', 'vertical', 'word', 'dword0', 'dword1', 'dword2',
          'engine', 'saved_modal', 'status', 'opened', 'closed', 'rects',
          'decoded', 'next_calls', 'source_l', 'source_t', 'source_r', 'source_b',
          'dest_l', 'dest_t', 'dest_r', 'dest_b')


class Native:
    def __init__(self, lib, data):
        self.lib = lib
        b = C.create_string_buffer(data)
        self.handle = lib.rt35_new(b, len(data))
        assert self.handle

    def step(self, phase, view=0, due=1, frame=0, more=1):
        return self.lib.rt35_step(self.handle, phase, view, due, frame, more)

    def values(self):
        a = (C.c_int32 * len(FIELDS))()
        self.lib.rt35_values(self.handle, a)
        return dict(zip(FIELDS, a))

    def flag(self, index):
        return self.lib.rt35_flag(self.handle, index)

    def close(self):
        if self.handle:
            self.lib.rt35_free(self.handle)
            self.handle = None


def load_driver(path=None):
    if path is None:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_35_runtime.sh'),
                        '--test-driver'], check=True, capture_output=True)
        path = PROJECT / 'build/libactionfamily35_runtime_test.dylib'
    lib = C.CDLL(str(path))
    lib.rt35_new.argtypes = [C.c_void_p, C.c_size_t]
    lib.rt35_new.restype = C.c_void_p
    lib.rt35_step.argtypes = [C.c_void_p] + [C.c_int32] * 5
    lib.rt35_values.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
    lib.rt35_missing.argtypes = [C.c_void_p, C.c_int]
    lib.rt35_flag.argtypes = [C.c_void_p, C.c_int]
    lib.rt35_free.argtypes = [C.c_void_p]
    lib.rt35_binding.argtypes = [C.c_void_p, C.c_void_p, C.c_int]
    lib.rt35_binding.restype = C.c_void_p
    lib.rt35_avf.argtypes = [C.c_void_p, C.c_void_p, C.c_size_t]
    lib.rt35_poll.argtypes = [C.c_void_p]
    lib.rt35_ack.argtypes = [C.c_void_p]
    lib.rt35_now.argtypes = [C.c_void_p, C.c_uint32]
    lib.rt35_fail_due.argtypes = [C.c_void_p]
    return lib


class MovieRuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = load_driver()

    def make(self, **kwargs):
        n = Native(self.lib, body(**kwargs))
        self.addCleanup(n.close)
        return n

    def test_start_bink_is_pending_and_does_not_decode(self):
        n = self.make()
        self.assertEqual(n.step(0), 0)
        v = n.values()
        self.assertEqual((v['phase'], v['active'], v['modal'], v['opened'],
                          v['decoded'], v['shown']), (1, 1, 1, 1, 0, 3))

    def test_hidden_tick_never_decodes(self):
        n = self.make()
        n.step(0)
        self.assertEqual(n.step(1, view=9), 0)
        v = n.values()
        self.assertEqual((v['visible'], v['shown'], v['decoded']), (0, 3, 0))

    def test_view_stops_matching_after_presentation_then_returns_not_due(self):
        n = self.make()
        self.assertEqual(n.step(0), 0)
        self.assertEqual(n.step(1), 0)
        v = n.values()
        self.assertEqual(tuple(v[k] for k in ('shown', 'matched', 'dirty', 'visible')),
                         (2, 1, 1, 1))
        self.assertEqual(n.step(1, view=99), 0)
        v = n.values()
        self.assertEqual(tuple(v[k] for k in ('shown', 'matched', 'dirty', 'visible', 'record')),
                         (3, 0, 0, 0, -1))
        self.assertEqual(n.step(1, due=0), 0)
        v = n.values()
        self.assertEqual(tuple(v[k] for k in ('shown', 'matched', 'dirty', 'visible', 'decoded')),
                         (3, 1, 0, 1, 1))

    def test_not_due_keeps_first_frame_state(self):
        n = self.make()
        n.step(0)
        n.step(1, due=0)
        v = n.values()
        self.assertEqual((v['substate'], v['dirty'], v['decoded']), (0, 0, 0))

    def test_frame_triggers_and_rectangles(self):
        n = self.make(events=((0, 1001, -3), (0, 1002, 1)))
        n.step(0)
        n.step(1, frame=0)
        v = n.values()
        self.assertEqual((n.flag(1001), n.flag(1002)), (-3, 1))
        self.assertEqual((v['dirty'], v['shown'], v['substate'], v['flag21a']), (1, 2, 4, 1))
        self.assertEqual(tuple(v[x] for x in ('source_l', 'source_t', 'source_r', 'source_b')), (0, 0, 3, 2))
        self.assertEqual(tuple(v[x] for x in ('dest_l', 'dest_t', 'dest_r', 'dest_b')), (11, 22, 14, 24))

    def test_same_frame_duplicate_event_id_uses_last_value(self):
        n = self.make(events=((0, 1001, -3), (0, 1001, 7)))
        self.assertEqual(n.step(0), 0)
        self.assertEqual(n.step(1), 0)
        self.assertEqual(n.flag(1001), 7)

    def test_end_of_bink_moves_to_finishing_then_completes(self):
        n = self.make(final=(1007, 4))
        n.step(0)
        n.step(1, frame=2, more=0)
        self.assertEqual(n.values()['phase'], 2)
        self.assertEqual(n.step(2), 0)
        v = n.values()
        self.assertEqual((v['finish'], v['phase'], v['active'], v['closed']), (1, 0, 0, 1))
        self.assertEqual(n.flag(1007), 4)
        self.assertEqual(tuple(v[x] for x in ('scene', 'frame', 'vertical', 'word', 'dword0', 'dword1', 'dword2', 'engine')), (4710, 7, 8, 1, 0, 0, 1, 4))

    def test_no_transition_effect_and_policy_one(self):
        n = self.make(effect=6, policy=1)
        n.step(0)
        n.step(2)
        self.assertEqual((n.values()['transition'], n.values()['start']), (0, 0))

    def test_multiple_matches_each_run_the_original_helper(self):
        n = self.make(views=(0, 0))
        n.step(0)
        n.step(1)
        self.assertEqual((n.values()['decoded'], n.values()['record']), (2, 1))

    def test_missing_decode_refuses_before_world_effects(self):
        n = self.make()
        self.lib.rt35_missing(n.handle, 1)
        n.step(0)
        before = n.values()
        self.assertEqual(n.step(1), 2)
        after = n.values()
        for field in ('visible', 'dirty', 'modal', 'record', 'decoded'):
            self.assertEqual(before[field], after[field])

    def test_missing_open_does_not_set_active(self):
        n = self.make()
        self.lib.rt35_missing(n.handle, 0)
        self.assertEqual(n.step(0), 2)
        self.assertEqual(n.values()['active'], 0)

    def test_host_failure_is_terminal_and_does_not_replay(self):
        n = self.make()
        n.step(0)
        self.lib.rt35_fail_due(n.handle)
        self.assertEqual(n.step(1), 3)
        self.assertEqual(n.step(1), 4)
        self.assertEqual(n.values()['decoded'], 0)

    def test_bad_event_id_is_rejected_before_open(self):
        n = self.make(events=((0, 4000, 1),))
        self.assertEqual(n.step(0), 1)
        self.assertEqual(n.values()['opened'], 0)

    def test_invalid_phase_is_a_noop(self):
        n = self.make()
        self.assertEqual(n.step(7), 0)
        self.assertEqual(n.values()['opened'], 0)

    def test_single_buffer_clears_three_render_layers(self):
        n = self.make(mode=0)
        n.step(0)
        v = n.values()
        self.assertEqual((v['layers0'], v['layers1'], v['layers2']), (0, 0, 0))

    def test_avf_sequential_reader_render_ack_and_finish(self):
        from test_avf_decoder import build_avf
        data = build_avf(4, 3, [(0, bytes([i, 0] * 12), None) for i in range(5)])
        for mode in (0, 1, 2):
            for direction in (1, 2):
                with self.subTest(mode=mode, direction=direction):
                    n = self.make(branch=0, mode=mode, direction=direction,
                                  first=1, last=3,
                                  events=((1, 1001, 1), (3, 1002, 2)))
                    storage = C.create_string_buffer(data)
                    self.assertEqual(self.lib.rt35_avf(n.handle, storage, len(data)), 0)
                    self.assertEqual(n.step(0), 0)
                    for i, frame in enumerate((1, 2, 3) if direction == 1 else (3, 2, 1)):
                        self.lib.rt35_now(n.handle, (i + 1) * 1000)
                        self.assertEqual(self.lib.rt35_poll(n.handle), 0)
                        self.assertEqual(n.step(1), 0)
                        self.assertEqual(n.values()['presented'], frame)
                        self.assertEqual(self.lib.rt35_ack(n.handle), 0)
                    self.lib.rt35_now(n.handle, 5000)
                    self.assertEqual(n.step(1), 0)
                    self.assertEqual(n.values()['phase'], 2)
                    self.assertEqual(n.step(2), 0)
                    self.assertEqual((n.values()['finish'], n.flag(1001), n.flag(1002)), (1, 1, 2))

    def test_avf_finish_waits_for_reader_ready(self):
        from test_avf_decoder import build_avf
        data = build_avf(4, 3, [(0, bytes([i, 0] * 12), None) for i in range(3)])
        n = self.make(branch=0, final=(1007, -9))
        storage = C.create_string_buffer(data)
        self.assertEqual(self.lib.rt35_avf(n.handle, storage, len(data)), 0)
        self.assertEqual(n.step(0), 0)
        self.assertEqual(n.step(2), 0)
        v = n.values()
        self.assertEqual(tuple(v[k] for k in ('phase', 'finish', 'active', 'closed', 'transition')),
                         (2, 0, 1, 0, 0))
        self.assertEqual(n.flag(1007), 0)
        self.assertEqual(self.lib.rt35_poll(n.handle), 0)
        self.assertEqual(n.step(2), 0)
        v = n.values()
        self.assertEqual(tuple(v[k] for k in ('phase', 'finish', 'active', 'closed', 'transition')),
                         (0, 1, 0, 1, 1))
        self.assertEqual(n.flag(1007), -9)

    def test_real_session_binding_preserves_pending_and_completes_by_subtype(self):
        self.session_case(missing=0, subtype=1)

    def test_real_session_binding_repeat_subtype_resets_phase(self):
        self.session_case(missing=0, subtype=2)

    def test_real_session_binding_names_and_freezes_missing_movie_provider(self):
        self.session_case(missing=1, subtype=1)

    def session_case(self, missing, subtype):
        import test_scene_session as s
        # Use the existing session test setup solely for signatures/build.
        s.SceneSessionTests.setUpClass()
        case = s.SceneSessionTests()
        data = body(effect=6)
        n = Native(self.lib, data)
        scene, owner = case.open_scene([s.action(0x35, subtype, data)])
        context = self.lib.rt35_binding(n.handle, scene, missing)
        self.assertTrue(context)
        flags, world, conditions = case.make_world()
        callback = s.ActionFn(('session_a35_handler', self.lib))

        @s.PrepareFn
        def prepare(*args):
            return s.CALLBACK_OK

        @s.MediaFn
        def media(*args):
            return s.CALLBACK_OK

        binding = s.Binding(type=0x35, provider=15, callback=callback, context=context)
        session, initial, bindings = case.create_session(scene, world, conditions,
            prepare=prepare, media=media, bindings=[binding])
        try:
            tick = s.SceneSessionTickResult()
            self.assertEqual(case.lib.scene_session_tick(session, C.byref(tick)), s.SESSION_OK)
            state = s.RuntimeState()
            case.lib.scene_session_get_action_state(session, 0, C.byref(state))
            self.assertEqual((state.phase, state.completed), (1, 0))
            if missing:
                self.assertEqual(case.lib.scene_session_tick(session, C.byref(tick)), s.SESSION_BLOCKED)
                self.assertEqual((tick.failure.provider, tick.failure.action_index,
                                  tick.failure.action_type), (15, 0, 0x35))
                before = n.values()['opened']
                self.assertEqual(case.lib.scene_session_tick(session, C.byref(tick)), s.SESSION_BLOCKED)
                self.assertEqual(n.values()['opened'], before)
            else:
                self.assertEqual(case.lib.scene_session_tick(session, C.byref(tick)), s.SESSION_OK)
                case.lib.scene_session_get_action_state(session, 0, C.byref(state))
                self.assertEqual((state.phase, state.completed), (2, 0))
                self.assertEqual(case.lib.scene_session_tick(session, C.byref(tick)), s.SESSION_OK)
                case.lib.scene_session_get_action_state(session, 0, C.byref(state))
                self.assertEqual((state.phase, state.completed), (0, int(subtype == 1)))
        finally:
            case.lib.scene_session_destroy(session)
            n.close()
            case.lib.scene_resource_close(scene)
            self.assertTrue(owner)


class MovieRuntimeSanitizerTests(unittest.TestCase):
    def test_corpus_truncations_and_event_bounds_under_sanitizers(self):
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_35_runtime.sh'),
                        '--sanitize'], check=True, capture_output=True)
        root = PROJECT.parents[1]
        corpus = json.loads((root / 'work/analysis/slices/A-35.1.corpus.json').read_text())
        inputs = []
        for row in corpus['records']:
            resource = root / f"work/analysis/hiff-resources/{row['resource_index']:04d}.bin"
            raw = resource.read_bytes()[row['raw_body_offset']:row['raw_body_offset']+row['raw_body_length']]
            inputs.extend(raw[:i] for i in range(len(raw) + 1))
        for flag in (-32768, -2, -1, 0, 2999, 3000, 32767):
            inputs.append(body(events=((0, flag, 1),), final=(flag, 2)))
        payload = b''.join(struct.pack('<I', len(raw)) + raw for raw in inputs)
        result = subprocess.run([str(PROJECT / 'build/action_family_35_runtime_sanitize')],
            input=payload, capture_output=True, env={**os.environ,
                'ASAN_OPTIONS': 'detect_leaks=0:halt_on_error=1',
                'UBSAN_OPTIONS': 'halt_on_error=1:print_stacktrace=1'}, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr.decode()[-3000:])
        self.assertEqual(result.stdout.decode().strip(), f'cases={len(inputs)}')


if __name__ == '__main__':
    unittest.main()
