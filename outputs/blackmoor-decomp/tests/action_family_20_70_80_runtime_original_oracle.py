#!/usr/bin/env python3
"""RT-48: immutable x86 dispatcher 0x427a50 (arms 0x429373, 0x4291f8, 0x42960b), the erase 0x43e96c + recount 0x43e8b8 and the
method 0x4e386e (raw types 0x20, 0x70 and 0x80) versus the native runtime modules.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw types 0x20, 0x70, 0x80 (and 0x67 as the plain "other
loaded row") the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0),
the arms themselves and the original erase / recount / dependency reset 0x423b51 / method 0x4e386e. All of it is original x86;
the rows sit in memory with the real slot layout (stride 0x8d at 0x5bb5b3: type 0x5bb5e3, body pointer +2, dependency +6,
completion byte 0x5bb625, request dword 0x5bb626, phase dword 0x5bb632, word 0x5bb636, unloaded dword 0x5bb638, loaded dword
0x5bb63c, high-water count word 0x5c39e3).

Native side: src/session_bindings_a20_a70_a80.c (the executor's handler contract) over src/action_family_{20,70,80}_runtime.c,
driven by tests/action_family_20_70_80_runtime_oracle_driver.c with the executor's disposition mapping. The driver holds the
cells, the 0x57975c object fields and a row model, and implements the HOST side of the contracts (erase_rows, unload_scene_sound,
transition, load/store of cells and object), as the app would. The native handler runs only for a true gate (executor
semantics): the gate itself is the original code on the original side and an event-flag model on the native side.

Compared after every dispatcher call (tick):
 * the exact observed event sequence of the original (arm entries, true-gate visits, every write to a modelled cell, every
   completion-byte store, the 0x4fb018 call with a snapshot of the six cells it must not have changed yet, every write to an
   object field) against the sequence the documented order predicts (0x20: 0x63aa10, 0x55cd94, completion := 1, the erased rows'
   completion := 0 in row order, the recount's word 0x5c39e3, 0x5bb57b, word 0x5c3a4f; 0x70: sound, 0x583985 := 6, 0x583981 := 5,
   0x583991 := 0, word 0x5bb1c4 := 1, 0x583999 := 0, 0x5bb1e2 := 0, completion := 1; 0x80: scene cells, tuple cells, mode 4, the
   state 2/3 stores in order, completion := 1);
 * every modelled process cell (21 of them) and every object field the method touches, original against native, bit for bit;
   every original byte of the 0x57975c..+0x6700 object that is not one of the listed fields is unchanged; every write outside the
   modelled cells (apart from the gate's pinned scratch) fails the run;
 * every byte of every row (0x8d bytes, except the dependency record the gate and the reset own) against the model: erased rows
   have type 0, body pointer 0, completion 0, request 0, phase 0, word 0xffff, unloaded 1, loaded 0; entered rows have request 0;
   completed rows have completion 1; nothing else changes (garbage in the unlisted bytes proves it);
 * the erased set, the freed body pointers (hook on 0x51dc6c), the 0x423b51 dependency resets and the new high-water count of the
   original against the native host's erase model AND against an independent recount computed here; rows below the new count
   that were erased are skipped for the rest of the pass (observed arm entries);
 * the dispatcher loop's own conditions (0x427a8e: engine mode [0x583999] must be 3 at every row, so after a 0x70 row (mode 0) or
   a 0x80 row (mode 4) no further row runs in that pass) against the native mode cell; neither the generic completion 0x42ba3a
   nor the dependency reset 0x423d33 ever runs; the scene-change request handed to the host equals target (int16)[0x5bb57b],
   words 0x5bb599 / 0x5bb595 / 0x5c39ff and dwords 0x5bb59b / 0x5bb59f / 0x5bb5a3; the stored-scene flag of the object loader is
   (word == 9999).

Native vs original model differences (the erase model is the host's): an erased row is "retired" natively (completed 1, phase 0)
and unloaded in the original (type 0, completion 0, unloaded 1), both permanently out of the pass; this is compared as the erased
SET and as the rows visited afterwards, not as raw fields. One real difference is recorded, not failed (use --strict-known to fail
on it): the original stores a phase of 0 only for a row it erases; a 0x20 row whose loaded dword is 0 keeps its phase, the native
binding always returns phase 0 (`known_divergences`).

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entries 0x429373 / 0x4291f8 / 0x42960b / 0x428692 (the row is the signed word at [ebp-0x11c]), the post-gate points
    0x42939b / 0x42921b / 0x42962f / 0x4286b5, method 0x4e386e (ECX must be 0x57975c), 0x43e96c, 0x43e8b8, 0x423b51 (reset of an
    erased row), 0x42ba3a and 0x423d33 (must not run), every store to the process data region (from 0x4f0000 up to 0x680000)
  R 0x4fb018 scene sound unload (recorded, its own effects are host behaviour), 0x51dc6c free (recorded: pointer)
  R 0x51dc43 malloc (bump arena) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle. The debug flag 0x63a4cd is 0 (the native modules model the flag as 0).

Not modelled / unverified: the scene loader 0x40b34a that builds the rows (the oracle builds them in memory; it sets the loaded
dword only when [0x5c3a01] == 2), the six corpus rows' real dependency records (replayed without them and behind a stand-in
event record, the gate is shared verified code), the effects of 0x4fb018 / the readers of the cells (host behaviour), and the
debug-flag-set paths.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_20_70_80_runtime_original_oracle.py --quick-only
  python3 action_family_20_70_80_runtime_original_oracle.py --mutations --result <receipt.json>
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
DEP_LO, DEP_HI = 0x36, 0x72            # the dependency record (gate and reset own it)
GAP_OFFS = (0x77, 0x7F)                # unlisted bytes between the request dword and the phase dword
MAX_ROWS = 40
BODY_STRIDE = 0x40

ARM = {0x20: 0x429373, 0x70: 0x4291F8, 0x80: 0x42960B, 0x67: 0x428692}
VISIT = {0x20: 0x42939B, 0x70: 0x42921B, 0x80: 0x42962F, 0x67: 0x4286B5}
METHOD, METHOD_THIS = 0x4E386E, 0x57975C
SOUND, SOUND_THIS = 0x4FB018, 0x5C3A67
FREE = 0x51DC6C
ERASE, RECOUNT, ERASE_RESET = 0x43E96C, 0x43E8B8, 0x423B51
OBJ, OBJ_BYTES = 0x57975C, 0x6700
DATA_BASE, DATA_LIMIT = 0x4F0000, 0x680000
EVENTS_VA = d9.EVENTS_VA

# modelled cells: name -> (address, size)
CELLS = {
    '63aa10': (0x63AA10, 4), '55cd94': (0x55CD94, 4), '5bb57b': (0x5BB57B, 4), '5bb57f': (0x5BB57F, 4), '5c3a4f': (0x5C3A4F, 2),
    '5c39e3': (0x5C39E3, 2), '583981': (0x583981, 4), '583985': (0x583985, 4), '583991': (0x583991, 4), '5bb1c4': (0x5BB1C4, 2),
    '583999': (0x583999, 4), '5bb1e2': (0x5BB1E2, 4), '583204': (0x583204, 4), '5bb22a': (0x5BB22A, 4), '5bb599': (0x5BB599, 2),
    '5bb595': (0x5BB595, 2), '5c39ff': (0x5C39FF, 2), '5bb59b': (0x5BB59B, 4), '5bb59f': (0x5BB59F, 4), '5bb5a3': (0x5BB5A3, 4),
}
FLAG_CELL = ('5bb1ca', 0x5BB1CA, 4)     # the 0x67 arm's start flag: original only
OBJ_FIELDS = {
    'o6ba': (0x6BA, 2), 'o6bc': (0x6BC, 2), 'o6be': (0x6BE, 2), 'o6c2': (0x6C2, 4), 'o6c6': (0x6C6, 4), 'o6ca': (0x6CA, 4),
    'o4528': (0x4528, 4), 'o6b2': (0x6B2, 2), 'o6b4': (0x6B4, 4), 'o4530': (0x4530, 4), 'o65d2': (0x65D2, 4),
}
SIZES = {**{n: s for n, (_, s) in CELLS.items()}, **{n: s for n, (_, s) in OBJ_FIELDS.items()}}
CELL_BY_VA = {va: (n, s) for n, (va, s) in CELLS.items()}
CELL_BY_VA[FLAG_CELL[1]] = (FLAG_CELL[0], FLAG_CELL[2])
OBJ_BY_OFF = {off: (n, s) for n, (off, s) in OBJ_FIELDS.items()}
SOUND_CELLS = ('583981', '583985', '583991', '5bb1c4', '583999', '5bb1e2')
# writes outside the modelled cells the gate and the dispatcher make (discovered, then pinned)
EXPECTED_OTHER_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423876, 0x423a30, '68ca5942ca89ab5f3a641c4d6fa7bde6c54a50b9ae8ae518b9af4ced25969e3e'),
    (0x423a30, 0x423aae, '252b82f254028899a115f8a39228636412d30bdcdc1ebb54ec3929f9ff90077b'),
    (0x423aae, 0x423af1, 'a84843a2eb2124a83a5d3693b27690db5339bd49929982c7f67978ac57be50b5'),
    (0x423b51, 0x423c2b, '918a1b51e6a925839988b64f0ffc7c30a9fdff1053d35bfb65375dbbccd04a3a'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x43dbd5, 0x43dbe3, '598507c387a08f61f186aa33bed364cdb4cddb3beb7b2f3638e7743017833ba3'),
    (0x43e8b8, 0x43e96c, 'b0a380ec6ece9b7b206a9087121c75ca5fd6360992938f532a08230a8e268e5d'),
    (0x43e96c, 0x43eab0, 'b477293ef99886349d5dfd2b5660451d5610ec0af97cc63b83c21dfa3b41e4f8'),
    (0x4e386e, 0x4e3a64, '463c4e19beca6dcc0f581edee45c07e92a3307bc0fc914324900668ac7580c98'),
    (0x4fb018, 0x4fb071, '648bb1b932269ec9dfd757b94323c7c19cfec9dbf87b37f952f3ef8aa07ffc62'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


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
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x20/0x70/0x80 observers."""

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
        self.events, self.methods, self.frees, self.erase_resets = [], [], [], []
        self.finish_entries, self.resets, self.erase_calls, self.recount_calls = [], [], 0, 0
        self.other_writes = Counter()

    def row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {SOUND: self._sound, FREE: self._free, METHOD: self._method, ERASE_RESET: self._erase_reset,
                 0x423D33: self._reset_seen, 0x42BA3A: self._finish, ERASE: self._erase_seen, RECOUNT: self._recount_seen}
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_BASE, end=DATA_LIMIT)

    def _mk_event(self, kind, typ):
        def run(uc, address, size, user):
            self.events.append((kind, typ, self.row_at_arm(uc)))
        return run

    def _method(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != METHOD_THIS:
            raise d9.OracleError('method called with this=%#x' % uc.reg_read(X.UC_X86_REG_ECX))
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.methods.append(s16(u32(uc, sp + 4)))

    def _sound(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != SOUND_THIS:
            raise d9.OracleError('sound unload called with this=%#x' % uc.reg_read(X.UC_X86_REG_ECX))
        snap = tuple(self.cell(n) for n in SOUND_CELLS)
        self.events.append(('sound', snap))
        self._ret(uc, 0)

    def _free(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.frees.append(u32(uc, sp + 4))
        self._ret(uc, 0)

    def _erase_reset(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.erase_resets.append(u32(uc, sp + 4))

    def _erase_seen(self, uc, address, size, user):
        self.erase_calls += 1

    def _recount_seen(self, uc, address, size, user):
        self.recount_calls += 1

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
        if OBJ <= address < OBJ + OBJ_BYTES:
            hit = OBJ_BY_OFF.get(address - OBJ)
            if hit is not None and hit[1] == size:
                self.events.append(('o', hit[0], value))
            else:
                self.other_writes['obj+%#x/%d' % (address - OBJ, size)] += 1
            return
        if ROWS <= address < ROWS + MAX_ROWS * ROW:
            row, off = divmod(address - ROWS, ROW)
            if off == COMPLETE_OFF and size == 1:
                self.events.append(('comp', row, value))
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
        va, size = CELLS[name] if name in CELLS else (FLAG_CELL[1], FLAG_CELL[2])
        return int.from_bytes(self.rd(va, size), 'little')

    def set_cell(self, name, value):
        va, size = CELLS[name] if name in CELLS else (FLAG_CELL[1], FLAG_CELL[2])
        self.wr(va, (value & mask(size)).to_bytes(size, 'little'))

    def obj_field(self, name):
        off, size = OBJ_FIELDS[name]
        return int.from_bytes(self.rd(OBJ + off, size), 'little')

    def set_obj_field(self, name, value):
        off, size = OBJ_FIELDS[name]
        self.wr(OBJ + off, (value & mask(size)).to_bytes(size, 'little'))

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
SOURCES = ('session_bindings_a20_a70_a80.c', 'action_family_20_runtime.c', 'action_family_70_runtime.c', 'action_family_80_runtime.c',
           'action_family_20.c', 'action_family_70.c', 'action_family_80.c')


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_20_70_80_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in SOURCES], '-lm', '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('A2X_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P = C.c_void_p
        lib.a2o_new.restype = P
        lib.a2o_free.argtypes = [P]
        lib.a2o_reset.argtypes = [P]
        lib.a2o_clear_logs.argtypes = [P]
        lib.a2o_name.restype = C.c_char_p
        lib.a2o_name.argtypes = [C.c_int]
        lib.a2o_get.restype = C.c_int64
        lib.a2o_get.argtypes = [P, C.c_int]
        lib.a2o_set.argtypes = [P, C.c_int, C.c_int64]
        lib.a2o_set_fail.argtypes = [P, C.c_int]
        lib.a2o_row_get.restype = C.c_int32
        lib.a2o_row_get.argtypes = [P, C.c_int, C.c_int]
        lib.a2o_row_set.argtypes = [P, C.c_int, C.c_int, C.c_int32]
        lib.a2o_log.restype = C.c_int
        lib.a2o_log.argtypes = [P, C.c_int, C.POINTER(C.c_int), C.c_int]
        lib.a2o_info.restype = C.c_int64
        lib.a2o_info.argtypes = [P, C.c_int]
        lib.a2o_snap70.argtypes = [P, C.POINTER(C.c_int64)]
        lib.a2o_req.argtypes = [P, C.POINTER(C.c_int64)]
        lib.a2o_visit.restype = C.c_int
        lib.a2o_visit.argtypes = [P, C.c_int, C.c_int, C.c_int, C.c_char_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                  C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a2o_failure.restype = C.c_char_p
        lib.a2o_failure.argtypes = [P, C.c_int]
        self.h = lib.a2o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')
        self.index = {lib.a2o_name(i).decode(): i for i in range(lib.a2o_nv())}
        if set(self.index) != set(SIZES):
            raise d9.OracleError('driver cell table differs from the oracle: %r' % sorted(set(self.index) ^ set(SIZES)))

    def close(self):
        self.lib.a2o_free(self.h)

    def reset(self):
        self.lib.a2o_reset(self.h)

    def clear_logs(self):
        self.lib.a2o_clear_logs(self.h)

    def get(self, name):
        return self.lib.a2o_get(self.h, self.index[name]) & mask(SIZES[name])

    def set(self, name, value):
        self.lib.a2o_set(self.h, self.index[name], sgn(value, SIZES[name]))

    def row(self, i):
        return tuple(self.lib.a2o_row_get(self.h, i, f) & 0xFFFFFFFF for f in range(4))

    def set_row(self, i, loaded, unloaded, retired, has_body):
        for f, v in enumerate((loaded, unloaded, retired, has_body)):
            self.lib.a2o_row_set(self.h, i, f, sgn(v, 4))

    def log(self, which):
        buf = (C.c_int * 1024)()
        n = self.lib.a2o_log(self.h, which, buf, 1024)
        return list(buf[:n])

    def info(self, which):
        return self.lib.a2o_info(self.h, which)

    def snap70(self):
        buf = (C.c_int64 * 6)()
        self.lib.a2o_snap70(self.h, buf)
        return [buf[0] & mask(4), buf[1] & mask(4), buf[2] & mask(4), buf[3] & mask(2), buf[4] & mask(4), buf[5] & mask(4)]

    def request(self):
        buf = (C.c_int64 * 7)()
        self.lib.a2o_req(self.h, buf)
        return list(buf)

    def set_fail(self, mask_):
        self.lib.a2o_set_fail(self.h, mask_)

    def visit(self, typ, row, subtype, raw, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a2o_visit(self.h, typ, row, subtype, bytes(raw), len(raw), completed, phase, C.byref(done), C.byref(reset),
                                    C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
POOL32 = [0, 1, 2, 3, 4, 5, 6, 0x270F, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xDEADBEEF, 0x12345678]
POOL16 = [0, 1, 2, 5, 6, 0x270F, 0x7FFF, 0x8000, 0xFFFF, 0x1234]
BODIES80 = [9999, 0x189D, 0x0000, 0xD8F0, 0x270E, 0x2710, 0xA70F, 0x270F, 0x8000, 0x7FFF, 0x0001, 0xFFFF]


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def body20(a, b):
    return struct.pack('<II', a & 0xFFFFFFFF, b & 0xFFFFFFFF)


def default_body(typ):
    return {0x20: body20(1, 2), 0x70: b'\0', 0x80: struct.pack('<H', 0x189D), 0x67: b'\1'}.get(typ, b'\0')


def R(typ, subtype=1, body=None, tail=b'', **kw):
    """One row: loaded dword 0 / unloaded 0 / open unless given. body=False means a null body pointer."""
    d = dict(type=typ, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA,
             word=0x1234, erased=False)
    d.update(kw)
    if d['body'] is None:
        d['body'] = default_body(typ)
    elif d['body'] is False:
        d['body'] = None
    return d


def rand_cells(rng, names=None):
    out = {}
    for n, (_, s) in CELLS.items():
        if n in ('5c39e3', '583999') or (names is not None and n not in names):
            continue
        out[n] = rng.choice(POOL32 if s == 4 else POOL16) if rng.random() < 0.45 else rng.getrandbits(8 * s)
    return out


def rand_obj(rng):
    out = {}
    for n, (_, s) in OBJ_FIELDS.items():
        pool = POOL32 if s == 4 else POOL16
        out[n] = rng.choice(pool) if rng.random() < 0.4 else rng.getrandbits(8 * s)
    out['o4528'] = rng.choice([0, 1, 2, 3, 4, rng.getrandbits(32), 0xFFFFFFFF])
    out['o6b2'] = rng.choice([0x270F, 0x270F, 0, 0xFFFF, rng.getrandbits(16)])
    out['o6b4'] = rng.choice([0, 0, 1, rng.getrandbits(32)])
    out['o6ba'] = rng.choice([0, 1, 0x270F, 0xFFFF, 0x8000, rng.getrandbits(16)])
    return out


def scenario_list(seed=0x4A80):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', cells=None, obj=None, events=None, mode=3, quick=False, known=False):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, cells=cells or {}, obj=obj or {},
                        events=events or {}, mode=mode, quick=quick, known=known))

    def AGAIN(*extra):
        return [('tick',), ('set', {'583999': 3}), ('rearm',), *extra, ('tick',)]

    # ---- the six corpus bodies (0x80: 0x189d, 0x270f; 0x20: (4,1), (3,1); 0x70: byte 0 with and without a dependency record)
    tuple_obj = dict(o6ba=0x0123, o6bc=0x0456, o6be=0xFFF0, o6c2=0x11112222, o6c6=0xFFFFFFFE, o6ca=7, o6b2=0x0042, o6b4=5,
                     o4530=0x77, o65d2=0x1234)
    for st in (0, 1, 2, 3, 4):
        S('corpus:80_189d_state%d' % st, [R(0x80, 1, struct.pack('<H', 0x189D), loaded=1)] , AGAIN(), group='corpus',
          obj=dict(tuple_obj, o4528=st), cells=rand_cells(rng), quick=st in (0, 2, 3))
        S('corpus:80_270f_state%d' % st, [R(0x80, 1, struct.pack('<H', 0x270F), loaded=1)], AGAIN(), group='corpus',
          obj=dict(tuple_obj, o4528=st), cells=rand_cells(rng), quick=st in (1, 2, 3))
    for k, (a, b) in enumerate(((4, 1), (3, 1))):
        S('corpus:20_%d_%d' % (a, b), [R(0x67, loaded=1, body=False), R(0x20, 1, body20(a, b), loaded=1), R(0x67, loaded=1),
                                       R(0x67, loaded=0)], AGAIN(), group='corpus', cells=rand_cells(rng), quick=True)
        S('corpus:20_%d_%d_alone' % (a, b), [R(0x20, 1, body20(a, b), loaded=1)], [('setphase', 0, 9), ('tick',)], group='corpus',
          cells=rand_cells(rng), quick=k == 0)
    S('corpus:70_bare', [R(0x70, 1, b'\0')], AGAIN(), group='corpus', cells=rand_cells(rng), quick=True)
    S('corpus:70_dependency', [R(0x70, 1, b'\0', tail=event_tail(1003, 1))], [('tick',), ('events', {1003: 1}), ('tick',)] + AGAIN(),
      group='corpus', cells=rand_cells(rng), events={1003: 7}, quick=True)

    # ---- gate: false gate changes nothing (the native handler is not called), true gate runs, offset rows, subtypes, re-arm
    for fam, mk in ((0x20, lambda t: R(0x20, 1, body20(5, 6), t, loaded=1)), (0x70, lambda t: R(0x70, 1, b'\x03', t)),
                    (0x80, lambda t: R(0x80, 1, struct.pack('<H', 0x0042), t))):
        S('gate:%#x_event_false' % fam, [mk(event_tail(40, 1)), R(0x67)], [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('set', {'583999': 3}),
                                                                           ('rearm',), ('tick',)],
          group='gate', events={40: 7}, cells=rand_cells(rng), obj=dict(tuple_obj, o4528=2), quick=True)
        S('gate:%#x_offset_rows' % fam, [R(0x67, completed=1, loaded=1), R(0x67, completed=1), mk(b''), R(0x67)], AGAIN(), group='gate',
          cells=rand_cells(rng), obj=dict(tuple_obj, o4528=3), quick=fam == 0x20)
        S('gate:%#x_mode_not_3' % fam, [mk(b''), R(0x67)], [('tick',), ('set', {'583999': 3}), ('tick',)], group='gate', mode=4,
          cells=rand_cells(rng), quick=True)
        for sub in (0, 1, 2, 3, 4, 255):
            rows = [R(fam, sub, default_body(fam) if fam != 0x80 else struct.pack('<H', 9999), loaded=1) , R(0x67, sub)]
            S('subtype:%#x_%d' % (fam, sub), rows, [('setphase', 0, 5), ('setphase', 1, 9)] + AGAIN(), group='subtype',
              cells=rand_cells(rng), obj=dict(tuple_obj, o4528=2), quick=sub in (0, 255))

    # ---- raw 0x20: erase set, frees, skip after erase, recount
    S('a20:mix', [R(0x67, loaded=1), R(0x20, 1, body20(0xA1, 0xB2), loaded=1), R(0x67, loaded=0), R(0x67, loaded=3, body=False),
                  R(0x20, 1, body20(9, 8), loaded=0), R(0x67, loaded=1)], AGAIN(), group='a20', cells=rand_cells(rng), quick=True)
    S('a20:loaded_zero_is_not_erased', [R(0x20, 1, body20(1, 2), loaded=0), R(0x67, loaded=0), R(0x67, loaded=0)],
      [('tick',), ('rearm',), ('tick',)], group='a20', cells=rand_cells(rng), quick=True)
    S('a20:loaded_zero_keeps_phase', [R(0x20, 1, body20(1, 2), loaded=0)], [('setphase', 0, 7), ('tick',)], group='a20', known=True,
      cells=rand_cells(rng), quick=True)
    S('a20:erased_row_phase_is_cleared', [R(0x20, 1, body20(1, 2), loaded=1), R(0x67, loaded=1)], [('setphase', 0, 5), ('setphase', 1, 6), ('tick',)],
      group='a20', cells=rand_cells(rng), quick=True)
    S('a20:two_20_rows_second_skipped', [R(0x20, 1, body20(1, 2), loaded=1), R(0x20, 1, body20(3, 4), loaded=1), R(0x67, loaded=0)],
      AGAIN(), group='a20', cells=rand_cells(rng), quick=True)
    S('a20:two_20_rows_second_unloaded_kept', [R(0x20, 1, body20(1, 2), loaded=0), R(0x20, 1, body20(3, 4), loaded=1)], AGAIN(), group='a20',
      cells=rand_cells(rng), quick=True)
    S('a20:count_shrinks_past_open_rows', [R(0x67, loaded=0), R(0x20, 1, body20(1, 2), loaded=1), R(0x67, loaded=0), R(0x67, loaded=0),
                                          R(0, 0, completed=0, unloaded=1, loaded=0), R(0, 0, unloaded=1, loaded=1)], AGAIN(),
      group='a20', cells=rand_cells(rng), quick=True)
    S('a20:all_erased_count_zero', [R(0x20, 1, body20(7, 7), loaded=5), R(0x67, loaded=1), R(0x67, loaded=2), R(0x67, completed=1, loaded=1)],
      AGAIN(), group='a20', cells=rand_cells(rng), quick=True)
    S('a20:no_trailing_run', [R(0x67, loaded=0), R(0x20, 1, body20(7, 7), loaded=0), R(0x67, loaded=0)], AGAIN(), group='a20',
      cells=rand_cells(rng), quick=True)
    S('a20:null_bodies', [R(0x67, loaded=1, body=False), R(0x20, 1, body20(1, 2), loaded=1), R(0x67, loaded=1, body=False)], AGAIN(),
      group='a20', cells=rand_cells(rng), quick=True)
    S('a20:unloaded_but_loaded_rows', [R(0x67, loaded=1, unloaded=1), R(0x20, 1, body20(0, 0xFFFFFFFF), loaded=1), R(0x67, unloaded=1, loaded=9)],
      AGAIN(), group='a20', cells=rand_cells(rng), quick=True)
    for k in range(6):
        cells = rand_cells(rng)
        S('a20:cells%d' % k, [R(0x20, 1, body20(rng.getrandbits(32), rng.getrandbits(32)), loaded=1)], AGAIN(), group='a20', cells=cells,
          quick=k < 2)

    # ---- raw 0x70
    for k in range(5):
        S('a70:cells%d' % k, [R(0x70, 1, bytes([rng.getrandbits(8)])), R(0x67), R(0x70, 2, b'\0')], AGAIN(), group='a70',
          cells=rand_cells(rng), quick=k < 3)
    S('a70:rows_after_are_not_run_in_the_pass', [R(0x67), R(0x70), R(0x67), R(0x20, 1, body20(1, 1), loaded=1)], AGAIN(), group='a70',
      cells=rand_cells(rng), quick=True)
    S('a70:cell_specials', [R(0x70)], [('tick',)], group='a70', quick=True,
      cells=dict(rand_cells(rng), **{'583981': 5, '583985': 6, '583991': 0, '5bb1c4': 1, '5bb1e2': 0}))
    S('a70:cell_specials_ff', [R(0x70)], [('tick',)], group='a70', quick=True,
      cells={'583981': 0xFFFFFFFF, '583985': 0xFFFFFFFF, '583991': 0xFFFFFFFF, '5bb1c4': 0xFFFF, '5bb1e2': 0xFFFFFFFF})

    # ---- raw 0x80
    for k, word in enumerate(BODIES80):
        for st in ((2, 0, 4), (3, 1, 2), (1, 3, 0))[k % 3]:
            obj = rand_obj(rng)
            obj['o4528'] = st
            if k % 4 == 0:
                obj['o6b2'] = 0x270F
            elif k % 4 == 1:
                obj['o6b2'] = rng.choice([0, 0x1111, 0xFFFF])
                obj['o6b4'] = rng.choice([0, 3])
            S('a80:word_%04x_state%d' % (word, st), [R(0x80, 1, struct.pack('<H', word), loaded=1), R(0x67)], AGAIN(), group='a80',
              cells=rand_cells(rng), obj=obj, quick=(k + st) % 2 == 0)
    for st in range(5):
        for b6b2, b6b4 in ((0x270F, 0), (0x270F, 9), (0x0042, 0), (0x0042, 9)):
            S('a80:state%d_6b2_%x_6b4_%d' % (st, b6b2, b6b4), [R(0x80, 1, struct.pack('<H', 0x189D))], [('tick',)], group='a80',
              cells=rand_cells(rng), obj=dict(rand_obj(rng), o4528=st, o6b2=b6b2, o6b4=b6b4), quick=st in (2, 3))

    # ---- mixed random scenarios
    for n in range(150):
        nrows = rng.randint(1, 8)
        rows = []
        for k in range(nrows):
            kind = rng.random()
            if kind < 0.18:     # a row the pass skips: unloaded or completed
                styp = rng.choice((0, 0x67, 0x20, 0x70, 0x80, 0x99))
                skip = R(styp, rng.randrange(256), rng.choice((None, False)) if styp in (0, 0x67, 0x70, 0x99) else None,
                         unloaded=rng.choice((0, 1, 1)), completed=rng.choice((0, 1)), loaded=rng.choice((0, 1, 7, 0xFFFFFFFF)),
                         phase=rng.randrange(0, 12), word=rng.getrandbits(16), request=rng.getrandbits(32))
                if not skip['unloaded']:
                    skip['completed'] = 1
                rows.append(skip)
                continue
            typ = rng.choice((0x20, 0x20, 0x20, 0x67, 0x67, 0x70, 0x80, 0x80))
            if typ == 0x20:
                body = body20(rng.choice(POOL32 + [rng.getrandbits(32)]), rng.choice(POOL32 + [rng.getrandbits(32)]))
            elif typ == 0x80:
                body = struct.pack('<H', rng.choice(BODIES80 + [rng.getrandbits(16)]))
            else:
                body = bytes([rng.getrandbits(8)])
            tail = event_tail(1000 + rng.randrange(8), rng.randrange(0, 3)) if rng.random() < 0.25 else b''
            nobody = typ in (0x67, 0x70) and rng.random() < 0.15
            rows.append(R(typ, rng.choice((0, 1, 1, 1, 2, 3, 4, 255)), False if nobody else body, tail,
                          loaded=rng.choice((0, 0, 1, 1, 1, 5, 0x80000000)), completed=1 if rng.random() < 0.1 else 0,
                          phase=rng.choice((0, 0, 0, 5, 9, 0xFFFFFFFF)), word=rng.getrandbits(16), request=rng.getrandbits(32)))
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
                acts.append(('set', rand_cells(rng, names=rng.sample([c for c in CELLS if c not in ('5c39e3', '583999')], 6))))
            if rng.random() < 0.3:
                acts.append(('set', rand_obj(rng)))
            if rng.random() < 0.4:
                acts.append(('events', {1000 + k: rng.randrange(0, 3) for k in range(8)}))
        S('random:%d' % n, rows, acts, group='random', cells=rand_cells(rng), obj=rand_obj(rng),
          events={1000 + k: rng.randrange(0, 3) for k in range(8)}, quick=n < 10, mode=rng.choice((3, 3, 3, 3, 3, 0, 1, 2, 4, 5)))
    return scs


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, compared_fields=0, rows_entered=Counter(), rows_visited=Counter(), rows_gated=Counter(),
                rows_erased=0, bodies_freed=0, trailing_recounts=0, passes_stopped_by_mode=0, native_refusal_checks=0, mismatches=0,
                known_divergences=Counter(), written_events=0, groups={})


def gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


class State:
    def __init__(self, sc, strict_known):
        self.sc = sc
        self.rows = [dict(r) for r in sc['rows']]
        self.strict_known = strict_known


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def run_scenario(x, nat, sc, stats, strict_known=False):
    t0 = time.monotonic()
    before = (stats['ticks'], sum(stats['rows_visited'].values()))
    try:
        run_scenario_inner(x, nat, sc, stats, strict_known)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += sum(stats['rows_visited'].values()) - before[1]
        g['seconds'] = round(g['seconds'] + time.monotonic() - t0, 2)


def sync_native(x, nat, st):
    """Copy the original's cells and object fields (and the row model) into the native handle."""
    for n in CELLS:
        nat.set(n, x.cell(n))
    for n in OBJ_FIELDS:
        nat.set(n, x.obj_field(n))
    for i, r in enumerate(st.rows):
        nat.set_row(i, r['loaded'], r['unloaded'], 0, 1 if r['body'] is not None else 0)


def run_scenario_inner(x, nat, sc, stats, strict_known):
    x.hard_reset()
    nat.reset()
    st = State(sc, strict_known)
    x.install_rows(st.rows)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    for n, v in sc['cells'].items():
        x.set_cell(n, v)
    for n, v in sc['obj'].items():
        x.set_obj_field(n, v)
    sync_native(x, nat, st)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, st, stats)
        elif kind == 'rearm':
            for i, r in enumerate(st.rows):
                if not r['erased'] and r['type'] in ARM:       # rows of other types stay completed (no arm is modelled for them)
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
        elif kind == 'set':
            for n, v in act[1].items():
                if n in OBJ_FIELDS:
                    x.set_obj_field(n, v)
                else:
                    x.set_cell(n, v)
                nat.set(n, v)
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def erased_pattern(r):
    r.update(type=0, body=None, completed=0, request=0, phase=0, word=0xFFFF, unloaded=1, loaded=0, erased=True)


def recount(rows, count):
    """0x43e8b8 over the rows below `count`: the start of the trailing run of unloaded rows, or None when there is none."""
    start, inrun = None, False
    for i in range(count):
        if rows[i]['unloaded']:
            if not inrun:
                inrun, start = True, i
        else:
            inrun, start = False, None
    return start


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    rows = st.rows
    pre_rows = [x.rd(ROWS + i * ROW, ROW) for i in range(len(rows))]
    pre_obj = x.rd(OBJ, OBJ_BYTES)
    pre_flag = x.cell('5bb1ca')
    nat.clear_logs()
    x.dispatch()
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    expected, entered, visited = [], [], []
    freed_exp, erased_exp, free_exp = [], [], []
    flag_set = False
    erased_seen = freed_seen = 0
    request_checks = []
    i = 0
    while True:
        count = s16(nat.get('5c39e3'))
        if i >= count or nat.get('583999') != 3:
            break
        r = rows[i]
        if r['completed'] or r['unloaded']:
            i += 1
            continue
        r['request'] = 0
        typ = r['type']
        entered.append((typ, i))
        expected.append(('entry', typ, i))
        if gate_open(r, flags):
            visited.append((typ, i))
            expected.append(('visit', typ, i))
            if typ == 0x67:
                r['completed'] = 1
                flag_set = True
                expected += [('c', '5bb1ca', 1), ('comp', i, 1)]
            elif typ == 0x20:
                visit_20(where, nat, r, i, count, rows, expected, freed_exp, erased_exp, free_exp, stats)
            elif typ == 0x70:
                visit_70(where, nat, r, i, expected, stats)
            elif typ == 0x80:
                visit_80(where, nat, r, i, expected, request_checks, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
            stats['rows_visited'][hex(typ)] += 1
        else:
            stats['rows_gated'][hex(typ)] += 1
        stats['rows_entered'][hex(typ)] += 1
        i += 1
    if i < s16(nat.get('5c39e3')) and nat.get('583999') != 3:
        stats['passes_stopped_by_mode'] += 1
    # ---- the observed event sequence of the original is the documented order, entry for entry
    check(stats, where, 'event sequence (arm entries, visits, cell stores in order, sound unload, completion stores)',
          x.events, expected)
    stats['written_events'] += len(x.events)
    check(stats, where, 'arm entries', [e[1:] for e in x.events if e[0] == 'entry'], entered)
    check(stats, where, 'visits (true gates)', [e[1:] for e in x.events if e[0] == 'visit'], visited)
    check(stats, where, 'method 0x4e386e rows', x.methods, [j for t, j in visited if t == 0x80])
    check(stats, where, 'sound unload calls', sum(1 for e in x.events if e[0] == 'sound'), sum(1 for t, _ in visited if t == 0x70))
    # 0x51dc6c: the erase frees the body (arena pointer), then 0x423b51 frees the row's dependency node (heap pointer)
    frees = ['body:%d' % ((p - d9.BODY_BASE) // BODY_STRIDE) if d9.BODY_BASE <= p < d9.BODY_BASE + 0x10000 else
             'node' if d9.HEAP_BASE <= p < d9.HEAP_BASE + d9.HEAP_SIZE else 'other:%#x' % p for p in x.frees]
    check(stats, where, 'freed pointers (0x51dc6c): bodies of the erased rows, then their dependency nodes', frees, free_exp)
    check(stats, where, 'dependency resets of erased rows (0x423b51)', x.erase_resets, erased_exp)
    check(stats, where, 'erase / recount call counts', (x.erase_calls, x.recount_calls),
          (sum(1 for t, _ in visited if t == 0x20),) * 2)
    check(stats, where, 'generic completion 0x42ba3a / dependency reset 0x423d33', (x.finish_entries, x.resets), ([], []))
    unexpected = {k: v for k, v in x.other_writes.items() if k not in EXPECTED_OTHER_WRITES}
    if unexpected:
        raise Mismatch('%s: the original wrote outside the modelled cells: %r' % (where, dict(list(unexpected.items())[:8])))
    # ---- cells and object fields, original against native
    for n in CELLS:
        check(stats, where, 'cell ' + n, x.cell(n), nat.get(n))
    check(stats, where, 'cell 5bb1ca (0x67 start flag)', x.cell('5bb1ca'), 1 if flag_set else pre_flag)
    for n in OBJ_FIELDS:
        check(stats, where, 'object field ' + n, x.obj_field(n), nat.get(n))
    post_obj = x.rd(OBJ, OBJ_BYTES)
    allowed = set()
    for off, size in OBJ_FIELDS.values():
        allowed.update(range(off, off + size))
    touched = [k for k in range(OBJ_BYTES) if pre_obj[k] != post_obj[k] and k not in allowed]
    check(stats, where, 'object bytes changed outside the listed fields', touched, [])
    # ---- the scene-change request of every 0x80 visit
    for _ in request_checks:
        req = nat.request()
        o = lambda n: x.cell(n)  # noqa: E731
        exp = [s16(o('5bb57b')), s16(o('5bb599')), s16(o('5bb595')), s16(o('5c39ff')), sgn(o('5bb59b'), 4), sgn(o('5bb59f'), 4), sgn(o('5bb5a3'), 4)]
        check(stats, where, 'scene-change request (target, 3 words, 3 dwords)', req, exp)
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
            raise Mismatch('%s: row %d bytes differ at offsets %s: original %s model %s (erased=%s)' % (
                where, i, [hex(k) for k in bad[:6]], [hex(post[k]) for k in bad[:6]], [hex(exp_img[k]) for k in bad[:6]], r['erased']))
        stats['compared_fields'] += 1
        check(stats, where, 'row %d native model (loaded, unloaded, retired, has_body)' % i, nat.row(i),
              (r['loaded'], r['unloaded'], 1 if r['erased'] else 0, 1 if r['body'] is not None else 0))


def visit_20(where, nat, r, i, count, rows, expected, freed_exp, erased_exp, free_exp, stats):
    body = r['body']
    d0, d4 = struct.unpack('<II', body)
    # the independent expectation of the erase and the recount (0x43e96c / 0x43e8b8)
    erased = [j for j in range(count) if rows[j]['loaded'] != 0]
    unl = [rows[j]['unloaded'] or (j in erased) for j in range(count)]
    start, inrun = None, False
    for j in range(count):
        if unl[j]:
            if not inrun:
                inrun, start = True, j
        else:
            inrun, start = False, None
    pre_57f = nat.get('5bb57f')
    e0, f0 = len(nat.log(0)), len(nat.log(1))
    status, done, reset, phase, disp = nat.visit(0x20, i, r['subtype'], body + r['tail'], r['completed'], r['phase'])
    if status != 0 or disp != 3:
        raise Mismatch('%s: native 0x20 handler status %d disposition %d for row %d (%s)' % (
            where, status, disp, i, nat.lib.a2o_failure(nat.h, 0x20)))
    check(stats, where, 'native 0x20 completion / reset of row %d' % i, (done, reset), (1, 0))
    freed = [j for j in erased if rows[j]['body'] is not None]
    check(stats, where, 'erased row set of the native host', nat.log(0)[e0:], erased)
    check(stats, where, 'rows whose body the native host freed', nat.log(1)[f0:], freed)
    check(stats, where, 'native rows_erased outcome', nat.info(4), len(erased))
    erased_exp.extend(erased)
    freed_exp.extend(freed)
    for j in erased:
        if rows[j]['body'] is not None:
            free_exp.append('body:%d' % j)
        if rows[j]['tail']:
            free_exp.append('node')
    for j in erased:
        erased_pattern(rows[j])
    if i in erased:
        check(stats, where, 'native phase of the erased 0x20 row %d' % i, phase, 0)
    else:
        rows[i]['completed'] = 1
        if phase != r['phase']:
            stats['known_divergences']['0x20 row not erased (loaded dword 0): original keeps its phase, native binding returns 0'] += 1
    expected += [('c', '63aa10', d0), ('c', '55cd94', d4), ('comp', i, 1)] + [('comp', j, 0) for j in erased]
    if start is not None:
        expected.append(('c', '5c39e3', start))
        stats['trailing_recounts'] += 1
    expected += [('c', '5bb57b', pre_57f), ('c', '5c3a4f', pre_57f & 0xFFFF)]
    stats['rows_erased'] += len(erased)
    stats['bodies_freed'] += len(freed)


def visit_70(where, nat, r, i, expected, stats):
    pre = [nat.get(n) for n in SOUND_CELLS]
    status, done, reset, phase, disp = nat.visit(0x70, i, r['subtype'], (r['body'] if r['body'] is not None else b'\0') + r['tail'], r['completed'], r['phase'])
    if status != 0 or disp != 3:
        raise Mismatch('%s: native 0x70 handler status %d disposition %d (%s)' % (where, status, disp, nat.lib.a2o_failure(nat.h, 0x70)))
    check(stats, where, 'native 0x70 completion / reset / phase', (done, reset, phase), (1, 0, r['phase']))
    check(stats, where, 'sound unload calls (native)', nat.info(0), 1)
    check(stats, where, 'world the native kernel had when it unloaded the sound', nat.snap70(), pre)
    r['completed'] = 1
    expected += [('sound', tuple(pre)), ('c', '583985', 6), ('c', '583981', 5), ('c', '583991', 0), ('c', '5bb1c4', 1), ('c', '583999', 0),
                 ('c', '5bb1e2', 0), ('comp', i, 1)]


def visit_80(where, nat, r, i, expected, request_checks, stats):
    word = struct.unpack('<H', r['body'][:2])[0]
    pre = {n: nat.get(n) for n in OBJ_FIELDS}
    status, done, reset, phase, disp = nat.visit(0x80, i, r['subtype'], r['body'] + r['tail'], r['completed'], r['phase'])
    if status != 0 or disp != 3:
        raise Mismatch('%s: native 0x80 handler status %d disposition %d (%s)' % (where, status, disp, nat.lib.a2o_failure(nat.h, 0x80)))
    check(stats, where, 'native 0x80 completion / reset / phase', (done, reset, phase), (1, 0, r['phase']))
    check(stats, where, 'native transition requests / object loads', (nat.info(1), nat.info(3)), (1, 1))
    check(stats, where, 'object loader told "use the stored scene"', nat.info(2), 1 if word == 0x270F else 0)
    request_checks.append(i)
    r['completed'] = 1
    ev = []
    if word != 0x270F:
        ev += [('c', '5bb57b', sgn(word, 2) & mask(4)), ('c', '5bb57f', sgn(word, 2) & mask(4)), ('c', '5bb599', 0), ('c', '5bb595', 0),
               ('c', '5bb59b', 0), ('c', '5bb59f', 0), ('c', '5bb5a3', 1), ('c', '5c39ff', 1)]
    else:
        ev += [('c', '5bb57b', sgn(pre['o6ba'], 2) & mask(4)), ('c', '5bb57f', sgn(pre['o6ba'], 2) & mask(4))]
    ev += [('c', '5bb599', pre['o6bc']), ('c', '5bb595', pre['o6be']), ('c', '5bb59b', pre['o6c2']), ('c', '5bb59f', pre['o6c6']),
           ('c', '5bb5a3', pre['o6ca']), ('c', '5c39ff', 1), ('c', '583999', 4)]
    if sgn(pre['o4528'], 4) in (2, 3):
        ev += [('c', '583204', 5), ('c', '5bb22a', 0), ('o', 'o4530', 0)]
        if sgn(pre['o6b2'], 2) != 0x270F:
            ev.append(('o', 'o6b2', 0x270F))
            if pre['o6b4'] != 0:
                ev += [('o', 'o65d2', 1), ('o', 'o6b4', 0)]
    expected += ev + [('comp', i, 1)]


def run_list(x, nat, scs, stats, fail_fast=False, strict_known=False):
    bad = []
    for sc in scs:
        try:
            before = Counter(stats['known_divergences'])
            run_scenario(x, nat, sc, stats, strict_known)
            if strict_known and stats['known_divergences'] != before:
                raise Mismatch('known divergence under --strict-known: %r' % (set(stats['known_divergences']) - set(before)))
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


def refusal_checks(nat, stats):
    """Host refusals (native only): every refused visit is a non-OK status and changes neither the cells nor the row model."""
    rng = random.Random(0x20)
    cases = ((0x20, 1, body20(1, 2)), (0x20, 2, body20(1, 2)), (0x70, 4, b'\0'), (0x70, 32, b'\0'), (0x80, 8, b'\x42\0'), (0x80, 16, b'\x42\0'),
             (0x80, 64, b'\x0f\x27'), (0x70, 0, b'\0'))
    for typ, fail, raw in cases:
        nat.reset()
        for n in CELLS:
            nat.set(n, rng.getrandbits(32))
        nat.set('5c39e3', 3)
        for n in OBJ_FIELDS:
            nat.set(n, rng.getrandbits(32))
        for j in range(3):
            nat.set_row(j, 1, 0, 0, 1)
        snap = ({n: nat.get(n) for n in SIZES}, [nat.row(j) for j in range(3)])
        nat.set_fail(fail)
        status, done, reset, phase, disp = nat.visit(typ, 1, 1, raw, 0, 5)
        after = ({n: nat.get(n) for n in SIZES}, [nat.row(j) for j in range(3)])
        stats['native_refusal_checks'] += 1
        if fail and status == 0:
            raise Mismatch('refusal %#x/%d: the handler returned OK' % (typ, fail))
        if not fail and status != 0:
            raise Mismatch('refusal control %#x: status %d' % (typ, status))
        if fail and (snap != after or (done, phase) != (0, 5)):
            raise Mismatch('refusal %#x/%d changed the host cells or rows (status %d)' % (typ, fail, status))
    nat.set_fail(0)


# native mutants: each must be caught by the quick scenario set
K20, K70, K80 = 'action_family_20_runtime.c', 'action_family_70_runtime.c', 'action_family_80_runtime.c'
B = 'session_bindings_a20_a70_a80.c'
VIEW0 = 'world->view_cell_63aa10 = (int32_t)decoded->dword_0;'
VIEW4 = 'world->view_cell_55cd94 = (int32_t)decoded->dword_4;'
MUTANTS = {
    # ---- raw 0x20
    'a20 view cells swapped': (K20, [(VIEW0, VIEW0.replace('dword_0', 'dword_4')), (VIEW4, VIEW4.replace('dword_4', 'dword_0'))]),
    'a20 second view cell from dword 0': (K20, [(VIEW4, VIEW4.replace('dword_4', 'dword_0'))]),
    'a20 copy direction of 5bb57b/5bb57f reversed': (K20, [('world->scene_5bb57b = world->scene_5bb57f;', 'world->scene_5bb57f = world->scene_5bb57b;')]),
    'a20 copy only the low half': (K20, [('world->scene_5bb57b = world->scene_5bb57f;',
                                          'world->scene_5bb57b = (world->scene_5bb57b & ~0xffff) | (world->scene_5bb57f & 0xffff);')]),
    'a20 word 5c3a4f from the high half': (K20, [('(uint32_t)world->scene_5bb57b & 0xffffu', '(uint32_t)world->scene_5bb57b >> 16')]),
    'a20 word 5c3a4f not stored': (K20, [('world->word_5c3a4f = (int16_t)(uint16_t)((uint32_t)world->scene_5bb57b & 0xffffu);', '(void)0;')]),
    'a20 erase skipped': (K20, [('if (host->erase_rows(host->context, &erased) != 0) {', 'if (erased != 0u) {')]),
    'a20 rows_erased reported wrong': (K20, [('out->rows_erased = erased;', 'out->rows_erased = erased + 1u;')]),
    'a20 phase kept instead of 0': (B, [('out->phase = 0u;', 'out->phase = before->phase;')]),
    'a20 generic completion instead of direct': (B, [('0x43ea29: the erase clears the phase dword */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                                                     '0x43ea29: the erase clears the phase dword */\n    out->disposition = SCENE_ACTION_HANDLER_COMPLETED;')]),
    'a20 row left pending': (B, [('0x43ea29: the erase clears the phase dword */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                                  '0x43ea29: the erase clears the phase dword */\n    out->disposition = SCENE_ACTION_HANDLER_PENDING;')]),
    'a20 world not stored': (B, [('b->last = outcome;\n    ++b->visits;\n    if (b->host.store_world != NULL) {', 'b->last = outcome;\n    ++b->visits;\n    if (0) {')]),
    'a20 decoder second dword from offset 3': ('action_family_20.c', [('d->dword_4 = read_le32(raw + 4);', 'd->dword_4 = read_le32(raw + 3);')]),
    # ---- raw 0x70
    'a70 states swapped (5/6)': (K70, [('world->next_state_583985 = 6;', 'world->next_state_583985 = 5;'),
                                       ('world->outer_state_583981 = 5;', 'world->outer_state_583981 = 6;')]),
    'a70 next state 7': (K70, [('world->next_state_583985 = 6;', 'world->next_state_583985 = 7;')]),
    'a70 outer state 4': (K70, [('world->outer_state_583981 = 5;', 'world->outer_state_583981 = 4;')]),
    'a70 mode not 0': (K70, [('world->engine_mode_583999 = 0;', 'world->engine_mode_583999 = 3;')]),
    'a70 5bb1c4 not 1': (K70, [('world->first_render_5bb1c4 = 1;', 'world->first_render_5bb1c4 = 0;')]),
    'a70 5bb1e2 not cleared': (K70, [('world->cell_5bb1e2 = 0;', '(void)0;')]),
    'a70 583991 not cleared': (K70, [('world->cell_583991 = 0;', '(void)0;')]),
    'a70 sound unload after the writes': (K70, [('    if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429220 */\n        return ACTION_FAMILY_70_RUNTIME_ERR_HOST;\n    }\n', ''),
                                                ('    world->cell_5bb1e2 = 0;', '    world->cell_5bb1e2 = 0;\n    if (host->unload_scene_sound(host->context) != 0) return ACTION_FAMILY_70_RUNTIME_ERR_HOST;\n')]),
    'a70 sound unload skipped': (K70, [('if (host->unload_scene_sound(host->context) != 0) {', 'if (0) {')]),
    'a70 sound unload twice': (K70, [('if (host->unload_scene_sound(host->context) != 0) {', 'host->unload_scene_sound(host->context);\n    if (host->unload_scene_sound(host->context) != 0) {')]),
    'a70 phase cleared': (B, [('out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269',
                               'out->phase = 0u;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269')]),
    'a70 generic completion': (B, [('SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', 'SCENE_ACTION_HANDLER_COMPLETED;   /* 0x429269')]),
    'a70 row left pending': (B, [('SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269', 'SCENE_ACTION_HANDLER_PENDING;   /* 0x429269')]),
    'a70 world not stored': (B, [('++b->visits;\n    if (b->host.store_world != NULL) {\n        b->host.store_world(b->host.context, &world);\n    }\n    out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269',
                                 '++b->visits;\n    out->phase = before->phase;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269')]),
    # ---- raw 0x80
    'a80 scene word read unsigned': (K80, [('word = (int32_t)(int16_t)decoded->word_0;', 'word = (int32_t)(uint16_t)decoded->word_0;')]),
    'a80 9999 compare on 15 bits': (K80, [('if (word != ACTION_FAMILY_80_SCENE_NONE) {', 'if ((word & 0x7fff) != ACTION_FAMILY_80_SCENE_NONE) {')]),
    'a80 9999 compare inverted': (K80, [('if (word != ACTION_FAMILY_80_SCENE_NONE) {', 'if (word == ACTION_FAMILY_80_SCENE_NONE) {')]),
    'a80 tuple words 6bc/6be swapped': (K80, [('world->word_5bb599 = object->word_6bc;', 'world->word_5bb599 = object->word_6be;'),
                                              ('world->word_5bb595 = object->word_6be;', 'world->word_5bb595 = object->word_6bc;')]),
    'a80 tuple dwords 6c2/6c6 swapped': (K80, [('world->dword_5bb59b = object->dword_6c2;', 'world->dword_5bb59b = object->dword_6c6;'),
                                               ('world->dword_5bb59f = object->dword_6c6;', 'world->dword_5bb59f = object->dword_6c2;')]),
    'a80 engine mode 3': ('action_family_80_runtime.h', [('#define ACTION_FAMILY_80_MODE_SCENE_CHANGE 4', '#define ACTION_FAMILY_80_MODE_SCENE_CHANGE 3')]),
    'a80 state test 2 or 4': (K80, [('object->state_4528 == 3', 'object->state_4528 == 4')]),
    'a80 state test 1 or 3': (K80, [('object->state_4528 == 2', 'object->state_4528 == 1')]),
    'a80 state test only 2': (K80, [('if (object->state_4528 == 2 || object->state_4528 == 3) {', 'if (object->state_4528 == 2) {')]),
    'a80 6b2 branch inverted': (K80, [('if ((int32_t)object->word_6b2 != ACTION_FAMILY_80_SCENE_NONE) {', 'if ((int32_t)object->word_6b2 == ACTION_FAMILY_80_SCENE_NONE) {')]),
    'a80 6b2 not rewritten': (K80, [('object->word_6b2 = (int16_t)ACTION_FAMILY_80_SCENE_NONE;', '(void)0;')]),
    'a80 65d2 store skipped': (K80, [('object->dword_65d2 = 1;', '(void)0;')]),
    'a80 6b4 not cleared': (K80, [('object->dword_6b4 = 0;', '(void)0;')]),
    'a80 4530 not cleared': (K80, [('object->dword_4530 = 0;', '(void)0;')]),
    'a80 583204 value 4': (K80, [('world->cell_583204 = 5;', 'world->cell_583204 = 4;')]),
    'a80 5bb22a not cleared': (K80, [('world->cell_5bb22a = 0;', '(void)0;')]),
    'a80 5c39ff final value 0': (K80, [('world->dword_5bb5a3 = object->dword_6ca;\n    world->word_5c39ff = 1;', 'world->dword_5bb5a3 = object->dword_6ca;\n    world->word_5c39ff = 0;')]),
    'a80 stored scene zero-extended': (K80, [('world->scene_5bb57b = (int32_t)object->scene_6ba;', 'world->scene_5bb57b = (int32_t)(uint16_t)object->scene_6ba;')]),
    'a80 5bb57f not set for a literal scene': (K80, [('world->scene_5bb57f = word;', '(void)0;')]),
    'a80 literal tuple zeroing kept after the object tuple': (K80, [('world->word_5bb599 = object->word_6bc;', 'if (word == ACTION_FAMILY_80_SCENE_NONE) world->word_5bb599 = object->word_6bc;')]),
    'a80 request words swapped': (B, [('request.opaque_words[0] = world.word_5bb599;', 'request.opaque_words[0] = world.word_5bb595;'),
                                      ('request.opaque_words[1] = world.word_5bb595;', 'request.opaque_words[1] = world.word_5bb599;')]),
    'a80 request target from the wrong cell': (B, [('request.target_scene = (int16_t)world.scene_5bb57b;', 'request.target_scene = (int16_t)world.word_5c39ff;')]),
    'a80 request dword 2 from dword 1': (B, [('request.opaque_dwords[2] = world.dword_5bb5a3;', 'request.opaque_dwords[2] = world.dword_5bb59f;')]),
    'a80 stored-scene flag inverted': (B, [('(int16_t)decoded.word_0 == ACTION_FAMILY_80_SCENE_NONE', '(int16_t)decoded.word_0 != ACTION_FAMILY_80_SCENE_NONE')]),
    'a80 generic completion': (B, [('SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e', 'SCENE_ACTION_HANDLER_COMPLETED;   /* 0x42964e')]),
    'a80 phase cleared': (B, [('out->phase = before->phase;                                  /* the phase word is not written */\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e',
                               'out->phase = 0u;\n    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e')]),
    'a80 object not stored': (B, [('if (b->host.store_object != NULL) {', 'if (0) {')]),
    'a80 decoder word high byte shift 7': ('action_family_80.c', [('((uint16_t)raw[1] << 8)', '((uint16_t)raw[1] << 7)')]),
}


def mutation_check(args, workdir):
    report = []
    for name, (filename, edits) in MUTANTS.items():
        source = (args.src / filename).read_text()
        bad_anchor = [old[:50] for old, _ in edits if source.count(old) != 1]
        if bad_anchor:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted: %r' % bad_anchor))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        for old, new in edits:
            source = source.replace(old, new)
        (d / filename).write_text(source)
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)), strict=False)
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
    ap.add_argument('--strict-known', action='store_true', help='fail on the recorded original/native differences too')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-48.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver2x.so')
    nat = Native(lib_path)
    x = Oracle()
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only or args.mutation_run:
        scs = [s for s in scs if s['quick']]
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast or args.mutation_run, strict_known=args.strict_known)
    if not args.only:
        try:
            refusal_checks(nat, stats)
        except Mismatch as error:
            bad.append(('refusal', str(error)))
            stats['mismatches'] += 1
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
        print('MISMATCH', sid, '::', msg[:600])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = 6
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
        summary['mutants_total'] = len(mutations)
        summary['mutants_killed'] = sum(1 for m in mutations if m['detected'])
    summary['seconds'] = round(time.monotonic() - started, 1)
    print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-48', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=summary['seconds']), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
