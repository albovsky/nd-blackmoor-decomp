#!/usr/bin/env python3
"""RT-58: immutable x86 dispatcher 0x427a50 / handler 0x42fc70 (raw 0x76, the PASSWORD puzzle), the character message handler 0x437dcd
with the key filter 0x437ea1, the pointer block 0x4f04b6..0x4f05a3 of the cascade 0x4f0059, the click block 0x43beeb..0x43bf2c of
0x43a7ca, the invalidate block 0x43d89a..0x43d8af of 0x43d7f0, the scene cleanup block 0x43ddde..0x43ddef of 0x43dbe3, the new-game block
0x43729f..0x4372a6 of 0x435015 and the render callback 0x4d07e7 versus the native kernel src/action_family_76_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x76 (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42902c, the handler
0x42fc70 with every phase (0 init, 1 with the inner states 0 field 1 / 1 field 2 / 2 wrong sound / 3 success wait / 4 wrong wait /
5 success sound / others, 2 finish) and the generic completion 0x42ba3a. The helpers run as ORIGINAL code: 0x50d0bc (case conversion at
0x63cb1c == 0), 0x50d8e0 (strstr), 0x430b9a (cursor blink), 0x437ea1 (key filter), 0x42ba3a, 0x423d33. The key function 0x437dcd runs as
a whole (the three other-puzzle methods it calls are stubbed and recorded), the other pieces run as BLOCKS of the original functions
(begin and end addresses above, registers set to garbage, the same process image).

Native side: tests/action_family_76_runtime_oracle_driver.c links ONLY the kernel and implements the HOST side of the PwdHost contract with
scripted queues (GetTickCount values, sound busy results), the view origin, a deterministic text width function, the event flag window
and the scene-change cells. The driver decides nothing the kernel decides. It keeps two logs, the observer log (PwdHost.observe) and the
host-call log (what the kernel really asked of the host); the oracle requires them to agree.

Compared after EVERY action (dispatcher pass, key, pointer, click, invalidate, cleanup, new game, render):
 * the whole 0x86-byte state image 0x5b616b..0x5b61f1 byte for byte against PwdState;
 * the start flag 0x5bb1ca, the entry flag dword 0x5d1c01, the engine mode 0x583999, the seven scene-change cells, the whole event flag
   window (4096 dwords at 0x585801), the candidate 0x5c39e5, the cursor cells 0x5b44f0 / 0x5b44f4 and the whole generic Z entry table
   (0x58 entries of 0x4a bytes: it contains 0x5d1c01 and the host-composed cursor cells 0x5d162d / 0x5d1631 / 0x5d1639 and the
   background surface 0x5d15e3) against a model built from the native outputs;
 * every byte of every row (except the dependency record the gate and the reset own) and every row body against a model;
   every write outside the modelled cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, the start flag,
   font calls, the entry flag, GetTickCount, the row phase stores, the text widths, the sound calls, the scene cells, the engine mode,
   the event flag window, the completion) against the sequence the native kernel reports for the same visit, entry for entry; the
   scripted queues are consumed identically by both sides;
 * key: the stored / refused outcome (through the state image) and the three stubbed calls of the original; pointer: the claim, the
   candidate and the cursor cells; click: the cancel flag and the row phase it stores; render: every recorded 0x4c5377 blit (this, source
   surface, rectangle contents, target, label) and every 0x4d2c20 text draw (string, font tables, x / y words, colour, target) in order;
 * the key filter over all 256 bytes through the real key function and directly through 0x437ea1.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N`
and returns), S = stub of another puzzle's method, G = raising guard.
  R 0x4c924d / 0x4c92c5 font acquire / release (ECX 0x5cf659, ret 4)   R 0x4d3836 text width (cdecl; scripted deterministic function of the
  string and the font, the same function in the driver)   R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)
  R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4, scripted queue)   R 0x4c5377 background blit (ECX 0x5cf659, ret 0x14)   R 0x4d2c20 text draw
  (cdecl, 8 args)   R GetTickCount (import stub) scripted values   S 0x4a1f59 / 0x48e93e / 0x4b8193 (ECX constants, ret 4)
  G 0x4c97b4 0x42639d 0x52139c 0x44a2b7 0x4264e8: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0 and 0x63cb1c is 0 (C locale; checked at start-up), 0x5e32c9 is 0 (the other branch of 0x437dcd is not entered).

KNOWN STAND-INS AND LIMITS (never silently skipped; native refusals are checked natively in refusal_checks()):
  N1 pwd_validate_body: a short or long body, a font index outside 0..17, a count outside 0..5, unterminated words / sound names ->
     PWD_ERR_BODY, no effect. The oracle's bodies satisfy it (the original trusts the loader).
  N2 phase 1 or 2 on a state that phase 0 did not initialise for the row -> PWD_ERR_UNSUPPORTED, no effect; phase > 2 likewise.
  N3 an event flag index outside 0..4095 (not -1) in the finish block -> PWD_ERR_UNSUPPORTED before the first effect.
  N4 a host failure after effects -> PWD_ERR_HOST (the original has no recovery).
  N5 the oracle keeps text widths in a 16-bit result and the colour table index in 0..17 (fonts 0..17, as validated).
 Not modelled / unverified: the real font surface acquire / release, the sound engine, the blit body 0x4c5377, the text routine 0x4d2c20,
 the real text width 0x4d3836 (replaced by the scripted function), the cascade 0x4f0059 / accepted-release chain 0x43a7ca / scene clears
 0x43dbe3 / new-game caller 0x435015 around the blocks (the blocks are run, not the callers), the loader 0x40dff4 that builds the body, the
 engine consumers of the scene-change cells, the host composition of the cursor cells (their documented composition is checked), the other
 callees of 0x437dcd (stubbed), the LCMapStringA branch of 0x50d0bc.

Modes: --quick-only runs the scenarios flagged quick; the default run is every scenario plus the native-only refusal checks; --workers N
shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does this);
--discover-pins prints the PINS_TABLE of the original code the scenarios execute (the pins are verified at start-up); --sanitize [ub|asan] builds
the driver with UBSan (ASan cannot load next to capstone's RTLD_DEEPBIND library, see build_driver). The planted-mutant sweep is tests/action_family_76_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_76_runtime_original_oracle.py --quick-only
  python3 action_family_76_runtime_original_oracle.py --workers 4 --result ../../../work/rt58/RT-58.oracle-result.json
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps
from action_family_20_70_80_runtime_original_oracle import (BODY_OFF, COMPLETE_OFF, DEP_HI, DEP_LO, GAP_OFFS, LOADED_OFF, MAX_ROWS,
                                                           REQ_OFF, TYPE_OFF, UNLOADED_OFF, WORD_OFF, event_tail, gate_open, mask, s16,
                                                           sgn)

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32
ROWS, ROW, PHASE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF
EVENTS_VA = d9.EVENTS_VA
EVENT_COUNT = 4096
BODY_LEN = 575
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF
RESOURCES = ROOT / 'work/analysis/hiff-resources'
CORPUS = ROOT / 'work/analysis/slices/A-76.1.corpus.json'

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x42FC70, 0x42BA3A, 0x423D33, 0x42BABE
ARM = {0x76: 0x42902C, 0x67: 0x428692}
VISIT = {0x76: 0x429050, 0x67: 0x4286B5}
KEY_FN, KEY_FILTER, KEY_THIS = 0x437DCD, 0x437EA1, 0x583208
KEY_STUBS = {0x4A1F59: 0x61D2DD, 0x48E93E: 0x624DC9, 0x4B8193: 0x61EE6E}
POINTER_BEGIN, POINTER_MISS, POINTER_HIT = 0x4F04B6, 0x4F05A3, 0x4F2578
CLICK_BEGIN, CLICK_END = 0x43BEEB, 0x43BF2C
INVAL_BEGIN, INVAL_END = 0x43D89A, 0x43D8AF
CLEAN_BEGIN, CLEAN_END = 0x43DDDE, 0x43DDEF
NEWGAME_BEGIN, NEWGAME_END = 0x43729F, 0x4372A6
RENDER = 0x4D07E7
FONT_ACQUIRE, FONT_RELEASE, TEXT_WIDTH, TEXT_DRAW, BLIT = 0x4C924D, 0x4C92C5, 0x4D3836, 0x4D2C20, 0x4C5377
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
GUARD_ADDRS = [0x4C97B4, 0x42639D, 0x52139C, 0x44A2B7, 0x4264E8]

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
STATE, STATE_LEN = 0x5B616B, 0x86
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_ENTRY_FLAG = 0x5D1C01
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_VIEW = 0x583186
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
COLOUR_TABLE = 0x5D032F
FONT_TABLE1, FONT_TABLE2 = 0x5A4C24, 0x5ADB3A
CELL_LOCALE, CELL_KEYMODE = 0x63CB1C, 0x5E32C9
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY = 0x5CF659, 0x5C3A67, 0x5CF1EB
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
BLIT_LABEL_VA = 0x55A004
BLIT_LABEL = b'PASSWORD Puzzle Background pSrcSurface'
NO_SOUND_VAS = (0x545C38, 0x545C44)
NO_SOUND = b'NO SOUND\0'
CAND_CANCEL = 0x2724
SCRATCH = 0x20180000
EVENT_PTR = SCRATCH + 0x100
CHAR_PTR = SCRATCH + 0x200
FRAME = deps.STACK_TOP - 0x2000

# the numbers of PwdEffect
FX = dict(START_FLAG=1, FONT_ACQUIRE=2, FONT_RELEASE=3, ENTRY_VISIBLE=4, TICK=5, PHASE=6, TEXT_WIDTH=7, SOUND_PREPARE=8, SOUND_PLAY=9,
          SOUND_BUSY=10, SOUND_STOP=11, X57B=12, X599=13, X595=14, X39FF=15, X59B=16, X59F=17, X5A3=18, MODE=19, EVENT_FLAG=20, COMPLETE=21)
FXN = {v: k for k, v in FX.items()}
FX_SIZE = {FX['FONT_ACQUIRE']: (2, 4), FX['FONT_RELEASE']: (2, 4), FX['TEXT_WIDTH']: (2, 4), FX['SOUND_PLAY']: (2, 4),
           FX['SOUND_BUSY']: (2, 4), FX['X599']: (2, 4), FX['X595']: (2, 4), FX['X39FF']: (2, 4), FX['EVENT_FLAG']: (2, 4),
           FX['COMPLETE']: (2, 4)}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_ENTRY_FLAG: (FX['ENTRY_VISIBLE'], 4), CELL_MODE: (FX['MODE'], 4),
            0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2), 0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2),
            0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4), 0x5BB5A3: (FX['X5A3'], 4)}
HOST_FX = {FX[k] for k in ('FONT_ACQUIRE', 'FONT_RELEASE', 'TICK', 'TEXT_WIDTH', 'SOUND_PREPARE', 'SOUND_PLAY', 'SOUND_BUSY', 'SOUND_STOP',
                           'X57B', 'EVENT_FLAG')}
HC_VIEW = 100

FAR_ROWS = 0x1B0                     # row records up to this index are watched (the far-row actions use indices above the installed rows)
GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {FONT_ACQUIRE: (0x78, 4), FONT_RELEASE: (0x7B, 4), TEXT_WIDTH: (0x200, 0), SND_BUSY: (0x200, 4), TEXT_DRAW: (0x453, 0), BLIT: (0x214, 0x14),
             SND_PREPARE: (0x2EF, 4), SND_STOP: (0x1D, 4), SND_PLAY: (0xB4, 4), 0x4A1F59: (0x400, 4), 0x48E93E: (0x400, 4), 0x4B8193: (0x6C, 4)}
POPS = {FONT_ACQUIRE: 4, FONT_RELEASE: 4, TEXT_WIDTH: 0, TEXT_DRAW: 0, BLIT: 0x14, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4,
        0x4A1F59: 4, 0x48E93E: 4, 0x4B8193: 4}
WANT_ECX = {FONT_ACQUIRE: THIS_SURF, FONT_RELEASE: THIS_SURF, BLIT: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            SND_BUSY: THIS_BUSY, 0x4A1F59: 0x61D2DD, 0x48E93E: 0x624DC9, 0x4B8193: 0x61EE6E}

# state image offsets (PwdState)
S_PENDING, S_KEY, S_FIELD1, S_FIELD2, S_ACTIVE, S_ROW, S_CANCEL, S_WRONG, S_STATE, S_BLINK, S_CORRECT, S_DEADLINE = (
    0x00, 0x01, 0x02, 0x23, 0x44, 0x45, 0x47, 0x48, 0x49, 0x4D, 0x51, 0x52)
S_RECT_BG, S_RECT_F1, S_RECT_F2 = 0x56, 0x66, 0x76

# Executed original code, as SHA-256 of the unmodified image bytes. Discovered over every scenario with --discover-pins, verified at start-up.
PINS_TABLE = (
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x76 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('tick', 'busy')}
        self.qpos = Counter()
        self.in_complete = False
        self.recording = False
        self.width_k, self.width_add = 1, 0
        self.garbage = random.Random(1)
        self.stop_hit = None
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))
        self._check_hook_rets()
        self._check_constants()
        self.clear_logs()

    def _check_hook_rets(self):
        from capstone import CS_ARCH_X86, CS_MODE_32, Cs
        md = Cs(CS_ARCH_X86, CS_MODE_32)
        base = self.pe.image_base
        for a, (span, imm) in HOOK_RETS.items():
            rets = set()
            for i in md.disasm(self.pristine[a - base:a - base + span], a):
                if i.mnemonic == 'ret':
                    rets.add(int(i.op_str, 0) if i.op_str else 0)
                    break
            if rets != {imm}:
                raise d9.OracleError('hooked function %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def _check_constants(self):
        base = self.pe.image_base

        def img(va, n):
            return bytes(self.pristine[va - base:va - base + n])
        want = [(va, NO_SOUND) for va in NO_SOUND_VAS] + [(BLIT_LABEL_VA, BLIT_LABEL + b'\0')]
        for va, data in want:
            if img(va, len(data)) != data:
                raise d9.OracleError('image constant at %#x differs from the kernel assumption' % va)
        for va, n in ((CELL_LOCALE, 4), (CELL_KEYMODE, 4), (0x63A4CD, 2)):
            if img(va, n) != bytes(n):
                raise d9.OracleError('process cell %#x is not zero in the image' % va)

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.blits = []
        self.texts = []
        self.in_complete = False
        self.stop_hit = None

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in ('tick', 'busy')}
        self.qpos = Counter()

    def pop(self, kind):
        i = self.qpos[kind]
        if i >= len(self.qs[kind]):
            raise d9.OracleError('script underflow: %s queue' % kind)
        self.qpos[kind] += 1
        return self.qs[kind][i] & M32

    # -- imports ---------------------------------------------------------------------------------
    def _on_import(self, uc, address, size, user):
        name, _iat = self.imports[address]
        if name == 'GetTickCount':
            v = self.pop('tick')
            self.events.append(('fx', FX['TICK'], v, 0))
            self._ret(uc, 0, v)
            self.counters['os:' + name] += 1
            return
        super()._on_import(uc, address, size, user)

    # -- hooks -------------------------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        table = {a: self._replaced for a in POPS}
        table.update({HANDLER: self._handler, GENERIC_COMPLETION: self._complete, GENERIC_RET: self._complete_done,
                      DEP_RESET: self._reset_seen, POINTER_HIT: self._stop_here})
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a in GUARD_ADDRS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=DATA_REGION_LO, end=DATA_REGION_HI)

    def row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _mk_event(self, kind, typ):
        def run(uc, address, size, user):
            self.events.append((kind, typ, self.row_at_arm(uc)))
        return run

    def _stop_here(self, uc, address, size, user):
        if self.mode == 'block':
            self.stop_hit = address
            uc.emu_stop()

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.events.append(('handler', row, self.row_phase(row)))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.events.append(('fx', FX['COMPLETE'], row & 0xFFFF, 0))
        self.in_complete = True

    def _complete_done(self, uc, address, size, user):
        self.in_complete = False

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('reset', (u32(uc, sp + 4) - 0x5BB5E9) // ROW))

    def body_ptr(self, pointer):
        """The body pointer of the row whose body contains `pointer` (the sound records are inside it)."""
        k = (pointer - d9.BODY_BASE) // BODY_STRIDE
        if not 0 <= k < MAX_ROWS:
            raise d9.OracleError('record %#x is not inside a row body' % pointer)
        return d9.BODY_BASE + BODY_STRIDE * k

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(8)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        if address in WANT_ECX and ecx != WANT_ECX[address]:
            raise d9.OracleError('hook %#x entered with ECX=%#x' % (address, ecx))
        if address in KEY_STUBS:
            self.events.append(('stub', address, a[0]))
        elif address in (FONT_ACQUIRE, FONT_RELEASE):
            self.events.append(('fx', FX['FONT_ACQUIRE'] if address == FONT_ACQUIRE else FX['FONT_RELEASE'], a[0] & 0xFFFF, 0))
        elif address == TEXT_WIDTH:
            font = (a[1] - FONT_TABLE1) // 0x7F3
            if not (0 <= font <= 17 and a[1] == FONT_TABLE1 + font * 0x7F3 and a[2] == FONT_TABLE2 + font * 0x1D0):
                raise d9.OracleError('text width called with unexpected font tables %#x %#x' % (a[1], a[2]))
            text = d9.cstr(self.rd(a[0], 40))
            width = text_width(self.width_k, self.width_add, font, text)
            self.events.append(('fx', FX['TEXT_WIDTH'], width & 0xFFFF, 0))
            eax = (width & 0xFFFF) | (self.garbage.getrandbits(16) << 16)
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['SOUND_BUSY'], a[0] & 0xFFFF, eax))
        elif address == TEXT_DRAW:
            self.texts.append(dict(text=d9.cstr(self.rd(a[0], 40)), arg1=a[1], arg2=a[2], x=a[3] & 0xFFFF, y=a[4] & 0xFFFF, colour=a[5],
                                   target=a[6], zero=a[7]))
            self.blits.append(('text', len(self.texts) - 1))
        elif address == BLIT:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label_ptr=a[4]))
        else:
            raise d9.OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    def _on_write(self, uc, access, address, size, value, user):
        if not self.recording:
            return
        value &= mask(size)
        if ROWS <= address < ROWS + FAR_ROWS * ROW and not 0x5C39E0 <= address < 0x5C3A10:   # (the candidate and 0x5c39ff cells lie inside the row array's address range)
            row, off = divmod(address - ROWS, ROW)
            if off == COMPLETE_OFF and size == 1:
                self.events.append(('comp', row, value))
            elif off == PHASE_OFF and size == 4:
                self.events.append(('gphase', row, value) if self.in_complete else ('fx', FX['PHASE'], value, 0))
            return                              # every other row byte is checked by the final image comparison
        if EVENTS_VA <= address < EVENTS_VA + 4 * EVENT_COUNT and size == 4 and (address - EVENTS_VA) % 4 == 0:
            self.events.append(('fx', FX['EVENT_FLAG'], (address - EVENTS_VA) // 4, value))
            return                              # the whole window is compared
        hit = WRITE_FX.get(address)
        if hit is not None and hit[1] == size:
            self.events.append(('fx', hit[0], value, 0))
        self.written['%#x/%d' % (address, size)] += 1

    # -- state access ----------------------------------------------------------------------------
    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def cell(self, va, size=4):
        return int.from_bytes(self.rd(va, size), 'little')

    def set_cell(self, va, value, size=4):
        self.wr(va, (value & mask(size)).to_bytes(size, 'little'))

    def state_image(self):
        return self.rd(STATE, STATE_LEN)

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
        self.mode = 'idle'
        self.expect_fatal = None
        self.recording = False
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.set_queues({})
        self.clear_logs()

    def install_rows(self, rows):
        total = len(rows)
        if total > MAX_ROWS or total * BODY_STRIDE > 0x10000:
            raise d9.OracleError('too many rows for the oracle storage')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i, r in enumerate(rows):
            base = ROWS + i * ROW
            body_at = d9.BODY_BASE + BODY_STRIDE * i
            if r['body'] is not None:
                self.wr(body_at, r['body'])
            self.wr(base + TYPE_OFF, bytes([r['type'], r['subtype']]) + struct.pack('<I', body_at if r['body'] is not None else 0))
            tail = r['tail'] or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(deps.ORIGINAL_LOADER, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base, bytes((i * 37 + k * 11 + 0x5A) & 0xFF for k in range(TYPE_OFF)))          # description garbage
            self.wr(base + GAP_OFFS[0], bytes((i * 29 + k * 7 + 0x33) & 0xFF for k in range(GAP_OFFS[1] - GAP_OFFS[0])))
            self.write_row_fields(i, r)
        self.wr(CELL_ROWCOUNT, struct.pack('<h', total))

    def write_row_fields(self, i, r):
        base = ROWS + i * ROW
        self.wr(base + TYPE_OFF, bytes([r['type']]))
        self.wr(base + COMPLETE_OFF, bytes([r['completed']]))
        self.w32(base + REQ_OFF, r['request'])
        self.w32(base + PHASE_OFF, r['phase'])
        self.wr(base + WORD_OFF, struct.pack('<H', r['word']))
        self.w32(base + UNLOADED_OFF, r['unloaded'])
        self.w32(base + LOADED_OFF, r['loaded'])
        self.w32(base + BODY_OFF, d9.BODY_BASE + BODY_STRIDE * i if r['body'] is not None else 0)

    def begin(self, queues):
        self.clear_logs()
        self.set_queues(queues)
        self.recording = True
        self.wr(0x5C3A47, bytes(4))

    def dispatch(self, queues):
        self.begin(queues)
        self.mode = 'step'
        try:
            self.call(DISPATCHER, [], 0)
        finally:
            self.mode = 'idle'
            self.recording = False

    def run_method(self, queues, address, args, ecx=0):
        self.begin(queues)
        try:
            eax, _ = self.call(address, args, ecx)
        finally:
            self.recording = False
        return eax

    def run_block(self, queues, begin, end, regs=None):
        """Run the instructions begin..end of an original function on a scratch frame (registers garbage), stopping at `end` or at the
        hit exit 0x4f2578. Returns the address it stopped at."""
        uc = self.machine
        self.begin(queues)
        self.mode = 'block'
        self._hook_error = None
        g = self.garbage
        for reg in (X.UC_X86_REG_EAX, X.UC_X86_REG_EBX, X.UC_X86_REG_ECX, X.UC_X86_REG_EDX, X.UC_X86_REG_ESI, X.UC_X86_REG_EDI):
            uc.reg_write(reg, g.getrandbits(32))
        uc.reg_write(X.UC_X86_REG_EBP, FRAME)
        uc.reg_write(X.UC_X86_REG_ESP, FRAME - 0x400)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        for reg, v in (regs or {}).items():
            uc.reg_write(reg, v)
        try:
            uc.emu_start(begin, end, timeout=60_000_000, count=0)
        except UcError as error:
            raise d9.OracleError('block %#x failed at %#x: %s' % (begin, uc.reg_read(X.UC_X86_REG_EIP), error)) from error
        finally:
            self.mode = 'idle'
            self.recording = False
        if self._hook_error:
            raise d9.OracleError(self._hook_error)
        eip = uc.reg_read(X.UC_X86_REG_EIP)
        if self.stop_hit is not None:
            return self.stop_hit
        if eip != end:
            raise d9.OracleError('block %#x stopped at %#x' % (begin, eip))
        return end


def text_width(k, add, font, text):
    """The text width stand-in (the same function as width_of() in the driver), as a signed 16-bit value."""
    total = sum(5 + (c % 7) + (font % 3) for c in text)
    return sgn(k * total + add, 2)


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
SOURCES = ('action_family_76_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5


def build_driver(src_dir, out, strict=True, sanitize=False):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O0', '-g', '-fPIC', '-fstack-protector-all', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_76_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if subprocess.run([cc, '-ftrivial-auto-var-init=pattern', '-x', 'c', '-c', '-o', os.devnull, os.devnull], capture_output=True).returncode == 0:
        cmd.insert(5, '-ftrivial-auto-var-init=pattern')       # an uninitialised local reads as a fixed non-zero pattern, so a missed initialisation shows
    kind = sanitize or os.environ.get('P76_SANITIZE')
    if kind == 'ub':                         # UBSan needs no runtime preload
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    elif kind:                               # ASan needs LD_PRELOAD=$(cc -print-file-name=libasan.so) and does not load next to capstone's DEEPBIND
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P, I32, U32, I64P, I32P, CP = C.c_void_p, C.c_int32, C.c_uint32, C.POINTER(C.c_int64), C.POINTER(C.c_int32), C.c_char_p
        lib.p76o_new.restype = P
        for name, args, res in (
                ('p76o_free', [P], None), ('p76o_reset', [P], None), ('p76o_clear_logs', [P], None), ('p76o_set_fail', [P, C.c_int], None),
                ('p76o_set_view', [P, I32, I32], None), ('p76o_set_width', [P, I32, I32], None), ('p76o_width_of', [P, I32, CP], I32),
                ('p76o_set_ticks', [P, I64P, C.c_int], None), ('p76o_set_busy', [P, I64P, C.c_int], None), ('p76o_queues', [P, I32P], None),
                ('p76o_state_get', [P, CP], None), ('p76o_state_set', [P, CP], None), ('p76o_cells_get', [P, I32P], None),
                ('p76o_cells_set', [P, I32P], None), ('p76o_events_get', [P, CP], None), ('p76o_events_set', [P, CP], None),
                ('p76o_log', [P, C.c_int, I32P, C.c_int], C.c_int),
                ('p76o_step', [P, CP, C.c_int, C.c_int, U32, I32P], None), ('p76o_step_ex', [P, CP, C.c_int, C.c_int, U32, C.c_int, I32P], None),
                ('p76o_null_checks', [P, CP, C.c_int, I32P], None), ('p76o_key', [P, C.c_int], C.c_int),
                ('p76o_constants', [I32P], None), ('p76o_step_msg', [P, CP, C.c_int, C.c_int, U32, C.c_int, CP, I32P], None),
                ('p76o_validate_msg', [CP, C.c_int, C.c_int, CP], C.c_int),
                ('p76o_key_filter', [C.c_int], C.c_int), ('p76o_pointer', [P, CP, C.c_int, I32, I32, I32P], None),
                ('p76o_click', [P, I32, I32P], None), ('p76o_invalidate', [P], C.c_int), ('p76o_cleanup', [P], None),
                ('p76o_new_game', [P], None), ('p76o_validate', [CP, C.c_int], C.c_int), ('p76o_render', [P, CP, C.c_int, I32P, CP], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.p76o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.p76o_free(self.h)

    def reset(self):
        self.lib.p76o_reset(self.h)

    def clear_logs(self):
        self.lib.p76o_clear_logs(self.h)

    def set_fail(self, n):
        self.lib.p76o_set_fail(self.h, n)

    def set_view(self, x, y):
        self.lib.p76o_set_view(self.h, sgn(x, 4), sgn(y, 4))

    def set_width(self, k, add):
        self.lib.p76o_set_width(self.h, k, add)

    def width_of(self, font, text):
        return self.lib.p76o_width_of(self.h, font, bytes(text))

    def set_queues(self, qs):
        for fn, key in ((self.lib.p76o_set_ticks, 'tick'), (self.lib.p76o_set_busy, 'busy')):
            vals = list(qs.get(key, []))[:8192]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            fn(self.h, arr, len(vals))

    def queues(self):
        arr = (C.c_int32 * 8)()
        self.lib.p76o_queues(self.h, arr)
        return list(arr)

    def state(self):
        buf = C.create_string_buffer(STATE_LEN)
        self.lib.p76o_state_get(self.h, buf)
        return bytes(buf.raw)[:STATE_LEN]

    def set_state(self, img):
        self.lib.p76o_state_set(self.h, bytes(img))

    def cells(self):
        arr = (C.c_int32 * 10)()
        self.lib.p76o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 10)(*[sgn(v, 4) for v in vals])
        self.lib.p76o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.p76o_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.p76o_events_set(self.h, bytes(data))

    def log(self, which):
        arr = (C.c_int32 * (3 * 16384))()
        n = self.lib.p76o_log(self.h, which, arr, 16384)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.p76o_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def step_ex(self, body, row, phase, no_observer):
        out = (C.c_int32 * 4)()
        self.lib.p76o_step_ex(self.h, bytes(body), len(body), row, phase & M32, no_observer, out)
        return tuple(out)

    def constants(self):
        out = (C.c_int32 * 44)()
        self.lib.p76o_constants(out)
        return list(out)

    def step_msg(self, body, row, phase, mode):
        buf = C.create_string_buffer(96)
        out = (C.c_int32 * 5)()
        self.lib.p76o_step_msg(self.h, bytes(body), len(body), row, phase & M32, mode, buf, out)
        return out[0], out[4], buf.value

    def validate_msg(self, body, mode):
        buf = C.create_string_buffer(96)
        rc = self.lib.p76o_validate_msg(bytes(body), len(body), mode, buf)
        return rc, buf.value

    def null_checks(self, body):
        out = (C.c_int32 * 27)()
        self.lib.p76o_null_checks(self.h, bytes(body), len(body), out)
        return list(out)

    def key(self, ch):
        return self.lib.p76o_key(self.h, ch if ch < 128 else ch - 256)

    def key_filter(self, ch):
        return self.lib.p76o_key_filter(ch if ch < 128 else ch - 256)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 4)()
        self.lib.p76o_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, candidate):
        out = (C.c_int32 * 4)()
        self.lib.p76o_click(self.h, sgn(candidate, 4), out)
        return tuple(out)

    def invalidate(self):
        return self.lib.p76o_invalidate(self.h)

    def cleanup(self):
        self.lib.p76o_cleanup(self.h)

    def new_game(self):
        self.lib.p76o_new_game(self.h)

    def validate(self, body):
        return self.lib.p76o_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * (2 + 14 * 3))()
        texts = C.create_string_buffer(34 * 3)
        self.lib.p76o_render(self.h, bytes(body), len(body), out, texts)
        ops = []
        for i in range(min(max(out[1], 0), 3)):
            o = list(out[2 + 14 * i:2 + 14 * (i + 1)])
            ops.append(dict(kind=o[0], src=tuple(o[1:5]), dst=tuple(o[5:9]), font=o[9], x=o[10], y=o[11], field=o[12],
                            text=d9.cstr(bytes(texts.raw[34 * i:34 * i + 34])), end=texts.raw[34 * i + 33], zero=o[13]))
        zeros = [out[2 + 14 * i + 13] for i in range(3)]
        return dict(status=out[0], count=out[1], ops=ops, zeros=zeros)


# ---------------------------------------------------------------------------------------------
# bodies (575 bytes)
# ---------------------------------------------------------------------------------------------
B_FONT, B_BLINK, B_RECT_F1, B_RECT_F2, B_RECT_BG = 0x000, 0x002, 0x004, 0x014, 0x024
B_COUNT_A, B_WORDS_A, B_COUNT_B, B_WORDS_B = 0x034, 0x036, 0x0DB, 0x0DD
B_CORRECT, B_SUCCESS_SOUND, B_SUCCESS_CH, B_WRONG, B_WRONG_SOUND, B_WRONG_CH, B_CANCEL, B_CANCEL_RECT = (
    0x182, 0x19B, 0x1BC, 0x1CC, 0x1E5, 0x206, 0x216, 0x22F)
WORD = 0x21


def snd(kind):
    return {'none': NO_SOUND, 'real': b'ding_1\0', 'real2': b'clunk_7\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0', 'nosound_tail': NO_SOUND + b'garbage\0'}[kind]


SND_KINDS = ('none', 'real', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4', 'nosound_tail')


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start, flag=flag, value=value)


def rand_block(rng, scene, flag=None):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)), rng.choice((-1, 0, 5, 340, 4095)) if flag is None else flag,
                 rng.choice((0, 1, 7, 0x80, 0xFF)))


def make_body(rng, font=3, blink=500, rect1=(100, 200, 300, 230), rect2=(100, 260, 300, 290), rect_bg=(10, 20, 640, 300), words_a=(b'KEY',),
              words_b=(), correct=None, wrong=None, cancel=None, snd_ok='none', snd_bad='none', ch_ok=1, ch_bad=2, cancel_rect=(0, 330, 619, 374),
              garbage=True):
    b = bytearray(rng.getrandbits(8) for _ in range(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    struct.pack_into('<hh', b, 0, font, blink)
    struct.pack_into('<4i', b, B_RECT_F1, *rect1)
    struct.pack_into('<4i', b, B_RECT_F2, *rect2)
    struct.pack_into('<4i', b, B_RECT_BG, *rect_bg)
    for off_count, off_words, words in ((B_COUNT_A, B_WORDS_A, words_a), (B_COUNT_B, B_WORDS_B, words_b)):
        struct.pack_into('<h', b, off_count, len(words))
        for k in range(5):
            w = words[k] if k < len(words) else b''
            slot = off_words + WORD * k
            b[slot:slot + WORD] = (bytes(w) + b'\0').ljust(WORD, b'\0') if k < len(words) or not garbage else b[slot:slot + WORD]
            if garbage and k >= len(words):
                b[slot + WORD - 1] = 0
            if garbage and k < len(words):
                tail = bytes(rng.getrandbits(8) for _ in range(WORD))
                b[slot + len(w) + 1:slot + WORD] = tail[len(w) + 1:]

    def put(off, blk):
        blk = blk or block(9999)
        struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, off + 20, sgn(blk['start'], 2))
        struct.pack_into('<h', b, off + 22, blk['flag'])
        b[off + 24] = blk['value'] & 0xFF
    put(B_CORRECT, correct)
    put(B_WRONG, wrong)
    put(B_CANCEL, cancel)
    for off, kind, ch_off, ch in ((B_SUCCESS_SOUND, snd_ok, B_SUCCESS_CH, ch_ok), (B_WRONG_SOUND, snd_bad, B_WRONG_CH, ch_bad)):
        data = snd(kind)
        b[off:off + len(data)] = data
        if 0 not in b[off:off + WORD]:
            b[off + WORD - 1] = 0
        struct.pack_into('<h', b, ch_off, ch)
    struct.pack_into('<4i', b, B_CANCEL_RECT, *cancel_rect)
    assert len(b) == BODY_LEN
    return bytes(b)


def patch(body, off, data):
    b = bytearray(body)
    b[off:off + len(data)] = data
    return bytes(b)


def body_info(body):
    w = lambda o: struct.unpack_from('<h', body, o)[0]  # noqa: E731
    words = lambda off, n: [d9.cstr(body[off + WORD * k:off + WORD * (k + 1)]) for k in range(n)]  # noqa: E731
    return dict(font=w(B_FONT), blink=w(B_BLINK), count_a=w(B_COUNT_A), count_b=w(B_COUNT_B), words_a=words(B_WORDS_A, w(B_COUNT_A)),
                words_b=words(B_WORDS_B, w(B_COUNT_B)), cancel_rect=struct.unpack_from('<4i', body, B_CANCEL_RECT),
                rect1=struct.unpack_from('<4i', body, B_RECT_F1), rect2=struct.unpack_from('<4i', body, B_RECT_F2))


_REAL = []


def real_rows():
    """The real raw-0x76 row (body, dependency tail, subtype) from the local evidence; [] when absent."""
    if not _REAL:
        out = []
        try:
            corpus = json.loads(CORPUS.read_text())
            for row in corpus['records']:
                data = (RESOURCES / ('%04d.bin' % row['resource_index'])).read_bytes()
                p, n = row['raw_body_offset'], row['raw_body_length']
                out.append((data[p:p + n], b'', row['subtype']))
        except (OSError, KeyError, ValueError):
            out = []
        _REAL.append(out)
    return _REAL[0]


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
STATE_RANGE = (STATE, STATE + STATE_LEN)
ENTRY_FLAG_RANGE = (CELL_ENTRY_FLAG, CELL_ENTRY_FLAG + 4)
EVENT_RANGE = (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT)
POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
ALLOWED_WRITES = {
    'tick': [STATE_RANGE, ENTRY_FLAG_RANGE, EVENT_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)]
    + [(va, va + sz) for _, va, sz in XFER],
    'key': [STATE_RANGE],
    'pointer': [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [STATE_RANGE],
    'render': [],
    'invalidate': [ENTRY_FLAG_RANGE],
    'cleanup': [STATE_RANGE, ENTRY_FLAG_RANGE],
    'new_game': [STATE_RANGE],
    'filter': [],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), keys=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0,
                queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(), outcomes=Counter(), filter_bytes=0,
                finishes=Counter(), texts=Counter(), blink=Counter())


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        if isinstance(a, list) and isinstance(b, list):
            k = next((i for i, (p, q) in enumerate(zip(a, b)) if p != q), min(len(a), len(b)))
            raise Mismatch('%s: %s differ at element %d of %d original / %d native: original %r native/model %r (context original %r)' % (
                where, what, k, len(a), len(b), a[k:k + 1], b[k:k + 1], a[max(0, k - 3):k]))
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def norm_fx(kind, a, b):
    sa, sb = FX_SIZE.get(kind, (4, 4))
    return ('fx', kind, a & mask(sa), b & mask(sb))


def norm_events(events):
    return [norm_fx(*e[1:]) if e[0] == 'fx' else e for e in events]


class Run:
    """Per-scenario model state."""

    def __init__(self, sc, rows):
        self.sc = sc
        self.rows = [dict(r) for r in rows]
        self.far = {}            # far row index -> body (rows above the installed ones, set up by the far actions)
        self.count = len(rows)
        self.cells = {}          # expected values of the pointer cells
        self.entry = bytearray()  # model of the generic Z entry table
        self.fx_seen = 0
        self.hc_seen = 0
        self.clock = sc['init'].get('clock', 100000) & M32
        self.trace = []
        self.row_images = []
        self.busy = list(sc['init'].get('busy', [0]))
        self.ticks_per_pass = 8

    def p76_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0x76]

    def queues(self, over=None):
        q = dict(tick=[self.clock] * self.ticks_per_pass, busy=list(self.busy))
        q.update(over or {})
        return q


def seed_scenario(x, nat, run, rng):
    sc = run.sc
    init = sc['init']
    x.hard_reset()
    nat.reset()
    x.install_rows(run.rows)
    x.garbage = random.Random(sc['seed'] ^ 0x5A5A)
    x.w32(CELL_MODE, sc['mode'])
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & M32)
    for idx, v in sc['events'].items():
        struct.pack_into('<i', pattern, 4 * idx, v)
    x.wr(EVENTS_VA, pattern)
    nat.set_events(pattern)
    # the state image: garbage, both field strings terminated
    img = bytearray(rng.getrandbits(8) for _ in range(STATE_LEN))
    img[S_FIELD1 + WORD - 1] = rng.choice((0x41, 0x80, 0xFF))      # byte 32 of a field is garbage until phase 0 clears all 33 bytes
    img[S_FIELD2 + WORD - 1] = rng.choice((0x42, 0x7F, 0x01))
    img[S_ACTIVE] = init.get('active', 0)
    for k in (S_PENDING, S_CANCEL, S_WRONG, S_CORRECT):
        img[k] = rng.choice((0, 0, 1, 0x80))
    if init.get('state_garbage', True) is False:
        img = bytearray(STATE_LEN)
    x.wr(STATE, bytes(img))
    nat.set_state(bytes(img))
    start = sgn(init.get('start', rng.choice((0, 1, M32, 5))), 4)
    x.w32(CELL_START, start)
    entry_flag = init.get('entry_flag', rng.choice((0, 1)))
    cells = [sc['mode'], start, entry_flag]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, 4) if sz == 4 else sgn(v, 2))
    nat.set_cells(cells)
    x.w32(CELL_ENTRY_FLAG, entry_flag)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    colours = [rng.getrandbits(32) | 0x01000000 + 0x10001 * k for k in range(18)]
    x.wr(COLOUR_TABLE, struct.pack('<18I', *[c & M32 for c in colours]))
    run.colours = [c & M32 for c in colours]
    view = init.get('view', (0, 0))
    x.wr(CELL_VIEW, struct.pack('<2i', *[sgn(v, 4) for v in view]))
    nat.set_view(*view)
    wk, wadd = init.get('width', (1, 0))
    x.width_k, x.width_add = wk, wadd
    nat.set_width(wk, wadd)
    table = bytearray(rng.getrandbits(8) for _ in range(NENT * STRIDE))
    struct.pack_into('<I', table, 1 * STRIDE + 8, BG_HANDLE)
    struct.pack_into('<I', table, CELL_ENTRY_FLAG - ENTRY, entry_flag)
    for name, (va, sz) in POINTER_CELLS.items():
        v = {'cand': init.get('cand', 0), 'k0': rng.choice((0, 1, 4, 7)), 'k1': rng.choice((0, 1, 3))}.get(name, rng.getrandbits(32))
        v = init.get(name, v)
        run.cells[name] = v & mask(sz)
        if va >= ENTRY:
            struct.pack_into('<I', table, va - ENTRY, v & M32)
    x.wr(ENTRY, bytes(table))
    run.entry = table
    for name, (va, sz) in POINTER_CELLS.items():
        if va < ENTRY:
            x.set_cell(va, run.cells[name], sz)
    x.wr(SCRATCH, bytes(0x1000))


def compare_state(where, x, nat, stats):
    a, b = x.state_image(), nat.state()
    if a != b:
        bad = [k for k in range(STATE_LEN) if a[k] != b[k]]
        raise Mismatch('%s: state image 0x5b616b..+0x86 differs at offsets %s: original %s native %s' % (
            where, [hex(k) for k in bad[:8]], [hex(a[k]) for k in bad[:8]], [hex(b[k]) for k in bad[:8]]))
    stats['compared_fields'] += STATE_LEN


def compare_all(where, x, nat, stats, run, rows=True, light=False):
    compare_state(where, x, nat, stats)
    cells = nat.cells()
    check(stats, where, 'start flag 0x5bb1ca', sgn(x.cell(CELL_START), 4), cells[1])
    check(stats, where, 'entry flag 0x5d1c01', sgn(x.cell(CELL_ENTRY_FLAG), 4), cells[2])
    for name in ('cand', 'k0', 'k1'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    if light:
        return
    check(stats, where, 'engine mode 0x583999', sgn(x.cell(CELL_MODE), 4), cells[0])
    for k, (name, va, sz) in enumerate(XFER):
        check(stats, where, 'scene-change cell ' + name, sgn(x.cell(va, sz), sz), cells[3 + k] if sz == 4 else sgn(cells[3 + k], 2))
    check(stats, where, 'event flag window (4096 dwords)', x.rd(EVENTS_VA, 4 * EVENT_COUNT), nat.events())
    ent = bytearray(run.entry)
    struct.pack_into('<I', ent, CELL_ENTRY_FLAG - ENTRY, cells[2] & M32)
    for name in ('c162d', 'c1631', 'c1639'):         # these three cells are fields of entry 2 (the cursor entry): the host-composed values
        va, sz = POINTER_CELLS[name]
        struct.pack_into('<I', ent, va - ENTRY, run.cells[name])
    check(stats, where, 'generic Z entry table (0x58 x 0x4a bytes, cursor and entry flag cells composed)', x.rd(ENTRY, NENT * STRIDE), bytes(ent))
    for name in ('c162d', 'c1631', 'c1639'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    if rows:
        compare_rows(where, x, run, stats)


def compare_rows(where, x, run, stats):
    pre = run.row_images
    for i, r in enumerate(run.rows):
        exp = bytearray(pre[i])
        exp[TYPE_OFF] = r['type']
        struct.pack_into('<I', exp, BODY_OFF, d9.BODY_BASE + BODY_STRIDE * i if r['body'] is not None else 0)
        exp[COMPLETE_OFF] = r['completed']
        struct.pack_into('<I', exp, REQ_OFF, r['request'])
        struct.pack_into('<I', exp, PHASE_OFF, r['phase'])
        struct.pack_into('<H', exp, WORD_OFF, r['word'])
        struct.pack_into('<I', exp, UNLOADED_OFF, r['unloaded'])
        struct.pack_into('<I', exp, LOADED_OFF, r['loaded'])
        post = x.rd(ROWS + i * ROW, ROW)
        bad = [k for k in range(ROW) if not (DEP_LO <= k < DEP_HI) and post[k] != exp[k]]
        if bad:
            raise Mismatch('%s: row %d bytes differ at offsets %s: original %s model %s' % (
                where, i, [hex(k) for k in bad[:6]], [hex(post[k]) for k in bad[:6]], [hex(exp[k]) for k in bad[:6]]))
        stats['compared_fields'] += 1
        if r['body'] is not None:
            body_at = d9.BODY_BASE + BODY_STRIDE * i
            got = x.rd(body_at, BODY_STRIDE)
            want = r['body'] + bytes(BODY_STRIDE - len(r['body']))
            if got != want:
                bad = [k for k in range(BODY_STRIDE) if got[k] != want[k]]
                raise Mismatch('%s: row %d body bytes differ at offsets %s' % (where, i, [hex(k) for k in bad[:6]]))
            stats['compared_fields'] += 1


def check_writes(where, x, kind, stats):
    allowed = ALLOWED_WRITES[kind]
    extra = {}
    for key, n in x.written.items():
        addr = int(key.split('/')[0], 16)
        if key in GATE_SCRATCH_WRITES and kind == 'tick':
            continue
        if any(lo <= addr < hi for lo, hi in allowed):
            continue
        extra[key] = n
    if extra:
        raise Mismatch('%s: the original wrote outside the modelled cells: %r' % (where, dict(list(extra.items())[:8])))
    stats['compared_fields'] += 1


def check_queues(where, x, nat, stats):
    q = nat.queues()
    check(stats, where, 'queue tick consumed', x.qpos['tick'], q[0])
    check(stats, where, 'queue busy consumed', x.qpos['busy'], q[2])
    check(stats, where, 'queue underflow (native)', (0, 0, 0), (q[1], q[3], q[4]))
    stats['queue_values_consumed'] += x.qpos['tick'] + x.qpos['busy']
    check(stats, where, 'host contract errors (record pointers, event flag window)', (0, 0, 0), tuple(q[5:8]))


def native_fx(nat, run):
    """New observer entries and host calls since the previous call: (mapped observer, host calls, view calls)."""
    fx, hc = nat.log(0), nat.log(1)
    nf, nh = fx[run.fx_seen:], hc[run.hc_seen:]
    run.fx_seen, run.hc_seen = len(fx), len(hc)
    mapped = [norm_fx(k, a, b) for k, a, b in nf]
    views = [h for h in nh if h[0] == HC_VIEW]
    hosts = [norm_fx(k, a, b) for k, a, b in nh if k != HC_VIEW]
    only = [e for e in mapped if e[1] in HOST_FX]
    return mapped, hosts, only, views


def sync_row_images(x, run):
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]


def start_native(nat, run, queues):
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    return queues


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    sync_row_images(x, run)
    queues = start_native(nat, run, run.queues(queues))
    pre_state = x.state_image()
    x.dispatch(queues)
    flags = lambda i: struct.unpack('<i', nat.events()[4 * i:4 * i + 4])[0]  # noqa: E731
    expected = []
    i = 0
    while True:
        if i >= run.count or nat.cells()[0] != 3:
            break
        r = rows[i]
        if r['completed'] or r['unloaded']:
            i += 1
            continue
        r['request'] = 0
        typ = r['type']
        expected.append(('entry', typ, i))
        if gate_open(r, flags):
            expected.append(('visit', typ, i))
            if typ == 0x67:
                r['completed'] = 1
                c = nat.cells()
                c[1] = 1
                nat.set_cells(c)
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0x76:
                visit_76(where, x, nat, run, r, i, expected, stats, pre_state)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', norm_events(x.events), expected)
    stats['ordered_events'] += len(x.events)
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


def visit_76(where, x, nat, run, r, i, expected, stats, pre_state):
    body, phase = r['body'], r['phase']
    pre = nat.state()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, views = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native pwd_step status %d for row %d phase %d (a native refusal the scenario must avoid)' % (where, status, i, phase))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    check(stats, where, 'view origin host calls (phase 0 only)', len(views), 1 if phase == 0 else 0)
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1
    sub = r['subtype']
    for e in mapped:
        expected.append(e)
        if e[1] == FX['COMPLETE']:
            if sub == 1:
                expected.append(('comp', i, 1))
                r['completed'] = 1
            elif sub == 2:
                expected += [('comp', i, 0), ('reset', i)]
                r['completed'] = 0
            expected.append(('gphase', i, 0))
    check(stats, where, 'native result.initialized (phase 0 only)', initialized, 1 if phase == 0 else 0)
    check(stats, where, 'native result.completed (phase 2 only)', completed, 1 if phase == 2 else 0)
    classify(stats, phase, pre, nat.state(), mapped)
    if completed:
        check(stats, where, 'native phase after the finish (the executor then applies the generic completion)', phase_after, 2)
        r['phase'] = 0
    else:
        r['phase'] = phase_after


def classify(stats, phase, pre, post, mapped):
    """Coverage bookkeeping only (never part of a check)."""
    kinds = [e[1] for e in mapped]
    state = struct.unpack_from('<I', pre, S_STATE)[0]
    if phase == 0:
        stats['handler_visits']['phase0'] += 1
        return
    if phase == 2:
        which = 'cancel' if pre[S_CANCEL] else 'wrong' if pre[S_WRONG] else 'correct' if pre[S_CORRECT] else 'none'
        stats['handler_visits']['phase2_' + which] += 1
        if FX['X57B'] in kinds:
            stats['finishes']['scene_' + which] += 1
        if FX['EVENT_FLAG'] in kinds:
            stats['finishes']['flag_' + which] += 1
        return
    stats['handler_visits']['phase1_state_%s' % (state if state <= 5 else 'other')] += 1
    if state in (0, 1) and pre[S_PENDING]:
        key = pre[S_KEY]
        stats['outcomes']['key_enter' if key == 13 else 'key_backspace' if key == 8 else 'key_char'] += 1
        if key == 13:
            after_state = struct.unpack_from('<I', post, S_STATE)[0]
            stats['outcomes']['enter_to_state_%d' % after_state] += 1
        if key not in (8, 13):
            stats['outcomes']['char_width_tested' if FX['TEXT_WIDTH'] in kinds else 'char_too_long'] += 1
    if state == 1 and pre[S_PENDING] and pre[S_KEY] == 13:
        stats['outcomes']['f2_enter_wrong%d_correct%d' % (post[S_WRONG], post[S_CORRECT])] += 1
    if FX['TICK'] in kinds:
        stats['blink']['tick_calls_%d' % kinds.count(FX['TICK'])] += 1
    if state in (3, 4):
        stats['outcomes']['wait_%s' % ('finished' if FX['SOUND_STOP'] in kinds else 'busy')] += 1


def row_of_state(run, st):
    row = s16(struct.unpack_from('<H', st, S_ROW)[0])
    if 0 <= row < len(run.rows) and run.rows[row]['type'] == 0x76:
        return row
    if row in run.far:
        return row
    return None


def body_of_row(run, row):
    return run.rows[row]['body'] if row < len(run.rows) else run.far[row]


def do_key(where, x, nat, run, stats, rng, ch):
    sync_row_images(x, run)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    stats['actions']['key'] += 1
    before = x.state_image()
    # the character message pointer: one byte, garbage around it
    x.wr(CHAR_PTR, bytes([ch]) + bytes(rng.getrandbits(8) for _ in range(7)))
    x.run_method({}, KEY_FN, [CHAR_PTR, rng.getrandbits(32), rng.getrandbits(32)], KEY_THIS)
    after = x.state_image()
    stored_x = before[S_PENDING] == 0 and after[S_PENDING] == 1 and after[S_KEY] == ch and before[S_ACTIVE] != 0
    stored_n = nat.key(ch)
    sx = (ch - 256 if ch >= 128 else ch) & M32
    check(stats, where, 'key: three stubbed method calls of 0x437dcd', x.events, [('stub', a, sx) for a in KEY_STUBS])
    check(stats, where, 'key: stored/refused outcome', int(stored_x), stored_n)
    stats['keys']['stored' if stored_x else 'refused'] += 1
    mapped, hosts, host_only, views = native_fx(nat, run)
    check(stats, where, 'key: native effects', (mapped, hosts, views), ([], [], []))
    check_writes(where, x, 'key', stats)
    compare_all(where, x, nat, stats, run, light=True)
    return stored_x


def do_filter_all(where, x, nat, run, stats, rng):
    """The key filter over all 256 bytes: through the real key function (state armed) and directly through 0x437ea1."""
    for ch in range(256):
        arm = bytearray(x.state_image())
        arm[S_ACTIVE] = 1
        arm[S_PENDING] = 0
        x.wr(STATE, bytes(arm))
        nat.set_state(bytes(arm))
        eax = x.run_method({}, KEY_FILTER, [0x61EE00 | ch], KEY_THIS)
        if eax not in (0, 1):
            raise d9.OracleError('key filter returned %#x' % eax)
        check(stats, where, 'key filter %#04x: original 0x437ea1 versus pwd_char_accepted' % ch, eax, nat.key_filter(ch))
        stats['filter_bytes'] += 1
        do_key(where + ' filter %#04x' % ch, x, nat, run, stats, rng, ch)


def do_pointer(where, x, nat, run, stats, rng, px, py, light=False):
    st = nat.state()
    active = st[S_ACTIVE] != 0
    ri = row_of_state(run, st)
    if active and ri is None:
        stats['skipped_native_refusal']['pointer: active state naming no 0x76 row'] += 1
        return False
    body = body_of_row(run, ri) if ri is not None else run.rows[run.p76_rows()[0]]['body']
    sync_row_images(x, run)
    stats['actions']['pointer'] += 1
    ev = bytearray(rng.getrandbits(8) for _ in range(0x80))
    struct.pack_into('<i', ev, 0x5E, sgn(px, 4))
    struct.pack_into('<i', ev, 0x5A, sgn(py, 4))
    x.wr(EVENT_PTR, bytes(ev))
    x.wr(FRAME - 4, struct.pack('<I', EVENT_PTR))
    nat.clear_logs()
    stop = x.run_block({}, POINTER_BEGIN, POINTER_MISS)
    hit_x = stop == POINTER_HIT
    status, hit, cand, kind = nat.pointer(body, px, py)
    if status != OK:
        raise Mismatch('%s: native pwd_pointer status %d' % (where, status))
    check(stats, where, 'pointer: claim (exit 0x4f2578) versus native hit', int(hit_x), hit)
    if hit_x:
        check(stats, where, 'pointer: eax = 1 on the hit exit', x.machine.reg_read(X.UC_X86_REG_EAX), 1)
    stats['pointer']['hit' if hit else 'inactive' if not active else 'miss'] += 1
    if hit:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((run.cells['k1'] << 4) & M32)) & M32
        run.cells['c1639'] = 1
        check(stats, where, 'pointer: candidate is 0x2724', cand, CAND_CANCEL)
        check(stats, where, 'pointer: cursor kind 9', kind, 9)
    else:
        check(stats, where, 'pointer: no candidate on a miss', (cand, kind), (-1, -1))
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)
    return bool(hit)


def do_click(where, x, nat, run, stats):
    st = nat.state()
    ri = row_of_state(run, st)
    cand = sgn(x.cell(CELL_CAND), 4)
    fires = st[S_ACTIVE] != 0 and st[S_CORRECT] == 0 and cand == CAND_CANCEL
    if fires and ri is None:
        stats['skipped_native_refusal']['click: firing with a state naming no 0x76 row'] += 1
        return
    row = ri if ri is not None else 0
    sync_row_images(x, run)
    nat.clear_logs()
    stats['actions']['click'] += 1
    before = x.row_phase(row) if run.count else 0
    x.run_block({}, CLICK_BEGIN, CLICK_END)
    after = x.row_phase(row) if run.count else 0
    status, fired, nrow, nphase = nat.click(cand)
    check(stats, where, 'click: native status', status, OK)
    check(stats, where, 'click: row phase after', after, nphase & M32 if fired else before)
    check(stats, where, 'click: claimed flag equals the original taking the cancel strip', int(fires), fired)
    if fired:
        check(stats, where, 'click: row', nrow, s16(struct.unpack_from('<H', st, S_ROW)[0]))
        check(stats, where, 'click: phase 2', nphase, 2)
        if row < len(run.rows):
            run.rows[row]['phase'] = 2
    check(stats, where, 'click: effects (only the row phase store)', norm_events(x.events), [('fx', FX['PHASE'], 2, 0)] if fires else [])
    stats['clicks']['accepted' if fired else 'guarded'] += 1
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def do_invalidate(where, x, nat, run, stats):
    sync_row_images(x, run)
    nat.clear_logs()
    stats['actions']['invalidate'] += 1
    x.run_block({}, INVAL_BEGIN, INVAL_END)
    marks = nat.invalidate()
    check(stats, where, 'invalidate: native marks exactly while active', marks, int(nat.state()[S_ACTIVE] != 0))
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    check(stats, where, 'invalidate: effects (the entry flag store while active)', norm_events(x.events), [('fx', FX['ENTRY_VISIBLE'], 1, 0)] if marks else [])
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats):
    sync_row_images(x, run)
    nat.clear_logs()
    stats['actions']['cleanup'] += 1
    x.run_block({}, CLEAN_BEGIN, CLEAN_END)
    nat.cleanup()
    check(stats, where, 'cleanup: effects (the entry flag store)', norm_events(x.events), [('fx', FX['ENTRY_VISIBLE'], 0, 0)])
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_new_game(where, x, nat, run, stats):
    sync_row_images(x, run)
    nat.clear_logs()
    stats['actions']['new_game'] += 1
    x.run_block({}, NEWGAME_BEGIN, NEWGAME_END)
    nat.new_game()
    check(stats, where, 'new game: no effects', x.events, [])
    check_writes(where, x, 'new_game', stats)
    compare_all(where, x, nat, stats, run)


def do_render(where, x, nat, run, stats):
    st = nat.state()
    ri = row_of_state(run, st)
    if ri is None:
        stats['skipped_native_refusal']['render: state naming no 0x76 row'] += 1
        return
    body = body_of_row(run, ri)
    info = body_info(body)
    stats['actions']['render'] += 1
    x.set_cell(CELL_BG, BG_HANDLE)
    sync_row_images(x, run)
    nat.clear_logs()
    x.run_method({}, RENDER, [], 0)
    plan = nat.render(body)
    check(stats, where, 'render: native status', plan['status'], OK)
    check(stats, where, 'render: no effects', x.events, [])
    orig = x.blits
    check(stats, where, 'render: blit and text draw count', len(orig), plan['count'])
    for k, (b, n) in enumerate(zip(orig, plan['ops'])):
        w = 'render op %d' % k
        if isinstance(b, tuple):                      # a text draw
            t = x.texts[b[1]]
            font = info['font']
            check(stats, where, w + ': kind (text)', 2, n['kind'])
            check(stats, where, w + ': string', t['text'], n['text'])
            check(stats, where, w + ': field', 1 if k == 1 else 2, n['field'])
            check(stats, where, w + ': font', font, n['font'])
            check(stats, where, w + ': x word', sgn(t['x'], 2), n['x'])
            check(stats, where, w + ': y word', sgn(t['y'], 2), n['y'])
            check(stats, where, w + ': constants (font tables, colour of the font, target cell, zero)',
                  (t['arg1'], t['arg2'], t['colour'], t['target'], t['zero']),
                  (FONT_TABLE1 + font * 0x7F3, FONT_TABLE2 + font * 0x1D0, run.colours[font], TARGET_HANDLE, 0))
            stats['blits'] += 1
            stats['texts']['field%d_len%s' % (n['field'], 'max' if len(n['text']) >= 31 else 'zero' if not n['text'] else 'some')] += 1
            continue
        check(stats, where, w + ': kind (blit)', 1, n['kind'])
        check(stats, where, w + ': this pointer', b['this'], THIS_SURF)
        check(stats, where, w + ': target surface', b['target'], TARGET_HANDLE)
        check(stats, where, w + ': source surface is the background cell', b['src_surface'], BG_HANDLE)
        check(stats, where, w + ': label', (b['label_ptr'], BLIT_LABEL), (BLIT_LABEL_VA, d9.cstr(x.rd(b['label_ptr'], 48))))
        check(stats, where, w + ': source rectangle contents', b['src'], n['src'])
        check(stats, where, w + ': destination rectangle contents', b['dst'], n['dst'])
        stats['blits'] += 1
    check(stats, where, 'render: unused ops are cleared', plan['zeros'][plan['count']:], [1] * (3 - plan['count']))
    check(stats, where, 'render: the text buffers end with a NUL byte', [n['end'] for n in plan['ops'] if n['kind'] == 2], [0] * sum(1 for n in plan['ops'] if n['kind'] == 2))
    stats['renders']['ops_%d' % plan['count']] += 1
    check_writes(where, x, 'render', stats)
    compare_all(where, x, nat, stats, run)


def do_far(where, x, nat, run, stats, rng, row, phase):
    """One handler visit (phase 0 or 1) of a 0x76 record at a row index above the installed rows, called directly (no dispatcher): the row
    word of the state image then has a nonzero high byte."""
    ri = run.p76_rows()[0]
    body = run.rows[ri]['body']
    if not 0xFF < row < FAR_ROWS:
        raise d9.OracleError('far row index out of range')
    base = ROWS + row * ROW
    if phase == 0:
        x.wr(base, bytes(ROW))
        x.wr(base + BODY_OFF, struct.pack('<I', d9.BODY_BASE + BODY_STRIDE * ri))
        x.wr(base + PHASE_OFF, struct.pack('<I', 0))
        run.far[row] = body
    elif row not in run.far or x.row_phase(row) != 1:
        raise d9.OracleError('far phase 1 without phase 0')
    stats['actions']['far%d' % phase] += 1
    sync_row_images(x, run)
    queues = start_native(nat, run, run.queues())
    x.run_method(queues, HANDLER, [(row & 0xFFFF) | (rng.getrandbits(16) << 16)], 0)
    status, phase_after, initialized, completed = nat.step(body, row, phase)
    mapped, hosts, host_only, views = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native pwd_step status %d for far row %d phase %d' % (where, status, row, phase))
    check(stats, where, 'far: ordered effects', norm_events(x.events), [('handler', row, phase)] + mapped)
    check(stats, where, 'far: host calls equal the observed effects', hosts, host_only)
    check(stats, where, 'far: view origin host calls', len(views), 1 if phase == 0 else 0)
    check(stats, where, 'far: row phase after', x.row_phase(row), phase_after & M32)
    check(stats, where, 'far: initialized / completed', (initialized, completed), (1 if phase == 0 else 0, 0))
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run, rows=False)


def do_set(x, nat, run, d):
    img = bytearray(x.state_image())
    for k, v in d.items():
        if k == 'pending':
            img[S_PENDING] = v
        elif k == 'key':
            img[S_KEY] = v
        elif k in ('field1', 'field2'):
            off = S_FIELD1 if k == 'field1' else S_FIELD2
            img[off:off + WORD] = bytes(v).ljust(WORD, b'\0')[:WORD]
        elif k == 'active':
            img[S_ACTIVE] = v
        elif k == 'row':
            struct.pack_into('<h', img, S_ROW, v)
        elif k == 'cancel':
            img[S_CANCEL] = v
        elif k == 'wrong':
            img[S_WRONG] = v
        elif k == 'state':
            struct.pack_into('<I', img, S_STATE, v & M32)
        elif k == 'blink':
            struct.pack_into('<I', img, S_BLINK, v & M32)
        elif k == 'correct':
            img[S_CORRECT] = v
        elif k == 'deadline':
            struct.pack_into('<I', img, S_DEADLINE, v & M32)
        elif k == 'cand':
            x.set_cell(CELL_CAND, v)
            run.cells['cand'] = v & M32
        elif k == 'mode':
            x.set_cell(CELL_MODE, v)
            c = nat.cells()
            c[0] = sgn(v, 4)
            nat.set_cells(c)
        elif k == 'busy':
            run.busy = list(v)
        elif k == 'width':
            x.width_k, x.width_add = v
            nat.set_width(*v)
        elif k == 'view':
            x.wr(CELL_VIEW, struct.pack('<2i', *[sgn(t, 4) for t in v]))
            nat.set_view(*v)
        elif k == 'c0377':
            x.set_cell(CELL_5D0377, v)
        elif k == 'k1':
            x.set_cell(CELL_CURSOR1, v)
            run.cells['k1'] = v & M32
        else:
            raise d9.OracleError('unknown set key ' + k)
    x.wr(STATE, bytes(img))
    nat.set_state(bytes(img))


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = stats['ticks']
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before
        g['seconds'] = round(g['seconds'] + time.monotonic() - t0, 2)


def run_scenario_inner(x, nat, sc, stats):
    rng = random.Random(sc['seed'])
    run = Run(sc, sc['rows'])
    seed_scenario(x, nat, run, rng)
    nat.clear_logs()
    try:
        for ai, act in enumerate(sc['actions']):
            do_action(x, nat, run, stats, rng, sc, ai, act)
        stats['scenarios'] += 1
    except (Mismatch, d9.OracleError) as error:
        raise type(error)('%s\n    last actions: %s' % (error, ' | '.join(run.trace[-5:]))) from None


def advance(run, rng, choices=(1, 10, 100, 499, 500, 501, 1000, 5000)):
    run.clock = (run.clock + rng.choice(choices)) & M32
    return run.clock


def ensure_mode(x, nat, run):
    if nat.cells()[0] != 3:
        do_set(x, nat, run, {'mode': 3})


def do_action(x, nat, run, stats, rng, sc, ai, act, depth=0):
    kind = act[0]
    where = '%s action %d%s %s' % (sc['id'], ai, '.%d' % depth if depth else '', kind)
    run.trace.append('%s%s' % (kind, '' if len(act) < 2 else ' ' + repr(act[1:])[:90]))
    result = None
    sub = lambda a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=depth + 1)  # noqa: E731
    if kind == 'tick':
        do_tick(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'key':
        result = do_key(where, x, nat, run, stats, rng, act[1])
    elif kind == 'filter256':
        do_filter_all(where, x, nat, run, stats, rng)
    elif kind == 'pointer':
        result = do_pointer(where, x, nat, run, stats, rng, act[1], act[2])
    elif kind == 'probes':
        pts = act[1]
        for k, (px, py) in enumerate(pts):
            do_pointer(where, x, nat, run, stats, rng, px, py, light=(k % 16 != 15 and k != len(pts) - 1))
    elif kind == 'click':
        do_click(where, x, nat, run, stats)
    elif kind == 'render':
        do_render(where, x, nat, run, stats)
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats)
    elif kind == 'new_game':
        do_new_game(where, x, nat, run, stats)
    elif kind == 'set':
        do_set(x, nat, run, act[1])
    elif kind == 'setphase':
        run.rows[act[1]]['phase'] = act[2]
        x.w32(ROWS + act[1] * ROW + PHASE_OFF, act[2])
    elif kind == 'events':
        window = bytearray(nat.events())
        for idx, v in act[1].items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
            struct.pack_into('<i', window, 4 * idx, v)
        nat.set_events(bytes(window))
    elif kind == 'clock':
        run.clock = act[1] & M32
    elif kind == 'rearm':
        for i, r in enumerate(run.rows):
            if r['type'] in ARM:
                r['completed'] = 0
                r['phase'] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
    elif kind == 'far':
        do_far(where, x, nat, run, stats, rng, act[1], act[2])
    elif kind == 'type':
        macro_type(where, x, nat, run, stats, rng, act[1], act[2] if len(act) > 2 else {}, sub)
    elif kind == 'play':
        macro_play(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {}, sub)
    elif kind == 'finish':
        macro_finish(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {}, sub)
    else:
        raise d9.OracleError('unknown action ' + kind)
    stats['actions'][kind] += 1
    return result


# ---------------------------------------------------------------------------------------------
# macros
# ---------------------------------------------------------------------------------------------
def macro_type(where, x, nat, run, stats, rng, text, opts, sub):
    """Type `text` byte by byte: a key message, then (unless opts['burst']) a dispatcher pass that consumes it. Bytes 8 and 13 are
    Backspace and Enter."""
    dts = opts.get('dts', (1, 10, 100, 499, 501))
    for k, ch in enumerate(bytes(text)):
        sub(('key', ch))
        if opts.get('double') and rng.random() < opts['double']:
            sub(('key', rng.choice(bytes(text) or b'a')))
        if opts.get('render') and rng.random() < opts['render']:
            sub(('render',))
        advance(run, rng, dts)
        ensure_mode(x, nat, run)
        sub(('tick', {'tick': [run.clock] * run.ticks_per_pass}))
        if opts.get('probe') and rng.random() < opts['probe']:
            sub(('pointer', rng.randint(-20, 700), rng.randint(-20, 500)))


def macro_play(where, x, nat, run, stats, rng, opts, sub):
    """Random player: keys drawn from the accepted words and a refused pool, Enter, Backspace, ticks that cross or miss the blink deadline,
    renders, pointer probes, clicks, invalidates; until the puzzle finishes or the steps run out."""
    ri = run.p76_rows()[0]
    info = body_info(run.rows[ri]['body'])
    words = info['words_a'] + info['words_b']
    pool = opts.get('pool', list(range(256)))
    dts = opts.get('dts', (1, 10, 100, 499, 500, 501, 1000))
    for k in range(opts.get('steps', 60)):
        ensure_mode(x, nat, run)
        st = nat.state()
        if st[S_ACTIVE] == 0 and run.rows[ri]['phase'] == 0 and k > 0 and run.rows[ri]['completed']:
            break
        r = rng.random()
        if r < 0.55 and words:
            w = rng.choice(words)
            if rng.random() < 0.5:
                w = w.swapcase()
            sub(('type', (bytes(rng.choice(b'xyz0 -') for _ in range(rng.randint(0, 2))) + w + bytes(rng.choice(b'qw. ') for _ in range(rng.randint(0, 2)))), {'dts': dts}))
        elif r < 0.75:
            sub(('type', bytes(rng.choice(pool) for _ in range(rng.randint(1, 5))), {'dts': dts}))
        elif r < 0.85:
            sub(('type', bytes([8] * rng.randint(1, 4)), {'dts': dts}))
        elif r < 0.93:
            sub(('type', b'\r', {'dts': dts}))
        else:
            sub(('key', rng.choice((8, 13, 65, 97, 200))))
        if rng.random() < opts.get('p_render', 0.3):
            sub(('render',))
        if rng.random() < opts.get('p_pointer', 0.15):
            l, t, rr, b = info['cancel_rect']
            sub(('pointer', rng.choice((l, (l + rr) // 2, rr, rr + 1, l - 1, rng.randint(-20, 700))), rng.choice((t, (t + b) // 2, b, b + 1, t - 1, rng.randint(-20, 500)))))
        if rng.random() < opts.get('p_click', 0.05):
            sub(('set', dict(cand=CAND_CANCEL if rng.random() < 0.8 else 0x1234)))
            sub(('click',))
        if rng.random() < opts.get('p_invalidate', 0.05):
            sub(('invalidate',))
        advance(run, rng, dts)
        sub(('tick', {'tick': [run.clock] * run.ticks_per_pass}))


def macro_finish(where, x, nat, run, stats, rng, opts, sub):
    """Ticks through the end: sounds, the finish (phase 2), the completion."""
    ri = run.p76_rows()[0]
    for k in range(opts.get('steps', 12)):
        ensure_mode(x, nat, run)
        if run.rows[ri]['phase'] == 0 and nat.state()[S_ACTIVE] == 0:
            break
        advance(run, rng, (1, 100, 1000))
        sub(('tick', {'tick': [run.clock] * run.ticks_per_pass}))


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
VIEWS = [(0, 0), (30, 40), (-17, 5), (1000, -2000), (0x7FFFFFF0, 0x10), (-1, -1)]
WORDS = [b'KEY', b'open sesame', b'a', b'Mixed Case', b'ESCAPE', b'x1-', b'-', b'\xe9t\xe9', b'A.B,C?', b'ZZZ', b'hello world', b'42']
FONTS = (0, 1, 3, 10, 16, 17)


def R76(body, subtype=1, **kw):
    d = dict(type=0x76, subtype=subtype, body=body, tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def scenario_list(seed=0x7658):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk():
        return ('tick', {})

    def pick_words(n, avoid=()):
        return tuple(rng.choice(WORDS) for _ in range(n))

    def mk(**kw):
        n_a = kw.pop('na', rng.choice((0, 1, 1, 2, 3, 5)))
        n_b = kw.pop('nb', rng.choice((0, 0, 1, 2, 5)))
        kw.setdefault('words_a', pick_words(n_a))
        kw.setdefault('words_b', pick_words(n_b))
        kw.setdefault('font', rng.choice(FONTS))
        kw.setdefault('blink', rng.choice((500, 500, 1, 0, -5, 1000, 32767, -32768, 100)))
        w = rng.choice((60, 120, 300, 700))
        kw.setdefault('rect1', (100, 200, 100 + w, 230))
        kw.setdefault('rect2', (110, 260, 110 + w, 290))
        kw.setdefault('rect_bg', (rng.randint(0, 50), rng.randint(0, 50), rng.randint(300, 640), rng.randint(300, 480)))
        kw.setdefault('snd_ok', rng.choice(SND_KINDS))
        kw.setdefault('snd_bad', rng.choice(SND_KINDS))
        kw.setdefault('ch_ok', rng.choice((0, 1, 5, -3, 32767)))
        kw.setdefault('ch_bad', rng.choice((0, 2, 6, -1, -32768)))
        kw.setdefault('correct', rand_block(rng, rng.choice((9999, 12, -5, 0, 4377)), flag=rng.choice((-1, 0, 7, 340, 4095))))
        kw.setdefault('wrong', rand_block(rng, rng.choice((9999, 3, 0x7FFF - 0x10000, 9999)), flag=rng.choice((-1, 2, 99, 4095))))
        kw.setdefault('cancel', rand_block(rng, rng.choice((9999, 8, 100)), flag=rng.choice((-1, 1, 88, 4095))))
        kw.setdefault('cancel_rect', rng.choice(((0, 330, 619, 374), (10, 10, 20, 20), (-5, -5, 5, 5), (100, 100, 100, 100), (50, 60, 400, 300))))
        return make_body(rng, **kw)

    real = real_rows()
    real_body, _, real_sub = real[0] if real else (None, None, 1)
    real_info = body_info(real_body) if real_body else None

    # ---- phase 0 / render / lifecycle: fonts, views, rectangles, garbage state ------------------------------------------------------
    for k in range(24):
        body = mk(font=FONTS[k % len(FONTS)], snd_ok='none', snd_bad='none')
        init = dict(view=VIEWS[k % len(VIEWS)], active=k % 2, clock=rng.choice((100000, 0, 0xFFFFFFF0, 0x7FFFFFF0)))
        S('init:%d' % k, [R76(body, subtype=1 + k % 2)],
          [tk(), ('render',), ('invalidate',), ('pointer', 1, 1), ('render',), ('set', dict(field1=b'abc', field2=b'DEF')), ('render',),
           ('set', dict(field2=b'')), ('render',), ('cleanup',), ('render',), ('invalidate',)],
          'init', init=init, quick=k < 2)

    # ---- typing: every accepted character class, refused ones, Backspace, long strings, widths ----------------------------------
    classes = [bytes(range(0x41, 0x5B)), bytes(range(0x61, 0x7B)), bytes(range(0x30, 0x3A)), b'\b\r .,?!/$()&:;+%=-', bytes(range(0x80, 0x100)), bytes(range(0, 0x20)),
               bytes(range(0x21, 0x30)) + bytes(range(0x3A, 0x41)) + bytes(range(0x5B, 0x61)) + bytes(range(0x7B, 0x80))]
    for k in range(40):
        cs = classes[k % len(classes)]
        text = bytes(rng.choice(cs) for _ in range(rng.choice((5, 12, 40)))) if k % 3 else cs[:70]
        body = mk(na=2, nb=rng.choice((0, 2)))
        init = dict(width=rng.choice(((1, 0), (1, 0), (2, 3), (3, 0), (40, 0), (1, 250), (4000, 7), (1, -300))), clock=rng.choice((100000, 0xFFFFFF00)))
        S('type:%d' % k, [R76(body)], [tk(), ('type', text, {'render': 0.2, 'double': 0.2, 'probe': 0.1}), ('render',), ('type', b'\b\b\b\b', {}), ('render',)],
          'type', init=init, quick=k == 0)
    for k in range(10):                                      # long strings up to the 30-character limit and the width limit
        body = mk(na=1, nb=1, rect1=(10, 10, 10 + rng.choice((25, 400, 4000)), 40), rect2=(10, 50, 10 + rng.choice((19, 20, 21, 400, 4000)), 80))
        S('long:%d' % k, [R76(body)], [tk(), ('type', bytes(rng.choice(b'abcXYZ019') for _ in range(40)), {}), ('render',),
                                       ('type', b'\r' if k % 2 else b'\b' * 3, {}), ('type', bytes(rng.choice(b'abcXYZ019') for _ in range(36)), {}), ('render',)],
          'long', init=dict(width=rng.choice(((1, 0), (1, -900), (0, 0), (2, 0)))), quick=k == 0)

    # ---- Enter: hits and misses on field 1, field 2, miss-then-hit orders ---------------------------------------------------------
    for k in range(40):
        wa = tuple(rng.choice(WORDS) for _ in range(rng.choice((1, 2, 3, 5))))
        wb = tuple(rng.choice(WORDS) for _ in range(rng.choice((0, 1, 2, 3, 5)))) if k % 4 else ()
        body = mk(words_a=wa, words_b=wb, snd_ok=rng.choice(SND_KINDS), snd_bad=rng.choice(SND_KINDS))
        hit_a = rng.choice(wa)
        hit_b = rng.choice(wb) if wb else b''
        word = lambda w: (bytes([rng.choice(b'x ')]) + (w.swapcase() if rng.random() < 0.5 else w) + bytes([rng.choice(b'q.')]))  # noqa: E731
        first = word(hit_a) if rng.random() < 0.6 else b'nomatch'
        second = word(hit_b) if hit_b and rng.random() < 0.6 else rng.choice((b'miss', b'', b'k'))
        acts = [tk(), ('type', first + b'\r', {}), ('render',)]
        acts += [('type', second + b'\r', {}), ('render',)]
        acts += [('play', dict(steps=25)), ('finish', {}), ('rearm',), tk(), ('type', hit_a + b'\r', {}), ('finish', {})]
        S('enter:%d' % k, [R76(body, subtype=rng.choice((1, 1, 2, 0, 3)))], acts, 'enter', init=dict(busy=rng.choice(([0], [1, 1, 0], [0x100, 0], [-1, 0], [1, 0, 1, 0]))),
          quick=k == 0)
    # Enter with misses first in field 2, then a hit (the wrong flag stays); empty accepted word; no accepted words
    for k in range(16):
        wb = ((b'AAA', b'BBB', b'CCC'), (b'', b'X'), (b'X', b''), (b'ZZZ',), ())[k % 5]
        wa = ((b'ONE',), (b'', ), (b'a', b'b'), ())[k % 4]
        body = mk(words_a=wa, words_b=wb, snd_ok='real' if k % 2 else 'none', snd_bad='none' if k % 3 else 'real')
        S('order:%d' % k, [R76(body, subtype=1 + k % 2)],
          [tk(), ('type', b'one\r', {}), ('type', rng.choice((b'ccc\r', b'aaa\r', b'bbb x\r', b'\r', b'xxx\r')), {}), ('render',), ('play', dict(steps=10)), ('finish', {}),
           ('rearm',), tk(), ('type', b'abc\r', {}), ('type', b'zzz\r', {}), ('finish', {})],
          'order', init=dict(busy=[1, 0]), quick=k == 0)

    # ---- cursor blink: ticks that cross and miss the deadline, wrap-around, periods 0 and negative -----------------------------------
    for k in range(24):
        period = (0, 1, -1, 500, 32767, -32768, 100, -500)[k % 8]
        clock = (0, 0xFFFFFFF0, 0x7FFFFFF0, 100000, 0xFFFFFE00)[k % 5]
        body = mk(blink=period, na=1, nb=1 if k % 2 else 0)
        acts = [tk(), ('render',)]
        for dt in (0, 1, 499, 500, 501, 100, 0x7FFFFFFF, 0x80000000, 5, 70000):
            acts += [('clock', (clock + dt) & M32), tk(), ('render',)]
        acts += [('type', b'ab', {'dts': (0, 1, period & 0xFFF, 500)}), ('type', b'\b\b\b', {'dts': (0, 1, 500)}), ('type', b'ab\r', {'dts': (1000,)})]
        S('blink:%d' % k, [R76(body)], acts, 'blink', init=dict(clock=clock), quick=k == 0)
    for k in range(6):                                       # state images with a stored cursor and every blink phase
        body = mk(na=1, nb=1)
        acts = [tk()]
        for f1, f2, ph in ((b'ab-', b'', 0), (b'ab-', b'cd-', 1), (b'-', b'-', 0), (b'-', b'-', 1), (b'--', b'x--', 1), (b'', b'', 1), (b'', b'', 0), (b'a-b', b'q-', 1)):
            acts += [('set', dict(field1=f1, field2=f2, blink=ph, deadline=(100000 - rng.choice((0, 1, 5))) & M32, state=rng.choice((0, 1)), wrong=0, correct=0)),
                     ('clock', 100000 + rng.choice((0, 1, 500))), tk(), ('render',)]
        S('cursor:%d' % k, [R76(body)], acts, 'blink', quick=k == 0)

    # ---- sounds: busy sequences, NO SOUND and near names, channels ------------------------------------------------------------------
    for k in range(30):
        okk, badk = rng.choice(SND_KINDS), rng.choice(SND_KINDS)
        body = mk(words_a=(b'GO',), words_b=(b'FOUR',) if k % 3 == 0 else (), snd_ok=okk, snd_bad=badk, ch_ok=rng.choice((0, 3, -7, 32767)), ch_bad=rng.choice((1, 4, -8, -32768)))
        busy = rng.choice(([0], [1, 0], [1, 1, 1, 0], [0x100, 0x100, 0], [-1, 0], [0x80000000, 0], [5, 6, 0, 7]))
        what = (b'go\r', b'miss\r', b'go\r' + b'four\r', b'x\r')[k % 4]
        S('sound:%d' % k, [R76(body, subtype=1 + k % 2)],
          [tk(), ('type', what, {}), ('play', dict(steps=6)), ('finish', {'steps': 12}), ('rearm',), tk(), ('type', b'go\r', {}), ('finish', {'steps': 12})],
          'sound', init=dict(busy=busy), quick=k == 0)

    # ---- phase 2: finish blocks, flags, scene words, start values ------------------------------------------------------------------
    for k in range(48):
        pb, nb, cb = [rand_block(rng, rng.choice((9999, 12, -5, 0, 0x7FFF - 0x10000)), flag=rng.choice((-1, 0, 7, 340, 4095))) for _ in range(3)]
        body = mk(words_a=(b'GO',), correct=pb, wrong=nb, cancel=cb, snd_ok='none', snd_bad='none')
        init = dict(start=rng.choice((0, 1, 5, M32)))
        route = k % 3
        acts = [tk()]
        if route == 0:
            acts += [('type', b'go\r', {})]
        elif route == 1:
            acts += [('type', b'no\r', {})]
        else:
            acts += [('type', b'g', {}), ('set', dict(cand=CAND_CANCEL)), ('click',)]
        acts += [('finish', {}), ('render',), ('new_game',), ('rearm',), tk(), ('cleanup',)]
        S('phase2:%d' % k, [R76(body, subtype=rng.choice((1, 1, 2, 0, 3)))], acts, 'phase2', init=init, events={rng.randint(0, 4095): rng.choice((0, 1, -1))}, quick=k < 3)

    # ---- pointer and click ---------------------------------------------------------------------------------------------------------
    for k in range(12):
        cr = rng.choice(((0, 330, 619, 374), (10, 10, 20, 20), (-5, -5, 5, 5), (100, 100, 100, 100), (50, 60, 400, 300), (-100, -100, -50, -50), (0x7FFFFFF0, 0, 0x7FFFFFFF, 5)))
        body = mk(cancel_rect=cr, na=1)
        l, t, r_, b = cr
        pts = [(x_, y_) for x_ in (l - 1, l, (l + r_) // 2, r_, r_ + 1, -1, 0, 0x7FFFFFFF, -0x80000000) for y_ in (t - 1, t, (t + b) // 2, b, b + 1, -1, 0, 0x7FFFFFFF, -0x80000000)]
        acts = [('pointer', l, t), tk(), ('probes', pts), ('click',), ('set', dict(cand=CAND_CANCEL)), ('click',), ('setphase', 0, 1), ('click',)]
        acts += [('set', dict(cand=CAND_CANCEL, correct=1)), ('click',), ('set', dict(cand=0x2723, correct=0)), ('click',), ('set', dict(cand=-1, active=0)), ('click',),
                 ('set', dict(cand=CAND_CANCEL, active=1, correct=0, wrong=1)), ('click',), ('probes', pts[:20]), ('set', dict(active=0)), ('probes', pts[:20])]
        S('pointer:%d' % k, [R76(body), R67()], acts, 'pointer', init=dict(cand=rng.choice((0, 0x1234, -1))), quick=k == 0)

    # ---- the key filter over all 256 bytes and key outcomes by state ----------------------------------------------------------------------
    for k in range(3):
        body = mk(na=2)
        acts = [tk(), ('filter256',)]
        for st in (dict(active=1, pending=0), dict(active=1, pending=1), dict(active=0, pending=0), dict(active=0, pending=1), dict(active=0x80, pending=0x80)):
            acts += [('set', st), ('key', 0x41), ('key', 0x61), ('key', 0x39), ('key', 0xE0), ('key', 0x1B), ('key', 0xFF), ('key', 8), ('key', 13)]
        S('keys:%d' % k, [R76(body)], acts, 'keys', quick=k == 0)

    # ---- inner states: forced states (every state, others), flags ----------------------------------------------------------------------------
    for k, state in enumerate((0, 1, 2, 3, 4, 5, 6, 7, 0x80000000, M32)):
        for case in range(4):
            body = mk(words_a=(b'GO',), words_b=(b'FOUR',), snd_ok=rng.choice(SND_KINDS), snd_bad=rng.choice(SND_KINDS))
            acts = [tk(), ('set', dict(state=state, wrong=case & 1, correct=case >> 1, pending=case % 2, key=rng.choice((8, 13, 65, 200)), field1=b'go-', field2=b'four-')),
                    tk(), ('render',), tk(), tk()]
            S('state:%d_%d' % (state & 0xFFFF, case), [R76(body, subtype=1 + case % 2)], acts, 'states', init=dict(busy=[1, 0, 1, 0]), quick=(state, case) in ((0, 0), (3, 1)))

    # ---- extra: boundary characters, field 2 width, blink dwords, forced states, answer flags, row positions, far rows -------------------------
    bounds = (b'@A', b'Z[', b'a`', b'z{', b'\xe1\xfa', b'\x7f\x80', b'AZaz', b'`{@[')
    for k in range(6):
        body = mk(words_a=(bounds[k], bounds[k + 1], bounds[k + 2]), nb=rng.choice((0, 1)))
        acts = [tk()]
        for text in (b'@A', b'Z[', b'a`', b'z{', b'\xe1\xfa', b'xx@Ayy', b'[Z', b'{z', b'`a', b'AZ'):
            acts += [('set', dict(state=0, field1=text, wrong=0, correct=0)), ('type', b'\r', {}), ('finish', {'steps': 12}), ('rearm',), tk()]
        S('bounds:%d' % k, [R76(body, subtype=1 + k % 2)], acts, 'extra', init=dict(busy=[1, 0]), quick=k == 0)
    for k in range(4):
        body = mk(words_a=(b'GO',), words_b=(b'TWO', b'ZED'), rect2=(110, 260, 110 + rng.choice((20, 40, 60, 90)), 290), font=rng.choice(FONTS))
        acts = [tk(), ('type', b'go\r', {})]
        acts += [('type', bytes(rng.choice(b'abcdefghijklmnopqrstuvwxyz') for _ in range(rng.randint(10, 36))), {'dts': (1, 10)}), ('type', b'\b\b\r', {}), ('finish', {'steps': 12}), ('rearm',), tk()]
        S('f2width:%d' % k, [R76(body)], acts, 'extra', init=dict(busy=[1, 0], width=rng.choice(((1, 0), (2, 0), (3, 4), (1, 9)))), quick=k == 0)
    for k, value in enumerate((0, 1, 2, 0x100, 0xFF, 0x80000000, M32, 7)):
        body = mk(blink=rng.choice((500, 1, 100)), words_a=(b'GO',))
        acts = [tk(), ('set', dict(blink=value)), ('type', b'g', {}), tk(), tk(), ('render',), ('type', b'\b\b', {}), ('set', dict(blink=value, deadline=rng.choice((0, M32, 5)))), tk(), ('render',)]
        S('blinkval:%d' % k, [R76(body)], acts, 'extra', init=dict(clock=rng.choice((1000, 0xFFFFFF00))), quick=k == 0)
    for k in range(4):
        body = mk(words_a=(b'GO',), nb=0)            # state 1 (field 2) although the body has no second field, with Enter pending
        acts = [tk(), ('set', dict(state=1, field1=b'go-', field2=b'go-', pending=1, key=13, correct=0, wrong=0)), tk(), tk(), tk(),
                ('set', dict(state=1, field2=b'', pending=1, key=8)), tk(), ('set', dict(state=1, field2=b'x', pending=1, key=13)), tk(), tk()]
        S('state1_nofield2:%d' % k, [R76(body)], acts, 'extra', init=dict(busy=[1, 0]), quick=k == 0)
    for k in range(4):
        body = mk(words_a=(b'GO',))
        acts = [tk(), ('type', b'g', {}), ('set', dict(cancel=1, wrong=1, correct=k % 2)), ('setphase', 0, 2), tk(), ('render',), ('new_game',), ('rearm',), tk()]
        S('cancelwrong:%d' % k, [R76(body)], acts, 'extra', init=dict(busy=[1, 0]), quick=k == 0)
    # 32-character fields and words (all 32 bytes before the terminator are used): the copies into the local buffers must keep byte 32
    for k, (w, f) in enumerate(((b'A' * 32, b'A' * 32), (b'A' * 31 + b'\xfe', b'B' + b'A' * 31), (b'a' * 32, b'A' * 32), (b'A' * 32, b'a' * 31), (b'\xfe' + b'B' * 31, b'x\xfe' + b'b' * 30))):
        body = mk(words_a=(w,), nb=0)
        acts = [tk(), ('set', dict(state=0, field1=f)), ('type', b'\r', {}), ('finish', {'steps': 12}), ('rearm',), tk()]
        S('copy32:%d' % k, [R76(body)], acts, 'extra', init=dict(busy=[1, 0]), quick=k < 2)
    for k in range(3):
        body = mk(words_a=(b'GO',), cancel_rect=(0, 330, 619, 374))
        rows = [R67(), R67(), R76(body, subtype=1)] + [R67()] * k
        acts = [tk(), ('pointer', 10, 340), tk(), ('set', dict(cand=CAND_CANCEL)), ('click',), ('finish', {'steps': 12}), ('rearm',), tk()]
        S('row2click:%d' % k, rows, acts, 'extra', quick=k == 0)
    for k, far in enumerate((256, 257, 300, 0x1A0, 511 if False else 0x1AF)):
        body = mk(words_a=(b'GO',))
        acts = [tk(), ('far', far, 0), ('far', far, 1), ('far', far, 1), ('set', dict(state=2)), ('far', far, 1), ('pointer', 10, 340), ('set', dict(cand=CAND_CANCEL)),
                ('click',), ('render',), ('invalidate',), ('cleanup',)]
        S('far:%d' % k, [R76(body)], acts, 'extra', init=dict(busy=[1, 0, 0]), quick=k == 0)

    # ---- real row ----------------------------------------------------------------------------------------------------------------------------
    if real_body:
        info = real_info
        words = info['words_a']
        for k in range(6):
            acts = [tk(), ('render',)]
            for w in words:
                variant = (w, w.upper(), w.lower(), b'xx' + w + b'yy', w.swapcase(), w + w)[k % 6]
                acts += [('type', variant + b'\r', {'dts': (1, 10, 499, 501)}), ('render',), ('finish', {'steps': 14}), ('rearm',), tk()]
            acts += [('type', b'nonsense\r', {}), ('finish', {'steps': 14}), ('rearm',), tk(), ('type', b'ab\b\b\b\bc', {}), ('set', dict(cand=CAND_CANCEL)), ('click',),
                     ('finish', {'steps': 14}), ('new_game',)]
            S('real:%d' % k, [R76(real_body, subtype=real_sub)], acts, 'real', init=dict(busy=[1, 1, 0], view=VIEWS[k % 3], width=((1, 0), (2, 0), (3, 1))[k % 3]), quick=k == 0)
        S('real_play', [R76(real_body, subtype=real_sub)], [tk(), ('play', dict(steps=80, p_click=0.05)), ('finish', {})], 'real', init=dict(busy=[1, 0]))
    else:
        S('real_missing', [R76(mk())], [tk(), ('render',)], 'real')

    # ---- random play over random bodies ---------------------------------------------------------------------------------------------------------
    for k in range(40):
        body = mk()
        p = dict(steps=rng.choice((20, 40, 60)), p_render=rng.choice((0.2, 0.5)), p_pointer=0.15, p_click=rng.choice((0.0, 0.05, 0.2)), p_invalidate=0.05,
                 pool=rng.choice((list(range(256)), list(b'abcxyz '), list(b'KEYkey-'))), dts=rng.choice(((1, 10, 100, 499, 500, 501, 1000), (0, 1), (700, 2000, 70000), (0x7FFFFFFF,))))
        S('play:%d' % k, [R76(body, subtype=rng.choice((1, 1, 2, 0))), R67()],
          [tk(), ('play', p), ('finish', {}), ('rearm',), ('play', dict(p, steps=15)), ('finish', {}), ('new_game',), ('render',)], 'play',
          init=dict(busy=rng.choice(([0], [1, 0], [1, 1, 0], [-1, 0])), view=VIEWS[k % len(VIEWS)], clock=rng.choice((100000, 0xFFFFFE00, 5)),
                    width=rng.choice(((1, 0), (2, 0), (3, 5), (1, 100)))), quick=k == 0)

    # ---- the executor: mode, gates, other rows, completed rows ---------------------------------------------------------------------------------
    for k in range(10):
        body = mk(words_a=(b'GO',))
        rows = [R67(), R76(body, subtype=1 + k % 2), R67(), R76(mk(), subtype=1, completed=1) if k % 2 else R67()]
        if k % 3 == 1:
            rows.append(R76(mk(), subtype=2, unloaded=1))
        S('mode:%d' % k, rows, [tk(), ('set', dict(mode=0)), tk(), ('set', dict(mode=3)), tk(), ('type', b'go\r', {}), ('finish', {}), ('rearm',), tk()], 'mode',
          mode=3 if k % 2 == 0 else 1, quick=k == 0)
    for k in range(6):                                       # a finish that changes the engine mode stops the pass after the row
        body = mk(words_a=(b'GO',), correct=block(77, (1, 2, 3), (4, 5, 6), 0, -1))
        rows = [R76(body, subtype=1), R67()]
        S('stop:%d' % k, rows, [tk(), ('type', b'go\r', {}), ('finish', {}), ('set', dict(mode=3)), tk()], 'mode', init=dict(busy=[0]))
    for k in range(6):                                       # gated rows: one event-flag record
        body = mk(words_a=(b'GO',))
        idx = rng.randint(0, 4095)
        rows = [R76(body, subtype=1 + k % 2, tail=event_tail(idx, 1)), R67(tail=event_tail(idx, 2))]
        S('gate:%d' % k, rows, [tk(), ('events', {idx: 1}), tk(), ('type', b'go\r', {}), ('events', {idx: 2}), ('finish', {}), tk(), ('events', {idx: 0}), tk()],
          'mode', events={idx: 0 if k % 2 else 1})
    return scs


# ---------------------------------------------------------------------------------------------
# native-only refusals
# ---------------------------------------------------------------------------------------------
def refusal_checks(nat, stats):
    rng = random.Random(0x7601)
    base = make_body(rng, words_a=(b'GO',), words_b=(b'TWO',), correct=rand_block(rng, 12, flag=5), wrong=rand_block(rng, 13, flag=6), cancel=rand_block(rng, 14, flag=7),
                     snd_ok='real', snd_bad='real')
    h = lambda v: struct.pack('<h', v)  # noqa: E731

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    def fresh(**kw):
        nat.reset()
        nat.set_queues(dict(tick=[5000] * 40, busy=[0] * 8))
        nat.clear_logs()
        img = bytearray(STATE_LEN)
        img[S_ACTIVE] = kw.get('active', 0)
        struct.pack_into('<h', img, S_ROW, kw.get('row', 0))
        nat.set_state(bytes(img))
        nat.set_cells([3, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        nat.set_view(0, 0)

    bad = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'font -1': patch(base, B_FONT, h(-1)), 'font 18': patch(base, B_FONT, h(18)),
           'font 32767': patch(base, B_FONT, h(32767)), 'count A -1': patch(base, B_COUNT_A, h(-1)), 'count A 6': patch(base, B_COUNT_A, h(6)),
           'count B -1': patch(base, B_COUNT_B, h(-1)), 'count B 6': patch(base, B_COUNT_B, h(6)),
           'success name unterminated': patch(base, B_SUCCESS_SOUND, bytes([0x41] * WORD)), 'wrong name unterminated': patch(base, B_WRONG_SOUND, bytes([0x41] * WORD))}
    for k in range(5):
        bad['word A%d unterminated' % k] = patch(patch(base, B_COUNT_A, h(5)), B_WORDS_A + WORD * k, bytes([0x42] * WORD))
        bad['word B%d unterminated' % k] = patch(patch(base, B_COUNT_B, h(5)), B_WORDS_B + WORD * k, bytes([0x43] * WORD))
    for name, b in bad.items():
        fresh(active=1)
        expect('validate ' + name, nat.validate(b), ERR_BODY)
        for phase in (0, 1, 2):
            fresh(active=1)
            st = nat.step(b, 0, phase)
            expect('step with body (%s) phase %d: status' % (name, phase), st[0], ERR_BODY)
            expect('step with body (%s) phase %d: no effect' % (name, phase), (nat.log(0), nat.log(1), nat.state()[S_ACTIVE]), ([], [], 1))
    for ok in (base, patch(base, B_FONT, h(0)), patch(base, B_FONT, h(17)), patch(base, B_COUNT_A, h(0)), patch(base, B_COUNT_A, h(5)), patch(base, B_COUNT_B, h(5)),
               patch(base, B_COUNT_B, h(0))):
        expect('validate accepts', nat.validate(ok), OK)
    for what, bb in (('A slot past the count', patch(base, B_WORDS_A + WORD * 1, bytes([0x44] * WORD))),
                     ('B slot past the count', patch(base, B_WORDS_B + WORD * 1, bytes([0x45] * WORD))),
                     ('A slot past count 0', patch(patch(base, B_COUNT_A, h(0)), B_WORDS_A, bytes([0x44] * WORD))),
                     ('B slot past count 0', patch(patch(base, B_COUNT_B, h(0)), B_WORDS_B, bytes([0x45] * WORD)))):
        expect('validate accepts an unterminated unused word slot (%s)' % what, nat.validate(bb), OK)
    # N2: phase 1 / 2 without phase 0 for the row, phase above 2
    for phase in (1, 2, 3, 7, M32):
        for active, row in ((0, 0), (1, 1)):
            fresh(active=active, row=row)
            st = nat.step(base, 0, phase)
            expect('step phase %d active %d row %d: unsupported' % (phase & 0xFF, active, row), st[0], ERR_UNSUPPORTED)
            expect('step phase %d: no effect' % (phase & 0xFF), (nat.log(0), nat.log(1)), ([], []))
    fresh(active=1, row=0)
    expect('phase 3 on an initialised row', nat.step(base, 0, 3)[0], ERR_UNSUPPORTED)
    # N3: event flag index outside the window in the chosen finish block (before the first effect)
    for off, name in ((B_CORRECT, 'correct'), (B_WRONG, 'wrong'), (B_CANCEL, 'cancel')):
        for idx in (4096, 5000, 32767, -2, -32768):
            b = patch(base, off + 22, h(idx))
            fresh(active=1, row=0)
            img = bytearray(nat.state())
            img[S_CORRECT] = 1 if name == 'correct' else 0
            img[S_WRONG] = 1 if name == 'wrong' else 0
            img[S_CANCEL] = 1 if name == 'cancel' else 0
            nat.set_state(bytes(img))
            st = nat.step(b, 0, 2)
            expect('N3 %s flag %d: unsupported' % (name, idx), st[0], ERR_UNSUPPORTED)
            expect('N3 %s flag %d: no effect' % (name, idx), (nat.log(0), nat.log(1), nat.state()[S_ACTIVE]), ([], [], 1))
        for idx in (-1, 0, 4095):
            b = patch(base, off + 22, h(idx))
            fresh(active=1, row=0)
            img = bytearray(nat.state())
            img[S_CORRECT] = 1 if name == 'correct' else 0
            img[S_WRONG] = 1 if name == 'wrong' else 0
            img[S_CANCEL] = 1 if name == 'cancel' else 0
            nat.set_state(bytes(img))
            expect('N3 %s flag %d: accepted' % (name, idx), nat.step(b, 0, 2)[0], OK)
    # the block that is used when cancel and wrong are both set is the cancel block (0x4300xx finish order: cancel, wrong, correct)
    for bad_off, good_off, want in ((B_CANCEL, B_WRONG, ERR_UNSUPPORTED), (B_WRONG, B_CANCEL, OK)):
        b = patch(patch(base, bad_off + 22, h(5000)), good_off + 22, h(5))
        fresh(active=1, row=0)
        img = bytearray(nat.state())
        img[S_CANCEL] = img[S_WRONG] = 1
        nat.set_state(bytes(img))
        expect('N3 cancel and wrong both set: the cancel block decides (bad block %#x)' % bad_off, nat.step(b, 0, 2)[0], want)
    for flag_set, bad_off, want in (((S_WRONG, S_CORRECT), B_WRONG, ERR_UNSUPPORTED), ((S_WRONG, S_CORRECT), B_CORRECT, OK), ((S_CORRECT,), B_CORRECT, ERR_UNSUPPORTED)):
        good_off = B_CORRECT if bad_off == B_WRONG else B_WRONG
        b = patch(patch(base, bad_off + 22, h(5000)), good_off + 22, h(5))
        fresh(active=1, row=0)
        img = bytearray(nat.state())
        for f in flag_set:
            img[f] = 1
        nat.set_state(bytes(img))
        expect('N3 wrong beats correct (flags %r, bad block %#x)' % (flag_set, bad_off), nat.step(b, 0, 2)[0], want)
    # failure texts of the two refusals (and a NULL pointer instead: no store through it)
    fresh(active=0, row=0)
    for phase in (1, 2):
        rc, flag, text = nat.step_msg(base, 0, phase, 2)
        expect('failure text of phase %d without phase 0' % phase, (rc, flag, bool(text)), (ERR_UNSUPPORTED, 1, True))
        expect('phase %d without phase 0, no failure pointer' % phase, nat.step_msg(base, 0, phase, 0)[0], ERR_UNSUPPORTED)
    fresh(active=1, row=0)
    img = bytearray(nat.state())
    img[S_CORRECT] = 1
    nat.set_state(bytes(img))
    b5000 = patch(base, B_CORRECT + 22, h(5000))
    rc, flag, text = nat.step_msg(b5000, 0, 2, 2)
    expect('failure text of an event flag outside the window', (rc, flag, bool(text)), (ERR_UNSUPPORTED, 1, True))
    expect('event flag outside the window, no failure pointer', nat.step_msg(b5000, 0, 2, 0)[0], ERR_UNSUPPORTED)
    expect('the two refusals have different texts', nat.step_msg(b5000, 0, 2, 2)[2] != nat.step_msg(base, 7, 1, 2)[2], True)
    # the window check applies to the block that is used: an invalid flag in an unused block is accepted
    fresh(active=1, row=0)
    img = bytearray(nat.state())
    img[S_CORRECT] = 1
    nat.set_state(bytes(img))
    expect('N3 unused wrong block with flag 5000', nat.step(patch(base, B_WRONG + 22, h(5000)), 0, 2)[0], OK)
    # no answer at all (no cancel, no wrong, no correct): no flag check, no block
    fresh(active=1, row=0)
    expect('N3 no answer with flag 5000 in the correct block', nat.step(patch(base, B_CORRECT + 22, h(5000)), 0, 2)[0], OK)
    # N4: host failures after effects (the n-th failing host call)
    fresh()
    img = bytearray(STATE_LEN)
    img[S_ACTIVE:S_ACTIVE + 1] = b'\0'
    for k in range(STATE_LEN):
        img[k] = (k * 37 + 11) & 0xFF
    img[S_ACTIVE] = 0
    nat.set_state(bytes(img))
    nat.set_fail(1)
    expect('N4 phase 0 view failure: host error, no effect, state image untouched', (nat.step(base, 0, 0)[0], nat.log(0), nat.state()), (ERR_HOST, [], bytes(img)))
    fresh()
    nat.set_fail(1)
    expect('N4 phase 0 view failure: host error, no effect', (nat.step(base, 0, 0)[0], nat.log(0)), (ERR_HOST, []))
    fresh()
    nat.set_fail(2)
    expect('N4 phase 0 font failure: host error after the start flag', (nat.step(base, 0, 0)[0], nat.log(0)), (ERR_HOST, [(1, 1, 0)]))
    fresh()
    nat.set_fail(3)
    expect('N4 phase 0 without a third failing call', nat.step(base, 0, 0)[0], OK)
    for state, calls in ((5, 2), (2, 2), (3, 1), (4, 1)):
        for n in range(1, calls + 1):
            fresh(active=1, row=0)
            img = bytearray(nat.state())
            struct.pack_into('<I', img, S_STATE, state)
            nat.set_state(bytes(img))
            nat.set_fail(n)
            expect('N4 phase 1 state %d failure %d' % (state, n), nat.step(base, 0, 1)[0], ERR_HOST)
    for n in (1, 2, 3):
        fresh(active=1, row=0)
        img = bytearray(nat.state())
        img[S_CORRECT] = 1
        nat.set_state(bytes(img))
        nat.set_fail(n)
        expect('N4 phase 2 failure %d' % n, nat.step(base, 0, 2)[0], ERR_HOST)
    fresh(active=1, row=0)
    img = bytearray(nat.state())
    img[S_FIELD1:S_FIELD1 + 3] = b'ab\0'
    nat.set_state(bytes(img))
    nat.set_fail(1)
    expect('N4 phase 1 text width failure while typing', (nat.step(base, 0, 1)[0] in (OK, ERR_HOST)), True)
    # argument guards and the optional observer
    fresh(active=1)
    expect('NULL arguments and missing host callbacks', nat.null_checks(base), [ERR_ARGUMENT] * 16 + [ERR_ARGUMENT] * 3 + [ERR_ARGUMENT] * 2
           + [ERR_ARGUMENT] * 3 + [0, 0, ERR_BODY])
    for phase, state, flags in ((0, 0, {}), (1, 5, {}), (1, 0, {'pending': 1}), (2, 0, {'correct': 1})):
        results = []
        for no_obs in (0, 1):
            fresh(active=1, row=0)
            nat.set_queues(dict(tick=[7000] * 8, busy=[0] * 4))
            img = bytearray(nat.state())
            struct.pack_into('<I', img, S_STATE, state)
            if 'pending' in flags:
                img[S_PENDING], img[S_KEY] = 1, 0x41
            if 'correct' in flags:
                img[S_CORRECT] = 1
            nat.set_state(bytes(img))
            st = nat.step_ex(base, 0, phase, no_obs)
            results.append((st, nat.state(), nat.log(1), nat.cells()[:1] + nat.cells()[3:]))
        expect('observer NULL gives the same result (phase %d state %d)' % (phase, state), results[0], results[1])
    fresh(active=1)
    expect('N5 pointer on a short body while active', nat.pointer(base[:-1], 1, 1)[0], ERR_BODY)
    fresh(active=0)
    expect('N5 pointer on a short body while inactive is not looked at', nat.pointer(base[:-1], 1, 1), (OK, 0, -1, -1))
    expect('N5 render on a short body', nat.render(base[:-1])['status'], ERR_BODY)
    expect('N5 render on a long body', nat.render(base + b'\0')['status'], ERR_BODY)
    for what, bb in (('short', base[:-1]), ('long', base + b'\0')):
        r = nat.render(bb)
        expect('N5 render on a %s body leaves a cleared result' % what, (r['count'], r['zeros']), (0, [1, 1, 1]))
    # the contract constants against the original's facts (type, body, state image, word size, limits, candidate, cursor kind, state numbers, offsets)
    consts = nat.constants()
    expect('constants: type, body, state image, word, accepted words, last font, no scene, no flag, cancel candidate, cancel cursor',
           consts[:10], [0x76, 575, STATE_LEN, WORD, 5, 17, 9999, -1, 0x2724, 9])
    expect('constants: contract sizes (transition, state, op, render result)', (consts[17], consts[18], consts[42], consts[43]), (20, STATE_LEN, 80, 244))
    expect('constants: status codes', consts[11:17], [OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS])
    expect('constants: handler state numbers', consts[21:27], [0, 1, 2, 3, 4, 5])
    expect('constants: state image offsets', consts[27:42], [S_PENDING, S_KEY, S_FIELD1, S_FIELD2, S_ACTIVE, S_ROW, S_CANCEL, S_WRONG, S_STATE, S_BLINK, S_CORRECT,
                                                         S_DEADLINE, S_RECT_BG, S_RECT_F1, S_RECT_F2])
    # failure messages: a refusal names its cause through the optional pointer (NULL pointer allowed), success leaves it NULL
    msgs = set()
    for name, b in bad.items():
        rc, msg = nat.validate_msg(b, 2)
        expect('failure message of validate (%s): code and text' % name, (rc, bool(msg), msg != b'?'), (ERR_BODY, True, True))
        expect('failure message of validate (%s) without a pointer' % name, nat.validate_msg(b, 0)[0], ERR_BODY)
        msgs.add(msg)
        fresh(active=1)
        before = (nat.state(), nat.cells())
        rc, flag, text = nat.step_msg(b, 0, 1, 2)
        expect('failure message of step (%s): code and text equal validate' % name, (rc, flag, text), (ERR_BODY, 1, nat.validate_msg(b, 2)[1]))
        expect('failure message of step (%s): state and cells untouched' % name, (nat.state(), nat.cells()), before)
    expect('distinct causes give distinct failure messages', len(msgs) >= 5, True)
    for ok in (base, patch(base, B_COUNT_A, h(5))):
        expect('validate success leaves the failure pointer NULL', nat.validate_msg(ok, 2), (OK, b''))
    fresh(active=0)
    expect('step failure pointer is NULL on success', nat.step_msg(base, 0, 0, 2)[:2], (OK, 0))
    fresh(active=1, row=0)
    expect('step unsupported names a cause', nat.step_msg(base, 0, 3, 2)[0:2], (ERR_UNSUPPORTED, 1))
    fresh()
    nat.set_fail(1)
    st = nat.step_msg(base, 0, 0, 2)
    expect('step host failure leaves no effect and sets the failure pointer (NULL or a text, never stale)', (st[0], st[1] != -1, nat.log(0)), (ERR_HOST, True, []))
    fresh(active=0)
    # the state image after reset is the defined one although the storage held garbage (the driver fills it with 0xA5 first)
    nat.reset()
    expect('reset zeroes the state image', nat.state(), bytes(STATE_LEN))


# ---------------------------------------------------------------------------------------------
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
    for a in list(HOOK_RETS) + [KEY_FN, KEY_FILTER, RENDER, 0x4F0059, 0x43A7CA, 0x43D7F0, 0x43DBE3, 0x435015, 0x430B9A, 0x50D0BC, 0x50D8E0]:
        i = bisect.bisect_left(starts, a)
        if i < len(starts) and starts[i] == a:
            funcs[a] = starts[i + 1]
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
    return 'PINS_TABLE = (\n' + ''.join('    (%#x, %#x, %r),\n' % t for t in out) + ')'


def merge(a, b):
    """Add two stats trees (dicts of numbers / dicts / lists)."""
    if isinstance(a, dict) and isinstance(b, dict):
        out = dict(a)
        for k, v in b.items():
            out[k] = merge(out[k], v) if k in out else v
        return out
    if isinstance(a, list) and isinstance(b, list):
        return a + b
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return a + b
    return a


def to_plain(stats):
    return {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--workers', type=int, default=1)
    ap.add_argument('--shard', default='', help='internal: k/N')
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--sanitize', nargs='?', const='ub', default='', choices=('ub', 'asan'), help='build the driver with UBSan (default) or ASan+UBSan')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-58.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_76.so', strict=not args.lenient_build, sanitize=args.sanitize)
        procs = []
        for k in range(args.workers):
            res = work / ('shard%d.json' % k)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--shard', '%d/%d' % (k, args.workers),
                   '--result', str(res), '--show', str(args.show)]
            for flag in ('--fail-fast', '--quick-only', '--discover-pins'):
                if getattr(args, flag[2:].replace('-', '_')):
                    cmd.append(flag)
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
            args.result.write_text(json.dumps(dict(slice='RT-58', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_76.so', strict=not args.lenient_build, sanitize=args.sanitize)
    nat = Native(lib_path)
    x = Oracle()
    # the text width stand-in must be the same function on both sides
    for font in (0, 1, 7, 17):
        for text in (b'', b'a', b'Hello 123 \xe9\xff', bytes(range(1, 33))):
            for k, add in ((1, 0), (3, 5), (4000, -7), (0, 9)):
                nat.set_width(k, add)
                if nat.width_of(font, text) != text_width(k, add, font, text):
                    raise d9.OracleError('the text width stand-ins differ')
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast)
    if not args.only and shard_k == 0:
        try:
            refusal_checks(nat, stats)
        except Mismatch as error:
            bad.append(('refusal', str(error)))
            stats['mismatches'] += 1
    if args.discover_pins:
        print(discover_pins(x, blocks))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:900])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = to_plain(stats)
    summary['skipped_native_refusal'] = dict(stats['skipped_native_refusal'])
    summary['seconds'] = round(time.monotonic() - started, 1)
    if not args.shard:
        print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-58', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
