"""FL-39 (batch a): the fixtures shared by tests/test_fl39a_differential.py and tests/fl39a_original_oracle.py.

Same shape as tests/fl35b_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the scripted callees (recording stubs at the call boundary, entered by address), the scripted stack argument and the globals. Random bytes fill everything else.

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
    """The fields of Fl39aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl39a.h').read_text()
    body = re.search(r'typedef struct Fl39aWorld \{(.*?)\} Fl39aWorld;', text, re.S).group(1)
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


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None, seh=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=seh, partial=None, fault=fault)


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
    if sc.seh is not None:
        read['tib'] = (TIB, 4)
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None and orig.memory.pop('tib') != struct.pack('<I', sc.seh):
        raise AssertionError('the structured-exception chain at fs:[0] was not restored')
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




SELF_BYTES = 0x400
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
RET_VALUES = [0, 1, 0x80000000, 0xffffffff]


def self_area(rng, size=SELF_BYTES):
    return Area('self', od.region_va(0), bytearray(rng.randbytes(size)), image=False)


def self_area_bytes(s):
    return Area('self', od.region_va(0), s, image=False)


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def result(rng):
    return rng.choice(RET_VALUES + [rng.randrange(1 << 32)])


def gvals(rng):
    """Random non-zero values for every world dword (a store of 0 must show)."""
    return {n_: rng.choice([0xffffffff, 0xa5a5a5a5, rng.randrange(1, 1 << 32)]) & ((1 << (8 * GLOBALS[n_][1])) - 1) or 1 for n_ in GLOBALS}


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def tbl_area(rng, name, base, stride, lo, hi, field):
    """A table of records of `stride` bytes at the original address `base` for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * stride))
    return Area(name, base + lo * stride, data, image=True), {field: (name, -lo * stride)}

# ---- kind mark1 ----------------------------------------------------------------------------------------------------
def gen_mark1(key, rng, n, c):
    gate_off, word_off, gate_bytes = c['G'], c['W'], 1
    profiles = [('gate0',), ('minus1',)] + [('mark', i) for i in (0, 1, -2, -3, 5, 0x2a)]
    (kind, *rest), variant = prof(n, profiles)
    area, ptrs = tbl_area(rng, 'tbl', c['B'], c['S'], -3, 0x2b, 'table_5d15a5')
    d = area.data
    for i in range(-3, 0x2c):                      # no entry starts with the dword 1: a store of 1 is visible
        put32(d, (i + 3) * c['S'], rng.choice([0, 2, 0x10000, 0xffffffff, 0x80000000, 0xdeadbeef]))
    s = bytearray(rng.randbytes(max(gate_off, word_off) + 16))
    on = rng.choice(NONZERO) if gate_bytes == 4 else rng.choice([1, 0x80, 0xff, 2])
    gate = 0 if kind == 'gate0' else on
    if gate_bytes == 4:
        put32(s, gate_off, gate)
    else:
        s[gate_off] = gate
    if variant % 2 and kind != 'gate0':             # the bytes next to the gate are zero
        s[gate_off + gate_bytes] = 0
        s[gate_off - 1] = 0
    if kind == 'gate0' and variant % 2:             # a zero gate with non-zero bytes next to it: a wider read of the gate would be non-zero
        s[gate_off + gate_bytes] = 0xff
        s[gate_off - 1] = 0xff
    if gate_bytes == 1 and kind == 'gate0':        # the three bytes above and below are non-zero: only the byte counts
        for k in (1, 2, 3):
            s[gate_off + k] = 0xff
            s[gate_off - k] = 0xff
    word = {'gate0': rng.choice([0, 0xffff, 0x0007, 0x1234]), 'minus1': 0xffff}.get(kind, rest[0] if rest else 0)
    put16(s, word_off, word)
    if variant % 2 and kind == 'minus1':          # the bytes around the word make the dword -1 only for a wrong width / sign
        s[word_off + 2] = 0
        s[word_off + 3] = 0
    if kind == 'mark' and variant % 2:
        s[word_off + 2] = 0xff
        s[word_off + 3] = 0xff
    return make(key, [self_area_bytes(s), area], {}, {}, [], (), (kind, *rest), ptrs)

# ---- kind guard73 ----------------------------------------------------------------------------------------------------
WORD_ARGS[0x4d3992] = (0,)       # pushed from dx with the left-over upper half of edx: the callee reads a word


def gen_guard73(key, rng, n, c):
    G, W = c['G'], c['W']
    profiles = [(gate, w) for gate in (0, 1) for w in (0xffff, 0, 0xfffe, 0x7fff, 0x8000, 0x1234)]
    (gate, w), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(max(G + 4, W + 2) + 16))
    put32(s, G, 0 if not gate else rng.choice(NONZERO))
    put16(s, W, w)
    if variant % 2 and not gate:
        s[G + 4] = s[G - 1] = 0xff             # a zero gate with non-zero bytes next to it
    stubs = {c['C1']: stub(c['C1'], THISCALL(1), results=[result(rng)]), c['C2']: stub(c['C2'], CDECL(1), results=[result(rng)]),
             c['C3']: stub(c['C3'], THISCALL(0), results=[result(rng)], probe=[('self', 0, 4)])}
    return make(key, [self_area_bytes(s)], stubs, {}, [], (), (gate, w, variant))

# ---- kind mark4 ----------------------------------------------------------------------------------------------------
def gen_mark4(key, rng, n, c):
    gate_off, word_off, gate_bytes = c['G'], c['W'], 4
    profiles = [('gate0',), ('minus1',)] + [('mark', i) for i in (0, 1, -2, -3, 5, 0x2a)]
    (kind, *rest), variant = prof(n, profiles)
    area, ptrs = tbl_area(rng, 'tbl', c['B'], c['S'], -3, 0x2b, 'table_5d15a5')
    d = area.data
    for i in range(-3, 0x2c):                      # no entry starts with the dword 1: a store of 1 is visible
        put32(d, (i + 3) * c['S'], rng.choice([0, 2, 0x10000, 0xffffffff, 0x80000000, 0xdeadbeef]))
    s = bytearray(rng.randbytes(max(gate_off, word_off) + 16))
    on = rng.choice(NONZERO) if gate_bytes == 4 else rng.choice([1, 0x80, 0xff, 2])
    gate = 0 if kind == 'gate0' else on
    if gate_bytes == 4:
        put32(s, gate_off, gate)
    else:
        s[gate_off] = gate
    if variant % 2 and kind != 'gate0':             # the bytes next to the gate are zero
        s[gate_off + gate_bytes] = 0
        s[gate_off - 1] = 0
    if kind == 'gate0' and variant % 2:             # a zero gate with non-zero bytes next to it: a wider read of the gate would be non-zero
        s[gate_off + gate_bytes] = 0xff
        s[gate_off - 1] = 0xff
    if gate_bytes == 1 and kind == 'gate0':        # the three bytes above and below are non-zero: only the byte counts
        for k in (1, 2, 3):
            s[gate_off + k] = 0xff
            s[gate_off - k] = 0xff
    word = {'gate0': rng.choice([0, 0xffff, 0x0007, 0x1234]), 'minus1': 0xffff}.get(kind, rest[0] if rest else 0)
    put16(s, word_off, word)
    if variant % 2 and kind == 'minus1':          # the bytes around the word make the dword -1 only for a wrong width / sign
        s[word_off + 2] = 0
        s[word_off + 3] = 0
    if kind == 'mark' and variant % 2:
        s[word_off + 2] = 0xff
        s[word_off + 3] = 0xff
    return make(key, [self_area_bytes(s), area], {}, {}, [], (), (kind, *rest), ptrs)

# ---- kind dtoreh ----------------------------------------------------------------------------------------------------
def gen_dtoreh(key, rng, n, c):
    areas = [self_area(rng)]
    th0 = lambda callee: stub(callee, THISCALL(0), results=[result(rng)], probe=[('self', 0, 0x20)])
    sc = make(key, areas, {c['C1']: th0(c['C1']), c['C2']: th0(c['C2'])}, {}, [], (), (n,))
    sc.seh = rng.randrange(1 << 32)
    return sc

SIZES = {
    '48220e': (58, 58),
    '487b4f': (73, 73),
    '487b98': (52, 52),
    '48a7e5': (73, 73),
    '48a82e': (55, 55),
    '48e393': (55, 55),
    '490547': (81, 81),
    '493a10': (55, 55),
    '49c59f': (81, 81),
    '4a1ce0': (52, 52),
    '4a3910': (55, 55),
    '4a6477': (55, 55),
    '4a7da5': (55, 55),
    '4a9fcb': (55, 55),
    '4ab3dc': (73, 73),
    '4ab425': (52, 52),
    '4acbba': (55, 55),
    '4afd7e': (73, 73),
    '4afdc7': (55, 55),
    '4b3d4d': (85, 85),
    '4b3da2': (61, 61),
    '4b7229': (73, 73),
    '4b7272': (55, 55),
    '4ba22e': (52, 52),
    '4cafc1': (52, 52),
    '4dbf6e': (81, 81),
    '4de1a4': (81, 81),
    '4e7684': (81, 81),
}
ROWS = {
    '48220e': ('mark1', {'G': 168, 'W': 28, 'S': 74, 'B': 6100389}),
    '487b4f': ('guard73', {'G': 32, 'OBJ': 6092377, 'C1': 4992507, 'W': 28, 'C2': 5061010, 'C3': 4750106}),
    '487b98': ('mark4', {'G': 113, 'W': 28, 'S': 74, 'B': 6100389}),
    '48a7e5': ('guard73', {'G': 32, 'OBJ': 6092377, 'C1': 4992507, 'W': 28, 'C2': 5061010, 'C3': 4761354}),
    '48a82e': ('mark4', {'G': 426, 'W': 28, 'S': 74, 'B': 6100389}),
    '48e393': ('mark4', {'G': 1122, 'W': 28, 'S': 74, 'B': 6100389}),
    '490547': ('dtoreh', {'H': 5408045, 'VT': 5430008, 'C1': 4787536, 'C2': 5363504}),
    '493a10': ('mark4', {'G': 8055, 'W': 28, 'S': 74, 'B': 6100389}),
    '49c59f': ('dtoreh', {'H': 5408112, 'VT': 5430216, 'C1': 4834954, 'C2': 5363504}),
    '4a1ce0': ('mark4', {'G': 96, 'W': 28, 'S': 74, 'B': 6100389}),
    '4a3910': ('mark4', {'G': 622, 'W': 28, 'S': 74, 'B': 6100389}),
    '4a6477': ('mark4', {'G': 134, 'W': 28, 'S': 74, 'B': 6100389}),
    '4a7da5': ('mark4', {'G': 3698, 'W': 28, 'S': 74, 'B': 6100389}),
    '4a9fcb': ('mark1', {'G': 69, 'W': 41, 'S': 74, 'B': 6100389}),
    '4ab3dc': ('guard73', {'G': 32, 'OBJ': 6092377, 'C1': 4992507, 'W': 28, 'C2': 5061010, 'C3': 4895655}),
    '4ab425': ('mark4', {'G': 84, 'W': 28, 'S': 74, 'B': 6100389}),
    '4acbba': ('mark4', {'G': 3099, 'W': 28, 'S': 74, 'B': 6100389}),
    '4afd7e': ('guard73', {'G': 32, 'OBJ': 6092377, 'C1': 4992507, 'W': 28, 'C2': 5061010, 'C3': 4914490}),
    '4afdc7': ('mark4', {'G': 5397, 'W': 28, 'S': 74, 'B': 6100389}),
    '4b3d4d': ('guard73', {'G': 1876, 'OBJ': 6092377, 'C1': 4992507, 'W': 1830, 'C2': 5061010, 'C3': 4930650}),
    '4b3da2': ('mark4', {'G': 1902, 'W': 1830, 'S': 74, 'B': 6100389}),
    '4b7229': ('guard73', {'G': 29, 'OBJ': 6092377, 'C1': 4992507, 'W': 47, 'C2': 5061010, 'C3': 4944375}),
    '4b7272': ('mark1', {'G': 53, 'W': 47, 'S': 74, 'B': 6100389}),
    '4ba22e': ('mark4', {'G': 52, 'W': 4, 'S': 74, 'B': 6100389}),
    '4cafc1': ('mark4', {'G': 14, 'W': 12, 'S': 74, 'B': 6100389}),
    '4dbf6e': ('dtoreh', {'H': 5408944, 'VT': 5432440, 'C1': 5095491, 'C2': 5363504}),
    '4de1a4': ('dtoreh', {'H': 5409004, 'VT': 5432524, 'C1': 5104148, 'C2': 5167740}),
    '4e7684': ('dtoreh', {'H': 5409308, 'VT': 5432560, 'C1': 5142253, 'C2': 5167740}),
}

GEN = {'mark1': gen_mark1, 'guard73': gen_guard73, 'mark4': gen_mark4, 'dtoreh': gen_dtoreh}
COUNTS = {'mark1': 48, 'guard73': 16, 'mark4': 48, 'dtoreh': 4}
KIND_NAMES = {'mark1': 'mark_entry', 'guard73': 'release_entry', 'mark4': 'mark_entry', 'dtoreh': 'destroy_with_frame'}
SPECFLAGS = {'48220e': {}, '487b4f': {'ret': True}, '487b98': {}, '48a7e5': {'ret': True}, '48a82e': {}, '48e393': {}, '490547': {'ret': True}, '493a10': {}, '49c59f': {'ret': True}, '4a1ce0': {}, '4a3910': {}, '4a6477': {}, '4a7da5': {}, '4a9fcb': {}, '4ab3dc': {'ret': True}, '4ab425': {}, '4acbba': {}, '4afd7e': {'ret': True}, '4afdc7': {}, '4b3d4d': {'ret': True}, '4b3da2': {}, '4b7229': {'ret': True}, '4b7272': {}, '4ba22e': {}, '4cafc1': {}, '4dbf6e': {'ret': True}, '4de1a4': {'ret': True}, '4e7684': {'ret': True}}
SPECS = {}
NAMES = {}
for _i, (_k, (_kind, _c)) in enumerate(ROWS.items()):
    _spec = SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=SIZES[_k][0], code=SIZES[_k][1], n=COUNTS[_kind])
    _spec.update(SPECFLAGS[_k])
    NAMES[_k] = KIND_NAMES[_kind]
KEYS = list(SPECS)


def build(key, rng, n):
    kind, c = ROWS[key]
    return GEN[kind](key, rng, n, c)


def scenarios(key):
    return SPECS[key]['n']
