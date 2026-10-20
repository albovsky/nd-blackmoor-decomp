"""FL-32 (batch b): the fixtures shared by tests/test_fl32b_differential.py and tests/fl32b_original_oracle.py.

Same shape as tests/fl31a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the objects behind the addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through
profiles (each guard failing in turn, then every arm and scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes
fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (OS or host boundaries); nothing inside the function under test
is patched.
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
    """The fields of Fl32bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl32b.h').read_text()
    body = re.search(r'typedef struct Fl32bWorld \{(.*?)\} Fl32bWorld;', text, re.S).group(1)
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
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
TAG_VA = 0x53ec58            # the area that holds the two 4-byte tags at 0x53ec5c and 0x53ec60 (patched into the image)
TAG_SIZE = 0x10


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None, fault=fault)


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
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the function did not return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
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


# ---- helpers ---------------------------------------------------------------------------------------------------------------------


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


# ---- 0x40a613 and 0x40a665 --------------------------------------------------------------------------------------------------------

ATOI_RESULTS = [0, 1, 0x7fff, 0x8000, 0xffff, 0x12345678, 0xffffffff, 0xdeadbeef]
REAL_TAG = b'---\x00'          # the bytes the original has at both tag addresses; later passes use random tags so that a compare against a shifted address shows


def gen_tag(key, rng, n, field, tag_off, g_word):
    profiles = [('eq',)] * 2 + [('ne', pos, r) for pos in range(4) for r in ATOI_RESULTS]
    (kind, *rest), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x400))
    tags = bytearray(rng.randbytes(TAG_SIZE))
    if variant == 0:
        tags[4:8] = REAL_TAG
        tags[8:12] = REAL_TAG
    mine = bytes(tags[tag_off - TAG_VA:tag_off - TAG_VA + 4])
    buf = bytearray(mine + rng.randbytes(0x10))
    if kind == 'ne':
        pos = rest[0]
        buf[pos] = (buf[pos] + 1 + rng.randrange(255)) & 0xff           # a different byte; the bytes before it stay equal, those behind it are random
        for i in range(pos + 1, 4):
            buf[i] = mine[i] if variant % 2 else rng.randrange(256)       # behind the first difference: equal again (odd passes) or random (even passes)
    elif variant % 2 == 0:
        buf[4] = (tags[tag_off - TAG_VA + 4] + 1) & 0xff                  # the byte behind the tag differs: a fifth compared byte would show
    g = {n_: rng.choice([0, 0xffff, rng.randrange(0x10000)]) for n_ in GLOBALS}
    atoi = ATOI_RESULTS[0] if kind == 'eq' else rest[1]
    ret = rng.choice([0, 1, 0x80000000, rng.randrange(1 << 32), 0xffffffff])
    stubs = {0x51d5b2: stub(0x51d5b2, THISCALL(2), writes=[(0, 0, 0, 0, bytes(buf))]),
             0x50cb1b: stub(0x50cb1b, CDECL(1), results=[atoi], derefs=[(0, 0x14)]),
             0x4090ab: stub(0x4090ab, THISCALL(0), results=[ret], probe=[('g:word_5ec2d8', 0, 2), ('g:word_5ec2da', 0, 2), ('self', 0, 0x120)])}
    return make(key, [self_area(s), Area('tags', TAG_VA, tags, image=True)], stubs, g, [], (), (kind, *rest, variant))


def gen_40a613(rng, n):
    return gen_tag('40a613', rng, n, 0xcc, 0x53ec5c, 'word_5ec2d8')


def gen_40a665(rng, n):
    return gen_tag('40a665', rng, n, 0x10c, 0x53ec60, 'word_5ec2da')


# ---- the straight-line field resets -----------------------------------------------------------------------------------------------

# (offset, size, value): the stores of the function in the order of the original
RESETS = {
    '4a9f27': [(0x21, 2, 0xffff), (0x29, 2, 0xffff), (0x1d, 4, 0), (0x45, 1, 0), (0x46, 1, 0), (0x47, 1, 0)],
    '4b71f7': [(0x21, 2, 0xffff), (0x2f, 2, 0xffff), (0x35, 1, 0), (0x36, 1, 0), (0x3b, 1, 0)],
    '4781fa': [(0x1e, 2, 0xffff), (0x1c, 2, 0xffff), (0x157a, 4, 0), (0x157e, 4, 0), (0x1576, 4, 0)],
    '4afd3a': [(0x1e, 2, 0xffff), (0x1c, 2, 0xffff), (0x1515, 4, 0), (0x1519, 4, 0), (0x151d, 4, 0)],
    '4e04f3': [(0xf2a, 4, 0), (0x74f, 4, 0), (0xf2e, 4, 0), (0xf32, 4, 0xffffffff), (0xf36, 4, 0xffffffff)],
    '4a638a': [(0x1e, 2, 0xffff), (0x1c, 2, 0xffff), (0x21, 4, 0), (0x25, 4, 0), (0x86, 4, 0), (0x8a, 1, 0), (0x8b, 1, 0)],
}


def gen_reset(key, rng, n):
    (kind,), variant = prof(n, [('random',)] * 4)
    s = bytearray(rng.randbytes(0x1800))
    if variant % 2:
        s = bytearray(b'\xa5' * 0x1800)               # a pass with a constant background: an extra or wider store is visible at once
    for off, size, value in RESETS[key]:
        if size == 4:
            put32(s, off, rng.choice(NONZERO if value == 0 else [0, 1, 0x80000000, 0xdeadbeef]))
        elif size == 2:
            put16(s, off, rng.choice([0, 1, 0x1234, 0x8000]))
        else:
            s[off] = rng.choice([1, 0x80, 0xff, 2])
    return make(key, [self_area(s)], {}, {}, [], (), (kind, variant))


def gen_4a9f27(rng, n):
    return gen_reset('4a9f27', rng, n)


def gen_4b71f7(rng, n):
    return gen_reset('4b71f7', rng, n)


def gen_4781fa(rng, n):
    return gen_reset('4781fa', rng, n)


def gen_4afd3a(rng, n):
    return gen_reset('4afd3a', rng, n)


def gen_4e04f3(rng, n):
    return gen_reset('4e04f3', rng, n)


def gen_4a638a(rng, n):
    return gen_reset('4a638a', rng, n)


# ---- 0x454565 ---------------------------------------------------------------------------------------------------------------------

PT_VALUES = [0, 1, 5, 0xfffffffb, 0xffffffff, 0x7fffffff, 0x80000000, 0x10000, 0x12345678, 0xfffffff0, 0xdeadbeef, 0x00010001]
POINT_OFFSETS = [0x10, 0x28, 0x44]


def gen_454565(rng, n):
    profiles = [('none', k) for k in range(24)] + [(alias, 0) for alias in ('ab', 'ac', 'bc', 'abc')]
    (alias, _), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x100))
    pts = [(rng.choice(PT_VALUES), rng.choice(PT_VALUES)) for _ in range(3)]
    if alias in ('ab', 'abc'):
        pts[1] = pts[0]
    if alias in ('ac', 'abc'):
        pts[2] = pts[0]
    if alias == 'bc':
        pts[2] = pts[1]
    at = list(POINT_OFFSETS)
    if alias in ('ab', 'abc'):
        at[1] = at[0]
    if alias in ('ac', 'abc'):
        at[2] = at[0]
    if alias == 'bc':
        at[2] = at[1]
    for (x, y), off in zip(pts, at):
        put32(s, off, x)
        put32(s, off + 4, y)
    args = tuple(od.region_va(0) + off for off in at)
    return make('454565', [self_area(s)], {}, {}, list(args), args, (alias, variant))


# GEN-END

SPECS = {
    '40a613': dict(id=1, va=0x40a613, size=82, gen=gen_40a613, cleanup=0, ret=True, n=34 * 3),
    '40a665': dict(id=2, va=0x40a665, size=82, gen=gen_40a665, cleanup=0, ret=True, n=34 * 3),
    '4a9f27': dict(id=3, va=0x4a9f27, size=60, gen=gen_4a9f27, cleanup=0, retself=True, n=8),
    '4b71f7': dict(id=4, va=0x4b71f7, size=50, gen=gen_4b71f7, cleanup=0, retself=True, n=8),
    '4781fa': dict(id=5, va=0x4781fa, size=68, gen=gen_4781fa, cleanup=0, retself=True, n=8),
    '4afd3a': dict(id=6, va=0x4afd3a, size=68, gen=gen_4afd3a, cleanup=0, retself=True, n=8),
    '4e04f3': dict(id=7, va=0x4e04f3, size=76, gen=gen_4e04f3, cleanup=0, retself=True, n=8),
    '454565': dict(id=8, va=0x454565, size=75, gen=gen_454565, cleanup=12, ret=True, ptr_args=True, n=28 * 3),
    '4a638a': dict(id=9, va=0x4a638a, size=82, gen=gen_4a638a, cleanup=0, retself=True, n=8),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'40a613': 'read_tag_word', '40a665': 'read_tag_word', '4a9f27': 'reset_fields', '4b71f7': 'reset_fields', '4781fa': 'reset_fields', '4afd3a': 'reset_fields',
         '4e04f3': 'reset_fields', '454565': 'cross_product', '4a638a': 'reset_fields',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
