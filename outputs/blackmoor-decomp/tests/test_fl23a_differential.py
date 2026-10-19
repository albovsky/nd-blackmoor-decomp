"""FL-23 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl23a.c on the same fixtures.

The fixtures and the runner of the original bytes are in tests/fl23a_fixtures.py (shared with tests/fl23a_original_oracle.py, which runs the
original side only). Every scenario compares all memory the function can write (the `self` object, the object behind it, the record table,
the world globals), the return value, the bytes the function popped (ret 8), and the ordered calls out: callee, ecx, stack arguments
('word' arguments, which the original pushes from a 16-bit register, by their low 16 bits) and the call-time state the scenario asks to
see (a probe). The callees are recording stubs; the function under test runs as the original bytes. A case also requires that its scenarios
reached every instruction of the original function.
"""
import ctypes
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl23a_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class World(ctypes.Structure):
    _fields_ = [(n, t) for n, t, _ in fx.WORLD_FIELDS]


class ShimCall23(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl23aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl23a_differential_shim.c'
    KERNELS = ['original_methods_fl23a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall23)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl23a.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl23aWorld'

    def native_calls(self, areas, probe_len):
        spans = [(ctypes.addressof(arr), len(arr), a.va) for a, arr in areas]

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
            if c.id in probe_len:
                entry.append(bytes(c.probe)[:probe_len[c.id]])
            out.append(entry)
        return out

    def pair(self, spec, executed):
        """The original and the native function on one scenario, compared."""
        orig, expected = fx.run_original(spec)
        self.assertEqual(orig.cleanup, 8)
        areas, stubs, g = spec['areas'], spec['stubs'], spec['g']
        self.lib.shim_reset()
        arrays, by_name = [], {}
        wide = next((a.wide for a in areas if a.wide), None)
        joined = set()
        if wide:
            # a negative record index word: the table and the areas below it are ONE contiguous host buffer that reaches fx.HI_RECORDS records
            # above the table (the original never reads there); the record at the zero-extended word leads to the decoy object, so that a
            # port that zero-extends the index reads a different object and fails the comparison instead of faulting
            parts = [a for a in areas if a.name in wide['spans']]
            joined = {a.name for a in parts}
            low = min(a.va for a in parts)
            big = bytearray(wide['table_va'] + fx.HI_RECORDS * 0x8d + 4 - low)
            for a in parts:
                big[a.va - low:a.va - low + len(a.data)] = a.data
            fx.put32(big, wide['table_va'] + wide['hi_word'] * 0x8d - low, wide['decoy_va'])
            whole = (ctypes.c_ubyte * len(big)).from_buffer(big)
            self.lib.shim_add_region(low, ptr(whole), len(big))
        for a in areas:
            if a.name in joined:
                arr = (ctypes.c_ubyte * len(a.data)).from_buffer(big, a.va - low)   # a view of the shared buffer
            else:
                arr = buf(a.data)
                self.lib.shim_add_region(a.va, ptr(arr), len(arr))
            by_name[a.name] = arr
            arrays.append((a, arr))
        sw = World()
        for field, value in g.items():
            setattr(sw, field, value & ((1 << (8 * fx.GLOBALS[field][1])) - 1))
        for field, (name, offset) in spec['pointers'].items():
            setattr(sw, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        probe_len = {}
        for s in stubs.values():
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for n, off, ln in (s.probe or ()):
                host = (ctypes.addressof(sw) + getattr(World, n[2:]).offset + off) if n.startswith('g:') else \
                    ctypes.cast(ctypes.byref(by_name[n], off), ctypes.c_void_p).value
                self.lib.shim_script_probe(s.name, host, ln)
            probe_len[s.name] = sum(ln for _, _, ln in (s.probe or ()))
        probe_len = {k: v for k, v in probe_len.items() if v}
        result = ctypes.c_int32(0)
        x, y = spec['args']
        self.lib.shim_fl23a(spec['fn'], ptr(by_name[spec['self_name']]), x & 0xffffffffffffffff, y & 0xffffffffffffffff, 0, 0, ctypes.byref(sw),
                            ctypes.byref(result))
        for a in areas:
            if a.compare:
                self.assertEqual(bytes(by_name[a.name]), orig.memory[a.name], a.name)
        for field in g:
            size_ = fx.GLOBALS[field][1]
            self.assertEqual(fx.struct.pack(fx.FMT[size_], getattr(sw, field) & ((1 << (8 * size_)) - 1)), orig.memory['g:' + field], field)
        self.assertEqual(result.value & 0xffffffff, orig.eax & 0xffffffff, 'return value')
        actual = self.native_calls(arrays, probe_len)
        for entry in actual:
            for index in spec['word_args'].get(entry[0], ()):
                entry[2 + index] &= 0xffff
        self.assertEqual(actual, expected)
        executed |= orig.executed

    def run_function(self, va):
        executed = set()
        for n, spec in enumerate(fx.scenarios(va)):
            with self.subTest(scenario=n):
                self.pair(spec, executed)
        span = fx.BY_VA[va][0]
        missing = sorted(od.instruction_addresses(va, span) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])

    # CASES-BEGIN

    def test_47d734_store_point(self):
        """FL-23a: differential test of m47d734_store_point (original 0x47d734)"""
        self.run_function(0x47d734)

    def test_4a1e16_hit_test(self):
        """FL-23a: differential test of m4a1e16_hit_test (original 0x4a1e16): the gates, the rectangle edges and the state test"""
        self.run_function(0x4a1e16)

    def test_4ba377_hit_test(self):
        """FL-23a: differential test of m4ba377_hit_test (original 0x4ba377): the two slots, their skip flags and the counter stored in the object"""
        self.run_function(0x4ba377)

    def test_459cc9_hit_test(self):
        """FL-23a: differential test of m459cc9_hit_test (original 0x459cc9): four rectangles of a record object and the disabled byte"""
        self.run_function(0x459cc9)

    def test_487c92_hit_test(self):
        """FL-23a: differential test of m487c92_hit_test (original 0x487c92): the pre-rectangle behind the flag byte and the item loop"""
        self.run_function(0x487c92)

    def test_48a920_hit_test(self):
        """FL-23a: differential test of m48a920_hit_test (original 0x48a920): the item loop with an unsigned byte count and the fallback rectangle"""
        self.run_function(0x48a920)

    def test_48e628_hit_test(self):
        """FL-23a: differential test of m48e628_hit_test (original 0x48e628): the pre-rectangle, the 0xd0-byte items and the selected-item skip"""
        self.run_function(0x48e628)

    def test_479deb_hit_test(self):
        """FL-23a: differential test of m479deb_hit_test (original 0x479deb): shrunk rectangles, the accept callee and the fallback rectangle"""
        self.run_function(0x479deb)

    def test_46ea16_hit_test(self):
        """FL-23a: differential test of m46ea16_hit_test (original 0x46ea16): the by-value structure arguments, the 16 entries and the global stores"""
        self.run_function(0x46ea16)

    def test_4b7389_hit_test(self):
        """FL-23a: differential test of m4b7389_hit_test (original 0x4b7389): three rectangles, the non-exclusive arms and the common tail"""
        self.run_function(0x4b7389)

    def test_4ab528_hit_test(self):
        """FL-23a: differential test of m4ab528_hit_test (original 0x4ab528): two item loops, the enabling words and the fallback rectangle"""
        self.run_function(0x4ab528)

    # CASES-END


if __name__ == '__main__':
    unittest.main()
