"""FL-30 (batch a): the fixtures shared by tests/test_fl30a_differential.py and tests/fl30a_original_oracle.py.

Same shape as tests/fl28b_fixtures.py (whose generic harness pieces are imported: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object
`this`, the objects behind the addresses it keeps, the vtables, the scripted callees (recording stubs at the call boundary, entered by address) and the
globals. The scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the vtable entries are recording stubs (OS or host boundaries);
nothing inside the function under test is patched. The x87 control word is 0x27f (the Windows process default) for the functions with x87 code.
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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, DBG_VALUES)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl30aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl30a.h').read_text()
    body = re.search(r'typedef struct Fl30aWorld \{(.*?)\} Fl30aWorld;', text, re.S).group(1)
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
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    if SPECS[sc.key].get('ret16'):
        h.update(struct.pack('<H', orig.eax & 0xffff))
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


# ---- helpers ---------------------------------------------------------------------------------------------------------------------


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def dbg_value(variant):
    return DBG_VALUES[1:][variant % 4]


# ---- 0x4f61e7 ---------------------------------------------------------------------------------------------------------------------


def gen_4f61e7(rng, n):
    (kind, arg), variant = prof(n, [(kind, arg) for kind in ('c0', 'no162', 'no28f', 'v0dbg0', 'v0dbg', 'vok') for arg in (0, 1, 2, 0xffffffff)])
    base, obj_va, vt_va = od.region_va(1), od.region_va(2), od.region_va(3)
    k = arg if arg < 3 else 0
    s = bytearray(rng.randbytes(0x600))
    put32(s, 0x3ce, base if arg < 3 else base + 0x5bb)
    recs = bytearray(rng.randbytes(0x5bb * 3 + 0x20))
    r = 0x5bb * k
    nz = NONZERO[(variant + k) % len(NONZERO)]
    put32(recs, r + 0x162, 0 if kind == 'no162' else nz)
    put32(recs, r + 0x28f, 0 if (kind == 'no28f' or (kind == 'no162' and variant % 2)) else obj_va)
    obj = bytearray(rng.randbytes(0x100))
    put32(obj, 0, vt_va)
    vt = bytearray(rng.randbytes(0x100))
    put32(vt, 0x48, VT_A)
    callee = [0] if kind == 'c0' else [NONZERO[(variant + 3) % len(NONZERO)]]
    vres = [0] if kind.startswith('v0') else [NONZERO[(variant + 5) % len(NONZERO)]]
    stubs = {0x4f709c: stub(0x4f709c, THISCALL(0), results=callee), VT_A: stub(VT_A, (1, True, 4), results=vres, probe=[('self', 0x3be, 0x18), ('recs', r + 0x280, 0x10)]),
             0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x44a2b7: stub(0x44a2b7, CDECL(1))}
    g = {'word_63a4cd': 0 if kind != 'v0dbg' else dbg_value(variant)}
    if kind not in ('v0dbg0', 'v0dbg'):
        g['word_63a4cd'] = DBG_VALUES[variant % 5]
    return make('4f61e7', [self_area(s), Area('recs', base, recs, image=False), Area('obj', obj_va, obj, image=False), Area('vtbl', vt_va, vt, image=False)], stubs, g, [arg],
                (arg,), (kind, arg))


# ---- 0x484762 ---------------------------------------------------------------------------------------------------------------------

AXIS = [-3, -2, -1, 0, 1]
EXH = len(AXIS) ** 4


def gen_484762(rng, n):
    """n < EXH: every (A.x0, A.x1, B.x0, B.x1) over AXIS with a valid y rectangle; EXH <= n < 2 * EXH: the same on the y axis; then random coordinates (some at the signed extremes)."""
    if n < EXH:
        xs, ys, profile = [AXIS[(n // 5 ** k) % 5] for k in range(4)], [0, 1, 0, 1], ('x', n)
    elif n < 2 * EXH:
        ys, xs, profile = [AXIS[((n - EXH) // 5 ** k) % 5] for k in range(4)], [0, 1, 0, 1], ('y', n - EXH)
    else:
        xs = [rng.randrange(-3, 4) for _ in range(4)]
        ys = [rng.randrange(-3, 4) for _ in range(4)]
        extremes = [-0x80000000, 0x7fffffff, -1, 0, 1, -2, 0x10000, -0x10000, 0x10001, 0xffff]
        if n % 2 == 0:
            xs = [rng.choice(extremes) for _ in range(4)]
        if n % 3 != 1:
            ys = [rng.choice(extremes) for _ in range(4)]
        profile = ('r', n)
    a, b = rng.randrange(4), rng.randrange(4)
    if n % 7 == 0:
        b = a
    s = bytearray(rng.randbytes(0x2000))
    for index, (x0, x1), (y0, y1) in ((a, (xs[0], xs[1]), (ys[0], ys[1])), (b, (xs[2], xs[3]), (ys[2], ys[3]))):
        if index == b and b == a and index is not a:
            continue
        base = 0x28 + index * 0x85 + 2
        for off, v in ((0, x0), (4, y0), (8, x1), (0xc, y1)):
            put32(s, base + off, v)
    if a == b:       # one record is both rectangles: A == B (the first rectangle)
        base = 0x28 + a * 0x85 + 2
        for off, v in ((0, xs[0]), (4, ys[0]), (8, xs[1]), (0xc, ys[1])):
            put32(s, base + off, v)
    stack = [a, b]
    return make('484762', [self_area(s)], {}, {}, stack, tuple(stack), profile)


SPECS = {
    '4f61e7': dict(id=1, va=0x4f61e7, size=333, gen=gen_4f61e7, cleanup=4, ret=True, n=24 * 8),
    '484762': dict(id=2, va=0x484762, size=467, gen=gen_484762, cleanup=8, ret=True, n=2 * 625 + 600),
}
KEYS = list(SPECS)
NAMES = {'4f61e7': 'start_record', '484762': 'intersect_rects'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
