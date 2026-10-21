"""FL-36 (batch a): the fixtures shared by tests/test_fl36a_differential.py and tests/fl36a_original_oracle.py.

Same shape as tests/fl33c_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording stub constructor,
the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it
keeps, the scripted callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through profiles (each guard failing in turn, then every arm and
every scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (including the CRT-shaped 0x50ca3e, 0x50d0a9, 0x50cf61, 0x52139c) are recording stubs (host boundaries);
nothing inside the function under test is patched. The stub of 0x50ca3e is entered with five stack words at every call site; the words behind the real arity of the site are dropped from the
log (ARITY_BY_SITE, keyed by the return address), as the native side logs only the arguments it passes.
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
    """The fields of Fl36aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl36a.h').read_text()
    body = re.search(r'typedef struct Fl36aWorld \{(.*?)\} Fl36aWorld;', text, re.S).group(1)
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
WORD_ARGS = {0x4f438f: (0,), 0x4f3c26: (0,)}      # callee -> positions of stack arguments pushed from a 16-bit register with a stale upper half (`mov cx, word`): the comparison masks them to 16 bits
BYTE_ARGS = {}
# 0x50ca3e is called with 3, 5 and 4 arguments at its three call sites (it is variadic): its stub reads 5 stack words, the log keeps the real arity of the site (key: return address)
ARITY_BY_SITE = {(0x50ca3e, 0x4f3afa): 3, (0x50ca3e, 0x4f3b91): 5, (0x50ca3e, 0x4f3bf0): 4}
STUB_ARGS = {0x50ca3e: 5}


def mask_raw(calls, rets):
    """The original's raw call log (name, args ...) with the per-call-site arity of ARITY_BY_SITE applied (the words behind it dropped) and the byte arguments of BYTE_ARGS masked."""
    out = []
    for call, ret in zip(calls, rets):
        call = list(call)
        site = ARITY_BY_SITE.get((call[0], ret))
        if site is not None:
            call = call[:1 + site] + call[1 + STUB_ARGS[call[0]]:]
        for index in BYTE_ARGS.get(call[0], ()):
            call[1 + index] &= 0xff
        out.append(tuple(call))
    return out


def mask_bytes(entries):
    for entry in entries:
        for index in BYTE_ARGS.get(entry[0], ()):
            entry[2 + index] &= 0xff
    return entries


class Original36a(Original27):
    """Original27 that also remembers the return address of every stub call (the call site), in the order of the call log."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.rets = []

    def _stub_hook(self, uc, address, size, user):
        esp = uc.reg_read(self._r['ESP'])
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        super()._stub_hook(uc, address, size, user)
        self.rets.append(ret)


def make(key, areas, stubs, g, stack, args, profile, iat=None, pointers=None, self_off=0):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) + self_off, self_off=self_off, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None, partial=None, fault=None, endless=None)


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
    runner = Original36a(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(mask_raw(orig.calls, runner.rets), sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests): none for 0x4f379c
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


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


# ---- 0x4f379c ---------------------------------------------------------------------------------------------------------------------

E_SIZES = [-1, 0x80000000, 0, 1, 0x56220, 0x56221, 0x7fffffff]
E_RANGES = [(0, 0), (0, 5), (0, -5), (3, 10), (10, 3), (5, 0), (7, 7), (0x7fffffff, 0x80000000), (0x80000000, 1), (-4, -1), (0xffffffff, 0)]
E_PAIRS = [(1, 2), (2, 1), (5, 5), (-1, 1), (1, -1), (0x7fffffff, 0x80000000), (0x80000000, 0x7fffffff)]
E_SMALL = [-5, 0, 1, 2, 3, 0x80000000, 0x7fffffff]
E_STRLEN = [0, 1, 3, 4, 5, 11, 31, 32, 33, 34, 35]          # 0x55dafc strings; a string of 36 or more would overrun the frame of the original (native rejection, direct test only)
E_IDS = [0, 1, 0x12, 0x8000, 0xffff, 0x1234]
E_WORD_OTHER = [0, 1, 3, 0xffff, 0x102, 0x8002]
E_PROFILES = ([('open0', p) for p in (0, 1)] + [('read0', p) for p in (0, 1)] + [('magic', k) for k in range(4)] + [('w10e', k) for k in range(len(E_WORD_OTHER))]
              + [('w110', k) for k in range(4)] + [('ok', size, dbg, w126, i) for i, (size, dbg, w126) in enumerate((s, d, w) for s in E_SIZES for d in (0, 1) for w in (2, 0))])
E_MAGIC_VA, E_STR_VA = 0x55dab4, 0x55dafc
E_DBG = [1, 0x100, 0x8000, 0xffff]


def gen_4f379c(rng, n):
    profile, variant = prof(n, E_PROFILES)
    stage = profile[0]
    ok = stage == 'ok'
    size, dbg, w126, i = profile[1:] if ok else (E_SIZES[(n + variant) % len(E_SIZES)], (n + variant) % 2, (2, 0)[(n // 2 + variant) % 2], n)
    id_ = E_IDS[(n + variant) % len(E_IDS)]
    entry_va = od.region_va(1) + 0x20 + variant % 3
    magic = rng.randbytes(4)
    s = bytearray(rng.randbytes(0x500))
    put32(s, 0x3ce, (entry_va - id_ * 0x5bb) & 0xffffffff)
    for off in (0x446, 0x44a, 0x466, 0x46a):
        put32(s, off, rnd32(rng))
    obj = bytearray(rng.randbytes(0x600 + 0x40))
    base = entry_va - od.region_va(1)

    def put_obj32(off, v):
        put32(obj, base + off, v)
    pre162 = profile[1] if stage in ('open0', 'read0') else (n + variant) % 3 != 0         # the 'already open' field: the first callee 0x4f356e only runs when it is non-zero
    put_obj32(0x162, rng.choice([1, 0x80000000, 0x100, 0xff]) if pre162 else 0)
    hdr = bytearray(magic)
    if stage == 'magic':
        hdr[profile[1]] ^= rng.choice([1, 0x80, 0xff])
    obj[base + 0x10a:base + 0x10e] = hdr
    put16(obj, base + 0x10e, E_WORD_OTHER[profile[1]] if stage == 'w10e' else 2)
    put16(obj, base + 0x110, [1, 0x100, 0x8000, 0xffff][profile[1]] if stage == 'w110' else 0)
    put16(obj, base + 0x126, 2 if w126 == 2 else rng.choice(E_WORD_OTHER))
    put_obj32(0x122, size)
    a, b = E_RANGES[(i + variant) % len(E_RANGES)]
    put_obj32(0x1aa, a)
    put_obj32(0x1ae, b)
    for k, off in enumerate((0x1b2, 0x1ba, 0x1c2)):
        x, y = E_PAIRS[(i + k * 3 + variant + n // 7) % len(E_PAIRS)]
        put_obj32(off, x)
        put_obj32(off + 4, y)
    put_obj32(0x1d6, E_SMALL[(i + variant) % len(E_SMALL)])
    put_obj32(0x1da, E_SMALL[(i * 3 + variant + 1) % len(E_SMALL)])
    strlen = E_STRLEN[(n + variant) % len(E_STRLEN)]
    text = bytearray(rng.randrange(1, 256) for _ in range(strlen)) + b'\0' + bytearray(rng.randbytes(8))
    magic_area = Area('magic', E_MAGIC_VA, bytearray(magic), image=True, compare=False)
    str_area = Area('str', E_STR_VA, text, image=True, compare=False)
    probe = [('self', 0x3b0, 0x30), ('objs', 0, 0x600 + 0x40)]
    fp = rng.choice([rnd32(rng) | 1, 0x10000, 0x80000000, 0xff000000, rnd32(rng) | 1])      # a non-zero handle, some with a zero low word (the test of the original is a dword compare)
    read_ok = rng.choice([1, 0x80000000, 0x100, 0xffffffff])
    self_va = od.region_va(0)

    def callee_result(i_):
        return rng.choice([1, 0x80000000, 0x100, 0xff]) if (i_ + variant) % 4 != 0 else 0
    r_open = 0 if stage == 'open0' else fp
    r_read = 0 if stage == 'read0' else read_ok
    r_a, r_b = callee_result(n), callee_result(n // 2 + 1)
    if ok and size > 0x56220:
        r_a = (r_a or 1) if (i // 2) % 3 else 0
    wa = [(0, -1, self_va + 0x3be, 4, rng.choice([0, 5, 0x80000000]))] if (n + variant) % 3 == 0 else []
    wb = [(0, -1, self_va + 0x3be, 4, rng.choice([0, 7, 0xffffffff]))] if (n + variant) % 5 == 0 else []
    stubs = {0x4f356e: stub(0x4f356e, THISCALL(1), probe=probe), 0x50d0a9: stub(0x50d0a9, CDECL(2), probe=probe, results=[r_open]),
             0x50cf61: stub(0x50cf61, CDECL(4), probe=probe, results=[r_read]), 0x50ca3e: stub(0x50ca3e, CDECL(5), probe=probe, derefs=[(2, 32)]),
             0x52139c: stub(0x52139c, STDCALL(3), probe=probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe),
             0x4f438f: stub(0x4f438f, THISCALL(1), probe=probe, results=[r_a], writes=wa), 0x4f3c26: stub(0x4f3c26, THISCALL(1), probe=probe, results=[r_b], writes=wb)}
    g = {'word_63a4cd': E_DBG[(variant + n) % 4] if dbg else 0, 'word_63aa14': rng.randrange(1 << 16)}
    areas = [self_area(s), Area('objs', od.region_va(1), obj, image=False), magic_area, str_area]
    args = [word_arg(rng, id_)]
    return make('4f379c', areas, stubs, g, args, tuple(args), (profile, variant, id_))


# GEN-END

SPECS = {
    '4f379c': dict(id=1, va=0x4f379c, size=1162, gen=gen_4f379c, cleanup=4, status=True, ret=True, n=len(E_PROFILES) * 4),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'4f379c': 'open_entry'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
