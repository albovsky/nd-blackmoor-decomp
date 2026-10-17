#!/usr/bin/env python3
"""RT-46: immutable x86 raw-0x33 handler 0x42c221 ("secondary video with hotspots") versus the native kernel
src/action_family_33_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn (x87 control word 0x27f, 53-bit precision, as the shipped process runs).
Two machines, as in the RT-44 oracle:

A. Loader: the REAL scene loader 0x40b34a with the raw-0x33 arm 0x40c186 (the machine of tests/action_family_33_original_oracle.py)
   copies the typed body of every scenario row into a fresh allocation. The bytes it produces are compared with the body the
   scenario describes, and THOSE bytes (the original's own object) become the body of the row the dispatcher visits.
B. Runtime: the REAL dispatcher 0x427a50 (arm 0x428003 for raw type 0x33, gate 0x423f57 mode 1, dependency trees built by the
   real loader 0x424aa8) drives the real handler 0x42c221 and its pure callees as original x86.

Native side: src/action_family_33_runtime.c through tests/action_family_33_runtime_oracle_driver.c (scripted A33Host that logs every
A33Op with arguments and returns and answers TICK / OVERLAY_LOAD / SURFACE_CREATE / THREAD_CREATE from scripted queues shared with
the hooks of machine B).

ORIGINAL x86, NOT hooked: 0x427a50 (dispatcher) 0x423f57 (gate) 0x424aa8 (dependency loader), the handler 0x42c221 and the pure
callees 0x42ca22 (event flags) 0x42caa8 + 0x42cecd (hotspot rectangles, request cells) 0x42d215 (frame advance, jump table
0x42d34a) 0x42e72c (page flip) - every branch of them runs as the shipped code.

HOOKS (code hooks at the call; R = replaced: the hook records one A33Op with the arguments the original pushed and the scripted
answer, then performs the callee's `ret N`; O = observed; G = raising guard). One replaced call = exactly one A33Op, same order:
  R 0x50ca3e sprintf (+ 0x52139c report on the two fatal paths, + 0x42639d on the memory path)   -> A33_OP_LOG (a = id from the
        format string: 0x5457ac 1, 0x5457fc 2, 0x545874 3 with b = the scene dword 0x5bb57b, 0x5458a0 via 0x42639d 4)
  G 0x4c97b4 the fatal exit: must equal native A33_ERR_FATAL at the same step (always preceded by a LOG)
  R 0x44c479 -> STREAM_LOCK (cdecl 0x5b4c3a)   R 0x44c4ab -> STREAM_UNLOCK (cdecl 0x5b4c3a)
  R 0x449a94 (ECX = thread) -> THREAD_STOP      R `call [edx]` at 0x42c43b (flag 1, scripted vtable) -> THREAD_DELETE
  R 0x51dc6c -> FREE (a = pointer)              R 0x415011 (ret 4) -> Z_UNREGISTER
  R 0x4c2dfb (ret 4, only when *ptr != 0; zeroes *ptr) -> SURFACE_RELEASE (a = *ptr, b = 0 for 0x5d03bf, 1 for 0x5d03c7)
  R 0x44c4c1 -> STREAM_RESET   R 0x44c2e0(1) -> OVERLAY_LOAD (scripted handle, stored into 0x5d03c7 when it is 0, as the original does inside)
  R 0x4c2c3a (ret 0x14) -> SURFACE_CREATE (a = w, b = h; the handler stores the handle itself)
  R 0x51dc43(0x46) + 0x4497a0 (ret 0x10) -> THREAD_CREATE (a = word 0x5b016f; handle 0 = failure, malloc answers 0)
  R 0x449bff (ECX = thread) -> THREAD_RESUME   R `call [0x52a23c]` GetTickCount -> TICK (scripted, incl. values around the 2^32 wrap)
  R 0x42e560 (cdecl, 2) -> PUSH_SCENE (the push is verified elsewhere)    R 0x42ba3a (cdecl, row) -> the completion record
  O `mov [4*eax+0x585801], ecx` at 0x42ca9b -> EVENT_FLAG (the store itself runs)   R `mov [ecx], edx` at 0x42e7a5 -> SURFACE_PIXELS
  G 0x44a2b7 (debug flag 0x63a4cd is kept 0)
Windows imports other than GetTickCount are stubbed as in the 0xd9 oracle; any unexpected import fails the run.

COMPARED per dispatcher call (step): the ordered op log of every handler visit (op, the arguments that are defined for the op, the
returns), which rows entered the handler (against the open-row model), fatal-vs-A33_ERR_FATAL, completion-vs-finished, the row phase
after the step, every A33State field against the original bytes at its address (clip / overlay names in full), the request
dword and the four rectangle words of every row, the pointers 0x5b4ead / 0x5b4ea5 / 0x5b4ea9 (original value vs the body address),
the number of scripted answers each side consumed, and a stray-write check (every changed byte of the data segment must belong to a
modelled cell).

EXPECTED DIFFERENCES (tagged and counted separately, never counted as a pass of the original comparison):
  E1 negative counts, names without a NUL, bodies shorter than their counts: a33_set_parse refuses (the original allocates >= 2 GiB,
     scans past the span, reads out of bounds). hotspot_count <= 0 is NOT one: the original is fatal there and so is the kernel.
  E2 a host op failure: native A33_ERR_HOST after the failed op (the original has no failure); the log up to the failed op must be a
     prefix of the original's.
  E3 row cells of a row other than the running one (0x42caa8 writes the cells of row 0x5b4e89): native A33_ERR_UNSUPPORTED.
  E4 argument validation (NULL, negative row).

Run (from outputs/blackmoor-decomp/tests):
  python3 -I action_family_33_runtime_original_oracle.py --mutations --result <receipt.json>
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.dont_write_bytecode = True

import argparse
import ctypes as C
import hashlib
import json
import os
import random
import shutil
import struct
import subprocess
import tempfile
import time
from collections import Counter

from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT, PROJECT, PRIVATE = d9.ROOT, d9.PROJECT, d9.PRIVATE
sha, u32 = d9.sha, d9.u32
M32 = 0xFFFFFFFF
TYPE = 0x33
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
REQ_OFF = 0x73            # 0x5bb626 - 0x5bb5b3
RECT_OFF = (0x77, 0x79, 0x7B, 0x7D)   # 0x5bb62a .. 0x5bb630
EVENTS_VA = d9.EVENTS_VA
MAX_ROWS = 4
EVENT_SLOTS = 2048     # the event flag array 0x585801 (the corpus rows use indexes around 1000)
STRIDE = 0x400
DATA_LO, DATA_HI = 0x530000, 0x640000
HANDLER = 0x42C221
RESULT_DEFAULT = ROOT / 'work/analysis/slices/RT-46.oracle-result.json'

# scripted memory: thread objects (first dword = a vtable address; THREAD_DELETE is replaced, the object only has to be readable)
SCRIPT = 0x24000000
VTBL = SCRIPT + 0x80
THREAD_BLOCK = SCRIPT + 0x800        # the 0x46 byte block malloc answers for the thread object


def THR(k):
    return SCRIPT + 0x1000 + 0x20 * k


def SURF(k):
    return 0x30000000 + 0x100 * k


def BUF(k):
    return 0x31000000 + 0x1000 * k


OP = dict(LOG=1, STREAM_LOCK=2, STREAM_UNLOCK=3, THREAD_STOP=4, THREAD_DELETE=5, FREE=6, Z_UNREGISTER=7, SURFACE_RELEASE=8,
          STREAM_RESET=9, OVERLAY_LOAD=10, SURFACE_CREATE=11, THREAD_CREATE=12, THREAD_RESUME=13, TICK=14, SURFACE_PIXELS=15,
          EVENT_FLAG=16, PUSH_SCENE=17)
OPN = {v: k for k, v in OP.items()}
# which of (a, b, ret) the native A33Op defines (and is therefore compared); the other fields are only observed
OPMASK = {OP['LOG']: (1, 0, 0), OP['STREAM_LOCK']: (0, 0, 0), OP['STREAM_UNLOCK']: (0, 0, 0), OP['THREAD_STOP']: (1, 0, 0),
          OP['THREAD_DELETE']: (1, 0, 0), OP['FREE']: (1, 0, 0), OP['Z_UNREGISTER']: (0, 0, 0), OP['SURFACE_RELEASE']: (1, 1, 0),
          OP['STREAM_RESET']: (0, 0, 0), OP['OVERLAY_LOAD']: (0, 0, 1), OP['SURFACE_CREATE']: (1, 1, 1),
          OP['THREAD_CREATE']: (1, 0, 1), OP['THREAD_RESUME']: (1, 0, 0), OP['TICK']: (0, 0, 1), OP['SURFACE_PIXELS']: (1, 1, 0),
          OP['EVENT_FLAG']: (1, 1, 0), OP['PUSH_SCENE']: (1, 0, 0)}
# the state a host op can observe when it is issued (compared at every op)
SNAP = ('stream_5b4c3a', 'thread_5b4e0c', 'buf_5b4db8', 'buf_5b4dbc', 'flags_5b4dc0', 'flags_5b4dc2', 'surface_5d03bf', 'surface_5d03c7',
        'surface_5d195b', 'page_5b4dc8', 'ready_5b4e0a', 'present_5b4e04', 'active_5c39f1', 'row_5b4e89', 'kind_5b4e8b', 'mode_5b4ea3',
        'frame_5b4e00', 'state_5b4e10', 'anim_5b4e14', 'deadline_5b4dfc', 'start_5bb1ca', 'mode_583999')
QUEUE_OF = {OP['TICK']: 0, OP['SURFACE_CREATE']: 1, OP['OVERLAY_LOAD']: 2, OP['THREAD_CREATE']: 3}
QNAMES = ('tick', 'surf', 'overlay', 'thread')
LOG_FMT = {0x5457AC: 1, 0x5457FC: 2, 0x545874: 3}

# original code windows (SHA-256 of the unmodified image bytes), verified at start-up
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
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x40c186, 0x40c29b, '5138b34021766b4f3054b12b114f54fdb69dd86f129266b3b7b33b40b8100bd7'),
    # the handler and its pure callees (the jump table of 0x42d215 follows at 0x42d34a)
    (0x42c221, 0x42ca22, 'c6914d608b70a9a0197c63e1086d625565068a277f248fe81268da48d38e672b'),
    (0x42ca22, 0x42caa8, '3dead420bd958c11ea07b07b40a28799798ec3908cd78ce7af62259b78ea33f8'),
    (0x42caa8, 0x42cecd, '339940d243f4701dceb67cc550ba9f5966635ae23fca1ee2458a20bc4a14dd93'),
    (0x42cecd, 0x42d215, '9f48a16e9478f249ed705cf908ff3ae2f95d618649581cf8397be06cae4464dd'),
    (0x42d215, 0x42d34a, '817d5b8b99584248fc719be750f9ba367d653b9a7feeb1505f6d096b4090f6ad'),
    (0x42d34a, 0x42d35a, '53768be929ab962c2f1ebb71a5e09ed810ca541fa3f6bc539f67bb89ce3f7d44'),
    (0x42e72c, 0x42e7b8, '12413d5e0afa20a4f02e4c57cd50897b89999c0824ac418368dd2c10c38cca91'),
)
ORIGINAL_FUNCS = ((0x42c221, 0x42ca22), (0x42ca22, 0x42caa8), (0x42caa8, 0x42cecd), (0x42cecd, 0x42d215), (0x42d215, 0x42d34a),
                  (0x42e72c, 0x42e7b8))


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= M32
    return v - (1 << 32) if v & 0x80000000 else v


# ---------------------------------------------------------------------------------------------
# the typed body
# ---------------------------------------------------------------------------------------------
def make_body(clip=b'TESTCLIP', overlay=b'TESTOVER', w42=0, w44=0, kind=1, anim=1, w4a=1, rng=(0, 3, 0, 3, 3, 3), scene=7,
              w5a=11, w5c=12, w5e=13, d60=1000, d64=-2000, d68=3000, push=1, entries=(), hotspots=()):
    """113 + 6 * count_6d + 66 * count_6f bytes. rng = (w4c, w4e, w50, w52, w54, w56). Names are synthetic."""
    b = bytearray(0x71)
    b[0:len(clip) + 1] = clip + b'\0'
    b[0x21:0x21 + len(overlay) + 1] = overlay + b'\0'
    struct.pack_into('<6h', b, 0x42, w42, w44, kind, anim, w4a, rng[0])
    struct.pack_into('<5h', b, 0x4e, rng[1], rng[2], rng[3], rng[4], rng[5])
    struct.pack_into('<4h', b, 0x58, scene, w5a, w5c, w5e)
    struct.pack_into('<3i', b, 0x60, d60, d64, d68)
    b[0x6c] = push
    struct.pack_into('<2h', b, 0x6d, len(entries), len(hotspots))
    for key, index, value in entries:
        b += struct.pack('<3h', key, index, value)
    for h in hotspots:
        b += struct.pack('<h', h['key'])
        for name in ('src1', 'dst1', 'src2', 'dst2'):
            b += struct.pack('<4i', *h[name])
    return bytes(b)


def parse_body(body):
    ec, hc = struct.unpack_from('<2h', body, 0x6d)
    ent = [struct.unpack_from('<3h', body, 0x71 + 6 * i) for i in range(max(ec, 0))]
    base = 0x71 + 6 * max(ec, 0)
    hot = []
    for i in range(max(hc, 0)):
        o = base + 66 * i
        hot.append(dict(key=struct.unpack_from('<h', body, o)[0], src1=struct.unpack_from('<4i', body, o + 2),
                        dst1=struct.unpack_from('<4i', body, o + 0x12), src2=struct.unpack_from('<4i', body, o + 0x22),
                        dst2=struct.unpack_from('<4i', body, o + 0x32)))
    return dict(entry_count=ec, hotspot_count=hc, entries=ent, hotspots=hot,
                kind=struct.unpack_from('<h', body, 0x46)[0], anim=struct.unpack_from('<h', body, 0x48)[0],
                rng=struct.unpack_from('<6h', body, 0x4c), push=body[0x6c])


def hs(key, src1, dst1, src2=None, dst2=None):
    return dict(key=key, src1=src1, dst1=dst1, src2=src2 or tuple(x + 1000 for x in src1), dst2=dst2 or tuple(x + 50 for x in dst1))


# ---------------------------------------------------------------------------------------------
# the original (machine B)
# ---------------------------------------------------------------------------------------------
class Oracle(d9.X86):
    """The 0xd9 machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x33 hooks."""

    def __init__(self):
        self.tick_boxed = None
        self.queues = [[], [], [], []]
        self.queue_pos = [0, 0, 0, 0]
        self.calls = []
        self.cur = None
        self.pending_thread = 0
        self.ctor_fail = False
        self.snap_fields = []
        self.coverage = set()
        self.cover_on = False
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual, digest is not None))
        uc = self.machine
        uc.mem_map(SCRIPT, 0x10000)
        self.writes = Counter()
        self.clear_logs()
        self._write_script_memory()

    def _write_script_memory(self):
        for k in range(32):
            self.wr(THR(k), struct.pack('<I', VTBL))

    # -- hooks ------------------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        table = {HANDLER: self._entry, 0x50CA3E: self._sprintf, 0x52139C: self._report, 0x42639D: self._log_memory,
                 0x4C97B4: self._fatal_exit, 0x44C479: self._lock, 0x44C4AB: self._unlock, 0x449A94: self._thread_stop,
                 0x42C43B: self._thread_delete, 0x51DC6C: self._free, 0x415011: self._z_unregister, 0x4C2DFB: self._surface_release,
                 0x44C4C1: self._stream_reset, 0x44C2E0: self._overlay_load, 0x4C2C3A: self._surface_create,
                 0x4497A0: self._thread_proc, 0x449BFF: self._thread_resume, 0x42E560: self._push_scene,
                 0x42BA3A: self._complete, 0x42CA9B: self._event_flag, 0x42E7A5: self._pixels, 0x44A2B7: self._raise_guard}
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_LO, end=DATA_HI)
        for lo, hi in ORIGINAL_FUNCS:
            uc.hook_add(UC_HOOK_CODE, self._cover, begin=lo, end=hi - 1)

    def _cover(self, uc, address, size, user):
        if self.cover_on:
            self.coverage.add(address)

    def _on_write(self, uc, access, address, size, value, user):
        self.writes[(address, size)] += 1

    def _args(self, uc, n):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        return [u32(uc, sp + 4 + 4 * i) for i in range(n)]

    def _op(self, op, a=0, b=0, ret=None):
        if self.cur is None:
            raise d9.OracleError('%s outside the handler' % OPN[op])
        self.cur['ops'].append((op, a, b, ret))
        self.cur['snaps'].append(self.snapshot())
        self.op_count[OPN[op]] += 1

    def snapshot(self):
        out = []
        for f in self.snap_fields:
            raw = self.rd(f.address, f.size * f.count)
            out.append(tuple(f.norm(int.from_bytes(raw[k * f.size:(k + 1) * f.size], 'little')) for k in range(f.count)))
        return tuple(out)

    def _pop(self, q):
        queue = self.queues[q]
        if not queue:
            raise d9.OracleError('scripted queue %s empty' % QNAMES[q])
        pos = self.queue_pos[q]
        value = queue[min(pos, len(queue) - 1)]
        self.queue_pos[q] += 1
        return value & M32

    def _expect_ecx(self, uc, value, what):
        if uc.reg_read(X.UC_X86_REG_ECX) != value:
            raise d9.OracleError('%s with ECX %#x' % (what, uc.reg_read(X.UC_X86_REG_ECX)))

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = s16(u32(uc, sp + 4))
        phase = u32(uc, ROWS + row * ROW + PHASE_OFF)
        self.cur = dict(row=row, phase=phase, ops=[], snaps=[], fatal=False, completed=False)
        self.calls.append(self.cur)

    def _sprintf(self, uc, address, size, user):
        a = self._args(uc, 4)
        if a[0] != 0x63888B or a[1] not in LOG_FMT:
            raise d9.OracleError('sprintf with an unexpected buffer/format %#x %#x' % (a[0], a[1]))
        ident = LOG_FMT[a[1]]
        self._op(OP['LOG'], ident, s32(a[2]) if ident == 3 else 0)
        self._ret(uc, 0, 0)

    def _report(self, uc, address, size, user):
        a = self._args(uc, 3)
        last = self.cur['ops'][-1] if self.cur and self.cur['ops'] else None
        if a != [0x63888B, 0, 0] or last is None or last[0] != OP['LOG'] or last[1] not in (1, 2):
            raise d9.OracleError('report 0x52139c not after a fatal-path log: %r' % (a,))
        self._ret(uc, 0xC, 0)

    def _log_memory(self, uc, address, size, user):
        self._expect_ecx(uc, 0x583979, '0x42639d')
        a = self._args(uc, 2)
        if a != [0x5458A0, 0x63888B]:
            raise d9.OracleError('0x42639d arguments %r' % (a,))
        self._op(OP['LOG'], 4, 0)
        self._ret(uc, 8, 0)

    def _fatal_exit(self, uc, address, size, user):
        self._expect_ecx(uc, 0x5CF659, '0x4c97b4')
        last = self.cur['ops'][-1] if self.cur and self.cur['ops'] else None
        if last is None or last[0] != OP['LOG'] or last[1] not in (1, 2, 4):
            raise d9.OracleError('fatal exit without a fatal-path log')
        self.cur['fatal'] = True
        raise d9.Fatal(address)

    def _raise_guard(self, uc, address, size, user):
        raise d9.OracleError('guarded original routine %#x reached' % address)

    def _lock(self, uc, address, size, user):
        if self._args(uc, 1) != [0x5B4C3A]:
            raise d9.OracleError('stream lock argument')
        self._op(OP['STREAM_LOCK'])
        self._ret(uc, 0, 0)

    def _unlock(self, uc, address, size, user):
        if self._args(uc, 1) != [0x5B4C3A]:
            raise d9.OracleError('stream unlock argument')
        self._op(OP['STREAM_UNLOCK'])
        self._ret(uc, 0, 0)

    def _thread_stop(self, uc, address, size, user):
        self._op(OP['THREAD_STOP'], s32(uc.reg_read(X.UC_X86_REG_ECX)))
        self._ret(uc, 0, 0)

    def _thread_delete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if u32(uc, sp) != 1:
            raise d9.OracleError('virtual destructor flag %#x' % u32(uc, sp))
        self._op(OP['THREAD_DELETE'], s32(uc.reg_read(X.UC_X86_REG_ECX)))
        uc.reg_write(X.UC_X86_REG_ESP, sp + 4)      # the callee's ret 4
        uc.reg_write(X.UC_X86_REG_EAX, 0)
        uc.reg_write(X.UC_X86_REG_EIP, address + size)

    def _free(self, uc, address, size, user):
        self._op(OP['FREE'], s32(self._args(uc, 1)[0]))
        self._ret(uc, 0, 0)

    def _z_unregister(self, uc, address, size, user):
        self._expect_ecx(uc, 0x5E2DBE, '0x415011')
        if self._args(uc, 1) != [0x5B4C3E]:
            raise d9.OracleError('z unregister argument')
        self._op(OP['Z_UNREGISTER'])
        self._ret(uc, 4, 0)

    def _surface_release(self, uc, address, size, user):
        self._expect_ecx(uc, 0x5CF659, '0x4c2dfb')
        ptr = self._args(uc, 1)[0]
        if ptr not in (0x5D03BF, 0x5D03C7):
            raise d9.OracleError('surface release of %#x' % ptr)
        old = u32(uc, ptr)
        if old != 0:
            self._op(OP['SURFACE_RELEASE'], s32(old), 0 if ptr == 0x5D03BF else 1)
            self.wr(ptr, bytes(4))
        self._ret(uc, 4, 0)

    def _stream_reset(self, uc, address, size, user):
        if self._args(uc, 1) != [0x5B4C3E]:
            raise d9.OracleError('stream reset argument')
        self._op(OP['STREAM_RESET'])
        self._ret(uc, 0, 0)

    def _overlay_load(self, uc, address, size, user):
        if self._args(uc, 1) != [1]:
            raise d9.OracleError('overlay load argument')
        handle = self._pop(2)
        self._op(OP['OVERLAY_LOAD'], 0, 0, s32(handle))
        if u32(uc, 0x5D03C7) == 0:
            self.wr(0x5D03C7, struct.pack('<I', handle))
        self._ret(uc, 0, 0)

    def _surface_create(self, uc, address, size, user):
        self._expect_ecx(uc, 0x5CF659, '0x4c2c3a')
        a = self._args(uc, 5)
        if a[2:] != [8, 1, 0x545864]:
            raise d9.OracleError('surface create arguments %r' % (a,))
        handle = self._pop(1)
        self._op(OP['SURFACE_CREATE'], s32(a[0]), s32(a[1]), s32(handle))
        self._ret(uc, 0x14, handle)

    def _malloc(self, uc):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if u32(uc, sp) == 0x42C61E:
            if u32(uc, sp + 4) != 0x46:
                raise d9.OracleError('thread object malloc size')
            handle = self._pop(3)
            self._op(OP['THREAD_CREATE'], s16(u32(uc, 0x5B016F) & 0xFFFF), 0, s32(handle))
            self.pending_thread = handle
            self._ret(uc, 0, THREAD_BLOCK if (handle or self.ctor_fail) else 0)
            return
        super()._malloc(uc)

    def _thread_proc(self, uc, address, size, user):
        self._expect_ecx(uc, THREAD_BLOCK, '0x4497a0')
        a = self._args(uc, 4)
        word = s16(u32(uc, 0x5B016F) & 0xFFFF)
        if a != [0x44CDE2, 0x63888B, word & M32, 4]:
            raise d9.OracleError('thread proc arguments %r' % (a,))
        self._ret(uc, 0x10, self.pending_thread)

    def _thread_resume(self, uc, address, size, user):
        self._op(OP['THREAD_RESUME'], s32(uc.reg_read(X.UC_X86_REG_ECX)))
        self._ret(uc, 0, 0)

    def _push_scene(self, uc, address, size, user):
        self._op(OP['PUSH_SCENE'], s32(self._args(uc, 1)[0]))
        self._ret(uc, 0, 0)

    def _complete(self, uc, address, size, user):
        row = s16(self._args(uc, 1)[0])
        if self.cur is None or row != self.cur['row']:
            raise d9.OracleError('completion for row %d' % row)
        self.cur['completed'] = True
        self._ret(uc, 0, 0)

    def _event_flag(self, uc, address, size, user):
        index = s32(uc.reg_read(X.UC_X86_REG_EAX))
        value = s32(uc.reg_read(X.UC_X86_REG_ECX))
        if not 0 <= index < EVENT_SLOTS:
            raise d9.OracleError('scenario generated event index %d' % index)
        self._op(OP['EVENT_FLAG'], index, value)

    def _pixels(self, uc, address, size, user):
        self._op(OP['SURFACE_PIXELS'], s32(uc.reg_read(X.UC_X86_REG_ECX)), s32(uc.reg_read(X.UC_X86_REG_EDX)))
        uc.reg_write(X.UC_X86_REG_EIP, address + size)     # the store goes to a scripted surface: not executed

    def _on_import(self, uc, address, size, user):
        name, _iat = self.imports[address]
        if name == 'GetTickCount':
            value = self._pop(0)
            self._op(OP['TICK'], 0, 0, s32(value))
            self._ret(uc, 0, value)
            return
        super()._on_import(uc, address, size, user)

    # -- scenario plumbing ------------------------------------------------------------------------
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
        self._write_script_memory()

    def clear_logs(self):
        self.calls, self.cur = [], None
        self.op_count = getattr(self, 'op_count', Counter())

    def install_rows(self, rows, stride=STRIDE):
        total = len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        self.pdata = []
        for i, spec in enumerate(rows):
            base_va = ROWS + i * ROW
            body_at = d9.BODY_BASE + stride * i
            self.wr(body_at, spec['body'] + bytes(16))
            self.wr(base_va + 0x30, bytes([TYPE, spec['subtype']]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base_va, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base_va + COMPLETE_OFF, b'\0')
            self.w32(base_va + PHASE_OFF, 0)
            self.pdata.append(body_at)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def dispatch(self):
        """One call of the real dispatcher 0x427a50. Returns True when a fatal exit ended it."""
        self.clear_logs()
        self.writes.clear()
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        for q in range(4):
            self.queue_pos[q] = 0
        try:
            self.call(0x427A50, [], 0)
            return False
        except d9.Fatal:
            return True
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out, kernel=None):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_33_runtime_oracle_driver.c'), str(kernel or Path(src_dir) / 'action_family_33_runtime.c'),
           '-o', str(out)]
    if os.environ.get('A33_SANITIZE'):     # 'ub' = UBSan only (no preload needed); anything else adds ASan (needs LD_PRELOAD of its runtime)
        kinds = 'undefined' if os.environ['A33_SANITIZE'] == 'ub' else 'address,undefined'
        cmd[1:1] = ['-fsanitize=' + kinds, '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer'] + (['-fsanitize-trap=undefined'] if kinds == 'undefined' else [])
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-1200:])
    return out


class Field:
    def __init__(self, i, name, address, size, count, signed, pointer):
        self.i, self.name, self.address, self.size, self.count, self.signed, self.pointer = i, name, address, size, count, signed, pointer

    def norm(self, v):
        v &= (1 << (8 * self.size)) - 1
        if self.pointer:
            return int(v != 0)
        if self.signed and v >> (8 * self.size - 1):
            v -= 1 << (8 * self.size)
        return v

    def span(self):
        return range(self.address, self.address + self.size * self.count)


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a33o_new.restype = C.c_void_p
        lib.a33o_free.argtypes = [C.c_void_p]
        lib.a33o_field_count.restype = C.c_int
        lib.a33o_field_info.argtypes = [C.c_int, C.c_char_p, C.POINTER(C.c_uint32), C.POINTER(C.c_int), C.POINTER(C.c_int),
                                        C.POINTER(C.c_int), C.POINTER(C.c_int)]
        lib.a33o_peek.argtypes = [C.c_void_p, C.c_int, C.c_int]
        lib.a33o_peek.restype = C.c_int64
        lib.a33o_poke.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int64]
        lib.a33o_zero_state.argtypes = [C.c_void_p]
        lib.a33o_parse.argtypes = [C.c_void_p, C.c_int, C.c_char_p, C.c_size_t, C.c_char_p, C.c_int]
        lib.a33o_script.argtypes = [C.c_void_p, C.c_int, C.POINTER(C.c_int64), C.c_int]
        lib.a33o_consumed.argtypes = [C.c_void_p, C.c_int]
        lib.a33o_consumed.restype = C.c_int
        lib.a33o_exhausted.argtypes = [C.c_void_p, C.c_int]
        lib.a33o_exhausted.restype = C.c_int
        lib.a33o_set_fail.argtypes = [C.c_void_p, C.c_int]
        lib.a33o_cells_get.argtypes = [C.c_void_p, C.c_int, C.POINTER(C.c_int32)]
        lib.a33o_cells_set.argtypes = [C.c_void_p, C.c_int, C.POINTER(C.c_int32)]
        lib.a33o_step.argtypes = [C.c_void_p, C.c_int, C.c_uint32, C.POINTER(C.c_uint32), C.POINTER(C.c_int), C.POINTER(C.c_int),
                                  C.c_char_p, C.c_int]
        lib.a33o_step.restype = C.c_int
        lib.a33o_log_count.argtypes = [C.c_void_p]
        lib.a33o_log_count.restype = C.c_int
        lib.a33o_log_get.argtypes = [C.c_void_p, C.c_int, C.POINTER(C.c_int32)]
        lib.a33o_log_peek.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int]
        lib.a33o_log_peek.restype = C.c_int64
        self.fields = []
        for i in range(lib.a33o_field_count()):
            name, addr, size, count, signed, ptr = C.create_string_buffer(40), C.c_uint32(), C.c_int(), C.c_int(), C.c_int(), C.c_int()
            lib.a33o_field_info(i, name, C.byref(addr), C.byref(size), C.byref(count), C.byref(signed), C.byref(ptr))
            self.fields.append(Field(i, name.value.decode(), addr.value, size.value, count.value, signed.value, ptr.value))
        self.by_name = {f.name: f for f in self.fields}
        self.h = lib.a33o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.a33o_free(self.h)
        self.h = None

    def poke(self, name, idx, value):
        self.lib.a33o_poke(self.h, self.by_name[name].i, idx, value)

    def peek(self, f):
        return [f.norm(self.lib.a33o_peek(self.h, f.i, k)) for k in range(f.count)]

    def parse(self, row, body):
        why = C.create_string_buffer(80)
        status = self.lib.a33o_parse(self.h, row, bytes(body), len(body), why, 80)
        return status, why.value.decode()

    def script(self, queue, values):
        arr = (C.c_int64 * max(len(values), 1))(*values)
        self.lib.a33o_script(self.h, queue, arr, len(values))

    def consumed(self):
        return [self.lib.a33o_consumed(self.h, q) for q in range(4)]

    def cells(self, row):
        out = (C.c_int32 * 5)()
        self.lib.a33o_cells_get(self.h, row, out)
        return list(out)

    def set_cells(self, row, vals):
        arr = (C.c_int32 * 5)(*vals)
        self.lib.a33o_cells_set(self.h, row, arr)

    def step(self, row, phase):
        pa, ini, fin = C.c_uint32(), C.c_int(), C.c_int()
        why = C.create_string_buffer(120)
        status = self.lib.a33o_step(self.h, row, phase, C.byref(pa), C.byref(ini), C.byref(fin), why, 120)
        ops, snaps = [], []
        out = (C.c_int32 * 4)()
        snap_fields = [f for f in self.fields if f.name in SNAP]
        for i in range(self.lib.a33o_log_count(self.h)):
            self.lib.a33o_log_get(self.h, i, out)
            ops.append(tuple(out))
            snaps.append(tuple(tuple(f.norm(self.lib.a33o_log_peek(self.h, i, f.i, k)) for k in range(f.count)) for f in snap_fields))
        return dict(status=status, snaps=snaps, phase_after=pa.value, initialized=ini.value, finished=fin.value, why=why.value.decode(), ops=ops)


# ---------------------------------------------------------------------------------------------
# machine A: the real loader
# ---------------------------------------------------------------------------------------------
class Loader:
    def __init__(self):
        import action_family_33_original_oracle as l33
        from cif_original_oracle import PEImage
        self.l33 = l33
        pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
        if sha(pe.data) != l33.EXE_HASH:
            raise d9.OracleError('loader machine: executable identity')
        for start, end, digest in l33.CODE:
            if sha(pe.image[start - pe.image_base:end - pe.image_base]) != digest:
                raise d9.OracleError('loader code window %#x' % start)
        self.machine = l33.Original(pe)
        self.cache = {}
        self.calls = 0

    def typed(self, body, subtype, tail=b''):
        """The original's object for `body`: the bytes loader 0x40b34a / arm 0x40c186 produced."""
        key = (body, subtype, tail)
        if key not in self.cache:
            payload = self.l33.payload_for(body + tail, subtype)
            image, advance, _ = self.machine.invoke(payload, seed_byte=0x5A)
            self.calls += 1
            self.cache[key] = (image, advance)
        return self.cache[key]


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
FIELD_DEFAULT = {'mode_583999': 3}


def S(sid, rows, steps, group='basic', init=None, quick=False, observed_gate=False):
    return dict(id=sid, rows=rows, steps=steps, group=group, init=init or {}, quick=quick, observed_gate=observed_gate)


def Row(body, subtype=1, tail=b''):
    return dict(body=body, subtype=subtype, tail=tail)


def step(set=None, phase=None, tick=None, surf=None, overlay=None, thread=None, cells=None, note='', ctor_fail=False):
    return dict(set=set or {}, phase=phase or {}, tick=tick, surf=surf, overlay=overlay, thread=thread, cells=cells or {}, note=note,
                ctor_fail=ctor_fail)


# deterministic scripted answers
SURF_ANS = [SURF(1), SURF(2), SURF(3)]
OVL_ANS = [SURF(5), SURF(6)]
THR_ANS = [THR(1), THR(2)]
FIVE = {'tick': [('abs', 1000)]}


def play_state(row=0, **kw):
    """The cells phase 1 reads, set to a consistent running state (as phase 0 leaves them)."""
    d = {'row_5b4e89': row, 'active_5c39f1': 1, 'surface_5d03bf': SURF(7), 'thread_5b4e0c': THR(3)}
    d.update(kw)
    return d


def hot_set(sel, hotspots_dst, kinds=(1, 1)):
    return None


def build_scenarios(seed, corpus_rows):
    rng = random.Random(seed)
    scs = []
    def st0(**kw):
        kw.setdefault('tick', [('abs', 1000)])
        kw.setdefault('surf', SURF_ANS)
        kw.setdefault('overlay', OVL_ANS)
        kw.setdefault('thread', THR_ANS)
        kw.setdefault('phase', {0: 0})
        return step(**kw)

    # -- corpus: the three real rows, real tails and without them ------------------------------------------------
    for n, (label, payload_body, subtype, typed_len) in enumerate(corpus_rows):
        body = payload_body[:typed_len]
        info = parse_body(body)
        key0 = info['hotspots'][0]['key'] if info['hotspots'] else 1
        tail = payload_body[typed_len:]
        for variant, tl in (('real_tail', tail), ('bare', b'')):
            steps = [
                st0(set={'selector_5bb50b': key0, 'delay_5b4c5a': 40, 'view_x_583186': 3, 'view_y_58318a': -2,
                         'clip_5bb583': [0, 0, 639, 479], 'vrect_5b4de8': 0, 'vrect_5b4df0': 319, 'vrect_5b4dec': 0, 'vrect_5b4df4': 239,
                         'thread_arg_5b016f': 9, 'scene_5bb57b': 77}),
                step(set={'ready_5b4e0a': 1, 'selector_5bb50b': key0}, tick=[('abs', 2000), ('abs', 2001)]),
                step(set={'ready_5b4e0a': 1}, tick=[('dl', 1), ('dl', 2)]),
                step(set={'ready_5b4e0a': 0}, tick=[('dl', -3), ('dl', 5)]),
                step(set={'ready_5b4e0a': 1}, tick=[('dl', 0), ('dl', 5)]),
                step(phase={0: 2}, set={'ready_5b4e0a': 0}),
                step(set={'ready_5b4e0a': 1}),
            ]
            scs.append(S('corpus:%d:%s' % (n, variant), [Row(body, subtype, tl)], steps, 'corpus', quick=n == 0 and variant == 'bare',
                         observed_gate=(variant == 'real_tail')))

    # -- phase 0 ---------------------------------------------------------------------------------------------------
    h1 = [hs(5, (1, 2, 3, 4), (10, 20, 30, 40))]
    for kind in (1, 2):
        for anim in (0, 1, 2, 3, 77):
            for w44 in (0, 2):
                body = make_body(kind=kind, anim=anim, w44=w44, w4a=2 if kind == 2 else 1, hotspots=h1, rng=(2, 6, 3, 5, 4, 7))
                scs.append(S('phase0:kind%d:anim%d:w44_%d' % (kind, anim, w44), [Row(body)],
                             [st0(set={'selector_5bb50b': 5, 'vrect_5b4de8': 10, 'vrect_5b4df0': 109, 'vrect_5b4dec': 20,
                                       'vrect_5b4df4': 59, 'scene_5bb57b': -5, 'thread_arg_5b016f': -7, 'frame_5b4e00': 99,
                                       'state_5b4e10': 4, 'anim_5b4e14': 2, 'ready_5b4e0a': 1}),
                              step(set={'ready_5b4e0a': 1}, tick=[('abs', 50), ('abs', 51)])],
                             'phase0', quick=(kind, anim, w44) in ((1, 1, 0), (2, 2, 2))))
    # old thread / buffers / surfaces present: every teardown branch, flag bit 8 meaning "do not free"
    old = lambda **kw: dict({'thread_5b4e0c': THR(4), 'stream_5b4c3a': 9, 'buf_5b4db8': BUF(1), 'buf_5b4dbc': BUF(2),
                             'flags_5b4dc0': 0, 'flags_5b4dc2': 0, 'surface_5d03bf': SURF(8), 'surface_5d03c7': SURF(9),
                             'clip_5b4d8f': [0x5A] * 33, 'overlay_5b4e68': [0x5B] * 33}, **kw)
    body2 = make_body(kind=2, w4a=2, hotspots=h1)
    body1 = make_body(kind=1, hotspots=h1)
    for f0 in (0, 8, 1, 0x108, 0xFFF7):
        for f2 in (0, 8, 0x10, 0xFFFF):
            for b0, b2 in ((1, 1), (1, 0), (0, 1), (0, 0)):
                if f0 not in (0, 8) and f2 not in (0, 8):
                    continue
                state = old(flags_5b4dc0=f0, flags_5b4dc2=f2, buf_5b4db8=BUF(1) if b0 else 0, buf_5b4dbc=BUF(2) if b2 else 0)
                scs.append(S('phase0:teardown:f%x_%x:b%d%d' % (f0, f2, b0, b2), [Row(body2)], [st0(set=state)], 'phase0',
                             quick=(f0, f2, b0, b2) == (0, 8, 1, 1)))
    for sn, state in (('thread_only', {'thread_5b4e0c': THR(4), 'stream_5b4c3a': 5}),
                      ('surfaces_only', {'surface_5d03bf': SURF(8), 'surface_5d03c7': SURF(9)}),
                      ('bf_only', {'surface_5d03bf': SURF(8)}), ('c7_only', {'surface_5d03c7': SURF(9)}),
                      ('stale_names', {'clip_5b4d8f': [0x5A] * 33, 'overlay_5b4e68': [0x5B] * 33})):
        for kind_body in (body1, body2):
            scs.append(S('phase0:%s:%s' % (sn, 'k2' if kind_body is body2 else 'k1'), [Row(kind_body)], [st0(set=state)], 'phase0'))
    # fatal: second video, thread creation failure, missing hotspots
    scs.append(S('fatal:second_video_active', [Row(body1)], [st0(set={'active_5c39f1': 1})], 'fatal', quick=True))
    scs.append(S('fatal:double_phase0', [Row(body1)], [st0(), step(phase={0: 0}, tick=[('abs', 5)], surf=SURF_ANS, overlay=OVL_ANS,
                                                                       thread=THR_ANS)], 'fatal'))
    scs.append(S('fatal:two_rows_second_phase0', [Row(body1), Row(body2)],
                 [step(phase={0: 0, 1: 0}, tick=[('abs', 5)], surf=SURF_ANS, overlay=OVL_ANS, thread=THR_ANS)], 'fatal', quick=True))
    scs.append(S('fatal:thread_create_failure', [Row(body1)], [st0(thread=[0])], 'fatal'))
    scs.append(S('fatal:thread_create_failure_overlay', [Row(body2)], [st0(thread=[0, 0])], 'fatal'))
    scs.append(S('fatal:thread_constructor_failure', [Row(body1)], [st0(thread=[0], ctor_fail=True)], 'fatal'))
    scs.append(S('fatal:thread_constructor_failure_old_thread', [Row(body1)],
                 [st0(thread=[0], ctor_fail=True, set={'thread_5b4e0c': THR(4), 'stream_5b4c3a': 5})], 'fatal'))
    for k in (0, 5):
        b0 = make_body(hotspots=[])
        b0 = b0[:0x6f] + struct.pack('<h', 0)
        scs.append(S('fatal:no_hotspots_phase%d' % k, [Row(make_body(hotspots=[], entries=[(1, 2, 3)]))],
                     [step(phase={0: k}, set={'active_5c39f1': 0})], 'fatal', quick=k == 0))
    scs.append(S('fatal:no_hotspots_no_entries', [Row(make_body(hotspots=[]))], [step(phase={0: 1}), step(phase={0: 0})], 'fatal'))
    # other phase values return after the prelude
    for p in (3, 4, 7, 0x100, 0x80000000, 0xFFFFFFFF):
        scs.append(S('phase:other_%x' % p, [Row(make_body(entries=[(0, 1, 2)], hotspots=h1))],
                     [step(phase={0: p}, set=play_state(selector_5bb50b=5, frame_5b4e00=0, state_5b4e10=4, ready_5b4e0a=1,
                                                         row_5b4e89=0), tick=[('abs', 5)])], 'phase', quick=p == 3))

    # -- phase 2 ----------------------------------------------------------------------------------------------
    for push in (0, 1, 2, 255):
        for ready in (0, 1):
            body = make_body(push=push, scene=-3, w5a=-4, w5c=0x7FFF, w5e=-32768, d60=-0x7FFFFFFF, d64=0x7FFFFFFF, d68=-1,
                             hotspots=h1)
            scs.append(S('phase2:push%d:ready%d' % (push, ready), [Row(body)],
                         [step(phase={0: 2}, set=play_state(ready_5b4e0a=ready, kind_5b4e8b=2, mode_5b4ea3=2)),
                          step(set={'mode_583999': 3, 'ready_5b4e0a': 1, 'active_5c39f1': 1, 'row_5b4e89': 0}, phase={0: 2})],
                         'phase2', quick=(push, ready) in ((1, 1), (1, 0))))
    scs.append(S('phase2:two_rows', [Row(make_body(hotspots=h1, scene=1)), Row(make_body(hotspots=h1, scene=2))],
                 [step(phase={0: 2, 1: 2}, set=play_state(ready_5b4e0a=1))], 'phase2'))

    # -- event flags (0x42ca22) -------------------------------------------------------------------------------
    ents = [(0, 5, 100), (1, -1, 7), (1, 63, -32768), (2, 0, 32767), (1, 9, -1), (0, 5, -5), (2, -1, 9)]
    for frame in (0, 1, 2, 3, -1):
        for ec in (0, 1, 2, 4, 7):
            body = make_body(entries=ents[:ec], hotspots=h1)
            for ready_tick in ('first', 'second'):
                if ready_tick == 'first':
                    st = [step(phase={0: 1}, set=play_state(selector_5bb50b=5, state_5b4e10=0, ready_5b4e0a=1, frame_5b4e00=frame,
                                                            anim_5b4e14=3), tick=[('abs', 10)])]
                else:
                    st = [step(phase={0: 1}, set=play_state(selector_5bb50b=5, state_5b4e10=4, ready_5b4e0a=1, frame_5b4e00=frame,
                                                            anim_5b4e14=3, deadline_5b4dfc=0), tick=[('abs', 10), ('abs', 20)])]
                scs.append(S('events:frame%d:count%d:%s' % (frame, ec, ready_tick), [Row(body)], st, 'events',
                             quick=(frame, ec, ready_tick) in ((1, 7, 'first'), (2, 4, 'second'))))
    # an entry table of one entry: nonzero / zero flag, table pointer NULL case (count 0 after hotspots)
    # -- frame advance 0x42d215 -----------------------------------------------------------------------------------
    for mode in (0, 1, 2, 3, 4, 9, -1):
        for fr in (-2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10):
            for latch in (0, 5):
                body = make_body(rng=(2, 6, 3, 5, 4, 8), hotspots=h1)
                scs.append(S('advance:mode%d:frame%d:latch%d' % (mode, fr, latch), [Row(body)],
                             [step(phase={0: 1}, set=play_state(selector_5bb50b=5, state_5b4e10=0, ready_5b4e0a=1, frame_5b4e00=fr,
                                                                anim_5b4e14=mode, latch_5c39e5=latch, row_5b4e89=0), tick=[('abs', 10)])],
                             'advance', quick=(mode, fr, latch) in ((0, 6, 0), (1, 5, 5), (1, 3, 0), (2, 2, 0), (3, 8, 5))))
    # candidate rule: state 1 -> 2 only when the latch differs from the row word; rows other than 0
    for row_n in (0, 1, 2):
        rows = [Row(make_body(rng=(2, 6, 3, 5, 4, 8), hotspots=h1)) for _ in range(row_n + 1)]
        for latch in (row_n, row_n + 1, -1, 0):
            scs.append(S('advance:candidate:row%d:latch%d' % (row_n, latch), rows,
                         [step(phase={row_n: 1}, set=play_state(row=row_n, selector_5bb50b=5, state_5b4e10=0, ready_5b4e0a=1,
                                                                frame_5b4e00=3, anim_5b4e14=1, latch_5c39e5=latch), tick=[('abs', 10)])
                          ] + [step(set={'ready_5b4e0a': 1, 'state_5b4e10': 0}, tick=[('abs', 10)])], 'advance', quick=(row_n, latch) == (1, 0)))

    # -- page flip 0x42e72c ----------------------------------------------------------------------------------------
    for pres in (0, 1, 2, 3):
        for page in (0, 1, 5):
            for surf in (0, SURF(4)):
                for state_ in (0, 4):
                    body = make_body(hotspots=h1)
                    sets = play_state(selector_5bb50b=5, state_5b4e10=state_, ready_5b4e0a=1, present_5b4e04=pres, page_5b4dc8=page,
                                      surface_5d03bf=surf, buf_5b4db8=BUF(1), buf_5b4dbc=BUF(2), deadline_5b4dfc=0)
                    scs.append(S('flip:pres%d:page%d:surf%d:state%d' % (pres, page, int(bool(surf)), state_), [Row(body)],
                                 [step(phase={0: 1}, set=sets, tick=[('abs', 3), ('abs', 4)])], 'flip',
                                 quick=(pres, page, bool(surf), state_) in ((2, 0, True, 0), (2, 1, True, 4), (1, 0, False, 0))))

    # -- ticks, deadline, selector, states ---------------------------------------------------------------------------
    hk = [hs(5, (1, 2, 3, 4), (10, 20, 30, 40)), hs(6, (5, 6, 7, 8), (50, 60, 70, 80)), hs(5, (9, 10, 11, 12), (90, 100, 110, 120)),
          hs(-2, (13, 14, 15, 16), (130, 140, 150, 160))]
    bodyk = make_body(entries=[(0, 3, 9), (1, 4, -9)], hotspots=hk, rng=(0, 4, 0, 4, 4, 4))
    wraps = [0, 1, 0x7FFFFFFE, 0x7FFFFFFF, 0x80000000, 0x80000001, 0xFFFFFFF0, 0xFFFFFFFE, 0xFFFFFFFF]
    for st_ in (0, 4, 1, 2, 3, 5, -1):
        for ready in (0, 1):
            for sel in (5, 6, -2, 99, 0):
                for dl in (0, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 20):
                    for delay in (0, 33, -5):
                        for tick in (wraps[0], 19, 20, 21, 0x80000000, 0xFFFFFFFE, 0xFFFFFFFF):
                            if rng.random() > 0.045 and not (st_ in (0, 4) and ready == 1 and sel == 5 and delay == 33 and
                                                              tick in (19, 20, 21)):
                                continue
                            scs.append(S('tick:s%d:r%d:sel%d:dl%x:d%d:t%x' % (st_, ready, sel, dl, delay, tick), [Row(bodyk)],
                                         [step(phase={0: 1}, set=play_state(selector_5bb50b=sel, state_5b4e10=st_, ready_5b4e0a=ready,
                                                                             deadline_5b4dfc=dl, delay_5b4c5a=delay, frame_5b4e00=2,
                                                                             anim_5b4e14=0, mode_5b4ea3=0),
                                               tick=[('abs', tick), ('abs', (tick + 7) & M32), ('abs', 5)])], 'tick',
                                         quick=(st_, ready, sel, dl, delay, tick) in ((4, 1, 5, 20, 33, 21), (0, 1, 5, 20, 33, 19),
                                                                                      (4, 0, 6, 0, 0, 0))))
    # long phase-1 sequences with relative ticks: state 0 -> 4, deadline refresh, wrap
    seq = [step(phase={0: 1}, set=play_state(selector_5bb50b=5, state_5b4e10=0, ready_5b4e0a=0, delay_5b4c5a=25, anim_5b4e14=0,
                                              frame_5b4e00=1), tick=[('abs', 0xFFFFFFF0)])]
    for k in range(10):
        seq.append(step(set={'ready_5b4e0a': k % 3 != 1}, tick=[('abs', (0xFFFFFFF0 + 12 * k) & M32), ('abs', (0xFFFFFFF8 + 12 * k) & M32)]))
    scs.append(S('seq:wrap_sequence', [Row(bodyk)], seq, 'seq', quick=True))

    # -- rectangles 0x42caa8 / 0x42cecd --------------------------------------------------------------------------------
    tops = (5, 9, 10, 11, 15, 19, 20, 21, 25)
    pairs = [(t, b) for t in tops for b in tops if b >= t]
    clip_pool = [(10, 20), (10, 10), (5, 25), (0, 9), (21, 30), (0, 100000), (-0x80000000, 0x7FFFFFFF)]
    rects = []
    for i in range(0, len(pairs), 4):
        group = pairs[i:i + 4]
        hots = [hs(i * 4 + j + 1, (100 + 4 * j, 200 + t, 300 + 4 * j, 400 + b), (12 + 2 * j, t, 40 + 2 * j, b),
                   (500 + j, 600 + t, 700 + j, 800 + b), (22 + j, t + 1, 50 + j, b + 3)) for j, (t, b) in enumerate(group)]
        rects.append((i, group, make_body(hotspots=hots)))
    for i, group, body in rects:
        for kind in (1, 2):
            for mode in (0, 2):
                steps = []
                for ci, (ct, cb) in enumerate(clip_pool):
                    if rng.random() < 0.5 and ci not in (0, 1):
                        continue
                    for j in range(len(group)):
                        steps.append(step(phase={0: 1}, set=play_state(selector_5bb50b=i * 4 + j + 1, state_5b4e10=4,
                                                                        ready_5b4e0a=0, deadline_5b4dfc=0xFFFFFFFF, kind_5b4e8b=kind,
                                                                        mode_5b4ea3=mode, view_x_583186=7, view_y_58318a=-11,
                                                                        clip_5bb583=[1, ct, 639, cb]), tick=[('abs', 5)]))
                scs.append(S('rect:g%d:kind%d:mode%d' % (i, kind, mode), [Row(body)], steps, 'rect',
                             quick=(i, kind, mode) in ((0, 2, 2), (8, 1, 0))))
    # rectangle edge sweep around the clip with a single hotspot, both kinds, after-deadline path (also state 0)
    for t, b in ((10, 20), (9, 21), (10, 21), (9, 20), (20, 30), (0, 10), (21, 22), (0, 9), (30, 31), (15, 15)):
        body = make_body(hotspots=[hs(5, (1, 2, 3, 4), (3, t, 90, b), (11, 12, 13, 14), (4, t - 1, 91, b + 1))])
        for st_ in (0, 4):
            scs.append(S('rect:single:%d_%d:s%d' % (t, b, st_), [Row(body)],
                         [step(phase={0: 1}, set=play_state(selector_5bb50b=5, state_5b4e10=st_, ready_5b4e0a=1, deadline_5b4dfc=0,
                                                             kind_5b4e8b=2, mode_5b4ea3=2, clip_5bb583=[0, 10, 639, 20],
                                                             view_x_583186=-4, view_y_58318a=5, latch_5c39e5=0), tick=[('abs', 9), ('abs', 9)])],
                         'rect'))
    # stale rectangle state: a rejected rectangle keeps the previous working rectangles and recomputes the relative ones
    body = make_body(hotspots=[hs(5, (1, 2, 3, 4), (3, 50, 90, 60), (11, 12, 13, 14), (4, 50, 91, 60)),
                               hs(6, (1, 2, 3, 4), (3, 12, 90, 18), (11, 12, 13, 14), (4, 12, 91, 18))])
    scs.append(S('rect:stale', [Row(body)],
                 [step(phase={0: 1}, set=play_state(selector_5bb50b=6, state_5b4e10=4, deadline_5b4dfc=0xFFFFFFFF, kind_5b4e8b=2,
                                                      mode_5b4ea3=2, clip_5bb583=[0, 10, 639, 20]), tick=[('abs', 5)]),
                  step(set={'selector_5bb50b': 5, 'view_x_583186': 9, 'view_y_58318a': 13}, tick=[('abs', 5)]),
                  step(set={'selector_5bb50b': 6, 'kind_5b4e8b': 1}, tick=[('abs', 5)])], 'rect', quick=True))
    # row word other than the visiting row in the cells (expected difference E3 is exercised in the native safety part)

    # -- multi-visit play with a real phase 0 first -----------------------------------------------------------------
    for kind in (1, 2):
        for anim in (1, 2):
            body = make_body(kind=kind, anim=anim, w4a=2, hotspots=hk, entries=[(0, 3, 9), (4, 4, -9), (1, 5, 5)], rng=(0, 4, 0, 3, 4, 3))
            steps = [st0(set={'selector_5bb50b': 5, 'delay_5b4c5a': 30, 'clip_5bb583': [0, 0, 639, 479]})]
            for k in range(14):
                steps.append(step(set={'ready_5b4e0a': k % 2, 'selector_5bb50b': (5, 6, 5, 99)[k % 4],
                                       'latch_5c39e5': 0 if k % 5 else 3},
                                  tick=[('dl', (0, 40, -3, 5)[k % 4]), ('dl', 1), ('dl', 2)]))
            steps.append(step(phase={0: 2}, set={'ready_5b4e0a': 0}))
            steps.append(step(set={'ready_5b4e0a': 1}))
            scs.append(S('play:kind%d:anim%d' % (kind, anim), [Row(body)], steps, 'play', quick=(kind, anim) == (2, 2)))

    # -- random sweeps -------------------------------------------------------------------------------------------------
    pool = [-3, -1, 0, 1, 2, 5, 9, 10, 11, 20, 21, 25, 640, 100000, -100000, 0x7FFFFFFF, -0x80000000, 70000, -70000]
    for n in range(260):
        nh = rng.randint(1, 4)
        ne = rng.choice([0, 0, 1, 2, 3, 4])
        keys = [rng.choice([5, 6, 7, -1, 0, 5]) for _ in range(nh)]
        hots = [hs(k, tuple(rng.choice(pool) for _ in range(4)), tuple(rng.choice(pool) for _ in range(4)),
                   tuple(rng.choice(pool) for _ in range(4)), tuple(rng.choice(pool) for _ in range(4))) for k in keys]
        ents = [(rng.choice([0, 1, 2, 3, 4, 5, -1]), rng.choice([-1, -1, 0, 1, 31, 62, 63]), rng.choice([-32768, -1, 0, 1, 99, 32767]))
                for _ in range(ne)]
        w = [rng.choice([-3, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]) for _ in range(6)]
        body = make_body(kind=rng.choice([1, 2, 1, 2, 3]), anim=rng.choice([1, 2, 0, 5]), w44=rng.choice([0, 2, 1]), w4a=rng.choice([1, 2, 0]),
                         rng=tuple(w), push=rng.choice([0, 1, 1, 2]), scene=rng.randint(-5, 5), hotspots=hots, entries=ents,
                         w42=rng.randint(-5, 5), w5a=rng.randint(-5, 5), w5c=rng.randint(-5, 5), w5e=rng.randint(-5, 5))
        steps = [st0(set={'selector_5bb50b': rng.choice([5, 6, 7, -1, 0, 99]), 'delay_5b4c5a': rng.choice([0, 10, 33, -7, 0x7FFFFFFF]),
                          'clip_5bb583': [rng.choice(pool), rng.choice(pool), rng.choice(pool), rng.choice(pool)],
                          'view_x_583186': rng.choice(pool), 'view_y_58318a': rng.choice(pool),
                          'vrect_5b4de8': rng.choice(pool), 'vrect_5b4df0': rng.choice(pool), 'vrect_5b4dec': rng.choice(pool),
                          'vrect_5b4df4': rng.choice(pool)}, )]
        for k in range(rng.randint(3, 9)):
            kind_ = rng.random()
            s = {'ready_5b4e0a': rng.choice([0, 1, 1]), 'selector_5bb50b': rng.choice([5, 6, 7, -1, 0, 99]),
                 'latch_5c39e5': rng.choice([0, 0, 1, 2]), 'frame_5b4e00': rng.choice([-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9])}
            if rng.random() < 0.5:
                s['state_5b4e10'] = rng.choice([0, 4, 4, 0, 1, 2])
            if rng.random() < 0.5:
                s['anim_5b4e14'] = rng.choice([0, 1, 2, 3, 3, 4])
            if rng.random() < 0.3:
                s['deadline_5b4dfc'] = rng.choice([0, 0xFFFFFFF0, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF])
            if rng.random() < 0.3:
                s['clip_5bb583'] = [rng.choice(pool), rng.choice(pool), rng.choice(pool), rng.choice(pool)]
            if rng.random() < 0.3:
                s['view_x_583186'], s['view_y_58318a'] = rng.choice(pool), rng.choice(pool)
            if rng.random() < 0.2:
                s['page_5b4dc8'] = rng.choice([0, 1, 2])
            if rng.random() < 0.2:
                s['buf_5b4db8'], s['buf_5b4dbc'] = BUF(rng.randint(1, 5)), BUF(rng.randint(6, 9))
            if rng.random() < 0.15:
                s['kind_5b4e8b'] = rng.choice([1, 2])
                s['mode_5b4ea3'] = rng.choice([1, 2])
            ticks = [('dl', rng.choice([-5, -1, 0, 1, 5])) if rng.random() < 0.7 else ('abs', rng.choice(wraps)) for _ in range(3)]
            steps.append(step(set=s, tick=ticks))
        if rng.random() < 0.6:
            steps.append(step(phase={0: 2}, set={'ready_5b4e0a': rng.choice([0, 1])}))
            steps.append(step(set={'ready_5b4e0a': 1, 'active_5c39f1': 1}))
        scs.append(S('random:%d' % n, [Row(body)], steps, 'random', quick=n < 6))
    return scs


def corpus_rows(loader):
    """The three real raw-0x33 rows of the scene resources: (label, body+tail, subtype, typed length)."""
    corpus = json.loads((PRIVATE / 'A-33.1.corpus.json').read_text())
    if corpus['exe_sha256'] != d9.EXE_HASH or len(corpus['records']) != 3:
        raise d9.OracleError('corpus identity')
    out = []
    for i, r in enumerate(corpus['records']):
        data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % r['resource_index'])).read_bytes()
        p, size = r['act_payload_offset'], r['act_payload_length']
        payload = data[p:p + size]
        if len(payload) != size or payload[48] != 0x33:
            raise d9.OracleError('corpus row %d' % i)
        out.append(('corpus%d' % i, payload[50:], r['subtype'], r['typed_body_length']))
    return out


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
class Stats(Counter):
    pass


class OrigSide:
    """Pokes and observations on machine B."""

    def __init__(self, x, fields):
        self.x, self.fields = x, fields

    def poke(self, f, idx, value):
        self.x.wr(f.address + idx * f.size, (value & ((1 << (8 * f.size)) - 1)).to_bytes(f.size, 'little'))

    def dump(self):
        out = {}
        for f in self.fields:
            raw = self.x.rd(f.address, f.size * f.count)
            out[f.name] = [f.norm(int.from_bytes(raw[k * f.size:(k + 1) * f.size], 'little')) for k in range(f.count)]
        return out

    def row_cells(self, n):
        cells = []
        for i in range(n):
            base = ROWS + i * ROW
            cells.append([s32(u32(self.x.machine, base + REQ_OFF))] + [s16(int.from_bytes(self.x.rd(base + o, 2), 'little')) for o in RECT_OFF]
                         + [u32(self.x.machine, base + PHASE_OFF)])
        return cells


def resolve_ticks(specs, deadline):
    out = []
    for kind, v in specs:
        out.append((deadline + v) & M32 if kind == 'dl' else v & M32)
    while len(out) < 6:
        out.append(out[-1])
    return out


def pad(values, n=4):
    values = list(values)
    while len(values) < n:
        values.append(values[-1])
    return values


def allowed_bytes(fields, nrows, extra):
    ok = set()
    for f in fields:
        ok.update(f.span())
    for i in range(nrows):
        base = ROWS + i * ROW
        ok.update(range(base + REQ_OFF, base + REQ_OFF + 4))
        for o in RECT_OFF:
            ok.update(range(base + o, base + o + 2))
        ok.update(range(base + PHASE_OFF, base + PHASE_OFF + 4))
        ok.update(range(base + 0x36, base + 0x3A))     # the gate's per-row dependency state (shared, separately verified code)
    ok.update(range(0x5B4EAD, 0x5B4EAD + 4))
    ok.update(range(EVENTS_VA, EVENTS_VA + 4 * EVENT_SLOTS))
    for lo, hi in extra:
        ok.update(range(lo, hi))
    return ok


# data-region writes the dispatcher and the gate make outside the modelled cells (discovered by the first run, then pinned):
# 0x5c3a47 the candidate cell the oracle clears before each tick; 0x637871.. and 0x637e81 the gate object's scratch dwords
SCRATCH_WRITES = ((0x5C3A47, 0x5C3A4B), (0x637871, 0x637879), (0x63787D, 0x637881), (0x637E81, 0x637E85))


def norm_op(t, side):
    op, a, b, ret = t[:4]
    m = OPMASK[op]
    use_b = m[1] or (op == OP['LOG'] and a == 3)       # only the thread-start log carries an argument (the scene dword)
    return (OPN[op], a if m[0] else None, b if use_b else None, ret if m[2] else None)


def fmt_ops(ops):
    return '[' + ', '.join('%s(%s)' % (OPN[o[0]], ','.join(str(v) for v in o[1:4] if v is not None)) for o in ops[:14]) + (
        ' ...' if len(ops) > 14 else '') + ']'


def run_original(x, fields, loader, sc, stats, record_coverage=True):
    """Runs the scenario on machine B; returns the recorded steps (inputs resolved, observations)."""
    x.hard_reset()
    rows = []
    for r in sc['rows']:
        image, advance = loader.typed(r['body'], r['subtype'], r['tail'])
        if image != r['body']:
            raise Mismatch('%s: loader 0x40b34a/0x40c186 produced a different object than the scenario body' % sc['id'])
        if advance != len(r['body']):
            raise Mismatch('%s: loader advanced %d, body %d' % (sc['id'], advance, len(r['body'])))
        rows.append(dict(r, body=image))
        stats['loader_objects'] += 1
    x.install_rows(rows)
    o = OrigSide(x, fields)
    # power-on state: every modelled cell zero, then the scenario's init
    for f in fields:
        for k in range(f.count):
            o.poke(f, k, 0)
    x.wr(EVENTS_VA, bytes(4 * EVENT_SLOTS))
    for name, v in sc['init'].items():
        f = next(f for f in fields if f.name == name)
        for k, vv in enumerate(v if isinstance(v, list) else [v]):
            o.poke(f, k, vv)
    allowed = allowed_bytes(fields, len(rows), SCRATCH_WRITES)
    recorded = []
    byname = {f.name: f for f in fields}
    x.cover_on = record_coverage
    x.snap_fields = [f for f in fields if f.name in SNAP]
    for si, st in enumerate(sc['steps']):
        sets = dict(FIELD_DEFAULT)
        sets.update(st['set'])
        for name, v in sets.items():
            f = byname[name]
            vals = v if isinstance(v, list) else [v]
            for k, vv in enumerate(vals):
                o.poke(f, k, vv)
        for row, p in st['phase'].items():
            x.w32(ROWS + row * ROW + PHASE_OFF, p)
        for row, cells in st['cells'].items():
            base = ROWS + row * ROW
            x.w32(base + REQ_OFF, cells[0] & M32)
            for off, v in zip(RECT_OFF, cells[1:]):
                x.wr(base + off, struct.pack('<h', v))
        deadline = u32(x.machine, 0x5B4DFC)
        inp = dict(set={k: (v if isinstance(v, list) else [v]) for k, v in sets.items()}, phase=dict(st['phase']),
                   cells=dict(st['cells']), ctor_fail=bool(st.get('ctor_fail')),
                   tick=resolve_ticks(st['tick'] or [('abs', 1000)], deadline),
                   surf=pad(st['surf'] or SURF_ANS), overlay=pad(st['overlay'] or OVL_ANS), thread=pad(st['thread'] or THR_ANS))
        x.queues = [inp['tick'], inp['surf'], inp['overlay'], inp['thread']]
        x.ctor_fail = inp['ctor_fail']
        before = {}
        for f in fields:
            raw = x.rd(f.address, f.size * f.count)
            before[f.name] = raw
        fatal = x.dispatch()
        # stray writes
        stray = sorted({a for (addr, size) in x.writes for a in range(addr, addr + size) if a not in allowed})
        if stray:
            raise Mismatch('%s step %d: the original wrote outside the modelled cells: %s' % (sc['id'], si, ['%#x' % a for a in stray[:10]]))
        ptrs = (u32(x.machine, 0x5B4EAD), u32(x.machine, 0x5B4EA5), u32(x.machine, 0x5B4EA9))
        obs = dict(calls=[dict(row=c['row'], phase=c['phase'], ops=list(c['ops']), snaps=list(c['snaps']), fatal=c['fatal'], completed=c['completed'])
                          for c in x.calls],
                   fatal=fatal, state=o.dump(), cells=o.row_cells(len(rows)), consumed=list(x.queue_pos), ptrs=ptrs,
                   pdata=list(x.pdata), step=si)
        recorded.append(dict(inp=inp, obs=obs))
        stats['steps'] += 1
        stats['calls'] += len(obs['calls'])
        stats['ops_original'] += sum(len(c['ops']) for c in obs['calls'])
        stats['fatal_steps'] += int(fatal)
    x.cover_on = False
    return recorded


def check_pointers(where, rows, obs):
    """The original's table pointers against the body address (0x42c221 prelude)."""
    if not obs['calls']:
        return
    row = obs['calls'][-1]['row']
    info = parse_body(rows[row]['body'])
    base = obs['pdata'][row]
    want = (base, base + 0x71 if info['entry_count'] > 0 else 0, base + 0x71 + 6 * info['entry_count'] if info['hotspot_count'] > 0 else 0)
    if obs['ptrs'] != want:
        raise Mismatch('%s: original pointers %s differ from the body-derived %s' % (where, [hex(v) for v in obs['ptrs']], [hex(v) for v in want]))


def run_native(nat, fields, sc, rows, recorded, stats, tag_expected=None):
    """Replays the recorded inputs on the native kernel and compares with the recorded original observations."""
    for r, spec in enumerate(rows):
        status, why = nat.parse(r, spec['body'])
        if status != 0:
            raise Mismatch('%s: native parse of row %d failed: %s (%d)' % (sc['id'], r, why, status))
    nat.lib.a33o_zero_state(nat.h)
    for name, v in sc['init'].items():
        for k, vv in enumerate(v if isinstance(v, list) else [v]):
            nat.poke(name, k, vv)
    phases = [0] * len(rows)
    for r in range(len(rows)):
        nat.set_cells(r, [0, 0, 0, 0, 0])
    for rec in recorded:
        inp, orig = rec['inp'], rec['obs']
        where = '%s step %d' % (sc['id'], orig['step'])
        for name, vals in inp['set'].items():
            for k, vv in enumerate(vals):
                nat.poke(name, k, vv)
        for row, p in inp['phase'].items():
            phases[row] = p
        for row, cells in inp['cells'].items():
            nat.set_cells(row, list(cells))
        for q, vals in enumerate((inp['tick'], inp['surf'], inp['overlay'], inp['thread'])):
            nat.script(q, vals)
        # the expected visits (open-row model): rows in order while mode is 3, until a fatal exit or a completion changed the mode
        mode3 = nat.peek(nat.by_name['mode_583999'])[0] == 3
        native_calls, stop = [], False
        for c in orig['calls']:
            row = c['row']
            cells = nat.cells(row)
            cells[0] = 0                                    # the dispatcher clears the request dword before the gate
            nat.set_cells(row, cells)
            if c['phase'] != phases[row]:
                raise Mismatch('%s: the original entered row %d with phase %d, the model has %d' % (where, row, c['phase'], phases[row]))
            res = nat.step(row, c['phase'])
            phases[row] = res['phase_after']
            native_calls.append(dict(row=row, phase=c['phase'], res=res))
            if res['status'] != 0 and res['status'] != 4:
                raise Mismatch('%s: native status %d (%s) where the original ran to its end' % (where, res['status'], res['why']))
            if res['status'] == 4 or res['finished']:
                break
        compare_step(where, sc, rows, fields, nat, orig, native_calls, phases, mode3, stats)
    return True


def compare_step(where, sc, rows, fields, nat, orig, ncalls, phases, mode3, stats):
    ocalls = orig['calls']
    # which rows ran the handler
    expected = []
    if mode3:
        for r in range(len(rows)):
            expected.append(r)
    seen = [c['row'] for c in ocalls]
    if sc['observed_gate']:
        if seen != [r for r in expected if r in seen]:
            raise Mismatch('%s: handler rows %s are not an ordered subset of %s' % (where, seen, expected))
    else:
        # all rows are open with an empty dependency list, the dispatch stops after a fatal exit or a completion
        cut = []
        for r in expected:
            cut.append(r)
            nc = next((n for n in ncalls if n['row'] == r), None)
            if nc is not None and (nc['res']['status'] == 4 or nc['res']['finished']):
                break
        if seen != cut:
            raise Mismatch('%s: the original ran the handler for rows %s, the model expects %s' % (where, seen, cut))
    stats['visits_group:' + sc['group'] + (':observed_gate' if sc['observed_gate'] else '')] += len(ocalls)
    if len(ncalls) != len(ocalls):
        raise Mismatch('%s: native ran %d visits, the original %d' % (where, len(ncalls), len(ocalls)))
    for oc, nc in zip(ocalls, ncalls):
        res = nc['res']
        if oc['fatal'] != (res['status'] == 4):
            raise Mismatch('%s: row %d fatal exit: original %s native status %d (%s)' % (where, oc['row'], oc['fatal'], res['status'], res['why']))
        if oc['completed'] != bool(res['finished']):
            raise Mismatch('%s: row %d completion: original %s native finished %d' % (where, oc['row'], oc['completed'], res['finished']))
        o_ops = [norm_op(t, 'o') for t in oc['ops']]
        n_ops = [norm_op(t, 'n') for t in res['ops']]
        if o_ops != n_ops:
            first = next((i for i in range(min(len(o_ops), len(n_ops))) if o_ops[i] != n_ops[i]), min(len(o_ops), len(n_ops)))
            raise Mismatch('%s: row %d op log differs at #%d: original %s native %s' % (
                where, oc['row'], first, fmt_ops(oc['ops'][first:first + 3]), fmt_ops(res['ops'][first:first + 3])))
        if oc['snaps'] != res['snaps']:
            first = next(i for i in range(min(len(oc['snaps']), len(res['snaps']))) if oc['snaps'][i] != res['snaps'][i])
            names = [f.name for f in fields if f.name in SNAP]
            diff = [n for n, a, b in zip(names, oc['snaps'][first], res['snaps'][first]) if a != b]
            raise Mismatch('%s: row %d state at op #%d (%s) differs in %s: original %s native %s' % (
                where, oc['row'], first, OPN[oc['ops'][first][0]], diff,
                [oc['snaps'][first][names.index(n)] for n in diff], [res['snaps'][first][names.index(n)] for n in diff]))
        stats['op_snapshots_compared'] += len(oc['snaps'])
        # unspecified native arguments are observed
        for t in res['ops']:
            m = OPMASK[t[0]]
            if (not m[0] and t[1]) or (not m[1] and t[2]) or (not m[2] and t[3] and t[0] not in QUEUE_OF):
                stats['native_unspecified_args_nonzero'] += 1
        stats['ops_compared'] += len(o_ops)
        for t in oc['ops']:
            stats['op:' + OPN[t[0]]] += 1
        stats['visits'] += 1
        stats['phase%d_visits' % min(oc['phase'], 3) if oc['phase'] < 3 else 'phase_other_visits'] += 1
    # scripted answers consumed
    if orig['consumed'] != nat.consumed():
        raise Mismatch('%s: scripted answers consumed: original %s native %s' % (where, orig['consumed'], nat.consumed()))
    for q in range(4):
        if nat.lib.a33o_exhausted(nat.h, q):
            raise Mismatch('%s: native exhausted scripted queue %s' % (where, QNAMES[q]))
    # state
    ostate = orig['state']
    for f in fields:
        nv = nat.peek(f)
        if ostate[f.name] != nv:
            k = next(i for i in range(f.count) if ostate[f.name][i] != nv[i])
            raise Mismatch('%s: A33State.%s[%d] original %s native %s' % (where, f.name, k, hex(ostate[f.name][k] & M32), hex(nv[k] & M32)))
    stats['fields_compared'] += len(fields)
    check_pointers(where, rows, orig)
    # row cells and phases
    for r in range(len(rows)):
        o = orig['cells'][r]
        n = nat.cells(r)
        if o[:5] != n:
            raise Mismatch('%s: row %d cells original %s native %s' % (where, r, o[:5], n))
        if o[5] != phases[r]:
            raise Mismatch('%s: row %d phase original %d native %d' % (where, r, o[5], phases[r]))
        stats['cells_compared'] += 6


def tally_group(stats, sc):
    stats['group:' + sc['group']] += 1


# ---------------------------------------------------------------------------------------------
# native safety / expected differences
# ---------------------------------------------------------------------------------------------
def native_safety(nat, fields, stats):
    """E1..E4. Each case is tagged, counted and never counts as an original comparison."""
    results = Counter()

    def expect(cond, what):
        if not cond:
            raise Mismatch('expected-difference check failed: ' + what)
        results[what.split(':')[0]] += 1

    base = make_body(entries=[(1, 2, 3)], hotspots=[hs(5, (1, 2, 3, 4), (5, 6, 7, 8))])
    # E1: negative counts, names without NUL, short bodies, counts beyond the span
    b = bytearray(base)
    struct.pack_into('<h', b, 0x6d, -1)
    expect(nat.parse(0, bytes(b))[0] == 2, 'E1 negative entry count refused: A33_ERR_BODY')
    b = bytearray(base)
    struct.pack_into('<h', b, 0x6f, -3)
    expect(nat.parse(0, bytes(b))[0] == 2, 'E1 negative hotspot count refused: A33_ERR_BODY')
    b = bytearray(base)
    b[0:33] = b'N' * 33
    expect(nat.parse(0, bytes(b))[0] == 2, 'E1 clip name without NUL refused: A33_ERR_BODY')
    b = bytearray(base)
    b[0x21:0x42] = b'N' * 33
    expect(nat.parse(0, bytes(b))[0] == 2, 'E1 overlay name without NUL refused: A33_ERR_BODY')
    for n in (0, 1, 0x70, len(base) - 1):
        expect(nat.parse(0, base[:n])[0] == 2, 'E1 short body %d refused: A33_ERR_BODY' % n)
    b = bytearray(base)
    struct.pack_into('<h', b, 0x6f, 5000)
    expect(nat.parse(0, bytes(b))[0] == 2, 'E1 count beyond the span refused: A33_ERR_BODY')
    expect(nat.lib.a33o_parse(nat.h, 0, None, 0, None, 0) == 2, 'E1 NULL body refused: A33_ERR_BODY')
    expect(nat.parse(9, base)[0] == 1, 'E4 row index beyond the driver refused: A33_ERR_ARGUMENT')
    expect(nat.parse(0, base)[0] == 0, 'E1 control: the clean body parses')
    # E4: a step without a parsed row
    expect(nat.step(3, 0)['status'] == 1, 'E4 step of an unparsed row: A33_ERR_ARGUMENT')
    # E3: the cells of a row other than the running one
    nat.lib.a33o_zero_state(nat.h)
    nat.parse(0, base)
    nat.poke('mode_5b4ea3', 0, 2)
    nat.poke('row_5b4e89', 0, 1)
    nat.poke('state_5b4e10', 0, 4)
    nat.poke('selector_5bb50b', 0, 5)
    nat.poke('deadline_5b4dfc', 0, 0xFFFFFFFF)
    nat.script(0, [5])
    expect(nat.step(0, 1)['status'] == 5, 'E3 cells of another row: A33_ERR_UNSUPPORTED')
    # E2: a host failure at op k stops the visit; the log up to the failed op is a prefix of the unfailed log
    return results


def host_failure_cases(nat, fields, loader_rows, stats):
    """E2 on a long phase-0 visit: fail the k-th op for every k; the log must be the unfailed log's first k+1 ops."""
    body = make_body(kind=2, w4a=2, anim=2, hotspots=[hs(5, (1, 2, 3, 4), (10, 20, 30, 40))], entries=[(3, 4, 5)])
    nat.parse(0, body)
    results = Counter()

    def prep():
        nat.lib.a33o_zero_state(nat.h)
        for name, v in (('mode_583999', 3), ('selector_5bb50b', 5), ('thread_5b4e0c', THR(4)), ('buf_5b4db8', BUF(1)),
                        ('buf_5b4dbc', BUF(2)), ('surface_5d03bf', SURF(8)), ('surface_5d03c7', SURF(9)), ('present_5b4e04', 2)):
            nat.poke(name, 0, v)
        nat.script(0, [100, 100])
        nat.script(1, SURF_ANS)
        nat.script(2, OVL_ANS)
        nat.script(3, THR_ANS)
        nat.set_cells(0, [0, 0, 0, 0, 0])

    prep()
    nat.lib.a33o_set_fail(nat.h, -1)
    full = nat.step(0, 0)
    if full['status'] != 0:
        raise Mismatch('host failure baseline status %d' % full['status'])
    total = len(full['ops'])
    for k in range(total):
        prep()
        nat.lib.a33o_set_fail(nat.h, k)
        res = nat.step(0, 0)
        if res['status'] != 3 or res['ops'] != full['ops'][:k + 1]:
            raise Mismatch('E2 host failure at op %d: status %d, %d ops (expected 3 and %d)' % (k, res['status'], len(res['ops']), k + 1))
        results['E2 host failure at op k stops with A33_ERR_HOST after the failed op'] += 1
    nat.lib.a33o_set_fail(nat.h, -1)
    return results


# ---------------------------------------------------------------------------------------------
# native mutants: each must make the oracle report a mismatch
# ---------------------------------------------------------------------------------------------
KERNEL = 'action_family_33_runtime.c'
MUTANTS = [
    # (name, old text, new text, nth occurrence)
    ('loop clamp >= instead of >', 'st->frame_5b4e00 > set->w4e', 'st->frame_5b4e00 >= set->w4e', 1),
    ('loop wraps to w50', '        if (st->frame_5b4e00 > set->w4e) {\n            st->frame_5b4e00 = set->w4c;', '        if (st->frame_5b4e00 > set->w4e) {\n            st->frame_5b4e00 = set->w50;', 1),
    ('hold clamp bound w56', 'st->frame_5b4e00 > set->w52', 'st->frame_5b4e00 > set->w56', 1),
    ('hold clamp value w4e', 'st->frame_5b4e00 = set->w52;', 'st->frame_5b4e00 = set->w4e;', 1),
    ('reverse clamp <= instead of <', 'st->frame_5b4e00 < set->w4c', 'st->frame_5b4e00 <= set->w4c', 1),
    ('reverse keeps mode 2', 'st->frame_5b4e00 = set->w4c;\n            st->anim_5b4e14 = 0;', 'st->frame_5b4e00 = set->w4c;\n            st->anim_5b4e14 = 2;', 1),
    ('end clamp bound w52', 'st->frame_5b4e00 > set->w56', 'st->frame_5b4e00 > set->w52', 1),
    ('end clamp value w54', 'st->frame_5b4e00 = set->w56;', 'st->frame_5b4e00 = set->w54;', 1),
    ('forward step is +2', 'case 0:\n        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 + 1);', 'case 0:\n        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 + 2);', 1),
    ('candidate rule inverted', 'st->latch_5c39e5 != (int32_t)st->row_5b4e89', 'st->latch_5c39e5 == (int32_t)st->row_5b4e89', 1),
    ('candidate sets state 3', 'st->anim_5b4e14 = 2;\n    }\n}', 'st->anim_5b4e14 = 3;\n    }\n}', 1),
    ('candidate rule for modes >= 1', 'st->anim_5b4e14 == 1 &&', 'st->anim_5b4e14 >= 1 &&', 1),
    ('page does not toggle back', 'st->page_5b4dc8 = st->page_5b4dc8 != 0 ? 0 : 1;', 'st->page_5b4dc8 = st->page_5b4dc8 == 0 ? 0 : 1;', 1),
    ('page buffers swapped', 'st->page_5b4dc8 != 0 ? st->buf_5b4dbc : st->buf_5b4db8', 'st->page_5b4dc8 != 0 ? st->buf_5b4db8 : st->buf_5b4dbc', 1),
    ('pixels for every presentation', 'if (st->present_5b4e04 == 2) {', 'if (st->present_5b4e04 != 0) {', 1),
    ('page flip without surface check', 'if (st->surface_5d03bf == 0u) {\n        return A33_OK;', 'if (0) {\n        return A33_OK;', 1),
    ('page flip never unlocks', '    OP(host, A33_OP_STREAM_UNLOCK, 0, 0, NULL);\n    return A33_OK;\n}\n\n/* 0x42d215 */', '    return A33_OK;\n}\n\n/* 0x42d215 */', 1),
    ('event index 0 skipped', 'e->index != -1 &&', 'e->index != 0 && e->index != -1 &&', 1),
    ('event key compare inverted', 'e->key == st->frame_5b4e00', 'e->key != st->frame_5b4e00', 1),
    ('event index and value swapped', 'A33_OP_EVENT_FLAG, e->index, e->value, NULL', 'A33_OP_EVENT_FLAG, e->value, e->index, NULL', 1),
    ('event scan stops at first match', 'OP(host, A33_OP_EVENT_FLAG, e->index, e->value, NULL);', 'OP(host, A33_OP_EVENT_FLAG, e->index, e->value, NULL);\n            break;', 1),
    ('clip inside test bottom <', 'bottom <= rect[3] && top >= rect[1]', 'bottom < rect[3] && top >= rect[1]', 1),
    ('clip inside test top >', 'bottom <= rect[3] && top >= rect[1]', 'bottom <= rect[3] && top > rect[1]', 1),
    ('clip reject bottom edge', '(top <= rect[3] && bottom >= rect[3])', '(top < rect[3] && bottom >= rect[3])', 1),
    ('clip reject top edge', '(top <= rect[1] && bottom >= rect[1])', '(top <= rect[1] && bottom > rect[1])', 1),
    ('clip top uses the wrong side', 'const int32_t cut_top = top < rect[1] ? rect[1] : top;', 'const int32_t cut_top = top < rect[1] ? top : rect[1];', 1),
    ('clip bottom uses the wrong side', 'const int32_t cut_bottom = bottom > rect[3] ? rect[3] : bottom;', 'const int32_t cut_bottom = bottom > rect[3] ? bottom : rect[3];', 1),
    ('clip source top offset sign', 'addi32(src[1], sub32(cut_top, top))', 'addi32(src[1], sub32(top, cut_top))', 1),
    ('clip source bottom offset sign', 'sub32(src[3], sub32(bottom, cut_bottom))', 'addi32(src[3], sub32(bottom, cut_bottom))', 1),
    ('clip destination top origin', 'addi32(sub32(top, rect[1]), st->view_y_58318a)', 'addi32(sub32(top, rect[0]), st->view_y_58318a)', 1),
    ('clip destination x view dropped', 'out_dst[0] = addi32(dst[0], st->view_x_583186);', 'out_dst[0] = dst[0];', 1),
    ('latch set for rejected rectangles', 'if (clip_rect(st, hs->src1, hs->dst1, rect, st->src1_5b4e18, st->dst1_5b4e28) != 0) {', 'if (clip_rect(st, hs->src1, hs->dst1, rect, st->src1_5b4e18, st->dst1_5b4e28) != 0 || 1) {', 1),
    ('second rectangle flag cleared', 'st->flag_5b4e8d = 1;', 'st->flag_5b4e8d = 0;', 1),
    ('request cell value 2', 'cells->request = 1;', 'cells->request = 2;', 1),
    ('cell rect word from dst right', 'cells->rect[0] = (int16_t)hs->dst1[0];', 'cells->rect[0] = (int16_t)hs->dst1[2];', 1),
    ('cells keyed on kind', 'if (st->mode_5b4ea3 == 2) {\n        if (st->row_5b4e89 != row)', 'if (st->kind_5b4e8b == 2) {\n        if (st->row_5b4e89 != row)', 1),
    ('second pair keyed on mode', 'if (st->kind_5b4e8b == 2) {\n        second_rects', 'if (st->mode_5b4ea3 == 2) {\n        second_rects', 1),
    ('relative rectangle uses x origin for y', 'st->rel_dst1_5b4e58[1] = sub32(st->dst1_5b4e28[1], st->view_y_58318a);', 'st->rel_dst1_5b4e58[1] = sub32(st->dst1_5b4e28[1], st->view_x_583186);', 1),
    ('first hit becomes last hit', 'for (int32_t i = 0; i < set->hotspot_count; ++i) {\n        if (set->hotspots[i].key == selector) {', 'for (int32_t i = set->hotspot_count - 1; i >= 0; --i) {\n        if (set->hotspots[i].key == selector) {', 1),
    ('state 0 ignores the ready flag', 'if (st->ready_5b4e0a != 0) {\n            const int hit', 'if (st->ready_5b4e0a == 0) {\n            const int hit', 1),
    ('state 4 entered only on a hit', 'st->state_5b4e10 = 4;', 'if (hit >= 0) st->state_5b4e10 = 4;', 1),
    ('state 4 test is >= 4', 'st->state_5b4e10 == 4', 'st->state_5b4e10 >= 4', 1),
    ('state 0 test is <= 0', 'if (st->state_5b4e10 == 0) {', 'if (st->state_5b4e10 <= 0) {', 1),
    ('signed tick compare', '(uint32_t)tick < st->deadline_5b4dfc', '(int32_t)tick < (int32_t)st->deadline_5b4dfc', 1),
    ('tick compare <= deadline', '(uint32_t)tick < st->deadline_5b4dfc', '(uint32_t)tick <= st->deadline_5b4dfc', 1),
    ('state 0 deadline without delay', 'st->deadline_5b4dfc = add32((uint32_t)tick, (uint32_t)st->delay_5b4c5a);', 'st->deadline_5b4dfc = (uint32_t)tick;', 1),
    ('state 4 deadline without delay', 'st->deadline_5b4dfc = add32((uint32_t)tick, (uint32_t)st->delay_5b4c5a);', 'st->deadline_5b4dfc = (uint32_t)tick;', 2),
    ('state 0 keeps the ready flag', 'st->ready_5b4e0a = 0;\n                OP(host, A33_OP_TICK', 'OP(host, A33_OP_TICK', 1),
    ('state 4 keeps the ready flag', 'st->ready_5b4e0a = 0;\n            }\n            return hotspot_rects', '}\n            return hotspot_rects', 1),
    ('state 0 event before flip', '                status = event_flags(st, set, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = page_flip(st, host);', '                status = page_flip(st, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = event_flags(st, set, host);', 1),
    ('state 4 flip before event', '                status = page_flip(st, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = event_flags(st, set, host);', '                status = event_flags(st, set, host);\n                if (status != A33_OK) {\n                    return status;\n                }\n                status = page_flip(st, host);', 1),
    ('start flag not set', 'st->start_5bb1ca = 1;', '', 1),
    ('phase 2 pushes for any nonzero flag', 'set->push_6c == 1u', 'set->push_6c != 0u', 1),
    ('phase 2 runs without a ready frame', 'A33StepResult *result)\n{\n    if (st->ready_5b4e0a == 0) {', 'A33StepResult *result)\n{\n    if (st->ready_5b4e0a != 0) {', 1),
    ('phase 2 leaves mode 3', 'st->mode_583999 = 4;', 'st->mode_583999 = 3;', 1),
    ('phase 2 keeps the singleton', 'st->active_5c39f1 = 0;', '', 1),
    ('phase 2 row word 0', 'st->row_5b4e89 = (int16_t)-1;', 'st->row_5b4e89 = 0;', 1),
    ('phase 2 scene unsigned', 'st->scene_5bb57b = (int32_t)set->scene_58;', 'st->scene_5bb57b = (int32_t)(uint16_t)set->scene_58;', 1),
    ('teardown stop and delete swapped', 'OP(host, A33_OP_THREAD_STOP, (int32_t)st->thread_5b4e0c, 0, NULL);\n        OP(host, A33_OP_THREAD_DELETE, (int32_t)st->thread_5b4e0c, 0, NULL);', 'OP(host, A33_OP_THREAD_DELETE, (int32_t)st->thread_5b4e0c, 0, NULL);\n        OP(host, A33_OP_THREAD_STOP, (int32_t)st->thread_5b4e0c, 0, NULL);', 1),
    ('teardown buffer 1 free flag bit 1', '(st->flags_5b4dc0 & 8u) == 0u', '(st->flags_5b4dc0 & 1u) == 0u', 1),
    ('teardown buffer 2 reads flags 1', '(st->flags_5b4dc2 & 8u) == 0u', '(st->flags_5b4dc0 & 8u) == 0u', 1),
    ('overlay release index 0', 'OP(host, A33_OP_SURFACE_RELEASE, (int32_t)st->surface_5d03c7, 1, NULL);', 'OP(host, A33_OP_SURFACE_RELEASE, (int32_t)st->surface_5d03c7, 0, NULL);', 1),
    ('surface released even when zero', 'if (st->surface_5d03bf != 0u) {\n        OP(host, A33_OP_SURFACE_RELEASE', 'if (1) {\n        OP(host, A33_OP_SURFACE_RELEASE', 1),
    ('z unregister missing', 'OP(host, A33_OP_Z_UNREGISTER, 0, 0, NULL);', '', 1),
    ('stream state not 2', 'st->stream_5b4c3a = 2;', 'st->stream_5b4c3a = 1;', 1),
    ('surface width without +1', 'addi32(sub32(st->vrect_5b4df0, st->vrect_5b4de8), 1)', 'sub32(st->vrect_5b4df0, st->vrect_5b4de8)', 1),
    ('animation 2 frame from w4c', 'st->frame_5b4e00 = set->w54;', 'st->frame_5b4e00 = set->w4c;', 1),
    ('animation 2 mode 2', 'st->anim_5b4e14 = 3;', 'st->anim_5b4e14 = 2;', 1),
    ('second video not fatal', 'if (st->active_5c39f1 != 0) {', 'if (st->active_5c39f1 > 1) {', 1),
    ('overlay loaded for every kind', 'if (st->kind_5b4e8b == 2) {\n        copy_name(st->overlay_5b4e68', 'if (st->kind_5b4e8b >= 1) {\n        copy_name(st->overlay_5b4e68', 1),
    ('phase 0 does not fall into play', 'status = phase_play(state, set, row, row_cells, host);\n    } else if (phase == 1u)', 'status = A33_OK;\n    } else if (phase == 1u)', 1),
    ('play keeps the latch', '    st->latch_5d1967 = 0;\n    st->flag_5b4e8d = 0;\n    rect[0]', '    st->flag_5b4e8d = 0;\n    rect[0]', 1),
    ('play clip rectangle bottom from top', 'rect[3] = st->clip_5bb583[3];', 'rect[3] = st->clip_5bb583[1];', 1),
    ('hotspot count 0 not fatal', 'if (set->hotspot_count < 1) {', 'if (set->hotspot_count < 0) {', 1),
    ('missing-hotspot log id', 'A33_LOG_MISSING_HOTSPOTS, 0, NULL', 'A33_LOG_SECOND_VIDEO, 0, NULL', 1),
    ('entries flag for empty tables', 'state->has_entries_5b4ea5 = set->entry_count > 0 ? 1 : 0;', 'state->has_entries_5b4ea5 = set->entry_count >= 0 ? 1 : 0;', 1),
    ('thread create failure not fatal', 'if (st->thread_5b4e0c == 0u) {\n            OP(host, A33_OP_LOG, A33_LOG_THREAD_MEMORY, 0, NULL);\n            return A33_ERR_FATAL;', 'if (0) {\n            OP(host, A33_OP_LOG, A33_LOG_THREAD_MEMORY, 0, NULL);\n            return A33_ERR_FATAL;', 1),
    ('thread arg is the scene word', 'A33_OP_THREAD_CREATE, (int32_t)st->thread_arg_5b016f', 'A33_OP_THREAD_CREATE, (int32_t)st->scene_5bb57b', 1),
    ('phase 0 leaves the ready flag', '    st->ready_5b4e0a = 0;\n    OP(host, A33_OP_THREAD_RESUME', '    OP(host, A33_OP_THREAD_RESUME', 1),
    ('thread never resumed', 'OP(host, A33_OP_THREAD_RESUME, (int32_t)st->thread_5b4e0c, 0, NULL);', '', 1),
    ('phase 0 leaves phase 2', 'result->phase_after = 1u;', 'result->phase_after = 2u;', 1),
    ('stream reset after overlay', 'OP(host, A33_OP_STREAM_RESET, 0, 0, NULL);\n    if (st->kind_5b4e8b == 2) {', 'if (st->kind_5b4e8b == 2) {', 1),
    ('video word copied to the wrong cell', 'st->w_5b4e02 = set->w42;', 'st->w_5b4e02 = set->w44;', 1),
    ('presentation word copied to the wrong cell', 'st->present_5b4e04 = set->w44;', 'st->present_5b4e04 = set->w42;', 1),
    ('mode word from the kind', 'st->mode_5b4ea3 = set->w4a;', 'st->mode_5b4ea3 = set->kind_46;', 1),
    ('thread start log without scene', 'A33_LOG_THREAD_START, st->scene_5bb57b', 'A33_LOG_THREAD_START, 0', 1),
]


def apply_mutant(text, old, new, nth):
    pos = -1
    for _ in range(nth):
        pos = text.find(old, pos + 1)
        if pos < 0:
            return None
    return text[:pos] + new + text[pos + len(old):]


def replay_all(nat, fields, cache, stats):
    for sid, (sc, rows, recorded) in cache.items():
        run_native(nat, fields, sc, rows, recorded, stats)


def run_mutants(src_dir, fields, cache, tmp, limit=None):
    base = (Path(src_dir) / KERNEL).read_text()
    caught, survived, invalid, unapplied = [], [], [], []
    quick_ids = [sid for sid, (sc, _r, _rec) in cache.items() if sc['quick']]
    for n, (name, old, new, nth) in enumerate(MUTANTS):
        if limit is not None and n >= limit:
            break
        text = apply_mutant(base, old, new, nth)
        if text is None:
            unapplied.append(name)
            continue
        kernel = Path(tmp) / ('mut%d.c' % n)
        kernel.write_text(text)
        lib = Path(tmp) / ('mut%d.so' % n)
        try:
            build_driver(src_dir, lib, kernel=kernel)
        except d9.OracleError as error:
            invalid.append((name, str(error)[-300:]))
            continue
        nat = Native(lib)
        hit = None
        try:
            # quick scenarios first (most mutants die there), then everything else
            order = quick_ids + [s for s in cache if s not in set(quick_ids)]
            for sid in order:
                sc, rows, recorded = cache[sid]
                try:
                    run_native(nat, fields, sc, rows, recorded, Counter())
                except Mismatch as error:
                    hit = (sid, str(error)[:200])
                    break
        finally:
            nat.close()
        if hit:
            caught.append((name, hit[0]))
        else:
            survived.append(name)
    return caught, survived, invalid, unapplied


# ---------------------------------------------------------------------------------------------
# coverage of the original code
# ---------------------------------------------------------------------------------------------
def coverage_report(x):
    import capstone
    pristine = x.pristine
    base = x.pe.image_base
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    total, hit, missing = 0, 0, []
    for lo, hi in ORIGINAL_FUNCS:
        for ins in md.disasm(pristine[lo - base:hi - base], lo):
            total += 1
            if ins.address in x.coverage:
                hit += 1
            else:
                missing.append(ins.address)
    return total, hit, missing


# ---------------------------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path, default=RESULT_DEFAULT)
    ap.add_argument('--mutations', action='store_true')
    ap.add_argument('--quick', action='store_true', help='only the quick scenario subset')
    ap.add_argument('--seed', type=int, default=0x33)
    ap.add_argument('--only', default='', help='run scenarios whose id contains this text')
    ap.add_argument('--print-pins', action='store_true')
    ap.add_argument('--limit-mutants', type=int)
    ap.add_argument('--show-missing', action='store_true')
    args = ap.parse_args()
    t0 = time.monotonic()
    src_dir = PROJECT / 'src'
    tmp = Path(tempfile.mkdtemp(prefix='a33oracle-'))
    lib = build_driver(src_dir, tmp / 'driver.so')
    nat = Native(lib)
    fields = nat.fields
    x = Oracle()
    if args.print_pins:
        for a, z, actual, pinned in x.pins:
            print('(0x%x, 0x%x, %r),' % (a, z, actual))
        return 0
    loader = Loader()
    scs = build_scenarios(args.seed, corpus_rows(loader))
    if args.quick:
        scs = [s for s in scs if s['quick']]
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    stats = Stats()
    cache, bad, expected_diffs = {}, [], Counter()
    for sc in scs:
        try:
            recorded = run_original(x, fields, loader, sc, stats)
            rows = [dict(r, body=loader.typed(r['body'], r['subtype'], r['tail'])[0]) for r in sc['rows']]
            cache[sc['id']] = (sc, rows, recorded)
            run_native(nat, fields, sc, rows, recorded, stats)
            stats['scenarios'] += 1
            stats['group:' + sc['group']] += 1
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
    for sid, msg in bad[:12]:
        print('MISMATCH', sid, msg[:400])
    # expected differences
    nat2 = Native(lib)
    try:
        expected_diffs.update(native_safety(nat2, fields, stats))
        expected_diffs.update(host_failure_cases(nat2, fields, None, stats))
    finally:
        nat2.close()
    total, hit, missing = coverage_report(x)
    nat.close()
    summary = dict(scenarios=stats['scenarios'], steps=stats['steps'], visits=stats['visits'], ops_compared=stats['ops_compared'],
                   fields_compared=stats['fields_compared'], cells_compared=stats['cells_compared'], fatal_steps=stats['fatal_steps'],
                   loader_objects=stats['loader_objects'], mismatches=stats['mismatches'],
                   original_instructions=total, original_instructions_executed=hit,
                   expected_differences=sum(expected_diffs.values()))
    ops = {k[3:]: v for k, v in stats.items() if k.startswith('op:')}
    groups = {k[6:]: v for k, v in stats.items() if k.startswith('group:')}
    visits_by_group = {k[13:]: v for k, v in stats.items() if k.startswith('visits_group:')}
    print('SUMMARY', json.dumps(summary))
    print('OPS', json.dumps(ops))
    print('GROUPS', json.dumps(groups))
    print('VISITS', json.dumps(visits_by_group))
    print('COVERAGE %d/%d instructions of the six original functions' % (hit, total))
    if args.show_missing:
        print('MISSING', ' '.join('%x' % a for a in missing))
    result = dict(slice='RT-46', scope='raw 0x33 handler 0x42c221 + callees, real dispatcher/loader', summary=summary, ops=ops, groups=groups, visits_by_group=visits_by_group,
                  expected_differences=dict(expected_diffs), uncovered_original_instructions=['%x' % a for a in missing],
                  oracle_script_sha256=sha(Path(__file__).read_bytes()),
                  driver_sha256=sha((PROJECT / 'tests/action_family_33_runtime_oracle_driver.c').read_bytes()),
                  kernel_sha256=sha((src_dir / KERNEL).read_bytes()), exe_sha256=d9.EXE_HASH,
                  pins=[dict(start=hex(a), end=hex(z), sha256=d, enforced=p) for a, z, d, p in x.pins if a >= 0x42C221 or a == 0x427A50],
                  mismatch_ids=[b[0] for b in bad], native_unspecified_args_nonzero=stats['native_unspecified_args_nonzero'])
    result['unverified'] = [
        'the debug flag 0x63a4cd set (0x42e744..0x42e74e log paths are unreached; the flag is modelled as 0)',
        'the instructions after the two fatal calls (0x42c306, 0x42c386) and the null-thread arm 0x42c442 are unreachable',
        'the bodies of every hooked callee (0x44c479 0x44c4ab 0x449a94 0x4c2dfb 0x44c4c1 0x44c2e0 0x4c2c3a 0x4497a0 0x449bff 0x42e560 '
        '0x42ba3a 0x415011 0x51dc6c) and the reader thread proc 0x44cde2: host behaviour, not run',
        'the real dependency records of the corpus rows (gate shared and verified elsewhere; the handler ran in %d observed-gate visits)'
        % visits_by_group.get('corpus:observed_gate', 0),
        'Unicorn timing: a real second thread (the reader) is not modelled; ready word / delay / buffers are scripted inputs',
        'ASan/UBSan of the kernel through this driver: UBSan (trap mode) ran clean once; ASan runtime unavailable here',
    ]
    if args.mutations and not bad:
        caught, survived, invalid, unapplied = run_mutants(src_dir, fields, cache, tmp, args.limit_mutants)
        print('MUTANTS caught %d survived %d invalid %d unapplied %d' % (len(caught), len(survived), len(invalid), len(unapplied)))
        for s in survived:
            print('  SURVIVED', s)
        for s in unapplied:
            print('  UNAPPLIED', s)
        for s in invalid:
            print('  INVALID', s[0], s[1][:200])
        result['mutants'] = dict(total=len(MUTANTS), caught=len(caught), survived=survived, invalid=[i[0] for i in invalid], unapplied=unapplied,
                                 caught_by=dict(caught))
    result['elapsed_seconds'] = round(time.monotonic() - t0, 1)
    args.result.parent.mkdir(parents=True, exist_ok=True)
    args.result.write_text(json.dumps(result, indent=2) + '\n')
    print('result', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
