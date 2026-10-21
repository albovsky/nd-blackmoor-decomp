"""FL-36 (batch c) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl36c.c on the same generated
fixtures (tests/fl36c_fixtures.py builds them; the original side is fl36c_fixtures.run_original, the same function that
tests/fl36c_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl36c_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl36c_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl36cDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl36c_differential_shim.c'
    KERNELS = ['original_methods_fl36c.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl36c.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl36cWorld'

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
        self.lib.shim_fl36c(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_401032_init_vtable_call(self):
        """FL-36c: differential test of m401032_init_vtable_call (original 0x401032)"""
        self.run_key('401032')

    def test_4014f5_init_vtable_call(self):
        """FL-36c: differential test of m4014f5_init_vtable_call (original 0x4014f5)"""
        self.run_key('4014f5')

    def test_40168f_set_mode_call(self):
        """FL-36c: differential test of m40168f_set_mode_call (original 0x40168f)"""
        self.run_key('40168f')

    def test_4016ac_set_mode_call(self):
        """FL-36c: differential test of m4016ac_set_mode_call (original 0x4016ac)"""
        self.run_key('4016ac')

    def test_4016c9_set_mode_call(self):
        """FL-36c: differential test of m4016c9_set_mode_call (original 0x4016c9)"""
        self.run_key('4016c9')

    def test_4016e6_set_mode_call(self):
        """FL-36c: differential test of m4016e6_set_mode_call (original 0x4016e6)"""
        self.run_key('4016e6')

    def test_401703_set_mode_call(self):
        """FL-36c: differential test of m401703_set_mode_call (original 0x401703)"""
        self.run_key('401703')

    def test_401720_set_mode_call(self):
        """FL-36c: differential test of m401720_set_mode_call (original 0x401720)"""
        self.run_key('401720')

    def test_40173d_set_mode_call(self):
        """FL-36c: differential test of m40173d_set_mode_call (original 0x40173d)"""
        self.run_key('40173d')

    def test_40175a_set_mode_call(self):
        """FL-36c: differential test of m40175a_set_mode_call (original 0x40175a)"""
        self.run_key('40175a')

    def test_401777_set_mode_call(self):
        """FL-36c: differential test of m401777_set_mode_call (original 0x401777)"""
        self.run_key('401777')

    def test_401794_set_mode_call(self):
        """FL-36c: differential test of m401794_set_mode_call (original 0x401794)"""
        self.run_key('401794')

    def test_4017b1_set_mode_call(self):
        """FL-36c: differential test of m4017b1_set_mode_call (original 0x4017b1)"""
        self.run_key('4017b1')

    def test_4017ce_set_mode_call(self):
        """FL-36c: differential test of m4017ce_set_mode_call (original 0x4017ce)"""
        self.run_key('4017ce')

    def test_4017eb_set_mode_call(self):
        """FL-36c: differential test of m4017eb_set_mode_call (original 0x4017eb)"""
        self.run_key('4017eb')

    def test_401808_set_mode_call(self):
        """FL-36c: differential test of m401808_set_mode_call (original 0x401808)"""
        self.run_key('401808')

    def test_401825_set_mode_call(self):
        """FL-36c: differential test of m401825_set_mode_call (original 0x401825)"""
        self.run_key('401825')

    def test_401842_set_mode_call(self):
        """FL-36c: differential test of m401842_set_mode_call (original 0x401842)"""
        self.run_key('401842')

    def test_40185f_set_mode_call(self):
        """FL-36c: differential test of m40185f_set_mode_call (original 0x40185f)"""
        self.run_key('40185f')

    def test_40187c_set_mode_call(self):
        """FL-36c: differential test of m40187c_set_mode_call (original 0x40187c)"""
        self.run_key('40187c')

    def test_401899_set_mode_call(self):
        """FL-36c: differential test of m401899_set_mode_call (original 0x401899)"""
        self.run_key('401899')

    def test_4018b6_set_mode_call(self):
        """FL-36c: differential test of m4018b6_set_mode_call (original 0x4018b6)"""
        self.run_key('4018b6')

    def test_4018d3_set_mode_call(self):
        """FL-36c: differential test of m4018d3_set_mode_call (original 0x4018d3)"""
        self.run_key('4018d3')

    def test_4018f0_set_mode_call(self):
        """FL-36c: differential test of m4018f0_set_mode_call (original 0x4018f0)"""
        self.run_key('4018f0')

    def test_40190d_set_mode_call(self):
        """FL-36c: differential test of m40190d_set_mode_call (original 0x40190d)"""
        self.run_key('40190d')

    def test_40192a_set_mode_call(self):
        """FL-36c: differential test of m40192a_set_mode_call (original 0x40192a)"""
        self.run_key('40192a')

    def test_401947_set_mode_call(self):
        """FL-36c: differential test of m401947_set_mode_call (original 0x401947)"""
        self.run_key('401947')

    def test_401964_set_mode_call(self):
        """FL-36c: differential test of m401964_set_mode_call (original 0x401964)"""
        self.run_key('401964')

    def test_401981_set_mode_call(self):
        """FL-36c: differential test of m401981_set_mode_call (original 0x401981)"""
        self.run_key('401981')

    def test_40199e_set_mode_call(self):
        """FL-36c: differential test of m40199e_set_mode_call (original 0x40199e)"""
        self.run_key('40199e')

    def test_4019bb_set_mode_call(self):
        """FL-36c: differential test of m4019bb_set_mode_call (original 0x4019bb)"""
        self.run_key('4019bb')

    def test_4019d8_set_mode_call(self):
        """FL-36c: differential test of m4019d8_set_mode_call (original 0x4019d8)"""
        self.run_key('4019d8')

    def test_4019f5_set_mode_call(self):
        """FL-36c: differential test of m4019f5_set_mode_call (original 0x4019f5)"""
        self.run_key('4019f5')

    def test_401a12_set_mode_call(self):
        """FL-36c: differential test of m401a12_set_mode_call (original 0x401a12)"""
        self.run_key('401a12')

    def test_401a2f_set_mode_call(self):
        """FL-36c: differential test of m401a2f_set_mode_call (original 0x401a2f)"""
        self.run_key('401a2f')

    def test_401a4c_set_mode_call(self):
        """FL-36c: differential test of m401a4c_set_mode_call (original 0x401a4c)"""
        self.run_key('401a4c')

    def test_401a69_set_mode_call(self):
        """FL-36c: differential test of m401a69_set_mode_call (original 0x401a69)"""
        self.run_key('401a69')

    def test_401a86_set_mode_call(self):
        """FL-36c: differential test of m401a86_set_mode_call (original 0x401a86)"""
        self.run_key('401a86')

    def test_401aa3_set_mode_call(self):
        """FL-36c: differential test of m401aa3_set_mode_call (original 0x401aa3)"""
        self.run_key('401aa3')

    def test_401ac0_set_mode_call(self):
        """FL-36c: differential test of m401ac0_set_mode_call (original 0x401ac0)"""
        self.run_key('401ac0')

    def test_401add_set_mode_call(self):
        """FL-36c: differential test of m401add_set_mode_call (original 0x401add)"""
        self.run_key('401add')

    def test_401afa_set_mode_call(self):
        """FL-36c: differential test of m401afa_set_mode_call (original 0x401afa)"""
        self.run_key('401afa')

    def test_401b17_set_mode_call(self):
        """FL-36c: differential test of m401b17_set_mode_call (original 0x401b17)"""
        self.run_key('401b17')

    def test_401b34_set_mode_call(self):
        """FL-36c: differential test of m401b34_set_mode_call (original 0x401b34)"""
        self.run_key('401b34')

    def test_401b51_set_mode_call(self):
        """FL-36c: differential test of m401b51_set_mode_call (original 0x401b51)"""
        self.run_key('401b51')

    def test_401b6e_set_mode_call(self):
        """FL-36c: differential test of m401b6e_set_mode_call (original 0x401b6e)"""
        self.run_key('401b6e')

    def test_401b8b_set_mode_call(self):
        """FL-36c: differential test of m401b8b_set_mode_call (original 0x401b8b)"""
        self.run_key('401b8b')

    def test_401ba8_set_mode_call(self):
        """FL-36c: differential test of m401ba8_set_mode_call (original 0x401ba8)"""
        self.run_key('401ba8')

    def test_401bc5_set_mode_call(self):
        """FL-36c: differential test of m401bc5_set_mode_call (original 0x401bc5)"""
        self.run_key('401bc5')

    def test_401be2_set_mode_call(self):
        """FL-36c: differential test of m401be2_set_mode_call (original 0x401be2)"""
        self.run_key('401be2')

    def test_401bff_set_mode_call(self):
        """FL-36c: differential test of m401bff_set_mode_call (original 0x401bff)"""
        self.run_key('401bff')

    def test_404af0_init_vtable_call(self):
        """FL-36c: differential test of m404af0_init_vtable_call (original 0x404af0)"""
        self.run_key('404af0')

    def test_41458b_init_vtable_call(self):
        """FL-36c: differential test of m41458b_init_vtable_call (original 0x41458b)"""
        self.run_key('41458b')

    def test_414ccf_init_vtable_call(self):
        """FL-36c: differential test of m414ccf_init_vtable_call (original 0x414ccf)"""
        self.run_key('414ccf')

    def test_437710_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m437710_init_vtable_call_ret_self (original 0x437710)"""
        self.run_key('437710')

    def test_43eb59_init_vtable_call(self):
        """FL-36c: differential test of m43eb59_init_vtable_call (original 0x43eb59)"""
        self.run_key('43eb59')

    def test_445df0_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m445df0_init_vtable_call_ret_self (original 0x445df0)"""
        self.run_key('445df0')

    def test_445e0f_init_vtable_call(self):
        """FL-36c: differential test of m445e0f_init_vtable_call (original 0x445e0f)"""
        self.run_key('445e0f')

    def test_447d10_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m447d10_init_vtable_call_ret_self (original 0x447d10)"""
        self.run_key('447d10')

    def test_447d2f_init_vtable_call(self):
        """FL-36c: differential test of m447d2f_init_vtable_call (original 0x447d2f)"""
        self.run_key('447d2f')

    def test_447e46_init_vtable_call(self):
        """FL-36c: differential test of m447e46_init_vtable_call (original 0x447e46)"""
        self.run_key('447e46')

    def test_448820_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m448820_init_vtable_call_ret_self (original 0x448820)"""
        self.run_key('448820')

    def test_449a78_init_vtable_call(self):
        """FL-36c: differential test of m449a78_init_vtable_call (original 0x449a78)"""
        self.run_key('449a78')

    def test_44afd6_init_vtable_call(self):
        """FL-36c: differential test of m44afd6_init_vtable_call (original 0x44afd6)"""
        self.run_key('44afd6')

    def test_44d0eb_init_vtable_call(self):
        """FL-36c: differential test of m44d0eb_init_vtable_call (original 0x44d0eb)"""
        self.run_key('44d0eb')

    def test_44e74b_init_vtable_call(self):
        """FL-36c: differential test of m44e74b_init_vtable_call (original 0x44e74b)"""
        self.run_key('44e74b')

    def test_44f650_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m44f650_init_vtable_call_ret_self (original 0x44f650)"""
        self.run_key('44f650')

    def test_44f66f_init_vtable_call(self):
        """FL-36c: differential test of m44f66f_init_vtable_call (original 0x44f66f)"""
        self.run_key('44f66f')

    def test_454d6e_init_vtable_call(self):
        """FL-36c: differential test of m454d6e_init_vtable_call (original 0x454d6e)"""
        self.run_key('454d6e')

    def test_456ceb_init_vtable_call(self):
        """FL-36c: differential test of m456ceb_init_vtable_call (original 0x456ceb)"""
        self.run_key('456ceb')

    def test_457f5e_init_vtable_call(self):
        """FL-36c: differential test of m457f5e_init_vtable_call (original 0x457f5e)"""
        self.run_key('457f5e')

    def test_459ace_init_vtable_call(self):
        """FL-36c: differential test of m459ace_init_vtable_call (original 0x459ace)"""
        self.run_key('459ace')

    def test_45b3ce_init_vtable_call(self):
        """FL-36c: differential test of m45b3ce_init_vtable_call (original 0x45b3ce)"""
        self.run_key('45b3ce')

    def test_45dc6e_init_vtable_call(self):
        """FL-36c: differential test of m45dc6e_init_vtable_call (original 0x45dc6e)"""
        self.run_key('45dc6e')

    def test_46180b_init_vtable_call(self):
        """FL-36c: differential test of m46180b_init_vtable_call (original 0x46180b)"""
        self.run_key('46180b')

    def test_463ffe_init_vtable_call(self):
        """FL-36c: differential test of m463ffe_init_vtable_call (original 0x463ffe)"""
        self.run_key('463ffe')

    def test_465aeb_init_vtable_call(self):
        """FL-36c: differential test of m465aeb_init_vtable_call (original 0x465aeb)"""
        self.run_key('465aeb')

    def test_4674e0_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4674e0_init_vtable_call_ret_self (original 0x4674e0)"""
        self.run_key('4674e0')

    def test_468e3e_init_vtable_call(self):
        """FL-36c: differential test of m468e3e_init_vtable_call (original 0x468e3e)"""
        self.run_key('468e3e')

    def test_46b56e_init_vtable_call(self):
        """FL-36c: differential test of m46b56e_init_vtable_call (original 0x46b56e)"""
        self.run_key('46b56e')

    def test_470d5e_init_vtable_call(self):
        """FL-36c: differential test of m470d5e_init_vtable_call (original 0x470d5e)"""
        self.run_key('470d5e')

    def test_4757be_init_vtable_call(self):
        """FL-36c: differential test of m4757be_init_vtable_call (original 0x4757be)"""
        self.run_key('4757be')

    def test_4781de_init_vtable_call(self):
        """FL-36c: differential test of m4781de_init_vtable_call (original 0x4781de)"""
        self.run_key('4781de')

    def test_47b21f_init_vtable_call(self):
        """FL-36c: differential test of m47b21f_init_vtable_call (original 0x47b21f)"""
        self.run_key('47b21f')

    def test_47d4db_init_vtable_call(self):
        """FL-36c: differential test of m47d4db_init_vtable_call (original 0x47d4db)"""
        self.run_key('47d4db')

    def test_47e23e_init_vtable_call(self):
        """FL-36c: differential test of m47e23e_init_vtable_call (original 0x47e23e)"""
        self.run_key('47e23e')

    def test_48215e_init_vtable_call(self):
        """FL-36c: differential test of m48215e_init_vtable_call (original 0x48215e)"""
        self.run_key('48215e')

    def test_483f4e_init_vtable_call(self):
        """FL-36c: differential test of m483f4e_init_vtable_call (original 0x483f4e)"""
        self.run_key('483f4e')

    def test_487afe_init_vtable_call(self):
        """FL-36c: differential test of m487afe_init_vtable_call (original 0x487afe)"""
        self.run_key('487afe')

    def test_488d89_init_vtable_call(self):
        """FL-36c: differential test of m488d89_init_vtable_call (original 0x488d89)"""
        self.run_key('488d89')

    def test_48a6ee_init_vtable_call(self):
        """FL-36c: differential test of m48a6ee_init_vtable_call (original 0x48a6ee)"""
        self.run_key('48a6ee')

    def test_48bafb_init_vtable_call(self):
        """FL-36c: differential test of m48bafb_init_vtable_call (original 0x48bafb)"""
        self.run_key('48bafb')

    def test_48d04b_init_vtable_call(self):
        """FL-36c: differential test of m48d04b_init_vtable_call (original 0x48d04b)"""
        self.run_key('48d04b')

    def test_48e26e_init_vtable_call(self):
        """FL-36c: differential test of m48e26e_init_vtable_call (original 0x48e26e)"""
        self.run_key('48e26e')

    def test_4a1c2b_init_vtable_call(self):
        """FL-36c: differential test of m4a1c2b_init_vtable_call (original 0x4a1c2b)"""
        self.run_key('4a1c2b')

    def test_4a376e_init_vtable_call(self):
        """FL-36c: differential test of m4a376e_init_vtable_call (original 0x4a376e)"""
        self.run_key('4a376e')

    def test_4a636e_init_vtable_call(self):
        """FL-36c: differential test of m4a636e_init_vtable_call (original 0x4a636e)"""
        self.run_key('4a636e')

    def test_4a7c5e_init_vtable_call(self):
        """FL-36c: differential test of m4a7c5e_init_vtable_call (original 0x4a7c5e)"""
        self.run_key('4a7c5e')

    def test_4a9f0b_init_vtable_call(self):
        """FL-36c: differential test of m4a9f0b_init_vtable_call (original 0x4a9f0b)"""
        self.run_key('4a9f0b')

    def test_4ab38b_init_vtable_call(self):
        """FL-36c: differential test of m4ab38b_init_vtable_call (original 0x4ab38b)"""
        self.run_key('4ab38b')

    def test_4ac8be_init_vtable_call(self):
        """FL-36c: differential test of m4ac8be_init_vtable_call (original 0x4ac8be)"""
        self.run_key('4ac8be')

    def test_4afd1e_init_vtable_call(self):
        """FL-36c: differential test of m4afd1e_init_vtable_call (original 0x4afd1e)"""
        self.run_key('4afd1e')

    def test_4b3c3e_init_vtable_call(self):
        """FL-36c: differential test of m4b3c3e_init_vtable_call (original 0x4b3c3e)"""
        self.run_key('4b3c3e')

    def test_4b5b6e_init_vtable_call(self):
        """FL-36c: differential test of m4b5b6e_init_vtable_call (original 0x4b5b6e)"""
        self.run_key('4b5b6e')

    def test_4b71db_init_vtable_call(self):
        """FL-36c: differential test of m4b71db_init_vtable_call (original 0x4b71db)"""
        self.run_key('4b71db')

    def test_4b7f00_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4b7f00_init_vtable_call_ret_self (original 0x4b7f00)"""
        self.run_key('4b7f00')

    def test_4b7f1f_init_vtable_call(self):
        """FL-36c: differential test of m4b7f1f_init_vtable_call (original 0x4b7f1f)"""
        self.run_key('4b7f1f')

    def test_4b9e00_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4b9e00_init_vtable_call_ret_self (original 0x4b9e00)"""
        self.run_key('4b9e00')

    def test_4b9e1f_init_vtable_call(self):
        """FL-36c: differential test of m4b9e1f_init_vtable_call (original 0x4b9e1f)"""
        self.run_key('4b9e1f')

    def test_4bed99_init_vtable_call(self):
        """FL-36c: differential test of m4bed99_init_vtable_call (original 0x4bed99)"""
        self.run_key('4bed99')

    def test_4bf600_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4bf600_init_vtable_call_ret_self (original 0x4bf600)"""
        self.run_key('4bf600')

    def test_4bf61f_init_vtable_call(self):
        """FL-36c: differential test of m4bf61f_init_vtable_call (original 0x4bf61f)"""
        self.run_key('4bf61f')

    def test_4caed0_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4caed0_init_vtable_call_ret_self (original 0x4caed0)"""
        self.run_key('4caed0')

    def test_4cc946_init_vtable_call(self):
        """FL-36c: differential test of m4cc946_init_vtable_call (original 0x4cc946)"""
        self.run_key('4cc946')

    def test_4ccd8f_init_vtable_call(self):
        """FL-36c: differential test of m4ccd8f_init_vtable_call (original 0x4ccd8f)"""
        self.run_key('4ccd8f')

    def test_4d3b6e_init_vtable_call(self):
        """FL-36c: differential test of m4d3b6e_init_vtable_call (original 0x4d3b6e)"""
        self.run_key('4d3b6e')

    def test_4d5260_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4d5260_init_vtable_call_ret_self (original 0x4d5260)"""
        self.run_key('4d5260')

    def test_4d527f_init_vtable_call(self):
        """FL-36c: differential test of m4d527f_init_vtable_call (original 0x4d527f)"""
        self.run_key('4d527f')

    def test_4d58b0_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4d58b0_init_vtable_call_ret_self (original 0x4d58b0)"""
        self.run_key('4d58b0')

    def test_4d58cf_init_vtable_call(self):
        """FL-36c: differential test of m4d58cf_init_vtable_call (original 0x4d58cf)"""
        self.run_key('4d58cf')

    def test_4db260_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4db260_init_vtable_call_ret_self (original 0x4db260)"""
        self.run_key('4db260')

    def test_4db27f_init_vtable_call(self):
        """FL-36c: differential test of m4db27f_init_vtable_call (original 0x4db27f)"""
        self.run_key('4db27f')

    def test_4dd3b0_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4dd3b0_init_vtable_call_ret_self (original 0x4dd3b0)"""
        self.run_key('4dd3b0')

    def test_4dd3cf_init_vtable_call(self):
        """FL-36c: differential test of m4dd3cf_init_vtable_call (original 0x4dd3cf)"""
        self.run_key('4dd3cf')

    def test_4e1c83_init_vtable_call(self):
        """FL-36c: differential test of m4e1c83_init_vtable_call (original 0x4e1c83)"""
        self.run_key('4e1c83')

    def test_4ee980_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4ee980_init_vtable_call_ret_self (original 0x4ee980)"""
        self.run_key('4ee980')

    def test_4ee99f_init_vtable_call(self):
        """FL-36c: differential test of m4ee99f_init_vtable_call (original 0x4ee99f)"""
        self.run_key('4ee99f')

    def test_4f0000_init_vtable_call_ret_self(self):
        """FL-36c: differential test of m4f0000_init_vtable_call_ret_self (original 0x4f0000)"""
        self.run_key('4f0000')

    def test_4f001f_init_vtable_call(self):
        """FL-36c: differential test of m4f001f_init_vtable_call (original 0x4f001f)"""
        self.run_key('4f001f')

    def test_4fa9e7_init_vtable_call(self):
        """FL-36c: differential test of m4fa9e7_init_vtable_call (original 0x4fa9e7)"""
        self.run_key('4fa9e7')


if __name__ == '__main__':
    unittest.main()
