"""FL-34 (batch a): the fixtures shared by tests/test_fl34a_differential.py and tests/fl34a_original_oracle.py.

Same shape as tests/fl32a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the table behind the world pointer, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through
profiles (each guard failing in turn, then every arm and scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random
bytes fill everything else. Every global of Fl34aWorld is set (random) in every scenario and read back, so a store to the wrong global or with the wrong width shows.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (OS or host boundaries); nothing inside the function under
test is patched.
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
from fl28b_fixtures import (Original27, stub, CDECL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl34aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl34a.h').read_text()
    body = re.search(r'typedef struct Fl34aWorld \{(.*?)\} Fl34aWorld;', text, re.S).group(1)
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


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None, fault=None)


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
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
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


def random_globals(rng):
    """Every non-pointer global of the world with a random value (some with a high bit and a low bit set, some 0 and 1)."""
    g = {}
    for name, (address, size) in GLOBALS.items():
        g[name] = rng.choice([0, 1, 2, 3, 0xffffffff, 0x80000000, rng.randrange(1 << 32), rng.randrange(1 << 32)]) & ((1 << (8 * size)) - 1)
    return g


def probe_globals(names):
    return [('g:' + n, 0, GLOBALS[n][1]) for n in names]


# ---- the 21 table toggles -------------------------------------------------------------------------------------------------

INDEXES = [0, 1, 5, 0x1f, -1, -3]
NOT_ONE = [0, 2, 0x100, 0x10001, 0x01000001, 0xffffffff, 0x80000001, 0x7fffffff]
TBL_LO, TBL_HI = -8, 0x20          # table elements (dwords of the array at the original address 0x5e60da) that the indices reach
MAX_DELTA = 0x5e6132 - 0x5e60da          # the largest base offset of the 21 rows, in bytes


def gen_toggle(key, rng, n, delta):
    profiles = [('one', i) for i in INDEXES] + [('other', i, v) for i in INDEXES for v in NOT_ONE]
    (kind, idx, *rest), variant = prof(n, profiles)
    count = TBL_HI - TBL_LO + 1 + MAX_DELTA // 4 + 1         # the elements lo..hi, and room for the largest base offset of the highest index
    data = bytearray(count * 4)
    for k in range(count):                                    # random dwords, with some 1s: a store to the wrong element changes the table
        put32(data, 4 * k, rng.choice([0, 1, 1, 2, 0x100, 0xffffffff, rng.randrange(1 << 32)]))
    at = (idx - TBL_LO) * 4 + delta                           # the byte offset of the element the function toggles (the table starts at the original address 0x5e60da + lo*4)
    put32(data, at, 1 if kind == 'one' else rest[0])
    area = Area('tbl', 0x5e60da + TBL_LO * 4, data, image=True)
    s = bytearray(rng.randbytes(0x400))
    put32(s, 0x5c, idx)
    g = random_globals(rng)
    stubs = {0x40236a: stub(0x40236a, THISCALL(0), probe=[('tbl', 0, len(data)), ('self', 0x40, 0x40)])}
    return make(key, [self_area(s), area], stubs, g, [], (), (kind, idx, *rest), pointers={'table_5e60da': ('tbl', -TBL_LO * 4)})


def gen_402962(rng, n):
    return gen_toggle('402962', rng, n, 0x5e60d6 - 0x5e60da)


def gen_402a7e(rng, n):
    return gen_toggle('402a7e', rng, n, 0x5e60e6 - 0x5e60da)


def gen_402ac5(rng, n):
    return gen_toggle('402ac5', rng, n, 0x5e60ea - 0x5e60da)


def gen_402b0c(rng, n):
    return gen_toggle('402b0c', rng, n, 0x5e60ee - 0x5e60da)


def gen_402b53(rng, n):
    return gen_toggle('402b53', rng, n, 0x5e60f2 - 0x5e60da)


def gen_402b9a(rng, n):
    return gen_toggle('402b9a', rng, n, 0x5e60f6 - 0x5e60da)


def gen_402be1(rng, n):
    return gen_toggle('402be1', rng, n, 0x5e60fa - 0x5e60da)


def gen_402c28(rng, n):
    return gen_toggle('402c28', rng, n, 0x5e60fe - 0x5e60da)


def gen_402c6f(rng, n):
    return gen_toggle('402c6f', rng, n, 0x5e6102 - 0x5e60da)


def gen_402cb6(rng, n):
    return gen_toggle('402cb6', rng, n, 0x5e6106 - 0x5e60da)


def gen_402cfd(rng, n):
    return gen_toggle('402cfd', rng, n, 0x5e610a - 0x5e60da)


def gen_402d44(rng, n):
    return gen_toggle('402d44', rng, n, 0x5e610e - 0x5e60da)


def gen_402d8b(rng, n):
    return gen_toggle('402d8b', rng, n, 0x5e6112 - 0x5e60da)


def gen_402dd2(rng, n):
    return gen_toggle('402dd2', rng, n, 0x5e6116 - 0x5e60da)


def gen_402e19(rng, n):
    return gen_toggle('402e19', rng, n, 0x5e611a - 0x5e60da)


def gen_402e60(rng, n):
    return gen_toggle('402e60', rng, n, 0x5e611e - 0x5e60da)


def gen_402ea7(rng, n):
    return gen_toggle('402ea7', rng, n, 0x5e6122 - 0x5e60da)


def gen_402eee(rng, n):
    return gen_toggle('402eee', rng, n, 0x5e6126 - 0x5e60da)


def gen_402f35(rng, n):
    return gen_toggle('402f35', rng, n, 0x5e612a - 0x5e60da)


def gen_402f7c(rng, n):
    return gen_toggle('402f7c', rng, n, 0x5e612e - 0x5e60da)


def gen_402fc3(rng, n):
    return gen_toggle('402fc3', rng, n, 0x5e6132 - 0x5e60da)


# GEN-END

SPECS = {
    '402962': dict(id=1, va=0x402962, size=71, gen=gen_402962, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402a7e': dict(id=2, va=0x402a7e, size=71, gen=gen_402a7e, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402ac5': dict(id=3, va=0x402ac5, size=71, gen=gen_402ac5, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402b0c': dict(id=4, va=0x402b0c, size=71, gen=gen_402b0c, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402b53': dict(id=5, va=0x402b53, size=71, gen=gen_402b53, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402b9a': dict(id=6, va=0x402b9a, size=71, gen=gen_402b9a, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402be1': dict(id=7, va=0x402be1, size=71, gen=gen_402be1, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402c28': dict(id=8, va=0x402c28, size=71, gen=gen_402c28, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402c6f': dict(id=9, va=0x402c6f, size=71, gen=gen_402c6f, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402cb6': dict(id=10, va=0x402cb6, size=71, gen=gen_402cb6, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402cfd': dict(id=11, va=0x402cfd, size=71, gen=gen_402cfd, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402d44': dict(id=12, va=0x402d44, size=71, gen=gen_402d44, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402d8b': dict(id=13, va=0x402d8b, size=71, gen=gen_402d8b, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402dd2': dict(id=14, va=0x402dd2, size=71, gen=gen_402dd2, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402e19': dict(id=15, va=0x402e19, size=71, gen=gen_402e19, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402e60': dict(id=16, va=0x402e60, size=71, gen=gen_402e60, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402ea7': dict(id=17, va=0x402ea7, size=71, gen=gen_402ea7, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402eee': dict(id=18, va=0x402eee, size=71, gen=gen_402eee, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402f35': dict(id=19, va=0x402f35, size=71, gen=gen_402f35, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402f7c': dict(id=20, va=0x402f7c, size=71, gen=gen_402f7c, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402fc3': dict(id=21, va=0x402fc3, size=77, code=71, gen=gen_402fc3, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    # SPECS-END
}
KEYS = list(SPECS)
BASES = {'402962': 0x5e60d6, '402a7e': 0x5e60e6, '402ac5': 0x5e60ea, '402b0c': 0x5e60ee, '402b53': 0x5e60f2, '402b9a': 0x5e60f6, '402be1': 0x5e60fa, '402c28': 0x5e60fe, '402c6f': 0x5e6102, '402cb6': 0x5e6106, '402cfd': 0x5e610a, '402d44': 0x5e610e, '402d8b': 0x5e6112, '402dd2': 0x5e6116, '402e19': 0x5e611a, '402e60': 0x5e611e, '402ea7': 0x5e6122, '402eee': 0x5e6126, '402f35': 0x5e612a, '402f7c': 0x5e612e, '402fc3': 0x5e6132}      # the table base of each row, read from its own disassembly
NAMES = {
         '402962': 'toggle_5e60d6', '402a7e': 'toggle_5e60e6', '402ac5': 'toggle_5e60ea',
         '402b0c': 'toggle_5e60ee', '402b53': 'toggle_5e60f2', '402b9a': 'toggle_5e60f6',
         '402be1': 'toggle_5e60fa', '402c28': 'toggle_5e60fe', '402c6f': 'toggle_5e6102',
         '402cb6': 'toggle_5e6106', '402cfd': 'toggle_5e610a', '402d44': 'toggle_5e610e',
         '402d8b': 'toggle_5e6112', '402dd2': 'toggle_5e6116', '402e19': 'toggle_5e611a',
         '402e60': 'toggle_5e611e', '402ea7': 'toggle_5e6122', '402eee': 'toggle_5e6126',
         '402f35': 'toggle_5e612a', '402f7c': 'toggle_5e612e', '402fc3': 'toggle_5e6132',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
