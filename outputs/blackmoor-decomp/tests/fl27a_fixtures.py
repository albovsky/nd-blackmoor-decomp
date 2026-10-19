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
KEYS = list(SPECS)


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
