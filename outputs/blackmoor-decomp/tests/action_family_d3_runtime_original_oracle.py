#!/usr/bin/env python3
"""RT-53: immutable x86 dispatcher 0x427a50 / handler 0x463392 (raw 0xd3, the Collision Puzzle), the object methods 0x462c39 (pointer, with
its inner 0x4630a3 / 0x4619be), 0x4631d1 (click), 0x463b10 (render callback), 0x4618ab (invalidate), 0x461862 + 0x461827 (cleanup) and the
grid reset 0x4618df versus the native kernel src/action_family_d3_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xd3 (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a210, the handler
0x463392 with every phase and all five states of obj+0x24 (plus values above 4 that fall out of the switch), the one-time grid setup
0x462577 with the cell rectangle 0x462b84, the move check 0x4619be, the animation step 0x461d82, the cell type test 0x461d4b, the solved
scan 0x4632bf, the generic completion 0x42ba3a (subtype 1 sets the completion byte, subtype 2 clears it and runs the dependency reset
0x423d33, every subtype stores phase 0) and the cleanup 0x461862 / 0x461827. The generic Z entry allocator 0x4d39f9 and releaser 0x4d3992
run as original code on the table at 0x5d1591 (busy seeds decide which slot comes back). The object methods run as original functions on
the same process image with ECX = 0x61d779: the pointer test 0x462c39 (two stack words x, y whose upper halves are garbage), the click
0x4631d1 (no arguments; it reads the retained candidate 0x5c39e5 and the start flag 0x5bb1ca and guards itself), the render callback
0x463b10 (cdecl, reads the slot and row through the globals 0x61d795 / 0x61d797), the invalidate 0x4618ab, the cleanup 0x461862 and the
grid reset 0x4618df.

Native side: tests/action_family_d3_runtime_oracle_driver.c links ONLY the kernel (src/action_family_d3_runtime.c) and implements the HOST
side of the CpzHost contract with scripted queues (GetTickCount values, sound-busy answers, image handles), a model of the Z entry table,
the view origin, the event flag window and the scene-change cells. The driver decides nothing the kernel decides. It keeps two logs, the
observer log (CpzHost.observe) and the host-call log (what the kernel really asked of the host); the oracle requires them to agree.

Compared after EVERY action (dispatcher pass, pointer, click, render, invalidate, cleanup, grid reset):
 * the whole 0x5f-byte object image 0x61d779.. byte for byte against CpzObject (the bytes without a field come from a shadow); the start
   flag 0x5bb1ca; the setup flag word 0x594db3 and ALL 64 grid cells (2560 bytes at 0x594db5); the engine mode 0x583999; the seven
   scene-change cells; the whole event flag window (4096 dwords at 0x585801); the whole generic Z entry table (0x58 entries of 0x4a bytes);
   the candidate 0x5c39e5, the cursor cells 0x5b44f0 / 0x5b44f4 and the host-composed cells 0x5d162d / 0x5d1631 / 0x5d1639 against their
   documented composition from the native outputs ([0x5d0377] copy, 0x5b160c + (kind << 5) + (sub << 4), 1);
 * every byte of every row (except the dependency record the gate and the reset own) against a model and the whole row body (the original
   never writes it); every write outside the modelled cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every CpzEffect: the
   active flag, the start flag, grid reset and setup, clear-item, the slot, the code point after the entry label copy (0x46353d) and after
   the slot surface store (0x46357c), the image loader, the sound routines, GetTickCount, the state and phase stores, the scene cells, the
   engine mode, the event flag window, the releasers, the blits, then the completion byte, the dependency reset and the phase store of
   0x42ba3a) against the sequence the native kernel reports for the same visit, entry for entry; the scripted queues are consumed
   identically by both sides;
 * pointer: the return value (1 claims), the candidate, the cursor cells, and through the object image the piece, cell, direction and
   step counter the move check leaves behind;
 * click: the ordered effects (state, sound, phase) and the object image; render: every recorded 0x4c5d4b / 0x4c5377 blit (this, source
   surface, source rectangle contents, target, destination rectangle contents, label) against cpz_render's list including the piece number.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10)   R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4)
  R 0x4c5d4b / 0x4c5377 blit recorders (ECX 0x5cf659, ret 0x14)   R 0x4e8d96 clear pending item (ECX 0x571442, plain ret)
  R 0x51dc6c free (recorded)   R GetTickCount (import thunk stub) scripted values
  O 0x42a210 / 0x428692 arm entries, 0x42a233 / 0x4286b5 post-gate points, 0x463392 handler entry, 0x42a245 handler return, 0x42ba3a generic
    completion, 0x42babe (its ret), 0x423d33 dependency reset, 0x46353d / 0x46357c code points inside the handler, 0x4d3992 releaser entry,
    0x4618df grid reset entry, 0x462577 grid setup entry; every store to the process data region is observed (read-only)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0. The strings the kernel hard-codes (the entry label at 0x54b164, the loader's kind / label, "NO SOUND\\0" at its 13 addresses,
 the 6 blit labels) are checked against the image at start-up.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick and busy values, the view
origin, the target surface handle (cell 0x5cf665), the background / entry 1 surface (0x5d15e3), the busy seeds of the Z entry table, the
event flag window contents, the contents of the grid at the start of a scenario.

KNOWN DIVERGENCES (native safety layer; never silently skipped. Checked natively in refusal_checks(); the oracle's scenarios skip the actions
the kernel refuses (counted in stats.skipped_native_refusal) instead of running them against the original):
  K1 cpz_validate_body: short body, name / sound names without NUL in their 0x21 bytes, R or C outside 0..8, P outside 0..10, animation steps
     below 1 (the original divides by it) -> CPZ_ERR_BODY (step) / CPZ_ERR_ARGUMENT (others), no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row -> CPZ_ERR_UNSUPPORTED, no effect.
  K3 phase 2 with an event flag index (solved / cancel block, whichever the object takes) outside the host window 0..4095 and not -1 ->
     CPZ_ERR_BOUNDS before the first effect.
  K4 render of a cell whose piece number is outside 1..10 (the original indexes past the body) -> CPZ_ERR_BOUNDS.
  K5 setup flag: the original holds a WORD at 0x594db3 (movsx / mov word); the kernel a byte. Only the values 0 and 1 are ever stored, so the
     oracle seeds only 0/1 (and the high byte 0x594db4 stays 0, which the reset also writes).
  K6 host failures -> CPZ_ERR_HOST, allocator exhaustion (the original reaches the fatal path 0x52139c) -> CPZ_ERR_HOST.
  K7 render with the slot -1: native does nothing (valid = 0), the original would index the entry table at -1; invalidate / cleanup with a slot
     outside the entry table are skipped likewise.
 All of these are unreachable in the game (loader-built 855-byte bodies, callbacks only for allocated entries).

Not modelled / unverified: the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine, the blit bodies 0x4c5d4b / 0x4c5377,
the cascade 0x4f0059 and the accepted-release chain 0x43b273 that call 0x462c39 / 0x4631d1 (the oracle calls the methods directly), the
generic Z entry drawer that calls 0x463b10, the scene clears 0x438b5d / 0x43de52 / the new-game reset 0x438471 and the invalidate caller
0x43d910 (the methods are run directly), the loader 0x461903 that builds the body, the engine consumers of the scene-change cells, the
host composition of the cursor cells (their documented composition is checked, not the engine code that reads them), 0x4e8d96.

Dependency tails use the real loader 0x424aa8 and the original gate 0x423f57. The real bodies of the three 0xd3 rows (resources 2190 and
2194) are read at run time from work/analysis/hiff-resources (never committed); scenarios that use them are skipped otherwise.

Modes: --quick-only runs the scenarios flagged quick (seconds); the default run is every scenario plus the native-only refusal checks;
--workers N shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does
this); --discover-pins prints the PINS_TABLE of the original code the scenarios execute. The pins are verified at start-up. The planted-mutant
sweep is tests/action_family_d3_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_d3_runtime_original_oracle.py --quick-only
  python3 action_family_d3_runtime_original_oracle.py --workers 4 --result ../../../work/analysis/slices/RT-53.oracle-result.json
  python3 action_family_d3_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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
from collections import Counter, deque
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
BODY_LEN = 855
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF
RESOURCES = ROOT / 'work/analysis/hiff-resources'

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x463392, 0x42BA3A, 0x423D33, 0x42BABE
HANDLER_RETURN = 0x42A245
ARM = {0xD3: 0x42A210, 0x67: 0x428692}
VISIT = {0xD3: 0x42A233, 0x67: 0x4286B5}
M_POINTER, M_CLICK, M_RENDER, M_INVALIDATE, M_CLEANUP, M_GRID_RESET = 0x462C39, 0x4631D1, 0x463B10, 0x4618AB, 0x461862, 0x4618DF
AT_REGISTER, AT_SLOT_SURFACE = 0x46353D, 0x46357C
GRID_SETUP_FN = 0x462577
RELEASE_SLOT_FN = 0x4D3992
LOAD_IMAGE, RELEASE_IMAGE = 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
BLIT_OPAQUE, BLIT_RESTORE, CLEAR_ITEM, FREE = 0x4C5D4B, 0x4C5377, 0x4E8D96, 0x51DC6C

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ = 0x61D779
OBJ_LEN = 0x5F
GRID_FLAG, GRID = 0x594DB3, 0x594DB5
GRID_LEN = 64 * 40
WORLD_LEN = 4 + 2 + GRID_LEN
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_ORG_X, CELL_ORG_Y = 0x583186, 0x58318A
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY, THIS_ITEM = 0x5CF659, 0x5C3A67, 0x5CF1EB, 0x571442
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
LABEL_KIND, LABEL_SURFACE, LABEL_ENTRY = b'CIFTREE', b'Collision Puzzle Surface', b'COLLISION PUZZLE OVERLAYS'
NO_SOUND = b'NO SOUND\0'
NO_SOUND_VAS = (0x54B158, 0x54B1A4, 0x54B1B0, 0x54B1BC, 0x54B1C8, 0x54B1D4, 0x54B1E0, 0x54B1EC, 0x54B1F8, 0x54B204)
CAND_CANCEL = 0x277F

# the numbers of CpzEffect
FX = dict(ACTIVE=1, START_FLAG=2, GRID_RESET=3, CLEAR_ITEM=4, GRID_SETUP=5, SLOT=6, SLOT_REGISTER=7, SURFACE_LOAD=8, SLOT_SURFACE=9, PHASE=10,
          STATE=11, SOUND_PREPARE=12, SOUND_STOP=13, SOUND_PLAY=14, SOUND_BUSY=15, TICK=16, X57B=17, X599=18, X595=19, X39FF=20, X59B=21,
          X59F=22, X5A3=23, MODE=24, EVENT_FLAG=25, COMPLETE=26, RELEASE_SURFACE=27, RELEASE_SLOT=28, BLIT=29)
FXN = {v: k for k, v in FX.items()}
WORD_FIRST = {FX['SLOT'], FX['SLOT_REGISTER'], FX['SLOT_SURFACE'], FX['SOUND_PLAY'], FX['SOUND_BUSY'], FX['COMPLETE'], FX['X599'], FX['X595'],
              FX['X39FF'], FX['RELEASE_SLOT'], FX['EVENT_FLAG']}
FX_SIZE = {k: (2, 4) for k in WORD_FIRST}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
HOST_FX = {FX['CLEAR_ITEM'], FX['SLOT'], FX['SLOT_REGISTER'], FX['SURFACE_LOAD'], FX['SLOT_SURFACE'], FX['SOUND_PREPARE'], FX['SOUND_STOP'],
           FX['SOUND_PLAY'], FX['SOUND_BUSY'], FX['TICK'], FX['EVENT_FLAG'], FX['RELEASE_SURFACE'], FX['RELEASE_SLOT']}
HC_MARK_DIRTY, HC_ORIGIN = 100, 101

# blit labels: address -> (kind of CpzBlitKind, text)
BLIT_LABELS = {0x54B210: (2, b'Collision Puzzle Overlays'), 0x54B22C: (3, b'Collision Puzzle Overlays'), 0x54B248: (4, b'Collision Puzzle Overlays'),
               0x54B264: (1, b'Collision Puzzle Piece Overlays'), 0x54B284: (5, b'restore background'),
               0x54B298: (6, b'Collision Puzzle Overlays')}

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4), SND_PLAY: (0xb4, 4),
             SND_BUSY: (0x138, 4), BLIT_OPAQUE: (0x350, 0x14), BLIT_RESTORE: (0x214, 0x14), CLEAR_ITEM: (0x32, 0), FREE: (0xb, 0)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT_OPAQUE: 0x14, BLIT_RESTORE: 0x14,
        CLEAR_ITEM: 0, FREE: 0}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            SND_BUSY: THIS_BUSY, BLIT_OPAQUE: THIS_SURF, BLIT_RESTORE: THIS_SURF, CLEAR_ITEM: THIS_ITEM}

# Executed original code, as SHA-256 of the unmodified image bytes. Discovered over every scenario with --discover-pins, verified at start-up.
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
    (0x461827, 0x461862, '1bd18922c37ba4cb8d906cfb0b3783f0529acc9a1e9898b8a0092aafa1a56515'),
    (0x461862, 0x4618ab, '4bc0b8aa79a87fffbf0de4a749ff22ace8a53e3f88dadba25cdeae9d08c13a71'),
    (0x4618ab, 0x4618df, '0c4cac37cbe806d1015a6d647c96305802f683eadaaf5f12b05526349fb0c43d'),
    (0x4618df, 0x461903, 'f2f66622d9d8ce1b263c4fa502a9f04b4523cad20c8f49be8c4ea0c5b84dc1f8'),
    (0x4619be, 0x461d4b, '20b8f7774e513156493e30545ab7c3925867e648b705b02f29c3f5b1649669bc'),
    (0x461d4b, 0x461d82, 'cb08f5d1c239c2d4bde4bb68e4064e14c2a0d8473ad85894650b0d267401c812'),
    (0x461d82, 0x462577, '07ad4647f309e11290b96bbebbeba818f7c88887d44e11c2d04ba8f2ce08e85f'),
    (0x462577, 0x462b84, 'c82cc0af095a07d97d91b77617f65d80b85fe7704d8c99f36f02dffbd58301ec'),
    (0x462b84, 0x462c39, '91472233b4e954089125fb2d35671ae55ed9f876fdf3e19f81fa42ca0d776e21'),
    (0x462c39, 0x4630a3, 'f242443d2b87a491ff7710452b6ce103b86736cb167f4b658e55542a8d4040e1'),
    (0x4630a3, 0x4631d1, 'e131792c907d98f7f3f7048ebc32995e8ea5fd2d6eb12504915866689e5028b5'),
    (0x4631d1, 0x4632bf, '115e9a8ef37e51166c8b883eeb5c6ffb898d5518b68f1fa650698f3b9d57e586'),
    (0x4632bf, 0x463392, 'ebaa96204b12ef3064a71bd81781a85c1912211b2f65ea0320190801adeae3bf'),
    (0x463392, 0x463b00, '91a70bc03752e30560690d8f61a5cf79557b453e99f7021ad83d3a10fabab208'),
    (0x463b10, 0x463f00, '763e4a6c1d2e6c6cf933f8d34a043394ffa705ad684e6523cf4009922ecec557'),
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
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)

class Mismatch(Exception):
    pass


# ---- object layout (offsets from 0x61d779)
OBJ_FIELDS = (('slot', 0x1C, 2), ('row', 0x1E, 2), ('surface', 0x20, 4), ('state', 0x24, 4), ('flag28', 0x28, 1), ('saved0', 0x29, 4),
              ('saved1', 0x2D, 4), ('saved2', 0x31, 4), ('saved3', 0x35, 4), ('piece', 0x39, 2), ('moved', 0x3B, 4), ('active', 0x3F, 4),
              ('canceled', 0x43, 4), ('solved', 0x47, 4), ('deadline', 0x4B, 4), ('cell_w', 0x4F, 4), ('cell_h', 0x53, 4), ('dir', 0x57, 2),
              ('step', 0x59, 2), ('at_row', 0x5B, 2), ('at_col', 0x5D, 2))
OBJ_POS = {n: (o, s) for n, o, s in OBJ_FIELDS}
SIGNED = {'slot', 'row', 'state', 'saved0', 'saved1', 'saved2', 'saved3', 'piece', 'moved', 'active', 'canceled', 'solved', 'cell_w', 'cell_h',
          'dir', 'step', 'at_row', 'at_col'}
CELL_FIELDS = (('visible', 0, 4), ('base0', 4, 4), ('base1', 8, 4), ('base2', 12, 4), ('base3', 16, 4), ('rect0', 20, 4), ('rect1', 24, 4),
               ('rect2', 28, 4), ('rect3', 32, 4), ('type', 36, 2), ('piece', 38, 2))


def fld(img, name):
    off, size = OBJ_POS[name]
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=name in SIGNED)


def put_fld(img, name, v):
    off, size = OBJ_POS[name]
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


def cell_fields(blob, a, b):
    base = (a * 8 + b) * 40
    out = {}
    for name, off, size in CELL_FIELDS:
        out[name] = int.from_bytes(blob[base + off:base + off + size], 'little', signed=True)
    return out


def put_cell(blob, a, b, **kw):
    base = (a * 8 + b) * 40
    for name, off, size in CELL_FIELDS:
        if name in kw:
            blob[base + off:base + off + size] = (kw[name] & mask(size)).to_bytes(size, 'little')


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xd3 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('tick', 'busy', 'handle')}
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
        want = [(0x54B164, LABEL_ENTRY + b'\0'), (0x54B180, LABEL_SURFACE + b'\0'), (0x54B19C, LABEL_KIND + b'\0')]
        want += [(va, NO_SOUND) for va in NO_SOUND_VAS]
        want += [(va, text + b'\0') for va, (_, text) in BLIT_LABELS.items()]
        for va, data in want:
            if img(va, len(data)) != data:
                raise d9.OracleError('image constant at %#x differs from the kernel assumption: %r' % (va, img(va, len(data))))

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.frees = []
        self.blits = []
        self.in_complete = False
        self.cur_phase = None

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in ('tick', 'busy', 'handle')}
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
                      GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen, AT_REGISTER: self._at_register,
                      AT_SLOT_SURFACE: self._at_slot_surface, RELEASE_SLOT_FN: self._release_slot, M_GRID_RESET: self._grid_reset,
                      GRID_SETUP_FN: self._grid_setup})
        for typ, a in ARM.items():
            table[a] = self._mk_event('entry', typ)
        for typ, a in VISIT.items():
            table[a] = self._mk_event('visit', typ)
        for a in d9.GUARDS:
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
            raise d9.OracleError('handler entered with ECX != 0x61d779')
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

    def _at_register(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT_REGISTER'], self.rs16(OBJ + 0x1C), 0))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0x1C)
        self.events.append(('fx', FX['SLOT_SURFACE'], slot, self.entry_surface(slot)))

    def _release_slot(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('fx', FX['RELEASE_SLOT'], struct.unpack('<H', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

    def _grid_reset(self, uc, address, size, user):
        self.events.append(('fx', FX['GRID_RESET'], 0, 0))

    def _grid_setup(self, uc, address, size, user):
        self.events.append(('fx', FX['GRID_SETUP'], 1 if self.rs16(GRID_FLAG) == 0 else 0, 0))

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
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
            if a[0] != OBJ + 0x20:
                raise d9.OracleError('releaser called for %#x' % a[0])
            old = u32(uc, a[0])
            self.events.append(('fx', FX['RELEASE_SURFACE'], old, 0))
            self.wr(a[0], bytes(4))
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['SOUND_BUSY'], a[0] & 0xFFFF, eax))
        elif address == CLEAR_ITEM:
            self.events.append(('fx', FX['CLEAR_ITEM'], 0, 0))
        elif address in (BLIT_OPAQUE, BLIT_RESTORE):
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            if a[4] not in BLIT_LABELS:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            kind, text = BLIT_LABELS[a[4]]
            if (kind == 5) != (address == BLIT_RESTORE):
                raise d9.OracleError('blit routine %#x used with the label %#x' % (address, a[4]))
            if kind == 5:
                piece = self.rs16(OBJ + 0x39)
            elif kind == 6:
                piece = self.rs16(a[3] - 0x14 + 0x26)          # the destination is cell + 0x14: the piece standing in that cell
            else:
                piece = 0
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=text, label_ptr=a[4],
                                   kind=kind, piece=piece, src_ptr=a[2], dst_ptr=a[3]))
            self.events.append(('fx', FX['BLIT'], kind, piece))
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
            return                              # the whole window is compared
        off = address - OBJ
        if 0 <= off < OBJ_LEN:
            if off == 0x3F and size == 4 and value == 1:
                self.events.append(('fx', FX['ACTIVE'], 1, 0))
            elif off == 0x24 and size == 4 and self.cur_phase != 0:
                self.events.append(('fx', FX['STATE'], value, 0))
            elif off == 0x1C and size == 2 and self.cur_phase == 0:
                self.events.append(('fx', FX['SLOT'], value, 0))
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
        return self.rd(CELL_START, 4) + self.rd(GRID_FLAG, 2) + self.rd(GRID, GRID_LEN)

    def put_world(self, blob):
        self.wr(CELL_START, blob[:4])
        self.wr(GRID_FLAG, blob[4:6])
        self.wr(GRID, blob[6:])

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
SOURCES = ('action_family_d3_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_ORIGIN, F_PREPARE, F_STOP, F_PLAY, F_BUSY,
 F_TRANSITION, F_FLAG, F_CLEAR) = [1 << k for k in range(15)]
QKINDS = ('tick', 'busy', 'handle')
MAX_BLITS = 192


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_d3_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('D3_SANITIZE'):
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
        lib.d3o_new.restype = P
        for name, args, res in (
                ('d3o_free', [P], None), ('d3o_reset', [P], None), ('d3o_clear_logs', [P], None), ('d3o_set_fail', [P, C.c_int], None),
                ('d3o_set_origin', [P, I32, I32], None), ('d3o_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('d3o_q_pos', [P, C.c_int], C.c_int), ('d3o_q_underflow', [P, C.c_int], C.c_int),
                ('d3o_obj_get', [P, C.c_char_p], None), ('d3o_obj_set', [P, C.c_char_p], None),
                ('d3o_world_get', [P, C.c_char_p], None), ('d3o_world_set', [P, C.c_char_p], None),
                ('d3o_cells_get', [P, I32P], None), ('d3o_cells_set', [P, I32P], None),
                ('d3o_events_get', [P, C.c_char_p], None), ('d3o_events_set', [P, C.c_char_p], None),
                ('d3o_entries_get', [P, C.c_char_p], None), ('d3o_entries_set', [P, C.c_char_p], None),
                ('d3o_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('d3o_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('d3o_str', [P, C.c_int], C.c_char_p),
                ('d3o_nstr', [P], C.c_int), ('d3o_errors', [P, I32P], None),
                ('d3o_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('d3o_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('d3o_click', [P, C.c_char_p, C.c_int, U32, I32, I32P], None),
                ('d3o_invalidate', [P], C.c_int), ('d3o_cleanup', [P], C.c_int), ('d3o_grid_reset', [P], None),
                ('d3o_validate', [C.c_char_p, C.c_int], C.c_int), ('d3o_render', [P, C.c_char_p, C.c_int, I32P], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.d3o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.d3o_free(self.h)

    def reset(self):
        self.lib.d3o_reset(self.h)

    def clear_logs(self):
        self.lib.d3o_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.d3o_set_fail(self.h, m)

    def set_origin(self, x, y):
        self.lib.d3o_set_origin(self.h, x, y)

    def set_queues(self, qs):
        for i, k in enumerate(QKINDS):
            vals = list(qs.get(k, []))[:256]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.d3o_q_set(self.h, i, arr, len(vals))

    def qpos(self, k):
        return self.lib.d3o_q_pos(self.h, QKINDS.index(k))

    def qunder(self, k):
        return self.lib.d3o_q_underflow(self.h, QKINDS.index(k))

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.d3o_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.d3o_obj_set(self.h, bytes(img))

    def world(self):
        buf = C.create_string_buffer(WORLD_LEN)
        self.lib.d3o_world_get(self.h, buf)
        return bytes(buf.raw)[:WORLD_LEN]

    def set_world(self, data):
        self.lib.d3o_world_set(self.h, bytes(data))

    def start_flag(self):
        return struct.unpack('<i', self.world()[:4])[0]

    def set_start(self, v):
        w = bytearray(self.world())
        w[:4] = struct.pack('<i', sgn(v, 4))
        self.set_world(bytes(w))

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.d3o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.d3o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.d3o_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.d3o_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.d3o_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.d3o_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.d3o_entry_set_u32(self.h, slot, off, v & M32)

    def log(self, which):
        arr = (C.c_int32 * (3 * 4096))()
        n = self.lib.d3o_log(self.h, which, arr, 4096)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def names(self):
        n = min(self.lib.d3o_nstr(self.h), 8)
        return [self.lib.d3o_str(self.h, i) for i in range(n)]

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.d3o_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.d3o_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 6)()
        self.lib.d3o_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, body, row_phase, candidate):
        out = (C.c_int32 * 5)()
        self.lib.d3o_click(self.h, bytes(body), len(body), row_phase & M32, sgn(candidate, 4), out)
        return tuple(out)

    def invalidate(self):
        return self.lib.d3o_invalidate(self.h)

    def cleanup(self):
        return self.lib.d3o_cleanup(self.h)

    def grid_reset(self):
        self.lib.d3o_grid_reset(self.h)

    def validate(self, body):
        return self.lib.d3o_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * (3 + 11 * MAX_BLITS))()
        self.lib.d3o_render(self.h, bytes(body), len(body), out)
        blits = []
        for i in range(out[2] if 0 <= out[2] <= MAX_BLITS else 0):
            o = out[3 + 11 * i:14 + 11 * i]
            blits.append(dict(kind=o[0], piece=o[1], src_surface=o[2] & M32, src=tuple(o[3:7]), dst=tuple(o[7:11])))
        return dict(status=out[0], valid=out[1], count=out[2], blits=blits)


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
B_PERSIST, B_ROWS, B_COLS, B_PIECES, B_TYPES, B_START, B_PIECE_SRC, B_TARGET_SRC = 0x21, 0x22, 0x24, 0x26, 0x28, 0xA8, 0xD0, 0x170
B_ARROW_H, B_ARROW_V, B_WALL, B_OX, B_OY, B_GAP, B_STEPS = 0x210, 0x220, 0x230, 0x240, 0x244, 0x248, 0x24A
B_SND = (0x24F, 0x280, 0x2B1, 0x2FD)
B_CH = (0x270, 0x2A1, 0x2D2, 0x31E)
B_SOLVED, B_DELAY, B_CANCEL, B_CANCEL_RECT = 0x2E2, 0x2FB, 0x32E, 0x347
NAME_REAL = b'HAL_DoorSlider_OVL'
DIRS = {0x10: (0, -1), 0x11: (-1, 0), 0x12: (1, 0), 0x13: (0, 1)}
OPPOSITE = {0x10: 0x13, 0x11: 0x12, 0x12: 0x11, 0x13: 0x10}

_REAL = []


def real_bodies():
    """The three real 0xd3 row bodies of resources 2190 (two rows) and 2194 (one row), read from the local evidence; [] when absent."""
    if not _REAL:
        out = []
        for res in ('2190.bin', '2194.bin'):
            try:
                data = (RESOURCES / res).read_bytes()
            except OSError:
                continue
            at = 0
            while True:
                at = data.find(NAME_REAL, at)
                if at < 0:
                    break
                if at + BODY_LEN <= len(data) and data[at + len(NAME_REAL)] == 0:
                    out.append(data[at:at + BODY_LEN])
                at += 1
        _REAL.append(out)
    return _REAL[0]


def snd(kind):
    return {'none': NO_SOUND, 'real': b'Slide12\0\0\0', 'real2': b'clunk_7\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0'}[kind]


def put_snd(b, off, kind):
    """A sound record: the name, a terminator inside the 0x21 bytes (the native validator needs one; the original compares 9 bytes)."""
    data = snd(kind)
    b[off:off + len(data)] = data
    if 0 not in b[off:off + 0x21]:
        b[off + 0x20] = 0


SND_KINDS = ('none', 'real', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4')


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start)


def rand_block(rng, scene):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)))


def rrect(rng, w=None, h=None):
    x, y = rng.randint(-50, 600), rng.randint(-50, 400)
    return (x, y, x + (rng.randint(5, 90) if w is None else w), y + (rng.randint(5, 90) if h is None else h))


def make_body(rng, name=NAME_REAL, persist=0, R=4, C=4, P=2, types=None, starts=None, cell=(40, 30), gap=2, origin=(100, 80), steps=4,
              snd_kinds=('none', 'none', 'none', 'none'), ch=(1, 2, 3, 4), solved=None, solved_flag=(-1, 0), cancel=None, cancel_flag=(-1, 0),
              delay=1, cancel_rect=(0, 0, 30, 20), arrow_h=(10, 8), arrow_v=(8, 10), wall=(28, 28), zero_targets=(), garbage=True,
              base=None):
    b = bytearray(base if base is not None else (bytes(rng.getrandbits(8) for _ in range(BODY_LEN)) if garbage else bytes(BODY_LEN)))
    name = bytes(name[:0x20])
    b[0:0x21] = name.ljust(0x21, b'\0')
    if garbage and base is None:
        for k in range(len(name) + 1, 0x21):
            b[k] = rng.getrandbits(8)
    b[B_PERSIST] = persist & 0xFF
    struct.pack_into('<3h', b, B_ROWS, R, C, P)
    for a in range(8):
        for c in range(8):
            if types is not None and a < len(types) and c < len(types[a]) and a < R and c < C:
                v = types[a][c]
            else:
                v = rng.choice((0, 0x14, 7, 0x11, -3, 0x7FFF)) if garbage and (a >= R or c >= C) and types is not None else 0
            struct.pack_into('<h', b, B_TYPES + 16 * a + 2 * c, sgn(v, 2))
    for k in range(10):
        if starts is not None and k < len(starts) and k < P:
            col, row = starts[k]
        else:
            col, row = rng.randint(-3, 9), rng.randint(-3, 9)
        struct.pack_into('<2h', b, B_START + 4 * k, col, row)
    sx, sy = rng.randint(-40, 500), rng.randint(-40, 300)
    struct.pack_into('<4i', b, B_PIECE_SRC, sx, sy, sgn(sx + cell[0], 4), sgn(sy + cell[1], 4))
    for k in range(1, 10):
        struct.pack_into('<4i', b, B_PIECE_SRC + 16 * k, *rrect(rng))
    for t in range(10):
        r = rrect(rng)
        if t in zero_targets:
            r = (r[0], r[1], r[0], r[3])
        struct.pack_into('<4i', b, B_TARGET_SRC + 16 * t, *r)
    struct.pack_into('<4i', b, B_ARROW_H, *rrect(rng, *arrow_h))
    struct.pack_into('<4i', b, B_ARROW_V, *rrect(rng, *arrow_v))
    wr = rrect(rng, *wall)
    struct.pack_into('<4i', b, B_WALL, *wr)
    struct.pack_into('<2i', b, B_OX, sgn(origin[0], 4), sgn(origin[1], 4))
    struct.pack_into('<2h', b, B_GAP, sgn(gap, 2), sgn(steps, 2))
    for k in range(4):
        put_snd(b, B_SND[k], snd_kinds[k])
        struct.pack_into('<h', b, B_CH[k], sgn(ch[k], 2))

    def put(off, blk, flag, start):
        struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, off + 20, sgn(blk['start'] if start is None else start, 2))
        struct.pack_into('<h', b, off + 22, sgn(flag[0], 2))
        b[off + 24] = flag[1] & 0xFF
    put(B_SOLVED, solved if solved is not None else block(9999), solved_flag, None)
    struct.pack_into('<h', b, B_DELAY, sgn(delay, 2))
    put(B_CANCEL, cancel if cancel is not None else block(9999), cancel_flag, None)
    struct.pack_into('<4i', b, B_CANCEL_RECT, *[sgn(v, 4) for v in cancel_rect])
    assert len(b) == BODY_LEN
    return bytes(b)


def patch(body, off, data):
    b = bytearray(body)
    b[off:off + len(data)] = data
    return bytes(b)


def body_info(body):
    R, C, P = struct.unpack_from('<3h', body, B_ROWS)
    cw = struct.unpack_from('<i', body, B_PIECE_SRC + 8)[0] - struct.unpack_from('<i', body, B_PIECE_SRC)[0]
    chh = struct.unpack_from('<i', body, B_PIECE_SRC + 12)[0] - struct.unpack_from('<i', body, B_PIECE_SRC + 4)[0]
    return dict(R=R, C=C, P=P, cw=cw, chh=chh, steps=struct.unpack_from('<h', body, B_STEPS)[0],
                cancel=struct.unpack_from('<4i', body, B_CANCEL_RECT), persist=body[B_PERSIST],
                types=[[struct.unpack_from('<h', body, B_TYPES + 16 * a + 2 * c)[0] for c in range(8)] for a in range(8)])


# ---- a model of the sliding rules (used only to FIND solving paths and legal moves; the original decides everything)
def py_can(t, occ, R, C, a, b, d):
    da, db = DIRS[d]
    na, nb = a + da, b + db
    if not (0 <= na < R and 0 <= nb < C):
        return False
    return not (t[a][b] == d or t[na][nb] == OPPOSITE[d] or (na, nb) in occ or t[na][nb] == 0x14)


def py_slide(t, occ, R, C, pos, d):
    a, b = pos
    occ = set(occ)
    occ.discard(pos)
    if not py_can(t, occ, R, C, a, b, d):
        return None
    while py_can(t, occ, R, C, a, b, d):
        a, b = a + DIRS[d][0], b + DIRS[d][1]
    return (a, b)


def py_solved(t, positions):
    return all(t[a][b] == n + 1 for n, (a, b) in enumerate(positions))


def py_solve(t, R, C, positions, depth=8, cap=3000):
    start = tuple(positions)
    if py_solved(t, start):
        return []
    seen = {start: None}
    queue = deque([(start, 0)])
    while queue and len(seen) < cap:
        cur, dep = queue.popleft()
        if dep >= depth:
            continue
        occ = set(cur)
        for n in range(len(cur)):
            for d in DIRS:
                end = py_slide(t, occ, R, C, cur[n], d)
                if end is None:
                    continue
                nxt = cur[:n] + (end,) + cur[n + 1:]
                if nxt in seen:
                    continue
                seen[nxt] = (cur, n, d)
                if py_solved(t, nxt):
                    path = []
                    while seen[nxt] is not None:
                        prev, pn, pd = seen[nxt]
                        path.append((pn, pd))
                        nxt = prev
                    return path[::-1]
                queue.append((nxt, dep + 1))
    return None


def gen_types(rng, R, C, wall_p=0.12, arrow_p=0.08, decoy_p=0.04):
    t = [[0] * 8 for _ in range(8)]
    for a in range(R):
        for c in range(C):
            r = rng.random()
            if r < wall_p:
                t[a][c] = 0x14
            elif r < wall_p + arrow_p:
                t[a][c] = rng.choice((0x10, 0x11, 0x12, 0x13))
            elif r < wall_p + arrow_p + decoy_p:
                t[a][c] = rng.choice((11, 12, 13, 14, 15, 0x15, 0x16))
    return t


def pick_starts(rng, t, R, C, P):
    cells = [(a, c) for a in range(R) for c in range(C) if t[a][c] != 0x14]
    rng.shuffle(cells)
    return cells[:P]


def gen_solvable(rng, R, C, P, moves=None, tries=200, **kw):
    """(types, starts as (col, row), positions as (row, col)) such that a walk of random legal slides ends with every piece on its target."""
    for _ in range(tries):
        t = gen_types(rng, R, C, **kw)
        pos = pick_starts(rng, t, R, C, P)
        if len(pos) < P:
            continue
        start = list(pos)
        cur = list(pos)
        done = 0
        for _m in range(moves or rng.randint(1, 5)):
            options = []
            occ = set(cur)
            for n in range(P):
                for d in DIRS:
                    end = py_slide(t, occ, R, C, cur[n], d)
                    if end is not None:
                        options.append((n, end))
            if not options:
                break
            n, end = rng.choice(options)
            cur[n] = end
            done += 1
        if done == 0 or any(t[a][c] != 0 for a, c in cur):
            continue
        for n, (a, c) in enumerate(cur):
            t[a][c] = n + 1
        if py_solved(t, tuple(start)):
            continue
        return t, [(c, a) for a, c in start], list(start)
    raise ValueError('no solvable board')


def board_from_x(x, body):
    info = body_info(body)
    w = x.rd(GRID, GRID_LEN)
    t = [[cell_fields(w, a, c)['type'] for c in range(8)] for a in range(8)]
    pieces = {}
    for a in range(info['R']):
        for c in range(info['C']):
            p = cell_fields(w, a, c)['piece']
            if p:
                pieces[p] = (a, c)
    return info, t, pieces, w


def clamp16(v):
    return max(-32768, min(32767, v))


def zone_point(rect, info, d, view):
    """A view-relative pointer position inside the zone of direction d of the cell rectangle (left, top, right, bottom)."""
    l, t_, r, b_ = rect
    cx, cy = (l + r) // 2, (t_ + b_) // 2
    px, py = {0x10: (l, cy), 0x11: (cx, t_), 0x12: (cx, b_), 0x13: (r, cy)}[d]
    return clamp16(px - view[0]), clamp16(py - view[1])


def probe_points(rect, info, view, rng=None, extra=0):
    """Pointer positions around one piece cell: the zone boundaries, +-1, the centre and the corners (view-relative)."""
    l, t_, r, b_ = rect
    q = info['cw'] // 4 if info['cw'] >= 0 else -((-info['cw']) // 4)
    hh = int(info['chh'] / 2)
    xs = sorted({l - 1, l, l + 1, l + q - 1, l + q, l + q + 1, (l + r) // 2, r - q - 1, r - q, r - q + 1, r - 1, r, r + 1})
    ys = sorted({t_ - 1, t_, t_ + 1, t_ + hh - 1, t_ + hh, t_ + hh + 1, (t_ + b_) // 2, b_ - hh - 1, b_ - hh, b_ - hh + 1, b_ - 1, b_, b_ + 1})
    pts = [(clamp16(px - view[0]), clamp16(py - view[1])) for py in ys for px in xs]
    if rng is not None:
        pts += [(rng.randint(-40, 700), rng.randint(-40, 500)) for _ in range(extra)]
    return pts


def cancel_points(body, view):
    l, t_, r, b_ = body_info(body)['cancel']
    xs = sorted({l - 1, l, l + 1, (l + r) // 2, r - 1, r, r + 1})
    ys = sorted({t_ - 1, t_, t_ + 1, (t_ + b_) // 2, b_ - 1, b_, b_ + 1})
    return [(clamp16(px), clamp16(py)) for py in ys for px in xs]


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
DEFAULT_Q = dict(tick=[5000] * 8, busy=[0] * 8, handle=[0x1234, 0x1235, 0x1236, 0x1237])
POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
OBJ_RANGE = (OBJ, OBJ + OBJ_LEN)
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
GRID_RANGE = (GRID_FLAG, GRID + GRID_LEN)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, ENTRY_RANGE, GRID_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)] + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE],
    'grid_reset': [GRID_RANGE],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0, known_divergences=Counter(),
                queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(), states=Counter(), outcomes=Counter(),
                slots=Counter(), blit_kinds=Counter(), geometry=Counter(), grid_cells_compared=0)


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def diff_obj(a, b):
    out = []
    for name, off, size in OBJ_FIELDS:
        if a[off:off + size] != b[off:off + size]:
            out.append('%s original %s native %s' % (name, a[off:off + size].hex(), b[off:off + size].hex()))
    if a[:0x1C] != b[:0x1C]:
        out.append('unmodelled object bytes original %s native %s' % (a[:0x1C].hex(), b[:0x1C].hex()))
    return out


def diff_world(a, b):
    out = []
    if a[:4] != b[:4]:
        out.append('start flag original %s native %s' % (a[:4].hex(), b[:4].hex()))
    if a[4:6] != b[4:6]:
        out.append('setup flag word original %s native %s' % (a[4:6].hex(), b[4:6].hex()))
    for k in range(64):
        ca, cb = a[6 + 40 * k:46 + 40 * k], b[6 + 40 * k:46 + 40 * k]
        if ca != cb:
            fa, fb = cell_fields(a[6:], k // 8, k % 8), cell_fields(b[6:], k // 8, k % 8)
            out.append('cell (%d,%d): ' % (k // 8, k % 8) + ', '.join('%s original %d native %d' % (n, fa[n], fb[n]) for n in fa if fa[n] != fb[n]))
            if len(out) > 3:
                break
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

    def d3_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xD3]

    def body_for(self, nat_img):
        """The body the kernel is shown: the row of an active object, else the first 0xd3 row (the original returns early)."""
        row, active = fld(nat_img, 'row'), fld(nat_img, 'active')
        if active and 0 <= row < len(self.rows) and self.rows[row]['type'] == 0xD3:
            return row
        if active:
            raise d9.OracleError('scenario activates the object for a row that is not a 0xd3 row')
        return self.d3_rows()[0]


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(slot=rng.choice((-1, -1, -1, 0x19, 0x30)), row=rng.choice((-1, 0, 1, 3, 5)), surface=rng.choice((0, 0x5151, M32)), state=rng.choice((0, 1, 2, 3, 4, 5, 9, M32)),
             saved0=rng.getrandbits(32), saved1=rng.getrandbits(32), saved2=rng.getrandbits(32), saved3=rng.getrandbits(32),
             piece=rng.choice((0, 1, 5, 11, -1)), moved=rng.choice((0, 1, 2, M32)), active=0, canceled=rng.choice((0, 1, 0x7F)),
             solved=rng.choice((0, 1, 0x80)), deadline=rng.choice((0, 1000, M32, rng.getrandbits(32))), cell_w=rng.choice((0, 40, -3)),
             cell_h=rng.choice((0, 30, 7)), dir=rng.choice((0, 0x10, 0x13, 0x2781, -1)), step=rng.choice((0, 1, 3, 100)),
             at_row=rng.choice((0, 1, 3)), at_col=rng.choice((0, 2, 3)))
    return img, g


def build_events(init, rng):
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & M32)
    for k in range(1000, 1008):
        struct.pack_into('<I', pattern, 4 * k, 0)
    return pattern


CELL_TYPE_POOL = [0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0x10, 0x11, 0x12, 0x13, 0x14, 0x14, 0x15, 0x16, 0x20, -1, -16, 0x7FFF,
                  -0x8000]


def rand_world(rng, pieces=True, types=True, start=None):
    """A grid image of 64 cells with random (valid) contents: setup flag word 0/1, pieces 0..10, any cell type."""
    cells = bytearray(GRID_LEN)
    for a in range(8):
        for c in range(8):
            put_cell(cells, a, c, visible=rng.choice((0, 1, 1, 2, -1)), base0=rng.randint(-300, 700), base1=rng.randint(-300, 700),
                     base2=rng.randint(-300, 700), base3=rng.randint(-300, 700), rect0=rng.randint(-300, 700), rect1=rng.randint(-300, 700),
                     rect2=rng.randint(-300, 700), rect3=rng.randint(-300, 700),
                     type=rng.choice(CELL_TYPE_POOL) if types else 0, piece=rng.choice((0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)) if pieces else 0)
    return struct.pack('<iH', sgn(rng.choice((0, 1, 5)) if start is None else start, 4), rng.choice((0, 1))) + bytes(cells)


def seed_scenario(x, nat, run, rng):
    sc = run.sc
    x.hard_reset()
    nat.reset()
    x.install_rows(run.rows)
    x.w32(CELL_MODE, sc['mode'])
    init = sc['init']
    pattern = build_events(init, rng)
    for idx, v in sc['events'].items():
        struct.pack_into('<i', pattern, 4 * idx, v)
    x.wr(EVENTS_VA, pattern)
    nat.set_events(pattern)
    # the singleton: garbage unless the scenario names the field
    img, g = garbage_obj(rng)
    g.update(init.get('obj', {}))
    for k, v in g.items():
        put_fld(img, k, v)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    # the process cells: the start flag and the grid (power-on zero unless the scenario carries state over)
    start = init.get('start', rng.choice((0, 1, M32, 5)))
    mode_grid = init.get('grid', 'zero')
    if mode_grid == 'zero':
        world = bytearray(WORLD_LEN)
    elif mode_grid == 'garbage':
        world = bytearray(rand_world(rng, start=0))
        struct.pack_into('<H', world, 4, init.get('grid_flag', 0))
    elif isinstance(mode_grid, (bytes, bytearray)):
        world = bytearray(mode_grid)
    else:
        raise d9.OracleError('unknown grid seed')
    struct.pack_into('<i', world, 0, sgn(start, 4))
    if 'grid_flag' in init and mode_grid == 'zero':
        struct.pack_into('<H', world, 4, init['grid_flag'])
    x.put_world(bytes(world))
    nat.set_world(bytes(world))
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    ox, oy = init.get('origin', (0, 0))
    x.set_cell(CELL_ORG_X, ox)
    x.set_cell(CELL_ORG_Y, oy)
    nat.set_origin(sgn(ox, 4), sgn(oy, 4))
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
        raise Mismatch('%s: object image 0x61d779..+0x5f differs: %s' % (where, '; '.join(diff_obj(img_x, img_n))))
    stats['compared_fields'] += len(OBJ_FIELDS) + 1
    wx, wn = x.world_image(), nat.world()
    if wx != wn:
        raise Mismatch('%s: process grid differs (start flag 0x5bb1ca, setup word 0x594db3, 64 cells at 0x594db5): %s' % (
            where, '; '.join(diff_world(wx, wn))))
    stats['compared_fields'] += 3
    stats['grid_cells_compared'] += 64
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
    hosts = [norm_fx(k, a, b) for k, a, b in nh if k not in (HC_MARK_DIRTY, HC_ORIGIN)]
    extra = [(k, a, b) for k, a, b in nh if k in (HC_MARK_DIRTY, HC_ORIGIN)]
    only = [e for e in mapped if e[1] in HOST_FX]
    return mapped, hosts, only, extra


def count_effects(stats, mapped):
    for e in mapped:
        stats['effects'][FXN.get(e[1], e[1])] += 1


def sync_row_images(x, run):
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]


def origin_of(x):
    return sgn(x.cell(CELL_ORG_X), 4), sgn(x.cell(CELL_ORG_Y), 4)


def start_tick(nat, run, queues):
    queues = {**DEFAULT_Q, **queues}
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    return queues


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    sync_row_images(x, run)
    queues = start_tick(nat, run, queues)
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
            elif typ == 0xD3:
                visit_d3(where, x, nat, run, r, i, expected, stats)
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


def classify(stats, phase, pre, mapped, body):
    """Coverage bookkeeping only (never part of a check)."""
    state = fld(pre, 'state')
    kinds = [e[1] for e in mapped]
    if phase == 0:
        stats['handler_visits']['phase0'] += 1
        return
    if phase == 2:
        stats['handler_visits']['phase2_%s' % ('canceled' if fld(pre, 'canceled') else 'solved' if fld(pre, 'solved') else 'plain')] += 1
        return
    if phase != 1:
        stats['handler_visits']['phase_other'] += 1
        return
    stats['handler_visits']['phase1_state_%s' % (state if 0 <= state <= 4 else 'other')] += 1
    if state == 0:
        stats['outcomes']['idle_%s' % ('already_solved' if fld(pre, 'solved') else 'solved_scan_solved' if FX['STATE'] in kinds else 'solved_scan_open')] += 1
    elif state == 2:
        if FX['STATE'] in kinds:
            stats['outcomes']['moving_stop_%s' % ('played' if FX['SOUND_PLAY'] in kinds else 'silent')] += 1
        else:
            stats['outcomes']['moving_step_or_continue'] += 1
    elif state == 4:
        stats['outcomes']['wait_delay_%s' % ('expired_next_sound' if FX['SOUND_PLAY'] in kinds else 'expired_finish' if FX['PHASE'] in kinds else 'waiting')] += 1
    elif state == 3:
        stats['outcomes']['wait_sound_%s' % ('done' if FX['PHASE'] in kinds else 'busy')] += 1
    elif state == 1:
        stats['outcomes']['solved_start_delay'] += 1


def visit_d3(where, x, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, extra = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native cpz_step status %d for row %d phase %d (a native refusal the scenario must avoid)' % (
            where, status, i, phase))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    origin = origin_of(x)
    reads = 1 if (phase == 0 or (phase == 1 and fld(pre, 'state') == 2)) else 0
    check(stats, where, 'view origin host reads (phase 0 and every moving step, nothing else)', extra, [(HC_ORIGIN, origin[0], origin[1])] * reads)
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
    if phase == 0:
        stats['slots'][fld(nat.obj(), 'slot')] += 1
        info = body_info(body)
        stats['geometry']['steps_%d' % info['steps']] += 1
        stats['geometry']['cell_w_odd' if info['cw'] % 2 else 'cell_w_even'] += 1
        stats['geometry']['cell_h_odd' if info['chh'] % 2 else 'cell_h_even'] += 1
        stats['geometry']['persist_%s' % ('zero' if info['persist'] == 0 else 'nonzero')] += 1
        stats['geometry']['gap_negative' if struct.unpack_from('<h', body, B_GAP)[0] < 0 else 'gap_nonneg'] += 1
        stats['geometry']['origin_negative' if min(struct.unpack_from('<2i', body, B_OX)) < 0 else 'origin_nonneg'] += 1
        stats['geometry']['pieces_%d' % info['P']] += 1
    if completed:
        check(stats, where, 'native completion phase', phase_after, 0)
        r['phase'] = 0
    else:
        r['phase'] = phase_after


def do_pointer(where, x, nat, run, stats, rng, px, py, light=False):
    img = nat.obj()
    ri = run.body_for(img)
    body = run.rows[ri]['body']
    sync_row_images(x, run)
    stats['actions']['pointer'] += 1
    xdw = (px & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= px <= 0xFFFF else px & M32
    ydw = (py & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= py <= 0xFFFF else py & M32
    nat.clear_logs()
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, written, kind, sub = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native cpz_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax, 1 if hit else 0)
    active = fld(img, 'active') != 0
    after = nat.obj()
    state = fld(img, 'state')
    stats['pointer']['hit' if hit else 'inactive' if not active else 'moving_ignored' if state == 2 else 'miss'] += 1
    if hit:
        stats['pointer']['cursor_%#x' % kind] += 1
    if written:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32
        run.cells['c1639'] = 1
        check(stats, where, 'pointer: candidate is 0x277f..0x2783', cand in (0x277F, 0x2780, 0x2781, 0x2782, 0x2783), True)
    elif hit:
        raise Mismatch('%s: native claims without writing the cursor cells' % where)
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)
    return hit


def do_click(where, x, nat, run, stats, queues):
    img = nat.obj()
    ri = run.body_for(img)
    r = run.rows[ri]
    row = fld(img, 'row')
    row_phase = run.rows[row]['phase'] if 0 <= row < len(run.rows) else 0
    queues = start_tick(nat, run, queues)
    sync_row_images(x, run)
    stats['actions']['click'] += 1
    cand = sgn(x.cell(CELL_CAND), 4)
    start_flag = sgn(x.cell(CELL_START), 4)
    check(stats, where, 'click: start flag cell equals the native world', start_flag, nat.start_flag())
    x.run_method(queues, M_CLICK, [])
    status, cancel, moved, sound, new_phase = nat.click(r['body'], row_phase, cand)
    if status != OK:
        raise Mismatch('%s: native cpz_click status %d' % (where, status))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'click: no stray host calls', extra, [])
    check(stats, where, 'click: ordered effects (phase, state, sound)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    orig = norm_events(x.events)
    check(stats, where, 'click: cancel flag equals the original storing phase 2', int(any(e[:2] == ('fx', FX['PHASE']) for e in orig)), int(cancel))
    check(stats, where, 'click: move_started flag equals the original storing state 2', int(any(e[:2] == ('fx', FX['STATE']) for e in orig)), int(moved))
    check(stats, where, 'click: sound_played flag equals the original issuing the play',
          int(any(e[:2] == ('fx', FX['SOUND_PLAY']) for e in orig)), int(sound))
    stats['clicks']['cancel' if cancel else 'move' if moved else 'guarded'] += 1
    if sound:
        stats['clicks']['sound'] += 1
    if 0 <= row < len(run.rows):
        run.rows[row]['phase'] = new_phase & M32
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def render_refused(img, x):
    """The render states the kernel refuses (known divergences K4, K7): they are skipped, never run against the original."""
    slot = fld(img, 'slot')
    if slot == -1:
        return 'render: slot -1'
    if not 0 <= slot < NENT:
        return 'render: slot outside the entry table'
    return False


def do_render(where, x, nat, run, stats, ox, oy):
    img = nat.obj()
    row = fld(img, 'row')
    if not 0 <= row < len(run.rows) or run.rows[row]['type'] != 0xD3:
        stats['skipped_native_refusal']['render: stale row of the object (no 0xd3 row installed)'] += 1
        return
    body = run.rows[row]['body']
    why = render_refused(img, x)
    if why:
        stats['skipped_native_refusal'][why] += 1
        return
    info = body_info(body)
    w = x.rd(GRID, GRID_LEN)
    for a in range(info['R']):
        for c in range(info['C']):
            if not 0 <= cell_fields(w, a, c)['piece'] <= 10:
                stats['skipped_native_refusal']['render: piece number outside 1..10 (K4)'] += 1
                return
    stats['actions']['render'] += 1
    slot = fld(img, 'slot')
    # the entry surface of the slot is what the original blits from; phase 0 stores the object's surface there: keep them equal
    surface = fld(img, 'surface') & M32
    x.w32(ENTRY + slot * STRIDE + 8, surface)
    nat.entry_set(slot, 8, surface)
    x.set_cell(CELL_ORG_X, ox)
    x.set_cell(CELL_ORG_Y, oy)
    nat.set_origin(sgn(ox, 4), sgn(oy, 4))
    sync_row_images(x, run)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    bg_cell = x.cell(CELL_BG)
    x.run_method({}, M_RENDER, [], 0)
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native cpz_render status %d' % (where, plan['status']))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'render: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'render: ordered effects (blits)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    check(stats, where, 'render: valid', plan['valid'], 1)
    check(stats, where, 'render: blit count', len(x.blits), plan['count'])
    check(stats, where, 'render: view origin read once', [e for e in extra if e[0] == HC_ORIGIN], [(HC_ORIGIN, sgn(ox, 4), sgn(oy, 4))])
    for k, (b, n) in enumerate(zip(x.blits, plan['blits'])):
        check(stats, where, 'render blit %d: kind (label)' % k, b['kind'], n['kind'])
        check(stats, where, 'render blit %d: piece number' % k, b['piece'], n['piece'])
        check(stats, where, 'render blit %d: this pointer' % k, b['this'], THIS_SURF)
        check(stats, where, 'render blit %d: target surface' % k, b['target'], TARGET_HANDLE)
        if b['kind'] != 5:
            check(stats, where, 'render blit %d: source surface versus native' % k, b['src_surface'], n['src_surface'])
            check(stats, where, 'render blit %d: source surface is the entry surface' % k, b['src_surface'], surface)
        else:
            check(stats, where, 'render blit %d: source surface is the background entry 1' % k, b['src_surface'], bg_cell)
            check(stats, where, 'render blit %d: native background marker' % k, n['src_surface'], 0)
        check(stats, where, 'render blit %d: source rectangle contents' % k, b['src'], n['src'])
        check(stats, where, 'render blit %d: destination rectangle contents' % k, b['dst'], n['dst'])
        stats['blits'] += 1
        stats['blit_kinds'][b['kind']] += 1
    stats['renders']['blits_%d' % min(plan['count'], 20)] += 1
    # the engine clears the redraw request after drawing: make it observable for the invalidate action
    x.w32(ENTRY + slot * STRIDE + 0x14, 0)
    nat.entry_set(slot, 0x14, 0)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
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
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method({}, M_INVALIDATE, [])
    if nat.invalidate() != OK:
        raise Mismatch('%s: native cpz_invalidate failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'invalidate: host calls', extra, [(HC_MARK_DIRTY, slot, 0)] if marks else [])
    check(stats, where, 'invalidate: no effects', (norm_events(x.events), mapped, hosts), ([], [], []))
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats, queues):
    img = nat.obj()
    slot = fld(img, 'slot')
    if slot != -1 and not 0 <= slot < NENT:
        stats['skipped_native_refusal']['cleanup: slot outside the entry table'] += 1
        return
    stats['actions']['cleanup'] += 1
    queues = start_tick(nat, run, queues)
    sync_row_images(x, run)
    x.run_method(queues, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native cpz_cleanup failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surface, release slot)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    check_queues(where, x, nat, stats)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_grid_reset(where, x, nat, run, stats):
    stats['actions']['grid_reset'] += 1
    sync_row_images(x, run)
    nat.clear_logs()
    x.run_method({}, M_GRID_RESET, [])
    nat.grid_reset()
    check(stats, where, 'grid reset: effects', norm_events(x.events), [('fx', FX['GRID_RESET'], 0, 0)])
    check_writes(where, x, 'grid_reset', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.obj_image())
    world = None
    for k, v in d.items():
        if k in OBJ_POS:
            put_fld(img, k, v)
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
            if va >= ENTRY:
                nat.entry_set((va - ENTRY) // STRIDE, (va - ENTRY) % STRIDE, v)
        elif k == 'start':
            x.set_cell(CELL_START, v)
            nat.set_start(v)
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
        elif k == 'origin':
            x.set_cell(CELL_ORG_X, v[0])
            x.set_cell(CELL_ORG_Y, v[1])
            nat.set_origin(sgn(v[0], 4), sgn(v[1], 4))
        elif k == 'grid_flag':
            world = world if world is not None else bytearray(x.world_image())
            struct.pack_into('<H', world, 4, v)
        elif k == 'cells':            # {(a, b): {field: value}}
            world = world if world is not None else bytearray(x.world_image())
            cells = bytearray(world[6:])
            for (a, c), fields in v.items():
                put_cell(cells, a, c, **fields)
            world[6:] = cells
        elif k == 'world':
            world = bytearray(v)
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


def do_action(x, nat, run, stats, rng, sc, ai, act, depth=0):
    kind = act[0]
    where = '%s action %d%s %s' % (sc['id'], ai, '.%d' % depth if depth else '', kind)
    run.trace.append('%s%s' % (kind, '' if len(act) < 2 else ' ' + repr(act[1:])[:90]))
    result = None
    if kind == 'tick':
        do_tick(where, x, nat, run, stats, act[1] if len(act) > 1 else {}, rng)
    elif kind == 'pointer':
        result = do_pointer(where, x, nat, run, stats, rng, act[1], act[2])
    elif kind == 'probes':
        pts = act[1]
        for k, (px, py) in enumerate(pts):
            do_pointer(where, x, nat, run, stats, rng, px, py, light=(k % 16 != 15 and k != len(pts) - 1))
    elif kind == 'click':
        do_click(where, x, nat, run, stats, act[1] if len(act) > 1 else {})
    elif kind == 'render':
        do_render(where, x, nat, run, stats, act[1], act[2])
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats, act[1] if len(act) > 1 else {})
    elif kind == 'grid_reset':
        do_grid_reset(where, x, nat, run, stats)
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
    elif kind == 'rearm':
        for i, r in enumerate(run.rows):
            if r['type'] in ARM:
                r['completed'] = 0
                r['phase'] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
    elif kind == 'move':
        macro_move(where, x, nat, run, stats, rng, act[1], act[2], act[3] if len(act) > 3 else {}, sc, ai)
    elif kind == 'finish':
        macro_finish(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else 12, sc, ai)
    elif kind == 'cancel':
        macro_cancel(where, x, nat, run, stats, rng, act[1] if len(act) > 1 else {}, sc, ai)
    elif kind == 'bot':
        bot(x, nat, run, stats, rng, sc, ai, act[1], act[2])
    else:
        raise d9.OracleError('unknown action ' + kind)
    stats['actions'][kind] += 1
    return result


# ---------------------------------------------------------------------------------------------
# macros and the random player (they read the live object, so they steer by deadlines and states)
# ---------------------------------------------------------------------------------------------
def ensure_mode(x, nat, run):
    if nat.cells()[0] != 3:
        do_set(x, nat, run, {'mode': 3})


def cur_row(nat, run):
    img = nat.obj()
    row = fld(img, 'row')
    if fld(img, 'active') and 0 <= row < len(run.rows):
        return row
    return run.d3_rows()[0]


def advance(run, rng):
    run.clock = (run.clock + rng.choice((1, 10, 100, 499, 500, 501, 1000, 5000))) & M32
    return run.clock


def macro_move(where, x, nat, run, stats, rng, piece, d, opts, sc, ai):
    """Pointer onto the zone of direction d of the piece's cell, click, then ticks (and renders) until the piece rests."""
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    ri = cur_row(nat, run)
    body = run.rows[ri]['body']
    info, t, pieces, w = board_from_x(x, body)
    if piece not in pieces:
        stats['outcomes']['move_piece_absent'] += 1
        return
    a, c = pieces[piece]
    cf = cell_fields(w, a, c)
    view = origin_of(x)
    px, py = zone_point((cf['rect0'], cf['rect1'], cf['rect2'], cf['rect3']), info, d, view)
    if not sub(1, ('pointer', px, py)):
        stats['outcomes']['move_zone_miss'] += 1
        return
    sub(2, ('click', dict(tick=[opts.get('tick', advance(run, rng))] * 3)))
    for k in range(400):
        if fld(nat.obj(), 'state') != 2:
            break
        if rng.random() < opts.get('render', 0.5):
            sub(3, ('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))))
        if rng.random() < 0.3:
            sub(4, ('pointer', rng.randint(-20, 600), rng.randint(-20, 400)))
        if rng.random() < 0.1:
            sub(5, ('click', {}))
        if rng.random() < 0.1:
            sub(5, ('invalidate',))
        sub(6, ('tick', {}))
    else:
        raise d9.OracleError('%s: a move never ended' % where)
    stats['outcomes']['move_done'] += 1
    if rng.random() < 0.8:
        sub(7, ('render', 0, 0))
    sub(8, ('tick', {}))                      # the idle tick scans for the solved state


def macro_finish(where, x, nat, run, stats, rng, max_steps, sc, ai):
    """Ticks through the solved path: start the delay, wait for the deadline, play the final sound, wait for it, finish (phase 2)."""
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    for k in range(max_steps):
        img = nat.obj()
        row = fld(img, 'row')
        if not fld(img, 'active') or not 0 <= row < len(run.rows):
            break
        phase = run.rows[row]['phase']
        state = fld(img, 'state')
        ensure_mode(x, nat, run)
        if phase == 2:
            sub(k, ('tick', {}))
            continue
        if phase != 1:
            break
        if state == 1:
            t = advance(run, rng)
            sub(k, ('tick', dict(tick=[t] * 3)))
        elif state == 4:
            dl = fld(img, 'deadline') & M32
            t = rng.choice(((dl - 1) & M32, dl, (dl + 1) & M32, (dl + 5000) & M32, (dl - 5000) & M32))
            sub(k, ('tick', dict(tick=[t] * 3, busy=[rng.choice((0, 1))] * 2)))
        elif state == 3:
            sub(k, ('tick', dict(busy=[rng.choice((0, 1, 1, 2, 0))] * 2)))
        else:
            sub(k, ('tick', {}))


def macro_cancel(where, x, nat, run, stats, rng, opts, sc, ai):
    """Pointer onto the cancel rectangle, click, tick (phase 2 finishes and cleans up)."""
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    body = run.rows[cur_row(nat, run)]['body']
    l, t_, r, b_ = body_info(body)['cancel']
    px, py = clamp16((l + r) // 2), clamp16((t_ + b_) // 2)
    if not sub(1, ('pointer', px, py)):
        stats['outcomes']['cancel_miss'] += 1
        return
    sub(2, ('click', dict(tick=[advance(run, rng)] * 2)))
    sub(3, ('tick', dict(tick=[advance(run, rng)] * 2)))
    stats['outcomes']['cancel_done'] += 1


def bot(x, nat, run, stats, rng, sc, ai, steps, profile):
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    dep = [0]

    def S(a):
        dep[0] += 1
        sub(dep[0], a)
    ri = run.d3_rows()[0]
    plan = []
    planned = False
    for step in range(steps):
        img = nat.obj()
        active = fld(img, 'active') != 0
        row = fld(img, 'row')
        ensure_mode(x, nat, run)
        if not active:
            if profile == 'chaos' and rng.random() < 0.3:
                S(('rearm',))
            S(('tick', dict(handle=[rng.choice((0x4441, 0, M32, 1, 0x7FFFFFFF))], tick=[advance(run, rng)] * 3)))
            planned = False
            continue
        ri = row if 0 <= row < len(run.rows) else ri
        phase = run.rows[ri]['phase']
        state = fld(img, 'state')
        body = run.rows[ri]['body']
        if phase == 2:
            S(('tick', {}))
            continue
        if state in (1, 3, 4) or fld(img, 'solved'):
            macro_finish(sub_where(sc, ai, dep), x, nat, run, stats, rng, 14, sc, ai)
            continue
        info, t, pieces, w = board_from_x(x, body)
        positions = tuple(pieces[n] for n in sorted(pieces))
        occ = set(positions)
        if profile == 'win' and not planned:
            plan = py_solve(t, info['R'], info['C'], tuple(pieces[n + 1] for n in range(len(pieces)))) if len(pieces) == len(positions) and sorted(pieces) == list(range(1, len(pieces) + 1)) else None
            plan = plan or []
            planned = True
        r = rng.random()
        if profile == 'win' and plan:
            n, d = plan.pop(0)
            S(('move', n + 1, d, {}))
        elif profile == 'chaos' and r < 0.25:
            S(('pointer', rng.randint(-60, 700), rng.randint(-60, 500)))
            if rng.random() < 0.5:
                S(('click', {}))
        elif profile == 'chaos' and r < 0.35:
            S(rng.choice((('invalidate',), ('render', rng.randint(-9, 9), rng.randint(-9, 9)), ('grid_reset',) if rng.random() < 0.0 else ('invalidate',))))
        elif r < 0.12 and profile != 'win':
            S(('cancel', {}))
        else:
            options = []
            for n, pos in pieces.items():
                for d in DIRS:
                    if py_can(t, occ - {pos}, info['R'], info['C'], pos[0], pos[1], d):
                        options.append((n, d))
            if options and rng.random() < 0.9:
                n, d = rng.choice(options)
                S(('move', n, d, {}))
            else:
                S(('tick', {}))


def sub_where(sc, ai, dep):
    return '%s action %d bot' % (sc['id'], ai)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
HANDLES = [0x4441, 0, M32, 1, 0x7FFFFFFF]
NAMES_POOL = [NAME_REAL, b'A', b'x' * 32, b'Collision Surface', b'']
FLAGS = ((-1, 0), (0, 7), (339, 5), (340, 9), (341, 3), (4095, 255), (1010, 300), (2047, 1), (338, 0xAB), (340, 0xFF))
CW = (1, 2, 3, 7, 8, 9, 13, 17, 31, 37, 40, 41, 63, 64)
STEPS = (1, 2, 3, 4, 5, 6, 7, 12)
GAPS = (-9, -5, -3, -2, -1, 0, 1, 2, 3, 7, 15)
ORIGINS = ((0, 0), (-37, -11), (100, 80), (1000, -500), (-1, -1), (255, 255))
SK = ('none', 'real', 'none', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4')
CHS = (0, 1, 2, -3, 0x4001, 32767, -32768)


def R_D3(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xD3, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def pick_block(rng):
    return rng.choice((block(9999, (1, 2, 3), (4, 5, 6), 1), rand_block(rng, 42), rand_block(rng, -5), rand_block(rng, 0x8000 - 0x10000),
                       rand_block(rng, 0x2710), rand_block(rng, 0xA70F - 0x10000), rand_block(rng, 1), rand_block(rng, 0), block(9999)))


def rand_body(rng, R=None, C=None, P=None, solvable=False, odd=False, **over):
    R = R or rng.randint(2, 8)
    C = C or rng.randint(2, 8)
    if solvable:
        P = P or rng.randint(1, 4)
        t, starts, _pos = gen_solvable(rng, R, C, P)
    else:
        P = P or rng.randint(1, min(10, max(1, R * C // 2)))
        t = gen_types(rng, R, C)
        pos = pick_starts(rng, t, R, C, P)
        P = len(pos)
        starts = [(c, a) for a, c in pos]
        for n in range(1, P + 1):
            if rng.random() < 0.6:
                a, c = rng.randrange(R), rng.randrange(C)
                if t[a][c] == 0:
                    t[a][c] = n
    cw = rng.choice(CW) if not odd else rng.choice((7, 9, 13, 17, 31, 37, 41, 63))
    ch = rng.choice(CW) if not odd else rng.choice((7, 9, 13, 17, 31, 37, 41, 63))
    kw = dict(R=R, C=C, P=P, types=t, starts=starts, cell=(cw, ch), gap=rng.choice(GAPS), origin=rng.choice(ORIGINS), steps=rng.choice(STEPS),
              snd_kinds=[rng.choice(SK) for _ in range(4)], ch=[rng.choice(CHS) for _ in range(4)], solved=pick_block(rng),
              solved_flag=rng.choice(FLAGS), cancel=pick_block(rng), cancel_flag=rng.choice(FLAGS), delay=rng.choice((0, 1, 2, -2, 32767, 7)),
              cancel_rect=(rng.randint(-10, 20), rng.randint(-10, 20), rng.randint(20, 80), rng.randint(20, 60)),
              arrow_h=(rng.choice((4, 9, 10, 15, 31)), rng.choice((4, 7, 8, 13, 41))), arrow_v=(rng.choice((4, 7, 8, 13, 41)), rng.choice((4, 9, 10, 15, 31))),
              wall=(rng.choice((0, 28, 31)), rng.choice((28, 31))), zero_targets=tuple(rng.sample(range(10), rng.randint(0, 3))))
    kw.update(over)
    return make_body(rng, **kw)


def scenario_list(seed=0xD353):
    rng = random.Random(seed)
    scs = []
    reals = real_bodies()

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        return rand_body(rng, **kw)

    # ---- phase 0: names, sounds, handles, busy seeds, surfaces, grid seeds, persist ------------------------------------------------
    seeds_variants = [[], [0x18], [0x18, 0x19, 0x1A], [0x18, 0x1A, 0x1B, 0x3E], list(range(0x18, 0x3F)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]]
    grids = ['zero', 'zero', 'garbage', 'garbage1']
    for k in range(48):
        name = NAMES_POOL[k % len(NAMES_POOL)]
        busy = seeds_variants[k % len(seeds_variants)]
        gm = grids[k % 4]
        init = dict(busy_slots=busy, obj=dict(surface=rng.choice((0, 0x5151)), slot=rng.choice((-1, 0x19, 0x30))), grid='garbage' if gm.startswith('garbage') else 'zero',
                    grid_flag=1 if gm == 'garbage1' else 0)
        body = mk(name=name, persist=rng.choice((0, 0, 1, 0x80, 0xFF)), snd_kinds=[SND_KINDS[(k + j) % len(SND_KINDS)] for j in range(4)])
        S('init:%d_%s_%s' % (k, 'noname' if not name else 'name', gm), [R_D3(body)],
          [tk(handle=[HANDLES[k % 5]]), tk(), ('render', 0, 0), ('cleanup',), ('rearm',), tk(handle=[HANDLES[(k + 1) % 5]]), tk(), ('render', 3, 4),
           ('grid_reset',), ('cleanup',)], 'init', init=init, quick=k in (0, 5, 11, 22))
    S('init:stale_state_released', [R_D3(mk())], [tk(), ('cleanup',)], 'init',
      init=dict(obj=dict(surface=0x7777, slot=0x30, active=1, row=0, canceled=1, solved=1, state=3)), quick=True)
    S('init:slot_exhaustion_but_last', [R_D3(mk())], [tk(), tk(), ('cleanup',)], 'init', init=dict(busy_slots=list(range(0x18, 0x3F))), quick=True)
    S('init:garbage_survives', [R_D3(mk())], [tk(), tk(), tk()], 'init',
      init=dict(obj=dict(saved0=7, saved3=9, cell_w=5, cell_h=6, deadline=0x1234, at_row=3, at_col=2)), quick=True)
    for k, real in enumerate(reals):
        S('init:real_body_%d' % k, [R_D3(real)], [tk(), ('render', 0, 0), tk(), ('pieceprobes', 3, 8, True), ('render', 3, 4), ('cleanup',)], 'init', quick=True)

    # ---- geometry: cell sizes (odd), gaps (negative), origins (negative), steps 1..6 and larger, views --------------------------------
    for k in range(90):
        odd = k % 2 == 0
        body = mk(odd=odd, steps=STEPS[k % len(STEPS)], gap=GAPS[(k * 3) % len(GAPS)], origin=ORIGINS[k % len(ORIGINS)])
        if k % 9 == 0:
            body = patch(body, B_PIECE_SRC, struct.pack('<4i', 10, 10, 10 + rng.choice((0, -5, -41)), 10 + rng.choice((0, -7, 30))))
        view = rng.choice(ORIGINS)
        S('geom:%d' % k, [R_D3(body)],
          [tk(), ('render', view[0], view[1]), ('pieceprobes', 2, 6, True), ('set', dict(origin=(view[1], view[0]))), ('render', 0, 0),
           ('bot', 12, 'play'), ('cleanup',)], 'geom', init=dict(origin=view), quick=k in (0, 1, 2, 9))
    S('geom:huge_values', [R_D3(mk(origin=(0x7FFFFFF0, -0x7FFFFFF0), gap=32767, cell=(0x3FFFFFFF, 0x7FFFFFFF)))],
      [tk(), ('render', 0x7FFFFFFF, -0x80000000), ('pieceprobes', 3, 3, False), ('cleanup',)], 'geom', init=dict(origin=(0x7FFFFFF0, 0x7FFFFFF0)), quick=True)

    # ---- persist: carried grid versus reset ----------------------------------------------------------------------------------------
    for k in range(30):
        persist = (0, 1, 0x80, 0xFF, 0, 2)[k % 6]
        body = mk(persist=persist, solvable=k % 3 == 0, steps=rng.choice((1, 2, 3)))
        second = patch(body, B_STEPS, struct.pack('<h', rng.choice((1, 4, 6)))) if k % 2 else body
        if k % 5 == 4:
            second = patch(second, B_ROWS, struct.pack('<2h', rng.randint(1, 8), rng.randint(1, 8)))
        S('persist:%d_p%d' % (k, persist), [R_D3(body, subtype=rng.choice((1, 2)))],
          [tk(), ('bot', 10, 'play'), ('cancel', {}), tk(), ('cleanup',), ('rearm',), ('body', 0, {B_STEPS: second[B_STEPS:B_STEPS + 2], B_ROWS: second[B_ROWS:B_ROWS + 4]}),
           tk(), tk(), ('render', 0, 0), ('bot', 8, 'play'), ('cancel', {}), tk(), ('rearm',), tk(), ('render', 1, 1)], 'persist',
          init=dict(grid='garbage' if k % 4 == 3 else 'zero', grid_flag=1 if k % 8 == 3 else 0), quick=k < 3)

    # ---- the handler's states 0..4, above 4, every phase, deadlines, busy answers, sounds -----------------------------------------------
    for state in list(range(0, 6)) + [9, 0x80000000, M32]:
        for sub in (1, 2):
            body = mk(snd_kinds=['real', 'real', 'real', 'real'], delay=2, solved=rand_block(rng, 12), cancel=rand_block(rng, 13), cancel_flag=rng.choice(FLAGS),
                      solved_flag=rng.choice(FLAGS), ch=[2, 0, -3, 7])
            acts = [tk(), ('set', dict(state=state, deadline=5000, solved=rng.choice((0, 1)))), tk(tick=[4999] * 4, busy=[0]),
                    tk(tick=[5000] * 4, busy=[1]), tk(tick=[5001] * 4, busy=[0]), tk(tick=[9000] * 4, busy=[0]), tk(tick=[20000] * 4, busy=[0]),
                    tk(tick=[30000] * 4, busy=[0]), tk(), tk()]
            S('state_forced:%#x_sub%d' % (state, sub), [R_D3(body, subtype=sub)], acts, 'states', quick=(state, sub) in ((0, 1), (3, 1), (4, 2)))
    for case in range(40):                               # the solved scan: partial / full / carried solutions
        solvable = rng.random() < 0.5
        body = mk(solvable=solvable)
        info = body_info(body)
        acts = [tk()]
        if solvable:
            acts += [('bot', 14, 'win')]
        acts += [tk(), tk(tick=[1000, 1000, 2000]), ('set', dict(state=4)), tk(), tk(), tk(), ('finish', 12)]
        S('solved_scan:%d' % case, [R_D3(body, subtype=rng.choice((1, 2)))], acts, 'states', quick=case < 2)
    for case in range(60):                               # states 1, 4, 3: the final delay, the final sound, the busy answers
        delay = rng.choice((0, 1, 3, -2, 32767, -32768, 7))
        t0 = rng.choice((0, 1000, 0xFFFFFC17, 0x7FFFFFFF, M32, 123456))
        dl = (t0 + delay * 1000) & M32
        ts = [(dl - 1) & M32, dl, (dl + 1) & M32, (dl + 0x80000000) & M32, (dl - 0x80000000) & M32, 0, M32]
        fsnd = rng.choice(('none', 'real', 'real2', 'near1', 'none', 'near2', 'zero', 'near3'))
        body = mk(snd_kinds=['none', 'none', 'none', fsnd], ch=[1, 2, 3, rng.choice((2, 0, -3, 32767, 0x4001))], delay=delay, solved=pick_block(rng),
                  solved_flag=rng.choice(FLAGS))
        sub = rng.choice((1, 1, 2, 0, 3))
        acts = [tk(), ('set', dict(state=1, solved=1)), tk(tick=[t0] * 2), tk(tick=[t0] * 2), tk(tick=[ts[0]] * 2), tk(tick=[ts[rng.randrange(1, 4)]] * 2),
                tk(tick=[ts[rng.randrange(4, 7)]] * 2), tk(busy=[1]), tk(busy=[2]), tk(busy=[M32]), tk(busy=[0]), tk(), tk()]
        S('final:%d_snd%s_d%d_sub%d' % (case, fsnd, delay, sub), [R_D3(body, subtype=sub)], acts, 'states', quick=case < 4)
    for b_ans in (0x100, 0x10000, 2, M32, 1, 0x80000000, 0xFF, 0):
        body = mk(snd_kinds=['none', 'none', 'none', 'real'], ch=[1, 2, 3, rng.choice((2, 0, -3))], solved=rand_block(rng, 12), solved_flag=rng.choice(FLAGS))
        S('state3_busy:%#x' % b_ans, [R_D3(body)], [tk(), ('set', dict(state=3, solved=1)), tk(busy=[b_ans]), tk(busy=[b_ans]), tk(busy=[0]), tk()], 'states',
          quick=b_ans == 0x100)
    for ph in (3, 4, 9, M32):
        S('phase_other:%#x' % ph, [R_D3(mk(), phase=ph)], [tk(), tk()], 'phase_other', quick=ph == 3)
    for case in range(48):                               # phase 2: canceled / solved / neither, the sounds stopped, the blocks
        sub = rng.choice((1, 2, 1, 0, 3))
        body = mk(snd_kinds=[rng.choice(SK), rng.choice(SK), rng.choice(SK), 'none'], solved=pick_block(rng), cancel=pick_block(rng),
                  solved_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS))
        flags = [dict(canceled=1, solved=0), dict(canceled=0, solved=1), dict(canceled=0, solved=0), dict(canceled=1, solved=1), dict(canceled=5, solved=3)][case % 5]
        S('phase2:%d_sub%d' % (case, sub), [R_D3(body, subtype=sub)],
          [tk(), ('set', flags), ('setphase', 0, 2), tk(), ('rearm',), tk(), ('set', flags), ('setphase', 0, 2), tk(mode=0) if False else tk()], 'finish',
          quick=case < 5)

    # ---- guided moves, win and cancel -------------------------------------------------------------------------------------------------
    for case in range(70):
        body = mk(odd=case % 2 == 0, steps=STEPS[case % len(STEPS)], snd_kinds=[rng.choice(SK) for _ in range(4)])
        S('move:%d' % case, [R_D3(body, subtype=rng.choice((1, 1, 2)))], [tk(handle=[HANDLES[case % 5]]), ('bot', 40, rng.choice(('play', 'play', 'chaos')))], 'move',
          init=dict(origin=rng.choice(ORIGINS)), quick=case < 4)
    for case in range(60):
        R, C = rng.randint(3, 8), rng.randint(3, 8)
        solved_flag = rng.choice(FLAGS)
        body = mk(solvable=True, R=R, C=C, odd=case % 2 == 1, steps=STEPS[case % 6], solved=pick_block(rng), solved_flag=solved_flag,
                  snd_kinds=['real' if case % 2 else 'none', rng.choice(SK), rng.choice(SK), rng.choice(('none', 'real', 'real2'))])
        S('win:%d' % case, [R_D3(body, subtype=rng.choice((1, 1, 2)))], [tk(handle=[HANDLES[case % 5]]), ('bot', 50, 'win'), ('finish', 14), tk(), tk(), ('rearm',), tk(),
                                                                          ('bot', 20, 'win'), ('finish', 14)], 'win',
          init=dict(start=rng.choice((1, 1, 0))), quick=case < 4)
    for case in range(24):
        body = mk(cancel=pick_block(rng), cancel_flag=rng.choice(FLAGS), snd_kinds=[rng.choice(SK) for _ in range(4)])
        cl, ct, cr, cb = body_info(body)['cancel']
        acts = [tk(), ('probes', cancel_points(body, (0, 0))), ('cancel', {}), tk(), ('rearm',), tk(), ('set', dict(cand=0x277F)), ('click', {}), tk(), tk()]
        S('cancel:%d' % case, [R_D3(body, subtype=rng.choice((1, 2)))], acts, 'cancel', quick=case < 3)

    # ---- pointer zones ----------------------------------------------------------------------------------------------------------------------
    for case in range(36):
        body = mk(odd=case % 3 == 0, R=rng.randint(2, 6), C=rng.randint(2, 6), P=rng.randint(2, 6), gap=rng.choice((-6, -2, 0, 1, 4)))
        if case % 4 == 0:
            body = patch(body, B_PIECE_SRC, struct.pack('<4i', 0, 0, rng.choice((-12, 1, 2, 3, 5, 8, 33)), rng.choice((-8, 1, 3, 5, 9, 30))))
        acts = [('probes', [(5, 5), (0x7FFF, 0x7FFF), (-0x8000, -0x8000), (0xFFFF, 0xFFFF), (0x10000 + 300, 0x10000 + 180)]), tk(), ('pieceprobes', 4, 6, True),
                ('set', dict(state=2)), ('pieceprobes', 1, 0, False), ('set', dict(state=0, solved=1)), ('pieceprobes', 1, 0, False), ('set', dict(solved=0)),
                ('pieceprobes', 2, 0, False), ('cleanup',), ('pieceprobes', 1, 0, False)]
        S('pointer:%d' % case, [R_D3(body)], acts, 'pointer', init=dict(origin=rng.choice(ORIGINS)), quick=case < 3)

    # ---- the click: candidate x object conditions x start flag x move sound ---------------------------------------------------------------------
    for case in range(24):
        body = mk(snd_kinds=[rng.choice(('real', 'none', 'near1', 'real2')), 'none', 'none', 'none'], ch=[rng.choice((0, 5, -2, 32767)), 1, 2, 3])
        acts = [tk()]
        for cand in (0x277F, 0x2780, 0x2781, 0x2782, 0x2783, 0, 0x1234, -1, 0x277E):
            for cond in (dict(state=0, solved=0, dir=0x10), dict(state=0, solved=0, dir=0), dict(state=1, solved=0, dir=0x11), dict(state=0, solved=1, dir=0x12),
                         dict(state=2, solved=0, dir=0x13), dict(state=3, solved=0, dir=0x2781)):
                acts += [('set', dict(cand=cand, start=rng.choice((0, 1, 5, M32)), canceled=0, **cond)), ('setphase', 0, rng.choice((1, 1, 1, 0, 2))), ('click', {}),
                         ('set', dict(state=0, solved=0, dir=0, canceled=0)), ('setphase', 0, 1)]
        S('click:%d' % case, [R_D3(body)], acts, 'click', quick=case < 2)

    # ---- the render: random grids, every cell type, states, moved flag, saved rectangles -----------------------------------------------------
    for case in range(36):
        body = mk(R=rng.randint(1, 8), C=rng.randint(1, 8), zero_targets=tuple(rng.sample(range(10), rng.randint(0, 5))), wall=(rng.choice((0, 28)), 28))
        acts = [tk()]
        for k in range(6):
            acts += [('set', dict(world=rand_world(rng, start=1), state=rng.choice((0, 1, 2, 3, 4, 2)), moved=rng.choice((0, 1, 2)), piece=rng.randint(0, 10),
                                  saved0=rng.randint(-50, 500), saved1=rng.randint(-50, 500), saved2=rng.randint(-50, 500), saved3=rng.randint(-50, 500))),
                     ('render', rng.randint(-40, 400), rng.randint(-40, 300)), ('invalidate',)]
        S('render:%d' % case, [R_D3(body)], acts, 'render', quick=case < 3)

    # ---- invalidate, cleanup, grid reset ------------------------------------------------------------------------------------------------------
    for case in range(30):
        body = mk()
        acts = [('set', dict(active=rng.choice((0, 1, 5)), slot=rng.choice((-1, 0x1F, 0, 0x57)), surface=rng.choice((0, 0x4242)), row=0, canceled=1, solved=1)),
                ('invalidate',), ('cleanup',), ('invalidate',), ('cleanup',), ('set', dict(world=rand_world(rng, start=3))), ('grid_reset',), ('grid_reset',),
                tk(), ('invalidate',), ('cleanup',)]
        S('invalidate:%d' % case, [R_D3(body)], acts, 'invalidate', init=dict(busy_slots=[0x18, 0x19]), quick=case < 3)
    for surface in (0, 0x4242):
        for slot in (-1, 0x1F, 0):
            S('cleanup:surface%#x_slot%d' % (surface, slot), [R_D3(mk())],
              [('set', dict(surface=surface, slot=slot, active=1, row=0, canceled=1, solved=1)), ('cleanup',), ('cleanup',)], 'invalidate',
              quick=(surface, slot) in ((0x4242, 0x1F), (0, -1)))

    # ---- dependency tails, neighbours, chained rows, passes stopped by the mode -----------------------------------------------------------------
    for case in range(10):
        body = mk(solvable=True, solved=pick_block(rng), cancel=pick_block(rng), solved_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS))
        tail = event_tail(1003, 1)
        acts = [tk(), ('events', {1003: 1}), tk(), ('bot', 20, 'play'), ('cancel', {}), tk(), tk(), tk(tick=[1000] * 3), tk(tick=[9000] * 3), tk(), tk()]
        rows = [R67(), R_D3(body, tail=tail), R67(loaded=3)] if case % 2 else [R_D3(body, tail=tail), R67()]
        S('dep:%d' % case, rows, acts, 'dep', events={1003: 0 if case < 8 else 1}, quick=case in (0, 1))
    for case in range(10):          # a first puzzle's finish opens the second one through the event flag
        b0 = mk(solvable=True, solved=pick_block(rng) if case % 2 else block(9999), cancel=pick_block(rng) if case % 3 else block(9999),
                solved_flag=(1003, 1), cancel_flag=(1003, 1), snd_kinds=['none', 'none', 'none', 'none'])
        b1 = mk(solvable=True)
        S('chain:%d' % case, [R_D3(b0), R_D3(b1, tail=event_tail(1003, 1)), R67()],
          [tk(), ('bot', 40, 'win' if case % 2 else 'play'), ('finish', 14), tk(), tk(), ('set', dict(mode=3)), tk(), tk(), ('set', dict(mode=3)), tk(),
           ('bot', 30, 'win'), ('finish', 14), ('set', dict(mode=3)), tk(), ('render', 0, 0), tk()], 'dep', events={1003: 0}, quick=case == 0)
    for case in range(6):
        body = mk(solvable=True, solved=block(7 + case, (1, 2, 3), (4, 5, 6), case % 2))
        S('mode:%d' % case, [R67(), R_D3(body, subtype=1 + case % 2), R67(), R_D3(mk(), subtype=1, completed=1)],
          [tk(), ('bot', 40, 'win'), ('finish', 14), tk(), tk(), ('set', dict(mode=3)), tk(), tk(tick=[1, 2]), tk()], 'mode', quick=case == 0)

    # ---- the real rows (resources 2190 and 2194) ---------------------------------------------------------------------------------------------------
    for k, real in enumerate(reals):
        for sub in (1, 2):
            S('real:%d_sub%d' % (k, sub), [R_D3(real, subtype=sub)], [tk(), ('bot', 60, 'play'), ('cancel', {}), tk(), ('rearm',), tk(), ('bot', 40, 'chaos'), ('cancel', {})], 'real',
              init=dict(start=1), quick=sub == 1 and k == 0)
    if len(reals) >= 3:
        solved_gate = patch(reals[0], 0x2F8, struct.pack('<h', 1003) + b'\1')
        S('real:two_rows_gated', [R_D3(solved_gate), R_D3(reals[1], tail=event_tail(1003, 1)), R_D3(reals[2], tail=event_tail(1003, 2))],
          [tk(), ('bot', 30, 'play'), ('cancel', {}), tk(), tk(), ('set', dict(mode=3)), tk(), ('bot', 20, 'play'), ('cancel', {})], 'real', events={1003: 0})

    # ---- guided and random play ----------------------------------------------------------------------------------------------------------------------
    for case in range(120):
        body = mk(solvable=case % 3 == 0, snd_kinds=[rng.choice(SK) for _ in range(4)], odd=case % 2 == 0)
        rows = [R_D3(body, subtype=rng.choice((1, 1, 2, 0, 3)))]
        if case % 4 == 0:
            rows = [R67()] + rows + [R67(loaded=3)]
        S('random:%d' % case, rows, [tk(handle=[HANDLES[case % 5]]), ('bot', 60, rng.choice(('play', 'chaos', 'chaos', 'win')))], 'bot',
          init=dict(start=rng.choice((1, 1, 0, 5)), origin=rng.choice(ORIGINS), grid='garbage' if case % 7 == 6 else 'zero'), quick=case < 3)
    # ---- targeted additions (a separate random stream so the groups above keep their boards) ------------------------------------------------
    rng = random.Random(seed ^ 0x5A5A5A)
    # ---- negative and odd rectangles: truncating halves, the quarter, the stale step of a refused check, every non-moving state ----------------------
    for case in range(24):
        body = mk(odd=True, R=rng.randint(2, 5), C=rng.randint(2, 5), P=rng.randint(2, 4), gap=rng.choice((-6, -3, 0, 1, 4)))
        cw = rng.choice((-1, -2, -3, -5, 1, 2, 3, 5, 8, 12, 33))
        chh = rng.choice((-1, -2, -3, -5, 1, 3, 9, 30, 0))
        body = patch(body, B_PIECE_SRC, struct.pack('<4i', 0, 0, cw, chh) if case % 3 else struct.pack('<4i', 4, 6, 4 + cw, 6 + chh))
        body = patch(body, B_ARROW_H, struct.pack('<4i', rng.randint(0, 5), rng.randint(0, 5), rng.choice((-1, -3, -5, -9, 4, 9, 11)) + rng.randint(0, 5),
                                                  rng.choice((-1, -3, -5, -9, 4, 9, 11)) + rng.randint(0, 5)))
        body = patch(body, B_ARROW_V, struct.pack('<4i', rng.randint(0, 5), rng.randint(0, 5), rng.choice((-1, -3, -5, -9, 4, 9, 11)) + rng.randint(0, 5),
                                                  rng.choice((-1, -3, -5, -9, 4, 9, 11)) + rng.randint(0, 5)))
        acts = [tk(), ('render', 0, 0), ('pieceprobes', 4, 6, False), ('set', dict(step=3, dir=0x11)), ('pieceprobes', 2, 0, False), ('set', dict(step=0, dir=0)),
                ('bot', 6, 'play')]
        for st in (1, 3, 4, 5, 9, 0x80000000, M32):
            acts += [('set', dict(state=st)), ('pieceprobes', 2, 0, False)]
        acts += [('set', dict(state=0)), ('cleanup',)]
        S('negrect:%d' % case, [R_D3(body)], acts, 'pointer', init=dict(origin=rng.choice(ORIGINS)), quick=case < 2)
    for case in range(16):                               # idle with the solved flag set, the start flag cleared before phase 2
        body = mk(solved=pick_block(rng), cancel=pick_block(rng), solved_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS),
                  snd_kinds=[rng.choice(SK), rng.choice(SK), rng.choice(SK), rng.choice(SK)], delay=rng.choice((0, 1, 2)))
        flags = [dict(canceled=1, solved=0), dict(canceled=0, solved=1), dict(canceled=0, solved=0)][case % 3]
        S('idle_solved:%d' % case, [R_D3(body, subtype=rng.choice((1, 2)))],
          [tk(), ('set', dict(state=0, solved=1)), tk(), tk(tick=[1000] * 3), tk(tick=[1000 + 1000 * 3] * 3), tk(busy=[0]), tk(), ('rearm',), tk(),
           ('set', dict(start=0, **flags)), ('setphase', 0, 2), tk(), ('rearm',), tk(), ('set', dict(start=0, **flags)), ('setphase', 0, 2), tk()], 'finish',
          quick=case < 2)

    for case in range(12):                               # every arrow type with negative odd arrow rectangles (truncating halves of the arrow size)
        t = [[0] * 8 for _ in range(8)]
        t[0][1], t[1][0], t[1][2], t[2][1] = 0x10, 0x11, 0x12, 0x13
        t[0][3] = 0x10 + case % 4
        body = mk(R=3, C=4, P=2, types=t, starts=[(1, 1), (3, 2)], odd=True, gap=rng.choice((-3, 0, 5)))
        al = rng.choice((9, 14, 5)); at = rng.choice((9, 14, 5))
        aw = rng.choice((-1, -3, -5, -7, -9, 3, 6)); ah = rng.choice((-1, -3, -5, -7, -9, 3, 6))
        bw = rng.choice((-1, -3, -5, -7, -9, 3, 6)); bh = rng.choice((-1, -3, -5, -7, -9, 3, 6))
        body = patch(body, B_ARROW_H, struct.pack('<4i', al, at, al + aw, at + ah))
        body = patch(body, B_ARROW_V, struct.pack('<4i', at, al, at + bw, al + bh))
        S('negarrow:%d' % case, [R_D3(body)], [tk(), ('render', 0, 0), ('pieceprobes', 2, 0, False), ('cleanup',)], 'geom', quick=case < 1)
    for case in range(8):                                # the click on an object that is not active
        body = mk(snd_kinds=['real', 'none', 'none', 'none'], ch=[1, 1, 2, 3])
        acts = [tk()]
        for cand in (0x277F, 0x2780, 0x2783, 0x2781):
            for cond in (dict(state=0, solved=0, dir=0x11, active=0), dict(state=0, solved=0, dir=0, active=0), dict(state=0, solved=0, dir=0x11, active=1)):
                acts += [('set', dict(cand=cand, start=1, canceled=0, **cond)), ('setphase', 0, 1), ('click', {}), ('set', dict(state=0, solved=0, dir=0, active=1)),
                         ('setphase', 0, 1)]
        S('click_inactive:%d' % case, [R_D3(body)], acts, 'click', quick=case < 1)
    return scs


# extra actions that read the live board
def _pieceprobes(where, x, nat, run, stats, rng, sc, ai, act):
    ri = cur_row(nat, run)
    body = run.rows[ri]['body']
    info, t, pieces, w = board_from_x(x, body)
    view = origin_of(x)
    pts = []
    for n in sorted(pieces)[:act[1]]:
        cf = cell_fields(w, *pieces[n])
        pts += probe_points((cf['rect0'], cf['rect1'], cf['rect2'], cf['rect3']), info, view, rng, act[2])
    if act[3]:
        pts += cancel_points(body, view)
    for k, (px, py) in enumerate(pts):
        do_pointer(where, x, nat, run, stats, rng, px, py, light=(k % 24 != 23 and k != len(pts) - 1))


_base_do_action = do_action


def do_action(x, nat, run, stats, rng, sc, ai, act, depth=0):  # noqa: F811
    if act[0] == 'pieceprobes':
        where = '%s action %d%s pieceprobes' % (sc['id'], ai, '.%d' % depth if depth else '')
        run.trace.append('pieceprobes')
        _pieceprobes(where, x, nat, run, stats, rng, sc, ai, act)
        stats['actions']['pieceprobes'] += 1
        return None
    if act[0] == 'bind':
        run.trace.append('bind')
        ri = cur_row(nat, run)
        info, t, pieces, w = board_from_x(x, run.rows[ri]['body'])
        if act[1] in pieces:
            a, c = pieces[act[1]]
            do_set(x, nat, run, dict(piece=act[1], at_row=a, at_col=c, dir=act[2], step=0, state=act[3]))
        stats['actions']['bind'] += 1
        return None
    return _base_do_action(x, nat, run, stats, rng, sc, ai, act, depth)


# ---------------------------------------------------------------------------------------------
# native-only refusals (known divergences K1..K7)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.obj(), nat.world(), nat.events(), nat.entries(), tuple(nat.cells()[:8]), len(nat.log(0)), len(nat.log(1)))


def refusal_checks(nat, stats):
    rng = random.Random(0xD301)
    base = make_body(rng, snd_kinds=['real', 'real', 'real', 'real'], solved=rand_block(rng, 12), cancel=rand_block(rng, 13), solved_flag=(5, 9),
                     cancel_flag=(6, 1), R=3, C=3, P=2, types=[[0, 0, 1], [0, 0, 0], [2, 0, 0]], starts=[(0, 0), (1, 1)])
    qs = dict(tick=[5000] * 8, busy=[0] * 8, handle=[0x1234, 0x1235, 0x1236])

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
        nat.set_origin(1, 2)
        nat.set_start(1)

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    def pat(off, data, body=base):
        return patch(body, off, data)

    # K1: bodies
    bad = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:],
           'rows 9': pat(B_ROWS, struct.pack('<h', 9)), 'rows -1': pat(B_ROWS, struct.pack('<h', -1)), 'cols 9': pat(B_COLS, struct.pack('<h', 9)),
           'cols -1': pat(B_COLS, struct.pack('<h', -1)), 'pieces 11': pat(B_PIECES, struct.pack('<h', 11)), 'pieces -1': pat(B_PIECES, struct.pack('<h', -1)),
           'steps 0': pat(B_STEPS, struct.pack('<h', 0)), 'steps -1': pat(B_STEPS, struct.pack('<h', -1)),
           'steps -32768': pat(B_STEPS, struct.pack('<h', -32768))}
    for k, off in enumerate(B_SND):
        bad['sound %s unterminated' % 'ABCD'[k]] = pat(off, bytes([0x42 + k] * 0x21))
    for name, b in bad.items():
        fresh(active=1, row=0)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
        expect('K1 click ' + name, nat.click(b, 1, 0x277F)[0], ERR_ARGUMENT)
        expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
        expect('K1 no effect ' + name, snapshot(nat), snap)
    for name, b in {'valid': base, 'terminator on the last name byte': pat(0x20, b'\0', pat(0, bytes([0x41] * 0x20))),
                    'rows 8 cols 8 pieces 10': pat(B_ROWS, struct.pack('<3h', 8, 8, 10)), 'rows 0 cols 0 pieces 0': pat(B_ROWS, struct.pack('<3h', 0, 0, 0)),
                    'steps 1': pat(B_STEPS, struct.pack('<h', 1)), 'steps 32767': pat(B_STEPS, struct.pack('<h', 32767))}.items():
        expect('K1 accepted: ' + name, nat.validate(b), OK)
    fresh()
    expect('K1 phase 0 with a negative row', nat.step(base, -1, 0)[0], ERR_ARGUMENT)
    # K2: phase 1 / 2 without initialisation, or for another row
    for ph in (1, 2):
        for variant in ('uninitialised', 'other row'):
            fresh(active=1 if variant == 'other row' else 0, row=3 if variant == 'other row' else 0, state=1)
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K3: event flag outside the host window (the cancel and the solved path)
    for idx in (4096, -2, 32767, -32768):
        for name, st, off in (('cancel', dict(canceled=1), B_CANCEL + 22), ('solved', dict(solved=1), B_SOLVED + 22)):
            body = pat(off, struct.pack('<h', idx))
            fresh(active=1, row=0, **st)
            snap = snapshot(nat)
            expect('K3 %s flag %d' % (name, idx), nat.step(body, 0, 2)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    for idx in (-1, 0, 4095):
        for name, st, off in (('cancel', dict(canceled=1), B_CANCEL + 22), ('solved', dict(solved=1), B_SOLVED + 22)):
            fresh(active=1, row=0, slot=0x19, **st)
            expect('K3 %s flag %d accepted' % (name, idx), nat.step(pat(off, struct.pack('<h', idx)), 0, 2)[0], OK)
    # K4: a piece number outside 1..10 in a drawn cell
    for piece in (11, -1, 0x7FFF, -0x8000):
        fresh(active=1, row=0, slot=0x19, surface=0x77)
        world = bytearray(nat.world())
        cells = bytearray(world[6:])
        put_cell(cells, 1, 1, visible=1, piece=piece, type=0)
        world[6:] = cells
        nat.set_world(bytes(world))
        snap = snapshot(nat)
        plan = nat.render(base)
        expect('K4 piece %d' % piece, plan['status'], ERR_BOUNDS)
        expect('K4 no object change', snapshot(nat)[:5], snap[:5])
    # K7: render with the slot -1 does nothing; invalidate / cleanup with the slot -1 skip the table
    fresh(active=1, row=0)
    snap = snapshot(nat)
    plan = nat.render(base)
    expect('K7 render slot -1', (plan['status'], plan['valid'], plan['count']), (OK, 0, 0))
    expect('K7 render slot -1 no effect', snapshot(nat), snap)
    expect('K7 invalidate slot -1', nat.invalidate(), OK)
    expect('K7 invalidate slot -1 no host call', len(nat.log(1)), 0)
    # K6: host failures surface as CPZ_ERR_HOST (each host callback the paths reach)
    def fails(what, mask_, run_fn, **state):
        fresh(**state)
        nat.set_fail(mask_)
        expect('K6 ' + what, run_fn(), ERR_HOST)
        nat.set_fail(0)
    for what, m in (('alloc', F_ALLOC), ('register', F_REGISTER), ('load', F_LOAD), ('set_slot_surface', F_SETSURF), ('view_origin', F_ORIGIN),
                    ('clear_item', F_CLEAR), ('sound_prepare', F_PREPARE)):
        fails('phase 0 ' + what, m, lambda: nat.step(base, 0, 0)[0])
    for what, m in (('release_surface', F_RELEASE_SURFACE), ('release_slot', F_RELEASE_SLOT), ('sound_stop', F_STOP), ('transition', F_TRANSITION),
                    ('store_flag', F_FLAG)):
        fails('phase 2 ' + what, m, lambda: nat.step(base, 0, 2)[0], active=1, row=0, slot=0x19, surface=0x77, solved=1)
    fails('phase 2 cancel transition', F_TRANSITION, lambda: nat.step(base, 0, 2)[0], active=1, row=0, slot=0x19, surface=0x77, canceled=1)
    fails('phase 1 moving view_origin', F_ORIGIN, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=2)
    fails('phase 1 wait sound busy', F_BUSY, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=3)
    fails('phase 1 wait delay prepare', F_PREPARE, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=4, deadline=0)
    fails('phase 1 wait delay play', F_PLAY, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=4, deadline=0)
    fails('phase 1 wait sound stop', F_STOP, lambda: nat.step(base, 0, 1)[0], active=1, row=0, state=3)
    fails('click play', F_PLAY, lambda: nat.click(base, 1, 0x2780)[0], active=1, row=0, dir=0x10)
    fails('invalidate dirty', F_DIRTY, lambda: nat.invalidate(), active=1, row=0, slot=0x19)
    fails('render view_origin', F_ORIGIN, lambda: nat.render(base)['status'], active=1, row=0, slot=0x19)
    fails('cleanup release_surface', F_RELEASE_SURFACE, lambda: nat.cleanup(), surface=5)
    fails('cleanup release_slot', F_RELEASE_SLOT, lambda: nat.cleanup(), slot=0x19)
    fresh()
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
    """ASan + UBSan run of the kernel on bounded malformed inputs (random bodies of exact heap length, random worlds, kernel-reachable objects).
    --fuzz-corrupt also feeds objects no kernel call can produce (index fields outside the board); the kernel does not guard those (open item)."""
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang')
    exe = Path(tempfile.mkdtemp(prefix='d3_fuzz_')) / 'fuzz'
    build = [cc, '-std=c11', '-Wall', '-Wextra', '-Werror', '-O1', '-g', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
             '-fno-omit-frame-pointer', '-DD3O_FUZZ_MAIN', f'-I{args.src}', str(PROJECT / 'tests/action_family_d3_runtime_oracle_driver.c'),
             *[str(Path(args.src) / x) for x in SOURCES], '-o', str(exe)]
    done = subprocess.run(build, capture_output=True, text=True)
    if done.returncode != 0:
        print('fuzz build failed', done.stderr[-600:])
        return 1
    env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
    total = 0
    for seed in range(1, 5):
        run = subprocess.run([str(exe), str(args.fuzz), str(seed), '1' if args.fuzz_corrupt else '0'], capture_output=True, text=True, env=env, timeout=1800)
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
    ap.add_argument('--fuzz-corrupt', action='store_true')
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
    tmp = tempfile.TemporaryDirectory(prefix='RT-53.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    # fast paths first: a failing mutant is caught by the quick set before the long scenarios
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_d3.so', strict=not args.lenient_build)
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
            args.result.write_text(json.dumps(dict(slice='RT-53', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_d3.so', strict=not args.lenient_build)
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
        args.result.write_text(json.dumps(dict(slice='RT-53', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
