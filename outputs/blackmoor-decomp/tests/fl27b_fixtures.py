"""FL-27 (batch b): the fixtures shared by tests/test_fl27b_differential.py and tests/fl27b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the
vtables, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The
scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees, the vtable entries and the import slots are recording
stubs (OS or host boundaries); nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that
changes `self` or a local of the caller: call number, argument or absolute address, offset, size, value) so that a function's re-reads
after a call are exercised. It returns the result, the normalised ordered call log and a digest of the ordered calls, the return value and
the memory read back.
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


def parse_world():
    """The fields of Fl27bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl27b.h').read_text()
    body = re.search(r'typedef struct Fl27bWorld \{(.*?)\} Fl27bWorld;', text, re.S).group(1)
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


class Original27(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)]) and carry
    scripted writes (stub.writes = [(call number, argument or -1, offset, size, value)]: argument k = the pointer at stack argument k, -1 = the
    absolute address `offset`). Records every (previous instruction, next instruction) pair, so that the direction of every jump is known."""

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
                uc.mem_write(at, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1)))
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
                           ecx=od.region_va(0) if ecx is None else ecx, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args)


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
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
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
UNTAKEN_ALLOWED = {
    '449a94': {
        (0x449ab9, 'taken'): 'the same dword [self+0x36] was tested non-zero at 0x449aa7 and nothing runs in between: this direction needs a concurrent store',
        (0x449aed, 'taken'): 'with [self+0x36] zero at the loop head the original stores through the null object at address 0x24 (an access violation): unsafe, a native rejection',
    },
}


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


# ---- the scenario generators ------------------------------------------------------------------------------------------------------

VT_STUB_A = od.STUB_BASE + 0x900       # the vtable entries that the original reads and calls (stubs inside the mapped stub page)
VT_STUB_B = od.STUB_BASE + 0xa00


def vtable_area(slot, target, rng):
    """A vtable region: random bytes with the dword `target` at byte offset `slot`."""
    v = bytearray(rng.randbytes(0x100))
    put32(v, slot, target)
    return Area('vtbl', od.region_va(2), v, image=False)


def object_area(name, index, vtable_va, rng, handle=None, size=0x40):
    o = bytearray(rng.randbytes(size))
    put32(o, 0, vtable_va)
    if handle is not None:
        put32(o, 0x28, handle)
    return Area(name, od.region_va(index), o, image=False)


NZ32 = [1, 0x100, 0x10000, 0x01000000, 0xffffffff]
HANDLES = [1, 0x1234, 0x80000000, 0xdeadbeef]


def profiles_449bff():
    profiles = [('gate',)] + [('fail', d) for d in DBG_VALUES]
    profiles += [('ok', r, d) for r in (0, 1) for d in DBG_VALUES]
    seqs = [(2, 0), (2, 1), (3, 2, 1), (0x80000000, 1), (0xfffffffe, 0), (5, 5, 5, 1), (7, 2, 0)]
    profiles += [('loop', s, d, rw) for s in seqs for d in (0, 1, 0x100) for rw in (False, True)]
    return profiles


def gen_449bff(rng, n):
    (kind, *rest), variant = prof(n, profiles_449bff())
    dbg = {'gate': rng.choice(DBG_VALUES), 'fail': rest[0] if rest else 0, 'ok': rest[1] if len(rest) > 1 else 0, 'loop': rest[1] if len(rest) > 1 else 0}[kind]
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x36, 0 if kind == 'gate' else od.region_va(1))
    obj = object_area('obj', 1, 0, rng, rng.choice(HANDLES))
    obj2 = object_area('obj2', 3, 0, rng, rng.choice(HANDLES) ^ 0x5a5a)
    results = {'gate': [rng.randrange(1 << 32)], 'fail': [0xffffffff], 'ok': [rest[0] if kind == 'ok' else 0]}.get(kind, list(rest[0]) if kind == 'loop' else None)
    writes = [(0, -1, od.region_va(0) + 0x36, 4, od.region_va(3))] if kind == 'loop' and rest[2] else []
    g, nbr = debug_areas(rng, dbg)
    probe = [('self', 0, 0x60)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(5), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4264e8: stub(0x4264e8, THISCALL(1), probe),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    iat = {0x52a284: stub(0x52a284, STDCALL(1), probe, results=results, writes=writes)}
    areas = [Area('self', od.region_va(0), d, image=False), obj, obj2, *nbr]
    return make('449bff', areas, stubs, g, [], (), (kind, *rest), iat=iat)


def profiles_449a94():
    profiles = [('gate', v) for v in (1, 3)]
    profiles += [('poll', ((1, 0),), v) for v in (1, 0, 2, 3, 0x100, 0x10001, 0xffffffff)]
    seqs = [((1, 259), (1, 0)), ((0, 5), (1, 0)), ((0, 0), (0, 0), (1, 0)), ((0x100, 0x100), (0x80000000, 0x100), (0xffffffff, 0)), ((0, 259), (0xffffffff, 0x80000000), (1, 0)),
            ((1, 0x100), (0x80000000, 1), (1, 0)), ((0, 0), (1, 0))]
    profiles += [('poll', s, v) for s in seqs for v in (1, 0, 5)]
    return profiles


def gen_449a94(rng, n):
    (kind, *rest), variant = prof(n, profiles_449a94())
    dbg = DBG_VALUES[(variant + n) % len(DBG_VALUES)] if variant % 2 == 0 or kind == 'poll' else 0
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x36, 0 if kind == 'gate' else od.region_va(1))
    put32(d, 0x42, rest[-1])
    obj = object_area('obj', 1, od.region_va(2), rng, rng.choice(HANDLES))
    vt = vtable_area(0x78, VT_STUB_B, rng)
    seq = rest[0] if kind == 'poll' else ()
    pc = lambda: [('self', 0, 0x60), ('obj', 0, 0x40)]
    writes = [(i, 1, 0, 4, code) for i, (_, code) in enumerate(seq)]
    g, nbr = debug_areas(rng, dbg)
    probe = pc()
    stubs = {0x449bff: stub(0x449bff, THISCALL(0)[:2] + (0,), probe), 0x426367: stub(0x426367, (0, True, 0), probe, results=[0x1234 + variant]),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), VT_STUB_B: stub(VT_STUB_B, (0, True, 0), probe)}
    iat = {0x52a2b0: stub(0x52a2b0, STDCALL(1), probe),
           0x52a280: stub(0x52a280, STDCALL(2), probe, results=[r for r, _ in seq] or None, writes=writes)}
    areas = [Area('self', od.region_va(0), d, image=False), obj, vt, *nbr]
    return make('449a94', areas, stubs, g, [], (), (kind, *rest), iat=iat)


def profiles_4bf773():
    profiles = [('gate0', d, g2) for d in DBG_VALUES for g2 in (0, 1, 0x100, 0x10000, 0x01000000, 0xffffffff)]
    profiles += [('main', rw, d, g2) for rw in (None, 'zero', 'obj2') for d in DBG_VALUES for g2 in (0, 1, 0x100, 0x10000, 0xffffffff)]
    return profiles


def gen_4bf773(rng, n):
    (kind, *rest), variant = prof(n, profiles_4bf773())
    rw, dbg, g222 = (None, *rest[:2]) if kind == 'gate0' else rest
    d = bytearray(rng.randbytes(0x240))
    put32(d, 0x1d6, 0 if kind == 'gate0' else od.region_va(1))
    put32(d, 0x222, g222)
    obj = object_area('obj', 1, od.region_va(2), rng)
    obj2 = object_area('obj2', 3, od.region_va(2), rng)
    vt = vtable_area(0, VT_STUB_A, rng)
    writes = []
    if rw == 'zero':
        writes = [(0, -1, od.region_va(0) + 0x1d6, 4, 0)]
    elif rw == 'obj2':
        writes = [(0, -1, od.region_va(0) + 0x1d6, 4, od.region_va(3))]
    g, nbr = debug_areas(rng, dbg)
    probe = [('self', 0, 0x240)]
    stubs = {0x44c479: stub(0x44c479, CDECL(1), probe), 0x449a94: stub(0x449a94, (0, True, 0), probe, writes=writes), VT_STUB_A: stub(VT_STUB_A, THISCALL(1), probe),
             0x44c4ab: stub(0x44c4ab, CDECL(1), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x415011: stub(0x415011, THISCALL(1), probe),
             0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe), 0x41632b: stub(0x41632b, THISCALL(1), probe), 0x4bedfa: stub(0x4bedfa, THISCALL(1), probe)}
    areas = [Area('self', od.region_va(0), d, image=False), obj, obj2, vt, *nbr]
    return make('4bf773', areas, stubs, g, [], (), (kind, *rest))


def profiles_4161d1():
    allocs = (0, 1, 0x20000000, 0xffffffff, 0x100)
    profiles = [('k0', p) for p in allocs] + [('k1', p, q) for p in allocs for q in allocs]
    profiles += [('other', k) for k in (2, 3, 0x100, 0x10000, 0x80000000, 0xffffffff, 0x101)]
    return profiles


def gen_4161d1(rng, n):
    (kind, *rest), variant = prof(n, profiles_4161d1())
    a = bytearray(rng.randbytes(0x200))
    put32(a, 0x172, {'k0': 0, 'k1': 1, 'other': rest[0] if rest else 2}[kind])
    put32(a, 0x1c8, rng.choice([0, 1, 0x1000, 0x7fffffff, rng.randrange(1 << 32)]))
    probe = [('arg', 0, 0x200), ('g:value_63a58a', 0, 4)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=list(rest) if kind != 'other' else [0x55]), 0x50ca3e: stub(0x50ca3e, CDECL(2), probe),
             0x52139c: stub(0x52139c, STDCALL(3), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    g = {'value_63a58a': rng.choice([0, 4, 1, rng.randrange(1 << 32)])}
    return make('4161d1', [Area('arg', od.region_va(1), a, image=False)], stubs, g, [od.region_va(1)], (od.region_va(1),), (kind, *rest))


DIMS = [0, 1, 2, 3, 9, 100, 0x7fff, -1, -2, -32768, 0x1234]


def profiles_4c2c3a():
    profiles = [('nomem',)]
    profiles += [('nobuf', n) for n in (0, 5, 0x19)]
    profiles += [('main', f, n) for f in (0, 1, 2, 3, 0x100, 0x101, 0x80000000, 0x80000001, 0xfffffffe, 0xffffffff) for n in (0, 1, 0x17, 0x18, 0x19, 0x1a, 0x40)]
    return profiles


def gen_4c2c3a(rng, n):
    (kind, *rest), variant = prof(n, profiles_4c2c3a())
    a, b = rng.choice(DIMS), rng.choice(DIMS)
    w895, w893 = rng.choice([0, 1, 2, 3, -1, 0x7fff, -32768, 0x100]), rng.randrange(-32768, 32768)
    flags = {'nomem': rng.randrange(1 << 32), 'nobuf': rng.choice([0, 2, 0x100]), 'main': rest[0] if kind == 'main' else 0}[kind]
    length = rest[-1] if kind != 'nomem' else rng.randrange(0, 40)
    name = bytearray(rng.randrange(1, 256) for _ in range(0x80))
    name[length] = 0
    rec = bytearray(rng.randbytes(0x80))
    buf = rng.choice([od.region_va(3), 0x1234, 0xffffffff, 0x80000000])
    results = [0] if kind == 'nomem' else [od.region_va(1), 0] if kind == 'nobuf' else [od.region_va(1), buf]
    probe = [('obj', 0, 0x80), ('name', 0, 0x80)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=results), 0x42639d: stub(0x42639d, THISCALL(2), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    g = {'word_639895': w895, 'word_639893': w893}
    nbr = [Area('nbr1', 0x639891, bytearray(rng.randbytes(2)), compare=False), Area('nbr2', 0x639897, bytearray(rng.randbytes(2)), compare=False)]
    areas = [Area('self', od.region_va(0), bytearray(rng.randbytes(0x40)), image=False), Area('obj', od.region_va(1), rec, image=False),
             Area('name', od.region_va(2), name, image=False), *nbr]
    # the name is at region 2; the second allocation (never dereferenced) is any value
    stack = [(rng.randrange(1 << 16) << 16) | (a & 0xffff), (rng.randrange(1 << 16) << 16) | (b & 0xffff), rng.randrange(1 << 32), flags, od.region_va(2)]
    return make('4c2c3a', areas, stubs, g, stack, (a, b, stack[2], flags, od.region_va(2)), (kind, *rest))


def wrap32(v):
    return ((v + (1 << 31)) % (1 << 32)) - (1 << 31)


def rect_pair(rng, mode):
    """Rectangles D and C as [x0, y0, x1, y1] signed values: `mode` 'hit' (random overlap), ('miss', k, delta) (condition k of the four rejections fails by delta; delta 0 still overlaps),
    ('pick', mask) (each of the four max / min choices goes the way of a bit of the mask, with strict differences)."""
    big = [0, 1, -1, 5, 100, -100, 0x7fffff00, -0x7fffff00, 0x7fffffff, -0x80000000, 0x12345678]
    c0, c1 = rng.choice(big), rng.choice(big)
    c = [c0, c1, c0 + rng.choice([0, 1, 10, 300]), c1 + rng.choice([0, 1, 10, 300])]
    if isinstance(mode, tuple) and mode[0] == 'pick':
        mask = mode[1]
        c[2], c[3] = c[0] + 100, c[1] + 100
        d = [c[0] + (-3 if mask & 1 else 3), c[1] + (-2 if mask & 2 else 2), c[2] + (-3 if mask & 4 else 3), c[3] + (-2 if mask & 8 else 2)]
    elif isinstance(mode, tuple) and mode[0] == 'miss':
        k, delta = mode[1], mode[2]
        c[2], c[3] = c[0] + 50, c[1] + 50
        d = [c[0] + 10, c[1] + 10, c[0] + 20, c[1] + 20]
        if k == 0:        # D.x0 > C.x1
            d[0] = c[2] + delta
            d[2] = d[0] + 5
        elif k == 1:      # D.x1 < C.x0
            d[2] = c[0] - delta
            d[0] = d[2] - 5
        elif k == 2:      # D.y0 > C.y1
            d[1] = c[3] + delta
            d[3] = d[1] + 5
        else:             # D.y1 < C.y0
            d[3] = c[1] - delta
            d[1] = d[3] - 5
    else:
        d = [c[0] + rng.choice([-5, 0, 5, 20]), c[1] + rng.choice([-5, 0, 5, 20]), 0, 0]
        d[2] = d[0] + rng.choice([0, 1, 30, 200])
        d[3] = d[1] + rng.choice([0, 1, 30, 200])
    return [wrap32(v) for v in d], [wrap32(v) for v in c]


def profiles_4c0d3f():
    profiles = [('none', f) for f in (0, 1)]
    profiles += [('first', f1, f3) for f1 in (1, 0x100, 0x10000, 0x01000000, 0xffffffff) for f3 in (0, 1, 0x100, 0xffffffff)]
    profiles += [('cond', a176, a172) for a176 in (0, 1, 2, 0x100, 0xffffffff) for a172 in (0, 1, 2, 0x100, 0xffffffff)]
    profiles += [('miss', k, delta) for k in range(4) for delta in (0, 1, 2, 1000)]
    profiles += [('pick', m) for m in range(16)]
    profiles += [('hit', 0)]
    return profiles


def gen_4c0d3f(rng, n):
    (kind, *rest), variant = prof(n, profiles_4c0d3f())
    player = bytearray(rng.randbytes(0x220))
    f1, f2, f3 = 0, rng.choice([1, 0x100, 0x10000, 0x01000000, 0xffffffff]), rng.choice([0, 0, 1, 0x100, 0xffffffff])
    a176, a172 = rng.choice([0, 1]), rng.choice([0, 1])
    mode = 'hit'
    if kind == 'none':
        f2 = 0 if rest[0] == 0 else rng.choice([0, 0])
        a176, a172 = rng.choice([(1, 0), (0, 1)])
    elif kind == 'first':
        f1, f3 = rest
        f2 = rng.choice([0, 1])
    elif kind == 'cond':
        a176, a172 = rest
    elif kind == 'miss':
        a176, a172 = 1, rng.choice([0, 5])
        mode = ('miss', rest[0], rest[1])
    elif kind == 'pick':
        a176, a172 = rng.choice([(1, 0), (0, 1), (1, 1)])
        mode = ('pick', rest[0])
    elif kind == 'hit':
        a176, a172 = 0, 1
    put32(player, 0x20e, f1)
    put32(player, 0x212, f2)
    put32(player, 0x216, f3)
    put32(player, 0x176, a176)
    put32(player, 0x172, a172)
    d, c = rect_pair(rng, mode)
    for i in range(4):
        struct.pack_into('<i', player, 0x1e6 + 4 * i, c[i])
    struct.pack_into('<ii', player, 0x1d6, rng.choice([0, 7, -50, 0x7fffffff, -0x80000000]), rng.choice([0, 3, -9, 0x7fffffff]))
    rectd = bytearray(rng.randbytes(0x20))
    for i in range(4):
        struct.pack_into('<i', rectd, 4 * i, d[i])
    g = {k: rng.randrange(1 << 32) for k in ('value_5d19f7', 'value_5d19f3', 'value_5cf665', 'value_5d19ef')}
    probe = [('player', 0x1c0, 0x60)]
    stubs = {0x4c5377: stub(0x4c5377, THISCALL(5), probe, derefs=[(2, 16), (3, 16)])}
    areas = [Area('player', 0x637fd7, player), Area('rectd', 0x583122, rectd)]
    return make('4c0d3f', areas, stubs, g, [], (), (kind, *rest), pointers={'player_637fd7': ('player', 0), 'rect_583122': ('rectd', 0)})


SPECS = {
    '449bff': dict(id=1, va=0x449bff, size=253, gen=gen_449bff, cleanup=0, n=len(profiles_449bff()) * 3),
    '449a94': dict(id=2, va=0x449a94, size=273, gen=gen_449a94, cleanup=0, n=len(profiles_449a94()) * 3),
    '4bf773': dict(id=3, va=0x4bf773, size=308, gen=gen_4bf773, cleanup=0, n=len(profiles_4bf773()) * 2),
    '4c2c3a': dict(id=5, va=0x4c2c3a, size=449, gen=gen_4c2c3a, ret=True, cleanup=0x14, n=len(profiles_4c2c3a()) * 4),
    '4c0d3f': dict(id=6, va=0x4c0d3f, size=497, code=483, gen=gen_4c0d3f, cleanup=0, n=len(profiles_4c0d3f()) * 4),
    '4161d1': dict(id=4, va=0x4161d1, size=346, gen=gen_4161d1, cleanup=4, n=len(profiles_4161d1()) * 4),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
