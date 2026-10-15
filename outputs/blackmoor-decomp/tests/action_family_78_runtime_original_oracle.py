#!/usr/bin/env python3
"""RT-19: original-x86 oracle for the raw 0x78 runtime (dispatcher arm 0x42944b).

Two machines, both the unmodified original under Unicorn:

A. Loader: the loader switch (0x40b34a, byte map 0x410e9c, table 0x410ca4) arm 0x40e56a
   -> constructor 0x4e9c2f builds the six-byte object and stores the raw type byte
   0x78 into the row (generic code, stop at 0x410a68). Compared with
   action78_object_from_body, byte for byte, with cursor and payload offset.

B. Runtime: the dispatcher arm runs from a fabricated frame

     0x42944b arm -> 0x423f57 dependency gate -> 0x4eaadc handler
       -> 0x4e8d96 put back / 0x4e9e84 add / 0x4ea06c remove
       -> 0x4e812f view rebuild -> 0x4e0559 UI animation -> 0x4eac3f completion

   and stops at the dispatcher's loop join 0x42a9a9. Nothing the arm decides is
   replaced. Enumerated hooks (the report lists the per-run counts):

   replacement  0x4fb2e3 sound manager request (host boundary): its argument is
                logged, the stdcall frame is popped. What it does (probe 0x4f6059,
                store 1 into the slot's trigger word) is a host effect, not compared.
   replacement  0x423f57 ONLY in the "false gate" cases (returns 0, pops two
                arguments). True-gate cases execute the real evaluator on an empty
                tree.
   observation  code entry of 0x42944b/0x423f57/0x4eaadc/0x4e8d96/0x4e9e84/0x4e9edc
                (duplicate exit)/0x4ea06c/0x4e812f/0x4e0559, every memory write of the
                whole address space (classified), register state at the stop.
   The real 0x4e812f view rebuild and the real 0x4e0559 UI animation run.

Compared after every case: one merged ORDERED event log (gate, handler entry, put back,
add entries with their flag, duplicate exits, sound request, count/list/presence stores,
rebuild entries with the modeled state at that moment, UI request, held stores, remove
entry and its stores, completion), the final value of every modeled cell (held, count,
all 70 list words including stale ones, all 70 presence dwords), and the original's
complete write footprint, which must fall inside the modeled cells, the completion byte,
the gate bookkeeping, the rebuild's derived cells and view object, the two UI animation
cells, and the stack.
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import subprocess
import time

from cif_original_oracle import PEImage
import session_binding_support as session
import test_action_family_78_runtime as native
import action_family_79_runtime_original_oracle as o79

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-19.oracle.json'
CORPUS = ROOT / 'work/analysis/slices/RT-19.corpus.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
LIVE_S6453 = ROOT / 'work/analysis/slices/RT-19.resources/S6453.live.bin'
LIVE_S6453_HASH = 'b1681a4aa5ee8dde3f69e91d4f5aec5d6653be68c6aa5b17ab07165d2f6be18d'
CODE_WINDOWS = [
    (0x42944b, 0x429486, 'dispatcher arm 0x78', 'd3ee8f3765241ed70571b27ee7ba3adfc2c826b765a5cb04bca6dbb9c779231f'),
    (0x4eaadc, 0x4eac4c, 'handler 0x4eaadc', 'd898dbde05c9472e27c277f78954739b9ce4d644a5bc815c400c5658f99dce1d'),
    (0x4e8d96, 0x4e8dc8, 'put back 0x4e8d96', '0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85'),
    (0x4e9e84, 0x4ea06c, 'add item 0x4e9e84', '2474b155759c56581a8aa3345ba306834fe612ce2eaaa47db2052e61f046e932'),
    (0x4ea06c, 0x4ea1cb, 'remove item 0x4ea06c', 'f6aa62744639b799a56390c9a86098b21c19b3708c1f1255023ce25c0ded2ba2'),
    (0x4e812f, 0x4e8622, 'view rebuild 0x4e812f', '99a57706af8058a563258127a1a24d08079729ea1f699bfeebb30cfaf182bfe0'),
    (0x4e0559, 0x4e0619, 'UI animation 0x4e0559', '3588d6413d5da5a05d2f2b95f48f83c09d778652ca01c5c4d85d9345377831b1'),
    (0x4fb2e3, 0x4fb397, 'sound request 0x4fb2e3 (replaced)', 'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57', '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8', 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4ee69e, 0x4ee6c7, 'rebuild helper 0x4ee69e', '7c9511b3156daf3837dc3a783867b87177457cf68cd55b62727fd095c8551641'),
    (0x50ce04, 0x50ce2b, 'float to int 0x50ce04', 'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
]
LOADER_WINDOWS = [
    (0x40b34a, 0x40b506, 'loader switch head 0x40b34a', '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x40e56a, 0x40e597, 'loader arm 0x78 0x40e56a', None),
    (0x4e9c2f, 0x4e9cdf, 'constructor 0x4e9c2f', None),
    (0x410a68, 0x410aaa, 'loader tail 0x410a68', 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]

VIEW, VIEW_BYTES = o79.VIEW, o79.VIEW_BYTES
GATE_OBJECT, GATE_FLAG = o79.GATE_OBJECT, o79.GATE_FLAG
HELD, COUNT_WORD, LIST, PRESENCE = o79.HELD, o79.COUNT_WORD, o79.LIST, o79.PRESENCE
CAPACITY = 70
DERIVED_WORDS, DERIVED_LISTS = o79.DERIVED_WORDS, o79.DERIVED_LISTS
SLOT_BASE, ROW_STRIDE, COMPLETION_OFFSET = o79.SLOT_BASE, o79.ROW_STRIDE, o79.COMPLETION_OFFSET
OBJECT_VA = o79.OBJECT_VA
STACK, FRAME, STOP = o79.STACK, o79.FRAME, 0x42a9a9
MODE_OFFSET, SLOT_FLAG_OFFSET, SCRATCH_INDEX = 0x764c, 0x7010, 0x822e
UI_CELLS = (0x5a1958, 0x5a195c)     # 0x5a17b4 + 0x1a4 and 0x5a17b8 + 0x1a4 (index 1, sub 0)
VIEW_MODES = ((0, 0), (2, 1), (2, 0), (0, 1), (3, 1), (2, 255), (1, 1))
REBUILD_DOMAIN = 'rebuild reads an item type outside the table'


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(AssertionError):
    pass


def s16(value):
    return struct.unpack('<h', struct.pack('<H', value & 0xffff))[0]


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
        self.events, self.writes, self.reads_beyond, self.ui_writes = [], [], [], []
        self.gate_false = False
        self.row = 0
        self.mode = 'add'
        self.last_id = None
        self.list_bytes = 0
        for address in (0x42944b, 0x423f57, 0x4eaadc, 0x4e8d96, 0x4e9e84, 0x4e9edc, 0x4ea06c,
                        0x4e812f, 0x4e0559, 0x4fb2e3):
            self.uc.hook_add(UC_HOOK_CODE, self.on_code, begin=address, end=address)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.on_write)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.on_read, begin=LIST + 2 * CAPACITY,
                         end=LIST + 2 * CAPACITY + 0x40)

    def read(self, address, size):
        return bytes(self.uc.mem_read(address, size))

    def u16(self, address):
        return struct.unpack('<H', self.read(address, 2))[0]

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
        if address == 0x42944b:
            self.count('observe 0x42944b arm entry')
        elif address == 0x423f57:
            pointer, mode = struct.unpack('<II', self.read(esp + 4, 8))
            self.events.append(('gate', ecx, pointer, mode))
            if self.gate_false:
                self.count('REPLACE 0x423f57 dependency gate (false-gate cases only)')
                ret = struct.unpack('<I', self.read(esp, 4))[0]
                uc.reg_write(self.regs['EAX'], 0)
                uc.reg_write(self.regs['ESP'], esp + 12)
                uc.reg_write(self.regs['EIP'], ret)
            else:
                self.count('observe 0x423f57 dependency gate (real code, empty tree)')
        elif address == 0x4eaadc:
            self.count('observe 0x4eaadc handler entry')
            slot = struct.unpack('<I', self.read(SLOT_BASE + self.row * ROW_STRIDE, 4))[0]
            self.events.append(('enter', s16(self.u16(slot))))
        elif address == 0x4e8d96:
            self.count('observe 0x4e8d96 put back entry')
            held = self.s16(HELD)
            if held != -1:
                self.events.append(('putback', held))
        elif address == 0x4e9e84:
            self.count('observe 0x4e9e84 add entry')
            word, flag = struct.unpack('<HxxI', self.read(esp + 4, 8))
            self.last_id = s16(word)
            self.mode = 'add'
            self.events.append(('add_flagged' if flag else 'add', self.last_id))
        elif address == 0x4e9edc:
            self.count('observe 0x4e9edc duplicate exit')
            self.events.append(('duplicate', struct.unpack('<i', self.read(VIEW + SCRATCH_INDEX, 4))[0]))
        elif address == 0x4ea06c:
            self.count('observe 0x4ea06c remove entry')
            self.last_id = struct.unpack('<h', self.read(esp + 4, 2))[0]
            self.mode = 'remove'
            self.events.append(('visit', self.last_id))
        elif address == 0x4e812f:
            self.count('observe 0x4e812f view rebuild entry (real code runs)')
            self.events.append(('rebuild', self.last_id))
            self.events.append(('rebuild_snapshot', self.model_snapshot()))
        elif address == 0x4e0559:
            self.count('observe 0x4e0559 UI animation entry (real code runs)')
            index, enable, sub = struct.unpack('<hxxIhxx', self.read(esp + 4, 12))
            self.events.append(('ui', index))
            self.events.append(('ui_call', index, enable, sub))
        elif address == 0x4fb2e3:
            self.count('REPLACE 0x4fb2e3 sound manager request (host boundary)')
            ret, slot = struct.unpack('<II', self.read(esp, 8))
            self.events.append(('sound', slot & 0xffff))
            self.events.append(('sound_call', slot & 0xffff))
            uc.reg_write(self.regs['ESP'], esp + 8)     # ret 4
            uc.reg_write(self.regs['EIP'], ret)

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
        for cell in UI_CELLS:
            if cell <= address and end <= cell + 4:
                return 'ui'
        return None

    def on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        self.writes.append((address, size, value))
        kind = self.classify(address, address + size)
        suffix = '' if self.mode == 'add' else '79'
        if kind == 'list':
            # rep movsd then rep movsb: count bytes, report whole words.
            name = 'list' + suffix
            if self.events and self.events[-1][0] == name:
                self.list_bytes += size
                self.events[-1] = (name, self.list_bytes // 2)
            else:
                self.list_bytes = size
                self.events.append((name, size // 2))
        elif kind == 'count':
            self.events.append(('count' + suffix, s16(value)))
        elif kind == 'presence':
            self.events.append(('presence' + suffix, (address - PRESENCE) // 4))
        elif kind == 'held':
            self.events.append(('held', s16(value)))
        elif kind == 'complete':
            self.events.append(('complete', value))
        elif kind == 'ui':
            self.ui_writes.append((address, size, value))

    def footprint_class(self, address, size):
        end = address + size
        kind = self.classify(address, end)
        if kind == 'ui':
            return 'UI animation cells (request)'
        if kind is not None:
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
        self.events, self.writes, self.reads_beyond, self.ui_writes = [], [], [], []
        self.last_id, self.mode = None, 'add'
        # Derived cells and the view object start as noise; the rebuild's inputs (item
        # type table, +0x252, +0x8232) get controlled values (as RT-13), and the two view
        # fields the add step reads get the case's values after the noise.
        uc.mem_write(VIEW, bytes(rng.randrange(256) for _ in range(VIEW_BYTES)))
        for item in range(CAPACITY):
            uc.mem_write(VIEW + 0x77e + item * 0x16d,
                         struct.pack('<h', rng.choice((0, 1, 2, 3, 3, 7))))
        uc.mem_write(VIEW + 0x252, bytes(4))
        uc.mem_write(VIEW + 0x8232, struct.pack('<I', rng.choice((0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0))))
        uc.mem_write(VIEW + MODE_OFFSET, struct.pack('<i', case['mode']))
        uc.mem_write(VIEW + SLOT_FLAG_OFFSET, bytes([case['slot_flag']]))
        uc.mem_write(DERIVED_WORDS[0], bytes(rng.randrange(256) for _ in range(4)))
        for address, size in DERIVED_LISTS:
            uc.mem_write(address, bytes(rng.randrange(256) for _ in range(size)))
        words = list(case['items']) + [rng.randrange(65536) for _ in range(CAPACITY - len(case['items']))]
        case['list_words'] = words[:CAPACITY]
        uc.mem_write(LIST, struct.pack('<%dH' % CAPACITY, *words[:CAPACITY]))
        uc.mem_write(COUNT_WORD, struct.pack('<h', case['count']))
        uc.mem_write(HELD, struct.pack('<h', case['held']))
        uc.mem_write(PRESENCE, struct.pack('<%di' % CAPACITY, *case['presence']))
        base = SLOT_BASE + row * ROW_STRIDE
        uc.mem_write(base, struct.pack('<I', OBJECT_VA))
        uc.mem_write(base + COMPLETION_OFFSET, b'\0')
        uc.mem_write(base + 4, struct.pack('<II', rng.randrange(2 ** 32), 0))
        uc.mem_write(GATE_OBJECT, bytes(rng.randrange(256) for _ in range(0x700)))
        uc.mem_write(GATE_FLAG, struct.pack('<I', 0x12345678))
        obj = struct.pack('<HHH', case['word'], case['take'], case['swap'])
        uc.mem_write(OBJECT_VA - 16, b'\xa5' * 16 + obj + b'\xd7' * 16)
        for cell in UI_CELLS:
            uc.mem_write(cell, struct.pack('<I', 0xdeadbeef))
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
        self.writes.clear()
        uc.emu_start(0x42944b, STOP, count=3000000)
        if uc.reg_read(r['EIP']) != STOP:
            raise OracleError('original did not reach the dispatcher loop join')
        for name in ('EBX', 'ESI', 'EDI', 'EBP'):
            if uc.reg_read(r[name]) != initial[name]:
                raise OracleError(f'callee-saved {name} changed')
        if uc.reg_read(r['ESP']) != esp:
            raise OracleError('arm left the stack unbalanced')
        if self.read(OBJECT_VA - 16, 16 + 6 + 16) != b'\xa5' * 16 + obj + b'\xd7' * 16:
            raise OracleError('original wrote the runtime object or its guards')
        classes = set()
        for address, size, _ in self.writes:
            name = self.footprint_class(address, size)
            if name is None:
                if strict:
                    raise OracleError(f'original write outside the allowed footprint: {address:#x}/{size}')
                name = 'OUTSIDE (unsafe original behaviour)'
            classes.add(name)
        # The UI animation request is exactly its two stores (index 1, sub 0).
        ui_calls = [e for e in self.events if e[0] == 'ui_call']
        expected_ui = []
        for _ in ui_calls:
            expected_ui += [(UI_CELLS[0], 4, 1), (UI_CELLS[1], 4, 1)]
        if strict and self.ui_writes != expected_ui:
            raise OracleError(('UI animation stores differ from the modeled request', self.ui_writes))
        if strict and any(e[1:] != (1, 1, 0) for e in ui_calls):
            raise OracleError(('UI animation arguments differ from (1, 1, 0)', ui_calls))
        return dict(events=list(self.events), model=self.model_snapshot(),
                    completed=self.read(base + COMPLETION_OFFSET, 1)[0],
                    footprint=classes, writes=list(self.writes),
                    reads_beyond=list(self.reads_beyond), ui_writes=list(self.ui_writes))


def run_native(lib, case):
    """Same inputs, same ordered log, through the native kernel."""
    world = native.World78([], held=case['held'], mode=case['mode'], slot_flag=case['slot_flag'])
    world.held.value = case['held']
    world.count.value = case['count']
    for i in range(CAPACITY):
        world.items[i] = case['list_words'][i]
        world.presence[i] = case['presence'][i]
    world.log.append(('gate', GATE_OBJECT, SLOT_BASE + case['row'] * ROW_STRIDE + 4, 0))
    result = None
    status = None
    why = None
    if case['gate'] == 'true':
        status, result, why = native.visit(lib, case['word'], case['take'], case['swap'], world)
    events = []
    for entry in world.log:
        if entry[0] == 'rebuild_call':
            events.append(('rebuild_snapshot', entry[2]))
        else:
            events.append(entry)
    return dict(events=events, model=world.snapshot(), result=result, status=status, why=why,
                guards=world.guards_intact())


def compare(lib, original, case):
    got = original.run(case)
    mine = run_native(lib, case)
    if case['gate'] == 'true' and mine['status'] != native.OK:
        raise OracleError(('native rejected a parity case', mine['status'], mine['why'], case))
    if mine['events'] != got['events']:
        raise OracleError(('effect order mismatch', case, mine['events'], got['events']))
    if mine['model'] != got['model']:
        raise OracleError(('model state mismatch', case, mine['model'], got['model']))
    if not mine['guards']:
        raise OracleError(('native wrote outside the arrays', case))
    names = [e[0] for e in got['events']]
    if case['gate'] == 'true':
        if got['completed'] != 1 or names[-1] != 'complete' or mine['result'].completed != 1:
            raise OracleError(('completion mismatch', case))
        res = mine['result']
        checks = (
            ('took_in_hand', res.took_in_hand, int(case['take'] != 0)),
            ('put_back', res.put_back, int('putback' in names)),
            ('removed', res.removed, names.count('presence79')),
            ('added', res.added, names.count('presence')),
            ('duplicates', res.duplicates, names.count('duplicate')),
            ('sound_requests', res.sound_requests, names.count('sound')),
            ('ui_requests', res.ui_requests, names.count('ui')),
            ('held_changed', res.held_changed, names.count('held')),
        )
        for label, actual, expected in checks:
            if actual != expected:
                raise OracleError(('result field mismatch', label, actual, expected, case))
    elif got['completed'] != 0 or names != ['gate']:
        raise OracleError(('false gate must do nothing', case, got['events']))
    return got


# ------------------------------------------------------------------ reference model
def simulate(case):
    """Independent Python model of the decision tree; used only to classify a case as
    inside or outside the original's valid-input domain (the original's reads and writes
    stay inside the modeled arrays and the rebuild's tables). Returns (safe, reason):
    reason is '' for a clean case, REBUILD_DOMAIN when the case is valid for the native
    kernel but the original's real 0x4e812f may read outside its item type table (the
    parity run is then attempted and a Unicorn fault is reported, not failed), or the
    first memory-safety violation (the native kernel must reject the case)."""
    held, count = case['held'], case['count']
    items = list(case['items']) + [0xffff] * (CAPACITY + 2 - len(case['items']))
    word, take, swap = case['word'], case['take'], case['swap']
    ident = s16(word)
    state = dict(held=held, count=count, items=items)
    soft = set()    # rebuild-domain violations: the original may fault or read garbage

    class Unsafe(Exception):
        pass

    def rebuild_ok():
        window = state['items'][:max(state['count'], 0)]
        if any(not 0 <= w < CAPACITY for w in window):
            soft.add(REBUILD_DOMAIN)

    def scan(item):
        if state['count'] > CAPACITY:
            raise Unsafe('scan beyond the item array')
        for i in range(max(state['count'], 0)):
            if s16(state['items'][i]) == item:
                return i
        return -1

    def remove(item):
        i = scan(item)
        if i < 0:
            return
        if not 0 <= item < CAPACITY:
            raise Unsafe('presence write outside the array')
        kept = [state['items'][k] for k in range(state['count']) if k != i]
        state['items'][:len(kept)] = kept
        state['count'] -= 1
        rebuild_ok()

    def add(item):
        if scan(item) >= 0:
            return
        if state['count'] < -1:
            raise Unsafe('negative length copy')
        if state['count'] + 1 > CAPACITY:
            raise Unsafe('list write past the item array')
        if not 0 <= item < CAPACITY:
            raise Unsafe('presence write outside the array')
        last = case['slot_flag'] != 0 and case['mode'] == 2
        new = state['count'] + 1
        if new > 0:
            if last:
                state['items'][state['count']] = item & 0xffff
            else:
                state['items'][1:new] = state['items'][0:new - 1]
                state['items'][0] = item & 0xffff
        state['count'] = new
        rebuild_ok()

    try:
        if take != 0:
            if state['held'] == -1:
                remove(ident)
                state['held'] = s16(word)
            elif swap != 0:
                if state['held'] != ident:
                    add(state['held'])
                    state['held'] = -1
                    remove(ident)
                    state['held'] = s16(word)
            elif state['held'] != ident:
                add(ident)
        if state['held'] != ident:
            add(ident)
    except Unsafe as error:
        return False, str(error)
    return True, REBUILD_DOMAIN if soft else ''


# ------------------------------------------------------------------ corpus and cases
def ensure_corpus():
    """The raw 0x78 rows of the corpus, produced through the production parser."""
    if not CORPUS.exists():
        tool = ROOT / 'work/analysis/slices/RT-19.corpus-dump'
        src = ROOT / 'outputs/blackmoor-decomp/src'
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-std=c11', '-O1', '-I', str(src),
                        str(Path(__file__).with_name('action_family_78_corpus_dump.c')),
                        str(src / 'scene_resource.c'), str(src / 'hiff.c'), '-o', str(tool)],
                       check=True, capture_output=True)
        listing = subprocess.run([str(tool), *sorted(str(p) for p in
                                 (ROOT / 'work/analysis/hiff-resources').glob('*.bin'))],
                                 check=True, capture_output=True, text=True).stdout
        records = []
        for line in listing.splitlines():
            path, row, rows, length, deps, hexbody = line.split()
            records.append(dict(resource_index=int(Path(path).stem), action_index=int(row),
                                scene_rows=int(rows), typed_body_length=int(length),
                                dependency_count=int(deps), body=hexbody,
                                body_sha256=sha(bytes.fromhex(hexbody))))
        CORPUS.write_text(json.dumps(dict(exe_sha256=EXE_HASH, raw_0x78_rows=len(records),
                                          records=records), indent=1) + '\n')
    corpus = json.loads(CORPUS.read_text())
    return [bytes.fromhex(r['body']) for r in corpus['records']], corpus


def live_s6453_row(library_path):
    lib = session.load_library(library_path)
    lib.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo)]
    live = LIVE_S6453.read_bytes()
    if sha(live) != LIVE_S6453_HASH:
        raise OracleError('live S6453 resource hash mismatch')
    owner = (c.c_uint8 * len(live)).from_buffer_copy(live)
    error = c.create_string_buffer(256)
    scene = lib.scene_resource_open_memory(owner, len(live), error, len(error))
    if not scene:
        raise OracleError('live S6453 did not open: ' + error.value.decode())
    info = session.SceneActionInfo()
    if lib.scene_resource_action_at(scene, 4, c.byref(info)) != 0 or info.type != 0x78:
        raise OracleError('live S6453 row 4 is not raw 0x78')
    row = dict(subtype=info.subtype, body=bytes(info.raw_body[:info.raw_body_length]),
               typed=bytes(info.typed_body[:info.typed_body_length]),
               description=bytes(info.description))
    lib.scene_resource_close(scene)
    del owner
    return row


def make_case(seed, row, word, take, swap, gate, items, count, held, mode, slot_flag):
    rng = random.Random(seed ^ 0x78)
    presence = [rng.choice((0, 1, 1, 2, 7, -1, 0x7fffffff)) for _ in range(CAPACITY)]
    return dict(seed=seed, row=row, word=word, take=take, swap=swap, gate=gate, items=list(items),
                count=count, held=held, presence=presence, mode=mode, slot_flag=slot_flag)


def scenarios(rng, word, take, swap):
    """(items, count, held) triples around one word. Lists hold valid item ids; the
    decoys differ from the word only above the low byte (0x100 | id, which the original's
    rebuild still maps) or, beside the word itself, in the sign bit."""
    signed_word = s16(word)
    valid = 0 <= signed_word < CAPACITY
    others = [v for v in range(CAPACITY) if v != word]

    def pick(n):
        rng.shuffle(others)
        return others[:n]

    out = []
    other_held = pick(1)[0]
    helds = [-1, signed_word, other_held, pick(1)[0]]
    for held in helds:
        out.append(([], 0, held))                                    # empty (new game)
        out.append((pick(5), 5, held))                               # word absent
        out.append((pick(3) + [word], 3, held))                      # present beyond the count
        if valid:
            for position in (0, 2, 4):                               # first / middle / last
                items = pick(5)
                items[position] = word
                out.append((items, 5, held))
        items = pick(6)
        items[1], items[4] = word & 0xffff, word & 0xffff            # duplicate
        out.append((items, 6, held))
        out.append((pick(4) + [word] * 3, 7, held))                  # triple at the end
        out.append(([word], 1, held))                                # only entry
        out.append(([word] + pick(68), 69, held))                    # one short of full, word first
        out.append((pick(69), 69, held))                             # one short of full, word absent
        out.append(([word] + pick(69), 70, held))                    # full, word first
        out.append((pick(69) + [word], 70, held))                    # full, word last
        # decoys: low byte shared / high bits differ. Insertable decoys (id + 0x100) only
        # when the original's rebuild can still read them; the sign-bit decoy only beside
        # a real match (the rebuild never runs over it then, or the case is a duplicate).
        if valid:
            out.append(([0x100 | signed_word, 0x4000 | signed_word], 2, held))
            out.append(([0x8000 | signed_word, signed_word], 2, held))
            out.append(([signed_word, 0x8000 | signed_word], 2, held))
        out.append(([(word + 0x4001) & 0xffff, word ^ 0x100 if word < 0x8000 else word ^ 0x4000], 2, held))
    out.append((pick(5), -1, signed_word))                           # count minus one
    out.append((pick(5), -1, -1))
    out.append(([word] * 3, -1, other_held))
    return out


def flag_decoys():
    # nonzero flags whose low byte is zero or whose value is negative: the original
    # tests whole words.
    return [(0, 0), (1, 1), (1, 0), (0, 1), (2, 1), (1, 2), (0x100, 1), (1, 0x100),
            (0xff00, 0xff00), (0xffff, 0xffff), (0x8000, 0), (0, 0x8000), (0x100, 0)]


def main(*, library=None, report_path=REPORT, quick=False):
    started = time.monotonic()
    library_path = native.build_library() if library is None else native.library_path()
    lib = native.bind(library_path)
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS + LOADER_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = Original(pe)

    # ---- A. loader parity ------------------------------------------------------------
    corpus_bodies, corpus_doc = ensure_corpus()
    live = live_s6453_row(library_path)
    loader_cases = run_loader_parity(pe, lib, corpus_bodies, live)

    # ---- B. runtime ------------------------------------------------------------------
    triples = sorted({struct.unpack('<3H', body[:6]) for body in corpus_bodies})
    corpus_triples = list(triples)
    live_triple = struct.unpack('<3H', live['typed'][:6])
    rng = random.Random(0x78)
    synthetic_words = [0xffff, 0xfffe, 0x8000, 0x7fff, 70, 255, 69, 0, 1, 33]
    synthetic = [(w, t, s) for w in synthetic_words for (t, s) in flag_decoys()[:7]]
    for word in (0, 5, 33, 69, 40):
        for take, swap in flag_decoys():
            synthetic.append((word, take, swap))
    groups = [('corpus', corpus_triples), ('live-S6453', [live_triple]), ('synthetic', synthetic)]
    rows = [0, 3, 4, 15, 16, 39, 119, 239]
    seed = cases = false_gate = rejected_observed = rebuild_domain_parity = 0
    sequences, footprints, per_group, unsafe_by_reason = {}, {}, {}, {}
    per_case_budget = 8 if quick else 26
    for group, triple_list in groups:
        per_group[group] = 0
        for word, take, swap in triple_list:
            pool = scenarios(rng, word, take, swap)
            rng.shuffle(pool)
            for items, count, held in pool[:per_case_budget]:
                mode, slot_flag = rng.choice(VIEW_MODES)
                gate = 'false' if seed % 11 == 4 else 'true'
                case = make_case(seed, rows[seed % len(rows)], word, take, swap, gate, items, count,
                                 held, mode, slot_flag)
                seed += 1
                got = None
                if gate == 'true':
                    safe, reason = simulate(case)
                    if not safe:
                        # Unsafe for the original (it would read or write outside the modeled
                        # arrays): not a parity target. The native kernel must reject it
                        # before any effect.
                        case['list_words'] = list(case['items']) + [0xffff] * (CAPACITY - len(case['items']))
                        mine = run_native(lib, case)
                        if mine['status'] != native.BOUNDS or mine['events'][1:]:
                            raise OracleError(('native accepted or acted on an unsafe case', reason, case,
                                               mine['status'], mine['events']))
                        rejected_observed += 1
                        unsafe_by_reason[reason] = unsafe_by_reason.get(reason, 0) + 1
                        continue
                    if reason == REBUILD_DOMAIN:
                        # Valid for the kernel; the original's real rebuild may read memory
                        # outside its item type table. Attempt the parity run; a Unicorn
                        # fault is reported, not failed.
                        try:
                            got = compare(lib, original, case)
                        except OracleError:
                            raise
                        except Exception as error:
                            unsafe_by_reason[REBUILD_DOMAIN + ' (original faulted: ' +
                                             type(error).__name__ + ')'] = \
                                unsafe_by_reason.get(REBUILD_DOMAIN + ' (original faulted: ' +
                                                     type(error).__name__ + ')', 0) + 1
                            continue
                        rebuild_domain_parity += 1
                if got is None:
                    got = compare(lib, original, case)
                cases += 1
                per_group[group] += 1
                false_gate += gate == 'false'
                key = ','.join(e[0] for e in got['events'])
                sequences[key] = sequences.get(key, 0) + 1
                for name in got['footprint']:
                    footprints[name] = footprints.get(name, 0) + 1

    parity_hooks = dict(sorted(original.hook_counts.items()))
    unsafe = observe_unsafe(lib, original)

    report = dict(
        slice='RT-19',
        scope='dispatcher arm 0x42944b through 0x4eaadc/0x4e8d96/0x4e9e84/0x4ea06c and the real '
              '0x4e812f and 0x4e0559; stop 0x42a9a9; loader 0x40b34a arm 0x40e56a constructor 0x4e9c2f',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        live_s6453_sha256=LIVE_S6453_HASH, live_row4_object=list(live_triple),
        corpus_rows=len(corpus_bodies), corpus_distinct_objects=len(corpus_triples),
        corpus_source='CIFTREE.DAT resources through the production parser (RT-19.corpus.json)',
        loader_cases=loader_cases,
        cases=cases, cases_by_input_group=per_group, false_gate_cases=false_gate,
        true_gate_cases=cases - false_gate, mismatches=0,
        unsafe_cases_rejected_by_native=rejected_observed, unsafe_cases_by_reason=unsafe_by_reason,
        rebuild_domain_cases_with_parity=rebuild_domain_parity,
        event_sequences=dict(sorted(sequences.items())),
        write_footprint_classes=dict(sorted(footprints.items())),
        hooks_parity_cases=parity_hooks,
        hooks_including_unsafe_observations=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='only 0x423f57 in the false-gate cases and the 0x4fb2e3 host boundary; '
                                    'true-gate cases run the real evaluator on an empty tree',
        compared='ordered merged event log; every modeled cell; completion byte; rebuild-entry snapshot; '
                 'sound request argument; UI animation arguments and its two stores; write footprint; '
                 'callee-saved registers and stack balance; per-case result counters',
        unsafe_original_observations=unsafe,
        unverified=['non-empty dependency tree evaluation (shared kernel; native session tests only)',
                    'what 0x4e812f derives (0x583a2d/2f, 0x583abd, 0x583b49, view object): runs but is not modeled',
                    'what 0x4fb2e3 does after the request (slot trigger word, mixer service): replaced, host effect',
                    'what the UI animation cells 0x5a1958/0x5a195c drive (button rendering): stores observed, not modeled',
                    'view mode 2 / slot flag reachability in play (the native app never opens the inventory view)',
                    'dispatcher loop ordering around the arm (executor tests)',
                    'external-CIF scenes other than S6453 / S6400'],
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('cases', 'true_gate_cases', 'false_gate_cases',
                                             'unsafe_cases_rejected_by_native', 'loader_cases',
                                             'mismatches', 'seconds')}))
    return report


def observe_unsafe(lib, original):
    """Unsafe original behaviour: observed, never a parity target. Native rejects."""
    unsafe = []

    def one(label, word, take, swap, items, count, held, presence_hint=None, mode=0, slot_flag=0):
        case = make_case(10_000 + len(unsafe), 3, word, take, swap, 'true', items, count, held, mode, slot_flag)
        try:
            got = original.run(case, strict=False)
            observed = dict(
                original_completed=got['completed'],
                original_reads_past_item_array=len(got['reads_beyond']),
                original_stores_outside_every_known_cell=sorted(
                    {hex(a) for a, size, _ in got['writes'] if original.footprint_class(a, size) is None})[:6],
                original_events=[e[0] for e in got['events']])
        except Exception as error:  # Unicorn raises UcError for an unmapped access
            observed = dict(original_result=type(error).__name__ + ': ' + str(error))
        mine = run_native(lib, case)
        if mine['status'] != native.BOUNDS or mine['events'][1:]:
            raise OracleError(('native accepted an unsafe case', label, mine['status']))
        observed.update(label=label, native_status='ACTION78_ERR_BOUNDS',
                        native_reason=(mine['why'] or b'').decode(), native_effects=0)
        unsafe.append(observed)

    one('plain add of an id above the presence array', 100, 0, 0, [4, 5], 2, -1)
    one('plain add of a negative id', 0xfffe, 0, 0, [4, 5], 2, -1)
    one('plain add into a full inventory', 9, 0, 0, [i for i in range(10, 80)], 70, -1)
    one('plain add with a count above the item array', 5, 0, 0, [4], 75, -1)
    one('plain add with a count below minus one', 5, 0, 0, [4, 6], -2, -1)
    one('take of a listed id above the presence array', 100, 1, 0, [4, 100], 2, -1)
    one('swap whose put back has no room', 6, 1, 1, [i for i in range(10, 80)], 70, 9)
    one('late rejection: swap put back works, the take cannot remove', 100, 1, 1, [4, 100], 2, 9)
    return unsafe


# ------------------------------------------------------------------ loader machine
class Loader:
    """The original loader switch head 0x40b34a through the 0x78 arm, stopped at 0x410a68."""
    STOP = 0x410a68
    INPUT, DATA, STK = 0x20000000, 0x30000000, 0x5800
    OUT = DATA + 0x5000
    ALLOCATOR = 0x51dc43

    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
        from unicorn import x86_const as x
        self.r = {name: getattr(x, 'UC_X86_REG_' + name) for name in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(0x1000, 0x10000)
        self.uc.mem_map(self.INPUT, 0x20000)
        self.uc.mem_map(self.DATA, 0x10000)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations, self.sizes = 0, {}
        self.source_span = (0, 0)
        self.seed = bytes(6)
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=self.ALLOCATOR, end=self.ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=self.INPUT, end=self.INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=self.OUT - 16, end=self.OUT + 23)

    def observe_read(self, _uc, _access, address, size, _value, _data):
        if address < self.source_span[0] or address + size > self.source_span[1]:
            raise OracleError(f'original read outside exact fixture at {address:#x}, size {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        if address < self.OUT or address + size > self.OUT + 6:
            raise OracleError(f'original write outside the six-byte allocation at {address:#x}')

    def allocate(self, uc, address, _size, _data):
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        if size != 6:
            raise OracleError(f'unexpected original allocation size {size}')
        uc.mem_write(self.OUT - 16, b'\xa5' * 16 + self.seed + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], self.OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] = self.sizes.get(size, 0) + 1

    def invoke(self, body, seed, subtype, payload_offset=50):
        uc, r = self.uc, self.r
        self.seed = seed
        payload = b'Add Inventory Item, No Hot Spot'.ljust(48, b'\0') + bytes([0x78, subtype]) + body
        body_va = self.INPUT + 16 + 50
        self.source_span = (self.INPUT + 16, self.INPUT + 16 + len(payload))
        uc.mem_write(self.INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        owner = 0x571442
        uc.mem_write(owner - 16, b'\x91' * 16 + b'\x5a' * 0x100 + b'\x92' * 16)
        if bytes(uc.mem_read(0x63a4cd, 2)) != bytes(2):
            raise OracleError('pinned diagnostic flag is nonzero')
        uc.mem_write(0x5c39e3, bytes(2))
        uc.mem_write(0x5bb5b3, bytes(0x8d))
        args = (self.INPUT + 16, len(payload))
        stack_args = struct.pack('<III', self.STOP, *args)
        uc.mem_write(self.STK - 0x1000, b'\x3c' * 16)
        uc.mem_write(self.STK + 32, b'\x7e' * 16)
        uc.mem_write(self.STK, stack_args)
        initial = dict(EAX=0x11111111, EBX=0x22222222, ECX=owner, EDX=0x33333333,
                       ESI=0x44444444, EDI=0x55555555, EBP=0x66666666)
        for name, value in initial.items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ESP'], self.STK)
        uc.reg_write(r['EFLAGS'], 0x202)
        before = self.allocations
        uc.emu_start(0x40b34a, self.STOP, count=1000000)
        if uc.reg_read(r['EIP']) != self.STOP or self.allocations != before + 1:
            raise OracleError('original did not reach the boundary with one allocation')
        ebp = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(ebp - 0x20, 4))[0]
        offset = struct.unpack('<I', uc.mem_read(ebp - 0xcc, 4))[0]
        table = bytes(uc.mem_read(0x5bb5b3, 0x8d))
        name_bytes = payload[:48].index(0) + 1
        expected = bytearray(0x8d)
        expected[:name_bytes] = payload[:name_bytes]
        expected[48:50] = bytes([0x78, subtype])
        expected[50:54] = struct.pack('<I', self.OUT)
        if table != bytes(expected):
            raise OracleError('original runtime type/subtype/table effect mismatch')
        for address, value in ((self.OUT - 16, b'\xa5' * 16), (self.OUT + 6, b'\xd7' * 16),
                               (self.INPUT + 16, payload)):
            if bytes(uc.mem_read(address, len(value))) != value:
                raise OracleError(f'original guard or input changed at {address:#x}')
        return bytes(uc.mem_read(self.OUT, 6)), cursor - body_va, offset


def run_loader_parity(pe, lib, corpus_bodies, live):
    loader = Loader(pe)
    rng = random.Random(0x4e9c2f)
    bodies = list(dict.fromkeys(corpus_bodies))          # distinct typed bodies
    bodies.append(live['typed'])
    for _ in range(300):
        bodies.append(bytes(rng.randrange(256) for _ in range(6)))
    bodies += [bytes(6), b'\xff' * 6, bytes([0xff, 0xff, 0, 0, 1, 0]), bytes([0x00, 0x80, 0, 1, 0, 1])]
    count = 0
    for index, body in enumerate(bodies):
        for tail in (b'', bytes(rng.randrange(256) for _ in range(16))):
            subtype = rng.choice((0, 1, 2, 3, 255))
            seed = bytes(rng.randrange(256) for _ in range(6))
            original, advance, offset = loader.invoke(body + tail, seed, subtype)
            if advance != 6 or offset != 56:
                raise OracleError(('original cursor/body rule mismatch', index, advance, offset))
            if original != body:
                raise OracleError(('original object differs from the typed body', index))
            obj = native.Object78()
            if lib.action78_object_from_body(body + tail, len(body + tail), c.byref(obj)) != native.OK:
                raise OracleError(('native decoder rejected', index))
            if struct.pack('<HHH', obj.item_word, obj.take_flag, obj.swap_flag) != original:
                raise OracleError(('native object differs from the original object', index))
            count += 1
    return count


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--quick', action='store_true')
    arguments = parser.parse_args()
    main(report_path=arguments.report, quick=arguments.quick)
