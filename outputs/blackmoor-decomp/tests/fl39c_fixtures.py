"""FL-39 (batch c): the fixtures shared by tests/test_fl39c_differential.py and tests/fl39c_original_oracle.py.

Same shape as tests/fl35b_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the scripted callees (recording stubs at the call boundary, entered by address), the scripted stack argument and the globals. Random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (host boundaries); nothing inside the function under test is patched.
"""
import ctypes
import hashlib
from pathlib import Path
import re
import struct
import sys
from types import SimpleNamespace

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, TIB)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl39cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl39c.h').read_text()
    body = re.search(r'typedef struct Fl39cWorld \{(.*?)\} Fl39cWorld;', text, re.S).group(1)
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
WORD_ARGS = {}


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None, seh=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=seh, partial=None, fault=fault)


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
    runner = Original27(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None and orig.memory.pop('tib') != struct.pack('<I', sc.seh):
        raise AssertionError('the structured-exception chain at fs:[0] was not restored')
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the function must return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') or SPECS[sc.key].get('retself'):
        h.update(struct.pack('<I', orig.eax))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total




SELF_BYTES = 0x400
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
RET_VALUES = [0, 1, 0x80000000, 0xffffffff]


def self_area(rng, size=SELF_BYTES):
    return Area('self', od.region_va(0), bytearray(rng.randbytes(size)), image=False)


def self_area_bytes(s):
    return Area('self', od.region_va(0), s, image=False)


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def result(rng):
    return rng.choice(RET_VALUES + [rng.randrange(1 << 32)])


def gvals(rng):
    """Random non-zero values for every world dword (a store of 0 must show)."""
    return {n_: rng.choice([0xffffffff, 0xa5a5a5a5, rng.randrange(1, 1 << 32)]) & ((1 << (8 * GLOBALS[n_][1])) - 1) or 1 for n_ in GLOBALS}


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def tbl_area(rng, name, base, stride, lo, hi, field):
    """A table of records of `stride` bytes at the original address `base` for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * stride))
    return Area(name, base + lo * stride, data, image=True), {field: (name, -lo * stride)}

# ---- kind clamp ----------------------------------------------------------------------------------------------------
def gen_clamp(key, rng, n, c):
    def axis(mode):
        gmin = rng.choice([0, 5, -100, 0x7ffffff0, -0x7ffffff0, rng.randrange(-5000, 5000)])
        span = rng.choice([0, 1, 7, 50, 1000])
        gmax = gmin + span
        w = rng.choice([0, 1, 5, -1, -7, 0x7fff, -0x8000, span + 1, span + 100 if span + 100 < 0x7fff else 0x7fff, rng.randrange(-0x8000, 0x8000)])
        k = rng.choice([1, 2, 100])
        if mode == 'none':
            lo, hi = gmin + rng.randrange(0, 5), gmax - rng.randrange(0, 5)
        elif mode == 'low':
            lo, hi = gmin - k, rng.randrange(-2000, 2000)
            w = rng.choice([0, 1, -1, 0x7fff, -0x8000, rng.randrange(-0x8000, 0x8000)])
        elif mode == 'lowhigh':
            lo, hi = gmin - k, gmax
            w = span + rng.choice([1, 2, 100])
            w = min(w, 0x7fff)
        elif mode == 'high':
            lo, hi = gmin + rng.randrange(0, 5), gmax + k
        elif mode == 'edge':
            lo, hi = gmin, gmax
        else:
            lo, hi = rng.randrange(-(1 << 31), 1 << 31), rng.randrange(-(1 << 31), 1 << 31)
            gmin, gmax = rng.randrange(-(1 << 31), 1 << 31), rng.randrange(-(1 << 31), 1 << 31)
        return gmin, gmax, lo, hi, w
    modes = ['none', 'low', 'lowhigh', 'high', 'edge', 'wild']
    my, mx = modes[n % 6], modes[(n // 6) % 6]
    gy0, gy1, ly, hy, wy = axis(my)
    gx0, gx1, lx, hx, wx = axis(mx)
    s = bytearray(rng.randbytes(0x1800))
    put32(s, c['L'], ly)
    put32(s, c['H'], hy)
    put32(s, c['L2'], lx)
    put32(s, c['H2'], hx)
    put16(s, c['WY'], wy)
    put16(s, c['WX'], wx)
    g = {'value_58319a': gy0, 'value_5831a2': gy1, 'value_583196': gx0, 'value_58319e': gx1}
    return make(key, [self_area_bytes(s)], {}, g, [], (), (my, mx))

# ---- kind cmpptr ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4fb2e3] = (0,)


def gen_cmpptr(key, rng, n, c):
    P, O, W, K = c['P'], c['O'], c['W'], c['K']
    (kind, pos), variant = prof(n, [('eq', 9)] + [('ne', i) for i in range(9)])
    k = bytes(rng.randrange(1, 256) for _ in range(9))
    s = bytearray(rng.randbytes(0x1000))
    put32(s, P, od.region_va(1))
    obj = bytearray(rng.randbytes(0x400))
    obj[O:O + 9] = k
    if kind == 'ne':
        obj[O + pos] = (k[pos] + rng.choice([1, 0x80, 0xff, 0x10])) & 0xff
        if variant % 2:
            for j in range(pos + 1, 9):
                obj[O + j] = k[j] ^ 0xff
    put16(obj, W, rng.choice([0, 0xffff, 0x8000, 0x7fff, 1, rng.randrange(1 << 16)]))
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[result(rng)])}
    sc = make(key, [self_area_bytes(s), Area('obj', od.region_va(1), obj, image=False), Area('cst', K, bytearray(k), image=True)], stubs, {}, [], (), (kind, pos), {'bytes_%x' % K: ('cst', 0)})
    sc.word_args = {}        # edx is cleared before the word is loaded: the whole pushed dword is the zero-extended word
    return sc

# ---- kind cmpself ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4fb2e3] = (0,)       # pushed from dx with the left-over upper half of edx (the group 1 rows do not clear edx): the callee reads a word


def gen_cmpself(key, rng, n, c):
    O, W, K = c['O'], c['W'], c['K']
    (kind, pos), variant = prof(n, [('eq', 9)] + [('ne', i) for i in range(9)])
    k = bytes(rng.randrange(1, 256) for _ in range(9))
    s = bytearray(rng.randbytes(0x500))
    s[O:O + 9] = k
    if kind == 'ne':
        s[O + pos] = (k[pos] + rng.choice([1, 0x80, 0xff, 0x10])) & 0xff
        if variant % 2:
            for j in range(pos + 1, 9):
                s[O + j] = k[j] ^ 0xff
    put16(s, W, rng.choice([0, 0xffff, 0x8000, 0x7fff, 1, rng.randrange(1 << 16)]))
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[result(rng)])}
    return make(key, [self_area_bytes(s), Area('cst', K, bytearray(k), image=True)], stubs, {}, [], (), (kind, pos), {'bytes_%x' % K: ('cst', 0)})

# ---- kind allocz ----------------------------------------------------------------------------------------------------
def nzbytes(rng, n):
    return bytearray(rng.randrange(1, 256) for _ in range(n))


def gen_allocz(key, rng, n, c):
    sizes = [0, 1, 2, 3, 4, 5, 7, 8, 9, 0x10, 0x13, 0x21]
    profiles = [('fail', d) for d in (0, 1, 0x100, 0x8000)] + [('ok', s) for s in sizes]
    (kind, v), variant = prof(n, profiles)
    size = rng.choice([0, 1, 5, 0x20, 0x33]) if kind == 'fail' else v
    p = 0 if kind == 'fail' else od.region_va(2)
    dbg = v if kind == 'fail' else rng.choice([0, 1, 0x100, 0x8000])
    areas = [Area('slot', od.region_va(1), nzbytes(rng, 16), image=False), Area('blk', od.region_va(2), nzbytes(rng, size + 0x20), image=False),
             Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]
    probe = [('slot', 0, 4)]
    stubs = {c['A']: stub(c['A'], CDECL(1), results=[p]), c['P']: stub(c['P'], CDECL(2), probe=probe), c['Q']: stub(c['Q'], THISCALL(1), probe=probe),
             c['R']: stub(c['R'], CDECL(1), probe=probe), c['Y']: stub(c['Y'], THISCALL(0), results=[result(rng)], probe=probe)}
    a = (od.region_va(1), size)
    return make(key, areas, stubs, {'word_63a4cd': dbg}, list(a), a, (kind, v))

# ---- kind outget ----------------------------------------------------------------------------------------------------
def gen_outget(key, rng, n, c):
    out = rng.choice([0, 1, 0x80000000, 0xffffffff, 0xdeadbeef, rng.randrange(1 << 32)])
    stubs = {c['C1']: stub(c['C1'], THISCALL(2), results=[result(rng)], writes=[(0, 0, 0, 4, out)], derefs=[(0, 4)])}
    return make(key, [self_area(rng)], stubs, {}, [], (), (out,))

# ---- kind copychk ----------------------------------------------------------------------------------------------------
def gen_copychk(key, rng, n, c):
    B = c['B']
    limits = [B - 1, B, B + 1, 0, 0xffffffff, 0x7fffffff, 0x80000000, B - 4, 0x10000, 0xfffffe00]
    limit = limits[n % len(limits)]
    probe = [('self', c['O'], 16)]
    src = bytearray(rng.randbytes(B))
    stubs = {c['P']: stub(c['P'], CDECL(4), probe=probe), c['Q']: stub(c['Q'], THISCALL(1), probe=probe), c['Y']: stub(c['Y'], THISCALL(0), results=[result(rng)], probe=probe)}
    a = (od.region_va(1), limit)
    return make(key, [self_area(rng, 0x7700), Area('src', od.region_va(1), src, image=False)], stubs, {}, list(a), a, (limit,))

# ---- kind dtorvec ----------------------------------------------------------------------------------------------------
def gen_dtorvec(key, rng, n, c):
    probe = [('self', 0, 0x20)]
    stubs = {c['C1']: stub(c['C1'], THISCALL(0), results=[result(rng)], probe=probe), c['V']: stub(c['V'], CDECL(4), results=[result(rng)], probe=probe),
             c['C2']: stub(c['C2'], THISCALL(0), results=[result(rng)], probe=probe)}
    sc = make(key, [self_area(rng, 0x7700)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind storefwd ----------------------------------------------------------------------------------------------------
def gen_storefwd(key, rng, n, c):
    arg = rng.choice([0, 1, 0xffffffff, 0x80000000, 0x10000, rng.randrange(1 << 32)])
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[result(rng)], probe=[('self', c['O'], 4)])}
    return make(key, [self_area(rng, 0x7700)], stubs, {}, [arg], (arg,), (arg,))

# ---- kind three0 ----------------------------------------------------------------------------------------------------
def gen_three0(key, rng, n, c):
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[result(rng), result(rng), result(rng)])}
    return make(key, [self_area(rng, 0x4500)], stubs, {}, [], (), (n,))

# ---- kind fwdword ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4fccf2] = (0,)       # pushed from ax with the left-over upper half of eax: the callee reads a word


def gen_fwdword(key, rng, n, c):
    w = rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(1 << 16)])
    a = (w & 0xffff) | (rng.randrange(1 << 16) << 16)       # the original reads only the low word of the stack dword
    stubs = {c['C1']: stub(c['C1'], THISCALL(2), results=[result(rng)])}
    return make(key, [self_area(rng)], stubs, {}, [a], (a,), (w,))

SIZES = {
    '4a3aec': (255, 255),
    '4a7f08': (255, 255),
    '4ada0d': (73, 73),
    '4ada56': (73, 73),
    '4ada9f': (73, 73),
    '4b3e99': (255, 255),
    '4be3d3': (61, 61),
    '4be410': (61, 61),
    '4be44d': (61, 61),
    '4be48a': (61, 61),
    '4be4c7': (61, 61),
    '4be619': (139, 139),
    '4bf542': (142, 139),
    '4cb8d5': (37, 37),
    '4cb8fa': (37, 37),
    '4cb91f': (37, 37),
    '4cc70f': (139, 139),
    '4d9910': (139, 139),
    '4de394': (127, 127),
    '4e2d63': (112, 112),
    '4e3525': (37, 37),
    '4e37bd': (59, 59),
    '4e37f8': (59, 59),
    '4e3833': (59, 59),
    '4e7843': (127, 127),
    '4e7b37': (112, 112),
    '4e7d2e': (127, 127),
    '4e8994': (37, 37),
    '4eb8fe': (112, 112),
    '4ebd2e': (37, 37),
    '4fcd4d': (28, 28),
    '4fcd69': (28, 28),
    '4fcd85': (28, 28),
}
ROWS = {
    '4a3aec': ('clamp', {'L': 556, 'GL': 5779866, 'WY': 2098, 'H': 564, 'GH': 5779874, 'L2': 552, 'GL2': 5779862, 'WX': 2096, 'H2': 560, 'GH2': 5779870}),
    '4a7f08': ('clamp', {'L': 3626, 'GL': 5779866, 'WY': 5030, 'H': 3634, 'GH': 5779874, 'L2': 3622, 'GL2': 5779862, 'WX': 5028, 'H2': 3630, 'GH2': 5779870}),
    '4ada0d': ('cmpptr', {'K': 5575124, 'P': 3095, 'O': 662, 'W': 695, 'OBJ': 6044263, 'C1': 5223139}),
    '4ada56': ('cmpptr', {'K': 5575136, 'P': 3095, 'O': 564, 'W': 597, 'OBJ': 6044263, 'C1': 5223139}),
    '4ada9f': ('cmpptr', {'K': 5575148, 'P': 3095, 'O': 613, 'W': 646, 'OBJ': 6044263, 'C1': 5223139}),
    '4b3e99': ('clamp', {'L': 1760, 'GL': 5779866, 'WY': 1826, 'H': 1768, 'GH': 5779874, 'L2': 1756, 'GL2': 5779862, 'WX': 1822, 'H2': 1764, 'GH2': 5779870}),
    '4be3d3': ('cmpself', {'K': 5579084, 'O': 796, 'W': 829, 'OBJ': 6044263, 'C1': 5223139}),
    '4be410': ('cmpself', {'K': 5579096, 'O': 845, 'W': 878, 'OBJ': 6044263, 'C1': 5223139}),
    '4be44d': ('cmpself', {'K': 5579108, 'O': 894, 'W': 927, 'OBJ': 6044263, 'C1': 5223139}),
    '4be48a': ('cmpself', {'K': 5579120, 'O': 943, 'W': 976, 'OBJ': 6044263, 'C1': 5223139}),
    '4be4c7': ('cmpself', {'K': 5579132, 'O': 1041, 'W': 1074, 'OBJ': 6044263, 'C1': 5223139}),
    '4be619': ('allocz', {'A': 5364803, 'S1': 5579152, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'D': 6530253, 'R': 4498103, 'X': 6092377, 'Y': 5019572}),
    '4bf542': ('allocz', {'A': 5364803, 'S1': 5580204, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'D': 6530253, 'R': 4498103, 'X': 6092377, 'Y': 5019572}),
    '4cb8d5': ('outget', {'K': 24, 'C1': 5031695}),
    '4cb8fa': ('outget', {'K': 13, 'C1': 5031695}),
    '4cb91f': ('outget', {'K': 41, 'C1': 5031695}),
    '4cc70f': ('allocz', {'A': 5364803, 'S1': 5607480, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'D': 6530253, 'R': 4498103, 'X': 6092377, 'Y': 5019572}),
    '4d9910': ('allocz', {'A': 5364803, 'S1': 5614132, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'D': 6530253, 'R': 4498103, 'X': 6092377, 'Y': 5019572}),
    '4de394': ('copychk', {'O': 1681, 'N': 192, 'B': 768, 'S1': 5617788, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'X': 6092377, 'Y': 5019572}),
    '4e2d63': ('dtorvec', {'H': 5409266, 'VT': 5432556, 'C1': 5124010, 'CB': 5119107, 'K': 26, 'O': 7330, 'V': 5295016, 'C2': 5167740}),
    '4e3525': ('storefwd', {'O': 17708, 'C1': 5169046}),
    '4e37bd': ('three0', {'O1': 15709, 'C1': 5122368, 'O2': 16108, 'O3': 17305}),
    '4e37f8': ('three0', {'O1': 15709, 'C1': 5122368, 'O2': 16108, 'O3': 17305}),
    '4e3833': ('three0', {'O1': 15709, 'C1': 5122368, 'O2': 16108, 'O3': 16507}),
    '4e7843': ('copychk', {'O': 1681, 'N': 192, 'B': 768, 'S1': 5620932, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'X': 6092377, 'Y': 5019572}),
    '4e7b37': ('dtorvec', {'H': 5409410, 'VT': 5432564, 'C1': 5143539, 'CB': 5119107, 'K': 6, 'O': 30292, 'V': 5295016, 'C2': 5167740}),
    '4e7d2e': ('copychk', {'O': 27424, 'N': 715, 'B': 2860, 'S1': 5621040, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'X': 6092377, 'Y': 5019572}),
    '4e8994': ('storefwd', {'O': 30288, 'C1': 5169046}),
    '4eb8fe': ('dtorvec', {'H': 5409506, 'VT': 5432568, 'C1': 5159508, 'CB': 5119107, 'K': 2, 'O': 3240, 'V': 5295016, 'C2': 5167740}),
    '4ebd2e': ('storefwd', {'O': 3236, 'C1': 5169046}),
    '4fcd4d': ('fwdword', {'K': 0, 'C1': 5229810}),
    '4fcd69': ('fwdword', {'K': 1, 'C1': 5229810}),
    '4fcd85': ('fwdword', {'K': 2, 'C1': 5229810}),
}

GEN = {'clamp': gen_clamp, 'cmpptr': gen_cmpptr, 'cmpself': gen_cmpself, 'allocz': gen_allocz, 'outget': gen_outget, 'copychk': gen_copychk, 'dtorvec': gen_dtorvec, 'storefwd': gen_storefwd, 'three0': gen_three0, 'fwdword': gen_fwdword}
COUNTS = {'clamp': 120, 'cmpptr': 30, 'cmpself': 30, 'allocz': 32, 'outget': 12, 'copychk': 30, 'dtorvec': 4, 'storefwd': 12, 'three0': 8, 'fwdword': 12}
KIND_NAMES = {'clamp': 'clamp_rect', 'cmpptr': 'check_bytes', 'cmpself': 'check_bytes', 'allocz': 'alloc_zero', 'outget': 'get_via_out', 'copychk': 'copy_block', 'dtorvec': 'destroy_vector', 'storefwd': 'set_field_forward', 'three0': 'call_three_zero', 'fwdword': 'forward_word'}
SPECFLAGS = {'4a3aec': {}, '4a7f08': {}, '4ada0d': {}, '4ada56': {}, '4ada9f': {}, '4b3e99': {}, '4be3d3': {}, '4be410': {}, '4be44d': {}, '4be48a': {}, '4be4c7': {}, '4be619': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4bf542': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4cb8d5': {'ret': True}, '4cb8fa': {'ret': True}, '4cb91f': {'ret': True}, '4cc70f': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4d9910': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4de394': {'cleanup': 8, 'ptr_args': True}, '4e2d63': {'ret': True}, '4e3525': {'ret': True, 'cleanup': 4}, '4e37bd': {'ret': True}, '4e37f8': {'ret': True}, '4e3833': {'ret': True}, '4e7843': {'cleanup': 8, 'ptr_args': True}, '4e7b37': {'ret': True}, '4e7d2e': {'cleanup': 8, 'ptr_args': True}, '4e8994': {'ret': True, 'cleanup': 4}, '4eb8fe': {'ret': True}, '4ebd2e': {'ret': True, 'cleanup': 4}, '4fcd4d': {'ret': True, 'cleanup': 4}, '4fcd69': {'ret': True, 'cleanup': 4}, '4fcd85': {'ret': True, 'cleanup': 4}}
SPECS = {}
NAMES = {}
for _i, (_k, (_kind, _c)) in enumerate(ROWS.items()):
    _spec = SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=SIZES[_k][0], code=SIZES[_k][1], n=COUNTS[_kind])
    _spec.update(SPECFLAGS[_k])
    NAMES[_k] = KIND_NAMES[_kind]
KEYS = list(SPECS)


def build(key, rng, n):
    kind, c = ROWS[key]
    return GEN[kind](key, rng, n, c)


def scenarios(key):
    return SPECS[key]['n']
