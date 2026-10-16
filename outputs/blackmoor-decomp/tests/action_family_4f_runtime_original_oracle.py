#!/usr/bin/env python3
"""RT-27: immutable x86 dispatcher 0x427a50 (arm 0x428133 -> 0x44b641) versus the native raw-0x4f runtime.

The unmodified GAME.EXE image is mapped under Unicorn and the REAL dispatcher 0x427a50 runs over rows of raw type
0x4f: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 1), the arm that calls the handler
0x44b641 on the object 0x637fb1, the handler itself (reads the 30 int16 + 10 float32 action values at 0x58c959,
compares them as x87 float32 values against other slots or literals, a percent form, and stores 1 in the event
flag table at 0x585801), the completion helper 0x42ba3a and, for subtype 2, the dependency reset 0x423d33. All of it
is original x86; x87 control word 0x027f as a Win32 process starts.

Native side: src/session_bindings_a4f.c (the executor's handler contract) over src/action_family_4f.c, driven by
tests/action_family_4f_runtime_oracle_driver.c with the executor's disposition mapping (action_core_finish_action).

Compared after every dispatcher call (tick), for the rows the original visited and the ones it did not:
 * which rows were visited (observed entries of 0x44b641), against a sequential gate model (event-flag dependency
   records, the world mode word; a row's visit changes the flags the next row's gate reads) and the native visits;
 * the row completion byte, the row phase dword and whether 0x423d33 reset the row's dependencies;
 * the first 1,600 event flag dwords (0x585801 + 4 * i), and that the 40 action values are unchanged.

HOOKS (everything else is original code): R = replaced, O = observed.
  O 0x44b641 handler, 0x42ba3a completion helper, 0x423d33 dependency reset: entry observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

KNOWN DIFFERENCES (counted in stats.known_observed, never as a pass; the native kernel refuses the row before any
state change, the original ran without error and its in-range flag writes are copied into the native table so the
scenario can go on):
  K1 modes 0 and 1 with operator 3 or 4 compare against the byte body[3 + slot], which leaves the 10-byte body
  K2 mode 2 with a slot operand from 40 up (other than the unused marker 99) reads past the 40 action values
  K3 the test held and the event flag index is below -1 or beyond the native table (1,600 entries)
Not modelled / unverified: the scene loader 0x40b34a that allocates the body (the oracle builds the body in memory;
the native decoder is checked against the decoded scene resources separately), the debug-flag paths (flag is 0),
the real game's use of the flags that rows set.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_4f_runtime_original_oracle.py --mutations --result <receipt.json>
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

OBJ4F = 0x637FB1
HANDLER = 0x44B641
VALUES_VA = 0x58C959          # 30 int16, then 10 float32 at 0x58c995
FLOAT_VA = 0x58C995
FLAG_COUNT = 1600
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
UNSET_BITS = 0x461C3C00       # 9999.0f
MAX_ROWS = 90

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
    (0x44b641, 0x44be44, 'd05630fdd24ed45fed367dc6a571649c84e010ba4d821f013f793cb8b590827a'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)

F32 = struct.Struct('<f')
LITERALS = (0, 1, 2, 3, 5, 7, 10, 15, 20, 50, 99, 100, 255)


def f32bits(value):
    return struct.unpack('<I', F32.pack(value))[0]


def bits_f32(bits):
    return F32.unpack(struct.pack('<I', bits))[0]


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x4f observers."""

    def __init__(self):
        super().__init__()
        self.handler_entries = []
        self.finish_entries = []
        self.resets = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    def _install_hooks(self):
        uc = self.machine
        table = {HANDLER: self._handler, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _handler(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ4F:
            raise d9.OracleError('0x44b641 entered with ECX != 0x637fb1')
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.handler_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

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
        self.handler_entries, self.finish_entries, self.resets = [], [], []
        self.set_values({}, {})

    def set_values(self, shorts, floats):
        """The 40 action values; unset slots hold 9999 / 9999.0f as after the initializer 0x44aff2."""
        for i in range(30):
            self.wr(VALUES_VA + 2 * i, struct.pack('<h', shorts.get(i, 9999)))
        for i in range(10):
            self.w32(FLOAT_VA + 4 * i, floats.get(i, UNSET_BITS))

    def values(self):
        return bytes(self.rd(VALUES_VA, 100))

    def flags(self):
        return struct.unpack('<%di' % FLAG_COUNT, bytes(self.rd(d9.EVENTS_VA, 4 * FLAG_COUNT)))

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
            self.wr(base + 0x30, bytes([0x4F, spec['subtype']]) + struct.pack('<I', body_at))
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
        self.handler_entries, self.finish_entries, self.resets = [], [], []
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-ffp-contract=off', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_4f_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('action_family_4f.c', 'session_bindings_a4f.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A4F_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a4fo_new.restype = C.c_void_p
        for name, args in (('a4fo_free', [C.c_void_p]), ('a4fo_reset', [C.c_void_p]),
                           ('a4fo_set_flag_count', [C.c_void_p, C.c_uint]),
                           ('a4fo_set_short', [C.c_void_p, C.c_int, C.c_int]),
                           ('a4fo_set_float_bits', [C.c_void_p, C.c_int, C.c_uint32]),
                           ('a4fo_set_flag', [C.c_void_p, C.c_int, C.c_int32])):
            getattr(lib, name).argtypes = args
        lib.a4fo_flag.argtypes = [C.c_void_p, C.c_int]
        lib.a4fo_flag.restype = C.c_int32
        lib.a4fo_short.argtypes = [C.c_void_p, C.c_int]
        lib.a4fo_short.restype = C.c_int
        lib.a4fo_float_bits.argtypes = [C.c_void_p, C.c_int]
        lib.a4fo_float_bits.restype = C.c_uint32
        lib.a4fo_probe.argtypes = [C.c_void_p, C.c_char_p, C.c_int]
        lib.a4fo_probe.restype = C.c_int
        lib.a4fo_visit.argtypes = [C.c_void_p, C.c_char_p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                   C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a4fo_visit.restype = C.c_int
        self.h = lib.a4fo_new()
        lib.a4fo_reset(self.h)

    def close(self):
        self.lib.a4fo_free(self.h)

    def reset(self):
        self.lib.a4fo_reset(self.h)

    def set_values(self, shorts, floats):
        for i in range(30):
            self.lib.a4fo_set_short(self.h, i, shorts.get(i, 9999))
        for i in range(10):
            self.lib.a4fo_set_float_bits(self.h, i, floats.get(i, UNSET_BITS))

    def values(self):
        return b''.join(struct.pack('<h', self.lib.a4fo_short(self.h, i)) for i in range(30)) + \
            b''.join(struct.pack('<I', self.lib.a4fo_float_bits(self.h, i)) for i in range(10))

    def flag(self, i):
        return self.lib.a4fo_flag(self.h, i)

    def flags(self):
        return tuple(self.lib.a4fo_flag(self.h, i) for i in range(FLAG_COUNT))

    def probe(self, body):
        return self.lib.a4fo_probe(self.h, bytes(body), len(body))

    def visit(self, body, subtype, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a4fo_visit(self.h, bytes(body), len(body), subtype, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def B(attr, mode, op, v=(99, 99, 99, 99, 99), flag=-1):
    v = list(v) + [99] * (5 - len(v))
    return struct.pack('<BBB5Bh', attr & 0xFF, mode & 0xFF, op & 0xFF, *[x & 0xFF for x in v], flag)


def R(body, subtype=1, tail=b''):
    return dict(body=body, subtype=subtype, tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def rand_value_set(rng, density=0.8):
    shorts, floats = {}, {}
    small = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 19, 20, 21, 25, 49, 50, 51, 98, 99, 100, 101, 255, 300, -1, -5, 32767, -32768)
    for i in range(30):
        if rng.random() < density:
            shorts[i] = rng.choice(small)
    fl = (0.0, -0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 5.0, 7.0, 10.0, 15.0, 20.0, 99.0, 100.0, 650.25, 0.01, 0.99, 1e-10, 1e10,
          float('inf'), float('-inf'), float('nan'), -3.5, 9999.0)
    for i in range(10):
        if rng.random() < density:
            floats[i] = f32bits(rng.choice(fl) if rng.random() < 0.7 else rng.choice(small) + rng.choice((0.0, 0.25, 0.5, -0.125)))
    return shorts, floats


def rand_body(rng, flag_range=1600):
    r = rng.random()
    attr = rng.randrange(40) if r < 0.93 else rng.choice((40, 41, 100, 127, 128, 200, 255))
    r = rng.random()
    mode = 3 if r < 0.45 else 2 if r < 0.62 else 1 if r < 0.78 else 0 if r < 0.93 else rng.choice((4, 5, 7, 255))
    r = rng.random()
    if mode == 3:
        op = rng.choice((0, 0, 1, 2, 3, 4, 5, 6, 7)) if r < 0.95 else rng.choice((8, 9, 100, 255))
    else:
        op = rng.choice((0, 1, 2, 3, 4)) if r < 0.93 else rng.choice((5, 6, 7, 8, 255))
    v = []
    for _ in range(5):
        r = rng.random()
        if mode == 2:
            v.append(99 if r < 0.4 else rng.randrange(40) if r < 0.93 else rng.choice((40, 45, 98, 100, 150, 255)))
        else:
            v.append(99 if r < 0.35 else rng.choice(LITERALS) if r < 0.85 else rng.randrange(256))
    r = rng.random()
    flag = -1 if r < 0.2 else rng.randrange(flag_range) if r < 0.97 else rng.choice((-2, -500, 1600, 1700, 5000, 32767, -32768))
    return B(attr, mode, op, v, flag)


def scenario_list(seed=27, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, shorts=kw.pop('shorts', {}),
                        floats=kw.pop('floats', {}), events=kw.pop('events', {}), mode=kw.pop('mode', 3),
                        quick=kw.pop('quick', False), first=kw.pop('first', 0), known=kw.pop('known', None)))

    # the corpus rows (all mode 3, operators 0..3): the real bodies against several worlds, then the same again
    if corpus:
        for start in range(0, len(corpus), 80):
            chunk = corpus[start:start + 80]
            acts = []
            for rep in range(4):
                sh, fl = corpus_world(random.Random(seed * 1000 + start + rep), chunk)
                acts += [('values', sh, fl), ('tick',), ('rearm',), ('clearflags',)]
            S('corpus:%d' % (start // 80), [R(b, st) for st, b in chunk], acts, group='corpus', quick=start == 0)
    # operator grid, every mode: the attribute (a short slot and a float slot) below, equal to and above the others
    for mode in (0, 1, 2, 3):
        for op in range(9):
            rows = []
            for attr in (4, 33):
                if mode == 3:
                    rows.append(R(B(attr, 3, op, (10, 11, 9, 99, 12), 100 + attr), 0))
                    rows.append(R(B(attr, 3, op, (9, 99, 99, 99, 99), 200 + attr), 0))
                elif mode == 2:
                    rows.append(R(B(attr, 2, op, (6, 7, 30, 31, 99), 100 + attr), 0))
                    rows.append(R(B(attr, 2, op, (30, 99, 99, 99, 99), 200 + attr), 0))
                    rows.append(R(B(attr, 2, op, (99, attr, 99, 99, 99), 300 + attr), 0))
                else:
                    rows.append(R(B(attr, mode, op, (1, 2, 3, 4, 5), 100 + attr), 0))
            acts = []
            for cur in (9, 10, 11, 12, 13):
                acts += [('values', {4: cur, 6: 10, 7: 11, 1: 3, 2: 9, 10: 4, 29: 12}, {3: f32bits(float(cur)), 0: f32bits(10.0), 1: f32bits(11.0),
                                                                                           2: f32bits(9.5), 9: f32bits(12.0)}),
                         ('tick',), ('clearflags',)]
            S('grid:m%d_op%d' % (mode, op), rows, acts, group='grid', quick=(mode, op) in ((3, 0), (3, 3), (3, 5), (3, 7), (2, 2), (1, 1), (0, 4), (0, 2), (0, 0), (1, 0), (1, 2), (0, 1), (2, 0), (2, 4)))
    # percent form: b3 * b4 / 100 against cur, cur one ulp below / equal / above the expected value
    pct_rng = random.Random(seed + 1)
    pairs = [(a, b) for a in (1, 2, 3, 7, 13, 25, 30, 33, 50, 64, 99, 100, 128, 200, 255) for b in (1, 3, 10, 33, 50, 67, 99, 100, 101, 255)]
    pct_rng.shuffle(pairs)
    for n in range(0, len(pairs), 10):
        group_pairs = pairs[n:n + 10]
        rows = []
        for k, (a, b) in enumerate(group_pairs):
            for op in (5, 6, 7):
                rows.append(R(B(30 + k, 3, op, (a, b, 99, 99, 99), 300 + 3 * k + op - 5), 0))
                rows.append(R(B(30 + k, 3, op, (99, b, a, 99, 99), 340 + 3 * k + op - 5), 0))
                rows.append(R(B(30 + k, 3, op, (a, b, a, b, 99), 380 + 3 * k + op - 5), 0))
        acts = []
        for delta in (-1, 0, 1):
            fl = {}
            for k, (a, b) in enumerate(group_pairs):
                lit = f32bits(a * b / 100.0)
                fl[k] = lit + delta
                if delta == 0 and k % 3 == 0:
                    fl[k] = f32bits(99 * b / 100.0)
            acts += [('values', {}, fl), ('tick',), ('clearflags',)]
        S('percent:%d' % (n // 10), rows, acts, group='percent', quick=n == 0)
    # unset and out-of-range attributes, modes, operators and the flag marker
    edge = []
    for attr in (0, 29, 30, 39, 40, 41, 255):
        for mode in (3, 4, 255):
            edge.append(R(B(attr, mode, 0, (0, 99, 99, 99, 99), 400 + attr + mode % 7)))
    for op in range(5):
        edge += [R(B(7, 3, op, (3, 99, 99, 99, 99), 460 + op), 0), R(B(37, 3, op, (3, 99, 99, 99, 99), 470 + op), 0),
                 R(B(7, 0, op, (), 480 + op), 0), R(B(7, 2, op, (5, 99, 99, 99, 99), 490 + op), 0)]
    edge += [R(B(5, 3, 8, (3, 99, 99, 99, 99), 450), 0), R(B(5, 3, 255, (3, 99, 99, 99, 99), 451), 0), R(B(5, 3, 0, (3, 99, 99, 99, 99), -1), 0),
             R(B(6, 3, 0, (3, 99, 99, 99, 99), 452), 0)]
    S('edge:attributes_and_markers', edge, [('values', {0: 0, 29: 0, 5: 3, 6: 9999}, {0: f32bits(0.0), 9: f32bits(0.0)}), ('tick',), ('tick',)],
      group='edge', quick=True)
    # NaN / infinity / negative zero (the x87 compare sets C0 and C3 for an unordered pair)
    nan_rows = []
    for op in range(5):
        nan_rows += [R(B(30, 3, op, (1, 99, 99, 99, 99), 500 + op), 0), R(B(31, 3, op, (0, 99, 99, 99, 99), 510 + op), 0),
                     R(B(32, 3, op, (7, 99, 99, 99, 99), 520 + op), 0), R(B(30, 2, op, (31, 32, 33, 99, 99), 530 + op), 0),
                     R(B(33, 0, op, (), 540 + op), 0)]
    acts = []
    for combo in ((float('nan'), float('inf'), float('-inf'), -0.0, 1.0), (1.0, float('nan'), 0.0, float('nan'), float('inf')),
                  (float('inf'), float('inf'), 0.0, -0.0, float('nan'))):
        acts += [('values', {}, {i: f32bits(v) for i, v in enumerate(combo)}), ('tick',), ('clearflags',)]
    S('nan:float_slots', nan_rows, acts, group='nan', quick=True)
    # dependency gates: a false record leaves the row; opening it later runs the arm; a flag set by one row opens a later one in the same tick
    S('gate:event_false_then_true', [R(B(4, 3, 0, (7, 99, 99, 99, 99), 60), tail=event_tail(40, 1)), R(B(4, 3, 0, (7, 99, 99, 99, 99), 61))],
      [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('tick',)], group='gate', shorts={4: 7}, events={40: 7}, quick=True)
    S('gate:flag_chain_in_one_tick',
      [R(B(4, 3, 0, (7, 99, 99, 99, 99), 70)), R(B(5, 3, 0, (3, 99, 99, 99, 99), 71), tail=event_tail(70, 1)),
       R(B(6, 3, 0, (2, 99, 99, 99, 99), 72), tail=event_tail(71, 1)), R(B(4, 3, 1, (7, 99, 99, 99, 99), 73), tail=event_tail(72, 1))],
      [('tick',), ('tick',)], group='gate', shorts={4: 7, 5: 3, 6: 2}, quick=True)
    S('gate:mode4_runs_nothing', [R(B(4, 3, 0, (7, 99, 99, 99, 99), 80)), R(B(4, 3, 0, (7, 99, 99, 99, 99), 81))],
      [('tick',), ('mode', 3), ('tick',)], group='gate', shorts={4: 7}, mode=4, quick=True)
    S('gate:subtype2_behind_event', [R(B(4, 3, 0, (7, 99, 99, 99, 99), 82), 2, event_tail(42, 5))], [('events', {42: 5}), ('tick',), ('tick',)],
      group='gate', shorts={4: 7}, events={42: 1})
    # subtype and phase: 1 completes, 2 resets, 0 and 3 leave the completion byte; the phase returns to 0 for all
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(B(4, 3, 0, (7, 99, 99, 99, 99), 90), subtype), R(B(4, 3, 1, (7, 99, 99, 99, 99), 91), subtype)],
          [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3), ('tick',)], group='subtype', shorts={4: 7},
          quick=subtype in (0, 1, 2))
    S('rows:offset_first_row', [R(B(4, 3, 0, (7, 99, 99, 99, 99), 92)), R(B(4, 3, 0, (7, 99, 99, 99, 99), 93))], [('tick',), ('tick',)], group='rows',
      shorts={4: 7}, first=3, quick=True)
    # random scenarios: random bodies, random worlds, several ticks with rearm
    for n in range(70):
        rows = [R(rand_body(rng), rng.choice((0, 1, 1, 2, 3))) for _ in range(rng.randint(3, 40))]
        acts = []
        for _ in range(rng.randint(2, 5)):
            sh, fl = rand_value_set(rng, rng.choice((0.4, 0.8, 1.0)))
            acts += [('values', sh, fl), ('tick',)]
            if rng.random() < 0.5:
                acts.append(('rearm',))
            if rng.random() < 0.3:
                acts.append(('clearflags',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 4)
    # K1..K3: native refuses before any state change, the original runs (no assertion on its effect)
    rows = [R(B(30, 0, 3, (), 20)), R(B(30, 0, 4, (), 21)), R(B(0, 1, 3, (), 22)), R(B(0, 1, 4, (), 23)), R(B(30, 2, 0, (40, 99, 99, 99, 99), 24)),
            R(B(30, 2, 1, (99, 255, 99, 99, 99), 25)), R(B(30, 3, 0, (7, 99, 99, 99, 99), 1700)), R(B(30, 3, 0, (7, 99, 99, 99, 99), -2)),
            R(B(30, 3, 0, (7, 99, 99, 99, 99), 32767))]
    S('known:K1_K2_K3', rows, [('values', {0: 5, 1: 5, 2: 6}, {0: f32bits(7.0), 1: f32bits(8.0), 2: f32bits(9.0)}), ('tick',)], group='known', quick=True,
      known=True)
    return scs


def corpus_world(rng, chunk):
    shorts, floats = rand_value_set(rng, 0.5)
    for _, body in chunk:
        attr, lit = body[0], body[3]
        if rng.random() < 0.55 and attr < 40:
            value = lit if lit != 99 else 1
            if attr < 30:
                shorts[attr] = value
            else:
                floats[attr - 30] = f32bits(float(value) + rng.choice((0.0, 0.0, 0.5, -0.5)))
    return shorts, floats


def load_corpus():
    """The decoded scene resources' raw-0x4f rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_4f_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('action_family_4f.c', 'session_bindings_a4f.c', 'action_core.c',
                                                                    'scene_resource.c', 'hiff.c')], '-lm', '-o', str(exe)],
                               capture_output=True, text=True)
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
    return dict(scenarios=0, ticks=0, rows_visited=0, rows_gated=0, completions=0, resets=0, flag_compares=0, flags_set=0, rows_found=0,
                value_compares=0, mismatches=0, gate_model_checks=0, native_probes=0, by_mode=Counter(), by_op=Counter(), known_observed=Counter(),
                groups={})


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'], stats['flags_set'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += stats['rows_visited'] - before[1]
        g['flags_set'] += stats['flags_set'] - before[2]
        g['seconds'] += round(time.monotonic() - t0, 2)


def row_gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    nat.reset()
    known_before = Counter(stats['known_observed'])
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    state = dict(mode=sc['mode'], shorts=dict(sc['shorts']), floats=dict(sc['floats']))
    x.set_values(state['shorts'], state['floats'])
    nat.set_values(state['shorts'], state['floats'])
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
        nat.lib.a4fo_set_flag(nat.h, idx, v)
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    compare_state(sc['id'] + ' initial', x, nat, stats)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, sc, rows, first, state, completed, phases, stats)
        elif kind == 'values':
            state['shorts'], state['floats'] = dict(act[1]), dict(act[2])
            x.set_values(act[1], act[2])
            nat.set_values(act[1], act[2])
        elif kind == 'rearm':
            for i in range(first, first + len(rows)):
                completed[i] = 0
                phases[i] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'clearflags':
            x.wr(d9.EVENTS_VA, bytes(4 * FLAG_COUNT))
            for i in range(FLAG_COUNT):
                nat.lib.a4fo_set_flag(nat.h, i, 0)
        elif kind == 'setphase':
            x.w32(ROWS + (first + act[1]) * ROW + PHASE_OFF, act[2])
            phases[first + act[1]] = act[2]
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
                nat.lib.a4fo_set_flag(nat.h, idx, v)
        elif kind == 'mode':
            state['mode'] = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        else:
            raise d9.OracleError('unknown action ' + kind)
    if sc['known']:
        seen = stats['known_observed']
        if not (seen['K3'] > known_before['K3'] and seen['K1/K2'] > known_before['K1/K2']):
            raise Mismatch('%s: the known-difference rows were not all refused natively (K1/K2 and K3 expected)' % sc['id'])
    stats['scenarios'] += 1


def tick(where, x, nat, sc, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    x.dispatch()
    visited = list(x.finish_entries)
    total = first + len(rows)
    if x.handler_entries != visited:
        raise Mismatch('%s: handler entries %s differ from completion entries %s' % (where, x.handler_entries, visited))
    known_rows = []
    expected = []
    # sequential gate model: a row's visit changes the flags the next row's gate reads; native visits run as the model goes
    if state['mode'] == 3:
        for i in range(total):
            if i < first or completed[i]:
                continue
            spec = rows[i - first]
            if not row_gate_open(spec, nat.flag):
                continue
            expected.append(i)
            status_probe = nat.probe(spec['body'])
            stats['native_probes'] += 1
            must_refuse = expected_refusal(spec['body'], state['shorts'], state['floats'])
            if (status_probe != 0) != (must_refuse is not None):
                raise Mismatch('%s: row %d: native kernel status %d but the reference model expects %s' % (where, i, status_probe, must_refuse or 'acceptance'))
            if status_probe != 0:
                # the native kernel refuses (K1/K2/K3): nothing may change natively; the original's in-range effects are copied over below
                before = (nat.flags(), nat.values())
                status, done, reset, phase, disposition = nat.visit(spec['body'], spec['subtype'], completed[i], phases[i])
                if status == 0 or (nat.flags(), nat.values()) != before:
                    raise Mismatch('%s: native did not refuse row %d cleanly (probe %d, status %d)' % (where, i, status_probe, status))
                kind = refusal_kind(spec['body'], status_probe, state['shorts'], state['floats'])
                if kind is None:
                    raise Mismatch('%s: native refused row %d (kernel status %d) outside the declared known differences' % (where, i, status_probe))
                stats['known_observed'][kind] += 1
                flag = struct.unpack_from('<h', spec['body'], 8)[0]
                if 0 <= flag < FLAG_COUNT:
                    known_rows.append(flag)
                # the original completed the row: mirror the executor's bookkeeping for the next tick
                completed[i], phases[i] = (1 if spec['subtype'] == 1 else (0 if spec['subtype'] == 2 else completed[i])), 0
                o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
                o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
                if (completed[i], phases[i]) != (o_done, o_phase) or (spec['subtype'] == 2) != (i in x.resets):
                    raise Mismatch('%s: refused row %d: original completion state (completed %d phase %d) differs from the executor model' %
                                   (where, i, o_done, o_phase))
                continue
            flags_before = nat.flags()
            status, done, reset, phase, disposition = nat.visit(spec['body'], spec['subtype'], completed[i], phases[i])
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            completed[i], phases[i] = done, phase
            body = spec['body']
            stats['by_mode'][body[1]] += 1
            stats['by_op'][body[2]] += 1
            changed = sum(1 for a, b in zip(flags_before, nat.flags()) if a != b)
            stats['flags_set'] += changed
            stats['rows_found'] += changed > 0 or (flags_before != nat.flags())
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            o_reset = x.resets.count(i)
            if (done, phase) != (o_done, o_phase) or reset != o_reset:
                raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d reset %d)' %
                               (where, i, done, phase, reset, o_done, o_phase, o_reset))
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['resets'] += reset
    stats['gate_model_checks'] += 1
    if visited != expected:
        raise Mismatch('%s: original visited rows %s, the gate model expects %s' % (where, visited, expected))
    if sorted(x.resets) != [i for i in expected if rows[i - first]['subtype'] == 2]:
        raise Mismatch('%s: dependency reset calls %s do not match the subtype-2 visits' % (where, x.resets))
    stats['rows_gated'] += sum(1 for i in range(first, total) if not completed[i] and i not in visited) if state['mode'] == 3 else 0
    for i in range(first, total):
        if i not in expected:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    if known_rows:
        # copy the original's value of the flag a refused row targets so the scenario can continue; everything else stays compared
        original = x.flags()
        for flag in set(known_rows):
            nat.lib.a4fo_set_flag(nat.h, flag, original[flag])
    compare_state(where, x, nat, stats)


def compare_state(where, x, nat, stats):
    stats['flag_compares'] += 1
    original, native = x.flags(), nat.flags()
    if original != native:
        bad = [i for i in range(FLAG_COUNT) if original[i] != native[i]][:6]
        raise Mismatch('%s: event flags differ at %s: original %s native %s' % (where, bad, [original[i] for i in bad], [native[i] for i in bad]))
    stats['value_compares'] += 1
    if x.values() != nat.values():
        raise Mismatch('%s: action values differ (original %s native %s)' % (where, x.values().hex(), nat.values().hex()))


def _slot_f32(shorts, floats, slot):
    return float(shorts.get(slot, 9999)) if slot < 30 else bits_f32(floats.get(slot - 30, UNSET_BITS))


def _holds(op, a, b):
    c0, c3 = (True, True) if (a != a or b != b) else (a < b, a == b)
    return [c3, c0, not (c0 or c3), not c0, c0 or c3][op]


def reference_model(body, shorts, floats):
    """Independent re-derivation of 0x44b641 from the disassembly: ('oob', kind) when the original reads outside the 10-byte
    body or the 40 action values before it can stop, else ('ok', found)."""
    attr, mode, op = body[0], body[1], body[2]
    if attr >= 40:
        return ('ok', False)
    cur = _slot_f32(shorts, floats, attr)
    unset = lambda v: f32bits(v) == UNSET_BITS  # noqa: E731
    if unset(cur):
        return ('ok', False)
    if mode in (0, 1):
        for slot in (range(30, 40) if mode == 0 else range(30)):
            other = _slot_f32(shorts, floats, slot)
            if unset(other) or slot == attr or op > 4:
                continue
            if op >= 3:
                if 3 + slot >= 10:
                    return ('oob', 'K1/K2')
                other = float(body[3 + slot])
            if _holds(op, cur, other):
                return ('ok', True)
        return ('ok', False)
    if mode == 2:
        for v in body[3:8]:
            if v == 99:
                continue
            if op > 4:
                continue
            if v >= 40:
                return ('oob', 'K1/K2')
            other = _slot_f32(shorts, floats, v)
            if unset(other):
                continue
            if _holds(op, cur, other):
                return ('ok', True)
        return ('ok', False)
    if mode == 3:
        for i, v in enumerate(body[3:8]):
            if v == 99 or op > 7:
                continue
            if op <= 4:
                if _holds(op, cur, float(v)):
                    return ('ok', True)
            elif i == 0:
                lit = struct.unpack('<f', struct.pack('<f', body[3] * body[4] / 100.0))[0]
                return ('ok', _holds(op - 5 if op == 5 else (3 if op == 6 else 4), cur, lit))
        return ('ok', False)
    return ('ok', False)


def expected_refusal(body, shorts, floats):
    """None when the native kernel must accept the row, else the declared known difference it must refuse with."""
    kind, detail = reference_model(body, shorts, floats)
    if kind == 'oob':
        return detail
    flag = struct.unpack_from('<h', body, 8)[0]
    if detail and flag != -1 and (flag < 0 or flag >= FLAG_COUNT):
        return 'K3'
    return None


def refusal_kind(body, status, shorts, floats):
    """The declared known difference a native refusal belongs to (verified against the reference model), else None."""
    kind = expected_refusal(body, shorts, floats)
    return kind if status != 0 and kind == {3: 'K3', 4: 'K1/K2'}.get(status) else None


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
MUTANTS = {
    'less-than and greater-than swapped': ('case 1: return c0;\n    case 2: return !(c0 || c3);', 'case 1: return !(c0 || c3);\n    case 2: return c0;', 'action_family_4f.c'),
    'greater-or-equal accepts less': ('case 3: case 6: return !c0;', 'case 3: case 6: return !c0 || c3;\n    case 90: return 0;', 'action_family_4f.c'),
    'less-or-equal excludes equal': ('default: return c0 || c3; /* 4, 7 */', 'default: return c0; /* 4, 7 */', 'action_family_4f.c'),
    'equality tests the wrong flag': ('case 0: case 5: return c3;', 'case 0: case 5: return c0;', 'action_family_4f.c'),
    'nan treated as ordered': ('c0 = 1;\n        c3 = 1;', 'c0 = 0;\n        c3 = 0;', 'action_family_4f.c'),
    'unset slots compared': ('if (is_sentinel(other) || slot == d->attribute) {', 'if (slot == d->attribute) {', 'action_family_4f.c'),
    'own slot compared': ('if (is_sentinel(other) || slot == d->attribute) {', 'if (is_sentinel(other)) {', 'action_family_4f.c'),
    'unset attribute evaluated': ('if (is_sentinel(current)) {\n        return ACTION_FAMILY_4F_OK;\n    }', '', 'action_family_4f.c'),
    'attribute limit 39': ('if (decoded->attribute >= ATTRIBUTE_COUNT) {', 'if (decoded->attribute >= ATTRIBUTE_COUNT - 1u) {', 'action_family_4f.c'),
    'unused literal compared': ('if (decoded->operand[i] == 99u || decoded->op > 7u) {', 'if (decoded->op > 7u) {', 'action_family_4f.c'),
    'mode 1 stops one slot short': ('status = scan_slots(decoded, world, current, 0u, LAST_SHORT_SLOT, &found);',
                                    'status = scan_slots(decoded, world, current, 0u, LAST_SHORT_SLOT - 1u, &found);', 'action_family_4f.c'),
    'mode 0 starts one slot late': ('current, ACTION_CORE_SHORT_SLOT_COUNT, ATTRIBUTE_COUNT - 1u, &found);',
                                    'current, ACTION_CORE_SHORT_SLOT_COUNT + 1u, ATTRIBUTE_COUNT - 1u, &found);', 'action_family_4f.c'),
    'mode 2 reads floats as shorts': ('if (slot <= LAST_SHORT_SLOT) {\n        return (float)world->short_values[slot];',
                                      'if (slot <= LAST_SHORT_SLOT + 5u) {\n        return (float)world->short_values[slot % 30u];', 'action_family_4f.c'),
    'percent divisor 10': ('/ 100.0;', '/ 10.0;', 'action_family_4f.c'),
    'percent at every operand': ('} else if (i == 0u) {', '} else {', 'action_family_4f.c'),
    'percent product squares the first operand': ('((double)decoded->operand[0] * (double)decoded->operand[1])',
                                                  '((double)decoded->operand[0] * (double)decoded->operand[0])', 'action_family_4f.c'),
    'flag set to two': ('world->event_flags[decoded->flag] = 1;', 'world->event_flags[decoded->flag] = 2;', 'action_family_4f.c'),
    'false test clears the flag': ('    local.found = (uint8_t)(found != 0);', '    if (!found && decoded->flag >= 0 && world->event_flags != NULL && (size_t)decoded->flag < world->event_flag_count) world->event_flags[decoded->flag] = 0;\n    local.found = (uint8_t)(found != 0);', 'action_family_4f.c'),
    'flag marker minus one ignored': ('if (found && decoded->flag != -1) {', 'if (found && decoded->flag != -2) {', 'action_family_4f.c'),
    'flag index sign lost': ('out->flag = (int16_t)((uint16_t)body[8] | ((uint16_t)body[9] << 8));', 'out->flag = (int16_t)((uint16_t)body[8] | (((uint16_t)body[9] & 0x7fu) << 8));', 'action_family_4f.c'),
    'mode 2 excludes the own slot': ('            other = slot_value(world, slot);\n            if (is_sentinel(other)) {',
                                     '            other = slot_value(world, slot);\n            if (is_sentinel(other) || slot == decoded->attribute) {', 'action_family_4f.c'),
    'every operator 3/4 read refused': ('if (offset >= ACTION_FAMILY_4F_BODY_BYTES) {', 'if (1) {', 'action_family_4f.c'),
    'slot 6 read refused': ('if (offset >= ACTION_FAMILY_4F_BODY_BYTES) {', 'if (offset >= ACTION_FAMILY_4F_BODY_BYTES || slot == 6u) {', 'action_family_4f.c'),
    'operand 40 refused for every operator': ('            if (decoded->op > 4u) {\n                continue; /* the original loads the value, then skips the compare */\n            }\n',
                                              '', 'action_family_4f.c'),
    'flag refused even when the test fails': ('    if (found && decoded->flag != -1) {', '    if (decoded->flag != -1 && (found || decoded->flag >= 1600)) {', 'action_family_4f.c'),
    'phase kept': ('out->phase = 0u; /* 0x42ba3a', 'out->phase = before->phase; /* 0x42ba3a', 'session_bindings_a4f.c'),
    'row completed directly': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'session_bindings_a4f.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-27.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver4f.so')
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
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]
        args.result.write_text(json.dumps(dict(slice='RT-27', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
