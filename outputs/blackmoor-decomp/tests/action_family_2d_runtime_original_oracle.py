#!/usr/bin/env python3
"""RT-36: immutable x86 raw-0x2d handler 0x4cd6ff and its object code versus the native kernel src/action_family_2d_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. Scenes are built by the REAL loader: the typed body of each raw-0x2d row is
fed to the original loader 0x4cd243 (arm 0x40c0e0 contract: slot = row+0x32, cursor cell, offset cell, ECX = 0x63821d), which
allocates the header / entry / group tables and the per-entry record blocks exactly as the game does; the dependency tree comes from
the real loader 0x424aa8. Ticks run the REAL dispatcher 0x427a50 (arm 0x427f27, gate 0x423f57, handler 0x4cd6ff with ECX = 0x63821d).
The object entry points are also driven directly with ECX = 0x63821d: handler 0x4cd6ff (phase 0 / 1 / 2 and other phase values),
stop 0x4ceb3b, scene clear 0x4cd218, render entry 0x4cecf7, render callback 0x4cf749 (blit 0x4c5377 recorded).

ORIGINAL x86 (no hook inside): 0x4cd6ff 0x4ccef1 0x4ccfbd 0x4ccff5 0x4ccdab 0x4ccd70 0x4cdfd3 0x4ce602 0x4ce8ea 0x4ceb8c 0x4cec6c
0x4cf026 0x4cf0a9 0x4cf0ce 0x4d36ed 0x4ceb3b 0x4cd218 0x4cd243 0x4cecf7 0x4cf749 0x516530 (strcmp) and the inline rep movs frame
copies of 0x4ce602 (observed, not replaced), 0x427a50, 0x423f57, 0x424aa8, 0x51dc43 (allocator, bump arena in the oracle heap).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY; R = replaced: the hook logs the call, applies the scripted answer, pops
the original's `ret N`; O = observed only; G = raising guard). Every R hook is one D2_OP_* of the native host, same order, same
arguments, same scripted answers (the queues below are shared by both sides):
  R 0x50cd50 rand                       -> D2_OP_RAND          (queue 'rand')
  R call [0x52a23c] GetTickCount        -> D2_OP_TICK          (queue 'tick', values near / across the 2^32 wrap)
  R 0x50cd72 sprintf + 0x449d90 file test -> one D2_OP_FILE_EXISTS(name, variant): variant from the call site and the ext/dir
        string pointers: 0x55981c/0x639eb5 = 0 (.BIK dir 1), 0x559824/0x639fb9 = 1 (.BIK dir 2), 0x55982c/0x639eb5 = 2 (.AVF dir 1),
        0x559834/0x639fb9 = 3 (.AVF dir 2); the answer is scripted per (name, variant)
  R 0x44c479 -> STREAM_POLL (cdecl obj+4)       R 0x449a94 -> THREAD_STOP (ECX = handle)
  R vcall [edx] at 0x4ccf4f -> THREAD_DELETE (the thread objects live in oracle memory; the vtable slot points at a `ret 4` stub that is hooked)
  R 0x44c4ab -> STREAM_RELEASE (cdecl obj+4)    R 0x415011 -> Z_UNREGISTER_A (ret 4)   R 0x41632b -> Z_UNREGISTER_B (ret 4)
  R 0x4bedfa -> BINK_RELEASE (ret 4, a = value of +0x18e; the stand-in does NOT zero +0x18e: the kernel treats the field as host owned)
  R 0x4c2dfb -> SURFACE_RELEASE (ret 4, a = old handle; zeroes *param as the real routine's last store does)
  R 0x44c4c1 -> STREAM_RESET (cdecl obj+8)      R 0x4c2a8d -> SURFACE_CREATE (ret 0x10; label 0x5598bc = 0 AVF, 0x559920 = 1 Bink;
        the stand-in builds the surface struct: +0 pixels, +0x23 size, +0x2b width, +0x2d height, +0x2f pitch)
  R 0x4161d1 -> Z_REGISTER (ret 4)              R 0x4497a0 (+ the 0x51dc43 malloc 0x46 before it) -> THREAD_CREATE (ret 0x10, 0 = failure)
  R 0x449bff -> THREAD_RESUME (ECX = handle)    R 0x4bef11 -> BINK_OPEN (ret 8)   R 0x4bf19a -> BINK_PREPARE (ret 8)
  R 0x4bef85 -> BINK_READY (ret 4)   R 0x4befc8 -> BINK_NEXT (ret 4)   R 0x4bf098 -> BINK_BLIT (ret 0x18)
  R 0x4bee2c -> BINK_FRAME (ret 4)   R 0x4bf10f -> BINK_MORE (ret 4)
  O 0x4ce68b 0x4ce6c6 0x4ce824 0x4ce85f (the rep movsd of the frame copies; ESI/EDI/ECX are checked against the scripted buffers
        and the surface, the copy itself runs as original code) -> D2_OP_FRAME_COPY(-1 single buffer / ring index)
  R 0x51dc6c free (recorded, counted against the tables the erase must free)   R 0x423b51 dependency reset (recorded)
  R 0x4c5377 blit (ret 0x14; render callback test only)
  R 0x50ca3e 0x42639d (ret 8) 0x4264e8 (ret 4) 0x4bf3b8 (ret 4): logging on failure paths, return addresses recorded, not compared
  G 0x4c97b4 reaching the fatal exit (must equal native D2_ERR_FATAL at the same step)   G 0x44a2b7 0x52139c raise
  O 0x4cd6ff handler entry, 0x427f27 arm entry. Windows imports are stubbed as in the 0xd9 oracle (any other import fails the run).
  Debug flag 0x63a4cd is 0. Scripted memory the kernel reads: the surface struct fields, the stream sub-object fields +0x24 +0x172
  +0x182.. +0x18e +0x192 +0x1b2.. +0x1d4 (poked identically on both sides: the AVF decode thread 0x4cf687 is host behaviour).

Compared per scenario step: the ordered op log (op, args, returns), every D2Object field against the bytes at its offset (plus the
name at +0x159 in full), the process globals (0x5bb1ca 0x5839a9 0x5d16cd 0x5d1683 0x5d1639 0x5d1a39 0x5d1a45 0x5831c8 word
0x5831c6, Z slot 16 0x5d1a31.. after 0x4cecf7, and the inputs unchanged), the row table (completion byte, phase, erase stores),
the free list of an erase, a stray-write check (every changed byte of the data segment and the object must be accounted for),
that a fatal exit happened exactly when the native result is D2_ERR_FATAL, and the render plan against the recorded blit.
Tick steps with more than one handler call compare the ops per call and the state after the last.

EXPECTED DIFFERENCES (tagged, counted separately, never passes):
  E1 a zero divisor (random pick over a zero weight total): the original faults at the idiv in 0x4cf0a9, native returns
     D2_ERR_BODY; state and ordered ops up to the fault must still match.
  E2 d2_destruct has no world argument: the original reset 0x4ccdab also stores 0x5d1a45 := 0; the oracle applies that store to
     the native world after a direct destruct (the binding must do it) and counts it. (d2_stop does clear it itself.)
  Native-only safety checks (counts, NUL spans, record index) are never reached by the generated bodies.

Run (from outputs/blackmoor-decomp/tests):
  python3 -I action_family_2d_runtime_original_oracle.py --mutations --result <receipt.json>
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

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
from concurrent.futures import ThreadPoolExecutor

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT, PROJECT, PRIVATE = d9.ROOT, d9.PROJECT, d9.PRIVATE
sha, u32 = d9.sha, d9.u32
M32 = 0xFFFFFFFF

OBJ = 0x63821D
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
EVENTS_VA = d9.EVENTS_VA
HANDLER, ARM, STOP, DESTRUCT, REGISTER, RENDER, LOADER, CTOR = 0x4CD6FF, 0x427F27, 0x4CEB3B, 0x4CD218, 0x4CECF7, 0x4CF749, 0x4CD243, 0x4CCD70
IDIV_ADDR = 0x4CF0C3
FATAL = 0x4C97B4
MAX_ROWS = 12
DATA_LO, DATA_HI = 0x530000, 0x63B000
CODE_LO, CODE_HI = 0x4CCD70, 0x4CF7AC

# scripted memory
SCRIPT = 0x24000000
VTBL, DTOR = SCRIPT + 0x80, SCRIPT + 0x100
CELLS = SCRIPT + 0x300
THR_BASE, SURF_BASE, PIX_BASE, FB_BASE, BODY_AT = SCRIPT + 0x1000, SCRIPT + 0x10000, SCRIPT + 0x20000, SCRIPT + 0xA0000, SCRIPT + 0xC0000
N_THR, N_SURF = 32, 24


def THR(k):
    return THR_BASE + 0x20 * k


def SURF(k):
    return SURF_BASE + 0x100 * k


def FB(i):
    return FB_BASE + 0x1000 * i


OPS = dict(RAND=1, TICK=2, FILE=3, POLL=4, TSTOP=5, TDEL=6, SREL=7, ZUA=8, ZUB=9, BREL=10, SURFREL=11, SRESET=12, SCREATE=13, ZREG=14,
           TCREATE=15, TRESUME=16, BOPEN=17, BPREP=18, BREADY=19, BNEXT=20, BBLIT=21, BFRAME=22, BMORE=23, FCOPY=24)
OPN = {v: k for k, v in OPS.items()}
QUEUES = ('rand', 'tick', 'surface', 'thread', 'bopen', 'bprep', 'bready', 'bframe', 'bmore')

SPRINTF_SITES = {0x4CE064: (0, 0x55981C, 0x639EB5, 0x639DAE), 0x4CE0AB: (1, 0x559824, 0x639FB9, 0x639DAB),
                 0x4CE103: (2, 0x55982C, 0x639EB5, 0x639DAE), 0x4CE14A: (3, 0x559834, 0x639FB9, 0x639DAB)}
LOG_POPS = {0x50CA3E: 0, 0x42639D: 8, 0x4264E8: 4, 0x4BF3B8: 4}
FRAME_COPIES = {0x4CE68B: True, 0x4CE6C6: False, 0x4CE824: True, 0x4CE85F: False}  # True = single buffer (+0x17a == 0)

# D2Object fields: name -> (offset, size, signed)
OBJ_SPEC = {
    'active': (0x216, 4, 1), 'mode': (0x23A, 4, 1), 'row': (0x242, 4, 1), 'state_1de': (0x1DE, 4, 1), 'flag_206': (0x206, 4, 1),
    'pending_25a': (0x25A, 4, 1), 'stream_state_4': (0x4, 4, 1), 'period_24': (0x24, 4, 0), 'decoder_172': (0x172, 4, 1),
    'buffers_182_0': (0x182, 4, 0), 'buffers_182_1': (0x186, 4, 0), 'buffers_182_2': (0x18A, 4, 0), 'ring_17a': (0x17A, 4, 1),
    'kind_17e': (0x17E, 4, 1), 'bink_id_18e': (0x18E, 4, 1), 'buffer_192': (0x192, 2, 1), 'rect_1b2': (0x1B2, 4, 1),
    'rect_1b6': (0x1B6, 4, 1), 'rect_1ba': (0x1BA, 4, 1), 'rect_1be': (0x1BE, 4, 1), 'deadline_1c6': (0x1C6, 4, 0),
    'frame_1ca': (0x1CA, 2, 1), 'word_1cc': (0x1CC, 2, 1), 'word_1ce': (0x1CE, 2, 1), 'ready_1d4': (0x1D4, 2, 1),
    'thread_1d6': (0x1D6, 4, 0), 'state_1da': (0x1DA, 4, 1), 'saved_202': (0x202, 4, 1), 'flag_20a': (0x20A, 4, 1),
    'flag_20e': (0x20E, 4, 1), 'surface_212': (0x212, 4, 0), 'kind_21a': (0x21A, 4, 1), 'scan_22e': (0x22E, 4, 1),
    'frame_232': (0x232, 4, 1), 'group_hit_236': (0x236, 4, 1), 'action_23e': (0x23E, 4, 1), 'clip_246': (0x246, 4, 1),
    'group_24a': (0x24A, 4, 1), 'deadline_24e': (0x24E, 4, 0), 'delay_252': (0x252, 4, 1), 'record_256': (0x256, 4, 1),
}
for _k in range(8):
    OBJ_SPEC['rects_%d' % _k] = (0x1E2 + 4 * _k, 4, 1)
WORLD_SPEC = {
    'start_flag': (0x5BB1CA, 4, 1), 'g_5839a9': (0x5839A9, 4, 1), 'g_5d16cd': (0x5D16CD, 4, 1), 'g_5d1683': (0x5D1683, 4, 1),
    'g_5d1639': (0x5D1639, 4, 1), 'g_5831c8': (0x5831C8, 4, 1), 'g_5831c6': (0x5831C6, 2, 1), 'entry_surface': (0x5D1A39, 4, 0),
    'entry_flag': (0x5D1A45, 4, 1), 'entry_type': (0x5D1A31, 4, 1), 'entry_flag_49': (0x5D1A49, 4, 1), 'entry_word_4d': (0x5D1A4D, 2, 1),
    'scene_key': (0x5BB50B, 2, 1), 'view_x': (0x583186, 4, 1), 'view_y': (0x58318A, 4, 1), 'thread_arg': (0x5B016F, 2, 1),
    'back_buffer': (0x5CF665, 4, 0),
}
WORLD_INPUTS = ('scene_key', 'view_x', 'view_y', 'thread_arg', 'back_buffer')
# object bytes the original may legitimately change: the D2Object fields, the table pointers and the reset's memset span
OBJ_OK = set(range(0x8, 0x1D6)) | {0x4 + k for k in range(4)}
for _n, (_o, _s, _g) in OBJ_SPEC.items():
    OBJ_OK |= set(range(_o, _o + _s))
OBJ_OK |= set(range(0x222, 0x22E)) | set(range(0x159, 0x159 + 33)) | set(range(0x1CA, 0x1D6))
# data bytes outside the object that the original may change
DATA_OK = set()
for _n, (_va, _s, _g) in WORLD_SPEC.items():
    if _n not in WORLD_INPUTS:
        DATA_OK |= set(range(_va, _va + _s))
DATA_OK |= set(range(0x5D1A31, 0x5D1A31 + 0x4A))   # Z slot 16
DATA_OK |= set(range(0x5C3A47, 0x5C3A4B))          # dispatcher pass bookkeeping the oracle clears
DATA_OK |= set(range(ROWS, ROWS + MAX_ROWS * ROW))  # the row table is checked separately


class Mismatch(Exception):
    pass


class ScriptError(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= M32
    return v - (1 << 32) if v & 0x80000000 else v


def cstr(b):
    return bytes(b).split(b'\0')[0]


# ---------------------------------------------------------------------------------------------
# original machine
# ---------------------------------------------------------------------------------------------
class Oracle(d9.X86):
    def __init__(self):
        super().__init__()
        self.machine.mem_map(SCRIPT, 0x200000)
        self.script = {}
        self.qpos = {}
        self.files = {}
        self.oplog, self.calls, self.entered, self.frees, self.resets, self.logs, self.blits = [], [], [], [], [], [], []
        self.last_malloc = None
        self.fatal = self.fault = False
        self.expect_div0 = True
        self.surf_dims = {}
        self.pending_file = None
        for ext, want in ((0x55981C, b'BIK'), (0x559824, b'BIK'), (0x55982C, b'AVF'), (0x559834, b'AVF')):
            if cstr(self.rd(ext, 16)).upper()[-3:] != want:
                raise d9.OracleError('extension string table is not what the probe order assumes')
        if cstr(self.rd(0x55939C, 16)) != b'RandomMovie':
            raise d9.OracleError('random-set name constant differs')
        self.pins = []
        for a, z, digest in PINS:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    # -- hook plumbing -----------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        t = {
            0x50CD50: self.h_rand, 0x50CD72: self.h_sprintf, 0x449D90: self.h_ftest, 0x44C479: self.h_poll, 0x449A94: self.h_tstop,
            DTOR: self.h_tdel, 0x44C4AB: self.h_srel, 0x415011: self.h_zua, 0x41632B: self.h_zub, 0x4BEDFA: self.h_brel,
            0x4C2DFB: self.h_surfrel, 0x44C4C1: self.h_sreset, 0x4C2A8D: self.h_screate, 0x4161D1: self.h_zreg,
            0x4497A0: self.h_tcreate, 0x449BFF: self.h_tresume, 0x4BEF11: self.h_bopen, 0x4BF19A: self.h_bprep,
            0x4BEF85: self.h_bready, 0x4BEFC8: self.h_bnext, 0x4BF098: self.h_bblit, 0x4BEE2C: self.h_bframe, 0x4BF10F: self.h_bmore,
            0x51DC6C: self.h_free, 0x423B51: self.h_depreset, 0x4C5377: self.h_restore, FATAL: self.h_fatal,
            HANDLER: self.h_handler, ARM: self.h_arm, 0x44A2B7: self.h_raise, 0x52139C: self.h_raise,
        }
        for a in LOG_POPS:
            t[a] = self.h_log
        for a in FRAME_COPIES:
            t[a] = self.h_fcopy
        for a, fn in t.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _on_import(self, uc, address, size, user):
        if self.imports[address][0] == 'GetTickCount':
            v = self.pop('tick')
            self.op('TICK', ret=v)
            self._ret(uc, 0, v)
            return
        super()._on_import(uc, address, size, user)

    def _malloc(self, uc):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        size = u32(uc, sp + 4)
        super()._malloc(uc)
        p = uc.reg_read(X.UC_X86_REG_EAX)
        self.last_malloc = (p, size)

    # -- scripted answers and the op log --------------------------------------------------------
    def pop(self, name):
        q = self.script.get(name)
        i = self.qpos.get(name, 0)
        if q is None or i >= len(q):
            raise ScriptError('queue %s exhausted' % name)
        self.qpos[name] = i + 1
        return q[i] & M32

    def op(self, name, a=0, b=0, c=0, d=0, nm='', ret=0):
        self.oplog.append((OPS[name], a & M32, b & M32, c & M32, d & M32, nm, ret & M32))

    def args(self, uc, n):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        return [u32(uc, sp + 4 + 4 * i) for i in range(n)]

    def need_ecx(self, uc, want, what):
        if uc.reg_read(X.UC_X86_REG_ECX) != want:
            raise d9.OracleError('%s entered with ECX %#x, expected %#x' % (what, uc.reg_read(X.UC_X86_REG_ECX), want))

    def caller(self, uc):
        return u32(uc, uc.reg_read(X.UC_X86_REG_ESP))

    def h_rand(self, uc, address, size, user):
        v = self.pop('rand')
        self.op('RAND', ret=v)
        self._ret(uc, 0, v)

    def h_sprintf(self, uc, address, size, user):
        a = self.args(uc, 5)
        site = self.caller(uc)
        if site not in SPRINTF_SITES:
            raise d9.OracleError('sprintf called from %#x' % site)
        variant, ext, dir_, fmt = SPRINTF_SITES[site]
        if (a[4], a[2], a[1]) != (ext, dir_, fmt):
            raise d9.OracleError('sprintf arguments differ from the variant table at %#x' % site)
        self.pending_file = (cstr(self.rd(a[3], 40)).decode('latin1'), variant, a[0])
        self.wr(a[0], b'FILE\0')
        self._ret(uc, 0, 5)

    def h_ftest(self, uc, address, size, user):
        a = self.args(uc, 1)
        if self.pending_file is None or self.pending_file[2] != a[0]:
            raise d9.OracleError('file test without a probe path')
        name, variant, _ = self.pending_file
        self.pending_file = None
        if (name, variant) not in self.files:
            raise ScriptError('no file table entry for (%s, %d)' % (name, variant))
        v = 1 if self.files[(name, variant)] else 0
        self.op('FILE', a=variant, nm=name, ret=v)
        self._ret(uc, 0, v)

    def h_poll(self, uc, address, size, user):
        if self.args(uc, 1)[0] != OBJ + 4:
            raise d9.OracleError('0x44c479 argument')
        self.op('POLL')
        self._ret(uc, 0, 0)

    def h_tstop(self, uc, address, size, user):
        self.op('TSTOP', a=uc.reg_read(X.UC_X86_REG_ECX))
        self._ret(uc, 0, 0)

    def h_tdel(self, uc, address, size, user):
        if self.args(uc, 1)[0] != 1:
            raise d9.OracleError('thread destructor flag')
        self.op('TDEL', a=uc.reg_read(X.UC_X86_REG_ECX))
        self._ret(uc, 4, 0)

    def h_srel(self, uc, address, size, user):
        if self.args(uc, 1)[0] != OBJ + 4:
            raise d9.OracleError('0x44c4ab argument')
        self.op('SREL')
        self._ret(uc, 0, 0)

    def _zun(self, uc, name):
        self.need_ecx(uc, 0x5E2DBE, name)
        if self.args(uc, 1)[0] != OBJ + 8:
            raise d9.OracleError('%s argument' % name)
        self.op(name)
        self._ret(uc, 4, 0)

    def h_zua(self, uc, address, size, user):
        self._zun(uc, 'ZUA')

    def h_zub(self, uc, address, size, user):
        self._zun(uc, 'ZUB')

    def h_brel(self, uc, address, size, user):
        self.need_ecx(uc, 0x6201F9, 'bink release')
        if self.args(uc, 1)[0] != OBJ + 0x18E:
            raise d9.OracleError('0x4bedfa argument')
        self.op('BREL', a=u32(uc, OBJ + 0x18E))
        self._ret(uc, 4, 0)

    def h_surfrel(self, uc, address, size, user):
        self.need_ecx(uc, 0x5CF659, 'surface release')
        p = self.args(uc, 1)[0]
        if p != OBJ + 0x212:
            raise d9.OracleError('0x4c2dfb argument')
        self.op('SURFREL', a=u32(uc, p))
        self.wr(p, bytes(4))
        self._ret(uc, 4, 0)

    def h_sreset(self, uc, address, size, user):
        if self.args(uc, 1)[0] != OBJ + 8:
            raise d9.OracleError('0x44c4c1 argument')
        self.op('SRESET')
        self._ret(uc, 0, 0)

    def build_surface(self, handle, w, h):
        k = (handle - SURF_BASE) // 0x100
        if handle < SURF_BASE or (handle - SURF_BASE) % 0x100 or k >= N_SURF:
            raise ScriptError('surface handle %#x is not a scripted surface' % handle)
        size = 0x41 + 7 * k
        self.wr(handle, struct.pack('<I', PIX_BASE + 0x1000 * k) + bytes(0x1F))
        self.wr(handle + 0x23, struct.pack('<I', size))
        self.wr(handle + 0x2B, struct.pack('<hhh', s16(w), s16(h), s16(w)))
        self.surf_dims[handle] = (s16(w), s16(h))

    def h_screate(self, uc, address, size, user):
        self.need_ecx(uc, 0x5CF659, 'surface create')
        a = self.args(uc, 4)
        lab = {0x5598BC: 0, 0x559920: 1}.get(a[3])
        if lab is None or a[2] != 8:
            raise d9.OracleError('0x4c2a8d arguments')
        handle = self.pop('surface')
        self.build_surface(handle, a[0], a[1])
        self.op('SCREATE', a=a[0], b=a[1], c=8, d=lab, ret=handle)
        self._ret(uc, 0x10, handle)

    def h_zreg(self, uc, address, size, user):
        self.need_ecx(uc, 0x5E2DBE, 'z register')
        if self.args(uc, 1)[0] != OBJ + 8:
            raise d9.OracleError('0x4161d1 argument')
        self.op('ZREG')
        self._ret(uc, 4, 0)

    def h_tcreate(self, uc, address, size, user):
        a = self.args(uc, 4)
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if self.last_malloc is None or self.last_malloc != (ecx, 0x46) or (a[0], a[1], a[3]) != (0x4CF687, 0x63888B, 4):
            raise d9.OracleError('0x4497a0 arguments differ (ecx %#x malloc %s)' % (ecx, self.last_malloc))
        handle = self.pop('thread')
        if handle and (handle - THR_BASE) % 0x20 or (handle and (handle - THR_BASE) // 0x20 >= N_THR):
            raise ScriptError('thread handle %#x is not a scripted thread object' % handle)
        self.op('TCREATE', a=a[2], ret=handle)
        self._ret(uc, 0x10, handle)

    def h_tresume(self, uc, address, size, user):
        self.op('TRESUME', a=uc.reg_read(X.UC_X86_REG_ECX))
        self._ret(uc, 0, 0)

    def h_bopen(self, uc, address, size, user):
        self.need_ecx(uc, 0x6201F9, 'bink open')
        a = self.args(uc, 2)
        if a[1] != 0:
            raise d9.OracleError('0x4bef11 second argument')
        v = self.pop('bopen')
        self.op('BOPEN', a=a[0], ret=v)
        self._ret(uc, 8, v)

    def h_bprep(self, uc, address, size, user):
        self.need_ecx(uc, 0x6201F9, 'bink prepare')
        a = self.args(uc, 2)
        v = self.pop('bprep')
        self.op('BPREP', a=a[0], b=a[1], ret=v)
        self._ret(uc, 8, v)

    def _bink1(self, uc, name, queue, pop):
        self.need_ecx(uc, 0x6201F9, name)
        a = self.args(uc, 1)
        v = self.pop(queue) if queue else 0
        self.op(name, a=a[0], ret=v)
        self._ret(uc, 4, v)

    def h_bready(self, uc, address, size, user):
        self._bink1(uc, 'BREADY', 'bready', 4)

    def h_bnext(self, uc, address, size, user):
        self._bink1(uc, 'BNEXT', None, 4)

    def h_bframe(self, uc, address, size, user):
        self._bink1(uc, 'BFRAME', 'bframe', 4)

    def h_bmore(self, uc, address, size, user):
        self._bink1(uc, 'BMORE', 'bmore', 4)

    def h_bblit(self, uc, address, size, user):
        self.need_ecx(uc, 0x6201F9, 'bink blit')
        a = self.args(uc, 6)
        surf = u32(uc, OBJ + 0x212)
        w_word = struct.unpack('<h', self.rd(surf + 0x2F, 2))[0] & M32
        h_word = struct.unpack('<h', self.rd(surf + 0x2D, 2))[0] & M32
        if (a[1], a[2], a[3], a[4], a[5]) != (u32(uc, surf), w_word, h_word, 0, 0):
            raise d9.OracleError('0x4bf098 arguments')
        self.op('BBLIT', a=a[0], b=surf)
        self._ret(uc, 0x18, 0)

    def h_free(self, uc, address, size, user):
        self.frees.append(self.args(uc, 1)[0])
        self._ret(uc, 0, 0)

    def h_depreset(self, uc, address, size, user):
        self.need_ecx(uc, 0x63786D, 'dependency reset')
        self.resets.append(s32(self.args(uc, 1)[0]))
        self._ret(uc, 4, 0)

    def h_restore(self, uc, address, size, user):
        self.need_ecx(uc, 0x5CF659, 'restore blit')
        a = self.args(uc, 5)
        rect = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
        self.blits.append(dict(surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=a[4]))
        self._ret(uc, 0x14, 0)

    def h_fatal(self, uc, address, size, user):
        self.need_ecx(uc, 0x5CF659, 'fatal exit')
        raise d9.Fatal(FATAL)

    def h_raise(self, uc, address, size, user):
        raise d9.OracleError('guarded original routine %#x reached' % address)

    def h_log(self, uc, address, size, user):
        site = self.caller(uc)
        if not CODE_LO <= site < CODE_HI:
            raise d9.OracleError('logging routine %#x called from outside the object code (%#x)' % (address, site))
        self.logs.append((address, site))
        eax = 0
        self._ret(uc, LOG_POPS[address], eax)

    def h_arm(self, uc, address, size, user):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        self.entered.append(s16(struct.unpack('<h', self.rd(ebp - 0x11C, 2))[0]))

    def h_handler(self, uc, address, size, user):
        self.need_ecx(uc, OBJ, 'handler')
        row = s16(self.args(uc, 1)[0])
        phase = u32(uc, ROWS + row * ROW + PHASE_OFF) if 0 <= row < MAX_ROWS else 0
        self.calls.append(dict(row=row, phase=phase, start=len(self.oplog)))

    def h_fcopy(self, uc, address, size, user):
        # the hook fires once per rep iteration: the first one (ECX = size / 4) is the copy, the others are checked as its continuation
        single = FRAME_COPIES[address]
        idx = s16(struct.unpack('<h', self.rd(OBJ + 0x192, 2))[0])
        if not single and not 0 <= idx < 3:
            raise ScriptError('ring index %d is outside the scripted buffers' % idx)
        src = u32(uc, OBJ + 0x182 + (0 if single else 4 * idx))
        surf = u32(uc, OBJ + 0x212)
        total = u32(uc, surf + 0x23) >> 2
        esi, edi, ecx = (uc.reg_read(r) for r in (X.UC_X86_REG_ESI, X.UC_X86_REG_EDI, X.UC_X86_REG_ECX))
        k = total - ecx
        if not 0 <= k <= total or (esi, edi) != (src + 4 * k, u32(uc, surf) + 4 * k):
            raise d9.OracleError('frame copy registers differ from the scripted buffers and the surface')
        if k == 0:
            self.op('FCOPY', a=-1 if single else idx)

    # -- state ------------------------------------------------------------------------------------
    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(d9.HEAP_BASE, bytes(self.heap_high - d9.HEAP_BASE))
        uc.mem_write(d9.BODY_BASE, bytes(0x10000))
        uc.mem_write(d9.TIB, bytes(0x1000))
        uc.mem_write(SCRIPT, bytes(0x200000))
        uc.reg_write(X.UC_X86_REG_FPCW, d9.FPCW)
        self.heap_cursor = self.heap_high = d9.HEAP_BASE
        self.allocs.clear()
        self.mode = 'idle'
        self.expect_fatal = None
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.w32(VTBL, DTOR)
        self.wr(DTOR, b'\xC2\x04\x00')
        for k in range(N_THR):
            self.w32(THR(k), VTBL)
        rng = random.Random(0x2D)
        for i in range(3):
            self.wr(FB(i), bytes(rng.randrange(256) for _ in range(0x1000)))
        self.script, self.qpos, self.files, self.surf_dims = {}, {}, {}, {}
        self.clear_logs()
        self.last_malloc = None
        self.pending_file = None
        self.call(CTOR, [], OBJ)  # the static initialiser's constructor: vtable + reset, original code
        self.w32(d9.G_MODE, 3)

    def clear_logs(self):
        self.oplog, self.calls, self.entered, self.frees, self.resets, self.logs, self.blits = [], [], [], [], [], [], []

    def run(self, address, args, ecx):
        self.clear_logs()
        self.fatal = self.fault = False
        self.mode = 'step'
        try:
            self.call(address, args, ecx)
        except d9.Fatal as error:
            if error.address != FATAL:
                raise
            self.fatal = True
        except d9.OracleError as error:
            if self.expect_div0 and self.machine.reg_read(X.UC_X86_REG_EIP) == IDIV_ADDR and ('failed at' in str(error) or 'stopped at' in str(error)):
                self.fault = True
            else:
                raise
        finally:
            self.mode = 'idle'

    def objbytes(self):
        return self.rd(OBJ, 0x300)

    def field(self, name):
        off, size, sg = OBJ_SPEC[name]
        return int.from_bytes(self.rd(OBJ + off, size), 'little', signed=bool(sg))

    def wfield(self, name):
        va, size, sg = WORLD_SPEC[name]
        return int.from_bytes(self.rd(va, size), 'little', signed=bool(sg))

    def set_field(self, name, v):
        off, size, _ = OBJ_SPEC[name]
        self.wr(OBJ + off, (v & ((1 << (8 * size)) - 1)).to_bytes(size, 'little'))

    def set_world(self, name, v):
        va, size, _ = WORLD_SPEC[name]
        self.wr(va, (v & ((1 << (8 * size)) - 1)).to_bytes(size, 'little'))

    def snapshot(self):
        return self.rd(DATA_LO, DATA_HI - DATA_LO)

    def install_rows(self, rows):
        total = len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i, spec in enumerate(rows):
            base = ROWS + i * ROW
            self.wr(base + 0x30, bytes([0x2D, spec['subtype']]))
            at = BODY_AT + 0x4000 * i
            self.wr(at, spec['body'])
            self.w32(CELLS + 8 * i, at)
            self.w32(CELLS + 8 * i + 4, 50)
            self.wr(d9.G_ROWCOUNT, struct.pack('<h', i))  # the loader reads the index word as "the row being loaded"
            eax, _ = self.call(LOADER, [base + 0x32, CELLS + 8 * i, CELLS + 8 * i + 4], OBJ)
            if eax == 0:
                raise d9.OracleError('the original loader refused the body')
            tail = spec.get('tail') or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def tables(self, row):
        """The tables the original loader built for `row` (header block pointer from the row)."""
        hp = u32(self.machine, ROWS + row * ROW + 0x32)
        h = self.rd(hp, 39)
        mode, n, g = struct.unpack_from('<hhh', h, 0x21)
        et, gt = u32(self.machine, OBJ + 0x226), u32(self.machine, OBJ + 0x22A)
        entries = []
        for i in range(n):
            e = self.rd(et + 0x35 * i, 0x35)
            w21, w23, dmin, dmax, wt, nrec = struct.unpack_from('<hhiihh', e, 0x21)
            rp = struct.unpack_from('<I', e, 0x31)[0]
            recs = [(cstr(self.rd(rp + 0x23 * j, 33)).decode('latin1'), struct.unpack('<h', self.rd(rp + 0x23 * j + 0x21, 2))[0]) for j in range(nrec)]
            entries.append((cstr(e[:33]).decode('latin1'), w21, w23, dmin, dmax, wt, nrec, recs))
        groups = []
        for i in range(g):
            gr = self.rd(gt + 0x22 * i, 0x22)
            groups.append((struct.unpack_from('<h', gr, 0)[0], struct.unpack_from('<4i', gr, 2), struct.unpack_from('<4i', gr, 0x12)))
        return cstr(h[:33]).decode('latin1'), mode, entries, groups

    def expected_frees(self):
        row = s32(u32(self.machine, OBJ + 0x23E))
        if row == -1:
            return []
        hp = u32(self.machine, OBJ + 0x222)
        et, gt = u32(self.machine, OBJ + 0x226), u32(self.machine, OBJ + 0x22A)
        out = []
        if et:
            n = struct.unpack('<h', self.rd(hp + 0x23, 2))[0]
            for i in range(n):
                rp = u32(self.machine, et + 0x35 * i + 0x31)
                if rp:
                    out.append(rp)
            out.append(et)
        if gt:
            out.append(gt)
        rp = u32(self.machine, ROWS + row * ROW + 0x32)
        if rp:
            out.append(rp)
        return out


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_2d_runtime_oracle_driver.c'), str(Path(src_dir) / 'action_family_2d_runtime.c'), '-o', str(out)]
    if os.environ.get('A2D_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        p, i32, u8p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8)
        lib.d2o_new.restype = p
        for n in ('d2o_free', 'd2o_reset_all', 'd2o_log_clear', 'd2o_register'):
            getattr(lib, n).argtypes = [p]
        lib.d2o_set_parse.argtypes = [p, C.c_int, C.c_char_p, C.c_size_t]
        lib.d2o_bind.argtypes = [p, C.c_int, C.c_int]
        lib.d2o_queue_set.argtypes = [p, C.c_int, C.POINTER(i32), C.c_uint]
        lib.d2o_file_set.argtypes = [p, C.c_char_p, C.c_int, C.c_int]
        lib.d2o_surface_dims.argtypes = [p, C.c_uint32, C.c_int, C.c_int]
        lib.d2o_fail_op.argtypes = [p, C.c_int, C.c_uint]
        lib.d2o_script_error.argtypes = [p]
        lib.d2o_script_error.restype = C.c_char_p
        lib.d2o_why.argtypes = [p]
        lib.d2o_why.restype = C.c_char_p
        lib.d2o_nfields.restype = C.c_uint
        lib.d2o_nworld.restype = C.c_uint
        lib.d2o_field_name.argtypes = [C.c_uint]
        lib.d2o_field_name.restype = C.c_char_p
        lib.d2o_world_name.argtypes = [C.c_uint]
        lib.d2o_world_name.restype = C.c_char_p
        lib.d2o_get.argtypes = [p, C.c_uint]
        lib.d2o_get.restype = C.c_int64
        lib.d2o_set.argtypes = [p, C.c_uint, C.c_int64]
        lib.d2o_world_get.argtypes = [p, C.c_uint]
        lib.d2o_world_get.restype = C.c_int64
        lib.d2o_world_set.argtypes = [p, C.c_uint, C.c_int64]
        lib.d2o_has_set.argtypes = [p]
        lib.d2o_get_name.argtypes = [p, C.c_char_p]
        lib.d2o_get_label.argtypes = [p, C.c_char_p]
        lib.d2o_log_count.argtypes = [p]
        lib.d2o_log_count.restype = C.c_uint
        lib.d2o_log_get.argtypes = [p, C.c_uint, C.POINTER(i32), C.c_char_p]
        lib.d2o_step.argtypes = [p, C.c_int, C.c_uint32, C.c_int, C.POINTER(i32)]
        lib.d2o_stop.argtypes = [p, C.POINTER(i32)]
        lib.d2o_destruct.argtypes = [p, C.POINTER(i32)]
        lib.d2o_render.argtypes = [p, C.POINTER(i32)]
        lib.d2o_set_info.argtypes = [p, C.c_int, C.POINTER(i32)]
        lib.d2o_set_name_of.argtypes = [p, C.c_int]
        lib.d2o_set_name_of.restype = C.c_char_p
        lib.d2o_entry_info.argtypes = [p, C.c_int, C.c_int, C.POINTER(i32), C.c_char_p]
        lib.d2o_record_info.argtypes = [p, C.c_int, C.c_int, C.c_int, C.POINTER(i32), C.c_char_p]
        lib.d2o_group_info.argtypes = [p, C.c_int, C.c_int, C.POINTER(i32)]
        self.h = lib.d2o_new()
        self.fi = {lib.d2o_field_name(i).decode(): i for i in range(lib.d2o_nfields())}
        self.wi = {lib.d2o_world_name(i).decode(): i for i in range(lib.d2o_nworld())}
        if set(self.fi) != set(OBJ_SPEC) or set(self.wi) != set(WORLD_SPEC):
            raise d9.OracleError('driver field tables differ from the oracle: %s %s' % (set(self.fi) ^ set(OBJ_SPEC), set(self.wi) ^ set(WORLD_SPEC)))

    def close(self):
        self.lib.d2o_free(self.h)

    def reset(self):
        self.lib.d2o_reset_all(self.h)

    def parse(self, slot, body):
        return self.lib.d2o_set_parse(self.h, slot, bytes(body), len(body))

    def bind(self, slot, row):
        self.lib.d2o_bind(self.h, slot, row)

    def queue(self, name, values):
        arr = (C.c_int32 * max(1, len(values)))(*[s32(v) for v in values])
        self.lib.d2o_queue_set(self.h, QUEUES.index(name), arr, len(values))

    def file(self, name, variant, value):
        self.lib.d2o_file_set(self.h, name.encode(), variant, int(value))

    def dims(self, handle, w, h):
        self.lib.d2o_surface_dims(self.h, handle, w, h)

    def get(self, name):
        return self.lib.d2o_get(self.h, self.fi[name])

    def set(self, name, v):
        off, size, sg = OBJ_SPEC[name]
        self.lib.d2o_set(self.h, self.fi[name], s32(v) if size == 4 and sg else (s16(v) if size == 2 and sg else v & M32))

    def wget(self, name):
        return self.lib.d2o_world_get(self.h, self.wi[name])

    def wset(self, name, v):
        va, size, sg = WORLD_SPEC[name]
        self.lib.d2o_world_set(self.h, self.wi[name], s32(v) if size == 4 and sg else (s16(v) if size == 2 and sg else v & M32))

    def name159(self):
        b = C.create_string_buffer(33)
        self.lib.d2o_get_name(self.h, b)
        return bytes(b.raw[:33])

    def label(self):
        b = C.create_string_buffer(16)
        self.lib.d2o_get_label(self.h, b)
        return bytes(b.raw[:16])

    def clear(self):
        self.lib.d2o_log_clear(self.h)

    def log(self):
        out = []
        t = (C.c_int32 * 6)()
        nm = C.create_string_buffer(40)
        for i in range(self.lib.d2o_log_count(self.h)):
            self.lib.d2o_log_get(self.h, i, t, nm)
            out.append((t[0], t[1] & M32, t[2] & M32, t[3] & M32, t[4] & M32, cstr(nm.raw).decode('latin1') if t[0] == OPS['FILE'] else '', t[5] & M32))
        return out

    def script_error(self):
        return (self.lib.d2o_script_error(self.h) or b'').decode()

    def why(self):
        return (self.lib.d2o_why(self.h) or b'').decode()

    def step(self, row, phase, slot):
        out = (C.c_int32 * 4)()
        status = self.lib.d2o_step(self.h, row, phase, slot, out)
        return status, list(out)

    def stop(self):
        out = C.c_int32()
        status = self.lib.d2o_stop(self.h, C.byref(out))
        return status, out.value

    def destruct(self):
        out = C.c_int32()
        status = self.lib.d2o_destruct(self.h, C.byref(out))
        return status, out.value

    def register(self):
        self.lib.d2o_register(self.h)

    def render(self):
        out = (C.c_int32 * 11)()
        status = self.lib.d2o_render(self.h, out)
        return status, list(out)

    def parsed(self, slot):
        L, h = self.lib, self.h
        info = (C.c_int32 * 3)()
        if L.d2o_set_info(h, slot, info):
            return None
        name = cstr(L.d2o_set_name_of(h, slot)).decode('latin1')
        entries, groups = [], []
        t, nm = (C.c_int32 * 12)(), C.create_string_buffer(40)
        for i in range(info[1]):
            L.d2o_entry_info(h, slot, i, t, nm)
            recs = []
            for j in range(t[5]):
                L.d2o_record_info(h, slot, i, j, t, nm)  # reuses t: re-read the entry afterwards
                recs.append((cstr(nm.raw).decode('latin1'), t[0]))
            L.d2o_entry_info(h, slot, i, t, nm)
            entries.append((cstr(nm.raw).decode('latin1'), t[0], t[1], t[2], t[3], t[4], t[5], recs))
        for i in range(info[2]):
            L.d2o_group_info(h, slot, i, t)
            groups.append((t[0], tuple(t[1:5]), tuple(t[5:9])))
        return name, info[0], entries, groups


# ---------------------------------------------------------------------------------------------
# bodies and scenarios
# ---------------------------------------------------------------------------------------------
def name33(text, rng=None):
    b = text.encode() + b'\0'
    fill = bytes((0xA0 + 3 * k) & 0xFF for k in range(33)) if rng is None else bytes(rng.randrange(1, 256) for _ in range(33))
    return (b + fill)[:33]


def make_body(name, mode, entries, groups, rng=None):
    out = bytearray(name33(name, rng))
    out += struct.pack('<hhh', mode, len(entries), len(groups))
    for e in entries:
        out += name33(e['name'], rng)
        out += struct.pack('<hhiihh', e['w21'], e['w23'], e['dmin'], e['dmax'], e['weight'], len(e['records']))
        for rn, rw in e['records']:
            out += name33(rn, rng) + struct.pack('<h', rw)
    for g in groups:
        out += struct.pack('<h', g['key']) + struct.pack('<4i', *g['src']) + struct.pack('<4i', *g['dst'])
    return bytes(out)


def entry(name, w21=0, w23=3, dmin=0, dmax=0, weight=0, records=()):
    return dict(name=name, w21=w21, w23=w23, dmin=dmin, dmax=dmax, weight=weight, records=list(records))


def group(key, src=(0, 0, 10, 10), dst=(0, 0, 10, 10)):
    return dict(key=key, src=list(src), dst=list(dst))


def parse_body(body):
    """Independent walk of a body (names of the entries and records) for the file table."""
    n = struct.unpack_from('<h', body, 0x23)[0]
    names, cur = [], 39
    for _ in range(n):
        names.append(cstr(body[cur:cur + 33]).decode('latin1'))
        nrec = struct.unpack_from('<h', body, cur + 0x2F)[0]
        cur += 49
        for j in range(nrec):
            names.append(cstr(body[cur:cur + 33]).decode('latin1'))
            cur += 35
    return names


def tick_stream(rng, n, base=None, wrap=False, step_choices=(0, 1, 1, 2, 5, 9, 20, 60, -2)):
    v = (0xFFFFFFF0 - rng.randrange(40) if wrap else (rng.randrange(1000, 100000) if base is None else base))
    out = []
    for _ in range(n):
        v = (v + rng.choice(step_choices)) & M32
        out.append(v)
    return out


def default_script(rng, nrand=400, wrap=False, bink=None):
    return dict(
        rand=[rng.choice((rng.randrange(0, 32768), rng.randrange(0, 32768), rng.randrange(0, 20), rng.randrange(0, 0x7FFFFFFF))) for _ in range(nrand)],
        tick=tick_stream(rng, 1500, wrap=wrap),
        surface=[SURF(k) for k in range(N_SURF)],
        thread=[THR(k) for k in range(N_THR)],
        bopen=[0] * 40, bprep=[1] * 40,
        bready=[rng.choice((0, 1, 1)) for _ in range(400)],
        bframe=[rng.randrange(0, 10) for _ in range(400)], bmore=[rng.choice((0, 1, 1, 1)) for _ in range(400)])


def file_table(names, rng, mode='one'):
    table = {}
    for n in names:
        r = rng.random()
        avail = {0: [], 1: [rng.randrange(4)], 2: sorted(rng.sample(range(4), 2))}[0 if mode == 'none' else (0 if r < 0.05 else 1 if r < 0.9 else 2)]
        if mode == 'bik':
            avail = [rng.choice((0, 1))]
        elif mode == 'avf':
            avail = [rng.choice((2, 3))]
        elif mode == 'all':
            avail = [0, 1, 2, 3]
        for v in range(4):
            table[(n, v)] = v in avail
    return table


def rand_scenario(seed, quick=False, force=None):
    """One random synthetic scenario. `force` pins chosen parameters."""
    rng = random.Random(seed)
    f = dict(force or {})
    nent = f.get('nent', rng.choice((1, 1, 2, 2, 3, 5)))
    names = ['C%d' % i for i in range(nent)]
    kind = f.get('kind', rng.choice(('random', 'random', 'named', 'named', 'random')))
    mode = f.get('mode', rng.choice((1, 1, 0, 2, -1, 5)))
    entries = []
    for i, n in enumerate(names):
        w21 = rng.choice((0, 1, 5, -3, 0x7FFE, 0x7FFF, 2))
        w23 = rng.choice((w21, w21 + 1, w21 + 3, w21 - 2, 7, 2, 0x7FFF)) if w21 < 0x7FFE else rng.choice((w21, 7, -5))
        w23 = ((w23 + 0x8000) & 0xFFFF) - 0x8000
        dmin, dmax = rng.choice(((0, 0), (5, 5), (5, 20), (30, 10), (-5, 7), (0, 1), (100, 400), (-100, -3), (40, 40)))
        weight = rng.choice((0, 3, 10, -2, 100, 1))
        recs = []
        for _ in range(rng.choice((0, 0, 1, 2, 3))):
            target = rng.choice(names + [names[i], 'NOPE'] if rng.random() < 0.08 else names + [names[i]])
            if rng.random() < 0.25:
                target = rng.choice((target.lower(), target.upper(), target.swapcase()))
            recs.append((target, rng.choice((0, 5, -3, 12, 1, 4))))
        entries.append(entry(n, w21, w23, dmin, dmax, weight, recs))
    hname = 'RandomMovie' if kind == 'random' else (rng.choice(names) if names else 'C0')
    if kind == 'named' and rng.random() < 0.3:
        hname = hname.lower()
    if f.get('hname'):
        hname = f['hname']
    keys = [1, 2, 3, 0x270F, -1]
    groups = []
    for _ in range(f.get('ngroups', rng.choice((0, 1, 1, 2, 4)))):
        src = [rng.choice((0, 3, -4, 100)) for _ in range(4)]
        dst = [rng.choice((0, 7, -9, 200, -100000)) for _ in range(4)]
        groups.append(group(rng.choice(keys), src, dst))
    body = make_body(hname, mode, entries, groups, rng)
    all_names = parse_body(body) + ['NOPE', hname]
    files = file_table(sorted(set(all_names)), rng, f.get('files', 'one'))
    key = rng.choice([g['key'] for g in groups] + [99, 7]) if groups else rng.choice((1, 99))
    script = default_script(rng, wrap=rng.random() < 0.15)
    if rng.random() < 0.14:
        script['thread'].insert(rng.randrange(3), 0)
    if rng.random() < 0.12:
        script['bopen'].insert(rng.randrange(3), rng.choice((1, 5, -1)))
    if rng.random() < 0.12:
        script['bprep'].insert(rng.randrange(3), 0)
    sc = dict(id='rand:%d' % seed, group='random', rows=[dict(body=body, subtype=1)], files=files, script=script,
              world=dict(scene_key=key, view_x=rng.choice((0, 5, -7, 1000)), view_y=rng.choice((0, 3, -11, 480)), thread_arg=rng.choice((0, 7, -3)),
                         back_buffer=rng.choice((0, 0x5000, 0x80000001)), g_5839a9=rng.choice((0, 1, 7, -4)),
                         g_5d16cd=rng.choice((0, 1, -1, 7)), g_5d1683=rng.choice((0, 2, -3)), g_5d1639=rng.choice((0, 5)), g_5831c8=rng.choice((0, 3)),
                         g_5831c6=rng.choice((0, 5)), start_flag=rng.choice((0, 1, 9)), entry_flag=rng.choice((0, 1)), entry_surface=rng.choice((0, 0x1234))),
              pokes=dict(rect_1b2=0, rect_1b6=0, rect_1ba=rng.choice((15, 159, 639)), rect_1be=rng.choice((7, 119, 479)), period_24=0,
                         buffer_192=rng.choice((0, 1, 2, 7)), pending_25a=rng.choice((0, 1, 7)), flag_206=rng.choice((0, 0, 1))),
              actions=[], quick=quick)
    acts = sc['actions']
    acts.append(('tick',))
    for _ in range(f.get('ticks', rng.randrange(6, 40))):
        r = rng.random()
        poke = {}
        if rng.random() < 0.7:
            poke['ready_1d4'] = rng.choice((0, 1, 1, 1, -1, 0x100))
        if rng.random() < 0.3:
            poke['period_24'] = rng.choice((0, 1, 5, 17, 40, M32 - 3, 0x80000000))
        if rng.random() < 0.3:
            poke['buffer_192'] = rng.choice((0, 1, 2))
        if rng.random() < 0.1:
            poke['bink_id_18e'] = rng.choice((0, 5, 77))
        if rng.random() < 0.07:
            poke['state_1de'] = rng.choice((2, 4, 5, -1, 0, 1, 3))
        if rng.random() < 0.07:
            poke['state_1da'] = rng.choice((0, 1, 2, 4, 5, -1))
        if rng.random() < 0.1:
            poke['rect_1ba'] = rng.choice((15, 159, 639, 7))
            poke['rect_1be'] = rng.choice((7, 119, 479, 3))
        if rng.random() < 0.06:
            poke['frame_1ca'] = rng.choice((0, 5, -1, 0x7FFF, -0x8000))
        if poke:
            acts.append(('poke', poke))
        if rng.random() < 0.15:
            acts.append(('world', dict(scene_key=rng.choice(keys + [99]))))
        if rng.random() < 0.08:
            acts.append(('world', dict(g_5831c8=rng.choice((0, 3)), g_5831c6=rng.choice((0, 5)), g_5d16cd=rng.choice((0, 1)), g_5d1683=rng.choice((0, 2)),
                                       g_5d1639=rng.choice((0, 5)), g_5839a9=rng.choice((0, 1, 7)))))
        if r < 0.04:
            acts.append(('register',))
        elif r < 0.08:
            if not any(a[0] == 'register' for a in acts):
                acts.append(('register',))
            acts.append(('render',))
        elif r < 0.10:
            acts.append(('handler', 0))
        else:
            acts.append(('tick',))
    tail = f.get('tail', rng.choice(('stop2', 'stop2', 'stopcall', 'destruct', 'none', 'double0', 'phase7')))
    if tail == 'stop2':
        acts += [('register',), ('phase', 0, 2), ('tick',), ('render',)]
    elif tail == 'stopcall':
        acts += [('register',), ('stop', 0), ('render',)]
    elif tail == 'destruct':
        acts += [('register',), ('destruct',), ('render',)]
    elif tail == 'double0':
        acts += [('phase', 0, 0), ('tick',)]
    elif tail == 'phase7':
        acts += [('phase', 0, 7), ('tick',), ('phase', 0, 1), ('tick',)]
    return sc


def structured_scenarios():
    scs = []
    rng = random.Random(0x36)

    def S(sid, body_spec, files, actions, group='struct', quick=False, script=None, world=None, pokes=None, rows=None):
        body = make_body(*body_spec, rng=random.Random(sid)) if body_spec else None
        names = (parse_body(body) if body else []) + ['NOPE']
        ft = files if isinstance(files, dict) else file_table(sorted(set(names)), random.Random(1), files)
        sc = dict(id=sid, group=group, rows=rows or [dict(body=body, subtype=1)], files=ft, script=script or default_script(random.Random(sid)),
                  world=dict(scene_key=1, view_x=0, view_y=0, thread_arg=3, back_buffer=0x7000, g_5839a9=5, **(world or {})),
                  pokes=dict(rect_1b2=0, rect_1b6=0, rect_1ba=15, rect_1be=7, period_24=3, **(pokes or {})), actions=actions, quick=quick)
        scs.append(sc)
        return sc

    # phase 0 matrix
    for hname, mode, n in ((('RandomMovie'), 1, 2), ('RandomMovie', 0, 1), ('RandomMovie', 2, 5), ('RandomMovie', -1, 3), ('RandomMovie', 1, 0), ('C1', 1, 3),
                           ('C0', 0, 2), ('Zzz', 1, 3), ('C1', 5, 0), ('RandomMovieX', 1, 3), ('RandomMovi', 1, 2), ('randommovie', 1, 2)):
        ents = [entry('C%d' % i, 0, 3) for i in range(n)]
        for fm in ('bik', 'avf', 'one', 'none'):
            S('p0:%s:%d:%d:%s' % (hname, mode, n, fm), (hname, mode, ents, [group(1)]), fm, [('tick',), ('tick',)], group='phase0',
              quick=fm in ('one', 'none') and n in (1, 2, 3) and mode in (1, 0) and hname in ('RandomMovie', 'C1', 'Zzz', 'RandomMovieX', 'randommovie'))
    # duplicate entry names: the first wins; duplicate group keys: the first wins
    ents = [entry('D', 0, 3), entry('D', 5, 9), entry('E', 1, 2)]
    S('dup:names', ('D', 1, ents, [group(1, (1, 2, 3, 4), (5, 6, 7, 8)), group(1, (9, 9, 9, 9), (1, 1, 1, 1)), group(2)]), 'avf',
      [('tick',), ('poke', dict(ready_1d4=1)), ('tick',), ('tick',)], group='phase0', quick=True)
    # file probe results for each variant, one at a time and combinations
    for combo in ((0,), (1,), (2,), (3,), (0, 1), (2, 3), (1, 2), (1, 3), (0, 3), ()):
        ft = {('C0', v): v in combo for v in range(4)}
        ft.update({('NOPE', v): False for v in range(4)})
        S('probe:%s' % (combo,), ('C0', 1, [entry('C0', 0, 3)], [group(1)]), ft, [('tick',), ('poke', dict(ready_1d4=1)), ('tick',), ('tick',)], group='probe',
          quick=combo in ((0,), (1,), (2,), (3,), (1, 2), ()))
    # surface / thread / bink failures and the size check
    ab = ('A', 1, [entry('A', 0, 2, 0, 0, 0, [('B', 5)]), entry('B', 0, 2, 0, 0, 4, [])], [group(1)])
    avf = {(n, v): v == 2 for n in ('A', 'B', 'NOPE') for v in range(4)}
    bik = {(n, v): v == 0 for n in ('A', 'B', 'NOPE') for v in range(4)}
    thr = lambda *v: dict(default_script(random.Random(5)), thread=list(v))
    S('fail:thread_phase0', ab, avf, [('tick',), ('tick',)], group='failure', quick=True, script=thr(0, THR(1)))
    S('fail:thread_record', ab, avf, [('tick',), ('poke', dict(state_1de=3)), ('tick',), ('tick',)], group='failure', quick=True, script=thr(THR(0), 0, THR(2)))
    S('fail:bink_open', ab, bik, [('tick',), ('tick',)], group='failure', quick=True, script=dict(default_script(random.Random(5)), bopen=[1] + [0] * 9))
    S('fail:bink_prepare', ab, bik, [('tick',), ('tick',)], group='failure', quick=True, script=dict(default_script(random.Random(5)), bprep=[0] + [1] * 9))
    S('fail:bink_open_record', ab, bik, [('tick',), ('poke', dict(state_1de=3)), ('tick',)], group='failure', quick=True,
      script=dict(default_script(random.Random(5)), bopen=[0, -1] + [0] * 9))
    S('fail:bink_prepare_record', ab, bik, [('tick',), ('poke', dict(state_1de=3)), ('tick',)], group='failure', quick=True,
      script=dict(default_script(random.Random(5)), bprep=[1, 0] + [1] * 9))
    for tag, pk in (('width', dict(rect_1ba=19)), ('height', dict(rect_1be=11)), ('both', dict(rect_1ba=19, rect_1be=11)), ('none', {})):
        S('size:%s' % tag, ab, avf, [('tick',), ('poke', pk), ('poke', dict(state_1de=3)), ('tick',), ('poke', dict(ready_1d4=1)), ('tick',), ('tick',)],
          group='size', quick=True)
        S('size_bink:%s' % tag, ab, bik, [('tick',), ('poke', pk), ('poke', dict(state_1de=3)), ('tick',), ('tick',)], group='size', quick=True)
    S('surface:injected_released', ab, avf, [('surface', 5, 16, 8), ('tick',), ('tick',)], group='size', quick=True)
    S('state:paused', ab, avf, [('tick',), ('poke', dict(state_1de=2)), ('tick',), ('tick',), ('poke', dict(state_1de=5)), ('tick',), ('poke', dict(state_1de=0, ready_1d4=1)),
                                ('tick',)], group='state', quick=True)
    S('state:da_values', ab, avf, [('tick',), ('poke', dict(state_1da=1, ready_1d4=1)), ('tick',), ('poke', dict(state_1da=2)), ('tick',)], group='state', quick=True)
    # dependency tails through the real loader and gate: the handler runs only while the event flag holds
    tail = struct.pack('<8h', 2, 40, 1, 0, 0, 0, 0, 0)
    rows = [dict(body=make_body(*ab, rng=random.Random(9)), subtype=1, tail=tail)]
    S('gate:off_then_on', None, avf, [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('tick',), ('events', {40: 0}), ('tick',), ('events', {40: 1}),
                                      ('phase', 0, 2), ('tick',)], group='gate', quick=True, rows=rows)
    S('gate:on', None, avf, [('events', {40: 1}), ('tick',), ('poke', dict(ready_1d4=1)), ('tick',), ('tick',)], group='gate', rows=rows)
    # weights: a negative record weight before a positive one; the stay range; the raw draw for a total of -1
    for tag, ew, recs in (('negfirst', 0, [('B', -3), ('B', 5)]), ('zerofirst', 0, [('B', 0), ('B', 4)]), ('stay', 3, [('B', 2)]), ('raw', 2, [('B', -3)]),
                          ('edge', 2, [('B', 3), ('B', 1)]), ('negstay', -2, [('B', 6)])):
        for rv in (0, 1, 2, 3, 4, 5, 6, 7):
            S('weights:%s:%d' % (tag, rv), ('A', 1, [entry('A', 0, 2, 5, 9, ew, recs), entry('B', 0, 2, 0, 0, 4, [])], [group(1)]), avf,
              [('tick',), ('poke', dict(state_1de=3)), ('tick',), ('tick',)], group='weights', quick=rv in (0, 3, 5),
              script=dict(default_script(random.Random(rv)), rand=[rv] * 5 + [rv + 1] * 40))
    return scs


def build_scenarios(corpus, count_random=420, seed=0x2D36):
    scs = structured_scenarios()
    quick_idx = set(range(0, count_random, 3))
    for k in range(count_random):
        scs.append(rand_scenario(seed + k, quick=k in quick_idx))
    # focused random families
    fam = [
        ('avf_play', dict(files='avf', kind='random', mode=1, tail='stop2', nent=2)),
        ('bink_play', dict(files='bik', kind='random', mode=1, tail='stopcall', nent=2)),
        ('avf_ring', dict(files='avf', kind='named', mode=0, tail='destruct', nent=3)),
        ('bink_ring', dict(files='bik', kind='named', mode=2, tail='none', nent=3)),
        ('groups', dict(files='one', ngroups=4, tail='none')),
    ]
    for fi, (fname, force) in enumerate(fam):
        for k in range(14):
            sc = rand_scenario(0x7000 + 100 * fi + k, quick=k < 2, force=dict(force, ticks=30))
            sc['id'] = 'fam:%s:%d' % (fname, k)
            sc['group'] = fname
            scs.append(sc)
    # corpus
    for ci, body in enumerate(corpus or []):
        names = parse_body(body) + ['NOPE']
        for k in range(8):
            r = random.Random(0xC0 + 16 * ci + k)
            sc = dict(id='corpus:%d:%d' % (ci, k), group='corpus', rows=[dict(body=body, subtype=1)],
                      files=file_table(sorted(set(names)), r, 'all' if k % 3 == 0 else ('avf' if k % 3 == 1 else 'one')),
                      script=default_script(r, nrand=600, wrap=k == 5),
                      world=dict(scene_key=1 + k % 3, view_x=r.choice((0, -5)), view_y=r.choice((0, 9)), thread_arg=3, back_buffer=0x6000, g_5839a9=2),
                      pokes=dict(rect_1b2=0, rect_1b6=0, rect_1ba=639, rect_1be=479, period_24=r.choice((0, 4, 30))), actions=[('tick',)], quick=k == 0)
            for _ in range(60):
                if r.random() < 0.8:
                    sc['actions'].append(('poke', dict(ready_1d4=r.choice((0, 1, 1)), buffer_192=r.choice((0, 1, 2)))))
                if r.random() < 0.1:
                    sc['actions'].append(('world', dict(scene_key=r.choice((1, 2, 3, 4, 5, 99)))))
                sc['actions'].append(('tick',))
            sc['actions'] += [('phase', 0, 2), ('tick',), ('render',)]
            scs.append(sc)
    return scs


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, steps=0, ticks=0, handler_calls=0, direct_calls=0, ops_compared=0, field_compares=0, world_compares=0, row_compares=0,
                stray_checks=0, free_checks=0, parse_compares=0, malformed_parse_calls=0, malformed_accepted=0, malformed_rejected=0, fatal_steps=0, fault_steps=0, blit_checks=0, mismatches=0, scripted_errors=0,
                expected_differences=Counter(), op_histogram=Counter(), groups={}, phases=Counter())


def compare_obj(where, x, nat, st):
    ob = x.objbytes()
    for name, (off, size, sg) in OBJ_SPEC.items():
        o = int.from_bytes(ob[off:off + size], 'little')
        n = nat.get(name) & ((1 << (8 * size)) - 1)
        st['field_compares'] += 1
        if o != n:
            raise Mismatch('%s: object field %s original %#x native %#x' % (where, name, o, n))
    st['field_compares'] += 4
    if ob[0x159:0x159 + 33] != nat.name159():
        raise Mismatch('%s: clip name +0x159 original %r native %r' % (where, ob[0x159:0x159 + 33][:12], nat.name159()[:12]))
    has = nat.lib.d2o_has_set(nat.h) != 0
    if (u32(x.machine, OBJ + 0x222) != 0) != has:
        raise Mismatch('%s: table pointer presence original %#x native %s' % (where, u32(x.machine, OBJ + 0x222), has))
    for a in (0x222, 0x226, 0x22A):
        if (u32(x.machine, OBJ + a) != 0) != (u32(x.machine, OBJ + 0x222) != 0) and has:
            raise Mismatch('%s: table pointer +%#x presence differs from +0x222' % (where, a))


def compare_world(where, x, nat, st, label=False):
    for name, (va, size, sg) in WORLD_SPEC.items():
        o = int.from_bytes(x.rd(va, size), 'little')
        n = nat.wget(name) & ((1 << (8 * size)) - 1)
        st['world_compares'] += 1
        if o != n:
            raise Mismatch('%s: world %s original %#x native %#x' % (where, name, o, n))
    if label:
        if x.rd(0x5D1A53, 16) != nat.label():
            raise Mismatch('%s: Z slot label differs' % where)
        if (u32(x.machine, 0x5D1A35), u32(x.machine, 0x5D1A3D), u32(x.machine, 0x5D1A41)) != (RENDER, OBJ + 0x1E2, OBJ + 0x1F2):
            raise Mismatch('%s: Z slot callback / rect pointers differ from 0x4cf749 / obj+0x1e2 / obj+0x1f2' % where)
        st['world_compares'] += 3


def compare_rows(where, x, model, st):
    for i, m in enumerate(model):
        base = ROWS + i * ROW
        done = x.rd(base + COMPLETE_OFF, 1)[0]
        phase = u32(x.machine, base + PHASE_OFF)
        dead = u32(x.machine, base + 0x85)
        st['row_compares'] += 1
        if (done, phase, dead) != (m['done'], m['phase'], 1 if m['dead'] else 0):
            raise Mismatch('%s: row %d original (done %d phase %d dead %d) native model (done %d phase %d dead %d)' % (
                where, i, done, phase, dead, m['done'], m['phase'], 1 if m['dead'] else 0))
        if m['dead']:
            t = (x.rd(base + 0x30, 1)[0], u32(x.machine, base + 0x32), u32(x.machine, base + 0x73), struct.unpack('<h', x.rd(base + 0x83, 2))[0],
                 u32(x.machine, base + 0x89))
            if t != (0, 0, 0, -1, 0):
                raise Mismatch('%s: erased row %d stores differ %s' % (where, i, t))


def erase_model(model, row):
    m = model[row]
    m.update(dead=True, done=0, phase=0)


def check_stray(where, x, before_obj, before_data, st):
    after_obj = x.objbytes()
    for k in range(0x300):
        if before_obj[k] != after_obj[k] and k not in OBJ_OK:
            raise Mismatch('%s: stray object byte change at +%#x' % (where, k))
    after = x.snapshot()
    st['stray_checks'] += 1
    if after != before_data:
        # locate differing bytes quickly
        for k in range(0, len(after), 4096):
            if after[k:k + 4096] != before_data[k:k + 4096]:
                for j in range(k, min(k + 4096, len(after))):
                    va = DATA_LO + j
                    if after[j] != before_data[j] and not (OBJ <= va < OBJ + 0x300) and va not in DATA_OK:
                        raise Mismatch('%s: stray data byte change at %#x' % (where, va))


def compare_ops(where, x_ops, nat, st):
    n_ops = nat.log()
    if nat.script_error():
        raise ScriptError('native script error: ' + nat.script_error())
    st['ops_compared'] += len(x_ops)
    for o in x_ops:
        st['op_histogram'][OPN[o[0]]] += 1
    if x_ops != n_ops:
        k = next((i for i, (a, b) in enumerate(zip(x_ops, n_ops)) if a != b), min(len(x_ops), len(n_ops)))
        fmt = lambda t: None if t is None else (OPN.get(t[0], t[0]),) + tuple(t[1:])
        raise Mismatch('%s: op %d original %s native %s (counts %d / %d)' % (where, k, fmt(x_ops[k]) if k < len(x_ops) else None,
                                                                             fmt(n_ops[k]) if k < len(n_ops) else None, len(x_ops), len(n_ops)))


def native_status_ok(where, status, x, last, why):
    """The original's end condition for the last call must equal the native status."""
    if last and x.fatal:
        if status != 4:
            raise Mismatch('%s: original reached the fatal exit, native status %d (%s)' % (where, status, why))
        return 'fatal'
    if last and x.fault:
        if status != 2 or 'divides by zero' not in why:
            raise Mismatch('%s: original faulted at the idiv, native status %d (%s)' % (where, status, why))
        return 'fault'
    if status != 0:
        raise Mismatch('%s: native status %d (%s) where the original completed' % (where, status, why))
    return 'ok'


def apply_native_world_after_destruct(nat):
    nat.wset('entry_flag', 0)


def run_scenario(x, nat, sc, st, verbose=False):
    x.hard_reset()
    nat.reset()
    x.script = {k: list(v) for k, v in sc['script'].items()}
    x.qpos = {}
    x.files = dict(sc['files'])
    for k, v in sc['script'].items():
        nat.queue(k, v)
    for (n, v), val in sc['files'].items():
        nat.file(n, v, val)
    rows = sc['rows']
    x.install_rows(rows)
    last = len(rows) - 1
    # the parsed sets against the tables the REAL loader built (only the last row's tables stay in the object)
    for i, r in enumerate(rows):
        status = nat.parse(i, r['body'])
        if status != 0:
            raise Mismatch('%s: native rejected a body the original loaded: %s' % (sc['id'], nat.why()))
    nat.bind(last, last)
    if x.tables(last) != nat.parsed(last):
        raise Mismatch('%s: native parse differs from the original loader tables' % sc['id'])
    st['parse_compares'] += 1
    for k, v in sc['world'].items():
        x.set_world(k, v)
        nat.wset(k, v)
    for k, v in sc['pokes'].items():
        x.set_field(k, v)
        nat.set(k, v)
    for i in range(3):
        x.set_field('buffers_182_%d' % i, FB(i))
        nat.set('buffers_182_%d' % i, FB(i))
    model = [dict(done=0, dead=False, phase=0, tail=r.get('tail') or b'') for r in rows]
    for k, v in sc.get('events', {}).items():
        x.wr(EVENTS_VA + 4 * k, struct.pack('<i', v))
    compare_obj(sc['id'] + ' initial', x, nat, st)
    compare_world(sc['id'] + ' initial', x, nat, st)
    compare_rows(sc['id'] + ' initial', x, model, st)
    for ai, act in enumerate(sc['actions']):
        where = '%s #%d %s' % (sc['id'], ai, act[0] if len(act) < 2 or not isinstance(act[1], dict) else '%s%s' % (act[0], sorted(act[1].items())[:3]))
        st['steps'] += 1
        try:
            outcome = do_action(x, nat, sc, act, where, model, st)
        except ScriptError:
            st['scripted_errors'] += 1
            raise
        if outcome in ('fatal', 'fault'):
            st['fatal_steps' if outcome == 'fatal' else 'fault_steps'] += 1
            break
    st['scenarios'] += 1


def gate_open(spec_tail, x):
    if not spec_tail:
        return True
    rec = struct.unpack_from('<8h', spec_tail, 0)
    return x.s32(EVENTS_VA + 4 * rec[1]) == rec[2]


def process_calls(where, x, nat, model, st, slot_of, direct=False):
    """Replay every handler call the original made on the native kernel; returns the outcome."""
    outcome = 'ok'
    if (x.calls and x.calls[0]['start'] != 0) or (not x.calls and x.oplog):
        raise Mismatch('%s: engine calls outside a handler visit' % where)
    bounds = [c['start'] for c in x.calls] + [len(x.oplog)]
    for ci, call in enumerate(x.calls):
        row = call['row']
        seg = x.oplog[bounds[ci]:bounds[ci + 1]]
        nat.clear()
        status, out = nat.step(row, call['phase'], slot_of(row))
        last = ci == len(x.calls) - 1
        outcome = native_status_ok('%s call %d (row %d)' % (where, ci, row), status, x, last, nat.why())
        compare_ops('%s call %d (row %d)' % (where, ci, row), seg, nat, st)
        st['handler_calls'] += 1
        st['phases'][call['phase']] += 1
        if outcome == 'ok':
            model[row]['phase'] = out[0]
            if out[1] != -1:
                erase_model(model, out[1])
                model[out[1]]['done'] = 1
                x.native_erased = True
        elif outcome == 'fault' or outcome == 'fatal':
            pass
    return outcome


def check_frees(where, x, erased, st):
    st['free_checks'] += 1
    exp = x.pre_frees if erased else []
    if x.frees != exp:
        raise Mismatch('%s: frees original %s expected %s' % (where, [hex(v) for v in x.frees], [hex(v) for v in exp]))


def do_action(x, nat, sc, act, where, model, st):
    kind = act[0]
    if kind in ('poke', 'world', 'phase', 'queue', 'surface', 'events'):
        if kind == 'poke':
            for k, v in act[1].items():
                x.set_field(k, v)
                nat.set(k, v)
        elif kind == 'world':
            for k, v in act[1].items():
                x.set_world(k, v)
                nat.wset(k, v)
        elif kind == 'phase':
            x.w32(ROWS + act[1] * ROW + PHASE_OFF, act[2])
            model[act[1]]['phase'] = act[2]
        elif kind == 'events':
            for k, v in act[1].items():
                x.wr(EVENTS_VA + 4 * k, struct.pack('<i', v))
        elif kind == 'queue':
            x.script[act[1]] = list(act[2])
            x.qpos[act[1]] = 0
            nat.queue(act[1], act[2])
        elif kind == 'surface':  # inject a surface struct with its own dimensions and make it the object's
            k, w, h = act[1], act[2], act[3]
            x.build_surface(SURF(k), w, h)
            nat.dims(SURF(k), s16(w), s16(h))
            x.set_field('surface_212', SURF(k))
            nat.set('surface_212', SURF(k))
        return 'ok'
    before_obj, before_data = x.objbytes(), x.snapshot()
    x.pre_frees = x.expected_frees()
    x.native_erased = False
    nat.clear()
    if kind == 'tick':
        st['ticks'] += 1
        x.run(0x427A50, [], 0)
        exp_enter = [i for i, m in enumerate(model) if not m['done'] and not m['dead']]
        if x.fatal or x.fault:
            exp_enter = exp_enter[:len(x.entered)]
        exp_handler = [i for i in exp_enter if gate_open(model[i]['tail'], x)]
        if x.entered != exp_enter or [c['row'] for c in x.calls] != exp_handler:
            raise Mismatch('%s: dispatcher entered rows %s handler rows %s, model %s / %s' % (
                where, x.entered, [c['row'] for c in x.calls], exp_enter, exp_handler))
        outcome = process_calls(where, x, nat, model, st, lambda r: r)
    elif kind == 'handler':
        st['direct_calls'] += 1
        row = act[1]
        x.run(HANDLER, [row & M32], OBJ)
        outcome = process_calls(where, x, nat, model, st, lambda r: r)
    elif kind == 'stop':
        st['direct_calls'] += 1
        arg = act[1]
        x.run(STOP, [arg & M32], OBJ)
        status, erased = nat.stop()
        if status != 0:
            raise Mismatch('%s: native stop status %d' % (where, status))
        compare_ops(where, x.oplog, nat, st)
        if erased != -1:
            erase_model(model, erased)
            x.native_erased = True
        model[arg]['done'] = 1
        outcome = 'ok'
    elif kind == 'destruct':
        st['direct_calls'] += 1
        x.run(DESTRUCT, [], OBJ)
        status, erased = nat.destruct()
        if status != 0:
            raise Mismatch('%s: native destruct status %d' % (where, status))
        compare_ops(where, x.oplog, nat, st)
        if erased != -1:
            erase_model(model, erased)
            x.native_erased = True
        if x.wfield('entry_flag') != 0:
            raise Mismatch('%s: the original reset did not clear 0x5d1a45' % where)
        apply_native_world_after_destruct(nat)
        st['expected_differences']['E2 destruct leaves 0x5d1a45 to the binding'] += 1
        outcome = 'ok'
    elif kind == 'register':
        st['direct_calls'] += 1
        x.run(REGISTER, [], OBJ)
        nat.register()
        compare_ops(where, x.oplog, nat, st)
        compare_world(where, x, nat, st, label=True)
        outcome = 'ok'
    elif kind == 'render':
        st['direct_calls'] += 1
        x.run(RENDER, [], 0)
        status, plan = nat.render()
        st['blit_checks'] += 1
        if status != 0:
            raise Mismatch('%s: native render status %d' % (where, status))
        if plan[0]:
            exp = dict(surface=plan[1] & M32, target=plan[2] & M32, src=plan[3:7], dst=plan[7:11])
            if len(x.blits) != 1 or any(x.blits[0][k] != exp[k] for k in ('surface', 'target', 'src', 'dst')):
                raise Mismatch('%s: render plan %s original blits %s' % (where, exp, x.blits))
        elif x.blits:
            raise Mismatch('%s: native plan invalid but the original blitted %s' % (where, x.blits))
        compare_ops(where, x.oplog, nat, st)
        outcome = 'ok'
    else:
        raise d9.OracleError('unknown action ' + kind)
    if kind != 'render':
        compare_obj(where, x, nat, st)
        compare_world(where, x, nat, st, label=False)
        compare_rows(where, x, model, st)
        check_stray(where, x, before_obj, before_data, st)
        check_frees(where, x, x.native_erased, st)
    return outcome


Oracle.pre_frees = []
Oracle.native_erased = False


def malformed_run(nat, bodies, st, seed=0x36):
    """Bounded malformed bodies through the native parser (the original overruns on these; native must reject or accept cleanly)."""
    rng = random.Random(seed)
    ents = [entry('C%d' % i, 0, 3, 0, 5, 2, [('C0', 1)]) for i in range(3)]
    pool = list(bodies) + [make_body('RandomMovie', 1, ents, [group(1), group(2)], rng), make_body('C0', 0, ents[:1], [], rng), make_body('X', 1, [], [], rng)]
    seen = Counter()
    for body in pool:
        cases = [body[:n] for n in range(0, min(len(body), 700))] + [body[:n] for n in range(max(0, len(body) - 80), len(body))]
        for _ in range(250):
            b = bytearray(body)
            for _ in range(rng.randrange(1, 4)):
                k = rng.choice((0x23, 0x25, 0x23 + 0x31 - 0x2, rng.randrange(len(b)))) if len(b) > 0x30 else 0
                if k + 2 <= len(b):
                    b[k:k + 2] = struct.pack('<h', rng.choice((-1, -32768, 0x7FFF, 1000, 0, 5, 0x100)))
                if rng.random() < 0.4 and len(b) > 3:
                    b[rng.randrange(min(len(b), 120))] = rng.randrange(1, 256)  # may remove the NUL of a name span
            cases.append(bytes(b))
        for c in cases:
            status = nat.parse(5, c)
            st['malformed_parse_calls'] += 1
            if status not in (0, 2):
                raise Mismatch('malformed body: native parse status %d' % status)
            seen[status] += 1
    st['malformed_accepted'], st['malformed_rejected'] = seen[0], seen[2]


def run_list(x, nat, scs, st, fail_fast=False, show=None):
    bad = []
    for sc in scs:
        t0 = time.monotonic()
        before = st['steps']
        try:
            run_scenario(x, nat, sc, st)
        except (Mismatch, d9.OracleError, ScriptError) as error:
            bad.append((sc['id'], '%s: %s' % (type(error).__name__, error)))
            st['mismatches'] += 1
            if fail_fast:
                break
        g = st['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['steps'] += st['steps'] - before
        g['seconds'] += round(time.monotonic() - t0, 2)
    return bad


# ---------------------------------------------------------------------------------------------
# mutants of the native kernel (each must be detected by the quick scenario set)
# ---------------------------------------------------------------------------------------------
C_ = 'action_family_2d_runtime.c'
MUT = [
    ('phase0 active test never fatal', 'if (o->movie.active != 0) {\n        *why = "0x2d: the random-movie object is already active', 'if (o->movie.active == 99) {\n        *why = "0x2d: the random-movie object is already active'),
    ('start flag cleared', 'w->start_flag = 1;', 'w->start_flag = 0;'),
    ('saved_202 not saved', '    o->saved_202 = w->g_5839a9;\n', ''),
    ('mode word test inverted', 'if (set->mode_word == 1) {\n        w->g_5839a9 = 0;', 'if (set->mode_word != 1) {\n        w->g_5839a9 = 0;'),
    ('single buffer flag swapped in mode 1', 'w->g_5839a9 = 0;\n        o->ring_17a = 1;', 'w->g_5839a9 = 0;\n        o->ring_17a = 0;'),
    ('entry global 5d1683 not cleared', '        w->g_5d16cd = 0;\n        w->g_5d1683 = 0;\n        w->g_5d1639 = 0;\n    }\n    o->clip_246 = -1;', '        w->g_5d16cd = 0;\n        w->g_5d1639 = 0;\n    }\n    o->clip_246 = -1;'),
    ('pending_25a kept at init', '    o->movie.pending_25a = 0;\n    if (name_equal', '    if (name_equal'),
    ('single entry draws a random number', 'if (set->entry_count == 1) {', 'if (set->entry_count == 0) {'),
    ('random set name prefix compare', 'name_equal(set->name, RANDOM_SET_NAME)', 'strncmp(set->name, RANDOM_SET_NAME, 3) == 0'),
    ('random set name case sensitive', 'name_equal(set->name, RANDOM_SET_NAME)', '(strcmp(set->name, RANDOM_SET_NAME) == 0)'),
    ('lookup takes the last match', 'for (int i = 0; i < set->entry_count; ++i) {\n        if (name_equal(name, set->entries[i].name)) {', 'for (int i = set->entry_count - 1; i >= 0; --i) {\n        if (name_equal(name, set->entries[i].name)) {'),
    ('lookup case sensitive', 'if (name_equal(name, set->entries[i].name)) {', 'if (strcmp(name, set->entries[i].name) == 0) {'),
    ('file variant order swapped', 'args.a = variant;\n        args.name = entry->name;', 'args.a = variant ^ 1;\n        args.name = entry->name;'),
    ('file kind swapped', 'kind = variant < 2 ? 1 : 0;', 'kind = variant < 2 ? 0 : 1;'),
    ('kind not reset before probes', '    o->kind_21a = -1;\n    for (int variant', '    for (int variant'),
    ('stream reset missing', '    TRY(simple_op(h, D2_OP_STREAM_RESET, 0, why));\n', ''),
    ('surface height check dropped', 'if (sw != width || sh != height) {', 'if (sw != width) {'),
    ('surface width without the plus one', 'return (int32_t)((uint32_t)hi - (uint32_t)lo + 1u);', 'return (int32_t)((uint32_t)hi - (uint32_t)lo);'),
    ('z register missing for avf', '        TRY(simple_op(h, D2_OP_Z_REGISTER, 0, why));\n', ''),
    ('thread create failure continues', '            if (o->thread_1d6 == 0) {\n                return D2_OK;\n            }\n', ''),
    ('first frame from the last frame word', 'o->frame_1ca = entry->word_21;\n        o->ready_1d4 = 0;', 'o->frame_1ca = entry->word_23;\n        o->ready_1d4 = 0;'),
    ('bink prepare count without plus one', '(int32_t)entry->word_21 + 1, &ret', '(int32_t)entry->word_21, &ret'),
    ('bink open failure inverted', '        if (ret != 0) {\n            return D2_OK;\n        }\n        TRY(value_op(h, D2_OP_BINK_PREPARE', '        if (ret == 0) {\n            return D2_OK;\n        }\n        TRY(value_op(h, D2_OP_BINK_PREPARE'),
    ('frame 232 not reset after load', '    o->frame_232 = -1;\n    *loaded = 1;', '    *loaded = 1;'),
    ('rects view x sign', '(uint32_t)g->dst[0] + (uint32_t)w->view_x', '(uint32_t)g->dst[0] - (uint32_t)w->view_x'),
    ('rects y from view x', 'o->rects[5] = (int32_t)((uint32_t)g->dst[1] + (uint32_t)w->view_y);', 'o->rects[5] = (int32_t)((uint32_t)g->dst[1] + (uint32_t)w->view_x);'),
    ('frame clamp off by one', 'if (o->frame_1ca > o->set->entries[o->clip_246].word_23) {', 'if (o->frame_1ca > o->set->entries[o->clip_246].word_23 + 1) {'),
    ('frame clamp unsigned', 'if (o->frame_1ca > o->set->entries[o->clip_246].word_23) {', 'if ((uint16_t)o->frame_1ca > (uint16_t)o->set->entries[o->clip_246].word_23) {'),
    ('frame advance by two', '(int16_t)(uint16_t)(o->frame_1ca + 1)', '(int16_t)(uint16_t)(o->frame_1ca + 2)'),
    ('frame copy ring and single swapped', 'o->ring_17a == 0 ? -1 : (int32_t)o->buffer_192', 'o->ring_17a != 0 ? -1 : (int32_t)o->buffer_192'),
    ('avf state 4 skipped', '            o->state_1da = 4;\n        }\n    } else if (o->state_1da == 4) {', '            o->state_1da = 0;\n        }\n    } else if (o->state_1da == 4) {'),
    ('avf deadline compare signed', 'if (now < o->deadline_1c6) {', 'if ((int32_t)now < (int32_t)o->deadline_1c6) {'),
    ('wait deadline compare signed', 'if (now >= o->deadline_24e) {', 'if ((int32_t)now >= (int32_t)o->deadline_24e) {'),
    ('wait deadline strict', 'if (now >= o->deadline_24e) {', 'if (now > o->deadline_24e) {'),
    ('first avf deadline without period', 'advance_frame(o);\n            TRY(tick(h, &now, why));\n            o->deadline_1c6 = now + o->period_24;', 'advance_frame(o);\n            TRY(tick(h, &now, why));\n            o->deadline_1c6 = now;'),
    ('ready kept when last frame not reached', '            if (o->flag_20e == 0) {\n                o->ready_1d4 = 0;\n            }\n            o->state_1da = 4;', '            o->state_1da = 4;'),
    ('weight range edge inclusive', 'if (r >= lo && r < hi) {\n            *out = -1;', 'if (r >= lo && r <= hi) {\n            *out = -1;'),
    ('negative record weight counted', 'if (w <= 0) {\n            continue;', 'if (w == 0) {\n            continue;'),
    ('delay span off by one', 'TRY(rand_mod(h, span, &r, why));', 'TRY(rand_mod(h, span + 1, &r, why));'),
    ('bink state 4 end test', 'if (ret == 0 || o->frame_232 == entry->word_23) {', 'if (ret == 0 && o->frame_232 == entry->word_23) {'),
    ('avf flag 20a not set', '            o->flag_20a = 1;\n            set_rects(o, w);\n            advance_frame(o);', '            set_rects(o, w);\n            advance_frame(o);'),
    ('phase 1 globals test inverted', 'if (set->mode_word != 1) {\n        w->g_5839a9 = 1;', 'if (set->mode_word == 1) {\n        w->g_5839a9 = 1;'),
    ('stream state 4 left at 2', '        o->stream_state_4 = 0;\n', ''),
    ('thread handle kept after delete', '        o->thread_1d6 = 0;\n        TRY(simple_op(h, D2_OP_STREAM_RELEASE, 0, why));', '        TRY(simple_op(h, D2_OP_STREAM_RELEASE, 0, why));'),
    ('phase 1 entry flag not cleared', '    w->entry_flag = 0;\n    o->group_hit_236 = 0;', '    o->group_hit_236 = 0;'),
    ('stay weight not in the total', '    total = entry->weight;', '    total = 0;'),
    ('delay compare strict', 'if (entry->delay_min >= entry->delay_max) {', 'if (entry->delay_min > entry->delay_max) {'),
    ('stay does not mark pending', '            o->movie.pending_25a = 1;\n', ''),
    ('teardown skips z unregister B', '    TRY(simple_op(h, D2_OP_Z_UNREGISTER_B, 0, why));\n', ''),
    ('stop leaves saved_202', '    w->g_5839a9 = o->saved_202;\n', ''),
    ('stop leaves 4d36ed globals', '    w->g_5831c8 = 1; /* 0x4d36ed */\n    w->g_5831c6 = 0;\n    status = d2_destruct', '    status = d2_destruct'),
    ('destruct skips the reset', '    d2_object_reset(o);\n    if (erased_row != NULL) {', '    if (erased_row != NULL) {'),
    ('reset single buffer flag', '    o->ring_17a = 1;\n    o->kind_17e = 0;', '    o->ring_17a = 0;\n    o->kind_17e = 0;'),
    ('register label typo', '#define ENTRY_LABEL "RAMDOM MOVIE"', '#define ENTRY_LABEL "RANDOM MOVIE"'),
    ('register type', 'w->entry_type = 0xb;', 'w->entry_type = 0xc;'),
    ('render valid when inactive', 'if (o->movie.active == 0 || o->movie.flag_206 == 0) {', 'if (o->movie.active == 0 && o->movie.flag_206 == 0) {'),
    ('buffer index not cleared at init', '    o->buffer_192 = 0;\n    w->start_flag = 1;', '    w->start_flag = 1;'),
    ('group scan keeps the last match', '            o->group_24a = o->scan_22e;\n            break;', '            o->group_24a = o->scan_22e;'),
    ('bink more test inverted', '            if (ret != 0 && o->frame_232 != entry->word_23) {', '            if (ret == 0 && o->frame_232 != entry->word_23) {'),
    ('bink frame minus one dropped', 'o->frame_232 = (int32_t)((uint32_t)frame - 1u);', 'o->frame_232 = (int32_t)((uint32_t)frame);'),
    ('phase 2 retires nothing', 'local.retire_row = arg == -1 ? D2_NO_ROW : arg;', 'local.retire_row = D2_NO_ROW; (void)arg;'),
    ('record index off by one', 'o->clip_246 = lookup_entry(set, entry->records[pick].name);', 'o->clip_246 = lookup_entry(set, entry->records[pick > 0 ? pick - 1 : pick].name);'),
]


def mutation_check(args, workdir, quick_scs=None):
    src_dir = Path(args.src)
    source = (src_dir / C_).read_text()
    jobs = []
    for n, (name, old, new) in enumerate(MUT):
        if source.count(old) != 1:
            jobs.append((n, name, None))
        else:
            jobs.append((n, name, source.replace(old, new)))

    def work(job):
        n, name, text = job
        if text is None:
            return dict(mutant=name, detected=None, how='mutation anchor drifted')
        d = Path(workdir) / ('mut%d' % n)
        d.mkdir(parents=True, exist_ok=True)
        for item in src_dir.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / C_).write_text(text)
        try:
            lib_path = build_driver(d, d / 'libmut.so')
        except d9.OracleError as error:
            return dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:160])
        done = subprocess.run([sys.executable, '-I', str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run'],
                              capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else ('crash signal %d' % -done.returncode if done.returncode < 0 else
                                                       'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:]))
        return dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how, first=first[6:][:200] if first else None)

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        return list(pool.map(work, jobs))


# ---------------------------------------------------------------------------------------------
def load_corpus():
    """The three raw-0x2d typed bodies of the decoded scene resources (from the pinned A-2D.1 corpus)."""
    corpus_path = PRIVATE / 'A-2D.1.corpus.json'
    if not corpus_path.exists():
        return None, None
    corpus = json.loads(corpus_path.read_bytes())
    bodies = []
    for row in corpus['records']:
        data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % row['resource_index'])).read_bytes()
        p, n = row['act_payload_offset'], row['act_payload_length']
        body = data[p + 50:p + n]
        if sha(body[:row['typed_body_length']]) != row['typed_body_sha256']:
            raise d9.OracleError('corpus body hash mismatch')
        bodies.append(body[:row['typed_body_length']])
    return bodies, sha(corpus_path.read_bytes())


def x_hooks(x):
    return [0x50CD50, 0x50CD72, 0x449D90, 0x44C479, 0x449A94, DTOR, 0x44C4AB, 0x415011, 0x41632B, 0x4BEDFA, 0x4C2DFB, 0x44C4C1, 0x4C2A8D, 0x4161D1, 0x4497A0,
            0x449BFF, 0x4BEF11, 0x4BF19A, 0x4BEF85, 0x4BEFC8, 0x4BF098, 0x4BEE2C, 0x4BF10F, 0x51DC6C, 0x423B51, 0x4C5377, *LOG_POPS, 0x44A2B7, 0x52139C, FATAL]


def discover_pins(x, blocks):
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
    return [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]


# Executed original code windows (function spans entered during the whole scenario set, SHA-256 of the unmodified image bytes);
# regenerate with --discover-pins. Windows whose entry is a hook address were entered but replaced (see the hook inventory).
PINS = (
    (0x415011,0x4150af,'6de131ad15d21cb08a1d54ce5c027579ddc63760cb9a13452646ac2ae4708b66'),
    (0x4161d1,0x41632b,'9b1dc6ed8fb242f085b8bcbd693dbcaf5c70425e7cab3adc9b92ece2203a55eb'),
    (0x41632b,0x4163b4,'bfae2ec37823ceff388af32a715b28491b58964704c64f4f3359c664eab127bf'),
    (0x4234c8,0x4234dd,'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7,0x423876,'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423b51,0x423c2b,'918a1b51e6a925839988b64f0ffc7c30a9fdff1053d35bfb65375dbbccd04a3a'),
    (0x423f57,0x423fbb,'5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d,0x424201,'9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201,0x424346,'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346,0x424aa8,'5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8,0x425b8b,'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x42639d,0x426428,'9acdc84d64bfb67bde207af9695523f701cc7668503ec29fa5bfb25f4f978bee'),
    (0x4264e8,0x426510,'47f26bb38bcb1e8beb39a57f94d227e5488835c80a5f1091221b5107e26ef858'),
    (0x427a50,0x42acad,'1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x4497a0,0x449a78,'93bbc611d8ae76a24de81d370be047ef43729ad73acb209c2284cb1aebf94586'),
    (0x449a94,0x449ba5,'720b11933709f732ac47abd039c5a915bfaf66ae6ce5a9d33cdefba8cab57d1f'),
    (0x449bff,0x449cfc,'c27f5aa0b42dfbc2f8981e50b6e9e1e2e604177d0c0a3805bad9e32774e0846c'),
    (0x449d90,0x449dc7,'c3ca6145390d9b2e1bc85660c49dc80a1485edf7e6d20b9cdff486f90057c172'),
    (0x44c479,0x44c4ab,'54c215e74ea4051a44fbcde7dd6a5d1412ae20c4c8a2d0a2d814175ddbd3d377'),
    (0x44c4ab,0x44c4c1,'20a525f4e4af04f5ad5548f1023fd4864472cabd7bcccc9fecae0b90781c0b93'),
    (0x44c4c1,0x44c9db,'8dd6a87ff43cc31725db8afa3dfd0c7740e39e6b738b109f71072a9cd21911e7'),
    (0x4bedfa,0x4bee2c,'5ee753ee08507e261aab21741a4d0dc9706c6d515c236b8c63a3185374072b97'),
    (0x4bee2c,0x4bee5f,'686c4c9ff3b6a40b1eeb3f2134afc9ca9657f6a4da3f7f4d63f95759f39972df'),
    (0x4bef11,0x4bef85,'e9ce0dd56561605180e985e9637699c5ab7649490b7c968e103fdfd3570c35af'),
    (0x4bef85,0x4befc8,'69fa0a5113f4db405b458b2d2555b0f01ac768ce9f23535b1d843d2b47897902'),
    (0x4befc8,0x4bf024,'59a12f309ea0a419703659113e52ab7218197e292bba55a7ae5675dc04a8b197'),
    (0x4bf098,0x4bf10f,'db2f5edd3e354c69850cfe30777772fc75860402a1608fc2e81e879b495d2c9e'),
    (0x4bf10f,0x4bf19a,'8ff4f95ff0aa5b703b2f812bf1ed8bed592c7ff1d2b1b452ef73e2d8440182e5'),
    (0x4bf19a,0x4bf1f0,'e1d4bfba556921a1e9049bde018e652cb61afacfd2645daca3542d28abe35246'),
    (0x4bf3b8,0x4bf542,'182bb311e03683957985487dc8aae9dc281c321bed51f099c3e901f4c00f7fe1'),
    (0x4c2a8d,0x4c2c3a,'9e30a70ee2613a1ea7fb608e88a98b56478e5c3e71814992f28c9609cc451f75'),
    (0x4c2dfb,0x4c2e5b,'6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377,0x4c558b,'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
    (0x4c97b4,0x4c9805,'3a3ce61456f41f3d52d744f0aa4870e4caadc0b704ac034e03916ad30717edc2'),
    (0x4ccd70,0x4ccd8f,'dcd7315a2881ed560167442793bce884fb1ed75ca93b4c91f2e9f64e241aa1c0'),
    (0x4ccdab,0x4ccef1,'521ba5342dad32f5ee803b35f61eb0e31887ceece3f254c8babce08117e6f87c'),
    (0x4ccef1,0x4ccfbd,'de58e87a8abad8aaadf9480d8e594a0b88fdf356732b5c869f022986f9aece38'),
    (0x4ccfbd,0x4ccff5,'543981467bbf45c36eeed21dcef5ce3d2972f4a7cc01714fdee0c5dd259b421d'),
    (0x4ccff5,0x4cd218,'d13fc6618bc3d11776da086eb8beff6fb9dd861eee513d084bb60a5cc237d822'),
    (0x4cd218,0x4cd243,'2a454b2c769dca755e240756b10fc0bfc3bc78ffaf0baa8983e3492d1ce1cd28'),
    (0x4cd243,0x4cd645,'5b186c92f48dc216b08e6bab3d683b068f4662942bf6f94f956acd4faa4659a3'),
    (0x4cd6ff,0x4cdfd3,'bdca476b91db9275c96c89775550a1cfaea685fec114b5a215e1f82cab7e0eb5'),
    (0x4cdfd3,0x4ce602,'b1030236e3d5715d75aec2f7b8acdd13dbe1ae948d70ef9330b86f2e8e9729bc'),
    (0x4ce602,0x4ce8ea,'95c0617d94a8a943c638a47d0ef461588ba78f53025b946a212cefd46af7d595'),
    (0x4ce8ea,0x4ceb3b,'6a37c4f21041be9ea11ddeedd55c1f838c622fad3abafe1d90d6b97f2f43854f'),
    (0x4ceb3b,0x4ceb8c,'61578011ce5d01057cb728224926c06f146d69407b1def650e38302be816810d'),
    (0x4ceb8c,0x4cec6c,'44fb80510d553e1cdf123f23cd3233c79932517869fc7315240aaf9df249673b'),
    (0x4cec6c,0x4cecf7,'5c0551332384f5bce6d1ff1a9dfe1968838cd4e035c9882992de01d5c1e2f0f1'),
    (0x4cecf7,0x4ced84,'b2b82d05059a88e23039b767feeeba68b8bf8152bc7cab071edccbc0a9adf967'),
    (0x4cf026,0x4cf0a9,'653b928813ebf80a73c13a45d6ff97a25d178043dbfb68b176d2b57ac70c4432'),
    (0x4cf0a9,0x4cf0ce,'24e8dbe00ba45e3995fd8436054035a3361119567e4c5db158a97143a51c9c84'),
    (0x4cf0ce,0x4cf1e4,'42d02963e7e2830193850153918c34944c9fd457de189c2cbc03e9421af04fbd'),
    (0x4cf1e4,0x4cf276,'57fc0c8e764630811d7505589b50b6507a779ee276fd3909722ded614a7be88e'),
    (0x4cf749,0x4cf7b0,'de82b5cb76c5bd070efe84d0bcb81a9236019b257b6d6949351f37a5f5c72108'),
    (0x4d36ed,0x4d3705,'9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd'),
    (0x50ca3e,0x50ca90,'e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73'),
    (0x50cd50,0x50cd72,'0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477'),
    (0x50cd72,0x50ce04,'ae6f88ecc30d1b283ff1d35a00a365dae2c0b41a77a24d116bee97fc5753e294'),
    (0x516530,0x516600,'e6af09f84ddc920c21c56a52ba89bb6f2b2f43bf0db2a874f605dfdb9ca98a65'),
    (0x51dc43,0x51dc6c,'8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c,0x51dc77,'8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=8)
    ap.add_argument('--mutations', action='store_true')
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--random', type=int, default=420)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--mutation-run', action='store_true')
    ap.add_argument('--coverage', action='store_true')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-36.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver2d.so')
    nat = Native(lib_path)
    x = Oracle()
    corpus, corpus_hash = load_corpus()
    scs = build_scenarios(corpus, count_random=args.random)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only or args.mutation_run:
        scs = [s for s in scs if s['quick']]
    blocks = set()
    if args.discover_pins or args.coverage:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    st = new_stats()
    bad = run_list(x, nat, scs, st, fail_fast=args.fail_fast or args.mutation_run)
    if args.mutation_run:
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    if not args.only:
        malformed_run(nat, corpus or [], st)
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:500])
    pins = []
    if args.coverage:
        covered = set()
        for a, sz in blocks:
            covered.update(range(a, a + sz))
        report = []
        for ln in open('/tmp/claude-0/dis/all.txt'):
            t = ln.split(':', 1)
            if len(t) == 2 and t[0].strip().startswith('4c') and CODE_LO <= int(t[0], 16) < CODE_HI and int(t[0], 16) not in covered:
                report.append(t[0].strip() + t[1].strip()[:30])
        print('UNCOVERED %d instructions' % len(report))
        print('\n'.join(report))
    if args.discover_pins:
        pins = discover_pins(x, blocks)
        print('PINS = (' + ','.join('(%#x,%#x,%r)' % t for t in pins) + ',)')
    st['groups'] = {g: dict(v) for g, v in st['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in st.items()}
    summary['scenarios_total'] = len(scs)
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:110])
    if args.result:
        hooked = set(x_hooks(x))
        code = [dict(start=hex(a), end=hex(z), sha256=h, replaced=a in hooked) for a, z, h in (pins or list(PINS))]
        window = sha(x.pristine[CODE_LO - 0x400000:CODE_HI - 0x400000])
        args.result.write_text(json.dumps(dict(
            slice='RT-36', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
            mutants_total=len(mutations) if mutations else 0, mutants_killed=sum(1 for m in (mutations or []) if m['detected']),
            hooks=dict(replaced=[hex(a) for a in x_hooks(x)], observed=[hex(HANDLER), hex(ARM)] + [hex(a) for a in FRAME_COPIES], imports=['GetTickCount']),
            kernel_fixes=['name_equal: 0x516530 is _stricmp (ASCII case-insensitive), the kernel used strcmp (header name vs RandomMovie, entry/record lookup)'],
            expected_differences=dict(E1='zero divisor: original faults at idiv 0x4cf0c3, native D2_ERR_BODY', E2='d2_destruct does not clear 0x5d1a45 (original reset 0x4ccdab does)'), code_windows=code, object_code_window=dict(
                start=hex(CODE_LO), end=hex(CODE_HI), sha256=window),
            source_sha256=sha((args.src / C_).read_bytes()), header_sha256=sha((args.src / 'action_family_2d_runtime.h').read_bytes()),
            native_library_sha256=sha(Path(lib_path).read_bytes()), oracle_sha256=sha(Path(__file__).read_bytes()),
            driver_sha256=sha((PROJECT / 'tests/action_family_2d_runtime_oracle_driver.c').read_bytes()), corpus_sha256=corpus_hash,
            seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
