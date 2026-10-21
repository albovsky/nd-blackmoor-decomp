"""FL-38 (batch b): the fixtures shared by tests/test_fl38b_differential.py and tests/fl38b_original_oracle.py.

Same shape as tests/fl36f_fixtures.py (the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub constructor,
the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the "clone a record" functions of ROWS: three dword cells (out, in2, adv), a source
buffer, a destination buffer (the block the scripted allocator returns), the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios
cycle through profiles (the debug word values, unaligned cells and buffers, the cells aliasing each other, overlapping source and destination, a wrapping advance, and the failed allocation).

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (host boundaries); nothing inside the function under test is patched. The callee
0x4c97b4 (called when the allocation failed) posts WM_QUIT and returns, after which the original faults copying into address 0; its stub stops the run there (`halt`), and the native port stops at the same call and returns 1
(`partial`: the calls up to and including it are compared and every byte of every area except the three cells must be unchanged).
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
from fl28b_fixtures import (Original27, stub, CDECL, THISCALL, Area, put32, normalize, conditional_edges, FMT, debug_areas)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl38bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl38b.h').read_text()
    found = re.search(r'typedef struct Fl38bWorld \{(.*?)\} Fl38bWorld;', text, re.S)
    body = re.sub(r'/\*.*?\*/', '', found.group(1), flags=re.S)
    fields = []
    for decl in body.split(';'):
        decl = decl.strip().replace('const ', '')
        if not decl:
            continue
        kind, _, names = decl.partition(' ')
        for name in names.split(','):
            fields.append((name.strip(), CTYPES[kind], False))
    return fields


WORLD_FIELDS = parse_world()


class World(ctypes.Structure):
    _fields_ = [(n, t) for n, t, _ in WORLD_FIELDS]


GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t, p in WORLD_FIELDS if not p}


class Original38b(Original27):
    """Original27 whose stub with `halt` set stops the run there (0x4c97b4 really returns, then the original faults copying into address 0; behaviour after the call is not modelled)."""
    halted = False

    def _stub_hook(self, uc, address, size, user):
        super()._stub_hook(uc, address, size, user)
        if getattr(self.stubs[address], 'halt', False):
            self.halted = True
            uc.reg_write(self._r['EIP'], od.STOP)


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
    runner = Original38b(image_patches, regions, sc.stubs, {})
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if runner.halted != (sc.partial is not None):
        raise AssertionError('the failure-branch callee 0x4c97b4 was %sreached' % ('not ' if sc.partial is not None else ''))
    if not runner.halted and orig.cleanup != 0xc:
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, {}, {})
    h = hashlib.sha256()
    h.update(repr(calls).encode())
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


# ---- the rows: key -> the constants read from the disassembly of the row ----------------------------------------------------------------

ROWS = {
    '44d1d1': dict(S=0x2fb, fmt=0x549538, msg=0x549564, dbg=0x549580, shape='a', size=187),
    '456fb6': dict(S=0x27b, fmt=0x54a330, msg=0x54a35c, dbg=0x54a378, shape='a', size=187),
    '45807c': dict(S=0x663, fmt=0x54a578, msg=0x54a5a4, dbg=0x54a5c0, shape='a', size=187),
    '464100': dict(S=0x43f, fmt=0x54b2c0, msg=0x54b2ec, dbg=0x54b308, shape='a', size=187),
    '465bde': dict(S=0x55f, fmt=0x54b4d0, msg=0x54b4fc, dbg=0x54b518, shape='a', size=187),
    '46b79a': dict(S=0x6e3, fmt=0x54bc84, msg=0x54bcb0, dbg=0x54bccc, shape='a', size=187),
    '47314b': dict(S=0x4ff, fmt=0x54c5a0, msg=0x54c5cc, dbg=0x54c5e8, shape='a', size=187),
    '4782db': dict(S=0x29b, fmt=0x54cb10, msg=0x54cb3c, dbg=0x54cb58, shape='a', size=187),
    '475964': dict(S=0x7f2, fmt=0x54c7cc, msg=0x54c7f8, dbg=0x54c814, shape='b', size=186),
    '44fbe3': dict(S=0x4e8, fmt=0x54991c, msg=0x549948, dbg=0x549964, shape='c', size=184),
    '467688': dict(S=0x408, fmt=0x54b7d8, msg=0x54b804, dbg=0x54b820, shape='c', size=184),
    '468f9f': dict(S=0x5d8, fmt=0x54b974, msg=0x54b9a0, dbg=0x54b9bc, shape='c', size=184),
    '47e477': dict(S=0xa34, fmt=0x54d474, msg=0x54d4a0, dbg=0x54d4bc, shape='c', size=184),
    '44e8a2': dict(S=0x269, fmt=0x5497a8, msg=0x5497d4, dbg=0x5497f0, shape='d', size=185),
    '454e70': dict(S=0xd01, fmt=0x549fbc, msg=0x549fe8, dbg=0x54a004, shape='d', size=185),
    '459c10': dict(S=0x2b1, fmt=0x54a74c, msg=0x54a778, dbg=0x54a794, shape='d', size=185),
    '45ddd0': dict(S=0x1346, fmt=0x54aeb8, msg=0x54aee4, dbg=0x54af00, shape='e', size=186),
    '47b3f0': dict(S=0x16c2, fmt=0x54cdd4, msg=0x54ce00, dbg=0x54ce1c, shape='e', size=186),
}

BUF = 0x1800 + 0x80        # the largest size of any row is 0x16c2; the buffers hold size + slack
CELLS = 0x40
DBG_WORDS = [0, 1, 0x8000, 0x100, 0xffff]
# (kind, variant): normal (dbg value index, cell offset 0/1, source offset, destination offset), alias_*, overlap (destination = source + k), wrap, fail (dword, word)
PROFILES = ([('normal', d, 0, 0, 0) for d in range(5)] + [('normal', 0, 1, 1, 2), ('normal', 1, 0, 3, 1), ('normal', 3, 1, 0, 3)]
            + [('alias_adv_src', 0), ('alias_out_src', 1), ('alias_out_adv', 3)]
            + [('overlap', k) for k in (1, 2, 3, 5, -1, -3)] + [('wrap', 0), ('wrap', 2)]
            + [('fail', 0x12345678, 0x8000, 1), ('fail', 0xffffffff, 0x7fff, 0), ('fail', 0, 0xffff, 2), ('fail', 0xa5a5a5a5, 0x0001, 4)])
PER_ROW = len(PROFILES)


def gen(key, rng, n):
    c = ROWS[key]
    S = c['S']
    prof = PROFILES[n % PER_ROW]
    kind = prof[0]
    word_g = lambda rng: rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(1 << 16)])
    g = {'dword_5bb57b': rng.choice([0xffffffff, 0xa5a5a5a5, rng.randrange(1, 1 << 32)]), 'word_5c39e3': word_g(rng), 'word_63a4cd': 0}
    cells = bytearray(rng.randbytes(CELLS))
    src = bytearray(rng.randbytes(BUF))
    dst = bytearray(rng.randbytes(BUF))
    cell_base, src_base, dst_base = od.region_va(0), od.region_va(1), od.region_va(2)
    co = 0x10 + (prof[2] if kind == 'normal' else n // PER_ROW % 2)
    out_c, src_c, adv_c = cell_base + co, cell_base + co + 0x10, cell_base + co + 0x20
    so, do = (prof[3], prof[4]) if kind == 'normal' else (4 + n // PER_ROW % 4, 1 + n // PER_ROW % 3)
    p = dst_base + do
    srcptr = src_base + so
    advv = rng.randrange(1 << 32)
    stack_cells = [out_c, src_c, adv_c]
    partial = None
    if kind == 'normal':
        g['word_63a4cd'] = DBG_WORDS[prof[1]]
    elif kind == 'alias_adv_src':
        g['word_63a4cd'] = DBG_WORDS[prof[1]]
        stack_cells = [out_c, src_c, src_c]
    elif kind == 'alias_out_src':
        g['word_63a4cd'] = DBG_WORDS[prof[1]]
        stack_cells = [src_c, src_c, adv_c]
    elif kind == 'alias_out_adv':
        g['word_63a4cd'] = DBG_WORDS[prof[1]]
        stack_cells = [adv_c, src_c, adv_c]
    elif kind == 'overlap':
        k = prof[1]
        srcptr = src_base + 8
        p = srcptr + k
        g['word_63a4cd'] = DBG_WORDS[n // PER_ROW % 5]
    elif kind == 'wrap':
        advv = rng.choice([0xffffffff, 0xfffffff0, (1 << 32) - S, (1 << 32) - S + 1])
        g['word_63a4cd'] = DBG_WORDS[prof[1]]
    elif kind == 'fail':
        _, g['dword_5bb57b'], g['word_5c39e3'], dbgi = prof
        g['word_63a4cd'] = DBG_WORDS[dbgi]
        p = 0
        partial = (4, {'cells': CELLS})
    put32(cells, co + 0x10, srcptr)
    put32(cells, co + 0x20, advv)
    if kind == 'alias_out_src':
        put32(cells, co + 0x10, srcptr)
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[p]), 0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x42639d: stub(0x42639d, THISCALL(2)),
             0x4c97b4: stub(0x4c97b4, THISCALL(0)), 0x44a2b7: stub(0x44a2b7, CDECL(1))}
    stubs[0x4c97b4].halt = True
    dbg_g, dbg_areas = debug_areas(rng, g['word_63a4cd'])
    areas = [Area('cells', cell_base, cells, image=False), Area('src', src_base, src, image=False), Area('dst', dst_base, dst, image=False), *dbg_areas]
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp['size'], areas=areas, stubs=stubs, iat={}, g=g, ecx=od.region_va(5) + 0x123, pointers={},
                           word_args={}, profile=prof, stack=stack_cells, args=tuple(stack_cells), seh=None, partial=partial, fault=None)


SPECS = {}
NAMES = {}
for _i, (_k, _c) in enumerate(ROWS.items()):
    SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=_c['size'], n=PER_ROW * 2, cleanup=0xc)
    NAMES[_k] = 'clone_record'
KEYS = list(SPECS)


def build(key, rng, n):
    return gen(key, rng, n)


def scenarios(key):
    return SPECS[key]['n']
