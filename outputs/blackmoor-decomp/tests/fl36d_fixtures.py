"""FL-36 (batch d): the fixtures shared by tests/test_fl36d_differential.py and tests/fl36d_original_oracle.py.

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
    """The fields of Fl36dWorld, from the header, as [(name, ctype, is_pointer)] (none when the batch has no world)."""
    text = (PROJECT / 'src/original_methods_fl36d.h').read_text()
    found = re.search(r'typedef struct Fl36dWorld \{(.*?)\} Fl36dWorld;', text, re.S)
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
    '401100': (48, 46),
    '401190': (48, 46),
    '401c40': (48, 46),
    '403010': (48, 46),
    '404a20': (48, 46),
    '407b10': (48, 46),
    '408980': (48, 46),
    '40b2a0': (48, 46),
    '414490': (48, 46),
    '414c80': (48, 46),
    '416e60': (48, 46),
    '41a480': (48, 46),
    '422fb0': (48, 46),
    '425f70': (48, 46),
    '4273f0': (48, 46),
    '434880': (48, 46),
    '438120': (48, 46),
    '43eed0': (48, 46),
    '43f1e0': (48, 46),
    '446ed0': (48, 46),
    '447ce0': (48, 46),
    '447d80': (48, 46),
    '4487f0': (48, 46),
    '449770': (48, 46),
    '449d60': (48, 46),
    '44be60': (48, 46),
    '44c2b0': (48, 46),
    '44e650': (48, 46),
    '44f620': (48, 46),
    '454c70': (48, 46),
    '456bf0': (48, 46),
    '457e60': (48, 46),
    '4599d0': (48, 46),
    '45b2d0': (48, 46),
    '45db70': (48, 46),
    '461710': (48, 46),
    '463f00': (48, 46),
    '4659f0': (48, 46),
    '4674b0': (48, 46),
    '468d40': (48, 46),
    '46b470': (48, 46),
    '46e550': (48, 46),
    '470c60': (48, 46),
    '472ed0': (48, 46),
    '4756c0': (48, 46),
    '4780e0': (48, 46),
    '47b1d0': (48, 46),
    '47d3e0': (48, 46),
    '47e140': (48, 46),
    '482060': (48, 46),
    '483e50': (48, 46),
    '487a00': (48, 46),
    '488cc0': (48, 46),
    '48a5f0': (48, 46),
    '48ba00': (48, 46),
    '48cf50': (48, 46),
    '48e170': (48, 46),
    '490450': (48, 46),
    '49c490': (48, 46),
    '4a1b30': (48, 46),
    '4a3670': (48, 46),
    '4a6270': (48, 46),
    '4a7b60': (48, 46),
    '4a9e10': (48, 46),
    '4ab290': (48, 46),
    '4ac7c0': (48, 46),
    '4afc20': (48, 46),
    '4b3b40': (48, 46),
    '4b5a70': (48, 46),
    '4b70e0': (48, 46),
    '4b7ed0': (48, 46),
    '4b9dd0': (48, 46),
    '4bed40': (48, 46),
    '4bf5d0': (48, 46),
    '4c0f30': (48, 46),
    '4cae90': (48, 46),
    '4cc880': (48, 46),
    '4ccd40': (48, 46),
    '4cf7b0': (48, 46),
    '4d42b0': (48, 46),
    '4d5230': (48, 46),
    '4d5880': (48, 46),
    '4d9d40': (48, 46),
    '4dbca0': (48, 46),
    '4dd380': (48, 46),
    '4de120': (48, 46),
    '4de5c0': (48, 46),
    '4e03e0': (48, 46),
    '4e1c20': (48, 46),
    '4e2cb0': (48, 46),
    '4e7600': (48, 46),
    '4e7a40': (48, 46),
    '4eb840': (48, 46),
    '4ed9e0': (48, 46),
    '4ee950': (48, 46),
    '4effd0': (48, 46),
    '4f2610': (48, 46),
}

ROWS = {
    '401100': ('dtor', {'callee': 4198450}),
    '401190': ('dtor', {'callee': 5379926}),
    '401c40': ('dtor', {'callee': 4199669}),
    '403010': ('dtor', {'callee': 4201584}),
    '404a20': ('dtor', {'callee': 4207145}),
    '407b10': ('dtor', {'callee': 4213488}),
    '408980': ('dtor', {'callee': 4226089}),
    '40b2a0': ('dtor', {'callee': 4230473}),
    '414490': ('dtor', {'callee': 4264151}),
    '414c80': ('dtor', {'callee': 4277643}),
    '416e60': ('dtor', {'callee': 4279503}),
    '41a480': ('dtor', {'callee': 4288301}),
    '422fb0': ('dtor', {'callee': 4308668}),
    '425f70': ('dtor', {'callee': 4338791}),
    '4273f0': ('dtor', {'callee': 4355104}),
    '434880': ('dtor', {'callee': 4406883}),
    '438120': ('dtor', {'callee': 4421423}),
    '43eed0': ('dtor', {'callee': 4451161}),
    '43f1e0': ('dtor', {'callee': 4452135}),
    '446ed0': ('dtor', {'callee': 4480527}),
    '447ce0': ('dtor', {'callee': 4485034}),
    '447d80': ('dtor', {'callee': 4488495}),
    '4487f0': ('dtor', {'callee': 4488774}),
    '449770': ('dtor', {'callee': 4491327}),
    '449d60': ('dtor', {'callee': 4495992}),
    '44be60': ('dtor', {'callee': 4501462}),
    '44c2b0': ('dtor', {'callee': 4505255}),
    '44e650': ('dtor', {'callee': 4509931}),
    '44f620': ('dtor', {'callee': 4515659}),
    '454c70': ('dtor', {'callee': 4519535}),
    '456bf0': ('dtor', {'callee': 4541806}),
    '457e60': ('dtor', {'callee': 4549867}),
    '4599d0': ('dtor', {'callee': 4554590}),
    '45b2d0': ('dtor', {'callee': 4561614}),
    '45db70': ('dtor', {'callee': 4568014}),
    '461710': ('dtor', {'callee': 4578414}),
    '463f00': ('dtor', {'callee': 4593675}),
    '4659f0': ('dtor', {'callee': 4603902}),
    '4674b0': ('dtor', {'callee': 4610795}),
    '468d40': ('dtor', {'callee': 4617471}),
    '46b470': ('dtor', {'callee': 4623934}),
    '46e550': ('dtor', {'callee': 4633966}),
    '470c60': ('dtor', {'callee': 4646506}),
    '472ed0': ('dtor', {'callee': 4656478}),
    '4756c0': ('dtor', {'callee': 4665237}),
    '4780e0': ('dtor', {'callee': 4675518}),
    '47b1d0': ('dtor', {'callee': 4686302}),
    '47d3e0': ('dtor', {'callee': 4698655}),
    '47e140': ('dtor', {'callee': 4707547}),
    '482060': ('dtor', {'callee': 4710974}),
    '483e50': ('dtor', {'callee': 4727134}),
    '487a00': ('dtor', {'callee': 4734798}),
    '488cc0': ('dtor', {'callee': 4750078}),
    '48a5f0': ('dtor', {'callee': 4754825}),
    '48ba00': ('dtor', {'callee': 4761326}),
    '48cf50': ('dtor', {'callee': 4766459}),
    '48e170': ('dtor', {'callee': 4771915}),
    '490450': ('dtor', {'callee': 4776558}),
    '49c490': ('dtor', {'callee': 4785479}),
    '4a1b30': ('dtor', {'callee': 4834719}),
    '4a3670': ('dtor', {'callee': 4856875}),
    '4a6270': ('dtor', {'callee': 4863854}),
    '4a7b60': ('dtor', {'callee': 4875118}),
    '4a9e10': ('dtor', {'callee': 4881502}),
    '4ab290': ('dtor', {'callee': 4890379}),
    '4ac7c0': ('dtor', {'callee': 4895627}),
    '4afc20': ('dtor', {'callee': 4901054}),
    '4b3b40': ('dtor', {'callee': 4914462}),
    '4b5a70': ('dtor', {'callee': 4930622}),
    '4b70e0': ('dtor', {'callee': 4938606}),
    '4b7ed0': ('dtor', {'callee': 4944347}),
    '4b9dd0': ('dtor', {'callee': 4947743}),
    '4bed40': ('dtor', {'callee': 4955679}),
    '4bf5d0': ('dtor', {'callee': 4976025}),
    '4c0f30': ('dtor', {'callee': 4978207}),
    '4cae90': ('dtor', {'callee': 4985754}),
    '4cc880': ('dtor', {'callee': 5025519}),
    '4ccd40': ('dtor', {'callee': 5032262}),
    '4cf7b0': ('dtor', {'callee': 5033359}),
    '4d42b0': ('dtor', {'callee': 5061486}),
    '4d5230': ('dtor', {'callee': 4501280}),
    '4d5880': ('dtor', {'callee': 5067391}),
    '4d9d40': ('dtor', {'callee': 5069007}),
    '4dbca0': ('dtor', {'callee': 5091967}),
    '4dd380': ('dtor', {'callee': 5095278}),
    '4de120': ('dtor', {'callee': 5100495}),
    '4de5c0': ('dtor', {'callee': 5104036}),
    '4e03e0': ('dtor', {'callee': 5105262}),
    '4e1c20': ('dtor', {'callee': 5112975}),
    '4e2cb0': ('dtor', {'callee': 5119107}),
    '4e7600': ('dtor', {'callee': 5123427}),
    '4e7a40': ('dtor', {'callee': 5142148}),
    '4eb840': ('dtor', {'callee': 5143351}),
    '4ed9e0': ('dtor', {'callee': 5159166}),
    '4ee950': ('dtor', {'callee': 5167740}),
    '4effd0': ('dtor', {'callee': 5171615}),
    '4f2610': ('dtor', {'callee': 5177375}),
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
