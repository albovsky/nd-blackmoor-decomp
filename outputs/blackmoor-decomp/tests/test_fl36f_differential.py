"""FL-36 (batch f) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl36f.c on the same generated
fixtures (tests/fl36f_fixtures.py builds them; the original side is fl36f_fixtures.run_original, the same function that
tests/fl36f_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl36f_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl36f_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl36fDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl36f_differential_shim.c'
    KERNELS = ['original_methods_fl36f.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl36f.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl36fWorld'

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
        self.lib.shim_fl36f(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_401420_new_and_construct(self):
        """FL-36f: differential test of m401420_new_and_construct (original 0x401420)"""
        self.run_key('401420')

    def test_403040_new_and_construct(self):
        """FL-36f: differential test of m403040_new_and_construct (original 0x403040)"""
        self.run_key('403040')

    def test_404a50_new_and_construct(self):
        """FL-36f: differential test of m404a50_new_and_construct (original 0x404a50)"""
        self.run_key('404a50')

    def test_407b40_new_and_construct(self):
        """FL-36f: differential test of m407b40_new_and_construct (original 0x407b40)"""
        self.run_key('407b40')

    def test_4089b0_new_and_construct(self):
        """FL-36f: differential test of m4089b0_new_and_construct (original 0x4089b0)"""
        self.run_key('4089b0')

    def test_4144c0_new_and_construct(self):
        """FL-36f: differential test of m4144c0_new_and_construct (original 0x4144c0)"""
        self.run_key('4144c0')

    def test_414537_construct_base_set_vtable(self):
        """FL-36f: differential test of m414537_construct_base_set_vtable (original 0x414537)"""
        self.run_key('414537')

    def test_41bda0_new_and_construct(self):
        """FL-36f: differential test of m41bda0_new_and_construct (original 0x41bda0)"""
        self.run_key('41bda0')

    def test_43eab0_new_and_construct(self):
        """FL-36f: differential test of m43eab0_new_and_construct (original 0x43eab0)"""
        self.run_key('43eab0')

    def test_446f00_new_and_construct(self):
        """FL-36f: differential test of m446f00_new_and_construct (original 0x446f00)"""
        self.run_key('446f00')

    def test_447db0_new_and_construct(self):
        """FL-36f: differential test of m447db0_new_and_construct (original 0x447db0)"""
        self.run_key('447db0')

    def test_44af40_new_and_construct(self):
        """FL-36f: differential test of m44af40_new_and_construct (original 0x44af40)"""
        self.run_key('44af40')

    def test_44d020_new_and_construct(self):
        """FL-36f: differential test of m44d020_new_and_construct (original 0x44d020)"""
        self.run_key('44d020')

    def test_44d097_construct_base_set_vtable(self):
        """FL-36f: differential test of m44d097_construct_base_set_vtable (original 0x44d097)"""
        self.run_key('44d097')

    def test_44e680_new_and_construct(self):
        """FL-36f: differential test of m44e680_new_and_construct (original 0x44e680)"""
        self.run_key('44e680')

    def test_44e6f7_construct_base_set_vtable(self):
        """FL-36f: differential test of m44e6f7_construct_base_set_vtable (original 0x44e6f7)"""
        self.run_key('44e6f7')

    def test_454ca0_new_and_construct(self):
        """FL-36f: differential test of m454ca0_new_and_construct (original 0x454ca0)"""
        self.run_key('454ca0')

    def test_454d1a_construct_base_set_vtable(self):
        """FL-36f: differential test of m454d1a_construct_base_set_vtable (original 0x454d1a)"""
        self.run_key('454d1a')

    def test_456c20_new_and_construct(self):
        """FL-36f: differential test of m456c20_new_and_construct (original 0x456c20)"""
        self.run_key('456c20')

    def test_456c97_construct_base_set_vtable(self):
        """FL-36f: differential test of m456c97_construct_base_set_vtable (original 0x456c97)"""
        self.run_key('456c97')

    def test_457e90_new_and_construct(self):
        """FL-36f: differential test of m457e90_new_and_construct (original 0x457e90)"""
        self.run_key('457e90')

    def test_457f0a_construct_base_set_vtable(self):
        """FL-36f: differential test of m457f0a_construct_base_set_vtable (original 0x457f0a)"""
        self.run_key('457f0a')

    def test_459a00_new_and_construct(self):
        """FL-36f: differential test of m459a00_new_and_construct (original 0x459a00)"""
        self.run_key('459a00')

    def test_459a7a_construct_base_set_vtable(self):
        """FL-36f: differential test of m459a7a_construct_base_set_vtable (original 0x459a7a)"""
        self.run_key('459a7a')

    def test_45b300_new_and_construct(self):
        """FL-36f: differential test of m45b300_new_and_construct (original 0x45b300)"""
        self.run_key('45b300')

    def test_45b37a_construct_base_set_vtable(self):
        """FL-36f: differential test of m45b37a_construct_base_set_vtable (original 0x45b37a)"""
        self.run_key('45b37a')

    def test_45dba0_new_and_construct(self):
        """FL-36f: differential test of m45dba0_new_and_construct (original 0x45dba0)"""
        self.run_key('45dba0')

    def test_45dc1a_construct_base_set_vtable(self):
        """FL-36f: differential test of m45dc1a_construct_base_set_vtable (original 0x45dc1a)"""
        self.run_key('45dc1a')

    def test_461740_new_and_construct(self):
        """FL-36f: differential test of m461740_new_and_construct (original 0x461740)"""
        self.run_key('461740')

    def test_4617b7_construct_base_set_vtable(self):
        """FL-36f: differential test of m4617b7_construct_base_set_vtable (original 0x4617b7)"""
        self.run_key('4617b7')

    def test_463f30_new_and_construct(self):
        """FL-36f: differential test of m463f30_new_and_construct (original 0x463f30)"""
        self.run_key('463f30')

    def test_463faa_construct_base_set_vtable(self):
        """FL-36f: differential test of m463faa_construct_base_set_vtable (original 0x463faa)"""
        self.run_key('463faa')

    def test_465a20_new_and_construct(self):
        """FL-36f: differential test of m465a20_new_and_construct (original 0x465a20)"""
        self.run_key('465a20')

    def test_465a97_construct_base_set_vtable(self):
        """FL-36f: differential test of m465a97_construct_base_set_vtable (original 0x465a97)"""
        self.run_key('465a97')

    def test_468d70_new_and_construct(self):
        """FL-36f: differential test of m468d70_new_and_construct (original 0x468d70)"""
        self.run_key('468d70')

    def test_468dea_construct_base_set_vtable(self):
        """FL-36f: differential test of m468dea_construct_base_set_vtable (original 0x468dea)"""
        self.run_key('468dea')

    def test_46b4a0_new_and_construct(self):
        """FL-36f: differential test of m46b4a0_new_and_construct (original 0x46b4a0)"""
        self.run_key('46b4a0')

    def test_46b51a_construct_base_set_vtable(self):
        """FL-36f: differential test of m46b51a_construct_base_set_vtable (original 0x46b51a)"""
        self.run_key('46b51a')

    def test_46e580_new_and_construct(self):
        """FL-36f: differential test of m46e580_new_and_construct (original 0x46e580)"""
        self.run_key('46e580')

    def test_470c90_new_and_construct(self):
        """FL-36f: differential test of m470c90_new_and_construct (original 0x470c90)"""
        self.run_key('470c90')

    def test_470d0a_construct_base_set_vtable(self):
        """FL-36f: differential test of m470d0a_construct_base_set_vtable (original 0x470d0a)"""
        self.run_key('470d0a')

    def test_4756f0_new_and_construct(self):
        """FL-36f: differential test of m4756f0_new_and_construct (original 0x4756f0)"""
        self.run_key('4756f0')

    def test_47576a_construct_base_set_vtable(self):
        """FL-36f: differential test of m47576a_construct_base_set_vtable (original 0x47576a)"""
        self.run_key('47576a')

    def test_478110_new_and_construct(self):
        """FL-36f: differential test of m478110_new_and_construct (original 0x478110)"""
        self.run_key('478110')

    def test_47818a_construct_base_set_vtable(self):
        """FL-36f: differential test of m47818a_construct_base_set_vtable (original 0x47818a)"""
        self.run_key('47818a')

    def test_47d410_new_and_construct(self):
        """FL-36f: differential test of m47d410_new_and_construct (original 0x47d410)"""
        self.run_key('47d410')

    def test_47d487_construct_base_set_vtable(self):
        """FL-36f: differential test of m47d487_construct_base_set_vtable (original 0x47d487)"""
        self.run_key('47d487')

    def test_47e170_new_and_construct(self):
        """FL-36f: differential test of m47e170_new_and_construct (original 0x47e170)"""
        self.run_key('47e170')

    def test_47e1ea_construct_base_set_vtable(self):
        """FL-36f: differential test of m47e1ea_construct_base_set_vtable (original 0x47e1ea)"""
        self.run_key('47e1ea')

    def test_482090_new_and_construct(self):
        """FL-36f: differential test of m482090_new_and_construct (original 0x482090)"""
        self.run_key('482090')

    def test_48210a_construct_base_set_vtable(self):
        """FL-36f: differential test of m48210a_construct_base_set_vtable (original 0x48210a)"""
        self.run_key('48210a')

    def test_483e80_new_and_construct(self):
        """FL-36f: differential test of m483e80_new_and_construct (original 0x483e80)"""
        self.run_key('483e80')

    def test_483efa_construct_base_set_vtable(self):
        """FL-36f: differential test of m483efa_construct_base_set_vtable (original 0x483efa)"""
        self.run_key('483efa')

    def test_487a30_new_and_construct(self):
        """FL-36f: differential test of m487a30_new_and_construct (original 0x487a30)"""
        self.run_key('487a30')

    def test_487aaa_construct_base_set_vtable(self):
        """FL-36f: differential test of m487aaa_construct_base_set_vtable (original 0x487aaa)"""
        self.run_key('487aaa')

    def test_488cf0_new_and_construct(self):
        """FL-36f: differential test of m488cf0_new_and_construct (original 0x488cf0)"""
        self.run_key('488cf0')

    def test_48a620_new_and_construct(self):
        """FL-36f: differential test of m48a620_new_and_construct (original 0x48a620)"""
        self.run_key('48a620')

    def test_48a69a_construct_base_set_vtable(self):
        """FL-36f: differential test of m48a69a_construct_base_set_vtable (original 0x48a69a)"""
        self.run_key('48a69a')

    def test_48ba30_new_and_construct(self):
        """FL-36f: differential test of m48ba30_new_and_construct (original 0x48ba30)"""
        self.run_key('48ba30')

    def test_48baa7_construct_base_set_vtable(self):
        """FL-36f: differential test of m48baa7_construct_base_set_vtable (original 0x48baa7)"""
        self.run_key('48baa7')

    def test_48cf80_new_and_construct(self):
        """FL-36f: differential test of m48cf80_new_and_construct (original 0x48cf80)"""
        self.run_key('48cf80')

    def test_48cff7_construct_base_set_vtable(self):
        """FL-36f: differential test of m48cff7_construct_base_set_vtable (original 0x48cff7)"""
        self.run_key('48cff7')

    def test_48e1a0_new_and_construct(self):
        """FL-36f: differential test of m48e1a0_new_and_construct (original 0x48e1a0)"""
        self.run_key('48e1a0')

    def test_48e21a_construct_base_set_vtable(self):
        """FL-36f: differential test of m48e21a_construct_base_set_vtable (original 0x48e21a)"""
        self.run_key('48e21a')

    def test_490480_new_and_construct(self):
        """FL-36f: differential test of m490480_new_and_construct (original 0x490480)"""
        self.run_key('490480')

    def test_49c4c0_new_and_construct(self):
        """FL-36f: differential test of m49c4c0_new_and_construct (original 0x49c4c0)"""
        self.run_key('49c4c0')

    def test_4a1b60_new_and_construct(self):
        """FL-36f: differential test of m4a1b60_new_and_construct (original 0x4a1b60)"""
        self.run_key('4a1b60')

    def test_4a1bd7_construct_base_set_vtable(self):
        """FL-36f: differential test of m4a1bd7_construct_base_set_vtable (original 0x4a1bd7)"""
        self.run_key('4a1bd7')

    def test_4a36a0_new_and_construct(self):
        """FL-36f: differential test of m4a36a0_new_and_construct (original 0x4a36a0)"""
        self.run_key('4a36a0')

    def test_4a371a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4a371a_construct_base_set_vtable (original 0x4a371a)"""
        self.run_key('4a371a')

    def test_4a62a0_new_and_construct(self):
        """FL-36f: differential test of m4a62a0_new_and_construct (original 0x4a62a0)"""
        self.run_key('4a62a0')

    def test_4a631a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4a631a_construct_base_set_vtable (original 0x4a631a)"""
        self.run_key('4a631a')

    def test_4a7b90_new_and_construct(self):
        """FL-36f: differential test of m4a7b90_new_and_construct (original 0x4a7b90)"""
        self.run_key('4a7b90')

    def test_4a7c0a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4a7c0a_construct_base_set_vtable (original 0x4a7c0a)"""
        self.run_key('4a7c0a')

    def test_4a9e40_new_and_construct(self):
        """FL-36f: differential test of m4a9e40_new_and_construct (original 0x4a9e40)"""
        self.run_key('4a9e40')

    def test_4a9eb7_construct_base_set_vtable(self):
        """FL-36f: differential test of m4a9eb7_construct_base_set_vtable (original 0x4a9eb7)"""
        self.run_key('4a9eb7')

    def test_4ab2c0_new_and_construct(self):
        """FL-36f: differential test of m4ab2c0_new_and_construct (original 0x4ab2c0)"""
        self.run_key('4ab2c0')

    def test_4ab337_construct_base_set_vtable(self):
        """FL-36f: differential test of m4ab337_construct_base_set_vtable (original 0x4ab337)"""
        self.run_key('4ab337')

    def test_4ac7f0_new_and_construct(self):
        """FL-36f: differential test of m4ac7f0_new_and_construct (original 0x4ac7f0)"""
        self.run_key('4ac7f0')

    def test_4ac86a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4ac86a_construct_base_set_vtable (original 0x4ac86a)"""
        self.run_key('4ac86a')

    def test_4afc50_new_and_construct(self):
        """FL-36f: differential test of m4afc50_new_and_construct (original 0x4afc50)"""
        self.run_key('4afc50')

    def test_4afcca_construct_base_set_vtable(self):
        """FL-36f: differential test of m4afcca_construct_base_set_vtable (original 0x4afcca)"""
        self.run_key('4afcca')

    def test_4b3b70_new_and_construct(self):
        """FL-36f: differential test of m4b3b70_new_and_construct (original 0x4b3b70)"""
        self.run_key('4b3b70')

    def test_4b3bea_construct_base_set_vtable(self):
        """FL-36f: differential test of m4b3bea_construct_base_set_vtable (original 0x4b3bea)"""
        self.run_key('4b3bea')

    def test_4b5aa0_new_and_construct(self):
        """FL-36f: differential test of m4b5aa0_new_and_construct (original 0x4b5aa0)"""
        self.run_key('4b5aa0')

    def test_4b5b1a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4b5b1a_construct_base_set_vtable (original 0x4b5b1a)"""
        self.run_key('4b5b1a')

    def test_4b7110_new_and_construct(self):
        """FL-36f: differential test of m4b7110_new_and_construct (original 0x4b7110)"""
        self.run_key('4b7110')

    def test_4b7187_construct_base_set_vtable(self):
        """FL-36f: differential test of m4b7187_construct_base_set_vtable (original 0x4b7187)"""
        self.run_key('4b7187')

    def test_4cc8b0_new_and_construct(self):
        """FL-36f: differential test of m4cc8b0_new_and_construct (original 0x4cc8b0)"""
        self.run_key('4cc8b0')

    def test_4d3aa0_new_and_construct(self):
        """FL-36f: differential test of m4d3aa0_new_and_construct (original 0x4d3aa0)"""
        self.run_key('4d3aa0')

    def test_4d3b1a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4d3b1a_construct_base_set_vtable (original 0x4d3b1a)"""
        self.run_key('4d3b1a')

    def test_4dbea0_new_and_construct(self):
        """FL-36f: differential test of m4dbea0_new_and_construct (original 0x4dbea0)"""
        self.run_key('4dbea0')

    def test_4dbf1a_construct_base_set_vtable(self):
        """FL-36f: differential test of m4dbf1a_construct_base_set_vtable (original 0x4dbf1a)"""
        self.run_key('4dbf1a')

    def test_4de150_construct_base_set_vtable(self):
        """FL-36f: differential test of m4de150_construct_base_set_vtable (original 0x4de150)"""
        self.run_key('4de150')

    def test_4e7630_construct_base_set_vtable(self):
        """FL-36f: differential test of m4e7630_construct_base_set_vtable (original 0x4e7630)"""
        self.run_key('4e7630')


if __name__ == '__main__':
    unittest.main()
