"""FL-29 (batch a): the fixtures shared by tests/test_fl29a_differential.py and tests/fl29a_original_oracle.py.

Same shape as tests/fl28b_fixtures.py (whose generic harness pieces are imported: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object
`this`, the objects behind the addresses it keeps, the vtables, the scripted callees (recording stubs at the call boundary, entered by address) and the
globals. The scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the vtable entries are recording stubs (OS or host boundaries);
nothing inside the function under test is patched. One scenario of 0x4895cc (the allocation returns 0) maps a zero page: the original then stores
through the null pointer (it would fault on Windows), and the native port rejects there (`sc.partial`: the number of calls and the memory the native port
is compared on).
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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl29aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl29a.h').read_text()
    body = re.search(r'typedef struct Fl29aWorld \{(.*?)\} Fl29aWorld;', text, re.S).group(1)
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
VT_A = od.STUB_BASE + 0x900          # the vtable entry that the original reads and calls (a stub inside the mapped stub page)
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte


def make(key, areas, stubs, g, stack, args, profile, pointers=None, partial=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat={}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None,
                           partial=partial)


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
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, {})
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, {}, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret16'):
        h.update(struct.pack('<H', orig.eax & 0xffff))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests)
UNTAKEN_ALLOWED = {
    '4c3efb': {
        (0x4c3f1f, 'fall-through'): 'the second `cmp [ebp+0xc], 0; jne` repeats the test of 0x4c3f15/0x4c3f19: a value that is not 0 has already jumped past this point, so the jne is always taken',
        (0x4c3fe7, 'taken'): '`mov ecx, 1; test ecx, ecx; je`: the guard of the retry loop is always true, so the je is never taken (its target 0x4c405f is reached through 0x4c3fd2 and 0x4c400d)',
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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


# ---- helpers ---------------------------------------------------------------------------------------------------------------------


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def tbl_area(rng, lo, hi):
    """The table of stride 0x4a at the original address 0x5d15a5 for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * 0x4a))
    return Area('tbl', 0x5d15a5 + lo * 0x4a, data, image=True), {'table_5d15a5': ('tbl', -lo * 0x4a)}


REPORT_STUBS = lambda: {0x52139c: stub(0x52139c, STDCALL(3)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}


# ---- 0x4d39f9 ---------------------------------------------------------------------------------------------------------------------


def gen_4d39f9(rng, n):
    (kind, *rest), variant = prof(n, [('hit', k) for k in range(0x18, 0x40)] + [('none',)])
    area, ptrs = tbl_area(rng, 0, 0x40)
    d = area.data
    for i in range(0x41):
        put32(d, i * 0x4a + 4, 0)
    for i in range(0x18, 0x40):
        put32(d, i * 0x4a + 4, NONZERO[(variant + i) % len(NONZERO)])
    if kind == 'hit':
        put32(d, rest[0] * 0x4a + 4, 0)
        if variant % 2:      # later free entries do not matter: the first one wins
            for i in range(rest[0] + 1, 0x40, 3):
                put32(d, i * 0x4a + 4, 0)
    return make('4d39f9', [area], REPORT_STUBS(), {}, [], (), (kind, *rest), ptrs)


# ---- 0x4d3992 ---------------------------------------------------------------------------------------------------------------------


def gen_4d3992(rng, n):
    idx_list = [-3, -2, -1, 0, 1, 0x2a, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5b]
    (idx,), variant = prof(n, [(i,) for i in idx_list])
    area, ptrs = tbl_area(rng, -3, 0x5b)
    for i in range(-3, 0x5c):
        for off in (0, 4):
            if variant % 2 or rng.random() < 0.5:
                put32(area.data, (i + 3) * 0x4a + off, rng.choice(NONZERO))
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3)), 0x52139c: stub(0x52139c, STDCALL(3)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}
    a = word_arg(rng, idx)
    return make('4d3992', [area], stubs, {}, [a], (a,), (idx,), ptrs)


# ---- 0x4c92c5 ---------------------------------------------------------------------------------------------------------------------

WORDS_VA, DWORDS_VA = 0x5afbda, 0x5d032f
WORD_VALUES = [0, 1, 2, 3, 0x7fff, 0x8000, 0xffff]


def gen_4c92c5(rng, n):
    profiles = [(i, d, w) for i in (-3, -1, 0, 1, 5) for d in (0, 1, 0x10000, 0x80000000) for w in WORD_VALUES]
    (idx, dval, word), variant = prof(n, profiles)
    words = Area('words', WORDS_VA - 8, bytearray(rng.randbytes(13 * 2)), image=True)
    dwords = Area('dwords', DWORDS_VA - 16, bytearray(rng.randbytes(13 * 4)), image=True)
    for i in range(-4, 9):
        if variant % 2 or rng.random() < 0.5:
            put32(dwords.data, (i + 4) * 4, rng.choice(NONZERO))
    put16(words.data, (idx + 4) * 2, word)
    put32(dwords.data, (idx + 4) * 4, dval)
    stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=[('words', 0, 26), ('dwords', 0, 52)])}
    a = word_arg(rng, idx)
    return make('4c92c5', [words, dwords], stubs, {}, [a], (a,), (idx, hex(dval), hex(word)), {'words_5afbda': ('words', 8), 'dwords_5d032f': ('dwords', 16)})


# ---- 0x4c948f ---------------------------------------------------------------------------------------------------------------------


def gen_4c948f(rng, n):
    (kind, *rest), variant = prof(n, [('hit', k) for k in range(0x18)] + [('none',)])
    s = bytearray(rng.randbytes(0x1000))
    for i in range(0x19):
        put32(s, 0xc72 + i * 4, NONZERO[(variant + i) % len(NONZERO)])
    put32(s, 0xc72 + 0x18 * 4, 0)             # the entry after the last one is free but not looked at
    put32(s, 0xc72 - 4, 0)
    if kind == 'hit':
        put32(s, 0xc72 + rest[0] * 4, 0)
        if variant % 2:
            for i in range(rest[0] + 1, 0x18, 2):
                put32(s, 0xc72 + i * 4, 0)
    return make('4c948f', [self_area(s)], REPORT_STUBS(), {}, [], (), (kind, *rest))


# ---- 0x4c4202 ---------------------------------------------------------------------------------------------------------------------

HRS = [0, 1, 0xffffffff, 0x887601c2, 0x80004005, 0x10000, 0x80000000]


def gen_4c4202(rng, n):
    (kind, *rest), variant = prof(n, [('same',)] + [('hr', h) for h in HRS])
    obj_va, vt_va = od.region_va(1), od.region_va(2)
    s = bytearray(rng.randbytes(0x400))
    put32(s, 0xc, obj_va if kind == 'same' else [obj_va ^ 1, obj_va ^ 0x10000, obj_va ^ 0x80000000, 0, 0xffffffff][variant % 5])
    obj = bytearray(rng.randbytes(0x100))
    put32(obj, 0, vt_va)
    vt = bytearray(rng.randbytes(0x100))
    put32(vt, 0x80, VT_A)
    stubs = {VT_A: stub(VT_A, (2, True, 8), results=[rest[0] if kind == 'hr' else 0]), 0x4c88c7: stub(0x4c88c7, THISCALL(1), results=[rng.randrange(1 << 32)]),
             0x42639d: stub(0x42639d, THISCALL(2)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}
    stack = [obj_va, rng.randrange(1 << 32), rng.randrange(1 << 32)]
    return make('4c4202', [self_area(s), Area('obj', obj_va, obj, image=False), Area('vtbl', vt_va, vt, image=False)], stubs, {}, stack, tuple(stack), (kind, *rest))


# ---- 0x4c46d1 ---------------------------------------------------------------------------------------------------------------------

SHIFTS = [0, 1, 5, 6, 0xb, 0xa, 0xf, 0x10, 0x1f, 0x20, 0x25, 0xff]
SIZES = [(0, 5), (5, 0), (1, 1), (3, 2), (4, 4), (16, 8), (-1, 5), (5, -1), (-2, -3), (-1, -1)]


def gen_4c46d1(rng, n):
    (sel, size), variant = prof(n, [(sel, size) for sel in range(8) for size in SIZES])
    s = bytearray(rng.randbytes(0x3a00))
    for off in (0x38c6, 0x38c5, 0x38c4):
        s[off] = rng.choice([0xff, 0x1f, 0x3f, 0x7f, 0xf8, 0, rng.randrange(256)])
    for k, off in enumerate((0x38ca, 0x38c9, 0x38c8)):
        s[off] = 5 if (sel >> k) & 1 else rng.choice([0, 1, 6, 0xff])
    for off in (0x38c2, 0x38c1, 0x38c0):
        s[off] = rng.choice(SHIFTS)
    surf_va, pix_va = od.region_va(1), od.region_va(2)
    surf = bytearray(rng.randbytes(0x100))
    put32(surf, 0, pix_va)
    put16(surf, 0x2b, size[0])
    put16(surf, 0x2d, size[1])
    pix = bytearray(rng.randbytes(0x400))
    stack = [surf_va] + [rng.randrange(1 << 32) for _ in range(3)]
    return make('4c46d1', [self_area(s), Area('surf', surf_va, surf, image=False), Area('pix', pix_va, pix, image=False)], {}, {}, stack, tuple(stack), (sel, size))


# ---- 0x4c9340 ---------------------------------------------------------------------------------------------------------------------

PIX_BASE = 0x100


def scanned(base, pitch, bpp, x0, y0, x1, y1):
    p = base + y0 * pitch + x0 * bpp
    rows, nbytes, out = y1 - y0 + 1, (x1 - x0 + 1) * bpp, []
    for _ in range(max(rows, 0)):
        for j in range(0, max(nbytes, 0), 2):
            out.append(p + j)
        p += pitch
    return out


def gen_4c9340(rng, n):
    shapes = [('null',), ('rows0',), ('rows_neg',), ('cols0',), ('cols_neg',), ('equal',), ('hit',), ('hit',), ('hit',), ('outside',), ('odd',), ('negpitch',), ('bpp1',), ('bpp3',), ('bpp0',)]
    (kind,), variant = prof(n, [(k,) for k in [s[0] for s in shapes]])
    bpp = {'bpp1': 1, 'odd': 1, 'bpp3': 3, 'bpp0': 0}.get(kind, 2)
    pitch = {'negpitch': -0x10, 'bpp0': 0x10}.get(kind, rng.choice([8, 0x10, 0x20, 0, 0x14]))
    x0, y0 = rng.randrange(0, 4), rng.randrange(0, 3)
    wd, ht = rng.randrange(1, 5), rng.randrange(1, 4)
    x1, y1 = x0 + wd - 1, y0 + ht - 1
    if kind == 'odd':
        x1 = x0 + 2                   # 3 bytes: the last word read starts at the third byte and ends outside the row
    if kind == 'rows0':
        y1 = y0 - 1
    elif kind == 'rows_neg':
        y1 = y0 - 1 - rng.randrange(1, 3)
    elif kind == 'cols0':
        x1 = x0 - 1
    elif kind == 'cols_neg':
        x1 = x0 - 2 - rng.randrange(0, 2)
    if kind == 'negpitch':
        y0, y1 = 3, 3 + ht - 1
    key = rng.choice([0, 0x8000, 0xffff, 0x1234, 0x00ff, 0xff00])
    s = bytearray(rng.randbytes(0x3a00))
    put16(s, 0x38d0, key)
    pix = bytearray(0x400)
    for i in range(0, 0x400, 2):
        put16(pix, i, key)
    pos = scanned(PIX_BASE, pitch, bpp, x0, y0, x1, y1)
    allp = set(range(0, 0x3fe, 2))
    if kind in ('hit', 'odd', 'negpitch', 'bpp1', 'bpp3') and pos:
        for at in rng.sample(pos, min(len(pos), rng.choice([1, 1, 2, 3]))):
            put16(pix, at, key ^ rng.choice([1, 0x8000, 0xffff, 0x100, 0x7fff]))
        if kind == 'hit' and variant == 0:      # the very first word
            put16(pix, pos[0], key ^ 0x8000)
    elif kind == 'outside':
        for at in rng.sample(sorted(allp - set(pos) - {p + 1 for p in pos}), 3):
            put16(pix, at, key ^ 0xffff)
    if kind == 'odd' and pos:
        put16(pix, pos[-1], key ^ 0x0100)     # the word that ends one byte behind the 3 byte row
    if kind == 'bpp0':
        for at in rng.sample(sorted(allp), 3):
            put16(pix, at, key ^ 1)
    surf_va, rect_va, pix_va = od.region_va(1), od.region_va(2), od.region_va(3)
    surf = bytearray(rng.randbytes(0x100))
    put32(surf, 0, pix_va + PIX_BASE)
    put16(surf, 0x2f, pitch)
    rect = bytearray(rng.randbytes(0x10))
    for k, v in enumerate((x0, y0, x1, y1)):
        put32(rect, 4 * k, v)
    stack = [0 if kind == 'null' else surf_va, rect_va]
    return make('4c9340', [self_area(s), Area('surf', surf_va, surf, image=False), Area('rect', rect_va, rect, image=False), Area('pix', pix_va, pix, image=False)],
                {}, {'word_639895': bpp}, stack, tuple(stack), (kind, bpp, pitch, (x0, y0, x1, y1)))


# ---- 0x4cb9d1 ---------------------------------------------------------------------------------------------------------------------


def gen_4cb9d1(rng, n):
    counts = [0, 1, 2, 5, -1, -0x8000, 3, 4]
    (kind, *rest), variant = prof(n, [('s0',), ('o0',)] + [('go', c) for c in counts])
    s_va, ents_va, obj_va = od.region_va(1), od.region_va(2), od.region_va(3)
    s = bytearray(rng.randbytes(0x40))
    count = rest[0] if kind == 'go' else rng.randrange(1, 4)
    put16(s, 2, count)
    put32(s, 9, ents_va)
    ents = bytearray(rng.randbytes(0x200))
    for k in range(0, 0x200, 4):
        if rng.random() < 0.2:
            put32(ents, k, rng.choice([0xffffffff, 0, 0x7fffffff, 0x80000000]))
    obj = bytearray(rng.randbytes(0x40))
    if variant % 2:
        put32(obj, 0x12, rng.choice([0, 0xffffffff, 0x80000000]))
        put32(obj, 0x16, rng.choice([0, 0xffffffff, 0x7fffffff]))
    me = bytearray(rng.randbytes(0x200))
    put32(me, 0x12, 0 if kind == 's0' else s_va)
    stubs = {0x4c0c69: stub(0x4c0c69, THISCALL(0), probe=[('self', 0x120, 0x50)], results=[0 if kind == 'o0' else obj_va])}
    return make('4cb9d1', [self_area(me), Area('s', s_va, s, image=False), Area('ents', ents_va, ents, image=False), Area('obj', obj_va, obj, image=False)],
                stubs, {}, [], (), (kind, *rest))


# ---- 0x4895cc ---------------------------------------------------------------------------------------------------------------------

BUF_VA, ZERO_VA = od.region_va(4), 0
LENGTHS = [0, 1, 3, 4, 5, 0x1f, 0x20, 0x21, 0x22, 0x23, 0x24, 0x30, 0x60]


def gen_4895cc(rng, n):
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', ln) for ln in LENGTHS])
    me_va, cells_va, q_va = od.region_va(0), od.region_va(1), od.region_va(2)
    me = bytearray(rng.randbytes(0x100))
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.randrange(1 << 32))
    put32(cells, 4, q_va)
    put32(cells, 8, rng.choice([0, 0xffffffbb, 0x7fffffff, rng.randrange(1 << 32)]))
    q = bytearray(rng.randbytes(0x100))
    ln = rest[0] if kind == 'ok' else rng.choice(LENGTHS)
    for i in range(ln):
        if q[i] == 0:
            q[i] = 1 + i
    q[ln] = 0
    buf = bytearray(rng.randbytes(0xc00))
    g = {'value_5bb57b': rng.randrange(1 << 32), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234]),
         'word_63a4cd': [0, 1, 0x100, 0x8000, 0xffff][variant % 5]}
    probes = [('self', 0, 0x30), ('buf', 0, 0x48)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else BUF_VA]), 0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x42639d: stub(0x42639d, THISCALL(2)),
             0x4c97b4: stub(0x4c97b4, THISCALL(0)), 0x48945b: stub(0x48945b, THISCALL(2), probe=probes), 0x44a2b7: stub(0x44a2b7, CDECL(1))}
    areas = [self_area(me), Area('cells', cells_va, cells, image=False), Area('q', q_va, q, image=False), Area('buf', BUF_VA, buf, image=False)]
    partial = None
    if kind == 'null':
        areas.append(Area('zero', ZERO_VA, bytearray(0x1000), image=False, compare=False))
        partial = (4, {'cells': 4})
    stack = [cells_va, cells_va + 4, cells_va + 8]
    return make('4895cc', areas, stubs, g, stack, tuple(stack), (kind, *rest), partial=partial)


# ---- 0x4c3efb ---------------------------------------------------------------------------------------------------------------------

LOCK_RESULTS = [[0], [0x887601c2, 0], [0x8876021c, 0], [0x80004005, 0], [0x887601c2, 0x8876021c, 0x1234, 0], [0xffffffff, 0x887601c2, 0x10000, 0x8876021c, 0],
                [0x887601c3, 0], [0x8876021d, 0], [0x88760000, 0x987601c2, 0]]


def gen_4c3efb(rng, n):
    profiles = [('fast_norect',), ('fast_rect', 0), ('fast_rect', 1)] + [('lock', i) for i in range(len(LOCK_RESULTS))]
    (kind, *rest), variant = prof(n, profiles)
    surf_va, vt_va, rect_va, desc_va = od.region_va(1), od.region_va(2), od.region_va(3), od.region_va(4)
    s = bytearray(rng.randbytes(0x200))
    put32(s, 0xc, surf_va if kind.startswith('fast') else [surf_va ^ 1, surf_va ^ 0x10000, 0, 0xffffffff][variant % 4])
    if kind.startswith('fast'):      # words that are negative / above 16 bits when read as dwords
        put16(s, 0x1a, rng.choice([0x8000, 0xffff, 0x7fff, 0x1234]))
        put16(s, 0x18, rng.choice([0x8000, 0xffff, 0x7fff, 0x4321]))
        put16(s, 0x20, rng.choice([0x8000, 0xffff, 0x7fff, 3]))
    surf = bytearray(rng.randbytes(0x100))
    put32(surf, 0, vt_va)
    vt = bytearray(rng.randbytes(0x100))
    put32(vt, 0x64, VT_A)
    rect = bytearray(rng.randbytes(0x10))
    for k in range(4):
        put32(rect, 4 * k, rng.choice([0, 1, 5, 0xffffffff, 0x80000000, 0x7fffffff, rng.randrange(1 << 32)]))
    desc = bytearray(rng.randbytes(0x100))
    results = LOCK_RESULTS[rest[0]] if kind == 'lock' else [0]
    stubs = {VT_A: stub(VT_A, (5, False, 20), probe=[('desc', 0, 0x10)], results=results), 0x4c4dc3: stub(0x4c4dc3, THISCALL(0)),
             0x4c88c7: stub(0x4c88c7, THISCALL(1), results=[rng.randrange(1 << 32)]), 0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x4264e8: stub(0x4264e8, THISCALL(1))}
    use_rect = 0 if kind in ('fast_norect',) else rect_va
    if kind == 'lock' and variant % 2:
        use_rect = 0
    stack = [surf_va, use_rect, desc_va, rng.randrange(1 << 32)]
    return make('4c3efb', [self_area(s), Area('surf', surf_va, surf, image=False), Area('vtbl', vt_va, vt, image=False), Area('rect', rect_va, rect, image=False),
                           Area('desc', desc_va, desc, image=False)], stubs, {}, stack, tuple(stack), (kind, *rest))


SPECS = {
    '4d39f9': dict(id=1, va=0x4d39f9, size=89, gen=gen_4d39f9, cleanup=0, ret16=True, n=29 * 3),
    '4c4202': dict(id=2, va=0x4c4202, size=92, gen=gen_4c4202, cleanup=12, n=8 * 10),
    '4c948f': dict(id=3, va=0x4c948f, size=93, gen=gen_4c948f, cleanup=0, ret16=True, n=25 * 3),
    '4d3992': dict(id=4, va=0x4d3992, size=103, gen=gen_4d3992, cleanup=0, n=12 * 6),
    '4c92c5': dict(id=5, va=0x4c92c5, size=123, gen=gen_4c92c5, cleanup=4, n=5 * 4 * 7 * 2),
    '4c9340': dict(id=6, va=0x4c9340, size=232, gen=gen_4c9340, cleanup=8, ret16=True, n=15 * 24),
    '4c46d1': dict(id=7, va=0x4c46d1, size=277, gen=gen_4c46d1, cleanup=16, n=80 * 3),
    '4cb9d1': dict(id=8, va=0x4cb9d1, size=303, gen=gen_4cb9d1, cleanup=0, n=10 * 8),
    '4895cc': dict(id=9, va=0x4895cc, size=342, gen=gen_4895cc, cleanup=12, n=14 * 10),
    '4c3efb': dict(id=10, va=0x4c3efb, size=364, gen=gen_4c3efb, cleanup=16, n=12 * 8),
}
KEYS = list(SPECS)
NAMES = {'4d39f9': 'find_free_entry', '4c4202': 'check_vtable_call', '4c948f': 'find_free_slot', '4d3992': 'clear_entry', '4c92c5': 'count_down', '4c9340': 'scan_surface',
         '4c46d1': 'fill_surface', '4cb9d1': 'relocate_entries', '4895cc': 'init_buffer', '4c3efb': 'lock_surface'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
