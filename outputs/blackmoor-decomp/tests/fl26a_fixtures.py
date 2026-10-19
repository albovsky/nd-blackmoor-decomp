"""FL-26 (batch a): the fixtures shared by tests/test_fl26a_differential.py and tests/fl26a_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the record table at 0x5bb5e5 (stride 0x8d, one
slack record below it), the object of the target record, the nine-byte constants, the scripted callees and the globals. The scenarios
cycle through profiles (each guard of the chain failing in turn, the record-state guard too, then every arm of the function), and the
optional parts (the 0x5bb1ca flag, the position of the first differing byte of a nine-byte compare, the scripted answers, the loop
counts) vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (SHAPES) and the GetTickCount import (0x52a23c) are
recording stubs (OS or host boundaries); nothing inside the function under test is patched. It returns the result, the normalised
ordered call log and a digest of the ordered calls, the return value and the memory read back.
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
TICK_SLOT = 0x52a23c
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl26aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl26a.h').read_text()
    body = re.search(r'typedef struct Fl26aWorld \{(.*?)\} Fl26aWorld;', text, re.S).group(1)
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


class Original20(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)])."""

    def _count(self, uc, address, size, user):
        """Records the executed instructions as od.Original does, and every (previous instruction, next instruction) pair of them: after a
        conditional jump the next address says which way it went. A stub entered in between does not break the pair (the call returns to
        the next instruction of the function)."""
        super()._count(uc, address, size, user)
        if not hasattr(self, 'edges'):
            self.edges = set()
        if getattr(self, 'last', None) is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        derefs = getattr(stub, 'derefs', None)
        deref_data = ()
        if derefs:
            esp = uc.reg_read(self._r['ESP'])
            deref_data = tuple(bytes(uc.mem_read(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n)) for arg, n in derefs)
        super()._stub_hook(uc, address, size, user)
        if deref_data:
            self.calls[before] = self.calls[before] + deref_data
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
SHAPES = {0x4db38a: (0, True, 0), 0x4e8d72: (0, True, 0), 0x4f0059: (0, True, 0), 0x4e075a: (0, True, 0), 0x4de322: (0, True, 0),
          0x4e77b8: (0, True, 0), 0x4e89eb: (0, True, 0), 0x4ebd85: (0, True, 0), 0x4e412d: (0, True, 0),
          0x4691ee: (1, True, 4), 0x4b3f98: (0, True, 0), 0x4b450f: (1, True, 4)}
# stack arguments that are pushed from 16-bit registers (only the low 16 bits are meaningful), by position
WORD_ARGS = {0x4691ee: (0,), 0x4b450f: (0,)}
RECORDS_VA = 0x5bb5e5
REC = 0x8d


def stub(callee, probe, results=None):
    nargs, this, cleanup = SHAPES[callee]
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)


def set_gate(d, kind, off, fail, rng):
    """nz32 / z32: a dword that must be non-zero / zero; nz8 / z8: the same for a byte (its neighbours are made non-zero so that a dword
    read instead of the byte would see them); weq: a word equal to a value."""
    if kind == 'nz32':
        put32(d, off, 0 if fail else rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]))
    elif kind == 'z32':
        put32(d, off, rng.choice([1, 0x100, 0x10000, 0x01000000, 0x80000000]) if fail else 0)
    elif kind in ('nz8', 'z8'):
        d[off] = rng.choice([1, 0x80, 0xff]) if (kind == 'nz8') != fail else 0
        d[off + 1:off + 4] = bytes(rng.randrange(1, 256) for _ in range(3))


def records(rng, idx, state_fail, target_va, decoy_va):
    """The record table with the records -1 .. 4 (one slack record below the table): the target holds the object address and the state
    (1, or a bad state when `state_fail`), every other record the decoy address and the state the guard does not accept."""
    rec = bytearray(rng.randbytes(6 * REC))
    for i in range(-1, 5):
        base = (i + 1) * REC
        put32(rec, base, target_va if i == idx else decoy_va)
        bad = rng.choice([0, 2, 3, 0xffffffff, 0x101, 0x10001])
        put32(rec, base + 0x4d, (bad if state_fail else 1) if i == idx else (1 if state_fail else 0))
    return Area('records', RECORDS_VA - REC, rec)


def common(key, rng, d, obj, idx, sel, state_fail, flag, stubs, extra=(), consts=(), g=None, pointers=None, **kw):
    """Assembles a scenario around the `self` bytes d and the record object bytes obj."""
    sp = SPECS[key]
    bias = kw.pop('obj_bias', 0)
    areas = [Area('self', od.region_va(0), d, image=False), records(rng, idx, state_fail, od.region_va(1) + bias, od.region_va(4)),
             Area('obj', od.region_va(1), obj, image=False), Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False)]
    ptrs = {'records_5bb5e5': ('records', REC), **(pointers or {})}
    for table, const in consts:
        areas.append(Area('c%x' % table, table, bytearray(const), compare=False))
        ptrs['bytes_%x' % table] = ('c%x' % table, 0)
    areas.extend(extra)
    gl = {k: v for k, v in {'value_5c39e5': sel, 'value_5bb1ca': flag}.items() if k in GLOBALS}
    gl.update(g or {})
    probes = [('self', o, ln) for o, ln in sp.get('probes', ())] + [('records', 0, 6 * REC)]
    for s in stubs.values():
        s.probe = s.probe if s.probe is not None else probes
    now = kw.pop('now')
    iat = {TICK_SLOT: od.Stub('tick', result=now)} if sp.get('tick') else {}
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat=iat, g=gl, ecx=od.region_va(0),
                           pointers=ptrs, word_args=WORD_ARGS, tick=now if sp.get('tick') else None, profile=kw.pop('profile', None), stack=kw.pop('stack', []), args=kw.pop('args', (0, 0)), **kw)


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
    for x in sc.stubs.values():
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in x.probe]
    runner = Original20(image_patches, regions, sc.stubs, sc.iat)
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
    """The original's call log as comparable lists: [callee or 'tick', ecx, *args (word arguments by their low 16 bits), probe]."""
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


def rect_into(rng, obj, x, y, offs, adj, hit):
    """Four signed dwords at offs = (ylo, yhi, xlo, xhi) such that the point (x, y) is inside the EFFECTIVE rectangle, often exactly on an
    edge (hit), or one effective edge misses it by one or more. `adj` is what the code adds to each stored edge before it compares (32-bit)."""
    m = lambda: rng.choice([0, 0, 1, 2, 9, rng.randrange(0, 100000)])
    eff = [y - m(), y + m(), x - m(), x + m()]
    if not hit:
        k = rng.randrange(4)
        eff[k] = (y if k < 2 else x) + (1 if k % 2 == 0 else -1) * rng.choice([1, 1, 2, 70000])
    for off, e, a in zip(offs, eff, adj):
        put32(obj, off, e - a)


def points(rng):
    xs = [-32768, -1, 0, 1, 2, 9, 255, 0x7fff, rng.randrange(-32768, 32768)]
    x, y = rng.choice(xs), rng.choice(xs)
    return x, y, [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]


EDGES = (None, 'e0', 'e1', 'e2', 'e3')
NZ32 = [1, 0x100, 0x10000, 0x01000000, 0xffffffff]


def edge_fail(rng, buf, x, y, offs, adj, fail):
    """Sets a rectangle (offs = ylo, yhi, xlo, xhi; adj = what the code adds to each stored edge) that holds the point, or (fail 'e0'..'e3')
    misses it at that one edge by one or more."""
    rect_into(rng, buf, x, y, offs, adj, True)
    if fail:
        e = int(fail[-1])
        eff = (y if e < 2 else x) + (1 if e % 2 == 0 else -1) * rng.choice([1, 1, 5])
        put32(buf, offs[e], eff - adj[e])


def wrap_edge(rng, buf, offs, e):
    """Makes the 32-bit `sub` / `add` of the edge e (adj -5, +5, -6, +10) wrap, so that the EFFECTIVE edge lies on the other side of the
    signed range and the point is outside (a 64-bit implementation would still find the point inside)."""
    stored = [0x80000000 + rng.randrange(0, 5), 0x7fffffff - rng.randrange(0, 5), 0x80000000 + rng.randrange(0, 6), 0x7ffffff6 + rng.randrange(0, 10)][e]
    put32(buf, offs[e], stored)


def make(key, areas, stubs, g, stack, args, profile, ecx=0x33333333, pointers=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat={}, g=g, ecx=ecx,
                           pointers=pointers or {}, word_args=WORD_ARGS, tick=None, profile=profile, stack=stack, args=args)


def profiles_4d3073():
    sels = [2, 3, 4, 5, 0, 1, 6, 7, 0x80000002, 0xffffffff, 0x7fffffff, 0x80000005]
    return [(s, f) for s in sels for f in (0, 1, 0x80, 0xff)]


def gen_4d3073(rng, n):
    (sel, flag), variant = prof(n, profiles_4d3073())
    probe = [('g:value_5a4c18', 0, 4), ('g:value_5c39e5', 0, 4), ('g:value_5b44f8', 0, 4)]
    stubs = {c: stub(c, probe) for c in (0x4db38a, 0x4e8d72, 0x4f0059, 0x4e075a, 0x4de322, 0x4e77b8, 0x4e89eb, 0x4ebd85, 0x4e412d)}
    g = {'value_583204': sel, 'byte_5a161f': flag, 'value_5a4c18': rng.choice([1, 0xffffffff, rng.randrange(1, 1 << 32)]),
         'value_5c39e5': rng.choice([0, 1, rng.randrange(0, 0xffffffff)]), 'value_5b44f8': rng.choice([1, 0x10000, rng.randrange(1, 1 << 32)])}
    neighbours = Area('nbr', 0x5a1620, bytearray(rng.randbytes(3) if variant % 2 == 0 else b'\xff\xff\xff'), compare=False)
    return make('4d3073', [neighbours], stubs, g, [], (0, 0), (sel, flag))


def profiles_469057():
    profiles = [('gate',)] + [('row', k, f) for k in range(6) for f in EDGES] + [('wrap', k, e) for k in (0, 5) for e in range(4)]
    profiles += [('overlap', 1, 4), ('overlap', 0, 5)]      # two rows hold the point: the first one wins (the callee gets its index), the later one is never looked at
    return profiles + [('tail', f) for f in EDGES] + [('tailwrap', e) for e in range(4)] + [('none',)]


def gen_469057(rng, n):
    (kind, *rest), variant = prof(n, profiles_469057())
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    adj = (-5, 5, -6, 10)
    d = bytearray(rng.randbytes(0x600))
    obj = bytearray(rng.randbytes(0x500))
    set_gate(d, 'nz32', 0x55c, kind == 'gate', rng)
    put16(d, 0x7e, idx)
    row = lambda k: (0x20 + 16 * k, 0x28 + 16 * k, 0x1c + 16 * k, 0x24 + 16 * k)
    tail = (0x35, 0x3d, 0x31, 0x39)
    for k in range(6):
        rect_into(rng, d, x, y, row(k), adj, kind == 'gate')
    if kind == 'row':
        edge_fail(rng, d, x, y, row(rest[0]), adj, rest[1])
    elif kind == 'wrap':
        edge_fail(rng, d, x, y, row(rest[0]), adj, None)
        wrap_edge(rng, d, row(rest[0]), rest[1])
    elif kind == 'overlap':
        for k in rest:
            edge_fail(rng, d, x, y, row(k), adj, None)
    if kind == 'tail':
        edge_fail(rng, obj, x, y, tail, adj, rest[0])
    elif kind == 'tailwrap':
        edge_fail(rng, obj, x, y, tail, adj, None)
        wrap_edge(rng, obj, tail, rest[0])
    else:
        rect_into(rng, obj, x, y, tail, adj, kind == 'gate' or bool(variant & 1))
    stubs = {0x4691ee: stub(0x4691ee, None)}
    return common('469057', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest), stack=stack, args=(x, y))


def profiles_4b42d3():
    profiles = [('gate',)] + [('row', k, f) for k in range(3) for f in EDGES]
    profiles += [('w750', v) for v in (1, 0xffff, 0x8000, 0x7fff, 0x80000001)] + [('w750z', v) for v in (0, 0x10000, 0xabcd0000)]
    profiles += [('overlap', 0, 2), ('overlap', 1, 2)]      # two rows hold the point: the first one wins
    return profiles + [('tail', f) for f in EDGES] + [('none',)]


def gen_4b42d3(rng, n):
    (kind, *rest), variant = prof(n, profiles_4b42d3())
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    adj = (0, 0, 0, 0)
    d = bytearray(rng.randbytes(0x800))
    obj = bytearray(rng.randbytes(0x900))
    set_gate(d, 'nz32', 0x76e, kind == 'gate', rng)
    put16(d, 0x728, idx)
    put32(d, 0x750, rest[0] if kind in ('w750', 'w750z') else rng.choice([0, 0x10000, 0xffff0000, 0x30000]))
    row = lambda k: (0xed + 16 * k, 0xf5 + 16 * k, 0xe9 + 16 * k, 0xf1 + 16 * k)
    tail = (0x8a2, 0x8aa, 0x89e, 0x8a6)
    for k in range(3):
        rect_into(rng, obj, x, y, row(k), adj, kind == 'gate')
    if kind == 'row':
        edge_fail(rng, obj, x, y, row(rest[0]), adj, rest[1])
    elif kind == 'overlap':
        for k in rest:
            edge_fail(rng, obj, x, y, row(k), adj, None)
    if kind == 'tail':
        edge_fail(rng, obj, x, y, tail, adj, rest[0])
        put32(d, 0x750, rng.choice([0, 0x10000]))
    else:
        rect_into(rng, obj, x, y, tail, adj, kind in ('gate', 'w750', 'w750z') or bool(variant & 1))
    rect = bytearray(rng.randbytes(16))
    stubs = {c: stub(c, [('self', 0, 0x800), ('records', 0, 6 * REC)]) for c in (0x4b3f98, 0x4b450f)}
    return common('4b42d3', rng, d, obj, idx, 0, False, 0, stubs, extra=[Area('rect', od.region_va(5), rect, image=False)], now=0, profile=(kind, *rest),
                  stack=[stack[0], stack[1], od.region_va(5)], args=(x, y, od.region_va(5)))


ROWS_4897CD = 4
TARGETS_4897CD = [(0, 0), (0, 2), (1, 1), (2, 0), (2, 3)]
FAULTS_4897CD = (None, 'flag', 'state', 'w0', 'w4', 'e0', 'e1', 'e2', 'e3')
BAD_STATES = [0, 2, 3, 0x101, 0x10001, 0xffffffff, 0x80000001]


def profiles_4897cd():
    profiles = [('gate',)] + [('count', c) for c in (-1, 0x80000000, 0xffffffff, 0x10000)]
    profiles += [('target', t, f) for t in TARGETS_4897CD for f in FAULTS_4897CD]
    profiles += [('nrows', c) for c in (0, -1, -32768, 0xffff)] + [('none',)]
    profiles += [('orows', 0, 1), ('orows', 1, 3), ('oobjs', 0, 2), ('oobjs', 1, 2)]      # two rows of one object / two objects hold the point: the first one wins
    profiles += [('ann', s, b) for s in (-1, 0, 5, 0x7fff, -2, -32768) for b in (0, 1, 0x10000, 0x80000000)]
    return profiles


def row_offs(r):
    b = 0x6ec + 0x26 * r
    return (b + 0x1a, b + 0x22, b + 0x16, b + 0x1e)


def gen_4897cd(rng, n):
    """kinds: gate (count 0), count (a count whose signed value is not positive: the loop is not entered), target (object t, row j holds the
    point, with one fault), nrows (the row count word of the target is not positive), none (every row misses), ann (the announcement
    globals: the word 0x583a29 and the dword 0x5b44f8 take every combination)."""
    (kind, *rest), variant = prof(n, profiles_4897cd())
    x, y, stack = points(rng)
    t, j = rest[0] if kind == 'target' else (1, rest[0]) if kind == 'orows' else (rest[0], 0) if kind == 'oobjs' else rng.choice(TARGETS_4897CD) if kind != 'ann' else (1, 2)
    fault = rest[1] if kind == 'target' else None
    d = bytearray(rng.randbytes(0x100))
    if kind == 'gate':
        count = 0
    elif kind == 'count':
        count = rest[0]
    elif kind in ('target', 'ann', 'nrows', 'orows'):
        count = max(t + 1, rng.choice([1, 2, 3, 3]))
    elif kind == 'oobjs':
        count = 3
    else:
        count = rng.choice([1, 2, 3])
    put32(d, 0xcc, count)
    if 0 < count < 0x100 and variant % 2:
        d[0xd0] = 0      # (the dword at +0xcd is then zero too: a gate that read the count one byte off would see an empty list)
    rec_indices = rng.sample([-1, 0, 1, 2, 3, 4], 3)
    objs = [bytearray(rng.randbytes(0xb00)) for _ in range(3)]
    states = {r: rng.choice(BAD_STATES) for r in range(-1, 5)}
    w5bb50b = rng.choice([0, 1, -1, 0x7fff, -32768, 5])
    everything_hits = kind in ('gate', 'count')
    for k in range(3):
        o = objs[k]
        put32(d, 0x2c + 4 * k, od.region_va(1 + k))
        put16(o, 0xab0, rec_indices[k])
        put32(o, 0xab2, rng.choice(NZ32))
        states[rec_indices[k]] = 1
        rows = rng.choice([1, 2, 3, 4]) if k != t else max(j + 1, rng.choice([1, 2, 3, 4]))
        if kind == 'nrows' and k == t:
            rows = rest[0] - (1 << 16) if rest[0] >= 0x8000 else rest[0]
        struct.pack_into('<h', o, 0xaa, rows)
        for r in range(ROWS_4897CD):
            b = 0x6ec + 0x26 * r
            put16(o, b, w5bb50b)
            put16(o, b + 4, 1)
            rect_into(rng, o, x, y, row_offs(r), (0, 0, 0, 0), everything_hits or (kind == 'nrows' and k == t))
        if k != t and kind in ('target', 'ann', 'nrows', 'none') and k < t:      # an object before the target that the loop skips, for one reason
            reason = ['flag', 'state', 'rows0', 'miss', 'w0', 'w4'][(variant + k) % 6]
            if reason == 'flag':
                put32(o, 0xab2, 0)
            elif reason == 'state':
                states[rec_indices[k]] = rng.choice(BAD_STATES)
            elif reason == 'rows0':
                struct.pack_into('<h', o, 0xaa, rng.choice([0, -1, -32768]))
            else:
                for r in range(ROWS_4897CD):               # every row would hit but for one fault
                    b = 0x6ec + 0x26 * r
                    rect_into(rng, o, x, y, row_offs(r), (0, 0, 0, 0), True)
                    if reason == 'w0':
                        put16(o, b, w5bb50b + rng.choice([1, -1, 0x4000, 0x8000]))
                    else:
                        put16(o, b + 4, rng.choice([0, 2, -1, 0x7fff, -32768, 3]))
    if kind in ('target', 'ann'):
        o = objs[t]
        b = 0x6ec + 0x26 * j
        rect_into(rng, o, x, y, row_offs(j), (0, 0, 0, 0), True)
        if fault in ('e0', 'e1', 'e2', 'e3'):
            edge_fail(rng, o, x, y, row_offs(j), (0, 0, 0, 0), fault)
        elif fault == 'flag':
            put32(o, 0xab2, 0)
        elif fault == 'state':
            states[rec_indices[t]] = rng.choice(BAD_STATES)
        elif fault == 'w0':
            put16(o, b, w5bb50b + rng.choice([1, -1, 0x4000, 0x8000]))
        elif fault == 'w4':
            put16(o, b + 4, rng.choice([0, 2, -1, 0x7fff, -32768, 3]))
    if kind == 'orows':
        struct.pack_into('<h', objs[t], 0xaa, 4)
        for r in rest:
            rect_into(rng, objs[t], x, y, row_offs(r), (0, 0, 0, 0), True)
    elif kind == 'oobjs':
        for k in rest:
            rect_into(rng, objs[k], x, y, row_offs(0), (0, 0, 0, 0), True)
    # stray junk beside the compared words (the bytes next to each compared word)
    for o in objs:
        for r in range(ROWS_4897CD):
            b = 0x6ec + 0x26 * r
            put16(o, b + 2, rng.randrange(0x10000))
            put16(o, b + 6, rng.randrange(0x10000))
    rec = bytearray(rng.randbytes(6 * REC))
    for r in range(-1, 5):
        put32(rec, (r + 1) * REC, od.region_va(4))
        put32(rec, (r + 1) * REC + 0x4d, states[r])
    sel, b44f8 = (rest[0], rest[1]) if kind == 'ann' else (rng.choice([-1, 0, 7, -2, 0x7fff]), rng.choice([0, 0, 1, 0x10000]))
    g = {'value_5c39e5': rng.randrange(1 << 32), 'value_5b44f0': rng.randrange(1 << 32), 'value_5b44f4': rng.randrange(1 << 32),
         'value_5b44f8': b44f8 & 0xffffffff, 'value_5d0377': rng.randrange(1 << 32), 'value_5d162d': rng.randrange(1 << 32),
         'value_5d1631': rng.randrange(1 << 32), 'value_5d1639': rng.randrange(1 << 32), 'value_571ad3': rng.randrange(1 << 32),
         'word_583a29': sel & 0xffff, 'word_5bb50b': w5bb50b & 0xffff}
    areas = [Area('self', od.region_va(0), d, image=False), Area('records', RECORDS_VA - REC, rec)]
    for k in range(3):
        areas.append(Area('obj%d' % k, od.region_va(1 + k), objs[k], image=False))
    areas.append(Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False))
    return make('4897cd', areas, {}, g, stack, (x, y), (kind, *rest), ecx=od.region_va(0), pointers={'records_5bb5e5': ('records', REC)})


SPECS = {
    '4d3073': dict(id=1, va=0x4d3073, size=196, code=180, gen=gen_4d3073, cleanup=0, n=len(profiles_4d3073()) * 3),
    '469057': dict(id=2, va=0x469057, size=407, gen=gen_469057, ret=True, cleanup=8, probes=[(0, 0x600)], n=len(profiles_469057()) * 6),
    '4b42d3': dict(id=3, va=0x4b42d3, size=572, gen=gen_4b42d3, ret=True, cleanup=12, probes=[(0, 0x800)], n=len(profiles_4b42d3()) * 6),
    '4897cd': dict(id=4, va=0x4897cd, size=509, gen=gen_4897cd, ret=True, cleanup=8, n=len(profiles_4897cd()) * 4),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
