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
WORD_ARGS = {0x43ef77: (1,)}       # callee -> positions of stack arguments pushed from a 16-bit register with a stale upper half (the callee reads a word): the comparison masks them to 16 bits
BYTE_ARGS = {0x4d214b: (0,)}    # 0x4d2c20 pushes a char from cl with a stale upper part: the comparison masks it to 8 bits


def mask_raw(calls):
    """The original's raw call log (name, args ...) with the byte arguments of BYTE_ARGS (non-thiscall callees) masked to 8 bits before the normaliser turns stack-looking values into locals."""
    out = []
    for call in calls:
        call = list(call)
        for index in BYTE_ARGS.get(call[0], ()):
            call[1 + index] &= 0xff
        out.append(tuple(call))
    return out


def mask_bytes(entries):
    for entry in entries:
        for index in BYTE_ARGS.get(entry[0], ()):
            entry[2 + index] &= 0xff
    return entries


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
    calls = normalize(mask_raw(orig.calls), sc.stubs, sc.iat, sc.word_args)
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


# ---- 0x416af3 ---------------------------------------------------------------------------------------------------------------------

PA_OUT_OFF = 0x200            # the word buffer 'out' starts this far into its area (slack for negative word offsets)
PA_X20 = lambda off, n: ('x20', off, n)
PA_X40 = lambda word, off, val: ('x40', word, off, val)
PA_X80 = lambda m, k, offs: ('x80', m, k, offs)
PA_OPS = {
    'x20_zero': [PA_X20(1, 0)], 'x20_5': [PA_X20(3, 5)], 'x20_2': [PA_X20(-7, 2)], 'x20_1': [PA_X20(0, 1)], 'x20_3': [PA_X20(10, 3)], 'x20_wrap': [PA_X20(2, 0x80000000), PA_X40(7, 4, 0x11223344)],
    'x20_wrap2': [PA_X20(-3, 0x80000002)], 'x40': [PA_X40(0x1234, 5, 0xdeadbeef)], 'x40_neg': [PA_X40(0xffff, -9, 0x80000001), PA_X40(0, 0, 0)],
    'x80_m3': [PA_X80(3, 2, [4, -6])], 'x80_m1': [PA_X80(1, 3, [0, 9, 20])], 'x80_m2': [PA_X80(2, 1, [-4])], 'x80_m0': [PA_X80(0, 2, [3, 8])], 'x80_k0': [PA_X80(3, 0, [])],
    'x80_kneg': [PA_X80(3, -1, []), PA_X20(5, 1)], 'x80_kbig': [PA_X80(3, 0x80000000, [])], 'x80_m80': [PA_X80(0x80, 1, [2])], 'x80_m81': [PA_X80(0x81, 1, [-30])], 'x80_mff': [PA_X80(0xff, 2, [0, 130])],
    'mixed': [PA_X20(2, 4), PA_X40(9, -3, 0x01020304), PA_X80(2, 2, [6, 30]), PA_X20(40, 3)],
    'bad_first': [('bad', 0x00)], 'bad_21': [PA_X20(1, 2), ('bad', 0x21)], 'bad_a0': [PA_X40(1, 2, 3), PA_X80(1, 1, [1]), ('bad', 0xa0)], 'bad_c0': [('bad', 0xc0)], 'bad_ff': [PA_X20(0, 3), ('bad', 0xff)],
    'bad_60': [('bad', 0x60)], 'bad_10': [('bad', 0x10)],
}
PA_COUNTS = ['full', 'zero', 'neg', 'min', 'first']
PA_PROFILES = ([(kind, ops, 'full') for kind in (1, 2) for ops in PA_OPS] + [(kind, 'mixed', c) for kind in (1, 2) for c in PA_COUNTS[1:]]
               + [(kind, 'x20_5', 'zero') for kind in (0, 3, 0x81, 0xff)])
PA_SIZES = [0, 1, 3, 4, 5, 0x20, 0x21, 0x23]
PA_FLAGS = [0, 1, 0x10000, 0x80000000, 0x100]


def pa_stream(rng, ops):
    """(bytes of the stream, [offset of the op in the stream])."""
    s, starts = bytearray(), []
    for op in ops:
        starts.append(len(s))
        if op[0] == 'bad':
            s += bytes([op[1]]) + rng.randbytes(8)
        elif op[0] == 'x20':
            s += bytes([0x20]) + struct.pack('<I', op[1] & 0xffffffff) + struct.pack('<I', op[2] & 0xffffffff) + rng.randbytes((2 * op[2]) & 0xffffffff)
        elif op[0] == 'x40':
            s += bytes([0x40]) + struct.pack('<H', op[1]) + struct.pack('<I', op[2] & 0xffffffff) + struct.pack('<I', op[3])
        else:
            m, k, offs = op[1:]
            s += bytes([0x80, m]) + struct.pack('<I', k & 0xffffffff) + rng.randbytes(2 * m) + b''.join(struct.pack('<I', o & 0xffffffff) for o in offs)
    return s, starts


def gen_416af3(rng, n):
    (kind, opsname, countmode), variant = prof(n, PA_PROFILES)
    ops = PA_OPS[opsname]
    stream, starts = pa_stream(rng, ops)
    stream_va = od.region_va(1) + 1 + variant % 2
    area_stream = bytearray(rng.randbytes(1 + variant % 2)) + stream + bytearray(rng.randbytes(0x40))
    count = {'full': len(stream), 'zero': 0, 'neg': 0x80000000 | len(stream), 'min': 0xffffffff, 'first': starts[1] if len(starts) > 1 else len(stream)}[countmode]
    hdr = bytearray(rng.randbytes(0x20))
    put32(hdr, 3 + 0xa, count)
    hdr[3 + 0xe] = kind
    hdr_va = od.region_va(0) + 3
    out = bytearray(rng.randbytes(0x800))
    base = bytearray(rng.randbytes(0x400))
    size = PA_SIZES[(variant + n) % len(PA_SIZES)]
    flag = PA_FLAGS[(variant // 2 + n) % len(PA_FLAGS)]
    out_va = od.region_va(2) + PA_OUT_OFF + variant % 2
    base_va = od.region_va(3) + 0x40 + variant % 3
    probe = [('out', 0x100, 0x400)]
    stubs = {0x4c7314: stub(0x4c7314, THISCALL(2), probe=probe), 0x43ef77: stub(0x43ef77, THISCALL(3), probe=probe)}
    areas = [Area('hdr', od.region_va(0), hdr, image=False), Area('stream', od.region_va(1), area_stream, image=False), Area('out', od.region_va(2), out, image=False),
             Area('base', od.region_va(3), base, image=False)]
    args = [hdr_va, out_va, size, stream_va, base_va, flag]
    cycle = None
    if any(o[0] == 'bad' for o in ops) and kind in (1, 2):
        lo, hi, tail = (0x416b2c, 0x416b5f, 0x416c6f) if kind == 1 else (0x416ca8, 0x416cdb, 0x416e4c)
        cycle = {a for a in od.instruction_addresses(0x416af3, 870) if lo <= a <= hi} | {tail}
        # the endless cycle is only reached when the count lets the loop run up to the bad op
        if countmode != 'full':
            cycle = None
    return make('416af3', areas, stubs, {}, args, tuple(args), (kind, opsname, countmode, variant), endless=cycle)


# ---- 0x4db38a ---------------------------------------------------------------------------------------------------------------------

UC_MOVES = [(0, 0, 10, 10), (5, -5, 10, 10), (10, -10, 10, 10), (11, -11, 10, 10), (-12, 12, 10, 10), (3, 3, 0, 0), (0, 0, -5, -5), (-1, 1, -5, 7), (0x7fffffff, 0x80000000, 0x7fff, -0x8000),
            (0x80000000, 0x7fffffff, 3, 3), (50, -50, -0x8000, 0x7fff), (0x10000, -0x20005, 10, 10), (3, 20, 10, 5), (-30, -20, 7, 5)]
# (dword 0x583204, result of 0x4d57e8, of 0x4d5834, of 0x4d5316, debug word on)
UC_ARMS = [(2, 1, 1, 1, 1), (3, 0, 0, 0, 0), (4, 1, 0, 1, 0), (5, 0, 1, 0, 1), (0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (6, 0, 0, 1, 0), (0x80000002, 0, 0, 0, 1), (0xffffffff, 0, 0, 0, 0), (0, 0, 0, 1, 1)]
UC_INDEXES = [(0, 0), (1, 0), (2, 1), (4, 3), (3, 0xffffffff), (1, 2)]
UC_SLACK = 0x40
PT_VA = od.region_va(1)


def gen_4db38a(rng, n):
    (mi, ai), variant = prof(n, [(m, a) for m in range(len(UC_MOVES)) for a in range(len(UC_ARMS))])
    dx, dy, w1, w2 = UC_MOVES[mi]
    v, r57, r58, r53, dbg = UC_ARMS[ai]
    b0, b4 = UC_INDEXES[(variant + n) % len(UC_INDEXES)]
    x0, y0 = rng.randrange(-100, 100), rng.randrange(-100, 100)
    px, py = (x0 + dx) & 0xffffffff, (y0 + dy) & 0xffffffff
    s = bytearray(rng.randbytes(0x100))
    put32(s, 0x34, x0)
    put32(s, 0x38, y0)
    pt = bytearray(rng.randbytes(0x40))
    put32(pt, 0x11, px)
    put32(pt, 0x15, py)
    wtbl = Area('wtbl', 0x5b3790 - UC_SLACK, bytearray(rng.randbytes(0x80)), image=True, compare=False)
    dtbl = Area('dtbl', 0x5b30cc - UC_SLACK, bytearray(rng.randbytes(0x100)), image=True, compare=False)
    nz = [1, 0x100, 0x80000000, 0xdeadbeef]
    g = {'value_5d16cd': rnd32(rng), 'value_5d1683': rnd32(rng), 'value_583204': v, 'value_583186': rnd32(rng), 'value_58318a': rnd32(rng), 'value_58318e': rnd32(rng), 'value_583192': rnd32(rng),
         'value_5b44f0': b0, 'value_5b44f4': b4, 'value_583106': rnd32(rng), 'value_583102': rnd32(rng), 'value_5c3a53': rnd32(rng), 'value_5c3a57': rnd32(rng), 'word_5d2f0d': w1, 'word_5d2f0f': w2,
         'word_63a4cd': [1, 0x100, 0x8000, 0xffff][variant % 4] if dbg else 0}
    pre = [('g:value_5d16cd', 0, 4), ('g:value_5d1683', 0, 4)]
    probe = [('self', 0, 0xb0), ('g:value_5d16cd', 0, 4), ('g:value_5d1683', 0, 4), ('g:value_5c3a53', 0, 4)]
    if variant % 2:         # the game's callee: stores the pair through its argument (the function's local) and returns that same pointer
        s5 = stub(0x4daeb5, THISCALL(1), probe=pre, writes=[(0, 0, 0, 4, px), (0, 0, 4, 4, py)])
        s5.ret_arg = 0
    else:
        s5 = stub(0x4daeb5, THISCALL(1), probe=pre, results=[PT_VA + 0x11])
    stubs = {0x4dadff: stub(0x4dadff, THISCALL(0), probe=pre), 0x4daeb5: s5, 0x4dbb13: stub(0x4dbb13, THISCALL(0), probe=probe),
             0x4d57e8: stub(0x4d57e8, THISCALL(2), probe=probe, results=[rng.choice(nz) if r57 else 0]), 0x4db780: stub(0x4db780, THISCALL(0), probe=probe),
             0x4d5834: stub(0x4d5834, THISCALL(2), probe=probe, results=[rng.choice(nz) if r58 else 0]), 0x4db817: stub(0x4db817, THISCALL(0), probe=probe),
             0x4d5316: stub(0x4d5316, THISCALL(2), probe=probe, results=[rng.choice(nz) if r53 else 0]), 0x4d56e2: stub(0x4d56e2, THISCALL(3), probe=probe),
             0x50ca3e: stub(0x50ca3e, CDECL(10), probe=probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe=probe), 0x4dae88: stub(0x4dae88, THISCALL(2), probe=probe)}
    areas = [self_area(s), Area('pt', PT_VA, pt, image=False), wtbl, dtbl]
    return make('4db38a', areas, stubs, g, [], (), (mi, ai, b0, b4, variant % 2), pointers={'table_5b3790': ('wtbl', UC_SLACK), 'table_5b30cc': ('dtbl', UC_SLACK)})


# ---- 0x4d2c20 ---------------------------------------------------------------------------------------------------------------------

LT_BIAS = {      # probability that the scripted answer of (4d214b, 651, 67f, 6a7, 6cf) is non-zero
    'rand': (0.5, 0.5, 0.5, 0.5, 0.5), 'mostly': (0.3, 0.7, 0.7, 0.7, 0.7), 'upper': (0, 1, 1, 0, 0), 'lower': (0, 1, 0, 1, 0), 'digit': (0, 0, 0, 0, 1), 'none': (0, 0, 0, 0, 0), 'special': (1, 0, 0, 0, 0)}
LT_PROFILES = [(0, 'ascii', 'rand'), (1, 'ascii', 'special'), (4, 'ascii', 'upper'), (4, 'ascii', 'lower'), (4, 'ascii', 'digit'), (5, 'ascii', 'none'), (6, 'ascii', 'rand'), (8, 'mixed', 'rand'),
               (8, 'mixed', 'mostly'), (6, 'edge', 'upper'), (6, 'edge', 'lower'), (6, 'edge', 'digit'), (6, 'high', 'upper'), (6, 'high', 'lower'), (6, 'high', 'digit'), (6, 'high', 'rand'), (10, 'mixed', 'rand'), (3, 'ascii', 'mostly')]
LT_DBG = ['off', 'on_ok', 'on_a0', 'on_b0', 'on_both0']


def gen_4d2c20(rng, n):
    (length, charset, bias), variant = prof(n, LT_PROFILES)
    dbgcase = LT_DBG[(variant + n) % len(LT_DBG)]
    text_va, font_va, metrics_va = od.region_va(1) + 1 + variant % 2, od.region_va(2) + 0x700, od.region_va(3) + 0x200
    chars = bytearray()
    for _ in range(length):
        chars.append(rng.choice({'ascii': range(0x21, 0x7f), 'high': range(0x80, 0x100), 'mixed': [*range(1, 0x21), *range(0x21, 0x7f), *range(0x80, 0x100)], 'edge': [0x7e, 0x7f, 0x80, 0x81, 0xff]}[charset]))
    text = bytearray(rng.randbytes(1 + variant % 2)) + chars + b'\0' + bytearray(rng.randbytes(0x20))
    font = bytearray(rng.randbytes(0x1800))
    w4f, w51 = rng.choice([0, 1, 7, -3, 0x7fff, -0x8000]), rng.choice([0, 2, -5, 0x1234])
    w53, w55, w57 = rng.choice([0, 5, -3]), rng.choice([0, 2, -4]), rng.choice([0, 1, 9])
    for off, w in ((0x4f, w4f), (0x51, w51), (0x53, w53), (0x55, w55), (0x57, w57)):
        put16(font, 0x700 + off, w)
    metrics = bytearray(rng.randbytes(0x400))
    sel = rng.choice([0, 1, 2, 3, -1])
    x, y = rng.choice([0, 5, 0x7fff, -0x8000, -1, 100]), rng.choice([0, 7, 0x7fff, -0x8000, -1, 200])
    a = 0 if dbgcase in ('on_a0', 'on_both0') else rnd32(rng) | 1
    b = 0 if dbgcase in ('on_b0', 'on_both0') else rnd32(rng) | 1
    probs = LT_BIAS[bias]
    longn = 4 * length + 4

    def answers(p):
        return [rng.choice([1, 0x80000000, 0xff, 0x100]) if rng.random() < p else 0 for _ in range(longn)]
    probe = [('g:value_63a8e0', 0, 4), ('g:value_63a8e4', 0, 4), ('g:value_63a8e8', 0, 4)]
    writes = [(i, 2, 0, 2, rng.choice([-8, -1, 0, 1, 5, 20, 3, 0x41 - 0x30])) for i in range(length + 1)]
    stubs = {0x52139c: stub(0x52139c, STDCALL(3), probe=probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe=probe),
             0x4d214b: stub(0x4d214b, CDECL(3), probe=probe, results=answers(probs[0]), writes=writes), 0x50d651: stub(0x50d651, CDECL(1), probe=probe, results=answers(probs[1])),
             0x50d67f: stub(0x50d67f, CDECL(1), probe=probe, results=answers(probs[2])), 0x50d6a7: stub(0x50d6a7, CDECL(1), probe=probe, results=answers(probs[3])),
             0x50d6cf: stub(0x50d6cf, CDECL(1), probe=probe, results=answers(probs[4])), 0x4c5d4b: stub(0x4c5d4b, THISCALL(5), probe=probe, derefs=[(2, 16)])}
    g = {'value_63a8e0': rnd32(rng), 'value_63a8e4': rnd32(rng), 'value_63a8e8': rnd32(rng), 'value_63a8ec': rnd32(rng), 'word_63a4cd': 0 if dbgcase == 'off' else rng.choice([1, 0x100, 0x8000])}
    areas = [Area('text', od.region_va(1), text, image=False), Area('font', od.region_va(2), font, image=False), Area('metrics', od.region_va(3), metrics, image=False)]
    args = [text_va, font_va, metrics_va, word_arg(rng, x), word_arg(rng, y), a, b, word_arg(rng, sel)]
    return make('4d2c20', areas, stubs, g, args, tuple(args), (length, charset, bias, dbgcase, variant))


# GEN-END

SPECS = {
    '4c6929': dict(id=1, va=0x4c6929, size=769, gen=gen_4c6929, cleanup=0x1c, status=True, n=len(CM_PROFILES) * 2),
    '416af3': dict(id=2, va=0x416af3, size=870, gen=gen_416af3, cleanup=0x18, status=True, n=len(PA_PROFILES) * 2),
    '4db38a': dict(id=3, va=0x4db38a, size=998, gen=gen_4db38a, cleanup=0, n=len(UC_MOVES) * len(UC_ARMS) * 2),
    '4d2c20': dict(id=4, va=0x4d2c20, size=1107, gen=gen_4d2c20, cleanup=0, ret=True, n=len(LT_PROFILES) * 5),
    # SPECS-END
}
KEYS = list(SPECS)
NAMES = {'4c6929': 'copy_masked', '416af3': 'apply_patches', '4db38a': 'update_cursor', '4d2c20': 'layout_text'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
