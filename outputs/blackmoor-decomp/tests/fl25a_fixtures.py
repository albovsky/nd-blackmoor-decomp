"""FL-25 (batch a): the fixtures shared by tests/test_fl25a_differential.py and tests/fl25a_original_oracle.py.

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
    """The fields of Fl25aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl25a.h').read_text()
    body = re.search(r'typedef struct Fl25aWorld \{(.*?)\} Fl25aWorld;', text, re.S).group(1)
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
        super()._stub_hook(uc, address, size, user)
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
SHAPES = {0x45e4d4: (1, True, 4), 0x46465d: (0, True, 0), 0x464ab5: (2, True, 8), 0x4a8007: (0, True, 0), 0x4a8697: (3, True, 12)}
# stack arguments that are pushed from 16-bit registers (only the low 16 bits are meaningful), by position
WORD_ARGS = {0x464ab5: (1,)}
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
    areas = [Area('self', od.region_va(0), d, image=False), records(rng, idx, state_fail, od.region_va(1), od.region_va(4)),
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
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in x.probe]
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
        wa = word_args.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out


# ---- the scenario generators ------------------------------------------------------------------------------------------------------


def nine(rng, variant, active, const, obj, off):
    """Writes the nine-byte compare of the arm that runs: equal, or different at byte `position` (-1 equal, 0..8, 9 = not compared)."""
    position = ((variant >> 1) % 11) - 1
    if not active:
        return
    obj[off:off + 9] = const
    if 0 <= position <= 8:
        obj[off + position] ^= rng.choice([1, 0x40, 0x80, 0xff])
    elif position == 9:
        obj[off + 9] ^= 0x40


def results(rng, variant, shift):
    """The scripted answer of 0x4f6334: zero, or non-zero on every fourth pass."""
    return [0 if (variant >> shift) % 4 != 3 else rng.choice([1, 5, 0x10000, 0x80000000])]


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


def gen_45e1ca(rng, n):
    # profiles: the gate byte clear; other values of the dword [+0x39e] (tail only); the tail alone with each edge missing; arm A (byte [+0x3ae] set)
    # with row k holding the point or missing one edge or failing the word test; arm B (byte clear) with row (j, k) likewise plus the dword test
    profiles = [('gate',)] + [('tail', m) for m in (0, 3, 5, 0x10004, 0x100, 0xffffffff, 4)] + [('tailedge', e) for e in range(4)]
    profiles += [('A', k, f) for k in range(3) for f in (None, 'e0', 'e1', 'e2', 'e3', 'w')] + [('A', None, None)]
    profiles += [('B', (j, k), f) for j in range(3) for k in range(2) for f in (None, 'e0', 'e1', 'e2', 'e3', 'd', 'w')] + [('B', None, None)]
    (kind, *rest), variant = prof(n, profiles)
    x, y, stack = points(rng)
    arm = kind if kind in ('A', 'B') else None
    d = bytearray(rng.randbytes(0x3c0))
    p = bytearray(rng.randbytes(0x1400))
    set_gate(d, 'nz8', 0x321, kind == 'gate', rng)
    put32(d, 0x31d, od.region_va(1))
    put32(d, 0x39e, 4 if arm else rest[0] if kind == 'tail' else rng.choice([0, 3, 5, 4 + (1 << 16)]) if kind != 'tailedge' else rng.choice([4, 4 + (1 << 24), 0]))
    set_gate(d, 'nz8' if arm == 'A' or arm is None else 'z8', 0x3ae, False, rng)
    target = rest[0] if arm else None
    fail = rest[1] if arm else None
    if arm and target is None:
        count = rng.choice([0, -1, -32768, 0, 1, 2])
    elif arm:
        row = target if arm == 'A' else target[1]
        count = max(rng.choice([1, 2, 3, 4]), row + 1)
    else:
        count = rng.choice([0, 1, 3, -1, 2, 4])
    struct.pack_into('<h', p, 0x25, count)
    rows = 4
    for i in range(rows):
        struct.pack_into('<h', d, 0x214 + 2 * i, rng.choice([1, 2, 1, 2, 0, -1, 3, 7, -32768, 0x7fff]))
    for j in range(3):
        for i in range(rows):
            put32(d, 0x144 + 0x34 * j + 4 * i, rng.choice([1, 1, 0, 2, rng.randrange(1 << 32)]))
    for i in range(rows):                                            # loop A rows (y low, y high, x low, x high)
        rect_into(rng, p, x, y, (0x657 + 16 * i, 0x65f + 16 * i, 0x653 + 16 * i, 0x65b + 16 * i), (0, 0, 0, 0), False)
    for j in range(3):
        for i in range(rows):                                        # loop B rows: x low +0, y low +4, x high +8, y high +0xc
            b = 0x723 + 0xd0 * j + 16 * i
            rect_into(rng, p, x, y, (b + 4, b + 0xc, b, b + 8), (0, 0, 0, 0), False)
    if arm:
        if target is not None:
            if arm == 'A':
                i, offs = target, (0x657 + 16 * target, 0x65f + 16 * target, 0x653 + 16 * target, 0x65b + 16 * target)
                wvalid = rng.choice([1, 2])
                wbad = rng.choice([0, -1, 3, 4, 0x7fff, -32768])
            else:
                j, i = target
                b = 0x723 + 0xd0 * j + 16 * i
                offs = (b + 4, b + 0xc, b, b + 8)
                wvalid = rng.choice([-32768, -3, -1, 0, 1, 2])
                wbad = rng.choice([3, 4, 0x7fff])
                put32(d, 0x144 + 0x34 * j + 4 * i, rng.choice([0, 2, 0x10001, 0x100, 0xffffffff]) if fail == 'd' else 1)
            rect_into(rng, p, x, y, offs, (0, 0, 0, 0), True)
            if fail and fail.startswith('e'):
                miss_edge = int(fail[1])
                put32(p, offs[miss_edge], (y if miss_edge < 2 else x) + (1 if miss_edge % 2 == 0 else -1) * rng.choice([1, 1, 5]))
            struct.pack_into('<h', d, 0x214 + 2 * i, wbad if fail == 'w' else wvalid)
    tail_hit = kind == 'tail' and rest[0] != 4 or kind == 'gate' or (arm is not None and rng.random() < 0.5)
    tail_hit = tail_hit or (kind == 'tail' and rest[0] == 4)
    rect_into(rng, p, x, y, (0x133a, 0x1342, 0x1336, 0x133e), (0, 0, 0, 0), tail_hit and kind != 'tailedge')
    stubs = {0x45e4d4: stub(0x45e4d4, None)}
    return common('45e1ca', rng, d, p, 0, 0, False, 0, stubs, now=0, profile=(kind, *rest), stack=stack, args=(x, y))


def edge_fail(rng, obj, x, y, offs, fail):
    """Sets a rectangle that holds the point, or (fail 'e0'..'e3': y low, y high, x low, x high) misses it at that one edge by one or more."""
    rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), True)
    if fail:
        e = int(fail[-1])
        put32(obj, offs[e], (y if e < 2 else x) + (1 if e % 2 == 0 else -1) * rng.choice([1, 1, 5]))


NZ32 = [1, 0x100, 0x10000, 0x01000000, 0xffffffff]


def gen_464792(rng, n):
    edges = (None, 'e0', 'e1', 'e2', 'e3')
    profiles = [('gate',)] + [('n', r, f) for r in (1, 2, 3) for f in edges] + [('z', c, f) for c in ('c1', 'c2', 'c5') for f in edges]
    profiles += [('zmiss', c) for c in ('c3', 'c4', 'c5b', 'c6')]
    for k in (0, 1, 4):
        profiles += [('loop', 0, k, kd) for kd in ('hit0', 'e0', 'e1', 'e2', 'e3', 'nz_no2a', 'none')]
        profiles += [('loop', 1, k, kd) for kd in ('hit0', 'e0', 'e1', 'e2', 'e3', 'nzhit', 'nze0', 'nze1', 'nze2', 'nze3', 'none')]
    assert len(profiles) == 89
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0x100))
    obj = bytearray(rng.randbytes(0x500))
    set_gate(d, 'nz32', 0xb8, kind == 'gate', rng)
    put16(d, 0x1e, idx)
    mode2a = {'n': 0, 'z': 1, 'zmiss': 1, 'loop': rest[0] if kind == 'loop' else 0}.get(kind, rng.choice([0, 1]))
    set_gate(d, 'nz32' if mode2a else 'z32', 0x2a, False, rng)
    w36, w8a, d8c = rng.choice([0, 1, -5, 0x7fff, -32768]), rng.choice([0, 1, -1, 0x7fff, -32768]), rng.choice([0, *NZ32])
    cond = rest[0] if kind in ('z', 'zmiss') else 'c3'
    if cond == 'c1':
        w36, w8a = 0, 0
    elif cond == 'c2':
        w36 = rng.choice([1, 2, 5, -1, 0x7fff, -2])
        w8a, d8c = w36 - 1, 0
    elif cond == 'c5':
        w36, w8a, d8c = 0, -1, 0
    elif cond == 'c3':
        w36 = rng.choice([1, -1, 7, -32768, 0x7fff])
        w8a, d8c = rng.choice([w36 - 1 if w36 > -32768 else 0, w36, 0]), rng.choice(NZ32)
    elif cond == 'c4':
        w36 = rng.choice([1, -1, 7, 0x7fff])
        w8a, d8c = rng.choice([w36, w36 - 2, w36 + 1 if w36 < 0x7fff else 0, 0, -32768]), 0
    elif cond == 'c5b':
        w36, w8a, d8c = 0, rng.choice([1, -2, 0x7fff, -32768]), 0
    elif cond == 'c6':
        w36, w8a, d8c = -32768, 0x7fff, 0
    put16(d, 0x36, w36)
    put16(d, 0x8a, w8a)
    put32(d, 0x8c, d8c)
    for k in range(5):
        put32(d, 0x94 + 4 * k, rng.choice([0, *NZ32]))
    fixed = {1: (0x25, 0x2d, 0x21, 0x29), 2: (0x35, 0x3d, 0x31, 0x39), 3: (0x433, 0x43b, 0x42f, 0x437), 'z': (0x45, 0x4d, 0x41, 0x49)}
    row = lambda k: (0x65 + 32 * k, 0x6d + 32 * k, 0x61 + 32 * k, 0x69 + 32 * k)
    for offs in [*fixed.values(), *[row(k) for k in range(5)]]:
        rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), False)
    if kind == 'n':
        edge_fail(rng, obj, x, y, fixed[rest[0]], rest[1])
    elif kind == 'z':
        edge_fail(rng, obj, x, y, fixed['z'], rest[1])
    elif kind == 'zmiss':
        rect_into(rng, obj, x, y, fixed['z'], (0, 0, 0, 0), True)      # (the rectangle holds the point: only the condition keeps it out)
    elif kind == 'gate':
        for offs in [*fixed.values(), row(0)]:
            rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), True)
    elif kind == 'loop':
        _, k, kd = rest
        for offs in fixed.values():
            rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), False)
        if kd == 'none':
            pass
        else:
            put32(d, 0x94 + 4 * k, rng.choice(NZ32) if kd.startswith('nz') else 0)
            edge_fail(rng, obj, x, y, row(k), kd[-2:] if kd[-2] == 'e' else None)
            if kd == 'nz_no2a':
                rect_into(rng, obj, x, y, row(k), (0, 0, 0, 0), True)
    rect = bytearray(rng.randbytes(16))
    stubs = {c: stub(c, [('self', 0, 0x100), ('records', 0, 6 * REC)]) for c in (0x46465d, 0x464ab5)}
    return common('464792', rng, d, obj, idx, 0, False, 0, stubs, extra=[Area('rect', od.region_va(5), rect, image=False)], now=0, profile=(kind, *rest),
                  stack=[stack[0], stack[1], od.region_va(5)], args=(x, y, od.region_va(5)))


def gen_4a835c(rng, n):
    edges = ('hit', 'e0', 'e1', 'e2', 'e3')
    targets = [(0, 0), (0, 1), (1, 0), (1, 2), (2, 1)]
    profiles = [('gate', None, None)]
    for mode in ('U', 'S'):
        profiles += [(mode, t, f) for t in targets for f in edges] + [(mode, 'none_c1', None), (mode, 'none_c2', None)]
    profiles += [('tail', None, f) for f in ('hit', 'e0', 'e1', 'e2', 'e3')]
    assert len(profiles) == 60
    (kind, target, fail), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0x1200))
    obj = bytearray(rng.randbytes(0x500))
    set_gate(d, 'nz32', 0xe72, kind == 'gate', rng)
    put16(d, 0x1e, idx)
    set_gate(d, 'nz32' if kind == 'U' else 'z32', 0xe5e, False, rng)
    if isinstance(target, tuple):
        c1, c2 = max(rng.choice([1, 2, 3]), target[0] + 1), max(rng.choice([1, 2, 3, 4]), target[1] + 1)
    elif target == 'none_c1':
        c1, c2 = rng.choice([0, -1, -32768]), rng.choice([1, 2])
    elif target == 'none_c2':
        c1, c2 = rng.choice([1, 2]), rng.choice([0, -1, -32768])
    else:
        c1, c2 = rng.choice([0, 1, 2, 3, -1]), rng.choice([0, 1, 2, 3, -1])
    struct.pack_into('<h', obj, 0x43, c1)
    struct.pack_into('<h', obj, 0x45, c2)
    row = lambda i, j: (0xe94 + 0x90 * i + 16 * j + 4, 0xe94 + 0x90 * i + 16 * j + 0xc, 0xe94 + 0x90 * i + 16 * j, 0xe94 + 0x90 * i + 16 * j + 8)
    for i in range(4):
        for j in range(5):
            rect_into(rng, d, x, y, row(i, j), (0, 0, 0, 0), False)
    if isinstance(target, tuple):
        edge_fail(rng, d, x, y, row(*target), None if fail == 'hit' else fail)
    tail = (0x43e, 0x446, 0x43a, 0x442)
    if kind == 'tail':
        edge_fail(rng, obj, x, y, tail, None if fail == 'hit' else fail)
    elif kind == 'gate' or isinstance(target, tuple):
        rect_into(rng, obj, x, y, tail, (0, 0, 0, 0), True)
    else:
        rect_into(rng, obj, x, y, tail, (0, 0, 0, 0), bool(variant & 1))
    if kind == 'gate':
        for i in range(4):
            for j in range(5):
                rect_into(rng, d, x, y, row(i, j), (0, 0, 0, 0), True)
    rect = bytearray(rng.randbytes(16))
    g = {name: rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)]) for name in
         ('value_5b44f0', 'value_5b44f4', 'value_5d0377', 'value_5d162d', 'value_5d1631', 'value_5d1639')}
    stubs = {c: stub(c, [('self', 0xe00, 0x300), ('records', 0, 6 * REC)]) for c in (0x4a8007, 0x4a8697)}
    return common('4a835c', rng, d, obj, idx, 0, False, 0, stubs, extra=[Area('rect', od.region_va(5), rect, image=False)], now=0, profile=(kind, target, fail),
                  stack=[stack[0], stack[1], od.region_va(5)], args=(x, y, od.region_va(5)), g=g)


# the functions: id (the shim number), va, size from the ledger, the object-window probes of the call logs, whether GetTickCount is
# imported, whether the function returns a value (compared), the bytes it pops, the generator
SPECS = {
    '45e1ca': dict(id=1, va=0x45e1ca, size=778, gen=gen_45e1ca, ret=True, cleanup=8, probes=[(0, 0x3c0)], n=74 * 6),
    '464792': dict(id=2, va=0x464792, size=803, gen=gen_464792, ret=True, cleanup=12, probes=[(0, 0x100)], n=89 * 6),
    '4a835c': dict(id=3, va=0x4a835c, size=827, gen=gen_4a835c, ret=True, cleanup=12, probes=[(0xe00, 0x300)], n=60 * 6),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
