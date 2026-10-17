#!/usr/bin/env python3
"""RT-49: immutable x86 dispatcher 0x427a50 / handler 0x42ed54 (raw 0x77, the Ordering Puzzle), the pointer case 0x4f0270..0x4f04b6,
the click block 0x43b3d6..0x43b5d3 and the render callback 0x4d00f4 versus the native kernel src/action_family_77_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x77 (and 0x67 as the plain "other loaded row") the
REAL dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x428f11,
the handler 0x42ed54 with all of its phases and the sub-states of the process dword 0x5b5162, and the generic completion 0x42ba3a
(subtype 1 sets the completion byte, subtype 2 clears it and runs the dependency reset 0x423d33, every subtype stores phase 0). All of
it is original x86. The three input/output paths that the engine reaches through other callers are driven as original code ranges
on the same process image: the pointer case of the cascade 0x4f0059 (a frame whose [ebp-4] points at a fake event record, stop at
0x4f04b6 or the epilogue 0x4f2578), the click block of the frame loop (a frame with the scratch word [ebp-0x48], stop at 0x43b5d3)
and the render callback 0x4d00f4 (cdecl, no arguments, called as a function).

Native side: tests/action_family_77_runtime_oracle_driver.c links ONLY the kernel (src/action_family_77_runtime.c) and implements
the HOST side of the A77Host contract with scripted queues (rand values, GetTickCount values, sound-busy answers, surface handles).
The driver decides nothing the kernel decides. It keeps two logs, the observer log (A77Host.observe) and the host-call log (what the
kernel really asked of the host); the oracle requires them to agree, so an observer that invents or omits an effect fails.

Compared after EVERY action (dispatcher pass, pointer, click, render):
 * the process image 0x5b5128..0x5b516a (67 bytes: selected bytes, order words, active, row, hover, exit flag, deadline, step, count,
   limit, solved) byte for byte against the A77State image; 0x5d03cf, 0x5d1a83, 0x5d1a8f; the start flag 0x5bb1ca; the engine mode
   0x583999; the seven scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff 0x5bb59b 0x5bb59f 0x5bb5a3; the whole event flag window
   (4096 dwords at 0x585801); the scene-clear and pointer cells 0x5c3a5b 0x5c3a5f 0x5c39e5 0x5b44f0 0x5b44f4 0x5d162d 0x5d1631 0x5d1639;
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every effect of
   the A77Effect list: stores to 0x5b5158 / 0x5bb1ca / 0x5b5162 / 0x5d1a83 / 0x5d1a8f / the scene cells / the engine mode / the event
   flag window / the row phase dword, and the calls to rand, the image loader (name, kind, label checked), the releaser, the four sound
   routines, GetTickCount and the generic completion, then the completion byte, the dependency reset and the phase store of 0x42ba3a)
   against the sequence the native kernel reports for the same visit, entry for entry;
 * every byte of every row (0x8d bytes except the dependency record the gate and the reset own) against a model; garbage in the
   unlisted bytes proves nothing else is touched; every write outside the listed cells fails the run (apart from the gate's pinned
   scratch); the scripted queues (rand, tick, busy, handle) are consumed identically by both sides;
 * pointer: the return path (claimed 0x4f2578 / continues 0x4f04b6), the candidate 0x5c39e5, the cursor cells, the hover word, and the
   three host-composed cells 0x5d162d / 0x5d1631 / 0x5d1639 against their documented composition from the native outputs;
 * click: the toggle / pop / clamp results, the exit candidate (0x5b515d and row phase 2), and the sound-play call;
 * render: every recorded 0x4c5377 blit (this, source surface, source rectangle contents, target, destination rectangle contents,
   label string) against a77_render_plan.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N`
and returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x50cd50 rand            scripted values (CRT boundary; the body reaches _getptd)
  R 0x4c2790 load image      thiscall ECX 0x5cf659, ret 0x10; returns the scripted handle; kind, name, 6 and the label are checked
  R 0x4c2dfb release image   thiscall ret 4: records the old value of the cell, zeroes it as the real routine's final store does
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4)
  R 0x4c5377 blit recorder (ECX 0x5cf659, ret 0x14)   R 0x51dc43 malloc (bump arena)   R 0x51dc6c free (recorded)
  R GetTickCount (import thunk stub)  scripted values
  O 0x428f11 / 0x428692 arm entries, 0x428f35 / 0x4286b5 post-gate points, 0x42ed54 handler entry, 0x42ba3a generic completion,
    0x42babe (its ret), 0x423d33 dependency reset; every store to the process data region is observed (read-only)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick and rand values, busy
answers, the view origin, the background / target surface handles, the event flag window contents.

KNOWN DIVERGENCES (native safety layer; never silently skipped. They are checked natively in refusal_checks() and are not run against
the original, which would index arbitrary memory or run on a state it never had):
  K1 a77_validate_body: short body, name without NUL in its 0x21 bytes, N or L outside 0..16 -> A77_ERR_BODY, no effect.
  K2 phase 1 / 2 on a state phase 0 did not initialise for the row -> A77_ERR_UNSUPPORTED, no effect.
  K3 phase 1 state 1 / phase 2 exit path with an event flag index outside the host window -> A77_ERR_BOUNDS before the first effect
     (the original stores through an arbitrary pointer).
  K4 click on a hovered button outside 0..N-1 or a count outside 0..16 -> A77_ERR_BOUNDS, no effect (the original indexes out of range).
  K5 host callback failures -> A77_ERR_HOST (the original has no failure path).
  K6 row phase above 2: the original switch does nothing; the native kernel returns A77_OK without effect (compared).
 All of these are unreachable in the game (loader-built 731-byte bodies, phase 0..2 only, one row per scene).

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69,
0x4fb2e3, 0x4f6334), the blit body 0x4c5377, the cascade 0x4f0059 and the accepted-release chain that wrap the pointer and click ranges
(the oracle supplies their frames), the generic Z entry drawer that skips the callback when 0x5d1a8f is 0 (the oracle calls 0x4d00f4
itself and only checks that the native plan is empty then), the scene clears 0x437260 / 0x438a60 / 0x43dd40 (a77_clear is checked against
its documented model only, not against the original), the scene loader 0x40b34a that builds the body, the host composition of the
cursor cells 0x5d162d / 0x5d1631 / 0x5d1639, and the engine consumers of the scene-change cells.

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.

Modes: --quick-only runs the scenarios flagged quick (about a second); the default run is every scenario plus the native-only
refusal checks; --mutations additionally plants ~110 mutants into a temporary copy of src/action_family_77_runtime.c (each is built
into its own driver library and must be caught by the quick set or the full set; MUTANTS below, anchors must match exactly once);
EQUIVALENT_MUTANTS lists the one mutant that is invisible against the original and is not counted. --discover-pins prints the
PINS_TABLE of the original code the scenarios execute (function spans from the decompiled function index, plus the exact pointer and
click ranges). The pins are verified at start-up; a mismatch aborts the run.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_77_runtime_original_oracle.py --quick-only
  python3 action_family_77_runtime_original_oracle.py --mutations --result ../../../work/analysis/slices/RT-49.oracle-result.json
  python3 action_family_77_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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
BODY_LEN = 731
BODY_STRIDE = 0x400
EVREC = d9.BODY_BASE + 0xE000          # the fake event record of the pointer case

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET = 0x427A50, 0x42ED54, 0x42BA3A, 0x423D33
GENERIC_RET = 0x42BABE
ARM = {0x77: 0x428F11, 0x67: 0x428692}
VISIT = {0x77: 0x428F35, 0x67: 0x4286B5}
RAND, LOAD_IMAGE, RELEASE_IMAGE = 0x50CD50, 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
BLIT, FREE = 0x4C5377, 0x51DC6C
RENDER_CB = 0x4D00F4
POINTER_RANGE = (0x4F0270, 0x4F04B6)      # begin, fall-through stop
POINTER_CLAIM = 0x4F2578                  # the common epilogue the claiming exits jump to
CLICK_RANGE = (0x43B3D6, 0x43B5D3)

# ---- process data cells (data region addresses, named so they are never mistaken for code windows)
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
CELL_STATE = 0x5B5128                    # the 67-byte object image
CELL_STATE_LEN = 0x43
CELL_ACTIVE, CELL_ROW, CELL_HOVER, CELL_EXIT, CELL_DEADLINE, CELL_STEP = 0x5B5158, 0x5B5159, 0x5B515B, 0x5B515D, 0x5B515E, 0x5B5162
CELL_COUNT, CELL_LIMIT, CELL_SOLVED = 0x5B5166, 0x5B5168, 0x5B516A
CELL_SURFACE, CELL_OVL_SURFACE, CELL_OVL_ACTIVE = 0x5D03CF, 0x5D1A83, 0x5D1A8F
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_ORG_X, CELL_ORG_Y = 0x583186, 0x58318A
CELL_PTR_X, CELL_PTR_Y, CELL_CAND = 0x5C3A5B, 0x5C3A5F, 0x5C39E5
CELL_CURSOR0, CELL_CURSOR1 = 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY = 0x5CF659, 0x5C3A67, 0x5CF1EB
BG_HANDLE, TARGET_HANDLE = 0x7A000011, 0x7A000022
LABEL_KIND, LABEL_SURFACE = b'CIFTREE', b'DF OrderingPuzzle Surface'
LABEL_SELECTED_BLIT = b'Ordering puzzle pSrcSurface'
LABEL_VA_SELECTED, LABEL_VA_UNSELECTED = 0x559F30, 0x559F4C     # data addresses of the two (identical) label strings
NO_SOUND = b'NO SOUND\0'

# A77Effect numbering of the header
FX = dict(ACTIVE=1, START_FLAG=2, RANDOM=3, RELEASE=4, LOAD=5, OVL_SURFACE=6, OVL_ACTIVE=7, PREPARE=8, STOP=9, PLAY=10, BUSY=11,
          TICK=12, STEP=13, PHASE=14, EVENT_FLAG=15, X57B=16, X599=17, X595=18, X39FF=19, X59B=20, X59F=21, X5A3=22, MODE=23, COMPLETE=24)
FXN = {v: k for k, v in FX.items()}
FX_SIZE = {FX['ACTIVE']: (1, 4), FX['PLAY']: (2, 4), FX['COMPLETE']: (2, 4), FX['X599']: (2, 4), FX['X595']: (2, 4), FX['X39FF']: (2, 4)}
WRITE_FX = {CELL_ACTIVE: (FX['ACTIVE'], 1), CELL_START: (FX['START_FLAG'], 4), CELL_STEP: (FX['STEP'], 4), CELL_OVL_SURFACE: (FX['OVL_SURFACE'], 4),
            CELL_OVL_ACTIVE: (FX['OVL_ACTIVE'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
# the kinds that are also host calls (the host-call log of the driver uses the same numbers)
HOST_FX = {FX['RANDOM'], FX['LOAD'], FX['RELEASE'], FX['PREPARE'], FX['STOP'], FX['PLAY'], FX['BUSY'], FX['TICK'], FX['EVENT_FLAG']}

# writes outside the modelled cells that the gate and the dispatcher make (discovered, then pinned)
GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {RAND: (0x22, 0), LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4),
             SND_PLAY: (0xb4, 4), SND_BUSY: (0x138, 4), BLIT: (0x214, 0x14), FREE: (0xb, 0)}

# Executed original code, as SHA-256 of the unmodified image bytes. Function spans, plus the two exact ranges that are run inside
# larger functions (the pointer case and the click block). Discovered over every scenario with --discover-pins, verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423d33, 0x423da2, 'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x42ba3a, 0x42babf, '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x42ed54, 0x42f510, 'af3c9c4f35226cf5d47acad55acfff599b2b698b1f622782cc60567a5b80f7ea'),
    (0x43b3d6, 0x43b5d3, 'e27fdd816eb1c346acc4e913b327a638fbb2cf61da899fb7e7c633582ff89e83'),
    (0x4c2790, 0x4c2898, '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377, 0x4c558b, 'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
    (0x4d00f4, 0x4d0275, 'c063634fd3c2ddf91dacb91b59c78fc1e1ac237fbae64da04036fcfe6befa16d'),
    (0x4f0270, 0x4f04b6, '40791398919812aa8136839e670540d46f55ec24aedebbbeffe5b536c2c39571'),
    (0x4f6334, 0x4f646c, '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
    (0x4fb2e3, 0x4fb397, 'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
    (0x4fb77a, 0x4fba69, '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
    (0x4fba69, 0x4fba86, '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
    (0x50cd50, 0x50cd72, '0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x77 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('rand', 'tick', 'busy', 'handle')}
        self.qpos = Counter()
        self.stops = {}
        self.stopped_at = None
        self.in_complete = False
        self.recording = False
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            actual = sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base])
            if digest is not None and actual != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, actual))
        self._check_hook_rets()
        self.clear_logs()

    def _check_hook_rets(self):
        from capstone import CS_ARCH_X86, CS_MODE_32, Cs
        md = Cs(CS_ARCH_X86, CS_MODE_32)
        base = self.pe.image_base
        for a, (span, imm) in HOOK_RETS.items():
            rets = {int(i.op_str, 0) if i.op_str else 0 for i in md.disasm(self.pristine[a - base:a - base + span], a)
                    if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise d9.OracleError('hooked function %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.frees = []
        self.blits = []
        self.in_complete = False
        self.stopped_at = None

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(v) for k, v in qs.items()}
        self.qpos = Counter()

    def pop(self, kind):
        i = self.qpos[kind]
        if i >= len(self.qs[kind]):
            raise d9.OracleError('script underflow: %s queue' % kind)
        self.qpos[kind] += 1
        return self.qs[kind][i] & 0xFFFFFFFF

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
        table = {RAND: self._replaced, LOAD_IMAGE: self._replaced, RELEASE_IMAGE: self._replaced, SND_PREPARE: self._replaced,
                 SND_STOP: self._replaced, SND_PLAY: self._replaced, SND_BUSY: self._replaced, BLIT: self._replaced, FREE: self._replaced,
                 HANDLER: self._handler, GENERIC_COMPLETION: self._complete, GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen}
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a in d9.GUARDS:
            table[a] = self._raise
        for a in (POINTER_RANGE[1], POINTER_CLAIM, CLICK_RANGE[1]):
            table[a] = self._range_stop
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

    def _range_stop(self, uc, address, size, user):
        if address in self.stops:
            self.stopped_at = address
            uc.emu_stop()

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        pops = {RAND: 0, LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT: 0x14, FREE: 0}
        want_ecx = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
                    SND_BUSY: THIS_BUSY, BLIT: THIS_SURF}
        if address in want_ecx and ecx != want_ecx[address]:
            raise d9.OracleError('hook %#x entered with ECX=%#x' % (address, ecx))
        if address == RAND:
            eax = self.pop('rand')
            self.events.append(('fx', FX['RANDOM'], eax, 0))
        elif address == LOAD_IMAGE:
            kind, name, six, label = d9.cstr(self.rd(a[0], 32)), d9.cstr(self.rd(a[1], 64)), a[2], d9.cstr(self.rd(a[3], 64))
            if kind != LABEL_KIND or six != 6 or label != LABEL_SURFACE:
                raise d9.OracleError('image loader arguments differ from the packet: %r %r %d %r' % (kind, name, six, label))
            eax = self.pop('handle')
            self.loaded.append(name.decode('latin1'))
            self.events.append(('fx', FX['LOAD'], eax, 0))
        elif address == RELEASE_IMAGE:
            if a[0] != CELL_SURFACE:
                raise d9.OracleError('releaser called for %#x' % a[0])
            old = u32(uc, a[0])
            self.events.append(('fx', FX['RELEASE'], old, 0))
            self.wr(a[0], bytes(4))
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['PREPARE'] if address == SND_PREPARE else FX['STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['BUSY'], a[0], eax))
        elif address == BLIT:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]),
                                   label=d9.cstr(self.rd(a[4], 64)), label_ptr=a[4]))
        elif address == FREE:
            self.frees.append(a[0])
        else:
            raise d9.OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, pops[address], eax)

    def body_ptr(self, pointer):
        """The body pointer of the row whose body contains `pointer` (the sound records are inside it)."""
        k = (pointer - d9.BODY_BASE) // BODY_STRIDE
        if not 0 <= k < MAX_ROWS:
            raise d9.OracleError('sound record %#x is not inside a row body' % pointer)
        return d9.BODY_BASE + BODY_STRIDE * k

    def _on_write(self, uc, access, address, size, value, user):
        if not self.recording:
            return
        value &= mask(size)
        if ROWS <= address < ROWS + MAX_ROWS * ROW:
            row, off = divmod(address - ROWS, ROW)
            if off == COMPLETE_OFF and size == 1:
                self.events.append(('comp', row, value))
            elif off == PHASE_OFF and size == 4:
                self.events.append(('gphase', row, value) if self.in_complete else ('fx', FX['PHASE'], value, 0))
            return                              # every other row byte is checked by the final image comparison
        if EVENTS_VA <= address < EVENTS_VA + 4 * EVENT_COUNT and size == 4 and (address - EVENTS_VA) % 4 == 0:
            self.events.append(('fx', FX['EVENT_FLAG'], (address - EVENTS_VA) // 4, value))
            return
        hit = WRITE_FX.get(address)
        if hit is not None and hit[1] == size:
            self.events.append(('fx', hit[0], value, 0))
        self.written['%#x/%d' % (address, size)] += 1

    # -- state access ----------------------------------------------------------------------------
    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

    def cell(self, va, size=4):
        return int.from_bytes(self.rd(va, size), 'little')

    def set_cell(self, va, value, size=4):
        self.wr(va, (value & mask(size)).to_bytes(size, 'little'))

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
        self.stops = {}
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.set_queues({k: [] for k in self.qs})
        self.clear_logs()

    def install_rows(self, rows):
        total = len(rows)
        if total > MAX_ROWS or total * BODY_STRIDE > 0xE000:
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

    def run_range(self, queues, start, stops, setup):
        """Run original code from `start` until execution reaches one of `stops` (a frame is built around ebp)."""
        uc = self.machine
        self.begin(queues)
        self.stops = {a: True for a in stops}
        ebp = deps.STACK_TOP - 0x2000
        setup(ebp)
        self._hook_error = None
        self._fatal = None
        for reg in (X.UC_X86_REG_EAX, X.UC_X86_REG_EBX, X.UC_X86_REG_EDX, X.UC_X86_REG_ESI, X.UC_X86_REG_EDI):
            uc.reg_write(reg, 0x5A5A0000 + reg)
        uc.reg_write(X.UC_X86_REG_ECX, 0x77AA77AA)
        uc.reg_write(X.UC_X86_REG_EBP, ebp)
        uc.reg_write(X.UC_X86_REG_ESP, ebp - 0x100)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        try:
            uc.emu_start(start, 0, timeout=900_000_000, count=60000)
        except UcError as error:
            if self._hook_error:
                raise d9.OracleError(self._hook_error) from error
            raise d9.OracleError('x86 range %#x failed at %#x: %s' % (start, uc.reg_read(X.UC_X86_REG_EIP), error)) from error
        finally:
            self.recording = False
            self.stops = {}
        if self._fatal is not None:
            raise d9.Fatal(self._fatal)
        if self._hook_error:
            raise d9.OracleError(self._hook_error)
        if self.stopped_at is None:
            raise d9.OracleError('range %#x did not reach a stop address (eip %#x)' % (start, uc.reg_read(X.UC_X86_REG_EIP)))
        return self.stopped_at, uc.reg_read(X.UC_X86_REG_EAX)

    def run_pointer(self, queues, x, y):
        scratch = 0xCAFE0000 | (x & 0xFFFF)

        def setup(ebp):
            self.wr(EVREC, bytes((0x41 + k) & 0xFF for k in range(0x80)))
            self.w32(EVREC + 0x5E, x)
            self.w32(EVREC + 0x5A, y)
            self.w32(EVREC + 0x62, scratch)
            self.w32(ebp - 4, EVREC)
        return self.run_range(queues, POINTER_RANGE[0], (POINTER_RANGE[1], POINTER_CLAIM), setup)

    def run_click(self, queues):
        def setup(ebp):
            self.wr(ebp - 0x60, bytes(0x40))
        return self.run_range(queues, CLICK_RANGE[0], (CLICK_RANGE[1],), setup)

    def run_render(self, queues):
        self.begin(queues)
        try:
            self.call(RENDER_CB, [], 0)
        finally:
            self.recording = False


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
SOURCES = ('action_family_77_runtime.c',)
STATE_FIELDS = (('selected', 0, 16), ('order', 16, 32), ('active', 48, 1), ('row', 49, 2), ('hover', 51, 2), ('exit', 53, 1),
                ('deadline', 54, 4), ('step', 58, 4), ('count', 62, 2), ('limit', 64, 2), ('solved', 66, 1))
FIELD_POS = {n: (o, s) for n, o, s in STATE_FIELDS}
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
F_LOAD, F_RELEASE, F_PREPARE, F_STOP, F_PLAY, F_BUSY, F_TRANSITION, F_FLAG, F_ORIGIN = 1, 2, 4, 8, 16, 32, 64, 128, 256


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_77_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('A77_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def norm_fx(kind, a, b):
    sa, sb = FX_SIZE.get(kind, (4, 4))
    return ('fx', kind, a & mask(sa), b & mask(sb))


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P, I32, U32 = C.c_void_p, C.c_int32, C.c_uint32
        lib.a77o_new.restype = P
        for name, args, res in (
                ('a77o_free', [P], None), ('a77o_reset', [P], None), ('a77o_clear_logs', [P], None), ('a77o_set_fail', [P, C.c_int], None),
                ('a77o_set_origin', [P, I32, I32], None), ('a77o_q_set', [P, C.c_int, C.POINTER(C.c_int64), C.c_int], None),
                ('a77o_q_pos', [P, C.c_int], C.c_int), ('a77o_q_underflow', [P, C.c_int], C.c_int),
                ('a77o_state_get', [P, C.c_char_p], None), ('a77o_state_set', [P, C.c_char_p], None),
                ('a77o_extra_get', [P, C.POINTER(U32)], None), ('a77o_extra_set', [P, C.POINTER(U32)], None),
                ('a77o_cells_get', [P, C.POINTER(I32)], None), ('a77o_cells_set', [P, C.POINTER(I32)], None),
                ('a77o_events_get', [P, C.c_char_p], None), ('a77o_events_set', [P, C.c_char_p], None),
                ('a77o_log', [P, C.c_int, C.POINTER(I32), C.c_int], C.c_int), ('a77o_name', [P, C.c_int], C.c_char_p),
                ('a77o_nnames', [P], C.c_int),
                ('a77o_step', [P, C.c_char_p, C.c_int, C.c_int, U32, C.POINTER(I32)], None),
                ('a77o_pointer', [P, C.c_char_p, C.c_int, I32, I32, C.POINTER(I32)], None),
                ('a77o_click', [P, C.c_char_p, C.c_int, U32, I32, I32, C.POINTER(I32)], None),
                ('a77o_clear', [P], C.c_int), ('a77o_validate', [C.c_char_p, C.c_int], C.c_int),
                ('a77o_render', [P, C.c_char_p, C.c_int, C.POINTER(I32)], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.a77o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.a77o_free(self.h)

    def reset(self):
        self.lib.a77o_reset(self.h)

    def clear_logs(self):
        self.lib.a77o_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.a77o_set_fail(self.h, m)

    def set_origin(self, x, y):
        self.lib.a77o_set_origin(self.h, x, y)

    def set_queues(self, qs):
        for i, k in enumerate(('rand', 'tick', 'busy', 'handle')):
            vals = list(qs.get(k, []))[:64]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.a77o_q_set(self.h, i, arr, len(vals))

    def qpos(self, k):
        return self.lib.a77o_q_pos(self.h, ('rand', 'tick', 'busy', 'handle').index(k))

    def qunder(self, k):
        return self.lib.a77o_q_underflow(self.h, ('rand', 'tick', 'busy', 'handle').index(k))

    def state(self):
        buf = C.create_string_buffer(CELL_STATE_LEN)
        self.lib.a77o_state_get(self.h, buf)
        return bytes(buf.raw)

    def set_state(self, img):
        self.lib.a77o_state_set(self.h, bytes(img))

    def extra(self):
        arr = (C.c_uint32 * 5)()
        self.lib.a77o_extra_get(self.h, arr)
        return list(arr)

    def set_extra(self, vals):
        arr = (C.c_uint32 * 5)(*[v & 0xFFFFFFFF for v in vals])
        self.lib.a77o_extra_set(self.h, arr)

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.a77o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.a77o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.a77o_events_get(self.h, buf)
        return bytes(buf.raw)

    def set_events(self, data):
        self.lib.a77o_events_set(self.h, bytes(data))

    def log(self, which):
        arr = (C.c_int32 * (3 * 512))()
        n = self.lib.a77o_log(self.h, which, arr, 512)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def names(self):
        return [self.lib.a77o_name(self.h, i).decode('latin1') for i in range(min(self.lib.a77o_nnames(self.h), 8))]

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.a77o_step(self.h, bytes(body), len(body), row, phase, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 6)()
        self.lib.a77o_pointer(self.h, bytes(body), len(body), x, y, out)
        return tuple(out)

    def click(self, body, row_phase, cand, start_flag):
        out = (C.c_int32 * 5)()
        self.lib.a77o_click(self.h, bytes(body), len(body), row_phase, cand, sgn(start_flag, 4), out)
        return tuple(out)

    def clear(self):
        return self.lib.a77o_clear(self.h)

    def validate(self, body):
        return self.lib.a77o_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * (4 + 9 * 16))()
        self.lib.a77o_render(self.h, bytes(body), len(body), out)
        blits = [dict(selected=out[4 + 9 * i], src=tuple(out[5 + 9 * i:9 + 9 * i]), dst=tuple(out[9 + 9 * i:13 + 9 * i])) for i in range(16)]
        return dict(status=out[0], valid=out[1], surface=out[2] & 0xFFFFFFFF, count=out[3], blits=blits)


def pack_state(**kw):
    """The 67-byte image from named fields (selected / order are lists)."""
    b = bytearray(CELL_STATE_LEN)
    for name, v in kw.items():
        off, size = FIELD_POS[name]
        if name == 'selected':
            b[off:off + 16] = bytes(v)
        elif name == 'order':
            struct.pack_into('<16h', b, off, *[sgn(e, 2) for e in v])
        else:
            b[off:off + size] = (v & mask(size)).to_bytes(size, 'little')
    return bytes(b)


def unpack_state(img):
    out = {}
    for name, off, size in STATE_FIELDS:
        out[name] = bytes(img[off:off + size])
    return out


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
def snd(kind):
    return {'none': NO_SOUND, 'real': b'snd_0001\0', 'real2': b'bell_77\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0\0'[:9],
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0'}[kind]


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start)


def rand_block(rng, scene):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)))


def make_body(rng, n=5, l=3, sol=None, name=b'PUZZLE1', snd_a='none', snd_b='none', click_ch=1, win_ch=2, solved=None, ev=(-1, 7),
              delay=1, exit_blk=None, exit_flag=(-1, 0), exit_rect=(200, 10, 260, 40), layout='grid', start_solved=None):
    b = bytearray(rng.getrandbits(8) for _ in range(BODY_LEN))
    b[0:0x21] = name[:0x20].ljust(0x21, b'\0')
    for k in range(len(name) + 1, 0x21):
        b[k] = rng.getrandbits(8)                       # garbage after the terminator
    struct.pack_into('<h', b, 0x21, n)
    for i in range(16):
        if layout == 'grid':
            lft, top = 8 + 36 * (i % 4), 10 + 36 * (i // 4)
            rect = (lft, top, lft + 31, top + 31)
        elif layout == 'overlap':
            rect = (50, 50, 100, 100)
        elif layout == 'neg':
            rect = (-300 + 40 * i, -90, -300 + 40 * i + 30, -50)
        else:
            raise ValueError(layout)
        struct.pack_into('<4i', b, 0x123 + 16 * i, *rect)
        struct.pack_into('<4i', b, 0x23 + 16 * i, 400 + 40 * i, 12, 400 + 40 * i + 31, 43)
    struct.pack_into('<h', b, 0x223, l)
    if sol is None:
        sol = [(3 * k + 1) % max(n, 1) for k in range(l)]
    for k, v in enumerate(sol[:16]):
        b[0x225 + k] = v & 0xFF
    b[0x235:0x23E] = snd(snd_a)
    struct.pack_into('<h', b, 0x256, click_ch)

    def put(off, blk):
        struct.pack_into('<h', b, off, blk['scene'])
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3i', b, off + 8, *[sgn(d, 4) for d in blk['dwords']])
        struct.pack_into('<h', b, off + 0x14 if off == 0x266 else off + 0x14, sgn(blk['start'], 2))
    put(0x266, solved if solved is not None else block(9999))
    struct.pack_into('<h', b, 0x27C, ev[0])
    b[0x27E] = ev[1] & 0xFF
    struct.pack_into('<h', b, 0x27F, delay)
    b[0x281:0x28A] = snd(snd_b)
    struct.pack_into('<h', b, 0x2A2, win_ch)
    put(0x2B2, exit_blk if exit_blk is not None else block(9999))
    struct.pack_into('<h', b, 0x2C8, exit_flag[0])
    b[0x2CA] = exit_flag[1] & 0xFF
    struct.pack_into('<4i', b, 0x2CB, *exit_rect)
    if start_solved is not None:
        struct.pack_into('<h', b, 0x27A, start_solved)
    return bytes(b)


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
DEFAULT_Q = dict(rand=[3, 4, 2, 1], tick=[5000, 5000, 5000, 5000], busy=[0, 0, 0, 0], handle=[0x1234, 0x1235, 0x1236, 0x1237])
POINTER_CELLS = {'ptr_x': (CELL_PTR_X, 4), 'ptr_y': (CELL_PTR_Y, 4), 'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4),
                 'c162d': (CELL_5D162D, 4), 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
ALLOWED_WRITES = {
    'tick': [(CELL_STATE, CELL_STATE + CELL_STATE_LEN), (CELL_SURFACE, CELL_SURFACE + 4), (CELL_OVL_SURFACE, CELL_OVL_SURFACE + 4),
             (CELL_OVL_ACTIVE, CELL_OVL_ACTIVE + 4), (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)]
    + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [(CELL_STATE, CELL_STATE + CELL_STATE_LEN)] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [(CELL_STATE, CELL_STATE + CELL_STATE_LEN)],
    'render': [],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer_claims=Counter(), clicks=Counter(), blits=0, mismatches=0, native_refusal_checks=0, known_divergences=Counter(),
                queue_values_consumed=0, groups={}, ordered_events=0)


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def diff_image(a, b):
    out = []
    for name, off, size in STATE_FIELDS:
        if a[off:off + size] != b[off:off + size]:
            out.append('%s original %s native %s' % (name, a[off:off + size].hex(), b[off:off + size].hex()))
    return out


class Run:
    """Per-scenario model state."""

    def __init__(self, sc, rows):
        self.sc = sc
        self.rows = [dict(r) for r in rows]
        self.count = len(rows)
        self.cells = {}          # expected values of the pointer cells
        self.fx_seen = 0
        self.hc_seen = 0
        self.names_expected = []


def seed_scenario(x, nat, run, rng):
    sc = run.sc
    x.hard_reset()
    nat.reset()
    x.install_rows(run.rows)
    x.w32(CELL_MODE, sc['mode'])
    # event flag window: a pseudo-random pattern, the gate flags 1000.. overridden by the scenario
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & 0xFFFFFFFF)
    for k in range(1000, 1008):
        struct.pack_into('<I', pattern, 4 * k, 0)
    for idx, v in sc['events'].items():
        struct.pack_into('<i', pattern, 4 * idx, v)
    x.wr(EVENTS_VA, pattern)
    nat.set_events(pattern)
    # process image: garbage unless the scenario names the field
    garb = dict(selected=[rng.choice((0, 1, 1, 0x80, 0xFF)) for _ in range(16)], order=[rng.choice((-1, 0, 1, 2, 5, 15, 0x7FFF)) for _ in range(16)],
                active=rng.choice((0, 1, 0xFE)), row=rng.choice((0, 1, 3, -1, 0x7000)), hover=rng.choice((0, 1, 4)), exit=rng.choice((0, 1, 0xFF)),
                deadline=rng.getrandbits(32), step=rng.choice((0, 1, 2, 3, 4, 0xFFFFFFFF)), count=rng.choice((0, 3, 16)),
                limit=rng.choice((0, 2, 9)), solved=rng.choice((0, 1, 0x7F)))
    garb.update(sc['init'].get('state', {}))
    img = pack_state(**garb)
    x.wr(CELL_STATE, img)
    nat.set_state(img)
    extra = [sc['init'].get('surface', rng.choice((0, 0x5151, 0xFFFFFFFF))), sc['init'].get('ovl', rng.choice((0, 0x6161, 0x80000001))),
             sc['init'].get('ovl_active', rng.choice((0, 1, 7))), 1 if sc['init'].get('native_init') else 0,
             sc['init'].get('start', rng.choice((0, 1, 0xFFFFFFFF, 5)))]
    x.set_cell(CELL_SURFACE, extra[0])
    x.set_cell(CELL_OVL_SURFACE, extra[1])
    x.set_cell(CELL_OVL_ACTIVE, extra[2])
    x.set_cell(CELL_START, extra[4])
    nat.set_extra(extra)
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    for name, (va, sz) in POINTER_CELLS.items():
        v = {'cand': 0, 'k0': rng.choice((0, 1, 4, 7)), 'k1': rng.choice((0, 1))}.get(name, rng.getrandbits(32))
        v = sc['init'].get(name, v)
        x.set_cell(va, v, sz)
        run.cells[name] = v & mask(sz)
    x.set_cell(CELL_5D0377, sc['init'].get('c0377', 0x0BAD0377))
    x.set_cell(CELL_BG, BG_HANDLE)
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    x.set_cell(CELL_ORG_X, 0)
    x.set_cell(CELL_ORG_Y, 0)
    nat.set_origin(0, 0)


def compare_all(where, x, nat, stats, run, rows=True):
    img_x, img_n = x.rd(CELL_STATE, CELL_STATE_LEN), nat.state()
    if img_x != img_n:
        raise Mismatch('%s: process image 0x5b5128..0x5b516a differs: %s' % (where, '; '.join(diff_image(img_x, img_n))))
    stats['compared_fields'] += len(STATE_FIELDS)
    ex = nat.extra()
    check(stats, where, 'cell 0x5d03cf (puzzle surface)', x.cell(CELL_SURFACE), ex[0])
    check(stats, where, 'cell 0x5d1a83 (overlay surface)', x.cell(CELL_OVL_SURFACE), ex[1])
    check(stats, where, 'cell 0x5d1a8f (overlay active)', x.cell(CELL_OVL_ACTIVE), ex[2])
    check(stats, where, 'cell 0x5bb1ca (start flag)', x.cell(CELL_START), ex[4])
    cells = nat.cells()
    check(stats, where, 'engine mode 0x583999', sgn(x.cell(CELL_MODE), 4), cells[0])
    for k, (name, va, sz) in enumerate(XFER):
        check(stats, where, 'scene-change cell ' + name, sgn(x.cell(va, sz), sz), cells[1 + k] if sz == 4 else sgn(cells[1 + k], 2))
    check(stats, where, 'event flag window (4096 dwords)', x.rd(EVENTS_VA, 4 * EVENT_COUNT), nat.events())
    for name, (va, sz) in POINTER_CELLS.items():
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


def check_queues(where, x, nat, queues, stats):
    for k in ('rand', 'tick', 'busy', 'handle'):
        check(stats, where, 'queue %s consumed' % k, x.qpos[k], nat.qpos(k))
        check(stats, where, 'queue %s underflow (native)' % k, 0, nat.qunder(k))
        stats['queue_values_consumed'] += x.qpos[k]


def native_fx(nat, run):
    """New observer entries and host calls since the previous call."""
    fx, hc = nat.log(0), nat.log(1)
    nf, nh = fx[run.fx_seen:], hc[run.hc_seen:]
    run.fx_seen, run.hc_seen = len(fx), len(hc)
    mapped = [norm_fx(k, a, b) for k, a, b in nf]
    hosts = [norm_fx(k, a, b) for k, a, b in nh]
    only = [e for e in mapped if e[1] in HOST_FX]
    return mapped, hosts, only


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(rows))]
    nat.set_queues(queues)
    x.dispatch(queues)
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  (rows never write the gate flags the tails read)
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
                ex = nat.extra()
                ex[4] = 1
                nat.set_extra(ex)
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0x77:
                visit_77(where, nat, run, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', x.events, expected)
    stats['ordered_events'] += len(x.events)
    check(stats, where, 'image names the loader was asked for', x.loaded, run.loaded_expected)
    run.loaded_expected = []
    check_queues(where, x, nat, queues, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


def visit_77(where, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= 0xFFFFFFFF
    mapped, hosts, host_only = native_fx(nat, run)
    if status != OK:
        raise Mismatch('%s: native a77_step status %d for row %d phase %d' % (where, status, i, phase))
    expected.append(('handler', i, phase))
    expected.extend(mapped)
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1
    stats['handler_visits']['phase%d' % phase if phase in (0, 1, 2) else 'other'] += 1
    run.loaded_expected += [d9.cstr(body[:0x21]).decode('latin1')] * sum(1 for e in mapped if e[1] == FX['LOAD'])
    if completed:
        check(stats, where, 'native completion phase', phase_after, 0)
        sub = r['subtype']
        if sub == 1:
            expected.append(('comp', i, 1))
            r['completed'] = 1
        elif sub == 2:
            expected += [('comp', i, 0), ('reset', i)]
            r['completed'] = 0
        expected.append(('gphase', i, 0))
        r['phase'] = 0
    else:
        r['phase'] = phase_after


def do_pointer(where, x, nat, run, stats, px, py):
    stats['actions']['pointer'] += 1
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    row = struct.unpack_from('<h', nat.state(), 49)[0]
    active = nat.state()[48]
    if active:
        body = run.rows[row]['body']
    else:
        body = run.rows[0]['body']
    pre = dict(run.cells)
    stop, eax = x.run_pointer({}, px, py)
    status, hit, cand, hover, k0, k1 = nat.pointer(body, px, py)
    if status != OK:
        raise Mismatch('%s: native a77_pointer status %d' % (where, status))
    check(stats, where, 'pointer: claimed (stop address 0x4f2578) versus native hit', stop == POINTER_CLAIM, bool(hit))
    if hit:
        check(stats, where, 'pointer: return value of a claim', eax, 1)
    stats['pointer_claims']['button' if hit and cand == 0x2719 else 'exit' if hit else 'none' if active else 'inactive'] += 1
    run.cells['ptr_x'], run.cells['ptr_y'] = px & 0xFFFFFFFF, py & 0xFFFFFFFF
    if cand != -1:
        run.cells['cand'] = cand
    k0_after, k1_after = (k0 if k0 != 0 else pre['k0']), (k1 if k1 != 0 else pre['k1'])
    run.cells['k0'], run.cells['k1'] = k0_after, k1_after
    if hit:
        # the host-composed cells (documented: 0x5b160c + (kind << 5) + (sub << 4)); the exit rectangle also copies [0x5d0377]
        run.cells['c1631'] = (CURSOR_TABLE + (k0_after << 5) + (k1_after << 4)) & 0xFFFFFFFF
        if cand == 0x271A:
            run.cells['c162d'] = x.cell(CELL_5D0377)
            run.cells['c1639'] = 1
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run)


def do_click(where, x, nat, run, stats):
    stats['actions']['click'] += 1
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    img = nat.state()
    row, active, solved = struct.unpack_from('<h', img, 49)[0], img[48], img[66]
    hover = struct.unpack_from('<h', img, 51)[0]
    n_body = run.rows[row]['body'] if 0 <= row < len(run.rows) else run.rows[0]['body']
    nb = struct.unpack_from('<h', n_body, 0x21)[0]
    if run.cells['cand'] == 0x2719 and active and not solved and not (0 <= hover < nb):
        raise d9.OracleError('%s: scenario clicks on a hover outside the button range (native refusal case)' % where)
    r = run.rows[row]
    ex = nat.extra()
    nat.set_queues({})
    stop, eax = x.run_click({})
    status, toggled, exit_asked, new_phase, click_sound = nat.click(r['body'], r['phase'], run.cells['cand'], ex[4])
    if status != OK:
        raise Mismatch('%s: native a77_click status %d' % (where, status))
    mapped, hosts, host_only = native_fx(nat, run)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'click: ordered effects (sound play, row phase)', x.events, mapped)
    check(stats, where, 'click: stop address', stop, CLICK_RANGE[1])
    stats['clicks']['toggle' if toggled else 'exit' if exit_asked else 'none'] += 1
    if click_sound:
        stats['clicks']['sound'] += 1
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1
    if exit_asked:
        r['phase'] = new_phase
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def do_render(where, x, nat, run, stats, ox, oy):
    stats['actions']['render'] += 1
    x.set_cell(CELL_ORG_X, ox)
    x.set_cell(CELL_ORG_Y, oy)
    nat.set_origin(sgn(ox, 4), sgn(oy, 4))
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    img = nat.state()
    row = struct.unpack_from('<h', img, 49)[0]
    body = run.rows[row]['body']
    x.run_render({})
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native a77_render_plan status %d' % (where, plan['status']))
    n = struct.unpack_from('<h', body, 0x21)[0]
    ovl = x.cell(CELL_OVL_SURFACE)
    check(stats, where, 'render: blit count (original draws N unconditionally)', len(x.blits), n)
    check(stats, where, 'render: native plan valid iff the overlay is active', plan['valid'], 1 if x.cell(CELL_OVL_ACTIVE) else 0)
    if not plan['valid']:
        check(stats, where, 'render: empty plan when inactive', (plan['count'], plan['blits'][0]['dst']), (0, (0, 0, 0, 0)))
    else:
        check(stats, where, 'render: plan surface', plan['surface'], ovl)
        check(stats, where, 'render: plan count', plan['count'], n)
        for k, b in enumerate(x.blits):
            p = plan['blits'][k]
            sel = b['src_surface'] == ovl
            check(stats, where, 'render blit %d: selected state (source surface is the overlay)' % k, (1 if sel else 0), p['selected'])
            check(stats, where, 'render blit %d: selected versus the byte 0x5b5128+i' % k, 1 if img[k] else 0, p['selected'])
            check(stats, where, 'render blit %d: this pointer' % k, b['this'], THIS_SURF)
            check(stats, where, 'render blit %d: source surface' % k, b['src_surface'], ovl if sel else BG_HANDLE)
            check(stats, where, 'render blit %d: target surface' % k, b['target'], TARGET_HANDLE)
            check(stats, where, 'render blit %d: source rectangle contents' % k, b['src'], tuple(p['src']))
            check(stats, where, 'render blit %d: destination rectangle contents' % k, b['dst'], tuple(p['dst']))
            check(stats, where, 'render blit %d: label (string, address)' % k, (b['label'], b['label_ptr']),
                  (LABEL_SELECTED_BLIT, LABEL_VA_SELECTED if sel else LABEL_VA_UNSELECTED))
            stats['blits'] += 1
    check(stats, where, 'render: no stray effects', x.events, [])
    check_writes(where, x, 'render', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.rd(CELL_STATE, CELL_STATE_LEN))
    ex = nat.extra()
    for k, v in d.items():
        if k in FIELD_POS:
            off, size = FIELD_POS[k]
            if k == 'selected':
                img[off:off + 16] = bytes(v)
            elif k == 'order':
                struct.pack_into('<16h', img, off, *[sgn(e, 2) for e in v])
            else:
                img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
        elif k == 'start':
            x.set_cell(CELL_START, v)
            ex[4] = v
        elif k == 'surface':
            x.set_cell(CELL_SURFACE, v)
            ex[0] = v
        elif k == 'ovl':
            x.set_cell(CELL_OVL_SURFACE, v)
            ex[1] = v
        elif k == 'ovl_active':
            x.set_cell(CELL_OVL_ACTIVE, v)
            ex[2] = v
        elif k == 'native_init':
            ex[3] = v
        elif k == 'mode':
            x.set_cell(CELL_MODE, v)
            cells = nat.cells()
            nat.set_cells([v] + cells[1:8])
        else:
            raise d9.OracleError('unknown set key ' + k)
    x.wr(CELL_STATE, bytes(img))
    nat.set_state(bytes(img))
    nat.set_extra(ex)


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
    run.loaded_expected = []
    run.row_images = []
    seed_scenario(x, nat, run, rng)
    nat.clear_logs()
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            queues = {**DEFAULT_Q, **(act[1] if len(act) > 1 else {})}
            do_tick(where, x, nat, run, stats, queues, rng)
        elif kind == 'pointer':
            do_pointer(where, x, nat, run, stats, act[1], act[2])
        elif kind == 'click':
            do_click(where, x, nat, run, stats)
        elif kind == 'render':
            do_render(where, x, nat, run, stats, act[1], act[2])
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
        elif kind == 'rearm':
            for i, r in enumerate(run.rows):
                if r['type'] in ARM:
                    r['completed'] = 0
                    r['phase'] = 0
                    x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                    x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        else:
            raise d9.OracleError('unknown action ' + kind)
        stats['actions'][kind] += 1
    stats['scenarios'] += 1


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
RANDS = [0, 1, 2, 3, 4, 5, 6, 7, 9, 12349, 32767, 30001]
SOUNDS_A = ['none', 'real', 'near1', 'near2', 'near3', 'zero', 'near4', 'real2']
HANDLES = [0x4441, 0, 0xFFFFFFFF, 1, 0x7FFFFFFF]


def R77(body, subtype=1, tail=b'', **kw):
    d = dict(type=0x77, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA,
             word=0x1234, erased=False)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA,
             word=0x1234, erased=False)
    d.update(kw)
    return d


def centers(body):
    n = struct.unpack_from('<h', body, 0x21)[0]
    out = []
    for i in range(n):
        lft, top, rgt, bot = struct.unpack_from('<4i', body, 0x123 + 16 * i)
        out.append(((lft + rgt) // 2, (top + bot) // 2))
    return out


def exit_center(body):
    lft, top, rgt, bot = struct.unpack_from('<4i', body, 0x2CB)
    return (lft + rgt) // 2, (top + bot) // 2


def solved_ticks(body, delay_ms_tick=5000):
    """The queue overrides of the first pass that finds the ordering solved (nothing consumed)."""
    return {}


def scenario_list(seed=0x7749):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    # ---- phase 0 -------------------------------------------------------------------------------
    combos = [(0, 0), (0, 1), (1, 0), (1, 1), (5, 0), (5, 1), (5, 5), (16, 0), (16, 1), (16, 16), (1, 5), (5, 16)]
    for k, (n, l) in enumerate(combos):
        for j in range(3):
            r = RANDS[(k * 3 + j) % len(RANDS)]
            body = make_body(rng, n=n, l=l, snd_a=SOUNDS_A[(k + j) % len(SOUNDS_A)], name=rng.choice((b'PUZZLE1', b'A', b'x' * 32)))
            S('init:n%d_l%d_rand%d_%d' % (n, l, r, j), [R77(body)], [tk(rand=[r], handle=[HANDLES[(k + j) % len(HANDLES)]]), tk()],
              'init', init=dict(surface=rng.choice((0, 0x5151)), ovl=rng.choice((0, 0x6161))), quick=(k, j) in ((2, 0), (6, 1), (9, 2)))
    for r in RANDS:
        body = make_body(rng, n=16, l=3)
        S('init:rand%d_modulo' % r, [R77(body)], [tk(rand=[r])], 'init', quick=r in (0, 1, 32767))
    for kind in SOUNDS_A:
        body = make_body(rng, n=4, l=2, snd_a=kind)
        S('init:sound_a_' + kind, [R77(body)], [tk(), tk()], 'init', quick=kind in ('real', 'near1'))
    S('init:stale_state_released', [R77(make_body(rng, n=3, l=2))], [tk()], 'init',
      init=dict(surface=0x7777, ovl=0x8888, ovl_active=1, state=dict(active=1, exit=1, solved=1, step=3, count=9)), quick=True)

    # ---- state 0: solved / unsolved / reset --------------------------------------------------------
    for n, l, case in ((5, 3, 'solved'), (5, 3, 'unsolved_low'), (5, 3, 'unsolved_full'), (5, 3, 'unsolved_over'), (16, 16, 'solved'), (16, 16, 'unsolved_last'),
                       (1, 0, 'solved'), (0, 0, 'solved'), (5, 4, 'ff_vs_empty'), (5, 3, 'wide_value')):
        body = make_body(rng, n=n, l=l, sol=[0xFF] * 16 if case == 'ff_vs_empty' else None)
        sol = list(body[0x225:0x225 + l])
        if case in ('solved',):
            order, count = sol + [-1] * (16 - l), l
        elif case == 'unsolved_low':
            order, count = [(v + 1) % max(n, 1) for v in sol] + [-1] * (16 - l), 1
        elif case == 'unsolved_full':
            order, count = [(v + 1) % max(n, 1) for v in sol] + [-1] * (16 - l), n
        elif case == 'unsolved_over':
            order, count = [(v + 1) % max(n, 1) for v in sol] + [-1] * (16 - l), 16
        elif case == 'unsolved_last':
            order, count = sol[:-1] + [(sol[-1] + 1) % 16] + [-1] * (16 - l), l
        elif case == 'ff_vs_empty':
            order, count = [-1] * 16, 2
        else:
            order, count = [0x1FF] + sol[1:] + [-1] * (16 - l), l
        S('state0:%s_n%d_l%d' % (case, n, l), [R77(body)], [tk(rand=[4]), ('set', dict(order=order, count=count, selected=[1] * 16)), tk(), tk()], 'state0',
          quick=(case, n) in (('solved', 5), ('unsolved_full', 5), ('ff_vs_empty', 5)))
    for lim_rand in (0, 1, 2, 3, 4):
        body = make_body(rng, n=5, l=2)
        S('state0:limit_rand%d' % lim_rand, [R77(body)], [tk(rand=[lim_rand]), ('set', dict(order=[4, 4] + [-1] * 14, count=2 + (lim_rand if lim_rand > 1 else 2) - 1)), tk(),
                                                           ('set', dict(count=2 + (lim_rand if lim_rand > 1 else 2))), tk()], 'state0')

    # ---- state 1 / 2 / 3 and phase 2 (solved path) ------------------------------------------------------
    for case in range(60):
        n = rng.choice((1, 5, 16))
        l = rng.choice((0, 1, n))
        delay = rng.choice((0, 1, 3, -2, 32767, -32768, 7))
        t0 = rng.choice((0, 1000, 0xFFFFFC17, 0x7FFFFFFF, 0xFFFFFFFF, 123456))
        dl = (t0 + delay * 1000) & 0xFFFFFFFF
        ts = [(dl - 1) & 0xFFFFFFFF, dl, (dl + 1) & 0xFFFFFFFF, (dl + 0x80000000) & 0xFFFFFFFF, (dl - 0x80000000) & 0xFFFFFFFF, 0, 0xFFFFFFFF]
        ev = rng.choice(((-1, 7), (0, 7), (100, 0), (4095, 255), (1003, 300), (2047, 1)))
        snd_b = rng.choice(('none', 'real', 'real2', 'near1', 'none'))
        win_ch = rng.choice((2, 0, -3, 32767, 0x4001))
        solved = rng.choice((block(9999, (1, 2, 3), (4, 5, 6), 1), rand_block(rng, 42), rand_block(rng, -5), rand_block(rng, 0x8000 - 0x10000), rand_block(rng, 0x2710), rand_block(rng, 0xA70F - 0x10000),
                             rand_block(rng, 1), rand_block(rng, 0), block(9999)))
        body = make_body(rng, n=n, l=l, snd_a=rng.choice(('none', 'real')), snd_b=snd_b, win_ch=win_ch, solved=solved, ev=ev, delay=delay,
                         start_solved=rng.choice((1, 0, 2, -1, 0x101)))
        sol = list(body[0x225:0x225 + l])
        sub = rng.choice((1, 1, 2, 0, 3))
        acts = [tk(rand=[rng.choice(RANDS)]), ('set', dict(order=sol + [-1] * (16 - l), count=l)), tk(),             # init, state 0 solved
                tk(tick=[t0]),                                                                                          # state 1
                tk(tick=[ts[0]]), tk(tick=[ts[rng.randrange(1, 4)]]), tk(tick=[ts[rng.randrange(4, 7)]]),            # state 2 attempts
                tk(busy=[1]), tk(busy=[2]), tk(busy=[0xFFFFFFFF]), tk(busy=[0]), tk(), tk()]
        S('solved_path:%d_n%d_l%d_snd%s_d%d_sub%d' % (case, n, l, snd_b, delay, sub), [R77(body, subtype=sub)], acts, 'solved_path',
          events={}, quick=case in (0, 1, 2, 3, 4, 5))

    # ---- exit path -------------------------------------------------------------------------------------
    for case in range(36):
        n = rng.choice((1, 5, 16))
        blk = rng.choice((block(9999, (7, 8, 9), (1, 2, 3), 1), rand_block(rng, 17), rand_block(rng, -1), rand_block(rng, 0x270E), rand_block(rng, 0x2710), rand_block(rng, 0xA70F - 0x10000), rand_block(rng, 3)))
        flag = rng.choice(((-1, 0), (5, 9), (4095, 255), (0, 1), (1003, 1), (700, 300)))
        body = make_body(rng, n=n, l=rng.choice((0, 1, n)), snd_a=rng.choice(('none', 'real')), exit_blk=dict(blk, start=rng.choice((1, 0, 2, -1))), exit_flag=flag,
                         solved=rand_block(rng, 55))
        ex, ey = exit_center(body)
        acts = [tk(), ('pointer', ex, ey), ('click',), tk(), tk(), ('set', dict(mode=3)), tk()]
        if case % 3 == 0:
            acts = [tk(), ('pointer', 0, 0), ('pointer', ex, ey), ('click',), ('click',), tk(), ('pointer', ex, ey), ('click',), tk()]
        S('exit_path:%d_n%d_flag%d' % (case, n, flag[0]), [R77(body, subtype=rng.choice((1, 1, 2)))], acts, 'exit_path', quick=case in (0, 1, 2, 3))

    # ---- click sequences -------------------------------------------------------------------------------
    for case in range(36):
        n = rng.choice((1, 2, 3, 5, 16))
        body = make_body(rng, n=n, l=min(n, rng.choice((0, 1, 2, n))), snd_a=rng.choice(('none', 'real', 'near1')), click_ch=rng.choice((1, 0, -4, 32767)))
        cs = centers(body)
        acts = [tk(rand=[rng.choice(RANDS)])]
        for _ in range(rng.randint(8, 24)):
            b = rng.randrange(n)
            acts += [('pointer', cs[b][0], cs[b][1]), ('click',)]
            if rng.random() < 0.15:
                acts.append(('set', dict(start=rng.choice((0, 1, 5)))))
            if rng.random() < 0.1:
                acts.append(tk())
        if case % 5 == 0:
            acts.append(('set', dict(solved=1)))
            acts += [('pointer', cs[0][0], cs[0][1]), ('click',)]
        if case % 7 == 0:
            acts.insert(2, ('set', dict(start=0)))
        S('click:%d_n%d' % (case, n), [R77(body)], acts, 'click', init=dict(start=rng.choice((0, 1))), quick=case in (0, 1, 2))
    for case in range(6):          # the pop on an inconsistent state (selected byte set, count 0), and candidates the block ignores
        body = make_body(rng, n=3, l=2, snd_a='real')
        cs = centers(body)
        pop = [1, 2, 0][case % 3]
        acts = [tk(), ('set', dict(selected=[1] * 16, count=0, order=[pop] + [-1] * 15, hover=1, cand=0x2719, solved=0, start=1)), ('click',),
                ('set', dict(selected=[1] * 16, count=0, order=[1] + [-1] * 15, hover=1, cand=0x2719)), ('click',)]
        for other in (0, 0x2718, 0x271B, 0xFFFF, 0x2719 ^ 0x100):
            acts += [('set', dict(cand=other, hover=2, solved=0, active=1)), ('click',)]
        S('click:inconsistent_%d' % case, [R77(body)], acts, 'click', quick=case == 0)
    for case in range(4):
        body = make_body(rng, n=3, l=2)
        cs = centers(body)
        acts = [('set', dict(active=0, row=0)), ('pointer', cs[1][0], cs[1][1]), ('set', dict(cand=0x2719, hover=1)), ('click',),
                ('set', dict(cand=0x271A, solved=0)), ('click',), ('set', dict(cand=0x2718)), ('click',), ('set', dict(cand=0x271B)), ('click',)]
        S('click:inactive_%d' % case, [R77(body)], acts, 'click', quick=case == 0)

    # ---- pointer sweeps ----------------------------------------------------------------------------------
    for layout in ('grid', 'overlap', 'neg'):
        for n in (0, 1, 5, 16):
            body = make_body(rng, n=n, l=min(n, 2), layout=layout, exit_rect=rng.choice(((200, 10, 260, 40), (-100, -100, -50, -80), (0, 0, 0, 0), (60, 60, 90, 90))))
            probes = []
            for i in range(n):
                lft, top, rgt, bot = struct.unpack_from('<4i', body, 0x123 + 16 * i)
                for (px, py) in ((lft, top), (rgt, bot), (lft - 1, top), (lft, top - 1), (rgt + 1, bot), (rgt, bot + 1), (lft - 1, bot + 1), ((lft + rgt) // 2, (top + bot) // 2),
                                 (rgt, top), (lft, bot)):
                    probes.append((px, py))
            ex = struct.unpack_from('<4i', body, 0x2CB)
            for (px, py) in ((ex[0], ex[1]), (ex[2], ex[3]), (ex[0] - 1, ex[1]), (ex[0], ex[1] - 1), (ex[2] + 1, ex[3]), (ex[2], ex[3] + 1),
                             ((ex[0] + ex[2]) // 2, (ex[1] + ex[3]) // 2), (ex[2], ex[1]), (ex[0], ex[3])):
                probes.append((px, py))
            probes += [(rng.randint(-120, 280), rng.randint(-120, 200)) for _ in range(12)] + [(0x7FFFFFFF, 0x7FFFFFFF), (-0x80000000, -0x80000000)]
            for active in (1, 0):
                acts = [('set', dict(active=active, row=0, k0=rng.choice((0, 3, 9)), k1=rng.choice((0, 1))))]
                acts += [('pointer', px, py) for px, py in probes]
                S('pointer:%s_n%d_active%d' % (layout, n, active), [R77(body)], acts, 'pointer', quick=(layout, n, active) in (('grid', 5, 1), ('overlap', 5, 1), ('neg', 1, 1), ('grid', 5, 0)))

    for n in (1, 5, 16):           # the exit rectangle on top of a button: the buttons win
        body = make_body(rng, n=n, l=1, exit_rect=(8, 10, 39, 41))
        cs = centers(body)
        ex, ey = exit_center(body)
        S('pointer:exit_over_button_n%d' % n, [R77(body)], [('set', dict(active=1, row=0)), ('pointer', ex, ey), ('pointer', 8, 10), ('pointer', 39, 41),
                                                            ('pointer', 40, 41), ('click',)], 'pointer', quick=n == 5)

    # ---- render ----------------------------------------------------------------------------------------------
    for case in range(16):
        n = rng.choice((0, 1, 5, 16))
        body = make_body(rng, n=n, l=min(n, 2), layout=rng.choice(('grid', 'neg', 'overlap')))
        sel = [rng.choice((0, 1, 1, 0x80, 0xFF)) for _ in range(16)]
        org = rng.choice(((0, 0), (100, -50), (-300, 77), (0x7FFFFFF0, 0x7FFFFFFF), (-0x80000000, -0x80000000), (5, 6)))
        acts = [('set', dict(row=0, selected=sel, ovl_active=rng.choice((1, 1, 0, 7)), ovl=rng.choice((0x6161, 0x1, 0x80000001)))), ('render', org[0], org[1]),
                ('set', dict(selected=[0] * 16)), ('render', 0, 0), ('set', dict(selected=[1] * 16)), ('render', org[1], org[0])]
        S('render:%d_n%d' % (case, n), [R77(body)], acts, 'render', quick=case in (0, 1, 2))

    # ---- dependency tails, neighbours, passes stopped by the mode ------------------------------------------------
    for case in range(10):
        body = make_body(rng, n=5, l=2, snd_a='real')
        tail = event_tail(1003, 1)
        acts = [tk(), ('events', {1003: 1}), tk(), ('set', dict(order=list(body[0x225:0x227]) + [-1] * 14, count=2)), tk(), tk(tick=[1000]), tk(tick=[9000]), tk(), tk()]
        rows = [R67(), R77(body, tail=tail), R67(loaded=3)] if case % 2 else [R77(body, tail=tail), R67()]
        S('dep:%d' % case, rows, acts, 'dep', events={1003: 0 if case < 8 else 1}, quick=case in (0, 1))
    for case in range(8):
        solved = rand_block(rng, 21 + case) if case % 2 == 0 else block(9999)
        exit_flag = (1003, 1)
        b0 = make_body(rng, n=3, l=1, solved=solved, exit_blk=rand_block(rng, 9) if case % 2 else block(9999), exit_flag=exit_flag)
        b1 = make_body(rng, n=4, l=2, snd_a='real')
        cs = centers(b0)
        ex, ey = exit_center(b0)
        S('chain:%d' % case, [R77(b0), R77(b1, tail=event_tail(1003, 1)), R67()],
          [tk(), ('pointer', ex, ey), ('click',), tk(), ('set', dict(mode=3)), tk(), tk(), tk(), ('pointer', cs[1][0], cs[1][1]) if False else ('pointer', 0, 0)],
          'dep', events={1003: 0}, quick=case == 0)
    for case in range(6):
        body = make_body(rng, n=2, l=1, solved=rand_block(rng, 30))
        sol = list(body[0x225:0x226])
        S('mode:%d' % case, [R67(), R77(body, subtype=1 + case % 2), R67(), R77(make_body(rng, n=2, l=1), subtype=1, completed=1)],
          [tk(), ('set', dict(order=sol + [-1] * 15, count=1)), tk(), tk(), tk(), ('set', dict(mode=3)), tk(), tk(tick=[1, 2]), tk()], 'mode', quick=case == 0)

    # ---- phases outside 0..2 and rows in odd states ----------------------------------------------------------------
    for ph in (3, 4, 9, 0xFFFFFFFF):
        body = make_body(rng, n=3, l=1)
        S('phase_other:%#x' % (ph & 0xFFFFFFFF), [R77(body, phase=ph)], [tk(), tk()], 'phase_other', quick=ph == 3)
    for case in range(3):
        body = make_body(rng, n=3, l=1)
        S('rows_skipped:%d' % case, [R77(body, completed=1), R77(body, unloaded=1), R77(body, loaded=5)], [tk(), tk()], 'phase_other')

    # ---- random play ------------------------------------------------------------------------------------------------
    for case in range(60):
        n = rng.choice((1, 2, 3, 5, 8, 16))
        l = rng.choice((0, 1, 2, n))
        body = make_body(rng, n=n, l=l, snd_a=rng.choice(('none', 'real', 'near2')), snd_b=rng.choice(('none', 'real')),
                         solved=rng.choice((block(9999), rand_block(rng, 12), rand_block(rng, -2))),
                         exit_blk=rng.choice((block(9999), rand_block(rng, 77))), ev=rng.choice(((-1, 0), (3, 4), (1003, 1))),
                         exit_flag=rng.choice(((-1, 0), (9, 9))), delay=rng.choice((0, 1, 2)), layout=rng.choice(('grid', 'grid', 'overlap')),
                         click_ch=rng.choice((0, 1, 9)), win_ch=rng.choice((0, 3)))
        cs = centers(body)
        sol = list(body[0x225:0x225 + l])
        acts = [tk(rand=[rng.choice(RANDS)])]
        t = 100000
        for _ in range(rng.randint(8, 22)):
            c = rng.random()
            if c < 0.30:
                b = rng.randrange(n)
                acts += [('pointer', cs[b][0], cs[b][1]), ('click',)]
            elif c < 0.38:
                ex, ey = exit_center(body)
                acts += [('pointer', ex, ey)] + ([('click',)] if rng.random() < 0.7 else [])
            elif c < 0.48:
                acts.append(('pointer', rng.randint(-20, 300), rng.randint(-20, 200)))
            elif c < 0.56:
                acts.append(('set', dict(order=sol + [-1] * (16 - l), count=l)))
            elif c < 0.62:
                acts.append(('set', dict(count=rng.randint(0, n), order=[rng.choice((-1, 0, n - 1)) for _ in range(16)])))
            elif c < 0.70:
                acts.append(('render', rng.randint(-5, 5), rng.randint(-5, 5)))
            elif c < 0.74:
                acts.append(('set', dict(mode=3)))
            else:
                t += rng.choice((10, 1000, 2000, 50000))
                acts.append(tk(tick=[t, t, t], busy=[rng.choice((0, 1))], rand=[rng.choice(RANDS)]))
        acts += [tk(tick=[t + 10 ** 6]), tk(tick=[t + 2 * 10 ** 6]), tk(tick=[t + 3 * 10 ** 6])]
        S('random:%d_n%d_l%d' % (case, n, l), [R77(body, subtype=rng.choice((1, 1, 2)))], acts, 'random', init=dict(state=dict(hover=0)), quick=case < 3)
    return scs


# ---------------------------------------------------------------------------------------------
# native-only checks (the safety layer and the scene clear; not comparable with the original)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.state(), nat.extra(), nat.cells()[:8], nat.events(), nat.log(0), nat.log(1))


def refusal_checks(nat, stats):
    rng = random.Random(0x7701)
    base = make_body(rng, n=5, l=3, snd_a='real', snd_b='real', ev=(5, 9), exit_flag=(6, 1), solved=rand_block(rng, 12), exit_blk=rand_block(rng, 13))

    def fresh(**state):
        nat.reset()
        nat.set_queues(DEFAULT_Q)
        nat.clear_logs()
        nat.set_state(pack_state(**{'order': [-1] * 16, 'selected': [0] * 16, **state}))
        nat.set_cells([3, 0, 0, 0, 0, 0, 0, 0])
        nat.set_origin(1, 2)

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    # K1: bodies
    bad = {'short': base[:-1], 'long': base + b'\0', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:], 'N=17': base[:0x21] + struct.pack('<h', 17) + base[0x23:],
           'N=-1': base[:0x21] + struct.pack('<h', -1) + base[0x23:], 'L=17': base[:0x223] + struct.pack('<h', 17) + base[0x225:],
           'L=-1': base[:0x223] + struct.pack('<h', -1) + base[0x225:]}
    for name, b in bad.items():
        fresh(active=1, row=0)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
        expect('K1 click ' + name, nat.click(b, 1, 0x2719, 1)[0], ERR_ARGUMENT)
        expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
        expect('K1 no effect ' + name, snapshot(nat), snap)
    expect('K1 valid body accepted', nat.validate(base), OK)
    # K2: phase 1 / 2 without initialisation, or for another row
    for ph in (1, 2):
        for variant in ('uninitialised', 'other row'):
            fresh(active=1, row=3 if variant == 'other row' else 0, step=1)
            if variant == 'other row':
                nat.set_extra([0, 0, 0, 1, 0])
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K3: event flag outside the host window
    for idx in (4096, -2, 32767, -32768):
        for ph, st in ((1, dict(step=1)), (2, dict(exit=1))):
            body = bytearray(base)
            struct.pack_into('<h', body, 0x27C if ph == 1 else 0x2C8, idx)
            fresh(active=1, row=0, **st)
            nat.set_extra([0, 0, 0, 1, 0])
            snap = snapshot(nat)
            expect('K3 phase %d flag %d' % (ph, idx), nat.step(bytes(body), 0, ph)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    # K4: click on a hover outside the buttons, or a count outside 0..16
    for hover, count in ((5, 0), (-1, 0), (0x7000, 0), (0, 17), (0, -1)):
        fresh(active=1, row=0, hover=hover, count=count)
        snap = snapshot(nat)
        expect('K4 hover %d count %d' % (hover, count), nat.click(base, 1, 0x2719, 1)[0], ERR_BOUNDS)
        expect('K4 no effect', snapshot(nat), snap)
    # K5: host failures
    cases = [('phase0 load', F_LOAD, 0, {}, None), ('phase0 release', F_RELEASE, 0, {}, None), ('phase0 prepare', F_PREPARE, 0, {}, None),
             ('state1 flag', F_FLAG, 1, dict(step=1), None), ('state2 prepare', F_PREPARE, 1, dict(step=2, deadline=0), None),
             ('state2 play', F_PLAY, 1, dict(step=2, deadline=0), None), ('state3 busy', F_BUSY, 1, dict(step=3), None),
             ('state3 stop', F_STOP, 1, dict(step=3), [0]), ('phase2 release', F_RELEASE, 2, {}, None), ('phase2 stop', F_STOP, 2, {}, None),
             ('phase2 transition', F_TRANSITION, 2, {}, None), ('phase2 exit flag', F_FLAG, 2, dict(exit=1), None)]
    for name, flag, ph, st, busy in cases:
        fresh(active=1, row=0, **st)
        nat.set_extra([0x44, 0x44, 1, 1, 0])
        if busy is not None:
            nat.set_queues({**DEFAULT_Q, 'busy': busy})
        nat.set_fail(flag)
        status = nat.step(base, 0, ph)[0]
        nat.set_fail(0)
        expect('K5 ' + name, status, ERR_HOST)
    for name, flag, setup in (('click play', F_PLAY, dict(active=1, row=0, hover=1)),):
        fresh(**setup)
        nat.set_fail(flag)
        status = nat.click(base, 1, 0x2719, 1)[0]
        nat.set_fail(0)
        expect('K5 ' + name, status, ERR_HOST)
    fresh(active=1, row=0)
    nat.set_extra([0, 0x1234, 1, 0, 0])
    nat.set_fail(F_ORIGIN)
    status = nat.render(base)['status']
    nat.set_fail(0)
    expect('K5 render origin', status, ERR_HOST)
    # the scene clear against its documented model (0x437260 etc.: [0x5b5158] := 0, [0x5d1a8f] := 0, release of [0x5d03cf] when nonzero)
    for surface in (0, 0x4242):
        fresh(active=1, row=2, step=2, count=3, solved=1)
        nat.set_extra([surface, 0x1111, 1, 1, 9])
        before = nat.state()
        expect('clear status', nat.clear(), OK)
        after = nat.state()
        want = bytearray(before)
        want[48] = 0
        expect('clear: only the active byte changes in the image', after, bytes(want))
        expect('clear: surface / overlay / stale overlay surface / start flag', nat.extra()[:3] + nat.extra()[4:], [0, 0x1111, 0, 9])
        expect('clear: effects in order', [(e[0], e[1]) for e in nat.log(0)], [(FX['ACTIVE'], 0), (FX['OVL_ACTIVE'], 0)] + ([(FX['RELEASE'], surface)] if surface else []))
        expect('clear: host calls', [(e[0], e[1]) for e in nat.log(1)], [(FX['RELEASE'], surface)] if surface else [])
    stats['known_divergences']['K1..K6 checked natively (see the docstring); not run against the original'] += 1


# ---------------------------------------------------------------------------------------------
# planted mutants of the kernel
# ---------------------------------------------------------------------------------------------
K = 'action_family_77_runtime.c'
MUTANTS = {}
# Equivalent against the original: the order of the transition host call relative to the observer calls that report it is invisible
# in the original (a bundle of plain stores), so it is not asserted and the mutant is not counted.
EQUIVALENT_MUTANTS = {'block transition after the effects': 'host transition call vs observer order is not an original effect'}


def mutant(name, *edits, file=K):
    MUTANTS[name] = (file, list(edits))


mutant('p0 rand modulo 4', ('r = (int16_t)(raw % 5);', 'r = (int16_t)(raw % 4);'))
mutant('p0 rand 0/1 not remapped to 2', ('if (r == 0 || r == 1) r = 2;', 'if (r == 0) r = 2;'))
mutant('p0 rand 0/1 remapped to 3', ('if (r == 0 || r == 1) r = 2;', 'if (r == 0 || r == 1) r = 3;'))
mutant('p0 limit not clamped to N', ('if (limit > n) limit = n;', 'if (0) limit = n;'))
mutant('p0 limit without L', ('limit = (int16_t)(uint16_t)((uint16_t)l + (uint16_t)r);', 'limit = (int16_t)r;'))
mutant('p0 start flag fx dropped', ('s->solved = 0u;\n    world->start_flag_5bb1ca = 1;\n    fx(host, A77_FX_START_FLAG, 1, 0);',
                                    's->solved = 0u;\n    world->start_flag_5bb1ca = 1;'))
mutant('p0 start flag not set', ('s->solved = 0u;\n    world->start_flag_5bb1ca = 1;', 's->solved = 0u;\n    world->start_flag_5bb1ca = 0;'))
mutant('p0 solved not cleared', ('s->solved = 0u;\n    world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 1;'))
mutant('p0 exit flag not cleared', ('s->row = row;\n    s->exit_requested = 0u;', 's->row = row;'))
mutant('p0 row not stored', ('s->row = row;\n    s->exit_requested = 0u;', 's->exit_requested = 0u;'))
mutant('p0 count not reset', ('clear_selection(s);\n    s->count = 0;\n    {', 'clear_selection(s);\n    {'))
mutant('p0 order cleared to 0', ('s->order[i] = -1;', 's->order[i] = 0;'))
mutant('p0 selection bytes not cleared', ('s->selected[i] = 0u;', '(void)0;'))
mutant('p0 release reports 0', ('s->surface = 0u;\n    fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);', 's->surface = 0u;\n    fx(host, A77_FX_RELEASE_SURFACE, 0, 0);'))
mutant('p0 held handle not zeroed', ('s->surface = 0u;\n    fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);', 'fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);'))
mutant('p0 overlay surface not stored', ('s->overlay_surface = surface;\n', ''))
mutant('p0 overlay inactive', ('s->overlay_active = 1u;\n        fx(host, A77_FX_OVERLAY_ACTIVE, 1, 0);', 's->overlay_active = 0u;\n        fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);'))
mutant('no-sound compare on 8 bytes', ('return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;'))
mutant('p0 sound prepare inverted', ('if (!no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare', 'if (no_sound(body + B_SOUND_A)) {\n        HOST(host->sound_prepare'))
mutant('p0 prepares record B', ('HOST(host->sound_prepare(host->context, body + B_SOUND_A));\n        fx(host, A77_FX_SOUND_PREPARE, B_SOUND_A, 0);',
                                'HOST(host->sound_prepare(host->context, body + B_SOUND_B));\n        fx(host, A77_FX_SOUND_PREPARE, B_SOUND_B, 0);'))
mutant('p0 step starts at 1', ('s->step = 0u;\n    fx(host, A77_FX_STEP, 0, 0);', 's->step = 1u;\n    fx(host, A77_FX_STEP, 1, 0);'))
mutant('p0 row phase stays 0', ('row_phase = 1u;\n            fx(host, A77_FX_PHASE, 1, 0);', 'row_phase = 0u;\n            fx(host, A77_FX_PHASE, 0, 0);'))
mutant('s0 compares one entry too few', ('for (int16_t i = 0; i < l; ++i) {\n            if (s->order[i]', 'for (int16_t i = 0; i < l - 1; ++i) {\n            if (s->order[i]'))
mutant('s0 solution byte read signed', ('(int16_t)body[B_SOLUTION + (size_t)i]', '(int16_t)(int8_t)body[B_SOLUTION + (size_t)i]'))
mutant('s0 reset needs count > limit', ('} else if (s->count >= s->limit) {', '} else if (s->count > s->limit) {'))
mutant('s0 reset keeps the count', ('clear_selection(s);\n            s->count = 0;\n        }\n        break;', 'clear_selection(s);\n        }\n        break;'))
mutant('s0 reset keeps the selection', ('clear_selection(s);\n            s->count = 0;\n        }\n        break;', 's->count = 0;\n        }\n        break;'))
mutant('s0 solved goes to step 2', ('s->step = 1u;\n            fx(host, A77_FX_STEP, 1, 0);', 's->step = 2u;\n            fx(host, A77_FX_STEP, 2, 0);'))
mutant('s0 solved flag stays set on mismatch', ('s->solved = 0u;\n                break;', 'break;'))
mutant('s1 event flag skipped for index 0', ('uint32_t now;\n        if (flag != A77_NO_FLAG) {', 'uint32_t now;\n        if (flag > 0) {'))
mutant('s1 event value masked to 7 bits', ('HOST(host->store_event_flag(host->context, flag, body[B_EVENT_VALUE]));\n            fx(host, A77_FX_EVENT_FLAG, flag, body[B_EVENT_VALUE]);',
                                          'HOST(host->store_event_flag(host->context, flag, body[B_EVENT_VALUE] & 0x7f));\n            fx(host, A77_FX_EVENT_FLAG, flag, body[B_EVENT_VALUE] & 0x7f);'))
mutant('s1 delay read unsigned', ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)(uint16_t)rd_s16(body, B_DELAY) * 1000)'))
mutant('s1 delay times 1024', ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1024)'))
mutant('s1 deadline from the stale tick', ('s->deadline = now + (uint32_t)', 's->deadline = s->deadline + (uint32_t)'))
mutant('s2 deadline strictly after', ('if (now >= s->deadline) {', 'if (now > s->deadline) {'))
mutant('s2 deadline compared signed', ('if (now >= s->deadline) {', 'if ((int32_t)now >= (int32_t)s->deadline) {'))
mutant('s2 win sound test inverted', ('if (!no_sound(body + B_SOUND_B)) {\n                const int16_t ch', 'if (no_sound(body + B_SOUND_B)) {\n                const int16_t ch'))
mutant('s2 win channel from the click channel', ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);\n                HOST(host->sound_prepare'))
mutant('s2 stays in step 2 after the sound', ('s->step = 3u;\n                fx(host, A77_FX_STEP, 3, 0);', 's->step = 2u;\n                fx(host, A77_FX_STEP, 2, 0);'))
mutant('s2 no-sound path keeps phase 1', ('} else {\n                *row_phase = 2u;', '} else {\n                *row_phase = 1u;'))
mutant('s3 busy test inverted', ('if (busy == 0) {', 'if (busy != 0) {'))
mutant('s3 busy test signed', ('if (busy == 0) {', 'if (busy <= 0) {'))
mutant('s3 stops record A', ('HOST(host->sound_stop(host->context, body + B_SOUND_B));\n            fx(host, A77_FX_SOUND_STOP, B_SOUND_B, 0);',
                             'HOST(host->sound_stop(host->context, body + B_SOUND_A));\n            fx(host, A77_FX_SOUND_STOP, B_SOUND_A, 0);'))
mutant('s3 busy channel is the click channel', ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);\n        int32_t busy = 0;'))
mutant('p2 start flag 0', ('world->start_flag_5bb1ca = 1;\n    fx(host, A77_FX_START_FLAG, 1, 0);\n    s->active = 0u;', 'world->start_flag_5bb1ca = 0;\n    fx(host, A77_FX_START_FLAG, 0, 0);\n    s->active = 0u;'))
mutant('p2 active kept', ('s->active = 0u;\n    fx(host, A77_FX_ACTIVE, 0, 0);\n    {', 's->active = 1u;\n    fx(host, A77_FX_ACTIVE, 1, 0);\n    {'))
mutant('p2 stale overlay surface cleared', ('s->overlay_active = 0u; /* overlay_surface keeps the stale handle */', 's->overlay_active = 0u; s->overlay_surface = 0u;'))
mutant('p2 overlay stays active', ('s->overlay_active = 0u; /* overlay_surface keeps the stale handle */', 's->overlay_active = 1u;'))
mutant('p2 stops record B', ('HOST(host->sound_stop(host->context, body + B_SOUND_A));\n        fx(host, A77_FX_SOUND_STOP, B_SOUND_A, 0);\n    }\n    if (s->exit_requested',
                             'HOST(host->sound_stop(host->context, body + B_SOUND_B));\n        fx(host, A77_FX_SOUND_STOP, B_SOUND_B, 0);\n    }\n    if (s->exit_requested'))
mutant('p2 exit test inverted', ('if (s->exit_requested != 0u) {\n        const int rc = apply_block', 'if (s->exit_requested == 0u) {\n        const int rc = apply_block'))
mutant('p2 exit flag value from the solved flag value', ('HOST(host->store_event_flag(host->context, flag, body[B_EXIT_VALUE]));', 'HOST(host->store_event_flag(host->context, flag, body[B_EVENT_VALUE]));'))
mutant('p2 exit flag skipped for index 0', ('const int16_t flag = rd_s16(body, B_EXIT_FLAG);\n            if (flag != A77_NO_FLAG) {', 'const int16_t flag = rd_s16(body, B_EXIT_FLAG);\n            if (flag > 0) {'))
mutant('p2 exit uses the solved block', ('apply_block(body + B_EXIT_BLOCK, rd_s16(body, B_EXIT_START), world, host)', 'apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_EXIT_START), world, host)'))
mutant('p2 solved uses the exit start word', ('apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_SOLVED_START), world, host)', 'apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_EXIT_START), world, host)'))
mutant('block start word == 0', ('start_word == 1 ? 0 : 1', 'start_word == 0 ? 0 : 1'))
mutant('block start word != 1', ('start_word == 1 ? 0 : 1', 'start_word != 1 ? 0 : 1'))
mutant('block start word low byte', ('start_word == 1 ? 0 : 1', '(start_word & 0xff) == 1 ? 0 : 1'))
mutant('block scene none is >= 9999', ('if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;', 'if (rd_s16(blk, SB_SCENE) >= A77_NO_SCENE) return A77_OK;'))
mutant('block scene none on 15 bits', ('if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;', 'if ((rd_s16(blk, SB_SCENE) & 0x7fff) == A77_NO_SCENE) return A77_OK;'))
mutant('block scene none is -1', ('if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;', 'if (rd_s16(blk, SB_SCENE) == -1) return A77_OK;'))
mutant('block words 1 and 2 swapped', ('t.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);'))
mutant('block dwords 2 and 3 swapped', ('t.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);'))
mutant('block scene zero-extended', ('t.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(uint16_t)rd_s16(blk, SB_SCENE) & 0x7fff;'))
mutant('block engine mode 3', ('fx(host, A77_FX_ENGINE_MODE, 4, 0);', 'fx(host, A77_FX_ENGINE_MODE, 3, 0);'))
mutant('p2 not completed', ('result->completed = 1u;', 'result->completed = 0u;'))
mutant('p2 phase stays 2', ('row_phase = 0u; /* 0x42ba3a stores phase 0 */', 'row_phase = 2u;'))
mutant('p2 complete fx carries no row', ('fx(host, A77_FX_COMPLETE, row, 0);', 'fx(host, A77_FX_COMPLETE, 0, 0);'))
mutant('pointer: top edge exclusive', ('return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12)', 'return rd_s32(body, rect + 4) < y && y <= rd_s32(body, rect + 12)'))
mutant('pointer: bottom edge exclusive', ('y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x', 'y < rd_s32(body, rect + 12) && rd_s32(body, rect) <= x'))
mutant('pointer: left edge exclusive', ('rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8)', 'rd_s32(body, rect) < x &&\n           x <= rd_s32(body, rect + 8)'))
mutant('pointer: right edge exclusive', ('x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);'))
mutant('pointer: last button unreachable', ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_BUTTON_RECT', 'for (int16_t i = 0; i < n - 1; ++i) {\n        if (in_rect(body, B_BUTTON_RECT'))
mutant('pointer: last button wins', ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_BUTTON_RECT + (size_t)i * 16u, x, y)) {\n            state->hover = i; /* word 0x5b515b */',
                                     'for (int16_t i = n - 1; i >= 0; --i) {\n        if (in_rect(body, B_BUTTON_RECT + (size_t)i * 16u, x, y)) {\n            state->hover = i; /* word 0x5b515b */'))
mutant('pointer: hover not stored', ('state->hover = i; /* word 0x5b515b */', '(void)0;'))
mutant('pointer: cursor sub 0', ('out->cursor_sub = 1u;', 'out->cursor_sub = 0u;'))
mutant('pointer: exit cursor 8', ('out->cursor_kind = A77_CURSOR_EXIT;', 'out->cursor_kind = 8;'))
mutant('pointer: exit candidate is the button one', ('out->candidate = A77_CANDIDATE_EXIT;', 'out->candidate = A77_CANDIDATE_BUTTON;'))
mutant('pointer: claims while inactive', ('if (state->active == 0u) return A77_OK;\n    n = rd_s16(body, B_COUNT);\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect', 'n = rd_s16(body, B_COUNT);\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect'))
mutant('pointer: exit tested before the buttons', ('    n = rd_s16(body, B_COUNT);\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_BUTTON_RECT',
                                                    '    n = rd_s16(body, B_COUNT);\n    if (in_rect(body, B_EXIT_RECT, x, y)) {\n        out->hit = 1u;\n        out->candidate = A77_CANDIDATE_EXIT;\n        out->cursor_kind = A77_CURSOR_EXIT;\n        return A77_OK;\n    }\n    for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_BUTTON_RECT'))
mutant('click: toggle test inverted', ('if (state->selected[h] != 0u) {', 'if (state->selected[h] == 0u) {'))
mutant('click: pop index not clamped', ('if (t < 0) t = 0;', '(void)0;'))
mutant('click: pops any button', ('if (state->order[t] == h) {', 'if (1) {'))
mutant('click: pop needs the top to differ', ('if (state->order[t] == h) {', 'if (state->order[t] != h) {'))
mutant('click: pop count not clamped at 0', ('if (state->count < 0) state->count = 0;', '(void)0;'))
mutant('click: popped slot not cleared', ('state->order[state->count] = -1;', '(void)0;'))
mutant('click: push stops one early', ('if (state->count <= n - 1) state->order[state->count] = h;', 'if (state->count < n - 1) state->order[state->count] = h;'))
mutant('click: push count clamp to N-1', ('if (state->count > n) state->count = n;', 'if (state->count > n) state->count = n - 1;'))
mutant('click: push count not clamped', ('if (state->count > n) state->count = n;', '(void)0;'))
mutant('click: sound needs start flag 1', ('start_flag != 0 && !no_sound(body + B_SOUND_A)', 'start_flag == 1 && !no_sound(body + B_SOUND_A)'))
mutant('click: sound ignores the record', ('start_flag != 0 && !no_sound(body + B_SOUND_A)', 'start_flag != 0'))
mutant('click: sound tests record B', ('start_flag != 0 && !no_sound(body + B_SOUND_A)', 'start_flag != 0 && !no_sound(body + B_SOUND_B)'))
mutant('click: channel is the win channel', ('const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);', 'const int16_t ch = rd_s16(body, B_WIN_CHANNEL);'))
mutant('click: exit phase 1', ('out->new_phase = 2u;', 'out->new_phase = 1u;'))
mutant('click: exit flag not set', ('state->exit_requested = 1u;', '(void)0;'))
mutant('click: works on a solved puzzle', ('if (state->active == 0u || state->solved != 0u) return A77_OK;', 'if (state->active == 0u) return A77_OK;'))
mutant('click: works on an inactive puzzle', ('if (state->active == 0u || state->solved != 0u) return A77_OK;', 'if (state->solved != 0u) return A77_OK;'))
mutant('click: candidate ignored', ('if (candidate == A77_CANDIDATE_BUTTON) {', 'if (candidate != A77_CANDIDATE_EXIT) {'))
mutant('render: origin y added to x', ('b->dst[0] = (int32_t)((uint32_t)rd_s32(body, rect) + (uint32_t)vx);', 'b->dst[0] = (int32_t)((uint32_t)rd_s32(body, rect) + (uint32_t)vy);'))
mutant('render: origin ignored for the right edge', ('b->dst[2] = (int32_t)((uint32_t)rd_s32(body, rect + 8) + (uint32_t)vx);', 'b->dst[2] = rd_s32(body, rect + 8);'))
mutant('render: selected means exactly 1', ('b->selected = state->selected[i] != 0u ? 1u : 0u;', 'b->selected = state->selected[i] == 1u ? 1u : 0u;'))
mutant('render: sources swapped', ('const size_t src = b->selected != 0u ? B_SELECTED_SRC + (size_t)i * 16u : rect;', 'const size_t src = b->selected == 0u ? B_SELECTED_SRC + (size_t)i * 16u : rect;'))
mutant('render: selected source stride 8', ('B_SELECTED_SRC + (size_t)i * 16u', 'B_SELECTED_SRC + (size_t)i * 8u'))
mutant('render: drawn while inactive', ('if (state->overlay_active == 0u) return A77_OK;', '(void)0;'))
mutant('render: plan surface is the puzzle handle', ('plan->surface = state->overlay_surface;', 'plan->surface = state->surface;'))
mutant('render: one blit too few', ('for (int16_t i = 0; i < n; ++i) {\n        const size_t rect = B_BUTTON_RECT + (size_t)i * 16u;\n        A77RenderBlit', 'for (int16_t i = 0; i < n - 1; ++i) {\n        const size_t rect = B_BUTTON_RECT + (size_t)i * 16u;\n        A77RenderBlit'))
mutant('validate: N up to 17', ('(n = rd_s16(body, B_COUNT)) < 0 || n > A77_MAX_BUTTONS', '(n = rd_s16(body, B_COUNT)) < 0 || n > 17'))
mutant('validate: L not checked', ('(l = rd_s16(body, B_SOLUTION_LEN)) < 0 || l > A77_MAX_BUTTONS', '(l = rd_s16(body, B_SOLUTION_LEN)) < 0 && l > A77_MAX_BUTTONS'))
mutant('step: init not required', ('if (state->initialized == 0u || state->row != row) {', 'if (0) {'))
mutant('step: event flag window unchecked', ('host->event_flag_invalid(host->context, flag) != 0', 'host->event_flag_invalid(host->context, flag) == 99'))
mutant('step: exit flag window unchecked in phase 2', ('flag = rd_s16(body, B_EXIT_FLAG);\n        if (flag', 'flag = A77_NO_FLAG;\n        if (flag'))
mutant('step: phase above 2 runs phase 1', ('} else if (phase == 1u || phase == 2u) {', '} else if (phase >= 1u) {'))
mutant('clear: overlay stays active', ('state->overlay_active = 0u;\n    fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);\n    state->initialized', 'fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);\n    state->initialized'))
mutant('clear: handle not released', ('if (state->surface != 0u) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface', 'if (0) {\n        const uint32_t held = state->surface;\n        HOST(host->release_surface'))


def mutation_check(args, workdir):
    report = []
    for name, (filename, edits) in MUTANTS.items():
        source = (args.src / filename).read_text()
        bad_anchor = [old[:60] for old, _ in edits if source.count(old) != 1]
        if bad_anchor:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted: %r' % bad_anchor))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        for old, new in edits:
            source = source.replace(old, new)
        (d / filename).write_text(source)
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)), strict=False)
        except d9.OracleError as error:
            report.append(dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:160]))
            continue
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=first[6:][:200] if first else None))
    return report


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
    ranges = (POINTER_RANGE, CLICK_RANGE)
    for a, sz in blocks:
        if any(lo <= a <= hi for lo, hi in ranges) or a == POINTER_CLAIM:      # the stop addresses are never executed
            continue
        i = bisect.bisect_right(starts, a) - 1
        funcs[starts[i]] = starts[i + 1]
    for a in HOOK_RETS:
        i = bisect.bisect_left(starts, a)
        funcs[starts[i]] = starts[i + 1]
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
    out += [(lo, hi, sha(x.pristine[lo - 0x400000:hi - 0x400000])) for lo, hi in ranges]
    out.sort()
    return 'PINS_TABLE = (\n' + ''.join('    (%#x, %#x, %r),\n' % t for t in out) + ')'


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
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick then full scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-49.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver77.so')
    nat = Native(lib_path)
    x = Oracle()
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    quick = [s for s in scs if s['quick']]
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    if args.mutation_run:
        bad = run_list(x, nat, quick, stats, fail_fast=True)
        if not bad:
            bad = run_list(x, nat, [s for s in scs if not s['quick']], stats, fail_fast=True)
        if not bad:
            try:
                refusal_checks(nat, stats)
            except Mismatch as error:
                bad.append(('refusal', str(error)))
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    bad = run_list(x, nat, quick if args.quick_only else scs, stats, fail_fast=args.fail_fast)
    if not args.only:
        try:
            refusal_checks(nat, stats)
        except Mismatch as error:
            bad.append(('refusal', str(error)))
            stats['mismatches'] += 1
    if args.discover_pins:
        print(discover_pins(x, blocks))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:700])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
        summary['mutants_total'] = len(mutations)
        summary['mutants_killed'] = sum(1 for m in mutations if m['detected'])
        summary['equivalent_mutants_not_counted'] = EQUIVALENT_MUTANTS
    summary['seconds'] = round(time.monotonic() - started, 1)
    print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-49', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
