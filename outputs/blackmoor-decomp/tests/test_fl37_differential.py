"""FL-37 differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl37.c on the same generated
fixtures (tests/fl37_fixtures.py builds them; the original side is fl37_fixtures.run_original, the same function that
tests/fl37_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl37_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl37_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl37Differential(DiffBase):
    SHIM = PROJECT / 'tests/fl37_differential_shim.c'
    KERNELS = ['original_methods_fl37.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl37.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl37World'

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
        self.lib.shim_fl37(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_406b3f_toggle_5e353e(self):
        """FL-37: differential test of m406b3f_toggle_5e353e (original 0x406b3f)"""
        self.run_key('406b3f')

    def test_406b86_toggle_5e3542(self):
        """FL-37: differential test of m406b86_toggle_5e3542 (original 0x406b86)"""
        self.run_key('406b86')

    def test_406bcd_toggle_5e3546(self):
        """FL-37: differential test of m406bcd_toggle_5e3546 (original 0x406bcd)"""
        self.run_key('406bcd')

    def test_406c14_toggle_5e354a(self):
        """FL-37: differential test of m406c14_toggle_5e354a (original 0x406c14)"""
        self.run_key('406c14')

    def test_406c5b_toggle_5e354e(self):
        """FL-37: differential test of m406c5b_toggle_5e354e (original 0x406c5b)"""
        self.run_key('406c5b')

    def test_406ca2_toggle_5e3552(self):
        """FL-37: differential test of m406ca2_toggle_5e3552 (original 0x406ca2)"""
        self.run_key('406ca2')

    def test_406ce9_toggle_5e3556(self):
        """FL-37: differential test of m406ce9_toggle_5e3556 (original 0x406ce9)"""
        self.run_key('406ce9')

    def test_406d30_toggle_5e355a(self):
        """FL-37: differential test of m406d30_toggle_5e355a (original 0x406d30)"""
        self.run_key('406d30')

    def test_406d77_toggle_5e355e(self):
        """FL-37: differential test of m406d77_toggle_5e355e (original 0x406d77)"""
        self.run_key('406d77')

    def test_406dbe_toggle_5e3562(self):
        """FL-37: differential test of m406dbe_toggle_5e3562 (original 0x406dbe)"""
        self.run_key('406dbe')

    def test_406e05_toggle_5e3566(self):
        """FL-37: differential test of m406e05_toggle_5e3566 (original 0x406e05)"""
        self.run_key('406e05')

    def test_406e4c_toggle_5e356a(self):
        """FL-37: differential test of m406e4c_toggle_5e356a (original 0x406e4c)"""
        self.run_key('406e4c')

    def test_406e93_toggle_5e356e(self):
        """FL-37: differential test of m406e93_toggle_5e356e (original 0x406e93)"""
        self.run_key('406e93')

    def test_406eda_toggle_5e3572(self):
        """FL-37: differential test of m406eda_toggle_5e3572 (original 0x406eda)"""
        self.run_key('406eda')

    def test_406f21_toggle_5e3576(self):
        """FL-37: differential test of m406f21_toggle_5e3576 (original 0x406f21)"""
        self.run_key('406f21')

    def test_406f68_toggle_5e357a(self):
        """FL-37: differential test of m406f68_toggle_5e357a (original 0x406f68)"""
        self.run_key('406f68')

    def test_406faf_toggle_5e357e(self):
        """FL-37: differential test of m406faf_toggle_5e357e (original 0x406faf)"""
        self.run_key('406faf')

    def test_406ff6_toggle_5e3582(self):
        """FL-37: differential test of m406ff6_toggle_5e3582 (original 0x406ff6)"""
        self.run_key('406ff6')

    def test_40703d_toggle_5e3586(self):
        """FL-37: differential test of m40703d_toggle_5e3586 (original 0x40703d)"""
        self.run_key('40703d')

    def test_407084_toggle_5e358a(self):
        """FL-37: differential test of m407084_toggle_5e358a (original 0x407084)"""
        self.run_key('407084')

    def test_4070cb_toggle_5e358e(self):
        """FL-37: differential test of m4070cb_toggle_5e358e (original 0x4070cb)"""
        self.run_key('4070cb')

    def test_407112_toggle_5e3592(self):
        """FL-37: differential test of m407112_toggle_5e3592 (original 0x407112)"""
        self.run_key('407112')

    def test_407159_toggle_5e3596(self):
        """FL-37: differential test of m407159_toggle_5e3596 (original 0x407159)"""
        self.run_key('407159')

    def test_4071a0_toggle_5e359a(self):
        """FL-37: differential test of m4071a0_toggle_5e359a (original 0x4071a0)"""
        self.run_key('4071a0')

    def test_4071e7_toggle_5e359e(self):
        """FL-37: differential test of m4071e7_toggle_5e359e (original 0x4071e7)"""
        self.run_key('4071e7')

    def test_40722e_toggle_5e35a2(self):
        """FL-37: differential test of m40722e_toggle_5e35a2 (original 0x40722e)"""
        self.run_key('40722e')

    def test_407275_toggle_5e35a6(self):
        """FL-37: differential test of m407275_toggle_5e35a6 (original 0x407275)"""
        self.run_key('407275')

    def test_4072bc_toggle_5e35aa(self):
        """FL-37: differential test of m4072bc_toggle_5e35aa (original 0x4072bc)"""
        self.run_key('4072bc')

    def test_407303_toggle_5e35ae(self):
        """FL-37: differential test of m407303_toggle_5e35ae (original 0x407303)"""
        self.run_key('407303')

    def test_40734a_toggle_5e35b2(self):
        """FL-37: differential test of m40734a_toggle_5e35b2 (original 0x40734a)"""
        self.run_key('40734a')

    def test_407391_toggle_5e35b6(self):
        """FL-37: differential test of m407391_toggle_5e35b6 (original 0x407391)"""
        self.run_key('407391')

    def test_4073d8_toggle_5e35ba(self):
        """FL-37: differential test of m4073d8_toggle_5e35ba (original 0x4073d8)"""
        self.run_key('4073d8')

    def test_40741f_toggle_5e35be(self):
        """FL-37: differential test of m40741f_toggle_5e35be (original 0x40741f)"""
        self.run_key('40741f')

    def test_407466_toggle_5e35c2(self):
        """FL-37: differential test of m407466_toggle_5e35c2 (original 0x407466)"""
        self.run_key('407466')

    def test_4074ad_toggle_5e35c6(self):
        """FL-37: differential test of m4074ad_toggle_5e35c6 (original 0x4074ad)"""
        self.run_key('4074ad')

    def test_4074f4_toggle_5e35ca(self):
        """FL-37: differential test of m4074f4_toggle_5e35ca (original 0x4074f4)"""
        self.run_key('4074f4')

    def test_40753b_toggle_5e35ce(self):
        """FL-37: differential test of m40753b_toggle_5e35ce (original 0x40753b)"""
        self.run_key('40753b')

    def test_407582_toggle_5e35d2(self):
        """FL-37: differential test of m407582_toggle_5e35d2 (original 0x407582)"""
        self.run_key('407582')

    def test_4075c9_toggle_5e35d6(self):
        """FL-37: differential test of m4075c9_toggle_5e35d6 (original 0x4075c9)"""
        self.run_key('4075c9')

    def test_407610_toggle_5e35da(self):
        """FL-37: differential test of m407610_toggle_5e35da (original 0x407610)"""
        self.run_key('407610')

    def test_407657_toggle_5e35de(self):
        """FL-37: differential test of m407657_toggle_5e35de (original 0x407657)"""
        self.run_key('407657')

    def test_40769e_toggle_5e35e2(self):
        """FL-37: differential test of m40769e_toggle_5e35e2 (original 0x40769e)"""
        self.run_key('40769e')

    def test_4076e5_toggle_5e35e6(self):
        """FL-37: differential test of m4076e5_toggle_5e35e6 (original 0x4076e5)"""
        self.run_key('4076e5')

    def test_40772c_toggle_5e35ea(self):
        """FL-37: differential test of m40772c_toggle_5e35ea (original 0x40772c)"""
        self.run_key('40772c')

    def test_407773_toggle_5e35ee(self):
        """FL-37: differential test of m407773_toggle_5e35ee (original 0x407773)"""
        self.run_key('407773')

    def test_4077ba_toggle_5e35f2(self):
        """FL-37: differential test of m4077ba_toggle_5e35f2 (original 0x4077ba)"""
        self.run_key('4077ba')

    def test_407801_toggle_5e35f6(self):
        """FL-37: differential test of m407801_toggle_5e35f6 (original 0x407801)"""
        self.run_key('407801')

    def test_407848_toggle_5e35fa(self):
        """FL-37: differential test of m407848_toggle_5e35fa (original 0x407848)"""
        self.run_key('407848')

    def test_40788f_toggle_5e35fe(self):
        """FL-37: differential test of m40788f_toggle_5e35fe (original 0x40788f)"""
        self.run_key('40788f')

    def test_4078d6_toggle_5e3602(self):
        """FL-37: differential test of m4078d6_toggle_5e3602 (original 0x4078d6)"""
        self.run_key('4078d6')

    def test_40791d_toggle_5e3606(self):
        """FL-37: differential test of m40791d_toggle_5e3606 (original 0x40791d)"""
        self.run_key('40791d')

    def test_407964_toggle_5e360a(self):
        """FL-37: differential test of m407964_toggle_5e360a (original 0x407964)"""
        self.run_key('407964')

    def test_4079ab_toggle_5e360e(self):
        """FL-37: differential test of m4079ab_toggle_5e360e (original 0x4079ab)"""
        self.run_key('4079ab')

    def test_4079f2_toggle_5e3612(self):
        """FL-37: differential test of m4079f2_toggle_5e3612 (original 0x4079f2)"""
        self.run_key('4079f2')

    def test_407a39_toggle_5e3616(self):
        """FL-37: differential test of m407a39_toggle_5e3616 (original 0x407a39)"""
        self.run_key('407a39')

    def test_407a80_toggle_5e361a(self):
        """FL-37: differential test of m407a80_toggle_5e361a (original 0x407a80)"""
        self.run_key('407a80')

    def test_407ac7_toggle_5e361e(self):
        """FL-37: differential test of m407ac7_toggle_5e361e (original 0x407ac7)"""
        self.run_key('407ac7')

    # CASES-END


if __name__ == '__main__':
    unittest.main()
