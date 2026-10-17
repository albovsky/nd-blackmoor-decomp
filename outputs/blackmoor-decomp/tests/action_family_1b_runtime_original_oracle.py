#!/usr/bin/env python3
"""RT-40: immutable x86 loader 0x40b34a / 0x414692, dispatcher arm 0x427c87 of 0x427a50, object method 0x414947 and the pointer-cascade
case 0x4f22ad (raw type 0x1b) versus the native raw-0x1b runtime.

The unmodified GAME.EXE image is mapped under Unicorn. Two machines:

A. Loader (the A-1B.1 machine, tests/action_family_1b_original_oracle.py): the original loader builds the 34-byte row object and
   its two record arrays from the raw body (dependency tail included). Those bytes, with the two array pointers relocated, are the
   objects the runtime machine works on.
B. Runtime: for rows of raw type 0x1b the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the
   prologue request clear (0x427ad4), the gate 0x423f57 (mode 1), the arm (0x427c87..0x427cbc) and the real method 0x414947 on the
   static object 0x6385db. Nothing of the method is replaced: it has no calls. The generic row loop of the pointer cascade
   (0x4f1eb8..0x4f257b, which contains the type-0x1b case 0x4f22ad) runs on the same rows.

Native side: src/session_bindings_a1b.c over src/action_family_1b_runtime.c, driven by tests/action_family_1b_runtime_oracle_driver.c
with what the executor does for an open row (pre-gate request clear, gate, handler, completion from the disposition).

Compared after every dispatcher call (tick):
 * which rows entered the arm and which ran the method (observed entries) against the open-row model with the loop exit once the
   engine mode 0x583999 is no longer 3 (a finished row ends the pass);
 * the ORDERED stream of stores to the modeled cells (row completion byte 0x5bb625, request 0x5bb626, rectangle words
   0x5bb62a/2c/2e/30, phase 0x5bb632; world cells 0x5bb1ca, 0x583999, 0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f,
   0x5bb5a3) against the effects the native kernel reported, kind, row and value;
 * every row cell after the tick (completion byte, phase, request, rectangle) and the start flag;
 * the method's scratch cells (object + 0x1c/0x20/0x24 receive the row object and the two arrays) and the row objects unchanged;
 * the original's whole write footprint stays inside the modeled cells, the gate bookkeeping, the method's scratch and the stack,
   and reads of the objects stay inside the object and its two arrays.
Cascade: random rows (request, rectangle, object) and pointer positions: the candidate (0x5c39e5) and the hover cursor cells
(0x5b44f0/f4/f8, 0x5d162d/31/39) against the production pointer scan plus the native hover cursor.

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entry 0x427c87 (the row is the signed word at [ebp-0x11c]), method entry 0x414947, every store to the data region
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a's allocation of the row (machine B builds the rows in memory around the
original loader's object), the dependency records of the corpus rows (replayed without them behind stand-in event records; the gate
is shared verified code), the executor's candidate store of phase 2 (0x43c054; the oracle writes the phase directly), the rest of
the cascade 0x4f0059 before 0x4f1eb8.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_1b_runtime_original_oracle.py --mutations --result <receipt.json>
"""
from __future__ import annotations

import argparse
import ctypes as C
import json
import os
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from collections import Counter
from pathlib import Path

from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps
import test_scene_executor as base
from action_family_1b_original_oracle import Original as LoaderMachine
from cif_original_oracle import PEImage

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM = 0x427C87
METHOD = 0x414947
CASCADE = 0x4F1EB8
OWNER = 0x6385DB
TYPE = 0x1B
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
SELECTOR_CELL, HELD_CELL = 0x5BB50B, 0x583A29
MAX_ROWS = 60
OBJ_BASE, OBJ_SIZE = 0x24000000, 0x600000
CASCADE_THIS = OBJ_BASE + 0x5F0000
CASCADE_EBP = 0x10004000
DATA_LO, DATA_HI = 0x580000, 0x640000

# modeled cells: row offset -> (effect, size); world address -> (effect, size). Effect numbers are Action17Effect.
FX = dict(START_FLAG=1, PHASE=2, REQUEST=3, LEFT=4, TOP=5, RIGHT=6, BOTTOM=7, DONE=8, XFER_5BB57B=9, XFER_5BB599=10,
          XFER_5BB595=11, XFER_5C39FF=12, XFER_5BB59B=13, XFER_5BB59F=14, XFER_5BB5A3=15, MODE=16)
FXN = {v: k for k, v in FX.items()}
FX_BITS = {1: 32, 2: 32, 3: 32, 4: 16, 5: 16, 6: 16, 7: 16, 8: 8, 9: 32, 10: 16, 11: 16, 12: 16, 13: 32, 14: 32, 15: 32, 16: 32}
ROW_CELLS = {COMPLETE_OFF: (FX['DONE'], 1), 0x73: (FX['REQUEST'], 4), 0x77: (FX['LEFT'], 2), 0x79: (FX['TOP'], 2),
             0x7B: (FX['RIGHT'], 2), 0x7D: (FX['BOTTOM'], 2), PHASE_OFF: (FX['PHASE'], 4)}
WORLD_CELLS = {0x5BB1CA: (FX['START_FLAG'], 4), 0x583999: (FX['MODE'], 4), 0x5BB57B: (FX['XFER_5BB57B'], 4),
               0x5BB599: (FX['XFER_5BB599'], 2), 0x5BB595: (FX['XFER_5BB595'], 2), 0x5C39FF: (FX['XFER_5C39FF'], 2),
               0x5BB59B: (FX['XFER_5BB59B'], 4), 0x5BB59F: (FX['XFER_5BB59F'], 4), 0x5BB5A3: (FX['XFER_5BB5A3'], 4)}
SCRATCH = (OWNER + 0x1C, OWNER + 0x28)
CURSOR_CELLS = {'cursor_index': (0x5B44F0, 4), 'cursor_variant': (0x5B44F4, 4), 'item_flag': (0x5B44F8, 4),
                'cursor_surface': (0x5D162D, 4), 'cursor_table': (0x5D1631, 4), 'cursor_layer': (0x5D1639, 4),
                'candidate': (0x5C39E5, 4)}
CURSOR_INPUT = {'held_item': (HELD_CELL, 2), 'surface_default': (0x5D0377, 4), 'surface_held': (0x571AD3, 4),
                'excluded_0': (0x5B4E89, 2), 'excluded_1': (0x5B5100, 2)}
CURSOR_TABLE_BASE = 0x5B160C
SURFACE_DEFAULT, SURFACE_HELD = 0x0D0377, 0x571AD3A

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423d33, 0x423da2, 'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
    (0x423da2, 0x423f57, '10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x42a9b4, 0x42aba4, '6339877da46c0c1a66738bb918087a2cd4c0ceab39811427da4dff64f5c8f8da'),
    (0x42aba4, 0x42ac91, '7d726256e7d84d38c7d1677a579c09be3e2133becfbed78350302c683bec2d2e'),
    (0x414947, 0x414c6d, '1adac407bc2dc2fc8da84913f7fad53e858def5411d5f028e230a96dbc1e4245'),
    (0x4f1eb8, 0x4f257c, '5d6cc6ee1cad1b8ab009d067c780861587598a2087191eca62fdc2d5b01e2395'),
    (0x4f257c, 0x4f25a0, 'c48023991e29570ea72618c1f09e79e8af229aa91ea163182b0a83a1a25d7358'),
    (0x4f25a0, 0x4f2610, 'c19a7e454d4df17d72f993955310e08a7d8a7387b008cd80f0551c8e9d650088'),
    (0x4f6334, 0x4f646c, '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
    (0x4f709c, 0x4f70b0, 'f4378d19b5c3ab0dbd39cba983f59f6dc52989a4d7f3e5211057cd34d287503e'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= 0xFFFFFFFF
    return v - (1 << 32) if v & 0x80000000 else v


def mask_for(effect, value):
    return value & ((1 << FX_BITS[effect]) - 1)


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x1b observers."""

    def __init__(self):
        super().__init__()
        self.entries, self.methods, self.stream, self.scratch_writes, self.other_writes = [], [], [], [], Counter()
        self.row_extent = {}      # row index -> (object, primary, secondary) extents [(va, length)]
        self.read_errors = []
        self.cur_row = -1
        self.total_rows = 0
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))
        self.machine.mem_map(OBJ_BASE, OBJ_SIZE)

    def _row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {ARM: self._entry, METHOD: self._method}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_LO, end=DATA_HI)
        uc.hook_add(UC_HOOK_MEM_READ, self._on_read, begin=OBJ_BASE, end=OBJ_BASE + OBJ_SIZE - 1)

    def _entry(self, uc, address, size, user):
        self.cur_row = self._row_at_arm(uc)
        self.entries.append(self.cur_row)

    def _method(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if ecx != OWNER:
            raise d9.OracleError('method called with this=%#x' % ecx)
        self.methods.append(s16(u32(uc, sp + 4)))

    def _on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        if ROWS <= address < ROWS + self.total_rows * ROW:
            row, off = divmod(address - ROWS, ROW)
            cell = ROW_CELLS.get(off)
            if cell is not None and cell[1] == size:
                self.stream.append((cell[0], row, mask_for(cell[0], value)))
                return
            self.other_writes['row+%#x/%d' % (off, size)] += 1
            return
        cell = WORLD_CELLS.get(address)
        if cell is not None and cell[1] == size:
            self.stream.append((cell[0], self.cur_row, mask_for(cell[0], value)))
            return
        if SCRATCH[0] <= address < SCRATCH[1]:
            self.scratch_writes.append((address, size, value))
            return
        self.other_writes['%#x/%d' % (address, size)] += 1

    def _on_read(self, uc, access, address, size, value, user):
        for extents in self.row_extent.values():
            for va, length in extents:
                if va <= address and address + size <= va + length:
                    return
        self.read_errors.append((address, size))

    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(d9.HEAP_BASE, bytes(self.heap_high - d9.HEAP_BASE))
        uc.mem_write(d9.BODY_BASE, bytes(0x10000))
        uc.mem_write(d9.TIB, bytes(0x1000))
        uc.mem_write(OBJ_BASE, bytes(OBJ_SIZE))
        uc.reg_write(X.UC_X86_REG_FPCW, d9.FPCW)
        self.heap_cursor = self.heap_high = d9.HEAP_BASE
        self.allocs.clear()
        self.frees = []
        self.mode = 'idle'
        self.expect_fatal = None
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.row_extent = {}
        self.clear_logs()

    def clear_logs(self):
        self.entries, self.methods, self.stream, self.scratch_writes = [], [], [], []
        self.other_writes = Counter()
        self.read_errors = []
        self.cur_row = -1

    def install_rows(self, rows, first):
        """rows: dicts with subtype, raw (typed body + dependency tail) and the loader's `loaded` result."""
        total = first + len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows for the oracle storage')
        self.total_rows = total
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        cursor = OBJ_BASE
        self.row_extent = {}

        def place(data, fill=0xA5):
            nonlocal cursor
            cursor = (cursor + 31) & ~15
            self.wr(cursor - 16, bytes([fill]) * 16)
            self.wr(cursor, data)
            self.wr(cursor + len(data), bytes([fill]) * 16)
            at = cursor
            cursor += len(data) + 16
            if cursor > OBJ_BASE + 0x5E0000:
                raise d9.OracleError('object region exhausted')
            return at

        for k, spec in enumerate(rows):
            i = first + k
            base_va = ROWS + i * ROW
            loaded = spec['loaded']
            obj = bytearray(loaded['object'])
            if struct.unpack_from('<II', obj, 0)[0] is None:
                raise d9.OracleError('unreachable')
            primary_va = place(loaded['primary'])
            secondary_va = place(loaded['secondary'])
            struct.pack_into('<I', obj, 2, primary_va)
            struct.pack_into('<I', obj, 30, secondary_va)
            object_va = place(bytes(obj))
            spec['object_va'], spec['primary_va'], spec['secondary_va'] = object_va, primary_va, secondary_va
            self.row_extent[i] = [(object_va, 34), (primary_va, len(loaded['primary'])), (secondary_va, len(loaded['secondary']))]
            self.wr(base_va + 0x30, bytes([TYPE, spec['subtype']]) + struct.pack('<I', object_va))
            tail = spec['raw'][loaded['advance']:]
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base_va, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base_va + COMPLETE_OFF, b'\0')
            self.w32(base_va + PHASE_OFF, 0)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def snapshot_objects(self):
        out = {}
        for i, extents in self.row_extent.items():
            out[i] = [self.rd(va, n) for va, n in extents]
        return out

    def dispatch(self):
        self.clear_logs()
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'

    def cascade(self, case):
        """0x4f1eb8..: the generic row loop of the pointer cascade with a pre-transformed pointer."""
        uc = self.machine
        self.clear_logs()
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', len(case['rows'])))
        self.wr(ROWS, bytes(len(case['rows']) * ROW))
        self.total_rows = len(case['rows'])
        for name, (address, size) in CURSOR_CELLS.items():
            self.wr(address, case['initial'][name].to_bytes(size, 'little', signed=case['initial'][name] < 0))
        for name, (address, size) in CURSOR_INPUT.items():
            self.wr(address, case['inputs'][name].to_bytes(size, 'little', signed=case['inputs'][name] < 0))
        self.wr(CASCADE_THIS, bytes(0x1000))
        self.wr(CASCADE_THIS + 0x5A, struct.pack('<I', case['y']))
        self.wr(CASCADE_THIS + 0x5E, struct.pack('<I', case['x']))
        self.wr(CASCADE_EBP - 4, struct.pack('<I', CASCADE_THIS))
        self.wr(CASCADE_EBP, struct.pack('<II', 0, deps.RETURN_SENTINEL))
        for k, spec in enumerate(case['rows']):
            base_va = ROWS + k * ROW
            self.wr(base_va + 0x30, bytes([spec['type'], 1]) + struct.pack('<I', spec['object_va']))
            self.w32(base_va + 0x73, spec['request'])
            for off, value in zip((0x77, 0x79, 0x7B, 0x7D), spec['rect']):
                self.wr(base_va + off, struct.pack('<h', value))
        self.row_extent['this'] = [(CASCADE_THIS, 0x1000)]
        self.mode = 'step'
        uc.reg_write(X.UC_X86_REG_EBP, CASCADE_EBP)
        uc.reg_write(X.UC_X86_REG_ESP, CASCADE_EBP - 0x200)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        self._hook_error = None
        try:
            uc.emu_start(CASCADE, deps.RETURN_SENTINEL, timeout=900_000_000, count=0)
        finally:
            self.mode = 'idle'
        if self._hook_error:
            raise d9.OracleError(self._hook_error)
        if uc.reg_read(X.UC_X86_REG_EIP) != deps.RETURN_SENTINEL:
            raise d9.OracleError('cascade fragment did not return')
        if self.read_errors:
            raise d9.OracleError('cascade read beyond an object: %r' % self.read_errors[:3])
        out = {name: struct.unpack('<I', self.rd(address, 4))[0] if size == 4 else struct.unpack('<H', self.rd(address, 2))[0]
               for name, (address, size) in CURSOR_CELLS.items()}
        written = {name for name, (address, size) in CURSOR_CELLS.items() if any(a == address for a in self.other_writes_addr)}
        return out, written

    @property
    def other_writes_addr(self):
        return [int(k.split('/')[0], 16) for k in self.other_writes if k.startswith('0x')]


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_1b_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a1b.c', 'action_family_1b_runtime.c', 'action_family_1b.c',
                                            'scene_resource.c', 'hiff.c', 'session_input.c', 'input_consume.c', 'input_latch.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A1B_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-1200:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a1bo_new.restype = C.c_void_p
        lib.a1bo_free.argtypes = [C.c_void_p]
        lib.a1bo_begin.argtypes = [C.c_void_p, C.c_char_p, C.c_uint]
        lib.a1bo_begin.restype = C.c_int
        lib.a1bo_set_world.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int]
        lib.a1bo_start_flag.argtypes = [C.c_void_p]
        lib.a1bo_start_flag.restype = C.c_int
        lib.a1bo_pregate.argtypes = [C.c_void_p, C.c_uint]
        lib.a1bo_visit.argtypes = [C.c_void_p, C.c_uint, C.c_int, C.c_uint, C.POINTER(C.c_int), C.POINTER(C.c_uint),
                                   C.POINTER(C.c_int)]
        lib.a1bo_visit.restype = C.c_int
        lib.a1bo_fx_count.argtypes = [C.c_void_p]
        lib.a1bo_fx_count.restype = C.c_uint
        lib.a1bo_fx_get.argtypes = [C.c_void_p, C.c_uint, C.POINTER(C.c_int), C.POINTER(C.c_int), C.POINTER(C.c_int)]
        lib.a1bo_fx_clear.argtypes = [C.c_void_p]
        lib.a1bo_transitions.argtypes = [C.c_void_p]
        lib.a1bo_transitions.restype = C.c_uint
        lib.a1bo_slot.argtypes = [C.c_void_p, C.c_uint] + [C.POINTER(C.c_int)] * 6
        lib.a1bo_slot.restype = C.c_int
        lib.a1bo_cascade.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int] + [C.POINTER(C.c_int)] * 6
        lib.a1bo_cascade.restype = C.c_int
        self.h = lib.a1bo_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.a1bo_free(self.h)

    def begin(self, scene):
        return self.lib.a1bo_begin(self.h, scene, len(scene))

    def set_world(self, selector, held, start_flag):
        self.lib.a1bo_set_world(self.h, selector, held, start_flag)

    def start_flag(self):
        return self.lib.a1bo_start_flag(self.h)

    def pregate(self, row):
        self.lib.a1bo_pregate(self.h, row)

    def visit(self, row, completed, phase):
        disposition, phase_out, done = C.c_int(), C.c_uint(), C.c_int()
        status = self.lib.a1bo_visit(self.h, row, completed, phase, C.byref(disposition), C.byref(phase_out), C.byref(done))
        return status, disposition.value, phase_out.value, done.value

    def effects(self, row_offset=0):
        out = []
        for i in range(self.lib.a1bo_fx_count(self.h)):
            row, effect, value = C.c_int(), C.c_int(), C.c_int()
            self.lib.a1bo_fx_get(self.h, i, C.byref(row), C.byref(effect), C.byref(value))
            out.append((effect.value, row.value + row_offset, mask_for(effect.value, value.value)))
        self.lib.a1bo_fx_clear(self.h)
        return out

    def slot(self, row):
        v = [C.c_int() for _ in range(6)]
        if self.lib.a1bo_slot(self.h, row, *[C.byref(x) for x in v]) != 0:
            raise d9.OracleError('native slot read failed')
        return [x.value for x in v]

    def cascade(self, held, x, y):
        v = [C.c_int() for _ in range(6)]
        status = self.lib.a1bo_cascade(self.h, held, x, y, *[C.byref(a) for a in v])
        if status != 0:
            raise d9.OracleError('native cascade failed %d' % status)
        return [a.value for a in v]


# ---------------------------------------------------------------------------------------------
# the original loader (machine A)
# ---------------------------------------------------------------------------------------------
class Loader:
    def __init__(self):
        pe = PEImage.parse_and_map(d9.DEFAULT_EXE)
        self.machine = LoaderMachine(pe)
        self.cache = {}
        self.calls = 0

    def build(self, subtype, raw):
        k = (subtype, raw)
        if k not in self.cache:
            payload = b'oracle'.ljust(48, b'\0') + bytes([TYPE, subtype]) + raw
            self.cache[k] = self.machine.invoke(raw, payload, seed=bytes([len(self.cache) & 0xFF]))
            self.calls += 1
        return self.cache[k]


# ---------------------------------------------------------------------------------------------
# bodies and scenarios
# ---------------------------------------------------------------------------------------------
def body_1b(primary, fixed, secondary):
    """count, count x 22-byte records (key, target, w4, w6, w8, d0, d1, d2), fixed words and dwords, count, count x 18-byte records
    (selector, left, top, right, bottom dwords)."""
    out = struct.pack('<h', len(primary))
    for rec in primary:
        out += struct.pack('<hhhhhiii', *[s16(v) for v in rec[:5]], *[s32(v) for v in rec[5:]])
    out += struct.pack('<5h3i', *[s16(v) for v in fixed[:5]], *[s32(v) for v in fixed[5:]])
    out += struct.pack('<h', len(secondary))
    for sel, a, b, c, d in secondary:
        out += struct.pack('<hiiii', s16(sel), *[s32(v) for v in (a, b, c, d)])
    return out


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def parse_tables(raw):
    """(primary records, fixed, secondary records) of a raw body as tuples, for the scenario generator."""
    p = struct.unpack_from('<h', raw)[0]
    primary = [struct.unpack_from('<hhhhhIII', raw, 2 + 22 * k) for k in range(p)]
    fixed = struct.unpack_from('<5hIII', raw, 2 + 22 * p)
    s = struct.unpack_from('<h', raw, 24 + 22 * p)[0]
    secondary = [struct.unpack_from('<hIIII', raw, 26 + 22 * p + 18 * k) for k in range(s)]
    return primary, fixed, secondary


def R(body, subtype=1, tail=b''):
    return dict(subtype=subtype, body=body, tail=tail)


def fixed_pack(rng=None, extreme=False):
    if extreme:
        return (0x8000, 0xFFFF, 0x7FFF, 0x8000, 0xFFFF, 0x80000000, 0xFFFFFFFF, 0x7FFFFFFF)
    return (rng.randrange(0x10000), rng.randrange(0x10000), rng.randrange(0x10000), rng.randrange(0x10000), rng.randrange(0x10000),
            rng.randrange(1 << 32), rng.randrange(1 << 32), rng.randrange(1 << 32))


KEYS = [0, 1, 2, 5, 7, 9, 12, 40, 0x7FFF, 0x8000, 0xFFFF, 0xFFFE, 0x1234, 0x0100]


def rand_body(rng, p=None, s=None, keys=KEYS):
    p = rng.choice((0, 1, 1, 2, 3, 5)) if p is None else p
    s = rng.choice((0, 1, 1, 2, 3, 5)) if s is None else s
    primary = [(rng.choice(keys),) + tuple(rng.randrange(0x10000) for _ in range(4)) + tuple(rng.randrange(1 << 32) for _ in range(3))
               for _ in range(p)]
    secondary = [(rng.choice(keys),) + tuple(rng.randrange(1 << 32) for _ in range(4)) for _ in range(s)]
    return body_1b(primary, fixed_pack(rng, extreme=rng.random() < 0.25), secondary)


def scenario_list(seed=0x40, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, events=kw.pop('events', {}),
                        mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0),
                        selector=kw.pop('selector', 7), held=kw.pop('held', -1), seed=rng.randrange(1 << 30)))

    def lifecycle(extra=()):
        return [('tick',), ('tick',), ('setphase', 0, 2), ('tick',), ('rearm',), ('setphase', 0, 2), ('held', 5), ('tick',), ('rearm',),
                *extra]

    if corpus:
        # The real dependency records of the corpus rows are not replayed (the gate is shared, separately verified code): each row
        # runs with its real typed body and either no dependency or a stand-in event record.
        typed_of = lambda raw: raw[:26 + 22 * len(parse_tables(raw)[0]) + 18 * len(parse_tables(raw)[2])]  # noqa: E731
        for k, (st, raw) in enumerate(corpus):
            primary, fixed, secondary = parse_tables(raw)
            sel_hit = secondary[0][0] if secondary else 0
            held_hit = primary[0][0] if primary else -1
            steps = [('selector', sel_hit), ('tick',), ('tick',), ('selector', s16(sel_hit) + 1), ('tick',), ('selector', sel_hit),
                     ('tick',), ('held', held_hit), ('setphase', 0, 2), ('tick',), ('rearm',), ('held', -1), ('setphase', 0, 2), ('tick',),
                     ('rearm',), ('held', 4321), ('setphase', 0, 2), ('tick',)]
            S('corpus:%d' % k, [R(typed_of(raw), st)], steps, group='corpus', quick=k < 2)
            S('corpus_gated:%d' % k, [R(typed_of(raw), st, event_tail(1000 + k, 1))],
              [('selector', sel_hit), ('tick',), ('events', {1000 + k: 1}), ('tick',), ('setphase', 0, 2), ('tick',), ('rearm',)] + steps[-6:],
              group='corpus', events={1000 + k: 0}, quick=k == 0)
        S('corpus:all', [R(typed_of(raw), st) for st, raw in corpus],
          [('selector', 1), ('tick',), ('tick',), ('setphase', 0, 2), ('setphase', 2, 2), ('tick',)], group='corpus')
    # phases: every phase value on a row with real tables
    table = body_1b([(5, 4005, 1, 2, 3, 50, 51, 52), (9, 4009, -2, 3, 4, 90, -91, 92), (9, 4999, 0, 0, 0, 1, 1, 1),
                     (0x7FFF, 0x8001, 0xFFFF, 0x8000, 0x7FFF, 0xFFFFFFFE, 0x80000000, 0x7FFFFFFF)],
                    (11, 0xFFFD, 7, 0xFFF8, 9, 70000, 0xFFFEF2A8, 72),
                    [(7, 0x7ABC0111, 0x7BCD0222, 0x7CDE0333, 0x7DEF0444), (3, 0x555, 0x666, 0x777, 0x888), (7, 1, 2, 3, 4)])
    for phase in (0, 1, 2, 3, 4, 7, 255, 0xFFFFFFFF, 0x80000000):
        S('phase:%#x' % phase, [R(table)], [('setphase', 0, phase), ('tick',), ('tick',)], group='phase', quick=phase in (0, 1, 2, 3, 0xFFFFFFFF))
    for held in (-1, 5, 9, 1234, 0x7FFF, -32768):
        S('held:%d' % held, [R(table)], [('setphase', 0, 2), ('tick',)], group='held', held=held, quick=held in (-1, 5, 9, 1234, 0x7FFF))
    for sel in (7, 3, 99, -1, 0, -32768, 0x7FFF):
        S('selector:%d' % sel, [R(table)], [('tick',), ('tick',), ('selector', 7), ('tick',), ('selector', 3), ('tick',)], group='selector',
          selector=sel, quick=sel in (7, 3, 99, -1))
    # empty tables, one-record tables, key and selector extremes
    S('tables:empty', [R(body_1b([], (1, 2, 3, 4, 5, 6, 7, 8), []))], lifecycle(), group='tables', quick=True)
    S('tables:fixed_extremes', [R(body_1b([], fixed_pack(extreme=True), [(7, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF, 0x10000)]))],
      [('tick',), ('setphase', 0, 2), ('tick',)], group='tables', quick=True)
    S('tables:sign_edges', [R(body_1b([(0x8000, 100, 1, 2, 3, 4, 5, 6), (0xFFFF, 200, 1, 2, 3, 4, 5, 6), (0, 300, 1, 2, 3, 4, 5, 6)],
                                     (0, 400, 0, 0, 0, 0, 0, 0), [(0x8000, 1, 2, 3, 4), (0xFFFF, 5, 6, 7, 8), (0, 9, 10, 11, 12)]))],
      [('selector', -32768), ('tick',), ('selector', -1), ('tick',), ('selector', 0), ('tick',), ('selector', 7), ('tick',)] +
      [item for h in (-32768, -1, 0, 1) for item in (('held', h), ('setphase', 0, 2), ('tick',), ('rearm',))], group='tables', quick=True)
    S('tables:wide', [R(rand_body(random.Random(5), 300, 250))], [('selector', 3), ('tick',), ('held', 9), ('setphase', 0, 2), ('tick',)],
      group='tables', quick=False)
    S('tables:last_record', [R(body_1b([(k, 1000 + k, k, k, k, k, k, k) for k in range(40)], fixed_pack(random.Random(1)),
                                       [(k, k, k, k, k) for k in range(40)]))],
      [('selector', 39), ('tick',), ('held', 39), ('setphase', 0, 2), ('tick',)], group='tables', quick=True)
    # rows: order, gate, finish ends the pass, rows after a finished row, done rows before the first row
    S('order:finish_ends_pass', [R(table), R(table), R(table)], [('setphase', 0, 2), ('setphase', 1, 2), ('tick',), ('tick',), ('rearm',), ('tick',)],
      group='order', held=5, quick=True)
    S('order:finish_last', [R(table), R(table)], [('setphase', 1, 2), ('tick',), ('tick',), ('rearm',), ('setphase', 1, 2), ('tick',)], group='order', quick=True)
    S('rows:offset_first_row', [R(table), R(table)], [('tick',), ('tick',), ('setphase', 1, 2), ('tick',)], group='rows', first=3, quick=True)
    S('gate:event_false_leaves_row', [R(table, 1, event_tail(1040, 1)), R(table, 1, event_tail(1041, 1)), R(table)],
      [('tick',), ('events', {1040: 1}), ('tick',), ('setphase', 0, 2), ('tick',)], group='gate', events={1040: 7, 1041: 7}, quick=True)
    S('gate:mode4_runs_nothing', [R(table), R(table)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, quick=True)
    S('gate:request_cleared_behind_a_false_gate', [R(table, 1, event_tail(1060, 1))],
      [('events', {1060: 1}), ('tick',), ('events', {1060: 0}), ('tick',), ('events', {1060: 1}), ('tick',)], group='gate', events={1060: 0}, quick=True)
    for subtype in (0, 1, 2, 3, 255):
        S('subtype:%d' % subtype, [R(table, subtype)], lifecycle(), group='subtype', quick=subtype in (0, 2))
    for n in range(120):
        rows = []
        for _ in range(rng.randint(1, 8)):
            tail = event_tail(1000 + rng.randrange(60), rng.randrange(-2, 3)) if rng.random() < 0.25 else b''
            rows.append(R(rand_body(rng), rng.choice((0, 1, 1, 2, 3, 255)), tail))
        acts = []
        for _ in range(rng.randint(4, 12)):
            r = rng.random()
            if r < 0.35:
                acts.append(('tick',))
            elif r < 0.50:
                acts.append(('selector', rng.choice(KEYS)))
            elif r < 0.62:
                acts.append(('held', rng.choice(KEYS + [-1])))
            elif r < 0.78:
                acts.append(('setphase', rng.randrange(len(rows)), rng.choice((0, 1, 1, 2, 2, 2, 3, 9))))
            elif r < 0.88:
                acts.append(('rearm',))
            elif r < 0.94:
                acts.append(('events', {1000 + rng.randrange(60): rng.randrange(-2, 3) for _ in range(6)}))
            else:
                acts.append(('startflag', rng.choice((0, 1, 5, -1))))
        acts.append(('tick',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 3, selector=rng.choice(KEYS), held=rng.choice(KEYS + [-1]),
          first=rng.choice((0, 0, 0, 2)))
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x1b rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_1b_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a1b.c', 'action_family_1b_runtime.c', 'action_family_1b.c',
                                                                    'scene_resource.c', 'hiff.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        subtype, hexbody = line.split()
        rows.append((int(subtype), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, finishes=0, phase0=0, phase1=0, phase2=0, other_phase=0,
                hover_hits=0, stream_events=0, loader_objects=0, loader_bytes=0, cells_compared=0,
                cascade_cases=0, cascade_hits=0, cascade_misses=0, cascade_held=0, mismatches=0, groups={})


def row_gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


def run_scenario(x, nat, loader, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'])
    try:
        run_scenario_inner(x, nat, loader, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += stats['rows_visited'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


class Scenario:
    def __init__(self, sc, rows, first):
        self.sc, self.rows, self.first = sc, rows, first
        self.mode = sc['mode']
        self.completed = [1 if i < first else 0 for i in range(first + len(rows))]
        self.phases = [0] * (first + len(rows))
        self.selector, self.held, self.start_flag = sc['selector'], sc['held'], 0


def run_scenario_inner(x, nat, loader, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    for r in rows:
        r['raw'] = r['body'] + r['tail']
        r['loaded'] = loader.build(r['subtype'], r['raw'])
        if r['loaded']['advance'] != len(r['body']):
            raise Mismatch('%s: the original loader consumed %d bytes of a %d byte typed body' % (sc['id'], r['loaded']['advance'], len(r['body'])))
        stats['loader_objects'] += 1
        stats['loader_bytes'] += 34 + len(r['loaded']['primary']) + len(r['loaded']['secondary'])
    scene = base.scene_bytes([base.action(TYPE, r['subtype'], r['raw']) for r in rows])
    status = nat.begin(scene)
    if status != 0:
        raise Mismatch('%s: native begin_scene status %d' % (sc['id'], status))
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    st = Scenario(sc, rows, first)
    x.wr(SELECTOR_CELL, struct.pack('<h', s16(st.selector)))
    x.wr(HELD_CELL, struct.pack('<h', s16(st.held)))
    x.w32(0x5BB1CA, 0)
    nat.effects()
    st.objects = x.snapshot_objects()
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, st, stats)
        elif kind == 'rearm':
            for i in range(first, first + len(rows)):
                st.completed[i] = 0
                st.phases[i] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'setphase':
            x.w32(ROWS + (first + act[1]) * ROW + PHASE_OFF, act[2])
            st.phases[first + act[1]] = act[2]
        elif kind == 'selector':
            st.selector = s16(act[1])
            x.wr(SELECTOR_CELL, struct.pack('<h', st.selector))
        elif kind == 'held':
            st.held = s16(act[1])
            x.wr(HELD_CELL, struct.pack('<h', st.held))
        elif kind == 'startflag':
            st.start_flag = act[1]
            x.w32(0x5BB1CA, act[1])
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        elif kind == 'mode':
            st.mode = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def fmt_stream(stream):
    return ', '.join('%s@%d=%#x' % (FXN.get(k, k), r, v) for k, r, v in stream[:40]) + (' ...' if len(stream) > 40 else '')


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    first, rows = st.first, st.rows
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    start_flag_before = struct.unpack('<i', x.rd(0x5BB1CA, 4))[0]
    st.start_flag = start_flag_before
    x.dispatch()
    nat.effects()
    nat.set_world(st.selector, st.held, start_flag_before)
    expected_entered, visited = [], []
    finished = False
    if st.mode == 3:
        for i in range(first, total):
            if st.completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            nat.pregate(i - first)
            if not row_gate_open(spec, flags):
                continue
            visited.append(i)
            phase_in = st.phases[i]
            status, disposition, phase, done = nat.visit(i - first, st.completed[i], phase_in)
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            st.completed[i], st.phases[i] = done, phase
            if phase_in == 0:
                stats['phase0'] += 1
            elif phase_in == 1:
                stats['phase1'] += 1
            elif phase_in == 2:
                stats['phase2'] += 1
            else:
                stats['other_phase'] += 1
            if disposition == 3:   # DIRECT_COMPLETED: the mode becomes 4 and the pass ends
                finished = True
                stats['finishes'] += 1
                break
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.methods != visited:
        raise Mismatch('%s: the original ran the method for rows %s, the model expects %s' % (where, x.methods, visited))
    stats['rows_visited'] += len(visited)
    stats['rows_gated'] += len(expected_entered) - len(visited)
    # the ordered store stream
    native_stream = nat.effects(first)
    if x.stream != native_stream:
        first_diff = next((k for k, (a, b) in enumerate(zip(x.stream, native_stream)) if a != b), min(len(x.stream), len(native_stream)))
        raise Mismatch('%s: store streams differ at %d: original %s | native %s' % (
            where, first_diff, fmt_stream(x.stream[max(first_diff - 1, 0):]), fmt_stream(native_stream[max(first_diff - 1, 0):])))
    stats['stream_events'] += len(x.stream)
    if x.other_writes:
        unexpected = {k: v for k, v in x.other_writes.items() if k not in GATE_WRITES}
        if unexpected:
            raise Mismatch('%s: writes outside the modeled cells: %r' % (where, unexpected))
    if x.read_errors:
        raise Mismatch('%s: the original read beyond an object: %r' % (where, x.read_errors[:3]))
    # the method's scratch: object, primary array, secondary array of the last visited row
    if visited:
        spec = rows[visited[-1] - first]
        want = {OWNER + 0x1C: spec['object_va'], OWNER + 0x20: spec['primary_va'], OWNER + 0x24: spec['secondary_va']}
        got = {}
        for address, size, value in x.scratch_writes:
            if size != 4:
                raise Mismatch('%s: scratch write of %d bytes at %#x' % (where, size, address))
            got[address] = value
        if got != want:
            raise Mismatch('%s: method scratch %r, expected %r' % (where, {hex(k): hex(v) for k, v in got.items()}, {hex(k): hex(v) for k, v in want.items()}))
    elif x.scratch_writes:
        raise Mismatch('%s: scratch written without a method call' % where)
    # every row cell, the start flag, the mode and the objects
    mode_after = struct.unpack('<i', x.rd(0x583999, 4))[0]
    want_mode = 4 if finished else st.mode
    if mode_after != want_mode:
        raise Mismatch('%s: engine mode %d, expected %d' % (where, mode_after, want_mode))
    st.mode = mode_after
    if struct.unpack('<i', x.rd(0x5BB1CA, 4))[0] != nat.start_flag():
        raise Mismatch('%s: start flag original %d native %d' % (where, struct.unpack('<i', x.rd(0x5BB1CA, 4))[0], nat.start_flag()))
    for i in range(first, total):
        base_va = ROWS + i * ROW
        done = x.rd(base_va + COMPLETE_OFF, 1)[0]
        phase = struct.unpack('<I', x.rd(base_va + PHASE_OFF, 4))[0]
        request = struct.unpack('<i', x.rd(base_va + 0x73, 4))[0]
        rect = [struct.unpack('<h', x.rd(base_va + off, 2))[0] for off in (0x77, 0x79, 0x7B, 0x7D)]
        n_request, left, top, right, bottom, _n_done = nat.slot(i - first)
        if (done, phase, request, rect) != (st.completed[i], st.phases[i], n_request, [s16(left), s16(top), s16(right), s16(bottom)]):
            raise Mismatch('%s: row %d original (done %d phase %#x request %d rect %r) native (done %d phase %#x request %d rect %r)' % (
                where, i, done, phase, request, rect, st.completed[i], st.phases[i], n_request, [left, top, right, bottom]))
        stats['cells_compared'] += 7
        if i in visited and request not in (0, 1):
            raise Mismatch('%s: request dword %d' % (where, request))
    if x.snapshot_objects() != st.objects:
        raise Mismatch('%s: the method changed a row object or array' % where)
    # coverage of the table paths
    for e, r, v in x.stream:
        if e == FX['REQUEST'] and v == 1:
            stats['hover_hits'] += 1


GATE_WRITES = {'0x637871/4', '0x637e81/4', '0x5c3a47/4', 'row+0x36/4'}   # gate bookkeeping of 0x423f57 (the gate object 0x63786d, its flag, the row's dependency state)


# ---------------------------------------------------------------------------------------------
# the pointer cascade
# ---------------------------------------------------------------------------------------------
def cascade_cases(x, nat, loader, count, stats, seed=0x4F22AD):
    for index in range(count):
        rng = random.Random(seed + index)
        nrows = rng.randrange(1, 7)
        specs = []
        for k in range(nrows):
            left, top = rng.randrange(0, 600), rng.randrange(0, 440)
            right, bottom = left + rng.randrange(0, 90), top + rng.randrange(0, 70)
            requested = rng.random() < 0.7
            fixed = fixed_pack(rng)
            fixed = (rng.choice((0, 1, 2, 5, 11, 0x25, 0x7FFF, 0x8000, 0xFFFF, rng.randrange(0x10000))),) + fixed[1:]
            # one secondary record whose selector is 100 + row and whose rectangle is the row's rectangle
            body = body_1b([], fixed, [(100 + k, left, top, right, bottom)])
            specs.append(dict(subtype=1, body=body, tail=b'', rect=(left, top, right, bottom), requested=requested, cursor=s16(fixed[0])))
        x.hard_reset()
        rows = [dict(r, raw=r['body']) for r in specs]
        for r in rows:
            r['loaded'] = loader.build(1, r['raw'])
        x.install_rows(rows, 0)
        scene = base.scene_bytes([base.action(TYPE, 1, r['raw']) for r in rows])
        if nat.begin(scene) != 0:
            raise Mismatch('cascade %d: native begin failed' % index)
        nat.effects()
        for k, r in enumerate(rows):
            nat.pregate(k)
            nat.set_world(100 + k if r['requested'] else -9999, -1, 0)
            status, _d, _p, _done = nat.visit(k, 0, 1)
            if status != 0:
                raise Mismatch('cascade %d: native visit failed' % index)
        nat.effects()
        pick = rng.choice(specs)
        l, t, r_, b = pick['rect']
        if rng.random() < 0.75:
            px = rng.choice((l, r_, l - 1, r_ + 1, (l + r_) // 2, l + (r_ - l) // 3))
            py = rng.choice((t, b, t - 1, b + 1, (t + b) // 2, t + (b - t) // 3))
        else:
            px, py = rng.randrange(0, 640), rng.randrange(0, 480)
        px, py = min(max(px, 0), 639), min(max(py, 0), 479)
        held = rng.choice((-1, -1, 0, 4, 5, 40, -2, 1000))
        case = dict(rows=[dict(type=TYPE, request=1 if r['requested'] else 0, rect=r['rect'], object_va=r['object_va']) for r in rows],
                    x=px, y=py,
                    initial={'cursor_index': 0x1111, 'cursor_variant': 0x2222, 'item_flag': 0x3333, 'cursor_surface': 0x4444,
                             'cursor_table': 0x5555, 'cursor_layer': 0x6666, 'candidate': 0xFFFFFFB3},
                    inputs={'held_item': held, 'surface_default': SURFACE_DEFAULT, 'surface_held': SURFACE_HELD, 'excluded_0': -1,
                            'excluded_1': -1})
        got, _written = x.cascade(case)
        cand, cursor_index, variant, held_flag, surface, table_offset = nat.cascade(held, px, py)
        original_candidate = s32(got['candidate']) if got['candidate'] != 0xFFFFFFB3 else -1
        if cand != original_candidate:
            raise Mismatch('cascade %d: candidate native %d original %d (case %r)' % (index, cand, original_candidate, case['rows']))
        stats['cascade_cases'] += 1
        if cand < 0:
            stats['cascade_misses'] += 1
            if got['cursor_index'] != 0x1111 or got['cursor_surface'] != 0x4444 or got['item_flag'] != 0:
                raise Mismatch('cascade %d: a miss wrote the cursor cells %r' % (index, got))
            continue
        stats['cascade_hits'] += 1
        if held != -1:
            stats['cascade_held'] += 1
        want_surface = {0: 0x4444, 1: SURFACE_DEFAULT, 2: SURFACE_HELD}[surface]
        if (got['cursor_index'], got['cursor_variant'], got['item_flag'], got['cursor_surface'], got['cursor_table'], got['cursor_layer']) != \
                (cursor_index & 0xFFFFFFFF, variant, held_flag, want_surface, (CURSOR_TABLE_BASE + table_offset) & 0xFFFFFFFF, 1):
            raise Mismatch('cascade %d: cursor original %r native (%d, %d, %d, %#x, %#x) held %d' % (
                index, got, cursor_index, variant, held_flag, want_surface, CURSOR_TABLE_BASE + table_offset, held))


def run_list(x, nat, loader, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, nat, loader, sc, stats)
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


# native mutants: each must be caught by the quick scenario set and the quick cascade set
BIND = 'session_bindings_a1b.c'
KERN = 'action_family_1b_runtime.c'
MUTANTS = {
    'phase 0 skips the start flag': ('        w.start_flag_5bb1ca = 1;\n        fx(host, ACTION17_FX_START_FLAG, 1);\n', '', KERN),
    'phase 0 keeps phase 0': ('        r.phase_after = 1u;\n        fx(host, ACTION17_FX_PHASE, 1);', '        fx(host, ACTION17_FX_PHASE, 1);', KERN),
    'phase 0 does not run phase 1': ('        r.phase_after = 1u;\n        fx(host, ACTION17_FX_PHASE, 1);\n        phase_one = 1;', '        r.phase_after = 1u;\n        fx(host, ACTION17_FX_PHASE, 1);', KERN),
    'request not cleared first': ('        s.request = 0;\n        fx(host, ACTION17_FX_REQUEST, 0);\n', '', KERN),
    'secondary scan takes the last hit': ('            r.matched_record = i;\n            break;\n        }\n    }\n\n    r.requested', '            r.matched_record = i;\n        }\n    }\n\n    r.requested', KERN),
    'secondary selector compared as unsigned byte': ('if (rd_s16(rec) != w.selector) {\n                continue;\n            }\n            s.request = 1;', 'if ((rd_s16(rec) & 0xff) != (w.selector & 0xff)) {\n                continue;\n            }\n            s.request = 1;', KERN),
    'secondary selector against the held item': ('if (rd_s16(rec) != w.selector) {\n                continue;\n            }\n            s.request = 1;', 'if (rd_s16(rec) != w.held_item) {\n                continue;\n            }\n            s.request = 1;', KERN),
    'left from the high word': ('s.left = rd_s16(rec + 2);', 's.left = rd_s16(rec + 4);', KERN),
    'top and bottom swapped': ('s.top = rd_s16(rec + 6);', 's.top = rd_s16(rec + 14);', KERN),
    'right from the left dword': ('s.right = rd_s16(rec + 10);', 's.right = rd_s16(rec + 2);', KERN),
    'bottom from the top dword': ('s.bottom = rd_s16(rec + 14);', 's.bottom = rd_s16(rec + 6);', KERN),
    'secondary record stride 16': ('decoded->secondary_records + (size_t)i * 18u', 'decoded->secondary_records + (size_t)i * 16u', KERN),
    'secondary count off by one': ('for (i = 0; i < decoded->secondary_count; ++i) {', 'for (i = 0; i + 1 < decoded->secondary_count; ++i) {', KERN),
    'completion byte skipped': ('        s.done = 1u;\n        fx(host, ACTION17_FX_DONE, 1);\n', '', KERN),
    'primary scan takes the last hit': ('            r.matched_record = i;\n            hit = 1;\n            break;', '            r.matched_record = i;\n            hit = 1;', KERN),
    'primary key against the selector': ('if (rd_s16(rec) != w.held_item) {\n                continue;\n            }\n            w.xfer_5bb57b', 'if (rd_s16(rec) != w.selector) {\n                continue;\n            }\n            w.xfer_5bb57b', KERN),
    'target not sign-extended': ('w.xfer_5bb57b = rd_s16(rec + 2);', 'w.xfer_5bb57b = (uint16_t)rd_s16(rec + 2);', KERN),
    'primary words shifted': ('w.xfer_5bb599 = rd_s16(rec + 4);', 'w.xfer_5bb599 = rd_s16(rec + 6);', KERN),
    'primary word 8 dropped': ('w.xfer_5c39ff = rd_s16(rec + 8);', 'w.xfer_5c39ff = 0;', KERN),
    'primary dwords shifted': ('w.xfer_5bb59f = rd_s32(rec + 14);', 'w.xfer_5bb59f = rd_s32(rec + 10);', KERN),
    'fixed block used even with a hit': ('        if (!hit) {', '        if (!hit || d->primary_count >= 0) {', KERN),
    'fixed block never used': ('        if (!hit) {', '        if (!hit && d->primary_count < 0) {', KERN),
    'fixed target from word 0': ('w.xfer_5bb57b = as_s16(d->fixed_words[1]);', 'w.xfer_5bb57b = as_s16(d->fixed_words[0]);', KERN),
    'fixed word 3 from word 2': ('w.xfer_5bb595 = as_s16(d->fixed_words[3]);', 'w.xfer_5bb595 = as_s16(d->fixed_words[2]);', KERN),
    'fixed dword 2 from dword 1': ('w.xfer_5bb5a3 = as_s32(d->fixed_dwords[2]);', 'w.xfer_5bb5a3 = as_s32(d->fixed_dwords[1]);', KERN),
    'finish not reported': ('        r.finished = 1u;\n    }\n\n    if (phase_one)', '    }\n\n    if (phase_one)', KERN),
    'phase 2 also scans the secondary table': ('    } else if (phase == 2u) {\n        const ActionFamily1bDecoded *d = decoded;', '    } else if (phase == 2u) {\n        phase_one = 1;\n        const ActionFamily1bDecoded *d = decoded;', KERN),
    'phase 3 acts like phase 1': ('    } else if (phase == 1u) {\n        phase_one = 1;', '    } else if (phase == 1u || phase == 3u) {\n        phase_one = 1;', KERN),
    'cursor index from the second fixed word': ('c.cursor_index = as_s16(decoded->fixed_words[0]);', 'c.cursor_index = as_s16(decoded->fixed_words[1]);', KERN),
    'cursor with a held item keeps the fixed word': ('        c.cursor_index = (int32_t)held_item + 0x25;\n        c.surface = ACTION17_SURFACE_HELD;', '        c.cursor_index = as_s16(decoded->fixed_words[0]);\n        c.surface = ACTION17_SURFACE_HELD;', KERN),
    'cursor variant 0': ('    c.variant = 1;\n    c.table_offset', '    c.variant = 0;\n    c.table_offset', KERN),
    'pre-gate leaves the request': ('        b->slots[index].request = 0;\n        b->current_row = index;', '        b->current_row = index;', BIND),
    'finish committed as pending': ('SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING', 'SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING', BIND),
    'phase not reported': ('    out->phase = result.phase_after;', '    out->phase = before->phase;', BIND),
    'world not stored': ('    if (b->host.store_world != NULL) {', '    if (0) {', BIND),
    'wrong row slot': ('    slot = b->slots[index];\n', '    slot = b->slots[index ? index - 1u : 0u];\n', BIND),
}
MUTANTS['primary record stride 20'] = ('d->primary_records + (size_t)i * 22u', 'd->primary_records + (size_t)i * 20u', KERN)


def mutation_check(args, workdir):
    report = []
    for name, (old, new, filename) in MUTANTS.items():
        source = (args.src / filename).read_text()
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted'))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / filename).write_text(source.replace(old, new))
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))
        except d9.OracleError as error:
            report.append(dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:160]))
            continue
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=first[6:][:200] if first else None))
    return report


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--mutations', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--cascade-cases', type=int, default=600)
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-40.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver1b.so')
    nat = Native(lib_path)
    loader = Loader()
    x = Oracle()
    corpus = load_corpus()
    scs = scenario_list(corpus=corpus)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only or args.mutation_run:
        scs = [s for s in scs if s['quick']]
    stats = new_stats()
    bad = run_list(x, nat, loader, scs, stats, fail_fast=args.fail_fast or args.mutation_run)
    cascades = 40 if (args.quick_only or args.mutation_run) else args.cascade_cases
    if not bad or not (args.fail_fast or args.mutation_run):
        try:
            cascade_cases(x, nat, loader, cascades, stats)
        except (Mismatch, d9.OracleError) as error:
            bad.append(('cascade', str(error)))
            stats['mismatches'] += 1
    if args.mutation_run:
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:600])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    summary['original_loader_calls'] = loader.calls
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-40', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
