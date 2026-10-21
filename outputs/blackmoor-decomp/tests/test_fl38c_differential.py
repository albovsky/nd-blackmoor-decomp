"""FL-38 (batch c) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl38c.c on the same generated fixtures (tests/fl38c_fixtures.py builds them;
the original side is fl38c_fixtures.run_original, the same function that tests/fl38c_original_oracle.py uses).

Every case compares all the memory the function can write (the object, the tables, the rectangles, the blocks and the globals), the ordered calls out (callee, ecx, stack arguments, the bytes
of the string the function passed on) and, where the original returns the eax of its last callee, the return value. The callees are recording stubs; the function under test runs as the
original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional jump of it
(fl38c_fixtures.UNTAKEN_ALLOWED is empty). `test_whole_instruction_streams` asserts, from GAME.EXE, that every row of a shape has the same instruction stream as the other rows of the shape
once the numbers are masked (the jump targets as instruction indices).
"""
import ctypes
from pathlib import Path
import random
import re
import struct
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
import fl38c_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall38(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


def masked_stream(va, size):
    """The instructions of the function with every number masked; a jump target is the index of the instruction it goes to (the encodings differ in length between rows)."""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    off = va - pe.image_base
    ins = list(md.disasm(pe.image[off:off + size], va))
    index = {i.address: k for k, i in enumerate(ins)}
    out = []
    for i in ins:
        if i.mnemonic.startswith('j') or i.mnemonic.startswith('loop'):
            out.append('%s @%d' % (i.mnemonic, index[int(i.op_str, 16)]))
        else:
            out.append('%s %s' % (i.mnemonic, re.sub(r'0x[0-9a-f]+', 'N', i.op_str)))
    return out


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl38cDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl38c_differential_shim.c'
    KERNELS = ['original_methods_fl38c.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall38)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_fl38c.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl38cWorld'

    def native_calls(self, arrays, deref_len, probe_spec):
        """The shim's call log as comparable lists: [callee, this, *args, bytes behind the pointer argument, probe]."""
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
            for arg, nbytes in deref_len.get(c.id, ()):       # the bytes behind a pointer argument that is a host pointer (a local of the function)
                entry.append(bytes(c.data)[:nbytes] if c.arg[arg] >= 1 << 32 else b'')
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
        deref_len, probe_spec = {}, {}
        for s in sc.stubs.values():
            for name, off, ln in (s.probe or ()):
                if name.startswith('g:'):
                    probe_spec.setdefault(s.name, []).append(('w', getattr(fx.World, name[2:]).offset, fx.GLOBALS[name[2:]][1]))
                else:
                    probe_spec.setdefault(s.name, []).append(('p', ln))
                    self.lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            for call, arg, offset, size_, value in s.writes:
                self.lib.shim_script_write_bytes(s.name, call, arg, offset, value, len(value))
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            for arg, nbytes in s.derefs:
                self.lib.shim_script_deref(s.name, arg, nbytes)
                deref_len.setdefault(s.name, []).append((arg, nbytes))
        result = ctypes.c_int32(0)
        self_ptr = ptr(by_name['self']) if 'self' in by_name else None
        native_args = list(sc.args)
        if fx.SPECS[sc.key]['ptr_args']:        # the stack arguments are pointers into a fixture: the port takes host pointers
            for i, v in enumerate(native_args):
                for a, arr in arrays:
                    if a.va <= v < a.va + len(arr):
                        native_args[i] = ctypes.addressof(arr) + (v - a.va)
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in native_args])
        self.lib.shim_fl38c(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        if fx.SPECS[sc.key]['ret']:
            self.assertEqual(result.value & 0xffffffff, orig.eax & 0xffffffff, 'return value (eax of the last callee)')
        for a, arr in arrays:
            if a.compare:
                self.assertEqual(bytes(arr), orig.memory[a.name], '%s %s %s' % (sc.key, a.name, sc.profile))
        for field in sc.g:
            size = fx.GLOBALS[field][1]
            self.assertEqual(struct.pack(fx.FMT[size], getattr(sw, field) & ((1 << (8 * size)) - 1)), orig.memory['g:' + field], field)
        self.assertEqual(self.native_calls(arrays, deref_len, probe_spec), expected, '%s scenario profile %s' % (sc.key, sc.profile))
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

    def test_whole_instruction_streams(self):
        """FL-38c: every row of a shape has the same masked instruction stream (jump targets as instruction indices), and ends in a ret"""
        first = {}
        for key, c in fx.ROWS.items():
            stream = masked_stream(int(key, 16), c['size'])
            shape = 'g4' if c['group'] in ('g4b', 'g4c') else c['group']
            self.assertEqual(stream, first.setdefault(shape, stream), key)
            self.assertTrue(stream[-1].startswith('ret'), key)

    def test_40430e_read_word_setting(self):
        """FL-38c: differential test of m40430e_read_word_setting (original 0x40430e)"""
        self.run_key('40430e')

    def test_404349_read_word_setting(self):
        """FL-38c: differential test of m404349_read_word_setting (original 0x404349)"""
        self.run_key('404349')

    def test_40492f_read_word_setting(self):
        """FL-38c: differential test of m40492f_read_word_setting (original 0x40492f)"""
        self.run_key('40492f')

    def test_40496a_read_word_setting(self):
        """FL-38c: differential test of m40496a_read_word_setting (original 0x40496a)"""
        self.run_key('40496a')

    def test_4049a5_read_word_setting(self):
        """FL-38c: differential test of m4049a5_read_word_setting (original 0x4049a5)"""
        self.run_key('4049a5')

    def test_4049e0_read_word_setting(self):
        """FL-38c: differential test of m4049e0_read_word_setting (original 0x4049e0)"""
        self.run_key('4049e0')

    def test_40893f_read_word_setting(self):
        """FL-38c: differential test of m40893f_read_word_setting (original 0x40893f)"""
        self.run_key('40893f')

    def test_4043b6_read_time_setting(self):
        """FL-38c: differential test of m4043b6_read_time_setting (original 0x4043b6)"""
        self.run_key('4043b6')

    def test_40445a_read_time_setting(self):
        """FL-38c: differential test of m40445a_read_time_setting (original 0x40445a)"""
        self.run_key('40445a')

    def test_4044fe_read_time_setting(self):
        """FL-38c: differential test of m4044fe_read_time_setting (original 0x4044fe)"""
        self.run_key('4044fe')

    def test_4045a2_read_time_setting(self):
        """FL-38c: differential test of m4045a2_read_time_setting (original 0x4045a2)"""
        self.run_key('4045a2')

    def test_404646_read_time_setting(self):
        """FL-38c: differential test of m404646_read_time_setting (original 0x404646)"""
        self.run_key('404646')

    def test_4046ea_read_time_setting(self):
        """FL-38c: differential test of m4046ea_read_time_setting (original 0x4046ea)"""
        self.run_key('4046ea')

    def test_454f29_shift_rect(self):
        """FL-38c: differential test of m454f29_shift_rect (original 0x454f29)"""
        self.run_key('454f29')

    def test_457071_shift_rect(self):
        """FL-38c: differential test of m457071_shift_rect (original 0x457071)"""
        self.run_key('457071')

    def test_458137_shift_rect(self):
        """FL-38c: differential test of m458137_shift_rect (original 0x458137)"""
        self.run_key('458137')

    def test_46453b_shift_rect(self):
        """FL-38c: differential test of m46453b_shift_rect (original 0x46453b)"""
        self.run_key('46453b')

    def test_466db1_shift_rect(self):
        """FL-38c: differential test of m466db1_shift_rect (original 0x466db1)"""
        self.run_key('466db1')

    def test_479d98_shift_rect(self):
        """FL-38c: differential test of m479d98_shift_rect (original 0x479d98)"""
        self.run_key('479d98')

    def test_4465fd_new_zeroed(self):
        """FL-38c: differential test of m4465fd_new_zeroed (original 0x4465fd)"""
        self.run_key('4465fd')

    def test_4547bc_new_zeroed(self):
        """FL-38c: differential test of m4547bc_new_zeroed (original 0x4547bc)"""
        self.run_key('4547bc')

    def test_454f7c_clamp_to_bounds(self):
        """FL-38c: differential test of m454f7c_clamp_to_bounds (original 0x454f7c)"""
        self.run_key('454f7c')

    def test_46458e_clamp_to_bounds(self):
        """FL-38c: differential test of m46458e_clamp_to_bounds (original 0x46458e)"""
        self.run_key('46458e')

    def test_46b855_clamp_to_bounds(self):
        """FL-38c: differential test of m46b855_clamp_to_bounds (original 0x46b855)"""
        self.run_key('46b855')


if __name__ == '__main__':
    unittest.main()
