"""FL-39 (batch c) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl39c.c on the same generated
fixtures (tests/fl39c_fixtures.py builds them; the original side is fl39c_fixtures.run_original, the same function that
tests/fl39c_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl39c_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
"""
import ctypes
from pathlib import Path
import random
import struct
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl39c_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl39cDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl39c_differential_shim.c'
    KERNELS = ['original_methods_fl39c.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl39c.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl39cWorld'

    def native_calls(self, arrays, probe_spec, deref_len):
        """The shim's call log as comparable lists: [callee, this, *args, probe]."""
        spans = [(ctypes.addressof(arr), len(arr), a.va) for a, arr in arrays]

        def va_of(value):
            for base, length, va in spans:
                if base <= value < base + length:
                    return va + (value - base)
            return fx.LOCAL if value >= 1 << 32 else value
        calls = self.lib.shim_calls()
        out = []
        for i in range(self.lib.shim_call_count()):
            c = calls[i]
            entry = [c.id, va_of(c.this_ptr), *[va_of(c.arg[k]) for k in range(c.nargs)]]
            for index, (arg, nbytes) in enumerate(deref_len.get(c.id, ())):       # the bytes behind pointer arguments that are host pointers (locals of the function)
                entry.append(bytes(c.data)[128 * index:128 * index + nbytes] if c.arg[arg] >= 1 << 32 else b'')
            if c.id in probe_spec:       # one blob, in the order of the stub's probe list: fixture bytes (from the shim's probe buffer) and globals (from the world snapshot)
                snap, mem, at, parts = bytes(c.world), bytes(c.probe), 0, []
                for part in probe_spec[c.id]:
                    if part[0] == 'p':
                        parts.append(mem[at:at + part[1]])
                        at += part[1]
                    else:
                        parts.append(snap[part[1]:part[1] + part[2]])
                entry.append(b''.join(parts))
            out.append(entry)
        return out

    def pair(self, sc, executed, edges):
        """Runs the original and the native function on scenario `sc` and compares."""
        orig, expected, _ = fx.run_original(sc)
        self.lib.shim_reset()
        arrays, by_name = [], {}
        for a in sc.areas:
            arr = buf(a.data)
            by_name[a.name] = arr
            arrays.append((a, arr))
            self.lib.shim_add_region(a.va, ptr(arr), len(arr))
        sw = fx.World()
        for field, value in sc.g.items():
            setattr(sw, field, value & ((1 << (8 * fx.GLOBALS[field][1])) - 1))
        for field, (name, offset) in sc.pointers.items():
            setattr(sw, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        probe_spec, deref_len = {}, {}
        for s in [*sc.stubs.values(), *sc.iat.values()]:
            for call, arg, offset, size_, value in s.writes:
                if isinstance(value, bytes):
                    self.lib.shim_script_write_bytes(s.name, call, arg, offset, value, len(value))
                else:
                    self.lib.shim_script_write(s.name, call, arg, offset, size_, value)
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for name, off, ln in (s.probe or ()):
                if name.startswith('g:'):
                    probe_spec.setdefault(s.name, []).append(('w', getattr(fx.World, name[2:]).offset, fx.GLOBALS[name[2:]][1]))
                else:
                    probe_spec.setdefault(s.name, []).append(('p', ln))
                    self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            for index, (arg, nbytes) in enumerate(getattr(s, 'derefs', None) or ()):
                (self.lib.shim_script_deref if index == 0 else self.lib.shim_script_deref2)(s.name, arg, nbytes)
                deref_len.setdefault(s.name, []).append((arg, nbytes))
        result = ctypes.c_int32(0)
        self_ptr = ptr(by_name['self']) if 'self' in by_name else None
        native_args = list(sc.args)
        if fx.SPECS[sc.key].get('ptr_args'):        # the stack arguments are pointers into a fixture: the port takes host pointers
            for i, v in enumerate(native_args):
                for a, arr in arrays:
                    if a.va <= v < a.va + len(arr):
                        native_args[i] = ctypes.addressof(arr) + (v - a.va)
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in native_args])
        self.lib.shim_fl39c(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        if fx.SPECS[sc.key].get('retself'):
            self.assertEqual(result.value, 0, 'the port must return self')
        if fx.SPECS[sc.key].get('ret16'):
            self.assertEqual(result.value & 0xffff, orig.eax & 0xffff, 'return value (ax)')
        if sc.fault is not None:
            self.assertEqual(result.value, -0x80000000, 'native rejection of an input that makes the original fault')
        elif fx.SPECS[sc.key].get('ret'):
            self.assertEqual(result.value & 0xffffffff, orig.eax & 0xffffffff, 'return value')
        if sc.partial is None:
            for a, arr in arrays:
                if a.compare:
                    self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s' % (sc.key, a.name))
            for field in sc.g:
                size = fx.GLOBALS[field][1]
                self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        else:       # the native port rejects after sc.partial[0] calls (the original goes on through a null pointer): compare that prefix, and require
            # that EVERY byte of EVERY area and every global is unchanged except the bytes named in sc.partial[1] ({area: nbytes}), which are the original's
            self.assertEqual(result.value, 1, 'native rejection status')
            expected = expected[:sc.partial[0]]
            for a, arr in arrays:
                want = bytearray(a.data)
                n = sc.partial[1].get(a.name, 0)
                if n:
                    want[:n] = orig.memory[a.name][:n]
                self.assertEqual(bytes(arr), bytes(want), '%s %s (rejection must leave everything else unchanged)' % (sc.key, a.name))
            for field, value in sc.g.items():
                size = fx.GLOBALS[field][1]
                self.assertEqual(getattr(sw, field) & ((1 << (8 * size)) - 1), value & ((1 << (8 * size)) - 1), field)
        actual = self.native_calls(arrays, probe_spec, deref_len)
        for entry in actual:
            for index in sc.word_args.get(entry[0], ()):
                entry[2 + index] &= 0xffff
        self.assertEqual(actual, expected, '%s scenario profile %s' % (sc.key, sc.profile))
        executed |= orig.executed
        edges |= orig.edges

    def run_key(self, key):
        rng = random.Random(int(key, 16))
        executed, edges = set(), set()
        va, size = fx.SPECS[key]['va'], fx.SPECS[key].get('code', fx.SPECS[key]['size'])
        for n in range(fx.scenarios(key)):
            self.pair(fx.build(key, rng, n), executed, edges)
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])
        # both directions of every conditional jump of the original function (the next address after the jump, recorded by the code hook)
        unexpected, stale, _ = fx.check_edges(key, edges)
        self.assertEqual(unexpected, [], 'conditional jumps never taken one way (address, direction): %s' % [(hex(a), d) for a, d in unexpected])
        self.assertEqual(stale, [], 'allowlisted untaken edges that are taken after all (remove them): %s' % [(hex(a), d) for a, d in stale])

    def test_4a3aec_clamp_rect(self):
        """FL-39c: differential test of m4a3aec_clamp_rect (original 0x4a3aec)"""
        self.run_key('4a3aec')

    def test_4a7f08_clamp_rect(self):
        """FL-39c: differential test of m4a7f08_clamp_rect (original 0x4a7f08)"""
        self.run_key('4a7f08')

    def test_4ada0d_check_bytes(self):
        """FL-39c: differential test of m4ada0d_check_bytes (original 0x4ada0d)"""
        self.run_key('4ada0d')

    def test_4ada56_check_bytes(self):
        """FL-39c: differential test of m4ada56_check_bytes (original 0x4ada56)"""
        self.run_key('4ada56')

    def test_4ada9f_check_bytes(self):
        """FL-39c: differential test of m4ada9f_check_bytes (original 0x4ada9f)"""
        self.run_key('4ada9f')

    def test_4b3e99_clamp_rect(self):
        """FL-39c: differential test of m4b3e99_clamp_rect (original 0x4b3e99)"""
        self.run_key('4b3e99')

    def test_4be3d3_check_bytes(self):
        """FL-39c: differential test of m4be3d3_check_bytes (original 0x4be3d3)"""
        self.run_key('4be3d3')

    def test_4be410_check_bytes(self):
        """FL-39c: differential test of m4be410_check_bytes (original 0x4be410)"""
        self.run_key('4be410')

    def test_4be44d_check_bytes(self):
        """FL-39c: differential test of m4be44d_check_bytes (original 0x4be44d)"""
        self.run_key('4be44d')

    def test_4be48a_check_bytes(self):
        """FL-39c: differential test of m4be48a_check_bytes (original 0x4be48a)"""
        self.run_key('4be48a')

    def test_4be4c7_check_bytes(self):
        """FL-39c: differential test of m4be4c7_check_bytes (original 0x4be4c7)"""
        self.run_key('4be4c7')

    def test_4be619_alloc_zero(self):
        """FL-39c: differential test of m4be619_alloc_zero (original 0x4be619)"""
        self.run_key('4be619')

    def test_4bf542_alloc_zero(self):
        """FL-39c: differential test of m4bf542_alloc_zero (original 0x4bf542)"""
        self.run_key('4bf542')

    def test_4cb8d5_get_via_out(self):
        """FL-39c: differential test of m4cb8d5_get_via_out (original 0x4cb8d5)"""
        self.run_key('4cb8d5')

    def test_4cb8fa_get_via_out(self):
        """FL-39c: differential test of m4cb8fa_get_via_out (original 0x4cb8fa)"""
        self.run_key('4cb8fa')

    def test_4cb91f_get_via_out(self):
        """FL-39c: differential test of m4cb91f_get_via_out (original 0x4cb91f)"""
        self.run_key('4cb91f')

    def test_4cc70f_alloc_zero(self):
        """FL-39c: differential test of m4cc70f_alloc_zero (original 0x4cc70f)"""
        self.run_key('4cc70f')

    def test_4d9910_alloc_zero(self):
        """FL-39c: differential test of m4d9910_alloc_zero (original 0x4d9910)"""
        self.run_key('4d9910')

    def test_4de394_copy_block(self):
        """FL-39c: differential test of m4de394_copy_block (original 0x4de394)"""
        self.run_key('4de394')

    def test_4e2d63_destroy_vector(self):
        """FL-39c: differential test of m4e2d63_destroy_vector (original 0x4e2d63)"""
        self.run_key('4e2d63')

    def test_4e3525_set_field_forward(self):
        """FL-39c: differential test of m4e3525_set_field_forward (original 0x4e3525)"""
        self.run_key('4e3525')

    def test_4e37bd_call_three_zero(self):
        """FL-39c: differential test of m4e37bd_call_three_zero (original 0x4e37bd)"""
        self.run_key('4e37bd')

    def test_4e37f8_call_three_zero(self):
        """FL-39c: differential test of m4e37f8_call_three_zero (original 0x4e37f8)"""
        self.run_key('4e37f8')

    def test_4e3833_call_three_zero(self):
        """FL-39c: differential test of m4e3833_call_three_zero (original 0x4e3833)"""
        self.run_key('4e3833')

    def test_4e7843_copy_block(self):
        """FL-39c: differential test of m4e7843_copy_block (original 0x4e7843)"""
        self.run_key('4e7843')

    def test_4e7b37_destroy_vector(self):
        """FL-39c: differential test of m4e7b37_destroy_vector (original 0x4e7b37)"""
        self.run_key('4e7b37')

    def test_4e7d2e_copy_block(self):
        """FL-39c: differential test of m4e7d2e_copy_block (original 0x4e7d2e)"""
        self.run_key('4e7d2e')

    def test_4e8994_set_field_forward(self):
        """FL-39c: differential test of m4e8994_set_field_forward (original 0x4e8994)"""
        self.run_key('4e8994')

    def test_4eb8fe_destroy_vector(self):
        """FL-39c: differential test of m4eb8fe_destroy_vector (original 0x4eb8fe)"""
        self.run_key('4eb8fe')

    def test_4ebd2e_set_field_forward(self):
        """FL-39c: differential test of m4ebd2e_set_field_forward (original 0x4ebd2e)"""
        self.run_key('4ebd2e')

    def test_4fcd4d_forward_word(self):
        """FL-39c: differential test of m4fcd4d_forward_word (original 0x4fcd4d)"""
        self.run_key('4fcd4d')

    def test_4fcd69_forward_word(self):
        """FL-39c: differential test of m4fcd69_forward_word (original 0x4fcd69)"""
        self.run_key('4fcd69')

    def test_4fcd85_forward_word(self):
        """FL-39c: differential test of m4fcd85_forward_word (original 0x4fcd85)"""
        self.run_key('4fcd85')
