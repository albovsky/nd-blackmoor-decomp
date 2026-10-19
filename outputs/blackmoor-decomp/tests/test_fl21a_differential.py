"""FL-21 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl21a.c on the same random
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
    """The fields of Fl21aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl21a.h').read_text()
    body = re.search(r'typedef struct Fl21aWorld \{(.*?)\} Fl21aWorld;', text, re.S).group(1)
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
    (stack argument index (-1: the this pointer, ecx), offset, size, value)."""

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
        probe = getattr(stub, 'probe_addr', None)
        # the memory at the probed addresses as it is at the call, read before the stub stores anything; appended after the deref bytes
        snapshot = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        self._stub_hook_inner(uc, address, size, user)
        if snapshot is not None and self.calls:
            self.calls[-1] = (*self.calls[-1], snapshot)

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
                pointer = uc.reg_read(self._r['ECX']) if arg < 0 else struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0]
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
class Fl21aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl21a_differential_shim.c'
    KERNELS = ['original_methods_fl21a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall20)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl21a.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl21aWorld'

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
        self.lib.shim_fl21a(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
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

    @staticmethod
    def cstr(rng, maxlen, alphabet=None):
        """The characters (no zero byte) of a string of 0 .. maxlen characters."""
        return bytes(rng.choice(alphabet) if alphabet else rng.randrange(1, 256) for _ in range(rng.randrange(maxlen + 1)))

    # ---- 0x4cb586 ----
    def test_4cb586_visit(self):
        """FL-21a: differential test of m4cb586_visit (original 0x4cb586)"""
        rng = random.Random(0x4cb586)
        executed = set()
        size = 0x4cb8d5 - 0x4cb586
        tslack = 0x4a
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            state = rng.choice([0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 0xffffffff, 4])
            records, rslack = self.records_area(rng, nrec=5)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x200)), image=False)
            name_va = od.region_va(2)
            qs = self.cstr(rng, 6, b'abAB\x80\xff')
            ps = rng.choice([qs, qs, qs, qs[:-1] if qs else b'zz', qs + b'a', bytes([qs[0] ^ 1]) + qs[1:] if qs else b'a',
                             qs[:1] + bytes([qs[1] ^ 0x80]) + qs[2:] if len(qs) > 1 else qs + b'bb', self.cstr(rng, 6, b'abAB\x80\xff')])
            qb = qs + b'\0' + rng.randbytes(8)
            pb = qb if rng.random() < 0.3 else ps + b'\0' + rng.randbytes(8)
            q = Area('name', name_va, bytearray(qb), image=False, compare=False)
            p = Area('pname', od.region_va(3), bytearray(pb), image=False, compare=False)
            struct.pack_into('<I', this.data, 0x1a, rng.choice([0, name_va, name_va]))
            struct.pack_into('<I', this.data, 0x14a, rng.choice([0xffffffff, 7, 0x1234]))
            struct.pack_into('<I', this.data, 0x12, rng.randrange(1 << 32))
            obj = bytearray(rng.randbytes(0x100))
            struct.pack_into('<h', obj, 0x21, rng.choice([0, 0, 1, 5, -1, 0x100]))
            sname = bytes(rng.choice(b'abcdefgh') for _ in range(rng.randrange(0, 20))) + b'\0'
            string = Area('s558c30', 0x558c30, bytearray(sname + rng.randbytes(4)), compare=False)
            table = Area('table', 0x5d1591 - tslack, bytearray(rng.randbytes(tslack + 6 * 0x4a)))
            g = {'word_583a29': rng.choice([-1, -1, 0, 5, -2, 0x7fff])}
            first_local = rng.choice([0, 1, 2, 2, 2, 3, 5, 0x80000002])
            second_local = rng.choice([0, 1, 2, 2, 3, 3, 4, 0xffffffff])
            v = rng.choice([0xffffffff, 7, 0x1234, 0, 5])
            idx_word = rng.choice([-1, 0, 1, 2, 3]) | (rng.randrange(0x10000) << 16)
            rbyte = ('records', rslack + index * 0x8d + 0x40, 1)
            stubs = {
                # the name pointer is stored by the load when [self+0x1a] was 0; call-time state is probed wherever the original has stored before the call
                0x4cbba9: stub(0x4cbba9, args=1, this=True, cleanup=4, writes=[[(-1, 0x1a, 4, name_va)]], probe=[('self', 0x16, 4), ('self', 0x1a, 4)]),
                0x4c0c2c: stub(0x4c0c2c, this=True, results=[first_local, second_local], probe=[('self', 8, 0x10), ('self', 0x14a, 4)]),
                0x4c0c18: od.Stub(0x4c0c18, this=True, result=p.va),
                0x4d39f9: stub(0x4d39f9, results=[idx_word], probe=[('self', 0xc, 2)]),
                0x4c0c54: od.Stub(0x4c0c54, this=True, result=v),
                0x4cb944: stub(0x4cb944, args=1, this=True, cleanup=4, results=[rng.choice([0, 1, 5, 0x80000000])], probe=[('self', 8, 0x10)]),
                0x4cb9d1: stub(0x4cb9d1, this=True, probe=[('self', 8, 0x10), ('self', 0x14a, 4)]),
                0x4caf8a: stub(0x4caf8a, this=True, probe=[rbyte]),
                0x42ba3a: stub(0x42ba3a, args=1, probe=[rbyte])}
            high = rng.randrange(0x10000) << 16
            self.pair(1, 0x4cb586, size, [this, records, q, p, Area('obj', od.region_va(1), obj, image=False, compare=False), string, table], stubs, g,
                      ecx=this.va, stack=[high | (index & 0xffff)], cleanup=4, args=(index,), self_name='self', executed=executed,
                      word_args={0x42ba3a: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1591': ('table', tslack), 'string_558c30': ('s558c30', 0)})
        self.finish(0x4cb586, size, executed)

    # ---- 0x42caa8 ----
    def test_42caa8_clip_rect(self):
        """FL-21a: differential test of m42caa8_clip_rect (original 0x42caa8)"""
        rng = random.Random(0x42caa8)
        executed = set()
        size = 0x42cecd - 0x42caa8

        def i32(v):
            return ((v + 0x80000000) & 0xffffffff) - 0x80000000
        eslack = 2
        for n in range(SCENARIOS):
            index = rng.choice([-2, -1, 0, 1, 2, 3, 4])
            c4 = rng.choice([rng.randrange(-8, 30), rng.randrange(-8, 30), 0x7ffffff0, -0x80000000, 5])
            c12 = i32(rng.choice([c4 + rng.randrange(0, 25), c4 + rng.randrange(0, 25), c4 + 3, rng.randrange(-8, 40), 0x7fffffff]))
            near = [c4 - 3, c4, c4 + 1, c12 - 1, c12, c12 + 3, rng.randrange(-10, 50), 0x7fffffff, -0x80000000]
            entries = bytearray(rng.randbytes((eslack + 8) * 0x42))
            for m in range(-eslack, 8):
                base = (eslack + m) * 0x42
                y0 = rng.choice(near)
                y1 = rng.choice([y0, y0 + rng.randrange(0, 20), rng.choice(near)])
                struct.pack_into('<i', entries, base + 0x16, i32(y0))
                struct.pack_into('<i', entries, base + 0x1e, i32(y1))
            ent = Area('entries', od.region_va(1), entries, image=False, compare=False)
            clip = Area('clip', od.region_va(2), bytearray(rng.randbytes(16)), image=False, compare=False)
            struct.pack_into('<i', clip.data, 4, i32(c4))
            struct.pack_into('<i', clip.data, 0xc, c12)
            records, rslack = self.records_area(rng, nrec=4)
            ptr_area = Area('p5b4ea9', 0x5b4ea9, bytearray(struct.pack('<I', ent.va + eslack * 0x42)), compare=False)
            g = {**self.globals_(rng, 'origin_x_583186', 'origin_y_58318a', 'value_5b4e1c', 'value_5b4e24', 'value_5b4e18', 'value_5b4e20', 'value_5b4e2c',
                                 'value_5b4e34', 'value_5b4e28', 'value_5b4e30', 'value_5b4e5c', 'value_5b4e64', 'value_5b4e58', 'value_5b4e60',
                                 'value_5d1967'),
                 'word_5b4ea3': rng.choice([2, 2, 2, 0, 1, 3, -2]), 'word_5b4e89': rng.choice([-1, 0, 1, 2, 3]),
                 'word_5b4e8b': rng.choice([2, 2, 0, 1, 3, -2])}
            if rng.random() < 0.5:
                g['origin_x_583186'] = rng.choice([0, 7, 0xfffffff9, 0x7fffffff, 0x80000000])
                g['origin_y_58318a'] = rng.choice([0, 7, 0xfffffff9, 0x7fffffff, 0x80000000])
            stubs = {0x42cecd: stub(0x42cecd, args=2)}
            high = rng.randrange(0x10000) << 16
            self.pair(2, 0x42caa8, size, [ent, clip, records, ptr_area], stubs, g, ecx=0, stack=[high | (index & 0xffff), clip.va], cleanup=0,
                      args=(index, ('ptr', 'clip', 0)), executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'entries_5b4ea9': ('entries', eslack * 0x42)})
        self.finish(0x42caa8, size, executed)

    # ---- 0x462c39 ----
    def test_462c39_pointer_move(self):
        """FL-21a: differential test of m462c39_pointer_move (original 0x462c39)"""
        rng = random.Random(0x462c39)
        executed = set()
        size = 0x4630a3 - 0x462c39
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            struct.pack_into('<I', this.data, 0x3f, 0 if rng.random() < 0.08 else rng.choice([1, 0x80000000, 0xffffffff, 0x100]))
            struct.pack_into('<I', this.data, 0x24, 2 if rng.random() < 0.08 else rng.choice([0, 1, 3, 0x100, 0x20000, 0xffffffff]))
            struct.pack_into('<i', this.data, 0x53, rng.choice([0, 1, 2, 3, 7, 8, 9, 20, 21, -1, -2, -3, -9, -21, 100]))
            struct.pack_into('<i', this.data, 0x4f, rng.choice([0, 1, 2, 3, 4, 5, 7, 8, 9, 12, 13, -1, -2, -3, -4, -5, -7, -9, -13]))
            rows, cols = rng.choice([0, 1, 2, 3, 3]), rng.choice([0, 1, 2, 3, 4, 4])
            records, rslack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            rec = bytearray(rng.randbytes(0x400))
            struct.pack_into('<h', rec, 0x22, rows)
            struct.pack_into('<h', rec, 0x24, cols)
            x = rng.choice([rng.randrange(-5, 60), rng.randrange(-5, 60), -32768, 32767, 0])
            y = rng.choice([rng.randrange(-5, 60), rng.randrange(-5, 60), -32768, 32767, 0])
            ox, oy = rng.choice([0, 0, 3, -4, 10]), rng.choice([0, 0, 2, -7, 11])
            px, py = x + ox, y + oy
            for off, base in ((0x347, x), (0x34f, x), (0x34b, y), (0x353, y)):
                struct.pack_into('<i', rec, off, rng.choice([base - 1, base, base + 1, base, base, rng.randrange(-100, 100)]))
            cells = bytearray(rng.randbytes(0x600))
            for r in range(4):
                for c in range(5):
                    cb = r * 0x140 + c * 0x28
                    left = rng.choice([px - rng.randrange(0, 8), px - 1, px, rng.randrange(-5, 50)])
                    right = rng.choice([left + rng.randrange(0, 40), left + 12, left + 3, px + rng.randrange(0, 8), px, px + 1])
                    top = rng.choice([py - rng.randrange(0, 8), py - 1, py, rng.randrange(-5, 50)])
                    bottom = rng.choice([top + rng.randrange(0, 40), top + 12, top + 3, py + rng.randrange(0, 8), py, py + 1])
                    struct.pack_into('<i', cells, cb + 0x14, left)
                    struct.pack_into('<i', cells, cb + 0x1c, right)
                    struct.pack_into('<i', cells, cb + 0x18, top)
                    struct.pack_into('<i', cells, cb + 0x20, bottom)
                    struct.pack_into('<h', cells, cb + 0x26, rng.choice([0, 0, 1, 2, -1, 0x1234, -32768]))
            g = {'origin_x_583186': ox, 'origin_y_58318a': oy}
            state = [('self', 0x39, 2), ('self', 0x5b, 4), ('self', 0x57, 2)]
            stubs = {0x4619be: stub(0x4619be, args=1, this=True, cleanup=4, results=[rng.choice([1, 0, 2, 0xffffffff, 0x80000001, 1]) for _ in range(24)],
                                    probe=state),
                     0x4630a3: stub(0x4630a3, args=1, this=True, cleanup=4, probe=state)}
            xw = (rng.randrange(0x10000) << 16) | (x & 0xffff)
            yw = (rng.randrange(0x10000) << 16) | (y & 0xffff)
            self.pair(3, 0x462c39, size, [this, records, Area('rec', od.region_va(1), rec, image=False, compare=False),
                                          Area('cells', 0x594db5, cells, compare=False)], stubs, g, ecx=this.va, stack=[xw, yw], cleanup=8,
                      args=(x, y), self_name='self', executed=executed, ret_mask=0xffffffff,
                      pointers={'records_5bb5e5': ('records', rslack), 'cells_594db5': ('cells', 0)})
        self.finish(0x462c39, size, executed)

    # ---- 0x484f42 ----
    def test_484f42_pointer_move(self):
        """FL-21a: differential test of m484f42_pointer_move (original 0x484f42)"""
        rng = random.Random(0x484f42)
        executed = set()
        size = 0x4853b0 - 0x484f42
        for n in range(SCENARIOS):
            rindex = rng.choice([-1, 0, 1, 2])
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0xd00)), image=False)
            d = this.data
            slot_index = rng.choice([0, 1, 2, 3])
            struct.pack_into('<h', d, 0x26, rindex)
            struct.pack_into('<I', d, 0xba7, 0 if rng.random() < 0.08 else rng.choice([1, 0x80000000, 0xff]))
            struct.pack_into('<I', d, 0xa92, 0 if rng.random() < 0.5 else rng.choice([1, 0x100, 0xffffffff]))
            struct.pack_into('<h', d, 0xa9e, slot_index)
            struct.pack_into('<I', d, 0xc27, rng.choice([0, 0, 1, 0x40000000]))
            struct.pack_into('<h', d, 0xbf9, rng.choice([0, 0, 3, -1, 0x7fff]))
            struct.pack_into('<h', d, 0xc23, rng.choice([0, 0, 3, -1, 0x7fff]))
            x = rng.choice([rng.randrange(-3, 30), rng.randrange(-3, 30), -32768, 32767])
            y = rng.choice([rng.randrange(-3, 30), rng.randrange(-3, 30), -32768, 32767])
            rec = bytearray(rng.randbytes(0x1000))
            struct.pack_into('<h', rec, 0x21, rng.choice([0, 1, 2, 3, 4, 4, -1]))
            rec[0x24] = rng.choice([0, 1, 1, 0xff])
            rec[0x25] = rng.choice([0, 1, 1, 0xff])
            rec[0x2a] = rng.choice([0, 1, 1, 0xff])
            struct.pack_into('<h', rec, 0x26, rng.choice([0, 3, 6, 10, -2]))
            struct.pack_into('<h', rec, 0x28, rng.choice([0, 3, 6, 10, -2]))
            struct.pack_into('<h', rec, 0x2b, rng.choice([0, 1, 2, -1, -3, 5]))
            near = lambda base: rng.choice([base - 1, base, base + 1, base, rng.randrange(-5, 40)])
            for left, right, top, bottom in ((0x5b7, 0x5bf, 0x5bb, 0x5c3), (0x5f8, 0x600, 0x5fc, 0x604), (0xef7, 0xeff, 0xefb, 0xf03)):
                struct.pack_into('<i', rec, left, near(x))
                struct.pack_into('<i', rec, right, near(x) if rng.random() < 0.7 else near(x) + 4)
                struct.pack_into('<i', rec, top, near(y))
                struct.pack_into('<i', rec, bottom, near(y) + (4 if rng.random() < 0.7 else 0))
            if rng.random() < 0.15:   # an empty rectangle at 0x5b7: the test is skipped
                struct.pack_into('<I', rec, 0x5bf, struct.unpack_from('<I', rec, 0x5b7)[0])
            e = slot_index * 0x42
            t = struct.unpack_from('<h', rec, 0x2b)[0] if rec[0x2a] != 0 else 0
            # the four extents of the entry in the record vs the four rectangle words in the object (all or most of the compares succeed)
            struct.pack_into('<i', rec, e + 0xa3, rng.randrange(-10, 10))
            struct.pack_into('<i', rec, e + 0xab, rng.randrange(-10, 10))
            struct.pack_into('<i', rec, e + 0x9f, rng.randrange(-10, 10))
            struct.pack_into('<i', rec, e + 0xa7, rng.randrange(-10, 10))
            a, b, c_, dd = [struct.unpack_from('<i', rec, e + o)[0] for o in (0xa3, 0xab, 0x9f, 0xa7)]
            good = rng.random() < 0.6
            struct.pack_into('<i', d, 0xaa4, a - t + rng.randrange(0, 3) if good else rng.randrange(-12, 12))
            struct.pack_into('<i', d, 0xaac, b + t - rng.randrange(0, 3) if good else rng.randrange(-12, 12))
            struct.pack_into('<i', d, 0xaa0, c_ - t + rng.randrange(0, 3) if good else rng.randrange(-12, 12))
            struct.pack_into('<i', d, 0xaa8, dd + t - rng.randrange(0, 3) if good else rng.randrange(-12, 12))
            for i in range(5):   # the slots: left +2, top +6, right +0xa, bottom +0xe, bytes +0x22 and +0x23
                sb = 0x28 + i * 0x85
                sl = rng.choice([x - 4, x - 1, x, x + 1, rng.randrange(-3, 30)])
                st = rng.choice([y - 4, y - 1, y, y + 1, rng.randrange(-3, 30)])
                struct.pack_into('<i', d, sb + 2, sl)
                struct.pack_into('<i', d, sb + 6, st)
                struct.pack_into('<i', d, sb + 0xa, sl + rng.choice([0, 2, 5, 12, -2]))
                struct.pack_into('<i', d, sb + 0xe, st + rng.choice([0, 2, 5, 12, -2]))
                d[sb + 0x22] = rng.choice([0, 0, 1, 0xff])
                d[sb + 0x23] = rng.choice([0, 0, 0, 1, 0xff])
            records, rslack = self.records_area(rng, nrec=4)
            struct.pack_into('<I', records.data, rslack + rindex * 0x8d, od.region_va(1))
            rect = Area('rect', od.region_va(2), bytearray(rng.randbytes(16)), image=False, compare=False)
            probe_all = [('self', 0xbb1, 0x7a), ('rec', 0x2b, 2)]
            stubs = {0x484d87: stub(0x484d87, this=True, probe=[('self', 0xbb1, 0x10)]),
                     0x4854fb: stub(0x4854fb, args=1, this=True, cleanup=4, probe=probe_all)}
            xw = (rng.randrange(0x10000) << 16) | (x & 0xffff)
            yw = (rng.randrange(0x10000) << 16) | (y & 0xffff)
            self.pair(4, 0x484f42, size, [this, records, Area('rec', od.region_va(1), rec, image=False), rect], stubs, {}, ecx=this.va,
                      stack=[xw, yw, rect.va], cleanup=0xc, args=(x, y, ('ptr', 'rect', 0)), self_name='self', executed=executed, ret_mask=0xffffffff,
                      pointers={'records_5bb5e5': ('records', rslack)})
        self.finish(0x484f42, size, executed)

    # ---- 0x48d914 ----
    def test_48d914_step_scene(self):
        """FL-21a: differential test of m48d914_step_scene (original 0x48d914)"""
        rng = random.Random(0x48d914)
        executed = set()
        # the original's body ends with its switch table (five dwords at 0x48deb3): only the code before it is instructions
        size = 0x48deb3 - 0x48d914
        tslack = 0x4a
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            now = rng.choice([0, 3, 0xfffffffe, 1000, rng.randrange(1 << 32)])
            state = rng.choice([0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 0xffffffff, 5])
            # (no slack record below the table: it would overlap the globals 0x5bb57b ... 0x5bb5a3 that the function writes)
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, rng.choice([0, 1, 2, 3]))
            struct.pack_into('<I', this.data, 0x2b, rng.choice([0, 1, 2, 3, 4, 5, 0xffffffff, 0x80000000, 1, 3]))
            struct.pack_into('<I', this.data, 0x2f, rng.choice([0, 1, 0x100]))
            struct.pack_into('<I', this.data, 0x39, (now + rng.choice([-5, -1, 0, 1, 5, 0x7fffffff, 0x80000000, 0x80000001])) & 0xffffffff)
            struct.pack_into('<I', this.data, 0x20, rng.choice([0, 0, 0x1234, 0xffffffff]))
            this.data[0x37] = rng.choice([0, 1, 0xff])
            this.data[0x38] = rng.choice([0, 1, 0xff])
            same_byte = rng.random() < 0.5
            rec = bytearray(rng.randbytes(0x800))
            byte_63a8ac = rng.randrange(256)
            rec[0] = byte_63a8ac if same_byte else (byte_63a8ac ^ rng.choice([1, 0x80, 0xff]))
            bytes9 = rng.randbytes(9)
            rec[0x761:0x761 + 9] = bytes9 if rng.random() < 0.5 else bytes(b ^ (1 if k == rng.randrange(9) else 0) for k, b in enumerate(bytes9))
            if rng.random() < 0.3:   # (a difference in just one position)
                rec[0x761 + rng.randrange(9)] ^= 0x80
            struct.pack_into('<h', rec, 0x75f, rng.choice([0, 1, 5, -1, -3, 40, 4000, -32768]))
            struct.pack_into('<h', rec, 0x782, rng.choice([0, 1, 5, -1, 0x7fff, -32768, 300]))
            for base in (0x792, 0x746):   # the two groups of 0x270f / flag / table words
                struct.pack_into('<h', rec, base, rng.choice([0x270f, 0x270f, 0, 5, -1, -0x270f]))
                struct.pack_into('<h', rec, base + 0x14, rng.choice([1, 1, 0, 2, -1, 0x101]))
                struct.pack_into('<h', rec, base + 0x16, rng.choice([-1, -1, -3, -2, 0, 1, 5, 9]))
            flags = Area('flags', 0x585801 - 0x10, bytearray(rng.randbytes(0x50)))
            t5d = Area('table', 0x5d1591 - tslack, bytearray(rng.randbytes(tslack + 6 * 0x4a)))
            s54 = bytes(rng.choice(b'abcdefgh') for _ in range(rng.randrange(0, 20))) + b'\0'
            str54 = Area('s54e89c', 0x54e89c, bytearray(s54 + rng.randbytes(2)), compare=False)
            b54 = Area('b54e8d4', 0x54e8d4, bytearray(bytes9), compare=False)
            g = {**self.globals_(rng, 'value_5bb1ca', 'value_583999', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f', 'value_5bb5a3', 'word_5bb599',
                                 'word_5bb595', 'word_5c39ff'), 'byte_63a8ac': byte_63a8ac}
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            idx_word = rng.choice([-1, 0, 1, 2, 3]) | (rng.randrange(0x10000) << 16)
            rbyte = [('records', rslack + index * 0x8d + 0x4d, 4)]
            stubs = {0x4e8d96: stub(0x4e8d96, this=True, probe=[('self', 0x1e, 2), ('self', 0x33, 4), ('self', 0x24, 3), ('self', 0x20, 4),
                                                              ('g:value_5bb1ca', 0, 4)]),
                     0x4d39f9: stub(0x4d39f9, results=[idx_word], probe=[('self', 0x2f, 4), ('self', 0x37, 2), ('self', 0x3d, 15)]),
                     0x4c2790: stub(0x4c2790, args=4, this=True, cleanup=0x10, results=[rng.randrange(1 << 32)],
                                    probe=[('self', 0x1c, 2), ('self', 0x20, 4), ('table', tslack + 0x0, 0x4a * 5)]),
                     0x4fba69: stub(0x4fba69, args=1, this=True, cleanup=4, probe=[('self', 0x24, 3), ('self', 0x2b, 4)] + rbyte),
                     0x48d89e: stub(0x48d89e, this=True, probe=[('self', 0x2b, 4)]),
                     0x4fb77a: stub(0x4fb77a, args=1, this=True, cleanup=4, probe=[('self', 0x2b, 4)]),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=[('self', 0x2b, 4)]),
                     0x4f6334: stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 1, 0xffffffff, 0x100])], probe=[('self', 0x2b, 4)] + rbyte),
                     0x42ba3a: stub(0x42ba3a, args=1, probe=[('g:value_5bb1ca', 0, 4), ('g:value_583999', 0, 4), ('flags', 0, 0x50)]),
                     0x48d09c: stub(0x48d09c, this=True, probe=[('g:value_5bb1ca', 0, 4), ('flags', 0, 0x50)])}
            high = rng.randrange(0x10000) << 16
            self.pair(5, 0x48d914, size, [this, records, Area('rec', od.region_va(1), rec, image=False, compare=False), flags, t5d, str54, b54], stubs, g,
                      ecx=this.va, stack=[high | (index & 0xffff)], cleanup=4, args=(index,), self_name='self', executed=executed, iat=iat, tick=now,
                      word_args={0x42ba3a: (0,), 0x4fb2e3: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1591': ('table', tslack), 'string_54e89c': ('s54e89c', 0),
                                'bytes_54e8d4': ('b54e8d4', 0), 'flags_585801': ('flags', 0x10)})
        self.finish(0x48d914, size, executed)

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
