#!/usr/bin/env python3
"""RT-57: immutable x86 dispatcher 0x427a50 (arms 0x4290c0 raw 0x6d and 0x429d34 raw 0x9a with the handler 0x4336ad, plus the wrappers
0x4eb96e / 0x4e7d04 / 0x4e303b) versus the native runtime modules action_family_6d_runtime.c / action_family_9a_runtime.c and the
session bindings src/session_bindings_a6d_a9a.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw types 0x6d and 0x9a (and 0x67 as the plain "other loaded row")
the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arms
themselves, the real 0x9a handler 0x4336ad (phase machine, stop loops, scene-change cells, event flag store, completion byte) and the
real popup wrappers 0x4eb96e (mode 4), 0x4e7d04 (mode 3) and 0x4e303b (overlay) with their direct cell stores (0x583204, 0x5bb22a,
word [0x57975c + 0x6b2]). The rows sit in memory with the real slot layout (stride 0x8d at 0x5bb5b3: type 0x5bb5e3, body pointer +2,
dependency +6, completion byte 0x5bb625, request dword 0x5bb626, phase dword 0x5bb632, word 0x5bb636, unloaded dword 0x5bb638, loaded
dword 0x5bb63c, high-water count word 0x5c39e3).

Native side: src/session_bindings_a6d_a9a.c (the executor's handler contract) over src/action_family_{6d,9a}_runtime.c, driven by
tests/action_family_6d_9a_runtime_oracle_driver.c with the executor's disposition mapping. The driver holds the cells, a 4096-entry
event flag table (window [0, 4096)) and a log of every host call in the order a host can observe it, and implements the HOST side of
the contracts (stop_channel, unload_scene_sound, teardown, event flag query / store, transition, load / store of cells), as the app
would. The native handler runs only for a true gate (executor semantics): the gate itself is the original code on the original side
and an event-flag model on the native side.

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entries 0x4290c0 / 0x429d34 / 0x428692 (the row is the signed word at [ebp-0x11c]), the post-gate points 0x4290e7 / 0x429d58 /
    0x4286b5, the wrappers 0x4eb96e / 0x4e7d04 / 0x4e303b (ECX is recorded: the teardown kind is the wrapper that ran), 0x42ba3a and
    0x423d33 (must not run), every store to the process data region (from 0x4f0000 up to 0x680000)
  R 0x4fc878 sound channel stop (records the low 16 bits of its argument, ECX must be 0x5c3a67); 0x4fc808 (the unload variant, only
    the second argument of 0x4336ad reaches it, which the raw 0x9a arm never sets) is a guard
  R 0x4fb018 scene sound unload (recorded with a snapshot of the seven cells of the 0x6d path at that moment)
  R the wrapper callees 0x4edb97, 0x4eba54, 0x4e7bf3, 0x4e2faa, 0x4d36ed, 0x4c2dfb, 0x4e1d34, 0x4c92c5, 0x4fba69 (recorded with ECX
    and, for 0x4c2dfb, its argument; the last three sit below the first six and are never reached once those are replaced)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle. The debug flag 0x63a4cd is 0 (the native modules model the flag as 0).

NOT COMPARED, host behaviour: the conditional image releases inside the wrappers (0x4c2dfb on the cells 0x5d03a3, 0x5d03a7, 0x5d039f,
only when a cell is nonzero) and every effect the replaced cleanups (0x4edb97 ...) have on the popup objects, and everything the
sound stop 0x4fc878 / unload 0x4fb018 do to the sound channels. The oracle sets those cells to nonzero in some scenarios so that the
release path runs and counts the calls (`releases_observed`), but the releases are not part of the compared sequence.

Compared after every dispatcher call (tick):
 * the exact observed event sequence of the original (arm entries, true-gate visits, every sound stop with its channel, every write
   to a modelled cell, every popup wrapper entry with its ECX and its replaced cleanups in order, the 0x4fb018 call with a snapshot of
   the cells, every event flag dword store, every phase-dword store and completion-byte store) against the sequence the documented
   order predicts;
 * the native host-call log (query of the flag index, stops in order, flag store, store_world, transition request, teardown kind,
   unload, store_world) against the sequence the kernels document, for every visit, plus the request handed to the transition host;
 * every modelled process cell (15 of them) original against native against an independent model, bit for bit; the whole event flag
   table (4096 dwords) original against native; the native bindings' last-world copy; every original byte of the 0x57975c..+0x6700
   object that is not the word +0x6b2 is unchanged; every write outside the modelled cells (apart from the gate's pinned scratch) fails
   the run;
 * every byte of every row (0x8d bytes, except the dependency record the gate owns) against the model: entered rows have request 0;
   a 0x9a row at phase 0 stores phase 2, at phase 2 stores completion 1 (its phase is kept), at any other phase nothing; a 0x6d row
   is completed directly with its phase untouched; nothing else changes (garbage in the unlisted bytes proves it);
 * the dispatcher loop's own conditions (0x427a8e: engine mode [0x583999] must be 3 at every row, so after a 0x9a row with a scene
   change (mode 4) or a 0x6d row (mode 0) no further row runs in that pass); neither the generic completion 0x42ba3a nor the dependency
   reset 0x423d33 ever runs; the executor's mapping of the native disposition (PENDING / DIRECT_COMPLETED + phase) against the
   original row bytes.

Native-only refusals (listed, checked natively, not comparable with the original, which has no such checks): an event flag index outside
the host window (checked before any effect), missing required hosts, host failures, malformed raw bodies, a popup teardown selected
with no teardown host (see refusal_checks()). One contract observation (not a mismatch): the unload host of the 0x6d visit runs while
the host's own cells still hold their pre-visit values (the kernel commits them afterwards through store_world), whereas the original
has already stored the wrapper cells; the oracle compares the original snapshot with the model and the native cells after the tick.

Not modelled / unverified: the scene loader 0x40b34a that builds the rows (the oracle builds them in memory), the six corpus rows'
real dependency records (replayed without them and behind a stand-in event record, the gate is shared verified code), the effects of
the replaced calls (host behaviour), the debug-flag-set paths, flag indexes outside [0, 4096) on the original side.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_6d_9a_runtime_original_oracle.py --quick-only
  python3 action_family_6d_9a_runtime_original_oracle.py --workers 4 --result ../../../work/rt57/RT-57.oracle-result.json
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ROWS, ROW = d9.ROWS, d9.ROW
TYPE_OFF, BODY_OFF = 0x30, 0x32
COMPLETE_OFF, REQ_OFF, PHASE_OFF, WORD_OFF, UNLOADED_OFF, LOADED_OFF = 0x72, 0x73, 0x7F, 0x83, 0x85, 0x89
DEP_LO, DEP_HI = 0x36, 0x72            # the dependency record (the gate owns it)
GAP_OFFS = (0x77, 0x7F)                # unlisted bytes between the request dword and the phase dword
MAX_ROWS = 40
BODY_STRIDE = 0x40
WINDOW = 4096                          # event flag window of the native host

ARM = {0x6D: 0x4290C0, 0x9A: 0x429D34, 0x67: 0x428692}
VISIT = {0x6D: 0x4290E7, 0x9A: 0x429D58, 0x67: 0x4286B5}
STOP, UNLOAD_VARIANT, STOP_THIS = 0x4FC878, 0x4FC808, 0x5C3A67
SOUND, SOUND_THIS = 0x4FB018, 0x5C3A67
WRAPPERS = {0x4EB96E: ('mode4', 0x57FD34), 0x4E7D04: ('mode3', 0x571442), 0x4E303B: ('overlay', 0x57975C)}
# the replaced callees: address -> pop (bytes of arguments the callee removes)
CLEANUPS = {0x4EDB97: 0, 0x4EBA54: 0, 0x4E7BF3: 0, 0x4E2FAA: 0, 0x4D36ED: 0, 0x4C2DFB: 4, 0x4E1D34: 0, 0x4C92C5: 4, 0x4FBA69: 4}
THIS_CLEANUPS = (0x4EDB97, 0x4EBA54, 0x4E7BF3, 0x4E2FAA)
KIND_CLEANUP = {'mode4': 0x4EBA54, 'mode3': 0x4E7BF3, 'overlay': 0x4E2FAA}
KIND_CODE = {'mode4': 1, 'mode3': 2, 'overlay': 3}           # Action6DTeardown
RELEASE_CELLS = {'mode4': (0x5D03A3, 0x5D03A7), 'mode3': (), 'overlay': (0x5D039F,)}
RELEASE_THIS = 0x5CF659
OBJ, OBJ_BYTES = 0x57975C, 0x6700
DATA_BASE, DATA_LIMIT = 0x4F0000, 0x680000
EVENTS_VA = d9.EVENTS_VA

# modelled cells: name -> (address, size)
CELLS = {
    '5bb57b': (0x5BB57B, 4), '5bb599': (0x5BB599, 2), '5bb595': (0x5BB595, 2), '5c39ff': (0x5C39FF, 2), '5bb59b': (0x5BB59B, 4),
    '5bb59f': (0x5BB59F, 4), '5bb5a3': (0x5BB5A3, 4), '5bb1ca': (0x5BB1CA, 4), '583999': (0x583999, 4),
    '583204': (0x583204, 4), '5bb22a': (0x5BB22A, 4), 'o6b2': (OBJ + 0x6B2, 2), '583981': (0x583981, 4), '5839a1': (0x5839A1, 4),
    '5bb1e2': (0x5BB1E2, 4),
}
SIZES = {n: s for n, (_, s) in CELLS.items()}
CELL_BY_VA = {va: (n, s) for n, (va, s) in CELLS.items()}
CELLS_9A = ('5bb57b', '5bb599', '5bb595', '5c39ff', '5bb59b', '5bb59f', '5bb5a3', '5bb1ca', '583999')
CELLS_6D = ('583204', '5bb22a', 'o6b2', '583981', '5839a1', '583999', '5bb1e2')
SOUND_CELLS = CELLS_6D
# writes outside the modelled cells the gate and the dispatcher make (discovered, then pinned)
EXPECTED_OTHER_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x4336ad, 0x4338bb, '834d4b813977f7497ee821a55ef37857c29bed86bc34deddfce3b5a62327054b'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c92c5, 0x4c9340, '367561d23a3a01a88e45d0ea6887498ac8f95e1d4d48d34f78c7b05b70aaacca'),
    (0x4d36ed, 0x4d3705, '9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd'),
    (0x4e1d34, 0x4e1db3, '7bb9d53606a405dd79d685d1ba7212d5adb6e8aa2b903c2964553680f55515c9'),
    (0x4e2faa, 0x4e303b, '65e93f6e03767a18a48f7e257f70ad80ddb8827db487107eeb097c5a855a06e5'),
    (0x4e303b, 0x4e3093, 'a7de591ad691159fcfed801c68abda65b4bcda49eb94976b502251550933babb'),
    (0x4e7bf3, 0x4e7c72, '5fbce2fd569dcb623fc311abd29a4ff9f7de9b68b5829e3e4b53854f3b39ce67'),
    (0x4e7d04, 0x4e7d2e, 'f7cc1012916b165c716ecb86ae7d8f47938e8ed4668e7077833a054a4ae2d405'),
    (0x4eb96e, 0x4eb9c8, 'fe96ae0e13e254c9da42f2d1457d19a597235dc0651c012e7f33b17782da77cf'),
    (0x4eba54, 0x4ebb5b, 'd1a3a6b57e8553dbdcf5fc3cd91bf52352750187945ef72184c3fd3d6b43e609'),
    (0x4edb97, 0x4edcb1, '0f9dd052b1bed5f56fff0501bbd7af2165f92d1d845367b6e593144eedfb542a'),
    (0x4fb018, 0x4fb071, '648bb1b932269ec9dfd757b94323c7c19cfec9dbf87b37f952f3ef8aa07ffc62'),
    (0x4fba69, 0x4fba86, '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
    (0x4fc808, 0x4fc878, '8a3072a589d1e623c814e0665396ac69dc9eb0041c5c2bcc00423a69bd99f0f8'),
    (0x4fc878, 0x4fc909, 'bfb3f1ddaa0d13aabe1898c6694f9e48c98cf9930c2b3e76d4297d96417b8cb9'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)
HOOK_ENTRIES = (STOP, UNLOAD_VARIANT, SOUND, *WRAPPERS, *CLEANUPS)


def mask(size):
    return (1 << (8 * size)) - 1


def sgn(v, size):
    v &= mask(size)
    return v - (1 << (8 * size)) if v >> (8 * size - 1) else v


def s16(v):
    return sgn(v, 2)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x6d / 0x9a observers."""

    def __init__(self):
        super().__init__()
        self.pins = []
        self.recording = False
        self.clear_logs()
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))

    def clear_logs(self):
        self.events = []
        self.finish_entries, self.resets = [], []
        self.other_writes = Counter()
        self.releases = 0

    def row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {STOP: self._stop, UNLOAD_VARIANT: self._raise, SOUND: self._sound, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a, (kind, _this) in WRAPPERS.items():
            table[a] = self._mk_wrap(kind)
        for a, pop in CLEANUPS.items():
            table[a] = self._mk_cleanup(a, pop)
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_BASE, end=DATA_LIMIT)

    def _mk_event(self, kind, typ):
        def run(uc, address, size, user):
            self.events.append((kind, typ, self.row_at_arm(uc)))
        return run

    def _mk_wrap(self, kind):
        def run(uc, address, size, user):
            self.events.append(('wrap', kind, uc.reg_read(X.UC_X86_REG_ECX)))
        return run

    def _mk_cleanup(self, address, pop):
        def run(uc, address_, size, user):
            sp = uc.reg_read(X.UC_X86_REG_ESP)
            ecx = uc.reg_read(X.UC_X86_REG_ECX)
            if address == 0x4C2DFB:                      # image release of a cell: the host's, counted, not compared
                self.releases += 1
                self.events.append(('release', u32(uc, sp + 4), ecx))
            elif address in THIS_CLEANUPS:
                self.events.append(('cleanup', address, ecx))
            else:
                self.events.append(('cleanup', address, None))
            self._ret(uc, pop, 0)
        return run

    def _stop(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != STOP_THIS:
            raise d9.OracleError('channel stop called with this=%#x' % uc.reg_read(X.UC_X86_REG_ECX))
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('stop', u32(uc, sp + 4) & 0xFFFF))
        self._ret(uc, 4, 0)

    def _sound(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != SOUND_THIS:
            raise d9.OracleError('sound unload called with this=%#x' % uc.reg_read(X.UC_X86_REG_ECX))
        snap = tuple(self.cell(n) for n in SOUND_CELLS)
        self.events.append(('sound', snap))
        self._ret(uc, 0, 0)

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _on_write(self, uc, access, address, size, value, user):
        if not self.recording:
            return
        value &= mask(size)
        hit = CELL_BY_VA.get(address)
        if hit is not None and hit[1] == size:
            self.events.append(('c', hit[0], value))
            return
        if EVENTS_VA <= address < EVENTS_VA + 4 * WINDOW:
            off = address - EVENTS_VA
            if size == 4 and off % 4 == 0:
                self.events.append(('flag', off // 4, value))
            else:
                self.other_writes['flags+%#x/%d' % (off, size)] += 1
            return
        if OBJ <= address < OBJ + OBJ_BYTES:
            self.other_writes['obj+%#x/%d' % (address - OBJ, size)] += 1
            return
        if ROWS <= address < ROWS + MAX_ROWS * ROW:
            row, off = divmod(address - ROWS, ROW)
            if off == COMPLETE_OFF and size == 1:
                self.events.append(('comp', row, value))
            elif off == PHASE_OFF and size == 4:
                self.events.append(('phase', row, value))
            return                          # every other row byte is checked by the final image comparison
        self.other_writes['%#x/%d' % (address, size)] += 1

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
        self.frees = []
        self.mode = 'idle'
        self.expect_fatal = None
        self.recording = False
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_logs()

    def cell(self, name):
        va, size = CELLS[name]
        return int.from_bytes(self.rd(va, size), 'little')

    def set_cell(self, name, value):
        va, size = CELLS[name]
        self.wr(va, (value & mask(size)).to_bytes(size, 'little'))

    def flag_table(self):
        return list(struct.unpack('<%dI' % WINDOW, self.rd(EVENTS_VA, 4 * WINDOW)))

    def set_flag_table(self, table):
        self.wr(EVENTS_VA, struct.pack('<%dI' % WINDOW, *[v & 0xFFFFFFFF for v in table]))

    def install_rows(self, rows):
        total = len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows for the oracle storage')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i, r in enumerate(rows):
            base = ROWS + i * ROW
            body_at = d9.BODY_BASE + BODY_STRIDE * i
            if r['body'] is not None:
                self.wr(body_at, r['body'])
            self.wr(base + TYPE_OFF, bytes([r['type'], r['subtype']]) + struct.pack('<I', body_at if r['body'] is not None else 0))
            tail = r['tail'] or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base, bytes((i * 37 + k * 11 + 0x5A) & 0xFF for k in range(TYPE_OFF)))          # description garbage
            self.wr(base + GAP_OFFS[0], bytes((i * 29 + k * 7 + 0x33) & 0xFF for k in range(GAP_OFFS[1] - GAP_OFFS[0])))
            self.write_row_fields(i, r)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def write_row_fields(self, i, r):
        base = ROWS + i * ROW
        self.wr(base + TYPE_OFF, bytes([r['type']]))
        self.wr(base + COMPLETE_OFF, bytes([r['completed']]))
        self.w32(base + REQ_OFF, r['request'])
        self.w32(base + PHASE_OFF, r['phase'])
        self.wr(base + WORD_OFF, struct.pack('<H', r['word']))
        self.w32(base + UNLOADED_OFF, r['unloaded'])
        self.w32(base + LOADED_OFF, r['loaded'])
        self.w32(base + BODY_OFF, d9.BODY_BASE + BODY_STRIDE * i if r['body'] is not None else 0)

    def dispatch(self):
        self.clear_logs()
        self.mode = 'step'
        self.recording = True
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'
            self.recording = False


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
SOURCES = ('session_bindings_a6d_a9a.c', 'action_family_6d_runtime.c', 'action_family_9a_runtime.c', 'action_family_6d.c',
           'action_family_9a.c')

# driver constants (see the driver)
F_LOAD9A, F_STORE_FLAG, F_TRANSITION, F_UNLOAD, F_TEARDOWN, F_LOAD6D = 1, 2, 4, 8, 16, 32
O_TEARDOWN, O_STORE6D, O_TRANSITION, O_STOP, O_FLAGQ, O_FLAGSTORE, O_UNLOAD, O_LOAD6D, O_LOAD9A, O_STORE9A = (
    1, 2, 4, 8, 16, 32, 64, 128, 256, 512)
L_STOP, L_FLAG, L_STORE9A, L_TRANSITION, L_TEARDOWN, L_UNLOAD, L_STORE6D, L_FLAGQ = 1, 2, 3, 4, 5, 6, 7, 8
HANDLER_OK, HANDLER_UNSUPPORTED, HANDLER_ERROR = 0, 1, 2
PENDING, DIRECT_COMPLETED = 0, 3


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('cc') or shutil.which('gcc') or shutil.which('clang')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_6d_9a_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in SOURCES], '-lm', '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('A6D_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P = C.c_void_p
        lib.a6o_new.restype = P
        lib.a6o_free.argtypes = [P]
        lib.a6o_reset.argtypes = [P]
        lib.a6o_clear_logs.argtypes = [P]
        lib.a6o_name.restype = C.c_char_p
        lib.a6o_name.argtypes = [C.c_int]
        lib.a6o_get.restype = C.c_int64
        lib.a6o_get.argtypes = [P, C.c_int]
        lib.a6o_set.argtypes = [P, C.c_int, C.c_int64]
        lib.a6o_set_fail.argtypes = [P, C.c_int, C.c_int]
        lib.a6o_set_omit.argtypes = [P, C.c_int]
        lib.a6o_flags_get.argtypes = [P, C.POINTER(C.c_int32)]
        lib.a6o_flags_load.argtypes = [P, C.POINTER(C.c_int32)]
        lib.a6o_log_count.restype = C.c_int
        lib.a6o_log_count.argtypes = [P]
        lib.a6o_log_get.argtypes = [P, C.c_int, C.POINTER(C.c_int64)]
        lib.a6o_req.argtypes = [P, C.POINTER(C.c_int64)]
        lib.a6o_last_world.argtypes = [P, C.c_int, C.POINTER(C.c_int64)]
        lib.a6o_visits.restype = C.c_int64
        lib.a6o_visits.argtypes = [P, C.c_int]
        lib.a6o_visit.restype = C.c_int
        lib.a6o_visit.argtypes = [P, C.c_int, C.c_int, C.c_int, C.c_int, C.c_char_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                  C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a6o_failure.restype = C.c_char_p
        lib.a6o_failure.argtypes = [P, C.c_int]
        self.h = lib.a6o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')
        if lib.a6o_flag_window() != WINDOW:
            raise d9.OracleError('driver flag window differs from the oracle')
        self.index = {lib.a6o_name(i).decode(): i for i in range(lib.a6o_nv())}
        if set(self.index) != set(SIZES):
            raise d9.OracleError('driver cell table differs from the oracle: %r' % sorted(set(self.index) ^ set(SIZES)))

    def close(self):
        self.lib.a6o_free(self.h)

    def reset(self):
        self.lib.a6o_reset(self.h)

    def clear_logs(self):
        self.lib.a6o_clear_logs(self.h)

    def get(self, name):
        return self.lib.a6o_get(self.h, self.index[name]) & mask(SIZES[name])

    def set(self, name, value):
        self.lib.a6o_set(self.h, self.index[name], sgn(value, SIZES[name]))

    def flags(self):
        buf = (C.c_int32 * WINDOW)()
        self.lib.a6o_flags_get(self.h, buf)
        return [v & 0xFFFFFFFF for v in buf]

    def load_flags(self, table):
        buf = (C.c_int32 * WINDOW)(*[sgn(v, 4) for v in table])
        self.lib.a6o_flags_load(self.h, buf)

    def log_count(self):
        return self.lib.a6o_log_count(self.h)

    def log(self, start=0):
        out = []
        buf = (C.c_int64 * 3)()
        for i in range(start, self.log_count()):
            self.lib.a6o_log_get(self.h, i, buf)
            out.append((buf[0], buf[1], buf[2]))
        return out

    def request(self):
        buf = (C.c_int64 * 7)()
        self.lib.a6o_req(self.h, buf)
        return list(buf)

    def last_world(self, family):
        buf = (C.c_int64 * len(self.index))()
        self.lib.a6o_last_world(self.h, family, buf)
        return {n: buf[i] for n, i in self.index.items() if buf[i] != -(1 << 40)}

    def visits(self, family):
        return self.lib.a6o_visits(self.h, family)

    def set_fail(self, mask_, stop_n=0):
        self.lib.a6o_set_fail(self.h, mask_, stop_n)

    def set_omit(self, mask_):
        self.lib.a6o_set_omit(self.h, mask_)

    def failure(self, binding):
        return self.lib.a6o_failure(self.h, binding).decode()

    def visit(self, binding, typ, row, subtype, raw, completed, phase):
        done, new_phase, disposition = C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a6o_visit(self.h, binding, typ, row, subtype, bytes(raw), len(raw), completed, phase, C.byref(done),
                                    C.byref(new_phase), C.byref(disposition))
        return status, done.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
POOL32 = [0, 1, 2, 3, 4, 5, 6, 0x270F, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xDEADBEEF, 0x12345678]
POOL16 = [0, 1, 2, 5, 6, 0x270F, 0x7FFF, 0x8000, 0xFFFF, 0x1234]
SOUNDS = [0x14, 0x15] + list(range(14)) + [14, 15, 0x13, 0x16, 0x7FFF, 0xFFFF, 0x8000, 0x8014, 0x0114, 0xFFFE, 0x7FFE, 0x8015]
SCENES = [9999, 9998, 10000, 0, 1, 0xFFFF, 0x7FFF, 0x8000, 0xA70F, 0x1234, 0xD8F1, 0xFFFE, 0x0F27, 0x270F | 0x4000]
W25S = [1, 0, 2, 0x100, 0x101, 0x8001, 0xFFFF, 0x7F01, 0x1234, 0xFF01, 0x0300]
FLAG_INDEXES = [0xFFFF, 0, 1, 2, 7, 255, 256, 1000, 1001, 1003, 1007, 2047, 2048, 4094, 4095]
GATE_FLAGS = tuple(range(1000, 1008))
POPUP_5BB22A = [0, 1, 0xFFFFFFFF, 0x100, 0x80000000, 0x10000, 2]
POPUP_583204 = [0, 3, 4, 5, 0xFFFFFFFF, 2, 0x10003, 0x10004, 0x300, 0x80000003, 6, 0x400, 0x1000000]


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def body9a(sound=0, scene=9999, w2=0, w3=0, w4=0, d10=0, d14=0, d18=0, flag=0xFFFF, fval=0, w25=0):
    """The 27-byte raw 0x9a body: words 0..4 at 0..9, dwords at 10, 14, 18, the flag index word at 22, the flag value byte at 24, the
    word at 25..26 (compared with 1) last."""
    b = bytearray(27)
    struct.pack_into('<HHHHH', b, 0, sound & 0xFFFF, scene & 0xFFFF, w2 & 0xFFFF, w3 & 0xFFFF, w4 & 0xFFFF)
    struct.pack_into('<III', b, 10, d10 & 0xFFFFFFFF, d14 & 0xFFFFFFFF, d18 & 0xFFFFFFFF)
    struct.pack_into('<H', b, 22, flag & 0xFFFF)
    b[24] = fval & 0xFF
    struct.pack_into('<H', b, 25, w25 & 0xFFFF)
    return bytes(b)


def default_body(typ):
    return {0x6D: b'\x00', 0x9A: body9a(), 0x67: b'\1'}.get(typ, b'\0')


def R(typ, subtype=1, body=None, tail=b'', **kw):
    """One row: loaded dword 0 / unloaded 0 / open unless given. body=False means a null body pointer."""
    d = dict(type=typ, subtype=subtype, body=body, tail=tail, loaded=0x1357, unloaded=0, completed=0, phase=0, request=0x55AA55AA,
             word=0x1234)
    d.update(kw)
    if d['body'] is None:
        d['body'] = default_body(typ)
    elif d['body'] is False:
        d['body'] = None
    return d


def rand_cells(rng, names):
    out = {}
    for n in names:
        if n == '583999':
            continue
        s = SIZES[n]
        out[n] = rng.choice(POOL32 if s == 4 else POOL16) if rng.random() < 0.45 else rng.getrandbits(8 * s)
    return out


def rand_9a_body(rng, **kw):
    d = dict(sound=rng.choice(SOUNDS), scene=rng.choice(SCENES), w2=rng.choice(POOL16 + [rng.getrandbits(16)]),
             w3=rng.choice(POOL16 + [rng.getrandbits(16)]), w4=rng.choice(POOL16 + [rng.getrandbits(16)]),
             d10=rng.choice(POOL32 + [rng.getrandbits(32)]), d14=rng.choice(POOL32 + [rng.getrandbits(32)]),
             d18=rng.choice(POOL32 + [rng.getrandbits(32)]), flag=rng.choice(FLAG_INDEXES), fval=rng.choice([0, 1, 2, 0x7F, 0x80, 0xFF, rng.getrandbits(8)]),
             w25=rng.choice(W25S + [rng.getrandbits(16)]))
    d.update(kw)
    return body9a(**d)


def scenario_list(seed=0x6D9A):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', cells=None, events=None, mode=3, quick=False, ftab=False, rel=None, garbage=True):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, cells=cells or {}, events=events or {}, mode=mode,
                        quick=quick, ftab=rng.getrandbits(32) if ftab else None, rel=rel or {}, garbage=garbage))

    def AGAIN(*extra):
        return [('tick',), ('set', {'583999': 3}), ('rearm',), *extra, ('tick',)]

    c9 = lambda: rand_cells(rng, CELLS_9A)       # noqa: E731
    c6 = lambda: rand_cells(rng, CELLS_6D)       # noqa: E731
    rel_off = {0x5D03A3: 0, 0x5D03A7: 0, 0x5D039F: 0}
    rel_on = {0x5D03A3: 0x1111, 0x5D03A7: 0x2222, 0x5D039F: 0x3333}

    # ---- raw 0x9a: the sound word (stop loops), with and without a scene change
    for k, sound in enumerate(SOUNDS):
        S('a9a:sound_%04x_noscene' % sound, [R(0x9A, 1, body9a(sound=sound, scene=9999))], [('setphase', 0, 2), ('tick',)], group='a9a_sound',
          cells=c9(), quick=sound in (0x14, 0x15, 0, 5, 13, 14, 0x7FFF, 0xFFFF, 0x8000))
        S('a9a:sound_%04x_scene' % sound, [R(0x9A, 1, rand_9a_body(rng, sound=sound, scene=rng.choice(SCENES[1:])))], [('setphase', 0, 2), ('tick',)],
          group='a9a_sound', cells=c9(), quick=sound in (0x14, 0x15, 7, 0xFFFE))
    # ---- raw 0x9a: the scene word and the cells it carries
    for k, scene in enumerate(SCENES):
        for w25 in W25S[:6]:
            body = rand_9a_body(rng, sound=rng.choice([0, 3, 14, 0x14, 0x15]), scene=scene, w25=w25, flag=rng.choice([0xFFFF, 5, 1003]))
            S('a9a:scene_%04x_w25_%04x' % (scene, w25), [R(0x9A, 1, body, phase=2), R(0x67)], AGAIN(), group='a9a_scene', cells=c9(), ftab=True,
              quick=(k + W25S.index(w25)) % 5 == 0)
    for k in range(12):
        S('a9a:cells%d' % k, [R(0x9A, 1, rand_9a_body(rng, scene=rng.choice(SCENES[1:]), flag=0xFFFF), phase=2)], AGAIN(), group='a9a_scene',
          cells=c9(), quick=k < 3)
    # the 15-bit and low-byte lookalikes of 9999 and of the start-flag word
    for scene in (0x270F, 0x270F ^ 0x8000, 0x270F ^ 0x0100, 0x270F ^ 0x0001, 0x270F ^ 0x1000, 0x270F + 0x10000 - 1 & 0xFFFF):
        S('a9a:lookalike_%04x' % scene, [R(0x9A, 1, body9a(scene=scene, d10=0x01020304, d14=0x05060708, d18=0x090A0B0C, w2=0x1111, w3=0x2222, w4=0x3333,
                                                           w25=0), phase=2)],
          group='a9a_scene', cells=c9(), quick=scene in (0x270F, 0xA70F))
    # ---- raw 0x9a: the event flag word and byte
    for part in range(8):
        rows = []
        for j in range(32):
            val = part * 32 + j
            idx = rng.choice(FLAG_INDEXES) if j % 3 else (val * 17) % WINDOW
            rows.append(R(0x9A, 1, body9a(sound=rng.choice([0, 1, 14, 0x14]), scene=9999, flag=idx, fval=val), phase=2))
        S('a9a:flag_values_%d' % part, rows, [('tick',)], group='a9a_flag', cells=c9(), ftab=True, quick=part == 0)
    for idx in FLAG_INDEXES:
        for fval in (0, 1, 0xFF, 0x80):
            S('a9a:flag_%04x_val_%02x' % (idx, fval), [R(0x9A, 1, rand_9a_body(rng, scene=rng.choice([9999, 5]), flag=idx, fval=fval), phase=2)],
              [('tick',)], group='a9a_flag', cells=c9(), ftab=True, quick=idx in (0xFFFF, 0, 4095) and fval in (0, 0xFF))
    # the flag a later row's gate reads is written by an earlier row of the same pass
    for fval in (0, 1, 2, 7):
        tail = event_tail(1003, 1)
        S('a9a:flag_feeds_gate_%d' % fval, [R(0x9A, 1, body9a(scene=9999, flag=1003, fval=fval), phase=2), R(0x9A, 1, body9a(sound=2, scene=9999), tail, phase=2),
                                           R(0x67, 1, b'\1', tail)],
          [('tick',), ('events', {1003: 0}), ('set', {'583999': 3}), ('rearm',), ('setphase', 0, 2), ('setphase', 1, 2), ('tick',)], group='a9a_flag',
          events={1003: 9}, cells=c9(), quick=fval in (0, 1))
    # ---- raw 0x9a: phases
    for phase in (0, 2, 1, 3, 5, 4, 0xFFFFFFFF, 0x80000000, 6, 0x100, 0x10002):
        for scene in (9999, 7):
            S('a9a:phase_%x_scene_%d' % (phase, scene), [R(0x9A, 1, rand_9a_body(rng, scene=scene, flag=rng.choice([0xFFFF, 12])), phase=phase)],
              [('tick',), ('tick',), ('tick',)], group='a9a_phase', cells=c9(), ftab=True, quick=phase in (0, 2, 1, 5) and scene == 7)
    S('a9a:phase0_to_2_to_done', [R(0x9A, 1, rand_9a_body(rng, scene=9999, flag=3, fval=9), phase=0), R(0x67)],
      [('tick',), ('tick',), ('tick',), ('rearm',), ('tick',), ('tick',)], group='a9a_phase', cells=c9(), quick=True)
    # ---- raw 0x9a: gate
    for phase in (0, 2):
        for scene in (9999, 55):
            S('gate:9a_event_false_p%d_s%d' % (phase, scene), [R(0x9A, 1, rand_9a_body(rng, scene=scene, flag=9), event_tail(40, 1), phase=phase), R(0x67)],
              [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('set', {'583999': 3}), ('rearm',), ('tick',)], group='gate', events={40: 7},
              cells=c9(), quick=phase == 2 and scene == 55)
    S('gate:9a_offset_rows', [R(0x67, completed=1), R(0x67, completed=1, loaded=1), R(0x9A, 1, rand_9a_body(rng, scene=9999), phase=2), R(0x67)],
      AGAIN(), group='gate', cells=c9(), quick=True)
    S('gate:9a_mode_not_3', [R(0x9A, 1, rand_9a_body(rng, scene=9999), phase=2), R(0x67)], [('tick',), ('set', {'583999': 3}), ('tick',)], group='gate',
      mode=4, cells=c9(), quick=True)
    for sub in (0, 1, 2, 3, 4, 255):
        S('subtype:9a_%d' % sub, [R(0x9A, sub, rand_9a_body(rng, scene=rng.choice([9999, 3])), phase=2), R(0x67, sub)], AGAIN(), group='subtype', cells=c9(),
          quick=sub in (0, 255))
        S('subtype:6d_%d' % sub, [R(0x6D, sub, bytes([rng.getrandbits(8)])), R(0x67, sub)], AGAIN(), group='subtype', cells=c6(), quick=sub in (0, 255))
    S('a9a:two_rows_second_after_transition', [R(0x9A, 1, body9a(sound=1, scene=77, w2=1, w3=2, w4=3, d10=4, d14=5, d18=6), phase=2),
                                               R(0x9A, 1, body9a(sound=2, scene=9999, flag=8, fval=8), phase=2), R(0x67)], AGAIN(),
      group='a9a_scene', cells=c9(), quick=True)
    S('a9a:two_rows_both_no_scene', [R(0x9A, 1, body9a(sound=0x15, scene=9999, flag=8, fval=8), phase=2),
                                     R(0x9A, 1, body9a(sound=0x14, scene=9999, flag=9, fval=9), phase=0), R(0x67)], AGAIN(),
      group='a9a_scene', cells=c9(), quick=True)
    S('a9a:start_flag_from_plain_row', [R(0x67), R(0x9A, 1, body9a(scene=9999), phase=2), R(0x67)], AGAIN(), group='a9a_scene', cells=c9(), quick=True)
    S('a9a:null_body_neighbour', [R(0x67, body=False), R(0x9A, 1, rand_9a_body(rng, scene=9999), phase=2), R(0x67, body=False)], AGAIN(),
      group='a9a_scene', cells=c9())

    # ---- raw 0x6d: every selector combination
    for a, v5 in enumerate(POPUP_5BB22A):
        for b, v3 in enumerate(POPUP_583204):
            cells = dict(c6(), **{'5bb22a': v5, '583204': v3})
            rel = rel_on if (a + b) % 2 == 0 else rel_off
            S('a6d:5bb22a_%x_583204_%x' % (v5, v3), [R(0x6D, 1, bytes([rng.getrandbits(8)]), phase=rng.choice([0, 0, 2, 7])), R(0x67)], AGAIN(), group='a6d_select',
              cells=cells, rel=rel, quick=(a + b) % 6 == 0 or (v5 in (0, 1) and v3 in (0, 3, 4, 5)) or (v5 == 0 and v3 in (0x10003, 0x10004)))
    for k in range(10):
        S('a6d:cells%d' % k, [R(0x6D, 1, bytes([k * 25]))], AGAIN(), group='a6d_cells', cells=dict(c6(), **{'583204': rng.choice([3, 4]), '5bb22a': rng.choice([0, 1])}),
          rel=rel_on if k % 2 else rel_off, quick=k < 2)
    for v in (0, 9999, 0x270E, 0xFFFF, 0x8000, 0x1234):
        for kind in ((1, 0), (0, 4), (0, 3), (0, 0)):
            S('a6d:o6b2_%04x_%d_%d' % (v, *kind), [R(0x6D)], [('tick',)], group='a6d_cells', cells=dict(c6(), **{'o6b2': v, '5bb22a': kind[0], '583204': kind[1]}),
              quick=v in (0, 0x1234) and kind[0] == 1)
    S('a6d:tail_cells_special', [R(0x6D)], [('tick',)], group='a6d_cells', quick=True,
      cells={'583981': 6, '5839a1': 0, '5bb1e2': 0, '583204': 4, '5bb22a': 0})
    S('a6d:tail_cells_ff', [R(0x6D)], [('tick',)], group='a6d_cells', quick=True,
      cells={'583981': 0xFFFFFFFF, '5839a1': 0xFFFFFFFF, '5bb1e2': 0xFFFFFFFF, '583204': 3, '5bb22a': 0})
    for phase in (0, 2, 1, 5, 0xFFFFFFFF):
        S('a6d:phase_%x' % phase, [R(0x6D, 1, b'\x00', phase=phase), R(0x67)], AGAIN(), group='a6d_cells', cells=dict(c6(), **{'583204': 3}), quick=phase in (0, 2))
    S('gate:6d_event_false', [R(0x6D, 1, b'\x00', event_tail(40, 1)), R(0x67)], [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('set', {'583999': 3}),
                                                                                  ('rearm',), ('tick',)], group='gate', events={40: 7},
      cells=dict(c6(), **{'583204': 4, '5bb22a': 1}), quick=True)
    S('gate:6d_offset_rows', [R(0x67, completed=1), R(0x67), R(0x6D), R(0x67), R(0x67)], AGAIN(), group='gate', cells=dict(c6(), **{'583204': 3}), quick=True)
    S('gate:6d_mode_not_3', [R(0x6D), R(0x67)], [('tick',), ('set', {'583999': 3}), ('tick',)], group='gate', mode=0, cells=dict(c6(), **{'583204': 4}), quick=True)
    S('a6d:rows_after_are_not_run_in_the_pass', [R(0x67), R(0x6D), R(0x67), R(0x9A, 1, body9a(sound=1, scene=9999), phase=2)], AGAIN(), group='a6d_cells',
      cells={**c6(), **c9(), '583204': 4}, quick=True)
    S('a6d:then_9a_next_tick', [R(0x6D), R(0x9A, 1, rand_9a_body(rng, scene=33, flag=0xFFFF), phase=2)],
      [('tick',), ('set', {'583999': 3}), ('rearm',), ('setphase', 1, 2), ('tick',)], group='a6d_cells', cells={**c6(), **c9(), '5bb22a': 1}, quick=True)
    S('a6d:9a_then_6d', [R(0x9A, 1, body9a(sound=3, scene=9999, flag=4, fval=4), phase=2), R(0x6D), R(0x67)], AGAIN(), group='a6d_cells',
      cells={**c6(), **c9(), '583204': 3}, quick=True)
    S('a6d:9a_phase0_then_6d', [R(0x9A, 1, body9a(sound=3, scene=40, flag=4, fval=4), phase=0), R(0x6D), R(0x67)], AGAIN(), group='a6d_cells',
      cells={**c6(), **c9(), '583204': 4, '5bb22a': 0})

    # ---- mixed random scenarios
    for n in range(160):
        nrows = rng.randint(1, 8)
        rows = []
        for k in range(nrows):
            kind = rng.random()
            if kind < 0.16:     # a row the pass skips: unloaded or completed
                styp = rng.choice((0, 0x67, 0x6D, 0x9A, 0x99))
                skip = R(styp, rng.randrange(256), rng.choice((None, False)) if styp in (0, 0x67, 0x99) else None,
                         unloaded=rng.choice((0, 1, 1)), completed=rng.choice((0, 1)), loaded=rng.choice((0, 1, 7, 0xFFFFFFFF)),
                         phase=rng.randrange(0, 12), word=rng.getrandbits(16), request=rng.getrandbits(32))
                if not skip['unloaded']:
                    skip['completed'] = 1
                rows.append(skip)
                continue
            typ = rng.choice((0x9A, 0x9A, 0x9A, 0x6D, 0x6D, 0x67, 0x67))
            if typ == 0x9A:
                scene = rng.choice((9999, 9999, 9999, rng.choice(SCENES)))
                body = rand_9a_body(rng, scene=scene, flag=rng.choice(FLAG_INDEXES + [1000 + rng.randrange(8)]))
            elif typ == 0x6D:
                body = bytes([rng.getrandbits(8)])
            else:
                body = bytes([rng.getrandbits(8)])
            tail = event_tail(1000 + rng.randrange(8), rng.randrange(0, 3)) if rng.random() < 0.25 else b''
            nobody = typ == 0x67 and rng.random() < 0.15
            rows.append(R(typ, rng.choice((0, 1, 1, 1, 2, 3, 4, 255)), False if nobody else body, tail,
                          loaded=rng.choice((0, 0, 1, 1, 1, 5, 0x80000000)), completed=1 if rng.random() < 0.1 else 0,
                          phase=rng.choice((0, 2, 2, 2, 0, 1, 3, 5, 0xFFFFFFFF)), word=rng.getrandbits(16), request=rng.getrandbits(32)))
        for _ in range(rng.choice((0, 0, 1, 2))):       # a trailing run of unloaded rows
            rows.append(R(0, 0, None, b'', unloaded=1, loaded=rng.choice((0, 0, 1)), request=rng.getrandbits(32), word=rng.getrandbits(16)))
        acts = []
        for _ in range(rng.randint(2, 4)):
            acts.append(('tick',))
            if rng.random() < 0.7:
                acts.append(('set', {'583999': 3}))
            if rng.random() < 0.6:
                acts.append(('rearm',))
            if rng.random() < 0.4:
                acts.append(('set', rand_cells(rng, rng.sample([c for c in CELLS if c != '583999'], 6))))
            if rng.random() < 0.4:
                acts.append(('events', {1000 + k: rng.randrange(0, 3) for k in range(8)}))
            if rng.random() < 0.3:
                acts.append(('setphase', rng.randrange(len(rows)), rng.choice((0, 2, 2, 1))))
        S('random:%d' % n, rows, acts, group='random', cells={**c9(), **c6(), '583204': rng.choice(POPUP_583204 + [3, 4, 3, 4]), '5bb22a': rng.choice(POPUP_5BB22A + [0] * 6)},
          events={1000 + k: rng.randrange(0, 3) for k in range(8)}, ftab=rng.random() < 0.5, rel=rng.choice((rel_on, rel_off)), quick=n < 12,
          mode=rng.choice((3, 3, 3, 3, 3, 0, 1, 2, 4, 5)))
    return scs


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, compared_fields=0, rows_entered=Counter(), rows_visited=Counter(), rows_gated=Counter(),
                stop_calls=0, stop_loops=Counter(), flags_stored=0, transitions=0, no_scene_works=0, pending_phase0=0, other_phase_noops=0,
                teardown_kinds=Counter(), no_teardown_visits=0, unloads=0, releases_observed=0, passes_stopped_by_mode=0,
                native_refusal_checks=0, mismatches=0, written_events=0, groups={})


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], sum(stats['rows_visited'].values()))
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += sum(stats['rows_visited'].values()) - before[1]
        g['seconds'] = round(g['seconds'] + time.monotonic() - t0, 2)


class State:
    def __init__(self, sc):
        self.sc = sc
        self.rows = [dict(r) for r in sc['rows']]
        self.mc = {}
        self.ftab = []


def sync_native(x, nat, st):
    """Copy the original's cells and flag table into the native handle and the model."""
    for n in CELLS:
        v = x.cell(n)
        nat.set(n, v)
        st.mc[n] = v
    st.ftab = x.flag_table()
    nat.load_flags(st.ftab)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    nat.reset()
    st = State(sc)
    x.install_rows(st.rows)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    if sc['ftab'] is not None:
        frng = random.Random(sc['ftab'])
        x.set_flag_table([frng.choice((0, 0, 1, 2, 3, 0xFF, 0x100, 0xFFFFFFFF, frng.getrandbits(32))) for _ in range(WINDOW)])
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    for n, v in sc['cells'].items():
        x.set_cell(n, v)
    for va, v in sc['rel'].items():
        x.w32(va, v)
    if sc['garbage']:                                         # fill the popup object with a pattern: any stray write is visible
        grng = random.Random(0x6D9A + len(sc['id']))
        pat = bytearray(grng.getrandbits(8) for _ in range(OBJ_BYTES))
        keep = x.rd(OBJ + 0x6B2, 2)
        x.wr(OBJ, bytes(pat))
        x.wr(OBJ + 0x6B2, keep)
    sync_native(x, nat, st)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, st, stats)
        elif kind == 'rearm':
            for i, r in enumerate(st.rows):
                if r['type'] in ARM and not r['unloaded']:     # rows of other types stay completed (no arm is modelled for them)
                    r['completed'] = 0
                    r['phase'] = 0
                    x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                    x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'setphase':
            st.rows[act[1]]['phase'] = act[2]
            x.w32(ROWS + act[1] * ROW + PHASE_OFF, act[2])
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                st.ftab[idx] = v & 0xFFFFFFFF
            nat.load_flags(st.ftab)
        elif kind == 'set':
            for n, v in act[1].items():
                x.set_cell(n, v)
                nat.set(n, v)
                st.mc[n] = v & mask(SIZES[n])
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def gate_open(spec, ftab):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return sgn(ftab[rec[1]], 4) == rec[2]


def select_kind(mc):
    if mc['5bb22a'] != 0:
        return 'overlay'
    if mc['583204'] == 4:
        return 'mode4'
    if mc['583204'] == 3:
        return 'mode3'
    return None


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    rows = st.rows
    pre_rows = [x.rd(ROWS + i * ROW, ROW) for i in range(len(rows))]
    pre_obj = x.rd(OBJ, OBJ_BYTES)
    mc = st.mc
    for n in CELLS:                                            # the model, the original and the native side start the tick in step
        check(stats, where, 'cell %s at tick start (original vs model)' % n, x.cell(n), mc[n])
        check(stats, where, 'cell %s at tick start (native vs model)' % n, nat.get(n), mc[n])
    nat.clear_logs()
    x.dispatch()
    ftab = list(st.ftab)
    expected, entered, visited = [], [], []
    count = len(rows)
    i = 0
    while True:
        if i >= count or mc['583999'] != 3:
            break
        r = rows[i]
        if r['completed'] or r['unloaded']:
            i += 1
            continue
        r['request'] = 0
        typ = r['type']
        entered.append((typ, i))
        expected.append(('entry', typ, i))
        if gate_open(r, ftab):
            visited.append((typ, i))
            expected.append(('visit', typ, i))
            if typ == 0x67:
                r['completed'] = 1
                mc['5bb1ca'] = 1
                nat.set('5bb1ca', 1)
                expected += [('c', '5bb1ca', 1), ('comp', i, 1)]
            elif typ == 0x9A:
                visit_9a(where, nat, st, r, i, ftab, expected, stats)
            elif typ == 0x6D:
                visit_6d(where, nat, st, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
            stats['rows_visited'][hex(typ)] += 1
        else:
            stats['rows_gated'][hex(typ)] += 1
        stats['rows_entered'][hex(typ)] += 1
        i += 1
    if i < count and mc['583999'] != 3:
        stats['passes_stopped_by_mode'] += 1
    st.ftab = ftab
    # ---- the observed event sequence of the original is the documented order, entry for entry (image releases are the host's)
    observed = [e for e in x.events if e[0] != 'release']
    stats['releases_observed'] += x.releases
    check(stats, where, 'event sequence (arm entries, visits, stops, cell stores in order, wrappers and cleanups, sound unload, flag, phase and completion stores)',
          observed, expected)
    stats['written_events'] += len(x.events)
    check(stats, where, 'arm entries', [e[1:] for e in x.events if e[0] == 'entry'], entered)
    check(stats, where, 'visits (true gates)', [e[1:] for e in x.events if e[0] == 'visit'], visited)
    check(stats, where, 'generic completion 0x42ba3a / dependency reset 0x423d33', (x.finish_entries, x.resets), ([], []))
    unexpected = {k: v for k, v in x.other_writes.items() if k not in EXPECTED_OTHER_WRITES}
    if unexpected:
        raise Mismatch('%s: the original wrote outside the modelled cells: %r' % (where, dict(list(unexpected.items())[:8])))
    # ---- cells, original against model against native
    for n in CELLS:
        check(stats, where, 'cell %s (original vs model)' % n, x.cell(n), mc[n])
        check(stats, where, 'cell %s (native vs original)' % n, nat.get(n), x.cell(n))
    check(stats, where, 'event flag table (original vs model)', x.flag_table(), ftab)
    check(stats, where, 'event flag table (native vs original)', nat.flags(), x.flag_table())
    post_obj = x.rd(OBJ, OBJ_BYTES)
    allowed = set(range(0x6B2, 0x6B4))
    touched = [k for k in range(OBJ_BYTES) if pre_obj[k] != post_obj[k] and k not in allowed]
    check(stats, where, 'object bytes changed outside the word +0x6b2', touched, [])
    # ---- every byte of every row
    for i, r in enumerate(rows):
        exp_img = bytearray(pre_rows[i])
        exp_img[TYPE_OFF] = r['type']
        struct.pack_into('<I', exp_img, BODY_OFF, d9.BODY_BASE + BODY_STRIDE * i if r['body'] is not None else 0)
        exp_img[COMPLETE_OFF] = r['completed']
        struct.pack_into('<I', exp_img, REQ_OFF, r['request'])
        struct.pack_into('<I', exp_img, PHASE_OFF, r['phase'])
        struct.pack_into('<H', exp_img, WORD_OFF, r['word'])
        struct.pack_into('<I', exp_img, UNLOADED_OFF, r['unloaded'])
        struct.pack_into('<I', exp_img, LOADED_OFF, r['loaded'])
        post = x.rd(ROWS + i * ROW, ROW)
        bad = [k for k in range(ROW) if not (DEP_LO <= k < DEP_HI) and post[k] != exp_img[k]]
        if bad:
            raise Mismatch('%s: row %d bytes differ at offsets %s: original %s model %s' % (
                where, i, [hex(k) for k in bad[:6]], [hex(post[k]) for k in bad[:6]], [hex(exp_img[k]) for k in bad[:6]]))
        stats['compared_fields'] += 1


def native_result(where, nat, binding, r, i, body, expect_disp, expect_phase, expect_completed, stats, phase_before):
    n0 = nat.log_count()
    v0 = nat.visits(binding)
    status, done, phase, disp = nat.visit(binding, binding, i, r['subtype'], body + r['tail'], r['completed'], phase_before)
    if status != 0:
        raise Mismatch('%s: native %#x handler status %d for row %d (%s)' % (where, binding, status, i, nat.failure(binding)))
    check(stats, where, 'native %#x visit counter and failure text after an accepted visit' % binding, (nat.visits(binding) - v0, nat.failure(binding)), (1, 'none'))
    check(stats, where, 'native %#x disposition of row %d' % (binding, i), disp, expect_disp)
    check(stats, where, 'native %#x completed / phase of row %d (executor mapping)' % (binding, i), (done, phase), (expect_completed, expect_phase))
    return nat.log(n0)


def visit_9a(where, nat, st, r, i, ftab, expected, stats):
    mc = st.mc
    body = r['body']
    sound, scene, w2, w3, w4 = struct.unpack_from('<hhHHH', body, 0)
    d10, d14, d18 = struct.unpack_from('<III', body, 10)
    flag = struct.unpack_from('<h', body, 22)[0]
    fval = body[24]
    w25 = struct.unpack_from('<h', body, 25)[0]
    phase = r['phase']
    if phase == 0:
        r['phase'] = 2
        expected.append(('phase', i, 2))
        log = native_result(where, nat, 0x9A, r, i, body, PENDING, 2, r['completed'], stats, phase)
        check(stats, where, 'native host calls of a 0x9a phase 0 -> 2 visit', log, [])
        stats['pending_phase0'] += 1
        return
    if phase != 2:
        log = native_result(where, nat, 0x9A, r, i, body, PENDING, phase, r['completed'], stats, phase)
        check(stats, where, 'native host calls of a 0x9a visit at phase %#x' % phase, log, [])
        stats['other_phase_noops'] += 1
        return
    # ---- the work (state 2)
    if sound in (0x14, 0x15):
        channels = list(range(0 if sound == 0x14 else 1, 14))
        stats['stop_loops'][hex(sound)] += 1
    else:
        channels = [sound & 0xFFFF]
        stats['stop_loops']['single'] += 1
    stats['stop_calls'] += len(channels)
    ev = [('stop', ch) for ch in channels]
    pre = dict(mc)
    if scene != 9999:
        s32 = sgn(scene, 4) & mask(4)
        start = 0 if w25 == 1 else 1
        ev += [('c', '5bb57b', s32), ('c', '5bb599', w2), ('c', '5bb595', w3), ('c', '5c39ff', w4), ('c', '5bb59b', d10), ('c', '5bb59f', d14),
               ('c', '5bb5a3', d18), ('c', '5bb1ca', start), ('c', '583999', 4)]
        mc.update({'5bb57b': s32, '5bb599': w2, '5bb595': w3, '5c39ff': w4, '5bb59b': d10, '5bb59f': d14, '5bb5a3': d18, '5bb1ca': start, '583999': 4})
        stats['transitions'] += 1
    else:
        stats['no_scene_works'] += 1
    nat_log = []
    if flag != -1:
        ev.append(('flag', flag, fval))
        ftab[flag] = fval
        stats['flags_stored'] += 1
        nat_log.append((L_FLAGQ, flag, 0))
    nat_log += [(L_STOP, ch, 0) for ch in channels]
    if flag != -1:
        nat_log.append((L_FLAG, flag, fval))
    nat_log.append((L_STORE9A, 0, 0))
    if scene != 9999:
        nat_log.append((L_TRANSITION, 0, 0))
    ev.append(('comp', i, 1))
    expected += ev
    log = native_result(where, nat, 0x9A, r, i, body, DIRECT_COMPLETED, phase, 1, stats, phase)
    r['completed'] = 1
    check(stats, where, 'native host calls of the 0x9a work (flag query, stops, flag store, store_world, transition)', log, nat_log)
    if scene != 9999:
        req = nat.request()
        exp = [sgn(scene, 2), sgn(w2, 2), sgn(w3, 2), sgn(w4, 2), sgn(d10, 4), sgn(d14, 4), sgn(d18, 4)]
        check(stats, where, 'scene-change request (target, 3 words, 3 dwords)', req, exp)
    last = nat.last_world(0x9A)
    check(stats, where, 'binding last world of the 0x9a visit', {n: v & mask(SIZES[n]) for n, v in last.items()}, {n: mc[n] for n in CELLS_9A})
    del pre


def visit_6d(where, nat, st, r, i, expected, stats):
    mc = st.mc
    body = r['body']
    kind = select_kind(mc)
    ev = []
    nat_log = []
    if kind is not None:
        this = WRAPPERS_BY_KIND[kind]
        ev += [('wrap', kind, this), ('cleanup', 0x4EDB97, this), ('cleanup', KIND_CLEANUP[kind], this), ('c', '583204', 0), ('cleanup', 0x4D36ED, None)]
        mc['583204'] = 0
        if kind == 'overlay':
            ev += [('c', '5bb22a', 0), ('c', 'o6b2', 9999)]
            mc['5bb22a'] = 0
            mc['o6b2'] = 9999
        nat_log.append((L_TEARDOWN, KIND_CODE[kind], 0))
        stats['teardown_kinds'][kind] += 1
    else:
        stats['no_teardown_visits'] += 1
    ev.append(('sound', tuple(mc[n] for n in SOUND_CELLS)))
    nat_log += [(L_UNLOAD, 0, 0), (L_STORE6D, 0, 0)]
    stats['unloads'] += 1
    mc.update({'583981': 6, '5839a1': 0, '583999': 0, '5bb1e2': 0})
    ev += [('c', '583981', 6), ('c', '5839a1', 0), ('c', '583999', 0), ('c', '5bb1e2', 0), ('comp', i, 1)]
    expected += ev
    log = native_result(where, nat, 0x6D, r, i, body, DIRECT_COMPLETED, r['phase'], 1, stats, r['phase'])
    r['completed'] = 1
    check(stats, where, 'native host calls of the 0x6d visit (teardown kind, unload, store_world)', log, nat_log)
    last = nat.last_world(0x6D)
    check(stats, where, 'binding last world of the 0x6d visit', {n: v & mask(SIZES[n]) for n, v in last.items()}, {n: mc[n] for n in CELLS_6D})


WRAPPERS_BY_KIND = {kind: this for kind, this in WRAPPERS.values()}


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
# native-only refusals
# ---------------------------------------------------------------------------------------------
def refusal_checks(nat, stats):
    """Host refusals and malformed bodies (native only): a refused visit is a non-OK status and changes neither the cells, the flag table
    nor the row result; the host-call log shows exactly which effects had already run (documented per case)."""
    rng = random.Random(0x6D9A57)

    def fresh(fill=True):
        nat.reset()
        if fill:
            for n in CELLS:
                nat.set(n, rng.getrandbits(32))
            nat.load_flags([rng.getrandbits(32) for _ in range(WINDOW)])
        return {n: nat.get(n) for n in CELLS}, nat.flags()

    def snap():
        return {n: nat.get(n) for n in CELLS}, nat.flags()

    def run(binding, raw, phase=2, subtype=1, expect=None, label='', cells=True, log=None, msg=None):
        stats['native_refusal_checks'] += 1
        before = snap()
        n0 = nat.log_count()
        v0 = nat.visits(binding)
        status, done, new_phase, disp = nat.visit(binding, binding, 1, subtype, raw, 0, phase)
        got = nat.log(n0)
        if status != 0 and nat.visits(binding) != v0:
            raise Mismatch('refusal %s: the visit counter moved on a refused visit' % label)
        if msg is not None and msg not in nat.failure(binding):
            raise Mismatch('refusal %s: failure text %r does not mention %r' % (label, nat.failure(binding), msg))
        if expect is not None and status != expect:
            raise Mismatch('refusal %s: status %d, expected %d (%s)' % (label, status, expect, nat.failure(binding)))
        if status != 0:
            if (done, new_phase) != (0, phase):
                raise Mismatch('refusal %s: a refused visit changed the row result (%d, %#x)' % (label, done, new_phase))
        if cells and status != 0 and snap() != before:
            raise Mismatch('refusal %s: a refused visit changed the host cells or flags' % label)
        if log is not None and got != log:
            raise Mismatch('refusal %s: host calls %r expected %r' % (label, got, log))
        return status, got

    # ---- raw 0x9a
    for idx in (-2, WINDOW, 0x7FFF, -32768, WINDOW + 1, -1000):
        for sound, scene in ((0x14, 9999), (3, 9999), (3, 12), (0x15, 40)):
            fresh()
            run(0x9A, body9a(sound=sound, scene=scene, flag=idx, fval=7), expect=HANDLER_ERROR, label='9a flag index %d' % idx,
                log=[(L_FLAGQ, sgn(idx, 2), 0)], msg='event flag index')
        for phase in (0, 1, 3):         # other phases never look at the flag
            fresh()
            run(0x9A, body9a(sound=3, scene=9999, flag=idx), phase=phase, expect=HANDLER_OK, label='9a flag index %d phase %d' % (idx, phase), log=[],
                cells=False)
    for idx in (0, WINDOW - 1):          # the window edges are valid
        fresh()
        run(0x9A, body9a(sound=3, scene=12, flag=idx, fval=9), expect=HANDLER_OK, label='9a flag edge %d' % idx)
    # missing hosts
    for omit, label, scene, expect in ((O_STOP, 'stop', 9999, HANDLER_UNSUPPORTED), (O_FLAGQ, 'flag query', 9999, HANDLER_UNSUPPORTED),
                                       (O_FLAGSTORE, 'flag store', 9999, HANDLER_UNSUPPORTED), (O_TRANSITION, 'transition with a scene', 12, HANDLER_UNSUPPORTED),
                                       (O_TRANSITION, 'transition without a scene', 9999, HANDLER_OK), (O_STORE9A, 'store_world', 12, HANDLER_OK),
                                       (O_LOAD9A, 'load_world', 9999, HANDLER_OK)):
        fresh()
        nat.set_omit(omit)
        run(0x9A, body9a(sound=3, scene=scene, flag=5, fval=1), expect=expect, label='9a missing ' + label,
            log=[] if expect != HANDLER_OK else None, cells=expect != HANDLER_OK,
            msg=None if expect == HANDLER_OK else ('scene-change provider' if omit == O_TRANSITION else 'sound channel stop'))
        if omit == O_LOAD9A:             # the optional world provider: a missing one is a zero world (documented contract), committed by store_world
            if any(nat.get(n) != 0 for n in CELLS_9A):
                raise Mismatch('9a without load_world did not start from the zero world')
    # host failures
    fresh()
    nat.set_fail(F_LOAD9A)
    run(0x9A, body9a(sound=3, scene=12, flag=5), expect=HANDLER_UNSUPPORTED, label='9a load_world fails', log=[], msg='world provider')
    for n_stop, sound, expected_stops in ((1, 0x14, 0), (2, 0x14, 1), (14, 0x14, 13), (1, 5, 0), (1, 0x15, 0), (13, 0x15, 12)):
        fresh()
        nat.set_fail(0, n_stop)
        run(0x9A, body9a(sound=sound, scene=12, flag=5, fval=1), expect=HANDLER_ERROR, label='9a stop %d fails' % n_stop, msg='stop or event flag',
            log=[(L_FLAGQ, 5, 0)] + [(L_STOP, (0 if sound == 0x14 else 1) + k if sound in (0x14, 0x15) else sound, 0) for k in range(expected_stops)])
    fresh()
    nat.set_fail(0, 15)
    status, _ = run(0x9A, body9a(sound=0x14, scene=12, flag=5), expect=HANDLER_OK, label='9a 15th stop never reached')
    fresh()
    nat.set_fail(F_STORE_FLAG)
    run(0x9A, body9a(sound=1, scene=12, flag=5, fval=3), expect=HANDLER_ERROR, label='9a flag store fails',
        log=[(L_FLAGQ, 5, 0), (L_STOP, 1, 0)], msg='stop or event flag')
    fresh()
    cells, flags = snap()
    nat.set_fail(F_TRANSITION)
    stats['native_refusal_checks'] += 1
    status, done, new_phase, disp = nat.visit(0x9A, 0x9A, 1, 1, body9a(sound=1, scene=12, flag=5, fval=3, w4=9), 0, 2)
    if status != HANDLER_ERROR or (done, new_phase) != (0, 2) or 'refused' not in nat.failure(0x9A):
        raise Mismatch('9a refused transition: status %d result (%d, %d) %s' % (status, done, new_phase, nat.failure(0x9A)))
    if nat.get('5bb57b') != 12 or nat.flags()[5] != 3:
        raise Mismatch('9a refused transition: the kernel work is committed before the request (documented), but the cells are not')
    # malformed bodies
    for raw, label in ((bytes(26), 'short'), (bytes(0), 'empty'), (bytes(27 + 5), 'ragged tail'), (bytes(27 + 15), 'ragged tail 15')):
        fresh()
        run(0x9A, raw, expect=HANDLER_ERROR, label='9a body ' + label, log=[], msg='invalid raw-0x9a body')
    fresh()
    run(0x9A, body9a(sound=3, scene=9999) + bytes(16), expect=HANDLER_OK, label='9a with one dependency record')
    fresh()
    run(0x9A, body9a(sound=3, scene=9999) + bytes(48), expect=HANDLER_OK, label='9a with three dependency records')
    stats['native_refusal_checks'] += 1
    nat.reset()
    status = nat.lib.a6o_visit(nat.h, 0x9A, 0x6D, 0, 1, bytes(27), 27, 0, 2, C.byref(C.c_int()), C.byref(C.c_uint32()), C.byref(C.c_int()))
    if status != HANDLER_ERROR:
        raise Mismatch('9a binding accepted a row of another type (status %d)' % status)

    # ---- raw 0x6d
    for sel_cells, kind in (({'5bb22a': 1, '583204': 4}, 'overlay'), ({'5bb22a': 0, '583204': 4}, 'mode4'), ({'5bb22a': 0, '583204': 3}, 'mode3')):
        fresh()
        for n, v in sel_cells.items():
            nat.set(n, v)
        nat.set_omit(O_TEARDOWN)
        run(0x6D, b'\x00', phase=5, expect=HANDLER_UNSUPPORTED, label='6d %s without a teardown host' % kind, log=[], msg='no host')
        fresh()
        for n, v in sel_cells.items():
            nat.set(n, v)
        nat.set_fail(F_TEARDOWN)
        run(0x6D, b'\x00', phase=5, expect=HANDLER_ERROR, label='6d %s teardown fails' % kind, log=[], msg='teardown or sound unload')
        fresh()
        for n, v in sel_cells.items():
            nat.set(n, v)
        nat.set_fail(F_UNLOAD)
        run(0x6D, b'\x00', phase=5, expect=HANDLER_ERROR, label='6d %s unload fails (teardown already ran)' % kind, log=[(L_TEARDOWN, KIND_CODE[kind], 0)],
            msg='teardown or sound unload')
    fresh()
    nat.set('5bb22a', 0)
    nat.set('583204', 5)
    nat.set_omit(O_TEARDOWN)
    run(0x6D, b'\x00', expect=HANDLER_OK, label='6d no teardown needed, no host', log=[(L_UNLOAD, 0, 0), (L_STORE6D, 0, 0)], cells=False)
    for omit, label, expect in ((O_UNLOAD, 'unload', HANDLER_UNSUPPORTED), (O_LOAD6D, 'load_world', HANDLER_UNSUPPORTED), (O_STORE6D, 'store_world', HANDLER_OK)):
        fresh()
        nat.set('5bb22a', 0)
        nat.set('583204', 0)
        nat.set_omit(omit)
        run(0x6D, b'\x00', expect=expect, label='6d missing ' + label, cells=expect != HANDLER_OK,
            msg=None if expect == HANDLER_OK else ('scene sound unload' if omit == O_UNLOAD else 'world provider'))
    fresh()
    nat.set_fail(F_LOAD6D)
    run(0x6D, b'\x00', expect=HANDLER_UNSUPPORTED, label='6d load_world fails', log=[], msg='world provider')
    for raw, label in ((bytes(0), 'empty'), (bytes(1 + 5), 'ragged tail')):
        fresh()
        run(0x6D, raw, expect=HANDLER_ERROR, label='6d body ' + label, log=[], msg='invalid raw-0x6d body')
    fresh()
    run(0x6D, b'\x00' + bytes(16), expect=HANDLER_OK, label='6d with one dependency record')
    stats['native_refusal_checks'] += 1
    nat.reset()
    status = nat.lib.a6o_visit(nat.h, 0x6D, 0x9A, 0, 1, bytes(1), 1, 0, 2, C.byref(C.c_int()), C.byref(C.c_uint32()), C.byref(C.c_int()))
    if status != HANDLER_ERROR:
        raise Mismatch('6d binding accepted a row of another type (status %d)' % status)
    nat.reset()


def merge(a, b):
    """Add two stats trees (dicts of numbers / dicts / lists)."""
    if isinstance(a, dict) and isinstance(b, dict):
        out = dict(a)
        for k, v in b.items():
            out[k] = merge(out[k], v) if k in out else v
        return out
    if isinstance(a, list) and isinstance(b, list):
        return a + b
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return a + b
    return a


def to_plain(stats):
    return {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}


def discover_pins(x, blocks):
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
    for a in HOOK_ENTRIES:
        i = bisect.bisect_left(starts, a)
        funcs[starts[i]] = starts[i + 1]
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
    return 'PINS_TABLE = (\n' + ''.join('    (%#x, %#x, %r),\n' % t for t in out) + ')'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--workers', type=int, default=1)
    ap.add_argument('--shard', default='', help='internal: k/N')
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    ap.add_argument('--list', action='store_true', help='print the scenario counts per group and exit')
    args = ap.parse_args()
    started = time.monotonic()
    scs = scenario_list()
    if args.list:
        print(json.dumps(dict(Counter(s['group'] for s in scs)), sort_keys=True), len(scs), 'scenarios,', sum(1 for s in scs if s['quick']), 'quick')
        return 0
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-57.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_6d9a.so', strict=not args.lenient_build)
        procs = []
        for k in range(args.workers):
            res = work / ('shard%d.json' % k)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--shard', '%d/%d' % (k, args.workers),
                   '--result', str(res), '--show', str(args.show)]
            for flag in ('--fail-fast', '--quick-only'):
                if getattr(args, flag[2:].replace('-', '_')):
                    cmd.append(flag)
            if args.only:
                cmd += ['--only', args.only]
            procs.append((res, subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)))
        merged, bad_lines, code = None, [], 0
        for res, p in procs:
            out, err = p.communicate()
            code |= p.returncode
            bad_lines += [l for l in out.splitlines() if l.startswith('MISMATCH')]
            if err.strip():
                print(err[-600:], file=sys.stderr)
            if res.exists():
                data = json.loads(res.read_text())
                merged = data['stats'] if merged is None else merge(merged, data['stats'])
        for l in bad_lines[:args.show]:
            print(l)
        if merged is None:
            print('no shard result')
            return 1
        merged['seconds'] = round(time.monotonic() - started, 1)
        merged['workers'] = args.workers
        print(json.dumps(merged, sort_keys=True, default=str))
        if args.result:
            args.result.parent.mkdir(parents=True, exist_ok=True)
            args.result.write_text(json.dumps(dict(slice='RT-57', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_6d9a.so', strict=not args.lenient_build)
    nat = Native(lib_path)
    x = Oracle()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast)
    if not args.only and shard_k == 0:
        try:
            refusal_checks(nat, stats)
        except Mismatch as error:
            bad.append(('refusal', str(error)))
            stats['mismatches'] += 1
    if args.discover_pins:
        print(discover_pins(x, blocks))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:900])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = to_plain(stats)
    summary['seconds'] = round(time.monotonic() - started, 1)
    if not args.shard:
        print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-57', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
