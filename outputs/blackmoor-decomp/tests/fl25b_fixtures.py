"""FL-25 (batch b): the fixtures shared by tests/test_fl25b_differential.py and tests/fl25b_original_oracle.py.

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
    """The fields of Fl25bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl25b.h').read_text()
    body = re.search(r'typedef struct Fl25bWorld \{(.*?)\} Fl25bWorld;', text, re.S).group(1)
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


def jcc_table(va, size):
    """{address: (taken target, fall-through, mnemonic)} of the conditional jumps (jcc, loop, jecxz) in [va, va+size); jmp, call and ret are
    not conditional. (A jump through a table, `jmp [reg*4+table]`, has no two edges and is not listed.)"""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    out = {}
    for i in md.disasm(pe.image[off:off + size], va):
        if i.mnemonic[0] == 'j' and i.mnemonic != 'jmp' or i.mnemonic.startswith('loop'):
            out[i.address] = (i.operands[0].imm, i.address + i.size, i.mnemonic)
    return out


def untaken_edges(va, size, edges):
    """[(address of a conditional jump, 'taken' | 'fall')]: the directions of the jumps of the function that no run of `edges` took.
    `edges` is the union of Original20.edges ((jump address, address of the next instruction executed))."""
    missing = []
    for address, (target, fall, _) in sorted(jcc_table(va, size).items()):
        if (address, target) not in edges:
            missing.append((address, 'taken'))
        if target != fall and (address, fall) not in edges:
            missing.append((address, 'fall'))
    return missing


# The directions of conditional jumps that no state of the function can take, with the reason (the differential test requires every other
# direction of every jcc of every function to be taken by the scenarios, and every entry here to stay untaken).
UNTAKEN_EDGES = {
    (0x467ac9, 'taken'): 'jne after the je at 0x467a2a on the same two values (word [+0xa] sign-extended vs dword [+0x1ba]); nothing between them changes either',
    (0x4ad409, 'taken'): 'je on dword [+0x20] == 0 after the jne at 0x4ad36e tested the same dword non-zero; no call or store in between',
}


class Original20(od.Original):
    """od.Original whose stubs can also log the bytes at some places as they are at the call (stub.probe_addr = [(address, length)]),
    and which records the edges of the conditional jumps of the function under test: `edges` = {(address of a jcc, address executed next)}."""

    def run(self, va, body_size, **kw):
        table = jcc_table(va, body_size)
        self.edges = set()
        pending = []

        def hook(uc, address, size, user):
            if pending:
                a = pending.pop()
                if address in table[a][:2]:
                    self.edges.add((a, address))
            if address in table:
                pending.append(address)
        self.uc.hook_add(od.unicorn.UC_HOOK_CODE, hook, begin=va, end=va + body_size - 1)
        return super().run(va, body_size, **kw)

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



def mk_scenario(sp, key, rng, *, areas, g=None, stubs=None, iat=None, pointers=None, stack_args=(), sel=0, profile=('x', 0), tick=None, ptr_args=None, self_pad=0):
    """A scenario namespace (the fields run_original and the differential read). `self_pad`: the object is that many bytes into its area (the
    bytes before it are mapped, compared and random, for a handler that can store below its object)."""
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs or {}, iat=iat or {}, g=g or {},
                           ecx=od.region_va(0) + self_pad, self_pad=self_pad, tick=tick, pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, sel=sel,
                           stack_args=list(stack_args), ptr_args=ptr_args or {}, ret=sp.get('ret'), cleanup=4 * len(stack_args) if sp.get('callee_pops') else 0)


# the functions: va, size from the ledger, code_size (the span without a trailing jump table: the coverage target), id, object size, ...
SPECS = {
    '455180': dict(id=1, va=0x455180, size=827, selfsz=0x180, ret='eax', callee_pops=True, scen=640),
    '4cb058': dict(id=2, va=0x4cb058, size=851, selfsz=0x170, ret='eax', callee_pops=True, scen=720),
    '4a3f40': dict(id=3, va=0x4a3f40, size=896, selfsz=0x900, ret='eax', callee_pops=True, scen=720),
    # SPECS-END
}
KEYS = list(SPECS)
RECORDS_VA = 0x5bb5e5
STUB_SHAPE = {0x45504b: dict(args=0, this=True, cleanup=0), 0x4554bb: dict(args=2, this=True, cleanup=8),
              0x4ea06c: dict(args=1, this=True, cleanup=4), 0x4a3beb: dict(args=0, this=True, cleanup=0), 0x4a42c0: dict(args=3, this=True, cleanup=12)}
WORD_ARGS = {0x4554bb: (1,), 0x4ea06c: (0,)}   # (pushed from 16-bit registers: only the low 16 bits are meaningful)


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
    elif kind == 'eq32':
        struct.pack_into('<I', d, off, rng.choice([0, 2, 0x101, 0x10001, 0xffffffff, 0x80000001, 0x100]) if fail else gate[2])
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
    pad = sp.get('pad', 0)
    areas = [Area('self', od.region_va(0), bytearray(rng.randbytes(pad)) + d, image=False), Area('records', RECORDS_VA - 0x8d, rec),
             Area('obj', od.region_va(1), obj, image=False),
             Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False), *c.areas]
    pointers = {'records_5bb5e5': ('records', 0x8d), **c.pointers}
    for table, data in c.consts.items():
        areas.append(Area('c%x' % table, table, bytearray(data), compare=False))
        pointers['bytes_%x' % table] = ('c%x' % table, 0)
    g = {'value_5c39e5': sel, **c.g}
    probes = [('self', o + pad, ln) for o, ln in sp.get('probes', ())] + [('records', 0, len(rec))]
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
                       profile=(kind, which), tick=now if sp.get('tick') else None, self_pad=pad)


def nine_const(c, table, off, obj, active, rng=None, nine=None):
    """Sets the constant at `table` and, when the compare is active, the nine bytes of obj at `off` equal to it or different at the byte
    `nine` (0..8; 9 = only the tenth byte, which is not compared; -1 = equal)."""
    rng = rng or c.rng
    const = rng.randbytes(9)
    c.consts[table] = const
    if active:
        obj[off:off + 9] = const
        nine = ((c.variant >> 1) % 11) - 1 if nine is None else nine
        if 0 <= nine <= 8:
            obj[off + nine] ^= rng.choice([1, 0x40, 0x80, 0xff])
        elif nine == 9:
            obj[off + 9] ^= 0x40
    return const


def span(rng, v, fail=None):
    """(lo, hi) signed dwords around the signed value v: it lies inside unless fail is 'lo' (lo = v + 1) or 'hi' (hi = v - 1)."""
    lo = rng.choice([v, v - 1, v - 7, -0x80000000, v - rng.randrange(1, 400), v - 0x10000])
    hi = rng.choice([v, v + 1, v + 9, 0x7fffffff, v + rng.randrange(1, 400), v + 0x10000])
    if fail == 'lo':
        lo = v + 1
    if fail == 'hi':
        hi = v - 1
    return lo & 0xffffffff, hi & 0xffffffff


def nspan(rng, v, fail=None):
    """A narrow (lo, hi) around v (so the offsets into a mask stay small): v inside unless fail is 'lo' (lo = v + 1) or 'hi' (hi = v - 1)."""
    lo, hi = v - rng.choice([0, 1, 2, 3]), v + rng.choice([0, 1, 2, 3])
    if fail == 'lo':
        lo = v + 1
    if fail == 'hi':
        hi = v - 1
    return lo & 0xffffffff, hi & 0xffffffff


MODES = ['ylo', 'yhi', 'xlo', 'xhi']
COORDS = [0, 1, -1, 100, -100, 0x7fff, -0x8000, 5, 0x1234, -0x1234]


def put_rect(buf, base, offs, x, y, rng, mode=None, narrow=False):
    """Stores the rectangle around (x, y) at buf[base + offs[k]] with offs = (y low, y high, x low, x high); `mode` names the side that misses."""
    f = nspan if narrow else span
    ylo, yhi = f(rng, y, 'lo' if mode == 'ylo' else 'hi' if mode == 'yhi' else None)
    xlo, xhi = f(rng, x, 'lo' if mode == 'xlo' else 'hi' if mode == 'xhi' else None)
    for off, v in zip(offs, (ylo, yhi, xlo, xhi)):
        struct.pack_into('<I', buf, base + off, v)


def different_word(rng, w):
    return (w ^ rng.choice([1, 0x100, 0x8000, 0x0101, 0x4000])) & 0xffff


def build_455180(sp, rng, n):
    PAD = 0x200      # (the entry of the word [+0x36] = -1 lies below the object)
    prof = n % 20
    var = n // 20
    d = bytearray(rng.randbytes(sp['selfsz']))
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    struct.pack_into('<h', d, 0x1e, idx)
    struct.pack_into('<I', d, 0x150, 0 if prof == 0 else rng.choice([1, 0x100, 0x01000000, 0x80000000, rng.randrange(1, 1 << 32)]))
    use2a = prof in (1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 17)
    if prof == 0:
        use2a = bool(var & 1)
    struct.pack_into('<I', d, 0x2a, rng.choice([1, 0x100, 0x01000000, 0x80000000, 0xffffffff]) if use2a else 0)
    w36 = rng.choice([-1, 0, 1, 2, 3, 4, 7, 5])
    struct.pack_into('<h', d, 0x36, w36)
    x = rng.choice(COORDS)
    y = rng.choice(COORDS)
    obj = bytearray(rng.randbytes(PAD + 0x1000))
    ro = PAD
    cnt = rng.choice([1, 2, 3, 5, 8, 4])
    if prof == 18:
        cnt = rng.choice([0, -1, -0x8000, 0, -5, 0x8000 - 0x10000 + 3])
    struct.pack_into('<h', obj, ro + 0x21, cnt)
    ncount = max(cnt, 0)
    # ---- the loop entries
    loop = {13: 'allfail', 17: 'allfail', 14: 'hit', 15: 'hit', 16: 'hit', 19: 'hit'}.get(prof, 'rand')
    force = {15: 'nz', 16: 'z', 14: 'z'}.get(prof)
    k = rng.randrange(max(ncount, 1)) if ncount > 0 else 0
    for i in range(8):
        e = ro + 0x45 + i * 0x96
        if loop == 'allfail':
            mode = rng.choice(MODES)
            q94 = rng.choice(['z', 'nz'])
        elif loop == 'hit':
            mode = None if i == k else (rng.choice(MODES) if prof != 19 or i > k else None)
            q94 = (force or 'z') if i == k else rng.choice(['z', 'nz']) if prof != 19 else ('nz' if i < k else rng.choice(['z', 'nz']))
            if prof == 19 and i == k:
                q94 = 'z'
        else:
            mode = None if rng.random() < 0.4 else rng.choice(MODES)
            q94 = rng.choice(['z', 'z', 'nz'])
        put_rect(obj, e, (0x84, 0x8c, 0x80, 0x88), x, y, rng, mode)
        v = 0 if q94 == 'z' else rng.choice([1, 0x8000, 0x7fff, 0xffff, 0x100, rng.randrange(1, 0x10000)])
        struct.pack_into('<H', obj, e + 0x94, v)
        if rng.random() < 0.5:
            struct.pack_into('<H', obj, e + 0x96, 0)      # (the word after it zero: a read at +0x95 sees only the high byte)
    # ---- the three fixed rectangles (the 0x2a == 0 path)
    r_modes = [MODES[(var + j) % 4] for j in range(3)]
    inside = {10: [True, None, None], 11: [False, True, None], 12: [False, False, True]}.get(prof)
    for j, (base, offs) in enumerate(((0x25, (0x29, 0x31, 0x25, 0x2d)), (0x35, (0x39, 0x41, 0x35, 0x3d)), (0xcf1, (0xcf5, 0xcfd, 0xcf1, 0xcf9)))):
        if inside is None:
            ok = False
        elif inside[j] is None:
            ok = rng.random() < 0.5
        else:
            ok = inside[j]
        if prof == 0:
            ok = rng.random() < 0.5
        put_rect(obj, ro, offs, x, y, rng, None if ok else r_modes[j])
    # ---- the selected entry (the 0x2a != 0 path), written last: for the word -1 it overlaps bytes of the fixed rectangle 2
    q = w36 * 0x96 + 0x45
    a_ok_how = ('nz', 'eq')[var % 2]
    a_ok = prof not in (1, 15, 16, 17)         # the first test (w7e0 != 0 or the words equal) passes
    b_ok = prof != 2
    rect_mode = {3: 'ylo', 4: 'yhi', 5: 'xlo', 6: 'xhi'}.get(prof)
    w7e0_nz = True
    if prof in (7, 9):
        w7e0_nz = prof == 9
    elif prof == 8:
        w7e0_nz = True
    elif a_ok:
        w7e0_nz = a_ok_how == 'nz'
    else:
        w7e0_nz = False
    struct.pack_into('<H', obj, ro + 0x7e0, rng.choice([1, 0x8000, 0xffff, 0x100, 0x7fff]) if w7e0_nz else 0)
    obj[ro + 0x7e2:ro + 0x7e4] = bytes(rng.randrange(1, 256) for _ in range(2))
    w8a = rng.randrange(0x10000)
    struct.pack_into('<H', d, 0x8a, w8a)
    if prof == 8:
        equal_a = False
    elif prof in (7, 9):
        equal_a = True
    elif a_ok:
        equal_a = (not w7e0_nz) or (var // 2) % 2 == 0
    else:
        equal_a = False
    struct.pack_into('<H', obj, ro + q + 0x90, w8a if equal_a else different_word(rng, w8a))
    w8c = rng.choice([0, 1, 0xffff, 0x8000, rng.randrange(0x10000)])
    struct.pack_into('<H', d, 0x8c, w8c)
    struct.pack_into('<H', obj, ro + q + 0x92, w8c if b_ok else different_word(rng, w8c))
    put_rect(obj, ro + q, (0x44, 0x4c, 0x40, 0x48), x, y, rng, rect_mode)
    # ---- the record table, the stubs, the arguments
    rec = bytearray(rng.randbytes(6 * 0x8d))
    for i in range(-1, 5):
        struct.pack_into('<I', rec, (i + 1) * 0x8d, od.region_va(1) + PAD if i == idx else od.region_va(4))
    block = bytearray(rng.randbytes(16))
    areas = [Area('self', od.region_va(0), d, image=False), Area('records', RECORDS_VA - 0x8d, rec), Area('obj', od.region_va(1), obj, image=False),
             Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False),
             Area('block', od.region_va(5), block, image=False, compare=False)]
    probes = [('self', 0, 0x180)]
    stubs = {c: stub(c, probe=probes, **STUB_SHAPE[c]) for c in (0x45504b, 0x4554bb)}
    junk = lambda v: (v & 0xffff) | (rng.randrange(0x10000) << 16)
    return mk_scenario(sp, '455180', rng, areas=areas, stubs=stubs, pointers={'records_5bb5e5': ('records', 0x8d)},
                       stack_args=[junk(x), junk(y), od.region_va(5)], ptr_args={2: 'block'}, profile=('x', prof))


TBL_VALUES_NOT_C8 = [0, 1, 0xc9, 0x10c8, 0xffc8, 0x80c8, 7, 0xffff, 0x7fff]


def build_4cb058(sp, rng, n):
    prof = n % 24
    var = n // 24
    P12, P16, PR = od.region_va(1), od.region_va(2), od.region_va(3)
    ENT = 0x100
    d = bytearray(rng.randbytes(sp['selfsz']))
    x = rng.choice(COORDS)
    y = rng.choice(COORDS)
    struct.pack_into('<I', d, 0xe, 0 if prof == 0 else rng.choice([1, 0x100, 0x01000000, 0x80000000, rng.randrange(1, 1 << 32)]))
    struct.pack_into('<I', d, 0x12, 0 if prof == 1 else P12)
    struct.pack_into('<I', d, 0x16, 0 if prof == 2 else P16)
    struct.pack_into('<I', d, 0x15c, 0 if prof == 3 else PR)
    # ---- the loop entries
    hit_profs = (14, 15, 16, 17, 18, 21, 22, 23)
    cnt = rng.choice([1, 2, 3, 5, 8, 4])
    if prof in (7, 19):
        cnt = rng.choice([0, 0, 1, 3, 8])
    if prof == 20:
        cnt = rng.choice([0, -1, -0x8000, -5, 0x7fff - 0x10000 + 1])
    k_hit = rng.randrange(max(cnt, 1))
    p12 = bytearray(rng.randbytes(0x400))
    struct.pack_into('<h', p12, 2, cnt)
    struct.pack_into('<I', p12, 9, P12 + ENT)
    kind = {14: 'skip', 15: 'c8', 16: 'c8m1', 17: 'not'}.get(prof)
    if kind is None and prof in (21, 22, 23):
        kind = ['skip', 'c8', 'c8m1', 'not'][(var + prof) % 4]
    s152 = rng.choice([0, 5, 0x7fff, -0x8000, 0x25, 100, -2])
    if kind == 'c8m1':
        s152 = -1
    elif kind == 'c8' and s152 == -1:
        s152 = 5
    ks = [1, 2, 3, 5, -3, 40, 0]
    for i in range(8):
        e = ENT + i * 0x18
        if prof in hit_profs and i == k_hit:
            mode = None
        elif prof == 18:
            mode = MODES[(i + var) % 4]
        else:
            mode = rng.choice(MODES)
        put_rect(p12, e, (8, 0x10, 4, 0xc), x, y, rng, mode)
        kk = rng.choice([-1, -1, *ks])
        if prof in hit_profs and i == k_hit:
            kk = -1 if kind == 'skip' else rng.choice(ks[:-1] if prof != 21 else ks)
        struct.pack_into('<h', p12, e + 0x16, kk)
    # ---- the second part: the byte, the rectangle R and the word k
    after = prof in (7, 8, 9, 10, 11, 12, 13) or prof in (0, 19, 20) or prof >= 24 or prof in (1, 2, 3, 4, 5, 6)
    byte4 = 0 if prof == 7 else rng.choice([1, 0x80, 0xff]) if prof in (8, 9, 10, 11, 12, 13) else rng.choice([0, 1, 0x80, 0xff, 0])
    p12[4] = byte4
    if byte4 == 0:
        p12[5] = rng.randrange(1, 256)
        p12[6] = rng.randrange(1, 256)
    rmode = {8: 'ylo', 9: 'yhi', 10: 'xlo', 11: 'xhi'}.get(prof)
    if prof in (12, 13):
        rmode = None
    elif rmode is None:
        rmode = rng.choice([None, None, *MODES])
    pr = bytearray(rng.randbytes(0x100))
    put_rect(pr, 0, (0x16, 0x1e, 0x12, 0x1a), x, y, rng, rmode)
    k7 = -1 if prof == 12 else rng.choice(ks) if prof == 13 else rng.choice([-1, *ks])
    struct.pack_into('<h', p12, 7, k7)
    # ---- the table of words in P16 and the block B (word [+0x152] against the global word)
    p16 = bytearray(rng.randbytes(0x400))
    for kk in range(-8, 48):
        if 0 <= 0x5f + kk * 2 < 0x3fe:
            struct.pack_into('<H', p16, 0x5f + kk * 2, rng.choice(TBL_VALUES_NOT_C8 + [0xc8, 0xc8]))
    if prof in (15, 16):
        for i in range(8):
            if i == k_hit:
                kk = struct.unpack_from('<h', p12, ENT + i * 0x18 + 0x16)[0]
                struct.pack_into('<H', p16, 0x5f + kk * 2, 0xc8)
    if prof == 17:
        kk = struct.unpack_from('<h', p12, ENT + k_hit * 0x18 + 0x16)[0]
        struct.pack_into('<H', p16, 0x5f + kk * 2, rng.choice(TBL_VALUES_NOT_C8))
    if prof == 13:
        pass
    b_how = ['equal', 'not_c8', 'c8_m1', 'c8_call'][var % 4]
    if prof == 2:
        b_how = 'equal'
    if prof == 4:
        b_how = 'not_c8'
    if prof == 5:
        b_how = 'c8_m1'
    if prof == 6:
        b_how = 'c8_call'
    if prof in (15, 16, 17, 14) and rng.random() < 0.5:
        b_how = 'equal'
    if b_how == 'c8_m1':
        s152 = -1
    elif b_how == 'c8_call' and s152 == -1:
        s152 = 7
    if b_how == 'equal':
        g583 = s152
    else:
        g583 = s152 ^ rng.choice([1, 0x100, 0x8000, 0x4000])
        if (g583 & 0xffff) == (s152 & 0xffff):
            g583 = s152 ^ 1
    if b_how in ('c8_m1', 'c8_call'):
        struct.pack_into('<H', p16, 0x5f, 0xc8)
    elif b_how == 'not_c8':
        struct.pack_into('<H', p16, 0x5f, rng.choice(TBL_VALUES_NOT_C8))
    if prof in (15, 16, 17) and b_how == 'equal':
        pass
    struct.pack_into('<h', d, 0x152, s152)
    # (the entry/table words of the hit entry for profile 15/16 may be the word 0x5f itself: the table was written first, B last: restore the
    # chosen value for the hit entry when it collides)
    if prof in (15, 16):
        kk = struct.unpack_from('<h', p12, ENT + k_hit * 0x18 + 0x16)[0]
        if kk == 0:
            struct.pack_into('<H', p16, 0x5f, 0xc8)
            if b_how != 'equal':
                g583 = s152
    areas = [Area('self', od.region_va(0), d, image=False), Area('p12', P12, p12, image=False), Area('p16', P16, p16, image=False),
             Area('rect', PR, pr, image=False)]
    g = {f: rng.choice([0, 0xffffffff, rng.randrange(1 << 32)]) for f in ('value_5b44f0', 'value_5b44f4', 'value_5d0377', 'value_5d162d',
                                                                           'value_5d1631', 'value_5d1639', 'value_5c39e5', 'value_571ad3')}
    g['value_583a29'] = g583 & 0xffff
    probes = [('self', 0, sp['selfsz'])]
    stubs = {0x4ea06c: stub(0x4ea06c, probe=probes, **STUB_SHAPE[0x4ea06c])}
    junk = lambda v: (v & 0xffff) | (rng.randrange(0x10000) << 16)
    return mk_scenario(sp, '4cb058', rng, areas=areas, g=g, stubs=stubs, stack_args=[junk(x), junk(y)], profile=('x', prof))


def build_4a3f40(sp, rng, n):
    prof = n % 20
    var = n // 20
    d = bytearray(rng.randbytes(sp['selfsz']))
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    struct.pack_into('<h', d, 0x1e, idx)
    struct.pack_into('<I', d, 0x26e, 0 if prof == 0 else rng.choice([1, 0x100, 0x01000000, 0x80000000, rng.randrange(1, 1 << 32)]))
    mode_a = prof in (1, 2, 3, 4) or (prof == 0 and var % 2 == 0) or (prof >= 16 and var % 2 == 0)
    struct.pack_into('<I', d, 0x260, rng.choice([1, 0x100, 0x01000000, 0x80000000, 0xffffffff]) if mode_a else 0)
    x = rng.choice(COORDS)
    y = rng.choice(COORDS)
    cnt_a = rng.choice([1, 2, 3, 4])
    cnt_b = rng.choice([1, 2, 3, 4, 5, 6])
    edge = rng.choice([0, -1, -128, 0, -5])
    if prof == 3 or (prof in (14, 15) and var % 3 == 0):
        cnt_a = edge
    if prof == 4 or (prof in (14, 15) and var % 3 == 1):
        cnt_b = edge
    # per profile: (inside probability of a cell in the regions 0x650, 0x290, 0x470, the word [ro+0x413] non-zero, the outer rectangle)
    P = {1: (0, 0, 0, 1, 'x'), 2: (.3, 0, 0, 1, 'x'), 3: (1, 0, 0, 1, 'x'), 4: (1, 0, 0, 1, 'x'),
         5: (0, 0, 0, 1, 'ylo'), 6: (0, 0, 0, 0, 'yhi'), 7: (0, 0, 0, 1, 'xlo'), 8: (0, 0, 0, 0, 'xhi'), 9: (0, 0, 0, 1, None),
         10: (0, .3, .3, 1, 'x'), 11: (0, 1, .3, 0, 'x'), 12: (0, 0, .3, 1, 'x'), 13: (0, .3, 0, 1, 'x'), 14: (0, 0, 0, 1, None),
         15: (0, 1, 0, 0, 'x')}.get(prof, (.3, .3, .3, rng.random() < .6, 'x'))
    p650, p290, p470, w413nz, outer = P
    obj = bytearray(rng.randbytes(0x1000))
    struct.pack_into('<b', obj, 0x22, cnt_a)
    struct.pack_into('<b', obj, 0x21, cnt_b)
    if w413nz:
        struct.pack_into('<H', obj, 0x413, rng.choice([1, 0x8000, 0x100, 0xffff, 0x7fff]))
    else:
        struct.pack_into('<H', obj, 0x413, 0)
        obj[0x415] = rng.randrange(1, 256)
        obj[0x416] = rng.randrange(1, 256)
    for base, p in ((0x650, p650), (0x290, p290), (0x470, p470)):
        for a in range(4):
            for b in range(6):
                mode = None if rng.random() < p else rng.choice(MODES)
                put_rect(d, base + a * 0x60 + b * 16, (4, 0xc, 0, 8), x, y, rng, mode)
    if outer == 'x':
        outer = rng.choice([None, None, *MODES])
    put_rect(obj, 0, (0x6b3, 0x6bb, 0x6af, 0x6b7), x, y, rng, outer)
    rec = bytearray(rng.randbytes(6 * 0x8d))
    for i in range(-1, 5):
        struct.pack_into('<I', rec, (i + 1) * 0x8d, od.region_va(1) if i == idx else od.region_va(4))
    block = bytearray(rng.randbytes(16))
    areas = [Area('self', od.region_va(0), d, image=False), Area('records', RECORDS_VA - 0x8d, rec), Area('obj', od.region_va(1), obj, image=False),
             Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False),
             Area('block', od.region_va(5), block, image=False, compare=False)]
    stubs = {c: stub(c, probe=[('self', 0, 0x900)], **STUB_SHAPE[c]) for c in (0x4a3beb, 0x4a42c0)}
    junk = lambda v: (v & 0xffff) | (rng.randrange(0x10000) << 16)
    return mk_scenario(sp, '4a3f40', rng, areas=areas, stubs=stubs, pointers={'records_5bb5e5': ('records', 0x8d)},
                       stack_args=[junk(x), junk(y), od.region_va(5)], ptr_args={2: 'block'}, profile=('x', prof))


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
    runner = Original20(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, SPECS[sc.key].get('code', sc.size), ecx=sc.ecx, stack_args=sc.stack_args, read=read)
    orig.edges = runner.edges
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
