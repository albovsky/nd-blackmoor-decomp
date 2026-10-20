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


# @@GENERATORS@@

SPECS = {
    '4e2e05': dict(id=1, va=0x4e2e05, size=421, gen=gen_4e2e05, cleanup=0, n=28 * 4),
}
KEYS = list(SPECS)
NAMES = {'4e2e05': 'copy_state'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
