"""FL-36 (batch d) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl36d.c on the same generated
fixtures (tests/fl36d_fixtures.py builds them; the original side is fl36d_fixtures.run_original, the same function that
tests/fl36d_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl36d_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl36d_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl36dDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl36d_differential_shim.c'
    KERNELS = ['original_methods_fl36d.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl36d.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl36dWorld'

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
        self.lib.shim_fl36d(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_401100_scalar_deleting_dtor(self):
        """FL-36d: differential test of m401100_scalar_deleting_dtor (original 0x401100)"""
        self.run_key('401100')

    def test_401190_scalar_deleting_dtor(self):
        """FL-36d: differential test of m401190_scalar_deleting_dtor (original 0x401190)"""
        self.run_key('401190')

    def test_401c40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m401c40_scalar_deleting_dtor (original 0x401c40)"""
        self.run_key('401c40')

    def test_403010_scalar_deleting_dtor(self):
        """FL-36d: differential test of m403010_scalar_deleting_dtor (original 0x403010)"""
        self.run_key('403010')

    def test_404a20_scalar_deleting_dtor(self):
        """FL-36d: differential test of m404a20_scalar_deleting_dtor (original 0x404a20)"""
        self.run_key('404a20')

    def test_407b10_scalar_deleting_dtor(self):
        """FL-36d: differential test of m407b10_scalar_deleting_dtor (original 0x407b10)"""
        self.run_key('407b10')

    def test_408980_scalar_deleting_dtor(self):
        """FL-36d: differential test of m408980_scalar_deleting_dtor (original 0x408980)"""
        self.run_key('408980')

    def test_40b2a0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m40b2a0_scalar_deleting_dtor (original 0x40b2a0)"""
        self.run_key('40b2a0')

    def test_414490_scalar_deleting_dtor(self):
        """FL-36d: differential test of m414490_scalar_deleting_dtor (original 0x414490)"""
        self.run_key('414490')

    def test_414c80_scalar_deleting_dtor(self):
        """FL-36d: differential test of m414c80_scalar_deleting_dtor (original 0x414c80)"""
        self.run_key('414c80')

    def test_416e60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m416e60_scalar_deleting_dtor (original 0x416e60)"""
        self.run_key('416e60')

    def test_41a480_scalar_deleting_dtor(self):
        """FL-36d: differential test of m41a480_scalar_deleting_dtor (original 0x41a480)"""
        self.run_key('41a480')

    def test_422fb0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m422fb0_scalar_deleting_dtor (original 0x422fb0)"""
        self.run_key('422fb0')

    def test_425f70_scalar_deleting_dtor(self):
        """FL-36d: differential test of m425f70_scalar_deleting_dtor (original 0x425f70)"""
        self.run_key('425f70')

    def test_4273f0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4273f0_scalar_deleting_dtor (original 0x4273f0)"""
        self.run_key('4273f0')

    def test_434880_scalar_deleting_dtor(self):
        """FL-36d: differential test of m434880_scalar_deleting_dtor (original 0x434880)"""
        self.run_key('434880')

    def test_438120_scalar_deleting_dtor(self):
        """FL-36d: differential test of m438120_scalar_deleting_dtor (original 0x438120)"""
        self.run_key('438120')

    def test_43eed0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m43eed0_scalar_deleting_dtor (original 0x43eed0)"""
        self.run_key('43eed0')

    def test_43f1e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m43f1e0_scalar_deleting_dtor (original 0x43f1e0)"""
        self.run_key('43f1e0')

    def test_446ed0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m446ed0_scalar_deleting_dtor (original 0x446ed0)"""
        self.run_key('446ed0')

    def test_447ce0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m447ce0_scalar_deleting_dtor (original 0x447ce0)"""
        self.run_key('447ce0')

    def test_447d80_scalar_deleting_dtor(self):
        """FL-36d: differential test of m447d80_scalar_deleting_dtor (original 0x447d80)"""
        self.run_key('447d80')

    def test_4487f0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4487f0_scalar_deleting_dtor (original 0x4487f0)"""
        self.run_key('4487f0')

    def test_449770_scalar_deleting_dtor(self):
        """FL-36d: differential test of m449770_scalar_deleting_dtor (original 0x449770)"""
        self.run_key('449770')

    def test_449d60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m449d60_scalar_deleting_dtor (original 0x449d60)"""
        self.run_key('449d60')

    def test_44be60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m44be60_scalar_deleting_dtor (original 0x44be60)"""
        self.run_key('44be60')

    def test_44c2b0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m44c2b0_scalar_deleting_dtor (original 0x44c2b0)"""
        self.run_key('44c2b0')

    def test_44e650_scalar_deleting_dtor(self):
        """FL-36d: differential test of m44e650_scalar_deleting_dtor (original 0x44e650)"""
        self.run_key('44e650')

    def test_44f620_scalar_deleting_dtor(self):
        """FL-36d: differential test of m44f620_scalar_deleting_dtor (original 0x44f620)"""
        self.run_key('44f620')

    def test_454c70_scalar_deleting_dtor(self):
        """FL-36d: differential test of m454c70_scalar_deleting_dtor (original 0x454c70)"""
        self.run_key('454c70')

    def test_456bf0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m456bf0_scalar_deleting_dtor (original 0x456bf0)"""
        self.run_key('456bf0')

    def test_457e60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m457e60_scalar_deleting_dtor (original 0x457e60)"""
        self.run_key('457e60')

    def test_4599d0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4599d0_scalar_deleting_dtor (original 0x4599d0)"""
        self.run_key('4599d0')

    def test_45b2d0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m45b2d0_scalar_deleting_dtor (original 0x45b2d0)"""
        self.run_key('45b2d0')

    def test_45db70_scalar_deleting_dtor(self):
        """FL-36d: differential test of m45db70_scalar_deleting_dtor (original 0x45db70)"""
        self.run_key('45db70')

    def test_461710_scalar_deleting_dtor(self):
        """FL-36d: differential test of m461710_scalar_deleting_dtor (original 0x461710)"""
        self.run_key('461710')

    def test_463f00_scalar_deleting_dtor(self):
        """FL-36d: differential test of m463f00_scalar_deleting_dtor (original 0x463f00)"""
        self.run_key('463f00')

    def test_4659f0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4659f0_scalar_deleting_dtor (original 0x4659f0)"""
        self.run_key('4659f0')

    def test_4674b0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4674b0_scalar_deleting_dtor (original 0x4674b0)"""
        self.run_key('4674b0')

    def test_468d40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m468d40_scalar_deleting_dtor (original 0x468d40)"""
        self.run_key('468d40')

    def test_46b470_scalar_deleting_dtor(self):
        """FL-36d: differential test of m46b470_scalar_deleting_dtor (original 0x46b470)"""
        self.run_key('46b470')

    def test_46e550_scalar_deleting_dtor(self):
        """FL-36d: differential test of m46e550_scalar_deleting_dtor (original 0x46e550)"""
        self.run_key('46e550')

    def test_470c60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m470c60_scalar_deleting_dtor (original 0x470c60)"""
        self.run_key('470c60')

    def test_472ed0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m472ed0_scalar_deleting_dtor (original 0x472ed0)"""
        self.run_key('472ed0')

    def test_4756c0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4756c0_scalar_deleting_dtor (original 0x4756c0)"""
        self.run_key('4756c0')

    def test_4780e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4780e0_scalar_deleting_dtor (original 0x4780e0)"""
        self.run_key('4780e0')

    def test_47b1d0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m47b1d0_scalar_deleting_dtor (original 0x47b1d0)"""
        self.run_key('47b1d0')

    def test_47d3e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m47d3e0_scalar_deleting_dtor (original 0x47d3e0)"""
        self.run_key('47d3e0')

    def test_47e140_scalar_deleting_dtor(self):
        """FL-36d: differential test of m47e140_scalar_deleting_dtor (original 0x47e140)"""
        self.run_key('47e140')

    def test_482060_scalar_deleting_dtor(self):
        """FL-36d: differential test of m482060_scalar_deleting_dtor (original 0x482060)"""
        self.run_key('482060')

    def test_483e50_scalar_deleting_dtor(self):
        """FL-36d: differential test of m483e50_scalar_deleting_dtor (original 0x483e50)"""
        self.run_key('483e50')

    def test_487a00_scalar_deleting_dtor(self):
        """FL-36d: differential test of m487a00_scalar_deleting_dtor (original 0x487a00)"""
        self.run_key('487a00')

    def test_488cc0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m488cc0_scalar_deleting_dtor (original 0x488cc0)"""
        self.run_key('488cc0')

    def test_48a5f0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m48a5f0_scalar_deleting_dtor (original 0x48a5f0)"""
        self.run_key('48a5f0')

    def test_48ba00_scalar_deleting_dtor(self):
        """FL-36d: differential test of m48ba00_scalar_deleting_dtor (original 0x48ba00)"""
        self.run_key('48ba00')

    def test_48cf50_scalar_deleting_dtor(self):
        """FL-36d: differential test of m48cf50_scalar_deleting_dtor (original 0x48cf50)"""
        self.run_key('48cf50')

    def test_48e170_scalar_deleting_dtor(self):
        """FL-36d: differential test of m48e170_scalar_deleting_dtor (original 0x48e170)"""
        self.run_key('48e170')

    def test_490450_scalar_deleting_dtor(self):
        """FL-36d: differential test of m490450_scalar_deleting_dtor (original 0x490450)"""
        self.run_key('490450')

    def test_49c490_scalar_deleting_dtor(self):
        """FL-36d: differential test of m49c490_scalar_deleting_dtor (original 0x49c490)"""
        self.run_key('49c490')

    def test_4a1b30_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4a1b30_scalar_deleting_dtor (original 0x4a1b30)"""
        self.run_key('4a1b30')

    def test_4a3670_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4a3670_scalar_deleting_dtor (original 0x4a3670)"""
        self.run_key('4a3670')

    def test_4a6270_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4a6270_scalar_deleting_dtor (original 0x4a6270)"""
        self.run_key('4a6270')

    def test_4a7b60_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4a7b60_scalar_deleting_dtor (original 0x4a7b60)"""
        self.run_key('4a7b60')

    def test_4a9e10_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4a9e10_scalar_deleting_dtor (original 0x4a9e10)"""
        self.run_key('4a9e10')

    def test_4ab290_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4ab290_scalar_deleting_dtor (original 0x4ab290)"""
        self.run_key('4ab290')

    def test_4ac7c0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4ac7c0_scalar_deleting_dtor (original 0x4ac7c0)"""
        self.run_key('4ac7c0')

    def test_4afc20_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4afc20_scalar_deleting_dtor (original 0x4afc20)"""
        self.run_key('4afc20')

    def test_4b3b40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4b3b40_scalar_deleting_dtor (original 0x4b3b40)"""
        self.run_key('4b3b40')

    def test_4b5a70_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4b5a70_scalar_deleting_dtor (original 0x4b5a70)"""
        self.run_key('4b5a70')

    def test_4b70e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4b70e0_scalar_deleting_dtor (original 0x4b70e0)"""
        self.run_key('4b70e0')

    def test_4b7ed0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4b7ed0_scalar_deleting_dtor (original 0x4b7ed0)"""
        self.run_key('4b7ed0')

    def test_4b9dd0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4b9dd0_scalar_deleting_dtor (original 0x4b9dd0)"""
        self.run_key('4b9dd0')

    def test_4bed40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4bed40_scalar_deleting_dtor (original 0x4bed40)"""
        self.run_key('4bed40')

    def test_4bf5d0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4bf5d0_scalar_deleting_dtor (original 0x4bf5d0)"""
        self.run_key('4bf5d0')

    def test_4c0f30_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4c0f30_scalar_deleting_dtor (original 0x4c0f30)"""
        self.run_key('4c0f30')

    def test_4cae90_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4cae90_scalar_deleting_dtor (original 0x4cae90)"""
        self.run_key('4cae90')

    def test_4cc880_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4cc880_scalar_deleting_dtor (original 0x4cc880)"""
        self.run_key('4cc880')

    def test_4ccd40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4ccd40_scalar_deleting_dtor (original 0x4ccd40)"""
        self.run_key('4ccd40')

    def test_4cf7b0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4cf7b0_scalar_deleting_dtor (original 0x4cf7b0)"""
        self.run_key('4cf7b0')

    def test_4d42b0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4d42b0_scalar_deleting_dtor (original 0x4d42b0)"""
        self.run_key('4d42b0')

    def test_4d5230_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4d5230_scalar_deleting_dtor (original 0x4d5230)"""
        self.run_key('4d5230')

    def test_4d5880_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4d5880_scalar_deleting_dtor (original 0x4d5880)"""
        self.run_key('4d5880')

    def test_4d9d40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4d9d40_scalar_deleting_dtor (original 0x4d9d40)"""
        self.run_key('4d9d40')

    def test_4dbca0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4dbca0_scalar_deleting_dtor (original 0x4dbca0)"""
        self.run_key('4dbca0')

    def test_4dd380_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4dd380_scalar_deleting_dtor (original 0x4dd380)"""
        self.run_key('4dd380')

    def test_4de120_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4de120_scalar_deleting_dtor (original 0x4de120)"""
        self.run_key('4de120')

    def test_4de5c0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4de5c0_scalar_deleting_dtor (original 0x4de5c0)"""
        self.run_key('4de5c0')

    def test_4e03e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4e03e0_scalar_deleting_dtor (original 0x4e03e0)"""
        self.run_key('4e03e0')

    def test_4e1c20_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4e1c20_scalar_deleting_dtor (original 0x4e1c20)"""
        self.run_key('4e1c20')

    def test_4e2cb0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4e2cb0_scalar_deleting_dtor (original 0x4e2cb0)"""
        self.run_key('4e2cb0')

    def test_4e7600_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4e7600_scalar_deleting_dtor (original 0x4e7600)"""
        self.run_key('4e7600')

    def test_4e7a40_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4e7a40_scalar_deleting_dtor (original 0x4e7a40)"""
        self.run_key('4e7a40')

    def test_4eb840_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4eb840_scalar_deleting_dtor (original 0x4eb840)"""
        self.run_key('4eb840')

    def test_4ed9e0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4ed9e0_scalar_deleting_dtor (original 0x4ed9e0)"""
        self.run_key('4ed9e0')

    def test_4ee950_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4ee950_scalar_deleting_dtor (original 0x4ee950)"""
        self.run_key('4ee950')

    def test_4effd0_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4effd0_scalar_deleting_dtor (original 0x4effd0)"""
        self.run_key('4effd0')

    def test_4f2610_scalar_deleting_dtor(self):
        """FL-36d: differential test of m4f2610_scalar_deleting_dtor (original 0x4f2610)"""
        self.run_key('4f2610')


if __name__ == '__main__':
    unittest.main()
