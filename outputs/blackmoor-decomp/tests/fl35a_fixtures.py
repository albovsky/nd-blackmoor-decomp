"""FL-35 (batch a): the fixtures shared by tests/test_fl35a_differential.py and tests/fl35a_original_oracle.py.

Same shape as tests/fl32b_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through profiles; the optional parts vary from one
pass of the cycle to the next; random bytes fill everything else.

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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl35aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl35a.h').read_text()
    body = re.search(r'typedef struct Fl35aWorld \{(.*?)\} Fl35aWorld;', text, re.S).group(1)
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


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


ATOI_RESULTS = [0, 1, 0x7fff, 0x8000, 0xffff, 0x12345678, 0xffffffff, 0xdeadbeef]
RET_VALUES = [0, 1, 0x80000000, 0xffffffff]

# ---- the 28 tag readers ---------------------------------------------------------------------------------------------------------

TAG_VA = 0x53ec58            # the area that holds the 4-byte tags (patched into the image)
TAG_SIZE = 0x7c
REAL_TAG = b'---\x00'          # the bytes the original has at the two tag addresses of FL-32; later passes use random tags so that a compare against a shifted address shows
# key: (string field offset, tag address, word address), each read from the disassembly of the row
ROWS = {
    '40a5c1': (0x8c, 0x53ec58, 0x5ec2d6),
    '40a6b7': (0x14c, 0x53ec64, 0x5ec2dc),
    '40a709': (0x18c, 0x53ec68, 0x5ec2de),
    '40a75b': (0x1cc, 0x53ec6c, 0x5ec2e0),
    '40a7ad': (0x20c, 0x53ec70, 0x5ec2e2),
    '40a7ff': (0x24c, 0x53ec74, 0x5ec2e4),
    '40a851': (0x28c, 0x53ec78, 0x5ec2e6),
    '40a8a3': (0x2cc, 0x53ec7c, 0x5ec2e8),
    '40a8f5': (0x30c, 0x53ec80, 0x5ec2ea),
    '40a947': (0x34c, 0x53ec84, 0x5ec2ec),
    '40a999': (0x38c, 0x53ec88, 0x5ec2ee),
    '40a9eb': (0x3cc, 0x53ec8c, 0x5ec2f0),
    '40aa3d': (0x40c, 0x53ec90, 0x5ec2f2),
    '40aa8f': (0x44c, 0x53ec94, 0x5ec2f4),
    '40aae1': (0x48c, 0x53ec98, 0x5ec2f6),
    '40ab33': (0x4cc, 0x53ec9c, 0x5ec2f8),
    '40ab85': (0x50c, 0x53eca0, 0x5ec2fa),
    '40abd7': (0x54c, 0x53eca4, 0x5ec2fc),
    '40ac29': (0x58c, 0x53eca8, 0x5ec2fe),
    '40ac7b': (0x5cc, 0x53ecac, 0x5ec300),
    '40accd': (0x60c, 0x53ecb0, 0x5ec302),
    '40ad1f': (0x64c, 0x53ecb4, 0x5ec304),
    '40ad71': (0x68c, 0x53ecb8, 0x5ec306),
    '40adc3': (0x6cc, 0x53ecbc, 0x5ec308),
    '40ae15': (0x70c, 0x53ecc0, 0x5ec30a),
    '40ae67': (0x74c, 0x53ecc4, 0x5ec30c),
    '40aeb9': (0x78c, 0x53ecc8, 0x5ec30e),
    '40af0b': (0x7cc, 0x53eccc, 0x5ec310),
}


def gen_tag(key, rng, n):
    field, tag, word = ROWS[key]
    profiles = [('eq',)] * 2 + [('ne', pos, r) for pos in range(4) for r in ATOI_RESULTS]
    (kind, *rest), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x1000))
    tags = bytearray(rng.randbytes(TAG_SIZE))
    if variant == 0:
        for off in range(0, TAG_SIZE, 4):
            tags[off:off + 4] = REAL_TAG
    mine = bytes(tags[tag - TAG_VA:tag - TAG_VA + 4])
    buf = bytearray(mine + rng.randbytes(0x10))
    if kind == 'ne':
        pos = rest[0]
        buf[pos] = (buf[pos] + 1 + rng.randrange(255)) & 0xff           # a different byte; the bytes before it stay equal, those behind it are random
        for i in range(pos + 1, 4):
            buf[i] = mine[i] if variant % 2 else rng.randrange(256)      # behind the first difference: equal again (odd passes) or random (even passes)
    elif variant % 2 == 0:
        buf[4] = (tags[tag - TAG_VA + 4] + 1) & 0xff                    # the byte behind the tag differs: a fifth compared byte would show
    g = {n_: rng.choice([0, 0xffff, rng.randrange(0x10000)]) for n_ in GLOBALS}
    atoi = ATOI_RESULTS[0] if kind == 'eq' else rest[1]
    ret = rng.choice([0, 1, 0x80000000, rng.randrange(1 << 32), 0xffffffff])
    stubs = {0x51d5b2: stub(0x51d5b2, THISCALL(2), writes=[(0, 0, 0, 0, bytes(buf))]),
             0x50cb1b: stub(0x50cb1b, CDECL(1), results=[atoi], derefs=[(0, 0x14)]),
             0x4090ab: stub(0x4090ab, THISCALL(0), results=[ret], probe=[('g:word_%x' % word, 0, 2), ('self', 0, 0x120)])}
    return make(key, [self_area(s), Area('tags', TAG_VA, tags, image=True)], stubs, g, [], (), (kind, *rest, variant))


def _gen(key):
    return lambda rng, n: gen_tag(key, rng, n)


SPECS = {k: dict(id=i + 1, va=int(k, 16), size=82, gen=_gen(k), cleanup=0, ret=True, n=34 * 3) for i, k in enumerate(ROWS)}
KEYS = list(SPECS)
NAMES = {k: 'read_tag_word' for k in KEYS}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
