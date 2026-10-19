"""FL-25 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl25b.c on the same generated
fixtures (tests/fl25b_fixtures.py builds them; the original side is fl25b_fixtures.run_original, the same function that
tests/fl25b_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the record table, the object of the target record, the
globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call, and GetTickCount as an ordered event. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function
and both directions of every conditional jump of it (fl25b_fixtures.UNTAKEN_EDGES lists the two directions that no state can take).
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
import fl25b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall24(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl25bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl25b_differential_shim.c'
    KERNELS = ['original_methods_fl25b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall24)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl25b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl25bWorld'

    def native_calls(self, arrays, probe_len):
        """The shim's call log as comparable lists: [callee, this, *args, probe]; GetTickCount is ['tick', 0]."""
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
            entry = ['tick' if c.id == fx.TICK_SLOT else c.id, va_of(c.this_ptr), *[va_of(c.arg[k]) for k in range(c.nargs)]]
            if c.id in probe_len:
                entry.append(bytes(c.probe)[:probe_len[c.id]])
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
        probe_len = {}
        for s in [*sc.stubs.values(), *[x for x in sc.iat.values() if x.name != 'tick']]:
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for name, off, ln in (getattr(s, 'probe', None) or ()):
                self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            if s.out is not None:
                self.lib.shim_script_write(s.name, 0, 0, 0, 4, s.out)
            if getattr(s, 'probe', None):
                probe_len[s.name] = sum(ln for _, _, ln in s.probe)
        if sc.tick is not None:
            self.lib.shim_set_tick(sc.tick)
        result = ctypes.c_int32(0)
        self_ptr = ctypes.cast(ctypes.byref(by_name['self'], sc.self_pad), ctypes.c_void_p).value
        sa = [*sc.stack_args, 0, 0, 0, 0][:4]
        for position, name in getattr(sc, 'ptr_args', {}).items():
            sa[position] = ctypes.cast(ctypes.byref(by_name[name]), ctypes.c_void_p).value
        self.lib.shim_fl25b(sc.fn, self_ptr, *sa, ctypes.byref(sw), ctypes.byref(result))
        if sc.ret == 'eax':
            self.assertEqual(result.value & 0xffffffff, orig.eax, '%s eax' % sc.key)
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s' % (sc.key, a.name))
        for field in sc.g:
            size = fx.GLOBALS[field][1]
            self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        actual = self.native_calls(arrays, probe_len)
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
        # both directions of every conditional jump of the original (the Unicorn code hook records the next instruction after each jcc),
        # except the directions in fx.UNTAKEN_EDGES (each with its reason); an allowlisted direction that the scenarios do take is stale
        untaken = fx.untaken_edges(va, size, edges)
        allowed = sorted((a, d) for (a, d) in fx.UNTAKEN_EDGES if va <= a < va + size)
        self.assertEqual(untaken, allowed, 'untaken jump directions (address, direction) %s, allowed %s' % (
            [(hex(a), d) for a, d in untaken], [(hex(a), d) for a, d in allowed]))


    def test_455180_hit_test(self):
        """FL-25b: differential test of m455180_hit_test (original 0x455180)"""
        self.run_key('455180')

    def test_4cb058_hit_test(self):
        """FL-25b: differential test of m4cb058_hit_test (original 0x4cb058)"""
        self.run_key('4cb058')

    def test_4a3f40_hit_test(self):
        """FL-25b: differential test of m4a3f40_hit_test (original 0x4a3f40)"""
        self.run_key('4a3f40')

    def test_4588ad_click_279f_27a5(self):
        """FL-25b: differential test of m4588ad_click_279f_27a5 (original 0x4588ad)"""
        self.run_key('4588ad')

    # DIFF-TESTS-END


if __name__ == '__main__':
    unittest.main()
