"""FL-22 (batch b) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl22b.c on the same random
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
    """The fields of Fl22bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl22b.h').read_text()
    body = re.search(r'typedef struct Fl22bWorld \{(.*?)\} Fl22bWorld;', text, re.S).group(1)
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
class Fl22bDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl22b_differential_shim.c'
    KERNELS = ['original_methods_fl22b.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall20)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl22b.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl22bWorld'

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
        self.lib.shim_fl22b(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
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

    # ---- 0x42ed54 ----
    def test_42ed54_run_state(self):
        """FL-22b: differential test of m42ed54_run_state (original 0x42ed54): all three states, all four arms of the jump table at 0x42f500"""
        rng = random.Random(0x42ed54)
        executed = set()
        size = 1964
        scalars = ['byte_5b5158', 'byte_5b516a', 'byte_5b515d', 'word_5b5159', 'word_5b5166', 'word_5b5168', 'value_5b515e', 'value_5b5162',
                   'value_5d03cf', 'value_5d1a83', 'value_5d1a8f', 'value_5bb1ca', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f',
                   'value_5bb5a3', 'value_583999', 'word_5bb599', 'word_5bb595', 'word_5c39ff']
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            now = rng.choice([1000, 0x7fffffff, 0x80000000, 0xfffffff0, rng.randrange(1 << 32)])
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            state = rng.choice([0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 0xffffffff, 0x80000000])
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            consts = bytearray(rng.randbytes(0x20))
            nine = [bytes(consts[0:9]), bytes(consts[0xc:0x15]), bytes(consts[0x18:0x21])]
            rec = bytearray(rng.randbytes(0x400))
            pick = lambda *vals: rng.choice(vals)
            small = lambda: rng.choice([-3, -1, 0, 1, 2, 3, 4, 5, 8, 0x270f, rng.randrange(-32768, 32768)])
            sw = lambda off, v: struct.pack_into('<h', rec, off, v)
            # the nine-byte fields: equal to the constant, or one byte off
            for off, k in ((0x235, 0), (0x281, 1)):
                rec[off:off + 9] = rng.choice([nine[k], nine[k], nine[k], bytes(rng.randbytes(9)), nine[k][:8] + bytes([nine[k][8] ^ 0x40]),
                                               bytes([nine[k][0] ^ 1]) + nine[k][1:]])
            if state == 2:
                rec[0x235:0x23e] = rng.choice([nine[2], nine[2], bytes(rng.randbytes(9)), nine[2][:8] + b'\xaa'])
            count = rng.choice([0, 1, 2, 3, 4, 5, 8, 15, 16, -2, -32768])
            sw(0x223, count if state == 1 else rng.choice([count, small(), 0x7fff, -0x7fff, 1000]))
            sw(0x21, rng.choice([0, 1, 3, 5, 6, 7, 10, -1, -5, 0x7fff, small()]))
            # the sub-step of state 1: words match the record's bytes for a while, then differ (or match all)
            step = rng.choice([0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 0xffffffff, 0x80000000])
            tab = bytearray(rng.randbytes(48))
            bound = max(0, min(count, 16)) if state == 1 else 0
            ok_n = rng.randrange(0, bound + 1) if bound else 0
            for i in range(16):
                value = rec[0x225 + i] if i < ok_n or rng.random() < 0.3 else rng.choice([0xffff, 0x100 | rec[0x225 + i], rng.randrange(0x10000)])
                struct.pack_into('<H', tab, 16 + 2 * i, value)
            flag_idx = lambda: rng.choice([-1, -1, 0, 1, 5, 9, -3, 40, -16, 47])
            for off in (0x27c, 0x2c8):
                sw(off, flag_idx())
            for off in (0x2b2, 0x266):
                sw(off, rng.choice([0x270f, 0x270f, 0, 5, -1, rng.randrange(-32768, 32768)]))
            for off in (0x2c6, 0x27a):
                sw(off, rng.choice([1, 1, 0, 2, -1, 0x7fff]))
            sw(0x27f, rng.choice([0, 1, 5, -3, 0x7fff, -32768, 20, rng.randrange(-32768, 32768)]))
            sw(0x2a2, rng.choice([0, 1, 5, -3, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            flags = Area('flags', 0x585801 - 0x40, bytearray(rng.randbytes(0x100)))
            g = self.globals_(rng, *scalars)
            g['value_5b5162'] = step
            g['byte_5b515d'] = pick(0, 1, 0xff)
            g['value_5b515e'] = rng.choice([now, (now + 1) & 0xffffffff, (now - 1) & 0xffffffff, 0, 0xffffffff, rng.randrange(1 << 32)])
            a = rng.choice([0, 1, 5, 0x7fff, 0x8000, 0xffff, rng.randrange(0x10000)])
            g['word_5b5166'] = rng.choice([a, a, (a + 1) & 0xffff, (a - 1) & 0xffff, rng.randrange(0x10000)])
            g['word_5b5168'] = a
            tabarea = Area('tab', 0x5b5128, tab)
            P1 = [('tab', 0, 48), ('records', 0, len(records.data)), ('g:byte_5b5158', 0, 1), ('g:byte_5b516a', 0, 1), ('g:byte_5b515d', 0, 1),
                  ('g:word_5b5159', 0, 2), ('g:word_5b5166', 0, 2), ('g:word_5b5168', 0, 2)]
            P2 = [('g:value_5d03cf', 0, 4), ('g:value_5d1a83', 0, 4), ('g:value_5d1a8f', 0, 4), ('g:value_5b5162', 0, 4), ('g:value_5b515e', 0, 4),
                  ('g:value_5bb1ca', 0, 4), ('records', 0, len(records.data)), ('tab', 0, 48)]
            P3 = [('g:value_5bb1ca', 0, 4), ('g:value_5bb57b', 0, 4), ('g:value_5bb59b', 0, 4), ('g:value_5bb59f', 0, 4), ('g:value_5bb5a3', 0, 4),
                  ('g:value_583999', 0, 4), ('g:word_5bb599', 0, 2), ('g:word_5bb595', 0, 2)]
            P4 = [('g:word_5c39ff', 0, 2), ('g:byte_5b5158', 0, 1), ('g:value_5d1a8f', 0, 4), ('flags', 0, 0x100), ('records', 0, len(records.data))]
            stubs = {0x50cd50: stub(0x50cd50, args=0, results=[rng.choice([0, 1, 2, 3, 4, 5, 6, 7, 0x7fff, 0x7fffffff, 0x80000000, 0xfffffffb, 0xffffffff,
                                                                         rng.randrange(1 << 32)])]),
                     0x4c2dfb: stub(0x4c2dfb, args=1, this=True, cleanup=4, probe=P1),
                     0x4c2790: stub(0x4c2790, args=4, this=True, cleanup=16, results=[rng.choice([0, 0xdeadbeef, 0x12345678])], probe=P1),
                     0x4fb77a: stub(0x4fb77a, args=1, this=True, cleanup=4, probe=P2),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=P2),
                     0x4f6334: stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 1, 5, 0x10000, 0x80000000])], probe=P2),
                     0x4fba69: stub(0x4fba69, args=1, this=True, cleanup=4, probe=P2),
                     0x42ba3a: stub(0x42ba3a, args=1, probe=P3)}
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            stack = [(rng.randrange(0x10000) << 16) | (index & 0xffff)]
            self.pair(1, 0x42ed54, size, [records, Area('rec', od.region_va(1), rec, image=False, compare=False), tabarea, flags,
                                          Area('consts', 0x545b48, consts, compare=False)], stubs, g, ecx=0x33333333, stack=stack, cleanup=0,
                      args=(index,), iat=iat, tick=now, executed=executed, word_args={0x4fb2e3: (0,), 0x42ba3a: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'flags_585801': ('flags', 0x40), 'bytes_5b5128': ('tab', 0),
                                'words_5b5138': ('tab', 16), 'bytes_545b48': ('consts', 0), 'bytes_545b54': ('consts', 0xc),
                                'bytes_545b60': ('consts', 0x18)})
        self.finish(0x42ed54, size, executed)

    # ---- 0x47ff0e ----
    def test_47ff0e_handle_click(self):
        """FL-22b: differential test of m47ff0e_handle_click (original 0x47ff0e): every event, the click, the release and the caption strings"""
        rng = random.Random(0x47ff0e)
        executed = set()
        size = 2713
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
            self_area = Area('self', od.region_va(0), bytearray(rng.randbytes(0x1400)), image=False)
            d = self_area.data
            put = lambda fmt, offset, value: struct.pack_into(fmt, d, offset, value)
            put('<h', 0x1e, rng.choice([index, index, index]))
            put('<I', 0x13c5, rng.choice([1, 1, 1, 0, 0x100, 0xff000000]))
            d[0x13ce] = rng.choice([0, 0, 0, 0, 1, 0xff])
            put('<I', 0x13ca, rng.choice([0, 0, 0, 0, 1, 0x10000]))
            put('<I', 0x1344, rng.choice([0, 1, 1, 0x100]))
            put('<I', 0x13df, rng.choice([0, 1, 0x10000, 0x100]))
            d[0x13b0] = rng.choice([0, 1, 1, 0xff])
            d[0x13b1] = rng.choice([0, 1, 1, 0xff])
            put('<h', 0x1350, rng.choice([0, 1, 2, 3, 4, -1]))
            put('<H', 0x13a2, rng.choice([0, 1, 5, 0xfffe, 0xffff, rng.randrange(0x10000)]))
            for k in range(4):
                d[0x7a0 + k] = rng.choice([0, 1, 2, 0x7f, 0xff])
            for item in range(-1, 6):   # the kind byte of every item
                d[0x7b6 + item * 0x25 + 0x21] = rng.choice([0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, rng.choice([1, 1, 1, 1, 1, 0, 2, 3, 0xffffffff]))
            # the strings: all of one length m so that the bytes behind the frame pointer can be compared
            m = rng.randrange(1, 28)
            text = lambda k: bytes(rng.randrange(1, 256) for _ in range(k))
            rec = bytearray(rng.randbytes(0x1000))
            consts = bytearray(rng.randbytes(0x20))
            nine = bytes(consts[0:9])
            rec[0x7a8:0x7b1] = rng.choice([nine, nine, bytes(rng.randbytes(9)), nine[:8] + bytes([nine[8] ^ 0x40]), bytes([nine[0] ^ 1]) + nine[1:]])
            rec[0x5e] = rng.choice([0, 1, 2, 2, 3])
            for k in range(4):
                rec[0xe9 + k * 0x53] = rng.choice([0, 0, 1, 0x80, 0xff])
            rec[0x7d9:0x7d9 + 40] = bytes(40)
            rec[0x7fa:0x7fa + 40] = bytes(40)
            len1 = rng.choice([0, m, m, m, 3])
            len2 = rng.choice([0, m, m, m])
            rec[0x7d9:0x7d9 + len1] = text(len1)
            rec[0x7fa:0x7fa + len2] = text(len2)
            areas = [self_area, records, Area('rec', od.region_va(1), rec, image=False, compare=False), Area('consts', 0x54d5a4, consts, compare=False)]
            mode = rng.choice(['text', 'text', 'text', 'null', 'big'])
            result_addr = 0
            if mode == 'text':
                areas.append(Area('text', od.region_va(2), bytearray(text(m) + b'\0' + bytes(8)), image=False, compare=False))
                result_addr = od.region_va(2)
            elif mode == 'big':   # longer than 0x9c40: the original drops it (and the second string is used)
                big = bytearray(b'a' * rng.choice([0x9c41, 0x9c41, 0x9c41 + rng.randrange(0, 20)]) + b'\0')
                areas.append(Area('text', od.region_va(2), big, image=False, compare=False))
                result_addr = od.region_va(2)
            sel = rng.choice([0x278d, 0x278d, 0x278e, 0x278f, 0x2790, 0x2791, 0x2791, 0x2791, 0x2791, 0x2792, 0x278c, 0])
            profile = rng.choice(['free', 'free', 'release', 'release', 'click', 'select'])
            if profile != 'free':   # the gates pass; then a release (the caption part), a first click, or a selection
                put('<I', 0x13c5, 1)
                d[0x13ce] = 0
                put('<I', 0x13ca, 0)
                struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, 1)
            if profile == 'release':
                put('<I', 0x13df, rng.choice([0, 0, 0, 0, 1, 0x10000]))   # (mostly nothing held: the caption part)
                put('<I', 0x1344, rng.choice([0, 1]))
                d[0x13b1] = 0
                rec[0x7a8:0x7b1] = rng.choice([nine, bytes(rng.randbytes(9)), bytes(rng.randbytes(9)), bytes(rng.randbytes(9))])
                sel = 0x2791
            elif profile == 'click':
                put('<I', 0x1344, rng.choice([0, 0, 1]))
                d[0x13b0] = rng.choice([0, 1, 1])
                d[0x13b1] = rng.choice([0, 0, 1])
                sel = 0x278d
            elif profile == 'select':
                sel = rng.choice([0x278e, 0x278f, 0x2790])
            g = {'value_5c39e5': sel, 'value_5bb202': rng.choice([0, 1, 1, 1, 1, 1, 2, 0x10000]), 'value_5d03b3': rng.randrange(1 << 32),
                 'dword_54d5b0': rng.randrange(1 << 32), 'dword_54d5b4': rng.randrange(1 << 32)}
            probe = [('self', 0, 0x20), ('self', 0x790, 0x80), ('self', 0x1340, 0x30), ('self', 0x1390, 0x60), ('records', 0, len(records.data))]
            word = lambda: (rng.randrange(0x10000) << 16) | rng.choice([0xffff, 0, 1, 2, 3, 4])   # (an item index: the object holds a few items)
            frame_len = m + 4
            stubs = {0x480b34: stub(0x480b34, args=0, this=True, probe=probe),
                     0x47e8fe: stub(0x47e8fe, args=0, this=True, results=[word()], probe=probe),
                     0x47fa11: stub(0x47fa11, args=1, this=True, cleanup=4, probe=probe),
                     0x480abe: stub(0x480abe, args=0, this=True, probe=probe),
                     0x47e9d3: stub(0x47e9d3, args=0, this=True, results=[word()], probe=probe),
                     0x47fb76: stub(0x47fb76, args=1, this=True, cleanup=4, probe=probe),
                     0x47e582: stub(0x47e582, args=3, this=True, cleanup=12, probe=probe),
                     0x47ed96: stub(0x47ed96, args=1, this=True, cleanup=4, probe=probe),
                     0x47e99e: stub(0x47e99e, args=1, this=True, cleanup=4, results=[rng.choice([0, 1, 0x10000, 0xffffffff])], probe=probe),
                     0x47e52f: stub(0x47e52f, args=2, this=True, cleanup=8, probe=probe),
                     0x4809a7: stub(0x4809a7, args=0, this=True, probe=probe),
                     0x480a1d: stub(0x480a1d, args=0, this=True, probe=probe),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=probe),
                     0x423259: stub(0x423259, args=1, this=True, cleanup=4, results=[result_addr], probe=probe),
                     0x448d11: stub(0x448d11, args=4, this=True, cleanup=16, derefs=[(1, frame_len)], probe=probe)}
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            self.pair(2, 0x47ff0e, size, areas, stubs, g, ecx=od.region_va(0), stack=[], cleanup=0, self_name='self', iat=iat, tick=now,
                      executed=executed, word_args={0x47fa11: (0,), 0x47fb76: (0,), 0x47e582: (0, 1), 0x47ed96: (0,), 0x4fb2e3: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'bytes_54d5a4': ('consts', 0)}, scalars={})
        self.finish(0x47ff0e, size, executed)

    # ---- 0x4b64a9 ----
    def test_4b64a9_run_scene(self):
        """FL-22b: differential test of m4b64a9_run_scene (original 0x4b64a9): the three record states and all six arms of the jump table at 0x4b7029"""
        rng = random.Random(0x4b64a9)
        executed = set()
        size = 2944
        scalars = ['value_5bb1ca', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f', 'value_5bb5a3', 'value_583999', 'word_5bb599', 'word_5bb595',
                   'word_5c39ff', 'value_58318a', 'value_583186']
        TSLACK = 3   # entries of 0x4a bytes below 0x5d1591 in the fixture
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            profile = ['blk', 'move', 'finish', 'bound', 'go', 'due', 'go', 'finish', 'bound', 'move', 'step0', 'free', 'free', 'free'][n % 14]   # (the arms that random fixtures rarely reach)
            state = rng.choice([0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 0xffffffff, 0x80000000])
            if profile != 'free':
                state = 2 if profile == 'blk' else 1
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            # the nine-byte constants: "NO SOUND\0" in the original; here a random base, mostly the same in every slot
            base9 = bytes(rng.randbytes(9))
            slots = [base9 if rng.random() < 0.5 else bytes(rng.randbytes(9)) for _ in range(7)]
            consts = bytearray()
            for slot in slots:
                consts += slot + bytes(rng.randbytes(3))
            text = bytes(rng.randrange(1, 256) for _ in range(rng.choice([0, 1, 3, 4, 5, 22, 23, 30])))
            string = Area('string', 0x551b24, bytearray(text + b'\0' + bytes(rng.randbytes(1))), compare=False)
            rec = bytearray(rng.randbytes(0x400))
            sw = lambda off, v: struct.pack_into('<h', rec, off, v)
            small = lambda: rng.choice([-3, -1, 0, 1, 2, 3, 4, 5, 8, 0x270f, rng.randrange(-32768, 32768)])
            count = rng.choice([0, 1, 1, 2, 3, 3, 4, 5, 6, 16, 17, -1, -32768])
            sw(0x21, count)
            nonzero = lambda: rng.choice([1, 2, 3, 5, 7, -1, -3, 100, 0x7fff, -32768, rng.randrange(1, 32768), -rng.randrange(1, 32768)])
            div = nonzero()
            sw(0x25, div)
            sw(0x23, rng.choice([0, 1, 2, 3, 4, -1, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            sw(0x2d4, rng.choice([0, 1, 5, -3, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            sw(0x2d7, rng.choice([0, 1, 2, 3, 5, -2, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            sw(0x2fa, rng.choice([0, 1, 5, -3, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            sw(0x366, rng.choice([0, 1, 5, -3, 0x7fff, -32768, rng.randrange(-32768, 32768)]))
            rec[0x2d6] = rng.choice([0, 1, 1, 0xff])
            for off in (0x2d9, 0x345):
                pick = rng.choice(slots)   # (equal to the compared slot or not, depending on which slots happen to agree)
                rec[off:off + 9] = rng.choice([base9, pick, pick, bytes(rng.randbytes(9)), pick[:8] + bytes([pick[8] ^ 0x40]),
                                               bytes([pick[0] ^ 1]) + pick[1:]])
            for off in (0x376, 0x32a):   # the blocks of state 2
                sw(off, rng.choice([0x270f, 0x270f, 0, 5, -1, rng.randrange(-32768, 32768)]))
                sw(off + 0x14, rng.choice([1, 1, 0, 2, -1, 0x7fff]))
            for off in (0x38c, 0x340):
                sw(off, rng.choice([-1, -1, 0, 1, 5, 9, -3, 40, -16, 47]))
            flags = Area('flags', 0x585801 - 0x40, bytearray(rng.randbytes(0x100)))
            tab = Area('tab', 0x5d1591 - TSLACK * 0x4a, bytearray(rng.randbytes((TSLACK + 0x44) * 0x4a)))
            # the session object
            d = bytearray(rng.randbytes(0x300))
            put = lambda fmt, offset, value: struct.pack_into(fmt.replace('h', 'H') if fmt == '<h' else fmt, d, offset, value & 0xffff if fmt == '<h' else value)
            put('<h', 0x1e, rng.choice([index, index, index, index, (index + 1) % 5]))
            put('<h', 0x1c, rng.choice([0, 1, 5, 0x18, 0x3f, 0x40, 0x41, -1, -2, 7]))
            step = rng.choice([0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 0xffffffff, 0x80000000])
            put('<I', 0x274, step)
            f6334 = [rng.choice([0, 0, 1, 5, 0x10000, 0x80000000]) for _ in range(2)]
            put('<I', 0x20, rng.choice([0, 0, 0, 0x12345678, 0xffffffff]))
            d[0x229] = rng.choice([0, 1, 0xff])
            d[0x22a] = rng.choice([0, 0, 1, 0xff])
            limit4 = struct.unpack_from('<h', rec, 0x2d7)[0] * (struct.unpack_from('<h', rec, 0x23)[0] - 1) - 1   # the bound that step 4 compares +0x22b with
            d[0x22b] = rng.choice([0, 1, 2, 5, 0xfe, 0xff, 0x80, 0x7f, rng.randrange(256), (limit4 - 1) & 0xff, limit4 & 0xff, (limit4 + 1) & 0xff])
            put('<h', 0x22c, rng.choice([div, div, div, (div + 1) & 0xffff, 1, 0, 0x7fff, rng.randrange(-32768, 32768)]))
            put('<I', 0x22e, rng.choice([now, (now + 1) & 0xffffffff, (now - 1) & 0xffffffff, 0, 0xffffffff, rng.randrange(1 << 32)]))
            last = struct.unpack_from('<h', rec, 0x23)[0] - 1
            for i in range(16):   # the word tables: flags (+0x232) mostly non-zero, positions (+0x254) at or around the last one
                put('<h', 0x232 + 2 * i, rng.choice([0, 1, 1, 1, -1, 0x100, 0x4000, -32768, rng.randrange(-32768, 32768)]))
                put('<h', 0x254 + 2 * i, sword(rng.choice([last, last, last - 1, last + 1, 0, 1, rng.randrange(-32768, 32768)])))
            if profile == 'blk':   # state 2 with one block armed (the one at +0x376 or at +0x32a) and its word 1 or not
                base = (0x376, 0x32a)[(n // 10) % 2]
                d[0x229], d[0x22a] = ((1, rng.choice([0, 1])) if base == 0x376 else (0, 1))
                sw(base, rng.choice([5, -7, 0]))
                sw(base + 0x14, (1, 2, 1, -1)[(n // 20) % 4])
            elif profile == 'due':   # step 3 that is due (the deadline at or before the tick), +0x22a set and the name different from slot 2
                step = 3
                put('<I', 0x274, step)
                put('<I', 0x22e, rng.choice([now, (now - 1) & 0xffffffff, 0]))
                d[0x22a] = rng.choice([1, 0xff])
                rec[0x2d9:0x2e2] = rng.choice([bytes([slots[2][0] ^ 0x80]) + slots[2][1:], bytes(rng.randbytes(9)), slots[2][:8] + bytes([slots[2][8] ^ 1]), slots[3], slots[4], slots[2]])
            elif profile == 'step0':   # step 0 with the byte +0x22a set (the step becomes 4) or clear (0x4b642d is called), or a step above 5
                put('<I', 0x274, rng.choice([0, 0, 0, 6, 7, 0x80000000, 0xffffffff, 6]))   # (the steps above 5 do nothing)
                d[0x22a] = rng.choice([0, 1, 0xff])
            elif profile == 'move':   # step 2 with the items due to move (+0x22c equals the divisor) and the clearing of the flag words (+0x22a clear)
                step = 2
                put('<I', 0x274, step)
                d[0x22a] = 0
                put('<h', 0x22c, div)
                sw(0x21, rng.choice([1, 2, 3, 4]))
                for i in range(4):
                    put('<h', 0x232 + 2 * i, rng.choice([0, 1, 1, 0x100]))
            elif profile == 'bound':   # step 4 with the first position at the last one: +0x22b against its bound, one either side
                step = 4
                put('<I', 0x274, step)
                put('<h', 0x254, struct.unpack_from('<h', rec, 0x23)[0] - 1 if struct.unpack_from('<h', rec, 0x23)[0] > -32768 else 0)
                bound = struct.unpack_from('<h', rec, 0x2d7)[0] * (struct.unpack_from('<h', rec, 0x23)[0] - 1) - 1
                d[0x22b] = rng.choice([bound - 1, bound, bound + 1, bound ^ 0x80, bound]) & 0xff
            elif profile == 'finish':   # steps 1 and 5 that end by moving the record to its state 2 (the byte +0x2d6 clear)
                step = rng.choice([1, 5])
                put('<I', 0x274, step)
                rec[0x2d6] = 0
                if step == 1:
                    rec[0x345:0x34e] = consts[36:45]
                f6334 = [0, 0]
            if profile == 'go':   # step 1 or 5, the arm in which the record's byte +0x2d6 is set, 0x4f6334 answers 0 and the name differs
                step = rng.choice([1, 5])
                put('<I', 0x274, step)
                rec[0x345:0x34e] = consts[36:45]
                rec[0x2d6] = 1
                rec[0x2d9:0x2e2] = rng.choice([slots[4], slots[5], bytes([slots[4][0] ^ 0x80]) + slots[4][1:], bytes([slots[5][8] ^ 0x80]).join([slots[5][:8], b''])])
                f6334 = [0, 0]
            self_area = Area('self', od.region_va(0), d, image=False)
            idx = struct.unpack_from('<h', d, 0x1c)[0]
            idx_result = rng.choice([0, 1, 5, 0x18, 0x3f, 0x40, 0x41, -1, -2, 7])   # what 0x4d39f9 returns (the low word)
            slot_probe_at = max(0, (idx_result + TSLACK) * 0x4a) if state == 0 else max(0, (idx + TSLACK) * 0x4a)
            g = self.globals_(rng, *scalars)
            P = [('self', 0, 0x300), ('tab', slot_probe_at, 0x4a), ('records', 0, len(records.data)), ('g:value_5bb1ca', 0, 4), ('g:value_5bb57b', 0, 4),
                 ('g:word_5bb599', 0, 2), ('g:word_5c39ff', 0, 2), ('flags', 0x20, 0x40)]
            P2 = [('g:value_5bb1ca', 0, 4), ('g:value_5bb57b', 0, 4), ('g:value_5bb59b', 0, 4), ('g:value_5bb59f', 0, 4), ('g:value_5bb5a3', 0, 4),
                  ('g:value_583999', 0, 4), ('g:word_5bb599', 0, 2), ('g:word_5bb595', 0, 2)]
            P3 = [('g:word_5c39ff', 0, 2), ('flags', 0, 0x100), ('g:value_5bb1ca', 0, 4), ('g:value_583999', 0, 4), ('self', 0, 0x300)]
            place_writes = [[(3, 0, 4, rng.randrange(1 << 32)), (3, 4, 4, rng.randrange(1 << 32)), (3, 8, 4, rng.randrange(1 << 32)),
                             (3, 0xc, 4, rng.randrange(1 << 32))] for _ in range(40)]
            stubs = {0x4e8d96: stub(0x4e8d96, args=0, this=True, probe=P),
                     0x4b6355: stub(0x4b6355, args=4, this=True, cleanup=16, writes=place_writes, probe=P),
                     0x4d39f9: stub(0x4d39f9, args=0, results=[(rng.randrange(0x10000) << 16) | (idx_result & 0xffff)], probe=P),
                     0x4c2790: stub(0x4c2790, args=4, this=True, cleanup=16, results=[rng.choice([0, 0xdeadbeef, 0x12345678])], probe=P),
                     0x4fb77a: stub(0x4fb77a, args=1, this=True, cleanup=4, probe=P),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=P),
                     0x4f6334: stub(0x4f6334, args=1, this=True, cleanup=4, results=f6334, probe=P),
                     0x4fba69: stub(0x4fba69, args=1, this=True, cleanup=4, probe=P),
                     0x4b642d: stub(0x4b642d, args=0, this=True, probe=P),
                     0x42ba3a: stub(0x42ba3a, args=1, probe=P3),
                     0x4b5bc8: stub(0x4b5bc8, args=0, this=True, probe=P2)}
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            # (0x4f6334 is called twice in step 5: two scripted results)
            stack = [(rng.randrange(0x10000) << 16) | (index & 0xffff)]
            self.pair(3, 0x4b64a9, size, [records, Area('rec', od.region_va(1), rec, image=False), self_area, tab, flags, string,
                                          Area('consts', 0x551b5c, consts)], stubs, g, ecx=od.region_va(0), stack=stack, cleanup=4,
                      args=(index,), self_name='self', iat=iat, tick=now, executed=executed, word_args={0x4b6355: (0, 1, 2), 0x4fb2e3: (0,), 0x42ba3a: (0,)},
                      pointers={'records_5bb5e5': ('records', rslack), 'flags_585801': ('flags', 0x40), 'table_5d1591': ('tab', TSLACK * 0x4a),
                                'string_551b24': ('string', 0), 'bytes_551b5c': ('consts', 0)})
        self.finish(0x4b64a9, size, executed)

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
