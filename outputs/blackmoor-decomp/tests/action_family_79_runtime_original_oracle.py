#!/usr/bin/env python3
"""RT-13: original-x86 oracle for the raw 0x79 runtime (dispatcher arm 0x429486).

Runs the unmodified original from the dispatcher arm with a fabricated frame:

    0x429486 arm -> 0x423f57 dependency gate -> 0x4eac4c handler
                 -> 0x4ea06c remove-item -> 0x4e812f view rebuild
                 -> 0x4eac88 held-item clear -> 0x4eac9b completion store

and stops at the dispatcher's loop join 0x42a9a9. Nothing the arm decides is
replaced. Hooks (enumerated in the report):

  replacement   0x423f57 ONLY in the "false gate" cases: returns 0 and pops its
                two arguments (the evaluator's tree walk needs a populated
                dependency tree; false-gate behaviour of the executor is
                covered by the native session tests). True-gate cases execute
                the real 0x423f57 on an empty tree (its count dword is zero).
  observation   code entry of 0x429486/0x423f57/0x4eac4c/0x4ea06c/0x4e812f,
                every memory write of the whole address space (classified), and
                register state at the stop. The real 0x4e812f view rebuild
                runs: it is NOT stubbed.

Compared after every case: one merged ORDERED event log (gate, handler/remove
entry, count/list/presence stores, rebuild entry with the full modeled state at
that moment, held store, completion store), the final value of every modeled
cell (held, count, all 70 list words including stale ones, all 70 presence
dwords), and the original's complete write footprint, which must fall inside the
modeled cells, the completion byte, the gate bookkeeping, the rebuild's derived
cells (0x583a2d/2f, 0x583abd, 0x583b49 and the view object) and the stack.
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import time

from cif_original_oracle import PEImage
import action_family_79_original_oracle as loader79
import session_binding_support as session
import test_action_family_79_runtime as native

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-13.oracle.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
LIVE_S6400_HASH = '78c3120adf5b9fe695d19e6b4a2f0f27965028f24254a39852e4fe1aa28702b3'
CODE_WINDOWS = [
    (0x429486, 0x4294c0, 'dispatcher arm 0x79', '2a8c8a80051177144635a3d777df828824bc90c58485db6e2c29165ac3c5a64a'),
    (0x4eac4c, 0x4eaca8, 'handler 0x4eac4c', '882b9be7aafb84490a96381ec2c62b04742a47195fc9fe3a6ad94744fff5a81b'),
    (0x4ea06c, 0x4ea1cb, 'remove item 0x4ea06c', 'f6aa62744639b799a56390c9a86098b21c19b3708c1f1255023ce25c0ded2ba2'),
    (0x4e812f, 0x4e8622, 'view rebuild 0x4e812f', '99a57706af8058a563258127a1a24d08079729ea1f699bfeebb30cfaf182bfe0'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57', '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8', 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4ee69e, 0x4ee6c7, 'rebuild helper 0x4ee69e', '7c9511b3156daf3837dc3a783867b87177457cf68cd55b62727fd095c8551641'),
    (0x50ce04, 0x50ce2b, 'float to int 0x50ce04', 'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
]

VIEW = 0x571442              # inventory view object (ECX of 0x4eac4c)
VIEW_BYTES = 0x8400
GATE_OBJECT = 0x63786d       # dependency evaluator object (ECX of 0x423f57)
HELD, COUNT_WORD = 0x583a29, 0x583a2b
LIST, PRESENCE = 0x583a31, 0x583bd5
CAPACITY = 70
DERIVED_WORDS = (0x583a2d, 4)
DERIVED_LISTS = ((0x583abd, 140), (0x583b49, 140))
SLOT_BASE, ROW_STRIDE = 0x5bb5e5, 0x8d
COMPLETION_OFFSET = 0x40     # 0x5bb625 - 0x5bb5e5
OBJECT_VA = 0x30001000
STACK, FRAME = 0x1000, 0xc000
STOP = 0x42a9a9
GATE_FLAG = 0x5c3a47


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(AssertionError):
    pass


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UC_HOOK_MEM_READ
        from unicorn import x86_const as x
        self.regs = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                     ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK, 0x10000)
        self.uc.mem_map(0x30000000, 0x10000)
        self.hook_counts = {}
        self.events, self.writes, self.reads_beyond = [], [], []
        self.gate_false = False
        self.row = 0
        self.last_id = None
        self.list_bytes = 0
        for address in (0x423f57, 0x4ea06c, 0x4e812f, 0x4eac4c, 0x429486):
            self.uc.hook_add(UC_HOOK_CODE, self.on_code, begin=address, end=address)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.on_write)
        # Reads of the words just past the item array: proves an unsafe scan.
        self.uc.hook_add(UC_HOOK_MEM_READ, self.on_read, begin=LIST + 2 * CAPACITY,
                         end=LIST + 2 * CAPACITY + 0x40)

    def read(self, address, size):
        return bytes(self.uc.mem_read(address, size))

    def s16(self, address):
        return struct.unpack('<h', self.read(address, 2))[0]

    def model_snapshot(self):
        return (self.s16(HELD), self.s16(COUNT_WORD),
                struct.unpack('<%dH' % CAPACITY, self.read(LIST, 2 * CAPACITY)),
                struct.unpack('<%di' % CAPACITY, self.read(PRESENCE, 4 * CAPACITY)))

    def count(self, name):
        self.hook_counts[name] = self.hook_counts.get(name, 0) + 1

    def on_code(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        ecx = uc.reg_read(self.regs['ECX'])
        if address == 0x429486:
            self.count('observe 0x429486 arm entry')
        elif address == 0x423f57:
            pointer, mode = struct.unpack('<II', self.read(esp + 4, 8))
            self.events.append(('gate', ecx, pointer, mode))
            if self.gate_false:
                # REPLACEMENT (false-gate cases only): EAX=0, pop two arguments.
                self.count('REPLACE 0x423f57 dependency gate (false-gate cases only)')
                ret = struct.unpack('<I', self.read(esp, 4))[0]
                uc.reg_write(self.regs['EAX'], 0)
                uc.reg_write(self.regs['ESP'], esp + 12)
                uc.reg_write(self.regs['EIP'], ret)
            else:
                self.count('observe 0x423f57 dependency gate (real code, empty tree)')
        elif address == 0x4eac4c:
            self.count('observe 0x4eac4c handler entry')
            self.events.append(('handler', ecx, struct.unpack('<h', self.read(esp + 4, 2))[0]))
        elif address == 0x4ea06c:
            self.count('observe 0x4ea06c remove entry')
            self.last_id = struct.unpack('<h', self.read(esp + 4, 2))[0]
            self.events.append(('visit', self.last_id, ecx))
        elif address == 0x4e812f:
            self.count('observe 0x4e812f view rebuild entry (real code runs)')
            self.events.append(('rebuild', self.last_id, ecx))
            self.events.append(('rebuild_snapshot', self.model_snapshot()))

    def on_read(self, uc, access, address, size, value, user):
        self.reads_beyond.append((address, size))

    def classify(self, address, end):
        if HELD <= address and end <= HELD + 2:
            return 'held'
        if COUNT_WORD <= address and end <= COUNT_WORD + 2:
            return 'count'
        if LIST <= address and end <= LIST + 2 * CAPACITY:
            return 'list'
        if PRESENCE <= address and end <= PRESENCE + 4 * CAPACITY:
            return 'presence'
        complete = SLOT_BASE + self.row * ROW_STRIDE + COMPLETION_OFFSET
        if complete <= address and end <= complete + 1:
            return 'complete'
        return None

    def on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        self.writes.append((address, size, value))
        kind = self.classify(address, address + size)
        if kind == 'list':
            # rep movsd then rep movsb: count bytes, report whole words.
            if self.events and self.events[-1][0] == 'list':
                self.list_bytes += size
                self.events[-1] = ('list', self.list_bytes // 2)
            else:
                self.list_bytes = size
                self.events.append(('list', size // 2))
        elif kind == 'count':
            self.events.append(('count', struct.unpack('<h', struct.pack('<H', value))[0]))
        elif kind == 'presence':
            self.events.append(('presence', (address - PRESENCE) // 4))
        elif kind == 'held':
            self.events.append(('held', struct.unpack('<h', struct.pack('<H', value))[0]))
        elif kind == 'complete':
            self.events.append(('complete', value))

    def footprint_class(self, address, size):
        end = address + size
        if self.classify(address, end) is not None:
            return 'modeled cells and completion byte'
        for start, length in ((GATE_OBJECT + 4, 4), (GATE_OBJECT + 0x614, 4), (GATE_FLAG, 4)):
            if start <= address and end <= start + length:
                return 'gate bookkeeping'
        for start, length in (DERIVED_WORDS, *DERIVED_LISTS, (VIEW, VIEW_BYTES)):
            if start <= address and end <= start + length:
                return 'rebuild-derived and view scratch (unmodeled)'
        if STACK <= address and end <= STACK + 0x10000:
            return 'stack'
        return None

    def run(self, case, strict=True):
        uc, r = self.uc, self.regs
        rng = random.Random(case['seed'])
        row = case['row']
        self.row = row
        self.gate_false = case['gate'] == 'false'
        self.events, self.writes, self.reads_beyond = [], [], []
        self.last_id = None
        # Derived cells and the view object start as noise; the rebuild's
        # inputs (item type table, mode word, +0x252) get controlled values.
        uc.mem_write(VIEW, bytes(rng.randrange(256) for _ in range(VIEW_BYTES)))
        for item in range(CAPACITY):
            uc.mem_write(VIEW + 0x77e + item * 0x16d,
                         struct.pack('<h', rng.choice((0, 1, 2, 3, 3, 7))))
        uc.mem_write(VIEW + 0x252, bytes(4))
        uc.mem_write(VIEW + 0x8232, struct.pack('<I', rng.choice((0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0))))
        uc.mem_write(DERIVED_WORDS[0], bytes(rng.randrange(256) for _ in range(4)))
        for address, size in DERIVED_LISTS:
            uc.mem_write(address, bytes(rng.randrange(256) for _ in range(size)))
        # Modeled cells: items first, then non-uniform stale words.
        words = list(case['items']) + [rng.randrange(65536) for _ in range(CAPACITY - len(case['items']))]
        case['list_words'] = words[:CAPACITY]
        uc.mem_write(LIST, struct.pack('<%dH' % CAPACITY, *words[:CAPACITY]))
        uc.mem_write(COUNT_WORD, struct.pack('<h', case['count']))
        uc.mem_write(HELD, struct.pack('<h', case['held']))
        uc.mem_write(PRESENCE, struct.pack('<%di' % CAPACITY, *case['presence']))
        # Row bookkeeping: slot pointer, completion byte, empty dependency tree.
        base = SLOT_BASE + row * ROW_STRIDE
        uc.mem_write(base, struct.pack('<I', OBJECT_VA))
        uc.mem_write(base + COMPLETION_OFFSET, b'\0')
        uc.mem_write(base + 4, struct.pack('<II', rng.randrange(2 ** 32), 0))
        uc.mem_write(GATE_OBJECT, bytes(rng.randrange(256) for _ in range(0x700)))
        uc.mem_write(GATE_FLAG, struct.pack('<I', 0x12345678))
        uc.mem_write(OBJECT_VA - 16, b'\xa5' * 16 + struct.pack('<H', case['word']) + b'\xd7' * 16)
        # Dispatcher frame: [ebp-0x11c] is the row index word.
        uc.mem_write(STACK, bytes(0x10000))
        uc.mem_write(FRAME - 0x11c, struct.pack('<h', row))
        initial = dict(EAX=rng.randrange(2 ** 32), EBX=rng.randrange(2 ** 32), ECX=rng.randrange(2 ** 32),
                       EDX=rng.randrange(2 ** 32), ESI=rng.randrange(2 ** 32), EDI=rng.randrange(2 ** 32),
                       EBP=FRAME)
        for name, value in initial.items():
            uc.reg_write(r[name], value)
        esp = FRAME - 0x400
        uc.reg_write(r['ESP'], esp)
        uc.reg_write(r['EFLAGS'], 0x202)
        self.writes.clear()  # the harness setup writes above are not original effects
        uc.emu_start(0x429486, STOP, count=2000000)
        if uc.reg_read(r['EIP']) != STOP:
            raise OracleError('original did not reach the dispatcher loop join')
        for name in ('EBX', 'ESI', 'EDI', 'EBP'):
            if uc.reg_read(r[name]) != initial[name]:
                raise OracleError(f'callee-saved {name} changed')
        if uc.reg_read(r['ESP']) != esp:
            raise OracleError('arm left the stack unbalanced')
        if self.read(OBJECT_VA - 16, 16) != b'\xa5' * 16 or self.read(OBJECT_VA + 2, 16) != b'\xd7' * 16 \
                or struct.unpack('<H', self.read(OBJECT_VA, 2))[0] != case['word']:
            raise OracleError('original wrote the runtime object or its guards')
        classes = set()
        for address, size, _ in self.writes:
            name = self.footprint_class(address, size)
            if name is None:
                if strict:
                    raise OracleError(f'original write outside the allowed footprint: {address:#x}/{size}')
                name = 'OUTSIDE (unsafe original behaviour)'
            classes.add(name)
        return dict(events=list(self.events), model=self.model_snapshot(),
                    completed=self.read(base + COMPLETION_OFFSET, 1)[0],
                    footprint=classes, writes=list(self.writes),
                    reads_beyond=list(self.reads_beyond))


def run_native(lib, case):
    """Same inputs, same ordered log, through the native kernel."""
    world = native.World([], held=case['held'])
    world.held.value = case['held']
    world.count.value = case['count']
    for i in range(CAPACITY):
        world.items[i] = case['list_words'][i]
        world.presence[i] = case['presence'][i]
    log = [('gate', GATE_OBJECT, SLOT_BASE + case['row'] * ROW_STRIDE + 4, 0)]

    @native.ObserveFn
    def observe(_ctx, effect, value):
        name = native.EFFECT_NAMES[effect]
        if name == 'visit':
            log.append(('handler', VIEW, case['row']))
            log.append(('visit', value, VIEW))
        elif name == 'rebuild':
            log.append(('rebuild', value, VIEW))
        else:
            log.append((name, value))

    @native.RebuildFn
    def rebuild(_ctx, removed):
        log.append(('rebuild_snapshot', world.snapshot()))
        return 0

    world.host = native.Host(None, rebuild, observe)
    result = None
    if case['gate'] == 'true':
        status, result, why = native.visit(lib, case['word'], world)
        if status != native.OK:
            raise OracleError(('native rejected a parity case', status, why, case))
    return dict(events=log, model=world.snapshot(), result=result)


def compare(lib, original, case):
    got = original.run(case)
    mine = run_native(lib, case)
    if mine['events'] != got['events']:
        raise OracleError(('effect order mismatch', case, mine['events'], got['events']))
    if mine['model'] != got['model']:
        raise OracleError(('model state mismatch', case, mine['model'], got['model']))
    if case['gate'] == 'true':
        names = [e[0] for e in got['events']]
        # The final store of a true-gate visit is the completion byte.
        if got['completed'] != 1 or names[-1] != 'complete' or mine['result'].completed != 1:
            raise OracleError(('completion mismatch', case))
        if bool(mine['result'].found) != ('rebuild' in names):
            raise OracleError(('found mismatch', case))
        if bool(mine['result'].held_cleared) != ('held' in names):
            raise OracleError(('held mismatch', case))
    elif got['completed'] != 0 or [e[0] for e in got['events']] != ['gate']:
        raise OracleError(('false gate must do nothing', case, got['events']))
    return got


def make_case(seed, row, word, gate, items, count, held):
    rng = random.Random(seed ^ 0x79)
    presence = [rng.choice((0, 1, 1, 2, 7, -1, 0x7fffffff)) for _ in range(CAPACITY)]
    return dict(seed=seed, row=row, word=word, gate=gate, items=list(items),
                count=count, held=held, presence=presence)


def scenarios(rng, word):
    """(items, count, held) triples around one removal word."""
    signed = struct.unpack('<h', struct.pack('<H', word))[0]
    others = [v for v in range(CAPACITY) if v != word]

    def pick(n):
        rng.shuffle(others)
        return others[:n]

    out = []
    for held in (signed, 3 if signed != 3 else 4, -1):
        out.append(([], 0, held))                                    # empty (new game)
        out.append((pick(5), 5, held))                               # absent
        for position in (0, 2, 4):                                   # first / middle / last
            items = pick(5)
            items[position] = word
            out.append((items, 5, held))
        items = pick(6)
        items[1], items[4] = word, word                              # duplicate
        out.append((items, 6, held))
        out.append((pick(4) + [word] * 3, 7, held))                  # triple at the end
        out.append(([word], 1, held))                                # only entry
        # Decoys that share the low byte or the sign bit but are different words.
        decoys = [(word ^ 0x100) & 0xffff, (word ^ 0x8000) & 0xffff, (word + 0x4001) & 0xffff]
        # Only the absent case is safe for the original: its view rebuild indexes an
        # item type table with every kept list word, so out-of-range words in a
        # FOUND list read unmapped memory (outside the valid-input domain).
        out.append((decoys, 3, held))                                # decoys only: absent
        out.append((pick(3) + [word], 3, held))                      # present beyond the count
    out.append((pick(5), -1, signed))
    out.append(([word] * 3, -32768, signed))
    out.append(([word] + pick(68), 69, signed))
    out.append((pick(69) + [word], 70, signed))                      # full inventory, last
    out.append(([word] + pick(69), 70, signed))                      # full inventory, first
    return out


def live_s6400_row(library_path):
    lib = session.load_library(library_path)
    lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo)]
    live = (ROOT / 'work/analysis/slices/RT-13.resources/S6400.live.bin').read_bytes()
    if sha(live) != LIVE_S6400_HASH:
        raise OracleError('live S6400 external resource hash mismatch')
    owner = (c.c_uint8 * len(live)).from_buffer_copy(live)
    error = c.create_string_buffer(256)
    scene = lib.scene_resource_open_memory(owner, len(live), error, len(error))
    if not scene:
        raise OracleError('live S6400 did not open: ' + error.value.decode())
    info = session.SceneActionInfo()
    if lib.scene_resource_action_at(scene, 15, c.byref(info)) != 0 or info.type != 0x79:
        raise OracleError('live S6400 row 15 is not raw 0x79')
    row = dict(subtype=info.subtype, body=bytes(info.raw_body[:info.raw_body_length]),
               description=bytes(info.description))
    lib.scene_resource_close(scene)
    del owner
    return row


def main(*, library=None, report_path=REPORT):
    started = time.monotonic()
    library_path = native.build_library() if library is None else native.library_path()
    lib = native.bind(library_path)
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = Original(pe)

    # Inputs: every raw-0x79 item word of the CIFTREE corpus (A-79.1) and the
    # live external-CIF S6400 row the tutorial actually reaches.
    corpus = json.loads((ROOT / 'work/analysis/slices/A-79.1.corpus.json').read_bytes())
    corpus_words = []
    for record in corpus['records']:
        data = (ROOT / 'work/analysis/hiff-resources' / f"{record['resource_index']:04d}.bin").read_bytes()
        start = record['act_payload_offset']
        payload = data[start:start + record['act_payload_length']]
        corpus_words.append(struct.unpack('<H', payload[50:52])[0])
    live = live_s6400_row(library_path)
    live_word = struct.unpack('<H', live['body'][:2])[0]
    # Original loader parity for the live external row (A-79.1 machinery).
    loader = loader79.Original(pe)
    live_payload = live['description'][:48].ljust(48, b'\0') + bytes([0x79, live['subtype']]) + live['body']
    loader_object, _, _, _ = loader.invoke(live['body'], b'\x00\x00', live_payload, 50)
    if struct.unpack('<H', loader_object)[0] != live_word:
        raise OracleError('original loader object differs from the live row word')

    rng = random.Random(0x13)
    synthetic_words = [0xffff, 0xfffe, 0x8000, 0x7fff, 70, 255, 69, 0, 1]
    groups = [('corpus', corpus_words), ('live-S6400-external', [live_word]),
              ('synthetic', synthetic_words)]
    rows = [0, 3, 15, 16, 39, 119, 239]
    cases = seed = false_gate = 0
    sequences, footprints = {}, {}
    per_group = {}
    for group, words in groups:
        per_group[group] = 0
        for word in words:
            signed_word = struct.unpack('<h', struct.pack('<H', word))[0]
            for items, count, held in scenarios(rng, word):
                # Words outside the presence array are unsafe in the original
                # when present in the list (observed separately, native rejects).
                if not 0 <= signed_word < CAPACITY and word in items[:max(count, 0)]:
                    continue
                gate = 'false' if seed % 7 == 3 else 'true'
                case = make_case(seed, rows[seed % len(rows)], word, gate, items, count, held)
                seed += 1
                got = compare(lib, original, case)
                cases += 1
                per_group[group] += 1
                false_gate += gate == 'false'
                key = ','.join(e[0] for e in got['events'])
                sequences[key] = sequences.get(key, 0) + 1
                for name in got['footprint']:
                    footprints[name] = footprints.get(name, 0) + 1

    parity_hooks = dict(sorted(original.hook_counts.items()))
    # Unsafe original behaviour: observed, never a parity target. Native rejects.
    unsafe = []

    def observe_unsafe(label, items, count, word):
        case = make_case(10_000 + len(unsafe), 3, word, 'true', items, count, -1)
        got = original.run(case, strict=False)
        world = native.World([], held=-1)
        world.count.value = count
        for i in range(CAPACITY):
            world.items[i] = case['list_words'][i]
        status, _, why = native.visit(lib, word, world)
        if status != native.BOUNDS:
            raise OracleError(('native accepted an unsafe case', label, status))
        outside = sorted(a for a, size, _ in got['writes'] if original.footprint_class(a, size) is None)
        presence_store = PRESENCE + 4 * struct.unpack('<h', struct.pack('<H', word))[0]
        stores_there = [(a, size, v) for a, size, v in got['writes'] if a == presence_store and size == 4]
        entry = dict(
            label=label, original_completed=got['completed'],
            original_reads_past_item_array=len(got['reads_beyond']),
            original_stores_outside_every_known_cell=len(outside),
            original_outside_range=[hex(outside[0]), hex(outside[-1])] if outside else None,
            native_status='ACTION79_ERR_BOUNDS', native_reason=(why or b'').decode())
        if count <= CAPACITY:
            if not stores_there or stores_there[0][2] != 0:
                raise OracleError(('original did not store presence[id]=0 at the computed address', label))
            entry['original_presence_store'] = hex(presence_store) + ' <- 0 (4 bytes)'
        unsafe.append(entry)

    observe_unsafe('id above the presence array', [4, 100, 5], 3, 100)
    observe_unsafe('negative id', [4, 0xfffe, 5], 3, 0xfffe)
    observe_unsafe('count above the item array', list(range(CAPACITY)), 75, 5)

    # Out-of-range words among the KEPT entries: the original's rebuild indexes an
    # item type table with each of them. Observed, not a parity target; the native
    # kernel never indexes with other entries, so it does not validate them.
    stray = make_case(20_000, 3, 4, 'true', [5, 0x8004, 4], 3, -1)
    try:
        original.run(stray, strict=False)
        stray_result = 'original completed'
    except Exception as error:  # Unicorn raises UcError for the unmapped read
        stray_result = type(error).__name__ + ': ' + str(error)
    unsafe.append(dict(label='out-of-range word among the kept entries (found item present)',
                       original_result=stray_result,
                       native='not validated by the kernel; the rebuild provider owns it'))

    report = dict(
        slice='RT-13',
        scope='dispatcher arm 0x429486 through 0x4eac4c/0x4ea06c and the real 0x4e812f; stop 0x42a9a9',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        live_s6400_external_sha256=LIVE_S6400_HASH, live_row15_word=live_word,
        live_row_loader_parity='original 0x40b34a loader built the same two-byte object',
        corpus_words=len(corpus_words),
        corpus_source='A-79.1.corpus.json (CIFTREE.DAT resources; external CIF scenes are not in it)',
        cases=cases, cases_by_input_group=per_group, false_gate_cases=false_gate,
        true_gate_cases=cases - false_gate, mismatches=0,
        event_sequences=dict(sorted(sequences.items())),
        write_footprint_classes=dict(sorted(footprints.items())),
        hooks_parity_cases=parity_hooks,
        hooks_including_unsafe_observations=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='only 0x423f57 in the false-gate cases; true-gate cases run the real '
                                    'evaluator on an empty tree',
        compared='ordered merged event log; every modeled cell; completion byte; rebuild-entry snapshot; '
                 'write footprint; callee-saved registers and stack balance',
        unsafe_original_observations=unsafe,
        unverified=['non-empty dependency tree evaluation (shared kernel; native session tests only)',
                    'what 0x4e812f derives (0x583a2d/2f, 0x583abd, 0x583b49, view object): runs but is not modeled',
                    'dispatcher loop ordering around the arm (executor tests)',
                    'external-CIF scenes other than S6400'],
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('cases', 'true_gate_cases', 'false_gate_cases',
                                             'mismatches', 'seconds')}))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    main(report_path=parser.parse_args().report)
