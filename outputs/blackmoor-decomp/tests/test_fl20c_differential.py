"""FL-20 (batch c) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl20c.c on the same random
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
    """The fields of Fl20cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl20c.h').read_text()
    body = re.search(r'typedef struct Fl20cWorld \{(.*?)\} Fl20cWorld;', text, re.S).group(1)
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


class Original20(od.Original):
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
        self._stub_hook_inner(uc, address, size, user)
        probe = getattr(stub, 'probe_addr', None)
        if probe and self.calls:
            # the memory at the probed addresses as it is at the call (the stub changes nothing); appended after the deref bytes
            self.calls[-1] = (*self.calls[-1], b''.join(bytes(uc.mem_read(a, n)) for a, n in probe))

    def _stub_hook_inner(self, uc, address, size, user):
        stub = self.stubs[address]
        if getattr(stub, 'ftol', False):
            return self._ftol(uc, address, stub)
        derefs = getattr(stub, 'derefs', None)
        if derefs:   # several pointer arguments to look behind: appended to the logged entry in order
            esp = uc.reg_read(self._r['ESP'])
            data = tuple(bytes(uc.mem_read(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n)) for arg, n in derefs)
            before = len(self.calls)
            self._stub_hook_writes(uc, address, size, user, stub)
            self.calls[before] = self.calls[before] + data
            return
        self._stub_hook_writes(uc, address, size, user, stub)

    def _stub_hook_writes(self, uc, address, size, user, stub):
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
    """A recording stub; writes=[[(arg, offset, size, value), ...] per call]; derefs=[(arg, nbytes), ...] (at most two) log the bytes behind
    those pointer arguments."""
    writes = kw.pop('writes', None)
    derefs = kw.pop('derefs', None)
    probe = kw.pop('probe', None)
    s = od.Stub(callee, **kw)
    s.writes = writes
    s.derefs = derefs
    s.probe = probe   # [(area name or 'g:<world field>', offset, length)]: bytes logged as they are at each call
    return s


class ShimCall20(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 512)]


def sword(v):
    return struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl20cDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl20c_differential_shim.c'
    KERNELS = ['original_methods_fl20c.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall20)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl20c.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl20cWorld'

    def native_calls20(self, areas, deref_len=None, probe_len=None):
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
            for slot, length in enumerate((deref_len or {}).get(c.id, ())):
                entry.append(bytes(c.data)[32 * slot:32 * slot + length])
            if c.id in (probe_len or {}):
                entry.append(bytes(c.probe)[:probe_len[c.id]])
            out.append(entry)
        return out

    def normalize_original(self, calls, stubs, iat, word_args=None):
        by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
        out = []
        for call in calls:
            s = by_name[call[0]]
            entry = [call[0], call[1] if s.this else 0]
            rest = list(call[2 if s.this else 1:])
            probe = rest.pop() if getattr(s, 'probe_addr', None) else None
            ndata = len(getattr(s, 'derefs', None) or ()) or (1 if s.deref is not None else 0)
            data = [rest.pop() for _ in range(ndata)][::-1]
            wa = (word_args or {}).get(call[0], ())
            for position, v in enumerate(rest):
                if position in wa:
                    entry.append(v & (wa[position] if isinstance(wa, dict) else 0xffff))
                else:
                    entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
            entry.extend(data)
            if probe is not None:
                entry.append(probe)
            out.append(entry)
        return out

    def pair(self, fn, va, size, areas, stubs, g, *, ecx=0, stack=(), iat=None, cleanup=0, word_args=None, args=(0, 0, 0, 0),
             self_name=None, tick=None, executed=None, pointers=None, ret_mask=None, scalars=None, limit=200000, arg_array=None):
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
        probed = [s for s in [*stubs.values(), *iat.values()] if getattr(s, 'probe', None)]
        for s in probed:   # s.probe = [(area name or 'g:<world field>', offset, length)]: the original addresses
            s.probe_addr = [((GLOBALS[n[2:]][0] if n.startswith('g:') else next(a.va for a in areas if a.name == n)) + off, ln) for n, off, ln in s.probe]
        orig = Original20(image_patches, regions, stubs, iat).run(va, size, ecx=ecx, stack_args=stack, read=read, limit=limit)
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
            for n, off, ln in (getattr(s, 'probe', None) or ()):
                base = (ctypes.addressof(sw) + getattr(World, n[2:]).offset) if n.startswith('g:') else ctypes.addressof(by_name[n])
                self.lib.shim_script_probe(s.name, base + off, ln)
            for slot, (arg, nbytes) in enumerate(getattr(s, 'derefs', None) or ()):
                (self.lib.shim_script_deref if slot == 0 else self.lib.shim_script_deref2)(s.name, arg, nbytes)
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
        if arg_array is not None:   # a function of more than four stack arguments: `a` is the address of an array of them
            array = (ctypes.c_uint64 * len(arg_array))(*[ctypes.cast(ctypes.byref(by_name[i[1]], i[2]), ctypes.c_void_p).value if isinstance(i, tuple)
                                                         else i & 0xffffffffffffffff for i in arg_array])
            native_args[0] = ctypes.addressof(array)
        self_ptr = ptr(by_name[self_name]) if self_name else None
        result = ctypes.c_int32(0)
        self.lib.shim_fl20c(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
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
        actual = self.native_calls20(arrays, {x.name: [x.deref[1]] if x.deref else [n for _, n in x.derefs] for x in [*stubs.values(), *iat.values()]
                                          if x.deref or getattr(x, 'derefs', None)},
                                     {x.name: sum(ln for _, _, ln in x.probe) for x in probed})
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

    # ---- 0x4b9a88 ----
    def test_4b9a88_draw_slots(self):
        """FL-20c: differential test of m4b9a88_draw_slots (original 0x4b9a88)"""
        rng = random.Random(0x4b9a88)
        executed = set()
        size = 0x4b9dcb - 0x4b9a88
        tslack = 0x4a
        for n in range(SCENARIOS):
            big = n % 25 == 7      # k * 0x37 above 0xffff: the upper half of the pushed dword is a leftover of that product
            count = rng.choice([1300, 1301]) if big else rng.choice([0, 1, 2, 3, 4, 5, 5, -1, -3])
            nslots = max(count, 0) + 1
            slots = bytearray(rng.randbytes(0x37 * nslots))
            for k in range(nslots):
                states = [0, 1, 2, 3, 1, 2, 3, 4, 0xffffffff, 0x80000001]
                if big and k < nslots - 2:
                    states = [0, 0, 0, 0, 0, 1, 2, 3]
                struct.pack_into('<I', slots, k * 0x37 + 0x33, rng.choice(states))
            obj = bytearray(rng.randbytes(0x500))
            struct.pack_into('<h', obj, 0x173, count)
            for off in (0x41d, 0x421, 0x425, 0x429):
                struct.pack_into('<I', obj, off, rng.choice([0, 1, 200, 201, 0xffffffff, 0xfffffffe, 0x7fffffff, 0x80000000, rng.randrange(1 << 32)]))
            table = Area('table', 0x5d1599 - tslack, bytearray(rng.randbytes(tslack + 5 * 0x4a)), compare=False)
            rect = Area('rect', 0x583196, bytearray(rng.randbytes(16)), compare=False)
            g = {**self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'origin_x2_58318e', 'origin_y2_583192', 'value_5cf665',
                                 'value_5d15e3', 'value_5d0357'),
                 'value_61ee82': rng.choice([0, 1, 1, 1, 1, 0x80000000, 0xffffffff]), 'value_61ee8e': rng.choice([0, 0, 1, 0x100, 0xffffffff]),
                 'value_61eea2': rng.choice([0, 1, 1, 0x40000000]), 'value_61ee76': od.region_va(0), 'word_61ee72': rng.choice([-1, 0, 1, 2, 3])}
            if rng.random() < 0.4:   # origins that make the halves cross zero or wrap
                g['origin_x_583186'] = rng.choice([0, 7, 0xfffffff9, 0x7fffffff, 0x80000000])
                g['origin_x2_58318e'] = rng.choice([0, 6, 7, 0xfffffff8, 0xfffffff9, 0x80000000, 0x7ffffffe])
            struct.pack_into('<I', table.data, tslack + 0x4a, g['value_5d15e3'])  # 0x5d15e3 = the dword of record 1
            stubs = {0x4c5d4b: stub(0x4c5d4b, args=5, this=True, cleanup=20, derefs=[(3, 16)]),
                     # at the call: the slot states (the store of 0 for state 3 comes after the call) and the dword 0x61eea2 (cleared after the call)
                     0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=20, derefs=[(2, 16)],
                                    probe=([] if big else [('slots', 0, 0x37 * nslots)]) + [('g:value_61eea2', 0, 4)]),
                     0x4d2c20: stub(0x4d2c20, args=8, derefs=[(0, 2)]),
                     0x4b8e42: od.Stub(0x4b8e42, args=1, this=True, cleanup=4)}
            self.pair(1, 0x4b9a88, size, [Area('slots', 0x61eeb8, slots), Area('obj', od.region_va(0), obj, image=False, compare=False), table, rect],
                      stubs, g, executed=executed, word_args={0x4b8e42: (0,)},
                      pointers={'slots_61eeb8': ('slots', 0), 'table_5d1599': ('table', tslack)})
        self.finish(0x4b9a88, size, executed)

    # ---- 0x4619be ----
    def test_4619be_check_direction(self):
        """FL-20c: differential test of m4619be_check_direction (original 0x4619be)"""
        rng = random.Random(0x4619be)
        executed = set()
        size = 0x461d3b - 0x4619be
        cslack = 4 * 0x140 + 4 * 0x28
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 4])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            row, col = rng.choice([-1, 0, 0, 1, 2, 3, 4]), rng.choice([-1, 0, 0, 1, 2, 3, 4])
            struct.pack_into('<h', this.data, 0x5b, row)
            struct.pack_into('<h', this.data, 0x5d, col)
            records, slack = self.records_area(rng, nrec=5)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            obj = bytearray(rng.randbytes(0x100))
            struct.pack_into('<h', obj, 0x22, rng.choice([row + 1, row + 1, 0, 1, 2, 5, rng.randrange(-4, 8)]))
            struct.pack_into('<h', obj, 0x24, rng.choice([col + 1, col + 1, 0, 1, 2, 5, rng.randrange(-4, 8)]))
            cells = bytearray(rng.randbytes(cslack + 8 * 0x140 + 0x40))
            for r in range(-3, 6):
                for c in range(-3, 8):
                    struct.pack_into('<h', cells, cslack + r * 0x140 + c * 0x28 + 0x24,
                                     rng.choice([0x10, 0x11, 0x12, 0x13, 0x14, 0, 5, -1, 0x15, 0x0f, 0x2, 0x3, 0x4, 0x5]))
                    struct.pack_into('<h', cells, cslack + r * 0x140 + c * 0x28 + 0x26, rng.choice([0, 0, 0, 0, 1, -1, 0x100, -32768]))
            direction = rng.choice([0x10, 0x11, 0x12, 0x13, 0x10, 0x11, 0x12, 0x13, 0x0f, 0x14, 0, -1, 0x30, rng.randrange(-32768, 32768)])
            high = rng.randrange(0x10000) << 16
            self.pair(2, 0x4619be, size, [this, records, Area('obj', od.region_va(1), obj, image=False, compare=False),
                                          Area('cells', 0x594db5 - cslack, cells, compare=False)], {}, {}, ecx=od.region_va(0),
                      stack=[high | (direction & 0xffff)], cleanup=4, args=(direction,), self_name='self', executed=executed, ret_mask=0xffffffff,
                      pointers={'records_5bb5e5': ('records', slack), 'cells_594db5': ('cells', cslack)})
        self.finish(0x4619be, size, executed)

    # ---- 0x481cb9 ----
    def test_481cb9_draw_cells(self):
        """FL-20c: differential test of m481cb9_draw_cells (original 0x481cb9)"""
        rng = random.Random(0x481cb9)
        executed = set()
        size = 0x482054 - 0x481cb9
        sslack = 2
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, rng.choice([od.region_va(0), 0x40000000, 0xfffff000, rng.randrange(1 << 32)]))
            flag_b = rng.choice([0, 0, 1, 0x80000000])
            count = rng.choice([1, 2, 3, 4, 5, 6]) if flag_b == 0 else rng.choice([1, 2, 3, 4, 6])
            if flag_b == 0 and rng.random() < 0.1:
                count = 0
            selected = rng.choice([-1, 0, 1, 2, 3, count - 1, count, 5, 6])
            nslots = 8
            g_b99 = rng.choice([0, 1, 1, 0x80])
            slots = bytearray(rng.randbytes((sslack + nslots) * 0x25))
            order = list(range(count))
            rng.shuffle(order)
            if rng.random() < 0.5:   # any words 0 .. 11: every cell is visited once in the end, several in one scan when words repeat
                order = [rng.randrange(12) for _ in range(count)]
            for m in range(sslack + nslots):
                base = m * 0x25
                slots[base + 0x22] = rng.choice([0, 1, 2, 3])           # (the table at 0x625f08 is 0x74a bytes in this fixture)
                slots[base + 0x24] = rng.choice([0, 0, 1, 2, 0xff])
                # byte +0x23 is also a plain factor (0x53) where the dword table is not read: any value is possible there
                free = slots[base + 0x24] == 0 and m - sslack != selected
                slots[base + 0x23] = rng.choice([0, 1, 2, 3, 18, 0x80, 0xff] if free else [0, 1, 2, 3, 18])
                if m >= sslack and m - sslack < count:
                    struct.pack_into('<h', slots, base, order[m - sslack])
                else:
                    struct.pack_into('<h', slots, base, rng.choice([-1, 0, 1, 2, 7, 0x4000]))
            table = Area('table', 0x625f08, bytearray(rng.randbytes(0x74a)), compare=False)
            r2 = Area('r2', 0x62725a, bytearray(rng.randbytes(16)), compare=False)
            r3 = Area('r3', 0x62726a, bytearray(rng.randbytes(16)), compare=False)
            g = {**self.globals_(rng, 'value_5cf665', 'value_5d15e3', 'value_627290', 'value_62728c', 'value_627294'),
                 'word_625f06': index, 'word_62728a': count, 'word_627238': selected,
                 'value_627230': rng.choice([0, 0, 1, 0x80000000]), 'value_62722c': flag_b, 'value_627234': rng.choice([0, 1, 1, 0xffff0000]),
                 'byte_627299': g_b99, 'byte_62729a': rng.choice([0, 0, 1, 0xff]), 'byte_62729b': rng.choice([0, 1, 1, 0x80])}
            texts = [[(1, 4 * q, 4, rng.randrange(1 << 32)) for q in range(4)] for _ in range(2)]
            # the flags that are cleared after the calls: the dwords 0x627230 and 0x627234 and the byte 0x62729b, as they are at each call
            flags = [('g:value_627230', 0, 4), ('g:value_627234', 0, 4), ('g:byte_62729b', 0, 1)]
            stubs = {0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=20, derefs=[(3, 16)], probe=flags),
                     0x4c5d4b: stub(0x4c5d4b, args=5, this=True, cleanup=20, derefs=[(3, 16)]),
                     0x47e52f: stub(0x47e52f, args=2, this=True, cleanup=8, writes=texts, probe=flags),
                     0x47e99e: od.Stub(0x47e99e, args=1, this=True, cleanup=4, results=[rng.choice([0, 1, 5, 0x80000000]) for _ in range(8)])}
            self.pair(3, 0x481cb9, size, [records, Area('slots', 0x62669c - sslack * 0x25, slots, compare=False), table, r2, r3], stubs, g,
                      executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'slots_62669c': ('slots', sslack * 0x25), 'table_625f08': ('table', 0)})
        self.finish(0x481cb9, size, executed)

    # ---- 0x463b10 ----
    def test_463b10_draw_grid(self):
        """FL-20c: differential test of m463b10_draw_grid (original 0x463b10)"""
        rng = random.Random(0x463b10)
        executed = set()
        size = 0x463ed0 - 0x463b10
        tslack = 0x4a
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(0))
            rows, cols = rng.choice([0, 1, 2, 3, -1]), rng.choice([0, 1, 2, 3, 4, 7, -2])
            rec = bytearray(rng.randbytes(0x300))
            struct.pack_into('<h', rec, 0x22, rows)
            struct.pack_into('<h', rec, 0x24, cols)
            for u in range(10):   # entries of 16 bytes: the dwords at +0x170 and +0x178 are often equal
                if rng.random() < 0.4:
                    struct.pack_into('<I', rec, 0x178 + u * 16, struct.unpack_from('<I', rec, 0x170 + u * 16)[0])
            if rng.random() < 0.4:
                struct.pack_into('<I', rec, 0x238, struct.unpack_from('<I', rec, 0x230)[0])
            cells = bytearray(rng.randbytes(4 * 0x140 + 0x80))
            markers = [0, 1, 2, 3, -1, -5, 7]
            for r in range(4):
                for c in range(8):
                    base = r * 0x140 + c * 0x28
                    struct.pack_into('<I', cells, base, rng.choice([0, 0, 1, 5, 0xffffffff, 0x100, 0x10000, 0x80000000]))
                    struct.pack_into('<h', cells, base + 0x24, rng.choice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 0, -1, 0x7fff, -32768,
                                                                            0x10, 0x11, 0x12, 0x13, 0x14, 1, 10]))
                    struct.pack_into('<h', cells, base + 0x26, rng.choice(markers))
            rec_area = Area('rec', od.region_va(0), rec, image=False, compare=False)
            table = Area('table', 0x5d1599 - tslack, bytearray(rng.randbytes(tslack + 5 * 0x4a)), compare=False)
            g = {**self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'value_5cf665', 'value_5d15e3', 'value_61d7a2', 'value_61d7a6',
                                 'value_61d7aa', 'value_61d7ae'),
                 'word_61d797': index, 'word_61d795': rng.choice([-1, 0, 1, 2, 3]), 'value_61d79d': rng.choice([2, 2, 0, 1, 7]),
                 'value_61d7b4': rng.choice([1, 0, 1, 2, 0x80000001]), 'word_61d7b2': rng.choice(markers)}
            struct.pack_into('<I', table.data, tslack + 0x4a, g['value_5d15e3'])  # 0x5d15e3 = the dword of record 1
            stubs = {0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=20, derefs=[(2, 16)]),
                     0x4c5d4b: stub(0x4c5d4b, args=5, this=True, cleanup=20, derefs=[(3, 16)])}
            self.pair(4, 0x463b10, size, [rec_area, records, Area('cells', 0x594db5, cells, compare=False), table], stubs, g, executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'cells_594db5': ('cells', 0), 'table_5d1599': ('table', tslack)})
        self.finish(0x463b10, size, executed)

    # ---- 0x412db8 ----
    def make_text(self, rng):
        kind = rng.choice(['words', 'words', 'words', 'long', 'empty', 'spaces'])
        if kind == 'empty':
            return b''
        if kind == 'long':
            return bytes(rng.choice(b'abcdefgh') for _ in range(rng.randrange(8, 30)))
        text = b' ' * rng.randrange(0, 3) if kind == 'spaces' else b''
        for _ in range(rng.randrange(1, 7)):
            text += bytes(rng.choice(b'abcdefgh') for _ in range(rng.randrange(1, 8))) + b' ' * rng.randrange(1, 3)
        return text[:rng.randrange(1, 31)]

    def test_412db8_wrap_text(self):
        """FL-20c: differential test of m412db8_wrap_text (original 0x412db8)"""
        rng = random.Random(0x412db8)
        executed = set()
        size = 0x413185 - 0x412db8
        fslack = 0x1d0
        for n in range(SCENARIOS):
            kind = rng.choice(['safe', 'wrap', 'wrap', 'wrap', 'exit'])
            font = rng.choice([-1, 0, 1, 2, 3])
            text = self.make_text(rng)
            text_area = bytearray(text + b'\0' + rng.randbytes(40000 - len(text) - 1 + 16))
            this = bytearray(rng.randbytes(0x3000))
            struct.pack_into('<h', this, 0x292e, rng.choice([0, 5, -7, 1000, rng.randrange(-32768, 32768)]))
            struct.pack_into('<I', this, 0x2938, rng.randrange(1 << 32))
            struct.pack_into('<h', this, 0x293c, rng.choice([0, 1, -1, 0x7fff, rng.randrange(-32768, 32768)]))
            struct.pack_into('<I', this, 0x293e, rng.choice([0, 0, 1, 0xffff0000]))
            struct.pack_into('<I', this, 0x2942, rng.choice([0, 1, 5, 0x80000000]))
            records = bytearray(rng.randbytes(fslack + 5 * 0x1d0))
            if kind == 'safe':
                wvalue = rng.choice([0, 1, 2, 5, 9, 17, 18, 19, -1, -2, -9, -10, -17, 100, -100, 32767, -32768, rng.randrange(-32768, 32768)])
            else:
                wvalue = rng.choice([1, 2, 3, 8, 9, 10, 17, 19, 30])
            for f in range(-1, 4):
                struct.pack_into('<h', records, fslack + f * 0x1d0 + 2, wvalue if f == font else rng.randrange(-100, 100))
            dwords = bytearray(rng.randbytes(8 + 6 * 4))
            args = bytearray(rng.randbytes(0x40))
            flag = rng.choice([0, 0, 1, 1, 0x80000000, 0xffffffff]) if kind != 'wrap' else rng.choice([0, 1, 1])
            struct.pack_into('<I', args, 0, flag)
            limit_e = rng.randrange(-300, 300)
            x0 = limit_e - rng.randrange(1, 40) if kind != 'exit' else limit_e + rng.randrange(0, 4)
            if kind == 'safe' and rng.random() < 0.3:
                x0 = rng.randrange(-32768, 32768)
            struct.pack_into('<h', args, 8, sword(x0))
            y0 = rng.randrange(-30, 50)
            struct.pack_into('<h', args, 0x10, y0)
            if kind == 'safe':
                limit_f = 0x7000
                widths = [rng.choice([0, 1, 3, 6, 6, 0x10000 + 4, 0xabcd0005]) for _ in range(rng.randrange(1, 40))]
            else:
                limit_f = rng.randrange(y0 + 1, y0 + 60)
                widths = [rng.choice([0, 2, 3, 5, 8, 13, 40, 90, 0x10000 + 7]) for _ in range(rng.randrange(1, 60))]
            tv, av = od.region_va(1), od.region_va(2)
            g = {'word_63a4cd': rng.choice([0, 1, -1, 0x4000])}
            stubs = {0x4d3836: stub(0x4d3836, args=3, derefs=[(0, 32)], results=widths),
                     0x4d270b: stub(0x4d270b, args=10, derefs=[(0, 32)]),
                     0x50ca3e: od.Stub(0x50ca3e, args=2),
                     0x4264e8: od.Stub(0x4264e8, args=1, this=True, cleanup=4)}
            font_word = (rng.randrange(0x10000) << 16) | (font & 0xffff)
            stack = [tv, font_word, av, av + 8, (rng.randrange(0x10000) << 16) | (limit_e & 0xffff), (rng.randrange(0x10000) << 16) | (limit_f & 0xffff),
                     av + 0x10, rng.randrange(1 << 32), (rng.randrange(0x10000) << 16) | rng.randrange(0x10000), rng.randrange(1 << 32)]
            native = [('ptr', 'text', 0), sword(font_word), ('ptr', 'args', 0), ('ptr', 'args', 8), sword(limit_e), sword(limit_f), ('ptr', 'args', 0x10),
                      stack[7], sword(stack[8]), stack[9]]
            self.pair(5, 0x412db8, size, [Area('self', 0x00c00000, this, image=False, compare=False), Area('text', tv, text_area, image=False),
                                          Area('args', av, args, image=False), Area('fonts', 0x5adb3a - fslack, records, compare=False),
                                          Area('dw', 0x5d032f - 8, dwords, compare=False)], stubs, g, ecx=0x00c00000, stack=stack, cleanup=0x28,
                      self_name='self', executed=executed, word_args={0x4d270b: (3,)}, limit=400000, arg_array=native,
                      pointers={'records_5adb3a': ('fonts', fslack), 'dwords_5d032f': ('dw', 8)})
        self.finish(0x412db8, size, executed)

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
