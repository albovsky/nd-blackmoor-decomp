#!/usr/bin/env python3
"""RT-39: immutable x86 loader arm 0x40c625 and dispatcher arm 0x42816e of 0x427a50 (raw type 0x4b) versus the native raw-0x4b runtime.

The unmodified GAME.EXE image is mapped under Unicorn. Two machines:

A. Loader (the A-4B.1 machine, tests/action_family_4b_original_oracle.py): the original loader builds the row object from the
   raw body with the original AUTOTEXT table (0x423259; a missing key becomes the original "Game Error ... missing auto text"
   string through the original sprintf), compared with the native session binding's object (length word, text, marker).
B. Runtime: for rows of raw type 0x4b the REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the
   gate 0x423f57 (mode 0), and the arm itself (0x42816e..0x4281ce): the caption writer 0x448d11 on the text box 0x619a05 with
   the caption surface [0x5d03b3], the object text (object + 2), mode -1 and measure 0, then the generic completion
   0x42ba3a(row) (subtype 1 completes, subtype 2 resets the dependencies and stays open). The objects are the ones the original
   loader built.

Native side: src/session_bindings_a4b.c with a host whose lookup serves the decoded AUTOTEXT resource (plus the synthetic entries
inserted into the original table too) and whose writer logs its text, driven by tests/action_family_4b_runtime_oracle_driver.c
with the executor's disposition mapping.

Compared after every dispatcher call (tick):
 * which rows entered the arm (observed arm entries) against the open-row model;
 * the caption writer calls (row, this object, caption surface, mode, measure, the length word and every text byte) against the
   native host's writes, in order; the original must call the writer exactly for the rows with a true gate;
 * the generic completion 0x42ba3a (once per visited row, in order) and the dependency reset 0x423d33 (exactly for the rows the
   native binding's disposition resets) against the native disposition;
 * the completion byte and phase dword of every row, the unvisited rows unchanged.
Loader comparison: the object of every row (length word and text bytes) against the original loader's object.

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm entry 0x42816e (the row is the signed word at [ebp-0x11c]), 0x42ba3a completion entry, 0x423d33 reset entry
  R 0x448d11 the caption writer: the arguments are logged and the call returns (the pixels are the S05-1 oracle's business)
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the body and the row (the x86 runtime rows are built in
memory around the original loader's object), the caption writer itself and the caption surface, the corpus rows' real
dependency records (replayed without them and behind a stand-in event record, the gate is shared verified code).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_4b_runtime_original_oracle.py --mutations --result <receipt.json>
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
import test_scene_executor as base
from action_family_4b_original_oracle import OriginalLoader
from autotext_original_oracle import _read_cvtx_payload, parse_entries

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM = 0x42816E
WRITER = 0x448D11
TEXT_BOX = 0x619A05
SURFACE_PTR = 0x5D03B3
SURFACE = 0x5D1234          # the value stored at [0x5d03b3]: the writer must be handed exactly this
TYPE = 0x4B
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 60
AUTOTEXT_RESOURCE = ROOT / 'work/analysis/hiff-resources/0001.bin'

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
    (0x448d11, 0x449770, '73e722d119326e1c9e8503964f3f5ecaeff18f856e43267a4519fe0282f7ccfa'),
    (0x4f6334, 0x4f646c, '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
    (0x4f709c, 0x4f70b0, 'f4378d19b5c3ab0dbd39cba983f59f6dc52989a4d7f3e5211057cd34d287503e'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x4b observers."""

    def __init__(self):
        super().__init__()
        self.entries = []
        self.writes = []
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
        table = {ARM: self._entry, WRITER: self._writer, 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _entry(self, uc, address, size, user):
        self.entries.append(self._row_at_arm(uc))

    def _writer(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        surface, text, mode, measure = (u32(uc, sp + 4 * k) for k in (1, 2, 3, 4))
        length = struct.unpack('<H', bytes(uc.mem_read(text - 2, 2)))[0]
        self.writes.append(dict(row=self._row_at_arm(uc), this=ecx, surface=surface, mode=mode, measure=measure, length=length,
                                text=bytes(uc.mem_read(text, length)), word_text=text - 2))
        self._ret(uc, 0x10, 0)   # thiscall, four stack arguments: ret 0x10

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
        self.w32(SURFACE_PTR, SURFACE)
        self.clear_logs()

    def clear_logs(self):
        self.entries, self.writes, self.finish_entries, self.resets = [], [], [], []

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
            self.wr(body_at, spec['obj'])
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

    def dispatch(self):
        self.clear_logs()
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
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_4b_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a4b.c', 'action_family_4b.c', 'action_core.c', 'scene_resource.c',
                                            'hiff.c', 'autotext.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A4B_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a4bo_new.argtypes = [C.c_char_p]
        lib.a4bo_new.restype = C.c_void_p
        lib.a4bo_free.argtypes = [C.c_void_p]
        lib.a4bo_add_entry.argtypes = [C.c_void_p, C.c_char_p, C.c_uint, C.c_char_p, C.c_uint]
        lib.a4bo_add_entry.restype = C.c_int
        lib.a4bo_begin.argtypes = [C.c_void_p, C.c_char_p, C.c_uint, C.POINTER(C.c_uint), C.POINTER(C.c_int)]
        lib.a4bo_begin.restype = C.c_int
        lib.a4bo_row_object.argtypes = [C.c_void_p, C.c_uint, C.c_char_p, C.c_uint]
        lib.a4bo_row_object.restype = C.c_int
        lib.a4bo_set_writer_status.argtypes = [C.c_void_p, C.c_int]
        lib.a4bo_log_count.argtypes = [C.c_void_p]
        lib.a4bo_log_count.restype = C.c_uint
        lib.a4bo_log_row.argtypes = [C.c_void_p, C.c_uint]
        lib.a4bo_log_row.restype = C.c_int
        lib.a4bo_log_length.argtypes = [C.c_void_p, C.c_uint]
        lib.a4bo_log_length.restype = C.c_uint
        lib.a4bo_log_copy.argtypes = [C.c_void_p, C.c_uint, C.c_char_p]
        lib.a4bo_log_clear.argtypes = [C.c_void_p]
        lib.a4bo_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a4bo_visit.restype = C.c_int
        self.h = lib.a4bo_new(str(AUTOTEXT_RESOURCE).encode())
        if not self.h:
            raise d9.OracleError('native driver could not start (AUTOTEXT resource?)')

    def close(self):
        self.lib.a4bo_free(self.h)

    def add_entry(self, key, value):
        if not self.lib.a4bo_add_entry(self.h, key, len(key), value, len(value)):
            raise d9.OracleError('native driver table full')

    def begin(self, scene):
        failed, kernel = C.c_uint(), C.c_int()
        status = self.lib.a4bo_begin(self.h, scene, len(scene), C.byref(failed), C.byref(kernel))
        return status, failed.value, kernel.value

    def row_object(self, index, capacity=40000):
        buf = C.create_string_buffer(capacity)
        n = self.lib.a4bo_row_object(self.h, index, buf, capacity)
        return None if n < 0 else buf.raw[:n]

    def writes(self):
        out = []
        for i in range(self.lib.a4bo_log_count(self.h)):
            n = self.lib.a4bo_log_length(self.h, i)
            buf = C.create_string_buffer(max(n, 1))
            self.lib.a4bo_log_copy(self.h, i, buf)
            out.append((self.lib.a4bo_log_row(self.h, i), buf.raw[:n]))
        self.lib.a4bo_log_clear(self.h)
        return out

    def visit(self, index, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a4bo_visit(self.h, index, completed, phase, C.byref(done), C.byref(reset), C.byref(new_phase),
                                     C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# the original loader (machine A)
# ---------------------------------------------------------------------------------------------
class Loader:
    def __init__(self):
        self.machine = OriginalLoader()
        self.machine.initialize()
        for entry in parse_entries(_read_cvtx_payload(AUTOTEXT_RESOURCE.read_bytes())):
            self.machine.insert(entry['key_field'], entry['raw_value'])
        self.machine.copy_table()
        self.cache = {}
        self.calls = 0

    def add_entry(self, key, value, nat):
        self.machine.insert(key + bytes(33 - len(key)), value)
        self.machine.copy_table()
        nat.add_entry(key, value)

    def build(self, subtype, raw_body):
        """The original loader's object (length word, text, marker, ...), allocation extent included."""
        k = (subtype, raw_body)
        if k not in self.cache:
            payload = b'oracle'.ljust(48, b'\0') + bytes([TYPE, subtype]) + raw_body
            image, _cursor, _offset, _addr = self.machine.invoke(payload, seed=len(self.cache) & 0xFF)
            self.calls += 1
            self.cache[k] = image
        return self.cache[k]


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
SYNTH = {
    b'RT39A': b'Alpha caption',
    b'RT39EMPTY': b'',
    b'RT39LONG': b'y' * 5000,
    b'RT39NUL': b'ab\0cd',
    b'RT39<E>': b'has <e> inside',
    b'K' * 32: b'full width key',
    b'RT39BIG': b'z' * 32761,
}
TEXTS = [b'', b'x', b'Hi there', b'two words <n> and a break', b'tab\tbyte \xff\x80 high bytes', b'a\0b embedded NUL', b'<e>',
         b'before <e> after', b'p' * 100, b'q' * 1500]


def inline_typed(text):
    return struct.pack('<h', len(text)) + text


def key_typed(key, pad=0):
    """Selector -1 and the 33-byte key field: the key, a NUL, then zeros (or `pad` bytes, junk the loader copies and ignores)."""
    field = (key + b'\0').ljust(33, bytes([pad]))
    return struct.pack('<h', -1) + field[:33]


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def R(typed, subtype=1, tail=b''):
    return dict(subtype=subtype, typed=typed, tail=tail)


def scenario_list(seed=0x39, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, events=kw.pop('events', {}),
                        mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0), stride=kw.pop('stride', 0x100),
                        seed=rng.randrange(1 << 30)))

    if corpus:
        for start in range(0, len(corpus), 9):
            chunk = corpus[start:start + 9]
            rows = [R(typed, st, tail) for st, typed, tail in chunk]
            S('corpus:%d' % (start // 9), rows, [('tick',), ('rearm',), ('tick',)], group='corpus', quick=start == 0, stride=0x100)
            gated = [R(typed, st, event_tail(1000 + k % 6, 1)) for k, (st, typed, _tail) in enumerate(chunk)]
            S('corpus_gated:%d' % (start // 9), gated,
              [('tick',), ('events', {1000 + k: 1 for k in range(0, 6, 2)}), ('tick',), ('rearm',),
               ('events', {1000 + k: 1 for k in range(6)}), ('tick',)], group='corpus', quick=start == 0, events={1000 + k: 0 for k in range(6)})
            for subtype in (0, 2, 3, 255):
                S('corpus_subtype:%d:%d' % (start // 9, subtype), [R(typed, subtype, tail) for _st, typed, tail in chunk],
                  [('tick',), ('tick',), ('rearm',), ('tick',)], group='corpus', quick=start == 0 and subtype == 2)
    # inline texts of every shape, one row each and all in one scene
    S('inline:all', [R(inline_typed(t), 1) for t in TEXTS], [('tick',), ('rearm',), ('tick',)], group='inline', quick=True)
    for n in (0, 1, 2, 3, 4, 9, 9998, 9999):
        S('inline_len:%d' % n, [R(inline_typed(bytes(rng.randrange(1, 256) for _ in range(n))), 1)], group='inline',
          quick=n in (0, 9999), stride=0x2800)
    S('inline_nul_run', [R(inline_typed(b'\0' * 20), 1), R(inline_typed(b'\0a\0'), 2)], group='inline', quick=True)
    # AUTOTEXT keys: found, found with another case, absent (the original error string), padded junk after the NUL
    keys = [b'RT39A', b'rt39a', b'RT39EMPTY', b'RT39LONG', b'RT39NUL', b'RT39<E>', b'K' * 32, b'NOSUCHKEY', b'', b'x', b'MISSING' * 4]
    S('key:all', [R(key_typed(k), 1) for k in keys], [('tick',), ('rearm',), ('tick',)], group='key', quick=True, stride=0x1400)
    S('key:padded', [R(key_typed(k, pad=0xFE), 1) for k in (b'RT39A', b'NOSUCH', b'K' * 32)], group='key', quick=True)
    S('key:big', [R(key_typed(b'RT39BIG'), 1)], group='key', quick=True, stride=0x8100)
    S('key:subtypes', [R(key_typed(b'RT39A'), s) for s in (0, 1, 2, 3, 255)], [('tick',), ('tick',), ('rearm',), ('tick',)], group='key', quick=True)
    # subtype and phase: the arm never reads the phase; the generic completion writes it
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(inline_typed(b'one'), subtype), R(key_typed(b'RT39A'), subtype), R(inline_typed(b'three'), subtype)],
          [('setphase', 0, 5), ('setphase', 2, 9), ('tick',), ('tick',), ('setphase', 1, 3), ('rearm',), ('tick',)], group='subtype',
          quick=subtype in (0, 1, 2, 255))
    # subtype 2 stays open and writes every tick; rows after it still run
    S('order:reset_row_between', [R(inline_typed(b'first'), 1), R(inline_typed(b'second'), 2), R(inline_typed(b'third'), 1)],
      [('tick',), ('tick',), ('tick',), ('rearm',), ('tick',)], group='order', quick=True)
    # gates
    S('gate:event_false_leaves_row', [R(inline_typed(b'g1'), 1, event_tail(1040, 1)), R(key_typed(b'RT39A'), 2, event_tail(1041, 1)),
                                      R(inline_typed(b'g3'), 1, event_tail(1042, 1))],
      [('tick',), ('tick',)], group='gate', events={1040: 7, 1041: 7, 1042: 7}, quick=True)
    S('gate:event_false_then_true', [R(inline_typed(b'late'), 1, event_tail(1040, 1)), R(inline_typed(b'late2'), 2, event_tail(1040, 1)),
                                     R(inline_typed(b'free'), 1)],
      [('tick',), ('tick',), ('events', {1040: 1}), ('rearm',), ('tick',), ('tick',)], group='gate', events={1040: 7}, quick=True)
    S('gate:two_rows_one_tick', [R(inline_typed(b'a'), 1), R(inline_typed(b'b'), 1, event_tail(1070, 1)), R(inline_typed(b'c'), 2)],
      [('tick',), ('events', {1070: 1}), ('rearm',), ('tick',)], group='gate', quick=True)
    S('gate:mode4_runs_nothing', [R(inline_typed(b'm4'), 1), R(key_typed(b'RT39A'), 1)], [('tick',), ('mode', 3), ('tick',)],
      group='gate', mode=4, quick=True)
    S('rows:offset_first_row', [R(inline_typed(b'x'), 1), R(inline_typed(b'y'), 2)], [('tick',), ('tick',)], group='rows', first=3, quick=True)
    # tails: dependency records of other opcodes that evaluate true or false on their own
    for k in range(4):
        S('tail:%d' % k, [R(inline_typed(b'tail'), 1 + k % 2, tail=event_tail(1100 + j, 0) * (k + 1)) for j in range(3)],
          [('tick',), ('rearm',), ('tick',)], group='tail', events={1100 + j: j % 2 for j in range(3)}, quick=k == 2)
    for n in range(60):
        rows = []
        for _ in range(rng.randint(1, 11)):
            typed = inline_typed(rng.choice(TEXTS)) if rng.random() < 0.5 else key_typed(rng.choice(keys + [b'NOSUCH%d' % rng.randrange(9)]))
            tail = event_tail(1000 + rng.randrange(60), rng.randrange(-2, 3)) if rng.random() < 0.3 else b''
            rows.append(R(typed, rng.choice((0, 1, 1, 1, 2, 3)), tail))
        acts = []
        for _ in range(rng.randint(2, 5)):
            acts.append(('tick',))
            if rng.random() < 0.5:
                acts.append(('events', {1000 + rng.randrange(60): rng.randrange(-2, 3) for _ in range(6)}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', quick=n < 2, stride=0x1400)
    return scs


def load_corpus():
    """The decoded scene resources' raw 0x4b rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_4b_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a4b.c', 'action_family_4b.c', 'scene_resource.c', 'hiff.c',
                                                                    'autotext.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', str(AUTOTEXT_RESOURCE), *map(str, sorted(resources.glob('*.bin')))],
                             capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        subtype, hexbody = line.split()
        raw = bytes.fromhex(hexbody)
        selector = struct.unpack_from('<h', raw)[0]
        typed_length = 35 if selector == -1 else 2 + selector
        rows.append((int(subtype), raw[:typed_length], raw[typed_length:]))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, rows_completed=0, rows_open=0, writes_compared=0,
                text_bytes=0, resets_checked=0, loader_objects=0, loader_bytes=0, missing_key_objects=0, mismatches=0, by_subtype=Counter(),
                groups={})


def row_gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


def run_scenario(x, nat, loader, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'])
    try:
        run_scenario_inner(x, nat, loader, sc, stats)
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


MISSING = b'Game Error (please contact Tech Support) missing auto text: '


def run_scenario_inner(x, nat, loader, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    # machine A: the original loader's objects, and the native binding's, row by row
    for r in rows:
        r['obj'] = loader.build(r['subtype'], r['typed'] + r['tail'])
    scene = base.scene_bytes([base.action(TYPE, r['subtype'], r['typed'] + r['tail']) for r in rows])
    status, failed, kernel = nat.begin(scene)
    if status != 0:
        raise Mismatch('%s: native begin_scene status %d (row %d kernel %d)' % (sc['id'], status, failed, kernel))
    for k, r in enumerate(rows):
        word = struct.unpack_from('<H', r['obj'])[0]
        native_object = nat.row_object(k)
        if native_object is None or native_object != r['obj'][:word + 2]:
            raise Mismatch('%s: row %d object differs: native %r original %r' % (sc['id'], k, (native_object or b'')[:60], r['obj'][:word + 2][:60]))
        stats['loader_objects'] += 1
        stats['loader_bytes'] += word + 2
        if r['obj'][2:2 + len(MISSING)] == MISSING:
            stats['missing_key_objects'] += 1
    x.install_rows(rows, first, sc['stride'])
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    st = Scenario(sc, rows, first)
    nat.writes()
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
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    nat.writes()
    expected_entered, visited, native_resets = [], [], []
    if st.mode == 3:
        for i in range(first, total):
            if st.completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if not row_gate_open(spec, flags):
                continue
            visited.append(i)
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            status, done, reset, phase, disposition = nat.visit(i - first, st.completed[i], st.phases[i])
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
    # the caption writer: exactly the visited rows, in order, with the original's own arguments and text
    native_writes = [(row + first, text) for row, text in nat.writes()]
    original_writes = x.writes
    if [w['row'] for w in original_writes] != visited:
        raise Mismatch('%s: the original called the caption writer for rows %s, expected %s' % (where, [w['row'] for w in original_writes], visited))
    if native_writes != [(w['row'], w['text']) for w in original_writes]:
        raise Mismatch('%s: caption writer calls differ: native %r original %r' % (
            where, [(r, t[:50]) for r, t in native_writes], [(w['row'], w['text'][:50]) for w in original_writes]))
    for w in original_writes:
        if (w['this'], w['surface'], w['mode'], w['measure']) != (TEXT_BOX, SURFACE, 0xFFFFFFFF, 0):
            raise Mismatch('%s: writer arguments this=%#x surface=%#x mode=%#x measure=%d' % (where, w['this'], w['surface'], w['mode'], w['measure']))
        if struct.unpack_from('<H', rows[w['row'] - first]['obj'])[0] != w['length']:
            raise Mismatch('%s: the writer text length differs from the object word' % where)
        body_at = struct.unpack('<I', x.rd(ROWS + w['row'] * ROW + 0x32, 4))[0]
        if body_at != w['word_text']:
            raise Mismatch('%s: the writer text is not object + 2' % where)
        stats['writes_compared'] += 1
        stats['text_bytes'] += w['length']
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


def run_list(x, nat, loader, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, nat, loader, sc, stats)
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


# native mutants: each must be caught by the quick scenario set
BIND = 'session_bindings_a4b.c'
HEAD51 = 'action_family_51.h'
MUTANTS = {
    'writer text starts at the length word': ('written = binding->host.write_caption(binding->host.context, row->object + 2u, row->text_bytes);',
                                              'written = binding->host.write_caption(binding->host.context, row->object, row->text_bytes);', BIND),
    'writer length one short': ('row->object + 2u, row->text_bytes);', 'row->object + 2u, row->text_bytes - 1u);', BIND),
    'writer length without the marker': ('row->object + 2u, row->text_bytes);', 'row->object + 2u, row->text_bytes - 3u);', BIND),
    'writer called twice': ('    ++binding->writes;\n', '    ++binding->writes;\n    (void)binding->host.write_caption(binding->host.context, row->object + 2u, row->text_bytes);\n', BIND),
    'writer never called': ('    written = binding->host.write_caption(binding->host.context, row->object + 2u, row->text_bytes);\n',
                            '    written = SESSION_A4B_WRITE_OK;\n', BIND),
    'writer after the completion only for subtype 1': ('    result->disposition = SCENE_ACTION_HANDLER_COMPLETED;\n    result->phase = 0u;',
                                                       '    result->disposition = action->subtype == 1u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;\n    result->phase = 0u;', BIND),
    'direct completion': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', BIND),
    'row left pending': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_PENDING;', BIND),
    'dependency reset always': ('result->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'result->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;', BIND),
    'phase kept': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = state_before->phase;\n    return SCENE_ACTION_HANDLER_OK;', BIND),
    'phase one': ('    result->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', '    result->phase = 1u;\n    return SCENE_ACTION_HANDLER_OK;', BIND),
    'wrong row object': ('    row = &binding->rows[action_index];\n    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {',
                         '    row = &binding->rows[action_index ? action_index - 1u : 0u];\n    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {', BIND),
    'key one byte short': ('lookup_status = binding->host.lookup(binding->host.lookup_context, decoded.text_key, key_length, &resolved, &resolved_bytes);',
                           'lookup_status = binding->host.lookup(binding->host.lookup_context, decoded.text_key, key_length ? key_length - 1u : 0u, &resolved, &resolved_bytes);', BIND),
    'table value not cut at the NUL': ('resolved_bytes = bounded_strlen(resolved, resolved_bytes);', '(void)bounded_strlen;', BIND),
    'missing key not formatted': ('int written = snprintf(missing, sizeof(missing), ACTION_FAMILY_51_MISSING_FORMAT, (const char *)decoded.text_key);',
                                  'int written = snprintf(missing, sizeof(missing), "%s", (const char *)decoded.text_key);', BIND),
    'missing key treated as empty': ('            resolved = (const uint8_t *)missing;\n            resolved_bytes = (size_t)written;',
                                     '            resolved = (const uint8_t *)missing;\n            resolved_bytes = 0u;', BIND),
    'missing format altered': ('"Game Error (please contact Tech Support) missing auto text: %s<n>"', '"Game Error (please contact Tech Support) missing autotext: %s<n>"', HEAD51),
    'inline row built as a key row': ('if (decoded.text_selector == -1) {\n        const size_t key_length', 'if (decoded.text_selector != 0) {\n        const size_t key_length', BIND),
    'object copy one byte short': ('memcpy(row->object, scratch->object_bytes, scratch->allocation_bytes);', 'memcpy(row->object, scratch->object_bytes, scratch->allocation_bytes - 1u);', BIND),
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
    work = Path(tempfile.mkdtemp(prefix='RT-39.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver4b.so')
    nat = Native(lib_path)
    loader = Loader()
    for key, value in SYNTH.items():
        loader.add_entry(key, value, nat)
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
    bad = run_list(x, nat, loader, scs, stats, fail_fast=args.fail_fast or args.mutation_run)
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
    summary['original_loader_calls'] = loader.calls
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-39', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
