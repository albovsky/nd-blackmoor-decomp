"""FL-39 (batch d) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl39d.c on the same generated
fixtures (tests/fl39d_fixtures.py builds them; the original side is fl39d_fixtures.run_original, the same function that
tests/fl39d_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl39d_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl39d_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl39dDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl39d_differential_shim.c'
    KERNELS = ['original_methods_fl39d.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl39d.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl39dWorld'

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
        self.lib.shim_fl39d(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_48217a_lifted(self):
        """FL-39d: differential test of m48217a_lifted (original 0x48217a)"""
        self.run_key('48217a')

    def test_4821ab_lifted(self):
        """FL-39d: differential test of m4821ab_lifted (original 0x4821ab)"""
        self.run_key('4821ab')

    def test_487dcf_lifted(self):
        """FL-39d: differential test of m487dcf_lifted (original 0x487dcf)"""
        self.run_key('487dcf')

    def test_488e54_lifted(self):
        """FL-39d: differential test of m488e54_lifted (original 0x488e54)"""
        self.run_key('488e54')

    def test_48a70a_lifted(self):
        """FL-39d: differential test of m48a70a_lifted (original 0x48a70a)"""
        self.run_key('48a70a')

    def test_48aa66_lifted(self):
        """FL-39d: differential test of m48aa66_lifted (original 0x48aa66)"""
        self.run_key('48aa66')

    def test_48e28a_lifted(self):
        """FL-39d: differential test of m48e28a_lifted (original 0x48e28a)"""
        self.run_key('48e28a')

    def test_4911ca_lifted(self):
        """FL-39d: differential test of m4911ca_lifted (original 0x4911ca)"""
        self.run_key('4911ca')

    def test_491422_lifted(self):
        """FL-39d: differential test of m491422_lifted (original 0x491422)"""
        self.run_key('491422')

    def test_491885_lifted(self):
        """FL-39d: differential test of m491885_lifted (original 0x491885)"""
        self.run_key('491885')

    def test_4921a1_lifted(self):
        """FL-39d: differential test of m4921a1_lifted (original 0x4921a1)"""
        self.run_key('4921a1')

    def test_493a54_lifted(self):
        """FL-39d: differential test of m493a54_lifted (original 0x493a54)"""
        self.run_key('493a54')

    def test_493af0_lifted(self):
        """FL-39d: differential test of m493af0_lifted (original 0x493af0)"""
        self.run_key('493af0')

    def test_493b2e_lifted(self):
        """FL-39d: differential test of m493b2e_lifted (original 0x493b2e)"""
        self.run_key('493b2e')

    def test_493c34_lifted(self):
        """FL-39d: differential test of m493c34_lifted (original 0x493c34)"""
        self.run_key('493c34')

    def test_495a5b_lifted(self):
        """FL-39d: differential test of m495a5b_lifted (original 0x495a5b)"""
        self.run_key('495a5b')

    def test_49c46c_lifted(self):
        """FL-39d: differential test of m49c46c_lifted (original 0x49c46c)"""
        self.run_key('49c46c')

    def test_49c68a_lifted(self):
        """FL-39d: differential test of m49c68a_lifted (original 0x49c68a)"""
        self.run_key('49c68a')

    def test_4a1d14_lifted(self):
        """FL-39d: differential test of m4a1d14_lifted (original 0x4a1d14)"""
        self.run_key('4a1d14')

    def test_4a1e93_lifted(self):
        """FL-39d: differential test of m4a1e93_lifted (original 0x4a1e93)"""
        self.run_key('4a1e93')

    def test_4a1fd1_lifted(self):
        """FL-39d: differential test of m4a1fd1_lifted (original 0x4a1fd1)"""
        self.run_key('4a1fd1')

    def test_4a378a_lifted(self):
        """FL-39d: differential test of m4a378a_lifted (original 0x4a378a)"""
        self.run_key('4a378a')

    def test_4a39c4_lifted(self):
        """FL-39d: differential test of m4a39c4_lifted (original 0x4a39c4)"""
        self.run_key('4a39c4')

    def test_4a3beb_lifted(self):
        """FL-39d: differential test of m4a3beb_lifted (original 0x4a3beb)"""
        self.run_key('4a3beb')

    def test_4a63dc_lifted(self):
        """FL-39d: differential test of m4a63dc_lifted (original 0x4a63dc)"""
        self.run_key('4a63dc')

    def test_4a7994_lifted(self):
        """FL-39d: differential test of m4a7994_lifted (original 0x4a7994)"""
        self.run_key('4a7994')

    def test_4a7c7a_lifted(self):
        """FL-39d: differential test of m4a7c7a_lifted (original 0x4a7c7a)"""
        self.run_key('4a7c7a')

    def test_4a7d1d_lifted(self):
        """FL-39d: differential test of m4a7d1d_lifted (original 0x4a7d1d)"""
        self.run_key('4a7d1d')

    def test_4a7df9_lifted(self):
        """FL-39d: differential test of m4a7df9_lifted (original 0x4a7df9)"""
        self.run_key('4a7df9')

    def test_4a8007_lifted(self):
        """FL-39d: differential test of m4a8007_lifted (original 0x4a8007)"""
        self.run_key('4a8007')

    def test_4a9f63_lifted(self):
        """FL-39d: differential test of m4a9f63_lifted (original 0x4a9f63)"""
        self.run_key('4a9f63')

    def test_4ab706_lifted(self):
        """FL-39d: differential test of m4ab706_lifted (original 0x4ab706)"""
        self.run_key('4ab706')

    def test_4accab_lifted(self):
        """FL-39d: differential test of m4accab_lifted (original 0x4accab)"""
        self.run_key('4accab')

    def test_4ad1e5_lifted(self):
        """FL-39d: differential test of m4ad1e5_lifted (original 0x4ad1e5)"""
        self.run_key('4ad1e5')

    def test_4b3c5a_lifted(self):
        """FL-39d: differential test of m4b3c5a_lifted (original 0x4b3c5a)"""
        self.run_key('4b3c5a')

    def test_4b3f98_lifted(self):
        """FL-39d: differential test of m4b3f98_lifted (original 0x4b3f98)"""
        self.run_key('4b3f98')

    def test_4b450f_lifted(self):
        """FL-39d: differential test of m4b450f_lifted (original 0x4b450f)"""
        self.run_key('4b450f')

    def test_4b72a9_lifted(self):
        """FL-39d: differential test of m4b72a9_lifted (original 0x4b72a9)"""
        self.run_key('4b72a9')

    def test_4b9e3b_lifted(self):
        """FL-39d: differential test of m4b9e3b_lifted (original 0x4b9e3b)"""
        self.run_key('4b9e3b')

    def test_4ba07f_lifted(self):
        """FL-39d: differential test of m4ba07f_lifted (original 0x4ba07f)"""
        self.run_key('4ba07f')

    def test_4ba262_lifted(self):
        """FL-39d: differential test of m4ba262_lifted (original 0x4ba262)"""
        self.run_key('4ba262')

    def test_4ba486_lifted(self):
        """FL-39d: differential test of m4ba486_lifted (original 0x4ba486)"""
        self.run_key('4ba486')

    def test_4be2c6_lifted(self):
        """FL-39d: differential test of m4be2c6_lifted (original 0x4be2c6)"""
        self.run_key('4be2c6')

    def test_4bed70_lifted(self):
        """FL-39d: differential test of m4bed70_lifted (original 0x4bed70)"""
        self.run_key('4bed70')

    def test_4bf63b_lifted(self):
        """FL-39d: differential test of m4bf63b_lifted (original 0x4bf63b)"""
        self.run_key('4bf63b')

    def test_4bf8a7_lifted(self):
        """FL-39d: differential test of m4bf8a7_lifted (original 0x4bf8a7)"""
        self.run_key('4bf8a7')

    def test_4c139a_lifted(self):
        """FL-39d: differential test of m4c139a_lifted (original 0x4c139a)"""
        self.run_key('4c139a')

    def test_4c4b12_lifted(self):
        """FL-39d: differential test of m4c4b12_lifted (original 0x4c4b12)"""
        self.run_key('4c4b12')

    def test_4c4c2b_lifted(self):
        """FL-39d: differential test of m4c4c2b_lifted (original 0x4c4c2b)"""
        self.run_key('4c4c2b')

    def test_4c9428_lifted(self):
        """FL-39d: differential test of m4c9428_lifted (original 0x4c9428)"""
        self.run_key('4c9428')

    def test_4c9b66_lifted(self):
        """FL-39d: differential test of m4c9b66_lifted (original 0x4c9b66)"""
        self.run_key('4c9b66')

    def test_4c9c10_lifted(self):
        """FL-39d: differential test of m4c9c10_lifted (original 0x4c9c10)"""
        self.run_key('4c9c10')

    def test_4ca92e_lifted(self):
        """FL-39d: differential test of m4ca92e_lifted (original 0x4ca92e)"""
        self.run_key('4ca92e')

    def test_4caec0_lifted(self):
        """FL-39d: differential test of m4caec0_lifted (original 0x4caec0)"""
        self.run_key('4caec0')

    def test_4caff5_lifted(self):
        """FL-39d: differential test of m4caff5_lifted (original 0x4caff5)"""
        self.run_key('4caff5')

    def test_4cca0e_lifted(self):
        """FL-39d: differential test of m4cca0e_lifted (original 0x4cca0e)"""
        self.run_key('4cca0e')

    def test_4ccc50_lifted(self):
        """FL-39d: differential test of m4ccc50_lifted (original 0x4ccc50)"""
        self.run_key('4ccc50')

    def test_4cd645_lifted(self):
        """FL-39d: differential test of m4cd645_lifted (original 0x4cd645)"""
        self.run_key('4cd645')

    def test_4d00d2_lifted(self):
        """FL-39d: differential test of m4d00d2_lifted (original 0x4d00d2)"""
        self.run_key('4d00d2')

    def test_4d3723_lifted(self):
        """FL-39d: differential test of m4d3723_lifted (original 0x4d3723)"""
        self.run_key('4d3723')

    def test_4d3b95_lifted(self):
        """FL-39d: differential test of m4d3b95_lifted (original 0x4d3b95)"""
        self.run_key('4d3b95')

    def test_4d3c9a_lifted(self):
        """FL-39d: differential test of m4d3c9a_lifted (original 0x4d3c9a)"""
        self.run_key('4d3c9a')

    def test_4d3cba_lifted(self):
        """FL-39d: differential test of m4d3cba_lifted (original 0x4d3cba)"""
        self.run_key('4d3cba')

    def test_4d3ced_lifted(self):
        """FL-39d: differential test of m4d3ced_lifted (original 0x4d3ced)"""
        self.run_key('4d3ced')

    def test_4d4043_lifted(self):
        """FL-39d: differential test of m4d4043_lifted (original 0x4d4043)"""
        self.run_key('4d4043')

    def test_4d4645_lifted(self):
        """FL-39d: differential test of m4d4645_lifted (original 0x4d4645)"""
        self.run_key('4d4645')

    def test_4d47b0_lifted(self):
        """FL-39d: differential test of m4d47b0_lifted (original 0x4d47b0)"""
        self.run_key('4d47b0')

    def test_4d56e2_lifted(self):
        """FL-39d: differential test of m4d56e2_lifted (original 0x4d56e2)"""
        self.run_key('4d56e2')

    def test_4d57e8_lifted(self):
        """FL-39d: differential test of m4d57e8_lifted (original 0x4d57e8)"""
        self.run_key('4d57e8')

    def test_4d5834_lifted(self):
        """FL-39d: differential test of m4d5834_lifted (original 0x4d5834)"""
        self.run_key('4d5834')

    def test_4d6787_lifted(self):
        """FL-39d: differential test of m4d6787_lifted (original 0x4d6787)"""
        self.run_key('4d6787')

    def test_4d794d_lifted(self):
        """FL-39d: differential test of m4d794d_lifted (original 0x4d794d)"""
        self.run_key('4d794d')

    def test_4d79c7_lifted(self):
        """FL-39d: differential test of m4d79c7_lifted (original 0x4d79c7)"""
        self.run_key('4d79c7')

    def test_4d8f8d_lifted(self):
        """FL-39d: differential test of m4d8f8d_lifted (original 0x4d8f8d)"""
        self.run_key('4d8f8d')

    def test_4d912a_lifted(self):
        """FL-39d: differential test of m4d912a_lifted (original 0x4d912a)"""
        self.run_key('4d912a')

    def test_4d920c_lifted(self):
        """FL-39d: differential test of m4d920c_lifted (original 0x4d920c)"""
        self.run_key('4d920c')

    def test_4d9d70_lifted(self):
        """FL-39d: differential test of m4d9d70_lifted (original 0x4d9d70)"""
        self.run_key('4d9d70')

    def test_4db066_lifted(self):
        """FL-39d: differential test of m4db066_lifted (original 0x4db066)"""
        self.run_key('4db066')

    def test_4db780_lifted(self):
        """FL-39d: differential test of m4db780_lifted (original 0x4db780)"""
        self.run_key('4db780')

    def test_4db817_lifted(self):
        """FL-39d: differential test of m4db817_lifted (original 0x4db817)"""
        self.run_key('4db817')

    def test_4dbc77_lifted(self):
        """FL-39d: differential test of m4dbc77_lifted (original 0x4dbc77)"""
        self.run_key('4dbc77')

    def test_4dbfbf_lifted(self):
        """FL-39d: differential test of m4dbfbf_lifted (original 0x4dbfbf)"""
        self.run_key('4dbfbf')

    def test_4dd28d_lifted(self):
        """FL-39d: differential test of m4dd28d_lifted (original 0x4dd28d)"""
        self.run_key('4dd28d')

    def test_4dd409_lifted(self):
        """FL-39d: differential test of m4dd409_lifted (original 0x4dd409)"""
        self.run_key('4dd409')

    def test_4de009_lifted(self):
        """FL-39d: differential test of m4de009_lifted (original 0x4de009)"""
        self.run_key('4de009')

    def test_4de0cf_lifted(self):
        """FL-39d: differential test of m4de0cf_lifted (original 0x4de0cf)"""
        self.run_key('4de0cf')

    def test_4de4f9_lifted(self):
        """FL-39d: differential test of m4de4f9_lifted (original 0x4de4f9)"""
        self.run_key('4de4f9')

    def test_4de6d7_lifted(self):
        """FL-39d: differential test of m4de6d7_lifted (original 0x4de6d7)"""
        self.run_key('4de6d7')

    def test_4de6fc_lifted(self):
        """FL-39d: differential test of m4de6fc_lifted (original 0x4de6fc)"""
        self.run_key('4de6fc')

    def test_4e01b3_lifted(self):
        """FL-39d: differential test of m4e01b3_lifted (original 0x4e01b3)"""
        self.run_key('4e01b3')

    def test_4e023b_lifted(self):
        """FL-39d: differential test of m4e023b_lifted (original 0x4e023b)"""
        self.run_key('4e023b')

    def test_4e0377_lifted(self):
        """FL-39d: differential test of m4e0377_lifted (original 0x4e0377)"""
        self.run_key('4e0377')

    def test_4e0619_lifted(self):
        """FL-39d: differential test of m4e0619_lifted (original 0x4e0619)"""
        self.run_key('4e0619')

    def test_4e06c0_lifted(self):
        """FL-39d: differential test of m4e06c0_lifted (original 0x4e06c0)"""
        self.run_key('4e06c0')

    def test_4e119b_lifted(self):
        """FL-39d: differential test of m4e119b_lifted (original 0x4e119b)"""
        self.run_key('4e119b')

    def test_4e1c9f_lifted(self):
        """FL-39d: differential test of m4e1c9f_lifted (original 0x4e1c9f)"""
        self.run_key('4e1c9f')

    def test_4e2913_lifted(self):
        """FL-39d: differential test of m4e2913_lifted (original 0x4e2913)"""
        self.run_key('4e2913')

    def test_4e29b7_lifted(self):
        """FL-39d: differential test of m4e29b7_lifted (original 0x4e29b7)"""
        self.run_key('4e29b7')

    def test_4e2dd3_lifted(self):
        """FL-39d: differential test of m4e2dd3_lifted (original 0x4e2dd3)"""
        self.run_key('4e2dd3')

    def test_4e35e8_lifted(self):
        """FL-39d: differential test of m4e35e8_lifted (original 0x4e35e8)"""
        self.run_key('4e35e8')

    def test_4e364a_lifted(self):
        """FL-39d: differential test of m4e364a_lifted (original 0x4e364a)"""
        self.run_key('4e364a')

    def test_4e3691_lifted(self):
        """FL-39d: differential test of m4e3691_lifted (original 0x4e3691)"""
        self.run_key('4e3691')

    def test_4e36fc_lifted(self):
        """FL-39d: differential test of m4e36fc_lifted (original 0x4e36fc)"""
        self.run_key('4e36fc')

    def test_4e3772_lifted(self):
        """FL-39d: differential test of m4e3772_lifted (original 0x4e3772)"""
        self.run_key('4e3772')

    def test_4e3a64_lifted(self):
        """FL-39d: differential test of m4e3a64_lifted (original 0x4e3a64)"""
        self.run_key('4e3a64')

    def test_4e40a6_lifted(self):
        """FL-39d: differential test of m4e40a6_lifted (original 0x4e40a6)"""
        self.run_key('4e40a6')

    def test_4e49e2_lifted(self):
        """FL-39d: differential test of m4e49e2_lifted (original 0x4e49e2)"""
        self.run_key('4e49e2')

    def test_4e7970_lifted(self):
        """FL-39d: differential test of m4e7970_lifted (original 0x4e7970)"""
        self.run_key('4e7970')

    def test_4e79ca_lifted(self):
        """FL-39d: differential test of m4e79ca_lifted (original 0x4e79ca)"""
        self.run_key('4e79ca')

    def test_4e7c72_lifted(self):
        """FL-39d: differential test of m4e7c72_lifted (original 0x4e7c72)"""
        self.run_key('4e7c72')

    def test_4e7dad_lifted(self):
        """FL-39d: differential test of m4e7dad_lifted (original 0x4e7dad)"""
        self.run_key('4e7dad')

    def test_4e8d72_lifted(self):
        """FL-39d: differential test of m4e8d72_lifted (original 0x4e8d72)"""
        self.run_key('4e8d72')

    def test_4e94a9_lifted(self):
        """FL-39d: differential test of m4e94a9_lifted (original 0x4e94a9)"""
        self.run_key('4e94a9')

    def test_4ea1cb_lifted(self):
        """FL-39d: differential test of m4ea1cb_lifted (original 0x4ea1cb)"""
        self.run_key('4ea1cb')

    def test_4ea361_lifted(self):
        """FL-39d: differential test of m4ea361_lifted (original 0x4ea361)"""
        self.run_key('4ea361')

    def test_4eb5f2_lifted(self):
        """FL-39d: differential test of m4eb5f2_lifted (original 0x4eb5f2)"""
        self.run_key('4eb5f2')

    def test_4eb9c8_lifted(self):
        """FL-39d: differential test of m4eb9c8_lifted (original 0x4eb9c8)"""
        self.run_key('4eb9c8')

    def test_4eda10_lifted(self):
        """FL-39d: differential test of m4eda10_lifted (original 0x4eda10)"""
        self.run_key('4eda10')

    def test_4edae5_lifted(self):
        """FL-39d: differential test of m4edae5_lifted (original 0x4edae5)"""
        self.run_key('4edae5')

    def test_4ee517_lifted(self):
        """FL-39d: differential test of m4ee517_lifted (original 0x4ee517)"""
        self.run_key('4ee517')

    def test_4ee572_lifted(self):
        """FL-39d: differential test of m4ee572_lifted (original 0x4ee572)"""
        self.run_key('4ee572')

    def test_4ee598_lifted(self):
        """FL-39d: differential test of m4ee598_lifted (original 0x4ee598)"""
        self.run_key('4ee598')

    def test_4ee5f2_lifted(self):
        """FL-39d: differential test of m4ee5f2_lifted (original 0x4ee5f2)"""
        self.run_key('4ee5f2')

    def test_4ee9bb_lifted(self):
        """FL-39d: differential test of m4ee9bb_lifted (original 0x4ee9bb)"""
        self.run_key('4ee9bb')

    def test_4eead0_lifted(self):
        """FL-39d: differential test of m4eead0_lifted (original 0x4eead0)"""
        self.run_key('4eead0')

    def test_4ef3ed_lifted(self):
        """FL-39d: differential test of m4ef3ed_lifted (original 0x4ef3ed)"""
        self.run_key('4ef3ed')

    def test_4ef4f0_lifted(self):
        """FL-39d: differential test of m4ef4f0_lifted (original 0x4ef4f0)"""
        self.run_key('4ef4f0')

    def test_4f67be_lifted(self):
        """FL-39d: differential test of m4f67be_lifted (original 0x4f67be)"""
        self.run_key('4f67be')

    def test_4f6810_lifted(self):
        """FL-39d: differential test of m4f6810_lifted (original 0x4f6810)"""
        self.run_key('4f6810')

    def test_4f8a17_lifted(self):
        """FL-39d: differential test of m4f8a17_lifted (original 0x4f8a17)"""
        self.run_key('4f8a17')

    def test_4fafc7_lifted(self):
        """FL-39d: differential test of m4fafc7_lifted (original 0x4fafc7)"""
        self.run_key('4fafc7')

    def test_4fb018_lifted(self):
        """FL-39d: differential test of m4fb018_lifted (original 0x4fb018)"""
        self.run_key('4fb018')

    def test_4fb071_lifted(self):
        """FL-39d: differential test of m4fb071_lifted (original 0x4fb071)"""
        self.run_key('4fb071')

    def test_4fb086_lifted(self):
        """FL-39d: differential test of m4fb086_lifted (original 0x4fb086)"""
        self.run_key('4fb086')

    def test_4fb1c6_lifted(self):
        """FL-39d: differential test of m4fb1c6_lifted (original 0x4fb1c6)"""
        self.run_key('4fb1c6')

    def test_4fb737_lifted(self):
        """FL-39d: differential test of m4fb737_lifted (original 0x4fb737)"""
        self.run_key('4fb737')

    def test_4fba86_lifted(self):
        """FL-39d: differential test of m4fba86_lifted (original 0x4fba86)"""
        self.run_key('4fba86')

    def test_4fbd7e_lifted(self):
        """FL-39d: differential test of m4fbd7e_lifted (original 0x4fbd7e)"""
        self.run_key('4fbd7e')

    def test_4fce90_lifted(self):
        """FL-39d: differential test of m4fce90_lifted (original 0x4fce90)"""
        self.run_key('4fce90')
