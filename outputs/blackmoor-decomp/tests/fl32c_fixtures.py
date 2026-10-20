"""FL-32 (batch c): the fixtures shared by tests/test_fl32c_differential.py and tests/fl32c_original_oracle.py.

Same shape as tests/fl31a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this` (or the
rectangles), the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through profiles (each guard failing in turn,
then every arm and scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes fill everything else.

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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, DBG_VALUES, debug_areas)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl32cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl32c.h').read_text()
    body = re.search(r'typedef struct Fl32cWorld \{(.*?)\} Fl32cWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4d3992: (0,)}       # 0x44e78e pushes edx whose upper half is the left-over of `this`; the callee reads a word
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
DWORDS = [0, 1, 0xffffffff, 0x80000000, 0x7fffffff, 0x12345678, 0x10000, 0xff]


def make(key, areas, stubs, g, stack, args, profile, pointers=None, native_args=None, expect_frame=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat={}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None, fault=None,
                           native_args=list(args) if native_args is None else native_args, expect_frame=expect_frame)


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
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    frame_at = od.STACK_BASE + od.STACK_SIZE - 0x100 - 4 * (len(sc.stack) + 1) - 0x14      # the first local of a frame with `sub esp, 0x10` (ebp-0x10)
    if sc.expect_frame is not None:
        sc.stubs[0x51ab4b].probe_addr.append((frame_at, 16))
    runner = Original27([(va, d) for va, d in image_patches], regions, sc.stubs, {})
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.expect_frame is not None:      # the dead stores of 0x43edac: ecx(this) and the three locals as they are when 0x51ab4b is entered (original side only; the port keeps them as locals)
        fixed = []
        for call in orig.calls:
            if call[0] == 0x51ab4b:
                if call[-1][-16:] != sc.expect_frame:
                    raise AssertionError('the frame of 0x43edac at the final call is %s, want %s' % (call[-1][-16:].hex(), sc.expect_frame.hex()))
                call = (*call[:-1], call[-1][:-16])
            fixed.append(call)
        orig.calls = fixed
    calls = normalize(orig.calls, sc.stubs, {}, sc.word_args)
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
    """[(jcc address, 'taken' or 'fall-through')] of the conditional jumps of the function `key` that none of `edges` went the way of."""
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


def tbl_area(rng, lo, hi):
    """The table of stride 0x4a at the original address 0x5d15a5 for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * 0x4a))
    return Area('tbl', 0x5d15a5 + lo * 0x4a, data, image=True), {'table_5d15a5': ('tbl', -lo * 0x4a)}


# ---- 0x44e78e ---------------------------------------------------------------------------------------------------------------------


def gen_44e78e(rng, n):
    (g20, w), variant = prof(n, [(g, w) for g in (0, 1) for w in (0xffff, 0, 1, 0x7fff, 0x8000, 0xfffe)])
    s = bytearray(rng.randbytes(0x400))
    put32(s, 0x20, NONZERO[variant % len(NONZERO)] if g20 else 0)
    put16(s, 0x1c, w)
    put16(s, 0x1e, [0xffff, 0, 0x1234][variant % 3])         # the neighbour of the word: only the word at +0x1c counts
    writes = []
    if variant % 3 == 1:       # the first callee changes the word that the function reads again afterwards
        writes = [(0, -1, od.region_va(0) + 0x1c, 2, 0xffff)]
    elif variant % 3 == 2:
        writes = [(0, -1, od.region_va(0) + 0x1c, 2, 0x1234)]
    stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=[('self', 0, 0x30)], writes=writes), 0x4d3992: stub(0x4d3992, CDECL(1), probe=[('self', 0, 0x30)]),
             0x44e767: stub(0x44e767, THISCALL(0), probe=[('self', 0, 0x30)])}
    return make('44e78e', [self_area(s)], stubs, {}, [], (), (g20, w, variant % 3))


# ---- 0x44e7d7 ---------------------------------------------------------------------------------------------------------------------

MARK_INDEXES = [0, 1, -2, -3, 5, 0x2a]


def gen_44e7d7(rng, n):
    profiles = [('gate0',), ('minus1',)] + [('mark', i) for i in MARK_INDEXES]
    (kind, *rest), variant = prof(n, profiles)
    area, ptrs = tbl_area(rng, -3, 0x2b)
    d = area.data
    for i in range(-3, 0x2c):                      # no entry starts with the dword 1: a store of 1 is visible
        put32(d, (i + 3) * 0x4a, rng.choice([0, 2, 0x10000, 0xffffffff, 0x80000000, 0xdeadbeef]))
    s = bytearray(rng.randbytes(0x400))
    gate = 0 if kind == 'gate0' else NONZERO[variant % len(NONZERO)]
    put32(s, 0x6b, gate)
    if kind == 'gate0' and variant % 2:            # the bytes around the zero gate are non-zero: a narrower or wider read of the gate would be non-zero
        s[0x6a] = 0xff
        s[0x6f] = 0xff
    word = {'gate0': rng.choice([0, 0xffff, 0x0007, 0x1234]), 'minus1': 0xffff}.get(kind, rest[0] if rest else 0)
    put16(s, 0x1c, word)
    if variant % 2 and kind == 'minus1':
        put16(s, 0x1e, 0)
    if kind == 'mark' and variant % 2:
        put16(s, 0x1e, 0xffff)
    return make('44e7d7', [self_area(s), area], {}, {}, [], (), (kind, *rest), ptrs)


# ---- 0x44e95b ---------------------------------------------------------------------------------------------------------------------

RECT_PAIRS = [(0x00, 0x20), (0x00, 0x00), (0x00, 0x04), (0x04, 0x00), (0x00, 0x08), (0x08, 0x00), (0x00, 0x0c), (0x0c, 0x00), (0x10, 0x14), (0x14, 0x10), (0x00, 0x01)]
ORIGINS = [(5, 7), (0xffffffff, 1), (0x80000000, 0x7fffffff), (0, 0), (1, 0xffffffff), (0x12345678, 0x9abcdef0)]


def gen_44e95b(rng, n):
    (src_off, dst_off), variant = prof(n, RECT_PAIRS)
    x, y = ORIGINS[variant % len(ORIGINS)]
    va = od.region_va(0)
    data = bytearray(rng.randbytes(0x80))
    for i in range(0, 0x30, 4):
        put32(data, i, rng.choice([rng.randrange(1 << 32), 0, 0xffffffff, 0x7fffffff, 0x80000000, 3]))
    return make('44e95b', [Area('rects', va, data, image=False)], {}, {'value_583186': x, 'value_58318a': y}, [va + src_off, va + dst_off], (va + src_off, va + dst_off),
                (src_off, dst_off, x, y), native_args=[('p', 'rects', src_off), ('p', 'rects', dst_off)])


# ---- 0x43edac ---------------------------------------------------------------------------------------------------------------------

RESULTS = [0, 1, 0xffffffff, 0x80000000, 0x12345678]


def gen_43edac(rng, n):
    (kind, r), variant = prof(n, [(k, r) for k in ('plain', 'rewrite') for r in RESULTS])
    s = bytearray(rng.randbytes(0x100))
    a8, ac, a10 = (rng.choice(DWORDS + [rng.randrange(1 << 32)]) for _ in range(3))
    new = (a8, ac, a10)
    writes = []
    if kind == 'rewrite':       # the callee writes through the three pointers it is given (the argument slots)
        new = tuple(rng.randrange(1 << 32) for _ in range(3))
        writes = [(0, k, 0, 4, new[k]) for k in range(3)]
    frame = struct.pack('<IIII', od.region_va(0), new[2], new[1], new[0])
    stubs = {0x437774: stub(0x437774, THISCALL(3), derefs=[(0, 12)], writes=writes), 0x51ab4b: stub(0x51ab4b, THISCALL(0), results=[r], probe=[('self', 0, 0x10)])}
    return make('43edac', [self_area(s)], stubs, {}, [a8, ac, a10], (a8, ac, a10), (kind, r, variant), expect_frame=frame)


# ---- 0x43ee69 ---------------------------------------------------------------------------------------------------------------------

SC_WPARAMS = [0xf140, 0xf170, 0xf14f, 0xf17f, 0x1f140, 0xf150, 0xf160, 0xf130, 0xf180, 0, 0x0140, 0xf141, 0xffff, 0xfff0, 0x1f171]
OTHER_MSGS = [0x113, 0x111, 0x15, 0x13, 0, 0x10014, 0x10112, 0xffffffff, 0x80000014, 0x80000112, 0x212]


def filter_profiles():
    return [('erase', 0x14)] + [('syscmd', 0x112, w) for w in SC_WPARAMS] + [('other', m) for m in OTHER_MSGS]


def gen_43ee69(rng, n):
    (kind, msg, *rest), variant = prof(n, filter_profiles())
    wparam = rest[0] if rest else rng.choice(DWORDS + [0xf140, 0xf170, rng.randrange(1 << 32)])
    lparam = rng.choice(DWORDS + [rng.randrange(1 << 32)])
    s = bytearray(rng.randbytes(0x100))
    results = [RESULTS[variant % len(RESULTS)]]
    stubs = {0x51b461: stub(0x51b461, THISCALL(3), results=results, probe=[('self', 0, 0x10)])}
    return make('43ee69', [self_area(s)], stubs, {}, [msg, wparam, lparam], (msg, wparam, lparam), (kind, msg, wparam))


# ---- 0x4db090 ---------------------------------------------------------------------------------------------------------------------

STATE_GLOBALS = [0xffffffff, 0, 5, 0xffff, 0x10000, 0xfffffffe]
STATE_F4 = [0, 1, 0x100, 0x10000]
STATE_F10 = [1, 0, 2, 0x101, 0x10001]


def gen_4db090(rng, n):
    (gv, f4, f10), variant = prof(n, [(g, a, b) for g in STATE_GLOBALS for a in STATE_F4 for b in STATE_F10])
    s = bytearray(rng.randbytes(0x40))
    put32(s, 4, f4)
    put32(s, 0x10, f10)
    put32(s, 0xc, rng.choice(NONZERO))
    junk = [rng.randrange(1 << 32), rng.randrange(1 << 32)]
    return make('4db090', [self_area(s)], {}, {'value_5c39e5': gv}, junk, (), (gv, f4, f10))


# ---- 0x4de53e ---------------------------------------------------------------------------------------------------------------------

REPORT_P = [0, 1, 0x20001234, 0xffffffff, 0x80000000, 0x10000, 0x100]
REPORT_G = [0, 0xffffffff, 0x80000000, 0x5cf665, None]


def gen_4de53e(rng, n):
    (p,), variant = prof(n, [(p,) for p in REPORT_P])
    gv = REPORT_G[variant % len(REPORT_G)]
    gv = rng.randrange(1 << 32) if gv is None else gv
    s = bytearray(rng.randbytes(0x1000))
    stubs = {0x4ee630: stub(0x4ee630, THISCALL(0), results=[p], probe=[('self', 0, 0x10)]),
             0x4c5377: stub(0x4c5377, THISCALL(5), probe=[('self', 0x970, 0x20), ('g:value_5cf665', 0, 4)])}
    return make('4de53e', [self_area(s)], stubs, {'value_5cf665': gv}, [], (), (p, gv))


# ---- 0x4ea229 ---------------------------------------------------------------------------------------------------------------------


def gen_4ea229(rng, n):
    (dbg,), variant = prof(n, [(d,) for d in DBG_VALUES])
    g, extra = debug_areas(rng, dbg)
    g['value_5d1717'] = NONZERO[variant % len(NONZERO)]
    s = bytearray(rng.randbytes(0x800))
    stubs = {0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=[('self', 0x690, 0x20), ('g:value_5d1717', 0, 4)]),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe=[('g:value_5d1717', 0, 4)])}
    return make('4ea229', [self_area(s), *extra], stubs, g, [], (), (dbg, variant))


# ---- 0x4fb2a6 ---------------------------------------------------------------------------------------------------------------------

SLOT_WORDS = [0, 1, 0x8000, 0xffff, 0x100, 0xff]
SLOT_B = [0, 1, 2, 3, 0x2c, 0x2d]       # 0x2d * 0x5bb is the first index above 16 bits (0x101df): the pushed eax then has a non-zero upper half
SLOT_SELF = 0x10600


def gen_4fb2a6(rng, n):
    (w, bl), variant = prof(n, [(w, b) for w in SLOT_WORDS for b in SLOT_B])
    s = bytearray(rng.randbytes(SLOT_SELF))
    for other in SLOT_B:
        pos = other * 0x5bb + 0x132
        value = w if other == bl else ((1 if w == 0 else 0) if variant % 2 == 0 else rng.choice(SLOT_WORDS))
        put16(s, pos, value)
        s[pos + 2] = 0xff
        s[pos + 3] = 0xff
        s[pos - 1] = rng.choice([0, 0xff])
    garbage = [0, 0xffff, rng.randrange(1, 0xffff)][variant % 3]
    b = bl | (garbage << 16)
    a = rng.choice(DWORDS + [rng.randrange(1 << 32)])
    stubs = {0x4faf98: stub(0x4faf98, THISCALL(2), probe=[('self', 0, 0x10)])}
    return make('4fb2a6', [self_area(s)], stubs, {}, [a, b], (a, b), (w, bl, variant % 3))


# GEN-END

SPECS = {
    '44e78e': dict(id=1, va=0x44e78e, size=73, gen=gen_44e78e, cleanup=0, n=12 * 3),
    '44e7d7': dict(id=2, va=0x44e7d7, size=52, gen=gen_44e7d7, cleanup=0, n=8 * 6),
    '44e95b': dict(id=3, va=0x44e95b, size=83, gen=gen_44e95b, cleanup=8, n=len(RECT_PAIRS) * len(ORIGINS)),
    '43edac': dict(id=4, va=0x43edac, size=63, gen=gen_43edac, cleanup=12, ret=True, n=10 * 4),
    '43ee69': dict(id=5, va=0x43ee69, size=103, code=101, gen=gen_43ee69, cleanup=12, ret=True, n=len(filter_profiles()) * 3),
    '4db090': dict(id=6, va=0x4db090, size=70, gen=gen_4db090, cleanup=8, n=len(STATE_GLOBALS) * len(STATE_F4) * len(STATE_F10)),
    '4de53e': dict(id=7, va=0x4de53e, size=70, gen=gen_4de53e, cleanup=0, n=len(REPORT_P) * 5),
    '4ea229': dict(id=8, va=0x4ea229, size=64, gen=gen_4ea229, cleanup=0, n=len(DBG_VALUES) * 6),
    '4fb2a6': dict(id=9, va=0x4fb2a6, size=61, gen=gen_4fb2a6, cleanup=8, n=len(SLOT_WORDS) * len(SLOT_B) * 3),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'44e78e': 'release_entry', '44e7d7': 'mark_entry', '44e95b': 'offset_rect', '43edac': 'default_after_query', '43ee69': 'filter_message',
         '4db090': 'normalize_state', '4de53e': 'report', '4ea229': 'clear_pending', '4fb2a6': 'check_slot',
         # NAMES-END
         }


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
