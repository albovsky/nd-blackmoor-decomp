"""FL-26 (batch b, the 0x62 interaction path): the fixtures shared by tests/test_fl26b_differential.py and tests/fl26b_original_oracle.py.

`build(key, rng, n)` makes scenario n of one of the functions of SPECS: the memory areas (objects, nodes, the record table at 0x5bb5e5, tables), the
scripted callees and the globals. The scenarios cycle through profiles (each guard failing in turn, then every arm and loop exit of the function), and the
optional parts vary from one pass of the cycle to the next; random bytes fill everything else.

`run_original(sc)` runs ONLY the original bytes (Unicorn) on a scenario: the callees (SHAPES) are recording stubs (host boundaries); nothing inside the
function under test is patched. A stub at the entry of the function under test (0x424201 calls itself) is skipped for the outermost entry only, so the
recursion is a recorded host call. It returns the result, the normalised ordered call log and a digest of the ordered calls, the return value and
the memory read back.
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
TICK_SLOT = 0x52a23c
LOCAL = 'L'
CTYPES = {'uint8_t': ctypes.c_uint8, 'int16_t': ctypes.c_int16, 'uint16_t': ctypes.c_uint16, 'int32_t': ctypes.c_int32, 'uint32_t': ctypes.c_uint32}


def parse_world():
    """The fields of Fl26bWorld, from the header, as [(name, ctype, is_pointer)]."""
    text = (PROJECT / 'src/original_methods_fl26b.h').read_text()
    body = re.search(r'typedef struct Fl26bWorld \{(.*?)\} Fl26bWorld;', text, re.S).group(1)
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

    def _count(self, uc, address, size, user):
        """Records the executed instructions as od.Original does, and every (previous instruction, next instruction) pair of them: after a
        conditional jump the next address says which way it went. A stub entered in between does not break the pair (the call returns to
        the next instruction of the function)."""
        super()._count(uc, address, size, user)
        if not hasattr(self, 'edges'):
            self.edges = set()
        if getattr(self, 'last', None) is not None:
            self.edges.add((self.last, address))
        self.last = address

    def _stub_hook(self, uc, address, size, user):
        if address == getattr(self, 'entry', None) and struct.unpack('<I', uc.mem_read(uc.reg_read(self._r['ESP']), 4))[0] == od.STOP:
            return      # the entry of the function under test itself (the outermost call), not a recursive call
        stub = self.stubs[address]
        probe = getattr(stub, 'probe_addr', None)
        before = len(self.calls)
        data = b''.join(bytes(uc.mem_read(a, n)) for a, n in probe) if probe else None
        derefs = getattr(stub, 'derefs', None)
        deref_data = ()
        if derefs:
            esp = uc.reg_read(self._r['ESP'])
            deref_data = tuple(bytes(uc.mem_read(struct.unpack('<I', uc.mem_read(esp + 4 + 4 * arg, 4))[0], n)) for arg, n in derefs)
        super()._stub_hook(uc, address, size, user)
        if deref_data:
            self.calls[before] = self.calls[before] + deref_data
        if data is not None:
            self.calls[before] = self.calls[before] + (data,)


# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
# the recording stubs of the callees (entered by address): (stack arguments, thiscall, bytes the callee pops)
SHAPES = {0x4e9e84: (2, True, 8), 0x4d36ed: (0, False, 0), 0x424346: (1, True, 4), 0x42406d: (1, True, 4), 0x42356d: (2, True, 8),
          0x424201: (1, True, 4), 0x4235fd: (0, True, 0), 0x50ca3e: (2, False, 0), 0x52139c: (3, False, 12), 0x44a2b7: (1, False, 0),
          0x4c97b4: (0, True, 0), 0x42ba3a: (1, False, 0), 0x50cd50: (0, False, 0), 0x4f6334: (1, True, 4), 0x4fb77a: (1, True, 4), 0x423259: (1, True, 4),
          0x448d11: (4, True, 0x10), 0x4fb2e3: (1, True, 4)}
WORD_ARGS = {}
RECORDS_VA = 0x5bb5e5
REC = 0x8d
FLAGS_VA = 0x585801




def stub(callee, probe, results=None):
    nargs, this, cleanup = SHAPES[callee]
    s = od.Stub(callee, args=nargs, this=this, cleanup=cleanup, results=results)
    s.probe = probe
    return s


# ---- fixture helpers ------------------------------------------------------------------------------------------------------------


def put32(d, off, v):
    struct.pack_into('<I', d, off, v & 0xffffffff)


def put16(d, off, v):
    struct.pack_into('<H', d, off, v & 0xffff)


def prof(n, profiles):
    """(profile, pass number) of scenario n: the profiles cycle, the optional parts vary with the pass number."""
    return profiles[n % len(profiles)], n // len(profiles)



def common26(key, areas, stubs, probes, g=None, pointers=None, stack=(), args=(0,), profile=None):
    """Assembles a scenario: the areas, the recording stubs (each logs the `probes` bytes as they are at the call), the globals, the
    pointers of the native world (field -> (area name, offset)), the stack arguments of the original and the arguments of the native call."""
    sp = SPECS[key]
    for s in stubs.values():
        s.probe = list(probes)
    return SimpleNamespace(key=key, fn=sp['id'], va=sp['va'], size=sp['size'], areas=areas, stubs=stubs, iat={}, g=g or {}, ecx=od.region_va(0),
                           pointers=pointers or {}, word_args=WORD_ARGS, tick=None, profile=profile, stack=list(stack), args=tuple(args) + (0,) * (2 - len(args)))




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
    for x in sc.stubs.values():
        x.probe_addr = [(next(a.va for a in sc.areas if a.name == name) + off, ln) for name, off, ln in x.probe]
    runner = Original20(image_patches, regions, sc.stubs, sc.iat)
    runner.entry = sc.va
    orig = runner.run(sc.va, sc.size, ecx=sc.ecx, stack_args=sc.stack, read=read)
    orig.edges = getattr(runner, 'edges', set())      # (address, next address) of the instructions executed in a row
    if orig.cleanup != SPECS[sc.key].get('cleanup', 0):
        raise AssertionError('the function popped %d bytes' % orig.cleanup)
    calls = normalize(orig.calls, sc.stubs, sc.iat, sc.word_args)
    h = hashlib.sha256()
    h.update(repr(calls).encode())
    if SPECS[sc.key].get('ret'):
        h.update(struct.pack('<I', orig.eax))
    for name in sorted(orig.memory):
        h.update(name.encode() + orig.memory[name])
    return orig, calls, h.hexdigest()


def conditional_edges(va, size):
    """[(jcc address, mnemonic, taken-edge target, fall-through address)] of every conditional jump of the original function (loop and
    jecxz forms included), by linear disassembly of the code part."""
    import capstone
    pe = od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    off = va - pe.image_base
    out = []
    for i in md.disasm(pe.image[off:off + size], va):
        if i.mnemonic.startswith('j') and i.mnemonic != 'jmp' or i.mnemonic.startswith('loop'):
            out.append((i.address, i.mnemonic, int(i.op_str, 16), i.address + i.size))
    return out


# the conditional-jump directions that no scenario takes, with the reason (anything else untaken fails the tests)
UNTAKEN_ALLOWED = {
    '424201': {(0x424271, 'taken'): 'jne 0x424305 on a node whose kind is neither 2 nor 1 loops back to 0x42421a with nothing changed (p, done, the node and its kind '
                                    'are re-read unchanged): the function never returns, so no terminating run can take it; the native port rejects it'},
}


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
    """(unexpected untaken edges, allowlisted edges that were taken after all, number of directions): both directions of every conditional
    jump of the function must be taken by some scenario, except the ones in UNTAKEN_ALLOWED (an allowlist entry that is taken is stale)."""
    allowed = UNTAKEN_ALLOWED.get(key, {})
    untaken = untaken_edges(key, edges)
    sp = SPECS[key]
    total = 2 * len(conditional_edges(sp['va'], sp.get('code', sp['size'])))
    return [e for e in untaken if e not in allowed], [e for e in allowed if e not in untaken], total


def norm_deref(callee, data):
    """The bytes behind a pointer argument as compared: the native locals are zero, the original's stack is filled with 0x71 (mapped to 0); the text buffer
    of 0x448d11 is a C string, compared up to its NUL (what follows is the original's other locals)."""
    data = bytes(0 if b == 0x71 else b for b in data)
    if callee == 0x448d11 and 0 in data:
        data = data[:data.index(0) + 1]
    return data


def normalize(calls, stubs, iat, word_args):
    """The original's call log as comparable lists: [callee or 'tick', ecx, *args (word arguments by their low 16 bits), probe]."""
    by_name = {s.name: s for s in [*stubs.values(), *iat.values()]}
    out = []
    for call in calls:
        s = by_name[call[0]]
        entry = [call[0], call[1] if s.this else 0]
        rest = list(call[2 if s.this else 1:])
        probe = rest.pop() if getattr(s, 'probe_addr', None) else None
        derefs = [rest.pop() for _ in getattr(s, 'derefs', None) or ()][::-1]
        wa = word_args.get(call[0], ())
        for position, v in enumerate(rest):
            if position in wa:
                entry.append(v & 0xffff)
            else:
                entry.append(LOCAL if od.STACK_BASE <= v < od.STACK_BASE + od.STACK_SIZE else v)
        entry.extend(norm_deref(call[0], d) for d in derefs)
        if probe is not None:
            entry.append(probe)
        out.append(entry)
    return out



# ---- the scenario generators ------------------------------------------------------------------------------------------------------

NZ32 = [1, 0x100, 0x10000, 0x01000000, 0xffffffff]


def gen_423fbb(rng, n):
    profiles = [('zero',)] + [('leaf', w) for w in (0, 1, 2, 0x7fff, 0x8000, 0xffff, 0x1234, -2)] + [('leafhigh',)]
    (kind, *rest), _ = prof(n, profiles)
    node = bytearray(rng.randbytes(0x40))
    leaf = bytearray(rng.randbytes(0x50))
    node_va, leaf_va = od.region_va(1), od.region_va(2)
    put32(node, 0x20, rng.choice(NZ32))
    if kind == 'zero':
        put32(node, 0x1c, 0)
    else:
        put32(node, 0x1c, leaf_va)
        w = rest[0] if kind == 'leaf' else 0x7fff
        put16(leaf, 0x12, w)
        leaf[0x14:0x16] = bytes([rng.choice([0, 0xff, 1]), rng.choice([0, 0x80, 0xff])])      # the bytes after the word (a dword read would see them)
        put32(leaf, 0x40, rng.choice([0, 5, 0xffffffff, rng.randrange(1 << 32)]))
    areas = [Area('self', od.region_va(0), bytearray(0x10), image=False, compare=False), Area('node', node_va, node, image=False),
             Area('leaf', leaf_va, leaf, image=False)]
    return common26('423fbb', areas, {}, [('node', 0, 0x40)], stack=[node_va], args=(node_va,), profile=(kind, *rest))


ITEMS = [-5, -1, 0, 1, 2, 3, 172, 300, 359]
WORD_OTHERS = [1, 3, -1, 0x7fff, -32768, 0x102, 0x100, 0x5]


def gen_4eb107(rng, n):
    profiles = [('miss', how) for how in ('low', 'high', 'sign', 'off1')] + [('w0',), ('w2',)] + [('wo', v) for v in WORD_OTHERS]
    (kind, *rest), variant = prof(n, profiles)
    item = ITEMS[(variant + n) % len(ITEMS)]
    self_ = bytearray(rng.randbytes(0x40000))
    at = item * 0x16d + 0x77e
    arg = item & 0xffffffff
    if kind == 'miss':
        arg = {'low': (item ^ 1) & 0xffffffff, 'high': (item | 0x10000) & 0xffffffff, 'sign': (item & 0xffff) if item < 0 else (item | 0x80000000) & 0xffffffff,
               'off1': (item + 1) & 0xffffffff}[rest[0]]
        w = rng.choice([0, 2, 7])
    else:
        w = 0 if kind == 'w0' else 2 if kind == 'w2' else rest[0]
    put16(self_, at, w)
    self_[at + 2:at + 4] = bytes([rng.choice([0, 1, 0xff]), rng.choice([0, 1, 0x80])])
    stubs = {0x4e9e84: stub(0x4e9e84, None, results=[rng.choice([0, 1, 0x80000000])]), 0x4d36ed: stub(0x4d36ed, None)}
    areas = [Area('self', od.region_va(0), self_, image=False)]
    return common26('4eb107', areas, stubs, [('self', 0, 0x20), ('self', at - 4, 12)], g={'word_583a29': item & 0xffff}, stack=[arg], args=(arg,),
                    profile=(kind, *rest, item))


NODE = 0x48
NODES = 8


def model_42406d(nodes, head):
    """The final count of the nodes with a non-zero flag that 0x42406d compares with [node + 0x18] (fixture helper only: the verdict is the original's)."""
    flags = {i: nodes[i]['flag'] for i in nodes}
    cnt = 0
    p = head
    for _ in range(10000):
        nx, ch = nodes[p]['next'], nodes[p]['ch']
        if ch is not None and nodes[ch]['word'] == 1:
            if flags[p] == 0 and flags[ch] != 0:
                flags[p] = 1
                cnt += 1
            elif flags[p] != 0 and flags[ch] == 0:
                flags[ch] = 1
                cnt += 1
        if nx is not None:
            if nodes[p]['word'] == 1:
                if flags[p] == 0 and flags[nx] != 0:
                    flags[p] = 1
                    cnt += 1
                elif flags[p] != 0 and flags[nx] == 0:
                    flags[nx] = 1
                    cnt += 1
            p = nx
        elif cnt:
            cnt = 0
            p = head
        else:
            break
    q, count = head, 0
    while q is not None:
        count += 1 if flags[q] else 0
        q = nodes[q]['next']
    return count


def gen_42406d(rng, n):
    profiles = [(aux, eq) for aux in (True, False) for eq in (True, False)]
    (aux, eq), variant = prof(n, profiles)
    arg_va, nodes_va = od.region_va(0), od.region_va(1)
    arg = bytearray(rng.randbytes(0x80))
    nd = bytearray(rng.randbytes(NODE * NODES))
    m = rng.choice([1, 1, 2, 3, 4, 5, 6, 8])
    order = rng.sample(range(NODES), m)
    model = {}
    for i in range(NODES):
        base = NODE * i
        flag = rng.choice([0, 0, 1, 0x100, 0x10000, 0x80000000, 0xffffffff])
        word = rng.choice([1, 1, 1, 0, 2, -1, 0x101])
        ch = rng.choice([None, None] + list(range(NODES)))
        put32(nd, base + 4, flag)
        put16(nd, base + 0x16, word)
        put32(nd, base + 0x34, 0 if ch is None else nodes_va + NODE * ch)
        put32(nd, base + 0x38, 0)
        put32(nd, base + 0x44, rng.randrange(1 << 32))
        model[i] = {'flag': flag, 'word': word, 'ch': ch, 'next': None}
    for a, b in zip(order, order[1:]):
        put32(nd, NODE * a + 0x38, nodes_va + NODE * b)
        model[a]['next'] = b
    # nodes of the chain whose link [0x34] leaves the chain are fine: they only get their flag set
    expected = model_42406d(model, order[0])
    put32(arg, 4, nodes_va + NODE * order[0])
    aux_va = arg_va + 0x40 if variant % 2 == 0 else od.region_va(2)       # (the second place has a zero low word: the pointer test is a dword test)
    put32(arg, 0xc, aux_va if aux else 0)
    put32(arg, 0x18, expected if eq else (expected + rng.choice([1, 2, 0x10000, 0xffffffff])) & 0xffffffff)
    put32(arg, 0, rng.choice([0, 1, 0x100, 0xffffffff]))
    areas = [Area('self', arg_va, arg, image=False), Area('nodes', nodes_va, nd, image=False), Area('aux', od.region_va(2), bytearray(rng.randbytes(0x40)), image=False)]
    return common26('42406d', areas, {}, [('self', 0, 0x80)], stack=[arg_va], args=(arg_va,), profile=(aux, eq, m))


def gen_424201(rng, n):
    profiles = [('t2end',)] + [('t2chain', k) for k in (2, 3)] + [('t1', 'rzero'), ('t1', 'rzero'), ('t1', 'rnext2'), ('t1', 'rnext1'), ('t1', 'rnext1b'),
                                                                   ('err', 0), ('err', 1), ('err', 0x100), ('err', -1), ('err', -32768)]
    profiles += [('mix', s) for s in range(14)]
    (kind, *rest), variant = prof(n, profiles)
    arg_va, nodes_va, qs_va = od.region_va(0), od.region_va(1), od.region_va(2)
    arg = bytearray(rng.randbytes(0x40))
    nd = bytearray(rng.randbytes(NODE * NODES))
    qs = bytearray(rng.randbytes(0x80))
    na = lambda i: nodes_va + NODE * i
    kinds = [rng.choice([1, 2]) for _ in range(NODES)]
    nxt = [0] * NODES
    results = []
    word63 = rng.choice([0, 1, 0x100, -1])
    first = 0
    if kind == 't2end':
        kinds[0] = 2
    elif kind == 't2chain':
        for i in range(rest[0]):
            kinds[i] = 2
            nxt[i] = na(i + 1) if i + 1 < rest[0] else 0
    elif kind == 't1':
        kinds[0] = 1
        results = [qs_va]
        put32(qs, 0, 0x22220000 + rng.randrange(0x1000))                # q[0]: the new node argument
        put32(qs, 8, na(5))                                             # q[8]: the node r
        if rest[0] == 'rzero':
            nxt[5] = 0
        elif rest[0] == 'rnext2':
            nxt[5], kinds[6], nxt[6] = na(6), 2, 0
        elif rest[0] == 'rnext1':
            nxt[5], kinds[6], nxt[6] = na(6), 1, 0
            results = [qs_va, qs_va + 0x20]
            put32(qs, 0x20, 0x33330000 + rng.randrange(0x1000))
            put32(qs, 0x28, na(7))
            nxt[7] = 0
        else:
            nxt[5], kinds[6], nxt[6] = na(6), 1, na(7)
            kinds[7], nxt[7] = 2, 0
            results = [qs_va, 0]
    elif kind == 'err':
        kinds[0] = 1
        results = [0]
        word63 = rest[0]
    else:   # mix: random kinds, forward-only links, a random script that ends in a zero result
        rr = random_for(rest[0], variant)
        for i in range(NODES):
            kinds[i] = rr.choice([1, 2])
            nxt[i] = na(rr.randrange(i + 1, NODES)) if i + 1 < NODES and rr.random() < 0.7 else 0
        for j in range(3):
            put32(qs, 0x20 * j, rr.randrange(1 << 32))
            put32(qs, 0x20 * j + 8, na(rr.randrange(NODES)))
        results = [qs_va + 0x20 * rr.randrange(3) for _ in range(rr.randrange(0, 4))] + [0]
        word63 = rr.choice([0, 1, -1])
    for i in range(NODES):
        base = NODE * i
        put32(nd, base, kinds[i])
        put32(nd, base + 4, rng.choice([0, 5, 0xffffffff, rng.randrange(1 << 32)]))
        put32(nd, base + 0x38, nxt[i])
        put32(nd, base + 0x44, rng.choice([0, nodes_va + 8, rng.randrange(1 << 32)]))
    put32(arg, 4, na(first))
    stubs = {c: stub(c, None) for c in (0x424346, 0x42406d, 0x42356d, 0x424201, 0x50ca3e, 0x52139c, 0x44a2b7, 0x4c97b4)}
    stubs[0x4235fd] = stub(0x4235fd, None, results=results or [0])
    areas = [Area('self', arg_va, arg, image=False), Area('nodes', nodes_va, nd, image=False), Area('qs', qs_va, qs, image=False)]
    return common26('424201', areas, stubs, [('self', 0, 0x40), ('nodes', 0, NODE * NODES), ('qs', 0, 0x80)], g={'word_63a4cd': word63}, stack=[arg_va],
                    args=(arg_va,), profile=(kind, *rest))


def random_for(seed, variant):
    import random
    return random.Random(seed * 1000 + variant)


def gen_42ea87(rng, n):
    kinds = [0x63, 0x00, 0x62, 0xff]
    profiles = [('s', s, k) for s in (0, 1, 2, 3, 0xffffffff, 0x100, 0x10000) for k in range(len(kinds))]
    profiles += [('l', s, k, c) for s in (0, 1) for k in (0, 1) for c in ('none', 'hit0', 'hit1', 'hit2', 'miss', 'neg', 'zero', 'max')]
    profiles += [('t', k, w8, flag) for k in (0, 1) for w8 in (0x22, 0x23, 0x7fff, -32768, -1, 0, 0x21, 0x24) for flag in ('a', 'b')]
    (kind, *rest), variant = prof(n, profiles)
    idx = rng.choice([-1, 0, 1, 2, 3, 4])
    obj_va, decoy_va = od.region_va(1), od.region_va(4)
    state, kidx = (rest[0], rest[1]) if kind in ('s', 'l') else (2, rest[0])
    kcode = kinds[kidx]
    is63 = kcode == 0x63
    rec = bytearray(rng.randbytes(6 * REC + 8))
    for i in range(-1, 5):
        base = (i + 1) * REC + 8      # (the area starts above the global 0x5bb50b)
        put32(rec, base, obj_va if i == idx else decoy_va)
        put32(rec, base + 0x4d, state if i == idx else rng.choice([0, 1, 2, 3]))
        rec[base - 2] = kcode if i == idx else rng.choice([0x63, 0, 1])
    obj = bytearray(rng.randbytes(0x400))
    key = rng.choice([0, 1, -1, 0x7fff, -32768, 0x1234, 7])
    flags_before = bytearray(rng.randbytes(0x200))
    if state in (0, 1):
        list_off = 0x2a if is63 else 0xa
        c = rest[2] if kind == 'l' else rng.choice(['none', 'hit0', 'hit1', 'hit2', 'miss'])
        count = {'none': 0, 'hit0': 3, 'hit1': 3, 'hit2': 3, 'miss': 3, 'neg': -1, 'zero': 0, 'max': 3}[c]
        put16(obj, list_off, count)
        for j in range(4):
            e = list_off + j * 0x12
            put16(obj, e + 2, key ^ 1 if key != 0x7fff else 3)
            for q in (4, 8, 0xc, 0x10):
                put16(obj, e + q, rng.choice([0, 1, -1, 0x7fff, -32768, rng.randrange(0x10000)]))
        if c.startswith('hit'):
            put16(obj, list_off + int(c[3]) * 0x12 + 2, key)
            if int(c[3]) > 0 and variant % 2:
                put16(obj, list_off + 2, key)          # an earlier entry also matches: the first one wins
        if c == 'max':
            put16(obj, list_off, 4)
        if c == 'miss' and variant % 2:
            put16(obj, list_off + 3 * 0x12 + 2, key)   # the entry just after the count does not count
    elif state == 2:
        w8 = rest[1] if kind == 't' else rng.choice([0x22, 0x23, -1])
        put16(obj, 0x28 if is63 else 8, w8)
        for k in range(10):
            a = rng.choice([-1, -1, 0, 1, 5, 17, 38, -3, -8, 40])
            if kind == 't' and rest[2] == 'b':
                a = -1 if k % 2 == 0 else rng.choice([0, 3, -2])
            put16(obj, 4 * k, a)
            put16(obj, 4 * k + 2, rng.choice([0, 1, -1, 0x7fff, -32768, rng.randrange(0x10000)]))
    else:
        put16(obj, 0x28 if is63 else 8, rng.choice([0, 0x23, -1]))
    garbage = rng.randrange(0x10000)
    stubs = {0x42ba3a: stub(0x42ba3a, None)}
    areas = [Area('self', od.region_va(0), bytearray(0x10), image=False, compare=False), Area('records', RECORDS_VA - REC - 8, rec), Area('obj', obj_va, obj, image=False), Area('decoy', od.region_va(4), bytearray(rng.randbytes(0x1000)), image=False, compare=False),
             Area('flags', FLAGS_VA - 0x40, flags_before)]
    g = {'value_5bb1ca': rng.choice([0, 0x55, 0xffffffff]), 'word_5bb50b': key & 0xffff}
    ptrs = {'records_5bb5e5': ('records', REC + 8), 'flags_585801': ('flags', 0x40)}
    word = ((garbage << 16) | (idx & 0xffff)) & 0xffffffff
    return common26('42ea87', areas, stubs, [('records', 0, 6 * REC + 8), ('flags', 0, 0x200), ('obj', 0, 0x100)], g=g, pointers=ptrs, stack=[word], args=(word,),
                    profile=(kind, *rest))


LETTERS = b'abcdefghijklmnoprstuvwxyz0123456789'      # no 0x71 ('q'): the harness maps the stack fill 0x71 of the original to 0 when it compares


def letters(rng, n):
    return bytes(rng.choice(LETTERS) for _ in range(n))


def hi_bytes(rng, n):
    return bytes(rng.randrange(0x80, 0x100) for _ in range(n))


def gen_4eb184(rng, n):
    s5s = [(0, '-'), (1, 'none'), (1, 'short'), (1, 'long')]
    profiles = [('neg', v) for v in (-1, -5, -2147483648)] + [('busy', f) for f in (0, 1)]
    profiles += [('f0', jm, arm, s5, sm) for jm in ('j1_9', 'j1_1', 'j2_9', 'j2_1', 'j3') for arm in ('r9', 'r1') for s5, sm in s5s[:1]]
    profiles += [('f0', jm, 'copy', s5, sm) for jm in ('j1_9', 'j1_1', 'j2_9', 'j2_1', 'j3') for s5, sm in s5s]
    profiles += [('f1', 'b9')] + [('f1', 'copy', s5, sm) for s5, sm in s5s]
    (kind, *rest), variant = prof(n, profiles)
    nn = -1 if kind == 'neg' else rng.choice([0, 1, 2, 3])
    if kind == 'neg':
        nn = rest[0]
    rn = max(nn, 0)
    flag0 = kind == 'busy' and rest[0] == 0 or kind == 'f0' or kind == 'neg' and rng.random() < 0.5
    flag1 = kind == 'f1' or kind == 'busy' and rest[0] == 1
    self_ = bytearray(rng.randbytes(0x9000))
    recs = bytearray(rng.randbytes(5 * 0x6e + 0x80))
    consts = bytearray(rng.randbytes(0x30))
    A, B, C = hi_bytes(rng, 9), hi_bytes(rng, 9), hi_bytes(rng, 9)
    c1, d = hi_bytes(rng, 1), hi_bytes(rng, 1)
    while d == c1:
        d = hi_bytes(rng, 1)
    consts[0:9], consts[0xc:0x15], consts[0x18:0x21] = A, B, C
    consts2 = bytearray(rng.randbytes(8))
    consts2[0:1], consts2[4:5] = c1, d
    recs[rn * 0x6e] = 0 if flag0 else rng.choice([1, 0x80, 0xff])
    strarea = bytearray(rng.randbytes(0x200))

    def row(j):
        return rn * 0x16d + 0x74e + j * 0x5d + 0x56

    # the structured rows -2 .. 3: a string of 9 .. 0x33 characters; the string at +0x21 ends L2 characters after it
    for j in range(-2, 4):
        o = row(j)
        len0 = rng.choice([9, 12, 0x20, 0x21, 0x25, 0x33, 0x34, 0x35, 0x37])
        self_[o:o + 0x5d] = letters(rng, 0x5d)
        self_[o + len0] = 0
        if len0 <= 0x20:
            self_[o + 0x21 + rng.choice([0, 1, 7, 0x20, 0x38])] = 0

    def mismatch(o, const, first):
        """The first nine bytes of the row at o are not `const` (and its first byte is not `first`), differing at byte k and equal before."""
        k = rng.randrange(9)
        self_[o:o + k] = const[:k]
        self_[o + k] = rng.choice(LETTERS)
        if k == 0:
            pass

    for j in (-2, -1, 0, 3):
        pass
    j_final = 3
    idx = 0
    tail = 0x38 if flag0 else 0      # the longest string that can reach the buffer from the rows (see the tail below)
    if flag0:
        jm = rest[0] if kind == 'f0' else 'j1_9'
        m = {'j1_9': 1, 'j1_1': 1, 'j2_9': 2, 'j2_1': 2, 'j3': None}[jm]
        for j in (1, 2):
            o = row(j)
            if m is not None and j == m:
                if jm.endswith('9'):
                    self_[o:o + 9] = A
                else:
                    mismatch(o, A, c1)
                    self_[o] = c1[0]
                    self_[o + 1] = rng.choice(LETTERS)      # (the nine bytes cannot all be equal: A[1] is not a letter)
            elif m is None or j < m:
                mismatch(o, A, c1)
                if self_[o] == c1[0]:
                    self_[o] = rng.choice(LETTERS)
        j_final = m if m is not None else 3
        arm = rest[1] if kind == 'f0' else 'copy'
        want = 0 if arm in ('r9', 'r1') else rng.randrange(j_final)
        sign = -1 if (variant % 3 == 2 and kind == 'f0') else 1
        r = sign * (want + j_final * rng.randrange(0, 4))
        idx = (sign * want)
        orow = row(idx)
        if arm == 'r9':
            self_[orow:orow + 9] = C
        elif arm == 'r1':
            self_[orow] = d[0]
            self_[orow + 1] = rng.choice(LETTERS)
        else:
            # the first nine bytes differ from C and the first byte from d
            if idx not in (1, 2):
                mismatch(orow, C, d)
                if self_[orow] == d[0]:
                    self_[orow] = rng.choice(LETTERS)
        rand_result = r
        if arm == 'copy' and idx < 0 and variant % 2 == 0:
            # the string at row + 0x21 is long (it runs over the following rows, not over the loop rows 1 and 2): the copy into the buffer then
            # runs over the dead locals of the original's frame
            T = rng.choice([0x39, 0x3c, 0x3d, 0x50, 0x70, 0x78])
            tail = T
            o = orow
            self_[o + 9:o + 0x21 + T] = letters(rng, 0x21 + T - 9)
            self_[o + rng.choice([0x10, 0x20])] = 0
            self_[o + 0x21 + T] = 0
    else:
        rand_result = 0
        arm = 'copy'
    s5, sm = (rest[2], rest[3]) if kind == 'f0' and rest[1] == 'copy' else (rest[1], rest[2]) if kind == 'f1' and rest[0] == 'copy' else (rng.choice([0, 1]), rng.choice(['none', 'short', 'long']))
    # the record string (flag set): nothing of the first nine bytes equal to B (b9: equal)
    L = rng.choice([0, 1, 5, 8, 9, 20, 0x30, 0x38, 0x39, 0x3b, 0x3c, 0x60, 0x78, 0x79, 0x7b])
    so = rn * 0x6e + 0x3d
    recs[so:so + L + 1] = letters(rng, L) + b'\0'
    if kind == 'f1' and rest[0] == 'b9':
        recs[so:so + 9] = B
        recs[so + 9] = 0
    # the translated text of 0x423259
    result_423259 = 0
    if sm == 'short':
        t = letters(rng, rng.choice([0, 1, 7, 0x20, 0x38, 0x39, 0x3c]))
        strarea[0:len(t) + 1] = t + b'\0'
        result_423259 = od.region_va(2)
    elif sm == 'long':
        t = letters(rng, 0x3d + rng.choice([0, 1, 9, 0x40]))
        strarea[0:len(t) + 1] = t + b'\0'
        result_423259 = od.region_va(2)
    busy = kind == 'busy'
    res_4f6334 = rng.choice([1, 0x100, 0xffffffff, 0x10000]) if busy else 0
    s_nz = rng.choice([1, 0x100, 0xffffffff, 0x10000]) if s5 else 0
    self_[0x69d:0x69f] = struct.pack('<h', rng.choice([0, 1, -1, 0x7fff, -32768, 300]))
    # the dword appended after the text. Without a NUL in it the string goes on into whatever follows the buffer: with the text up to 0x37 characters (the buffer of the original is 0x3c bytes, then idx) that is
    # the stack fill of the original (0x71, compared as 0, like the zeros of the native buffer); with a longer text it is the original's dead locals (idx, j,
    # the string pointer), which the native buffer does not reproduce: only a NUL-terminated dword is generated then (the direct test covers the lengths)
    longest = max(L, tail, len(t) if sm == 'short' else 0)
    appended = struct.unpack('<I', letters(rng, 3) + b'\0')[0] if rng.random() < 0.7 or longest > 0x37 else struct.unpack('<I', letters(rng, 4))[0]
    g = {'value_5bb202': s_nz, 'value_55cbc4': appended, 'value_5d03b3': rng.randrange(1 << 32), 'value_585d37': rng.choice([0, 5, 0xffffff00, rng.randrange(1 << 32)])}
    stubs = {0x50cd50: stub(0x50cd50, None, results=[rand_result & 0xffffffff]), 0x4f6334: stub(0x4f6334, None, results=[res_4f6334]),
             0x4fb77a: stub(0x4fb77a, None), 0x423259: stub(0x423259, None, results=[result_423259]), 0x448d11: stub(0x448d11, None), 0x4fb2e3: stub(0x4fb2e3, None)}
    stubs[0x4fb77a].derefs = [(0, 0x34)]
    stubs[0x448d11].derefs = [(1, 0x80)]
    areas = [Area('self', od.region_va(0), self_, image=False), Area('recs', 0x583f1f, recs), Area('consts', 0x55cba0, consts, compare=False),
             Area('c2', 0x63aa00, consts2, compare=False), Area('str', od.region_va(2), strarea, image=False, compare=False)]
    ptrs = {'records_583f1f': ('recs', 0), 'bytes_55cba0': ('consts', 0), 'bytes_55cbac': ('consts', 0xc), 'bytes_55cbb8': ('consts', 0x18),
            'bytes_63aa00': ('c2', 0), 'bytes_63aa04': ('c2', 4)}
    return common26('4eb184', areas, stubs, [('self', 0x8250, 0x40), ('self', 0x690, 0x20)], g=g, pointers=ptrs, stack=[nn & 0xffffffff], args=(nn & 0xffffffff,),
                    profile=(kind, *rest))


# the functions: id (the shim number), va, size from the ledger, whether the function returns a value (compared), the bytes it pops, the generator
SPECS = {
    '423fbb': dict(id=1, va=0x423fbb, size=62, gen=gen_423fbb, ret=True, cleanup=4, n=10 * 10),
    '4eb107': dict(id=2, va=0x4eb107, size=125, gen=gen_4eb107, cleanup=4, n=14 * 16),
    '42406d': dict(id=3, va=0x42406d, size=404, gen=gen_42406d, cleanup=4, n=4 * 150),
    '424201': dict(id=4, va=0x424201, size=325, gen=gen_424201, cleanup=4, n=27 * 12),
    '42ea87': dict(id=5, va=0x42ea87, size=717, gen=gen_42ea87, cleanup=0, n=0),
    '4eb184': dict(id=6, va=0x4eb184, size=1134, gen=gen_4eb184, cleanup=4, n=40 * 12),
}
KEYS = list(SPECS)
SPECS['42ea87']['n'] = (7 * 4 + 2 * 2 * 8 + 2 * 8 * 2) * 6


def build(key, rng, n):
    return SPECS[key]['gen'](rng, n)


def scenarios(key):
    return SPECS[key]['n']
