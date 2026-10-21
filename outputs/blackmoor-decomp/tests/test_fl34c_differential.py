"""FL-34 (batch c) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl34c.c on the same generated
fixtures (tests/fl34c_fixtures.py builds them; the original side is fl34c_fixtures.run_original, the same function that
tests/fl34c_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the world words), how many bytes the function popped, the eax it returns (a returned
`this` is compared as such) and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared as the original addresses they stand for), the bytes
of the object and the world words at each call (probes). The callees are recording stubs; the function under test runs as the original bytes. A case also requires that its
scenarios reached every instruction of the original function and took both directions of every conditional jump of it (fl34c_fixtures.UNTAKEN_ALLOWED is empty).
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
import fl34c_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall34(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl34cDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl34c_differential_shim.c'
    KERNELS = ['original_methods_fl34c.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall34)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl34c.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl34cWorld'

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
        for i in fx.SPECS[sc.key].get('ptr_args', ()):        # these stack arguments are pointers into a fixture: the port takes host pointers
            for a, arr in arrays:
                if a.va <= native_args[i] < a.va + len(arr):
                    native_args[i] = ctypes.addressof(arr) + (native_args[i] - a.va)
                    break
            else:
                self.fail('pointer argument %d is not inside a fixture area' % i)
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in native_args])
        self.lib.shim_fl34c(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        want = fx.SELF_TOKEN if orig.eax == sc.ecx else orig.eax        # the port reports a returned `self` as the token
        if fx.SPECS[sc.key].get('retself'):
            self.assertEqual(result.value & 0xffffffff, fx.SELF_TOKEN, 'the port must return self')
        self.assertEqual(result.value & 0xffffffff, want & 0xffffffff, 'return value (eax)')
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s' % (sc.key, a.name))
        for field in sc.g:
            size = fx.GLOBALS[field][1]
            self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        actual = self.native_calls(arrays, probe_spec, deref_len)
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

    def test_4d0abc_post_message(self):
        """FL-34c: differential test of m4d0abc_post_message (original 0x4d0abc)"""
        self.run_key('4d0abc')

    def test_4d0c17_post_message(self):
        """FL-34c: differential test of m4d0c17_post_message (original 0x4d0c17)"""
        self.run_key('4d0c17')

    def test_4e01fb_post_message(self):
        """FL-34c: differential test of m4e01fb_post_message (original 0x4e01fb)"""
        self.run_key('4e01fb')

    def test_4cca9c_fill_record(self):
        """FL-34c: differential test of m4cca9c_fill_record (original 0x4cca9c)"""
        self.run_key('4cca9c')

    def test_446f77_construct(self):
        """FL-34c: differential test of m446f77_construct (original 0x446f77)"""
        self.run_key('446f77')

    def test_4fce5e_call_with_record_dword(self):
        """FL-34c: differential test of m4fce5e_call_with_record_dword (original 0x4fce5e)"""
        self.run_key('4fce5e')

    def test_4d3ffe_start_flag(self):
        """FL-34c: differential test of m4d3ffe_start_flag (original 0x4d3ffe)"""
        self.run_key('4d3ffe')

    def test_47a3d9_set_flags(self):
        """FL-34c: differential test of m47a3d9_set_flags (original 0x47a3d9)"""
        self.run_key('47a3d9')

    # CASES-END


if __name__ == '__main__':
    unittest.main()
