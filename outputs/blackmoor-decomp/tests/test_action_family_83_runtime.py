"""RT-12: email/web list runtime, typed provider and live session ordering."""
import ctypes as C
import os
from pathlib import Path
import struct
import subprocess
import unittest

import session_binding_support as s

PROJECT = Path(__file__).resolve().parents[1]
OK, ARGUMENT, BODY, UNSUPPORTED, HOST_ERROR, CAPACITY, STATE = range(7)
SESSION_ARGUMENT = 3  # SCENE_SESSION_ERR_ARGUMENT

class World(C.Structure):
    _fields_ = [('mail', C.POINTER(C.c_uint8 * 74)), ('mail_capacity', C.c_size_t),
                ('mail_count', C.c_int16), ('web', C.POINTER(C.c_uint8 * 41)),
                ('web_capacity', C.c_size_t), ('web_count', C.c_int16)]
class Input(C.Structure):
    _fields_ = [('phase', C.c_uint32), ('subtype', C.c_uint8),
                ('completed', C.c_uint8), ('eligible', C.c_uint8)]
class Result(C.Structure):
    _fields_ = [('phase', C.c_uint32), ('completed', C.c_uint8),
                ('applied', C.c_uint8), ('selected', C.c_int16),
                ('inserted', C.c_uint8), ('list', C.c_uint8)]
REFRESH = C.CFUNCTYPE(C.c_int, C.c_void_p, C.c_int16, C.c_int32, C.c_int16)
class Backend(C.Structure):
    _fields_ = [('context', C.c_void_p), ('refresh', REFRESH)]
class Host(C.Structure):
    _fields_ = [('world', C.POINTER(World)), ('backend', Backend)]

def raw(branch=0, key=b'subject', text=b'body', field=3, word_a=10, word_b=-1):
    return struct.pack('<h', branch) + key.ljust(33, b'\0') + text.ljust(33, b'\0') + struct.pack('<hhh', field, word_a, word_b)

def storage(data):
    return (C.c_uint8 * len(data)).from_buffer_copy(data)

def bind(path=None):
    lib = s.load_library(path or Path(os.environ.get('A83_RUNTIME_LIBRARY', PROJECT / 'build/libactionfamily83_runtime.dylib')))
    lib.action83_runtime_step.argtypes = [C.POINTER(C.c_uint8), C.c_size_t, C.POINTER(Input),
        C.POINTER(World), C.POINTER(Backend), C.POINTER(Result), C.POINTER(C.c_char_p)]
    lib.action83_initialize.argtypes = [C.POINTER(World), C.POINTER(C.c_uint8), C.c_size_t]
    lib.session_a83_create.argtypes = [C.POINTER(Host)]; lib.session_a83_create.restype = C.c_void_p
    lib.session_a83_destroy.argtypes = [C.c_void_p]
    lib.session_a83_begin_scene.argtypes = [C.c_void_p, C.c_void_p]
    lib.session_a83_failure.argtypes = [C.c_void_p]; lib.session_a83_failure.restype = C.c_char_p
    lib.session_a83_last_result.argtypes = [C.c_void_p]; lib.session_a83_last_result.restype = C.c_void_p
    lib.session_a83_handler.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(s.SceneActionInfo),
        C.POINTER(s.RuntimeState), C.POINTER(s.HandlerResult)]
    lib.scene_session_mark_ui_dirty.argtypes = [C.c_void_p, C.c_int16, C.c_int16]
    lib.scene_session_get_action_ui.argtypes = [C.c_void_p]
    lib.scene_session_get_action_ui.restype = C.POINTER(__import__('test_scene_session').ActionUIWorld)
    return lib

def build():
    if 'A83_RUNTIME_LIBRARY' not in os.environ:
        subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_83_runtime.sh')], check=True, capture_output=True)
    return bind()

def refreshes(n):
    return [e for e in n.events if e[0] == 'refresh']

def act(data, subtype=1):
    return s.action(0x83, subtype, data)

class Native:
    def __init__(self, lib, capacity=8, fill=0):
        self.lib = lib
        # Two guard rows past the declared capacity: an overrun lands in harness
        # memory (and is caught by pad_intact) instead of corrupting the heap.
        self.capacity = capacity
        self.mail = ((C.c_uint8 * 74) * (capacity + 2))()
        self.web = ((C.c_uint8 * 41) * (capacity + 2))()
        C.memset(self.mail, 0xEE, C.sizeof(self.mail)); C.memset(self.web, 0xEE, C.sizeof(self.web))
        C.memset(self.mail, fill, capacity * 74); C.memset(self.web, fill, capacity * 41)
        self.world = World(self.mail, capacity, 0, self.web, capacity, 0)
        self.events = []
        self.failure = 0
        self.session = None
        self.rows = 0
        self.refresh = REFRESH(self.on_refresh)
        self.backend = Backend(None, self.refresh)
    def snapshot(self):
        return (self.world.mail_count, bytes(self.mail)[:self.capacity * 74],
                self.world.web_count, bytes(self.web)[:self.capacity * 41])
    def pad_intact(self):
        return (bytes(self.mail)[self.capacity * 74:] == b'\xEE' * 148 and
                bytes(self.web)[self.capacity * 41:] == b'\xEE' * 82)
    def completed_vector(self):
        if not self.session: return ()
        out = []
        for i in range(self.rows):
            state = s.RuntimeState()
            assert self.lib.scene_session_get_action_state(self.session, i, C.byref(state)) == 0
            out.append(state.completed)
        return tuple(out)
    def ui_state(self):
        ui = self.lib.scene_session_get_action_ui(self.session).contents
        return tuple(v for g in range(5) for v in (ui.controls[g].availability, *ui.controls[g].flags))
    def on_refresh(self, _, panel, active, child):
        self.events.append(('refresh', panel, active, child, self.snapshot(), self.completed_vector()))
        if self.failure: return self.failure
        if self.session:
            result = self.lib.scene_session_mark_ui_dirty(self.session, panel, child)
            assert result == 0
            self.events.append(('ui', self.ui_state()))
        return 0
    def step(self, data=None, phase=0, subtype=1, completed=0, eligible=1):
        data = raw() if data is None else data
        src = storage(data); inp = Input(phase, subtype, completed, eligible)
        out = Result(); C.memset(C.byref(out), 0xA5, C.sizeof(out)); failure = C.c_char_p()
        status = self.lib.action83_runtime_step(src, len(data), C.byref(inp), C.byref(self.world),
            C.byref(self.backend), C.byref(out), C.byref(failure))
        assert bytes(src) == data
        assert self.pad_intact(), 'list guard rows were overrun'
        return status, out, failure.value

class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.lib = build()
    def test_mail_insert_newest_first(self):
        n = Native(self.lib)
        for key in (b'first', b'second'):
            st, out, _ = n.step(raw(key=key))
            self.assertEqual((st, out.completed, out.selected, out.inserted), (0, 1, 0, 1))
        self.assertEqual(n.world.mail_count, 2)
        self.assertEqual(bytes(n.mail[0]).split(b'\0')[0], b'second')
        self.assertEqual(bytes(n.mail[1]).split(b'\0')[0], b'first')
    def test_mail_update_in_place_and_reset_read(self):
        n = Native(self.lib)
        for key in (b'first', b'second'): n.step(raw(key=key))
        n.mail[1][70] = 1
        st, out, _ = n.step(raw(key=b'first', text=b'changed', word_a=-3, word_b=-2))
        self.assertEqual((st, out.selected, out.inserted, n.world.mail_count), (0, 1, 0, 2))
        self.assertEqual(bytes(n.mail[1])[33:41], b'changed\0')
        self.assertEqual(struct.unpack_from('<hhI', bytes(n.mail[1]), 66), (-3, -2, 0))
    def test_web_append_update_and_signed_dword(self):
        n = Native(self.lib)
        for key in (b'A', b'B'): n.step(raw(1, key=key, field=-32768))
        st, out, _ = n.step(raw(-1, key=b'A', field=-7, word_a=-2, word_b=-3))
        self.assertEqual((st, out.selected, out.list, out.inserted, n.world.web_count), (0, 0, 1, 0, 2))
        self.assertEqual(struct.unpack_from('<hhi', bytes(n.web[0]), 33), (-2, -3, -7))
        self.assertEqual(bytes(n.web[1]).split(b'\0')[0], b'B')
    def test_exact_case_first_duplicate_selection(self):
        n = Native(self.lib)
        n.step(raw(1, key=b'KEY')); n.step(raw(1, key=b'key'))
        n.web[2][:] = n.web[0][:]; n.world.web_count = 3
        st, out, _ = n.step(raw(1, key=b'KEY', field=12))
        self.assertEqual((st, out.selected, n.world.web_count), (0, 0, 3))
        self.assertNotEqual(bytes(n.web[0]), bytes(n.web[2]))
    def test_shorter_strings_preserve_suffix_bytes(self):
        n = Native(self.lib, fill=0xA7)
        n.step(raw(key=b'long-key', text=b'long-text'))
        n.step(raw(key=b'long-key', text=b'x'))
        self.assertEqual(bytes(n.mail[0])[33:43], b'x\0ng-text\0')
    def test_refresh_observes_committed_rows(self):
        n = Native(self.lib)
        n.step(); n.step(raw(1))
        self.assertEqual([x[:4] for x in n.events], [('refresh', 3, 1, 1), ('refresh', 3, 1, 2)])
        self.assertEqual(n.events[0][4][0], 1)
        self.assertEqual(n.events[1][4][2], 1)
        # Every list store precedes the refresh (0x4e7448/0x4e7505): the callback
        # already sees the full committed record, not only the count.
        self.assertEqual(n.events[0][4][1][:8], b'subject\0')
        self.assertEqual(n.events[0][4][1][33:38], b'body\0')
        self.assertEqual(struct.unpack_from('<hhI', n.events[0][4][1], 66), (10, -1, 0))
        self.assertEqual(n.events[1][4][3][:8], b'subject\0')
        self.assertEqual(struct.unpack_from('<hhi', n.events[1][4][3], 33), (10, -1, 3))
    def test_false_gate_and_completed_leave_all_state(self):
        n = Native(self.lib)
        for eligible, completed in ((0, 0), (0, 1), (1, 1), (1, 255)):
            before = n.snapshot()
            st, out, _ = n.step(phase=7, eligible=eligible, completed=completed)
            self.assertEqual((st, out.phase, out.completed, out.applied), (0, 7, completed, 0))
            self.assertEqual(n.snapshot(), before)
        self.assertEqual(n.events, [])
    def test_every_subtype_completes_directly_preserves_phase(self):
        for subtype in range(256):
            n = Native(self.lib)
            st, out, _ = n.step(phase=0xFEDCBA98, subtype=subtype)
            self.assertEqual((st, out.phase, out.completed), (0, 0xFEDCBA98, 1))
    def test_missing_refresh_preflight_no_effect(self):
        n = Native(self.lib); n.backend.refresh = REFRESH()
        before = n.snapshot(); st, out, why = n.step()
        self.assertEqual((st, why), (UNSUPPORTED, b'0x83-refresh-unbound'))
        self.assertEqual(bytes(out), b'\xA5' * C.sizeof(out)); self.assertEqual(n.snapshot(), before)
    def test_refresh_error_retains_rows_without_completion(self):
        n = Native(self.lib); n.failure = 2
        st, out, why = n.step()
        self.assertEqual((st, why), (HOST_ERROR, b'0x83-refresh-failed'))
        self.assertEqual(n.world.mail_count, 1); self.assertEqual(bytes(out), b'\xA5' * C.sizeof(out))
    def test_capacity_and_negative_counts_fail_before_effect(self):
        n = Native(self.lib, capacity=1); n.step()
        for count, expected in ((1, CAPACITY), (-1, STATE), (2, STATE)):
            n.world.mail_count = count; before = n.snapshot(); events = len(n.events)
            self.assertEqual(n.step(raw(key=b'new'))[0], expected)
            self.assertEqual(n.snapshot(), before); self.assertEqual(len(n.events), events)
        n.world.mail_count = 1
        self.assertEqual(n.step()[0], OK)  # update at capacity still allowed
    def test_malformed_reached_strings_and_short_body(self):
        n = Native(self.lib)
        for data in (raw()[:73], raw()[:2]+b'x'*33+raw()[35:], raw()[:35]+b'y'*33+raw()[68:]):
            before = n.snapshot(); self.assertEqual(n.step(data)[0], BODY); self.assertEqual(n.snapshot(), before)
        self.assertEqual(n.events, [])
        self.assertEqual(n.step(raw(1)[:35]+b'y'*33+raw(1)[68:])[0], OK)  # unused string not read
    def test_corrupt_existing_key_rejected(self):
        n = Native(self.lib); n.world.mail_count = 1; n.mail[0][:33] = b'x'*33
        before = n.snapshot(); self.assertEqual(n.step()[0], STATE); self.assertEqual(n.snapshot(), before)
    def test_uicl_initial_entries_and_empty_reset(self):
        n = Native(self.lib, fill=0xA7); boot = bytearray(0xDA1)
        boot[0xCCB:0xCCB+70] = b'subj\0'.ljust(33,b'!')+b'text\0'.ljust(33,b'!')+struct.pack('<hh',-4,8)
        boot[0xD11:0xD11+39] = b'link\0'.ljust(33,b'!')+struct.pack('<hhh',-7,-9,11)
        self.assertEqual(self.lib.action83_initialize(C.byref(n.world), storage(boot), len(boot)), 0)
        self.assertEqual((n.world.mail_count,n.world.web_count),(1,1))
        self.assertEqual(bytes(n.mail[0])[:5],b'subj\0');self.assertEqual(bytes(n.mail[0])[33:38],b'text\0')
        self.assertEqual(bytes(n.web[0])[:5],b'link\0')
        self.assertEqual(struct.unpack_from('<hhI',bytes(n.mail[0]),66),(-4,8,0))
        self.assertEqual(struct.unpack_from('<hhi',bytes(n.web[0]),33),(-9,11,-7))
        boot[0xCCB] = boot[0xD11] = 0; before = (bytes(n.mail),bytes(n.web))
        self.assertEqual(self.lib.action83_initialize(C.byref(n.world), storage(boot), len(boot)), 0)
        self.assertEqual((n.world.mail_count,n.world.web_count),(0,0)); self.assertEqual((bytes(n.mail),bytes(n.web)),before)
    def test_initializer_rejects_short_or_unterminated_before_mutation(self):
        n=Native(self.lib); boot=bytearray(0xDA1); boot[0xCCB:0xCCB+33]=b'x'*33
        for data in (boot[:0xDA0],boot):
            before=n.snapshot();self.assertEqual(self.lib.action83_initialize(C.byref(n.world),storage(data),len(data)),BODY);self.assertEqual(n.snapshot(),before)

    def test_branch_selector_is_nonzero_word0_for_every_value(self):
        # 0x4e731c..0x4e7321: movsx; test; jne. Not "== 1", not sign-sensitive.
        for value in range(-32768, 32768, 7):
            n = Native(self.lib)
            st, out, _ = n.step(raw(value))
            self.assertEqual((st, out.list), (OK, 1 if value else 0), value)
        for value in (0, 1, -1, 2, 255, 256, 0x7fff, -0x8000):
            n = Native(self.lib)
            self.assertEqual(n.step(raw(value))[1].list, 1 if value else 0)
            self.assertEqual((n.world.mail_count, n.world.web_count), (0, 1) if value else (1, 0))
    def test_mail_insert_shifts_whole_records_including_read_flags(self):
        n = Native(self.lib, fill=0x5A)
        for i, key in enumerate((b'a', b'b', b'c')):
            n.mail[i][:] = bytes([0x30 + i]) * 74; n.mail[i][:len(key) + 1] = key + b'\0'
        n.world.mail_count = 3; old = [bytes(r) for r in n.mail]
        st, out, _ = n.step(raw(key=b'new'))
        self.assertEqual((st, out.selected, out.inserted, n.world.mail_count), (OK, 0, 1, 4))
        self.assertEqual([bytes(n.mail[i]) for i in (1, 2, 3)], old[:3])
        self.assertEqual(bytes(n.mail[4]), old[4])
    def test_lookup_is_exact_string_not_prefix_or_case_folded(self):
        n = Native(self.lib)
        for key in (b'abcd', b'ab', b'ABC', b'abc'):
            st, out, _ = n.step(raw(1, key=key)); self.assertEqual((st, out.inserted), (OK, 1), key)
        self.assertEqual(n.world.web_count, 4)
        st, out, _ = n.step(raw(1, key=b'abc')); self.assertEqual((out.selected, out.inserted, n.world.web_count), (3, 0, 4))
    def test_lists_are_independent_and_unused_strings_not_copied(self):
        n = Native(self.lib, fill=0xC3)
        web_before = bytes(n.web)
        n.step(raw(0, key=b'm'))
        self.assertEqual(bytes(n.web), web_before)
        mail_before = bytes(n.mail)
        n.step(raw(1, key=b'w', text=b'IGNORED'))
        self.assertEqual(bytes(n.mail), mail_before)
        self.assertNotIn(b'IGNORED', bytes(n.web))
    def test_web_dword_sign_extension_and_word_fields(self):
        for field in (-32768, -1, 0, 1, 32767):
            n = Native(self.lib)
            n.step(raw(1, key=b'k', field=field, word_a=-12345, word_b=23456))
            self.assertEqual(struct.unpack_from('<hhi', bytes(n.web[0]), 33), (-12345, 23456, field))
    def test_mail_words_are_not_the_web_dword(self):
        n = Native(self.lib)
        n.step(raw(0, key=b'k', field=-9, word_a=-12345, word_b=23456))
        self.assertEqual(struct.unpack_from('<hhI', bytes(n.mail[0]), 66), (-12345, 23456, 0))
    def test_found_entry_not_moved_and_count_unchanged(self):
        n = Native(self.lib)
        for key in (b'a', b'b', b'c'): n.step(raw(key=key))
        order = [bytes(r).split(b'\0')[0] for r in n.mail[:3]]
        st, out, _ = n.step(raw(key=b'a', text=b'zz'))
        self.assertEqual((out.selected, out.inserted, n.world.mail_count), (2, 0, 3))
        self.assertEqual([bytes(r).split(b'\0')[0] for r in n.mail[:3]], order)
    def test_refresh_failure_codes_all_nonzero_are_failures(self):
        for code in (1, 2, -1, 0x7fffffff):
            n = Native(self.lib); n.failure = code
            st, out, why = n.step()
            self.assertEqual((st, why), (HOST_ERROR, b'0x83-refresh-failed'))
    def test_world_unbound_is_unsupported_before_any_effect(self):
        n = Native(self.lib); src = storage(raw()); inp = Input(0, 1, 0, 1); out = Result(); why = C.c_char_p()
        st = self.lib.action83_runtime_step(src, 74, C.byref(inp), None, C.byref(n.backend), C.byref(out), C.byref(why))
        self.assertEqual((st, why.value, n.events), (UNSUPPORTED, b'0x83-world-unbound', []))
    def test_output_and_failure_arguments_validated(self):
        n = Native(self.lib); src = storage(raw()); inp = Input(0, 1, 0, 1); out = Result()
        self.assertEqual(self.lib.action83_runtime_step(src, 74, None, C.byref(n.world), C.byref(n.backend), C.byref(out), None), ARGUMENT)
        self.assertEqual(self.lib.action83_runtime_step(src, 74, C.byref(inp), C.byref(n.world), C.byref(n.backend), None, None), ARGUMENT)
        self.assertEqual(n.snapshot()[0], 0); self.assertEqual(n.events, [])

class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.lib = build()
    def make(self, actions, world_bound=True, refresh_bound=True):
        lib=self.lib; n=Native(lib)
        if not refresh_bound:n.backend.refresh=REFRESH()
        host=Host(C.pointer(n.world) if world_bound else None,n.backend)
        binding=lib.session_a83_create(C.byref(host)); self.assertTrue(binding)
        self.addCleanup(lib.session_a83_destroy,binding)
        scene,owner=s.open_scene(lib,actions); self.addCleanup(lib.scene_resource_close,scene)
        self.assertEqual(lib.session_a83_begin_scene(binding,scene),0)
        flags,world,conditions=s.make_world(flag_count=3000)
        provider=s.Binding(0x83,16,C.cast(lib.session_a83_handler,s.ActionFn),binding)
        bindings=(s.Binding*1)(provider)
        cfg=s.SessionConfig();cfg.scene=scene;cfg.scene_id=4808;cfg.action_core_world=C.pointer(world);cfg.conditions=C.pointer(conditions)
        cfg.action_bindings=bindings;cfg.action_binding_count=1;cfg.prepare_tick=s.PrepareFn(lambda *_:0);cfg.advance_media_one=s.MediaFn(lambda *_:0)
        session=C.c_void_p();failure=s.SceneSessionFailure();self.assertEqual(lib.scene_session_create(C.byref(cfg),C.byref(session),C.byref(failure)),0)
        self.addCleanup(lib.scene_session_destroy,session);n.session=session
        # Keep all borrowed structures and callbacks alive.
        n.owners=(host,owner,flags,world,conditions,bindings,cfg);n.binding=binding;n.rows=len(actions)
        return n
    def tick(self,n):
        out=s.SceneSessionTickResult();status=self.lib.scene_session_tick(n.session,C.byref(out));assert n.pad_intact(),'list guard rows were overrun';return status,out
    def test_two_rows_source_order_and_no_repeat(self):
        n=self.make([act(raw(key=b'one')),act(raw(key=b'two'))])
        self.assertEqual(self.tick(n)[0],0); self.assertEqual(n.world.mail_count,2)
        self.assertEqual([x[4][0] for x in n.events if x[0]=='refresh'],[1,2]); self.assertEqual(bytes(n.mail[0]).split(b'\0')[0],b'two')
        self.assertEqual(self.tick(n)[0],0);self.assertEqual(len(refreshes(n)),2)
        for i in range(2):
            state=s.RuntimeState();self.lib.scene_session_get_action_state(n.session,i,C.byref(state));self.assertEqual(state.completed,1)
        ui=self.lib.scene_session_get_action_ui(n.session).contents
        self.assertEqual((ui.controls[3].availability,list(ui.controls[3].flags)),(1,[0,1,0]))
    def test_dependency_gate_real_opcode2_then_true(self):
        dep=struct.pack('<hhB',2,2075,1)+bytes(11)
        n=self.make([act(raw()+dep)])
        self.assertEqual(self.tick(n)[0],0); self.assertEqual(n.events,[])
        n.owners[2][2075]=1
        self.assertEqual(self.tick(n)[0],0); self.assertEqual(n.world.mail_count,1)
    def test_dependency_false_then_true_no_silent_skip(self):
        # Same opcode/value as the corpus tail, bounded test event ID.
        dep=struct.pack('<hhB',2,3,1)+bytes(11)
        n=self.make([act(raw()+dep)])
        self.assertEqual(self.tick(n)[0],0);self.assertEqual(n.events,[])
        n.owners[2][3]=1
        self.assertEqual(self.tick(n)[0],0);self.assertEqual(n.world.mail_count,1)
    def test_binding_nonzero_branch_and_direct_subtype2(self):
        n=self.make([act(raw(7,field=-1),subtype=2)])
        self.assertEqual(self.tick(n)[0],0);self.assertEqual((n.world.mail_count,n.world.web_count),(0,1))
        state=s.RuntimeState();self.lib.scene_session_get_action_state(n.session,0,C.byref(state));self.assertEqual(state.completed,1)
        self.assertEqual(self.tick(n)[0],0);self.assertEqual(len(refreshes(n)),1)
    def test_unbound_providers_before_any_effect(self):
        for world,refresh,why in ((False,True,b'0x83-world-unbound'),(True,False,b'0x83-refresh-unbound')):
            n=self.make([act(raw())],world,refresh);before=n.snapshot();status,out=self.tick(n)
            self.assertEqual((status,out.failure.provider,out.failure.action_type),(2,16,0x83));self.assertEqual(self.lib.session_a83_failure(n.binding),why)
            self.assertEqual(n.snapshot(),before);self.assertEqual(n.events,[])
    def test_host_failure_is_sticky_and_uncompleted(self):
        n=self.make([act(raw())]);n.failure=2
        self.assertEqual(self.tick(n)[0],5);state=s.RuntimeState();self.lib.scene_session_get_action_state(n.session,0,C.byref(state));self.assertEqual(state.completed,0)
        self.assertEqual(n.world.mail_count,1);self.tick(n);self.assertEqual(len(refreshes(n)),1)
    def test_world_survives_scene_replacement(self):
        n=self.make([act(raw(key=b'one'))]);self.tick(n)
        scene,owner=s.open_scene(self.lib,[act(raw(key=b'two'))]);self.addCleanup(self.lib.scene_resource_close,scene)
        self.assertEqual(self.lib.session_a83_begin_scene(n.binding,scene),0)
        failure=s.SceneSessionFailure();self.assertEqual(self.lib.scene_session_replace_scene(n.session,scene,4809,C.byref(failure)),0)
        self.assertEqual(self.tick(n)[0],0);self.assertEqual(n.world.mail_count,2)
    def test_unowned_binding_row_errors(self):
        n=self.make([act(raw())])
        # A handler cannot apply a row beyond the owned scene table.
        info=s.SceneActionInfo();info.type=0x83;state=s.RuntimeState();out=s.HandlerResult()
        self.assertEqual(self.lib.session_a83_handler(n.binding,9,C.byref(info),C.byref(state),C.byref(out)),2)

    def test_mark_ui_dirty_sets_only_selected_group_and_child(self):
        n = self.make([act(raw())])
        ui = self.lib.scene_session_get_action_ui(n.session).contents
        for g in range(5):
            for c in range(3):
                for gg in range(5):
                    ui.controls[gg].availability = 0x1000 + gg
                    for cc in range(3): ui.controls[gg].flags[cc] = 0x2000 + 3 * gg + cc
                self.assertEqual(self.lib.scene_session_mark_ui_dirty(n.session, g, c), 0)
                for gg in range(5):
                    for cc in range(3):
                        want = 1 if (gg, cc) == (g, c) else 0x2000 + 3 * gg + cc
                        self.assertEqual(ui.controls[gg].flags[cc], want)
                    self.assertEqual(ui.controls[gg].availability, 1 if gg == g else 0x1000 + gg)
        before = n.ui_state()
        for g, c in ((5, 0), (-1, 0), (0, 3), (0, -1), (32767, 32767), (-32768, 0)):
            self.assertEqual(self.lib.scene_session_mark_ui_dirty(n.session, g, c), SESSION_ARGUMENT, (g, c))
            self.assertEqual(n.ui_state(), before)
        self.assertEqual(self.lib.scene_session_mark_ui_dirty(None, 3, 1), SESSION_ARGUMENT)
    def test_each_row_uses_its_own_loader_copy_in_source_order(self):
        n = self.make([act(raw(0, key=b'm0')), act(raw(1, key=b'w1')), act(raw(0, key=b'm2')), act(raw(0, key=b'm0', text=b'again'))])
        self.assertEqual(self.tick(n)[0], 0)
        self.assertEqual([e[1:4] for e in refreshes(n)], [(3, 1, 1), (3, 1, 2), (3, 1, 1), (3, 1, 1)])
        self.assertEqual([bytes(r).split(b'\0')[0] for r in n.mail[:2]], [b'm2', b'm0'])
        self.assertEqual(bytes(n.mail[1])[33:39], b'again\0')
        self.assertEqual(struct.unpack_from('<hhI', bytes(n.mail[0]), 66), (10, -1, 0))  # full 74-byte loader copy
        self.assertEqual((n.world.mail_count, n.world.web_count), (2, 1))
        self.assertEqual([e[5] for e in refreshes(n)], [(0, 0, 0, 0), (1, 0, 0, 0), (1, 1, 0, 0), (1, 1, 1, 0)])
        last = Result.from_address(self.lib.session_a83_last_result(n.binding))
        self.assertEqual((last.selected, last.inserted, last.list, last.applied, last.completed), (1, 0, 0, 1, 1))
        self.assertIsNone(self.lib.session_a83_last_result(None))
    def test_refresh_sees_row_not_yet_complete_and_ui_set_after_each_refresh(self):
        n = self.make([act(raw(key=b'x'))])
        self.assertEqual(self.tick(n)[0], 0)
        kinds = [e[0] for e in n.events]
        self.assertEqual(kinds, ['refresh', 'ui'])
        self.assertEqual(n.events[0][5], (0,))
        ui = n.events[1][1]
        self.assertEqual(ui[12:16], (1, 0, 1, 0))
        self.assertEqual(sum(1 for v in ui if v == 1), 2)
    def test_begin_scene_arguments_and_failure_text(self):
        lib = self.lib; n = Native(lib)
        host = Host(C.pointer(n.world), n.backend); binding = lib.session_a83_create(C.byref(host))
        self.addCleanup(lib.session_a83_destroy, binding)
        scene, owner = s.open_scene(lib, [act(raw())]); self.addCleanup(lib.scene_resource_close, scene)
        self.assertEqual(lib.session_a83_begin_scene(binding, scene), OK)
        self.assertEqual(lib.session_a83_begin_scene(None, scene), ARGUMENT)
        self.assertEqual(lib.session_a83_begin_scene(binding, None), ARGUMENT)
        self.assertEqual(lib.session_a83_failure(binding), b'none')
        self.assertEqual(lib.session_a83_failure(None), b'0x83-binding-unbound')
    def test_handler_rejects_wrong_type_null_and_missing_row(self):
        n = self.make([act(raw())])
        info = s.SceneActionInfo(); info.type = 0x84; state = s.RuntimeState(); out = s.HandlerResult()
        self.assertEqual(self.lib.session_a83_handler(n.binding, 0, C.byref(info), C.byref(state), C.byref(out)), 2)
        self.assertEqual(self.lib.session_a83_failure(n.binding), b'0x83-row-not-owned')
        info.type = 0x83
        self.assertEqual(self.lib.session_a83_handler(None, 0, C.byref(info), C.byref(state), C.byref(out)), 2)
        self.assertEqual(self.lib.session_a83_handler(n.binding, 0, None, C.byref(state), C.byref(out)), 2)
        self.assertEqual(n.events, [])
    def test_non_a83_rows_in_the_scene_have_no_owned_body(self):
        n = self.make([s.action(0x61, 1, s.i16(0) + s.i16(9) + s.i16(-1) + s.i16(0)), act(raw(key=b'only'))])
        info = s.SceneActionInfo(); info.type = 0x83; state = s.RuntimeState(); out = s.HandlerResult()
        self.assertEqual(self.lib.session_a83_handler(n.binding, 0, C.byref(info), C.byref(state), C.byref(out)), 2)
        self.assertEqual(self.lib.session_a83_failure(n.binding), b'0x83-row-not-owned')
    def test_failure_text_reports_the_unbound_provider_and_recovers_to_none(self):
        n = self.make([act(raw())], refresh_bound=False)
        self.tick(n)
        self.assertEqual(self.lib.session_a83_failure(n.binding), b'0x83-refresh-unbound')
    def test_scene_replacement_swaps_rows_and_world_persists(self):
        n = self.make([act(raw(key=b'one'))]); self.tick(n)
        scene, owner = s.open_scene(self.lib, [act(raw(key=b'two')), act(raw(1, key=b'link'))]); self.addCleanup(self.lib.scene_resource_close, scene)
        self.assertEqual(self.lib.session_a83_begin_scene(n.binding, scene), 0)
        failure = s.SceneSessionFailure(); self.assertEqual(self.lib.scene_session_replace_scene(n.session, scene, 4809, C.byref(failure)), 0)
        n.rows = 2; self.assertEqual(self.tick(n)[0], 0)
        self.assertEqual((n.world.mail_count, n.world.web_count), (2, 1))
        self.assertEqual(bytes(n.mail[0]).split(b'\0')[0], b'two')


class SanitizerTests(unittest.TestCase):
    def test_asan_ubsan_bounded_malformed_inputs(self):
        import tempfile
        with tempfile.TemporaryDirectory() as directory:
            exe = Path(directory) / 'a83-sanitize'
            compiled = subprocess.run(['xcrun', 'clang', '-arch', 'arm64', '-std=c11', '-Wall', '-Wextra', '-Wpedantic',
                '-Werror', '-O1', '-g', '-fsanitize=address,undefined', '-fno-omit-frame-pointer',
                '-I' + str(PROJECT / 'src'), str(PROJECT / 'src/action_family_83_runtime.c'),
                str(PROJECT / 'tests/action_family_83_runtime_sanitize.c'), '-o', str(exe)],
                capture_output=True, text=True)
            self.assertEqual(compiled.returncode, 0, compiled.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('66074 cases', result.stdout)



class OracleTests(unittest.TestCase):
    def test_original_x86_oracle_has_no_mismatch(self):
        import json
        import sys
        import tempfile
        if not (PROJECT.parents[1] / 'work/original/GAME.EXE').is_file():
            raise unittest.SkipTest('original executable unavailable')
        with tempfile.TemporaryDirectory() as directory:
            report = Path(directory) / 'report.json'
            result = subprocess.run([sys.executable, str(PROJECT / 'tests/action_family_83_runtime_original_oracle.py'),
                                     '--report', str(report)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            data = json.loads(report.read_text())
            self.assertEqual(data['mismatches'], 0)
            self.assertGreaterEqual(data['counts']['runtime_visits'], 1600)
            self.assertGreaterEqual(data['counts']['binding_visits'], 80)


if __name__=='__main__':unittest.main()
