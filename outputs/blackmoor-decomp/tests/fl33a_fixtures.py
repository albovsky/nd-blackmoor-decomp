"""FL-33 (batch a): the fixtures shared by tests/test_fl33a_differential.py and tests/fl33a_original_oracle.py.

Same shape as tests/fl31b_fixtures.py and tests/fl29a_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub
constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the
addresses it keeps, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through profiles (each guard failing in turn, then every
arm and every scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (including the CRT calls 0x50cd50 and 0x516530 and the allocator 0x51dc43) are recording stubs (host boundaries);
nothing inside the function under test is patched.
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
    """The fields of Fl33aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl33a.h').read_text()
    body = re.search(r'typedef struct Fl33aWorld \{(.*?)\} Fl33aWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4c808f: (6,)}       # 0x4c7623 pushes a word with a stale upper half (mov cx, word; push ecx): the callee reads a word
NONZERO = [1, 0x80000000, 0x10000, 0xff000000, 0x00ff0000, 0xdeadbeef, 0xffffffff, 0x100]    # non-zero dwords, some with a zero low word / byte
WORDS_OTHER = [0, 1, 0x7fff, 0x8000, 0xfffe, 0x1234, 0xff00, 0x00ff]


class Original31c(Original27):
    """Original27 whose stubs can also return one of their own stack arguments (stub.ret_arg = argument index): a callee that returns its pointer argument."""

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        ret_arg = getattr(stub, 'ret_arg', None)
        value = None
        if ret_arg is not None:
            esp = uc.reg_read(self._r['ESP'])
            value = struct.unpack('<I', uc.mem_read(esp + 4 + 4 * ret_arg, 4))[0]
        super()._stub_hook(uc, address, size, user)
        if value is not None:
            uc.reg_write(self._r['EAX'], value)


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
    runner = Original31c(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if SPECS[sc.key].get('retoff') is not None and orig.eax != sc.ecx + SPECS[sc.key]['retoff']:
        raise AssertionError('the function did not return this + 0x%x' % SPECS[sc.key]['retoff'])
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


def rnd32(rng):
    """A random dword that is not inside the stack of the Unicorn run (the normaliser would call it a local)."""
    while True:
        v = rng.randrange(1 << 32)
        if not od.STACK_BASE - 0x1000 <= v < od.STACK_BASE + od.STACK_SIZE + 0x1000:
            return v


# ---- helpers shared by the generators ---------------------------------------------------------------------------------------------


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def tbl_area(rng, base, stride, lo, hi, pointer_name, name='tbl', dword_rnd=True):
    """The table of stride `stride` at the original address `base` for the indices lo..hi (patched into the image), and the world pointer to its index 0."""
    data = bytearray(rng.randbytes((hi - lo + 1) * stride))
    if dword_rnd:
        for i in range(lo, hi + 1):
            put32(data, (i - lo) * stride, rnd32(rng))
    return Area(name, base + lo * stride, data, image=True), {pointer_name: (name, -lo * stride)}


def zero_string(rng, length, size):
    """`size` bytes: `length` non-zero random bytes, a NUL, then random bytes."""
    s = bytearray(rng.randbytes(size))
    for i in range(length):
        s[i] = rng.randrange(1, 256)
    s[length] = 0
    return s


# ---- 0x4dae88 ---------------------------------------------------------------------------------------------------------------------

CURSOR = [(0, 0), (1, 0xffffffff), (0x80000000, 0x7fffffff), (0x7fffffff, 0x80000000)]


def gen_4dae88(rng, n):
    (kind,), variant = prof(n, [('run',)] * 8)
    s = bytearray(rng.randbytes(0x40))
    x, y = CURSOR[variant % 4] if variant < 4 else (rnd32(rng), rnd32(rng))
    iat = {0x52a488: stub(0x52a488, STDCALL(2), probe=[('self', 0, 0x30)], results=[rng.choice([0, 1, rnd32(rng)])])}
    return make('4dae88', [self_area(s)], {}, {}, [x, y], (x, y), (kind, variant), iat=iat)


# ---- 0x473117 ---------------------------------------------------------------------------------------------------------------------

MARK_INDEXES = [0, 1, -2, -3, 5, 0x2a]


def gen_473117(rng, n):
    profiles = [('gate0',), ('minus1',)] + [('mark', i) for i in MARK_INDEXES]
    (kind, *rest), variant = prof(n, profiles)
    area, ptrs = tbl_area(rng, 0x5d15a5, 0x4a, -3, 0x2b, 'table_5d15a5', dword_rnd=False)
    d = area.data
    for i in range(-3, 0x2c):                      # no entry starts with the dword 1: a store of 1 is visible
        put32(d, (i + 3) * 0x4a, rng.choice([0, 2, 0x10000, 0xffffffff, 0x80000000, 0xdeadbeef]))
    s = bytearray(rng.randbytes(0x400))
    gate = 0 if kind == 'gate0' else rng.choice(NONZERO)
    put32(s, 0x7a, gate)
    if variant % 2:
        s[0x7a + 4] = 0
        s[0x7a - 1] = 0
    word = {'gate0': rng.choice([0, 0xffff, 0x0007, 0x1234]), 'minus1': 0xffff}.get(kind, rest[0] if rest else 0)
    put16(s, 0x14, word)
    if variant % 2 and kind == 'minus1':          # the bytes around the word make the dword -1 only for a wrong width / sign
        s[0x16] = 0
        s[0x17] = 0
    if kind == 'mark' and variant % 2:
        s[0x16] = 0xff
        s[0x17] = 0xff
    return make('473117', [self_area(s), area], {}, {}, [], (), (kind, *rest), pointers=ptrs)


# ---- 0x4234dd ---------------------------------------------------------------------------------------------------------------------

PUSH_N = [(0, 0), (1, 0), (5, 0), (0x7f, 0), (-1, 0), (0x80000000, 0), (0x80, 0), (0x80, 1), (0x81, 0x8000), (0x81, 0xffff), (0x15555556, 0x100), (0x2aaaaaab, 0)]


def gen_4234dd(rng, n):
    (count, dbg), variant = prof(n, PUSH_N)
    s = bytearray(rng.randbytes(0x800))
    put32(s, 4, count)
    a, b = rnd32(rng), rnd32(rng)
    probe = [('self', 0, 0x20), ('self', 0x600, 0x20), ('g:word_63a4cd', 0, 2)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(2), probe=probe), 0x52139c: stub(0x52139c, STDCALL(3), probe=probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe)}
    return make('4234dd', [self_area(s)], stubs, {'word_63a4cd': dbg}, [a, b], (a, b), (hex(count & 0xffffffff), dbg))


# ---- 0x4c7623 ---------------------------------------------------------------------------------------------------------------------

RECT_VA = od.region_va(1)
FRAME_WORDS = [0xffff, 0, 0x8000, 0x1234]


def gen_4c7623(rng, n):
    (kind, w), variant = prof(n, [(k, w) for k in ('eq', 'ne_hi', 'ne_lo', 'ne_rand') for w in FRAME_WORDS])
    s = bytearray(rng.randbytes(0x40))
    a = rnd32(rng)
    put32(s, 0xc, a if kind == 'eq' else {'ne_hi': a ^ 0x80000000, 'ne_lo': a ^ 1, 'ne_rand': rnd32(rng)}[kind])
    rect = bytearray(rng.randbytes(0x40))
    for off in (3, 7, 11, 15):                                    # the four dwords of the rectangle, unaligned
        put32(rect, off, rnd32(rng))
    v1, v2 = rnd32(rng), rnd32(rng)
    wa = word_arg(rng, w)
    probe = [('self', 0, 0x20)]
    stubs = {0x4c4067: stub(0x4c4067, THISCALL(5), probe=probe, writes=[(0, 2, 0x10, 4, v1), (0, 2, 0x24, 4, v2)]),
             0x4c808f: stub(0x4c808f, THISCALL(7), probe=probe), 0x4c4202: stub(0x4c4202, THISCALL(3), probe=probe), 0x4c952f: stub(0x4c952f, THISCALL(1), probe=probe)}
    return make('4c7623', [self_area(s), Area('rect', RECT_VA, rect, image=False)], stubs, {}, [a, RECT_VA + 3, wa], (a, RECT_VA + 3, wa), (kind, w, variant))


# ---- 0x4bf3b8 ---------------------------------------------------------------------------------------------------------------------

TEXT_FIELDS = [-6, -5, -4, -3, -2, -1, 0, 1, 0x7fffffff, -7, 0x80000000, 5]
TEXT_STRING_VAS = [0x552494, 0x5524bc, 0x5524e4, 0x552508, 0x552594]
TEXT_LENS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 0x1e, 0x1d]


def gen_4bf3b8(rng, n):
    (field,), variant = prof(n, [(f,) for f in TEXT_FIELDS])
    s = bytearray(rng.randbytes(0x400))
    put32(s, 0x2c0, field)
    areas = [self_area(s)]
    for k, va in enumerate(TEXT_STRING_VAS):
        areas.append(Area('str_%x' % va, va, zero_string(rng, TEXT_LENS[(variant + 3 * k) % len(TEXT_LENS)], 0x24), image=True, compare=False))    # 0x24: the closest two strings are 0x24 bytes apart
    code = rnd32(rng)
    probe = [('self', 0xb0, 0x30)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3), probe=probe)}
    iat = {0x52a514: stub(0x52a514, STDCALL(0), probe=probe, results=[rng.choice([0, 1, rnd32(rng)])])}
    return make('4bf3b8', areas, stubs, {}, [code], (code,), (field, variant), iat=iat)


# ---- 0x4db993 ---------------------------------------------------------------------------------------------------------------------

PT_VA = od.region_va(1)
BOUNDS = [(0, 100, 0, 100), (-50, 50, -60, 40), (0x80000000, 0x7fffffff, 0x80000000, 0x7fffffff)]
POSITIONS = ['in', 'xmin', 'xmax', 'ymin', 'ymax', 'xlo', 'xhi', 'ylo', 'yhi']
SEL_WORDS = [0xffff, 0, 1, 5, 0xfffe]
ALL32 = 0xffffffff


def cursor_point(bounds, pos):
    xmin, xmax, ymin, ymax = [b & ALL32 for b in bounds]

    def sx(v):
        return v - (1 << 32) if v >= 1 << 31 else v

    def mid(lo, hi):
        return ((sx(lo) + sx(hi)) // 2) & ALL32
    x, y = mid(xmin, xmax), mid(ymin, ymax)
    return {'in': (x, y), 'xmin': (xmin, y), 'xmax': (xmax, y), 'ymin': (x, ymin), 'ymax': (x, ymax), 'xlo': ((xmin - 1) & ALL32, y), 'xhi': ((xmax + 1) & ALL32, y),
            'ylo': (x, (ymin - 1) & ALL32), 'yhi': (x, (ymax + 1) & ALL32)}[pos]


def gen_4db993(rng, n):
    (bi, pos, where), variant = prof(n, [(b, p, w) for b in range(len(BOUNDS)) for p in POSITIONS for w in ('apart', 'local')])
    word = SEL_WORDS[(n // 7) % len(SEL_WORDS)]
    xmin, xmax, ymin, ymax = [b & ALL32 for b in BOUNDS[bi]]
    px, py = cursor_point(BOUNDS[bi], pos)
    s = bytearray(rng.randbytes(0x100))
    pt = bytearray(rng.randbytes(0x40))
    put32(pt, 0x11, px)
    put32(pt, 0x15, py)
    wtbl = Area('wtbl', 0x5b3790, bytearray(rng.randbytes(0x31 * 8)), image=True, compare=False)
    g = {'word_583a29': word, 'value_5d0377': rnd32(rng), 'value_571ad3': rnd32(rng), 'value_5b44f0': rnd32(rng), 'value_5d162d': rnd32(rng), 'value_5b44f4': rng.choice([1, ALL32, 0x10, rnd32(rng)]),
         'value_583106': rnd32(rng), 'value_58310e': rnd32(rng), 'value_583102': rnd32(rng), 'value_58310a': rnd32(rng), 'value_5c3a53': rnd32(rng), 'value_5c3a57': rnd32(rng),
         'value_5b377c': xmin, 'value_5b3784': xmax, 'value_5b3780': ymin, 'value_5b3788': ymax}
    probe = [('g:value_5b44f0', 0, 4), ('g:value_5c3a53', 0, 4), ('g:value_583106', 0, 4), ('self', 0x10, 0x30)]
    if where == 'local':        # the game's callee: stores the pair through its argument (the function's local) and returns that same pointer
        s5 = stub(0x4daeb5, THISCALL(1), probe=probe, writes=[(0, 0, 0, 4, px), (0, 0, 4, 4, py)])
        s5.ret_arg = 0
    else:
        s5 = stub(0x4daeb5, THISCALL(1), probe=probe, results=[PT_VA + 0x11])
    a, b = rnd32(rng), rnd32(rng)
    stubs = {0x4dae88: stub(0x4dae88, THISCALL(2), probe=probe), 0x4daeb5: s5}
    areas = [self_area(s), Area('pt', PT_VA, pt, image=False), wtbl]
    return make('4db993', areas, stubs, g, [a, b], (a, b), (bi, pos, where, hex(word)), pointers={'table_5b3790': ('wtbl', 0)})


# ---- 0x47d24e ---------------------------------------------------------------------------------------------------------------------

OBJ_VA = od.region_va(1)
ENT_VA = od.region_va(2) + 0x100 + 5
ENT_FLAGS = [0, 2, 0x100, 0x10001, 0xffffffff, 0x80000001]
ENT_FIRST = [0, 1, 2, 0x3f, 0x7fffffff, 0x10000001]
TABLE_WORDS = [0, 1, 0xffff, 0xfffe, 0x20, 5]
REPORT_PROFILES = ([('gate0', f, b, 0, 0) for f in (0, 1) for b in (0, 1)]
                   + [('run', f, b, c, p) for f in (0, 1) for b in (0, 1) for c in (0, 1, 2, 3, -1, 0x80000000) for p in (0, 1, -1, 2)] + [('bigpage', 1, 1, 0, 0x40000000)])


def gen_47d24e(rng, n):
    (kind, flag, byte, count, page), variant = prof(n, REPORT_PROFILES)
    obj = bytearray(rng.randbytes(0x600))
    obj[0x35b] = rng.choice([1, 0x80, 0xff, 2]) if byte else 0
    obj[0x35a] = obj[0x35c] = obj[0x35d] = obj[0x35e] = 0 if byte else 0xff       # a wider read of the byte would see the neighbours
    ent = bytearray(rng.randbytes(0x400))
    for idx in range(-16, 20):
        at = 0x100 + 5 + 12 * idx
        put32(ent, at, rng.choice(ENT_FIRST))
        put32(ent, at + 4, 1 if (variant >> (idx & 7)) & 1 == (idx & 1) else rng.choice(ENT_FLAGS))
    word = TABLE_WORDS[(variant + n) % len(TABLE_WORDS)]
    g = {'value_61e3a4': OBJ_VA, 'value_61e3ac': ENT_VA, 'value_61e3bc': 0 if kind == 'gate0' else rng.choice(NONZERO), 'value_61e3c8': 0 if not flag else rng.choice(NONZERO),
         'value_61e618': count, 'value_61e624': page, 'value_5cf665': rnd32(rng), 'value_5d15e3': rnd32(rng), 'word_61e39c': word}
    area, ptrs = tbl_area(rng, 0x5d1599, 0x4a, -3, 0x21, 'table_5d1599')
    put32(area.data, (1 + 3) * 0x4a, g['value_5d15e3'])        # record 1 starts at 0x5d15e3: the global and the table dword are the same memory in the game
    area.compare = False
    probe = [('g:value_61e3c8', 0, 4), ('obj', 0x350, 0x20)]
    stubs = {0x4c5377: stub(0x4c5377, THISCALL(5), probe=probe)}
    areas = [Area('obj', OBJ_VA, obj, image=False), Area('ent', od.region_va(2), ent, image=False), area]
    return make('47d24e', areas, stubs, g, [], (), (kind, flag, byte, count, page, word), pointers=ptrs)


# ---- 0x4c7070 ---------------------------------------------------------------------------------------------------------------------

DESC_VA = od.region_va(1)
IMG_VA = od.region_va(2)
BUF_VA = od.region_va(3) + 0x400
ROTATE = [(3, 2, 4, 2, 0x10), (2, 3, 6, 2, 0x11), (1, 1, 2, 2, 3), (0, 3, 4, 2, 0x12), (3, 0, 4, 2, 0x13), (-1, 2, 4, 2, 4), (2, -2, 4, 2, 5), (3, 3, -4, 1, 0x80), (2, 2, 0x20, -2, 0x81),
          (1, 4, 2, 0, 0x100), (-0x8000, 2, 4, 2, 0x20), (2, -0x8000, 4, 2, 0x21)]


def gen_4c7070(rng, n):
    (kind, *rest), variant = prof(n, [('null', 0x10), ('null', 0x13)] + [('ok', *r) for r in ROTATE] + [('big', 2, 2, 4, 2, 0x10005)])
    big = kind == 'big'                           # a size above 16 bits: the image and the block are 0x10800 bytes (regions 4 and 6, the regions between stay unused)
    img_va, buf_region = (od.region_va(4), od.region_va(6)) if big else (IMG_VA, od.region_va(3))
    buf_va = buf_region + 0x400
    s = bytearray(rng.randbytes(0x40))
    desc = bytearray(rng.randbytes(0x60))
    img = bytearray(rng.randbytes(0x10800 if big else 0x400))
    buf = bytearray(rng.randbytes(0x10800 if big else 0x800))
    off = 3 + (variant % 2)                      # the descriptor lies at an unaligned address, the image at a varying offset
    img_at = img_va + 0x10 + 5 * (variant % 3)
    if kind == 'null':
        w1, w2, w3, bpp, size = 3, 2, 4, 2, rest[0]
    else:
        w1, w2, w3, bpp, size = rest
    put32(desc, off, img_at)
    put32(desc, off + 0x23, size)
    put16(desc, off + 0x2b, w1)
    put16(desc, off + 0x2d, w2)
    put16(desc, off + 0x2f, w3)
    put16(desc, off + 0x31, rng.randrange(0x10000))
    arg2 = rnd32(rng)
    probe_img = [('img', 0, 0x40)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe=probe_img, results=[0 if kind == 'null' else buf_va]),
             0x51dc6c: stub(0x51dc6c, CDECL(1), probe=[('img', 0, 0x40), ('desc', 0, 0x60)]), 0x42639d: stub(0x42639d, THISCALL(2), probe=probe_img),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe_img)}
    areas = [self_area(s), Area('desc', DESC_VA, desc, image=False), Area('img', img_va, img, image=False), Area('buf', buf_region, buf, image=False)]
    # the allocator's block starts 0x400 bytes into 'buf' (slack below it for a negative row stride); BUF_VA is that block
    g = {'word_639895': bpp}
    return make('4c7070', areas, stubs, g, [DESC_VA + off, arg2], (DESC_VA + off, arg2), (kind, *rest, off, variant % 3))


# GEN-END

SPECS = {
    '4dae88': dict(id=1, va=0x4dae88, size=45, gen=gen_4dae88, cleanup=8, ret=True, n=8),
    '473117': dict(id=2, va=0x473117, size=52, gen=gen_473117, cleanup=0, n=8 * 6),
    '4234dd': dict(id=3, va=0x4234dd, size=144, gen=gen_4234dd, cleanup=8, n=12 * 3),
    '4c7623': dict(id=4, va=0x4c7623, size=333, gen=gen_4c7623, cleanup=12, n=16 * 2),
    '4bf3b8': dict(id=5, va=0x4bf3b8, size=370, gen=gen_4bf3b8, cleanup=4, retoff=0xc0, n=12 * 11),
    '4db993': dict(id=6, va=0x4db993, size=384, gen=gen_4db993, cleanup=8, n=54 * 5),
    '47d24e': dict(id=7, va=0x47d24e, size=388, gen=gen_47d24e, cleanup=0, n=len(REPORT_PROFILES) * 2),
    '4c7070': dict(id=8, va=0x4c7070, size=393, gen=gen_4c7070, cleanup=8, n=15 * 3),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'4dae88': 'set_cursor', '473117': 'mark_entry', '4234dd': 'push_pair', '4c7623': 'draw_frame', '4bf3b8': 'set_text', '4db993': 'move_cursor', '47d24e': 'report_fields',
         '4c7070': 'rotate_image'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
