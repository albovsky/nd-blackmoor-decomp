"""FL-35 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl35b.c on the same generated
fixtures (tests/fl35b_fixtures.py builds them; the original side is fl35b_fixtures.run_original, the same function that
tests/fl35b_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl35b_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl35b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl35bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl35b_differential_shim.c'
    KERNELS = ['original_methods_fl35b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl35b.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl35bWorld'

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
        self.lib.shim_fl35b(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_4080fc_toggle_5ec28c(self):
        """FL-35b: differential test of m4080fc_toggle_5ec28c (original 0x4080fc)"""
        self.run_key('4080fc')

    def test_40812e_read_text_word(self):
        """FL-35b: differential test of m40812e_read_text_word (original 0x40812e)"""
        self.run_key('40812e')

    def test_408169_read_text_word(self):
        """FL-35b: differential test of m408169_read_text_word (original 0x408169)"""
        self.run_key('408169')

    def test_4081a4_read_text_word(self):
        """FL-35b: differential test of m4081a4_read_text_word (original 0x4081a4)"""
        self.run_key('4081a4')

    def test_4081df_read_text_word(self):
        """FL-35b: differential test of m4081df_read_text_word (original 0x4081df)"""
        self.run_key('4081df')

    def test_40821a_read_text_word(self):
        """FL-35b: differential test of m40821a_read_text_word (original 0x40821a)"""
        self.run_key('40821a')

    def test_408255_read_text_word(self):
        """FL-35b: differential test of m408255_read_text_word (original 0x408255)"""
        self.run_key('408255')

    def test_408290_read_text_word(self):
        """FL-35b: differential test of m408290_read_text_word (original 0x408290)"""
        self.run_key('408290')

    def test_4082cb_read_text_word(self):
        """FL-35b: differential test of m4082cb_read_text_word (original 0x4082cb)"""
        self.run_key('4082cb')

    def test_408306_read_text_word(self):
        """FL-35b: differential test of m408306_read_text_word (original 0x408306)"""
        self.run_key('408306')

    def test_408341_read_text_word(self):
        """FL-35b: differential test of m408341_read_text_word (original 0x408341)"""
        self.run_key('408341')

    def test_40837c_read_text_word(self):
        """FL-35b: differential test of m40837c_read_text_word (original 0x40837c)"""
        self.run_key('40837c')

    def test_4083b7_read_text_word(self):
        """FL-35b: differential test of m4083b7_read_text_word (original 0x4083b7)"""
        self.run_key('4083b7')

    def test_4083f2_read_text_word(self):
        """FL-35b: differential test of m4083f2_read_text_word (original 0x4083f2)"""
        self.run_key('4083f2')

    def test_40842d_read_text_word(self):
        """FL-35b: differential test of m40842d_read_text_word (original 0x40842d)"""
        self.run_key('40842d')

    def test_408468_read_text_word(self):
        """FL-35b: differential test of m408468_read_text_word (original 0x408468)"""
        self.run_key('408468')

    def test_4084a3_read_text_word(self):
        """FL-35b: differential test of m4084a3_read_text_word (original 0x4084a3)"""
        self.run_key('4084a3')

    def test_4084de_read_text_word(self):
        """FL-35b: differential test of m4084de_read_text_word (original 0x4084de)"""
        self.run_key('4084de')

    def test_408519_read_text_word(self):
        """FL-35b: differential test of m408519_read_text_word (original 0x408519)"""
        self.run_key('408519')

    def test_408554_read_text_word(self):
        """FL-35b: differential test of m408554_read_text_word (original 0x408554)"""
        self.run_key('408554')

    def test_40858f_read_text_word(self):
        """FL-35b: differential test of m40858f_read_text_word (original 0x40858f)"""
        self.run_key('40858f')

    def test_4085ca_read_text_word(self):
        """FL-35b: differential test of m4085ca_read_text_word (original 0x4085ca)"""
        self.run_key('4085ca')

    def test_408605_read_text_word(self):
        """FL-35b: differential test of m408605_read_text_word (original 0x408605)"""
        self.run_key('408605')

    def test_408640_read_text_word(self):
        """FL-35b: differential test of m408640_read_text_word (original 0x408640)"""
        self.run_key('408640')

    def test_40867b_read_text_word(self):
        """FL-35b: differential test of m40867b_read_text_word (original 0x40867b)"""
        self.run_key('40867b')

    def test_4086b6_read_text_word(self):
        """FL-35b: differential test of m4086b6_read_text_word (original 0x4086b6)"""
        self.run_key('4086b6')

    def test_4086f1_read_text_word(self):
        """FL-35b: differential test of m4086f1_read_text_word (original 0x4086f1)"""
        self.run_key('4086f1')

    def test_40872c_read_text_word(self):
        """FL-35b: differential test of m40872c_read_text_word (original 0x40872c)"""
        self.run_key('40872c')

    def test_408767_read_text_word(self):
        """FL-35b: differential test of m408767_read_text_word (original 0x408767)"""
        self.run_key('408767')

    def test_4087a2_read_text_word(self):
        """FL-35b: differential test of m4087a2_read_text_word (original 0x4087a2)"""
        self.run_key('4087a2')

    def test_4087dd_read_text_word(self):
        """FL-35b: differential test of m4087dd_read_text_word (original 0x4087dd)"""
        self.run_key('4087dd')

    def test_408818_read_text_word(self):
        """FL-35b: differential test of m408818_read_text_word (original 0x408818)"""
        self.run_key('408818')

    def test_408853_read_text_word(self):
        """FL-35b: differential test of m408853_read_text_word (original 0x408853)"""
        self.run_key('408853')

    def test_40888e_read_text_word(self):
        """FL-35b: differential test of m40888e_read_text_word (original 0x40888e)"""
        self.run_key('40888e')

    def test_4088c9_read_text_word(self):
        """FL-35b: differential test of m4088c9_read_text_word (original 0x4088c9)"""
        self.run_key('4088c9')

    def test_408904_read_text_word(self):
        """FL-35b: differential test of m408904_read_text_word (original 0x408904)"""
        self.run_key('408904')



if __name__ == '__main__':
    unittest.main()
