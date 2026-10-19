"""FL-24 (batch a): the fixtures shared by tests/test_fl24a_differential.py and tests/fl24a_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the record table at 0x5bb5e5 (stride 0x8d, one
slack record below it), the object of the target record, the nine-byte constants, the scripted callees and the globals. The scenarios
cycle through profiles (each guard of the chain failing in turn, the record-state guard too, then every arm of the function), and the
optional parts (the 0x5bb1ca flag, the position of the first differing byte of a nine-byte compare, the scripted answers, the loop
counts) vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (SHAPES) and the GetTickCount import (0x52a23c) are
recording stubs (OS or host boundaries); nothing inside the function under test is patched. It returns the result, the normalised
ordered call log and a digest of the ordered calls, the return value and the memory read back.
"""
import ctypes
import hashlib
from dataclasses import dataclass
from pathlib import Path
import re
import struct
import sys
from types import SimpleNamespace

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od

PROJECT = Path(__file__).resolve().parents[1]
TICK_SLOT = 0x52a23c
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl24aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl24a.h').read_text()
    body = re.search(r'typedef struct Fl24aWorld \{(.*?)\} Fl24aWorld;', text, re.S).group(1)
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
FMT = {1: '<B', 2: '<H', 4: '<I'}


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


class Original20(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)])."""

    def _count(self, uc, address, size, user):
        """Records the executed instructions as od.Original does, and every (previous instruction, next instruction) pair of them: after a
        conditional jump the next address says which way it went. A stub entered in between does not break the pair (the call returns to
        the next instruction of the function)."""
        super()._count(uc, address, size, user)
        if not hasattr(self, 'edges'):
            self.edges = set()
        if getattr(self, 'last', None) is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        super()._stub_hook(uc, address, size, user)
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
SHAPES = {0x4fb2e3: (1, True, 4), 0x4f6334: (1, True, 4), 0x44ecaf: (2, True, 8), 0x50ca3e: (6, False, 0), 0x44a2b7: (1, False, 0),
          0x4709bb: (1, True, 4), 0x4709de: (2, True, 8), 0x448d11: (4, True, 16),
          0x45741d: (2, True, 8), 0x47b709: (1, True, 4), 0x4a67f3: (2, True, 8), 0x465f8e: (3, True, 12), 0x482595: (2, True, 8)}
# stack arguments that are pushed from 16-bit registers (only the low 16 bits are meaningful), by position
WORD_ARGS = {0x4fb2e3: (0,), 0x44ecaf: (1,), 0x45741d: (1,), 0x482595: (0,)}
RECORDS_VA = 0x5bb5e5
REC = 0x8d


def stub(callee, probe, results=None):
    nargs, this, cleanup = SHAPES[callee]
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)


def set_gate(d, kind, off, fail, rng):
    """nz32 / z32: a dword that must be non-zero / zero; nz8 / z8: the same for a byte (its neighbours are made non-zero so that a dword
    read instead of the byte would see them); weq: a word equal to a value."""
    if kind == 'nz32':
        put32(d, off, 0 if fail else rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]))
    elif kind == 'z32':
        put32(d, off, rng.choice([1, 0x100, 0x10000, 0x01000000, 0x80000000]) if fail else 0)
    elif kind in ('nz8', 'z8'):
        d[off] = rng.choice([1, 0x80, 0xff]) if (kind == 'nz8') != fail else 0
        d[off + 1:off + 4] = bytes(rng.randrange(1, 256) for _ in range(3))


def records(rng, idx, state_fail, target_va, decoy_va):
    """The record table with the records -1 .. 4 (one slack record below the table): the target holds the object address and the state
    (1, or a bad state when `state_fail`), every other record the decoy address and the state the guard does not accept."""
    rec = bytearray(rng.randbytes(6 * REC))
    for i in range(-1, 5):
        base = (i + 1) * REC
        put32(rec, base, target_va if i == idx else decoy_va)
        bad = rng.choice([0, 2, 3, 0xffffffff, 0x101, 0x10001])
        put32(rec, base + 0x4d, (bad if state_fail else 1) if i == idx else (1 if state_fail else 0))
    return Area('records', RECORDS_VA - REC, rec)


def common(key, rng, d, obj, idx, sel, state_fail, flag, stubs, extra=(), consts=(), g=None, pointers=None, **kw):
    """Assembles a scenario around the `self` bytes d and the record object bytes obj."""
    sp = SPECS[key]
    areas = [Area('self', od.region_va(0), d, image=False), records(rng, idx, state_fail, od.region_va(1), od.region_va(4)),
             Area('obj', od.region_va(1), obj, image=False), Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False)]
    ptrs = {'records_5bb5e5': ('records', REC), **(pointers or {})}
    for table, const in consts:
        areas.append(Area('c%x' % table, table, bytearray(const), compare=False))
        ptrs['bytes_%x' % table] = ('c%x' % table, 0)
    areas.extend(extra)
    gl = {'value_5c39e5': sel, 'value_5bb1ca': flag, **(g or {})}
    probes = [('self', o, ln) for o, ln in sp.get('probes', ())] + [('records', 0, 6 * REC)]
    for s in stubs.values():
        s.probe = s.probe if s.probe is not None else probes
    now = kw.pop('now')
    iat = {TICK_SLOT: od.Stub('tick', result=now)} if sp.get('tick') else {}
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat=iat, g=gl, ecx=od.region_va(0),
                           pointers=ptrs, word_args=WORD_ARGS, tick=now if sp.get('tick') else None, profile=kw.pop('profile', None), stack=kw.pop('stack', []), args=kw.pop('args', (0, 0)), **kw)


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
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in x.probe]
    runner = Original20(image_patches, regions, sc.stubs, sc.iat)
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


def conditional_edges(va, size):
    """[(jcc address, mnemonic, taken-edge target, fall-through address)] of every conditional jump of the original function (loop and
    jecxz forms included), by linear disassembly of the code part."""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    out = []
    for i in md.disasm(pe.image[off:off + size], va):
        if i.mnemonic.startswith('j') and i.mnemonic != 'jmp' or i.mnemonic.startswith('loop'):
            out.append((i.address, i.mnemonic, int(i.op_str, 16), i.address + i.size))
    return out


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests)
UNTAKEN_ALLOWED = {
    '4a6574': {(0x4a6597, 'taken'): 'byte [+0x29] != 0 (jne 0x4a679f): the original reaches it only through the documented uninitialised-slot path '
                                    '(the tail reads the record object through a local that was never stored), which is not fixtured; the port rejects it'},
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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions): both directions of every conditional
    jump of the function must be taken by some scenario, except the ones in UNTAKEN_ALLOWED (an allowlist entry that is taken is stale)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


def normalize(calls, stubs, iat, word_args):
    """The original's call log as comparable lists: [callee or 'tick', ecx, *args (word arguments by their low 16 bits), probe]."""
    by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
    out = []
    for call in calls:
        s = by_name[call[0]]
        entry = [call[0], call[1] if s.this else 0]
        rest = list(call[2 if s.this else 1:])
        probe = rest.pop() if getattr(s, 'probe_addr', None) else None
        wa = word_args.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out


# ---- the scenario generators ------------------------------------------------------------------------------------------------------


def nine(rng, variant, active, const, obj, off):
    """Writes the nine-byte compare of the arm that runs: equal, or different at byte `position` (-1 equal, 0..8, 9 = not compared)."""
    position = ((variant >> 1) % 11) - 1
    if not active:
        return
    obj[off:off + 9] = const
    if 0 <= position <= 8:
        obj[off + position] ^= rng.choice([1, 0x40, 0x80, 0xff])
    elif position == 9:
        obj[off + 9] ^= 0x40


def results(rng, variant, shift):
    """The scripted answer of 0x4f6334: zero, or (when bits `shift`.. of the pass number read 3 mod 4: with the compare pass numbers
    of the callers, the passes that reach the call with a differing nine-byte compare) non-zero."""
    return [0 if (variant >> shift) % 4 != 3 else rng.choice([1, 5, 0x10000, 0x80000000])]


def gen_4d3bef(rng, n):
    value, variant = prof(n, [0, 1, 0x80, 0xff, 0x7f, 2])
    d = bytearray(rng.randbytes(0x480))
    if variant & 1:
        put32(d, 0x462, 0)
    return common('4d3bef', rng, d, bytearray(0x10), 0, 0, False, 0, {}, g={'byte_61c6ae': value}, now=0)


def gen_44edfb(rng, n):
    profiles = [('fail', 0), ('fail', 1), ('fail', 2), ('pass', 0x2787, None), ('pass', 0x2786, 0), ('pass', 0x2786, 1), ('pass', 0x2786, 2),
                ('pass', 0x2786, 0x100), ('pass', 0x2786, -1), ('pass', 0x2785, None), ('pass', 0x2784, None)]
    (kind, which, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
    failing = which if kind == 'fail' else None
    sel = which if kind == 'pass' else rng.choice([0x2785, 0x2786, 0x2787, 0x2000])
    d = bytearray(rng.randbytes(0x80))
    set_gate(d, 'nz32', 0x6b, failing == 0, rng)
    set_gate(d, 'z32', 0x2c, failing == 1, rng)
    put16(d, 0x1e, idx)
    if kind == 'pass' and sel == 0x2786:
        put16(d, 0x30, rest[0])
    elif kind == 'pass' and sel == 0x2784:
        put16(d, 0x30, rng.choice([0, 1, 2]))
    obj = bytearray(rng.randbytes(0x400))
    const = rng.randbytes(9)
    # the nine-byte compare reads the 49 bytes that the arm copied to self + 0x32 (or, with no copy, the bytes already there)
    word30 = struct.unpack_from('<h', d, 0x30)[0]
    src = {0x2785: 0x18d, 0x2786: {0: 0x1be, 1: 0x1be, 2: 0x1ef}.get(word30)}.get(sel)
    if src is not None:
        nine(rng, variant, kind == 'pass', const, obj, src)
    else:
        nine(rng, variant, kind == 'pass', const, d, 0x32)
    flag = 0 if variant & 1 == 0 else rng.choice([1, 0x100, 0xffffffff])
    stubs = {c: stub(c, None, results=results(rng, variant, 1) if c == 0x4f6334 else None) for c in (0x4f6334, 0x4fb2e3)}
    return common('44edfb', rng, d, obj, idx, sel, failing == 2, flag, stubs, consts=[(0x549824, const)], now=now, profile=(kind, which, *rest))


def gen_4cb3ab(rng, n):
    profiles = [('fail', i) for i in range(4)] + [('A', 'w'), ('A', 'q'), ('A', 'g0'), ('A', 'g1'), ('B', 'off'), ('B', 'w'), ('B', 'q'), ('B', 'g0'),
                                                  ('B', 'g1')]
    (kind, which), variant = prof(n, profiles)
    d = bytearray(rng.randbytes(0x200))
    failing = which if kind == 'fail' else None
    for i, off in enumerate((0xe, 0x12, 0x16, 0x15c)):
        set_gate(d, 'nz32', off, failing == i, rng)
    arm = rng.choice(['A', 'B']) if kind == 'fail' else kind
    if failing == 1:
        arm = 'A'     # (a port that lost the [+0x12] guard would otherwise read through the null pointer in arm B: it is caught by the memory instead)
    obj154, obj12 = od.region_va(5), od.region_va(6)
    tbl = od.region_va(7) + 0x100
    # the pointers are stored only when their own gate holds: a failing gate stays 0 (set_gate), so that a port without the guard goes on
    if failing != 2:
        put32(d, 0x16, tbl)
    if failing != 1:
        put32(d, 0x12, obj12)
    put32(d, 0x154, obj154 if arm == 'A' else 0)
    put32(d, 0x14e, 0 if (kind, which) == ('B', 'off') else rng.choice([1, 0x100, 0xffffffff]))
    a154 = bytearray(rng.randbytes(0x40))
    a12 = bytearray(rng.randbytes(0x40))
    entry = rng.choice([0, 1, 2, 5, 7, -2, -3, 30, 33])
    for buf, off in ((a154, 0x14), (a12, 5)):
        struct.pack_into('<h', buf, off, -1 if which == 'w' and kind == arm else entry)
    t = bytearray(rng.randbytes(0x400))
    q = 0x100 + 0x23 + entry * 4
    struct.pack_into('<h', t, q, -1 if which == 'q' and kind == arm else rng.choice([0, 1, 5, 20, -4, -20, 30]))
    struct.pack_into('<h', t, q + 2, rng.choice([0, 1, -1, 0x7fff, -0x8000, rng.randrange(-0x8000, 0x8000)]))
    struct.pack_into('<h', a12, 0, rng.choice([0, 1, -1, 0x7fff, -0x8000, 1234]))
    flags = bytearray(rng.randbytes(0x200))
    g63 = 0 if which == 'g0' else rng.choice([1, -1, 0x100, 0x7fff, -0x8000])
    stubs = {c: stub(c, [('self', 0, 0x200), ('flags', 0, 0x200)]) for c in (0x50ca3e, 0x44a2b7)}
    extra = [Area('a154', obj154, a154, image=False), Area('a12', obj12, a12, image=False), Area('tbl', od.region_va(7), t, image=False),
             Area('flags', 0x585801 - 0x80, flags)]
    sc = common('4cb3ab', rng, d, bytearray(0x10), 0, 0, False, 0, stubs, extra=extra, g={'word_63a4cd': 0 if failing == 1 else g63 if arm else 0},
                pointers={'flags_585801': ('flags', 0x80)}, now=0, profile=(kind, which))
    return sc


def gen_44eab1(rng, n):
    # profiles: the gate fails; each of the 4 loop-rectangle positions hits; none of the loop rectangles hit; the fixed rectangles A..D hit;
    # nothing hits
    profiles = [('gate',), ('loop', 0), ('loop', 1), ('loop', 2), ('loop', 3), ('A',), ('B',), ('C',), ('D',), ('none',), ('gate',)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    xs = [-32768, -1, 0, 1, 2, 9, 255, 0x7fff, rng.randrange(-32768, 32768)]
    x, y = rng.choice(xs), rng.choice(xs)
    d = bytearray(rng.randbytes(0x80))
    set_gate(d, 'nz32', 0x6b, kind == 'gate', rng)
    put16(d, 0x1e, idx)
    obj = bytearray(rng.randbytes(0x300))
    count = max(rng.choice([1, 2, 3, 4]), rest[0] + 1) if kind == 'loop' else rng.choice([0, 1, 3, -1, -32768, 2, 4])
    struct.pack_into('<h', obj, 0x25, count)

    def rect(offs, hit):
        """Four signed dwords at offs = (ylo, yhi, xlo, xhi): the point inside (often exactly on an edge), or one edge missing by 1 or more."""
        m = lambda: rng.choice([0, 0, 1, 2, 9, rng.randrange(0, 100000)])
        vals = [y - m(), y + m(), x - m(), x + m()]
        if not hit:
            k = rng.randrange(4)
            vals[k] = (y if k < 2 else x) + (1 if k % 2 == 0 else -1) * rng.choice([1, 1, 2, 70000])
        for off, v in zip(offs, vals):
            put32(obj, off, v)
    for i in range(4):     # the loop rectangles at +0xed + 16 i: x low +0xed, y low +0xf1, x high +0xf5, y high +0xf9
        rect((0xf1 + 16 * i, 0xf9 + 16 * i, 0xed + 16 * i, 0xf5 + 16 * i), kind == 'loop' and i == rest[0])
    for name, offs in (('A', (0x61, 0x69, 0x5d, 0x65)), ('B', (0x71, 0x79, 0x6d, 0x75)), ('C', (0x31, 0x39, 0x2d, 0x35)), ('D', (0x25d, 0x265, 0x259, 0x261))):
        rect(offs, kind == name)
    stubs = {0x44ecaf: stub(0x44ecaf, [('self', 0, 0x80), ('records', 0, 6 * REC)], results=[rng.randrange(1 << 32)])}
    return common('44eab1', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest),
                  stack=[(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)], args=(x, y))


def gen_46ebff(rng, n):
    profiles = [('fail', 0), ('fail', 1), ('fail', 2), ('fail', 3), ('c2', 0), ('c2', 9), ('c2', 10), ('c2', 11), ('c2', 0xff), ('c3', 0),
                ('c3', 1), ('c3', 3), ('c3', 8), ('c3', 12), ('c3', -1), ('other', 0)]
    (kind, which), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
    failing = which if kind == 'fail' else None
    sel = {'c2': 0x27c2, 'c3': 0x27c3}.get(kind, rng.choice([0x27c2, 0x27c3, 0x1, 0x27c4]))
    d = bytearray(rng.randbytes(0x200))
    set_gate(d, 'nz32', 0x46, failing == 0, rng)
    set_gate(d, 'z32', 0x5f, failing == 1, rng)
    set_gate(d, 'z32', 0x28, failing == 2, rng)
    put16(d, 0x1e, idx)
    byte52 = which if kind == 'c2' else rng.choice([0, 3, 9, 10, 200, 255])
    d[0x52] = byte52
    obj = bytearray(rng.randbytes(0xa000))
    count = which if kind == 'c3' else rng.choice([0, 1, 4, -1, 9])
    struct.pack_into('<h', obj, 0x21, count)
    k = 0 if byte52 < 10 else byte52 - 9
    const = rng.randbytes(9)
    nine(rng, variant, kind == 'c2', const, obj, 0x64d + k * 0x95 + 0x64)
    flag = 0 if variant & 1 == 0 else rng.choice([1, 0x100, 0xffffffff])
    stubs = {c: stub(c, [('self', 0, 0x100)], results=results(rng, variant, 1) if c == 0x4f6334 else None) for c in (0x4f6334, 0x4fb2e3)}
    for c in (0x4709bb, 0x4709de):
        stubs[c] = stub(c, [('self', 0, 0x100)], results=[rng.choice([0, 1, 0x7fffffff, 0xffffff00, rng.randrange(1 << 32)]) for _ in range(14)])
    stubs[0x448d11] = stub(0x448d11, [('self', 0, 0x100)])
    return common('46ebff', rng, d, obj, idx, sel, failing == 3, flag, stubs, consts=[(0x54c140, const)], g={'value_5d03b3': rng.randrange(1 << 32)},
                  now=now, profile=(kind, which))


def rect_into(rng, obj, x, y, offs, adj, hit):
    """Four signed dwords at offs = (ylo, yhi, xlo, xhi) such that the point (x, y) is inside the EFFECTIVE rectangle, often exactly on an
    edge (hit), or one effective edge misses it by one or more. `adj` is what the code adds to each stored edge before it compares (32-bit)."""
    m = lambda: rng.choice([0, 0, 1, 2, 9, rng.randrange(0, 100000)])
    eff = [y - m(), y + m(), x - m(), x + m()]
    if not hit:
        k = rng.randrange(4)
        eff[k] = (y if k < 2 else x) + (1 if k % 2 == 0 else -1) * rng.choice([1, 1, 2, 70000])
    for off, e, a in zip(offs, eff, adj):
        put32(obj, off, e - a)


def points(rng):
    xs = [-32768, -1, 0, 1, 2, 9, 255, 0x7fff, rng.randrange(-32768, 32768)]
    x, y = rng.choice(xs), rng.choice(xs)
    return x, y, [(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)]


def gen_4571e1(rng, n):
    profiles = [('gate', 0), ('gate', 1), ('r', 0), ('r', 1), ('r', 2), ('loop', 0, 0), ('loop', 1, 0), ('loop', 2, 1), ('loop', 3, 0), ('loop', 1, 1),
                ('final',), ('none',), ('wrap',)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0x80))
    set_gate(d, 'nz32', 0x3e, kind == 'gate' and rest[0] == 0, rng)
    set_gate(d, 'z32', 0x2c, kind == 'gate' and rest[0] == 1, rng)
    put16(d, 0x1e, idx)
    obj = bytearray(rng.randbytes(0x300))
    count = max(rng.choice([1, 2, 3, 4]), rest[0] + 1) if kind == 'loop' else rng.choice([0, 1, 3, -1, -32768, 2, 4])
    struct.pack_into('<h', obj, 0x25, count)
    struct.pack_into('<h', d, 0x2a, rest[0] if kind == 'loop' and rest[1] else rng.choice([-1, 0, 1, 2, 3, 5, 0x7fff]))
    if kind == 'loop' and rest[1] == 0:
        w = struct.unpack_from('<h', d, 0x2a)[0]
        if w == rest[0]:
            struct.pack_into('<h', d, 0x2a, rest[0] + 1)
    rect_into(rng, obj, x, y, (0x3b, 0x43, 0x37, 0x3f), (-5, 5, 0, 0), kind == 'r' and rest[0] == 0)
    rect_into(rng, obj, x, y, (0x4b, 0x53, 0x47, 0x4f), (5, 5, 10, -10), kind == 'r' and rest[0] == 1)
    rect_into(rng, obj, x, y, (0x5b, 0x63, 0x57, 0x5f), (0, 0, 0, 0), kind == 'r' and rest[0] == 2)
    for i in range(4):
        rect_into(rng, obj, x, y, (0x9b + 16 * i, 0xa3 + 16 * i, 0x97 + 16 * i, 0x9f + 16 * i), (0, 0, 0, 0), kind == 'loop' and i == rest[0])
    rect_into(rng, obj, x, y, (0x26f, 0x277, 0x26b, 0x273), (0, 0, 0, 0), kind == 'final')
    if kind == 'wrap':
        # R0 would hold the point but its stored low y edge is -2^31 + 2: minus 5 wraps to a large positive edge, so the point is below it
        rect_into(rng, obj, x, y, (0x3b, 0x43, 0x37, 0x3f), (-5, 5, 0, 0), True)
        put32(obj, 0x3b, 0x80000002 + rng.randrange(3))
        if variant % 2:
            put32(obj, 0x43, 0x7ffffffe + rng.randrange(2))     # + 5 wraps negative: the point is above it
            put32(obj, 0x3b, y + 5)
    stubs = {0x45741d: stub(0x45741d, [('self', 0, 0x80), ('records', 0, 6 * REC)], results=[rng.randrange(1 << 32)])}
    return common('4571e1', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest), stack=stack, args=(x, y))


def gen_47b4aa(rng, n):
    profiles = [('gate', 0), ('gate', 1), ('gate', 2), ('l1', 0), ('l1', 1), ('l1', 2), ('l1none',), ('l2', 0, 'ok'), ('l2', 1, 'ok'), ('l2', 2, 'ok'),
                ('l2', 3, 'ok'), ('l2', 1, 'b4'), ('l2', 2, 'b8'), ('l2', 0, 'b4'), ('l2', 3, 'b8'), ('byte0',), ('none',)]
    (kind, *rest), variant = prof(n, profiles)
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0x2c0))
    set_gate(d, 'nz32', 0x24, kind == 'gate' and rest[0] == 0, rng)
    set_gate(d, 'z32', 0x28, kind == 'gate' and rest[0] == 1, rng)
    set_gate(d, 'z32', 0x2c, kind == 'gate' and rest[0] == 2, rng)
    a_va, b_va = od.region_va(5), od.region_va(6)
    put32(d, 0xc, a_va)
    put32(d, 0x14, b_va)
    s28c = rng.choice([0, 1, 2, 3])
    put32(d, 0x28c, s28c)
    cnt = max(rng.choice([1, 2, 3, 4]), rest[0] + 1) if kind == 'l2' else rng.choice([0, 1, 2, 3, 4, -1, 0x80000000, 5])
    if cnt > 5 or cnt < 0:
        cnt = rng.choice([0, 1, 2]) if cnt >= 0 else cnt
    put32(d, 0x280, cnt)
    a = bytearray(rng.randbytes(0x600))
    a[0x35b] = 0 if kind == 'byte0' else rng.choice([1, 0x80, 0xff, 0x7f])
    for i in range(3):
        rect_into(rng, a, x, y, (0x2a1 + s28c * 0x30 + 16 * i + 4, 0x2a1 + s28c * 0x30 + 16 * i + 0xc, 0x2a1 + s28c * 0x30 + 16 * i, 0x2a1 + s28c * 0x30 + 16 * i + 8),
                  (0, 0, 0, 0), (kind == 'l1' and i == rest[0]) or (kind == 'byte0' and i == variant % 3))
    for i in range(5):
        rect_into(rng, a, x, y, (0x115 + 16 * i, 0x11d + 16 * i, 0x111 + 16 * i, 0x119 + 16 * i), (3, -3, 3, -3), kind == 'l2' and i == rest[0])
    b = bytearray(rng.randbytes(0x400))
    for e in range(24):
        for off in (4, 8):
            if rng.random() < 0.5:
                put32(b, e * 12 + off, 0)
    if kind == 'l2':
        e = (s28c * cnt + rest[0]) * 12
        put32(b, e + 4, rng.choice([1, 0x100, 0x80000000, 0xffffffff]) if rest[1] == 'b4' else 0)
        put32(b, e + 8, rng.choice([1, 0x100, 0x80000000, 0xffffffff]) if rest[1] == 'b8' else 0)
    extra = [Area('a', a_va, a, image=False), Area('b', b_va, b, image=False)]
    stubs = {0x47b709: stub(0x47b709, [('self', 0, 0x2c0)], results=[rng.randrange(1 << 32)])}
    return common('47b4aa', rng, d, bytearray(0x10), 0, 0, False, 0, stubs, extra=extra, now=0, profile=(kind, *rest), stack=stack, args=(x, y))



def gen_4a6574(rng, n):
    profiles = [('gate',), ('r1', 'b'), ('r1', 'w'), ('r1', 'skip'), ('r2', 'b'), ('r2', 'w'), ('r2', 'skip'), ('r3',), ('r4',), ('r5',), ('tail_in',),
                ('tail_6',), ('tail_out',)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0x100))
    set_gate(d, 'nz32', 0x86, kind == 'gate', rng)
    d[0x29] = 0
    d[0x20] = rng.choice([0, 1, 0x80, rng.randrange(256)])
    put16(d, 0x1e, idx)
    obj = bytearray(rng.randbytes(0x400))
    b65 = rng.choice([1, 0x80, 0xff]) if rest and rest[0] == 'b' else 0
    obj[0x65] = b65
    w63 = rng.choice([-5, 0, 1, 2, 3, 100, 0x7fff, -0x8000])
    struct.pack_into('<h', obj, 0x63, w63)
    # the word [+0x2e] against w63 - 1 (arm r1) and 0 (arm r2): 'w' passes the test, 'skip' fails it
    if kind == 'r1':
        w2e = w63 - 2 - rng.randrange(3) if rest[0] == 'w' else w63 - 1 + rng.randrange(3)
        w2e = max(-0x8000, min(0x7fff, w2e))
        if rest[0] == 'w' and not w2e < w63 - 1:
            w63, w2e = 5, 2
            struct.pack_into('<h', obj, 0x63, w63)
        if rest[0] == 'skip' and w2e < w63 - 1:
            w63, w2e = 5, 9
            struct.pack_into('<h', obj, 0x63, w63)
    elif kind == 'r2':
        w2e = rng.choice([1, 2, 0x7fff]) if rest[0] == 'w' else rng.choice([0, -1, -0x8000])
    else:
        w2e = rng.choice([-0x8000, -1, 0, 1, 5, 0x7fff])
    struct.pack_into('<h', d, 0x2e, w2e)
    rects = {'r1': (0x2b2, 0x2ba, 0x2ae, 0x2b6), 'r2': (0x2c2, 0x2ca, 0x2be, 0x2c6), 'r3': (0x1ba, 0x1c2, 0x1b6, 0x1be),
             'r4': (0x1da, 0x1e2, 0x1d6, 0x1de), 'r5': (0x3cb, 0x3d3, 0x3c7, 0x3cf), 'tail': (0x6a, 0x72, 0x66, 0x6e)}
    for name, offs in rects.items():
        hit = kind == name or (name == 'tail' and kind == 'tail_in')
        rect_into(rng, obj, x, y, offs, (0, 0, 0, 0), hit)
    g61 = 6 if kind in ('tail_6',) or (kind != 'tail_out' and variant % 3 == 0) else rng.choice([0, 5, 7, 0x106, 0x80000006, 0xffffffff])
    stubs = {0x4a67f3: stub(0x4a67f3, [('self', 0, 0x100), ('records', 0, 6 * REC)], results=[rng.randrange(1 << 32)])}
    return common('4a6574', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest), stack=stack, args=(x, y), g={'value_61d3c2': g61})


def gen_465c99(rng, n):
    profiles = [('gate',), ('c1',), ('c1', 'ylo'), ('c1', 'yhi'), ('c1', 'xlo'), ('c1', 'xmid'), ('c2',), ('c2', 'xhi'), ('c2', 'ymiss'), ('c3',),
                ('c4',), ('c5',), ('c7',), ('c6',), ('none',)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    k = [1, 2, 0, -1, 6, 7, 9, 3, -4][variant % 9]
    w2c = [0, 0, 1, 3, 2, -1, 5, 0, 0x7fff][(variant // 9) % 9]
    if kind == 'c4':
        w2c = rng.choice([0, 1, 2, -5, -32768])
    if kind == 'c5':
        w2c = 3
    if kind == 'c7':
        w2c = rng.choice([4, 5, 100, 0x7fff])       # above 3: the 0x58/0x60 rectangle hit takes neither of its two words
    d = bytearray(rng.randbytes(0x100))
    set_gate(d, 'nz32', 0x49, kind == 'gate', rng)
    put16(d, 0x1e, idx)
    struct.pack_into('<h', d, 0x2a, k)
    struct.pack_into('<h', d, 0x2c, w2c)
    obj = bytearray(rng.randbytes(0x600))
    # the row of k: lo = [+0xf8], ylo = [+0xfc], hi = [+0x100], yhi = [+0x104]
    base = 0xf8 + 16 * k
    h = rng.choice([2, 3, 10, 100, 70000])
    a = rng.randrange(1, h)
    odd = rng.randrange(2)
    ylo, yhi = y - rng.choice([0, 0, 1, 9]), y + rng.choice([0, 0, 1, 9])
    if kind == 'c1':
        lo = x - rng.choice([1, 1, 2, a])         # lo < x
        hi = lo + 2 * (h + rng.choice([0, 0, 1, 5]) + (x - lo)) + odd     # half >= x - lo: x <= lo + half
        if rest and rest[0] == 'ylo':
            ylo = y + 1
        elif rest and rest[0] == 'yhi':
            yhi = y - 1
        elif rest and rest[0] == 'xlo':
            lo = x                                     # x > lo fails
            hi = lo + 2 * h + odd
        elif rest and rest[0] == 'xmid':
            lo = x - 1
            hi = lo + 2 * 0 + odd - 2 * rng.choice([0, 1, 3])    # half <= 0 or so: x > lo + half
    elif kind == 'c2':
        lo = x - h - a                                 # x > lo + half
        hi = lo + 2 * h + odd
        if rest and rest[0] == 'xhi':
            hi = x                                     # x < hi fails
        elif rest and rest[0] == 'ymiss':
            ylo = y + 1
    else:
        lo = x + rng.choice([1, 5, 70000]) if rng.random() < 0.5 else x - rng.choice([1, 5, 70000])
        hi = lo + rng.choice([-9, 0, 7, 100000])
        ylo, yhi = y + rng.choice([1, 5]), y + rng.choice([6, 9])
    for off, v in ((0xf8, lo), (0xfc, ylo), (0x100, hi), (0x104, yhi)):
        put32(obj, 16 * k + off, v)
    rect_into(rng, obj, x, y, (0x6c, 0x74, 0x68, 0x70), (0, 0, 0, 0), kind == 'c3')
    rect_into(rng, obj, x, y, (0x5c, 0x64, 0x58, 0x60), (0, 0, 0, 0), kind in ('c4', 'c5', 'c7'))
    rect_into(rng, obj, x, y, (0x553, 0x55b, 0x54f, 0x557), (0, 0, 0, 0), kind == 'c6')
    stubs = {0x465f8e: stub(0x465f8e, [('self', 0, 0x100), ('records', 0, 6 * REC)], results=[rng.randrange(1 << 32)])}
    return common('465c99', rng, d, obj, idx, 0, False, 0, stubs, now=0, profile=(kind, *rest, k, w2c), stack=stack, args=(x, y))


def gen_482724(rng, n):
    profiles = [('a8',), ('s6',), ('g78',), ('a9',), ('sel',), ('arm', '3a2'), ('arm', '3a4'), ('arm', '39e'), ('arm', '3a0'), ('arm', 'none')]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    sel = {'s6': 0x27b6}.get(kind, rng.choice([0x27b4, 0x27b7, 0, 0xffffffff, 0x27b5 ^ 0x100]) if kind == 'sel' else 0x27b5)
    if kind in ('a8', 'g78', 'a9'):
        sel = rng.choice([0x27b5, 0x27b6])
    if kind == 'a8':
        sel = rng.choice([0x27b5, 0x27b6, 0x27b4])
    d = bytearray(rng.randbytes(0x300))
    d[0xa8] = 0 if kind == 'a8' else rng.choice([1, 0x80, 0xff])
    d[0xa9:0xac] = bytes(rng.randrange(1, 256) for _ in range(3))
    put16(d, 0xa9, rng.choice([0, 5, 0x7fff, 0x8000, 0xfffe, 0x100]) if kind == 'a9' else 0xffff)
    put16(d, 0x1e, idx)
    put32(d, 0x78, rng.choice([2, 0x100, 0x10000, 0xffffffff, 3, 0x80000000]) if kind == 'g78' else (variant >> 4) & 1)
    # the four words of the record object; w = word [+0xad] is the one the arm names (or none of them)
    pool = [v for v in range(-2, 14) if v not in (-1, 1)]
    r = {name: pool.pop(rng.randrange(len(pool))) for name in ('3a2', '3a4', '39e', '3a0')}
    if (variant >> 5) & 1:
        r['39e'] = r['3a2']        # two of the words equal: the first block falls through into the second chain with a match
    w = r[rest[0]] if kind == 'arm' and rest[0] != 'none' else (1 if (variant >> 4) & 1 else rng.choice([v for v in pool if v not in r.values()]))
    put16(d, 0xad, w)
    w92 = [0, 1, -1, 3, -3, 8, -2, 0][(variant >> 1) % 8]
    put16(d, 0x92, w92)
    d[0x91] = (variant & 1) * rng.choice([1, 0x80, 0xff])
    obj = bytearray(rng.randbytes(0x400))
    for name, off in (('3a2', 0x3a2), ('3a4', 0x3a4), ('39e', 0x39e), ('3a0', 0x3a0)):
        struct.pack_into('<h', obj, off, r[name])
    obj[0xfb] = rng.choice([0, 1, 0x80, 0xff])
    stubs = {0x482595: stub(0x482595, [('self', 0, 0x100), ('records', 0, 6 * REC)],
                            results=[rng.choice([0, 1, 0x100, 0xffffff00, 0x12345680, rng.randrange(1 << 32)]) for _ in range(4)])}
    return common('482724', rng, d, obj, idx, sel, False, 0, stubs, now=0, profile=(kind, *rest, w, w92))


def gen_470ffe(rng, n):
    profiles = [('gate',), ('first',), ('loop', 0), ('loop', 1), ('loop', 2), ('loop', 3), ('skip', 0), ('skip', 1), ('tail',), ('tail_b24',), ('tail_skip',),
                ('none',)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    x, y, stack = points(rng)
    d = bytearray(rng.randbytes(0xd80))
    skipping = kind in ('skip', 'tail_skip')
    set_gate(d, 'z8', 0xd3b, skipping, rng)       # (fills the three bytes after 0xd3b non-zero, 0xd3e among them: the gate byte comes second)
    set_gate(d, 'nz8', 0xd3e, kind == 'gate', rng)
    put16(d, 0xd28, idx)
    obj = bytearray(rng.randbytes(0x400))
    count = max(rng.choice([1, 2, 3, 4]), rest[0] + 1) if kind in ('loop', 'skip') else rng.choice([0, 1, 3, -1, 2, 4, -32768])
    struct.pack_into('<h', obj, 0x21, count)
    obj[0x24] = 0 if kind == 'tail_b24' else rng.choice([1, 0x80, 0xff])
    rect_into(rng, obj, x, y, (0x100, 0x108, 0xfc, 0x104), (0, 0, 0, 0), kind in ('first', 'gate'))     # (the gate scenarios hold the point: only the gate stops it)
    for i in range(4):
        rect_into(rng, d, x, y, (0x660 + 16 * i, 0x668 + 16 * i, 0x65c + 16 * i, 0x664 + 16 * i), (0, 0, 0, 0), kind in ('loop', 'skip') and i == rest[0])
    rect_into(rng, obj, x, y, (0x39, 0x41, 0x35, 0x3d), (0, 0, 0, 0), kind in ('tail', 'tail_b24', 'tail_skip'))
    g = {name: rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)]) for name in
         ('value_5b44f0', 'value_5b44f4', 'value_5d0377', 'value_5d162d', 'value_5d1631', 'value_5d1639')}
    return common('470ffe', rng, d, obj, idx, rng.choice([0, 0x27ad, 0x27a6, rng.randrange(1 << 32)]), False, 0, {}, now=0, profile=(kind, *rest), stack=stack,
                  args=(x, y), g=g)


def gen_4a6946(rng, n):
    profiles = [('fail', 0), ('fail', 1), ('fail', 2), ('fail', 3), ('s70',), ('other',), ('sw', 4), ('sw', 3), ('sw', 2), ('sw', 1), ('sw', 0), ('sw', 5),
                ('sw', 0x80000001), ('sw', 4)]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
    failing = rest[0] if kind == 'fail' else None
    sel = {'s70': 0x2770}.get(kind, rng.choice([0x2000, 0x276e, 0x2771, 0, 0xffffffff]) if kind == 'other' else 0x276f)
    if kind == 'fail':
        sel = rng.choice([0x2770, 0x276f])
    d = bytearray(rng.randbytes(0x100))
    set_gate(d, 'nz32', 0x86, failing == 0, rng)
    set_gate(d, 'z8', 0x8b, failing == 1, rng)
    set_gate(d, 'z32', 0x21, failing == 2, rng)
    put16(d, 0x1e, idx)
    put32(d, 0x25, rest[0] if kind == 'sw' else rng.choice([0, 1, 2, 3, 4]))
    obj = bytearray(rng.randbytes(0x400))
    count = rng.choice([-2, 0, 1, 2, 3, 5, 8])
    struct.pack_into('<h', obj, 0x298, count)
    # the two strings: 8..30 characters (at least nine bytes with the terminator), then the terminator
    s300 = bytes(rng.randrange(1, 256) for _ in range(rng.randrange(8, 31))) + b'\x00'
    s2cf = bytes(rng.randrange(1, 256) for _ in range(rng.randrange(8, 31))) + b'\x00'
    obj[0x300:0x300 + len(s300)] = s300
    obj[0x2cf:0x2cf + len(s2cf)] = s2cf
    t = (rest[0] - 1) & 0xffffffff if kind == 'sw' else None
    shown = s2cf if t in (1, 2) else s300
    const = bytearray(shown[:9])
    position = ((variant >> 1) % 11) - 1
    if 0 <= position <= 8:
        const[position] ^= rng.choice([1, 0x40, 0x80, 0xff])
    flag = 0 if variant & 1 == 0 else rng.choice([1, 0x100, 0xffffffff])
    if t is None or t > 3:
        flag = 0                     # (the kept string and word are uninitialised locals there: not fixtured)
    stubs = {c: stub(c, [('self', 0, 0x100), ('records', 0, 6 * REC)], results=results(rng, variant, 1) if c == 0x4f6334 else None) for c in (0x4f6334, 0x4fb2e3)}
    return common('4a6946', rng, d, obj, idx, sel, failing == 3, flag, stubs, consts=[(0x550964, bytes(const))], now=now, profile=(kind, *rest))


# the functions: id (the shim number), va, size from the ledger, the object-window probes of the call logs, whether GetTickCount is
# imported, whether the function returns a value (compared), the bytes it pops, the generator
SPECS = {
    '4d3bef': dict(id=1, va=0x4d3bef, size=46, gen=gen_4d3bef, n=12),
    '44edfb': dict(id=2, va=0x44edfb, size=466, gen=gen_44edfb, tick=True, probes=[(0, 0x80)], n=11 * 44),
    '4cb3ab': dict(id=3, va=0x4cb3ab, size=475, gen=gen_4cb3ab, n=13 * 12),
    '44eab1': dict(id=4, va=0x44eab1, size=510, gen=gen_44eab1, ret=True, cleanup=8, n=11 * 40),
    '46ebff': dict(id=5, va=0x46ebff, size=545, gen=gen_46ebff, tick=True, probes=[(0, 0x100)], n=16 * 44),
    '4571e1': dict(id=6, va=0x4571e1, size=572, gen=gen_4571e1, ret=True, cleanup=8, n=13 * 40),
    '47b4aa': dict(id=7, va=0x47b4aa, size=607, gen=gen_47b4aa, ret=True, cleanup=8, n=17 * 40),
    '4a6574': dict(id=8, va=0x4a6574, size=639, gen=gen_4a6574, ret=True, cleanup=8, n=13 * 40),
    '465c99': dict(id=9, va=0x465c99, size=757, gen=gen_465c99, ret=True, cleanup=8, n=15 * 81),
    '482724': dict(id=10, va=0x482724, size=740, gen=gen_482724, probes=[(0, 0x100)], n=10 * 64),
    '470ffe': dict(id=11, va=0x470ffe, size=690, gen=gen_470ffe, ret=True, cleanup=8, n=12 * 40),
    '4a6946': dict(id=12, va=0x4a6946, size=664, gen=gen_4a6946, code=648, tick=True, probes=[(0, 0x100)], n=14 * 44),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
