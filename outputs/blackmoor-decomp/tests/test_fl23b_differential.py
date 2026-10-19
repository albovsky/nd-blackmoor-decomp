"""FL-23 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl23b.c on the same generated
fixtures (tests/fl23b_fixtures.py builds them; the original side is fl23b_fixtures.run_original, the same function that
tests/fl23b_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the record table, the object of the target record, the
globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call, and GetTickCount as an ordered event. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function.
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
import fl23b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall23(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl23bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl23b_differential_shim.c'
    KERNELS = ['original_methods_fl23b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall23)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl23b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl23bWorld'

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

    def pair(self, sc, executed):
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
        for s in sc.stubs.values():
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for name, off, ln in s.probe:
                self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            probe_len[s.name] = sum(ln for _, _, ln in s.probe)
        if sc.tick is not None:
            self.lib.shim_set_tick(sc.tick)
        result = ctypes.c_int32(0)
        self_ptr = ptr(by_name['self'])
        self.lib.shim_fl23b(sc.fn, self_ptr, 0, 0, 0, 0, ctypes.byref(sw), ctypes.byref(result))
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

    def run_key(self, key):
        rng = random.Random(int(key, 16))
        executed = set()
        va, size = fx.SPECS[key]['va'], fx.SPECS[key]['size']
        for n in range(fx.SCENARIOS):
            self.pair(fx.build(key, rng, n), executed)
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])

    # CASES-BEGIN
    def test_4a1efd_click_2760(self):
        """FL-23b: differential test of m4a1efd_click_2760 (original 0x4a1efd)"""
        self.run_key('4a1efd')

    def test_4ba4f2_click_276a(self):
        """FL-23b: differential test of m4ba4f2_click_276a (original 0x4ba4f2)"""
        self.run_key('4ba4f2')

    def test_46957d_click_272e(self):
        """FL-23b: differential test of m46957d_click_272e (original 0x46957d)"""
        self.run_key('46957d')

    def test_4b45ed_click_2739(self):
        """FL-23b: differential test of m4b45ed_click_2739 (original 0x4b45ed)"""
        self.run_key('4b45ed')

    def test_473ffc_click_27a1(self):
        """FL-23b: differential test of m473ffc_click_27a1 (original 0x473ffc)"""
        self.run_key('473ffc')

    def test_48e851_click_27b8_27b9(self):
        """FL-23b: differential test of m48e851_click_27b8_27b9 (original 0x48e851)"""
        self.run_key('48e851')

    def test_45e587_click_27ec_27ef(self):
        """FL-23b: differential test of m45e587_click_27ec_27ef (original 0x45e587)"""
        self.run_key('45e587')

    def test_48ab49_click_2756_2757(self):
        """FL-23b: differential test of m48ab49_click_2756_2757 (original 0x48ab49)"""
        self.run_key('48ab49')

    def test_4ab899_click_27ce_27d0(self):
        """FL-23b: differential test of m4ab899_click_27ce_27d0 (original 0x4ab899)"""
        self.run_key('4ab899')

    def test_4574e4_click_27bc_27be(self):
        """FL-23b: differential test of m4574e4_click_27bc_27be (original 0x4574e4)"""
        self.run_key('4574e4')

    def test_47a03c_click_279c_279d(self):
        """FL-23b: differential test of m47a03c_click_279c_279d (original 0x47a03c)"""
        self.run_key('47a03c')

    def test_4b2a9e_click_2792_2793(self):
        """FL-23b: differential test of m4b2a9e_click_2792_2793 (original 0x4b2a9e)"""
        self.run_key('4b2a9e')


if __name__ == '__main__':
    unittest.main()
