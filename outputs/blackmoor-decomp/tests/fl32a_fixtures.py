"""FL-32 (batch a): the fixtures shared by tests/test_fl32a_differential.py and tests/fl32a_original_oracle.py.

Same shape as tests/fl31a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the table behind the world pointer, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through
profiles (each guard failing in turn, then every arm and scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random
bytes fill everything else. Every global of Fl32aWorld is set (random) in every scenario and read back, so a store to the wrong global or with the wrong width shows.

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
    """The fields of Fl32aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl32a.h').read_text()
    body = re.search(r'typedef struct Fl32aWorld \{(.*?)\} Fl32aWorld;', text, re.S).group(1)
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
TEXT_WORDS = ['word_5ec33e', 'word_5ec340', 'word_5e5688']
FLAGS = ['dword_5e350e', 'dword_5e3512', 'dword_5e3516']


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


# ---- 0x40425d, 0x404298, 0x4042d3 -------------------------------------------------------------------------------------------------

TEXT_RESULTS = [0, 1, 0x7fff, 0x8000, 0xffff, 0x12345, 0xffff8000, 0xffffffff, 0x80000000, 0xdeadbeef, 0x7fff0001]


def text_bytes(rng, variant):
    """The 0x13 bytes that the (host-modelled) text callee leaves in the buffer: 1 to 18 characters, the terminator and random bytes behind it."""
    length = [1, 5, 18, 3][variant % 4]
    data = bytearray(rng.randbytes(0x13))
    for i in range(length):
        data[i] = ord('0') + rng.randrange(10)
    data[length] = 0
    return bytes(data)


def gen_text(key, rng, n, off, word):
    (r,), variant = prof(n, [(v,) for v in TEXT_RESULTS])
    s = bytearray(rng.randbytes(0x400))
    g = random_globals(rng)
    text = text_bytes(rng, variant)
    words = probe_globals(TEXT_WORDS)
    stubs = {0x51d5b2: stub(0x51d5b2, THISCALL(2), results=[len(text.split(b'\0')[0])], writes=[(0, 0, 0, 0, text)], probe=[('self', 0, 0x20)] + words),
             0x50cb1b: stub(0x50cb1b, CDECL(1), results=[r], derefs=[(0, 0x13)], probe=words),
             0x4033db: stub(0x4033db, THISCALL(0), probe=words + [('self', 0, 0x20)])}
    return make(key, [self_area(s)], stubs, g, [], (), (r, variant))


def gen_40425d(rng, n):
    return gen_text('40425d', rng, n, 0xcc, 'word_5ec33e')


def gen_404298(rng, n):
    return gen_text('404298', rng, n, 0x10c, 'word_5ec340')


def gen_4042d3(rng, n):
    return gen_text('4042d3', rng, n, 0x1cc, 'word_5e5688')


# ---- 0x4029a9, 0x4029f0, 0x402a37 -------------------------------------------------------------------------------------------------

INDEXES = [0, 1, 5, 0x1f, -1, -3]
NOT_ONE = [0, 2, 0x100, 0x10001, 0x01000001, 0xffffffff, 0x80000001, 0x7fffffff]
TBL_LO, TBL_HI = -4, 0x20


def gen_toggle(key, rng, n, delta):
    profiles = [('one', i) for i in INDEXES] + [('other', i, v) for i in INDEXES for v in NOT_ONE]
    (kind, idx, *rest), variant = prof(n, profiles)
    count = TBL_HI - TBL_LO + 1 + 3                          # the elements lo..hi, and room for the +4 / +8 offsets of the last index
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


def gen_4029a9(rng, n):
    return gen_toggle('4029a9', rng, n, 0)


def gen_4029f0(rng, n):
    return gen_toggle('4029f0', rng, n, 4)


def gen_402a37(rng, n):
    return gen_toggle('402a37', rng, n, 8)


# ---- 0x4067eb, 0x406832, 0x406879 -------------------------------------------------------------------------------------------------

FLAG_OTHERS = [0, 2, 0x100, 0x10001, 0xffffffff]


def gen_flag(key, rng, n, flag, k):
    words = [k, 0, 1, 2, 3, 0xffff, 0x8000, 0x8000 | k, 0x100 | k, 0xfffe]
    profiles = [('on', w) for w in words] + [('off', f, w) for f in FLAG_OTHERS for w in words]
    (kind, *rest), variant = prof(n, profiles)
    g = random_globals(rng)
    if kind == 'on':
        g[flag], g['word_5e335e'] = 1, rest[0]
    else:
        g[flag], g['word_5e335e'] = rest
    s = bytearray(rng.randbytes(0x100))
    probe = probe_globals(FLAGS + ['word_5e335e'])
    stubs = {0x404be1: stub(0x404be1, THISCALL(0), probe=probe + [('self', 0, 0x20)])}
    return make(key, [self_area(s)], stubs, g, [], (), (kind, *rest))


def gen_4067eb(rng, n):
    return gen_flag('4067eb', rng, n, 'dword_5e350e', 1)


def gen_406832(rng, n):
    return gen_flag('406832', rng, n, 'dword_5e3512', 2)


def gen_406879(rng, n):
    return gen_flag('406879', rng, n, 'dword_5e3516', 3)


# GEN-END

SPECS = {
    '40425d': dict(id=1, va=0x40425d, size=59, gen=gen_40425d, cleanup=0, n=len(TEXT_RESULTS) * 4),
    '404298': dict(id=2, va=0x404298, size=59, gen=gen_404298, cleanup=0, n=len(TEXT_RESULTS) * 4),
    '4042d3': dict(id=3, va=0x4042d3, size=59, gen=gen_4042d3, cleanup=0, n=len(TEXT_RESULTS) * 4),
    '4029a9': dict(id=4, va=0x4029a9, size=71, gen=gen_4029a9, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '4029f0': dict(id=5, va=0x4029f0, size=71, gen=gen_4029f0, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '402a37': dict(id=6, va=0x402a37, size=71, gen=gen_402a37, cleanup=0, n=(len(INDEXES) * (1 + len(NOT_ONE))) * 2),
    '4067eb': dict(id=7, va=0x4067eb, size=71, gen=gen_4067eb, cleanup=0, n=(10 + len(FLAG_OTHERS) * 10) * 2),
    '406832': dict(id=8, va=0x406832, size=71, gen=gen_406832, cleanup=0, n=(10 + len(FLAG_OTHERS) * 10) * 2),
    '406879': dict(id=9, va=0x406879, size=71, gen=gen_406879, cleanup=0, n=(10 + len(FLAG_OTHERS) * 10) * 2),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'40425d': 'read_text_cc', '404298': 'read_text_10c', '4042d3': 'read_text_1cc',
         '4029a9': 'toggle_5e60da', '4029f0': 'toggle_5e60de', '402a37': 'toggle_5e60e2',
         '4067eb': 'toggle_5e350e', '406832': 'toggle_5e3512', '406879': 'toggle_5e3516',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
