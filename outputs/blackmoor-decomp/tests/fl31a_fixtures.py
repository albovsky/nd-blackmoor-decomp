"""FL-31 (batch a): the fixtures shared by tests/test_fl31a_differential.py and tests/fl31a_original_oracle.py.

Same shape as tests/fl29a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the objects behind the addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address, and the GetTickCount import slot) and the
globals. The scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional parts vary
from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the import are recording stubs (OS or host boundaries); nothing inside the
function under test is patched.
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
TICK_SLOT = 0x52a23c


def parse_world():
    """The fields of Fl31aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl31a.h').read_text()
    body = re.search(r'typedef struct Fl31aWorld \{(.*?)\} Fl31aWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4d3992: (0,)}       # 0x47b321 pushes eax whose upper half is the left-over of `this`; the callee reads a word
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None)


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
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the constructor did not return this')
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


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def tbl_area(rng, lo, hi):
    """The table of stride 0x4a at the original address 0x5d15a5 for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * 0x4a))
    return Area('tbl', 0x5d15a5 + lo * 0x4a, data, image=True), {'table_5d15a5': ('tbl', -lo * 0x4a)}


# ---- 0x47b200 ---------------------------------------------------------------------------------------------------------------------


def gen_47b200(rng, n):
    (kind,), variant = prof(n, [('run',)] * 4)
    s = bytearray(rng.randbytes(0x400))
    stubs = {0x47b23b: stub(0x47b23b, THISCALL(0), probe=[('self', 0, 0x10)])}
    return make('47b200', [self_area(s)], stubs, {}, [], (), (kind, variant))


# ---- 0x47b3bc and 0x47d640 --------------------------------------------------------------------------------------------------------

MARK_INDEXES = [0, 1, -2, -3, 5, 0x2a]


def gen_mark(key, rng, n, gate_off, word_off, gate_bytes):
    profiles = [('gate0',), ('minus1',)] + [('mark', i) for i in MARK_INDEXES]
    (kind, *rest), variant = prof(n, profiles)
    area, ptrs = tbl_area(rng, -3, 0x2b)
    d = area.data
    for i in range(-3, 0x2c):                      # no entry starts with the dword 1: a store of 1 is visible
        put32(d, (i + 3) * 0x4a, rng.choice([0, 2, 0x10000, 0xffffffff, 0x80000000, 0xdeadbeef]))
    s = bytearray(rng.randbytes(0x400))
    on = rng.choice(NONZERO) if gate_bytes == 4 else rng.choice([1, 0x80, 0xff, 2])
    off = 0
    gate = off if kind == 'gate0' else on
    if gate_bytes == 4:
        put32(s, gate_off, gate)
    else:
        s[gate_off] = gate
    if variant % 2 and kind != 'gate0':             # the neighbours of the gate: a wider read of the gate would be non-zero
        s[gate_off + 1] = 0
        s[gate_off - 1] = 0
    if kind == 'gate0' and variant % 2:
        s[gate_off + 1] = 0xff
        s[gate_off - 1] = 0xff
    if gate_bytes == 1 and kind == 'gate0':        # the three bytes above and below are non-zero: only the byte counts
        for k in (1, 2, 3):
            s[gate_off + k] = 0xff
        for k in (1, 2, 3):
            s[gate_off - k] = 0xff
    word = {'gate0': rng.choice([0, 0xffff, 0x0007, 0x1234]), 'minus1': 0xffff}.get(kind, rest[0] if rest else 0)
    put16(s, word_off, word)
    if variant % 2 and kind == 'minus1':          # the bytes around the word make the dword -1 only for a wrong width / sign
        s[word_off + 2] = 0
        s[word_off + 3] = 0
    if kind == 'mark' and variant % 2:
        s[word_off + 2] = 0xff
        s[word_off + 3] = 0xff
    return make(key, [self_area(s), area], {}, {}, [], (), (kind, *rest), ptrs)


def gen_47b3bc(rng, n):
    return gen_mark('47b3bc', rng, n, 0x24, 4, 4)


def gen_47d640(rng, n):
    return gen_mark('47d640', rng, n, 0x57, 0x23, 1)


# ---- 0x47b709 ---------------------------------------------------------------------------------------------------------------------

SEL_VALUES = [0, 1, 0x7fff, 0x8000, 0xffff, 0x1234, 0xfffe, 0x80]


def gen_47b709(rng, n):
    (sel,), variant = prof(n, [(v,) for v in SEL_VALUES])
    g = {name: rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32), rng.randrange(1 << 32)]) for name, _ in ((f, 0) for f in GLOBALS)}
    if variant % 2:
        g['value_5b44f0'], g['value_5b44f4'] = 1, 0     # the stores of 0 and 1 are visible
    a = word_arg(rng, sel)
    return make('47b709', [self_area(bytearray(rng.randbytes(0x100)))], {}, g, [a], (a,), (sel, variant))


# ---- 0x47ba79 ---------------------------------------------------------------------------------------------------------------------

TICK_PAIRS = [(5, 10), (10, 10), (11, 10), (0x80000000, 0x7fffffff), (0x7fffffff, 0x80000000), (0xffffffff, 0), (0, 0xffffffff), (1, 0), (0, 0)]


def tick_iat(now):
    return {TICK_SLOT: stub(TICK_SLOT, (0, False, 0), results=[now])}


def gen_47ba79(rng, n):
    profiles = [('gate0',)] + [('tick', now, deadline) for now, deadline in TICK_PAIRS]
    (kind, *rest), variant = prof(n, profiles)
    a_va, b_va = od.region_va(1), od.region_va(2)
    s = bytearray(rng.randbytes(0x400))
    put32(s, 0x1c, a_va)
    put32(s, 0x20, a_va if variant % 3 == 2 else b_va)       # one pass with both pointers to the same object
    put32(s, 0x34, 0 if kind == 'gate0' else NONZERO[variant % len(NONZERO)])
    now, deadline = (rng.choice([0, 3, 0xffffffff, rng.randrange(1 << 32)]), rng.randrange(1 << 32)) if kind == 'gate0' else rest
    if kind == 'gate0' and variant % 2:
        now, deadline = 0xffffffff, 0                         # a gate that was skipped would expire the links
    put32(s, 0x38, deadline)
    a, b = bytearray(rng.randbytes(0x40)), bytearray(rng.randbytes(0x40))
    for obj in (a, b):
        put32(obj, 4, rng.choice([0, 1, 0xdeadbeef, 0xffffffff]))
    return make('47ba79', [self_area(s), Area('a', a_va, a, image=False), Area('b', b_va, b, image=False)], {}, {}, [], (), (kind, *rest), iat=tick_iat(now))


# ---- 0x47badf ---------------------------------------------------------------------------------------------------------------------

ORDERED = [(0, 1), (1, 1), (2, 1), (-1, 0), (0, -1), (0x7fffffff, 0x80000000), (0x80000000, 0x7fffffff), (5, 5), (-5, -2)]


def gen_47badf(rng, n):
    (ab, cd), variant = prof(n, [(ab, cd) for ab in ORDERED for cd in ORDERED])
    obj_va = od.region_va(1)
    s = bytearray(rng.randbytes(0x400))
    a, b = ab
    c, d = cd
    put32(s, 0x290, a)
    put32(s, 0x2a0, b)
    put32(s, 0x294, c)
    put32(s, 0xc, obj_va)
    put32(s, 0x28, rng.choice([0, 2, 0xffffffff, 1]))
    put32(s, 0x2c, rng.choice([0, 2, 0xffffffff, 1]) if variant % 2 else 0)
    obj = bytearray(rng.randbytes(0x400))
    put32(obj, 0x341, d)
    return make('47badf', [self_area(s), Area('obj', obj_va, obj, image=False)], {}, {}, [], (), (ab, cd))


# GEN-END

SPECS = {
    '47b200': dict(id=1, va=0x47b200, size=31, gen=gen_47b200, cleanup=0, retself=True, n=8),
    '47b3bc': dict(id=2, va=0x47b3bc, size=52, gen=gen_47b3bc, cleanup=0, n=8 * 6),
    '47d640': dict(id=3, va=0x47d640, size=55, gen=gen_47d640, cleanup=0, n=8 * 6),
    '47b709': dict(id=4, va=0x47b709, size=94, gen=gen_47b709, cleanup=4, n=8 * 6),
    '47ba79': dict(id=5, va=0x47ba79, size=102, gen=gen_47ba79, cleanup=0, n=10 * 6),
    '47badf': dict(id=6, va=0x47badf, size=119, gen=gen_47badf, cleanup=0, n=81 * 2),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'47b200': 'construct', '47b3bc': 'mark_entry', '47d640': 'mark_entry',
         '47b709': 'set_selector', '47ba79': 'expire_links', '47badf': 'check_range',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
