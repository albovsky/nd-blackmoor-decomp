#!/usr/bin/env python3
"""RT-16: original-x86 oracle for the raw 0x0b "scene change" hotspot runtime.

Runs the unmodified original under Unicorn and compares it, step by step, with
the native loader/kernel/binding/session:

  A. the loader arm 0x40b7d4 itself (payload construction from the 24-byte
     typed body: every payload byte, the row pointer cell, the source and
     counter advance, reads inside the body) against action0b_load, for all
     1,275 corpus bodies and random/boundary bodies;
  B. the dispatcher 0x427a50 itself (prologue skips, request clear, type switch
     via the real map 0x42aba4 and jump table 0x42a9b4, arm 0x427ba4, the real
     dependency gate 0x423f57, the real handler 0x42ae73, the loop join and the
     mode-4 loop exit) against the native SESSION (executor + pre-gate +
     binding + kernel) on multi-row scenes with decoy rows (done rows, raw
     0x17 rows), over multi-pass sequences with selector changes, gate flips
     and accepted candidates (the 0x43bfb6 phase-2 store). The row payloads of
     the original side come from the original loader arm, not from the native
     loader;
  C. the same dispatcher against the native KERNEL for every runtime type the
     handler 0x42ae73 serves (0x0b, 0x0d, 0x0e..0x14: gate mode compared with
     the native executor table) and phases 0, 1, 2 and the no-effect phases;
  D. the generic row loop of the pointer cascade 0x4f0059 (0x4f1eb8..0x4f257b,
     which includes the type-0x0b case 0x4f221e): first hit, candidate, cursor
     index/variant/flag/table/surface against session_input_scan plus the
     native hover cursor.

Hooks (every one is enumerated in the report; none replaces a decision the
original makes except the first two, which stand in for the host):

  replacement  0x423f57 dependency gate ONLY for rows the case declares
               false-gate: EAX=0, pop two arguments. True-gate rows run the
               real evaluator on an empty tree (it returns 1).
  replacement  0x51dc43 allocator (the CRT operator new) during the loader
               runs: EAX = a fresh object in a mapped test region.
  observation  code entry of 0x427a50 / 0x423f57 (arguments) / 0x42ae73 /
               0x42b07e, every memory write of the address space (classified
               into the modeled cells, the gate bookkeeping, the loader's
               payload/row-pointer and the stack), reads of the row body
               objects (any read beyond an object is an error),
               register/stack state at the stop.
  stub         the return address (a single RET page) is the only code outside
               the executable.

Compared after every pass: the ORDERED stream of writes to the modeled cells
(merged with the dependency-gate calls and their mode argument), every row
cell (completion, request, rectangle words, phase), every world cell
(0x5bb1ca, 0x583999 and the seven scene-change cells), callee-saved registers
and stack balance. The original's complete write footprint must stay inside the
modeled cells, the gate bookkeeping, the loader's outputs and the stack.

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/action_family_0b_runtime_original_oracle.py
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import subprocess
import sys
import time

from cif_original_oracle import PEImage, align_up
import session_binding_support as session
import test_action_family_0b_runtime as native
import test_action_family_17_runtime as t17
import test_scene_session_pointer as pointer

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-16.oracle.json'
CORPUS = ROOT / 'work/analysis/slices/RT-16.corpus.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

CODE_WINDOWS = [
    (0x40b7d4, 0x40b98f, 'loader arm for raw 0x0b 0x40b7d4',
     '0a5722b6c89bc4dd1b82dac573827fa6e0135b81f8816f306ed321bbae672900'),
    (0x410ca4, 0x410e9c, 'loader jump table 0x410ca4',
     'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x410e9c, 0x410f8a, 'loader type map 0x410e9c',
     'b02db4fa2f62414827503d71dff0159917037ae49ba6d47dee50ff7941cbc7a6'),
    (0x427a50, 0x427b33, 'dispatcher prologue and type switch 0x427a50',
     '1c4502762e5132191098c486266e2643fc259cd7d9533ebea773a0662ca5d42e'),
    (0x427b33, 0x427b6b, 'dispatcher arm 0x0d (gate mode 1)',
     '863e222bb5a1e1e286372ea4dae3d075bec118faa82e8dce63b724bed44842cf'),
    (0x427b6b, 0x427ba4, 'dispatcher arm 0x0e..0x14 (gate mode 0)',
     '5f2d0cde74ae1ed75a888d2b6b6d1d8e830c77a3a1833ef4ef3540b64cfd10e4'),
    (0x427ba4, 0x427bdd, 'dispatcher arm 0x0b (gate mode 1)',
     'd9ac9bad54ce70e3beab27fbd373ed0f0fa6e48a6b1906e3febbd562b84f3235'),
    (0x427bdd, 0x427c4e, 'dispatcher arms 0x16..0x19 (decoy rows)',
     '2018b68ba51bb564dd166deebbda630136d048309cc10655b3250fda61f125a6'),
    (0x42a9a9, 0x42a9b4, 'dispatcher loop join and epilogue',
     'c542a2c75f291cf8ee9d05f425537a3ffd1f9bc33d439b9ab2b4036a83a560a3'),
    (0x42ae73, 0x42b07e, 'handler 0x42ae73',
     '48d63750bd18989845fc3046817967c1cdc8f192d2590a803121d7bce5f374f6'),
    (0x42b07e, 0x42b2e4, 'handler 0x42b07e (decoy rows)',
     'b88ed7735c97e51ccc9c5d0354d8c3749cc1adcc4e3ca03ec39d4d7e92bf23f8'),
    (0x42a9b4, 0x42aba4, 'dispatcher jump table 0x42a9b4',
     '6339877da46c0c1a66738bb918087a2cd4c0ceab39811427da4dff64f5c8f8da'),
    (0x42aba4, 0x42ac91, 'dispatcher type map 0x42aba4',
     '7d726256e7d84d38c7d1677a579c09be3e2133becfbed78350302c683bec2d2e'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57',
     '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8',
     'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4f1eb8, 0x4f257c, 'pointer cascade generic row loop 0x4f1eb8',
     '5d6cc6ee1cad1b8ab009d067c780861587598a2087191eca62fdc2d5b01e2395'),
    (0x4f257c, 0x4f25a0, 'cascade cursor jump table',
     'c48023991e29570ea72618c1f09e79e8af229aa91ea163182b0a83a1a25d7358'),
    (0x4f25a0, 0x4f2610, 'cascade cursor type map',
     'c19a7e454d4df17d72f993955310e08a7d8a7387b008cd80f0551c8e9d650088'),
    (0x40b2d0, 0x40b34a, 'cursor index map 0x40b2d0',
     '0c1bd444697f81002521c0fd82eab1b2cf8ba8e5388126794b354d8411c59222'),
]

STACK, STACK_SIZE = 0x10000000, 0x40000
OBJ_BASE, OBJ_SIZE, OBJ_STRIDE = 0x30000000, 0x100000, 0x1000
STUBS = 0x31000000
STUB_RET = STUBS + 0x10
THIS_OBJ = 0x32000000
ALLOC_BASE, ALLOC_SIZE = 0x33000000, 0x10000
FRAME = STACK + 0x30000
ROW_BASE, ROW_STRIDE = 0x5bb5e3, 0x8d
GATE_OBJECT, GATE_FLAG = 0x63786d, 0x5c3a47
COUNT_WORD, MODE_CELL, SELECTOR_CELL = 0x5c39e3, 0x583999, 0x5bb50b
LOADER_ARM, LOADER_JOIN, ALLOCATOR = 0x40b7d4, 0x410a68, 0x51dc43
LOADER_SRC_ROW = 240
WORLD_CELLS = {
    0x5bb1ca: ('start_flag', 4), 0x583999: ('mode', 4),
    0x5bb57b: ('xfer_5bb57b', 4), 0x5bb599: ('xfer_5bb599', 2), 0x5bb595: ('xfer_5bb595', 2),
    0x5c39ff: ('xfer_5c39ff', 2), 0x5bb59b: ('xfer_5bb59b', 4), 0x5bb59f: ('xfer_5bb59f', 4),
    0x5bb5a3: ('xfer_5bb5a3', 4),
}
ROW_CELLS = {0x42: ('done', 1), 0x43: ('request', 4), 0x47: ('left', 2), 0x49: ('top', 2),
             0x4b: ('right', 2), 0x4d: ('bottom', 2), 0x4f: ('phase', 4)}
XFER = ('xfer_5bb57b', 'xfer_5bb599', 'xfer_5bb595', 'xfer_5c39ff', 'xfer_5bb59b', 'xfer_5bb59f',
        'xfer_5bb5a3')
SIGNED = {1: '<B', 2: '<h', 4: '<i'}
CURSOR_CELLS = {
    'cursor_index': (0x5b44f0, 4), 'cursor_variant': (0x5b44f4, 4), 'item_flag': (0x5b44f8, 4),
    'cursor_surface': (0x5d162d, 4), 'cursor_table': (0x5d1631, 4), 'cursor_layer': (0x5d1639, 4),
    'candidate': (0x5c39e5, 4),
}
CURSOR_INPUT = {'held_item': (0x583a29, 2), 'surface_default': (0x5d0377, 4),
                'surface_held': (0x571ad3, 4), 'excluded_0': (0x5b4e89, 2),
                'excluded_1': (0x5b5100, 2)}
CURSOR_TABLE_BASE = 0x5b160c


class OracleError(AssertionError):
    pass


def sha(data):
    return hashlib.sha256(data).hexdigest()


def obj_va(row):
    return OBJ_BASE + row * OBJ_STRIDE


def row_va(row, offset):
    return ROW_BASE + row * ROW_STRIDE + offset


def s(value, size):
    return struct.unpack(SIGNED[size], (value & ((1 << (8 * size)) - 1)).to_bytes(size, 'little'))[0]


def wrap_s16(value):
    value &= 0xffff
    return value - 0x10000 if value >= 0x8000 else value


class Original:
    def __init__(self, pe):
        from unicorn import (Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_WRITE,
                             UC_HOOK_MEM_READ)
        from unicorn import x86_const as x
        self.regs = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                     ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(STACK, STACK_SIZE)
        self.uc.mem_map(OBJ_BASE, OBJ_SIZE)
        self.uc.mem_map(THIS_OBJ, 0x1000)
        self.uc.mem_map(STUBS, 0x1000)
        self.uc.mem_map(ALLOC_BASE, ALLOC_SIZE)
        self.uc.mem_write(STUB_RET, b'\xc3')
        self.hook_counts = {}
        self.events = []
        self.writes = []
        self.reads_beyond = []
        self.body_lengths = {}
        self.false_rows = set()
        self.nrows = 0
        self.gate_calls = []
        self.alloc_next = 0
        for address in (0x427a50, 0x423f57, 0x42ae73, 0x42b07e, ALLOCATOR):
            self.uc.hook_add(UC_HOOK_CODE, self.on_code, begin=address, end=address)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.on_write)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.on_read, begin=OBJ_BASE, end=OBJ_BASE + OBJ_SIZE - 1)

    # -- helpers
    def read(self, address, size):
        return bytes(self.uc.mem_read(address, size))

    def cell(self, address, size):
        return struct.unpack(SIGNED[size], self.read(address, size))[0]

    def put(self, address, size, value):
        self.uc.mem_write(address, (value & ((1 << (8 * size)) - 1)).to_bytes(size, 'little'))

    def count(self, name):
        self.hook_counts[name] = self.hook_counts.get(name, 0) + 1

    # -- hooks
    def on_code(self, uc, address, size, user):
        esp = uc.reg_read(self.regs['ESP'])
        if address == 0x427a50:
            self.count('observe 0x427a50 dispatcher entry')
        elif address == 0x423f57:
            pointer_arg, mode = struct.unpack('<II', self.read(esp + 4, 8))
            row = (pointer_arg - row_va(0, 6)) // ROW_STRIDE
            self.events.append(('gate', row, mode))
            if row in self.false_rows:
                self.count('REPLACE 0x423f57 dependency gate (false-gate rows only)')
                ret = struct.unpack('<I', self.read(esp, 4))[0]
                uc.reg_write(self.regs['EAX'], 0)
                uc.reg_write(self.regs['ESP'], esp + 12)
                uc.reg_write(self.regs['EIP'], ret)
            else:
                self.count('observe 0x423f57 dependency gate (real code, empty tree)')
        elif address == 0x42ae73:
            self.count('observe 0x42ae73 handler entry')
            self.events.append(('handler', struct.unpack('<h', self.read(esp + 4, 2))[0]))
        elif address == 0x42b07e:
            self.count('observe 0x42b07e handler entry (decoy raw 0x17 rows)')
            self.events.append(('handler', struct.unpack('<h', self.read(esp + 4, 2))[0]))
        elif address == ALLOCATOR:
            self.count('REPLACE 0x51dc43 allocator (loader runs only)')
            ret = struct.unpack('<I', self.read(esp, 4))[0]
            uc.reg_write(self.regs['EAX'], ALLOC_BASE + self.alloc_next)
            self.alloc_next += 0x100
            uc.reg_write(self.regs['ESP'], esp + 4)
            uc.reg_write(self.regs['EIP'], ret)

    def classify(self, address, size):
        if address in WORLD_CELLS and WORLD_CELLS[address][1] == size:
            return WORLD_CELLS[address][0], -1
        offset = address - ROW_BASE
        if 0 <= offset < self.nrows * ROW_STRIDE:
            row, within = divmod(offset, ROW_STRIDE)
            if within in ROW_CELLS and ROW_CELLS[within][1] == size:
                return ROW_CELLS[within][0], row
        return None

    def on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        self.writes.append((address, size, value))
        kind = self.classify(address, size)
        if kind is not None:
            name, row = kind
            self.events.append(('w', name, row, s(value, size)))

    def on_read(self, uc, access, address, size, value, user):
        row = (address - OBJ_BASE) // OBJ_STRIDE
        length = self.body_lengths.get(row)
        if length is None or address + size > obj_va(row) + length:
            self.reads_beyond.append((address, size))

    def footprint_class(self, address, size):
        end = address + size
        if self.classify(address, size) is not None:
            return 'modeled cells'
        for start, length in ((GATE_OBJECT + 4, 4), (GATE_OBJECT + 0x614, 4), (GATE_FLAG, 4)):
            if start <= address and end <= start + length:
                return 'gate bookkeeping'
        if STACK <= address and end <= STACK + STACK_SIZE:
            return 'stack'
        return None

    def check_footprint(self):
        classes = set()
        for address, size, _ in self.writes:
            name = self.footprint_class(address, size)
            if name is None:
                raise OracleError(f'original write outside the allowed footprint: {address:#x}/{size}')
            classes.add(name)
        return classes

    # -- the loader arm 0x40b7d4
    def run_loader(self, body, row, rng, declared_length=None):
        """Run the original loader arm for raw 0x0b on `body` for table row `row`.
        Returns the payload object bytes (0x28) and the loader bookkeeping."""
        uc, r = self.uc, self.regs
        self.writes, self.events, self.reads_beyond = [], [], []
        self.nrows = 0
        self.alloc_next = 0
        uc.mem_write(ALLOC_BASE, bytes([0xa5]) * ALLOC_SIZE)
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(COUNT_WORD, 2, row)
        src = obj_va(LOADER_SRC_ROW)
        uc.mem_write(src, bytes([0x5a]) * OBJ_STRIDE)
        uc.mem_write(src, body)
        self.body_lengths = {LOADER_SRC_ROW: len(body) if declared_length is None else declared_length}
        uc.mem_write(STACK, bytes(STACK_SIZE))
        ebp = FRAME
        counter = rng.randrange(0x1000, 0x2000)
        self.put(ebp - 0x20, 4, src)
        self.put(ebp - 0xcc, 4, counter)
        for name in ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI'):
            uc.reg_write(r[name], rng.randrange(2 ** 32))
        uc.reg_write(r['EBP'], ebp)
        uc.reg_write(r['ESP'], ebp - 0x300)
        uc.reg_write(r['EFLAGS'], 0x202)
        uc.emu_start(LOADER_ARM, LOADER_JOIN, count=100000)
        if uc.reg_read(r['EIP']) != LOADER_JOIN:
            raise OracleError('loader arm did not reach the loop join')
        pointer_cell = self.cell(row_va(row, 2), 4)
        if pointer_cell != ALLOC_BASE:
            raise OracleError(('loader stored an unexpected payload pointer', hex(pointer_cell)))
        payload = self.read(ALLOC_BASE, 0x28)
        written = set()
        for address, size, _ in self.writes:
            if ALLOC_BASE <= address < ALLOC_BASE + 0x28:
                if address + size > ALLOC_BASE + 0x28:
                    raise OracleError('loader write beyond the 0x28-byte payload')
                written.update(range(address - ALLOC_BASE, address - ALLOC_BASE + size))
            elif address == row_va(row, 2) and size == 4:
                pass
            elif STACK <= address and address + size <= STACK + STACK_SIZE:
                pass
            else:
                raise OracleError(f'loader write outside payload/row pointer/stack: {address:#x}/{size}')
        if written != set(range(0x28)):
            raise OracleError(('loader did not write every payload byte', sorted(set(range(0x28)) - written)))
        advance = (self.cell(ebp - 0xcc, 4) - counter, self.cell(ebp - 0x20, 4) - src)
        return payload, advance, bool(self.reads_beyond)

    # -- scene setup
    def load_scene(self, rows, rng, world):
        """rows: dicts type, obj (bytes of the row object), done. Clears the row table first."""
        uc = self.uc
        self.nrows = len(rows)
        self.body_lengths = {}
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(COUNT_WORD, 2, len(rows))
        self.put(MODE_CELL, 4, 3)
        for row, spec in enumerate(rows):
            self.put(row_va(row, 0), 1, spec['type'])
            self.put(row_va(row, 1), 1, spec.get('subtype', 1))
            obj = spec.get('obj', b'')
            uc.mem_write(obj_va(row), bytes([0xa5]) * OBJ_STRIDE)
            uc.mem_write(obj_va(row), obj)
            self.body_lengths[row] = len(obj)
            self.put(row_va(row, 2), 4, obj_va(row))
            uc.mem_write(row_va(row, 6), struct.pack('<II', rng.randrange(2 ** 32), 0))
            self.put(row_va(row, 0x42), 1, 1 if spec.get('done') else 0)
        for name, value in world.items():
            address = next(a for a, (n, _) in WORLD_CELLS.items() if n == name)
            self.put(address, WORLD_CELLS[address][1], value)
        uc.mem_write(GATE_OBJECT, bytes(rng.randrange(256) for _ in range(0x700)))
        uc.mem_write(GATE_FLAG, struct.pack('<I', 0x12345678))
        uc.mem_write(STACK, bytes(STACK_SIZE))

    def snapshot(self):
        rows = []
        for row in range(self.nrows):
            rows.append(tuple(self.cell(row_va(row, off), size) for off, (name, size) in sorted(ROW_CELLS.items())))
        world = {name: self.cell(address, size) for address, (name, size) in WORLD_CELLS.items()}
        return rows, world

    def run_dispatcher(self, rng):
        uc, r = self.uc, self.regs
        self.events, self.writes, self.reads_beyond = [], [], []
        self.put(MODE_CELL, 4, 3)
        initial = dict(EAX=rng.randrange(2 ** 32), EBX=rng.randrange(2 ** 32), ECX=rng.randrange(2 ** 32),
                       EDX=rng.randrange(2 ** 32), ESI=rng.randrange(2 ** 32), EDI=rng.randrange(2 ** 32),
                       EBP=rng.randrange(2 ** 32))
        for name, value in initial.items():
            uc.reg_write(r[name], value)
        esp = FRAME - 0x800
        uc.mem_write(esp, struct.pack('<I', STUB_RET))
        uc.reg_write(r['ESP'], esp)
        uc.reg_write(r['EFLAGS'], 0x202)
        uc.emu_start(0x427a50, STUB_RET, count=2000000)
        if uc.reg_read(r['EIP']) != STUB_RET:
            raise OracleError('dispatcher did not return')
        for name in ('EBX', 'ESI', 'EDI', 'EBP'):
            if uc.reg_read(r[name]) != initial[name]:
                raise OracleError(f'callee-saved {name} changed')
        if uc.reg_read(r['ESP']) != esp + 4:
            raise OracleError('dispatcher left the stack unbalanced')
        if self.reads_beyond:
            raise OracleError(('original read beyond a row body', self.reads_beyond[:3]))
        classes = self.check_footprint()
        rows, world = self.snapshot()
        return dict(events=list(self.events), rows=rows, world=world, classes=classes)

    # -- the cascade fragment
    def run_cascade(self, case, rng):
        """0x4f1eb8..: the generic row loop with a pre-transformed pointer."""
        uc, r = self.uc, self.regs
        self.nrows = len(case['rows'])
        self.writes, self.events, self.reads_beyond = [], [], []
        self.body_lengths = {}
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(COUNT_WORD, 2, len(case['rows']))
        for row, spec in enumerate(case['rows']):
            self.put(row_va(row, 0), 1, spec['type'])
            self.put(row_va(row, 0x43), 4, spec['request'])
            for off, value in zip((0x47, 0x49, 0x4b, 0x4d), spec['rect']):
                self.put(row_va(row, off), 2, value)
            if 'payload' in spec:
                uc.mem_write(obj_va(row), spec['payload'])
                self.body_lengths[row] = len(spec['payload'])
                self.put(row_va(row, 2), 4, obj_va(row))
        for name, (address, size) in CURSOR_CELLS.items():
            self.put(address, size, case['initial'][name])
        for name, (address, size) in CURSOR_INPUT.items():
            self.put(address, size, case['inputs'][name])
        uc.mem_write(THIS_OBJ, bytes(0x1000))
        self.put(THIS_OBJ + 0x5a, 4, case['y'])
        self.put(THIS_OBJ + 0x5e, 4, case['x'])
        uc.mem_write(STACK, bytes(STACK_SIZE))
        ebp = FRAME
        uc.mem_write(ebp - 4, struct.pack('<I', THIS_OBJ))
        uc.mem_write(ebp, struct.pack('<II', 0, STUB_RET))
        for name in ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI'):
            uc.reg_write(r[name], rng.randrange(2 ** 32))
        uc.reg_write(r['EBP'], ebp)
        uc.reg_write(r['ESP'], ebp - 0x200)
        uc.reg_write(r['EFLAGS'], 0x202)
        uc.emu_start(0x4f1eb8, STUB_RET, count=2000000)
        if uc.reg_read(r['EIP']) != STUB_RET:
            raise OracleError('cascade fragment did not return')
        if self.reads_beyond:
            raise OracleError(('cascade read beyond a payload', self.reads_beyond[:3]))
        result = {name: self.cell(address, size) for name, (address, size) in CURSOR_CELLS.items()}
        result['return'] = uc.reg_read(r['EAX'])
        written = {name for name, (address, size) in CURSOR_CELLS.items()
                   if any(a == address for a, _, _ in self.writes)}
        return result, written


# ----------------------------------------------------------------- native side

def action_bytes(spec, flag):
    if spec['type'] == 0x61:
        return session.action(0x61, 1, session.i16(15) + session.i16(1) + session.i16(-1) +
                              session.i16(0))
    return session.action(spec['type'], spec.get('subtype', 1), spec['body'], (session.flag_gate(flag),))


class NativeSession:
    def __init__(self, lib, rows, rng, world):
        self.lib, self.rows = lib, rows
        self.rig = t17.Rig17(selector=0)
        self.rig.start_flag = world['start_flag']
        self.rig.lib = lib
        self.scene, self.owner = session.open_scene(lib, [action_bytes(r, i + 1) for i, r in enumerate(rows)])
        self.flags, self.core, self.conditions = session.make_world()
        # One host serves both bindings, so the effect stream keeps the dispatch order.
        self.binding_0b = lib.session_a0b_create(c.byref(self.rig.host))
        self.binding_17 = lib.session_a17_create(c.byref(self.rig.host))
        if not self.binding_0b or not self.binding_17 or \
                lib.session_a0b_begin_scene(self.binding_0b, self.scene) != 0 or \
                lib.session_a17_begin_scene(self.binding_17, self.scene) != 0:
            raise OracleError('native binding refused the scene')
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler_0b = session.ActionFn(('session_a0b_handler', lib))
        handler_17 = session.ActionFn(('session_a17_handler', lib))
        self.bindings = (session.Binding * 3)(session.Binding(0x0b, 11, handler_0b, self.binding_0b),
                                              session.Binding(0x17, 11, handler_17, self.binding_17),
                                              session.Binding(0x16, 11, handler_17, self.binding_17))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6403,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=3, prepare_tick=prepare,
            advance_media_one=media)
        if lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                                    c.byref(session.SceneSessionFailure())) != 0:
            raise OracleError('native session refused the scene')
        for runtime_type, fn, binding in ((0x0b, lib.session_a0b_pre_gate, self.binding_0b),
                                          (0x17, lib.session_a17_pre_gate, self.binding_17),
                                          (0x16, lib.session_a17_pre_gate, self.binding_17)):
            if lib.scene_session_set_pre_gate(self.session, runtime_type, c.cast(fn, c.c_void_p),
                                              binding) != 0:
                raise OracleError('pre-gate registration failed')
        self.rig.session = self.session
        self.keep = (prepare, media, handler_0b, handler_17)
        self.transitioned = False

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a0b_destroy(self.binding_0b)
        self.lib.session_a17_destroy(self.binding_17)
        self.lib.scene_resource_close(self.scene)

    def pass_(self, selector, gates, accept):
        lib = self.lib
        self.rig.selector = selector
        for row, ok in enumerate(gates):
            self.flags[row + 1] = 1 if ok else 0
        if accept is not None and lib.scene_session_accept_action_candidate(self.session, accept) != 0:
            raise OracleError('native refused the candidate')
        self.rig.effects.clear()
        out = session.SceneSessionTickResult()
        status = lib.scene_session_tick(self.session, c.byref(out))
        if status not in (session.SESSION_OK, session.SESSION_TRANSITION):
            raise OracleError(('native tick failed', status, out.failure.action_index))
        events, seen = [], set()
        world_names = {n for n, _ in WORLD_CELLS.values()}
        for row, name, value in self.rig.effects:
            events.append(('w', name, -1 if name in world_names else row, value))
            if row not in seen:
                seen.add(row)       # the first event of a visit is the prologue request clear
                runtime_type = self.rows[row]['type']
                events.append(('gate', row, lib.scene_conditions_gate_mode_for_type(runtime_type)))
        cells = []
        for row in range(len(self.rows)):
            state = session.RuntimeState()
            lib.scene_session_get_action_state(self.session, row, c.byref(state))
            if self.rows[row]['type'] == 0x61:
                cells.append(None)
                continue
            slot = native.Slot()
            slot_fn = lib.session_a0b_slot if self.rows[row]['type'] == 0x0b else lib.session_a17_slot
            slot_fn(self.binding_0b if self.rows[row]['type'] == 0x0b else self.binding_17, row,
                    c.byref(slot))
            cells.append((state.completed, slot.request, slot.left, slot.top, slot.right, slot.bottom,
                          state.phase))
        world = {'start_flag': self.rig.start_flag, 'mode': 3}
        transition = None
        if status == session.SESSION_TRANSITION:
            pending = session.SceneTransitionRequest()
            if lib.scene_session_get_pending_transition(self.session, c.byref(pending)) != 1:
                raise OracleError('transition status without a pending request')
            transition = (pending.target_scene, *pending.opaque_words, *pending.opaque_dwords)
            world['mode'] = 4
            self.transitioned = True
        return events, cells, world, transition


def insert_handler_marks(events):
    """The original also logs handler entries; the session stream has none."""
    return [e for e in events if e[0] != 'handler']


# --------------------------------------------------------------------- corpus

def ensure_corpus():
    """The raw 0x0b rows of the corpus, produced through the production parser."""
    if not CORPUS.exists():
        tool = ROOT / 'work/analysis/slices/RT-16.corpus-dump'
        src = ROOT / 'outputs/blackmoor-decomp/src'
        subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-std=c11', '-O1', '-I', str(src),
                        str(Path(__file__).with_name('action_family_0b_corpus_dump.c')),
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
        CORPUS.write_text(json.dumps(dict(exe_sha256=EXE_HASH, raw_0x0b_rows=len(records),
                                          records=records), indent=1) + '\n')
    corpus = json.loads(CORPUS.read_text())
    return [bytes.fromhex(r['body']) for r in corpus['records']], corpus


def random_body(rng, cursor=None):
    word = lambda: rng.choice((0, 1, -1, 0x7fff, -32768, rng.randrange(-32768, 32768)))
    dword = lambda: rng.choice((0, 1, -1, 0x7fffffff, -2 ** 31, rng.randrange(0, 640),
                                rng.randrange(-70000, 70000), 0x8000, 0xffff, 0x12345))
    return native.body(cursor=rng.choice((0, 3, 4, 5, 9, 0x1a, 0x1b, -1, 100, word())) if cursor is None
                       else cursor, target=rng.choice((6404, 0, -1, word())), frame=word(),
                       word6=rng.choice((1, 0, word())),
                       rect=(dword(), dword(), dword(), dword()))


# --------------------------------------------------------------------- cases

def run_loader_cases(lib, original, corpus, counters):
    """A. The loader arm against action0b_load."""
    cases = 0
    bodies = list(corpus)
    rng = random.Random(0x40b7d4)
    for index in range(2500):
        bodies.append(random_body(rng))
    for index in (0x00, 0xff, 0xa5):
        bodies.append(bytes([index]) * 24)
    for number, body in enumerate(bodies):
        rng = random.Random(number * 7919 + 1)
        row = rng.randrange(0, 200)
        payload, advance, beyond = original.run_loader(body, row, rng)
        if beyond:
            raise OracleError(('loader read beyond the 24-byte body', number))
        if advance != (0x18, 0x18):
            raise OracleError(('loader advance mismatch', number, advance))
        status, mine, why = native.load(lib, body)
        if status != native.OK:
            raise OracleError(('native loader rejected a valid body', number, why))
        if native.image(mine) != payload:
            raise OracleError(('payload image mismatch', number, payload.hex(), native.image(mine).hex()))
        cases += 1
    counters['loader_corpus_bodies'] = len(corpus)
    return cases


def build_sequence(rng, corpus):
    nfamily = rng.choice((1, 1, 2, 2, 3))
    rows = []
    for _ in range(nfamily):
        if rng.random() < 0.2:      # a decoy raw 0x17 row in the same scene
            runtime_type, body = 0x17, t17.body(target=rng.choice((6402, 6451)), words=(0, 0, 1),
                                                 records=[(f, 1, 2, 30, 40) for f in
                                                          rng.sample(range(-3, 8), rng.randrange(1, 4))])
        else:
            runtime_type = 0x0b
            body = rng.choice(corpus) if rng.random() < 0.4 else random_body(rng)
        rows.append(dict(type=runtime_type, body=body, done=False,
                         subtype=rng.choice((1, 1, 1, 0, 2, 3, 255))))
    if rng.random() < 0.4:
        rows.insert(rng.randrange(len(rows) + 1), dict(type=0x61, body=b'', done=True))
    pool = [0, 0, 0]
    for r in rows:
        if r['type'] == 0x17:
            pool += [struct.unpack_from('<h', r['body'], 22 + 18 * i)[0]
                     for i in range(struct.unpack_from('<h', r['body'], 20)[0])]
    decoys = [f ^ 0x100 for f in pool] + [f + 1 for f in pool] + [-5, 100, 0x4000]
    steps = []
    for _ in range(rng.randrange(1, 7)):
        steps.append(dict(selector=wrap_s16(rng.choice(pool + decoys)),
                          gates=[rng.random() < 0.7 for _ in rows], accept_mode=rng.random()))
    world = dict(start_flag=rng.choice((0, -1, 0x7a7a7a7a, 12345)), mode=3,
                 **{n: rng.randrange(-2 ** 31, 2 ** 31) if sz == 4 else rng.randrange(-32768, 32768)
                    for n, sz in ((n, WORLD_CELLS[a][1]) for a, (n, _) in WORLD_CELLS.items()
                                  if n.startswith('xfer'))})
    return rows, steps, world


def original_objects(original, rows, rng):
    """The row objects the original loader would have produced."""
    for number, spec in enumerate(rows):
        if spec['type'] == 0x0b:
            spec['obj'], _, _ = original.run_loader(spec['body'], number, rng)
        else:
            spec['obj'] = spec['body']


def compare_pass(lib, original, nat, rng, rows, step, accept, label, counters):
    original.false_rows = {row for row, ok in enumerate(step['gates']) if not ok}
    original.put(SELECTOR_CELL, 2, step['selector'])
    if accept is not None:
        original.put(row_va(accept, 0x4f), 4, 2)
    got = original.run_dispatcher(rng)
    events, cells, world, transition = nat.pass_(step['selector'], step['gates'], accept)
    expected = insert_handler_marks(got['events'])
    if events != expected:
        raise OracleError(('ordered effect stream mismatch', label, events, expected))
    for row, spec in enumerate(rows):
        if spec['type'] == 0x61:
            continue
        done, request, left, top, right, bottom, phase = cells[row]
        o = dict(zip([n for _, (n, _) in sorted(ROW_CELLS.items())], got['rows'][row]))
        if (o['done'], o['request'], o['left'], o['top'], o['right'], o['bottom'], o['phase']) != \
                (done, request, left, top, right, bottom, phase):
            raise OracleError(('row cell mismatch', label, row, cells[row], got['rows'][row]))
    for name, value in world.items():
        if got['world'][name] != value:
            raise OracleError(('world cell mismatch', label, name, value, got['world'][name]))
    if transition is not None:
        for name, value in zip(XFER, transition):
            if got['world'][name] != value:
                raise OracleError(('scene-change cell mismatch', label, name, value, got['world'][name]))
    for name in got['classes']:
        counters['footprint'][name] = counters['footprint'].get(name, 0) + 1
    for e in got['events']:
        key = e[1] if e[0] == 'w' else e[0]
        counters['sequence'][key] = counters['sequence'].get(key, 0) + 1
    return got, cells, transition


def run_sequences(lib, original, corpus, count, counters, seed=0x16):
    passes = transitions = 0
    for index in range(count):
        rng = random.Random(seed * 100003 + index)
        rows, steps, world = build_sequence(rng, corpus)
        original_objects(original, rows, rng)
        original.load_scene(rows, rng, world)
        nat = NativeSession(lib, rows, rng, world)
        nat.last_cells = [None] * len(rows)
        try:
            for number, step in enumerate(steps):
                accept = None
                if number > 0 and step['accept_mode'] < 0.6:
                    candidates = [i for i, cell in enumerate(nat.last_cells) if cell is not None
                                  and not cell[0] and (cell[1] != 0 or step['accept_mode'] < 0.1)]
                    if candidates:
                        accept = candidates[0] if step['accept_mode'] < 0.5 else candidates[-1]
                _, cells, transition = compare_pass(lib, original, nat, rng, rows, step, accept,
                                                    (index, number), counters)
                nat.last_cells = cells
                passes += 1
                if transition is not None:
                    transitions += 1
                    for spec_row, cell in zip(rows, cells):
                        if spec_row['type'] == 0x0b and cell is not None and cell[0]:
                            counters['finish_0b'] = counters.get('finish_0b', 0) + 1
                    break
        finally:
            nat.close()
    return passes, transitions


def run_kernel_cases(lib, original, corpus, counters):
    """C. Dispatcher against the kernel directly for every type served by the handler."""
    cases = 0
    for runtime_type in (0x0b, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14):
        mode = lib.scene_conditions_gate_mode_for_type(runtime_type)
        for index in range(40):
            rng = random.Random(runtime_type * 7919 + index)
            body = random_body(rng) if index % 3 else rng.choice(corpus)
            payload, _, _ = original.run_loader(body, 0, rng)
            for phase in (0, 1, 2, 3, 5, 0x10000):
                for gate in (True, False):
                    selector = wrap_s16(rng.choice((0, 0, 1, -1, 0x100, 4)))
                    world = dict(start_flag=rng.choice((0, 0x5a5a5a5a)), mode=3,
                                 **{n: 1000 + i for i, n in enumerate(XFER)})
                    rows = [dict(type=runtime_type, obj=payload, done=False,
                                 subtype=rng.choice((0, 1, 2, 3, 255)))]
                    original.load_scene(rows, rng, world)
                    original.false_rows = set() if gate else {0}
                    original.put(SELECTOR_CELL, 2, selector)
                    original.put(row_va(0, 0x4f), 4, phase)
                    seed_cells = [rng.randrange(-30000, 30000) for _ in range(4)]
                    for off, value in zip((0x47, 0x49, 0x4b, 0x4d), seed_cells):
                        original.put(row_va(0, off), 2, value)
                    original.put(row_va(0, 0x43), 4, rng.choice((0, 1, 7)))
                    got = original.run_dispatcher(rng)
                    log = [('w', 'request', 0, 0), ('gate', 0, mode)]
                    slot = native.Slot(request=0, left=seed_cells[0], top=seed_cells[1],
                                       right=seed_cells[2], bottom=seed_cells[3], done=0)
                    w = native.World(selector=selector, start_flag_5bb1ca=world['start_flag'],
                                     mode_583999=3, **{k: world[k] for k in XFER})
                    case = native.Case(lib, body, phase & 0xffffffff, slot=slot, world=w)
                    if gate:
                        status, result = case.run()
                        if status != native.OK:
                            raise OracleError(('native kernel rejected a parity case', status))
                        world_names = {n for n, _ in WORLD_CELLS.values()}
                        log += [('w', n, -1 if n in world_names else 0, v) for n, v in case.log]
                    expected = insert_handler_marks(got['events'])
                    if log != expected:
                        raise OracleError(('kernel stream mismatch', runtime_type, phase, gate, log, expected))
                    o = dict(zip([n for _, (n, _) in sorted(ROW_CELLS.items())], got['rows'][0]))
                    nat_state = case.state()
                    if gate and ((o['request'], o['left'], o['top'], o['right'], o['bottom'], o['done']) !=
                                 nat_state[0]):
                        raise OracleError(('kernel cell mismatch', runtime_type, phase, nat_state, o))
                    if not gate and o['request'] != 0:
                        raise OracleError(('false gate left the request set', runtime_type))
                    if got['world']['start_flag'] != (case.world.start_flag_5bb1ca if gate else world['start_flag']):
                        raise OracleError(('start flag mismatch', runtime_type, phase))
                    if gate and got['world']['mode'] != case.world.mode_583999:
                        raise OracleError(('mode mismatch', runtime_type, phase))
                    if gate and phase == 2:
                        for name, native_value in zip(XFER, nat_state[1][2:]):
                            if got['world'][name] != native_value:
                                raise OracleError(('scene-change cell mismatch', runtime_type, name))
                    cases += 1
                    for name in got['classes']:
                        counters['footprint'][name] = counters['footprint'].get(name, 0) + 1
    return cases


def run_cascade_cases(lib, original, count):
    cases = hits = family_hits = misses = 0
    shapes = {}
    for index in range(count):
        rng = random.Random(0x4f221e + index)
        nrows = rng.randrange(1, 7)
        rows = []
        for _ in range(nrows):
            left, top = rng.randrange(0, 600), rng.randrange(0, 440)
            runtime_type = rng.choice((0x0b, 0x0b, 0x0b, 0x17, 0x6a, 0x0d, 0x16))
            spec = dict(type=runtime_type,
                        request=rng.choice((0, 1, 1, 7, -1)),
                        rect=(left, top, left + rng.randrange(0, 90), top + rng.randrange(0, 70)))
            if runtime_type == 0x0b:
                cursor = rng.choice((0, 1, 2, 3, 4, 5, 9, 0x1a, 0x1b, 0x1c, -1, 100, -32768, 0x7fff,
                                     rng.randrange(-40, 60)))
                spec['cursor'] = cursor
                spec['payload'] = struct.pack('<h', cursor) + bytes(rng.randrange(256) for _ in range(0x26))
            rows.append(spec)
        pick = rng.choice(rows)
        l, t, r, b = pick['rect']
        if rng.random() < 0.75:
            x = rng.choice((l, r, l - 1, r + 1, (l + r) // 2, l + (r - l) // 3))
            y = rng.choice((t, b, t - 1, b + 1, (t + b) // 2, t + (b - t) // 3))
        else:
            x, y = rng.randrange(0, 640), rng.randrange(0, 480)
        x, y = min(max(x, 0), 639), min(max(y, 0), 479)
        held = rng.choice((-1, -1, 0, 5, 40, -2, 1000))
        case = dict(rows=rows, x=x, y=y,
                    initial={'cursor_index': 0x1111, 'cursor_variant': 0x2222, 'item_flag': 0x3333,
                             'cursor_surface': 0x4444, 'cursor_table': 0x5555, 'cursor_layer': 0x6666,
                             'candidate': -77},
                    inputs={'held_item': held, 'surface_default': 0xd0377, 'surface_held': 0x571ad3a,
                            'excluded_0': -1, 'excluded_1': -1})
        got, written = original.run_cascade(case, rng)
        spots = (pointer.InputHotspot * max(len(rows), 1))()
        n = 0
        for i, spec in enumerate(rows):
            if spec['request'] != 0:
                spots[n].index = i
                spots[n].rectangle = pointer.Rect(*spec['rect'])
                spots[n].active = 1
                n += 1
        state = pointer.InputState()
        lib.session_input_init(c.byref(state))
        ctx = pointer.InputContext(pointer.Rect(0, 0, 639, 479), pointer.Rect(x, y, x, y),
                                   0, 0, 0, 0, 0, 0, 1, 1, -1, -1)
        lib.session_input_publish_candidate(c.byref(state), -1)
        status = lib.session_input_scan(c.byref(state), c.byref(ctx), spots, n)
        if status != 0:
            raise OracleError(('session_input_scan failed', status))
        candidate = state.candidate
        original_candidate = got['candidate'] if 'candidate' in written else -1
        if candidate != original_candidate:
            raise OracleError(('candidate mismatch', index, candidate, original_candidate, case))
        cases += 1
        if candidate < 0:
            misses += 1
            if written - {'item_flag'} or got['return'] != 1 or got['item_flag'] != 0:
                raise OracleError(('a miss wrote cursor cells', index, written))
            continue
        hits += 1
        spec = rows[candidate]
        if spec['type'] != 0x0b:
            continue
        family_hits += 1
        status, payload, _ = native.load(lib, native.body(cursor=spec['cursor']))
        cursor = native.Cursor()
        if lib.action0b_hover_cursor(c.byref(payload), held, c.byref(cursor)) != 0:
            raise OracleError('native hover rejected a family row')
        expected = {'cursor_index': cursor.cursor_index, 'cursor_variant': cursor.variant,
                    'item_flag': cursor.held_flag,
                    'cursor_table': CURSOR_TABLE_BASE + cursor.table_offset, 'cursor_layer': 1}
        expected['cursor_surface'] = {0: case['initial']['cursor_surface'],
                                      1: case['inputs']['surface_default'],
                                      2: case['inputs']['surface_held']}[cursor.surface]
        for name, value in expected.items():
            if got[name] != value:
                raise OracleError(('cursor cell mismatch', name, got[name], value, spec['cursor'], held))
        if got['return'] != 1:
            raise OracleError('cascade fragment did not return 1')
        in_range = 3 < spec['cursor'] < 0x1b
        key = f"held={'none' if held == -1 else 'item'} word={'in 4..0x1a' if in_range else 'outside'}"
        shapes[key] = shapes.get(key, 0) + 1
    return dict(cases=cases, hits=hits, family_hits=family_hits, misses=misses,
                family_hit_shapes=dict(sorted(shapes.items())))


def unsafe_observations(lib, original):
    out = []
    rng = random.Random(0x0b0b)
    body = native.body()
    # A source object shorter than the 24 bytes the loader consumes: the original reads past it.
    payload, advance, beyond = original.run_loader(body[:20], 3, rng, declared_length=20)
    status, _, why = native.load(lib, body[:20])
    if status != native.BOUNDS or not beyond:
        raise OracleError('short-body observation did not hold')
    out.append(dict(label='typed body of 20 bytes (4 short of the 24 the loader copies)',
                    original='the loader arm reads 4 bytes beyond the source object and still builds a payload',
                    native='ACTION17_ERR_BOUNDS: ' + (why or b'').decode()))
    status, _, why = native.load(lib, body + b'\0')
    if status != native.BOUNDS:
        raise OracleError('long body accepted')
    out.append(dict(label='typed body of 25 bytes',
                    original='the loader copies the first 24 bytes and advances by 0x18 (the extra byte '
                             'would belong to the next record)',
                    native='ACTION17_ERR_BOUNDS: ' + (why or b'').decode()))
    return out


def main(*, library=None, report_path=REPORT, sequences=1500, cascade_cases=1500):
    started = time.monotonic()
    library_path = native.build_library() if library is None else native.library_path()
    lib = session.load_library(library_path)
    native.configure(lib)
    native_kernel = native.bind(library_path)
    for name in ('action0b_load', 'action0b_step', 'action0b_hover_cursor'):
        setattr(lib, name, getattr(native_kernel, name))
    lib.scene_conditions_gate_mode_for_type.argtypes = [c.c_uint8]
    lib.scene_conditions_gate_mode_for_type.restype = c.c_int32
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError(f'code window mismatch: {label}')
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    original = Original(pe)
    corpus, corpus_doc = ensure_corpus()
    counters = dict(footprint={}, sequence={})
    loader_cases = run_loader_cases(lib, original, corpus, counters)
    passes, finished = run_sequences(lib, original, corpus, sequences, counters)
    kernel_cases = run_kernel_cases(lib, original, corpus, counters)
    cascade = run_cascade_cases(lib, original, cascade_cases)
    unsafe = unsafe_observations(lib, original)
    report = dict(
        slice='RT-16',
        scope='loader arm 0x40b7d4; dispatcher 0x427a50 (prologue, type switch, arms 0x427b33/0x427b6b/0x427ba4, '
              'real gate, real handler 0x42ae73, loop join); generic row loop of the pointer cascade '
              '0x4f1eb8..0x4f257b including the type-0x0b hover case 0x4f221e',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_file_sha256=sha(CORPUS.read_bytes()), corpus_bodies=len(corpus),
        loader_cases=loader_cases,
        session_sequences=sequences, session_passes=passes, session_scene_changes=finished,
        session_0b_scene_changes=counters.get('finish_0b', 0),
        kernel_dispatcher_cases=kernel_cases, cascade=cascade,
        mismatches=0,
        write_stream_names=dict(sorted(counters['sequence'].items())),
        write_footprint_classes=dict(sorted(counters['footprint'].items())),
        hooks=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='only 0x423f57 for rows declared false-gate; true-gate rows run the real '
                                    'evaluator on an empty tree. 0x51dc43 (allocator) is a host stand-in '
                                    'during the loader runs only',
        compared='loader: every payload byte, the row pointer cell, source and counter advance, byte coverage; '
                 'dispatcher: ordered write stream merged with gate calls and their mode; every row cell; '
                 'every world cell; the seven scene-change cells; callee-saved registers and stack balance; '
                 'write footprint; cascade candidate and the six cursor cells',
        unsafe_original_observations=unsafe,
        unverified=['non-empty dependency tree evaluation (shared kernel; native session tests)',
                    'the action-active dword (+0x55) skip: the executor has no producer for it',
                    'the loader allocation-failure branch (error print and exit) is not run',
                    'runtime types 0x0d..0x14 and raw 0x15 only at kernel level (gate mode and handler); '
                    'their loaders (0x40b506, 0x40b5f1) are not compared',
                    'the pointer transform before the generic row loop (session_input oracles)',
                    'excluded rows 0x5b4e89/0x5b5100 and the other cursor cases of 0x4f0059'],
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('loader_cases', 'session_sequences', 'session_passes',
                                             'session_scene_changes', 'session_0b_scene_changes',
                                             'kernel_dispatcher_cases', 'mismatches', 'seconds')}))
    print(json.dumps(report['cascade']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--mutation', action='store_true',
                        help='smaller run for mutation checks (library from A0B_RUNTIME_LIBRARY)')
    arguments = parser.parse_args()
    if arguments.mutation:
        main(library=True, report_path=arguments.report, sequences=250, cascade_cases=300)
    else:
        main(report_path=arguments.report)
