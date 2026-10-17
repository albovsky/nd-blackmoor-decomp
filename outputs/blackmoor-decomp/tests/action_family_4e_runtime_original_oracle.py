#!/usr/bin/env python3
"""RT-44: immutable x86 loader 0x44b102, dispatcher arm 0x4280f9 of 0x427a50 and method 0x44b3c8 (raw type 0x4e) versus the
native raw-0x4e runtime.

The unmodified GAME.EXE image is mapped under Unicorn (x87 control word 0x27f, 53-bit precision, as the shipped process runs).
Two machines:

A. Loader: the original loader 0x44b102 copies the 31-byte body into a fresh allocation and advances its source and length
   counters; the bytes it produced are compared with the raw body (the bytes the native binding reads).
B. Runtime: for rows of raw type 0x4e the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the
   gate 0x423f57 (mode 1), the arm (0x4280f9..), and the real method 0x44b3c8 with its float arithmetic, then the generic
   completion 0x42ba3a(row). The value cells start from random states: 30 int16 slots (0x58c959, 9999 included), 10 float32
   slots (0x58c995: 9999.0f, NaN, infinities, denormals, signed zeros, random bit patterns) and the 15 float slots in front of
   them, which the method never touches.

Native side: src/session_bindings_a4e.c over src/action_family_4e_runtime.c, driven by
tests/action_family_4e_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm and which ran the method (observed entries) against the open-row model;
 * the out-of-range selector reports (format string and selector argument of 0x50ca3e, then 0x52139c, in order) against the
   native outcome's reports;
 * the whole value area 0x58c91d..0x58c9bd (160 bytes: 15 untouched floats, the 30 words, the 10 floats) bit for bit against
   the native world (words and float bit patterns), and the 60 bytes in front of the native cells against their start state;
   every original write to that area is classified and a write outside the ten target cells fails the run;
 * the completion byte and phase dword of every row, the unvisited rows unchanged; the generic completion 0x42ba3a once per
   visited row, in order, and the dependency reset 0x423d33 for exactly the rows the native disposition resets.

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entry 0x4280f9 (the row is the signed word at [ebp-0x11c]), method entry 0x44b3c8, 0x42ba3a completion entry,
    0x423d33 reset entry, every store to the data region
  R 0x50ca3e sprintf (logged, the format string and selector are compared; nothing is formatted)
  R 0x52139c the error report (logged, returns)
  R 0x51dc43 malloc (bump arena in the oracle heap)
  G 0x4c97b4 0x42639d 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a (the x86 rows are built in memory, the body through the original loader
0x44b102), the corpus rows' real dependency records (replayed without them and behind a stand-in event record; the gate is shared
verified code), the debug flag set (the original then logs on an out-of-range target; the native module models the flag as 0).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_4e_runtime_original_oracle.py --mutations --result <receipt.json>
"""
from __future__ import annotations

import argparse
import ctypes as C
import json
import math
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
import test_scene_executor as base

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

LOADER = 0x44B102
ARM = 0x4280F9
METHOD = 0x44B3C8
METHOD_THIS = 0x637FB1
SPRINTF = 0x50CA3E
REPORT = 0x52139C
TYPE = 0x4E
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 60
DATA_LO, DATA_HI = 0x580000, 0x640000
# the value area: floats 0..14 (never touched by the action), 30 int16 words (aliasing floats 15..29), floats 30..39
AREA_VA, AREA_BYTES = 0x58C91D, 160
WORDS_VA = 0x58C959
FLOATS_VA = 0x58C995
FRONT_BYTES = WORDS_VA - AREA_VA      # 60 bytes the native world does not model
SRC_BUF, SRC_PTR, LEN_CELL = 0x20010000, 0x20010100, 0x20010104   # inside the zeroed 0x20000000 scratch window
FMT_RANGE = 0x549088                  # "AT_SET_VALUE_COMBO, index out of range for value to combine: ..."
SCRATCH_BUF = 0x63888B

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
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
    (0x42ba3a, 0x42babf, '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x44b102, 0x44b1b4, '8f284db00b7529f3a9ad8dbd661c76bb6333fbe1aa86501ca59eb3cf3f797a7a'),
    (0x44b3c8, 0x44b641, 'bbb8faa8936805077289b618d4b353bc146088a9561d75b6a3dd45994f388152'),
    (0x50ca3e, 0x50ca90, 'e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x52139c, 0x5213d4, '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x4e observers."""

    def __init__(self):
        super().__init__()
        self.pins = []
        self.clear_logs()
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))

    def _row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {ARM: self._entry, METHOD: self._method, SPRINTF: self._sprintf, REPORT: self._report,
                 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            if a not in (REPORT, SPRINTF):
                table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_LO, end=DATA_HI)

    def _entry(self, uc, address, size, user):
        self.cur_row = self._row_at_arm(uc)
        self.entries.append(self.cur_row)

    def _method(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if ecx != METHOD_THIS:
            raise d9.OracleError('method called with this=%#x' % ecx)
        row = s16(u32(uc, sp + 4))
        if row != self.cur_row:
            raise d9.OracleError('method row %d differs from the arm row %d' % (row, self.cur_row))
        self.methods.append(row)

    def _sprintf(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        args = tuple(u32(uc, sp + 4 * k) for k in (1, 2, 3))
        self.sprintfs.append((self.cur_row, args))
        self._ret(uc, 0, 0)   # cdecl: the caller pops

    def _report(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        args = tuple(u32(uc, sp + 4 * k) for k in (1, 2, 3))
        self.reports.append((self.cur_row, args))
        self._ret(uc, 0xC, 0)   # stdcall, three stack arguments: ret 0xc

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _on_write(self, uc, access, address, size, value, user):
        if AREA_VA <= address < AREA_VA + AREA_BYTES:
            self.area_writes['area+%d/%d' % (address - AREA_VA, size)] += 1
            return
        if ROWS <= address < ROWS + MAX_ROWS * ROW:
            self.row_writes['row+%#x/%d' % ((address - ROWS) % ROW, size)] += 1
            return
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
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_logs()

    def clear_logs(self):
        self.entries, self.methods, self.sprintfs, self.reports = [], [], [], []
        self.resets, self.finish_entries = [], []
        self.area_writes, self.row_writes, self.other_writes = Counter(), Counter(), Counter()
        self.cur_row = -1

    def install_rows(self, rows, first=0, stride=0x100):
        total = first + len(rows)
        if total > MAX_ROWS or total * stride > 0xF000:
            raise d9.OracleError('too many rows for the oracle storage')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base_va = ROWS + i * ROW
            body_at = d9.BODY_BASE + stride * i
            self.wr(body_at, spec['raw'])
            self.wr(base_va + 0x30, bytes([TYPE, spec['subtype']]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base_va, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base_va + COMPLETE_OFF, b'\0')
            self.w32(base_va + PHASE_OFF, 0)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def load_body(self, index, raw):
        """Machine A: the original loader 0x44b102 builds row `index`'s pData from the raw body."""
        self.wr(SRC_BUF, raw)
        self.w32(SRC_PTR, SRC_BUF)
        self.w32(LEN_CELL, 1000)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', index))
        field = 0x5BB5E5 + index * ROW
        self.call(LOADER, [field, SRC_PTR, LEN_CELL], 0)
        pdata = u32(self.machine, field)
        produced = self.rd(pdata, 0x1F)
        advanced = (u32(self.machine, SRC_PTR) - SRC_BUF, u32(self.machine, LEN_CELL) - 1000)
        return pdata, produced, advanced

    def dispatch(self):
        self.clear_logs()
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'

    def set_area(self, area):
        self.wr(AREA_VA, bytes(area))

    def get_area(self):
        return self.rd(AREA_VA, AREA_BYTES)


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_4e_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a4e.c', 'action_family_4e_runtime.c', 'action_family_4e.c', 'action_core.c',
                                             'scene_resource.c', 'hiff.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A4E_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a4eo_new.restype = C.c_void_p
        lib.a4eo_free.argtypes = [C.c_void_p]
        lib.a4eo_load.argtypes = [C.c_void_p, C.c_char_p, C.c_char_p]
        lib.a4eo_dump.argtypes = [C.c_void_p, C.c_char_p, C.c_char_p]
        lib.a4eo_outcome.argtypes = [C.c_void_p, C.POINTER(C.c_int)]
        lib.a4eo_visit.argtypes = [C.c_void_p, C.c_int, C.c_uint, C.c_char_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                   C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a4eo_visit.restype = C.c_int
        self.h = lib.a4eo_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.a4eo_free(self.h)

    def load(self, area):
        self.lib.a4eo_load(self.h, bytes(area[FRONT_BYTES:FRONT_BYTES + 60]), bytes(area[FRONT_BYTES + 60:]))

    def dump(self):
        shorts, floats = C.create_string_buffer(60), C.create_string_buffer(40)
        self.lib.a4eo_dump(self.h, shorts, floats)
        return shorts.raw + floats.raw

    def outcome(self):
        o = (C.c_int * 14)()
        self.lib.a4eo_outcome(self.h, o)
        vals = list(o)
        return dict(target_valid=vals[0], terms=vals[1], unset=vals[2], reports=vals[3], selectors=vals[4:4 + vals[3]])

    def visit(self, index, subtype, raw, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a4eo_visit(self.h, index, subtype, bytes(raw), len(raw), completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
AMOUNTS = [-32768, -101, -100, -99, -50, -1, 0, 1, 2, 3, 7, 10, 33, 50, 99, 100, 101, 250, 1000, 9999, 32767]
SHORTS = [-32768, -9999, -100, -1, 0, 1, 2, 3, 50, 99, 100, 255, 9998, 9999, 10000, 32767]
FLOAT_WITNESSES = [(31252, 0XB94EFB80), (-4280, 0X15319B08), (-14380, 0X4D556EC0), (28272, 0X98B8FF60), (28360, 0X53511B40), (-6460, 0X4444C2A0)]
SHORT_WITNESSES = [(-25615, -32705), (-25665, -32635), (-25715, -32565), (-25765, -32495)]
FLOAT_POOL = [0x00000000, 0x80000000, 0x3F800000, 0xBF800000, 0x42C80000, 0x461C3C00,   # 0, -0, 1, -1, 100, 9999.0
              0x461C3C01, 0x461C3BFF, 0x7FC00000, 0xFFC00000, 0x7F800001, 0x7F800000, 0xFF800000,   # near 9999, NaNs, inf
              0x00000001, 0x007FFFFF, 0x00800000, 0x7F7FFFFF, 0xFF7FFFFF, 0x3DCCCCCD, 0x40490FDB, 0x4B800000, 0x33800000]


def body(target, triples):
    """31 bytes: the target byte and ten (selector, amount) triples (shorter lists are padded with 'no term')."""
    triples = list(triples) + [(99, 0)] * (10 - len(triples))
    return bytes([target]) + b''.join(struct.pack('<Bh', sel, amount) for sel, amount in triples[:10])


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def make_area(shorts, floats, front=None):
    """The 160-byte value area: 15 float cells in front, 30 words, 10 floats (bit patterns)."""
    front = front if front is not None else [0] * 15
    return struct.pack('<15I', *front) + struct.pack('<30h', *shorts) + struct.pack('<10I', *floats)


def init_area():
    return make_area([9999] * 30, [0x461C3C00] * 10)


def random_area(rng, pool=None):
    pool = pool or FLOAT_POOL
    shorts = [rng.choice(SHORTS) if rng.random() < 0.7 else rng.randrange(-32768, 32768) for _ in range(30)]
    floats = [rng.choice(pool) if rng.random() < 0.6 else rng.randrange(1 << 32) for _ in range(10)]
    front = [rng.randrange(1 << 32) for _ in range(15)]
    return make_area(shorts, floats, front)


def R(target, triples, subtype=1, tail=b'', junk=False):
    raw = body(target, triples)
    return dict(subtype=subtype, raw=raw + tail, tail=tail, target=target)


def scenario_list(seed=0x4E, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', area=None, **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, area=area if area is not None else init_area(),
                        events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                        first=kw.pop('first', 0), stride=kw.pop('stride', 0x100), observed_gate=kw.pop('observed_gate', False)))

    if corpus:
        scenes = {}
        for scene_id, st, raw in corpus:
            scenes.setdefault(scene_id, []).append((st, raw))
        for n, (scene_id, items) in enumerate(sorted(scenes.items())):
            rows = [dict(subtype=st, raw=raw, tail=raw[31:], target=raw[0]) for st, raw in items]
            bare = [dict(r, raw=r['raw'][:31], tail=b'') for r in rows]
            # the real dependency tails (their conditions read event flags that start at zero) and the same rows without them,
            # from freshly initialized values and from random value states
            S('corpus:%d:real_tails' % n, rows, [('tick',), ('rearm',), ('tick',)], group='corpus', quick=n == 0, observed_gate=True)
            S('corpus:%d:fresh' % n, bare, [('tick',), ('rearm',), ('tick',)], group='corpus', quick=n == 0)
            for k in range(4):
                S('corpus:%d:random_values%d' % (n, k), bare, [('tick',), ('rearm',), ('tick',)], group='corpus',
                  area=random_area(rng), quick=n == 0 and k == 0)
    # basic rules
    fresh = init_area()
    S('basic:literal_only', [R(30, [(100, 5)]), R(31, [(100, -7), (100, 40)]), R(32, [(100, 32767), (100, 32767)])], quick=True)
    S('basic:skip_entries', [R(33, [(99, 5), (99, 6)]), R(34, [(99, 1), (100, 3), (99, 2)])], quick=True)
    S('basic:short_slots_fresh', [R(35, [(s, 10) for s in range(10)]), R(36, [(s, 10) for s in range(10, 20)]),
                                  R(37, [(s, 10) for s in range(20, 30)])], quick=True)
    S('basic:float_slots_fresh', [R(38, [(s, 10) for s in range(30, 40)])], quick=True)
    sh = [3, 0, -5, 100, 9999, 7, 255, -32768, 32767, 1] + [50] * 20
    fl = [0x41200000, 0x461C3C00, 0x42C80000, 0xC1200000, 0x00000000, 0x80000000, 0x3F800000, 0x461C3C01, 0x7FC00000, 0x7F800000]
    S('basic:short_slots_set', [R(30 + i, [(s, a) for s in range(i, i + 5) for a in (AMOUNTS[(s + 3 * i) % len(AMOUNTS)],)][:10]) for i in range(10)],
      area=make_area(sh, fl), quick=True)
    S('basic:float_slots_set', [R(30 + i, [(30 + (i + j) % 10, AMOUNTS[(i * 3 + j) % len(AMOUNTS)]) for j in range(10)]) for i in range(10)],
      area=make_area(sh, fl), quick=True)
    S('basic:self_reference', [R(31, [(31, 100), (31, 100), (31, 50), (100, 1), (31, -25)]), R(30, [(100, 4), (30, 100), (30, 100)])],
      area=make_area(sh, fl), quick=True)
    S('basic:accumulation_order', [R(32, [(30, 100), (100, 1), (100, 1), (31, 100), (100, -32768)]),
                                   R(33, [(30, 100), (31, 100), (32, 100)])], area=make_area(sh, [0x4B800000, 0x33800000, 0x3F800000] + [0] * 7),
      quick=True)
    S('basic:out_of_range_target', [R(t, [(100, 5)]) for t in (0, 1, 29, 40, 41, 99, 100, 200, 255)] + [R(39, [(100, 9)])], quick=True)
    S('basic:out_of_range_selector', [R(30, [(40, 5), (41, 6), (98, 1), (101, 2), (255, 3), (100, 1)]), R(31, [(50, 1)]),
                                      R(32, [(60, 2), (61, 3), (62, 4), (63, 5), (64, 6), (65, 7), (66, 8), (67, 9), (68, 10), (69, 11)])],
      quick=True)
    # rounding witnesses: (amount, slot) pairs where a / 100 * slot and amount * slot / 100 round to different floats, so the order
    # of the original's fdiv and fmul is pinned (found by a 20-million trial search)
    for n, (amount, bits) in enumerate(FLOAT_WITNESSES):
        floats = [0] * 10
        floats[1] = bits
        S('rounding:float%d' % n, [R(30, [(31, amount)])], area=make_area([9999] * 30, floats), quick=True)
    for n, (amount, value) in enumerate(SHORT_WITNESSES):
        shorts = [9999] * 30
        shorts[n + 3] = value
        S('rounding:short%d' % n, [R(30, [(n + 3, amount)])], area=make_area(shorts, [0] * 10), quick=True)
    # subtype and phase: the arm never reads the phase; the generic completion writes it
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(30, [(100, 1)], subtype), R(31, [(30, 50), (100, 3)], subtype), R(30, [(100, 2)], subtype)],
          [('setphase', 0, 5), ('setphase', 2, 9), ('tick',), ('tick',), ('setphase', 1, 3), ('rearm',), ('tick',)], group='subtype',
          quick=subtype in (0, 1, 2, 255), area=make_area(sh, fl))
    # gates
    S('gate:event_false_leaves_row', [R(30, [(100, 1)], 1, event_tail(1040, 1)), R(31, [(100, 2)], 2, event_tail(1041, 1)),
                                      R(32, [(100, 3)], 1, event_tail(1042, 1))],
      [('tick',), ('tick',)], group='gate', events={1040: 7, 1041: 7, 1042: 7}, quick=True)
    S('gate:event_false_then_true', [R(30, [(100, 1)], 1, event_tail(1040, 1)), R(31, [(30, 50)], 2, event_tail(1040, 1)), R(32, [(100, 3)])],
      [('tick',), ('tick',), ('events', {1040: 1}), ('rearm',), ('tick',), ('tick',)], group='gate', events={1040: 7}, quick=True)
    S('gate:mode4_runs_nothing', [R(30, [(100, 1)]), R(31, [(100, 2)])], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, quick=True)
    S('rows:offset_first_row', [R(30, [(100, 1)]), R(31, [(30, 100), (100, 2)], 2)], [('tick',), ('tick',)], group='rows', first=3, quick=True)
    for n in range(240):
        area = random_area(rng)
        rows = []
        for _ in range(rng.randint(1, 9)):
            target = rng.choice([30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 39, 30]) if rng.random() < 0.9 else rng.randrange(256)
            triples = []
            for _ in range(rng.randint(1, 10)):
                kind = rng.random()
                sel = 99 if kind < 0.1 else 100 if kind < 0.3 else rng.randrange(0, 30) if kind < 0.5 else rng.randrange(30, 40) if kind < 0.9 \
                    else rng.randrange(256)
                triples.append((sel, rng.choice(AMOUNTS) if rng.random() < 0.7 else rng.randrange(-32768, 32768)))
            tail = event_tail(1000 + rng.randrange(60), rng.randrange(-2, 3)) if rng.random() < 0.3 else b''
            rows.append(R(target, triples, rng.choice((0, 1, 1, 1, 2, 3)), tail))
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('events', {1000 + rng.randrange(60): rng.randrange(-2, 3) for _ in range(6)}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 3, area=area)
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x4e rows (derived by the production parser): (scene id, subtype, raw body), or None."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_4e_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a4e.c', 'action_family_4e_runtime.c', 'action_family_4e.c',
                                                                    'action_core.c', 'scene_resource.c', 'hiff.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
        if built.returncode != 0:
            return None
        rows = []
        for path in sorted(resources.glob('*.bin')):
            out = subprocess.run([str(exe), '--dump', str(path)], capture_output=True, text=True).stdout
            for line in out.splitlines():
                subtype, hexbody = line.split()
                rows.append((path.stem, int(subtype), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, rows_completed=0, rows_open=0,
                valid_targets=0, invalid_targets=0, terms=0, unset_terms=0, reports=0, area_compares=0, area_bytes=0,
                float_cells_written=0, nonfinite_results=0, resets_checked=0, loader_objects=0, mismatches=0,
                by_subtype=Counter(), groups={}, writes_area=Counter(), writes_row=Counter(), writes_other=Counter())


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


class Scenario:
    def __init__(self, sc, rows, first):
        self.sc, self.rows, self.first = sc, rows, first
        self.mode = sc['mode']
        self.completed = [1 if i < first else 0 for i in range(first + len(rows))]
        self.phases = [0] * (first + len(rows))
        self.start_area = sc['area']


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first, sc['stride'])
    # machine A: the original loader's copy of every body becomes the row object
    for k, r in enumerate(rows):
        i = first + k
        pdata, produced, advanced = x.load_body(i, r['raw'])
        if produced != r['raw'][:0x1F] or advanced != (0x1F, 0x1F):
            raise Mismatch('%s: loader 0x44b102 row %d produced %r advanced %r, expected %r' % (sc['id'], k, produced[:20], advanced, r['raw'][:20]))
        if x.allocs.get(pdata) != 0x1F:
            raise Mismatch('%s: loader allocation of %r bytes, expected 31' % (sc['id'], x.allocs.get(pdata)))
        stats['loader_objects'] += 1
    x.wr(d9.G_ROWCOUNT, struct.pack('<h', first + len(rows)))
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    x.set_area(sc['area'])
    nat.load(sc['area'])
    st = Scenario(sc, rows, first)
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
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        elif kind == 'mode':
            st.mode = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def compare_area(where, x, nat, st, stats):
    o = x.get_area()
    n = nat.dump()
    if o[:FRONT_BYTES] != st.start_area[:FRONT_BYTES]:
        raise Mismatch('%s: the original changed the 15 float cells in front of the words' % where)
    if o[FRONT_BYTES:] != n:
        first = next(i for i in range(len(n)) if o[FRONT_BYTES + i] != n[i])
        cell = 'word %d' % (first // 2) if first < 60 else 'float %d' % (30 + (first - 60) // 4)
        raise Mismatch('%s: value cells differ at %s (byte %d): original %#x native %#x' % (where, cell, first, o[FRONT_BYTES + first], n[first]))
    stats['area_compares'] += 1
    stats['area_bytes'] += AREA_BYTES


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    x.dispatch()
    rows, first = st.rows, st.first
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    expected_entered, visited, native_resets, native_out = [], [], [], {}
    if st.mode == 3:
        for i in range(first, total):
            if st.completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if st.sc['observed_gate']:
                # the corpus rows' real dependency records are other opcodes than the stand-in event record: the visited rows
                # are the ones whose gate the (shared, separately verified) original gate opened
                if i in x.methods:
                    visited.append(i)
                continue
            if not row_gate_open(spec, flags):
                continue
            visited.append(i)
    for i in visited:
        spec = rows[i - first]
        o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
        status, done, reset, phase, disposition = nat.visit(i - first, spec['subtype'], spec['raw'], st.completed[i], st.phases[i])
        native_out[i] = nat.outcome()
        if status != 0:
            raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
        st.completed[i], st.phases[i] = done, phase
        if reset:
            native_resets.append(i)
        if (done, phase) != (o_done, o_phase):
            raise Mismatch('%s: row %d (subtype %d) native (completed %d phase %d reset %d disposition %d) original (completed %d phase %d)' %
                           (where, i, spec['subtype'], done, phase, reset, disposition, o_done, o_phase))
        stats['rows_visited'] += 1
        stats['rows_completed' if done else 'rows_open'] += 1
        stats['by_subtype'][spec['subtype']] += 1
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.methods != visited:
        raise Mismatch('%s: the original ran the method for rows %s, expected %s' % (where, x.methods, visited))
    # the out-of-range selector reports: sprintf(buffer, format, selector), then the report 0x52139c(buffer, 0, 0)
    original_reports = []
    for (row, args), (row2, rargs) in zip(x.sprintfs, x.reports):
        if row != row2 or args[0] != SCRATCH_BUF or args[1] != FMT_RANGE or rargs != (SCRATCH_BUF, 0, 0):
            raise Mismatch('%s: report arguments differ: sprintf %r report %r' % (where, args, rargs))
        original_reports.append((row, args[2]))
    if len(x.sprintfs) != len(x.reports):
        raise Mismatch('%s: %d sprintf calls but %d reports' % (where, len(x.sprintfs), len(x.reports)))
    native_reports = [(i, sel) for i, o in native_out.items() for sel in o['selectors']]
    if original_reports != native_reports:
        raise Mismatch('%s: selector reports differ: original %r native %r' % (where, original_reports[:6], native_reports[:6]))
    stats['reports'] += len(original_reports)
    # the generic completion and the dependency reset
    if x.finish_entries != visited:
        raise Mismatch('%s: 0x42ba3a ran for %s, expected the visited rows %s' % (where, x.finish_entries, visited))
    if x.resets != native_resets:
        raise Mismatch('%s: 0x423d33 ran for rows %s, the native dispositions reset %s' % (where, x.resets, native_resets))
    stats['resets_checked'] += len(x.resets)
    stats['rows_gated'] += len(expected_entered) - len(visited)
    for i in range(first, total):
        if i not in visited:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (st.completed[i], st.phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    for i, o in native_out.items():
        spec = rows[i - first]
        if bool(o['target_valid']) != (30 <= spec['raw'][0] <= 39):
            raise Mismatch('%s: row %d target %d: native target_valid %d' % (where, i, spec['raw'][0], o['target_valid']))
        stats['valid_targets'] += o['target_valid']
        stats['invalid_targets'] += 1 - o['target_valid']
        stats['terms'] += o['terms']
        stats['unset_terms'] += o['unset']
    # footprint: every original write to the value area is one of the ten float cells, as a dword
    stats['writes_area'].update(x.area_writes)
    stats['writes_row'].update(x.row_writes)
    stats['writes_other'].update(x.other_writes)
    for tag, count in x.area_writes.items():
        offset, size = tag[len('area+'):].split('/')
        if int(size) != 4 or not (FRONT_BYTES + 60 <= int(offset) < AREA_BYTES) or (int(offset) - FRONT_BYTES - 60) % 4:
            raise Mismatch('%s: the original wrote %s outside the ten float target cells' % (where, tag))
        stats['float_cells_written'] += count
    unexpected = {k: v for k, v in x.other_writes.items() if k not in EXPECTED_OTHER_WRITES}
    if unexpected:
        raise Mismatch('%s: the original wrote outside the modelled cells: %r' % (where, dict(list(unexpected.items())[:8])))
    compare_area(where, x, nat, st, stats)
    stats['nonfinite_results'] += sum(1 for off in range(FRONT_BYTES + 60, AREA_BYTES, 4)
                                      if not math.isfinite(struct.unpack_from('<f', x.get_area(), off)[0]))


# data-region writes the dispatcher and the gate make outside the value area and the rows (discovered, then pinned)
# (0x5c3a47: the candidate cell the oracle clears before each tick; 0x637871..0x63787d and 0x637e81: the gate object's scratch dwords)
EXPECTED_OTHER_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}


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
KERNEL = 'action_family_4e_runtime.c'
BIND = 'session_bindings_a4e.c'
DECODE = 'action_family_4e.c'
MUTANTS = {
    'target range starts at 29': ('decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET', 'decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET - 1u', KERNEL),
    'target range starts at 31': ('decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET', 'decoded->option_00 < ACTION_FAMILY_4E_FIRST_TARGET + 1u', KERNEL),
    'target range ends at 38': ('decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET', 'decoded->option_00 >= ACTION_FAMILY_4E_LAST_TARGET', KERNEL),
    'target range ends at 40': ('decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET', 'decoded->option_00 > ACTION_FAMILY_4E_LAST_TARGET + 1u', KERNEL),
    'target not cleared first': ('    *target = 0.0f;\n', '', KERNEL),
    'target cleared to one': ('    *target = 0.0f;\n', '    *target = 1.0f;\n', KERNEL),
    'skip selector not skipped': ('        if (selector == ACTION_FAMILY_4E_SELECTOR_SKIP) {\n            continue;\n        }\n', '', KERNEL),
    'skip selector is 98': ('selector == ACTION_FAMILY_4E_SELECTOR_SKIP', 'selector == 98u', KERNEL),
    'literal selector is 101': ('selector == ACTION_FAMILY_4E_SELECTOR_LITERAL', 'selector == 101u', KERNEL),
    'literal scaled by percent': ('term = (float)amount;', 'term = (float)amount / 100.0f;', KERNEL),
    'literal amount unsigned': ('term = (float)amount;', 'term = (float)(uint16_t)amount;', KERNEL),
    'short slot boundary 29': ('if (selector < ACTION_CORE_SHORT_SLOT_COUNT) {', 'if (selector < ACTION_CORE_SHORT_SLOT_COUNT - 1u) {', KERNEL),
    'short slot boundary 31': ('if (selector < ACTION_CORE_SHORT_SLOT_COUNT) {', 'if (selector <= ACTION_CORE_SHORT_SLOT_COUNT) {', KERNEL),
    'float slot boundary 38': ('} else if (selector <= ACTION_FAMILY_4E_LAST_TARGET) {', '} else if (selector < ACTION_FAMILY_4E_LAST_TARGET) {', KERNEL),
    'float slot boundary 40': ('} else if (selector <= ACTION_FAMILY_4E_LAST_TARGET) {', '} else if (selector <= ACTION_FAMILY_4E_LAST_TARGET + 1u) {', KERNEL),
    'short unset sentinel 9998': ('if (slot == UNSET_SHORT) {', 'if (slot == UNSET_SHORT - 1) {', KERNEL),
    'short unset ignored': ('if (slot == UNSET_SHORT) {', 'if (0) {', KERNEL),
    'float unset ignored': ('if (slot == UNSET_FLOAT || isnan(slot)) {', 'if (isnan(slot)) {', KERNEL),
    'float nan not treated as unset': ('if (slot == UNSET_FLOAT || isnan(slot)) {', 'if (slot == UNSET_FLOAT) {', KERNEL),
    'float unset sentinel different': ('#define UNSET_FLOAT 9999.0f', '#define UNSET_FLOAT 9998.0f', KERNEL),
    'percent divisor 10': ('#define PERCENT_DIVISOR 100.0', '#define PERCENT_DIVISOR 10.0', KERNEL),
    'amount divided in float': ('return (float)(((double)(float)amount / PERCENT_DIVISOR) * slot);',
                                'return (float)((float)((float)amount / (float)PERCENT_DIVISOR) * (float)slot);', KERNEL),
    'product rounded early': ('return (float)(((double)(float)amount / PERCENT_DIVISOR) * slot);',
                              'return (float)((float)((double)(float)amount / PERCENT_DIVISOR) * (float)slot);', KERNEL),
    'amount multiplied before dividing': ('return (float)(((double)(float)amount / PERCENT_DIVISOR) * slot);',
                                          'return (float)(((double)(float)amount * slot) / PERCENT_DIVISOR);', KERNEL),
    'sum overwrites the target': ('*target = (float)((double)term + (double)*target);', '*target = term;', KERNEL),
    'report term not zero': ('            o->report_selector[o->reports++] = selector;\n            term = 0.0f;', '            o->report_selector[o->reports++] = selector;\n            term = 1.0f;', KERNEL),
    'report not recorded': ('o->report_selector[o->reports++] = selector;', 'o->reports += 0u;', KERNEL),
    'short slot read as float': ('term = scaled(amount, (double)(float)slot);', 'term = scaled(amount, (double)(float)(slot & 0x7fff));', KERNEL),
    'float slot index off by one': ('world->float_values[selector - ACTION_CORE_SHORT_SLOT_COUNT]', 'world->float_values[selector - ACTION_CORE_SHORT_SLOT_COUNT + (selector > 30u)]', KERNEL),
    'target slot index off by one': ('&world->float_values[decoded->option_00 - ACTION_FAMILY_4E_FIRST_TARGET]', '&world->float_values[decoded->option_00 - ACTION_FAMILY_4E_FIRST_TARGET - (decoded->option_00 == 39u)]', KERNEL),
    'amount unsigned': ('const int16_t amount = (int16_t)decoded->entries[i].word_0;', 'const int16_t amount = (int16_t)(uint16_t)(decoded->entries[i].word_0 & 0x7fffu);', KERNEL),
    'triple order reversed': ('for (i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {', 'for (i = ACTION_FAMILY_4E_ENTRY_COUNT; i-- > 0u;) {', KERNEL),
    'last triple ignored': ('for (i = 0u; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {', 'for (i = 0u; i + 1u < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {', KERNEL),
    'entry stride wrong': ('decoded->entries[i].option_00 = raw_body[1u + i * 3u];', 'decoded->entries[i].option_00 = raw_body[1u + i * 3u + (i == 9u)];', DECODE),
    'amount offset wrong': ('decoded->entries[i].word_0 = load16(raw_body + 2u + i * 3u);', 'decoded->entries[i].word_0 = load16(raw_body + 3u + i * 3u);', DECODE),
    'direct completion': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', BIND),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', BIND),
    'phase one': ('    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */', '    out->phase = 1u;', BIND),
    'phase kept': ('    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */', '    out->phase = before->phase;', BIND),
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
            report.append(dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:120]))
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
    work = Path(tempfile.mkdtemp(prefix='RT-44.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver4e.so')
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
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-44', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
