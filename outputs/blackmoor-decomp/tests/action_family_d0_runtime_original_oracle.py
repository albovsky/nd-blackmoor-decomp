#!/usr/bin/env python3
"""RT-50: immutable x86 dispatcher 0x427a50 / handler 0x48d914 (raw 0xd0, the Piano Puzzle), the object methods 0x48d1e8 (pointer),
0x48d5f4 (click), 0x48ded7 (render callback), 0x48d0e5 (invalidate), 0x48d09c (cleanup) versus the native kernel
src/action_family_d0_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xd0 (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a0ea, the handler
0x48d914 with every phase and all five states of obj+0x2b (0..4, plus the values above 4 that fall out of the switch), the solved check
0x48d89e, the generic completion 0x42ba3a (subtype 1 sets the completion byte, subtype 2 clears it and runs the dependency reset
0x423d33, every subtype stores phase 0) and the cleanup 0x48d09c / 0x48d067. The generic Z entry allocator 0x4d39f9 and releaser
0x4d3992 run as original code on the table at 0x5d1591 (busy seeds decide which slot comes back). The object methods run as original
functions on the same process image with ECX = 0x61d345: the pointer test 0x48d1e8 (with its inner 0x48d3cb; two stack dwords x, y whose
upper halves are garbage), the click method 0x48d5f4 (no arguments, reads the candidate 0x5c39e5 and the start flag 0x5bb1ca), the render
callback 0x48ded7 (cdecl) and the invalidate 0x48d0e5, the cleanup 0x48d09c.

Native side: tests/action_family_d0_runtime_oracle_driver.c links ONLY the kernel (src/action_family_d0_runtime.c) and implements the HOST
side of the D0Host contract with scripted queues (GetTickCount values, sound-busy answers, image handles, the texts the lookup 0x423259
answers with, NULL included), a model of the Z entry table and the view origin. The driver decides nothing the kernel decides. It keeps
two logs, the observer log (D0Host.observe) and the host-call log (what the kernel really asked of the host); the oracle requires them to
agree, so an observer that invents or omits an effect fails.

Compared after EVERY action (dispatcher pass, pointer, click, render, invalidate, cleanup):
 * the whole 0x5c-byte object image 0x61d345.. byte for byte against D0Object (the bytes without a field come from a shadow); the process
   cells 0x5bb1ca and 0x583999; the seven scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff 0x5bb59b 0x5bb59f 0x5bb5a3; the whole
   event flag window (4096 dwords at 0x585801); the whole generic Z entry table (0x58 entries of 0x4a bytes: type 10, callback 0x48ded7,
   surface, flags 0/0/1/1, word 0 and the label are the stores of the original; the allocator and releaser flags); the pointer and cursor
   cells 0x5c39e5 0x5b44f0 0x5b44f4 and the three host-composed cells 0x5d162d 0x5d1631 0x5d1639 against their documented composition
   from the native outputs ([0x5d0377] copy, 0x5b160c + (kind << 5) + (sub << 4), 1);
 * every byte of every row (0x8d bytes except the dependency record the gate and the reset own) against a model, and the whole row body
   (the click block rewrites body+0x715.., the native kernel mutates a copy that becomes the model); garbage in the unlisted bytes proves
   nothing else is touched; every write outside the listed cells fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every effect of
   the D0Effect list: stores to +0x33 / +0x1c / +0x2b / 0x5bb1ca / the scene cells / the engine mode / the event flag window / the row
   phase dword, the code points after the entry label copy (0x48dadc) and after the slot surface store (0x48db1b), the entry of 0x48d89e,
   and the calls to the image loader, the releasers, the clear-item hook, the four sound routines, the text lookup and the text show,
   GetTickCount, the blit and the generic completion, then the completion byte, the dependency reset and the phase store of 0x42ba3a)
   against the sequence the native kernel reports for the same visit, entry for entry; the scripted queues (tick, busy, handle, text)
   are consumed identically by both sides;
 * click: every looked-up key string, every shown text (bytes including the "<e>" suffix), the sound-play call, the exit candidate
   (+0x37 and row phase 2) and the retained sound record in the body;
 * pointer: the return value (1 claims), the candidate 0x5c39e5, the cursor cells, hover and the dirty byte;
 * render: every recorded 0x4c5377 blit (this, source surface, source rectangle contents, target, destination rectangle contents, label
   pointer and string) against d0_render's result, including the view origin.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10)   R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4e8d96 clear pending item (ECX 0x571442, ret 0)       R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)
  R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4)               R 0x4c5377 blit recorder (ECX 0x5cf659, ret 0x14)
  R 0x423259 text lookup (ECX 0x619a6b, ret 4: scripted pointer or NULL)   R 0x448d11 text show (ECX 0x619a05, ret 0x10)
  R 0x51dc6c free (recorded)  R GetTickCount (import thunk stub) scripted values
  O 0x42a0ea / 0x428692 arm entries, 0x42a10e / 0x4286b5 post-gate points, 0x48d914 handler entry, 0x42a120 handler return, 0x42ba3a generic
    completion, 0x42babe (its ret), 0x423d33 dependency reset, 0x48d89e solved check entry, 0x48dadc / 0x48db1b code points inside the
    handler, 0x4d3992 releaser entry; every store to the process data region is observed (read-only)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0. The strings the kernel hard-codes ("<e>\\0" at 0x54e898, "NO SOUND\\0" at 0x54e88c and 0x54e8d4, the labels, the byte 0x63a8ac
 of the empty-name test) are checked against the image at start-up.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick and busy values, the texts, the
view origin, the background / target surface handles (entry 1 surface 0x5d15e3, cell 0x5cf665), the busy seeds of the Z entry table, the
event flag window contents.

KNOWN DIVERGENCES (native safety layer; never silently skipped. Checked natively in refusal_checks(); the oracle's scenarios skip the
actions the kernel refuses (counted in stats.skipped_native_refusal) instead of running them against the original):
  K1 d0_validate_body: short body, name without NUL, N outside 0..15, L outside 1..15 (L == 0 makes the original store into the deadline),
     a key sound / text key without NUL inside its 0x21 bytes -> D0_ERR_BODY (step) / D0_ERR_ARGUMENT (others), no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row -> D0_ERR_UNSUPPORTED, no effect.
  K3 phase 2 with an event flag index outside the host window -> D0_ERR_BOUNDS before the first effect.
  K4 a key press (click) or a render blit whose hover / last key is outside 0..N-1 -> D0_ERR_BOUNDS, no effect.
  K5 a looked-up text longer than 199 characters (and not over 0x9c40: the original overflows its 203-byte stack buffer) -> D0_ERR_BOUNDS
     after the sound effects, nothing shown; longer than 0x9c40 characters is skipped by the original and by the kernel (compared).
  K6 host failures -> D0_ERR_HOST, allocator exhaustion (the original reaches the fatal path 0x52139c) -> D0_ERR_HOST.
  K7 render with the slot -1 while a redraw is requested and a surface exists: native does nothing (valid = 0), the original would index the
     entry table at -1. Row phase above 2 and an object state above 4 are not divergences (compared).
 All of these are unreachable in the game (loader-built 1979-byte bodies, one row per scene, callbacks only for allocated entries).

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69,
0x4fb2e3, 0x4f6334), the text lookup 0x423259 and show 0x448d11, 0x4e8d96, the blit body 0x4c5377, the cascade 0x4f0059 and the accepted-
release chain 0x43b273 that call 0x48d1e8 / 0x48d5f4 (the oracle calls the methods directly), the generic Z entry drawer that calls
0x48ded7 (the oracle calls it itself), the scene clears 0x438b5d / 0x43de52 and the invalidate caller 0x43d910 (the methods are run
directly), the loader 0x48d12d / 0x40b34a that builds the body, the engine consumers of the scene-change cells, and the host composition of the
cursor cells (their documented composition is checked, not the engine code that reads them).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.

Modes: --quick-only runs the scenarios flagged quick (seconds); the default run is every scenario plus the native-only refusal checks;
--mutations additionally plants ~115 mutants into a temporary copy of src/action_family_d0_runtime.c (each is built into its own driver
library and must be caught by the quick set or the full set; MUTANTS below, anchors must match exactly once); EQUIVALENT_MUTANTS lists the
mutants that are invisible against the original and are not counted. --discover-pins prints the PINS_TABLE of the original code the
scenarios execute (function spans from the decompiled function index). The pins are verified at start-up; a mismatch aborts the run.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_d0_runtime_original_oracle.py --quick-only
  python3 action_family_d0_runtime_original_oracle.py --mutations --result ../../../work/analysis/slices/RT-50.oracle-result.json
  python3 action_family_d0_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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
BODY_LEN = 1979
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x48D914, 0x42BA3A, 0x423D33, 0x42BABE
HANDLER_RETURN = 0x42A120
ARM = {0xD0: 0x42A0EA, 0x67: 0x428692}
VISIT = {0xD0: 0x42A10E, 0x67: 0x4286B5}
M_POINTER, M_CLICK, M_RENDER, M_INVALIDATE, M_CLEANUP, M_SOLVED = 0x48D1E8, 0x48D5F4, 0x48DED7, 0x48D0E5, 0x48D09C, 0x48D89E
AT_REGISTER, AT_SLOT_SURFACE = 0x48DADC, 0x48DB1B
RELEASE_SLOT_FN = 0x4D3992
LOAD_IMAGE, RELEASE_IMAGE, CLEAR_ITEM = 0x4C2790, 0x4C2DFB, 0x4E8D96
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
BLIT, FREE, TEXT_LOOKUP, TEXT_SHOW = 0x4C5377, 0x51DC6C, 0x423259, 0x448D11

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ = 0x61D345
OBJ_LEN = 0x5C
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_ORG_X, CELL_ORG_Y = 0x583186, 0x58318A
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377, CELL_TEXTARG = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377, 0x5D03B3
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY, THIS_ITEM, THIS_TEXT, THIS_SHOW = 0x5CF659, 0x5C3A67, 0x5CF1EB, 0x571442, 0x619A6B, 0x619A05
BG_HANDLE, TARGET_HANDLE = 0x7A000011, 0x7A000022
LABEL_KIND, LABEL_SURFACE = b'CIFTREE', b'Piano Puzzle Surface'
LABEL_VA_PRESSED, LABEL_VA_RESTORE = 0x54E8E0, 0x54E8FC
LABEL_PRESSED, LABEL_RESTORE = b'Piano puzzle pSrcSurface', b'Piano Puzzle pSrcSurface'
NO_SOUND = b'NO SOUND\0'
TEXT_BASE = d9.HEAP_BASE + d9.HEAP_SIZE - 0x40000
TEXT_STRIDE = 0xA000
TEXT_ARG = 0x0BADBEEF
CAND_KEY, CAND_EXIT = 0x2765, 0x2766

FX = dict(ACTIVE=1, START_FLAG=2, CLEAR_ITEM=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6, SLOT_SURFACE=7, PHASE=8, STATE=9,
          SOUND_PREPARE=10, SOUND_STOP=11, SOUND_PLAY=12, SOUND_BUSY=13, TICK=14, X57B=15, X599=16, X595=17, X39FF=18, X59B=19,
          X59F=20, X5A3=21, MODE=22, EVENT_FLAG=23, COMPLETE=24, RELEASE_SURFACE=25, RELEASE_SLOT=26, TEXT_LOOKUP=27, TEXT_SHOW=28,
          BLIT=29, SOLVED_CHECK=30)
FXN = {v: k for k, v in FX.items()}
FX_SIZE = {FX['SLOT']: (2, 4), FX['SLOT_REGISTER']: (2, 4), FX['SLOT_SURFACE']: (2, 4), FX['SOUND_PLAY']: (2, 4), FX['COMPLETE']: (2, 4),
           FX['X599']: (2, 4), FX['X595']: (2, 4), FX['X39FF']: (2, 4), FX['RELEASE_SLOT']: (2, 4), FX['EVENT_FLAG']: (2, 4)}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
# the kinds that are also host calls (the host-call log of the driver uses the same numbers)
HOST_FX = {FX['CLEAR_ITEM'], FX['SLOT'], FX['SLOT_REGISTER'], FX['SURFACE_LOAD'], FX['SLOT_SURFACE'], FX['SOUND_PREPARE'],
           FX['SOUND_STOP'], FX['SOUND_PLAY'], FX['SOUND_BUSY'], FX['TICK'], FX['EVENT_FLAG'], FX['RELEASE_SURFACE'], FX['RELEASE_SLOT'],
           FX['TEXT_LOOKUP'], FX['TEXT_SHOW']}
HC_MARK_DIRTY, HC_ORIGIN = 100, 101

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), CLEAR_ITEM: (0x32, 0), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4),
             SND_PLAY: (0xb4, 4), SND_BUSY: (0x138, 4), BLIT: (0x214, 0x14), FREE: (0xb, 0), TEXT_LOOKUP: (0x10f, 4),
             TEXT_SHOW: (0xa5f, 0x10)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, CLEAR_ITEM: 0, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT: 0x14, FREE: 0,
        TEXT_LOOKUP: 4, TEXT_SHOW: 0x10}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, CLEAR_ITEM: THIS_ITEM, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND,
            SND_PLAY: THIS_SND, SND_BUSY: THIS_BUSY, BLIT: THIS_SURF, TEXT_LOOKUP: THIS_TEXT, TEXT_SHOW: THIS_SHOW}

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
    (0x48d067, 0x48d09c, '5497e61ad63a4f2aece7487de826762d09ce52d10dfbbaff93520faa756571f3'),
    (0x48d09c, 0x48d0e5, 'b9ed04abda5e20560959328a01564f6f1d8992a22e59ba1e4760e20c3f482631'),
    (0x48d0e5, 0x48d119, '22238852c847900892e6c7f71c17a6d5670012b4b2faee044cfdbbd321fcc170'),
    (0x48d1e8, 0x48d3cb, 'b2ed89cebeda856c985443892513c937b076e3ff8f20fbfdaa1ce4ad3f465a32'),
    (0x48d3cb, 0x48d5f4, '24c7997adcd6e49ebf1cc544724aacb8770595cf8b5831aa00942d01edd94b2b'),
    (0x48d5f4, 0x48d89e, '3087d9d66981870381180468e94cfb417d6e69f7a59f9cebfe0ae9f682198e7c'),
    (0x48d89e, 0x48d914, '55dd6272c2e9078c8e422f614795c611341a334b0430382047c21ca69dce4303'),
    (0x48d914, 0x48dec7, 'c16eaa9635b6c5261282602575e07dc3c07f4970869c22bc78c89ab3d7dbd873'),
    (0x48ded7, 0x48e170, '780edc82219b3b74918eeb48fb22e99baa07b216cc857707f49d9ba98adf8731'),
    (0x4c2790, 0x4c2898, '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377, 0x4c558b, 'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
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


class Skip(Exception):
    """The kernel refuses this action (known divergence): not run against the original."""


# ---- object layout (offsets from 0x61d345)
OBJ_FIELDS = (('slot', 0x1C, 2), ('row', 0x1E, 2), ('surface', 0x20, 4), ('dirty', 0x24, 1), ('check', 0x25, 1), ('pressed', 0x26, 1),
              ('hover', 0x27, 2), ('last', 0x29, 2), ('state', 0x2B, 4), ('has_surface', 0x2F, 4), ('active', 0x33, 4),
              ('exit', 0x37, 1), ('solved', 0x38, 1), ('deadline', 0x39, 4), ('order', 0x3D, 30))
OBJ_POS = {n: (o, s) for n, o, s in OBJ_FIELDS}
SIGNED = {'slot', 'row', 'hover', 'last', 'state'}


def fld(img, name):
    off, size = OBJ_POS[name]
    raw = bytes(img[off:off + size])
    if name == 'order':
        return list(struct.unpack('<15h', raw))
    return int.from_bytes(raw, 'little', signed=name in SIGNED)


def put_fld(img, name, v):
    off, size = OBJ_POS[name]
    if name == 'order':
        struct.pack_into('<15h', img, off, *[sgn(e, 2) for e in v])
    else:
        img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xd0 hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('tick', 'busy', 'handle')}
        self.texts = []
        self.qpos = Counter()
        self.tpos = 0
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
        want = ((0x54E898, b'<e>\0'), (0x54E88C, NO_SOUND), (0x54E8D4, NO_SOUND), (0x54E89C, b'PIANO PUZZLE OVERLAYS\0'),
                (0x54E8B4, LABEL_SURFACE + b'\0'), (0x54E8CC, LABEL_KIND + b'\0'), (LABEL_VA_PRESSED, LABEL_PRESSED + b'\0'),
                (LABEL_VA_RESTORE, LABEL_RESTORE + b'\0'), (0x63A8AC, b'\0'))
        for va, data in want:
            if img(va, len(data)) != data:
                raise d9.OracleError('image constant at %#x differs from the kernel assumption: %r' % (va, img(va, len(data))))

    def clear_logs(self):
        self.events = []
        self.written = Counter()
        self.loaded = []
        self.frees = []
        self.blits = []
        self.shown = []
        self.lookups = []
        self.in_complete = False
        self.cur_phase = None

    # -- scripted queues -----------------------------------------------------------------------
    def set_queues(self, qs):
        self.qs = {k: list(qs.get(k, [])) for k in ('tick', 'busy', 'handle')}
        self.texts = list(qs.get('text', []))
        self.qpos = Counter()
        self.tpos = 0

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
                      GENERIC_RET: self._complete_done, DEP_RESET: self._reset_seen, M_SOLVED: self._solved_check,
                      AT_REGISTER: self._at_register, AT_SLOT_SURFACE: self._at_slot_surface, RELEASE_SLOT_FN: self._release_slot})
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
            raise d9.OracleError('handler entered with ECX != 0x61d345')
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

    def _solved_check(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise d9.OracleError('solved check entered with ECX != 0x61d345')
        self.events.append(('fx', FX['SOLVED_CHECK'], 0, 0))

    def _at_register(self, uc, address, size, user):
        self.events.append(('fx', FX['SLOT_REGISTER'], self.rs16(OBJ + 0x1C), 0))

    def _at_slot_surface(self, uc, address, size, user):
        if self.cell(OBJ + 0x2F) != 0:        # 0x48db1b is also the join point of the no-surface path
            slot = self.rs16(OBJ + 0x1C)
            self.events.append(('fx', FX['SLOT_SURFACE'], slot, self.entry_surface(slot)))

    def _release_slot(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.events.append(('fx', FX['RELEASE_SLOT'], struct.unpack('<H', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

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
        elif address == CLEAR_ITEM:
            self.events.append(('fx', FX['CLEAR_ITEM'], 0, 0))
        elif address in (SND_PREPARE, SND_STOP):
            self.events.append(('fx', FX['SOUND_PREPARE'] if address == SND_PREPARE else FX['SOUND_STOP'], a[0] - self.body_ptr(a[0]), 0))
        elif address == SND_PLAY:
            self.events.append(('fx', FX['SOUND_PLAY'], a[0] & 0xFFFF, 0))
        elif address == SND_BUSY:
            eax = self.pop('busy')
            self.events.append(('fx', FX['SOUND_BUSY'], a[0], eax))
        elif address == TEXT_LOOKUP:
            body = self.body_ptr(a[0])
            off = a[0] - body - 0x358
            if off < 0 or off % 0x42 or off // 0x42 > 14:
                raise d9.OracleError('text key pointer %#x is not a key text of the body' % a[0])
            if self.tpos >= len(self.texts):
                raise d9.OracleError('script underflow: text queue')
            item = self.texts[self.tpos]
            slot = self.tpos
            self.tpos += 1
            self.lookups.append(d9.cstr(self.rd(a[0], 0x21)))
            if item is None:
                eax = 0
            else:
                if len(item) + 1 > TEXT_STRIDE:
                    raise d9.OracleError('scripted text too long')
                eax = TEXT_BASE + slot * TEXT_STRIDE
                self.wr(eax, bytes(item) + b'\0')
            self.events.append(('fx', FX['TEXT_LOOKUP'], off // 0x42, 0 if item is None else 1))
        elif address == TEXT_SHOW:
            text = d9.cstr(self.rd(a[1], 256))
            if a[0] != self.cell(CELL_TEXTARG) or a[2] != M32 or a[3] != 0:
                raise d9.OracleError('text show arguments differ: %#x %#x %#x' % (a[0], a[2], a[3]))
            self.shown.append(text)
            self.events.append(('fx', FX['TEXT_SHOW'], len(text), 0))
        elif address == BLIT:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            label = d9.cstr(self.rd(a[4], 64))
            kind = 1 if a[4] == LABEL_VA_PRESSED else 2 if a[4] == LABEL_VA_RESTORE else 0
            if kind == 0:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            body = self.body_ptr(a[2])
            key = (a[2] - body - (0x23 if kind == 1 else 0x113)) // 16
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=label, label_ptr=a[4],
                                   kind=kind, key=key))
            self.events.append(('fx', FX['BLIT'], key, kind))
        elif address == FREE:
            self.frees.append(a[0])
        else:
            raise d9.OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    def body_ptr(self, pointer):
        """The body pointer of the row whose body contains `pointer` (the sound records and key records are inside it)."""
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
        off = address - OBJ
        if 0 <= off < OBJ_LEN:
            if off == 0x33 and size == 4 and value != 0:
                self.events.append(('fx', FX['ACTIVE'], 1, 0))
            elif off == 0x1C and size == 2 and self.cur_phase == 0:
                self.events.append(('fx', FX['SLOT'], value, 0))
            elif off == 0x2B and size == 4:
                self.events.append(('fx', FX['STATE'], value, 0))
        hit = WRITE_FX.get(address)
        if hit is not None and hit[1] == size:
            self.events.append(('fx', hit[0], value, 0))
        self.written['%#x/%d' % (address, size)] += 1

    # -- state access ----------------------------------------------------------------------------
    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

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
SOURCES = ('action_family_d0_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_ORIGIN, F_CLEAR, F_PREPARE, F_STOP, F_PLAY,
 F_BUSY, F_TEXT_LOOKUP, F_TEXT_SHOW, F_TRANSITION, F_FLAG) = [1 << k for k in range(17)]
QKINDS = ('tick', 'busy', 'handle')


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_d0_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('D0_SANITIZE'):
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
        P, I32, U32, U8P, I64P, I32P = C.c_void_p, C.c_int32, C.c_uint32, C.POINTER(C.c_uint8), C.POINTER(C.c_int64), C.POINTER(C.c_int32)
        lib.d0o_new.restype = P
        for name, args, res in (
                ('d0o_free', [P], None), ('d0o_reset', [P], None), ('d0o_clear_logs', [P], None), ('d0o_set_fail', [P, C.c_int], None),
                ('d0o_set_origin', [P, I32, I32], None), ('d0o_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('d0o_q_pos', [P, C.c_int], C.c_int), ('d0o_q_underflow', [P, C.c_int], C.c_int),
                ('d0o_text_clear', [P], None), ('d0o_text_add', [P, C.c_char_p, C.c_int, C.c_int], C.c_int),
                ('d0o_text_pos', [P], C.c_int), ('d0o_text_underflow', [P], C.c_int),
                ('d0o_obj_get', [P, C.c_char_p], None), ('d0o_obj_set', [P, C.c_char_p], None),
                ('d0o_extra_get', [P, C.POINTER(U32)], None), ('d0o_extra_set', [P, C.POINTER(U32)], None),
                ('d0o_cells_get', [P, I32P], None), ('d0o_cells_set', [P, I32P], None),
                ('d0o_events_get', [P, C.c_char_p], None), ('d0o_events_set', [P, C.c_char_p], None),
                ('d0o_entries_get', [P, C.c_char_p], None), ('d0o_entries_set', [P, C.c_char_p], None),
                ('d0o_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('d0o_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('d0o_str', [P, C.c_int, C.c_int], C.c_char_p),
                ('d0o_nstr', [P, C.c_int], C.c_int), ('d0o_errors', [P, I32P], None),
                ('d0o_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('d0o_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('d0o_click', [P, U8P, C.c_int, U32, I32, I32, I32P], None),
                ('d0o_invalidate', [P], C.c_int), ('d0o_cleanup', [P], C.c_int), ('d0o_validate', [C.c_char_p, C.c_int], C.c_int),
                ('d0o_render', [P, C.c_char_p, C.c_int, I32P], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.d0o_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.d0o_free(self.h)

    def reset(self):
        self.lib.d0o_reset(self.h)

    def clear_logs(self):
        self.lib.d0o_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.d0o_set_fail(self.h, m)

    def set_origin(self, x, y):
        self.lib.d0o_set_origin(self.h, x, y)

    def set_queues(self, qs):
        for i, k in enumerate(QKINDS):
            vals = list(qs.get(k, []))[:64]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.d0o_q_set(self.h, i, arr, len(vals))
        self.lib.d0o_text_clear(self.h)
        for t in qs.get('text', []):
            if self.lib.d0o_text_add(self.h, b'' if t is None else bytes(t), 0 if t is None else len(t), 0 if t is None else 1) != 0:
                raise d9.OracleError('native text queue full or text too long')

    def qpos(self, k):
        return self.lib.d0o_q_pos(self.h, QKINDS.index(k))

    def qunder(self, k):
        return self.lib.d0o_q_underflow(self.h, QKINDS.index(k))

    def tpos(self):
        return self.lib.d0o_text_pos(self.h)

    def tunder(self):
        return self.lib.d0o_text_underflow(self.h)

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.d0o_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.d0o_obj_set(self.h, bytes(img))

    def extra(self):
        arr = (C.c_uint32 * 1)()
        self.lib.d0o_extra_get(self.h, arr)
        return list(arr)

    def set_extra(self, vals):
        arr = (C.c_uint32 * 1)(*[v & M32 for v in vals])
        self.lib.d0o_extra_set(self.h, arr)

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.d0o_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.d0o_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.d0o_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.d0o_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.d0o_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.d0o_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.d0o_entry_set_u32(self.h, slot, off, v & M32)

    def log(self, which):
        arr = (C.c_int32 * (3 * 1024))()
        n = self.lib.d0o_log(self.h, which, arr, 1024)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def strs(self, which):
        n = min(self.lib.d0o_nstr(self.h, which), 8)
        return [self.lib.d0o_str(self.h, which, i) for i in range(n)]

    def nstrs(self, which):
        return self.lib.d0o_nstr(self.h, which)

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.d0o_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.d0o_step(self.h, bytes(body), len(body), row, phase, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 6)()
        self.lib.d0o_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, body, row_phase, cand, start_flag):
        out = (C.c_int32 * 6)()
        buf = (C.c_uint8 * len(body)).from_buffer_copy(bytes(body))
        self.lib.d0o_click(self.h, buf, len(body), row_phase & M32, cand, sgn(start_flag, 4), out)
        return tuple(out), bytes(buf)

    def invalidate(self):
        return self.lib.d0o_invalidate(self.h)

    def cleanup(self):
        return self.lib.d0o_cleanup(self.h)

    def validate(self, body):
        return self.lib.d0o_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * 14)()
        self.lib.d0o_render(self.h, bytes(body), len(body), out)
        return dict(status=out[0], valid=out[1], blit=out[2], key=out[3], src_surface=out[4] & M32, src=tuple(out[5:9]),
                    dst=tuple(out[9:13]), solved_check=out[13])


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
def snd(kind):
    return {'none': NO_SOUND, 'real': b'snd_0001\0', 'real2': b'bell_77\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0'}[kind]


KEY_SOUNDS = {'none': b'NO SOUND', 'real': b'piano_c4', 'real2': b'bell_77', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE',
              'near3': b'no sound', 'empty': b'', 'long': b'k' * 32, 'prefix': b'NO SOUN', 'ext': b'NO SOUND2', 'short': b'x'}
KEY_SOUND_NAMES = tuple(KEY_SOUNDS)


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start)


def rand_block(rng, scene):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)))


KIND_POOL = (1, 2, 3, 7, -1, 0x7FFF, -0x8000, 0, 5, 12)


def grid_rect(i, layout, rng):
    if layout == 'grid':
        lft, top = 8 + 36 * (i % 4), 10 + 36 * (i // 4)
        return (lft, top, lft + 31, top + 31)
    if layout == 'overlap':
        return (50, 50, 100, 100)
    if layout == 'neg':
        return (-300 + 40 * i, -90, -300 + 40 * i + 30, -50)
    if layout == 'extreme':
        return rng.choice(((-0x80000000, -0x80000000, 0x7FFFFFFF, 0x7FFFFFFF), (0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF),
                           (-0x80000000, 0, -0x7FFFFFF0, 40), (0, 0, 0, 0), (-1, -1, 0, 0), (40000, 40000, 50000, 50000),
                           (-50000, -50000, -40000, -40000), (i, i, i, i)))
    raise ValueError(layout)


def make_body(rng, n=5, l=3, sol=None, name=b'PUZZLE1', layout='grid', hit='same', regions='auto', click_ch=1, win_ch=2,
              snd_c='none', snd_w='none', solved=None, ev=(-1, 7), delay=1, exit_blk=None, exit_flag=(-1, 0),
              exit_rect=(200, 10, 260, 40), key_sounds=None, key_texts=None, kinds=None):
    b = bytearray(rng.getrandbits(8) for _ in range(BODY_LEN))
    b[0:0x21] = bytes(name[:0x20]).ljust(0x21, b'\0')
    for k in range(len(name) + 1, 0x21):
        b[k] = rng.getrandbits(8)                       # garbage after the terminator
    struct.pack_into('<h', b, 0x21, n)
    keyrects, hitrects = [], []
    for i in range(15):
        rect = grid_rect(i, layout, rng)
        if hit == 'same' or layout == 'extreme':
            hr = rect
        elif hit == 'grow':
            hr = (rect[0] - 2, rect[1] - 2, rect[2] + 2, rect[3] + 2)
        elif hit == 'shrink':
            hr = (rect[0] + 4, rect[1] + 4, rect[2] - 4, rect[3] - 4)
        else:
            raise ValueError(hit)
        keyrects.append(rect)
        hitrects.append(hr)
        struct.pack_into('<4i', b, 0x23 + 16 * i, 400 + 40 * i, 12, 400 + 40 * i + 31, 43)       # pressed-key source rectangle
        struct.pack_into('<4i', b, 0x113 + 16 * i, *rect)
        struct.pack_into('<4i', b, 0x203 + 16 * i, *hr)
    kind_a, kind_b = (kinds or (rng.choice(KIND_POOL), rng.choice(KIND_POOL)))
    if regions == 'auto':
        regions = rng.choice(('all_a', 'a_then_b', 'b_only', 'none', 'edge', 'off1', 'both_all', 'row0'))
    big = (-100000, -100000, 100000, 100000)
    far = (5000, 5000, 6000, 6000)
    half = (0, 0, 8 + 36 * 2 + 31 + 2, 10 + 36 * 4 + 31)       # columns 0..2 of the grid
    rest = (8 + 36 * 3 - 2, 0, 400, 10 + 36 * 4 + 31)
    union = (min(h[0] for h in hitrects[:max(n, 1)]), min(h[1] for h in hitrects[:max(n, 1)]),
             max(h[2] for h in hitrects[:max(n, 1)]), max(h[3] for h in hitrects[:max(n, 1)]))
    ra, rb = {'all_a': (big, far), 'a_then_b': (half, rest), 'b_only': (far, big), 'none': (far, far), 'edge': (hitrects[0], union),
              'off1': ((hitrects[0][0] + 1, hitrects[0][1], hitrects[0][2], hitrects[0][3]),
                       (hitrects[0][0], hitrects[0][1], hitrects[0][2] - 1, hitrects[0][3])),
              'both_all': (big, big), 'row0': ((0, 0, 400, 10 + 31), (0, 10 + 32, 400, 400))}[regions]
    ra, rb = [tuple(sgn(v, 4) for v in r) for r in (ra, rb)]
    struct.pack_into('<h', b, 0x2F3, kind_a)
    struct.pack_into('<4i', b, 0x2F5, *ra)
    struct.pack_into('<h', b, 0x305, kind_b)
    struct.pack_into('<4i', b, 0x307, *rb)
    struct.pack_into('<h', b, 0x317, l)
    if sol is None:
        sol = [rng.randrange(max(n, 1)) for _ in range(l)]
    for k in range(15):
        struct.pack_into('<h', b, 0x319 + 2 * k, sgn(sol[k], 2) if k < len(sol) else rng.choice((0, 1, -1, 0x7FFF)))
    for k in range(15):
        ks = (key_sounds[k % len(key_sounds)] if key_sounds else rng.choice(KEY_SOUND_NAMES))
        kt = (key_texts[k % len(key_texts)] if key_texts else b'KEY_%d' % k)
        sname = KEY_SOUNDS[ks] if isinstance(ks, str) else ks
        rec = bytearray(rng.getrandbits(8) for _ in range(0x42))
        rec[0:0x21] = bytes(sname[:0x20]).ljust(0x21, b'\0')
        rec[0x21:0x42] = bytes(kt[:0x20]).ljust(0x21, b'\0')
        if k >= n and rng.random() < 0.5:
            rec[0:0x42] = bytes(rng.getrandbits(8) | 1 for _ in range(0x42))       # unterminated garbage: only keys 0..N-1 are validated
        b[0x337 + 0x42 * k:0x337 + 0x42 * (k + 1)] = rec
    cs = snd(snd_c)
    b[0x715:0x715 + 9] = cs
    struct.pack_into('<h', b, 0x736, sgn(click_ch, 2))

    def put(off, blk, flag_off, flag, val):
        struct.pack_into('<h', b, off, blk['scene'])
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, off + 20, sgn(blk['start'], 2))
        struct.pack_into('<h', b, flag_off, flag)
        b[flag_off + 2] = val & 0xFF
    put(0x746, solved if solved is not None else block(9999), 0x75C, ev[0], ev[1])
    struct.pack_into('<h', b, 0x75F, delay)
    b[0x761:0x761 + 9] = snd(snd_w)
    struct.pack_into('<h', b, 0x782, sgn(win_ch, 2))
    put(0x792, exit_blk if exit_blk is not None else block(9999), 0x7A8, exit_flag[0], exit_flag[1])
    struct.pack_into('<4i', b, 0x7AB, *exit_rect)
    return bytes(b)


def body_n(body):
    return struct.unpack_from('<h', body, 0x21)[0]


def body_l(body):
    return struct.unpack_from('<h', body, 0x317)[0]


def body_sol(body):
    return list(struct.unpack_from('<%dh' % body_l(body), body, 0x319))


def hit_rect(body, i):
    return struct.unpack_from('<4i', body, 0x203 + 16 * i)


def key_rect(body, i):
    return struct.unpack_from('<4i', body, 0x113 + 16 * i)


def exit_rect_of(body):
    return struct.unpack_from('<4i', body, 0x7AB)


def clamp16(v):
    return max(-32768, min(32767, v))


def center_of(rect):
    return clamp16((rect[0] + rect[2]) // 2), clamp16((rect[1] + rect[3]) // 2)


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
DEFAULT_Q = dict(tick=[5000] * 4, busy=[0] * 4, handle=[0x1234, 0x1235, 0x1236, 0x1237], text=[])
POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
OBJ_RANGE = (OBJ, OBJ + OBJ_LEN)
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, ENTRY_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)] + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [OBJ_RANGE],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0, known_divergences=Counter(),
                queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(), states=Counter(), outcomes=Counter(),
                texts=Counter(), slots=Counter())


def check(stats, where, what, a, b):
    stats['compared_fields'] += 1
    if a != b:
        raise Mismatch('%s: %s original %r native/model %r' % (where, what, a, b))


def diff_obj(a, b):
    out = []
    for name, off, size in OBJ_FIELDS:
        if a[off:off + size] != b[off:off + size]:
            out.append('%s original %s native %s' % (name, a[off:off + size].hex(), b[off:off + size].hex()))
    if a[:0x1C] != b[:0x1C] or a[0x5B:] != b[0x5B:]:
        out.append('unmodelled object bytes original %s native %s' % ((a[:0x1C] + a[0x5B:]).hex(), (b[:0x1C] + b[0x5B:]).hex()))
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
        self.names_seen = 0

    def d0_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xD0]

    def body_for(self, nat_img):
        """The body the kernel is shown: the row of an active object, else the first 0xd0 row (the original returns early)."""
        row, active = fld(nat_img, 'row'), fld(nat_img, 'active')
        rows = self.d0_rows()
        if active and 0 <= row < len(self.rows) and self.rows[row]['type'] == 0xD0:
            return row
        if active:
            raise d9.OracleError('scenario activates the object for a row that is not a 0xd0 row')
        return rows[0]


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(slot=rng.choice((-1, -1, -1, 0x19, 0x30)), row=rng.choice((-1, 0, 1, 3, 5)), surface=rng.choice((0, 0x5151, M32)),
             dirty=rng.choice((0, 1, 0xFE)), check=rng.choice((0, 1, 0x80)), pressed=rng.choice((0, 1, 7)),
             hover=rng.choice((0, 1, 4, -1, 2)), last=rng.choice((0, 1, 4, -1, 2)), state=rng.choice((0, 1, 2, 3, 4, 5, M32)),
             has_surface=rng.choice((0, 1, 0x100)), active=0, exit=rng.choice((0, 1, 0xFF)), solved=rng.choice((0, 1, 0x7F)),
             deadline=rng.choice((0, 1000, M32, rng.getrandbits(32))),
             order=[rng.choice((-1, 0, 1, 2, 5, 15, 0x7FFF)) for _ in range(15)])
    return img, g


def seed_scenario(x, nat, run, rng):
    sc = run.sc
    x.hard_reset()
    nat.reset()
    x.install_rows(run.rows)
    x.w32(CELL_MODE, sc['mode'])
    init = sc['init']
    # event flag window: a pseudo-random pattern, the gate flags 1000.. overridden by the scenario
    pattern = bytearray(4 * EVENT_COUNT)
    for k in range(EVENT_COUNT):
        struct.pack_into('<I', pattern, 4 * k, (k * 2654435761 + 12345) & M32)
    for k in range(1000, 1008):
        struct.pack_into('<I', pattern, 4 * k, 0)
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
    start = init.get('start', rng.choice((0, 1, M32, 5)))
    x.set_cell(CELL_START, start)
    nat.set_extra([start])
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
    x.set_cell(CELL_TEXTARG, TEXT_ARG)
    x.set_cell(CELL_TARGET, TARGET_HANDLE)
    x.set_cell(CELL_ORG_X, 0)
    x.set_cell(CELL_ORG_Y, 0)
    nat.set_origin(0, 0)
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


def compare_all(where, x, nat, stats, run, rows=True):
    img_x, img_n = x.obj_image(), nat.obj()
    if img_x != img_n:
        raise Mismatch('%s: object image 0x61d345..+0x5c differs: %s' % (where, '; '.join(diff_obj(img_x, img_n))))
    stats['compared_fields'] += len(OBJ_FIELDS) + 1
    check(stats, where, 'cell 0x5bb1ca (start flag)', x.cell(CELL_START), nat.extra()[0])
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
    check(stats, where, 'text queue consumed', x.tpos, nat.tpos())
    check(stats, where, 'text queue underflow (native)', 0, nat.tunder())
    stats['queue_values_consumed'] += x.tpos
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


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(rows))]
    queues = {**DEFAULT_Q, **queues}
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    img = x.obj_image()
    if fld(img, 'active'):
        stats['states']['phase_visit_state_%d' % min(max(fld(img, 'state'), -1), 5)] += 1
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
                nat.set_extra([1])
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0xD0:
                visit_d0(where, nat, run, r, i, expected, stats)
            else:
                raise d9.OracleError('model has no arm for type %#x' % typ)
        else:
            stats['rows_gated'] += 1
        i += 1
    check(stats, where, 'ordered effect sequence (entries, visits, handler, effects, completion)', norm_events(x.events), expected)
    stats['ordered_events'] += len(x.events)
    check(stats, where, 'image names the loader was asked for', x.loaded, run.loaded_expected)
    check(stats, where, 'image names (native host)', [s.decode('latin1') for s in nat.strs(0)], run.loaded_expected)
    run.loaded_expected = []
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'tick', stats)
    compare_all(where, x, nat, stats, run)


def visit_d0(where, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, extra = native_fx(nat, run)
    if status != OK:
        raise Mismatch('%s: native d0_step status %d for row %d phase %d' % (where, status, i, phase))
    expected.append(('handler', i, phase))
    check(stats, where, 'host calls the kernel made equal the effects it observed', hosts, host_only)
    check(stats, where, 'no stray host calls in a step', extra, [])
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
        stats['outcomes']['finish_exit' if fld(pre, 'exit') else 'finish_solved' if fld(pre, 'solved') else 'finish_plain'] += 1
    run.loaded_expected += [d9.cstr(body[:0x21]).decode('latin1')] * sum(1 for e in mapped if e[1] == FX['SURFACE_LOAD'])
    if phase == 0:
        stats['slots'][fld(nat.obj(), 'slot')] += 1
    if completed:
        check(stats, where, 'native completion phase', phase_after, 0)
        r['phase'] = 0
    else:
        r['phase'] = phase_after


def refused_by_native(body, img, phase, cand):
    """The click / render states the kernel refuses (known divergence K4): they are skipped, never run against the original."""
    n = body_n(body)
    hover = fld(img, 'hover')
    return (fld(img, 'active') and fld(img, 'state') == 1 and phase == 1 and cand == CAND_KEY and not 0 <= hover < n)


def do_pointer(where, x, nat, run, stats, rng, px, py):
    img = nat.obj()
    ri = run.body_for(img)
    body = run.rows[ri]['body']
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    stats['actions']['pointer'] += 1
    xdw = (px & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= px <= 0xFFFF else px & M32
    ydw = (py & 0xFFFF) | (rng.getrandbits(16) << 16) if -0x8000 <= py <= 0xFFFF else py & M32
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, written, kind, sub = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native d0_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax & 0xFF, 1 if hit else 0)
    active = fld(img, 'active') != 0
    stats['pointer']['key' if hit and cand == CAND_KEY else 'exit' if hit else 'redraw' if fld(nat.obj(), 'dirty') and not fld(img, 'dirty') and active
                     else 'none' if active else 'inactive'] += 1
    if written:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32
        run.cells['c1639'] = 1
        if cand == CAND_EXIT:
            stats['pointer']['cursor_exit'] += 1
        else:
            stats['pointer']['cursor_kind_%s' % ('zero' if kind == 0 else 'region')] += 1
    elif hit:
        raise Mismatch('%s: native claims without writing the cursor cells' % where)
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run)


def do_click(where, x, nat, run, stats, queues):
    img = nat.obj()
    ri = run.body_for(img)
    r = run.rows[ri]
    cand, start = run.cells['cand'], nat.extra()[0]
    if refused_by_native(r['body'], img, r['phase'], cand):
        stats['skipped_native_refusal']['click: key press with hover outside 0..N-1'] += 1
        return
    queues = {**DEFAULT_Q, 'text': [b'Key text'], **queues}
    for t in queues['text']:
        if t is not None and D0_TEXT_LIMIT < len(t) <= 0x9C40:
            raise d9.OracleError('%s: scripted text of %d characters is a native refusal case' % (where, len(t)))
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    stats['actions']['click'] += 1
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method(queues, M_CLICK, [])
    (status, exit_asked, key_pressed, sound_played, text_shown, new_phase), new_body = nat.click(r['body'], r['phase'], cand, start)
    if status != OK:
        raise Mismatch('%s: native d0_click status %d' % (where, status))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'click: no stray host calls', extra, [])
    check(stats, where, 'click: ordered effects (sound, tick, text, row phase)', norm_events(x.events), mapped)
    check(stats, where, 'click: looked-up keys', x.lookups, [s for s in nat.strs(1)])
    check(stats, where, 'click: shown texts (bytes incl. the <e> suffix)', x.shown, [s for s in nat.strs(2)])
    count_effects(stats, mapped)
    stats['clicks']['exit' if exit_asked else 'key' if key_pressed else 'none'] += 1
    if sound_played:
        stats['clicks']['sound'] += 1
    if text_shown:
        stats['clicks']['text'] += 1
    if key_pressed and not text_shown:
        stats['clicks']['no_text'] += 1
    for t in queues['text'][:1]:
        if key_pressed:
            stats['texts']['null' if t is None else 'len0' if len(t) == 0 else 'over_limit_skipped' if len(t) > 0x9C40 else
                           'len199' if len(t) == 199 else 'short'] += 1
    r['body'] = new_body
    if exit_asked:
        r['phase'] = new_phase & M32
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


D0_TEXT_LIMIT = 199


def render_refused(body, img):
    n = body_n(body)
    if fld(img, 'dirty') == 0 or fld(img, 'has_surface') == 0:
        return False
    if fld(img, 'slot') == -1:
        return 'render: slot -1 with a redraw request'
    if fld(img, 'pressed') != 0 and fld(img, 'hover') != -1:
        return False if 0 <= fld(img, 'hover') < n else 'render: pressed hover outside 0..N-1'
    if fld(img, 'check') != 0 and fld(img, 'last') != -1:
        return False if 0 <= fld(img, 'last') < n else 'render: restore key outside 0..N-1'
    return False


def do_render(where, x, nat, run, stats, ox, oy):
    img = nat.obj()
    ri = run.body_for(img) if fld(img, 'active') else run.d0_rows()[0]
    row = fld(img, 'row')
    if not fld(img, 'active') and (fld(img, 'dirty') and fld(img, 'has_surface')) and not (0 <= row < len(run.rows) and run.rows[row]['type'] == 0xD0):
        stats['skipped_native_refusal']['render: stale row of an inactive object with a redraw request'] += 1
        return
    if 0 <= row < len(run.rows) and run.rows[row]['type'] == 0xD0:
        ri = row
    body = run.rows[ri]['body']
    why = render_refused(body, img)
    if why:
        stats['skipped_native_refusal'][why] += 1
        return
    stats['actions']['render'] += 1
    x.set_cell(CELL_ORG_X, ox)
    x.set_cell(CELL_ORG_Y, oy)
    nat.set_origin(sgn(ox, 4), sgn(oy, 4))
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    slot = fld(img, 'slot')
    entry_surface = x.entry_surface(slot) if 0 <= slot < NENT else None
    bg_cell = x.cell(CELL_BG)
    x.run_method({}, M_RENDER, [], 0)
    plan = nat.render(body)
    if plan['status'] != OK:
        raise Mismatch('%s: native d0_render status %d' % (where, plan['status']))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'render: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'render: ordered effects (blit, state, solved check)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    check(stats, where, 'render: blit count', len(x.blits), 1 if plan['blit'] else 0)
    check(stats, where, 'render: view origin read iff a blit', [e for e in extra if e[0] == HC_ORIGIN],
          [(HC_ORIGIN, sgn(ox, 4), sgn(oy, 4))] if plan['blit'] else [])
    if plan['blit']:
        b = x.blits[0]
        pressed = plan['blit'] == 1
        check(stats, where, 'render blit: kind (label pointer)', b['kind'], plan['blit'])
        check(stats, where, 'render blit: key', b['key'], plan['key'])
        check(stats, where, 'render blit: label string', b['label'], LABEL_PRESSED if pressed else LABEL_RESTORE)
        check(stats, where, 'render blit: this pointer', b['this'], THIS_SURF)
        check(stats, where, 'render blit: target surface', b['target'], TARGET_HANDLE)
        if pressed:
            check(stats, where, 'render blit: source surface (entry surface of the slot) versus native', b['src_surface'], plan['src_surface'])
            check(stats, where, 'render blit: source surface is the entry surface', b['src_surface'], entry_surface)
        else:
            check(stats, where, 'render blit: source surface is the background entry 1', b['src_surface'], bg_cell)
            check(stats, where, 'render blit: native background marker', plan['src_surface'], 0)
        check(stats, where, 'render blit: source rectangle contents', b['src'], tuple(plan['src']))
        check(stats, where, 'render blit: destination rectangle contents', b['dst'], tuple(plan['dst']))
        stats['blits'] += 1
        stats['renders']['pressed' if pressed else 'restore'] += 1
    else:
        stats['renders']['none'] += 1
    if plan['solved_check']:
        stats['renders']['solved_check'] += 1
    # the engine clears the redraw request after drawing: make it observable for the invalidate action
    if 0 <= slot < NENT:
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
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method({}, M_INVALIDATE, [])
    if nat.invalidate() != OK:
        raise Mismatch('%s: native d0_invalidate failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'invalidate: host calls', extra, [(HC_MARK_DIRTY, slot, 0)] if marks else [])
    check(stats, where, 'invalidate: no effects', (norm_events(x.events), mapped, hosts), ([], [], []))
    stats['actions']['invalidate_marks' if marks else 'invalidate_noop'] += 1
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_writes(where, x, 'invalidate', stats)
    compare_all(where, x, nat, stats, run)


def do_cleanup(where, x, nat, run, stats):
    img = nat.obj()
    slot = fld(img, 'slot')
    if slot != -1 and not 0 <= slot < NENT:
        stats['skipped_native_refusal']['cleanup: slot outside the entry table'] += 1
        return
    stats['actions']['cleanup'] += 1
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method({}, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native d0_cleanup failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surface, release slot)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_writes(where, x, 'cleanup', stats)
    compare_all(where, x, nat, stats, run)


def do_set(x, nat, run, d):
    img = bytearray(x.obj_image())
    for k, v in d.items():
        if k in OBJ_POS:
            put_fld(img, k, v)
        elif k in POINTER_CELLS:
            va, sz = POINTER_CELLS[k]
            x.set_cell(va, v, sz)
            run.cells[k] = v & mask(sz)
        elif k == 'start':
            x.set_cell(CELL_START, v)
            nat.set_extra([v])
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
        else:
            raise d9.OracleError('unknown set key ' + k)
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
    elif kind == 'click':
        do_click(where, x, nat, run, stats, act[1] if len(act) > 1 else {})
    elif kind == 'render':
        do_render(where, x, nat, run, stats, act[1], act[2])
    elif kind == 'invalidate':
        do_invalidate(where, x, nat, run, stats)
    elif kind == 'cleanup':
        do_cleanup(where, x, nat, run, stats)
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
    elif kind == 'play':
        macro_play(where, x, nat, run, stats, rng, act[1], act[2] if len(act) > 2 else {}, sc, ai)
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
TEXTS = (b'Hello', b'', None, b'x' * 197, b'y' * 198, b'z' * 199, bytes(range(1, 128)) + bytes(range(129, 200)), b'A<e>B', b'Ola\xe9\xff',
         b'long ' * 30, b'w' * 0x9C41)


def pick_text(rng, rare=True):
    c = rng.random()
    if c < 0.45:
        return b'Text %d' % rng.randrange(100)
    if c < 0.55:
        return None
    if c < 0.60:
        return b''
    if c < 0.65 and rare:
        return b'w' * 0x9C41
    return rng.choice(TEXTS[:10])


def ensure_mode(x, nat, run):
    if nat.cells()[0] != 3:
        do_set(x, nat, run, {'mode': 3})


def cur_body(nat, run):
    img = nat.obj()
    row = fld(img, 'row')
    if fld(img, 'active') and 0 <= row < len(run.rows):
        return run.rows[row]['body']
    return run.rows[run.d0_rows()[0]]['body']


def advance(run, rng):
    run.clock = (run.clock + rng.choice((1, 10, 100, 499, 500, 501, 1000, 5000))) & M32
    return run.clock


def macro_play(where, x, nat, run, stats, rng, key, opts, sc, ai):
    """pointer onto the key, click, render (pressed blit), tick past the release deadline, render (restore blit and solved check)."""
    body = cur_body(nat, run)
    if not 0 <= key < body_n(body):
        return
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    cx, cy = center_of(hit_rect(body, key))
    sub(1, ('pointer', cx, cy))
    q = dict(tick=[advance(run, rng)] * 4, busy=[opts.get('busy', rng.choice((0, 0, 0, 1, 2, M32, 0x100, 0x10000)))] * 2,
             text=[opts.get('text', pick_text(rng, rare=False))])
    sub(2, ('click', q))
    if rng.random() < 0.9:
        sub(3, ('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))))
    img = nat.obj()
    if rng.random() < 0.9:
        ensure_mode(x, nat, run)
        t = (fld(img, 'deadline') + rng.choice((-1, 0, 0, 1, 10, 600))) & M32 if fld(img, 'state') == 0 and rng.random() < 0.7 else advance(run, rng)
        sub(4, ('tick', dict(tick=[t] * 4, busy=[rng.choice((0, 1))] * 2)))
    if rng.random() < 0.9:
        sub(5, ('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))))


def macro_finish(where, x, nat, run, stats, rng, max_steps, sc, ai):
    """tick through the win states (2, 3, 4) steering by the deadline and the busy answers until the puzzle finished."""
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    for k in range(max_steps):
        img = nat.obj()
        if not fld(img, 'active'):
            break
        ensure_mode(x, nat, run)
        state = fld(img, 'state')
        if state in (0, 3):
            t = (fld(img, 'deadline') + rng.choice((-1, 0, 0, 1, 7))) & M32
        else:
            t = advance(run, rng)
        busy = [rng.choice((0, 1, 1, 2, M32, 0x100, 0x10000))] * 2 if state == 4 else [0] * 2
        sub(k + 1, ('tick', dict(tick=[t] * 4, busy=busy)))
        if rng.random() < 0.3:
            sub(k + 1, ('render', 0, 0))


def bot(x, nat, run, stats, rng, sc, ai, steps, profile):
    d0 = run.d0_rows()
    plan = []
    body0 = run.rows[d0[0]]['body']
    if profile in ('play', 'win') and body_n(body0) > 0 and all(0 <= v < body_n(body0) for v in body_sol(body0)):
        plan = [rng.randrange(body_n(body0)) for _ in range(rng.choice((0, 1, 3)))] + body_sol(body0)
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    weights = {'play': (('macro', 6), ('tick', 3), ('pointer_key', 3), ('pointer_exit', 0.5), ('pointer_rand', 1.5), ('pointer_keyrect', 1),
                        ('click', 4), ('render', 3), ('invalidate', 0.4), ('cleanup', 0.15), ('finish', 1.0), ('set', 0.3)),
               'win': (('macro', 8), ('tick', 1), ('pointer_key', 1), ('click', 1), ('render', 2), ('finish', 3), ('pointer_exit', 0.1)),
               'chaos': (('macro', 2), ('tick', 3), ('pointer_key', 3), ('pointer_exit', 1.5), ('pointer_rand', 2.5), ('pointer_keyrect', 1.5),
                         ('click', 5), ('render', 3), ('invalidate', 1), ('cleanup', 0.3), ('finish', 1), ('set', 2.5), ('body', 1))}[profile]
    names = [w[0] for w in weights]
    wts = [w[1] for w in weights]
    for k in range(steps):
        img = nat.obj()
        body = cur_body(nat, run)
        n = body_n(body)
        choice = rng.choices(names, wts)[0]
        if choice == 'macro':
            key = plan.pop(0) if plan and rng.random() < 0.92 else (rng.randrange(n) if n else 0)
            sub(k, ('play', key))
        elif choice == 'tick':
            ensure_mode(x, nat, run)
            dl = fld(img, 'deadline')
            t = (dl + rng.choice((-1, 0, 1, 500, 1000))) & M32 if rng.random() < 0.5 else advance(run, rng)
            sub(k, ('tick', dict(tick=[t] * 4, busy=[rng.choice((0, 1, 2, M32))] * 2, handle=[rng.choice((0x4441, 0, 1, 0xFFFFFFFF))] * 2)))
        elif choice == 'pointer_key' and n:
            key = plan[0] if plan and rng.random() < 0.8 else rng.randrange(n)
            rect = hit_rect(body, key)
            px, py = rng.choice((center_of(rect), (clamp16(rect[0]), clamp16(rect[1])), (clamp16(rect[2]), clamp16(rect[3])),
                                 (clamp16(rect[0] - 1), clamp16(rect[1])), (clamp16(rect[2] + 1), clamp16(rect[3]))))
            sub(k, ('pointer', px, py))
        elif choice == 'pointer_exit':
            px, py = rng.choice((center_of(exit_rect_of(body)), (clamp16(exit_rect_of(body)[0]), clamp16(exit_rect_of(body)[1]))))
            sub(k, ('pointer', px, py))
        elif choice == 'pointer_rand':
            sub(k, ('pointer', rng.randint(-40, 300), rng.randint(-40, 200)))
        elif choice == 'pointer_keyrect' and n:
            kr = key_rect(body, rng.randrange(n))
            sub(k, ('pointer', center_of(kr)[0], center_of(kr)[1]))
        elif choice == 'click':
            sub(k, ('click', dict(tick=[advance(run, rng)] * 4, busy=[rng.choice((0, 0, 1, 2, M32, 0x100, 0x80000000))] * 2, text=[pick_text(rng)])))
        elif choice == 'render':
            sub(k, ('render', rng.choice((0, 0, 5, -7, 0x7FFFFFF0, -0x80000000)), rng.choice((0, 0, 3, -1, 0x7FFFFFFF))))
        elif choice == 'invalidate':
            sub(k, ('invalidate',))
        elif choice == 'cleanup':
            sub(k, ('cleanup',))
            sub(k, ('rearm',))
        elif choice == 'finish':
            macro_finish('', x, nat, run, stats, rng, rng.choice((3, 6, 10)), sc, ai)
        elif choice == 'set':
            d = rng.choice(({'state': rng.choice((0, 1, 2, 3, 4, 5, M32))}, {'start': rng.choice((0, 1, 5, M32))},
                            {'pressed': rng.choice((0, 1)), 'hover': rng.randrange(max(n, 1)) if n else -1},
                            {'check': rng.choice((0, 1)), 'last': rng.randrange(max(n, 1)) if n else -1},
                            {'dirty': rng.choice((0, 1))}, {'cand': rng.choice((0, CAND_KEY, CAND_EXIT, 0x2764, 0xFFFF))},
                            {'deadline': (run.clock + rng.choice((-1, 0, 1, 1000))) & M32},
                            {'order': [rng.choice((-1, 0, 1, 2, max(n - 1, 0))) for _ in range(15)]},
                            {'busy': {0x18 + rng.randrange(0x28): rng.choice((0, 1))}}, {'entry_dirty': {rng.randrange(0x18, 0x40): rng.choice((0, 1))}}))
            if 'hover' in d and 'pressed' in d and d['pressed'] == 0:
                d['hover'] = rng.choice((-1, d['hover']))
            sub(k, ('set', d))
        elif choice == 'body' and d0:
            ri = fld(img, 'row') if fld(img, 'active') and fld(img, 'row') in d0 else d0[0]
            kind = rng.choice(('sol', 'exit', 'delay', 'win_sound', 'solved_block'))
            if kind == 'sol':
                lv = body_l(run.rows[ri]['body'])
                tail = [rng.randrange(max(body_n(run.rows[ri]['body']), 1)) for _ in range(lv)]
                sub(k, ('body', ri, {0x319: struct.pack('<%dh' % lv, *tail)}))
            elif kind == 'exit':
                sub(k, ('body', ri, {0x7AB: struct.pack('<4i', *rng.choice(((200, 10, 260, 40), (0, 0, 400, 400), (8, 10, 39, 41), (5, 5, 4, 4))))}))
            elif kind == 'delay':
                sub(k, ('body', ri, {0x75F: struct.pack('<h', rng.choice((0, 1, 2, -2, 32767, -32768)))}))
            elif kind == 'win_sound':
                sub(k, ('body', ri, {0x761: snd(rng.choice(('none', 'real', 'near1', 'near2', 'zero'))), 0x782: struct.pack('<h', rng.choice((0, 2, -3)))}))
            else:
                sub(k, ('body', ri, {0x746: struct.pack('<h', rng.choice((9999, 42, -5, 0x2710))), 0x75A: struct.pack('<h', rng.choice((0, 1, 2, -1)))}))


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
HANDLES = [0x4441, 0, M32, 1, 0x7FFFFFFF]
NAMES_POOL = [b'PUZZLE1', b'A', b'x' * 32, b'Piano Surface']


def R_D0(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xD0, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def hit_points(body, extra_edges=True):
    pts = []
    n = body_n(body)
    for i in range(n):
        l_, t_, r_, b_ = hit_rect(body, i)
        pts += [center_of((l_, t_, r_, b_)), (clamp16(l_), clamp16(t_)), (clamp16(r_), clamp16(b_)), (clamp16(l_ - 1), clamp16(t_)),
                (clamp16(l_), clamp16(t_ - 1)), (clamp16(r_ + 1), clamp16(b_)), (clamp16(r_), clamp16(b_ + 1)), (clamp16(r_), clamp16(t_)),
                (clamp16(l_), clamp16(b_))]
    ex = exit_rect_of(body)
    pts += [center_of(ex), (clamp16(ex[0]), clamp16(ex[1])), (clamp16(ex[2]), clamp16(ex[3])), (clamp16(ex[0] - 1), clamp16(ex[1])),
            (clamp16(ex[0]), clamp16(ex[1] - 1)), (clamp16(ex[2] + 1), clamp16(ex[3])), (clamp16(ex[2]), clamp16(ex[3] + 1))]
    return pts


def scenario_list(seed=0xD050):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        return make_body(rng, **kw)

    # ---- phase 0: key counts, solution lengths, names (empty = no surface), handles, busy seeds ----------------------------
    seeds_variants = [[], [0x18], [0x18, 0x19, 0x1A], [0x18, 0x1A, 0x1B, 0x3E], list(range(0x18, 0x3F)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]]
    for k, (n, l) in enumerate(((0, 1), (1, 1), (5, 3), (15, 15), (15, 1), (1, 15), (5, 8), (5, 9), (3, 2), (15, 14))):
        for j in range(4):
            name = NAMES_POOL[(k + j) % 4] if (k + j) % 5 else b''
            busy = seeds_variants[(k * 4 + j) % len(seeds_variants)]
            body = mk(n=n, l=l, name=name, snd_c=rng.choice(('none', 'real', 'near1')))
            S('init:n%d_l%d_%s_%d' % (n, l, 'nosurf' if not name else 'surf', j), [R_D0(body)],
              [tk(handle=[HANDLES[(k + j) % 5]]), tk(), ('cleanup',), ('rearm',), tk(handle=[HANDLES[(k + j + 1) % 5]]), tk()], 'init',
              init=dict(busy_slots=busy, obj=dict(surface=rng.choice((0, 0x5151)), slot=rng.choice((-1, 0x19, 0x30)))),
              quick=(k, j) in ((2, 0), (0, 1), (3, 2), (6, 3)))
    S('init:stale_state_released', [R_D0(mk(n=3, l=2))], [tk(), ('cleanup',)], 'init',
      init=dict(obj=dict(surface=0x7777, slot=0x30, active=1, row=0, exit=1, solved=1, state=3)), quick=True)
    S('init:stale_slot_no_surface_released', [R_D0(mk(n=3, l=2, name=b''))], [tk(), ('set', dict(state=1)), tk(), ('cleanup',)], 'init',
      init=dict(obj=dict(slot=0x2A, surface=0, active=0)), quick=True)
    S('init:order_garbage_survives', [R_D0(mk(n=5, l=15, name=b'', sol=[0] * 15))], [tk(), tk(), tk()], 'init',
      init=dict(obj=dict(order=[0x7F7F, 1, 2, 3, 4, 5, 6, 0x7FFF, 0x1234, 8, 9, 10, 11, 12, 13])))
    S('init:slot_exhaustion_but_last', [R_D0(mk(n=3, l=2))], [tk(), tk(), ('cleanup',)], 'init', init=dict(busy_slots=list(range(0x18, 0x3F))), quick=True)

    # ---- the five states and the values above 4 ----------------------------------------------------------------------------
    for case in range(48):
        n = rng.choice((1, 5, 15))
        l = rng.choice((1, 2, n))
        delay = rng.choice((0, 1, 3, -2, 32767, -32768, 7))
        t0 = rng.choice((0, 1000, 0xFFFFFC17, 0x7FFFFFFF, M32, 123456))
        dl = (t0 + delay * 1000) & M32
        ts = [(dl - 1) & M32, dl, (dl + 1) & M32, (dl + 0x80000000) & M32, (dl - 0x80000000) & M32, 0, M32]
        snd_w = rng.choice(('none', 'real', 'real2', 'near1', 'none', 'near2', 'zero', 'near3'))
        win_ch = rng.choice((2, 0, -3, 32767, 0x4001))
        name = rng.choice((b'PUZZLE1', b'', b'PUZZLE1'))
        solved = rng.choice((block(9999, (1, 2, 3), (4, 5, 6), 1), rand_block(rng, 42), rand_block(rng, -5), rand_block(rng, 0x8000 - 0x10000),
                             rand_block(rng, 0x2710), rand_block(rng, 0xA70F - 0x10000), rand_block(rng, 1), rand_block(rng, 0), block(9999)))
        ev = rng.choice(((-1, 7), (0, 7), (100, 0), (4095, 255), (1003, 300), (2047, 1)))
        body = mk(n=n, l=l, name=name, snd_w=snd_w, win_ch=win_ch, solved=solved, ev=ev, delay=delay)
        sol = body_sol(body)
        order = sol + [rng.choice((0, 1)) for _ in range(15 - l)]
        sub = rng.choice((1, 1, 2, 0, 3))
        acts = [tk(), ('set', dict(order=order)),                      # init, then a solved sequence
                tk(tick=[t0] * 2),                                      # state 1 (solved check at has_surface == 0), state 2 start
                tk(tick=[t0] * 2), tk(tick=[ts[0]] * 2), tk(tick=[ts[rng.randrange(1, 4)]] * 2), tk(tick=[ts[rng.randrange(4, 7)]] * 2),
                tk(busy=[1]), tk(busy=[2]), tk(busy=[M32]), tk(busy=[0]), tk(), tk()]
        S('states:%d_n%d_l%d_snd%s_d%d_sub%d_%s' % (case, n, l, snd_w, delay, sub, 'nosurf' if not name else 'surf'),
          [R_D0(body, subtype=sub)], acts, 'states', quick=case in (0, 1, 2, 3, 4, 5))
    for state in (0, 1, 2, 3, 4, 5, 6, M32, 0x80000000):
        for sub in (1, 2):
            body = mk(n=4, l=2, snd_w='real', delay=2, solved=rand_block(rng, 12))
            acts = [tk(), ('set', dict(state=state, deadline=5000, order=body_sol(body) + [0] * 13)), tk(tick=[4999] * 2, busy=[0]), tk(tick=[5000] * 2, busy=[1]),
                    tk(tick=[5001] * 2, busy=[0]), tk(tick=[9000] * 2, busy=[0]), tk(tick=[20000] * 2, busy=[0]), tk(tick=[30000] * 2, busy=[0]), tk(), tk()]
            S('state_forced:%#x_sub%d' % (state, sub), [R_D0(body, subtype=sub)], acts, 'states', quick=(state, sub) in ((0, 1), (3, 2), (4, 1)))
    # has_surface == 0: the solved check runs on every state-1 pass; solutions of zeros solve immediately, others never
    for case in range(10):
        n = rng.choice((1, 3, 6))
        l = rng.choice((1, 2, 5, 9, 15))
        sol = rng.choice(([0] * l, [rng.randrange(n) for _ in range(l)]))
        body = mk(n=n, l=l, name=b'', sol=sol, snd_w=rng.choice(('none', 'real')), solved=rand_block(rng, 21 + case) if case % 2 else block(9999),
                  delay=rng.choice((0, 1)))
        order = [rng.choice((0, 1, 2, -1)) for _ in range(15)]
        S('nosurface:%d_n%d_l%d' % (case, n, l), [R_D0(body, subtype=1 + case % 2)],
          [tk(), tk(), ('set', dict(order=order)), tk(), ('set', dict(order=(sol + [0] * 15)[:15])), tk(), tk(), 'finish_marker'][:-1] + [('finish', 12)], 'states',
          quick=case in (0, 1))

    # ---- phase 2 exit path -----------------------------------------------------------------------------------------------------
    for case in range(36):
        n = rng.choice((0, 1, 5, 15))
        blk = rng.choice((block(9999, (7, 8, 9), (1, 2, 3), 1), rand_block(rng, 17), rand_block(rng, -1), rand_block(rng, 0x270E), rand_block(rng, 0x2710),
                          rand_block(rng, 0xA70F - 0x10000), rand_block(rng, 3)))
        flag = rng.choice(((-1, 0), (5, 9), (4095, 255), (0, 1), (1003, 1), (700, 300)))
        body = mk(n=n, l=rng.choice((1, 2, max(n, 1))), name=rng.choice((b'PUZZLE1', b'PUZZLE1', b'')), exit_blk=dict(blk, start=rng.choice((1, 0, 2, -1))),
                  exit_flag=flag, solved=rand_block(rng, 55), layout=rng.choice(('grid', 'grid', 'overlap')),
                  exit_rect=rng.choice(((200, 10, 260, 40), (8, 10, 39, 41), (0, 0, 400, 400))))
        ex = center_of(exit_rect_of(body))
        acts = [tk(), ('pointer', ex[0], ex[1]), ('click',), tk(), tk(), ('set', dict(mode=3)), tk()]
        if case % 3 == 0:
            acts = [tk(), ('pointer', 0, 0), ('pointer', ex[0], ex[1]), ('click',), ('click',), tk(), ('pointer', ex[0], ex[1]), ('click',), tk()]
        S('exit_path:%d_n%d_flag%d' % (case, n, flag[0]), [R_D0(body, subtype=rng.choice((1, 1, 2)))], acts, 'exit_path', quick=case in (0, 1, 2, 3))

    # ---- pointer sweeps (inclusive edges, regions A / B, exit over keys, pressed key rectangles) --------------------------------
    for layout, hit in (('grid', 'same'), ('grid', 'grow'), ('grid', 'shrink'), ('overlap', 'same'), ('neg', 'same'), ('extreme', 'same')):
        for n in (0, 1, 5, 15):
            for regions in ('auto', 'edge', 'off1'):
                body = mk(n=n, l=min(max(n, 1), 2), layout=layout, hit=hit, regions=regions,
                          exit_rect=rng.choice(((200, 10, 260, 40), (-100, -100, -50, -80), (0, 0, 0, 0), (60, 60, 90, 90), (-0x80000000, -5, 0x7FFFFFFF, 5))))
                probes = hit_points(body) + [(rng.randint(-120, 280), rng.randint(-120, 200)) for _ in range(12)] + \
                         [(0x7FFFFFFF, 0x7FFFFFFF), (-0x80000000, -0x80000000), (0x8000, 0x8000), (0xFFFF, 0xFFFF), (-0x8000, 0x7FFF)]
                for active in (1, 0):
                    acts = [tk(), ('set', dict(active=active, row=0, k0=rng.choice((0, 3, 9)), k1=rng.choice((0, 1))))]
                    acts += [('pointer', px, py) for px, py in probes]
                    if active and n:                    # while a key is pressed: the exit is skipped, the key rectangles redraw the pressed key
                        acts.append(('set', dict(pressed=1, hover=rng.randrange(n), dirty=0)))
                        acts += [('pointer', px, py) for px, py in probes]
                    S('pointer:%s_%s_n%d_%s_a%d' % (layout, hit, n, regions, active), [R_D0(body)], acts, 'pointer',
                      quick=(layout, hit, n, regions, active) in (('grid', 'same', 5, 'auto', 1), ('overlap', 'same', 5, 'edge', 1), ('neg', 'same', 1, 'auto', 1),
                                                                   ('grid', 'shrink', 5, 'off1', 1), ('grid', 'same', 5, 'auto', 0)))
    for n in (1, 5, 15):               # the exit rectangle on top of a key: the exit wins unless a key is pressed
        body = mk(n=n, l=1, exit_rect=(8, 10, 39, 41))
        ex = center_of(exit_rect_of(body))
        S('pointer:exit_over_key_n%d' % n, [R_D0(body)], [tk(), ('pointer', ex[0], ex[1]), ('pointer', 8, 10), ('pointer', 39, 41), ('pointer', 40, 41),
                                                           ('set', dict(pressed=1, hover=0, dirty=0)), ('pointer', 8, 10), ('pointer', 39, 41), ('click',)], 'pointer', quick=n == 5)

    # ---- clicks: key names, texts, start flag, busy answers, candidates ------------------------------------------------------------
    text_cases = [None, b'', b'a', b'ab', b'x' * 100, b'y' * 196, b'z' * 197, b'q' * 198, b'r' * 199, bytes(range(1, 255)) * 0 + bytes(range(1, 200)), b'A<e>B',
                  b'w' * 0x9C41, b'tail\xff\x80', b'\x01' * 199]
    for ti, text in enumerate(text_cases):
        for variant in range(2):
            n = 4
            body = mk(n=n, l=2, key_sounds=[rng.choice(KEY_SOUND_NAMES) for _ in range(4)])
            cs = [center_of(hit_rect(body, i)) for i in range(n)]
            acts = [tk(), ('pointer', *cs[1]), ('click', dict(text=[text])), ('pointer', *cs[2]), ('click', dict(text=[text], busy=[variant])),
                    ('set', dict(start=0)), ('pointer', *cs[3]), ('click', dict(text=[text])), ('render', 0, 0)]
            S('click_text:%d_v%d' % (ti, variant), [R_D0(body)], acts, 'click', init=dict(start=1), quick=(ti, variant) in ((0, 0), (1, 1), (8, 0), (11, 0), (10, 1)))
    for name in KEY_SOUND_NAMES:
        for start in (1, 0, 7):
            for busy in (0, 1, 0x100, M32):
                n = 3
                body = mk(n=n, l=3, key_sounds=[name, name, name], snd_c=rng.choice(('none', 'real', 'near1', 'zero')), click_ch=rng.choice((1, 0, -4, 32767, 0x4000)))
                cs = [center_of(hit_rect(body, i)) for i in range(n)]
                acts = [tk(), ('set', dict(start=start))]
                for i in (0, 1, 2, 1):
                    acts += [('pointer', *cs[i]), ('click', dict(busy=[busy] * 2, text=[b'T%d' % i])), ('render', 0, 0), tk(tick=[1000 + 600 * i] * 3, busy=[busy])]
                S('click_sound:%s_start%d_busy%d' % (name, start, busy), [R_D0(body)], acts, 'click', quick=(name, start, busy) in (('real', 1, 0), ('none', 1, 0), ('near1', 7, 0), ('empty', 1, 1), ('real', 1, 0x100), ('real', 1, M32)))
    for case in range(8):
        body = mk(n=3, l=2, snd_c='real')
        cs = [center_of(hit_rect(body, i)) for i in range(3)]
        acts = [tk()]
        for other in (0, 0x2764, 0x2767, 0xFFFF, CAND_KEY ^ 0x100, CAND_EXIT ^ 0x100):         # candidates the click ignores
            acts += [('set', dict(cand=other, hover=1, active=1, row=0)), ('click',)]
        acts += [('set', dict(cand=CAND_EXIT, state=1)), ('click',)]
        if case % 2:
            acts = [('set', dict(active=0, row=0, cand=CAND_KEY, hover=1)), ('click',), ('set', dict(cand=CAND_EXIT)), ('click',)] + acts
        S('click_candidates:%d' % case, [R_D0(body)], acts, 'click', quick=case == 0)
    for state in (0, 2, 3, 4, 5):                      # the click does nothing unless the state is 1 and the row phase is 1
        body = mk(n=3, l=2, snd_c='real')
        cs = [center_of(hit_rect(body, i)) for i in range(3)]
        S('click_gate:state%d' % state, [R_D0(body)], [tk(), ('pointer', *cs[1]), ('set', dict(state=state)), ('click',), ('set', dict(state=1)),
                                                      ('setphase', 0, 2), ('click',), ('setphase', 0, 1), ('click',)], 'click', quick=state == 0)

    # ---- render: forced states, origins, background handle -------------------------------------------------------------------------
    for case in range(60):
        n = rng.choice((1, 2, 5, 15))
        body = mk(n=n, l=min(n, 2), layout=rng.choice(('grid', 'neg', 'overlap')), key_sounds=['none'] * 3)
        h = rng.randrange(n)
        la = rng.randrange(n)
        org = rng.choice(((0, 0), (100, -50), (-300, 77), (0x7FFFFFF0, 0x7FFFFFFF), (-0x80000000, -0x80000000), (5, 6)))
        st = dict(dirty=rng.choice((1, 1, 0, 0xFE)), check=rng.choice((0, 1, 1, 0x80)), pressed=rng.choice((0, 1, 1, 3)), hover=rng.choice((h, h, -1)),
                  last=rng.choice((la, la, -1)), state=rng.choice((0, 1, 2)), has_surface=rng.choice((1, 1, 0x100)), order=[rng.choice((0, 1)) for _ in range(15)])
        acts = [tk(), ('set', st), ('render', org[0], org[1]), ('set', dict(st, dirty=1)), ('render', 0, 0), ('set', dict(dirty=1, pressed=0, check=1)), ('render', org[1], org[0]),
                ('set', dict(dirty=1, pressed=0, check=0)), ('render', 1, 1), ('set', dict(bg=rng.choice((0x1111, 0, M32)), dirty=1, check=1, pressed=0)), ('render', 2, 2)]
        S('render:%d_n%d' % (case, n), [R_D0(body)], acts, 'render', quick=case in (0, 1, 2, 3))
    for case in range(6):          # no surface: the render does nothing even when redraw is requested
        body = mk(n=3, l=1, name=b'')
        S('render:nosurface_%d' % case, [R_D0(body)], [tk(), ('set', dict(dirty=1, pressed=1, hover=1, check=1, last=0)), ('render', 0, 0), ('render', 3, 3)], 'render', quick=case == 0)

    # ---- invalidate / cleanup on every kind of state ------------------------------------------------------------------------------
    for case in range(16):
        body = mk(n=3, l=1, name=rng.choice((b'PUZZLE1', b'')))
        st = rng.choice((dict(active=0), dict(active=1, slot=-1), dict(active=1, slot=0x18), dict(active=1, slot=0x3F), dict(active=0, slot=0x20), dict(active=1, slot=0)))
        acts = [('set', dict(st, row=0)), ('invalidate',), tk(), ('invalidate',), ('cleanup',), ('invalidate',), ('rearm',), tk(), ('invalidate',), ('cleanup',), ('cleanup',)]
        S('invalidate:%d' % case, [R_D0(body)], acts, 'invalidate', init=dict(busy_slots=[0x18, 0x19]), quick=case in (0, 1, 2))
    for surface in (0, 0x4242):
        for slot in (-1, 0x1F, 0):
            body = mk(n=2, l=1)
            S('cleanup:surface%#x_slot%d' % (surface, slot), [R_D0(body)], [('set', dict(surface=surface, slot=slot, active=1, row=0, exit=1, solved=1)), ('cleanup',), ('cleanup',)],
              'invalidate', quick=(surface, slot) in ((0x4242, 0x1F),))

    # ---- dependency tails, neighbours, passes stopped by the mode -------------------------------------------------------------------
    for case in range(10):
        body = mk(n=5, l=2, snd_c='real')
        tail = event_tail(1003, 1)
        sol = body_sol(body)
        acts = [tk(), ('events', {1003: 1}), tk(), ('set', dict(order=sol + [0] * 13)), tk(), tk(tick=[1000] * 3), tk(tick=[9000] * 3), tk(), tk()]
        rows = [R67(), R_D0(body, tail=tail), R67(loaded=3)] if case % 2 else [R_D0(body, tail=tail), R67()]
        S('dep:%d' % case, rows, acts, 'dep', events={1003: 0 if case < 8 else 1}, quick=case in (0, 1))
    for case in range(8):          # a first puzzle's finish opens the second one through the event flag
        solved = rand_block(rng, 21 + case) if case % 2 == 0 else block(9999)
        b0 = mk(n=3, l=1, name=rng.choice((b'', b'PUZ')), solved=solved, exit_blk=rand_block(rng, 9) if case % 2 else block(9999), exit_flag=(1003, 1), ev=(1003, 1))
        b1 = mk(n=4, l=2, snd_c='real')
        ex = center_of(exit_rect_of(b0))
        S('chain:%d' % case, [R_D0(b0), R_D0(b1, tail=event_tail(1003, 1)), R67()],
          [tk(), ('pointer', ex[0], ex[1]), ('click',), tk(), ('set', dict(mode=3)), tk(), tk(), ('set', dict(mode=3)), tk(), ('pointer', 0, 0), ('render', 0, 0), tk()],
          'dep', events={1003: 0}, quick=case == 0)
    for case in range(6):
        body = mk(n=2, l=1, name=b'', solved=rand_block(rng, 30))
        S('mode:%d' % case, [R67(), R_D0(body, subtype=1 + case % 2), R67(), R_D0(mk(n=2, l=1), subtype=1, completed=1)],
          [tk(), ('set', dict(order=body_sol(body) + [0] * 14)), tk(), tk(), tk(), ('set', dict(mode=3)), tk(), tk(tick=[1, 2]), tk()], 'mode', quick=case == 0)
    for ph in (3, 4, 9, M32):
        body = mk(n=3, l=1)
        S('phase_other:%#x' % ph, [R_D0(body, phase=ph)], [tk(), tk()], 'phase_other', quick=ph == 3)
    for case in range(3):
        body = mk(n=3, l=1)
        S('rows_skipped:%d' % case, [R_D0(body, completed=1), R_D0(body, unloaded=1), R_D0(body, loaded=5)], [tk(), tk()], 'phase_other')

    # ---- state 4 with busy answers that are nonzero but zero in the low byte / negative -------------------------------------------------
    for b_ans in (0x100, 0x10000, 2, M32, 1, 0x80000000, 0xFF):
        body = mk(n=3, l=1, snd_w='real', win_ch=rng.choice((2, 0, -3)), solved=rand_block(rng, 12))
        S('state4_busy:%#x' % b_ans, [R_D0(body)], [tk(), ('set', dict(state=4)), tk(busy=[b_ans]), tk(busy=[b_ans]), tk(busy=[0]), tk()], 'states',
          quick=b_ans == 0x100)
    # ---- solution words with the sign bit (signed word compare of 0x48d89e) -------------------------------------------------------------
    for case, sol in enumerate(([-1], [0x7FFF, -1, -0x8000, 0x1234], [-1] * 15, [0xFF, 0x1FF, -256, 255, 0x7F], [-0x8000, 0x7FFF])):
        l = len(sol)
        body = mk(n=3, l=l, name=b'', sol=sol, solved=rand_block(rng, 14))
        wrong = [(w + 1) for w in sol]
        S('solved_sign:%d' % case, [R_D0(body)], [tk(), ('set', dict(order=wrong + [0] * (15 - l))), tk(), ('set', dict(order=(sol + [0] * 15)[:15])), tk(), ('finish', 8)],
          'states', quick=case in (0, 1))
        bs = mk(n=3, l=l, sol=sol, snd_w='none')       # with a surface: the check runs from the render restore blit
        S('solved_sign_render:%d' % case, [R_D0(bs)], [tk(), ('set', dict(order=(sol + [0] * 15)[:15], dirty=1, check=1, last=1, pressed=0)), ('render', 0, 0), tk(), tk()],
          'states', quick=case == 1)
    # ---- both finish flags set: the exit block wins (0x48da.. tests +0x37 first) ----------------------------------------------------------
    for case in range(4):
        body = mk(n=3, l=1, exit_blk=rand_block(rng, 17 + case), exit_flag=(40 + case, 5), solved=rand_block(rng, 60 + case), ev=(50 + case, 6))
        S('both_flags:%d' % case, [R_D0(body, subtype=1 + case % 2)], [tk(), ('set', dict(exit=1, solved=1)), ('setphase', 0, 2), tk()] if case < 2 else
          [tk(), ('set', dict(exit=0, solved=1)), ('setphase', 0, 2), tk()], 'exit_path', quick=case in (0, 2))
    # ---- clicks on an inactive object that is otherwise ready ----------------------------------------------------------------------------
    for case in range(4):
        body = mk(n=3, l=2, snd_c='real')
        S('click_inactive:%d' % case, [R_D0(body)], [tk(), ('set', dict(active=0, state=1, hover=1, cand=CAND_KEY, pressed=0)), ('click',),
                                                  ('set', dict(cand=CAND_EXIT)), ('click',), ('set', dict(active=1)), ('click',)], 'click', quick=case == 0)

    # ---- guided play and random play --------------------------------------------------------------------------------------------------
    for case in range(60):
        n = rng.choice((1, 2, 3, 5, 8, 15))
        l = rng.choice((1, 2, 3, n))
        body = mk(n=n, l=l, name=rng.choice((b'PUZZLE1', b'PUZZLE1', b'PUZZLE1', b'')), layout=rng.choice(('grid', 'grid', 'overlap', 'grid')), hit=rng.choice(('same', 'grow', 'shrink')),
                  snd_c=rng.choice(('none', 'real', 'near1')), snd_w=rng.choice(('none', 'real', 'near2')), solved=rng.choice((block(9999), rand_block(rng, 12), rand_block(rng, -2))),
                  exit_blk=rng.choice((block(9999), rand_block(rng, 77))), ev=rng.choice(((-1, 0), (3, 4), (1003, 1))), exit_flag=rng.choice(((-1, 0), (9, 9))),
                  delay=rng.choice((0, 1, 2)), click_ch=rng.choice((0, 1, 9)), win_ch=rng.choice((0, 3)))
        S('win:%d_n%d_l%d' % (case, n, l), [R_D0(body, subtype=rng.choice((1, 1, 2)))], [tk(handle=[HANDLES[case % 5]]), ('bot', 40, 'win')], 'bot', init=dict(start=rng.choice((1, 1, 0))), quick=case < 4)
    for case in range(120):
        n = rng.choice((1, 2, 3, 5, 8, 15))
        l = rng.choice((1, 2, 3, n))
        body = mk(n=n, l=l, name=rng.choice((b'PUZZLE1', b'PUZZLE1', b'PUZZLE1', b'')), layout=rng.choice(('grid', 'grid', 'overlap', 'neg')), hit=rng.choice(('same', 'grow', 'shrink')),
                  snd_c=rng.choice(('none', 'real', 'near1')), snd_w=rng.choice(('none', 'real', 'near2')), solved=rng.choice((block(9999), rand_block(rng, 12), rand_block(rng, -2))),
                  exit_blk=rng.choice((block(9999), rand_block(rng, 77))), ev=rng.choice(((-1, 0), (3, 4), (1003, 1))), exit_flag=rng.choice(((-1, 0), (9, 9))),
                  delay=rng.choice((0, 1, 2)), click_ch=rng.choice((0, 1, 9)), win_ch=rng.choice((0, 3)))
        rows = [R_D0(body, subtype=rng.choice((1, 1, 2, 0, 3)))]
        if case % 4 == 0:
            rows = [R67()] + rows + [R67(loaded=3)]
        S('random:%d_n%d_l%d' % (case, n, l), rows, [tk(handle=[HANDLES[case % 5]]), ('bot', 60, rng.choice(('play', 'chaos', 'chaos')))], 'bot',
          init=dict(start=rng.choice((1, 1, 0, 5))), quick=case < 4)
    return scs


# ---------------------------------------------------------------------------------------------
# native-only checks (the safety layer; not comparable with the original)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.obj(), nat.extra(), nat.cells()[:8], nat.events(), nat.entries(), nat.log(0), nat.log(1))


def refusal_checks(nat, stats):
    rng = random.Random(0xD001)
    base = make_body(rng, n=5, l=3, snd_c='real', snd_w='real', ev=(5, 9), exit_flag=(6, 1), solved=rand_block(rng, 12), exit_blk=rand_block(rng, 13),
                     key_texts=[b'T0', b'T1'])

    clean = bytearray(base)
    for k in range(15):                       # records of the keys >= N are random garbage in the generator: terminate all of them
        clean[0x337 + 0x42 * k + 0x20] = 0
        clean[0x337 + 0x42 * k + 0x41] = 0
    base = bytes(clean)

    def fresh(**state):
        nat.reset()
        nat.set_queues(DEFAULT_Q)
        nat.clear_logs()
        img = bytearray(0x5C)
        put_fld(img, 'slot', -1)
        put_fld(img, 'row', -1)
        put_fld(img, 'order', [-1] * 15)
        for k, v in state.items():
            put_fld(img, k, v)
        nat.set_obj(bytes(img))
        nat.set_cells([3, 0, 0, 0, 0, 0, 0, 0])
        nat.set_origin(1, 2)

    def expect(what, got, want):
        stats['native_refusal_checks'] += 1
        stats['compared_fields'] += 1
        if got != want:
            raise Mismatch('refusal %s: got %r want %r' % (what, got, want))

    def patch(off, data, body=base):
        b = bytearray(body)
        b[off:off + len(data)] = data
        return bytes(b)

    # K1: bodies
    bad = {'short': base[:-1], 'long': base + b'\0', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:],
           'N=16': patch(0x21, struct.pack('<h', 16)), 'N=-1': patch(0x21, struct.pack('<h', -1)), 'L=0': patch(0x317, struct.pack('<h', 0)),
           'L=16': patch(0x317, struct.pack('<h', 16)), 'L=-1': patch(0x317, struct.pack('<h', -1)),
           'key 0 sound unterminated': patch(0x337, bytes([0x41] * 0x21)), 'key 4 text unterminated': patch(0x337 + 4 * 0x42 + 0x21, bytes([0x41] * 0x21)),
           'key 2 sound unterminated': patch(0x337 + 2 * 0x42, bytes([0x42] * 0x21))}
    for name, b in bad.items():
        fresh(active=1, row=0)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
        expect('K1 click ' + name, nat.click(b, 1, CAND_KEY, 1)[0][0], ERR_ARGUMENT)
        expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
        expect('K1 no effect ' + name, snapshot(nat), snap)
    expect('K1 valid body accepted', nat.validate(base), OK)
    expect('K1 unterminated records beyond N accepted', nat.validate(patch(0x337 + 7 * 0x42, bytes([0x41] * 0x42))), OK)
    expect('K1 phase 0 with a negative row', (fresh(), nat.step(base, -1, 0)[0])[1], ERR_ARGUMENT)
    # K2: phase 1 / 2 without initialisation, or for another row
    for ph in (1, 2):
        for variant in ('uninitialised', 'other row'):
            fresh(active=1 if variant == 'other row' else 0, row=3 if variant == 'other row' else 0, state=1)
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K3: event flag outside the host window (the exit and the solved path)
    for idx in (4096, -2, 32767, -32768):
        for name, st, off in (('exit', dict(exit=1), 0x7A8), ('solved', dict(solved=1), 0x75C)):
            body = patch(off, struct.pack('<h', idx))
            fresh(active=1, row=0, **st)
            snap = snapshot(nat)
            expect('K3 %s flag %d' % (name, idx), nat.step(body, 0, 2)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    # K4: key press with a hover outside 0..N-1, render with a pressed hover / restore key outside 0..N-1
    for hover in (5, -1, 0x7000, -2, 15, 6):
        fresh(active=1, row=0, state=1, hover=hover)
        snap = snapshot(nat)
        expect('K4 click hover %d' % hover, nat.click(base, 1, CAND_KEY, 1)[0][0], ERR_BOUNDS)
        expect('K4 no effect', snapshot(nat), snap)
    for st in (dict(pressed=1, hover=5), dict(pressed=1, hover=-2), dict(pressed=0, check=1, last=5), dict(pressed=0, check=1, last=-3)):
        fresh(active=1, row=0, slot=0x18, dirty=1, has_surface=1, **st)
        snap = snapshot(nat)
        expect('K4 render %r' % (st,), nat.render(base)['status'], ERR_BOUNDS)
        expect('K4 no effect', snapshot(nat), snap)
    for st in (dict(pressed=1, hover=-1), dict(pressed=0, check=1, last=-1), dict(pressed=0, check=0, last=7), dict(dirty=0, pressed=1, hover=9)):
        fresh(active=1, row=0, slot=0x18, **{'dirty': 1, 'has_surface': 1, **st})
        expect('K4 no refusal %r' % (st,), nat.render(base)['status'], OK)
    # K5: texts longer than 199 characters, up to 0x9c40 (refused after the sound effects), 0x9c41 (skipped like the original)
    for ln in (200, 203, 5000, 0x9C40):
        fresh(active=1, row=0, state=1, hover=1)
        nat.set_queues({**DEFAULT_Q, 'text': [b'k' * ln], 'busy': [0]})
        nat.set_extra([1])
        expect('K5 text %d' % ln, nat.click(base, 1, CAND_KEY, 1)[0][0], ERR_BOUNDS)
        expect('K5 nothing shown', nat.nstrs(2), 0)
        expect('K5 sound effects happened first', [e[0] for e in nat.log(0)][:4], [FX['PHASE'] * 0 + FX['SOUND_BUSY'], FX['SOUND_PREPARE'], FX['SOUND_PLAY'], FX['TICK']])
    for ln in (199, 0x9C41):
        fresh(active=1, row=0, state=1, hover=1)
        nat.set_queues({**DEFAULT_Q, 'text': [b'k' * ln], 'busy': [0]})
        expect('K5 text %d is accepted' % ln, nat.click(base, 1, CAND_KEY, 1)[0][0], OK)
        expect('K5 shown iff <= 199', nat.nstrs(2), 1 if ln == 199 else 0)
    # K6: host failures, in every host call the kernel makes
    cases = [('phase0 clear', F_CLEAR, 0, {}), ('phase0 alloc', F_ALLOC, 0, {}), ('phase0 register', F_REGISTER, 0, {}), ('phase0 load', F_LOAD, 0, {}),
             ('phase0 set surface', F_SETSURF, 0, {}), ('state0 stop', F_STOP, 1, dict(state=0, deadline=0)), ('state2 tick-free', 0, 1, dict(state=2)),
             ('state3 prepare', F_PREPARE, 1, dict(state=3, deadline=0)), ('state3 play', F_PLAY, 1, dict(state=3, deadline=0)), ('state4 busy', F_BUSY, 1, dict(state=4)),
             ('state4 stop', F_STOP, 1, dict(state=4)), ('phase2 transition', F_TRANSITION, 2, dict(solved=1)), ('phase2 flag', F_FLAG, 2, dict(exit=1)),
             ('phase2 release surface', F_RELEASE_SURFACE, 2, dict(surface=0x44, slot=0x20)), ('phase2 release slot', F_RELEASE_SLOT, 2, dict(slot=0x20))]
    for name, flag, ph, st in cases:
        if flag == 0:
            continue
        fresh(active=1, row=0, **st)
        nat.set_queues({**DEFAULT_Q, 'busy': [0]})
        nat.set_fail(flag)
        status = nat.step(base, 0, ph)[0]
        nat.set_fail(0)
        expect('K6 ' + name, status, ERR_HOST)
    fresh(active=1, row=0, state=1, hover=1)
    nat.set_extra([1])
    for name, flag in (('click busy', F_BUSY), ('click prepare', F_PREPARE), ('click play', F_PLAY), ('click text lookup', F_TEXT_LOOKUP), ('click text show', F_TEXT_SHOW)):
        fresh(active=1, row=0, state=1, hover=1)
        nat.set_queues({**DEFAULT_Q, 'text': [b'hello'], 'busy': [0]})
        nat.set_extra([1])
        nat.set_fail(flag)
        status = nat.click(base, 1, CAND_KEY, 1)[0][0]
        nat.set_fail(0)
        expect('K6 ' + name, status, ERR_HOST)
    fresh(active=1, row=0, slot=0x18, dirty=1, has_surface=1, pressed=1, hover=1)
    nat.set_fail(F_ORIGIN)
    status = nat.render(base)['status']
    nat.set_fail(0)
    expect('K6 render origin', status, ERR_HOST)
    fresh(active=1, slot=0x18)
    nat.set_fail(F_DIRTY)
    status = nat.invalidate()
    nat.set_fail(0)
    expect('K6 invalidate mark dirty', status, ERR_HOST)
    for flag, st in ((F_RELEASE_SURFACE, dict(surface=0x44)), (F_RELEASE_SLOT, dict(slot=0x20))):
        fresh(**st)
        nat.set_fail(flag)
        status = nat.cleanup()
        nat.set_fail(0)
        expect('K6 cleanup host failure %d' % flag, status, ERR_HOST)
    # K6: allocator exhaustion (the original reaches the fatal path 0x52139c)
    fresh(active=0, row=-1)
    table = bytearray(nat.entries())
    for s in range(0x18, 0x40):
        struct.pack_into('<I', table, s * STRIDE + 0x18, 1)
    nat.set_entries(bytes(table))
    expect('K6 allocator exhausted', nat.step(base, 0, 0)[0], ERR_HOST)
    # K7: render with the slot -1 while redraw is requested: native does nothing
    fresh(active=1, row=0, slot=-1, dirty=1, has_surface=1, pressed=1, hover=1)
    snap = snapshot(nat)
    r = nat.render(base)
    expect('K7 render slot -1', (r['status'], r['valid'], r['blit']), (OK, 0, 0))
    expect('K7 no effect', snapshot(nat), snap)
    # no-op arguments
    fresh()
    expect('invalidate on a power-on object', (nat.invalidate(), nat.log(1)), (OK, []))
    stats['known_divergences']['K1..K7 checked natively (see the docstring); not run against the original'] += 1


# ---------------------------------------------------------------------------------------------
# planted mutants of the kernel
# ---------------------------------------------------------------------------------------------
K = 'action_family_d0_runtime.c'
MUTANTS = {}
# Equivalent against the original: the order of the transition host call relative to the observer calls that report it is invisible in
# the original (a bundle of plain stores), so it is not asserted and the mutant is not counted.
EQUIVALENT_MUTANTS = {
    'click: order shifted one too far': 'the extra move writes order[l-1], which the following store of the played key overwrites; for l == 15 it reads one word '
                                        'past the array (undefined in C, no original behaviour): invisible against the original',
}


def mutant(name, *edits, file=K):
    MUTANTS[name] = (file, list(edits))


# no-sound compare, validation
mutant('no-sound compare on 8 bytes', ('return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;'))
mutant('no-sound compare ignores case of the first byte', ("{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}", "{'n', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}"))
mutant('validate: N up to 16', ('n > D0_MAX_KEYS)', 'n > D0_MAX_KEYS + 1)'))
mutant('validate: L zero accepted', ('(l = rd_s16(body, B_SOLUTION_LEN)) < 1', '(l = rd_s16(body, B_SOLUTION_LEN)) < 0'))
mutant('validate: L up to 16', ('l > D0_MAX_KEYS)', 'l > D0_MAX_KEYS + 1)'))
# phase 0
mutant('p0 row not stored', ('o->row = row;\n    o->active = 1;', 'o->active = 1;'))
mutant('p0 active fx dropped', ('fx(host, D0_FX_ACTIVE, 1, 0);', '(void)0;'))
mutant('p0 active not set', ('o->active = 1;\n    fx(host, D0_FX_ACTIVE, 1, 0);', 'fx(host, D0_FX_ACTIVE, 1, 0);'))
mutant('p0 pressed not cleared', ('o->pressed = 0;\n    o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;', 'o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;'))
mutant('p0 check not cleared', ('o->pressed = 0;\n    o->check = 0;', 'o->pressed = 0;'))
mutant('p0 dirty not cleared', ('o->check = 0;\n    o->dirty = 0;\n    o->surface = 0u;', 'o->check = 0;\n    o->surface = 0u;'))
mutant('p0 start flag 0', ('world->start_flag_5bb1ca = 1;\n    fx(host, D0_FX_START_FLAG, 1, 0);\n    HOST(host->clear_pending_item', 'world->start_flag_5bb1ca = 0;\n    fx(host, D0_FX_START_FLAG, 0, 0);\n    HOST(host->clear_pending_item'))
mutant('p0 start flag fx dropped', ('fx(host, D0_FX_START_FLAG, 1, 0);\n    HOST(host->clear_pending_item', 'HOST(host->clear_pending_item'))
mutant('p0 clear item skipped', ('HOST(host->clear_pending_item(host->context));\n    fx(host, D0_FX_CLEAR_ITEM, 0, 0);', '(void)0;'))
mutant('p0 clear item fx dropped', ('fx(host, D0_FX_CLEAR_ITEM, 0, 0);', '(void)0;'))
mutant('p0 order cleared one short', ('for (int k = 0; k < 7; ++k) o->order[k] = 0;', 'for (int k = 0; k < 6; ++k) o->order[k] = 0;'))
mutant('p0 order cleared one long', ('for (int k = 0; k < 7; ++k) o->order[k] = 0;', 'for (int k = 0; k < 8; ++k) o->order[k] = 0;'))
mutant('p0 order word 7 fully cleared', ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', 'o->order[7] = 0;'))
mutant('p0 order word 7 kept', ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', '(void)0;'))
mutant('p0 order word 7 high byte cleared instead', ('o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);', 'o->order[7] = (int16_t)(o->order[7] & 0x00ff);'))
mutant('p0 exit not cleared', ('o->exit_taken = 0;\n    o->solved = 0;\n    if (body[0] == 0) {', 'o->solved = 0;\n    if (body[0] == 0) {'))
mutant('p0 solved not cleared', ('o->exit_taken = 0;\n    o->solved = 0;\n    if (body[0] == 0) {', 'o->exit_taken = 0;\n    if (body[0] == 0) {'))
mutant('p0 empty test on the second byte', ('if (body[0] == 0) {\n        o->has_surface = 0;', 'if (body[1] == 0) {\n        o->has_surface = 0;'))
mutant('p0 has_surface not set', ('o->has_surface = 1;\n        HOST(host->alloc_slot', 'HOST(host->alloc_slot'))
mutant('p0 slot fx drops the slot', ('fx(host, D0_FX_SLOT, slot, 0);', 'fx(host, D0_FX_SLOT, 0, 0);'))
mutant('p0 slot not stored', ('o->slot = slot;\n        fx(host, D0_FX_SLOT, slot, 0);', 'fx(host, D0_FX_SLOT, slot, 0);'))
mutant('p0 register label', ('"PIANO PUZZLE OVERLAYS"', '"PIANO PUZZLE OVERLAY"'))
mutant('p0 slot register fx dropped', ('fx(host, D0_FX_SLOT_REGISTER, slot, 0);', '(void)0;'))
mutant('p0 surface loaded from the label', ('host->load_surface(host->context, (const char *)body, &surface)', 'host->load_surface(host->context, (const char *)body + 1, &surface)'))
mutant('p0 surface not stored', ('o->surface = surface;\n            fx(host, D0_FX_SURFACE_LOAD', 'fx(host, D0_FX_SURFACE_LOAD'))
mutant('p0 surface load fx drops the handle', ('fx(host, D0_FX_SURFACE_LOAD, (int32_t)surface, 0);', 'fx(host, D0_FX_SURFACE_LOAD, 0, 0);'))
mutant('p0 slot surface fx drops the surface', ('fx(host, D0_FX_SLOT_SURFACE, slot, (int32_t)o->surface);', 'fx(host, D0_FX_SLOT_SURFACE, slot, 0);'))
mutant('p0 slot surface skipped', ('HOST(host->set_slot_surface(host->context, slot, o->surface));\n        fx(host, D0_FX_SLOT_SURFACE, slot, (int32_t)o->surface);', '(void)0;'))
mutant('p0 state not idle', ('o->state = D0_STATE_IDLE;\n    fx(host, D0_FX_STATE, o->state, 0);\n    return D0_OK;', 'o->state = D0_STATE_RELEASE;\n    fx(host, D0_FX_STATE, o->state, 0);\n    return D0_OK;'))
mutant('p0 state fx dropped', ('o->state = D0_STATE_IDLE;\n    fx(host, D0_FX_STATE, o->state, 0);\n    return D0_OK;', 'o->state = D0_STATE_IDLE;\n    return D0_OK;'))
mutant('p0 row phase stays 0', ('row_phase = 1u;\n            fx(host, D0_FX_PHASE, 1, 0);', 'row_phase = 0u;\n            fx(host, D0_FX_PHASE, 0, 0);'))
mutant('p0 initialized not reported', ('result->initialized = 1u;', '(void)0;'))
# phase 1 states
mutant('s0 deadline strictly after', ('if (now >= o->deadline) {\n            HOST(host->sound_stop', 'if (now > o->deadline) {\n            HOST(host->sound_stop'))
mutant('s0 deadline compared signed', ('if (now >= o->deadline) {\n            HOST(host->sound_stop', 'if ((int32_t)now >= (int32_t)o->deadline) {\n            HOST(host->sound_stop'))
mutant('s0 stops the win record', ('host->sound_stop(host->context, body + B_KEY_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_KEY_SOUND, 0);', 'host->sound_stop(host->context, body + B_WIN_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);'))
mutant('s0 release goes to state 2', ('o->state = D0_STATE_IDLE;\n            fx(host, D0_FX_STATE, o->state, 0);\n            o->dirty = 1;', 'o->state = D0_STATE_START_WIN;\n            fx(host, D0_FX_STATE, o->state, 0);\n            o->dirty = 1;'))
mutant('s0 release keeps dirty', ('o->dirty = 1;\n            o->check = 1;\n            o->pressed = 0;', 'o->check = 1;\n            o->pressed = 0;'))
mutant('s0 release keeps check', ('o->dirty = 1;\n            o->check = 1;\n            o->pressed = 0;', 'o->dirty = 1;\n            o->pressed = 0;'))
mutant('s0 release keeps pressed', ('o->dirty = 1;\n            o->check = 1;\n            o->pressed = 0;', 'o->dirty = 1;\n            o->check = 1;'))
mutant('s0 tick fx dropped', ('const uint32_t now = host->tick(host->context);\n        fx(host, D0_FX_TICK, (int32_t)now, 0);\n        if (now >= o->deadline) {\n            HOST(host->sound_stop', 'const uint32_t now = host->tick(host->context);\n        if (now >= o->deadline) {\n            HOST(host->sound_stop'))
mutant('s1 solved check also with a surface', ('if (o->has_surface == 0) solved_check(o, body, host);', 'solved_check(o, body, host);'))
mutant('s1 solved check never', ('if (o->has_surface == 0) solved_check(o, body, host);', '(void)0;'))
mutant('s1 solved check inverted', ('if (o->has_surface == 0) solved_check(o, body, host);', 'if (o->has_surface != 0) solved_check(o, body, host);'))
mutant('s2 delay read unsigned', ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)(uint16_t)rd_s16(body, B_DELAY) * 1000)'))
mutant('s2 delay times 1024', ('(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000)', '(uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1024)'))
mutant('s2 delay read from the wrong word', ('rd_s16(body, B_DELAY) * 1000', 'rd_s16(body, B_DELAY + 2) * 1000'))
mutant('s2 deadline from the stale value', ('o->deadline = now + (uint32_t)', 'o->deadline = o->deadline + (uint32_t)'))
mutant('s2 goes to state 4', ('o->state = D0_STATE_WAIT_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);', 'o->state = D0_STATE_WIN_SOUND;\n        fx(host, D0_FX_STATE, o->state, 0);'))
mutant('s3 deadline strictly after', ('if (now >= o->deadline) {\n            if (!no_sound', 'if (now > o->deadline) {\n            if (!no_sound'))
mutant('s3 deadline compared signed', ('if (now >= o->deadline) {\n            if (!no_sound', 'if ((int32_t)now >= (int32_t)o->deadline) {\n            if (!no_sound'))
mutant('s3 win sound test inverted', ('if (!no_sound(body + B_WIN_SOUND)) {', 'if (no_sound(body + B_WIN_SOUND)) {'))
mutant('s3 win channel from the key channel', ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n                HOST(host->sound_prepare', 'const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n                HOST(host->sound_prepare'))
mutant('s3 prepares the key record', ('host->sound_prepare(host->context, body + B_WIN_SOUND));\n                fx(host, D0_FX_SOUND_PREPARE, B_WIN_SOUND, 0);', 'host->sound_prepare(host->context, body + B_KEY_SOUND));\n                fx(host, D0_FX_SOUND_PREPARE, B_KEY_SOUND, 0);'))
mutant('s3 stays in state 3 after the sound', ('o->state = D0_STATE_WIN_SOUND;\n                fx(host, D0_FX_STATE, o->state, 0);', 'fx(host, D0_FX_STATE, o->state, 0);'))
mutant('s3 no-sound path keeps phase 1', ('} else {\n                *row_phase = 2u;', '} else {\n                *row_phase = 1u;'))
mutant('s4 busy test inverted', ('if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy != 0) {\n            HOST(host->sound_stop'))
mutant('s4 busy test signed', ('if (busy == 0) {\n            HOST(host->sound_stop', 'if (busy <= 0) {\n            HOST(host->sound_stop'))
mutant('s4 busy test on the low byte', ('if (busy == 0) {\n            HOST(host->sound_stop', 'if ((busy & 0xff) == 0) {\n            HOST(host->sound_stop'))
mutant('s4 stops the key record', ('host->sound_stop(host->context, body + B_WIN_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);\n            *row_phase = 2u;', 'host->sound_stop(host->context, body + B_KEY_SOUND));\n            fx(host, D0_FX_SOUND_STOP, B_KEY_SOUND, 0);\n            *row_phase = 2u;'))
mutant('s4 busy channel is the key channel', ('const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n        int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n        int32_t busy = 0;'))
mutant('states above 4 run state 1', ('    default:\n        break;\n    }\n    return D0_OK;\n}\n\n/* 0x48dca9', '    default:\n        if (o->has_surface == 0) solved_check(o, body, host);\n        break;\n    }\n    return D0_OK;\n}\n\n/* 0x48dca9'))
# solved check
mutant('solved: one entry too few', ('while (i < l && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;', 'while (i < l - 1 && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;'))
mutant('solved: unsigned compare', ('o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)', '(uint16_t)o->order[i] == (uint16_t)rd_s16(body, B_SOLUTION + (size_t)i * 2u) && o->order[i] >= 0'))
mutant('solved: solution word read as byte', ('o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)', 'o->order[i] == (int16_t)body[B_SOLUTION + (size_t)i * 2u]'))
mutant('solved: compares the last entries', ('o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)', 'o->order[14 - i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)'))
mutant('solved: goes to state 3', ('o->state = D0_STATE_START_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'o->state = D0_STATE_WAIT_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;'))
mutant('solved: flag not set', ('fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'fx(host, D0_FX_STATE, o->state, 0);'))
mutant('solved: state fx dropped', ('o->state = D0_STATE_START_WIN;\n        fx(host, D0_FX_STATE, o->state, 0);\n        o->solved = 1;', 'o->state = D0_STATE_START_WIN;\n        o->solved = 1;'))
mutant('solved: entry fx dropped', ('fx(host, D0_FX_SOLVED_CHECK, 0, 0);', '(void)0;'))
mutant('solved: lazy match on the first entry only', ('while (i < l && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;\n    if (i >= l) {', 'while (i < l && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;\n    if (i >= 1) {'))
# phase 2
mutant('p2 start flag 0', ('world->start_flag_5bb1ca = 1;\n    fx(host, D0_FX_START_FLAG, 1, 0);\n    if (o->exit_taken', 'world->start_flag_5bb1ca = 0;\n    fx(host, D0_FX_START_FLAG, 0, 0);\n    if (o->exit_taken'))
mutant('p2 start flag fx dropped', ('fx(host, D0_FX_START_FLAG, 1, 0);\n    if (o->exit_taken', 'if (o->exit_taken'))
mutant('p2 exit and solved swapped', ('if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);\n    if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);',
                                      'if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);\n    if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);'))
mutant('p2 exit uses the solved block', ('return apply_block(body + B_EXIT, world, host);\n    if (o->solved', 'return apply_block(body + B_SOLVED, world, host);\n    if (o->solved'))
mutant('p2 solved uses the exit block', ('return apply_block(body + B_SOLVED, world, host);\n    return D0_OK;', 'return apply_block(body + B_EXIT, world, host);\n    return D0_OK;'))
mutant('p2 exit test inverted', ('if (o->exit_taken != 0) return apply_block', 'if (o->exit_taken == 0) return apply_block'))
mutant('p2 solved test inverted', ('if (o->solved != 0) return apply_block', 'if (o->solved == 0) return apply_block'))
mutant('p2 solved ignored', ('    if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);\n    return D0_OK;', '    return D0_OK;'))
mutant('block start word == 0', ('rd_s16(blk, SB_START) != 1 ? 1 : 0', 'rd_s16(blk, SB_START) != 0 ? 1 : 0'))
mutant('block start word != 1 inverted', ('rd_s16(blk, SB_START) != 1 ? 1 : 0', 'rd_s16(blk, SB_START) == 1 ? 1 : 0'))
mutant('block start word low byte', ('rd_s16(blk, SB_START) != 1 ? 1 : 0', '(rd_s16(blk, SB_START) & 0xff) != 1 ? 1 : 0'))
mutant('block scene none is >= 9999', ('if (rd_s16(blk, SB_SCENE) != D0_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) < D0_NO_SCENE) {'))
mutant('block scene none on 15 bits', ('if (rd_s16(blk, SB_SCENE) != D0_NO_SCENE) {', 'if ((rd_s16(blk, SB_SCENE) & 0x7fff) != D0_NO_SCENE) {'))
mutant('block scene none is -1', ('if (rd_s16(blk, SB_SCENE) != D0_NO_SCENE) {', 'if (rd_s16(blk, SB_SCENE) != -1) {'))
mutant('block words 1 and 2 swapped', ('t.word[0] = rd_s16(blk, SB_W1);', 't.word[0] = rd_s16(blk, SB_W2);'))
mutant('block word 3 from word 1', ('t.word[2] = rd_s16(blk, SB_W3);', 't.word[2] = rd_s16(blk, SB_W1);'))
mutant('block dwords 2 and 3 swapped', ('t.dword[1] = rd_s32(blk, SB_D2);', 't.dword[1] = rd_s32(blk, SB_D3);'))
mutant('block dword 1 from word offset', ('t.dword[0] = rd_s32(blk, SB_D1);', 't.dword[0] = rd_s32(blk, SB_D1 + 2);'))
mutant('block scene zero-extended', ('t.scene = rd_s16(blk, SB_SCENE);', 't.scene = (int16_t)(rd_s16(blk, SB_SCENE) & 0x7fff);'))
mutant('block engine mode 3', ('fx(host, D0_FX_ENGINE_MODE, 4, 0);', 'fx(host, D0_FX_ENGINE_MODE, 3, 0);'))
mutant('block engine mode fx dropped', ('fx(host, D0_FX_ENGINE_MODE, 4, 0);', '(void)0;'))
mutant('block start flag fx dropped', ('fx(host, D0_FX_START_FLAG, world->start_flag_5bb1ca, 0);', '(void)0;'))
mutant('block flag skipped for index 0', ('if (flag != D0_NO_FLAG) {\n            HOST(host->store_event_flag', 'if (flag > 0) {\n            HOST(host->store_event_flag'))
mutant('block flag value masked to 7 bits', ('HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));\n            fx(host, D0_FX_EVENT_FLAG, flag, blk[SB_VALUE]);',
                                           'HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE] & 0x7f));\n            fx(host, D0_FX_EVENT_FLAG, flag, blk[SB_VALUE] & 0x7f);'))
mutant('block flag value is the scene byte', ('blk[SB_VALUE]));\n            fx(host, D0_FX_EVENT_FLAG, flag, blk[SB_VALUE]);', 'blk[SB_VALUE + 1]));\n            fx(host, D0_FX_EVENT_FLAG, flag, blk[SB_VALUE + 1]);'))
mutant('block flag index word from the wrong offset', ('const int16_t flag = rd_s16(blk, SB_FLAG);\n        if (flag != D0_NO_FLAG) {', 'const int16_t flag = rd_s16(blk, SB_FLAG + 2);\n        if (flag != D0_NO_FLAG) {'))
mutant('block flag none is 0', ('if (flag != D0_NO_FLAG) {\n            HOST(host->store_event_flag', 'if (flag != 0) {\n            HOST(host->store_event_flag'))
mutant('p2 complete fx carries no row', ('fx(host, D0_FX_COMPLETE, row, 0);', 'fx(host, D0_FX_COMPLETE, 0, 0);'))
mutant('p2 not completed', ('result->completed = 1u;', 'result->completed = 0u;'))
mutant('p2 phase stays 2', ('row_phase = 0u; /* 0x42ba3a stores phase 0 */', 'row_phase = 2u;'))
mutant('p2 cleanup skipped', ('rc = d0_cleanup(object, host);\n        }', '(void)0;\n        }'))
mutant('p2 flag window check ignores the solved block', ('const uint8_t *blk = object->exit_taken != 0 ? body + B_EXIT : (object->solved != 0 ? body + B_SOLVED : NULL);', 'const uint8_t *blk = object->exit_taken != 0 ? body + B_EXIT : NULL;'))
mutant('step: phase 1 needs no init', ('if (object->active == 0 || object->row != row) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";', 'if (0) {\n            if (failure != NULL) *failure = "0xd0-phase-1-without-init";'))
mutant('step: phase above 2 runs phase 1', ('} else if (phase == 1u) {', '} else if (phase >= 1u && phase != 2u) {'))
# pointer
mutant('pointer: top edge exclusive', ('return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12)', 'return rd_s32(body, rect + 4) < y && y <= rd_s32(body, rect + 12)'))
mutant('pointer: bottom edge exclusive', ('y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x', 'y < rd_s32(body, rect + 12) && rd_s32(body, rect) <= x'))
mutant('pointer: left edge exclusive', ('rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8)', 'rd_s32(body, rect) < x &&\n           x <= rd_s32(body, rect + 8)'))
mutant('pointer: right edge exclusive', ('x <= rd_s32(body, rect + 8);', 'x < rd_s32(body, rect + 8);'))
mutant('pointer: x not truncated to a word', ('x = (int16_t)x; /* movsx word */', '(void)0;'))
mutant('pointer: y not truncated to a word', ('y = (int16_t)y;', '(void)0;'))
mutant('pointer: x and y swapped in the rectangle test', ('return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n           x <= rd_s32(body, rect + 8);',
                                                         'return rd_s32(body, rect + 4) <= x && x <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= y &&\n           y <= rd_s32(body, rect + 8);'))
mutant('pointer: claims while inactive', ('if (object->active == 0) return D0_OK;\n    x = (int16_t)x;', 'x = (int16_t)x;'))
mutant('pointer: exit tested while pressed', ('if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {', 'if (in_rect(body, B_EXIT_RECT, x, y)) {'))
mutant('pointer: exit never', ('if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {', 'if (0 && in_rect(body, B_EXIT_RECT, x, y)) {'))
mutant('pointer: exit tested after the keys', ('    if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {\n        cursor_write(object, body, D0_CANDIDATE_EXIT, 0, out);\n        out->hit = 1u;\n        return D0_OK;\n    }\n',
                                              ''))
mutant('pointer: last key unreachable', ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {', 'for (int16_t i = 0; i < n - 1; ++i) {\n        if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {'))
mutant('pointer: last key wins', ('for (int16_t i = 0; i < n; ++i) {\n        if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {', 'for (int16_t i = n - 1; i >= 0; --i) {\n        if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {'))
mutant('pointer: keys tested against the key rectangles', ('if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {', 'if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y)) {'))
mutant('pointer: pressed redraw needs no hover match', ('if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover) {', 'if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y)) {'))
mutant('pointer: pressed redraw tests the hit rectangles', ('if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover) {', 'if (in_rect(body, B_HIT + (size_t)i * 16u, x, y) && i == object->hover) {'))
mutant('pointer: pressed redraw never', ('if (object->pressed != 0) {\n        for (int16_t i = 0; i < n; ++i) {\n            if (in_rect(body, B_KEYRECT', 'if (0) {\n        for (int16_t i = 0; i < n; ++i) {\n            if (in_rect(body, B_KEYRECT'))
mutant('pointer: pressed redraw leaves dirty', ('object->dirty = 1;\n                return D0_OK;', 'return D0_OK;'))
mutant('pointer: pressed redraw claims', ('object->dirty = 1;\n                return D0_OK;', 'object->dirty = 1;\n                out->hit = 1u;\n                return D0_OK;'))
mutant('cursor: sub 0', ('out->cursor_sub = 1;', 'out->cursor_sub = 0;'))
mutant('cursor: exit kind 8', ('out->cursor_kind = D0_CURSOR_EXIT;', 'out->cursor_kind = 8;'))
mutant('cursor: exit clears no hover', ('out->cursor_kind = D0_CURSOR_EXIT;\n        o->hover = -1;', 'out->cursor_kind = D0_CURSOR_EXIT;'))
mutant('cursor: dirty not set', ('o->dirty = 1;\n    if (candidate == D0_CANDIDATE_EXIT) {', 'if (candidate == D0_CANDIDATE_EXIT) {'))
mutant('cursor: hover stored while pressed', ('if (o->pressed == 0) o->hover = key;', 'o->hover = key;'))
mutant('cursor: hover never stored', ('if (o->pressed == 0) o->hover = key;', '(void)0;'))
mutant('cursor: region A top edge exclusive', ('if (top >= rd_s32(body, B_REGION_A + 4) &&', 'if (top > rd_s32(body, B_REGION_A + 4) &&'))
mutant('cursor: region A bottom edge exclusive', ('bottom <= rd_s32(body, B_REGION_A + 12) &&', 'bottom < rd_s32(body, B_REGION_A + 12) &&'))
mutant('cursor: region A left edge exclusive', ('left >= rd_s32(body, B_REGION_A) && right', 'left > rd_s32(body, B_REGION_A) && right'))
mutant('cursor: region A right edge exclusive', ('right <= rd_s32(body, B_REGION_A + 8))', 'right < rd_s32(body, B_REGION_A + 8))'))
mutant('cursor: region B top edge exclusive', ('top >= rd_s32(body, B_REGION_B + 4) &&', 'top > rd_s32(body, B_REGION_B + 4) &&'))
mutant('cursor: region B bottom edge exclusive', ('bottom <= rd_s32(body, B_REGION_B + 12) &&', 'bottom < rd_s32(body, B_REGION_B + 12) &&'))
mutant('cursor: region B left edge exclusive', ('left >= rd_s32(body, B_REGION_B) &&', 'left > rd_s32(body, B_REGION_B) &&'))
mutant('cursor: region B right edge exclusive', ('right <= rd_s32(body, B_REGION_B + 8))', 'right < rd_s32(body, B_REGION_B + 8))'))
mutant('cursor: region test on the key rectangle', ('const size_t h = B_HIT + (size_t)key * 16u;', 'const size_t h = B_KEYRECT + (size_t)key * 16u;'))
mutant('cursor: region B first', ('out->cursor_kind = rd_s16(body, B_KIND_A);\n        else if', 'out->cursor_kind = rd_s16(body, B_KIND_B);\n        else if'))
mutant('cursor: kind A unsigned', ('out->cursor_kind = rd_s16(body, B_KIND_A);', 'out->cursor_kind = (uint16_t)rd_s16(body, B_KIND_A);'))
mutant('cursor: kind B unsigned', ('out->cursor_kind = rd_s16(body, B_KIND_B);', 'out->cursor_kind = (uint16_t)rd_s16(body, B_KIND_B);'))
mutant('cursor: no region gives kind A', ('        else\n            out->cursor_kind = 0;', '        else\n            out->cursor_kind = rd_s16(body, B_KIND_A);'))
mutant('cursor: candidate not reported', ('out->candidate = candidate;', '(void)0;'))
# click
mutant('click: works while inactive', ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;'))
mutant('click: works in any state', ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->active != 0 && row_phase == 1u)) return D0_OK;'))
mutant('click: works in any row phase', ('if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;', 'if (!(object->active != 0 && object->state == D0_STATE_IDLE)) return D0_OK;'))
mutant('click: exit phase 1', ('out->new_phase = 2u;\n        fx(host, D0_FX_PHASE, 2, 0);', 'out->new_phase = 1u;\n        fx(host, D0_FX_PHASE, 1, 0);'))
mutant('click: exit flag not set', ('object->exit_taken = 1;\n        out->exit_asked = 1u;', 'out->exit_asked = 1u;'))
mutant('click: exit phase fx dropped', ('out->new_phase = 2u;\n        fx(host, D0_FX_PHASE, 2, 0);', 'out->new_phase = 2u;'))
mutant('click: pressed without a surface', ('if (object->has_surface != 0) object->pressed = 1;', 'object->pressed = 1;'))
mutant('click: pressed never', ('if (object->has_surface != 0) object->pressed = 1;', '(void)0;'))
mutant('click: last not stored', ('object->last = key;', '(void)0;'))
mutant('click: order not shifted', ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];', '(void)0;'))
mutant('click: order shifted one too far', ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];', 'for (int16_t i = 0; i < l; ++i) object->order[i] = object->order[i + 1];'))
mutant('click: order shifted one short', ('for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];', 'for (int16_t i = 0; i < l - 2; ++i) object->order[i] = object->order[i + 1];'))
mutant('click: key stored in the first slot', ('object->order[l - 1] = key;', 'object->order[0] = key;'))
mutant('click: key stored one slot early', ('object->order[l - 1] = key;', 'object->order[l > 1 ? l - 2 : 0] = key;'))
mutant('click: sound name not copied', ('memcpy(body + B_KEY_SOUND, rec, strlen((const char *)rec) + 1u);', '(void)0;'))
mutant('click: sound name copied without its terminator', ('memcpy(body + B_KEY_SOUND, rec, strlen((const char *)rec) + 1u);', 'memcpy(body + B_KEY_SOUND, rec, strlen((const char *)rec));'))
mutant('click: sound name copied whole', ('memcpy(body + B_KEY_SOUND, rec, strlen((const char *)rec) + 1u);', 'memcpy(body + B_KEY_SOUND, rec, 0x21u);'))
mutant('click: sound needs start flag 1', ('start_flag != 0 && !no_sound(body + B_KEY_SOUND)', 'start_flag == 1 && !no_sound(body + B_KEY_SOUND)'))
mutant('click: sound ignores the record', ('start_flag != 0 && !no_sound(body + B_KEY_SOUND)', 'start_flag != 0'))
mutant('click: sound ignores the start flag', ('start_flag != 0 && !no_sound(body + B_KEY_SOUND)', '!no_sound(body + B_KEY_SOUND)'))
mutant('click: sound tests the win record', ('start_flag != 0 && !no_sound(body + B_KEY_SOUND)', 'start_flag != 0 && !no_sound(body + B_WIN_SOUND)'))
mutant('click: channel is the win channel', ('const int16_t ch = rd_s16(body, B_KEY_CHANNEL);\n            int32_t busy = 0;', 'const int16_t ch = rd_s16(body, B_WIN_CHANNEL);\n            int32_t busy = 0;'))
mutant('click: busy test inverted', ('fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy == 0) {\n                uint32_t now;', 'fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy != 0) {\n                uint32_t now;'))
mutant('click: busy test signed', ('fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy == 0) {', 'fx(host, D0_FX_SOUND_BUSY, ch, busy);\n            if (busy <= 0) {'))
mutant('click: deadline 500 -> 501', ('object->deadline = now + 500u;', 'object->deadline = now + 501u;'))
mutant('click: deadline 500 -> 1000', ('object->deadline = now + 500u;', 'object->deadline = now + 1000u;'))
mutant('click: deadline not set', ('object->deadline = now + 500u;', '(void)now;'))
mutant('click: dirty not set by the sound', ('out->sound_played = 1u;\n                object->dirty = 1;', 'out->sound_played = 1u;'))
mutant('click: prepares the win record', ('host->sound_prepare(host->context, body + B_KEY_SOUND));\n                fx(host, D0_FX_SOUND_PREPARE, B_KEY_SOUND, 0);', 'host->sound_prepare(host->context, body + B_WIN_SOUND));\n                fx(host, D0_FX_SOUND_PREPARE, B_WIN_SOUND, 0);'))
mutant('click: tick fx dropped', ('now = host->tick(host->context);\n                fx(host, D0_FX_TICK, (int32_t)now, 0);', 'now = host->tick(host->context);'))
mutant('click: text key from the sound name', ('host->text_lookup(host->context, (const char *)rec + KEY_TEXT, &text)', 'host->text_lookup(host->context, (const char *)rec, &text)'))
mutant('click: text lookup fx null flag', ('fx(host, D0_FX_TEXT_LOOKUP, key, text != NULL ? 1 : 0);', 'fx(host, D0_FX_TEXT_LOOKUP, key, 1);'))
mutant('click: text limit 198', ('if (len > D0_TEXT_LIMIT) return D0_ERR_BOUNDS;', 'if (len > D0_TEXT_LIMIT - 1) return D0_ERR_BOUNDS;'))
mutant('click: text max compared with 0x9c3f', ('if (len <= D0_TEXT_MAX) {', 'if (len < D0_TEXT_MAX) {'))
mutant('click: texts over the maximum are shown', ('if (len <= D0_TEXT_MAX) {\n                char buf', 'if (1) {\n                char buf'))
mutant('click: suffix missing', ('memcpy(buf + len, "<e>", 4);', 'memcpy(buf + len, "", 1);'))
mutant('click: suffix wrong', ('memcpy(buf + len, "<e>", 4);', 'memcpy(buf + len, "<E>", 4);'))
mutant('click: shown length without the suffix', ('fx(host, D0_FX_TEXT_SHOW, (int32_t)(len + 3u), 0);', 'fx(host, D0_FX_TEXT_SHOW, (int32_t)len, 0);'))
mutant('click: key candidate ignored', ('} else if (candidate == D0_CANDIDATE_KEY) {', '} else if (candidate == D0_CANDIDATE_KEY + 1) {'))
mutant('click: any other candidate presses', ('} else if (candidate == D0_CANDIDATE_KEY) {', '} else {'))
mutant('click: exit candidate is the key one', ('if (candidate == D0_CANDIDATE_EXIT) {\n        object->exit_taken = 1;', 'if (candidate == D0_CANDIDATE_KEY) {\n        object->exit_taken = 1;'))
# invalidate, cleanup
mutant('invalidate: ignores active', ('if (object->active != 0 && object->slot != D0_NO_SLOT) HOST(host->mark_dirty', 'if (object->slot != D0_NO_SLOT) HOST(host->mark_dirty'))
mutant('invalidate: ignores the slot', ('if (object->active != 0 && object->slot != D0_NO_SLOT) HOST(host->mark_dirty', 'if (object->active != 0) HOST(host->mark_dirty'))
mutant('invalidate: marks the wrong slot', ('HOST(host->mark_dirty(host->context, object->slot));', 'HOST(host->mark_dirty(host->context, object->slot == 0x18 ? 0x19 : 0x18));'))
mutant('cleanup: surface kept', ('object->surface = 0u;\n        fx(host, D0_FX_RELEASE_SURFACE, (int32_t)surface, 0);', 'fx(host, D0_FX_RELEASE_SURFACE, (int32_t)surface, 0);'))
mutant('cleanup: surface released when 0', ('if (object->surface != 0u) {\n        const uint32_t surface = object->surface;', 'if (1) {\n        const uint32_t surface = object->surface;'))
mutant('cleanup: surface fx reports 0', ('fx(host, D0_FX_RELEASE_SURFACE, (int32_t)surface, 0);', 'fx(host, D0_FX_RELEASE_SURFACE, 0, 0);'))
mutant('cleanup: slot released when -1', ('if (object->slot != D0_NO_SLOT) {\n        const int16_t slot = object->slot;', 'if (1) {\n        const int16_t slot = object->slot;'))
mutant('cleanup: slot kept', ('object->slot = D0_NO_SLOT; /* 0x48d067 */', '(void)0;'))
mutant('cleanup: row kept', ('object->row = -1;\n    object->active = 0;', 'object->active = 0;'))
mutant('cleanup: active kept', ('object->active = 0;\n    object->exit_taken = 0;', 'object->exit_taken = 0;'))
mutant('cleanup: exit kept', ('object->exit_taken = 0;\n    object->solved = 0;\n    return D0_OK;\n}\n\nint d0_render', 'object->solved = 0;\n    return D0_OK;\n}\n\nint d0_render'))
mutant('cleanup: solved kept', ('object->exit_taken = 0;\n    object->solved = 0;\n    return D0_OK;\n}\n\nint d0_render', 'object->exit_taken = 0;\n    return D0_OK;\n}\n\nint d0_render'))
mutant('cleanup: slot fx reports the surface', ('fx(host, D0_FX_RELEASE_SLOT, slot, 0);', 'fx(host, D0_FX_RELEASE_SLOT, 0, 0);'))
mutant('cleanup: order cleared', ('object->exit_taken = 0;\n    object->solved = 0;\n    return D0_OK;\n}\n\nint d0_render', 'object->exit_taken = 0;\n    object->solved = 0;\n    memset(object->order, 0, sizeof object->order);\n    return D0_OK;\n}\n\nint d0_render'))
# render
mutant('render: valid without a slot test', ('if (object->slot == D0_NO_SLOT) return D0_OK;\n    out->valid = 1u;', 'out->valid = 1u;'))
mutant('render: draws without a redraw request', ('if (object->dirty == 0 || object->has_surface == 0) return D0_OK;', 'if (object->has_surface == 0) return D0_OK;'))
mutant('render: draws without a surface', ('if (object->dirty == 0 || object->has_surface == 0) return D0_OK;', 'if (object->dirty == 0) return D0_OK;'))
mutant('render: dirty kept', ('    object->dirty = 0;\n    return D0_OK;\n}', '    return D0_OK;\n}'))
mutant('render: pressed test ignores hover -1', ('if (object->pressed != 0 && object->hover != -1) {', 'if (object->pressed != 0) {'))
mutant('render: pressed test ignores pressed', ('if (object->pressed != 0 && object->hover != -1) {', 'if (object->hover != -1) {'))
mutant('render: restore test ignores last -1', ('} else if (object->check != 0 && object->last != -1) {', '} else if (object->check != 0) {'))
mutant('render: restore test ignores check', ('} else if (object->check != 0 && object->last != -1) {', '} else if (object->last != -1) {'))
mutant('render: restore before pressed', ('    if (object->pressed != 0 && object->hover != -1) {\n        const int16_t key = object->hover;', '    if (0) {\n        const int16_t key = object->hover;'))
mutant('render: pressed blit source is the key rectangle', ('for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, B_PRESSED + (size_t)key * 16u + (size_t)k * 4u);', 'for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, B_KEYRECT + (size_t)key * 16u + (size_t)k * 4u);'))
mutant('render: pressed source stride 8', ('B_PRESSED + (size_t)key * 16u + (size_t)k * 4u', 'B_PRESSED + (size_t)key * 8u + (size_t)k * 4u'))
mutant('render: pressed blit surface is 0', ('out->src_surface = object->surface;', 'out->src_surface = 0u;'))
mutant('render: restore blit surface is the puzzle', ('out->src_surface = 0u; /* the host\'s generic entry 1 surface (0x5d15e3) */', 'out->src_surface = object->surface;'))
mutant('render: origin y added to x', ('out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);',
                                       'out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vy);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);'))
mutant('render: origin ignored for the right edge (pressed)', ('out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);',
                                                               'out->dst[2] = rd_s32(body, d + 8);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 1);'))
mutant('render: origin ignored for the bottom edge (restore)', ('out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 2);', 'out->dst[3] = rd_s32(body, d + 12);\n        fx(host, D0_FX_BLIT, key, 2);'))
mutant('render: origin ignored for the left edge (restore)', ('out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 2);',
                                                                'out->dst[0] = rd_s32(body, d);\n        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);\n        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);\n        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);\n        fx(host, D0_FX_BLIT, key, 2);'))
mutant('render: pressed blit fx kind', ('fx(host, D0_FX_BLIT, key, 1);', 'fx(host, D0_FX_BLIT, key, 2);'))
mutant('render: pressed blit sets no state', ('object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);', '(void)0;'))
mutant('render: pressed blit state 1', ('object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);', 'object->state = D0_STATE_IDLE;\n        fx(host, D0_FX_STATE, object->state, 0);'))
mutant('render: pressed state fx dropped', ('object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);', 'object->state = D0_STATE_RELEASE;'))
mutant('render: restore leaves check', ('object->check = 0;\n        out->solved_check = 1u;', 'out->solved_check = 1u;'))
mutant('render: restore runs no solved check', ('out->solved_check = 1u;\n        solved_check(object, body, host);', 'out->solved_check = 1u;'))
mutant('render: pressed blit runs the solved check', ('object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);', 'object->state = D0_STATE_RELEASE;\n        fx(host, D0_FX_STATE, object->state, 0);\n        solved_check(object, body, host);'))
mutant('render: restore blit key is hover', ('const int16_t key = object->last;', 'const int16_t key = object->hover;'))
mutant('render: pressed blit key is last', ('const int16_t key = object->hover;\n        const size_t d = B_KEYRECT + (size_t)key * 16u;\n        if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;', 'const int16_t key = object->last;\n        const size_t d = B_KEYRECT + (size_t)key * 16u;\n        if (key < 0 || key >= n) return D0_ERR_BOUNDS;\n        HOST(host->view_origin(host->context, &vx, &vy));\n        out->blit = 1u;'))
mutant('render: restore source rectangle with origin', ('for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, d + (size_t)k * 4u);', 'for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, d + (size_t)k * 4u) + (k % 2 ? vy : vx);'))


def mutation_check(args, workdir, jobs):
    report = [None] * len(MUTANTS)
    pending = []
    for idx, (name, (filename, edits)) in enumerate(MUTANTS.items()):
        source = (args.src / filename).read_text()
        bad_anchor = [old[:60] for old, _ in edits if source.count(old) != 1]
        if bad_anchor:
            report[idx] = dict(mutant=name, detected=None, how='mutation anchor drifted: %r' % bad_anchor)
            continue
        d = Path(workdir) / ('mut%d' % idx)
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        for old, new in edits:
            source = source.replace(old, new)
        (d / filename).write_text(source)
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % idx), strict=False)
        except d9.OracleError as error:
            report[idx] = dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:160])
            continue
        pending.append((idx, name, lib_path))
    running = []
    while pending or running:
        while pending and len(running) < jobs:
            idx, name, lib_path = pending.pop(0)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
            running.append((idx, name, subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)))
        time.sleep(0.05)
        for entry in list(running):
            idx, name, proc = entry
            if proc.poll() is None:
                continue
            running.remove(entry)
            out, err = proc.communicate()
            first = next((l for l in out.splitlines() if l.startswith('FIRST ')), None)
            rc = proc.returncode
            how = 'mismatch' if rc == 1 else 'crash signal %d' % -rc if rc < 0 else 'undetected' if rc == 0 else 'error %d: %s' % (rc, err[-200:])
            report[idx] = dict(mutant=name, detected=rc != 0 and not how.startswith('error'), how=how, first=first[6:][:200] if first else None)
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
    for a, sz in blocks:
        i = bisect.bisect_right(starts, a) - 1
        funcs[starts[i]] = starts[i + 1]
    for a in HOOK_RETS:
        i = bisect.bisect_left(starts, a)
        funcs[starts[i]] = starts[i + 1]
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
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
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick then full scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-50.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_d0.so')
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
            try:
                refusal_checks(nat, stats)
            except Mismatch as error:
                bad.append(('refusal', str(error)))
        if not bad:
            bad = run_list(x, nat, [s for s in scs if not s['quick']], stats, fail_fast=True)
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300].replace('\n', ' ')))
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
        print('MISMATCH', sid, '::', msg[:900])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['skipped_native_refusal'] = dict(stats['skipped_native_refusal'])
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work, args.jobs)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
        for m in mutations:
            m['equivalent'] = m['mutant'] in EQUIVALENT_MUTANTS
        counted = [m for m in mutations if not m['equivalent']]
        summary['mutants_total'] = len(counted)
        summary['mutants_killed'] = sum(1 for m in counted if m['detected'])
        summary['mutants_planted'] = len(mutations)
        summary['equivalent_mutants_not_counted'] = EQUIVALENT_MUTANTS
    summary['seconds'] = round(time.monotonic() - started, 1)
    print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in x.pins]
        args.result.write_text(json.dumps(dict(slice='RT-50', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] and not m['equivalent'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
