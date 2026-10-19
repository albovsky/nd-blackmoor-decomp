"""FL-27 (batch c): the fixtures shared by tests/test_fl27c_differential.py and tests/fl27c_original_oracle.py.

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
    """The fields of Fl27cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl27c.h').read_text()
    body = re.search(r'typedef struct Fl27cWorld \{(.*?)\} Fl27cWorld;', text, re.S).group(1)
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


HANDLES = [1, 0x1234, 0x80000000, 0xdeadbeef]
ALLOCS = [od.region_va(4), 0x1234, 0xffffffff, 0x80000000]


def profiles_4497a0():
    flags_set = (0, 1, 2, 4, 5, 0xc, 0x100, 0x80000000, 0x80000004, 0xfffffffb, 0xffffffff)
    profiles = [('nomem', f) for f in (0, 4)]
    profiles += [('noctor', f) for f in (0, 4, 1)]
    profiles += [('noinit', f) for f in (0, 1, 4, 0x80000000)]
    profiles += [('nowait', f) for f in (0, 4, 8, 0xffffffff)]
    profiles += [('noresume', f) for f in (0, 1, 2, 8, 0x100, 0x80000000)]
    profiles += [('ok', f, r3, d) for f in flags_set for r3 in ((0, 1, 2, 0xfffffffe, 0x80000000) if f & 4 == 0 else (0,)) for d in (0, 1, 0x100)]
    return profiles


NAME_LENGTHS = [0, 1, 2, 3, 4, 5, 7, 0x20, 0x30, 0x32, 0x35, 0x36, 0x37, 0x3a, 0x41]


def gen_4497a0(rng, n):
    (kind, *rest), variant = prof(n, profiles_4497a0())
    flags = rest[0]
    r3 = rest[1] if kind == 'ok' else (0xffffffff if kind == 'noresume' else 0)
    dbg = rest[2] if kind == 'ok' else rng.choice(DBG_VALUES)
    waits = [1, 0x102, 0xffffffff, 0x80000000, 0x100]
    r2 = 0 if kind == 'nowait' else waits[(variant + n) % len(waits)]
    p = 0 if kind == 'nomem' else ALLOCS[(variant + n) % len(ALLOCS)]
    obj_result = 0 if kind in ('nomem', 'noctor') else od.region_va(1)
    r_init = 0 if kind == 'noinit' else rng.choice([1, 0x100, 0x80000000, 0xffffffff])
    length = NAME_LENGTHS[(variant + n) % len(NAME_LENGTHS)]
    selfd = bytearray(rng.randbytes(0x100))
    obj = bytearray(rng.randbytes(0x80))
    put32(obj, 0, od.region_va(2))
    put32(obj, 0x28, rng.choice(HANDLES))
    put32(obj, 0x2c, rng.randrange(1 << 32))
    vt = vtable_area(0x78, VT_STUB_B, rng)
    name = Area('name', od.region_va(3), zstring(rng, length, 0x80), image=False)
    arg8, timeout = rng.randrange(1 << 32), rng.choice([0, 1, 0xffffffff, 0x1388, rng.randrange(1 << 32)])
    probe = [('self', 0, 0x100), ('obj', 0, 0x80)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[p]), 0x524aff: stub(0x524aff, THISCALL(2), probe, results=[obj_result]),
             0x4264e8: stub(0x4264e8, THISCALL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x51ed8c: stub(0x51ed8c, THISCALL(3), probe, results=[r_init]),
             0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe), VT_STUB_B: stub(VT_STUB_B, (0, True, 0), probe)}
    iat = {0x52a2ac: stub(0x52a2ac, STDCALL(2), probe, results=[r2]), 0x52a284: stub(0x52a284, STDCALL(1), probe, results=[r3])}
    g, nbr = debug_areas(rng, dbg)
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('obj', od.region_va(1), obj, image=False), vt, name, *nbr]
    sc = make('4497a0', areas, stubs, g, [arg8, od.region_va(3), timeout, flags], (arg8, od.region_va(3), timeout, flags), (kind, *rest), iat=iat)
    sc.seh = rng.randrange(1 << 32)
    return sc


AVF_SIGNATURE = b'AVF WayneSikes\x00'      # the 15 bytes that 0x414ceb compares the header with (at 0x541978)


def profiles_414ceb():
    profiles = [(kind, pre, empty) for kind in ('open_fail', 'map_fail', 'view_fail') for pre in (0, 1) for empty in (0, 1)]
    profiles += [('sig', i) for i in range(15)]
    profiles += [('w10', v) for v in (0, 1, 3, 0x100, 0x102, 0xffff)]
    profiles += [('w12', v) for v in (1, 0x100, 0x101, 0xffff)]
    profiles += [('alloc_fail', w) for w in (0, 1, 2, -1, 0x7fff, -0x8000)]
    shapes = [(0, 0, 0), (1, 1, 8), (1, 0x7fff, 0xff), (-1, -1, 0x1f), (-0x8000, -0x8000, 0xff), (3, -2, 7), (0x1234, 0x10, 0x28)]
    profiles += [('ok', w15, *shape) for w15 in (0, 1, 2, 3, 4, 5, 16) for shape in shapes]
    return profiles


def gen_414ceb(rng, n):
    (kind, *rest), variant = prof(n, profiles_414ceb())
    pre = rest[0] if kind in ('open_fail', 'map_fail', 'view_fail') else rng.choice([0, 0, 1, 0x100, 0x80000000, 0xffffffff])
    empty = rest[1] if kind in ('open_fail', 'map_fail', 'view_fail') else 0
    arg = bytearray(rng.randbytes(0x200))
    put32(arg, 0x21, pre)
    length = 0 if empty else rng.choice([1, 2, 3, 4, 5, 0x10, 0x20])
    arg[0x4d:0x4d + 0x40] = zstring(rng, length, 0x40)
    arg[0x151:0x151 + 0x20] = zstring(rng, rng.choice([0, 3, 0x10]), 0x20)
    delta = rng.choice([0, 3, 0x10])
    file = bytearray(rng.randbytes(0x400))
    header = bytearray(rng.randbytes(0x21))
    header[0:15] = AVF_SIGNATURE
    put16(header, 0x10, 2)
    put16(header, 0x12, 0)
    w15, w17, w19, b1b = 1, rng.choice([1, 2, 0x7fff, -3]), rng.choice([1, 5, 0x8000]), rng.randrange(256)
    if kind == 'sig':
        header[rest[0]] ^= rng.choice([1, 0x80, 0xff, 0x20])
    elif kind == 'w10':
        put16(header, 0x10, rest[0])
    elif kind == 'w12':
        put16(header, 0x12, rest[0])
    elif kind == 'alloc_fail':
        w15 = rest[0]
    elif kind == 'ok':
        w15, w17, w19, b1b = rest
    put16(header, 0x15, w15)
    put16(header, 0x17, w17)
    put16(header, 0x19, w19)
    header[0x1b] = b1b
    file[delta:delta + 0x21] = header
    dest = bytearray(rng.randbytes(0x400))
    h = 0xffffffff if kind == 'open_fail' else rng.choice([1, 0x1234, 0x80000000, 0xfffffffe])
    m = 0 if kind == 'map_fail' else rng.choice([1, 0x5678, 0xffffffff, 0x80000000])
    v = 0 if kind == 'view_fail' else od.region_va(2) + delta
    a = 0 if kind == 'alloc_fail' else od.region_va(3)
    probe = [('arg', 0, 0x200), ('g:value_63a58a', 0, 4)]
    stubs = {0x42639d: stub(0x42639d, THISCALL(2), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x415011: stub(0x415011, THISCALL(1), probe),
             0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[a])}
    iat = {0x52a2bc: stub(0x52a2bc, STDCALL(7), probe, results=[h]), 0x52a2c0: stub(0x52a2c0, STDCALL(6), probe, results=[m]),
           0x52a2c4: stub(0x52a2c4, STDCALL(5), probe, results=[v])}
    g = {'value_63a58a': rng.choice([0, 4, 1, rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), bytearray(rng.randbytes(0x40)), image=False), Area('arg', od.region_va(1), arg, image=False),
             Area('file', od.region_va(2), file, image=False), Area('dest', od.region_va(3), dest, image=False)]
    return make('414ceb', areas, stubs, g, [od.region_va(1)], (od.region_va(1),), (kind, *rest), iat=iat)


def make_mask(rng, kind, shift):
    """A colour mask whose lowest set bit is `shift`: kind 5 gives 0x1f << shift, kind 6 any other odd pattern."""
    if kind == 5:
        return (0x1f << shift) & 0xffffffff
    while True:
        width = 32 - shift
        pattern = (rng.getrandbits(rng.choice([1, 2, 3, 6, 8, 16, width])) | 1) & ((1 << width) - 1)
        if pattern != 0x1f:
            return (pattern << shift) & 0xffffffff


FLAG_BITS = (0x2, 0x20, 0x40, 0x400)


def profiles_4c2e97():
    profiles = [('hrfail', hr, d) for hr in (1, 0x80004005, 0xffffffff, 0x100) for d in (0, 1)]
    profiles += [('rgb', kinds, d, flags) for kinds in range(8) for d in (0, 1) for flags in (0, 2, 0x20, 0x40, 0x400, 0x462, 0xffffffff, 0x1b3)]
    profiles += [('shift', ch, c) for ch in range(3) for c in range(32)]
    profiles += [('flags', subset) for subset in range(16)]
    return profiles


def gen_4c2e97(rng, n):
    (kind, *rest), variant = prof(n, profiles_4c2e97())
    dbg = {'hrfail': rest[1] if kind == 'hrfail' else 0, 'rgb': rest[1] if kind == 'rgb' else 0}.get(kind, 1)
    shifts = [rng.choice([0, 0, 1, 2, 5, 6, 11, 16, 31, rng.randrange(32)]) for _ in range(3)]
    kinds = [rng.choice([5, 6]) for _ in range(3)]
    flags = rng.randrange(1 << 32)
    if kind == 'rgb':
        kinds = [5 if (rest[0] >> i) & 1 else 6 for i in range(3)]
        flags = rest[2]
    elif kind == 'shift':
        shifts[rest[0]] = rest[1]
        kinds[rest[0]] = 6 if rest[1] > 27 else rng.choice([5, 6])
    elif kind == 'flags':
        flags = (rng.randrange(1 << 32) & ~sum(FLAG_BITS)) | sum(b for i, b in enumerate(FLAG_BITS) if (rest[0] >> i) & 1)
    masks = [make_mask(rng, kinds[i], min(shifts[i], 27) if kinds[i] == 5 else shifts[i]) for i in range(3)]
    hr = rest[0] if kind == 'hrfail' else 0
    selfd = bytearray(rng.randbytes(0x38e0))
    surf = bytearray(rng.randbytes(0x40))
    put32(surf, 0, od.region_va(2))
    vt = vtable_area(0x58, VT_STUB_A, rng)
    bpp = rng.choice([0, 8, 15, 16, 24, 32, rng.randrange(1 << 32)])
    writes = [] if hr else [(0, 1, 0x58, 4, masks[0]), (0, 1, 0x5c, 4, masks[1]), (0, 1, 0x60, 4, masks[2]), (0, 1, 0x54, 4, bpp), (0, 1, 0x4c, 4, flags)]
    probe = [('self', 0x38a0, 0x40), ('g:byte_5b0257', 0, 1), ('g:byte_5b0258', 0, 1), ('g:byte_5b0259', 0, 1)]
    stubs = {0x4c88c7: stub(0x4c88c7, THISCALL(1), probe, results=[rng.randrange(1 << 32)]), 0x42639d: stub(0x42639d, THISCALL(2), probe),
             0x50ca3e: stub(0x50ca3e, CDECL(16), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe),
             VT_STUB_A: stub(VT_STUB_A, (2, True, 8), probe, results=[hr], writes=writes, derefs=[(1, 0x7c)])}
    g, nbr = debug_areas(rng, DBG_VALUES[1 + (variant + n) % (len(DBG_VALUES) - 1)] if dbg else 0)
    g.update({'byte_5b0257': rng.choice([0, 0xff, 0x80, 0x7f, rng.randrange(256)]), 'byte_5b0258': rng.choice([0, 0xff, 0x81, 0x40, rng.randrange(256)]),
              'byte_5b0259': rng.choice([0, 0xff, 0xc0, 0x3f, rng.randrange(256)])})
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('surf', od.region_va(1), surf, image=False), vt, *nbr]
    return make('4c2e97', areas, stubs, g, [od.region_va(1)], (od.region_va(1),), (kind, *rest))


RATES = [(30, 1), (0, 5), (5, 0), (0, 0), (1, 1), (0xffffffff, 1), (1, 0xffffffff), (24, 1001), (30000, 1001), (3, 7), (0x7fffffff, 2), (1000, 3), (0x1000001, 7), (299, 13), (2, 3), (7, 5)]


def profiles_44c4c1():
    profiles = [('avf', k, r) for k in (0, 2, 3, 0x100, 0x80000000, 0xffffffff) for r in (0, 1)]
    profiles += [('nohandle', d, r) for d in DBG_VALUES for r in (0, 1)]
    profiles += [('noinfo', d, r) for d in (0, 1, 0x8000) for r in (0, 1)]
    profiles += [('rewrite', d, 1) for d in (0, 1)]
    profiles += [('reread', k, r) for k in (1, 0) for r in (0, 1)]
    profiles += [('ok', a, b, r) for (a, b) in RATES for r in (0, 1)]
    return profiles


def gen_44c4c1(rng, n):
    (kind, *rest), variant = prof(n, profiles_44c4c1())
    kind176 = {'avf': rest[0] if rest else 0, 'reread': rest[0] if kind == 'reread' else 1}.get(kind, 1)
    r449 = rng.choice([1, 0x80000000, 0xffffffff, 0x100]) if rest[-1] else 0
    dbg = rest[0] if kind in ('nohandle', 'noinfo', 'rewrite') else 0
    arg = bytearray(rng.randbytes(0x200))
    put32(arg, 0x176, kind176)
    s1 = zstring(rng, rng.choice([0, 1, 3, 4, 0x20, 0x61, 0x7f]), 0x80)
    s2 = zstring(rng, rng.choice([0, 1, 5, 8, 0x21, 0x60, 0x7f]), 0x80)
    info = bytearray(rng.randbytes(0x40))
    sizes = [0, 1, 2, 0x7fff, 0x8000, 0xffff, 0x10000, 0x12345, 0x7fffffff, 0x80000000, 0xffffffff, 320, 640, 480]
    put32(info, 0, rng.choice(sizes))
    put32(info, 4, rng.choice(sizes))
    put32(info, 0x20, rng.choice([0, 1, 2, 100, 0xffff, 0x10000, 0x7fffffff, 0x80000000, 0xffffffff]))
    if kind == 'ok':
        put32(info, 0xc, rest[0])
        put32(info, 0x10, rest[1])
    handle = 0 if kind == 'nohandle' else rng.choice([1, 0x77, 0x80000000, 0xffffffff])
    info_result = 0 if kind == 'noinfo' else od.region_va(2)
    probe = [('arg', 0, 0x1d0), ('g:value_5bb20c', 0, 4)]
    writes_449 = [(0, -1, od.region_va(1) + 0x176, 4, 0 if kind176 == 1 else 1)] if kind == 'reread' else []
    writes_sprintf = [(0, 0, 0, 0, bytes(s1)), (1, 0, 0, 0, bytes(s2))]
    writes_ee5f = [(0, -1, od.region_va(1) + 0x186, 4, 0)] if kind == 'rewrite' else []
    stubs = {0x50cd72: stub(0x50cd72, CDECL(5), probe, writes=writes_sprintf, derefs=[(4, 5)]),
             0x449d90: stub(0x449d90, CDECL(1), probe, results=[r449], writes=writes_449, derefs=[(0, 0x80)]),
             0x414ceb: stub(0x414ceb, THISCALL(1), probe), 0x4bf315: stub(0x4bf315, THISCALL(2), probe, results=[handle]),
             0x4bf3b8: stub(0x4bf3b8, THISCALL(1), probe, results=[rng.randrange(1 << 32)]), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe),
             0x4264e8: stub(0x4264e8, THISCALL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x50ca3e: stub(0x50ca3e, CDECL(3), probe),
             0x4bee5f: stub(0x4bee5f, THISCALL(1), probe, results=[info_result], writes=writes_ee5f)}
    g, nbr = debug_areas(rng, dbg)
    g['value_5bb20c'] = rng.choice([0, 1, rng.randrange(1 << 32)])
    g['word_639895'] = rng.choice([0, 1, 2, 3, 4, -1, 0x7fff, -0x8000, 0x100])
    nbr.append(Area('bppnbr', 0x639897, bytearray(rng.randbytes(2)), compare=False))
    areas = [Area('arg', od.region_va(1), arg, image=False), Area('info', od.region_va(2), info, image=False), *nbr]
    return make('44c4c1', areas, stubs, g, [od.region_va(1)], (od.region_va(1),), (kind, *rest))


SPECS = {
    '44c4c1': dict(id=4, va=0x44c4c1, size=1306, gen=gen_44c4c1, cleanup=0, fpcw=0x27f, n=len(profiles_44c4c1()) * 3),
    '4c2e97': dict(id=3, va=0x4c2e97, size=1208, gen=gen_4c2e97, cleanup=4, ret16=True, n=len(profiles_4c2e97()) * 2),
    '414ceb': dict(id=2, va=0x414ceb, size=806, gen=gen_414ceb, cleanup=4, n=len(profiles_414ceb()) * 3),
    '4497a0': dict(id=1, va=0x4497a0, size=728, gen=gen_4497a0, cleanup=0x10, retself=True, n=len(profiles_4497a0()) * 3),
}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
