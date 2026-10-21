"""FL-34 (batch c): the fixtures shared by tests/test_fl34c_differential.py and tests/fl34c_original_oracle.py.

Same shape as tests/fl32b_fixtures.py (the generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the eight spill rows of FL-32 listed in SPECS: the object
`this`, the globals and tables the function reads (patched into the image), the scripted callees (recording stubs at the call boundary, entered by address) and the world
words the function writes. The scenarios cycle through profiles (each branch and each scripted answer in turn); the optional parts vary from one pass of the cycle to the next;
random bytes fill everything else. Several profiles make a callee change what the function reads or writes afterwards (a scripted write at the call), which shows a read or a
store on the wrong side of the call.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (OS or host boundaries); nothing inside the function under test is patched.
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
SELF_TOKEN = 0x5e1f5e1f      # what the shim reports when a port returned `self` (callee answers are never this value or the fake address of `this`)


def parse_world():
    """The fields of Fl34cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl34c.h').read_text()
    body = re.search(r'typedef struct Fl34cWorld \{(.*?)\} Fl34cWorld;', text, re.S).group(1)
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
RESULTS = [0, 1, 0x80000000, 0xffffffff, 0xdeadbeef, 0x10000, 0x100, 0xffff, 0xff000000]


def result_value(rng):
    """A scripted callee answer: never the self token nor the fake address of `this`, so that 'returned self' is unambiguous."""
    v = rng.choice([*RESULTS, rng.randrange(1 << 32)])
    return v + 1 if v in (SELF_TOKEN, od.region_va(0)) else v


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
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the function did not return this')
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


def self_va(off=0):
    return od.region_va(0) + off


# ---- 0x4d0abc, 0x4d0c17, 0x4e01fb -------------------------------------------------------------------------------------------------

# (first global, constant pushed, cleared word) of each row; the three dwords are at g, g + 4, g + 8
POST = {'4d0abc': (0x5d2a1f, 0x55a05c, 'word_63a97c'), '4d0c17': (0x5d2bdb, 0x55a0e8, 'word_63a97e'), '4e01fb': (0x5d2819, 0x55ba9c, 'word_63a9d0')}
GLOBAL_PATTERNS = [None, b'\x00' * 12, b'\xff' * 12]


def gen_post(key, rng, n):
    g1, text, clear = POST[key]
    profiles = [('plain',)] * 3 + [('mutate',)] * 3
    (kind,), variant = prof(n, profiles)
    glob = bytearray(rng.randbytes(20))                                    # g1 - 4 .. g1 + 16: the three dwords and one dword of slack on each side
    pattern = GLOBAL_PATTERNS[variant % 3]
    if pattern is not None:
        glob[4:16] = pattern
    cf = bytearray(rng.randbytes(12))                                      # 0x5cf665 - 4 .. + 8
    writes = []
    if kind == 'mutate':                                                   # the callee changes every global that the function read: they were read before the call
        writes = [(0, -1, g1 + 4 * i, 4, rng.randrange(1 << 32)) for i in range(3)] + [(0, -1, 0x5cf665, 4, rng.randrange(1 << 32))]
    g = {name: rng.choice([0, 2, 0xffff, rng.randrange(0x10000)]) for name in GLOBALS}
    probe = [('g:word_5bb1c4', 0, 2), ('g:' + clear, 0, 2)]                # the stores come after the call
    stubs = {0x4c5377: stub(0x4c5377, THISCALL(5), results=[result_value(rng)], probe=probe, writes=writes)}
    return make(key, [Area('glob', g1 - 4, glob, image=True), Area('cf', 0x5cf661, cf, image=True)], stubs, g, [], (), (kind, variant))


def gen_4d0abc(rng, n):
    return gen_post('4d0abc', rng, n)


def gen_4d0c17(rng, n):
    return gen_post('4d0c17', rng, n)


def gen_4e01fb(rng, n):
    return gen_post('4e01fb', rng, n)


# ---- 0x4cca9c ---------------------------------------------------------------------------------------------------------------------

DW = [0, 1, 0xffffffff, 0x80000000, 0xdeadbeef, 0x10000, 0xff]
REC_OFFSETS = [0x40, 0x100, 0, 0x3d4, 0x13, 0x14]          # where `rec` lies inside the 0x400-byte object: 0 and 0x14 alias `self`, 0x13 is unaligned


def gen_4cca9c(rng, n):
    profiles = [('plain', off, w) for off in REC_OFFSETS for w in (0, 1)]
    (kind, roff, writes_on), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x400))
    if variant % 2:
        s = bytearray(b'\xa5' * 0x400)
    rec = self_va(roff)
    a = [rng.choice([*DW, rng.randrange(1 << 32)]) for _ in range(3)]
    a = [v + 1 if v in (SELF_TOKEN, od.region_va(0)) else v for v in a]
    writes = [(0, 0, off, 4, rng.randrange(1 << 32)) for off in (0, 0x14, 0x28)] if writes_on else []      # the callee clobbers the three fields: the stores come after it
    stubs = {0x4cc962: stub(0x4cc962, THISCALL(1), results=[result_value(rng)], probe=[('self', 0, 0x400)], writes=writes)}
    args = (rec, *a)
    return make('4cca9c', [self_area(s)], stubs, {}, list(args), args, (kind, roff, writes_on, variant))


# ---- 0x446f77 ---------------------------------------------------------------------------------------------------------------------


def gen_446f77(rng, n):
    profiles = [('plain',), ('callee_writes',)]
    (kind,), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x100))
    if variant % 2:
        s = bytearray(b'\xa5' * 0x100)
    writes = []
    if kind == 'callee_writes':          # the real callee stores 1 at [this + 4]; the scripted one also dirties the fields that the function writes afterwards
        writes = [(0, -1, self_va(off), 4, v) for off, v in ((0, 0x11223344), (4, 1), (0x31, 0x55667788), (0x35, 0x99aabbcc))]
    stubs = {0x51d716: stub(0x51d716, THISCALL(0), results=[result_value(rng)], probe=[('self', 0, 0x40)], writes=writes)}
    return make('446f77', [self_area(s)], stubs, {}, [], (), (kind, variant))


# ---- 0x4fce5e ---------------------------------------------------------------------------------------------------------------------

REC_VA = 0x5bb5e5
INDICES = [0, 1, 2, 3, 0x7f, 0x80, 0x100, 100, 4000, -1, -2, -3, -100, -1000, -12000]       # all addresses inside the image; -5446 would hit the function itself


def gen_4fce5e(rng, n):
    profiles = [('idx', i) for i in INDICES]
    (kind, idx), variant = prof(n, profiles)
    at = REC_VA + idx * 0x8d
    data = bytearray(rng.randbytes(16))                                    # at - 8 .. at + 8: one dword of slack on each side
    word = idx & 0xffff
    high = rng.choice([0, 0xffff, rng.randrange(0x10000), 0x8000]) if variant else 0          # the high half of the pushed dword is ignored (movsx of the word)
    arg = (high << 16) | word
    stubs = {0x4f7e93: stub(0x4f7e93, THISCALL(1), results=[result_value(rng)])}
    return make('4fce5e', [Area('rec', at - 8, data, image=True)], stubs, {}, [arg], (arg,), (kind, idx, variant))


# ---- 0x4d3ffe ---------------------------------------------------------------------------------------------------------------------

FLAG_VA = 0x61c6ae


def gen_4d3ffe(rng, n):
    profiles = [('flag', v, c) for v in (0, 1, 0x80, 0xff, 0, 0x7f) for c in ('none', 'to_zero', 'to_nonzero')]
    (kind, v, callee), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x500))
    if variant % 2:
        s = bytearray(b'\xa5' * 0x500)
    flag = bytearray(rng.randbytes(16))                                    # FLAG_VA - 8 .. + 8: the neighbouring bytes are non-zero (a wider read of the flag shows)
    for i in range(16):
        if flag[i] == 0:
            flag[i] = 1
    if variant % 3 == 2:
        flag[8 + 1:8 + 4] = b'\x00\x00\x00'                                # a pass with zero bytes behind the flag as well
    flag[8] = v
    writes = [(0, -1, self_va(off), 4, rng.randrange(1, 1 << 32)) for off in (0x440, 0x462, 0x1c)]      # the callee dirties the three fields
    if callee == 'to_zero':
        writes.append((0, -1, FLAG_VA, 1, 0))
    elif callee == 'to_nonzero':
        writes.append((0, -1, FLAG_VA, 1, rng.choice([1, 0x80, 0xff])))
    stubs = {0x4dad60: stub(0x4dad60, THISCALL(0), results=[result_value(rng)], probe=[('self', 0x18, 8), ('self', 0x438, 0x30)], writes=writes)}
    return make('4d3ffe', [self_area(s), Area('flag', FLAG_VA - 8, flag, image=True)], stubs, {}, [], (), (kind, v, callee, variant))


# ---- 0x47a3d9 ---------------------------------------------------------------------------------------------------------------------


def gen_47a3d9(rng, n):
    answers = [0, 1, 0x10000, 0x80000000, 0xffffffff, 0x100, 0xffff, 0xff000000, 0xdeadbeef]
    profiles = [('x', x, w) for x in answers for w in (0, 1)]
    (kind, x, writes_on), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x1800))
    if variant % 2:
        s = bytearray(b'\xa5' * 0x1800)
    writes = [(0, -1, self_va(off), 4, rng.randrange(1 << 32)) for off in (0x1576, 0x24)] if writes_on else []     # the callee dirties the two fields
    stubs = {0x4789d6: stub(0x4789d6, THISCALL(0), results=[x], probe=[('self', 0x1c, 0x10), ('self', 0x1570, 0x10)], writes=writes)}
    return make('47a3d9', [self_area(s)], stubs, {}, [], (), (kind, x, writes_on, variant))


# GEN-END

SPECS = {
    '4d0abc': dict(id=1, va=0x4d0abc, size=64, gen=gen_4d0abc, cleanup=0, ret=True, n=12),
    '4d0c17': dict(id=2, va=0x4d0c17, size=64, gen=gen_4d0c17, cleanup=0, ret=True, n=12),
    '4e01fb': dict(id=3, va=0x4e01fb, size=64, gen=gen_4e01fb, cleanup=0, ret=True, n=12),
    '4cca9c': dict(id=4, va=0x4cca9c, size=51, gen=gen_4cca9c, cleanup=0x10, ret=True, ptr_args=(0,), n=12 * 3),
    '446f77': dict(id=5, va=0x446f77, size=51, gen=gen_446f77, cleanup=0, ret=True, retself=True, n=8),
    '4fce5e': dict(id=6, va=0x4fce5e, size=50, code=48, gen=gen_4fce5e, cleanup=4, ret=True, n=len(INDICES) * 2),
    '4d3ffe': dict(id=7, va=0x4d3ffe, size=69, gen=gen_4d3ffe, cleanup=0, ret=True, n=18 * 3),
    '47a3d9': dict(id=8, va=0x47a3d9, size=61, gen=gen_47a3d9, cleanup=0, ret=True, n=18 * 3),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'4d0abc': 'post_message', '4d0c17': 'post_message', '4e01fb': 'post_message', '4cca9c': 'fill_record', '446f77': 'construct', '4fce5e': 'call_with_record_dword',
         '4d3ffe': 'start_flag', '47a3d9': 'set_flags',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
