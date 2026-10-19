"""FL-21 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl21b.c on the same random
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
    """The fields of Fl21bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl21b.h').read_text()
    body = re.search(r'typedef struct Fl21bWorld \{(.*?)\} Fl21bWorld;', text, re.S).group(1)
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
        if getattr(stub, 'ftol', False):
            return self._ftol(uc, address, stub)
        derefs = getattr(stub, 'derefs', None)
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = ()
        if derefs:   # several pointer arguments to look behind: appended to the logged entry in order
            esp = uc.reg_read(self._r['ESP'])
            data = tuple(bytes(uc.mem_read(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n)) for arg, n in derefs)
        if probe:    # the memory at the probed addresses as it is at the call (read before the stub stores anything), appended last
            data += (b''.join(bytes(uc.mem_read(a, n)) for a, n in probe),)
        self._stub_hook_writes(uc, address, size, user, stub)
        if data:
            self.calls[before] = self.calls[before] + data

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
    those pointer arguments; probe=[(area name or 'g:<world field>', offset, nbytes), ...] (at most eight, 4096 bytes in all) log the bytes at those places as
    they are at the call (call-time state), after the deref bytes."""
    writes = kw.pop('writes', None)
    derefs = kw.pop('derefs', None)
    probe = kw.pop('probe', None)
    s = od.Stub(callee, **kw)
    s.probe = probe
    s.writes = writes
    s.derefs = derefs
    return s


class ShimCall20(ctypes.Structure):
    _fields_ = [('id', ctypes.c_uint32), ('nargs', ctypes.c_int32), ('this_ptr', ctypes.c_uint64), ('arg', ctypes.c_uint64 * 12),
                ('data', ctypes.c_uint8 * 64), ('probe', ctypes.c_uint8 * 4096)]


def sword(v):
    return struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]


@unittest.skipUnless(od.available(), 'needs Unicorn and the pinned private work/original/GAME.EXE')
class Fl21bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl21b_differential_shim.c'
    KERNELS = ['original_methods_fl21b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall20)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl21b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl21bWorld'

    def native_calls20(self, areas, deref_len=None, probe_len=None):
        """The shim's call log as comparable tuples: [callee, this, *args, *data, probe]; GetTickCount is ['tick', 0]."""
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
            entry = ['tick' if c.id == TICK_SLOT else c.id, va_of(c.this_ptr),
                     *[c.arg[k] if c.id == 0x50ce04 else va_of(c.arg[k]) for k in range(c.nargs)]]
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
        probed = [x for x in [*stubs.values(), *iat.values()] if getattr(x, 'probe', None)]
        for x in probed:   # x.probe = [(area name | 'g:<field>', offset, length)]: the original addresses
            x.probe_addr = [((GLOBALS[n[2:]][0] if n.startswith('g:') else next(a.va for a in areas if a.name == n)) + off, ln)
                            for n, off, ln in x.probe]
        orig = Original20(image_patches, regions, stubs, iat).run(va, size, ecx=ecx, stack_args=stack, read=read)
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
            for slot, (arg, nbytes) in enumerate(getattr(s, 'derefs', None) or ()):
                (self.lib.shim_script_deref if slot == 0 else self.lib.shim_script_deref2)(s.name, arg, nbytes)
            for n, off, ln in (getattr(s, 'probe', None) or ()):
                host = (ctypes.addressof(sw) + getattr(World, n[2:]).offset + off) if n.startswith('g:') else \
                    ctypes.cast(ctypes.byref(by_name[n], off), ctypes.c_void_p).value
                self.lib.shim_script_probe(s.name, host, ln)
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
        self.lib.shim_fl21b(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
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

    # CASES-BEGIN

    # ---- 0x4468fe ----
    def test_4468fe_draw_clock(self):
        """FL-21b: differential test of m4468fe_draw_clock (original 0x4468fe)"""
        rng = random.Random(0x4468fe)
        executed = set()
        size = 1478
        tslack = 0x4a
        digits = b'0123456789/:0123456789\x80\xc9\xff'
        for n in range(SCENARIOS):
            bs = 0x400   # slack below 0x638600 for the signed index of a character that is not a digit
            block = bytearray(rng.randbytes(bs + 0x300))

            def put(address, value):
                struct.pack_into('<I', block, bs + address - 0x638600, value & 0xffffffff)
            put(0x63860b, rng.choice([1, 1, 2, 0x80000000]))
            put(0x638613, rng.choice([1, 1, 5, 0x100]))
            gate = rng.random()
            if gate < 0.08:
                put(0x63860b, 0)
            elif gate < 0.16:
                put(0x638613, 0)
            for d in range(-1, 10):   # widths 0x638667[d], heights 0x63868f[d]
                put(0x638667 + 4 * d, rng.choice([0, 1, 7, 20 + d, 0xffffffff, rng.randrange(1 << 32)]) if rng.random() < 0.3 else rng.randrange(1, 60))
                put(0x63868f + 4 * d, rng.choice([0, 1, 9, 0x80000000, rng.randrange(1 << 32)]) if rng.random() < 0.3 else rng.randrange(1, 60))
            put(0x6386b7, rng.choice([5, 7, 0, 0xffffffff, rng.randrange(1 << 32)]) if rng.random() < 0.4 else rng.randrange(1, 30))
            put(0x6386bb, rng.choice([4, 0, 0x7fffffff, 0xfffffffd, rng.randrange(1 << 32)]) if rng.random() < 0.4 else rng.randrange(1, 70))
            put(0x638827, rng.choice([100, 0xfffffff0, 0x7ffffff0, rng.randrange(1 << 32)]))
            put(0x63882b, rng.choice([200, 0x7fffffff, rng.randrange(1 << 32)]))
            put(0x63882f, rng.choice([4, 0, 0xffffffff, rng.randrange(1 << 32)]))
            put(0x638837, rng.choice([-1, 0, 1, 1, 2, 3]))

            def text(k):
                return bytes(rng.choice(digits) for _ in range(k))

            def draw(length=None):
                return text(rng.randrange(0, 10) if length is None else length)
            kind = rng.choice(['diff', 'diff', 'same', 'same', 'first', 'second', 'empty_new', 'empty_old', 'prefix', 'suffix', 'long'])
            s1, s2, o1, o2 = draw(), draw(), draw(), draw()
            if kind == 'same':
                o1, o2 = s1, s2
            elif kind == 'first':
                o2 = s2
            elif kind == 'second':
                o1 = s1
            elif kind == 'empty_new':
                s1 = b''
            elif kind == 'empty_old':
                o2 = b''
                o1 = s1 = s1 or b'7'
                s2 = s2 or b'42'
            elif kind == 'prefix':
                o1 = s1 + text(rng.randrange(1, 3)) if len(s1) < 8 else s1
                o2 = s2
            elif kind == 'suffix':
                o1 = s1
                o2 = s2 if len(s2) < 1 else s2[:-1]
            if kind == 'long':   # the first string runs through the second one and the copy overlaps the old strings
                s1 = text(rng.randrange(0x1e, 0x29))
            at = lambda address: bs + address - 0x638600
            if kind != 'long':
                block[at(0x63884b):at(0x63884b) + len(s1) + 1] = s1 + b'\0'
                block[at(0x638855):at(0x638855) + len(s2) + 1] = s2 + b'\0'
                block[at(0x638869):at(0x638869) + len(o1) + 1] = o1 + b'\0'
                block[at(0x638873):at(0x638873) + len(o2) + 1] = o2 + b'\0'
            else:   # the bytes behind the first string are zero, so the strings that start inside or behind it end
                block[at(0x63884b):at(0x638900)] = s1 + b'\0' * (0xb5 - len(s1))
            block_area = Area('block', 0x638600 - bs, block)
            table = Area('table', 0x5d1599 - tslack, bytearray(rng.randbytes(tslack + 5 * 0x4a)), compare=False)
            g = self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'value_5cf665', 'value_5d15e3')
            struct.pack_into('<I', table.data, tslack + 0x4a, g['value_5d15e3'])  # 0x5d15e3 = the dword of record 1
            # at each call the strings are still the old ones (the copies come last)
            probe = [('block', at(0x63884b), 0x32)]
            stubs = {0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=20, derefs=[(2, 16), (3, 16)], probe=probe),
                     0x4c5d4b: stub(0x4c5d4b, args=5, this=True, cleanup=20, derefs=[(3, 16)], probe=probe)}
            self.pair(1, 0x4468fe, size, [block_area, table], stubs, g, executed=executed,
                      pointers={'block_638600': ('block', bs), 'table_5d1599': ('table', tslack)})
        self.finish(0x4468fe, size, executed)


    # ---- 0x47f421 ----
    def test_47f421_pointer_hit(self):
        """FL-21b: differential test of m47f421_pointer_hit (original 0x47f421)"""
        rng = random.Random(0x47f421)
        executed = set()
        size = 1520
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x1500)), image=False)
            d = this.data

            def put32(offset, value):
                struct.pack_into('<I', d, offset, value & 0xffffffff)

            def put16(offset, value):
                struct.pack_into('<H', d, offset, value & 0xffff)
            struct.pack_into('<h', d, 0x1e, index)
            put32(0x13c5, 0 if rng.random() < 0.06 else rng.choice([1, 1, 0x80000000]))
            mode = rng.choice(['drag_loop'] * 4 + ['drag', 'pick', 'pick', 'pick', 'pick', 'nodrag', 'locked'])
            put32(0x1344, 0 if mode == 'nodrag' else rng.choice([1, 1, 0x100, 0xffffffff]))
            d[0x13b1] = rng.choice([1, 2, 0xff]) if mode == 'locked' else 0
            count = rng.choice([0, 1, 2, 3, 4, 5, 6, 6, -1, -4])
            put16(0x13a2, count)
            current = rng.choice([-1, 0, 1, 2, 3, max(count - 1, 0), count])
            put16(0x1350, current)
            x = rng.choice([rng.randrange(-10, 110), rng.randrange(-32768, 32768), rng.randrange(0, 60)]) if rng.random() < 0.3 else rng.randrange(0, 100)
            y = rng.choice([rng.randrange(-10, 110), rng.randrange(-32768, 32768), rng.randrange(0, 60)]) if rng.random() < 0.3 else rng.randrange(0, 100)
            around = rng.random() < 0.7   # boxes that contain the point
            for slot in range(-1, 8):   # the items: x0 at +2, y0 at +6, x1 at +0xa, y1 at +0xe, bytes +0x23 and +0x24
                base = 0x7b4 + 0x25 * slot
                if around and rng.random() < 0.7:
                    x0, y0 = x - rng.randrange(0, 25), y - rng.randrange(0, 25)
                    x1, y1 = x + rng.choice([0, 0, rng.randrange(0, 25)]), y + rng.choice([0, 0, rng.randrange(0, 25)])
                else:
                    x0, y0 = rng.randrange(-5, 70), rng.randrange(-5, 70)
                    x1 = x0 + rng.choice([rng.randrange(-4, 90), rng.randrange(0, 30), 1, 2, 3, 5])
                    y1 = y0 + rng.choice([rng.randrange(-4, 90), rng.randrange(0, 30), 1, 2, 3, 5])
                put32(base + 2, x0)
                put32(base + 6, y0)
                put32(base + 0xa, x1)
                put32(base + 0xe, y1)
                d[base + 0x23] = rng.choice([0, 1, 2, 3])
                d[base + 0x24] = rng.choice([0, 0, 0, 1, 0xff])
            for slot in range(0, 8):
                d[0x7a0 + slot] = rng.choice([0, 1, 1, 1, 0xff])
            for offset in (0x1352, 0x1356, 0x135a, 0x135e):   # the dragged rectangle
                put32(offset, rng.randrange(-5, 100))
            if rng.random() < 0.6:   # make the dragged rectangle a proper one
                put32(0x135a, struct.unpack_from('<i', d, 0x1352)[0] + rng.randrange(0, 50))
                put32(0x135e, struct.unpack_from('<i', d, 0x1356)[0] + rng.randrange(0, 50))
            records, slack = self.records_area(rng, nrec=5)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            rec = bytearray(rng.randbytes(0xb00))

            def rput32(offset, value):
                struct.pack_into('<I', rec, offset, value & 0xffffffff)
            wide = mode == 'drag_loop' or rng.random() < 0.4
            rput32(0x4e, rng.randrange(-1000, -100) if wide else rng.randrange(-30, 130))   # left bound
            rput32(0x56, rng.randrange(150, 1000) if wide else rng.randrange(-30, 130))     # right bound
            rput32(0x52, rng.randrange(-1000, -100) if wide else rng.randrange(-30, 130))   # top bound
            rput32(0x5a, rng.randrange(150, 1000) if wide else rng.randrange(-30, 130))     # bottom bound
            if mode == 'drag_loop':
                rec[0x5e], rec[0x5f] = 0, rng.choice([1, 1, 7])
            else:
                rec[0x5e] = rng.choice([0, 0, 1, 1, 2, 0xff])
                rec[0x5f] = rng.choice([0, 1, 1, 7])
            rec[0x48] = rng.choice([0, 1, 1, 1])
            rec[0x49] = rng.choice([0, 1, 1, 1])
            struct.pack_into('<h', rec, 0x4a, rng.randrange(-5, 70))
            struct.pack_into('<h', rec, 0x4c, rng.randrange(-5, 70))
            for b in range(4):
                rec[0xe9 + 0x53 * b] = rng.choice([0, 0, 1, 0xff])
            for offset in (0xa14, 0xa24):    # x0, y0, x1, y1 of the two boxes: (0xa14, 0xa18, 0xa1c, 0xa20) and (0xa24, 0xa28, 0xa2c, 0xa30)
                if rng.random() < 0.5:
                    x0, y0, x1, y1 = x - rng.randrange(0, 10), y - rng.randrange(0, 10), x + rng.randrange(0, 10), y + rng.randrange(0, 10)
                else:
                    x0, y0 = rng.randrange(-5, 80), rng.randrange(-5, 80)
                    x1, y1 = x0 + rng.randrange(-3, 70), y0 + rng.randrange(-3, 70)
                rput32(offset, x0)
                rput32(offset + 4, y0)
                rput32(offset + 8, x1)
                rput32(offset + 12, y1)
            rect = Area('rect', od.region_va(2), bytearray(rng.randbytes(16)), image=False, compare=False)
            probe = [('self', 0x13cf, 0x75)]   # the dragged-over box dwords, 0x13df, the two lists and their counts, as they are at each call
            stubs = {0x47f275: stub(0x47f275, args=0, this=True, probe=probe),
                     0x47ec06: stub(0x47ec06, args=2, this=True, cleanup=8, results=[rng.choice([0, 1, 5, 0x80000000, 0x10000]) for _ in range(2)], probe=probe),
                     0x47fd65: stub(0x47fd65, args=1, this=True, cleanup=4, probe=probe)}
            stack = [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff), od.region_va(2)]
            self.pair(2, 0x47f421, size, [this, records, rect, Area('rec', od.region_va(1), rec, image=False, compare=False)], stubs, {}, ecx=od.region_va(0),
                      stack=stack, cleanup=0xc, args=(x, y, ('ptr', 'rect', 0)), self_name='self', executed=executed, ret_mask=0xffffffff,
                      word_args={0x47ec06: (0, 1)}, pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x47f421, size, executed)

    # ---- 0x48569e ----
    def test_48569e_handle_key(self):
        """FL-21b: differential test of m48569e_handle_key (original 0x48569e)"""
        rng = random.Random(0x48569e)
        executed = set()
        size = 1539
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0xc30)), image=False)
            d = this.data
            struct.pack_into('<h', d, 0x26, index)
            struct.pack_into('<I', d, 0xba7, 0 if rng.random() < 0.05 else rng.choice([1, 1, 1, 0x100, 0x80000000]))
            d[0xbb0] = rng.choice([1, 0xff]) if rng.random() < 0.05 else 0
            struct.pack_into('<I', d, 0xbac, rng.choice([1, 0x80000000]) if rng.random() < 0.05 else 0)
            struct.pack_into('<I', d, 0xa92, rng.choice([0, 0, 0, 1, 0x100, 0xffffffff]))
            struct.pack_into('<h', d, 0xa9e, rng.choice([0, 1, 2, 3, 4, 5, 19]))
            struct.pack_into('<h', d, 0xc25, rng.choice([0, 0, 1, 2, 3, -2]) if rng.random() < 0.3 else rng.randrange(0, 4))
            records, slack = self.records_area(rng, nrec=5)
            struct.pack_into('<I', records.data, slack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, slack + index * 0x8d + 0x4d, 1 if rng.random() < 0.9 else rng.choice([0, 2, 3, 0x80000000, 0xffffffff]))
            rec = bytearray(rng.randbytes(0x600))
            rec[0x2d] = rng.choice([0, 0, 1, 0xff])
            rec[0x23] = rng.choice([0, 1, 0xff])
            slot = struct.unpack_from('<h', d, 0xa9e)[0]
            for j in range(0, 6):
                struct.pack_into('<h', rec, 0x2e + 2 * j, rng.choice([slot + 1, slot + 1, rng.randrange(-3, 8), 0x7fff]))
            key = rng.choice([0x2779, 0x277c, 0x2778, 0x2778, 0x2777, 0x2777, 0x2777, 0x277b, 0x277b, 0x277b, 0x277a, 0x277a, 0, 0x2776, 0x2780])
            word = lambda v: (rng.randrange(0x10000) << 16) | (v & 0xffff)
            probe = [('self', 0, 0xc30), ('records', 0, len(records.data))]
            pick = lambda: rng.choice([0, 1, 2, 3, 4, 5, 19, -1, -1])
            stubs = {0x484622: stub(0x484622, args=0, this=True, results=[word(pick())], probe=probe),
                     0x4846c2: stub(0x4846c2, args=0, this=True, results=[word(pick())], probe=probe),
                     0x4853b0: stub(0x4853b0, args=1, this=True, cleanup=4, probe=probe),
                     0x485f12: stub(0x485f12, args=0, this=True, probe=probe),
                     0x485ca1: stub(0x485ca1, args=0, this=True, probe=probe),
                     0x485d52: stub(0x485d52, args=0, this=True, probe=probe),
                     0x484f0d: stub(0x484f0d, args=1, this=True, cleanup=4, results=[rng.choice([0, 1, 0x10000, 0x80000000, 0xffffffff])], probe=probe),
                     0x4841cb: stub(0x4841cb, args=2, this=True, cleanup=8, probe=probe),
                     0x484935: stub(0x484935, args=1, this=True, cleanup=4, probe=probe)}
            self.pair(3, 0x48569e, size, [this, records, Area('rec', od.region_va(1), rec, image=False, compare=False)], stubs, {'value_5c39e5': key},
                      ecx=od.region_va(0), self_name='self', executed=executed, word_args={0x4853b0: (0,), 0x484935: (0,)},
                      pointers={'records_5bb5e5': ('records', slack)})
        self.finish(0x48569e, size, executed)

    # ---- 0x44e035 ----
    def test_44e035_draw_panel(self):
        """FL-21b: differential test of m44e035_draw_panel (original 0x44e035)"""
        rng = random.Random(0x44e035)
        executed = set()
        size = 1519
        tslack = 0x4a
        for n in range(SCENARIOS):
            records, rslack = self.records_area(rng, nrec=4)
            index = rng.choice([-1, 0, 1, 2, 3])
            struct.pack_into('<I', records.data, rslack + index * 0x8d, rng.choice([od.region_va(1), 0xfffffff0, 0x7fffffff, rng.randrange(1 << 32)]))
            table = Area('table', 0x5d1599 - tslack, bytearray(rng.randbytes(tslack + 5 * 0x4a)), compare=False)
            g = {**self.globals_(rng, 'value_5cf665', 'value_5d15e3', 'word_624cf4', 'word_624cf6', 'word_624cfc', 'word_624cfe'),
                 'word_624cdd': index, 'word_624cdb': rng.choice([-1, 0, 1, 2, 3]),
                 'value_624cec': rng.choice([0, 8, 2, 2, 2, 2, 1, 3, 5, 9, 0xffffffff, 4, 7, 0x80000002]),
                 'value_624cf0': rng.choice([0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 9, 0x10, 0xffffffff, 0x80000000]),
                 'value_624cf8': rng.choice([0, 1, 0x80000000, 0xffffff00]), 'value_624d00': rng.choice([0, 1, 0x100]),
                 'value_624d04': rng.choice([0, 1, 1, 0x40000000]), 'byte_624ce3': rng.choice([0, 1, 0xff])}
            struct.pack_into('<I', table.data, tslack + 0x4a, g['value_5d15e3'])  # 0x5d15e3 = the dword of record 1
            # at each call the redraw flag and the byte are still set (both are cleared at the end)
            probe = [('g:value_624d04', 0, 4), ('g:byte_624ce3', 0, 1)]
            rects = [[(1, 4 * q, 4, rng.randrange(1 << 32)) for q in range(4)] for _ in range(8)]
            stubs = {0x44d9b5: stub(0x44d9b5, args=2, this=True, cleanup=8, writes=rects, probe=probe),
                     0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=20, derefs=[(3, 16)], probe=probe)}
            self.pair(4, 0x44e035, size, [records, table], stubs, g, executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1599': ('table', tslack)})
        self.finish(0x44e035, size, executed)

    # ---- 0x44da08 ----
    def test_44da08_run_state(self):
        """FL-21b: differential test of m44da08_run_state (original 0x44da08)"""
        rng = random.Random(0x44da08)
        executed = set()
        size = 1529
        tslack = 0x60
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])   # (the globals 0x5bb57b.. lie just below the table: no record -1)
            now = rng.choice([1000, 0x7fffffff, 0x80000000, 0xfffffff0, rng.randrange(1 << 32)])
            self_area = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            d = self_area.data

            def put32(offset, value):
                struct.pack_into('<I', d, offset, value & 0xffffffff)
            struct.pack_into('<h', d, 0x1e, rng.choice([index, index, rng.randrange(0, 4)]))   # (state 1 and 2 use this word, not the argument)
            struct.pack_into('<h', d, 0x1c, rng.choice([0, 1, 2, 3, -1]))
            put32(0x20, rng.choice([0, 0, 0x1234abcd, 0x80000000]))
            put32(0x2d, rng.choice([0, 1, 2, 2, 3, 4, 5, 5, 6, 7, 7, 7, 8, 8, 9, 0x10, 0xffffffff, 0x80000000]))
            for offset in (0x4b, 0x4f):
                put32(offset, rng.choice([now, (now - 1) & 0xffffffff, (now + 1) & 0xffffffff, 0, 0xffffffff, rng.randrange(1 << 32)]))
            put32(0x31, rng.randrange(1 << 32))
            d[0x49] = rng.choice([0, 1, 1, 0xff])
            d[0x4a] = rng.choice([0, 1, 1, 0xff])
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            state = rng.choice([0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 0xffffffff, 0x80000000, 4])
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            consts = bytearray(rng.randbytes(0x60))
            text = bytes(rng.randrange(1, 256) for _ in range(rng.randrange(0, 0x2f)))
            consts[0:len(text) + 1] = text + b'\0'
            c_f0, c_fc, c_08 = bytes(consts[0x34:0x3d]), bytes(consts[0x40:0x49]), bytes(consts[0x4c:0x55])
            rec = bytearray(rng.randbytes(0x400))
            rec[0x265:0x26e] = rng.choice([c_f0, c_08, bytes(rng.randbytes(9)), c_f0[:8] + b'\xaa'])
            rec[0x2b1:0x2ba] = rng.choice([c_fc, c_fc, bytes(rng.randbytes(9)), c_fc[:8] + b'\xaa', c_fc[:1] + b'\xaa' + c_fc[2:]])
            for offset in (0x2d2, 0x2af):
                struct.pack_into('<h', rec, offset, rng.choice([0, 1, 5, -3, 0x7fff, -32768, 20, rng.randrange(-32768, 32768)]))
            for base, other in ((0x2e2, 0x2f6), (0x296, 0x2aa)):   # the two stored blocks: selector, then the flag word
                struct.pack_into('<h', rec, base, rng.choice([0x270f, 0x270f, 0, 5, -1, rng.randrange(-32768, 32768)]))
                struct.pack_into('<h', rec, other, rng.choice([1, 1, 0, 2, -1, 0x7fff]))
            for offset in (0x2f8, 0x2ac):   # the index of the flag table, -1 = none
                struct.pack_into('<h', rec, offset, rng.choice([-1, -1, 0, 1, 5, 9, -3]))
            table = Area('table', 0x5d1599 - tslack, bytearray(rng.randbytes(tslack + 5 * 0x4a + 0x40)))
            flags = Area('flags', 0x585801 - 0x40, bytearray(rng.randbytes(0x100)))
            g = self.globals_(rng, 'value_5bb1ca', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f', 'value_5bb5a3', 'value_583999', 'word_5bb599',
                              'word_5bb595', 'word_5c39ff')
            probe = [('self', 0, 0x60), ('table', 0, len(table.data)), ('records', 0, len(records.data)), ('flags', 0, 0x100), ('g:value_5bb1ca', 0, 4),
                     ('g:value_5bb57b', 0, 4), ('g:value_583999', 0, 4), ('g:word_5c39ff', 0, 2)]
            word = lambda v: (rng.randrange(0x10000) << 16) | (v & 0xffff)
            stubs = {0x44d711: stub(0x44d711, args=0, this=True, probe=probe),
                     0x4d39f9: stub(0x4d39f9, args=0, results=[word(rng.choice([0, 1, 2, 3, -1]))], probe=probe),
                     0x4c2790: stub(0x4c2790, args=4, this=True, cleanup=16, results=[rng.choice([0, 0xdeadbeef, 0x12345678])], probe=probe),
                     0x4fb77a: stub(0x4fb77a, args=1, this=True, cleanup=4, probe=probe),
                     0x44d8ad: stub(0x44d8ad, args=1, this=True, cleanup=4, probe=probe),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=probe),
                     0x4f6334: stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 1, 5, 0x10000, 0x80000000])], probe=probe),
                     0x4fba69: stub(0x4fba69, args=1, this=True, cleanup=4, probe=probe),
                     0x44d946: stub(0x44d946, args=0, this=True, probe=probe),
                     0x42ba3a: stub(0x42ba3a, args=1, probe=probe),
                     0x44d154: stub(0x44d154, args=0, this=True, probe=probe)}
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            stack = [(rng.randrange(0x10000) << 16) | (index & 0xffff)]
            self.pair(5, 0x44da08, size, [self_area, records, Area('rec', od.region_va(1), rec, image=False, compare=False), table, flags,
                                          Area('consts', 0x5495bc, consts, compare=False)], stubs, g, ecx=od.region_va(0), stack=stack, cleanup=4,
                      args=(index,), self_name='self', iat=iat, tick=now, executed=executed, word_args={0x4fb2e3: (0,), 0x42ba3a: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1599': ('table', tslack), 'flags_585801': ('flags', 0x40),
                                'bytes_5495bc': ('consts', 0), 'bytes_5495f0': ('consts', 0x34), 'bytes_5495fc': ('consts', 0x40),
                                'bytes_549608': ('consts', 0x4c)})
        self.finish(0x44da08, size, executed)

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
