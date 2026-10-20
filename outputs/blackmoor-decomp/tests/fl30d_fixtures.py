"""FL-30 (batch d): the fixtures shared by tests/test_fl30d_differential.py and tests/fl30d_original_oracle.py.

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
    """The fields of Fl30dWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl30d.h').read_text()
    body = re.search(r'typedef struct Fl30dWorld \{(.*?)\} Fl30dWorld;', text, re.S).group(1)
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


# ---- 0x4e2e05 ---------------------------------------------------------------------------------------------------------------------

BLK_VA, BLK_SIZE = 0x5a1e54, 0x2540
COUNTS = [0, 1, 2, 3, 5, 0x32, 0x33]
LEN1 = [0, 1, 3, 4, 0x20, 0x21, 0x22, 0x30]


def zbytes(rng, buf, off, length):
    """A NUL-terminated string of `length` non-zero bytes at buf[off:], random bytes after the NUL."""
    for i in range(length):
        buf[off + i] = rng.randrange(1, 256)
    buf[off + length] = 0


def gen_4e2e05(rng, n):
    (count, d1, d2), variant = prof(n, [(c, a, b) for c in COUNTS for a in (0, 1) for b in (0, 1)])
    s = bytearray(rng.randbytes(0x5400))
    put16(s, 0x1471, count)
    for off in (0x13df, 0x13e1, 0x1404, 0x1406, 0x1408):       # the fields first: the strings (NUL included) must end before 0x13df / 0x1404
        put16(s, off, rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(0x10000)]))
    zbytes(rng, s, 0x139d, LEN1[(variant + count) % len(LEN1)])
    zbytes(rng, s, 0x13be, rng.choice([0, 1, 5, 0x1f, 0x20]))
    zbytes(rng, s, 0x13e3, rng.choice([0, 1, 2, 0x1c, 0x20]))
    g1 = s[0x139d] if d1 == 0 else (s[0x139d] ^ rng.randrange(1, 256))
    g2 = s[0x13e3] if d2 == 0 else (s[0x13e3] ^ rng.randrange(1, 256))
    blk = Area('blk', BLK_VA, bytearray(rng.randbytes(BLK_SIZE)), image=True)
    stubs = {0x4e3ade: stub(0x4e3ade, THISCALL(0), probe=[('blk', 0, 0x600), ('blk', 0x810, 0x50)])}
    return make('4e2e05', [self_area(s), blk], stubs, {'byte_63a9e4': g1 & 0xff, 'byte_63a9e8': g2 & 0xff}, [], (), (count, d1, d2), {'block_5a1e54': ('blk', 0)})


# ---- 0x4c2a8d ---------------------------------------------------------------------------------------------------------------------

REC_VA, PIX2_VA, STR_VA = od.region_va(1), od.region_va(2), od.region_va(3)
NAME_LENS = [0, 1, 5, 0x17, 0x18, 0x19, 0x1a, 0x30]
DIMS = [(1, 1), (3, 2), (0x10, 5), (0x7fff, 2), (-1, 4), (4, -2), (-3, -5), (0, 7), (0x1234, 0)]


def gen_4c2a8d(rng, n):
    (kind, *rest), variant = prof(n, [('a1fail',), ('a2fail',)] + [('ok', ln, d) for ln in NAME_LENS for d in range(len(DIMS))])
    s = bytearray(rng.randbytes(0x40))
    rec = bytearray(rng.randbytes(0x100))
    pix = bytearray(rng.randbytes(0x20))
    name = bytearray(rng.randbytes(0x80))
    ln = rest[0] if kind == 'ok' else rng.choice(NAME_LENS)
    zbytes(rng, name, 0, ln)
    w, h = DIMS[rest[1] if kind == 'ok' else variant % len(DIMS)]
    bpp = [2, 1, 3, 0, -1, 4][(variant + (rest[1] if kind == 'ok' else 0)) % 6]
    g = {'word_639895': bpp, 'word_639893': rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(0x10000)])}
    results = {'a1fail': [0], 'a2fail': [REC_VA, 0]}.get(kind, [REC_VA, PIX2_VA])
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=results, probe=[('rec', 0, 0x59), ('name', 0, 0x30)]), 0x42639d: stub(0x42639d, THISCALL(2)),
             0x4c97b4: stub(0x4c97b4, THISCALL(0))}
    tag = rng.randrange(1 << 32)
    stack = [word_arg(rng, w), word_arg(rng, h), tag, STR_VA]
    return make('4c2a8d', [self_area(s), Area('rec', REC_VA, rec, image=False), Area('pix', PIX2_VA, pix, image=False), Area('name', STR_VA, name, image=False)],
                stubs, g, stack, tuple(stack), (kind, *rest, w, h, bpp))


# ---- 0x48d3cb ---------------------------------------------------------------------------------------------------------------------

PREC_VA = od.region_va(1)
BOX1 = (0x2f9, 0x301, 0x2f5, 0x2fd)       # the bounds of the first box: e(0x207) >= , e(0x20f) <= , e(0x203) >= , e(0x20b) <=
BOX2 = (0x30b, 0x313, 0x307, 0x30f)
ENTRY = (0x207, 0x20f, 0x203, 0x20b)
SELS = [0x2766, 0x2765, 0x2764, 0x2767, 0, 0xffff, 0x12765, 0xd89a]      # the last is sign-extended -0x2766; 0x12765 is 0x2765 as a word


def box_values(rng, p, bounds, fail_at, k):
    """Writes the bound dwords of one box and the entry dwords of entry k so that the test `fail_at` (0..3, None = none) is the first to fail."""
    for i, (bo, eo) in enumerate(zip(bounds, ENTRY)):
        b = rng.choice([0, 5, -7, 0x40000000, -0x40000000, rng.randrange(-1000, 1000)])
        pos = eo + 16 * k
        if i == 0 or i == 2:       # entry >= bound passes
            e = b + rng.choice([0, 0, 1, 100]) if (fail_at is None or i < fail_at) else b - rng.choice([1, 1, 100])
            if fail_at is not None and i > fail_at:
                e = rng.randrange(-1000, 1000)
        else:                      # entry <= bound passes
            e = b - rng.choice([0, 0, 1, 100]) if (fail_at is None or i < fail_at) else b + rng.choice([1, 1, 100])
            if fail_at is not None and i > fail_at:
                e = rng.randrange(-1000, 1000)
        put32(p, bo, b)
        put32(p, pos, e)


def gen_48d3cb(rng, n):
    paths = [('b1pass',)] + [('b1fail', i, j) for i in range(4) for j in range(5)]      # j = 4: the second box passes, else the test j fails
    (sel, k, path, zero26), variant = prof(n, [(s, k, pth, z) for s in SELS[:2] for k in (0, 3, -1) for pth in paths for z in (0, 1)] + [(s, 0, ('b1pass',), 0) for s in SELS[2:]])
    idx = [0, 1, -1, 2, -2][n % 5]
    s = bytearray(rng.randbytes(0x100))
    put16(s, 0x1e, idx)
    s[0x26] = 0 if zero26 else rng.randrange(1, 256)
    # table of records of stride 0x8d for the indices -2..3 (patched into the image); the dword at +0 is the original address of the entry object
    area = Area('tbl', 0x5bb5e5 - 2 * 0x8d, bytearray(rng.randbytes(6 * 0x8d)), image=True)
    for i in range(-2, 4):
        put32(area.data, (i + 2) * 0x8d, PREC_VA if i == idx else rng.randrange(1 << 32))
    p = bytearray(rng.randbytes(0x500))
    put16(p, 0x2f3, rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, 7]))
    put16(p, 0x305, rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, 9]))
    kk = k
    if path[0] == 'b1pass':
        box_values(rng, p, BOX1, None, kk)         # box 2 keeps random bounds: it is not looked at
    else:
        box_values(rng, p, BOX1, path[1], kk)
    if path[0] == 'b1fail':
        # the entry values were chosen for box 1; box 2 reads the same entry fields, so its bounds are chosen against them
        e = [struct.unpack_from('<i', p, eo + 16 * kk)[0] for eo in ENTRY]
        fail = None if path[2] == 4 else path[2]
        for i, bo in enumerate(BOX2):
            if i in (0, 2):        # entry >= bound passes
                b = e[i] - rng.choice([0, 1, 100]) if (fail is None or i < fail) else e[i] + rng.choice([1, 1, 100])
            else:
                b = e[i] + rng.choice([0, 1, 100]) if (fail is None or i < fail) else e[i] - rng.choice([1, 1, 100])
            if fail is not None and i > fail:
                b = rng.randrange(-1000, 1000)
            put32(p, bo, b)
    g = {'dword_5b44f0': rng.randrange(1 << 32), 'dword_5b44f4': rng.randrange(1 << 32), 'dword_5d0377': rng.randrange(1 << 32), 'dword_5d162d': rng.randrange(1 << 32),
         'dword_5d1631': rng.randrange(1 << 32), 'dword_5d1639': rng.randrange(1 << 32), 'dword_5c39e5': rng.randrange(1 << 32)}
    a0, a1 = word_arg(rng, sel), word_arg(rng, k)
    return make('48d3cb', [self_area(s), area, Area('p', PREC_VA, p, image=False)], {}, g, [a0, a1], (a0, a1), (sel, k, path, zero26, idx), {'table_5bb5e5': ('tbl', 2 * 0x8d)})


# @@GENERATORS@@

SPECS = {
    '4e2e05': dict(id=1, va=0x4e2e05, size=421, gen=gen_4e2e05, cleanup=0, n=28 * 4),
    '48d3cb': dict(id=3, va=0x48d3cb, size=553, gen=gen_48d3cb, cleanup=8, n=2 * 3 * 21 * 2 + 6),
    '4c2a8d': dict(id=2, va=0x4c2a8d, size=429, gen=gen_4c2a8d, cleanup=16, ret=True, n=74 * 2),
}
KEYS = list(SPECS)
NAMES = {'4e2e05': 'copy_state', '4c2a8d': 'make_record', '48d3cb': 'select_entry'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
