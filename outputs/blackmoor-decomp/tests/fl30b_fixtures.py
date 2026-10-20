"""FL-30 (batch b): the fixtures shared by tests/test_fl30b_differential.py and tests/fl30b_original_oracle.py.

Same shape as tests/fl29a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py). `build(key, rng, n)` makes scenario n of one of the functions of SPECS:
the object `this`, the objects behind the addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios
cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional parts vary from one pass of the cycle to the
next; random bytes fill everything else. `run_original(sc)` runs ONLY the original bytes (Unicorn); nothing inside the function under test is patched.
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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, records_area, debug_areas,
                            REC_STRIDE, RECORDS_VA)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl30bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl30b.h').read_text()
    body = re.search(r'typedef struct Fl30bWorld \{(.*?)\} Fl30bWorld;', text, re.S).group(1)
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
    runner = Original27(image_patches, regions, sc.stubs, {}, fpcw=SPECS[sc.key].get('fpcw'))
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
    '44b26a': {
        (0x44b28f, 'taken'): '`xor eax, eax; mov al, [edx]; test eax, eax; jl`: eax is a zero-extended byte, so SF is clear and the jl is never taken (its target 0x44b29d is reached through the jle at 0x44b29b when the byte is above 0x27, and executed)',
    },
    #ALLOW
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


def f32(x):
    return struct.pack('<f', x)


# ---- 0x44b26a ---------------------------------------------------------------------------------------------------------------------

TAB_VA = 0x58c91d           # floats at +kind*4, words at 0x58c959 + kind*2 (= +0x3c + kind*2)
FLOATS = [9999.0, 0.0, -1.5, 1e10, 3.4e38, float('nan'), float('inf'), float('-inf'), 1e-45, 12345.0, -9999.0, 0.5, 9998.999]
WORDS = [0x270f, 0x270e, 0x2710, 0, 0xffff, 0x7fff, 0x8000, 1, 0xd8f1]
DELTAS = [0, 1, 0x8000, 0xffff, 0x7fff, 5, 0x270f, 0xff00, 0x1234]


def gen_44b26a(rng, n):
    profiles = [('big', k, dbg) for k in (0x28, 0x29, 0x80, 0xff) for dbg in (0, 1, 0x100, 0x8000)]
    profiles += [('word', k, fl, w) for k in (0, 1, 0x1d, 7) for fl in (0, 1, 0xff) for w in WORDS]
    profiles += [('float', k, fl, f) for k in (0x1e, 0x1f, 0x27, 0x22) for fl in (0, 1, 0x80) for f in range(len(FLOATS))]
    (kind, *rest), variant = prof(n, profiles)
    slot = (0, 2, -1, 1)[(n + variant) % 4]
    delta = DELTAS[(n * 3 + variant) % len(DELTAS)]
    tab = bytearray(rng.randbytes(0xa0))
    item = bytearray(rng.randbytes(0x10))
    dbg = 0
    if kind == 'big':
        item[0], dbg = rest[0], rest[1] * rng.choice([1, 1])
    elif kind == 'word':
        item[0], item[1] = rest[0], rest[1]
        put16(tab, 0x3c + rest[0] * 2, rest[2])
    else:
        item[0], item[1] = rest[0], rest[1]
        tab[rest[0] * 4:rest[0] * 4 + 4] = f32(FLOATS[rest[2]])
        if variant == 1 and FLOATS[rest[2]] == FLOATS[rest[2]]:
            tab[rest[0] * 4:rest[0] * 4 + 4] = f32(rng.choice([9999.0, 9999.5, -9999.0, 1e7, 3.0]))
    put16(item, 2, delta)
    if kind != 'big':
        dbg = rng.choice([0, 1])
    recs, pointers = records_area(rng, slot, od.region_va(1))
    pointers['words_58c959'] = ('tab', 0x3c)
    pointers['floats_58c91d'] = ('tab', 0)
    g, nbr = debug_areas(rng, dbg)
    probe = [('tab', 0, 0xa0)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3), probe), 0x52139c: stub(0x52139c, STDCALL(3), probe), 0x42ba3a: stub(0x42ba3a, CDECL(1), probe)}
    WORD_ARGS[0x42ba3a] = (0,)
    a = word_arg(rng, slot)
    return make('44b26a', [Area('tab', TAB_VA, tab, image=True), Area('item', od.region_va(1), item, image=False), recs, *nbr], stubs, g, [a], (a,), (kind, *rest, slot, hex(delta)), pointers)


# ---- 0x488e9c ---------------------------------------------------------------------------------------------------------------------

BUF_VA = od.region_va(4)


def gen_488e9c(rng, n):
    profiles = [('null',)] + [('ok', mode, cnt, m) for mode in ('d2', 'dother') for cnt in (0, 1, 2, 3, 5, 0x20) for m in (0, 1, 2, 3, 0x19)]
    (kind, *rest), variant = prof(n, profiles)
    me_va, cells_va, q_va = od.region_va(0), od.region_va(1), od.region_va(2)
    me = bytearray(rng.randbytes(0x100))
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 4, q_va)
    put32(cells, 8, rng.choice([0, 0xffffffbb, 0x7fffffff, 0xfffffff0, rng.randrange(1 << 32)]))
    mode, cnt, m = (rest + [None, None, None])[:3] if kind == 'ok' else (rng.choice(['d2', 'dother']), rng.choice([0, 2, 5]), rng.choice([0, 1, 3]))
    q = bytearray(rng.randbytes(0xc00))
    if mode == 'd2':
        put16(q, 0x29, 2)
        a = rng.randrange(-300, 300)
        put16(q, 0x33, a)
        put16(q, 0x35, a + cnt - 1)
        put16(q, 0x2b, rng.randrange(0x10000))
    else:
        put16(q, 0x29, [0, 1, 3, 0x102, 0xffff, 0x8002, 0x0200][(variant + n) % 7])
        put16(q, 0x2b, cnt)
        put16(q, 0x33, rng.randrange(0x10000))
        put16(q, 0x35, rng.randrange(0x10000))
    put16(q, 0xaa, m)
    buf = bytearray(rng.randbytes(0xc00))
    g = {'value_5bb57b': rng.randrange(1 << 32), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234]), 'word_63a4cd': [0, 1, 0x100, 0x8000, 0xffff][variant % 5]}
    probe = [('self', 0, 0x30), ('cells', 0, 0x10)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[0 if kind == 'null' else BUF_VA]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe),
             0x42639d: stub(0x42639d, THISCALL(2), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    areas = [self_area(me), Area('cells', cells_va, cells, image=False), Area('q', q_va, q, image=False), Area('buf', BUF_VA, buf, image=False)]
    partial = None
    if kind == 'null':
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))
        partial = (4, {'cells': 4})
    stack = [cells_va, cells_va + 4, cells_va + 8]
    return make('488e9c', areas, stubs, g, stack, tuple(stack), (kind, *rest), partial=partial)


# ---- 0x4c5b3a ---------------------------------------------------------------------------------------------------------------------

PIX_BASE = 0x300


def gen_4c5b3a(rng, n):
    shapes = ['normal1', 'normal2', 'normal3', 'normal4', 'odd', 'rows0', 'rows_neg', 'cols0', 'cols_neg', 'negA', 'negB', 'bpp0', 'allkey', 'nokey', 'mixed']
    profiles = [('off', s) for s in shapes] + [('on', s) for s in ('ok', 'w', 'h', 'wh', 'a0', 'b0', 'ok_neg', 'hi1x', 'hi1y', 'hi2x', 'hi2y')]
    (mode, shape), variant = prof(n, profiles)
    bpp = {'normal1': 1, 'odd': 1, 'normal3': 3, 'normal4': 4, 'bpp0': 0}.get(shape, 2)
    pitch_a = {'negA': -0x20, 'ok_neg': -0x18}.get(shape, rng.choice([8, 0x10, 0x20, 0x14, 0x30]))
    pitch_b = {'negB': -0x18, 'ok_neg': -0x28}.get(shape, rng.choice([8, 0x10, 0x20, 0x14, 0x30]))
    x0, y0 = rng.randrange(0, 4), rng.randrange(0, 3)
    wd, ht = rng.randrange(1, 5), rng.randrange(1, 4)
    x1, y1 = x0 + wd - 1, y0 + ht - 1
    if shape == 'odd':
        x1 = x0 + 2
    elif shape == 'rows0':
        y1 = y0 - 1
    elif shape == 'rows_neg':
        y1 = y0 - 1 - rng.randrange(1, 3)
    elif shape == 'cols0':
        x1 = x0 - 1
    elif shape == 'cols_neg':
        x1 = x0 - 2 - rng.randrange(0, 2)
    ya = 3 if pitch_a < 0 else y0
    yb0 = 3 if pitch_b < 0 else rng.randrange(0, 3)
    xb0 = rng.randrange(0, 4)
    y1 += ya - y0
    y0 = ya
    xb1, yb1 = xb0 + (x1 - x0), yb0 + (y1 - y0)
    if mode == 'on' and shape == 'w':
        xb1 += rng.choice([1, -1])
    elif mode == 'on' and shape == 'h':
        yb1 += rng.choice([1, -1])
    elif mode == 'on' and shape == 'wh':
        xb1 += rng.choice([1, 2, -1]); yb1 += rng.choice([1, 3, -2])
    elif mode == 'off':
        xb1, yb1 = xb0 + rng.randrange(-2, 5), yb0 + rng.randrange(-2, 4)
    key = rng.choice([0, 0x8000, 0xffff, 0x1234, 0x00ff, 0xff00])
    s = bytearray(rng.randbytes(0x3a00))
    put16(s, 0x38d0, key)
    pix_a = bytearray(0x800)
    for i in range(0, 0x800, 2):
        if shape == 'allkey' or (shape != 'nokey' and shape != 'mixed' and rng.random() < 0.4) or (shape == 'mixed' and i % 4 == 0):
            put16(pix_a, i, key)
        else:
            put16(pix_a, i, key ^ rng.choice([1, 0x8000, 0xffff, 0x100, 0x7fff]))
    pix_b = bytearray(rng.randbytes(0x800))
    a_va, b_va, r1_va, r2_va, pa_va, pb_va = [od.region_va(i) for i in range(1, 7)]
    da, db = bytearray(rng.randbytes(0x100)), bytearray(rng.randbytes(0x100))
    put32(da, 0, pa_va + PIX_BASE)
    put16(da, 0x2f, pitch_a)
    put32(db, 0, pb_va + PIX_BASE)
    put16(db, 0x2f, pitch_b)
    r1, r2 = bytearray(rng.randbytes(0x10)), bytearray(rng.randbytes(0x10))
    r1v, r2v = [x0, y0, x1, y1], [xb0, yb0, xb1, yb1]
    if mode == 'on':       # the report path does not dereference anything: coordinates with high bits (the sizes are compared as 32-bit values)
        if shape == 'hi1x':
            r1v[2] += 0x10000
        elif shape == 'hi1y':
            r1v[3] += 0x10000
        elif shape == 'hi2x':
            r2v[2] += 0x10000
        elif shape == 'hi2y':
            r2v[3] += 0x20000
        elif shape in ('w', 'h', 'wh'):
            for v in (r1v, r2v):
                a, b = rng.choice([0, 0x10000, 0x7ffe0000, 0x80000000]), rng.choice([0, 0x30000, 0x7ffd0000])
                v[0] += a; v[2] += a; v[1] += b; v[3] += b
    for k, v in enumerate(r1v):
        put32(r1, 4 * k, v)
    for k, v in enumerate(r2v):
        put32(r2, 4 * k, v)
    dbg = [1, 0x100, 0x8000, 0xffff][variant % 4] if mode == 'on' else 0
    stack = [0 if shape == 'a0' else a_va, 0 if shape == 'b0' else b_va, r1_va, r2_va, rng.randrange(1 << 32)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(11)), 0x52139c: stub(0x52139c, STDCALL(3)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}
    areas = [self_area(s), Area('da', a_va, da, image=False), Area('db', b_va, db, image=False), Area('r1', r1_va, r1, image=False), Area('r2', r2_va, r2, image=False),
             Area('pa', pa_va, pix_a, image=False), Area('pb', pb_va, pix_b, image=False)]
    return make('4c5b3a', areas, stubs, {'word_639895': bpp, 'word_63a4cd': dbg}, stack, tuple(stack), (mode, shape, bpp, (x0, y0, x1, y1), (xb0, yb0, xb1, yb1)))


SPECS = {
    '44b26a': dict(id=1, va=0x44b26a, size=350, gen=gen_44b26a, cleanup=4, fpcw=0x27f, n=(16 + 4 * 3 * len(WORDS) + 4 * 3 * len(FLOATS)) * 2),
    '488e9c': dict(id=2, va=0x488e9c, size=447, gen=gen_488e9c, cleanup=12, n=61 * 10),
    '4c5b3a': dict(id=3, va=0x4c5b3a, size=529, gen=gen_4c5b3a, cleanup=20, n=26 * 16),
}
KEYS = list(SPECS)
NAMES = {'44b26a': 'apply_delta', '488e9c': 'init_record', '4c5b3a': 'copy_keyed'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
