"""FL-25 (batch d): the fixtures shared by tests/test_fl25d_differential.py and tests/fl25d_original_oracle.py.

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
    """The fields of Fl25dWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl25d.h').read_text()
    body = re.search(r'typedef struct Fl25dWorld \{(.*?)\} Fl25dWorld;', text, re.S).group(1)
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
SHAPES = {0x4fb2e3: (1, True, 4), 0x4afec1: (1, True, 4), 0x4b2917: (1, True, 4)}
# stack arguments that are pushed from 16-bit registers (only the low 16 bits are meaningful), by position
WORD_ARGS = {0x4afec1: (0,), 0x4b2917: (0,)}
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
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat=iat, g=gl, ecx=od.region_va(0) + kw.get('self_bias', 0),
                           pointers=ptrs, word_args=WORD_ARGS, tick=now if sp.get('tick') else None, profile=kw.pop('profile', None), stack=kw.pop('stack', []), self_bias=kw.pop('self_bias', 0), args=kw.pop('args', (0, 0)), **kw)


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
UNTAKEN_ALLOWED = {
    '4712bd': {(0x4714dd, 'taken'): 'jne 0x4715ee tests the byte [R+0x23] again at 0x4714d8, reached only from the je at 0x471424 that tested the same byte '
                                    'with no store of any kind in between: it cannot be taken'},
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


def edge_fail(rng, obj, x, y, offs, fail):
    """Sets a rectangle that holds the point, or (fail 'e0'..'e3': y low, y high, x low, x high) misses it at that one edge by one or more."""
    rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), True)
    if fail:
        e = int(fail[-1])
        put32(obj, offs[e], (y if e < 2 else x) + (1 if e % 2 == 0 else -1) * rng.choice([1, 1, 5]))


NZ32 = [1, 0x100, 0x10000, 0x01000000, 0xffffffff]


def gen_4712bd(rng, n):
    # profiles: each gate failing; a selector that is neither event; slot 0x28; the three arms of the selector 0x27a6 with their sub-cases. The tail
    # (the list at +0xdc2, the flag and the nine-byte compare, the byte [R+0x24], the selector 0x27ad) varies with the pass number.
    profiles = [('g1',), ('g2',), ('g3',)] + [('sel', v) for v in (0, 0x27a5, 0x27a7, 0x27ad)] + [('s28', v) for v in (0x27a6, 0x27ad, 0)]
    profiles += [('arm1', d32, hit) for d32 in (-4, 0, 1, 2, 5) for hit in (True, False)]
    profiles += [('arm2', d32, m) for d32, m in ((0, 3), (1, 3), (2, 3), (3, 3), (4, 3), (5, 2), (-2, 1), (0, 0), (0, -1), (32767, 3))] + [('arm2', 'alias', 3)]
    profiles += [('arm3', 'b1', 0, 0)] + [('arm3', 'b0', d01, d32) for d01 in (-1, 0, 1, 2, 3, 6) for d32 in (-1, 2, 7)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    d = bytearray(rng.randbytes(0x1000))
    obj = bytearray(rng.randbytes(0x200))
    set_gate(d, 'nz8', 0xd3e, kind == 'g1', rng)
    set_gate(d, 'z32', 0xd2c, kind == 'g2', rng)
    put16(d, 0xd28, idx)
    slot = rng.choice([0, 1, 2, 5, 0x27, 0x29, 0x30, -1, 0x39])
    sel = 0x27a6
    if kind == 'sel':
        sel = rest[0]
        slot = rng.choice([0x28, 0x28, slot])
    elif kind == 's28':
        sel, slot = rest[0], 0x28
    elif kind in ('g1', 'g2', 'g3'):
        sel = rng.choice([0x27a6, 0x27ad])
        slot = rng.choice([0x28, slot])
    m = rng.choice([-1, 0, 1, 2, 3, 5])
    c = rng.choice([1, 0x80, 0xff, 7])
    b = rng.choice([0, 1, 0x80, 0xff])
    d32 = rng.choice([-3, 0, 1, 2, 4])
    d01 = rng.choice([-1, 0, 1, 2, 3, 6])
    words_t = None
    if kind == 'arm1':
        d32 = rest[0]
        b = rng.choice([1, 0x80, 0xff])
        words_t = (max(d32 - 1, 0), rest[1])
    elif kind == 'arm2':
        b, c = 0, rng.choice([1, 0x80, 0xff, 7])
        if rest[0] == 'alias':
            slot, d32, m = 0x36, -60, 3
        else:
            d32, m = rest
    elif kind == 'arm3':
        c = 0
        b = rng.choice([1, 0x80, 0xff]) if rest[0] == 'b1' else 0
        d01, d32 = rest[1], rest[2]
        if rest[0] == 'b1':
            d32 = rng.choice([-1, 2])
    # the tail: the list at +0xdc2
    e06 = rng.choice([1, 5, 0x100, 0x7fff, 0, -1, -32768, 0x0100 - 0x10000])
    d30 = (m - 1) + rng.choice([-3, -2, -1, 0, 0, 1, 2])
    d30 = max(-4, min(8, d30))
    r24 = rng.choice([0, 1, 0x80, 0xff]) if (variant % 3) else 0
    flag = 1 if variant % 4 else 0
    put16(d, 0xd2a, slot)
    put16(d, 0xd32, d32)
    put16(d, 0xd30, d30)
    put16(d, 0xe06, e06)
    put16(d, 0xd01, d01)
    for j in range(-6, 14):
        put16(d, 0xd4a + 2 * j, rng.choice([0, 1, 0x28, 0x10000 - 1, rng.randrange(0x10000)]))
    d[0xc9c:0xc9c + 0x40] = rng.randbytes(0x40)
    # the byte [+0xc9c + slot] (b); its neighbours are made non-zero so that a wider read would see them
    d[0xc9c + slot] = b
    for o in (-1, 1):
        d[0xc9c + slot + o] = rng.choice([1, 0x80, 0xff])
    if kind == 'arm2' and rest[0] == 'alias':
        d[0xcd2] = 0
    if words_t is not None:
        put16(d, 0xd4a + 2 * words_t[0], slot if words_t[1] else (slot + 1 + rng.choice([0, 0x100, 0x7ff0])) & 0xffff)
    struct.pack_into('<h', obj, 0x21, m)
    obj[0x23] = c
    obj[0x24] = r24
    obj[0x25:0x28] = rng.randbytes(3)
    put16(obj, 0x87, rng.randrange(0x10000))
    c1, c2 = rng.randbytes(9), rng.randbytes(9)
    nine(rng, variant, True, c2 if slot == 0x28 else c1, obj, 0x66)
    # the stub of 0x4fb2e3 (this = 0x5c3a67, one dword argument)
    stubs = {0x4fb2e3: stub(0x4fb2e3, None)}
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
    return common('4712bd', rng, d, obj, idx, sel, kind == 'g3', flag, stubs, consts=[(0x54c480, c1), (0x54c48c, c2)], now=now, profile=(kind, *rest))


def s32(v):
    v &= 0xffffffff
    return v - (1 << 32) if v & 0x80000000 else v


class Model:
    """The bytes of an object plus the set of bytes that a scenario has already decided: `cond` reads a dword at `off` (relative to `base`) and, when it is
    still undecided, picks a value for it that makes the comparison `val OP (field + adj)` come out as `want` (random values and edge offsets of 0, 1,
    2, 5, 70000 and 2^30 from the boundary). A decided dword keeps its value (the outcome is then whatever the original will compute)."""

    def __init__(self, buf, base, rng):
        self.buf, self.base, self.rng, self.known = buf, base, rng, set()

    def is_known(self, off, ln):
        return all((self.base + off + i) in self.known for i in range(ln))

    def put(self, off, ln, v):
        fmt = {1: '<B', 2: '<H', 4: '<I'}[ln]
        struct.pack_into(fmt, self.buf, self.base + off, v & ((1 << (8 * ln)) - 1))
        self.known.update(range(self.base + off, self.base + off + ln))

    def get(self, off, signed=True):
        return struct.unpack_from('<i' if signed else '<I', self.buf, self.base + off)[0]

    def cond(self, off, val, op, adj, want):
        if want is None:
            want = self.rng.random() < 0.5
        if not self.is_known(off, 4):
            k = self.rng.choice([0, 0, 1, 2, 5, 70000, 1 << 30])
            if op == '>=':       # holds iff val >= f + adj
                f = val - adj - k if want else val - adj + 1 + k
            else:                # holds iff val <= f + adj
                f = val - adj + k if want else val - adj - 1 - k
            self.put(off, 4, f)
        total = s32(self.get(off) + adj)
        return val >= total if op == '>=' else val <= total


def div4(v):
    return (v + (3 if v < 0 else 0)) >> 2


def gen_4b2250(rng, n):
    BIAS = 0x400
    profiles = [('gate', 1), ('gate', 2), ('gate', 3)]
    profiles += [('post', byte, f) for byte in (0, 1) for f in (None, 0, 1, 2, 3)]
    profiles += [('Z', f, pos) for f in (None, 0, 1, 2, 3) for pos in ((0, 0), (1, 2))]
    profiles += [('T5', mask, pos) for mask in range(16) for pos in ((0, 0), (1, 2))]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    gx, gy = (rng.choice([0, 0, 1, -1, 100, -200, 70000, -70000, rng.randrange(-1 << 20, 1 << 20)]) for _ in range(2))
    X, Y = s32(x + gx), s32(y + gy)
    d = bytearray(rng.randbytes(BIAS + 0x1600))
    obj = bytearray(rng.randbytes(0x1000))
    S, O = Model(d, BIAS, rng), Model(obj, 0, rng)
    put16(d, BIAS + 0x1e, idx)
    set_gate(d, 'nz32', BIAS + 0x1515, kind == 'gate' and rest[0] == 1, rng)
    if kind == 'gate' and rest[0] in (2, 3):
        put32(d, BIAS + 0x24, {2: 2, 3: 1}[rest[0]])
    else:
        put32(d, BIAS + 0x24, rng.choice([0, 3, 0x102, 0x101, 0xffffffff, 0x10001, 0x80000002]))
    raw1 = rng.choice([0, 1, 3, 4, 7, 8, 100, -1, -3, -4, -5, -8, -101, 0x7fffffff, -0x80000000, rng.randrange(-1000, 1000)])
    raw2 = rng.choice([0, 1, 3, 4, 7, 8, 100, -1, -3, -4, -5, -8, -101, 0x7fffffff, -0x80000000, rng.randrange(-1000, 1000)])
    put32(d, BIAS + 0x152d, raw1)
    put32(d, BIAS + 0x1529, raw2)
    q1, q2 = div4(raw1), div4(raw2)
    for off in (0x1531, 0x1533):
        put16(d, BIAS + off, rng.choice([1, 0x100, 0xffff, 0x8000, rng.randrange(1, 0x10000)]))
    pos = rest[-1] if kind in ('Z', 'T5') else None
    if kind in ('Z', 'T5'):
        w21, w23 = pos[0] + 1 + rng.choice([0, 1]), pos[1] + 1 + rng.choice([0, 1])
    elif kind == 'post':
        w21, w23 = rng.choice([-1, 0, 1, 2]), rng.choice([-1, 0, 1, 2, 3])
    else:
        w21, w23 = rng.choice([-1, 0, 1, 2]), rng.choice([0, 1, 2])
    struct.pack_into('<h', obj, 0x21, w21)
    struct.pack_into('<h', obj, 0x23, w23)
    hit = False
    if not (kind == 'gate'):
        # the clearing test: Y <= [(w21 - 1) * 0x1e4 + 0x6b], X <= [(w23 - 1) * 0x2c + 0x67], X >= [0x5f]
        mode = ['none', 'a', 'b', 'c', 'none', 'none'][(variant + (pos[0] if pos else 0)) % 6]
        if S.cond((w21 - 1) * 0x1e4 + 0x6b, Y, '<=', 0, mode != 'a') and S.cond((w23 - 1) * 0x2c + 0x67, X, '<=', 0, mode != 'b'):
            S.cond(0x5f, X, '>=', 0, mode != 'c')

        def cell(A, B, da, db, field):
            return 0x43 + (A + da) * 0x1e4 + (B + db) * 0x2c + field

        def chain(conds, want_pass, fail_idx):
            for i, (val, op, off, adj) in enumerate(conds):
                if not S.cond(off, val, op, adj, True if want_pass or i < fail_idx else False):
                    return False
            return True

        def blocks(A, B, spec):
            """The four blocks of a type-5 cell in turn, as the original does (a block that holds advances A and / or B for the ones after it); spec is
            [(want_pass, fail_idx)] * 4. Returns (code, A, B)."""
            code = 0
            c = lambda da, db, f: cell(A, B, da, db, f)
            if chain([(Y, '>=', c(0, 0, 0x20), 0), (Y, '<=', c(0, 0, 0x20), q1), (X, '>=', c(0, 0, 0x1c), q2), (X, '<=', c(0, 1, 0x24), -q2)], *spec[0]):
                code, B = 0x2795, B + 1
            c = lambda da, db, f: cell(A, B, da, db, f)
            if chain([(Y, '>=', c(1, 0, 0x28), -q1), (Y, '<=', c(1, 0, 0x28), 0), (X, '>=', c(0, 0, 0x1c), q2), (X, '<=', c(0, 1, 0x24), -q2)], *spec[1]):
                code, A = 0x2796, A + 1
            c = lambda da, db, f: cell(A, B, da, db, f)
            if chain([(Y, '>=', c(0, 0, 0x20), q1), (Y, '<=', c(1, 0, 0x28), -q1), (X, '>=', c(0, 0, 0x1c), 0), (X, '<=', c(0, 0, 0x1c), q2)], *spec[2]):
                code = 0x2794
            if chain([(Y, '>=', c(0, 0, 0x20), q1), (Y, '<=', c(1, 0, 0x28), -q1), (X, '>=', c(0, 1, 0x24), -q2), (X, '<=', c(0, 1, 0x24), 0)], *spec[3]):
                code, A, B = 0x2797, A + 1, B + 1
            return code, A, B

        A = 0
        while A < w21 and not hit:
            B = 0
            while B < w23 and not hit:
                is_target = kind in ('Z', 'T5') and (A, B) == pos
                if is_target and kind == 'Z':
                    cell_kind = 'nf5'
                elif is_target:
                    cell_kind = 't5'
                else:
                    cell_kind = rng.choice(['z0', 'z0', 'z0', 'nf5', 't5'])
                w1a_nz = rng.choice([1, 0x100, 0x7fff, -1, -32768, 5])
                code = 0
                if cell_kind == 'z0':
                    S.put(cell(A, B, 0, 0, 0x1a), 2, 0)
                    S.put(cell(A, B, 0, 0, 0x18), 2, rng.choice([5, 5, 0, 4, 0x7fff]))
                else:
                    S.put(cell(A, B, 0, 0, 0x1a), 2, w1a_nz)
                    S.put(cell(A, B, 0, 0, 0x18), 2, 5 if cell_kind == 't5' else rng.choice([0, 4, 6, -5, 0x7fff, -32768]))
                if cell_kind == 'nf5':
                    wf = rest[0] if is_target else rng.randrange(4)
                    ok = chain([(Y, '>=', cell(A, B, 0, 0, 0x20), 0), (Y, '<=', cell(A, B, 0, 0, 0x28), 0), (X, '>=', cell(A, B, 0, 0, 0x1c), 0),
                                (X, '<=', cell(A, B, 0, 0, 0x24), 0)], wf is None, -1 if wf is None else wf)
                    if ok:
                        code = w1a_nz
                elif cell_kind == 't5':
                    if is_target:
                        mask = rest[0]
                        spec = [(bool(mask >> b & 1), (variant + b) % 4) for b in range(4)]
                    else:
                        spec = [(False, rng.randrange(4)) for _ in range(4)]
                    code, A, B = blocks(A, B, spec)
                if code != 0:
                    hit = True
                    break
                B += 1
            if not hit:
                A += 1
    # the rectangles of the record object (the point itself, not X and Y)
    obj[0x17c], obj[0x17e] = rng.choice([1, 0x80]), rng.choice([1, 0x80])
    if kind == 'post':
        pf = rest[1]
        obj[0x17d] = 0 if rest[0] == 0 else rng.choice([1, 0x80, 0xff])
    else:
        pf = rng.randrange(-1, 4)
        pf = None if pf < 0 else pf
        obj[0x17d] = rng.choice([0, 1, 0x80, 0xff])
    offs = (0x370, 0x378, 0x36c, 0x374) if obj[0x17d] == 0 else (0x192, 0x19a, 0x18e, 0x196)
    ops = ('>=', '<=', '>=', '<=')
    vals = (y, y, x, x)
    for i in range(4):
        if not O.cond(offs[i], vals[i], ops[i], 0, True if pf is None or i < pf else False):
            break
    results = [rng.choice([1, 1, 0, 2, 0x100, 0xffffffff])] if (variant % 3) else [1]
    stubs = {c: stub(c, None, results=results if c == 0x4afec1 else None) for c in (0x4afec1, 0x4b2917)}
    g = {'value_583186': gx & 0xffffffff, 'value_58318a': gy & 0xffffffff}
    return common('4b2250', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest), stack=stack, args=(x, y), g=g, self_bias=BIAS)



# the functions: id (the shim number), va, size from the ledger, the object-window probes of the call logs, whether GetTickCount is
# imported, whether the function returns a value (compared), the bytes it pops, the generator
SPECS = {
    '4712bd': dict(id=1, va=0x4712bd, size=1125, gen=gen_4712bd, tick=True, probes=[(0xc90, 0x180)], n=50 * 12),
    '4b2250': dict(id=2, va=0x4b2250, size=1735, gen=gen_4b2250, ret=True, cleanup=8, probes=[(0x430, 0x20), (0x1920, 0x20)], n=65 * 14),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
