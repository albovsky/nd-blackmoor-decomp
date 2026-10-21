"""FL-36 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl36b.c on the same generated
fixtures (tests/fl36b_fixtures.py builds them; the original side is fl36b_fixtures.run_original, the same function that
tests/fl36b_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl36b_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl36b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl36bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl36b_differential_shim.c'
    KERNELS = ['original_methods_fl36b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl36b.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl36bWorld'

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
        self.lib.shim_fl36b(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_40104e_get_constant(self):
        """FL-36b: differential test of m40104e_get_constant (original 0x40104e)"""
        self.run_key('40104e')

    def test_4010b0_get_constant(self):
        """FL-36b: differential test of m4010b0_get_constant (original 0x4010b0)"""
        self.run_key('4010b0')

    def test_40148a_get_constant(self):
        """FL-36b: differential test of m40148a_get_constant (original 0x40148a)"""
        self.run_key('40148a')

    def test_40167f_get_constant(self):
        """FL-36b: differential test of m40167f_get_constant (original 0x40167f)"""
        self.run_key('40167f')

    def test_402952_get_constant(self):
        """FL-36b: differential test of m402952_get_constant (original 0x402952)"""
        self.run_key('402952')

    def test_4030aa_get_constant(self):
        """FL-36b: differential test of m4030aa_get_constant (original 0x4030aa)"""
        self.run_key('4030aa')

    def test_40339b_get_constant(self):
        """FL-36b: differential test of m40339b_get_constant (original 0x40339b)"""
        self.run_key('40339b')

    def test_4033cb_get_constant(self):
        """FL-36b: differential test of m4033cb_get_constant (original 0x4033cb)"""
        self.run_key('4033cb')

    def test_404aba_get_constant(self):
        """FL-36b: differential test of m404aba_get_constant (original 0x404aba)"""
        self.run_key('404aba')

    def test_404b39_get_constant(self):
        """FL-36b: differential test of m404b39_get_constant (original 0x404b39)"""
        self.run_key('404b39')

    def test_405b62_get_constant(self):
        """FL-36b: differential test of m405b62_get_constant (original 0x405b62)"""
        self.run_key('405b62')

    def test_407baa_get_constant(self):
        """FL-36b: differential test of m407baa_get_constant (original 0x407baa)"""
        self.run_key('407baa')

    def test_407c97_get_constant(self):
        """FL-36b: differential test of m407c97_get_constant (original 0x407c97)"""
        self.run_key('407c97')

    def test_407d90_get_constant(self):
        """FL-36b: differential test of m407d90_get_constant (original 0x407d90)"""
        self.run_key('407d90')

    def test_408a1a_get_constant(self):
        """FL-36b: differential test of m408a1a_get_constant (original 0x408a1a)"""
        self.run_key('408a1a')

    def test_40906b_get_constant(self):
        """FL-36b: differential test of m40906b_get_constant (original 0x40906b)"""
        self.run_key('40906b')

    def test_40909b_get_constant(self):
        """FL-36b: differential test of m40909b_get_constant (original 0x40909b)"""
        self.run_key('40909b')

    def test_414527_get_constant(self):
        """FL-36b: differential test of m414527_get_constant (original 0x414527)"""
        self.run_key('414527')

    def test_41a4be_empty_method(self):
        """FL-36b: differential test of m41a4be_empty_method (original 0x41a4be)"""
        self.run_key('41a4be')

    def test_41be0a_get_constant(self):
        """FL-36b: differential test of m41be0a_get_constant (original 0x41be0a)"""
        self.run_key('41be0a')

    def test_4229fa_get_constant(self):
        """FL-36b: differential test of m4229fa_get_constant (original 0x4229fa)"""
        self.run_key('4229fa')

    def test_426510_get_constant(self):
        """FL-36b: differential test of m426510_get_constant (original 0x426510)"""
        self.run_key('426510')

    def test_43eb1a_get_constant(self):
        """FL-36b: differential test of m43eb1a_get_constant (original 0x43eb1a)"""
        self.run_key('43eb1a')

    def test_43eb2a_get_constant(self):
        """FL-36b: differential test of m43eb2a_get_constant (original 0x43eb2a)"""
        self.run_key('43eb2a')

    def test_43ef00_get_constant(self):
        """FL-36b: differential test of m43ef00_get_constant (original 0x43ef00)"""
        self.run_key('43ef00')

    def test_446f67_get_constant(self):
        """FL-36b: differential test of m446f67_get_constant (original 0x446f67)"""
        self.run_key('446f67')

    def test_447e17_get_constant(self):
        """FL-36b: differential test of m447e17_get_constant (original 0x447e17)"""
        self.run_key('447e17')

    def test_447e78_empty_method(self):
        """FL-36b: differential test of m447e78_empty_method (original 0x447e78)"""
        self.run_key('447e78')

    def test_448853_empty_method(self):
        """FL-36b: differential test of m448853_empty_method (original 0x448853)"""
        self.run_key('448853')

    def test_448871_empty_method(self):
        """FL-36b: differential test of m448871_empty_method (original 0x448871)"""
        self.run_key('448871')

    def test_44afa7_get_constant(self):
        """FL-36b: differential test of m44afa7_get_constant (original 0x44afa7)"""
        self.run_key('44afa7')

    def test_44d087_get_constant(self):
        """FL-36b: differential test of m44d087_get_constant (original 0x44d087)"""
        self.run_key('44d087')

    def test_44e025_get_constant(self):
        """FL-36b: differential test of m44e025_get_constant (original 0x44e025)"""
        self.run_key('44e025')

    def test_44e6e7_get_constant(self):
        """FL-36b: differential test of m44e6e7_get_constant (original 0x44e6e7)"""
        self.run_key('44e6e7')

    def test_44e80b_empty_method(self):
        """FL-36b: differential test of m44e80b_empty_method (original 0x44e80b)"""
        self.run_key('44e80b')

    def test_44f4ea_get_constant(self):
        """FL-36b: differential test of m44f4ea_get_constant (original 0x44f4ea)"""
        self.run_key('44f4ea')

    def test_454d0a_get_constant(self):
        """FL-36b: differential test of m454d0a_get_constant (original 0x454d0a)"""
        self.run_key('454d0a')

    def test_456506_get_constant(self):
        """FL-36b: differential test of m456506_get_constant (original 0x456506)"""
        self.run_key('456506')

    def test_456c87_get_constant(self):
        """FL-36b: differential test of m456c87_get_constant (original 0x456c87)"""
        self.run_key('456c87')

    def test_457bc8_get_constant(self):
        """FL-36b: differential test of m457bc8_get_constant (original 0x457bc8)"""
        self.run_key('457bc8')

    def test_457efa_get_constant(self):
        """FL-36b: differential test of m457efa_get_constant (original 0x457efa)"""
        self.run_key('457efa')

    def test_4595e1_get_constant(self):
        """FL-36b: differential test of m4595e1_get_constant (original 0x4595e1)"""
        self.run_key('4595e1')

    def test_459a6a_get_constant(self):
        """FL-36b: differential test of m459a6a_get_constant (original 0x459a6a)"""
        self.run_key('459a6a')

    def test_45ae5e_get_constant(self):
        """FL-36b: differential test of m45ae5e_get_constant (original 0x45ae5e)"""
        self.run_key('45ae5e')

    def test_45b36a_get_constant(self):
        """FL-36b: differential test of m45b36a_get_constant (original 0x45b36a)"""
        self.run_key('45b36a')

    def test_45d2b6_get_constant(self):
        """FL-36b: differential test of m45d2b6_get_constant (original 0x45d2b6)"""
        self.run_key('45d2b6')

    def test_45dc0a_get_constant(self):
        """FL-36b: differential test of m45dc0a_get_constant (original 0x45dc0a)"""
        self.run_key('45dc0a')

    def test_460f16_get_constant(self):
        """FL-36b: differential test of m460f16_get_constant (original 0x460f16)"""
        self.run_key('460f16')

    def test_4617a7_get_constant(self):
        """FL-36b: differential test of m4617a7_get_constant (original 0x4617a7)"""
        self.run_key('4617a7')

    def test_463b00_get_constant(self):
        """FL-36b: differential test of m463b00_get_constant (original 0x463b00)"""
        self.run_key('463b00')

    def test_463f9a_get_constant(self):
        """FL-36b: differential test of m463f9a_get_constant (original 0x463f9a)"""
        self.run_key('463f9a')

    def test_4657d7_get_constant(self):
        """FL-36b: differential test of m4657d7_get_constant (original 0x4657d7)"""
        self.run_key('4657d7')

    def test_465a87_get_constant(self):
        """FL-36b: differential test of m465a87_get_constant (original 0x465a87)"""
        self.run_key('465a87')

    def test_465bd3_empty_method(self):
        """FL-36b: differential test of m465bd3_empty_method (original 0x465bd3)"""
        self.run_key('465bd3')

    def test_466e04_get_constant(self):
        """FL-36b: differential test of m466e04_get_constant (original 0x466e04)"""
        self.run_key('466e04')

    def test_468dda_get_constant(self):
        """FL-36b: differential test of m468dda_get_constant (original 0x468dda)"""
        self.run_key('468dda')

    def test_46ab6f_get_constant(self):
        """FL-36b: differential test of m46ab6f_get_constant (original 0x46ab6f)"""
        self.run_key('46ab6f')

    def test_46b50a_get_constant(self):
        """FL-36b: differential test of m46b50a_get_constant (original 0x46b50a)"""
        self.run_key('46b50a')

    def test_46dea0_get_constant(self):
        """FL-36b: differential test of m46dea0_get_constant (original 0x46dea0)"""
        self.run_key('46dea0')

    def test_46e5ea_get_constant(self):
        """FL-36b: differential test of m46e5ea_get_constant (original 0x46e5ea)"""
        self.run_key('46e5ea')

    def test_470a63_get_constant(self):
        """FL-36b: differential test of m470a63_get_constant (original 0x470a63)"""
        self.run_key('470a63')

    def test_470cfa_get_constant(self):
        """FL-36b: differential test of m470cfa_get_constant (original 0x470cfa)"""
        self.run_key('470cfa')

    def test_472a4c_get_constant(self):
        """FL-36b: differential test of m472a4c_get_constant (original 0x472a4c)"""
        self.run_key('472a4c')

    def test_47575a_get_constant(self):
        """FL-36b: differential test of m47575a_get_constant (original 0x47575a)"""
        self.run_key('47575a')

    def test_4778cf_get_constant(self):
        """FL-36b: differential test of m4778cf_get_constant (original 0x4778cf)"""
        self.run_key('4778cf')

    def test_47817a_get_constant(self):
        """FL-36b: differential test of m47817a_get_constant (original 0x47817a)"""
        self.run_key('47817a')

    def test_47ac23_get_constant(self):
        """FL-36b: differential test of m47ac23_get_constant (original 0x47ac23)"""
        self.run_key('47ac23')

    def test_47d477_get_constant(self):
        """FL-36b: differential test of m47d477_get_constant (original 0x47d477)"""
        self.run_key('47d477')

    def test_47d677_empty_method(self):
        """FL-36b: differential test of m47d677_empty_method (original 0x47d677)"""
        self.run_key('47d677')

    def test_47df47_get_constant(self):
        """FL-36b: differential test of m47df47_get_constant (original 0x47df47)"""
        self.run_key('47df47')

    def test_47e1da_get_constant(self):
        """FL-36b: differential test of m47e1da_get_constant (original 0x47e1da)"""
        self.run_key('47e1da')

    def test_481ca9_get_constant(self):
        """FL-36b: differential test of m481ca9_get_constant (original 0x481ca9)"""
        self.run_key('481ca9')

    def test_4820fa_get_constant(self):
        """FL-36b: differential test of m4820fa_get_constant (original 0x4820fa)"""
        self.run_key('4820fa')

    def test_483ac9_get_constant(self):
        """FL-36b: differential test of m483ac9_get_constant (original 0x483ac9)"""
        self.run_key('483ac9')

    def test_483eea_get_constant(self):
        """FL-36b: differential test of m483eea_get_constant (original 0x483eea)"""
        self.run_key('483eea')

    def test_4876dd_get_constant(self):
        """FL-36b: differential test of m4876dd_get_constant (original 0x4876dd)"""
        self.run_key('4876dd')

    def test_487a9a_get_constant(self):
        """FL-36b: differential test of m487a9a_get_constant (original 0x487a9a)"""
        self.run_key('487a9a')

    def test_487bcc_empty_method(self):
        """FL-36b: differential test of m487bcc_empty_method (original 0x487bcc)"""
        self.run_key('487bcc')

    def test_4889e0_get_constant(self):
        """FL-36b: differential test of m4889e0_get_constant (original 0x4889e0)"""
        self.run_key('4889e0')

    def test_488d5a_get_constant(self):
        """FL-36b: differential test of m488d5a_get_constant (original 0x488d5a)"""
        self.run_key('488d5a')

    def test_48a3cb_get_constant(self):
        """FL-36b: differential test of m48a3cb_get_constant (original 0x48a3cb)"""
        self.run_key('48a3cb')

    def test_48a68a_get_constant(self):
        """FL-36b: differential test of m48a68a_get_constant (original 0x48a68a)"""
        self.run_key('48a68a')

    def test_48b720_get_constant(self):
        """FL-36b: differential test of m48b720_get_constant (original 0x48b720)"""
        self.run_key('48b720')

    def test_48ba97_get_constant(self):
        """FL-36b: differential test of m48ba97_get_constant (original 0x48ba97)"""
        self.run_key('48ba97')

    def test_48bc9b_empty_method(self):
        """FL-36b: differential test of m48bc9b_empty_method (original 0x48bc9b)"""
        self.run_key('48bc9b')

    def test_48cc60_get_constant(self):
        """FL-36b: differential test of m48cc60_get_constant (original 0x48cc60)"""
        self.run_key('48cc60')

    def test_48cfe7_get_constant(self):
        """FL-36b: differential test of m48cfe7_get_constant (original 0x48cfe7)"""
        self.run_key('48cfe7')

    def test_48dec7_get_constant(self):
        """FL-36b: differential test of m48dec7_get_constant (original 0x48dec7)"""
        self.run_key('48dec7')

    def test_48e20a_get_constant(self):
        """FL-36b: differential test of m48e20a_get_constant (original 0x48e20a)"""
        self.run_key('48e20a')

    def test_49026c_get_constant(self):
        """FL-36b: differential test of m49026c_get_constant (original 0x49026c)"""
        self.run_key('49026c')

    def test_4904ea_get_constant(self):
        """FL-36b: differential test of m4904ea_get_constant (original 0x4904ea)"""
        self.run_key('4904ea')

    def test_494f14_empty_method(self):
        """FL-36b: differential test of m494f14_empty_method (original 0x494f14)"""
        self.run_key('494f14')

    def test_49c45c_get_constant(self):
        """FL-36b: differential test of m49c45c_get_constant (original 0x49c45c)"""
        self.run_key('49c45c')

    def test_49c52a_get_constant(self):
        """FL-36b: differential test of m49c52a_get_constant (original 0x49c52a)"""
        self.run_key('49c52a')

    def test_4a1bc7_get_constant(self):
        """FL-36b: differential test of m4a1bc7_get_constant (original 0x4a1bc7)"""
        self.run_key('4a1bc7')

    def test_4a35c7_get_constant(self):
        """FL-36b: differential test of m4a35c7_get_constant (original 0x4a35c7)"""
        self.run_key('4a35c7')

    def test_4a370a_get_constant(self):
        """FL-36b: differential test of m4a370a_get_constant (original 0x4a370a)"""
        self.run_key('4a370a')

    def test_4a5eda_get_constant(self):
        """FL-36b: differential test of m4a5eda_get_constant (original 0x4a5eda)"""
        self.run_key('4a5eda')

    def test_4a630a_get_constant(self):
        """FL-36b: differential test of m4a630a_get_constant (original 0x4a630a)"""
        self.run_key('4a630a')

    def test_4a64ae_empty_method(self):
        """FL-36b: differential test of m4a64ae_empty_method (original 0x4a64ae)"""
        self.run_key('4a64ae')

    def test_4a7a19_get_constant(self):
        """FL-36b: differential test of m4a7a19_get_constant (original 0x4a7a19)"""
        self.run_key('4a7a19')

    def test_4a7bfa_get_constant(self):
        """FL-36b: differential test of m4a7bfa_get_constant (original 0x4a7bfa)"""
        self.run_key('4a7bfa')

    def test_4a9b1b_get_constant(self):
        """FL-36b: differential test of m4a9b1b_get_constant (original 0x4a9b1b)"""
        self.run_key('4a9b1b')

    def test_4a9ea7_get_constant(self):
        """FL-36b: differential test of m4a9ea7_get_constant (original 0x4a9ea7)"""
        self.run_key('4a9ea7')

    def test_4aaef5_get_constant(self):
        """FL-36b: differential test of m4aaef5_get_constant (original 0x4aaef5)"""
        self.run_key('4aaef5')

    def test_4ab327_get_constant(self):
        """FL-36b: differential test of m4ab327_get_constant (original 0x4ab327)"""
        self.run_key('4ab327')

    def test_4ac488_get_constant(self):
        """FL-36b: differential test of m4ac488_get_constant (original 0x4ac488)"""
        self.run_key('4ac488')

    def test_4ac85a_get_constant(self):
        """FL-36b: differential test of m4ac85a_get_constant (original 0x4ac85a)"""
        self.run_key('4ac85a')

    def test_4afa0e_get_constant(self):
        """FL-36b: differential test of m4afa0e_get_constant (original 0x4afa0e)"""
        self.run_key('4afa0e')

    def test_4afcba_get_constant(self):
        """FL-36b: differential test of m4afcba_get_constant (original 0x4afcba)"""
        self.run_key('4afcba')

    def test_4afdfe_empty_method(self):
        """FL-36b: differential test of m4afdfe_empty_method (original 0x4afdfe)"""
        self.run_key('4afdfe')

    def test_4b371c_get_constant(self):
        """FL-36b: differential test of m4b371c_get_constant (original 0x4b371c)"""
        self.run_key('4b371c')

    def test_4b3bda_get_constant(self):
        """FL-36b: differential test of m4b3bda_get_constant (original 0x4b3bda)"""
        self.run_key('4b3bda')

    def test_4b5838_get_constant(self):
        """FL-36b: differential test of m4b5838_get_constant (original 0x4b5838)"""
        self.run_key('4b5838')

    def test_4b5b0a_get_constant(self):
        """FL-36b: differential test of m4b5b0a_get_constant (original 0x4b5b0a)"""
        self.run_key('4b5b0a')

    def test_4b7041_get_constant(self):
        """FL-36b: differential test of m4b7041_get_constant (original 0x4b7041)"""
        self.run_key('4b7041')

    def test_4b7177_get_constant(self):
        """FL-36b: differential test of m4b7177_get_constant (original 0x4b7177)"""
        self.run_key('4b7177')

    def test_4b7ddd_get_constant(self):
        """FL-36b: differential test of m4b7ddd_get_constant (original 0x4b7ddd)"""
        self.run_key('4b7ddd')

    def test_4c0f60_get_constant(self):
        """FL-36b: differential test of m4c0f60_get_constant (original 0x4c0f60)"""
        self.run_key('4c0f60')

    def test_4cc917_get_constant(self):
        """FL-36b: differential test of m4cc917_get_constant (original 0x4cc917)"""
        self.run_key('4cc917')

    def test_4d3b0a_get_constant(self):
        """FL-36b: differential test of m4d3b0a_get_constant (original 0x4d3b0a)"""
        self.run_key('4d3b0a')

    def test_4d3b8a_empty_method(self):
        """FL-36b: differential test of m4d3b8a_empty_method (original 0x4d3b8a)"""
        self.run_key('4d3b8a')

    def test_4d3d3d_empty_method(self):
        """FL-36b: differential test of m4d3d3d_empty_method (original 0x4d3d3d)"""
        self.run_key('4d3d3d')

    def test_4d4192_get_constant(self):
        """FL-36b: differential test of m4d4192_get_constant (original 0x4d4192)"""
        self.run_key('4d4192')

    def test_4d51f7_get_constant(self):
        """FL-36b: differential test of m4d51f7_get_constant (original 0x4d51f7)"""
        self.run_key('4d51f7')

    def test_4d529b_empty_method(self):
        """FL-36b: differential test of m4d529b_empty_method (original 0x4d529b)"""
        self.run_key('4d529b')

    def test_4dbf0a_get_constant(self):
        """FL-36b: differential test of m4dbf0a_get_constant (original 0x4dbf0a)"""
        self.run_key('4dbf0a')

    def test_4dd3eb_empty_method(self):
        """FL-36b: differential test of m4dd3eb_empty_method (original 0x4dd3eb)"""
        self.run_key('4dd3eb')

    def test_4f003b_empty_method(self):
        """FL-36b: differential test of m4f003b_empty_method (original 0x4f003b)"""
        self.run_key('4f003b')


if __name__ == '__main__':
    unittest.main()
