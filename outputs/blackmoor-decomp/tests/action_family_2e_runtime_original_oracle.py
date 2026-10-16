#!/usr/bin/env python3
"""RT-33: immutable x86 dispatcher 0x427a50 (arm 0x427f62) and handler 0x4ced84 versus the native raw-0x2e runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x2e the REAL dispatcher 0x427a50 runs:
dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm (push 0 / gate / for a true gate
`ecx = 0x63821d; call 0x4ced84(row)`), and the handler itself with the random-movie object at 0x63821d in a scenario-chosen
state. All of it is original x86.

Native side: src/session_bindings_a2e.c (the executor's handler contract) with a host that stores the event flags, the start
flag and the scene-change request, driven by tests/action_family_2e_runtime_oracle_driver.c with the executor's disposition
mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm (observed 0x427f62) and which reached the handler (observed 0x4ced84) against the open-row
   model and a gate model (event flag dependency records, which the handler itself changes within the tick, and the world
   mode word);
 * every store the handler makes to the movie object (+0x1de, +0x206, +0x23a, +0x242, +0x25a), to the event flag table, to
   the start flag 0x5bb1ca, to the scene-change cells (0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3)
   and the engine mode 0x583999, and to a row's completion byte, as an ORDERED list against the effects the native binding
   reports; any other store into the object (+0..+0x300), the row table or those cells fails the run;
 * the object fields, the whole event flag table and the completion byte and phase dword of every row after the tick, and
   that neither the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran;
 * the active mode-0 path, which the native binding refuses (UNSUPPORTED before any effect): the original must reach 0x4ceb3b
   (the random-movie stop, which this oracle does not run) at exactly the row where the native binding refused, and the two
   stores it made before (row and mode) are the only difference.

HOOKS (everything else is original code): O = observed.
  O 0x427f62 arm entry and 0x4ced84 handler entry (the row is the signed word at [ebp-0x11c] / [esp+4]; ECX is checked),
    0x42ba3a completion helper, 0x423d33 dependency reset: entry observers, they only read memory
  O memory writes into the ranges listed above
  S 0x4ceb3b: stops the run when a scenario expects the active mode-0 path (anywhere else it fails the run)
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the 15-byte body (the oracle builds the row in memory; the
native decoder and the 10 corpus rows are checked against the decoded scene resources separately), the 10 corpus rows'
dependency records (2 carry one; replayed without them and behind a stand-in event record, the gate is shared verified code),
the random-movie stop 0x4ceb3b and everything raw 0x2d (0x4cd6ff) does to the object, every other reader of the object (frame
steps 0x4383ed and 0x4394fb), and the readers of the cells the handler writes.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_2e_runtime_original_oracle.py --mutations --result <receipt.json>
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

ARM_ENTRY = 0x427F62
HANDLER = 0x4CED84
STOP = 0x4CEB3B
OBJ = 0x63821D
START_FLAG_VA = 0x5BB1CA
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
EVENTS = 1600
MAX_ROWS = 90

# effect ids shared with src/session_bindings_a2e.h
FX_ROW, FX_MODE, FX_EVENT_FLAG, FX_EVENT_VALUE = 1, 2, 3, 4
FX_X57B, FX_X599, FX_X595, FX_XFF, FX_X59B, FX_X59F, FX_X5A3, FX_ENGINE, FX_START = 5, 6, 7, 8, 9, 10, 11, 12, 13
FX_1DE, FX_206, FX_25A, FX_DONE = 14, 15, 16, 17
MOVIE_FX = {0x242: FX_ROW, 0x23A: FX_MODE, 0x1DE: FX_1DE, 0x206: FX_206, 0x25A: FX_25A}
GLOBAL_FX = {0x5BB57B: (FX_X57B, 4), 0x5BB599: (FX_X599, 2), 0x5BB595: (FX_X595, 2), 0x5C39FF: (FX_XFF, 2),
             0x5BB59B: (FX_X59B, 4), 0x5BB59F: (FX_X59F, 4), 0x5BB5A3: (FX_X5A3, 4), 0x583999: (FX_ENGINE, 4),
             START_FLAG_VA: (FX_START, 4)}
FIELD_OFFSETS = (0x216, 0x23A, 0x242, 0x1DE, 0x206, 0x25A)  # active, mode, row, 1de, 206, 25a (the driver's order)

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
    (0x4ceb3b, 0x4ceb8c, '61578011ce5d01057cb728224926c06f146d69407b1def650e38302be816810d'),
    (0x4ced84, 0x4cf026, '2a0c3ff70a2cb090b0663c15f75de9852ecbcf5afbefc4baadc0d87bd20cedef'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


def _s(value, size):
    value &= (1 << (8 * size)) - 1
    return value - (1 << (8 * size)) if value >> (8 * size - 1) else value


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x2e observers."""

    def __init__(self):
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))
        self.entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.events = []
        self.stray = []
        self.prologue = []
        self.gate_writes = 0
        self.stop_expected = False
        self.stopped = False

    def _row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {ARM_ENTRY: self._entry, HANDLER: self._handler, 0x423D33: self._reset_seen, 0x42BA3A: self._finish,
                 STOP: self._stop}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        for lo, hi in ((OBJ, OBJ + 0x300), (EVENTS_VA, EVENTS_VA + 4 * EVENTS), (0x5BB595, 0x5BB5A7), (0x5BB57B, 0x5BB57E),
                       (0x5C39FF, 0x5C3A00), (0x583999, 0x58399C), (START_FLAG_VA, START_FLAG_VA + 3),
                       (ROWS, ROWS + MAX_ROWS * ROW - 1)):
            uc.hook_add(UC_HOOK_MEM_WRITE, self._write, begin=lo, end=hi)

    def _entry(self, uc, address, size, user):
        self.entries.append(self._row_at_arm(uc))

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise d9.OracleError('handler entered with ECX != 0x63821d')
        self.handler_rows.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _stop(self, uc, address, size, user):
        if not self.stop_expected:
            raise d9.OracleError('the random-movie stop 0x4ceb3b ran where the scenario did not expect it')
        self.stopped = True
        raise d9.Fatal(address)

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _write(self, uc, access, address, size, value, user):
        if self.mode != 'step':
            return
        if OBJ <= address < OBJ + 0x300:
            off = address - OBJ
            if off in MOVIE_FX and size == 4:
                self.events.append((MOVIE_FX[off], _s(value, 4), 0))
            else:
                self.stray.append(('object', off, size, value))
        elif EVENTS_VA <= address < EVENTS_VA + 4 * EVENTS and (address - EVENTS_VA) % 4 == 0 and size == 4:
            self.events.append((FX_EVENT_FLAG, (address - EVENTS_VA) // 4, 0))
            self.events.append((FX_EVENT_VALUE, _s(value, 4), 0))
        elif address in GLOBAL_FX and GLOBAL_FX[address][1] == size:
            self.events.append((GLOBAL_FX[address][0], _s(value, size), 0))
        elif ROWS <= address < ROWS + MAX_ROWS * ROW:
            row, off = divmod(address - ROWS, ROW)
            if off == COMPLETE_OFF and size == 1:
                self.events.append((FX_DONE, value & 0xFF, row))
            elif off == 0x43 + 0x30 and size == 4 and value == 0:  # dispatcher prologue: request dword := 0 (0x5bb626)
                self.prologue.append(row)
            elif 0x4234C8 <= uc.reg_read(X.UC_X86_REG_EIP) < 0x424AA8 and 0x36 <= off < COMPLETE_OFF:
                self.gate_writes += 1  # the dependency evaluator's own bookkeeping in the row's dependency root (shared code)
            else:
                self.stray.append(('row', row, off, value))
        else:
            self.stray.append(('other', address, size, value))

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
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.events, self.stray, self.prologue = [], [], []
        self.stop_expected = self.stopped = False
        self.wr(EVENTS_VA, bytes(4 * EVENTS))

    def movie(self):
        return [_s(struct.unpack('<I', self.rd(OBJ + off, 4))[0], 4) for off in FIELD_OFFSETS]

    def set_movie(self, fields, filler=None):
        if filler is not None:  # the unmodelled bytes of the object: anything, they must survive
            self.wr(OBJ, filler)
        for off, v in zip(FIELD_OFFSETS, fields):
            self.w32(OBJ + off, v)

    def object_bytes(self):
        return self.rd(OBJ, 0x300)

    def event(self, index):
        return _s(struct.unpack('<I', self.rd(EVENTS_VA + 4 * index, 4))[0], 4)

    def events_table(self):
        return struct.unpack('<%di' % EVENTS, self.rd(EVENTS_VA, 4 * EVENTS))

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
            body_at = d9.BODY_BASE + 0x40 * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([0x2E, spec['subtype']]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def dispatch(self):
        self.entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.events, self.stray, self.prologue = [], [], []
        self.stopped = False
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        except d9.Fatal as error:
            if not (self.stop_expected and error.address == STOP):
                raise
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_2e_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a2e.c', 'action_family_2e.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A2E_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a2eo_new.restype = C.c_void_p
        lib.a2eo_free.argtypes = [C.c_void_p]
        lib.a2eo_set_start_flag.argtypes = [C.c_void_p, C.c_int32]
        lib.a2eo_get_start_flag.argtypes = [C.c_void_p]
        lib.a2eo_get_start_flag.restype = C.c_int32
        for name in ('a2eo_start_sets', 'a2eo_transitions'):
            getattr(lib, name).argtypes = [C.c_void_p]
            getattr(lib, name).restype = C.c_ulong
        lib.a2eo_set_event.argtypes = [C.c_void_p, C.c_int, C.c_int32]
        lib.a2eo_get_event.argtypes = [C.c_void_p, C.c_int]
        lib.a2eo_get_event.restype = C.c_int32
        lib.a2eo_clear_events.argtypes = [C.c_void_p]
        lib.a2eo_last_request.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a2eo_set_movie.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a2eo_get_movie.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a2eo_fx_count.argtypes = [C.c_void_p]
        lib.a2eo_fx_count.restype = C.c_uint
        lib.a2eo_fx_get.argtypes = [C.c_void_p, C.c_uint, C.POINTER(C.c_int32), C.POINTER(C.c_int32), C.POINTER(C.c_int32)]
        lib.a2eo_fx_get.restype = C.c_int
        lib.a2eo_fx_clear.argtypes = [C.c_void_p]
        lib.a2eo_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_char_p, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a2eo_visit.restype = C.c_int
        self.h = lib.a2eo_new()

    def close(self):
        self.lib.a2eo_free(self.h)

    def start_sets(self):
        return self.lib.a2eo_start_sets(self.h)

    def transitions(self):
        return self.lib.a2eo_transitions(self.h)

    def last_request(self):
        arr = (C.c_int32 * 7)()
        self.lib.a2eo_last_request(self.h, arr)
        return list(arr)

    def set_start_flag(self, v):
        self.lib.a2eo_set_start_flag(self.h, _s(v, 4))

    def start_flag(self):
        return self.lib.a2eo_get_start_flag(self.h)

    def reset_events(self):
        self.lib.a2eo_clear_events(self.h)

    def set_event(self, i, v):
        self.lib.a2eo_set_event(self.h, i, _s(v, 4))

    def event(self, i):
        return self.lib.a2eo_get_event(self.h, i)

    def events_table(self):
        return tuple(self.event(i) for i in range(EVENTS))

    def set_movie(self, fields):
        arr = (C.c_int32 * 6)(*[_s(f, 4) for f in fields])
        self.lib.a2eo_set_movie(self.h, arr)

    def movie(self):
        arr = (C.c_int32 * 6)()
        self.lib.a2eo_get_movie(self.h, arr)
        return list(arr)

    def take_fx(self):
        out = []
        for i in range(self.lib.a2eo_fx_count(self.h)):
            e, v, r = C.c_int32(), C.c_int32(), C.c_int32()
            self.lib.a2eo_fx_get(self.h, i, C.byref(e), C.byref(v), C.byref(r))
            out.append((e.value, v.value, r.value if e.value == FX_DONE else 0))
        self.lib.a2eo_fx_clear(self.h)
        return out

    def visit(self, row, subtype, body, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a2eo_visit(self.h, row, subtype, bytes(body), completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
INACTIVE = [0, 0, 0, 0, 0, 0]
OBJ_FILLER = bytes((i * 37 + 11) & 0xFF for i in range(0x300))


def body(mode=2, scene=0x270F, w3=0, w5=0, w7=0, flag=-1, value=0, startw=0):
    return struct.pack('<Bhhhhhhh', mode & 0xFF, scene, w3, w5, w7, flag, value, startw)


def R(subtype=1, tail=b'', b=None):
    return dict(body=b if b is not None else body(), subtype=subtype, tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def active_movie(rng=None, **kw):
    f = dict(active=1, mode=0x55AA, row=0x1234, s1de=7, f206=9, p25a=0)
    f.update(kw)
    return [f['active'], f['mode'], f['row'], f['s1de'], f['f206'], f['p25a']]


def rand16(rng):
    return rng.choice((0, 1, -1, 2, 0x7FFF, -0x8000, 0x270F, 0x2710, 0x270E, 1599, 1600, rng.randrange(-0x8000, 0x8000)))


def rand_body(rng, mode=None, flag_ok=True):
    flag = rng.choice((-1, 0, 1, 1599, 800, rng.randrange(EVENTS), rng.randrange(EVENTS))) if flag_ok else rand16(rng)
    return body(rng.choice((0, 1, 2)) if mode is None else mode, rng.choice((0x270F, 0x270F, -1, 0, rand16(rng))), rand16(rng),
                rand16(rng), rand16(rng), flag, rand16(rng), rng.choice((1, 1, 0, -1, 2, rand16(rng))))


MOVIE_SETS = (active_movie(), active_movie(active=2), active_movie(active=0x100), active_movie(active=-1),
              active_movie(active=0x80000000, p25a=1), active_movie(p25a=1), active_movie(p25a=-1, s1de=0, f206=0),
              active_movie(p25a=0x7FFFFFFF, s1de=-1, f206=-1))


def scenario_list(seed=33, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, movie=kw.pop('movie', list(INACTIVE)),
                        events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0),
                        start=kw.pop('start', 0), stop=kw.pop('stop', False)))

    if corpus:
        for st, b in corpus:
            m0 = (b[0] & 0x80 and b[0] - 256) or b[0]
            S('corpus_inactive:%s' % b.hex(), [R(st, b'', b)], group='corpus', quick=b[0] == 2)
            for k, mv in enumerate(MOVIE_SETS):
                S('corpus_active:%s:%d' % (b.hex(), k), [R(st, b'', b)], [('start', 5 if k & 1 else 0), ('tick',)], group='corpus',
                  movie=list(mv), stop=m0 == 0 and mv[0] != 0, quick=k == 0 and b[0] != 1 or k == 5)
        # all corpus rows in one scene, in order, with the object active (the first mode-0 row stops the pass)
        rows = [R(st, b'', b) for st, b in corpus]
        S('corpus_all_inactive', rows, [('tick',)], group='corpus')
        S('corpus_all_active', rows, [('tick',)], group='corpus', movie=active_movie(), stop=any(b[0] == 0 for _, b in corpus))
        sans0 = [R(st, b'', b) for st, b in corpus if b[0] != 0]
        S('corpus_active_without_mode0', sans0, [('tick',), ('rearm',), ('tick',)], group='corpus', movie=active_movie())
    for mode in range(256):
        S('inactive:mode%d' % mode, [R(1, b'', rand_body(rng, mode))], [('tick',)], group='inactive', movie=[0, 0x7777, 9, 4, 5, 6],
          quick=mode in (0, 1, 2, 3, 127, 128, 255))
    for mode in (3, 4, 100, 127, 128, 200, 254, 255):
        S('active:other_mode%d' % mode, [R(1, b'', rand_body(rng, mode))], [('tick',)], group='active', movie=active_movie(),
          quick=mode in (3, 128, 255))
    for k, mv in enumerate(MOVIE_SETS):
        S('active:mode2:%d' % k, [R(1, b'', body(2)), R(1, b'', body(2))], [('tick',), ('rearm',), ('tick',)], group='active',
          movie=list(mv), quick=k in (0, 5, 6))
        S('active:mode1_plain:%d' % k, [R(1, b'', body(1, 0x270F, 0, 0, 0, -1, 0, 1))], [('start', 7), ('tick',)], group='active',
          movie=list(mv), quick=k in (0, 4))
    for startw in (1, 0, -1, 2, 0x7FFF, -0x8000, 257):
        S('active:startword%d' % startw, [R(1, b'', body(1, 0x270F, 1, 2, 3, -1, 0, startw))], [('start', 9), ('tick',)], group='active',
          movie=active_movie(), start=3, quick=startw in (1, 0, 2, 257))
    for scene in (0x270F, 0x270E, 0x2710, 0, -1, 1, 0x7FFF, -0x8000, 0x0632):
        S('active:scene%d' % scene, [R(1, b'', body(1, scene, -2, 300, -400, -1, 0, 2))], [('tick',)], group='active', movie=active_movie(),
          quick=scene in (0x270F, 0, -1, 0x0632))
    for flag in (-1, 0, 1, 2, 799, 1598, 1599):
        for value in (0, 1, -1, 0x7FFF, -0x8000, 1234):
            S('active:flag%d_value%d' % (flag, value), [R(1, b'', body(1, 0x270F, 0, 0, 0, flag, value, 1))], [('tick',)], group='active',
              movie=active_movie(), quick=(flag, value) in ((-1, 5), (0, -1), (1599, 1234), (1, 0)))
    # the flag store changes later gates inside the same tick
    S('gate:handler_opens_next_gate',
      [R(1, b'', body(1, 0x270F, 0, 0, 0, 40, 1, 1)), R(1, event_tail(40, 1), body(2)), R(1, event_tail(40, 1), body(1, 0x270F, 0, 0, 0, 41, 3, 1)),
       R(1, event_tail(41, 3), body(2))], [('tick',), ('rearm',), ('tick',)], group='gate', movie=active_movie(), events={40: 0, 41: 0}, quick=True)
    S('gate:handler_closes_next_gate', [R(1, b'', body(1, 0x270F, 0, 0, 0, 40, 0, 1)), R(1, event_tail(40, 1), body(2))], [('tick',)],
      group='gate', movie=active_movie(), events={40: 1}, quick=True)
    S('gate:handler_changes_earlier_gate_for_next_tick',
      [R(1, event_tail(50, 1), body(2)), R(1, b'', body(1, 0x270F, 0, 0, 0, 50, 1, 1))], [('tick',), ('rearm',), ('tick',)], group='gate',
      movie=active_movie(), events={50: 0})
    # the stop row ends the pass: later rows do not run, earlier rows did
    S('stop:first_row', [R(1, b'', body(0, 9, 1, 2, 3, 5, 6, 7)), R(1, b'', body(2))], group='stop', movie=active_movie(), stop=True, quick=True)
    S('stop:middle_row', [R(1, b'', body(2)), R(1, b'', body(1, 0x270F, 0, 0, 0, 12, 4, 0)), R(1, b'', body(0)), R(1, b'', body(2))],
      group='stop', movie=active_movie(), stop=True, quick=True)
    S('stop:gated_off_stop_row_is_skipped', [R(1, event_tail(60, 1), body(0)), R(1, b'', body(2))], group='stop', movie=active_movie(),
      events={60: 0}, quick=True)
    S('stop:gated_on_stop_row', [R(1, event_tail(60, 1), body(0)), R(1, b'', body(2))], group='stop', movie=active_movie(), events={60: 1},
      stop=True)
    S('stop:only_after_first_pass_rows', [R(1, b'', body(2)), R(1, b'', body(0))], [('tick',)], group='stop', movie=active_movie(),
      first=4, stop=True)
    S('stop:inactive_mode0_runs_through', [R(1, b'', body(0)), R(1, b'', body(0)), R(1, b'', body(2))], group='stop')
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(subtype, b'', body(2)), R(subtype, b'', body(1, 0x270F, 0, 0, 0, 3, 4, 1))],
          [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3), ('rearm',), ('tick',)], group='subtype',
          movie=active_movie(), quick=subtype in (0, 2, 255))
    S('gate:event_false', [R(1, event_tail(40, 1), body(1, 0x270F, 0, 0, 0, 5, 5, 0))], [('tick',), ('tick',)], group='gate',
      movie=active_movie(), events={40: 7}, start=9, quick=True)
    S('gate:event_false_then_true', [R(1, event_tail(40, 1), body(1, 0x270F, 0, 0, 0, 5, 5, 0)), R(1, b'', body(2))],
      [('tick',), ('events', {40: 1}), ('rearm',), ('tick',)], group='gate', movie=active_movie(), events={40: 7}, quick=True)
    S('gate:subtype2_behind_event', [R(2, event_tail(42, 5), body(2))], [('events', {42: 5}), ('tick',), ('tick',)], group='gate',
      movie=active_movie(), events={42: 1})
    S('gate:mode4_runs_nothing', [R(1, b'', body(1, 5, 1, 2, 3, 4, 5, 6)), R(1, b'', body(2))], [('tick',), ('mode', 3), ('tick',)],
      group='gate', movie=active_movie(), mode=4, quick=True)
    S('rows:offset_first_rows', [R(1, b'', body(1, 5, 1, 2, 3, 4, 5, 6)), R(1, b'', body(2))], [('tick',), ('tick',)], group='rows',
      movie=active_movie(), first=3, quick=True)
    S('rows:high_index', [R(1, b'', body(2))], [('tick',)], group='rows', movie=active_movie(), first=88)
    S('rows:revisit_after_rearm', [R(1, b'', body(2))], [('tick',), ('movie', active_movie(p25a=1)), ('tick',), ('rearm',), ('tick',)],
      group='rows', movie=active_movie(), quick=True)
    S('rows:object_state_carries_between_rows', [R(1, b'', body(2)), R(1, b'', body(2)), R(1, b'', body(1, 0x270F, 0, 0, 0, -1, 0, 5))],
      [('tick',)], group='rows', movie=active_movie(p25a=1), quick=True)
    for n in range(80):
        count = rng.randint(1, 30)
        rows = []
        for _ in range(count):
            tail = event_tail(rng.choice((rng.randrange(EVENTS), 40, 41, 42)), rng.randrange(-3, 4)) if rng.random() < 0.3 else b''
            rows.append(R(rng.choice((0, 1, 1, 1, 2, 3)), tail, rand_body(rng, rng.choice((1, 2, 2, 1, 3, rng.randrange(256))))))
        mv = rng.choice((list(INACTIVE), active_movie(p25a=rng.choice((0, 1))), active_movie(active=rng.choice((1, 2, -1)))))
        stop = False
        events = {k: rng.randrange(-3, 4) for k in (40, 41, 42)}
        acts = []
        for _ in range(rng.randint(1, 3)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('rearm',))
            if rng.random() < 0.4:
                acts.append(('events', {k: rng.randrange(-3, 4) for k in (40, 41, 42)}))
        S('random:%d' % n, rows, acts, group='random', movie=mv, events=events, start=rng.choice((0, 1, 5)), quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw-0x2e rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1',
                                f'-I{PROJECT / "src"}', str(PROJECT / 'tests/action_family_2e_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a2e.c', 'action_family_2e.c', 'scene_resource.c', 'hiff.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        st, _, hexbody = line.partition(' ')
        rows.append((int(st), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, completions=0, effect_compares=0, ordered_events=0,
                state_compares=0, stops=0, mismatches=0, gate_model_checks=0, by_subtype=Counter(), by_mode=Counter(), groups={})


def row_gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += stats['rows_visited'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    nat.reset_events()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    state = dict(mode=sc['mode'])
    x.set_movie(sc['movie'], OBJ_FILLER)
    nat.set_movie(sc['movie'])
    x.w32(START_FLAG_VA, sc['start'])
    nat.set_start_flag(sc['start'])
    for idx, v in sc['events'].items():
        x.set_event(idx, v)
        nat.set_event(idx, v)
    completed = [1] * first + [0] * len(rows)
    phases = [0] * (first + len(rows))
    compare_state(sc['id'] + ' initial', x, nat, stats)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, rows, first, state, completed, phases, stats)
        elif kind == 'start':
            x.w32(START_FLAG_VA, act[1])
            nat.set_start_flag(act[1])
        elif kind == 'rearm':
            for i in range(first, first + len(rows)):
                completed[i] = 0
                phases[i] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'setphase':
            x.w32(ROWS + (first + act[1]) * ROW + PHASE_OFF, act[2])
            phases[first + act[1]] = act[2]
        elif kind == 'events':
            for idx, v in act[1].items():
                x.set_event(idx, v)
                nat.set_event(idx, v)
        elif kind == 'mode':
            state['mode'] = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        elif kind == 'movie':
            x.set_movie(act[1])
            nat.set_movie(act[1])
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def compare_state(where, x, nat, stats):
    stats['state_compares'] += 1
    if x.movie() != nat.movie():
        raise Mismatch('%s: movie object original %s native %s' % (where, x.movie(), nat.movie()))
    if x.events_table() != nat.events_table():
        diff = [i for i, (a, b) in enumerate(zip(x.events_table(), nat.events_table())) if a != b][:6]
        raise Mismatch('%s: event flag table differs at %s (original %s native %s)' % (
            where, diff, [x.event(i) for i in diff], [nat.event(i) for i in diff]))
    if _s(struct.unpack('<I', x.rd(START_FLAG_VA, 4))[0], 4) != nat.start_flag():
        raise Mismatch('%s: start flag original %d native %d' % (where, _s(struct.unpack('<I', x.rd(START_FLAG_VA, 4))[0], 4), nat.start_flag()))


def tick(where, x, nat, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    total = first + len(rows)
    movie_before = nat.movie()
    # the model first: it says where the original must stop, from the native table (which mirrors the original's)
    stop_possible = movie_before[0] != 0 and state['mode'] == 3
    x.stop_expected = stop_possible
    x.dispatch()
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x2e row' % (where, x.finish_entries, x.resets))
    if x.stray:
        raise Mismatch('%s: unexpected stores %s' % (where, x.stray[:4]))
    expected_entered, expected, native_events = [], [], []
    stopped_row = None
    starts_before, trans_before = nat.start_sets(), nat.transitions()
    nat.take_fx()
    if state['mode'] == 3:
        for i in range(first, total):
            if completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if not row_gate_open(spec, nat.event):
                continue
            expected.append(i)
            status, done, reset, phase, disposition = nat.visit(i, spec['subtype'], spec['body'], completed[i], phases[i])
            visit_events = nat.take_fx()
            native_events += visit_events
            if any(e[0] == FX_X57B for e in visit_events):  # the request the host received equals the scene-change cells the original stored
                cells = [e[1] for e in visit_events if FX_X57B <= e[0] <= FX_X5A3]
                if nat.last_request() != cells:
                    raise Mismatch('%s: row %d host request %s, scene-change cells %s' % (where, i, nat.last_request(), cells))
            if status == 1:  # SCENE_ACTION_HANDLER_UNSUPPORTED: the active random-movie stop
                stopped_row = i
                break
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            completed[i], phases[i] = done, phase
            if reset != 0 or disposition != 3:
                raise Mismatch('%s: native row %d disposition %d reset %d (expected direct completion)' % (where, i, disposition, reset))
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['by_subtype'][spec['subtype']] += 1
            stats['by_mode'][_s(spec['body'][0], 1)] += 1
            if any(e[0] == FX_ENGINE for e in native_events):  # the scene change stores 0x583999 := 4: the dispatcher loop ends
                state['mode'] = 4
                break
    stats['gate_model_checks'] += 1
    stats['rows_entered'] += len(x.entries)
    if (stopped_row is not None) != x.stopped:
        raise Mismatch('%s: native refused row %s but the original %s the random-movie stop' % (
            where, stopped_row, 'reached' if x.stopped else 'did not reach'))
    original_events = list(x.events)
    if x.stopped:
        stats['stops'] += 1
        mode_byte = _s(rows[stopped_row - first]['body'][0], 1)
        # the original stored the row and the mode before it reached the stop; the native refusal precedes both
        if original_events[-2:] != [(FX_ROW, stopped_row, 0), (FX_MODE, mode_byte, 0)] or mode_byte != 0:
            raise Mismatch('%s: unexpected stores before the stop: %s' % (where, original_events[-3:]))
        original_events = original_events[:-2]
    if x.prologue != expected_entered:
        raise Mismatch('%s: the dispatcher prologue cleared the request dword of rows %s, the model expects %s' % (where, x.prologue, expected_entered))
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for rows %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.handler_rows != expected:
        raise Mismatch('%s: the original reached the handler for rows %s, the gate model expects %s' % (where, x.handler_rows, expected))
    stats['rows_gated'] += len(expected_entered) - len(expected)
    stats['effect_compares'] += 1
    stats['ordered_events'] += len(original_events)
    if original_events != native_events:
        n = next((k for k, (a, b) in enumerate(zip(original_events, native_events)) if a != b), min(len(original_events), len(native_events)))
        raise Mismatch('%s: ordered stores differ at %d: original %s native %s' % (where, n, original_events[n:n + 3], native_events[n:n + 3]))
    if nat.start_sets() - starts_before != sum(1 for e in original_events if e[0] == FX_START):
        raise Mismatch('%s: host start-flag calls differ from the original stores' % where)
    if nat.transitions() - trans_before != sum(1 for e in original_events if e[0] == FX_X57B):
        raise Mismatch('%s: host transition requests differ from the original scene-change stores' % where)
    # state after the tick
    if x.stopped:
        om = x.movie()
        if om[1] != 0 or om[2] != stopped_row or om[0] != movie_before[0]:
            raise Mismatch('%s: unexpected object state at the stop %s' % (where, om))
        mm = nat.movie()
        if [om[0], om[3], om[4], om[5]] != [mm[0], mm[3], mm[4], mm[5]]:
            raise Mismatch('%s: object fields at the stop original %s native %s' % (where, om, mm))
        if x.events_table() != nat.events_table() or _s(struct.unpack('<I', x.rd(START_FLAG_VA, 4))[0], 4) != nat.start_flag():
            raise Mismatch('%s: tables differ at the stop' % where)
    else:
        compare_state(where, x, nat, stats)
    for i in range(first, total):
        o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
        if (o_done, o_phase) != (completed[i], phases[i]):
            raise Mismatch('%s: row %d original (completed %d phase %d) native model (completed %d phase %d)' % (
                where, i, o_done, o_phase, completed[i], phases[i]))
    if x.stopped:  # the original stopped inside the pass; align the native object with it for the next tick
        nat.set_movie(x.movie())


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


# native mutants: each must be caught by the quick scenario set
H, C_ = 'session_bindings_a2e.h', 'session_bindings_a2e.c'
MUTANTS = {
    'mode zero-extended': ('mode = (int32_t)(int8_t)body.option_00;', 'mode = (int32_t)body.option_00;', C_),
    'row stored plus one': ('b->movie.row = (int32_t)(int16_t)index;', 'b->movie.row = (int32_t)(int16_t)index + 1;', C_),
    'row not stored': ('    b->movie.row = (int32_t)(int16_t)index;                                  /* 0x4ced94 */\n    fx(b, index, SESSION_A2E_FX_ROW, b->movie.row);\n', '', C_),
    'mode not stored': ('    b->movie.mode = mode;                                                    /* 0x4cedbb */\n    fx(b, index, SESSION_A2E_FX_MODE, mode);\n', '', C_),
    'active test inverted': ('    if (b->movie.active != 0) {\n        if (mode == 1) {', '    if (b->movie.active == 0) {\n        if (mode == 1) {', C_),
    'object always active': ('    if (b->movie.active != 0) {\n        if (mode == 1) {                                                     /* 0x4ceefd */', '    if (1) {\n        if (mode == 1) {                                                     /* 0x4ceefd */', C_),
    'mode 0 treated as no-op': ('        if (mode == 0) {\n            b->failure = "random movie stop', '        if (mode == 0 && 0) {\n            b->failure = "random movie stop', C_),
    'mode 3 applies mode 1': ('        if (mode == 1) {                                                     /* 0x4ceefd */', '        if (mode == 1 || mode == 3) {', C_),
    'event flag sign dropped': ('b->world->event_flags[flag] = (int32_t)(int16_t)body.word[5];', 'b->world->event_flags[flag] = (int32_t)body.word[5];', C_),
    'event flag index 0 skipped': ('if (flag != SESSION_A2E_NO_FLAG) {\n                b->world->event_flags[flag]', 'if (flag > 0) {\n                b->world->event_flags[flag]', C_),
    'no-scene sentinel 9998': ('#define SESSION_A2E_NO_SCENE 9999', '#define SESSION_A2E_NO_SCENE 9998', H),
    'no-flag sentinel 0': ('#define SESSION_A2E_NO_FLAG (-1)', '#define SESSION_A2E_NO_FLAG 0', H),
    'scene words swapped': ('request.opaque_words[0] = (int16_t)body.word[1];\n                request.opaque_words[1] = (int16_t)body.word[2];', 'request.opaque_words[0] = (int16_t)body.word[2];\n                request.opaque_words[1] = (int16_t)body.word[1];', C_),
    'last scene word wrong': ('request.opaque_words[2] = (int16_t)body.word[3];', 'request.opaque_words[2] = (int16_t)body.word[4];', C_),
    'scene dwords wrong': ('request.opaque_dwords[2] = 1;', 'request.opaque_dwords[2] = 0;', C_),
    'transition for every mode-1 row': ('if (scene != SESSION_A2E_NO_SCENE) {\n                SceneTransitionRequest', 'if (1) {\n                SceneTransitionRequest', C_),
    'start flag word compare inverted': ('const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;', 'const int32_t start = (int16_t)body.word[6] == 1 ? 1 : 0;', C_),
    'start flag from the wrong word': ('const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;', 'const int32_t start = (int16_t)body.word[5] != 1 ? 1 : 0;', C_),
    'start flag word truncated to 8 bits': ('const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;', 'const int32_t start = (int8_t)body.word[6] != 1 ? 1 : 0;', C_),
    'start flag not reported': ('                b->host.set_start_flag(b->host.context, start);\n', '', C_),
    'mode 1 state 1de wrong': ('            b->movie.state_1de = 2;                                          /* 0x4cefaf */\n            fx(b, index, SESSION_A2E_FX_STATE_1DE, 2);', '            b->movie.state_1de = 3;\n            fx(b, index, SESSION_A2E_FX_STATE_1DE, 3);', C_),
    'mode 1 flag 206 wrong': ('            b->movie.flag_206 = 0;                                           /* 0x4cefb9 */\n            fx(b, index, SESSION_A2E_FX_FLAG_206, 0);', '            b->movie.flag_206 = 1;\n            fx(b, index, SESSION_A2E_FX_FLAG_206, 1);', C_),
    'mode 2 pending not cleared': ('                b->movie.pending_25a = 0;\n                fx(b, index, SESSION_A2E_FX_PENDING_25A, 0);', '                fx(b, index, SESSION_A2E_FX_PENDING_25A, 0);', C_),
    'mode 2 pending value 4': ('                b->movie.state_1de = 3;\n                fx(b, index, SESSION_A2E_FX_STATE_1DE, 3);', '                b->movie.state_1de = 4;\n                fx(b, index, SESSION_A2E_FX_STATE_1DE, 4);', C_),
    'mode 2 test inverted': ('if (b->movie.pending_25a == 0) {', 'if (b->movie.pending_25a != 0) {', C_),
    'mode 2 flag 206 cleared': ('            b->movie.flag_206 = 1;\n            fx(b, index, SESSION_A2E_FX_FLAG_206, 1);\n        }', '            b->movie.flag_206 = 0;\n            fx(b, index, SESSION_A2E_FX_FLAG_206, 0);\n        }', C_),
    'mode 3 acts like mode 2': ('} else if (mode == 2) {                                              /* 0x4cefc8 */', '} else if (mode >= 2) {', C_),
    'completion byte not reported': ('    fx(b, index, SESSION_A2E_FX_DONE, 1);                                    /* 0x4cf019 */\n', '', C_),
    'phase cleared': ('out->phase = before->phase;', 'out->phase = 0u;', C_),
    'phase advanced': ('out->phase = before->phase;', 'out->phase = before->phase + 1u;', C_),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', C_),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', C_),
    'subtype 2 resets': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', C_),
    'dependency reset requested': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', C_),
    'event flag before row stores': ('    b->movie.row = (int32_t)(int16_t)index;                                  /* 0x4ced94 */\n    fx(b, index, SESSION_A2E_FX_ROW, b->movie.row);\n    b->movie.mode = mode;                                                    /* 0x4cedbb */\n    fx(b, index, SESSION_A2E_FX_MODE, mode);', '    b->movie.mode = mode;\n    fx(b, index, SESSION_A2E_FX_MODE, mode);\n    b->movie.row = (int32_t)(int16_t)index;\n    fx(b, index, SESSION_A2E_FX_ROW, b->movie.row);', C_),
    'state stores before start flag': ('            {\n                const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;   /* 0x4cef8d..0x4cefac */\n                b->host.set_start_flag(b->host.context, start);\n                fx(b, index, SESSION_A2E_FX_START_FLAG, start);\n            }\n            b->movie.state_1de = 2;', '            b->movie.state_1de = 2;', C_),
}


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
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-33.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver2e.so')
    nat = Native(lib_path)
    x = Oracle()
    x._install_hooks_done = True
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
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    modes = stats['by_mode']
    summary['by_mode'] = dict(distinct=len(modes), mode0=modes.get(0, 0), mode1=modes.get(1, 0), mode2=modes.get(2, 0),
                              other=sum(v for k, v in modes.items() if k not in (0, 1, 2)))
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-33', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
