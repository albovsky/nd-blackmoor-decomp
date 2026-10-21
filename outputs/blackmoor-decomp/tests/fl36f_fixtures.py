"""FL-36 (batch f): the fixtures shared by tests/test_fl36f_differential.py and tests/fl36f_original_oracle.py.

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
from fl28b_fixtures import (Original27, stub, CDECL, STDCALL, THISCALL, Area, put32, put16, prof, normalize, conditional_edges, LOCAL, FMT, TIB)

PROJECT = Path(__file__).resolve().parents[1]
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl36fWorld, from the header, as [(name, ctype, is_pointer)] (none when the batch has no world)."""
    text = (PROJECT / 'src/original_methods_fl36f.h').read_text()
    found = re.search(r'typedef struct Fl36fWorld \{(.*?)\} Fl36fWorld;', text, re.S)
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


def make(key, areas, stubs, g, stack, args, profile, pointers=None, iat=None, fault=None, seh=None):
    sp = SPECS[key]
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], code=sp.get('code', sp['size']), areas=areas, stubs=stubs, iat=iat or {}, g=g,
                           ecx=od.region_va(0), pointers=pointers or {}, word_args=WORD_ARGS, profile=profile, stack=stack, args=args, seh=seh, partial=None, fault=fault)


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
    runner = Original27(image_patches, regions, sc.stubs, sc.iat, seh=sc.seh)
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    if sc.seh is not None and orig.memory.pop('tib') != struct.pack('<I', sc.seh):
        raise AssertionError('the structured-exception chain at fs:[0] was not restored')
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
RETSELF = ('ctorret', 'dtor', 'setvt', 'dtorbase', 'setfa', 'setfi', 'ctoreh')
NORET = ('empty', 'retn', 'setw', 'setw2')
RET_VALUES = [0, 1, 0x80000000, 0xffffffff]
FLAGS = [0, 1, 2, 3, 0x100, 0x101, 0xfffffffe, 0xffffffff, 0x80000000, 0x80000001]


def self_area(rng):
    return Area('self', od.region_va(0), bytearray(rng.randbytes(SELF_BYTES)), image=False)


def result(rng):
    return rng.choice(RET_VALUES + [rng.randrange(1 << 32)])


# ---- the rows: key -> kind and the constants read from the disassembly of the row ----------------------------------------------------

SIZES = {
    '401420': (106, 106),
    '403040': (106, 106),
    '404a50': (106, 106),
    '407b40': (106, 106),
    '4089b0': (106, 106),
    '4144c0': (103, 103),
    '414537': (84, 84),
    '41bda0': (106, 106),
    '43eab0': (106, 106),
    '446f00': (103, 103),
    '447db0': (103, 103),
    '44af40': (103, 103),
    '44d020': (103, 103),
    '44d097': (84, 84),
    '44e680': (103, 103),
    '44e6f7': (84, 84),
    '454ca0': (106, 106),
    '454d1a': (84, 84),
    '456c20': (103, 103),
    '456c97': (84, 84),
    '457e90': (106, 106),
    '457f0a': (84, 84),
    '459a00': (106, 106),
    '459a7a': (84, 84),
    '45b300': (106, 106),
    '45b37a': (84, 84),
    '45dba0': (106, 106),
    '45dc1a': (84, 84),
    '461740': (103, 103),
    '4617b7': (84, 84),
    '463f30': (106, 106),
    '463faa': (84, 84),
    '465a20': (103, 103),
    '465a97': (84, 84),
    '468d70': (106, 106),
    '468dea': (84, 84),
    '46b4a0': (106, 106),
    '46b51a': (84, 84),
    '46e580': (106, 106),
    '470c90': (106, 106),
    '470d0a': (84, 84),
    '4756f0': (106, 106),
    '47576a': (84, 84),
    '478110': (106, 106),
    '47818a': (84, 84),
    '47d410': (103, 103),
    '47d487': (84, 84),
    '47e170': (106, 106),
    '47e1ea': (84, 84),
    '482090': (106, 106),
    '48210a': (84, 84),
    '483e80': (106, 106),
    '483efa': (84, 84),
    '487a30': (106, 106),
    '487aaa': (84, 84),
    '488cf0': (106, 106),
    '48a620': (106, 106),
    '48a69a': (84, 84),
    '48ba30': (103, 103),
    '48baa7': (84, 84),
    '48cf80': (103, 103),
    '48cff7': (84, 84),
    '48e1a0': (106, 106),
    '48e21a': (84, 84),
    '490480': (106, 106),
    '49c4c0': (106, 106),
    '4a1b60': (103, 103),
    '4a1bd7': (84, 84),
    '4a36a0': (106, 106),
    '4a371a': (84, 84),
    '4a62a0': (106, 106),
    '4a631a': (84, 84),
    '4a7b90': (106, 106),
    '4a7c0a': (84, 84),
    '4a9e40': (103, 103),
    '4a9eb7': (84, 84),
    '4ab2c0': (103, 103),
    '4ab337': (84, 84),
    '4ac7f0': (106, 106),
    '4ac86a': (84, 84),
    '4afc50': (106, 106),
    '4afcca': (84, 84),
    '4b3b70': (106, 106),
    '4b3bea': (84, 84),
    '4b5aa0': (106, 106),
    '4b5b1a': (84, 84),
    '4b7110': (103, 103),
    '4b7187': (84, 84),
    '4cc8b0': (103, 103),
    '4d3aa0': (106, 106),
    '4d3b1a': (84, 84),
    '4dbea0': (106, 106),
    '4dbf1a': (84, 84),
    '4de150': (84, 84),
    '4e7630': (84, 84),
}

ROWS = {
    '401420': ('newctor', {'size': 140, 'callee': 4199578, 'handler': 5401290}),
    '403040': ('newctor', {'size': 1204, 'callee': 4206778, 'handler': 5401386}),
    '404a50': ('newctor', {'size': 3552, 'callee': 4213450, 'handler': 5401898}),
    '407b40': ('newctor', {'size': 2444, 'callee': 4225978, 'handler': 5401930}),
    '4089b0': ('newctor', {'size': 2700, 'callee': 4229674, 'handler': 5401994}),
    '4144c0': ('newctor', {'size': 40, 'callee': 4277559, 'handler': 5403274}),
    '414537': ('ctoreh', {'callee': 5363478, 'vtbl': 5424368, 'callee2': 4277671, 'handler': 5403293}),
    '41bda0': ('newctor', {'size': 8431, 'callee': 4308506, 'handler': 5403386}),
    '43eab0': ('newctor', {'size': 188, 'callee': 4451130, 'handler': 5406378}),
    '446f00': ('newctor', {'size': 94, 'callee': 4484983, 'handler': 5406410}),
    '447db0': ('newctor', {'size': 34, 'callee': 4488743, 'handler': 5406458}),
    '44af40': ('newctor', {'size': 30, 'callee': 4501431, 'handler': 5406586}),
    '44d020': ('newctor', {'size': 83, 'callee': 4509847, 'handler': 5406618}),
    '44d097': ('ctoreh', {'callee': 5363478, 'vtbl': 5426232, 'callee2': 4509959, 'handler': 5406637}),
    '44e680': ('newctor', {'size': 111, 'callee': 4515575, 'handler': 5406666}),
    '44e6f7': ('ctoreh', {'callee': 5363478, 'vtbl': 5426368, 'callee2': 4515687, 'handler': 5406685}),
    '454ca0': ('newctor', {'size': 372, 'callee': 4541722, 'handler': 5406714}),
    '454d1a': ('ctoreh', {'callee': 5363478, 'vtbl': 5426512, 'callee2': 4541854, 'handler': 5406733}),
    '456c20': ('newctor', {'size': 68, 'callee': 4549783, 'handler': 5406762}),
    '456c97': ('ctoreh', {'callee': 5363478, 'vtbl': 5426648, 'callee2': 4549895, 'handler': 5406781}),
    '457e90': ('newctor', {'size': 243, 'callee': 4554506, 'handler': 5406810}),
    '457f0a': ('ctoreh', {'callee': 5363478, 'vtbl': 5426784, 'callee2': 4554618, 'handler': 5406829}),
    '459a00': ('newctor', {'size': 226, 'callee': 4561530, 'handler': 5406858}),
    '459a7a': ('ctoreh', {'callee': 5363478, 'vtbl': 5426920, 'callee2': 4561642, 'handler': 5406877}),
    '45b300': ('newctor', {'size': 441, 'callee': 4567930, 'handler': 5406906}),
    '45b37a': ('ctoreh', {'callee': 5363478, 'vtbl': 5427056, 'callee2': 4568042, 'handler': 5406925}),
    '45dba0': ('newctor', {'size': 943, 'callee': 4578330, 'handler': 5406954}),
    '45dc1a': ('ctoreh', {'callee': 5363478, 'vtbl': 5427192, 'callee2': 4578442, 'handler': 5406973}),
    '461740': ('newctor', {'size': 95, 'callee': 4593591, 'handler': 5407002}),
    '4617b7': ('ctoreh', {'callee': 5363478, 'vtbl': 5427328, 'callee2': 4593703, 'handler': 5407021}),
    '463f30': ('newctor', {'size': 218, 'callee': 4603818, 'handler': 5407050}),
    '463faa': ('ctoreh', {'callee': 5363478, 'vtbl': 5427464, 'callee2': 4603950, 'handler': 5407069}),
    '465a20': ('newctor', {'size': 86, 'callee': 4610711, 'handler': 5407098}),
    '465a97': ('ctoreh', {'callee': 5363478, 'vtbl': 5427600, 'callee2': 4610823, 'handler': 5407117}),
    '468d70': ('newctor', {'size': 1460, 'callee': 4623850, 'handler': 5407146}),
    '468dea': ('ctoreh', {'callee': 5363478, 'vtbl': 5427744, 'callee2': 4623962, 'handler': 5407165}),
    '46b4a0': ('newctor', {'size': 33538, 'callee': 4633882, 'handler': 5407194}),
    '46b51a': ('ctoreh', {'callee': 5363478, 'vtbl': 5427944, 'callee2': 4633994, 'handler': 5407213}),
    '46e580': ('newctor', {'size': 149, 'callee': 4646394, 'handler': 5407242}),
    '470c90': ('newctor', {'size': 3594, 'callee': 4656394, 'handler': 5407354}),
    '470d0a': ('ctoreh', {'callee': 5363478, 'vtbl': 5428216, 'callee2': 4656506, 'handler': 5407373}),
    '4756f0': ('newctor', {'size': 2266, 'callee': 4675434, 'handler': 5407434}),
    '47576a': ('ctoreh', {'callee': 5363478, 'vtbl': 5428368, 'callee2': 4675546, 'handler': 5407453}),
    '478110': ('newctor', {'size': 5536, 'callee': 4686218, 'handler': 5407482}),
    '47818a': ('ctoreh', {'callee': 5363478, 'vtbl': 5428504, 'callee2': 4686330, 'handler': 5407501}),
    '47d410': ('newctor', {'size': 88, 'callee': 4707463, 'handler': 5407530}),
    '47d487': ('ctoreh', {'callee': 5363478, 'vtbl': 5428648, 'callee2': 4707575, 'handler': 5407549}),
    '47e170': ('newctor', {'size': 5197, 'callee': 4710890, 'handler': 5407610}),
    '47e1ea': ('ctoreh', {'callee': 5363478, 'vtbl': 5428784, 'callee2': 4711002, 'handler': 5407629}),
    '482090': ('newctor', {'size': 183, 'callee': 4727050, 'handler': 5407658}),
    '48210a': ('ctoreh', {'callee': 5363478, 'vtbl': 5428920, 'callee2': 4727162, 'handler': 5407677}),
    '483e80': ('newctor', {'size': 3131, 'callee': 4734714, 'handler': 5407706}),
    '483efa': ('ctoreh', {'callee': 5363478, 'vtbl': 5429056, 'callee2': 4734826, 'handler': 5407725}),
    '487a30': ('newctor', {'size': 155, 'callee': 4749994, 'handler': 5407754}),
    '487aaa': ('ctoreh', {'callee': 5363478, 'vtbl': 5429192, 'callee2': 4750106, 'handler': 5407773}),
    '488cf0': ('newctor', {'size': 208, 'callee': 4754794, 'handler': 5407802}),
    '48a620': ('newctor', {'size': 462, 'callee': 4761242, 'handler': 5407834}),
    '48a69a': ('ctoreh', {'callee': 5363478, 'vtbl': 5429464, 'callee2': 4761354, 'handler': 5407853}),
    '48ba30': ('newctor', {'size': 86, 'callee': 4766375, 'handler': 5407882}),
    '48baa7': ('ctoreh', {'callee': 5363478, 'vtbl': 5429600, 'callee2': 4766487, 'handler': 5407901}),
    '48cf80': ('newctor', {'size': 92, 'callee': 4771831, 'handler': 5407930}),
    '48cff7': ('ctoreh', {'callee': 5363478, 'vtbl': 5429736, 'callee2': 4771943, 'handler': 5407949}),
    '48e1a0': ('newctor', {'size': 1252, 'callee': 4776474, 'handler': 5407978}),
    '48e21a': ('ctoreh', {'callee': 5363478, 'vtbl': 5429872, 'callee2': 4776586, 'handler': 5407997}),
    '490480': ('newctor', {'size': 20734, 'callee': 4785402, 'handler': 5408026}),
    '49c4c0': ('newctor', {'size': 3660, 'callee': 4834618, 'handler': 5408074}),
    '4a1b60': ('newctor', {'size': 104, 'callee': 4856791, 'handler': 5408138}),
    '4a1bd7': ('ctoreh', {'callee': 5363478, 'vtbl': 5430360, 'callee2': 4856903, 'handler': 5408157}),
    '4a36a0': ('newctor', {'size': 2112, 'callee': 4863770, 'handler': 5408186}),
    '4a371a': ('ctoreh', {'callee': 5363478, 'vtbl': 5430496, 'callee2': 4863882, 'handler': 5408205}),
    '4a62a0': ('newctor', {'size': 168, 'callee': 4875034, 'handler': 5408234}),
    '4a631a': ('ctoreh', {'callee': 5363478, 'vtbl': 5430632, 'callee2': 4875146, 'handler': 5408253}),
    '4a7b90': ('newctor', {'size': 5117, 'callee': 4881418, 'handler': 5408282}),
    '4a7c0a': ('ctoreh', {'callee': 5363478, 'vtbl': 5430768, 'callee2': 4881530, 'handler': 5408301}),
    '4a9e40': ('newctor', {'size': 74, 'callee': 4890295, 'handler': 5408330}),
    '4a9eb7': ('ctoreh', {'callee': 5363478, 'vtbl': 5430904, 'callee2': 4890407, 'handler': 5408349}),
    '4ab2c0': ('newctor', {'size': 98, 'callee': 4895543, 'handler': 5408378}),
    '4ab337': ('ctoreh', {'callee': 5363478, 'vtbl': 5431040, 'callee2': 4895655, 'handler': 5408397}),
    '4ac7f0': ('newctor', {'size': 3721, 'callee': 4900970, 'handler': 5408426}),
    '4ac86a': ('ctoreh', {'callee': 5363478, 'vtbl': 5431176, 'callee2': 4901082, 'handler': 5408445}),
    '4afc50': ('newctor', {'size': 5441, 'callee': 4914378, 'handler': 5408474}),
    '4afcca': ('ctoreh', {'callee': 5363478, 'vtbl': 5431312, 'callee2': 4914490, 'handler': 5408493}),
    '4b3b70': ('newctor', {'size': 1922, 'callee': 4930538, 'handler': 5408522}),
    '4b3bea': ('ctoreh', {'callee': 5363478, 'vtbl': 5431448, 'callee2': 4930650, 'handler': 5408541}),
    '4b5aa0': ('newctor', {'size': 632, 'callee': 4938522, 'handler': 5408570}),
    '4b5b1a': ('ctoreh', {'callee': 5363478, 'vtbl': 5431584, 'callee2': 4938634, 'handler': 5408589}),
    '4b7110': ('newctor', {'size': 60, 'callee': 4944263, 'handler': 5408618}),
    '4b7187': ('ctoreh', {'callee': 5363478, 'vtbl': 5431720, 'callee2': 4944375, 'handler': 5408637}),
    '4cc8b0': ('newctor', {'size': 28, 'callee': 5032231, 'handler': 5408794}),
    '4d3aa0': ('newctor', {'size': 1126, 'callee': 5061402, 'handler': 5408858}),
    '4d3b1a': ('ctoreh', {'callee': 5363478, 'vtbl': 5432080, 'callee2': 5061525, 'handler': 5408877}),
    '4dbea0': ('newctor', {'size': 266, 'callee': 5095194, 'handler': 5408906}),
    '4dbf1a': ('ctoreh', {'callee': 5363478, 'vtbl': 5432440, 'callee2': 5095359, 'handler': 5408925}),
    '4de150': ('ctoreh', {'callee': 5167632, 'vtbl': 5432524, 'callee2': 5104117, 'handler': 5408985}),
    '4e7630': ('ctoreh', {'callee': 5167632, 'vtbl': 5432560, 'callee2': 5142229, 'handler': 5409289}),
}


def gen(key, rng, n):
    kind, c = ROWS[key]
    g = {n_: rng.choice([0xffffffff, 0xa5a5a5a5, rng.randrange(1, 1 << 32)]) for n_ in GLOBALS}      # never 0: a store of 0 must show
    self_probe = [('self', 0, 0x20)]
    areas = [self_area(rng)]
    th0 = lambda callee: stub(callee, THISCALL(0), results=[result(rng)], probe=self_probe)
    if kind in ('get', 'empty', 'getf', 'setvt', 'setfi', 'setw', 'setw2'):
        return make(key, areas, {}, g, [], (), (n,))
    if kind == 'retn':
        words = [rng.randrange(1 << 32) for _ in range(c['n'] // 4)]
        return make(key, areas, {}, g, words, tuple(words), (n,))
    if kind == 'setfa':
        value = rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)])
        return make(key, areas, {}, g, [value], (value,), (value,))
    if kind in ('ctor', 'ctorret', 'tail0', 'dtorbase'):
        return make(key, areas, {c['callee']: th0(c['callee'])}, g, [], (), (n,))
    if kind == 'setg':
        stubs = {c['callee']: stub(c['callee'], THISCALL(0), results=[result(rng)], probe=[('g:dword_%x' % c['addr'], 0, 4), *self_probe])}
        return make(key, areas, stubs, g, [], (), (n,))
    if kind == 'dtor':
        flags = FLAGS[n % len(FLAGS)]
        stubs = {c['callee']: th0(c['callee']), 0x51dc6c: stub(0x51dc6c, CDECL(1), results=[result(rng)], probe=self_probe)}
        return make(key, areas, stubs, g, [flags], (flags,), (flags,))
    if kind == 'fwd1':
        arg = rng.choice([0, 1, 0xffffffff, rng.randrange(1 << 32)])
        stubs = {c['callee']: stub(c['callee'], THISCALL(1), results=[result(rng)], probe=self_probe)}
        return make(key, areas, stubs, g, [arg], (arg,), (arg,))
    if kind == 'call2':
        return make(key, areas, {c['callee']: th0(c['callee']), c['callee2']: th0(c['callee2'])}, g, [], (), (n,))
    if kind == 'scall':
        return make(key, areas, {c['callee']: th0(c['callee'])}, g, [], (), (n,))
    if kind == 'newctor':
        made = 0 if n % 2 == 0 else rng.choice([1, 0x1000, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1, 1 << 32)])
        stubs = {0x51dc43: stub(0x51dc43, CDECL(1), results=[made]), c['callee']: th0(c['callee'])}
        sc = make(key, areas, stubs, g, [], (), (made,))
        sc.seh = rng.randrange(1 << 32)
        return sc
    if kind == 'ctoreh':
        sc = make(key, areas, {c['callee']: th0(c['callee']), c['callee2']: th0(c['callee2'])}, g, [], (), (n,))
        sc.seh = rng.randrange(1 << 32)
        return sc
    raise KeyError(kind)


COUNTS = {'get': 4, 'empty': 2, 'ctor': 4, 'ctorret': 4, 'setg': 4, 'dtor': 2 * len(FLAGS), 'getf': 4, 'retn': 2, 'setvt': 2, 'tail0': 4, 'fwd1': 6, 'dtorbase': 4, 'setfa': 4,
          'setfi': 2, 'setw': 3, 'setw2': 3, 'call2': 3, 'scall': 4, 'newctor': 8, 'ctoreh': 4}
SPECS = {}
NAMES = {}
for _i, (_k, (_kind, _c)) in enumerate(ROWS.items()):
    _spec = SPECS[_k] = dict(id=_i + 1, va=int(_k, 16), size=SIZES[_k][0], code=SIZES[_k][1], n=COUNTS[_kind])
    if _kind in ('dtor', 'fwd1', 'setfa'):
        _spec['cleanup'] = 4
    if _kind == 'retn':
        _spec['cleanup'] = _c['n']
    if _kind in RETSELF:
        _spec['retself'] = True
    elif _kind not in NORET:
        _spec['ret'] = True
    NAMES[_k] = {'get': 'get_constant', 'empty': 'empty_method', 'ctor': 'init_vtable_call', 'ctorret': 'init_vtable_call_ret_self', 'setg': 'set_mode_call', 'dtor': 'scalar_deleting_dtor', 'getf': 'get_field', 'retn': 'empty_method_args', 'setvt': 'init_vtable_ret_self', 'tail0': 'forward_call', 'fwd1': 'forward_call_arg', 'dtorbase': 'destruct_base_set_vtable', 'setfa': 'set_field_arg', 'setfi': 'set_field_const', 'setw': 'set_word', 'setw2': 'set_two_words', 'call2': 'call_two_return_const', 'scall': 'call_global_object', 'newctor': 'new_and_construct', 'ctoreh': 'construct_base_set_vtable'}[_kind]
KEYS = list(SPECS)


def build(key, rng, n):
    return gen(key, rng, n)


def scenarios(key):
    return SPECS[key]['n']
