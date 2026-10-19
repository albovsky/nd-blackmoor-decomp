"""FL-27 (batch a): the fixtures shared by tests/test_fl27a_differential.py and tests/fl27a_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`, the argument objects (a Bink handle, a string,
a slot, the state dwords at 0x637fd3), the scripted callees and imports, and the globals. The scenarios cycle through profiles (each
guard failing in turn, then every arm of the function); the optional parts (the scripted answers, the junk beside each compared value)
vary from one pass of the cycle to the next, and random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario. The hooks are OS and host boundaries: the recording stubs of the
callees that the port reaches through Fl18Host.call (SHAPES: entry address -> arguments, thiscall, bytes popped) and of the imports
(IAT_SHAPES: IAT slot -> arguments, bytes popped; Sleep, Bink). A stub may also (a) store a value into memory at its n-th call (`pokes`:
the other thread that a waiting loop waits for, or the effect of a Bink call on the handle) and (b) stop the run (`halt`: the call
never returns, AfxEndThread). Nothing inside the function under test is patched; every guard, compare, index computation and store of
the bodies runs as original instructions. It returns the result, the normalised ordered call log and a digest of the ordered calls, the
return value and the memory read back.
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


def parse_world():
    """The fields of Fl27aWorld, from the header, as [(name, ctype)]."""
    text = (PROJECT / 'src/original_methods_fl27a.h').read_text()
    body = re.search(r'typedef struct Fl27aWorld \{(.*?)\} Fl27aWorld;', text, re.S).group(1)
    body = re.sub(r'/\*.*?\*/', '', body, flags=re.S)
    fields = []
    for decl in body.split(';'):
        decl = decl.strip()
        if not decl:
            continue
        kind, _, names = decl.partition(' ')
        for name in names.split(','):
            fields.append((name.strip(), CTYPES[kind]))
    return fields


WORLD_FIELDS = parse_world()


class World(ctypes.Structure):
    _fields_ = WORLD_FIELDS


# the globals of the original (the field name ends with the address); `native_*` fields are not original memory
GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t in WORLD_FIELDS if not n.startswith('native_')}
FMT = {1: '<B', 2: '<H', 4: '<I'}


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
SHAPES = {0x4bf38c: (0, True, 0), 0x4bede7: (0, True, 0), 0x4e053f: (1, True, 4), 0x4e1113: (0, True, 0),
          0x415db9: (2, True, 8), 0x415011: (1, True, 4), 0x4c97b4: (0, True, 0), 0x4c2e5b: (1, True, 4),
          0x41546f: (1, True, 4), 0x4156ea: (1, True, 4),
          0x50ca3e: (4, False, 0), 0x51dc6c: (1, False, 0), 0x50d0a9: (2, False, 0), 0x50cee4: (1, False, 0), 0x44c4ab: (1, False, 0),
          0x52139c: (3, False, 12), 0x51ec84: (2, False, 8)}
# the imports called through their IAT slot: (stack arguments, bytes popped)
IAT_SHAPES = {0x52a2b0: (1, 4), 0x52a52c: (1, 4), 0x52a508: (2, 8), 0x52a528: (1, 4), 0x52a524: (7, 28), 0x52a530: (3, 12),
              0x52a520: (1, 4), 0x52a518: (2, 8)}
# stack arguments that are pushed from 16-bit registers (only the low 16 bits are meaningful), by position
WORD_ARGS = {0x415db9: (1,)}


class Original27(od.Original):
    """od.Original whose stubs can log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)]), store
    values at their n-th call (stub.pokes = {n: [(address, size, value)]}), stop the run (stub.halt), and which records the executed
    (previous instruction, next instruction) pairs: after a conditional jump the next address says which way it went."""

    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        self.edges = set()
        self.last = None
        self.halted = False
        self._nth = {}

    def _count(self, uc, address, size, user):
        super()._count(uc, address, size, user)
        if self.last is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        nth = self._nth.get(address, 0)
        self._nth[address] = nth + 1
        for a, n, v in (getattr(stub, 'pokes', None) or {}).get(nth, ()):
            uc.mem_write(a, struct.pack('<I', v & 0xffffffff)[:n])
        super()._stub_hook(uc, address, size, user)
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)
        if getattr(stub, 'halt', False):
            self.halted = True
            uc.emu_stop()

    def run(self, va, body_size, *, ecx=0x33333333, stack_args=(), read=None, limit=400000):
        uc, r = self.uc, self._r
        esp = od.STACK_BASE + od.STACK_SIZE - 0x100
        uc.mem_write(od.STACK_BASE, b'\x71' * od.STACK_SIZE)
        frame = struct.pack('<%dI' % (len(stack_args) + 1), od.STOP, *stack_args)
        sp = esp - len(frame)
        uc.mem_write(sp, frame)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=ecx, EDX=0x44444444, ESI=0x55555555, EDI=0x66666666, EBP=0x77777777).items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ESP'], sp)
        uc.hook_add(od.unicorn.UC_HOOK_CODE, self._count, begin=va, end=va + body_size - 1)
        uc.emu_start(va, od.STOP, count=limit)
        if not self.halted and uc.reg_read(r['EIP']) != od.STOP:
            raise RuntimeError('original did not return (instruction limit?) at 0x%x' % uc.reg_read(r['EIP']))
        memory = {name: bytes(uc.mem_read(a, n)) for name, (a, n) in (read or {}).items()}
        return od.Result(eax=uc.reg_read(r['EAX']), cleanup=uc.reg_read(r['ESP']) - sp - 4, memory=memory, calls=self.calls, executed=self.executed)


def stub(callee, probe=None, results=None, pokes=None, halt=False):
    """The recording stub of a callee (SHAPES) or an import (IAT_SHAPES)."""
    if callee in IAT_SHAPES:
        nargs, cleanup = IAT_SHAPES[callee]
        s = od.Stub(callee, args=nargs, this=False, cleanup=cleanup, results=results)
    else:
        nargs, this, cleanup = SHAPES[callee]
        s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    s.pokes = pokes
    s.halt = halt
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)


def make(key, areas, stubs, g, stack, args, profile, probes=None, ecx=None):
    """A scenario. `probes` are the places [(area name or 'g:field', offset, length)] that every stub without its own list logs at its call."""
    sp = SPECS[key]
    for s in stubs.values():
        if s.probe is None and probes:
            s.probe = probes
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, g=g, ecx=od.region_va(0) if ecx is None else ecx,
                           word_args=WORD_ARGS, profile=profile, stack=stack, args=args)


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
        if x.probe:
            x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in x.probe]
    plain = {k: v for k, v in sc.stubs.items() if k not in IAT_SHAPES}
    iat = {k: v for k, v in sc.stubs.items() if k in IAT_SHAPES}
    runner = Original27(image_patches, regions, plain, iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = runner.edges
    orig.halted = runner.halted
    if not runner.halted and orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax & SPECS[sc.key]['ret']))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


def conditional_edges(va, size):
    """[(jcc address, mnemonic, taken-edge target, fall-through address)] of every conditional jump of the original function (loop and
    jecxz forms included), by linear disassembly of the code part."""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
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


def normalize(calls, stubs, word_args):
    """The original's call log as comparable lists: [callee, ecx or 0, *args (word arguments by their low 16 bits), probe]."""
    by_name = {s.name: s for s in stubs.values()}
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

SELF_LEN = 0xa00
SPECS = {}


def junk_self(rng, n=SELF_LEN):
    return bytearray(rng.randbytes(n))


def gen_4de1f5(rng, n):
    """The dword at +0x991 (unaligned) is cleared and the byte 0x5a161f is cleared; the bytes beside both are junk and must stay."""
    variant = n
    d = junk_self(rng)
    if variant % 2:
        d[0x990] = d[0x995] = 0xff
        put32(d, 0x991, 0xffffffff)
    g = {'byte_5a161f': rng.choice([0, 1, 0x80, 0xff])}
    return make('4de1f5', [Area('self', od.region_va(0), d, image=False)], {}, g, [], (), (variant,))


SPECS['4de1f5'] = dict(id=1, va=0x4de1f5, size=31, gen=gen_4de1f5, cleanup=0, n=16)
def gen_4de214(rng, n):
    """0x4de214 only calls 0x4de1f5 (run as original bytes in the oracle): the same fixtures as 0x4de1f5."""
    d = junk_self(rng)
    if n % 2:
        d[0x990] = d[0x995] = 0xff
        put32(d, 0x991, 0xffffffff)
    g = {'byte_5a161f': rng.choice([0, 1, 0x80, 0xff])}
    return make('4de214', [Area('self', od.region_va(0), d, image=False)], {}, g, [], (), (n,))


SPECS['4de214'] = dict(id=2, va=0x4de214, size=19, gen=gen_4de214, cleanup=0, n=16)

def gen_4de2d8(rng, n):
    """Both callees see [self+0x991] = 1 and the globals not yet cleared; the function then clears them (through 0x4de214)."""
    d = junk_self(rng)
    if n % 2:
        d[0x990] = d[0x995] = 0xff
    put32(d, 0x991, rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)]))
    g = {'byte_5a161f': rng.choice([0, 1, 0x80, 0xff]), 'value_5b15d6': rng.choice([0, 1, 0x100, 0xffffffff, rng.randrange(1 << 32)]),
         'value_5d17f5': rng.choice([0, 1, 0x10000, 0xffffffff, rng.randrange(1 << 32)])}
    probes = [('self', 0, SELF_LEN), ('g:byte_5a161f', 0, 1), ('g:value_5b15d6', 0, 4), ('g:value_5d17f5', 0, 4)]
    stubs = {0x4e053f: stub(0x4e053f, results=[rng.randrange(1 << 32)]), 0x4e1113: stub(0x4e1113, results=[rng.randrange(1 << 32)])}
    return make('4de2d8', [Area('self', od.region_va(0), d, image=False)], stubs, g, [], (), (n,), probes=probes)


SPECS['4de2d8'] = dict(id=3, va=0x4de2d8, size=74, gen=gen_4de2d8, cleanup=0, n=32)

def gen_449d90(rng, n):
    """The open call answers zero (return 0, no close) or a handle (the close gets that very value, return 1)."""
    answers = [0, 1, 0x100, 0x80000000, 0xffffffff, 0x10000, None]
    answer = answers[n % len(answers)]
    if answer is None:
        answer = rng.randrange(1, 1 << 32)
    path = od.region_va(1) + rng.choice([0, 1, 0x20])
    stubs = {0x50d0a9: stub(0x50d0a9, results=[answer]), 0x50cee4: stub(0x50cee4, results=[rng.randrange(1 << 32)])}
    areas = [Area('path', od.region_va(1), bytearray(rng.randbytes(0x40)), image=False)]
    return make('449d90', areas, stubs, {}, [path], (path,), (answer,))


SPECS['449d90'] = dict(id=4, va=0x449d90, size=55, gen=gen_449d90, ret=0xffffffff, cleanup=0, n=21)

def gen_44c479(rng, n):
    """The state dword (at an odd address, junk beside it): not 1 and not 2 -> stored 1 and returned 1; 2 -> returned 2 untouched; 1 -> Sleep(1)
    until a poke of the other thread (at the k-th Sleep) changes it, then the same two outcomes."""
    profiles = [('init', v) for v in (0, 3, 4, 0x100, 0x10000, 0x01000000, 0x80000000, 0xffffffff, 2)]
    profiles += [('wait', k, v) for k in (0, 1, 2, 4) for v in (0, 2, 3, 0x101, 0xffffffff, 0x100)]
    profiles += [('wait', 0, 2), ('relapse', 2, 2), ('relapse', 3, 0)]       # (relapse: the state goes 1 -> 5 -> 1 again before it ends)
    (kind, *rest), variant = prof(n, profiles)
    off = rng.choice([1, 3, 5, 0x11])
    flag_va = od.region_va(1) + off
    area = bytearray(rng.randbytes(0x40))
    # junk beside the dword: its neighbours must stay
    state = rest[0] if kind == 'init' else 1
    put32(area, off, state)
    pokes = {}
    if kind == 'wait':
        pokes[rest[0]] = [(flag_va, 4, rest[1])]
    elif kind == 'relapse':
        pokes[0] = [(flag_va, 4, 5)]
        pokes[1] = [(flag_va, 4, 1)]
        pokes[rest[0]] = [(flag_va, 4, rest[1])]
    stubs = {0x52a2b0: stub(0x52a2b0, probe=[('flag', 0, 0x40)], pokes=pokes or None)}
    return make('44c479', [Area('flag', od.region_va(1), area, image=False)], stubs, {}, [flag_va], (flag_va,), (kind, *rest))


SPECS['44c479'] = dict(id=5, va=0x44c479, size=50, gen=gen_44c479, ret=0xffff, cleanup=0, n=60)

def bink_area(rng, size=0x100):
    return bytearray(rng.randbytes(size))


def gen_4bee2c(rng, n):
    """The handle is null (error code stored, -1 returned) or points at an object whose dword +0xc is returned (its neighbours are junk)."""
    profiles = [('null',)] + [('ok', v) for v in (0, 1, 0xffffffff, 0x80000000, 0x100, 0x10000, 0x01000000, None)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    obj = bink_area(rng)
    hoff = rng.choice([0, 4, 0x20])
    handle = 0 if kind == 'null' else od.region_va(1) + hoff
    if kind == 'ok':
        put32(obj, hoff + 0xc, rest[0] if rest[0] is not None else rng.randrange(1 << 32))
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), obj, image=False)]
    return make('4bee2c', areas, stubs, {}, [handle], (handle,), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bee2c'] = dict(id=6, va=0x4bee2c, size=51, gen=gen_4bee2c, ret=0xffffffff, cleanup=4, n=27)

def gen_4bef85(rng, n):
    """null handle -> error code; else _BinkWait answers zero (return 1) or non-zero (return 0)."""
    profiles = [('null',)] + [('wait', v) for v in (0, 1, 2, 0x100, 0x10000, 0x01000000, 0x80000000, 0xffffffff)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    handle = 0 if kind == 'null' else od.region_va(1) + rng.choice([0, 8, 0x30])
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a52c: stub(0x52a52c, results=[rest[0] if rest else 0])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), bink_area(rng), image=False)]
    return make('4bef85', areas, stubs, {}, [handle], (handle,), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bef85'] = dict(id=7, va=0x4bef85, size=67, gen=gen_4bef85, ret=0xffffffff, cleanup=4, n=27)

def gen_4bee5f(rng, n):
    """null handle -> 124 bytes at self+8 cleared (the bytes beside the span stay), error code; else the summary call (handle, self+8) and
    self+8 returned (self is untouched)."""
    profiles = [('null',), ('ok',)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    for k in (7, 8, 0x83, 0x84):
        d[k] = rng.randrange(1, 256)
    handle = 0 if kind == 'null' else od.region_va(1) + rng.choice([0, 8, 0x30])
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a508: stub(0x52a508, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), bink_area(rng), image=False)]
    return make('4bee5f', areas, stubs, {}, [handle], (handle,), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bee5f'] = dict(id=8, va=0x4bee5f, size=84, gen=gen_4bee5f, ret=0xffffffff, ret_ptr=True, cleanup=4, n=16)

def gen_4befc8(rng, n):
    """[self+0xbc] is cleared right after the first call (the import sees it zero); null handle -> error code, 0 returned; else the import's
    answer is stored there and returned."""
    profiles = [('null',)] + [('frame', v) for v in (0, 1, 2, 0x100, 0x10000, 0x01000000, 0x80000000, 0xffffffff)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    put32(d, 0xbc, rng.choice([0xffffffff, 1, rng.randrange(1, 1 << 32)]))
    handle = 0 if kind == 'null' else od.region_va(1) + rng.choice([0, 8, 0x30])
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a528: stub(0x52a528, results=[rest[0] if rest else 0])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), bink_area(rng), image=False)]
    return make('4befc8', areas, stubs, {}, [handle], (handle,), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4befc8'] = dict(id=9, va=0x4befc8, size=92, gen=gen_4befc8, ret=0xffffffff, cleanup=4, n=27)

def gen_4bef11(rng, n):
    """null handle -> error code, -3 returned; else [self+0x2c4] = mode; mode 1 goes to the frame count [handle+8], every other mode (dword
    compare: 0x101, 0x10000, ...) to frame 1."""
    modes = (0, 1, 2, 3, 0x100, 0x101, 0x10000, 0x01000000, 0x80000000, 0xffffffff)
    profiles = [('null', 5)] + [('mode', m) for m in modes]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    obj = bink_area(rng)
    hoff = rng.choice([0, 4, 0x20])
    handle = 0 if kind == 'null' else od.region_va(1) + hoff
    mode = rest[0]
    put32(obj, hoff + 8, rng.choice([0, 1, 2, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)]))
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a530: stub(0x52a530, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), obj, image=False)]
    return make('4bef11', areas, stubs, {}, [handle, mode], (handle, mode), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bef11'] = dict(id=10, va=0x4bef11, size=116, gen=gen_4bef11, ret=0xffffffff, cleanup=8, n=33)

def gen_4bf098(rng, n):
    """null handle -> error code, [self+0xbc] (0) returned; else the import gets the six arguments and [self+4], its answer is stored in
    [self+0xbc] (cleared before) and returned."""
    profiles = [('null',)] + [('copy', v) for v in (0, 1, 2, 0x100, 0x10000, 0x01000000, 0x80000000, 0xffffffff)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    put32(d, 0xbc, rng.choice([0xffffffff, 1, rng.randrange(1, 1 << 32)]))
    handle = 0 if kind == 'null' else od.region_va(1) + rng.choice([0, 8, 0x30])
    others = [rng.randrange(1 << 32) for _ in range(5)]
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a524: stub(0x52a524, results=[rest[0] if rest else 0])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), bink_area(rng), image=False)]
    return make('4bf098', areas, stubs, {}, [handle, *others], (handle, *others), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bf098'] = dict(id=11, va=0x4bf098, size=119, gen=gen_4bf098, ret=0xffffffff, cleanup=0x18, n=27)

def gen_4bf10f(rng, n):
    """null handle -> error code; mode (dword [self+0x2c4]) not 1: current == total (0) or not (NextFrame, 1); mode 1: current == 1 (0) or not
    (Goto current-1, 1). The dword compares are probed with values that agree in their low byte or word only."""
    modes = (0, 2, 0x100, 0x101, 0x10000, 0x80000000, 0xffffffff)
    curs = (0, 2, 0x100, 0x101, 0x10001, 0x10000, 0x80000000, 0xffffffff, 5)
    profiles = [('null',)] + [('other', m, 'eq') for m in modes] + [('other', m, 'ne') for m in modes] + [('one', 1)] + [('one', c) for c in curs]
    profiles += [('other', 0, 'ne_hi'), ('other', 2, 'ne_lo'), ('other', 0xffffffff, 'ne_mid')]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    obj = bink_area(rng)
    hoff = rng.choice([0, 4, 0x20])
    handle = 0 if kind == 'null' else od.region_va(1) + hoff
    mode = 1 if kind == 'one' else (rest[0] if kind == 'other' else rng.choice([0, 1, 5]))
    put32(d, 0x2c4, mode)
    total = rng.choice([1, 2, 0x100, 0x7fffffff, 0xffffffff, rng.randrange(1 << 32)])
    cur = total
    if kind == 'other' and rest[1] != 'eq':
        cur = {'ne': total ^ 1, 'ne_hi': total ^ 0x01000000, 'ne_lo': total ^ 0x80, 'ne_mid': total ^ 0x00010000}[rest[1]]
    if kind == 'one':
        cur = rest[0]
    put32(obj, hoff + 8, total)
    put32(obj, hoff + 0xc, cur)
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x52a520: stub(0x52a520, results=[rng.randrange(1 << 32)]),
             0x52a530: stub(0x52a530, results=[rng.randrange(1 << 32)])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('bink', od.region_va(1), obj, image=False)]
    return make('4bf10f', areas, stubs, {}, [handle], (handle,), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bf10f'] = dict(id=12, va=0x4bf10f, size=139, gen=gen_4bf10f, ret=0xffffffff, cleanup=4, n=36)

def gen_4bf315(rng, n):
    """An empty name (first byte zero, junk after it; error code -5) or a name of 1 to 0x30 bytes whose first byte is non-zero (including
    0x80 and 0xff): _BinkOpen answers zero (error code -6) or a handle (returned)."""
    profiles = [('empty',), ('empty',)] + [('open', v) for v in (0, 0, 1, 2, 0x100, 0x10000, 0x01000000, 0x80000000, 0xffffffff)]
    (kind, *rest), variant = prof(n, profiles)
    d = junk_self(rng)
    s = bytearray(rng.randbytes(0x40))
    noff = rng.choice([0, 1, 7])
    length = 0 if kind == 'empty' else rng.choice([1, 1, 2, 5, 0x30 - noff])
    for k in range(length):
        s[noff + k] = rng.choice([1, 0x41, 0x80, 0xff, rng.randrange(1, 256)])
    s[noff + length] = 0
    if kind == 'empty' and variant % 2:
        s[noff + 1] = rng.randrange(1, 256)
    name = od.region_va(1) + noff
    flags = rng.randrange(1 << 32)
    stubs = {0x4bf38c: stub(0x4bf38c, results=[rng.randrange(1 << 32)]), 0x4bede7: stub(0x4bede7, results=[rng.randrange(1 << 32)]),
             0x52a518: stub(0x52a518, results=[rest[0] if rest else 0])}
    areas = [Area('self', od.region_va(0), d, image=False), Area('name', od.region_va(1), s, image=False)]
    return make('4bf315', areas, stubs, {}, [name, flags], (name, flags), (kind, *rest), probes=[('self', 0, 0x300)])


SPECS['4bf315'] = dict(id=13, va=0x4bf315, size=119, gen=gen_4bf315, ret=0xffffffff, cleanup=8, n=44)

KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
