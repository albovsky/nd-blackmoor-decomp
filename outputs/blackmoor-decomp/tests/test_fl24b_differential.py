"""FL-24 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl24b.c on the same generated
fixtures (tests/fl24b_fixtures.py builds them; the original side is fl24b_fixtures.run_original, the same function that
tests/fl24b_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the record table, the object of the target record, the
globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call, and GetTickCount as an ordered event. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function
and both directions of every conditional jump of it (fl24b_fixtures.UNTAKEN_EDGES lists the two directions that no state can take).
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
import fl24b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall24(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl24bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl24b_differential_shim.c'
    KERNELS = ['original_methods_fl24b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall24)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl24b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl24bWorld'

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
        self.lib.shim_fl24b(sc.fn, self_ptr, *sa, ctypes.byref(sw), ctypes.byref(result))
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


    def test_4dad60_init_swap_buttons(self):
        """FL-24b: differential test of m4dad60_init_swap_buttons (original 0x4dad60)"""
        self.run_key('4dad60')

    def test_466073_click_27d2_27d3(self):
        """FL-24b: differential test of m466073_click_27d2_27d3 (original 0x466073)"""
        self.run_key('466073')

    def test_467740_hit_test(self):
        """FL-24b: differential test of m467740_hit_test (original 0x467740)"""
        self.run_key('467740')

    def test_4b7563_click_27bf_27c1(self):
        """FL-24b: differential test of m4b7563_click_27bf_27c1 (original 0x4b7563)"""
        self.run_key('4b7563')

    def test_459e49_click_2742(self):
        """FL-24b: differential test of m459e49_click_2742 (original 0x459e49)"""
        self.run_key('459e49')

    def test_482359_hit_test(self):
        """FL-24b: differential test of m482359_hit_test (original 0x482359)"""
        self.run_key('482359')

    def test_46793a_click_27ab_27ac(self):
        """FL-24b: differential test of m46793a_click_27ab_27ac (original 0x46793a)"""
        self.run_key('46793a')

    def test_4ad310_click_2774_2776(self):
        """FL-24b: differential test of m4ad310_click_2774_2776 (original 0x4ad310)"""
        self.run_key('4ad310')

    def test_4acf45_hit_test(self):
        """FL-24b: differential test of m4acf45_hit_test (original 0x4acf45)"""
        self.run_key('4acf45')

    def test_4aa0f0_hit_test(self):
        """FL-24b: differential test of m4aa0f0_hit_test (original 0x4aa0f0)"""
        self.run_key('4aa0f0')

    def test_487ed5_click_2788_2789(self):
        """FL-24b: differential test of m487ed5_click_2788_2789 (original 0x487ed5)"""
        self.run_key('487ed5')

    def test_464c59_click_27c9_27cd(self):
        """FL-24b: differential test of m464c59_click_27c9_27cd (original 0x464c59)"""
        self.run_key('464c59')


if __name__ == '__main__':
    unittest.main()
