"""FL-28 (batch a): the fixtures shared by tests/test_fl28a_differential.py and tests/fl28a_original_oracle.py.

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
    """The fields of Fl28aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl28a.h').read_text()
    body = re.search(r'typedef struct Fl28aWorld \{(.*?)\} Fl28aWorld;', text, re.S).group(1)
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

    halted = False

    def run(self, va, body_size, **kw):
        try:
            return super().run(va, body_size, **kw)
        except RuntimeError:
            if not self.halted:
                raise
        uc = self.uc
        memory = {name: bytes(uc.mem_read(a, n)) for name, (a, n) in (kw.get('read') or {}).items()}
        return od.Result(eax=uc.reg_read(self._r['EAX']), cleanup=0, memory=memory, calls=self.calls, executed=self.executed)

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
        seq = getattr(stub, 'arg_seq', None)
        if seq:       # a variadic callee (0x50ca3e) whose argument count differs from call to call
            stub.args = seq[min(number, len(seq) - 1)]
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
        if getattr(stub, 'halt', False):          # a callee that never returns (0x4c97b4 ends the process): the run stops here
            self.halted = True
            uc.emu_stop()
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


def stub(callee, shape, probe=None, results=None, writes=None, derefs=None, halt=False, arg_seq=None):
    nargs, this, cleanup = shape
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    s.writes = writes or []
    s.derefs = derefs or []
    s.halt = halt
    s.arg_seq = arg_seq
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


def make(key, areas, stubs, g, stack, args, profile, iat=None, ecx=None, pointers=None, self_off=0):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0) + self_off if ecx is None else ecx, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args,
                           seh=None, self_off=self_off)


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
    orig.halted = runner.halted
    if not runner.halted and orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None:
        if orig.memory.pop('tib') != struct.pack('<I', sc.seh):
            raise AssertionError('the structured-exception chain at fs:[0] was not restored')
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the constructor did not return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') and not runner.halted:
        h.update(struct.pack('<I', orig.eax & SPECS[sc.key]['ret']))
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

DBG = lambda rng: rng.choice(DBG_VALUES)
LOG = 0x63888b


def junk(rng, n):
    return bytearray(rng.randbytes(n))


def zstring(rng, length, size):
    """`size` bytes: `length` non-zero random bytes, a terminator, then random bytes."""
    s = bytearray(rng.randbytes(size))
    for i in range(length):
        if s[i] == 0:
            s[i] = 1 + i % 255
    s[length] = 0
    return s


def debug_stubs(extra, probe, dbg_nargs=None):
    """The reporting callees of the debug traces (0x50ca3e with 3 then 4 arguments in 0x4fb2e3, otherwise a given count) and 0x44a2b7."""
    out = dict(extra)
    out[0x44a2b7] = stub(0x44a2b7, CDECL(1), probe)
    return out


def slot_value(rng, n):
    """A slot argument: its low 16 bits are the slot (kept small: the record array is 0x5bb bytes per slot), the high 16 bits junk."""
    return (rng.choice([0, 0, 1, 0xffff, rng.randrange(0x10000)]) << 16) | (n % 4)


# 0x4235fd ---------------------------------------------------------------------------------------------------------------------------

COUNTS_4235FD = (0, 1, 2, 3, 0x10, 0x7f, 0x80, 0x100, 0x2aaaaaab, 0x40000001, 0x80000000, 0xffffffff, 0xfffffff5)


def gen_4235fd(rng, n):
    (count,), variant = prof(n, [(c,) for c in COUNTS_4235FD])
    d = junk(rng, 0x100)
    put32(d, 4, count)
    return make('4235fd', [Area('self', od.region_va(0), d, image=False)], {}, {}, [], (), (count,))


# 0x4fc808 ---------------------------------------------------------------------------------------------------------------------------

def gen_4fc808(rng, n):
    profiles = [(dbg, k) for dbg in (0, 1, 0x8000, 0x100, 0xffff) for k in range(4)]
    (dbg, k), variant = prof(n, profiles)
    d = junk(rng, 0x1400)
    probe = [('self', 0, 0x1400)]
    g, nbr = debug_areas(rng, dbg)
    stubs = debug_stubs({0x50ca3e: stub(0x50ca3e, CDECL(3), probe), 0x4f356e: stub(0x4f356e, THISCALL(1), probe, results=[rng.randrange(1 << 32)])}, probe)
    slot = (rng.choice([0, 1, 0xffff, rng.randrange(0x10000)]) << 16) | k
    return make('4fc808', [Area('self', od.region_va(0), d, image=False), *nbr], stubs, g, [slot], (slot,), (dbg, k))


# 0x4237f7 and 0x4236d6 ----------------------------------------------------------------------------------------------------------------

def gen_block(key, size, rng, n):
    profiles = [('fail', dbg) for dbg in (0, 1, 0x8000, 0x100, 0xffff)] + [('ok', off, dbg) for off in (0, 4, 0x20, 0x41) for dbg in (0, 1)]
    (kind, *rest), variant = prof(n, profiles)
    off = rest[0] if kind == 'ok' else 0
    dbg = rest[0] if kind == 'fail' else rest[1]
    d = junk(rng, 0x100)
    p = 0 if kind == 'fail' else od.region_va(1) + off
    probe = [('blk', 0, 0x100)]
    stubs = debug_stubs({0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[p]), 0x50ca3e: stub(0x50ca3e, CDECL(2), probe),
                         0x52139c: stub(0x52139c, STDCALL(3), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe, halt=True)}, probe)
    g, nbr = debug_areas(rng, dbg)
    return make(key, [Area('blk', od.region_va(1), d, image=False), *nbr], stubs, g, [], (), (kind, *rest))


def gen_4237f7(rng, n):
    return gen_block('4237f7', 0x4c, rng, n)


def gen_4236d6(rng, n):
    return gen_block('4236d6', 0x1c, rng, n)


# 0x4f80d3 ---------------------------------------------------------------------------------------------------------------------------

LOST = 0x88780096
VT_ENTRY_30, VT_ENTRY_50 = od.STUB_BASE + 0x900, od.STUB_BASE + 0xa00


def gen_4f80d3(rng, n):
    firsts = (0, 1, LOST, LOST + 1, LOST - 1, 0xffffffff, 0x188780096 & 0xffffffff, 0x80000000, 0x8878)
    seconds = (0, 5, LOST, 0xffffffff)
    profiles = [(f, s) for f in firsts for s in seconds]
    (first, second), variant = prof(n, profiles)
    selfd = junk(rng, 0x400)
    obj = junk(rng, 0x40)
    put32(obj, 0, od.region_va(2))
    vt = junk(rng, 0x100)
    put32(vt, 0x30, VT_ENTRY_30)
    put32(vt, 0x50, VT_ENTRY_50)
    arg = rng.choice([0, 1, 0x7fffffff, 0xffffffff, rng.randrange(1 << 32)])
    probe = [('self', 0, 0x400), ('obj', 0, 0x40)]
    stubs = {VT_ENTRY_30: stub(VT_ENTRY_30, STDCALL(4), probe, results=[first, second]), VT_ENTRY_50: stub(VT_ENTRY_50, STDCALL(1), probe, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('obj', od.region_va(1), obj, image=False), Area('vtbl', od.region_va(2), vt, image=False)]
    return make('4f80d3', areas, stubs, {}, [od.region_va(1), arg], (od.region_va(1), arg), (first, second))


# 0x42356d ---------------------------------------------------------------------------------------------------------------------------

def gen_42356d(rng, n):
    counts = [('ok', c) for c in (0, 1, 2, 0x40, 0x7f, -1, -2, -3, -0x20, -0x80, -0x100)] + [('full', c) for c in (0x80, 0x81, 0x7fffffff, 0x1000)]
    profiles = [(kind, c, dbg) for kind, c in counts for dbg in ((0, 1) if kind == 'full' else (0,))]
    (kind, count, dbg), variant = prof(n, profiles)
    d = junk(rng, 0x1800)
    put32(d, 0x1000 + 4, count)
    a, b = rng.randrange(1 << 32), rng.randrange(1 << 32)
    probe = [('self', 0, 0x1800)]
    stubs = debug_stubs({0x50ca3e: stub(0x50ca3e, CDECL(2), probe), 0x52139c: stub(0x52139c, STDCALL(3), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe, halt=True)}, probe)
    g, nbr = debug_areas(rng, dbg)
    return make('42356d', [Area('self', od.region_va(0), d, image=False), *nbr], stubs, g, [a, b], (a, b), (kind, count, dbg), self_off=0x1000)


# 0x4fb2e3 ---------------------------------------------------------------------------------------------------------------------------

def gen_4fb2e3(rng, n):
    profiles = [(dbg, r, k) for dbg in (0, 1, 0x8000, 0x100, 0xffff) for r in (0, 1, 0x100, 0xffffffff) for k in range(4)]
    (dbg, r, k), variant = prof(n, profiles)
    d = junk(rng, 0x1400)
    probe = [('self', 0, 0x1400)]
    g, nbr = debug_areas(rng, dbg)
    stubs = debug_stubs({0x50ca3e: stub(0x50ca3e, CDECL(3), probe), 0x4f6059: stub(0x4f6059, THISCALL(1), probe, results=[r]),
                         0x4fa2a8: stub(0x4fa2a8, THISCALL(0), probe, results=[rng.randrange(1 << 32)])}, probe)
    stubs[0x50ca3e].arg_seq = [3, 4]
    slot = (rng.choice([0, 1, 0xffff, rng.randrange(0x10000)]) << 16) | k
    return make('4fb2e3', [Area('self', od.region_va(0), d, image=False), *nbr], stubs, g, [slot], (slot,), (dbg, r, k))


# 0x423368 ---------------------------------------------------------------------------------------------------------------------------

FIRST_ATOI = (0, 1, 0x3ff, 0x400, 0x7fffffff, 0x80000000, 0x80000001, 0xffffffff, 0x12345678, 0xfffffc00)


def profiles_423368():
    profiles = [('first', v, ln) for v in FIRST_ATOI if v & 0x800003ff or True for ln in (0, 1, 5)]
    for ln in (0, 1, 2, 3, 6):
        profiles += [('none', ln, c0) for c0 in (0x41, 0x80, 0xff, 0x7f)]
    profiles += [('hit', ln, k, v) for ln in (1, 2, 4, 6) for k in range(ln) for v in (0, 7, 0x80000000, 0x80000001, 0x400)]
    profiles += [('long', ln) for ln in (0x8000, 0x10000, 0x10005)]
    return profiles


def gen_423368(rng, n):
    (kind, *rest), variant = prof(n, profiles_423368())
    first, second, ln, k, c0 = 0, 0, 0, None, None
    if kind == 'first':
        first, ln = rest
    elif kind == 'none':
        ln, c0 = rest
    elif kind == 'hit':
        ln, k, second = rest
    else:
        ln = rest[0]
    size = max(0x40, ln + 0x10)
    s = bytearray(rng.randbytes(size))
    for i in range(ln):
        if s[i] == 0:
            s[i] = 1 + i % 255
    s[ln] = 0
    if c0 is not None and ln:
        s[0] = c0
    if ln == 0 and kind == 'none':
        s[0] = 0
    digit = [0] * (k if k is not None else 0) + [1 if k is not None else 0]
    probe = [('str', 0, 0x40)]
    off = rng.choice([0, 1, 5])
    stubs = {0x50cb1b: stub(0x50cb1b, CDECL(1), probe, results=[first, second]), 0x50d6cf: stub(0x50d6cf, CDECL(1), probe, results=digit)}
    area = Area('str', od.region_va(1), s, image=False)
    sc = make('423368', [Area('self', od.region_va(0), junk(rng, 0x40), image=False), area], stubs, {}, [od.region_va(1)], (od.region_va(1),), (kind, *rest))
    return sc


# 0x4f356e ---------------------------------------------------------------------------------------------------------------------------

FLAGS = (1, 0x100, 0x10000, 0x80000000, 0xffffffff)
VT_REL = od.STUB_BASE + 0xb00
FIELDS_4F356E = (0x162, 0x29b, 0x28f, 0x28b, 0x293, 0x297, 0x166, 0x2f1, 0x156)


def gen_4f356e(rng, n):
    early = n < 8
    combo = 0 if early else (n - 8) % 512
    on = {f: bool(combo >> i & 1) for i, f in enumerate(FIELDS_4F356E)}
    idx = rng.choice([0, 1, 0xffffffff])
    base = od.region_va(1) + 0x800
    rec_va = (base + idx * 0x5bb) & 0xffffffff
    rec_off = rec_va - od.region_va(1)
    rec = junk(rng, 0x1400)
    objs = {f: junk(rng, 0x80) for f in (0x293, 0x29b, 0x28f)}
    layouts = {f: rng.choice([0, 0x41]) for f in objs}       # 0: the object at the start of its 64 KiB region (low 16 bits zero); 0x41: low byte non-zero
    low = rng.random() < 0.25       # the [rec + 0x28f] object at the address 0x24 (only its low byte is non-zero: a dword read at [rec + 0x290] sees zero where it should see the pointer)
    for f in objs:
        put32(objs[f], 0, od.region_va(3))
        put32(objs[f], 0x41, od.region_va(3))
    put32(objs[0x28f], 0x24, od.region_va(3))
    vt = junk(rng, 0x100)
    put32(vt, 8, VT_REL)
    objaddr = {0x293: od.region_va(2) + layouts[0x293], 0x29b: od.region_va(5) + layouts[0x29b], 0x28f: 0x24 if low else od.region_va(6) + layouts[0x28f]}
    for f in FIELDS_4F356E:
        value = 0 if not on[f] else (objaddr[f] if f in objaddr else rng.choice(FLAGS))
        put32(rec, rec_off + f, value)
    selfd = junk(rng, 0x400)
    put32(selfd, 0x3ce, base)
    put32(selfd, 0x3d6, rng.choice([0, 1, 2, 0x80000000, 0xffffffff]))
    r709 = 0 if early else rng.choice([1, 0x100, 0xffffffff])
    r6334 = rng.choice([0, 1, 0xffffffff, 0x100])
    probe = [('self', 0, 0x400), ('rec', 0, 0x1400)]
    w61e7 = [(0, -1, rec_va + 0x28f, 4, 0)] if rng.random() < 0.3 else []
    wrel = [(0, -1, rec_va + 0x28f, 4, 0)] if rng.random() < 0.2 else []
    stubs = {0x4f709c: stub(0x4f709c, THISCALL(0), probe, results=[r709]), 0x4f6334: stub(0x4f6334, THISCALL(1), probe, results=[r6334]),
             0x4f61e7: stub(0x4f61e7, THISCALL(1), probe, results=[rng.randrange(1 << 32)], writes=w61e7), 0x51dc6c: stub(0x51dc6c, CDECL(1), probe),
             0x4fcef0: stub(0x4fcef0, CDECL(1), probe), 0x50cee4: stub(0x50cee4, CDECL(1), probe),
             VT_REL: stub(VT_REL, STDCALL(1), probe, results=[rng.randrange(1 << 32)], writes=wrel)}
    areas = [Area('self', od.region_va(0), selfd, image=False), Area('rec', od.region_va(1), rec, image=False), Area('o293', od.region_va(2), objs[0x293], image=False),
             Area('o29b', od.region_va(5), objs[0x29b], image=False), Area('o28f', 0 if low else od.region_va(6), objs[0x28f], image=False), Area('vtbl', od.region_va(3), vt, image=False)]
    return make('4f356e', areas, stubs, {}, [idx], (idx,), (early, combo))


# 0x4fadc4 ---------------------------------------------------------------------------------------------------------------------------

F32 = lambda v: struct.pack('<f', v)
FLOATS = (0.0, -0.0, 1.0, -1.0, 2.0, 1000.5, 1e-30, 3.4e38, -3.4e38, float('inf'), float('-inf'), float('nan'), 0.35, 12345.678, -77.25, 1.0e-45)
SELF_4FADC4 = 0xb800


def profiles_4fadc4():
    return [(dbg, r, k) for dbg in (0, 1, 0x8000, 0xffff) for r in (0, 1, 0x100, 0xffffffff) for k in range(4)]


def gen_4fadc4(rng, n):
    (dbg, r, k), variant = prof(n, profiles_4fadc4())
    slot16 = k
    d = junk(rng, SELF_4FADC4)
    rec = slot16 * 0x5bb
    idx_a, idx_b = rng.choice([0, 1, 2, 3, 5, 0xffff, 0xfffe, 0xfffd]), rng.choice([0, 1, 2, 3, 7, 0xffff])
    put16(d, rec + 0x10c, idx_a)
    for i in range(-3, 8):
        d[0xb764 + 4 * i:0xb764 + 4 * i + 4] = F32(rng.choice(FLOATS)) if rng.random() < 0.8 else rng.randbytes(4)
    d[rec + 0x138:rec + 0x13c] = F32(rng.choice(FLOATS)) if rng.random() < 0.8 else rng.randbytes(4)
    d[rec + 0x13c:rec + 0x140] = F32(rng.choice(FLOATS)) if rng.random() < 0.8 else rng.randbytes(4)
    if variant % 2:
        put16(d, rec + 0x10c, idx_b)
    name = zstring(rng, rng.choice([0, 1, 2, 3, 4, 5, 7, 0x10, 0x31]), 0x40)
    probe = [('self', 0, 0x1400), ('self', 0xb740, 0x60)]
    g, nbr = debug_areas(rng, dbg)
    stubs = debug_stubs({0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x4f379c: stub(0x4f379c, THISCALL(1), probe, results=[r]),
                         0x4fa2a8: stub(0x4fa2a8, THISCALL(0), probe, results=[rng.randrange(1 << 32)]), 0x52139c: stub(0x52139c, STDCALL(3), probe)}, probe)
    stubs[0x50ca3e].arg_seq = [4, 5] if dbg else [5]
    slot = (rng.choice([0, 1, 0xffff, rng.randrange(0x10000)]) << 16) | k
    areas = [Area('self', od.region_va(0), d, image=False), Area('name', od.region_va(1), name, image=False), *nbr]
    return make('4fadc4', areas, stubs, g, [od.region_va(1), slot], (od.region_va(1), slot), (dbg, r, k))


# 0x423142 ---------------------------------------------------------------------------------------------------------------------------

def profiles_423142():
    return [(chain, idx, kind) for chain in range(4) for idx in (0, 1, 0x3f, -1) for kind in ('ok', 'nodenull', 'ctor0', 'ctorother')]


def gen_423142(rng, n):
    (chain, idx, kind), variant = prof(n, profiles_423142())
    self_off = 0x100
    d = junk(rng, 0x800)
    nodes = junk(rng, 0x400)
    addr = [od.region_va(1) + 0x60 * i for i in range(3)]
    cell_off = self_off + 4 * idx
    # the chain: the table cell holds node 0 (when chain >= 1), node i's cell at +0x25 holds node i + 1, the last cell is zero
    put32(d, cell_off, addr[0] if chain >= 1 else 0)
    for i in range(3):
        put32(nodes, 0x60 * i + 0x25, addr[i + 1] if i + 1 < chain else 0)
    new_va, buf_va = od.region_va(2), od.region_va(3)
    newnode = junk(rng, 0x80)
    bufd = junk(rng, 0x80)
    nulld = junk(rng, 0x100)
    name = zstring(rng, [0, 1, 2, 3, 4, 7, 8, 0x20, 0x23, 0x24][(variant + n) % 10], 0x60)
    value = zstring(rng, [0, 1, 3, 4, 5, 0x20, 0x40, 0x4f][(variant + n // 3) % 8], 0x60)
    node_ret = 0 if kind == 'nodenull' else new_va + rng.choice([0, 4, 0x10])
    ctor_ret = {'ok': node_ret, 'nodenull': 0, 'ctor0': 0, 'ctorother': new_va + 0x30}[kind]
    probe = [('self', 0, 0x800), ('nodes', 0, 0x400), ('newnode', 0, 0x80), ('buf', 0, 0x80), ('null', 0, 0x100)]
    stubs = {0x423368: stub(0x423368, THISCALL(1), probe, results=[idx & 0xffffffff]), 0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[node_ret, buf_va + rng.choice([0, 8])]),
             0x423000: stub(0x423000, THISCALL(0), probe, results=[ctor_ret])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('nodes', od.region_va(1), nodes, image=False), Area('newnode', new_va, newnode, image=False),
             Area('buf', buf_va, bufd, image=False), Area('null', 0, nulld, image=False), Area('name', od.region_va(4), name, image=False),
             Area('value', od.region_va(5), value, image=False)]
    sc = make('423142', areas, stubs, {}, [od.region_va(4), od.region_va(5)], (od.region_va(4), od.region_va(5)), (chain, idx, kind), self_off=self_off)
    sc.seh = rng.randrange(1 << 32)
    return sc


def _count(key):
    return {'423368': len(profiles_423368()) * 2}.get(key)


SPECS = {
    '4235fd': dict(id=1, va=0x4235fd, size=55, gen=gen_4235fd, cleanup=0, ret=0xffffffff, ret_ptr=True, n=len(COUNTS_4235FD) * 2),
    '4fc808': dict(id=2, va=0x4fc808, size=112, gen=gen_4fc808, cleanup=4, n=40),
    '4237f7': dict(id=3, va=0x4237f7, size=127, gen=gen_4237f7, cleanup=0, ret=0xffffffff, n=34),
    '4236d6': dict(id=4, va=0x4236d6, size=127, gen=gen_4236d6, cleanup=0, ret=0xffffffff, n=34),
    '4f80d3': dict(id=5, va=0x4f80d3, size=132, gen=gen_4f80d3, cleanup=8, ret=0xffffffff, n=72),
    '42356d': dict(id=6, va=0x42356d, size=144, gen=gen_42356d, cleanup=8, n=60),
    '4fb2e3': dict(id=7, va=0x4fb2e3, size=180, gen=gen_4fb2e3, cleanup=4, n=160),
    '4f356e': dict(id=9, va=0x4f356e, size=558, gen=gen_4f356e, cleanup=4, ret=0xffffffff, n=8 + 512 * 2),
    '4fadc4': dict(id=10, va=0x4fadc4, size=468, gen=gen_4fadc4, cleanup=8, ret=0xffffffff, fpcw=0x27f, n=len(profiles_4fadc4()) * 12),
    '423142': dict(id=11, va=0x423142, size=279, gen=gen_423142, cleanup=8, ret=0xffffffff, n=len(profiles_423142()) * 3),
    '423368': dict(id=8, va=0x423368, size=232, code=218, gen=gen_423368, cleanup=4, ret=0xffffffff, n=len(profiles_423368()) * 2),
}
# 0x42342a `jne 0x423437`: the word [ebp-0xc] is zero at that point (the same word was tested non-zero at 0x4233be, and the loop leaves it unchanged
# before it returns), so the taken direction cannot happen; the target instruction runs through 0x4233be
UNTAKEN_ALLOWED['423368'] = {(0x42342a, 'taken'): 'the word [ebp-0xc] is zero after the loop (it was tested non-zero before the loop); 0x423437 runs through 0x4233be'}
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
