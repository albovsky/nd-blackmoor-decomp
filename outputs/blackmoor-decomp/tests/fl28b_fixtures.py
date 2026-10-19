"""FL-28 (batch b): the fixtures shared by tests/test_fl28b_differential.py and tests/fl28b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the
vtables, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The
scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees, the vtable entries and the import slots are recording
stubs (OS or host boundaries); nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that
changes `self` or a local of the caller: call number, argument or absolute address, offset, size, value or a byte string) so that a
function's re-reads after a call are exercised. Two more host/OS boundaries are modelled outside the function: the thread information block
behind fs (0x4497a0 links a structured-exception frame into fs:[0]; the run asserts that the chain is restored) and the x87 control word
(0x27f, the Windows process default: 53-bit precision, all exceptions masked). It returns the result, the normalised ordered call log and a
digest of the ordered calls, the return value and the memory read back.
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
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}
TIB, GDT = 0x7d000000, 0x7d010000


def parse_world():
    """The fields of Fl28bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl28b.h').read_text()
    body = re.search(r'typedef struct Fl28bWorld \{(.*?)\} Fl28bWorld;', text, re.S).group(1)
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


class Original27(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)]) and carry
    scripted writes (stub.writes = [(call number, argument or -1, offset, size, value)]: argument k = the pointer at stack argument k, -1 = the
    absolute address `offset`; a bytes value is written as it is). Records every (previous instruction, next instruction) pair, so that the
    direction of every jump is known. `seh` (the chain head) maps a thread information block behind fs (the OS boundary of the structured
    exception chain); `fpcw` sets the x87 control word."""

    def __init__(self, image_patches=(), regions=None, stubs=None, iat_slots=None, seh=None, fpcw=None):
        super().__init__(image_patches, regions, stubs, iat_slots)
        uc = self.uc
        self.seh = seh
        if seh is not None:
            from unicorn import x86_const as X
            uc.mem_map(TIB, 0x1000)
            uc.mem_map(GDT, 0x1000)
            uc.mem_write(TIB, struct.pack('<I', seh))

            def seg(base, limit, access, flags):
                return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access, ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
            uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc) + seg(TIB, 0xfff, 0x93, 0x4))
            uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
            uc.reg_write(X.UC_X86_REG_CS, 0x08)
            for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
                uc.reg_write(reg, 0x10)
            uc.reg_write(X.UC_X86_REG_FS, 0x18)
        if fpcw is not None:
            from unicorn import x86_const as X
            uc.reg_write(X.UC_X86_REG_FPCW, fpcw)

    def _count(self, uc, address, size, user):
        super()._count(uc, address, size, user)
        if not hasattr(self, 'edges'):
            self.edges = set()
        if getattr(self, 'last', None) is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        if not hasattr(self, '_calln'):
            self._calln = {}
        number = self._calln.get(address, 0)
        self._calln[address] = number + 1
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        derefs = getattr(stub, 'derefs', None)
        deref_data = ()
        esp = uc.reg_read(self._r['ESP'])
        if derefs:
            pointers = [(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n) for arg, n in derefs]
            # only a pointer to a local of the function under test (the stack) is read; any other value is logged by the arguments alone
            deref_data = tuple(bytes(uc.mem_read(at, n)) if od.STACK_BASE <= at < od.STACK_BASE + od.STACK_SIZE else b'' for at, n in pointers)
        for call, arg, offset, size_, value in getattr(stub, 'writes', ()):
            if call == number:
                at = offset if arg < 0 else struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0] + offset
                uc.mem_write(at, value if isinstance(value, bytes) else struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1)))
        super()._stub_hook(uc, address, size, user)
        if deref_data:
            self.calls[before] = self.calls[before] + deref_data
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# shapes of the callees: (stack arguments, thiscall, bytes the callee pops)
CDECL = lambda n: (n, False, 0)
STDCALL = lambda n: (n, False, 4 * n)
THISCALL = lambda n: (n, True, 4 * n)
WORD_ARGS = {}
DBG_VALUES = (0, 1, 0x8000, 0x100, 0xffff)      # the debug word 0x63a4cd: every non-zero value is on


def stub(callee, shape, probe=None, results=None, writes=None, derefs=None):
    nargs, this, cleanup = shape
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    s.writes = writes or []
    s.derefs = derefs or []
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)


def debug_areas(rng, dbg):
    """The debug word 0x63a4cd (a global patched into the image) and the two bytes behind it, which a dword read would see."""
    return {'word_63a4cd': dbg}, [Area('dbgnbr', 0x63a4cf, bytearray(rng.randbytes(2)), compare=False)]


def make(key, areas, stubs, g, stack, args, profile, iat=None, ecx=None, pointers=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) if ecx is None else ecx, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None)


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
    if sc.seh is not None:
        read['tib'] = (TIB, 4)
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh, fpcw=SPECS[sc.key].get('fpcw'))
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None:
        if orig.memory.pop('tib') != struct.pack('<I', sc.seh):
            raise AssertionError('the structured-exception chain at fs:[0] was not restored')
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the constructor did not return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    if SPECS[sc.key].get('ret16'):
        h.update(struct.pack('<H', orig.eax & 0xffff))
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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions): both directions of every conditional
    jump of the function must be taken by some scenario, except the ones in UNTAKEN_ALLOWED (an allowlist entry that is taken is stale)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


def normalize(calls, stubs, iat, word_args):
    """The original's call log as comparable lists: [callee, ecx, *args (word arguments by their low 16 bits), derefs, probe]."""
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
        entry.extend(derefs)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out


# ---- the scenario generators ------------------------------------------------------------------------------------------------------

VT_STUB_A = od.STUB_BASE + 0x900       # the vtable entries that the original reads and calls (stubs inside the mapped stub page)
VT_STUB_B = od.STUB_BASE + 0xa00


def vtable_area(slot, target, rng):
    """A vtable region: random bytes with the dword `target` at byte offset `slot`."""
    v = bytearray(rng.randbytes(0x100))
    put32(v, slot, target)
    return Area('vtbl', od.region_va(2), v, image=False)


def zstring(rng, length, size):
    """`size` bytes: `length` non-zero random bytes, a terminator, then random bytes."""
    s = bytearray(rng.randbytes(size))
    for i in range(length):
        if s[i] == 0:
            s[i] = 1 + i % 255
    s[length] = 0
    return s



# the table object of the slot-table methods (0x41de29, 0x41e043, 0x41e0b4, 0x41e250): a 0x1000-byte region (the table of 0x4b entries of 0x16 bytes at +0x1c, the words at +0x68e / +0x694 / +0x696)
SELF_SIZE = 0x1000
WORDS = [0, 1, 2, 0x7fff, 0x8000, 0xfffe, 0x1234, 0x100]       # entry words that are not 0xffff (0x8000 is -32768 when sign-extended)


def put8(d, off, v):
    d[off] = v & 0xff


def slot_object(rng, count=None, cap=None, used=None, free_at=()):
    """A random table object. `used`: the entry indices (0..0x4a) given a word other than 0xffff (None: random), `free_at` the ones given 0xffff."""
    s = bytearray(rng.randbytes(SELF_SIZE))
    for i in range(0x4b):
        free = rng.random() < 0.25
        put16(s, 0x1c + i * 0x16, 0xffff if free else rng.choice(WORDS))
    if count is not None:
        put16(s, 0x68e, count)
    if cap is not None:
        put16(s, 0x696, cap)
    for i in (used or ()):
        put16(s, 0x1c + i * 0x16, rng.choice(WORDS))
    for i in free_at:
        put16(s, 0x1c + i * 0x16, 0xffff)
    return s


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


SELF_PROBE = [('self', 0, SELF_SIZE)]


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def profiles_41e043():
    p = [('ge', c, k) for c, k in ((0, 0), (1, 0), (3, 3), (4, 3), (0x7fff, 0x7ffe), (-1, -1), (-3, -4), (5, -1))]
    p += [('hit', k, i) for k in (1, 2, 3, 5, 0x4b) for i in range(0, min(k, 6))]
    p += [('none', k) for k in (1, 2, 3, 6, 0x4b)]
    p += [('neg', c, k) for c, k in ((-1, 0), (-5, -3), (-0x8000, 1), (-2, 2))]
    return p


def gen_41e043(rng, n):
    (kind, *rest), variant = prof(n, profiles_41e043())
    if kind == 'ge':
        count, cap = rest
        s = slot_object(rng, count, cap, free_at=[0, 1] if variant % 2 else [])
    elif kind == 'hit':
        cap, at = rest
        s = slot_object(rng, rng.choice([0, cap - 1]) & 0xffff, cap, used=range(0, min(cap, 0x4b)), free_at=[at] + ([min(cap - 1, at + 2)] if variant % 2 else []))
    elif kind == 'none':
        cap = rest[0]
        s = slot_object(rng, rng.choice([0, cap - 1]) & 0xffff, cap, used=range(0, min(cap, 0x4b)), free_at=[min(cap, 0x4a)] if variant % 2 else [])
    else:
        count, cap = rest
        s = slot_object(rng, count, cap, free_at=[0] if variant % 2 else [])
    return make('41e043', [self_area(s)], {}, {}, [], (), (kind, *rest))


def profiles_42e493():
    p = [('sentinel', v) for v in (0x270f,)]
    p += [('other', v, d) for v in (0, 0x270e, 0x2710, -0x58f1, 1, -1, 0x7fff, -0x8000) for d in (1, 0, 2, -1, 0x101, -0x8000)]
    return p


SENTINEL_STUBS = lambda: {0x52139c: stub(0x52139c, STDCALL(3)), 0x4c97b4: stub(0x4c97b4, THISCALL(0))}


def world_values(rng):
    """All the globals of Fl28bWorld with random contents (the sources and the destinations of 0x42e493 and the extents of 0x4edfaf)."""
    g = {}
    for name, (address, size) in GLOBALS.items():
        g[name] = rng.randrange(1 << (8 * size))
    return g


def gen_42e493(rng, n):
    (kind, *rest), variant = prof(n, profiles_42e493())
    g = world_values(rng)
    g['word_5c3a05'] = 0x270f if kind == 'sentinel' else rest[0]
    if kind == 'other':
        g['word_5c3a0d'] = rest[1]
    if variant % 2 and kind == 'other':
        g['word_5c3a07'] = rng.choice([0x8000, 0xffff, 0x7fff, 0x270f, 0])
    return make('42e493', [], SENTINEL_STUBS(), g, [], (), (kind, *rest))


def gen_41de29(rng, n):
    masks = [0, (1 << 0x4b) - 1, 0x5555555555555555555 & ((1 << 0x4b) - 1), 0x2aaaaaaaaaaaaaaaaaa & ((1 << 0x4b) - 1), None, None]
    mask = masks[n % len(masks)]
    if mask is None:
        mask = rng.getrandbits(0x4b)
    s = slot_object(rng)
    for i in range(0x4b):
        put32(s, 0x1c + i * 0x16 + 2, (rng.randrange(1, 1 << 32) if (mask >> i) & 1 else 0))
    stubs = {0x51dc6c: stub(0x51dc6c, CDECL(1), SELF_PROBE), 0x4c2e5b: stub(0x4c2e5b, THISCALL(1), SELF_PROBE)}
    return make('41de29', [self_area(s)], stubs, {}, [], (), ('mask', hex(mask)))


def profiles_41e250():
    p = [('free', i) for i in (0, 1, 0x4a, -1, 7)]
    p += [('used', i, ptr, cnt) for i in (0, 1, 0x4a, -1, 33) for ptr in (0, 1, 0x80000000, 0xdeadbeef) for cnt in (0, 1, 2, 0x8000, 0xffff, 0x8001, 0x7fff, 0x1234)]
    return p


def gen_41e250(rng, n):
    (kind, *rest), variant = prof(n, profiles_41e250())
    slot = rest[0]
    s = slot_object(rng)
    base = 0x1c + slot * 0x16
    if kind == 'free':
        put16(s, base, 0xffff)
    else:
        put16(s, base, rng.choice(WORDS))
        put32(s, base + 2, rest[1])
        put16(s, 0x68e, rest[2])
    stubs = {0x51dc6c: stub(0x51dc6c, CDECL(1), SELF_PROBE), 0x4c2e5b: stub(0x4c2e5b, THISCALL(1), SELF_PROBE)}
    a = word_arg(rng, slot)
    return make('41e250', [self_area(s)], stubs, {}, [a], (a,), (kind, *rest))


EXTENTS = [0, 1, 2, 3, 0x7fffffff, 0x80000000, 0xffffffff, 0xfffffffe, 100, 101, 0x40000000, 0xc0000000, 640, 479]
WEXT = [0, 1, 2, -1, -2, 0x7fff, -0x8000, 0x1234, 0x21, 479]


def profiles_4edfaf():
    p = [('kind', k) for k in (3, 0, 1, 2, 4, 0x103, 0x80000003, 0xffffffff, 0x300)]
    return p


def gen_4edfaf(rng, n):
    (kind, k), variant = prof(n, profiles_4edfaf())
    s = bytearray(rng.randbytes(SELF_SIZE))
    put32(s, 0x4af, k)
    for off in (0x1c, 0x20, 0x24, 0x28, 0x665, 0x669, 0x66d, 0x671):
        put32(s, off, rng.choice(EXTENTS) if rng.random() < 0.8 else rng.randrange(1 << 32))
    g = {'word_5b3790': rng.choice(WEXT), 'word_5b3792': rng.choice(WEXT)}
    stubs = {0x4db993: stub(0x4db993, THISCALL(2), SELF_PROBE)}
    a = rng.randrange(1 << 32)
    return make('4edfaf', [self_area(s)], stubs, g, [a], (a,), (kind, k))


KINDS_41E0B4 = (0x39, 0x3b, 0x3e, 0x38, 0x3a, 0x3c, 0x3d, 0x3f, 0, 0xff, 0xb9)


def profiles_41e0b4():
    p = [('add', guard, k, c) for guard in ('ok', 'full', 'used') for k in KINDS_41E0B4 for c in (0, 1, 2, 5, -1, -3, 0x8000)]
    return p


def gen_41e0b4(rng, n):
    (kind, guard, k, c), variant = prof(n, profiles_41e0b4())
    slot = rng.choice([0, 1, 2, 0x4a, -1, 33, 7])
    ident = rng.choice([0, 1, 0x7fff, -1, -0x8000, 0x1234, 5, 0x55aa])
    s = slot_object(rng, count=rng.choice([0, 1, 5, -3]), cap=rng.choice([6, 0x4b, 0x7fff]), free_at=[slot])
    if guard == 'full':
        c0 = rng.choice([6, 7, 0x4b, 0x7fff])
        put16(s, 0x68e, c0)
        put16(s, 0x696, rng.choice([c0, c0 - 1, -5 & 0xffff, 0]) if variant % 2 else c0)
    elif guard == 'used':
        put16(s, 0x1c + slot * 0x16, rng.choice(WORDS))
    s[0x75a] = k
    put16(s, 0xf9b, c)
    put32(s, 0xfa1, rng.choice([0x20000000, 0xffffff00, 0x1000, 0, rng.randrange(1 << 32)]))
    # the stack dwords: the low words are the arguments
    a, b = word_arg(rng, slot), word_arg(rng, ident)
    stubs = {0x52139c: stub(0x52139c, STDCALL(3), SELF_PROBE), 0x4c97b4: stub(0x4c97b4, THISCALL(0), SELF_PROBE), 0x417b04: stub(0x417b04, THISCALL(3), SELF_PROBE)}
    WORD_ARGS[0x417b04] = (0,)
    return make('41e0b4', [self_area(s)], stubs, {}, [a, b], (a, b), (kind, guard, k, c))


SPECS = {
    '41e043': dict(id=1, va=0x41e043, size=113, gen=gen_41e043, cleanup=0, ret16=True, n=len(profiles_41e043()) * 3),
    '42e493': dict(id=2, va=0x42e493, size=205, gen=gen_42e493, cleanup=0, n=len(profiles_42e493()) * 2),
    '41de29': dict(id=3, va=0x41de29, size=220, gen=gen_41de29, cleanup=0, n=18),
    '41e250': dict(id=4, va=0x41e250, size=235, gen=gen_41e250, cleanup=4, n=len(profiles_41e250()) * 2),
    '4edfaf': dict(id=5, va=0x4edfaf, size=293, gen=gen_4edfaf, cleanup=4, n=len(profiles_4edfaf()) * 40),
    '41e0b4': dict(id=6, va=0x41e0b4, size=304, gen=gen_41e0b4, cleanup=8, n=len(profiles_41e0b4()) * 2),
}
KEYS = list(SPECS)
NAMES = {'41e043': 'find_free_slot', '42e493': 'take_pending', '41de29': 'clear_slots', '41e250': 'release_slot', '4edfaf': 'centre_rect', '41e0b4': 'add_slot'}


# ---- the record-driven methods (0x4205c1, 0x4209e8, 0x4f6ef4) -----------------------------------------------------------------------------

RECORDS_VA = 0x5bb5e5
REC_STRIDE = 0x8d
STUB_T1, STUB_T2 = od.STUB_BASE + 0xa00, od.STUB_BASE + 0xb00         # the indirect-call targets in the tables of `self` (0xf23 and 0xf4b)
KSET = (0, 1, 5, 0x13, 0x15, 0x7f, 0xff)                               # the table indices (bytes) that the fixtures give a stub
ZERO_AX = [0, 0x10000, 0xabcd0000]                                     # results with a zero low word (the original tests `movsx eax, ax`)
NONZERO_AX = [1, 0x8000, 0xffff, 0x12340001, 0xffff8000]


def records_area(rng, slot, rec_va):
    """The table of records of stride 0x8d (one record before and three after the used one so that a negative slot lies inside) whose dword at +0 for `slot` is rec_va."""
    data = bytearray(rng.randbytes(5 * REC_STRIDE))
    for i in range(5):
        put32(data, i * REC_STRIDE, rng.randrange(1 << 32))
    put32(data, (slot + 1) * REC_STRIDE, rec_va)
    return Area('records', RECORDS_VA - REC_STRIDE, data, image=True), {'records_5bb5e5': ('records', REC_STRIDE)}


def call_results(rng, pattern, count):
    return [rng.choice(NONZERO_AX) if (pattern >> k) & 1 else rng.choice(ZERO_AX) for k in range(count)]


TAILS = [(0x14, 0x14), (0, 0x14), (0x14, 1), (5, 0x13), (0x13, 5), (0x15, 0xff), (0x7f, 0), (1, 0x7f), (0xff, 0x15)]


def profiles_4205c1():
    return [(slot, cnt, pat) for slot in (0, 1, -1, 2) for cnt in (-1, 0, 1, 2, 3, 4) for pat in range(8 if cnt > 0 else 1)]


def gen_4205c1(rng, n):
    (slot, cnt, pat), variant = prof(n, profiles_4205c1())
    tail = TAILS[(n + variant) % len(TAILS)]
    selfd = bytearray(rng.randbytes(0x1400))
    for i, k in enumerate(KSET):
        put32(selfd, 0xf23 + 4 * k, STUB_T1 + 0x10 * i)
        put32(selfd, 0xf4b + 4 * k, STUB_T2 + 0x10 * i)
    rec = bytearray(rng.randbytes(0x800))
    put16(rec, 0x793, cnt)
    put32(rec, 0x795, od.region_va(2))
    rec[0x779], rec[0x77a] = tail
    ents = bytearray(rng.randbytes(0x800))
    kinds = [0, 1, 2, 3, 0xff, 2, 1, 0]
    for k in range(4):
        ents[k * 0x1d1 + 0x1b7] = kinds[(k + variant * 3 + n) % len(kinds)]
    recs, pointers = records_area(rng, slot, od.region_va(1))
    probe = [('self', 0, 0x40)]
    stubs = {0x420737: stub(0x420737, THISCALL(3), probe, results=call_results(rng, pat, 4)), 0x41fa11: stub(0x41fa11, THISCALL(1), probe),
             0x41fd08: stub(0x41fd08, THISCALL(1), probe), 0x42028e: stub(0x42028e, THISCALL(1), probe)}
    for i in range(len(KSET)):
        stubs[STUB_T1 + 0x10 * i] = stub(STUB_T1 + 0x10 * i, (0, True, 0), probe)
        stubs[STUB_T2 + 0x10 * i] = stub(STUB_T2 + 0x10 * i, (0, True, 0), probe)
    WORD_ARGS[0x420737] = (1,)
    a = word_arg(rng, slot)
    return make('4205c1', [self_area(selfd), Area('rec', od.region_va(1), rec, image=False), Area('ents', od.region_va(2), ents, image=False), recs],
                stubs, {}, [a], (a,), (slot, cnt, pat, tail), pointers=pointers)


def profiles_4209e8():
    return [(slot, cnt, pat, dbg) for slot in (0, 2, -1) for cnt in (-1, 0, 1, 2, 3, 5) for pat in range(8 if cnt > 0 else 1) for dbg in ((0, 1) if cnt > 0 else (0,))]


def gen_4209e8(rng, n):
    (slot, cnt, pat, dbg), variant = prof(n, profiles_4209e8())
    selfd = bytearray(rng.randbytes(0x2100))
    rec = bytearray(rng.randbytes(0x800))
    put16(rec, 0x79f, cnt)
    put32(rec, 0x7a1, od.region_va(2))
    ents = bytearray(rng.randbytes(0x100))
    kinds = [1, 2, 0, 3, 0xff, 2, 1, 2]
    for k in range(5):
        ents[k * 10 + 6] = kinds[(k + variant * 2 + n) % len(kinds)]
        ents[k * 10 + 9] = rng.choice([0, 1, 2, 0xff, 1])
        put16(ents, k * 10 + 7, rng.choice([0, 1, 5, -1, -4, 4, 0xfffe, 3]))
    tab = bytearray(rng.randbytes(80))
    recs, pointers = records_area(rng, slot, od.region_va(1))
    pointers['dwords_585801'] = ('tab', 32)
    probe = [('self', 0x1f00, 0x100)]
    stubs = {0x420737: stub(0x420737, THISCALL(3), probe, results=call_results(rng, pat, 5)), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4e9e84: stub(0x4e9e84, THISCALL(2), probe), 0x4ea06c: stub(0x4ea06c, THISCALL(1), probe)}
    WORD_ARGS[0x420737] = (1,)
    WORD_ARGS[0x4e9e84] = (0,)
    WORD_ARGS[0x4ea06c] = (0,)
    g, nbr = debug_areas(rng, dbg * rng.choice([1, 0x100, 0x8000]))
    a = word_arg(rng, slot)
    return make('4209e8', [self_area(selfd), Area('rec', od.region_va(1), rec, image=False), Area('ents', od.region_va(2), ents, image=False), recs,
                           Area('tab', 0x585801 - 32, tab, image=True), *nbr], stubs, g, [a], (a,), (slot, cnt, pat, dbg), pointers=pointers)


N_VALUES = (1, 2, 3, 7, 100, 0x7fffffff, 0, -2, 0x80000000, 0xfffffffe, 5000)
D_VALUES = (0, 1, 2, 3, -1, 7, 0x7fffffff, 0x80000000, 1000, 0x1000001)
LH_VALUES = ((0, 1), (5, 10), (-3, 100), (0x7fffffff, 0x80000000), (0x80000000, 5), (0, 0), (2, 3), (-5, -5), (1, 0x7fffffff))


def profiles_4f6ef4():
    p = [('s709c', r) for r in (0, 1, 0x100)]
    p += [('s162', 0, 1), ('s162', 1, 0), ('s162', 0, 0), ('s162', 5, 5)]
    p = [x for x in p]
    p += [('s6334', r) for r in (0, 1, 0x100)]
    p += [('nm1', d) for d in (0, 1)]
    p += [('calc', nn, dd, lo, hi) for nn in N_VALUES for dd in D_VALUES for (lo, hi) in LH_VALUES]
    return p


def gen_4f6ef4(rng, n):
    (kind, *rest), variant = prof(n, profiles_4f6ef4())
    arg = rng.choice([0, 1, 2, 0xffffffff, 0x80000000, 3])
    r709c = rest[0] if kind == 's709c' else rng.choice([1, 0x100, 0xffffffff])
    f162, f28f = (rest[0], rest[1]) if kind == 's162' else (rng.choice([1, 0x80000000, 0xffffffff]), rng.choice([1, 0x100]))
    r6334 = rest[0] if kind == 's6334' else rng.choice([1, 0x100, 0xffffffff])
    nres, divisor, lo, hi = 0xffffffff, rng.choice(D_VALUES), rng.randrange(1 << 32), rng.randrange(1 << 32)
    dbg = rest[0] if kind == 'nm1' else 0
    if kind == 'calc':
        nres, divisor, lo, hi = rest
    selfd = bytearray(rng.randbytes(0x400))
    rec_va = od.region_va(1)
    put32(selfd, 0x3ce, rec_va - arg * 0x5bb)
    rec = bytearray(rng.randbytes(0x300))
    put32(rec, 0x162, f162)
    put32(rec, 0x28f, f28f)
    put32(rec, 0x176, divisor)
    put32(rec, 0x17a, hi)
    put32(rec, 0x182, lo)
    probe = [('self', 0x3c0, 0x10), ('rec', 0x17a, 0x10)]
    stubs = {0x4f709c: stub(0x4f709c, THISCALL(0), probe, results=[r709c]), 0x4f6334: stub(0x4f6334, THISCALL(1), probe, results=[r6334]),
             0x4f81fa: stub(0x4f81fa, THISCALL(1), probe, results=[nres]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    g, nbr = debug_areas(rng, dbg * rng.choice([1, 0x100, 0x8000]))
    return make('4f6ef4', [self_area(selfd), Area('rec', rec_va, rec, image=False), *nbr], stubs, g, [arg], (arg,), (kind, *rest))


SPECS.update({
    '4205c1': dict(id=7, va=0x4205c1, size=374, gen=gen_4205c1, cleanup=4, n=len(profiles_4205c1()) * 3),
    '4209e8': dict(id=8, va=0x4209e8, size=438, gen=gen_4209e8, cleanup=4, n=len(profiles_4209e8()) * 2),
    '4f6ef4': dict(id=9, va=0x4f6ef4, size=424, gen=gen_4f6ef4, cleanup=4, ret=True, fpcw=0x27f, n=len(profiles_4f6ef4())),
})
KEYS = list(SPECS)
NAMES.update({'4205c1': 'run_entries', '4209e8': 'run_small_entries', '4f6ef4': 'advance_record'})


# ---- 0x41c544 and 0x41fa11 -----------------------------------------------------------------------------------------------------------

STR_LENGTHS = [0, 1, 2, 3, 4, 5, 8, 0x15, 0x30]


def profiles_41c544():
    return [(dbg, has, ln) for dbg in (0, 1, 0x100, 0x8000) for has in (0, 1) for ln in (STR_LENGTHS if has else [0])]


def gen_41c544(rng, n):
    (dbg, has, ln), variant = prof(n, profiles_41c544())
    selfd = bytearray(rng.randbytes(0x1100))
    rec = bytearray(rng.randbytes(0x800))
    src = bytearray(rng.randbytes(0x40))
    text = zstring(rng, ln, 0x80)
    probe = [('rec', 0, 0x800), ('g:value_5bb57b', 0, 4)]
    stubs = {0x423259: stub(0x423259, THISCALL(1), probe, results=[od.region_va(3) if has else 0]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe),
             0x52139c: stub(0x52139c, STDCALL(3), probe)}
    g, nbr = debug_areas(rng, dbg)
    g['value_5bb57b'] = rng.choice([0, 1, rng.randrange(1 << 32), 0xffffffff])
    return make('41c544', [self_area(selfd), Area('rec', od.region_va(1), rec, image=False), Area('src', od.region_va(2), src, image=False),
                           Area('text', od.region_va(3), text, image=False), *nbr], stubs, g, [od.region_va(1), od.region_va(2)], (od.region_va(1), od.region_va(2)), (dbg, has, ln))


def profiles_41fa11():
    p = [('early', c, d) for c in (0x1e, 0x1f, 0x7fff) for d in (0, 1)]
    p += [('dup', c, k) for c in (1, 2, 3, 5, 0x1d) for k in range(0, c, max(1, c // 3))]
    p += [('new', c, ln) for c in (-1, 0, 1, 2, 3, 0x1d) for ln in (0, 1, 3, 4, 0x10, 0x1f, 0x25, 0x30)]
    p += [('trace', 0x1e, 1)]
    return p


def gen_41fa11(rng, n):
    (kind, count, extra), variant = prof(n, profiles_41fa11())
    dbg = extra if kind in ('early', 'trace') else rng.choice([0, 1])
    selfd = bytearray(rng.randbytes(0x1000))
    put16(selfd, 0xf21, count)
    arg = bytearray(rng.randbytes(0x200))
    ln = extra if kind == 'new' else rng.choice([0, 3, 0x10])
    arg[0x196:0x196 + 0x40] = zstring(rng, ln, 0x40)
    buf = bytearray(rng.randbytes(0x1a0))
    if kind == 'dup':
        results = [rng.randrange(1, 1 << 32) for _ in range(extra)] + [0]
    else:
        results = [rng.randrange(1, 1 << 32) for _ in range(min(max(count, 1), 0x20))]
    probe = [('self', 0xea5, 0x80), ('self', 0xf20, 4), ('buf', 0, 0x1a0)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(3), probe), 0x4264e8: stub(0x4264e8, THISCALL(1), probe), 0x51ea75: stub(0x51ea75, THISCALL(1), probe, results=[od.region_va(3)]),
             0x50d550: stub(0x50d550, CDECL(3), probe, results=results), 0x51eac4: stub(0x51eac4, THISCALL(1), probe)}
    g, nbr = debug_areas(rng, dbg * rng.choice([1, 0x100, 0x8000]))
    return make('41fa11', [self_area(selfd), Area('arg', od.region_va(1), arg, image=False), Area('buf', od.region_va(3), buf, image=False), *nbr], stubs, g, [od.region_va(1)],
                (od.region_va(1),), (kind, count, extra))


SPECS.update({
    '41c544': dict(id=10, va=0x41c544, size=556, gen=gen_41c544, cleanup=8, n=len(profiles_41c544()) * 3),
    '41fa11': dict(id=11, va=0x41fa11, size=759, gen=gen_41fa11, cleanup=4, n=len(profiles_41fa11()) * 3),
})
KEYS = list(SPECS)
NAMES.update({'41c544': 'init_record', '41fa11': 'add_entry'})


# ---- 0x422a0a --------------------------------------------------------------------------------------------------------------------------

def profiles_422a0a():
    p = [('kind', k) for k in (0x38, 0x3a, 0x3c, 0, 0xff, 0x40)]
    p += [('run', c, idx) for c in (-1, 0, 1, 2, 3, 4) for idx in (-1, 0, 1, 2)]
    return p


def gen_422a0a(rng, n):
    (kind, *rest), variant = prof(n, profiles_422a0a())
    k = rest[0] if kind == 'kind' else (0x39, 0x3b, 0x3e)[(n + variant) % 3]
    c = rng.choice([2, 3, 4]) if kind == 'kind' else rest[0]
    idx = rng.choice([-1, 0, 1, 2]) if kind == 'kind' else rest[1]
    tbl617804 = bytearray(rng.randbytes(4 * 0x16))
    for j in range(4):
        put32(tbl617804, (idx + 1) * 0x16 + 6 + 4 * j, od.region_va(3 + j))
    words = bytearray(8)
    for j in range(4):
        put16(words, 2 * j, rng.choice([-1, 0, 1, 2]))
    objs = bytearray(rng.randbytes(4 * 0x84d))
    for w in range(4):
        objs[w * 0x84d + 0x1e + 0x84d - 0x84d] = 0
    for w in range(4):         # the objects for the words -1, 0, 1, 2 start at (w - 1) * 0x84d + 0x5d34d1; the area starts one object before 0x5d34d1
        objs[w * 0x84d + 0x1e] = rng.choice([0, 1, 2, 3, 4, 0xff, 2, 0, 3, 2])
        objs[w * 0x84d + 0x1f] = rng.choice([1, 2, 0, 3, 1, 2])
    tbl = bytearray(rng.randbytes(0x140))
    for j in range(4):
        tbl[0xb2 + j] = rng.choice([x for x in range(max(c, 1))] + [0xff, c & 0xff, (c + 1) & 0xff]) if rng.random() < 0.9 else 0xff
        tbl[0xb6 + j] = rng.choice([2, 2, 0, 1, 3])
    subs = [Area('sub%d' % j, od.region_va(3 + j), bytearray(rng.randbytes(0x80)), image=False) for j in range(4)]
    g = {'word_617e78': idx, 'word_618783': c, 'byte_617f42': k, 'value_618795': od.region_va(1), 'value_58318a': rng.choice([0, 1, rng.randrange(1 << 32)]),
         'value_583186': rng.choice([0, 0xffffffff, rng.randrange(1 << 32)]), 'value_5cf665': rng.randrange(1 << 32), 'value_5d15e3': rng.randrange(1 << 32),
         'value_5d191d': rng.choice([1, 0x80000000, 0xdeadbeef])}
    probe = [('r1', 0, 0x40), ('r2', 0, 0x40)]
    d = [(2, 16), (3, 16)]
    stubs = {0x4c5377: stub(0x4c5377, THISCALL(5), probe, derefs=d), 0x4c609b: stub(0x4c609b, THISCALL(6), probe, derefs=d), 0x4c5770: stub(0x4c5770, THISCALL(6), probe, derefs=d)}
    areas = [Area('tbl617804', 0x617804 - 0x16, tbl617804, image=True), Area('w', 0x61879d, words, image=True), Area('objs', 0x5d34d1 - 0x84d, objs, image=True),
             Area('r1', 0x617ec2, bytearray(rng.randbytes(0x40)), image=True), Area('r2', 0x617f02, bytearray(rng.randbytes(0x40)), image=True),
             Area('tbl', od.region_va(1), tbl, image=False), *subs]
    pointers = {'table_617804': ('tbl617804', 0x16), 'words_61879d': ('w', 0), 'objs_5d34d1': ('objs', 0x84d), 'rects_617ec2': ('r1', 0), 'rects_617f02': ('r2', 0)}
    return make('422a0a', areas, stubs, g, [], (), (kind, *rest, hex(k)), pointers=pointers)


SPECS.update({
    '422a0a': dict(id=12, va=0x422a0a, size=1088, code=1072, gen=gen_422a0a, cleanup=0, n=len(profiles_422a0a()) * 12),
})
KEYS = list(SPECS)
NAMES.update({'422a0a': 'draw_marked'})


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
