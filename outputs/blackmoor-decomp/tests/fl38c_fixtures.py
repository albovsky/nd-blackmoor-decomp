"""FL-38 (batch c): the fixtures shared by tests/test_fl38c_differential.py and tests/fl38c_original_oracle.py.

Same shape as tests/fl38b_fixtures.py and tests/fl36f_fixtures.py (the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the 24 functions of ROWS, which come in five shapes (`group`):
  g1  read_word_setting  (59 bytes, 7 rows)   g2  read_time_setting (164 bytes, 6 rows)   g3  shift_rect (83 bytes, 6 rows)
  g4a new_zeroed (139 bytes, 2 rows)          g4b/g4c clamp_to_bounds (207 and 255 bytes, 3 rows).
Each scenario holds the object or the memory the function reaches, the scripted callees (recording stubs at the call boundary, entered by address) and the globals; the scenarios cycle
through profiles (the scripted answers, the index and the overlaps, each guard of the clamps going both ways) and the optional parts vary from one pass to the next.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (host boundaries); nothing inside the function under test is patched. A stub can
write a byte string through its first argument (0x51d5b2 reads a string into a local of the function). The callee 0x4c97b4 (called by new_zeroed when the allocation failed) is modelled as
a normal callee that returns: its body (read from GAME.EXE) calls PostQuitMessage (import 0x52a48c) and returns with `ret`.
"""
import hashlib
from pathlib import Path
import struct
import sys
from types import SimpleNamespace

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
from fl28b_fixtures import (Original27, stub, CDECL, THISCALL, Area, put32, put16, normalize, conditional_edges, FMT, debug_areas, LOCAL, CTYPES)
import ctypes
import re

PROJECT = Path(__file__).resolve().parents[1]


def parse_world():
    """The fields of Fl38cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl38c.h').read_text()
    found = re.search(r'typedef struct Fl38cWorld \{(.*?)\} Fl38cWorld;', text, re.S)
    body = re.sub(r'/\*.*?\*/', '', found.group(1), flags=re.S)
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

# ---- the rows: key -> the constants read from the disassembly of the row (every row's whole instruction stream was asserted against its shape with these constants) ------------------
# g1: off = the add to ecx for 0x51d5b2, g = the word global written, callee = the method of self called last
# g2: off as above, base = the entry-relative base of the five fields (0x5e569e or 0x5e56b2), store = the field (+4, +8 or +0xc) that receives the converted value
# g4a: fmt = the format string pushed for 0x50ca3e;  g4b/g4c: A, B, C, D = the fields clamped, W1, W2 = the int16 extents
ROWS = {
    '40430e': dict(group='g1', size=59, off=0x18c, g=0x5e5686, callee=0x4033db),
    '404349': dict(group='g1', size=59, off=0x14c, g=0x5e5684, callee=0x4033db),
    '40492f': dict(group='g1', size=59, off=0x38c, g=0x5ec33a, callee=0x4033db),
    '40496a': dict(group='g1', size=59, off=0x3cc, g=0x5ec284, callee=0x4033db),
    '4049a5': dict(group='g1', size=59, off=0x44c, g=0x5ec288, callee=0x4033db),
    '4049e0': dict(group='g1', size=59, off=0x40c, g=0x5ec286, callee=0x4033db),
    '40893f': dict(group='g1', size=59, off=0x94c, g=0x5ec2d4, callee=0x407ca7),
    '4043b6': dict(group='g2', size=164, off=0x24c, base=0x5e569e, store=0xc),
    '40445a': dict(group='g2', size=164, off=0x20c, base=0x5e569e, store=0x8),
    '4044fe': dict(group='g2', size=164, off=0x28c, base=0x5e569e, store=0x4),
    '4045a2': dict(group='g2', size=164, off=0x30c, base=0x5e56b2, store=0xc),
    '404646': dict(group='g2', size=164, off=0x2cc, base=0x5e56b2, store=0x8),
    '4046ea': dict(group='g2', size=164, off=0x34c, base=0x5e56b2, store=0x4),
    '454f29': dict(group='g3', size=83),
    '457071': dict(group='g3', size=83),
    '458137': dict(group='g3', size=83),
    '46453b': dict(group='g3', size=83),
    '466db1': dict(group='g3', size=83),
    '479d98': dict(group='g3', size=83),
    '4465fd': dict(group='g4a', size=139, fmt=0x54824c),
    '4547bc': dict(group='g4a', size=139, fmt=0x549e28),
    '454f7c': dict(group='g4b', size=207, A=0x4e, B=0x56, C=0x4a, D=0x52, W1=0x16c, W2=0x16a),
    '46458e': dict(group='g4b', size=207, A=0x4e, B=0x56, C=0x4a, D=0x52, W1=0xd4, W2=0xd2),
    '46b855': dict(group='g4c', size=255, A=0x49f8, B=0x4a00, C=0x49f4, D=0x49fc, W1=0x816c, W2=0x816a),
}
SHAPE = {'g1': 'read_word_setting', 'g2': 'read_time_setting', 'g3': 'shift_rect', 'g4a': 'new_zeroed', 'g4b': 'clamp_to_bounds', 'g4c': 'clamp_to_bounds'}

DBG_WORDS = [0, 1, 0x8000, 0x100, 0xffff]
R16 = [0, 1, 0x7fff, 0x8000, 0xffff, 0x10000, 0x12345678, 0xffffffff, 0x80000001, 0xdeadbeef]
TABLE_SLACK = 0x200                 # bytes of the table area below 0x5e569e (an index of -1 reaches into them)
TABLE_BASE = 0x5e569e


def rnd32(rng):
    return rng.choice([0, 1, 0xffffffff, 0x7fffffff, 0x80000000, 0x36ee80, rng.randrange(1 << 32), rng.randrange(1 << 32), rng.randrange(1 << 12)])


def sc_common(key, areas, stubs, g, stack, profile, pointers=None, ecx=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp['size'], areas=areas, stubs=stubs, iat={}, g=g, ecx=od.region_va(0) if ecx is None else ecx,
                           pointers=pointers or {}, word_args={}, profile=profile, stack=stack, args=tuple(stack), seh=None, partial=None, fault=None)


def read_stubs(rng, c, n, callee, probe=None):
    """0x51d5b2 writes a 0x13-byte string through its first argument (a local of the function), 0x50cb1b converts it (a scripted answer, and the string it was given is logged),
    `callee` is the method of self called last (a scripted answer; `probe` = the bytes of the world or of an area that are logged at that call, to see what was stored before it)."""
    text = bytes(rng.choice(b'0123456789 \x00\xff-x') for _ in range(0x13))
    answer = R16[n % len(R16)] if n // len(R16) % 2 == 0 else rng.randrange(1 << 32)
    tail = rng.choice([0, 1, 0xcafef00d, rng.randrange(1 << 32)])
    return {0x51d5b2: stub(0x51d5b2, THISCALL(2), results=[rng.randrange(1 << 32)], writes=[(0, 0, 0, 0, text)]),
            0x50cb1b: stub(0x50cb1b, CDECL(1), results=[answer], derefs=[(0, 0x13)]),
            callee: stub(callee, THISCALL(0), results=[tail], probe=probe)}


def gen_g1(key, rng, n):
    c = ROWS[key]
    self_ = bytearray(rng.randbytes(0xa00))
    word = 'word_%x' % c['g']
    g = {word: rng.choice([0, 0xffff, rng.randrange(1 << 16)])}
    return sc_common(key, [Area('self', od.region_va(0), self_, image=False)], read_stubs(rng, c, n, c['callee'], probe=[('g:word_%x' % c['g'], 0, 2)]), g, [], n % len(R16))


def gen_g2(key, rng, n):
    c = ROWS[key]
    self_ = bytearray(rng.randbytes(0xa00))
    idx = [0, 1, 2, 3, -1][(n // 3) % 5]
    table = bytearray(rng.randbytes(TABLE_SLACK + 4 * 0x106 + 0x100))
    if n % 4 == 1:                                  # small field values: the sum is not wrapped, so a wrong multiplier shows
        for e in range(-1, 4):
            for off in (4, 8, 0xc):
                put32(table, TABLE_SLACK + e * 0x106 + (c['base'] - TABLE_BASE) + off, rng.randrange(1, 100))
    g = {'dword_5c3a63': idx & 0xffffffff}
    areas = [Area('self', od.region_va(0), self_, image=False), Area('table', TABLE_BASE - TABLE_SLACK, table)]
    return sc_common(key, areas, read_stubs(rng, c, n, 0x4033db, probe=[('table', 0, len(table))]), g, [], (n % len(R16), idx), pointers={'table_5e569e': ('table', TABLE_SLACK)})


G3_PLACE = [(0x20, 0), (0, 0), (4, 0), (8, 0), (0xc, 0), (-4, 0), (-8, 0), (-0xc, 0), (1, 0), (-2, 0), (0x30, 3), (0x18, 1)]


def gen_g3(key, rng, n):
    rects = bytearray(rng.randbytes(0x100))
    delta, skew = G3_PLACE[n % len(G3_PLACE)]
    base = od.region_va(1)
    src = base + 0x40 + skew
    dst = src + delta
    if n // len(G3_PLACE) % 2 == 1 and delta not in (0, 1, -2):         # a second pass: a different, unaligned source
        src += 1
        dst += 1
    g = {'dword_58318a': rnd32(rng), 'dword_583186': rnd32(rng)}
    return sc_common(key, [Area('rects', base, rects, image=False)], {}, g, [src, dst], (delta, skew), ecx=rng.randrange(1 << 32))


NEW_SIZES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 17, 33, 64, 0x7e, 0x80, 0x83]


def gen_g4a(key, rng, n):
    c = ROWS[key]
    kind = ['ok', 'ok', 'ok', 'null', 'null', 'inside', 'ok'][n % 7]
    size = NEW_SIZES[n % len(NEW_SIZES)] if kind != 'inside' else rng.choice([8, 16, 0x21])
    cells = bytearray(rng.randbytes(0x40))
    blk = bytearray(rng.choice(range(1, 256)) for _ in range(0x200))
    cell_va, blk_va = od.region_va(0), od.region_va(1)
    out = cell_va + 0x10 + n // 7 % 3
    p = blk_va + n // 7 % 4
    if kind == 'null':
        p = 0
    elif kind == 'inside':           # the cell lives inside the block that is zeroed: the zeroing wipes the cell that was just written
        out = blk_va + 0x20 + 1
        p = blk_va + 0x18
    dbg = DBG_WORDS[n % 5] if n // 7 % 2 == 0 else DBG_WORDS[(n + 2) % 5]
    g = {'word_63a4cd': dbg}
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[p]), 0x50ca3e: stub(0x50ca3e, CDECL(2), results=[rng.randrange(1 << 32)]),
             0x4264e8: stub(0x4264e8, THISCALL(1), results=[rng.randrange(1 << 32)]), 0x44a2b7: stub(0x44a2b7, CDECL(1), results=[rng.randrange(1 << 32)]),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), results=[rng.randrange(1 << 32)])}
    _, dbg_areas = debug_areas(rng, dbg)
    areas = [Area('cells', cell_va, cells, image=False), Area('blk', blk_va, blk, image=False), *dbg_areas]
    return sc_common(key, areas, stubs, g, [out, size], (kind, size), ecx=rng.randrange(1 << 32))


def bound_pick(rng, lo, hi):
    return rng.choice([lo - 5, lo, lo + 5, hi - 5, hi, hi + 5, (lo + hi) // 2, rng.randrange(-1 << 31, 1 << 31), -1 << 31, (1 << 31) - 1])


def gen_clamp(key, rng, n):
    c = ROWS[key]
    size = 0x8200 if c['group'] == 'g4c' else 0x400
    self_ = bytearray(rng.randbytes(size))
    xlo = rng.choice([0, -100, 100, rng.randrange(-1 << 31, 1 << 31), -1 << 31, (1 << 31) - 1, 0x7fff0000])
    ylo = rng.choice([0, -50, 50, rng.randrange(-1 << 31, 1 << 31), -1 << 31, (1 << 31) - 1])
    xhi = xlo + rng.choice([0, 1, 50, 640, -20, 1 << 20, rng.randrange(1 << 31)])
    yhi = ylo + rng.choice([0, 1, 50, 480, -20, 1 << 20, rng.randrange(1 << 31)])
    wrap = lambda v: ((v + (1 << 31)) % (1 << 32)) - (1 << 31)
    xlo, xhi, ylo, yhi = wrap(xlo), wrap(xhi), wrap(ylo), wrap(yhi)
    w1 = rng.choice([0, 1, -1, 7, 100, 0x7fff, -0x8000, rng.randrange(-0x8000, 0x8000)])
    w2 = rng.choice([0, 1, -1, 7, 100, 0x7fff, -0x8000, rng.randrange(-0x8000, 0x8000)])
    put32(self_, c['A'], bound_pick(rng, xlo, xhi))
    put32(self_, c['B'], bound_pick(rng, xlo, xhi))
    put32(self_, c['C'], bound_pick(rng, ylo, yhi))
    put32(self_, c['D'], bound_pick(rng, ylo, yhi))
    put16(self_, c['W1'], w1)
    put16(self_, c['W2'], w2)
    g = {'dword_58319a': xlo & 0xffffffff, 'dword_5831a2': xhi & 0xffffffff, 'dword_583196': ylo & 0xffffffff, 'dword_58319e': yhi & 0xffffffff}
    return sc_common(key, [Area('self', od.region_va(0), self_, image=False)], {}, g, [], (w1, w2))


GEN = {'g1': gen_g1, 'g2': gen_g2, 'g3': gen_g3, 'g4a': gen_g4a, 'g4b': gen_clamp, 'g4c': gen_clamp}


def run_original(sc):
    """Runs the original bytes on the scenario. Returns (Result, normalised calls, digest of calls and memory read back)."""
    image_patches = [(a.va, a.data) for a in sc.areas if a.image]
    for field, value in sc.g.items():
        address, size_ = GLOBALS[field]
        image_patches.append((address, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1))))
    regions = {a.name: (a.va, a.data) for a in sc.areas if not a.image}
    read = {a.name: (a.va, len(a.data)) for a in sc.areas if a.compare}
    for field in sc.g:
        read['g:' + field] = GLOBALS[field]
    for x in sc.stubs.values():
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, {})
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key]['cleanup']:
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, {}, {})
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests): none
UNTAKEN_ALLOWED = {}


def untaken_edges(key, edges):
    """[(jcc address, 'taken' or 'fall-through')] of the conditional jumps of the function `key` that none of `edges` (the union of the
    (instruction, next instruction) pairs of the scenarios) went the way of."""
    sp = SPECS[key]
    out = []
    for address, _, target, after in conditional_edges(sp['va'], sp['size']):
        if (address, target) not in edges:
            out.append((address, 'taken'))
        if (address, after) not in edges:
            out.append((address, 'fall-through'))
    return out


def check_edges(key, edges):
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    total = 2 * len(conditional_edges(SPECS[key]['va'], SPECS[key]['size']))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


SPECS = {}
NAMES = {}
SCENARIOS = {'g1': 24, 'g2': 40, 'g3': 24, 'g4a': 56, 'g4b': 160, 'g4c': 160}
for _i, (_k, _c) in enumerate(ROWS.items()):
    _g = _c['group']
    SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=_c['size'], n=SCENARIOS[_g], cleanup=8 if _g in ('g3', 'g4a') else 0, ret=_g in ('g1', 'g2'), ptr_args=_g == 'g3')
    NAMES[_k] = SHAPE[_g]
KEYS = list(SPECS)


def build(key, rng, n):
    return GEN[ROWS[key]['group']](key, rng, n)


def scenarios(key):
    return SPECS[key]['n']
