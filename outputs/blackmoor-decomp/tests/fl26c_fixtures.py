"""FL-26 (batch c, the 0x62 interaction path): the fixtures shared by tests/test_fl26c_differential.py and tests/fl26c_original_oracle.py
for the function 0x424346.

`build(key, rng, n)` makes scenario n: the node, the object of the kind 0xb, the tables that the function indexes (at their original addresses
inside the image), the scripted callees and the globals. The scenarios cycle through cases (every kind of the jump table, each guard failing in
turn, each arm and the out-of-range arms), and three passes of the cycle vary the initial value of the result dword [node + 4] and the random
fill; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (SHAPES) are recording stubs (host boundaries); nothing
inside the function under test is patched. It returns the result, the normalised ordered call log and a digest of the ordered calls and the
memory read back.
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
    """The fields of Fl26cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl26c.h').read_text()
    body = re.search(r'typedef struct Fl26cWorld \{(.*?)\} Fl26cWorld;', text, re.S).group(1)
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
        if address == getattr(self, 'entry', None) and struct.unpack('<I', uc.mem_read(uc.reg_read(self._r['ESP']), 4))[0] == od.STOP:
            return      # the entry of the function under test itself (the outermost call), not a recursive call
        stub = self.stubs[address]
        if address == 0x50ca3e:      # printf-like callee: the call at 0x42497b pushes four arguments, every other call site three
            stub.args = 4 if struct.unpack('<I', uc.mem_read(uc.reg_read(self._r['ESP']), 4))[0] == 0x424980 else 3
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        derefs = getattr(stub, 'derefs', None)
        deref_data = ()
        if derefs:
            esp = uc.reg_read(self._r['ESP'])
            deref_data = tuple(bytes(uc.mem_read(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n)) for arg, n in derefs)
        super()._stub_hook(uc, address, size, user)
        if deref_data:
            self.calls[before] = self.calls[before] + deref_data
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops).
# 0x50ca3e is a cdecl varargs callee: 3 arguments are logged, 4 at the one call site that pushes 4 (Original20._stub_hook)
SHAPES = {0x4f6334: (1, True, 4), 0x50ca3e: (3, False, 0), 0x52139c: (3, False, 12), 0x44a2b7: (1, False, 0), 0x4c97b4: (0, True, 0),
          0x50cd50: (0, False, 0), 0x42639d: (2, True, 8)}
WORD_ARGS = {}




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



def common26(key, areas, stubs, probes, g=None, pointers=None, stack=(), args=(0,), profile=None):
    """Assembles a scenario: the areas, the recording stubs (each logs the `probes` bytes as they are at the call), the globals, the
    pointers of the native world (field -> (area name, offset)), the stack arguments of the original and the arguments of the native call."""
    sp = SPECS[key]
    for s in stubs.values():
        s.probe = list(probes)
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat={}, g=g or {}, ecx=od.region_va(0),
                           pointers=pointers or {}, word_args=WORD_ARGS, tick=None, profile=profile, stack=list(stack), args=tuple(args) + (0,) * (2 - len(args)))




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
    runner.entry = sc.va
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
UNTAKEN_ALLOWED = {}      # filled in from the oracle run, if a direction is unreachable (with the disassembly reason)


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
        derefs = [rest.pop() for _ in getattr(s, 'derefs', None) or ()][::-1]
        wa = word_args.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        entry.extend(bytes(0 if b == 0x71 else b for b in d) for d in derefs)      # (the native locals are zero, the original's stack is filled with 0x71)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out



# ---- the scenario generator -------------------------------------------------------------------------------------------------------

NODE_SZ = 0x50
T1, T2, T3, T4, T5 = 0x583bd5, 0x585801, 0x581a71, 0x587b2d, 0x585d65      # the tables (original addresses)
REC106 = 0x106
M32 = 0xffffffff

PAIRS_DD = [(0, 0), (1, 2), (2, 1), (-1, 1), (1, -1), (0x7fffffff, -0x80000000), (-0x80000000, 0x7fffffff), (-3, -3), (-5, -2), (-2, -5),
            (0x10000, 0x10000), (0x10000, 0), (0, 0x10000), (0x10001, 1), (1, 0x10001)]
PAIRS_WW = [(0, 0), (1, 2), (2, 1), (-1, 1), (1, -1), (0x7fff, -0x8000), (-0x8000, 0x7fff), (5, 5), (-7, -7), (-1, -1)]
PAIRS_XB = [(0, 0), (1, 2), (2, 1), (M32, -1), (M32, 1), (1, -1), (0x10000, 0), (0x10001, 1), (0xffff, -1), (0xffff8000, -0x8000), (0x8000, -0x8000),
            (0x7fff, 0x7fff), (5, 5), (7, -7)]
S_LIVE = (1, 5, 6)
S_DEAD = (0, 2, 4, 7, 0x10001, 0x10005, 0x10006, M32)
# kind 6, b = 3: (e, f, v) with e <= f (a range) and e > f (the wrapped range through 0x59f)
TRIPLES = [(10, 20, 9), (10, 20, 10), (10, 20, 15), (10, 20, 20), (10, 20, 21), (-5, -1, -6), (-5, -1, -5), (-5, -1, -1), (-5, -1, 0), (7, 7, 7), (7, 7, 6),
           (7, 7, 8), (-0x80000000, 0x7fffffff, 0), (-0x80000000, 0x7fffffff, -1), (0, 0, 0), (0, 0, -1), (0, 0, 1), (0x600, 0x7ff, 0x600), (0x600, 0x7ff, 0x7ff),
           (100, 5, 3), (100, 5, 5), (100, 5, 6), (100, 5, 99), (100, 5, 100), (100, 5, 0x59f), (100, 5, 0x5a0), (100, 5, -1), (100, 5, 0), (0x59f, 5, 0x59f),
           (0x59f, 5, 0x5a0), (0x5a0, 5, 0x59f), (0x5a0, -1, 0x5a0), (0x5a0, -1, -1), (0x5a0, -1, 0), (0x600, 0x10, 0x59f), (0x600, 0x10, 0x600),
           (-5, -10, -5), (-5, -10, -6), (-5, -10, 0), (-5, -10, -10), (100, 50, 30), (100, 50, 60), (100, 50, 0), (100, 50, 50), (100, 50, 51),
           (100, 50, 0x5a0), (0x900, 0x7ff, 0x7ff), (0x900, 0x7ff, 0x800), (0x900, 0x7ff, 0x900), (0x900, 0x7ff, 0x600)]
RLIST = [0, 5, 99, 100, 101, -1, -99, -100, 0x7fffffff, -0x80000000, 1234567, 250]
B20 = [-0x8000, -1, 0, 1, 50, 100, 101, 0x7fff]
DEFAULT_KINDS = [7, 8, 10, 18, 19, 0x17, 0x18, 0x100, 0x7fff, -1, -2, -0x8000]
PASSES = 3


def cases():
    """The cases (one dict each), in the order the scenarios cycle through them."""
    out = []
    add = lambda **kw: out.append(kw)
    add(kind=0)
    for b in (1, 0, 2, -1):
        for t in (0, 1, 2, 0x100, 0x10000, 0x10001):
            for wm in ('eq', 'ne'):
                add(kind=1, b=b, t=t, wm=wm)
    for z in (0, 1, 0x10000, 0x100):
        for wm in ('eq', 'ne'):
            for r24 in ('p', 'zero', 'other'):
                add(kind=0xb, z=z, wm=wm, r24=r24)
    for x, y in PAIRS_XB:
        add(kind=2, t=x, b=y)
        add(kind=3, t=x, b=y)
    for b in (1, 0, 2, -1, -0x8000):
        for r in (0, 1, 0x100, 0x10000, M32):
            add(kind=0x11, b=b, r=r)
    for x, y in PAIRS_WW:
        add(kind=0xf, w=x, b=y)
        add(kind=0xc, w=x, a=y)
    for b in (1, 2, 0, 3, -1):
        for v in (0, 1, 0x10000, 0x100, M32):
            add(kind=0x10, b=b, v=v)
    for mode in (1, 2, 3):
        for t, w in PAIRS_WW:
            add(kind=9, mode=mode, t=t, w=w)
    for mode in (0, 4, -1, 0x100, -0x8000, 0x7fff):
        add(kind=9, mode=mode, t=3, w=3)
    for v, d in PAIRS_DD:
        add(kind=4, v=v, d=d)
        add(kind=5, v=v, d=d)
    for kind in (0xd, 0xe):
        for s in S_LIVE:
            for v, d in PAIRS_DD:
                add(kind=kind, s=s, v=v, d=d)
        for s in S_DEAD:
            for v, d in PAIRS_DD[:2]:
                add(kind=kind, s=s, v=v, d=d)
    for s in S_LIVE + S_DEAD:
        add(kind=0x16, s=s)
    for b in (0, 1, 2):
        for v, d in PAIRS_DD:
            add(kind=6, b=b, v=v, d=d)
    for e, f, v in TRIPLES:
        add(kind=6, b=3, e=e, f=f, v=v)
    for b in (4, 5, -1, 0x100, 0x7fff, -0x8000):
        add(kind=6, b=b)
    for z in (1, 0x100, 0x10000, M32):
        add(kind=0x14, z=z, w=1, b=50, r=5)
    for w, rs in ((0, RLIST), (1, RLIST), (0x100, RLIST[:3] + RLIST[5:7]), (-0x8000, RLIST[:3] + RLIST[5:7])):
        for b in B20:
            for r in rs:
                add(kind=0x14, z=0, w=w, b=b, r=r)
    for v in (0, 1, 0x10000, 0x100, M32):
        add(kind=0x15, v=v)
    for k in DEFAULT_KINDS:
        add(kind=k)
    return out


CASES = cases()


def gen_424346(rng, n):
    case, pass_ = CASES[n % len(CASES)], n // len(CASES)
    kind = case['kind']
    initial = (0x5a5a5a5a, 0, 1)[pass_ % 3]
    node_va, obj_va, rr_va, self_va = od.region_va(1), od.region_va(2), od.region_va(3), od.region_va(0)
    node = bytearray(rng.randbytes(NODE_SZ))
    obj = bytearray(rng.randbytes(0x20))
    rr = bytearray(rng.randbytes(0x30))
    self_ = bytearray(rng.randbytes(0x700))
    t1, t2, t3 = (bytearray(rng.randbytes(0x44)) for _ in range(3))
    t4 = bytearray(rng.randbytes(0x42))
    t5 = bytearray(rng.randbytes(4 * REC106 + 8))
    t5m = bytearray(rng.randbytes(8))      # the record -1: only its two dwords (the bytes above it are other globals)
    g = {'word_583a29': rng.randrange(0x10000), 'word_58c94f': rng.randrange(0x10000), 'word_5bb20a': rng.randrange(0x10000),
         'word_63a4cd': rng.choice([0, 1, 0x100, 0xffff]), 'value_5bb202': rng.choice([0, 1, 0x10000]), 'value_5bb57b': rng.randrange(1 << 32),
         'value_585d37': rng.randrange(1 << 32), 'value_585d41': rng.randrange(1 << 32), 'value_585d4b': rng.randrange(1 << 32),
         'value_5c3a47': rng.choice([0, 1, 0x100])}
    a = rng.choice([-3, -2, -1, 0, 1, 2, 3, 4, 7, -8])
    b = case.get('b', rng.choice([-1, 0, 1, 2, 3, 0x7fff, -0x8000, 0x1234]))
    d = rng.randrange(1 << 32)
    e = rng.randrange(1 << 32)
    f = rng.randrange(1 << 32)
    q = [rng.choice([-1, 0, 1, 0x7fff, -0x8000]), rng.choice([-1, 0, 1, 0x7fff, -0x8000]), rng.randrange(0x10000), rng.randrange(0x10000)]   # words at q + 0, 2, 4, 6
    rand_result = rng.randrange(1 << 32)
    r4f = rng.choice([0, 1, 0x100, M32])

    def word(v):
        return v & 0xffff

    if kind == 1:
        a = rng.choice([-5, -2, 0, 1, 3, 7])
        g['word_583a29'] = word(a) if case['wm'] == 'eq' else word(a + rng.choice([1, -1, 0x100, 0x8000]))
        for i in range(0, 0x44, 4):
            put32(t1, i, rng.choice([0, 1, 2, 0x100]))
        put32(t1, (a + 8) * 4, case['t'])
    elif kind in (2, 3):
        a = rng.choice([-5, -2, 0, 1, 3, 7])
        t = t2 if kind == 2 else t3
        for i in range(0, 0x44, 4):
            put32(t, i, rng.choice([case['t'], case['t'] ^ 1, case['t'] + 1, 0, M32]))
        put32(t, (a + 8) * 4, case['t'])
    elif kind == 0xb:
        a = rng.choice([-3, 0, 1, 5, -0x8000, 0x7fff])
        g['word_583a29'] = word(a) if case['wm'] == 'eq' else word(a + rng.choice([1, -1, 0x100, 0x8000]))
        put32(self_, 0x614, case['z'])
        put32(node, 0x48, obj_va)
        put32(obj, 0x14, rr_va)
        put32(rr, 0x24, node_va if case['r24'] == 'p' else 0 if case['r24'] == 'zero' else rng.choice([node_va + 4, node_va ^ 0x10000, 1, M32]))
    elif kind == 0x11:
        a = rng.choice([-0x8000, -1, 0, 1, 0x7fff, 300])
        r4f = case['r']
    elif kind == 0xf:
        g['word_58c94f'] = word(case['w'])
    elif kind == 0xc:
        g['word_5bb20a'] = word(case['w'])
        a = case['a']
    elif kind == 0x10:
        g['value_5bb202'] = case['v']
    elif kind == 9:
        q0 = rng.choice([-6, -3, -1, 0, 1, 2, 5, 7])
        q[0] = q0
        q[1] = case['w']
        q[3] = case['mode']
        for i in range(0, 0x42, 2):
            put16(t4, i, rng.choice([case['t'], case['t'] + 1, case['t'] - 1, 0, 0x7fff, -0x8000]))
        put16(t4, (q0 + 16) * 2, case['t'])
    elif kind == 4:
        g['value_585d37'] = case['v'] & M32
        d = case['d'] & M32
    elif kind == 5:
        g['value_585d41'] = case['v'] & M32
        d = case['d'] & M32
    elif kind in (0xd, 0xe, 0x16):
        a = (0, 1, 2, 3, -1)[(n + pass_) % 5]          # the record -1 (0x585c5f) is a valid record of the original
        for j in range(4):
            put32(t5, j * REC106, rng.choice([1, 5, 6, 0, 2]))
            put32(t5, j * REC106 + 4, rng.randrange(1 << 32))
        put32(t5m, 0, rng.choice([1, 5, 6, 0, 2]))
        put32(t5m, 4, rng.randrange(1 << 32))
        rec = t5m if a < 0 else t5
        put32(rec, 0 if a < 0 else a * REC106, case['s'])
        if kind != 0x16:
            put32(rec, 4 if a < 0 else a * REC106 + 4, case['v'] & M32)
            d = case['d'] & M32
    elif kind == 6:
        if case['b'] == 3:
            e, f = case['e'] & M32, case['f'] & M32
            g['value_585d4b'] = case['v'] & M32
        elif case['b'] in (0, 1, 2):
            g['value_585d4b'] = case['v'] & M32
            d = case['d'] & M32
    elif kind == 0x14:
        g['word_63a4cd'] = word(case['w'])
        rand_result = case['r'] & M32
    elif kind == 0x15:
        g['value_5c3a47'] = case['v']
    put32(node, 4, initial)
    put16(node, 0x10, kind)
    put16(node, 0x12, a)
    put16(node, 0x14, b)
    put32(node, 0x20, d)
    put32(node, 0x24, e)
    put32(node, 0x28, f)
    for i, w in enumerate(q):
        put16(node, 0x18 + 2 * i, w)
    if kind == 0x14:
        put32(node, 0x2c, case['z'])
        put32(node, 0x30, rng.randrange(1 << 32))
    stubs = {c: stub(c, None) for c in SHAPES}
    stubs[0x4f6334] = stub(0x4f6334, None, results=[r4f])
    stubs[0x50cd50] = stub(0x50cd50, None, results=[rand_result])
    areas = [Area('self', self_va, self_, image=False), Area('node', node_va, node, image=False), Area('obj', obj_va, obj, image=False),
             Area('rr', rr_va, rr, image=False), Area('t1', T1 - 0x20, t1), Area('t2', T2 - 0x20, t2), Area('t3', T3 - 0x20, t3),
             Area('t4', T4 - 0x20, t4), Area('t5', T5, t5), Area('t5m', T5 - REC106, t5m)]
    return common26('424346', areas, stubs, [('node', 0, NODE_SZ), ('rr', 0, 0x30)], g=g, stack=[node_va], args=(node_va,),
                    profile=(hex(kind & 0xffff), n % len(CASES), pass_))


SPECS = {
    '424346': dict(id=1, va=0x424346, size=1890, code=1782, gen=gen_424346, cleanup=4, n=len(CASES) * PASSES),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
