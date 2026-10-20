"""FL-29 (batch c): the fixtures shared by tests/test_fl29c_differential.py and tests/fl29c_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the
vtables, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The
scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees, the vtable entries and the import slots are recording
stubs (OS or host boundaries); nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that
changes `self` or a local of the caller: call number, argument or absolute address, offset, size, value or a byte string) so that a
function's re-reads after a call are exercised. Two more host/OS boundaries are modelled outside the function: the thread information block
behind fs and the x87 control word (neither is used by this batch's functions; kept from the shared harness). It returns the result, the normalised ordered call log and a
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
    """The fields of Fl29cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl29c.h').read_text()
    body = re.search(r'typedef struct Fl29cWorld \{(.*?)\} Fl29cWorld;', text, re.S).group(1)
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


class Original29(od.Original):
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
    runner = Original29(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh, fpcw=SPECS[sc.key].get('fpcw'))
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



# ---- helpers shared by the generators ------------------------------------------------------------------------------------------------

SELF_SIZE = 0x1000
RECORDS_VA = 0x5bb5e5
REC_STRIDE = 0x8d


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


def word_arg(rng, v):
    """A word argument as a stack dword whose upper half is left-over garbage (the original reads only the low word)."""
    return (v & 0xffff) | (rng.randrange(0x10000) << 16)


def records_area(rng, slot, rec_va):
    """The table of records of stride 0x8d (one record before and three after the used one so that a negative slot lies inside) whose dword at +0 for `slot` is rec_va."""
    data = bytearray(rng.randbytes(5 * REC_STRIDE))
    for i in range(5):
        put32(data, i * REC_STRIDE, rng.randrange(1 << 32))
    put32(data, (slot + 1) * REC_STRIDE, rec_va)
    return Area('records', RECORDS_VA - REC_STRIDE, data, image=True), {'records_5bb5e5': ('records', REC_STRIDE)}


def rand32(rng):
    """A random dword that is not near the stack of the original run (a call argument in that range is logged as a local of the function)."""
    while True:
        v = rng.randrange(1 << 32)
        if not od.STACK_BASE - 0x10 <= v < od.STACK_BASE + od.STACK_SIZE + 0x10:
            return v


def nonzero_bytes(rng, length, high=False):
    return bytes(rng.randrange(0x80, 0x100) if high and rng.random() < 0.5 else rng.randrange(1, 0x100) for _ in range(length))


def cstring(content, size, rng):
    """`size` bytes: the content, a terminator, then random bytes."""
    s = bytearray(rng.randbytes(size))
    s[:len(content)] = content
    s[len(content)] = 0
    return s


# ---- 0x4bf19a ------------------------------------------------------------------------------------------------------------------------------


def profiles_4bf19a():
    p = [('null', 5, 3), ('null', 0, 0)]
    p += [('low', n, 10) for n in (0, -1, -5, 0x80000000, 0xffffffff)]
    p += [('high', n, c) for n, c in ((11, 10), (1, 0), (0x80000000, 0x7fffffff), (0xffffffff, 0xfffffffe), (6, 5), (0x7fffffff, 0x7ffffffe))]
    p += [('ok', n, c) for n, c in ((1, 10), (10, 10), (5, 10), (0x7fffffff, 0x7fffffff), (5, 0x80000000), (1, 1), (0xffffffff, 0xffffffff), (3, 0xffffffff))]
    return p


def gen_4bf19a(rng, n):
    (kind, frame, count), variant = prof(n, profiles_4bf19a())
    selfd = bytearray(rng.randbytes(0x300))
    handle = bytearray(rng.randbytes(0x20))
    put32(handle, 8, count)
    h = 0 if kind == 'null' else od.region_va(1)
    probe = [('self', 0x2b0, 0x20)]
    stubs = {0x4bf38c: stub(0x4bf38c, THISCALL(0), probe)}
    iat = {0x52a530: stub(0x52a530, STDCALL(3), [('hdl', 0, 0x20)], results=[rng.randrange(1, 1 << 32) if variant != 1 else 0])}
    return make('4bf19a', [self_area(selfd), Area('hdl', od.region_va(1), handle, image=False)], stubs, {}, [h, frame & 0xffffffff], (h, frame & 0xffffffff),
                (kind, frame, count), iat=iat)


# ---- 0x434814 ------------------------------------------------------------------------------------------------------------------------------


def profiles_434814():
    return [(ln, high) for ln in range(0, 7) for high in (False, True)]


def gen_434814(rng, n):
    (ln, high), variant = prof(n, profiles_434814())
    src = cstring(nonzero_bytes(rng, ln, high), 0x20, rng)
    buf = bytearray(rng.randbytes(8))
    return make('434814', [Area('src', od.region_va(1), src, image=False), Area('buf', 0x63a590, buf, image=True)], {}, {}, [od.region_va(1)], (od.region_va(1),),
                (ln, high), pointers={'buf_63a590': ('buf', 0)})


# ---- 0x4471ca, 0x45b4ae, 0x461903, 0x4b5c5c ---------------------------------------------------------------------------------------------

FAMILY = {'4471ca': 0x15, '45b4ae': 0xb8e, '461903': 0x357, '4b5c5c': 0x39f}


def profiles_copy():
    p = [('ok', dbg, alias) for dbg in (0, 1, 0x100, 0x8000, 0xffff) for alias in (None, 'cb', 'ab')]
    p += [('null', dbg, alias) for dbg in (0, 1) for alias in (None, 'cb')]
    return p


def make_copy_gen(key):
    size = FAMILY[key]

    def gen(rng, n):
        (kind, dbg, alias), variant = prof(n, profiles_copy())
        SRC, DST, CELLS = od.region_va(1), od.region_va(2), od.region_va(3)
        src, dst = bytearray(rng.randbytes(size + 0x20)), bytearray(rng.randbytes(size + 0x20))
        cells = bytearray(rng.randbytes(0x20))
        put32(cells, 4, SRC)
        put32(cells, 8, rng.choice([0, 0x1000, 0xfffffff0, rng.randrange(1 << 32)]))
        a, b, c = CELLS, CELLS + 4, CELLS + 8
        if alias == 'cb':
            c = b
        if alias == 'ab':
            a = b
        p = DST if kind == 'ok' else 0
        probe = [('cells', 0, 0x20)]
        stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[p]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x42639d: stub(0x42639d, THISCALL(2), probe),
                 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
        g, nbr = debug_areas(rng, dbg)
        g['word_5c39e3'] = rng.choice([0, 1, -1, 0x7fff, -0x8000, 5])
        g['value_5bb57b'] = rng.choice([0, 0xffffffff, rand32(rng)])
        areas = [Area('cells', CELLS, cells, image=False), Area('src', SRC, src, image=False), *nbr]
        areas.append(Area('dst', DST, dst, image=False) if kind == 'ok' else Area('null', 0, bytearray(rng.randbytes(0x1000)), image=False))
        return make(key, areas, stubs, g, [a, b, c], (a, b, c), (kind, dbg, alias))
    return gen


# ---- 0x45bbd8 ------------------------------------------------------------------------------------------------------------------------------

ODD_POSITIVE = [1, 3, 0x7fff, 0x7ffffffd, 0x12345677]
NOT_ONE = [0, 2, 0x80000000, 0x80000001, 0x80000003, 0xffffffff, 0x7ffffffe, 0xfffffffe]       # words 0, 0, 0, -1, -1, -1, 0, 0
ANY_ROLL = [0, 1, 2, 3, 0x7fff, 0x80000000, 0x80000001, 0x80000002, 0x80000003, 0x80000004, 0xfffffffe, 0xffffffff, 0x12345678, 0x7ffffffd]
ARG_VALUES = [0, 1, 2, -1, -2, 3]
IDX_VALUES = [0, 1, -1, 2]


def profiles_45bbd8():
    return [(mask, ARG_VALUES[mask % 6], IDX_VALUES[mask % 4]) for mask in range(16)]


def gen_45bbd8(rng, n):
    (mask, argv, idx), variant = prof(n, profiles_45bbd8())
    rolls = []
    for i in range(4):
        rolls.append(rng.choice(ODD_POSITIVE) if (mask >> i) & 1 else rng.choice(NOT_ONE))
        rolls.append(rng.choice(ANY_ROLL))
    selfd = bytearray(rng.randbytes(0x400))
    put16(selfd, 0x21e, idx)
    rec = bytearray(rng.randbytes(0x500))
    recs, pointers = records_area(rng, idx, od.region_va(1))
    stubs = {0x50cd50: stub(0x50cd50, CDECL(0), [('self', 0x1b0, 0x150)], results=rolls)}
    a = word_arg(rng, argv)
    return make('45bbd8', [self_area(selfd), Area('rec', od.region_va(1), rec, image=False), recs], stubs, {}, [a], (a,), (mask, argv, idx, [hex(r) for r in rolls]),
                ecx=od.region_va(0) + 0x200, pointers=pointers)


# ---- 0x4630a3 ------------------------------------------------------------------------------------------------------------------------------

ARGS_4630A3 = [0x277f, 0x2780, 0x2781, 0x2782, 0x2783, 0x2784, 0x277e, 0, 0xffff, 0x8000, 0x7fff, 0x2700]


def profiles_4630a3():
    return [(arg, w57) for arg in ARGS_4630A3 for w57 in (0, 5, 0x100, 0x8000)]


def gen_4630a3(rng, n):
    (arg, w57), variant = prof(n, profiles_4630a3())
    selfd = bytearray(rng.randbytes(0x100))
    put16(selfd, 0x57, w57)
    g = {name: rng.choice([0, 1, 9, 0x19, 0xffffffff, rng.randrange(1 << 32)]) for name in ('value_5b44f0', 'value_5b44f4', 'value_5d0377', 'value_5d162d', 'value_5d1631',
                                                                                          'value_5d1639', 'value_5c39e5')}
    a = word_arg(rng, arg)
    return make('4630a3', [self_area(selfd)], {}, g, [a], (a,), (hex(arg), w57))


# ---- 0x43423d and 0x4344bf -----------------------------------------------------------------------------------------------------------------

# (name length, kind, position): the entry string equals the name ('eq') or differs from it by one byte ('diff' at the position), is the name without its last byte
# ('short'), the name plus a byte ('long') or empty ('empty')
MISS = [(1, 'diff', 0), (2, 'diff', 1), (3, 'diff', 0), (5, 'diff', 2), (5, 'diff', 3), (5, 'diff', 4), (4, 'short', 0), (3, 'short', 0), (2, 'short', 0), (1, 'short', 0),
        (4, 'long', 0), (3, 'long', 0), (0, 'long', 0), (3, 'empty', 0), (2, 'diff', 0), (7, 'diff', 6)]
HITS = [(ln, 'eq', 0) for ln in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0x20, 0x21, 0x30)]
NVALS = [0, 1, 4, 5, 8, 9, 0x10, 0x80000000, 0xffffffff, 100]


def strings_for(rng, spec, high):
    """(name, entry string) for the spec (length, kind, position)."""
    ln, kind, j = spec
    name = bytearray(nonzero_bytes(rng, ln, high))
    cand = bytearray(name)
    if kind == 'diff':
        b = name[j]
        options = [x for x in {(b % 250) + 1, b ^ 0x80, b ^ 1, b ^ 0x40} if x != 0 and x != b]
        cand[j] = rng.choice(sorted(options))
    elif kind == 'short':
        cand = cand[:max(ln - 1, 0)]
    elif kind == 'long':
        cand += nonzero_bytes(rng, 1, high)
    elif kind == 'empty':
        cand = bytearray()
    return bytes(name), bytes(cand)


def search_profiles(alias):
    p = [('none', c) for c in (0, -1)]
    p += [('miss', c, spec) for c in (1, 2, 3) for spec in MISS]
    p += [('hit', c, k, spec) for c in (1, 2, 3) for k in range(c) for spec in HITS]
    p += [('shrink',), ('grow',)]       # a lookup callee rewrites the loop bound ([self+0x5f64] / [self+0x5f68]) mid-loop
    if alias:
        p += [('alias_hit', f) for f in (1, 0x10001, 0x100, 0)] + [('alias_miss', 1)]
    return p


def gen_search(key, rng, n):
    big = key == '4344bf'
    (kind, *rest), variant = prof(n, search_profiles(big))
    high = bool(variant % 2)
    k = None
    if kind == 'none':
        count, spec = rest[0], MISS[n % len(MISS)]
    elif kind == 'miss':
        count, spec = rest
    elif kind == 'hit':
        count, k, spec = rest
    elif kind == 'shrink':
        count, spec = 3, (3, 'eq', 0)
    elif kind == 'grow':
        count, spec = 1, (3, 'eq', 0)
    else:       # alias_hit / alias_miss: the flag dwords of the entries 1000 and 1001 are [self+0x5f64] (set to 1) and the count itself
        count, spec = 1002, (3, 'eq', 0)
    name, cand = strings_for(rng, spec, high)
    other = cand if kind == 'miss' else (bytes([(name[0] % 250) + 1]) + name[1:] if name else b'x')
    selfd = bytearray(rng.randbytes(0x6100))
    put32(selfd, 0x5f68 if big else 0x5f64, count)
    table = 0x20e4 if big else 0x1144
    iters = 3 if kind in ('shrink', 'grow') else min(max(count, 0), 1002)
    writes = []
    for i in range(iters):
        put32(selfd, table + 4 * i, rand32(rng))
    VA_A, VA_B = od.region_va(2), od.region_va(3)
    if kind == 'alias_hit':
        put32(selfd, 0x5f64, rest[0])
        lookups = [VA_B] * 1000 + [VA_A, VA_A]
    elif kind == 'alias_miss':
        put32(selfd, 0x5f64, 1)
        lookups = [VA_B] * 1000 + [VA_A, VA_B]
    elif kind == 'shrink':      # the first lookup shrinks the bound to 1: the second entry (which would match) is never visited
        lookups = [VA_B, VA_A, VA_A]
        writes = [(0, -1, od.region_va(0) + (0x5f68 if big else 0x5f64), 4, 1)]
    elif kind == 'grow':        # the first lookup grows the bound to 3: the third entry (the match) is visited
        lookups = [VA_B, VA_B, VA_A]
        writes = [(0, -1, od.region_va(0) + (0x5f68 if big else 0x5f64), 4, 3)]
    else:
        lookups = [VA_A if i == k else VA_B for i in range(iters)] or [VA_B]
    probe = [('self', 0x1100, 0x40), ('self', 0x5f64, 8)]
    stubs = {0x434814: stub(0x434814, THISCALL(1), probe, results=lookups, writes=writes)}
    if big:
        # the flag dword of the entry that matches (alias entries: 1001 or 1000) is probed at the 0x4347b8 call, which sits between the flag store and the 0x112c store
        hit = {'alias_hit': 1001 if kind == 'alias_hit' and rest[0] == 1 else 1000, 'alias_miss': 1001, 'grow': 2}.get(kind, k if k is not None else 0)
        stubs[0x4347b8] = stub(0x4347b8, THISCALL(1), probe + [('self', 0x4fc4 + 4 * hit, 4)], results=[rng.choice([0, 0x77, 0xffffffff, 0x8000, rng.randrange(1 << 32)])])
    else:
        stubs[0x4347b8] = stub(0x4347b8, THISCALL(1), probe, results=[NVALS[(n + 3 * i + variant) % len(NVALS)] for i in range(iters)] or [0])
        stubs[0x42639d] = stub(0x42639d, THISCALL(2), probe)
        stubs[0x4c97b4] = stub(0x4c97b4, THISCALL(0), probe)
    areas = [self_area(selfd), Area('name', od.region_va(1), cstring(name, 0x80, rng), image=False), Area('sa', od.region_va(2), cstring(name, 0x80, rng), image=False),
             Area('sb', od.region_va(3), cstring(other, 0x80, rng), image=False)]
    return make(key, areas, stubs, {}, [od.region_va(1)], (od.region_va(1),), (kind, *rest))


def gen_43423d(rng, n):
    return gen_search('43423d', rng, n)


def gen_4344bf(rng, n):
    return gen_search('4344bf', rng, n)


SPECS = {
    '4bf19a': dict(id=1, va=0x4bf19a, size=86, gen=gen_4bf19a, cleanup=8, ret=True, n=len(profiles_4bf19a()) * 3),
    '434814': dict(id=2, va=0x434814, size=108, code=101, gen=gen_434814, cleanup=4, ret=True, n=len(profiles_434814()) * 4),
    '4471ca': dict(id=3, va=0x4471ca, size=176, gen=make_copy_gen('4471ca'), cleanup=12, n=len(profiles_copy()) * 3),
    '45b4ae': dict(id=4, va=0x45b4ae, size=186, gen=make_copy_gen('45b4ae'), cleanup=12, n=len(profiles_copy()) * 3),
    '461903': dict(id=5, va=0x461903, size=187, gen=make_copy_gen('461903'), cleanup=12, n=len(profiles_copy()) * 3),
    '4b5c5c': dict(id=6, va=0x4b5c5c, size=187, gen=make_copy_gen('4b5c5c'), cleanup=12, n=len(profiles_copy()) * 3),
    '45bbd8': dict(id=7, va=0x45bbd8, size=233, gen=gen_45bbd8, cleanup=4, ret16=True, n=len(profiles_45bbd8()) * 6),
    '4630a3': dict(id=8, va=0x4630a3, size=302, code=286, gen=gen_4630a3, cleanup=4, n=len(profiles_4630a3()) * 3),
    '43423d': dict(id=9, va=0x43423d, size=357, gen=gen_43423d, cleanup=4, ret=True, n=len(search_profiles(False)) * 2),
    '4344bf': dict(id=10, va=0x4344bf, size=369, gen=gen_4344bf, cleanup=4, ret=True, n=len(search_profiles(True)) * 2),
}
KEYS = list(SPECS)
NAMES = {'4bf19a': 'bink_goto', '434814': 'copy_name', '4471ca': 'copy_record15', '45b4ae': 'copy_record_b8e', '461903': 'copy_record_357', '4b5c5c': 'copy_record_39f',
         '45bbd8': 'roll_rects', '4630a3': 'select_action', '43423d': 'find_name_a', '4344bf': 'find_name_b'}


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
