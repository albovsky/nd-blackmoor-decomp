"""FL-26 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl26b.c on the same generated
fixtures (tests/fl26b_fixtures.py builds them; the original side is fl26b_fixtures.run_original, the same function that
tests/fl26b_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the record table, the object of the target record, the
globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call, and GetTickCount as an ordered event. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl26b_fixtures.UNTAKEN_ALLOWED lists the one edge that is deliberately not reached, with the reason).
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
import fl26b_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall24(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 128), ('probe', ctypes.c_uint8 * 4096)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl26bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl26b_differential_shim.c'
    KERNELS = ['original_methods_fl26b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall24)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_reject.restype = ctypes.c_int32
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl26b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 3 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl26bWorld'

    def native_calls(self, arrays, probe_len, deref_len):
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
            if c.id in deref_len:
                entry.append(bytes(0 if b == 0x71 else b for b in bytes(c.data)[:deref_len[c.id]]))
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
        probe_len, deref_len = {}, {}
        for s in sc.stubs.values():
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for name, off, ln in s.probe:
                self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            probe_len[s.name] = sum(ln for _, _, ln in s.probe)
            for arg, nbytes in getattr(s, 'derefs', None) or ():
                self.lib.shim_script_deref(s.name, arg, nbytes)
                deref_len[s.name] = nbytes
        if sc.tick is not None:
            self.lib.shim_set_tick(sc.tick)
        result = ctypes.c_int32(0)
        self_ptr = ptr(by_name['self'])
        self.lib.shim_fl26b(sc.fn, self_ptr, sc.args[0] & 0xffffffffffffffff, sc.args[1] & 0xffffffffffffffff, (sc.args[2] if len(sc.args) > 2 else 0), ctypes.byref(sw), ctypes.byref(result))
        if fx.SPECS[sc.key].get('ret'):
            self.assertEqual(result.value & 0xffffffff, orig.eax & 0xffffffff, 'return value')
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s profile %s' % (sc.key, a.name, sc.profile))
        for field in sc.g:
            size = fx.GLOBALS[field][1]
            self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        actual = self.native_calls(arrays, probe_len, deref_len)
        for entry in actual:
            for index in sc.word_args.get(entry[0], ()):
                entry[2 + index] &= 0xffff
        self.assertEqual(self.lib.shim_reject(), 0, 'a valid scenario was rejected')
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
    def test_423fbb_leaf_word(self):
        """FL-26b: differential test of m423fbb_leaf_word (original 0x423fbb)"""
        self.run_key('423fbb')

    def test_4eb107_item_use_feedback(self):
        """FL-26b: differential test of m4eb107_item_use_feedback (original 0x4eb107)"""
        self.run_key('4eb107')

    def test_42406d_propagate(self):
        """FL-26b: differential test of m42406d_propagate (original 0x42406d)"""
        self.run_key('42406d')

    def test_424201_walk(self):
        """FL-26b: differential test of m424201_walk (original 0x424201)"""
        self.run_key('424201')

    def test_42ea87_record_state(self):
        """FL-26b: differential test of m42ea87_record_state (original 0x42ea87)"""
        self.run_key('42ea87')

    def test_4eb184_use_feedback(self):
        """FL-26b: differential test of m4eb184_use_feedback (original 0x4eb184)"""
        self.run_key('4eb184')

    def test_unsafe_loops_never_return_in_the_original(self):
        """The two endless loops that the port rejects (a node of kind 3 in 0x424201, a cycle of the [+0x38] chain in 0x42406d) are real: the original
        bytes do not return within the instruction limit on such a fixture (the jne at 0x424271 is the untaken-edge allowlist entry)."""
        sc = fx.build('424201', random.Random(1), 0)
        nodes = next(a for a in sc.areas if a.name == 'nodes')
        head = struct.unpack_from('<I', next(a for a in sc.areas if a.name == 'self').data, 4)[0] - nodes.va
        struct.pack_into('<I', nodes.data, head, 3)
        with self.assertRaises(RuntimeError):
            fx.run_original(sc)
        sc = fx.build('42406d', random.Random(2), 0)
        nodes = next(a for a in sc.areas if a.name == 'nodes')
        head = struct.unpack_from('<I', next(a for a in sc.areas if a.name == 'self').data, 4)[0] - nodes.va
        struct.pack_into('<I', nodes.data, head + 0x38, nodes.va + head)
        with self.assertRaises(RuntimeError):
            fx.run_original(sc)

    # CASES-END


if __name__ == '__main__':
    unittest.main()
