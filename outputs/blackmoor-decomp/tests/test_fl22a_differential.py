"""FL-22 (batch a) differential tests: the original GAME.EXE bytes (Unicorn) against src/original_methods_fl22a.c on the same random
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
import hashlib
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
# per original address: scenarios run, ordered host calls compared, bytes of memory compared, globals compared, a digest of every fixture
STATS = {}
COVERAGE = {}
TICK_SLOT = 0x52a23c

CTYPES = {'float': ctypes.c_float, 'double': ctypes.c_double, 'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32,
          'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl22aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl22a.h').read_text()
    body = re.search(r'typedef struct Fl22aWorld \{(.*?)\} Fl22aWorld;', text, re.S).group(1)
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
class Fl22aDifferential(DiffBase):
    SHIM = PROJECT / 'tests/fl22a_differential_shim.c'
    KERNELS = ['original_methods_fl22a.c']

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.lib.shim_calls.restype = ctypes.POINTER(ShimCall20)
        cls.lib.shim_world_size.restype = ctypes.c_size_t
        cls.lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
        cls.lib.shim_fl22a.argtypes = [ctypes.c_int, ctypes.c_void_p] + [ctypes.c_uint64] * 4 + [ctypes.c_void_p, ctypes.c_void_p]
        assert cls.lib.shim_world_size() == ctypes.sizeof(World), 'the World mirror does not match Fl22aWorld'

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
        stats = STATS.setdefault(va, {'scenarios': 0, 'calls_compared': 0, 'memory_bytes_compared': 0, 'globals_compared': 0, 'digest': hashlib.sha256()})
        stats['scenarios'] += 1
        stats['digest'].update(repr((va, ecx, list(stack), g, sorted((a.name, a.va, bytes(a.data)) for a in areas),
                                     sorted((hex(k) if isinstance(k, int) else k, v.results, v.result) for k, v in {**stubs, **iat}.items()))).encode())
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
        self.lib.shim_fl22a(fn, self_ptr, *native_args, ctypes.byref(sw), ctypes.byref(result))
        for a in areas:
            if a.compare:
                nb, ob = bytes(by_name[a.name]), orig.memory[a.name]
                if nb != ob:
                    diff = [i for i in range(len(nb)) if nb[i] != ob[i]]
                    self.fail('%s: first differing offsets %s native %s original %s' % (a.name, [hex(i) for i in diff[:8]], [nb[i] for i in diff[:8]], [ob[i] for i in diff[:8]]))
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
        stats['calls_compared'] += len(expected)
        stats['memory_bytes_compared'] += sum(len(a.data) for a in areas if a.compare)
        stats['globals_compared'] += len(g)
        if executed is not None:
            executed |= orig.executed
        if tick is not None and TICK_SLOT in iat:
            pass
        return orig, sw

    def finish(self, va, size, executed):
        wanted = od.instruction_addresses(va, size)
        COVERAGE[va] = (len(wanted & executed), len(wanted))
        missing = sorted(wanted - executed)
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

    # ---- 0x463392 ----
    def test_463392_step_scene(self):
        """FL-22a: differential test of m463392_step_scene (original 0x463392)"""
        self.run_463392(0x463392, False)

    def test_463392_scripted_stubs(self):
        """FL-22a: differential test of m463392_step_scene with 0x461d82 / 0x4619be stubs that store [self+0x57], [self+0x39], [self+0x5b] and
        [self+0x5d] at each call (the port reads them where the original reads them, not once before the calls)"""
        self.run_463392(0x463393, True)

    # the nine-byte patterns of the image: offset in the 0x54b164 block -> offset of the record bytes that the original compares with it
    PATTERNS_463392 = {0x40: 0x24f, 0x4c: 0x280, 0x58: 0x2b1, 0x64: 0x280, 0x70: 0x2b1, 0x7c: 0x2fd, 0x88: 0x24f, 0x94: 0x280, 0xa0: 0x2b1}

    def run_463392(self, seed, scripted):
        rng = random.Random(seed)
        executed = set()
        # the original's body ends with its switch table (five dwords at 0x463aec): only the code before it is instructions
        size = 0x463aec - 0x463392
        tslack = 0x4a
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            now = rng.choice([0, 3, 0xfffffffe, 1000, rng.randrange(1 << 32)])
            state = rng.choice([0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 0xffffffff, 5])
            # (no slack record below the table: it would overlap the globals 0x5bb57b ... 0x5bb5a3 that the function writes)
            records, rslack = self.records_area(rng, nrec=5, slack=0)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            struct.pack_into('<I', records.data, rslack + index * 0x8d + 0x4d, state)
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, rng.choice([0, 1, 2, 3]))
            struct.pack_into('<I', this.data, 0x24, rng.choice([0, 1, 2, 3, 4, 5, 0xffffffff, 0x80000000, 1, 2, 3, 4, 0x100000001 & 0xffffffff]))
            struct.pack_into('<I', this.data, 0x20, rng.choice([0, 0, 0x1234, 0xffffffff]))
            struct.pack_into('<I', this.data, 0x43, rng.choice([0, 0, 1, 0xffffffff, 0x100, 0x1000000]))
            struct.pack_into('<I', this.data, 0x47, rng.choice([0, 0, 1, 0xffffffff, 0x100, 0x1000000]))
            struct.pack_into('<I', this.data, 0x4b, (now + rng.choice([-5, -1, 0, 1, 5, 0x7fffffff, 0x80000000, 0x80000001])) & 0xffffffff)
            rec = bytearray(rng.randbytes(0x400))
            rec[0x21] = rng.choice([0, 0, 1, 0xff, 0x80])
            struct.pack_into('<h', rec, 0x2fb, rng.choice([0, 1, 5, -1, -3, 40, 4000, -32768]))
            struct.pack_into('<h', rec, 0x31e, rng.choice([0, 1, 5, -1, 0x7fff, -32768, 300]))
            struct.pack_into('<h', rec, 0x32e, rng.choice([0x270f, 0x270f, 0x260f, 0x2710, 0x270e, 0x2f0f, 0, -1, 5]))
            struct.pack_into('<h', rec, 0x2e2, rng.choice([0x270f, 0x270f, 0x260f, 0x2710, 0x270e, 0x2f0f, 0, -1, 5]))
            for base in (0x32e, 0x2e2):   # the two groups of 0x270f / flag / table words
                struct.pack_into('<h', rec, base + 0x14, rng.choice([1, 1, 0, 2, -1, 0x101]))
                struct.pack_into('<h', rec, base + 0x16, rng.choice([-1, -1, -3, -2, 0, 1, 5, 9]))
            # the data block of the image: a string at its start, the nine bytes that the record bytes are compared with equal or one byte off
            data = bytearray(rng.randbytes(0xac))
            sname = bytes(rng.choice(b'abcdefgh') for _ in range(rng.randrange(0, 20))) + b'\0'
            data[0:len(sname)] = sname
            for off, recoff in self.PATTERNS_463392.items():
                nine = bytes(rec[recoff:recoff + 9])
                if rng.random() < 0.55:
                    data[off:off + 9] = nine
                else:
                    pat = bytearray(nine)
                    pat[rng.choice([8, 8, *range(9)])] ^= rng.choice([1, 0x80])
                    if rng.random() < 0.3:   # (an embedded zero: it must not end the compare)
                        z = rng.randrange(1, 8)
                        pat[z] = 0
                        rec[recoff + z] = 0
                        pat[rng.randrange(z + 1, 9)] ^= 1
                    data[off:off + 9] = pat
            flags = Area('flags', 0x585801 - 0x10, bytearray(rng.randbytes(0x50)))
            t5d = Area('table', 0x5d1591 - tslack, bytearray(rng.randbytes(tslack + 6 * 0x4a)))
            dat = Area('d54b164', 0x54b164, data, compare=False)
            g = self.globals_(rng, 'value_5bb1ca', 'value_583999', 'value_5bb57b', 'value_5bb59b', 'value_5bb59f', 'value_5bb5a3', 'word_5bb599',
                              'word_5bb595', 'word_5c39ff')
            iat = {TICK_SLOT: od.Stub('tick', result=now)}
            slot = rng.choice([-1, 0, 1, 2, 3])
            idx_word = slot | (rng.randrange(0x10000) << 16)
            sidx = slot if state == 0 else 0
            rstate = [('records', rslack + index * 0x8d + 0x4d, 4)]
            selfp = [('self', 0x24, 4), ('self', 0x4b, 4)]
            w16 = lambda: rng.randrange(0x10000)
            writes_461d82 = writes_4619be = None
            if scripted:
                writes_461d82 = [[(-1, 0x57, 2, w16()), (-1, 0x39, 2, w16()), (-1, 0x5b, 2, w16()), (-1, 0x5d, 2, w16())]]
                writes_4619be = [[(-1, 0x39, 2, w16()), (-1, 0x5b, 2, w16()), (-1, 0x5d, 2, w16())]]
            stubs = {0x4618df: stub(0x4618df, this=True, probe=[('self', 0x1e, 2), ('self', 0x3f, 4), ('g:value_5bb1ca', 0, 4)]),
                     0x4e8d96: stub(0x4e8d96, this=True, probe=[('self', 0x1e, 2), ('self', 0x3f, 4), ('g:value_5bb1ca', 0, 4)]),
                     0x462577: stub(0x462577, this=True, probe=[('self', 0x1e, 2), ('self', 0x3f, 4), ('self', 0x4f, 8), ('g:value_5bb1ca', 0, 4)]),
                     0x4d39f9: stub(0x4d39f9, results=[idx_word], probe=[('self', 0x28, 1), ('self', 0x4f, 8)]),
                     0x4c2790: stub(0x4c2790, args=4, this=True, cleanup=0x10, results=[rng.randrange(1 << 32)],
                                    probe=[('self', 0x1c, 2), ('self', 0x20, 4), ('table', tslack + sidx * 0x4a, 0x4a)]),
                     0x4fb77a: stub(0x4fb77a, args=1, this=True, cleanup=4,
                                    probe=[('self', 0x1c, 4), ('self', 0x20, 4), ('self', 0x24, 4), ('table', tslack + sidx * 0x4a, 0x4a)] + rstate),
                     0x4632bf: stub(0x4632bf, this=True, probe=[('self', 0x3b, 4), ('self', 0x24, 4)]),
                     0x461d82: stub(0x461d82, this=True, results=[rng.choice([0, 1, 1, 1, 0x100, 0xffffffff])], writes=writes_461d82,
                                    probe=[('self', 0x24, 4), ('self', 0x57, 2), ('self', 0x39, 2)]),
                     0x4619be: stub(0x4619be, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 0, 1, 0x100])], writes=writes_4619be,
                                    probe=[('self', 0x24, 4)]),
                     0x461d4b: stub(0x461d4b, args=3, this=True, cleanup=12, results=[rng.choice([0, 1, 0x100, 0xffffffff])],
                                    probe=[('self', 0x24, 4)]),
                     0x4fb2e3: stub(0x4fb2e3, args=1, this=True, cleanup=4, probe=selfp + rstate),
                     0x4f6334: stub(0x4f6334, args=1, this=True, cleanup=4, results=[rng.choice([0, 0, 0, 1, 0x100, 0xffffffff])], probe=selfp + rstate),
                     0x4fba69: stub(0x4fba69, args=1, this=True, cleanup=4, probe=selfp + rstate + [('g:value_5bb1ca', 0, 4)]),
                     0x42ba3a: stub(0x42ba3a, args=1, probe=[('g:value_5bb1ca', 0, 4), ('g:value_583999', 0, 4), ('g:value_5bb57b', 0, 4),
                                                              ('g:word_5bb599', 0, 2), ('g:value_5bb59b', 0, 4), ('flags', 0, 0x50)]),
                     0x461862: stub(0x461862, this=True, probe=[('g:value_5bb1ca', 0, 4), ('g:value_583999', 0, 4), ('flags', 0, 0x50)])}
            high = rng.randrange(0x10000) << 16
            self.pair(1, 0x463392, size, [this, records, Area('rec', od.region_va(1), rec, image=False, compare=False), flags, t5d, dat], stubs, g,
                      ecx=this.va, stack=[high | (index & 0xffff)], cleanup=4, args=(index,), self_name='self', executed=executed, iat=iat, tick=now,
                      word_args={0x42ba3a: (0,), 0x4fb2e3: (0,), 0x4619be: (0,), 0x461d4b: (0, 1, 2)},
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1591': ('table', tslack), 'data_54b164': ('d54b164', 0),
                                'flags_585801': ('flags', 0x10)})
        if not scripted:
            self.finish(0x463392, size, executed)

    # ---- 0x461d82 ----
    def test_461d82_move_step(self):
        """FL-22a: differential test of m461d82_move_step (original 0x461d82)"""
        self.run_461d82(0x461d82, False)

    def test_461d82_scripted_stub(self):
        """FL-22a: differential test of m461d82_move_step with a 0x462b84 stub that stores [self+0x5b], [self+0x5d] and [self+0x39] at its call
        (the port re-reads the row, the column and the word after the call, as the original does)"""
        self.run_461d82(0x461d83, True)

    def run_461d82(self, seed, scripted):
        rng = random.Random(seed)
        executed = set()
        # the original's body ends with its switch table (four dwords at 0x462567): only the code before it is instructions
        size = 0x462567 - 0x461d82
        for n in range(SCENARIOS):
            index = rng.choice([0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=5, slack=1)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            this = Area('self', od.region_va(0), bytearray(rng.randbytes(0x100)), image=False)
            struct.pack_into('<h', this.data, 0x1e, index)
            divisor = rng.choice([1, 2, 3, 4, 5, 7, -1, -2, -3, 0x7fff, -32768, 10])
            rec = bytearray(rng.randbytes(0x300))
            struct.pack_into('<h', rec, 0x24a, divisor)
            row = rng.choice([-1, 0, 1, 2])
            col = rng.choice([-1, 0, 1, 2])
            struct.pack_into('<h', this.data, 0x5b, row)
            struct.pack_into('<h', this.data, 0x5d, col)
            struct.pack_into('<h', this.data, 0x57, rng.choice([0x10, 0x11, 0x12, 0x13, 0x10, 0x11, 0x12, 0x13, 0x0f, 0x14, 0, -1, 0x7fff, -32768, -0x7ff0]))
            dividend = lambda: rng.choice([0, 1, -1, 7, -7, 1000, -1000, 0x7fffffff, rng.randrange(-5000, 5000), rng.randrange(-(1 << 31) + 1, 1 << 31),
                                           divisor * rng.randrange(-30, 30), divisor * 100 + 1, 0x7fffffff // max(1, abs(divisor))])
            for off in (0x4f, 0x53):
                value = dividend()
                if divisor == -1 and value == -(1 << 31):
                    value = 5
                struct.pack_into('<i', this.data, off, value)
            # the move counter [self+0x59]: one before the divisor (the cell completes) or something else
            struct.pack_into('<h', this.data, 0x59, sword(divisor - 1) if rng.random() < 0.55 else sword(rng.choice([0, 1, -1, 0x7fff, divisor, divisor - 2])))
            struct.pack_into('<h', this.data, 0x39, rng.randrange(-32768, 32768))
            cells = bytearray(rng.randbytes(0x780))
            for r in range(-2, 4):
                for c in range(-2, 4):   # the word cell+0x24 is zero in about half of the cells
                    if rng.random() < 0.5:
                        struct.pack_into('<h', cells, 0x2d0 + r * 0x140 + c * 0x28 + 0x24, 0)
            cell_area = Area('cells', 0x594db5 - 0x2d0, cells)
            stubs_writes = None
            if scripted:
                stubs_writes = [[(-1, 0x5b, 2, rng.choice([-1, 0, 1, 2])), (-1, 0x5d, 2, rng.choice([-1, 0, 1, 2])), (-1, 0x39, 2, rng.randrange(0x10000))]]

            def cell_probe(r, c):
                return ('cells', 0x2d0 + r * 0x140 + c * 0x28, 0x28)
            stubs = {0x462b84: stub(0x462b84, args=4, this=True, cleanup=0x10, writes=stubs_writes,
                                    probe=[cell_probe(row, col), ('self', 0x39, 2), ('self', 0x3b, 4), ('self', 0x59, 2), ('self', 0x5b, 4)])}
            self.pair(2, 0x461d82, size, [this, records, Area('rec', od.region_va(1), rec, image=False, compare=False), cell_area], stubs, {},
                      ecx=this.va, stack=[], cleanup=0, args=(), self_name='self', executed=executed, ret_mask=0xffffffff,
                      word_args={0x462b84: (0, 1)},
                      pointers={'records_5bb5e5': ('records', rslack), 'cells_594db5': ('cells', 0x2d0)})
        if not scripted:
            self.finish(0x461d82, size, executed)

    # ---- 0x45d2c6 ----
    def test_45d2c6_render(self):
        """FL-22a: differential test of m45d2c6_render (original 0x45d2c6)"""
        self.run_45d2c6(0x45d2c6, False)

    def test_45d2c6_boundaries(self):
        """FL-22a: differential test of m45d2c6_render with the loop limits and the selector words on their boundaries"""
        self.run_45d2c6(0x45d2c7, True)

    def run_45d2c6(self, seed, boundary):
        rng = random.Random(seed)
        executed = set()
        size = 0x45db6a - 0x45d2c6   # (the bytes after the ret are padding)
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=5, slack=1)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            rec = bytearray(rng.randbytes(0x700))
            struct.pack_into('<h', rec, 0x23, rng.choice([0, 1, 2, 3, 4, 5, 6, -1, 7] if not boundary else [0, 1, 2, 3, 4, 5]))
            t5d = Area('t5d1599', 0x5d1599 - 0x4a, bytearray(rng.randbytes(0x4a * 5)), compare=False)
            small = [0, 1, 2, 3, 4, -1]
            word_choice = [0, 1, 2, 3, -1, 0x100]
            dword_choice = [0, 0, 1, 0xffffffff, 0x10000, 0x100, 0x1000000]
            g = {'word_624752': index, 'word_624750': rng.choice([-1, 0, 1, 2, 3]), 'value_5cf665': rng.randrange(1 << 32), 'value_5d15e3': rng.randrange(1 << 32),
                 'word_6247ec': rng.choice(small), 'word_6247ea': rng.choice(small), 'word_6247ee': rng.choice(word_choice),
                 'value_624892': rng.choice(dword_choice), 'value_62475c': rng.choice(dword_choice), 'value_624896': rng.choice(dword_choice),
                 'value_624758': rng.choice([6, 6, 9, 9, 0, 5, 7, 0xffffffff, 0x100, 0x100000006 & 0xffffffff]), 'value_624766': rng.choice(dword_choice),
                 'word_624760': rng.choice([-2, -1, 0, 1, 2, 3]), 'word_624890': rng.choice([0, 1, 2, -1, 0x100]),
                 'value_624818': rng.choice(dword_choice), 'value_624848': rng.choice(dword_choice)}
            for name in ('value_624840', 'value_624844', 'value_62484c', 'value_624810', 'value_624814', 'value_62481c'):
                g[name] = rng.randrange(1 << 32)
            if boundary:   # the selectors sit on the values that the compares test
                g['word_6247ee'] = rng.choice([0, 1, 2, 1, 2, 0, 3])
                g['value_624758'] = rng.choice([6, 9, 6, 9, 5])
                g['word_624890'] = rng.choice([0, 1, 1, 0, 2])
                g['value_624896'] = rng.choice([0, 0, 1])
                g['word_6247ec'] = rng.choice([0, 1, 2, 3])
                g['word_6247ea'] = rng.choice([0, 1, 2, 3])
            # (the table at 0x5d1599 holds the global 0x5d15e3 at its entry 1: the area bytes are the global's)
            struct.pack_into('<I', t5d.data, 0x5d15e3 - t5d.va, g['value_5d15e3'])
            # B fills the rectangle (arg 1) with four dwords at each call
            writes_b = [[(1, 4 * k, 4, rng.randrange(1 << 32)) for k in range(4)] for _ in range(60)]
            probes = [('g:value_624848', 0, 4), ('g:value_62475c', 0, 4), ('g:value_624818', 0, 4), ('g:value_624840', 0, 4), ('g:value_624810', 0, 4)]
            stubs = {0x45b568: stub(0x45b568, args=2, this=True, cleanup=8, writes=writes_b),
                     0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=0x14, derefs=[(3, 16)], probe=probes),
                     0x4c5d4b: stub(0x4c5d4b, args=5, this=True, cleanup=0x14, derefs=[(3, 16)], probe=probes)}
            self.pair(3, 0x45d2c6, size, [records, Area('rec', od.region_va(1), rec, image=False, compare=False), t5d], stubs, g,
                      ecx=0, stack=[], cleanup=0, args=(), executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'table_5d1599': ('t5d1599', 0x4a)})
        if not boundary:
            self.finish(0x45d2c6, size, executed)

    # ---- 0x4778df ----
    def test_4778df_render(self):
        """FL-22a: differential test of m4778df_render (original 0x4778df)"""
        self.run_4778df(0x4778df, False)

    def test_4778df_scripted(self):
        """FL-22a: differential test of m4778df_render with distinct callee results for 0x4d3836 (the word added to 0xd) and scripted text for 0x50ca3e"""
        self.run_4778df(0x4778e0, True)

    def run_4778df(self, seed, targeted):
        rng = random.Random(seed)
        executed = set()
        size = 0x4780d2 - 0x4778df   # (the bytes after the ret are padding)
        for n in range(SCENARIOS):
            index = rng.choice([-1, 0, 1, 2, 3])
            records, rslack = self.records_area(rng, nrec=5, slack=1)
            struct.pack_into('<I', records.data, rslack + index * 0x8d, od.region_va(1))
            rec = bytearray(rng.randbytes(0x700))
            struct.pack_into('<h', rec, 0x42, rng.choice([0, 1, 2, 3, -1, 3]))
            struct.pack_into('<h', rec, 0x44, rng.choice([0, 1, 2, 3, 4, -2, 4]))
            rec[0x238] = rng.choice([0, 1, 0xff, 1])
            rec[0x63d] = rng.choice([0, 1, 0xff, 1])
            rec[0x23e] = rng.randrange(256)
            struct.pack_into('<h', rec, 0x23a, rng.choice([-1, 0, 1, 3, 0x7f, -32768, 0x7fff]))
            struct.pack_into('<h', rec, 0x63e, rng.choice([-1, 0, 1, 5, 0x7fff, -32768]))
            # the table of the entries (rows of 0xc8, entries of 0x14): the first two bytes are often zero or small
            tbl = bytearray(rng.randbytes(0x300))
            for off in range(0, 0x300 - 2, 0x14):
                tbl[off] = rng.choice([0, 0, 1, 0xff, 5])
                tbl[off + 1] = rng.choice([0, 0, 1, 0xff, 3])
                if rng.random() < 0.5:
                    struct.pack_into('<h', tbl, off + 2, rng.choice([0, 1, 2, -1, -3, 0x7ff, -0x800, 0x1234]))
            t5d = Area('t5d1599', 0x5d1599 - 0x4a, bytearray(rng.randbytes(0x4a * 5)), compare=False)
            d5a = Area('d5a0549', 0x5a0549, bytearray(rng.randbytes(20)), compare=False)
            ox = rng.choice([0, 7, 0xfffffff9, 0x7fffffff, 0x80000000, rng.randrange(1 << 32)])
            oy = rng.choice([0, 7, 0xfffffff9, 0x7fffffff, 0x80000000, rng.randrange(1 << 32)])
            odata = bytearray(rng.randbytes(0x40))
            struct.pack_into('<I', odata, 6, ox)
            struct.pack_into('<I', odata, 0xa, oy)
            flagsdata = bytearray(rng.randbytes(0xc0))
            flag_choices = [0, 1, 0xff, 1, 2]
            gb = {n_: rng.choice(flag_choices) for n_ in ('byte_6237a2', 'byte_6237a3', 'byte_6237a4', 'byte_6237a5', 'byte_62383a', 'byte_62383b')}
            for field in gb:   # the bytes of the image are the ones of the region that is handed to the callee
                flagsdata[GLOBALS[field][0] - 0x6237a0] = gb[field]
            bytes_pair = {}
            for a_name, b_name in (('byte_6237f8', 'byte_63a88c'), ('byte_623819', 'byte_63a894')):
                a_v = rng.randrange(256)
                gb[a_name] = a_v
                gb[b_name] = a_v if rng.random() < 0.5 else rng.randrange(256)
                flagsdata[GLOBALS[a_name][0] - 0x6237a0] = a_v
            gb['byte_63a890'] = rec[0x23e] if rng.random() < 0.5 else rng.randrange(256)
            g = {**gb, 'word_622fc4': index, 'word_622fc2': rng.choice([-1, 0, 1, 2, 3]), 'value_5cf665': rng.randrange(1 << 32), 'value_5d15e3': rng.randrange(1 << 32),
                 'value_622fce': rng.choice([6, 6, 6, 0, 5, 7, 0xffffffff, 0x100, 6]), 'value_622fca': rng.randrange(1 << 32),
                 'origin_x_583186': ox, 'origin_y_58318a': oy}
            # (the table at 0x5d1599 holds the global 0x5d15e3 at its entry 1: the area bytes are the global's)
            struct.pack_into('<I', t5d.data, 0x5d15e3 - t5d.va, g['value_5d15e3'])
            if rng.random() < 0.15:
                g['value_622fce'] = 6
                rec[0x42:0x44] = b'\0\0'
            stubs = {0x4c5377: stub(0x4c5377, args=5, this=True, cleanup=0x14, derefs=[(3, 16)],
                                    probe=[('g:byte_6237a4', 0, 1), ('g:byte_6237a5', 0, 1), ('g:byte_6237a3', 0, 1), ('g:byte_62383b', 0, 1)]),
                     0x475cc4: stub(0x475cc4, args=2, this=True, cleanup=8, derefs=[(0, 4), (1, 16)]),
                     0x4d3836: stub(0x4d3836, args=3, results=[rng.choice([0, 1, 0x10, 0xffff, 0x8000, 0x7ff3, rng.randrange(1 << 32), 0xfffffff3])]),
                     0x50ca3e: stub(0x50ca3e, args=3, writes=[[(0, 0, 4, rng.randrange(1 << 32))] for _ in range(6)])}
            self.pair(4, 0x4778df, size, [records, Area('rec', od.region_va(1), rec, image=False, compare=False), Area('t622fd2', 0x622fd2, tbl, compare=False), t5d, d5a,
                                          Area('o583180', 0x583180, odata, compare=False), Area('f6237a0', 0x6237a0, flagsdata, compare=False)], stubs, g,
                      ecx=0, stack=[], cleanup=0, args=(), executed=executed,
                      pointers={'records_5bb5e5': ('records', rslack), 'table_622fd2': ('t622fd2', 0), 'table_5d1599': ('t5d1599', 0x4a), 'dwords_5a0549': ('d5a0549', 0)})
        if not targeted:
            self.finish(0x4778df, size, executed)

    # TESTS-END


if __name__ == '__main__':
    unittest.main()
