"""FL-30 (batch c): the fixtures shared by tests/test_fl30c_differential.py and tests/fl30c_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the
vtables, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The
scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees, the vtable entries and the import slots are recording
stubs (OS or host boundaries); nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that
changes `self` or a local of the caller: call number, argument or absolute address, offset, size, value or a byte string) so that a
function's re-reads after a call are exercised. Two more host/OS boundaries are modelled outside the function: the thread information block
behind fs and the x87 control word (neither is used by this batch's functions; kept from the shared harness). It returns the result, the normalised ordered call log and a
digest of the ordered calls, the return value and the memory read back.
"""
import ctypes
import hashlib
from dataclasses import dataclass
from pathlib import Path
import re
import struct
import sys
from types import SimpleNamespace

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od

PROJECT = Path(__file__).resolve().parents[1]
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}
TIB, GDT = 0x7d000000, 0x7d010000


def parse_world():
    """The fields of Fl30cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl30c.h').read_text()
    body = re.search(r'typedef struct Fl30cWorld \{(.*?)\} Fl30cWorld;', text, re.S).group(1)
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


GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t, p in WORLD_FIELDS if not p}
FMT = {1: '<B', 2: '<H', 4: '<I'}


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


class Original30(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)]) and carry
    scripted writes (stub.writes = [(call number, argument or -1, offset, size, value)]: argument k = the pointer at stack argument k, -1 = the
    absolute address `offset`; a bytes value is written as it is). Records every (previous instruction, next instruction) pair, so that the
    direction of every jump is known. `seh` (the chain head) maps a thread information block behind fs (the OS boundary of the structured
    exception chain); `fpcw` sets the x87 control word."""

    def __init__(self, image_patches=(), regions=None, stubs=None, iat_slots=None, seh=None, fpcw=None):
        super().__init__(image_patches, regions, stubs, iat_slots)
        uc = self.uc
        self.seh = seh
        if seh is not None:
            from unicorn import x86_const as X
            uc.mem_map(TIB, 0x1000)
            uc.mem_map(GDT, 0x1000)
            uc.mem_write(TIB, struct.pack('<I', seh))

            def seg(base, limit, access, flags):
                return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access, ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
            uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc) + seg(TIB, 0xfff, 0x93, 0x4))
            uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
            uc.reg_write(X.UC_X86_REG_CS, 0x08)
            for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
                uc.reg_write(reg, 0x10)
            uc.reg_write(X.UC_X86_REG_FS, 0x18)
        if fpcw is not None:
            from unicorn import x86_const as X
            uc.reg_write(X.UC_X86_REG_FPCW, fpcw)

    def _count(self, uc, address, size, user):
        super()._count(uc, address, size, user)
        if not hasattr(self, 'edges'):
            self.edges = set()
        if getattr(self, 'last', None) is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        if not hasattr(self, '_calln'):
            self._calln = {}
        number = self._calln.get(address, 0)
        self._calln[address] = number + 1
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        derefs = getattr(stub, 'derefs', None)
        deref_data = ()
        esp = uc.reg_read(self._r['ESP'])
        if derefs:
            pointers = [(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n) for arg, n in derefs]
            # only a pointer to a local of the function under test (the stack) is read; any other value is logged by the arguments alone
            deref_data = tuple(bytes(uc.mem_read(at, n)) if od.STACK_BASE <= at < od.STACK_BASE + od.STACK_SIZE else b'' for at, n in pointers)
        for call, arg, offset, size_, value in getattr(stub, 'writes', ()):
            if call == number:
                at = offset if arg < 0 else struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0] + offset
                uc.mem_write(at, value if isinstance(value, bytes) else struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1)))
        super()._stub_hook(uc, address, size, user)
        if deref_data:
            self.calls[before] = self.calls[before] + deref_data
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# shapes of the callees: (stack arguments, thiscall, bytes the callee pops)
CDECL = lambda n: (n, False, 0)
STDCALL = lambda n: (n, False, 4 * n)
THISCALL = lambda n: (n, True, 4 * n)
WORD_ARGS = {}
TRIM = {}     # callee -> function(logged stack dwords) -> the dwords that the call really passes (a stub that serves calls of two arities logs the larger count)
DBG_VALUES = (0, 1, 0x8000, 0x100, 0xffff)      # the debug word 0x63a4cd: every non-zero value is on


def stub(callee, shape, probe=None, results=None, writes=None, derefs=None):
    nargs, this, cleanup = shape
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    s.writes = writes or []
    s.derefs = derefs or []
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)


def debug_areas(rng, dbg):
    """The debug word 0x63a4cd (a global patched into the image) and the two bytes behind it, which a dword read would see."""
    return {'word_63a4cd': dbg}, [Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]


def make(key, areas, stubs, g, stack, args, profile, iat=None, ecx=None, pointers=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) if ecx is None else ecx, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None)


def run_original(sc):
    """Runs the original bytes on the scenario. Returns (Result, normalised calls, digest of calls, return value and memory read back)."""
    image_patches = [(a.va, a.data) for a in sc.areas if a.image]
    for field, value in sc.g.items():
        address, size_ = GLOBALS[field]
        image_patches.append((address, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1))))
    regions = {a.name: (a.va, a.data) for a in sc.areas if not a.image}
    read = {a.name: (a.va, len(a.data)) for a in sc.areas if a.compare}
    for field in sc.g:
        read['g:' + field] = GLOBALS[field]
    if sc.seh is not None:
        read['tib'] = (TIB, 4)
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original30(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh, fpcw=SPECS[sc.key].get('fpcw'))
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None:
        if orig.memory.pop('tib') != struct.pack('<I', sc.seh):
            raise AssertionError('the structured-exception chain at fs:[0] was not restored')
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the constructor did not return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    if SPECS[sc.key].get('ret16'):
        h.update(struct.pack('<H', orig.eax & 0xffff))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


def conditional_edges(va, size):
    """[(jcc address, mnemonic, taken-edge target, fall-through address)] of every conditional jump of the original function (loop and
    jecxz forms included), by linear disassembly of the code part."""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    out = []
    for i in md.disasm(pe.image[off:off + size], va):
        if i.mnemonic.startswith('j') and i.mnemonic != 'jmp' or i.mnemonic.startswith('loop'):
            out.append((i.address, i.mnemonic, int(i.op_str, 16), i.address + i.size))
    return out


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests)
UNTAKEN_ALLOWED = {}


def untaken_edges(key, edges):
    """[(jcc address, 'taken' or 'fall-through')] of the conditional jumps of the function `key` that none of `edges` (the union of the
    (instruction, next instruction) pairs of the scenarios) went the way of."""
    sp = SPECS[key]
    out = []
    for address, _, target, after in conditional_edges(sp['va'], sp.get('code', sp['size'])):
        if (address, target) not in edges:
            out.append((address, 'taken'))
        if (address, after) not in edges:
            out.append((address, 'fall-through'))
    return out


def check_edges(key, edges):
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions): both directions of every conditional
    jump of the function must be taken by some scenario, except the ones in UNTAKEN_ALLOWED (an allowlist entry that is taken is stale)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


def normalize(calls, stubs, iat, word_args):
    """The original's call log as comparable lists: [callee, ecx, *args (word arguments by their low 16 bits), derefs, probe]."""
    by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
    out = []
    for call in calls:
        s = by_name[call[0]]
        entry = [call[0], call[1] if s.this else 0]
        rest = list(call[2 if s.this else 1:])
        probe = rest.pop() if getattr(s, 'probe_addr', None) else None
        if call[0] in TRIM:
            rest = TRIM[call[0]](rest)
        derefs = [rest.pop() for _ in getattr(s, 'derefs', None) or ()][::-1]
        wa = word_args.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        entry.extend(derefs)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out



# ---- helpers shared by the generators ------------------------------------------------------------------------------------------------

SELF_SIZE = 0x1000
RECORDS_VA = 0x5bb5e5
REC_STRIDE = 0x8d


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def records_area(rng, slot, rec_va):
    """The table of records of stride 0x8d (one record before and three after the used one so that a negative slot lies inside) whose dword at +0 for `slot` is rec_va."""
    data = bytearray(rng.randbytes(5 * REC_STRIDE))
    for i in range(5):
        put32(data, i * REC_STRIDE, rng.randrange(1 << 32))
    put32(data, (slot + 1) * REC_STRIDE, rec_va)
    return Area('records', RECORDS_VA - REC_STRIDE, data, image=True), {'records_5bb5e5': ('records', REC_STRIDE)}


def rand32(rng):
    """A random dword that is not near the stack of the original run (a call argument in that range is logged as a local of the function)."""
    while True:
        v = rng.randrange(1 << 32)
        if not od.STACK_BASE - 0x10 <= v < od.STACK_BASE + od.STACK_SIZE + 0x10:
            return v


def nonzero_bytes(rng, length, high=False):
    return bytes(rng.randrange(0x80, 0x100) if high and rng.random() < 0.5 else rng.randrange(1, 0x100) for _ in range(length))


def cstring(content, size, rng):
    """`size` bytes: the content, a terminator, then random bytes."""
    s = bytearray(rng.randbytes(size))
    s[:len(content)] = content
    s[len(content)] = 0
    return s




# ---- 0x4fcb5c ------------------------------------------------------------------------------------------------------------------------------

SELF_4FCB5C = 0xb900
VOL_BITS = [0xbf800000, 0x80000000, 0, 1, 0x3e800000, 0x3f000000, 0x3f800000, 0x3f800001, 0x3f7fffff, 0x40000000, 0x7f800000, 0xff800000, 0x7fc00000, 0x7f800001, 0xffc00000,
            0x80000001, 0x3f4ccccd, 0x7f7fffff]
F_BITS = [0, 0x3f800000, 0xbf800000, 0x3f000000, 0x7149f2ca, 0xf149f2ca, 0x4f32d05e, 0xcf32d05e, 0x447a0000, 0x3a83126f, 0x7fc00000, 0x7f800000, 0x3a03126f, 0x80000000, 0x3f800001,
          0x7f7fffff, 0x5f000000, 0xdf000000]


def f32(x):
    return struct.unpack('<I', struct.pack('<f', x))[0]


def profiles_4fcb5c():
    p = [(v, idx) for v in range(len(VOL_BITS)) for idx in (0, 1, 7, -1)]
    p += [(v, idx) for v in (6, 4, 0, 12) for idx in (0x1f, 0x20, -3, 2)]
    return p


def gen_4fcb5c(rng, n):
    (v, idx), variant = prof(n, profiles_4fcb5c())
    s = bytearray(rng.randbytes(SELF_4FCB5C))
    put32(s, 0xb764 + 4 * idx, VOL_BITS[v])
    for c in range(0x21):      # channel 0x20 lies behind the loop (a bound slip would process it)
        ch = c * 0x5bb
        match = rng.random() < (0.6 if c < 2 else 0.25 if c < 0x20 else 0.7)
        put16(s, ch + 0x10c, idx if match else rng.choice([idx + 1, idx - 1, idx ^ 0x100, 0, 0x7fff, 0x8000, 0xffff, 5]))
        put16(s, ch + 0x132, rng.choice([1, 1, 1, 0, 2, 0xffff, 0x100, 0x101, 0x8001]))
        put32(s, ch + 0x138, rng.choice(F_BITS) if rng.random() < 0.8 else f32(rng.uniform(-2.0, 2.0)))
        put32(s, ch + 0x13c, rng.choice(F_BITS) if rng.random() < 0.8 else f32(rng.uniform(-2.0, 2.0)))
    probe = [('self', 0x100, 0x100), ('self', 0x5bb + 0x100, 0x100)]
    stubs = {0x4f684a: stub(0x4f684a, THISCALL(1), probe)}
    a = idx & 0xffffffff
    return make('4fcb5c', [self_area(s)], stubs, {}, [a], (a,), (v, idx))


# ---- 0x43d7f0 ------------------------------------------------------------------------------------------------------------------------------

CALLS_43D7F0 = [(0x61c387, 0x4d3ced), (0x616ab2, 0x468f68), (0x61c8cf, 0x4a3910), (0x61d10f, 0x48a82e), (0x617066, 0x4b3da2), (0x61c7ed, 0x459bd6), (0x61d2dd, 0x4a1ce0),
                (0x624dc9, 0x48e393), (0x61d345, 0x48d0e5), (0x61d3a1, 0x4a6477), (0x61d449, 0x4b5c11), (0x61d6c1, 0x4ab425), (0x61d723, 0x465b9f), (0x61d779, 0x4618ab),
                (0x61d7d8, 0x487b98), (0x6204c1, 0x4afdc7), (0x61d873, 0x44fb54), (0x61e398, 0x47b3bc), (0x61df56, 0x4ba22e), (0x638603, 0x446075), (0x621a02, 0x478287),
                (0x622fa2, 0x4758e8), (0x62387c, 0x470e31), (0x624686, 0x48bc38), (0x6246dc, 0x47d640), (0x624734, 0x45b477), (0x6248ed, 0x456d77), (0x624931, 0x44e7d7),
                (0x6249a0, 0x4b7272), (0x6249dc, 0x454e39), (0x6252ad, 0x4840d9), (0x625ee8, 0x47e440), (0x627335, 0x4a7da5), (0x61e65c, 0x467651), (0x61e95c, 0x473117),
                (0x61ed7b, 0x458045), (0x61f4b1, 0x45dd96), (0x61ee6e, 0x4b80a5), (0x630a34, 0x4a9fcb), (0x624b50, 0x4640c9), (0x628732, 0x46b707), (0x624c2a, 0x46e7ef),
                (0x624cbf, 0x44d19d), (0x624d12, 0x48220e), (0x6369e4, 0x4acbba), (0x63847b, 0x4cafc1), (0x619935, 0x489722)]
BYTE_FLAGS_43D7F0 = ['byte_5b5158', 'byte_5b51ab', 'byte_5b51c6', 'byte_5b615e', 'byte_5b61af', 'byte_5b51f6']
OUT_FLAGS_43D7F0 = ['value_5d1a8f', 'value_5d1ad9', 'value_5d1b23', 'value_5d1bb7', 'value_5d1c01', 'value_5d1b6d']


def profiles_43d7f0():
    return [(d1, d2, mask) for d1 in (0, 1) for d2 in (0, 1) for mask in range(64)]


def gen_43d7f0(rng, n):
    (d1, d2, mask), variant = prof(n, profiles_43d7f0())
    g = world_all(rng)
    g['value_5bb1d2'] = 0 if not d1 else rng.choice([1, 0x80000000, 0xffffffff, rng.randrange(1, 1 << 32)])
    g['value_5bb1da'] = 0 if not d2 else rng.choice([1, 0x100, 0xffff0000, rng.randrange(1, 1 << 32)])
    for k, name in enumerate(BYTE_FLAGS_43D7F0):
        g[name] = rng.choice([1, 0x80, 0xff, 0x7f, rng.randrange(1, 256)]) if (mask >> k) & 1 else 0
    for name in OUT_FLAGS_43D7F0:
        g[name] = rng.choice([0, 0, 7, 0xffffffff, rng.randrange(1 << 32)])      # each flag is only ever set to 1: a clear flag stays 0, an old value stays
    probe = [('g:' + name, 0, size) for name, (address, size) in GLOBALS.items() if name != 'word_63a4cd']
    stubs = {callee: stub(callee, THISCALL(0), probe) for _, callee in CALLS_43D7F0}
    return make('43d7f0', [], stubs, g, [], (), (d1, d2, mask))


def world_all(rng):
    """Every global of Fl30cWorld with random contents."""
    return {name: rng.randrange(1 << (8 * size)) for name, (address, size) in GLOBALS.items()}


# ---- 0x434025 ------------------------------------------------------------------------------------------------------------------------------

SELF_434025 = 0x6000


def profiles_434025():
    return [('empty', 0), ('empty', -1), ('empty', 0x80000000)] + [('norm', k) for k in range(160)] + [('big', 0)]


def gen_434025(rng, n):
    (kind, k), variant = prof(n, profiles_434025())
    s = bytearray(rng.randbytes(SELF_434025))
    if kind == 'empty':
        put32(s, 0x5f64, k)
        put32(s, 0x5f68, rng.randrange(1 << 32))
        pool_n, pool_r = [20], [1]
    elif kind == 'big':
        count = 500
        put32(s, 0x5f64, count)
        for i in range(count):
            put32(s, 0x1144 + 4 * i, rand32(rng))
        pool_n, pool_r = [40, 0, 40] * 500, [0]
    else:
        count = 1 + k % 6
        put32(s, 0x5f64, count)
        a = [rand32(rng) for _ in range(count)]
        for i in range(count):
            put32(s, 0x1144 + 4 * i, a[i])
        for i in range(count):      # sometimes another entry equals the first p of entry i (A[i] + 4 + 4 + 4): the scan finds it
            if count > 1 and rng.random() < 0.5:
                j = rng.choice([x for x in range(count) if x != i])
                put32(s, 0x1144 + 4 * j, a[i] + 12)
        if rng.random() < 0.4:      # the dword behind the last entry equals the p of an entry: a scan that runs one entry too far finds it
            put32(s, 0x1144 + 4 * count, a[rng.randrange(count)] + 12)
        for j in range(count + 1):
            put32(s, 0x3084 + 4 * j, rng.choice([0, 1, 4, 8, 16, 20, 0x7ffffff0, 3, 0x10000, 5]))
        pool_n = [rng.choice([0, 3, 8, 9, 12, 20, 41, 60, 7, 16, 0x20000, 0x30001]) for _ in range(400)]
        pool_r = [rng.choice([0, 1, 1, 1, 2, 0xffffffff, 1]) for _ in range(400)]
    probe = [('self', 0x5f64, 8), ('self', 0x20e4, 64)]
    stubs = {0x4347b8: stub(0x4347b8, THISCALL(1), probe, results=pool_n), 0x434773: stub(0x434773, THISCALL(1), probe, results=pool_r),
             0x42639d: stub(0x42639d, THISCALL(2), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    return make('434025', [self_area(s)], stubs, {}, [], (), (kind, k))


# ---- 0x41b6e2 ------------------------------------------------------------------------------------------------------------------------------

RING_VA = 0x56f354


def lz_tokens(rng, groups, bias):
    """The tokens of an LZ stream: ('flag', byte) then, for the eight bits of the flag byte (lowest first), a literal (bit set: 1 token) or a match (bit clear: lo and hi tokens)."""
    toks = []
    for _ in range(groups):
        bits = [1 if rng.random() >= bias else 0 for _ in range(8)]
        toks.append(('flag', sum(b << i for i, b in enumerate(bits))))
        for b in bits:
            if b:
                toks.append(('lit', rng.randrange(256)))
            else:
                toks.append(('m1', rng.randrange(256) if rng.random() < 0.6 else rng.choice([0xf0, 0xff, 0xee, 0])))
                toks.append(('m2', rng.randrange(256) if rng.random() < 0.7 else rng.choice([0xff, 0xf0, 0x0f, 0, 0xfe])))
    return toks


def profiles_41b6e2():
    return [(cut, groups, bias) for cut in ('flag', 'lit', 'm1', 'm2', 'end', 'zero') for groups in (1, 2, 3, 6, 12) for bias in (0.0, 0.3, 0.8, 1.0)]


def gen_41b6e2(rng, n):
    (cut, groups, bias), variant = prof(n, profiles_41b6e2())
    toks = lz_tokens(rng, groups, bias)
    stream = bytearray((value + index) & 0xff for index, (kind, value) in enumerate(toks))      # byte i is the token plus the running key (the key is the index modulo 256)
    if cut == 'end':
        srclen = len(stream)
    elif cut == 'zero':
        srclen = 0
    else:
        cands = [i for i, (kind, _) in enumerate(toks) if kind == cut]
        srclen = rng.choice(cands) if cands else len(stream)
    src = bytearray(rng.randbytes(len(stream) + 8))
    src[:len(stream)] = stream
    dst = bytearray(rng.randbytes(0x2400))
    ring = bytearray(rng.randbytes(0x1000))
    areas = [Area('src', od.region_va(1), src, image=False, compare=False), Area('dst', od.region_va(2), dst, image=False), Area('ring', RING_VA, ring, image=True)]
    junk = rng.randrange(1 << 32)
    return make('41b6e2', areas, {}, {}, [od.region_va(1), od.region_va(2), srclen, junk], (od.region_va(1), od.region_va(2), srclen, junk), (cut, groups, bias, srclen),
                pointers={'ring_56f354': ('ring', 0)})


# ---- 0x4763b3 ------------------------------------------------------------------------------------------------------------------------------

# 0x50ca3e is called with four stack arguments (the debug trace) and with three (the text of a score); the stub logs four dwords, the fourth of the three-argument call is the
# caller's own local (`self`), not an argument: it is dropped here from the log of the original
def _trim_50ca3e(rest):
    """0x50ca3e takes four dwords from 0x4763b3's debug trace (second dword 0x54c868), two from the messages of 0x423876 (0x544730, 0x5447e0), three from the other messages and the texts."""
    if rest[1] == 0x54c868:
        return rest
    return rest[:2] if rest[1] in (0x544730, 0x5447e0) else rest[:3]


TRIM[0x50ca3e] = _trim_50ca3e
CELL_VALUES = [0, 1, 2, 3, 0xffff, 0x8000, 0x7fff]
REC_WORDS = [0, 1, 2, 5, 0x7fff, 0x8000, 0xffff, 0xfffe, 0x100, 10, 0x3e8, 7, 0xfff0]


def profiles_4763b3():
    edges = [(0, 0, 0, 0), (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1), (1, 0, 1, 0), (0, 1, 0, 1), (1, 0, 0, 1), (0, 1, 1, 0)]
    return [(d, h, e) for d in range(6) for h in range(6) for e in edges]


def gen_4763b3(rng, n):
    (d, h, (top, bottom, left, right)), variant = prof(n, profiles_4763b3())
    nrows, ncols = rng.choice([8, 9]), rng.choice([9, 10])
    if top:
        y0 = 0
    elif bottom:
        y0 = nrows - 1 - d
    else:
        y0 = rng.randint(1, nrows - 2 - d)
    if left:
        x0 = 0
    elif right:
        x0 = ncols - 1 - h
    else:
        x0 = rng.randint(1, ncols - 2 - h)
    y1, x1 = y0 + d, x0 + h
    yy, xx = rng.randint(y0, y1), rng.randint(x0, x1)
    ref = rng.choice(CELL_VALUES)
    s = bytearray(rng.randbytes(0x1000))
    for r in range(9):
        for c in range(10):
            put16(s, 0x30 + r * 0xc8 + c * 0x14 + 2, rng.choice(CELL_VALUES))
            s[0x30 + r * 0xc8 + c * 0x14 + 1] = rng.choice([0, 0, 0, 1])
    def other():
        return rng.choice([v for v in CELL_VALUES if v != ref])
    for r in range(y0, y1 + 1):
        put16(s, 0x30 + r * 0xc8 + xx * 0x14 + 2, ref)
    for c in range(x0, x1 + 1):
        put16(s, 0x30 + yy * 0xc8 + c * 0x14 + 2, ref)
    if y0 > 0:
        put16(s, 0x30 + (y0 - 1) * 0xc8 + xx * 0x14 + 2, other())
    if y1 < nrows - 1:
        put16(s, 0x30 + (y1 + 1) * 0xc8 + xx * 0x14 + 2, other())
    if x0 > 0:
        put16(s, 0x30 + yy * 0xc8 + (x0 - 1) * 0x14 + 2, other())
    if x1 < ncols - 1:
        put16(s, 0x30 + yy * 0xc8 + (x1 + 1) * 0x14 + 2, other())
    slot = rng.choice([0, 1, -1, 2])
    put16(s, 0x22, slot)
    rec = bytearray(rng.randbytes(0x800))
    put16(rec, 0x42, nrows)
    put16(rec, 0x44, ncols)
    for off in (0x644, 0x656, 0x658, 0x65a, 0x65c, 0x65e):
        put16(rec, off, rng.choice(REC_WORDS))
    recs, pointers = records_area(rng, slot, od.region_va(1))
    dbg = (0, rng.choice([1, 0x100, 0x8000]))[variant % 2]
    g, nbr = debug_areas(rng, dbg)
    probe = [('self', 0x8c0, 0x18), ('self', 0x800, 2), ('self', 0x835, 0x10)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    return make('4763b3', [self_area(s), Area('rec', od.region_va(1), rec, image=False), recs, *nbr], stubs, g, [xx, yy], (xx, yy), (d, h, top, bottom, left, right, variant % 2),
                pointers=pointers)


# ---- 0x423876 ------------------------------------------------------------------------------------------------------------------------------

NODE_SIZE = 0x60


def profiles_423876():
    p = [('nullcell', dbg, f) for dbg in (0, 1) for f in (0, 1)]
    p += [('nonode', f) for f in (0, 1)]
    p += [('chain', length, typ, c, f, dbg) for length in (1, 2, 3) for typ in (0, 1, 2, 3) for c in (0, 1) for f in (0, 1) for dbg in (0, 1)]
    p += [('rec', prefix, inner, tmode, outer, cinner, couter, f, dbg) for prefix in (0, 1) for inner in (1, 2) for tmode in ('zero', 'bad', 'ok') for outer in (1, 2)
          for cinner in (0, 1) for couter in (0, 1) for f in (0, 1) for dbg in (0, 1)][::5]
    return p


def gen_423876(rng, n):
    (kind, *rest), variant = prof(n, profiles_423876())
    areas, nodes = [], []

    def node(typ, next_va, c_va, f44=None):
        """A node object; returns its address. type 3 stands for a type that is neither 1 nor 2."""
        b = bytearray(rng.randbytes(NODE_SIZE))
        real = {0: 2, 1: 1, 2: 2, 3: 1}[typ]
        put32(b, 0, real)
        put32(b, 0x34, next_va)
        put32(b, 0x48, c_va)
        put32(b, 0x44, (0 if real == 1 or rng.random() < 0.5 else rng.choice([rand32(rng), 0x10000, 0x20000])) if f44 is None else f44)
        va = od.region_va(4 + len(nodes))
        areas.append(Area('node%d' % len(nodes), va, b, image=False))
        nodes.append(va)
        return va

    def simple_chain(length, typ_choices, c_last):
        """`length` simple nodes (types 2, or 1 with [0x44] = 0) linked by +0x34, the last next 0; returns the address of the first and the list of the node addresses."""
        vas = [od.region_va(4 + len(nodes) + i) for i in range(length)]
        c_vas = [od.region_va(12 + c_last)] if c_last else [0]
        for i in range(length):
            node(typ_choices[i % len(typ_choices)], vas[i + 1] if i + 1 < length else 0, c_vas[0] if i + 1 == length else rand32(rng) & 0x7fffffff | 1)
        return vas[0], vas

    cell = bytearray(rng.randbytes(16))
    cell2 = bytearray(rng.randbytes(16))
    tstruct = bytearray(rng.randbytes(16))
    cobjs = [bytearray(rng.randbytes(16)) for _ in range(4)]
    r423aae, r4235fd = [], []
    f, dbg = 0, 0
    p0 = rng.choice([rand32(rng), rand32(rng), 0x10000, 0x30000])
    put32(cell, 0, p0)
    if kind == 'nullcell':
        dbg, f = rest
        put32(cell, 0, 0)
    elif kind == 'nonode':
        f = rest[0]
        r423aae = [0]
    elif kind == 'chain':
        length, typ, c, f, dbg = rest
        first, _ = simple_chain(length, [typ, (typ + 1) % 3, 2], c)
        r423aae = [first]
    else:
        prefix, inner, tmode, outer, cinner, couter, f, dbg = rest
        q = rand32(rng)
        # the nodes in the order of the plan: [prefix simple node] -> R (type 1, [0x44] = q); the inner chain; the nodes after the call of 0x4235fd
        first_va = od.region_va(4)
        r_index = 1 if prefix else 0
        if prefix:
            node(rng.choice([0, 1, 2]), od.region_va(4 + r_index), rand32(rng) | 1)
        node(1, rng.choice([0, od.region_va(11)]), rand32(rng) | 1, f44=q)
        inner_first, _ = simple_chain(inner, [rng.choice([0, 1, 2]), 2], cinner)
        r423aae = [first_va, inner_first]
        if tmode == 'zero':
            r4235fd = [0]
        else:
            t_va = od.region_va(3)
            put32(tstruct, 4, od.region_va(2))
            second = od.region_va(4 + len(nodes))
            if tmode == 'bad':
                node(rng.choice([0, 1, 2]), 0, 0, f44=rand32(rng) | 1)
                put32(tstruct, 8, second)
            else:
                chain_first, _ = simple_chain(outer, [rng.choice([0, 1, 2]), 2], couter)
                put32(tstruct, 8, chain_first)
            r4235fd = [t_va]
    areas = [self_area(bytearray(rng.randbytes(0x100))), Area('cell', od.region_va(1), cell, image=False), Area('cell2', od.region_va(2), cell2, image=False),
             Area('tstruct', od.region_va(3), tstruct, image=False), *areas, *[Area('cobj%d' % i, od.region_va(12 + i), cobjs[i], image=False) for i in range(4)]]
    probe = [('cobj0', 0, 16), ('cobj1', 0, 16), ('cell', 0, 4), ('cell2', 0, 4), ('node0', 0x30, 0x20)] if nodes else [('cell', 0, 4)]
    probe = [x for x in probe if x[0] == 'cell' or x[0] != 'node0' or nodes]
    g, nbr = debug_areas(rng, (0, rng.choice([1, 0x100, 0x8000]))[dbg])
    stubs = {0x423aae: stub(0x423aae, THISCALL(1), probe, results=r423aae or [0]), 0x4234dd: stub(0x4234dd, THISCALL(2), probe), 0x423a30: stub(0x423a30, THISCALL(1), probe, derefs=[(0, 4)]),
             0x4235fd: stub(0x4235fd, THISCALL(0), probe, results=r4235fd or [0]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x51dc6c: stub(0x51dc6c, CDECL(1), probe),
             0x52139c: stub(0x52139c, STDCALL(3), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    return make('423876', [*areas, *nbr], stubs, g, [od.region_va(1), f], (od.region_va(1), f), (kind, *rest))


SPECS = {
    '4fcb5c': dict(id=1, va=0x4fcb5c, size=406, gen=gen_4fcb5c, cleanup=4, fpcw=0x27f, n=len(profiles_4fcb5c()) * 6),
    '43d7f0': dict(id=2, va=0x43d7f0, size=675, gen=gen_43d7f0, cleanup=0, n=len(profiles_43d7f0()) * 2),
    '434025': dict(id=3, va=0x434025, size=536, gen=gen_434025, cleanup=0, n=len(profiles_434025()) * 3),
    '41b6e2': dict(id=4, va=0x41b6e2, size=579, gen=gen_41b6e2, cleanup=16, n=len(profiles_41b6e2()) * 3),
    '4763b3': dict(id=5, va=0x4763b3, size=1650, gen=gen_4763b3, cleanup=8, n=len(profiles_4763b3()) * 2),
    '423876': dict(id=6, va=0x423876, size=442, gen=gen_423876, cleanup=8, n=len(profiles_423876()) * 2),
}
KEYS = list(SPECS)


def hang_run_423876():
    """The original on a node whose type is neither 1 nor 2 (0x423876): it does not return (the run is cut after 20000 instructions, which raises). Returns (executed instructions,
    (instruction, next instruction) pairs) of that run: the evidence for the jumps 0x4238d9 and 0x423930 whose taken direction leads into the endless loop at 0x4239c8."""
    node = bytearray(NODE_SIZE)
    put32(node, 0, 3)
    areas = [Area('self', od.region_va(0), bytearray(0x100), image=False), Area('cell', od.region_va(1), bytearray(struct.pack('<I', 0x1234) + bytes(12)), image=False),
             Area('node0', od.region_va(4), node, image=False)]
    stubs = {0x423aae: stub(0x423aae, THISCALL(1), None, results=[od.region_va(4)])}
    runner = Original30([], {a.name: (a.va, a.data) for a in areas}, stubs, {}, fpcw=None)
    try:
        runner.run(0x423876, 442, ecx=od.region_va(0), stack_args=[od.region_va(1), 0], limit=20000)
    except RuntimeError:
        return set(runner.executed), set(runner.edges)
    raise AssertionError('the original returned on a node of type 3')


EXTRA_RUNS = {'423876': hang_run_423876}
UNTAKEN_ALLOWED['423876'] = {(0x42393d, 'taken'): 'je [node+0x44] == 0 at 0x42393d is reached only after 0x4238de..0x4238e2 found [node+0x44] != 0 for the same type 1 node: the jump is never taken'}
UNTAKEN_ALLOWED['434025'] = {(0x4340e3, 'taken'): 'je after `mov eax, 1; test eax, eax` guards the endless entry loop: the guard is always true, so the jump to 0x434233 is never taken from here '
                                                    '(0x434233 itself is reached by the jumps at 0x43416e and 0x43422c, and every instruction of the function is executed)'}
NAMES = {'4fcb5c': 'set_category_master', '43d7f0': 'init_scenes', '434025': 'scan_entries', '41b6e2': 'lz_decode', '4763b3': 'mark_runs', '423876': 'unwind_chain'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
