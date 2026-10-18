"""FL-20 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl20a.c on the same random
fixtures.

See test_fl_differential.py, test_fl18_differential.py and original_differential.py for the method. Every case compares all the memory
the function can write (objects, record tables, globals), the return value where there is one, how many bytes the function popped, and
the ordered calls out: callee, ecx, stack arguments (pointers into a fixture are compared as the original addresses they stand for,
pointers to a local of the function as 'L'; 'word' arguments, which the original pushes from a 16-bit register, by their low 16 bits)
and the bytes behind a pointer argument where the call is described that way. The callees are recording stubs (which may store
scripted values through a pointer argument); the function under test runs as the original bytes. A case also requires that its
scenarios reached every instruction of the original function.
"""
import ctypes
import math
from dataclasses import dataclass
from pathlib import Path
import random
import re
import struct
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
from test_fl_differential import DiffBase, buf, ptr

PROJECT = Path(__file__).resolve().parents[1]
SCENARIOS = 300
LOCAL = 'L'
TICK_SLOT = 0x52a23c

CTYPES = {'float': ctypes.c_float, 'double': ctypes.c_double, 'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32,
          'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl20aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl20a.h').read_text()
    body = re.search(r'typedef struct Fl20aWorld \{(.*?)\} Fl20aWorld;', text, re.S).group(1)
    body = re.sub(r'/\*.*?\*/', '', body, flags=re.S)
    fields = []
    for decl in body.split(';'):
        decl = decl.strip().replace('const ', '')
        if not decl:
            continue
        kind, _, names = decl.partition(' ')
        for name in names.split(','):
            name = name.strip()
            if name.startswith('*'):
                fields.append((name[1:], ctypes.c_void_p, True))
            else:
                fields.append((name, CTYPES[kind], False))
    return fields


WORLD_FIELDS = parse_world()


class World(ctypes.Structure):
    _fields_ = [(n, t) for n, t, _ in WORLD_FIELDS]


# the globals of the original that a case may set (every scalar field of the world): name -> (address, size)
GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t, p in WORLD_FIELDS if not p}
SIGNED = {n for n, t, p in WORLD_FIELDS if not p and t in (ctypes.c_int16, ctypes.c_int32)}
FMT = {1: '<B', 2: '<H', 4: '<I'}


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


class Original19(od.Original):
    """od.Original whose stubs can also store scripted values through a pointer argument: stub.writes[call] is a list of
    (stack argument index, offset, size, value)."""

    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self._nth = {}
        self._set_x87_precision()

    def _set_x87_precision(self):
        """fldcw 0x27f, run as code: the 53-bit precision control of the Microsoft runtime."""
        base = od.STUB_BASE
        self.uc.mem_write(base + 0xf00, struct.pack('<H', 0x27f))
        self.uc.mem_write(base + 0x900, b'\xd9\x2d' + struct.pack('<I', base + 0xf00) + b'\x90')
        self.uc.emu_start(base + 0x900, base + 0x906, count=1)

    def _ftol(self, uc, address, stub):
        """0x50ce04 takes st0: log its value (as the bits of a double) and return the scripted result."""
        esp = uc.reg_read(self._r['ESP'])
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        top = (uc.reg_read(od.x.UC_X86_REG_FPSW) >> 11) & 7   # st0 is the physical register `top`
        mantissa, exponent = uc.reg_read(od.x.UC_X86_REG_FP0 + top)
        value = math.ldexp(mantissa, (exponent & 0x7fff) - 16383 - 63)
        value = -value if exponent & 0x8000 else value
        self.calls.append((stub.name, struct.unpack('<Q', struct.pack('<d', value))[0]))
        n = self._nth.get(address, 0)
        self._nth[address] = n + 1
        uc.reg_write(self._r['EAX'], stub.results[min(n, len(stub.results) - 1)])
        uc.reg_write(self._r['ESP'], esp + 4)
        uc.reg_write(self._r['EIP'], ret)

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        if getattr(stub, 'ftol', False):
            return self._ftol(uc, address, stub)
        writes = getattr(stub, 'writes', None)
        if writes:
            n = self._nth.get(address, 0)
            self._nth[address] = n + 1
            esp = uc.reg_read(self._r['ESP'])
            for arg, off, sz, value in (writes[n] if n < len(writes) else ()):
                pointer = struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0]
                uc.mem_write(pointer + off, struct.pack('<I' if sz == 4 else '<H', value & (0xffffffff if sz == 4 else 0xffff)))
        super()._stub_hook(uc, address, size, user)


def stub(callee, **kw):
    """A recording stub; writes=[[(arg, offset, size, value), ...] per call]."""
    writes = kw.pop('writes', None)
    s = od.Stub(callee, **kw)
    s.writes = writes
    return s


class ShimCall19(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 8),
                ('data', ctypes.c_uint8 * 32)]


def sword(v):
    return struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl20aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl20a_differential_shim.c'
    KERNELS = ['original_methods_fl20a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall19)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_fl20a.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl20aWorld'

    def native_calls19(self, areas, deref_len=None):
        """The shim's call log as comparable tuples: [callee, this, *args, *data]."""
        spans = [(ctypes.addressof(arr), len(arr), a.va) for a, arr in areas]

        def va_of(value):
            for base, length, va in spans:
                if base <= value < base + length:
                    return va + (value - base)
            return LOCAL if value >= 1 << 32 else value
        calls = self.lib.shim_calls()
        out = []
        for i in range(self.lib.shim_call_count()):
            c = calls[i]
            # (0x50ce04 takes the bits of a double, not an address)
            entry = [c.id, va_of(c.this_ptr), *[c.arg[k] if c.id == 0x50ce04 else va_of(c.arg[k]) for k in range(c.nargs)]]
            if c.id in (deref_len or {}):
                entry.append(bytes(c.data)[:deref_len[c.id]])
            out.append(entry)
        return out

    def normalize_original(self, calls, stubs, iat, word_args=None):
        by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
        out = []
        for call in calls:
            s = by_name[call[0]]
            entry = [call[0], call[1] if s.this else 0]
            rest = list(call[2 if s.this else 1:])
            data = rest.pop() if s.deref is not None else None
            wa = (word_args or {}).get(call[0], ())
            for position, v in enumerate(rest):
                if position in wa:
                    entry.append(v & (wa[position] if isinstance(wa, dict) else 0xffff))
                else:
                    entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
            if data is not None:
                entry.append(data)
            out.append(entry)
        return out

    def pair(self, fn, va, size, areas, stubs, g, *, ecx=0, stack=(), iat=None, cleanup=0, word_args=None, args=(0, 0, 0, 0),
             self_name=None, tick=None, executed=None, pointers=None, ret_mask=None, scalars=None):
        """Run the original and the native function on one fixture and compare. `g` maps scalar world fields to initial values
        (written to the image; read back and compared); `pointers` maps world pointer fields to (area name, offset); `args` are the
        native a, b, c, d (an int, or ('ptr', area name, offset) for a host pointer into an area)."""
        iat = dict(iat or {})
        image_patches = [(a.va, a.data) for a in areas if a.image]
        for field, value in g.items():
            address, size_ = GLOBALS[field]
            image_patches.append((address, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1))))
        regions = {a.name: (a.va, a.data) for a in areas if not a.image}
        read = {a.name: (a.va, len(a.data)) for a in areas if a.compare}
        for field in g:
            read['g:' + field] = GLOBALS[field]
        orig = Original19(image_patches, regions, stubs, iat).run(va, size, ecx=ecx, stack_args=stack, read=read)
        self.assertEqual(orig.cleanup, cleanup)
        # native
        self.lib.shim_reset()
        arrays, by_name = [], {}
        for a in areas:
            arr = buf(a.data)
            by_name[a.name] = arr
            arrays.append((a, arr))
            self.lib.shim_add_region(a.va, ptr(arr), len(arr))
        sw = World()
        for field, value in g.items():
            setattr(sw, field, sword(value) if field in SIGNED and GLOBALS[field][1] == 2 else
                    (struct.unpack('<i', struct.pack('<I', value & 0xffffffff))[0] if field in SIGNED else value & ((1 << (8 * GLOBALS[field][1])) - 1)))
        for field, value in (scalars or {}).items():
            setattr(sw, field, value)
        for field, (name, offset) in (pointers or {}).items():
            setattr(sw, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        for s in [*stubs.values(), *iat.values()]:
            if isinstance(s.name, str):
                continue
            for r in (s.results or ([s.result] if s.result else [])):
                self.lib.shim_script_return(s.name, r)
            if s.deref is not None:
                self.lib.shim_script_deref(s.name, s.deref[0], s.deref[1])
            for callno, lst in enumerate(getattr(s, 'writes', None) or ()):
                for arg, off, sz, value in lst:
                    self.lib.shim_script_write(s.name, callno, arg, off, sz, value & 0xffffffff)
        if tick is not None:
            self.lib.shim_set_tick(tick)
        native_args = []
        for item in args:
            if isinstance(item, tuple):
                native_args.append(ctypes.cast(ctypes.byref(by_name[item[1]], item[2]), ctypes.c_void_p).value)
            else:
                native_args.append(item & 0xffffffffffffffff)
        native_args += [0] * (4 - len(native_args))
        self_ptr = ptr(by_name[self_name]) if self_name else None
        result = ctypes.c_int32(0)
        self.lib.shim_fl20a(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
        for a in areas:
            if a.compare:
                self.assertEqual(bytes(by_name[a.name]), orig.memory[a.name], a.name)
        for field in g:
            address, size_ = GLOBALS[field]
            native_value = getattr(sw, field) & ((1 << (8 * size_)) - 1)
            self.assertEqual(struct.pack(FMT[size_], native_value), orig.memory['g:' + field], field)
        if ret_mask is not None:
            self.assertEqual(result.value & ret_mask, orig.eax & ret_mask, 'return value')
        expected = self.normalize_original(orig.calls, stubs, iat, word_args)
        actual = self.native_calls19(arrays, {x.name: x.deref[1] for x in [*stubs.values(), *iat.values()] if x.deref})
        for calls in (expected, actual):
            for entry in calls:
                wa = (word_args or {}).get(entry[0], ())
                for index in wa:
                    entry[2 + index] = entry[2 + index] & (wa[index] if isinstance(wa, dict) else 0xffff)
        self.assertEqual(actual, expected)
        if executed is not None:
            executed |= orig.executed
        if tick is not None and TICK_SLOT in iat:
            pass
        return orig, sw

    def finish(self, va, size, executed):
        missing = sorted(od.instruction_addresses(va, size) - executed)
        self.assertEqual(missing, [], 'scenarios never reached original instructions %s' % [hex(a) for a in missing])

    def records_area(self, rng, nrec=6, slack=1):
        """The record table at 0x5bb5e5 (stride 0x8d) with `slack` records below it."""
        return Area('records', 0x5bb5e5 - slack * 0x8d, bytearray(rng.randbytes((slack + nrec) * 0x8d))), slack * 0x8d

    def globals_(self, rng, *names):
        return {n: rng.randrange(1 << (8 * GLOBALS[n][1])) for n in names}

    # ---- 0x4d3c88 ----
    def test_4d3c88_clear_flag(self):
        """FL-20a: differential test of m4d3c88_clear_flag (original 0x4d3c88)"""
        rng = random.Random(0x4d3c88)
        executed = set()
        for n in range(SCENARIOS):
            before = Area('before', 0x61c690, bytearray(rng.randbytes(0x1d)))      # up to the byte
            after = Area('after', 0x61c6ae, bytearray(rng.randbytes(0x20)))
            g = {'byte_61c6ad': rng.choice([0, 1, 0x80, 0xff, rng.randrange(256)])}
            self.pair(1, 0x4d3c88, 18, [before, after], {}, g, ecx=rng.randrange(1 << 32), executed=executed)
        self.finish(0x4d3c88, 18, executed)

    # ---- 0x4d3c5f ----
    def test_4d3c5f_set_ready(self):
        """FL-20a: differential test of m4d3c5f_set_ready (original 0x4d3c5f)"""
        rng = random.Random(0x4d3c5f)
        executed = set()
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x400)), image=False)
            stubs = {0x4d3c31: od.Stub(0x4d3c31, this=True, results=[rng.choice([0, 0, 1, 0x100, 0xffffffff, 0x80000000])]),
                     0x4d3d20: od.Stub(0x4d3d20, this=True)}
            self.pair(2, 0x4d3c5f, 41, [this], stubs, {}, ecx=od.region_va(0), self_name='self', executed=executed)
        self.finish(0x4d3c5f, 41, executed)

    # ---- 0x41c509 ----
    def test_41c509_init_fields(self):
        """FL-20a: differential test of m41c509_init_fields (original 0x41c509)"""
        rng = random.Random(0x41c509)
        executed = set()
        for n in range(SCENARIOS):
            rec = Area('rec', od.region_va(1), bytearray(rng.randbytes(0x80)), image=False)
            self.pair(3, 0x41c509, 59, [rec], {}, {}, ecx=rng.randrange(1 << 32), stack=[od.region_va(1) + 0],
                      cleanup=4, args=(('ptr', 'rec', 0),), executed=executed)
        self.finish(0x41c509, 59, executed)

    # ---- the four sibling methods 0x43ec4a, 0x43ec85, 0x43ecc0, 0x43ed71 ----
    def sibling(self, fn, va, callee, seed):
        rng = random.Random(seed)
        executed = set()
        for n in range(SCENARIOS):
            this = rng.randrange(1 << 32)
            a, b, c = (rng.choice([0, 1, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]) for _ in range(3))
            stubs = {callee: stub(callee, args=2, this=True, cleanup=8, deref=(0, 12)),
                     0x51ab4b: od.Stub(0x51ab4b, this=True)}
            self.pair(fn, va, 59, [], stubs, {}, ecx=this, stack=[a, b, c], cleanup=12, args=(a, b, c, this), executed=executed)
        self.finish(va, 59, executed)

    def test_43ec4a_forward_4db000(self):
        """FL-20a: differential test of m43ec4a_forward_4db000 (original 0x43ec4a)"""
        self.sibling(4, 0x43ec4a, 0x4db000, 0x43ec4a)

    def test_43ec85_forward_4dafc3(self):
        """FL-20a: differential test of m43ec85_forward_4dafc3 (original 0x43ec85)"""
        self.sibling(5, 0x43ec85, 0x4dafc3, 0x43ec85)

    def test_43ecc0_forward_4db04f(self):
        """FL-20a: differential test of m43ecc0_forward_4db04f (original 0x43ecc0)"""
        self.sibling(6, 0x43ecc0, 0x4db04f, 0x43ecc0)

    def test_43ed71_forward_4daf9f(self):
        """FL-20a: differential test of m43ed71_forward_4daf9f (original 0x43ed71)"""
        self.sibling(7, 0x43ed71, 0x4daf9f, 0x43ed71)

    # ---- 0x475885 ----
    def test_475885_release(self):
        """FL-20a: differential test of m475885_release (original 0x475885)"""
        rng = random.Random(0x475885)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x100))
            struct.pack_into('<I', data, 0x24, rng.choice([0, 0, 1, 0x100, 0x80000000, rng.randrange(1 << 32)]))
            struct.pack_into('<I', data, 0x28, rng.choice([0, 0, 1, 0x10000, 0x80000000, rng.randrange(1 << 32)]))
            struct.pack_into('<H', data, 0x20, rng.choice([0xffff, 0xffff, 0, 1, 0xfffe, 0x7fff, rng.randrange(1 << 16)]))
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4c2dfb: od.Stub(0x4c2dfb, args=1, this=True, cleanup=4), 0x4d3992: od.Stub(0x4d3992, args=1),
                     0x4757da: od.Stub(0x4757da, this=True)}
            self.pair(8, 0x475885, 99, [this], stubs, {}, ecx=od.region_va(0), self_name='self', executed=executed,
                      word_args={0x4d3992: {0}})
        self.finish(0x475885, 99, executed)

    # ---- 0x4caf03 ----
    def test_4caf03_reset(self):
        """FL-20a: differential test of m4caf03_reset (original 0x4caf03)"""
        rng = random.Random(0x4caf03)
        executed = set()
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x200)), image=False)
            self.pair(9, 0x4caf03, 135, [this], {}, {}, ecx=od.region_va(0), self_name='self', executed=executed)
        self.finish(0x4caf03, 135, executed)

    # ---- 0x41c770 ----
    def test_41c770_init_fields(self):
        """FL-20a: differential test of m41c770_init_fields (original 0x41c770)"""
        rng = random.Random(0x41c770)
        executed = set()
        for n in range(SCENARIOS):
            rec = Area('rec', od.region_va(1), bytearray(rng.randbytes(0x200)), image=False)
            self.pair(10, 0x41c770, 132, [rec], {}, {}, ecx=rng.randrange(1 << 32), stack=[od.region_va(1)], cleanup=4,
                      args=(('ptr', 'rec', 0),), executed=executed)
        self.finish(0x41c770, 132, executed)

    # ---- 0x4757da ----
    def test_4757da_clear_grid(self):
        """FL-20a: differential test of m4757da_clear_grid (original 0x4757da)"""
        rng = random.Random(0x4757da)
        executed = set()
        for n in range(40):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x900)), image=False)
            self.pair(11, 0x4757da, 171, [this], {}, {}, ecx=od.region_va(0), self_name='self', executed=executed)
        self.finish(0x4757da, 171, executed)

    # ---- 0x48bb86 ----
    def test_48bb86_release(self):
        """FL-20a: differential test of m48bb86_release (original 0x48bb86)"""
        rng = random.Random(0x48bb86)
        executed = set()
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x100))
            first = rng.choice([0, 0, 1, 0x80000000, rng.randrange(1 << 32)])
            second = rng.choice([first, first, 0, 0x1000, rng.randrange(1 << 32)])
            struct.pack_into('<I', data, 0x1e, first)
            struct.pack_into('<I', data, 0x22, second)
            data[0x45] = rng.choice([0, 0, 1, 1, 2, 0xff, rng.randrange(256)])
            struct.pack_into('<H', data, 0x2e, rng.choice([0xffff, 0xffff, 0, 3, 0xfffe, rng.randrange(1 << 16)]))
            struct.pack_into('<H', data, 0x30, rng.choice([0xffff, 0xffff, 0, 9, 0x8000, rng.randrange(1 << 16)]))
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4c2dfb: od.Stub(0x4c2dfb, args=1, this=True, cleanup=4), 0x4d3992: od.Stub(0x4d3992, args=1),
                     0x48bb17: od.Stub(0x48bb17, this=True)}
            self.pair(12, 0x48bb86, 178, [this], stubs, {}, ecx=od.region_va(0), self_name='self', executed=executed,
                      word_args={0x4d3992: {0}})
        self.finish(0x48bb86, 178, executed)

    # ---- 0x483fb5 ----
    def test_483fb5_release_all(self):
        """FL-20a: differential test of m483fb5_release_all (original 0x483fb5)"""
        rng = random.Random(0x483fb5)
        executed = set()
        for n in range(80):
            data = bytearray(rng.randbytes(0xb00))
            struct.pack_into('<I', data, 0x1e, rng.choice([0, 0x1000, rng.randrange(1 << 32)]))
            struct.pack_into('<I', data, 0x22, rng.choice([0, 0x2000, rng.randrange(1 << 32)]))
            struct.pack_into('<H', data, 0x1c, rng.choice([0xffff, 0xffff, 0, 5, 0xfffe, rng.randrange(1 << 16)]))
            density = rng.choice([0.0, 0.2, 0.5, 1.0])
            for i in range(20):
                for j in range(4):
                    if rng.random() >= density:
                        struct.pack_into('<I', data, 0x4c + i * 0x85 + j * 0x18, 0)
            this = Area('self', od.region_va(0), data, image=False)
            stubs = {0x4c2dfb: od.Stub(0x4c2dfb, args=1, this=True, cleanup=4), 0x4d3992: od.Stub(0x4d3992, args=1),
                     0x483f6a: od.Stub(0x483f6a, this=True)}
            self.pair(13, 0x483fb5, 292, [this], stubs, {}, ecx=od.region_va(0), self_name='self', executed=executed,
                      word_args={0x4d3992: {0}})
        self.finish(0x483fb5, 292, executed)

    # ---- 0x4343a2 ----
    def test_4343a2_find_name(self):
        """FL-20a: differential test of m4343a2_find_name (original 0x4343a2)"""
        rng = random.Random(0x4343a2)
        executed = set()
        size = 285
        for n in range(SCENARIOS):
            count = rng.choice([-1, 0, 1, 2, 3, 5, 6])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x6000)), image=False)
            struct.pack_into('<i', this.data, 0x5f68, count)
            name = bytes(rng.choice(b'abcXY') for _ in range(rng.choice([0, 1, 2, 3, 3, 4, 5]))) + b'\x00'
            strings = bytearray(b'\x00' * 0x400)
            results = []
            for i in range(6):
                struct.pack_into('<I', this.data, 0x20e4 + 4 * i, rng.randrange(1 << 32))
                struct.pack_into('<I', this.data, 0x4fc4 + 4 * i, rng.choice([0, 1, 1, 2, 0x100]))   # the flag dword of 0x434630 is not looked at here
                kind = rng.choice(['same', 'diff', 'diff', 'longer', 'shorter', 'other'])
                text = bytearray(name[:-1])
                if kind == 'diff' and text:
                    text[rng.randrange(len(text))] ^= 1 + rng.randrange(3)
                elif kind == 'longer':
                    text += b'z'
                elif kind == 'shorter' and text:
                    text = text[:-1]
                elif kind == 'other':
                    text = bytearray(rng.choice(b'abcXYZ') for _ in range(rng.randrange(6)))
                strings[i * 0x40: i * 0x40 + len(text) + 1] = bytes(text) + b'\x00'
                results.append(od.region_va(2) + i * 0x40)
            name_area = Area('name', od.region_va(1), bytearray(name + bytes(rng.randbytes(8))), image=False, compare=False)
            texts = Area('texts', od.region_va(2), strings, image=False, compare=False)
            stubs = {0x434814: od.Stub(0x434814, args=1, this=True, cleanup=4, results=results),
                     0x4347b8: od.Stub(0x4347b8, args=1, this=True, cleanup=4, results=[rng.randrange(1 << 32)])}
            self.pair(14, 0x4343a2, size, [this, name_area, texts], stubs, {}, ecx=od.region_va(0), stack=[od.region_va(1)], cleanup=4,
                      args=(('ptr', 'name', 0),), self_name='self', executed=executed, ret_mask=0xffffffff)
        self.finish(0x4343a2, size, executed)

    # ---- 0x44727a ----
    def test_44727a_start_record(self):
        """FL-20a: differential test of m44727a_start_record (original 0x44727a)"""
        rng = random.Random(0x44727a)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            this.data[0x1c] = rng.choice([0, 0, 0, 1, 0x80, rng.randrange(256)])
            records, slack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, slack + index * 0x8d + 0x4d, rng.choice([0, 0, 0, 0, 2, 2, 1, 3, 0x100, 0x80000000]))
            src = bytearray(rng.randbytes(0x40))
            x0, x1, y0, y1 = (rng.randrange(1 << 32) for _ in range(4))
            struct.pack_into('<I', src, 5, x0)
            struct.pack_into('<I', src, 9, y0)
            struct.pack_into('<I', src, 0xd, x0 if rng.random() < 0.3 else x1)
            struct.pack_into('<I', src, 0x11, y0 if rng.random() < 0.3 else y1)
            obj = Area('obj', od.region_va(1), src, image=False, compare=False)
            g = self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'corner_x_58318e', 'corner_y_583192')
            stubs = {0x4473a9: od.Stub(0x4473a9, this=True), 0x42ba3a: od.Stub(0x42ba3a, args=1)}
            hi = rng.randrange(1 << 16) << 16
            self.pair(15, 0x44727a, 303, [this, obj, records], stubs, g, ecx=od.region_va(0), stack=[hi | (index & 0xffff)], cleanup=4,
                      args=(index,), self_name='self', executed=executed, word_args={0x42ba3a: {0}},
                      pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x44727a, 303, executed)

    # ---- 0x42b87a ----
    def test_42b87a_apply_record(self):
        """FL-20a: differential test of m42b87a_apply_record (original 0x42b87a; the switch is the jump table at 0x42ba22)"""
        rng = random.Random(0x42b87a)
        executed = set()
        size = 424
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, slack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            obj_data = bytearray(rng.randbytes(0x20))
            obj_data[0] = rng.choice([0, 1, 2, 3, 4, 5, 6, 7, 0xff, rng.randrange(256)] + [1, 2, 3, 4, 5, 6])
            obj = Area('obj', od.region_va(1), obj_data, image=False, compare=False)
            g = {'word_585d51': rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(1 << 16)]),
                 'word_585d4f': rng.choice([0, 0x7fff, 0xfffe, rng.randrange(1 << 16)]),
                 'word_5b0280': rng.choice([0, 1, 0xffff, 0x8000, 0x7fff, rng.randrange(1 << 16)]),
                 'value_585d4b': rng.randrange(1 << 32), 'value_585d55': rng.randrange(1 << 32)}
            now = rng.choice([0, 1000, 0x7fffffff, 0xfffffff0, 0xffffffff, rng.randrange(1 << 32)])
            stubs = {0x4d3c5f: od.Stub(0x4d3c5f, this=True), 0x4d3c88: od.Stub(0x4d3c88, this=True), 0x42ba3a: od.Stub(0x42ba3a, args=1)}
            iat = {TICK_SLOT: od.Stub('tick', result=now, silent=True)}
            hi = rng.randrange(1 << 16) << 16
            self.pair(16, 0x42b87a, size, [obj, records], stubs, g, stack=[hi | (index & 0xffff)], cleanup=0, args=(index,),
                      iat=iat, tick=now, executed=executed, word_args={0x42ba3a: {0}},
                      pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x42b87a, size, executed)

    # DIFF-END


if __name__ == '__main__':
    unittest.main()
