"""FL-36 (batch b): the fixtures shared by tests/test_fl36b_differential.py and tests/fl36b_original_oracle.py.

Same shape as tests/fl35b_fixtures.py (whose generic harness pieces come from tests/fl28b_fixtures.py: the Unicorn runner with the code and edge hooks, the recording
stub constructor, the call-log normaliser and the conditional-jump finder). `build(key, rng, n)` makes scenario n of one of the functions of SPECS: the object `this`,
the scripted callees (recording stubs at the call boundary, entered by address), the scripted stack argument and the globals. Random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees are recording stubs (host boundaries); nothing inside the function under test is patched.
"""
import ctypes
import hashlib
from pathlib import Path
import re
import struct
import sys
from types import SimpleNamespace

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import original_differential as od
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl36bWorld, from the header, as [(name, ctype, is_pointer)] (none when the batch has no world)."""
    text = (PROJECT / 'src/original_methods_fl36b.h').read_text()
    found = re.search(r'typedef struct Fl36bWorld \{(.*?)\} Fl36bWorld;', text, re.S)
    if found is None:
        return []
    body = re.sub(r'/\*.*?\*/', '', found.group(1), flags=re.S)
    fields = []
    for decl in body.split(';'):
        decl = decl.strip().replace('const ', '')
        if not decl:
            continue
        kind, _, names = decl.partition(' ')
        for name in names.split(','):
            name = name.strip()
            fields.append((name, CTYPES[kind], False))
    return fields


WORLD_FIELDS = parse_world()


class World(ctypes.Structure):
    _fields_ = [(n, t) for n, t, _ in WORLD_FIELDS]


GLOBALS = {n: (int(n.rsplit('_', 1)[1], 16), ctypes.sizeof(t)) for n, t, p in WORLD_FIELDS if not p}
WORD_ARGS = {}


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=None, partial=None, fault=fault)


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
    for x in [*sc.stubs.values(), *sc.iat.values()]:
        x.probe_addr = [((GLOBALS[name[2:]][0] if name.startswith('g:') else next(a.va for a in sc.areas if a.name == name)) + off, ln) for name, off, ln in (x.probe or ())]
    runner = Original27(image_patches, regions, sc.stubs, sc.iat)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if SPECS[sc.key].get('retself') and orig.eax != sc.ecx:
        raise AssertionError('the function must return this')
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret') or SPECS[sc.key].get('retself'):
        h.update(struct.pack('<I', orig.eax))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


SELF_BYTES = 0x200
RET_VALUES = [0, 1, 0x80000000, 0xffffffff]
FLAGS = [0, 1, 2, 3, 0x100, 0x101, 0xfffffffe, 0xffffffff, 0x80000000, 0x80000001]


def self_area(rng):
    return Area('self', od.region_va(0), bytearray(rng.randbytes(SELF_BYTES)), image=False)


def result(rng):
    return rng.choice(RET_VALUES + [rng.randrange(1 << 32)])


# ---- the rows: key -> kind and the constants read from the disassembly of the row ----------------------------------------------------

SIZES = {
    '40104e': (16, 16),
    '4010b0': (16, 16),
    '40148a': (16, 16),
    '40167f': (16, 16),
    '402952': (16, 16),
    '4030aa': (16, 16),
    '40339b': (16, 16),
    '4033cb': (16, 16),
    '404aba': (16, 16),
    '404b39': (16, 16),
    '405b62': (16, 16),
    '407baa': (16, 16),
    '407c97': (16, 16),
    '407d90': (16, 16),
    '408a1a': (16, 16),
    '40906b': (16, 16),
    '40909b': (16, 16),
    '414527': (16, 16),
    '41a4be': (11, 11),
    '41be0a': (16, 16),
    '4229fa': (16, 16),
    '426510': (16, 16),
    '43eb1a': (16, 16),
    '43eb2a': (16, 16),
    '43ef00': (16, 16),
    '446f67': (16, 16),
    '447e17': (16, 16),
    '447e78': (11, 11),
    '448853': (11, 11),
    '448871': (11, 11),
    '44afa7': (16, 16),
    '44d087': (16, 16),
    '44e025': (16, 16),
    '44e6e7': (16, 16),
    '44e80b': (11, 11),
    '44f4ea': (16, 16),
    '454d0a': (16, 16),
    '456506': (16, 16),
    '456c87': (16, 16),
    '457bc8': (16, 16),
    '457efa': (16, 16),
    '4595e1': (16, 16),
    '459a6a': (16, 16),
    '45ae5e': (16, 16),
    '45b36a': (16, 16),
    '45d2b6': (16, 16),
    '45dc0a': (16, 16),
    '460f16': (16, 16),
    '4617a7': (16, 16),
    '463b00': (16, 16),
    '463f9a': (16, 16),
    '4657d7': (16, 16),
    '465a87': (16, 16),
    '465bd3': (11, 11),
    '466e04': (16, 16),
    '468dda': (16, 16),
    '46ab6f': (16, 16),
    '46b50a': (16, 16),
    '46dea0': (16, 16),
    '46e5ea': (16, 16),
    '470a63': (16, 16),
    '470cfa': (16, 16),
    '472a4c': (16, 16),
    '47575a': (16, 16),
    '4778cf': (16, 16),
    '47817a': (16, 16),
    '47ac23': (16, 16),
    '47d477': (16, 16),
    '47d677': (11, 11),
    '47df47': (16, 16),
    '47e1da': (16, 16),
    '481ca9': (16, 16),
    '4820fa': (16, 16),
    '483ac9': (16, 16),
    '483eea': (16, 16),
    '4876dd': (16, 16),
    '487a9a': (16, 16),
    '487bcc': (11, 11),
    '4889e0': (16, 16),
    '488d5a': (16, 16),
    '48a3cb': (16, 16),
    '48a68a': (16, 16),
    '48b720': (16, 16),
    '48ba97': (16, 16),
    '48bc9b': (11, 11),
    '48cc60': (16, 16),
    '48cfe7': (16, 16),
    '48dec7': (16, 16),
    '48e20a': (16, 16),
    '49026c': (16, 16),
    '4904ea': (16, 16),
    '494f14': (11, 11),
    '49c45c': (16, 16),
    '49c52a': (16, 16),
    '4a1bc7': (16, 16),
    '4a35c7': (16, 16),
    '4a370a': (16, 16),
    '4a5eda': (16, 16),
    '4a630a': (16, 16),
    '4a64ae': (11, 11),
    '4a7a19': (16, 16),
    '4a7bfa': (16, 16),
    '4a9b1b': (16, 16),
    '4a9ea7': (16, 16),
    '4aaef5': (16, 16),
    '4ab327': (16, 16),
    '4ac488': (16, 16),
    '4ac85a': (16, 16),
    '4afa0e': (16, 16),
    '4afcba': (16, 16),
    '4afdfe': (11, 11),
    '4b371c': (16, 16),
    '4b3bda': (16, 16),
    '4b5838': (16, 16),
    '4b5b0a': (16, 16),
    '4b7041': (16, 16),
    '4b7177': (16, 16),
    '4b7ddd': (16, 16),
    '4c0f60': (16, 16),
    '4cc917': (16, 16),
    '4d3b0a': (16, 16),
    '4d3b8a': (11, 11),
    '4d3d3d': (11, 11),
    '4d4192': (16, 16),
    '4d51f7': (16, 16),
    '4d529b': (11, 11),
    '4dbf0a': (16, 16),
    '4dd3eb': (11, 11),
    '4f003b': (11, 11),
}

ROWS = {
    '40104e': ('get', {'const': 5416272}),
    '4010b0': ('get', {'const': 128}),
    '40148a': ('get', {'const': 5416584}),
    '40167f': ('get', {'const': 5416608}),
    '402952': ('get', {'const': 5418080}),
    '4030aa': ('get', {'const': 5418896}),
    '40339b': ('get', {'const': 5418920}),
    '4033cb': ('get', {'const': 1}),
    '404aba': ('get', {'const': 5419864}),
    '404b39': ('get', {'const': 1}),
    '405b62': ('get', {'const': 5419888}),
    '407baa': ('get', {'const': 5421864}),
    '407c97': ('get', {'const': 5421888}),
    '407d90': ('get', {'const': 1}),
    '408a1a': ('get', {'const': 5423048}),
    '40906b': ('get', {'const': 5423072}),
    '40909b': ('get', {'const': 1}),
    '414527': ('get', {'const': 5424312}),
    '41a4be': ('empty', {}),
    '41be0a': ('get', {'const': 5424624}),
    '4229fa': ('get', {'const': 5424648}),
    '426510': ('get', {'const': 5424784}),
    '43eb1a': ('get', {'const': 5425088}),
    '43eb2a': ('get', {'const': 5425112}),
    '43ef00': ('get', {'const': 5425656}),
    '446f67': ('get', {'const': 5425696}),
    '447e17': ('get', {'const': 5425872}),
    '447e78': ('empty', {}),
    '448853': ('empty', {}),
    '448871': ('empty', {}),
    '44afa7': ('get', {'const': 5426016}),
    '44d087': ('get', {'const': 5426176}),
    '44e025': ('get', {'const': 5426200}),
    '44e6e7': ('get', {'const': 5426312}),
    '44e80b': ('empty', {}),
    '44f4ea': ('get', {'const': 5426336}),
    '454d0a': ('get', {'const': 5426456}),
    '456506': ('get', {'const': 5426480}),
    '456c87': ('get', {'const': 5426592}),
    '457bc8': ('get', {'const': 5426616}),
    '457efa': ('get', {'const': 5426728}),
    '4595e1': ('get', {'const': 5426752}),
    '459a6a': ('get', {'const': 5426864}),
    '45ae5e': ('get', {'const': 5426888}),
    '45b36a': ('get', {'const': 5427000}),
    '45d2b6': ('get', {'const': 5427024}),
    '45dc0a': ('get', {'const': 5427136}),
    '460f16': ('get', {'const': 5427160}),
    '4617a7': ('get', {'const': 5427272}),
    '463b00': ('get', {'const': 5427296}),
    '463f9a': ('get', {'const': 5427408}),
    '4657d7': ('get', {'const': 5427432}),
    '465a87': ('get', {'const': 5427544}),
    '465bd3': ('empty', {}),
    '466e04': ('get', {'const': 5427568}),
    '468dda': ('get', {'const': 5427688}),
    '46ab6f': ('get', {'const': 5427712}),
    '46b50a': ('get', {'const': 5427888}),
    '46dea0': ('get', {'const': 5427912}),
    '46e5ea': ('get', {'const': 5428024}),
    '470a63': ('get', {'const': 5428048}),
    '470cfa': ('get', {'const': 5428160}),
    '472a4c': ('get', {'const': 5428184}),
    '47575a': ('get', {'const': 5428312}),
    '4778cf': ('get', {'const': 5428336}),
    '47817a': ('get', {'const': 5428448}),
    '47ac23': ('get', {'const': 5428472}),
    '47d477': ('get', {'const': 5428592}),
    '47d677': ('empty', {}),
    '47df47': ('get', {'const': 5428616}),
    '47e1da': ('get', {'const': 5428728}),
    '481ca9': ('get', {'const': 5428752}),
    '4820fa': ('get', {'const': 5428864}),
    '483ac9': ('get', {'const': 5428888}),
    '483eea': ('get', {'const': 5429000}),
    '4876dd': ('get', {'const': 5429024}),
    '487a9a': ('get', {'const': 5429136}),
    '487bcc': ('empty', {}),
    '4889e0': ('get', {'const': 5429160}),
    '488d5a': ('get', {'const': 5429272}),
    '48a3cb': ('get', {'const': 5429296}),
    '48a68a': ('get', {'const': 5429408}),
    '48b720': ('get', {'const': 5429432}),
    '48ba97': ('get', {'const': 5429544}),
    '48bc9b': ('empty', {}),
    '48cc60': ('get', {'const': 5429568}),
    '48cfe7': ('get', {'const': 5429680}),
    '48dec7': ('get', {'const': 5429704}),
    '48e20a': ('get', {'const': 5429816}),
    '49026c': ('get', {'const': 5429840}),
    '4904ea': ('get', {'const': 5429952}),
    '494f14': ('empty', {}),
    '49c45c': ('get', {'const': 5429976}),
    '49c52a': ('get', {'const': 5430160}),
    '4a1bc7': ('get', {'const': 5430304}),
    '4a35c7': ('get', {'const': 5430328}),
    '4a370a': ('get', {'const': 5430440}),
    '4a5eda': ('get', {'const': 5430464}),
    '4a630a': ('get', {'const': 5430576}),
    '4a64ae': ('empty', {}),
    '4a7a19': ('get', {'const': 5430600}),
    '4a7bfa': ('get', {'const': 5430712}),
    '4a9b1b': ('get', {'const': 5430736}),
    '4a9ea7': ('get', {'const': 5430848}),
    '4aaef5': ('get', {'const': 5430872}),
    '4ab327': ('get', {'const': 5430984}),
    '4ac488': ('get', {'const': 5431008}),
    '4ac85a': ('get', {'const': 5431120}),
    '4afa0e': ('get', {'const': 5431144}),
    '4afcba': ('get', {'const': 5431256}),
    '4afdfe': ('empty', {}),
    '4b371c': ('get', {'const': 5431280}),
    '4b3bda': ('get', {'const': 5431392}),
    '4b5838': ('get', {'const': 5431416}),
    '4b5b0a': ('get', {'const': 5431528}),
    '4b7041': ('get', {'const': 5431552}),
    '4b7177': ('get', {'const': 5431664}),
    '4b7ddd': ('get', {'const': 5431688}),
    '4c0f60': ('get', {'const': 5431832}),
    '4cc917': ('get', {'const': 5431872}),
    '4d3b0a': ('get', {'const': 5432024}),
    '4d3b8a': ('empty', {}),
    '4d3d3d': ('empty', {}),
    '4d4192': ('get', {'const': 5432048}),
    '4d51f7': ('get', {'const': 5432160}),
    '4d529b': ('empty', {}),
    '4dbf0a': ('get', {'const': 5432416}),
    '4dd3eb': ('empty', {}),
    '4f003b': ('empty', {}),
}


def gen(key, rng, n):
    kind, c = ROWS[key]
    g = {n_: rng.choice([0, 0xffffffff, rng.randrange(1 << 32)]) for n_ in GLOBALS}
    self_probe = [('self', 0, 0x20)]
    if kind in ('get', 'empty'):
        return make(key, [self_area(rng)], {}, g, [], (), (n,))
    if kind in ('ctor', 'ctorret'):
        stubs = {c['callee']: stub(c['callee'], THISCALL(0), results=[result(rng)], probe=self_probe)}
        return make(key, [self_area(rng)], stubs, g, [], (), (n,))
    if kind == 'setg':
        stubs = {c['callee']: stub(c['callee'], THISCALL(0), results=[result(rng)], probe=[('g:dword_%x' % c['addr'], 0, 4), *self_probe])}
        return make(key, [self_area(rng)], stubs, g, [], (), (n,))
    if kind == 'dtor':
        flags = FLAGS[n % len(FLAGS)]
        stubs = {c['callee']: stub(c['callee'], THISCALL(0), results=[result(rng)], probe=self_probe),
                 0x51dc6c: stub(0x51dc6c, CDECL(1), results=[result(rng)], probe=self_probe)}
        return make(key, [self_area(rng)], stubs, g, [flags], (flags,), (flags,))
    raise KeyError(kind)


COUNTS = {'get': 4, 'empty': 2, 'ctor': 4, 'ctorret': 4, 'setg': 4, 'dtor': 2 * len(FLAGS)}
SPECS = {}
NAMES = {}
for _i, (_k, (_kind, _c)) in enumerate(ROWS.items()):
    _spec = SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=SIZES[_k][0], code=SIZES[_k][1], n=COUNTS[_kind])
    if _kind == 'dtor':
        _spec['cleanup'] = 4
    if _kind in ('ctorret', 'dtor'):
        _spec['retself'] = True
    elif _kind != 'empty':
        _spec['ret'] = True
    NAMES[_k] = {'get': 'get_constant', 'empty': 'empty_method', 'ctor': 'init_vtable_call', 'ctorret': 'init_vtable_call_ret_self', 'setg': 'set_mode_call', 'dtor': 'scalar_deleting_dtor'}[_kind]
KEYS = list(SPECS)


def build(key, rng, n):
    return gen(key, rng, n)


def scenarios(key):
    return SPECS[key]['n']
