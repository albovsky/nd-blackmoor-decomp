#!/usr/bin/env python3
"""RT-54: immutable x86 dispatcher 0x427a50 / handler 0x476a25 (raw 0xe4, the Match Puzzle), the object methods 0x475da4 (pointer, with its
inner 0x475fb1), 0x47608e (click), 0x4778df (render callback, with the text helper 0x475cc4), 0x4758e8 (invalidate), 0x475885 (cleanup, with
0x4757da), 0x47591f (scene reset of the high score table), and, through the handler, the fill 0x475a1e (with 0x475bef) and CheckForMatch
0x4763b3 versus the native kernel src/action_family_e4_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xe4 (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a3e9, the handler
0x476a25 with ECX = 0x622fa2 and every phase, all states of obj+0x2c (0..6, plus the values above 6 that fall out of the switch), the fill and
CheckForMatch it calls, the generic completion 0x42ba3a (subtype 1 sets the completion byte, subtype 2 clears it and runs the dependency
reset 0x423d33, every subtype stores phase 0) and the cleanup 0x475885 / 0x4757da. The generic Z entry allocator 0x4d39f9 and releaser 0x4d3992
run as original code on the table at 0x5d1591 (busy seeds decide which slot comes back). The object methods run as original functions on the
same process image with ECX = 0x622fa2: the pointer test 0x475da4 (two stack words x, y whose upper halves are garbage), the click method
0x47608e (no arguments: it reads the candidate cell 0x5c39e5 and the row phase itself and guards itself), the render callback 0x4778df
(cdecl, reads the object through globals) and the invalidate 0x4758e8, the cleanup 0x475885 and the scene reset 0x47591f.

Native side: tests/action_family_e4_runtime_oracle_driver.c links ONLY the kernel (src/action_family_e4_runtime.c) and implements the HOST
side of the E4rHost contract with scripted queues (GetTickCount values, sound-busy answers, image handles, 15-bit rand values, text extents),
a model of the Z entry table, the view and full rectangles, the event flag window and the object image at 0x622fa2 (E4rObject.b IS that image,
all 0x8da bytes). The driver decides nothing the kernel decides. It keeps two logs, the observer log (E4rHost.observe) and the host-call log
(what the kernel really asked of the host); the oracle requires them to agree, so an observer that invents or omits an effect fails.

Compared after EVERY action (dispatcher pass, pointer, click, render, invalidate, cleanup, scene reset):
 * the whole 0x8da-byte object image 0x622fa2.. byte for byte against E4rObject.b (garbage seeds in every byte the scenario does not name,
   in the 0x1c unused bytes, the 100 cells, the text buffers beyond their NUL, prove nothing else is touched); the process cells 0x5bb1ca
   (start flag), 0x583999 (engine mode), the seven scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff 0x5bb59b 0x5bb59f 0x5bb5a3, the
   whole event flag window (4096 dwords at 0x585801), the high score table 0x5a0545 / 0x5a0549 (five dwords), the whole generic Z entry
   table (0x58 entries of 0x4a bytes: type 10, callback 0x4778df, surface, flags 0/0/1/1, word 0 and the label are the stores of the original;
   the allocator and releaser flags; the dirty request of the invalidate), the pointer and cursor cells 0x5c39e5 0x5b44f0 0x5b44f4 and the three
   host-composed cells 0x5d162d 0x5d1631 0x5d1639 against their documented composition from the native outputs ([0x5d0377] copy,
   0x5b160c + (kind << 5) + (sub << 4), 1); the read-only cells (view rectangle 0x583186, full rectangle 0x583196, target surface 0x5cf665,
   debug flag 0x63a4cd, the empty-string globals 0x63a87c..0x63a894, the font image table 0x5d032f) unchanged;
 * every byte of every row (0x8d bytes except the dependency record the gate and the reset own) against a model and the whole row body (the
   original never writes it); every write outside the listed cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every effect of the
   E4rEffect list: the start flag, the ambient stop, every rand value, the slot (after 0x4d39f9), the code point after the entry label copy
   (0x476b8e) and after the slot surface store (0x476bcd), the image loader (kind, handle), the sound routines, GetTickCount, the scene cells,
   the engine mode, the event flag window, the row phase dword, the font release, the releasers, the invalidate's dirty store, the text extent,
   then the completion byte, the dependency reset and the phase store of 0x42ba3a) against the sequence the native kernel reports for the same
   visit, entry for entry; the scripted queues (tick, busy, handle, rand, extent) are consumed identically by both sides;
 * pointer: the return value (1 claims), the candidate 0x5c39e5, the cursor cells, the hover indexes in the object image;
 * click: the sound calls, the tick, the exit button's row phase store, the swap and selection fields in the object image;
 * render: every recorded 0x4c5377 blit (this, source surface = the role the kernel names, source and destination rectangle CONTENTS, label
   pointer and string) and every text draw (0x4c924d acquire then 0x4d2c20: string, x, y, font, parameter, font tables, font image, target)
   against E4rRenderResult.op, including the view origin; the object's dirty flags.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10; the kind comes from the label pointer 0x54c8b8 / 0x54c8d8)
  R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4)
  R 0x4c5377 blit recorder (ECX 0x5cf659, ret 0x14)   R 0x4d2c20 text draw recorder (cdecl, 8 arguments)
  R 0x4c924d / 0x4c92c5 font image acquire / release (ECX 0x5cf659, ret 4; the acquire pairs with the next draw, the release is an effect)
  R 0x4d3836 text measure (cdecl, scripted word result)   R 0x50cd50 rand (scripted 15-bit values)   R 0x4e8d96 ambient stop (ECX 0x571442)
  R 0x50ca3e sprintf (cdecl; the formats "%lu", "%2dm %2ds" and "%s", implemented here for the original side)
  R 0x51dc6c free (recorded)   R GetTickCount (import thunk stub) scripted values
  O 0x42a3e9 / 0x428692 arm entries, 0x42a40d / 0x4286b5 post-gate points, 0x476a25 handler entry, 0x42a41f handler return, 0x42ba3a generic
    completion, 0x42babe (its ret), 0x423d33 dependency reset, 0x476ab4 / 0x476b8e / 0x476bcd code points inside the handler, 0x4d3992 releaser
    entry, 0x475911 (the invalidate's dirty store); every store to the process data region is observed (read-only)
  G 0x4c97b4 0x42639d 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag 0x63a4cd is 0.
 The strings the kernel hard-codes (the entry label, the 11 blit labels, the 11 "NO SOUND\\0" compare sites, the loader's kind / labels, the
 sprintf formats) are checked against the image at start-up.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick, busy, rand and extent values, the
view and full rectangles, the target surface handle (cell 0x5cf665), the background / entry 1 surface (0x5d15e3), the font image table, the busy
seeds of the Z entry table, the event flag window contents.

KNOWN DIVERGENCES (native safety layer; never silently skipped. Checked natively in refusal_checks(); the oracle's scenarios skip the actions
the kernel refuses (counted in stats.skipped_native_refusal) instead of running them against the original):
  K1 e4r_validate_body: wrong length, rows / columns outside 1..10, kinds outside E4R_MIN_KINDS..30, font outside 0..17, an unterminated name,
     score name, title, sound record or used piece name -> E4R_ERR_BODY, no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row -> E4R_ERR_UNSUPPORTED, no effect; a piece kind outside the body for phase 1,
     a selection or swap index outside the board for the check, a click with indexes outside the board -> E4R_ERR_UNSUPPORTED.
  K3 phase 2 with an event flag index outside the host window 0..4095 and not -1 -> E4R_ERR_BOUNDS before the first effect.
  K4 render with a present, unmatched piece kind outside the body (not on the score screen) -> E4R_ERR_BOUNDS, no change.
  K5 render with slot -1 or row -1: native does nothing (valid = 0), the original would index the entry table / row table at -1; invalidate /
     cleanup with a slot outside the entry table are skipped likewise.
  K6 host failures -> E4R_ERR_HOST, allocator exhaustion (the original reaches the fatal path 0x52139c) -> E4R_ERR_HOST, a fill that cannot finish.
 All of these are unreachable in the game (loader-built 2034-byte bodies, callbacks only for allocated entries).

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69, 0x4fb2e3,
0x4f6334), the blit body 0x4c5377, the text routines 0x4d2c20 / 0x4d3836 and the font acquire / release bodies, the CRT rand 0x50cd50 and sprintf
0x50ca3e, the cascade 0x4f0059 and the accepted-release chain 0x43b273 that call 0x475da4 / 0x47608e (the oracle calls the methods directly), the
generic Z entry drawer that calls 0x4778df (the oracle calls it itself), the scene clears 0x438b5d / 0x43de52 and the invalidate caller 0x43d910,
the loader 0x475964 / 0x40b34a that builds the body, the engine consumers of the scene-change cells, the host composition of the cursor cells
(their documented composition is checked, not the engine code that reads them).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57. The two real bodies (resources 2295 and 2296) are
read at run time from work/rt54/body_2295.bin / body_2296.bin or work/analysis/hiff-resources/{2295,2296}.bin when present (never committed);
scenarios that use them are skipped otherwise.

Modes: --quick-only runs the scenarios flagged quick (seconds); the default run is every scenario plus the native-only refusal checks;
--workers N shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does
this); --discover-pins prints the PINS_TABLE of the original code the scenarios execute (function spans from the decompiled function index).
The pins are verified at start-up; a mismatch aborts the run. The planted-mutant sweep is tests/action_family_e4_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_e4_runtime_original_oracle.py --quick-only
  python3 action_family_e4_runtime_original_oracle.py --workers 4 --result ../../../work/analysis/slices/RT-54.oracle-result.json
  python3 action_family_e4_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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
BODY_LEN = 2034
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF
REAL_BODY_FILES = (ROOT / 'work/rt54/body_2295.bin', ROOT / 'work/rt54/body_2296.bin')
REAL_RESOURCES = (ROOT / 'work/analysis/hiff-resources/2295.bin', ROOT / 'work/analysis/hiff-resources/2296.bin')

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x476A25, 0x42BA3A, 0x423D33, 0x42BABE
HANDLER_RETURN = 0x42A41F
ARM = {0xE4: 0x42A3E9, 0x67: 0x428692}
VISIT = {0xE4: 0x42A40D, 0x67: 0x4286B5}
M_POINTER, M_CLICK, M_RENDER, M_INVALIDATE, M_CLEANUP, M_SCENE_RESET = 0x475DA4, 0x47608E, 0x4778DF, 0x4758E8, 0x475885, 0x47591F
AT_ALLOC, AT_REGISTER, AT_SLOT_SURFACE, AT_DIRTY = 0x476AB4, 0x476B8E, 0x476BCD, 0x475911
RELEASE_SLOT_FN = 0x4D3992
LOAD_IMAGE, RELEASE_IMAGE = 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
BLIT, FREE = 0x4C5377, 0x51DC6C
TEXT_DRAW, FONT_ACQUIRE, FONT_RELEASE, TEXT_MEASURE = 0x4D2C20, 0x4C924D, 0x4C92C5, 0x4D3836
RAND, AMBIENT, SPRINTF = 0x50CD50, 0x4E8D96, 0x50CA3E
GUARDS = [0x4C97B4, 0x42639D, 0x52139C, 0x44A2B7]

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ = 0x622FA2
OBJ_LEN = 0x8DA
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_VIEW, CELL_FULL = 0x583186, 0x583196
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
HS_MARKER, HS_TABLE = 0x5A0545, 0x5A0549
FONT_IMG_TABLE, FONT_TAB1, FONT_TAB2 = 0x5D032F, 0x5A4C24, 0x5ADB3A
FONT_STRIDE1, FONT_STRIDE2 = 0x7F3, 0x1D0
EMPTY_STRINGS = (0x63A87C, 0x63A880, 0x63A884, 0x63A888, 0x63A88C, 0x63A890, 0x63A894)
DEBUG_FLAGS = (0x63A4CD, 0x63888B)
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY, THIS_AMBIENT = 0x5CF659, 0x5C3A67, 0x5CF1EB, 0x571442
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
LABEL_KIND = b'CIFTREE'
LABEL_ENTRY = b'MATCH PUZZLE OVERLAYS'
LOAD_LABELS = {0x54C8B8: (0, b'Match Puzzle Surface'), 0x54C8D8: (1, b'Score Surface')}
NO_SOUND = b'NO SOUND\0'
NO_SOUND_SITES = (0x54C844, 0x54C850, 0x54C85C, 0x54C8F0, 0x54C8FC, 0x54C908, 0x54C970, 0x54C97C, 0x54C98C, 0x54C998, 0x54C9A4)
CAND_PIECE, CAND_EXIT, CAND_SHUFFLE = 0x27D5, 0x27D6, 0x27D7
MAX_FONT = 17

# the numbers of E4rEffect
FX = dict(START_FLAG=1, AMBIENT_STOP=2, RAND=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6, SLOT_SURFACE=7, PHASE=8, SOUND_PREPARE=9, SOUND_STOP=10,
          SOUND_PLAY=11, SOUND_BUSY=12, TICK=13, X57B=14, X599=15, X595=16, X39FF=17, X59B=18, X59F=19, X5A3=20, MODE=21, EVENT_FLAG=22,
          FONT_RELEASE=23, COMPLETE=24, RELEASE_SURFACE=25, RELEASE_SLOT=26, MARK_DIRTY=27, TEXT_EXTENT=28)
FXN = {v: k for k, v in FX.items()}
# effects whose first value (and second, where listed) is a word on the original's side
FX_SIZE = {FX['SLOT']: (2, 4), FX['SLOT_REGISTER']: (2, 4), FX['SLOT_SURFACE']: (2, 4), FX['SOUND_PLAY']: (2, 4), FX['SOUND_BUSY']: (2, 4),
           FX['COMPLETE']: (2, 4), FX['X599']: (2, 4), FX['X595']: (2, 4), FX['X39FF']: (2, 4), FX['RELEASE_SLOT']: (2, 4),
           FX['EVENT_FLAG']: (2, 4), FX['FONT_RELEASE']: (2, 4), FX['MARK_DIRTY']: (2, 4), FX['TEXT_EXTENT']: (2, 2)}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
# the kinds that are also host calls (the host-call log of the driver uses the same numbers)
HOST_FX = {FX[k] for k in ('AMBIENT_STOP', 'RAND', 'SLOT', 'SLOT_REGISTER', 'SURFACE_LOAD', 'SLOT_SURFACE', 'SOUND_PREPARE', 'SOUND_STOP',
                           'SOUND_PLAY', 'SOUND_BUSY', 'TICK', 'X57B', 'X599', 'X595', 'X39FF', 'X59B', 'X59F', 'X5A3', 'MODE', 'EVENT_FLAG',
                           'FONT_RELEASE', 'RELEASE_SURFACE', 'RELEASE_SLOT', 'MARK_DIRTY', 'TEXT_EXTENT')}
HC_VIEW = 101

# blit labels: address -> (E4rLabel, text)
BLIT_LABELS = {0x54C9B0: (1, b'MATCH PUZZLE Entire Background Erase'), 0x54C9D8: (2, b'Match Puzzle Overlays'),
               0x54C9F0: (3, b'Match Puzzle Overlays'), 0x54CA08: (4, b'Matching Piece'),
               0x54CA18: (5, b'MATCH PUZZLE Sring Background Erase'), 0x54CA3C: (6, b'Matching Piece'),
               0x54CA4C: (7, b'MATCH PUZZLE Score Background Erase'), 0x54CA70: (8, b'MATCH PUZZLE Time Left'),
               0x54CA88: (9, b'MatchPuz Shuffle Button Down'), 0x54CAA8: (10, b'MatchPuz Shuffle Button Down'),
               0x54CAC8: (11, b'MATCH PUZZLE blt with score background')}
SPRINTF_FORMATS = {0x54C898: b'%lu', 0x54C89C: b'%lu', 0x54C918: b'%lu', 0x54C954: b'%2dm %2ds', 0x54CAF4: b'%s', 0x54CAF8: b'%lu'}
ROLE_PUZZLE, ROLE_BACKGROUND, ROLE_SCORE = 1, 2, 3

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4), SND_PLAY: (0xb4, 4),
             SND_BUSY: (0x138, 4), BLIT: (0x214, 0x14), FREE: (0xb, 0), TEXT_DRAW: (0x453, 0), FONT_ACQUIRE: (0x78, 4),
             FONT_RELEASE: (0x7b, 4), TEXT_MEASURE: (0x15c, 0), RAND: (0x22, 0), AMBIENT: (0x32, 0), SPRINTF: (0x52, 0)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT: 0x14, FREE: 0, TEXT_DRAW: 0,
        FONT_ACQUIRE: 4, FONT_RELEASE: 4, TEXT_MEASURE: 0, RAND: 0, AMBIENT: 0, SPRINTF: 0}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            SND_BUSY: THIS_BUSY, BLIT: THIS_SURF, FONT_ACQUIRE: THIS_SURF, FONT_RELEASE: THIS_SURF, AMBIENT: THIS_AMBIENT}

# Executed original code, as SHA-256 of the unmodified image bytes. Discovered over every scenario with --discover-pins, verified at start-up.
PINS_TABLE = ()


class Mismatch(Exception):
    pass


# ---- object layout (offsets from 0x622fa2): name -> (offset, size, signed)
OBJ_FIELDS = (('won', 0x1C, 4, 1), ('slot', 0x20, 2, 1), ('row', 0x22, 2, 1), ('surface', 0x24, 4, 0), ('score_surface', 0x28, 4, 0),
              ('state', 0x2C, 4, 1), ('show_name', 0x800, 1, 0), ('score_dirty', 0x801, 1, 0), ('erase_all', 0x802, 1, 0),
              ('name_dirty', 0x803, 1, 0), ('shuffle_down', 0x898, 1, 0), ('shuffle_dirty', 0x899, 1, 0), ('active', 0x89A, 4, 1),
              ('exit', 0x89E, 4, 1), ('deadline', 0x8A2, 4, 0), ('sel_col', 0x8A6, 4, 1), ('sel_row', 0x8AA, 4, 1), ('swap_col', 0x8AE, 4, 1),
              ('swap_row', 0x8B2, 4, 1), ('no_selection', 0x8B6, 4, 1), ('hover_col', 0x8BA, 4, 1), ('hover_row', 0x8BE, 4, 1),
              ('score', 0x8C2, 4, 1), ('time_end', 0x8C6, 4, 0), ('shuffle_end', 0x8CA, 4, 0), ('run_row_min', 0x8CE, 2, 1),
              ('run_row_max', 0x8D0, 2, 1), ('run_col_min', 0x8D2, 2, 1), ('run_col_max', 0x8D4, 2, 1), ('match_col', 0x8D6, 1, 0),
              ('match_row', 0x8D7, 1, 0), ('check_first', 0x8D8, 1, 0), ('check_second', 0x8D9, 1, 0))
OBJ_POS = {n: (o, s, g) for n, o, s, g in OBJ_FIELDS}
TEXT_FIELDS = {'name_text': 0x804, 'score_text': 0x835, 'time_text': 0x856, 'target_text': 0x877}
CELLS_AT, CELL_ROW_STRIDE, CELL_STRIDE = 0x30, 200, 20


def fld(img, name):
    off, size, signed = OBJ_POS[name]
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=bool(signed))


def put_fld(img, name, v):
    off, size, _ = OBJ_POS[name]
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


def cell_off(r, c):
    return CELLS_AT + r * CELL_ROW_STRIDE + c * CELL_STRIDE


def cell_kind(img, r, c):
    return struct.unpack_from('<h', img, cell_off(r, c) + 2)[0]


def cell_rect(img, r, c):
    return struct.unpack_from('<4i', img, cell_off(r, c) + 4)


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xe4 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in QKINDS}
        self.qpos = Counter()
        self.in_complete = False
        self.recording = False
        self.cur_phase = None
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
            rets = {int(i.op_str, 0) if i.op_str else 0 for i in md.disasm(self.pristine[a - base:a - base + span], a)
                    if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise d9.OracleError('hooked function %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def _check_constants(self):
        base = self.pe.image_base

        def img(va, n):
            return bytes(self.pristine[va - base:va - base + n])
        want = [(0x54C8A0, LABEL_ENTRY + b'\0'), (0x54C8D0, LABEL_KIND + b'\0'), (0x54C8E8, LABEL_KIND + b'\0'), (0x54CAF0, b'T\0')]
        want += [(va, text + b'\0') for va, (_, text) in LOAD_LABELS.items()]
        want += [(va, NO_SOUND) for va in NO_SOUND_SITES]
        want += [(va, text + b'\0') for va, (_, text) in BLIT_LABELS.items()]
        want += [(va, fmt + b'\0') for va, fmt in SPRINTF_FORMATS.items()]
        want += [(0x54C960, b'WIN!!!\0'), (0x54C968, b'TIME!\0'), (0x54C914, b'0\0'), (0x54C988, b'0\0')]
        for va, data in want:
            if img(va, len(data)) != data:
                raise d9.OracleError('image constant at %#x differs from the kernel assumption: %r' % (va, img(va, len(data))))

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.frees = []
        self.ops = []
        self.pending_acq = None
        self.sprintfs = []
        self.in_complete = False
        self.cur_phase = None

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in QKINDS}
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
                      GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen, AT_ALLOC: self._at_alloc, AT_REGISTER: self._at_register,
                      AT_SLOT_SURFACE: self._at_slot_surface, AT_DIRTY: self._at_dirty, RELEASE_SLOT_FN: self._release_slot})
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a in GUARDS:
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
            raise d9.OracleError('handler entered with ECX != 0x622fa2')
        self.cur_phase = self.row_phase(row)
        self.events.append(('handler', row, self.cur_phase))

    def _handler_return(self, uc, address, size, user):
        self.cur_phase = None

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

    def _at_alloc(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT'], uc.reg_read(X.UC_X86_REG_EAX) & 0xFFFF, 0))

    def _at_register(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT_REGISTER'], self.rs16(OBJ + 0x20) & 0xFFFF, 0))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0x20)
        self.events.append(('fx', FX['SLOT_SURFACE'], slot & 0xFFFF, self.entry_surface(slot)))

    def _at_dirty(self, uc, address, size, user):
        self.events.append(('fx', FX['MARK_DIRTY'], self.rs16(OBJ + 0x20) & 0xFFFF, 0))

    def _release_slot(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('fx', FX['RELEASE_SLOT'], struct.unpack('<H', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

    def font_of(self, tab1, tab2):
        k, rem = divmod(tab1 - FONT_TAB1, FONT_STRIDE1)
        if rem or not 0 <= k <= MAX_FONT or tab2 != FONT_TAB2 + k * FONT_STRIDE2:
            raise d9.OracleError('font tables %#x %#x are not those of a font index' % (tab1, tab2))
        return k

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(9)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        if address in WANT_ECX and ecx != WANT_ECX[address]:
            raise d9.OracleError('hook %#x entered with ECX=%#x' % (address, ecx))
        if address == LOAD_IMAGE:
            kind_s, name, six = d9.cstr(self.rd(a[0], 32)), d9.cstr(self.rd(a[1], 64)), a[2]
            if kind_s != LABEL_KIND or six != 6 or a[3] not in LOAD_LABELS:
                raise d9.OracleError('image loader arguments differ from the packet: %r %d %#x' % (kind_s, six, a[3]))
            kind = LOAD_LABELS[a[3]][0]
            eax = self.pop('handle')
            self.loaded.append((kind, name.decode('latin1')))
            self.events.append(('fx', FX['SURFACE_LOAD'], kind, eax))
        elif address == RELEASE_IMAGE:
            if a[0] not in (OBJ + 0x24, OBJ + 0x28):
                raise d9.OracleError('releaser called for %#x' % a[0])
            old = u32(uc, a[0])
            self.events.append(('fx', FX['RELEASE_SURFACE'], old, 0 if a[0] == OBJ + 0x24 else 1))
            self.wr(a[0], bytes(4))
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['SOUND_BUSY'], a[0], eax))
        elif address == BLIT:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            if a[4] not in BLIT_LABELS:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            label, text = BLIT_LABELS[a[4]]
            self.ops.append(dict(op='blit', this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=label,
                                 label_text=text))
        elif address == FONT_ACQUIRE:
            if self.pending_acq is not None:
                raise d9.OracleError('font acquired twice without a draw')
            self.pending_acq = s16(a[0] & 0xFFFF)
        elif address == FONT_RELEASE:
            self.events.append(('fx', FX['FONT_RELEASE'], a[0] & 0xFFFF, 0))
        elif address == TEXT_DRAW:
            font = self.font_of(a[1], a[2])
            if self.pending_acq != font:
                raise d9.OracleError('text drawn with font %d after acquiring %r' % (font, self.pending_acq))
            self.pending_acq = None
            fontimg = u32(uc, FONT_IMG_TABLE + 4 * font)
            self.ops.append(dict(op='text', text=d9.cstr(self.rd(a[0], 64)).decode('latin1'), font=font, x=s16(a[3] & 0xFFFF),
                                 y=s16(a[4] & 0xFFFF), fontimg=a[5], want_fontimg=fontimg, target=a[6], param=s16(a[7] & 0xFFFF)))
        elif address == TEXT_MEASURE:
            if self.rd(a[0], 2) != b'T\0':
                raise d9.OracleError('text measure of something other than "T"')
            font = self.font_of(a[1], a[2])
            v = self.pop('extent')
            eax = (v & 0xFFFF) | (0x5A5A0000 if v & 1 else 0xA5A50000)       # the caller takes AX only
            self.events.append(('fx', FX['TEXT_EXTENT'], font, v & 0xFFFF))
        elif address == RAND:
            eax = self.pop('rand')
            self.events.append(('fx', FX['RAND'], eax, 0))
        elif address == AMBIENT:
            self.events.append(('fx', FX['AMBIENT_STOP'], 0, 0))
        elif address == SPRINTF:
            fmt = d9.cstr(self.rd(a[1], 16))
            if a[1] not in SPRINTF_FORMATS or SPRINTF_FORMATS[a[1]] != fmt:
                raise d9.OracleError('sprintf with an unknown format %#x %r' % (a[1], fmt))
            if fmt == b'%lu':
                text = b'%d' % (a[2] & M32)
            elif fmt == b'%2dm %2ds':
                text = b'%2dm %2ds' % (sgn(a[2], 4), sgn(a[3], 4))
            else:
                text = d9.cstr(self.rd(a[2], 64))
            self.wr(a[0], text + b'\0')
            self.sprintfs.append((fmt, text))
            eax = len(text)
        elif address == FREE:
            self.frees.append(a[0])
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
            return
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
        for va in DEBUG_FLAGS:
            if self.rd(va, 2) != b'\0\0':
                raise d9.OracleError('original debug flag %#x nonzero' % va)
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
SOURCES = ('action_family_e4_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_VIEW, F_PREPARE, F_STOP, F_PLAY, F_BUSY, F_RANDOM,
 F_AMBIENT, F_FONT, F_EXTENT, F_TRANSITION, F_FLAG) = [1 << k for k in range(18)]
QKINDS = ('tick', 'busy', 'handle', 'rand', 'extent')
LOGMAX = 4096


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_e4_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('E4_SANITIZE'):
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
        P, I32, U32, U32P, I64P, I32P = C.c_void_p, C.c_int32, C.c_uint32, C.POINTER(C.c_uint32), C.POINTER(C.c_int64), C.POINTER(C.c_int32)
        lib.e4o_new.restype = P
        lib.e4o_str.restype = C.c_char_p
        for name, args, res in (
                ('e4o_free', [P], None), ('e4o_reset', [P], None), ('e4o_clear_logs', [P], None), ('e4o_set_fail', [P, C.c_int], None),
                ('e4o_set_rects', [P, I32P], None), ('e4o_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('e4o_q_pos', [P, C.c_int], C.c_int), ('e4o_q_underflow', [P, C.c_int], C.c_int),
                ('e4o_obj_get', [P, C.c_char_p], None), ('e4o_obj_set', [P, C.c_char_p], None),
                ('e4o_world_get', [P, I32P], None), ('e4o_world_set', [P, I32P], None),
                ('e4o_cells_get', [P, I32P], None), ('e4o_cells_set', [P, I32P], None),
                ('e4o_events_get', [P, C.c_char_p], None), ('e4o_events_set', [P, C.c_char_p], None),
                ('e4o_entries_get', [P, C.c_char_p], None), ('e4o_entries_set', [P, C.c_char_p], None),
                ('e4o_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('e4o_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('e4o_str', [P, C.c_int], C.c_char_p),
                ('e4o_str_kind', [P, C.c_int], C.c_int), ('e4o_nstr', [P], C.c_int), ('e4o_errors', [P, I32P], None),
                ('e4o_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('e4o_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('e4o_click', [P, C.c_char_p, C.c_int, U32, I32, I32P], None),
                ('e4o_invalidate', [P], C.c_int), ('e4o_cleanup', [P], C.c_int), ('e4o_scene_reset', [P], None),
                ('e4o_validate', [C.c_char_p, C.c_int], C.c_int),
                ('e4o_render', [P, C.c_char_p, C.c_int, I32P], None), ('e4o_render_op', [P, C.c_int, I32P, C.c_char_p], C.c_int)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.e4o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.e4o_free(self.h)

    def reset(self):
        self.lib.e4o_reset(self.h)

    def clear_logs(self):
        self.lib.e4o_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.e4o_set_fail(self.h, m)

    def set_rects(self, view, full):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in list(view) + list(full)])
        self.lib.e4o_set_rects(self.h, arr)

    def set_queues(self, qs):
        for i, k in enumerate(QKINDS):
            vals = list(qs.get(k, []))[:1024]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.e4o_q_set(self.h, i, arr, len(vals))

    def qpos(self, k):
        return self.lib.e4o_q_pos(self.h, QKINDS.index(k))

    def qunder(self, k):
        return self.lib.e4o_q_underflow(self.h, QKINDS.index(k))

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.e4o_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.e4o_obj_set(self.h, bytes(img))

    def world(self):
        arr = (C.c_int32 * 7)()
        self.lib.e4o_world_get(self.h, arr)
        return list(arr)

    def set_world(self, vals):
        arr = (C.c_int32 * 7)(*[sgn(v, 4) for v in vals])
        self.lib.e4o_world_set(self.h, arr)

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.e4o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.e4o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.e4o_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.e4o_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.e4o_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.e4o_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.e4o_entry_set_u32(self.h, slot, off, v & M32)

    def log(self, which):
        arr = (C.c_int32 * (3 * LOGMAX))()
        n = self.lib.e4o_log(self.h, which, arr, LOGMAX)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def names(self):
        n = min(self.lib.e4o_nstr(self.h), 8)
        return [(self.lib.e4o_str_kind(self.h, i), self.lib.e4o_str(self.h, i).decode('latin1')) for i in range(n)]

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.e4o_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.e4o_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 6)()
        self.lib.e4o_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, body, row_phase, candidate):
        out = (C.c_int32 * 5)()
        self.lib.e4o_click(self.h, bytes(body), len(body), row_phase & M32, sgn(candidate, 4), out)
        return tuple(out)

    def invalidate(self):
        return self.lib.e4o_invalidate(self.h)

    def cleanup(self):
        return self.lib.e4o_cleanup(self.h)

    def scene_reset(self):
        self.lib.e4o_scene_reset(self.h)

    def validate(self, body):
        return self.lib.e4o_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * 3)()
        self.lib.e4o_render(self.h, bytes(body), len(body), out)
        ops = []
        for i in range(out[2] if 0 <= out[2] <= 160 else 0):
            o = (C.c_int32 * 16)()
            text = C.create_string_buffer(40)
            self.lib.e4o_render_op(self.h, i, o, text)
            ops.append(dict(kind=o[0], label=o[1], role=o[2], src=tuple(o[3:7]), dst=tuple(o[7:11]), font=o[11], param=o[12], x=o[13],
                            y=o[14], text=text.value.decode('latin1')))
        return dict(status=out[0], valid=out[1], count=out[2], ops=ops)


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
B = dict(name=0, score_name=0x21, rows=0x42, cols=0x44, kinds=0x46, shuffle_src=0x48, piece_rect=0x58, name_panel=0x238, font=0x23A,
         param=0x23C, title=0x23E, kind_names=0x25F, score_panel=0x63D, time_limit=0x63E, target=0x640, per_piece=0x644, matched_src=0x646,
         bonus3_time=0x656, bonus4_score=0x658, bonus4_time=0x65A, bonus5_score=0x65C, bonus5_time=0x65E, xoff=0x660, yoff=0x662, ygap=0x664,
         xgap=0x666, title_rect=0x668, shuffle_rect=0x678, target_rect=0x688, score_rect=0x698, time_rect=0x6A8, name_rect=0x6B8,
         icon_rect=0x6C8, hs0=0x6D8, hs1=0x6DC, hs2=0x6E0, hs3=0x6E4, end_delay=0x6E8, snd_a=0x6EA, ch_a=0x70B, snd_b=0x71B, ch_b=0x73C,
         snd_c=0x74C, ch_c=0x76D, win=0x77D, final_delay=0x796, snd_d=0x798, ch_d=0x7B9, exit=0x7C9, exit_rect=0x7E2)
SND_OFF = dict(a=B['snd_a'], b=B['snd_b'], c=B['snd_c'], d=B['snd_d'])
CH_OFF = dict(a=B['ch_a'], b=B['ch_b'], c=B['ch_c'], d=B['ch_d'])

EXTREME_RECTS = ((-0x80000000, -0x80000000, 0x7FFFFFFF, 0x7FFFFFFF), (0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF),
                 (-0x80000000, 0, -0x7FFFFFF0, 40), (0, 0, 0, 0), (-1, -1, 0, 0), (40000, 40000, 50000, 50000),
                 (-50000, -50000, -40000, -40000), (7, 7, 7, 7))

_REAL = []


def real_bodies():
    """The two real 2034-byte bodies (resources 2295, 2296) from the local evidence; empty when absent."""
    if not _REAL:
        found = []
        for f, res in zip(REAL_BODY_FILES, REAL_RESOURCES):
            body = None
            try:
                data = f.read_bytes()
                if len(data) == BODY_LEN:
                    body = data
            except OSError:
                pass
            if body is None:
                try:
                    data = res.read_bytes()
                    at = data.find(b'JAN_GlyphMatchPUZ_OVL')
                    if at >= 0 and at + BODY_LEN <= len(data):
                        body = data[at:at + BODY_LEN]
                except OSError:
                    pass
            if body is not None:
                found.append(body)
        _REAL.append(found)
    return _REAL[0]


def snd(kind):
    return {'none': NO_SOUND, 'real': b'Beep12\0\0\0', 'real2': b'bell_77\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0', 'long': b'k' * 32 + b'\0'}[kind]


SND_KINDS = ('none', 'real', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4')


def put_snd(b, off, kind):
    """A sound record: the name, a terminator inside the 0x21 bytes (the native validator needs one; the original compares 9 bytes)."""
    data = snd(kind)
    b[off:off + len(data)] = data
    if 0 not in b[off:off + 0x21]:
        b[off + 0x20] = 0


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start, flag=flag, value=value)


def rand_block(rng, scene, flag=-1):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)), flag, rng.choice((0, 1, 7, 0x80, 0xFF)))


def put_block(b, off, blk):
    struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
    struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
    struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
    struct.pack_into('<h', b, off + 20, sgn(blk['start'], 2))
    struct.pack_into('<h', b, off + 22, sgn(blk['flag'], 2))
    b[off + 24] = blk['value'] & 0xFF


def pack_rect(b, off, r):
    struct.pack_into('<4i', b, off, *[sgn(v, 4) for v in r])


def rand_rect(rng):
    return tuple(rng.choice((rng.randint(-2000, 2000), rng.getrandbits(32) - 0x80000000, 0x7FFFFFF0, -0x7FFFFFF0, 0)) for _ in range(4))


def make_body(rng, name=b'JAN_Glyph', score_name=b'', rows=5, cols=7, kinds=26, time=61, target=2500, per=50, bonus=(5, 100, 8, 250, 12),
              font=3, param=7, name_panel=1, score_panel=1, title=b'Match', layout='grid', snds=None, chans=None, win=None, exitb=None,
              end_delay=2, final_delay=1, geometry=None, hs=None, kind_names=None, per_set=True):
    b = bytearray(rng.getrandbits(8) for _ in range(BODY_LEN))                                    # garbage in every unnamed byte

    def cstr_at(off, text, n=0x21, garbage=True):
        text = bytes(text)[:n - 1]
        b[off:off + len(text)] = text
        b[off + len(text)] = 0                                                                       # garbage stays after the NUL
    cstr_at(B['name'], name)
    cstr_at(B['score_name'], score_name)
    struct.pack_into('<hhh', b, B['rows'], rows, cols, kinds)
    b[B['name_panel']] = name_panel
    b[B['score_panel']] = score_panel
    struct.pack_into('<hh', b, B['font'], font, param)
    cstr_at(B['title'], title)
    pw, ph = (geometry or {}).get('piece', (40, 40))
    for k in range(30):                                                                          # piece source rectangles
        pack_rect(b, B['piece_rect'] + 16 * k, (k * 41, 7 + (k % 3), k * 41 + pw + (k % 2 if k else 0), 7 + (k % 3) + ph))
    pack_rect(b, B['piece_rect'], (0, 0, pw, ph))
    pack_rect(b, B['shuffle_src'], rand_rect(rng))
    pack_rect(b, B['matched_src'], rand_rect(rng))
    names = kind_names or [b'Piece %d' % k if k % 7 else b'' for k in range(30)]
    for k in range(30):
        if k < kinds:
            cstr_at(B['kind_names'] + 0x21 * k, names[k % len(names)] if k % 5 else (b'N' * 32 if k % 10 == 0 else b'Glyph %c' % (65 + k % 26)))
    struct.pack_into('<h', b, B['time_limit'], sgn(time, 2))
    struct.pack_into('<i', b, B['target'], sgn(target, 4))
    struct.pack_into('<h', b, B['per_piece'], sgn(per, 2))
    for off, v in zip(('bonus3_time', 'bonus4_score', 'bonus4_time', 'bonus5_score', 'bonus5_time'), bonus):
        struct.pack_into('<h', b, B[off], sgn(v, 2))
    g = geometry or {}
    struct.pack_into('<hhhh', b, B['xoff'], sgn(g.get('xoff', 31), 2), sgn(g.get('yoff', 17), 2), sgn(g.get('ygap', 3), 2),
                     sgn(g.get('xgap', 2), 2))
    rects = layout_rects(layout, rng)
    for n in ('title_rect', 'shuffle_rect', 'target_rect', 'score_rect', 'time_rect', 'name_rect', 'icon_rect', 'exit_rect'):
        pack_rect(b, B[n], rects[n])
    struct.pack_into('<4i', b, B['hs0'], *[sgn(v, 4) for v in (hs or (210, 100, 340, 130))])
    struct.pack_into('<h', b, B['end_delay'], sgn(end_delay, 2))
    struct.pack_into('<h', b, B['final_delay'], sgn(final_delay, 2))
    snds = snds or {}
    chans = chans or {}
    for k in 'abcd':
        put_snd(b, SND_OFF[k], snds.get(k, 'none'))
        struct.pack_into('<h', b, CH_OFF[k], sgn(chans.get(k, 1 + 'abcd'.index(k)), 2))
    put_block(b, B['win'], win or block(9999))
    put_block(b, B['exit'], exitb or block(9999))
    return bytes(b)


def layout_rects(kind, rng):
    t = dict(title_rect=(300, 10, 500, 40), shuffle_rect=(500, 100, 600, 140), target_rect=(300, 50, 500, 80), score_rect=(300, 90, 500, 120),
             time_rect=(300, 130, 500, 160), name_rect=(20, 400, 300, 440), icon_rect=(320, 400, 360, 440), exit_rect=(540, 420, 620, 470))
    if kind == 'grid':
        return {n: tuple(v + rng.randint(-3, 3) for v in r) for n, r in t.items()}
    if kind == 'tight':
        return dict(t)
    if kind == 'adjacent':
        d = dict(t)
        d['exit_rect'] = (500, 140, 600, 200)                      # shares an edge with the shuffle rectangle
        d['shuffle_rect'] = (500, 100, 600, 140)
        return d
    if kind == 'overlap':
        return {n: (50 + rng.choice((0, 0, 1)), 50 + rng.choice((0, 0, 1)), 100 - rng.choice((0, 0, 1)), 100 - rng.choice((0, 0, 1)))
                for n in t}
    if kind == 'neg':
        return {n: (r[0] - 700, r[1] - 300, r[2] - 700, r[3] - 300) for n, r in t.items()}
    if kind == 'extreme':
        return {n: rng.choice(EXTREME_RECTS) for n in t}
    if kind == 'inverted':
        return {n: (r[2], r[3], r[0], r[1]) if rng.random() < 0.5 else r for n, r in t.items()}
    if kind == 'wide':
        d = dict(t)
        d['shuffle_rect'] = (-30000, -30000, 30000, 30000)
        d['exit_rect'] = (-20000, -20000, 20000, 20000)
        return d
    raise ValueError(kind)


def body_rect(body, off):
    return struct.unpack_from('<4i', body, off)


def bw(body, off):
    return struct.unpack_from('<h', body, off)[0]


def clamp16(v):
    return max(-32768, min(32767, v))


def center_of(rect):
    return clamp16((rect[0] + rect[2]) // 2), clamp16((rect[1] + rect[3]) // 2)


def probe_points(body, img, rng=None, extra=12):
    """Points around every piece cell of the live board, the two buttons and a few wild words."""
    pts = []
    rows, cols = bw(body, B['rows']), bw(body, B['cols'])
    rects = [cell_rect(img, r, c) for r in range(rows) for c in range(cols)]
    rects += [body_rect(body, B['shuffle_rect']), body_rect(body, B['exit_rect'])]
    for l_, t_, r_, b_ in rects:
        pts += [center_of((l_, t_, r_, b_))]
        for dx, dy in ((2, 2), (3, 3), (4, 4), (-2, -2), (-3, -3), (-4, -4), (0, 0), (1, 0)):
            pts += [(clamp16(l_ + dx), clamp16(t_ + dy)), (clamp16(r_ + dx), clamp16(b_ + dy)), (clamp16(l_ + dx), clamp16(b_ + dy)),
                    (clamp16(r_ + dx), clamp16(t_ + dy))]
    pts += [(0x7FFFFFFF, 0x7FFFFFFF), (-0x80000000, -0x80000000), (0x8000, 0x8000), (0xFFFF, 0xFFFF), (-0x8000, 0x7FFF), (0x10000 + 300, 0x10000 + 180)]
    if rng is not None:
        pts += [(rng.randint(-100, 700), rng.randint(-100, 500)) for _ in range(extra)]
    seen, out = set(), []
    for p in pts:
        if p not in seen:
            seen.add(p)
            out.append(p)
    return out


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def default_q(rng=None, **over):
    rand = [rng.getrandbits(15) for _ in range(700)] if rng is not None else [7] * 700
    q = dict(tick=[5000] * 12, busy=[0] * 12, handle=[0x1234, 0x1235, 0x1236, 0x1237], rand=rand, extent=[14] * 8)
    q.update(over)
    return q


POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
OBJ_RANGE = (OBJ, OBJ + OBJ_LEN)
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
HS_RANGE = (HS_MARKER, HS_TABLE + 20)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, ENTRY_RANGE, HS_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)] + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [OBJ_RANGE],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE],
    'scene_reset': [HS_RANGE],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), renders=Counter(), ops=Counter(), mismatches=0, native_refusal_checks=0,
                queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(), states=Counter(), outcomes=Counter(),
                slots=Counter(), blit_labels=Counter(), matches=Counter(), tagged_differences=Counter(), tick_wrap=0)


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def field_at(off):
    for n, o, s, _ in OBJ_FIELDS:
        if o <= off < o + s:
            return n
    for n, o in TEXT_FIELDS.items():
        if o <= off < o + 0x21:
            return n + '+%#x' % (off - o)
    if 0x825 <= off < 0x835:
        return 'icon_rect+%d' % (off - 0x825)
    if CELLS_AT <= off < CELLS_AT + 2000:
        r, rem = divmod(off - CELLS_AT, CELL_ROW_STRIDE)
        return 'cell[%d][%d]+%d' % (r, rem // CELL_STRIDE, rem % CELL_STRIDE)
    if off < 0x1C:
        return 'unused+%#x' % off
    return 'gap+%#x' % off


def diff_obj(a, b):
    bad = [k for k in range(OBJ_LEN) if a[k] != b[k]]
    names = []
    for k in bad:
        n = field_at(k)
        base = n.split('+')[0]
        if base not in [x.split('+')[0] for x in names]:
            names.append('%s original %02x native %02x (obj+%#x)' % (n, a[k], b[k], k))
    return names[:6]


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
        self.static = {}
        self.view = (0, 0, 639, 479)
        self.full = (0, 0, 640, 480)

    def e4_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xE4]

    def body_row(self, img):
        """The row whose body the kernel is shown: the object's row, else the first 0xe4 row; None when the object names a bad row."""
        row, active = fld(img, 'row'), fld(img, 'active')
        if 0 <= row < len(self.rows) and self.rows[row]['type'] == 0xE4:
            return row
        if active or row >= 0:
            return None
        return self.e4_rows()[0]


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(won=rng.choice((0, 0, 1, 2, M32)), slot=rng.choice((-1, -1, 0x19, 0x30)), row=rng.choice((-1, 0, 1, 3)),
             surface=rng.choice((0, 0x5151, M32)), score_surface=rng.choice((0, 0x5252, M32)), state=rng.choice((0, 1, 2, 3, 4, 5, 6)),
             active=0, exit=rng.choice((0, 0, 1, 7)), no_selection=rng.choice((0, 1, 5)), check_first=rng.choice((0, 1, 0xFE)),
             check_second=rng.choice((0, 1, 0x80)), deadline=rng.getrandbits(32), time_end=rng.getrandbits(32),
             shuffle_end=rng.getrandbits(32), score=rng.choice((0, 5, -7, 0x7FFFFFFF, rng.getrandbits(31))),
             show_name=rng.choice((0, 1, 2)), score_dirty=rng.choice((0, 1, 9)), erase_all=rng.choice((0, 1, 3)),
             name_dirty=rng.choice((0, 1, 4)), shuffle_down=rng.choice((0, 1, 6)), shuffle_dirty=rng.choice((0, 1, 8)))
    return img, g


def build_events(rng):
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & M32)
    for k in range(1000, 1008):
        struct.pack_into('<I', pattern, 4 * k, 0)
    return pattern


def set_text_field(img, name, text):
    off = TEXT_FIELDS[name]
    data = bytes(text)[:0x20]
    img[off:off + len(data) + 1] = data + b'\0'


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
    for name, text in init.get('texts', {}).items():
        set_text_field(img, name, text)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    # the process globals the kernel owns: start flag and the high score table
    start = init.get('start', rng.choice((0, 1, M32, 5)))
    marker = init.get('marker', rng.choice((0, 0x1234, M32)))
    hs = init.get('hs', [rng.choice((0, 0, 100, -5, 0x7FFFFFFF, rng.getrandbits(31))) for _ in range(5)])
    x.set_cell(CELL_START, start)
    x.set_cell(HS_MARKER, marker)
    for i in range(5):
        x.set_cell(HS_TABLE + 4 * i, hs[i])
    nat.set_world([start, marker] + list(hs))
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    # read-only cells: the view and full rectangles, the target surface, the font image table, the pointer source, the empty strings
    run.view, run.full = init.get('view', (0, 0, 639, 479)), init.get('full', (0, 0, 640, 480))
    set_view(x, nat, run, run.view, run.full)
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    for k in range(MAX_FONT + 1):
        x.w32(FONT_IMG_TABLE + 4 * k, 0x7B000000 + k * 0x111)
    # the generic Z entry table: garbage, busy seeds decide the allocation
    table = bytearray(rng.getrandbits(8) for _ in range(NENT * STRIDE))
    for s in range(NENT):
        struct.pack_into('<I', table, s * STRIDE + 0x18, 0 if 0x18 <= s <= 0x3F else rng.choice((0, 1, 0xFF000001)))
        struct.pack_into('<I', table, s * STRIDE + 0x14, rng.choice((0, 1)))
    for s in init.get('busy_slots', []):
        struct.pack_into('<I', table, s * STRIDE + 0x18, rng.choice((1, 1, 0xFF000001, 0x80000000)))
    struct.pack_into('<I', table, 1 * STRIDE + 8, BG_HANDLE)
    for name, (va, sz) in POINTER_CELLS.items():
        v = {'cand': 0, 'k0': rng.choice((0, 1, 4, 7)), 'k1': rng.choice((0, 1))}.get(name, rng.getrandbits(32))
        v = init.get(name, v)
        run.cells[name] = v & mask(sz)
        if va >= ENTRY:
            struct.pack_into('<I', table, va - ENTRY, v & M32)
    x.wr(ENTRY, bytes(table))
    nat.set_entries(bytes(table))
    for name, (va, sz) in POINTER_CELLS.items():
        if va < ENTRY:
            x.set_cell(va, run.cells[name], sz)
    run.static = {va: x.rd(va, n) for va, n in [(CELL_VIEW, 32), (CELL_TARGET, 4), (CELL_5D0377, 4), (FONT_IMG_TABLE, 4 * (MAX_FONT + 1))]
                  + [(va, 4) for va in EMPTY_STRINGS] + [(va, 2) for va in DEBUG_FLAGS]}


def set_view(x, nat, run, view, full):
    run.view, run.full = tuple(view), tuple(full)
    x.wr(CELL_VIEW, struct.pack('<4i', *[sgn(v, 4) for v in view]))
    x.wr(CELL_FULL, struct.pack('<4i', *[sgn(v, 4) for v in full]))
    nat.set_rects(view, full)
    run.static[CELL_VIEW] = x.rd(CELL_VIEW, 32)


def compare_all(where, x, nat, stats, run, rows=True, light=False):
    img_x, img_n = x.obj_image(), nat.obj()
    if img_x != img_n:
        raise Mismatch('%s: object image 0x622fa2..+0x8da differs: %s' % (where, '; '.join(diff_obj(img_x, img_n))))
    stats['compared_fields'] += len(OBJ_FIELDS) + 1
    world = nat.world()
    check(stats, where, 'cell 0x5bb1ca (start flag)', sgn(x.cell(CELL_START), 4), world[0])
    check(stats, where, 'cell 0x5a0545 (high score marker)', sgn(x.cell(HS_MARKER), 4), world[1])
    check(stats, where, 'high score table 0x5a0549 (5 dwords)', [sgn(x.cell(HS_TABLE + 4 * i), 4) for i in range(5)], world[2:7])
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
    for va, want in run.static.items():
        check(stats, where, 'read-only cell %#x' % va, x.rd(va, len(want)), want)
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
    """New observer entries and host calls since the previous call: (mapped observer, host calls, observer host-call subset, extra)."""
    fx, hc = nat.log(0), nat.log(1)
    nf, nh = fx[run.fx_seen:], hc[run.hc_seen:]
    run.fx_seen, run.hc_seen = len(fx), len(hc)
    mapped = [norm_fx(k, a, b) for k, a, b in nf]
    hosts = [norm_fx(k, a, b) for k, a, b in nh if k != HC_VIEW]
    extra = [(k, a, b) for k, a, b in nh if k == HC_VIEW]
    only = [e if e[1] != FX['RELEASE_SURFACE'] else ('fx', e[1], e[2], 0) for e in mapped if e[1] in HOST_FX]
    return mapped, hosts, only, extra


def count_effects(stats, mapped):
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1


def sync_row_images(x, run):
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]


def fresh_logs(nat, run):
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0


# ---- predicates that mirror the packet's native-only refusals, written from the disassembly (never from the kernel)
def in_board(body, row, col):
    return 0 <= row < bw(body, B['rows']) and 0 <= col < bw(body, B['cols'])


def step_refusal(img, body, row, phase):
    state = fld(img, 'state')
    if phase in (1, 2) and (fld(img, 'row') != row or fld(img, 'active') == 0):
        return 'phase %d without phase 0 for the row' % phase
    if phase == 1:
        rows, cols, kinds = bw(body, B['rows']), bw(body, B['cols']), bw(body, B['kinds'])
        for r in range(rows):
            for c in range(cols):
                if not 0 <= cell_kind(img, r, c) < kinds:
                    return 'phase 1 with a piece kind outside the body'
        if state == 0:
            if img[0x8D8] != 0 and not in_board(body, fld(img, 'sel_row'), fld(img, 'sel_col')):
                return 'phase 1 check of a selection outside the board'
            if img[0x8D8] == 0 and img[0x8D9] != 0 and not in_board(body, fld(img, 'swap_row'), fld(img, 'swap_col')):
                return 'phase 1 check of a swapped piece outside the board'
    if phase == 2:
        blk = B['exit'] if fld(img, 'exit') != 0 else B['win'] if fld(img, 'won') != 0 else None
        if blk is not None:
            flag = bw(body, blk + 22)
            if flag != -1 and not 0 <= flag < EVENT_COUNT:
                return 'phase 2 with an event flag index outside the host window'
    return None


def tick_refusal(x, run):
    sim = bytearray(x.obj_image())
    flags = lambda i: struct.unpack('<i', x.rd(EVENTS_VA + 4 * i, 4))[0]  # noqa: E731
    for i, r in enumerate(run.rows):
        if r['completed'] or r['unloaded']:
            continue
        if not gate_open(r, flags) or r['type'] != 0xE4:
            continue
        why = step_refusal(sim, r['body'], i, r['phase'])
        if why:
            return why
        if r['phase'] == 0:
            put_fld(sim, 'row', i)
            put_fld(sim, 'active', 1)
        elif r['phase'] == 2:
            put_fld(sim, 'row', -1)
            put_fld(sim, 'active', 0)
    return None


def do_tick(where, x, nat, run, stats, queues, rng):
    rows = run.rows
    why = tick_refusal(x, run)
    if why:
        stats['skipped_native_refusal']['tick: ' + why] += 1
        return
    stats['ticks'] += 1
    sync_row_images(x, run)
    queues = {**default_q(rng), **queues}
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    img = x.obj_image()
    if fld(img, 'active'):
        stats['states']['visit_state_%d' % min(max(fld(img, 'state'), -1), 7)] += 1
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
                w = nat.world()
                nat.set_world([1] + w[1:])
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0xE4:
                visit_e4(where, x, nat, run, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', norm_events(x.events), expected)
    stats['ordered_events'] += len(x.events)
    check(stats, where, 'image names the loader was asked for', x.loaded, run.loaded_expected)
    check(stats, where, 'image names (native host)', nat.names(), run.loaded_expected)
    check(stats, where, 'no draw in a dispatcher pass', x.ops, [])
    run.loaded_expected = []
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


_PRE_HS = [None]


def set_pre_hs(v):
    _PRE_HS[0] = list(v)


def pre_hs(nat):
    return _PRE_HS[0]


def classify_progress(stats, pre, post, nat):
    """Coverage only: which CheckForMatch branch ran, which shuffle and high-score paths were taken."""
    m = stats['matches']
    for flag, tag in (('match_col', 'v'), ('match_row', 'h')):
        if fld(post, flag) and not fld(pre, flag):
            rl = fld(post, 'run_row_max') - fld(post, 'run_row_min')
            cl = fld(post, 'run_col_max') - fld(post, 'run_col_min')
            span = rl if tag == 'v' else cl
            m['%s_run_len_%d' % (tag, min(span + 1, 7))] += 1
            if tag == 'v':
                m['v_time_bonus3' if cl == 2 else 'v_bonus4' if rl == 3 else 'v_bonus5' if rl == 4 else 'v_no_bonus'] += 1
            else:
                m['h_bonus3' if cl == 2 else 'h_bonus4' if cl == 3 else 'h_bonus5' if cl == 4 else 'h_no_bonus'] += 1
            if tag == 'h' and fld(post, 'match_col'):
                m['cross'] += 1
    if fld(pre, 'state') != 3 and fld(post, 'state') == 3:
        m['shuffle_started'] += 1
    if fld(pre, 'state') == 6 and fld(post, 'state') != 6:
        m['score_screen_left'] += 1
    hs_pre, hs_post = pre_hs(nat), nat.world()[2:7]
    if hs_pre is not None and list(hs_pre) != list(hs_post):
        rank = next(i for i in range(5) if hs_pre[i] != hs_post[i])
        m['hs_insert_rank_%d' % rank] += 1


def visit_e4(where, x, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    set_pre_hs(nat.world()[2:7])
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, extra = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native e4r_step status %d for row %d phase %d (a native refusal the scenario must avoid)' % (
            where, status, i, phase))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    check(stats, where, 'view origin the fill read', [(a, b) for (_, a, b) in extra], [(sgn(run.view[0], 4), sgn(run.view[1], 4))] * len(extra))
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
    stats['handler_visits']['phase%d' % phase if phase in (0, 1, 2) else 'other'] += 1
    if phase == 2:
        stats['outcomes']['finish_exit' if fld(pre, 'exit') else 'finish_win' if fld(pre, 'won') else 'finish_plain'] += 1
    for e in mapped:
        if e[1] == FX['SURFACE_LOAD']:
            kind = e[2]
            run.loaded_expected.append((kind, d9.cstr(body[0:0x21] if kind == 0 else body[0x21:0x42]).decode('latin1')))
    if phase == 0:
        stats['slots'][fld(nat.obj(), 'slot')] += 1
    post = nat.obj()
    if phase == 1:
        classify_progress(stats, pre, post, nat)
    if completed:
        check(stats, where, 'native phase_after on completion (the executor applies the generic completion, which clears the phase)', phase_after, phase)
        r['phase'] = 0
    else:
        r['phase'] = phase_after


def do_pointer(where, x, nat, run, stats, rng, px, py, light=False):
    img = nat.obj()
    ri = run.body_row(img)
    if ri is None:
        stats['skipped_native_refusal']['pointer: object names a row that is not an e4 row'] += 1
        return
    body = run.rows[ri]['body']
    sync_row_images(x, run)
    stats['actions']['pointer'] += 1
    xdw = (px & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= px <= 0xFFFF else px & M32
    ydw = (py & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= py <= 0xFFFF else py & M32
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, written, kind, sub = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native e4r_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax & 0xFF, 1 if hit else 0)
    active = fld(img, 'active') != 0
    after = nat.obj()
    stats['pointer']['hit' if hit else 'inactive' if not active else 'none'] += 1
    if written:
        stats['pointer']['cursor_%#x' % cand] += 1
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32
        run.cells['c1639'] = 1
    elif hit:
        stats['pointer']['hit_without_cursor'] += 1
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)


def click_refusal(img, body, row_phase, cand):
    if not (fld(img, 'active') and fld(img, 'won') == 0 and fld(img, 'state') == 0 and img[0x8D8] == 0 and img[0x8D9] == 0 and row_phase == 1):
        return None
    if cand == CAND_PIECE:
        if not in_board(body, fld(img, 'hover_row'), fld(img, 'hover_col')):
            return 'click: hover indexes outside the board'
        if fld(img, 'no_selection') == 0 and not in_board(body, fld(img, 'sel_row'), fld(img, 'sel_col')):
            return 'click: selection indexes outside the board'
    return None


def do_click(where, x, nat, run, stats, queues, rng):
    img = nat.obj()
    ri = run.body_row(img)
    if ri is None:
        stats['skipped_native_refusal']['click: object names a row that is not an e4 row'] += 1
        return
    r = run.rows[ri]
    row = fld(img, 'row')
    row_phase = run.rows[row]['phase'] if 0 <= row < len(run.rows) else 0
    cand = run.cells['cand']
    why = click_refusal(img, r['body'], row_phase, sgn(cand, 4))
    if why:
        stats['skipped_native_refusal'][why] += 1
        return
    queues = {**default_q(rng), **queues}
    sync_row_images(x, run)
    stats['actions']['click'] += 1
    nat.set_queues(queues)
    fresh_logs(nat, run)
    pre_img = x.obj_image()
    x.run_method(queues, M_CLICK, [])
    status, fired, sound, phase_changed, phase = nat.click(r['body'], row_phase, sgn(cand, 4))
    if status != OK:
        raise Mismatch('%s: native e4r_click status %d' % (where, status))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'click: no stray host calls', extra, [])
    check(stats, where, 'click: ordered effects (busy, play, tick, phase)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    orig = norm_events(x.events)
    check(stats, where, 'click: sound_played flag equals the original issuing the play',
          int(any(e[:2] == ('fx', FX['SOUND_PLAY']) for e in orig)), int(sound))
    check(stats, where, 'click: phase_changed flag equals the original storing the row phase',
          int(any(e[:2] == ('fx', FX['PHASE']) for e in orig)), int(phase_changed))
    check(stats, where, 'click: fired flag equals the original changing the object', int(x.obj_image() != pre_img), int(fired))
    stats['clicks']['fired' if fired else 'guarded'] += 1
    if fired:
        stats['clicks']['cand_%#x' % cand] += 1
    if sound:
        stats['clicks']['sound'] += 1
    if phase_changed:
        check(stats, where, 'click: phase stored', phase, 2)
        run.rows[row]['phase'] = phase
        stats['clicks']['exit'] += 1
    fresh_logs(nat, run)
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def render_refusal(img, run):
    """The render states the kernel refuses (known divergences K4, K5): they are skipped, never run against the original."""
    row, slot = fld(img, 'row'), fld(img, 'slot')
    if not 0 <= row < len(run.rows) or run.rows[row]['type'] != 0xE4:
        return 'render: stale row of the object (no 0xe4 row installed)'
    if slot == -1:
        return 'render: slot -1'
    if not 0 <= slot < NENT:
        return 'render: slot outside the entry table'
    body = run.rows[row]['body']
    if fld(img, 'state') != 6:
        for r in range(bw(body, B['rows'])):
            for c in range(bw(body, B['cols'])):
                if img[cell_off(r, c)] != 0 and img[cell_off(r, c) + 1] == 0 and not 0 <= cell_kind(img, r, c) < bw(body, B['kinds']):
                    return 'render: present unmatched piece kind outside the body'
    return None


def do_render(where, x, nat, run, stats, ox, oy, queues):
    img = nat.obj()
    why = render_refusal(img, run)
    if why:
        stats['skipped_native_refusal'][why] += 1
        return
    row = fld(img, 'row')
    body = run.rows[row]['body']
    stats['actions']['render'] += 1
    slot = fld(img, 'slot')
    # the entry surface of the slot is what the original blits from; phase 0 stores the object's surface there: keep them equal
    surface = fld(img, 'surface') & M32
    x.w32(ENTRY + slot * STRIDE + 8, surface)
    nat.entry_set(slot, 8, surface)
    set_view(x, nat, run, (ox, oy, ox + run.view[2] - run.view[0], oy + run.view[3] - run.view[1]), run.full)
    sync_row_images(x, run)
    fresh_logs(nat, run)
    bg_cell = x.cell(CELL_BG)
    pre_entries = x.rd(ENTRY, NENT * STRIDE)
    x.run_method(queues, M_RENDER, [], 0)
    nat.set_queues(queues)
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native e4r_render status %d' % (where, plan['status']))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'render: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'render: ordered effects (text extent)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    check(stats, where, 'render: valid', plan['valid'], 1)
    check(stats, where, 'render: view rectangles read once', [e[0] for e in extra], [HC_VIEW])
    check(stats, where, 'render: view origin', (extra[0][1], extra[0][2]), (sgn(ox, 4), sgn(oy, 4)))
    ops = x.ops
    check(stats, where, 'render: op count (blits + texts)', len(ops), plan['count'])
    handle_of = {ROLE_PUZZLE: surface, ROLE_BACKGROUND: bg_cell, ROLE_SCORE: fld(img, 'score_surface') & M32}
    for k, (o, n) in enumerate(zip(ops, plan['ops'])):
        if o['op'] == 'blit':
            check(stats, where, 'render op %d: kind (blit)' % k, 1, n['kind'])
            check(stats, where, 'render op %d: label (pointer %s)' % (k, o['label_text'].decode()), o['label'], n['label'])
            check(stats, where, 'render op %d: this pointer' % k, o['this'], THIS_SURF)
            check(stats, where, 'render op %d: target surface' % k, o['target'], TARGET_HANDLE)
            check(stats, where, 'render op %d: source surface is the handle of role %d' % (k, n['role']), o['src_surface'], handle_of.get(n['role']))
            check(stats, where, 'render op %d: source rectangle contents' % k, o['src'], n['src'])
            check(stats, where, 'render op %d: destination rectangle contents' % k, o['dst'], n['dst'])
            stats['blit_labels'][o['label']] += 1
            stats['ops']['blit'] += 1
        else:
            check(stats, where, 'render op %d: kind (text)' % k, 2, n['kind'])
            check(stats, where, 'render op %d: text' % k, o['text'], n['text'])
            check(stats, where, 'render op %d: font' % k, o['font'], n['font'])
            check(stats, where, 'render op %d: parameter' % k, o['param'], n['param'])
            check(stats, where, 'render op %d: x' % k, o['x'], n['x'])
            check(stats, where, 'render op %d: y' % k, o['y'], n['y'])
            check(stats, where, 'render op %d: font image handle' % k, o['fontimg'], o['want_fontimg'])
            check(stats, where, 'render op %d: target surface' % k, o['target'], TARGET_HANDLE)
            stats['ops']['text'] += 1
    check(stats, where, 'render: no unpaired font acquire', x.pending_acq, None)
    stats['renders']['ops_%d' % min(plan['count'], 12)] += 1
    check(stats, where, 'render: entry table untouched', x.rd(ENTRY, NENT * STRIDE), pre_entries)
    fresh_logs(nat, run)
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'render', stats)
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
    fresh_logs(nat, run)
    x.run_method({}, M_INVALIDATE, [])
    if nat.invalidate() != OK:
        raise Mismatch('%s: native e4r_invalidate failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'invalidate: observed effects equal the original', norm_events(x.events), mapped)
    check(stats, where, 'invalidate: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'invalidate: effects', mapped, [norm_fx(FX['MARK_DIRTY'], slot, 0)] if marks else [])
    count_effects(stats, mapped)
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    fresh_logs(nat, run)
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats, queues):
    img = nat.obj()
    slot = fld(img, 'slot')
    if slot != -1 and not 0 <= slot < NENT:
        stats['skipped_native_refusal']['cleanup: slot outside the entry table'] += 1
        return
    stats['actions']['cleanup'] += 1
    sync_row_images(x, run)
    fresh_logs(nat, run)
    x.run_method(queues, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native e4r_cleanup failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surfaces, release slot)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    fresh_logs(nat, run)
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_scene_reset(where, x, nat, run, stats):
    stats['actions']['scene_reset'] += 1
    sync_row_images(x, run)
    fresh_logs(nat, run)
    x.run_method({}, M_SCENE_RESET, [])
    nat.scene_reset()
    check(stats, where, 'scene reset: no effects', (x.events, nat.log(0), nat.log(1)), ([], [], []))
    check_writes(where, x, 'scene_reset', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.obj_image())
    for k, v in d.items():
        if k in OBJ_POS:
            put_fld(img, k, v)
        elif k in TEXT_FIELDS:
            set_text_field(img, k, v)
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
        elif k == 'start':
            x.set_cell(CELL_START, v)
            w = nat.world()
            nat.set_world([v] + w[1:])
        elif k == 'hs':
            for i in range(5):
                x.set_cell(HS_TABLE + 4 * i, v[i])
            w = nat.world()
            nat.set_world(w[:2] + list(v))
        elif k == 'marker':
            x.set_cell(HS_MARKER, v)
            w = nat.world()
            nat.set_world([w[0], v] + w[2:])
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
        elif k == 'bg':
            x.set_cell(CELL_BG, v)
            nat.entry_set(1, 8, v)
        elif k == 'garbage_bytes':     # {offset: bytes} straight into the object image (bytes no field covers)
            for off, data in v.items():
                img[off:off + len(data)] = data
        else:
            raise d9.OracleError('unknown set key ' + k)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))


def do_kinds(x, nat, matrix):
    img = bytearray(x.obj_image())
    for r, row in enumerate(matrix):
        for c, k in enumerate(row):
            struct.pack_into('<h', img, cell_off(r, c) + 2, k)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))


def do_cellflags(x, nat, cells):
    img = bytearray(x.obj_image())
    for r, c, present, matched in cells:
        img[cell_off(r, c)] = present
        img[cell_off(r, c) + 1] = matched
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))


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
    run.clock = sc['init'].get('clock', 100000)
    seed_scenario(x, nat, run, rng)
    nat.clear_logs()
    try:
        for ai, act in enumerate(sc['actions']):
            do_action(x, nat, run, stats, rng, sc, ai, act)
        stats['scenarios'] += 1
    except (Mismatch, d9.OracleError) as error:
        raise type(error)('%s\n    last actions: %s' % (error, ' | '.join(run.trace[-5:]))) from None


def do_action(x, nat, run, stats, rng, sc, ai, act, depth=0):
    kind = act[0]
    where = '%s action %d%s %s' % (sc['id'], ai, '.%d' % depth if depth else '', kind)
    run.trace.append('%s%s' % (kind, '' if len(act) < 2 else ' ' + repr(act[1:])[:90]))
    if kind == 'tick':
        do_tick(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'pointer':
        do_pointer(where, x, nat, run, stats, rng, act[1], act[2])
    elif kind == 'probes':
        img = nat.obj()
        ri = run.body_row(img)
        if ri is None:
            stats['skipped_native_refusal']['probes: object names a row that is not an e4 row'] += 1
        else:
            pts = probe_points(run.rows[ri]['body'], img, rng, act[1] if len(act) > 1 else 12)
            for k, (px, py) in enumerate(pts):
                do_pointer(where, x, nat, run, stats, rng, px, py, light=(k % 16 != 15 and k != len(pts) - 1))
    elif kind == 'click':
        do_click(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'render':
        ext = act[3] if len(act) > 3 else rng.choice((14, 0, 20, -3, 0x7FFF, -0x8000, 1, 8))
        do_render(where, x, nat, run, stats, act[1], act[2], {'extent': [ext] * 2})
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats, act[1] if len(act) > 1 else {})
    elif kind == 'scene_reset':
        do_scene_reset(where, x, nat, run, stats)
    elif kind == 'set':
        do_set(x, nat, run, act[1])
    elif kind == 'kinds':
        do_kinds(x, nat, act[1])
    elif kind == 'cellflags':
        do_cellflags(x, nat, act[1])
    elif kind == 'view':
        set_view(x, nat, run, act[1], act[2])
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
    elif kind == 'rearm':
        for i, r in enumerate(run.rows):
            if r['type'] in ARM:
                r['completed'] = 0
                r['phase'] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
    elif kind == 'swap':
        macro_swap(where, x, nat, run, stats, rng, act[1:5], act[5] if len(act) > 5 else {}, sc, ai)
    elif kind == 'press':
        macro_press(where, x, nat, run, stats, rng, act[1], act[2] if len(act) > 2 else {}, sc, ai)
    elif kind == 'finish':
        macro_finish(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else 10, sc, ai)
    elif kind == 'bot':
        bot(x, nat, run, stats, rng, sc, ai, act[1], act[2])
    else:
        raise d9.OracleError('unknown action ' + kind)
    stats['actions'][kind] += 1


# ---------------------------------------------------------------------------------------------
# macros and the random player (they read the live object, so they steer by deadlines and states)
# ---------------------------------------------------------------------------------------------
def ensure_mode(x, nat, run):
    if nat.cells()[0] != 3:
        do_set(x, nat, run, {'mode': 3})


def advance(run, rng):
    run.clock = (run.clock + rng.choice((1, 10, 100, 499, 500, 501, 800, 1000, 5000))) & M32
    return run.clock


def live_body(nat, run):
    ri = run.body_row(nat.obj())
    return None if ri is None else run.rows[ri]['body']


def settle_tick(x, nat, run, stats, rng, sub):
    """One dispatcher pass with the clock steered by the live state (deadlines hit exactly, one early, one late)."""
    img = nat.obj()
    state = fld(img, 'state')
    ensure_mode(x, nat, run)
    jitter = rng.choice((-1, 0, 0, 1, 7, 799))
    if state == 2:
        t = (fld(img, 'deadline') + jitter) & M32
    elif state == 3:
        t = (fld(img, 'shuffle_end') + jitter) & M32
    elif state in (5, 6):
        t = (fld(img, 'deadline') + jitter) & M32
    elif state == 0 and rng.random() < 0.3:
        t = (fld(img, 'time_end') - rng.choice((0, 499, 500, 501, 1000)) + jitter) & M32
    else:
        t = advance(run, rng)
    run.clock = t
    busy = [rng.choice((0, 0, 1, 2, M32, 0x100, 0x10000))] * 6
    sub(('tick', dict(tick=[t] * 12, busy=busy, rand=[rng.getrandbits(15) for _ in range(700)])))


def macro_swap(where, x, nat, run, stats, rng, cells, opts, sc, ai):
    """pointer onto piece A, click, pointer onto piece B, click, then ticks through the check and the refill."""
    sub = lambda a, k=0: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    (r1, c1, r2, c2) = cells
    img = nat.obj()
    body = live_body(nat, run)
    if body is None or not (in_board(body, r1, c1) and in_board(body, r2, c2)):
        stats['skipped_native_refusal']['swap macro: cells outside the board'] += 1
        return
    q = dict(tick=[advance(run, rng)] * 4, busy=[rng.choice((0, 0, 1, M32))] * 4)
    sub(('pointer',) + center_of(cell_rect(img, r1, c1)), 1)
    sub(('click', q), 2)
    img = nat.obj()
    sub(('pointer',) + center_of(cell_rect(img, r2, c2)), 3)
    sub(('click', q), 4)
    for k in range(opts.get('ticks', 6)):
        if not fld(nat.obj(), 'active'):
            break
        settle_tick(x, nat, run, stats, rng, lambda a, k=k: sub(a, 5 + k))
        if rng.random() < 0.4:
            sub(('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))), 5 + k)


def macro_press(where, x, nat, run, stats, rng, which, opts, sc, ai):
    """pointer onto the shuffle or exit button, click, render, ticks."""
    sub = lambda a, k=0: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    body = live_body(nat, run)
    if body is None:
        return
    rect = body_rect(body, B['shuffle_rect'] if which == 'shuffle' else B['exit_rect'])
    sub(('pointer',) + center_of(rect), 1)
    q = dict(tick=[opts.get('tick', advance(run, rng))] * 4, busy=[rng.choice((0, 0, 1, 2))] * 4)
    sub(('click', q), 2)
    if rng.random() < 0.9:
        sub(('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))), 3)
    for k in range(opts.get('ticks', 2)):
        if fld(nat.obj(), 'active'):
            settle_tick(x, nat, run, stats, rng, lambda a, k=k: sub(a, 4 + k))
    if rng.random() < 0.9:
        sub(('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))), 9)


def macro_finish(where, x, nat, run, stats, rng, max_steps, sc, ai):
    """tick through the states steering by the deadlines and the busy answers until the object finished."""
    sub = lambda a, k=0: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    for k in range(max_steps):
        if not fld(nat.obj(), 'active'):
            break
        settle_tick(x, nat, run, stats, rng, lambda a, k=k: sub(a, k + 1))
        if rng.random() < 0.3:
            sub(('render', 0, 0), k + 1)


def rand_matrix(rng, rows, cols, kinds, palette):
    return [[rng.choice(palette) for _ in range(cols)] for _ in range(rows)]


def bot(x, nat, run, stats, rng, sc, ai, steps, profile):
    sub = lambda a, k=0: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    weights = {'play': (('swap', 7), ('tick', 3), ('pointer_rand', 1.5), ('click', 2), ('render', 3), ('invalidate', 0.4), ('cleanup', 0.1),
                        ('shuffle', 1.0), ('exit', 0.15), ('finish', 0.8), ('runs', 3), ('score', 1.0), ('probes', 0.3)),
               'win': (('swap', 8), ('tick', 1), ('render', 2), ('finish', 3), ('runs', 4), ('score', 3)),
               'chaos': (('swap', 2), ('tick', 3), ('pointer_rand', 2.5), ('click', 3), ('render', 3), ('invalidate', 1), ('cleanup', 0.3),
                         ('shuffle', 1), ('exit', 0.4), ('finish', 1), ('runs', 2), ('score', 1.5), ('probes', 0.5), ('scene_reset', 0.3))}[profile]
    names = [w[0] for w in weights]
    wts = [w[1] for w in weights]
    for k in range(steps):
        img = nat.obj()
        body = live_body(nat, run)
        choice = rng.choices(names, wts)[0]
        active = fld(img, 'active') != 0
        if body is None:
            return
        rows, cols = bw(body, B['rows']), bw(body, B['cols'])
        if choice == 'swap' and active:
            sub(('swap', rng.randrange(rows), rng.randrange(cols), rng.randrange(rows), rng.randrange(cols), dict(ticks=rng.choice((2, 4, 6)))), k)
        elif choice == 'tick' or (choice == 'swap' and not active):
            if not active and run.rows[run.e4_rows()[0]]['phase'] != 0:
                sub(('rearm',), k)
            ensure_mode(x, nat, run)
            sub(('tick', dict(tick=[advance(run, rng)] * 12, busy=[rng.choice((0, 1, 2))] * 6)), k)
        elif choice == 'pointer_rand':
            sub(('pointer', rng.randint(-50, 700), rng.randint(-50, 500)), k)
        elif choice == 'probes':
            sub(('probes', 4), k)
        elif choice == 'click':
            sub(('click', dict(tick=[advance(run, rng)] * 4, busy=[rng.choice((0, 1, 2))] * 4)), k)
        elif choice == 'render':
            sub(('render', rng.choice((0, 5, -7)), rng.choice((0, 3))), k)
        elif choice == 'invalidate':
            sub(('invalidate',), k)
        elif choice == 'cleanup':
            sub(('cleanup',), k)
        elif choice == 'shuffle' and active:
            sub(('press', 'shuffle', dict(ticks=rng.choice((1, 2, 3)))), k)
        elif choice == 'exit' and active:
            sub(('press', 'exit', dict(ticks=2)), k)
        elif choice == 'finish':
            sub(('finish', rng.choice((3, 6, 10))), k)
        elif choice == 'runs' and active:
            kinds = bw(body, B['kinds'])
            palette = list(range(max(2, min(kinds - 1, rng.choice((2, 3, 4, kinds - 1))))))
            sub(('kinds', rand_matrix(rng, rows, cols, kinds, palette)), k)
        elif choice == 'score' and active:
            tgt = struct.unpack_from('<i', body, B['target'])[0]
            sub(('set', dict(score=rng.choice((0, tgt - 1, tgt, tgt + 1, -1, 123456, tgt - 3)))), k)
        elif choice == 'scene_reset':
            sub(('scene_reset',), k)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
HANDLES = [0x4441, 0, M32, 1, 0x7FFFFFFF]
BUSY_SEEDS = [[], [0x18], [0x18, 0x19, 0x1A], [0x18, 0x1A, 0x1B, 0x3E], list(range(0x18, 0x3F)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]]
T0 = 100000


def R_E4(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xE4, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def scenario_list(seed=0xE454):
    rng = random.Random(seed)
    scs = []
    reals = real_bodies()

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        return make_body(rng, **kw)

    def boot(**q):
        return tk(**{'tick': [T0] * 4, **q})

    def pal_matrix(rows, cols, palette):
        return rand_matrix(rng, rows, cols, 0, palette)

    # ---- phase 0 -------------------------------------------------------------------------------------------------------------------------
    names_pool = [b'JAN_Glyph', b'A', b'x' * 32, b'Puzzle Surface']
    shapes = [(5, 7, 26), (1, 1, 4), (1, 10, 6), (10, 1, 30), (10, 10, 30), (3, 4, 5), (2, 2, 4), (6, 9, 12)]
    for k in range(36):
        rows_, cols_, kinds_ = shapes[k % len(shapes)]
        body = mk(name=names_pool[k % 4], score_name=[b'', b'ScoreSurf', b'S' * 32][k % 3], rows=rows_, cols=cols_, kinds=kinds_,
                  time=rng.choice((0, 61, -5, 1, 32767)), target=rng.choice((0, 2500, -3, 0x7FFFFFFF, 1)),
                  snds={s: SND_KINDS[(k + i) % len(SND_KINDS)] for i, s in enumerate('abcd')},
                  font=rng.randrange(18), param=rng.choice((0, 7, -1, 0x7FFF)), layout=rng.choice(('grid', 'tight', 'overlap', 'neg')),
                  geometry=dict(piece=rng.choice(((40, 40), (1, 1), (64, 33), (0, 0), (30000, 30000), (65576, 40), (40, 65576), (-65496, 70000), (32808, 32808))), xoff=rng.choice((31, -40, 32767, -32768)),
                                yoff=rng.choice((17, 0, 32767)), ygap=rng.choice((3, -2, 100)), xgap=rng.choice((2, 0, -7, 32767))))
        init = dict(busy_slots=BUSY_SEEDS[k % len(BUSY_SEEDS)] if k % 7 != 4 else [0x18, 0x19],
                    obj=dict(surface=rng.choice((0, 0, 0x5151)), score_surface=rng.choice((0, 0, 0x5252)), slot=rng.choice((-1, 0x19, 0x30)),
                             row=rng.choice((-1, 0)), active=rng.choice((0, 1)), state=rng.choice((0, 3, 6))),
                    view=rng.choice(((0, 0, 639, 479), (13, -9, 700, 500), (-200, 50, 0, 100), (0x7FFFFFF0, 5, 0, 0))))
        S('init:%d_%dx%dk%d' % (k, rows_, cols_, kinds_), [R_E4(body)],
          [tk(handle=[HANDLES[k % 5], HANDLES[(k + 1) % 5]]), ('render', 0, 0), tk(), ('cleanup',), ('rearm',),
           tk(handle=[HANDLES[(k + 2) % 5], HANDLES[(k + 3) % 5]]), tk(), ('render', 3, 4), ('invalidate',)], 'init', init=init,
          quick=k in (0, 5, 11, 22))
    S('init:slot_exhaustion_but_last', [R_E4(mk())], [tk(), tk(), ('cleanup',)], 'init', init=dict(busy_slots=list(range(0x18, 0x3F))), quick=True)
    S('init:garbage_survives', [R_E4(mk())], [tk(), tk(), tk(), ('render', 1, 1)], 'init',
      init=dict(obj=dict(state=5, deadline=0x1234, won=1), texts=dict(name_text=b'garbage name', time_text=b'xx')), quick=True)
    for k, real in enumerate(reals):
        S('init:real_body_%d' % k, [R_E4(real)], [tk(), ('render', 0, 0), tk(), ('render', 3, 4), ('cleanup',)], 'init', quick=k == 0)
    # board neighbours: the fill avoids the cell above and the cell to the left
    for kinds_ in (4, 5, 30):
        S('init:fill_kinds%d' % kinds_, [R_E4(mk(rows=8, cols=8, kinds=kinds_))], [tk(), ('render', 0, 0)], 'init')

    # negative and huge rand values (the CRT never returns them, the kernel and the original must still agree on the signed remainder)
    EXT = [-1, -32768, -7, 0x7FFFFFFF, -0x80000000, 0xFFFF, 0x10000, 1 << 20, 0]
    for k, kinds_ in enumerate((4, 5, 9, 30)):
        S('init:fill_rand_extremes%d' % k, [R_E4(mk(rows=4, cols=5, kinds=kinds_))],
          [tk(rand=[rng.choice(EXT) if rng.random() < 0.7 else rng.getrandbits(15) for _ in range(900)]), ('render', 0, 0)], 'init')

    # ---- phase 1 state matrix --------------------------------------------------------------------------------------------------------------
    def state_case(sid, st, setd, tick_q, body_kw=None, post=None, quick=False, extra_actions=()):
        body = mk(**{**dict(rows=4, cols=5, kinds=8, time=61, target=900, per=7, bonus=(11, 222, 33, 444, 55)), **(body_kw or {})})
        acts = [boot(), ('set', {**setd, 'state': st}), *extra_actions, tk(**tick_q), ('render', 0, 0)]
        if post:
            acts += post
        S(sid, [R_E4(body)], acts, 'state', quick=quick)

    for st in (0, 1, 2, 3, 4, 5, 6, 7, 9, -1, 0x7FFFFFFF):
        for name, setd, q in (
                ('plain', {}, dict(tick=[T0 + 5] * 12)),
                ('deadline_before', dict(deadline=T0 + 10, shuffle_end=T0 + 10), dict(tick=[T0 + 9] * 12, busy=[0, 0, 0, 0, 0, 0])),
                ('deadline_equal', dict(deadline=T0 + 10, shuffle_end=T0 + 10), dict(tick=[T0 + 10] * 12, busy=[0, 0, 0, 1, 0, 0])),
                ('deadline_after', dict(deadline=T0 + 10, shuffle_end=T0 + 10), dict(tick=[T0 + 11] * 12, busy=[1, 0, 0, 0, 1, 1])),
                ('wrap', dict(deadline=0xFFFFFFF0, shuffle_end=5, time_end=0xFFFFFFFF), dict(tick=[0xFFFFFFFF, 0xFFFFFFFF, 3, 3, 3, 3])),
                ('wrap2', dict(deadline=5, shuffle_end=0xFFFFFFF0, time_end=2), dict(tick=[0xFFFFFFF8] * 12, busy=[0] * 6))):
            state_case('state%d:%s' % (st, name), st, {**setd, 'score': 0}, q, quick=(st in (2, 6) and name == 'plain'),
                       extra_actions=[('cellflags', [(0, 1, 1, 1), (1, 1, 1, 1), (2, 1, 1, 1), (3, 3, 1, 1)])] if st == 2 else [])
    # state 0 detail: time left against 500 ms, target, limit sign
    for limit in (0, 61, -5, 1):
        for left in (-1, 0, 1, 499, 500, 501, 59999, 60000, 3599000, 3600000, 3600001, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF):
            for score in (0, 899, 900, 901, -900):
                if rng.random() < 0.55:
                    continue
                state_case('state0:limit%d_left%d_score%d' % (limit, left, score), 0, dict(score=score, time_end=(T0 + 5 + left) & M32),
                           dict(tick=[T0 + 5] * 12), body_kw=dict(time=limit), post=[tk(tick=[T0 + 9] * 12)])
    for tgt in (0, 1, -1, 5, 0x7FFFFFFF, -0x80000000):
        for score in (-1, 0, 1, 4, 5, 6, 0x7FFFFFFF, -0x80000000):
            for limit in (0, 30):
                if rng.random() < 0.6:
                    continue
                state_case('state0:target%d_score%d_limit%d' % (tgt, score, limit), 0, dict(score=score, time_end=T0 + 100000),
                           dict(tick=[T0 + 5] * 12), body_kw=dict(target=tgt, time=limit), post=[tk(tick=[T0 + 6] * 12), ('render', 0, 0)])
    # end sound, end delay, final delay
    for dsnd in ('none', 'real', 'near1'):
        for fd in (0, 1, -1, 32767):
            for ed in (0, 2, -3):
                state_case('end:snd%s_fd%d_ed%d' % (dsnd, fd, ed), 1, dict(), dict(tick=[T0 + 5] * 12), body_kw=dict(snds=dict(d=dsnd), final_delay=fd, end_delay=ed),
                           post=[('set', dict(state=5, deadline=T0 + 5 + fd * 1000)), tk(tick=[T0 + 5 + fd * 1000] * 12),
                                 tk(tick=[T0 + 9] * 12, busy=[0, 1, 0, 1, 0, 0]), tk(tick=[T0 + 20] * 12, busy=[1] * 6),
                                 ('set', dict(state=4)), tk(tick=[T0 + 30] * 12, busy=[0] * 6),
                                 tk(tick=[T0 + 30 + ed * 1000] * 12), ('render', 0, 0)])

    # ---- CheckForMatch: every bonus branch, vertical and horizontal, 3/4/5/6-runs, crosses, bounds of the board ---------------------------
    BONUS = (11, 222, 33, 444, 55)
    for rows_, cols_ in ((5, 7), (7, 5), (1, 10), (10, 1), (3, 3), (10, 10), (4, 6), (6, 4)):
        for orient in ('v', 'h', 'cross', 'two'):
            for run_len in (2, 3, 4, 5, 6):
                if rng.random() < 0.5:
                    continue
                kinds_ = 12
                rr, cc = rng.randrange(rows_), rng.randrange(cols_)
                m = [[(r * 3 + c * 5 + (r // 2) + 1) % 7 for c in range(cols_)] for r in range(rows_)]   # no run longer than 2 in this pattern
                for r in range(rows_):
                    for c in range(cols_):
                        m[r][c] = 1 + (r + 2 * c) % 6
                kind = 9
                if orient in ('v', 'cross', 'two'):
                    for d in range(run_len):
                        if rr - d >= 0 and d < run_len:
                            m[rr - d][cc] = kind
                if orient in ('h', 'cross'):
                    for d in range(run_len):
                        if cc + d < cols_:
                            m[rr][cc + d] = kind
                body = mk(rows=rows_, cols=cols_, kinds=kinds_, time=rng.choice((0, 61)), target=100000, per=7, bonus=BONUS,
                          kind_names=[b'', b'one', b'x' * 32, b'four'])
                which = rng.choice(('first', 'second', 'both'))
                setd = dict(state=0, check_first=1 if which in ('first', 'both') else 0, check_second=1 if which in ('second', 'both') else 0,
                            sel_row=rr, sel_col=cc, swap_row=rr, swap_col=cc, time_end=T0 + 61000, score=rng.choice((0, 5)))
                S('match:%dx%d_%s_len%d_%s' % (rows_, cols_, orient, run_len, which), [R_E4(body)],
                  [boot(), ('kinds', m), ('set', setd), tk(tick=[T0 + 5] * 12), ('render', 2, 3), tk(tick=[T0 + 6] * 12), tk(tick=[T0 + 7] * 12),
                   tk(tick=[T0 + 900] * 12, busy=[0, 0, 0, 0, 0, 0]), tk(tick=[T0 + 901] * 12, busy=[0] * 6), ('render', 0, 0)], 'match',
                  quick=(rows_, cols_, orient, run_len) == (5, 7, 'cross', 5))
    # extreme score / bonus arithmetic (wrap-around of the dword sums)
    for k in range(10):
        body = mk(rows=3, cols=3, kinds=6, per=rng.choice((32767, -32768, 1, 0)), bonus=tuple(rng.choice((32767, -32768, 0, 1, -1)) for _ in range(5)),
                  time=rng.choice((0, 61)))
        S('match:extreme%d' % k, [R_E4(body)],
          [boot(), ('kinds', [[2, 2, 2], [2, 2, 2], [2, 2, 2]]),
           ('set', dict(check_first=1, sel_row=1, sel_col=1, score=rng.choice((0x7FFFFFF0, -5, 0)), time_end=rng.choice((0xFFFFFF00, T0)))),
           tk(), tk(), tk(tick=[T0 + 1000] * 12), ('render', 0, 0)], 'match')

    # ---- the real play path: pointer + click select, pointer + click swap, ticks through the check and the refill ------------------------
    for k in range(40):
        rows_, cols_ = rng.choice(((5, 7), (4, 4), (3, 6), (8, 8), (2, 5)))
        kinds_ = rng.choice((5, 8, 26))
        body = mk(rows=rows_, cols=cols_, kinds=kinds_, time=rng.choice((0, 61, 41)), target=rng.choice((300, 2500, 100000)),
                  snds={s: rng.choice(SND_KINDS) for s in 'abcd'}, bonus=BONUS, per=rng.choice((7, 50)),
                  layout=rng.choice(('grid', 'tight', 'adjacent')))
        acts = [boot(handle=[0x4441, 0x4442]), ('render', 0, 0)]
        for t in range(rng.choice((2, 4))):
            m = pal_matrix(rows_, cols_, list(range(rng.choice((2, 3, 4, min(kinds_ - 1, 6))))))
            acts += [('kinds', m), ('swap', rng.randrange(rows_), rng.randrange(cols_), rng.randrange(rows_), rng.randrange(cols_))]
        S('swap:%d' % k, [R_E4(body)], acts, 'swap', quick=k in (0, 1, 2))
    # swaps next to each other that build a run in neither / one / both pieces
    for k in range(18):
        rows_, cols_ = 5, 7
        body = mk(rows=rows_, cols=cols_, kinds=10, time=61, target=100000, bonus=BONUS, per=7, snds=dict(a='real', c='real2'))
        base = [[1 + (r + 2 * c) % 5 for c in range(cols_)] for r in range(rows_)]
        r1, c1 = rng.randrange(1, rows_ - 1), rng.randrange(1, cols_ - 3)
        r2, c2 = (r1, c1 + 1) if k % 2 == 0 else (r1 + 1, c1)
        mode = k % 3
        m = [row[:] for row in base]
        a, b = 9, 8
        m[r1][c1], m[r2][c2] = (a, b) if k % 2 == 0 else (b, a)
        if mode in (0, 2):                      # after the swap a sits at (r2, c2) with a run of three on its row/column
            for d in (1, 2):
                if c2 + d < cols_:
                    m[r2][c2 + d] = a
        if mode in (1, 2):                      # after the swap b sits at (r1, c1) with a vertical run
            for d in (1, 2):
                if r1 - d >= 0:
                    m[r1 - d][c1] = b
        S('swap:build%d' % k, [R_E4(body)], [boot(), ('kinds', m), ('swap', r1, c1, r2, c2, dict(ticks=8)), ('render', 0, 0)], 'swap')
    # the second piece is only checked on a later visit and only when the first check did not start the refill
    for k in range(8):
        body = mk(rows=4, cols=4, kinds=9, time=61, target=100000, bonus=BONUS, per=7)
        m = [[1 + (r + 2 * c) % 5 for c in range(4)] for r in range(4)]
        for c in range(3):
            m[0][c] = 8
        for r in range(3):
            m[r][3] = 7
        S('swap:later_second%d' % k, [R_E4(body)],
          [boot(), ('kinds', m), ('set', dict(check_first=1, check_second=1, sel_row=0, sel_col=1, swap_row=2, swap_col=3, state=0,
                                              time_end=T0 + 61000)),
           tk(tick=[T0 + 1] * 12), tk(tick=[T0 + 2] * 12), tk(tick=[T0 + 3] * 12), tk(tick=[T0 + 900] * 12, busy=[0] * 6), tk(tick=[T0 + 901] * 12),
           tk(tick=[T0 + 902] * 12), ('render', 0, 0)], 'swap')

    # ---- shuffle -------------------------------------------------------------------------------------------------------------------------
    for k in range(14):
        body = mk(rows=rng.choice((3, 5)), cols=rng.choice((3, 7)), kinds=rng.choice((6, 26)), time=rng.choice((0, 61)), target=100000,
                  snds={'b': rng.choice(SND_KINDS)}, layout=rng.choice(('grid', 'adjacent', 'overlap')))
        S('shuffle:%d' % k, [R_E4(body)],
          [boot(), ('press', 'shuffle', dict(ticks=0)), ('render', 0, 0), tk(tick=[T0 + 249] * 12), tk(tick=[T0 + 250] * 12),
           ('render', 1, 1), ('render', 1, 1), tk(tick=[T0 + 251] * 12), ('press', 'shuffle', dict(ticks=3))], 'shuffle', quick=k == 0)

    # ---- the high score screen -----------------------------------------------------------------------------------------------------------
    HS_LISTS = ([500, 400, 300, 200, 100], [0, 0, 0, 0, 0], [900, 800, 700, 600, 500], [-1, -2, -3, -4, -5], [100, 100, 100, 100, 100],
                [0x7FFFFFFF, 5, 4, 3, 2], [-0x80000000, -0x80000000, 0, 0, 0])
    for k in range(30):
        hs = HS_LISTS[k % len(HS_LISTS)]
        score = rng.choice((600, 450, 350, 250, 150, 50, 500, 100, 0, -1, 0x7FFFFFFF, -0x80000000, 1000, 800, 5))
        won = rng.choice((0, 1, 0, 1, 2))
        limit = rng.choice((0, 61, -5))
        body = mk(rows=3, cols=3, kinds=6, time=limit, target=100000, hs=rng.choice(((210, 100, 340, 130), (0, 0, 0, 0), (-5, 32767, 70000, -70000))),
                  font=rng.randrange(18), title=rng.choice((b'', b'Match', b'T' * 32)), score_panel=rng.choice((0, 1)), end_delay=rng.choice((0, 2)))
        S('scores:%d' % k, [R_E4(body)],
          [boot(), ('set', dict(state=6, score=score, won=won, deadline=T0 + 100, hs=hs, score_text=b'%d' % (score & M32))),
           tk(tick=[T0 + 99] * 12), ('render', 0, 0), ('set', dict(erase_all=rng.choice((0, 1)))), ('render', 7, -3), tk(tick=[T0 + 100] * 12),
           ('render', 0, 0), tk(tick=[T0 + 101] * 12), tk(tick=[T0 + 102] * 12), ('render', 0, 0)], 'scores', quick=k in (0, 1))
    S('scores:reset', [R_E4(mk())], [boot(), ('scene_reset',), ('set', dict(hs=[5, 4, 3, 2, 1], marker=77)), ('scene_reset',)], 'scores')
    for k in range(5):
        S('scores:reset_garbage%d' % k, [R_E4(mk())], [('scene_reset',), boot(), ('scene_reset',)], 'scores', init=dict(hs=HS_LISTS[k], marker=0x1234))

    # ---- finish: phase 2 ---------------------------------------------------------------------------------------------------------------------
    FLAGS = ((-1, 0), (0, 7), (339, 5), (340, 9), (1010, 300), (2047, 1), (4095, 255), (1000, 0x80))
    for k in range(48):
        flag_w, flag_x = FLAGS[k % len(FLAGS)], FLAGS[(k + 3) % len(FLAGS)]
        win = rng.choice((block(9999, flag=flag_w[0], value=flag_w[1], start=1), rand_block(rng, 1299, flag_w[0]), rand_block(rng, 0, flag_w[0]),
                          rand_block(rng, -5, flag_w[0]), rand_block(rng, 0x2710, flag_w[0]), block(9999)))
        exitb = rng.choice((block(9999, flag=flag_x[0], value=flag_x[1], start=0), rand_block(rng, 1298, flag_x[0]), rand_block(rng, 0x4E, flag_x[0]),
                            block(0, (1, 2, 3), (4, 5, 6), 1, flag_x[0], flag_x[1]), block(9999)))
        win['value'], exitb['value'] = flag_w[1] if win['flag'] == flag_w[0] else win['value'], exitb['value']
        body = mk(rows=3, cols=3, kinds=7, time=rng.choice((0, 61)), target=100000, snds={s: rng.choice(SND_KINDS) for s in 'abcd'}, win=win,
                  exitb=exitb, name_panel=rng.choice((0, 1)), font=rng.randrange(18))
        sub_ = 1 + (k % 2)
        outcome = ('exit', 'won', 'plain')[k % 3]
        setd = dict(won=1 if outcome == 'won' else 0, exit=1 if outcome == 'exit' else 0)
        if outcome == 'plain':
            setd['won'] = rng.choice((0, 0, 1))
        rows = [R_E4(body, subtype=sub_)]
        if k % 4 == 3:
            rows = [R67(), R_E4(body, subtype=sub_), R67(loaded=3)]
        ri = 1 if k % 4 == 3 else 0
        S('finish:%d_%s_sub%d' % (k, outcome, sub_), rows,
          [boot(), ('set', setd), ('setphase', ri, 2), tk(), ('render', 0, 0), ('rearm',), tk(), tk(), ('cleanup',)], 'finish', quick=k in (0, 1, 2, 5))
    # the exit button and the target score end to end
    for k in range(10):
        body = mk(rows=3, cols=4, kinds=6, time=rng.choice((0, 61)), target=rng.choice((500, 100000)), exitb=rand_block(rng, 1298, rng.choice((-1, 3, 4095))),
                  win=rand_block(rng, 1299, rng.choice((-1, 7, 0))), layout=rng.choice(('tight', 'grid')))
        S('finish:buttons%d' % k, [R_E4(body, subtype=1 + k % 2)],
          [boot(), ('press', 'exit', dict(ticks=2)), ('rearm',), tk(), ('set', dict(score=600)), tk(tick=[T0 + 5] * 12), ('finish', 8)], 'finish')

    # ---- pointer -----------------------------------------------------------------------------------------------------------------------------
    for k in range(24):
        layout = ('tight', 'grid', 'adjacent', 'overlap', 'neg', 'extreme', 'inverted', 'wide')[k % 8]
        body = mk(rows=rng.choice((2, 5, 10)), cols=rng.choice((2, 7, 10)), kinds=8, layout=layout,
                  geometry=dict(piece=rng.choice(((40, 40), (6, 6), (7, 5), (3, 3))), xgap=rng.choice((2, -3, 0)), ygap=rng.choice((3, 0, -2))))
        init = dict(view=rng.choice(((0, 0, 639, 479), (21, -33, 700, 500))))
        S('pointer:%d_%s' % (k, layout), [R_E4(body)],
          [('probes', 4), boot(), ('probes', 10), ('set', dict(state=2)), ('probes', 4), ('set', dict(state=6)), ('probes', 4),
           ('set', dict(state=3, active=0)), ('probes', 4)], 'pointer', init=init, quick=k in (0, 2))

    # ---- click guard matrix ----------------------------------------------------------------------------------------------------------------
    for k in range(60):
        body = mk(rows=3, cols=4, kinds=7, snds={'b': rng.choice(SND_KINDS), 'c': rng.choice(SND_KINDS)}, chans=dict(b=rng.choice((1, -1, 0x7FFF)), c=rng.choice((2, 0))))
        cand = rng.choice((CAND_PIECE, CAND_PIECE, CAND_EXIT, CAND_SHUFFLE, 0, -1, 0x27D4, 0x27D8, 0x10000 + CAND_PIECE))
        setd = dict(active=1, won=0, state=0, check_first=0, check_second=0, no_selection=rng.choice((0, 1, 5, 0x100, M32)),
                    hover_row=rng.randrange(3), hover_col=rng.randrange(4), sel_row=rng.randrange(3), sel_col=rng.randrange(4))
        broken = rng.choice(('none', 'none', 'active', 'won', 'state', 'first', 'second', 'phase'))
        busy_v = rng.choice((0, 1, M32, 0x10000, 0x100, 0x1000000))
        if broken == 'active':
            setd['active'] = 0
        elif broken == 'won':
            setd['won'] = rng.choice((1, 2, M32, 0x100, 0x10000))
        elif broken == 'state':
            setd['state'] = rng.choice((1, 2, 3, 6, 7, -1))
        elif broken == 'first':
            setd['check_first'] = rng.choice((1, 2, 0xFF))
        elif broken == 'second':
            setd['check_second'] = rng.choice((1, 2, 0xFF))
        acts = [boot(), ('set', {**setd, 'cand': cand & M32})]
        if broken == 'phase':
            acts.append(('setphase', 0, rng.choice((0, 2, 3, M32, 1 << 16))))
        acts += [('click', dict(tick=[T0 + 77] * 4, busy=[busy_v] * 4)), ('render', 0, 0),
                 ('click', dict(tick=[T0 + 78] * 4, busy=[0] * 4)), ('set', dict(state=0, check_first=0, check_second=0, cand=cand & M32)),
                 ('click', dict(tick=[T0 + 79] * 4, busy=[0] * 4))]
        S('click:%d_%s_%#x' % (k, broken, cand & 0xFFFFF), [R_E4(body)], acts, 'click', quick=k < 3)

    # deterministic guard / busy / flag corner cases of the click
    for k, (cand, sel, busy_v, sndk) in enumerate([(CAND_PIECE, 1, 0x100, 'real'), (CAND_PIECE, 0, 0x10000, 'real'), (CAND_SHUFFLE, 1, 0x100, 'real2'),
                                                    (CAND_SHUFFLE, 1, 0x1000000, 'real'), (CAND_PIECE, 0x100, 0, 'real'), (CAND_PIECE, M32, 0, 'real'),
                                                    (CAND_EXIT, 1, 0, 'none')]):
        body = mk(rows=3, cols=4, kinds=7, snds={'b': sndk, 'c': sndk})
        S('click:det%d' % k, [R_E4(body)],
          [boot(), ('set', dict(cand=cand & M32, no_selection=sel, hover_row=1, hover_col=2, sel_row=0, sel_col=3)),
           ('click', dict(tick=[T0 + 70] * 4, busy=[busy_v] * 4)), ('click', dict(tick=[T0 + 71] * 4, busy=[0] * 4)), ('render', 0, 0)], 'click', quick=k == 0)
    for k, (ph, won, extra) in enumerate([(0, 0, {}), (2, 0, {}), (3, 0, {}), (1 << 16, 0, {}), (1, 2, {}), (1, 0x100, {}), (1, 0x10000, {}), (1, 0, dict(state=7)),
                                           (1, 0, dict(check_first=0x100)), (1, 0, dict(check_second=0x100))]):
        S('click:guard%d' % k, [R_E4(mk(rows=3, cols=4, kinds=7, snds={'c': 'real'}))],
          [boot(), ('set', dict(cand=CAND_PIECE, no_selection=1, hover_row=1, hover_col=1, won=won, **extra)), ('setphase', 0, ph),
           ('click', dict(tick=[T0 + 70] * 4, busy=[0] * 4))], 'click')
    # selections outside the board are only an error when the check that reads them runs
    for k, setd in enumerate([dict(state=2, check_first=1, sel_row=9, sel_col=9), dict(state=5, check_second=1, swap_row=-3, swap_col=40),
                              dict(state=0, check_first=1, check_second=1, sel_row=1, sel_col=1, swap_row=9, swap_col=9),
                              dict(state=3, check_first=1, check_second=1, sel_row=77, sel_col=-4, swap_row=9, swap_col=9)]):
        S('guard:selection%d' % k, [R_E4(mk(rows=3, cols=4, kinds=7))],
          [boot(), ('set', {**setd, 'time_end': T0 + 90000, 'deadline': T0 + 50, 'shuffle_end': T0 + 50}), tk(tick=[T0 + 10] * 12), tk(tick=[T0 + 60] * 12), ('render', 0, 0)], 'state')
    # both finish flags set: the exit block wins; the start flag of the world is rewritten on phase 2
    for k, (wf, ef, start) in enumerate([(5000, 3, 0), (3, 5000, 0), (3, 4, 1), (-1, 7, 0), (7, -1, 0)]):
        body = mk(rows=3, cols=3, kinds=6, win=block(9999, flag=wf, value=5, start=1), exitb=block(9999, flag=ef, value=9, start=0))
        S('finish:both%d' % k, [R_E4(body)],
          [boot(), ('set', dict(won=1, exit=1, start=start)), ('setphase', 0, 2), tk(), ('render', 0, 0)], 'finish', quick=k == 0)
    for k in range(4):
        body = mk(rows=3, cols=3, kinds=6, win=block(9999, flag=-1), exitb=block(9999, flag=-1))
        S('finish:startflag%d' % k, [R_E4(body)], [boot(), ('set', dict(won=k % 2, exit=(k // 2) % 2, start=0)), ('setphase', 0, 2), tk()], 'finish')
    # refill state with matched marks other than 1 (only a byte equal to 1 is refilled)
    for k, mv in enumerate((2, 0xFF, 0x80, 1)):
        body = mk(rows=3, cols=4, kinds=9)
        S('refill:matched%d' % k, [R_E4(body)],
          [boot(), ('cellflags', [(0, 1, 1, mv), (1, 2, 1, mv), (2, 3, 1, 1)]), ('set', dict(state=2, deadline=T0 + 5)), tk(tick=[T0 + 9] * 12),
           ('render', 0, 0)], 'state')
    # text and view arithmetic beyond 16 bits
    for k, v in enumerate(((70000, -70000, 700, 500), (40000, 40000, 0, 0), (-33000, 33000, 0, 0))):
        body = mk(rows=3, cols=3, kinds=6, name_panel=1, score_panel=1, title=b'Title', time=61, font=3, param=5)
        S('render:bigview%d' % k, [R_E4(body)], [boot(), ('set', dict(show_name=1, name_text=b'abc', state=0)), ('render', 0, 0), ('swap', 0, 0, 0, 1),
                                                    ('set', dict(state=6)), ('render', 0, 0)], 'render', init=dict(view=v))
    # a rectangle that is 1 or 0 high at the lowest y (pointer arithmetic at the edge of the dword)
    for k, (view, piece) in enumerate((((0, -0x80000000, 639, 479), (40, 1)), ((0x7FFFFFF0, 0, 0, 0), (40, 40)), ((0, 0x7FFFFFF0, 0, 0), (40, 40)),
                                       ((-0x80000000, -0x80000000, 0, 0), (1, 1)),
                                       # negative piece size: left + 3 wraps (0x475e4e is a 32-bit add) while right = left - 40 does not
                                       ((0x7FFFFFFE, 0x7FFFFFFE, 0, 0), (-40, -40)), ((0x7FFFFFFD, 0, 0, 0), (-40, 40)),
                                       ((0, 0x7FFFFFFF, 0, 0), (40, -40)), ((-0x7FFFFFFF, -0x7FFFFFFF, 0, 0), (40, 40)))):
        body = mk(rows=2, cols=3, kinds=6, geometry=dict(piece=piece), layout='grid')
        S('pointer:edge%d' % k, [R_E4(body)], [boot(), ('probes', 24), ('render', 0, 0)], 'pointer', init=dict(view=view))

    # sweep the view origin so some cell edge lands within 3 of INT32_MAX (the +3 / -3 compares wrap like the original)
    for k, v in enumerate(range(0x7FFFFF80, 0x80000000, 5)):
        body = mk(rows=3, cols=3, kinds=6, geometry=dict(piece=(-40, -40)), layout='grid')
        S('pointer:wrap%d' % k, [R_E4(body)], [boot(), ('probes', 24)], 'pointer', init=dict(view=(v, v, 0, 0)))

    # ---- render matrix ---------------------------------------------------------------------------------------------------------------------
    for k in range(40):
        body = mk(rows=rng.choice((2, 5, 10)), cols=rng.choice((3, 7, 10)), kinds=rng.choice((6, 26, 30)), name_panel=rng.choice((0, 1)),
                  score_panel=rng.choice((0, 1)), title=rng.choice((b'', b'Title', b'T' * 32)), time=rng.choice((0, 61, -3)),
                  font=rng.randrange(18), param=rng.choice((0, 5, -1, 0x7FFF, -0x8000)), layout=rng.choice(('grid', 'tight', 'extreme', 'neg')),
                  hs=rng.choice(((210, 100, 340, 130), (-5, 32767, 70000, -70000), (0x7FFFFFFF, 0x7FFFFFFF, -0x80000000, 0))),
                  geometry=dict(piece=rng.choice(((40, 40), (3, 3))), xoff=rng.choice((31, 32767, -32768)), yoff=rng.choice((17, 32767))))
        acts = [boot()]
        for t in range(10):
            st = rng.choice((0, 0, 1, 2, 3, 4, 5, 6, 6))
            texts = {n: rng.choice((b'', b'abc', b'0', b'%d' % rng.getrandbits(31), b'z' * 32)) for n in TEXT_FIELDS}
            flags = {n: rng.choice((0, 1, 2, 0xFF)) for n in ('show_name', 'score_dirty', 'erase_all', 'name_dirty', 'shuffle_down', 'shuffle_dirty')}
            acts += [('set', {**texts, **flags, 'state': st, 'garbage_bytes': {0x825: bytes(rng.getrandbits(8) for _ in range(16))},
                              'score_surface': rng.choice((0, 0x5252, M32)), 'hs': [rng.choice((0, 5, 99999, -1, M32 >> 1)) for _ in range(5)]}),
                     ('cellflags', [(rng.randrange(2), rng.randrange(3), rng.choice((0, 1, 1, 2)), rng.choice((0, 0, 1, 2, 0xFF)))]),
                     ('render', rng.choice((0, 5, -7, 0x7FFFFFF0)), rng.choice((0, 3, -9))), ('render', 0, 0)]
        S('render:%d' % k, [R_E4(body)], acts, 'render', init=dict(view=rng.choice(((0, 0, 639, 479), (13, -9, 700, 500)))), quick=k < 2)
    for k, real in enumerate(reals):
        S('render:real%d' % k, [R_E4(real)],
          [boot(), ('render', 0, 0), ('swap', 1, 1, 1, 2, dict(ticks=8)), ('render', 0, 0), ('set', dict(state=6, deadline=T0 + 50)), ('render', 0, 0),
           tk(tick=[T0 + 60] * 12), ('render', 0, 0)], 'render')

    # ---- invalidate / cleanup ------------------------------------------------------------------------------------------------------------------
    for k in range(12):
        body = mk()
        obj = dict(active=k % 2, slot=rng.choice((-1, 0x19, 0x20, 0x57)), surface=rng.choice((0, 0x5151)), score_surface=rng.choice((0, 0x5252)))
        S('cleanup:%d' % k, [R_E4(body)], [('set', obj), ('invalidate',), ('cleanup',), ('invalidate',), boot(), ('invalidate',), ('cleanup',),
                                             ('cleanup',)], 'cleanup', quick=k == 0)

    # ---- dependency tails, neighbours, passes stopped by the mode ------------------------------------------------------------------------
    for case in range(12):
        body = mk(rows=3, cols=3, kinds=6)
        tail = event_tail(1003, 1)
        rows = [R67(), R_E4(body, tail=tail), R67(loaded=3)] if case % 2 else [R_E4(body, tail=tail), R67()]
        S('dep:%d' % case, rows, [boot(), tk(), ('events', {1003: 1}), boot(), tk(), ('render', 0, 0), ('rearm',), tk()], 'dep',
          events={1003: 0 if case < 8 else 1}, quick=case in (0, 1))
    for case in range(6):
        b0, b1 = mk(rows=3, cols=3, kinds=6), mk(rows=4, cols=4, kinds=9)
        S('chain:%d' % case, [R_E4(b0), R_E4(b1, tail=event_tail(1003, 1)), R67()],
          [boot(), tk(), ('events', {1003: 1}), tk(), ('render', 0, 0), ('setphase', 0, 2), ('set', dict(exit=1)), tk(), tk(), ('render', 0, 0), tk()],
          'dep', events={1003: 0})
    S('mode:stop', [R_E4(mk()), R_E4(mk())], [boot(), ('set', dict(mode=4)), tk(), ('set', dict(mode=3)), tk()], 'dep')

    # ---- tick wraparound -------------------------------------------------------------------------------------------------------------------
    for k in range(10):
        start = (0xFFFFFFFF - rng.randrange(0, 3000)) & M32
        body = mk(rows=3, cols=4, kinds=7, time=rng.choice((2, 61)), target=900)
        S('wrap:%d' % k, [R_E4(body)],
          [tk(tick=[start] * 4), ('swap', 0, 0, 0, 1, dict(ticks=6)), ('finish', 10)], 'wrap', init=dict(clock=start))

    # ---- the two real bodies, played ---------------------------------------------------------------------------------------------------------
    for k, real in enumerate(reals):
        S('real:%d_play' % k, [R_E4(real)], [boot(handle=[0x7001, 0x7002]), ('bot', 40, 'play'), ('finish', 12)], 'real', quick=k == 0)
        S('real:%d_win' % k, [R_E4(real)], [boot(), ('bot', 30, 'win'), ('set', dict(score=100000)), ('finish', 14), ('rearm',), boot(), ('finish', 14)], 'real')
        S('real:%d_exit' % k, [R_E4(real, subtype=2)], [boot(), ('swap', 0, 0, 0, 1), ('press', 'exit'), ('rearm',), boot(), ('finish', 6)], 'real')

    # ---- fuzz -------------------------------------------------------------------------------------------------------------------------------
    for k in range(60):
        profile = ('play', 'win', 'chaos')[k % 3]
        rows_, cols_ = rng.choice(((5, 7), (4, 4), (10, 10), (1, 6), (6, 1), (3, 3), (8, 5)))
        body = mk(rows=rows_, cols=cols_, kinds=rng.choice((4, 5, 8, 26, 30)), time=rng.choice((0, 61, 5, -2)), target=rng.choice((100, 1000, 100000)),
                  snds={s: rng.choice(SND_KINDS) for s in 'abcd'}, bonus=BONUS, per=rng.choice((7, 50, 0)), layout=rng.choice(('grid', 'tight', 'adjacent')),
                  name_panel=rng.choice((0, 1)), score_panel=rng.choice((0, 1)), win=rand_block(rng, rng.choice((9999, 1299)), rng.choice((-1, 5))),
                  exitb=rand_block(rng, rng.choice((9999, 1298)), rng.choice((-1, 4095))), end_delay=rng.choice((0, 1, 2)), final_delay=rng.choice((0, 1)),
                  font=rng.randrange(18))
        rows = [R_E4(body, subtype=1 + k % 2)]
        if k % 5 == 4:
            rows = [R67(), R_E4(body, subtype=1 + k % 2), R_E4(mk(rows=2, cols=2, kinds=5))]
        S('fuzz:%d_%s' % (k, profile), rows, [boot(), ('bot', rng.choice((25, 40)), profile), ('finish', 10), ('rearm',), boot(), ('bot', 15, profile)],
          'fuzz', quick=k == 0)
    return scs


def snapshot(nat):
    return (nat.obj(), nat.world(), nat.cells()[:8], nat.events(), nat.entries(), nat.log(0), nat.log(1))


def refusal_checks(nat, stats):
    """The native-only refusals (known divergences K1..K6): each one answers with its status, no effect, no change."""
    rng = random.Random(0xE401)
    base = make_body(rng, rows=4, cols=5, kinds=8, snds={s: 'real' for s in 'abcd'}, win=rand_block(rng, 12, 5), exitb=rand_block(rng, 13, 6), name_panel=1)

    def fresh(**state):
        nat.reset()
        nat.set_queues(default_q(rng))
        nat.clear_logs()
        nat.set_rects((0, 0, 639, 479), (0, 0, 640, 480))
        img = bytearray(OBJ_LEN)
        put_fld(img, 'slot', -1)
        put_fld(img, 'row', -1)
        for k, v in state.items():
            put_fld(img, k, v)
        nat.set_obj(bytes(img))
        return img

    def good_board(img, rows=4, cols=5, kind=2):
        for r in range(rows):
            for c in range(cols):
                img[cell_off(r, c)] = 1
                struct.pack_into('<h', img, cell_off(r, c) + 2, kind + (r + c) % 3)
        nat.set_obj(bytes(img))

    def want(what, got, expect):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != expect:
            raise Mismatch('refusal %s: got %r expected %r' % (what, got, expect))

    def untouched(what, call, expect):
        snap = snapshot(nat)
        got = call()
        want(what + ' status', got, expect)
        want(what + ' leaves object, world, cells, events, entries and logs untouched', snapshot(nat), snap)

    def patched(off, data):
        b = bytearray(base)
        b[off:off + len(data)] = data
        return bytes(b)

    # K1 body validation (everything must be refused with ERR_BODY before any effect)
    bad_bodies = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'rows0': patched(B['rows'], struct.pack('<h', 0)),
                  'rows11': patched(B['rows'], struct.pack('<h', 11)), 'rows-1': patched(B['rows'], struct.pack('<h', -1)),
                  'cols0': patched(B['cols'], struct.pack('<h', 0)), 'cols11': patched(B['cols'], struct.pack('<h', 11)),
                  'kinds0': patched(B['kinds'], struct.pack('<h', 0)), 'kinds1': patched(B['kinds'], struct.pack('<h', 1)),
                  'kinds2': patched(B['kinds'], struct.pack('<h', 2)), 'kinds3': patched(B['kinds'], struct.pack('<h', 3)),
                  'kinds31': patched(B['kinds'], struct.pack('<h', 31)), 'font-1': patched(B['font'], struct.pack('<h', -1)),
                  'font18': patched(B['font'], struct.pack('<h', 18)), 'name': patched(0, b'x' * 0x21), 'score_name': patched(0x21, b'y' * 0x21),
                  'title': patched(B['title'], b'z' * 0x21), 'snd_a': patched(B['snd_a'], b'a' * 0x21), 'snd_b': patched(B['snd_b'], b'b' * 0x21),
                  'snd_c': patched(B['snd_c'], b'c' * 0x21), 'snd_d': patched(B['snd_d'], b'd' * 0x21),
                  'kind0_name': patched(B['kind_names'], b'k' * 0x21), 'kind7_name': patched(B['kind_names'] + 7 * 0x21, b'k' * 0x21)}
    for what, body in bad_bodies.items():
        want('validate ' + what, nat.validate(body), ERR_BODY)
        fresh()
        untouched('step ' + what, lambda b=body: nat.step(b, 0, 0)[0], ERR_BODY)
        untouched('pointer ' + what, lambda b=body: nat.pointer(b, 1, 1)[0], ERR_BODY)
        untouched('click ' + what, lambda b=body: nat.click(b, 1, CAND_PIECE)[0], ERR_BODY)
        untouched('render ' + what, lambda b=body: nat.render(b)['status'], ERR_BODY)
    # an unused piece name needs no NUL
    # one more kind than the body can name, with every byte of the extra name area zero (so only the count refuses it)
    zero_tail = bytearray(patched(B['kinds'], struct.pack('<h', 31)))
    zero_tail[B['kind_names']:B['kind_names'] + 31 * 0x21] = bytes(31 * 0x21)
    want('validate kinds 31 with a terminated 31st name', nat.validate(bytes(zero_tail)), ERR_BODY)
    unused = patched(B['kind_names'] + 8 * 0x21, b'u' * 0x21)
    want('validate unused piece name', nat.validate(unused), OK)
    want('validate good body', nat.validate(base), OK)
    # K2 phase 1 / 2 without phase 0, kinds and indexes outside the board
    for phase in (1, 2):
        fresh(row=-1, active=0)
        untouched('phase %d without init' % phase, lambda p=phase: nat.step(base, 0, p)[0], ERR_UNSUPPORTED)
        img = fresh(row=1, active=1)
        untouched('phase %d for another row' % phase, lambda p=phase: nat.step(base, 0, p)[0], ERR_UNSUPPORTED)
        img = fresh(row=0, active=0)
        untouched('phase %d inactive' % phase, lambda p=phase: nat.step(base, 0, p)[0], ERR_UNSUPPORTED)
    img = fresh(row=0, active=1, state=0)
    good_board(img)
    struct.pack_into('<h', img, cell_off(2, 3) + 2, 8)
    nat.set_obj(bytes(img))
    untouched('phase 1 piece kind 8 of 8', lambda: nat.step(base, 0, 1)[0], ERR_UNSUPPORTED)
    struct.pack_into('<h', img, cell_off(2, 3) + 2, -1)
    nat.set_obj(bytes(img))
    untouched('phase 1 piece kind -1', lambda: nat.step(base, 0, 1)[0], ERR_UNSUPPORTED)
    for (sr, sc_, name) in ((4, 0, 'row 4'), (-1, 0, 'row -1'), (0, 5, 'col 5'), (0, -1, 'col -1')):
        img = fresh(row=0, active=1, state=0)
        good_board(img)
        put_fld(img, 'check_first', 1)
        put_fld(img, 'sel_row', sr)
        put_fld(img, 'sel_col', sc_)
        nat.set_obj(bytes(img))
        untouched('phase 1 selection ' + name, lambda: nat.step(base, 0, 1)[0], ERR_UNSUPPORTED)
        img = fresh(row=0, active=1, state=0)
        good_board(img)
        put_fld(img, 'check_second', 1)
        put_fld(img, 'swap_row', sr)
        put_fld(img, 'swap_col', sc_)
        nat.set_obj(bytes(img))
        untouched('phase 1 swapped piece ' + name, lambda: nat.step(base, 0, 1)[0], ERR_UNSUPPORTED)
        img = fresh(row=0, active=1, state=0, no_selection=1)
        good_board(img)
        put_fld(img, 'hover_row', sr)
        put_fld(img, 'hover_col', sc_)
        nat.set_obj(bytes(img))
        untouched('click hover ' + name, lambda: nat.click(base, 1, CAND_PIECE)[0], ERR_UNSUPPORTED)
        img = fresh(row=0, active=1, state=0, no_selection=0)
        good_board(img)
        put_fld(img, 'sel_row', sr)
        put_fld(img, 'sel_col', sc_)
        nat.set_obj(bytes(img))
        untouched('click selection ' + name, lambda: nat.click(base, 1, CAND_PIECE)[0], ERR_UNSUPPORTED)
    img = fresh(row=0, active=1, state=0, no_selection=0)
    good_board(img)
    put_fld(img, 'hover_row', 7)
    put_fld(img, 'hover_col', 1)
    nat.set_obj(bytes(img))
    untouched('click swap with the hovered piece outside the board', lambda: nat.click(base, 1, CAND_PIECE)[0], ERR_UNSUPPORTED)
    nat.reset()
    pre = nat.obj()
    want('power-on object (slot -1, row -1, everything else zero)', pre, bytes(OBJ_LEN)[:0x20] + struct.pack('<h', -1) + struct.pack('<h', -1) + bytes(OBJ_LEN - 0x24))
    # K3 event flag index outside the window (win and exit blocks)
    for blk, field in ((B['win'], 'won'), (B['exit'], 'exit')):
        for bad in (4096, 5000, 32767, -2, -32768):
            body = patched(blk + 22, struct.pack('<h', bad))
            img = fresh(row=0, active=1, **{field: 1})
            untouched('phase 2 flag %d (%s block)' % (bad, field), lambda b=body: nat.step(b, 0, 2)[0], ERR_BOUNDS)
        for ok in (-1, 0, 4095):
            body = patched(blk + 22, struct.pack('<h', ok))
            fresh(row=0, active=1, **{field: 1})
            want('phase 2 flag %d accepted (%s block)' % (ok, field), nat.step(body, 0, 2)[0], OK)
    # K4 render with a kind outside the body; K5 render without a row or slot
    img = fresh(row=0, active=1, slot=0x19, state=0)
    good_board(img)
    struct.pack_into('<h', img, cell_off(1, 1) + 2, 8)
    nat.set_obj(bytes(img))
    untouched('render piece kind 8 of 8', lambda: nat.render(base)['status'], ERR_BOUNDS)
    struct.pack_into('<h', img, cell_off(1, 1) + 2, -1)
    nat.set_obj(bytes(img))
    untouched('render piece kind -1', lambda: nat.render(base)['status'], ERR_BOUNDS)
    struct.pack_into('<h', img, cell_off(1, 1) + 2, 8)
    nat.set_obj(bytes(img))
    img[cell_off(1, 1) + 1] = 1                                             # matched cells need no kind
    nat.set_obj(bytes(img))
    want('render matched cell with a stale kind', nat.render(base)['status'], OK)
    img[cell_off(1, 1) + 1] = 0
    img[cell_off(1, 1)] = 0                                                 # absent cells need no kind
    nat.set_obj(bytes(img))
    want('render absent cell with a stale kind', nat.render(base)['status'], OK)
    img[cell_off(1, 1)] = 1
    put_fld(img, 'state', 6)                                                # the score screen draws no piece
    nat.set_obj(bytes(img))
    want('render score screen with a stale kind', nat.render(base)['status'], OK)
    for row, slot in ((-1, 0x19), (0, -1)):
        fresh(row=row, slot=slot, active=1)
        plan = nat.render(base)
        want('render without row/slot valid flag', (plan['status'], plan['valid'], plan['count']), (OK, 0, 0))
    # K6 host failures: every failing host call answers ERR_HOST
    fails = {F_AMBIENT: 'ambient', F_RANDOM: 'rand', F_ALLOC: 'alloc', F_REGISTER: 'register', F_LOAD: 'load', F_SETSURF: 'set surface',
             F_PREPARE: 'prepare', F_VIEW: 'view'}
    for bit, name in fails.items():
        fresh()
        nat.set_fail(bit)
        want('phase 0 host failure ' + name, nat.step(base, 0, 0)[0], ERR_HOST)
        nat.set_fail(0)
    for bit, name, field in ((F_STOP, 'stop', 'exit'), (F_TRANSITION, 'transition', 'exit'), (F_FLAG, 'flag', 'exit'), (F_FONT, 'font', 'exit'),
                             (F_RELEASE_SURFACE, 'release surface', 'exit'), (F_RELEASE_SLOT, 'release slot', 'exit')):
        fresh(row=0, active=1, slot=0x19, surface=0x10, score_surface=0x11, **{field: 1})
        nat.set_fail(bit)
        want('phase 2 host failure ' + name, nat.step(patched(B['exit'] + 22, struct.pack('<h', 5)), 0, 2)[0], ERR_HOST)
        nat.set_fail(0)
    fresh(row=0, active=1, slot=0x19)
    nat.set_fail(F_DIRTY)
    want('invalidate host failure', nat.invalidate(), ERR_HOST)
    nat.set_fail(0)
    fresh(row=0, active=1, slot=0x19, surface=0x10)
    nat.set_fail(F_RELEASE_SURFACE)
    want('cleanup host failure', nat.cleanup(), ERR_HOST)
    nat.set_fail(0)
    img = fresh(row=0, active=1, slot=0x19, state=6)
    good_board(img)
    nat.set_fail(F_EXTENT)
    want('render host failure (text extent)', nat.render(patched(B['time_limit'], struct.pack('<h', 61)))['status'], ERR_HOST)
    nat.set_fail(F_VIEW)
    want('render host failure (view)', nat.render(base)['status'], ERR_HOST)
    nat.set_fail(0)
    img = fresh(row=0, active=1, state=2, deadline=0)
    good_board(img)
    nat.set_fail(F_BUSY)
    want('refill host failure (busy)', nat.step(base, 0, 1)[0], ERR_HOST)
    nat.set_fail(0)
    img = fresh(row=0, active=1, state=0, no_selection=1, hover_row=1, hover_col=1)
    good_board(img)
    nat.set_fail(F_PLAY)
    want('click host failure (play)', nat.click(base, 1, CAND_PIECE)[0], ERR_HOST)
    nat.set_fail(0)
    # a fill that cannot finish (kinds 4 draws 0..2; a scripted rand that is always 0 equals the left neighbour): ERR_HOST, the original loops
    fresh()
    nat.set_queues(dict(rand=[0] * 1024, tick=[5] * 4, handle=[1, 2]))
    want('fill that cannot finish', nat.step(patched(B['kinds'], struct.pack('<h', 4)), 0, 0)[0], ERR_HOST)
    # allocator exhaustion (the original reaches the fatal path 0x52139c)
    fresh()
    ents = bytearray(nat.entries())
    for s in range(0x18, 0x40):
        struct.pack_into('<I', ents, s * STRIDE + 0x18, 1)
    nat.set_entries(bytes(ents))
    want('allocator exhaustion', nat.step(base, 0, 0)[0], ERR_HOST)
    nat.set_queues({})


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
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-54.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.list:
        print(len(scs), Counter(s['group'] for s in scs))
        return 0
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    # fast paths first: a failing mutant is caught by the quick set before the long scenarios
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_e4.so', strict=not args.lenient_build)
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
            if args.discover_pins:
                print(out[-3000:])
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
            args.result.write_text(json.dumps(dict(slice='RT-54', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_e4.so', strict=not args.lenient_build)
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
        args.result.write_text(json.dumps(dict(slice='RT-54', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
