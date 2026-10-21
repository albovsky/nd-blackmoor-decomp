"""FL-35 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl35a.c on the same generated
fixtures (tests/fl35a_fixtures.py builds them; the original side is fl35a_fixtures.run_original, the same function that
tests/fl35a_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl35a_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl35a_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl35aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl35a_differential_shim.c'
    KERNELS = ['original_methods_fl35a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl35a.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl35aWorld'

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
        self.lib.shim_fl35a(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_40a5c1_read_tag_word(self):
        """FL-35a: differential test of m40a5c1_read_tag_word (original 0x40a5c1)"""
        self.run_key('40a5c1')

    def test_40a6b7_read_tag_word(self):
        """FL-35a: differential test of m40a6b7_read_tag_word (original 0x40a6b7)"""
        self.run_key('40a6b7')

    def test_40a709_read_tag_word(self):
        """FL-35a: differential test of m40a709_read_tag_word (original 0x40a709)"""
        self.run_key('40a709')

    def test_40a75b_read_tag_word(self):
        """FL-35a: differential test of m40a75b_read_tag_word (original 0x40a75b)"""
        self.run_key('40a75b')

    def test_40a7ad_read_tag_word(self):
        """FL-35a: differential test of m40a7ad_read_tag_word (original 0x40a7ad)"""
        self.run_key('40a7ad')

    def test_40a7ff_read_tag_word(self):
        """FL-35a: differential test of m40a7ff_read_tag_word (original 0x40a7ff)"""
        self.run_key('40a7ff')

    def test_40a851_read_tag_word(self):
        """FL-35a: differential test of m40a851_read_tag_word (original 0x40a851)"""
        self.run_key('40a851')

    def test_40a8a3_read_tag_word(self):
        """FL-35a: differential test of m40a8a3_read_tag_word (original 0x40a8a3)"""
        self.run_key('40a8a3')

    def test_40a8f5_read_tag_word(self):
        """FL-35a: differential test of m40a8f5_read_tag_word (original 0x40a8f5)"""
        self.run_key('40a8f5')

    def test_40a947_read_tag_word(self):
        """FL-35a: differential test of m40a947_read_tag_word (original 0x40a947)"""
        self.run_key('40a947')

    def test_40a999_read_tag_word(self):
        """FL-35a: differential test of m40a999_read_tag_word (original 0x40a999)"""
        self.run_key('40a999')

    def test_40a9eb_read_tag_word(self):
        """FL-35a: differential test of m40a9eb_read_tag_word (original 0x40a9eb)"""
        self.run_key('40a9eb')

    def test_40aa3d_read_tag_word(self):
        """FL-35a: differential test of m40aa3d_read_tag_word (original 0x40aa3d)"""
        self.run_key('40aa3d')

    def test_40aa8f_read_tag_word(self):
        """FL-35a: differential test of m40aa8f_read_tag_word (original 0x40aa8f)"""
        self.run_key('40aa8f')

    def test_40aae1_read_tag_word(self):
        """FL-35a: differential test of m40aae1_read_tag_word (original 0x40aae1)"""
        self.run_key('40aae1')

    def test_40ab33_read_tag_word(self):
        """FL-35a: differential test of m40ab33_read_tag_word (original 0x40ab33)"""
        self.run_key('40ab33')

    def test_40ab85_read_tag_word(self):
        """FL-35a: differential test of m40ab85_read_tag_word (original 0x40ab85)"""
        self.run_key('40ab85')

    def test_40abd7_read_tag_word(self):
        """FL-35a: differential test of m40abd7_read_tag_word (original 0x40abd7)"""
        self.run_key('40abd7')

    def test_40ac29_read_tag_word(self):
        """FL-35a: differential test of m40ac29_read_tag_word (original 0x40ac29)"""
        self.run_key('40ac29')

    def test_40ac7b_read_tag_word(self):
        """FL-35a: differential test of m40ac7b_read_tag_word (original 0x40ac7b)"""
        self.run_key('40ac7b')

    def test_40accd_read_tag_word(self):
        """FL-35a: differential test of m40accd_read_tag_word (original 0x40accd)"""
        self.run_key('40accd')

    def test_40ad1f_read_tag_word(self):
        """FL-35a: differential test of m40ad1f_read_tag_word (original 0x40ad1f)"""
        self.run_key('40ad1f')

    def test_40ad71_read_tag_word(self):
        """FL-35a: differential test of m40ad71_read_tag_word (original 0x40ad71)"""
        self.run_key('40ad71')

    def test_40adc3_read_tag_word(self):
        """FL-35a: differential test of m40adc3_read_tag_word (original 0x40adc3)"""
        self.run_key('40adc3')

    def test_40ae15_read_tag_word(self):
        """FL-35a: differential test of m40ae15_read_tag_word (original 0x40ae15)"""
        self.run_key('40ae15')

    def test_40ae67_read_tag_word(self):
        """FL-35a: differential test of m40ae67_read_tag_word (original 0x40ae67)"""
        self.run_key('40ae67')

    def test_40aeb9_read_tag_word(self):
        """FL-35a: differential test of m40aeb9_read_tag_word (original 0x40aeb9)"""
        self.run_key('40aeb9')

    def test_40af0b_read_tag_word(self):
        """FL-35a: differential test of m40af0b_read_tag_word (original 0x40af0b)"""
        self.run_key('40af0b')



if __name__ == '__main__':
    unittest.main()
