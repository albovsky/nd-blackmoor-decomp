"""FL-25 (batch c): the fixtures shared by tests/test_fl25c_differential.py and tests/fl25c_original_oracle.py.

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
    """The fields of Fl25cWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl25c.h').read_text()
    body = re.search(r'typedef struct Fl25cWorld \{(.*?)\} Fl25cWorld;', text, re.S).group(1)
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
    (0x46c840, 'taken'): 'jne on selector != 0x27e8 after 0x46c836 found it != 0x27e6; this block is reached only with the selector 0x27e6 or 0x27e8 (the je/jne at 0x46c76f/0x46c77b) and the global is not changed in between (no call, no store to it)',
    (0x46c99f, 'taken'): 'jne on selector != 0x27e3 after 0x46c995 found it != 0x27e2; this block is reached only with the selector 0x27e2 or 0x27e3 (0x46c8c3..0x46c8d9), unchanged in between',
    (0x46cb02, 'taken'): 'jne on selector != 0x27e5 after 0x46caf8 found it != 0x27e4; this block is reached only with the selector 0x27e4 or 0x27e5 (0x46ca26..0x46ca3c), unchanged in between',
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
    '4a8818': dict(id=1, va=0x4a8818, size=986, selfsz=0xf00, idx=0x1e, gates=[('nz32', 0xe72), ('z8', 0xe83), ('z32', 0xe7f)],
                   sels=[0x279a, 0x2798, 0x2799], callees=[0x4f6334, 0x4fb2e3, 0x4a8bf2], post=lambda c: post_4a8818(c), scen=1000,
                   probes=[(0xa40, 0x1ea), (0xe00, 0x90)]),
    '4aa3d2': dict(id=2, va=0x4aa3d2, size=1100, selfsz=0x80, idx=0x21, gates=[('nz8', 0x45)], sels=[0x276f, 0x2770, 0x2771],
                   callees=[0x4fb2e3, 0x4fb77a, 0x423259, 0x448d11], post=lambda c: post_4aa3d2(c), scen=1800, probes=[(0, 0x80)]),
    '46c6a9': dict(id=3, va=0x46c6a9, size=1506, selfsz=0x4a80, idx=0x1e, gates=[('nz32', 0x4a48), ('z8', 0x4a59), ('z32', 0x4a55)],
                   sels=[0x27ea, 0x27e6, 0x27e8, 0x27e2, 0x27e3, 0x27e4, 0x27e5], callees=[0x4f6334, 0x4fb2e3, 0x46cc8b], post=lambda c: post_46c6a9(c),
                   scen=1800, probes=[(0x48a0, 0x180), (0x4a20, 0x40)]),
    # (the span ends with a 16-byte jump table at 0x4a4c05: the coverage target is the 1861 code bytes)
    '4a44c0': dict(id=4, va=0x4a44c0, size=1877, code=1861, selfsz=0x290, idx=0x1e, gates=[('nz32', 0x26e), ('z8', 0x27f), ('z32', 0x27b)],
                   sels=[0x274f, 0x274e, 0x274c, 0x274d], callees=[0x4f6334, 0x4fb2e3, 0x4a4d55], post=lambda c: post_4a44c0(c), scen=1800,
                   probes=[(0x200, 0x90)]),
    # SPECS-END
}
KEYS = list(SPECS)
RECORDS_VA = 0x5bb5e5
STUB_SHAPE = {
    0x4f6334: dict(args=1, this=True, cleanup=4), 0x4fb2e3: dict(args=1, this=True, cleanup=4), 0x4a8bf2: dict(args=0, this=True, cleanup=0),
    0x423259: dict(args=1, this=True, cleanup=4), 0x4fb77a: dict(args=1, this=True, cleanup=4), 0x448d11: dict(args=4, this=True, cleanup=16),
    0x46cc8b: dict(args=0, this=True, cleanup=0),
    0x4a4d55: dict(args=0, this=True, cleanup=0),
    # STUBS-END
}
WORD_ARGS = {0x4fb2e3: (0,)}   # (pushed from 16-bit registers: only the low 16 bits are meaningful)


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
    elif kind == 'in32':
        struct.pack_into('<I', d, off, rng.choice([1, 2, 3, 4, 6, 0x100, 0x10005, 0xffffffff, 0x80000000]) if fail else rng.choice(gate[2]))
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
                        areas=[], g={}, pointers={}, consts={}, stack_args=[], stubs_results={}, iat={}, stub_kw={})
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
        kw.update(c.stub_kw.get(callee, {}))
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


def post_4a8818(c):
    d, obj, rng, v, sel = c.d, c.obj, c.rng, c.variant, c.sel
    flip = v % 2 == 1                      # the dword [+0xe5e] disagrees with the arm that the selector names
    natural_nz = {0x2799: True}.get(sel)
    if c.passing and sel in (0x279a, 0x2798, 0x2799):
        e5e_nz = (natural_nz is True) != flip
    else:
        e5e_nz = bool(rng.getrandbits(1)) if c.passing else bool((v // 3) % 2)
    struct.pack_into('<I', d, 0xe5e, rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]) if e5e_nz else 0)
    arm_a = c.passing and sel == 0x279a and not e5e_nz
    arm_b = c.passing and sel == 0x2798 and not e5e_nz
    arm_c = c.passing and sel == 0x2799 and e5e_nz
    g_nz = (v // 2) % 2 == 1
    nine = ((v // 4) % 11) - 1
    c.g['value_5bb1ca'] = rng.choice([1, 0x100, 0x80000000, 0xffffffff, rng.randrange(1, 1 << 32)]) if g_nz else 0
    a = rng.choice([0, 1, 2, 3, 5, -1])
    b = rng.choice([0, 1, 2, 4, 8, -1])
    struct.pack_into('<h', d, 0xe7a, a)
    struct.pack_into('<h', d, 0xe7c, b)
    for i in range(8):
        for j in range(9):
            at = 0xa40 + i * 0x36 + j * 6
            struct.pack_into('<H', d, at, 0xfff6 if rng.random() < 0.4 else rng.choice([0, 1, 0xfff7, 0xfff5, 0x00f6, 0x80f6, 0x8000, 0xffff]))
    q = 0xa40 + a * 0x36 + b * 6
    struct.pack_into('<H', d, q, 0xfff6 if (v // 8) % 2 == 0 else rng.choice([0, 0xfff7, 0x00f6, 0x8000, 0xffff, 0xf6f6]))
    struct.pack_into('<h', obj, 0x43, rng.choice([-3, -1, 0, 1, 2, 3, 5, 8]))
    struct.pack_into('<h', obj, 0x45, rng.choice([-2, 0, 1, 2, 3, 5, 9]))
    c.stubs_results[0x4f6334] = [0 if (v // 44) % 2 == 0 else rng.choice([1, 0x100, 0xffffffff])]
    nine_const(c, 0x550bac, 0x375, obj, arm_b and g_nz, nine=nine)
    nine_const(c, 0x550bb8, 0x3a6, obj, arm_c and g_nz, nine=nine)
    c.areas.append(Area('b5a110f', 0x5a110f, bytearray(rng.randbytes(0x1e6 + 0x20))))
    c.pointers['buf_5a110f'] = ('b5a110f', 0)


SLENS = [1, 2, 3, 4, 5, 7, 8, 11, 12, 15, 16, 24, 27, 28]


def post_4aa3d2(c):
    d, obj, rng, v, sel = c.d, c.obj, c.rng, c.variant, c.sel
    if c.passing and sel == 0x276f:
        d[0x47] = 0 if v % 5 != 4 else rng.choice([1, 0x80, 0xff])
    else:
        d[0x47] = rng.choice([0, 0, 1, 0xff])
    arm1 = c.passing and sel == 0x276f and d[0x47] == 0
    arm2 = c.passing and sel == 0x2770
    k = rng.choice([0, 1, 2, 3, 5, 9]) if arm2 else rng.choice([-1, 0, 1, 2, 3, 5, 9])
    struct.pack_into('<h', d, 0x23, k)
    nine = (v % 11) - 1
    sub = (v // 3) % 4                       # arm 1: 0 words equal and flag byte zero (the counting arm), 1 words differ, 2 flag byte set, 3 both
    word = struct.unpack_from('<H', obj, k * 0x15c + 0x233)[0]
    if arm1:
        struct.pack_into('<H', d, 0x40, word if sub in (0, 2) else different_word(rng, word))
        d[k + 0x2c] = 0 if sub in (0, 1) else rng.choice([1, 0x80, 0xff])
        if (v // 12) % 2:
            obj[0x83] = rng.choice([1, 0x80, 0xff])
        else:
            obj[0x83] = 0
            obj[0x84:0x87] = bytes(rng.randrange(1, 256) for _ in range(3))
        struct.pack_into('<h', obj, 0xf7, rng.choice([-2, 0, 1, 3, 7, 20, 40, -0x8000]))
    nine_const(c, 0x550e2c, 0x52, obj, arm1 and sub == 0, nine=nine)
    nine_const(c, 0x550e38, 0x21, obj, arm1 and sub != 0, nine=nine)
    e = k * 0x15c
    nine_const(c, 0x550e44, e + 0x119, obj, arm2, nine=nine)
    g_nz = rng.random() < 0.8
    c.g['value_5bb202'] = rng.choice([1, 0x100, 0x80000000, 0xffffffff]) if g_nz else 0
    c.g['value_5d03b3'] = rng.randrange(1 << 32)
    c.g['value_550e50'] = rng.randrange(1 << 32)
    c.areas.append(Area('b630a60', 0x630a60, bytearray(rng.randbytes(0x60))))
    c.pointers['buf_630a60'] = ('b630a60', 0)
    if arm2:
        len1 = 0 if rng.random() < 0.2 else rng.choice(SLENS)
        len2 = 0 if rng.random() < 0.3 else rng.choice(SLENS)
        obj[e + 0x14a:e + 0x14a + len1 + 1] = bytes(rng.randrange(1, 256) for _ in range(len1)) + b'\0'
        obj[e + 0x16b:e + 0x16b + len2 + 1] = bytes(rng.randrange(1, 256) for _ in range(len2)) + b'\0'
        smode = (v // 11) % 5                # the result of 0x423259: 0, a short string, an empty string, a string longer than 0x9c40, a short one
        slen = SLENS[(v // 55) % len(SLENS)]
        off = rng.choice([0, 1, 2, 3, 5, 0x100])
        sbuf = bytearray(rng.randbytes(0xa000))
        if smode in (1, 4):
            sbuf[off:off + slen + 1] = bytes(rng.randrange(1, 256) for _ in range(slen)) + b'\0'
        elif smode == 2:
            sbuf[off] = 0
        elif smode == 3:
            sbuf[off:off + 0x9c42] = b'Q' * 0x9c41 + b'\0'
        c.areas.append(Area('sbuf', od.region_va(6), sbuf, image=False, compare=False))
        c.stubs_results[0x423259] = [od.region_va(6) + off if smode else 0]
        local = g_nz and 0 <= nine <= 8 and len1 != 0 and smode in (1, 2, 4)
        n = (slen if smode in (1, 4) else 0) if local else len2
        c.stub_kw[0x448d11] = dict(deref=(1, n + 4))
    else:
        c.stub_kw[0x448d11] = dict(deref=(1, 4))


def post_46c6a9(c):
    d, obj, rng, v, sel = c.d, c.obj, c.rng, c.variant, c.sel
    flip = v % 2 == 1                      # the dword [+0x4a2c] disagrees with the group of the event
    group_nz = sel in (0x27e2, 0x27e3, 0x27e4, 0x27e5)
    known = sel in (0x27ea, 0x27e6, 0x27e8, 0x27e2, 0x27e3, 0x27e4, 0x27e5)
    nz = (group_nz != flip) if (c.passing and known) else bool(rng.getrandbits(1))
    struct.pack_into('<I', d, 0x4a2c, rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]) if nz else 0)
    ks = [-2, -1, 0, 1, 2, 5, 12, 18]
    struct.pack_into('<h', d, 0x49e0, rng.choice(ks))
    struct.pack_into('<h', d, 0x49e2, rng.choice(ks) if v % 3 else struct.unpack_from('<h', d, 0x49e0)[0])
    g_nz = (v // 2) % 2 == 1
    nine = ((v // 4) % 11) - 1
    c.g['value_5bb1ca'] = rng.choice([1, 0x100, 0x80000000, 0xffffffff, rng.randrange(1, 1 << 32)]) if g_nz else 0
    nine_const(c, 0x54bd00, 0x63d, obj, c.passing and sel in (0x27e2, 0x27e3, 0x27e4, 0x27e5) and g_nz, nine=nine)
    nine_const(c, 0x54bd0c, 0x60c, obj, c.passing and sel in (0x27e6, 0x27e8) and g_nz, nine=nine)
    c.stubs_results[0x4f6334] = [0 if (v // 44) % 2 == 0 else rng.choice([1, 0x100, 0xffffffff])]
    c.areas.append(Area('b5a14df', 0x5a14df, bytearray(rng.randbytes(0x140 + 0x20))))
    c.pointers['buf_5a14df'] = ('b5a14df', 0)


def post_4a44c0(c):
    d, obj, rng, v, sel = c.d, c.obj, c.rng, c.variant, c.sel
    flip = v % 2 == 1                      # the dword [+0x260] disagrees with the group of the event
    known = sel in (0x274f, 0x274e, 0x274c, 0x274d)
    nz = ((sel == 0x274d) != flip) if (c.passing and known) else bool(rng.getrandbits(1))
    struct.pack_into('<I', d, 0x260, rng.choice([1, 0x100, 0x01000000, 0xffffffff, rng.randrange(1, 1 << 32)]) if nz else 0)
    row, sub, i = rng.choice([0, 1, 2, 3]), rng.choice([0, 1, 2, 3, 4]), rng.choice([0, 1, 2, 3, 4, 5])
    struct.pack_into('<h', d, 0x264, row)
    struct.pack_into('<h', d, 0x278, sub)
    struct.pack_into('<h', d, 0x276, i)
    p_off = row * 0x7c + sub * 0xc + i * 2
    buf = bytearray(rng.randbytes(0x200))
    bvals = [0, 7, -1, -10, -0x8000, 0x7fff]
    avals = [0, 1, 2, 3, 4, -1, 0x7fff, -0x8000]
    struct.pack_into('<h', buf, p_off, bvals[(v // 16) % 6])
    struct.pack_into('<h', buf, 0x3c + p_off, avals[(v // 2) % 8])
    c.areas.append(Area('b591a28', 0x591a28, buf))
    c.pointers['buf_591a28'] = ('b591a28', 0)
    dvals = [1, 2, 3, 5, 7, -1, -3, 127, -128]
    obj[0x21] = dvals[(v // 3) % 9] & 0xff
    struct.pack_into('<H', obj, 0x413, 1 if (v // 5) % 2 else rng.choice([0, 2, 0x8001, 0xffff, 0x101]))
    struct.pack_into('<h', d, 0x214, rng.choice([0, 1, -1, 100, -0x8000, 0x7fff, 0x1234, -7]))
    g_nz = rng.random() < 0.75
    nine = ((v // 3) % 11) - 1
    c.g['value_5bb1ca'] = rng.choice([1, 0x100, 0x80000000, 0xffffffff]) if g_nz else 0
    nine_const(c, 0x550570, 0x61b, obj, c.passing and sel == 0x274e and not nz and g_nz, nine=nine)
    nine_const(c, 0x55057c, 0x5b9, obj, c.passing and sel == 0x274c and not nz and g_nz, nine=nine)
    nine_const(c, 0x550588, 0x5ea, obj, c.passing and sel == 0x274d and nz and g_nz, nine=nine)
    c.stubs_results[0x4f6334] = [0 if (v // 33) % 2 == 0 else rng.choice([1, 0x100, 0xffffffff])]


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
            if isinstance(v, bytes):
                entry.append(v)
            elif position in wa:
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
