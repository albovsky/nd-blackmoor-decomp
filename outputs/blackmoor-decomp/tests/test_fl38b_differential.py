"""FL-38 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl38b.c on the same generated fixtures (tests/fl38b_fixtures.py builds them;
the original side is fl38b_fixtures.run_original, the same function that tests/fl38b_original_oracle.py uses).

Every case compares all the memory the function can write (the three cells, the source and destination buffers and the globals), the status (0, or 1 where the original reaches the callee
0x4c97b4 that ends the program), and the ordered calls out: callee, ecx, stack arguments. The callees are recording stubs; the function under test runs as the original bytes. A case also
requires that its scenarios reached every instruction of the original function and took both directions of every conditional jump of it (fl38b_fixtures.UNTAKEN_ALLOWED is empty).
Where the original reaches 0x4c97b4 the run stops there (the real callee ends the program): the native port must make the same calls up to it and leave everything but the three cells
unchanged.
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
import fl38b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall38(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl38bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl38b_differential_shim.c'
    KERNELS = ['original_methods_fl38b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall38)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_fl38b.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl38bWorld'

    def native_calls(self):
        """The shim's call log as comparable lists: [callee, this, *args]."""
        calls = self.lib.shim_calls()
        return [[calls[i].id, calls[i].this_ptr, *[calls[i].arg[k] for k in range(calls[i].nargs)]] for i in range(self.lib.shim_call_count())]

    def pair(self, sc, executed, edges):
        """Runs the original and the native function on scenario `sc` and compares."""
        orig, expected, _ = fx.run_original(sc)
        self.lib.shim_reset()
        arrays = []
        for a in sc.areas:
            arr = buf(a.data)
            arrays.append((a, arr))
            self.lib.shim_add_region(a.va, ptr(arr), len(arr))
        sw = fx.World()
        for field, value in sc.g.items():
            setattr(sw, field, value & ((1 << (8 * fx.GLOBALS[field][1])) - 1))
        for s in sc.stubs.values():
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
        result = ctypes.c_int32(-1)
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in sc.args])
        self.lib.shim_fl38b(sc.fn, None, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        self.assertEqual(result.value, 0 if sc.partial is None else 1, 'status (1 = the port stops at the callee that ends the program)')
        if sc.partial is None:
            for a, arr in arrays:
                if a.compare:
                    self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s %s' % (sc.key, a.name, sc.profile))
            for field in sc.g:
                size = fx.GLOBALS[field][1]
                self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        else:       # the port stops after sc.partial[0] calls: compare that prefix, and require that every byte of every area but the named ones ({area: nbytes} = the original's first bytes) is unchanged
            expected = expected[:sc.partial[0]]
            for a, arr in arrays:
                want = bytearray(a.data)
                n = sc.partial[1].get(a.name, 0)
                if n:
                    want[:n] = orig.memory[a.name][:n]
                self.assertEqual(bytes(arr), bytes(want), '%s %s (the stop must leave everything else unchanged)' % (sc.key, a.name))
            for field, value in sc.g.items():
                size = fx.GLOBALS[field][1]
                self.assertEqual(getattr(sw, field) & ((1 << (8 * size)) - 1), value & ((1 << (8 * size)) - 1), field)
        self.assertEqual(self.native_calls(), expected, '%s scenario profile %s' % (sc.key, sc.profile))
        executed |= orig.executed
        edges |= orig.edges

    def run_key(self, key):
        rng = random.Random(int(key, 16))
        executed, edges = set(), set()
        va, size = fx.SPECS[key]['va'], fx.SPECS[key]['size']
        for n in range(fx.scenarios(key)):
            self.pair(fx.build(key, rng, n), executed, edges)
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])
        unexpected, stale, _ = fx.check_edges(key, edges)
        self.assertEqual(unexpected, [], 'conditional jumps never taken one way (address, direction): %s' % [(hex(a), d) for a, d in unexpected])
        self.assertEqual(stale, [], 'allowlisted untaken edges that are taken after all (remove them): %s' % [(hex(a), d) for a, d in stale])

    def test_44d1d1_clone_record(self):
        """FL-38b: differential test of m44d1d1_clone_record (original 0x44d1d1)"""
        self.run_key('44d1d1')

    def test_456fb6_clone_record(self):
        """FL-38b: differential test of m456fb6_clone_record (original 0x456fb6)"""
        self.run_key('456fb6')

    def test_45807c_clone_record(self):
        """FL-38b: differential test of m45807c_clone_record (original 0x45807c)"""
        self.run_key('45807c')

    def test_464100_clone_record(self):
        """FL-38b: differential test of m464100_clone_record (original 0x464100)"""
        self.run_key('464100')

    def test_465bde_clone_record(self):
        """FL-38b: differential test of m465bde_clone_record (original 0x465bde)"""
        self.run_key('465bde')

    def test_46b79a_clone_record(self):
        """FL-38b: differential test of m46b79a_clone_record (original 0x46b79a)"""
        self.run_key('46b79a')

    def test_47314b_clone_record(self):
        """FL-38b: differential test of m47314b_clone_record (original 0x47314b)"""
        self.run_key('47314b')

    def test_4782db_clone_record(self):
        """FL-38b: differential test of m4782db_clone_record (original 0x4782db)"""
        self.run_key('4782db')

    def test_475964_clone_record(self):
        """FL-38b: differential test of m475964_clone_record (original 0x475964)"""
        self.run_key('475964')

    def test_44fbe3_clone_record(self):
        """FL-38b: differential test of m44fbe3_clone_record (original 0x44fbe3)"""
        self.run_key('44fbe3')

    def test_467688_clone_record(self):
        """FL-38b: differential test of m467688_clone_record (original 0x467688)"""
        self.run_key('467688')

    def test_468f9f_clone_record(self):
        """FL-38b: differential test of m468f9f_clone_record (original 0x468f9f)"""
        self.run_key('468f9f')

    def test_47e477_clone_record(self):
        """FL-38b: differential test of m47e477_clone_record (original 0x47e477)"""
        self.run_key('47e477')

    def test_44e8a2_clone_record(self):
        """FL-38b: differential test of m44e8a2_clone_record (original 0x44e8a2)"""
        self.run_key('44e8a2')

    def test_454e70_clone_record(self):
        """FL-38b: differential test of m454e70_clone_record (original 0x454e70)"""
        self.run_key('454e70')

    def test_459c10_clone_record(self):
        """FL-38b: differential test of m459c10_clone_record (original 0x459c10)"""
        self.run_key('459c10')

    def test_45ddd0_clone_record(self):
        """FL-38b: differential test of m45ddd0_clone_record (original 0x45ddd0)"""
        self.run_key('45ddd0')

    def test_47b3f0_clone_record(self):
        """FL-38b: differential test of m47b3f0_clone_record (original 0x47b3f0)"""
        self.run_key('47b3f0')


if __name__ == '__main__':
    unittest.main()
