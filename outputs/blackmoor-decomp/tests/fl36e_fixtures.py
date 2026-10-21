"""FL-36 (batch e): the fixtures shared by tests/test_fl36e_differential.py and tests/fl36e_original_oracle.py.

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
    """The fields of Fl36eWorld, from the header, as [(name, ctype, is_pointer)] (none when the batch has no world)."""
    text = (PROJECT / 'src/original_methods_fl36e.h').read_text()
    found = re.search(r'typedef struct Fl36eWorld \{(.*?)\} Fl36eWorld;', text, re.S)
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


SELF_BYTES = 0x8300
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
    '402945': (13, 13),
    '40338e': (13, 13),
    '4033ab': (32, 32),
    '404b0c': (13, 13),
    '404b19': (32, 32),
    '407c8a': (13, 13),
    '407d70': (32, 32),
    '40905e': (13, 13),
    '40907b': (32, 32),
    '414cb0': (31, 31),
    '423450': (23, 23),
    '423467': (20, 20),
    '4234b5': (19, 19),
    '426b5d': (15, 15),
    '426b7e': (15, 15),
    '43772f': (20, 20),
    '43eb3a': (31, 31),
    '43ef10': (23, 23),
    '43ef27': (20, 20),
    '445f40': (19, 19),
    '447d4b': (21, 21),
    '447e27': (31, 31),
    '447e62': (22, 22),
    '44883f': (20, 20),
    '44885e': (19, 19),
    '44afb7': (31, 31),
    '44be90': (23, 23),
    '44bea7': (20, 20),
    '454d8a': (20, 20),
    '456dab': (29, 29),
    '46401a': (20, 20),
    '4674ff': (20, 20),
    '46b73e': (29, 29),
    '470e71': (29, 29),
    '4712b0': (13, 13),
    '4782be': (29, 29),
    '488d6a': (31, 31),
    '48d119': (20, 20),
    '493ad8': (24, 24),
    '4a7ddc': (29, 29),
    '4ab459': (20, 20),
    '4b5c48': (20, 20),
    '4bf3a4': (20, 20),
    '4c0c40': (20, 20),
    '4caeef': (20, 20),
    '4cc927': (31, 31),
    '4d3705': (15, 15),
    '4d3714': (15, 15),
    '4d3c1d': (20, 20),
    '4d51ea': (13, 13),
    '4d52a6': (19, 19),
    '4dae66': (17, 17),
    '4dae77': (17, 17),
    '4daef1': (17, 17),
    '4daf02': (22, 22),
    '4daf18': (17, 17),
    '4daf29': (22, 22),
    '4db377': (19, 19),
    '4dd3f6': (19, 19),
    '4e0742': (24, 24),
    '4e2940': (22, 22),
    '4e2956': (17, 17),
    '4e2967': (17, 17),
    '4e2978': (24, 24),
    '4e2990': (22, 22),
    '4e29a6': (17, 17),
    '4e40fb': (25, 25),
    '4e4114': (25, 25),
    '4e779f': (25, 25),
    '4e89b9': (25, 25),
    '4e89d2': (25, 25),
    '4e9e6c': (24, 24),
    '4ebd53': (25, 25),
    '4ebd6c': (25, 25),
    '4ee602': (20, 20),
    '4ee630': (20, 20),
    '4ef4c9': (22, 22),
    '4ef4df': (17, 17),
    '4ef516': (20, 20),
    '4f0046': (19, 19),
}

ROWS = {
    '402945': ('retn', {'n': 4}),
    '40338e': ('retn', {'n': 4}),
    '4033ab': ('call2', {'callee': 5380898, 'callee2': 4207579, 'imm': 1}),
    '404b0c': ('retn', {'n': 4}),
    '404b19': ('call2', {'callee': 5380898, 'callee2': 4213729, 'imm': 1}),
    '407c8a': ('retn', {'n': 4}),
    '407d70': ('call2', {'callee': 5380898, 'callee2': 4226215, 'imm': 1}),
    '40905e': ('retn', {'n': 4}),
    '40907b': ('call2', {'callee': 5380898, 'callee2': 4231339, 'imm': 1}),
    '414cb0': ('dtorbase', {'callee': 5363478, 'imm': 5424448}),
    '423450': ('setvt', {'imm': 5424776}),
    '423467': ('setvt', {'imm': 5424776}),
    '4234b5': ('tail0', {'callee': 4338811}),
    '426b5d': ('scall', {'obj': 5702536, 'callee': 4351264}),
    '426b7e': ('scall', {'obj': 5702536, 'callee': 4355104}),
    '43772f': ('setvt', {'imm': 5425084}),
    '43eb3a': ('dtorbase', {'callee': 5384134, 'imm': 5425408}),
    '43ef10': ('setvt', {'imm': 5425680}),
    '43ef27': ('setvt', {'imm': 5425680}),
    '445f40': ('tail0', {'callee': 4480555}),
    '447d4b': ('setfi', {'off': 4, 'imm': 0}),
    '447e27': ('dtorbase', {'callee': 5363478, 'imm': 5425928}),
    '447e62': ('setfa', {'off': 30}),
    '44883f': ('setvt', {'imm': 5426008}),
    '44885e': ('tail0', {'callee': 4491347}),
    '44afb7': ('dtorbase', {'callee': 5363478, 'imm': 5426072}),
    '44be90': ('setvt', {'imm': 5426160}),
    '44bea7': ('setvt', {'imm': 5426160}),
    '454d8a': ('setw', {'addr': 5899585, 'imm': 0}),
    '456dab': ('setw2', {'addr': 5855169, 'imm': 0, 'addr2': 5855171, 'imm2': 0}),
    '46401a': ('setw', {'addr': 5899587, 'imm': 0}),
    '4674ff': ('setvt', {'imm': 5427680}),
    '46b73e': ('setw2', {'addr': 5903579, 'imm': 0, 'addr2': 5903581, 'imm2': 9999}),
    '470e71': ('setw2', {'addr': 5855157, 'imm': 0, 'addr2': 5855159, 'imm2': 0}),
    '4712b0': ('retn', {'n': 8}),
    '4782be': ('setw2', {'addr': 5855163, 'imm': 0, 'addr2': 5855165, 'imm2': 9999}),
    '488d6a': ('dtorbase', {'callee': 5363478, 'imm': 5429328}),
    '48d119': ('setw', {'addr': 5852591, 'imm': 0}),
    '493ad8': ('setfi', {'off': 8203, 'imm': 1}),
    '4a7ddc': ('setw2', {'addr': 5902603, 'imm': 0, 'addr2': 5902605, 'imm2': 9999}),
    '4ab459': ('setw', {'addr': 5855161, 'imm': 0}),
    '4b5c48': ('setw', {'addr': 5852593, 'imm': 0}),
    '4bf3a4': ('getf', {'off': 704}),
    '4c0c40': ('getf', {'off': 534}),
    '4caeef': ('setvt', {'imm': 5431868}),
    '4cc927': ('dtorbase', {'callee': 5363478, 'imm': 5431928}),
    '4d3705': ('scall', {'obj': 5777169, 'callee': 5142986}),
    '4d3714': ('scall', {'obj': 5702920, 'callee': 5116247}),
    '4d3c1d': ('getf', {'off': 1122}),
    '4d51ea': ('retn', {'n': 4}),
    '4d52a6': ('tail0', {'callee': 5067419}),
    '4dae66': ('getf', {'off': 24}),
    '4dae77': ('getf', {'off': 28}),
    '4daef1': ('getf', {'off': 12}),
    '4daf02': ('setfa', {'off': 12}),
    '4daf18': ('getf', {'off': 16}),
    '4daf29': ('setfa', {'off': 16}),
    '4db377': ('tail0', {'callee': 5091995}),
    '4dd3f6': ('tail0', {'callee': 5100523}),
    '4e0742': ('setfi', {'off': 3886, 'imm': 1}),
    '4e2940': ('setfa', {'off': 48}),
    '4e2956': ('getf', {'off': 48}),
    '4e2967': ('getf', {'off': 122}),
    '4e2978': ('setfi', {'off': 375, 'imm': 1}),
    '4e2990': ('setfa', {'off': 24}),
    '4e29a6': ('getf', {'off': 24}),
    '4e40fb': ('fwd1', {'callee': 5169071}),
    '4e4114': ('fwd1', {'callee': 5169364}),
    '4e779f': ('fwd1', {'callee': 5169364}),
    '4e89b9': ('fwd1', {'callee': 5169071}),
    '4e89d2': ('fwd1', {'callee': 5169364}),
    '4e9e6c': ('setfi', {'off': 33366, 'imm': 0}),
    '4ebd53': ('fwd1', {'callee': 5169071}),
    '4ebd6c': ('fwd1', {'callee': 5169364}),
    '4ee602': ('getf', {'off': 1199}),
    '4ee630': ('getf', {'off': 1195}),
    '4ef4c9': ('setfa', {'off': 16}),
    '4ef4df': ('getf', {'off': 16}),
    '4ef516': ('getf', {'off': 354}),
    '4f0046': ('tail0', {'callee': 5177403}),
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
