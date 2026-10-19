"""FL-23 (batch a): the fixtures of the hit-test handlers of src/original_methods_fl23a.c, and the runner that executes the ORIGINAL bytes.

Used by two consumers that must see exactly the same scenarios:
  * tests/test_fl23a_differential.py runs each scenario on the original bytes (run_original) and on the native port and compares;
  * tests/fl23a_original_oracle.py runs only the original bytes and asserts that every instruction of each function ran.

A scenario is a dict: fn (the shim function id), va, size (bytes of the function body), areas (Area list: the `self` object, the object that
a record or a pointer in `self` leads to, the record table), stubs (recording replacements of the callees, the only hooks), g (initial values of
world scalars = original globals), ecx, stack (the two stack words), word_args, args (the native x, y), self_name and pointers.

Nothing here holds original bytes: the fixtures are random synthetic objects built around the point that the handler is given.
"""
import ctypes
import hashlib
import itertools
from dataclasses import dataclass
from pathlib import Path
import random
import re
import struct
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od

PROJECT = Path(__file__).resolve().parents[1]
SCENARIOS = 300
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'uint32_t': ctypes.c_uint32}
FMT = {1: '<B', 2: '<H', 4: '<I'}


def parse_world():
    """The fields of Fl23aWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl23a.h').read_text()
    body = re.search(r'typedef struct Fl23aWorld \{(.*?)\} Fl23aWorld;', text, re.S).group(1)
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
GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t, p in WORLD_FIELDS if not p}
SCALARS = [n for n, t, p in WORLD_FIELDS if not p]


@dataclass
class Area:
    name: str
    va: int
    data: bytearray
    image: bool = True      # inside the image (a global or table) or a region outside it
    compare: bool = True
    wide: dict = None       # on the record table of a scenario with a negative index word: see records_and_obj


class Original20(od.Original):
    """od.Original whose stubs can also log the bytes behind pointer arguments and the state at the call (probe)."""

    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self._nth = {}

    def _stub_hook(self, uc, address, size, user):
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = ()
        if probe:    # the memory at the probed addresses as it is at the call (read before the stub stores anything), appended last
            data += (b''.join(bytes(uc.mem_read(a, n)) for a, n in probe),)
        super()._stub_hook(uc, address, size, user)
        if data:
            self.calls[before] = self.calls[before] + data


def stub(callee, **kw):
    """A recording stub; probe=[(area name or 'g:<world field>', offset, nbytes), ...] (at most eight, 4096 bytes in all) log the bytes at those
    places as they are at the call (call-time state)."""
    probe = kw.pop('probe', None)
    s = od.Stub(callee, **kw)
    s.probe = probe
    return s


def run_original(spec):
    """The original function on one scenario. Returns (od.Result, normalized ordered call log)."""
    areas, stubs, g = spec['areas'], spec['stubs'], spec['g']
    image_patches = [(a.va, a.data) for a in areas if a.image]
    for field, value in g.items():
        address, size_ = GLOBALS[field]
        image_patches.append((address, struct.pack(FMT[size_], value & ((1 << (8 * size_)) - 1))))
    regions = {a.name: (a.va, a.data) for a in areas if not a.image}
    read = {a.name: (a.va, len(a.data)) for a in areas if a.compare}
    for field in g:
        read['g:' + field] = GLOBALS[field]
    for x in stubs.values():
        if getattr(x, 'probe', None):
            x.probe_addr = [((GLOBALS[n[2:]][0] if n.startswith('g:') else next(a.va for a in areas if a.name == n)) + off, ln)
                            for n, off, ln in x.probe]
    orig = Original20(image_patches, regions, stubs, {}).run(spec['va'], spec['size'], ecx=spec['ecx'], stack_args=spec['stack'], read=read)
    return orig, normalize(orig.calls, stubs, spec.get('word_args'))


# stack arguments of a callee that are plain data (the dwords of the 16-byte structure that 0x46ebbd takes by value, after x and y)
VALUE_ARGS = {0x46ebbd: (2, 3, 4, 5)}


def normalize(calls, stubs, word_args):
    by_name = {s.name: s for s in stubs.values()}
    out = []
    for call in calls:
        s = by_name[call[0]]
        entry = [call[0], call[1] if s.this else 0]
        rest = list(call[2 if s.this else 1:])
        probe = rest.pop() if getattr(s, 'probe_addr', None) else None
        wa = (word_args or {}).get(call[0], ())
        by_value = VALUE_ARGS.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            elif position in by_value:   # data, never a pointer: a value that happens to lie in the stack range is not a local
                entry.append(v)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out


def digest(orig, calls):
    """sha256 over the ordered call observations (callee, ecx, arguments, call-time probes) and the memory and return observations."""
    h = hashlib.sha256()
    h.update(repr([[repr(v) for v in c] for c in calls]).encode())
    h.update(repr((orig.eax, orig.cleanup)).encode())
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return h.hexdigest()


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def coord(rng):
    return rng.choice([-32768, -32767, -1, 0, 1, 2, 9, 10, 11, 255, 0x7ffe, 0x7fff, rng.randrange(-32768, 32768), rng.randrange(-32768, 32768)])


def rand32(rng):
    return rng.choice([0, 1, -1, 0x7fffffff, -0x80000000, 0x7ffffff5, -0x7ffffff6, 0x10000, rng.randrange(-1 << 31, 1 << 31)])


def rect(rng, d, base, offs, x, y, mode, pad=0):
    """Four dwords of a rectangle at base + offs = (ylo, yhi, xlo, xhi). 'in': the point is inside (often exactly on an edge); 'out': one edge
    misses it, often by exactly one; 'rand': random dwords. `pad` is the amount the handler adds to a low and subtracts from a high edge."""
    names = ('ylo', 'yhi', 'xlo', 'xhi')
    m = lambda: rng.choice([0, 0, 0, 1, 2, 7, rng.randrange(0, 100000)])
    if mode == 'rand':
        vals = {k: rand32(rng) for k in names}
    elif mode == 'wrap':   # edges near the 32-bit limits: +pad / -pad wraps around and the rectangle then holds every point (pad > 0)
        vals = {'ylo': 0x7ffffff6 + rng.randrange(10), 'yhi': -0x80000000 + rng.randrange(10), 'xlo': 0x7ffffff6 + rng.randrange(10),
                'xhi': -0x80000000 + rng.randrange(10)}
    else:
        vals = {'ylo': y - pad - m(), 'yhi': y + pad + m(), 'xlo': x - pad - m(), 'xhi': x + pad + m()}
        if mode == 'out':
            k = rng.choice(names)
            e = rng.choice([1, 1, 1, 2, rng.randrange(1, 70000)])
            c = y if k[0] == 'y' else x
            vals[k] = c + e - pad if k.endswith('lo') else c - e + pad
    for k, off in zip(names, offs):
        put32(d, base + off, vals[k])


_PERIOD = [1]


def cycle(n, *dims):
    """The n-th element (cycling) of the cartesian product of the option lists: every combination of the profile is reached in turn.
    The number of combinations is kept for index_word (every generator calls cycle first)."""
    combos = list(itertools.product(*dims))
    _PERIOD[0] = len(combos)
    return combos[n % len(combos)]


NEG_SLACK = 6     # records of slack below the table in the image (indices -1 .. -6 read real records)
FAR_VA = 0x153000   # page below the record -32768 (0x5bb5e5 - 32768 * 0x8d = 0x1535e5), outside the image
HI_RECORDS = 65536  # the zero-extended word indices 0 .. 65535 reach this many records above the table


def index_word(rng, n):
    """The record index word of scenario n, as an unsigned 16-bit value. The profile changes once per cycle of the generator's profile
    combinations, so every combination meets every profile: (0) an index 0..5, (1) a negative word in the slack below the table (0xffff
    about half of the time, else 0xfffa .. 0xfffe), (2) 0x8000 (the record 32768 below the table). The originals sign-extend the word
    (movsx), so a negative word reads the records BELOW the table; a port that zero-extends reads the records above it."""
    profile = (n // _PERIOD[0]) % 3
    if profile == 0:
        return rng.randrange(6)
    if profile == 1:
        return 0xffff if rng.random() < 0.5 else rng.randrange(0xfffa, 0xffff)
    return 0x8000


def nonzero32(rng):
    return rng.choice([1, 2, 0x100, 0x80000000, 0xffffffff, rng.randrange(1, 1 << 32)])


def make_scenario(rng, fn, va, size, self_data, x, y, areas, stubs, g=None, word_args=None, pointers=None):
    self_area = Area('self', od.region_va(0), self_data, image=False)
    return dict(fn=fn, va=va, size=size, areas=[self_area, *areas], stubs=stubs, g=g or {}, ecx=od.region_va(0), word_args=word_args or {},
                stack=[(rng.randrange(0x10000) << 16) | (x & 0xffff), (rng.randrange(0x10000) << 16) | (y & 0xffff)], args=(x, y), self_name='self',
                pointers=pointers or {})


def records_and_obj(rng, word, obj_size):
    """The record table (6 records of stride 0x8d, with NEG_SLACK records of slack below it in the image) whose record `word` (a signed 16-bit
    index: the original does movsx; imul 0x8d) leads to the object 'obj' (outside the image). Returns ([areas], obj, pointers). A negative
    word below the slack (0x8000) also gets the area 'far' (outside the image, below the image base) that holds that record, and every
    negative word marks the table `wide`: the native side then builds one contiguous host buffer from the lowest area to HI_RECORDS records
    above the table (the original never reads there), whose record at the ZERO-extended word leads to the 'decoy' object, so that a port
    that zero-extends the word does not fault but reads a different object and is detected by the comparison."""
    table_va = 0x5bb5e5
    k = word - 0x10000 if word >= 0x8000 else word
    records = Area('records', table_va - NEG_SLACK * 0x8d, bytearray(rng.randbytes((NEG_SLACK + 6) * 0x8d)))
    areas = [records]
    if k >= -NEG_SLACK:
        put32(records.data, (NEG_SLACK + k) * 0x8d, od.region_va(1))
    if k < 0:
        far_off = table_va + k * 0x8d - FAR_VA
        spans = [records]
        if k < -NEG_SLACK:
            far = Area('far', FAR_VA, bytearray(rng.randbytes(0x1000)))
            far.image = False
            put32(far.data, far_off, od.region_va(1))
            areas.insert(0, far)
            spans.insert(0, far)
        decoy = Area('decoy', od.region_va(3), bytearray(rng.randbytes(0x2000)), image=False, compare=False)
        areas.append(decoy)
        records.wide = dict(spans=[a.name for a in spans], table_va=table_va, hi_word=word, decoy_va=decoy.va)
    obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(obj_size)), image=False)
    return areas, obj, {'records_5bb5e5': ('records', NEG_SLACK * 0x8d)}


def callee_stub(callee, nargs, cleanup, **kw):
    return stub(callee, args=nargs, this=True, cleanup=cleanup, **kw)


# ---- the scenario generators, one per function ----------------------------------------------------------------------------------


def gen_47d734(rng, n):
    gate, = cycle(n, [0, 1, 0xff, 0x80])
    x, y = coord(rng), coord(rng)
    d = bytearray(rng.randbytes(0x80))
    d[0x57] = gate
    put16(d, 0x1d, rng.randrange(6))   # the original reads the record table at this index (unused result); a wild index would fault in the original
    return make_scenario(rng, 1, 0x47d734, 73, d, x, y, [], {})


def gen_4a1e16(rng, n):
    g60, mode, f50 = cycle(n, [0, 1], ['in', 'out', 'rand'], [2, 1, 3, 0x100002, 0])
    x, y = coord(rng), coord(rng)
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x60, 0 if g60 == 0 else nonzero32(rng))
    put32(d, 0x20, od.region_va(1))
    put32(d, 0x50, f50)
    obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x200)), image=False)
    rect(rng, obj.data, 0, (0x141, 0x149, 0x13d, 0x145), x, y, mode)
    stubs = {0x4a1e93: callee_stub(0x4a1e93, 1, 4, probe=[('self', 0, 0x80)])}
    return make_scenario(rng, 2, 0x4a1e16, 125, d, x, y, [obj], stubs)


def gen_4ba377(rng, n):
    g34, s0, s1, r0, r1 = cycle(n, [0, 1], [0, 1], [0, 1], ['in', 'out', 'rand'], ['in', 'out', 'rand'])
    x, y = coord(rng), coord(rng)
    d = bytearray(rng.randbytes(0x340))
    put32(d, 0x34, 0 if g34 == 0 else nonzero32(rng))
    put32(d, 0x18, od.region_va(1))
    put32(d, 0x24, 0 if s0 == 0 else nonzero32(rng))
    put32(d, 0x2c, 0 if s1 == 0 else nonzero32(rng))
    obj = Area('obj', od.region_va(1), bytearray(rng.randbytes(0x900)), image=False)
    for i, mode in enumerate((r0, r1)):
        rect(rng, obj.data, 16 * i, (0x7f0, 0x7f8, 0x7ec, 0x7f4), x, y, mode)
    stubs = {0x4ba486: callee_stub(0x4ba486, 1, 4, probe=[('self', 0x2d4, 4), ('self', 0x310, 4)])}
    return make_scenario(rng, 3, 0x4ba377, 271, d, x, y, [obj], stubs, word_args={0x4ba486: (0,)})


def gen_459cc9(rng, n):
    gate, h, skip = cycle(n, [0, 1], [None, 0, 1, 2, 3], [0, 1])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0xe0))
    d[0xd6] = 0 if gate == 0 else rng.choice([1, 0xff, 0x80])
    put16(d, 0x1c, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x100)
    for i in range(4):
        later = 'in' if (skip == 1 and h is not None and i == h + 1) else 'rand'   # a disabled hit must not fall through to an enabled later item
        rect(rng, obj.data, 16 * i, (0x65, 0x6d, 0x61, 0x69), x, y, later if h is not None and i > h else ('in' if i == h else 'out'))
    if h is not None:
        d[0x1e + h] = 0 if skip == 0 else rng.choice([1, 0xff, 0x80])
        if h < 3 and skip == 1:
            d[0x1f + h] = 0
    stubs = {0x459ddc: callee_stub(0x459ddc, 1, 4, probe=[('self', 0xcc, 2)])}
    return make_scenario(rng, 4, 0x459cc9, 275, d, x, y, [*recs, obj], stubs, word_args={0x459ddc: (0,)}, pointers=pointers)


def gen_487c92(rng, n):
    gate, b65, pre, count, hm = cycle(n, [0, 1], [0, 1], ['in', 'out'], [-1, 0, 1, 3, 4], ['none', 'first', 'last'])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x71, 0 if gate == 0 else nonzero32(rng))
    d[0x65] = 0 if b65 == 0 else rng.choice([1, 0xff])
    put16(d, 0x1e, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x700)
    rect(rng, obj.data, 0, (0x5a7, 0x5af, 0x5a3, 0x5ab), x, y, pre)
    put16(obj.data, 0x21, count)
    hit = None if count <= 0 or hm == 'none' else (0 if hm == 'first' else count - 1)
    for i in range(4):
        rect(rng, obj.data, 16 * i, (0x329, 0x331, 0x325, 0x32d), x, y, 'rand' if hit is not None and i > hit else ('in' if i == hit else 'out'))
    stubs = {0x487dcf: callee_stub(0x487dcf, 2, 8, probe=[('self', 0x24, 1)])}
    return make_scenario(rng, 5, 0x487c92, 317, d, x, y, [*recs, obj], stubs, word_args={0x487dcf: (1,)}, pointers=pointers)


def gen_48a920(rng, n):
    gate, hm, skipbyte, f44, final = cycle(n, [0, 1], ['none', 'first', 'last'], [0, 1], [0, 1], ['in', 'out'])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x1c0))
    put32(d, 0x1aa, 0 if gate == 0 else nonzero32(rng))
    put16(d, 0x1e, word)
    put32(d, 0x44, 0 if f44 == 0 else nonzero32(rng))
    recs, obj, pointers = records_and_obj(rng, word, 0x1200)
    if hm == 'none':
        count, hit = rng.choice([0, 1, 3]), None
    elif hm == 'first':
        count, hit = rng.choice([1, 2, 4, 0x80, 0xff]), 0   # 0x80 and 0xff: the count is an unsigned byte
    else:
        count, hit = rng.choice([2, 3, 4]), None
        hit = count - 1
    obj.data[0x21] = count
    for i in range(min(count, 0x20)):
        if hit is not None and i < hit:   # earlier items: outside, or inside but disabled by a non-zero byte of self
            inside = rng.random() < 0.5
            rect(rng, obj.data, 16 * i, (0x168, 0x170, 0x164, 0x16c), x, y, 'in' if inside else 'out')
            d[0x24 + i] = rng.choice([1, 0xff]) if inside else rng.choice([0, 1])
        elif i == hit:
            rect(rng, obj.data, 16 * i, (0x168, 0x170, 0x164, 0x16c), x, y, 'in')
            d[0x24 + i] = 0 if skipbyte == 0 else rng.choice([1, 0x80])
        elif hit is None:
            rect(rng, obj.data, 16 * i, (0x168, 0x170, 0x164, 0x16c), x, y, rng.choice(['out', 'rand']))
    rect(rng, obj.data, 0, (0x40f, 0x417, 0x40b, 0x413), x, y, final)
    stubs = {0x48aa66: callee_stub(0x48aa66, 2, 8, probe=[('self', 0x1b0, 2)])}
    return make_scenario(rng, 6, 0x48a920, 326, d, x, y, [*recs, obj], stubs, word_args={0x48aa66: (1,)}, pointers=pointers)


def gen_48e628(rng, n):
    gate, pre, hm, eqskip = cycle(n, [0, 1], ['in', 'out'], ['none', 'first', 'last'], [0, 1])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x480))
    put32(d, 0x462, 0 if gate == 0 else nonzero32(rng))
    put16(d, 0x1e, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x500)
    rect(rng, obj.data, 0, (0x9e, 0xa6, 0x9a, 0xa2), x, y, pre)
    if hm == 'none':
        count, hit = rng.choice([-1, 0, 1, 3]), None
    elif hm == 'first':
        count, hit = rng.choice([1, 2, 4]), 0
    else:
        count = rng.choice([2, 3, 4])
        hit = count - 1
    put16(obj.data, 0xb0, count)
    skipidx = hit if hit is not None else (rng.randrange(count) if count > 0 else 0)
    for i in range(4):
        mode = 'out'
        if hit is not None:
            mode = 'out' if i < hit else ('in' if i == hit else 'rand')
        elif eqskip and i == skipidx and count > 0:
            mode = 'in'
        rect(rng, obj.data, 0xd0 * i, (0xb6, 0xbe, 0xb2, 0xba), x, y, mode)
    put16(d, 0x3fe, skipidx if eqskip else rng.choice([-1, 0x7fff, skipidx + 1, -32768]))
    stubs = {0x48e776: callee_stub(0x48e776, 2, 8)}
    return make_scenario(rng, 7, 0x48e628, 334, d, x, y, [*recs, obj], stubs, word_args={0x48e776: (1,)}, pointers=pointers)


def gen_479deb(rng, n):
    state, h, ret, final = cycle(n, ['pass', 'f157a', 'f24', 'f1528'], [None, 0, 1, 2, 3, 4], ['one', 'notone', 'notone_one'], ['in', 'out'])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x1600))
    put32(d, 0x157a, 0 if state == 'f157a' else nonzero32(rng))
    put32(d, 0x24, 2 if state == 'f24' else rng.choice([0, 1, 3, 0x100000002 & 0xffffffff, 0x80000002, rng.randrange(1 << 32)]))
    put32(d, 0x1528, nonzero32(rng) if state == 'f1528' else 0)
    put16(d, 0x1e, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x400)
    for i in range(5):
        hot = h is not None and (i == h or (ret == 'notone_one' and i == h + 1))
        rect(rng, obj.data, 16 * i, (0x174, 0x17c, 0x170, 0x178), x, y, (rng.choice(['in', 'in', 'wrap']) if hot else ('out' if h is None or i < h else 'rand')), pad=10)
    rect(rng, obj.data, 0, (0x28f, 0x297, 0x28b, 0x293), x, y, final)
    notone = rng.choice([0, 2, 0xffffffff, 0x80000001])
    results = {'one': [1], 'notone': [notone], 'notone_one': [notone, 1]}[ret]
    stubs = {0x478396: callee_stub(0x478396, 3, 0xc, results=results), 0x479f72: callee_stub(0x479f72, 2, 8)}
    return make_scenario(rng, 8, 0x479deb, 391, d, x, y, [*recs, obj], stubs, word_args={0x478396: (1, 2)}, pointers=pointers)


GLOBAL_WRITES = ['value_5c39e5', 'value_5d0377', 'value_5d162d', 'value_5b44f0', 'value_5b44f4', 'value_5d1631', 'value_5d1639']


def gen_46ea16(rng, n):
    state, first, hitidx = cycle(n, ['pass', 'f46', 'f5f'], ['hit', 'miss'], [None, 0, 7, 15])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x46, 0 if state == 'f46' else nonzero32(rng))
    put32(d, 0x5f, nonzero32(rng) if state == 'f5f' else 0)
    put16(d, 0x1e, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x1000)
    results = [nonzero32(rng) if first == 'hit' else 0]
    for i in range(16):
        results.append(0 if hitidx is None or i < hitidx else (nonzero32(rng) if i == hitidx else rng.choice([0, 1])))
    g = {k: rng.randrange(1 << 32) for k in GLOBAL_WRITES}
    stubs = {0x46ebbd: callee_stub(0x46ebbd, 6, 0x18, results=results, probe=[('self', 0x24, 4), ('self', 0x52, 1), ('g:value_5c39e5', 0, 4),
                                                                            ('g:value_5b44f0', 0, 4), ('g:value_5d1639', 0, 4)])}
    return make_scenario(rng, 9, 0x46ea16, 423, d, x, y, [*recs, obj], stubs, g=g, pointers=pointers)


def gen_4b7389(rng, n):
    gate, a, b, c, o25 = cycle(n, [0, 1], ['in', 'out'], ['in', 'out'], ['in', 'out'], [0, 1])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x60))
    d[0x35] = 0 if gate == 0 else rng.choice([1, 0xff, 0x80])
    put16(d, 0x21, word)
    recs, obj, pointers = records_and_obj(rng, word, 0x400)
    rect(rng, obj.data, 0, (0x3ba, 0x3c2, 0x3b6, 0x3be), x, y, a)
    rect(rng, obj.data, 0, (0x2f, 0x37, 0x2b, 0x33), x, y, b)
    rect(rng, obj.data, 0, (0x3f, 0x47, 0x3b, 0x43), x, y, c)
    obj.data[0x25] = 0 if o25 == 0 else rng.choice([1, 0xff])
    g = {k: rng.randrange(1 << 32) for k in GLOBAL_WRITES}
    return make_scenario(rng, 10, 0x4b7389, 474, d, x, y, [*recs, obj], {}, g=g, pointers=pointers)


def gen_4ab528(rng, n):
    state, stage, pos = cycle(n, ['pass', 'f54', 'f24', 'f5e'], ['l1', 'l2', 'l2neg', 'final', 'none'], ['first', 'last'])
    x, y = coord(rng), coord(rng)
    word = index_word(rng, n)
    d = bytearray(rng.randbytes(0x80))
    put32(d, 0x54, 0 if state == 'f54' else nonzero32(rng))
    put32(d, 0x24, nonzero32(rng) if state == 'f24' else 0)
    put32(d, 0x5e, nonzero32(rng) if state == 'f5e' else 0)
    put16(d, 0x1e, word)
    recs, obj, pointers = records_and_obj(rng, word, 0xc00)
    count = rng.choice([-1, 0, 1, 2, 4]) if stage == 'none' else (1 if pos == 'first' else rng.choice([2, 3, 4]))
    put16(obj.data, 0x21, count)
    t = 0 if pos == 'first' else max(count - 1, 0)
    for i in range(4):
        m1 = 'out'
        m2 = 'out'
        if stage == 'l1':
            m1 = 'out' if i < t else ('in' if i == t else 'rand')
        elif stage == 'l2':
            m2 = 'out' if i < t else ('in' if i == t else 'rand')
        elif stage == 'l2neg' and i == t:
            m2 = 'in'
        rect(rng, obj.data, 16 * i, (0xa3, 0xab, 0x9f, 0xa7), x, y, m1)
        rect(rng, obj.data, 16 * i, (0x1c3, 0x1cb, 0x1bf, 0x1c7), x, y, m2)
        # the enabling word of item i: positive for a hit in 'l2', not positive otherwise (earlier 'in' items of 'l2' are disabled)
        put16(d, 0x3c + 2 * i, rng.choice([1, 2, 0x7fff]) if (stage == 'l2' and i == t) else rng.choice([0, -1, -32768]) if (stage == 'l2neg' or i < t) else rng.randrange(-32768, 32768))
    rect(rng, obj.data, 0, (0xbb3, 0xbbb, 0xbaf, 0xbb7), x, y, 'in' if stage == 'final' else 'out')
    stubs = {0x4ab706: callee_stub(0x4ab706, 2, 8)}
    return make_scenario(rng, 11, 0x4ab528, 478, d, x, y, [*recs, obj], stubs, word_args={0x4ab706: (1,)}, pointers=pointers)


# (va, span, name, generator, symbol, ledger_window_end)
FUNCTIONS = [
    (0x47d734, 73, 'store_point', gen_47d734),
    (0x4a1e16, 125, 'hit_test', gen_4a1e16),
    (0x4ba377, 271, 'hit_test', gen_4ba377),
    (0x459cc9, 275, 'hit_test', gen_459cc9),
    (0x487c92, 317, 'hit_test', gen_487c92),
    (0x48a920, 326, 'hit_test', gen_48a920),
    (0x48e628, 334, 'hit_test', gen_48e628),
    (0x479deb, 391, 'hit_test', gen_479deb),
    (0x46ea16, 423, 'hit_test', gen_46ea16),
    (0x4b7389, 474, 'hit_test', gen_4b7389),
    (0x4ab528, 478, 'hit_test', gen_4ab528),
]
BY_VA = {va: (span, name, gen) for va, span, name, gen in FUNCTIONS}


def scenarios(va, count=SCENARIOS):
    """The scenarios of one function: the same rng seed on every run, so every consumer sees the same fixtures."""
    span, _name, gen = BY_VA[va]
    rng = random.Random(va)
    return [gen(rng, n) for n in range(count)]
