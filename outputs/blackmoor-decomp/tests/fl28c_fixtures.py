"""FL-28 (batch c): the fixtures shared by tests/test_fl28c_differential.py and tests/fl28c_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the scripted
callees (recording stubs at the call boundary, entered by address) and the globals. The scenarios cycle through profiles (each guard failing in turn,
then every arm, loop exit and scripted answer of the function); the optional parts vary from one pass of the cycle to the next; random bytes fill
everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and the vtable entries are recording stubs (host boundaries);
nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that changes `self` or a local of the caller:
call number, argument or absolute address, offset, size, value or a byte string) so that a function's re-reads after a call are exercised. It
returns the result, the normalised ordered call log and a digest of the ordered calls, the return value and the memory read back.
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
    """The fields of Fl28cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl28c.h').read_text()
    body = re.search(r'typedef struct Fl28cWorld \{(.*?)\} Fl28cWorld;', text, re.S).group(1)
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


class Original28(od.Original):
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
    runner = Original28(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh, fpcw=SPECS[sc.key].get('fpcw'))
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read, limit=20000000)
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

VT_STUB_A = od.STUB_BASE + 0x900       # the vtable entry that the original reads and calls (a stub inside the mapped stub page)
NONZERO = [1, 0xffffffff, 0x80000000, 0x100, 0x7fffffff]


def vtable_area(slot, target, rng):
    """A vtable region: random bytes with the dword `target` at byte offset `slot`."""
    v = bytearray(rng.randbytes(0x100))
    put32(v, slot, target)
    return Area('vtbl', od.region_va(5), v, image=False)


def self_area(rng, size=0x300):
    return bytearray(rng.randbytes(size))


# ---- 0x4cf026: the index of the first record the compare callee accepts -----------------------------------------------------------


def profiles_4cf026():
    profiles = [('guard', 1, 0), ('guard', 0, 1), ('guard', 0, 0)]
    profiles += [('empty', c) for c in (0, -1, -2, -0x8000)]
    profiles += [('hit', c, i) for c in (1, 2, 3, 5) for i in range(c)]
    profiles += [('hit', 0x7fff, 3), ('hit', 0x100, 0), ('hit', 6, 5), ('hit', 0x7fff, 1237), ('hit', 0x7fff, 1300)]
    profiles += [('miss', c) for c in (1, 2, 3, 6, 0x7fff)]
    return profiles


def gen_4cf026(rng, n):
    (kind, *rest), variant = prof(n, profiles_4cf026())
    count = 0 if kind == 'guard' else rest[0]
    if variant and count == 0x7fff and kind == 'miss':       # the full 32767-step walk (a 16-bit index would wrap) once; the other passes take 1300 steps
        count = 1300
        rest = (count,)
    if kind == 'guard':
        count = rng.choice([0, 3, 0x7fff])
    selfd = self_area(rng)
    hdr = bytearray(rng.randbytes(0x40))
    put16(hdr, 0x23, count)
    has_hdr, has_tbl = (rest[0], rest[1]) if kind == 'guard' else (1, 1)
    tbl_va = od.region_va(1) + 0x11 if variant % 3 else 0xffffff11        # a table address near the top of the 32-bit space: the record address wraps
    put32(selfd, 0x222, od.region_va(2) if has_hdr else 0)
    put32(selfd, 0x226, tbl_va if has_tbl else 0)
    if kind == 'hit':
        results = [rng.choice(NONZERO) for _ in range(rest[1])] + [0]
    elif kind == 'miss':
        results = [rng.choice(NONZERO) for _ in range(min(rest[0], 64))]        # the last answer repeats
    else:
        results = []
    key = rng.randrange(1 << 32)
    probe = [('self', 0x220, 0x10)]
    stubs = {0x516530: stub(0x516530, CDECL(2), probe, results=results)}
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('hdr', od.region_va(2), hdr, image=False)]
    return make('4cf026', areas, stubs, {}, [key], (key,), (kind, *rest))


# ---- 0x4cec6c: a word counter that is clamped to the limit of a record ------------------------------------------------------------


def profiles_4cec6c():
    profiles = [('guard', which) for which in range(3)]
    starts = (0, 4, 5, 6, 0x7ffe, 0x7fff, 0x8000, 0xfffe, 0xffff)
    limits = (0, 5, 6, 7, -1, -5, 0x7fff, -0x8000)
    profiles += [('run', s, lim) for s in starts for lim in limits]
    return profiles


# record indices, small and wide: the table base is moved down by index * stride (mod 2**32), so that the record address is in the fixture region whatever the index
INDEXES_4CEC6C = (None, 0x100, 0x10000, 0x10003, 0x1000000, 0x12345678, 0x7fffffff, 0x80000000, 0xfffffffe)


def gen_4cec6c(rng, n):
    (kind, *rest), variant = prof(n, profiles_4cec6c())
    selfd = self_area(rng)
    tbl = bytearray(rng.randbytes(0x35 * 4))
    slot = rng.randrange(4)                          # the record that the index addresses
    wide = INDEXES_4CEC6C[(variant + n) % len(INDEXES_4CEC6C)]
    index = slot if wide is None else wide
    base = (od.region_va(1) + 0x35 * slot - 0x35 * index) & 0xffffffff
    put32(selfd, 0x222, rng.choice([od.region_va(2), 1, 0x80000000, 0xffffffff]))
    put32(selfd, 0x226, base)
    put32(selfd, 0x246, index)
    if kind == 'guard':
        which = rest[0]
        if which == 0:
            put32(selfd, 0x222, 0)
        elif which == 1:
            put32(selfd, 0x226, 0)
        else:
            put32(selfd, 0x246, 0xffffffff)
    else:
        put16(selfd, 0x1ca, rest[0])
        put16(tbl, 0x35 * slot + 0x23, rest[1])
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('tbl', od.region_va(1), tbl, image=False)]
    return make('4cec6c', areas, {}, {}, [], (), (kind, *rest, index))


# ---- 0x4cf1e4: allocate and clear ---------------------------------------------------------------------------------------------------


def profiles_4cf1e4():
    profiles = [('fail', size, d) for size in (0, 1, 8, 0x100, 0x10000, 0xffffffff) for d in DBG_VALUES]
    profiles += [('ok', size, off) for size in (0, 1, 2, 3, 4, 5, 7, 8, 9, 0x1f, 0x20, 0x23, 0x35, 0x80, 0xff, 0x100, 0x101, 0x103, 0x1ff, 0x400, 0x10000, 0x10001, 0x10003, 0x1fffc)
                 for off in (0, 0x10)]
    profiles += [('ok_unmapped', 0, 0x1234), ('ok_unmapped', 0, 0xffffffff)]
    return profiles


def gen_4cf1e4(rng, n):
    (kind, *rest), variant = prof(n, profiles_4cf1e4())
    size = rest[0]
    dbg = rest[1] if kind == 'fail' else rng.choice(DBG_VALUES)
    heap = bytearray(rng.randbytes(0x20100))
    out = bytearray(rng.randbytes(8))
    if kind == 'fail':
        p = 0
    elif kind == 'ok':
        p = od.region_va(2) + rest[1]
    else:
        p = rest[1]
    probe = [('out', 0, 8)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[p]), 0x50ca3e: stub(0x50ca3e, CDECL(2), probe),
             0x4264e8: stub(0x4264e8, THISCALL(1), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    g, nbr = debug_areas(rng, dbg)
    areas = [Area('out', od.region_va(1), out, image=False), Area('heap', od.region_va(2), heap, image=False), *nbr]
    return make('4cf1e4', areas, stubs, g, [od.region_va(1), size], (od.region_va(1), size), (kind, *rest), ecx=rng.randrange(1 << 32))


# ---- 0x4ceb8c: a rectangle from a record, moved by the origin -------------------------------------------------------------------


def profiles_4ceb8c():
    profiles = [('guard', which) for which in range(3)]
    profiles += [('run', idx, ox, oy) for idx in range(4) for (ox, oy) in ((0, 0), (100, -7), (-1, 1), (0x7fffffff, 0x7fffffff), (-0x80000000, -0x80000000), (12345, 0x10000))]
    return profiles


INDEXES_4CEB8C = (None, 0x100, 0x10000, 0x10003, 0x1000000, 0x12345678, 0x7fffffff, 0x80000000, 0xfffffffe)


def gen_4ceb8c(rng, n):
    (kind, *rest), variant = prof(n, profiles_4ceb8c())
    selfd = self_area(rng)
    tbl = bytearray(rng.randbytes(0x22 * 4))
    slot = rest[0] if kind == 'run' else 0
    wide = INDEXES_4CEB8C[(variant + n) % len(INDEXES_4CEB8C)]
    index = slot if wide is None else wide
    for off in (0x16, 0x1e, 0x12, 0x1a):          # a field that wraps with the origin
        if variant % 2:
            put32(tbl, 0x22 * slot + off, rng.choice([0xffffff00, 0x7fffffff, 0x80000000, 5]))
    put32(selfd, 0x222, rng.choice([od.region_va(2), 1, 0x80000000, 0xffffffff]))
    put32(selfd, 0x22a, (od.region_va(1) + 0x22 * slot - 0x22 * index) & 0xffffffff)      # the record address is in the region whatever the index
    put32(selfd, 0x24a, index)
    g = {'origin_x_583186': rng.randrange(1 << 32), 'origin_y_58318a': rng.randrange(1 << 32)}
    if kind == 'guard':
        put32(selfd, 0x22a, od.region_va(1))
        put32(selfd, 0x24a, rng.choice([0, 1, 3, 0x7fffffff]))
        put32(selfd, (0x222, 0x22a, 0x24a)[rest[0]], (0, 0, 0xffffffff)[rest[0]])
    else:
        g = {'origin_x_583186': rest[1], 'origin_y_58318a': rest[2]}
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('tbl', od.region_va(1), tbl, image=False)]
    return make('4ceb8c', areas, {}, g, [], (), (kind, *rest, index))


# ---- 0x4ccef1: release the movie player and the movie record ------------------------------------------------------------------------


def profiles_4ccef1():
    profiles = [('none', 0), ('none', 1)]
    profiles += [('live', cleared, pre4) for cleared in (0, 1) for pre4 in (0, 1, 2, 0xffffffff)]
    return profiles


def gen_4ccef1(rng, n):
    (kind, *rest), variant = prof(n, profiles_4ccef1())
    selfd = self_area(rng)
    player = bytearray(rng.randbytes(0x40))
    put32(player, 0, od.region_va(5))
    vt = vtable_area(0, VT_STUB_A, rng)
    put32(selfd, 0x1d6, od.region_va(3) if kind == 'live' else 0)
    if kind == 'live':
        put32(selfd, 4, rest[1])
    cleared = kind == 'live' and rest[0] == 1
    writes = [(0, -1, od.region_va(0) + 0x1d6, 4, 0)] if cleared else []
    probe = [('self', 0, 0x10), ('self', 0x1d0, 0x10)]
    stubs = {0x44c479: stub(0x44c479, CDECL(1), probe, results=[rng.randrange(1 << 32)]), 0x449a94: stub(0x449a94, THISCALL(0), probe, results=[rng.randrange(1 << 32)], writes=writes),
             0x44c4ab: stub(0x44c4ab, CDECL(1), probe), 0x415011: stub(0x415011, THISCALL(1), probe), 0x41632b: stub(0x41632b, THISCALL(1), probe),
             0x4bedfa: stub(0x4bedfa, THISCALL(1), probe), VT_STUB_A: stub(VT_STUB_A, THISCALL(1), probe, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('player', od.region_va(3), player, image=False), vt]
    # the vtable region is region 5: the player's first dword
    return make('4ccef1', areas, stubs, {}, [], (), (kind, *rest))


# ---- 0x4ce8ea: one step of the scan state machine ---------------------------------------------------------------------------------


STATES = (1, 2, 3, 0x10000, 0x10004, 0xffffffff, 0x80000000, 0x100)


def profiles_4ce8ea():
    profiles = [('state', s) for s in STATES]
    profiles += [('z85', s) for s in (0, 4)]
    profiles += [('run', s, r10f, match, dbg) for s in (0, 4) for r10f in (0, 1) for match in (0, 1, 2, 3) for dbg in (0, 1, 0x8000)]
    return profiles


def gen_4ce8ea(rng, n):
    (kind, *rest), variant = prof(n, profiles_4ce8ea())
    state = rest[0] if kind in ('state', 'z85', 'run') else 0
    match = rest[2] if kind == 'run' else 0
    w16 = rng.choice([-3, -1, -0x8000]) if match == 3 else rng.choice([0, 5, -3, 0x7fff, -0x8000, 1, -1])
    selfd = self_area(rng)
    tbl = bytearray(rng.randbytes(0x35 * 4))
    index = rng.randrange(4)
    put32(selfd, 0x1da, state)
    put32(selfd, 0x226, od.region_va(1))
    put32(selfd, 0x246, index)
    put32(selfd, 0x212, od.region_va(3))
    put32(selfd, 0x18e, rng.choice([0, 1, 7, 0xffffffff, 0x80000000, rng.randrange(1 << 32)]))
    put16(tbl, 0x35 * index + 0x23, w16)
    player = bytearray(rng.randbytes(0x40))
    for off in (0x2d, 0x2f):
        put16(player, off, rng.choice([0, 1, 0x7fff, 0x8000, 0xffff, rng.randrange(1 << 16)]))
    r85 = 0 if kind == 'z85' else rng.choice(NONZERO)
    r10f = 0 if kind == 'run' and rest[1] == 0 else rng.choice(NONZERO)
    # [self+0x232] = result of 0x4bee2c - 1: equal to the sign-extended word (1), different (0), different until 0x4ceb8c stores the equal value (2), the zero-extended word (3)
    ext = w16 & 0xffffffff
    r_bee = {0: (ext + 2) & 0xffffffff, 1: (ext + 1) & 0xffffffff, 2: (ext + 7) & 0xffffffff, 3: ((w16 & 0xffff) + 1) & 0xffffffff}[match]
    writes = [(0, -1, od.region_va(0) + 0x232, 4, ext)] if match == 2 else []
    dbg = rest[3] if kind == 'run' else rng.choice(DBG_VALUES)
    probe = [('self', 0x18e, 4), ('self', 0x1d8, 0x68)]
    stubs = {0x4bef85: stub(0x4bef85, THISCALL(1), probe, results=[r85]), 0x4befc8: stub(0x4befc8, THISCALL(1), probe), 0x4bf098: stub(0x4bf098, THISCALL(6), probe),
             0x4bee2c: stub(0x4bee2c, THISCALL(1), probe, results=[r_bee]), 0x4bf10f: stub(0x4bf10f, THISCALL(1), probe, results=[r10f]),
             0x4ceb8c: stub(0x4ceb8c, THISCALL(0), probe, writes=writes), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    g, nbr = debug_areas(rng, dbg)
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('tbl', od.region_va(1), tbl, image=False), Area('player', od.region_va(3), player, image=False), *nbr]
    return make('4ce8ea', areas, stubs, g, [], (), (kind, *rest))


# ---- 0x4cd243: read the scene tables from a stream -----------------------------------------------------------------------------------

# the regions of this function are 16 MiB apart so that the wide scenarios (tables of more than 64 KiB) fit
STREAM_VA, HDRBUF_VA, TBL_VA, SUBS_VA, TBL2_VA, CELLS_VA = (0x30000000 + i * 0x1000000 for i in range(6))
ANSWERS = (1, 0x10000, 0x80000000, 0xffffffff, 0x100, 0x7fffffff)       # a success of 0x4cf1e4 is any non-zero eax: the answers are tested as a whole dword


def profiles_4cd243():
    profiles = [('busy', flag, d) for flag in (1, 0x80000000, 0xffffffff) for d in (0, 1, 0x8000)]
    profiles += [('fail', k, count, d) for count in (2, 1) for k in range(2 + count + 1) for d in (0, 1)]
    profiles += [('fail', 1, 1300, 0), ('fail', 1, 0x7fff, 1), ('fail', 1, -2, 0), ('fail', 1, -0x8000, 1)]       # the size passed to the table allocation does not fit in 16 bits / is negative
    profiles += [('ok', count, count2, d) for count in (0, 1, 2, 3) for count2 in (0, 1, 2, 5) for d in (0, 1, 0x8000)]
    profiles += [('negcount', c) for c in (-1, -0x8000)]
    profiles += [('negword', 0)]
    # sizes that do not fit in 8 or 16 bits: a sub table of 315 / 65555 bytes, a second table of 272 / 65552 bytes, a running offset above 0x10000
    profiles += [('wide', 'm8', 1, (9,), 0), ('wide', 'm16', 1, (1873,), 3), ('wide', 'n8', 0, (), 8), ('wide', 'n16', 0, (), 1928),
                 ('wide', 'c16', 2, (1873, 9), 2), ('wide', 'both', 2, (40, 1900), 1930)]
    return profiles


def gen_4cd243(rng, n):
    (kind, *rest), variant = prof(n, profiles_4cd243())
    count, count2, dbg, fail_at, wide = 2, rng.choice([0, 1, 2, 3]), 0, -1, False
    explicit = None
    if kind == 'busy':
        dbg = rest[1]
    elif kind == 'fail':
        fail_at, count, dbg = rest[0], rest[1], rest[2]
        if fail_at == 2 + count:         # the second table fails: its size is the (signed) word [hdr+0x25] * 0x22, also negative or above 16 bits
            count2 = rng.choice([0, 1, 2, 3, 0xffff, 0x8000, -3, 1930])
    elif kind == 'ok':
        count, count2, dbg = rest
    elif kind == 'negcount':
        count, count2 = rest[0], 0
    elif kind == 'negword':
        fail_at = 2
    elif kind == 'wide':
        count, explicit, count2, wide = rest[1], rest[2], rest[3], True
    # the word [+0x2f] of each record (the size of its sub table): small and non-negative where the allocation succeeds
    shown = min(max(count, 0), 8)
    words = list(explicit) if explicit is not None else [rng.choice([0, 1, 2, 3, 7]) for _ in range(shown)]
    if kind == 'negword':
        words[0] = rng.choice([-1, -0x8000, -7])
    elif kind == 'fail' and 2 <= fail_at < 2 + count:
        words[fail_at - 2] = rng.choice([-1, 0, 1, 3, 0x7fff])
    # the calls of 0x4cf1e4 that happen: 0 the header, 1 the table, 2.. one sub table per record, then the second table
    total_calls = 3 + max(count, 0)
    ncalls = total_calls if fail_at < 0 else min(total_calls, fail_at + 1)
    # variant 1: the sub-table allocation of a record changes the word [rec+0x2f]; variant 2: the second-table allocation changes the word [hdr+0x25] (the sizes are computed again after the call)
    rewrite = {}
    if variant % 3 == 1 and kind in ('ok', 'wide'):
        for i, w in enumerate(words):
            if 2 + i < ncalls - (1 if fail_at < 0 else 0):
                rewrite[i] = (w // 2 + 1) if wide else (w + 3) % 8
    rewrite_last = variant % 3 == 2 and kind in ('ok', 'wide', 'negcount') and fail_at < 0
    eff = [rewrite.get(i, w) for i, w in enumerate(words)]
    count2_last = count2 + 1 if rewrite_last else count2
    sized = max(0, min(max(count2, count2_last), 2000))          # a table that is really copied
    need = 0x27 + sum(0x31 + (e * 0x23 if e > 0 else 0) for e in eff) + sized * 0x22 + 0x80
    stream = bytearray(rng.randbytes(max(0x400, need)))
    put16(stream, 0x23, count)
    put16(stream, 0x25, count2)
    at = 0x27
    for w, e in zip(words, eff):
        if at + 0x31 > len(stream) - 0x80:         # a record behind a failing allocation is never read
            break
        put16(stream, at + 0x2f, w)
        at += 0x31 + (e * 0x23 if e > 0 else 0)
    selfd = self_area(rng)
    put32(selfd, 0x216, rest[0] if kind == 'busy' else 0)
    cells = bytearray(rng.randbytes(16))
    put32(cells, 0, rng.randrange(1 << 32))
    put32(cells, 4, STREAM_VA)
    hdrbuf = bytearray(rng.randbytes(0x40))
    tbl = bytearray(rng.randbytes(0x100))
    stride = 0x20000 if wide else 0x100
    subs = bytearray(rng.randbytes(max(0x400, stride * min(max(count, 1), 4))))
    tbl2 = bytearray(rng.randbytes(max(0x100, sized * 0x22 + 0x40)))
    values = [HDRBUF_VA, TBL_VA] + [SUBS_VA + stride * i for i in range(max(count, 0))] + [TBL2_VA]
    results, writes = [], []
    for k in range(ncalls):
        ok = k != fail_at
        results.append(rng.choice(ANSWERS) if ok else 0)
        writes.append((k, 0, 0, 4, values[k] if ok else 0))
        if ok and 2 <= k < 2 + max(count, 0) and (k - 2) in rewrite:
            writes.append((k, 0, -2, 2, rewrite[k - 2]))               # [rec+0x2f], two bytes below the pointer cell that the call stores
        if ok and k == total_calls - 1 and rewrite_last:
            writes.append((k, -1, HDRBUF_VA + 0x25, 2, count2_last))
    probe = [('self', 0x210, 0x40), ('self', 0x220, 0x30), ('cells', 0, 16)]
    f50 = CDECL(3) if kind == 'busy' else CDECL(4)
    stubs = {0x4cf1e4: stub(0x4cf1e4, THISCALL(2), probe, results=results, writes=writes), 0x50ca3e: stub(0x50ca3e, f50, probe), 0x42639d: stub(0x42639d, THISCALL(2), probe),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4cf276: stub(0x4cf276, THISCALL(0), probe)}
    g, nbr = debug_areas(rng, dbg)
    g.update({'word_5c39e3': rng.choice([0, 1, -1, 0x7fff, -0x8000, 5, rng.randrange(1 << 16)]), 'value_5bb57b': rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)])})
    nbr.append(Area('scenenbr', 0x5c39e5, bytearray(rng.randbytes(2)), compare=False))
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('stream', STREAM_VA, stream, image=False), Area('hdrbuf', HDRBUF_VA, hdrbuf, image=False),
             Area('tbl', TBL_VA, tbl, image=False), Area('subs', SUBS_VA, subs, image=False), Area('tbl2', TBL2_VA, tbl2, image=False), Area('cells', CELLS_VA, cells, image=False), *nbr]
    return make('4cd243', areas, stubs, g, [CELLS_VA, CELLS_VA + 4, CELLS_VA + 8], (CELLS_VA, CELLS_VA + 4, CELLS_VA + 8), (kind, *rest))


SPECS = {
    '4cf026': dict(id=1, va=0x4cf026, size=131, gen=gen_4cf026, cleanup=4, ret=True, n=len(profiles_4cf026()) * 3),
    '4cec6c': dict(id=2, va=0x4cec6c, size=139, gen=gen_4cec6c, cleanup=0, n=len(profiles_4cec6c()) * 3),
    '4cf1e4': dict(id=3, va=0x4cf1e4, size=146, gen=gen_4cf1e4, cleanup=8, ret=True, n=len(profiles_4cf1e4()) * 3),
    '4ceb8c': dict(id=4, va=0x4ceb8c, size=224, gen=gen_4ceb8c, cleanup=0, n=len(profiles_4ceb8c()) * 3),
    '4ccef1': dict(id=5, va=0x4ccef1, size=204, gen=gen_4ccef1, cleanup=0, n=len(profiles_4ccef1()) * 4),
    '4ce8ea': dict(id=6, va=0x4ce8ea, size=593, gen=gen_4ce8ea, cleanup=0, n=len(profiles_4ce8ea()) * 3),
    '4cd243': dict(id=7, va=0x4cd243, size=1026, gen=gen_4cd243, cleanup=12, ret=True, n=len(profiles_4cd243()) * 3),
    # SPECS-INSERT
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
