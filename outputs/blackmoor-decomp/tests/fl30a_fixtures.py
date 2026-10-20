"""FL-30 (batch a): the fixtures shared by tests/test_fl30a_differential.py and tests/fl30a_original_oracle.py.

Same shape as tests/fl28b_fixtures.py (whose generic harness pieces are imported: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object
`this`, the objects behind the addresses it keeps, the vtables, the scripted callees (recording stubs at the call boundary, entered by address) and the
globals. The scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the vtable entries are recording stubs (OS or host boundaries);
nothing inside the function under test is patched. The x87 control word is 0x27f (the Windows process default) for the functions with x87 code.
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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, DBG_VALUES)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl30aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl30a.h').read_text()
    body = re.search(r'typedef struct Fl30aWorld \{(.*?)\} Fl30aWorld;', text, re.S).group(1)
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
VT_A = od.STUB_BASE + 0x900          # the vtable entry that the original reads and calls (a stub inside the mapped stub page)
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte


def make(key, areas, stubs, g, stack, args, profile, pointers=None, partial=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat={}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None,
                           partial=partial)


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
    for x in sc.stubs.values():
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, {}, fpcw=SPECS[sc.key].get('fpcw'))
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, {}, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    if SPECS[sc.key].get('ret16'):
        h.update(struct.pack('<H', orig.eax & 0xffff))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests)
UNTAKEN_ALLOWED = {
    '44b3c8': {
        (0x44b492, 'taken'): '`xor eax, eax; mov al, byte ptr [..]; test eax, eax; jl`: eax is the zero-extended byte, so it is never negative and the jl is never taken (its target 0x44b5a3 is reached through the jg at 0x44b4ab, and executed)',
    },
}


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


def region(rng, name, index, size, compare=True):
    return Area(name, od.region_va(index), bytearray(rng.randbytes(size)), image=False, compare=compare)


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def dbg_value(variant):
    return DBG_VALUES[1:][variant % 4]


# ---- 0x4f61e7 ---------------------------------------------------------------------------------------------------------------------


def gen_4f61e7(rng, n):
    (kind, arg), variant = prof(n, [(kind, arg) for kind in ('c0', 'no162', 'no28f', 'v0dbg0', 'v0dbg', 'vok') for arg in (0, 1, 2, 0xffffffff)])
    base, obj_va, vt_va = od.region_va(1), od.region_va(2), od.region_va(3)
    k = arg if arg < 3 else 0
    s = bytearray(rng.randbytes(0x600))
    put32(s, 0x3ce, base if arg < 3 else base + 0x5bb)
    recs = bytearray(rng.randbytes(0x5bb * 3 + 0x20))
    r = 0x5bb * k
    nz = NONZERO[(variant + k) % len(NONZERO)]
    put32(recs, r + 0x162, 0 if kind == 'no162' else nz)
    put32(recs, r + 0x28f, 0 if (kind == 'no28f' or (kind == 'no162' and variant % 2)) else obj_va)
    obj = bytearray(rng.randbytes(0x100))
    put32(obj, 0, vt_va)
    vt = bytearray(rng.randbytes(0x100))
    put32(vt, 0x48, VT_A)
    callee = [0] if kind == 'c0' else [NONZERO[(variant + 3) % len(NONZERO)]]
    vres = [0] if kind.startswith('v0') else [NONZERO[(variant + 5) % len(NONZERO)]]
    stubs = {0x4f709c: stub(0x4f709c, THISCALL(0), results=callee), VT_A: stub(VT_A, (1, True, 4), results=vres, probe=[('self', 0x3be, 0x18), ('recs', r + 0x280, 0x10)]),
             0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x44a2b7: stub(0x44a2b7, CDECL(1))}
    g = {'word_63a4cd': 0 if kind != 'v0dbg' else dbg_value(variant)}
    if kind not in ('v0dbg0', 'v0dbg'):
        g['word_63a4cd'] = DBG_VALUES[variant % 5]
    return make('4f61e7', [self_area(s), Area('recs', base, recs, image=False), Area('obj', obj_va, obj, image=False), Area('vtbl', vt_va, vt, image=False)], stubs, g, [arg],
                (arg,), (kind, arg))


# ---- 0x484762 ---------------------------------------------------------------------------------------------------------------------

AXIS = [-3, -2, -1, 0, 1]
EXH = len(AXIS) ** 4


def gen_484762(rng, n):
    """n < EXH: every (A.x0, A.x1, B.x0, B.x1) over AXIS with a valid y rectangle; EXH <= n < 2 * EXH: the same on the y axis; then random coordinates (some at the signed extremes)."""
    if n < EXH:
        xs, ys, profile = [AXIS[(n // 5 ** k) % 5] for k in range(4)], [0, 1, 0, 1], ('x', n)
    elif n < 2 * EXH:
        ys, xs, profile = [AXIS[((n - EXH) // 5 ** k) % 5] for k in range(4)], [0, 1, 0, 1], ('y', n - EXH)
    else:
        xs = [rng.randrange(-3, 4) for _ in range(4)]
        ys = [rng.randrange(-3, 4) for _ in range(4)]
        extremes = [-0x80000000, 0x7fffffff, -1, 0, 1, -2, 0x10000, -0x10000, 0x10001, 0xffff]
        if n % 2 == 0:
            xs = [rng.choice(extremes) for _ in range(4)]
        if n % 3 != 1:
            ys = [rng.choice(extremes) for _ in range(4)]
        profile = ('r', n)
    a, b = rng.randrange(4), rng.randrange(4)
    if n % 7 == 0:
        b = a
    s = bytearray(rng.randbytes(0x2000))
    for index, (x0, x1), (y0, y1) in ((a, (xs[0], xs[1]), (ys[0], ys[1])), (b, (xs[2], xs[3]), (ys[2], ys[3]))):
        if index == b and b == a and index is not a:
            continue
        base = 0x28 + index * 0x85 + 2
        for off, v in ((0, x0), (4, y0), (8, x1), (0xc, y1)):
            put32(s, base + off, v)
    if a == b:       # one record is both rectangles: A == B (the first rectangle)
        base = 0x28 + a * 0x85 + 2
        for off, v in ((0, xs[0]), (4, ys[0]), (8, xs[1]), (0xc, ys[1])):
            put32(s, base + off, v)
    stack = [a, b]
    return make('484762', [self_area(s)], {}, {}, stack, tuple(stack), profile)


# ---- 0x484ac0 and 0x47ef0f (the same latch of a hit index, with different offsets) ----------------------------------------------------

WORD_ARGS.update({0x4853b0: (0,), 0x484935: (0,), 0x47fa11: (0,), 0x47ed96: (0,)})
HIT_GUARDS = ['ba7', '24', '25', 'bb0', 'bac', 'state', 'bf9']
BAD_STATES = [0, 2, 0x101, 0xffffffff, 0x100, 0x80000001]
# offsets: self word (record number), the guards, the latched flag and index, the two output words; rec bytes; probes
HIT = {
    '484ac0': dict(wsel=0x26, ba7=0xba7, r24=0x24, r25=0x25, bb0=0xbb0, bac=0xbac, bf9=0xbf9, a92=0xa92, a9e=0xa9e, out1=0xbc5, out2=0xbc7, probes=[('self', 0xa90, 0x10), ('self', 0xbc0, 0x10)],
                   call_a='4853b0', call_b='4846c2', call_c='485f12', call_d='484935'),
    '47ef0f': dict(wsel=0x1e, ba7=0x13c5, r24=0x48, r25=0x49, bb0=0x13ce, bac=0x13ca, bf9=0x1417, a92=0x1344, a9e=0x1350, out1=0x13e3, out2=0x13e5,
                   probes=[('self', 0x1340, 0x18), ('self', 0x13e0, 0x10), ('self', 0x7a0, 0x40)], call_a='47fa11', call_b='47e9d3', call_c='480abe', call_d='47ed96'),
}


def hit_table(rng, w, rec_va, rec2_va, state, lo=-2, hi=3):
    """The record table (stride 0x8d) of 0x5bb5e5 for the entries lo..hi: entry w holds the record address `rec_va` and the state `state`, the others point at another record and hold another state."""
    data = bytearray(rng.randbytes((hi - lo + 1) * 0x8d + 0x10))
    for index in range(lo, hi + 1):
        put32(data, (index - lo) * 0x8d, rec_va if index == w else rec2_va)
        put32(data, (index - lo) * 0x8d + 0x4d, state if index == w else rng.choice([1, 0, 2]))
    return Area('tbl', 0x5bb5e5 + lo * 0x8d, data, image=True), {'table_5bb5e5': ('tbl', -lo * 0x8d)}


def gen_hit(key, rng, n, paths, extra=None):
    """The profile is (a failed guard or a path, an argument) and the pass number; `extra(s, rec, kind, variant)` adds the data that only 0x47ef0f has."""
    O = HIT[key]
    (kind, *rest), variant = prof(n, [(g,) for g in HIT_GUARDS for _ in range(2)] + paths)
    w = rng.choice([-2, -1, 0, 1, 2, 3])
    rec_va, rec2_va = od.region_va(1), od.region_va(2)
    s = bytearray(rng.randbytes(0x1800))
    rec, rec2 = bytearray(rng.randbytes(0x400)), bytearray(rng.randbytes(0x400))
    put16(s, O['wsel'], w & 0xffff)
    put32(s, O['ba7'], NONZERO[variant % 8])
    rec[O['r24']], rec[O['r25']], s[O['bb0']] = rng.choice([1, 0x80, 0xff, 0x7f]), 0, 0
    put32(s, O['bac'], 0)
    put16(s, O['bf9'], rng.choice([1, 0x8000, 0x100, 0xff, 0x7fff, 0xffff]))
    state = 1
    # the other record is the opposite of the right one for every guard, so that a wrong table index shows
    rec2[O['r24']], rec2[O['r25']] = 0, 0xff
    guard_fail = kind in HIT_GUARDS
    if kind == 'ba7':
        put32(s, O['ba7'], 0)
    elif kind == '24':
        rec[O['r24']] = 0
    elif kind == '25':
        rec[O['r25']] = rng.choice([1, 0x80, 0xff])
    elif kind == 'bb0':
        s[O['bb0']] = rng.choice([1, 0x80, 0xff])
    elif kind == 'bac':
        put32(s, O['bac'], NONZERO[variant % 8])
    elif kind == 'state':
        state = BAD_STATES[variant % len(BAD_STATES)]
    elif kind == 'bf9':
        put16(s, O['bf9'], 0)
    path_a = kind == 'A' or (guard_fail and n % 2 == 1)      # the guards are failed on both paths
    h = rest[0] if kind == 'A' else rng.choice([0, 1, 3])
    put32(s, O['a92'], NONZERO[variant % 8] if path_a else 0)
    put16(s, O['a9e'], h)
    ret = rest[0] if kind == 'B' else rng.choice([0xffff, 2, 4])
    if extra:
        extra(s, rec, kind, variant, h, ret, path_a)
    area, ptrs = hit_table(rng, w, rec_va, rec2_va, state)
    probes = O['probes']
    ca, cb, cc, cd = (int(O[k], 16) for k in ('call_a', 'call_b', 'call_c', 'call_d'))
    stubs = {ca: stub(ca, THISCALL(1), probe=probes), cb: stub(cb, THISCALL(0), results=[ret]), cc: stub(cc, THISCALL(0), probe=probes), cd: stub(cd, THISCALL(1), probe=probes)}
    return make(key, [self_area(s), Area('rec', rec_va, rec, image=False), Area('rec2', rec2_va, rec2, image=False), area], stubs, {}, [], (), (kind, *rest, variant, n % 2), ptrs)


def gen_484ac0(rng, n):
    paths = [('A', h) for h in (0, 1, 3, 5)] + [('B', r) for r in (0xffff, 0x1ffff, 0, 1, 2, 5, 0x12340003, 0x7f000004)]
    return gen_hit('484ac0', rng, n, paths)


# ---- 0x44b3c8 ---------------------------------------------------------------------------------------------------------------------

WORD_ARGS[0x42ba3a] = (0,)
FLOATS = [0.0, 9999.0, 1.5, -2.25, 0.1, 123456.789, -9999.0, 1e-40, 3.4e38, 100.0, 0.33333334, 9998.999, 9999.001, float('inf'), float('-inf'), -0.0]
NAN_BITS = [0x7fc00000, 0xffc00001, 0x7f800001]
WORD_TABLE = [0x270f, 0, 1, -1, 100, 0x7fff, -0x8000, 3, 0x270e, 0x2710]
VALUES = [0, 1, -1, 7, 100, -100, 12345, -32768, 32767, 3, 255, 1000]
E_PATTERNS = ['skip', 'w270f', 'word', 'f9999', 'float', 'fnan', 'plain', 'report', 'mix', 'mix', 'mix']


def gen_44b3c8(rng, n):
    import struct as st
    profiles = [('kind', k, pat) for k in range(0x1e, 0x28) for pat in E_PATTERNS] + [('bad', k, 'x') for k in (0, 0x1d, 0x28, 0x63, 0x80, 0xff)] * 2
    (cls, kind, pat), variant = prof(n, profiles)
    rec_va, rec2_va = od.region_va(1), od.region_va(2)
    w = rng.choice([-2, -1, 0, 1, 2, 3])
    rec = bytearray(rng.randbytes(0x40))
    rec[0] = kind
    all_e = list(range(0x1e)) + list(range(0x1e, 0x28)) + [0x28, 0x64, 0x65, 0x80, 0xff, 0x63]
    for i in range(10):
        e = {'skip': 0x63, 'w270f': 0x00, 'word': rng.randrange(0x1e), 'f9999': rng.randrange(0x1e, 0x28), 'float': rng.randrange(0x1e, 0x28), 'fnan': rng.randrange(0x1e, 0x28),
             'plain': 0x64, 'report': rng.choice([0x28, 0x65, 0x80, 0xff, 0x7f]), 'mix': rng.choice(all_e), 'x': rng.choice(all_e)}[pat]
        if pat == 'w270f':
            e = rng.choice([k for k in range(0x1e) if True][:3])
        rec[1 + 3 * i] = e
        put16(rec, 2 + 3 * i, rng.choice(VALUES) if i % 2 else rng.randrange(0x10000))
    tab = bytearray(0xa0)
    for k in range(0x1e):                            # the word table at +0x3c
        put16(tab, 0x3c + 2 * k, (WORD_TABLE[(k + variant) % len(WORD_TABLE)] if pat in ('w270f', 'word', 'mix') else rng.choice(WORD_TABLE)) & 0xffff)
    if pat == 'w270f':
        for k in range(3):
            put16(tab, 0x3c + 2 * k, 0x270f if variant % 2 == 0 or k != 1 else 0x270e)
    for k in range(0x28):                            # the float cells (0x1e..0x27 are the ones looked at; the others overlap the word table)
        if 0x1e <= k:
            if pat == 'f9999':
                bits = st.unpack('<I', st.pack('<f', 9999.0))[0] if (k + variant) % 3 else st.unpack('<I', st.pack('<f', rng.choice(FLOATS)))[0]
            elif pat == 'fnan':
                bits = rng.choice(NAN_BITS) if (k + variant) % 2 else st.unpack('<I', st.pack('<f', rng.choice(FLOATS)))[0]
            else:
                bits = st.unpack('<I', st.pack('<f', rng.choice(FLOATS) if rng.random() < 0.7 else rng.uniform(-500, 20000)))[0]
            put32(tab, 4 * k, bits)
    for k in range(0x0f):
        put32(tab, 4 * k, rng.randrange(1 << 32))
    area, ptrs = hit_table(rng, w, rec_va, rec2_va, 1)
    ptrs['tab_58c91d'] = ('tab', 0)
    probe = [('tab', 0, 0xa0)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3), probe=probe), 0x52139c: stub(0x52139c, STDCALL(3), probe=probe), 0x42ba3a: stub(0x42ba3a, CDECL(1), probe=probe)}
    g = {'word_63a4cd': 0 if (variant % 2 == 0 and cls == 'bad') else DBG_VALUES[1:][variant % 4]}
    a = word_arg(rng, w)
    return make('44b3c8', [Area('self', od.region_va(0), bytearray(rng.randbytes(0x40)), image=False, compare=False), Area('rec', rec_va, rec, image=False), Area('rec2', rec2_va, bytearray(rng.randbytes(0x40)), image=False),
                           area, Area('tab', 0x58c91d, tab, image=True)], stubs, g, [a], (a,), (cls, kind, pat, variant), ptrs)


SPECS = {
    '4f61e7': dict(id=1, va=0x4f61e7, size=333, gen=gen_4f61e7, cleanup=4, ret=True, n=24 * 8),
    '484ac0': dict(id=3, va=0x484ac0, size=495, gen=gen_484ac0, cleanup=0, n=(7 * 2 + 12) * 12),
    '44b3c8': dict(id=4, va=0x44b3c8, size=633, gen=gen_44b3c8, cleanup=4, fpcw=0x27f, n=(10 * 11 + 12) * 6),
    '484762': dict(id=2, va=0x484762, size=467, gen=gen_484762, cleanup=8, ret=True, n=2 * 625 + 600),
}
KEYS = list(SPECS)
NAMES = {'4f61e7': 'start_record', '484762': 'intersect_rects', '484ac0': 'latch_hit', '44b3c8': 'sum_kinds'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
