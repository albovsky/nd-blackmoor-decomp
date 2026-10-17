#!/usr/bin/env python3
"""RT-42: immutable x86 loader 0x411a22, dispatcher arm 0x428515 of 0x427a50 and appender 0x412787 (raw type 0x47) versus the
native raw-0x47 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. Two machines:

A. Loader: the original loader 0x411a22 copies the 0x27-byte body into a fresh allocation and advances its source and length
   counters; the bytes it produced are compared with the first 39 raw bytes (the bytes the native binding reads) and are the
   row objects machine B works on.
B. Runtime: for rows of raw type 0x47 the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the
   gate 0x423f57 (mode 0), the arm (0x428515..) and the real appender 0x412787 including its duplicate loop, the strcpy, the code
   and link-value stores, the count and the flag setter 0x4e0559, then the generic completion 0x42ba3a(row). The journal tables
   start from random states (counts from 0 to 400, random names, stale bytes after the NULs, random codes, links and flags).

Native side: src/session_bindings_a47.c over src/action_family_47_runtime.c, driven by
tests/action_family_47_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm and which ran the appender (observed entries) against the open-row model;
 * the AUTOTEXT lookup calls 0x423259 (row, ECX, key bytes, in order, once per non-matching stored entry) against the native host's
   calls; the lookup is answered from the same present-key set on both sides;
 * the writes to the count words (table, new count, in order) and the flag setter calls 0x4e0559 (row, page, flag, slot) against
   the native outcomes;
 * the whole table memory after the tick: 3 x 400 names with their stale bytes, the code words, the count words, the link
   values and the four flag dwords, against the native tables; every original write to the data region is classified and a write
   outside the modelled cells fails the run;
 * the completion byte and phase dword of every row, the unvisited rows unchanged; the generic completion 0x42ba3a once per
   visited row, in order, and the dependency reset 0x423d33 for exactly the rows the native disposition resets.
Expected difference (tagged "overflow"): a stored count of 400 with a name that is not stored. The original reports through
0x52139c ("AUTOTEXT error - too many list entries on page") and writes entry 400 (aliasing the next table); the native module
refuses with an error and changes nothing. The run checks that exactly those rows reached 0x52139c and returned ERROR natively
and then ends the scenario (the original's state is overrun).

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entry 0x428515 (the row is the signed word at [ebp-0x11c]), appender entry 0x412787, 0x4e0559 entry,
    0x42ba3a completion entry, 0x423d33 reset entry, every store to the data region
  R 0x423259 AUTOTEXT lookup (answers from the present-key set; found = nonzero pointer)
  R 0x52139c the error report (logged, returns)
  R 0x51dc43 malloc (bump arena in the oracle heap)
  G 0x4c97b4 0x42639d 0x50ca3e 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a (the x86 rows are built in memory, the body through the original loader
0x411a22), the AUTOTEXT table behind 0x423259 (its lookup is the 4B/51 oracles' business; here only the found/not found control
flow is compared), the rest of the text owner object 0x619a41 (the appender never reads it), the corpus rows' real dependency
records (replayed without them and behind a stand-in event record; the gate is shared verified code), kinds outside 3..5 (the
original indexes memory outside the tables; the native module refuses them, covered by the unit cases).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_47_runtime_original_oracle.py --mutations --result <receipt.json>
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
import test_scene_executor as base

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

LOADER = 0x411A22
ARM = 0x428515
APPENDER = 0x412787
LOOKUP = 0x423259
FLAGSET = 0x4E0559
REPORT = 0x52139C
OWNER = 0x619A41
LOOKUP_THIS = 0x619A6B
TYPE = 0x47
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 60
DATA_LO, DATA_HI = 0x580000, 0x640000
# the journal tables
NAMES_VA, NAMES_BYTES = 0x5957CB, 3 * 0x3390
CODES_VA, CODES_BYTES = 0x59F27B, 3 * 0x320
COUNTS_VA, COUNTS_BYTES = 0x59FBDB, 6
LINKS_VA, LINKS_BYTES = 0x59FBE1, 3 * 0x320
FLAGS_VA = 0x5A17B4 + 0x348       # dword "any", then three slot dwords at +4
FLAGS_BYTES = 16
SRC_BUF, SRC_PTR, LEN_CELL = 0x20010000, 0x20010100, 0x20010104   # inside the zeroed 0x20000000 scratch window
LOOKUP_RETURN = 0x5D0001           # a nonzero "found" pointer
MISSING_PIN = None

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
PINS_TABLE = (
    (0x411a22, 0x411b16, 'c9e641c18f0fd3663697c2c7bc3f23a193c4040e79d336047f53c5534dcb53ba'),
    (0x412787, 0x4129da, '4656759381574d9bfbba2bdd4fbb9c6b92ce3f283f46b86190688832279eda7e'),
    (0x423259, 0x423368, '05577fdc25bbcff3f5b8e48c31cedc4836a90d77f41d1f59886594953693f7e3'),
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x42356d, 0x4235fd, 'a6dc33d7551652dc77db241a4b9d86dce0b508ed4deefc755006e966dde76506'),
    (0x4235fd, 0x423634, '8a6999419fee63910944336417e99db758d3eb9b03c751ce7fb8499bb1e84a1b'),
    (0x4236d6, 0x423755, 'd3e12ee43fdc94129c88d28e0a7b257960663e21e8779a3158cf51845492361a'),
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
    (0x4e0559, 0x4e0619, '3588d6413d5da5a05d2f2b95f48f83c09d778652ca01c5c4d85d9345377831b1'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x52139c, 0x5213d4, '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x47 observers."""

    def __init__(self):
        super().__init__()
        self.present = set()
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
        table = {ARM: self._entry, APPENDER: self._appender, LOOKUP: self._lookup, FLAGSET: self._flagset, REPORT: self._report,
                 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            if a != REPORT:
                table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_LO, end=DATA_HI)

    def _entry(self, uc, address, size, user):
        self.cur_row = self._row_at_arm(uc)
        self.entries.append(self.cur_row)

    def _appender(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if ecx != OWNER:
            raise d9.OracleError('appender called with this=%#x' % ecx)
        row = s16(u32(uc, sp + 4))
        if row != self.cur_row:
            raise d9.OracleError('appender row %d differs from the arm row %d' % (row, self.cur_row))
        self.methods.append(row)

    def _lookup(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        key_at = u32(uc, sp + 4)
        raw = bytearray()
        while len(raw) < 64:
            b = bytes(uc.mem_read(key_at + len(raw), 1))[0]
            if b == 0:
                break
            raw.append(b)
        key = bytes(raw)
        self.lookups.append((self.cur_row, ecx, key))
        self._ret(uc, 4, LOOKUP_RETURN if key in self.present else 0)   # thiscall, one stack argument: ret 4

    def _flagset(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        a, flag, slot = (s16(u32(uc, sp + 4)), u32(uc, sp + 8), s16(u32(uc, sp + 12)))
        self.flag_calls.append((self.cur_row, ecx, a, flag, slot))

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
        value &= (1 << (8 * size)) - 1
        if COUNTS_VA <= address < COUNTS_VA + COUNTS_BYTES:
            if size != 2 or (address - COUNTS_VA) % 2:
                self.other_writes['count+%d/%d' % (address - COUNTS_VA, size)] += 1
            else:
                self.count_writes.append(((address - COUNTS_VA) // 2, s16(value)))
            return
        for lo, n, tag in ((NAMES_VA, NAMES_BYTES, 'names'), (CODES_VA, CODES_BYTES, 'codes'), (LINKS_VA, LINKS_BYTES, 'links'),
                           (FLAGS_VA, FLAGS_BYTES, 'flags')):
            if lo <= address < lo + n:
                self.table_writes[tag] += 1
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
        self.entries, self.methods, self.lookups, self.flag_calls, self.reports = [], [], [], [], []
        self.resets, self.finish_entries, self.count_writes = [], [], []
        self.table_writes, self.row_writes, self.other_writes = Counter(), Counter(), Counter()
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
        """Machine A: the original loader 0x411a22 builds row `index`'s pData from the raw body."""
        self.wr(SRC_BUF, raw)
        self.w32(SRC_PTR, SRC_BUF)
        self.w32(LEN_CELL, 1000)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', index))
        field = 0x5BB5E5 + index * ROW
        self.call(LOADER, [field, SRC_PTR, LEN_CELL], 0)
        pdata = u32(self.machine, field)
        produced = self.rd(pdata, 0x27)
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

    def set_tables(self, st):
        self.wr(NAMES_VA, bytes(st['names']))
        self.wr(CODES_VA, bytes(st['codes']))
        self.wr(COUNTS_VA, struct.pack('<3h', *st['counts']))
        self.wr(LINKS_VA, bytes(st['links']))
        self.wr(FLAGS_VA, struct.pack('<4I', *st['flags']))

    def get_tables(self):
        return dict(names=self.rd(NAMES_VA, NAMES_BYTES), codes=self.rd(CODES_VA, CODES_BYTES),
                    counts=struct.unpack('<3h', self.rd(COUNTS_VA, COUNTS_BYTES)), links=self.rd(LINKS_VA, LINKS_BYTES),
                    flags=struct.unpack('<4I', self.rd(FLAGS_VA, FLAGS_BYTES)))


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_47_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a47.c', 'action_family_47_runtime.c', 'action_core.c', 'scene_resource.c', 'hiff.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A47_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a47o_new.restype = C.c_void_p
        lib.a47o_free.argtypes = [C.c_void_p]
        lib.a47o_present_clear.argtypes = [C.c_void_p]
        lib.a47o_present_add.argtypes = [C.c_void_p, C.c_char_p, C.c_uint]
        lib.a47o_present_add.restype = C.c_int
        lib.a47o_set_lookup_error.argtypes = [C.c_void_p, C.c_int]
        lib.a47o_load.argtypes = [C.c_void_p, C.c_char_p, C.c_char_p, C.c_char_p, C.c_char_p, C.c_char_p]
        lib.a47o_dump.argtypes = [C.c_void_p, C.c_char_p, C.c_char_p, C.c_char_p, C.c_char_p, C.c_char_p]
        lib.a47o_call_count.argtypes = [C.c_void_p]
        lib.a47o_call_count.restype = C.c_uint
        lib.a47o_call_row.argtypes = [C.c_void_p, C.c_uint]
        lib.a47o_call_row.restype = C.c_int
        lib.a47o_call_length.argtypes = [C.c_void_p, C.c_uint]
        lib.a47o_call_length.restype = C.c_uint
        lib.a47o_call_copy.argtypes = [C.c_void_p, C.c_uint, C.c_char_p]
        lib.a47o_calls_clear.argtypes = [C.c_void_p]
        lib.a47o_outcome.argtypes = [C.c_void_p, C.POINTER(C.c_int)]
        lib.a47o_visit.argtypes = [C.c_void_p, C.c_int, C.c_uint, C.c_char_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                   C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a47o_visit.restype = C.c_int
        self.h = lib.a47o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.a47o_free(self.h)

    def set_present(self, keys):
        self.lib.a47o_present_clear(self.h)
        for key in keys:
            if not self.lib.a47o_present_add(self.h, key, len(key)):
                raise d9.OracleError('native present set full')

    def load(self, st):
        self.lib.a47o_load(self.h, bytes(st['names']), bytes(st['codes']), struct.pack('<3h', *st['counts']), bytes(st['links']),
                           struct.pack('<4I', *st['flags']))

    def dump(self):
        names, codes, counts = C.create_string_buffer(NAMES_BYTES), C.create_string_buffer(CODES_BYTES), C.create_string_buffer(6)
        links, flags = C.create_string_buffer(LINKS_BYTES), C.create_string_buffer(16)
        self.lib.a47o_dump(self.h, names, codes, counts, links, flags)
        return dict(names=names.raw, codes=codes.raw, counts=struct.unpack('<3h', counts.raw), links=links.raw,
                    flags=struct.unpack('<4I', flags.raw))

    def lookups(self):
        out = []
        for i in range(self.lib.a47o_call_count(self.h)):
            n = self.lib.a47o_call_length(self.h, i)
            buf = C.create_string_buffer(max(n, 1))
            self.lib.a47o_call_copy(self.h, i, buf)
            out.append((self.lib.a47o_call_row(self.h, i), buf.raw[:n]))
        self.lib.a47o_calls_clear(self.h)
        return out

    def outcome(self):
        o = (C.c_int * 7)()
        self.lib.a47o_outcome(self.h, o)
        keys = ('table', 'index', 'appended', 'duplicate', 'miss', 'flag_slot', 'lookups')
        return dict(zip(keys, list(o)))

    def visit(self, index, subtype, raw, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a47o_visit(self.h, index, subtype, bytes(raw), len(raw), completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
CODES = [-32768, -5, -1, 0, 1, 6, 7, 8, 9, 10, 11, 100, 32767]
POOL = [b'CURJ%02d' % i for i in range(12)] + [b'A', b'AB', b'ab', b'Q' * 32, b'Q' * 31 + b'R', b'']


def body(kind, name, code, value, junk=None):
    """The 39 typed bytes; `junk` fills the bytes after the name's NUL (the loader copies them, the appender must not)."""
    field = name + b'\0'
    field = field.ljust(33, b'\0') if junk is None else (field + junk * 33)[:33]
    return struct.pack('<h', kind) + field + struct.pack('<hh', code, value)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def empty_state():
    return dict(names=bytearray(NAMES_BYTES), codes=bytearray(CODES_BYTES), counts=[0, 0, 0], links=bytearray(LINKS_BYTES), flags=[0] * 4)


def random_state(rng, pool, fills):
    st = empty_state()
    for t in range(3):
        n = fills[t]
        names = list(pool)
        rng.shuffle(names)
        for j in range(n):
            name = names[j] if j < len(names) else b'X%d_%d' % (t, j)
            entry = (name + b'\0' + bytes(rng.randrange(1, 256) for _ in range(33)))[:33]
            off = t * 0x3390 + j * 33
            st['names'][off:off + 33] = entry
            struct.pack_into('<h', st['codes'], t * 0x320 + 2 * j, rng.choice(CODES))
            struct.pack_into('<h', st['links'], t * 0x320 + 2 * j, rng.randrange(-32768, 32768))
        st['counts'][t] = n
        # stale bytes beyond the count: the appender overwrites only the NUL-terminated name
        for j in range(n, min(n + 3, 400)):
            off = t * 0x3390 + j * 33
            st['names'][off:off + 33] = bytes(rng.randrange(1, 256) for _ in range(33))
    st['flags'] = [rng.randrange(2) for _ in range(4)]
    return st


def R(kind, name, code, value, subtype=1, tail=b'', junk=None):
    raw = body(kind, name, code, value, junk)
    return dict(subtype=subtype, raw=raw + tail, tail=tail, kind=kind, name=name)


def scenario_list(seed=0x42, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', state=None, present=(), **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, state=state or empty_state(),
                        present=set(present), events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                        first=kw.pop('first', 0), stride=kw.pop('stride', 0x100), overflow=kw.pop('overflow', False),
                        observed_gate=kw.pop('observed_gate', False)))

    if corpus:
        scenes = {}
        for scene_id, st, raw in corpus:
            scenes.setdefault(scene_id, []).append((st, raw))
        for n, (scene_id, items) in enumerate(sorted(scenes.items())):
            rows = []
            for st, raw in items:
                kind = struct.unpack_from('<h', raw)[0]
                name = raw[2:raw.index(0, 2)]
                code, value = struct.unpack_from('<hh', raw, 0x23)
                rows.append(dict(subtype=st, raw=raw, tail=raw[39:], kind=kind, name=name))
            names = {r['name'] for r in rows}
            # the real dependency tails (their conditions read event flags that start at zero) and the same rows without them
            bare = [dict(r, raw=r['raw'][:39], tail=b'') for r in rows]
            S('corpus:%d:real_tails' % n, rows, [('tick',), ('rearm',), ('tick',)], group='corpus', present=names, quick=n == 0, observed_gate=True)
            S('corpus:%d:all_present' % n, bare, [('tick',), ('rearm',), ('tick',)], group='corpus', present=names, quick=n == 0)
            S('corpus:%d:none_present' % n, bare, [('tick',), ('rearm',), ('tick',)], group='corpus', present=(), quick=n == 0)
            half = {nm for k, nm in enumerate(sorted(names)) if k % 2}
            S('corpus:%d:half_present' % n, bare, [('tick',), ('rearm',), ('tick',)], group='corpus', present=half)
            gated = []
            for k, r in enumerate(bare):
                g = dict(r)
                g['tail'] = event_tail(1000 + k % 6, 1)
                g['raw'] = r['raw'][:39] + g['tail']
                gated.append(g)
            S('corpus_gated:%d' % n, gated, [('tick',), ('events', {1000 + k: 1 for k in range(0, 6, 2)}), ('tick',), ('rearm',),
                                              ('events', {1000 + k: 1 for k in range(6)}), ('tick',)],
              group='corpus', present=names, events={1000 + k: 0 for k in range(6)})
    # basic rules
    S('basic:first_entries', [R(4, b'CURJ00', 0, -1), R(3, b'CURJ01', 7, 123), R(5, b'CURJ02', 10, 5)], [('tick',)], quick=True)
    S('basic:link_rule', [R(5, b'N%d' % i, c, 1000 + i) for i, c in enumerate(CODES)], [('tick',)], quick=True, present={b'N%d' % i for i in range(20)})
    S('basic:duplicate_ends', [R(4, b'AAA', 0, 0), R(4, b'BBB', 0, 0), R(4, b'CCC', 0, 0), R(4, b'BBB', 3, 3), R(4, b'AAA', 3, 3),
                               R(4, b'CCC', 3, 3), R(4, b'ddd', 0, 0), R(4, b'DDD', 0, 0)],
      [('tick',)], quick=True, present={b'AAA', b'BBB', b'CCC', b'DDD', b'ddd'})
    S('basic:miss_ends', [R(4, b'AAA', 0, 0), R(4, b'BBB', 0, 0), R(4, b'CCC', 0, 0)], [('tick',), ('rearm',), ('tick',)], quick=True,
      present={b'AAA', b'BBB'})
    S('basic:tables_are_separate', [R(3, b'SAME', 0, 0), R(4, b'SAME', 1, 1), R(5, b'SAME', 2, 2), R(3, b'SAME', 3, 3)], quick=True)
    S('basic:name_lengths', [R(4, b'x' * n, 12, n) for n in (1, 2, 31, 32)] + [R(3, b'y' * n, 7, n) for n in (1, 2, 31, 32)], quick=True,
      present={b'x' * n for n in (1, 2, 31, 32)} | {b'y' * n for n in (1, 2, 31, 32)})
    S('basic:junk_after_nul', [R(4, b'JUNK1', 12, 1, junk=b'\xfe'), R(3, b'JUNK2', 7, 2, junk=b'\x01\x02'), R(5, b'JUNK1', 7, 3, junk=b'\xff')],
      quick=True)
    # subtype and phase: the arm never reads the phase; the generic completion writes it
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(4, b'one', 0, 1, subtype), R(3, b'two', 7, 2, subtype), R(4, b'one', 0, 1, subtype)],
          [('setphase', 0, 5), ('setphase', 2, 9), ('tick',), ('tick',), ('setphase', 1, 3), ('rearm',), ('tick',)], group='subtype',
          quick=subtype in (0, 1, 2, 255), present={b'one', b'two'})
    # gates
    S('gate:event_false_leaves_row', [R(4, b'g1', 0, 1, 1, event_tail(1040, 1)), R(3, b'g2', 7, 2, 2, event_tail(1041, 1)),
                                      R(4, b'g3', 0, 3, 1, event_tail(1042, 1))],
      [('tick',), ('tick',)], group='gate', events={1040: 7, 1041: 7, 1042: 7}, quick=True)
    S('gate:event_false_then_true', [R(4, b'late', 0, 1, 1, event_tail(1040, 1)), R(4, b'late2', 0, 2, 2, event_tail(1040, 1)), R(4, b'free', 0, 3)],
      [('tick',), ('tick',), ('events', {1040: 1}), ('rearm',), ('tick',), ('tick',)], group='gate', events={1040: 7}, quick=True,
      present={b'late', b'late2', b'free'})
    S('gate:mode4_runs_nothing', [R(4, b'm4', 0, 1), R(3, b'm4b', 7, 1)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, quick=True)
    S('rows:offset_first_row', [R(4, b'x', 0, 1), R(4, b'y', 0, 2, 2)], [('tick',), ('tick',)], group='rows', first=3, quick=True)
    # full tables: a stored name still completes; a new name overflows (expected difference, scenario ends)
    full = random_state(random.Random(5), POOL, [400, 399, 400])
    S('full:stored_name_completes', [R(3, POOL[0], 12, 1), R(5, POOL[1], 12, 1), R(4, POOL[2], 12, 1)], [('tick',)], group='full', state=full,
      quick=True, present=set(POOL))
    S('full:last_slot', [R(4, b'LAST', 12, 77), R(4, b'LAST', 12, 77)], [('tick',)], group='full', state=full, present={b'LAST'}, quick=True)
    S('full:overflow_miss_first', [R(3, b'NEWNAME', 12, 1)], [('tick',)], group='full', state=full, present=set(), overflow=True)
    S('full:overflow', [R(3, b'NEWNAME', 12, 1)], [('tick',)], group='full', state=full, present={b'NEWNAME'}, overflow=True, quick=True)
    S('full:overflow_kind5', [R(5, b'NEWNAME', 12, 1)], [('tick',)], group='full', state=full, present={b'NEWNAME'}, overflow=True)
    for n in range(80):
        pool = rng.sample(POOL, rng.randint(3, len(POOL)))
        fills = [rng.choice((0, 0, 1, 2, 3, 5, 12, 40, 399)) for _ in range(3)]
        state = random_state(rng, pool, fills)
        present = {p for p in pool if rng.random() < 0.6} | ({b'extra'} if rng.random() < 0.3 else set())
        rows = []
        for _ in range(rng.randint(1, 9)):
            name = rng.choice(pool + [b'new%d' % rng.randrange(6)])
            tail = event_tail(1000 + rng.randrange(60), rng.randrange(-2, 3)) if rng.random() < 0.3 else b''
            rows.append(R(rng.choice((3, 4, 5)), name, rng.choice(CODES), rng.randrange(-32768, 32768), rng.choice((0, 1, 1, 1, 2, 3)), tail,
                          junk=bytes([rng.randrange(1, 256)]) if rng.random() < 0.3 else None))
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('events', {1000 + rng.randrange(60): rng.randrange(-2, 3) for _ in range(6)}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 3, state=state, present=present)
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x47 rows (derived by the production parser): (scene id, subtype, raw body), or None."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_47_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a47.c', 'action_family_47_runtime.c', 'scene_resource.c', 'hiff.c')],
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
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, rows_completed=0, rows_open=0, appended=0,
                duplicates=0, lookup_misses=0, lookups_compared=0, flag_calls=0, count_writes=0, table_compares=0, table_bytes=0,
                resets_checked=0, loader_objects=0, overflow_rows=0, mismatches=0, by_subtype=Counter(), by_table=Counter(),
                groups={}, writes_table=Counter(), writes_row=Counter(), writes_other=Counter())


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
        self.diverged = False


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first, sc['stride'])
    # machine A: the original loader's copy of every body becomes the row object
    for k, r in enumerate(rows):
        i = first + k
        pdata, produced, advanced = x.load_body(i, r['raw'])
        if produced != r['raw'][:0x27] or advanced != (0x27, 0x27):
            raise Mismatch('%s: loader 0x411a22 row %d produced %r advanced %r, expected %r' % (sc['id'], k, produced[:20], advanced, r['raw'][:20]))
        if x.allocs.get(pdata) != 0x27:
            raise Mismatch('%s: loader allocation of %r bytes, expected 39' % (sc['id'], x.allocs.get(pdata)))
        stats['loader_objects'] += 1
    x.wr(d9.G_ROWCOUNT, struct.pack('<h', first + len(rows)))
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    x.set_tables(sc['state'])
    x.present = set(sc['present'])
    nat.set_present(sc['present'])
    nat.load(sc['state'])
    nat.lookups()
    st = Scenario(sc, rows, first)
    for ai, act in enumerate(sc['actions']):
        if st.diverged:
            break
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


def compare_tables(where, x, nat, stats):
    o, n = x.get_tables(), nat.dump()
    for key in ('counts', 'flags'):
        if tuple(o[key]) != tuple(n[key]):
            raise Mismatch('%s: %s differ: original %r native %r' % (where, key, o[key], n[key]))
    for key, stride in (('names', 0x3390), ('codes', 0x320), ('links', 0x320)):
        if o[key] != n[key]:
            first = next(i for i in range(len(o[key])) if o[key][i] != n[key][i])
            raise Mismatch('%s: %s differ at table %d offset %#x: original %#x native %#x' % (
                where, key, first // stride, first % stride, o[key][first], n[key][first]))
    stats['table_compares'] += 1
    stats['table_bytes'] += NAMES_BYTES + CODES_BYTES + LINKS_BYTES + COUNTS_BYTES + FLAGS_BYTES


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    x.dispatch()
    rows, first = st.rows, st.first
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    nat.lookups()
    expected_entered, visited, native_resets, native_out = [], [], [], {}
    overflow_native = []
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
    # the original's overflow rows (expected difference)
    overflow_rows = [row for row, _args in x.reports]
    for args in (a for _r, a in x.reports):
        if args != (0x54164C, 0, 0):
            raise Mismatch('%s: the error report 0x52139c got arguments %r' % (where, args))
    for i in visited:
        spec = rows[i - first]
        o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
        status, done, reset, phase, disposition = nat.visit(i - first, spec['subtype'], spec['raw'], st.completed[i], st.phases[i])
        native_out[i] = nat.outcome()
        if i in overflow_rows:
            if status != 2:   # SCENE_ACTION_HANDLER_ERROR
                raise Mismatch('%s: row %d reached the original error report; native status %d, expected ERROR' % (where, i, status))
            overflow_native.append(i)
            stats['overflow_rows'] += 1
            continue
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
        stats['by_table'][spec['kind']] += 1
    if overflow_native != overflow_rows:
        raise Mismatch('%s: the original reported a full table for rows %s, native refused rows %s' % (where, overflow_rows, overflow_native))
    if overflow_rows and not st.sc['overflow']:
        raise Mismatch('%s: an unexpected full-table report for rows %s' % (where, overflow_rows))
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.methods != visited:
        raise Mismatch('%s: the original ran the appender for rows %s, expected %s' % (where, x.methods, visited))
    # the lookup calls: row, ECX and key bytes, in order
    native_lookups = [(row + first, key) for row, key in nat.lookups()]
    original_lookups = []
    for row, ecx, key in x.lookups:
        if ecx != LOOKUP_THIS:
            raise Mismatch('%s: lookup 0x423259 called with this=%#x' % (where, ecx))
        original_lookups.append((row, key))
    if original_lookups != native_lookups:
        raise Mismatch('%s: lookup calls differ: original %r native %r' % (where, original_lookups[:6], native_lookups[:6]))
    stats['lookups_compared'] += len(original_lookups)
    # the generic completion and the dependency reset (rows that overflowed are excluded: the original completed them)
    if x.finish_entries != visited:
        raise Mismatch('%s: 0x42ba3a ran for %s, expected the visited rows %s' % (where, x.finish_entries, visited))
    if x.resets != native_resets and not overflow_rows:
        raise Mismatch('%s: 0x423d33 ran for rows %s, the native dispositions reset %s' % (where, x.resets, native_resets))
    stats['resets_checked'] += len(x.resets)
    stats['rows_gated'] += len(expected_entered) - len(visited)
    for i in range(first, total):
        if i not in visited:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (st.completed[i], st.phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    # appended entries and flag calls
    native_counts = [(o['table'], o['index'] + 1) for i, o in native_out.items() if o['appended']]
    native_flags = [(i, 2, 1, o['flag_slot']) for i, o in native_out.items() if o['flag_slot'] >= 0]
    if overflow_rows:
        st.diverged = True
        return
    if [(t, c) for t, c in x.count_writes] != native_counts:
        raise Mismatch('%s: count writes %r differ from native appends %r' % (where, x.count_writes, native_counts))
    stats['count_writes'] += len(x.count_writes)
    original_flags = []
    for row, ecx, a, flag, slot in x.flag_calls:
        if ecx != 0x570508:
            raise Mismatch('%s: flag setter called with this=%#x' % (where, ecx))
        original_flags.append((row, a, flag, slot))
    if original_flags != native_flags:
        raise Mismatch('%s: flag setter calls %r differ from native %r' % (where, original_flags, native_flags))
    stats['flag_calls'] += len(original_flags)
    for o in native_out.values():
        stats['appended'] += o['appended']
        stats['duplicates'] += o['duplicate']
        stats['lookup_misses'] += o['miss']
    # footprint: every original write is a modelled cell
    stats['writes_table'].update(x.table_writes)
    stats['writes_row'].update(x.row_writes)
    stats['writes_other'].update(x.other_writes)
    unexpected = {k: v for k, v in x.other_writes.items() if k not in EXPECTED_OTHER_WRITES}
    if unexpected:
        raise Mismatch('%s: the original wrote outside the modelled cells: %r' % (where, dict(list(unexpected.items())[:8])))
    compare_tables(where, x, nat, stats)


# data-region writes the dispatcher and the gate make outside the journal tables and the rows (discovered, then pinned)
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
KERNEL = 'action_family_47_runtime.c'
BIND = 'session_bindings_a47.c'
MUTANTS = {
    'link value kept for any code': ('(body->code >= 10 || body->code == 7) ? body->value', '1 ? body->value', KERNEL),
    'link value dropped for code 7': ('(body->code >= 10 || body->code == 7) ? body->value', '(body->code >= 10) ? body->value', KERNEL),
    'link value threshold off by one': ('body->code >= 10 ||', 'body->code > 10 ||', KERNEL),
    'link value threshold unsigned': ('body->code >= 10 ||', '(uint16_t)body->code >= 10u ||', KERNEL),
    'wrong special code': ('body->code == 7)', 'body->code == 8)', KERNEL),
    'no-link value zero': ('(int16_t)A47_NO_LINK;', '(int16_t)0;', KERNEL),
    'flag slots swapped': ('body->kind == 4 ? 0u : 1u', 'body->kind == 4 ? 1u : 0u', KERNEL),
    'flag call for every kind': ('if (body->kind == 4 || body->kind == 3) {', 'if (1) {', KERNEL),
    'flag call for kind 4 only': ('if (body->kind == 4 || body->kind == 3) {', 'if (body->kind == 4) {', KERNEL),
    'any flag not set': ('        tables->page2_any = 1u;\n', '', KERNEL),
    'slot flag not set': ('        tables->page2_slot[slot] = 1u;\n', '', KERNEL),
    'duplicate not detected': ('strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0', '0', KERNEL),
    'duplicate compared on the first byte only': ('strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0',
                                                  'strncmp((const char *)tables->name[table][entry], (const char *)body->name, 1u) == 0', KERNEL),
    'lookup before the duplicate compare': ('        if (strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0) {\n            o->duplicate = 1;',
                                            '        if (lookup != NULL && lookup(context, body->name, name_bytes) == 0) {\n            o->lookup_miss = 1;\n            return A47_OK;\n        }\n        if (strcmp((const char *)tables->name[table][entry], (const char *)body->name) == 0) {\n            o->duplicate = 1;', KERNEL),
    'lookup miss ignored': ('        if (found == 0) {', '        if (0) {', KERNEL),
    'lookup key one byte short': ('found = lookup(context, body->name, name_bytes);', 'found = lookup(context, body->name, name_bytes - 1u);', KERNEL),
    'lookup once for the first entry only': ('        found = lookup(context, body->name, name_bytes);', '        found = entry == 0 ? lookup(context, body->name, name_bytes) : 1;', KERNEL),
    'table index off by one': ('(size_t)(body->kind - A47_FIRST_KIND)', '(size_t)(body->kind - A47_FIRST_KIND + (body->kind > 3))', KERNEL),
    'count not grown': ('    tables->count[table] = (int16_t)(count + 1);\n', '', KERNEL),
    'name copied without its NUL': ('name_bytes + 1u', 'name_bytes', KERNEL),
    'whole name field copied': ('name_bytes + 1u', 'A47_NAME_BYTES', KERNEL),
    'code word not stored': ('    tables->code[table][count] = body->code;\n', '', KERNEL),
    'value taken from the wrong word': ('out->value = le16(raw + 0x25);', 'out->value = le16(raw + 0x23);', KERNEL),
    'code taken from the wrong word': ('out->code = le16(raw + 0x23);', 'out->code = le16(raw + 0x25);', KERNEL),
    'direct completion': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', BIND),
    'row left pending': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_PENDING;', BIND),
    'dependency reset always': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', BIND),
    'phase kept': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = state_before->phase;\n    return SCENE_ACTION_HANDLER_OK;', BIND),
    'phase one': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = 1u;\n    return SCENE_ACTION_HANDLER_OK;', BIND),
    'lookup not found treated as found': ('    case ACTION_FAMILY_51_LOOKUP_NOT_FOUND:\n        return 0;', '    case ACTION_FAMILY_51_LOOKUP_NOT_FOUND:\n        return 1;', BIND),
    'full table completed anyway': ('        binding->failure = "journal table is full (400 entries)";\n        return SCENE_ACTION_HANDLER_ERROR;',
                                    '        binding->failure = "journal table is full (400 entries)";\n        break;', BIND),
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
    work = Path(tempfile.mkdtemp(prefix='RT-42.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver47.so')
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
        args.result.write_text(json.dumps(dict(slice='RT-42', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
