"""FL-19 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl19b.c on the same random
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
    """The fields of Fl19bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl19b.h').read_text()
    body = re.search(r'typedef struct Fl19bWorld \{(.*?)\} Fl19bWorld;', text, re.S).group(1)
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
class Fl19bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl19b_differential_shim.c'
    KERNELS = ['original_methods_fl19b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall19)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_fl19b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl19bWorld'

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
        self.lib.shim_fl19b(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
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

    # ---- 0x44d597 ----
    def test_44d597_press(self):
        """FL-19b: differential test of m44d597_press (original 0x44d597)"""
        rng = random.Random(0x44d597)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 4])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            records, slack = self.records_area(rng, nrec=5)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x300)), image=False)
            struct.pack_into('<h', obj.data, 0x263, rng.choice([0, 1, -1, 7, -32768, 32767, rng.randrange(-32768, 32768)]))
            g = self.globals_(rng, 'value_5b44f0', 'value_5b44f4', 'value_5d0377', 'value_5d162d', 'value_5d1631', 'value_5d1639',
                              'value_5c39e5')
            arg = rng.randrange(1 << 32)
            self.pair(1, 0x44d597, 141, [this, obj, records], {}, g, ecx=od.region_va(0), stack=[arg], cleanup=4,
                      args=(arg,), self_name='self', executed=executed, pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x44d597, 141, executed)

    # ---- 0x41f986 ----
    def test_41f986_init_strings(self):
        """FL-19b: differential test of m41f986_init_strings (original 0x41f986)"""
        rng = random.Random(0x41f986)
        executed = set()
        for n in range(30):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x1000)), image=False)
            buffers = Area('buffers', od.region_va(1), bytearray(rng.randbytes(0x3c00 + 0x200)), image=False)
            base = od.region_va(1)
            spacing = rng.choice([0x200, 0x1a0, 0x190, 0x1e0])
            results = [base + rng.randrange(4) * 8 + k * spacing for k in range(0x1e)]
            stubs = {0x51e745: od.Stub(0x51e745, this=True), 0x51ea75: od.Stub(0x51ea75, args=1, this=True, cleanup=4, results=results),
                     0x51eac4: od.Stub(0x51eac4, args=1, this=True, cleanup=4)}
            self.pair(2, 0x41f986, 139 - 0, [this, buffers], stubs, {}, ecx=od.region_va(0), self_name='self', executed=executed)
        self.finish(0x41f986, 139 - 0, executed)

    # ---- 0x4d00f4 ----
    def test_4d00f4_draw_list(self):
        """FL-19b: differential test of m4d00f4_draw_list (original 0x4d00f4)"""
        rng = random.Random(0x4d00f4)
        executed = set()
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, slack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x300)), image=False)
            struct.pack_into('<h', obj.data, 0x21, rng.choice([-3, -1, 0, 1, 2, 3, 4, 4, 5]))
            flags = Area('flags', 0x5b5128, bytearray(rng.choice([0, 0, 1, 5, 0xff, 0x80]) for _ in range(8)))
            g = {**self.globals_(rng, 'value_5cf665', 'value_5d1a83', 'value_5d15e3', 'origin_x_583186', 'origin_y_58318a'),
                 'word_5b5159': index}
            if rng.random() < 0.3:
                g['origin_x_583186'] = rng.choice([0xffffffff, 0x7fffffff, 0x80000000, 0])
            stubs = {0x4c5377: od.Stub(0x4c5377, args=5, this=True, cleanup=20, deref=(3, 16))}
            self.pair(3, 0x4d00f4, 0x4d0275 - 0x4d00f4, [obj, records, flags], stubs, g, executed=executed,
                      pointers={'records_5bb5e5': ('records', slack), 'bytes_5b5128': ('flags', 0)})
        self.finish(0x4d00f4, 0x4d0275 - 0x4d00f4, executed)

    # ---- 0x447ac7 ----
    def test_447ac7_split_pixels(self):
        """FL-19b: differential test of m447ac7_split_pixels (original 0x447ac7)"""
        rng = random.Random(0x447ac7)
        executed = set()
        size = 0x447c1c - 0x447ac7
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x80)), image=False)
            struct.pack_into('<i', this.data, 0x41, rng.choice([-2, 0, 1, 2, 3, 4]))
            struct.pack_into('<i', this.data, 0x45, rng.choice([-4, 0, 1, 2, 3, 4, 7, 8]))
            pix = Area('pix', od.region_va(1), bytearray(rng.randbytes(0x1000)), image=False, compare=False)
            dst = Area('dst', od.region_va(2), bytearray(rng.randbytes(0x400)), image=False)
            start = od.region_va(1) + 0x800 + rng.randrange(0, 0x40)
            stride = rng.choice([0, 2, 6, 8, 0x20, 0x21, -8, -0x30 & 0xffffffff])
            stubs = {0x4c3efb: stub(0x4c3efb, args=4, this=True, cleanup=16, writes=[[(2, 0x24, 4, start), (2, 0x10, 4, stride)]]),
                     0x4c4202: od.Stub(0x4c4202, args=3, this=True, cleanup=12)}
            g = {n_: rng.choice([0, 1, 5, 6, 8, 0x1f, 0x20, 0x25, 0xff, rng.randrange(256)])
                 for n_ in ('shift_5d2f1b', 'mask_5d2f1f', 'shift_5d2f1a', 'mask_5d2f1e', 'shift_5d2f19', 'mask_5d2f1d')}
            arg = rng.randrange(1 << 32)
            self.pair(4, 0x447ac7, size, [this, pix, dst], stubs, g, ecx=od.region_va(0), stack=[arg, od.region_va(2)], cleanup=8,
                      args=(arg, ('ptr', 'dst', 0)), self_name='self', executed=executed)
        self.finish(0x447ac7, size, executed)

    # ---- 0x45b872 ----
    def test_45b872_click(self):
        """FL-19b: differential test of m45b872_click (original 0x45b872)"""
        rng = random.Random(0x45b872)
        executed = set()
        size = 0x45ba0b - 0x45b872
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x200)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            struct.pack_into('<I', this.data, 0x166, rng.choice([0, 1, 1, 1, 1, 1, 1, 1, 1, 0x80000000]))
            struct.pack_into('<I', this.data, 0x16a, rng.choice([0] * 9 + [1]))
            struct.pack_into('<I', this.data, 0x24, rng.choice([0] * 9 + [7]))
            s = rng.choice([-2, -1, 0, 1, 2, 5])
            struct.pack_into('<h', this.data, 0x172, s)
            records, slack = self.records_area(rng, nrec=4, slack=0)
            struct.pack_into('<I', records.data, index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, index * 0x8d + 0x4d, rng.choice([1] * 8 + [0, 2]))
            obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x4000)), image=False, compare=False)
            entry = (s * 0x31) & 0xffffffff
            entry = entry - (1 << 32) if entry >= 1 << 31 else entry
            text = bytearray(rng.randbytes(9)) if rng.random() < 0.5 else bytearray(b'\x00' * 9)
            pattern = Area('pattern', 0x54ab5c, text, compare=False)
            if abs(entry) < 0x1000:
                if rng.random() < 0.35:
                    obj.data[entry + 0x4fe: entry + 0x4fe + 9] = text
                else:
                    obj.data[entry + 0x4fe: entry + 0x4fe + 9] = text
                    obj.data[entry + 0x4fe + rng.choice([8, 8, rng.randrange(9)])] ^= rng.randrange(1, 256)
            sel = rng.choice([0x27bb, 0x27bb, 0x27ba, 0x27ba, 0x27ba, 0x27b9, 0])
            g = {'value_5c39e5': sel, 'value_5bb1ca': rng.choice([0, 1, 1, 0x100])}
            now = rng.choice([1000, 0x7fffffff, 0xfffffff0, rng.randrange(1 << 32)])
            stubs = {0x45be7f: od.Stub(0x45be7f, args=3, this=True, cleanup=12, results=[rng.choice([0, 1, 0x100])]),
                     0x4f6334: od.Stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 1])]),
                     0x4fb2e3: od.Stub(0x4fb2e3, args=1, this=True, cleanup=4)}
            iat = {TICK_SLOT: od.Stub('tick', result=now, silent=True)}
            self.pair(5, 0x45b872, size, [this, records, obj, pattern], stubs, g, ecx=od.region_va(0), iat=iat, tick=now,
                      self_name='self', executed=executed, word_args={0x4fb2e3: {0}},
                      pointers={'records_5bb5e5': ('records', 0), 'bytes_54ab5c': ('pattern', 0)})
        self.finish(0x45b872, size, executed)

    # ---- 0x434630 ----
    def test_434630_find_name(self):
        """FL-19b: differential test of m434630_find_name (original 0x434630)"""
        rng = random.Random(0x434630)
        executed = set()
        size = 0x434773 - 0x434630
        for n in range(SCENARIOS):
            count = rng.choice([-1, 0, 1, 2, 3, 5, 6])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x6000)), image=False)
            struct.pack_into('<i', this.data, 0x5f68, count)
            name = bytes(rng.choice(b'abcXY') for _ in range(rng.choice([0, 1, 2, 3, 3, 4, 5]))) + b'\x00'
            strings = bytearray(b'\x00' * 0x400)
            results, reads = [], []
            for i in range(6):
                struct.pack_into('<I', this.data, 0x20e4 + 4 * i, rng.randrange(1 << 32))
                struct.pack_into('<I', this.data, 0x4fc4 + 4 * i, rng.choice([0, 1, 1, 2, 0]))
                kind = rng.choice(['same', 'same', 'diff', 'longer', 'shorter', 'other'])
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
            self.pair(6, 0x434630, size, [this, name_area, texts], stubs, {}, ecx=od.region_va(0), stack=[od.region_va(1)], cleanup=4,
                      args=(('ptr', 'name', 0),), self_name='self', executed=executed, ret_mask=0xffffffff)
        self.finish(0x434630, size, executed)

    # ---- 0x4c7481 ----
    def test_4c7481_pack_555(self):
        """FL-19b: differential test of m4c7481_pack_555 (original 0x4c7481)"""
        rng = random.Random(0x4c7481)
        executed = set()
        size = 0x4c7623 - 0x4c7481
        for n in range(SCENARIOS):
            data = bytearray(rng.randbytes(0x3a00))
            for off in (0x38c2, 0x38c1, 0x38c0):
                data[off] = rng.choice([0, 1, 5, 6, 10, 11, 15, 16, 17, 31, 32, 37, 255, rng.randrange(256)])
            for off in (0x38c6, 0x38c5, 0x38c4):
                data[off] = rng.choice([0x1f, 0x3f, 0xff, 0x0f, 0, rng.randrange(256)])
            for off in (0x38ca, 0x38c9, 0x38c8):
                data[off] = rng.choice([5, 5, 5, 6, 0, 0xff, rng.randrange(256)])
            this = Area('self', od.region_va(0), data, image=False)
            buf_len = rng.choice([0, 1, 2, 3, 8, 9, 14, 17, 32])
            pixels = Area('buf', od.region_va(1), bytearray(rng.randbytes(64)), image=False)
            self.pair(7, 0x4c7481, size, [this, pixels], {}, {}, ecx=od.region_va(0), stack=[od.region_va(1), buf_len], cleanup=8,
                      args=(('ptr', 'buf', 0), buf_len), self_name='self', executed=executed)
        self.finish(0x4c7481, size, executed)

    # ---- 0x4d3836 ----
    def test_4d3836_text_width(self):
        """FL-19b: differential test of m4d3836_text_width (original 0x4d3836)"""
        rng = random.Random(0x4d3836)
        executed = set()
        size = 0x4d3992 - 0x4d3836
        pool = b'AbZz09 !~\x7f\x80\xe9\xff'
        for n in range(SCENARIOS):
            text = bytes(rng.choice(pool) for _ in range(rng.randrange(0, 7))) + b'\x00'
            text_area = Area('text', od.region_va(0), bytearray(text + rng.randbytes(8)), image=False, compare=False)
            font = bytearray(rng.randbytes(0x80))
            struct.pack_into('<h', font, 0x4f, rng.choice([0, 1, 3, -1, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            struct.pack_into('<h', font, 0x51, rng.choice([0, 1, -2, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            struct.pack_into('<h', font, 0x53, 0x41 + rng.randrange(-0x40, 0x40))
            struct.pack_into('<h', font, 0x55, 0x61 + rng.randrange(-0x40, 0x40))
            struct.pack_into('<h', font, 0x57, 0x30 + rng.randrange(-0x40, 0x40))
            font_area = Area('font', od.region_va(1), font, image=False, compare=False)
            table = bytearray(rng.randbytes(0x1000))
            table_area = Area('table', od.region_va(2), table, image=False, compare=False)
            calls = lambda: [rng.choice([0, 1, 1, 0x100]) for _ in range(40)]
            local_writes = [[(2, 0, 4, (rng.randrange(1 << 16) << 16) | (rng.randrange(-0x200, 0x200) & 0xffff))] for _ in range(8)]
            stubs = {0x4d214b: stub(0x4d214b, args=3, results=[rng.choice([0, 0, 1]) for _ in range(8)], writes=local_writes),
                     0x50d651: od.Stub(0x50d651, args=1, results=calls()), 0x50d67f: od.Stub(0x50d67f, args=1, results=calls()),
                     0x50d6a7: od.Stub(0x50d6a7, args=1, results=calls()), 0x50d6cf: od.Stub(0x50d6cf, args=1, results=calls())}
            self.pair(8, 0x4d3836, size, [text_area, font_area, table_area], stubs, {},
                      stack=[od.region_va(0), od.region_va(1), od.region_va(2) + 0x800], cleanup=0,
                      args=(('ptr', 'text', 0), ('ptr', 'font', 0), ('ptr', 'table', 0x800)), executed=executed,
                      word_args={0x4d214b: {0: 0xff}}, ret_mask=0xffff)
        self.finish(0x4d3836, size, executed)

    # ---- 0x4460d6 ----
    def test_4460d6_load_layout(self):
        """FL-19b: differential test of m4460d6_load_layout (original 0x4460d6)"""
        rng = random.Random(0x4460d6)
        executed = set()
        size = 0x4462d3 - 0x4460d6
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x300)), image=False)
            src_data = bytearray(rng.randbytes(0xb8))
            for k in range(10):
                if rng.random() < 0.5:   # small values, so that the differences are small and the sign shows
                    struct.pack_into('<4i', src_data, k * 16, *[rng.randrange(-50, 50) for _ in range(4)])
            index = rng.choice([-2, -1, 0, 1, 2, 3, 4])
            struct.pack_into('<i', src_data, 0x16c - 0xbc, index)
            src = Area('src', od.region_va(1), src_data, image=False, compare=False)
            slack = 3 * 0x4a
            table = Area('table', 0x5d1591 - slack, bytearray(rng.randbytes(slack + 8 * 0x4a)))
            text = Area('text', 0x548218, bytearray(bytes(rng.choice(b'abcdefgh ') for _ in range(rng.randrange(0, 30))) + b'\x00'),
                        compare=False)
            self.pair(9, 0x4460d6, size, [this, src, table, text], {}, {}, ecx=od.region_va(0), stack=[od.region_va(1)], cleanup=4,
                      args=(('ptr', 'src', 0),), self_name='self', executed=executed,
                      pointers={'table_5d1591': ('table', slack), 'string_548218': ('text', 0)})
        self.finish(0x4460d6, size, executed)

    # ---- 0x48ded7 ----
    def test_48ded7_draw_hover(self):
        """FL-19b: differential test of m48ded7_draw_hover (original 0x48ded7)"""
        rng = random.Random(0x48ded7)
        executed = set()
        size = 0x48e166 - 0x48ded7
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            records, slack = self.records_area(rng, nrec=4, slack=0)
            struct.pack_into('<I', records.data, index * 0x8d, od.region_va(1))
            obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x300)), image=False, compare=False)
            tslack = 2 * 0x4a
            table = Area('table', 0x5d1591 - tslack, bytearray(rng.randbytes(tslack + 6 * 0x4a)), compare=False)
            g = {'word_61d363': index, 'word_61d361': rng.choice([-2, -1, 0, 1, 4]),
                 'byte_61d369': rng.choice([0, 1, 1, 1, 0x80]), 'value_61d374': rng.choice([0, 1, 1, 1, 0x80000000]),
                 'byte_61d36b': rng.choice([0, 1, 1, 0xff]), 'word_61d36c': rng.choice([-1, 0, 1, 2, 3, 4]),
                 'byte_61d36a': rng.choice([0, 1, 1, 0x7f]), 'word_61d36e': rng.choice([-1, 0, 1, 2, 3, 4]),
                 'value_61d370': rng.randrange(1 << 32),
                 **self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'value_5cf665', 'value_5d15e3')}
            # the dword 0x5d15e3 lies inside the record table (record 1, offset 0x52): keep the two views of it equal
            struct.pack_into('<I', table.data, tslack + 0x5d15e3 - 0x5d1591, g['value_5d15e3'])
            stubs = {0x4c5377: od.Stub(0x4c5377, args=5, this=True, cleanup=20, deref=(3, 16)),
                     0x48d89e: od.Stub(0x48d89e, this=True)}
            self.pair(10, 0x48ded7, size, [records, obj, table], stubs, g, executed=executed,
                      pointers={'records_5bb5e5': ('records', 0), 'table_5d1591': ('table', tslack)})
        self.finish(0x48ded7, size, executed)

    # ---- 0x45b5bb ----
    def test_45b5bb_pointer_move(self):
        """FL-19b: differential test of m45b5bb_pointer_move (original 0x45b5bb)"""
        rng = random.Random(0x45b5bb)
        executed = set()
        size = 0x45b7a8 - 0x45b5bb
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x200)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            struct.pack_into('<I', this.data, 0x166, rng.choice([0, 1, 1, 1, 1, 1, 0x80000000]))
            struct.pack_into('<I', this.data, 0x28, rng.choice([0] * 9 + [5]))
            struct.pack_into('<h', this.data, 0xba, rng.choice([1, 1, 3, 3, 0, 2, -1, 5]))
            records, slack = self.records_area(rng, nrec=3, slack=0)
            struct.pack_into('<I', records.data, index * 0x8d, od.region_va(1))
            rec = bytearray(rng.randbytes(0xc00))
            rec[0x27] = rng.choice([0, 1, 0xff])
            x, y = rng.randrange(-30, 30), rng.randrange(-30, 30)
            if rng.random() < 0.15:
                x, y = rng.choice([-32768, 32767, -1, 0]), rng.choice([-32768, 32767, -1, 0])
            # (low, high) offsets of the four boxes: x_lo, x_hi, y_lo, y_hi fields and the extra margins of the box B / the offsets
            boxes = {'A': (0x31d, 0x325, 0x321, 0x329, 0, 0, -5, 5), 'B': (0x32d, 0x335, 0x331, 0x339, 10, -10, 5, 5),
                     'C': (0x33d, 0x345, 0x341, 0x349, 0, 0, 0, 0), 'D': (0xb7e, 0xb86, 0xb82, 0xb8a, 0, 0, 0, 0)}
            for name, (xl, xh, yl, yh, mxl, mxh, myl, myh) in boxes.items():
                inside = rng.random() < 0.45
                if inside:   # the point lies inside, on or one unit off the edges
                    vals = [x - mxl - rng.choice([0, 0, 1, 2, 7]), x - mxh + rng.choice([0, 0, 1, 2, 7]),
                            y - myl - rng.choice([0, 0, 1, 2, 7]), y - myh + rng.choice([0, 0, 1, 2, 7])]
                else:        # each edge lands near the point on either side
                    deltas = [0, 1, -1, 1, -1, 50, -50, rng.randrange(-60, 60)]
                    vals = [x - mxl + rng.choice(deltas), x - mxh + rng.choice(deltas),
                            y - myl + rng.choice(deltas), y - myh + rng.choice(deltas)]
                for off, v in zip((xl, xh, yl, yh), vals):
                    struct.pack_into('<i', rec, off, max(-1 << 31, min((1 << 31) - 1, v)))
                if rng.random() < 0.05:   # exercise the 32-bit wrap of the +/-5 and +/-10 offsets
                    struct.pack_into('<i', rec, rng.choice((xl, xh, yl, yh)), rng.choice([-1 << 31, (1 << 31) - 1, (1 << 31) - 6, -(1 << 31) + 4]))
            obj = Area('obj', od.region_va(1), rec, image=False, compare=False)
            g = {'word_6247ee': rng.choice([-3, 0, 1, 2, 3, 0x7fff])}
            stubs = {0x45b7a8: od.Stub(0x45b7a8, args=2, this=True, cleanup=8)}
            hx, hy = rng.randrange(1 << 16) << 16, rng.randrange(1 << 16) << 16
            self.pair(11, 0x45b5bb, size, [this, records, obj], stubs, g, ecx=od.region_va(0),
                      stack=[hx | (x & 0xffff), hy | (y & 0xffff)], cleanup=8, args=(x & 0xffff, y & 0xffff), self_name='self',
                      executed=executed, ret_mask=0xffffffff, pointers={'records_5bb5e5': ('records', 0)})
        self.finish(0x45b5bb, size, executed)

    # ---- 0x4462d3 ----
    def test_4462d3_load_layout(self):
        """FL-19b: differential test of m4462d3_load_layout (original 0x4462d3)"""
        rng = random.Random(0x4462d3)
        executed = set()
        size = 0x446532 - 0x4462d3
        for n in range(SCENARIOS):
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x300)), image=False)
            src_data = bytearray(rng.randbytes(0xc8))
            for k in range(10):
                if rng.random() < 0.5:
                    struct.pack_into('<4i', src_data, k * 16, *[rng.randrange(-50, 50) for _ in range(4)])
            if rng.random() < 0.5:
                struct.pack_into('<4i', src_data, 0x214 - 0x174, *[rng.randrange(-50, 50) for _ in range(4)])
            struct.pack_into('<i', src_data, 0x234 - 0x174, rng.choice([-2, -1, 0, 1, 2, 3, 4]))
            src = Area('src', od.region_va(1), src_data, image=False, compare=False)
            slack = 3 * 0x4a
            table = Area('table', 0x5d1591 - slack, bytearray(rng.randbytes(slack + 8 * 0x4a)))
            text = Area('text', 0x548228, bytearray(bytes(rng.choice(b'abcdefgh ') for _ in range(rng.randrange(0, 30))) + b'\x00'),
                        compare=False)
            self.pair(12, 0x4462d3, size, [this, src, table, text], {}, {}, ecx=od.region_va(0), stack=[od.region_va(1)], cleanup=4,
                      args=(('ptr', 'src', 0),), self_name='self', executed=executed,
                      pointers={'table_5d1591': ('table', slack), 'string_548228': ('text', 0)})
        self.finish(0x4462d3, size, executed)

    # ---- 0x412787 ----
    def test_412787_register_name(self):
        """FL-19b: differential test of m412787_register_name (original 0x412787)"""
        rng = random.Random(0x412787)
        executed = set()
        size = 0x4129da - 0x412787
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2])
            g = rng.choice([0, 1, 2])
            records, slack = self.records_area(rng, nrec=3, slack=0)
            struct.pack_into('<I', records.data, index * 0x8d, od.region_va(0))
            name = bytes(rng.choice(b'abcd') for _ in range(rng.randrange(1, 8))) + b'\x00'
            rec = bytearray(rng.randbytes(0x100))
            struct.pack_into('<h', rec, 0, g + 3)
            rec[2:2 + len(name)] = name
            struct.pack_into('<h', rec, 0x23, rng.choice([0, 5, 6, 7, 8, 9, 10, 11, -1, 300, rng.randrange(-32768, 32768)]))
            obj = Area('rec', od.region_va(0), rec, image=False, compare=False)
            counts = bytearray(rng.randbytes(6))   # the table is 3 words: 0x59fbe1 follows it
            count = rng.choice([0, 1, 2, 3, 6, 6, 0x18f, 0x190, 0x190])
            struct.pack_into('<h', counts, g * 2, count)
            strs = bytearray(rng.randbytes(0x3390 * 3))
            for k in range(min(count, 0x190)):
                for gg in (g,):
                    text = bytes(rng.choice(b'abcd') for _ in range(rng.randrange(0, 8))) + b'\x00'
                    if text == name and rng.random() < 0.8:
                        text = text[:-1] + b'e\x00' if len(text) > 1 else b'e\x00'
                    strs[gg * 0x3390 + k * 0x21: gg * 0x3390 + k * 0x21 + len(text)] = text
            if 0 < count < 0x190 and rng.random() < 0.4:   # one entry equals the name
                k = rng.randrange(count)
                strs[g * 0x3390 + k * 0x21: g * 0x3390 + k * 0x21 + len(name)] = name
            if count >= 0x18f:                                # no matching string: every entry differs in its first byte
                for k in range(0x190):
                    strs[g * 0x3390 + k * 0x21] = ord('Z')
            s_area = Area('strs', 0x5957cb, strs)
            c_area = Area('counts', 0x59fbdb, counts)
            w27b = Area('w27b', 0x59f27b, bytearray(rng.randbytes(0x320 * 3)))
            wbe1 = Area('wbe1', 0x59fbe1, bytearray(rng.randbytes(0x320 * 3)))
            go_on = rng.choice([1, 1, 1, 0x100])
            seq = [go_on] * rng.choice([0, 1, 2, 400]) + [rng.choice([0, 1, 1])]
            if count >= 0x18f:
                seq = [1]
            stubs = {0x423259: od.Stub(0x423259, args=1, this=True, cleanup=4, results=seq),
                     0x42ba3a: od.Stub(0x42ba3a, args=1), 0x52139c: od.Stub(0x52139c, args=3, cleanup=12),
                     0x4e0559: od.Stub(0x4e0559, args=3, this=True, cleanup=12)}
            hi = rng.randrange(1 << 16) << 16
            self.pair(13, 0x412787, size, [obj, records, s_area, c_area, w27b, wbe1], stubs, {}, stack=[hi | index], cleanup=4,
                      args=(index,), executed=executed, word_args={0x42ba3a: {0}},
                      pointers={'records_5bb5e5': ('records', 0), 'strings_5957cb': ('strs', 0), 'words_59fbdb': ('counts', 0),
                                'words_59f27b': ('w27b', 0), 'words_59fbe1': ('wbe1', 0)})
        self.finish(0x412787, size, executed)

    # ---- 0x4fca60 ----
    def test_4fca60_set_channel_scalars(self):
        """FL-19b: differential test of m4fca60_set_channel_scalars (original 0x4fca60; the x87 code against C doubles)"""
        rng = random.Random(0x4fca60)
        executed = set()
        size = 0x4fcb5c - 0x4fca60

        def f32(v):
            return struct.unpack('<f', struct.pack('<f', v))[0]
        for n in range(SCENARIOS):
            channel = rng.choice([0, 1, 2, 3])
            this = bytearray(rng.randbytes(0xc000))
            word_at = channel * 0x5bb + 0x10c
            index = rng.choice([-3, -1, 0, 1, 2, 5, 8])
            struct.pack_into('<h', this, word_at, index)
            for i in range(-4, 10):
                struct.pack_into('<f', this, 0xb764 + 4 * i, f32(rng.choice([0.0, -0.0, 1.0, -1.5, 100.25, 1e-3, 3.0e8, rng.uniform(-1000, 1000)])))
            first = f32(rng.choice([0.0, 1.0, -2.5, 1e10, 123456.789, rng.uniform(-5000, 5000)]))
            second = f32(rng.choice([0.0, -0.0, 7.0, 1e-7, -77777.7, rng.uniform(-5000, 5000)]))
            scale = f32(rng.choice([0.5, 1.0, 100.0, 0.01, -3.0, rng.uniform(-10, 10)]))
            bias = rng.choice([0.5, 0.0, -0.5, 1e-9, 12345.678, rng.uniform(-100, 100)])
            area = Area('self', od.region_va(0), this, image=False)
            consts = [Area('scale', 0x52e4e0, bytearray(struct.pack('<f', scale)), compare=False),
                      Area('bias', 0x52e4d8, bytearray(struct.pack('<d', bias)), compare=False)]
            ftol = stub(0x50ce04, results=[rng.randrange(1 << 32), rng.randrange(1 << 32)])
            ftol.ftol = True
            stubs = {0x50ce04: ftol, 0x4f684a: od.Stub(0x4f684a, args=1, this=True, cleanup=4)}
            first_bits = struct.unpack('<I', struct.pack('<f', first))[0]
            second_bits = struct.unpack('<I', struct.pack('<f', second))[0]
            hi = rng.randrange(1 << 16) << 16
            self.pair(14, 0x4fca60, size, [area, *consts], stubs, {}, ecx=od.region_va(0),
                      stack=[hi | (channel & 0xffff), first_bits, second_bits], cleanup=12,
                      args=(channel, first_bits, second_bits), self_name='self', executed=executed,
                      scalars={'scale_52e4e0': scale, 'bias_52e4d8': bias})
        self.finish(0x4fca60, size, executed)

    # DIFF-END


if __name__ == '__main__':
    unittest.main()
