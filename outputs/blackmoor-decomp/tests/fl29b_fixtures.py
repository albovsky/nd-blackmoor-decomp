"""FL-29 (batch b): the fixtures shared by tests/test_fl29b_differential.py and tests/fl29b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the objects behind the addresses it keeps, the
vtables, the scripted callees (recording stubs at the call boundary, entered by address, and at the import slots) and the globals. The
scenarios cycle through profiles (each guard failing in turn, then every arm, loop exit and scripted answer of the function); the optional
parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees, the vtable entries and the import slots are recording
stubs (OS or host boundaries); nothing inside the function under test is patched. A stub can also carry scripted WRITES (a callee that
changes `self` or a local of the caller: call number, argument or absolute address, offset, size, value or a byte string) so that a
function's re-reads after a call are exercised. Two more host/OS boundaries are modelled outside the function: the thread information block
behind fs (not used by this batch's functions; kept from the shared harness) and the x87 control word (0x27f, set for 0x4fccf2)
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
    """The fields of Fl29bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl29b.h').read_text()
    body = re.search(r'typedef struct Fl29bWorld \{(.*?)\} Fl29bWorld;', text, re.S).group(1)
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


class Original29b(od.Original):
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
    runner = Original29b(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh, fpcw=SPECS[sc.key].get('fpcw'))
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


def arg_mask(word_args, callee, position):
    """The mask of a stack argument that the callee reads only partly: 0xffff for a word (a tuple of positions), or the mask given in a dict {position: mask}."""
    wa = word_args.get(callee, ())
    return wa[position] if isinstance(wa, dict) else 0xffff


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
                entry.append(v & arg_mask(word_args, call[0], position))
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        entry.extend(derefs)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out



# ---- the ten functions of batch b ---------------------------------------------------------------------------------------------------

def world_values(rng):
    return {name: rng.randrange(1 << (8 * size)) for name, (address, size) in GLOBALS.items()}


SPECS = {}
NAMES = {}
SELF_SIZE = 0xc800
CELLS_VA, SRC_VA, DST_VA = od.region_va(1), od.region_va(2), od.region_va(3)


def finish(key, name, **spec):
    SPECS[key] = dict(spec)
    NAMES[key] = name


def self_area(s):
    return Area('self', od.region_va(0), s, image=False)


def rand_nonzero32(rng):
    return rng.choice([1, 0x100, 0x10000, 0x1000000, 0x80000000, 0xffffffff, 0x20010000, rng.randrange(1, 1 << 32)])


# ---- 0x4ee69e -----------------------------------------------------------------------------------------------------------------------

def profiles_4ee69e():
    return [('zero', 0)] + [('set', v) for v in (1, 0x100, 0x10000, 0x1000000, 0x80000000, 0xffffffff, 0x12345678)]


def gen_4ee69e(rng, n):
    (kind, v), variant = prof(n, profiles_4ee69e())
    s = bytearray(rng.randbytes(0x800))
    put32(s, 0x252, v)
    results = [rng.choice([0, 1, 0xdeadbeef, 0xffffffff, 0x10000, rng.randrange(1 << 32)])]
    stubs = {0x4ef516: stub(0x4ef516, THISCALL(0), [('self', 0, 0x800)], results=results)}
    return make('4ee69e', [self_area(s)], stubs, {}, [], (), (kind, v))


finish('4ee69e', 'forward_if_set', id=1, va=0x4ee69e, size=41, gen=gen_4ee69e, cleanup=0, ret=True, n=len(profiles_4ee69e()) * 6)


# ---- 0x423aae -----------------------------------------------------------------------------------------------------------------------

def profiles_423aae():
    return [('arg0',), ('q0',)] + [('chain', k) for k in range(0, 6)]


def gen_423aae(rng, n):
    (kind, *rest), variant = prof(n, profiles_423aae())
    obj = bytearray(rng.randbytes(0x400))
    slots = list(range(16))
    rng.shuffle(slots)
    at = lambda i: CELLS_VA + 0x40 * slots[i]
    for i in range(16):         # every object: [+4] and [+0x38] cleared unless the profile sets them
        put32(obj, 0x40 * slots[i] + 4, 0)
        put32(obj, 0x40 * slots[i] + 0x38, 0)
    if kind == 'arg0':
        arg = 0
    else:
        arg = at(0)
        if kind == 'chain':
            put32(obj, 0x40 * slots[0] + 4, at(1))
            for i in range(1, 1 + rest[0]):
                put32(obj, 0x40 * slots[i] + 0x38, at(i + 1))
        else:
            put32(obj, 0x40 * slots[0] + 4, 0)
            if variant % 2:
                put32(obj, 0x40 * slots[0] + 0x38, at(3))
    return make('423aae', [Area('chain', CELLS_VA, obj, image=False)], {}, {}, [arg], (arg,), (kind, *rest))


finish('423aae', 'chain_end', id=2, va=0x423aae, size=67, gen=gen_423aae, cleanup=4, ret=True, n=len(profiles_423aae()) * 4)


# ---- 0x4fccf2 -----------------------------------------------------------------------------------------------------------------------

A_VALUES = [0, 1, 2, 3, 99, 100, 101, 0x7fff, 0x8000, 0xffff, 0x1234, 12345, 255, 256, 33333, 7]
INDEXES = [0, 1, 2, 7, 0x100, 0xffffffff, 0xfffffffe, 0xffffffe0]


def profiles_4fccf2():
    return [(dbg, a, i) for dbg in (0, 1, 0x100, 0x8000, 0xffff) for a in A_VALUES[:8] for i in INDEXES[:3]] + [(0, a, i) for a in A_VALUES for i in INDEXES]


def gen_4fccf2(rng, n):
    (dbg, a, i), variant = prof(n, profiles_4fccf2())
    s = bytearray(rng.randbytes(SELF_SIZE))
    g, nbr = debug_areas(rng, dbg)
    probe = [('self', 0xb600, 0x300)]
    stubs = {0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4fcb5c: stub(0x4fcb5c, THISCALL(1), probe, results=[rng.choice([0, 1, 0xfedcba98, rng.randrange(1 << 32)])])}
    stack_a = (a & 0xffff) | (rng.randrange(1, 0x10000) << 16 if variant % 2 else 0)
    return make('4fccf2', [self_area(s), *nbr], stubs, g, [stack_a, i], (stack_a, i), (dbg, a, i))


finish('4fccf2', 'store_percent', id=3, va=0x4fccf2, size=91, gen=gen_4fccf2, cleanup=8, ret=True, fpcw=0x27f, n=len(profiles_4fccf2()) * 2)


# ---- 0x423a30 -----------------------------------------------------------------------------------------------------------------------

def profiles_423a30():
    return [('null', d) for d in (0, 1, 0x100, 0x8000, 0xffff)] + [('set', v, d) for v in (1, 0x100, 0x20010000, 0x80000000, 0xffffffff) for d in (0, 1)]


def gen_423a30(rng, n):
    (kind, *rest), variant = prof(n, profiles_423a30())
    cell = bytearray(rng.randbytes(0x40))
    dbg = rest[0] if kind == 'null' else rest[1]
    put32(cell, 0, 0 if kind == 'null' else rest[0])
    g, nbr = debug_areas(rng, dbg)
    probe = [('cell', 0, 0x40)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(2), probe), 0x51dc6c: stub(0x51dc6c, CDECL(1), probe), 0x52139c: stub(0x52139c, STDCALL(3), probe),
             0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    return make('423a30', [Area('cell', CELLS_VA, cell, image=False), *nbr], stubs, g, [CELLS_VA], (CELLS_VA,), (kind, *rest))


finish('423a30', 'free_cell', id=4, va=0x423a30, size=126, gen=gen_423a30, cleanup=4, n=len(profiles_423a30()) * 3)


# ---- 0x42e72c -----------------------------------------------------------------------------------------------------------------------

MODES = [2, 0, 1, 3, 0x102, 0x8002, 0xffff, 0x10002]      # the word compared with 2 after the sign extension (0x10002 stores as the word 2)


def profiles_42e72c():
    p = [('none', d) for d in (0, 1, 0x100, 0x8000, 0xffff)]
    p += [('go', t, m) for t in (0, 1, 2, 0x100, 0x8000, 0xffff) for m in MODES]
    return p


def gen_42e72c(rng, n):
    (kind, *rest), variant = prof(n, profiles_42e72c())
    dest = bytearray(rng.randbytes(0x40))
    g = world_values(rng)
    g['word_63a4cd'] = rest[0] if kind == 'none' else rng.choice([0, 1])
    if kind == 'none':
        g['value_5d03bf'] = 0
    else:
        g['value_5d03bf'] = CELLS_VA + rng.choice([0, 4, 0x10, 0x3c]) if (rest[1] & 0xffff) == 2 else rand_nonzero32(rng)
        g['word_5b4dc8'], g['word_5b4e04'] = rest
    probe = [('dest', 0, 0x40), ('g:word_5b4dc8', 0, 2)]
    stubs = {0x44a2b7: stub(0x44a2b7, CDECL(1), probe), 0x44c479: stub(0x44c479, CDECL(1), probe), 0x44c4ab: stub(0x44c4ab, CDECL(1), probe)}
    return make('42e72c', [Area('dest', CELLS_VA, dest, image=False)], stubs, g, [], (), (kind, *rest))


finish('42e72c', 'toggle_state', id=5, va=0x42e72c, size=140, gen=gen_42e72c, cleanup=0, n=len(profiles_42e72c()) * 3)


# ---- 0x4e9c2f and 0x411a22 (the cell-pointer copies) --------------------------------------------------------------------------------

SELS = [0, 1, 2, -1, -2, 0x7fff, -0x8000]


def cells_area(rng, dst, src, adv):
    c = bytearray(rng.randbytes(0x40))
    put32(c, 0, dst)
    put32(c, 4, src)
    put32(c, 8, adv)
    return Area('cells', CELLS_VA, c, image=False)


def profiles_4e9c2f():
    p = [('ok', k) for k in range(8)]
    p += [('overlap', k) for k in range(3)]
    p += [('fail', d) for d in (0, 1, 0x100, 0x8000)]
    return p


def gen_4e9c2f(rng, n):
    (kind, k), variant = prof(n, profiles_4e9c2f())
    src = bytearray(rng.randbytes(0x80))
    dst = bytearray(rng.randbytes(0x80))
    src_at = SRC_VA + 0x10 + (k if kind == 'ok' else 0)
    adv = rng.choice([0, 6, 0xfffffffe, 0xfffffffa, rng.randrange(1 << 32)])
    results = [DST_VA + 4]
    writes = []
    dbg = rng.choice([0, 1, 0x8000, 0x100]) if kind != 'fail' else 0
    if kind == 'overlap':          # destination two bytes above the source in the same area: the dword store changes the source word that is read next
        src_at = DST_VA + 8 + k
        results = [DST_VA + 10 + k]
    cells_dst = results[0]
    if kind == 'fail':
        results = [0]
        cells_dst = 0
        dbg = k
        writes = [(0, -1, CELLS_VA, 4, DST_VA + 0x20)]      # the report (0x4c97b4) leaves a valid destination in the cell, so the copy that follows is defined
    g, nbr = debug_areas(rng, dbg)
    g['value_5bb57b'] = rng.randrange(1 << 32)
    g['word_5c39e3'] = rng.choice(SELS)
    probe = [('cells', 0, 0x40), ('dst', 0, 0x80)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=results), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x42639d: stub(0x42639d, THISCALL(2), probe),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe, writes=writes), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    return make('4e9c2f', [cells_area(rng, cells_dst, src_at, adv), Area('src', SRC_VA, src, image=False), Area('dst', DST_VA, dst, image=False), *nbr], stubs, g,
                [CELLS_VA, CELLS_VA + 4, CELLS_VA + 8], (CELLS_VA, CELLS_VA + 4, CELLS_VA + 8), (kind, k))


finish('4e9c2f', 'copy_six', id=6, va=0x4e9c2f, size=176, gen=gen_4e9c2f, cleanup=12, n=len(profiles_4e9c2f()) * 3)


# ---- 0x4e45be -----------------------------------------------------------------------------------------------------------------------

TABLE_VA, ROW = 0x5a1e64, 0x29
LENS = [1, 2, 3, 8, 0x29, 0x2a]


def profiles_4e45be():
    p = [('len0', 1), ('len0', 3)]
    p += [('neglen', c, ln) for c in (1, 3) for ln in (0xffff, 0x8000, 0xfffb)]
    p += [('match', c, r, ln) for c in (1, 2, 3, 5) for r in range(c) for ln in LENS]
    p += [('nomatch', c, 0, ln) for c in (1, 2, 5) for ln in LENS]
    return p


def gen_4e45be(rng, n):
    (kind, *rest), variant = prof(n, profiles_4e45be())
    count = rest[0]
    ln = {'len0': 0, 'neglen': rest[-1] if kind == 'neglen' else 0}.get(kind, rest[2] if kind in ('match', 'nomatch') else 0)
    stop = rest[1] if kind == 'match' else None
    width = ln if 0 < ln < 0x8000 else 0                  # the bytes that the inner loop compares
    table = bytearray(rng.randbytes(0x200))
    bytes_ = bytearray(rng.randbytes(0x40))
    if width:
        for row in range(count):
            base = row * ROW
            if row == stop:
                table[base:base + width] = bytes_[:width]
            elif stop is None or row < stop:
                d = rng.randrange(width) if (variant + row) % 2 else width - 1
                table[base:base + d] = bytes_[:d]
                table[base + d] = (bytes_[d] + rng.randrange(1, 256)) & 0xff
    stack_len = (ln & 0xffff) | (rng.randrange(1, 0x10000) << 16 if variant % 2 else 0)
    out = bytearray(rng.randbytes(0x10))
    g = {'word_5a1e5c': count}
    areas = [Area('out', CELLS_VA, out, image=False), Area('bytes', SRC_VA, bytes_, image=False), Area('tab', TABLE_VA, table, image=True)]
    return make('4e45be', areas, {}, g, [CELLS_VA, SRC_VA, rng.randrange(1 << 32), stack_len], (CELLS_VA, SRC_VA, 0, stack_len), (kind, *rest), pointers={'table_5a1e64': ('tab', 0)})


finish('4e45be', 'find_row', id=7, va=0x4e45be, size=193, gen=gen_4e45be, cleanup=16, ret=True, n=len(profiles_4e45be()) * 2)


# ---- 0x437dcd -----------------------------------------------------------------------------------------------------------------------

CHARS = [0x61, 0x2f, 0x3f, 0x3a, 0x80, 0xff, 0x00, 0x41, 0x2e]
WORD_ARGS[0x437ea1] = {0: 0xff}          # the callee reads only the low byte of its argument (movsx byte [ebp+8]); the original pushes ecx = (this & ~0xff) | c on the first call


def profiles_437dcd():
    p = []
    for e1 in (0, 0x100, 1, 0x80000000):
        for latched in (0, 1, 0x1000000):
            for r1 in (0, 1, 0x100, 0x10000, 0x80000000):
                for c in (CHARS if (e1 and not latched and r1) else CHARS[:2]):
                    for e2 in ((0, 1), (1, 0), (1, 1), (0xff, 0)):
                        p.append((e1, latched, r1, c, e2, 1))
    return p


def gen_437dcd(rng, n):
    (e1, latched, r1, c, (e2, b6b), r2), variant = prof(n, profiles_437dcd())
    r2 = (1, 0, 0x100, 0x10000, 0x80000000)[variant % 5] if (e2 and not b6b) else 1
    ch = bytearray(rng.randbytes(0x10))
    ch[0] = c
    g = {'value_5e32c9': e1, 'value_5e32de': latched, 'byte_5e32dd': rng.randrange(256), 'byte_5b61af': e2, 'byte_5b616b': b6b, 'byte_5b616c': rng.randrange(256)}
    stubs = {0x437ea1: stub(0x437ea1, THISCALL(1), [('ch', 0, 0x10), ('g:byte_5e32dd', 0, 1)], results=[r1, r2]), 0x4a1f59: stub(0x4a1f59, THISCALL(1), [('ch', 0, 0x10)]),
             0x48e93e: stub(0x48e93e, THISCALL(1), [('ch', 0, 0x10)]), 0x4b8193: stub(0x4b8193, THISCALL(1), [('ch', 0, 0x10)])}
    a = [CELLS_VA, rng.randrange(1 << 32), rng.randrange(1 << 32)]
    return make('437dcd', [self_area(bytearray(rng.randbytes(0x100))), Area('ch', CELLS_VA, ch, image=False)], stubs, g, a, tuple(a), (e1, latched, r1, hex(c), e2, b6b))


finish('437dcd', 'note_key', id=8, va=0x437dcd, size=212, gen=gen_437dcd, cleanup=12, n=len(profiles_437dcd()) * 5)


# ---- 0x4e4337 -----------------------------------------------------------------------------------------------------------------------

SIZE_WORDS = [0, 1, 2, 3, 4, 7, 799, 1601, -1598]           # the word [self + 0x1471]: n = (word * 0x29) as a word (all of these give n >= 0)
SRC_SIZE = 0x9000


def profiles_4e4337():
    p = []
    for s in SIZE_WORDS:
        n = ((s * 0x29) & 0xffff)
        total = 0xda1 + n
        for delta in (0, 1, -1, 0x7fffffff - total, -total - 1, None):
            p.append((s, delta))
    return p


def gen_4e4337(rng, n):
    (s, delta), variant = prof(n, profiles_4e4337())
    nn = (s * 0x29) & 0xffff
    total = 0xda1 + nn
    selfd = bytearray(rng.randbytes(SELF_SIZE))
    src = bytearray(rng.randbytes(SRC_SIZE))
    put16(src, 0x2f0 + 0xaaf, s)                      # self + 0x1471 receives the word at src + 0x2f0 + (0x1471 - 0x9c2)
    if delta is None:
        limit = rng.choice([0x80000000, 0xffffffff, 0, 0x7fffffff, total + 0x100000000 - 0x10000, total + 1])
    else:
        limit = (total + delta) & 0xffffffff
    probe = [('self', 0x1460, 0x40), ('self', 0x457b, 0x20)]
    stubs = {0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x4264e8: stub(0x4264e8, THISCALL(1), probe), 0x4c97b4: stub(0x4c97b4, THISCALL(0), probe)}
    return make('4e4337', [self_area(selfd), Area('src', SRC_VA, src, image=False)], stubs, {}, [SRC_VA, limit], (SRC_VA, limit), (s, delta, hex(limit)))


finish('4e4337', 'load_blocks', id=9, va=0x4e4337, size=241, gen=gen_4e4337, cleanup=8, n=len(profiles_4e4337()) * 2)


# ---- 0x411a22 -----------------------------------------------------------------------------------------------------------------------

REC_VA, REC_STRIDE = 0x5bb5e5, 0x8d
S23 = [0, 9, 10, 11, 0xffff, 0x7fff, 0x8000, 0x8001]


def profiles_411a22():
    p = [('ok', w, s) for w in S23 for s in SELS[:5]]
    p += [('overlap', w, 0) for w in (9, 10)]
    p += [('fail', w, s) for w in (9, 10) for s in SELS[:5]]
    return p


def gen_411a22(rng, n):
    (kind, w23, sel), variant = prof(n, profiles_411a22())
    srcobj = bytearray(rng.randbytes(0x80))
    dst = bytearray(rng.randbytes(0x80))
    shift = 0x10 if kind == 'overlap' else rng.choice([0, 1, 3, 4])
    put16(srcobj, shift + 0x23, w23)
    src_at = SRC_VA + shift
    dst_at = SRC_VA + 0x14 if kind == 'overlap' else DST_VA + rng.choice([0, 1, 2, 5])     # overlap: the destination four bytes above the source in the same area
    alloc = 0 if kind == 'fail' else rng.choice([DST_VA + 0x60, 0x20010000, rng.randrange(1, 1 << 32)])
    g, nbr = debug_areas(rng, rng.choice([0, 1, 0x8000, 0x100]))
    g['word_5c39e3'] = sel
    g['value_5bb57b'] = rng.randrange(1 << 32)
    rec = bytearray(rng.randbytes(REC_STRIDE * 5))
    put32(rec, 0x5bb57b - (REC_VA - 2 * REC_STRIDE), g['value_5bb57b'])      # the global 0x5bb57b lies inside the record area (record -1): the same bytes in both
    probe = [('rec', 0, REC_STRIDE * 5), ('cells', 0, 0x40)]
    stubs = {0x51dc43: stub(0x51dc43, CDECL(1), probe, results=[alloc]), 0x50ca3e: stub(0x50ca3e, CDECL(4), probe), 0x42639d: stub(0x42639d, THISCALL(2), probe),
             0x4c97b4: stub(0x4c97b4, THISCALL(0), probe), 0x44a2b7: stub(0x44a2b7, CDECL(1), probe)}
    adv = rng.choice([0, 0x27, 0xffffffe0, rng.randrange(1 << 32)])
    areas = [cells_area(rng, dst_at, src_at, adv), Area('src', SRC_VA, srcobj, image=False), Area('dst', DST_VA, dst, image=False),
             Area('rec', REC_VA - 2 * REC_STRIDE, rec, image=True), *nbr]
    cells = (CELLS_VA, CELLS_VA + 4, CELLS_VA + 8)
    return make('411a22', areas, stubs, g, list(cells), cells, (kind, w23, sel), pointers={'records_5bb5e5': ('rec', 2 * REC_STRIDE)})


finish('411a22', 'alloc_copy', id=10, va=0x411a22, size=244, gen=gen_411a22, cleanup=12, n=len(profiles_411a22()) * 2)

KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
