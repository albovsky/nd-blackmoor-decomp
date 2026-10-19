"""FL-24 (batch b): the fixtures shared by tests/test_fl24b_differential.py and tests/fl24b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the handlers of GAME.EXE (see SPECS): the object `this`, the stack arguments, the record
table at 0x5bb5e5 (stride 0x8d, one slack record below it), the object of the target record, the constants, the scripted callees and the
globals. A guard-chain handler cycles through profiles so that every guard of the chain fails in turn (the record-state guard too) and
every selector passes all guards, with the optional parts varying from one pass of the cycle to the next; a handler of another shape has
its own builder. Random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees and imports are recording stubs (OS or host boundaries); nothing inside the function under test is patched. It returns the
result, the normalised ordered call log and a digest of the ordered calls and the memory read back.
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
SCENARIOS = 224


def scenarios(key):
    return SPECS[key].get('scen', SCENARIOS)
WINDOW_END = {}
TICK_SLOT = 0x52a23c
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl24bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl24b.h').read_text()
    body = re.search(r'typedef struct Fl24bWorld \{(.*?)\} Fl24bWorld;', text, re.S).group(1)
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

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        super()._stub_hook(uc, address, size, user)
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


def stub(callee, **kw):
    """A recording stub; probe=[(area name, offset, nbytes), ...] logs the bytes at those places as they are at the call."""
    probe = kw.pop('probe', None)
    s = od.Stub(callee, **kw)
    s.probe = probe
    return s



def mk_scenario(sp, key, rng, *, areas, g=None, stubs=None, iat=None, pointers=None, stack_args=(), sel=0, profile=('x', 0), tick=None):
    """A scenario namespace (the fields run_original and the differential read)."""
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs or {}, iat=iat or {}, g=g or {},
                           ecx=od.region_va(0), tick=tick, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, sel=sel,
                           stack_args=list(stack_args), ret=sp.get('ret'), cleanup=4 * len(stack_args) if sp.get('callee_pops') else 0)


# the functions: va, size from the ledger, code_size (the span without a trailing jump table: the coverage target), id, object size, ...
SPECS = {
    '4dad60': dict(id=1, va=0x4dad60, size=159, selfsz=0x40, ret='self'),
}
KEYS = list(SPECS)
SPECS.update({
    '466073': dict(id=2, va=0x466073, size=468, code=0x1c4, selfsz=0x100, idx=0x1e, gates=[('nz32', 0x49), ('z8', 0x4e)], sels=[0x27d3, 0x27d2],
                   callees=[0x4fb2e3], post=lambda c: post_466073(c), scen=396, probes=[(0, 0x100)]),
})
KEYS = list(SPECS)
RECORDS_VA = 0x5bb5e5
STUB_SHAPE = {0x4fb2e3: dict(args=1, this=True, cleanup=4), 0x4f6334: dict(args=1, this=True, cleanup=4), 0x4fb77a: dict(args=1, this=True, cleanup=4),
              0x4e26fc: dict(args=0, this=True, cleanup=0), 0x45e6bd: dict(args=3, this=True, cleanup=12)}
WORD_ARGS = {0x4fb2e3: (0,), 0x45e6bd: (2,)}   # (pushed from 16-bit registers: only the low 16 bits are meaningful)


def build_4dad60(sp, rng, n):
    d = bytearray(rng.randbytes(sp['selfsz']))
    result = [0, 1, 0xffffffff, 0x80000000, 0x100, 0x10000, rng.randrange(1 << 32)][n % 7]
    iat = {0x52a498: od.Stub(0x52a498, args=1, cleanup=4, result=result)}
    g = {'value_58321d': rng.randrange(1, 256), 'value_58321e': rng.randrange(1, 256)}
    return mk_scenario(sp, '4dad60', rng, areas=[Area('self', od.region_va(0), d, image=False)], g=g, iat=iat)


def _set_gate(d, gate, fail, rng):
    kind, off = gate[0], gate[1]
    if kind == 'nz32':
        struct.pack_into('<I', d, off, 0 if fail else rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]))
    elif kind == 'z32':
        struct.pack_into('<I', d, off, rng.choice([1, 0x100, 0x10000, 0x01000000, 0x80000000]) if fail else 0)
    elif kind in ('nz8', 'z8'):
        set_ = (kind == 'nz8') != fail
        d[off] = rng.choice([1, 0x80, 0xff]) if set_ else 0
        d[off + 1:off + 4] = bytes(rng.randrange(1, 256) for _ in range(3))     # (non-zero: a dword read instead of the byte would see these)
    elif kind == 'weq':
        v = gate[2]
        struct.pack_into('<H', d, off, rng.choice([v ^ 1, v + 0x100, v ^ 0x8000, (v + 7) & 0xffff]) if fail else v)
    elif kind == 'wz':
        struct.pack_into('<H', d, off, rng.choice([1, 0x8000, 0xffff, 0x100]) if fail else 0)
    elif kind == 'ne32':
        struct.pack_into('<I', d, off, gate[2] if fail else rng.choice([0, 5, 0x10a, 0xb, 0xffffffff, 0x1000a, 0x8000000a]))



def other_selector(sp, rng):
    while True:
        s = rng.choice([0, 1, 0x2710, 0x2800, 0xffffffff, rng.randrange(1 << 32), 0x2700 + rng.randrange(0x100), 0x27ab, 0x27ac])
        if s not in sp['sels']:
            return s


def chain_build(key, rng, n):
    """A guard-chain handler: profiles = every guard failing in turn (the record-state guard last), then every selector passing all
    guards, then an unrelated selector. sp['post'](ctx) adds the function-specific parts (it may change ctx.d, ctx.obj, ctx.g, ...)."""
    sp = SPECS[key]
    sels, gates = sp['sels'], sp['gates']
    profiles = [('fail', i) for i in range(len(gates) + 1)] + [('pass', s) for s in [*sels, None]]
    kind, which = profiles[n % len(profiles)]
    variant = n // len(profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])
    if kind == 'pass':
        sel = which if which is not None else other_selector(sp, rng)
        failing = None
    else:
        sel = rng.choice([*sels, other_selector(sp, rng)])
        failing = which
    state_fail = failing == len(gates)
    d = bytearray(rng.randbytes(sp['selfsz']))
    for gi, g in enumerate(gates):
        _set_gate(d, g, gi == failing, rng)
    struct.pack_into('<h', d, sp['idx'], idx)
    rec = bytearray(rng.randbytes(6 * 0x8d))
    for i in range(-1, 5):
        base = (i + 1) * 0x8d
        struct.pack_into('<I', rec, base, od.region_va(1) if i == idx else od.region_va(4))
        bad = rng.choice([0, 2, 3, 0xffffffff, 0x101, 0x10001])
        struct.pack_into('<I', rec, base + 0x4d, (bad if state_fail else 1) if i == idx else (1 if state_fail else 0))
    obj = bytearray(rng.randbytes(0x1000))
    c = SimpleNamespace(d=d, obj=obj, rng=rng, n=n, variant=variant, sel=sel, passing=kind == 'pass', failing=failing, idx=idx, now=now,
                        areas=[], g={}, pointers={}, consts={}, stack_args=[], stubs_results={}, iat={})
    if sp.get('post'):
        sp['post'](c)
    areas = [Area('self', od.region_va(0), d, image=False), Area('records', RECORDS_VA - 0x8d, rec),
             Area('obj', od.region_va(1), obj, image=False),
             Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False), *c.areas]
    pointers = {'records_5bb5e5': ('records', 0x8d), **c.pointers}
    for table, data in c.consts.items():
        areas.append(Area('c%x' % table, table, bytearray(data), compare=False))
        pointers['bytes_%x' % table] = ('c%x' % table, 0)
    g = {'value_5c39e5': sel, **c.g}
    probes = [('self', o, ln) for o, ln in sp.get('probes', ())] + [('records', 0, len(rec))]
    stubs = {}
    for callee in sp.get('callees', ()):
        kw = dict(STUB_SHAPE[callee], probe=probes)
        if callee in c.stubs_results:
            kw['results'] = c.stubs_results[callee]
        stubs[callee] = stub(callee, **kw)
    iat = dict(c.iat)
    if sp.get('tick'):
        iat[TICK_SLOT] = od.Stub('tick', result=now)
    return mk_scenario(sp, key, rng, areas=areas, g=g, stubs=stubs, iat=iat, pointers=pointers, stack_args=c.stack_args, sel=sel,
                       profile=(kind, which), tick=now if sp.get('tick') else None)


def nine_const(c, table, off, obj, active, rng=None):
    """Sets the constant at `table` and, when the compare is active, the nine bytes of obj at `off` equal to it or different at the byte
    `nine` (0..8; 9 = only the tenth byte, which is not compared; -1 = equal)."""
    rng = rng or c.rng
    const = rng.randbytes(9)
    c.consts[table] = const
    if active:
        obj[off:off + 9] = const
        nine = ((c.variant >> 1) % 11) - 1
        if 0 <= nine <= 8:
            obj[off + nine] ^= rng.choice([1, 0x40, 0x80, 0xff])
        elif nine == 9:
            obj[off + 9] ^= 0x40
    return const


def post_466073(c):
    d, obj, rng, v = c.d, c.obj, c.rng, c.variant
    sw = [1, 4, 2, 3, 0, 5, 0xffff, 0x8000, 4, 3, 2, 1, 0x7fff][v % 13]
    struct.pack_into('<H', d, 0x28, sw)
    struct.pack_into('<H', d, 0x2c, rng.choice([0, 1, 2, 3, 4, 0xffff, 0x8000, 0x7fff]))
    struct.pack_into('<H', d, 0x2a, rng.choice([0, 1, 0xffff, 0x8000, 0x7fff, rng.randrange(0x10000)]))
    d[0x3e] = rng.choice([0, 0, 1, 0x80, 0xff])
    off = {1: 0x43e, 4: 0x46f, 2: 0x40d, 3: 0x40d}.get(sw)
    flag = v & 1
    if off is None:
        flag = 0     # (the out-of-range arm compares an uninitialised local: the original reads stack garbage, the port zero; not comparable)
    c.g['value_5bb1ca'] = 0 if flag == 0 else rng.choice([1, 0x100, 0xffffffff])
    nine_const(c, 0x54b54c, off if off is not None else 0, obj, c.sel == 0x27d2 and off is not None)
    c.stubs_results[0x4fb2e3] = [0]


# BUILDERS-END
BUILDERS = {k: (globals()['build_' + k] if 'build_' + k in globals() else (lambda sp, rng, n, _k=k: chain_build(_k, rng, n))) for k in KEYS}


def build(key, rng, n):
    return BUILDERS[key](SPECS[key], rng, n)


def normalize_original(calls, stubs, iat, word_args=None):
    """The original's call log as comparable lists: [callee or 'tick', ecx, *args (word arguments by their low 16 bits), probe]."""
    by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
    out = []
    for call in calls:
        s = by_name[call[0]]
        entry = [call[0], call[1] if s.this else 0]
        rest = list(call[2 if s.this else 1:])
        probe = rest.pop() if getattr(s, 'probe_addr', None) else None
        wa = (word_args or {}).get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out


def run_original(sc):
    """Runs the original bytes on the scenario. Returns (Result, normalised calls, digest of the ordered calls and the memory read back)."""
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
    orig = Original20(image_patches, regions, sc.stubs, sc.iat).run(sc.va, SPECS[sc.key].get('code', sc.size), ecx=sc.ecx, stack_args=sc.stack_args, read=read)
    if orig.cleanup != sc.cleanup:
        raise AssertionError('%s popped %d bytes, expected %d' % (sc.key, orig.cleanup, sc.cleanup))
    if sc.ret == 'self' and orig.eax != sc.ecx:
        raise AssertionError('%s did not return this' % sc.key)
    calls = normalize_original(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr((calls, orig.eax if sc.ret else None)).encode())
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()
