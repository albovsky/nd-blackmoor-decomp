"""FL-37: the fixtures shared by tests/test_fl37_differential.py and tests/fl37_original_oracle.py.

Same shape as tests/fl34b_fixtures.py and tests/fl32a_fixtures.py (the flag toggles of FL-34 batch b and FL-32 batch a; the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner
with the code and edge hooks, the recording stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one
of the 57 flag toggles of ROWS: the object `this`, the scripted callee 0x404be1 (a recording stub entered by address) and the globals. The scenarios cycle through
profiles (the flag equal to 1 with every word, the flag not 1 with every word); random bytes fill everything else. Every global of Fl37World is set (random) in
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
    """The fields of Fl37World, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl37.h').read_text()
    body = re.search(r'typedef struct Fl37World \{(.*?)\} Fl37World;', text, re.S).group(1)
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

# (key = va without 0x, va, span, flag address, k): the constants of each row, read from its own disassembly (tasks/fl37-handoff.md). k is the word constant of
# `movsx eax, word ptr [0x5e335e]; cmp eax, k; jne`. 0x407ac7 has span 73 (71 code bytes plus two `int3`).
ROWS = [('406b3f', 0x406b3f, 71, 0x5e353e, 0xd), ('406b86', 0x406b86, 71, 0x5e3542, 0xe), ('406bcd', 0x406bcd, 71, 0x5e3546, 0xf),
        ('406c14', 0x406c14, 71, 0x5e354a, 0x10), ('406c5b', 0x406c5b, 71, 0x5e354e, 0x11), ('406ca2', 0x406ca2, 71, 0x5e3552, 0x12),
        ('406ce9', 0x406ce9, 71, 0x5e3556, 0x13), ('406d30', 0x406d30, 71, 0x5e355a, 0x14), ('406d77', 0x406d77, 71, 0x5e355e, 0x15),
        ('406dbe', 0x406dbe, 71, 0x5e3562, 0x16), ('406e05', 0x406e05, 71, 0x5e3566, 0x17), ('406e4c', 0x406e4c, 71, 0x5e356a, 0x18),
        ('406e93', 0x406e93, 71, 0x5e356e, 0x19), ('406eda', 0x406eda, 71, 0x5e3572, 0x1a), ('406f21', 0x406f21, 71, 0x5e3576, 0x1b),
        ('406f68', 0x406f68, 71, 0x5e357a, 0x1c), ('406faf', 0x406faf, 71, 0x5e357e, 0x1d), ('406ff6', 0x406ff6, 71, 0x5e3582, 0x1e),
        ('40703d', 0x40703d, 71, 0x5e3586, 0x1f), ('407084', 0x407084, 71, 0x5e358a, 0x20), ('4070cb', 0x4070cb, 71, 0x5e358e, 0x21),
        ('407112', 0x407112, 71, 0x5e3592, 0x22), ('407159', 0x407159, 71, 0x5e3596, 0x23), ('4071a0', 0x4071a0, 71, 0x5e359a, 0x24),
        ('4071e7', 0x4071e7, 71, 0x5e359e, 0x25), ('40722e', 0x40722e, 71, 0x5e35a2, 0x26), ('407275', 0x407275, 71, 0x5e35a6, 0x27),
        ('4072bc', 0x4072bc, 71, 0x5e35aa, 0x28), ('407303', 0x407303, 71, 0x5e35ae, 0x29), ('40734a', 0x40734a, 71, 0x5e35b2, 0x2a),
        ('407391', 0x407391, 71, 0x5e35b6, 0x2b), ('4073d8', 0x4073d8, 71, 0x5e35ba, 0x2c), ('40741f', 0x40741f, 71, 0x5e35be, 0x2d),
        ('407466', 0x407466, 71, 0x5e35c2, 0x2e), ('4074ad', 0x4074ad, 71, 0x5e35c6, 0x2f), ('4074f4', 0x4074f4, 71, 0x5e35ca, 0x30),
        ('40753b', 0x40753b, 71, 0x5e35ce, 0x31), ('407582', 0x407582, 71, 0x5e35d2, 0x32), ('4075c9', 0x4075c9, 71, 0x5e35d6, 0x33),
        ('407610', 0x407610, 71, 0x5e35da, 0x34), ('407657', 0x407657, 71, 0x5e35de, 0x35), ('40769e', 0x40769e, 71, 0x5e35e2, 0x36),
        ('4076e5', 0x4076e5, 71, 0x5e35e6, 0x37), ('40772c', 0x40772c, 71, 0x5e35ea, 0x38), ('407773', 0x407773, 71, 0x5e35ee, 0x39),
        ('4077ba', 0x4077ba, 71, 0x5e35f2, 0x3a), ('407801', 0x407801, 71, 0x5e35f6, 0x3b), ('407848', 0x407848, 71, 0x5e35fa, 0x3c),
        ('40788f', 0x40788f, 71, 0x5e35fe, 0x3d), ('4078d6', 0x4078d6, 71, 0x5e3602, 0x3e), ('40791d', 0x40791d, 71, 0x5e3606, 0x3f),
        ('407964', 0x407964, 71, 0x5e360a, 0x40), ('4079ab', 0x4079ab, 71, 0x5e360e, 0x41), ('4079f2', 0x4079f2, 71, 0x5e3612, 0x42),
        ('407a39', 0x407a39, 71, 0x5e3616, 0x43), ('407a80', 0x407a80, 71, 0x5e361a, 0x44), ('407ac7', 0x407ac7, 73, 0x5e361e, 0x45)]
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
    for w in [k, (k - 1) & 0xffff, k + 1, 0, 1, 2, 3, 0xffff, 0x8000, 0x8000 | k, 0x100 | k, 0xfffe, 0xc, 0xd, 0x45]:
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


SPECS = {key: dict(id=i + 1, va=va, size=size, **({'code': 71} if size == 73 else {}), gen=make_gen(key, 'dword_%x' % flag, k), cleanup=0, n=n_for(k)) for i, (key, va, size, flag, k) in enumerate(ROWS)}
KEYS = list(SPECS)
NAMES = {key: 'toggle_%x' % flag for key, va, size, flag, k in ROWS}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
