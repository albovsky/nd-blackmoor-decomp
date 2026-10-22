"""FL-39 (batch e) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl39e.c on the same generated
fixtures (tests/fl39e_fixtures.py builds them; the original side is fl39e_fixtures.run_original, the same function that
tests/fl39e_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl39e_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl39e_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl39eDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl39e_differential_shim.c'
    KERNELS = ['original_methods_fl39e.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl39e.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl39eWorld'

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
        self.lib.shim_fl39e(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_487b1a_init_fields5(self):
        """FL-39e: differential test of m487b1a_init_fields5 (original 0x487b1a)"""
        self.run_key('487b1a')

    def test_48e2f5_release_word(self):
        """FL-39e: differential test of m48e2f5_release_word (original 0x48e2f5)"""
        self.run_key('48e2f5')

    def test_49c5f0_zero_fields11(self):
        """FL-39e: differential test of m49c5f0_zero_fields11 (original 0x49c5f0)"""
        self.run_key('49c5f0')

    def test_4a1b12_get_constant(self):
        """FL-39e: differential test of m4a1b12_get_constant (original 0x4a1b12)"""
        self.run_key('4a1b12')

    def test_4a1c47_init_fields11(self):
        """FL-39e: differential test of m4a1c47_init_fields11 (original 0x4a1c47)"""
        self.run_key('4a1c47')

    def test_4a1cb1_release_word(self):
        """FL-39e: differential test of m4a1cb1_release_word (original 0x4a1cb1)"""
        self.run_key('4a1cb1')

    def test_4ab3a7_init_fields5(self):
        """FL-39e: differential test of m4ab3a7_init_fields5 (original 0x4ab3a7)"""
        self.run_key('4ab3a7')

    def test_4ae452_copy_sub_dword(self):
        """FL-39e: differential test of m4ae452_copy_sub_dword (original 0x4ae452)"""
        self.run_key('4ae452')

    def test_4ae495_copy_sub_dword(self):
        """FL-39e: differential test of m4ae495_copy_sub_dword (original 0x4ae495)"""
        self.run_key('4ae495')

    def test_4c87ba_fill_stride(self):
        """FL-39e: differential test of m4c87ba_fill_stride (original 0x4c87ba)"""
        self.run_key('4c87ba')

    def test_4c8872_fill_stride(self):
        """FL-39e: differential test of m4c8872_fill_stride (original 0x4c8872)"""
        self.run_key('4c8872')

    def test_4cca42_forward_struct(self):
        """FL-39e: differential test of m4cca42_forward_struct (original 0x4cca42)"""
        self.run_key('4cca42')

    def test_4cca6f_forward_struct(self):
        """FL-39e: differential test of m4cca6f_forward_struct (original 0x4cca6f)"""
        self.run_key('4cca6f')

    def test_4ccd25_get_constant(self):
        """FL-39e: differential test of m4ccd25_get_constant (original 0x4ccd25)"""
        self.run_key('4ccd25')

    def test_4d0b68_log_loop(self):
        """FL-39e: differential test of m4d0b68_log_loop (original 0x4d0b68)"""
        self.run_key('4d0b68')

    def test_4d0c57_log_loop(self):
        """FL-39e: differential test of m4d0c57_log_loop (original 0x4d0c57)"""
        self.run_key('4d0c57')

    def test_4d3728_log_three(self):
        """FL-39e: differential test of m4d3728_log_three (original 0x4d3728)"""
        self.run_key('4d3728')

    def test_4d37af_log_three(self):
        """FL-39e: differential test of m4d37af_log_three (original 0x4d37af)"""
        self.run_key('4d37af')

    def test_4de227_call_pair(self):
        """FL-39e: differential test of m4de227_call_pair (original 0x4de227)"""
        self.run_key('4de227')

    def test_4de413_call_unless_01(self):
        """FL-39e: differential test of m4de413_call_unless_01 (original 0x4de413)"""
        self.run_key('4de413')

    def test_4de584_call_unless_01(self):
        """FL-39e: differential test of m4de584_call_unless_01 (original 0x4de584)"""
        self.run_key('4de584')

    def test_4de66e_destroy_subobjects(self):
        """FL-39e: differential test of m4de66e_destroy_subobjects (original 0x4de66e)"""
        self.run_key('4de66e')

    def test_4e053f_set_field_sx(self):
        """FL-39e: differential test of m4e053f_set_field_sx (original 0x4e053f)"""
        self.run_key('4e053f')

    def test_4e1113_log_guarded(self):
        """FL-39e: differential test of m4e1113_log_guarded (original 0x4e1113)"""
        self.run_key('4e1113')

    def test_4e1157_log_guarded(self):
        """FL-39e: differential test of m4e1157_log_guarded (original 0x4e1157)"""
        self.run_key('4e1157')

    def test_4e7700_call_pair(self):
        """FL-39e: differential test of m4e7700_call_pair (original 0x4e7700)"""
        self.run_key('4e7700')

    def test_4e7a10_call_unless_01(self):
        """FL-39e: differential test of m4e7a10_call_unless_01 (original 0x4e7a10)"""
        self.run_key('4e7a10')

    def test_4eda7c_destroy_subobjects(self):
        """FL-39e: differential test of m4eda7c_destroy_subobjects (original 0x4eda7c)"""
        self.run_key('4eda7c')

    def test_4ee5b8_store_global(self):
        """FL-39e: differential test of m4ee5b8_store_global (original 0x4ee5b8)"""
        self.run_key('4ee5b8')

    def test_4ee5dd_store_global(self):
        """FL-39e: differential test of m4ee5dd_store_global (original 0x4ee5dd)"""
        self.run_key('4ee5dd')

    def test_4ee616_set_field_sx(self):
        """FL-39e: differential test of m4ee616_set_field_sx (original 0x4ee616)"""
        self.run_key('4ee616')

    def test_4f872e_forward_fields(self):
        """FL-39e: differential test of m4f872e_forward_fields (original 0x4f872e)"""
        self.run_key('4f872e')

    def test_4f88ad_forward_fields(self):
        """FL-39e: differential test of m4f88ad_forward_fields (original 0x4f88ad)"""
        self.run_key('4f88ad')

    def test_4fc909_check_trace(self):
        """FL-39e: differential test of m4fc909_check_trace (original 0x4fc909)"""
        self.run_key('4fc909')

    def test_4fc97d_check_trace(self):
        """FL-39e: differential test of m4fc97d_check_trace (original 0x4fc97d)"""
        self.run_key('4fc97d')
