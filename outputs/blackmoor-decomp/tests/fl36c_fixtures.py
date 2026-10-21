"""FL-36 (batch c): the fixtures shared by tests/test_fl36c_differential.py and tests/fl36c_original_oracle.py.

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
    """The fields of Fl36cWorld, from the header, as [(name, ctype, is_pointer)] (none when the batch has no world)."""
    text = (PROJECT / 'src/original_methods_fl36c.h').read_text()
    found = re.search(r'typedef struct Fl36cWorld \{(.*?)\} Fl36cWorld;', text, re.S)
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
    '401032': (28, 28),
    '4014f5': (28, 28),
    '40168f': (29, 29),
    '4016ac': (29, 29),
    '4016c9': (29, 29),
    '4016e6': (29, 29),
    '401703': (29, 29),
    '401720': (29, 29),
    '40173d': (29, 29),
    '40175a': (29, 29),
    '401777': (29, 29),
    '401794': (29, 29),
    '4017b1': (29, 29),
    '4017ce': (29, 29),
    '4017eb': (29, 29),
    '401808': (29, 29),
    '401825': (29, 29),
    '401842': (29, 29),
    '40185f': (29, 29),
    '40187c': (29, 29),
    '401899': (29, 29),
    '4018b6': (29, 29),
    '4018d3': (29, 29),
    '4018f0': (29, 29),
    '40190d': (29, 29),
    '40192a': (29, 29),
    '401947': (29, 29),
    '401964': (29, 29),
    '401981': (29, 29),
    '40199e': (29, 29),
    '4019bb': (29, 29),
    '4019d8': (29, 29),
    '4019f5': (29, 29),
    '401a12': (29, 29),
    '401a2f': (29, 29),
    '401a4c': (29, 29),
    '401a69': (29, 29),
    '401a86': (29, 29),
    '401aa3': (29, 29),
    '401ac0': (29, 29),
    '401add': (29, 29),
    '401afa': (29, 29),
    '401b17': (29, 29),
    '401b34': (29, 29),
    '401b51': (29, 29),
    '401b6e': (29, 29),
    '401b8b': (29, 29),
    '401ba8': (29, 29),
    '401bc5': (29, 29),
    '401be2': (29, 29),
    '401bff': (29, 29),
    '404af0': (28, 28),
    '41458b': (28, 28),
    '414ccf': (28, 28),
    '437710': (31, 31),
    '43eb59': (28, 28),
    '445df0': (31, 31),
    '445e0f': (28, 28),
    '447d10': (31, 31),
    '447d2f': (28, 28),
    '447e46': (28, 28),
    '448820': (31, 31),
    '449a78': (28, 28),
    '44afd6': (28, 28),
    '44d0eb': (28, 28),
    '44e74b': (28, 28),
    '44f650': (31, 31),
    '44f66f': (28, 28),
    '454d6e': (28, 28),
    '456ceb': (28, 28),
    '457f5e': (28, 28),
    '459ace': (28, 28),
    '45b3ce': (28, 28),
    '45dc6e': (28, 28),
    '46180b': (28, 28),
    '463ffe': (28, 28),
    '465aeb': (28, 28),
    '4674e0': (31, 31),
    '468e3e': (28, 28),
    '46b56e': (28, 28),
    '470d5e': (28, 28),
    '4757be': (28, 28),
    '4781de': (28, 28),
    '47b21f': (28, 28),
    '47d4db': (28, 28),
    '47e23e': (28, 28),
    '48215e': (28, 28),
    '483f4e': (28, 28),
    '487afe': (28, 28),
    '488d89': (28, 28),
    '48a6ee': (28, 28),
    '48bafb': (28, 28),
    '48d04b': (28, 28),
    '48e26e': (28, 28),
    '4a1c2b': (28, 28),
    '4a376e': (28, 28),
    '4a636e': (28, 28),
    '4a7c5e': (28, 28),
    '4a9f0b': (28, 28),
    '4ab38b': (28, 28),
    '4ac8be': (28, 28),
    '4afd1e': (28, 28),
    '4b3c3e': (28, 28),
    '4b5b6e': (28, 28),
    '4b71db': (28, 28),
    '4b7f00': (31, 31),
    '4b7f1f': (28, 28),
    '4b9e00': (31, 31),
    '4b9e1f': (28, 28),
    '4bed99': (28, 28),
    '4bf600': (31, 31),
    '4bf61f': (28, 28),
    '4caed0': (31, 31),
    '4cc946': (28, 28),
    '4ccd8f': (28, 28),
    '4d3b6e': (28, 28),
    '4d5260': (31, 31),
    '4d527f': (28, 28),
    '4d58b0': (31, 31),
    '4d58cf': (28, 28),
    '4db260': (31, 31),
    '4db27f': (28, 28),
    '4dd3b0': (31, 31),
    '4dd3cf': (28, 28),
    '4e1c83': (28, 28),
    '4ee980': (31, 31),
    '4ee99f': (28, 28),
    '4f0000': (31, 31),
    '4f001f': (28, 28),
    '4fa9e7': (28, 28),
}

ROWS = {
    '401032': ('ctor', {'vtbl': 5416400, 'callee': 5379926}),
    '4014f5': ('ctor', {'vtbl': 5417840, 'callee': 5380330}),
    '40168f': ('setg', {'addr': 5673272, 'imm': 0, 'callee': 4199718}),
    '4016ac': ('setg', {'addr': 5673272, 'imm': 1, 'callee': 4199718}),
    '4016c9': ('setg', {'addr': 5673272, 'imm': 2, 'callee': 4199718}),
    '4016e6': ('setg', {'addr': 5673272, 'imm': 3, 'callee': 4199718}),
    '401703': ('setg', {'addr': 5673272, 'imm': 4, 'callee': 4199718}),
    '401720': ('setg', {'addr': 5673272, 'imm': 5, 'callee': 4199718}),
    '40173d': ('setg', {'addr': 5673272, 'imm': 6, 'callee': 4199718}),
    '40175a': ('setg', {'addr': 5673272, 'imm': 7, 'callee': 4199718}),
    '401777': ('setg', {'addr': 5673272, 'imm': 8, 'callee': 4199718}),
    '401794': ('setg', {'addr': 5673272, 'imm': 9, 'callee': 4199718}),
    '4017b1': ('setg', {'addr': 5673272, 'imm': 10, 'callee': 4199718}),
    '4017ce': ('setg', {'addr': 5673272, 'imm': 11, 'callee': 4199718}),
    '4017eb': ('setg', {'addr': 5673272, 'imm': 12, 'callee': 4199718}),
    '401808': ('setg', {'addr': 5673272, 'imm': 13, 'callee': 4199718}),
    '401825': ('setg', {'addr': 5673272, 'imm': 14, 'callee': 4199718}),
    '401842': ('setg', {'addr': 5673272, 'imm': 15, 'callee': 4199718}),
    '40185f': ('setg', {'addr': 5673272, 'imm': 16, 'callee': 4199718}),
    '40187c': ('setg', {'addr': 5673272, 'imm': 17, 'callee': 4199718}),
    '401899': ('setg', {'addr': 5673272, 'imm': 18, 'callee': 4199718}),
    '4018b6': ('setg', {'addr': 5673272, 'imm': 19, 'callee': 4199718}),
    '4018d3': ('setg', {'addr': 5673272, 'imm': 20, 'callee': 4199718}),
    '4018f0': ('setg', {'addr': 5673272, 'imm': 21, 'callee': 4199718}),
    '40190d': ('setg', {'addr': 5673272, 'imm': 22, 'callee': 4199718}),
    '40192a': ('setg', {'addr': 5673272, 'imm': 23, 'callee': 4199718}),
    '401947': ('setg', {'addr': 5673272, 'imm': 24, 'callee': 4199718}),
    '401964': ('setg', {'addr': 5673272, 'imm': 25, 'callee': 4199718}),
    '401981': ('setg', {'addr': 5673272, 'imm': 26, 'callee': 4199718}),
    '40199e': ('setg', {'addr': 5673272, 'imm': 27, 'callee': 4199718}),
    '4019bb': ('setg', {'addr': 5673272, 'imm': 28, 'callee': 4199718}),
    '4019d8': ('setg', {'addr': 5673272, 'imm': 29, 'callee': 4199718}),
    '4019f5': ('setg', {'addr': 5673272, 'imm': 30, 'callee': 4199718}),
    '401a12': ('setg', {'addr': 5673272, 'imm': 31, 'callee': 4199718}),
    '401a2f': ('setg', {'addr': 5673272, 'imm': 32, 'callee': 4199718}),
    '401a4c': ('setg', {'addr': 5673272, 'imm': 33, 'callee': 4199718}),
    '401a69': ('setg', {'addr': 5673272, 'imm': 34, 'callee': 4199718}),
    '401a86': ('setg', {'addr': 5673272, 'imm': 35, 'callee': 4199718}),
    '401aa3': ('setg', {'addr': 5673272, 'imm': 36, 'callee': 4199718}),
    '401ac0': ('setg', {'addr': 5673272, 'imm': 37, 'callee': 4199718}),
    '401add': ('setg', {'addr': 5673272, 'imm': 38, 'callee': 4199718}),
    '401afa': ('setg', {'addr': 5673272, 'imm': 39, 'callee': 4199718}),
    '401b17': ('setg', {'addr': 5673272, 'imm': 40, 'callee': 4199718}),
    '401b34': ('setg', {'addr': 5673272, 'imm': 41, 'callee': 4199718}),
    '401b51': ('setg', {'addr': 5673272, 'imm': 42, 'callee': 4199718}),
    '401b6e': ('setg', {'addr': 5673272, 'imm': 43, 'callee': 4199718}),
    '401b8b': ('setg', {'addr': 5673272, 'imm': 44, 'callee': 4199718}),
    '401ba8': ('setg', {'addr': 5673272, 'imm': 45, 'callee': 4199718}),
    '401bc5': ('setg', {'addr': 5673272, 'imm': 46, 'callee': 4199718}),
    '401be2': ('setg', {'addr': 5673272, 'imm': 47, 'callee': 4199718}),
    '401bff': ('setg', {'addr': 5673272, 'imm': 48, 'callee': 4199718}),
    '404af0': ('ctor', {'vtbl': 5421624, 'callee': 5380330}),
    '41458b': ('ctor', {'vtbl': 5424368, 'callee': 5363504}),
    '414ccf': ('ctor', {'vtbl': 5424448, 'callee': 5363504}),
    '437710': ('ctorret', {'vtbl': 5425084, 'callee': 4421443}),
    '43eb59': ('ctor', {'vtbl': 5425408, 'callee': 5384356}),
    '445df0': ('ctorret', {'vtbl': 5425692, 'callee': 4480555}),
    '445e0f': ('ctor', {'vtbl': 5425692, 'callee': 4480832}),
    '447d10': ('ctorret', {'vtbl': 5425864, 'callee': 4488523}),
    '447d2f': ('ctor', {'vtbl': 5425864, 'callee': 4488544}),
    '447e46': ('ctor', {'vtbl': 5425928, 'callee': 5363504}),
    '448820': ('ctorret', {'vtbl': 5426008, 'callee': 4491347}),
    '449a78': ('ctor', {'vtbl': 5426012, 'callee': 4496020}),
    '44afd6': ('ctor', {'vtbl': 5426072, 'callee': 5363504}),
    '44d0eb': ('ctor', {'vtbl': 5426232, 'callee': 5363504}),
    '44e74b': ('ctor', {'vtbl': 5426368, 'callee': 5363504}),
    '44f650': ('ctorret', {'vtbl': 5426448, 'callee': 4519563}),
    '44f66f': ('ctor', {'vtbl': 5426448, 'callee': 4520342}),
    '454d6e': ('ctor', {'vtbl': 5426512, 'callee': 5363504}),
    '456ceb': ('ctor', {'vtbl': 5426648, 'callee': 5363504}),
    '457f5e': ('ctor', {'vtbl': 5426784, 'callee': 5363504}),
    '459ace': ('ctor', {'vtbl': 5426920, 'callee': 5363504}),
    '45b3ce': ('ctor', {'vtbl': 5427056, 'callee': 5363504}),
    '45dc6e': ('ctor', {'vtbl': 5427192, 'callee': 5363504}),
    '46180b': ('ctor', {'vtbl': 5427328, 'callee': 5363504}),
    '463ffe': ('ctor', {'vtbl': 5427464, 'callee': 5363504}),
    '465aeb': ('ctor', {'vtbl': 5427600, 'callee': 5363504}),
    '4674e0': ('ctorret', {'vtbl': 5427680, 'callee': 4617491}),
    '468e3e': ('ctor', {'vtbl': 5427744, 'callee': 5363504}),
    '46b56e': ('ctor', {'vtbl': 5427944, 'callee': 5363504}),
    '470d5e': ('ctor', {'vtbl': 5428216, 'callee': 5363504}),
    '4757be': ('ctor', {'vtbl': 5428368, 'callee': 5363504}),
    '4781de': ('ctor', {'vtbl': 5428504, 'callee': 5363504}),
    '47b21f': ('ctor', {'vtbl': 5428584, 'callee': 4698913}),
    '47d4db': ('ctor', {'vtbl': 5428648, 'callee': 5363504}),
    '47e23e': ('ctor', {'vtbl': 5428784, 'callee': 5363504}),
    '48215e': ('ctor', {'vtbl': 5428920, 'callee': 5363504}),
    '483f4e': ('ctor', {'vtbl': 5429056, 'callee': 5363504}),
    '487afe': ('ctor', {'vtbl': 5429192, 'callee': 5363504}),
    '488d89': ('ctor', {'vtbl': 5429328, 'callee': 5363504}),
    '48a6ee': ('ctor', {'vtbl': 5429464, 'callee': 5363504}),
    '48bafb': ('ctor', {'vtbl': 5429600, 'callee': 5363504}),
    '48d04b': ('ctor', {'vtbl': 5429736, 'callee': 5363504}),
    '48e26e': ('ctor', {'vtbl': 5429872, 'callee': 5363504}),
    '4a1c2b': ('ctor', {'vtbl': 5430360, 'callee': 5363504}),
    '4a376e': ('ctor', {'vtbl': 5430496, 'callee': 5363504}),
    '4a636e': ('ctor', {'vtbl': 5430632, 'callee': 5363504}),
    '4a7c5e': ('ctor', {'vtbl': 5430768, 'callee': 5363504}),
    '4a9f0b': ('ctor', {'vtbl': 5430904, 'callee': 5363504}),
    '4ab38b': ('ctor', {'vtbl': 5431040, 'callee': 5363504}),
    '4ac8be': ('ctor', {'vtbl': 5431176, 'callee': 5363504}),
    '4afd1e': ('ctor', {'vtbl': 5431312, 'callee': 5363504}),
    '4b3c3e': ('ctor', {'vtbl': 5431448, 'callee': 5363504}),
    '4b5b6e': ('ctor', {'vtbl': 5431584, 'callee': 5363504}),
    '4b71db': ('ctor', {'vtbl': 5431720, 'callee': 5363504}),
    '4b7f00': ('ctorret', {'vtbl': 5431800, 'callee': 4947771}),
    '4b7f1f': ('ctor', {'vtbl': 5431800, 'callee': 4947956}),
    '4b9e00': ('ctorret', {'vtbl': 5431808, 'callee': 4955707}),
    '4b9e1f': ('ctor', {'vtbl': 5431808, 'callee': 4956287}),
    '4bed99': ('ctor', {'vtbl': 5431824, 'callee': 4976103}),
    '4bf600': ('ctorret', {'vtbl': 5431828, 'callee': 4978235}),
    '4bf61f': ('ctor', {'vtbl': 5431828, 'callee': 4978855}),
    '4caed0': ('ctorret', {'vtbl': 5431868, 'callee': 5025539}),
    '4cc946': ('ctor', {'vtbl': 5431928, 'callee': 5363504}),
    '4ccd8f': ('ctor', {'vtbl': 5432016, 'callee': 5034520}),
    '4d3b6e': ('ctor', {'vtbl': 5432080, 'callee': 5363504}),
    '4d5260': ('ctorret', {'vtbl': 5432400, 'callee': 5067419}),
    '4d527f': ('ctor', {'vtbl': 5432400, 'callee': 5067430}),
    '4d58b0': ('ctorret', {'vtbl': 5432404, 'callee': 5069035}),
    '4d58cf': ('ctor', {'vtbl': 5432404, 'callee': 5069652}),
    '4db260': ('ctorret', {'vtbl': 5432408, 'callee': 5091995}),
    '4db27f': ('ctor', {'vtbl': 5432408, 'callee': 5092215}),
    '4dd3b0': ('ctorret', {'vtbl': 5432520, 'callee': 5100523}),
    '4dd3cf': ('ctor', {'vtbl': 5432520, 'callee': 5100534}),
    '4e1c83': ('ctor', {'vtbl': 5432552, 'callee': 5119284}),
    '4ee980': ('ctorret', {'vtbl': 5432576, 'callee': 5171643}),
    '4ee99f': ('ctor', {'vtbl': 5432576, 'callee': 5171920}),
    '4f0000': ('ctorret', {'vtbl': 5432580, 'callee': 5177403}),
    '4f001f': ('ctor', {'vtbl': 5432580, 'callee': 5177414}),
    '4fa9e7': ('ctor', {'vtbl': 5432600, 'callee': 5221712}),
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
