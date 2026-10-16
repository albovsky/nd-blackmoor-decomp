#!/usr/bin/env python3
"""RT-30: immutable x86 dispatcher 0x427a50 (arm 0x428692) versus the native raw-0x67 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x67 the REAL dispatcher 0x427a50 runs:
dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), and the arm itself (push 0 / gate / for a
true gate: dword [0x5bb1ca] := 1 at 0x4286b5, then the row's completion byte := 1 at 0x4286cc). All of it is original x86.

Native side: src/session_bindings_a67.c (the executor's handler contract) with a host that stores the start flag, driven by
tests/action_family_67_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm (observed entries of 0x428692) against the rows still open, and which rows stored the flag
   (observed 0x4286b5) against a gate model (event flag dependency records, the world mode word);
 * the completion byte and phase dword of every row (the arm sets the byte directly and never touches the phase), and that
   neither the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran;
 * the dword at 0x5bb1ca against the native start flag (the flag starts at a scenario-chosen value, so "stored 1" is
   distinguished from "or-ed" and "left alone").

HOOKS (everything else is original code): O = observed.
  O 0x428692 arm entry and 0x4286b5 flag store (the row is the signed word at [ebp-0x11c]), 0x42ba3a completion helper,
    0x423d33 dependency reset: entry observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the body (the oracle builds the row in memory; the native
decoder and the 27 corpus rows are checked against the decoded scene resources separately), the 27 corpus rows' dependency
records (replayed without them and behind a stand-in event record, the gate is shared verified code), and every reader of
0x5bb1ca (the frame step 0x43a7ca and others), which is host behaviour outside this slice.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_67_runtime_original_oracle.py --mutations --result <receipt.json>
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

ARM_ENTRY = 0x428692
ARM_STORE = 0x4286B5
FLAG_VA = 0x5BB1CA
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
MAX_ROWS = 90

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
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x67 observers."""

    def __init__(self):
        super().__init__()
        self.entries = []
        self.stores = []
        self.finish_entries = []
        self.resets = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    def _row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {ARM_ENTRY: self._entry, ARM_STORE: self._store, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _entry(self, uc, address, size, user):
        self.entries.append(self._row_at_arm(uc))

    def _store(self, uc, address, size, user):
        self.stores.append(self._row_at_arm(uc))

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
        self.entries, self.stores, self.finish_entries, self.resets = [], [], [], []

    def flag(self):
        return struct.unpack('<i', self.rd(FLAG_VA, 4))[0]

    def set_flag(self, value):
        self.wr(FLAG_VA, struct.pack('<i', value))

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
            self.wr(base + 0x30, bytes([0x67, spec['subtype']]) + struct.pack('<I', body_at))
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
        self.entries, self.stores, self.finish_entries, self.resets = [], [], [], []
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
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_67_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a67.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A67_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a67o_new.restype = C.c_void_p
        lib.a67o_free.argtypes = [C.c_void_p]
        lib.a67o_set_flag.argtypes = [C.c_void_p, C.c_int32]
        lib.a67o_get_flag.argtypes = [C.c_void_p]
        lib.a67o_get_flag.restype = C.c_int32
        lib.a67o_sets.argtypes = [C.c_void_p]
        lib.a67o_sets.restype = C.c_ulong
        lib.a67o_visits.argtypes = [C.c_void_p]
        lib.a67o_visits.restype = C.c_ulong
        lib.a67o_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a67o_visit.restype = C.c_int
        self.h = lib.a67o_new()

    def sets(self):
        return self.lib.a67o_sets(self.h)

    def close(self):
        self.lib.a67o_free(self.h)

    def set_flag(self, v):
        self.lib.a67o_set_flag(self.h, v - (1 << 32) if v >> 31 else v)

    def flag(self):
        return self.lib.a67o_get_flag(self.h)

    def visit(self, subtype, body_byte, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a67o_visit(self.h, subtype, body_byte, completed, phase, C.byref(done), C.byref(reset), C.byref(new_phase),
                                     C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
FLAGS = (0, 1, 2, 7, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF)


def R(subtype=1, tail=b'', body=b'\0'):
    return dict(body=body, subtype=subtype, tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def scenario_list(seed=30, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, flag=kw.pop('flag', 0),
                        events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                        first=kw.pop('first', 0)))

    if corpus:
        for start in range(0, len(corpus), 20):
            chunk = corpus[start:start + 20]
            acts = []
            for rep in range(3):
                acts += [('flag', rng.choice(FLAGS)), ('tick',), ('rearm',)]
            S('corpus:%d' % (start // 20), [R(st, b'', body) for st, body in chunk], acts, group='corpus', quick=start == 0)
            # the same rows behind the dependency record the real rows carry (event flags 1000..1013 == 1): half the flags set
            tails = [R(st, event_tail(1000 + k % 14, 1), body) for k, (st, body) in enumerate(chunk)]
            acts = [('flag', 0), ('tick',), ('events', {1000 + k: 1 for k in range(0, 14, 2)}), ('tick',), ('rearm',), ('flag', 5),
                    ('events', {1000 + k: 1 for k in range(14)}), ('tick',)]
            S('corpus_gated:%d' % (start // 20), tails, acts, group='corpus', quick=start == 0)
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(subtype), R(subtype)], [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3),
                                                              ('rearm',), ('tick',)], group='subtype', quick=subtype in (0, 1, 2, 3, 255))
    for f in FLAGS:
        S('flag:initial_%#x' % f, [R(1)], [('tick',)], group='flag', flag=f, quick=f in (0, 7))
    S('body:values', [R(1, event_tail(1003, 1) if v & 1 else b'', bytes([v])) for v in (0, 1, 2, 0x80, 0xFF)],
      [('events', {1003: 1}), ('tick',)], group='body', quick=True)
    for v in (0, 1, 2, 0x7F, 0x80, 0xFF):  # one row at a time: the flag is shared, so a body-dependent store shows only alone
        S('body:single_%#x' % v, [R(1, b'', bytes([v]))], [('tick',)], group='body', flag=3, quick=v in (1, 0x80))
    S('gate:event_false_leaves_flag', [R(1, event_tail(40, 1))], [('tick',), ('tick',)], group='gate', events={40: 7}, flag=9, quick=True)
    S('gate:event_false_then_true', [R(1, event_tail(40, 1)), R(1)], [('tick',), ('tick',), ('events', {40: 1}), ('flag', 9), ('rearm',), ('tick',), ('tick',)],
      group='gate', events={40: 7}, quick=True)
    S('gate:subtype2_behind_event', [R(2, event_tail(42, 5))], [('events', {42: 5}), ('tick',), ('tick',)], group='gate', events={42: 1})
    S('gate:two_rows_one_tick', [R(1), R(1, event_tail(70, 1)), R(0)], [('tick',), ('events', {70: 1}), ('rearm',), ('tick',)], group='gate',
      quick=True)
    S('gate:mode4_runs_nothing', [R(1), R(1)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, flag=3, quick=True)
    S('rows:offset_first_row', [R(1), R(1)], [('tick',), ('tick',)], group='rows', first=3, quick=True)
    S('rows:revisit_after_rearm', [R(1)], [('tick',), ('flag', 0), ('tick',), ('rearm',), ('tick',)], group='rows', flag=4, quick=True)
    for n in range(60):
        rows = [R(rng.choice((0, 1, 1, 1, 2, 3)), event_tail(rng.randrange(1600), rng.randrange(-3, 4)) if rng.random() < 0.3 else b'')
                for _ in range(rng.randint(1, 30))]
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts += [('flag', rng.choice(FLAGS)), ('tick',)]
            if rng.random() < 0.5:
                acts.append(('events', {r['tail'] and struct.unpack_from('<h', r['tail'], 2)[0] or 0: rng.randrange(-3, 4) for r in rows[:6]}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', flag=rng.choice(FLAGS), quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw-0x67 rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_67_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a67.c', 'scene_resource.c', 'hiff.c')], '-lm',
                                '-o', str(exe)],
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
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, completions=0, flag_compares=0, mismatches=0,
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
    state = dict(mode=sc['mode'])
    x.set_flag(sc['flag'] - (1 << 32) if sc['flag'] >> 31 else sc['flag'])
    nat.set_flag(sc['flag'])
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    compare_flag(sc['id'] + ' initial', x, nat, stats)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, rows, first, state, completed, phases, stats)
        elif kind == 'flag':
            x.set_flag(act[1] - (1 << 32) if act[1] >> 31 else act[1])
            nat.set_flag(act[1])
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


def tick(where, x, nat, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    x.dispatch()
    total = first + len(rows)
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x67 row' % (where, x.finish_entries, x.resets))
    expected_entered, expected = [], []
    sets_before = nat.sets()
    flags = lambda i: struct.unpack('<i', x.rd(d9.EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    if state['mode'] == 3:
        for i in range(first, total):
            if completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if not row_gate_open(spec, flags):
                continue
            expected.append(i)
            status, done, reset, phase, disposition = nat.visit(spec['subtype'], spec['body'][0], completed[i], phases[i])
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            completed[i], phases[i] = done, phase
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (done, phase) != (o_done, o_phase) or reset != 0:
                raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d, no reset)' %
                               (where, i, done, phase, reset, o_done, o_phase))
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['by_subtype'][spec['subtype']] += 1
    stats['gate_model_checks'] += 1
    if nat.sets() - sets_before != len(x.stores):
        raise Mismatch('%s: the host sink was called %d times, the original stored the flag %d times' % (where, nat.sets() - sets_before, len(x.stores)))
    stats['rows_entered'] += len(x.entries)
    if x.entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for rows %s, the model expects %s' % (where, x.entries, expected_entered))
    if x.stores != expected:
        raise Mismatch('%s: the original stored the flag for rows %s, the gate model expects %s' % (where, x.stores, expected))
    stats['rows_gated'] += len(expected_entered) - len(expected)
    for i in range(first, total):
        if i not in expected:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    compare_flag(where, x, nat, stats)


def compare_flag(where, x, nat, stats):
    stats['flag_compares'] += 1
    if x.flag() != nat.flag():
        raise Mismatch('%s: start flag original %d native %d' % (where, x.flag(), nat.flag()))


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
    'flag value 0': ('#define SESSION_A67_START_FLAG_VALUE 1', '#define SESSION_A67_START_FLAG_VALUE 0', 'session_bindings_a67.h'),
    'flag value 2': ('#define SESSION_A67_START_FLAG_VALUE 1', '#define SESSION_A67_START_FLAG_VALUE 2', 'session_bindings_a67.h'),
    'flag reported to the host twice': ('    b->host.set_start_flag(b->host.context, b->start_flag);', '    b->host.set_start_flag(b->host.context, b->start_flag); b->host.set_start_flag(b->host.context, b->start_flag);', 'session_bindings_a67.c'),
    'flag not reported to the host': ('    b->host.set_start_flag(b->host.context, b->start_flag);', '    (void)b->host.set_start_flag;', 'session_bindings_a67.c'),
    'flag set only for subtype 1': ('    b->host.set_start_flag(b->host.context, b->start_flag);', '    if (action->subtype == 1u) b->host.set_start_flag(b->host.context, b->start_flag);', 'session_bindings_a67.c'),
    'flag set only for subtype below 3': ('    b->host.set_start_flag(b->host.context, b->start_flag);', '    if (action->subtype < 3u) b->host.set_start_flag(b->host.context, b->start_flag);', 'session_bindings_a67.c'),
    'flag set when the body byte is zero': ('    b->host.set_start_flag(b->host.context, b->start_flag);', '    if (action->typed_body[0] == 0u) b->host.set_start_flag(b->host.context, b->start_flag);', 'session_bindings_a67.c'),
    'flag follows the subtype': ('    b->start_flag = SESSION_A67_START_FLAG_VALUE;', '    b->start_flag = (int32_t)action->subtype + 1;', 'session_bindings_a67.c'),
    'phase cleared': ('out->phase = before->phase;', 'out->phase = 0u;', 'session_bindings_a67.c'),
    'phase advanced': ('out->phase = before->phase;', 'out->phase = before->phase + 1u;', 'session_bindings_a67.c'),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'session_bindings_a67.c'),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;', 'session_bindings_a67.c'),
    'subtype 2 resets': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'session_bindings_a67.c'),
    'dependency reset requested': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', 'session_bindings_a67.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-30.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver67.so')
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
        args.result.write_text(json.dumps(dict(slice='RT-30', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
