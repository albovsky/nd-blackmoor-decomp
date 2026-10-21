"""FL-38 (batch a): the fixtures shared by tests/test_fl38a_differential.py and tests/fl38a_original_oracle.py.

Same shape as tests/fl36f_fixtures.py and tests/fl34a_fixtures.py (the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the table behind
the world pointer (the `guard` rows), the scripted callees (recording stubs at the call boundary, entered by address) and random bytes everywhere else. The scenarios cycle through profiles
(each guard failing in turn, then every arm); the surrounding bytes vary from one pass of the cycle to the next.

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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, TIB)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl38aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl38a.h').read_text()
    body = re.search(r'typedef struct Fl38aWorld \{(.*?)\} Fl38aWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4d3992: (0,), 0x4fb2e3: (0,)}      # the word arguments, pushed from a 16-bit register (the upper half of the pushed dword is not defined)


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
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the function must return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') or SPECS[sc.key].get('retself'):
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


RET_VALUES = [0, 1, 0x80000000, 0xffffffff]
NONZERO_DWORDS = [1, 0x100, 0x10000, 0x1000000, 0xffffffff, 0x80000000]          # a dword guard must see every byte: each of these has one or more bytes set
A_VALUES = [0] + NONZERO_DWORDS
TBL_LO, TBL_HI, STRIDE = -3, 0x20, 0x4a          # table elements (records of 0x4a bytes at the original address 0x5d15a5) that the indices reach
INDEXES = [0, 1, 5, 0x1f, -2, -3, -1]
WORDS = [0xffff, 0, 1, 0x7fff, 0x8000, 0xfffe]          # the word at [this+B]: 0xffff is the "none" marker; 0x8000 and 0xfffe are negative when sign-extended


def result(rng):
    return rng.choice(RET_VALUES + [rng.randrange(1 << 32)])


def self_area(rng, size):
    return Area('self', od.region_va(0), bytearray(rng.randbytes(size)), image=False)


# ---- the rows: key -> kind and the constants read from the disassembly of the row (offsets, tail callee, string address and bytes, returned value) ---------------

SIZES = {
    '414c6d': (19, 16),
    '447cc4': (28, 16),
    '4487de': (18, 16),
    '44be44': (28, 16),
    '4542b5': (61, 61),
    '4542f2': (61, 61),
    '45441d': (61, 61),
    '454de6': (83, 83),
    '454e39': (55, 55),
    '456d2e': (73, 73),
    '456d77': (52, 52),
    '457fc2': (83, 83),
    '458045': (55, 55),
    '459b87': (79, 79),
    '45dd4d': (73, 73),
    '464076': (83, 83),
    '4640c9': (55, 55),
    '465b9f': (52, 52),
    '467651': (55, 55),
    '468f19': (79, 79),
    '468f68': (55, 55),
    '46b707': (55, 55),
    '46e7a6': (73, 73),
    '46e7ef': (52, 52),
    '470ddc': (85, 85),
    '47823e': (73, 73),
    '478287': (55, 55),
}

ROWS = {
    '414c6d': ('get', {'value': 5424336}),
    '447cc4': ('get', {'value': 5425720}),
    '4487de': ('get', {'value': 5425896}),
    '44be44': ('get', {'value': 5426040}),
    '4542b5': ('nosound', {'A': 1360, 'B': 1393, 'str': '4e4f20534f554e4400', 'strva': 5545440}),
    '4542f2': ('nosound', {'A': 1409, 'B': 1442, 'str': '4e4f20534f554e4400', 'strva': 5545452}),
    '45441d': ('nosound', {'A': 1654, 'B': 1687, 'str': '4e4f20534f554e4400', 'strva': 5545500}),
    '454de6': ('releaseclr', {'A': 32, 'B': 28, 'tail': 4541854}),
    '454e39': ('guard', {'A': 336, 'B': 28, 'base': 6100389}),
    '456d2e': ('release', {'A': 32, 'B': 28, 'tail': 4549895}),
    '456d77': ('guard', {'A': 62, 'B': 28, 'base': 6100389}),
    '457fc2': ('releaseclr', {'A': 28, 'B': 36, 'tail': 4554618}),
    '458045': ('guard', {'A': 152, 'B': 36, 'base': 6100389}),
    '459b87': ('release', {'A': 200, 'B': 34, 'tail': 4561642}),
    '45dd4d': ('release', {'A': 32, 'B': 28, 'tail': 4578442}),
    '464076': ('releaseclr', {'A': 32, 'B': 28, 'tail': 4603950}),
    '4640c9': ('guard', {'A': 184, 'B': 28, 'base': 6100389}),
    '465b9f': ('guard', {'A': 73, 'B': 28, 'base': 6100389}),
    '467651': ('guard', {'A': 430, 'B': 16, 'base': 6100389}),
    '468f19': ('release', {'A': 1324, 'B': 124, 'tail': 4623962}),
    '468f68': ('guard', {'A': 1372, 'B': 124, 'base': 6100389}),
    '46b707': ('guard', {'A': 19016, 'B': 28, 'base': 6100389}),
    '46e7a6': ('release', {'A': 32, 'B': 28, 'tail': 4646593}),
    '46e7ef': ('guard', {'A': 70, 'B': 28, 'base': 6100389}),
    '470ddc': ('release', {'A': 3364, 'B': 3384, 'tail': 4656506}),
    '47823e': ('release', {'A': 32, 'B': 28, 'tail': 4686330}),
    '478287': ('guard', {'A': 5498, 'B': 28, 'base': 6100389}),
}

NAMES = {
    '414c6d': 'get_constant',
    '447cc4': 'get_constant',
    '4487de': 'get_constant',
    '44be44': 'get_constant',
    '4542b5': 'check_no_sound_call',
    '4542f2': 'check_no_sound_call',
    '45441d': 'check_no_sound_call',
    '454de6': 'release_surface_clear_call_tail',
    '454e39': 'guard_set_table_flag',
    '456d2e': 'release_surface_call_tail',
    '456d77': 'guard_set_table_flag',
    '457fc2': 'release_surface_clear_call_tail',
    '458045': 'guard_set_table_flag',
    '459b87': 'release_surface_call_tail',
    '45dd4d': 'release_surface_call_tail',
    '464076': 'release_surface_clear_call_tail',
    '4640c9': 'guard_set_table_flag',
    '465b9f': 'guard_set_table_flag',
    '467651': 'guard_set_table_flag',
    '468f19': 'release_surface_call_tail',
    '468f68': 'guard_set_table_flag',
    '46b707': 'guard_set_table_flag',
    '46e7a6': 'release_surface_call_tail',
    '46e7ef': 'guard_set_table_flag',
    '470ddc': 'release_surface_call_tail',
    '47823e': 'release_surface_call_tail',
    '478287': 'guard_set_table_flag',
}
SELF_SIZE_PAD = 0x20


def self_size(c, tail):
    return (max(c['A'] + tail, c['B'] + 2) + SELF_SIZE_PAD + 15) & ~15


def gen(key, rng, n):
    kind, c = ROWS[key]
    if kind == 'get':
        return make(key, [self_area(rng, 0x40)], {}, {}, [], (), (n,))
    if kind == 'guard':
        profiles = [(a, i) for a in A_VALUES for i in INDEXES]
        (a, idx), variant = profiles[n % len(profiles)], n // len(profiles)
        s = self_area(rng, self_size(c, 4))
        put32(s.data, c['A'], a)
        put16(s.data, c['B'], idx & 0xffff)
        count = (TBL_HI - TBL_LO + 1) * STRIDE + 8
        data = bytearray(rng.randbytes(count))
        put32(data, (idx - TBL_LO) * STRIDE, rng.choice([0, 0xffffffff, 2, 0x100, rng.randrange(1 << 32)]))
        tbl = Area('tbl', 0x5d15a5 + TBL_LO * STRIDE, data, image=True)
        return make(key, [s, tbl], {}, {}, [], (), (a, idx, variant), pointers={'table_5d15a5': ('tbl', -TBL_LO * STRIDE)})
    if kind in ('release', 'releaseclr'):
        profiles = [(a, w) for a in A_VALUES for w in WORDS]
        (a, w), variant = profiles[n % len(profiles)], n // len(profiles)
        size = self_size(c, 4)
        s = self_area(rng, size)
        put32(s.data, c['A'], a)
        put16(s.data, c['B'], w)
        probe = [('self', 0, size)]
        stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), results=[result(rng)], probe=probe),
                 0x4d3992: stub(0x4d3992, CDECL(1), results=[result(rng)], probe=probe),
                 c['tail']: stub(c['tail'], THISCALL(0), results=[result(rng)], probe=probe)}
        return make(key, [s], stubs, {}, [], (), (a, w, variant))
    if kind == 'nosound':
        string = bytes.fromhex(c['str'])
        profiles = [('eq', 0)] * 2 + [('diff', k, d) for k in range(9) for d in (1, 0x80)] + [('beyond', 9), ('beyond', -1)]
        profile, variant = profiles[n % len(profiles)], n // len(profiles)
        size = self_size(c, 9)
        s = self_area(rng, size)
        data = bytearray(string)
        if profile[0] == 'diff':
            data[profile[1]] ^= profile[2]
        s.data[c['A']:c['A'] + 9] = data
        if profile[0] == 'beyond':      # a difference just outside the 9 bytes does not count
            s.data[c['A'] + profile[1]] ^= 0x55
        put16(s.data, c['B'], rng.choice(WORDS + [rng.randrange(1 << 16)]))
        stubs = {0x4fb2e3: stub(0x4fb2e3, THISCALL(1), results=[result(rng)], probe=[('self', 0, size)])}
        return make(key, [s], stubs, {}, [], (), (profile, variant))
    raise KeyError(kind)


PROFILES = {'get': 4, 'guard': 2 * len(A_VALUES) * len(INDEXES), 'release': 2 * len(A_VALUES) * len(WORDS), 'releaseclr': 2 * len(A_VALUES) * len(WORDS), 'nosound': 2 * (2 + 18 + 2)}
SPECS = {}
for _i, (_k, (_kind, _c)) in enumerate(ROWS.items()):
    _spec = SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=SIZES[_k][0], code=SIZES[_k][1], n=PROFILES[_kind])
    if _kind == 'guard':
        _spec['retself'] = True
    else:
        _spec['ret'] = True
KEYS = list(SPECS)


def build(key, rng, n):
    return gen(key, rng, n)


def scenarios(key):
    return SPECS[key]['n']
