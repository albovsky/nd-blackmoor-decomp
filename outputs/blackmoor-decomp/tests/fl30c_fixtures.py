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


SPECS = {
    '4fcb5c': dict(id=1, va=0x4fcb5c, size=406, gen=gen_4fcb5c, cleanup=4, fpcw=0x27f, n=len(profiles_4fcb5c()) * 6),
    '43d7f0': dict(id=2, va=0x43d7f0, size=675, gen=gen_43d7f0, cleanup=0, n=len(profiles_43d7f0()) * 2),
}
KEYS = list(SPECS)
NAMES = {'4fcb5c': 'set_category_master', '43d7f0': 'init_scenes'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
