"""FL-23 (batch b): the fixtures shared by tests/test_fl23b_differential.py and tests/fl23b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the twelve click handlers of GAME.EXE (see SPECS): the object `this`, the record table at
0x5bb5e5 (stride 0x8d, one slack record below it), the object of the target record, the nine-byte constants, the scripted callees and the
globals. The scenarios cycle through profiles so that every guard of the chain fails in turn (the record-state guard too) and every
selector of the function passes all guards, with the optional parts (the 0x5bb1ca flag, the nine-byte compare at each byte position, the
scripted answers) varying from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees 0x4fb2e3, 0x4f6334, 0x4fb77a, 0x4e26fc, 0x45e6bd and the
GetTickCount import (0x52a23c) are recording stubs (OS or host boundaries); nothing inside the function under test is patched. It returns the
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
TICK_SLOT = 0x52a23c
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl23bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl23b.h').read_text()
    body = re.search(r'typedef struct Fl23bWorld \{(.*?)\} Fl23bWorld;', text, re.S).group(1)
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


# the twelve functions: va, size from the ledger, the object size, the offset of the record index word, the guards of the chain (kind,
# offset[, value]), the selectors of the arms, the nine-byte compares [(selector or None for "any other", record offset or 'item', table
# address)], the callees that are stubbed, whether GetTickCount is imported, the windows of the object that are logged at a call
SPECS = {
    '4a1efd': dict(id=1, va=0x4a1efd, size=92, selfsz=0x80, idx=0x1e, gates=[('nz32', 0x60), ('z8', 0x58), ('z32', 0x4c)], sels=[0x2760]),
    '4ba4f2': dict(id=2, va=0x4ba4f2, size=120, selfsz=0x300, idx=6, gates=[('nz32', 0x34)], sels=[0x276a], callees=[0x4fb2e3], tick=True,
                   probes=[(0, 0x300)]),
    '46957d': dict(id=3, va=0x46957d, size=122, selfsz=0x600, idx=0x7e,
                   gates=[('nz32', 0x55c), ('nz32', 0x158), ('z32', 0x54a), ('weq', 0x548, 0x64)], sels=[0x272e]),
    '4b45ed': dict(id=4, va=0x4b45ed, size=137, selfsz=0x790, idx=0x728,
                   gates=[('nz32', 0x76e), ('z32', 0x77a), ('z32', 0x772), ('wz', 0x750)], sels=[0x2739]),
    '473ffc': dict(id=5, va=0x473ffc, size=162, selfsz=0x1c0, idx=0xc, gates=[('nz32', 0x7a), ('z32', 0x10), ('z32', 0x82), ('z32', 0x7e)],
                   sels=[0x27a1], callees=[0x4e26fc], probes=[(0, 0x90)]),
    '48e851': dict(id=6, va=0x48e851, size=237, selfsz=0x480, idx=0x1e, gates=[('nz32', 0x462), ('z8', 0x45a), ('z32', 0x452)],
                   sels=[0x27b9, 0x27b8]),
    '45e587': dict(id=7, va=0x45e587, size=246, selfsz=0x3b0, idx=0x1e, gates=[('nz8', 0x321), ('z8', 0x2aa), ('ne32', 0x39e, 0xa)],
                   sels=[0x27ef, 0x27ec, 0x27ed], callees=[0x45e6bd], probes=[(0x290, 0x120)]),
    '48ab49': dict(id=8, va=0x48ab49, size=329, selfsz=0x1c0, idx=0x1e, gates=[('nz32', 0x1aa), ('z8', 0x1af), ('z32', 0x1b6)],
                   sels=[0x2757, 0x2756], nines=[(0x2756, 0x344, 0x54e364)], callees=[0x4f6334, 0x4fb2e3], tick=True, probes=[(0x40, 0x20)]),
    '4ab899': dict(id=9, va=0x4ab899, size=353, selfsz=0x80, idx=0x1e, gates=[('nz32', 0x54), ('z8', 0x59), ('z32', 0x5e)],
                   sels=[0x27d0, 0x27ce, 0x27cf], nines=[(0x27ce, 0xab7, 0x550fb8), (0x27cf, 0xb19, 0x550fc4)], callees=[0x4fb2e3], tick=True,
                   probes=[(0x20, 0x50)]),
    '4574e4': dict(id=10, va=0x4574e4, size=358, selfsz=0x50, idx=0x1e, gates=[('nz32', 0x3e), ('z32', 0x24)],
                   sels=[0x27bd, 0x27be, 0x27bc], nines=[(0x27bc, 'item', 0x54a3a8)], callees=[0x4f6334, 0x4fb2e3], tick=True, probes=[(0x20, 0x28)]),
    '47a03c': dict(id=11, va=0x47a03c, size=365, selfsz=0x15a8, idx=0x1e,
                   gates=[('nz32', 0x157a), ('z32', 0x1576), ('z32', 0x24), ('z32', 0x1528)], sels=[0x279d, 0x279c],
                   nines=[(0x279c, 0x1f5, 0x54cb8c)], callees=[0x4f6334, 0x4fb2e3], tick=True, probes=[(0x20, 0x10), (0x1520, 0x70)]),
    '4b2a9e': dict(id=12, va=0x4b2a9e, size=404, selfsz=0x1560, idx=0x1e, gates=[('nz32', 0x1515), ('z32', 0x151d), ('z32', 0x24)],
                   sels=[0x2793, 0x2792], nines=[(0x2792, 0x2d6, 0x551764), (None, 0x274, 0x551770)], callees=[0x4fb77a, 0x4fb2e3], tick=True,
                   probes=[(0x20, 0x10), (0x1510, 0x30)]),
}
KEYS = list(SPECS)
RECORDS_VA = 0x5bb5e5
STUB_SHAPE = {0x4fb2e3: dict(args=1, this=True, cleanup=4), 0x4f6334: dict(args=1, this=True, cleanup=4), 0x4fb77a: dict(args=1, this=True, cleanup=4),
              0x4e26fc: dict(args=0, this=True, cleanup=0), 0x45e6bd: dict(args=3, this=True, cleanup=12)}
WORD_ARGS = {0x4fb2e3: (0,), 0x45e6bd: (2,)}   # (pushed from 16-bit registers: only the low 16 bits are meaningful)


def _set_gate(d, gate, fail, rng):
    kind, off = gate[0], gate[1]
    if kind == 'nz32':
        struct.pack_into('<I', d, off, 0 if fail else rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]))
    elif kind == 'z32':
        struct.pack_into('<I', d, off, rng.choice([1, 0x100, 0x10000, 0x01000000, 0x80000000]) if fail else 0)
    elif kind in ('nz8', 'z8'):
        set_ = (kind == 'nz8') != fail
        d[off] = rng.choice([1, 0x80, 0xff]) if set_ else 0
        d[off + 1:off + 4] = b'\xff\xff\xff'     # (a dword read instead of the byte would see these)
    elif kind == 'weq':
        v = gate[2]
        struct.pack_into('<H', d, off, rng.choice([v ^ 1, v + 0x100, v ^ 0x8000, (v + 7) & 0xffff]) if fail else v)
    elif kind == 'wz':
        struct.pack_into('<H', d, off, rng.choice([1, 0x8000, 0xffff, 0x100]) if fail else 0)
    elif kind == 'ne32':
        struct.pack_into('<I', d, off, gate[2] if fail else rng.choice([0, 5, 0x10a, 0xb, 0xffffffff]))


def build(key, rng, n):
    """Scenario n of function `key`: the profile cycles with n, the optional parts with n // len(profiles)."""
    sp = SPECS[key]
    sels, gates = sp['sels'], sp['gates']
    profiles = [('fail', i) for i in range(len(gates) + 1)] + [('pass', s) for s in [*sels, None]]
    kind, which = profiles[n % len(profiles)]
    variant = n // len(profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    now = rng.choice([1000, 0x7fffffff, 0xffffff40, rng.randrange(1 << 32)])

    def other():
        while True:
            s = rng.choice([0, 1, 0x2710, 0x2800, 0xffffffff, rng.randrange(1 << 32), 0x2760 + rng.randrange(0x80)])
            if s not in sels and s not in (0x2792, 0x2793):
                return s
    if kind == 'pass':
        sel = which if which is not None else other()
        failing = None
    else:
        sel = rng.choice([*sels, other()])
        failing = which
    state_fail = failing == len(gates)
    d = bytearray(rng.randbytes(sp['selfsz']))
    for gi, g in enumerate(gates):
        _set_gate(d, g, gi == failing, rng)
    struct.pack_into('<h', d, sp['idx'], idx)
    # function-specific parts of the object
    item = None
    if key == '4ba4f2':
        struct.pack_into('<I', d, 0x2d4, rng.choice([0, 1, 2, 3, 5, 6, 0xffffffff]))
        struct.pack_into('<I', d, 0x18, od.region_va(3))
    if key == '48e851':
        item = rng.choice([-1, 0, 1, 2, 3, 4, 5])
        struct.pack_into('<h', d, 0x3fe, item)
        at = 0x200 + 0x11 * item
        d[at] = 0 if rng.random() < 0.4 else rng.randrange(1, 256)
    if key == '4574e4':
        item = rng.choice([-1, 0, 1, 2, 5])
        struct.pack_into('<h', d, 0x42, item)
    if key == '47a03c':
        struct.pack_into('<H', d, 0x159a, rng.choice([0, 0x8000, 5, 0x100, 0xffff]))
    if key == '4b2a9e':
        struct.pack_into('<H', d, 0x1531, rng.choice([0, 1, 0x8000, 0x100, rng.randrange(0x10000)]))
    self_area = Area('self', od.region_va(0), d, image=False)
    # the record table: records -1 .. 4; the target holds the object, the others a decoy
    rec = bytearray(rng.randbytes(6 * 0x8d))
    for i in range(-1, 5):
        base = (i + 1) * 0x8d
        struct.pack_into('<I', rec, base, od.region_va(1) if i == idx else od.region_va(4))
        bad = rng.choice([0, 2, 3, 0xffffffff, 0x101, 0x10001])
        struct.pack_into('<I', rec, base + 0x4d, (bad if state_fail else 1) if i == idx else (1 if state_fail else 0))
    records = Area('records', RECORDS_VA - 0x8d, rec)
    obj = bytearray(rng.randbytes(0x1000))
    areas = [self_area, records, Area('obj', od.region_va(1), obj, image=False), Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False)]
    if key == '4ba4f2':
        areas.append(Area('obj18', od.region_va(3), bytearray(rng.randbytes(0x1000)), image=False))
    # the nine-byte constants; the compare of the arm that runs is set equal or different at one byte position
    flag = variant & 1
    nine = ((variant >> 1) % 11) - 1
    pointers = {'records_5bb5e5': ('records', 0x8d)}
    for cond, off, table in sp.get('nines', ()):
        const = bytearray(rng.randbytes(9))
        areas.append(Area('c%x' % table, table, const, compare=False))
        pointers['bytes_%x' % table] = ('c%x' % table, 0)
        active = (sel == cond) if cond is not None else (sel not in sels)
        if off == 'item':
            off = item * 0x31 + 0x197
        if active:
            obj[off:off + 9] = const
            if 0 <= nine <= 8:
                obj[off + nine] ^= rng.choice([1, 0x40, 0x80, 0xff])
            elif nine == 9:
                obj[off + 9] ^= 0x40     # (the tenth byte is not compared)
    g = {'value_5c39e5': sel, 'value_5bb1ca': 0 if flag == 0 else rng.choice([1, 0x100, 0xffffffff])}
    probes = [('self', o, ln) for o, ln in sp.get('probes', ())] + [('records', 0, len(rec))]
    stubs = {}
    for callee in sp.get('callees', ()):
        kw = dict(STUB_SHAPE[callee], probe=probes)
        if callee == 0x4f6334:
            kw['results'] = [0 if variant % 3 != 2 else rng.choice([1, 5, 0x10000, 0x80000000])]
        if callee == 0x4e26fc:
            kw['results'] = [0 if variant % 3 != 2 else rng.choice([1, 0x100, 0x80000000])]
        stubs[callee] = stub(callee, **kw)
    iat = {TICK_SLOT: od.Stub('tick', result=now)} if sp.get('tick') else {}
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat=iat, g=g, ecx=od.region_va(0),
                           tick=now if sp.get('tick') else None, pointers=pointers, word_args=WORD_ARGS, profile=(kind, which), sel=sel)


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
    orig = Original20(image_patches, regions, sc.stubs, sc.iat).run(sc.va, sc.size, ecx=sc.ecx, stack_args=[], read=read)
    if orig.cleanup != 0:
        raise AssertionError('the function popped %d bytes (all twelve end in a plain ret)' % orig.cleanup)
    calls = normalize_original(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()
