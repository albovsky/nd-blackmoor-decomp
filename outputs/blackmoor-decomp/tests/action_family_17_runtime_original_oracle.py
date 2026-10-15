#!/usr/bin/env python3
"""RT-15: original-x86 oracle for the raw 0x16..0x19 multiframe scene hotspot runtime.

Runs the unmodified original under Unicorn and compares it, step by step, with
the native kernel/binding/session:

  A. dispatcher 0x427a50 itself (prologue skips, request clear, type switch via
     the real map 0x42aba4 and jump table 0x42a9b4, arms 0x427bdd/0x427c15, the
     real dependency gate 0x423f57, the real handler 0x42b07e, the loop join and
     the mode-4 loop exit) against the native SESSION (executor + pre-gate +
     binding + kernel) for raw 0x16 and 0x17, on multi-row scenes with decoy
     rows, over multi-pass sequences with selector changes, gate flips and
     accepted candidates (the 0x43bfb6 phase-2 store);
  B. the same dispatcher against the native KERNEL for every runtime type the
     handler serves (0x16..0x19) and phases 0, 1, 2 and the no-effect phases;
  C. 0x40b2d0 (cursor index by runtime type) for all 256 inputs;
  D. the generic row loop of the pointer cascade 0x4f0059 (0x4f1eb8..0x4f257b,
     which calls the real 0x40b2d0) against session_input_scan plus the native
     hover cursor: first hit, candidate, cursor index/variant/flag/table/surface.

Hooks (every one is enumerated in the report; none replaces a decision the
original makes except the first, which is limited to false-gate rows):

  replacement  0x423f57 dependency gate ONLY for rows the case declares
               false-gate: EAX=0, pop two arguments. True-gate rows run the
               real evaluator on an empty tree (it returns 1).
  observation  code entry of 0x427a50 / 0x423f57 (arguments) / 0x42b07e,
               every memory write of the address space (classified into the
               modeled cells, the gate bookkeeping and the stack), reads of
               the row body objects (any read beyond a body is an error),
               register/stack state at the stop.
  stub         the return address (a single RET page) is the only code outside
               the executable.

Compared after every pass: the ORDERED stream of writes to the modeled cells
(merged with the dependency-gate calls and their mode argument), every row
cell (completion, request, rectangle words, phase), every world cell
(0x5bb1ca, 0x583999 and the seven scene-change cells), callee-saved registers
and stack balance. The original's complete write footprint must stay inside the
modeled cells, the gate bookkeeping and the stack.

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/action_family_17_runtime_original_oracle.py
"""
import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct
import sys
import time

from cif_original_oracle import PEImage, align_up
import session_binding_support as session
import test_action_family_17_runtime as native
import test_scene_session_pointer as pointer

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-15.oracle.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

CODE_WINDOWS = [
    (0x427a50, 0x427b33, 'dispatcher prologue and type switch 0x427a50',
     '1c4502762e5132191098c486266e2643fc259cd7d9533ebea773a0662ca5d42e'),
    (0x427bdd, 0x427c15, 'dispatcher arm 0x16 (gate mode 1)',
     '4e27444941ea54699cf77c15ae67f43cdf87bdc9c963171813ec97f10a89ca3a'),
    (0x427c15, 0x427c4e, 'dispatcher arm 0x17..0x19 (gate mode 0)',
     '590951d199d394688ea09320a58b270eeb1e53bc8ddfe527b0c685c35fb56ade'),
    (0x42a9a9, 0x42a9b4, 'dispatcher loop join and epilogue',
     'c542a2c75f291cf8ee9d05f425537a3ffd1f9bc33d439b9ab2b4036a83a560a3'),
    (0x42b07e, 0x42b2e4, 'handler 0x42b07e',
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
FRAME = STACK + 0x30000
ROW_BASE, ROW_STRIDE = 0x5bb5e3, 0x8d
GATE_OBJECT, GATE_FLAG = 0x63786d, 0x5c3a47
COUNT_WORD, MODE_CELL, SELECTOR_CELL = 0x5c39e3, 0x583999, 0x5bb50b
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
        self.uc.mem_write(STUB_RET, b'\xc3')
        self.hook_counts = {}
        self.events = []
        self.writes = []
        self.reads_beyond = []
        self.body_lengths = {}
        self.false_rows = set()
        self.nrows = 0
        self.gate_calls = []
        for address in (0x427a50, 0x423f57, 0x42b07e):
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
        elif address == 0x42b07e:
            self.count('observe 0x42b07e handler entry')
            self.events.append(('handler', struct.unpack('<h', self.read(esp + 4, 2))[0]))

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

    # -- scene setup
    def load_scene(self, rows, rng, world):
        """rows: dicts type, body, done. Clears the row table first."""
        uc = self.uc
        self.nrows = len(rows)
        self.body_lengths = {}
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(COUNT_WORD, 2, len(rows))
        self.put(MODE_CELL, 4, 3)
        for row, spec in enumerate(rows):
            self.put(row_va(row, 0), 1, spec['type'])
            self.put(row_va(row, 1), 1, 1)
            body = spec.get('body', b'')
            uc.mem_write(obj_va(row), bytes([0xa5]) * OBJ_STRIDE)
            uc.mem_write(obj_va(row), body)
            self.body_lengths[row] = len(body)
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

    # -- 0x40b2d0 and the cascade fragment
    def call_cursor_map(self, runtime_type):
        uc, r = self.uc, self.regs
        esp = FRAME - 0x800
        uc.mem_write(esp, struct.pack('<II', STUB_RET, runtime_type))
        uc.reg_write(r['ESP'], esp)
        uc.reg_write(r['EAX'], 0xdeadbeef)
        uc.emu_start(0x40b2d0, STUB_RET, count=1000)
        return uc.reg_read(r['EAX']) & 0xff

    def run_cascade(self, case, rng):
        """0x4f1eb8..: the generic row loop with a pre-transformed pointer."""
        uc, r = self.uc, self.regs
        self.nrows = len(case['rows'])
        self.writes, self.events, self.reads_beyond = [], [], []
        uc.mem_write(ROW_BASE, bytes(240 * ROW_STRIDE))
        self.put(COUNT_WORD, 2, len(case['rows']))
        for row, spec in enumerate(case['rows']):
            self.put(row_va(row, 0), 1, spec['type'])
            self.put(row_va(row, 0x43), 4, spec['request'])
            for off, value in zip((0x47, 0x49, 0x4b, 0x4d), spec['rect']):
                self.put(row_va(row, off), 2, value)
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
    return session.action(spec['type'], 1, spec['body'], (session.flag_gate(flag),))


class NativeSession:
    def __init__(self, lib, rows, rng, world):
        self.lib, self.rows = lib, rows
        self.rig = native.Rig17(selector=0)
        self.rig.start_flag = world['start_flag']
        self.rig.lib = lib
        self.scene, self.owner = session.open_scene(lib, [action_bytes(r, i + 1) for i, r in enumerate(rows)])
        self.flags, self.core, self.conditions = session.make_world()
        self.binding = lib.session_a17_create(c.byref(self.rig.host))
        if not self.binding or lib.session_a17_begin_scene(self.binding, self.scene) != 0:
            raise OracleError('native binding refused the scene')
        self.session = c.c_void_p()

        @session.PrepareFn
        def prepare(*_): return 0

        @session.MediaFn
        def media(*_): return 0

        handler = session.ActionFn(('session_a17_handler', lib))
        self.bindings = (session.Binding * 2)(session.Binding(0x17, 11, handler, self.binding),
                                              session.Binding(0x16, 11, handler, self.binding))
        self.config = session.SessionConfig(scene=self.scene, scene_id=6401,
            action_core_world=c.pointer(self.core), conditions=c.pointer(self.conditions),
            action_bindings=self.bindings, action_binding_count=2, prepare_tick=prepare,
            advance_media_one=media)
        if lib.scene_session_create(c.byref(self.config), c.byref(self.session),
                                    c.byref(session.SceneSessionFailure())) != 0:
            raise OracleError('native session refused the scene')
        pre_gate = c.cast(lib.session_a17_pre_gate, c.c_void_p)
        for runtime_type in (0x16, 0x17):
            if lib.scene_session_set_pre_gate(self.session, runtime_type, pre_gate, self.binding) != 0:
                raise OracleError('pre-gate registration failed')
        self.rig.session = self.session
        self.keep = (prepare, media, handler)
        self.transitioned = False

    def close(self):
        self.lib.scene_session_destroy(self.session)
        self.lib.session_a17_destroy(self.binding)
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
            lib.session_a17_slot(self.binding, row, c.byref(slot))
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


# --------------------------------------------------------------------- cases

def random_record(rng, frames):
    frame = rng.choice(frames)
    pick = lambda: rng.choice((rng.randrange(0, 640), rng.randrange(-70000, 70000),
                               rng.randrange(-2 ** 31, 2 ** 31), 0x8000, 0xffff, -1, 0x12345))
    return (frame, pick(), pick(), pick(), pick())


def make_body(rng, base=None):
    frames = [rng.randrange(-4, 30) for _ in range(rng.randrange(1, 6))] + [-32768, 0x7fff, -2]
    if base is not None:
        return base
    count = rng.choice((0, 1, 2, 3, 4, 5, 5, 8))
    records = [random_record(rng, frames) for _ in range(count)]
    if count >= 2 and rng.random() < 0.4:
        records[1] = (records[0][0],) + records[1][1:]      # duplicate frame
    target = rng.choice((6402, 6451, rng.randrange(-32768, 32768), 0))
    words = tuple(rng.choice((0, 1, rng.randrange(-32768, 32768))) for _ in range(3))
    dwords = tuple(rng.choice((0, 1, rng.randrange(-2 ** 31, 2 ** 31))) for _ in range(3))
    return native.body(target, words, dwords, records)


def corpus_bodies():
    out = []
    for name in ('A-17.1.corpus.json', 'A-16.1.corpus.json'):
        corpus = json.loads((ROOT / 'work/analysis/slices' / name).read_bytes())
        for record in corpus['records']:
            data = (ROOT / 'work/analysis/hiff-resources' / f"{record['resource_index']:04d}.bin").read_bytes()
            start = record['raw_body_offset']
            raw = data[start:start + record['raw_body_length']]
            count = struct.unpack_from('<h', raw, 20)[0]
            out.append((0x17 if '17' in name else 0x16, raw[:22 + 18 * count]))
    return out


def frames_of(body):
    count = struct.unpack_from('<h', body, 20)[0]
    return [struct.unpack_from('<h', body, 22 + 18 * i)[0] for i in range(count)]


def build_sequence(rng, corpus):
    nfamily = rng.choice((1, 1, 2, 2, 3))
    rows = []
    for _ in range(nfamily):
        if rng.random() < 0.35:
            runtime_type, body = rng.choice(corpus)
        else:
            runtime_type, body = rng.choice((0x16, 0x17)), make_body(rng)
        rows.append(dict(type=runtime_type, body=body, done=False))
    if rng.random() < 0.4:
        rows.insert(rng.randrange(len(rows) + 1), dict(type=0x61, body=b'', done=True))
    pool = sorted({f for r in rows if r['type'] != 0x61 for f in frames_of(r['body'])})
    decoys = [f ^ 0x100 for f in pool] + [f + 1 for f in pool] + [-5, 100, 0x4000]
    steps = []
    for _ in range(rng.randrange(1, 7)):
        steps.append(dict(selector=wrap_s16(rng.choice(pool + decoys + [0]) if pool else rng.randrange(10)),
                          gates=[rng.random() < 0.7 for _ in rows], accept_mode=rng.random()))
    world = dict(start_flag=rng.choice((0, -1, 0x7a7a7a7a, 12345)), mode=3,
                 **{n: rng.randrange(-2 ** 31, 2 ** 31) if sz == 4 else rng.randrange(-32768, 32768)
                    for n, sz in ((n, WORLD_CELLS[a][1]) for a, (n, _) in WORLD_CELLS.items()
                                  if n.startswith('xfer'))})
    return rows, steps, world


def compare_pass(lib, original, nat, rng, rows, step, accept, label, counters):
    # Original side.
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
        counters['sequence'][e[1] if e[0] == 'w' else e[0]] = counters['sequence'].get(
            e[1] if e[0] == 'w' else e[0], 0) + 1
    return got, cells, transition


def run_sequences(lib, original, corpus, count, counters, seed=0x15):
    passes = transitions = 0
    for index in range(count):
        rng = random.Random(seed * 100003 + index)
        rows, steps, world = build_sequence(rng, corpus)
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
                    counters['finish'] = counters.get('finish', 0) + 1
                    break
        finally:
            nat.close()
    return passes, transitions


def run_kernel_cases(lib, original, corpus, counters):
    """B. Dispatcher against the kernel directly for every handler type."""
    cases = 0
    for runtime_type in (0x16, 0x17, 0x18, 0x19):
        mode = 1 if runtime_type == 0x16 else 0
        for index in range(60):
            rng = random.Random(runtime_type * 7919 + index)
            body = make_body(rng) if index % 3 else rng.choice(corpus)[1]
            pool = frames_of(body) or [0]
            for phase in (0, 1, 2, 3, 5, 0x10000):
                for gate in (True, False):
                    selector = wrap_s16(rng.choice(pool + [pool[0] ^ 0x100, -9]))
                    world = dict(start_flag=rng.choice((0, 0x5a5a5a5a)), mode=3,
                                 **{n: 1000 + i for i, n in enumerate(XFER)})
                    rows = [dict(type=runtime_type, body=body, done=False)]
                    original.load_scene(rows, rng, world)
                    original.false_rows = set() if gate else {0}
                    original.put(SELECTOR_CELL, 2, selector)
                    original.put(row_va(0, 0x4f), 4, phase)
                    seed_cells = [rng.randrange(-30000, 30000) for _ in range(4)]
                    for off, value in zip((0x47, 0x49, 0x4b, 0x4d), seed_cells):
                        original.put(row_va(0, off), 2, value)
                    original.put(row_va(0, 0x43), 4, rng.choice((0, 1, 7)))
                    request_before = original.cell(row_va(0, 0x43), 4)
                    got = original.run_dispatcher(rng)
                    # Native: the prologue request clear, the gate, then the handler.
                    log = [('w', 'request', 0, 0), ('gate', 0, mode)]
                    slot = native.Slot(request=0, left=seed_cells[0], top=seed_cells[1],
                                       right=seed_cells[2], bottom=seed_cells[3], done=0)
                    w = native.World(selector=selector, start_flag_5bb1ca=world['start_flag'],
                                     mode_583999=3, **{k: world[k] for k in XFER})
                    # The kernel is exercised through the same ctypes entry the tests use.
                    case = native.Case(lib, body, phase & 0xffffffff, slot=slot, world=w)
                    if gate:
                        status, result, why = case.run()
                        if status != native.OK:
                            raise OracleError(('native kernel rejected a parity case', status, why))
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
                    cases += 1
                    for name in got['classes']:
                        counters['footprint'][name] = counters['footprint'].get(name, 0) + 1
    return cases


def run_cursor_map(lib, original):
    for value in range(256):
        got = original.call_cursor_map(value)
        mine = lib.action17_cursor_index_for_type(value)
        if got != mine:
            raise OracleError(('cursor map mismatch', value, got, mine))
    return 256


def run_cascade_cases(lib, original, count):
    ctx_lib = lib
    cases = hits = family_hits = misses = 0
    shapes = {}
    for index in range(count):
        rng = random.Random(0x4f0059 + index)
        nrows = rng.randrange(1, 7)
        rows = []
        for _ in range(nrows):
            left, top = rng.randrange(0, 600), rng.randrange(0, 440)
            rows.append(dict(type=rng.choice((0x16, 0x17, 0x17, 0x18, 0x19, 0x6a, 0x0d)),
                             request=rng.choice((0, 1, 1, 7, -1)),
                             rect=(left, top, left + rng.randrange(0, 90), top + rng.randrange(0, 70))))
        # Pointer on or around an edge of a random row, or anywhere.
        pick = rng.choice(rows)
        l, t, r, b = pick['rect']
        if rng.random() < 0.75:      # on or just around an edge, or inside
            x = rng.choice((l, r, l - 1, r + 1, (l + r) // 2, l + (r - l) // 3))
            y = rng.choice((t, b, t - 1, b + 1, (t + b) // 2, t + (b - t) // 3))
        else:
            x, y = rng.randrange(0, 640), rng.randrange(0, 480)
        x, y = min(max(x, 0), 639), min(max(y, 0), 479)
        held = rng.choice((-1, -1, 0, 5, 40, -2))
        case = dict(rows=rows, x=x, y=y,
                    initial={'cursor_index': 0x1111, 'cursor_variant': 0x2222, 'item_flag': 0x3333,
                             'cursor_surface': 0x4444, 'cursor_table': 0x5555, 'cursor_layer': 0x6666,
                             'candidate': -77},
                    inputs={'held_item': held, 'surface_default': 0xd0377, 'surface_held': 0x571ad3a,
                            'excluded_0': -1, 'excluded_1': -1})
        got, written = original.run_cascade(case, rng)
        # Native: session_input scan over the rows with request != 0, ascending.
        spots = (pointer.InputHotspot * max(len(rows), 1))()
        n = 0
        for i, spec in enumerate(rows):
            if spec['request'] != 0:
                spots[n].index = i
                spots[n].rectangle = pointer.Rect(*spec['rect'])
                spots[n].active = 1
                n += 1
        state = pointer.InputState()
        ctx_lib.session_input_init(c.byref(state))
        ctx = pointer.InputContext(pointer.Rect(0, 0, 639, 479), pointer.Rect(x, y, x, y),
                                   0, 0, 0, 0, 0, 0, 1, 1, -1, -1)
        ctx_lib.session_input_publish_candidate(c.byref(state), -1)
        status = ctx_lib.session_input_scan(c.byref(state), c.byref(ctx), spots, n)
        if status != 0:
            raise OracleError(('session_input_scan failed', status))
        candidate = state.candidate
        original_candidate = got['candidate'] if 'candidate' in written else -1
        if candidate != original_candidate:
            raise OracleError(('candidate mismatch', index, candidate, original_candidate, case))
        cases += 1
        if candidate < 0:
            misses += 1
            # 0x4f1eb8 itself clears the item flag 0x5b44f8 at loop entry; nothing else is written.
            if written - {'item_flag'} or got['return'] != 1 or got['item_flag'] != 0:
                raise OracleError(('a miss wrote cursor cells', index, written))
            continue
        hits += 1
        spec = rows[candidate]
        if spec['type'] not in (0x16, 0x17, 0x18, 0x19):
            continue
        family_hits += 1
        cursor = native.Cursor()
        if ctx_lib.action17_hover_cursor(spec['type'], held, c.byref(cursor)) != 0:
            raise OracleError('native hover rejected a family row')
        expected = {'cursor_index': cursor.cursor_index, 'cursor_variant': cursor.variant,
                    'item_flag': cursor.held_flag,
                    'cursor_table': CURSOR_TABLE_BASE + cursor.table_offset, 'cursor_layer': 1}
        surface = {0: case['initial']['cursor_surface'], 1: case['inputs']['surface_default'],
                   2: case['inputs']['surface_held']}[cursor.surface]
        expected['cursor_surface'] = surface
        for name, value in expected.items():
            if got[name] != value:
                raise OracleError(('cursor cell mismatch', name, got[name], value, spec['type'], held))
        if got['return'] != 1:
            raise OracleError('cascade fragment did not return 1')
        key = f"type 0x{spec['type']:02x} held={'none' if held == -1 else 'item'}"
        shapes[key] = shapes.get(key, 0) + 1
    return dict(cases=cases, hits=hits, family_hits=family_hits, misses=misses,
                family_hit_shapes=dict(sorted(shapes.items())))


def unsafe_observations(lib, original, corpus):
    out = []
    rng = random.Random(0x1515)
    base = native.body(6402, (0, 0, 1), (0, 0, 1), [(4, 1, 2, 3, 4), (5, 5, 6, 7, 8)])
    # Negative count: the original compares signed and scans nothing.
    neg = bytearray(base)
    struct.pack_into('<h', neg, 20, -1)
    original.load_scene([dict(type=0x17, body=bytes(neg), done=False)], rng,
                        dict(start_flag=0, mode=3, **{n: 0 for n in XFER}))
    original.false_rows = set()
    original.put(SELECTOR_CELL, 2, 4)
    got = original.run_dispatcher(rng)
    slot = native.Slot()
    w = native.World(selector=4)
    case = native.Case(lib, bytes(neg), 1, slot=slot, world=w)
    status, _, why = case.run()
    if status != native.BOUNDS:
        raise OracleError('native accepted a negative record count')
    out.append(dict(label='negative record count (-1)', original=dict(
        events=[list(e) for e in got['events']],
        note='signed compare: nothing is scanned, only the request is cleared'),
        native='ACTION17_ERR_BOUNDS: ' + (why or b'').decode()))
    # Count above the data: the original reads past the object.
    big = bytearray(base)
    struct.pack_into('<h', big, 20, 6)
    original.load_scene([dict(type=0x17, body=bytes(big[:len(base)]), done=False)], rng,
                        dict(start_flag=0, mode=3, **{n: 0 for n in XFER}))
    original.put(SELECTOR_CELL, 2, 99)
    original.false_rows = set()
    try:
        original.run_dispatcher(rng)
        result = 'completed'
    except OracleError as error:
        result = 'read beyond the row body: ' + str(error.args[0][0])
    case = native.Case(lib, bytes(big[:len(base)]), 1, slot=native.Slot(), world=native.World(selector=99))
    status, _, why = case.run()
    if status != native.BOUNDS:
        raise OracleError('native accepted a count above the data')
    out.append(dict(label='count above the body data (6 records declared, 2 present)',
                    original=result, native='ACTION17_ERR_BOUNDS: ' + (why or b'').decode()))
    return out


def main(*, library=None, report_path=REPORT, sequences=1500, cascade_cases=1500):
    started = time.monotonic()
    library_path = native.build_library() if library is None else native.library_path()
    session_lib = session.load_library(library_path)
    native.configure(session_lib)
    session_lib.scene_conditions_gate_mode_for_type.argtypes = [c.c_uint8]
    session_lib.scene_conditions_gate_mode_for_type.restype = c.c_int32
    session_lib.session_a17_slot.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(native.Slot)]
    kernel = native.bind(library_path)
    # One ctypes handle serves both: the session library already exports the kernel.
    for name in ('action17_step', 'action17_hover_cursor', 'action17_cursor_index_for_type'):
        setattr(session_lib, name, getattr(kernel, name))
    lib = session_lib
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
    corpus = corpus_bodies()
    counters = dict(footprint={}, sequence={})
    passes, finished = run_sequences(lib, original, corpus, sequences, counters)
    kernel_cases = run_kernel_cases(lib, original, corpus, counters)
    cursor_map = run_cursor_map(lib, original)
    cascade = run_cascade_cases(lib, original, cascade_cases)
    unsafe = unsafe_observations(lib, original, corpus)
    report = dict(
        slice='RT-15',
        scope='dispatcher 0x427a50 (prologue, type switch, arms, real gate, real handler 0x42b07e, loop join); '
              'cursor map 0x40b2d0; generic row loop of the pointer cascade 0x4f1eb8..0x4f257b',
        original_sha256=EXE_HASH, code_windows=windows,
        native_sha256=sha(Path(library_path).read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_bodies=len(corpus),
        session_sequences=sequences, session_passes=passes, session_scene_changes=finished,
        kernel_dispatcher_cases=kernel_cases, cursor_map_inputs=cursor_map, cascade=cascade,
        mismatches=0,
        write_stream_names=dict(sorted(counters['sequence'].items())),
        write_footprint_classes=dict(sorted(counters['footprint'].items())),
        hooks=dict(sorted(original.hook_counts.items())),
        original_decisions_replaced='only 0x423f57 for rows declared false-gate; true-gate rows run the real '
                                    'evaluator on an empty tree',
        compared='ordered write stream merged with gate calls and their mode; every row cell; every world '
                 'cell; the seven scene-change cells; callee-saved registers and stack balance; write footprint; '
                 'cascade candidate and the six cursor cells',
        unsafe_original_observations=unsafe,
        unverified=['non-empty dependency tree evaluation (shared kernel; native session tests)',
                    'the action-active dword (+0x55) skip: the executor has no producer for it',
                    'runtime types 0x18/0x19 only at kernel level (the shared parser does not type them)',
                    'the pointer transform before the generic row loop (session_input oracles)',
                    'excluded rows 0x5b4e89/0x5b5100 and the other cursor cases of 0x4f0059'],
        seconds=round(time.monotonic() - started, 2))
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('session_sequences', 'session_passes',
                                             'session_scene_changes', 'kernel_dispatcher_cases',
                                             'cursor_map_inputs', 'mismatches', 'seconds')}))
    print(json.dumps(report['cascade']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=REPORT)
    parser.add_argument('--mutation', action='store_true',
                        help='smaller run for mutation checks (library from A17_RUNTIME_LIBRARY)')
    arguments = parser.parse_args()
    if arguments.mutation:
        main(library=True, report_path=arguments.report, sequences=250, cascade_cases=300)
    else:
        main(report_path=arguments.report)
