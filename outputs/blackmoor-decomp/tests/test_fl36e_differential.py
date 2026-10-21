"""FL-36 (batch e) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl36e.c on the same generated
fixtures (tests/fl36e_fixtures.py builds them; the original side is fl36e_fixtures.run_original, the same function that
tests/fl36e_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl36e_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl36e_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl36eDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl36e_differential_shim.c'
    KERNELS = ['original_methods_fl36e.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl36e.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl36eWorld'

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
        self.lib.shim_fl36e(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_402945_empty_method_args(self):
        """FL-36e: differential test of m402945_empty_method_args (original 0x402945)"""
        self.run_key('402945')

    def test_40338e_empty_method_args(self):
        """FL-36e: differential test of m40338e_empty_method_args (original 0x40338e)"""
        self.run_key('40338e')

    def test_4033ab_call_two_return_const(self):
        """FL-36e: differential test of m4033ab_call_two_return_const (original 0x4033ab)"""
        self.run_key('4033ab')

    def test_404b0c_empty_method_args(self):
        """FL-36e: differential test of m404b0c_empty_method_args (original 0x404b0c)"""
        self.run_key('404b0c')

    def test_404b19_call_two_return_const(self):
        """FL-36e: differential test of m404b19_call_two_return_const (original 0x404b19)"""
        self.run_key('404b19')

    def test_407c8a_empty_method_args(self):
        """FL-36e: differential test of m407c8a_empty_method_args (original 0x407c8a)"""
        self.run_key('407c8a')

    def test_407d70_call_two_return_const(self):
        """FL-36e: differential test of m407d70_call_two_return_const (original 0x407d70)"""
        self.run_key('407d70')

    def test_40905e_empty_method_args(self):
        """FL-36e: differential test of m40905e_empty_method_args (original 0x40905e)"""
        self.run_key('40905e')

    def test_40907b_call_two_return_const(self):
        """FL-36e: differential test of m40907b_call_two_return_const (original 0x40907b)"""
        self.run_key('40907b')

    def test_414cb0_destruct_base_set_vtable(self):
        """FL-36e: differential test of m414cb0_destruct_base_set_vtable (original 0x414cb0)"""
        self.run_key('414cb0')

    def test_423450_init_vtable_ret_self(self):
        """FL-36e: differential test of m423450_init_vtable_ret_self (original 0x423450)"""
        self.run_key('423450')

    def test_423467_init_vtable_ret_self(self):
        """FL-36e: differential test of m423467_init_vtable_ret_self (original 0x423467)"""
        self.run_key('423467')

    def test_4234b5_forward_call(self):
        """FL-36e: differential test of m4234b5_forward_call (original 0x4234b5)"""
        self.run_key('4234b5')

    def test_426b5d_call_global_object(self):
        """FL-36e: differential test of m426b5d_call_global_object (original 0x426b5d)"""
        self.run_key('426b5d')

    def test_426b7e_call_global_object(self):
        """FL-36e: differential test of m426b7e_call_global_object (original 0x426b7e)"""
        self.run_key('426b7e')

    def test_43772f_init_vtable_ret_self(self):
        """FL-36e: differential test of m43772f_init_vtable_ret_self (original 0x43772f)"""
        self.run_key('43772f')

    def test_43eb3a_destruct_base_set_vtable(self):
        """FL-36e: differential test of m43eb3a_destruct_base_set_vtable (original 0x43eb3a)"""
        self.run_key('43eb3a')

    def test_43ef10_init_vtable_ret_self(self):
        """FL-36e: differential test of m43ef10_init_vtable_ret_self (original 0x43ef10)"""
        self.run_key('43ef10')

    def test_43ef27_init_vtable_ret_self(self):
        """FL-36e: differential test of m43ef27_init_vtable_ret_self (original 0x43ef27)"""
        self.run_key('43ef27')

    def test_445f40_forward_call(self):
        """FL-36e: differential test of m445f40_forward_call (original 0x445f40)"""
        self.run_key('445f40')

    def test_447d4b_set_field_const(self):
        """FL-36e: differential test of m447d4b_set_field_const (original 0x447d4b)"""
        self.run_key('447d4b')

    def test_447e27_destruct_base_set_vtable(self):
        """FL-36e: differential test of m447e27_destruct_base_set_vtable (original 0x447e27)"""
        self.run_key('447e27')

    def test_447e62_set_field_arg(self):
        """FL-36e: differential test of m447e62_set_field_arg (original 0x447e62)"""
        self.run_key('447e62')

    def test_44883f_init_vtable_ret_self(self):
        """FL-36e: differential test of m44883f_init_vtable_ret_self (original 0x44883f)"""
        self.run_key('44883f')

    def test_44885e_forward_call(self):
        """FL-36e: differential test of m44885e_forward_call (original 0x44885e)"""
        self.run_key('44885e')

    def test_44afb7_destruct_base_set_vtable(self):
        """FL-36e: differential test of m44afb7_destruct_base_set_vtable (original 0x44afb7)"""
        self.run_key('44afb7')

    def test_44be90_init_vtable_ret_self(self):
        """FL-36e: differential test of m44be90_init_vtable_ret_self (original 0x44be90)"""
        self.run_key('44be90')

    def test_44bea7_init_vtable_ret_self(self):
        """FL-36e: differential test of m44bea7_init_vtable_ret_self (original 0x44bea7)"""
        self.run_key('44bea7')

    def test_454d8a_set_word(self):
        """FL-36e: differential test of m454d8a_set_word (original 0x454d8a)"""
        self.run_key('454d8a')

    def test_456dab_set_two_words(self):
        """FL-36e: differential test of m456dab_set_two_words (original 0x456dab)"""
        self.run_key('456dab')

    def test_46401a_set_word(self):
        """FL-36e: differential test of m46401a_set_word (original 0x46401a)"""
        self.run_key('46401a')

    def test_4674ff_init_vtable_ret_self(self):
        """FL-36e: differential test of m4674ff_init_vtable_ret_self (original 0x4674ff)"""
        self.run_key('4674ff')

    def test_46b73e_set_two_words(self):
        """FL-36e: differential test of m46b73e_set_two_words (original 0x46b73e)"""
        self.run_key('46b73e')

    def test_470e71_set_two_words(self):
        """FL-36e: differential test of m470e71_set_two_words (original 0x470e71)"""
        self.run_key('470e71')

    def test_4712b0_empty_method_args(self):
        """FL-36e: differential test of m4712b0_empty_method_args (original 0x4712b0)"""
        self.run_key('4712b0')

    def test_4782be_set_two_words(self):
        """FL-36e: differential test of m4782be_set_two_words (original 0x4782be)"""
        self.run_key('4782be')

    def test_488d6a_destruct_base_set_vtable(self):
        """FL-36e: differential test of m488d6a_destruct_base_set_vtable (original 0x488d6a)"""
        self.run_key('488d6a')

    def test_48d119_set_word(self):
        """FL-36e: differential test of m48d119_set_word (original 0x48d119)"""
        self.run_key('48d119')

    def test_493ad8_set_field_const(self):
        """FL-36e: differential test of m493ad8_set_field_const (original 0x493ad8)"""
        self.run_key('493ad8')

    def test_4a7ddc_set_two_words(self):
        """FL-36e: differential test of m4a7ddc_set_two_words (original 0x4a7ddc)"""
        self.run_key('4a7ddc')

    def test_4ab459_set_word(self):
        """FL-36e: differential test of m4ab459_set_word (original 0x4ab459)"""
        self.run_key('4ab459')

    def test_4b5c48_set_word(self):
        """FL-36e: differential test of m4b5c48_set_word (original 0x4b5c48)"""
        self.run_key('4b5c48')

    def test_4bf3a4_get_field(self):
        """FL-36e: differential test of m4bf3a4_get_field (original 0x4bf3a4)"""
        self.run_key('4bf3a4')

    def test_4c0c40_get_field(self):
        """FL-36e: differential test of m4c0c40_get_field (original 0x4c0c40)"""
        self.run_key('4c0c40')

    def test_4caeef_init_vtable_ret_self(self):
        """FL-36e: differential test of m4caeef_init_vtable_ret_self (original 0x4caeef)"""
        self.run_key('4caeef')

    def test_4cc927_destruct_base_set_vtable(self):
        """FL-36e: differential test of m4cc927_destruct_base_set_vtable (original 0x4cc927)"""
        self.run_key('4cc927')

    def test_4d3705_call_global_object(self):
        """FL-36e: differential test of m4d3705_call_global_object (original 0x4d3705)"""
        self.run_key('4d3705')

    def test_4d3714_call_global_object(self):
        """FL-36e: differential test of m4d3714_call_global_object (original 0x4d3714)"""
        self.run_key('4d3714')

    def test_4d3c1d_get_field(self):
        """FL-36e: differential test of m4d3c1d_get_field (original 0x4d3c1d)"""
        self.run_key('4d3c1d')

    def test_4d51ea_empty_method_args(self):
        """FL-36e: differential test of m4d51ea_empty_method_args (original 0x4d51ea)"""
        self.run_key('4d51ea')

    def test_4d52a6_forward_call(self):
        """FL-36e: differential test of m4d52a6_forward_call (original 0x4d52a6)"""
        self.run_key('4d52a6')

    def test_4dae66_get_field(self):
        """FL-36e: differential test of m4dae66_get_field (original 0x4dae66)"""
        self.run_key('4dae66')

    def test_4dae77_get_field(self):
        """FL-36e: differential test of m4dae77_get_field (original 0x4dae77)"""
        self.run_key('4dae77')

    def test_4daef1_get_field(self):
        """FL-36e: differential test of m4daef1_get_field (original 0x4daef1)"""
        self.run_key('4daef1')

    def test_4daf02_set_field_arg(self):
        """FL-36e: differential test of m4daf02_set_field_arg (original 0x4daf02)"""
        self.run_key('4daf02')

    def test_4daf18_get_field(self):
        """FL-36e: differential test of m4daf18_get_field (original 0x4daf18)"""
        self.run_key('4daf18')

    def test_4daf29_set_field_arg(self):
        """FL-36e: differential test of m4daf29_set_field_arg (original 0x4daf29)"""
        self.run_key('4daf29')

    def test_4db377_forward_call(self):
        """FL-36e: differential test of m4db377_forward_call (original 0x4db377)"""
        self.run_key('4db377')

    def test_4dd3f6_forward_call(self):
        """FL-36e: differential test of m4dd3f6_forward_call (original 0x4dd3f6)"""
        self.run_key('4dd3f6')

    def test_4e0742_set_field_const(self):
        """FL-36e: differential test of m4e0742_set_field_const (original 0x4e0742)"""
        self.run_key('4e0742')

    def test_4e2940_set_field_arg(self):
        """FL-36e: differential test of m4e2940_set_field_arg (original 0x4e2940)"""
        self.run_key('4e2940')

    def test_4e2956_get_field(self):
        """FL-36e: differential test of m4e2956_get_field (original 0x4e2956)"""
        self.run_key('4e2956')

    def test_4e2967_get_field(self):
        """FL-36e: differential test of m4e2967_get_field (original 0x4e2967)"""
        self.run_key('4e2967')

    def test_4e2978_set_field_const(self):
        """FL-36e: differential test of m4e2978_set_field_const (original 0x4e2978)"""
        self.run_key('4e2978')

    def test_4e2990_set_field_arg(self):
        """FL-36e: differential test of m4e2990_set_field_arg (original 0x4e2990)"""
        self.run_key('4e2990')

    def test_4e29a6_get_field(self):
        """FL-36e: differential test of m4e29a6_get_field (original 0x4e29a6)"""
        self.run_key('4e29a6')

    def test_4e40fb_forward_call_arg(self):
        """FL-36e: differential test of m4e40fb_forward_call_arg (original 0x4e40fb)"""
        self.run_key('4e40fb')

    def test_4e4114_forward_call_arg(self):
        """FL-36e: differential test of m4e4114_forward_call_arg (original 0x4e4114)"""
        self.run_key('4e4114')

    def test_4e779f_forward_call_arg(self):
        """FL-36e: differential test of m4e779f_forward_call_arg (original 0x4e779f)"""
        self.run_key('4e779f')

    def test_4e89b9_forward_call_arg(self):
        """FL-36e: differential test of m4e89b9_forward_call_arg (original 0x4e89b9)"""
        self.run_key('4e89b9')

    def test_4e89d2_forward_call_arg(self):
        """FL-36e: differential test of m4e89d2_forward_call_arg (original 0x4e89d2)"""
        self.run_key('4e89d2')

    def test_4e9e6c_set_field_const(self):
        """FL-36e: differential test of m4e9e6c_set_field_const (original 0x4e9e6c)"""
        self.run_key('4e9e6c')

    def test_4ebd53_forward_call_arg(self):
        """FL-36e: differential test of m4ebd53_forward_call_arg (original 0x4ebd53)"""
        self.run_key('4ebd53')

    def test_4ebd6c_forward_call_arg(self):
        """FL-36e: differential test of m4ebd6c_forward_call_arg (original 0x4ebd6c)"""
        self.run_key('4ebd6c')

    def test_4ee602_get_field(self):
        """FL-36e: differential test of m4ee602_get_field (original 0x4ee602)"""
        self.run_key('4ee602')

    def test_4ee630_get_field(self):
        """FL-36e: differential test of m4ee630_get_field (original 0x4ee630)"""
        self.run_key('4ee630')

    def test_4ef4c9_set_field_arg(self):
        """FL-36e: differential test of m4ef4c9_set_field_arg (original 0x4ef4c9)"""
        self.run_key('4ef4c9')

    def test_4ef4df_get_field(self):
        """FL-36e: differential test of m4ef4df_get_field (original 0x4ef4df)"""
        self.run_key('4ef4df')

    def test_4ef516_get_field(self):
        """FL-36e: differential test of m4ef516_get_field (original 0x4ef516)"""
        self.run_key('4ef516')

    def test_4f0046_forward_call(self):
        """FL-36e: differential test of m4f0046_forward_call (original 0x4f0046)"""
        self.run_key('4f0046')


if __name__ == '__main__':
    unittest.main()
