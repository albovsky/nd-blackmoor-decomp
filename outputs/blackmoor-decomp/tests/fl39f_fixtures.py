"""FL-39 (batch f): the fixtures shared by tests/test_fl39f_differential.py and tests/fl39f_original_oracle.py.

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
    """The fields of Fl39fWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl39f.h').read_text()
    body = re.search(r'typedef struct Fl39fWorld \{(.*?)\} Fl39fWorld;', text, re.S).group(1)
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

# ---- kind advslot ----------------------------------------------------------------------------------------------------
def gen_advslot(key, rng, n, c):
    import math
    (m, cur, mode), variant = prof(n, [(m_, cu, mode_) for mode_ in ('all', 'none', 'first') for cu in (0, 1, -1, 2, -3, 4) for m_ in (1, 2, 3, 5, -3, 4)])
    idx = [0, 1, 2, 3, -1][(n + variant) % 5]
    s = bytearray(rng.randrange(1, 256) for _ in range(c['AR'] + 0x80))
    put16(s, c['SL'], idx & 0xffff)
    put16(s, c['CU'], cur & 0xffff)
    first = int(math.fmod(cur + 1, m))               # the idiv remainder: the sign of the dividend
    for k in range(-8, 8):
        zero = mode == 'none' or (mode == 'first' and k != first)
        put32(s, c['AR'] + 4 * k, 0 if zero else rng.choice([1, 0x80000000, 0xdeadbeef]))
    area, ptrs = tbl_area(rng, 'tbl', c['TB'], c['ST'], -1, 3, 'table_5bb5e5')
    for i in range(-1, 4):
        put32(area.data, (i + 1) * c['ST'], 0)
    put32(area.data, (idx + 1) * c['ST'], od.region_va(1))
    desc = bytearray(rng.randbytes(c['MD'] + 0x10))
    put16(desc, c['MD'], m & 0xffff)
    return make(key, [self_area_bytes(s), area, Area('desc', od.region_va(1), desc, image=False)], {}, {}, [], (), (m, cur, mode), ptrs)

# ---- kind seq_4904fa ----------------------------------------------------------------------------------------------------
OPS_seq_4904fa = [('call', 'C0', 'self', [], 'this'), ('st', 4, 0, 'K1'), ('st', 4, 'K2', 0), ('st', 4, 'K3', 1), ('fill', 'K5', 'K4', 3), ('retself',)]


def gen_seq_4904fa(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4904fa:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    pass
    return sc

# ---- kind clearblk ----------------------------------------------------------------------------------------------------
def gen_clearblk(key, rng, n, c):
    ns = [0, 1, 2, 3, 4, 5, 7, 8, 9, 0x10, 0x13, 0x41]
    armed = n % 3 != 2
    cnt = ns[n % len(ns)]
    off = [0, 1, 3, 5][(n // 3) % 4]
    s = bytearray(rng.randbytes(c['F'] + 0x20))
    put32(s, c['P'], od.region_va(1) + off if armed else 0)
    put32(s, c['N'], cnt if armed else rng.choice([1, 8, 0x41, 0xffffffff]))
    s[c['F']] = rng.choice([1, 0x80, 0xff, 0x33])
    blk = bytearray(rng.randrange(1, 256) for _ in range(off + cnt + 0x20))
    return make(key, [self_area_bytes(s), Area('blk', od.region_va(1), blk, image=False)], {}, {}, [], (), (armed, cnt, off))

# ---- kind checkobj ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4fc878] = (0,)       # pushed from ax with the left-over upper half of eax (the result of the first call): the callee reads a word


def gen_checkobj(key, rng, n, c):
    O, W, P, G = c['O'], c['W'], c['P'], c['G']
    profiles = [(g, 'eq', 0, 0) for g in (0, 1)] + [(g, 'ne', pos, r) for g in (0, 1) for pos in (0, 4, 8) for r in (0, 1)]
    (g, kind, pos, r), variant = prof(n, profiles)
    k1 = bytes(rng.randrange(1, 256) for _ in range(9))
    k2 = bytes(rng.randrange(1, 256) for _ in range(9))
    k = k1 if g else k2
    s = bytearray(rng.randbytes(0x4800))
    put32(s, G, rng.choice(NONZERO) if g else 0)
    put32(s, P, od.region_va(1))
    obj = bytearray(rng.randbytes(0x80))
    obj[O:O + 9] = k
    if kind == 'ne':
        obj[O + pos] = (k[pos] + rng.choice([1, 0x80, 0xff, 0x10])) & 0xff
        if variant % 2:
            for j in range(pos + 1, 9):
                obj[O + j] = k[j] ^ 0xff
    put16(obj, W, rng.choice([0, 0xffff, 0x8000, 0x7fff, 1, rng.randrange(1 << 16)]))
    res1 = 0 if r == 0 else rng.choice([1, 0x80000000, 0xffff0000, 0xdeadbeef])
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[res1]), c['C2']: stub(c['C2'], THISCALL(1)), c['C3']: stub(c['C3'], THISCALL(1))}
    areas = [self_area_bytes(s), Area('obj', od.region_va(1), obj, image=False), Area('cst1', c['K1'], bytearray(k1), image=True), Area('cst2', c['K2'], bytearray(k2), image=True)]
    return make(key, areas, stubs, {}, [], (), (g, kind, pos, r), {'bytes_%x' % c['K1']: ('cst1', 0), 'bytes_%x' % c['K2']: ('cst2', 0)})

# ---- kind seq_49c53a ----------------------------------------------------------------------------------------------------
OPS_seq_49c53a = [('call', 'C1', 'self', [], 'this'), ('st', 4, 0, 'K2'), ('fill', 'K4', 'K3', 0), ('call', 'C5', 'self', [], 'this'), ('retself',)]


def gen_seq_49c53a(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_49c53a:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind fillcells ----------------------------------------------------------------------------------------------------
def gen_fillcells(key, rng, n, c):
    shapes = [(0, 0), (1, 1), (2, 3), (3, 2), (-1, 3), (2, -4), (4, 5), (1, 7), (3, 3), (0, 4)]
    (h, w), variant = prof(n, shapes)
    cells = max(h, 0) * max(w, 0) if h > 0 and w > 0 else 0
    fills = [0, 1, cells // 2, cells, cells + 2, 3][(n + variant) % 6]
    tsize = max(cells, fills) * 2 + 0x20
    off = [0, 2, 1, 3][variant % 4]
    s = bytearray(rng.randbytes(c['FN'] + 0x20))
    put32(s, c['FN'], fills)
    put32(s, c['PT'], od.region_va(1) + off)
    put32(s, c['WD'], w & 0xffffffff)
    put32(s, c['HT'], h & 0xffffffff)
    tbl = bytearray(rng.randbytes(tsize + off))
    return make(key, [self_area_bytes(s), Area('tbl', od.region_va(1), tbl, image=False)], {}, {}, [], (), (h, w, fills, off))

# ---- kind countne ----------------------------------------------------------------------------------------------------
def gen_countne(key, rng, n, c):
    masks = [0, 0x3ff, 0x155, 0x2aa, 1, 0x200, 0x1ff, 0x2ff, 0x0f0, 0x00f, 0x3fe, 0x3fd]
    m = masks[n % len(masks)]
    s = bytearray(rng.randrange(1, 256) for _ in range(c['CNT'] + 0x20))
    for i in range(c['R']):
        base = c['B'] + i * c['S']
        if (m >> i) & 1:
            s[base + rng.randrange(1, c['S'])] = 0
        else:
            s[base] = 0
    put32(s, c['CNT'], rng.choice([0xffffffff, 0x12345678, 0x5, 0x80000000]))
    return make(key, [self_area_bytes(s)], {}, {}, [], (), (m,))

# ---- kind seq_4ac8da ----------------------------------------------------------------------------------------------------
OPS_seq_4ac8da = [('st', 2, 'K0', 'K1'), ('st', 2, 'K2', 'K3'), ('st', 4, 'K4', 0), ('st', 4, 'K5', 0), ('st', 1, 'K6', 0), ('st', 1, 'K7', 0), ('st', 4, 'K8', 0), ('st', 2, 'K9', 'K10'), ('st', 4, 'K11', 0), ('st', 4, 'K12', 0), ('st', 4, 'K13', 0), ('fill', 'K15', 'K14', 1), ('fill', 'K17', 'K16', 0)]


def gen_seq_4ac8da(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4ac8da:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    pass
    return sc

# ---- kind impclear ----------------------------------------------------------------------------------------------------
def gen_impclear(key, rng, n, c):
    a0 = [0, 0, 1, 0x80000000, 0xffffffff, 0x12345678, 0, 0xdeadbeef][n % 8]
    s = bytearray(rng.randrange(1, 256) for _ in range(c['F'] + 0x40))
    probe = [('self', c['F'], 4), ('self', c['O'], 16)]
    stubs = {c['C1']: stub(c['C1'], THISCALL(0), results=[result(rng)], probe=probe)}
    iat = {c['IMP']: stub(c['IMP'], STDCALL(3), probe=[('self', c['O'], 16)], results=[result(rng)])}
    return make(key, [self_area_bytes(s)], stubs, {}, [a0], (a0,), (a0,), iat=iat)

# ---- kind findzero ----------------------------------------------------------------------------------------------------
def gen_findzero(key, rng, n, c):
    profiles = [('null',), ('c', 0, -1), ('c', -3, -1)] + [('c', cnt, hit) for cnt in (1, 2, 3, 5) for hit in [-1] + list(range(cnt))]
    (kind, *rest), variant = prof(n, profiles)
    obj = bytearray(rng.randbytes(c['RES'] + 0x40))
    a = (0,)
    if kind != 'null':
        cnt, hit = rest
        put32(obj, c['CNT'], cnt & 0xffffffff)
        for i in range(max(cnt, 0)):
            base = c['B'] + i * c['S']
            if i == hit:
                obj[base:base + 16 + (variant % 2)] = bytes(16 + (variant % 2))       # the byte after the 16 may be zero too: it must not count
            else:
                j = (i * 5 + variant * 3 + n) % 16          # the first non-zero byte: bytes before it are zero
                obj[base:base + j] = bytes(j)
                obj[base + j] = rng.randrange(1, 256)
                if (variant + i) % 2 == 0:
                    obj[base + j + 1:base + 16] = bytes(15 - j)     # nothing but zeros after it
        put32(obj, c['RES'], rng.choice([0xffffffff, 0x12345678, 7]))
        a = (od.region_va(1),)
    return make(key, [Area('obj', od.region_va(1), obj, image=False)], {}, {}, list(a), a, (kind, *rest))

# ---- kind seq_4d52b9 ----------------------------------------------------------------------------------------------------
OPS_seq_4d52b9 = [('fill', 'K1', 'K0', 0), ('fill', 'K2', 4, 0), ('fill', 'K4', 4, 0), ('fill', 'K6', 4, 0)]


def gen_seq_4d52b9(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4d52b9:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    pass
    return sc

# ---- kind tickstr ----------------------------------------------------------------------------------------------------
def gen_tickstr(key, rng, n, c):
    lens = [0, 1, 2, 3, 4, 5, 0x20, 0x41]
    ln = lens[n % 8]
    now = [0, 1, 0xffffffff, 0x7fffffff, 0x80000000, rng.randrange(1 << 32)][n % 6]
    s = bytearray(rng.randrange(1, 256) for _ in range(c['S'] + 0x60))
    s[c['S'] + ln] = 0
    put16(s, c['W'], [0, 1, 0xffff, 0x7fff, 0x8000, 0x1234][(n // 2) % 6])
    return make(key, [self_area_bytes(s)], {}, {}, [], (), (ln, now), iat={0x52a23c: stub(0x52a23c, (0, False, 0), results=[now])})

# ---- kind rellist ----------------------------------------------------------------------------------------------------
def gen_rellist(key, rng, n, c):
    (ln, tail), variant = prof(n, [(ln_, t) for ln_ in range(4) for t in (0, 1)])
    s = bytearray(rng.randrange(1, 256) for _ in range(c['HD'] + c['N'] * 4 + 0x20))
    nodes = []
    for j in range(3):
        nd = bytearray(rng.randrange(1, 256) for _ in range(c['NX'] + 0x10))
        put32(nd, c['NX'], od.region_va(1 + j + 1) if j + 1 < ln else 0)
        nodes.append(Area('n%d' % j, od.region_va(1 + j), nd, image=False))
    put32(s, c['HD'], od.region_va(1) if ln else 0)
    put32(s, c['TL'], rng.choice([1, 0x80000000, 0xdeadbeef, 0xffffffff]) if tail else 0)
    probe = [('self', c['HD'], 16)]
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), probe=probe), c['C2']: stub(c['C2'], CDECL(1), probe=probe)}
    return make(key, [self_area_bytes(s), *nodes], stubs, {}, [], (), (ln, tail))

# ---- kind copycount ----------------------------------------------------------------------------------------------------
def gen_copycount(key, rng, n, c):
    (cnt, dbg), variant = prof(n, [(k, d) for k in (0, 1, 2, 3, 4, 5, 7, 8, 9, 0x10, 0x13, 0x40) for d in (0, 1, 0x100, 0x8000, 0xffff)])
    s = bytearray(rng.randbytes(c['O'] + cnt + 0x20))
    src = bytearray(rng.randbytes(cnt + 0x10))
    probe = [('self', c['O'], 16)]
    stubs = {c['C1']: stub(c['C1'], CDECL(1), probe=probe)}
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]
    a = (od.region_va(1), cnt)
    return make(key, [self_area_bytes(s), Area('src', od.region_va(1), src, image=False), *nbr], stubs, {'word_63a4cd': dbg}, list(a), a, (cnt, dbg))

# ---- kind seq_4de5f0 ----------------------------------------------------------------------------------------------------
OPS_seq_4de5f0 = [('call', 'C2', ('self', 'K1'), [], 'this'), ('call', 'C4', ('self', 'K3'), [], 'this'), ('st', 4, 0, 'K5'), ('fill', 'K7', 'K6', 1), ('call', 'C8', 'self', [], 'this'), ('retself',)]


def gen_seq_4de5f0(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4de5f0:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind seq_4e0410 ----------------------------------------------------------------------------------------------------
OPS_seq_4e0410 = [('call', 'C5', None, [('self', 'K4'), 'K3', 'N5', 'K2', 'K1'], 'std'), ('st', 4, 0, 'K6'), ('fill', 'K8', 'K7', 3), ('call', 'C9', 'self', [], 'this'), ('retself',)]


def gen_seq_4e0410(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4e0410:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind copyin_b ----------------------------------------------------------------------------------------------------
def gen_copyin_b(key, rng, n, c):
    total = c['N'] * 4 + 3
    s = bytearray(rng.randbytes(c['O'] + total + 0x20))
    src = bytearray(rng.randbytes(total + 0x10))
    if n % 2:                                       # the bytes of the destination that the copy replaces start equal to the source in places (a skipped unit must still show)
        s[c['O'] + 3] = src[3]
    junk = rng.choice([0xdeadbeef, 0x12345678, 0, 0xffffffff])
    a = (od.region_va(1), junk)
    return make(key, [self_area_bytes(s), Area('src', od.region_va(1), src, image=False)], {}, {}, list(a), a, (n,))

# ---- kind seq_4e1c50 ----------------------------------------------------------------------------------------------------
OPS_seq_4e1c50 = [('st', 4, 0, 'K0'), ('fill', 'K2', 'K1', 3), ('call', 'C3', 'self', [], 'this'), ('retself',)]


def gen_seq_4e1c50(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4e1c50:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    pass
    return sc

# ---- kind copyin_a ----------------------------------------------------------------------------------------------------
def gen_copyin_a(key, rng, n, c):
    total = c['N'] * 4 + 1
    s = bytearray(rng.randbytes(c['O'] + total + 0x20))
    src = bytearray(rng.randbytes(total + 0x10))
    if n % 2:                                       # the bytes of the destination that the copy replaces start equal to the source in places (a skipped unit must still show)
        s[c['O'] + 3] = src[3]
    junk = rng.choice([0xdeadbeef, 0x12345678, 0, 0xffffffff])
    a = (od.region_va(1), junk)
    return make(key, [self_area_bytes(s), Area('src', od.region_va(1), src, image=False)], {}, {}, list(a), a, (n,))

# ---- kind setname ----------------------------------------------------------------------------------------------------
def gen_setname(key, rng, n, c):
    lens = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 15, 16, 17, 31, 32, 47, 48]
    ln = lens[n % len(lens)]
    s = bytearray(rng.randbytes(c['O'] + 0x31 + 0x40))
    name = bytearray(rng.randrange(1, 256) for _ in range(ln)) + bytearray([0]) + bytearray(rng.randbytes(0x10))
    a = (od.region_va(1),)
    return make(key, [self_area_bytes(s), Area('name', od.region_va(1), name, image=False)], {}, {}, list(a), a, (ln,))

# ---- kind seq_4e7a70 ----------------------------------------------------------------------------------------------------
OPS_seq_4e7a70 = [('call', 'C1', 'self', [], 'this'), ('call', 'C6', None, [('self', 'K5'), 'K4', 'N6', 'K3', 'K2'], 'std'), ('st', 4, 0, 'K7'), ('st', 4, 'K8', 0), ('st', 4, 'K9', 0), ('st', 4, 'K10', 0), ('fill', 'K12', 'K11', 0), ('fill', 'K14', 'K13', 3), ('call', 'C15', 'self', [], 'this'), ('retself',)]


def gen_seq_4e7a70(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4e7a70:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind filltable ----------------------------------------------------------------------------------------------------
def gen_filltable(key, rng, n, c):
    lens = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 30, 0x3b]
    ln = lens[n % len(lens)]
    s = bytearray(rng.randbytes(c['CT'] + 0x20))
    s[c['SRC']:c['SRC'] + ln] = bytes(rng.randrange(1, 256) for _ in range(ln))
    s[c['SRC'] + ln] = 0
    put32(s, c['CT'], rng.choice([0xffffffff, 0x12345678, 0x46, 0x7fffffff]))
    tbl = bytearray(rng.randbytes(c['R'] * c['S'] + 0x20))
    return make(key, [self_area_bytes(s), Area('tbl', c['T0'], tbl, image=True)], {}, {}, [], (), (ln,), {'table_583f1f': ('tbl', 0)})

# ---- kind seq_4eb870 ----------------------------------------------------------------------------------------------------
OPS_seq_4eb870 = [('call', 'C1', 'self', [], 'this'), ('call', 'C6', None, [('self', 'K5'), 'K4', 'N2', 'K3', 'K2'], 'std'), ('st', 4, 0, 'K7'), ('fill', 'K9', 'K8', 3), ('call', 'C10', 'self', [], 'this'), ('retself',)]


def gen_seq_4eb870(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4eb870:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

# ---- kind copylimit ----------------------------------------------------------------------------------------------------
def gen_copylimit(key, rng, n, c):
    B = c['B']
    limits = [B - 1, B, B + 1, 0, 0xffffffff, 0x7fffffff, 0x80000000, B - 4, 0x10000, 0xfffffe00]
    limit = limits[n % len(limits)]
    probe = [('self', c['O'], 16)]
    s = bytearray(rng.randbytes(c['O'] + B + 0x20))
    src = bytearray(rng.randbytes(B + 0x10))
    stubs = {c['P']: stub(c['P'], CDECL(4), probe=probe), c['Q']: stub(c['Q'], THISCALL(1), probe=probe), c['Y']: stub(c['Y'], THISCALL(0), results=[result(rng)], probe=probe)}
    a = (od.region_va(1), limit)
    return make(key, [self_area_bytes(s), Area('src', od.region_va(1), src, image=False)], stubs, {}, list(a), a, (limit,))

# ---- kind checkname ----------------------------------------------------------------------------------------------------
def gen_checkname(key, rng, n, c):
    (kind, dbg, pos), variant = prof(n, [(k, d, p) for k, ps in (('eq', (0,)), ('ne', (0, 7, 0x14)), ('nz', (0,))) for p in ps for d in (0, 1, 0x100, 0x8000)])
    N, K = c['N'], c['K']
    k = bytes(rng.randrange(1, 256) for _ in range(N))
    name = bytearray(k) + bytearray(rng.randbytes(0x10))
    if kind == 'ne':
        name[pos] = (k[pos] + rng.choice([1, 0x80, 0xff, 0x10])) & 0xff
        if variant % 2:
            for j in range(pos + 1, N):
                name[j] = k[j] ^ 0xff
    if kind == 'nz':
        for j in range(0, N, 5):
            name[j] ^= 0x5a
    a0 = 0 if kind != 'nz' else rng.choice([1, 0x80000000, 0x1234abcd, 0xffffffff])
    a2 = rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)])
    cell = bytearray(rng.randbytes(4 + 8))
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]
    stubs = {c['P']: stub(c['P'], CDECL(3 if kind != 'nz' else 4)), c['Q']: stub(c['Q'], CDECL(1))}
    a = (a0, od.region_va(1), a2, od.region_va(2))
    sc = make(key, [Area('name', od.region_va(1), name, image=False), Area('cell', od.region_va(2), cell, image=False), Area('cst', K, bytearray(k), image=True), *nbr], stubs, {'word_63a4cd': dbg}, list(a), a,
              (kind, dbg, pos), {'bytes_%x' % K: ('cst', 0)})
    return sc

# ---- kind seq_4fa980 ----------------------------------------------------------------------------------------------------
OPS_seq_4fa980 = [('st', 4, 0, 'K0'), ('st', 2, 'K1', 0), ('st', 4, 'K2', 0), ('st', 4, 'K3', 0), ('st', 4, 'K4', 0), ('st', 2, 'K5', 0), ('fill', 'K7', 'K6', 0), ('retself',)]


def gen_seq_4fa980(key, rng, n, c):
    def R(x):
        return c[x] if isinstance(x, str) else x
    ops = []
    for op in OPS_seq_4fa980:
        if op[0] == 'call':
            ops.append((op[0], R(op[1]), op[2] if op[2] in (None, 'self') else R(op[2][1]), [R(a[1]) if isinstance(a, tuple) else None for a in op[3]], op[4]))
        elif op[0] == 'st':
            ops.append((op[0], op[1], R(op[2])))
        elif op[0] == 'fill':
            ops.append((op[0], R(op[1]), R(op[2]) * 4 + op[3]))
    need = 0x40
    for op in ops:
        if op[0] == 'call':
            if op[2] not in (None, 'self'):
                need = max(need, op[2] + 0x10)
            need = max(need, max([a for a in op[3] if a is not None] or [0]) + 0x10)
        elif op[0] == 'st':
            need = max(need, op[2] + op[1] + 0x10)
        else:
            need = max(need, op[1] + op[2] + 0x10)
    s = bytearray(rng.randrange(1, 256) for _ in range(need))
    starts = [(0, 0x20)] + [(op[2] if op[0] == 'st' else op[1], 4) for op in ops if op[0] != 'call']
    probe = []
    for off, ln in starts:
        if (off, ln) not in probe and len(probe) < 8:
            probe.append(('self', off, ln))
    stubs = {}
    for op in ops:
        if op[0] == 'call':
            stubs[op[1]] = stub(op[1], {'this': THISCALL, 'std': STDCALL, 'cdecl': CDECL}[op[4]](len(op[3])), results=[result(rng)], probe=probe)
    sc = make(key, [self_area_bytes(s)], stubs, {}, [], (), (n,))
    pass
    return sc

SIZES = {
    '48ef40': (168, 168),
    '4904fa': (77, 77),
    '49192b': (71, 71),
    '495608': (203, 203),
    '49c53a': (101, 101),
    '49cf80': (185, 185),
    '4a0c7f': (107, 107),
    '4ac8da': (163, 163),
    '4beeb3': (94, 94),
    '4c9cdd': (180, 180),
    '4d52b9': (93, 93),
    '4d6ad1': (119, 119),
    '4d8f0a': (131, 131),
    '4dc13f': (67, 67),
    '4de5f0': (126, 126),
    '4e0410': (127, 127),
    '4e069c': (36, 36),
    '4e1c50': (51, 51),
    '4e4428': (37, 37),
    '4e498d': (85, 85),
    '4e7a70': (199, 199),
    '4eb77d': (195, 181),
    '4eb870': (142, 142),
    '4ec005': (130, 130),
    '4fa8d2': (174, 171),
    '4fa980': (103, 103),
}
ROWS = {
    '48ef40': ('advslot', {'SL': 30, 'ST': 141, 'TB': 6010341, 'CU': 1022, 'MD': 176, 'AR': 1130}),
    '4904fa': ('seq_4904fa', {'C0': 5363478, 'K1': 5430008, 'K2': 8055, 'K3': 8059, 'K4': 1970, 'K5': 32}),
    '49192b': ('clearblk', {'P': 20723, 'N': 20727, 'F': 20731}),
    '495608': ('checkobj', {'G': 18281, 'K1': 5568648, 'P': 8223, 'O': 40, 'W': 73, 'OB1': 6091243, 'C1': 5202740, 'OB2': 6044263, 'C2': 5223139, 'K2': 5568660, 'C3': 5228664}),
    '49c53a': ('seq_49c53a', {'K0': 5408093, 'C1': 5363478, 'K2': 5430216, 'K3': 876, 'K4': 40, 'C5': 4834800}),
    '49cf80': ('fillcells', {'FN': 3572, 'PT': 3552, 'HT': 3548, 'WD': 3544}),
    '4a0c7f': ('countne', {'CNT': 3608, 'R': 10, 'S': 350, 'B': 44}),
    '4ac8da': ('seq_4ac8da', {'K0': 30, 'K1': 65535, 'K2': 28, 'K3': 65535, 'K4': 3099, 'K5': 3095, 'K6': 3103, 'K7': 3108, 'K8': 32, 'K9': 36, 'K10': 65535, 'K11': 70, 'K12': 106, 'K13': 3125, 'K14': 746, 'K15': 110, 'K16': 12, 'K17': 3673}),
    '4beeb3': ('impclear', {'C1': 4977548, 'N': 14, 'O': 132, 'F': 704, 'V': 4294967293, 'IMP': 5416244}),
    '4c9cdd': ('findzero', {'CNT': 5976, 'S': 996, 'B': 780, 'RES': 5980}),
    '4d52b9': ('seq_4d52b9', {'K0': 32, 'K1': 4, 'K2': 132, 'K3': 12, 'K4': 148, 'K5': 12, 'K6': 164, 'K7': 12}),
    '4d6ad1': ('tickstr', {'Z1': 1121, 'W': 716, 'T': 1125, 'S': 38611, 'L': 1129, 'Z2': 1133, 'Z3': 1134, 'Z4': 1138}),
    '4d8f0a': ('rellist', {'HD': 38916, 'NX': 264, 'C1': 5083021, 'TL': 38924, 'C2': 5364844, 'N': 41}),
    '4dc13f': ('copycount', {'O': 78, 'A': 5615704, 'C1': 4498103}),
    '4de5f0': ('seq_4de5f0', {'K0': 5409054, 'K1': 1007, 'C2': 5119056, 'K3': 1406, 'C4': 5171584, 'K5': 5432528, 'K6': 226, 'K7': 4, 'C8': 5105367}),
    '4e0410': ('seq_4e0410', {'K0': 5409131, 'K1': 5119107, 'K2': 5119056, 'N5': 5, 'K3': 399, 'K4': 1879, 'C5': 5294886, 'K6': 5432548, 'K7': 466, 'K8': 4, 'C9': 5113075}),
    '4e069c': ('copyin_b', {'O': 4, 'N': 466}),
    '4e1c50': ('seq_4e1c50', {'K0': 5432552, 'K1': 59, 'K2': 56, 'C3': 5119135}),
    '4e4428': ('copyin_a', {'N': 1083, 'O': 21727}),
    '4e498d': ('setname', {'A': 2688, 'O': 17724, 'N': 12}),
    '4e7a70': ('seq_4e7a70', {'K0': 5409364, 'C1': 5167632, 'K2': 5119107, 'K3': 5119056, 'N6': 6, 'K4': 399, 'K5': 30292, 'C6': 5294886, 'K7': 5432564, 'K8': 1689, 'K9': 1685, 'K10': 1681, 'K11': 715, 'K12': 27424, 'K13': 6431, 'K14': 1693, 'C15': 5143463}),
    '4eb77d': ('filltable', {'CT': 33326, 'R': 70, 'S': 110, 'T0': 5783327, 'SRC': 1810, 'T1': 5783328, 'SRC2': 1761, 'T2': 5783388, 'N': 12}),
    '4eb870': ('seq_4eb870', {'K0': 5409460, 'C1': 5167632, 'K2': 5119107, 'K3': 5119056, 'N2': 2, 'K4': 399, 'K5': 3240, 'C6': 5294886, 'K7': 5432568, 'K8': 386, 'K9': 1685, 'C10': 5159368}),
    '4ec005': ('copylimit', {'O': 1685, 'N': 386, 'B': 1547, 'S1': 5622856, 'S2': 6523019, 'P': 5294654, 'M': 5781881, 'Q': 4351208, 'X': 6092377, 'Y': 5019572}),
    '4fa8d2': ('checkname', {'K': 5637132, 'N': 21, 'S1': 5637156, 'S2': 6523019, 'P': 5294654, 'Q': 4498103, 'S3': 5637240}),
    '4fa980': ('seq_4fa980', {'K0': 5432600, 'K1': 46964, 'K2': 46966, 'K3': 46970, 'K4': 46974, 'K5': 46978, 'K6': 11736, 'K7': 4}),
}

GEN = {'advslot': gen_advslot, 'seq_4904fa': gen_seq_4904fa, 'clearblk': gen_clearblk, 'checkobj': gen_checkobj, 'seq_49c53a': gen_seq_49c53a, 'fillcells': gen_fillcells, 'countne': gen_countne, 'seq_4ac8da': gen_seq_4ac8da, 'impclear': gen_impclear, 'findzero': gen_findzero, 'seq_4d52b9': gen_seq_4d52b9, 'tickstr': gen_tickstr, 'rellist': gen_rellist, 'copycount': gen_copycount, 'seq_4de5f0': gen_seq_4de5f0, 'seq_4e0410': gen_seq_4e0410, 'copyin_b': gen_copyin_b, 'seq_4e1c50': gen_seq_4e1c50, 'copyin_a': gen_copyin_a, 'setname': gen_setname, 'seq_4e7a70': gen_seq_4e7a70, 'filltable': gen_filltable, 'seq_4eb870': gen_seq_4eb870, 'copylimit': gen_copylimit, 'checkname': gen_checkname, 'seq_4fa980': gen_seq_4fa980}
COUNTS = {'advslot': 108, 'seq_4904fa': 6, 'clearblk': 24, 'checkobj': 28, 'seq_49c53a': 6, 'fillcells': 40, 'countne': 24, 'seq_4ac8da': 6, 'impclear': 12, 'findzero': 18, 'seq_4d52b9': 6, 'tickstr': 24, 'rellist': 24, 'copycount': 60, 'seq_4de5f0': 6, 'seq_4e0410': 6, 'copyin_b': 6, 'seq_4e1c50': 6, 'copyin_a': 6, 'setname': 18, 'seq_4e7a70': 6, 'filltable': 12, 'seq_4eb870': 6, 'copylimit': 30, 'checkname': 30, 'seq_4fa980': 6}
KIND_NAMES = {'advslot': 'advance_slot', 'seq_4904fa': 'construct_record', 'clearblk': 'clear_block', 'checkobj': 'check_object', 'seq_49c53a': 'construct_record', 'fillcells': 'fill_cells', 'countne': 'count_nonempty', 'seq_4ac8da': 'init_record', 'impclear': 'bind_buffer', 'findzero': 'find_zero_record', 'seq_4d52b9': 'init_record', 'tickstr': 'start_timer', 'rellist': 'release_list', 'copycount': 'copy_counted', 'seq_4de5f0': 'construct_record', 'seq_4e0410': 'construct_record', 'copyin_b': 'copy_in', 'seq_4e1c50': 'construct_record', 'copyin_a': 'copy_in', 'setname': 'set_name', 'seq_4e7a70': 'construct_record', 'filltable': 'fill_name_table', 'seq_4eb870': 'construct_record', 'copylimit': 'copy_checked', 'checkname': 'check_name', 'seq_4fa980': 'construct_record'}
SPECFLAGS = {'48ef40': {}, '4904fa': {'retself': True}, '49192b': {}, '495608': {}, '49c53a': {'retself': True}, '49cf80': {}, '4a0c7f': {}, '4ac8da': {}, '4beeb3': {'ret': True, 'cleanup': 4}, '4c9cdd': {'ret': True, 'cleanup': 4, 'ptr_args': True}, '4d52b9': {}, '4d6ad1': {}, '4d8f0a': {}, '4dc13f': {'cleanup': 8, 'ptr_args': True}, '4de5f0': {'retself': True}, '4e0410': {'retself': True}, '4e069c': {'cleanup': 8, 'ptr_args': True}, '4e1c50': {'retself': True}, '4e4428': {'cleanup': 8, 'ptr_args': True}, '4e498d': {'cleanup': 4, 'ptr_args': True}, '4e7a70': {'retself': True}, '4eb77d': {}, '4eb870': {'retself': True}, '4ec005': {'cleanup': 8, 'ptr_args': True}, '4fa8d2': {'ret': True, 'cleanup': 16, 'ptr_args': True}, '4fa980': {'retself': True}}
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
