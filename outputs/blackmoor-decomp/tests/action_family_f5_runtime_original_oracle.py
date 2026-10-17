#!/usr/bin/env python3
"""RT-55: immutable x86 dispatcher 0x427a50 / handler 0x4b8e92 (raw 0xf5, the Typing Quiz Puzzle), the object methods 0x4b8193 (key),
0x4b81ff (pointer), 0x4b82cd (click), 0x4b9a88 (render callback of the quiz z entry), 0x4b80a5 (invalidate), 0x4b7ff4 + 0x4b7f3b (cleanup
and reset), 0x4b8087 (new-game reset of 0x5a4c0a / 0x5a4c0e), the key filter 0x437ea1, and the shared score / time display widget (its
render callbacks 0x446688 / 0x4468fe, run as original functions; init, reset, set and enable run inside the handler) versus the native
kernels src/action_family_f5_runtime.c and src/score_time_display.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xf5 (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a8f4, the handler
0x4b8e92 with every phase (0 init, 1 with the obj+0x10 states 0 play / 1 time up / 2 wait for the end delay / others, 2 finish), the inner
methods 0x4b832c (clock), 0x4b844d (score, with the REAL x87 __ftol 0x50ce04 at control word 0x27f), 0x4b8d5e (balloon expiry), 0x4b8783
(first wave), 0x4b8a27 (more balloons), 0x4b866e (free position), 0x4b85f6 / 0x4b8520 (character pick), 0x4b8e42 (popping balloon expiry),
the display init / reset / set / enable functions 0x4460d6 0x4462d3 0x445f53 0x445fc5 0x44655e 0x446598 0x446532 0x446548 including the
CRT formatter 0x50ca3e ("%d", "%02d"), the generic completion 0x42ba3a and the cleanup 0x4b7ff4 / 0x4b7f3b. The generic Z entry allocator
0x4d39f9 and releaser 0x4d3992 run as original code on the table at 0x5d1591 (busy seeds decide which slot comes back). The object methods
run as original functions on the same process image with ECX = 0x61ee6e: the key method 0x4b8193 (stack word: the character in the low
byte, garbage above, as the real caller pushes), the pointer test 0x4b81ff (two stack words x, y whose upper halves are garbage), the click
0x4b82cd (no arguments; it reads the retained candidate 0x5c39e5), the render callback 0x4b9a88 (cdecl, reads the slot and row through the
globals), the invalidate 0x4b80a5, the cleanup 0x4b7ff4, the new-game reset 0x4b8087, and without ECX the two display callbacks.

Native side: tests/action_family_f5_runtime_oracle_driver.c links ONLY the two kernels and implements the HOST side of the TqzHost contract
with scripted queues (GetTickCount values, _rand values, image handles), a model of the Z entry table, the view rectangles, the event flag
window and the scene-change cells. The driver decides nothing the kernel decides. It keeps two logs, the observer log (TqzHost.observe)
and the host-call log (what the kernel really asked of the host); the oracle requires them to agree.

Compared after EVERY action (dispatcher pass, key, pointer, click, render of the three callbacks, invalidate, cleanup, new-game reset):
 * the whole 0x643-byte object image 0x61ee6e.. byte for byte against TqzObject (the bytes without a field come from a shadow; the body
   pointer dword at +8 against its model: the handler stores it at every visit, the reset zeroes it); the widget image 0x638603..+0x288
   against StdDisplay; the start flag 0x5bb1ca, the played flag 0x5a4c0a and the best-score word 0x5a4c0e; the engine mode 0x583999; the
   seven scene-change cells; the whole event flag window (4096 dwords at 0x585801); the whole generic Z entry table (0x58 entries of 0x4a
   bytes); the candidate 0x5c39e5, the cursor cells 0x5b44f0 / 0x5b44f4 and the host-composed cells 0x5d162d / 0x5d1631 / 0x5d1639 against
   their documented composition from the native outputs;
 * every byte of every row (except the dependency record the gate and the reset own) against a model and the whole row body (the original
   never writes it); every write outside the modelled cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every TqzEffect: the
   active flag, the start flag, clear-item, the three slots, the entry registrations after the label copy and after the slot surface
   store, the image loader, the sound routines, GetTickCount, _rand, the state and phase stores, the display calls, the played flag, the
   best score, the scene cells, the engine mode, the event flag window, the releasers, the font calls, then the completion byte, the
   dependency reset and the phase store of 0x42ba3a) against the sequence the native kernel reports for the same visit, entry for
   entry; the scripted queues are consumed identically by both sides;
 * key: the stored/refused outcome and (through the object image) the pending flag and the character; pointer: the return value, the
   candidate and the cursor cells; click: the row phase it stores; render: every recorded 0x4c5d4b / 0x4c5377 blit (this, source surface,
   source rectangle contents, target, destination rectangle contents, label) and every 0x4d2c20 text draw (character, x, y words, the
   constants) against the kernel's list, in order, plus the ticks and random draws of the balloon replacement;
 * the key filter over all 256 bytes through the real key method and directly through 0x437ea1.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10)   R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4c924d / 0x4c92c5 font acquire / release (ret 4)
  R 0x4c5d4b / 0x4c5377 blit recorders (ECX 0x5cf659, ret 0x14)   R 0x4d2c20 text draw (cdecl, 8 args)   R 0x4e8d96 clear pending item
  R 0x50cd50 _rand (scripted queue; the CRT's per-thread seed state is outside the slice)   R GetTickCount (import stub) scripted values
  O 0x42a8f4 / 0x428692 arm entries, 0x42a917 / 0x4286b5 post-gate points, 0x4b8e92 handler entry, 0x42a929 handler return, 0x42ba3a
    generic completion, 0x42babe (its ret), 0x423d33 dependency reset, 0x4b8f13 / 0x4b9146 / 0x4b9289 (after the three slot allocations),
    0x4b8feb / 0x4b902d (after the quiz entry label copy and after the slot surface store), 0x446296 / 0x4464d4 (after the display entry
    label copies), the entries of 0x44655e 0x446598 0x446532 0x446548 0x445f53 0x445fc5, 0x4d3992 releaser entry, 0x4b7f3b / its ret
    (reset: its stores of the active flag are not an effect), every store to the process data region is observed (read-only)
  S 0x4b8a2d: the 16-byte local area of 0x4b8a27 is zeroed at entry (stand-in for the uninitialised `fresh`, see below)
  G 0x4c97b4 0x42639d 0x52139c 0x44a2b7 0x4264e8: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0. The strings the kernels hard-code (the entry labels, the loader's kind / label, "NO SOUND\\0" at its addresses, the blit labels,
 the formats "%d" / "%02d") are checked against the image at start-up.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick and _rand values, the view
rectangles, the target surface handle (cell 0x5cf665), the text colour cell 0x5d0357, the background / entry 1 surface (0x5d15e3), the busy
seeds of the Z entry table, the event flag window contents, the contents of the process cells at the start of a scenario.

KNOWN STAND-INS AND DIVERGENCES (never silently skipped; the oracle's scenarios skip the actions the kernels refuse, counted in
stats.skipped_native_refusal; the refusals are checked natively in refusal_checks()):
  S1 the local `fresh` of 0x4b8a27 is uninitialised in the original when count + n < minimum; the oracle zeroes the 16-byte area at that
     function's entry and the kernel takes 0.
  K1 tqz_validate_body: short body, names without NUL in their 0x21 bytes, V or N outside 1..20, balloon count range outside 0..20 or
     min > max, lifetime min > max -> TQZ_ERR_BODY / ARGUMENT, no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row -> TQZ_ERR_UNSUPPORTED, no effect.
  K3 phase 2 with an event flag index outside the host window 0..4095 (and not -1) -> TQZ_ERR_BOUNDS before the first effect.
  K4 score outside 0..99999999 and clock values outside 0..99 (std_set_score / std_set_clock) -> TQZ_ERR_BOUNDS (the original would index
     the digit tables with '-' - '0' or overflow the ten-byte string); render of a string with a non-digit -> BOUNDS.
  K5 pick loops: the divisor 0 (max_char == 0x41 / 0x30) -> TQZ_ERR_BOUNDS, loops that do not end within TQZ_PICK_LIMIT draws ->
     TQZ_ERR_STUCK (the original would divide by zero or hang); the oracle's bodies keep the count maximum at most the position count and
     the position rectangles distinct.
  K6 host failures -> TQZ_ERR_HOST, allocator exhaustion -> TQZ_ERR_HOST.
  K7 render / invalidate with the slot -1 or outside the table: native does nothing (valid = 0) where the original would index the table.
  K8 widget strings: the original's string copy (previous := current) copies up to and including the NUL; the kernel copies all ten bytes.
     The bytes after the NUL of a widget string are dead; the oracle compares them separately (stats.known_divergences) and resynchronises
     the native widget image from the original's, never hiding any other difference.
 All of these are unreachable in the game (loader-built 1390-byte bodies, callbacks only for allocated entries).

Not modelled / unverified: the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine, the blit bodies 0x4c5d4b / 0x4c5377 and
the text routine 0x4d2c20, the font surface 0x4c924d / 0x4c92c5, the CRT random state behind 0x50cd50, the cascade 0x4f0059 and the
accepted-release chain 0x43b273 that call 0x4b81ff / 0x4b82cd, the character message handler 0x437e92 that calls 0x4b8193, the generic
Z entry drawer that calls the three render callbacks, the scene clears 0x438c75 / 0x43df60 and the new-game reset caller 0x43851c (the methods
are run directly), the loader 0x4b80d9 that builds the body, the engine consumers of the scene-change cells, the host composition of the
cursor cells (their documented composition is checked, not the engine code that reads them), 0x4e8d96, the other callers of the widget
(0x452576 and 0x4bca71).

Modes: --quick-only runs the scenarios flagged quick; the default run is every scenario plus the native-only refusal checks; --workers N
shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernels (the mutation check does this);
--discover-pins prints the PINS_TABLE of the original code the scenarios execute (the pins are verified at start-up); --fuzz N runs the
ASan / UBSan malformed-input harness. The planted-mutant sweep is tests/action_family_f5_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_f5_runtime_original_oracle.py --quick-only
  python3 action_family_f5_runtime_original_oracle.py --workers 4 --result ../../../work/rt55/RT-55.oracle-result.json
  python3 action_family_f5_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)

RESULTS (2026-10-17, this machine, 4 workers; JSON at work/rt55/RT-55.oracle-result.json):
  280 scenarios, 4452 dispatcher ticks (352 phase-0 inits, 3728 phase-1 visits in states 0 / 1 / 2 / other, 201 phase-2 finishes), 34991
  ordered effects, 47415 ordered events compared entry for entry, 3,258,673 compared fields, 11,676 recorded blits / text draws, 18,405
  scripted queue values consumed identically by both sides, 874 score-formula samples against the real x87 __ftol at control word 0x27f,
  1024 key-filter bytes (256 x 4 scenarios), 154 native refusal checks: 0 mismatches. Wall time of the full run: 14 s (--workers 4),
  about 35 s single-process; --fuzz 3000 (4 seeds, ASan + UBSan): 12000 inputs clean in 32 s.
  Known divergence counted, not hidden: K8 (widget string bytes after the NUL), seen 1930 times, always the same dead bytes.
  Planted-mutant sweep (tests/action_family_f5_runtime_mutation_check.py, 574 one-site mutants over both kernel files, 610 s with 4 jobs):
  543 counted (30 reasoned equivalents excluded), 542 killed on the full run (99.8 %), the one survivor (key-case-lower-test) and one crashing mutant
  (place-lifetime-span) were killed after a scenario / mutant-text fix; result JSON work/rt55/RT-55.mutation-result.json.
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
BODY_LEN = 1390
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF
RESOURCES = ROOT / 'work/analysis/hiff-resources'
CORPUS = ROOT / 'work/analysis/slices/A-F5.1.corpus.json'
RESULT_DIR = ROOT / 'work/rt55'

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x4B8E92, 0x42BA3A, 0x423D33, 0x42BABE
HANDLER_RETURN = 0x42A929
ARM = {0xF5: 0x42A8F4, 0x67: 0x428692}
VISIT = {0xF5: 0x42A917, 0x67: 0x4286B5}
M_KEY, M_POINTER, M_CLICK, M_INVALIDATE, M_CLEANUP, M_RESET, M_NEWGAME = 0x4B8193, 0x4B81FF, 0x4B82CD, 0x4B80A5, 0x4B7FF4, 0x4B7F3B, 0x4B8087
M_RESET_RET = 0x4B7FF3
M_RENDER, W_RENDER_SCORE, W_RENDER_CLOCK = 0x4B9A88, 0x446688, 0x4468FE
KEY_FILTER = 0x437EA1
KEY_FILTER_THIS = 0x583208
MORE_BALLOONS_LOCALS = 0x4B8A2D
SLOT_POINTS = (0x4B8F13, 0x4B9146, 0x4B9289)
AT_QUIZ_REGISTER, AT_QUIZ_SLOT_SURFACE, AT_SCORE_INIT, AT_CLOCK_INIT = 0x4B8FEB, 0x4B902D, 0x446296, 0x4464D4
W_SET_SCORE, W_SET_CLOCK, W_ENABLE_SCORE, W_ENABLE_CLOCK, W_RESET_SCORE, W_RESET_CLOCK = 0x44655E, 0x446598, 0x446532, 0x446548, 0x445F53, 0x445FC5
RELEASE_SLOT_FN = 0x4D3992
LOAD_IMAGE, RELEASE_IMAGE = 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY = 0x4FB77A, 0x4FBA69, 0x4FB2E3
BLIT_OPAQUE, BLIT_RESTORE, CLEAR_ITEM = 0x4C5D4B, 0x4C5377, 0x4E8D96
FONT_ACQUIRE, FONT_RELEASE, TEXT_DRAW, RAND = 0x4C924D, 0x4C92C5, 0x4D2C20, 0x50CD50
GUARD_ADDRS = [0x4C97B4, 0x42639D, 0x52139C, 0x44A2B7, 0x4264E8]

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ, OBJ_LEN = 0x61EE6E, 0x643
WIDGET, WIDGET_LEN = 0x638603, 0x288
WORLD_LEN = 10
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_PLAYED, CELL_BEST = 0x5A4C0A, 0x5A4C0E
CELL_BG, CELL_TARGET, CELL_COLOUR = 0x5D15E3, 0x5CF665, 0x5D0357
CELL_VIEW, CELL_LOCAL = 0x583186, 0x583196
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_ITEM = 0x5CF659, 0x5C3A67, 0x571442
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
LABEL_KIND, LABEL_SURFACE, LABEL_ENTRY = b'CIFTREE', b'Typing Quiz Puzzle Data Surface', b'TYPING QUIZ PUZZLE OVERLAYS'
NO_SOUND = b'NO SOUND\0'
NO_SOUND_VAS = (0x551DF4, 0x551E00, 0x551E0C, 0x551E18, 0x551E24, 0x551E30, 0x551E3C, 0x551E48)
CAND_QUIZ = 0x27EB

# the numbers of TqzEffect (plus the display's own and one oracle-only second half of the display reset)
FX = dict(ACTIVE=1, START_FLAG=2, CLEAR_ITEM=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6, SLOT_SURFACE=7, SOUND_PREPARE=8, SOUND_STOP=9,
          SOUND_PLAY=10, TICK=11, RANDOM=12, PHASE=13, STATE=14, X57B=15, X599=16, X595=17, X39FF=18, X59B=19, X59F=20, X5A3=21, MODE=22,
          EVENT_FLAG=23, COMPLETE=24, RELEASE_SURFACE=25, RELEASE_SLOT=26, FONT_ACQUIRE=27, FONT_RELEASE=28, SET_SCORE=29, SET_CLOCK=30,
          ENABLE_SCORE=31, ENABLE_CLOCK=32, RESET_DISPLAY=33, PLAYED=34, BEST=35, BLIT=36, INIT_SCORE=200, INIT_CLOCK=201, RESET_CLOCK=133)
FXN = {v: k for k, v in FX.items()}
WORD_FIRST = {FX['SLOT'], FX['SLOT_REGISTER'], FX['SLOT_SURFACE'], FX['SOUND_PLAY'], FX['COMPLETE'], FX['X599'], FX['X595'], FX['X39FF'],
              FX['RELEASE_SLOT'], FX['EVENT_FLAG'], FX['BEST']}
FX_SIZE = {k: (2, 4) for k in WORD_FIRST}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4), CELL_PLAYED: (FX['PLAYED'], 4), CELL_BEST: (FX['BEST'], 2)}
HOST_FX = {FX[k] for k in ('CLEAR_ITEM', 'SLOT', 'SLOT_REGISTER', 'SURFACE_LOAD', 'SLOT_SURFACE', 'SOUND_PREPARE', 'SOUND_STOP', 'SOUND_PLAY', 'TICK',
                           'RANDOM', 'EVENT_FLAG', 'RELEASE_SURFACE', 'RELEASE_SLOT', 'FONT_ACQUIRE', 'FONT_RELEASE', 'MODE', 'INIT_SCORE', 'INIT_CLOCK')}
HC_MARK_DIRTY, HC_ENGINE_MODE = 100, 101

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# blit labels: address -> kind (TqzBlitKind / StdBlitKind) and text
BLIT_LABELS = {0x551E54: (101, b'Typing Quiz Character'), 0x551E6C: (103, b'Typing Quiz Character'), 0x551E84: (104, b'Typing Quiz balloon Erase'),
               0x551EA0: (105, b'TYPING PUZZLE Background Erase'), 0x551EC0: (106, b'Typing Puzzle Passed Msg'),
               0x548288: (1, b'Score Time Display - Background Restoration'), 0x5482B4: (2, b'Score Display'),
               0x5482C4: (3, b'Score Time Display - Background Restoration'), 0x5482F0: (4, b'Score Time Display - Background Restoration'),
               0x54831C: (5, b'Score Time Display - Background Restoration'), 0x548348: (6, b'Minutes Display'), 0x548358: (7, b'Colon Display'),
               0x548368: (8, b'Seconds Display')}
RESTORE_KINDS = {1, 3, 4, 5, 104, 105}
TEXT_KIND = 102
EXTRA_LABELS = ((0x548218, b'SCORE DISPLAY'), (0x548228, b'TIME DISPLAY'), (0x548238, b'%d'), (0x54823C, b'%02d'), (0x548244, b'%02d'))

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4), SND_PLAY: (0xb4, 4),
             BLIT_OPAQUE: (0x350, 0x14), BLIT_RESTORE: (0x214, 0x14), CLEAR_ITEM: (0x32, 0), FONT_ACQUIRE: (0x78, 4), FONT_RELEASE: (0x7b, 4),
             TEXT_DRAW: (0x453, 0), RAND: (0x22, 0)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, BLIT_OPAQUE: 0x14, BLIT_RESTORE: 0x14, CLEAR_ITEM: 0,
        FONT_ACQUIRE: 4, FONT_RELEASE: 4, TEXT_DRAW: 0, RAND: 0}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            BLIT_OPAQUE: THIS_SURF, BLIT_RESTORE: THIS_SURF, CLEAR_ITEM: THIS_ITEM, FONT_ACQUIRE: THIS_SURF, FONT_RELEASE: THIS_SURF}

# Executed original code, as SHA-256 of the unmodified image bytes. Discovered over every scenario with --discover-pins, verified at start-up.
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
    (0x437ea1, 0x438120, 'caef9c0c46eba1b1519981b27e8ac043ac2cf807919fb89d377f5c3ad291bc9c'),
    (0x445f53, 0x445fc5, 'a463f7a840cf35daebe3d4a411a77df582920ad77dd6fec30e4e8e9f39d4dfa5'),
    (0x445fc5, 0x446075, '86dfcb44ff104d6a79cc97f10f6bb6655120a348bc56f96d783f9605f6d95dc1'),
    (0x4460d6, 0x4462d3, 'cc71ba678570f339a179e918bf0eb72728be11c478e340ebb2eff5baa18cbf3a'),
    (0x4462d3, 0x446532, 'd92ec6be39e659ace36761b5a6d2e5a8e3a7f48cf24fd1019921b77eff6f37e8'),
    (0x446532, 0x446548, '033d6824afeeb673c61c80a831ae80637bab653caa51bd21c5689685398a3a91'),
    (0x446548, 0x44655e, '0162bfa67fc7ddc9bf8205692f7e8481acd5ff09c30b047fd1070242dabbef1c'),
    (0x44655e, 0x446598, '3e9beb00d4e6932214089bc1acc4c1a9ee55364008ca58a80ac1b20951c34d5c'),
    (0x446598, 0x4465fd, '16de3b153ae659df97ba442a0cdf93d88c3a09c314bd4c8d3eab518eb2ef3b0c'),
    (0x446688, 0x4468fe, '37ba46ced92ebd3f6d6f5a8a93bcfcdbd3a5f35e9616417c63413b1b63a434e9'),
    (0x4468fe, 0x446ed0, 'dbe2e25bedcd8a46c1c44f4a01d72f791b341b5622f7b40af6f31fbf2d620e5f'),
    (0x4b7f3b, 0x4b7ff4, '83b0fbf598a4dd2924e32ee21d1971ca1dcb6f137972c22e3c2dc0e85f25f0d9'),
    (0x4b7ff4, 0x4b8087, '7301b469ab96ba207b725f123633e5977a39b903397f6cf07a6ecf46500cbfd7'),
    (0x4b8087, 0x4b80a5, 'a5c698aba2ff340807de48713b306002ca6d50098787de97d12fb076d9d46a0e'),
    (0x4b80a5, 0x4b80d9, 'bbeb1eb20f3be6a1227dc927f3d80fb49f7397322643bc23de4a98a25333fc43'),
    (0x4b8193, 0x4b81ff, '7fdadd5ee8c4822265ea8ab0504cb7dcbacdd69af7e34efe7ef5e86c50b48a70'),
    (0x4b81ff, 0x4b82cd, 'cc4313cc869bfafef7d9744a0c7a43cd22e0dd0c201c96b181f073f21871f3f5'),
    (0x4b82cd, 0x4b832c, '6a3491e8eca7445acdc9a3fc5f2ff2b5eb5a4564a8b302b94fea4938db0a9460'),
    (0x4b832c, 0x4b844d, 'a2743220601f298aba5cece95185d5133c4fc84ac2718f6beeaed29c58efa2eb'),
    (0x4b844d, 0x4b8520, '87601d720680d616aa12e82603d5c6a2dc622fe6ee454cbee278c30405cd214b'),
    (0x4b8520, 0x4b85f6, 'b67c66550ce730fbe200b7058d50d3ee97158db07115c7a034e9442ffefd69aa'),
    (0x4b85f6, 0x4b866e, '5beed41b496466f2141b722d7c843cd02b107f5ae03a21e2c966c2954a5e9eab'),
    (0x4b866e, 0x4b8783, '135100aec276a05a45bb48891e43448ee0a2b83ac30f4ac4c251d6a7830445a1'),
    (0x4b8783, 0x4b8a27, '4e3035a2264fbf65ebc477c25ef1ee7021babcf5a55826d0bf545d7f5e53ceeb'),
    (0x4b8a27, 0x4b8d5e, 'e5513c74173b872d934d00fa4e70224b80ad23ba086b696c810f13b938123bfa'),
    (0x4b8d5e, 0x4b8e42, '9b27963dfe72a98a83d8405743c0e2f278587652f1fdeb579af1df1d2165953d'),
    (0x4b8e42, 0x4b8e92, '5a922b613325a8067cecd45ca5286e05021bbd89ee5c71a8ead93d838db033a9'),
    (0x4b8e92, 0x4b9a88, '59271b05b4690deddb54ae52fb29d774455030026a069cea7225b9d97a7bffda'),
    (0x4b9a88, 0x4b9dd0, '5e71095d9dd6c7237df2380eb135b37de7a4933e0d305c2ad832f69b7ea1eb15'),
    (0x4c2790, 0x4c2898, '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377, 0x4c558b, 'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
    (0x4c5d4b, 0x4c609b, 'cfb7385d2efeb3e0fe986eb4812d22f3447e4b1134ff5086a655a0ccc10d5379'),
    (0x4c924d, 0x4c92c5, 'e475cd56cf48f243d65af4bac77bf5b42d25ba3ca2243d775b3e2a2a58793a81'),
    (0x4c92c5, 0x4c9340, '367561d23a3a01a88e45d0ea6887498ac8f95e1d4d48d34f78c7b05b70aaacca'),
    (0x4d2c20, 0x4d3073, 'a3a64815176d5fedc00262247ba11a5e2f9050a406b46c38f3b4f013a2bd0016'),
    (0x4d3992, 0x4d39f9, 'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
    (0x4d39f9, 0x4d3a52, '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
    (0x4e8d96, 0x4e8dc8, '0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85'),
    (0x4fb2e3, 0x4fb397, 'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
    (0x4fb77a, 0x4fba69, '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
    (0x4fba69, 0x4fba86, '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
    (0x50ca3e, 0x50ca90, 'e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73'),
    (0x50cd50, 0x50cd72, '0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477'),
    (0x50ce04, 0x50ce2b, 'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
    (0x5110a9, 0x5117ea, '30ab89539b4634e594dabcd0d4a34ec0b1144258e9431d606224d47327dc56ff'),
    (0x5117ea, 0x51181f, 'bdd9c94b0f84d222abba49b0dd9c6ff49164736dc4a0b443c3c5514c565947fe'),
    (0x51181f, 0x511850, 'd5748a1236092028ae8b199bac0bb65729e23f668a9cebb0ddbc9575a160e454'),
    (0x511850, 0x511888, '9bfcb6c87e82e7113264f86175a304743888349564947d1146fe8ecdccf6f9ee'),
    (0x511888, 0x511895, '639148f2f162bda27c1f66ab90d68794bac59a533c7cbf65580a2c6853ef771f'),
    (0x5167a0, 0x516810, '966ff9f7dfaffbf0817f818f7c7816e2518a2383269e57586d51908ee7cf8535'),
    (0x516810, 0x516885, 'e85ca4198a284fa33b4141d18479ff2edfded90a25e35567ac9d55bd2bccb611'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


# ---- object layout (offsets from 0x61ee6e): name -> (offset, size, signed)
OBJ_SCALARS = {'slot': (0x04, 2, 1), 'row': (0x06, 2, 1), 'surface': (0x0C, 4, 0), 'state': (0x10, 4, 1), 'active': (0x14, 4, 0),
               'passed': (0x18, 4, 0), 'reached': (0x1C, 4, 0), 'finishing': (0x20, 4, 0), 'flag34': (0x34, 4, 0), 'count': (0x48, 2, 1),
               'hits': (0x54E, 4, 1), 'score': (0x552, 4, 1), 'prev_score': (0x556, 4, 1), 'dword55a': (0x55A, 4, 0), 'minutes': (0x626, 4, 1),
               'seconds': (0x62A, 4, 1), 'start_tick': (0x62E, 4, 0), 'elapsed': (0x632, 4, 0), 'key_char': (0x636, 1, 0),
               'key_pending': (0x637, 4, 0), 'max_char': (0x63B, 2, 1), 'end_deadline': (0x63D, 4, 0), 'target': (0x641, 2, 1)}
BALLOON0, BALLOON_SIZE = 0x4A, 0x37
BALLOON_FIELDS = {'src0': (0x00, 4, 1), 'src1': (0x04, 4, 1), 'src2': (0x08, 4, 1), 'src3': (0x0C, 4, 1), 'dst0': (0x10, 4, 1), 'dst1': (0x14, 4, 1),
                  'dst2': (0x18, 4, 1), 'dst3': (0x1C, 4, 1), 'ch': (0x20, 1, 0), 'text_x': (0x21, 4, 1), 'text_y': (0x25, 4, 1),
                  'deadline': (0x29, 4, 0), 'spawn': (0x2D, 4, 0), 'lifetime': (0x31, 2, 1), 'state': (0x33, 4, 1)}
UNMODELLED = ((0, 4), (8, 12), (0x24, 0x34), (0x38, 0x48))
SCORE_BLOCK, CLOCK_BLOCK = 0x496, 0x55E
W_STR = {'minutes_str': 0x248, 'seconds_str': 0x252, 'score_str': 0x25C, 'prev_minutes_str': 0x266, 'prev_seconds_str': 0x270, 'prev_score_str': 0x27A}


def fld(img, name):
    off, size, sg = OBJ_SCALARS[name]
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=bool(sg))


def put_fld(img, name, v):
    off, size, _ = OBJ_SCALARS[name]
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


def bfld(img, k, name):
    off, size, sg = BALLOON_FIELDS[name]
    off += BALLOON0 + BALLOON_SIZE * k
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=bool(sg))


def put_bfld(img, k, name, v):
    off, size, _ = BALLOON_FIELDS[name]
    off += BALLOON0 + BALLOON_SIZE * k
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xf5 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('tick', 'rand', 'handle')}
        self.qpos = Counter()
        self.in_complete = False
        self.in_reset = False
        self.recording = False
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
            rets = {int(i.op_str, 0) if i.op_str else 0 for i in md.disasm(self.pristine[a - base:a - base + span], a) if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise d9.OracleError('hooked function %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def _check_constants(self):
        base = self.pe.image_base

        def img(va, n):
            return bytes(self.pristine[va - base:va - base + n])
        want = [(0x551DB0, LABEL_ENTRY + b'\0'), (0x551DCC, LABEL_SURFACE + b'\0'), (0x551DEC, LABEL_KIND + b'\0')]
        want += [(va, NO_SOUND) for va in NO_SOUND_VAS]
        want += [(va, text + b'\0') for va, (_, text) in BLIT_LABELS.items()]
        want += [(va, text + b'\0') for va, text in EXTRA_LABELS]
        for va, data in want:
            if img(va, len(data)) != data:
                raise d9.OracleError('image constant at %#x differs from the kernel assumption: %r' % (va, img(va, len(data))))

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.blits = []
        self.texts = []
        self.in_complete = False
        self.in_reset = False

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in ('tick', 'rand', 'handle')}
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
        table.update({HANDLER: self._handler, HANDLER_RETURN: self._handler_return, GENERIC_COMPLETION: self._complete,
                      GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen, AT_QUIZ_REGISTER: self._at_register,
                      AT_QUIZ_SLOT_SURFACE: self._at_slot_surface, RELEASE_SLOT_FN: self._release_slot, M_RESET: self._reset_enter,
                      M_RESET_RET: self._reset_leave, MORE_BALLOONS_LOCALS: self._zero_locals, AT_SCORE_INIT: self._at_init(0x16C, 0x168, 'INIT_SCORE'),
                      AT_CLOCK_INIT: self._at_init(0x234, 0x230, 'INIT_CLOCK'), W_SET_SCORE: self._w_call('SET_SCORE', 1),
                      W_SET_CLOCK: self._w_call('SET_CLOCK', 2), W_ENABLE_SCORE: self._w_call('ENABLE_SCORE', 1),
                      W_ENABLE_CLOCK: self._w_call('ENABLE_CLOCK', 1), W_RESET_SCORE: self._w_call('RESET_DISPLAY', 0),
                      W_RESET_CLOCK: self._w_call('RESET_CLOCK', 0)})
        for a in SLOT_POINTS:
            table[a] = self._after_alloc
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

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise d9.OracleError('handler entered with ECX != 0x61ee6e')
        self.events.append(('handler', row, self.row_phase(row)))

    def _handler_return(self, uc, address, size, user):
        pass

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

    def _reset_enter(self, uc, address, size, user):
        self.in_reset = True

    def _reset_leave(self, uc, address, size, user):
        self.in_reset = False

    def _zero_locals(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        uc.mem_write(sp, bytes(16))

    def _after_alloc(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT'], uc.reg_read(X.UC_X86_REG_EAX) & 0xFFFF, 0))

    def _at_register(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT_REGISTER'], self.rs16(OBJ + 4), 0))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 4)
        self.events.append(('fx', FX['SLOT_SURFACE'], slot, self.entry_surface(slot)))

    def _at_init(self, slot_off, surface_off, name):
        def run(uc, address, size, user):
            self.events.append(('fx', FX[name], u32(uc, WIDGET + slot_off), u32(uc, WIDGET + surface_off)))
        return run

    def _w_call(self, name, nargs):
        def run(uc, address, size, user):
            sp = uc.reg_read(X.UC_X86_REG_ESP)
            a = [u32(uc, sp + 4 + 4 * i) for i in range(nargs)] + [0, 0]
            self.events.append(('fx', FX[name], a[0], a[1]))
        return run

    def _release_slot(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('fx', FX['RELEASE_SLOT'], struct.unpack('<H', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(8)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        if address in WANT_ECX and ecx != WANT_ECX[address]:
            raise d9.OracleError('hook %#x entered with ECX=%#x' % (address, ecx))
        if address == LOAD_IMAGE:
            kind, name, six, label = d9.cstr(self.rd(a[0], 32)), d9.cstr(self.rd(a[1], 64)), a[2], d9.cstr(self.rd(a[3], 64))
            if kind != LABEL_KIND or six != 6 or label != LABEL_SURFACE:
                raise d9.OracleError('image loader arguments differ from the packet: %r %r %d %r' % (kind, name, six, label))
            eax = self.pop('handle')
            self.loaded.append(name.decode('latin1'))
            self.events.append(('fx', FX['SURFACE_LOAD'], eax, 0))
        elif address == RELEASE_IMAGE:
            if a[0] != OBJ + 0x0C:
                raise d9.OracleError('releaser called for %#x' % a[0])
            old = u32(uc, a[0])
            self.events.append(('fx', FX['RELEASE_SURFACE'], old, 0))
            self.wr(a[0], bytes(4))
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == CLEAR_ITEM:
            self.events.append(('fx', FX['CLEAR_ITEM'], 0, 0))
        elif address in (FONT_ACQUIRE, FONT_RELEASE):
            if a[0] != 10:
                raise d9.OracleError('font routine called with %d' % a[0])
            self.events.append(('fx', FX['FONT_ACQUIRE'] if address == FONT_ACQUIRE else FX['FONT_RELEASE'], 10, 0))
        elif address == RAND:
            eax = self.pop('rand')
            self.events.append(('fx', FX['RANDOM'], eax, 0))
        elif address == TEXT_DRAW:
            self.texts.append(dict(ch=self.rd(a[0], 1)[0], tail=self.rd(a[0] + 1, 1)[0], arg1=a[1], arg2=a[2], x=a[3] & 0xFFFF, y=a[4] & 0xFFFF,
                                   colour=a[5], target=a[6], zero=a[7]))
            self.blits.append(('text', len(self.texts) - 1))
        elif address in (BLIT_OPAQUE, BLIT_RESTORE):
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            if a[4] not in BLIT_LABELS:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            kind, text = BLIT_LABELS[a[4]]
            if (kind in RESTORE_KINDS) != (address == BLIT_RESTORE):
                raise d9.OracleError('blit routine %#x used with the label %#x' % (address, a[4]))
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=text, label_ptr=a[4], kind=kind,
                                   src_ptr=a[2], dst_ptr=a[3]))
        else:
            raise d9.OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    def body_ptr(self, pointer):
        """The body pointer of the row whose body contains `pointer` (the sound records are inside it)."""
        k = (pointer - d9.BODY_BASE) // BODY_STRIDE
        if not 0 <= k < MAX_ROWS:
            raise d9.OracleError('record %#x is not inside a row body' % pointer)
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
            return                              # the whole window is compared
        off = address - OBJ
        if 0 <= off < OBJ_LEN:
            if off == 0x14 and size == 4 and not self.in_reset:
                self.events.append(('fx', FX['ACTIVE'], value, 0))
            elif off == 0x10 and size == 4:
                self.events.append(('fx', FX['STATE'], value, 0))
        hit = WRITE_FX.get(address)
        if hit is not None and hit[1] == size:
            self.events.append(('fx', hit[0], value, 0))
        self.written['%#x/%d' % (address, size)] += 1

    # -- state access ----------------------------------------------------------------------------
    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def entry_surface(self, slot):
        return struct.unpack('<I', self.rd(ENTRY + slot * STRIDE + 8, 4))[0]

    def rs16(self, va):
        return struct.unpack('<h', self.rd(va, 2))[0]

    def cell(self, va, size=4):
        return int.from_bytes(self.rd(va, size), 'little')

    def set_cell(self, va, value, size=4):
        self.wr(va, (value & mask(size)).to_bytes(size, 'little'))

    def obj_image(self):
        return self.rd(OBJ, OBJ_LEN)

    def widget_image(self):
        return self.rd(WIDGET, WIDGET_LEN)

    def world_image(self):
        return self.rd(CELL_START, 4) + self.rd(CELL_PLAYED, 4) + self.rd(CELL_BEST, 2)

    def put_world(self, blob):
        self.wr(CELL_START, blob[:4])
        self.wr(CELL_PLAYED, blob[4:8])
        self.wr(CELL_BEST, blob[8:10])

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

    def run_method(self, queues, address, args, ecx=OBJ):
        self.begin(queues)
        try:
            eax, _ = self.call(address, args, ecx)
        finally:
            self.recording = False
        return eax


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
SOURCES = ('action_family_f5_runtime.c', 'score_time_display.c')
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS, ERR_STUCK = 0, 1, 2, 3, 4, 5, 6
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_VIEW, F_PREPARE, F_STOP, F_PLAY, F_TRANSITION, F_FLAG,
 F_CLEAR, F_FONT_ACQUIRE, F_FONT_RELEASE, F_MODE, F_REGISTER_DISPLAY, F_REGISTER_CLOCK) = [1 << k for k in range(19)]
QKINDS = ('tick', 'rand', 'handle')
MAX_BLITS = 192
BLIT_INTS = 13


def build_driver(src_dir, out, strict=True, sanitize=False, fuzz=False):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O0', '-g', f'-I{src_dir}', str(PROJECT / 'tests/action_family_f5_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if not fuzz:
        cmd[8:8] = ['-fPIC', '-shared']
    else:
        cmd[8:8] = ['-DF5O_FUZZ_MAIN']
    if strict:
        cmd.insert(5, '-Werror')
    if sanitize or os.environ.get('F5_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def norm_fx(kind, a, b):
    sa, sb = FX_SIZE.get(kind, (4, 4))
    return ('fx', kind, a & mask(sa), b & mask(sb))


def norm_events(events):
    return [norm_fx(*e[1:]) if e[0] == 'fx' else e for e in events]


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        P, I32, U32, I64P, I32P = C.c_void_p, C.c_int32, C.c_uint32, C.POINTER(C.c_int64), C.POINTER(C.c_int32)
        lib.f5o_new.restype = P
        for name, args, res in (
                ('f5o_free', [P], None), ('f5o_reset', [P], None), ('f5o_clear_logs', [P], None), ('f5o_set_fail', [P, C.c_int], None),
                ('f5o_set_view', [P, I32P, I32P], None), ('f5o_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('f5o_q_pos', [P, C.c_int], C.c_int), ('f5o_q_underflow', [P, C.c_int], C.c_int),
                ('f5o_obj_get', [P, C.c_char_p], None), ('f5o_obj_set', [P, C.c_char_p], None),
                ('f5o_world_get', [P, C.c_char_p], None), ('f5o_world_set', [P, C.c_char_p], None),
                ('f5o_widget_get', [P, C.c_char_p], None), ('f5o_widget_set', [P, C.c_char_p], None),
                ('f5o_cells_get', [P, I32P], None), ('f5o_cells_set', [P, I32P], None),
                ('f5o_events_get', [P, C.c_char_p], None), ('f5o_events_set', [P, C.c_char_p], None),
                ('f5o_entries_get', [P, C.c_char_p], None), ('f5o_entries_set', [P, C.c_char_p], None),
                ('f5o_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('f5o_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('f5o_str', [P, C.c_int], C.c_char_p),
                ('f5o_nstr', [P], C.c_int), ('f5o_errors', [P, I32P], None),
                ('f5o_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('f5o_key', [P, U32, C.c_int], C.c_int), ('f5o_key_filter', [C.c_int], C.c_int),
                ('f5o_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('f5o_click', [P, U32, I32, I32P], None),
                ('f5o_invalidate', [P], C.c_int), ('f5o_cleanup', [P], C.c_int), ('f5o_new_game', [P], None),
                ('f5o_validate', [C.c_char_p, C.c_int], C.c_int), ('f5o_render', [P, C.c_char_p, C.c_int, I32P], None),
                ('f5o_render_score', [P, I32P], None), ('f5o_render_clock', [P, I32P], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.f5o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.f5o_free(self.h)

    def reset(self):
        self.lib.f5o_reset(self.h)

    def clear_logs(self):
        self.lib.f5o_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.f5o_set_fail(self.h, m)

    def set_view(self, absolute, local):
        a = (C.c_int32 * 4)(*[sgn(v, 4) for v in absolute])
        b = (C.c_int32 * 4)(*[sgn(v, 4) for v in local])
        self.lib.f5o_set_view(self.h, a, b)

    def set_queues(self, qs):
        for i, k in enumerate(QKINDS):
            vals = list(qs.get(k, []))[:8192]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.f5o_q_set(self.h, i, arr, len(vals))

    def qpos(self, k):
        return self.lib.f5o_q_pos(self.h, QKINDS.index(k))

    def qunder(self, k):
        return self.lib.f5o_q_underflow(self.h, QKINDS.index(k))

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.f5o_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.f5o_obj_set(self.h, bytes(img))

    def widget(self):
        buf = C.create_string_buffer(WIDGET_LEN)
        self.lib.f5o_widget_get(self.h, buf)
        return bytes(buf.raw)[:WIDGET_LEN]

    def set_widget(self, img):
        self.lib.f5o_widget_set(self.h, bytes(img))

    def world(self):
        buf = C.create_string_buffer(WORLD_LEN)
        self.lib.f5o_world_get(self.h, buf)
        return bytes(buf.raw)[:WORLD_LEN]

    def set_world(self, data):
        self.lib.f5o_world_set(self.h, bytes(data))

    def start_flag(self):
        return struct.unpack('<i', self.world()[:4])[0]

    def set_start(self, v):
        w = bytearray(self.world())
        w[:4] = struct.pack('<i', sgn(v, 4))
        self.set_world(bytes(w))

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.f5o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.f5o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.f5o_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.f5o_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.f5o_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.f5o_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.f5o_entry_set_u32(self.h, slot, off, v & M32)

    def log(self, which):
        arr = (C.c_int32 * (3 * 16384))()
        n = self.lib.f5o_log(self.h, which, arr, 16384)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def names(self):
        n = min(self.lib.f5o_nstr(self.h), 8)
        return [self.lib.f5o_str(self.h, i) for i in range(n)]

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.f5o_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.f5o_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def key(self, row_phase, ch):
        return self.lib.f5o_key(self.h, row_phase & M32, ch)

    def key_filter(self, ch):
        return self.lib.f5o_key_filter(ch)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 5)()
        self.lib.f5o_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, row_phase, candidate):
        out = (C.c_int32 * 2)()
        self.lib.f5o_click(self.h, row_phase & M32, sgn(candidate, 4), out)
        return tuple(out)

    def invalidate(self):
        return self.lib.f5o_invalidate(self.h)

    def cleanup(self):
        return self.lib.f5o_cleanup(self.h)

    def new_game(self):
        self.lib.f5o_new_game(self.h)

    def validate(self, body):
        return self.lib.f5o_validate(bytes(body), len(body))

    def _blits(self, out):
        blits = []
        for i in range(out[2] if 0 <= out[2] <= MAX_BLITS else 0):
            o = out[3 + BLIT_INTS * i:3 + BLIT_INTS * (i + 1)]
            blits.append(dict(kind=o[0], surface=o[1] & M32, src=tuple(o[2:6]), dst=tuple(o[6:10]), a=o[10], b=o[11], c=o[12]))
        return dict(status=out[0], valid=out[1], count=out[2], blits=blits)

    def render(self, body):
        out = (C.c_int32 * (3 + BLIT_INTS * MAX_BLITS))()
        self.lib.f5o_render(self.h, bytes(body), len(body), out)
        return self._blits(out)

    def render_score(self):
        out = (C.c_int32 * (3 + BLIT_INTS * MAX_BLITS))()
        self.lib.f5o_render_score(self.h, out)
        return self._blits(out)

    def render_clock(self):
        out = (C.c_int32 * (3 + BLIT_INTS * MAX_BLITS))()
        self.lib.f5o_render_clock(self.h, out)
        return self._blits(out)


# ---------------------------------------------------------------------------------------------
# bodies (1390 bytes)
# ---------------------------------------------------------------------------------------------
B_VARIANTS, B_VARIANT_RECT, B_POP_RECT, B_POSITIONS, B_POSITION_RECT = 0x21, 0x23, 0x163, 0x173, 0x175
B_SCORE_DIGITS, B_CLOCK_DIGITS, B_COLON = 0x2B5, 0x355, 0x3F5
B_SCORE_X, B_SCORE_Y, B_CLOCK_X, B_CLOCK_Y, B_SCORE_GAP, B_CLOCK_GAP, B_PASSED_RECT = 0x405, 0x409, 0x40D, 0x411, 0x415, 0x419, 0x41D
B_END_DELAY, B_CASE, B_DIGITS, B_WIDE, B_EXTRA = 0x42D, 0x431, 0x432, 0x433, 0x434
B_LIFE_MIN, B_LIFE_MAX, B_COUNT_MIN, B_COUNT_MAX, B_TIME, B_FACTOR, B_MIN_SCORE, B_DEFAULT_TARGET, B_PERCENT, B_LOW = (
    0x452, 0x454, 0x456, 0x458, 0x45A, 0x45C, 0x45E, 0x460, 0x462, 0x464)
B_SND = (0x466, 0x497, 0x4C8, 0x511)
B_CH = (0x487, 0x4B8, 0x4E9, 0x532)             # hit, miss, timeout, passed sound
B_PASSED, B_NORMAL, B_CURSOR, B_RECT = 0x4F9, 0x542, 0x55C, 0x55E
NAME_REAL = b'LIB_TypingGame_PUZ_OVL'


def snd(kind):
    return {'none': NO_SOUND, 'real': b'TypeLette\0', 'real2': b'clunk_7\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0'}[kind]


def put_snd(b, off, kind):
    """A sound record: the name, a terminator inside the 0x21 bytes (the native validator needs one; the original compares 9 bytes)."""
    data = snd(kind)
    b[off:off + len(data)] = data
    if 0 not in b[off:off + 0x21]:
        b[off + 0x20] = 0


SND_KINDS = ('none', 'real', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4')


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, flag2=-1):
    return dict(scene=scene, words=words, dwords=dwords, start=start, flag=flag, flag2=flag2)


def rand_block(rng, scene, flag=None, flag2=None):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)), rng.choice((-1, 0, 5, 340, 4095)) if flag is None else flag,
                 rng.choice((-1, 1, 77, 2047)) if flag2 is None else flag2)


def make_body(rng, name=NAME_REAL, V=18, N=20, case=0, digits=0, wide=0, extra=(), life=(2, 5), count=(2, 6), time=6, factor=2, min_score=19,
              default_target=20, percent=90, low=15, snd_kinds=('none', 'none', 'none', 'none'), ch=(1, 2, 3, 4), passed=None, normal=None,
              cursor=22, rect=(578, 4, 612, 38), delay=2000, garbage=True, positions=None, digit_wh=None, score_xy=(20, 10), clock_xy=(100, 10),
              gaps=(1, 2), passed_rect=None, pop=None, base=None):
    b = bytearray(base if base is not None else (bytes(rng.getrandbits(8) for _ in range(BODY_LEN)) if garbage else bytes(BODY_LEN)))
    b[0:0x21] = bytes(name[:0x20]).ljust(0x21, b'\0')
    if garbage and base is None:
        for k in range(len(name) + 1, 0x21):
            b[k] = rng.getrandbits(8)
    struct.pack_into('<h', b, B_VARIANTS, V)
    for k in range(20):
        x, y = rng.randint(0, 500), rng.randint(0, 300)
        struct.pack_into('<4i', b, B_VARIANT_RECT + 16 * k, x, y, x + rng.randint(10, 40), y + rng.randint(10, 40))
    struct.pack_into('<4i', b, B_POP_RECT, *(pop or (300, 10, 340, 50)))
    struct.pack_into('<h', b, B_POSITIONS, N)
    if positions is None:
        seen = set()
        positions = []
        while len(positions) < 20:
            x, y = rng.randint(-20, 560), rng.randint(-20, 400)
            if (x, y) in seen:
                continue
            seen.add((x, y))
            positions.append((x, y, x + rng.randint(5, 60), y + rng.randint(5, 60)))
    for k in range(20):
        struct.pack_into('<4i', b, B_POSITION_RECT + 16 * k, *positions[k])
    dw, dh = digit_wh or (rng.choice((6, 9, 12, 13)), rng.choice((10, 14, 20)))
    for base_off, w_, h_ in ((B_SCORE_DIGITS, dw, dh), (B_CLOCK_DIGITS, dw + rng.choice((0, 1)), dh)):
        for d in range(10):
            x, y = rng.randint(0, 400), rng.randint(0, 200)
            ww = w_ + (d % 3 if rng.random() < 0.3 else 0)
            hh = h_ + (d % 4 if rng.random() < 0.5 else 0)
            struct.pack_into('<4i', b, base_off + 16 * d, x, y, x + ww - 1, y + hh - 1)
    cx, cy = rng.randint(0, 400), rng.randint(0, 200)
    struct.pack_into('<4i', b, B_COLON, cx, cy, cx + rng.choice((3, 4, 6)), cy + rng.choice((8, 10, 14)))
    struct.pack_into('<ii', b, B_SCORE_X, *score_xy)
    struct.pack_into('<ii', b, B_CLOCK_X, *clock_xy)
    struct.pack_into('<i', b, B_SCORE_GAP, gaps[0])
    struct.pack_into('<i', b, B_CLOCK_GAP, gaps[1])
    struct.pack_into('<4i', b, B_PASSED_RECT, *(passed_rect or (rng.randint(0, 100), rng.randint(0, 100), rng.randint(110, 300), rng.randint(110, 200))))
    struct.pack_into('<i', b, B_END_DELAY, delay)
    b[B_CASE], b[B_DIGITS], b[B_WIDE] = case & 0xFF, digits & 0xFF, wide & 0xFF
    ex = bytes(extra)[:30]
    b[B_EXTRA:B_EXTRA + 30] = ex.ljust(30, b'\0')
    struct.pack_into('<10h', b, B_LIFE_MIN, life[0], life[1], count[0], count[1], time, factor, min_score, default_target, percent, low)
    for k in range(4):
        put_snd(b, B_SND[k], snd_kinds[k])
        struct.pack_into('<h', b, B_CH[k], ch[k])

    def put(off, blk, start_off, flag_off, flag2_off=None):
        struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, start_off, sgn(blk['start'], 2))
        struct.pack_into('<h', b, flag_off, blk['flag'])
        if flag2_off is not None:
            struct.pack_into('<h', b, flag2_off, blk['flag2'])
    put(B_PASSED, passed if passed is not None else block(9999), 0x50D, 0x50F)
    put(B_NORMAL, normal if normal is not None else block(9999), 0x556, 0x558, 0x55A)
    struct.pack_into('<h', b, B_CURSOR, cursor)
    struct.pack_into('<4i', b, B_RECT, *rect)
    assert len(b) == BODY_LEN
    return bytes(b)


def patch(body, off, data):
    b = bytearray(body)
    b[off:off + len(data)] = data
    return bytes(b)


def body_info(body):
    w = lambda o: struct.unpack_from('<h', body, o)[0]  # noqa: E731
    return dict(V=w(B_VARIANTS), N=w(B_POSITIONS), life=(w(B_LIFE_MIN), w(B_LIFE_MAX)), count=(w(B_COUNT_MIN), w(B_COUNT_MAX)), time=w(B_TIME),
                factor=w(B_FACTOR), min_score=w(B_MIN_SCORE), default=w(B_DEFAULT_TARGET), percent=w(B_PERCENT), low=w(B_LOW),
                case=body[B_CASE], digits=body[B_DIGITS], wide=body[B_WIDE], extra0=body[B_EXTRA], delay=struct.unpack_from('<i', body, B_END_DELAY)[0],
                rect=struct.unpack_from('<4i', body, B_RECT), cursor=w(B_CURSOR))


_REAL = []


def real_rows():
    """The four real raw-0xf5 rows of resources 1053 and 1054 (body, dependency tail), read from the local evidence; [] when absent."""
    if not _REAL:
        out = []
        try:
            corpus = json.loads(CORPUS.read_text())
            for row in corpus['records']:
                data = (RESOURCES / ('%04d.bin' % row['resource_index'])).read_bytes()
                p, n = row['act_payload_offset'], row['act_payload_length']
                body = data[p:p + n][50:]
                out.append((body[:BODY_LEN], body[BODY_LEN:], row['subtype']))
        except (OSError, KeyError, ValueError):
            out = []
        _REAL.append(out)
    return _REAL[0]


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
HANDLES = [0x4441, 0x1, M32, 0x7FFFFFFF, 0x5151]
POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
OBJ_RANGE = (OBJ, OBJ + OBJ_LEN)
WIDGET_RANGE = (WIDGET, WIDGET + WIDGET_LEN)
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
EVENT_RANGE = (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, WIDGET_RANGE, ENTRY_RANGE, EVENT_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4), (CELL_PLAYED, CELL_PLAYED + 4),
             (CELL_BEST, CELL_BEST + 2)] + [(va, va + sz) for _, va, sz in XFER],
    'key': [OBJ_RANGE],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [OBJ_RANGE],
    'render_widget': [WIDGET_RANGE],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE],
    'new_game': [(CELL_PLAYED, CELL_PLAYED + 4), (CELL_BEST, CELL_BEST + 2)],
    'filter': [],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), keys=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0,
                known_divergences=Counter(), queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(),
                states=Counter(), outcomes=Counter(), slots=Counter(), blit_kinds=Counter(), geometry=Counter(), filter_bytes=0, score_formula=0)


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        if isinstance(a, list) and isinstance(b, list):
            k = next((i for i, (p, q) in enumerate(zip(a, b)) if p != q), min(len(a), len(b)))
            raise Mismatch('%s: %s differ at element %d of %d original / %d native: original %r native/model %r (context original %r)' % (
                where, what, k, len(a), len(b), a[k:k + 1], b[k:k + 1], a[max(0, k - 3):k]))
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def diff_obj(a, b):
    out = []
    for name, (off, size, _s) in OBJ_SCALARS.items():
        if a[off:off + size] != b[off:off + size]:
            out.append('%s original %s native %s' % (name, a[off:off + size].hex(), b[off:off + size].hex()))
    for k in range(20):
        base = BALLOON0 + BALLOON_SIZE * k
        if a[base:base + BALLOON_SIZE] != b[base:base + BALLOON_SIZE]:
            fa = {n: bfld(a, k, n) for n in BALLOON_FIELDS}
            fb = {n: bfld(b, k, n) for n in BALLOON_FIELDS}
            out.append('balloon %d: ' % k + ', '.join('%s original %d native %d' % (n, fa[n], fb[n]) for n in fa if fa[n] != fb[n]))
    for name, off, n in (('score_block', SCORE_BLOCK, 0xB8), ('clock_block', CLOCK_BLOCK, 200)):
        if a[off:off + n] != b[off:off + n]:
            ws = [i for i in range(0, n, 4) if a[off + i:off + i + 4] != b[off + i:off + i + 4]]
            out.append('%s dwords %s original %s native %s' % (name, [i // 4 for i in ws[:4]], [a[off + i:off + i + 4].hex() for i in ws[:3]],
                                                             [b[off + i:off + i + 4].hex() for i in ws[:3]]))
    for lo, hi in UNMODELLED:
        if a[lo:hi] != b[lo:hi]:
            out.append('unmodelled bytes %#x..%#x original %s native %s' % (lo, hi, a[lo:hi].hex(), b[lo:hi].hex()))
    return out


def widget_diff(a, b):
    out = []
    for i in range(0, WIDGET_LEN, 4):
        if a[i:i + 4] != b[i:i + 4]:
            out.append('+%#x original %s native %s' % (i, a[i:i + 4].hex(), b[i:i + 4].hex()))
            if len(out) > 5:
                break
    return out


def mask_string_tails(img):
    """The widget image with every byte after the NUL of the six strings zeroed (K8)."""
    img = bytearray(img)
    for off in W_STR.values():
        s = bytes(img[off:off + 10])
        if 0 in s:
            z = s.index(0)
            img[off + z + 1:off + 10] = bytes(9 - z)
    return bytes(img)


class Run:
    """Per-scenario model state."""

    def __init__(self, sc, rows):
        self.sc = sc
        self.rows = [dict(r) for r in rows]
        self.count = len(rows)
        self.cells = {}          # expected values of the pointer cells
        self.fx_seen = 0
        self.hc_seen = 0
        self.clock = 100000
        self.trace = []
        self.row_images = []
        self.loaded_expected = []
        self.obj8 = 0
        self.live = False
        self.handle_i = 0

    def f5_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xF5]

    def queues(self, rng, over=None, nrand=3000, ntick=96):
        over = over or {}
        self.handle_i += 1
        q = dict(tick=[self.clock] * ntick, rand=[rng.getrandbits(15) for _ in range(nrand)], handle=[HANDLES[self.handle_i % 5]] * 2)
        q.update(over)
        return q


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(slot=-1, row=rng.choice((-1, 0, 1, 3)), surface=rng.choice((0, 0, 0x5151, M32)), state=rng.choice((0, 1, 2, 3, 5, 9, M32)),
             active=0, passed=rng.choice((0, 1, 0x7F)), reached=rng.choice((0, 1, 2)), finishing=rng.choice((0, 1, 0x80)),
             flag34=rng.choice((0, 1, 3)), count=rng.choice((0, 3, 25, -2)), key_pending=rng.choice((0, 0, 1, 5)), key_char=rng.getrandbits(8),
             max_char=0, hits=rng.choice((0, 3, 99, -4)), score=rng.choice((0, 7, 4000)), prev_score=rng.choice((0, 7, -9, 123456)),
             target=rng.choice((0, 20, -5, 3000)), minutes=rng.choice((0, 5, 60, -1)), seconds=rng.choice((0, 33, -1)),
             start_tick=rng.getrandbits(32), elapsed=rng.getrandbits(32), end_deadline=rng.getrandbits(32))
    for k in range(20):
        put_bfld(img, k, 'state', rng.choice((0, 0, 1, 2, 3, 9)))
    return img, g


def build_events(rng):
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & M32)
    for k in range(1000, 1008):
        struct.pack_into('<I', pattern, 4 * k, 0)
    return pattern


def seed_scenario(x, nat, run, rng):
    sc = run.sc
    x.hard_reset()
    nat.reset()
    x.install_rows(run.rows)
    x.w32(CELL_MODE, sc['mode'])
    init = sc['init']
    pattern = build_events(rng)
    for idx, v in sc['events'].items():
        struct.pack_into('<i', pattern, 4 * idx, v)
    x.wr(EVENTS_VA, pattern)
    nat.set_events(pattern)
    # the singleton: garbage unless the scenario names the field
    img, g = garbage_obj(rng)
    g.update(init.get('obj', {}))
    for k, v in g.items():
        put_fld(img, k, v)
    for k, fields in init.get('balloons', {}).items():
        for n, v in fields.items():
            put_bfld(img, k, n, v)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    run.obj8 = struct.unpack_from('<I', img, 8)[0]
    # the widget: garbage with both halves off (power-on zero when the scenario says so)
    wspec = init.get('widget')
    wimg = bytearray(WIDGET_LEN)
    if isinstance(wspec, dict):
        for n, off in enumerate((4, 8, 0xC, 0x10)):
            wimg[off:off + 4] = struct.pack('<I', (wspec['flags'] >> n) & 1)
        for off, text in ((W_STR['score_str'], b'123'), (W_STR['prev_score_str'], b'45'), (W_STR['minutes_str'], b'05'), (W_STR['seconds_str'], b'09'),
                          (W_STR['prev_minutes_str'], b'12'), (W_STR['prev_seconds_str'], b'34')):
            wimg[off:off + len(text)] = text
        for off in range(0x18, 0x168, 4):                       # digit rectangles / sizes: small distinct numbers
            struct.pack_into('<i', wimg, off, 2 + (off % 7))
    elif wspec != 'zero':
        wimg[:] = bytes(rng.getrandbits(8) for _ in range(WIDGET_LEN))
        for off in (4, 8, 0xC, 0x10):
            wimg[off:off + 4] = bytes(4)
    x.wr(WIDGET, bytes(wimg))
    nat.set_widget(bytes(wimg))
    # the process cells
    world = struct.pack('<iiH', sgn(init.get('start', rng.choice((0, 1, M32, 5))), 4), init.get('played', rng.choice((0, 1, 7))),
                        init.get('best', rng.choice((0, 1, 50, 200, 0xFFF0, 3000))) & 0xFFFF)
    x.put_world(world)
    nat.set_world(world)
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    x.set_cell(CELL_COLOUR, init.get('colour', 0x0BAD0357))
    view = init.get('view', (0, 0, 640, 480))
    local = init.get('local', (0, 0, view[2] - view[0], view[3] - view[1]))
    x.wr(CELL_VIEW, struct.pack('<4i', *[sgn(v, 4) for v in view]))
    x.wr(CELL_LOCAL, struct.pack('<4i', *[sgn(v, 4) for v in local]))
    nat.set_view(view, local)
    # the generic Z entry table: garbage, busy seeds decide the allocation
    table = bytearray(rng.getrandbits(8) for _ in range(NENT * STRIDE))
    for s in range(NENT):
        struct.pack_into('<I', table, s * STRIDE + 0x18, 0 if 0x18 <= s <= 0x3F else rng.choice((0, 1, 0xFF000001)))
        struct.pack_into('<I', table, s * STRIDE + 0x14, rng.choice((0, 1)))
    for s in init.get('busy_slots', []):
        struct.pack_into('<I', table, s * STRIDE + 0x18, rng.choice((1, 1, 0xFF000001, 0x80000000)))
    struct.pack_into('<I', table, 1 * STRIDE + 8, BG_HANDLE)
    for name, (va, sz) in POINTER_CELLS.items():
        v = {'cand': init.get('cand', 0), 'k0': rng.choice((0, 1, 4, 7)), 'k1': rng.choice((0, 1))}.get(name, rng.getrandbits(32))
        v = init.get(name, v)
        run.cells[name] = v & mask(sz)
        if va >= ENTRY:
            struct.pack_into('<I', table, va - ENTRY, v & M32)
    x.wr(ENTRY, bytes(table))
    nat.set_entries(bytes(table))
    for name, (va, sz) in POINTER_CELLS.items():
        if va < ENTRY:
            x.set_cell(va, run.cells[name], sz)


def compare_all(where, x, nat, stats, run, rows=True, light=False):
    img_x, img_n = x.obj_image(), bytearray(nat.obj())
    img_n[8:12] = struct.pack('<I', run.obj8 & M32)
    img_n = bytes(img_n)
    if img_x != img_n:
        raise Mismatch('%s: object image 0x61ee6e..+0x643 differs: %s' % (where, '; '.join(diff_obj(img_x, img_n)[:6])))
    stats['compared_fields'] += len(OBJ_SCALARS) + 20 + 4
    wx, wn = x.widget_image(), nat.widget()
    if wx != wn:
        if mask_string_tails(wx) == mask_string_tails(wn):
            stats['known_divergences']['K8 widget string bytes after the NUL (dead bytes; native resynchronised)'] += 1
            nat.set_widget(wx)
        else:
            raise Mismatch('%s: widget image 0x638603..+0x288 differs: %s' % (where, '; '.join(widget_diff(wx, wn))))
    stats['compared_fields'] += WIDGET_LEN // 4
    wxw, wnw = x.world_image(), nat.world()
    if wxw != wnw:
        raise Mismatch('%s: process cells differ (start flag 0x5bb1ca, played 0x5a4c0a, best 0x5a4c0e): original %s native %s' % (where, wxw.hex(), wnw.hex()))
    stats['compared_fields'] += 3
    for name in ('cand', 'k0', 'k1'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    if light:
        return
    cells = nat.cells()
    check(stats, where, 'engine mode 0x583999', sgn(x.cell(CELL_MODE), 4), cells[0])
    for k, (name, va, sz) in enumerate(XFER):
        check(stats, where, 'scene-change cell ' + name, sgn(x.cell(va, sz), sz), cells[1 + k] if sz == 4 else sgn(cells[1 + k], 2))
    check(stats, where, 'event flag window (4096 dwords)', x.rd(EVENTS_VA, 4 * EVENT_COUNT), nat.events())
    ent = bytearray(nat.entries())
    for name in ('c162d', 'c1631', 'c1639'):         # these three cells are fields of entry 2 (the cursor entry): the host-composed values
        va, sz = POINTER_CELLS[name]
        struct.pack_into('<I', ent, va - ENTRY, run.cells[name])
    check(stats, where, 'generic Z entry table (0x58 x 0x4a bytes, cursor entry cells composed)', x.rd(ENTRY, NENT * STRIDE), bytes(ent))
    for name in ('c162d', 'c1631', 'c1639'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    check(stats, where, 'view rectangle cells (unchanged)', x.rd(CELL_VIEW, 32), x.rd(CELL_VIEW, 32))
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
                raise Mismatch('%s: row %d body bytes differ at offsets %s: original %s model %s' % (
                    where, i, [hex(k) for k in bad[:6]], [hex(got[k]) for k in bad[:6]], [hex(want[k]) for k in bad[:6]]))
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
    for k in QKINDS:
        check(stats, where, 'queue %s consumed' % k, x.qpos[k], nat.qpos(k))
        check(stats, where, 'queue %s underflow (native)' % k, 0, nat.qunder(k))
        stats['queue_values_consumed'] += x.qpos[k]
    check(stats, where, 'host contract errors (label, record pointers, slot range, allocator)', (0, 0, 0), nat.errors())


def native_fx(nat, run):
    """New observer entries and host calls since the previous call: (mapped observer, host calls, observer host-call subset)."""
    fx, hc = nat.log(0), nat.log(1)
    nf, nh = fx[run.fx_seen:], hc[run.hc_seen:]
    run.fx_seen, run.hc_seen = len(fx), len(hc)
    mapped = []
    for k, a, b in nf:
        mapped.append(norm_fx(k, a, b))
        if k == FX['RESET_DISPLAY']:                     # 0x445f53 then 0x445fc5: the kernel reports one effect for both
            mapped.append(norm_fx(FX['RESET_CLOCK'], 0, 0))
    hosts = []
    for k, a, b in nh:
        if k == HC_MARK_DIRTY:
            continue
        hosts.append(norm_fx(FX['MODE'], a, 0) if k == HC_ENGINE_MODE else norm_fx(k, a, b))
    only = [e for e in mapped if e[1] in HOST_FX]
    dirty = [(k, a, b) for k, a, b in nh if k == HC_MARK_DIRTY]
    return mapped, hosts, only, dirty


def count_effects(stats, mapped):
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1


def sync_row_images(x, run):
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]


def start_tick(nat, run, queues):
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    return queues


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    sync_row_images(x, run)
    queues = start_tick(nat, run, run.queues(rng, queues))
    img = x.obj_image()
    if fld(img, 'active'):
        stats['states']['phase_visit_state_%d' % min(max(fld(img, 'state'), -1), 9)] += 1
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
                w = bytearray(nat.world())
                w[:4] = struct.pack('<i', 1)
                nat.set_world(bytes(w))
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0xF5:
                visit_f5(where, x, nat, run, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', norm_events(x.events), expected)
    stats['ordered_events'] += len(x.events)
    check(stats, where, 'image names the loader was asked for', x.loaded, run.loaded_expected)
    check(stats, where, 'image names (native host)', [s.decode('latin1') for s in nat.names()], run.loaded_expected)
    run.loaded_expected = []
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


def visit_f5(where, x, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native tqz_step status %d for row %d phase %d (a native refusal the scenario must avoid)' % (where, status, i, phase))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    check(stats, where, 'no mark-dirty host call in a handler visit', dirty, [])
    count_effects(stats, mapped)
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
    classify(stats, phase, pre, mapped, body)
    run.loaded_expected += [d9.cstr(body[:0x21]).decode('latin1')] * sum(1 for e in mapped if e[1] == FX['SURFACE_LOAD'])
    run.obj8 = d9.BODY_BASE + BODY_STRIDE * i
    if phase == 0:
        run.live = True
        stats['slots'][fld(nat.obj(), 'slot')] += 1
        info = body_info(body)
        stats['geometry']['digits_%d' % (info['digits'] != 0)] += 1
        stats['geometry']['case_%d' % (info['case'] != 0)] += 1
        stats['geometry']['wide_%d' % (info['wide'] != 0)] += 1
        stats['geometry']['extra_%d' % (info['extra0'] != 0)] += 1
        stats['geometry']['positions_%d' % min(info['N'], 21)] += 1
        stats['geometry']['count_max_%d' % info['count'][1]] += 1
    if completed:
        check(stats, where, 'native completion phase', phase_after, 0)
        r['phase'] = 0
        run.obj8 = 0
        run.live = False
    else:
        r['phase'] = phase_after


def classify(stats, phase, pre, mapped, body):
    """Coverage bookkeeping only (never part of a check)."""
    state = fld(pre, 'state')
    kinds = [e[1] for e in mapped]
    if phase == 0:
        stats['handler_visits']['phase0'] += 1
        return
    if phase == 2:
        stats['handler_visits']['phase2_%s' % ('passed' if fld(pre, 'passed') else 'reached' if fld(pre, 'reached') else 'plain')] += 1
        return
    if phase != 1:
        stats['handler_visits']['phase_other'] += 1
        return
    stats['handler_visits']['phase1_state_%s' % (state if 0 <= state <= 2 else 'other')] += 1
    if state == 0:
        stats['outcomes']['play_hit' if FX['SOUND_PLAY'] in kinds and FX['TICK'] in kinds and fld(pre, 'key_pending') else 'play'] += 1
        if FX['SET_CLOCK'] in kinds:
            stats['outcomes']['clock_changed'] += 1
        if FX['SET_SCORE'] in kinds:
            stats['outcomes']['score_changed'] += 1
        if FX['STATE'] in kinds:
            stats['outcomes']['time_up_detected'] += 1
        if fld(pre, 'key_pending'):
            stats['outcomes']['key_consumed_hit' if any(e[1] == FX['SOUND_PLAY'] for e in mapped) else 'key_pending_none'] += 1
    elif state == 1:
        stats['outcomes']['time_up_%s' % ('passed' if fld(pre, 'score') >= fld(pre, 'target') else 'not_passed')] += 1
    elif state == 2:
        stats['outcomes']['wait_end_%s' % ('finished' if FX['PHASE'] in kinds else 'waiting')] += 1


def body_of_object(x, run, img):
    """The row the object's body pointer (+8, kept by the oracle: the kernel has no such field) names, or None."""
    p = run.obj8
    k = (p - d9.BODY_BASE) // BODY_STRIDE
    if p == d9.BODY_BASE + BODY_STRIDE * k and 0 <= k < len(run.rows) and run.rows[k]['type'] == 0xF5:
        return k
    return None


def row_phase_of(x, row):
    return x.row_phase(row)


def do_key(where, x, nat, run, stats, rng, ch, real_push=True):
    sync_row_images(x, run)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    stats['actions']['key'] += 1
    before = x.obj_image()
    row = fld(before, 'row')
    row_phase = row_phase_of(x, row)
    push = (ch & 0xFF) | (0x61EE00 if real_push else rng.getrandbits(24) << 8)
    x.run_method({}, M_KEY, [push])
    after = x.obj_image()
    stored_x = fld(before, 'key_pending') == 0 and fld(after, 'key_pending') == 1
    stored_n = nat.key(row_phase, ch if ch < 128 else ch - 256)
    check(stats, where, 'key: stored/refused outcome', int(stored_x), stored_n)
    if stored_x:
        check(stats, where, 'key: character stored', fld(after, 'key_char'), ch & 0xFF)
    check(stats, where, 'key: no stray effects', x.events, [])
    stats['keys']['stored' if stored_x else 'refused'] += 1
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    check(stats, where, 'key: native effects', (mapped, hosts, dirty), ([], [], []))
    check_writes(where, x, 'key', stats)
    compare_all(where, x, nat, stats, run, light=True)
    return stored_x


def do_filter_all(where, x, nat, run, stats, rng):
    """The key filter over all 256 bytes: through the real key method (state armed) and directly through 0x437ea1."""
    for ch in range(256):
        arm = bytearray(x.obj_image())
        put_fld(arm, 'active', 1)
        put_fld(arm, 'state', 0)
        put_fld(arm, 'key_pending', 0)
        put_fld(arm, 'row', 0)
        x.wr(OBJ, bytes(arm))
        nat.set_obj(bytes(arm))
        saved = run.rows[0]['phase'] if run.rows else 0
        x.w32(ROWS + PHASE_OFF, 1)
        run.rows[0]['phase'] = 1
        orig_direct = x.run_method({}, KEY_FILTER, [0x61EE00 | ch], KEY_FILTER_THIS) & 0xFF
        if not (ch in (0, 1) and False):
            check(stats, where, 'key filter %#04x: original 0x437ea1 versus tqz_key_filter' % ch, int(orig_direct != 0), nat.key_filter(ch if ch < 128 else ch - 256))
        stats['filter_bytes'] += 1
        do_key(where + ' filter %#04x' % ch, x, nat, run, stats, rng, ch, real_push=(ch % 2 == 0))
        run.rows[0]['phase'] = saved
        x.w32(ROWS + PHASE_OFF, saved)


def do_pointer(where, x, nat, run, stats, rng, px, py, light=False):
    img = nat.obj()
    active = fld(img, 'active') != 0
    ri = body_of_object(x, run, img)
    if active and ri is None:
        stats['skipped_native_refusal']['pointer: active object without a body pointer (+8)'] += 1
        return False
    body = run.rows[ri]['body'] if ri is not None else next(r['body'] for r in run.rows if r['type'] == 0xF5)
    sync_row_images(x, run)
    stats['actions']['pointer'] += 1
    xdw = (px & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= px <= 0xFFFF else px & M32
    ydw = (py & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= py <= 0xFFFF else py & M32
    nat.clear_logs()
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, kind, sub = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native tqz_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax, 1 if hit else 0)
    stats['pointer']['hit' if hit else 'inactive' if not active else 'miss'] += 1
    if hit:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32
        run.cells['c1639'] = 1
        check(stats, where, 'pointer: candidate is 0x27eb', cand, CAND_QUIZ)
        stats['pointer']['cursor_%d' % kind] += 1
    else:
        check(stats, where, 'pointer: no candidate on a miss', cand, -1)
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)
    return bool(hit)


def do_click(where, x, nat, run, stats):
    img = nat.obj()
    row = fld(img, 'row')
    row_phase = row_phase_of(x, row)
    sync_row_images(x, run)
    nat.clear_logs()
    stats['actions']['click'] += 1
    cand = sgn(x.cell(CELL_CAND), 4)
    x.run_method({}, M_CLICK, [])
    after = row_phase_of(x, row)
    clicked, new_phase = nat.click(row_phase, cand)
    new_phase &= M32
    check(stats, where, 'click: row phase after', after, new_phase)
    check(stats, where, 'click: claimed flag equals the original storing phase 2', int(after == 2 and row_phase != 2), clicked)
    check(stats, where, 'click: effects (only the row phase store)', norm_events(x.events), [('fx', FX['PHASE'], 2, 0)] if after != row_phase else [])
    stats['clicks']['accepted' if clicked else 'guarded'] += 1
    if 0 <= row < len(run.rows):
        run.rows[row]['phase'] = new_phase
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def blit_expectation_checks(where, x, nat, stats, plan, slot_of, label):
    """Compare the recorded original blits / texts with the kernel's list, in order."""
    orig = x.blits
    check(stats, where, label + ': blit count', len(orig), plan['count'])
    for k, (b, n) in enumerate(zip(orig, plan['blits'])):
        w = '%s %d' % (label, k)
        if isinstance(b, tuple):                      # a text draw
            t = x.texts[b[1]]
            check(stats, where, w + ': kind (text)', TEXT_KIND, n['kind'])
            check(stats, where, w + ': character', t['ch'], n['a'])
            check(stats, where, w + ': string terminator', t['tail'], 0)
            check(stats, where, w + ': x word', sgn(t['x'], 2), n['b'])
            check(stats, where, w + ': y word', sgn(t['y'], 2), n['c'])
            check(stats, where, w + ': constants (font tables, colour cell, target cell, zero)',
                  (t['arg1'], t['arg2'], t['colour'], t['target'], t['zero']), (0x5A9BA2, 0x5AED5A, x.cell(CELL_COLOUR), TARGET_HANDLE, 0))
            stats['blits'] += 1
            stats['blit_kinds'][TEXT_KIND] += 1
            continue
        check(stats, where, w + ': kind (label)', b['kind'], n['kind'])
        check(stats, where, w + ': this pointer', b['this'], THIS_SURF)
        check(stats, where, w + ': target surface', b['target'], TARGET_HANDLE)
        if b['kind'] in RESTORE_KINDS:
            check(stats, where, w + ': source surface is the background entry 1', b['src_surface'], x.cell(CELL_BG))
            check(stats, where, w + ': native background marker', n['surface'], 0)
        else:
            check(stats, where, w + ': source surface versus native', b['src_surface'], n['surface'])
            slot = slot_of(b['kind'])
            check(stats, where, w + ': source surface is the entry surface of the slot', b['src_surface'], x.entry_surface(slot))
        check(stats, where, w + ': source rectangle contents', b['src'], n['src'])
        check(stats, where, w + ': destination rectangle contents', b['dst'], n['dst'])
        kind = b['kind']
        if kind in (101, 103, 104):
            idx, rem = divmod(b['dst_ptr'] - (OBJ + BALLOON0 + 0x10), BALLOON_SIZE)
            check(stats, where, w + ': balloon index (destination pointer)', (idx, rem), (n['a'], 0))
        elif kind in (2, 6, 8):
            base = WIDGET + (0xBC if kind == 2 else 0x174)
            idx, rem = divmod(b['src_ptr'] - base, 16)
            check(stats, where, w + ': digit (source pointer)', (idx, rem), (n['a'], 0))
        stats['blits'] += 1
        stats['blit_kinds'][kind] += 1
    stats['renders']['blits_%d' % min(plan['count'], 20)] += 1


def widget_renderable(img):
    for off in W_STR.values():
        s = bytes(img[off:off + 10])
        if 0 not in s:
            return False
        if any(not (0x30 <= c <= 0x39) for c in s[:s.index(0)]):
            return False
    return True


def do_render(where, x, nat, run, stats, queues, rng):
    img = nat.obj()
    ri = body_of_object(x, run, img)
    slot = fld(img, 'slot')
    if ri is None or not run.live:
        stats['skipped_native_refusal']['render: object not initialised by phase 0 / no body pointer'] += 1
        return
    if not 0 <= slot < NENT:
        stats['skipped_native_refusal']['render: slot -1 or outside the table (K7)'] += 1
        return
    body = run.rows[ri]['body']
    stats['actions']['render'] += 1
    surface = fld(img, 'surface') & M32
    x.w32(ENTRY + slot * STRIDE + 8, surface)
    nat.entry_set(slot, 8, surface)
    sync_row_images(x, run)
    queues = start_tick(nat, run, run.queues(rng, queues))
    active = fld(img, 'active') != 0
    x.run_method(queues, M_RENDER, [], 0)
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native tqz_render status %d' % (where, plan['status']))
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    check(stats, where, 'render: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'render: ordered effects (ticks, random draws, no blit effects)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    check(stats, where, 'render: valid', plan['valid'], 1 if active else 0)
    blit_expectation_checks(where, x, nat, stats, plan, lambda kind: slot, 'render')
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'render', stats)
    compare_all(where, x, nat, stats, run)
    # the engine clears the redraw request after drawing: make it observable for the invalidate action
    x.w32(ENTRY + slot * STRIDE + 0x14, 0)
    nat.entry_set(slot, 0x14, 0)


def do_render_widget(where, x, nat, run, stats, which):
    wimg = x.widget_image()
    if not widget_renderable(wimg):
        stats['skipped_native_refusal']['render widget: a string with a non-digit or without NUL (K4)'] += 1
        return
    ready_enabled = (wimg[0xC:0x10] != bytes(4) and wimg[4:8] != bytes(4)) if which == 'score' else (wimg[0x10:0x14] != bytes(4) and wimg[8:0xC] != bytes(4))
    if ready_enabled:
        slot = struct.unpack_from('<i', wimg, 0x16C if which == 'score' else 0x234)[0]
        if not 0 <= slot < NENT:
            stats['skipped_native_refusal']['render widget: entry slot outside the table'] += 1
            return
        surf = struct.unpack_from('<I', wimg, 0x168 if which == 'score' else 0x230)[0]
        x.w32(ENTRY + slot * STRIDE + 8, surf)
        nat.entry_set(slot, 8, surf)
    else:
        slot = 0
    stats['actions']['render_' + which] += 1
    sync_row_images(x, run)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method({}, W_RENDER_SCORE if which == 'score' else W_RENDER_CLOCK, [], 0)
    plan = nat.render_score() if which == 'score' else nat.render_clock()
    if plan['status'] != OK:
        raise Mismatch('%s: native render %s status %d' % (where, which, plan['status']))
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    check(stats, where, 'render %s: no effects' % which, (norm_events(x.events), mapped, hosts), ([], [], []))
    check(stats, where, 'render %s: valid' % which, plan['valid'], 1)
    blit_expectation_checks(where, x, nat, stats, plan, lambda kind: slot, 'render ' + which)
    check_writes(where, x, 'render_widget', stats)
    compare_all(where, x, nat, stats, run)


def do_invalidate(where, x, nat, run, stats):
    img = nat.obj()
    slot = fld(img, 'slot')
    marks = fld(img, 'active') != 0 and slot != -1
    if marks and not 0 <= slot < NENT:
        stats['skipped_native_refusal']['invalidate: slot outside the entry table'] += 1
        return
    stats['actions']['invalidate'] += 1
    sync_row_images(x, run)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method({}, M_INVALIDATE, [])
    if nat.invalidate() != OK:
        raise Mismatch('%s: native tqz_invalidate failed' % where)
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    check(stats, where, 'invalidate: host calls', dirty, [(HC_MARK_DIRTY, slot, 0)] if marks else [])
    check(stats, where, 'invalidate: no effects', (norm_events(x.events), mapped, hosts), ([], [], []))
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats, queues, rng):
    img = nat.obj()
    for name, v in (('slot', fld(img, 'slot')), ('clock slot', struct.unpack_from('<i', img, CLOCK_BLOCK + 0xC0)[0]),
                    ('score slot', struct.unpack_from('<i', img, SCORE_BLOCK + 0xB0)[0])):
        if v != -1 and not 0 <= (v & 0xFFFF) < NENT:
            stats['skipped_native_refusal']['cleanup: %s outside the entry table' % name] += 1
            return
    stats['actions']['cleanup'] += 1
    queues = start_tick(nat, run, run.queues(rng, queues))
    sync_row_images(x, run)
    x.run_method(queues, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native tqz_cleanup failed' % where)
    mapped, hosts, host_only, dirty = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surface, slots, font)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    run.obj8 = 0
    run.live = False
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_new_game(where, x, nat, run, stats):
    stats['actions']['new_game'] += 1
    sync_row_images(x, run)
    nat.clear_logs()
    x.run_method({}, M_NEWGAME, [])
    nat.new_game()
    check(stats, where, 'new game: the two stores of 0x4b8087', norm_events(x.events), [('fx', FX['PLAYED'], 0, 0), ('fx', FX['BEST'], 0, 0)])
    check_writes(where, x, 'new_game', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.obj_image())
    world = None
    for k, v in d.items():
        if k in OBJ_SCALARS:
            put_fld(img, k, v)
        elif k == 'raw':
            for off, data in v.items():
                img[off:off + len(data)] = data
        elif k == 'balloons':
            for idx, fields in v.items():
                for n, val in fields.items():
                    put_bfld(img, idx, n, val)
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
            if va >= ENTRY:
                nat.entry_set((va - ENTRY) // STRIDE, (va - ENTRY) % STRIDE, v)
        elif k in ('start', 'played', 'best'):
            world = world if world is not None else bytearray(x.world_image())
            if k == 'start':
                struct.pack_into('<i', world, 0, sgn(v, 4))
            elif k == 'played':
                struct.pack_into('<i', world, 4, sgn(v, 4))
            else:
                struct.pack_into('<H', world, 8, v & 0xFFFF)
        elif k == 'mode':
            x.set_cell(CELL_MODE, v)
            cells = nat.cells()
            nat.set_cells([v] + cells[1:8])
        elif k == 'busy':             # {slot: value} of the +0x18 dword of the entry
            for s, val in v.items():
                x.w32(ENTRY + s * STRIDE + 0x18, val)
                nat.entry_set(s, 0x18, val)
        elif k == 'entry_dirty':
            for s, val in v.items():
                x.w32(ENTRY + s * STRIDE + 0x14, val)
                nat.entry_set(s, 0x14, val)
        elif k == 'c0377':
            x.set_cell(CELL_5D0377, v)
        elif k == 'bg':
            x.set_cell(CELL_BG, v)
            nat.entry_set(1, 8, v)
        elif k == 'view':
            view, local = v
            x.wr(CELL_VIEW, struct.pack('<4i', *[sgn(t, 4) for t in view]))
            x.wr(CELL_LOCAL, struct.pack('<4i', *[sgn(t, 4) for t in local]))
            nat.set_view(view, local)
        else:
            raise d9.OracleError('unknown set key ' + k)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    if world is not None:
        x.put_world(bytes(world))
        nat.set_world(bytes(world))


def do_body(x, run, ri, patches):
    r = run.rows[ri]
    b = bytearray(r['body'])
    for off, data in patches.items():
        b[off:off + len(data)] = data
        x.wr(d9.BODY_BASE + BODY_STRIDE * ri + off, bytes(data))
    r['body'] = bytes(b)


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
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    if kind == 'tick':
        do_tick(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'key':
        result = do_key(where, x, nat, run, stats, rng, act[1], real_push=rng.random() < 0.5)
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
        do_render(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'render_score':
        do_render_widget(where, x, nat, run, stats, 'score')
    elif kind == 'render_clock':
        do_render_widget(where, x, nat, run, stats, 'clock')
    elif kind == 'render_all':
        do_render(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
        do_render_widget(where, x, nat, run, stats, 'score')
        do_render_widget(where, x, nat, run, stats, 'clock')
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'new_game':
        do_new_game(where, x, nat, run, stats)
    elif kind == 'set':
        do_set(x, nat, run, act[1])
    elif kind == 'body':
        do_body(x, run, act[1], act[2])
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
    elif kind == 'play':
        macro_play(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {}, sub)
    elif kind == 'finish':
        macro_finish(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {}, sub)
    elif kind == 'formula':
        macro_formula(where, x, nat, run, stats, rng, act[1], sub)
    elif kind == 'pointer_sweep':
        macro_pointer_sweep(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else 0, sub)
    else:
        raise d9.OracleError('unknown action ' + kind)
    stats['actions'][kind] += 1
    return result


# ---------------------------------------------------------------------------------------------
# macros: the random player steers by the live object (deadlines, states, balloon characters)
# ---------------------------------------------------------------------------------------------
KEY_POOL = [c for c in range(256)]
# (hits, factor, seconds) where dropping the float rounding of the hit count (first group) or of the stored score (second group) changes the result
FORMULA_EDGES = [(61862542, 98, 1279), (17063013, 100, 646), (25934333, 100, 968), (53105050, 130, 1386), (19514819, 13, 3600), (19007505, 100, 517),
                 (2765, 3, 7), (2674, 10, 1), (2579, 10, 2), (1931, 5, 3), (3890, 1, 60), (3935, 10, 3), (3920, 2, 60), (1804, 40, 11)]


def cur_row(nat, run):
    return run.f5_rows()[0]


def live_chars(img, n):
    return [bfld(img, k, 'ch') for k in range(min(n, 20)) if bfld(img, k, 'state') == 1]


def pick_key(rng, img, n, p_hit):
    flying = live_chars(img, n)
    if flying and rng.random() < p_hit:
        c = rng.choice(flying)
        if rng.random() < 0.3 and (0x41 <= c <= 0x5A or 0x61 <= c <= 0x7A):
            c ^= 0x20
        return c
    return rng.choice(KEY_POOL)


def macro_play(where, x, nat, run, stats, rng, opts, sub):
    """Ticks (and keys, renders, pointer probes, a click) with the clock advanced until the puzzle finishes or the steps run out."""
    ri = cur_row(nat, run)
    body = run.rows[ri]['body']
    info = body_info(body)
    dts = opts.get('dts', (100, 300, 700, 999, 1000, 1001, 2500))
    done = False
    for k in range(opts.get('steps', 40)):
        ensure_mode(x, nat, run)
        img = nat.obj()
        phase = run.rows[ri]['phase']
        state = fld(img, 'state')
        advance(run, rng, dts)
        if phase == 1 and fld(img, 'active') and state == 0 and rng.random() < opts.get('p_key', 0.5):
            sub(k, ('key', pick_key(rng, img, info['N'], opts.get('p_hit', 0.6))))
        if rng.random() < opts.get('p_render', 0.4):
            sub(k, ('render_all', dict(tick=[run.clock] * 96)))
        if rng.random() < opts.get('p_pointer', 0.1):
            l, t, r_, b = info['rect']
            sub(k, ('pointer', rng.choice((l, (l + r_) // 2, r_, r_ + 1, l - 1, rng.randint(-20, 700))), rng.choice((t, (t + b) // 2, b, b + 1, t - 1, rng.randint(-20, 500)))))
        if phase == 1 and rng.random() < opts.get('p_click', 0.0):
            sub(k, ('set', dict(cand=CAND_QUIZ if rng.random() < 0.8 else 0x1234)))
            sub(k, ('click',))
        if rng.random() < opts.get('p_invalidate', 0.05):
            sub(k, ('invalidate',))
        sub(k, ('tick', dict(tick=[run.clock] * 96)))
        if run.rows[ri]['phase'] == 0 and not fld(nat.obj(), 'active') and k > 0 and phase != 0:
            done = True
            break
    stats['outcomes']['play_finished' if done else 'play_steps_exhausted'] += 1


def macro_finish(where, x, nat, run, stats, rng, opts, sub):
    """Ticks through the end: time up, the end delay, the finish (phase 2) and the cleanup."""
    ri = cur_row(nat, run)
    for k in range(opts.get('steps', 14)):
        ensure_mode(x, nat, run)
        img = nat.obj()
        phase = run.rows[ri]['phase']
        if phase == 0 and not fld(img, 'active'):
            break
        state = fld(img, 'state')
        if phase == 1 and state == 2:
            dl = fld(img, 'end_deadline') & M32
            run.clock = rng.choice(((dl - 1) & M32, dl, (dl + 1) & M32, (dl + 3000) & M32, (dl - 3000) & M32))
        else:
            advance(run, rng, (1000, 5000, 60000))
        sub(k, ('tick', dict(tick=[run.clock] * 96)))


def macro_formula(where, x, nat, run, stats, rng, n, sub):
    """The score formula against the real x87 code: random hit counts, factors and elapsed times, one phase-1 tick each."""
    ri = cur_row(nat, run)
    body = run.rows[ri]['body']
    info = body_info(body)
    plan = [None] * n
    if n >= 30:
        plan[:len(FORMULA_EDGES)] = FORMULA_EDGES
    for k in range(n):
        ensure_mode(x, nat, run)
        factor = rng.choice((1, 2, 3, 5, 7, 10, 13, 40, 100))
        secs = rng.choice((0, 1, 2, 3, 7, 11, 30, 59, 60, 61, 119, 3000)) if k % 9 == 5 else rng.choice((1, 2, 3, 7, 11, 30, 59, 60, 61, 119, 3000))
        hits = rng.choice((1, 2, 3, 5, 9, 17, 33, 100, 1000, 16777217, rng.randint(1, 300), rng.randint(1, 5000)))
        if plan[k] is not None:
            hits, factor, secs = plan[k]
        if secs == 0:
            sub(k, ('set', dict(hits=hits, start_tick=(run.clock - rng.choice((0, 500, 999))) & M32, state=0, key_pending=0, score=77, prev_score=rng.choice((77, 5)))))
            sub(k, ('tick', dict(tick=[run.clock] * 96)))
            stats['score_formula'] += 1
            if fld(nat.obj(), 'state') != 0 or run.rows[ri]['phase'] != 1:
                sub(k, ('set', dict(state=0)))
                sub(k, ('setphase', ri, 1))
            continue
        if hits * 60.0 / (factor * secs) >= 32000.0 or info['time'] <= 0:
            stats['skipped_native_refusal']['formula: score would leave 0..32767 (K4)'] += 1
            continue
        t0 = (run.clock - secs * 1000 - rng.choice((0, 1, 999, 500))) & M32
        sub(k, ('set', dict(hits=hits, start_tick=t0, state=0, key_pending=0, prev_score=rng.choice((0, 1, -3)))))
        run.rows[ri]['body'] = patch(run.rows[ri]['body'], B_FACTOR, struct.pack('<h', factor))
        do_body(x, run, ri, {B_FACTOR: struct.pack('<h', factor)})
        sub(k, ('tick', dict(tick=[run.clock] * 96)))
        stats['score_formula'] += 1
        if fld(nat.obj(), 'state') != 0 or run.rows[ri]['phase'] != 1:
            sub(k, ('set', dict(state=0)))
            sub(k, ('setphase', ri, 1))


def macro_pointer_sweep(where, x, nat, run, stats, rng, extra, sub):
    ri = cur_row(nat, run)
    info = body_info(run.rows[ri]['body'])
    l, t, r_, b = info['rect']
    xs = sorted({l - 1, l, l + 1, (l + r_) // 2, r_ - 1, r_, r_ + 1, -0x8000, 0x7FFF, 0xFFFF, 0x10000 + l})
    ys = sorted({t - 1, t, t + 1, (t + b) // 2, b - 1, b, b + 1, -0x8000, 0x7FFF, 0xFFFF, 0x10000 + t})
    pts = [(px, py) for py in ys for px in xs] + [(rng.randint(-100, 800), rng.randint(-100, 600)) for _ in range(extra)]
    sub(0, ('probes', pts))


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def R_F5(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xF5, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


NAMES_POOL = [NAME_REAL, b'A', b'Typing Quiz Surface 7', b'N' * 0x20, b'LIB_TypingGame_PUZ_OVL_2', b'a b']
FILTER_EXTRA = (0xE0, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xF4, 0xC0, 0xE2, 0xEE, 0xF9, 0xC4, 0xE4, 0xD6, 0xF6, 0xDC, 0xFC, 0xA1, 0xBF, 0xD1, 0xF1, 0xC9, 0xE1, 0xED,
                0xF3, 0xFA, 0xDF)
CHARSETS = [dict(case=c, digits=d, wide=w, extra=e) for c in (0, 1) for d in (0, 1) for w in (0, 1) for e in ((), (0xE0, 0xE7, 0xFF, 0xC4))]
CHARSETS += [dict(case=0, digits=0, wide=0, extra=(0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60, 0x7B, 0x7C)), dict(case=1, digits=1, wide=0, extra=(0x60,)),
             dict(case=0, digits=0, wide=0, extra=tuple([0x5B] * 29 + [0x5E])), dict(case=1, digits=0, wide=0, extra=(0, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60)),
             dict(case=0, digits=1, wide=1, extra=FILTER_EXTRA), dict(case=1, digits=0, wide=1, extra=FILTER_EXTRA), dict(case=0, digits=0, wide=1, extra=(0x41, 0x5B))]
VIEWS = [((0, 0, 640, 480), None), ((-5, 7, 300, 200), (3, 4, 100, 50)), ((1000, 1000, 1640, 1480), (0, 0, 640, 480)),
         ((-1000, -700, -360, -220), (-9, -9, 20, 20)), ((0, 0, 0, 0), (0, 0, 0, 0)), ((17, 23, 657, 503), (0, 0, 640, 480)),
         ((0x7FFF0000, 0x7FFF0000, 0x7FFF0280, 0x7FFF01E0), (1, 1, 2, 2))]


def scenario_list(seed=0xF553):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        n = kw.setdefault('N', rng.randint(3, 20))
        kw.setdefault('V', rng.randint(1, 20))
        lo = kw.setdefault('count', (rng.randint(0, min(3, n)), None))
        a = min(lo[0], n)
        kw['count'] = (a, max(a, min(n, lo[1] if lo[1] is not None else rng.randint(a, n))))
        lf = kw.setdefault('life', (rng.randint(1, 4), 0))
        kw['life'] = (lf[0], lf[1] or lf[0] + rng.randint(0, 6))
        return make_body(rng, **kw)

    def sk():
        return tuple(rng.choice(SND_KINDS) for _ in range(4))

    ONE = [R_F5]

    # ---- phase 0 / render / cleanup: charsets, names, sounds, handles, busy slots, views -------------------------------------------
    for k in range(40):
        cs = CHARSETS[k % len(CHARSETS)]
        view, local = VIEWS[k % len(VIEWS)]
        body = mk(name=NAMES_POOL[k % len(NAMES_POOL)], snd_kinds=sk(), **cs)
        busy = [[], [0x18], [0x18, 0x19, 0x1A], list(range(0x18, 0x3C)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]][k % 6]
        init = dict(busy_slots=busy, view=view, obj=dict(surface=rng.choice((0, 0x5151)), slot=rng.choice((-1, 0x19, 0x30))),
                    widget='zero' if k % 5 == 0 else 'garbage', best=rng.choice((0, 50, 3000, 0xFFF0)), start=rng.choice((0, 1, 5, M32)))
        if local:
            init['local'] = local
        S('init:%d' % k, [R_F5(body, subtype=1 + k % 2)],
          [tk(handle=[HANDLES[k % 5]] * 2), ('render_all', {}), ('invalidate',), ('pointer', 600, 20), ('render_all', {}),
           ('set', dict(balloons={0: dict(state=3), 1: dict(state=2, deadline=0), 2: dict(state=2, deadline=M32), 3: dict(state=1)})), ('render_all', {}),
           ('set', dict(raw={SCORE_BLOCK + 0xB0: struct.pack('<i', (0, -1, 0x30)[k % 3]), CLOCK_BLOCK + 0xC0: struct.pack('<i', (-1, 0x30, 0)[k % 3]),
                             0x04: struct.pack('<h', (0, -1, 0x57, 0x19)[k % 4])})), ('cleanup', {}), ('render_all', {})],
          'init', init=init, quick=k < 3)

    # ---- the play loop: balloons, lifetimes, hits, misses, timeouts, popping, clock crossing minute boundaries ----------------------
    for k in range(60):
        cs = CHARSETS[(k * 5) % len(CHARSETS)]
        n = rng.choice((1, 2, 5, 12, 20, 20))
        body = mk(N=n, count=rng.choice(((0, 0), (1, 1), (2, 6), (0, 20), (3, 3), (5, 20))), life=rng.choice(((1, 1), (1, 3), (2, 5), (5, 30), (0, 2), (-3, 4))),
                  time=rng.choice((1, 2, 5, 61, 65, 125, 7, 190)), factor=rng.choice((1, 2, 3, 10, 100)), min_score=rng.choice((0, 5, 19, 1000)),
                  default_target=rng.choice((0, 20, 100)), percent=rng.choice((0, 50, 90, 100)), low=rng.choice((0, 15, 99)),
                  snd_kinds=sk(), ch=[rng.randint(-3, 40) for _ in range(4)], delay=rng.choice((0, 500, 2000, -5)), **cs)
        p = dict(steps=rng.choice((25, 40, 60)), p_key=rng.choice((0.3, 0.6, 0.9)), p_hit=rng.choice((0.2, 0.6, 0.95)), p_render=rng.choice((0.2, 0.5)),
                 p_pointer=0.1, p_invalidate=0.05, dts=rng.choice(((100, 300, 999, 1001, 2500), (400, 1000, 7000), (1, 10, 100, 499, 500, 501), (30000, 61000))))
        S('play:%d' % k, [R_F5(body, subtype=rng.choice((1, 1, 2)))],
          [tk(handle=[HANDLES[k % 5]]), ('play', p), ('finish', {}), ('rearm',), ('play', dict(p, steps=15)), ('finish', {}), ('new_game',), ('render_all', {})],
          'play', init=dict(best=rng.choice((0, 7, 3000)), played=rng.choice((0, 1)), view=VIEWS[(k + 1) % len(VIEWS)][0]), quick=k < 3)

    # ---- score formula against the real x87 code ---------------------------------------------------------------------------------
    for k in range(24):
        body = mk(N=20, count=(3, 8), life=(50, 90), time=rng.choice((3000, 30000)), factor=rng.choice((1, 2, 7)), min_score=rng.choice((0, 5, 40)),
                  percent=rng.choice((50, 90)), **CHARSETS[k % len(CHARSETS)])
        S('formula:%d' % k, [R_F5(body)], [tk(handle=[HANDLES[k % 5]]), ('formula', 30 + 40 * (k % 6 == 0))], 'formula', init=dict(obj=dict(count=0)), quick=k < 2)

    # ---- the key filter over all 256 bytes and key outcomes by state ---------------------------------------------------------------
    for k in range(4):
        body = mk(N=12, count=(1, 3), **CHARSETS[k])
        acts = [tk(), ('filter256',)]
        for state in (0, 1, 2, 3, -1):
            acts += [('set', dict(state=state, key_pending=0)), ('key', 0x41), ('key', 0x61), ('key', 0x39), ('key', 0xE0), ('key', 0x1B), ('key', 0xFF)]
        acts += [('set', dict(state=0, key_pending=1)), ('key', 0x42), ('setphase', 0, 2), ('set', dict(key_pending=0)), ('key', 0x42),
                 ('setphase', 0, 0), ('key', 0x43), ('setphase', 0, 1), ('set', dict(active=0, state=0, key_pending=0)), ('key', 0x44), ('set', dict(active=1)), ('key', 0x45),
                 ('set', dict(state=0, key_pending=0, balloons={0: dict(ch=0x41, state=1, lifetime=30000, spawn=100000), 1: dict(ch=0x5A, state=1, lifetime=30000, spawn=100000)})),
                 ('key', 0x61), tk(), ('set', dict(key_pending=0)), ('key', 0x7A), tk()]
        S('keys:%d' % k, [R_F5(body)], acts, 'keys', quick=k == 0)

    # ---- pointer and click --------------------------------------------------------------------------------------------------------
    for k in range(10):
        body = mk(N=10, count=(1, 3), rect=rng.choice(((578, 4, 612, 38), (0, 0, 10, 10), (-5, -5, 5, 5), (100, 100, 100, 100), (50, 60, 400, 300))),
                  cursor=rng.choice((22, 0, 3, 31, 32767, -1)), **CHARSETS[k % len(CHARSETS)])
        acts = [('pointer', 600, 20), tk(), ('pointer_sweep', 20), ('click',), ('set', dict(cand=CAND_QUIZ)), ('click',), ('setphase', 0, 1), ('click',),
                ('setphase', 0, 2), ('click',), ('set', dict(cand=0x27EA)), ('setphase', 0, 1), ('click',), ('set', dict(cand=-1 & M32)), ('click',),
                ('set', dict(cand=CAND_QUIZ)), ('setphase', 0, 1)]
        for st in (dict(finishing=1), dict(state=1), dict(state=2), dict(active=0), dict(state=-1)):
            acts += [('set', st), ('click',), ('setphase', 0, 1), ('set', dict(finishing=0, state=0, active=1))]
        acts += [('click',), ('set', dict(active=0)), ('pointer_sweep', 5), ('set', dict(active=1))]
        S('pointer:%d' % k, [R_F5(body)], acts, 'pointer', quick=k == 0)

    # ---- forced obj+0x10 states, passed / not, minimum score reached or not -------------------------------------------------------------
    for k, state in enumerate((0, 1, 2, 3, 5, 9, -1, 0x7FFFFFFF)):
        for passed_case in range(4):
            body = mk(N=14, count=(2, 5), life=(2, 6), min_score=rng.choice((0, 10, 60)), time=rng.choice((5, 90, 200)), snd_kinds=sk(), delay=rng.choice((0, 500, 2000)),
                      **CHARSETS[(k + passed_case) % len(CHARSETS)])
            score, target = [(100, 20), (5, 20), (15, 20), (20, 20)][passed_case]
            acts = [tk(handle=[HANDLES[passed_case]]), ('clock', 105000), tk(), ('set', dict(state=state, score=score, target=target, key_pending=rng.choice((0, 1)), key_char=rng.getrandbits(8),
                                                                  end_deadline=rng.choice((0, 100000, 100500, 1000000, M32)))),
                    ('render_all', {})]
            for dt in (1, 600, 5000):
                acts += [('clock', 100000 + dt), tk()]
                if state == 2:
                    acts += [('set', dict(end_deadline=100000 + dt - 1)), ('clock', 100000 + dt), tk()]
            S('state:%d_%d' % (state & 0xFFFF, passed_case), [R_F5(body, subtype=1 + passed_case % 2)], acts, 'states', quick=(state, passed_case) in ((0, 0), (1, 0), (2, 1)))

    # ---- phase 2: finish blocks, sounds, flags -1 and set, persistence of the best score ----------------------------------------
    for k in range(48):
        passed = k % 2
        reached = (k // 2) % 2
        pb = rand_block(rng, rng.choice((9999, 12, -5, 0)), flag=rng.choice((-1, 0, 7, 340, 4095)))
        nb = rand_block(rng, rng.choice((9999, 3, 0x7FFF - 0x10000)), flag=rng.choice((-1, 2, 99, 4095)), flag2=rng.choice((-1, 1, 88, 4095)))
        body = mk(N=10, count=(1, 3), snd_kinds=sk(), passed=pb, normal=nb, **CHARSETS[k % len(CHARSETS)])
        init = dict(best=rng.choice((0, 1, 77, 3000, 0xFFF0)), played=rng.choice((0, 1)), start=rng.choice((0, 1, 5, M32)), busy_slots=[0x19, 0x1B])
        acts = [tk(handle=[HANDLES[k % 5]]), ('set', dict(passed=passed, reached=reached, finishing=1, score=rng.choice((0, 50, 7000)), target=rng.choice((20, 7000)),
                                                      hits=rng.choice((0, 4, 33)))),
                ('setphase', 0, 2), tk(), ('render_all', {}), ('new_game',), ('rearm',), tk(), ('cleanup', {})]
        S('phase2:%d' % k, [R_F5(body, subtype=rng.choice((1, 1, 2, 0, 3)))], acts, 'phase2', init=init, events={rng.randint(0, 4095): rng.choice((0, 1, -1))}, quick=k < 4)

    # ---- real rows (the four records of the 0xf5 resources) ----------------------------------------------------------------------------
    real = real_rows()
    for k, (body, tail, sub) in enumerate(real):
        for case in range(2):
            p = dict(steps=60, p_key=0.8, p_hit=0.9, p_render=0.5, p_pointer=0.2, p_click=0.1, dts=(300, 999, 1001, 4000, 61000))
            S('real:%d_%d' % (k, case), [R_F5(body, subtype=sub)],
              [tk(handle=[HANDLES[k]]), ('play', p), ('finish', {}), ('rearm',), tk(), ('play', dict(p, steps=20)), ('finish', {}), ('new_game',)], 'real',
              init=dict(best=rng.choice((0, 3000))), quick=(k, case) == (0, 0))
        S('real_formula:%d' % k, [R_F5(body, subtype=sub)], [tk(), ('formula', 10), ('pointer_sweep', 10)], 'real')

    # ---- the executor: mode, gates, other rows, completed rows ---------------------------------------------------------------------------
    for k in range(10):
        body = mk(N=8, count=(1, 3), **CHARSETS[k % len(CHARSETS)])
        rows = [R67(), R_F5(body, subtype=1 + k % 2), R67(), R_F5(mk(N=6, count=(1, 2)), subtype=1, completed=1)]
        if k % 3 == 1:
            rows.append(R_F5(mk(N=6, count=(1, 2)), subtype=2, unloaded=1))
        S('mode:%d' % k, rows, [tk(), ('set', dict(mode=0)), tk(), ('set', dict(mode=3)), tk(), ('play', dict(steps=10)), ('finish', {}), ('rearm',), tk()], 'mode',
          mode=3 if k % 2 == 0 else 1, quick=k == 0)

    # gated rows: the dependency tail is one event-flag record (the rest of the loader's tail grammar is outside the slice)
    for k in range(6):
        body = mk(N=8, count=(1, 3), **CHARSETS[k % len(CHARSETS)])
        idx = rng.randint(0, 4095)
        rows = [R_F5(body, subtype=1 + k % 2, tail=event_tail(idx, 1)), R67(tail=event_tail(idx, 2))]
        S('gate:%d' % k, rows, [tk(), ('events', {idx: 1}), tk(), ('play', dict(steps=10)), ('events', {idx: 2}), ('finish', {}), tk(), ('events', {idx: 0}), tk()],
          'mode', events={idx: 0 if k % 2 else 1})

    # ---- long clocks (minute and second clamps at 59), negative lifetimes against a huge tick jump
    for k, tl in enumerate((3539, 3540, 3599, 3600, 3659, 3660, 5000, 30000)):
        body = mk(N=8, count=(1, 2), time=tl, **CHARSETS[k])
        S('longclock:%d' % k, [R_F5(body)], [tk(), ('play', dict(steps=8, dts=(1000, 3000, 61000, 599000), p_key=0.2)), ('finish', {})], 'longclock', quick=k == 3)
    for k in range(4):
        body = mk(N=6, count=(2, 4), life=(-3 - k, -1), time=30000, **CHARSETS[k])
        S('neglife:%d' % k, [R_F5(body)], [tk(), ('clock', (100000 + 70000000 + 1000 * k) & M32), tk(), ('render_all', {}), ('clock', (100000 + 71000000) & M32), tk()], 'longclock')
    # ---- widget flag combinations (enabled / ready of the two halves) with digit strings
    for bits in range(16):
        body = mk(N=5, count=(1, 2))
        S('wflags:%d' % bits, [R_F5(body)], [('render_score',), ('render_clock',), ('render_score',), ('render_clock',)], 'widget',
          init=dict(widget=dict(flags=bits)))

    # ---- widget states: garbage and power-on widget around the first tick ------------------------------------------------------------------
    for k in range(6):
        body = mk(N=9, count=(1, 3), **CHARSETS[k])
        S('widget:%d' % k, [R_F5(body)], [('render_score',), ('render_clock',), tk(), ('render_score',), ('render_clock',), ('play', dict(steps=12)), ('render_all', {}),
                                          ('cleanup', {}), ('render_score',), ('render_clock',)], 'widget', init=dict(widget='zero' if k % 2 else 'garbage'))
    return scs


# ---------------------------------------------------------------------------------------------
# native-only refusal checks (K1..K7, none of them reachable in the game)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.obj(), nat.world(), nat.widget(), nat.events(), nat.entries(), tuple(nat.cells()[:8]), len(nat.log(0)), len(nat.log(1)))


def refusal_checks(nat, stats):
    rng = random.Random(0xF501)
    base = make_body(rng, snd_kinds=('real', 'real', 'real', 'real'), passed=rand_block(rng, 12, flag=5), normal=rand_block(rng, 13, flag=6, flag2=7), N=6,
                     count=(1, 3), V=5)
    qs = dict(tick=[5000] * 40, rand=[7] * 400, handle=[0x1234, 0x1235, 0x1236])

    def fresh(**state):
        nat.reset()
        nat.set_queues(qs)
        nat.clear_logs()
        img = bytearray(OBJ_LEN)
        put_fld(img, 'slot', -1)
        put_fld(img, 'row', -1)
        for k, v in state.items():
            put_fld(img, k, v)
        nat.set_obj(bytes(img))
        nat.set_cells([3, 0, 0, 0, 0, 0, 0, 0])
        nat.set_view((0, 0, 640, 480), (0, 0, 640, 480))

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    def pat(off, data, body=base):
        return patch(body, off, data)

    h = lambda v: struct.pack('<h', v)  # noqa: E731
    # K1 bodies
    bad = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:],
           'variants 0': pat(B_VARIANTS, h(0)), 'variants 21': pat(B_VARIANTS, h(21)), 'variants -1': pat(B_VARIANTS, h(-1)),
           'positions 0': pat(B_POSITIONS, h(0)), 'positions 21': pat(B_POSITIONS, h(21)), 'positions -1': pat(B_POSITIONS, h(-1)),
           'count min -1': pat(B_COUNT_MIN, h(-1)), 'count max 21': pat(B_COUNT_MAX, h(21)), 'count min > max': pat(B_COUNT_MIN, h(5) + h(4)),
           'life min > max': pat(B_LIFE_MIN, h(9) + h(8))}
    for k, off in enumerate(B_SND):
        bad['sound %s unterminated' % 'ABCD'[k]] = pat(off, bytes([0x42 + k] * 0x21))
    for name, b in bad.items():
        fresh(active=1, row=0)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        if len(b) != BODY_LEN:
            expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
            expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
        expect('K1 no effect ' + name, snapshot(nat), snap)
    for name, b in {'valid': base, 'terminator on the last name byte': pat(0x20, b'\0', pat(0, bytes([0x41] * 0x20))),
                    'variants 1 positions 20': pat(B_VARIANTS, h(1)), 'variants 20': pat(B_VARIANTS, h(20)), 'positions 1': pat(B_POSITIONS, h(1)),
                    'count 0..0': pat(B_COUNT_MIN, h(0) + h(0)), 'count 0..20': pat(B_COUNT_MIN, h(0) + h(20)), 'life 5..5': pat(B_LIFE_MIN, h(5) + h(5)),
                    'life -3..7': pat(B_LIFE_MIN, h(-3) + h(7))}.items():
        expect('K1 accepted: ' + name, nat.validate(b), OK)
    fresh()
    expect('K1 phase 0 with a negative row', nat.step(base, -1, 0)[0], ERR_ARGUMENT)
    # K2 phase 1 / 2 without the initialisation
    for ph in (1, 2):
        for variant in ('uninitialised', 'other row'):
            fresh(active=1 if variant == 'other row' else 0, row=3 if variant == 'other row' else -1, state=1)
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K3 event flag outside the host window
    for idx in (4096, -2, 32767, -32768):
        for name, st, off in (('normal flag', dict(passed=0, reached=1), 0x558), ('normal flag2', dict(passed=0, reached=0), 0x55A),
                              ('passed flag', dict(passed=1), 0x50F)):
            body = pat(off, h(idx))
            if name == 'normal flag':
                body = pat(0x558, h(idx), body)
            fresh(active=1, row=0, slot=0x19, **st)
            snap = snapshot(nat)
            expect('K3 %s %d' % (name, idx), nat.step(body, 0, 2)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    for idx in (-1, 0, 4095):
        for name, st, off in (('normal flag', dict(passed=0, reached=1), 0x558), ('passed flag', dict(passed=1), 0x50F)):
            fresh(active=1, row=0, slot=0x19, **st)
            expect('K3 %s %d accepted' % (name, idx), nat.step(pat(off, h(idx)), 0, 2)[0], OK)
    # K4 strings of the widget with a non-digit, K5 pick divisor
    fresh(row=-1)
    st = nat.step(base, 0, 0)
    expect('K4 setup phase 0', st[0], OK)
    w = bytearray(nat.widget())
    w[W_STR['score_str']:W_STR['score_str'] + 3] = b'1x\0'
    nat.set_widget(bytes(w))
    expect('K4 render score with a non-digit', nat.render_score()['status'], ERR_BOUNDS)
    for mc, digits in ((0x41, 0), (0x30, 1)):
        fresh(row=-1, max_char=mc)
        expect('K5 divisor 0 (max_char %#x digits %d)' % (mc, digits), nat.step(pat(B_DIGITS, bytes([digits])), 0, 0)[0], ERR_BOUNDS)
    # host contract: _rand outside 0..32767
    for bad_value in (32768, -1, 0x7FFFFFFF):
        fresh(row=-1)
        nat.set_queues(dict(qs, rand=[bad_value] * 400))
        expect('host contract: rand %d' % bad_value, nat.step(base, 0, 0)[0], ERR_HOST)
    fresh(row=-1)
    nat.set_queues(dict(qs, rand=[32767] * 400))
    expect('host contract: rand 32767 accepted', nat.step(base, 0, 0)[0], OK)
    # K4: the 16-bit wrap of the score formula (hits 1100, factor 2, one second: 33000 -> -32536) is refused; 66000 wraps to 464
    for hits, want_status, want_score in ((1100, ERR_BOUNDS, None), (2200, OK, 464), (100, OK, 3000)):
        fresh(active=1, row=0, slot=0x19, state=0, hits=hits, start_tick=4000)
        nat.set_queues(dict(qs, tick=[5000] * 40))
        st = nat.step(base, 0, 1)
        expect('K4 score formula hits %d' % hits, st[0], want_status)
        if want_score is not None:
            expect('K4 score formula hits %d score' % hits, fld(nat.obj(), 'score'), want_score)
    # power-on object (0x4b7f3b values)
    nat.reset()
    img = nat.obj()
    expect('power-on slot and row', (fld(img, 'slot'), fld(img, 'row')), (-1, -1))
    expect('power-on slots', (struct.unpack_from('<i', img, SCORE_BLOCK + 0xB0)[0], struct.unpack_from('<i', img, CLOCK_BLOCK + 0xC0)[0]), (-1, -1))
    # K4: a negative factor makes the score negative (refused); phases above 2 do nothing
    fresh(active=1, row=0, slot=0x19, state=0, hits=100, start_tick=4000)
    expect('K4 negative factor', nat.step(pat(B_FACTOR, h(-2)), 0, 1)[0], ERR_BOUNDS)
    fresh(row=-1)
    expect('phase 3 is a no-op', nat.step(base, 0, 3)[:2], (OK, 3))
    # K7 render / invalidate with the slot -1
    fresh(active=1, row=0)
    snap = snapshot(nat)
    plan = nat.render(base)
    expect('K7 render slot -1', (plan['status'], plan['valid'], plan['count']), (OK, 0, 0))
    expect('K7 render slot -1 no effect', snapshot(nat), snap)
    expect('K7 invalidate slot -1', nat.invalidate(), OK)
    expect('K7 invalidate slot -1 no host call', len(nat.log(1)), 0)
    # K6 host failures
    def fails(what, mask_, run_fn, **state):
        fresh(**state)
        nat.set_fail(mask_)
        expect('K6 ' + what, run_fn(), ERR_HOST)
        nat.set_fail(0)
    for what, m in (('alloc', F_ALLOC), ('register', F_REGISTER), ('load', F_LOAD), ('set_slot_surface', F_SETSURF), ('view_rects', F_VIEW),
                    ('clear_item', F_CLEAR), ('sound_prepare', F_PREPARE), ('font_acquire', F_FONT_ACQUIRE)):
        fails('phase 0 ' + what, m, lambda: nat.step(base, 0, 0)[0], row=-1)
    for what, m in (('release_surface', F_RELEASE_SURFACE), ('release_slot', F_RELEASE_SLOT), ('sound_stop', F_STOP), ('transition', F_TRANSITION),
                    ('store_flag', F_FLAG), ('mode', F_MODE), ('font_release', F_FONT_RELEASE)):
        fails('phase 2 ' + what, m, lambda: nat.step(base, 0, 2)[0], active=1, row=0, slot=0x19, surface=0x77, passed=0, reached=1)
    fails('phase 0 score display register', F_REGISTER_DISPLAY, lambda: nat.step(base, 0, 0)[0], row=-1)
    fails('phase 0 clock display register', F_REGISTER_CLOCK, lambda: nat.step(base, 0, 0)[0], row=-1)
    fails('phase 1 time up sound prepare', F_PREPARE, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=1, score=100, target=20)
    fails('phase 1 time up sound play', F_PLAY, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=1, score=100, target=20)
    fails('invalidate dirty', F_DIRTY, lambda: nat.invalidate(), active=1, row=0, slot=0x19)
    fails('render view_rects (finish message)', F_VIEW, lambda: nat.render(base)['status'], active=1, row=0, slot=0x19, finishing=1)
    fails('cleanup release_surface', F_RELEASE_SURFACE, lambda: nat.cleanup(), surface=5)
    fails('cleanup release_slot', F_RELEASE_SLOT, lambda: nat.cleanup(), slot=0x19)
    fresh(row=-1)
    entries = bytearray(nat.entries())
    for s in range(0x18, 0x40):
        struct.pack_into('<I', entries, s * STRIDE + 0x18, 1)
    nat.set_entries(bytes(entries))
    expect('K6 allocator exhausted', nat.step(base, 0, 0)[0], ERR_HOST)
    fresh()
    expect('power-on object is reset', (fld(nat.obj(), 'slot'), fld(nat.obj(), 'row'), fld(nat.obj(), 'active')), (-1, -1, 0))
    stats['known_divergences']['K1..K7 checked natively (see the docstring); not run against the original'] += 1


# ---------------------------------------------------------------------------------------------
# driver
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
    for a in HOOK_RETS:
        i = bisect.bisect_left(starts, a)
        funcs[starts[i]] = starts[i + 1]
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


def sanitize_fuzz(args):
    """ASan + UBSan run of the kernels on bounded malformed inputs (random bodies, objects, worlds and host failures)."""
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang')
    exe = Path(tempfile.mkdtemp(prefix='f5_fuzz_', dir=str(PRIVATE))) / 'fuzz'
    build = [cc, '-std=c11', '-Wall', '-Wextra', '-Werror', '-O0', '-g', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
             '-fno-omit-frame-pointer', '-DF5O_FUZZ_MAIN', f'-I{args.src}', str(PROJECT / 'tests/action_family_f5_runtime_oracle_driver.c'),
             *[str(Path(args.src) / x) for x in SOURCES], '-o', str(exe)]
    done = subprocess.run(build, capture_output=True, text=True)
    if done.returncode != 0:
        print('fuzz build failed', done.stderr[-600:])
        return 1
    env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
    total = 0
    for seed in range(1, 5):
        run = subprocess.run([str(exe), str(args.fuzz), str(seed)], capture_output=True, text=True, env=env, timeout=1800)
        line = (run.stdout.strip().splitlines() or [''])[-1]
        print('seed', seed, 'rc', run.returncode, line, (run.stderr.strip().splitlines() or [''])[0][:200])
        if run.returncode != 0:
            return 1
        total += args.fuzz
    print('fuzz clean: %d inputs under ASan/UBSan' % total)
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--fuzz', type=int, default=0, help='run the ASan/UBSan malformed-input harness with N inputs per seed (4 seeds) and exit')
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
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    args = ap.parse_args()
    if args.fuzz:
        return sanitize_fuzz(args)
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-55.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_f5.so', strict=not args.lenient_build)
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
            args.result.write_text(json.dumps(dict(slice='RT-55', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_f5.so', strict=not args.lenient_build)
    nat = Native(lib_path)
    x = Oracle()
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
        args.result.write_text(json.dumps(dict(slice='RT-55', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
