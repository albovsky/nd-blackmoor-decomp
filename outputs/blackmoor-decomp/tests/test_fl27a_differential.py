"""FL-27 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl27a.c on the same generated
fixtures (tests/fl27a_fixtures.py builds them; the original side is fl27a_fixtures.run_original, the same function that
tests/fl27a_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the argument objects, the globals), how many bytes the function
popped, the return value (its low 16 bits for 0x44c479, which sets only ax; a returned pointer as the original address it stands for) and
the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared as the original addresses they stand for;
'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the bytes of the object and the globals at
each call. The callees and the imports are recording stubs; the function under test runs as the original bytes. A case also requires
that its scenarios reached every instruction of the original function and took both directions of every conditional jump of it
(fl27a_fixtures.UNTAKEN_ALLOWED lists the edges that are deliberately not reached, with the reason).
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
import fl27a_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall27(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl27aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl27a_differential_shim.c'
    KERNELS = ['original_methods_fl27a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall27)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_script_poke.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_void_p, ctypes.c_int, ctypes.c_uint32]
        cls.lib.shim_fl27a.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl27aWorld'

    def native_calls(self, arrays, plans):
        """The shim's call log as comparable lists: [callee, this, *args, probe]. The probe of a callee is built from its plan, in the
        order of the stub's probe list: ('m', length) takes bytes of the shim's probe buffer, ('g', offset, size) a slice of the world snapshot."""
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
            plan = plans.get(c.id)
            if plan:
                mem, snap, pos, data = bytes(c.probe), bytes(c.world), 0, b''
                for item in plan:
                    if item[0] == 'm':
                        data += mem[pos:pos + item[1]]
                        pos += item[1]
                    else:
                        data += snap[item[1]:item[1] + item[2]]
                entry.append(data)
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
        plans = {}
        for s in sc.stubs.values():
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for name, off, ln in s.probe or ():
                if name.startswith('g:'):
                    plans.setdefault(s.name, []).append(('g', getattr(fx.World, name[2:]).offset, fx.GLOBALS[name[2:]][1]))
                else:
                    self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
                    plans.setdefault(s.name, []).append(('m', ln))
            for k, items in (s.pokes or {}).items():
                for address, size, value in items:
                    area = next((a for a in sc.areas if a.va <= address < a.va + len(a.data)), None)
                    target = ctypes.cast(ctypes.byref(by_name[area.name], address - area.va), ctypes.c_void_p).value
                    self.lib.shim_script_poke(s.name, k, target, size, value & 0xffffffff)
        result = ctypes.c_uint64(0)
        self_ptr = ptr(by_name['self']) if 'self' in by_name else None
        args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in sc.args])
        self.lib.shim_fl27a(sc.fn, self_ptr, ctypes.byref(args), ctypes.byref(sw), ctypes.byref(result))
        spec = fx.SPECS[sc.key]
        if spec.get('ret'):
            value = result.value
            if spec.get('ret_ptr'):       # a pointer into the object: the address it stands for (0 stays 0)
                arr = by_name['self']
                value = 0 if value == 0 else od.region_va(0) + (value - ctypes.addressof(arr))
            self.assertEqual(value & spec['ret'], orig.eax & spec['ret'], 'return value')
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s' % (sc.key, a.name))
        for field in sc.g:
            size = fx.GLOBALS[field][1]
            self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        actual = self.native_calls(arrays, plans)
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

    # CASES-BEGIN
    def test_4de1f5_clear_flags(self):
        """FL-27a: differential test of m4de1f5_clear_flags (original 0x4de1f5)"""
        self.run_key('4de1f5')

    def test_4de214_clear_flags_thunk(self):
        """FL-27a: differential test of m4de214_clear_flags_thunk (original 0x4de214)"""
        self.run_key('4de214')

    def test_4de2d8_reset_caption(self):
        """FL-27a: differential test of m4de2d8_reset_caption (original 0x4de2d8)"""
        self.run_key('4de2d8')

    def test_449d90_file_exists(self):
        """FL-27a: differential test of m449d90_file_exists (original 0x449d90)"""
        self.run_key('449d90')

    def test_44c479_wait_state(self):
        """FL-27a: differential test of m44c479_wait_state (original 0x44c479)"""
        self.run_key('44c479')

    def test_4bee2c_get_field(self):
        """FL-27a: differential test of m4bee2c_get_field (original 0x4bee2c)"""
        self.run_key('4bee2c')

    def test_4bef85_bink_wait(self):
        """FL-27a: differential test of m4bef85_bink_wait (original 0x4bef85)"""
        self.run_key('4bef85')

    def test_4bee5f_bink_summary(self):
        """FL-27a: differential test of m4bee5f_bink_summary (original 0x4bee5f)"""
        self.run_key('4bee5f')

    def test_4befc8_bink_do_frame(self):
        """FL-27a: differential test of m4befc8_bink_do_frame (original 0x4befc8)"""
        self.run_key('4befc8')

    def test_4bef11_bink_goto(self):
        """FL-27a: differential test of m4bef11_bink_goto (original 0x4bef11)"""
        self.run_key('4bef11')

    def test_4bf098_bink_copy_to_buffer(self):
        """FL-27a: differential test of m4bf098_bink_copy_to_buffer (original 0x4bf098)"""
        self.run_key('4bf098')

    def test_4bf10f_bink_next(self):
        """FL-27a: differential test of m4bf10f_bink_next (original 0x4bf10f)"""
        self.run_key('4bf10f')

    def test_4bf315_bink_open(self):
        """FL-27a: differential test of m4bf315_bink_open (original 0x4bf315)"""
        self.run_key('4bf315')

    def test_4c2dfb_free_pair(self):
        """FL-27a: differential test of m4c2dfb_free_pair (original 0x4c2dfb)"""
        self.run_key('4c2dfb')

    def test_4159db_dispatch_piece(self):
        """FL-27a: differential test of m4159db_dispatch_piece (original 0x4159db)"""
        self.run_key('4159db')

    # CASES-END


if __name__ == '__main__':
    unittest.main()
