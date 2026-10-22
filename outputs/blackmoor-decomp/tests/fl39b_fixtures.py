"""FL-39 (batch b): the fixtures shared by tests/test_fl39b_differential.py and tests/fl39b_original_oracle.py.

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
    """The fields of Fl39bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl39b.h').read_text()
    body = re.search(r'typedef struct Fl39bWorld \{(.*?)\} Fl39bWorld;', text, re.S).group(1)
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

# ---- kind clone_dwb ----------------------------------------------------------------------------------------------------
DBG_clone_dwb = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_dwb(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_dwb])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_dwb)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_dw ----------------------------------------------------------------------------------------------------
DBG_clone_dw = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_dw(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_dw])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_dw)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_db ----------------------------------------------------------------------------------------------------
DBG_clone_db = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_db(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_db])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_db)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_d ----------------------------------------------------------------------------------------------------
DBG_clone_d = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_d(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_d])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_d)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_s2 ----------------------------------------------------------------------------------------------------
DBG_clone_s2 = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_s2(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_s2])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_s2)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_s4 ----------------------------------------------------------------------------------------------------
DBG_clone_s4 = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_s4(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_s4])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_s4)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_s6 ----------------------------------------------------------------------------------------------------
DBG_clone_s6 = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_s6(key, rng, n, c):
    S, exits = c['S'], False
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_s6])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_s6)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

# ---- kind clone_exit ----------------------------------------------------------------------------------------------------
DBG_clone_exit = [0, 1, 0x100, 0x8000, 0xffff]


def gen_clone_exit(key, rng, n, c):
    S, exits = c['S'], True
    (kind, *rest), variant = prof(n, [('null',)] + [('ok', d) for d in DBG_clone_exit])
    off, boff = [0, 1, 3, 8, 5][variant % 5], [0, 4, 1, 7, 2][(variant + 2) % 5]
    cells_va, src_va, blk_va = od.region_va(1), od.region_va(2), od.region_va(3)
    cells = bytearray(rng.randbytes(0x20))
    put32(cells, 0, rng.choice([0xffffffff, 0x80000000, 0x12345678, rng.randrange(1, 1 << 32)]))     # the destination cell: a stale non-zero value
    put32(cells, 4, src_va + off)
    put32(cells, 8, rng.choice([0, 1, 0xfffffff0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    src = bytearray(rng.randbytes(off + S + 16))
    blk = bytearray(rng.randbytes(boff + S + 16))
    dbg = rest[0] if kind == 'ok' else rng.choice(DBG_clone_exit)
    g = {'value_5bb57b': rng.choice([0, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]), 'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 0x1234, -2]), 'word_63a4cd': dbg}
    if exits:
        g['value_63a58a'] = rng.choice([0, 4, 6, 1, 0xffffffff, rng.randrange(1 << 32)])
    nbr = [Area('dbgnbr', 0x63a4cf, bytearray([0xff, 0xff] if dbg == 0 else [0, 0]), compare=False)]
    areas = [Area('cells', cells_va, cells, image=False), Area('src', src_va, src, image=False), Area('blk', blk_va, blk, image=False), *nbr]
    probe = [('cells', 0, 12), ('blk', 0, boff + S)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[0 if kind == 'null' else blk_va + boff]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe=[('cells', 0, 12)]),
             0x42639d: stub(0x42639d, THISCALL(2), probe=[('cells', 0, 12)]), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('cells', 0, 12)] + ([('g:value_63a58a', 0, 4)] if exits else [])),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    stack = [cells_va, cells_va + 4, cells_va + 8]
    if kind == 'null' and not exits:
        areas.append(Area('zero', 0, bytearray(0x1000), image=False, compare=False))      # the original stores through the null pointer: a zero page is mapped, the native port rejects
    sc = make(key, areas, stubs, g, stack, tuple(stack), (kind, *rest, variant))
    if kind == 'null' and not exits:
        sc.partial = (4, {'cells': 4})
    return sc

SIZES = {
    '484110': (187, 187),
    '487bd7': (187, 187),
    '48a865': (187, 187),
    '48d12d': (187, 187),
    '493b7a': (186, 186),
    '4a3a33': (185, 185),
    '4a64b9': (187, 187),
    '4a7e50': (184, 184),
    '4ab46d': (187, 187),
    '4acbf1': (186, 186),
    '4afe09': (184, 184),
    '4b3ddf': (186, 186),
    '4b72cf': (186, 186),
    '4b80d9': (186, 186),
    '4ba2bd': (186, 186),
    '4e9a2c': (177, 177),
    '4e9add': (170, 170),
    '4e9b87': (168, 168),
    '4e9cdf': (176, 176),
    '4fcda1': (189, 189),
}
ROWS = {
    '484110': ('clone_dwb', {'S': 3847, 'P1': 5560864, 'P2': 5560908, 'N': 961, 'P3': 5560936}),
    '487bd7': ('clone_dwb', {'S': 1459, 'P1': 5561736, 'P2': 5561780, 'N': 364, 'P3': 5561808}),
    '48a865': ('clone_dwb', {'S': 1051, 'P1': 5563108, 'P2': 5563152, 'N': 262, 'P3': 5563180}),
    '48d12d': ('clone_dwb', {'S': 1979, 'P1': 5564436, 'P2': 5564480, 'N': 494, 'P3': 5564508}),
    '493b7a': ('clone_dw', {'S': 198, 'P1': 5568388, 'P2': 5568432, 'N': 49, 'P3': 5568460}),
    '4a3a33': ('clone_db', {'S': 1729, 'P1': 5571824, 'P2': 5571868, 'N': 432, 'P3': 5571896}),
    '4a64b9': ('clone_dwb', {'S': 983, 'P1': 5572848, 'P2': 5572892, 'N': 245, 'P3': 5572920}),
    '4a7e50': ('clone_d', {'S': 1100, 'P1': 5573420, 'P2': 5573464, 'N': 275, 'P3': 5573492}),
    '4ab46d': ('clone_dwb', {'S': 3007, 'P1': 5574464, 'P2': 5574508, 'N': 751, 'P3': 5574536}),
    '4acbf1': ('clone_dw', {'S': 826, 'P1': 5575000, 'P2': 5575044, 'N': 206, 'P3': 5575072}),
    '4afe09': ('clone_d', {'S': 892, 'P1': 5576424, 'P2': 5576468, 'N': 223, 'P3': 5576496}),
    '4b3ddf': ('clone_dw', {'S': 2222, 'P1': 5576928, 'P2': 5576972, 'N': 555, 'P3': 5577000}),
    '4b72cf': ('clone_dw', {'S': 966, 'P1': 5577688, 'P2': 5577732, 'N': 241, 'P3': 5577760}),
    '4b80d9': ('clone_dw', {'S': 1390, 'P1': 5578036, 'P2': 5578080, 'N': 347, 'P3': 5578108}),
    '4ba2bd': ('clone_dw', {'S': 2786, 'P1': 5578460, 'P2': 5578504, 'N': 696, 'P3': 5578532}),
    '4e9a2c': ('clone_dw', {'S': 114, 'P1': 5621680, 'P2': 5621724, 'N': 28, 'P3': 5621752}),
    '4e9add': ('clone_s2', {'S': 2, 'P1': 5621812, 'P2': 5621856, 'P3': 5621884}),
    '4e9b87': ('clone_s4', {'S': 4, 'P1': 5621944, 'P2': 5621988, 'P3': 5622016}),
    '4e9cdf': ('clone_s6', {'S': 6, 'P1': 5622196, 'P2': 5622240, 'P3': 5622268}),
    '4fcda1': ('clone_exit', {'S': 22, 'P1': 5638640, 'P2': 5638684, 'N': 5, 'P3': 5638712}),
}

GEN = {'clone_dwb': gen_clone_dwb, 'clone_dw': gen_clone_dw, 'clone_db': gen_clone_db, 'clone_d': gen_clone_d, 'clone_s2': gen_clone_s2, 'clone_s4': gen_clone_s4, 'clone_s6': gen_clone_s6, 'clone_exit': gen_clone_exit}
COUNTS = {'clone_dwb': 30, 'clone_dw': 30, 'clone_db': 30, 'clone_d': 30, 'clone_s2': 30, 'clone_s4': 30, 'clone_s6': 30, 'clone_exit': 30}
KIND_NAMES = {'clone_dwb': 'clone_record', 'clone_dw': 'clone_record', 'clone_db': 'clone_record', 'clone_d': 'clone_record', 'clone_s2': 'clone_record', 'clone_s4': 'clone_record', 'clone_s6': 'clone_record', 'clone_exit': 'clone_record'}
SPECFLAGS = {'484110': {'cleanup': 12}, '487bd7': {'cleanup': 12}, '48a865': {'cleanup': 12}, '48d12d': {'cleanup': 12}, '493b7a': {'cleanup': 12}, '4a3a33': {'cleanup': 12}, '4a64b9': {'cleanup': 12}, '4a7e50': {'cleanup': 12}, '4ab46d': {'cleanup': 12}, '4acbf1': {'cleanup': 12}, '4afe09': {'cleanup': 12}, '4b3ddf': {'cleanup': 12}, '4b72cf': {'cleanup': 12}, '4b80d9': {'cleanup': 12}, '4ba2bd': {'cleanup': 12}, '4e9a2c': {'cleanup': 12}, '4e9add': {'cleanup': 12}, '4e9b87': {'cleanup': 12}, '4e9cdf': {'cleanup': 12}, '4fcda1': {'cleanup': 12}}
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
