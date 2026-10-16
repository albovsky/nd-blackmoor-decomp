#!/usr/bin/env python3
"""RT-38: immutable x86 dispatcher 0x427a50 (arm 0x4287cc, raw type 0x45) versus the native raw-0x45 timer-control runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x45 the REAL dispatcher 0x427a50 runs: dependency
trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), and the arm itself (0x4287cc..0x428cce): the timer record
n = (signed word)body[0] at 0x585d65 + n * 0x106 and the signed word body[2] select one of seven sub-cases through the jump table
0x42ac91 (anything else does nothing): 0 clears the record with the original 0x433bd2, 1 and 2 store the state, 3 and 4 add and
subtract hours/minutes/seconds (state 1, 2, 5 or 6 only; a seconds word >= 5000 reads the loader word table at 0x5adb81), 5 and 6
configure the record (state 1 only: limit values, three text copies, the ten event pair index words, the entries, state := mode).
The arm sets the completion byte itself, except when a sub-case does not apply: the row then stays open and is visited again.
Everything is original x86.

Native side: src/session_bindings_a45.c (the executor's handler contract) with a host that holds the ten timer records and the
word table, driven by tests/action_family_45_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm (observed arm entries) against the open-row model, which rows ran 0x433bd2 (observed entries, in
   order) against the gate model (event flag dependency records, the world mode word) and the body's sub-case;
 * the timer record table: the original's first ten records (every byte, randomly pre-filled with chosen states and extreme time
   values) against the native host's ten records after every visit;
 * the completion byte and phase dword of every row (the arm sets the byte directly, never touches the phase), and that neither
   the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran;
 * the native host calls: the record handed to the binding for each visited row, and the table words it asked for (exactly the
   rows the original completed in sub-cases 3 to 6 with a seconds word >= 5000).
Tagged native safety difference (the only one): a timer index outside the port's ten records (signed word, so also negative ones)
is refused UNSUPPORTED before any effect while the original writes the record anyway; those rows are checked for the refusal and the
original's row state is carried on.

HOOKS (everything else is original code): O = observed.
  O arm entry 0x4287cc (the row is the signed word at [ebp-0x11c]), 0x433bd2 clear entry, 0x42ba3a completion helper, 0x423d33
    dependency reset: entry observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the body (the oracle builds the row in memory; the native
decoders and the 32 corpus rows are checked against the decoded scene resources separately), the corpus rows' real dependency
records (replayed without them and behind a stand-in event record, the gate is shared verified code), the loader word table
beyond index 17685 (the original reads the row array there) and every reader of the timer table (conditions 0x4246bd, the clock,
the task list UI), which belong to other slices.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_45_runtime_original_oracle.py --mutations --result <receipt.json>
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

ARM = 0x4287CC
CLEAR_ROUTINE = 0x433BD2
TIMERS_VA = 0x585D65
WORDS_VA = 0x5ADB81
WORD_BASE, WORD_LIMIT = 5000, 17686   # the table words the oracle sources (below the row array at 0x5bb5b3)
SLOT = 0x106
SLOTS = 10          # the port's records
ORIG_SLOTS = 600    # records below the loader word table (0x5adb81) that far indexes may reach
TYPE = 0x45
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 90
BODY_STRIDE = 0x100
BASE_BODY = 196

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
    (0x433bd2, 0x433c60, 'dfa7ec5114c85c569a673364b571e731097a5b58eb3c8b320bbf8feb907c5666'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x45 observers."""

    def __init__(self):
        super().__init__()
        self.entries = []
        self.clears = []
        self.finish_entries = []
        self.resets = []
        self.pins = []
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
        table = {ARM: self._entry, CLEAR_ROUTINE: self._clear, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _entry(self, uc, address, size, user):
        self.entries.append((TYPE, self._row_at_arm(uc)))

    def _clear(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        offset = u32(uc, sp + 4) - TIMERS_VA
        if offset % SLOT or not -8 * SLOT <= offset < ORIG_SLOTS * SLOT:
            raise d9.OracleError('0x433bd2 called with offset %#x, not a timer record' % offset)
        self.clears.append(offset // SLOT)

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
        self.entries, self.clears, self.finish_entries, self.resets = [], [], [], []

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
            body_at = d9.BODY_BASE + BODY_STRIDE * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([TYPE, spec['subtype']]) + struct.pack('<I', body_at))
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
        self.entries, self.clears, self.finish_entries, self.resets = [], [], [], []
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
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_45_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a45.c', 'session_bindings_a65_a68_a69.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A45_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a45o_new.restype = C.c_void_p
        lib.a45o_free.argtypes = [C.c_void_p]
        lib.a45o_set_records.argtypes = [C.c_void_p, C.c_char_p]
        lib.a45o_get_records.argtypes = [C.c_void_p, C.c_char_p]
        lib.a45o_set_words.argtypes = [C.c_void_p, C.c_char_p]
        lib.a45o_log_count.argtypes = [C.c_void_p]
        lib.a45o_log_count.restype = C.c_uint
        lib.a45o_log_at.argtypes = [C.c_void_p, C.c_uint]
        lib.a45o_log_at.restype = C.c_int32
        lib.a45o_log_clear.argtypes = [C.c_void_p]
        lib.a45o_clear_kernel.argtypes = [C.c_char_p]
        lib.a45o_word_limit.restype = C.c_uint
        if lib.a45o_word_limit() != WORD_LIMIT:
            raise d9.OracleError('driver word table limit differs from the oracle')
        lib.a45o_visit.argtypes = [C.c_void_p, C.c_int, C.c_char_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                   C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a45o_visit.restype = C.c_int
        self.h = lib.a45o_new()

    def close(self):
        self.lib.a45o_free(self.h)

    def set_records(self, data):
        self.lib.a45o_set_records(self.h, bytes(data))

    def set_words(self, words):
        self.lib.a45o_set_words(self.h, struct.pack('<%dh' % WORD_LIMIT, *words))

    def records(self):
        buf = C.create_string_buffer(SLOTS * SLOT)
        self.lib.a45o_get_records(self.h, buf)
        return buf.raw

    def log(self):
        out = [self.lib.a45o_log_at(self.h, i) for i in range(self.lib.a45o_log_count(self.h))]
        self.lib.a45o_log_clear(self.h)
        return out

    def kernel_clear(self):
        buf = C.create_string_buffer(SLOT)
        self.lib.a45o_clear_kernel(buf)
        return buf.raw

    def visit(self, subtype, body, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a45o_visit(self.h, subtype, bytes(body), len(body), completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
FILL = random.Random(4545)
VALUES = [0, 1, 2, 3, 59, 60, 61, 100, 3599, 3600, -1, -2, -5, -60, -100, 32767, 32768, 2 ** 31 - 1, -2 ** 31, 0x7FFFFF00,
          0x00124F80, 1000, 4999, 5000]
STATES = [0, 1, 1, 1, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7, 8, 0xFFFFFFFF, 0x80000001]
WORDVALS = [0, 1, 2, 5, 59, 60, 61, 100, 300, 1500, -1, -5, -60, -100, 32767, -32768]
SECS = [-32768, -1, 0, 1, 3, 5, 33, 53, 59, 60, 4998, 4999, 5000, 5001, 5004, 5005, 9000, 17685, 12345]


def body45(record, mode, hours=0, minutes=0, seconds=0, entries=(), count=None, name=None, text=None, payload=None):
    """A raw 0x45 body (typed part): record word, mode word, h/m/s words, 49/33/100 filler bytes, signed count, entries."""
    n = len(entries) if count is None else count
    b = bytearray(BASE_BODY)
    struct.pack_into('<5h', b, 0, record, mode, hours, minutes, seconds)
    b[12:61] = name or bytes(FILL.randrange(256) for _ in range(49))
    b[61:94] = text or bytes(FILL.randrange(256) for _ in range(33))
    b[94:194] = payload or bytes(FILL.randrange(256) for _ in range(100))
    struct.pack_into('<h', b, 194, n)
    for e in entries:
        b += struct.pack('<I', e)
    return bytes(b)


def R(record, mode, hours=0, minutes=0, seconds=0, entries=(), subtype=1, tail=b'', **kw):
    return dict(subtype=subtype, body=body45(record, mode, hours, minutes, seconds, entries, **kw), tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def real_entries(rng, count):
    return [rng.getrandbits(32) for _ in range(count)]


def scenario_list(seed=38, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, events=kw.pop('events', {}),
                        mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0), seed=rng.randrange(1 << 30),
                        wide=kw.pop('wide', False), states=kw.pop('states', None), tame=kw.pop('tame', False)))

    def secs():
        return rng.choice(SECS)

    if corpus:
        for start in range(0, len(corpus), 12):
            chunk = corpus[start:start + 12]
            rows = [dict(subtype=st, body=body, tail=b'') for st, body in chunk]
            S('corpus:%d' % (start // 12), rows, [('tick',), ('rearm',), ('tick',)], group='corpus', quick=start == 0,
              states={n: 1 for n in range(SLOTS)}, tame=True)
            tails = [dict(subtype=st, body=body, tail=event_tail(1000 + k % 14, 1)) for k, (st, body) in enumerate(chunk)]
            acts = [('tick',), ('events', {1000 + k: 1 for k in range(0, 14, 2)}), ('tick',), ('rearm',),
                    ('events', {1000 + k: 1 for k in range(14)}), ('tick',)]
            S('corpus_gated:%d' % (start // 12), tails, acts, group='corpus', quick=start == 0, tame=True)
            S('corpus_random_states:%d' % (start // 12), rows, [('tick',), ('rearm',), ('tick',)], group='corpus')
    # every sub-case against every state of interest: one record per state (the ten records), rows in record order
    state_of = [0, 1, 2, 3, 4, 5, 6, 7, 1, 5]
    for mode in range(-1, 9):
        rows = [R(n, mode, rng.choice((0, 1, 2, -1, 7)), rng.choice((0, 3, -2, 59)), rng.choice(SECS),
                  real_entries(rng, rng.randrange(0, 5))) for n in range(SLOTS)]
        S('mode:%d' % mode, rows, [('tick',), ('tick',), ('rearm',), ('tick',)], group='mode', quick=mode in (-1, 0, 3, 5, 6, 7),
          states={n: state_of[n] for n in range(SLOTS)})
        S('mode_all_states:%d' % mode, [R(n, mode, 1, 1, 7) for n in range(SLOTS)], [('tick',), ('rearm',), ('tick',)], group='mode',
          states={n: (0xFFFFFFFF if n == 9 else n) for n in range(SLOTS)})
    # arithmetic edges: sub-cases 3 and 4 on running timers with extreme record values and every seconds form
    for mode in (3, 4):
        for k, sec in enumerate(SECS):
            S('arith:%d:%d' % (mode, k), [R(2, mode, rng.choice(VALUES[:15]), rng.choice(VALUES[:15]), sec)] * 2, [('tick',), ('rearm',), ('tick',)],
              group='arith', quick=k in (4, 11, 12, 16), states={2: rng.choice((1, 2, 5, 6))})
        for h in (0, 1, -1, 32767, -32768):
            for m in (0, 1, -1, 32767, -32768):
                S('arith_hm:%d:%d:%d' % (mode, h, m), [R(1, mode, h, m, rng.choice((0, 7, -7)))], [('tick',)], group='arith', quick=(h, m) in ((32767, -32768), (-1, 1)),
                  states={1: rng.choice((1, 2, 5, 6))})
    # configure: counts 0..10, both modes, the entries, and the word-only write of the ten event pairs
    for mode in (5, 6):
        for count in range(0, 11):
            S('config:%d:%d' % (mode, count), [R(3, mode, rng.randrange(-5, 30), rng.randrange(-5, 70), rng.choice(SECS), real_entries(rng, count))],
              [('tick',), ('tick',)], group='config', quick=count in (0, 1, 4, 10), states={3: 1})
        for sec in (4998, 4999, 5000, 5001, 5004, 17685, 33):
            S('config_sec:%d:%d' % (mode, sec), [R(4, mode, 1, 2, sec, real_entries(rng, 2))], [('tick',)], group='config', quick=sec in (4999, 5000, 17685), states={4: 1})
        S('config_double_visit:%d' % mode, [R(5, mode, 2, 3, 4, real_entries(rng, 3)), R(5, mode, 9, 9, 9, real_entries(rng, 1))],
          [('tick',), ('rearm',), ('tick',)], group='config', quick=True, states={5: 1})
    # ordering and pending revisit on one record
    S('order:pending_then_start', [R(2, 3, 0, 0, 5), R(2, 1), R(2, 3, 0, 0, 5)], [('tick',), ('tick',), ('rearm',), ('tick',)], group='order',
      quick=True, states={2: 0})
    S('order:configure_then_add', [R(6, 3, 0, 1, 1), R(6, 5, 1, 1, 1, [7, 8]), R(6, 3, 0, 1, 1), R(6, 4, 1, 0, 0), R(6, 6, 1, 1, 1)],
      [('tick',), ('tick',), ('rearm',), ('tick',), ('tick',)], group='order', quick=True, states={6: 1})
    S('order:clear_start_configure_stop', [R(7, 0), R(7, 1), R(7, 5, 1, 2, 3, [4]), R(7, 2), R(7, 3, 1, 1, 1), R(7, 0), R(7, 6, 1, 1, 1)],
      [('tick',), ('rearm',), ('tick',), ('tick',)], group='order', quick=True, states={7: 5})
    S('order:twice_in_one_scene', [R(1, 5, 1, 1, 1, [1]), R(1, 6, 2, 2, 2, [2]), R(1, 3, 1, 1, 1)], [('tick',), ('rearm',), ('tick',)], group='order',
      states={1: 1})
    # subtype and phase never matter
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(3, 5, 0, 1, 3, [5], subtype=subtype), R(4, 3, 0, 0, 1, subtype=subtype), R(5, 0, subtype=subtype)],
          [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3), ('rearm',), ('tick',)], group='subtype',
          quick=subtype in (0, 1, 255), states={3: 1, 4: 1, 5: 1})
    # indexes outside the port's records (the native binding refuses; the original writes the record anyway)
    for i in (10, 11, 99, 100, 127, 128, 200, 255, 256, 266, 512, 522, 599, -1, -2, -3):
        S('beyond:%d' % i, [R(i, 0), R(i, 1), R(i, 5, 1, 1, 1, [2]), R(i, 3, 1, 1, 1), R(2, 1)], [('tick',), ('rearm',), ('tick',)], group='beyond',
          wide=True, quick=i in (10, 255, 256, -1), states={i: 1} if i >= 0 else None)
    S('beyond:mixed_with_valid', [R(12, 5, 1, 1, 1), R(4, 5, 1, 1, 1, [3]), R(250, 0), R(9, 3, 1, 1, 1), R(-1, 4, 0, 0, 1), R(0, 1)],
      [('tick',), ('rearm',), ('tick',)], group='beyond', wide=True, quick=True, states={4: 1, 9: 1})
    # gates
    S('gate:event_false_leaves_table', [R(3, 5, 1, 1, 1, [1], tail=event_tail(1040, 1)), R(4, 0, tail=event_tail(1041, 1)), R(5, 1, tail=event_tail(1042, 1))],
      [('tick',), ('tick',)], group='gate', events={1040: 7, 1041: 7, 1042: 7}, quick=True, states={3: 1, 4: 1})
    S('gate:event_false_then_true', [R(3, 5, 1, 1, 1, [1], tail=event_tail(1040, 1)), R(3, 6, 1, 1, 1, tail=event_tail(1040, 1)), R(3, 3, 0, 0, 1)],
      [('tick',), ('tick',), ('events', {1040: 1}), ('rearm',), ('tick',), ('tick',)], group='gate', events={1040: 7}, quick=True, states={3: 1})
    S('gate:two_rows_one_tick', [R(1, 1), R(2, 0, tail=event_tail(1070, 1)), R(3, 5, 1, 1, 1, [9])], [('tick',), ('events', {1070: 1}), ('rearm',), ('tick',)],
      group='gate', quick=True, states={3: 1})
    S('gate:mode4_runs_nothing', [R(1, 1), R(3, 5, 1, 1, 1), R(2, 0)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, quick=True, states={3: 1})
    S('rows:offset_first_row', [R(1, 1), R(2, 5, 1, 1, 1, [4]), R(3, 0)], [('tick',), ('tick',)], group='rows', first=3, quick=True, states={2: 1})
    S('rows:revisit_after_rearm', [R(8, 5, 1, 1, 1, [4, 5])], [('tick',), ('tick',), ('rearm',), ('tick',)], group='rows', quick=True, states={8: 1})
    for n in range(60):
        rows = []
        for _ in range(rng.randint(1, 30)):
            mode = rng.choice((0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, -1))
            tail = event_tail(1000 + rng.randrange(100), rng.randrange(-3, 4)) if rng.random() < 0.3 else b''
            rows.append(R(rng.randrange(SLOTS), mode, rng.choice(VALUES[:16]), rng.choice(VALUES[:16]), secs(), real_entries(rng, rng.randrange(0, 11)),
                          subtype=rng.choice((0, 1, 1, 1, 2, 3)), tail=tail))
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('events', {1000 + rng.randrange(100): rng.randrange(-3, 4) for _ in range(6)}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x45 rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_45_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a45.c', 'session_bindings_a65_a68_a69.c', 'scene_resource.c', 'hiff.c')],
                                '-lm', '-o', str(exe)],
                               capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        _type, subtype, hexbody, _tail = line.split()
        rows.append((int(subtype), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, rows_completed=0, rows_pending=0, table_compares=0,
                table_bytes=0, mismatches=0, clears_checked=0, beyond_rows=0, native_refusals=0, word_reads=0, by_mode=Counter(),
                by_mode_completed=Counter(), by_subtype=Counter(), groups={})


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
    def __init__(self, sc, rows, first, words):
        self.sc, self.rows, self.first = sc, rows, first
        self.mode = sc['mode']
        self.completed = [1 if i < first else 0 for i in range(first + len(rows))]
        self.phases = [0] * (first + len(rows))
        self.words = words


def make_table(rng, slots, states, tame):
    t = bytearray(rng.getrandbits(8) for _ in range(slots * SLOT))
    for n in range(slots):
        base = n * SLOT
        state = states[n] if states and n in states else rng.choice(STATES)
        struct.pack_into('<I', t, base, state)
        for off in (4, 8, 0xC, 0x10):
            value = rng.choice((0, 1, 5, 30)) if tame else rng.choice(VALUES)
            struct.pack_into('<i', t, base + off, max(-2 ** 31, min(2 ** 31 - 1, value)))
    return bytes(t)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    rng = random.Random(sc['seed'])
    slots = ORIG_SLOTS if sc['wide'] else SLOTS
    if sc['wide'] and sc['events']:
        raise d9.OracleError('the wide table overlaps the event flags')
    table = make_table(rng, slots, sc['states'], sc['tame'])
    x.wr(TIMERS_VA, table)
    nat.set_records(table[:SLOTS * SLOT])
    words = [0] * WORD_LIMIT
    for i in range(WORD_BASE, WORD_LIMIT):
        words[i] = rng.choice(WORDVALS) if rng.random() < 0.7 else rng.randrange(-32768, 32768)
    x.wr(WORDS_VA + 2 * WORD_BASE, struct.pack('<%dh' % (WORD_LIMIT - WORD_BASE), *words[WORD_BASE:]))
    nat.set_words(words)
    nat.log()
    st = Scenario(sc, rows, first, words)
    compare_table('%s initial' % sc['id'], x, nat, stats)
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


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    x.dispatch()
    rows, first = st.rows, st.first
    total = first + len(rows)
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x45 row' % (where, x.finish_entries, x.resets))
    expected_entered, visited = [], []
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    nat.log()
    native_expected, clears_expected = [], []
    if st.mode == 3:
        for i in range(first, total):
            if st.completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append((TYPE, i))
            if not row_gate_open(spec, flags):
                continue
            visited.append(i)
            body = spec['body']
            record, mode, _h, _m, seconds = struct.unpack_from('<5h', body, 0)
            beyond = not 0 <= record < SLOTS
            if mode == 0:
                clears_expected.append(record)
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if not beyond:
                native_expected.append(record)
                if o_done and 3 <= mode <= 6 and seconds >= WORD_BASE:
                    native_expected.append(100000 + seconds)
                    stats['word_reads'] += 1
            status, done, reset, phase, disposition = nat.visit(spec['subtype'], body, st.completed[i], st.phases[i])
            if beyond:
                stats['beyond_rows'] += 1
                if status != 1:
                    raise Mismatch('%s: row %d (record %d) the native binding returned status %d, expected UNSUPPORTED' % (where, i, record, status))
                stats['native_refusals'] += 1
                done, phase, reset = o_done, o_phase, 0   # the refusal is the one tagged difference; carry the original's row state
            elif status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            st.completed[i], st.phases[i] = done, phase
            if (done, phase) != (o_done, o_phase) or reset != 0:
                raise Mismatch('%s: row %d (mode %d) native (completed %d phase %d reset %d) original (completed %d phase %d, no reset)' %
                               (where, i, mode, done, phase, reset, o_done, o_phase))
            stats['rows_visited'] += 1
            stats['rows_completed' if done else 'rows_pending'] += 1
            stats['by_mode'][mode if -1 <= mode <= 7 else 8] += 1
            if done:
                stats['by_mode_completed'][mode if -1 <= mode <= 7 else 8] += 1
            stats['by_subtype'][spec['subtype']] += 1
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.clears != clears_expected:
        raise Mismatch('%s: the original ran 0x433bd2 on records %s, the gate/sub-case model expects %s' % (where, x.clears, clears_expected))
    native_log = nat.log()
    if native_log != native_expected:
        raise Mismatch('%s: the native host calls %s differ from the expected %s' % (where, native_log, native_expected))
    stats['clears_checked'] += len(x.clears)
    stats['rows_gated'] += len(expected_entered) - len(visited)
    for i in range(first, total):
        if i not in visited:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (st.completed[i], st.phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    compare_table(where, x, nat, stats)


def compare_table(where, x, nat, stats):
    stats['table_compares'] += 1
    stats['table_bytes'] += SLOTS * SLOT
    original = x.rd(TIMERS_VA, SLOTS * SLOT)
    native = nat.records()
    if native != original:
        at = next(i for i in range(SLOTS * SLOT) if native[i] != original[i])
        raise Mismatch('%s: the native timer records differ from the original at record %d offset %#x (native %#x original %#x)' %
                       (where, at // SLOT, at % SLOT, native[at], original[at]))


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
BIND = 'session_bindings_a45.c'
HEAD = 'session_bindings_a45.h'
MUTANTS = {
    'mode 1 stores 2': ('rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);            /* 0x428877, 0x42889c */',
                        'rec_put(r, SESSION_TIMER_STATE, 2u);', BIND),
    'mode 2 stores 1': ('rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);            /* 0x428877, 0x42889c */',
                        'rec_put(r, SESSION_TIMER_STATE, 1u);', BIND),
    'mode 0 clears nothing': ('        session_timer_record_clear(r);                              /* 0x428850 */', '        (void)r;', BIND),
    'mode 0 leaves the state': ('        session_timer_record_clear(r);                              /* 0x428850 */',
                                '        { uint32_t keep = rec_get(r, 0u); session_timer_record_clear(r); rec_put(r, 0u, keep); }', BIND),
    'gate drops state 1': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 2u || state == 5u || state == 6u;', BIND),
    'gate drops state 2': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 1u || state == 5u || state == 6u;', BIND),
    'gate drops state 5': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 1u || state == 2u || state == 6u;', BIND),
    'gate drops state 6': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 1u || state == 2u || state == 5u;', BIND),
    'gate accepts state 0': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 0u || state == 1u || state == 2u || state == 5u || state == 6u;', BIND),
    'gate accepts state 3': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 1u || state == 2u || state == 3u || state == 5u || state == 6u;', BIND),
    'gate accepts state 4': ('return state == 1u || state == 2u || state == 5u || state == 6u;', 'return state == 1u || state == 2u || state == 4u || state == 5u || state == 6u;', BIND),
    'add and subtract swapped': ('adjust(r, body, seconds, mode == 4);', 'adjust(r, body, seconds, mode == 3);', BIND),
    'hours subtract sign': ('hours = subtract ? hours - (uint32_t)h : hours + (uint32_t)h;', 'hours = subtract ? hours + (uint32_t)h : hours + (uint32_t)h;', BIND),
    'minutes add sign': ('minutes = subtract ? minutes - (uint32_t)m : minutes + (uint32_t)m;', 'minutes = subtract ? minutes - (uint32_t)m : minutes - (uint32_t)m;', BIND),
    'seconds subtract sign': ('secs = subtract ? secs - (uint32_t)seconds : secs + (uint32_t)seconds;', 'secs = subtract ? secs + (uint32_t)seconds : secs + (uint32_t)seconds;', BIND),
    'hours not clamped': ('hours = (int32_t)hours < 0 ? 0u : hours;', '', BIND),
    'minutes not clamped': ('minutes = (int32_t)minutes < 0 ? 0u : minutes;', '', BIND),
    'seconds not clamped': ('secs = (int32_t)secs < 0 ? 0u : secs;', '', BIND),
    'clamp also on addition': ('    if (subtract) {                                                 /* 0x428a77..0x428ac2: each below zero becomes zero */',
                               '    if (1) {', BIND),
    'clamp is unsigned': ('hours = (int32_t)hours < 0 ? 0u : hours;', 'hours = hours > 0x7fffffffu ? hours : hours;', BIND),
    'hours per ms': ('#define MS_PER_HOUR 0x36ee80u', '#define MS_PER_HOUR 0x36ee81u', BIND),
    'minutes per ms': ('#define MS_PER_MINUTE 0xea60u', '#define MS_PER_MINUTE 0xea61u', BIND),
    'seconds per ms': ('#define MS_PER_SECOND 0x3e8u', '#define MS_PER_SECOND 0x3e9u', BIND),
    'elapsed ms not stored': ('    rec_put(r, SESSION_TIMER_ELAPSED_MS, milliseconds(hours, minutes, secs));', '    (void)milliseconds;', BIND),
    'table base 5001': ('#define SESSION_A45_VARIABLE_BASE 0x1388', '#define SESSION_A45_VARIABLE_BASE 0x1389', HEAD),
    'table base 4999': ('#define SESSION_A45_VARIABLE_BASE 0x1388', '#define SESSION_A45_VARIABLE_BASE 0x1387', HEAD),
    'table word unsigned': ('    *value = table;', '    *value = (int32_t)(uint16_t)table;', BIND),
    'table index shifted': ('b->host.variable_word(b->host.context, word, &table)', 'b->host.variable_word(b->host.context, (int16_t)(word - 1), &table)', BIND),
    'table word ignored': ('    *value = table;', '    *value = word; (void)table;', BIND),
    'limit hours stored in minutes': ('rec_put(r, SESSION_TIMER_LIMIT_HOURS, hours);', 'rec_put(r, SESSION_TIMER_LIMIT_HOURS, minutes);', BIND),
    'limit minutes zero': ('rec_put(r, SESSION_TIMER_LIMIT_MINUTES, minutes);', 'rec_put(r, SESSION_TIMER_LIMIT_MINUTES, 0u);', BIND),
    'limit seconds not stored': ('rec_put(r, SESSION_TIMER_LIMIT_SECONDS, (uint32_t)seconds);', '', BIND),
    'limit ms wrong': ('rec_put(r, SESSION_TIMER_LIMIT_MS, milliseconds(hours, minutes, (uint32_t)seconds));', 'rec_put(r, SESSION_TIMER_LIMIT_MS, milliseconds(hours, minutes, 0u));', BIND),
    'name copy short': ('#define NAME_BYTES 49u', '#define NAME_BYTES 48u', BIND),
    'text copy short': ('#define TEXT_BYTES 33u', '#define TEXT_BYTES 32u', BIND),
    'payload copy short': ('#define PAYLOAD_BYTES 100u', '#define PAYLOAD_BYTES 99u', BIND),
    'name copy offset': ('memcpy(r + 0x28u, body + SESSION_A45_BODY_NAME, NAME_BYTES);', 'memcpy(r + 0x29u, body + SESSION_A45_BODY_NAME, NAME_BYTES);', BIND),
    'text copy offset': ('memcpy(r + 0x59u, body + SESSION_A45_BODY_TEXT, TEXT_BYTES);', 'memcpy(r + 0x5au, body + SESSION_A45_BODY_TEXT, TEXT_BYTES);', BIND),
    'payload from the wrong body offset': ('memcpy(r + 0x7au, body + SESSION_A45_BODY_PAYLOAD, PAYLOAD_BYTES);', 'memcpy(r + 0x7au, body + SESSION_A45_BODY_PAYLOAD + 1u, PAYLOAD_BYTES);', BIND),
    'pair words not set': ('        r[0xdeu + 4u * k + 1u] = 0xffu;\n    }\n    for (k = 0u; k < count; ++k) {', '    }\n    for (k = 0u; k < count; ++k) {', BIND),
    'pair high word set too': ('        r[0xdeu + 4u * k + 1u] = 0xffu;\n    }\n    for (k = 0u; k < count; ++k) {', '        r[0xdeu + 4u * k + 1u] = 0xffu;\n        r[0xdeu + 4u * k + 2u] = 0xffu;\n    }\n    for (k = 0u; k < count; ++k) {', BIND),
    'pair loop one short': ('for (k = 0u; k < PAIR_COUNT; ++k) {', 'for (k = 0u; k + 1u < PAIR_COUNT; ++k) {', BIND),
    'entries one short': ('for (k = 0u; k < count; ++k) {                                  /* 0x428c37..0x428c9c: whole dwords */', 'for (k = 0u; k + 1u < count; ++k) {', BIND),
    'entries one extra': ('for (k = 0u; k < count; ++k) {                                  /* 0x428c37..0x428c9c: whole dwords */', 'for (k = 0u; k <= count && k < 10u; ++k) {', BIND),
    'entries only low word': ('memcpy(r + 0xdeu + 4u * k, body + SESSION_A45_BODY_ENTRIES + 4u * k, 4u);', 'memcpy(r + 0xdeu + 4u * k, body + SESSION_A45_BODY_ENTRIES + 4u * k, 2u);', BIND),
    'reserved dword kept': ('rec_put(r, SESSION_TIMER_RESERVED_14, 0u);', '', BIND),
    'configure state fixed 5': ('rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);                /* 0x428cab..0x428cb8 */', 'rec_put(r, SESSION_TIMER_STATE, 5u + 0u * (uint32_t)mode);', BIND),
    'configure state not stored': ('rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);                /* 0x428cab..0x428cb8 */', '(void)mode;', BIND),
    'configure runs for state 2': ('} else if (rec_get(r, SESSION_TIMER_STATE) != 1u) {              /* 0x428b1b */', '} else if (rec_get(r, SESSION_TIMER_STATE) != 1u && rec_get(r, SESSION_TIMER_STATE) != 2u) {', BIND),
    'configure runs for any state': ('} else if (rec_get(r, SESSION_TIMER_STATE) != 1u) {              /* 0x428b1b */', '} else if (0) {', BIND),
    'mode 7 configures': ('if (mode < 0 || (unsigned)mode >= SESSION_A45_MODE_COUNT) {', 'if (mode < 0 || (unsigned)mode > SESSION_A45_MODE_COUNT) {', BIND),
    'negative mode taken as signed': ('if (mode < 0 || (unsigned)mode >= SESSION_A45_MODE_COUNT) {', 'if (mode >= (int)SESSION_A45_MODE_COUNT) {', BIND),
    'record index unsigned': ('record_index = body_s16(body, SESSION_A45_BODY_RECORD);         /* movsx 0x428810 */',
                              'record_index = (int16_t)(uint8_t)body_s16(body, SESSION_A45_BODY_RECORD);', BIND),
    'record index off by one': ('r = record_index < 0 ? NULL : b->host.time_record(b->host.context, (unsigned)record_index);',
                                'r = record_index < 0 ? NULL : b->host.time_record(b->host.context, (unsigned)record_index + 1u);', BIND),
    'out of range index written anyway': ('    if (r == NULL) {\n        b->failure = "timer index outside', '    if (0) {\n        b->failure = "timer index outside', BIND),
    'phase cleared': ('out->phase = before->phase;                                     /* the phase word is never written */', 'out->phase = 0u;', BIND),
    'phase advanced': ('out->phase = before->phase;                                     /* the phase word is never written */', 'out->phase = before->phase + 1u;', BIND),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* the completion byte := 1 by the arm itself */', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', BIND),
    'dependency reset requested': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* the completion byte := 1 by the arm itself */', 'out->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', BIND),
    'pending rows completed': ('out->disposition = SCENE_ACTION_HANDLER_PENDING;            /* the row is visited again next tick */', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', BIND),
    'completed rows left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* the completion byte := 1 by the arm itself */', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', BIND),
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
    work = Path(tempfile.mkdtemp(prefix='RT-38.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver45.so')
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
        args.result.write_text(json.dumps(dict(slice='RT-38', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
