"""FL-31 (batch b): the fixtures shared by tests/test_fl31b_differential.py and tests/fl31b_original_oracle.py.

Same shape as tests/fl29a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the
addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The scenarios cycle through profiles
(each guard failing in turn, then every arm and every scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes fill everything
else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the imports are recording stubs (OS or host boundaries); nothing inside the function under
test is patched. The import GetCursorPos (slot 0x52a484) is a stub with scripted WRITES (it stores two dwords through its pointer argument, as the OS does).
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
    """The fields of Fl31bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl31b.h').read_text()
    body = re.search(r'typedef struct Fl31bWorld \{(.*?)\} Fl31bWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4d3992: (0,)}       # 0x47d59b pushes a word with stale upper half (mov dx, word; push edx): compared by its low 16 bits
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
DBG_VALUES = (0, 1, 0x8000, 0x100, 0xffff)       # the debug word 0x63a4cd: every non-zero value is on
WORDS_OTHER = [0, 1, 0x7fff, 0x8000, 0xfffe, 0x1234, 0xff00, 0x00ff]


def make(key, areas, stubs, g, stack, args, profile, iat=None, pointers=None, self_off=0):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) + self_off, self_off=self_off, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None, partial=None)


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


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests): none for this batch
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


def debug_area(rng):
    """The two bytes behind the debug word 0x63a4cd: a dword read of it would see them (not compared)."""
    return Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)


# ---- 0x4c946b ---------------------------------------------------------------------------------------------------------------------

SLOT_INDICES = [-0x2000, -0x1000, -3, -2, -1, 0, 1, 2, 5, 0x7f, 0x1000, 0x1800]


def gen_4c946b(rng, n):
    (idx,), variant = prof(n, [(i,) for i in SLOT_INDICES])
    s = bytearray(rng.randbytes(0x10000))       # self sits at +0x8000 of this area: the slot address (self + 0xc72 + index * 4) is inside it for every index of the list
    stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=[('self', 0, 0x40)])}
    a = word_arg(rng, idx)
    return make('4c946b', [self_area(s)], stubs, {}, [a], (a,), (idx,), self_off=0x8000)


# ---- 0x4ee673 ---------------------------------------------------------------------------------------------------------------------


def gen_4ee673(rng, n):
    (kind, *rest), variant = prof(n, [('zero',)] + [('set', v) for v in NONZERO])
    s = bytearray(rng.randbytes(0x600))
    if kind == 'zero':          # the neighbours are non-zero: only the dword at +0x252 is looked at
        put32(s, 0x252, 0)
        put32(s, 0x24e, rng.choice(NONZERO))
        put32(s, 0x256, rng.choice(NONZERO))
        put16(s, 0x24c, rng.choice([1, 0xffff]))
        put16(s, 0x25a, rng.choice([1, 0xffff]))
    else:
        put32(s, 0x252, rest[0])
    stubs = {0x4ef4f0: stub(0x4ef4f0, THISCALL(1), probe=[('self', 0x240, 0x30)])}
    stack = [rng.randrange(1 << 32)]
    return make('4ee673', [self_area(s)], stubs, {}, stack, tuple(stack), (kind, *rest))


# ---- 0x4daeb5 ---------------------------------------------------------------------------------------------------------------------

CURSOR = [0, 1, 0x7fff, 0x80000000, 0xffffffff, 0x12345678, 0xfffffff0]


def gen_4daeb5(rng, n):
    (kind, *rest), variant = prof(n, [('apart', i) for i in range(len(CURSOR))] + [('overlap', d) for d in (2, 4, -4, 0x18, 0x1a, 0x1c, 0x14)])
    x = CURSOR[(rest[0] + variant) % len(CURSOR)] if kind == 'apart' else rng.randrange(1 << 32)
    y = CURSOR[(rest[0] * 3 + 1 + variant) % len(CURSOR)] if kind == 'apart' else rng.randrange(1 << 32)
    s = bytearray(rng.randbytes(0x100))
    out = bytearray(rng.randbytes(0x20))
    out_va = od.region_va(1) + 8 if kind == 'apart' else od.region_va(0) + 0x18 + rest[0]       # 'overlap': the pair lands inside self, over the two dwords just stored
    writes = [(0, 0, 0, 4, x), (0, 0, 4, 4, y)]
    iat = {0x52a484: stub(0x52a484, STDCALL(1), writes=writes)}
    areas = [self_area(s)] + ([Area('out', od.region_va(1), out, image=False)] if kind == 'apart' else [])
    return make('4daeb5', areas, {}, {}, [out_va], (out_va,), (kind, *rest), iat=iat)


# ---- 0x4dadff ---------------------------------------------------------------------------------------------------------------------

KEY_RESULTS = [0x8000, 0, 0x7fff, 0xffff, 0x18000, 0x10000, 0xffff8000, 0x00018001, 0x4000, 0x8001]


def gen_4dadff(rng, n):
    (r1, r2), variant = prof(n, [(a, b) for a in KEY_RESULTS for b in KEY_RESULTS])
    s = bytearray(rng.randbytes(0x80))
    g = {'byte_58321d': [0, 1, 0xff, 0x80][variant % 4], 'byte_58321e': [1, 0, 0x7f, 0xff][(variant + n) % 4]}
    iat = {0x52a4b4: stub(0x52a4b4, STDCALL(1), probe=[('g:byte_58321d', 0, 1), ('g:byte_58321e', 0, 1)], results=[r1, r2])}
    return make('4dadff', [self_area(s)], {}, g, [], (), (hex(r1), hex(r2)), iat=iat)


# ---- 0x420b9e ---------------------------------------------------------------------------------------------------------------------

TBL_LO, TBL_HI = -4, 4
WORD_PAIRS = [(-4, 4), (4, -4), (0, -1), (-1, 0), (1, 3), (3, -2), (2, 2), (-3, 1)]


def gen_420b9e(rng, n):
    (flag, pair), variant = prof(n, [(f, p) for f in [0, *NONZERO] for p in WORD_PAIRS])
    s = bytearray(rng.randbytes(0x1000))
    put16(s, 0xf73, pair[0])
    put16(s, 0xf75, pair[1])
    tbl = Area('tbl', 0x5d02cb + TBL_LO * 4, bytearray(rng.randbytes((TBL_HI - TBL_LO + 1) * 4)), image=True)
    g = {'dword_5b15da': flag, 'dword_5d03af': rng.randrange(1 << 32)}
    stubs = {0x4c51a5: stub(0x4c51a5, THISCALL(5))}
    return make('420b9e', [self_area(s), tbl], stubs, g, [], (), (hex(flag), pair), pointers={'table_5d02cb': ('tbl', -TBL_LO * 4)})


# ---- 0x47d1c3 ---------------------------------------------------------------------------------------------------------------------

BUF_VA = od.region_va(2)
SIZES = [0, 1, 2, 3, 4, 5, 7, 8, 0x10, 0x11, 0x40, 0x41, 0x5f]


def gen_47d1c3(rng, n):
    (kind, *rest), variant = prof(n, [('null', d) for d in DBG_VALUES] + [('ok', sz) for sz in SIZES])
    out = bytearray(rng.randbytes(0x20))
    buf = bytearray(rng.randbytes(0x100))
    for i in range(len(buf)):          # non-zero filler, so that a missed zero is visible
        if buf[i] == 0:
            buf[i] = 1 + i % 255
    off = [0, 1, 3, 0x20][variant % 4]
    size = rest[0] if kind == 'ok' else rng.choice(SIZES)
    dbg = rest[0] if kind == 'null' else DBG_VALUES[variant % len(DBG_VALUES)]
    result = 0 if kind == 'null' else BUF_VA + off
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[result]), 0x50ca3e: stub(0x50ca3e, CDECL(2)), 0x4264e8: stub(0x4264e8, THISCALL(1)),
             0x44a2b7: stub(0x44a2b7, CDECL(1)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}
    cell = od.region_va(1) + 8
    stack = [cell, size]
    areas = [Area('out', od.region_va(1), out, image=False), Area('buf', BUF_VA, buf, image=False), debug_area(rng)]
    return make('47d1c3', areas, stubs, {'word_63a4cd': dbg}, stack, tuple(stack), (kind, *rest, dbg))


# ---- 0x4fc878 ---------------------------------------------------------------------------------------------------------------------

REC = 0x5bb


FAR_INDICES = (0x8000, 0x8001, 0xffff)       # bit 15 of the record index: the index is unsigned (0x8000 * 0x5bb is 48 MB, 0xffff * 0x5bb is 96 MB)


def gen_4fc878(rng, n):
    near = [('near', d, i, w) for d in DBG_VALUES for i in (0, 1, 2, 3, 6) for w in (1, 0, 2, 0xffff, 0x8001, 3, 0x0100)]
    far = [('far', d, i, w) for d in (1, 0x8000) for i in FAR_INDICES for w in (1, 0)]
    (kind, dbg, idx, word), variant = prof(n, near + far)
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3)), 0x44a2b7: stub(0x44a2b7, CDECL(1))}
    a = word_arg(rng, idx)
    if kind == 'far':
        # the object would be 48 to 96 MB: the fixture maps only the 0x200 bytes around the record word (area offset 0x40) and puts `this` (ecx) where
        # this + idx * 0x5bb + 0x132 is that word, so the original (Unicorn) and the native port both address it by the full unsigned index
        s = bytearray(rng.randbytes(0x200))
        put16(s, 0x40, word)
        if variant % 2:
            put16(s, 0x42, rng.choice([0xffff, 1, 0x8000]))
        stubs[0x4f61e7] = stub(0x4f61e7, THISCALL(1), probe=[('self', 0x40, 2)])
        return make('4fc878', [self_area(s), debug_area(rng)], stubs, {'word_63a4cd': dbg}, [a], (a,), (kind, hex(dbg), hex(idx), hex(word)),
                    self_off=0x40 - 0x132 - idx * REC)
    s = bytearray(rng.randbytes(0x4000))
    for r in range(8):                  # the same word of every other record is 1 (or 2): a wrong record or a wrong stride is seen
        put16(s, r * REC + 0x132, rng.choice([1, 1, 2, 0]))
    put16(s, idx * REC + 0x132, word)
    if variant % 2:                     # the word after it: a dword compare would see it
        put16(s, idx * REC + 0x134, rng.choice([0xffff, 1, 0x8000]))
    off = idx * REC + 0x132
    stubs[0x4f61e7] = stub(0x4f61e7, THISCALL(1), probe=[('self', off, 2)])
    return make('4fc878', [self_area(s), debug_area(rng)], stubs, {'word_63a4cd': dbg}, [a], (a,), (kind, hex(dbg), idx, hex(word)))


# ---- 0x47d4f7 ---------------------------------------------------------------------------------------------------------------------


def gen_47d4f7(rng, n):
    (fill,), variant = prof(n, [('random',), ('ff',), ('zero',), ('a5',)])
    s = {'random': bytearray(rng.randbytes(0x100)), 'ff': bytearray(b'\xff' * 0x100), 'zero': bytearray(0x100), 'a5': bytearray(b'\xa5' * 0x100)}[fill]
    return make('47d4f7', [self_area(s)], {}, {}, [], (), (fill,))


# ---- 0x47d59b ---------------------------------------------------------------------------------------------------------------------


def gen_47d59b(rng, n):
    (mask,), variant = prof(n, [(m,) for m in range(32)])
    s = bytearray(rng.randbytes(0x100))
    for bit, off in enumerate((0x1f, 0x49, 0x4d, 0x51)):
        put32(s, off, NONZERO[(variant + 3 * bit + mask) % len(NONZERO)] if (mask >> bit) & 1 else 0)
    put16(s, 0x23, WORDS_OTHER[(variant + mask) % len(WORDS_OTHER)] if (mask >> 4) & 1 else 0xffff)
    probe = [('self', 0, 0x60)]
    stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=probe), 0x51dc6c: stub(0x51dc6c, CDECL(1), probe=probe), 0x4d3992: stub(0x4d3992, CDECL(1), probe=probe),
             0x47d4f7: stub(0x47d4f7, THISCALL(0), probe=probe)}
    return make('47d59b', [self_area(s)], stubs, {}, [], (), (mask,))


SPECS = {
    '4c946b': dict(id=1, va=0x4c946b, size=36, gen=gen_4c946b, cleanup=4, n=12 * 3),
    '4ee673': dict(id=2, va=0x4ee673, size=43, gen=gen_4ee673, cleanup=4, n=9 * 4),
    '4daeb5': dict(id=3, va=0x4daeb5, size=60, gen=gen_4daeb5, cleanup=4, ret=True, n=14 * 4),
    '4dadff': dict(id=4, va=0x4dadff, size=103, gen=gen_4dadff, cleanup=0, n=100 * 2),
    '420b9e': dict(id=5, va=0x420b9e, size=121, gen=gen_420b9e, cleanup=0, n=72 * 2),
    '47d1c3': dict(id=6, va=0x47d1c3, size=139, gen=gen_47d1c3, cleanup=8, n=18 * 8),
    '4fc878': dict(id=7, va=0x4fc878, size=145, gen=gen_4fc878, cleanup=4, n=187 * 2),
    '47d4f7': dict(id=8, va=0x47d4f7, size=164, gen=gen_47d4f7, cleanup=0, n=4 * 3),
    '47d59b': dict(id=9, va=0x47d59b, size=165, gen=gen_47d59b, cleanup=0, n=32 * 3),
}
KEYS = list(SPECS)
NAMES = {'4c946b': 'call_slot', '4ee673': 'forward_if_set', '4daeb5': 'read_cursor', '4dadff': 'poll_keys', '420b9e': 'report_name', '47d1c3': 'alloc_zeroed',
         '4fc878': 'activate_record', '47d4f7': 'reset_fields', '47d59b': 'release_fields'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
