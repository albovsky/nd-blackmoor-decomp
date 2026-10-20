"""FL-31 (batch c): the fixtures shared by tests/test_fl31c_differential.py and tests/fl31c_original_oracle.py.

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
    """The fields of Fl31cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl31c.h').read_text()
    body = re.search(r'typedef struct Fl31cWorld \{(.*?)\} Fl31cWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4c92c5: (0,)}       # 0x4e2faa pushes a word with a stale upper half (mov cx, word; push ecx): the callee compares its low 16 bits
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


# ---- 0x4e2faa ---------------------------------------------------------------------------------------------------------------------


def gen_4e2faa(rng, n):
    (kind, *rest), variant = prof(n, [('zero',)] + [('set', v) for v in NONZERO])
    s = bytearray(rng.randbytes(0x4800))
    put32(s, 0x6ce, 0 if kind == 'zero' else rest[0])
    put16(s, 0x140a, WORDS_OTHER[variant % 8])
    put16(s, 0x140c, WORDS_OTHER[(variant * 3 + 1) % 8])
    probe = [('self', 0x6c0, 0x20), ('self', 0x1400, 0x20)]
    stubs = {0x4e1d34: stub(0x4e1d34, THISCALL(0)), 0x4e2dd3: stub(0x4e2dd3, THISCALL(0), probe=probe), 0x4c92c5: stub(0x4c92c5, THISCALL(1), probe=probe),
             0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=probe)}
    return make('4e2faa', [self_area(s)], stubs, {}, [], (), (kind, *rest, variant % 8))


# ---- 0x4c2790 ---------------------------------------------------------------------------------------------------------------------

BUF_VA = od.region_va(2)
STR_VA = od.region_va(3)
LENS = [0, 1, 2, 3, 4, 5, 7, 8, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x30]


def gen_4c2790(rng, n):
    (kind, *rest), variant = prof(n, [('null', 0)] + [('fail', 0), ('fail', 0x18), ('fail', 0x19)] + [('ok', ln) for ln in LENS])
    s = bytearray(rng.randbytes(0x40))
    buf = bytearray(rng.randbytes(0x100))
    for i in range(len(buf)):          # non-zero filler, so that a missed zero is visible
        if buf[i] == 0:
            buf[i] = 1 + i % 255
    length = rest[0] if kind != 'null' else rng.choice(LENS)
    str_off = variant % 4
    st = bytearray(rng.randbytes(0x100))
    for i in range(len(st)):
        if st[i] == 0 and (i <= str_off + length or variant % 2):
            st[i] = 1 + i % 255
    st[str_off + length] = 0
    boff = [0, 1, 3, 0x20][variant % 4]
    result = 0 if kind == 'null' else BUF_VA + boff
    fill = 0 if kind == 'fail' else NONZERO[variant % len(NONZERO)]
    probe = [('buf', boff, 0x60), ('str', str_off, 0x30)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[result]), 0x42639d: stub(0x42639d, THISCALL(2), probe=probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe),
             0x4181c6: stub(0x4181c6, THISCALL(3), probe=probe, writes=[(0, 2, 0, 4, fill)])}
    a, b, c = rnd32(rng), rnd32(rng), rnd32(rng)
    stack = [a, b, c, STR_VA + str_off]
    g = {'word_639893': [0, 0xffff, 0x1234, 0x8000][variant % 4]}
    areas = [self_area(s), Area('buf', BUF_VA, buf, image=False), Area('str', STR_VA, st, image=False)]
    return make('4c2790', areas, stubs, g, stack, tuple(stack), (kind, length, variant % 4))


# ---- 0x4eba54 ---------------------------------------------------------------------------------------------------------------------

COUNTS = [0xffff, 0, 1, 2, 3, 6, 0x8000]       # the signed word [self+0x28da]: -1, 0, ..., -32768
NOT8 = [0, 7, 9, 0x8008, 0xffff, 0x0800, 0x0080, 0xfff8, 0x8000, 0x0108]


def gen_4eba54(rng, n):
    # (flag 0, flag 1, count, bump): bump is a value that the callee 0x4e1d34 stores in the counter [self+0xfc6] on its first call (None: it leaves it alone)
    profiles = [(a, b, c, None) for a in (0, 1) for b in (0, 1) for c in COUNTS] + [(1, b, 2, v) for b in (0, 1) for v in (1, 0xfffffffe, 0xfffffffd)]
    (f0, f1, cnt, bump), variant = prof(n, profiles)
    s = bytearray(rng.randbytes(0x3000))
    put32(s, 0x985, NONZERO[variant % 8] if f0 else 0)
    put32(s, 0x985 + 0xf7, NONZERO[(variant + 3) % 8] if f1 else 0)
    put32(s, 0x985 + 2 * 0xf7, rng.choice(NONZERO))      # the record after the second is never looked at
    put16(s, 0x28da, cnt)
    signed = cnt - 0x10000 if cnt & 0x8000 else cnt
    tbl = bytearray(0x40)
    for k in range(32):
        in_range = 0 <= k < signed
        mode = variant % 3
        if in_range and mode == 0:
            w = 8
        elif in_range and mode == 1:
            w = rng.choice(NOT8)
        elif in_range:
            w = 8 if rng.randrange(2) else rng.choice(NOT8)
        else:
            w = 8                        # beyond the count: a loop that runs on would change these
        put16(tbl, 2 * k, w)
    put16(s, 0xb85, rng.choice([8, 0, 0x1234, 0xffff, 0x8008, rng.randrange(0x10000)]))
    probe = [('self', 0xfc6, 4), ('tbl', 0, 0x40)]
    writes = [] if bump is None else [(0, -1, od.region_va(0) + 0xfc6, 4, bump)]
    stubs = {0x4e1d34: stub(0x4e1d34, THISCALL(0), probe=probe, writes=writes), 0x4eb9c8: stub(0x4eb9c8, THISCALL(0), probe=probe)}
    return make('4eba54', [self_area(s), Area('tbl', 0x59f27b, tbl, image=True)], stubs, {}, [], (), (f0, f1, signed, variant % 3, bump), pointers={'words_59f27b': ('tbl', 0)})


# ---- 0x4edb97 ---------------------------------------------------------------------------------------------------------------------


def gen_4edb97(rng, n):
    (mask,), variant = prof(n, [(m,) for m in range(128)])
    s = bytearray(rng.randbytes(0x800))
    for bit, off in enumerate((0x15f, 0x252, 0x4ab, 0x675, 0x679, 0x67d, 0x681)):
        put32(s, off, NONZERO[(variant + 3 * bit + mask) % len(NONZERO)] if (mask >> bit) & 1 else 0)
    probe = [('self', 0x670, 0x20)]
    stubs = {0x4e1d34: stub(0x4e1d34, THISCALL(0), probe=probe), 0x4eead0: stub(0x4eead0, THISCALL(0), probe=probe), 0x4c2dfb: stub(0x4c2dfb, THISCALL(1), probe=probe),
             0x4fba69: stub(0x4fba69, THISCALL(1), probe=probe), 0x4edae5: stub(0x4edae5, THISCALL(0), probe=probe)}
    return make('4edb97', [self_area(s)], stubs, {}, [], (), (mask,))


# ---- 0x4db870 ---------------------------------------------------------------------------------------------------------------------

TBL_VA = 0x5b3790 - 0x100
TBL_SIZE = 0xb00
SEL_WORDS = [0xffff, 0, 1, 5, 0x10, 0xfffe, 0xffdb, 0xffe0, 0x3b, 0xffd8, 0xff]      # -1, 0, 1, 5, 16, -2, -0x25, -0x20, 0x3b, -0x28, 0xff
PAIR_VA = od.region_va(1)
CURSOR = [0, 1, 0x7fff, 0x80000000, 0xffffffff, 0x12345678, 0xfffffff0]


def gen_4db870(rng, n):
    (word, where), variant = prof(n, [(w, p) for w in SEL_WORDS for p in ('apart', 0x14, 0x10, 0x18, 0x1c, 0x28, 'local')])
    s = bytearray(rng.randbytes(0x100))
    pair = bytearray(rng.randbytes(0x20))
    put32(pair, 8, CURSOR[(variant + SEL_WORDS.index(word)) % len(CURSOR)])
    put32(pair, 12, CURSOR[(variant * 3 + 1) % len(CURSOR)])
    tbl = bytearray(rng.randbytes(TBL_SIZE))
    ptr = PAIR_VA + 8 if where == 'apart' else (0 if where == 'local' else od.region_va(0) + where)
    px, py = struct.unpack('<II', pair[8:16])
    g = {'word_583a29': word, 'dword_5d0377': rng.randrange(1 << 32), 'dword_571ad3': rng.randrange(1 << 32), 'dword_5b44f0': rng.randrange(1 << 32),
         'dword_5d162d': rng.randrange(1 << 32), 'dword_5b44f4': rng.choice([1, 0xffffffff, 0x10, rng.randrange(1, 1 << 32)]), 'dword_583106': rng.randrange(1 << 32),
         'dword_58310e': rng.randrange(1 << 32), 'dword_583102': rng.randrange(1 << 32), 'dword_58310a': rng.randrange(1 << 32)}
    probe = [('g:dword_5b44f0', 0, 4), ('g:dword_5d162d', 0, 4), ('g:dword_5b44f4', 0, 4), ('self', 0x10, 0x30)]
    if where == 'local':        # the game's callee: stores the pair through its argument (the function's local) and returns that same pointer
        s5 = stub(0x4daeb5, THISCALL(1), probe=probe, writes=[(0, 0, 0, 4, px), (0, 0, 4, 4, py)])
        s5.ret_arg = 0
    else:
        s5 = stub(0x4daeb5, THISCALL(1), probe=probe, results=[ptr])
    stubs = {0x4dae88: stub(0x4dae88, THISCALL(2), probe=probe), 0x4daeb5: s5}
    areas = [self_area(s), Area('pair', PAIR_VA, pair, image=False), Area('tbl', TBL_VA, tbl, image=True)]
    return make('4db870', areas, stubs, g, [], (), (hex(word), where), pointers={'table_5b3790': ('tbl', 0x100)})


# ---- 0x47cd90, 0x47ce6f, 0x47cf4e ---------------------------------------------------------------------------------------------------

RANDS = [0, 1, 4, 5, 6, 9, 10, 11, 0x7fff, 0x7fffffff, 0xfffffffb, 0xfffffffd, 0xfffffff6, 0x80000000, 0x80000001, 0xffffffff]
BASES = [od.region_va(1), od.region_va(1) + 0x1234, 0x10000, 0xfffffe00, 0x80000000, 0x5d0000, 0xffffffff]
NZ_RESULTS = [1, 0xffffffff, 0x80000000, 0x10000, 0x100, 0xff00, 0x7fffffff, 5]
VARIANTS = {'47cd90': (0x2b8, 0x4c8, 5, 0x54d104, 0x54d110), '47ce6f': (0x2bc, 0x856, 10, 0x54d11c, 0x54d128), '47cf4e': (0x2c0, 0xf72, 10, 0x54d134, 0x54d140)}


def gen_pick(key):
    sel, base, count, s1, s2 = VARIANTS[key]

    def gen(rng, n):
        profiles = [(k, script) for k in range(count) for script in (1, 2, 4)] + [(count, 0)]
        (k, script), variant = prof(n, profiles)
        s = bytearray(rng.randbytes(0x1000))
        put32(s, 0xc, BASES[(variant + k) % len(BASES)])
        rands = [RANDS[(variant * 5 + k * 3 + i * 7) % len(RANDS)] for i in range(script or 1)]
        second = [0] * (script - 1) + [NZ_RESULTS[(variant + k) % len(NZ_RESULTS)]] if script else []
        first = [0] * k + ([NZ_RESULTS[(variant * 3 + k) % len(NZ_RESULTS)]] if k < count else [])
        probe = [('self', sel, 4)]
        stubs = {0x516530: stub(0x516530, CDECL(2), probe=probe, results=first + second), 0x50cd50: stub(0x50cd50, CDECL(0), probe=probe, results=rands),
                 0x47d02d: stub(0x47d02d, THISCALL(1), probe=probe)}
        return make(key, [self_area(s)], stubs, {}, [], (), (k, script, variant % len(BASES)))
    return gen


SPECS = {
    '4e2faa': dict(id=1, va=0x4e2faa, size=145, gen=gen_4e2faa, cleanup=0, n=9 * 8),
    '4c2790': dict(id=2, va=0x4c2790, size=264, gen=gen_4c2790, cleanup=16, ret=True, n=19 * 8),
    '4eba54': dict(id=3, va=0x4eba54, size=263, gen=gen_4eba54, cleanup=0, n=34 * 6),
    '4edb97': dict(id=4, va=0x4edb97, size=282, gen=gen_4edb97, cleanup=0, n=128 * 2),
    '4db870': dict(id=5, va=0x4db870, size=291, gen=gen_4db870, cleanup=0, n=77 * 2),
    '47cd90': dict(id=6, va=0x47cd90, size=223, gen=gen_pick('47cd90'), cleanup=0, n=16 * 3),
    '47ce6f': dict(id=7, va=0x47ce6f, size=223, gen=gen_pick('47ce6f'), cleanup=0, n=31 * 3),
    '47cf4e': dict(id=8, va=0x47cf4e, size=223, gen=gen_pick('47cf4e'), cleanup=0, n=31 * 3),
}
KEYS = list(SPECS)
NAMES = {'4e2faa': 'release_cells', '4c2790': 'new_record', '4eba54': 'retarget_words', '4edb97': 'release_members', '4db870': 'load_cursor',
         '47cd90': 'pick_variant_a', '47ce6f': 'pick_variant_b', '47cf4e': 'pick_variant_c'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
