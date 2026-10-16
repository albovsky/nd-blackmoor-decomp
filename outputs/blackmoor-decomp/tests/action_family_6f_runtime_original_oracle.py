#!/usr/bin/env python3
"""RT-29: immutable x86 dispatcher 0x427a50 (arm 0x4291b6 -> pop 0x42e493) versus the native raw-0x6f runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x6f (and 0x6e, the push that feeds the pop) the
REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arms
themselves, the pop 0x42e493 that turns the saved scene record at 0x5c3a05..0x5c3a1a into a scene-change request (the globals
0x5bb57b/0x5bb57f/0x5bb599/0x5bb595/0x5bb59b/0x5bb59f/0x5bb5a3/0x5c39ff/0x5bb1ca, engine mode 0x583999 := 4) and 0x42e560 (the
push). All of it is original x86.

Native side: src/session_bindings_a6f.c (+ a6e for the push rows) over src/scene_stack.c, driven by
tests/action_family_6f_runtime_oracle_driver.c with the executor's disposition mapping. The host callback of the pop records the
globals the pop wrote and the scene-change request.

Compared after every dispatcher call (tick):
 * which rows were visited (observed entries of 0x42e493 and 0x42e560, each push with its argument 2), against a gate model
   (event flag dependency records, the world mode word) that also stops the pass after a pop (mode 4: the dispatcher's loop needs
   mode 3 at every row, 0x427a8e);
 * the completion byte and phase dword of every row (the arms set the byte directly and never touch the phase), and that
   neither the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran;
 * the 22 bytes of the saved scene record, the seven running-scene globals, and four memory windows around the destination
   globals (seeded with random bytes): every byte must equal the pre-tick byte unless the pop writes it, and then the native pop
   result decides the value;
 * the scene-change request the host was handed against the globals the original wrote;
 * the empty record (word 0x5c3a05 == 9999): the original reaches its fatal path 0x52139c (expect_fatal); the native handler must
   return an error before any effect.
Besides the dispatcher, the pop is called directly with random records (including near-empty words) and the push is replayed
for the 0x6e rows of the round trips. The initializer window 0x436fe4..0x437011 is covered by the RT-28 oracle.

HOOKS (everything else is original code): O = observed.
  O 0x42e493 pop, 0x42e560 push, 0x42ba3a completion helper, 0x423d33 dependency reset: entry observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run (0x52139c is the expected one
    for the empty-record scenarios)
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the body (the oracle builds the row in memory; the native
decoder and the 25 corpus rows are checked against the decoded scene resources separately), the 25 corpus rows' dependency
records (replayed without them and behind a stand-in record, the gate is shared verified code), what the engine does with mode 4
afterwards (the scene load itself), and how the running scene's words come to hold their values in the real loader (0x439822)
versus the host provider.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_6f_runtime_original_oracle.py --mutations --result <receipt.json>
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

POP = 0x42E493
PUSH = 0x42E560
FATAL = 0x52139C
SLOT_VA = 0x5C3A05
SLOT_BYTES = 22
EMPTY = 0x270F
# the seven running-scene globals 0x42e560 reads (and the pop writes two of): (address, width)
SOURCES = ((0x5BB57B, 4), (0x5BB57F, 4), (0x5BB50B, 2), (0x5BB593, 2), (0x5BB5A7, 4), (0x5BB5AB, 4), (0x5BB5AF, 4))
# memory around the pop's destination globals, seeded with random bytes and compared byte for byte after every tick
WINDOWS = ((0x5BB500, 0x5BB5B3), (0x583960, 0x583A00), (0x5BB1C0, 0x5BB1E0), (0x5C39F0, 0x5C3A60))
SKIP = ((SLOT_VA, SLOT_VA + SLOT_BYTES), (0x5C3A47, 0x5C3A4B))  # the slot is compared separately; the gate writes 0x5c3a47
# the globals the pop writes: (address, width, index into the native pop result)
POP_STORES = ((0x5BB57B, 4, 0), (0x5BB57F, 4, 1), (0x5BB599, 2, 2), (0x5BB595, 2, 3), (0x5C39FF, 2, 4), (0x5BB59B, 4, 5),
              (0x5BB59F, 4, 6), (0x5BB5A3, 4, 7), (0x5BB1CA, 4, 8), (0x583999, 4, 9))
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
MAX_ROWS = 90
POPTYPE, PUSHTYPE = 0x6F, 0x6E

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
    (0x42e493, 0x42e560, 'ad863a5b6157f199732eb975d2f9f9e99ebf6e539ae56df7868eedb397dd1b69'),
    (0x42e560, 0x42e5c6, '1a763d06546b76749f6382a3694a1890fdcb557414518ab6d3c3a591e006d34d'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x52139c, 0x5213d4, '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x6f observers."""

    def __init__(self):
        super().__init__()
        self.pop_entries = []
        self.push_entries = []
        self.finish_entries = []
        self.resets = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    def _install_hooks(self):
        uc = self.machine
        table = {POP: self._pop, PUSH: self._push, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _pop(self, uc, address, size, user):
        self.pop_entries.append(1)

    def _push(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.push_entries.append(u32(uc, sp + 4))

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
        self.pop_entries, self.push_entries, self.finish_entries, self.resets = [], [], [], []

    def set_sources(self, vals):
        for (addr, width), v in zip(SOURCES, vals):
            self.wr(addr, (v & ((1 << (8 * width)) - 1)).to_bytes(width, 'little'))

    def sources(self):
        return tuple(int.from_bytes(self.rd(addr, width), 'little') for addr, width in SOURCES)

    def slot(self):
        return self.rd(SLOT_VA, SLOT_BYTES)

    def set_slot(self, data):
        self.wr(SLOT_VA, data)

    def window_bytes(self):
        return [self.rd(a, z - a) for a, z in WINDOWS]

    def seed_windows(self, rng):
        for a, z in WINDOWS:
            data = bytearray(rng.randrange(256) for _ in range(z - a))
            for lo, hi in SKIP:
                for k in range(max(lo, a), min(hi, z)):
                    data[k - a] = 0
            self.wr(a, bytes(data))

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
            self.wr(base + 0x30, bytes([spec['type'], spec['subtype']]) + struct.pack('<I', body_at))
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
        self.pop_entries, self.push_entries, self.finish_entries, self.resets = [], [], [], []
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'

    def pop_direct(self):
        self.pop_entries = []
        self.mode = 'step'
        try:
            self.call(POP, [], 0)
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_6f_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('scene_stack.c', 'session_bindings_a6e.c', 'session_bindings_a6f.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A6F_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def s_int(value, width):
    value &= (1 << (8 * width)) - 1
    return value - (1 << (8 * width)) if value >> (8 * width - 1) else value


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a6fo_new.restype = C.c_void_p
        lib.a6fo_free.argtypes = [C.c_void_p]
        lib.a6fo_set_current.argtypes = [C.c_void_p, C.c_int32, C.c_int32, C.c_int, C.c_int, C.c_int32, C.c_int32, C.c_int32]
        lib.a6fo_set_refuse.argtypes = [C.c_void_p, C.c_int]
        lib.a6fo_applies.argtypes = [C.c_void_p]
        lib.a6fo_applies.restype = C.c_int
        lib.a6fo_get_slot.argtypes = [C.c_void_p, C.c_char_p]
        lib.a6fo_set_slot.argtypes = [C.c_void_p, C.c_char_p]
        lib.a6fo_get_pop.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a6fo_get_request.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a6fo_pop_direct.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a6fo_pop_direct.restype = C.c_int
        lib.a6fo_push_direct.argtypes = [C.c_void_p, C.c_int32]
        lib.a6fo_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a6fo_visit.restype = C.c_int
        self.h = lib.a6fo_new()

    def close(self):
        self.lib.a6fo_free(self.h)

    def set_sources(self, v):
        self.lib.a6fo_set_current(self.h, s_int(v[0], 4), s_int(v[1], 4), s_int(v[2], 2), s_int(v[3], 2), s_int(v[4], 4),
                                  s_int(v[5], 4), s_int(v[6], 4))

    def slot(self):
        buf = C.create_string_buffer(SLOT_BYTES)
        self.lib.a6fo_get_slot(self.h, buf)
        return buf.raw

    def set_slot(self, data):
        self.lib.a6fo_set_slot(self.h, bytes(data))

    def pop_result(self):
        out = (C.c_int32 * 10)()
        self.lib.a6fo_get_pop(self.h, out)
        return list(out)

    def request(self):
        out = (C.c_int32 * 7)()
        self.lib.a6fo_get_request(self.h, out)
        return list(out)

    def pop_direct(self):
        out = (C.c_int32 * 10)()
        rc = self.lib.a6fo_pop_direct(self.h, out)
        return rc, list(out)

    def visit(self, rtype, subtype, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a6fo_visit(self.h, rtype, subtype, completed, phase, C.byref(done), C.byref(reset), C.byref(new_phase),
                                     C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
INTERESTING = (0, 1, 2, 3, 4, 100, 255, 0x270F, 0x2710, 4700, 6400, 0x7FFF, 0x8000, 0xFFFF, 0x10000, 0x12345678, 0x7FFFFFFF,
               0x80000000, 0xFFFFFFFF, 0xFFFFFFFE)


def rand_sources(rng):
    def word():
        return rng.choice(INTERESTING) & 0xFFFF if rng.random() < 0.5 else rng.randrange(0x10000)

    def dword():
        return rng.choice(INTERESTING) if rng.random() < 0.5 else rng.randrange(1 << 32)
    return (dword(), dword(), word(), word(), dword(), dword(), dword())


def rand_slot(rng, empty=False):
    """A saved record. Unless `empty`, the empty word 0x5c3a05 is avoided (the pop of an empty record is the fatal path)."""
    data = bytearray(rng.randrange(256) for _ in range(SLOT_BYTES))
    if rng.random() < 0.3:  # exercise the type word 1 / small values
        data[8:10] = struct.pack('<h', rng.choice((0, 1, 1, 2, 3, -1, 0x101, 0x100, -0x7FFF)))
    if rng.random() < 0.1:  # words that share a byte with the empty marker
        data[0:2] = struct.pack('<H', rng.choice((0x000F, 0x260F, 0x2700, 0x270E, 0x2710, 0x0F27)))
    word = struct.unpack_from('<h', data, 0)[0]
    if empty:
        data[0:2] = struct.pack('<H', EMPTY)
    elif word == EMPTY:
        data[0:2] = struct.pack('<H', 0x270E)
    return bytes(data)


def R(subtype=1, tail=b'', body=b'\0', rtype=POPTYPE):
    return dict(type=rtype, body=body, subtype=subtype, tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def scenario_list(seed=29, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group,
                        sources=kw.pop('sources', (4700, 4701, 12, 3, 5, 6, 7)), slot=kw.pop('slot', None),
                        events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                        first=kw.pop('first', 0), seed=kw.pop('seed', len(scs))))

    def refill():  # a fresh non-empty record, mode back to 3, the next tick pops the next row
        return [('slot', rand_slot(rng)), ('mode', 3)]

    if corpus:
        for start in range(0, len(corpus), 25):
            chunk = corpus[start:start + 25]
            acts = []
            for _ in chunk:  # one pop per tick: each tick pops the first row still open
                acts += refill() + [('tick',)]
            S('corpus:%d' % (start // 25), [R(st, b'', body) for st, body in chunk], acts, group='corpus', quick=start == 0)
            tails = [R(st, event_tail(1000 + k % 14, 1), body) for k, (st, body) in enumerate(chunk)]
            acts = [('events', {1000 + k: 1 for k in range(0, 14, 2)})]
            for _ in chunk:
                acts += refill() + [('tick',)]
            acts += [('events', {1000 + k: 1 for k in range(14)}), ('rearm',)]
            for _ in chunk:
                acts += refill() + [('tick',)]
            S('corpus_gated:%d' % (start // 25), tails, acts, group='corpus', quick=start == 0)
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(subtype), R(subtype)],
          [('setphase', 0, 5), ('setphase', 1, 9)] + refill() + [('tick',)] + refill() + [('tick',), ('setphase', 0, 3), ('rearm',)] + refill() +
          [('tick',)], group='subtype', quick=subtype in (0, 1, 2))
    S('body:values', [R(1, event_tail(1003, 1) if v & 1 else b'', bytes([v])) for v in (0, 1, 2, 0x80, 0xFF)],
      [('events', {1003: 1})] + refill() + [('tick',)] + refill() + [('tick',)], group='body', quick=True)
    S('gate:event_false_then_true', [R(1, event_tail(40, 1)), R(1)], refill() + [('tick',), ('events', {40: 1})] + refill() +
      [('tick',)] + refill() + [('tick',)], group='gate', events={40: 7}, quick=True)
    S('gate:two_rows_one_tick', [R(1), R(1, event_tail(70, 1)), R(0)], refill() + [('tick',), ('events', {70: 1}), ('rearm',)] + refill() +
      [('tick',)], group='gate', quick=True)
    S('gate:mode4_runs_nothing', [R(1), R(1)], [('slot', rand_slot(rng)), ('tick',)] + refill() + [('tick',)], group='gate', mode=4, quick=True)
    S('pass:stops_after_the_pop', [R(1), R(1, rtype=PUSHTYPE), R(1)], refill() + [('tick',)] + refill() + [('tick',)] + refill() + [('tick',)],
      group='pass', quick=True)
    S('pass:push_before_pop_then_stop', [R(1, rtype=PUSHTYPE), R(1), R(1, rtype=PUSHTYPE)], [('tick',), ('mode', 3), ('rearm',), ('tick',)],
      group='pass', quick=True)
    S('rows:offset_first_row', [R(1), R(1)], refill() + [('tick',)] + refill() + [('tick',)], group='rows', first=3, quick=True)
    for k, (name, slot) in enumerate((
            ('init_values', bytes.fromhex('0f270f27000000000200') + bytes(12)),          # what the game initializer leaves
            ('zero_record', bytes(SLOT_BYTES)),                                          # process start state
            ('empty_word_only_05', struct.pack('<hh', EMPTY, 4700) + bytes(18)),
            ('word_07_marker_only', struct.pack('<hh', 4700, EMPTY) + bytes(18)),
            ('type_word_1', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 1) + bytes(12)),
            ('type_word_2', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 2) + bytes(12)),
            ('type_word_0x101', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 0x101) + bytes(12)),
            ('type_word_0x100', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 0x100) + bytes(12)),
            ('word_05_shares_the_low_byte', struct.pack('<hh', 0x000F, 4710) + bytes(18)),
            ('word_05_shares_the_high_byte', struct.pack('<hh', 0x2700, 4710) + bytes(18)),
            ('scene_negative', struct.pack('<hh', 4700, -2) + bytes(18)))):
        S('slot:' + name, [R(1)], [('tick',)], group='slot', slot=slot, quick=name in ('init_values', 'type_word_1', 'word_07_marker_only', 'type_word_0x101', 'word_05_shares_the_low_byte'))
    S('roundtrip:push_then_pop', [R(1, rtype=PUSHTYPE), R(1)], [('tick',), ('mode', 3), ('rearm',), ('tick',), ('sources', (6400, 6401, 1, 2, 3, 4, 5)),
                                                             ('mode', 3), ('rearm',), ('tick',)], group='roundtrip', slot=bytes(SLOT_BYTES), quick=True)
    S('roundtrip:pop_pop_is_fatal', [R(1, rtype=PUSHTYPE), R(1), R(1)], [('tick',), ('mode', 3), ('tick',)], group='roundtrip',
      slot=bytes(SLOT_BYTES))
    S('roundtrip:separate_ticks_gated', [R(1, event_tail(50, 1), rtype=PUSHTYPE), R(1, event_tail(51, 1))],
      [('tick',), ('events', {50: 1}), ('tick',), ('events', {51: 1}), ('tick',)], group='roundtrip', slot=bytes(SLOT_BYTES))
    S('fatal:empty_after_init', [R(1)], [('tick',)], group='fatal', slot=bytes.fromhex('0f270f27000000000200') + bytes(12), quick=True)
    S('fatal:after_a_push_row', [R(1, rtype=PUSHTYPE), R(1)], [('slot', rand_slot(rng, empty=True)), ('tick',)], group='fatal')
    S('fatal:second_pop_same_tick_never_happens', [R(1), R(1)], [('slot', rand_slot(rng)), ('tick',), ('slot', rand_slot(rng, empty=True)),
                                                               ('mode', 3), ('tick',)], group='fatal')
    for n in range(150):
        rows = []
        for _ in range(rng.randint(1, 30)):
            rows.append(R(rng.choice((0, 1, 1, 1, 2, 3)), event_tail(rng.randrange(1600), rng.randrange(-3, 4)) if rng.random() < 0.3 else b'',
                          rtype=rng.choice((POPTYPE, POPTYPE, POPTYPE, PUSHTYPE))))
        acts = []
        events = {}
        for _ in range(rng.randint(2, 6)):
            acts += [('sources', rand_sources(rng)), ('slot', rand_slot(rng, empty=rng.random() < 0.1)), ('mode', 3), ('tick',)]
            if rng.random() < 0.5:
                acts.append(('events', {r['tail'] and struct.unpack_from('<h', r['tail'], 2)[0] or 0: rng.randrange(-3, 4) for r in rows[:6]}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', sources=rand_sources(rng), events=events, quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw-0x6f rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_6f_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('scene_stack.c', 'session_bindings_a6f.c', 'action_core.c',
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
    return dict(scenarios=0, ticks=0, rows_visited=0, rows_gated=0, completions=0, slot_compares=0, window_compares=0, source_compares=0,
                request_compares=0, pops=0, pushes=0, fatal_paths_matched=0, direct_pops=0, direct_empty=0, mismatches=0,
                gate_model_checks=0, by_subtype=Counter(), groups={})


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
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    x.seed_windows(random.Random(sc['seed'] * 7919 + 1))
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    state = dict(mode=sc['mode'], sources=tuple(sc['sources']), events=dict(sc['events']), fatal=False)
    x.set_sources(state['sources'])
    nat.set_sources(state['sources'])
    slot = sc['slot'] if sc['slot'] is not None else bytes(SLOT_BYTES)
    x.set_slot(slot)
    nat.set_slot(slot)
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    compare_state(sc['id'] + ' initial', x, nat, state, stats)
    for ai, act in enumerate(sc['actions']):
        if state['fatal']:
            break  # the original aborted: its dispatcher cannot continue
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, rows, first, state, completed, phases, stats)
        elif kind == 'sources':
            state['sources'] = tuple(act[1])
            x.set_sources(act[1])
            nat.set_sources(act[1])
        elif kind == 'slot':
            x.set_slot(act[1])
            nat.set_slot(act[1])
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
                x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
        elif kind == 'mode':
            state['mode'] = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def slot_is_empty(slot):
    return struct.unpack_from('<h', slot, 0)[0] == EMPTY


def tick(where, x, nat, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(d9.EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    pre = x.window_bytes()
    pre_slot = x.slot()
    # --- the model: which rows run, in order, until a pop (mode 4) or a fatal empty pop ---
    plan = []  # (row index, expect 'push' / 'pop' / 'fatal')
    if state['mode'] == 3:
        slot_now = pre_slot
        for i in range(first, total):
            if completed[i]:
                continue
            spec = rows[i - first]
            if not row_gate_open(spec, flags):
                continue
            if spec['type'] == PUSHTYPE:
                plan.append((i, 'push'))
                # a push copies the low word of 0x5bb57b into word 0x5c3a05: it can write the empty marker itself
                slot_now = struct.pack('<H', state['sources'][0] & 0xFFFF) + bytes(SLOT_BYTES - 2)
            else:
                plan.append((i, 'fatal' if slot_is_empty(slot_now) else 'pop'))
                break
    fatal_expected = bool(plan) and plan[-1][1] == 'fatal'
    if fatal_expected:
        x.expect_fatal = FATAL
    fatal_seen = False
    try:
        x.dispatch()
    except d9.Fatal as error:
        fatal_seen = error.address == FATAL
        if not fatal_expected or not fatal_seen:
            raise Mismatch('%s: unexpected fatal original path %#x (expected: %s)' % (where, error.address, fatal_expected))
    if fatal_expected and not fatal_seen:
        raise Mismatch('%s: the original did not reach its fatal path for an empty record' % where)
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x6e/0x6f row' % (where, x.finish_entries, x.resets))
    # --- native side: run the same rows ---
    expected_pushes = 0
    popped = None
    visited = []
    for i, what in plan:
        spec = rows[i - first]
        if what == 'fatal':
            applies = nat.lib.a6fo_applies(nat.h)
            before_slot = nat.slot()
            status, done, reset, phase, disposition = nat.visit(spec['type'], spec['subtype'], completed[i], phases[i])
            if status != 2:  # SCENE_ACTION_HANDLER_ERROR
                raise Mismatch('%s: native handler status %d for row %d, expected ERROR for the empty record' % (where, status, i))
            if nat.slot() != before_slot or nat.lib.a6fo_applies(nat.h) != applies:
                raise Mismatch('%s: the native handler changed state before refusing the empty record' % where)
            stats['fatal_paths_matched'] += 1
            state['fatal'] = True
            continue
        status, done, reset, phase, disposition = nat.visit(spec['type'], spec['subtype'], completed[i], phases[i])
        if status != 0:
            raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
        completed[i], phases[i] = done, phase
        o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
        if (done, phase) != (o_done, o_phase) or reset != 0:
            raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d, no reset)' %
                           (where, i, done, phase, reset, o_done, o_phase))
        visited.append(i)
        stats['rows_visited'] += 1
        stats['completions'] += done
        stats['by_subtype'][(spec['type'], spec['subtype'])] += 1
        if what == 'push':
            expected_pushes += 1
            stats['pushes'] += 1
        else:
            popped = nat.pop_result()
            stats['pops'] += 1
    stats['gate_model_checks'] += 1
    exp_pops = sum(1 for _, w in plan if w in ('pop', 'fatal'))
    if len(x.pop_entries) != exp_pops or x.push_entries != [2] * expected_pushes:
        raise Mismatch('%s: original entered the pop %d times and the push with %s; the model expects %d pops and %d pushes of argument 2' %
                       (where, len(x.pop_entries), x.push_entries, exp_pops, expected_pushes))
    stats['rows_gated'] += sum(1 for i in range(first, total) if not completed[i]) if state['mode'] == 3 else 0
    for i in range(first, total):
        if i not in visited:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    # --- the globals: the pre-tick window bytes patched with the native pop result must equal the original's ---
    patched = [bytearray(w) for w in pre]
    if popped is not None:
        for addr, width, k in POP_STORES:
            for wi, (a, z) in enumerate(WINDOWS):
                if a <= addr < z:
                    patched[wi][addr - a:addr - a + width] = (popped[k] & ((1 << (8 * width)) - 1)).to_bytes(width, 'little')
        state['sources'] = (popped[0] & 0xFFFFFFFF, popped[1] & 0xFFFFFFFF) + tuple(state['sources'][2:])
        nat.set_sources(state['sources'])
        state['mode'] = popped[9]
        # the host was handed a request that matches the globals
        req = nat.request()
        want = [s_int(popped[0], 2), popped[2], popped[3], popped[4], popped[5], popped[6], popped[7]]
        if req != want:
            raise Mismatch('%s: scene-change request %s does not match the pop result %s' % (where, req, want))
        stats['request_compares'] += 1
    now = x.window_bytes()
    stats['window_compares'] += 1
    for wi, (a, z) in enumerate(WINDOWS):
        for off in range(z - a):
            va = a + off
            if any(lo <= va < hi for lo, hi in SKIP):
                continue
            if patched[wi][off] != now[wi][off]:
                raise Mismatch('%s: byte %#x original %02x expected %02x (window %#x..%#x)' % (where, va, now[wi][off], patched[wi][off], a, z))
    compare_state(where, x, nat, state, stats)


def compare_state(where, x, nat, state, stats):
    stats['slot_compares'] += 1
    if x.slot() != nat.slot():
        raise Mismatch('%s: saved scene record differs: original %s native %s' % (where, x.slot().hex(), nat.slot().hex()))
    stats['source_compares'] += 1
    expected = tuple(int(v) & ((1 << (8 * w)) - 1) for v, (_, w) in zip(state['sources'], SOURCES))
    if x.sources() != expected:
        raise Mismatch('%s: the original\'s running-scene globals %s differ from the model %s' % (where, x.sources(), expected))


def run_direct(x, nat, stats, count=240, seed=2900):
    """The pop 0x42e493 called directly on random records against scene_stack_pop (including the empty record)."""
    rng = random.Random(seed)
    for n in range(count):
        x.hard_reset()
        x.seed_windows(random.Random(seed + n))
        empty = n % 6 == 5
        slot = rand_slot(rng, empty=empty)
        x.set_slot(slot)
        nat.set_slot(slot)
        pre = x.window_bytes()
        x.expect_fatal = FATAL if empty else None
        try:
            x.pop_direct()
            fatal = False
        except d9.Fatal as error:
            fatal = error.address == FATAL
            if not fatal or not empty:
                raise Mismatch('direct pop %d: unexpected fatal %#x' % (n, error.address))
        rc, res = nat.pop_direct()
        stats['direct_pops'] += 1
        if empty:
            stats['direct_empty'] += 1
            if not fatal or rc != 1 or nat.slot() != slot or x.slot() != slot:
                raise Mismatch('direct pop %d (empty): fatal %s native rc %d' % (n, fatal, rc))
            continue
        if rc != 0 or x.pop_entries != [1]:
            raise Mismatch('direct pop %d: native rc %d, original entries %s' % (n, rc, x.pop_entries))
        patched = [bytearray(w) for w in pre]
        for addr, width, k in POP_STORES:
            for wi, (a, z) in enumerate(WINDOWS):
                if a <= addr < z:
                    patched[wi][addr - a:addr - a + width] = (res[k] & ((1 << (8 * width)) - 1)).to_bytes(width, 'little')
        now = x.window_bytes()
        for wi, (a, z) in enumerate(WINDOWS):
            for off in range(z - a):
                va = a + off
                if any(lo <= va < hi for lo, hi in SKIP):
                    continue
                if patched[wi][off] != now[wi][off]:
                    raise Mismatch('direct pop %d: byte %#x original %02x expected %02x' % (n, va, now[wi][off], patched[wi][off]))
        if x.slot() != nat.slot():
            raise Mismatch('direct pop %d: record original %s native %s' % (n, x.slot().hex(), nat.slot().hex()))
        stats['window_compares'] += 1
        stats['slot_compares'] += 1


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
    'scene taken from word 05': ('r.scene_5bb57b = slot->scene_5c3a07; ', 'r.scene_5bb57b = slot->scene_5c3a05; ', 'scene_stack.c'),
    'second scene global from word 05': ('r.scene_5bb57f = slot->scene_5c3a07; ', 'r.scene_5bb57f = slot->scene_5c3a05; ', 'scene_stack.c'),
    'scene word zero extended': ('r.scene_5bb57b = slot->scene_5c3a07; ', 'r.scene_5bb57b = (uint16_t)slot->scene_5c3a07; ', 'scene_stack.c'),
    'words 599 and 595 swapped': ('r.word_5bb599 = slot->word_5c3a09; ', 'r.word_5bb599 = slot->word_5c3a0b; ', 'scene_stack.c'),
    'word 595 taken from 09': ('r.word_5bb595 = slot->word_5c3a0b; ', 'r.word_5bb595 = slot->word_5c3a09; ', 'scene_stack.c'),
    'dword 59b taken from 13': ('r.dword_5bb59b = slot->dword_5c3a0f; ', 'r.dword_5bb59b = slot->dword_5c3a13; ', 'scene_stack.c'),
    'dword 59f taken from 0f': ('r.dword_5bb59f = slot->dword_5c3a13; ', 'r.dword_5bb59f = slot->dword_5c3a0f; ', 'scene_stack.c'),
    'dword 5a3 not read': ('r.dword_5bb5a3 = slot->dword_5c3a17; ', 'r.dword_5bb5a3 = 0; ', 'scene_stack.c'),
    'flag 5c39ff zero': ('r.word_5c39ff = 1; ', 'r.word_5c39ff = 0; ', 'scene_stack.c'),
    'start flag inverted': ('slot->word_5c3a0d == 1 ? 0 : 1', 'slot->word_5c3a0d == 1 ? 1 : 0', 'scene_stack.c'),
    'start flag for type words up to 1': ('slot->word_5c3a0d == 1 ? 0 : 1', 'slot->word_5c3a0d <= 1 ? 0 : 1', 'scene_stack.c'),
    'start flag tests the low byte': ('slot->word_5c3a0d == 1 ? 0 : 1', '(slot->word_5c3a0d & 0xff) == 1 ? 0 : 1', 'scene_stack.c'),
    'mode 3': ('r.mode_583999 = 4; ', 'r.mode_583999 = 3; ', 'scene_stack.c'),
    'record not emptied (word 07)': ('    slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e555 */\n', '', 'scene_stack.c'),
    'record not emptied (word 05)': ('    slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e54c */\n', '', 'scene_stack.c'),
    'record emptied with zero': ('slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e54c */', 'slot->scene_5c3a05 = 0;', 'scene_stack.c'),
    'dwords cleared by the pop': ('slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e555 */', 'slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER; slot->dword_5c3a17 = 0;', 'scene_stack.c'),
    'empty test on word 07': ('if (slot->scene_5c3a05 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496', 'if (slot->scene_5c3a07 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496', 'scene_stack.c'),
    'empty test on the low byte': ('if (slot->scene_5c3a05 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496', 'if ((slot->scene_5c3a05 & 0xff) == (SCENE_STACK_EMPTY_MARKER & 0xff)) { /* 0x42e496', 'scene_stack.c'),
    'empty record popped anyway': ('        return SCENE_STACK_POP_EMPTY;\n    }\n    r.', '        slot->scene_5c3a05 = 1;\n    }\n    r.', 'scene_stack.c'),
    'phase cleared': ('out->phase = before->phase;', 'out->phase = 0u;', 'session_bindings_a6f.c'),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'session_bindings_a6f.c'),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', 'session_bindings_a6f.c'),
    'subtype 2 resets': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'session_bindings_a6f.c'),
    'pop skipped for subtype 0': ('    if (scene_stack_pop(&popped, &pop) != SCENE_STACK_POP_OK) {', '    if (action->subtype == 0u) { *out = (SceneActionHandlerResult){SCENE_ACTION_HANDLER_DIRECT_COMPLETED, before->phase}; return SCENE_ACTION_HANDLER_OK; }\n    if (scene_stack_pop(&popped, &pop) != SCENE_STACK_POP_OK) {', 'session_bindings_a6f.c'),
    'record kept after the pop': ('    *b->slot = popped;\n', '', 'session_bindings_a6f.c'),
    'empty record accepted': ('        b->failure = "scene stack is empty (0x42e493 aborts)";\n        return SCENE_ACTION_HANDLER_ERROR;', '        b->failure = "scene stack is empty (0x42e493 aborts)";\n        *out = (SceneActionHandlerResult){SCENE_ACTION_HANDLER_DIRECT_COMPLETED, before->phase};\n        return SCENE_ACTION_HANDLER_OK;', 'session_bindings_a6f.c'),
    'request target from the wrong scene': ('request.target_scene = (int16_t)pop.scene_5bb57b;', 'request.target_scene = (int16_t)(pop.scene_5bb57b + 1);', 'session_bindings_a6f.c'),
    'request dword 1 dropped': ('request.opaque_dwords[1] = pop.dword_5bb59f;', 'request.opaque_dwords[1] = pop.dword_5bb59b;', 'session_bindings_a6f.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-29.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver6f.so')
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
    if not bad and not args.only:
        try:
            run_direct(x, nat, stats, count=24 if (args.quick_only or args.mutation_run) else 240)
        except (Mismatch, d9.OracleError) as error:
            bad.append(('direct', str(error)))
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
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (({str(kk): vv for kk, vv in v.items()}) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]
        args.result.write_text(json.dumps(dict(slice='RT-29', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
