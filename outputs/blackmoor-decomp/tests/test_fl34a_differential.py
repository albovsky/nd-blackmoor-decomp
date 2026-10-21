"""FL-34 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl34a.c on the same generated
fixtures (tests/fl34a_fixtures.py builds them; the original side is fl34a_fixtures.run_original, the same function that
tests/fl34a_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl34a_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl34a_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl34aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl34a_differential_shim.c'
    KERNELS = ['original_methods_fl34a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl34a.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl34aWorld'

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
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in sc.args])
        self.lib.shim_fl34a(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        if fx.SPECS[sc.key].get('retself'):
            self.assertEqual(result.value, 0, 'the constructor must return self')
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

    def test_402962_toggle_5e60d6(self):
        """FL-34a: differential test of m402962_toggle_5e60d6 (original 0x402962)"""
        self.run_key('402962')

    def test_402a7e_toggle_5e60e6(self):
        """FL-34a: differential test of m402a7e_toggle_5e60e6 (original 0x402a7e)"""
        self.run_key('402a7e')

    def test_402ac5_toggle_5e60ea(self):
        """FL-34a: differential test of m402ac5_toggle_5e60ea (original 0x402ac5)"""
        self.run_key('402ac5')

    def test_402b0c_toggle_5e60ee(self):
        """FL-34a: differential test of m402b0c_toggle_5e60ee (original 0x402b0c)"""
        self.run_key('402b0c')

    def test_402b53_toggle_5e60f2(self):
        """FL-34a: differential test of m402b53_toggle_5e60f2 (original 0x402b53)"""
        self.run_key('402b53')

    def test_402b9a_toggle_5e60f6(self):
        """FL-34a: differential test of m402b9a_toggle_5e60f6 (original 0x402b9a)"""
        self.run_key('402b9a')

    def test_402be1_toggle_5e60fa(self):
        """FL-34a: differential test of m402be1_toggle_5e60fa (original 0x402be1)"""
        self.run_key('402be1')

    def test_402c28_toggle_5e60fe(self):
        """FL-34a: differential test of m402c28_toggle_5e60fe (original 0x402c28)"""
        self.run_key('402c28')

    def test_402c6f_toggle_5e6102(self):
        """FL-34a: differential test of m402c6f_toggle_5e6102 (original 0x402c6f)"""
        self.run_key('402c6f')

    def test_402cb6_toggle_5e6106(self):
        """FL-34a: differential test of m402cb6_toggle_5e6106 (original 0x402cb6)"""
        self.run_key('402cb6')

    def test_402cfd_toggle_5e610a(self):
        """FL-34a: differential test of m402cfd_toggle_5e610a (original 0x402cfd)"""
        self.run_key('402cfd')

    def test_402d44_toggle_5e610e(self):
        """FL-34a: differential test of m402d44_toggle_5e610e (original 0x402d44)"""
        self.run_key('402d44')

    def test_402d8b_toggle_5e6112(self):
        """FL-34a: differential test of m402d8b_toggle_5e6112 (original 0x402d8b)"""
        self.run_key('402d8b')

    def test_402dd2_toggle_5e6116(self):
        """FL-34a: differential test of m402dd2_toggle_5e6116 (original 0x402dd2)"""
        self.run_key('402dd2')

    def test_402e19_toggle_5e611a(self):
        """FL-34a: differential test of m402e19_toggle_5e611a (original 0x402e19)"""
        self.run_key('402e19')

    def test_402e60_toggle_5e611e(self):
        """FL-34a: differential test of m402e60_toggle_5e611e (original 0x402e60)"""
        self.run_key('402e60')

    def test_402ea7_toggle_5e6122(self):
        """FL-34a: differential test of m402ea7_toggle_5e6122 (original 0x402ea7)"""
        self.run_key('402ea7')

    def test_402eee_toggle_5e6126(self):
        """FL-34a: differential test of m402eee_toggle_5e6126 (original 0x402eee)"""
        self.run_key('402eee')

    def test_402f35_toggle_5e612a(self):
        """FL-34a: differential test of m402f35_toggle_5e612a (original 0x402f35)"""
        self.run_key('402f35')

    def test_402f7c_toggle_5e612e(self):
        """FL-34a: differential test of m402f7c_toggle_5e612e (original 0x402f7c)"""
        self.run_key('402f7c')

    def test_402fc3_toggle_5e6132(self):
        """FL-34a: differential test of m402fc3_toggle_5e6132 (original 0x402fc3)"""
        self.run_key('402fc3')

    # CASES-END


if __name__ == '__main__':
    unittest.main()
