#!/usr/bin/env python3
"""RT-57: immutable x86 dispatcher 0x427a50 (arm 0x427cc1/0x427cc3, gate 0x423f57 mode 1), handler 0x4cb586 on the CInteractiveVideo
singleton 0x63847b (phases 0 / 1 / 2, the ".IV" loader 0x4cbba9, the entry search 0x4cb944, the origin shift 0x4cb9d1, the free
0x4cbb00, the object reset 0x4caf03 / 0x4caf8a), the generic completion 0x42ba3a, the generic z entry allocator 0x4d39f9 / releaser
0x4d3992 (original code on the table at 0x5d1591) and the z entry render callback 0x4cc79a (raw type 0x1c) versus the native kernel
src/action_family_1c_runtime.c behind src/session_bindings_a1c.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x1c (and 0x67 as the plain "neighbouring row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57, the arm, the handler with every phase,
all the inner methods above and, after a phase 2 visit, the generic completion 0x42ba3a (completion byte by subtype, dependency reset
0x423d33, phase store). The movie player's getters 0x4c0c18 (clip name pointer +0x22a), 0x4c0c2c (state +0x240), 0x4c0c54 (hotspot
word +0x244) and 0x4c0c69 (origin object pointer +0x24a) run as ORIGINAL code over a scripted player image at 0x637fcf; the origin object
holds the dwords +0x12 / +0x16. The render callback 0x4cc79a runs as original code with the rectangle fill 0x4c7623 recorded.

Native side: tests/action_family_1c_runtime_oracle_driver.c links the real session binding (session_bindings_a1c.c), the kernel, the
decoder and the action core, and implements the HOST side of C1cHost with scripted values: the player (state, name, hotspot, origin), a
store of ".IV" files, the word cell [0x583a29] and a model of the z entry table with the original's allocator rule. a1co_visit() maps the
binding's disposition to the row's completion byte, dependency reset and phase exactly as scene_executor.c apply_external_handler does
(PENDING: phase; COMPLETED: action_core_finish_action(subtype, completed_before) + the handler's phase).

Compared after EVERY dispatcher call (tick) and every render:
 * which rows entered the arm 0x427cc1 and the handler 0x4cb586 (with the phase the handler read) against the rows still open behind
   an open gate (a model of the event flag dependency records and the world mode word), and that the 0x67 neighbour rows ran;
 * the completion byte and the phase dword of EVERY row (and the request dword and the unlisted bytes of the row: nothing else changes),
   the observed generic completions 0x42ba3a and dependency resets 0x423d33 against the native executor mapping;
 * the persistent object fields (+8 changed, +0xc z slot, +0xe armed, +0x12 current entry as an index into the loaded table, +0x16 body
   pointer as the body bytes, +0x1a loaded file, +0x14a last index, +0x14e, +0x152 word, +0x154, +0x158, +0x15c origin pointer present)
   against C1cObject, bit for bit; the scratch bytes the original uses (+0x1e..+0x14a) get garbage at the start and are not compared;
 * the loaded table by walking the original's pointers (33-byte name, entry count, every 13-byte entry {id, count, byte, word, word,
   rectangle pointer}, every rectangle's six dwords) against C1cIv after every tick, so the in-place origin shift is checked each time;
 * the whole z entry table (0x58 entries of 0x4a bytes, garbage seeds) byte for byte against the driver's model, which the kernel drives
   through alloc_slot / register_slot / release_slot (the original allocator and releaser run as original code);
 * the ordered host-call sequence: the original's player getter calls, fopen (store index of the file), every fread (size, bytes
   returned; the loader's one fread of count * 24 rectangle bytes is split into the kernel's 24-byte reads), fclose, the allocation
   result of 0x4d39f9, the registration (after the field stores), the release, the read of the word cell [0x583a29] against the
   kernel's host calls, entry for entry;
 * heap discipline: every free of the original is an allocation of the loader and the live allocations after every tick are exactly the
   file's tables (iv, entries, rectangle arrays), in the original free order (rectangles in entry order, entries, iv);
 * every store of the original to the process data region (.data) is observed; a store outside the object, the rows, the z table and
   the start flag (apart from the gate's pinned scratch) fails the run;
 * the render callback: the list of fills (this, surface, rectangle in screen coordinates after the view origin, 16-bit color, in
   order) against C1cFill, and that the changed flag is cleared; render without a change draws nothing.

HOOKS (everything else is original code): O = observed, R = replaced.
  O arm 0x427cc1 (row at [ebp-0x11c]), handler 0x4cb586 (row word, phase), 0x42ba3a, 0x423d33, the four getters, 0x4cb695 (alloc result),
    0x4cb73b (registration), 0x4cb76f (word cell), 0x4d3992 (release)
  R CRT 0x50d0a9 fopen ("rb" and the path that 0x50cd72 produced), 0x50cf61 fread (returns the element count only when size * count is
    nonzero and that many bytes remain, as the CRT does), 0x50cee4 fclose, 0x50cd72 sprintf (the stand-in writes the file name only; the
    arguments are checked: format cell 0x639dae / 0x639da2 by [0x5bb1fa], directory 0x639db1, the body's name pointer, ".IV"),
    0x51dc43 malloc (bump arena; sizes above 0x7fffffe0 or the arena fail with NULL like the CRT), 0x51dc6c free, 0x4c7623 fill
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7 0x4264e8: fatal and logging paths; the refusal scenarios expect the message 0x50ca3e /
    0x52139c and classify the call site, every other scenario fails the run when one is reached
 Windows imports are stubbed as in the 0xd9 oracle. The debug flag 0x63a4cd is 0 (the native module models the flag as 0).

NATIVE-ONLY REFUSALS (checked natively, never silently skipped; the original prints a message, posts a quit message and goes on with a broken
object, or runs away): empty name, unterminated name, failed open, short read at every field, entry count outside 0..4096, rectangle
count 0 / negative / above 4096, no free z entry, host failures. The oracle runs the original on each file variant to prove it reaches
the same message (classified by call site) and that the kernel refuses, keeps nothing loaded and closes the file.

Not modelled / unverified: the real movie player (the getters are driven over a scripted image), the file system and the CRT file
buffering, the sprintf formats and the directory string, the rectangle fill 0x4c7623 and the surface, the z entry drawer that calls the
render callback, the scene loader 0x40b34a / 0x4caff5 that builds the rows (the oracle builds them in memory), the other methods of the
object (0x4cb058 pointer, 0x4cb3ab, 0x4cafc1, 0x4caf8a as a scene-clear caller), the debug-flag-set paths, and the real .IV files (not
in the cloud: the oracle generates files).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_1c_runtime_original_oracle.py --quick-only
  python3 action_family_1c_runtime_original_oracle.py --workers 4 --result ../../../work/rt57/RT-57.1c.oracle-result.json
  python3 action_family_1c_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32
M32 = 0xFFFFFFFF

ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
TYPE_OFF, SUBTYPE_OFF, BODY_OFF = 0x30, 0x31, 0x32
DEP_LO, DEP_HI = 0x36, 0x72            # the dependency record (gate and reset own it)
MAX_ROWS = 40
BODY_STRIDE = 0x100
BODY_BYTES = 105

OBJ, OBJ_LEN = 0x63847B, 0x160
PLAYER, PLAYER_LEN = 0x637FCF, OBJ - 0x637FCF
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
NAME_AT = d9.BODY_BASE + 0xE000
ORIGIN_AT = d9.BODY_BASE + 0xE200
NAME_BYTES = 33
FILE_HANDLE = 0x7F100000
FLAG_1FA = 0x5BB1FA
START_FLAG = d9.START_FLAG
CELL_583A29 = 0x583A29
VIEW_X, VIEW_Y, SURFACE_CELL = 0x583186, 0x58318A, 0x5CF665
FILL, FILL_THIS = 0x4C7623, 0x5CF659
DATA_LO, DATA_HI = 0x537000, 0x63F000
SCRATCH_LO, SCRATCH_HI = 0x1E, 0x14A   # garbage region of the object (the original's temporaries and the path buffer)

ARM_1C, HANDLER = 0x427CC1, 0x4CB586
ARM_67, VISIT_67 = 0x428692, 0x4286B5
GETTERS = {0x4C0C2C: 1, 0x4C0C18: 2, 0x4C0C54: 3, 0x4C0C69: 4}
EV_STATE, EV_NAME, EV_HOTSPOT, EV_ORIGIN, EV_OPEN, EV_READ, EV_CLOSE, EV_ALLOC, EV_REGISTER, EV_RELEASE, EV_CELL = range(1, 12)
EV_RECT_RUN = 16
EVN = {1: 'state', 2: 'name', 3: 'hotspot', 4: 'origin', 5: 'open', 6: 'read', 7: 'close', 8: 'alloc', 9: 'register', 10: 'release',
       11: 'cell', 16: 'rectrun'}
RECT_READ_RET = 0x4CBECA               # return address of the loader's rectangle fread
FATAL_SITES = {0x4CBBE8: 'empty-name', 0x4CBC8B: 'open', 0x4CBD01: 'header', 0x4CBE6D: 'entry', 0x4CBEF2: 'rects',
               0x4CC745: 'alloc', 0x4D3A40: 'z-full'}
EXPECTED_OTHER_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

C1C_LABEL = b'INTERACTIVE VIDEO DIAGS'

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
    (0x4c0c18, 0x4c0c2c, '943b3dc801809ae2575daa065bff97f3f22d307f3bf8fb64c6dfa2c0f5c3bf27'),
    (0x4c0c2c, 0x4c0c40, '243bcfb16cdd309fad82a5b536800535ccb63fda3ad65ed829e16d8ed8dd0d5f'),
    (0x4c0c54, 0x4c0c69, '39ce18c9c72a1fc9d0abc69c1e31af56dfe458837e6f949505fd5c30450e867b'),
    (0x4c0c69, 0x4c0c7d, '2d01ffd9fae4e24d8e0992c6d99d46535dba02a16768ce5c96588e6913834838'),
    (0x4c7623, 0x4c7770, '66033d073d90ecf2ce92fdffa33eae3c9e2c461165de31c20e691c8c4897b11f'),
    (0x4caf03, 0x4caf8a, 'da7c5a1a9b60e66942a4da5ec532edbbe9196f4b15895f6e625629d6e9ecbc26'),
    (0x4caf8a, 0x4cafc1, '932329bb7205664a814efa0db5de25d22f1322d8eca64228f8bf7514091ddc44'),
    (0x4cb586, 0x4cb8d5, '91e675c3a72629218d9b961ae84b177a59581568d0f19b4e52b8f4110288ab76'),
    (0x4cb944, 0x4cb9d1, 'c7c697d90d471e234f475b8f4279143d00c8fbbe5c0528349d3067ba2278e589'),
    (0x4cb9d1, 0x4cbb00, '64cd145431893efa99e7edc6f888b35762c57286d5d9f795e6419be5727449fa'),
    (0x4cbb00, 0x4cbba9, '14caf0364b2924de7b54714f890e2d2c1821ef40da880fc35fe6d602bc55a4b0'),
    (0x4cbba9, 0x4cbf72, '43560a4a3b0918e72ad68874b74f2341659055c4e94a18a376ba2df825f43a56'),
    (0x4cc70f, 0x4cc79a, 'f4b42b91311bbc621df2b790920c1bf9ebb32fa1d90b45d9dfe4872e6af88100'),
    (0x4cc79a, 0x4cc880, 'c3866b524bd9894e9251433aa6ada2e8697140728d8e8f88cd6a34cdabdcceef'),
    (0x4d3992, 0x4d39f9, 'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
    (0x4d39f9, 0x4d3a52, '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
    (0x50ca3e, 0x50ca90, 'e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73'),
    (0x50cd72, 0x50ce04, 'ae6f88ecc30d1b283ff1d35a00a365dae2c0b41a77a24d116bee97fc5753e294'),
    (0x50cee4, 0x50cf15, '74b05488da3454a55ad584855019c17f66a638720786e4de8e6bfb76eee07fa5'),
    (0x50cf61, 0x50cf90, '3a65f967babaf3e248f16a586004e6d0459defd6e2d39c5e4ef0b19afa2efa07'),
    (0x50d0a9, 0x50d0bc, '009e28bec388b5a3a6c6dd7d876ea8e0b3273502f59125715f63c1dd258be5b6'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
    (0x52139c, 0x5213d4, '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)


class Mismatch(Exception):
    pass


def s16(v):
    v &= 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= M32
    return v - (1 << 32) if v & 0x80000000 else v


# ---------------------------------------------------------------------------------------------
# original side
# ---------------------------------------------------------------------------------------------
class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw-0x1c hooks."""

    def __init__(self):
        self.ev, self.arms, self.handlers, self.finishes, self.resets, self.fills = [], [], [], [], [], []
        self.files, self.streams, self.live, self.freed_log = [], {}, {}, []
        self.other_writes, self.sprintf_calls = Counter(), []
        self.fatal_site = None
        self.write_watch = False
        self.body_of_row = {}
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, digest))

    # -- hooks ---------------------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        table = {
            ARM_1C: self._arm, HANDLER: self._handler, 0x42BA3A: self._finish, 0x423D33: self._reset_seen,
            0x4CB695: self._after_alloc, 0x4CB73B: self._register, 0x4CB76F: self._cell, 0x4D3992: self._release,
            0x50D0A9: self._fopen, 0x50CF61: self._fread, 0x50CEE4: self._fclose, 0x50CD72: self._sprintf,
            0x51DC6C: self._free, FILL: self._fill,
        }
        for a in GETTERS:
            table[a] = self._getter
        for a in d9.GUARDS + [0x4264E8]:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_LO, end=DATA_HI)

    def _raise(self, uc, address, size, user):
        if address == self.expect_fatal:
            self.fatal_site = u32(uc, uc.reg_read(X.UC_X86_REG_ESP))
            raise d9.Fatal(address)
        raise d9.OracleError('guarded original routine %#x reached from %#x' % (address, u32(uc, uc.reg_read(X.UC_X86_REG_ESP))))

    def _on_write(self, uc, access, address, size, value, user):
        if not self.write_watch:
            return
        end = address + size
        if OBJ <= address and end <= OBJ + OBJ_LEN:
            return
        if ROWS <= address and end <= ROWS + MAX_ROWS * ROW:
            return
        if ENTRY <= address and end <= ENTRY + NENT * STRIDE:
            return
        if address == START_FLAG and size == 4:
            return
        self.other_writes['%#x/%d' % (address, size)] += 1

    def _row_at_arm(self, uc):
        return struct.unpack('<h', bytes(uc.mem_read(uc.reg_read(X.UC_X86_REG_EBP) - 0x11C, 2)))[0]

    def _arm(self, uc, address, size, user):
        self.arms.append(self._row_at_arm(uc))

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise d9.OracleError('handler entered with ECX != 0x63847b')
        self.handlers.append((row, u32(uc, ROWS + row * ROW + PHASE_OFF)))

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finishes.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _getter(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != PLAYER:
            raise d9.OracleError('player getter %#x with ECX != 0x637fcf' % address)
        self.ev.append((GETTERS[address], 0, 0))

    def _after_alloc(self, uc, address, size, user):
        self.ev.append((EV_ALLOC, s16(uc.reg_read(X.UC_X86_REG_EAX)), 0))

    def _register(self, uc, address, size, user):
        self.ev.append((EV_REGISTER, s16(self.rd16(OBJ + 0xC)), 0))

    def _cell(self, uc, address, size, user):
        self.ev.append((EV_CELL, 0, 0))

    def _release(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.ev.append((EV_RELEASE, struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

    def rd16(self, a):
        return struct.unpack('<H', self.rd(a, 2))[0]

    def rdu32(self, a):
        return struct.unpack('<I', self.rd(a, 4))[0]

    def cstring(self, a, limit=4096):
        out = bytearray()
        while len(out) < limit:
            b = self.rd(a + len(out), 1)[0]
            if b == 0:
                return bytes(out)
            out.append(b)
        raise d9.OracleError('unterminated string')

    def _malloc(self, uc):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        size = u32(uc, sp + 4)
        start = (self.heap_cursor + 15) & ~15
        end = start + max(size, 1) + 16
        if size > 0x7FFFFFE0 or end > d9.HEAP_BASE + d9.HEAP_SIZE:   # the CRT returns NULL there
            self.counters['malloc-null'] += 1
            uc.reg_write(X.UC_X86_REG_EAX, 0)
            self._ret(uc, 0)
            return
        self.heap_cursor = end
        self.heap_high = max(self.heap_high, end)
        self.allocs[start] = size
        self.live[start] = size
        self.counters['malloc'] += 1
        uc.reg_write(X.UC_X86_REG_EAX, start)
        self._ret(uc, 0)

    def _free(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ptr = u32(uc, sp + 4)
        if ptr not in self.live:
            raise d9.OracleError('free of %#x, which is not a live allocation' % ptr)
        del self.live[ptr]
        self.freed_log.append(ptr)
        self._ret(uc, 0)

    def _sprintf(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        dst, fmt, directory, name, suffix = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        flag = self.rdu32(FLAG_1FA)
        want_fmt, want_suffix = (0x639DA2, 0x558C98) if flag else (0x639DAE, 0x558C9C)
        body = self.rdu32(OBJ + 0x16)
        if (fmt, directory, name, suffix) != (want_fmt, 0x639DB1, body, want_suffix) or dst != OBJ + 0x1E:
            raise d9.OracleError('sprintf arguments differ from the packet: %s' % ([hex(v) for v in (dst, fmt, directory, name, suffix)],))
        text = self.cstring(name)
        uc.mem_write(dst, text + b'\0')
        self.sprintf_calls.append(text)
        self._ret(uc, 0, len(text))

    def _fopen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        path, mode = u32(uc, sp + 4), u32(uc, sp + 8)
        if self.cstring(mode) != b'rb':
            raise d9.OracleError('fopen mode is not "rb"')
        if path != OBJ + 0x1E:
            raise d9.OracleError('fopen path is not the object buffer')
        name = self.cstring(path)
        index = next((i for i, (n, _d) in enumerate(self.files) if n == name), -1)
        self.ev.append((EV_OPEN, index, 0))
        if index < 0 or self.streams:
            self._ret(uc, 0, 0)
            return
        handle = FILE_HANDLE + 0x10 * (len(self.ev) & 0xFFF)
        self.streams[handle] = [index, 0]
        self._ret(uc, 0, handle)

    def _fread(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ret, buf, esize, count, handle = [u32(uc, sp + 4 * i) for i in range(5)]
        if handle not in self.streams:
            raise d9.OracleError('fread on a stream that is not open')
        index, pos = self.streams[handle]
        data = self.files[index][1]
        total = esize * count
        if total == 0 or esize == 0:
            self.ev.append((EV_RECT_RUN if ret == RECT_READ_RET else EV_READ, total, 0))
            self._ret(uc, 0, 0)
            return
        avail = max(len(data) - pos, 0)
        got = min(avail, total)
        uc.mem_write(buf, data[pos:pos + got])
        self.streams[handle][1] = pos + got
        self.ev.append((EV_RECT_RUN if ret == RECT_READ_RET else EV_READ, total, got))
        self._ret(uc, 0, got // esize)

    def _fclose(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        handle = u32(uc, sp + 4)
        if handle not in self.streams:
            raise d9.OracleError('fclose of a stream that is not open')
        del self.streams[handle]
        self.ev.append((EV_CLOSE, 0, 0))
        self._ret(uc, 0, 0)

    def _fill(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        surface, rect, color = u32(uc, sp + 4), u32(uc, sp + 8), u32(uc, sp + 12)
        if self.mode != 'render':
            raise d9.OracleError('rectangle fill outside the render run')
        self.fills.append((uc.reg_read(X.UC_X86_REG_ECX), surface, struct.unpack('<4i', self.rd(rect, 16)), color & 0xFFFF))
        self._ret(uc, 0xC)

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
        self.live = {}
        self.frees = []
        self.freed_log = []
        self.mode = 'idle'
        self.write_watch = False
        self.expect_fatal = None
        self.fatal_site = None
        self.files, self.streams = [], {}
        self.other_writes = Counter()
        self.sprintf_calls = []
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_lists()

    def clear_lists(self):
        self.ev, self.arms, self.handlers, self.finishes, self.resets, self.fills = [], [], [], [], [], []
        self.freed_log = []

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
            self.wr(base + TYPE_OFF, bytes([spec['type'], spec['subtype']]) + struct.pack('<I', body_at))
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
        self.clear_lists()
        self.mode = 'step'
        self.write_watch = True
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'
            self.write_watch = False

    def render(self):
        self.clear_lists()
        self.mode = 'render'
        self.write_watch = True
        try:
            self.call(0x4CC79A, [], 0)
        finally:
            self.mode = 'idle'
            self.write_watch = False

    # -- state -------------------------------------------------------------------------------------
    def set_player(self, state, name, hotspot, origin):
        self.w32(PLAYER + 0x240, state)
        self.wr(PLAYER + 0x22A, struct.pack('<I', NAME_AT))
        self.wr(NAME_AT, name + b'\0' + bytes(0x40 - len(name) - 1) if len(name) < 0x3F else name + b'\0')
        self.wr(PLAYER + 0x244, struct.pack('<h', hotspot))
        if origin is None:
            self.wr(PLAYER + 0x24A, bytes(4))
        else:
            self.wr(PLAYER + 0x24A, struct.pack('<I', ORIGIN_AT))
            self.wr(ORIGIN_AT + 0x12, struct.pack('<ii', s32(origin[0]), s32(origin[1])))

    def object(self):
        r = self.rd(OBJ, OBJ_LEN)
        g = lambda off, fmt: struct.unpack_from(fmt, r, off)[0]  # noqa: E731
        return dict(changed=g(8, '<i'), slot=g(0xC, '<h'), armed=g(0xE, '<i'), record=g(0x12, '<I'), body=g(0x16, '<I'),
                    iv=g(0x1A, '<I'), last=g(0x14A, '<i'), d14e=g(0x14E, '<i'), w152=g(0x152, '<h'), d154=g(0x154, '<i'),
                    d158=g(0x158, '<i'), origin=g(0x15C, '<I'))

    def table(self):
        """The loaded file as the native dump list, plus the pointers; None when nothing is loaded."""
        iv = self.rdu32(OBJ + 0x1A)
        if iv == 0:
            return None
        name = self.rd(iv, NAME_BYTES)
        count = struct.unpack('<i', self.rd(iv + 0x21, 4))[0]
        ents = self.rdu32(iv + 0x25)
        out, rect_ptrs = [count], []
        if count < 0 or count > 100000:
            raise d9.OracleError('implausible entry count %d in the original table' % count)
        for i in range(count):
            e = ents + 13 * i
            rid, rcount, rbyte, w5, w7, rptr = struct.unpack('<hhBhhI', self.rd(e, 13))
            out += [rid, rcount, rbyte, w5, w7]
            rect_ptrs.append(rptr)
            if rcount > 0:
                out += list(struct.unpack('<%di' % (6 * rcount), self.rd(rptr, 24 * rcount)))
        return dict(name=name, values=out, iv=iv, entries=ents, rects=rect_ptrs, count=count)


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out, strict=True, sanitize=False):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', *(['-Werror'] if strict else []), '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_1c_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a1c.c', 'action_family_1c_runtime.c', 'action_family_1c.c',
                                              'action_core.c')],
           '-Wl,--wrap=calloc', '-Wl,--wrap=malloc', '-Wl,--wrap=free', '-lm', '-o', str(out)]
    if sanitize or os.environ.get('A1C_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


TABLE_CAP = 600000


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P, i32, u8p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8)
        lib.a1co_new.restype = P
        lib.a1co_new.argtypes = [C.c_int]
        lib.a1co_free.argtypes = [P]
        lib.a1co_clear_files.argtypes = [P]
        lib.a1co_add_file.argtypes = [P, C.c_char_p, C.c_char_p, C.c_size_t]
        lib.a1co_add_file.restype = C.c_int
        lib.a1co_set_player.argtypes = [P, i32, C.c_char_p, C.c_int16, C.c_int, i32, i32]
        lib.a1co_set_cell.argtypes = [P, C.c_int16]
        lib.a1co_set_ztable.argtypes = [P, C.c_char_p]
        lib.a1co_get_ztable.argtypes = [P, C.c_char_p]
        lib.a1co_fail_after.argtypes = [P, C.c_long]
        lib.a1co_failed.argtypes = [P]
        lib.a1co_stream_open.argtypes = [P]
        for n in ('a1co_opens', 'a1co_closes', 'a1co_visits'):
            getattr(lib, n).argtypes = [P]
            getattr(lib, n).restype = C.c_ulong
        lib.a1co_failure.argtypes = [P]
        lib.a1co_failure.restype = C.c_char_p
        lib.a1co_clear_events.argtypes = [P]
        lib.a1co_event_count.argtypes = [P]
        lib.a1co_event.argtypes = [P, C.c_int, C.POINTER(i32)]
        lib.a1co_visit.argtypes = [P, C.c_char_p, C.c_size_t, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a1co_visit.restype = C.c_int
        lib.a1co_object.argtypes = [P, C.POINTER(i32)]
        lib.a1co_body.argtypes = [P, C.c_char_p]
        lib.a1co_body.restype = C.c_int
        lib.a1co_table.argtypes = [P, C.c_char_p, C.POINTER(i32), C.c_int]
        lib.a1co_table.restype = C.c_int
        lib.a1co_render.argtypes = [P, i32, i32, C.POINTER(i32), C.c_size_t, C.POINTER(C.c_size_t)]
        lib.a1co_render.restype = C.c_int
        lib.a1co_render_null.argtypes = [P, C.c_int]
        lib.a1co_render_null.restype = C.c_int
        lib.a1co_kernel_null.argtypes = [P, C.c_int]
        lib.a1co_kernel_null.restype = C.c_int
        lib.a1co_binding_null.argtypes = [P, C.c_int, C.c_char_p, C.c_size_t]
        lib.a1co_binding_null.restype = C.c_int
        lib.a1co_create_null.restype = C.c_int
        lib.a1co_kernel_unterminated.argtypes = [P]
        lib.a1co_free_iv_record.restype = C.c_int
        lib.a1co_render_corrupt.restype = C.c_int
        lib.a1co_set_open_quirk.argtypes = [P, C.c_int]
        lib.a1co_failed_kind.argtypes = [P]
        lib.a1co_fail_alloc_after.argtypes = [C.c_long]
        lib.a1co_alloc_failed.restype = C.c_int
        lib.a1co_live.restype = C.c_long
        lib.a1co_nfiles.argtypes = [P]
        lib.a1co_kernel_omit.argtypes = [P, C.c_int]
        lib.a1co_wrong_type.argtypes = [P, C.c_int, C.c_char_p, C.c_size_t]
        lib.a1co_accessors_null.restype = C.c_int
        lib.a1co_render_cap0.argtypes = [P, C.POINTER(C.c_size_t)]
        self.h = None
        self.table_buf = (i32 * TABLE_CAP)()

    def new(self, omit=0):
        self.close()
        self.h = self.lib.a1co_new(omit)
        if not self.h:
            raise d9.OracleError('native handle')

    def close(self):
        if self.h:
            self.lib.a1co_free(self.h)
            self.h = None
            if self.lib.a1co_live() != 0:
                live = self.lib.a1co_live()
                raise Mismatch('native leak: %d blocks still allocated after the binding was destroyed' % live)

    def live(self):
        return self.lib.a1co_live()

    def expected_live(self, table_blocks):
        return 2 + self.lib.a1co_nfiles(self.h) + table_blocks      # the handle, the binding, one block per file, the table

    def add_file(self, name, data):
        return self.lib.a1co_add_file(self.h, name, data, len(data))

    def set_player(self, state, name, hotspot, origin):
        name33 = (name + bytes(NAME_BYTES))[:NAME_BYTES]
        o = origin or (0, 0)
        self.lib.a1co_set_player(self.h, s32(state), name33, s16(hotspot), 1 if origin else 0, s32(o[0]), s32(o[1]))

    def set_cell(self, v):
        self.lib.a1co_set_cell(self.h, s16(v))

    def set_ztable(self, data):
        self.lib.a1co_set_ztable(self.h, bytes(data))

    def ztable(self):
        buf = C.create_string_buffer(NENT * STRIDE)
        self.lib.a1co_get_ztable(self.h, buf)
        return buf.raw

    def events(self):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(self.lib.a1co_event_count(self.h)):
            self.lib.a1co_event(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        self.lib.a1co_clear_events(self.h)
        return out

    def visit(self, raw_body, subtype, completed, phase):
        done, reset, new_phase, disp = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a1co_visit(self.h, bytes(raw_body), len(raw_body), subtype, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disp))
        return status, done.value, reset.value, new_phase.value, disp.value

    def object(self):
        t = (C.c_int32 * 16)()
        self.lib.a1co_object(self.h, t)
        keys = ('body', 'iv', 'slot', 'armed', 'changed', 'record', 'w152', 'last', 'd14e', 'd154', 'd158', 'origin')
        return {k: t[i] for i, k in enumerate(keys)}

    def body(self):
        buf = C.create_string_buffer(BODY_BYTES)
        return buf.raw if self.lib.a1co_body(self.h, buf) else None

    def table(self):
        name = C.create_string_buffer(NAME_BYTES)
        n = self.lib.a1co_table(self.h, name, self.table_buf, TABLE_CAP)
        if n == 0:
            return None
        if n > TABLE_CAP:
            raise d9.OracleError('native table larger than the dump buffer')
        return dict(name=name.raw, values=list(self.table_buf[:n]))

    def render(self, vx, vy, cap=8192):
        out = (C.c_int32 * (5 * cap))()
        count = C.c_size_t()
        status = self.lib.a1co_render(self.h, s32(vx), s32(vy), out, cap, C.byref(count))
        fills = [tuple(out[5 * i:5 * i + 5]) for i in range(min(count.value, cap))]
        return status, count.value, fills


# ---------------------------------------------------------------------------------------------
# files and bodies
# ---------------------------------------------------------------------------------------------
def name33(text):
    """A 33-byte header name: the text, a NUL and zero padding."""
    return (text + b'\0' + bytes(NAME_BYTES))[:NAME_BYTES]


def rect(x1, y1, x2, y2, d0=0, d5=0):
    return (d0, x1, y1, x2, y2, d5)


def entry(rid, rects, byte=0, w5=0, w7=0, count=None):
    return dict(id=rid, rects=list(rects), byte=byte, w5=w5, w7=w7, count=count)


def iv_file(header_name, entries, count=None, trailing=b''):
    out = bytearray(header_name)
    out += struct.pack('<i', len(entries) if count is None else count)
    for e in entries:
        c = len(e['rects']) if e['count'] is None else e['count']
        out += struct.pack('<hhBhh', e['id'], c, e['byte'], e['w5'], e['w7'])
        for r in e['rects']:
            out += struct.pack('<6i', *[s32(v) for v in r])
    return bytes(out) + trailing


def make_body(file_name, render=0, seed=0, subtype_garbage=True):
    """105 body bytes: the NUL-terminated file name, garbage after it, the render word at +0x21."""
    rng = random.Random(seed ^ 0x1C)
    body = bytearray(rng.randrange(256) for _ in range(BODY_BYTES))
    body[0:len(file_name) + 1] = file_name + b'\0'
    if len(file_name) < 0x21 - 1:
        struct.pack_into('<h', body, 0x21, s16(render))
    return bytes(body)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def R1C(name=b'CLIP', render=0, subtype=2, tail=b'', seed=0, body=None):
    return dict(type=0x1C, subtype=subtype, body=body if body is not None else make_body(name, render, seed), tail=tail)


def R67(subtype=1, tail=b''):
    return dict(type=0x67, subtype=subtype, body=b'\0', tail=tail)


def std_rects(n, base=0):
    return [rect(10 + base + 7 * k, 20 + base + 5 * k, 40 + base + 9 * k, 60 + base + 11 * k, d0=0x100 + k, d5=0x200 + k) for k in range(n)]


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
class Sc(dict):
    pass


def player_default():
    return dict(state=0, name=b'', hotspot=-1, origin=None)


def scenario_list(seed=0x1C57):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, files=None, quick=False, **kw):
        scs.append(Sc(id=sid, rows=rows, actions=actions, group=group, files=files or {}, quick=quick, mode=kw.pop('mode', 3),
                      first=kw.pop('first', 0), player=kw.pop('player', player_default()), cell=kw.pop('cell', 0),
                      busy=kw.pop('busy', ()), flag1fa=kw.pop('flag1fa', 0), events=kw.pop('events', {}), seed=len(scs) + seed,
                      isolate=kw.pop('isolate', False)))

    def P(**kw):
        return ('player', kw)

    T = ('tick',)
    HOT = P(state=2, name=b'CLIP')
    base_file = {b'CLIP': iv_file(name33(b'CLIP'), [entry(5, std_rects(2)), entry(9, std_rects(1, 100)), entry(-2, std_rects(3, 200))])}

    # ---- basic life cycle -------------------------------------------------------------------
    S('basic:full_cycle_hotspots', [R1C()], [HOT, T, P(hotspot=5), T, T, P(hotspot=9), T, ('render', 3, 4, 0x1234), P(hotspot=-1), T,
                                              P(hotspot=5), T, ('render', 0, 0, 7), P(state=4), T, T], 'basic', base_file, quick=True)
    S('basic:render_slot', [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('render', 11, -13, 0x55), T, P(state=0), T, T], 'basic', base_file, quick=True)
    S('basic:subtype1_once', [R1C(subtype=1, render=1)], [HOT, T, P(hotspot=9), T, ('render', 1, 1, 9), P(state=5), T, T, T], 'basic', base_file, quick=True)
    S('basic:subtype2_cycles', [R1C(subtype=2, render=0x7fff)],
      [HOT, T, P(hotspot=5), T, P(state=1), T, T, HOT, P(hotspot=9), T, ('render', 2, 3, 4), P(state=0), T, T, HOT, T, T], 'basic', base_file, quick=True)
    S('basic:wait_for_state', [R1C()], [P(state=0, name=b'CLIP'), T, T, P(state=1), T, P(state=3), T, P(state=5), T, P(state=2), T, T], 'basic', base_file, quick=True)
    S('basic:state3_pauses', [R1C()], [HOT, T, P(hotspot=5), T, P(state=3), T, T, P(state=2), T, ('render', 0, 0, 1), P(hotspot=9), T, P(state=3), T,
                                       P(state=2), T], 'basic', base_file, quick=True)
    # ---- player states -----------------------------------------------------------------------
    for st in (0, 1, 3, 4, 5, 6, -1, 0x7FFFFFFF, -0x80000000, 0x100000002, 0x200):
        S('player:phase0_state_%d' % st, [R1C()], [P(state=st & M32, name=b'CLIP'), T, T, P(state=2), T], 'player', base_file, quick=st in (0, 3, -1))
    for st in (0, 1, 2, 3, 4, 5, 7, -1, 0x10000002):
        S('player:phase1_state_%d' % st, [R1C()], [HOT, T, P(state=st & M32, hotspot=9), T, P(state=2, hotspot=5), T, T], 'player', base_file, quick=st in (0, 3, 4))
    # ---- names ---------------------------------------------------------------------------------
    names = [(b'CLIP', b'CLIP', True), (b'CLIP', b'CLIP2', False), (b'CLIP2', b'CLIP', False), (b'CLIP', b'clip', False), (b'', b'', True),
             (b'', b'X', False), (b'X', b'', False), (b'A' * 32, b'A' * 32, True), (b'A' * 32, b'A' * 31, False), (b'A' * 31, b'A' * 32, False),
             (b'\x80\xff', b'\x80\xff', True), (b'\x80\xff', b'\x7f\xff', False), (b'AB', b'AC', False), (b'AB', b'A', False),
             (b'A\x01', b'A', False), (b'ab cd', b'ab cd', True)]
    for k, (fname, pname, equal) in enumerate(names):
        junk = bytes((7 * i + 3) & 0xFF for i in range(33))
        hdr = (fname + b'\0' + junk[len(fname) + 1:])[:NAME_BYTES] if k % 2 else name33(fname)
        f = {b'CLIP': iv_file(hdr, [entry(5, std_rects(1)), entry(9, std_rects(2))])}
        S('name:%d_%s' % (k, 'eq' if equal else 'ne'), [R1C()], [P(state=2, name=pname), T, P(hotspot=5), T, T, P(name=fname), T, T, P(hotspot=9), T,
                                                                  P(state=4), T], 'name', f, quick=k in (0, 1, 3, 4, 7))
    # ---- file shapes ---------------------------------------------------------------------------
    S('file:no_entries', [R1C()], [HOT, T, P(hotspot=5), T, P(hotspot=-1), T, P(state=4), T], 'file', {b'CLIP': iv_file(name33(b'CLIP'), [])}, quick=True)
    S('file:one_entry_one_rect', [R1C(render=2)], [HOT, T, P(hotspot=7), T, ('render', 5, 6, 1), P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(7, [rect(1, 2, 3, 4)], 1, 2, 3)])}, quick=True)
    S('file:many_entries', [R1C(render=1)], [HOT, T] + sum(([P(hotspot=h), T, ('render', h, -h, h)] for h in (0, 1, 2, 5, 17, 31, 32, 99, -3)), []) + [P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(h, std_rects(1 + h % 3, h), h & 255, h, -h) for h in range(0, 33)])}, quick=True)
    S('file:many_rects_color_wrap', [R1C(render=1)], [HOT, T, P(hotspot=1, origin=(7, -9)), T, ('render', 100, 200, 5), ('render', 0, 0, 5), T, P(hotspot=2), T,
                                                      ('render', -(1 << 31), (1 << 31) - 1, 1), P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(1, std_rects(70)), entry(2, std_rects(66, 5))])}, quick=True)
    S('file:repeated_ids_first_wins', [R1C(render=1)], [HOT, T, P(hotspot=4), T, ('render', 0, 0, 1), P(hotspot=8), T, ('render', 1, 1, 1), P(hotspot=4), T,
                                                        ('render', 2, 2, 1), P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(4, std_rects(1), 1), entry(8, std_rects(1, 3), 2), entry(4, std_rects(2, 9), 3),
                                                   entry(4, std_rects(1, 1), 4), entry(8, std_rects(4), 5)])}, quick=True)
    S('file:entry_fields', [R1C()], [HOT, T, P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(i, std_rects(1 + i % 2), byte=b, w5=w5, w7=w7) for i, (b, w5, w7) in enumerate(
          [(0, 0, 0), (255, -1, -1), (128, 0x7FFF, -0x8000), (1, -0x8000, 0x7FFF), (0x7F, 0x1234, -0x4321)])])}, quick=True)
    S('file:extreme_rects', [R1C(render=1)], [HOT, T, P(hotspot=1, origin=(0x7FFFFFFF, -0x80000000)), T, ('render', 0x7FFFFFFF, -0x80000000, 3), P(hotspot=2), T,
                                              ('render', 1, -1, 3), P(state=4), T],
      'file', {b'CLIP': iv_file(name33(b'CLIP'), [entry(1, [rect(0x7FFFFFFF, 0x7FFFFFFF, -0x80000000, -0x80000000, -1, 0x7FFFFFFF),
                                                           rect(-0x80000000, -1, 0, 1)]),
                                                  entry(2, [rect(0, 0, 0, 0), rect(5, 6, 7, 8)])])}, quick=True)
    S('file:trailing_bytes', [R1C()], [HOT, T, P(hotspot=1), T, P(state=4), T], 'file',
      {b'CLIP': iv_file(name33(b'CLIP'), [entry(1, std_rects(2))], trailing=bytes(range(50)))})
    S('file:count_smaller_than_entries', [R1C()], [HOT, T, P(hotspot=2), T, P(state=4), T], 'file',
      {b'CLIP': iv_file(name33(b'CLIP'), [entry(1, std_rects(1)), entry(2, std_rects(1))], count=1)})
    S('file:empty_name_header_eq_empty_player', [R1C()], [P(state=2, name=b''), T, P(hotspot=3), T, P(state=4), T], 'file',
      {b'CLIP': iv_file(name33(b''), [entry(3, std_rects(1))])})
    # ---- hotspot changes and the origin shift ---------------------------------------------------
    S('hotspot:minus_one_never_searched', [R1C()], [HOT, T, P(hotspot=-1), T, T, P(hotspot=5), T, P(hotspot=-1), T], 'hotspot', base_file, quick=True)
    S('hotspot:not_found', [R1C(render=1)], [HOT, T, P(hotspot=1234), T, ('render', 0, 0, 1), P(hotspot=-32768), T, P(hotspot=32767), T, P(hotspot=0), T], 'hotspot', base_file, quick=True)
    S('hotspot:repeated_no_second_shift', [R1C(render=1)], [HOT, P(origin=(100, 200)), T, P(hotspot=5), T, T, T, ('render', 0, 0, 1), P(origin=(1, 1)), T, T], 'hotspot',
      base_file, quick=True)
    S('hotspot:changing_shifts_again', [R1C(render=1)], [HOT, P(origin=(100, 200)), T, P(hotspot=5), T, P(hotspot=9), T, P(hotspot=5), T, P(hotspot=-2), T,
                                                          ('render', 7, 8, 1), P(hotspot=5), T, ('render', 7, 8, 1)], 'hotspot', base_file, quick=True)
    S('hotspot:state3_forgets_record', [R1C(render=1)], [HOT, T, P(hotspot=5, origin=(3, 4)), T, P(state=3), T, ('render', 0, 0, 1), P(state=2), T, P(hotspot=9), T, ('render', 0, 0, 1)], 'hotspot',
      base_file, quick=True)
    S('hotspot:origin_absent_then_present', [R1C(render=1)], [HOT, T, P(hotspot=5, origin=None), T, ('render', 1, 2, 1), P(hotspot=9, origin=(50, 60)), T, ('render', 1, 2, 1),
                                                              P(hotspot=5, origin=None), T, P(hotspot=-2, origin=(9, 9)), T, ('render', 1, 2, 1)], 'hotspot', base_file, quick=True)
    S('hotspot:origin_wraparound', [R1C(render=1)], [HOT, P(origin=(0x7FFFFFFF, 0x7FFFFFFF)), T, P(hotspot=5), T, ('render', 0x7FFFFFFF, 0x7FFFFFFF, 1), P(hotspot=9), T,
                                                      ('render', -0x80000000, -0x80000000, 1)], 'hotspot', base_file)
    S('hotspot:index_equals_last_after_wait', [R1C()], [HOT, T, P(hotspot=5), T, P(state=0), T, P(state=2), T, P(hotspot=5), T], 'hotspot', base_file)
    # ---- render word ----------------------------------------------------------------------------
    for w in (0, 1, -1, 0x7FFF, -0x8000, 0x100, 0x2):
        S('render_word:%d' % w, [R1C(render=w)], [HOT, T, P(hotspot=5), T, ('render', 1, 1, 1), P(state=4), T], 'render_word', base_file, quick=w in (0, 1, 0x100))
    S('render_word:long_name_overlaps', [R1C(name=b'CLIP' + b'Q' * 37)], [P(state=2, name=b'CLIP'), T, T], 'render_word',
      {b'CLIP' + b'Q' * 37: iv_file(name33(b'CLIP'), [entry(5, std_rects(1))])}, isolate=True)
    S('render_word:name_104_chars', [R1C(name=b'N' * 104)], [P(state=2, name=b'CLIP'), T, T, P(hotspot=5), T, P(state=4), T], 'render_word',
      {b'N' * 104: base_file[b'CLIP']}, isolate=True)
    S('render_word:name_33_34_chars', [R1C(name=b'M' * 33), R1C(name=b'K' * 34)], [P(state=2, name=b'CLIP'), T, T, P(hotspot=5), T, P(state=4), T, T], 'render_word',
      {b'M' * 33: base_file[b'CLIP'], b'K' * 34: base_file[b'CLIP']}, isolate=True)
    S('render_word:long_name_zero_word', [R1C(body=bytes([0x43, 0x4C, 0x49, 0x50]) + bytes(BODY_BYTES - 4))], [HOT, T, P(hotspot=5), T, ('render', 0, 0, 1), P(state=4), T],
      'render_word', base_file)
    S('render:no_change_draws_nothing', [R1C(render=1)], [HOT, ('render', 0, 0, 1), T, ('render', 1, 1, 1), ('render', 1, 1, 1), P(hotspot=5), T, ('render', 0, 0, 1), ('render', 0, 0, 1)],
      'render_word', base_file, quick=True)
    S('render:capacity_cuts', [R1C(render=1)], [HOT, T, P(hotspot=1), T, ('render', 4, 5, 6, 3), P(hotspot=2), T, ('render', 4, 5, 6, 1), P(hotspot=1), T,
                                                ('render', 4, 5, 6, 70), P(hotspot=2), T, ('render', 4, 5, 6, 66), P(hotspot=1), T, ('render', 4, 5, 6, 0)],
      'render_word', {b'CLIP': iv_file(name33(b'CLIP'), [entry(1, std_rects(70)), entry(2, std_rects(66, 5))])}, quick=True)
    S('render:two_ticks_one_render', [R1C(render=1)], [HOT, T, P(hotspot=5), T, P(hotspot=9), T, ('render', 0, 0, 1), P(hotspot=5), T, T, ('render', 0, 0, 1)], 'render_word', base_file)
    # ---- phases ---------------------------------------------------------------------------------
    for ph in (1, 2, 3, 4, 5, 7, 0x80000000, M32):
        S('phase:fresh_object_phase_%#x' % ph, [R1C(render=1)], [P(state=2, name=b'CLIP', hotspot=5), ('setphase', 0, ph), T, T, ('setphase', 0, 0), T, T], 'phase', base_file,
          quick=ph in (1, 2, 3))
    S('phase:set_2_after_load', [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('setphase', 0, 2), T, T, T], 'phase', base_file, quick=True)
    S('phase:set_0_after_load_keeps_table', [R1C(render=1)], [HOT, T, P(hotspot=5, origin=(5, 6)), T, ('setphase', 0, 0), T, T, P(hotspot=9), T], 'phase', base_file, quick=True)
    S('phase:set_3_midway', [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('setphase', 0, 3), T, T, ('setphase', 0, 1), T], 'phase', base_file)
    S('phase:2_twice', [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('setphase', 0, 2), T, ('setphase', 0, 2), T], 'phase', base_file)
    S('phase:phase1_without_load', [R1C()], [P(state=2, name=b'CLIP', hotspot=5), ('setphase', 0, 1), T, P(state=3), T, P(state=0), T], 'phase', base_file)
    S('state:carried_record_cleared', [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('render', 0, 0, 1), P(state=3), T, ('render', 0, 0, 1), P(state=2, hotspot=-1), T,
                                                          ('render', 0, 0, 1), P(hotspot=5), T, ('render', 0, 0, 1), P(hotspot=-1), T, ('render', 0, 0, 1), P(state=4), T, T],
      'phase', base_file, quick=True)
    S('state:origin_then_phase2', [R1C(render=1)], [HOT, T, P(hotspot=5, origin=(3, 4)), T, ('render', 0, 0, 1), P(state=4), T, T, HOT, T, P(hotspot=9), T, ('render', 0, 0, 1)],
      'phase', base_file, quick=True)
    S('state:origin_kept_until_phase0_reset', [R1C(render=1)], [HOT, T, P(hotspot=5, origin=(5, 6)), T, ('render', 0, 0, 1), P(hotspot=-1), ('setphase', 0, 0), T, T,
                                                                  ('render', 0, 0, 1), P(hotspot=5), T, ('render', 0, 0, 1)],
      'phase', base_file, quick=True)
    # ---- subtypes ---------------------------------------------------------------------------------
    for st in (0, 1, 2, 3, 4, 0x7F, 0x80, 0xFF):
        S('subtype:%d' % st, [R1C(subtype=st, render=1)], [HOT, T, P(hotspot=5), T, P(state=4), T, T, HOT, T, T], 'subtype', base_file, quick=st in (0, 1, 2, 3))
    # ---- z entry table -----------------------------------------------------------------------------
    for k, busy in enumerate([(), (0x18,), (0x18, 0x19, 0x1A), tuple(range(0x18, 0x3F)), (0x3F,), (0x19, 0x1B, 0x1D), tuple(range(0x20, 0x30)),
                              tuple(range(0x18, 0x3E))]):
        S('ztable:busy_%d' % k, [R1C(render=1)], [HOT, T, P(hotspot=5), T, ('render', 1, 1, 1), P(state=4), T, T, HOT, T, T], 'ztable', base_file, busy=busy, quick=k in (0, 1, 3))
    S('ztable:two_rows_two_slots', [R1C(render=1), R1C(name=b'CLIP2', render=1)], [HOT, T, T, P(state=4), T], 'ztable',
      {**base_file, b'CLIP2': iv_file(name33(b'CLIP'), [entry(5, std_rects(1))])}, busy=(0x18,))
    S('ztable:no_slot_without_render_word', [R1C(render=0)], [HOT, T, P(hotspot=5), T, P(state=4), T], 'ztable', base_file, busy=tuple(range(0x18, 0x3F)), quick=True)
    # ---- word cell [0x583a29] ------------------------------------------------------------------------
    for v in (0, 1, -1, 0x7FFF, -0x8000, 0x1234):
        S('cell:%d' % v, [R1C()], [HOT, T, P(hotspot=5), T, P(state=4), T, ('cell', v ^ 0x55), HOT, T, T], 'cell', base_file, cell=v, quick=v in (-1, 0x1234))
    # ---- rows, gates and neighbours -------------------------------------------------------------------
    S('rows:neighbour_67_rows', [R67(), R1C(render=1), R67(2), R67(0)], [HOT, T, P(hotspot=5), T, P(state=4), T, ('rearm',), T, T], 'rows', base_file, quick=True)
    S('rows:two_1c_rows_shared_object', [R1C(name=b'CLIP', render=1), R1C(name=b'CLIP2', render=1, subtype=1)],
      [P(state=2, name=b'CLIP'), T, P(hotspot=5), T, P(name=b'CLIP2', hotspot=9), T, T, P(state=4), T, T, ('rearm',), T],
      'rows', {**base_file, b'CLIP2': iv_file(name33(b'CLIP2'), [entry(9, std_rects(2)), entry(5, std_rects(1, 3))])}, quick=True)
    S('rows:same_body_two_rows', [R1C(render=1), R1C(render=1)], [HOT, T, P(hotspot=5), T, P(state=4), T, T], 'rows', base_file)
    S('rows:first_offset', [R1C(render=1), R67()], [HOT, T, P(hotspot=9), T, P(state=4), T], 'rows', base_file, first=3, quick=True)
    S('rows:mode4_runs_nothing', [R1C(), R67()], [HOT, T, ('mode', 3), T, P(hotspot=5), T], 'rows', base_file, mode=4, quick=True)
    S('rows:gated_event_false_true', [R1C(tail=event_tail(40, 1)), R67(tail=event_tail(41, 1))], [HOT, T, ('events', {40: 1}), T, P(hotspot=5), T, ('events', {41: 1}), T,
                                                                                                P(state=4), T, ('rearm',), T], 'rows', base_file, events={40: 7, 41: 7}, quick=True)
    S('rows:gate_flips_midway', [R1C(tail=event_tail(40, 1), render=1)], [HOT, ('events', {40: 1}), T, P(hotspot=5), T, ('events', {40: 0}), T, T, ('events', {40: 1}), T,
                                                                          P(state=4), T], 'rows', base_file, events={40: 0})
    S('rows:flag1fa_path_format', [R1C()], [HOT, T, P(hotspot=5), T, P(state=4), T], 'rows', base_file, flag1fa=1, quick=True)
    S('rows:file_replaced_between_cycles', [R1C(subtype=2)], [HOT, T, P(hotspot=5), T, P(state=4), T, ('file', b'CLIP', iv_file(name33(b'CLIP'), [entry(5, std_rects(4, 1))])), HOT, T,
                                                              P(hotspot=5), T, P(state=4), T], 'rows', base_file, quick=True)
    S('rows:file_replaced_while_loaded', [R1C(subtype=2)], [HOT, T, P(hotspot=5), T, ('file', b'CLIP', b''), T, P(hotspot=9), T, P(state=4), T], 'rows', base_file)
    S('rows:two_files_same_clip_name', [R1C(name=b'A'), R1C(name=b'B', subtype=1)], [HOT, T, T, P(hotspot=5), T, T], 'rows',
      {b'A': iv_file(name33(b'CLIP'), [entry(5, std_rects(2))]), b'B': iv_file(name33(b'CLIP'), [entry(5, std_rects(3))])})
    # ---- randomised mixes -------------------------------------------------------------------------------
    for n in range(160):
        names_pool = [b'CLIP', b'CLIP', b'CLIP', b'CLIP2', b'', b'AB' * 12]
        file_names = [b'CLIP', b'CLIP2', b'F%d' % n]
        rows = []
        files = {}
        for r in range(rng.randint(1, 3)):
            fname = rng.choice(file_names)
            if fname not in files:
                ents = [entry(rng.choice([-1, 0, 1, 2, 3, 7, 9, -2, 300]), std_rects(rng.randint(1, 4), rng.randrange(50)), rng.randrange(256),
                              rng.randrange(-32768, 32768), rng.randrange(-32768, 32768)) for _ in range(rng.randint(0, 8))]
                files[fname] = iv_file(name33(rng.choice(names_pool)), ents)
            rows.append(R1C(name=fname, render=rng.choice([0, 0, 1, -1, 3]), subtype=rng.choice([0, 1, 2, 2, 2, 3]), seed=n * 7 + r,
                            tail=event_tail(40 + r, 1) if rng.random() < 0.2 else b''))
            if rng.random() < 0.3:
                rows.append(R67(rng.choice([0, 1, 2])))
        acts = []
        for _ in range(rng.randint(8, 24)):
            k = rng.random()
            if k < 0.45:
                acts.append(T)
            elif k < 0.7:
                acts.append(P(state=rng.choice([0, 1, 2, 2, 2, 3, 3, 4, 5, -1]), name=rng.choice(names_pool), hotspot=rng.choice([-1, -1, 0, 1, 2, 3, 7, 9, -2, 300, 5]),
                              origin=rng.choice([None, None, (rng.randrange(-1000, 1000), rng.randrange(-1000, 1000)), (0x7FFFFFFF, -0x80000000)])))
            elif k < 0.8:
                acts.append(('render', rng.randrange(-300, 300), rng.randrange(-300, 300), rng.randrange(1, 1 << 30), rng.choice([8192, 8192, 1, 2, 5])))
            elif k < 0.85:
                acts.append(('setphase', rng.randrange(len(rows)), rng.choice([0, 1, 2, 2, 3, 5])))
            elif k < 0.9:
                acts.append(('rearm',))
            elif k < 0.95:
                acts.append(('cell', rng.randrange(-32768, 32768)))
            else:
                acts.append(('events', {40 + q: rng.choice([0, 1]) for q in range(3)}))
        S('random:%d' % n, rows, acts, 'random', files, cell=rng.randrange(-32768, 32768), busy=tuple(rng.sample(range(0x18, 0x40), rng.randint(0, 20))),
          events={40: 1, 41: rng.choice([0, 1]), 42: 1}, flag1fa=rng.choice([0, 0, 1]), quick=n < 4)
    return scs


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, handler_visits=0, phase0_visits=0, phase1_visits=0, phase2_visits=0, phase_other_visits=0,
                completions=0, resets=0, loads=0, renders=0, fills=0, events=0, fields=0, table_values=0, z_bytes=0, frees=0,
                native_visits=0, neighbour_rows=0, gated=0, mismatches=0, refusals=0, groups={}, by_subtype=Counter(), fatal_sites=Counter(),
                limits=Counter())


def gate_open(spec, flags):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flags.get(rec[1], 0) == rec[2]


def check(stats, where, what, a, b):
    stats['fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native %r' % (where, what, a, b))


def norm_orig_events(events):
    out = []
    for kind, a, b in events:
        if kind == EV_RECT_RUN:
            if a == 0:
                continue                       # fread of 0 bytes: the kernel refuses that count before reading
            full = b // 24
            out += [(EV_READ, 24, 24)] * full
            if b < a:
                out.append((EV_READ, 24, b % 24))
        else:
            out.append((kind, a, b))
    return out


def fmt_events(events, n=14):
    return ' '.join('%s(%d,%d)' % (EVN.get(k, k), a, b) for k, a, b in events[:n]) + (' ...' if len(events) > n else '')


class Run:
    """The per-scenario state shared by the original and the native side."""

    def __init__(self, sc, x, nat):
        self.sc, self.x, self.nat = sc, x, nat
        self.rows = [dict(r) for r in sc['rows']]
        self.first = sc['first']
        total = self.first + len(self.rows)
        self.completed = [1 if i < self.first else 0 for i in range(total)]
        self.phases = [0] * total
        self.mode = sc['mode']
        self.flags = dict(sc['events'])
        self.player = dict(sc['player'])
        self.files = {}
        self.file_index = {}
        self.flag_cell = 0
        self.rng = random.Random(sc['seed'])
        self.last_body = None
        self.visits = 0


def apply_player(run):
    p = run.player
    run.x.set_player(p['state'] & M32, p['name'], p['hotspot'], p['origin'])
    run.nat.set_player(p['state'], p['name'], p['hotspot'], p['origin'])


def set_file(run, name, data):
    x, nat = run.x, run.nat
    if name in run.file_index:
        idx = run.file_index[name]
        x.files[idx] = (name, data)
    else:
        idx = len(x.files)
        x.files.append((name, data))
        run.file_index[name] = idx
    got = nat.add_file(name, data)
    if got != idx:
        raise d9.OracleError('file index disagreement')


def setup(sc, x, nat, rng_seed=None):
    run = Run(sc, x, nat)
    x.hard_reset()
    nat.new()
    x.install_rows(run.rows, run.first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    x.w32(FLAG_1FA, sc['flag1fa'])
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    rng = run.rng
    # garbage: the player image outside the getters' fields, the object's scratch bytes, the z table
    x.wr(PLAYER, bytes(rng.randrange(256) for _ in range(PLAYER_LEN)))
    x.wr(OBJ + SCRATCH_LO, bytes(rng.randrange(256) for _ in range(SCRATCH_HI - SCRATCH_LO)))
    x.wr(OBJ + 0xC, struct.pack('<H', 0xFFFF))                          # the constructor 0x4caed0 -> 0x4caf03: slot -1,
    x.w32(OBJ + 0x14A, 0xFFFFFFFF)                                      # last index -1 (the other fields stay 0)
    z = bytearray(rng.randrange(256) for _ in range(NENT * STRIDE))
    for slot in range(0x18, 0x40):
        struct.pack_into('<I', z, slot * STRIDE + 0x18, 1 if slot in sc['busy'] else 0)
    x.wr(ENTRY, bytes(z))
    nat.set_ztable(z)
    x.w32(CELL_583A29 - 2, rng.randrange(1 << 32))                     # the bytes around the word cell
    x.wr(CELL_583A29, struct.pack('<h', s16(sc['cell'])))
    nat.set_cell(sc['cell'])
    for name, data in sc['files'].items():
        set_file(run, name, data)
    apply_player(run)
    x.base_live = dict(x.live)
    return run


def expected_row_state(run):
    return [(run.completed[i], run.phases[i]) for i in range(len(run.completed))]


def compare_rows(where, run, stats, skip_dep=True):
    x = run.x
    for i in range(run.first + len(run.rows)):
        base = ROWS + i * ROW
        check(stats, where, 'row %d completion byte' % i, x.rd(base + COMPLETE_OFF, 1)[0], run.completed[i])
        check(stats, where, 'row %d phase dword' % i, struct.unpack('<I', x.rd(base + PHASE_OFF, 4))[0], run.phases[i])
        # the request dword and the other unlisted bytes are never written by the 0x1c / 0x67 arms
        check(stats, where, 'row %d request dword' % i, x.rd(base + 0x73, 4), bytes(4))


def table_expected_frees(pre):
    if pre is None:
        return []
    return list(pre['rects'][i] for i in range(pre['count']) if pre['values'] is not None and pre['rects'][i]) + [pre['entries'], pre['iv']]


def compare_object(where, run, stats):
    x, nat = run.x, run.nat
    o, n = x.object(), nat.object()
    tab = x.table()
    check(stats, where, 'changed (+8)', o['changed'], n['changed'])
    check(stats, where, 'z slot (+0xc)', o['slot'], n['slot'])
    check(stats, where, 'armed (+0xe)', o['armed'], n['armed'])
    check(stats, where, 'loaded (+0x1a)', int(o['iv'] != 0), n['iv'])
    # +0x12: the entry as an index into the loaded table
    if o['record'] == 0:
        idx = -1
    else:
        if tab is None or (o['record'] - tab['entries']) % 13 or not 0 <= (o['record'] - tab['entries']) // 13 < tab['count']:
            raise Mismatch('%s: original +0x12 %#x is not an entry of the loaded table' % (where, o['record']))
        idx = (o['record'] - tab['entries']) // 13
    check(stats, where, 'current entry (+0x12)', idx, n['record'])
    check(stats, where, 'last index (+0x14a)', o['last'], n['last'])
    check(stats, where, 'dword +0x14e', o['d14e'], n['d14e'])
    check(stats, where, 'word +0x152', o['w152'], s16(n['w152']))
    check(stats, where, 'dword +0x154', o['d154'], n['d154'])
    check(stats, where, 'dword +0x158', o['d158'], n['d158'])
    check(stats, where, 'origin pointer present (+0x15c)', int(o['origin'] != 0), n['origin'])
    # +0x16: the body pointer as the body bytes
    ob = x.rd(o['body'], BODY_BYTES) if o['body'] else None
    check(stats, where, 'body (+0x16) bytes', ob, nat.body())
    check(stats, where, 'body (+0x16) presence', int(o['body'] != 0), n['body'])
    # the loaded table
    nt = nat.table()
    check(stats, where, 'table loaded', tab is not None, nt is not None)
    if tab is not None:
        check(stats, where, 'table name', tab['name'], nt['name'])
        stats['table_values'] += len(tab['values'])
        if tab['values'] != nt['values']:
            a, b = tab['values'], nt['values']
            at = next((k for k in range(min(len(a), len(b))) if a[k] != b[k]), min(len(a), len(b)))
            raise Mismatch('%s: loaded table differs at value %d (original %s native %s, lengths %d / %d)' %
                           (where, at, a[at:at + 3], b[at:at + 3], len(a), len(b)))
    # heap discipline: the live allocations are exactly the loaded file's tables
    live = {p for p in x.live if p not in x.base_live}
    reach = set()
    if tab is not None:
        reach = {tab['iv'], tab['entries']} | {p for p in tab['rects'] if p}
    if live != reach:
        raise Mismatch('%s: live allocations %s differ from the reachable table %s' % (where, sorted(hex(p) for p in live ^ reach)[:6], len(reach)))
    check(stats, where, 'native live blocks (handle, binding, files, table)', nat.live(), nat.expected_live(len(reach)))
    # z table
    zo, zn = x.rd(ENTRY, NENT * STRIDE), nat.ztable()
    stats['z_bytes'] += len(zo)
    if zo != zn:
        at = next(k for k in range(len(zo)) if zo[k] != zn[k])
        raise Mismatch('%s: z entry table differs at entry %d offset %#x (original %#x native %#x)' % (where, at // STRIDE, at % STRIDE, zo[at], zn[at]))
    return tab


def check_writes(where, run):
    bad = {k: v for k, v in run.x.other_writes.items() if k not in EXPECTED_OTHER_WRITES}
    if bad:
        raise Mismatch('%s: stores outside the modelled cells: %s' % (where, dict(list(bad.items())[:6])))
    run.x.other_writes.clear()


def tick(where, run, stats):
    x, nat = run.x, run.nat
    pre = x.table()
    nat.events()
    x.dispatch()
    total = run.first + len(run.rows)
    check_writes(where, run)
    # model: rows entered / visited
    entered_1c, visited, neighbours = [], [], []
    if run.mode == 3:
        for i in range(run.first, total):
            if run.completed[i]:
                continue
            spec = run.rows[i - run.first]
            if spec['type'] == 0x1C:
                entered_1c.append(i)
            if not gate_open(spec, run.flags):
                stats['gated'] += 1
                continue
            visited.append(i)
    expected_handlers = []
    exp_finish, exp_reset = [], []
    for i in visited:
        spec = run.rows[i - run.first]
        if spec['type'] == 0x67:
            run.completed[i] = 1
            run.flag_cell = 1
            neighbours.append(i)
            stats['neighbour_rows'] += 1
            continue
        phase_before = run.phases[i]
        expected_handlers.append((i, phase_before))
        raw = spec['body'] + (spec.get('tail') or b'')
        status, done, reset, phase, disp = nat.visit(raw, spec['subtype'], run.completed[i], phase_before)
        stats['native_visits'] += 1
        if status != 0:
            raise Mismatch('%s: native handler status %d (%s) for row %d, original ran it to the end' %
                           (where, status, nat.lib.a1co_failure(nat.h).decode(), i))
        run.completed[i], run.phases[i] = done, phase
        run.visits += 1
        check(stats, where, 'binding failure text after an accepted visit', nat.lib.a1co_failure(nat.h), b'none')
        if reset:
            exp_reset.append(i)
        if phase_before == 2:    # the original always ends phase 2 with the generic completion 0x42ba3a (the binding may map it to DIRECT_COMPLETED)
            exp_finish.append(i)
        stats['by_subtype'][spec['subtype']] += 1
        stats['phase0_visits' if phase_before == 0 else 'phase1_visits' if phase_before == 1 else 'phase2_visits' if phase_before == 2
              else 'phase_other_visits'] += 1
    stats['handler_visits'] += len(expected_handlers)
    stats['rows_entered'] += len(x.arms)
    check(stats, where, 'rows that entered the 0x1c arm', x.arms, entered_1c)
    check(stats, where, 'handler entries (row, phase read)', x.handlers, expected_handlers)
    check(stats, where, 'generic completions 0x42ba3a', x.finishes, exp_finish)
    check(stats, where, 'dependency resets 0x423d33', x.resets, exp_reset)
    stats['completions'] += len(exp_finish)
    stats['resets'] += len(exp_reset)
    compare_rows(where, run, stats)
    check(stats, where, 'start flag 0x5bb1ca', struct.unpack('<I', x.rd(START_FLAG, 4))[0], run.flag_cell)
    # ordered host calls
    oe, ne = norm_orig_events(x.ev), nat.events()
    stats['events'] += len(oe)
    if oe != ne:
        at = next((k for k in range(min(len(oe), len(ne))) if oe[k] != ne[k]), min(len(oe), len(ne)))
        raise Mismatch('%s: ordered host calls differ at %d: original [%s] native [%s]' % (where, at, fmt_events(oe[max(at - 1, 0):], 5), fmt_events(ne[max(at - 1, 0):], 5)))
    stats['loads'] += sum(1 for e in oe if e[0] == EV_OPEN)
    if x.streams or nat.lib.a1co_stream_open(nat.h):
        raise Mismatch('%s: a file stream is still open (original %d native %d)' % (where, len(x.streams), nat.lib.a1co_stream_open(nat.h)))
    tab = compare_object(where, run, stats)
    # free order of a table that was loaded before the tick
    stats['frees'] += len(x.freed_log)
    if pre is not None and x.freed_log and x.freed_log[0] in set(pre['rects']) | {pre['entries'], pre['iv']}:
        blk = [p for p in pre['rects'] if p] + [pre['entries'], pre['iv']]
        if x.freed_log[:len(blk)] != blk:
            raise Mismatch('%s: free order differs from rectangles / entries / iv' % where)
    stats['ticks'] += 1
    return tab


def do_render(where, run, stats, vx, vy, surf, cap=8192):
    x, nat = run.x, run.nat
    x.w32(VIEW_X, s32(vx) & M32)
    x.w32(VIEW_Y, s32(vy) & M32)
    x.w32(SURFACE_CELL, surf)
    before = x.object()
    x.render()
    check_writes(where, run)
    status, count, nfills = nat.render(vx, vy, cap)
    if status != 0:
        raise Mismatch('%s: native render status %d' % (where, status))
    ofills = []
    for this, surface, r, color in x.fills:
        if this != FILL_THIS or surface != surf:
            raise Mismatch('%s: fill called with this %#x surface %#x' % (where, this, surface))
        ofills.append((r[0], r[1], r[2], r[3], color))
    stats['renders'] += 1
    stats['fills'] += len(ofills)
    stats['limits']['render_capacity_cuts'] += int(cap < len(ofills))
    ofills_cap = ofills[:cap]
    if ofills_cap != nfills or count != len(ofills):
        at = next((k for k in range(min(len(ofills), len(nfills))) if ofills[k] != nfills[k]), min(len(ofills), len(nfills)))
        raise Mismatch('%s: fills differ at %d: original %s native %s (counts %d / %d)' % (where, at, ofills[at:at + 1], nfills[at:at + 1], len(ofills), count))
    after = x.object()
    check(stats, where, 'changed flag cleared by the render', after['changed'], nat.object()['changed'])
    if before['changed'] == 0:
        check(stats, where, 'no change: no fills', len(ofills), 0)
    compare_object(where, run, stats)


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['native_visits'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['visits'] += stats['native_visits'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, nat, sc, stats):
    run = setup(sc, x, nat)
    compare_object(sc['id'] + ' initial', run, stats)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0] if act[0] != 'player' else 'player %s' % {k: v for k, v in act[1].items()})
        kind = act[0]
        if kind == 'tick':
            tick(where, run, stats)
        elif kind == 'player':
            run.player.update(act[1])
            apply_player(run)
        elif kind == 'render':
            do_render(where, run, stats, act[1], act[2], act[3], *act[4:])
        elif kind == 'setphase':
            i = run.first + act[1]
            run.phases[i] = act[2] & M32
            x.w32(ROWS + i * ROW + PHASE_OFF, act[2] & M32)
        elif kind == 'rearm':
            for i in range(run.first, run.first + len(run.rows)):
                run.completed[i] = 0
                run.phases[i] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'events':
            for idx, v in act[1].items():
                run.flags[idx] = v
                x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
        elif kind == 'cell':
            x.wr(CELL_583A29, struct.pack('<h', s16(act[1])))
            run.nat.set_cell(act[1])
        elif kind == 'mode':
            run.mode = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        elif kind == 'file':
            set_file(run, act[1], act[2])
        else:
            raise d9.OracleError('unknown action ' + kind)
    check(stats, sc['id'], 'binding visit counter', nat.lib.a1co_visits(nat.h), run.visits)
    stats['scenarios'] += 1


# ---------------------------------------------------------------------------------------------
# native-only refusals, run against the original's own failure paths
# ---------------------------------------------------------------------------------------------
def native_table_blocks(nat):
    """Number of heap blocks the kernel keeps for the loaded file (iv, entries, one rectangle array per entry that has rectangles)."""
    t = nat.table()
    if t is None:
        return 0
    v, n, pos = t['values'], t['values'][0], 1
    blocks = 2
    for _ in range(n):
        count = v[pos + 1]
        blocks += 1 if count > 0 else 0
        pos += 5 + 6 * max(count, 0)
    return blocks


def refusal_variants():
    """(id, file bytes or None, body name, expected fatal call-site kind of the original, extra row options)."""
    good_entries = [entry(5, std_rects(2)), entry(9, std_rects(1, 100))]
    good = iv_file(name33(b'CLIP'), good_entries)
    head = name33(b'CLIP')
    out = [('no_file', None, b'CLIP', 'open'), ('empty_name', good, b'', 'empty-name'), ('empty_file', b'', b'CLIP', 'header'),
           ('empty_name_tail', good, b'', 'empty-name')]
    for cut in (1, 20, 32, 33, 34, 36):
        out.append(('cut_%d' % cut, good[:cut], b'CLIP', 'header'))
    # cuts inside the entry fields and rectangle data of the first entry (entry starts at 37)
    for cut in (37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 60, 61, 84, 85):
        out.append(('cut_%d' % cut, good[:cut], b'CLIP', 'entry' if cut < 46 else 'rects'))
    out.append(('cut_second_entry', good[:37 + 9 + 48 + 5], b'CLIP', 'entry'))
    out.append(('cut_second_rects', good[:37 + 9 + 48 + 9 + 10], b'CLIP', 'rects'))
    out.append(('rect_count_zero', iv_file(head, [entry(5, [], count=0)]), b'CLIP', 'rects'))
    out.append(('rect_count_zero_second', iv_file(head, [entry(5, std_rects(1)), entry(6, [], count=0)]), b'CLIP', 'rects'))
    for c in (-1, -2, -32768):
        out.append(('rect_count_%d' % c, iv_file(head, [entry(5, [], count=c)]), b'CLIP', 'alloc' if c * 24 & M32 > 0x7FFFFFE0 else 'rects'))
    out.append(('rect_count_short_data', iv_file(head, [entry(5, std_rects(1), count=3)]), b'CLIP', 'rects'))
    for c in (-1, -7, -2147483648, 0x7FFFFFFF, 0x20000000, 0x10000000):
        out.append(('entry_count_%d' % c, iv_file(head, [entry(5, std_rects(1))], count=c), b'CLIP', 'alloc' if (c * 13) & M32 > 0x7FFFFFE0 or c > 0x600000 else 'entry'))
    out.append(('entry_count_2_one_present', iv_file(head, [entry(5, std_rects(1))], count=2), b'CLIP', 'entry'))
    return out


def refusal_checks(x, nat, stats, fail_fast=False):
    """Native-only refusals against the original's own paths; raises Mismatch on the first difference."""
    bad = []
    for rid, data, body_name, kind in refusal_variants():
        body = make_body(body_name, 0, 5) if body_name else make_body(b'', 0, 5)
        files = {} if data is None else {b'CLIP': data}
        if rid == 'empty_name_tail':                       # NUL first, then "CLIP": a scan that skips the first byte would open the file named ""
            body = b'\0CLIP' + bytes(BODY_BYTES - 5)
            files[b''] = data
        sc = Sc(id='refuse:' + rid, rows=[R1C(name=body_name or b'', body=body)], actions=[], group='refusal',
                files=files, quick=False, mode=3, first=0, player=dict(state=2, name=b'CLIP', hotspot=-1, origin=None),
                cell=0, busy=(), flag1fa=0, events={}, seed=0x5EED)
        try:
            run = setup(sc, x, nat)
            x.expect_fatal = 0x50CA3E
            nat.events()
            fatal = False
            try:
                x.dispatch()
            except d9.Fatal:
                fatal = True
            x.expect_fatal = None
            site = FATAL_SITES.get(x.fatal_site, hex(x.fatal_site or 0))
            if not fatal:
                raise Mismatch('%s: the original did not reach the load failure message' % sc['id'])
            if site != kind:
                raise Mismatch('%s: the original failed at %s, expected %s' % (sc['id'], site, kind))
            stats['fatal_sites'][site] += 1
            status, done, reset, phase, disp = nat.visit(sc['rows'][0]['body'], 2, 0, 0)
            if status == 0:
                raise Mismatch('%s: the original prints a message and the native kernel accepted the file' % sc['id'])
            n = nat.object()
            if n['iv'] or n['record'] != -1:
                raise Mismatch('%s: the native refusal left a file loaded' % sc['id'])
            if nat.lib.a1co_stream_open(nat.h) or nat.lib.a1co_opens(nat.h) != nat.lib.a1co_closes(nat.h):
                raise Mismatch('%s: the native refusal left the file open' % sc['id'])
            if nat.live() != nat.expected_live(0):
                raise Mismatch('%s: the native refusal leaked %d blocks' % (sc['id'], nat.live() - nat.expected_live(0)))
            if status != 2 or not nat.lib.a1co_failure(nat.h).startswith(b'the .IV file'):
                raise Mismatch('%s: refusal status %d text %r' % (sc['id'], status, nat.lib.a1co_failure(nat.h)))
            if nat.lib.a1co_visits(nat.h) != 0:
                raise Mismatch('%s: a refused visit was counted' % sc['id'])
            stats['refusals'] += 1
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
            if fail_fast:
                break
    # z table full: the original reports it and returns -1, the kernel refuses
    sc = Sc(id='refuse:z_full', rows=[R1C(render=1)], actions=[], group='refusal', files={b'CLIP': good_file()}, quick=False, mode=3, first=0,
            player=dict(state=2, name=b'CLIP', hotspot=-1, origin=None), cell=0, busy=tuple(range(0x18, 0x40)), flag1fa=0, events={}, seed=0x5EED)
    try:
        run = setup(sc, x, nat)
        x.expect_fatal = 0x52139C
        fatal = False
        try:
            x.dispatch()
        except d9.Fatal:
            fatal = True
        x.expect_fatal = None
        if not fatal or FATAL_SITES.get(x.fatal_site) != 'z-full':
            raise Mismatch('refuse:z_full: the original did not report the full z table')
        status = nat.visit(sc['rows'][0]['body'], 2, 0, 0)[0]
        if status == 0:
            raise Mismatch('refuse:z_full: the native kernel accepted a full z table')
        if status != 2 or nat.lib.a1co_failure(nat.h) != b'raw-0x1c host callback failed':
            raise Mismatch('refuse:z_full: status %d text %r' % (status, nat.lib.a1co_failure(nat.h)))
        if nat.live() != nat.expected_live(native_table_blocks(nat)):
            raise Mismatch('refuse:z_full: leaked blocks')
        stats['fatal_sites']['z-full'] += 1
        stats['refusals'] += 1
    except (Mismatch, d9.OracleError) as error:
        bad.append(('refuse:z_full', str(error)))
    return bad


def good_file():
    return iv_file(name33(b'CLIP'), [entry(5, std_rects(2)), entry(9, std_rects(1, 100))])


def native_limit_checks(x, nat, stats):
    """Files the original loads without complaint that the kernel refuses by its documented limits."""
    bad = []
    big_entries = [entry(i, [rect(i, i, i + 1, i + 1)]) for i in range(4097)]
    big_rects = [entry(1, [rect(i, i, i + 1, i + 1) for i in range(4097)])]
    for rid, data in (('4097_entries', iv_file(name33(b'CLIP'), big_entries)), ('4097_rects', iv_file(name33(b'CLIP'), big_rects)),
                      ('4096_entries_ok', iv_file(name33(b'CLIP'), big_entries[:4096])), ('4096_rects_ok', iv_file(name33(b'CLIP'), [entry(1, big_rects[0]['rects'][:4096])]))):
        sc = Sc(id='limit:' + rid, rows=[R1C()], actions=[], group='limit', files={b'CLIP': data}, quick=False, mode=3, first=0,
                player=dict(state=2, name=b'CLIP', hotspot=-1, origin=None), cell=0, busy=(), flag1fa=0, events={}, seed=1)
        try:
            run = setup(sc, x, nat)
            x.dispatch()                                # the original loads it
            if x.table() is None:
                raise Mismatch('%s: the original did not load the file' % sc['id'])
            nat.events()
            status = nat.visit(sc['rows'][0]['body'], 2, 0, 0)[0]
            ok = rid.endswith('_ok')
            if ok != (status == 0):
                raise Mismatch('%s: native status %d where the limit says %s' % (sc['id'], status, 'accept' if ok else 'refuse'))
            if ok:
                compare_object(sc['id'], run, stats)
            stats['limits'][rid] += 1
        except (Mismatch, d9.OracleError) as error:
            bad.append((sc['id'], str(error)))
    return bad


def host_failure_checks(x, nat, stats):
    """A failing host call at every position of a full life cycle: the binding reports an error and never crashes or keeps a file open."""
    bad = []
    sc = Sc(id='hostfail', rows=[R1C(render=1)], actions=[], group='refusal', files={b'CLIP': good_file()}, quick=False, mode=3, first=0,
            player=dict(state=2, name=b'CLIP', hotspot=5, origin=(3, 4)), cell=7, busy=(), flag1fa=0, events={}, seed=2)
    body = sc['rows'][0]['body']
    calls = 0
    for n in range(1, 80):
        try:
            run = setup(sc, x, nat)
            nat.lib.a1co_fail_after(nat.h, n)
            statuses, text = [], None
            for ph in (0, 1, 2):
                statuses.append(nat.visit(body, 2, 0, ph)[0])
                if statuses[-1] != 0 and text is None:
                    text = nat.lib.a1co_failure(nat.h)         # the text of the visit that failed, before a later visit overwrites it
            if not nat.lib.a1co_failed(nat.h):
                calls = n - 1
                break
            if all(s == 0 for s in statuses):
                raise Mismatch('hostfail %d: no refusal although a host call failed' % n)
            if nat.lib.a1co_stream_open(nat.h):
                raise Mismatch('hostfail %d: file left open' % n)
            if nat.live() != nat.expected_live(native_table_blocks(nat)):
                raise Mismatch('hostfail %d: leaked blocks' % n)
            kind = nat.lib.a1co_failed_kind(nat.h)
            want = b'the .IV file is missing or malformed (the original shuts the game down)' if kind in (5, 6) else b'raw-0x1c host callback failed'
            if text != want and not (text is None and kind not in (5, 6)):
                raise Mismatch('hostfail %d (kind %d): failure text %r' % (n, kind, text))
            stats['refusals'] += 1
        except Mismatch as error:
            bad.append(('hostfail %d' % n, str(error)))
    stats['limits']['host_failure_positions'] = calls
    return bad


def argument_checks(x, nat, stats):
    bad = []
    nat.new()
    lib = nat.lib
    try:
        for which in range(5):
            if lib.a1co_kernel_null(nat.h, which) != 1:
                raise Mismatch('kernel argument check %d did not return C1C_ERR_ARGUMENT' % which)
        if lib.a1co_create_null() != 0:
            raise Mismatch('session_a1c_create(NULL) did not fail')
        nb = make_body(b'CLIP', 0, 1)
        for which in range(1, 5):
            if lib.a1co_binding_null(nat.h, which, nb, len(nb)) != 2:      # SCENE_ACTION_HANDLER_ERROR
                raise Mismatch('binding argument check %d did not return ERROR' % which)
        if lib.a1co_render_corrupt() != 4:
            raise Mismatch('render of a changed object without a current entry did not return C1C_ERR_BODY with count 0')
        for which in range(3):
            if lib.a1co_render_null(nat.h, which) != 1:
                raise Mismatch('render argument check %d did not return C1C_ERR_ARGUMENT' % which)
        nat.new()
        for omit in range(1, 12):
            if lib.a1co_kernel_omit(nat.h, omit) != 1:
                raise Mismatch('kernel call without host callback %d did not return C1C_ERR_ARGUMENT' % omit)
        if lib.a1co_accessors_null() != 0:
            raise Mismatch('NULL accessors misbehave (%d)' % lib.a1co_accessors_null())
        count = C.c_size_t(99)
        if lib.a1co_render_cap0(nat.h, C.byref(count)) != 0 or count.value != 0:
            raise Mismatch('render with capacity 0 and no fills array failed')
        body = make_body(b'CLIP', 0, 1)
        nat.add_file(b'CLIP', good_file())              # a loadable file, so that only the type check can refuse the row
        nat.set_player(2, b'CLIP', 5, None)
        if lib.a1co_wrong_type(nat.h, 0x1D, body, len(body)) != 2 or lib.a1co_opens(nat.h) != 0:
            raise Mismatch('a row of another raw type was not refused before any effect')
        if lib.a1co_kernel_unterminated(nat.h) != 3:
            raise Mismatch('a body without a NUL was not refused as C1C_ERR_FILE')
        if lib.a1co_free_iv_record() != 0:
            raise Mismatch('c1c_free_iv left a dangling record')
        # D5 (native-only; the original reads past the 33 bytes): names equal over all 33 bytes without a NUL are equal, a difference in the last byte is not
        for pname, want in ((b'A' * 33, 1), (b'A' * 32 + b'B', 0)):
            nat.new()
            nat.add_file(b'CLIP', iv_file(b'A' * 33, [entry(5, std_rects(1))]))
            nat.set_player(2, pname, 5, None)
            res = nat.visit(body, 2, 0, 0)
            if res[0] != 0 or res[3] != want:
                raise Mismatch('33-byte name without NUL: native phase %d, expected %d' % (res[3], want))
        nat.new()
        nat.add_file(b'CLIP', good_file())
        nat.set_player(2, b'CLIP', 5, None)
        # a failure followed by a success on one binding: the failure text goes back to "none"
        nat.new()
        nat.set_player(2, b'CLIP', 5, None)
        if nat.visit(body, 2, 0, 0)[0] != 2 or not nat.lib.a1co_failure(nat.h).startswith(b'the .IV file'):
            raise Mismatch('a missing file was not refused as ERROR with the file text')
        nat.add_file(b'CLIP', good_file())
        if nat.visit(body, 2, 0, 0)[0] != 0 or nat.lib.a1co_failure(nat.h) != b'none':
            raise Mismatch('a success after a failure did not reset the failure text to "none"')
        nat.new()
        for omit in range(1, 12):
            nat.new(omit)
            nat.add_file(b'CLIP', good_file())
            nat.set_player(2, b'CLIP', 5, None)
            before = nat.lib.a1co_opens(nat.h)
            status = nat.visit(body, 2, 0, 0)[0]
            if status != 1 or nat.events() or nat.lib.a1co_opens(nat.h) != before or nat.lib.a1co_failure(nat.h) != b'movie player, .IV file or z entry provider':
                raise Mismatch('omitted host callback %d: status %d, effects %d' % (omit, status, 0))
        nat.new()
        for raw, what in ((body[:104], 'short body'), (body + bytes(7), 'tail not a multiple of 16'), (b'', 'empty body')):
            if nat.visit(raw, 2, 0, 0)[0] != 2 or nat.events() or nat.lib.a1co_failure(nat.h) != b'invalid raw-0x1c body':
                raise Mismatch('%s was not refused as ERROR before any effect' % what)
        unterminated = bytes([0x41]) * BODY_BYTES
        nat.add_file(b'A' * 105, good_file())
        nat.set_player(2, b'CLIP', 5, None)
        if nat.visit(unterminated, 2, 0, 0)[0] != 2 or nat.object()['iv']:
            raise Mismatch('an unterminated name was not refused')
        stats['refusals'] += 11 + 5 + 4 + 3 + 11 + 3 + 2
        # open_iv answering with a file but a failure code, or success without a file, must be refused with the file closed
        for quirk in (1, 2):
            nat.new()
            nat.add_file(b'CLIP', good_file())
            nat.set_player(2, b'CLIP', 5, None)
            nat.lib.a1co_set_open_quirk(nat.h, quirk)
            if nat.visit(body, 2, 0, 0)[0] == 0 or nat.lib.a1co_stream_open(nat.h) or nat.object()['iv']:
                raise Mismatch('open_iv quirk %d was not refused cleanly' % quirk)
        # a failing allocation at each position of the load leaves nothing allocated and nothing open
        for n in range(1, 12):
            nat.new()
            nat.add_file(b'CLIP', good_file())
            nat.set_player(2, b'CLIP', 5, None)
            nat.lib.a1co_fail_alloc_after(n)
            status = nat.visit(body, 2, 0, 0)[0]
            failed = nat.lib.a1co_alloc_failed()
            nat.lib.a1co_fail_alloc_after(0)
            if not failed:
                break
            if status == 0 or nat.lib.a1co_stream_open(nat.h) or nat.object()['iv']:
                raise Mismatch('allocation failure %d: status %d, stream open %d' % (n, status, nat.lib.a1co_stream_open(nat.h)))
            if n == 1 and nat.lib.a1co_failure(nat.h) != b'raw-0x1c host callback failed':
                raise Mismatch('allocation failure of the file record reported %r' % nat.lib.a1co_failure(nat.h))
            if nat.live() != nat.expected_live(native_table_blocks(nat)):
                raise Mismatch('allocation failure %d: leaked blocks' % n)
            stats['refusals'] += 1
        # a successful visit leaves "none" as the failure text, a fresh binding too
        nat.new()
        if nat.lib.a1co_failure(nat.h) != b'none':
            raise Mismatch('a fresh binding does not report "none"')
        nat.add_file(b'CLIP', good_file())
        nat.set_player(2, b'CLIP', 5, None)
        if nat.visit(body, 2, 0, 0)[0] != 0 or nat.lib.a1co_failure(nat.h) != b'none':
            raise Mismatch('a successful visit did not leave "none"')
    except Mismatch as error:
        bad.append(('arguments', str(error)))
    return bad


LIB_PATH = [None]
CHILD = [False]


def run_isolated(sc, stats):
    """Scenarios that may crash a defective kernel run in a child process, so that a crash is reported as a mismatch."""
    cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(LIB_PATH[0]), '--only', sc['id'], '--no-refusals', '--child']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode < 0:
        raise Mismatch('%s: the native kernel crashed (signal %d) running the scenario' % (sc['id'], -done.returncode))
    if done.returncode != 0:
        line = next((l for l in done.stdout.splitlines() if l.startswith('MISMATCH')), done.stderr[-300:])
        raise Mismatch(line.split(' :: ', 1)[-1])
    stats['scenarios'] += 1
    g = stats['groups'].setdefault(sc['group'], Counter())
    g['scenarios'] += 1


def run_list(x, nat, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            if sc.get('isolate') and not CHILD[0]:
                run_isolated(sc, stats)
                continue
            run_scenario(x, nat, sc, stats)
        except (Mismatch, d9.OracleError, d9.Fatal) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


def merge(a, b):
    out = dict(a)
    for k, v in b.items():
        if isinstance(v, dict) and k in out and isinstance(out[k], dict):
            out[k] = merge(out[k], v)
        elif isinstance(v, (int, float)) and k in out and isinstance(out[k], (int, float)) and k != 'seconds':
            out[k] = out[k] + v
        elif k not in out:
            out[k] = v
    return out


def to_plain(stats):
    out = {}
    for k, v in stats.items():
        out[k] = {kk: dict(vv) if isinstance(vv, Counter) else vv for kk, vv in v.items()} if isinstance(v, (dict, Counter)) else v
    return out


def discover_pins(x, blocks):
    import bisect
    starts = sorted(int(k, 16) for k in json.load(open(ROOT / 'work/rt57/pseudo.json')))
    funcs = {}
    for a, sz in blocks:
        i = bisect.bisect_right(starts, a) - 1
        funcs[starts[i]] = starts[i + 1]
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
    return 'PINS_TABLE = (\n' + ''.join('    (%#x, %#x, %r),\n' % t for t in out) + ')'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='')
    ap.add_argument('--skip-group', action='append', default=[])
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--workers', type=int, default=1)
    ap.add_argument('--shard', default='', help='internal: k/N')
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--no-refusals', action='store_true')
    ap.add_argument('--refusals-only', action='store_true', help='run only the native-only refusal / limit / host-failure / argument checks')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    ap.add_argument('--sanitize', action='store_true')
    ap.add_argument('--child', action='store_true', help='internal: run isolated scenarios in this process')
    args = ap.parse_args()
    CHILD[0] = args.child
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-57.1c.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.skip_group:
        scs = [s for s in scs if s['group'] not in args.skip_group]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.refusals_only:
        scs = []
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_1c.so', strict=not args.lenient_build, sanitize=args.sanitize)
        procs = []
        for k in range(args.workers):
            res = work / ('shard%d.json' % k)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--shard', '%d/%d' % (k, args.workers),
                   '--result', str(res), '--show', str(args.show)]
            for flag in ('--fail-fast', '--quick-only', '--no-refusals'):
                if getattr(args, flag[2:].replace('-', '_')):
                    cmd.append(flag)
            for g in args.skip_group:
                cmd += ['--skip-group', g]
            if args.only:
                cmd += ['--only', args.only]
            procs.append((res, subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)))
        merged, bad_lines, code = None, [], 0
        for res, p in procs:
            out, err = p.communicate()
            code |= p.returncode
            bad_lines += [l for l in out.splitlines() if l.startswith('MISMATCH')]
            if err.strip():
                print(err[-600:], file=sys.stderr)
            if res.exists():
                data = json.loads(res.read_text())
                merged = data['stats'] if merged is None else merge(merged, data['stats'])
        for l in bad_lines[:args.show]:
            print(l)
        if merged is None:
            print('no shard result')
            return 1
        merged['seconds'] = round(time.monotonic() - started, 1)
        merged['workers'] = args.workers
        print(json.dumps(merged, sort_keys=True, default=str))
        if args.result:
            args.result.parent.mkdir(parents=True, exist_ok=True)
            args.result.write_text(json.dumps(dict(slice='RT-57', item='0x1c', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_1c.so', strict=not args.lenient_build, sanitize=args.sanitize)
    LIB_PATH[0] = lib_path
    nat = Native(lib_path)
    x = Oracle()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast)
    if not args.only and not args.no_refusals and shard_k == 0 and not (bad and args.fail_fast):
        for fn in (refusal_checks, native_limit_checks, host_failure_checks, argument_checks):
            try:
                found = fn(x, nat, stats)
            except (Mismatch, d9.OracleError, d9.Fatal) as error:
                found = [(fn.__name__, str(error))]
            for sid, msg in found:
                bad.append((sid, msg))
                stats['mismatches'] += 1
    if args.discover_pins:
        print(discover_pins(x, blocks))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:900])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = to_plain(stats)
    summary['seconds'] = round(time.monotonic() - started, 1)
    if not args.shard:
        print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-57', item='0x1c', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    try:
        nat.close()
    except Mismatch as error:
        bad.append(('close', str(error)))
        print('MISMATCH close ::', error)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
