"""FL-34 (batch b): the fixtures shared by tests/test_fl34b_differential.py and tests/fl34b_original_oracle.py.

Same shape as tests/fl32a_fixtures.py (the three flag toggles of FL-32 batch a; the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner
with the code and edge hooks, the recording stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one
of the ten flag toggles of ROWS: the object `this`, the scripted callee 0x404be1 (a recording stub entered by address) and the globals. The scenarios cycle through
profiles (the flag equal to 1 with every word, the flag not 1 with every word); random bytes fill everything else. Every global of Fl34bWorld is set (random) in
every scenario and read back, so a store to the wrong flag or with the wrong width shows.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callee is a recording stub (a host boundary); nothing inside the function under test is
patched.
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
from fl28b_fixtures import (Original27, stub, THISCALL, Area, prof, normalize, conditional_edges, LOCAL, FMT)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl34bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl34b.h').read_text()
    body = re.search(r'typedef struct Fl34bWorld \{(.*?)\} Fl34bWorld;', text, re.S).group(1)
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

# (key = va without 0x, va, span, flag address, k): the constants of each row, read from its own disassembly (tasks/fl34b-handoff.md). k is the word constant of
# `movsx eax, word ptr [0x5e335e]; cmp eax, k; jne` (0x4067a5: `test eax, eax`, k = 0).
ROWS = [('4067a5', 0x4067a5, 70, 0x5e350a, 0x0), ('4068c0', 0x4068c0, 71, 0x5e351a, 0x4), ('406907', 0x406907, 71, 0x5e351e, 0x5), ('40694e', 0x40694e, 71, 0x5e3522, 0x6),
        ('406995', 0x406995, 71, 0x5e3526, 0x7), ('4069dc', 0x4069dc, 71, 0x5e352a, 0x8), ('406a23', 0x406a23, 71, 0x5e352e, 0x9), ('406a6a', 0x406a6a, 71, 0x5e3532, 0xa),
        ('406ab1', 0x406ab1, 71, 0x5e3536, 0xb), ('406af8', 0x406af8, 71, 0x5e353a, 0xc)]
FLAGS = ['dword_%x' % flag for _, _, _, flag, _ in ROWS]


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None, fault=None)


def run_original(sc):
    """Runs the original bytes on the scenario. Returns (Result, normalised calls, digest of calls and of the memory read back)."""
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


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests); none: every jump of every row is taken both ways
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


# ---- the ten flag toggles ----------------------------------------------------------------------------------------------------------

FLAG_OTHERS = [0, 2, 0x100, 0x10001, 0xffffffff]


def words_for(k):
    """The values of the word [0x5e335e]: k itself, its neighbours, the sign and byte edge cases, and the other constants of the family."""
    out = []
    for w in [k, (k - 1) & 0xffff, k + 1, 0, 1, 2, 3, 0xffff, 0x8000, 0x8000 | k, 0x100 | k, 0xfffe, 0x4, 0xc, 0xd]:
        if w not in out:
            out.append(w)
    return out


def n_for(k):
    words = words_for(k)
    return (len(words) + len(FLAG_OTHERS) * len(words)) * 2


def make_gen(key, flag, k):
    words = words_for(k)

    def gen(rng, n):
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
    return gen


SPECS = {key: dict(id=i + 1, va=va, size=size, gen=make_gen(key, 'dword_%x' % flag, k), cleanup=0, n=n_for(k)) for i, (key, va, size, flag, k) in enumerate(ROWS)}
KEYS = list(SPECS)
NAMES = {key: 'toggle_%x' % flag for key, va, size, flag, k in ROWS}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
