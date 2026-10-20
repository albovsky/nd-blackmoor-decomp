"""FL-33 (batch c): the fixtures shared by tests/test_fl33c_differential.py and tests/fl33c_original_oracle.py.

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
    """The fields of Fl33cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl33c.h').read_text()
    body = re.search(r'typedef struct Fl33cWorld \{(.*?)\} Fl33cWorld;', text, re.S).group(1)
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
WORD_ARGS = {}       # callee -> positions of stack arguments pushed from a 16-bit register with a stale upper half (the callee reads a word): the comparison masks them to 16 bits
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


def make(key, areas, stubs, g, stack, args, profile, iat=None, pointers=None, self_off=0, fault=None, endless=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) + self_off, self_off=self_off, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None, partial=None, fault=fault, endless=endless)


def run_abnormal(runner, sc, read):
    """The two ways in which the original does not return: it FAULTS (sc.fault = the address of the faulting instruction; the run must stop exactly there) or it NEVER FINISHES
    (sc.endless = the set of instruction addresses of the endless cycle: after a bounded number of instructions the run is inside the cycle, and a second bounded run through it changes
    neither memory nor the stack). Either way the memory is read back as it is, and the native port is compared on the calls made before and on its documented rejection."""
    import unicorn
    from unicorn import x86_const as X
    uc = runner.uc
    if sc.fault is not None:
        try:
            runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
        except unicorn.UcError:
            pass
        else:
            raise AssertionError('the original did not fault')
        if uc.reg_read(X.UC_X86_REG_EIP) != sc.fault:
            raise AssertionError('the original faulted at 0x%x, not at 0x%x' % (uc.reg_read(X.UC_X86_REG_EIP), sc.fault))
    else:
        try:
            runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read, limit=20000)
        except RuntimeError:
            pass
        else:
            raise AssertionError('the original returned')

        def snapshot():
            return [bytes(uc.mem_read(a, n)) for a, n in [*read.values(), (od.STACK_BASE, od.STACK_SIZE)]]
        before = snapshot()
        seen = set()
        for _ in range(64):                          # the instructions of the cycle, one by one
            eip = uc.reg_read(X.UC_X86_REG_EIP)
            seen.add(eip)
            uc.emu_start(eip, od.STOP, count=1)
        if not seen <= sc.endless:
            raise AssertionError('the original left the endless cycle: %s' % sorted(hex(a) for a in seen - sc.endless))
        if snapshot() != before:
            raise AssertionError('the endless cycle changed memory')
    return SimpleNamespace(eax=None, cleanup=0, executed=runner.executed, edges=getattr(runner, 'edges', set()), calls=runner.calls,
                           memory={name: bytes(uc.mem_read(a, n)) for name, (a, n) in read.items()})


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
    if sc.fault is not None or sc.endless is not None:
        orig = run_abnormal(runner, sc, read)
    else:
        orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
        orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if sc.fault is None and sc.endless is None and orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if SPECS[sc.key].get('retoff') is not None and orig.eax is not None and orig.eax != sc.ecx + SPECS[sc.key]['retoff']:
        raise AssertionError('the function did not return this + 0x%x' % SPECS[sc.key]['retoff'])
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') and orig.eax is not None:
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


# ---- 0x4c6929 ---------------------------------------------------------------------------------------------------------------------

def sgn(v):
    v &= 0xffffffff
    return v - (1 << 32) if v >= 1 << 31 else v


CM_RUNS = [(2, 3, 8, 0x10, 2, 7), (3, 5, -8, -0x10, 2, 15), (1, 4, 7, 0x11, 1, 3), (2, 2, -7, -0x11, 4, 9), (0, 4, 8, 0x10, 2, 7), (-1, 4, 8, 0x10, 2, 7), (2, 0, 8, 0x10, 2, 7), (2, -3, 8, 0x10, 2, 7),
           (1, 8, 0x7fff, 0x7fffffff, 2, 0x7fffffff), (1, 3, -0x8000, -0x80000000, 0xffff, -1), (3, 1, 0, 0, 3, 0), (2, 2, 1, 1, 2, 1), (2, 2, -1, -1, 2, 2)]
CM_PROFILES = [('run', *r, dbg, beq) for r in CM_RUNS for dbg in (0, 1) for beq in (0, 1)] + [('size', 'x'), ('size', 'y'), ('size', 'xy'), ('a0',), ('b0',), ('a0b0',), ('fault',), ('bigmask', 2, 3, 8, 0x10, 2, 0x10004, 0, 1)]
CM_DBG = [1, 0x100, 0x8000, 0xffff]
FAULT_4C6929 = 0x4c6ab5           # movsx eax, word ptr [eax+0x2f] with a == 0


def gen_4c6929(rng, n):
    prof_, variant = prof(n, CM_PROFILES)
    kind = prof_[0]
    rows, cols, hw, v1, bpp, r3w, dbg, beq = (prof_[1:] if kind in ('run', 'bigmask') else (2, 3, 8, 0x10, 2, 7, 1, 0))
    if kind in ('size', 'a0', 'b0', 'a0b0'):
        dbg = 1
    if kind == 'fault':
        dbg, beq = 0, 0
    a_va, rect_va = od.region_va(1) + 3, od.region_va(2) + 5
    src_start, dst_start, mask_start = od.region_va(3) + 0x100 + variant % 2, od.region_va(4) + 0x100 + variant % 3, od.region_va(5) + 0x80
    x0, y0 = rng.randrange(-20, 20), rng.randrange(-20, 20)
    r3x, r3y = rng.randrange(-5, 5), rng.randrange(-5, 5)
    r1 = [x0, y0, x0 + cols - 1, y0 + rows - 1]
    r3 = [r3x, r3y, r3w, rng.randrange(1 << 32)]
    a0 = (src_start - (y0 * hw + x0 * (bpp if bpp < 0x8000 else bpp - 0x10000))) & 0xffffffff
    c = (mask_start - (r3y * ((r3w + 1) & 0xffffffff) + r3x)) & 0xffffffff
    dx, dy = (r1[2] - r1[0]) & 0xffffffff, (r1[3] - r1[1]) & 0xffffffff
    X0, Y0 = rnd32(rng), rnd32(rng)
    ddx, ddy = dx, dy
    if kind == 'size':
        if 'x' in prof_[1]:
            ddx = (dx + rng.choice([1, 0x80000000, 0x10000, 0xffffffff])) & 0xffffffff
        if 'y' in prof_[1]:
            ddy = (dy + rng.choice([1, 0x80000000, 0x10000, 0xffffffff])) & 0xffffffff
    r2 = [X0, Y0, (X0 + ddx) & 0xffffffff, (Y0 + ddy) & 0xffffffff]
    if not dbg:
        r2 = [rnd32(rng) for _ in range(4)]
    s = bytearray(rng.randbytes(0x40))
    b = rnd32(rng) | 1
    if kind in ('b0', 'a0b0') or (not dbg and variant % 2 and beq and kind == 'run'):
        b = 0
    put32(s, 0xc, b if beq else b ^ rng.choice([1, 0x80000000, 0x100]))
    a = 0 if kind in ('a0', 'a0b0', 'fault') else a_va
    obj = bytearray(rng.randbytes(0x80))
    put32(obj, 3, a0)
    put16(obj, 3 + 0x2f, hw)
    rects = bytearray(rng.randbytes(0x80))           # the three rectangles start at +5, +0x25 and +0x45 of the area (unaligned)
    for off, r in ((5, r1), (0x25, r2), (0x45, r3)):
        for k in range(4):
            put32(rects, off + 4 * k, r[k])
    src = bytearray(rng.randbytes(0x600))
    dst = bytearray(rng.randbytes(0x600))
    mask = bytearray(rng.randbytes(0x10800 if kind == 'bigmask' else 0x400))      # a row step above 16 bits: the mask area is 0x10800 bytes (the next region is unused)
    for i in range(len(mask)):
        if rng.random() < 0.45:
            mask[i] = 0
    d = rnd32(rng)
    r1a, r2a, r3a = rect_va, rect_va + 0x20, rect_va + 0x40
    probe = [('self', 0, 0x20)]
    probe_dst = [('self', 0, 0x20), ('dst', 0x80, 0x100)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(11), probe=probe), 0x52139c: stub(0x52139c, STDCALL(3), probe=probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe),
             0x4c4067: stub(0x4c4067, THISCALL(5), probe=probe_dst, writes=[(0, 2, 0x10, 4, v1 & 0xffffffff), (0, 2, 0x24, 4, dst_start)]),
             0x4c4202: stub(0x4c4202, THISCALL(3), probe=probe_dst), 0x4c952f: stub(0x4c952f, THISCALL(1), probe=probe_dst)}
    areas = [self_area(s), Area('objA', od.region_va(1), obj, image=False), Area('rects', od.region_va(2), rects, image=False), Area('src', od.region_va(3), src, image=False),
             Area('dst', od.region_va(4), dst, image=False), Area('mask', od.region_va(5), mask, image=False)]
    g = {'word_63a4cd': CM_DBG[variant % 4] if dbg else 0, 'word_639895': bpp}
    args = [a, b, c, r1a, r2a, r3a, d]
    return make('4c6929', areas, stubs, g, args, tuple(args), (prof_, variant), fault=FAULT_4C6929 if kind == 'fault' else None)


# GEN-END

SPECS = {
    '4c6929': dict(id=1, va=0x4c6929, size=769, gen=gen_4c6929, cleanup=0x1c, status=True, n=len(CM_PROFILES) * 2),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'4c6929': 'copy_masked'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
