"""FL-35 (batch b): the fixtures shared by tests/test_fl35b_differential.py and tests/fl35b_original_oracle.py.

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
    """The fields of Fl35bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl35b.h').read_text()
    body = re.search(r'typedef struct Fl35bWorld \{(.*?)\} Fl35bWorld;', text, re.S).group(1)
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

# ---- the toggle and the 35 text readers -----------------------------------------------------------------------------------------

# key: (string field offset, word address) of each reader, read from the disassembly of the row
ROWS = {
    '40812e': (0x8c, 0x5ec28e),
    '408169': (0xcc, 0x5ec290),
    '4081a4': (0x10c, 0x5ec292),
    '4081df': (0x14c, 0x5ec294),
    '40821a': (0x18c, 0x5ec296),
    '408255': (0x1cc, 0x5ec298),
    '408290': (0x20c, 0x5ec29a),
    '4082cb': (0x24c, 0x5ec29c),
    '408306': (0x28c, 0x5ec29e),
    '408341': (0x2cc, 0x5ec2a0),
    '40837c': (0x30c, 0x5ec2a2),
    '4083b7': (0x34c, 0x5ec2a4),
    '4083f2': (0x38c, 0x5ec2a6),
    '40842d': (0x3cc, 0x5ec2a8),
    '408468': (0x40c, 0x5ec2aa),
    '4084a3': (0x44c, 0x5ec2ac),
    '4084de': (0x48c, 0x5ec2ae),
    '408519': (0x4cc, 0x5ec2b0),
    '408554': (0x50c, 0x5ec2b2),
    '40858f': (0x54c, 0x5ec2b4),
    '4085ca': (0x58c, 0x5ec2b6),
    '408605': (0x5cc, 0x5ec2b8),
    '408640': (0x60c, 0x5ec2ba),
    '40867b': (0x64c, 0x5ec2bc),
    '4086b6': (0x68c, 0x5ec2be),
    '4086f1': (0x6cc, 0x5ec2c0),
    '40872c': (0x70c, 0x5ec2c2),
    '408767': (0x74c, 0x5ec2c4),
    '4087a2': (0x78c, 0x5ec2c6),
    '4087dd': (0x7cc, 0x5ec2c8),
    '408818': (0x80c, 0x5ec2ca),
    '408853': (0x84c, 0x5ec2cc),
    '40888e': (0x88c, 0x5ec2ce),
    '4088c9': (0x8cc, 0x5ec2d0),
    '408904': (0x90c, 0x5ec2d2),
}
TOGGLE_VALUES = [0, 1, 0x8000, 0xffff, 0x100, 0xff, 2, 0x7fff]


def gen_reader(key, rng, n):
    field, word = ROWS[key]
    profiles = [(r,) for r in ATOI_RESULTS]
    (atoi,), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x1000))
    buf = bytearray(rng.randbytes(0x14))
    if variant % 2:
        buf[:4] = b'\x00\x00\x00\x00'
    g = {n_: rng.choice([0, 0xffff, rng.randrange(0x10000)]) for n_ in GLOBALS}
    ret = rng.choice(RET_VALUES + [rng.randrange(1 << 32)])
    stubs = {0x51d5b2: stub(0x51d5b2, THISCALL(2), writes=[(0, 0, 0, 0, bytes(buf))]),
             0x50cb1b: stub(0x50cb1b, CDECL(1), results=[atoi], derefs=[(0, 0x14)]),
             0x407ca7: stub(0x407ca7, THISCALL(0), results=[ret], probe=[('g:word_%x' % word, 0, 2), ('self', 0, 0x120)])}
    return make(key, [self_area(s)], stubs, g, [], (), (atoi, variant))


def gen_4080fc(rng, n):
    (value,), variant = prof(n, [(v,) for v in TOGGLE_VALUES])
    s = bytearray(rng.randbytes(0x1000))
    g = {n_: rng.choice([0, 0xffff, rng.randrange(0x10000)]) for n_ in GLOBALS}
    g['word_5ec28c'] = value
    ret = rng.choice(RET_VALUES + [rng.randrange(1 << 32)])
    stubs = {0x407ca7: stub(0x407ca7, THISCALL(0), results=[ret], probe=[('g:word_5ec28c', 0, 2), ('self', 0, 0x120)])}
    return make('4080fc', [self_area(s)], stubs, g, [], (), (value, variant))


def _gen(key):
    return lambda rng, n: gen_reader(key, rng, n)


SPECS = {'4080fc': dict(id=1, va=0x4080fc, size=50, gen=gen_4080fc, cleanup=0, ret=True, n=8 * 3)}
for _i, _k in enumerate(ROWS):
    SPECS[_k] = dict(id=_i + 2, va=int(_k, 16), size=59, gen=_gen(_k), cleanup=0, ret=True, n=8 * 4)
KEYS = list(SPECS)
NAMES = {k: 'read_text_word' for k in KEYS}
NAMES['4080fc'] = 'toggle_5ec28c'


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
