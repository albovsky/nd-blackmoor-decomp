#!/usr/bin/env python3
"""RT-37: immutable x86 dispatcher 0x427a50 (arms 0x4285fd, 0x4286d8, 0x42875d) versus the native raw-0x65/0x68/0x69 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x65, 0x68 and 0x69 the REAL dispatcher 0x427a50
runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), and the arms themselves:
  0x65: for a true gate `ecx = 0x5e2e70; push 0; push "SAVE CONTINUE"; call 0x4d7a15`, then the row's completion byte := 1;
  0x68: record = (unsigned byte)body[0] * 0x106 + 0x585d65, the original 0x433bd2 clears it, dword [record] := 1, completion := 1;
  0x69: the same clear without the dword store.
Everything is original x86 except the save routine 0x4d7a15 (a recorder: it is the whole-game save writer, a host boundary).

Native side: src/session_bindings_a65_a68_a69.c (the executor's handler contract) with a host that holds the ten timer records and
logs the save call, driven by tests/action_family_65_68_69_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered an arm (observed arm entries) against the open-row model, which rows ran the effect (observed 0x4d7a15 /
   0x433bd2 entries, in order) against a gate model (event flag dependency records, the world mode word), and for 0x65 that the
   save call received ECX 0x5e2e70, the 14 bytes "SAVE CONTINUE\\0" and the second argument 0;
 * the native effect log (save call, record index handed to the binding) against the original's ordered effects;
 * the timer record table: every byte of the original's records against a model that applies the native clear kernel and the
   0x68 state store in row order to a randomly pre-filled table (ten records; for the probe group the whole 256-record extent
   the original's byte index reaches), and the native host's ten records against the same model;
 * the completion byte and phase dword of every row (the arm sets the byte directly and never touches the phase), and that neither
   the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran.
Tagged native safety difference (the only one): a 0x68/0x69 body byte of 10 or more indexes past the port's ten records; the original
clears that record anyway (checked against the model) while the native binding refuses it UNSUPPORTED before any effect. The real
corpus indexes are 1..8.

HOOKS (everything else is original code): O = observed.
  O arm entries 0x4285fd 0x4286d8 0x42875d (the row is the signed word at [ebp-0x11c]), 0x433bd2 clear entry, 0x42ba3a completion
    helper, 0x423d33 dependency reset: entry observers, they only read memory
  S 0x4d7a15: records ECX, the two arguments and the name bytes, then returns as `ret 8` with eax = 1 (the arm ignores the result)
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the save routine 0x4d7a15 itself (file name handling, the game state it writes, the fopen/ error log);
the scene loader 0x40b34a that allocates the body (the oracle builds the row in memory; the native decoders and the 24 corpus
rows are checked against the decoded scene resources separately), the corpus rows' real dependency records (replayed without them
and behind a stand-in event record, the gate is shared verified code), and every reader of the timer table (conditions 0x4246bd,
the clock, the task list UI), which belong to other slices.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_65_68_69_runtime_original_oracle.py --mutations --result <receipt.json>
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

ARMS = {0x4285FD: 0x65, 0x4286D8: 0x68, 0x42875D: 0x69}
SAVE_ROUTINE = 0x4D7A15
CLEAR_ROUTINE = 0x433BD2
SAVE_OBJECT = 0x5E2E70
SAVE_NAME_VA = 0x545630
TIMERS_VA = 0x585D65
SLOT = 0x106
SLOTS = 10          # the port's records
ORIG_SLOTS = 256    # what the original's unsigned byte index reaches
TYPES = (0x65, 0x68, 0x69)
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 90

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up. 0x4d7a15 is pinned too although it is replaced by a recorder.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x433bd2, 0x433c60, 'dfa7ec5114c85c569a673364b571e731097a5b58eb3c8b320bbf8feb907c5666'),
    (0x4d7a15, 0x4d7ea4, '615b793371fb9a42b79d8fac6db2d3074e57ad153235da1355201c49befe51e1'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x65/0x68/0x69 observers."""

    def __init__(self):
        super().__init__()
        self.entries = []
        self.effects = []
        self.saves = []
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
        table = {a: self._entry for a in ARMS}
        table.update({CLEAR_ROUTINE: self._clear, SAVE_ROUTINE: self._save, 0x423D33: self._reset_seen, 0x42BA3A: self._finish})
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _entry(self, uc, address, size, user):
        self.entries.append((ARMS[address], self._row_at_arm(uc)))

    def _clear(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        pointer = u32(uc, sp + 4)
        offset = pointer - TIMERS_VA
        if offset % SLOT or not 0 <= offset < ORIG_SLOTS * SLOT:
            raise d9.OracleError('0x433bd2 called with %#x, not a timer record' % pointer)
        self.effects.append(('clear', offset // SLOT))

    def _save(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        name_va, arg = u32(uc, sp + 4), u32(uc, sp + 8)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        name = bytes(uc.mem_read(name_va, 14))
        self.effects.append(('save',))
        self.saves.append((ecx, name_va, name, arg))
        self._ret(uc, 8, eax=1)  # `ret 8`; the arm ignores the result

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
        self.entries, self.effects, self.saves, self.finish_entries, self.resets = [], [], [], [], []

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
        self.entries, self.effects, self.saves, self.finish_entries, self.resets = [], [], [], [], []
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
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_65_68_69_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a65_a68_a69.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A65_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a65o_new.restype = C.c_void_p
        lib.a65o_free.argtypes = [C.c_void_p]
        lib.a65o_set_records.argtypes = [C.c_void_p, C.c_char_p]
        lib.a65o_get_records.argtypes = [C.c_void_p, C.c_char_p]
        lib.a65o_log_count.argtypes = [C.c_void_p]
        lib.a65o_log_count.restype = C.c_uint
        lib.a65o_log_at.argtypes = [C.c_void_p, C.c_uint]
        lib.a65o_log_at.restype = C.c_int32
        lib.a65o_log_clear.argtypes = [C.c_void_p]
        lib.a65o_saves.argtypes = [C.c_void_p]
        lib.a65o_saves.restype = C.c_uint
        lib.a65o_save_args_ok.argtypes = [C.c_void_p]
        lib.a65o_save_args_ok.restype = C.c_int
        lib.a65o_visits.argtypes = [C.c_void_p]
        lib.a65o_visits.restype = C.c_ulong
        lib.a65o_clear_kernel.argtypes = [C.c_char_p]
        lib.a65o_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a65o_visit.restype = C.c_int
        self.h = lib.a65o_new()

    def close(self):
        self.lib.a65o_free(self.h)

    def set_records(self, data):
        self.lib.a65o_set_records(self.h, bytes(data))

    def records(self):
        buf = C.create_string_buffer(SLOTS * SLOT)
        self.lib.a65o_get_records(self.h, buf)
        return buf.raw

    def log(self):
        out = [self.lib.a65o_log_at(self.h, i) for i in range(self.lib.a65o_log_count(self.h))]
        self.lib.a65o_log_clear(self.h)
        return [('save',) if v == -1 else ('clear', v) for v in out]

    def saves(self):
        return self.lib.a65o_saves(self.h)

    def save_args_ok(self):
        return bool(self.lib.a65o_save_args_ok(self.h))

    def kernel_clear(self):
        buf = C.create_string_buffer(SLOT)
        self.lib.a65o_clear_kernel(buf)
        return buf.raw

    def visit(self, rtype, subtype, body_byte, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a65o_visit(self.h, rtype, subtype, body_byte, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def R(rtype=0x68, subtype=1, index=0, tail=b''):
    return dict(type=rtype, subtype=subtype, body=bytes([index]), tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def scenario_list(seed=37, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, events=kw.pop('events', {}),
                        mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0), seed=rng.randrange(1 << 30),
                        wide=kw.pop('wide', False)))

    if corpus:
        for start in range(0, len(corpus), 12):
            chunk = corpus[start:start + 12]
            S('corpus:%d' % (start // 12), [R(t, st, body[0]) for t, st, body in chunk], [('tick',), ('rearm',), ('tick',)], group='corpus',
              quick=start == 0)
            tails = [R(t, st, body[0], event_tail(1000 + k % 14, 1)) for k, (t, st, body) in enumerate(chunk)]
            acts = [('tick',), ('events', {1000 + k: 1 for k in range(0, 14, 2)}), ('tick',), ('rearm',),
                    ('events', {1000 + k: 1 for k in range(14)}), ('tick',)]
            S('corpus_gated:%d' % (start // 12), tails, acts, group='corpus', quick=start == 0)
    for rtype in TYPES:
        for subtype in (0, 1, 2, 3, 4, 255):
            S('subtype:%#x:%d' % (rtype, subtype), [R(rtype, subtype, 3), R(rtype, subtype, 4)],
              [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3), ('rearm',), ('tick',)], group='subtype',
              quick=subtype in (0, 1, 2, 255))
    for rtype in (0x68, 0x69):
        S('index:all_%#x' % rtype, [R(rtype, 1, i) for i in range(SLOTS)], [('tick',), ('rearm',), ('tick',)], group='index', quick=True)
        for i in range(SLOTS):
            S('index:single_%#x_%d' % (rtype, i), [R(rtype, 1, i)], [('tick',)], group='index', quick=i in (0, 5, 9))
    S('order:start_then_clear_same_record', [R(0x68, 1, 2), R(0x69, 1, 2)], [('tick',), ('rearm',), ('tick',)], group='order', quick=True)
    S('order:clear_then_start_same_record', [R(0x69, 1, 6), R(0x68, 1, 6), R(0x65, 1, 0), R(0x68, 1, 7), R(0x69, 1, 7)],
      [('tick',), ('rearm',), ('tick',)], group='order', quick=True)
    S('order:twice_in_one_scene', [R(0x68, 1, 1), R(0x68, 2, 1), R(0x69, 0, 1), R(0x68, 255, 1)], [('tick',), ('rearm',), ('tick',)], group='order')
    for v in (0, 1, 2, 0x7F, 0x80, 0xFF):  # the 0x65 body byte is never read
        S('save:body_%#x' % v, [R(0x65, 1, v)], [('tick',), ('rearm',), ('tick',)], group='save', quick=v in (0, 0xFF))
    S('save:three_rows', [R(0x65, 1, 0), R(0x65, 2, 0), R(0x65, 0, 0)], [('tick',), ('rearm',), ('tick',)], group='save', quick=True)
    # a body byte outside the port's ten records: the original clears record n anyway, the native binding refuses
    for i in (10, 11, 99, 100, 127, 128, 200, 255):
        for rtype in (0x68, 0x69):
            S('beyond:%#x_%d' % (rtype, i), [R(rtype, 1, i), R(rtype, 2, 3)], [('tick',)], group='beyond', wide=True, quick=i in (10, 255))
    S('beyond:mixed_with_valid', [R(0x68, 1, 12), R(0x69, 1, 4), R(0x68, 1, 250), R(0x65, 1, 0), R(0x69, 1, 9)], [('tick',), ('rearm',), ('tick',)],
      group='beyond', wide=True, quick=True)
    S('gate:event_false_leaves_table', [R(0x68, 1, 3, event_tail(1040, 1)), R(0x69, 1, 4, event_tail(1041, 1)), R(0x65, 1, 0, event_tail(1042, 1))],
      [('tick',), ('tick',)], group='gate', events={1040: 7, 1041: 7, 1042: 7}, quick=True)
    S('gate:event_false_then_true', [R(0x68, 1, 3, event_tail(1040, 1)), R(0x65, 1, 0, event_tail(1040, 1)), R(0x69, 1, 3)],
      [('tick',), ('tick',), ('events', {1040: 1}), ('rearm',), ('tick',), ('tick',)], group='gate', events={1040: 7}, quick=True)
    S('gate:subtype2_behind_event', [R(0x68, 2, 5, event_tail(1042, 5)), R(0x65, 2, 0, event_tail(1042, 5))], [('events', {1042: 5}), ('tick',), ('tick',)],
      group='gate', events={1042: 1})
    S('gate:two_rows_one_tick', [R(0x68, 1, 1), R(0x69, 1, 2, event_tail(1070, 1)), R(0x65, 0, 0)], [('tick',), ('events', {1070: 1}), ('rearm',), ('tick',)],
      group='gate', quick=True)
    S('gate:mode4_runs_nothing', [R(0x68, 1, 1), R(0x65, 1, 0), R(0x69, 1, 2)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, quick=True)
    S('rows:offset_first_row', [R(0x68, 1, 1), R(0x65, 1, 0), R(0x69, 1, 2)], [('tick',), ('tick',)], group='rows', first=3, quick=True)
    S('rows:revisit_after_rearm', [R(0x68, 1, 8)], [('tick',), ('tick',), ('rearm',), ('tick',)], group='rows', quick=True)
    for n in range(60):
        rows = []
        for _ in range(rng.randint(1, 30)):
            rtype = rng.choice(TYPES)
            tail = event_tail(1000 + rng.randrange(600), rng.randrange(-3, 4)) if rng.random() < 0.3 else b''
            rows.append(R(rtype, rng.choice((0, 1, 1, 1, 2, 3)), rng.randrange(SLOTS) if rtype != 0x65 else rng.randrange(256), tail))
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('events', {1000 + rng.randrange(600): rng.randrange(-3, 4) for _ in range(6)}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x65 / 0x68 / 0x69 rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_65_68_69_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a65_a68_a69.c', 'scene_resource.c', 'hiff.c')], '-lm',
                                '-o', str(exe)],
                               capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        rtype, subtype, hexbody, _tail = line.split()
        rows.append((int(rtype, 16), int(subtype), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, completions=0, table_compares=0, table_bytes=0,
                mismatches=0, saves_checked=0, clears_checked=0, beyond_rows=0, native_refusals=0, effects_compared=0,
                by_type=Counter(), by_subtype=Counter(), groups={})


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
    """Per-scenario model state."""

    def __init__(self, sc, rows, first, table):
        self.sc, self.rows, self.first = sc, rows, first
        self.mode = sc['mode']
        self.completed = [1 if i < first else 0 for i in range(first + len(rows))]
        self.phases = [0] * (first + len(rows))
        self.table = bytearray(table)          # model of the original's timer record extent
        self.extent = len(table)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    rng = random.Random(sc['seed'])
    extent = ORIG_SLOTS * SLOT if sc['wide'] else SLOTS * SLOT
    if sc['wide'] and sc['events']:
        raise d9.OracleError('the wide table overlaps the event flags')
    table = bytes(rng.getrandbits(8) for _ in range(extent))
    x.wr(TIMERS_VA, table)
    nat.set_records(table[:SLOTS * SLOT])
    nat.log()
    st = Scenario(sc, rows, first, table)
    compare_table('%s initial' % sc['id'], x, nat, st, stats)
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


def model_apply(st, rtype, index, nat):
    """What the original arm does to the timer extent for one visited row (the clear kernel is the native one)."""
    if rtype == 0x65:
        return
    clear = nat.kernel_clear()
    base = index * SLOT
    st.table[base:base + SLOT] = clear
    if rtype == 0x68:
        st.table[base:base + 4] = struct.pack('<I', 1)


def tick(where, x, nat, st, stats):
    stats['ticks'] += 1
    x.dispatch()
    rows, first = st.rows, st.first
    total = first + len(rows)
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x65/0x68/0x69 row' % (where, x.finish_entries, x.resets))
    expected_entered, visited = [], []
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    nat.log()
    native_expected = []
    original_expected = []
    if st.mode == 3:
        for i in range(first, total):
            if st.completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append((spec['type'], i))
            if not row_gate_open(spec, flags):
                continue
            visited.append(i)
            rtype, index = spec['type'], spec['body'][0]
            beyond = rtype != 0x65 and index >= SLOTS
            if rtype == 0x65:
                original_expected.append(('save',))
                native_expected.append(('save',))
            else:
                original_expected.append(('clear', index))
                if not beyond:
                    native_expected.append(('clear', index))
            status, done, reset, phase, disposition = nat.visit(rtype, spec['subtype'], index, st.completed[i], st.phases[i])
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if beyond:
                stats['beyond_rows'] += 1
                if status != 1:
                    raise Mismatch('%s: row %d (type %#x index %d) the native binding returned status %d, expected UNSUPPORTED' %
                                   (where, i, rtype, index, status))
                stats['native_refusals'] += 1
                done, phase, reset = o_done, o_phase, 0   # the refusal is the one tagged difference; carry the original's row state
            else:
                if status != 0:
                    raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            st.completed[i], st.phases[i] = done, phase
            if (done, phase) != (o_done, o_phase) or reset != 0:
                raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d, no reset)' %
                               (where, i, done, phase, reset, o_done, o_phase))
            model_apply(st, rtype, index, nat)
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['by_type'][hex(rtype)] += 1
            stats['by_subtype'][spec['subtype']] += 1
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arms for %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.effects != original_expected:
        raise Mismatch('%s: the original ran the effects %s, the gate model expects %s' % (where, x.effects, original_expected))
    native_log = nat.log()
    if native_log != native_expected:
        raise Mismatch('%s: the native effects %s differ from the expected %s (original %s)' % (where, native_log, native_expected, x.effects))
    stats['effects_compared'] += len(native_log)
    for ecx, name_va, name, arg in x.saves:
        if (ecx, name_va, name, arg) != (SAVE_OBJECT, SAVE_NAME_VA, b'SAVE CONTINUE\0', 0):
            raise Mismatch('%s: the original called 0x4d7a15 with ecx %#x name %#x %r arg %d' % (where, ecx, name_va, name, arg))
        stats['saves_checked'] += 1
    if x.saves and not nat.save_args_ok():
        raise Mismatch('%s: the native save call received other arguments than SAVE CONTINUE / 0' % where)
    stats['clears_checked'] += sum(1 for e in x.effects if e[0] == 'clear')
    stats['rows_gated'] += len(expected_entered) - len(visited)
    for i in range(first, total):
        if i not in visited:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (st.completed[i], st.phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    compare_table(where, x, nat, st, stats)


def compare_table(where, x, nat, st, stats):
    stats['table_compares'] += 1
    stats['table_bytes'] += st.extent
    original = x.rd(TIMERS_VA, st.extent)
    if original != bytes(st.table):
        at = next(i for i in range(st.extent) if original[i] != st.table[i])
        raise Mismatch('%s: the original timer table differs from the model at record %d offset %#x (original %#x model %#x)' %
                       (where, at // SLOT, at % SLOT, original[at], st.table[at]))
    native = nat.records()
    if native != bytes(st.table[:SLOTS * SLOT]):
        at = next(i for i in range(SLOTS * SLOT) if native[i] != st.table[i])
        raise Mismatch('%s: the native timer records differ from the original at record %d offset %#x (native %#x original %#x)' %
                       (where, at // SLOT, at % SLOT, native[at], st.table[at]))


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
SAVE = '    b->host.save_game(b->host.context, SESSION_A65_SAVE_NAME, 0);'
MUTANTS = {
    'save name changed': ('#define SESSION_A65_SAVE_NAME "SAVE CONTINUE"', '#define SESSION_A65_SAVE_NAME "SAVE CONTINUF"', 'session_bindings_a65_a68_a69.h'),
    'save report_failure 1': (SAVE, SAVE.replace(', 0);', ', 1);'), 'session_bindings_a65_a68_a69.c'),
    'save skipped': (SAVE, '    (void)b->host.save_game;', 'session_bindings_a65_a68_a69.c'),
    'save twice': (SAVE, SAVE + '\n' + SAVE, 'session_bindings_a65_a68_a69.c'),
    'save only for subtype 1': (SAVE, '    if (action->subtype == 1u) b->host.save_game(b->host.context, SESSION_A65_SAVE_NAME, 0);', 'session_bindings_a65_a68_a69.c'),
    'timer state 0': ('#define SESSION_A68_STATE_RUNNING 1', '#define SESSION_A68_STATE_RUNNING 0', 'session_bindings_a65_a68_a69.h'),
    'timer state 2': ('#define SESSION_A68_STATE_RUNNING 1', '#define SESSION_A68_STATE_RUNNING 2', 'session_bindings_a65_a68_a69.h'),
    '0x69 starts the timer': ('SESSION_A69_TYPE, 0);', 'SESSION_A69_TYPE, 1);', 'session_bindings_a65_a68_a69.c'),
    '0x68 does not start the timer': ('SESSION_A68_TYPE, 1);', 'SESSION_A68_TYPE, 0);', 'session_bindings_a65_a68_a69.c'),
    'record not cleared': ('    session_timer_record_clear(record);', '    (void)record;', 'session_bindings_a65_a68_a69.c'),
    'clear leaves the state dword': ('    memset(record, 0, SESSION_TIMER_RECORD_BYTES);', '    memset(record + 4, 0, SESSION_TIMER_RECORD_BYTES - 4u);', 'session_bindings_a65_a68_a69.c'),
    'clear stops one byte early': ('    memset(record, 0, SESSION_TIMER_RECORD_BYTES);', '    memset(record, 0, SESSION_TIMER_RECORD_BYTES - 1u);', 'session_bindings_a65_a68_a69.c'),
    'pair index words zero': ('record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0xffu;', 'record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0u;', 'session_bindings_a65_a68_a69.c'),
    'pair loop one short': ('for (k = 0u; k < RECORD_FLAG_PAIR_COUNT; ++k) {', 'for (k = 0u; k + 1u < RECORD_FLAG_PAIR_COUNT; ++k) {', 'session_bindings_a65_a68_a69.c'),
    'pair value word set too': ('record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0xffu;', 'record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0xffu; record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 2u] = 0xffu;', 'session_bindings_a65_a68_a69.c'),
    'no sound string': ('static const char no_sound[] = "NO SOUND";', 'static const char no_sound[] = "NO SOUNE";', 'session_bindings_a65_a68_a69.c'),
    'sound string at the wrong offset': ('#define RECORD_SOUND_OFFSET 0x28u', '#define RECORD_SOUND_OFFSET 0x2cu', 'session_bindings_a65_a68_a69.c'),
    'sound string without its NUL': ('memcpy(record + RECORD_SOUND_OFFSET, no_sound, sizeof no_sound);', 'memcpy(record + RECORD_SOUND_OFFSET, no_sound, sizeof no_sound - 1u); record[RECORD_SOUND_OFFSET + 8u] = 0x41u;', 'session_bindings_a65_a68_a69.c'),
    'timer index off by one': ('(unsigned)action->typed_body[0]);', '(unsigned)action->typed_body[0] + 1u);', 'session_bindings_a65_a68_a69.c'),
    'timer index masked to 3 bits': ('(unsigned)action->typed_body[0]);', '(unsigned)(action->typed_body[0] & 7u));', 'session_bindings_a65_a68_a69.c'),
    'phase cleared': ('out->phase = before->phase;', 'out->phase = 0u; (void)before;', 'session_bindings_a65_a68_a69.c'),
    'phase advanced': ('out->phase = before->phase;', 'out->phase = before->phase + 1u;', 'session_bindings_a65_a68_a69.c'),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'session_bindings_a65_a68_a69.c'),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', 'session_bindings_a65_a68_a69.c'),
    'dependency reset requested': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', 'session_bindings_a65_a68_a69.c'),
    'index beyond the table written anyway': ('    if (record == NULL) {', '    if (0) {', 'session_bindings_a65_a68_a69.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-37.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver65.so')
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
        args.result.write_text(json.dumps(dict(slice='RT-37', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
