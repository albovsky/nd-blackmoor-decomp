#!/usr/bin/env python3
"""RT-59: immutable x86 dispatcher 0x427a50 / handler 0x45c18f (raw 0xda, the Bul puzzle), the object methods 0x45b5bb (pointer, with the
candidate writer 0x45b7a8), 0x45b872 (click), 0x45d2c6 (render callback of the puzzle z entry, with 0x45b568), 0x45b477 (invalidate) and
0x45b42e + 0x45b3ea (cleanup and reset) versus the native kernel src/action_family_da_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xda (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a424, the handler
0x45c18f with every phase (0 init, 1 with the object states 0..0xb of obj+0x24, 2 finish) and, as original code, the inner methods 0x45ba0b
(per-game reset), 0x45bbd8 (random pick of the roll rectangles), 0x45bcc1 (step check), 0x45bda7 (win / lose check), 0x45be3f (real sound
name test), 0x45be7f (caption + sound picker), the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 (the table at 0x5d1591, busy
seeds decide which slot comes back), the generic completion 0x42ba3a and the cleanup 0x45b42e / 0x45b3ea. The object methods run as original
functions on the same process image with ECX = 0x624734: the pointer receiver 0x45b5bb (two stack words x, y whose upper halves are garbage,
as the real caller pushes) with 0x45b7a8, the click 0x45b872 (no arguments; it reads the retained candidate 0x5c39e5), the render callback
0x45d2c6 (cdecl, reads the slot and the row through the globals; the blits 0x4c5377 / 0x4c5d4b are recorded), the invalidate 0x45b477 and
the cleanup 0x45b42e.

Native side: tests/action_family_da_runtime_oracle_driver.c links ONLY the kernel and implements the HOST side of the BulHost contract with
scripted queues (GetTickCount values, _rand values, image handles, sound busy answers, caption texts), a model of the Z entry table, the
view origin, the event flag window and the scene-change cells. The driver decides nothing the kernel decides. It keeps two logs, the
observer log (BulHost.observe) and the host-call log (what the kernel really asked of the host); the oracle requires them to agree. The
session binding src/session_bindings_ada.c is a thin wrapper of these kernel calls (it needs a parsed scene resource and is covered by
tests/test_action_family_da_runtime.py); the oracle drives the kernel entry points the binding forwards to.

Compared after EVERY action (dispatcher pass, pointer, click, render, invalidate, cleanup):
 * the whole 0x1b9-byte object image 0x624734.. byte for byte against BulObject (the 28 bytes in front of the first field come from a
   shadow); the start flag 0x5bb1ca; the engine mode 0x583999; the seven scene-change cells; the whole event flag window (4096 dwords at
   0x585801); the whole generic Z entry table (0x58 entries of 0x4a bytes, label bytes included); the candidate 0x5c39e5, the cursor cells
   0x5b44f0 / 0x5b44f4 and the host-composed cells 0x5d162d / 0x5d1631 / 0x5d1639 against their documented composition from the native
   outputs;
 * every byte of every row (except the dependency record the gate and the reset own) against a model and the whole row body (the original
   never writes it); every write outside the modelled cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every BulEffect: the
   start flag, clear-item, the row phase stores, the slot, the entry registration after the label copy and after the slot surface store, the
   image loader, the sound prepare / stop / play / busy calls, GetTickCount, _rand, the caption lookup and the caption show, the scene cells,
   the engine mode, the event flag window, the releasers, then the completion byte, the dependency reset and the phase store of 0x42ba3a)
   against the sequence the native kernel reports for the same visit, entry for entry; the scripted queues are consumed identically by
   both sides; the shown caption strings and the lookup names byte for byte;
 * pointer: the return value, the candidate and the cursor cells; click: the row phase it stores and the "handled" classification;
   render: every recorded 0x4c5d4b / 0x4c5377 blit (this, source surface, source rectangle contents, target, destination rectangle contents,
   label) against the kernel's list, in order.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10)   R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4f6334 sound busy query (ECX 0x5cf1eb, ret 4)
  R 0x423259 caption lookup (ECX 0x619a6b, ret 4)   R 0x448d11 caption show (ECX 0x619a05, ret 0x10)   R 0x4e8d96 clear pending item
  R 0x4c5d4b / 0x4c5377 blit recorders (ECX 0x5cf659, ret 0x14)   R 0x50cd50 _rand (scripted queue)   R GetTickCount (import stub)
  O 0x42a424 / 0x428692 arm entries, 0x42a447 / 0x4286b5 post-gate points, 0x45c18f handler entry, 0x42ba3a generic completion, 0x42babe (its
    ret), 0x423d33 dependency reset, 0x45c350 (after the slot allocation), 0x45c423 / 0x45c462 (after the entry label copy and after the slot
    surface store), 0x4d3992 releaser entry, every store to the process data region is observed (read-only)
  G 0x4c97b4 0x42639d 0x52139c 0x44a2b7 0x4264e8: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag 0x63a4cd is
 0. The strings the kernel hard-codes ("NO SOUND\\0" at its addresses, the suffix dword at 0x54ab74) and the label strings of the blits and of
 the image loader are checked against the image at start-up (the blit and loader labels by SHA-256; the entry label by the entry table).

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick, _rand, busy and caption
queues, the view origin, the target surface handle (cell 0x5cf665), the caption destination (cell 0x5d03b3), the cursor source (cell
0x5d0377), the background / entry 1 surface (0x5d15e3), the busy seeds of the Z entry table, the event flag window contents, the contents of
the process cells at the start of a scenario.

KNOWN STAND-INS AND DIVERGENCES (never silently skipped; the oracle's scenarios skip the actions the kernel refuses, counted in
stats.skipped_native_refusal; the refusals are checked natively in refusal_checks()):
  K1 bul_validate_body: short / long body, names without NUL in their 0x21 bytes (surface, 4 sound records, 44 caption names), M outside
     1..15, N outside 1..6, start positions outside 1..M -> BUL_ERR_BODY, no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row; phase 1 / render with a hand-made object (mode outside 0..3, scores
     outside 0..N, positions outside 1..M, side outside 0..1, button kind outside 0..2); a button click with a pending button outside 0..2
     -> BUL_ERR_UNSUPPORTED before any effect.
  K3 phase 2 with an event flag index outside the host window 0..4095 (and not -1) -> BUL_ERR_BOUNDS before the first effect.
  K4 a caption text of 201..0x9c40 characters (the original copies it into a 204-byte stack buffer) -> BUL_ERR_BOUNDS after 0x423259 was
     called. A text longer than 0x9c40 is valid (no caption is shown) and compared against the original.
  K5 the name pick that does not end within BUL_PICK_LIMIT draws -> BUL_ERR_STUCK; _rand values outside 0..32767 -> BUL_ERR_HOST.
  K6 host failures -> BUL_ERR_HOST, allocator exhaustion -> BUL_ERR_HOST.
  K7 render / invalidate / pointer / click while inactive or with the slot -1: native does nothing (valid = 0), where the original render
     callback has no active test and the original click reads the body pointer of a stale row.
 All of these are unreachable in the game (loader-built 2958-byte bodies, callbacks only for allocated entries).

Not modelled / unverified: the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine, the blit bodies 0x4c5d4b / 0x4c5377, the
caption table behind 0x423259 and the writer 0x448d11, the CRT random state behind 0x50cd50, the cascade 0x4f0059 and the accepted-release
chain 0x43b2a0 that call 0x45b5bb / 0x45b872 (the methods are run directly), the scene clears 0x438bfd / 0x43ded9, the loader 0x45b4ae that
builds the body, 0x4e8d96, the engine consumers of the scene-change cells, the host composition of the cursor cells (their documented
composition is checked, not the engine code that reads them), the session binding.

Modes: --quick-only runs the scenarios flagged quick; the default run is every scenario plus the native-only refusal checks; --workers N
shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does this);
--discover-pins prints the PINS_TABLE of the original code the scenarios execute (the pins are verified at start-up); --fuzz N runs the
ASan / UBSan malformed-input harness. The planted-mutant sweep is tests/action_family_da_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_da_runtime_original_oracle.py --quick-only
  python3 action_family_da_runtime_original_oracle.py --workers 4 --result ../../../work/rt59/RT-59.oracle-result.json
  python3 action_family_da_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
"""
from __future__ import annotations

import argparse
import ctypes as C
import hashlib
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
BODY_LEN = 2958
BODY_STRIDE = 0x1000
M32 = 0xFFFFFFFF
RESOURCES = ROOT / 'work/analysis/hiff-resources'
CORPUS = ROOT / 'work/analysis/slices/A-DA.1.corpus.json'
RESULT_DIR = ROOT / 'work/rt59'
TEXT_VA = 0x20100000          # scripted caption texts (inside the zeroed 0x20000000 scratch region)
TEXT_SPACE = 0x40000

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x45C18F, 0x42BA3A, 0x423D33, 0x42BABE
ARM = {0xDA: 0x42A424, 0x67: 0x428692}
VISIT = {0xDA: 0x42A447, 0x67: 0x4286B5}
M_POINTER, M_CLICK, M_INVALIDATE, M_CLEANUP, M_RENDER = 0x45B5BB, 0x45B872, 0x45B477, 0x45B42E, 0x45D2C6
AT_SLOT, AT_REGISTER, AT_SLOT_SURFACE = 0x45C350, 0x45C423, 0x45C462
RELEASE_SLOT_FN = 0x4D3992
LOAD_IMAGE, RELEASE_IMAGE = 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
CAP_TEXT, CAP_SHOW = 0x423259, 0x448D11
BLIT_OPAQUE, BLIT_RESTORE, CLEAR_ITEM, RAND = 0x4C5D4B, 0x4C5377, 0x4E8D96, 0x50CD50
GUARD_ADDRS = [0x4C97B4, 0x42639D, 0x52139C, 0x44A2B7, 0x4264E8]

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ, OBJ_LEN = 0x624734, 0x1B9
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_BG, CELL_TARGET, CELL_CAPDEST = 0x5D15E3, 0x5CF665, 0x5D03B3
CELL_VIEW = 0x583186
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_ITEM, THIS_BUSY, THIS_CAPTEXT, THIS_CAPSHOW = 0x5CF659, 0x5C3A67, 0x571442, 0x5CF1EB, 0x619A6B, 0x619A05
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
PUZZLE_HANDLE = 0x7A000033
CAPDEST_HANDLE = 0x7A0000C3
NO_SOUND = b'NO SOUND\0'
NO_SOUND_VAS = (0x54AB5C, 0x54AB68, 0x54ABA8, 0x54ABB4, 0x54ABC0, 0x54ABCC, 0x54ABD8, 0x54ABE4, 0x54ABF0, 0x54ABFC, 0x54AC08)
SUFFIX_VA, SUFFIX = 0x54AB74, b'<e>\0'
CAND_BUTTON, CAND_FINISH = 0x27BA, 0x27BB
CAP_LIMIT = 0x9C40
CAP_MAX = 200

# the numbers of BulEffect
FX = dict(START_FLAG=1, CLEAR_ITEM=2, ROW_PHASE=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6, SLOT_SURFACE=7, SOUND_PREPARE=8, SOUND_STOP=9,
          SOUND_BUSY=10, SOUND_PLAY=11, TICK=12, RANDOM=13, CAPTION_TEXT=14, CAPTION_SHOW=15, X57B=16, X599=17, X595=18, X39FF=19, X59B=20,
          X59F=21, X5A3=22, MODE=23, EVENT_FLAG=24, COMPLETE=25, RELEASE_SURFACE=26, RELEASE_SLOT=27, MARK_DIRTY=28, BLIT=29)
FXN = {v: k for k, v in FX.items()}
WORD_FIRST = {FX['SLOT'], FX['SLOT_REGISTER'], FX['SLOT_SURFACE'], FX['SOUND_PLAY'], FX['COMPLETE'], FX['X599'], FX['X595'], FX['X39FF'],
              FX['RELEASE_SLOT'], FX['EVENT_FLAG'], FX['MARK_DIRTY']}
FX_SIZE = {k: (2, 4) for k in WORD_FIRST}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
HOST_FX = {FX[k] for k in ('CLEAR_ITEM', 'SLOT', 'SLOT_REGISTER', 'SURFACE_LOAD', 'SLOT_SURFACE', 'SOUND_PREPARE', 'SOUND_STOP', 'SOUND_BUSY',
                           'SOUND_PLAY', 'TICK', 'RANDOM', 'CAPTION_TEXT', 'CAPTION_SHOW', 'EVENT_FLAG', 'MODE', 'RELEASE_SURFACE',
                           'RELEASE_SLOT', 'MARK_DIRTY')}

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# blit labels: address -> (BulBlitKind, SHA-256 of the label bytes with the NUL), checked against the image at start-up
BLIT_LABELS = {
    0x54AC14: (1, 'ab4206d219287759fd7bcbca0fced2e17a8be2e7b916053c629083f29542f1d1'),
    0x54AC28: (2, 'ab4206d219287759fd7bcbca0fced2e17a8be2e7b916053c629083f29542f1d1'),
    0x54AC3C: (3, 'd3a8efdb2a8c3a3eff6fdea77ede247168180d93babf5a2f0d8c79b04c230ed0'),
    0x54AC54: (4, 'b2d947f386dfce7150757181adcbe367c72dcb257111ac8ad69aac7abe06326a'),
    0x54AC68: (5, 'aaceea29d5e53e25b5f9727a481f6941bc0fb5ce065e4a4df45fc9e655c36dc8'),
    0x54AC80: (6, '34bb548635b84518f166b87a8e781a298b9133e84d5b11e034ff2644c03ec19e'),
    0x54AC98: (7, 'b2d947f386dfce7150757181adcbe367c72dcb257111ac8ad69aac7abe06326a'),
    0x54ACAC: (8, 'ab9c30a745a630149a6ccefa12a460d3e8450ff52ed03567e5c8e03f26113a14'),
    0x54ACCC: (9, 'b01ec0034127f9e172353935abf5f0fdea773a94ce299325dc057a5ea9dcc829'),
    0x54ACE0: (10, 'ad9ad2659197fb690a8781547af9e14a6997112c6345b78f5f5fa6b052886f9b'),
    0x54ACFC: (11, 'b01ec0034127f9e172353935abf5f0fdea773a94ce299325dc057a5ea9dcc829'),
    0x54AD10: (12, '4fa765911595ba3a53dfbf78d15380cbd2fcdcd2db655bd8fd99976014e11f3c'),
    0x54AD2C: (13, '4cc47209c6aadf77e2156285e646fddceb5befc5bd4196c2c7a6dc7ca90b6dc7'),
    0x54AD48: (14, 'd64fe72d186a0adca206d09ce93c04d2746cab78f9c4336b297e93b488f0837e'),
    0x54AD5C: (15, 'd9bbf0d4699aa6dcff5cf150854d2e8ab8a15b9832ee94764f069a9538f841b3'),
    0x54AD88: (16, 'f073043a615326af5668d2be06578b6fbb47925ce9cfd46cc90cfecef2c470bb'),
    0x54ADAC: (17, 'c46d7511b8f7d2ccac1e45d355419297650f15aa527948c0c0145fe0c327d81b'),
    0x54ADC8: (18, '478d5f04e4b48b8ac6a9637a910ce234950b428ee8a7c044cca59c4ea1b94869'),
    0x54ADE8: (19, '32cf42f90e9514099b49321dce571d61e0efd0fca5f0147a4dac63d5977072cf'),
    0x54AE08: (20, '07cad75324859f403965b7258c3d2489cd218115c656eb6232f218d613f6c183'),
    0x54AE34: (21, 'd415bd303f0118bed9c7dfedfb56895bcbf8fdbee90341f81fe8cf9eddc1dff8'),
    0x54AE64: (22, '0d01d0f09bfe6f9207bf80cf242bc5407adc1a9a637ed699a77a6f58807dfb8a'),
    0x54AE88: (23, '250971e86c316c2b19d53c15bfcb167d608a26bfcd96eadaac16c438ae3335de'),
}
RESTORE_KINDS = set(range(1, 15)) | {16, 17, 18, 19, 20, 21, 22, 23}   # every blit but kind 15 uses 0x4c5377
DRAW_KIND = 15
BACKDROP_KINDS = {8, 10, 12, 14, 16, 19, 20, 21, 22, 23}
# the image loader's arguments: kind string and surface label (SHA-256 of the bytes with the NUL), the entry label is checked by the table
LOAD_KIND_VA, LOAD_KIND_SHA = 0x54ABA0, '57962567ed11c8452f7e30e0672c883092a029ed61001d48fc642db2a0ef2eb3'
LOAD_LABEL_VA, LOAD_LABEL_SHA = 0x54AB8C, 'bf36c559e6d8842c01382ea2174779815f1319ccacf1c13f1e6d662d7322198a'
ENTRY_LABEL_VA, ENTRY_LABEL_SHA = 0x54AB78, '8712fa0f63637da39a43ceddb956ed1763326d57a215ed10f75a55bd3c1c96df'

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4), SND_PLAY: (0xb4, 4),
             SND_BUSY: (0x138, 4), BLIT_OPAQUE: (0x350, 0x14), BLIT_RESTORE: (0x214, 0x14), CLEAR_ITEM: (0x32, 0), RAND: (0x22, 0),
             CAP_TEXT: (0x10f, 4), CAP_SHOW: (0xa5f, 0x10)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT_OPAQUE: 0x14, BLIT_RESTORE: 0x14,
        CLEAR_ITEM: 0, RAND: 0, CAP_TEXT: 4, CAP_SHOW: 0x10}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            SND_BUSY: THIS_BUSY, BLIT_OPAQUE: THIS_SURF, BLIT_RESTORE: THIS_SURF, CLEAR_ITEM: THIS_ITEM, CAP_TEXT: THIS_CAPTEXT,
            CAP_SHOW: THIS_CAPSHOW}

# Executed original code, as SHA-256 of the unmodified image bytes. Discovered over every scenario with --discover-pins, verified at start-up.
PINS_TABLE = (
    (0x423259, 0x423368, '05577fdc25bbcff3f5b8e48c31cedc4836a90d77f41d1f59886594953693f7e3'),
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
    (0x448d11, 0x449770, '73e722d119326e1c9e8503964f3f5ecaeff18f856e43267a4519fe0282f7ccfa'),
    (0x45b3ea, 0x45b42e, 'f02126a56c7d43b5b6f95f7ab4a7537dec8dfcca54f6c91b5da33c256793beb5'),
    (0x45b42e, 0x45b477, '8c41eba777fc7fde61077839ea84c321cc4a834e50074bfe9b74aecb2d345122'),
    (0x45b477, 0x45b4ae, 'df6b2cf018539b83dc4011959e982ee1af6e4e920017f7c25910288a017e5b96'),
    (0x45b568, 0x45b5bb, '30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57'),
    (0x45b5bb, 0x45b7a8, 'f33181868dd2e9e169753aa6d13aefb5d4231e3215356d5bd0fc589f00728284'),
    (0x45b7a8, 0x45b872, 'c9ffd6250f130ce3825d3e66ee88b47d482c9dcb2e4e6309c54770660e6918ca'),
    (0x45b872, 0x45ba0b, '526611362736b2e3f2b9a84981ef4d5e6c9b5b8b020575a2a3b84fdacf204071'),
    (0x45ba0b, 0x45bbd8, 'bda1fb6e9941f00ef4c139013cff48b674f6f19034c345b3b7dc570a2453d506'),
    (0x45bbd8, 0x45bcc1, '693b45f27e4f2d89d3e316c71cddaf5aef0b77f050d85313405545f901f26df1'),
    (0x45bcc1, 0x45bda7, '4fa61216e8097b07b065fcfd1ffb8c3414302db167e55d58916776a18fddc332'),
    (0x45bda7, 0x45be3f, '002f90b1e09da9cfc5472c85a63b93924d5cf2b1dc7577bd6e9dd480a7f2f58a'),
    (0x45be3f, 0x45be7f, '23ab2bf99ef5490fcce4ae406fb4f129643ccf024537544746c09e1e714de1e4'),
    (0x45be7f, 0x45c18f, '8a75bc3f2dfd3aa29bfefc4e2473c63e2c048a7938dcb3ad9525e136a8253f41'),
    (0x45c18f, 0x45d2b6, '6bb396743ac8040fb0f2f11f59a63a2691d2a0bb5708e32b79e5b2f1e1948397'),
    (0x45d2c6, 0x45db70, '55f48adb8d3b1d46f5267a6289202030028d8f37ff8952ca7b088215962cb47a'),
    (0x4c2790, 0x4c2898, '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377, 0x4c558b, 'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
    (0x4c5d4b, 0x4c609b, 'cfb7385d2efeb3e0fe986eb4812d22f3447e4b1134ff5086a655a0ccc10d5379'),
    (0x4d3992, 0x4d39f9, 'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
    (0x4d39f9, 0x4d3a52, '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
    (0x4e8d96, 0x4e8dc8, '0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85'),
    (0x4f6334, 0x4f646c, '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
    (0x4fb2e3, 0x4fb397, 'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
    (0x4fb77a, 0x4fba69, '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
    (0x4fba69, 0x4fba86, '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
    (0x50cd50, 0x50cd72, '0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


# ---- object layout (offsets from 0x624734): name -> (offset, size, signed)
OBJ_SCALARS = {
    'slot': (0x1C, 2, 1), 'row': (0x1E, 2, 1), 'surface': (0x20, 4, 0), 'state': (0x24, 4, 1), 'anim_active': (0x28, 4, 0),
    'button_kind': (0x2C, 2, 1), 'anim_deadline': (0x2E, 4, 0), 'button_down': (0x32, 4, 0), 'score_player': (0xB6, 2, 1),
    'score_computer': (0xB8, 2, 1), 'mode': (0xBA, 2, 1), 'side': (0x15C, 2, 1), 'light': (0x15E, 4, 0), 'finish_kind': (0x162, 4, 0),
    'active': (0x166, 4, 0), 'won': (0x16A, 4, 0), 'deadline_16e': (0x16E, 4, 0), 'pending_button': (0x172, 2, 1), 'moves': (0x174, 2, 1),
    'step': (0x176, 2, 1), 'pos_player': (0x178, 2, 1), 'pos_computer': (0x17A, 2, 1), 'deadline_17c': (0x17C, 4, 0),
    'deadline_180': (0x180, 4, 0), 'cap_channel': (0x1A5, 2, 1), 'cap_1a7': (0x1A7, 2, 1), 'cap_1a9': (0x1A9, 2, 1), 'cap_1ab': (0x1AB, 2, 1),
    'cap_1ad': (0x1AD, 4, 0), 'cap_1b1': (0x1B1, 2, 1), 'cap_1b3': (0x1B3, 2, 1), 'next_state': (0x1B5, 4, 1)}
OBJ_RECTS = {'roll_a%d' % i: 0x36 + 16 * i for i in range(4)}
OBJ_RECTS.update({'roll_b%d' % i: 0x76 + 16 * i for i in range(4)})
OBJ_RECTS.update({'cur_player': 0xBC, 'cur_computer': 0xCC, 'moving': 0xDC, 'image_player': 0xEC, 'image_computer': 0xFC, 'erase': 0x10C})
OBJ_RECTS.update({'clear%d' % i: 0x11C + 16 * i for i in range(4)})
SOUND_NAME_OFF, SOUND_NAME_LEN = 0x184, 33
UNMODELLED = ((0, 0x1C),)


def fld(img, name):
    off, size, sg = OBJ_SCALARS[name]
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=bool(sg))


def put_fld(img, name, v):
    off, size, _ = OBJ_SCALARS[name]
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


def rect_of(img, name):
    off = OBJ_RECTS[name]
    return struct.unpack_from('<4i', bytes(img), off)


def put_rect(img, name, r):
    struct.pack_into('<4i', img, OBJ_RECTS[name], *[sgn(v, 4) for v in r])


QKIND = ('tick', 'rand', 'handle', 'busy')


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xda hooks."""

    def __init__(self):
        self.qs = {k: [] for k in QKIND + ('caption',)}
        self.qpos = Counter()
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

        def cs(va):
            return d9.cstr(img(va, 96)) + b'\0'
        for va in NO_SOUND_VAS:
            if img(va, len(NO_SOUND)) != NO_SOUND:
                raise d9.OracleError('"NO SOUND" constant at %#x differs from the kernel assumption' % va)
        if img(SUFFIX_VA, 4) != SUFFIX:
            raise d9.OracleError('caption suffix dword at %#x differs from the kernel assumption' % SUFFIX_VA)
        for va, (_, digest) in BLIT_LABELS.items():
            if sha(cs(va)) != digest:
                raise d9.OracleError('blit label at %#x differs from the recorded digest' % va)
        for va, digest in ((LOAD_KIND_VA, LOAD_KIND_SHA), (LOAD_LABEL_VA, LOAD_LABEL_SHA), (ENTRY_LABEL_VA, ENTRY_LABEL_SHA)):
            if sha(cs(va)) != digest:
                raise d9.OracleError('label at %#x differs from the recorded digest' % va)
        self.entry_label = cs(ENTRY_LABEL_VA)

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.blits = []
        self.cap_names = []
        self.shown = []
        self.in_complete = False

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in QKIND + ('caption',)}
        self.qpos = Counter()

    def pop(self, kind):
        i = self.qpos[kind]
        if i >= len(self.qs[kind]):
            raise d9.OracleError('script underflow: %s queue' % kind)
        self.qpos[kind] += 1
        v = self.qs[kind][i]
        return v if kind == 'caption' else v & M32

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
        table.update({HANDLER: self._handler, GENERIC_COMPLETION: self._complete, GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen,
                      AT_SLOT: self._after_alloc, AT_REGISTER: self._at_register, AT_SLOT_SURFACE: self._at_slot_surface,
                      RELEASE_SLOT_FN: self._release_slot})
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
            raise d9.OracleError('handler entered with ECX != 0x624734')
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

    def _after_alloc(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT'], self.rs16(OBJ + 0x1C) & 0xFFFF, 0))

    def _at_register(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT_REGISTER'], self.rs16(OBJ + 0x1C) & 0xFFFF, 0))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0x1C)
        self.events.append(('fx', FX['SLOT_SURFACE'], slot & 0xFFFF, self.entry_surface(slot)))

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
            if sha(kind + b'\0') != LOAD_KIND_SHA or six != 6 or sha(label + b'\0') != LOAD_LABEL_SHA:
                raise d9.OracleError('image loader arguments differ from the packet')
            eax = self.pop('handle')
            self.loaded.append(name)
            self.events.append(('fx', FX['SURFACE_LOAD'], eax, 0))
        elif address == RELEASE_IMAGE:
            if a[0] != OBJ + 0x20:
                raise d9.OracleError('releaser called for %#x' % a[0])
            old = u32(uc, a[0])
            self.events.append(('fx', FX['RELEASE_SURFACE'], old, 0))
            self.wr(a[0], bytes(4))
        elif address in (SND_PREPARE, SND_STOP):
            off = -1 if a[0] == OBJ + SOUND_NAME_OFF else a[0] - self.body_ptr(a[0])
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], off & M32, 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['SOUND_BUSY'], a[0], int(eax != 0)))
        elif address == CLEAR_ITEM:
            self.events.append(('fx', FX['CLEAR_ITEM'], 0, 0))
        elif address == RAND:
            eax = self.pop('rand')
            self.events.append(('fx', FX['RANDOM'], eax, 0))
        elif address == CAP_TEXT:
            if a[0] != OBJ + SOUND_NAME_OFF:
                raise d9.OracleError('caption lookup called with %#x' % a[0])
            self.cap_names.append(d9.cstr(self.rd(a[0], SOUND_NAME_LEN)))
            text = self.pop('caption')
            if text is None:
                self.events.append(('fx', FX['CAPTION_TEXT'], 0, 0))
            else:
                if len(text) + 1 > TEXT_SPACE:
                    raise d9.OracleError('scripted caption text too long')
                self.wr(TEXT_VA, text + b'\0')
                eax = TEXT_VA
                self.events.append(('fx', FX['CAPTION_TEXT'], 1, 0))
        elif address == CAP_SHOW:
            if a[0] != self.cell(CELL_CAPDEST) or sgn(a[2], 4) != -1 or a[3] != 0:
                raise d9.OracleError('caption show arguments %s' % [hex(v) for v in a[:4]])
            text = d9.cstr(self.rd(a[1], 512))
            self.shown.append(text)
            self.events.append(('fx', FX['CAPTION_SHOW'], len(text), 0))
        elif address in (BLIT_OPAQUE, BLIT_RESTORE):
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            if a[4] not in BLIT_LABELS:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            kind = BLIT_LABELS[a[4]][0]
            if (kind in RESTORE_KINDS) != (address == BLIT_RESTORE):
                raise d9.OracleError('blit routine %#x used with the label %#x' % (address, a[4]))
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label_ptr=a[4], kind=kind,
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
                self.events.append(('gphase', row, value) if self.in_complete else ('fx', FX['ROW_PHASE'], value, 0))
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

    def world_image(self):
        return self.rd(CELL_START, 4)

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
        if total > MAX_ROWS or total * BODY_STRIDE > 0xF000:
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
SOURCES = ('action_family_da_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS, ERR_STUCK = 0, 1, 2, 3, 4, 5, 6
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_VIEW, F_PREPARE, F_STOP, F_PLAY, F_TRANSITION,
 F_FLAG, F_CLEAR, F_MODE, F_SHOW) = [1 << k for k in range(16)]
MAX_BLITS = 64
BLIT_INTS = 11


def build_driver(src_dir, out, strict=True, sanitize=False, fuzz=False):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O0', '-g', f'-I{src_dir}', str(PROJECT / 'tests/action_family_da_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if not fuzz:
        cmd[8:8] = ['-fPIC', '-shared']
    else:
        cmd[8:8] = ['-DBUO_FUZZ_MAIN']
    if strict:
        cmd.insert(5, '-Werror')
    if sanitize or os.environ.get('DA_SANITIZE'):
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
        lib.buo_new.restype = P
        for name, args, res in (
                ('buo_free', [P], None), ('buo_reset', [P], None), ('buo_clear_logs', [P], None), ('buo_set_fail', [P, C.c_int], None),
                ('buo_set_view', [P, I32, I32], None), ('buo_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('buo_q_pos', [P, C.c_int], C.c_int), ('buo_q_underflow', [P, C.c_int], C.c_int),
                ('buo_cap_set', [P, C.c_char_p, I32P, C.c_int], None), ('buo_cap_pos', [P], C.c_int), ('buo_cap_underflow', [P], C.c_int),
                ('buo_obj_get', [P, C.c_char_p], None), ('buo_obj_set', [P, C.c_char_p], None),
                ('buo_world_get', [P, C.c_char_p], None), ('buo_world_set', [P, C.c_char_p], None),
                ('buo_cells_get', [P, I32P], None), ('buo_cells_set', [P, I32P], None),
                ('buo_events_get', [P, C.c_char_p], None), ('buo_events_set', [P, C.c_char_p], None),
                ('buo_entries_get', [P, C.c_char_p], None), ('buo_entries_set', [P, C.c_char_p], None),
                ('buo_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('buo_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('buo_str', [P, C.c_int, C.c_int], C.c_char_p),
                ('buo_nstr', [P, C.c_int], C.c_int), ('buo_errors', [P, I32P], None),
                ('buo_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('buo_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('buo_click', [P, C.c_char_p, C.c_int, U32, I32, I32P], None),
                ('buo_invalidate', [P], C.c_int), ('buo_cleanup', [P], C.c_int),
                ('buo_validate', [C.c_char_p, C.c_int], C.c_int), ('buo_render', [P, C.c_char_p, C.c_int, I32P], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.buo_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.buo_free(self.h)

    def reset(self):
        self.lib.buo_reset(self.h)

    def clear_logs(self):
        self.lib.buo_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.buo_set_fail(self.h, m)

    def set_view(self, x, y):
        self.lib.buo_set_view(self.h, sgn(x, 4), sgn(y, 4))

    def set_queues(self, qs):
        for i, k in enumerate(QKIND):
            vals = list(qs.get(k, []))[:8192]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.buo_q_set(self.h, i, arr, len(vals))
        caps = list(qs.get('caption', []))[:1024]
        lens = (C.c_int32 * max(len(caps), 1))(*[(-1 if t is None else len(t)) for t in caps])
        self.lib.buo_cap_set(self.h, b''.join(t for t in caps if t is not None), lens, len(caps))

    def qpos(self, k):
        return self.lib.buo_cap_pos(self.h) if k == 'caption' else self.lib.buo_q_pos(self.h, QKIND.index(k))

    def qunder(self, k):
        return self.lib.buo_cap_underflow(self.h) if k == 'caption' else self.lib.buo_q_underflow(self.h, QKIND.index(k))

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.buo_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.buo_obj_set(self.h, bytes(img))

    def world(self):
        buf = C.create_string_buffer(4)
        self.lib.buo_world_get(self.h, buf)
        return bytes(buf.raw)[:4]

    def set_world(self, data):
        self.lib.buo_world_set(self.h, bytes(data))

    def start_flag(self):
        return struct.unpack('<i', self.world())[0]

    def set_start(self, v):
        self.set_world(struct.pack('<i', sgn(v, 4)))

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.buo_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.buo_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.buo_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.buo_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.buo_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.buo_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.buo_entry_set_u32(self.h, slot, off, v & M32)

    def log(self, which):
        arr = (C.c_int32 * (3 * 16384))()
        n = self.lib.buo_log(self.h, which, arr, 16384)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def strs(self, kind):
        n = min(self.lib.buo_nstr(self.h, kind), 64)
        return [self.lib.buo_str(self.h, kind, i) for i in range(n)]

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.buo_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.buo_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 8)()
        self.lib.buo_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, body, row_phase, candidate):
        out = (C.c_int32 * 3)()
        self.lib.buo_click(self.h, bytes(body), len(body), row_phase & M32, sgn(candidate, 4), out)
        return tuple(out)

    def invalidate(self):
        return self.lib.buo_invalidate(self.h)

    def cleanup(self):
        return self.lib.buo_cleanup(self.h)

    def validate(self, body):
        return self.lib.buo_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * (3 + BLIT_INTS * MAX_BLITS))()
        self.lib.buo_render(self.h, bytes(body), len(body), out)
        blits = []
        for i in range(out[2] if 0 <= out[2] <= MAX_BLITS else 0):
            o = out[3 + BLIT_INTS * i:3 + BLIT_INTS * (i + 1)]
            blits.append(dict(kind=o[0], index=o[1], backdrop=o[2], src=tuple(o[3:7]), dst=tuple(o[7:11])))
        return dict(status=out[0], valid=out[1], count=out[2], blits=blits)


# ---------------------------------------------------------------------------------------------
# bodies (2958 bytes)
# ---------------------------------------------------------------------------------------------
B_NAME, B_M, B_N, B_TWO, B_SMART, B_START_P, B_START_C = 0x00, 0x21, 0x23, 0x27, 0x28, 0x29, 0x2B
B_ROLL_A, B_ROLL_B, B_POS = 0x2D, 0x6D, 0xAD
B_PBARRACK, B_PJAIL, B_CBARRACK, B_CJAIL = 0x19D, 0x1FD, 0x25D, 0x2BD
B_BUTTON, B_LIGHT_P, B_LIGHT_C, B_WORK = 0x31D, 0x34D, 0x35D, 0x36D
B_IMG, B_IMG_AFTER, B_PIECE_PB, B_PIECE_CB, B_PIECE_CJ, B_PIECE_PJ = 0x3ED, 0x40D, 0x42D, 0x43D, 0x44D, 0x45D
B_BTN_DOWN, B_LIGHT_P_ON, B_LIGHT_C_ON, B_PASS_OFF = 0x46D, 0x49D, 0x4AD, 0x4BD
B_SND_STEP, B_SND_BTN = 0x4CD, 0x4FE
B_CAP, B_CAP_STRIDE = 0x591, 0x2DC
B_ENDED, B_LEFT, B_FINISH_RECT = 0xB49, 0xB65, 0xB7E
NAME_REAL = b'LIB_BulPuzzle_Surface'


def snd(kind, rng=None):
    """A sound / caption name: the 0x21-byte field (the native validator needs a terminator inside it; the original compares 9 bytes)."""
    letters = b'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
    if kind == 'real':
        n = rng.randint(1, 32) if rng else 8
        return bytes(rng.choice(letters) for _ in range(n)) if rng else b'bul_clip\0'
    return {'none': NO_SOUND, 'real1': b'x\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0', 'near3': b'no sound\0', 'zero': bytes(9),
            'near4': b'NO SOUN\0\0', 'long': b'L' * 32, 'near5': b'NO SOUNDS\0'}[kind]


SND_KINDS = ('none', 'real', 'real1', 'near1', 'near2', 'near3', 'zero', 'near4', 'long', 'near5')


def put_name(b, off, kind, rng):
    data = snd(kind, rng)
    b[off:off + 0x21] = bytes(rng.getrandbits(8) for _ in range(0x21))     # garbage after the terminator, as a loader-built body may hold
    b[off:off + len(data)] = data
    if len(data) < 0x21 and 0 not in data:
        b[off + len(data)] = 0
    if 0 not in b[off:off + 0x21]:
        b[off + 0x20] = 0


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, flag2=-1, value=0, value2=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start, flag=flag, flag2=flag2, value=value, value2=value2)


def rand_block(rng, scene, flag=None, flag2=None):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)), rng.choice((-1, 0, 5, 340, 4095)) if flag is None else flag,
                 rng.choice((-1, 1, 77, 2047)) if flag2 is None else flag2, rng.choice((0, 1, 2, 0x7F, 0xFF)), rng.choice((0, 1, 3, 0x80, 0xFE)))


def rrect(rng, big=False):
    if big:
        return tuple(rng.choice((0, 1, -1, 0x7FFFFFFF, -0x80000000, 0x7FFFFFF0, rng.randint(-1000, 1000))) for _ in range(4))
    x, y = rng.randint(-30, 600), rng.randint(-30, 440)
    return (x, y, x + rng.randint(0, 90), y + rng.randint(0, 70))


def make_body(rng, name=NAME_REAL, M=8, N=4, two=0, smart=0, start=(1, 1), snd_kinds=('none', 'none', 'none', 'none'), ch=(1, 2, 3, 4),
              capmix=('real', 'real', 'real', 'none'), cap_ch=((3, 4, 5), (6, 7, 8)), ended=None, left=None, btn=None, finish_rect=None,
              light_flat=False, big=False, garbage=True, positions=None):
    b = bytearray(rng.getrandbits(8) for _ in range(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    put_name(b, 0, 'real', rng) if name is None else None
    if name is not None:
        b[0:0x21] = bytes(rng.getrandbits(8) for _ in range(0x21)) if garbage else bytes(0x21)
        b[0:len(name)] = name[:0x20]
        b[len(name[:0x20])] = 0
        b[0x20] = 0 if len(name) >= 0x20 else b[0x20]
        if 0 not in b[0:0x21]:
            b[0x20] = 0
    struct.pack_into('<h', b, B_M, M)
    struct.pack_into('<h', b, B_N, N)
    b[B_TWO], b[B_SMART] = two & 0xFF, smart & 0xFF
    struct.pack_into('<h', b, B_START_P, start[0])
    struct.pack_into('<h', b, B_START_C, start[1])
    for base, count in ((B_ROLL_A, 4), (B_ROLL_B, 4), (B_POS, 15), (B_PBARRACK, 6), (B_PJAIL, 6), (B_CBARRACK, 6), (B_CJAIL, 6)):
        pos_list = positions if (base == B_POS and positions is not None) else None
        for k in range(count):
            struct.pack_into('<4i', b, base + 16 * k, *(pos_list[k] if pos_list else rrect(rng, big)))
    # three buttons, the lights, the work sources, the images: rectangles
    brects = btn or [rrect(rng) for _ in range(3)]
    for k in range(3):
        struct.pack_into('<4i', b, B_BUTTON + 16 * k, *brects[k])
    lp = rrect(rng)
    lc = rrect(rng)
    if light_flat:
        lp = (lp[0], lp[1], lp[0], lp[3])
    elif lp[2] == lp[0]:
        lp = (lp[0], lp[1], lp[0] + 5, lp[3])
    struct.pack_into('<4i', b, B_LIGHT_P, *lp)
    struct.pack_into('<4i', b, B_LIGHT_C, *lc)
    for k in range(8):
        struct.pack_into('<4i', b, B_WORK + 16 * k, *rrect(rng, big))
    for off in (B_IMG, B_IMG + 16, B_IMG_AFTER, B_IMG_AFTER + 16, B_PIECE_PB, B_PIECE_CB, B_PIECE_CJ, B_PIECE_PJ, B_BTN_DOWN, B_BTN_DOWN + 16,
                B_BTN_DOWN + 32, B_LIGHT_P_ON, B_LIGHT_C_ON, B_PASS_OFF):
        struct.pack_into('<4i', b, off, *rrect(rng, big))
    for k in range(4):
        put_name(b, B_SND_STEP + 0x31 * k, snd_kinds[k], rng)
        struct.pack_into('<h', b, B_SND_STEP + 0x31 * k + 0x21, ch[k])
    for e in range(2):
        base = B_CAP + B_CAP_STRIDE * e
        struct.pack_into('<3h', b, base, *cap_ch[e])
        for i in range(22):
            kind = capmix[i % len(capmix)] if isinstance(capmix, (list, tuple)) and not callable(capmix) else 'real'
            put_name(b, base + 6 + 0x21 * i, kind, rng)

    def put(off, blk, two_flags):
        struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, off + 0x14, sgn(blk['start'], 2))
        struct.pack_into('<h', b, off + 0x16, blk['flag'])
        b[off + 0x18] = blk['value'] & 0xFF
        if two_flags:
            struct.pack_into('<h', b, off + 0x19, blk['flag2'])
            b[off + 0x1B] = blk['value2'] & 0xFF
    put(B_ENDED, ended if ended is not None else block(9999), True)
    put(B_LEFT, left if left is not None else block(9999), False)
    fr = finish_rect or rrect(rng)
    struct.pack_into('<4i', b, B_FINISH_RECT, *fr)
    assert len(b) == BODY_LEN
    return bytes(b)


def patch(body, off, data):
    b = bytearray(body)
    b[off:off + len(data)] = data
    return bytes(b)


def body_info(body):
    w = lambda o: struct.unpack_from('<h', body, o)[0]  # noqa: E731
    rect = lambda o: struct.unpack_from('<4i', body, o)  # noqa: E731
    return dict(M=w(B_M), N=w(B_N), two=body[B_TWO], smart=body[B_SMART], start=(w(B_START_P), w(B_START_C)),
                buttons=[rect(B_BUTTON + 16 * k) for k in range(3)], finish=rect(B_FINISH_RECT),
                positions=[rect(B_POS + 16 * k) for k in range(15)])


_REAL = []


def real_rows():
    """The two real raw-0xda rows (body, dependency tail, subtype), read from the local evidence; [] when absent."""
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
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
EVENT_RANGE = (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, ENTRY_RANGE, EVENT_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)] + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [OBJ_RANGE],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0,
                known_divergences=Counter(), queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(),
                states=Counter(), outcomes=Counter(), slots=Counter(), blit_kinds=Counter(), geometry=Counter(), strings_compared=0)


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
    for name, off in OBJ_RECTS.items():
        if a[off:off + 16] != b[off:off + 16]:
            out.append('%s original %s native %s' % (name, struct.unpack_from('<4i', a, off), struct.unpack_from('<4i', b, off)))
    if a[SOUND_NAME_OFF:SOUND_NAME_OFF + SOUND_NAME_LEN] != b[SOUND_NAME_OFF:SOUND_NAME_OFF + SOUND_NAME_LEN]:
        out.append('sound_name original %s native %s' % (a[SOUND_NAME_OFF:SOUND_NAME_OFF + SOUND_NAME_LEN].hex(),
                                                         b[SOUND_NAME_OFF:SOUND_NAME_OFF + SOUND_NAME_LEN].hex()))
    for lo, hi in UNMODELLED:
        if a[lo:hi] != b[lo:hi]:
            out.append('unmodelled bytes %#x..%#x original %s native %s' % (lo, hi, a[lo:hi].hex(), b[lo:hi].hex()))
    if not out:
        k = next(i for i in range(OBJ_LEN) if a[i] != b[i])
        out.append('byte %#x original %02x native %02x (not covered by a named field)' % (k, a[k], b[k]))
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
        self.clock = 100000
        self.trace = []
        self.row_images = []
        self.loaded_expected = []
        self.handle_i = 0

    def da_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xDA]

    # -- scripted queues: values every action may consume -----------------------------------------------------------------
    def tick_values(self, rng, n):
        mode = self.sc.get('tickmode', 'mixed')
        if mode == 'const' or (mode == 'mixed' and rng.random() < 0.4):
            return [self.clock] * n
        out, t = [], self.clock
        for _ in range(n):
            out.append(t & M32)
            t += rng.choice((0, 0, 1, 1, 2, 5, 100, 300))
        return out

    def rand_values(self, rng, n):
        mode = self.sc.get('randmode', 'uniform')
        if mode == 'even':
            return [rng.getrandbits(14) * 2 for _ in range(n)]
        if mode == 'odd':
            return [rng.getrandbits(14) * 2 + 1 for _ in range(n)]
        if mode == 'edge':
            return [rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 32766, 32767, rng.getrandbits(15))) for _ in range(n)]
        if mode == 'mixed':
            return [(rng.getrandbits(14) * 2 + (k // 2 % 2)) if k % 17 < 8 else rng.getrandbits(15) for k in range(n)]
        return [rng.getrandbits(15) for _ in range(n)]

    def busy_values(self, rng, n):
        mode = self.sc.get('busy', 'random')
        if mode == 'free':
            return [0] * n
        if mode == 'busy':
            return [rng.choice((1, 1, 2, 0x100, M32)) for _ in range(n)]
        if mode == 'pulse':
            return [1, 1, 0] * (n // 3 + 1)
        return [rng.choice((0, 0, 0, 1, 1, 2, 0x10000, M32)) for _ in range(n)]

    def cap_values(self, rng, n):
        mode = self.sc.get('cap', 'mixed')
        out = []
        for _ in range(n):
            r = rng.random()
            if mode == 'none' or (mode == 'mixed' and r < 0.2):
                out.append(None)
            elif mode == 'empty' or (mode == 'mixed' and r < 0.25):
                out.append(b'')
            else:
                size = rng.choice((1, 2, 7, 33, 80, 120, 199, 200)) if mode == 'mixed' or mode == 'long' else rng.randint(1, 40)
                out.append(bytes(rng.choice(range(0x20, 0x7F)) if rng.random() < 0.9 else rng.randint(0x80, 0xFF) for _ in range(size)))
        return out

    def queues(self, rng, over=None, nrand=3000, ntick=96):
        over = over or {}
        self.handle_i += 1
        q = dict(tick=self.tick_values(rng, ntick), rand=self.rand_values(rng, nrand), handle=[HANDLES[self.handle_i % 5]] * 2,
                 busy=self.busy_values(rng, 160), caption=self.cap_values(rng, 96))
        q.update(over)
        return q


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(slot=-1, row=rng.choice((-1, 0, 1, 3)), surface=rng.choice((0, 0, 0, 0x5151, M32)), state=rng.choice((0, 1, 2, 3, 5, 9, 0xB, M32)),
             anim_active=rng.choice((0, 1)), button_kind=rng.choice((0, 1, 2)), button_down=rng.choice((0, 1)), score_player=rng.choice((0, 1, 2)),
             score_computer=rng.choice((0, 1, 2)), mode=rng.choice((0, 1, 2, 3)), side=rng.choice((0, 1)), light=rng.choice((0, 1)),
             finish_kind=rng.choice((0, 0, 0, 1)), active=0, won=rng.choice((0, 0, 0, 1)), pending_button=rng.choice((0, 1, 2)),
             pos_player=rng.choice((1, 2, 3)), pos_computer=rng.choice((1, 2, 3)))
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
    for k, r in init.get('rects', {}).items():
        put_rect(img, k, r)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    # the process cells
    world = struct.pack('<i', sgn(init.get('start', rng.choice((0, 1, M32, 5))), 4))
    x.wr(CELL_START, world)
    nat.set_world(world)
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    x.set_cell(CELL_CAPDEST, CAPDEST_HANDLE)
    view = init.get('view', (0, 0, 640, 480))
    x.wr(CELL_VIEW, struct.pack('<4i', *[sgn(v, 4) for v in (view[0], view[1], view[0] + 640, view[1] + 480)]))
    nat.set_view(view[0], view[1])
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
    img_x, img_n = x.obj_image(), nat.obj()
    if img_x != img_n:
        raise Mismatch('%s: object image 0x624734..+0x1b9 differs: %s' % (where, '; '.join(diff_obj(img_x, img_n)[:6])))
    stats['compared_fields'] += len(OBJ_SCALARS) + len(OBJ_RECTS) + 2
    wxw, wnw = x.world_image(), nat.world()
    if wxw != wnw:
        raise Mismatch('%s: process cell start flag 0x5bb1ca differs: original %s native %s' % (where, wxw.hex(), wnw.hex()))
    stats['compared_fields'] += 1
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
    for name in ('c162d', 'c1631', 'c1639'):         # these three cells are fields of an entry: the host-composed values
        va, sz = POINTER_CELLS[name]
        struct.pack_into('<I', ent, va - ENTRY, run.cells[name])
    check(stats, where, 'generic Z entry table (0x58 x 0x4a bytes, cursor cells composed)', x.rd(ENTRY, NENT * STRIDE), bytes(ent))
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
    for k in QKIND + ('caption',):
        check(stats, where, 'queue %s consumed' % k, x.qpos[k], nat.qpos(k))
        check(stats, where, 'queue %s underflow (native)' % k, 0, nat.qunder(k))
        stats['queue_values_consumed'] += x.qpos[k]
    check(stats, where, 'host contract errors (record pointers, slot range, allocator, entry label)', (0, 0, 0), nat.errors())


def check_strings(where, x, nat, stats, loaded_expected=None):
    check(stats, where, 'image names the loader was asked for', x.loaded, nat.strs(0))
    if loaded_expected is not None:
        check(stats, where, 'image names expected from the body', x.loaded, loaded_expected)
    check(stats, where, 'caption lookup names', x.cap_names, nat.strs(1))
    check(stats, where, 'shown caption strings (text + suffix)', x.shown, nat.strs(2))
    stats['strings_compared'] += len(x.loaded) + len(x.cap_names) + len(x.shown)


def native_fx(nat, run):
    """New observer entries and host calls since the previous call: (mapped observer, host calls, observer host-call subset)."""
    fx, hc = nat.log(0), nat.log(1)
    nf, nh = fx[run.fx_seen:], hc[run.hc_seen:]
    run.fx_seen, run.hc_seen = len(fx), len(hc)
    mapped = [norm_fx(k, a, b) for k, a, b in nf]
    hosts = [norm_fx(k, a, b) for k, a, b in nh]
    only = [e for e in mapped if e[1] in HOST_FX]
    return mapped, hosts, only


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
        stats['states']['phase_visit_state_%d' % min(max(fld(img, 'state'), -1), 12)] += 1
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
                nat.set_start(1)
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0xDA:
                visit_da(where, x, nat, run, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', norm_events(x.events), expected)
    stats['ordered_events'] += len(x.events)
    check_strings(where, x, nat, stats, run.loaded_expected)
    run.loaded_expected = []
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


def visit_da(where, x, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only = native_fx(nat, run)
    if status != OK:
        o = nat.obj()
        bi = body_info(body)
        raise d9.OracleError('%s: native bul_step status %d for row %d phase %d (a native refusal the scenario must avoid); object before: %s, M %d N %d' % (
            where, status, i, phase, {k: fld(pre, k) for k in ('active', 'row', 'mode', 'score_player', 'score_computer', 'pos_player', 'pos_computer', 'side',
                                                               'button_kind', 'state')}, bi['M'], bi['N']))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
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
    run.loaded_expected += [d9.cstr(body[:0x21])] * sum(1 for e in mapped if e[1] == FX['SURFACE_LOAD'])
    if phase == 0:
        stats['slots'][fld(nat.obj(), 'slot')] += 1
        info = body_info(body)
        stats['geometry']['M_%d' % info['M']] += 1
        stats['geometry']['N_%d' % info['N']] += 1
        stats['geometry']['two_players_%d' % (info['two'] != 0)] += 1
        stats['geometry']['smart_%d' % (info['smart'] != 0)] += 1
    if completed:
        check(stats, where, 'native completion phase', phase_after, 0)
        r['phase'] = 0
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
        stats['handler_visits']['phase2_%s' % ('ended_won' if fld(pre, 'finish_kind') and fld(pre, 'won') else 'ended_lost' if fld(pre, 'finish_kind') else 'left')] += 1
        return
    if phase != 1:
        stats['handler_visits']['phase_other'] += 1
        return
    mode = fld(pre, 'mode')
    stats['handler_visits']['phase1_state_%s' % (state if 0 <= state <= 11 else 'other')] += 1
    stats['handler_visits']['phase1_state_%s_mode_%d' % (state if 0 <= state <= 11 else 'other', mode)] += 1
    if state == 0:
        if fld(pre, 'anim_active'):
            stats['outcomes']['idle_anim_kind_%d' % fld(pre, 'button_kind')] += 1
        else:
            stats['outcomes']['idle_%s' % ('computer_decides' if body[B_TWO] == 0 and mode >= 2 else 'wait_for_player')] += 1
    if FX['CAPTION_SHOW'] in kinds:
        stats['outcomes']['caption_shown'] += 1
    elif FX['CAPTION_TEXT'] in kinds:
        stats['outcomes']['caption_without_text'] += 1
    if FX['ROW_PHASE'] in kinds:
        stats['outcomes']['row_phase_2_stored'] += 1


def row_phase_of(x, row):
    return x.row_phase(row)


def pick_row_body(run, nat, img):
    """The body of the row the object names (None when it names none of the oracle's puzzle rows)."""
    row = fld(img, 'row')
    if 0 <= row < len(run.rows) and run.rows[row]['type'] == 0xDA:
        return row, run.rows[row]['body']
    return None, None


def do_pointer(where, x, nat, run, stats, rng, px, py, light=False):
    img = nat.obj()
    active = fld(img, 'active') != 0
    ri, body = pick_row_body(run, nat, img)
    if active and ri is None:
        stats['skipped_native_refusal']['pointer: active object whose row is not a puzzle row'] += 1
        return False
    if body is None:
        body = next(r['body'] for r in run.rows if r['type'] == 0xDA)
    sync_row_images(x, run)
    stats['actions']['pointer'] += 1
    xdw = (px & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= px <= 0xFFFF else px & M32
    ydw = (py & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= py <= 0xFFFF else py & M32
    nat.clear_logs()
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, kind, sub, cell, link, button = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native bul_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax, 1 if hit else 0)
    stats['pointer']['hit' if hit else 'inactive' if not active else 'miss'] += 1
    if hit:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = cell & M32
        run.cells['c1639'] = 1
        check(stats, where, 'pointer: cursor cell composition (0x5b160c + kind * 32 + sub * 16)', cell & M32, (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32)
        check(stats, where, 'pointer: cursor link stored', link, 1)
        check(stats, where, 'pointer: cursor sub index', sub, 1)
        check(stats, where, 'pointer: candidate is 0x27ba or 0x27bb', cand in (CAND_BUTTON, CAND_FINISH), True)
        check(stats, where, 'pointer: button index versus the candidate', button >= 0, cand == CAND_BUTTON)
        stats['pointer']['cursor_%d' % kind] += 1
        stats['pointer']['cand_%x' % cand] += 1
        if cand == CAND_BUTTON:
            stats['pointer']['button_%d' % button] += 1
    else:
        check(stats, where, 'pointer: no candidate on a miss', cand, -1)
        check(stats, where, 'pointer: no cursor link on a miss', link, 0)
        check(stats, where, 'pointer: no cursor kind / sub / cell / button on a miss', (kind, sub, cell, button), (0, 0, 0, -1))
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)
    return bool(hit)


def do_click(where, x, nat, run, stats, rng, queues):
    img = nat.obj()
    row = fld(img, 'row')
    active = fld(img, 'active') != 0
    cand = sgn(x.cell(CELL_CAND), 4)
    if active and not (0 <= row < len(run.rows) and run.rows[row]['type'] == 0xDA):
        stats['skipped_native_refusal']['click: active object whose row is not a puzzle row'] += 1
        return
    if active and cand == CAND_BUTTON and not 0 <= fld(img, 'pending_button') <= 2:
        stats['skipped_native_refusal']['click: pending button outside 0..2 (K2)'] += 1
        return
    ri, body = pick_row_body(run, nat, img)
    if body is None:
        body = next(r['body'] for r in run.rows if r['type'] == 0xDA)
        row_phase = 1
    else:
        row_phase = row_phase_of(x, row)
    sync_row_images(x, run)
    queues = start_tick(nat, run, run.queues(rng, queues))
    stats['actions']['click'] += 1
    x.run_method(queues, M_CLICK, [])
    after = row_phase_of(x, row) if ri is not None else row_phase
    handled, new_phase = None, None
    status, handled, new_phase = nat.click(body, row_phase, cand)
    if status != OK:
        raise Mismatch('%s: native bul_click status %d' % (where, status))
    new_phase &= M32
    mapped, hosts, host_only = native_fx(nat, run)
    gate = active and fld(img, 'won') == 0 and fld(img, 'state') == 0 and row_phase == 1
    want_handled = int(gate and cand in (CAND_BUTTON, CAND_FINISH))
    check(stats, where, 'click: row phase after', after, new_phase)
    check(stats, where, 'click: handled flag equals the original gate and candidate', want_handled, handled)
    check(stats, where, 'click: ordered effects', norm_events(x.events), mapped)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    stats['clicks']['finish' if want_handled and cand == CAND_FINISH else 'button' if want_handled else 'guarded'] += 1
    if want_handled and cand == CAND_BUTTON:
        stats['clicks']['button_%d' % fld(img, 'pending_button')] += 1
    if ri is not None:
        run.rows[ri]['phase'] = new_phase
    check_strings(where, x, nat, stats)
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def blit_expectation_checks(where, x, nat, stats, plan, slot, label):
    """Compare the recorded original blits with the kernel's list, in order."""
    orig = x.blits
    check(stats, where, label + ': blit count', len(orig), plan['count'])
    for k, (b, n) in enumerate(zip(orig, plan['blits'])):
        w = '%s %d' % (label, k)
        check(stats, where, w + ': kind (label)', b['kind'], n['kind'])
        check(stats, where, w + ': this pointer', b['this'], THIS_SURF)
        check(stats, where, w + ': target surface', b['target'], TARGET_HANDLE)
        check(stats, where, w + ': draw routine only for the pressed button', (b['kind'] == DRAW_KIND), (n['kind'] == DRAW_KIND))
        if b['kind'] in BACKDROP_KINDS:
            check(stats, where, w + ': source surface is the background entry 1', b['src_surface'], x.cell(CELL_BG))
            check(stats, where, w + ': native backdrop marker', n['backdrop'], 1)
        else:
            check(stats, where, w + ': source surface is the entry surface of the slot', b['src_surface'], x.entry_surface(slot))
            check(stats, where, w + ': native puzzle-surface marker', n['backdrop'], 0)
        check(stats, where, w + ': source rectangle contents', b['src'], n['src'])
        check(stats, where, w + ': destination rectangle contents', b['dst'], n['dst'])
        kind = b['kind']
        if kind in (1, 2):
            base = OBJ + (0x36 if kind == 1 else 0x76)
            idx, rem = divmod(b['src_ptr'] - base, 16)
            check(stats, where, w + ': roll rectangle index (source pointer)', (idx, rem), (n['index'], 0))
        elif kind in (15, 16):
            body_at = x.body_ptr(b['src_ptr']) if kind == 15 else None
            if body_at is not None:
                idx, rem = divmod(b['src_ptr'] - (body_at + B_BTN_DOWN), 16)
                check(stats, where, w + ': button kind (source pointer)', (idx, rem), (n['index'], 0))
        stats['blits'] += 1
        stats['blit_kinds'][kind] += 1
    stats['renders']['blits_%d' % min(plan['count'], 40)] += 1


def do_render(where, x, nat, run, stats, rng):
    img = nat.obj()
    ri, body = pick_row_body(run, nat, img)
    slot = fld(img, 'slot')
    if fld(img, 'active') == 0 or slot == -1:
        stats['skipped_native_refusal']['render: inactive object / slot -1 (K7)'] += 1
        return
    if ri is None or not 0 <= slot < NENT:
        stats['skipped_native_refusal']['render: row not a puzzle row / slot outside the table'] += 1
        return
    stats['actions']['render'] += 1
    x.w32(ENTRY + slot * STRIDE + 8, PUZZLE_HANDLE)
    nat.entry_set(slot, 8, PUZZLE_HANDLE)
    sync_row_images(x, run)
    start_tick(nat, run, {})
    x.run_method({}, M_RENDER, [], 0)
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native bul_render status %d' % (where, plan['status']))
    mapped, hosts, host_only = native_fx(nat, run)
    blit_fx = [e for e in mapped if e[1] == FX['BLIT']]
    check(stats, where, 'render: observed blit effects equal the blit list', [(e[2], e[3]) for e in blit_fx],
          [(b['kind'], b['index']) for b in plan['blits']])
    check(stats, where, 'render: no effects besides the blit annotations (the original makes none)', (norm_events(x.events), [e for e in mapped if e[1] != FX['BLIT']], hosts),
          ([], [], []))
    check(stats, where, 'render: valid', plan['valid'], 1)
    blit_expectation_checks(where, x, nat, stats, plan, slot, 'render')
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'render', stats)
    compare_all(where, x, nat, stats, run)
    # the engine clears the redraw request after drawing: make it observable for the invalidate action
    x.w32(ENTRY + slot * STRIDE + 0x14, 0)
    nat.entry_set(slot, 0x14, 0)


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
        raise Mismatch('%s: native bul_invalidate failed' % where)
    mapped, hosts, host_only = native_fx(nat, run)
    check(stats, where, 'invalidate: observed effect', mapped, [norm_fx(FX['MARK_DIRTY'], slot, 0)] if marks else [])
    check(stats, where, 'invalidate: host calls', hosts, host_only)
    check(stats, where, 'invalidate: no original effects', norm_events(x.events), [])
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats, queues, rng):
    img = nat.obj()
    slot = fld(img, 'slot')
    if slot != -1 and not 0 <= (slot & 0xFFFF) < NENT:
        stats['skipped_native_refusal']['cleanup: slot outside the entry table'] += 1
        return
    stats['actions']['cleanup'] += 1
    queues = start_tick(nat, run, run.queues(rng, queues))
    sync_row_images(x, run)
    x.run_method(queues, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native bul_cleanup failed' % where)
    mapped, hosts, host_only = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surface, slot)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.obj_image())
    world = None
    for k, v in d.items():
        if k in OBJ_SCALARS:
            put_fld(img, k, v)
        elif k == 'rects':
            for n, r in v.items():
                put_rect(img, n, r)
        elif k == 'sound_name':
            img[SOUND_NAME_OFF:SOUND_NAME_OFF + SOUND_NAME_LEN] = bytes(v).ljust(SOUND_NAME_LEN, b'\0')[:SOUND_NAME_LEN]
        elif k == 'raw':
            for off, data in v.items():
                img[off:off + len(data)] = data
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
            if va >= ENTRY:
                nat.entry_set((va - ENTRY) // STRIDE, (va - ENTRY) % STRIDE, v)
        elif k == 'start':
            world = struct.pack('<i', sgn(v, 4))
        elif k == 'engine_mode':
            x.set_cell(CELL_MODE, v)
            cells = nat.cells()
            nat.set_cells([v] + cells[1:8])
        elif k == 'busy_slots':       # {slot: value} of the +0x18 dword of the entry
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
            x.wr(CELL_VIEW, struct.pack('<4i', *[sgn(t, 4) for t in (v[0], v[1], v[0] + 640, v[1] + 480)]))
            nat.set_view(v[0], v[1])
        else:
            raise d9.OracleError('unknown set key ' + k)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    if world is not None:
        x.wr(CELL_START, world)
        nat.set_world(world)


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


def advance(run, rng, choices=(1, 10, 100, 250, 299, 300, 301, 500, 799, 800, 801, 1000, 1200, 5000)):
    run.clock = (run.clock + rng.choice(choices)) & M32
    return run.clock


def ensure_mode(x, nat, run):
    if nat.cells()[0] != 3:
        do_set(x, nat, run, {'engine_mode': 3})


def do_action(x, nat, run, stats, rng, sc, ai, act, depth=0):
    kind = act[0]
    where = '%s action %d%s %s' % (sc['id'], ai, '.%d' % depth if depth else '', kind)
    run.trace.append('%s%s' % (kind, '' if len(act) < 2 else ' ' + repr(act[1:])[:90]))
    result = None
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    if kind == 'tick':
        do_tick(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'pointer':
        result = do_pointer(where, x, nat, run, stats, rng, act[1], act[2])
    elif kind == 'probes':
        pts = act[1]
        for k, (px, py) in enumerate(pts):
            do_pointer(where, x, nat, run, stats, rng, px, py, light=(k % 16 != 15 and k != len(pts) - 1))
    elif kind == 'click':
        do_click(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {})
    elif kind == 'render':
        do_render(where, x, nat, run, stats, rng)
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
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
    elif kind == 'opts':
        run.sc = dict(run.sc, **act[1])
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
    elif kind == 'state':
        macro_state(where, x, nat, run, stats, rng, act[1], sub)
    elif kind == 'sweep':
        macro_sweep(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else 0, sub)
    elif kind == 'render_all_states':
        macro_render_states(where, x, nat, run, stats, rng, sub)
    else:
        raise d9.OracleError('unknown action ' + kind)
    stats['actions'][kind] += 1
    return result


# ---------------------------------------------------------------------------------------------
# macros: the random player steers by the live object (deadlines, states, buttons)
# ---------------------------------------------------------------------------------------------
def cur_row(run):
    return run.da_rows()[0]


DEADLINES = {0: 'anim_deadline', 3: 'deadline_16e', 4: 'deadline_180', 6: 'deadline_17c', 11: 'deadline_16e'}


def steer_clock(run, rng, img, dts):
    """Next clock value: sometimes exactly at, just before or after the deadline the current state waits for."""
    state = fld(img, 'state')
    if state == 0 and not fld(img, 'anim_active'):
        return advance(run, rng, dts)
    name = DEADLINES.get(state)
    if name is not None and rng.random() < 0.5:
        dl = fld(img, name) & M32
        run.clock = rng.choice(((dl - 1) & M32, dl, (dl + 1) & M32, (dl + 2) & M32, (dl + 5000) & M32))
        return run.clock
    return advance(run, rng, dts)


def point_for(rng, info, what):
    b = info['buttons']
    if what == 'roll':
        l, t, r, bt = b[0]
        return ((l + r) // 2, (t + bt) // 2)
    if what == 'pass':
        l, t, r, bt = b[1]
        return ((l + r) // 2, (t + bt) // 2 + 5)
    if what == 'reset':
        l, t, r, bt = b[2]
        return ((l + r) // 2, (t + bt) // 2)
    if what == 'finish':
        l, t, r, bt = info['finish']
        return ((l + r) // 2, (t + bt) // 2)
    return (rng.randint(-20, 700), rng.randint(-20, 500))


def macro_play(where, x, nat, run, stats, rng, opts, sub):
    """Ticks (and pointer moves, clicks, renders, invalidates) with the clock steered by the live object until the puzzle finishes."""
    ri = cur_row(run)
    info = body_info(run.rows[ri]['body'])
    dts = opts.get('dts', (1, 10, 100, 250, 299, 300, 301, 500, 799, 800, 801, 1000, 1200))
    done = False
    for k in range(opts.get('steps', 80)):
        ensure_mode(x, nat, run)
        img = nat.obj()
        phase = run.rows[ri]['phase']
        steer_clock(run, rng, img, dts)
        if phase == 1 and fld(img, 'active') and rng.random() < opts.get('p_input', 0.35):
            what = rng.choices(('roll', 'pass', 'reset', 'finish', 'random'), weights=opts.get('w_input', (6, 3, 1, 0.3, 1)))[0]
            px, py = point_for(rng, info, what)
            if sub(k, ('pointer', px, py)) and rng.random() < opts.get('p_click', 0.9):
                sub(k, ('click', dict(tick=[run.clock] * 96)))
        if rng.random() < opts.get('p_render', 0.4):
            sub(k, ('render',))
        if rng.random() < opts.get('p_invalidate', 0.05):
            sub(k, ('invalidate',))
        sub(k, ('tick', {}))
        if run.rows[ri]['phase'] == 0 and not fld(nat.obj(), 'active') and k > 0 and phase != 0:
            done = True
            break
    stats['outcomes']['play_finished' if done else 'play_steps_exhausted'] += 1


def macro_finish(where, x, nat, run, stats, rng, opts, sub):
    """Ticks through the end: caption waits, the exit delay, the finish (phase 2) and the cleanup."""
    ri = cur_row(run)
    for k in range(opts.get('steps', 14)):
        ensure_mode(x, nat, run)
        img = nat.obj()
        phase = run.rows[ri]['phase']
        if phase == 0 and not fld(img, 'active'):
            break
        steer_clock(run, rng, img, (1000, 5000, 60000))
        sub(k, ('tick', {}))


def rand_state(rng, info, clock, state=None, **over):
    """A consistent in-game object state (every field within the ranges the kernel accepts), deadlines around the clock."""
    M, N = info['M'], info['N']
    # deadlines around the clock, plus far ones: the original compares the 32-bit values unsigned
    near = lambda: (clock + rng.choice((-100000, -1000, -2, -1, 0, 1, 2, 5, 1000, 100000, -0x7FFFFFFF, 0x7FFFFFFF, 0x80000000, 0xFFFFFF00))) & M32  # noqa: E731
    state = rng.randint(0, 11) if state is None else state
    # a score at N may only be forced where no later step adds a point (the kernel refuses an object whose score exceeds N, K2)
    top = N if state in (9, 10, 11) else max(N - 1, 0)
    st = dict(state=state, mode=rng.randint(0, 3), score_player=rng.randint(0, top), score_computer=rng.randint(0, top),
              pos_player=rng.randint(1, M), pos_computer=rng.randint(1, M), anim_active=rng.choice((0, 0, 1)), button_kind=rng.randint(0, 2),
              button_down=rng.choice((0, 1)), anim_deadline=near(), deadline_16e=near(), deadline_17c=near(), deadline_180=near(),
              side=rng.choice((0, 1)), moves=rng.randint(1, 5), step=rng.randint(0, 6), light=rng.choice((0, 1)), finish_kind=rng.choice((0, 0, 1)),
              won=rng.choice((0, 1)), next_state=rng.choice((0, 1, 2, 0xB, 6, 10, 7)), cap_channel=rng.choice((-3, 0, 3, 40, -32768, 32767)),
              pending_button=rng.randint(0, 2))
    rects = {}
    for name in ('moving', 'erase'):
        if rng.random() < 0.5:
            rects[name] = (0, 0, 0, 0) if rng.random() < 0.3 else rrect(rng)
    for name in ('cur_player', 'cur_computer', 'image_player', 'image_computer', 'clear0', 'clear1', 'clear2', 'clear3') + tuple(
            'roll_a%d' % i for i in range(4)) + tuple('roll_b%d' % i for i in range(4)):
        if rng.random() < 0.7:
            rects[name] = rrect(rng)
    if rng.random() < 0.7:
        st['rects'] = rects
    st['sound_name'] = bytes(rng.choice(b'abcdefghij') for _ in range(rng.randint(0, 20)))
    st['start'] = rng.choice((0, 1, 1, 5))        # the start flag 0x5bb1ca: the button sounds are gated on it
    st.update(over)
    return st


def macro_state(where, x, nat, run, stats, rng, opts, sub):
    """Force many in-game object states and run one dispatcher pass (plus optionally pointer / click / render) at clocks around the deadlines."""
    ri = cur_row(run)
    info = body_info(run.rows[ri]['body'])
    for k in range(opts.get('n', 30)):
        ensure_mode(x, nat, run)
        if run.rows[ri]['phase'] != 1 or not fld(nat.obj(), 'active'):
            sub(k, ('rearm',))
            sub(k, ('tick', {}))
            if run.rows[ri]['phase'] != 1:
                sub(k, ('setphase', ri, 1))
        advance(run, rng, (1, 1000, 100000))
        st = rand_state(rng, info, run.clock, state=opts.get('state'), **opts.get('over', {}))
        sub(k, ('set', st))
        if rng.random() < 0.5:
            sub(k, ('render',))
        if rng.random() < opts.get('p_input', 0.3):
            px, py = point_for(rng, info, rng.choice(('roll', 'pass', 'reset', 'finish', 'random')))
            if sub(k, ('pointer', px, py)) and rng.random() < 0.7:
                sub(k, ('click', {}))
        for _ in range(opts.get('ticks', 2)):
            sub(k, ('tick', {}))
            if rng.random() < 0.5:
                run.clock = (run.clock + rng.choice((1, 100, 1000))) & M32
        if run.rows[ri]['phase'] == 0:
            sub(k, ('rearm',))


def macro_sweep(where, x, nat, run, stats, rng, extra, sub):
    """Pointer positions on and around every hit rectangle, for every mode, animation flag and player setting."""
    ri = cur_row(run)
    info = body_info(run.rows[ri]['body'])
    pts = []
    for rect, (dl, dr, dt, db) in ((info['buttons'][0], (0, 0, -5, 5)), (info['buttons'][1], (10, -10, 5, 5)), (info['buttons'][2], (0, 0, 0, 0)),
                                   (info['finish'], (0, 0, 0, 0))):
        l, t, r, b = rect
        xs = sorted({l + dl - 1, l + dl, l + dl + 1, r + dr - 1, r + dr, r + dr + 1, (l + r) // 2, l - 1, l, r, r + 1, -0x8000, 0x7FFF, 0xFFFF, 0x10000 + l})
        ys = sorted({t + dt - 1, t + dt, t + dt + 1, b + db - 1, b + db, b + db + 1, (t + b) // 2, t - 1, t, b, b + 1, -0x8000, 0x7FFF, 0xFFFF, 0x10000 + t})
        pts += [(px, py) for py in ys for px in xs]
    pts += [(rng.randint(-100, 800), rng.randint(-100, 600)) for _ in range(extra)]
    for mode in (0, 1, 2, 3):
        for anim in (0, 1):
            sub(0, ('set', dict(mode=mode, anim_active=anim)))
            sub(0, ('probes', pts if (mode, anim) == (0, 0) or extra else pts[::3]))


def macro_render_states(where, x, nat, run, stats, rng, sub):
    """The render callback in every state, mode, light, animation and erase combination."""
    ri = cur_row(run)
    info = body_info(run.rows[ri]['body'])
    for state in range(12):
        for mode in (0, 1, 2, 3):
            st = rand_state(rng, info, run.clock, state=state, mode=mode, finish_kind=rng.choice((0, 1)))
            sub(0, ('set', st))
            sub(0, ('render',))
            sub(0, ('render',))
    for k in range(40):
        st = rand_state(rng, info, run.clock, state=rng.choice((0, 6, 9)), anim_active=rng.choice((0, 1)), button_down=rng.choice((0, 1)))
        sub(0, ('set', st))
        sub(0, ('render',))
        sub(0, ('invalidate',))


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def R_DA(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xDA, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


NAMES_POOL = [NAME_REAL, b'A', b'Bul Surface 7', b'N' * 0x20, b'LIB_BulPuzzle_Surface_2', b'a b']
VIEWS = [(0, 0), (-5, 7), (1000, 1000), (-1000, -700), (17, 23), (0x7FFF0000, 0x7FFF0000), (0x7FFFFFFF, -0x80000000)]
CAPMIXES = [('real', 'real', 'real', 'real'), ('real', 'none', 'none', 'none'), ('none', 'none', 'none', 'none'), ('none', 'zero', 'near1', 'real'),
            ('near2', 'near3', 'real', 'near4'), ('zero', 'zero', 'zero', 'real1'), ('real', 'long', 'near5', 'none'), ('none', 'none', 'none', 'real')]


def scenario_list(seed=0xDA59):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False, **opts):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32), **opts))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        M = kw.setdefault('M', rng.randint(1, 15))
        N = kw.setdefault('N', rng.randint(1, 6))
        kw.setdefault('start', (rng.randint(1, M), rng.randint(1, M)))
        kw.setdefault('two', rng.choice((0, 1)))
        kw.setdefault('smart', rng.choice((0, 1)))
        kw.setdefault('snd_kinds', tuple(rng.choice(SND_KINDS) for _ in range(4)))
        kw.setdefault('ch', tuple(rng.choice((-3, 0, 1, 7, 40, 0x7FFF, -0x8000)) for _ in range(4)))
        kw.setdefault('capmix', rng.choice(CAPMIXES))
        kw.setdefault('cap_ch', tuple(tuple(rng.choice((-1, 0, 5, 12, 300)) for _ in range(3)) for _ in range(2)))
        return make_body(rng, **kw)

    def play_body(**kw):
        kw.setdefault('snd_kinds', ('real', 'real', 'real', 'real'))
        kw.setdefault('capmix', ('real', 'real', 'real', 'real'))
        kw.setdefault('M', rng.randint(4, 12))
        kw.setdefault('N', rng.randint(1, 3))
        M = kw['M']
        kw.setdefault('start', (rng.randint(1, M), rng.randint(1, M)))
        # buttons far enough apart that the three hit rectangles do not overlap, finish rectangle elsewhere
        kw.setdefault('btn', [(20, 20, 80, 60), (100, 20, 180, 60), (200, 20, 260, 60)])
        kw.setdefault('finish_rect', (300, 300, 360, 340))
        return mk(**kw)

    # ---- phase 0 / render / cleanup: names, sounds, captions, handles, busy slots, views ----------------------------------------
    for k in range(48):
        view = VIEWS[k % len(VIEWS)]
        body = mk(name=NAMES_POOL[k % len(NAMES_POOL)], capmix=CAPMIXES[k % len(CAPMIXES)], light_flat=(k % 5 == 0), big=(k % 11 == 5))
        busy = [[], [0x18], [0x18, 0x19, 0x1A], list(range(0x18, 0x3C)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]][k % 6]
        init = dict(busy_slots=busy, view=view, obj=dict(surface=rng.choice((0, 0x5151)), slot=rng.choice((-1, 0x19, 0x30))),
                    start=rng.choice((0, 1, 5, M32)), cand=rng.choice((0, CAND_BUTTON)))
        S('init:%d' % k, [R_DA(body, subtype=1 + k % 2)],
          [tk(handle=[HANDLES[k % 5]] * 2), ('render',), ('invalidate',), ('pointer', 30, 30), ('render',), ('state', dict(n=4, ticks=1)), ('render_all_states',),
           ('cleanup', {}), ('render',), ('invalidate',)] + ([('sweep', 0)] if k % 3 == 0 else []),
          'init', init=init, quick=k < 3, cap=rng.choice(('mixed', 'none', 'empty', 'mixed')), busy=rng.choice(('random', 'free', 'pulse')))

    # ---- the play loop: full games, both sides, rolls, passes, resets, finishes -----------------------------------------------------
    for k in range(60):
        body = play_body(two=k % 2, smart=(k // 2) % 2, snd_kinds=tuple(rng.choice(('real', 'real', 'none', 'near1', 'zero')) for _ in range(4)),
                         capmix=rng.choice(CAPMIXES[:3] + CAPMIXES[4:]),
                         ended=rand_block(rng, rng.choice((9999, 12, -5, 0)), flag=rng.choice((-1, 0, 7, 340, 4095)), flag2=rng.choice((-1, 2, 99, 4095))),
                         left=rand_block(rng, rng.choice((9999, 3, 0x7FFF - 0x10000)), flag=rng.choice((-1, 2, 99, 4095))))
        p = dict(steps=rng.choice((80, 120)), p_input=rng.choice((0.2, 0.5, 0.8)), p_click=rng.choice((0.5, 0.9)), p_render=0.3,
                 dts=rng.choice(((1, 10, 100, 250, 299, 300, 301, 500, 799, 800, 801, 1000, 1200), (200, 400, 900, 1100), (1, 2, 3))))
        S('play:%d' % k, [R_DA(body, subtype=rng.choice((1, 1, 2)))],
          [tk(handle=[HANDLES[k % 5]]), ('play', p), ('finish', {}), ('rearm',), ('opts', dict(randmode='edge')), ('play', dict(p, steps=60)), ('finish', {}), ('render',)],
          'play', init=dict(start=rng.choice((0, 1))), quick=k < 3, randmode=rng.choice(('uniform', 'mixed', 'uniform')), busy=rng.choice(('random', 'free', 'pulse')),
          cap=rng.choice(('mixed', 'mixed', 'none')), tickmode=rng.choice(('mixed', 'const', 'inc')))

    # ---- forced object states: every state x mode with deadlines around the clock ---------------------------------------------------
    for state in range(0, 14):
        for rep in range(2):
            body = play_body(two=rep, smart=rep, snd_kinds=tuple(rng.choice(('real', 'none')) for _ in range(4)))
            S('state:%d_%d' % (state, rep), [R_DA(body, subtype=1 + rep)],
              [tk(), ('state', dict(n=14, state=state, ticks=2, p_input=0.2))], 'states', quick=(state, rep) in ((0, 0), (3, 1), (9, 0)),
              busy=rng.choice(('random', 'free', 'pulse')), randmode=rng.choice(('uniform', 'edge', 'mixed')), cap=rng.choice(('mixed', 'none')))

    # ---- random states everywhere --------------------------------------------------------------------------------------------------
    for k in range(40):
        body = mk(two=k % 2)
        S('rstate:%d' % k, [R_DA(body, subtype=1 + k % 2)], [tk(), ('state', dict(n=40, ticks=2, p_input=0.3))], 'states', quick=k == 0,
          busy=rng.choice(('random', 'free', 'pulse')), randmode=rng.choice(('uniform', 'edge', 'mixed')), cap=rng.choice(('mixed', 'none', 'empty')))

    # ---- pointer and click ----------------------------------------------------------------------------------------------------------
    for k in range(16):
        body = play_body(two=k % 2, big=(k % 7 == 3)) if k % 4 else mk(two=k % 2, btn=[rrect(rng) for _ in range(3)], finish_rect=rrect(rng))
        acts = [tk(), ('sweep', 20), ('click', {}), ('set', dict(cand=CAND_BUTTON, pending_button=1)), ('click', {}),
                ('set', dict(cand=CAND_FINISH)), ('click', {}), ('set', dict(cand=0x1234)), ('click', {}), ('set', dict(cand=CAND_BUTTON, pending_button=0))]
        for st in (dict(won=1), dict(state=1), dict(state=7), dict(active=0), dict(state=-1), dict(state=0xC)):
            acts += [('setphase', 0, 1), ('set', st), ('click', {}), ('set', dict(won=0, state=0, active=1, cand=rng.choice((CAND_BUTTON, CAND_FINISH))))]
        acts += [('setphase', 0, 2), ('click', {}), ('setphase', 0, 1), ('set', dict(cand=CAND_FINISH)), ('click', {}), ('sweep', 5)]
        S('pointer:%d' % k, [R_DA(body)], acts, 'pointer', quick=k == 0, busy=rng.choice(('random', 'free')), cap=rng.choice(('mixed', 'none')))

    # ---- phase 2: finish blocks, flags, won / lost / left ------------------------------------------------------------------------------
    for k in range(64):
        won = k % 2
        kind = (k // 2) % 2
        ended = rand_block(rng, rng.choice((9999, 12, -5, 0, 0x7FFF)), flag=rng.choice((-1, 0, 7, 340, 4095)), flag2=rng.choice((-1, 1, 88, 4095)))
        left = rand_block(rng, rng.choice((9999, 3, -0x7FFF)), flag=rng.choice((-1, 2, 99, 4095)))
        body = mk(snd_kinds=tuple(rng.choice(('real', 'none', 'zero')) for _ in range(4)), ended=ended, left=left)
        init = dict(start=rng.choice((0, 1, 5, M32)), busy_slots=[0x19, 0x1B])
        acts = [tk(handle=[HANDLES[k % 5]]), ('set', dict(won=won, finish_kind=kind, state=rng.choice((0, 7, 8, 0xB)), start=rng.choice((0, 1, 5)))),
                ('setphase', 0, 2), tk(), ('render',), ('rearm',), tk(), ('cleanup', {}), ('rearm',), tk(), ('set', dict(won=won, finish_kind=kind)), ('setphase', 0, 2), tk()]
        S('phase2:%d' % k, [R_DA(body, subtype=rng.choice((1, 1, 2, 0, 3)))], acts, 'phase2', init=init, events={rng.randint(0, 4095): rng.choice((0, 1, -1))}, quick=k < 4)

    # ---- the real rows ----------------------------------------------------------------------------------------------------------------------
    real = real_rows()
    for k, (body, tail, sub) in enumerate(real):
        info = body_info(body)
        for case in range(6):
            p = dict(steps=140, p_input=0.5, p_click=0.9, p_render=0.4, dts=rng.choice(((1, 10, 100, 250, 299, 300, 301, 500, 799, 800, 801, 1000, 1200), (200, 400, 900, 1100))))
            S('real:%d_%d' % (k, case), [R_DA(body, subtype=sub)],
              [tk(handle=[HANDLES[k]]), ('play', p), ('finish', {}), ('rearm',), tk(), ('play', dict(p, steps=60)), ('finish', {}), ('render_all_states',)], 'real',
              init=dict(start=rng.choice((0, 1))), quick=(k, case) == (0, 0), busy=('random', 'free', 'pulse')[case % 3], randmode=('uniform', 'mixed', 'edge')[case % 3],
              cap=('mixed', 'mixed', 'none')[case % 3])
        S('real_sweep:%d' % k, [R_DA(body, subtype=sub)], [tk(), ('sweep', 10), ('state', dict(n=30, ticks=2))], 'real', busy='random')

    # ---- the executor: engine mode, gates, other rows, completed rows -----------------------------------------------------------------------
    for k in range(8):
        body = mk(two=k % 2)
        rows = [R67(), R_DA(body, subtype=1 + k % 2), R67(), R_DA(mk(), subtype=1, completed=1)]
        if k % 3 == 1:
            rows.append(R_DA(mk(), subtype=2, unloaded=1))
        S('mode:%d' % k, rows, [tk(), ('set', dict(engine_mode=0)), tk(), ('set', dict(engine_mode=3)), tk(), ('play', dict(steps=20)), ('finish', {}), ('rearm',), tk()],
          'mode', mode=3 if k % 2 == 0 else 1, quick=k == 0)
    # gated rows: the dependency tail is one event-flag record (the rest of the loader's tail grammar is outside the slice)
    for k in range(6):
        body = mk(two=k % 2)
        idx = rng.randint(0, 4095)
        rows = [R_DA(body, subtype=1 + k % 2, tail=event_tail(idx, 1)), R67(tail=event_tail(idx, 2))]
        S('gate:%d' % k, rows, [tk(), ('events', {idx: 1}), tk(), ('play', dict(steps=20)), ('events', {idx: 2}), ('finish', {}), tk(), ('events', {idx: 0}), tk()],
          'mode', events={idx: 0 if k % 2 else 1})

    # ---- captions: found / not found, empty, the longest text that fits, over the 0x9c40 limit --------------------------------------------
    for k in range(14):
        body = mk(capmix=('real', 'real', 'real', 'real'), snd_kinds=('real', 'real', 'real', 'real'))
        lens = [0, 1, 199, 200, 0x9C41, 0x9C41 + 7, 20, 20][k % 8]
        text = bytes(0x41 + (j % 26) for j in range(lens))
        S('caption:%d' % k, [R_DA(body)], [tk(caption=[text] * 40 if k % 2 == 0 else [None, text] * 20), ('state', dict(n=10, ticks=1, state=rng.choice((1, 7, 8, 0))))], 'caption',
          cap='mixed', quick=k == 0)

    # ---- the smart computer's decision (mode 3, state 0): position differences around 0, 5 and the wrap -------------------------------------------
    for k, (pp, pc) in enumerate(((2, 2), (1, 6), (1, 7), (7, 1), (12, 1), (12, 7), (1, 12), (6, 6), (12, 12), (5, 11), (11, 5), (3, 9), (9, 3))):
        body = play_body(two=0, smart=1, M=12, start=(1, 1))
        S('smart:%d' % k, [R_DA(body)],
          [tk(), ('state', dict(n=6, state=0, ticks=2, p_input=0.0, over=dict(mode=3, anim_active=0, pos_player=pp, pos_computer=pc)))],
          'states', busy=rng.choice(('random', 'free')), randmode=rng.choice(('uniform', 'edge')), quick=k == 0)

    # ---- random sequences that force the edge paths: odd == 0 -> five moves, every roll row, the name pick loops ---------------------------------
    for mode in ('even', 'odd', 'edge', 'mixed'):
        for k in range(3):
            body = play_body(two=k % 2, capmix=CAPMIXES[(k * 3) % len(CAPMIXES)])
            S('rand:%s_%d' % (mode, k), [R_DA(body)], [tk(), ('play', dict(steps=70, p_input=0.6)), ('finish', {})], 'rand', randmode=mode, quick=(mode, k) == ('even', 0))
    return scs


# ---------------------------------------------------------------------------------------------
# native-only refusal checks (K1..K7, none of them reachable in the game)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.obj(), nat.world(), nat.events(), nat.entries(), tuple(nat.cells()[:8]), len(nat.log(0)), len(nat.log(1)))


def refusal_checks(nat, stats):
    rng = random.Random(0xDA01)
    base = make_body(rng, snd_kinds=('real', 'real', 'real', 'real'), capmix=('real',) * 4, M=6, N=3, start=(2, 3),
                     ended=rand_block(rng, 12, flag=5, flag2=6), left=rand_block(rng, 13, flag=7))
    qs = dict(tick=[5000] * 40, rand=[7] * 400, handle=[0x1234, 0x1235, 0x1236], busy=[0] * 40, caption=[b'text'] * 40)

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
        nat.set_view(0, 0)

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    def pat(off, data, body=base):
        return patch(body, off, data)

    h = lambda v: struct.pack('<h', v)  # noqa: E731
    active = dict(active=1, row=0, slot=0x19, mode=0, pos_player=2, pos_computer=3, side=0, button_kind=0)
    # K1 bodies
    bad = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:],
           'M 0': pat(B_M, h(0)), 'M 16': pat(B_M, h(16)), 'M -1': pat(B_M, h(-1)), 'N 0': pat(B_N, h(0)), 'N 7': pat(B_N, h(7)), 'N -1': pat(B_N, h(-1)),
           'start player 0': pat(B_START_P, h(0)), 'start player M+1': pat(B_START_P, h(7)), 'start computer 0': pat(B_START_C, h(0)),
           'start computer M+1': pat(B_START_C, h(7)), 'start player -1': pat(B_START_P, h(-1))}
    for k in range(4):
        bad['sound record %d unterminated' % k] = pat(B_SND_STEP + 0x31 * k, bytes([0x42 + k] * 0x21))
    for e in range(2):
        for i in (0, 1, 7, 21):
            bad['caption %d name %d unterminated' % (e, i)] = pat(B_CAP + B_CAP_STRIDE * e + 6 + 0x21 * i, bytes([0x43] * 0x21))
    for name, b in bad.items():
        fresh(**active)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        expect('K1 no effect ' + name, snapshot(nat), snap)
        if len(b) != BODY_LEN:
            expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
            expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
            expect('K1 click ' + name, nat.click(b, 1, CAND_FINISH)[0], ERR_ARGUMENT)
    for name, b in {'valid': base, 'terminator on the last name byte': pat(0x20, b'\0', pat(0, bytes([0x41] * 0x20))),
                    'M 1': pat(B_START_P, h(1) + h(1), pat(B_M, h(1))), 'M 15': pat(B_M, h(15)), 'N 1': pat(B_N, h(1)), 'N 6': pat(B_N, h(6)),
                    'start 1 and M': pat(B_START_P, h(1) + h(6)), 'start M and 1': pat(B_START_P, h(6) + h(1)),
                    # an empty name (the terminator is its first byte) followed by non-NUL bytes: the whole 0x21-byte record is searched from its start
                    'surface name empty': pat(0, b'\0' + b'\x44' * 0x20),
                    'sound record 0 empty': pat(B_SND_STEP, b'\0' + b'\x44' * 0x20),
                    'sound record 3 empty': pat(B_SND_STEP + 0x31 * 3, b'\0' + b'\x44' * 0x20),
                    'caption 0 name 0 empty': pat(B_CAP + 6, b'\0' + b'\x44' * 0x20),
                    'caption 0 name 21 empty': pat(B_CAP + 6 + 0x21 * 21, b'\0' + b'\x44' * 0x20),
                    'caption 1 name 0 empty': pat(B_CAP + B_CAP_STRIDE + 6, b'\0' + b'\x44' * 0x20),
                    'caption 1 name 21 empty': pat(B_CAP + B_CAP_STRIDE + 6 + 0x21 * 21, b'\0' + b'\x44' * 0x20)}.items():
        expect('K1 accepted: ' + name, nat.validate(b), OK)
    fresh()
    expect('K1 phase 0 with a negative row', nat.step(base, -1, 0)[0], ERR_ARGUMENT)
    # K2 phase 1 / 2 without the initialisation
    for ph in (1, 2):
        for variant, over in (('uninitialised', dict(active=0, row=-1)), ('inactive with the row', dict(active=0, row=0)),
                              ('other row', dict(active=1, row=3)), ('row -1 active', dict(active=1, row=-1))):
            if ph == 2 and over['row'] == 0:
                continue            # phase 2 only compares the row: row 0 is the legitimate case
            fresh(**dict(active, state=1, **over))   # a valid object otherwise, so only the ownership test can refuse
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K2: hand-made objects refused before any effect (phase 1 and render)
    for what, over in (('mode 4', dict(mode=4)), ('mode -1', dict(mode=-1)), ('score player > N', dict(score_player=4)), ('score player < 0', dict(score_player=-1)),
                       ('score computer > N', dict(score_computer=4)), ('score computer < 0', dict(score_computer=-1)), ('position player 0', dict(pos_player=0)),
                       ('position player > M', dict(pos_player=7)), ('position computer 0', dict(pos_computer=0)), ('position computer > M', dict(pos_computer=7)),
                       ('side 2', dict(side=2)), ('side -1', dict(side=-1)), ('button kind 3', dict(button_kind=3)), ('button kind -1', dict(button_kind=-1))):
        st = dict(active, **over)
        fresh(**st)
        snap = snapshot(nat)
        expect('K2 phase 1 ' + what, nat.step(base, 0, 1)[0], ERR_UNSUPPORTED)
        expect('K2 render ' + what, nat.render(base)['status'], ERR_UNSUPPORTED)
        expect('K2 no effect ' + what, snapshot(nat), snap)
    for kind in (3, -1, 0x7FFF):
        fresh(**active, pending_button=kind)
        snap = snapshot(nat)
        expect('K2 click with pending button %d' % kind, nat.click(base, 1, CAND_BUTTON)[0], ERR_UNSUPPORTED)
        expect('K2 click no effect', snapshot(nat), snap)
    # K3 event flag outside the host window
    for idx in (4096, -2, 32767, -32768):
        for name, st, off in (('ended flag won', dict(finish_kind=1, won=1), B_ENDED + 0x16), ('ended flag lost', dict(finish_kind=1, won=0), B_ENDED + 0x19),
                              ('left flag', dict(finish_kind=0), B_LEFT + 0x16)):
            fresh(**dict(active, **st))
            snap = snapshot(nat)
            expect('K3 %s %d' % (name, idx), nat.step(pat(off, h(idx)), 0, 2)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    for idx in (-1, 0, 4095):
        for name, st, off in (('ended flag won', dict(finish_kind=1, won=1), B_ENDED + 0x16), ('left flag', dict(finish_kind=0), B_LEFT + 0x16)):
            fresh(**dict(active, **st))
            expect('K3 %s %d accepted' % (name, idx), nat.step(pat(off, h(idx)), 0, 2)[0], OK)
    # K4 captions longer than the 204-byte local
    for ln, want in ((200, OK), (201, ERR_BOUNDS), (0x9C40, ERR_BOUNDS), (0x9C41, OK)):
        fresh(row=-1)
        nat.set_queues(dict(qs, caption=[b'A' * ln] * 40))
        expect('K4 caption of %d characters' % ln, nat.step(base, 0, 0)[0], want)
    # K5 name pick that never ends, _rand outside 0..32767
    stuck = patch(base, B_CAP + B_CAP_STRIDE * 1 + 6, b'')
    stuck = bytearray(base)
    for i in range(22):
        stuck[B_CAP + 6 + 0x21 * i:B_CAP + 6 + 0x21 * i + 9] = NO_SOUND
    fresh(**active, state=1)
    nat.set_queues(dict(qs, rand=[0] * 10))     # the queue underflows: constant 0, the pick never sees the other names
    expect('K5 name pick never ends', nat.step(bytes(stuck), 0, 1)[0], ERR_STUCK)
    for bad_value in (32768, -1, 0x7FFFFFFF):
        fresh(row=-1)
        nat.set_queues(dict(qs, rand=[bad_value] * 400))
        expect('K5 rand %d from a name pick' % bad_value, nat.step(bytes(base), 0, 1)[0], ERR_UNSUPPORTED)   # not initialised: refused first
        fresh(**active, state=2)
        nat.set_queues(dict(qs, rand=[bad_value] * 400))
        expect('K5 rand %d from the roll pick' % bad_value, nat.step(base, 0, 1)[0], ERR_HOST)
    fresh(**active, state=2)
    nat.set_queues(dict(qs, rand=[32767] * 400))
    expect('K5 rand 32767 accepted', nat.step(base, 0, 1)[0], OK)
    # phases above 2 do nothing; the power-on object
    fresh(row=-1)
    expect('phase 3 is a no-op', nat.step(base, 0, 3)[:2], (OK, 3))
    nat.reset()
    img = nat.obj()
    expect('power-on slot and row', (fld(img, 'slot'), fld(img, 'row')), (-1, -1))
    # K7 render / invalidate / pointer / click while inactive or with the slot -1
    fresh(**dict(active, slot=-1))
    snap = snapshot(nat)
    plan = nat.render(base)
    expect('K7 render slot -1', (plan['status'], plan['valid'], plan['count']), (OK, 0, 0))
    expect('K7 render slot -1 no effect', snapshot(nat), snap)
    expect('K7 invalidate slot -1', nat.invalidate(), OK)
    fresh(**dict(active, active=0))
    plan = nat.render(base)
    expect('K7 render inactive', (plan['status'], plan['valid'], plan['count']), (OK, 0, 0))
    expect('K7 invalidate inactive', (nat.invalidate(), len(nat.log(1))), (OK, 0))
    expect('K7 pointer inactive', nat.pointer(base, 1, 1)[:3], (OK, 0, -1))
    expect('K7 click inactive', nat.click(base, 1, CAND_FINISH)[:2], (OK, 0))
    expect('K7 no host call', (len(nat.log(0)), len(nat.log(1))), (0, 0))
    # K6 host failures
    def fails(what, mask_, run_fn, **state):
        fresh(**state)
        nat.set_fail(mask_)
        expect('K6 ' + what, run_fn(), ERR_HOST)
        nat.set_fail(0)
    for what, m in (('alloc', F_ALLOC), ('register', F_REGISTER), ('load', F_LOAD), ('set_slot_surface', F_SETSURF), ('clear_item', F_CLEAR),
                    ('sound_prepare', F_PREPARE), ('caption_show', F_SHOW)):
        fails('phase 0 ' + what, m, lambda: nat.step(base, 0, 0)[0], row=-1)
    for what, m in (('release_surface', F_RELEASE_SURFACE), ('release_slot', F_RELEASE_SLOT), ('sound_stop', F_STOP), ('transition', F_TRANSITION),
                    ('store_flag', F_FLAG), ('mode', F_MODE)):
        fails('phase 2 ' + what, m, lambda: nat.step(base, 0, 2)[0], **dict(active, finish_kind=1, won=1, surface=0x77))
    fails('phase 1 sound_play', F_PLAY, lambda: nat.step(base, 0, 1)[0], **dict(active, state=3, moves=3, step=0, deadline_16e=0))
    fails('invalidate dirty', F_DIRTY, lambda: nat.invalidate(), **active)
    fails('render view origin', F_VIEW, lambda: nat.render(base)['status'], **active)
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
    """ASan + UBSan run of the kernel on bounded malformed inputs (random bodies, objects and host answers)."""
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang')
    PRIVATE.mkdir(parents=True, exist_ok=True)
    exe = Path(tempfile.mkdtemp(prefix='da_fuzz_', dir=str(PRIVATE))) / 'fuzz'
    build = [cc, '-std=c11', '-Wall', '-Wextra', '-Werror', '-O0', '-g', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
             '-fno-omit-frame-pointer', '-DBUO_FUZZ_MAIN', f'-I{args.src}', str(PROJECT / 'tests/action_family_da_runtime_oracle_driver.c'),
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
    tmp = tempfile.TemporaryDirectory(prefix='RT-59.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_da.so', strict=not args.lenient_build)
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
            args.result.write_text(json.dumps(dict(slice='RT-59', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_da.so', strict=not args.lenient_build)
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
        args.result.write_text(json.dumps(dict(slice='RT-59', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
