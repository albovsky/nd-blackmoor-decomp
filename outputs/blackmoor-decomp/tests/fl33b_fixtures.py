"""FL-33 (batch b): the fixtures shared by tests/test_fl33b_differential.py and tests/fl33b_original_oracle.py.

Same shape as tests/fl31a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the objects behind the addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address, with scripted results and scripted writes
through pointer arguments) and the globals. The scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the
function); the optional parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (OS or host boundaries); nothing inside the function under
test is patched. A scenario with `fault` set is one on which the original faults (a read or write at address 0): the run must stop exactly at that instruction.
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
    """The fields of Fl33bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl33b.h').read_text()
    body = re.search(r'typedef struct Fl33bWorld \{(.*?)\} Fl33bWorld;', text, re.S).group(1)
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
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]
DBG = [1, 2, 0x8000, 0x100, 0xffff]            # non-zero values of the debug word 0x63a4cd (0x8000 and 0xffff are negative as signed words)
THREE_ARG_FMT = (0x55e63c, 0x55e718)           # 0x4f5b50 calls 0x50ca3e with 3 arguments for these formats and with 4 for the others: the 4-argument stub logs one more dword


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None, ecx=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) if ecx is None else ecx, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None,
                           partial=None, fault=fault)


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
    if sc.fault is not None:
        # the original faults here (a read or write at an unmapped address): the run must stop exactly at the faulting instruction, the memory is read back as it is
        # and the native port is compared on the calls made before and on its documented rejection (tests/test_fl33b_differential.py)
        import unicorn
        from unicorn import x86_const as X
        try:
            runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
        except unicorn.UcError:
            pass
        else:
            raise AssertionError('the original did not fault')
        if runner.uc.reg_read(X.UC_X86_REG_EIP) != sc.fault:
            raise AssertionError('the original faulted at 0x%x, not at 0x%x' % (runner.uc.reg_read(X.UC_X86_REG_EIP), sc.fault))
        orig = SimpleNamespace(eax=None, cleanup=0, executed=runner.executed, edges=getattr(runner, 'edges', set()), calls=runner.calls,
                               memory={name: bytes(runner.uc.mem_read(a, n)) for name, (a, n) in read.items()})
    else:
        orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
        orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
        if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
            raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    calls = [c[:5] if c[0] == 0x50ca3e and len(c) > 5 and c[3] in THREE_ARG_FMT and sc.key == '4f5b50' else c for c in calls]
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') and sc.fault is None:
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


def table_area(rng, name, base, stride, lo, hi, compare=True):
    """A table of `stride` byte records at the original address base + lo*stride .. base + (hi+1)*stride (patched into the image), and the pointer of the world to its index 0."""
    return Area(name, base + lo * stride, bytearray(rng.randbytes((hi - lo + 1) * stride)), image=True, compare=compare), (name, -lo * stride)


def text(rng, n):
    """n printable non-zero bytes."""
    return bytes(rng.randrange(0x41, 0x5b) for _ in range(n))


def put_str(d, off, s):
    d[off:off + len(s) + 1] = s + b'\0'


# ---- 0x47d02d ---------------------------------------------------------------------------------------------------------------------

CONST_A = 0x54d158          # the 7 bytes after the string in the first case (dword, word, byte) ...
CONST_B = 0x54d160          # ... and in the second case; random bytes are patched in, the port must read them through the host
SHOW_CASES = [         # (result of 0x516530, length of the string at rec+0x31, what 0x423259 returns, length of that string, length of the string at rec+0x52)
    (0, 4, 'ptr', 4, 3), (7, 4, 'ptr', 0, 3), (0, 4, 'ptr', 97, 3), (7, 4, 'ptr', 0x9c41, 3), (0, 4, 'ptr', 0x9c41, 0), (0, 4, 'null', 0, 5), (7, 4, 'null', 0, 0),
    (0, 4, 'null', 0, 97), (0, 0, None, 0, 6), (7, 0, None, 0, 0), (7, 32, 'ptr', 5, 0), (3, 1, 'ptr', 96, 1)]
REC47D = od.region_va(1) + 0x13


def gen_47d02d(rng, n):
    profiles = [('off', 0), ('off', 7)] + [('on', *c) for c in SHOW_CASES]
    (kind, *rest), variant = prof(n, profiles)
    if kind == 'off':
        c516, l1, ret, rn, l2 = rest[0], 4, 'ptr', 4, 3
    else:
        c516, l1, ret, rn, l2 = rest
    rec = bytearray(rng.randbytes(0x100))
    put_str(rec, 0x13 + 0x31, text(rng, l1))
    put_str(rec, 0x13 + 0x52, text(rng, l2))
    res_va = od.region_va(2)
    res_ptr = res_va + 3
    res = bytearray(rng.randbytes(0xa000 if rn > 0x1000 else 0x200))
    put_str(res, 3, text(rng, rn))
    const = bytearray(rng.randbytes(0x10))
    flag = 0 if kind == 'off' else rng.choice(NONZERO)
    first_ok = flag and l1 > 0 and ret == 'ptr' and rn <= 0x9c40
    second = flag and not first_ok and l2 > 0
    nbytes = (rn if first_ok else l2) + 7
    stubs = {0x516530: stub(0x516530, CDECL(2), results=[c516]), 0x4fb77a: stub(0x4fb77a, THISCALL(1), results=[rng.randrange(1 << 16, 1 << 32)]),
             0x4fb2e3: stub(0x4fb2e3, THISCALL(1)), 0x423259: stub(0x423259, THISCALL(1), results=[res_ptr if ret == 'ptr' else 0]),
             0x448d11: stub(0x448d11, THISCALL(4), derefs=[(1, nbytes)])}
    g = {'value_5bb202': flag, 'value_5d03b3': rng.choice([0, 0xdeadbeef, rng.randrange(1 << 32)])}
    areas = [Area('rec', od.region_va(1), rec, image=False), Area('res', res_va, res, image=False), Area('const', CONST_A, const, image=True, compare=False)]
    return make('47d02d', areas, stubs, g, [REC47D], (REC47D,), (kind, *rest), ecx=0x33333333)


# ---- 0x4c51a5 ---------------------------------------------------------------------------------------------------------------------

COPY_CASES = [(1, 0, 0, 8, 8), (2, 1, 1, 0x10, 0x18), (3, 2, 2, 0x20, -0x20), (4, 2, 1, 0x30, 0x30), (3, 2, 1, 0x10, 0x10), (2, 2, 2, -0x20, 0x20), (1, 6, 1, 0x20, -0x10),
              (4, 0, 2, -0x30, 0x28)]       # (bytes per pixel, x1 - x0, y1 - y0, pitch of the source, pitch of the destination)
SRC_VA, DST_VA = od.region_va(5), od.region_va(6)
RECT_AT = 3
DESC_AT = 5


def gen_4c51a5(rng, n):
    profiles = ([('copy', i) for i in range(len(COPY_CASES))] + [('nodbg', i) for i in range(4)] + [('rows0',), ('rowsneg',), ('wmis',), ('hmis',), ('a0',), ('b0',),
                ('fault_a',), ('fault_b',), ('wmis_big',)])
    (kind, *rest), variant = prof(n, profiles)
    bpp, dx, dy, pa, pb = COPY_CASES[rest[0]] if rest else COPY_CASES[(n + variant) % len(COPY_CASES)]
    x0, y0, tx0, ty0 = rng.choice([0, 1, 3]), rng.choice([0, 1, 2]), rng.choice([0, 2, 5]), rng.choice([0, 1, 3])
    fr = [x0, y0, x0 + dx, y0 + dy]
    tr = [tx0, ty0, tx0 + dx, ty0 + dy]
    dbg = 0 if kind in ('nodbg', 'rows0', 'rowsneg', 'fault_a', 'fault_b') else rng.choice(DBG)
    if kind == 'nodbg':
        tr = [rng.randrange(0, 9), rng.randrange(0, 9), rng.randrange(0, 40), rng.randrange(0, 40)]       # the destination rectangle is not looked at
    if kind == 'rows0':
        fr[3] = fr[1] - 1
    if kind == 'rowsneg':
        fr[3] = fr[1] - 3
    if kind == 'wmis':
        tr[2] += rng.choice([1, 2, 7])
    if kind == 'wmis_big':
        tr = [rng.randrange(1 << 32) for _ in range(4)]
    if kind == 'hmis':
        tr[3] += rng.choice([1, 3])
    a_va, b_va = od.region_va(1) + DESC_AT, od.region_va(2) + DESC_AT
    fr_va, tr_va = od.region_va(3) + RECT_AT, od.region_va(4) + RECT_AT
    sbase, dbase = SRC_VA + 0x400 + rng.choice([0, 1, 3]), DST_VA + 0x400 + rng.choice([0, 1, 2])
    a, b = bytearray(rng.randbytes(0x80)), bytearray(rng.randbytes(0x80))
    put32(a, DESC_AT, sbase)
    put32(b, DESC_AT, dbase)
    put16(a, DESC_AT + 0x2f, pa)
    put16(b, DESC_AT + 0x2f, pb)
    frd, trd = bytearray(rng.randbytes(0x40)), bytearray(rng.randbytes(0x40))
    for i in range(4):
        put32(frd, RECT_AT + 4 * i, fr[i])
        put32(trd, RECT_AT + 4 * i, tr[i])
    tag = rng.randrange(1 << 32)
    sa, sb = a_va, b_va
    fault = None
    if kind == 'a0':
        sa = 0
    if kind == 'b0':
        sb = 0
    if kind == 'fault_a':
        sa = 0
        fault = 0x4c529e
    if kind == 'fault_b':
        sb = 0
        fault = 0x4c52c9
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(11)), 0x52139c: stub(0x52139c, STDCALL(3)), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=[('self', 0, 0x20)])}
    areas = [self_area(bytearray(rng.randbytes(0x200))), Area('a', od.region_va(1), a, image=False), Area('b', od.region_va(2), b, image=False),
             Area('fr', od.region_va(3), frd, image=False), Area('tr', od.region_va(4), trd, image=False), Area('src', SRC_VA, bytearray(rng.randbytes(0x800)), image=False),
             Area('dst', DST_VA, bytearray(rng.randbytes(0x800)), image=False)]
    g = {'word_63a4cd': dbg, 'word_639895': bpp}
    return make('4c51a5', areas, stubs, g, [sa, sb, fr_va, tr_va, tag], (sa, sb, fr_va, tr_va, tag), (kind, *rest), fault=fault)


# ---- 0x47df57 ---------------------------------------------------------------------------------------------------------------------

VIEW_IDX = [0, 2, -1, 3, -2]
TAB_IDX = [0, 2, 3, -1]
ITEM47 = od.region_va(1) + 7


def gen_47df57(rng, n):
    profiles = [('off',)] + [('on', f22, wlt, x0z, hlt, y0z) for f22 in (0, 1) for wlt in (0, 1) for x0z in (0, 1) for hlt in (0, 1) for y0z in (0, 1)]
    (kind, *rest), variant = prof(n, profiles)
    f22, wlt, x0z, hlt, y0z = rest if rest else (0, 0, 0, 0, 0)
    ri, ti = VIEW_IDX[(n + variant) % len(VIEW_IDX)], TAB_IDX[(n // 3 + variant) % len(TAB_IDX)]
    rec, rptr = table_area(rng, 'rec', 0x5bb5e5, 0x8d, -2, 3)
    for i in range(-2, 4):
        put32(rec.data, (i + 2) * 0x8d, rng.randrange(1 << 32))
    put32(rec.data, (ri + 2) * 0x8d, ITEM47)
    tab, tptr = table_area(rng, 'tab', 0x5d1599, 0x4a, -1, 3, compare=False)
    item = bytearray(rng.randbytes(0x80))
    item[7 + 0x22] = f22 * rng.choice([1, 0x80, 0xff])
    half = rng.choice([0x20, 0x40, 0x7fff])
    wide = rng.randrange(1, 0x30)
    x0 = 0 if x0z else rng.randrange(1, 6)
    y0 = 0 if y0z else rng.randrange(1, 6)
    width = rng.randrange(1, 2 * half) if wlt else rng.randrange(2 * half, 2 * half + 0x50)
    height = rng.randrange(1, 2 * half) if hlt else rng.randrange(2 * half, 2 * half + 0x50)
    big = lambda: rng.choice([rng.randrange(1 << 32), rng.randrange(0x40), 0xffffffff, 0x80000000])
    g = {'word_6246f9': ri, 'byte_6246f8': 0 if kind == 'off' else rng.choice([1, 0x80, 0xff]), 'word_624731': half, 'word_6246ff': ti,
         'value_624705': x0, 'value_62470d': (x0 + width - 1) & 0xffffffff, 'value_624709': y0, 'value_624711': (y0 + height - 1) & 0xffffffff,
         'value_624715': big(), 'value_624719': big(), 'value_62471d': big(), 'value_624721': big(), 'value_624729': big(), 'value_62472d': big(),
         'value_583186': big(), 'value_58318a': big(), 'value_5cf665': big(), 'value_5d15e3': big()}
    if variant % 2 and kind != 'off':       # signed extremes: a negative half size, a wrapped width
        g['word_624731'] = rng.choice([-0x8000, -1, 0, 1])
        g['value_62470d'] = rng.choice([x0 - 1, 0x7fffffff, 0x80000000, 0xffffffff]) & 0xffffffff
    stubs = {0x4c5377: stub(0x4c5377, THISCALL(5), derefs=[(3, 16)]), 0x4c62f0: stub(0x4c62f0, THISCALL(9), derefs=[(6, 16), (7, 16)]),
             0x4c6929: stub(0x4c6929, THISCALL(7), derefs=[(4, 16), (5, 16)])}
    areas = [Area('item', od.region_va(1), item, image=False), rec, tab]
    return make('47df57', areas, stubs, g, [], (), (kind, *rest, ri, ti), {'records_5bb5e5': rptr, 'table_5d1599': tptr})


# ---- 0x4c2898 ---------------------------------------------------------------------------------------------------------------------

NAME_LENS = [0, 5, 0x18, 0x19, 0x30]
WH = [(4, 3), (0x7fff, 2), (0x8000, 5), (0xffff, 0xffff), (300, 200), (0, 7)]
BPPS = [1, 2, 4, -2, 3, 0x7fff]
CELL_AT, P_AT, NAME_AT = 3, 5, 1


def gen_4c2898(rng, n):
    profiles = [('exists',), ('a1fail',), ('a2fail',)] + [('ok', nl, wh) for nl in NAME_LENS for wh in range(len(WH))]
    (kind, *rest), variant = prof(n, profiles)
    nl, wh = (rest if rest else (5, 0))
    w, h = WH[wh]
    cell_va, p_va, name_va = od.region_va(1) + CELL_AT, od.region_va(2) + P_AT, od.region_va(3) + NAME_AT
    cell = bytearray(rng.randbytes(0x40))
    put32(cell, CELL_AT, rng.choice(NONZERO) if kind == 'exists' else 0)
    p = bytearray(rng.randbytes(0x100))
    name = bytearray(rng.randbytes(0x100))
    put_str(name, NAME_AT, text(rng, nl))
    q = rng.choice([0x30001234, 0x7fff0000, 0xdeadbeef])
    results = [0] if kind == 'a1fail' else [p_va, 0 if kind == 'a2fail' else q]
    probe = [('cell', 0, 0x10), ('p', 0, 0x60)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=results, probe=probe), 0x42639d: stub(0x42639d, THISCALL(2), probe=probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe)}
    g = {'word_639895': BPPS[(n + variant) % len(BPPS)], 'word_639893': rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, 0x1234])}
    areas = [self_area(bytearray(rng.randbytes(0x100))), Area('cell', od.region_va(1), cell, image=False), Area('p', od.region_va(2), p, image=False),
             Area('name', od.region_va(3), name, image=False)]
    wa, ha = word_arg(rng, w), word_arg(rng, h)
    extra = rng.randrange(1 << 32)
    return make('4c2898', areas, stubs, g, [cell_va, wa, ha, extra, name_va], (cell_va, wa, ha, extra, name_va), (kind, *rest))


# ---- 0x4f594d ---------------------------------------------------------------------------------------------------------------------

RECS_VA, DATA_VA, FILE_VA = od.region_va(1), od.region_va(2), od.region_va(3)
BASE_AT = 0x700
READ_PROFILES = [('f95zero',), ('mis3',), ('mis4',), ('neg1', 1), ('neg1', 0), ('full', 1), ('full', 0), ('over',), ('a_neg',), ('a_short',), ('a_ok',), ('b_skip',), ('b_fill8',),
                 ('b_fill0',), ('lenzero',), ('lenneg',), ('b_fill8', 'one'), ('b_fill0', 'one')]


def rec_area(rng, idx):
    """The records region: the record of index idx starts at RECS_VA + BASE_AT + idx*0x5bb."""
    return bytearray(rng.randbytes(0x1800))


def gen_4f594d(rng, n):
    (kind, *rest), variant = prof(n, READ_PROFILES)
    eq, buf0 = [(0, 0), (1, 0), (0, 1), (1, 1)][variant % 4]
    idx = [0, 1, -1][(n + variant) % 3]
    len_ = rng.choice([8, 11, 6, 9]) if kind != 'lenzero' else 0
    if kind == 'lenneg':
        len_ = -4 & 0xffffffff
    n1 = {'a_neg': 2, 'a_short': 2, 'a_ok': 3, 'b_skip': 3, 'b_fill8': 2, 'b_fill0': 3, 'over': len_ + 3, 'full': len_, 'lenzero': 0, 'lenneg': 0}.get(kind, 0)
    if kind == 'neg1':
        n1 = -1 & 0xffffffff
    if kind in ('b_fill8', 'b_fill0') and rest:
        n1 = len_ - 1                      # one byte left to fill
    n2 = {'a_neg': -1 & 0xffffffff, 'a_short': len_ - n1 - 1, 'a_ok': len_ - n1}.get(kind, 0)
    recs = rec_area(rng, idx)
    o = BASE_AT + idx * 0x5bb
    base_va = RECS_VA + BASE_AT
    put32(recs, o + 0x15e, len_ if eq else len_ + 1)
    put32(recs, o + 0x28f, rng.randrange(1 << 32))
    put32(recs, o + 0x130, 0 if kind.startswith('a_') else rng.choice([1, 0x100, 0xdeadbeef]))
    put32(recs, o + 0x18a + 0x10, 0xffffffff if kind == 'b_skip' else rng.choice([0, 5, 0xfffffffe, 0x7fffffff]))
    put32(recs, o + 0x18a + 0xc, rng.choice([0, 7, 0xffffffff]))
    put16(recs, o + 0x2ed, 8 if kind == 'b_fill8' else rng.choice([0, 7, 9, 0x108, 0x8000]))
    s = bytearray(rng.randbytes(0x500))
    put32(s, 0x3ce, base_va)
    put32(s, 0x3c2, rng.randrange(1 << 32))
    data = bytearray(rng.randbytes(0x100))
    s2 = DATA_VA + 3
    s3, s4 = len_, 0
    if kind == 'mis3':
        s3 = (len_ + 1) & 0xffffffff
    if kind == 'mis4':
        s4 = rng.choice([1, 0x10000, 0x80000000])
    r95 = 0 if kind == 'f95zero' else rng.choice([1, 5, 0xffffffff])
    r35_on = rest[0] if kind in ('neg1', 'full') else variant % 3 != 2
    r35 = rng.choice([1, 9]) if r35_on else 0
    buf = 0 if buf0 else 0x30000000 + rng.randrange(0x1000)
    writes = [(0, 1, 8, 4, s2), (0, 1, 0xc, 4, s3), (0, 1, 0x10, 4, s4)]
    stubs = {0x4f5e95: stub(0x4f5e95, THISCALL(2), results=[r95], writes=writes, derefs=[(1, 0x1c)]),
             0x4f5e35: stub(0x4f5e35, THISCALL(2), results=[r35], derefs=[(1, 0x1c)]),
             0x4f5b50: stub(0x4f5b50, THISCALL(3), results=[n1, n2])}
    areas = [self_area(s), Area('recs', RECS_VA, recs, image=False), Area('data', DATA_VA, data, image=False)]
    return make('4f594d', areas, stubs, {}, [idx & 0xffffffff, buf, len_], (idx & 0xffffffff, buf, len_), (kind, *rest, eq, buf0, idx, len_))


# ---- 0x41e3c0 ---------------------------------------------------------------------------------------------------------------------

BUILD_IDX = [0, 2, -1, 1]
BUF_VA, ITEM41_VA, STRS_VA = od.region_va(3), od.region_va(1), od.region_va(2)
ITEM41_AT = 3
CONST41 = 0x54388c


def gen_41e3c0(rng, n):
    profiles = [('run', cnt, flag) for cnt in (0, 1, 2, 3, 4) for flag in (0, 1)] + [('neg', 0xffff, 1), ('neg', 0x8000, 0), ('nobuf', 2, 1)]
    (kind, *rest), variant = prof(n, profiles)
    cnt, flag = rest
    idx = BUILD_IDX[(n + variant) % len(BUILD_IDX)]
    s = bytearray(rng.randbytes(0x1000))
    put16(s, 0xf21, cnt)
    nstr = 4
    strs = bytearray(rng.randbytes(0x200))
    for i in range(nstr):
        put32(s, 0xea5 + 4 * i, STRS_VA + 0x10 + 0x40 * i + (i % 2))
        put_str(strs, 0x10 + 0x40 * i + (i % 2), text(rng, rng.choice([0, 1, 4, 5, 9, 12])))
    item = bytearray(rng.randbytes(0x200))
    put_str(item, ITEM41_AT + 0x16b, text(rng, rng.choice([0, 1, 3, 7, 20])))
    rec, rptr = table_area(rng, 'rec', 0x5bb5e5, 0x8d, -1, 2)
    for i in range(-1, 3):
        put32(rec.data, (i + 1) * 0x8d, rng.randrange(1 << 32))
    put32(rec.data, (idx + 1) * 0x8d, ITEM41_VA + ITEM41_AT)
    const = bytearray(rng.randbytes(0x28))
    put_str(const, 4, text(rng, rng.choice([0, 1, 2, 3])))          # the string at 0x543890
    put_str(const, 0xc, text(rng, rng.choice([0, 1, 4, 7])))        # the string at 0x543898
    for off in (0, 8, 0x24):
        const[off:off + 4] = bytes(rng.choice([0, rng.randrange(0x41, 0x5b)]) for _ in range(4)) if variant % 2 else rng.randbytes(4)
    buf = bytearray(rng.randbytes(F41_BUF + 0x40))
    writes = [(i, 0, 0, 0, text(rng, rng.choice([0, 1, 5, 20, 40, 51])) + b'\0') for i in range(8)]
    probe = [('buf', 0, 0x100)]
    stubs = {0x51e745: stub(0x51e745, THISCALL(0)), 0x51ea75: stub(0x51ea75, THISCALL(1), results=[0 if kind == 'nobuf' else BUF_VA], probe=probe),
             0x50ca3e: stub(0x50ca3e, CDECL(5), writes=writes, probe=probe), 0x51eac4: stub(0x51eac4, THISCALL(1), probe=[('buf', 0, 0x200)])}
    g = {'value_5bb202': flag * rng.choice(NONZERO)}
    areas = [self_area(s), Area('item', ITEM41_VA, item, image=False), Area('strs', STRS_VA, strs, image=False), Area('buf', BUF_VA, buf, image=False), rec,
             Area('const', CONST41, const, image=True, compare=False)]
    a = word_arg(rng, idx)
    return make('41e3c0', areas, stubs, g, [a], (a,), (kind, *rest, idx), {'records_5bb5e5': rptr}, fault=0x41e400 if kind == 'nobuf' else None)


F41_BUF = 0x3a98


# ---- 0x4f5b50 ---------------------------------------------------------------------------------------------------------------------

BLOCK_DBG = [0, 1, 2, 0x8000, 2, 0xffff, 0x100]
M2_CASES = [('full', lambda L: [(L, 0)]), ('two', lambda L: [(3, 0), (L - 3, 0)]), ('zero_then', lambda L: [(2, 0), (0, 0)]), ('zero_end', lambda L: [(0, 0)]),
            ('neg', lambda L: [(0xffffffff, 0)]), ('flagged', lambda L: [(2, 1)]), ('neg_then', lambda L: [(2, 0), (0xfffffffb, 0)]), ('len0', lambda L: []),
            ('lenneg', lambda L: []), ('short_then_flag', lambda L: [(2, 0), (1, 5)])]
M1_CASES = [('eq', 0), ('n20', 0x20), ('n10', 0x10), ('n30', 0x30), ('none', 0), ('none', 0x8000), ('big', 0x7fffffe0)]
M0_MODES = [0, 3, 0xffff, 0x7fff, 0x8000]


def gen_4f5b50(rng, n):
    profiles = [('m2', i) for i in range(len(M2_CASES))] + [('m1', i) for i in range(len(M1_CASES))] + [('m0', i) for i in range(len(M0_MODES))]
    (kind, *rest), variant = prof(n, profiles)
    idx = [0, 1, -1][(n + variant) % 3]
    dbg = BLOCK_DBG[(n + variant) % len(BLOCK_DBG)] if variant % 4 != 3 else 0
    recs = bytearray(rng.randbytes(0x1800))
    o = BASE_AT + idx * 0x5bb
    base_va = RECS_VA + BASE_AT
    file_va = FILE_VA + 0x10
    len_ = rng.choice([8, 11, 6, 9, 5])
    mode = {'m2': 2, 'm1': 1}.get(kind)
    if kind == 'm0':
        mode = M0_MODES[rest[0]]
    put16(recs, o + 0x126, mode)
    put32(recs, o + 0x156, file_va)
    put16(recs, o + 0x2ed, 8 if variant % 2 else rng.choice([0, 7, 9, 0x108]))
    fileb = bytearray(rng.randbytes(0x40))
    results, writes, stack_len = [], [], len_
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(4)), 0x44a2b7: stub(0x44a2b7, CDECL(1)), 0x52139c: stub(0x52139c, STDCALL(3))}
    if kind == 'm2':
        name, mk = M2_CASES[rest[0]]
        if name == 'lenneg':
            stack_len = 0xfffffffc
        if name == 'len0':
            stack_len = 0
        seq = mk(len_)
        for k, (go, fl) in enumerate(seq):
            results.append(go)
            writes.append((k, 6, 0, 4, fl))
        stubs[0x4fe2d0] = stub(0x4fe2d0, CDECL(7), results=results or [0], writes=writes)
        stubs[0x4fdc70] = stub(0x4fdc70, CDECL(3))
    if kind == 'm1':
        name, fl = M1_CASES[rest[0]]
        res_n = len_ if name == 'eq' else rng.choice([0, len_ - 1, len_ + 2, 0xffffffff])
        stubs[0x50cf61] = stub(0x50cf61, CDECL(4), results=[res_n])
        stubs[0x50ce2b] = stub(0x50ce2b, CDECL(3))
        put32(fileb, 0x10 + 0xc, (fl | (rng.randrange(1 << 32) & ~0x30)) & 0xffffffff if name != 'none' else (rng.randrange(1 << 32) & ~0x30) & 0xffffffff)
        if name == 'big':
            put32(fileb, 0x10 + 0xc, 0x20 | 0x7fffff00)
    s = bytearray(rng.randbytes(0x500))
    put32(s, 0x3ce, base_va)
    put32(s, 0x3c2, rng.randrange(1 << 32))
    buf = 0x30000000 + rng.randrange(0x1000)
    areas = [self_area(s), Area('recs', RECS_VA, recs, image=False), Area('file', FILE_VA, fileb, image=False)]
    return make('4f5b50', areas, stubs, {'word_63a4cd': dbg}, [idx & 0xffffffff, buf, stack_len], (idx & 0xffffffff, buf, stack_len), (kind, *rest, dbg, idx))


# ---- 0x41db40 ---------------------------------------------------------------------------------------------------------------------

FREE_IDX = [0, 2, -1, 3]
ARR_STRIDES = [(0x793, 0x795, 0x1d1), (0x799, 0x79b, 0x1c), (0x79f, 0x7a1, 0xa)]
ITEM_AT = 9
BLOCK_KINDS = ['run', 'cnt0', 'cntneg', 'ptr0']
ENTRY_STATES = ['go', 'wz', 'wneg', 'dz']


def gen_41db40(rng, n):
    profiles = [('null', d) for d in (0, 1)] + [('blocks', a, b, c, d) for a in BLOCK_KINDS for b in BLOCK_KINDS for c in BLOCK_KINDS for d in (0, 1)]
    (kind, *rest), variant = prof(n, profiles)
    idx = FREE_IDX[(n + variant) % len(FREE_IDX)]
    dbg = rng.choice(DBG) if rest[-1] else 0
    rec, rptr = table_area(rng, 'rec', 0x5bb5e5, 0x8d, -2, 3)
    for i in range(-2, 4):
        put32(rec.data, (i + 2) * 0x8d, rng.randrange(1, 1 << 32))
    item_va = od.region_va(1)
    put32(rec.data, (idx + 2) * 0x8d, 0 if kind == 'null' else item_va + ITEM_AT)
    item = bytearray(rng.randbytes(0x900))
    arrs = [(od.region_va(2), bytearray(rng.randbytes(0x700))), (od.region_va(3), bytearray(rng.randbytes(0x100))), (od.region_va(4), bytearray(rng.randbytes(0x100)))]
    if kind == 'blocks':
        for blk, ((cnt_off, ptr_off, stride), (va, data)) in enumerate(zip(ARR_STRIDES, arrs)):
            bk = rest[blk]
            count = {'run': 3, 'cnt0': 0, 'cntneg': rng.choice([0x8000, 0xffff, 0x8001]), 'ptr0': 2}[bk]
            put16(item, ITEM_AT + cnt_off, count)
            put32(item, ITEM_AT + ptr_off, 0 if bk == 'ptr0' else va + 1)
            for j in range(3):
                st = ENTRY_STATES[(n + j + blk) % 4]
                e = 1 + j * stride
                put16(data, e, {'go': rng.choice([1, 0x7fff, 5]), 'wz': 0, 'wneg': rng.choice([0x8000, 0xffff]), 'dz': rng.choice([1, 2])}[st])
                put32(data, e + 2, 0 if st == 'dz' else rng.randrange(1, 1 << 32))
    ridx = (idx + 2) * 0x8d
    probe = [('item', ITEM_AT + 0x793, 0x10), ('rec', ridx, 4)]
    stubs = {0x51dc6c: stub(0x51dc6c, CDECL(1), probe=probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe)}
    areas = [self_area(bytearray(rng.randbytes(0x40))), Area('item', item_va, item, image=False), *[Area(nm, va, d, image=False) for nm, (va, d) in zip(('arrA', 'arrB', 'arrC'), arrs)], rec]
    a = word_arg(rng, idx)
    return make('41db40', areas, stubs, {'word_63a4cd': dbg}, [a], (a,), (kind, *rest, idx), {'records_5bb5e5': rptr})


# GEN-END

SPECS = {
    '47d02d': dict(id=1, va=0x47d02d, size=406, gen=gen_47d02d, cleanup=4, status=True, n=(len(SHOW_CASES) + 2) * 3),
    '4c51a5': dict(id=2, va=0x4c51a5, size=466, gen=gen_4c51a5, cleanup=0x14, status=True, n=(len(COPY_CASES) + 13) * 3),
    '47df57': dict(id=3, va=0x47df57, size=477, gen=gen_47df57, cleanup=0, n=33 * 2),
    '4c2898': dict(id=4, va=0x4c2898, size=501, gen=gen_4c2898, cleanup=0x14, n=(3 + len(NAME_LENS) * len(WH)) * 2),
    '4f594d': dict(id=5, va=0x4f594d, size=515, gen=gen_4f594d, cleanup=0xc, ret=True, n=len(READ_PROFILES) * 4),
    '41e3c0': dict(id=6, va=0x41e3c0, size=647, gen=gen_41e3c0, cleanup=4, status=True, n=13 * 4),
    '4f5b50': dict(id=7, va=0x4f5b50, size=741, gen=gen_4f5b50, cleanup=0xc, ret=True, n=(len(M2_CASES) + len(M1_CASES) + len(M0_MODES)) * 4),
    '41db40': dict(id=8, va=0x41db40, size=745, gen=gen_41db40, cleanup=4, n=130),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'47d02d': 'show_names', '4c51a5': 'copy_rows', '47df57': 'update_view', '4c2898': 'alloc_surface', '4f594d': 'read_checked', '41e3c0': 'build_text',
         '4f5b50': 'read_block', '41db40': 'free_record',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
