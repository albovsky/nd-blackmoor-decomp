"""FL-39 (batch f) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl39f.c on the same generated
fixtures (tests/fl39f_fixtures.py builds them; the original side is fl39f_fixtures.run_original, the same function that
tests/fl39f_original_oracle.py uses).

Every case compares all the memory the function can write (the objects, the tables and the globals), how many bytes the function popped, and the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared
as the original addresses they stand for; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits), the
state of the object and of the record table at each call. The callees are recording stubs; the
function under test runs as the original bytes. A case also requires that its scenarios reached every instruction of the original function and took both directions of every conditional
jump of it (fl39f_fixtures.UNTAKEN_ALLOWED lists the edges that the function's own instructions make impossible, with the reason).
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
import fl39f_fixtures as fx
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]


class ShimCall32(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 16),
                ('data', ctypes.c_uint8 * 256), ('probe', ctypes.c_uint8 * 4096), ('world', ctypes.c_uint8 * 256)]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl39fDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl39f_differential_shim.c'
    KERNELS = ['original_methods_fl39f.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall32)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl39f.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        cls.lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
        cls.lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
        assert cls.lib.shim_world_size() == ctypes.sizeof(fx.World), 'the World mirror does not match Fl39fWorld'

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
        self.lib.shim_fl39f(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
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

    def test_48ef40_advance_slot(self):
        """FL-39f: differential test of m48ef40_advance_slot (original 0x48ef40)"""
        self.run_key('48ef40')

    def test_4904fa_construct_record(self):
        """FL-39f: differential test of m4904fa_construct_record (original 0x4904fa)"""
        self.run_key('4904fa')

    def test_49192b_clear_block(self):
        """FL-39f: differential test of m49192b_clear_block (original 0x49192b)"""
        self.run_key('49192b')

    def test_495608_check_object(self):
        """FL-39f: differential test of m495608_check_object (original 0x495608)"""
        self.run_key('495608')

    def test_49c53a_construct_record(self):
        """FL-39f: differential test of m49c53a_construct_record (original 0x49c53a)"""
        self.run_key('49c53a')

    def test_49cf80_fill_cells(self):
        """FL-39f: differential test of m49cf80_fill_cells (original 0x49cf80)"""
        self.run_key('49cf80')

    def test_4a0c7f_count_nonempty(self):
        """FL-39f: differential test of m4a0c7f_count_nonempty (original 0x4a0c7f)"""
        self.run_key('4a0c7f')

    def test_4ac8da_init_record(self):
        """FL-39f: differential test of m4ac8da_init_record (original 0x4ac8da)"""
        self.run_key('4ac8da')

    def test_4beeb3_bind_buffer(self):
        """FL-39f: differential test of m4beeb3_bind_buffer (original 0x4beeb3)"""
        self.run_key('4beeb3')

    def test_4c9cdd_find_zero_record(self):
        """FL-39f: differential test of m4c9cdd_find_zero_record (original 0x4c9cdd)"""
        self.run_key('4c9cdd')

    def test_4d52b9_init_record(self):
        """FL-39f: differential test of m4d52b9_init_record (original 0x4d52b9)"""
        self.run_key('4d52b9')

    def test_4d6ad1_start_timer(self):
        """FL-39f: differential test of m4d6ad1_start_timer (original 0x4d6ad1)"""
        self.run_key('4d6ad1')

    def test_4d8f0a_release_list(self):
        """FL-39f: differential test of m4d8f0a_release_list (original 0x4d8f0a)"""
        self.run_key('4d8f0a')

    def test_4dc13f_copy_counted(self):
        """FL-39f: differential test of m4dc13f_copy_counted (original 0x4dc13f)"""
        self.run_key('4dc13f')

    def test_4de5f0_construct_record(self):
        """FL-39f: differential test of m4de5f0_construct_record (original 0x4de5f0)"""
        self.run_key('4de5f0')

    def test_4e0410_construct_record(self):
        """FL-39f: differential test of m4e0410_construct_record (original 0x4e0410)"""
        self.run_key('4e0410')

    def test_4e069c_copy_in(self):
        """FL-39f: differential test of m4e069c_copy_in (original 0x4e069c)"""
        self.run_key('4e069c')

    def test_4e1c50_construct_record(self):
        """FL-39f: differential test of m4e1c50_construct_record (original 0x4e1c50)"""
        self.run_key('4e1c50')

    def test_4e4428_copy_in(self):
        """FL-39f: differential test of m4e4428_copy_in (original 0x4e4428)"""
        self.run_key('4e4428')

    def test_4e498d_set_name(self):
        """FL-39f: differential test of m4e498d_set_name (original 0x4e498d)"""
        self.run_key('4e498d')

    def test_4e7a70_construct_record(self):
        """FL-39f: differential test of m4e7a70_construct_record (original 0x4e7a70)"""
        self.run_key('4e7a70')

    def test_4eb77d_fill_name_table(self):
        """FL-39f: differential test of m4eb77d_fill_name_table (original 0x4eb77d)"""
        self.run_key('4eb77d')

    def test_4eb870_construct_record(self):
        """FL-39f: differential test of m4eb870_construct_record (original 0x4eb870)"""
        self.run_key('4eb870')

    def test_4ec005_copy_checked(self):
        """FL-39f: differential test of m4ec005_copy_checked (original 0x4ec005)"""
        self.run_key('4ec005')

    def test_4fa8d2_check_name(self):
        """FL-39f: differential test of m4fa8d2_check_name (original 0x4fa8d2)"""
        self.run_key('4fa8d2')

    def test_4fa980_construct_record(self):
        """FL-39f: differential test of m4fa980_construct_record (original 0x4fa980)"""
        self.run_key('4fa980')
