#!/usr/bin/env python3
"""RT-34: immutable x86 dispatcher 0x427a50 (arm 0x44 -> 0x4121b8) and record builder 0x411b16 versus the native raw-0x44 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x44 the REAL dispatcher 0x427a50 runs: dependency
trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm at 0x42849f (push 0 / gate / for a true gate
`ecx = 0x619a41; call 0x4121b8(row)`), and then, as ORIGINAL x86 code: 0x4121b8 (flag := 0, writer call, 0x42ba3a, 0x411b16),
the generic completion 0x42ba3a with the dependency reset 0x423d33 for subtype 2, the record builder 0x411b16 (zeroed 0x868-byte
buffer, the CRT itoa 0x5193ca, string copies, word/dword/block copies, the link loop, free of the old row object, the second
malloc, the copy, the row type/subtype/completion/phase stores) and the CRT string work they use. The row pData
(0x5bb5e5 + row * 0x8d) is the constructed 0x44 object (A-44.1 output: 528-byte header + NUL-terminated text) placed in the
oracle heap; rows are built in memory, the scene loader 0x40b34a and the constructor 0x41166e are not run.

Native side: src/session_bindings_a44.c (the executor's handler contract) through tests/action_family_44_runtime_oracle_driver.c
(white box: the driver includes the binding to read its row table), with a scripted write_text host that hands the binding
the same A44TextResult the stand-in of 0x413187 gave the original, and the executor's own disposition mapping. The record
builder a44_build_record is also called directly on the same inputs.

Compared for every visit of every dispatcher pass:
 * which rows entered the arm (observed 0x42849f), which reached 0x4121b8 (observed) against the open-row / gate model;
 * the text writer stand-in was called once per visit with (ECX 0x619a41, object == the row's pData, text == pData + 0x210, 0, 0),
   the flag [0x619a41 + 0x102a] was 0 at the call (0x4121b8 zeroes it BEFORE the call), and the object bytes it saw equal the
   bytes the native binding passed to its write_text host (and the object length equals the original allocation size);
 * the new record bytes (length = the second malloc size 0x868 - (100 - count) * 0x12) against (a) the native binding's row
   record, (b) a44_build_record called directly and (c) an independent Python model of 0x411b16 written from the disassembly;
 * the row table after the visit: type 0xd8, subtype 1, completion 0, phase 0, pData changed to the second malloc result, and
   against the native executor mapping (completed 0, phase 0, dependency reset requested exactly for subtype 2);
 * the malloc sizes and return sites (0x868 temp, then the record) and the free calls in order (old pData, then the temp);
 * that 0x42ba3a ran once per visit and 0x423d33 exactly for subtype 2 (native disposition RESET_DEPENDENCIES);
 * the ORDERED stores to the row table and the 0x619a41 object for the whole pass against the model of the disassembly
   (prologue request dword, flag, 0x42ba3a stores, the 0x411b16 stores) and that no store landed anywhere else in the image,
   the heap outside the temp / record blocks (except the documented overflow), or the old object.

HOOKS (everything else is original code): R = replaced, O = observed (they only read), G = raising guard.
  R 0x413187 text writer (thiscall, ECX 0x619a41, args object, text, 0, 0, `ret 0x10` confirmed at 0x41440b): applies the
    scenario-chosen outputs the native host also receives: dword [0x619a41 + 0x102a] (a nonzero value for "has links"), word
    [0x59fbdb] (link count of table index 0), words [0x59fbe1 + 2 * i] and the 16-byte rects [0x619a41 + 0x102e + 16 * i]; it
    does not render. Returns EAX 0 (0x4121b8 ignores it). The text writer belongs to the RT-32 text writer port.
  R 0x51dc43 malloc (cdecl): the d9 oracle's bump arena in the oracle heap (zero filled by the harness), size and caller recorded
  R 0x51dc6c free (cdecl): the pointer and caller recorded, nothing freed
  O 0x42849f arm entry   O 0x4121b8 entry   O 0x411b16 entry   O 0x42ba3a entry   O 0x423d33 entry (dependency reset)
  O memory writes over the whole image and the heap (classified, never altered)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths (the malloc-failure branch of 0x411b16 and the
    debug logger); reaching one fails the run
 Windows imports (OS boundary, IAT slots patched to stubs) as in the 0xd9 oracle; any unexpected import fails the run. The
 debug flag 0x63a4cd is 0 (no debug lines).

DELIBERATE NATIVE SAFETY DIVERGENCES (the original has no check; the original runs to completion in the oracle, the native
binding refuses the visit before any change and a44_build_record returns an error; counted, never mismatches):
  D1 more than 100 accepted link entries: the original writes past its 0x868-byte buffer (the oracle observes the stores
     outside the buffer) and allocates a larger record from the overflowed data; the native refuses (A44_ERR_BOUNDS)
  D2 link count above 400 (the table row 0x320 bytes): the original reads into the next table rows; native A44_ERR_BOUNDS
  D3 second name (+0xea) with no NUL inside 0x21 bytes: the original strcpy writes past the 0x21-byte field into later
     fields; native A44_ERR_BODY
  D4 object of 0x210 bytes or less: native A44_ERR_BODY (the constructor never produces it)

Not modelled / unverified: the text writer 0x413187 itself; the scene loader 0x40b34a and the constructor 0x41166e (checked
by RT-34's other tests and A-44.1); the second visit of a row (the 0xd8 arm 0x42a354 / 0x48c1c0, the d8 oracle); the original
failure paths (malloc returns 0 -> 0x4c97b4); the heap corruption an overflowing original would suffer in the real process.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_44_runtime_original_oracle.py --mutations --result <receipt.json>
"""
from __future__ import annotations

import argparse
import ctypes as C
import hashlib
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM_ENTRY = 0x42849F
BEGIN = 0x4121B8
WRITER = 0x413187
BUILD = 0x411B16
FINISH = 0x42BA3A
RESET = 0x423D33
FREE = 0x51DC6C
OBJ44 = 0x619A41
FLAG = OBJ44 + 0x102A
RECTS = OBJ44 + 0x102E
COUNTS = 0x59FBDB
VALUES = 0x59FBE1
GATE_CELL = 0x5C3A47
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
TYPE_OFF, SUB_OFF, PDATA_OFF, REQ_OFF = 0x30, 0x31, 0x32, 0x73
EVENTS_VA = d9.EVENTS_VA
EVENTS = 1600
MAX_ROWS = 90
TABLE_N = 460          # entries the oracle writes per scripted table (the native result holds the first 400)
LINK_MAX = 400
NO_LINK = 0x270F
RET_TEMP_MALLOC, RET_REC_MALLOC = 0x411B2C, 0x411E3F
RET_OLD_FREE, RET_TEMP_FREE = 0x411DFF, 0x411F18
RECORD_FIXED, ENTRY_BYTES, ENTRY_MAX = 0x160, 0x12, 100
GATE_LO, GATE_HI = 0x4234C8, 0x424AA8      # shared dependency code (gate 0x423f57, reset 0x423d33, evaluator)

# Executed original code: function spans (SHA-256 of the unmodified image bytes), discovered with --discover-pins over every
# scenario and verified at start-up. Spans end at the next recovered function start. 0x413187 (text writer), 0x51dc43 (malloc)
# and 0x51dc6c (free) are pinned as the replaced routines: their entry is diverted by a hook, their bytes do not run.
PINS_TABLE = (
 (0x411b16, 0x411f24,
  '5afbf0368df06c3056a379c32ae48ab96910e2ca7adcf40164b0949f492bafe9'),
 (0x4121b8, 0x412234,
  '820a18022e9054dbce130344a7b0725e5391f7547e54a726b810dfe22d91125a'),
 (0x413187, 0x414490,
  '50d8a1ab8a296ad627d4842d3915ca391ab3c4d0e6a73591dbd3de9c39b8f6b6'),
 (0x4234c8, 0x4234dd,
  'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
 (0x4237f7, 0x423876,
  'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
 (0x423d33, 0x423da2,
  'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
 (0x423da2, 0x423f57,
  '10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160'),
 (0x423f57, 0x423fbb,
  '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
 (0x42406d, 0x424201,
  '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
 (0x424201, 0x424346,
  'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
 (0x424346, 0x424aa8,
  '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
 (0x424aa8, 0x425b8b,
  'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
 (0x427a50, 0x42acad,
  '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
 (0x42ba3a, 0x42babf,
  '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
 (0x5193ca, 0x5193f7,
  '0b10051bfe983a39084ed57ab72f0bd42db98bbb410280c695c0bf184fb02308'),
 (0x5193f7, 0x519453,
  '54f936226be9f51f7f9ab44240f5dbece70134c0aa2cd2fcbf98441ee7e33527'),
 (0x51dc43, 0x51dc6c,
  '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
 (0x51dc6c, 0x51dc77,
  '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= 0xFFFFFFFF
    return v - (1 << 32) if v & 0x80000000 else v


# ---------------------------------------------------------------------------------------------
# original side
# ---------------------------------------------------------------------------------------------
class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x44 observers."""

    def __init__(self):
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))
        self._check_dispatch_table()
        self.image_end = self.pe.image_base + self.pe.size_of_image
        self._reset_logs()
        self.text_script = {}
        self.pdata_row = {}
        self.blocks = []
        self.mallocs = []
        self.frees = []

    def _check_dispatch_table(self):
        base = self.pe.image_base
        idx = self.pristine[0x42ABA4 - base + (0x44 - 0x0A)]
        target = struct.unpack_from('<I', self.pristine, 0x42A9B4 - base + 4 * idx)[0]
        if target != ARM_ENTRY:
            raise d9.OracleError('raw 0x44 dispatches to %#x, not %#x' % (target, ARM_ENTRY))
        # the arm: push 0; ... call 0x423f57; test; je; mov cx,[row]; push; mov ecx,0x619a41; call 0x4121b8
        arm = self.pristine[ARM_ENTRY - base:0x4284D5 - base]
        rel = struct.unpack_from('<i', arm, len(arm) - 4)[0]
        if arm[-5] != 0xE8 or 0x4284D5 + rel != BEGIN or arm.count(b'\xb9\x41\x9a\x61\x00') != 1 or arm[:2] != b'\x6a\x00':
            raise d9.OracleError('arm 0x42849f does not have the expected shape')

    def _reset_logs(self):
        self.arm_rows, self.visits, self.events, self.stray = [], [], [], []
        self.cur = None
        self.gate_writes = 0
        self.gate_cell_writes = 0
        self.overflow = 0
        self.heap_writes = Counter()

    def _install_hooks(self):
        uc = self.machine
        table = {ARM_ENTRY: self._arm, BEGIN: self._begin, BUILD: self._build_entry, FINISH: self._finish,
                 RESET: self._reset_seen, WRITER: self._writer, FREE: self._free}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._write_image, begin=self.pe.image_base,
                    end=self.pe.image_base + self.pe.size_of_image - 1)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._write_heap, begin=d9.HEAP_BASE, end=d9.HEAP_BASE + d9.HEAP_SIZE - 1)

    # -- observers -------------------------------------------------------------------------------
    def _arm(self, uc, address, size, user):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        self.arm_rows.append(struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0])

    def _begin(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ44:
            raise d9.OracleError('0x4121b8 entered with ECX != 0x619a41')
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        base = ROWS + row * ROW
        self.cur = dict(row=row, writers=[], mallocs=[], frees=[], finishes=[], resets=[], builds=[],
                        pdata_before=u32(uc, base + PDATA_OFF), type_before=self.rd(base + TYPE_OFF, 1)[0],
                        sub_before=self.rd(base + SUB_OFF, 1)[0], flag_before=u32(uc, FLAG))
        self.visits.append(self.cur)

    def _build_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.cur['builds'].append((uc.reg_read(X.UC_X86_REG_ECX), u32(uc, sp + 4), s16(u32(uc, sp + 8)), s16(u32(uc, sp + 12))))

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.cur['finishes'].append(s16(u32(uc, sp + 4)))

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if uc.reg_read(X.UC_X86_REG_ECX) != 0x63786D:
            raise d9.OracleError('dependency reset ECX')
        self.cur['resets'].append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    # -- replaced --------------------------------------------------------------------------------
    def _writer(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        obj, text, a2, a3 = (u32(uc, sp + 4 + 4 * i) for i in range(4))
        row = self.pdata_row.get(obj)
        if row is None or self.cur is None or row != self.cur['row']:
            raise d9.OracleError('text writer called with an object that is not the visited row pData: %#x' % obj)
        script = self.text_script[row]
        length = self.allocs[obj]
        self.cur['writers'].append(dict(ecx=uc.reg_read(X.UC_X86_REG_ECX), obj=obj, text=text, a2=a2, a3=a3,
                                        flag_before=u32(uc, FLAG), object_bytes=self.rd(obj, length)))
        self.wr(FLAG, struct.pack('<I', script['flag'] & 0xFFFFFFFF))
        self.wr(COUNTS, struct.pack('<h', script['count']))
        self.wr(VALUES, struct.pack('<%dh' % TABLE_N, *script['values']))
        self.wr(RECTS, b''.join(script['rects']))
        self._ret(uc, 0x10, 0)

    def _free(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if self.cur is None:
            raise d9.OracleError('free outside a visit')
        self.cur['frees'].append((u32(uc, sp + 4), u32(uc, sp)))
        self._ret(uc, 0)

    def _malloc(self, uc):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        size, ret = u32(uc, sp + 4), u32(uc, sp)
        super()._malloc(uc)
        ptr = uc.reg_read(X.UC_X86_REG_EAX)
        if self.mode == 'step':
            kind = {RET_TEMP_MALLOC: 'temp', RET_REC_MALLOC: 'record'}.get(ret)
            if kind is None or self.cur is None:
                raise d9.OracleError('malloc from an unexpected caller %#x during the pass' % ret)
            self.cur['mallocs'].append((size, ret, ptr))
        else:
            kind = 'dep'
        self.blocks.append([ptr, ptr + size, kind])

    def alloc(self, size, kind):
        start = (self.heap_cursor + 15) & ~15
        end = start + max(size, 1) + 16
        if end > d9.HEAP_BASE + d9.HEAP_SIZE:
            raise d9.OracleError('oracle heap exhausted')
        self.heap_cursor = end
        self.heap_high = max(self.heap_high, end)
        self.allocs[start] = size
        self.blocks.append([start, start + size, kind])
        return start

    # -- memory writes -----------------------------------------------------------------------------
    def _write_image(self, uc, access, address, size, value, user):
        if self.mode != 'step':
            return
        if ROWS <= address < ROWS + MAX_ROWS * ROW:
            row, off = divmod(address - ROWS, ROW)
            if off == TYPE_OFF and size == 1:
                self.events.append(('type', row, value & 0xFF))
            elif off == SUB_OFF and size == 1:
                self.events.append(('subtype', row, value & 0xFF))
            elif off == PDATA_OFF and size == 4:
                self.events.append(('pdata', row, value & 0xFFFFFFFF))
            elif off == COMPLETE_OFF and size == 1:
                self.events.append(('complete', row, value & 0xFF))
            elif off == PHASE_OFF and size == 4:
                self.events.append(('phase', row, value & 0xFFFFFFFF))
            elif off == REQ_OFF and size == 4 and value == 0:   # dispatcher prologue: request dword := 0 (0x5bb626)
                self.events.append(('req', row, 0))
            elif GATE_LO <= uc.reg_read(X.UC_X86_REG_EIP) < GATE_HI and 0x36 <= off < COMPLETE_OFF:
                self.gate_writes += 1   # the dependency evaluator's bookkeeping in the row's dependency root (shared code)
            else:
                self.stray.append(('row', row, off, size, value))
        elif address == FLAG and size == 4:
            self.events.append(('flag', value & 0xFFFFFFFF))
        elif address == GATE_CELL and size == 4:
            self.gate_cell_writes += 1   # 0x423f57 / the dispatcher's own request cell
        elif 0x63786D <= address < 0x63786D + 0x700 and GATE_LO <= uc.reg_read(X.UC_X86_REG_EIP) < GATE_HI:
            self.gate_writes += 1        # the dependency engine object (ECX 0x63786d) written by the shared gate code
        else:
            self.stray.append(('image', address, size, value))

    def _write_heap(self, uc, access, address, size, value, user):
        if self.mode != 'step':
            return
        for lo, hi, kind in reversed(self.blocks):
            if lo <= address < hi:
                if kind in ('temp', 'record'):
                    self.heap_writes[kind] += 1
                elif kind == 'dep' and GATE_LO <= uc.reg_read(X.UC_X86_REG_EIP) < GATE_HI:
                    self.heap_writes['dep'] += 1
                else:
                    self.stray.append(('heap', kind, address, size, value))
                return
        temp = next((b for b in reversed(self.blocks) if b[2] == 'temp'), None)
        if temp is not None and temp[1] <= address < temp[1] + 0x12 * 300 and self.cur is not None:
            self.overflow += size   # the documented unbounded link loop of the original
        else:
            self.stray.append(('heap-unowned', address, size, value))

    # -- scenario plumbing -------------------------------------------------------------------------
    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(d9.HEAP_BASE, bytes(self.heap_high - d9.HEAP_BASE))
        uc.mem_write(d9.BODY_BASE, bytes(0x10000))
        uc.mem_write(d9.TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, d9.FPCW)
        self.heap_cursor = self.heap_high = d9.HEAP_BASE
        self.allocs.clear()
        self.blocks = []
        self.frees = []
        self.mode = 'idle'
        self.expect_fatal = None
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self._reset_logs()
        self.text_script = {}
        self.pdata_row = {}
        self.wr(EVENTS_VA, bytes(4 * EVENTS))

    def set_event(self, index, value):
        self.wr(EVENTS_VA + 4 * index, struct.pack('<i', value))

    def install_rows(self, rows, first=0):
        total = first + len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows for the oracle storage')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            obj = self.alloc(len(spec['obj']), 'object')
            self.wr(obj, spec['obj'])
            self.pdata_row[obj] = i
            self.text_script[i] = spec['text']
            self.wr(base + TYPE_OFF, bytes([0x44, spec['subtype']]) + struct.pack('<I', obj))
            tail = spec['tail']
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, bytes([spec['completed']]))
            self.w32(base + PHASE_OFF, spec['phase'])
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def pdata(self, row):
        return u32(self.machine, ROWS + row * ROW + PDATA_OFF)

    def row_fields(self, row):
        base = ROWS + row * ROW
        return dict(type=self.rd(base + TYPE_OFF, 1)[0], subtype=self.rd(base + SUB_OFF, 1)[0], pdata=self.pdata(row),
                    completed=self.rd(base + COMPLETE_OFF, 1)[0], phase=struct.unpack('<I', self.rd(base + PHASE_OFF, 4))[0])

    def dispatch(self):
        self._reset_logs()
        self.mode = 'step'
        self.mallocs = []
        self.wr(GATE_CELL, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    src = Path(src_dir)
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_44_runtime_oracle_driver.c'),
           *[str(src / s) for s in ('action_family_44_runtime.c', 'action_family_d8_runtime.c', 'action_family_44.c',
                                    'scene_resource.c', 'hiff.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A44_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    if os.environ.get('A44_CFLAGS'):
        cmd[-2:-2] = os.environ['A44_CFLAGS'].split()   # appended: after -Werror, e.g. -Wno-error=type-limits for gcc
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        p, cp = C.c_void_p, C.c_char_p
        lib.a44o_new.restype = p
        lib.a44o_new.argtypes = [C.c_uint]
        lib.a44o_free.argtypes = [p]
        lib.a44o_set_row.argtypes = [p, C.c_uint, cp, C.c_size_t]
        lib.a44o_set_text.argtypes = [p, C.c_int, C.c_int, C.POINTER(C.c_int16), C.c_uint, cp, C.c_uint]
        lib.a44o_writer_calls.argtypes = [p]
        lib.a44o_writer_calls.restype = C.c_uint
        lib.a44o_writer_same_pointer.argtypes = [p]
        lib.a44o_writer_same_pointer.restype = C.c_uint
        lib.a44o_writer_object.argtypes = [p, C.c_void_p, C.c_size_t]
        lib.a44o_writer_object.restype = C.c_size_t
        lib.a44o_visit.argtypes = [p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a44o_visit.restype = C.c_int
        lib.a44o_row_flags.argtypes = [p, C.c_uint]
        lib.a44o_row_bytes.argtypes = [p, C.c_uint, C.c_void_p, C.c_size_t]
        lib.a44o_row_bytes.restype = C.c_size_t
        lib.a44o_failure.argtypes = [p]
        lib.a44o_failure.restype = C.c_char_p
        lib.a44o_build.argtypes = [cp, C.c_size_t, C.c_int, C.c_int, C.POINTER(C.c_int16), C.c_uint, cp, C.c_uint,
                                   C.c_void_p, C.c_size_t, C.POINTER(C.c_size_t)]
        lib.a44o_build.restype = C.c_int
        lib.a44o_record_length.argtypes = [cp, C.c_size_t, C.c_int, C.c_int, C.POINTER(C.c_int16), C.c_uint, cp, C.c_uint]
        lib.a44o_record_length.restype = C.c_size_t
        self.h = None

    def begin(self, rows):
        self.end()
        self.h = self.lib.a44o_new(rows)
        if not self.h:
            raise d9.OracleError('native handle allocation failed')

    def end(self):
        if self.h:
            self.lib.a44o_free(self.h)
            self.h = None

    def close(self):
        self.end()

    def set_row(self, row, obj):
        if self.lib.a44o_set_row(self.h, row, bytes(obj), len(obj)) != 0:
            raise d9.OracleError('native set_row failed')

    @staticmethod
    def _table(text):
        n = min(len(text['values']), LINK_MAX)
        vals = (C.c_int16 * n)(*text['values'][:n])
        rects = b''.join(text['rects'][:n])
        return vals, n, rects

    def set_text(self, text):
        vals, n, rects = self._table(text)
        self.lib.a44o_set_text(self.h, 1 if text['flag'] & 0xFFFFFFFF else 0, text['count'], vals, n, rects, n)

    def visit(self, row, subtype, completed, phase):
        done, reset, new_phase, disp = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a44o_visit(self.h, row, subtype, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disp))
        return dict(status=status, completed=done.value, reset=reset.value, phase=new_phase.value, disposition=disp.value)

    def row_flags(self, row):
        return self.lib.a44o_row_flags(self.h, row)

    def row_bytes(self, row):
        n = self.lib.a44o_row_bytes(self.h, row, None, 0)
        buf = (C.c_uint8 * max(n, 1))()
        self.lib.a44o_row_bytes(self.h, row, buf, n)
        return bytes(buf[:n])

    def writer_object(self):
        n = self.lib.a44o_writer_object(self.h, None, 0)
        buf = (C.c_uint8 * max(n, 1))()
        self.lib.a44o_writer_object(self.h, buf, n)
        return bytes(buf[:n])

    def failure(self):
        return (self.lib.a44o_failure(self.h) or b'').decode()

    def build(self, obj, text):
        vals, n, rects = self._table(text)
        out = (C.c_uint8 * 0x900)()
        length = C.c_size_t()
        flag = 1 if text['flag'] & 0xFFFFFFFF else 0
        status = self.lib.a44o_build(bytes(obj), len(obj), flag, text['count'], vals, n, rects, n, out, 0x900, C.byref(length))
        reported = self.lib.a44o_record_length(bytes(obj), len(obj), flag, text['count'], vals, n, rects, n)
        return status, bytes(out[:length.value]), reported


# ---------------------------------------------------------------------------------------------
# data builders and the independent model of 0x411b16
# ---------------------------------------------------------------------------------------------
def make_text_result(rng, flag=1, count=0, skip=(), values=None, garbage_zero=False):
    """The scripted writer outputs: `count` entries at the head (the indices in `skip` are 0x270f), random elsewhere."""
    pool = (0, 1, -1, 2, 0x7FFF, -0x8000, 0x270E, 0x2710, 100, 1599, rng.randrange(-0x8000, 0x8000))
    n = TABLE_N
    vals, rects = [], []
    for i in range(n):
        if i < max(count, 0):
            v = NO_LINK if i in skip else (values[i] if values and i < len(values) else rng.choice(pool))
        else:
            v = 0 if garbage_zero else rng.choice(pool + (NO_LINK,))
        vals.append(s16(v))
        rects.append(bytes(rng.getrandbits(8) for _ in range(16)))
    return dict(flag=flag, count=count, values=vals, rects=rects)


def accepted_links(text):
    """The original loop of 0x411b16: signed word counter against the signed word count, signed word value != 0x270f."""
    if text['flag'] & 0xFFFFFFFF == 0:
        return []
    out = []
    i = 0
    while i < text['count']:
        if text['values'][i] != NO_LINK:
            out.append((text['values'][i], text['rects'][i]))
        i += 1
    return out


def model_record(obj, links):
    """0x411b16 written from the disassembly (valid inputs: name2 within 0x21 bytes, at most 100 entries)."""
    n = len(links)
    size = 0x868 - (100 - n) * ENTRY_BYTES
    rec = bytearray(0x868)
    name1 = b'USE_LISTPAGE' + str(s16(struct.unpack_from('<H', obj, 2)[0]) - 2).encode()
    rec[0:len(name1)] = name1
    name2 = obj[0xEA:].split(b'\0')[0]
    rec[0x21:0x21 + len(name2)] = name2
    rec[0x42:0x44] = obj[0:2]
    rec[0x50:0x54] = struct.pack('<i', s16(struct.unpack_from('<H', obj, 0xE)[0]))
    rec[0x4C:0x50] = struct.pack('<i', s16(struct.unpack_from('<H', obj, 0xC)[0]))
    rec[0x54:0x64] = obj[0x10B:0x11B]
    rec[0x64:0x74] = obj[0x11B:0x12B]
    rec[0x74:0xB4] = obj[0x12B:0x16B]
    rec[0xB4:0xF4] = obj[0x16B:0x1AB]
    rec[0xF4:0x134] = obj[0x1AB:0x1EB]
    rec[0x134] = obj[0x1EB]
    for k, (v, rect) in enumerate(links):
        at = RECORD_FIXED + k * ENTRY_BYTES
        rec[at:at + 2] = struct.pack('<h', v)
        rec[at + 2:at + 18] = rect
    rec[0x15E:0x160] = struct.pack('<H', n)
    return bytes(rec[:size]), size


def native_rule(obj, text):
    """The native acceptance rules (action_family_44_runtime.h); None when the visit is accepted."""
    if len(obj) <= 0x210:
        return 'D4 object <= 0x210 bytes'
    if b'\0' not in obj[0xEA:0xEA + 0x21]:
        return 'D3 second name unterminated within 0x21 bytes'
    if text['flag'] & 0xFFFFFFFF and text['count'] > LINK_MAX:
        return 'D2 link count above 400'
    if len(accepted_links(text)) > ENTRY_MAX:
        return 'D1 more than 100 accepted links'
    return None


def make_object(rng, text_len=24, word0=None, word2=None, wc=None, we=None, name2=None, fps=None, option=None, junk=0,
                header=None):
    if header is not None:
        h = bytearray(header)
    else:
        h = bytearray(rng.getrandbits(8) for _ in range(528))
    if word0 is not None:
        h[0:2] = struct.pack('<h', s16(word0))
    if word2 is not None:
        h[2:4] = struct.pack('<h', s16(word2))
    if wc is not None:
        h[0xC:0xE] = struct.pack('<h', s16(wc))
    if we is not None:
        h[0xE:0x10] = struct.pack('<h', s16(we))
    if name2 is not None:
        if len(name2) <= 0x20:
            field = bytearray(rng.getrandbits(8) for _ in range(0x21))
            field[0:len(name2)] = name2
            field[len(name2)] = 0
            h[0xEA:0xEA + 0x21] = field
        else:   # longer than the 0x21-byte field: the string and its NUL overwrite the fields behind it
            h[0xEA:0xEA + len(name2)] = name2
            h[0xEA + len(name2)] = 0
    if fps is not None:
        h[0x1EB] = fps
    if option is not None:
        h[0x1EC] = option
    text = (b'Peephole row text. ' * (text_len // 19 + 1))[:text_len]
    h[0x20E:0x210] = struct.pack('<H', len(text) & 0xFFFF)
    tail = bytes(rng.getrandbits(8) for _ in range(junk))
    return bytes(h) + text + b'\0' + tail


NO_LINKS = dict(flag=0, count=0, values=[0] * TABLE_N, rects=[bytes(16)] * TABLE_N)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def Row(obj, subtype=1, text=None, tail=b'', completed=0, phase=0):
    return dict(obj=obj, subtype=subtype, text=text if text is not None else NO_LINKS, tail=tail, completed=completed, phase=phase)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def scenario_list(seed=34, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, group='basic', quick=False, first=0, events=None, mode=3):
        scs.append(dict(id=sid, rows=rows, group=group, quick=quick, first=first, events=events or {}, mode=mode))

    def obj(**kw):
        return make_object(rng, **kw)

    base = make_object(rng, text_len=30, word0=0x1234, word2=5, wc=-3, we=77, name2=b'ABOUT_PAGE', fps=24)
    T = lambda **kw: make_text_result(rng, **kw)

    # corpus: the 27 real headers (private), each with several writer outcomes and its own subtype
    if corpus:
        for k, (st, header) in enumerate(corpus):
            o = make_object(rng, text_len=rng.choice((0, 7, 120, 700)), header=header, junk=rng.choice((0, 0, 5)))
            variants = [('none', NO_LINKS), ('one', T(flag=1, count=1)), ('mixed', T(flag=1, count=9, skip={1, 4, 5})),
                        ('allskip', T(flag=1, count=6, skip=set(range(6))))]
            for vi, (vn, txt) in enumerate(variants):
                S('corpus:%d:%s' % (k, vn), [Row(o, st, txt, phase=rng.choice((0, 0, 1, 2, 7)))], group='corpus',
                  quick=(k in (0, 13, 26) and vi < 2))
            S('corpus:%d:subtype2' % k, [Row(o, 2, T(flag=1, count=3), phase=3)], group='corpus', quick=k == 5)
        S('corpus:all_in_one_pass', [Row(make_object(rng, text_len=rng.choice((0, 9, 90)), header=h), st,
                                          T(flag=rng.choice((0, 1)), count=rng.randrange(0, 12), skip=set(rng.sample(range(12), 3))))
                                      for st, h in corpus], group='corpus')
    # word at +2 -> the record name suffix (itoa of value - 2)
    for w2 in (2, 0, 1, 3, 4, 11, 12, 100, 1000, 9998, 0x7FFF, -1, -2, -3, -100, -0x8000, 0x7FFE, -0x7FFF, 10, 12, 0x1234):
        S('word2:%d' % w2, [Row(obj(word2=w2, name2=b'N'), 1, NO_LINKS)], group='fields',
          quick=w2 in (2, 0, -0x8000, 0x7FFF, 12, 3, 11))
    for w0 in (0, 1, 0xFF, 0x100, 0x7FFF, -0x8000, -1, 0x1234):
        S('word0:%d' % w0, [Row(obj(word0=w0, name2=b'X'), 1, NO_LINKS)], group='fields', quick=w0 in (0x1234, -1))
    for wc, we in ((0, 0), (-1, 1), (1, -1), (0x7FFF, -0x8000), (-0x8000, 0x7FFF), (0x1234, -0x4321), (0xFF, 0x100), (-2, -3)):
        S('wcwe:%d_%d' % (wc, we), [Row(obj(wc=wc, we=we, name2=b''), 1, NO_LINKS)], group='fields', quick=(wc, we) in ((-1, 1), (0x7FFF, -0x8000)))
    for n2 in (b'', b'A', b'USE_AUTOTEXT1', b'0123456789012345678901234567890', b'01234567890123456789012345678901',
               b'x' * 16, b'y' * 31, b'Z' * 32):
        S('name2:%d:%s' % (len(n2), n2[:6].decode()), [Row(obj(name2=n2), 1, NO_LINKS)], group='fields',
          quick=len(n2) in (0, 13, 32))
    for fps in (0, 1, 24, 30, 127, 128, 255):
        S('fps:%d' % fps, [Row(obj(fps=fps, name2=b'f'), 1, NO_LINKS)], group='fields', quick=fps in (0, 255))
    for tl in (0, 1, 18, 19, 20, 300, 4000):
        S('textlen:%d' % tl, [Row(obj(text_len=tl, name2=b'T'), 1, T(flag=1, count=2))], group='fields', quick=tl in (0, 300))
    for opt in (0, 1, 0x80, 255):
        S('option:%d' % opt, [Row(obj(option=opt, name2=b'o', junk=7), 1, NO_LINKS)], group='fields', quick=opt == 1)
    for j in range(500):
        o = obj(text_len=rng.choice((0, 3, 50, 333)), word0=rng.randrange(-0x8000, 0x8000), word2=rng.randrange(-0x8000, 0x8000),
                wc=rng.randrange(-0x8000, 0x8000), we=rng.randrange(-0x8000, 0x8000),
                name2=bytes(rng.choice(b'ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789') for _ in range(rng.choice((0, 1, 7, 20, 31, 32)))),
                fps=rng.randrange(256), option=rng.randrange(256), junk=rng.choice((0, 0, 9)))
        S('random_object:%d' % j, [Row(o, rng.choice((1, 1, 2, 0, 3)), T(flag=rng.choice((0, 1, 1, 2)), count=rng.randrange(0, 20),
                                                                             skip=set(rng.sample(range(20), rng.randrange(0, 8)))),
                                        phase=rng.choice((0, 0, 4, 0xFFFFFFFF)))], group='random_objects', quick=j < 2)
    # the text writer outcomes
    for flag in (0, 1, 2, 0x100, 0x10000, 0x80000000, 0xFFFFFFFF, 0x01010101):
        S('flag:%#x' % flag, [Row(base, 1, T(flag=flag, count=5, skip={2}))], group='links', quick=flag in (0, 0x100, 0x80000000))
    S('flag0_with_stale_table', [Row(base, 1, T(flag=0, count=60))], group='links', quick=True)
    for count in (0, 1, 2, 3, 5, 17, 50, 99, 100):
        S('count:%d' % count, [Row(base, 1, T(flag=1, count=count))], group='links', quick=count in (0, 1, 2, 99, 100))
    for count in (-1, -2, -100, -0x8000):
        S('count_negative:%d' % count, [Row(base, 1, T(flag=1, count=count))], group='links', quick=count in (-1, -0x8000))
    S('skip:all_9999', [Row(base, 1, T(flag=1, count=40, skip=set(range(40))))], group='links', quick=True)
    S('skip:first', [Row(base, 1, T(flag=1, count=8, skip={0}))], group='links')
    S('skip:last', [Row(base, 1, T(flag=1, count=8, skip={7}))], group='links', quick=True)
    S('skip:alternate', [Row(base, 1, T(flag=1, count=30, skip=set(range(0, 30, 2))))], group='links')
    S('skip:130_to_100', [Row(base, 1, T(flag=1, count=130, skip=set(range(0, 130, 4)) | {1, 2, 3, 5, 6, 7, 9, 10}))], group='links')
    S('skip:400_to_100', [Row(base, 1, T(flag=1, count=400, skip=set(range(300))))], group='links', quick=True)
    S('skip:400_to_0', [Row(base, 1, T(flag=1, count=400, skip=set(range(400))))], group='links')
    S('values:near_sentinel', [Row(base, 1, T(flag=1, count=6, values=[0x270E, 0x2710, -0x8D8F, 0x7FFF, -0x8000, -1]))], group='links', quick=True)
    S('values:explicit_9999_mixed', [Row(base, 1, T(flag=1, count=6, values=[9999, 1, 9999, 2, 0x270F, 3], skip=set()))], group='links')
    for j in range(200):
        count = rng.choice((1, 2, 3, 8, 21, 33, 60, 77, 99, 100, 140, 250, 399, 400))
        skip = set(rng.sample(range(count), rng.randrange(0, count + 1) if count <= 100 else count - rng.choice((40, 100, 100))))
        S('links_random:%d' % j, [Row(obj(name2=b'LK', word2=rng.randrange(-30, 30), junk=3), rng.choice((1, 2)),
                                      T(flag=rng.choice((1, 1, 3)), count=count, skip=skip))], group='links', quick=j < 2)
    # subtypes
    for st in (0, 1, 2, 3, 4, 0x80, 255):
        S('subtype:%d' % st, [Row(base, st, T(flag=1, count=4, skip={1}), phase=9)], group='subtype', quick=st in (0, 1, 2, 255))
    # gates, completed rows, row positions, the pass
    S('gate:event_false', [Row(base, 1, T(flag=1, count=3), tail=event_tail(40, 1))], group='gate', events={40: 7}, quick=True)
    S('gate:event_true', [Row(base, 1, T(flag=1, count=3), tail=event_tail(40, 1))], group='gate', events={40: 1}, quick=True)
    S('gate:event_true_subtype2', [Row(base, 2, T(flag=1, count=3), tail=event_tail(41, 5))], group='gate', events={41: 5}, quick=True)
    S('gate:mixed_rows', [Row(base, 1, T(flag=1, count=2), tail=event_tail(42, 1)), Row(obj(name2=b'B', word2=6), 2, T(flag=0)),
                          Row(obj(name2=b'C', word2=7), 1, T(flag=1, count=5, skip={0, 4}), tail=event_tail(43, 2)),
                          Row(obj(name2=b'D', word2=8), 0, T(flag=1, count=1), completed=1)], group='gate',
      events={42: 0, 43: 2}, quick=True)
    S('gate:subtype2_gate_false_no_reset', [Row(base, 2, T(flag=1, count=3), tail=event_tail(44, 1))], group='gate', events={44: 0})
    S('rows:completed_row_skipped', [Row(base, 1, T(flag=1, count=3), completed=1), Row(obj(name2=b'S'), 1, T(flag=1, count=2))],
      group='rows', quick=True)
    S('rows:mode4_runs_nothing', [Row(base, 1, T(flag=1, count=3))], group='rows', mode=4, quick=True)
    S('rows:offset_first_rows', [Row(base, 1, T(flag=1, count=3)), Row(obj(name2=b'O'), 2, T(flag=1, count=1))], group='rows', first=3)
    S('rows:high_index', [Row(base, 1, T(flag=1, count=3))], group='rows', first=87)
    S('rows:five_in_a_pass', [Row(obj(name2=b'P%d' % k, word2=k), rng.choice((1, 2)), T(flag=1, count=rng.randrange(0, 15),
                                                                                         skip=set(rng.sample(range(15), 4))),
                                  phase=k) for k in range(5)], group='rows')
    for n in range(250):
        count = rng.randint(1, 8)
        rows, events = [], {40: rng.randrange(-2, 3), 41: rng.randrange(-2, 3), 42: rng.randrange(-2, 3)}
        for k in range(count):
            tail = event_tail(rng.choice((40, 41, 42)), rng.randrange(-2, 3)) if rng.random() < 0.35 else b''
            rows.append(Row(obj(name2=bytes(rng.choice(b'abcdef') for _ in range(rng.choice((0, 3, 32)))), word2=rng.randrange(-5, 40),
                                junk=rng.choice((0, 4))),
                            rng.choice((0, 1, 1, 2, 3)),
                            T(flag=rng.choice((0, 1, 1)), count=rng.randrange(0, 25), skip=set(rng.sample(range(25), rng.randrange(0, 10)))),
                            tail=tail, completed=1 if rng.random() < 0.15 else 0, phase=rng.choice((0, 0, 1, 5))))
        S('random_pass:%d' % n, rows, group='random_passes', first=rng.choice((0, 0, 2)), events=events, quick=n < 3)
    # deliberate native safety divergences: the original runs, the native refuses before any change
    for acc in (101, 102, 105, 110, 150):
        S('diverge:D1_accepted_%d' % acc, [Row(base, 1, T(flag=1, count=acc))], group='divergence', quick=acc in (101, 110))
    S('diverge:D1_accepted_120_of_300', [Row(base, 1, T(flag=1, count=300, skip=set(range(180))))], group='divergence')
    for count in (401, 410, 450):
        S('diverge:D2_count_%d' % count, [Row(base, 1, T(flag=1, count=count, skip=set(range(count - 3))))], group='divergence',
          quick=count == 401)
    S('diverge:D2_count_450_but_flag0_accepted', [Row(base, 1, T(flag=0, count=450))], group='divergence', quick=True)
    for ln in (33, 34, 40, 80):
        S('diverge:D3_name2_%d' % ln, [Row(make_object(rng, name2=b'q' * ln, word2=9), 1, T(flag=1, count=2))], group='divergence',
          quick=ln == 33)
    S('diverge:D4_object_0x210', [Row(make_object(rng, word2=9, name2=b'sh')[:0x210], 1, T(flag=1, count=2))], group='divergence', quick=True)
    return scs


EXTRACTOR = r'''
#include <stdio.h>
#include <stdlib.h>
#include "scene_resource.h"
int main(int argc, char **argv) {
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb"); unsigned char *bytes; long n; SceneResource *scene; char err[128] = {0};
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END); n = ftell(f); fseek(f, 0, SEEK_SET);
        bytes = malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) { fclose(f); free(bytes); continue; }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            size_t count = scene_resource_action_count(scene);
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != 0x44) continue;
                if (info.typed_body == NULL || info.typed_body_length < 528) continue;
                printf("%u ", (unsigned)info.subtype);
                for (size_t k = 0; k < 528; ++k) printf("%02x", info.typed_body[k]);
                printf("\n");
            }
        }
    }
    return 0;
}
'''


def load_corpus():
    """The 528-byte headers of the decoded scene resources' raw-0x44 rows (production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / 'dump.c'
        src.write_text(EXTRACTOR)
        exe = Path(tmp) / 'corpus'
        cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
        built = subprocess.run([cc, '-std=c11', '-O1', f'-I{PROJECT / "src"}', str(src),
                                *[str(PROJECT / 'src' / s) for s in ('scene_resource.c', 'hiff.c')], '-lm', '-o', str(exe)],
                               capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        st, _, hexbody = line.partition(' ')
        rows.append((int(st), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, passes=0, rows_entered=0, visits=0, visits_compared=0, visits_refused_native=0, rows_gated_off=0,
                state_compares=0, record_bytes_compared=0, ordered_events=0, direct_builds=0, model_checks=0, mallocs=0,
                frees=0, resets_seen=0, finishes_seen=0, writer_calls=0, divergences=Counter(), mismatches=0,
                gate_bookkeeping_writes=0, gate_cell_writes=0, heap_writes=Counter(), overflow_bytes=0,
                by_subtype=Counter(), links_accepted=Counter(), groups={})


def row_gate_open(spec, events):
    t = spec['tail']
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return events.get(rec[1], 0) == rec[2]


def eq(stats, what, a, b):
    stats['state_compares'] += 1
    if a != b:
        raise Mismatch('%s: observed %r expected %r' % (what, a if not isinstance(a, bytes) else a.hex()[:80],
                                                           b if not isinstance(b, bytes) else b.hex()[:80]))


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['passes'], stats['visits'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['visits'] += stats['visits'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows, first = sc['rows'], sc['first']
    total = first + len(rows)
    x.install_rows(rows, first)
    x.w32(FLAG, 0xA5A5A5A5)    # stale nonzero flag: 0x4121b8 must clear it before the writer runs
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.set_event(idx, v)
    initial = {first + k: dict(r) for k, r in enumerate(rows)}
    nat.begin(total)
    for i, r in initial.items():
        nat.set_row(i, r['obj'])
    x.dispatch()
    stats['passes'] += 1
    stats['scenarios'] += 1
    where = sc['id']
    if x.stray:
        raise Mismatch('%s: unexpected stores %s' % (where, x.stray[:4]))
    stats['gate_bookkeeping_writes'] += x.gate_writes
    stats['gate_cell_writes'] += x.gate_cell_writes
    for k, v in x.heap_writes.items():
        stats['heap_writes'][k] += v
    # which rows the model says entered the arm / reached 0x4121b8
    entered = [i for i in range(first, total) if sc['mode'] == 3 and not initial[i]['completed']]
    visited = [i for i in entered if row_gate_open(initial[i], sc['events'])]
    eq(stats, where + ' arm rows', x.arm_rows, entered)
    eq(stats, where + ' rows reaching 0x4121b8', [v['row'] for v in x.visits], visited)
    stats['rows_entered'] += len(entered)
    stats['rows_gated_off'] += len(entered) - len(visited)
    expected_events = []
    for i in entered:
        expected_events.append(('req', i, 0))
        if i in visited:
            expected_events += visit_events(x, [v for v in x.visits if v['row'] == i][0], initial[i])
    eq(stats, where + ' ordered row/object stores', x.events, expected_events)
    stats['ordered_events'] += len(x.events)
    # rows that were not visited are untouched on both sides
    for i, r in initial.items():
        if i in visited:
            continue
        f = x.row_fields(i)
        eq(stats, '%s row %d untouched (original)' % (where, i),
           (f['type'], f['subtype'], f['completed'], f['phase']), (0x44, r['subtype'], r['completed'], r['phase']))
        eq(stats, '%s row %d untouched (native)' % (where, i), nat.row_flags(i), 1)
    for v in x.visits:
        compare_visit(where, x, nat, initial[v['row']], v, stats)
    expected_malloc = sum(len(v['mallocs']) for v in x.visits)
    stats['mallocs'] += expected_malloc


def visit_events(x, v, spec):
    r, st = v['row'], spec['subtype']
    q = v['mallocs'][1][2] if len(v['mallocs']) == 2 else None
    ev = [('flag', 0)]
    if st == 1:
        ev.append(('complete', r, 1))
    elif st == 2:
        ev.append(('complete', r, 0))
    ev.append(('phase', r, 0))
    ev += [('pdata', r, 0), ('pdata', r, q), ('complete', r, 0), ('type', r, 0xD8), ('subtype', r, 1), ('phase', r, 0)]
    return ev


def compare_visit(where, x, nat, spec, v, stats):
    row, st, obj, text = v['row'], spec['subtype'], spec['obj'], spec['text']
    where = '%s row %d' % (where, row)
    stats['visits'] += 1
    stats['by_subtype'][st] += 1
    P = v['pdata_before']
    reason = native_rule(obj, text)
    links = accepted_links(text)
    # --- the original's own calls
    eq(stats, where + ' writer calls', len(v['writers']), 1)
    w = v['writers'][0]
    eq(stats, where + ' writer (ecx, object, text, 0, 0)', (w['ecx'], w['obj'], w['text'], w['a2'], w['a3']), (OBJ44, P, P + 0x210, 0, 0))
    eq(stats, where + ' flag cleared before the writer call', w['flag_before'], 0)
    eq(stats, where + ' object bytes the writer saw', w['object_bytes'], obj)
    eq(stats, where + ' 0x411b16 call (ecx, object, row, index)', v['builds'], [(OBJ44, P, row, 0)])
    eq(stats, where + ' 0x42ba3a rows', v['finishes'], [row])
    eq(stats, where + ' 0x423d33 rows (subtype 2 only)', v['resets'], [row] if st == 2 else [])
    stats['writer_calls'] += 1
    stats['finishes_seen'] += 1
    stats['resets_seen'] += len(v['resets'])
    if len(v['mallocs']) != 2:
        raise Mismatch('%s: %d mallocs' % (where, len(v['mallocs'])))
    (size_t, ret_t, T), (size_r, ret_r, Q) = v['mallocs']
    eq(stats, where + ' malloc sites', (ret_t, ret_r), (RET_TEMP_MALLOC, RET_REC_MALLOC))
    eq(stats, where + ' temp malloc size', size_t, 0x868)
    eq(stats, where + ' record size formula', size_r, 0x868 - (100 - len(links)) * ENTRY_BYTES)
    eq(stats, where + ' frees (old pData, then temp)', v['frees'], [(P, RET_OLD_FREE), (T, RET_TEMP_FREE)])
    stats['frees'] += 2
    f = x.row_fields(row)
    eq(stats, where + ' row type/subtype/completion/phase', (f['type'], f['subtype'], f['completed'], f['phase']), (0xD8, 1, 0, 0))
    eq(stats, where + ' row pData is the record', f['pdata'], Q)
    if Q == P:
        raise Mismatch('%s: pData unchanged' % where)
    stats['links_accepted'][min(len(links), 101)] += 1
    # the old object block is not touched by the pass (free is a no-op in the oracle, so the bytes stay comparable)
    eq(stats, where + ' old object untouched', x.rd(P, len(obj)), obj)
    # --- native
    nat.set_text(text)
    res = nat.visit(row, st, 0, spec['phase'])
    if reason is not None:
        # deliberate safety divergence: the original ran, the native refuses before any change
        eq(stats, where + ' native refuses (' + reason + ')', res['status'], 2)
        eq(stats, where + ' native row unchanged', nat.row_flags(row), 1)
        status, _out, reported = nat.build(obj, text)
        eq(stats, where + ' direct builder refuses', (status != 0, reported), (True, 0))
        stats['divergences'][reason.split()[0]] += 1
        stats['visits_refused_native'] += 1
        if reason.startswith('D1'):
            if x.overflow <= 0:
                raise Mismatch('%s: the original did not write outside its 0x868-byte buffer' % where)
            stats['overflow_bytes'] += x.overflow
        return
    model, msize = model_record(obj, links)
    record = x.rd(Q, size_r)
    eq(stats, where + ' original record vs the python model of 0x411b16', record, model)
    stats['model_checks'] += 1
    eq(stats, where + ' native handler status', res['status'], 0)
    eq(stats, where + ' native disposition', res['disposition'], 2 if st == 2 else 0)
    eq(stats, where + ' native final completion byte (0x411b16 clears it)', res['completed'], 0)
    eq(stats, where + ' native final phase', res['phase'], 0)
    eq(stats, where + ' native dependency reset requested', res['reset'], 1 if st == 2 else 0)
    eq(stats, where + ' native row converted to a record', nat.row_flags(row), 2)
    native_record = nat.row_bytes(row)
    eq(stats, where + ' record length', len(native_record), size_r)
    eq(stats, where + ' record bytes original vs native binding', record, native_record)
    stats['record_bytes_compared'] += len(record)
    eq(stats, where + ' native writer calls', (nat.lib.a44o_writer_calls(nat.h), nat.lib.a44o_writer_same_pointer(nat.h)), (1, 1))
    eq(stats, where + ' object the native writer got', nat.writer_object(), w['object_bytes'])
    status, direct, reported = nat.build(obj, text)
    eq(stats, where + ' direct a44_build_record status', status, 0)
    eq(stats, where + ' direct a44_build_record bytes', direct, record)
    eq(stats, where + ' a44_record_length', reported, size_r)
    stats['direct_builds'] += 1
    stats['visits_compared'] += 1


def run_list(x, nat, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, nat, sc, stats)
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


# ---------------------------------------------------------------------------------------------
# mutants
# ---------------------------------------------------------------------------------------------
R_, B_, H_ = 'action_family_44_runtime.c', 'session_bindings_a44.c', 'action_family_44_runtime.h'
MUTANTS = {
    'itoa bias 3 instead of 2': ('(int)rds16(object + OBJ_WORD2) - 2)', '(int)rds16(object + OBJ_WORD2) - 3)', R_),
    'itoa of the unsigned word': ('(int)rds16(object + OBJ_WORD2) - 2)', '(int)(uint16_t)rds16(object + OBJ_WORD2) - 2)', R_),
    'name prefix wrong': ('memcpy(record, "USE_LISTPAGE", 12u);', 'memcpy(record, "USE_LISTPAGF", 12u);', R_),
    'second name offset': ('#define OBJ_NAME2 0xeau', '#define OBJ_NAME2 0xebu', R_),
    'second name destination': ('memcpy(record + D8_NAME_BYTES, object + OBJ_NAME2, used);', 'memcpy(record + D8_NAME_BYTES + 1, object + OBJ_NAME2, used);', R_),
    'word 0 destination': ('memcpy(record + 0x42, object + OBJ_WORD0, 2u);', 'memcpy(record + 0x43, object + OBJ_WORD0, 2u);', R_),
    'dword words swapped': ('put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_E));\n    put32(record + 0x4c, (uint32_t)(int32_t)rds16(object + OBJ_WORD_C));',
                            'put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_C));\n    put32(record + 0x4c, (uint32_t)(int32_t)rds16(object + OBJ_WORD_E));', R_),
    'word 0xc zero-extended': ('put32(record + 0x4c, (uint32_t)(int32_t)rds16(object + OBJ_WORD_C));', 'put32(record + 0x4c, (uint32_t)(uint16_t)rds16(object + OBJ_WORD_C));', R_),
    'word 0xe zero-extended': ('put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_E));', 'put32(record + 0x50, (uint32_t)(uint16_t)rds16(object + OBJ_WORD_E));', R_),
    'source rect offset': ('#define OBJ_SRC_RECT 0x10bu', '#define OBJ_SRC_RECT 0x10cu', R_),
    'destination rect offset': ('#define OBJ_DST_RECT 0x11bu', '#define OBJ_DST_RECT 0x11cu', R_),
    'button block offset': ('#define OBJ_BUTTONS 0x12bu', '#define OBJ_BUTTONS 0x12au', R_),
    'down block offset': ('#define OBJ_DOWN 0x16bu', '#define OBJ_DOWN 0x16cu', R_),
    'inactive block offset': ('#define OBJ_INACTIVE 0x1abu', '#define OBJ_INACTIVE 0x1aau', R_),
    'fps byte offset': ('#define OBJ_FPS 0x1ebu', '#define OBJ_FPS 0x1ecu', R_),
    'skipped sentinel 0x270e': ('#define A44_NO_LINK 9999', '#define A44_NO_LINK 9998', H_),
    'skipped entries not skipped': ('            if (text->link_value[i] == A44_NO_LINK) continue;\n            entry', '            entry', R_),
    'skipped entries not counted out': ('        if (text->link_value[i] != A44_NO_LINK) ++count;', '        ++count;', R_),
    'entry value narrowed to a byte': ('put16(entry, (uint16_t)text->link_value[i]);', 'put16(entry, (uint8_t)text->link_value[i]);', R_),
    'entry rect offset': ('memcpy(entry + 2, text->link_rect[i], 16u);', 'memcpy(entry + 1, text->link_rect[i], 16u);', R_),
    'entry rect from the written index': ('memcpy(entry + 2, text->link_rect[i], 16u);', 'memcpy(entry + 2, text->link_rect[written], 16u);', R_),
    'link count word offset': ('put16(record + 0x15e, (uint16_t)written);', 'put16(record + 0x15c, (uint16_t)written);', R_),
    'link count is the table count': ('put16(record + 0x15e, (uint16_t)written);', 'put16(record + 0x15e, (uint16_t)text->link_count);', R_),
    'has_links ignored in the count': ('    if (text->has_links == 0u) return 0;\n', '', R_),
    'has_links ignored in the copy': ('if (text->has_links != 0u && text->link_count > 0) {', 'if (text->link_count > 0) {', R_),
    'negative count rejected': ('    if (text->link_count < 0) return 0; /* the original loop does not run */', '    if (text->link_count < 0) return -1;', R_),
    'exactly 100 entries rejected': ('return count > (int)D8_ENTRY_MAX ? -1 : count;', 'return count >= (int)D8_ENTRY_MAX ? -1 : count;', R_),
    'second name check too lax': ('memchr(object + OBJ_NAME2, 0, D8_NAME_BYTES)', 'memchr(object + OBJ_NAME2, 0, D8_NAME_BYTES + 8u)', R_),
    'short object accepted': ('if (object_bytes <= A44_OBJECT_HEADER_BYTES) return A44_ERR_BODY;', 'if (object_bytes < A44_OBJECT_HEADER_BYTES) return A44_ERR_BODY;', R_),
    'link count limit 401': ('if ((size_t)text->link_count > A44_LINK_MAX) return -1;', 'if ((size_t)text->link_count > A44_LINK_MAX + 1u) return -1;', R_),
    'subtype 2 does not reset': ('action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES', 'action->subtype == 3u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES', B_),
    'subtype 1 resets as well': ('action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES', 'action->subtype != 0u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES', B_),
    'row left completed': ('        out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES : SCENE_ACTION_HANDLER_PENDING;',
                           '        out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', B_),
    'phase kept': ('        out->phase = 0u;\n        out->disposition = action->subtype == 2u', '        out->phase = before->phase;\n        out->disposition = action->subtype == 2u', B_),
    'row stays an object': ('        row->is_object = 0u;\n        row->is_record = 1u;', '        row->is_record = 1u;', B_),
    'record length off by one': ('        row->length = record_bytes;', '        row->length = record_bytes - 1u;', B_),
    'writer gets a short object': ('b->host.write_text(USER(b), row->bytes, row->length, text)', 'b->host.write_text(USER(b), row->bytes, row->length - 1u, text)', B_),
    'builder rejection ignored': ('        if (status != A44_OK) {\n            b->failure = "0x44 record build rejected', '        if (status != A44_OK && status != A44_ERR_BOUNDS) {\n            b->failure = "0x44 record build rejected', B_),
}


def mutation_check(args, workdir):
    report = []
    for name, (old, new, filename) in MUTANTS.items():
        source = (args.src / filename).read_text()
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted (%d matches)' % source.count(old)))
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
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-34.oracle-', dir=os.environ.get('A44_WORKDIR') or PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver44.so')
    nat = Native(lib_path)
    x = Oracle()
    corpus = load_corpus()
    scs = scenario_list(corpus=corpus)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only or args.mutation_run:
        scs = [s for s in scs if s['quick']]
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast or args.mutation_run)
    if args.mutation_run:
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    if args.discover_pins:
        import bisect
        import glob
        starts = set()
        for f in glob.glob(str(ROOT / 'work/analysis/decompiled/batch-*.json')):
            for it in json.load(open(f))['normalized_result']['items']:
                starts.add(int(it['address'], 16))
        starts = sorted(starts)
        funcs = {}
        for a, sz in blocks:
            i = bisect.bisect_right(starts, a) - 1
            funcs[starts[i]] = starts[i + 1]
        out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
        print('PINS_TABLE = (' + ','.join('(%#x,%#x,%r)' % t for t in out) + ',)')
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:500])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:140])
    if args.result:
        src_hashes = {n: sha((args.src / n).read_bytes()) for n in
                      ('action_family_44_runtime.c', 'action_family_44_runtime.h', 'session_bindings_a44.c', 'session_bindings_a44.h',
                       'action_family_d8_runtime.c', 'action_family_d8_runtime.h', 'action_family_44.c', 'action_family_44.h')}
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(
            dict(slice='RT-34', oracle='action_family_44_runtime_original_oracle', original_sha256=d9.EXE_HASH, stats=summary,
                 mutations=mutations, mutants_caught=(sum(1 for m in mutations if m['detected']) if mutations else None),
                 mutants_total=(len(mutations) if mutations else None), code_windows=code, source_sha256=src_hashes,
                 oracle_sha256=sha(Path(__file__).read_bytes()), driver_sha256=sha((PROJECT / 'tests/action_family_44_runtime_oracle_driver.c').read_bytes()),
                 native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=round(time.monotonic() - started, 1),
                 hooks=dict(replaced=['0x413187 text writer (scripted)', '0x51dc43 malloc (bump arena)', '0x51dc6c free (recorded)'],
                            observed=['0x42849f', '0x4121b8', '0x411b16', '0x42ba3a', '0x423d33', 'memory writes'],
                            guards=[hex(a) for a in d9.GUARDS])), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
