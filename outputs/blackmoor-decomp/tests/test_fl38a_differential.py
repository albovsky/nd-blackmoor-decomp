"""FL-38 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl38a.c on the same generated
fixtures (tests/fl38a_fixtures.py builds them; the original side is fl38a_fixtures.run_original, the same function that
tests/fl38a_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl38a_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl38a_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl38aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl38a_differential_shim.c'
    KERNELS = ['original_methods_fl38a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl38a.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl38aWorld'

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
        self.lib.shim_fl38a(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_414c6d_get_constant(self):
        """FL-38a: differential test of m414c6d_get_constant (original 0x414c6d)"""
        self.run_key('414c6d')

    def test_447cc4_get_constant(self):
        """FL-38a: differential test of m447cc4_get_constant (original 0x447cc4)"""
        self.run_key('447cc4')

    def test_4487de_get_constant(self):
        """FL-38a: differential test of m4487de_get_constant (original 0x4487de)"""
        self.run_key('4487de')

    def test_44be44_get_constant(self):
        """FL-38a: differential test of m44be44_get_constant (original 0x44be44)"""
        self.run_key('44be44')

    def test_4542b5_check_no_sound_call(self):
        """FL-38a: differential test of m4542b5_check_no_sound_call (original 0x4542b5)"""
        self.run_key('4542b5')

    def test_4542f2_check_no_sound_call(self):
        """FL-38a: differential test of m4542f2_check_no_sound_call (original 0x4542f2)"""
        self.run_key('4542f2')

    def test_45441d_check_no_sound_call(self):
        """FL-38a: differential test of m45441d_check_no_sound_call (original 0x45441d)"""
        self.run_key('45441d')

    def test_454de6_release_surface_clear_call_tail(self):
        """FL-38a: differential test of m454de6_release_surface_clear_call_tail (original 0x454de6)"""
        self.run_key('454de6')

    def test_454e39_guard_set_table_flag(self):
        """FL-38a: differential test of m454e39_guard_set_table_flag (original 0x454e39)"""
        self.run_key('454e39')

    def test_456d2e_release_surface_call_tail(self):
        """FL-38a: differential test of m456d2e_release_surface_call_tail (original 0x456d2e)"""
        self.run_key('456d2e')

    def test_456d77_guard_set_table_flag(self):
        """FL-38a: differential test of m456d77_guard_set_table_flag (original 0x456d77)"""
        self.run_key('456d77')

    def test_457fc2_release_surface_clear_call_tail(self):
        """FL-38a: differential test of m457fc2_release_surface_clear_call_tail (original 0x457fc2)"""
        self.run_key('457fc2')

    def test_458045_guard_set_table_flag(self):
        """FL-38a: differential test of m458045_guard_set_table_flag (original 0x458045)"""
        self.run_key('458045')

    def test_459b87_release_surface_call_tail(self):
        """FL-38a: differential test of m459b87_release_surface_call_tail (original 0x459b87)"""
        self.run_key('459b87')

    def test_45dd4d_release_surface_call_tail(self):
        """FL-38a: differential test of m45dd4d_release_surface_call_tail (original 0x45dd4d)"""
        self.run_key('45dd4d')

    def test_464076_release_surface_clear_call_tail(self):
        """FL-38a: differential test of m464076_release_surface_clear_call_tail (original 0x464076)"""
        self.run_key('464076')

    def test_4640c9_guard_set_table_flag(self):
        """FL-38a: differential test of m4640c9_guard_set_table_flag (original 0x4640c9)"""
        self.run_key('4640c9')

    def test_465b9f_guard_set_table_flag(self):
        """FL-38a: differential test of m465b9f_guard_set_table_flag (original 0x465b9f)"""
        self.run_key('465b9f')

    def test_467651_guard_set_table_flag(self):
        """FL-38a: differential test of m467651_guard_set_table_flag (original 0x467651)"""
        self.run_key('467651')

    def test_468f19_release_surface_call_tail(self):
        """FL-38a: differential test of m468f19_release_surface_call_tail (original 0x468f19)"""
        self.run_key('468f19')

    def test_468f68_guard_set_table_flag(self):
        """FL-38a: differential test of m468f68_guard_set_table_flag (original 0x468f68)"""
        self.run_key('468f68')

    def test_46b707_guard_set_table_flag(self):
        """FL-38a: differential test of m46b707_guard_set_table_flag (original 0x46b707)"""
        self.run_key('46b707')

    def test_46e7a6_release_surface_call_tail(self):
        """FL-38a: differential test of m46e7a6_release_surface_call_tail (original 0x46e7a6)"""
        self.run_key('46e7a6')

    def test_46e7ef_guard_set_table_flag(self):
        """FL-38a: differential test of m46e7ef_guard_set_table_flag (original 0x46e7ef)"""
        self.run_key('46e7ef')

    def test_470ddc_release_surface_call_tail(self):
        """FL-38a: differential test of m470ddc_release_surface_call_tail (original 0x470ddc)"""
        self.run_key('470ddc')

    def test_47823e_release_surface_call_tail(self):
        """FL-38a: differential test of m47823e_release_surface_call_tail (original 0x47823e)"""
        self.run_key('47823e')

    def test_478287_guard_set_table_flag(self):
        """FL-38a: differential test of m478287_guard_set_table_flag (original 0x478287)"""
        self.run_key('478287')


if __name__ == '__main__':
    unittest.main()
