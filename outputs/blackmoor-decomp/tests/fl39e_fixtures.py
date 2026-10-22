"""FL-39 (batch %s): the fixtures shared by tests/test_fl39e_differential.py and tests/fl39e_original_oracle.py.

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
    """The fields of Fl39eWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl39e.h').read_text()
    body = re.search(r'typedef struct Fl39eWorld \{(.*?)\} Fl39eWorld;', text, re.S).group(1)
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

# ---- kind init5 ----------------------------------------------------------------------------------------------------
def gen_init5(key, rng, n, c):
    size = max(v for k, v in c.items() if k.startswith('O')) + 0x20
    s = bytearray(rng.randrange(1, 255) for _ in range(size))      # no byte is 0 or 0xff: every store is visible, whatever its width
    return make(key, [self_area_bytes(s)], {}, {}, [], (), (n,))

# ---- kind wordguard ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4d3992] = (0,)       # pushed from eax whose upper half is left-over: the callee reads a word


def gen_wordguard(key, rng, n, c):
    W = c['W']
    (w,), variant = prof(n, [(x,) for x in (0xffff, 0, 0xfffe, 0x7fff, 0x8000, 0x1234, 1)])
    s = bytearray(rng.randbytes(0x100))
    put16(s, W, w)
    if variant % 2:
        put16(s, W + 2, 0xffff if w != 0xffff else 0)       # what is around the word must not count
        put16(s, W - 2, 0xffff if w != 0xffff else 0)
    stubs = {c['C1']: stub(c['C1'], CDECL(1), results=[result(rng)]), c['C2']: stub(c['C2'], THISCALL(0), results=[result(rng)], probe=[('self', 0, 0x40)])}
    return make(key, [self_area_bytes(s)], stubs, {}, [], (), (w,))

# ---- kind zero11 ----------------------------------------------------------------------------------------------------
def gen_zero11(key, rng, n, c):
    size = max(v for k, v in c.items() if k.startswith('O')) + 0x20
    s = bytearray(rng.randrange(1, 255) for _ in range(size))      # no byte is 0 or 0xff: every store is visible, whatever its width
    return make(key, [self_area_bytes(s)], {}, {}, [], (), (n,))

# ---- kind retconst ----------------------------------------------------------------------------------------------------
def gen_retconst(key, rng, n, c):
    return make(key, [self_area(rng, 0x40)], {}, {}, [], (), (n,))

# ---- kind init11a ----------------------------------------------------------------------------------------------------
def gen_init11a(key, rng, n, c):
    size = max(v for k, v in c.items() if k.startswith('O')) + 0x20
    s = bytearray(rng.randrange(1, 255) for _ in range(size))      # no byte is 0 or 0xff: every store is visible, whatever its width
    return make(key, [self_area_bytes(s)], {}, {}, [], (), (n,))

# ---- kind idxcopyb ----------------------------------------------------------------------------------------------------
def gen_idxcopyb(key, rng, n, c):
    (idx, b), variant = prof(n, [(i, x) for i in (0, 1, 2, 3) for x in (0, 1, 2, 7, 0x80, 0xff)])
    s = bytearray(rng.randbytes(0x3000))
    rec = idx * c['M'] + c['O']
    s[rec + c['B']] = b
    return make(key, [self_area_bytes(s)], {}, {}, [idx], (idx,), (idx, b))

# ---- kind idxcopya ----------------------------------------------------------------------------------------------------
def gen_idxcopya(key, rng, n, c):
    (idx, b), variant = prof(n, [(i, x) for i in (0, 1, 2, 3) for x in (0, 1, 2, 7, 0x80, 0xff)])
    s = bytearray(rng.randbytes(0x3000))
    rec = idx * c['M'] + c['O']
    s[rec + c['B']] = b
    return make(key, [self_area_bytes(s)], {}, {}, [idx], (idx,), (idx, b))

# ---- kind fillstride ----------------------------------------------------------------------------------------------------
def gen_fillstride(key, rng, n, c):
    (count, step), variant = prof(n, [(cn, st) for cn in (0, 1, 2, 5, -1, -4, 8, 0x80000000, 3) for st in (1, 2, -1, 3, 0)])
    after = rng.choice([0, 7, -3, 0x100, -0x40, 1, 0x7fffffff])
    scalars = (step, after) if c['S1'] == 0xc else (after, step)
    val = rng.choice([0x41, 0xffffff7f, 0x12345680, 0, 0xab, rng.randrange(1 << 32)])
    blk = bytearray(rng.randbytes(0x100))
    slot = bytearray(rng.randbytes(8))
    put32(slot, 0, od.region_va(2) + 0x80)
    args = (od.region_va(1), scalars[0] & 0xffffffff, scalars[1] & 0xffffffff, count & 0xffffffff, val)
    return make(key, [Area('slot', od.region_va(1), slot, image=False), Area('blk', od.region_va(2), blk, image=False)], {}, {}, list(args), args, (count, step))

# ---- kind fwd3 ----------------------------------------------------------------------------------------------------
def gen_fwd3(key, rng, n, c):
    a = rng.choice([0, 1, 0xffffffff, 0x80000000, rng.randrange(1 << 32)])
    rec = bytearray(rng.randbytes(0x20))
    stubs = {c['C1']: stub(c['C1'], THISCALL(4), results=[result(rng)])}
    args = (a, od.region_va(1))
    return make(key, [self_area(rng, 0x40), Area('rec', od.region_va(1), rec, image=False)], stubs, {}, list(args), args, (n,))

# ---- kind logloop ----------------------------------------------------------------------------------------------------
def gen_logloop(key, rng, n, c):
    N = c['N']
    curs = [0, 1, 2, 5, 8, 0xffff, 9, 0x7fff, 0x8000]
    cur = curs[n % len(curs)]
    g = {'value_%x' % c['G1']: rng.choice(NONZERO), 'value_%x' % c['G2']: rng.choice(NONZERO), 'value_5cf665': rng.choice(NONZERO), 'word_%x' % c['GI']: cur}
    stubs = {c['C1']: stub(c['C1'], THISCALL(5), results=[result(rng) for _ in range(N)])}
    return make(key, [self_area(rng, 0x40)], stubs, g, [], (), (cur,))

# ---- kind logthree ----------------------------------------------------------------------------------------------------
def gen_logthree(key, rng, n, c):
    (w,), variant = prof(n, [(0,), (1,), (0x100,), (0x8000,), (0xffff,), (0x7fff,)])
    g = {'value_%x' % c[k]: rng.choice(NONZERO) for k in ('G1', 'G2', 'G3', 'G4', 'G6')}
    g['value_5cf665'] = rng.choice(NONZERO)
    g['word_%x' % c['G5']] = w
    stubs = {c['C1']: stub(c['C1'], THISCALL(5), results=[result(rng)]), c['C2']: stub(c['C2'], THISCALL(5), results=[result(rng), result(rng)])}
    return make(key, [self_area(rng, 0x40)], stubs, g, [], (), (w,))

# ---- kind twocalls ----------------------------------------------------------------------------------------------------
def gen_twocalls(key, rng, n, c):
    stubs = {c['C1']: stub(c['C1'], THISCALL(2), results=[result(rng)]), c['C2']: stub(c['C2'], THISCALL(1), results=[result(rng)])}
    return make(key, [self_area(rng, 0x800)], stubs, {}, [], (), (n,))

# ---- kind gate01 ----------------------------------------------------------------------------------------------------
def gen_gate01(key, rng, n, c):
    G = c['G']
    (v,), variant = prof(n, [(x,) for x in (0, 1, 2, 0x80000000, 0xffffffff, 0x100, 0x101, 0x10000, 0x10001, 3)])
    s = bytearray(rng.randbytes(0x1000))
    put32(s, G, v)
    stubs = {c['C1']: stub(c['C1'], THISCALL(0), results=[result(rng)], probe=[('self', 0, 0x40)])}
    return make(key, [self_area_bytes(s)], stubs, {}, [], (), (v,))

# ---- kind dtorsub2 ----------------------------------------------------------------------------------------------------
def gen_dtorsub2(key, rng, n, c):
    probe = [('self', 0, 0x20)]
    stubs = {c['C1']: stub(c['C1'], THISCALL(0), results=[result(rng)], probe=probe), c['C2']: stub(c['C2'], THISCALL(0), results=[result(rng)], probe=probe),
             c['C3']: stub(c['C3'], THISCALL(0), results=[result(rng)], probe=probe)}
    sc = make(key, [self_area(rng, 0x800)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind storesx ----------------------------------------------------------------------------------------------------
def gen_storesx(key, rng, n, c):
    w = rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, 0xfffe, rng.randrange(1 << 16)])
    a = word_arg(rng, w)
    s = bytearray(rng.randbytes(0x1000))
    put32(s, c['O'], rng.choice([0, 0xffffffff, 0xa5a5a5a5]))
    return make(key, [self_area_bytes(s)], {}, {}, [a], (a,), (w,))

# ---- kind guardcall5 ----------------------------------------------------------------------------------------------------
def gen_guardcall5(key, rng, n, c):
    (on,), variant = prof(n, [(0,), (1,), (2,), (3,)])
    s = bytearray(rng.randbytes(0x1000))
    G = c['G']
    put32(s, G, 0 if on == 0 else rng.choice(NONZERO))
    if variant % 2:                      # zero gate with non-zero neighbours: a wrong width would see them
        for k in (1, 2, 3):
            if on == 0:
                s[G + k] = 0xff
                s[G - k] = 0xff
    stubs = {c['C1']: stub(c['C1'], THISCALL(5), results=[result(rng)])}
    return make(key, [self_area_bytes(s)], stubs, {'value_5cf665': rng.choice(NONZERO)}, [], (), (on,))

# ---- kind storeg ----------------------------------------------------------------------------------------------------
def gen_storeg(key, rng, n, c):
    arg = rng.choice([0, 1, 0xffffffff, 0x80000000, 0x10000, 0xdeadbeef, rng.randrange(1 << 32)])
    old = rng.choice(NONZERO)
    if old == arg:
        old ^= 0x5a5a5a5a
    return make(key, [self_area(rng, 0x40)], {}, {'value_%x' % c['G']: old}, [arg], (arg,), (n,))

# ---- kind fwdfields3 ----------------------------------------------------------------------------------------------------
def gen_fwdfields3(key, rng, n, c):
    stubs = {c['C1']: stub(c['C1'], THISCALL(3), results=[result(rng)], probe=[('self', 0, 0x20)])}
    return make(key, [self_area(rng, 0x400)], stubs, {}, [], (), (n,))

# ---- kind tracechk ----------------------------------------------------------------------------------------------------
def gen_tracechk(key, rng, n, c):
    (dbg, r1), variant = prof(n, [(d, r) for d in (0, 1, 0x100, 0x8000, 0xffff) for r in (0, 5, 0x80000000, 0xffffffff)])
    stubs = {c['P1']: stub(c['P1'], CDECL(1)), c['C1']: stub(c['C1'], THISCALL(0), results=[r1]), c['C2']: stub(c['C2'], THISCALL(0), results=[result(rng)]),
             c['P2']: stub(c['P2'], CDECL(3)), c['P3']: stub(c['P3'], STDCALL(3))}
    areas = [self_area(rng, 0x40), Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]
    return make(key, areas, stubs, {'word_63a4cd': dbg}, [], (), (dbg, r1))

SIZES = {
    '487b1a': (53, 53),
    '48e2f5': (47, 47),
    '49c5f0': (154, 154),
    '4a1b12': (30, 16),
    '4a1c47': (106, 106),
    '4a1cb1': (47, 47),
    '4ab3a7': (53, 53),
    '4ae452': (67, 67),
    '4ae495': (66, 66),
    '4c87ba': (85, 85),
    '4c8872': (85, 85),
    '4cca42': (45, 45),
    '4cca6f': (45, 45),
    '4ccd25': (27, 16),
    '4d0b68': (175, 175),
    '4d0c57': (175, 175),
    '4d3728': (135, 135),
    '4d37af': (135, 135),
    '4de227': (40, 40),
    '4de413': (45, 45),
    '4de584': (60, 45),
    '4de66e': (105, 105),
    '4e053f': (26, 26),
    '4e1113': (68, 68),
    '4e1157': (68, 68),
    '4e7700': (40, 40),
    '4e7a10': (48, 45),
    '4eda7c': (105, 105),
    '4ee5b8': (21, 21),
    '4ee5dd': (21, 21),
    '4ee616': (26, 26),
    '4f872e': (49, 49),
    '4f88ad': (49, 49),
    '4fc909': (116, 116),
    '4fc97d': (116, 116),
}
ROWS = {
    '487b1a': ('init5', {'O0': 30, 'O1': 28, 'O2': 113, 'O3': 117, 'O4': 112}),
    '48e2f5': ('wordguard', {'W': 28, 'C1': 5061010, 'C2': 4776586}),
    '49c5f0': ('zero11', {'O0': 3552, 'O1': 3564, 'O2': 3556, 'O3': 3632, 'O4': 3636, 'O5': 3640, 'O6': 3644, 'O7': 3648, 'O8': 3652, 'O9': 3656, 'O10': 3608}),
    '4a1b12': ('retconst', {'K': 5430184}),
    '4a1c47': ('init11a', {'O0': 30, 'O1': 28, 'O2': 96, 'O3': 75, 'O4': 88, 'O5': 89, 'O6': 90, 'O7': 32, 'O8': 36, 'O9': 91, 'O10': 73}),
    '4a1cb1': ('wordguard', {'W': 28, 'C1': 5061010, 'C2': 4856903}),
    '4ab3a7': ('init5', {'O0': 30, 'O1': 28, 'O2': 84, 'O3': 88, 'O4': 89}),
    '4ae452': ('idxcopyb', {'M': 199, 'O': 110, 'B': 38, 'S': 40, 'R': 39, 'Q': 4, 'D': 8}),
    '4ae495': ('idxcopya', {'M': 199, 'O': 110, 'B': 38, 'S': 40, 'R': 39, 'D': 8}),
    '4c87ba': ('fillstride', {'S1': 16, 'S2': 12}),
    '4c8872': ('fillstride', {'S1': 12, 'S2': 16}),
    '4cca42': ('fwd3', {'C1': 5032462}),
    '4cca6f': ('fwd3', {'C1': 5032604}),
    '4ccd25': ('retconst', {'K': 5431896}),
    '4d0b68': ('logloop', {'N': 9, 'GI': 5963607, 'S1': 5611672, 'T1': 5963013, 'T2': 5963445, 'G1': 6105927, 'OBJ': 6092377, 'C1': 5002103, 'S2': 5611708, 'T3': 5963013, 'G2': 6105631}),
    '4d0c57': ('logloop', {'N': 1, 'GI': 5963792, 'S1': 5611768, 'T1': 5963730, 'T2': 5963762, 'G1': 6106371, 'OBJ': 6092377, 'C1': 5002103, 'S2': 5611800, 'T3': 5963730, 'G2': 6106075}),
    '4d3728': ('logthree', {'A1': 5612424, 'G1': 6101347, 'A2': 5983832, 'G2': 6095803, 'OBJ': 6092377, 'C1': 5002103, 'A3': 5612440, 'G3': 6101343, 'G4': 6101339, 'C2': 5004619, 'G5': 5983885, 'A4': 5612456, 'A5': 5983816, 'A6': 5983800, 'G6': 6095815}),
    '4d37af': ('logthree', {'A1': 5612484, 'G1': 6101421, 'A2': 5984463, 'G2': 6095803, 'OBJ': 6092377, 'C1': 5002103, 'A3': 5612500, 'G3': 6101417, 'G4': 6101413, 'C2': 5004619, 'G5': 5984516, 'A4': 5612516, 'A5': 5984447, 'A6': 5984431, 'G6': 6095819}),
    '4de227': ('twocalls', {'O': 1681, 'C1': 5168305, 'K': 0, 'C2': 5170887}),
    '4de413': ('gate01', {'G': 2449, 'C1': 5170455}),
    '4de584': ('gate01', {'G': 2449, 'C1': 5171311}),
    '4de66e': ('dtorsub2', {'H': 5409094, 'VT': 5432528, 'C1': 5105404, 'O2': 1406, 'C2': 5171615, 'O3': 1007, 'C3': 5119107}),
    '4e053f': ('storesx', {'O': 3882}),
    '4e1113': ('guardcall5', {'G': 1871, 'K': 5619212, 'A1': 53, 'A2': 37, 'OBJ': 6092377, 'C1': 5002103}),
    '4e1157': ('guardcall5', {'G': 1871, 'K': 5619284, 'A1': 85, 'A2': 85, 'OBJ': 6092377, 'C1': 5002103}),
    '4e7700': ('twocalls', {'O': 1681, 'C1': 5168305, 'K': 1, 'C2': 5170887}),
    '4e7a10': ('gate01', {'G': 2449, 'C1': 5171311}),
    '4eda7c': ('dtorsub2', {'H': 5409590, 'VT': 5432572, 'C1': 5168023, 'O2': 1207, 'C2': 5171615, 'O3': 796, 'C3': 5119107}),
    '4ee5b8': ('storeg', {'G': 5623188}),
    '4ee5dd': ('storeg', {'G': 6531600}),
    '4ee616': ('storesx', {'O': 1199}),
    '4f872e': ('fwdfields3', {'A3': 584, 'A2': 580, 'A1': 576, 'C1': 5211676}),
    '4f88ad': ('fwdfields3', {'A3': 596, 'A2': 592, 'A1': 588, 'C1': 5211999}),
    '4fc909': ('tracechk', {'S1': 5638492, 'P1': 4498103, 'OBJ': 6091243, 'C1': 5203902, 'C2': 5218984, 'S2': 5638516, 'B': 6523019, 'P2': 5294654, 'P3': 5378972}),
    '4fc97d': ('tracechk', {'S1': 5638548, 'P1': 4498103, 'OBJ': 6091243, 'C1': 5203984, 'C2': 5218984, 'S2': 5638576, 'B': 6523019, 'P2': 5294654, 'P3': 5378972}),
}

GEN = {'init5': gen_init5, 'wordguard': gen_wordguard, 'zero11': gen_zero11, 'retconst': gen_retconst, 'init11a': gen_init11a, 'idxcopyb': gen_idxcopyb, 'idxcopya': gen_idxcopya, 'fillstride': gen_fillstride, 'fwd3': gen_fwd3, 'logloop': gen_logloop, 'logthree': gen_logthree, 'twocalls': gen_twocalls, 'gate01': gen_gate01, 'dtorsub2': gen_dtorsub2, 'storesx': gen_storesx, 'guardcall5': gen_guardcall5, 'storeg': gen_storeg, 'fwdfields3': gen_fwdfields3, 'tracechk': gen_tracechk}
COUNTS = {'init5': 10, 'wordguard': 14, 'zero11': 10, 'retconst': 4, 'init11a': 10, 'idxcopyb': 24, 'idxcopya': 24, 'fillstride': 40, 'fwd3': 8, 'logloop': 24, 'logthree': 12, 'twocalls': 8, 'gate01': 16, 'dtorsub2': 4, 'storesx': 14, 'guardcall5': 16, 'storeg': 12, 'fwdfields3': 8, 'tracechk': 20}
KIND_NAMES = {'init5': 'init_fields5', 'wordguard': 'release_word', 'zero11': 'zero_fields11', 'retconst': 'get_constant', 'init11a': 'init_fields11', 'idxcopyb': 'copy_sub_dword', 'idxcopya': 'copy_sub_dword', 'fillstride': 'fill_stride', 'fwd3': 'forward_struct', 'logloop': 'log_loop', 'logthree': 'log_three', 'twocalls': 'call_pair', 'gate01': 'call_unless_01', 'dtorsub2': 'destroy_subobjects', 'storesx': 'set_field_sx', 'guardcall5': 'log_guarded', 'storeg': 'store_global', 'fwdfields3': 'forward_fields', 'tracechk': 'check_trace'}
SPECFLAGS = {'487b1a': {}, '48e2f5': {'ret': True}, '49c5f0': {}, '4a1b12': {'ret': True}, '4a1c47': {}, '4a1cb1': {'ret': True}, '4ab3a7': {}, '4ae452': {'cleanup': 4}, '4ae495': {'cleanup': 4}, '4c87ba': {'cleanup': 20, 'ptr_args': True}, '4c8872': {'cleanup': 20, 'ptr_args': True}, '4cca42': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4cca6f': {'ret': True, 'cleanup': 8, 'ptr_args': True}, '4ccd25': {'ret': True}, '4d0b68': {}, '4d0c57': {}, '4d3728': {}, '4d37af': {}, '4de227': {'ret': True}, '4de413': {}, '4de584': {}, '4de66e': {'ret': True}, '4e053f': {'cleanup': 4}, '4e1113': {}, '4e1157': {}, '4e7700': {'ret': True}, '4e7a10': {}, '4eda7c': {'ret': True}, '4ee5b8': {'cleanup': 4}, '4ee5dd': {'cleanup': 4}, '4ee616': {'cleanup': 4}, '4f872e': {'ret': True}, '4f88ad': {'ret': True}, '4fc909': {}, '4fc97d': {}}
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
