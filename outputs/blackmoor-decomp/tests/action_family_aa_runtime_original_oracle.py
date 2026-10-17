#!/usr/bin/env python3
"""RT-52: immutable x86 dispatcher 0x427a50 / handler 0x44da08 (raw 0xaa, the Alarm Clock), the object methods 0x44d28c (pointer, with
its inner 0x44d597), 0x44d624 (click), 0x44e035 (render callback, with 0x44d9b5), 0x44d19d (invalidate), 0x44d154 (cleanup, with 0x44d107),
and the time helpers 0x44d711 / 0x44d8ad / 0x44d946 versus the native kernel src/action_family_aa_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xaa (and 0x67 as the plain "other loaded row") the REAL
dispatcher 0x427a50 runs: dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a66e, the handler
0x44da08 with every phase and all nine states of obj+0x2d (0..8, plus the values above 8 that fall out of the switch), the time reader
0x44d711, the hour step 0x44d8ad, the alarm writer 0x44d946, the generic completion 0x42ba3a (subtype 1 sets the completion byte, subtype
2 clears it and runs the dependency reset 0x423d33, every subtype stores phase 0) and the cleanup 0x44d154 / 0x44d107 with the idle-timer
touch (0x4d3c31 / 0x4d3d20 run as original code on the object at 0x61c387). The generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 run
as original code on the table at 0x5d1591 (busy seeds decide which slot comes back). The object methods run as original functions on the
same process image with ECX = 0x624cbf: the pointer test 0x44d28c (two stack words x, y whose upper halves are garbage), the click method
0x44d624 (no arguments, reads the start flag 0x5bb1ca; there is no candidate: the original calls it on every accepted release and it
guards itself), the render callback 0x44e035 (cdecl) and the invalidate 0x44d19d, the cleanup 0x44d154.

Native side: tests/action_family_aa_runtime_oracle_driver.c links ONLY the kernel (src/action_family_aa_runtime.c) and implements the HOST
side of the AlcHost contract with scripted queues (GetTickCount values, sound-busy answers, image handles), a model of the Z entry table,
the view origin, the event flag window (the game hour word 0x585d51 and minute word 0x585d4f live INSIDE it) and the object at 0x61c387.
The driver decides nothing the kernel decides. It keeps two logs, the observer log (AlcHost.observe) and the host-call log (what the kernel
really asked of the host); the oracle requires them to agree, so an observer that invents or omits an effect fails.

Compared after EVERY action (dispatcher pass, pointer, click, render, invalidate, cleanup):
 * the whole 0x53-byte object image 0x624cbf.. byte for byte against AlcObject (the bytes without a field come from a shadow); the process
   cells 0x5bb1ca and 0x583999; the clock words 0x585d51 / 0x585d4f; the seven scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff
   0x5bb59b 0x5bb59f 0x5bb5a3; the whole event flag window (4096 dwords at 0x585801, which contains the clock words); the whole generic Z
   entry table (0x58 entries of 0x4a bytes: type 10, callback 0x44e035, surface, flags 0/0/1/1, word 0 and the label are the stores of the
   original; the allocator and releaser flags); the idle-timer object 0x61c387..+0x460; the pointer and cursor cells 0x5c39e5 0x5b44f0
   0x5b44f4 and the three host-composed cells 0x5d162d 0x5d1631 0x5d1639 against their documented composition from the native outputs
   ([0x5d0377] copy, 0x5b160c + (kind << 5) + (sub << 4), 1);
 * every byte of every row (0x8d bytes except the dependency record the gate and the reset own) against a model and the whole row body
   (the original never writes it); garbage in the unlisted bytes proves nothing else is touched; every write outside the listed cells fails
   the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (arm entries, true-gate visits, handler entry with row and phase, every effect of the
   AlcEffect list: the start flag, slot, the code point after the entry label copy (0x44db81) and after the slot surface store (0x44dbc0),
   the image loader, the sound routines, GetTickCount, the clock word stores, the scene cells, the engine mode, the event flag window, the
   row phase dword, the releasers, the idle-timer touch, the blits, then the completion byte, the dependency reset and the phase store of
   0x42ba3a) against the sequence the native kernel reports for the same visit, entry for entry; the scripted queues (tick, busy, handle)
   are consumed identically by both sides (the idle touch consumes one GetTickCount value on both sides when the object's +0x1c is nonzero);
 * pointer: the return value (1 claims), the candidate 0x5c39e5 (0x276e), the cursor cells, over and the dirty byte;
 * click: the sound calls, the tick, the press deadline and the state in the object image;
 * render: every recorded 0x4c5377 blit (this, source surface, source rectangle contents, target, destination rectangle contents, label
   pointer and string) against alc_render's result, including the view origin; the object's restore and dirty bytes.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load image (thiscall ECX 0x5cf659, ret 0x10)   R 0x4c2dfb release image (ret 4, records and zeroes the cell)
  R 0x4fb77a / 0x4fba69 / 0x4fb2e3 sound prepare / stop / play (ECX 0x5c3a67, ret 4)   R 0x4f6334 sound busy (ECX 0x5cf1eb, ret 4)
  R 0x4c5377 blit recorder (ECX 0x5cf659, ret 0x14)   R 0x51dc6c free (recorded)   R GetTickCount (import thunk stub) scripted values
  O 0x42a66e / 0x428692 arm entries, 0x42a692 / 0x4286b5 post-gate points, 0x44da08 handler entry, 0x42a6a4 handler return, 0x42ba3a generic
    completion, 0x42babe (its ret), 0x423d33 dependency reset, 0x44db81 / 0x44dbc0 code points inside the handler, 0x4d3992 releaser entry,
    0x4d3d20 (idle stamp, the GetTickCount inside is not an effect), 0x44d150 (join after the idle touch); every store to the process data
    region is observed (read-only)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle plus the scripted GetTickCount; any other import fails the run. The debug flag
 0x63a4cd is 0. The strings the kernel hard-codes ("ALARM CLOCK OVERLAYS" at 0x5495bc, "NO SOUND\\0" at 0x5495b0 0x5495f0 0x5495fc 0x549608,
 the loader's kind / label, the 18 blit labels) are checked against the image at start-up.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, tick and busy values, the view
origin, the target surface handle (cell 0x5cf665), the background / entry 1 surface (0x5d15e3), the busy seeds of the Z entry table, the
event flag window contents, the clock words, the idle object contents.

KNOWN DIVERGENCES (native safety layer; never silently skipped. Checked natively in refusal_checks(); the oracle's scenarios skip the actions
the kernel refuses (counted in stats.skipped_native_refusal) instead of running them against the original):
  K1 alc_validate_body: short body, name / button sound / final sound without NUL in its 0x21 bytes -> ALC_ERR_BODY (step) / ALC_ERR_ARGUMENT
     (others), no effect.
  K2 phase 1 / 2 on an object phase 0 did not initialise for the row -> ALC_ERR_UNSUPPORTED, no effect.
  K3 phase 2 with an event flag index (set / cancel block, whichever the object takes) outside the host window 0..4095 and not -1 ->
     ALC_ERR_BOUNDS before the first effect.
  K4 render whose hour index is outside 0..11 or quarter outside 0..3 in the shown time (the original indexes past the body) -> ALC_ERR_BOUNDS,
     no change.
  K5 (reserved: the 0xd0 text limit has no counterpart here).
  K6 host failures -> ALC_ERR_HOST, allocator exhaustion (the original reaches the fatal path 0x52139c) -> ALC_ERR_HOST.
  K7 render with the slot -1: native does nothing (valid = 0), the original would index the entry table at -1; invalidate / cleanup with a slot
     outside the entry table are skipped likewise.
 All of these are unreachable in the game (loader-built 763-byte bodies, callbacks only for allocated entries).

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69,
0x4fb2e3, 0x4f6334), the blit body 0x4c5377, the cascade 0x4f0059 and the accepted-release chain 0x43b273 that call 0x44d28c / 0x44d624 (the
oracle calls the methods directly), the generic Z entry drawer that calls 0x44e035 (the oracle calls it itself), the scene clears 0x438b5d /
0x43de52 and the invalidate caller 0x43d910 (the methods are run directly), the loader 0x44d1d1 / 0x40b34a that builds the body, the
engine consumers of the scene-change cells and of the clock words, the host composition of the cursor cells (their documented composition is
checked, not the engine code that reads them), and the body of 0x4d3c31 beyond its read of +0x1c (it is original code and runs).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57. The real body of resource 1535 (row 3) is read
at run time from work/analysis/hiff-resources/1535.bin when present (never committed); scenarios that use it are skipped otherwise.

Modes: --quick-only runs the scenarios flagged quick (seconds); the default run is every scenario plus the native-only refusal checks;
--workers N shards the scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does
this); --discover-pins prints the PINS_TABLE of the original code the scenarios execute (function spans from the decompiled function index).
The pins are verified at start-up; a mismatch aborts the run. The planted-mutant sweep is tests/action_family_aa_runtime_mutation_check.py.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_aa_runtime_original_oracle.py --quick-only
  python3 action_family_aa_runtime_original_oracle.py --workers 4 --result ../../../work/analysis/slices/RT-52.oracle-result.json
  python3 action_family_aa_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
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
BODY_LEN = 763
BODY_STRIDE = 0x800
M32 = 0xFFFFFFFF
REAL_BODY_FILE = ROOT / 'work/analysis/hiff-resources/1535.bin'

# ---- original code addresses
DISPATCHER, HANDLER, GENERIC_COMPLETION, DEP_RESET, GENERIC_RET = 0x427A50, 0x44DA08, 0x42BA3A, 0x423D33, 0x42BABE
HANDLER_RETURN = 0x42A6A4
ARM = {0xAA: 0x42A66E, 0x67: 0x428692}
VISIT = {0xAA: 0x42A692, 0x67: 0x4286B5}
M_POINTER, M_CLICK, M_RENDER, M_INVALIDATE, M_CLEANUP = 0x44D28C, 0x44D624, 0x44E035, 0x44D19D, 0x44D154
AT_REGISTER, AT_SLOT_SURFACE = 0x44DB81, 0x44DBC0
RELEASE_SLOT_FN = 0x4D3992
IDLE_ENTER, IDLE_DONE = 0x4D3D20, 0x44D150
LOAD_IMAGE, RELEASE_IMAGE = 0x4C2790, 0x4C2DFB
SND_PREPARE, SND_STOP, SND_PLAY, SND_BUSY = 0x4FB77A, 0x4FBA69, 0x4FB2E3, 0x4F6334
BLIT, FREE = 0x4C5377, 0x51DC6C

# ---- process data cells
DATA_REGION_LO, DATA_REGION_HI = 0x52A000, 0x63F000
OBJ = 0x624CBF
OBJ_LEN = 0x53
IDLE_OBJ = 0x61C387
IDLE_LEN = 0x460
ENTRY, STRIDE, NENT = d9.ENTRY, d9.STRIDE, d9.NENT
CELL_START, CELL_MODE, CELL_ROWCOUNT = 0x5BB1CA, 0x583999, d9.G_ROWCOUNT
CELL_HOUR, CELL_MINUTE = 0x585D51, 0x585D4F
CELL_BG, CELL_TARGET = 0x5D15E3, 0x5CF665
CELL_ORG_X, CELL_ORG_Y = 0x583186, 0x58318A
CELL_CAND, CELL_CURSOR0, CELL_CURSOR1 = 0x5C39E5, 0x5B44F0, 0x5B44F4
CELL_5D162D, CELL_5D1631, CELL_5D1639, CELL_5D0377 = 0x5D162D, 0x5D1631, 0x5D1639, 0x5D0377
CURSOR_TABLE = 0x5B160C
XFER = (('5bb57b', 0x5BB57B, 4), ('5bb599', 0x5BB599, 2), ('5bb595', 0x5BB595, 2), ('5c39ff', 0x5C39FF, 2), ('5bb59b', 0x5BB59B, 4),
        ('5bb59f', 0x5BB59F, 4), ('5bb5a3', 0x5BB5A3, 4))
THIS_SURF, THIS_SND, THIS_BUSY = 0x5CF659, 0x5C3A67, 0x5CF1EB
TARGET_HANDLE = 0x7A000022
BG_HANDLE = 0x7A000011
LABEL_KIND, LABEL_SURFACE, LABEL_ENTRY = b'CIFTREE', b'Alarm Clock Surface', b'ALARM CLOCK OVERLAYS'
NO_SOUND = b'NO SOUND\0'
CAND_BUTTON = 0x276E
HOUR_BYTE, MINUTE_BYTE = CELL_HOUR - EVENTS_VA, CELL_MINUTE - EVENTS_VA

# the numbers of AlcEffect
FX = dict(START_FLAG=1, SLOT=2, SLOT_REGISTER=3, SURFACE_LOAD=4, SLOT_SURFACE=5, PHASE=6, SOUND_PREPARE=7, SOUND_STOP=8, SOUND_PLAY=9,
          SOUND_BUSY=10, TICK=11, X57B=12, X599=13, X595=14, X39FF=15, X59B=16, X59F=17, X5A3=18, MODE=19, EVENT_FLAG=20, COMPLETE=21,
          RELEASE_SURFACE=22, RELEASE_SLOT=23, IDLE_TIMER=24, HOUR_STORE=25, MINUTE_STORE=26, BLIT=27)
FXN = {v: k for k, v in FX.items()}
WORD_FIRST = {FX['SLOT'], FX['SLOT_REGISTER'], FX['SLOT_SURFACE'], FX['SOUND_PLAY'], FX['COMPLETE'], FX['X599'], FX['X595'], FX['X39FF'],
              FX['RELEASE_SLOT'], FX['EVENT_FLAG'], FX['HOUR_STORE'], FX['MINUTE_STORE']}
FX_SIZE = {k: (2, 4) for k in WORD_FIRST}
WRITE_FX = {CELL_START: (FX['START_FLAG'], 4), CELL_MODE: (FX['MODE'], 4), 0x5BB57B: (FX['X57B'], 4), 0x5BB599: (FX['X599'], 2),
            0x5BB595: (FX['X595'], 2), 0x5C39FF: (FX['X39FF'], 2), 0x5BB59B: (FX['X59B'], 4), 0x5BB59F: (FX['X59F'], 4),
            0x5BB5A3: (FX['X5A3'], 4)}
# the kinds that are also host calls (the host-call log of the driver uses the same numbers)
HOST_FX = {FX['SLOT'], FX['SLOT_REGISTER'], FX['SURFACE_LOAD'], FX['SLOT_SURFACE'], FX['SOUND_PREPARE'], FX['SOUND_STOP'], FX['SOUND_PLAY'],
           FX['SOUND_BUSY'], FX['TICK'], FX['EVENT_FLAG'], FX['RELEASE_SURFACE'], FX['RELEASE_SLOT'], FX['IDLE_TIMER']}
HC_MARK_DIRTY, HC_ORIGIN = 100, 101

# blit labels: address -> (kind of AlcBlitKind, text)
BLIT_LABELS = {0x549614: (1, b'AM Overlay'), 0x549620: (2, b'PM Overlay'), 0x54962C: (3, b'Time Mode Light Overlay'),
               0x549644: (4, b'Alarm Mode Light Overlay'), 0x549660: (5, b'Clock Hour Digits Overlays'),
               0x54967C: (6, b'Clock Minute Digits Overlays'), 0x5496C8: (7, b'Clock Time Mode Down'),
               0x5496B0: (8, b'Clock Alarm Mode Down'), 0x5496E0: (9, b'Clock Alarm Set Down'),
               0x5496F8: (10, b'Clock Alarm Increase Down'), 0x549714: (11, b'Clock Alarm Decrease Down'),
               0x54969C: (12, b'Clock Cancel Down'), 0x549730: (13, b'Cancel up'), 0x54973C: (14, b'Alarm button up'),
               0x54974C: (15, b'Time button up'), 0x54975C: (16, b'Set button up'), 0x54976C: (17, b'Increase button up'),
               0x549780: (18, b'Decrease button up')}

GATE_SCRATCH_WRITES = {'0x5c3a47/4', '0x637871/4', '0x637875/4', '0x63787d/4', '0x637e81/4'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {LOAD_IMAGE: (0x108, 0x10), RELEASE_IMAGE: (0x60, 4), SND_PREPARE: (0x2ef, 4), SND_STOP: (0x1d, 4), SND_PLAY: (0xb4, 4),
             SND_BUSY: (0x138, 4), BLIT: (0x214, 0x14), FREE: (0xb, 0)}
POPS = {LOAD_IMAGE: 0x10, RELEASE_IMAGE: 4, SND_PREPARE: 4, SND_STOP: 4, SND_PLAY: 4, SND_BUSY: 4, BLIT: 0x14, FREE: 0}
WANT_ECX = {LOAD_IMAGE: THIS_SURF, RELEASE_IMAGE: THIS_SURF, SND_PREPARE: THIS_SND, SND_STOP: THIS_SND, SND_PLAY: THIS_SND,
            SND_BUSY: THIS_BUSY, BLIT: THIS_SURF}

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
    (0x44d107, 0x44d154, 'b8659b6b25caa4c455d2b9622920b146da78eff2e4e21ca2cdaa827d7556d096'),
    (0x44d154, 0x44d19d, 'a5e0960dfa0fd46999dac01f36b7dca12e590c248e74c73303658d66fcce6d1e'),
    (0x44d19d, 0x44d1d1, '249943da1f881b09d241d1ebeae9ece0805f770c39489fd451e48a47a5da9a32'),
    (0x44d28c, 0x44d597, '5122b89df40c45c230f74e9cc21d9a09296e413aaa44038595344255321cf200'),
    (0x44d597, 0x44d624, 'fdd609c73c693ddb44cdd811fe51f8c9d12eef51a67ca73ca9030c31bd4954e4'),
    (0x44d624, 0x44d711, '5e2e0bcb06613a9fc6bb1fa2b89eae56bd1f6f5c0629433ba3aef70f4c64f2e4'),
    (0x44d711, 0x44d8ad, '06e25bdc66b7fa2b9850cb38dd36d767353318e5256fcb572540d2e961d94d0e'),
    (0x44d8ad, 0x44d946, 'ae511437a9a901f309142c541ae0971ede882f8d55d31f867f4b0b27d8a9e375'),
    (0x44d946, 0x44d9b5, '20ce27beea49c61c6d93cea1d7e5b42ab173823a26a7f653d0078d23f6dc6f5f'),
    (0x44d9b5, 0x44da08, '30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57'),
    (0x44da08, 0x44e025, '7b9503e2e027595bd67bc7be695113fbc8ac466700059ddd3e48e6d89585e6e5'),
    (0x44e035, 0x44e650, '58af4373c70f898c3e0ed560376335b7bf43cc22e04e3ca89f5a76f82d2c693c'),
    (0x4c2790, 0x4c2898, '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
    (0x4c2dfb, 0x4c2e5b, '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
    (0x4c5377, 0x4c558b, 'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
    (0x4d3992, 0x4d39f9, 'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
    (0x4d39f9, 0x4d3a52, '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
    (0x4d3c31, 0x4d3c42, '55b6e58404a3e0e3a48be30a93afd471c029dbaec0b52893db79c4f37241b821'),
    (0x4d3d20, 0x4d3d3d, '2a9b1b092c2d90c8120150375153f2ee790ce81e1bae154c2b7569f49645daaf'),
    (0x4f6334, 0x4f646c, '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
    (0x4fb2e3, 0x4fb397, 'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
    (0x4fb77a, 0x4fba69, '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
    (0x4fba69, 0x4fba86, '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


class Mismatch(Exception):
    pass


# ---- object layout (offsets from 0x624cbf)
OBJ_FIELDS = (('slot', 0x1C, 2), ('row', 0x1E, 2), ('surface', 0x20, 4), ('dirty', 0x24, 1), ('active', 0x25, 4), ('over', 0x29, 4),
              ('state', 0x2D, 4), ('button', 0x31, 4), ('thour', 0x35, 2), ('tquarter', 0x37, 2), ('tam', 0x39, 4), ('ahour', 0x3D, 2),
              ('aquarter', 0x3F, 2), ('aam', 0x41, 4), ('restore', 0x45, 4), ('canceled', 0x49, 1), ('set', 0x4A, 1), ('pdl', 0x4B, 4),
              ('fdl', 0x4F, 4))
OBJ_POS = {n: (o, s) for n, o, s in OBJ_FIELDS}
SIGNED = {'slot', 'row', 'state', 'button', 'thour', 'tquarter', 'ahour', 'aquarter'}


def fld(img, name):
    off, size = OBJ_POS[name]
    return int.from_bytes(bytes(img[off:off + size]), 'little', signed=name in SIGNED)


def put_fld(img, name, v):
    off, size = OBJ_POS[name]
    img[off:off + size] = (v & mask(size)).to_bytes(size, 'little')


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0xaa hooks."""

    def __init__(self):
        self.qs = {k: [] for k in ('tick', 'busy', 'handle')}
        self.qpos = Counter()
        self.in_complete = False
        self.in_idle = False
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
        want = [(0x5495BC, LABEL_ENTRY + b'\0'), (0x5495D4, LABEL_SURFACE + b'\0'), (0x5495E8, LABEL_KIND + b'\0')]
        want += [(va, NO_SOUND) for va in (0x5495B0, 0x5495F0, 0x5495FC, 0x549608)]
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
        self.idle_ticks = []
        self.in_complete = False
        self.in_idle = False
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
            if self.in_idle:
                self.idle_ticks.append(v)
            else:
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
                      AT_SLOT_SURFACE: self._at_slot_surface, RELEASE_SLOT_FN: self._release_slot, IDLE_ENTER: self._idle_enter,
                      IDLE_DONE: self._idle_done})
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
            raise d9.OracleError('handler entered with ECX != 0x624cbf')
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

    def _idle_enter(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != IDLE_OBJ:
            raise d9.OracleError('idle stamp entered with ECX != 0x61c387')
        self.in_idle = True

    def _idle_done(self, uc, address, size, user):
        self.in_idle = False
        self.events.append(('fx', FX['IDLE_TIMER'], 0, 0))

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
            self.events.append(('fx', FX['SOUND_BUSY'], a[0], eax))
        elif address == BLIT:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            if a[4] not in BLIT_LABELS:
                raise d9.OracleError('blit with an unknown label %#x' % a[4])
            kind, text = BLIT_LABELS[a[4]]
            self.blits.append(dict(this=ecx, src_surface=a[0], target=a[1], src=rect(a[2]), dst=rect(a[3]), label=text, label_ptr=a[4],
                                   kind=kind))
            self.events.append(('fx', FX['BLIT'], kind, 0))
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
        if size == 2 and address == CELL_HOUR:
            self.events.append(('fx', FX['HOUR_STORE'], value, 0))
            return                              # the clock words are compared inside the event flag window
        if size == 2 and address == CELL_MINUTE:
            self.events.append(('fx', FX['MINUTE_STORE'], value, 0))
            return
        if EVENTS_VA <= address < EVENTS_VA + 4 * EVENT_COUNT and size == 4 and (address - EVENTS_VA) % 4 == 0:
            self.events.append(('fx', FX['EVENT_FLAG'], (address - EVENTS_VA) // 4, value))
            return
        off = address - OBJ
        if 0 <= off < OBJ_LEN and off == 0x1C and size == 2 and self.cur_phase == 0:
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
SOURCES = ('action_family_aa_runtime.c',)
OK, ERR_ARGUMENT, ERR_BODY, ERR_UNSUPPORTED, ERR_HOST, ERR_BOUNDS = 0, 1, 2, 3, 4, 5
(F_ALLOC, F_REGISTER, F_LOAD, F_SETSURF, F_RELEASE_SURFACE, F_RELEASE_SLOT, F_DIRTY, F_ORIGIN, F_PREPARE, F_STOP, F_PLAY, F_BUSY,
 F_TRANSITION, F_FLAG, F_IDLE) = [1 << k for k in range(15)]
QKINDS = ('tick', 'busy', 'handle')


def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('gcc') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}',
           str(PROJECT / 'tests/action_family_aa_runtime_oracle_driver.c'), *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if strict:
        cmd.insert(5, '-Werror')
    if os.environ.get('AA_SANITIZE'):
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
        lib.aao_new.restype = P
        for name, args, res in (
                ('aao_free', [P], None), ('aao_reset', [P], None), ('aao_clear_logs', [P], None), ('aao_set_fail', [P, C.c_int], None),
                ('aao_set_origin', [P, I32, I32], None), ('aao_q_set', [P, C.c_int, I64P, C.c_int], None),
                ('aao_q_pos', [P, C.c_int], C.c_int), ('aao_q_underflow', [P, C.c_int], C.c_int),
                ('aao_obj_get', [P, C.c_char_p], None), ('aao_obj_set', [P, C.c_char_p], None),
                ('aao_extra_get', [P, U32P], None), ('aao_extra_set', [P, U32P], None),
                ('aao_cells_get', [P, I32P], None), ('aao_cells_set', [P, I32P], None),
                ('aao_events_get', [P, C.c_char_p], None), ('aao_events_set', [P, C.c_char_p], None),
                ('aao_entries_get', [P, C.c_char_p], None), ('aao_entries_set', [P, C.c_char_p], None),
                ('aao_entry_set_u32', [P, C.c_int, C.c_int, U32], None),
                ('aao_idle_get', [P, C.c_char_p], None), ('aao_idle_set', [P, C.c_char_p], None),
                ('aao_log', [P, C.c_int, I32P, C.c_int], C.c_int), ('aao_str', [P, C.c_int], C.c_char_p),
                ('aao_nstr', [P], C.c_int), ('aao_errors', [P, I32P], None),
                ('aao_step', [P, C.c_char_p, C.c_int, C.c_int, U32, I32P], None),
                ('aao_pointer', [P, C.c_char_p, C.c_int, I32, I32, I32P], None),
                ('aao_click', [P, C.c_char_p, C.c_int, U32, I32P], None),
                ('aao_invalidate', [P], C.c_int), ('aao_cleanup', [P], C.c_int), ('aao_validate', [C.c_char_p, C.c_int], C.c_int),
                ('aao_render', [P, C.c_char_p, C.c_int, I32P], None)):
            fn = getattr(lib, name)
            fn.argtypes, fn.restype = args, res
        self.h = lib.aao_new()
        if not self.h:
            raise d9.OracleError('native driver could not start')

    def close(self):
        self.lib.aao_free(self.h)

    def reset(self):
        self.lib.aao_reset(self.h)

    def clear_logs(self):
        self.lib.aao_clear_logs(self.h)

    def set_fail(self, m):
        self.lib.aao_set_fail(self.h, m)

    def set_origin(self, x, y):
        self.lib.aao_set_origin(self.h, x, y)

    def set_queues(self, qs):
        for i, k in enumerate(QKINDS):
            vals = list(qs.get(k, []))[:64]
            arr = (C.c_int64 * max(len(vals), 1))(*[sgn(v, 4) for v in vals])
            self.lib.aao_q_set(self.h, i, arr, len(vals))

    def qpos(self, k):
        return self.lib.aao_q_pos(self.h, QKINDS.index(k))

    def qunder(self, k):
        return self.lib.aao_q_underflow(self.h, QKINDS.index(k))

    def obj(self):
        buf = C.create_string_buffer(OBJ_LEN)
        self.lib.aao_obj_get(self.h, buf)
        return bytes(buf.raw)[:OBJ_LEN]

    def set_obj(self, img):
        self.lib.aao_obj_set(self.h, bytes(img))

    def extra(self):
        arr = (C.c_uint32 * 3)()
        self.lib.aao_extra_get(self.h, arr)
        return list(arr)

    def set_extra(self, vals):
        arr = (C.c_uint32 * 3)(*[v & M32 for v in vals])
        self.lib.aao_extra_set(self.h, arr)

    def cells(self):
        arr = (C.c_int32 * 9)()
        self.lib.aao_cells_get(self.h, arr)
        return list(arr)

    def set_cells(self, vals):
        arr = (C.c_int32 * 8)(*[sgn(v, 4) for v in vals])
        self.lib.aao_cells_set(self.h, arr)

    def events(self):
        buf = C.create_string_buffer(4 * EVENT_COUNT)
        self.lib.aao_events_get(self.h, buf)
        return bytes(buf.raw)[:4 * EVENT_COUNT]

    def set_events(self, data):
        self.lib.aao_events_set(self.h, bytes(data))

    def entries(self):
        n = NENT * STRIDE
        buf = C.create_string_buffer(n)
        self.lib.aao_entries_get(self.h, buf)
        return bytes(buf.raw)[:n]

    def set_entries(self, data):
        self.lib.aao_entries_set(self.h, bytes(data))

    def entry_set(self, slot, off, v):
        self.lib.aao_entry_set_u32(self.h, slot, off, v & M32)

    def idle(self):
        buf = C.create_string_buffer(IDLE_LEN)
        self.lib.aao_idle_get(self.h, buf)
        return bytes(buf.raw)[:IDLE_LEN]

    def set_idle(self, data):
        self.lib.aao_idle_set(self.h, bytes(data))

    def log(self, which):
        arr = (C.c_int32 * (3 * 1024))()
        n = self.lib.aao_log(self.h, which, arr, 1024)
        if n < 0:
            raise d9.OracleError('native log overflow')
        return [tuple(arr[3 * i:3 * i + 3]) for i in range(n)]

    def names(self):
        n = min(self.lib.aao_nstr(self.h), 8)
        return [self.lib.aao_str(self.h, i) for i in range(n)]

    def errors(self):
        arr = (C.c_int32 * 3)()
        self.lib.aao_errors(self.h, arr)
        return tuple(arr)

    def step(self, body, row, phase):
        out = (C.c_int32 * 4)()
        self.lib.aao_step(self.h, bytes(body), len(body), row, phase & M32, out)
        return tuple(out)

    def pointer(self, body, x, y):
        out = (C.c_int32 * 6)()
        self.lib.aao_pointer(self.h, bytes(body), len(body), sgn(x, 4), sgn(y, 4), out)
        return tuple(out)

    def click(self, body, row_phase):
        out = (C.c_int32 * 3)()
        self.lib.aao_click(self.h, bytes(body), len(body), row_phase & M32, out)
        return tuple(out)

    def invalidate(self):
        return self.lib.aao_invalidate(self.h)

    def cleanup(self):
        return self.lib.aao_cleanup(self.h)

    def validate(self, body):
        return self.lib.aao_validate(bytes(body), len(body))

    def render(self, body):
        out = (C.c_int32 * (3 + 10 * 10))()
        self.lib.aao_render(self.h, bytes(body), len(body), out)
        blits = []
        for i in range(out[2] if 0 <= out[2] <= 10 else 0):
            o = out[3 + 10 * i:13 + 10 * i]
            blits.append(dict(kind=o[0], src_surface=o[1] & M32, src=tuple(o[2:6]), dst=tuple(o[6:10])))
        return dict(status=out[0], valid=out[1], count=out[2], blits=blits)


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
POS_NAMES = ('minute_dst', 'hour_dst', 'ampm_dst', 'time_btn', 'alarm_btn', 'set_btn', 'cancel_btn', 'incr_btn', 'decr_btn', 'light_dst')
POS_OFF = {n: 0x21 + 16 * k for k, n in enumerate(POS_NAMES)}
BUTTON_OF = {'time_btn': 0, 'alarm_btn': 1, 'incr_btn': 3, 'decr_btn': 4, 'set_btn': 6, 'cancel_btn': 8}
B_BTN_SOUND, B_BTN_CH, B_PRESS, B_CURSOR = 0x265, 0x286, 0x261, 0x263
B_SET, B_CANCEL, B_FDELAY, B_FSOUND, B_FCH = 0x296, 0x2E2, 0x2AF, 0x2B1, 0x2D2
TEMPLATE = {'minute_dst': (346, 146, 438, 221), 'hour_dst': (226, 146, 318, 221), 'ampm_dst': (440, 146, 488, 221),
            'time_btn': (40, 150, 170, 185), 'alarm_btn': (40, 190, 170, 225), 'set_btn': (170, 240, 330, 270),
            'cancel_btn': (332, 240, 490, 270), 'incr_btn': (516, 144, 575, 184), 'decr_btn': (516, 200, 575, 240),
            'light_dst': (190, 148, 218, 220)}
EXTREME_RECTS = ((-0x80000000, -0x80000000, 0x7FFFFFFF, 0x7FFFFFFF), (0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF),
                 (-0x80000000, 0, -0x7FFFFFF0, 40), (0, 0, 0, 0), (-1, -1, 0, 0), (40000, 40000, 50000, 50000),
                 (-50000, -50000, -40000, -40000), (7, 7, 7, 7))

_REAL = []


def real_body():
    """The 763-byte body of the only real raw 0xaa row (resource 1535, row 3), read from the local evidence; None when absent."""
    if not _REAL:
        body = None
        try:
            data = REAL_BODY_FILE.read_bytes()
            at = data.find(b'BLU_AlarmClock_OVL')
            if at >= 0 and at + BODY_LEN <= len(data):
                body = data[at:at + BODY_LEN]
        except OSError:
            body = None
        _REAL.append(body)
    return _REAL[0]


def snd(kind):
    return {'none': NO_SOUND, 'real': b'Beep12\0\0\0', 'real2': b'bell_77\0\0', 'near1': b'NO SOUND\x01', 'near2': b'NO SOUNE\0',
            'near3': b'no sound\0', 'zero': bytes(9), 'near4': b'NO SOUN\0\0', 'long': b'k' * 32 + b'\0'}[kind]


def put_snd(b, off, kind):
    """A sound record: the name, a terminator inside the 0x21 bytes (the native validator needs one; the original compares 9 bytes)."""
    data = snd(kind)
    b[off:off + len(data)] = data
    if 0 not in b[off:off + 0x21]:
        b[off + 0x20] = 0


def snd_patch(kind):
    return snd(kind) + b'\0'


SND_KINDS = ('none', 'real', 'real2', 'near1', 'near2', 'near3', 'zero', 'near4')


def block(scene, words=(0, 0, 0), dwords=(0, 0, 0), start=0):
    return dict(scene=scene, words=words, dwords=dwords, start=start)


def rand_block(rng, scene):
    return block(scene, tuple(rng.choice((0, 1, 0x1234, 0x8000, 0xFFFF, rng.getrandbits(16))) for _ in range(3)),
                 tuple(rng.choice((0, 1, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFE, rng.getrandbits(32))) for _ in range(3)),
                 rng.choice((0, 1, 2, 0xFFFF, 0x8001)))


def layout_rects(kind, rng):
    t = TEMPLATE
    if kind == 'tight':
        return dict(t)
    if kind == 'grid':
        return {n: tuple(v + rng.randint(-3, 3) for v in r) for n, r in t.items()}
    if kind == 'adjacent':          # buttons share edge rows / columns: inclusive bounds and the hit order matter
        d = dict(t)
        d['alarm_btn'] = (t['time_btn'][0], t['time_btn'][3], t['time_btn'][2], 225)
        d['set_btn'] = (t['time_btn'][2], 240, 330, 270)
        d['cancel_btn'] = (330, 240, 490, 270)
        d['incr_btn'] = (516, 144, 575, 200)
        d['decr_btn'] = (516, 200, 575, 240)
        d['hour_dst'] = (226, 146, 346, 221)
        d['minute_dst'] = (346, 146, 438, 221)
        return d
    if kind == 'overlap':
        return {n: (50 + rng.choice((0, 0, 1)), 50 + rng.choice((0, 0, 1)), 100 - rng.choice((0, 0, 1)), 100 - rng.choice((0, 0, 1)))
                for n in POS_NAMES}
    if kind == 'neg':
        return {n: (r[0] - 700, r[1] - 300, r[2] - 700, r[3] - 300) for n, r in t.items()}
    if kind == 'extreme':
        return {n: rng.choice(EXTREME_RECTS) for n in POS_NAMES}
    if kind == 'inverted':
        return {n: (r[2], r[3], r[0], r[1]) if rng.random() < 0.5 else r for n, r in t.items()}
    if kind == 'wide':               # hit rectangles far bigger than the gate hull: the gate decides
        d = dict(t)
        d['time_btn'] = (-30000, -30000, 30000, 30000)
        d['alarm_btn'] = (-20000, -20000, 20000, 20000)
        return d
    if kind == 'real':
        body = real_body()
        if body is None:
            return dict(t)
        return {n: struct.unpack_from('<4i', body, POS_OFF[n]) for n in POS_NAMES}
    raise ValueError(kind)


def rand_rect(rng):
    return tuple(rng.choice((rng.randint(-2000, 2000), rng.getrandbits(32) - 0x80000000, 0x7FFFFFF0, -0x7FFFFFF0, 0)) for _ in range(4))


def make_body(rng, name=b'BLU_Clock', layout='grid', btn_snd='none', btn_ch=1, press=1, cursor=4, set_blk=None, set_flag=(-1, 0),
              fdelay=1, fsnd='none', fch=2, cancel_blk=None, cancel_flag=(-1, 0), base=None, set_start=None, cancel_start=None):
    b = bytearray(base if base is not None else bytes(rng.getrandbits(8) for _ in range(BODY_LEN)))
    if base is None:
        b[0:0x21] = bytes(name[:0x20]).ljust(0x21, b'\0')
        for k in range(len(name) + 1, 0x21):
            b[k] = rng.getrandbits(8)                       # garbage after the terminator
        for n, r in layout_rects(layout, rng).items():
            struct.pack_into('<4i', b, POS_OFF[n], *[sgn(v, 4) for v in r])
        for off in [0xC1 + 16 * k for k in range(4)] + [0x101 + 16 * k for k in range(12)] + \
                [0x1C1 + 16 * k for k in range(14)]:        # sources: AM PM down x6 lights
            struct.pack_into('<4i', b, off, *[sgn(v, 4) for v in rand_rect(rng)])
    struct.pack_into('<h', b, B_PRESS, sgn(press, 2))
    struct.pack_into('<h', b, B_CURSOR, sgn(cursor, 2))
    put_snd(b, B_BTN_SOUND, btn_snd)
    struct.pack_into('<h', b, B_BTN_CH, sgn(btn_ch, 2))

    def put(off, blk, flag, val, start):
        struct.pack_into('<h', b, off, sgn(blk['scene'], 2))
        struct.pack_into('<3h', b, off + 2, *[sgn(w, 2) for w in blk['words']])
        struct.pack_into('<3I', b, off + 8, *[d & M32 for d in blk['dwords']])
        struct.pack_into('<h', b, off + 20, sgn(blk['start'] if start is None else start, 2))
        struct.pack_into('<h', b, off + 22, sgn(flag, 2))
        b[off + 24] = val & 0xFF
    put(B_SET, set_blk if set_blk is not None else block(9999), set_flag[0], set_flag[1], set_start)
    struct.pack_into('<h', b, B_FDELAY, sgn(fdelay, 2))
    put_snd(b, B_FSOUND, fsnd)
    struct.pack_into('<h', b, B_FCH, sgn(fch, 2))
    put(B_CANCEL, cancel_blk if cancel_blk is not None else block(9999), cancel_flag[0], cancel_flag[1], cancel_start)
    return bytes(b)


def body_rect(body, name):
    return struct.unpack_from('<4i', body, POS_OFF[name])


def clamp16(v):
    return max(-32768, min(32767, v))


def center_of(rect):
    return clamp16((rect[0] + rect[2]) // 2), clamp16((rect[1] + rect[3]) // 2)


def probe_points(body, rng=None, extra=12):
    pts = []
    for n in POS_NAMES:
        l_, t_, r_, b_ = body_rect(body, n)
        pts += [center_of((l_, t_, r_, b_)), (clamp16(l_), clamp16(t_)), (clamp16(r_), clamp16(b_)), (clamp16(l_ - 1), clamp16(t_)),
                (clamp16(l_), clamp16(t_ - 1)), (clamp16(r_ + 1), clamp16(b_)), (clamp16(r_), clamp16(b_ + 1)), (clamp16(r_), clamp16(t_)),
                (clamp16(l_), clamp16(b_))]
    inc_r = body_rect(body, 'incr_btn')[2]
    can_b = body_rect(body, 'cancel_btn')[3]
    tim_l = body_rect(body, 'time_btn')[0]
    cx, cy = center_of(body_rect(body, 'alarm_btn'))
    pts += [(clamp16(inc_r + 1), cy), (clamp16(inc_r), cy), (cx, clamp16(can_b + 1)), (cx, clamp16(can_b)), (clamp16(tim_l - 1), cy),
            (clamp16(tim_l), cy), (clamp16(inc_r + 1), clamp16(can_b + 1))]
    pts += [(0x7FFFFFFF, 0x7FFFFFFF), (-0x80000000, -0x80000000), (0x8000, 0x8000), (0xFFFF, 0xFFFF), (-0x8000, 0x7FFF), (0x10000 + 300, 0x10000 + 180)]
    if rng is not None:
        pts += [(rng.randint(-100, 700), rng.randint(-100, 400)) for _ in range(extra)]
    return pts


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
DEFAULT_Q = dict(tick=[5000] * 6, busy=[0] * 6, handle=[0x1234, 0x1235, 0x1236, 0x1237])
POINTER_CELLS = {'cand': (CELL_CAND, 4), 'k0': (CELL_CURSOR0, 4), 'k1': (CELL_CURSOR1, 4), 'c162d': (CELL_5D162D, 4),
                 'c1631': (CELL_5D1631, 4), 'c1639': (CELL_5D1639, 4)}
OBJ_RANGE = (OBJ, OBJ + OBJ_LEN)
ENTRY_RANGE = (ENTRY, ENTRY + NENT * STRIDE)
IDLE_RANGE = (IDLE_OBJ, IDLE_OBJ + IDLE_LEN)
ALLOWED_WRITES = {
    'tick': [OBJ_RANGE, ENTRY_RANGE, IDLE_RANGE, (CELL_START, CELL_START + 4), (CELL_MODE, CELL_MODE + 4)] + [(va, va + sz) for _, va, sz in XFER],
    'pointer': [OBJ_RANGE] + [(va, va + sz) for va, sz in POINTER_CELLS.values()],
    'click': [OBJ_RANGE],
    'render': [OBJ_RANGE],
    'invalidate': [ENTRY_RANGE],
    'cleanup': [OBJ_RANGE, ENTRY_RANGE, IDLE_RANGE],
}


def new_stats():
    return dict(scenarios=0, ticks=0, actions=Counter(), compared_fields=0, handler_visits=Counter(), rows_gated=0, effects=Counter(),
                pointer=Counter(), clicks=Counter(), renders=Counter(), blits=0, mismatches=0, native_refusal_checks=0, known_divergences=Counter(),
                queue_values_consumed=0, groups={}, ordered_events=0, skipped_native_refusal=Counter(), states=Counter(), outcomes=Counter(),
                slots=Counter(), clock=Counter(), blit_kinds=Counter())


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

    def aa_rows(self):
        return [i for i, r in enumerate(self.rows) if r['type'] == 0xAA]

    def body_for(self, nat_img):
        """The body the kernel is shown: the row of an active object, else the first 0xaa row (the original returns early)."""
        row, active = fld(nat_img, 'row'), fld(nat_img, 'active')
        if active and 0 <= row < len(self.rows) and self.rows[row]['type'] == 0xAA:
            return row
        if active:
            raise d9.OracleError('scenario activates the object for a row that is not a 0xaa row')
        return self.aa_rows()[0]


def garbage_obj(rng):
    img = bytearray(rng.getrandbits(8) for _ in range(OBJ_LEN))
    g = dict(slot=rng.choice((-1, -1, -1, 0x19, 0x30)), row=rng.choice((-1, 0, 1, 3, 5)), surface=rng.choice((0, 0x5151, M32)),
             dirty=rng.choice((0, 1, 0xFE)), active=0, over=rng.choice((0, 1, 0x100, M32)), state=rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 8, 9, M32)),
             button=rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 8, 9, M32)), thour=rng.choice((0, 5, 11, 12, -1)), tquarter=rng.choice((0, 1, 2, 3, 4, -1)),
             tam=rng.choice((0, 1, 7)), ahour=rng.choice((0, 5, 11, 12, -1)), aquarter=rng.choice((0, 1, 2, 3, 4, -1)), aam=rng.choice((0, 1, 7)),
             restore=rng.choice((0, 1, 0x100, M32)), canceled=rng.choice((0, 1, 0x7F)), set=rng.choice((0, 1, 0x80)),
             pdl=rng.choice((0, 1000, M32, rng.getrandbits(32))), fdl=rng.choice((0, 1000, M32, rng.getrandbits(32))))
    return img, g


def build_events(init, rng):
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
    pattern = build_events(init, rng)
    for idx, v in sc['events'].items():
        struct.pack_into('<i', pattern, 4 * idx, v)
    hour = init.get('hour', rng.choice((0, 1, 5, 11, 12, 13, 23, 24)))
    minute = init.get('minute', rng.choice((0, 14, 15, 16, 30, 31, 45, 46, 59)))
    struct.pack_into('<H', pattern, HOUR_BYTE, hour & 0xFFFF)
    struct.pack_into('<H', pattern, MINUTE_BYTE, minute & 0xFFFF)
    x.wr(EVENTS_VA, pattern)
    nat.set_events(pattern)
    # the singleton: garbage unless the scenario names the field
    img, g = garbage_obj(rng)
    g.update(init.get('obj', {}))
    for k, v in g.items():
        put_fld(img, k, v)
    x.wr(OBJ, bytes(img))
    nat.set_obj(bytes(img))
    # the idle-timer object: garbage, the +0x1c dword decides whether the reset stamps it
    idle = bytearray(rng.getrandbits(8) for _ in range(IDLE_LEN))
    struct.pack_into('<I', idle, 0x1C, init.get('idle', rng.choice((0, 1, 1, 0x100, M32))) & M32)
    x.wr(IDLE_OBJ, bytes(idle))
    nat.set_idle(bytes(idle))
    start = init.get('start', rng.choice((0, 1, M32, 5)))
    x.set_cell(CELL_START, start)
    nat.set_extra([start, hour, minute])
    cells = [sc['mode']]
    for _, va, sz in XFER:
        v = rng.choice((0, 0xFFFF, 0x12345678, 0x8000)) if rng.random() < 0.5 else rng.getrandbits(8 * sz)
        x.set_cell(va, v, sz)
        cells.append(sgn(v, sz))
    nat.set_cells(cells)
    x.set_cell(CELL_5D0377, init.get('c0377', 0x0BAD0377))
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


def compare_all(where, x, nat, stats, run, rows=True, light=False):
    img_x, img_n = x.obj_image(), nat.obj()
    if img_x != img_n:
        raise Mismatch('%s: object image 0x624cbf..+0x53 differs: %s' % (where, '; '.join(diff_obj(img_x, img_n))))
    stats['compared_fields'] += len(OBJ_FIELDS) + 1
    extra = nat.extra()
    check(stats, where, 'cell 0x5bb1ca (start flag)', x.cell(CELL_START), extra[0])
    check(stats, where, 'clock hour word 0x585d51', x.cell(CELL_HOUR, 2), extra[1])
    check(stats, where, 'clock minute word 0x585d4f', x.cell(CELL_MINUTE, 2), extra[2])
    for name in ('cand', 'k0', 'k1'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    if light:
        return
    cells = nat.cells()
    check(stats, where, 'engine mode 0x583999', sgn(x.cell(CELL_MODE), 4), cells[0])
    for k, (name, va, sz) in enumerate(XFER):
        check(stats, where, 'scene-change cell ' + name, sgn(x.cell(va, sz), sz), cells[1 + k] if sz == 4 else sgn(cells[1 + k], 2))
    check(stats, where, 'event flag window (4096 dwords, contains the clock words)', x.rd(EVENTS_VA, 4 * EVENT_COUNT), nat.events())
    ent = bytearray(nat.entries())
    for name in ('c162d', 'c1631', 'c1639'):         # these three cells are fields of entry 2 (the cursor entry): the host-composed values
        va, sz = POINTER_CELLS[name]
        struct.pack_into('<I', ent, va - ENTRY, run.cells[name])
    check(stats, where, 'generic Z entry table (0x58 x 0x4a bytes, cursor entry cells composed)', x.rd(ENTRY, NENT * STRIDE), bytes(ent))
    for name in ('c162d', 'c1631', 'c1639'):
        va, sz = POINTER_CELLS[name]
        check(stats, where, 'cell ' + name + ' %#x' % va, x.cell(va, sz), run.cells[name])
    check(stats, where, 'idle-timer object 0x61c387..+0x460', x.rd(IDLE_OBJ, IDLE_LEN), nat.idle())
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


def nat_set_start(nat, v):
    e = nat.extra()
    nat.set_extra([v, e[1], e[2]])


def sync_row_images(x, run):
    run.row_images = [x.rd(ROWS + i * ROW, ROW) for i in range(len(run.rows))]


def do_tick(where, x, nat, run, stats, queues, rng):
    stats['ticks'] += 1
    rows = run.rows
    sync_row_images(x, run)
    queues = {**DEFAULT_Q, **queues}
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    img = x.obj_image()
    if fld(img, 'active'):
        stats['states']['phase_visit_state_%d' % min(max(fld(img, 'state'), -1), 9)] += 1
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
                nat_set_start(nat, 1)
                expected += [('fx', FX['START_FLAG'], 1, 0), ('comp', i, 1)]
            elif typ == 0xAA:
                visit_aa(where, x, nat, run, r, i, expected, stats)
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


def visit_aa(where, x, nat, run, r, i, expected, stats):
    body, phase = r['body'], r['phase']
    pre = nat.obj()
    status, phase_after, initialized, completed = nat.step(body, i, phase)
    phase_after &= M32
    mapped, hosts, host_only, extra = native_fx(nat, run)
    if status != OK:
        raise d9.OracleError('%s: native alc_step status %d for row %d phase %d (a native refusal the scenario must avoid)' % (
            where, status, i, phase))
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
        stats['outcomes']['finish_cancel' if fld(pre, 'canceled') else 'finish_set' if fld(pre, 'set') else 'finish_plain'] += 1
    run.loaded_expected += [d9.cstr(body[:0x21]).decode('latin1')] * sum(1 for e in mapped if e[1] == FX['SURFACE_LOAD'])
    if phase == 0:
        stats['slots'][fld(nat.obj(), 'slot')] += 1
        stats['clock']['hour_%d' % nat.extra()[1] if nat.extra()[1] < 100 else 'hour_other'] += 1
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
    eax = x.run_method({}, M_POINTER, [xdw, ydw])
    status, hit, cand, written, kind, sub = nat.pointer(body, sgn(xdw, 4), sgn(ydw, 4))
    if status != OK:
        raise Mismatch('%s: native alc_pointer status %d' % (where, status))
    check(stats, where, 'pointer: return value (1 claims) versus native hit', eax, 1 if hit else 0)
    active = fld(img, 'active') != 0
    after = nat.obj()
    stats['pointer']['button' if hit else 'inactive' if not active else 'redraw' if fld(after, 'dirty') else 'none'] += 1
    if hit:
        stats['pointer']['button_%d' % fld(after, 'button')] += 1
    if active:
        stats['pointer']['over' if fld(after, 'over') else 'outside'] += 1
    if written:
        run.cells['cand'] = cand & M32
        run.cells['k0'] = kind & M32
        run.cells['k1'] = sub & M32
        run.cells['c162d'] = x.cell(CELL_5D0377)
        run.cells['c1631'] = (CURSOR_TABLE + ((kind << 5) & M32) + ((sub << 4) & M32)) & M32
        run.cells['c1639'] = 1
        check(stats, where, 'pointer: candidate is 0x276e', cand, CAND_BUTTON)
    elif hit:
        raise Mismatch('%s: native claims without writing the cursor cells' % where)
    check(stats, where, 'pointer: no stray effects', x.events, [])
    check_writes(where, x, 'pointer', stats)
    compare_all(where, x, nat, stats, run, light=light)


def do_click(where, x, nat, run, stats, queues):
    img = nat.obj()
    ri = run.body_for(img)
    r = run.rows[ri]
    queues = {**DEFAULT_Q, **queues}
    sync_row_images(x, run)
    stats['actions']['click'] += 1
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method(queues, M_CLICK, [])
    status, fired, sound = nat.click(r['body'], r['phase'])
    if status != OK:
        raise Mismatch('%s: native alc_click status %d' % (where, status))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'click: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'click: no stray host calls', extra, [])
    check(stats, where, 'click: ordered effects (busy, play, tick)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    # the result flags are native-only outputs; they must agree with what the original did (deadline tick read = guard held)
    orig = norm_events(x.events)
    check(stats, where, 'click: fired flag equals the original reading the tick', int(any(e[:2] == ('fx', FX['TICK']) for e in orig)), int(fired))
    check(stats, where, 'click: sound_played flag equals the original issuing the play',
          int(any(e[:2] == ('fx', FX['SOUND_PLAY']) for e in orig)), int(sound))
    stats['clicks']['fired' if fired else 'guarded'] += 1
    if sound:
        stats['clicks']['sound'] += 1
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    check_queues(where, x, nat, stats)
    check_writes(where, x, 'click', stats)
    compare_all(where, x, nat, stats, run)


def render_refused(img):
    """The render states the kernel refuses (known divergences K4, K7): they are skipped, never run against the original."""
    slot, state, button = fld(img, 'slot'), fld(img, 'state'), fld(img, 'button')
    if slot == -1:
        return 'render: slot -1'
    if not 0 <= slot < NENT:
        return 'render: slot outside the entry table'
    showing_time = state in (0, 8) or (state == 2 and button == 8)
    hour, quarter = (fld(img, 'thour'), fld(img, 'tquarter')) if showing_time else (fld(img, 'ahour'), fld(img, 'aquarter'))
    if not 0 <= hour <= 11 or not 0 <= quarter <= 3:
        return 'render: hour index or quarter outside the body tables'
    return False


def do_render(where, x, nat, run, stats, ox, oy):
    img = nat.obj()
    row = fld(img, 'row')
    if not 0 <= row < len(run.rows) or run.rows[row]['type'] != 0xAA:
        stats['skipped_native_refusal']['render: stale row of the object (no 0xaa row installed)'] += 1
        return
    body = run.rows[row]['body']
    why = render_refused(img)
    if why:
        stats['skipped_native_refusal'][why] += 1
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
        raise Mismatch('%s: native alc_render status %d' % (where, plan['status']))
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'render: host calls equal observed effects', hosts, host_only)
    check(stats, where, 'render: ordered effects (blits)', norm_events(x.events), mapped)
    count_effects(stats, mapped)
    check(stats, where, 'render: valid', plan['valid'], 1)
    check(stats, where, 'render: blit count', len(x.blits), plan['count'])
    check(stats, where, 'render: view origin read once', [e for e in extra if e[0] == HC_ORIGIN], [(HC_ORIGIN, sgn(ox, 4), sgn(oy, 4))])
    for k, (b, n) in enumerate(zip(x.blits, plan['blits'])):
        check(stats, where, 'render blit %d: kind (label pointer)' % k, b['kind'], n['kind'])
        check(stats, where, 'render blit %d: this pointer' % k, b['this'], THIS_SURF)
        check(stats, where, 'render blit %d: target surface' % k, b['target'], TARGET_HANDLE)
        if b['kind'] <= 12:
            check(stats, where, 'render blit %d: source surface versus native' % k, b['src_surface'], n['src_surface'])
            check(stats, where, 'render blit %d: source surface is the entry surface' % k, b['src_surface'], surface)
        else:
            check(stats, where, 'render blit %d: source surface is the background entry 1' % k, b['src_surface'], bg_cell)
            check(stats, where, 'render blit %d: native background marker' % k, n['src_surface'], 0)
        check(stats, where, 'render blit %d: source rectangle contents' % k, b['src'], n['src'])
        check(stats, where, 'render blit %d: destination rectangle contents' % k, b['dst'], n['dst'])
        stats['blits'] += 1
        stats['blit_kinds'][b['kind']] += 1
    stats['renders']['blits_%d' % plan['count']] += 1
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
        raise Mismatch('%s: native alc_invalidate failed' % where)
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
    queues = {**DEFAULT_Q, **queues}
    sync_row_images(x, run)
    nat.set_queues(queues)
    nat.clear_logs()
    run.fx_seen = run.hc_seen = 0
    x.run_method(queues, M_CLEANUP, [])
    if nat.cleanup() != OK:
        raise Mismatch('%s: native alc_cleanup failed' % where)
    mapped, hosts, host_only, extra = native_fx(nat, run)
    check(stats, where, 'cleanup: ordered effects (release surface, release slot, idle timer)', norm_events(x.events), mapped)
    check(stats, where, 'cleanup: host calls equal observed effects', hosts, host_only)
    count_effects(stats, mapped)
    check_queues(where, x, nat, stats)
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
            nat_set_start(nat, v)
        elif k in ('hour', 'minute'):
            x.set_cell(CELL_HOUR if k == 'hour' else CELL_MINUTE, v, 2)
            e = nat.extra()
            e[1 if k == 'hour' else 2] = v & 0xFFFF
            nat.set_extra(e)
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
        elif k == 'idle':
            data = bytearray(x.rd(IDLE_OBJ, IDLE_LEN))
            struct.pack_into('<I', data, 0x1C, v & M32)
            x.wr(IDLE_OBJ, bytes(data))
            nat.set_idle(bytes(data))
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


def cur_body(nat, run):
    img = nat.obj()
    row = fld(img, 'row')
    if fld(img, 'active') and 0 <= row < len(run.rows):
        return run.rows[row]['body']
    return run.rows[run.aa_rows()[0]]['body']


def advance(run, rng):
    run.clock = (run.clock + rng.choice((1, 10, 100, 499, 500, 501, 1000, 5000))) & M32
    return run.clock


def macro_press(where, x, nat, run, stats, rng, button, opts, sc, ai):
    """pointer onto the button, click, render (pressed blit), tick past the release deadline, render (restore blit)."""
    body = cur_body(nat, run)
    name = {v: k for k, v in BUTTON_OF.items()}[button]
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    cx, cy = center_of(body_rect(body, name))
    sub(1, ('pointer', cx, cy))
    q = dict(tick=[opts.get('tick', advance(run, rng))] * 4, busy=[opts.get('busy', rng.choice((0, 0, 0, 1, 2, M32, 0x100, 0x10000)))] * 2)
    sub(2, ('click', q))
    if rng.random() < 0.9:
        sub(3, ('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))))
    img = nat.obj()
    if rng.random() < 0.9:
        ensure_mode(x, nat, run)
        t = (fld(img, 'pdl') + rng.choice((-1, 0, 0, 1, 10, 600))) & M32 if fld(img, 'state') == 2 and rng.random() < 0.7 else advance(run, rng)
        sub(4, ('tick', dict(tick=[t] * 4, busy=[rng.choice((0, 1))] * 2)))
    if rng.random() < 0.9:
        sub(5, ('render', rng.choice((0, 0, 5, -7)), rng.choice((0, 0, 3))))


def macro_finish(where, x, nat, run, stats, rng, max_steps, sc, ai):
    """tick through the states steering by the deadlines and the busy answers until the object finished."""
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    for k in range(max_steps):
        img = nat.obj()
        if not fld(img, 'active'):
            break
        ensure_mode(x, nat, run)
        state = fld(img, 'state')
        if state == 2:
            t = (fld(img, 'pdl') + rng.choice((-1, 0, 0, 1, 7))) & M32
        elif state == 5:
            t = (fld(img, 'fdl') + rng.choice((-1, 0, 0, 1, 7))) & M32
        else:
            t = advance(run, rng)
        busy = [rng.choice((0, 1, 1, 2, M32, 0x100, 0x10000))] * 2 if state == 7 else [0] * 2
        sub(k + 1, ('tick', dict(tick=[t] * 4, busy=busy)))
        if rng.random() < 0.3:
            sub(k + 1, ('render', 0, 0))


def bot(x, nat, run, stats, rng, sc, ai, steps, profile):
    sub = lambda k, a: do_action(x, nat, run, stats, rng, sc, ai, a, depth=k)  # noqa: E731
    weights = {'play': (('press', 6), ('tick', 3), ('pointer_btn', 3), ('pointer_rand', 1.5), ('click', 3), ('render', 3), ('invalidate', 0.4),
                        ('cleanup', 0.15), ('finish', 1.0), ('set', 0.3)),
               'win': (('press', 8), ('tick', 1), ('pointer_btn', 1), ('click', 1), ('render', 2), ('finish', 3)),
               'chaos': (('press', 2), ('tick', 3), ('pointer_btn', 3), ('pointer_rand', 2.5), ('click', 4), ('render', 3), ('invalidate', 1),
                         ('cleanup', 0.3), ('finish', 1), ('set', 3.5), ('body', 1))}[profile]
    names = [w[0] for w in weights]
    wts = [w[1] for w in weights]
    for k in range(steps):
        img = nat.obj()
        body = cur_body(nat, run)
        choice = rng.choices(names, wts)[0]
        state = fld(img, 'state')
        if choice == 'press':
            live = {0: (1, 8), 1: (0, 3, 4, 6, 8)}.get(state, (8,))
            button = rng.choice(live) if rng.random() < 0.85 else rng.choice((0, 1, 3, 4, 6, 8))
            sub(k, ('press', button))
        elif choice == 'tick':
            ensure_mode(x, nat, run)
            ref = fld(img, 'pdl') if state == 2 else fld(img, 'fdl')
            t = (ref + rng.choice((-1, 0, 1, 500, 1000))) & M32 if rng.random() < 0.5 else advance(run, rng)
            sub(k, ('tick', dict(tick=[t] * 4, busy=[rng.choice((0, 1, 2, M32))] * 2, handle=[rng.choice((0x4441, 0, 1, 0xFFFFFFFF))] * 2)))
        elif choice == 'pointer_btn':
            name = rng.choice(tuple(BUTTON_OF) + ('minute_dst', 'hour_dst', 'light_dst'))
            rect = body_rect(body, name)
            px, py = rng.choice((center_of(rect), (clamp16(rect[0]), clamp16(rect[1])), (clamp16(rect[2]), clamp16(rect[3])),
                                 (clamp16(rect[0] - 1), clamp16(rect[1])), (clamp16(rect[2] + 1), clamp16(rect[3]))))
            sub(k, ('pointer', px, py))
        elif choice == 'pointer_rand':
            sub(k, ('pointer', rng.randint(-40, 700), rng.randint(-40, 400)))
        elif choice == 'click':
            sub(k, ('click', dict(tick=[advance(run, rng)] * 4, busy=[rng.choice((0, 0, 1, 2, M32, 0x100, 0x80000000))] * 2)))
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
            d = rng.choice(({'state': rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 8, 9, M32))}, {'start': rng.choice((0, 1, 5, M32))},
                            {'over': rng.choice((0, 1))}, {'button': rng.choice((0, 1, 3, 4, 6, 8, 2, 5, 7, 9))},
                            {'restore': rng.choice((0, 1))}, {'dirty': rng.choice((0, 1))}, {'canceled': rng.choice((0, 1))},
                            {'pdl': (run.clock + rng.choice((-1, 0, 1, 1000))) & M32}, {'fdl': (run.clock + rng.choice((-1, 0, 1, 1000))) & M32},
                            {'hour': rng.randint(-3, 30), 'minute': rng.randint(-2, 70)}, {'idle': rng.choice((0, 1))},
                            {'ahour': rng.randint(0, 11), 'aquarter': rng.randint(0, 3), 'aam': rng.choice((0, 1))},
                            {'busy': {0x18 + rng.randrange(0x28): rng.choice((0, 1))}}, {'entry_dirty': {rng.randrange(0x18, 0x40): rng.choice((0, 1))}}))
            sub(k, ('set', d))
        elif choice == 'body':
            ri = fld(img, 'row') if fld(img, 'active') and 0 <= fld(img, 'row') < len(run.rows) else run.aa_rows()[0]
            kind = rng.choice(('press', 'fdelay', 'fsound', 'bsound', 'set_block', 'cancel_block'))
            if kind == 'press':
                sub(k, ('body', ri, {B_PRESS: struct.pack('<h', rng.choice((0, 1, 2, -2, 32767, -32768)))}))
            elif kind == 'fdelay':
                sub(k, ('body', ri, {B_FDELAY: struct.pack('<h', rng.choice((0, 1, 2, -2, 32767, -32768)))}))
            elif kind == 'fsound':
                sub(k, ('body', ri, {B_FSOUND: snd_patch(rng.choice(('none', 'real', 'near1', 'near2', 'zero'))), B_FCH: struct.pack('<h', rng.choice((0, 2, -3)))}))
            elif kind == 'bsound':
                sub(k, ('body', ri, {B_BTN_CH: struct.pack('<h', rng.choice((0, 2, -3, 9)))}))
            elif kind == 'set_block':
                sub(k, ('body', ri, {B_SET: struct.pack('<h', rng.choice((9999, 42, -5, 0x2710))), B_SET + 20: struct.pack('<h', rng.choice((0, 1, 2, -1)))}))
            else:
                sub(k, ('body', ri, {B_CANCEL: struct.pack('<h', rng.choice((9999, 42, -5, 0x2710))), B_CANCEL + 20: struct.pack('<h', rng.choice((0, 1, 2, -1)))}))


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
HANDLES = [0x4441, 0, M32, 1, 0x7FFFFFFF]
NAMES_POOL = [b'BLU_Clock', b'A', b'x' * 32, b'Alarm Surface', b'']
BUTTONS = (0, 1, 3, 4, 6, 8)
HOURS = list(range(-3, 31))
MINUTES = (-2, 0, 1, 15, 16, 30, 31, 45, 46, 59, 60, 70)


def R_AA(body, subtype=1, tail=b'', **kw):
    d = dict(type=0xAA, subtype=subtype, body=body, tail=tail, loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def R67(**kw):
    d = dict(type=0x67, subtype=1, body=b'\1', tail=b'', loaded=0, unloaded=0, completed=0, phase=0, request=0x55AA55AA, word=0x1234)
    d.update(kw)
    return d


def scenario_list(seed=0xAA52):
    rng = random.Random(seed)
    scs = []
    real = real_body()

    def S(sid, rows, actions, group, init=None, mode=3, events=None, quick=False):
        scs.append(dict(id=sid, rows=rows, actions=actions, group=group, init=init or {}, events=events or {}, mode=mode, quick=quick,
                        seed=rng.getrandbits(32)))

    def tk(**q):
        return ('tick', q)

    def mk(**kw):
        return make_body(rng, **kw)

    def pick_block():
        return rng.choice((block(9999, (1, 2, 3), (4, 5, 6), 1), rand_block(rng, 42), rand_block(rng, -5), rand_block(rng, 0x8000 - 0x10000),
                           rand_block(rng, 0x2710), rand_block(rng, 0xA70F - 0x10000), rand_block(rng, 1), rand_block(rng, 0), block(9999)))

    FLAGS = ((-1, 0), (0, 7), (339, 5), (340, 9), (341, 3), (4095, 255), (1010, 300), (2047, 1), (338, 0xAB), (340, 0xFF))

    # ---- phase 0: sounds, names, handles, busy seeds, surfaces, clock values ------------------------------------------------------
    seeds_variants = [[], [0x18], [0x18, 0x19, 0x1A], [0x18, 0x1A, 0x1B, 0x3E], list(range(0x18, 0x3F)), [0x00, 0x10, 0x17, 0x40, 0x57], [0x3F]]
    for k in range(40):
        name = NAMES_POOL[k % len(NAMES_POOL)]
        busy = seeds_variants[k % len(seeds_variants)]
        body = mk(name=name, btn_snd=SND_KINDS[k % len(SND_KINDS)], layout=rng.choice(('grid', 'tight', 'overlap')))
        S('init:%d_%s_snd%s' % (k, 'noname' if not name else 'name', SND_KINDS[k % len(SND_KINDS)]), [R_AA(body)],
          [tk(handle=[HANDLES[k % 5]]), tk(), ('cleanup',), ('rearm',), tk(handle=[HANDLES[(k + 1) % 5]]), tk(), ('render', 0, 0)], 'init',
          init=dict(busy_slots=busy, obj=dict(surface=rng.choice((0, 0x5151)), slot=rng.choice((-1, 0x19, 0x30))), idle=rng.choice((0, 1))),
          quick=k in (0, 5, 11, 22))
    S('init:stale_state_released', [R_AA(mk())], [tk(), ('cleanup',)], 'init',
      init=dict(obj=dict(surface=0x7777, slot=0x30, active=1, row=0, canceled=1, set=1, state=3)), quick=True)
    S('init:slot_exhaustion_but_last', [R_AA(mk())], [tk(), tk(), ('cleanup',)], 'init', init=dict(busy_slots=list(range(0x18, 0x3F))), quick=True)
    S('init:garbage_survives', [R_AA(mk(btn_snd='none'))], [tk(), tk(), tk()], 'init',
      init=dict(obj=dict(tquarter=-1, ahour=-5, aquarter=4, tam=9, aam=7, thour=100, restore=0x100, pdl=0x1234, fdl=0x4321, button=0x55)), quick=True)
    if real is not None:
        S('init:real_body', [R_AA(real)], [tk(), ('render', 0, 0), tk(), ('set', dict(state=1)), ('render', 3, 4), ('cleanup',)], 'init', quick=True)

    # ---- the clock: hours -3..30, minutes -2..70 through the time reader, then render both modes and step the alarm hour ------------
    for h in HOURS:
        body = mk(btn_snd=rng.choice(('none', 'real')), layout='grid')
        acts = []
        for m in MINUTES:
            acts += [('set', dict(hour=h, minute=m)), tk(), ('render', 0, 0), ('set', dict(state=1)), ('render', 5, 7), ('set', dict(state=3)), tk(),
                     ('set', dict(state=4)), tk(), tk(), ('cleanup',), ('rearm',)]
        S('clock:hour%d' % h, [R_AA(body)], acts, 'clock', init=dict(idle=0), quick=h in (-3, 0, 12, 24, 30))
    for h in (0, 1, 11, 12, 13, 23, 24):                 # the alarm walk: every alarm hour and the AM/PM flips, up and down, then set
        for m in (0, 20, 50):
            body = mk(btn_snd='real', fsnd=rng.choice(('none', 'real')), fdelay=rng.choice((0, 1, 3)), set_blk=pick_block(),
                      set_flag=rng.choice(FLAGS), layout='tight')
            acts = [('set', dict(hour=h, minute=m)), tk()]
            for dirn in (3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4):
                acts += [('set', dict(state=dirn)), tk(), ('set', dict(state=1)), ('render', 0, 0)]
            acts += [('set', dict(state=6)), tk(tick=[1000] * 2), ('set', dict(state=5)), ('finish', 8)]
            S('alarm_walk:h%d_m%d' % (h, m), [R_AA(body, subtype=rng.choice((1, 2)))], acts, 'clock', quick=(h, m) in ((0, 0), (12, 20), (23, 50)))
    for ah in (0, 1, 5, 9, 10, 11, 12, -1, 100):         # the alarm writer for every alarm hour / AM combination
        for am in (0, 1, 7):
            body = mk(set_blk=rand_block(rng, 12), set_flag=rng.choice(FLAGS), fsnd='none')
            S('alarm_write:h%d_am%d' % (ah, am), [R_AA(body, subtype=rng.choice((1, 2)))],
              [tk(), ('set', dict(ahour=ah, aam=am, set=1, canceled=0)), ('setphase', 0, 2), tk()], 'clock', quick=(ah, am) in ((11, 0), (0, 1)))

    # ---- the states 0..8, above 8, every phase ---------------------------------------------------------------------------------
    for state in list(range(0, 10)) + [0x80000000, M32]:
        for sub in (1, 2):
            body = mk(btn_snd='real', fsnd='real', fdelay=2, fch=rng.choice((2, 0, -3)), set_blk=rand_block(rng, 12), cancel_blk=rand_block(rng, 13),
                      cancel_flag=rng.choice(FLAGS), set_flag=rng.choice(FLAGS), press=rng.choice((1, 3)))
            acts = [tk(), ('set', dict(state=state, pdl=5000, fdl=5000, button=rng.choice(BUTTONS), restore=0)), tk(tick=[4999] * 2, busy=[0]),
                    tk(tick=[5000] * 2, busy=[1]), tk(tick=[5001] * 2, busy=[0]), tk(tick=[9000] * 2, busy=[0]), tk(tick=[20000] * 2, busy=[0]),
                    tk(tick=[30000] * 2, busy=[0]), tk(), tk()]
            S('state_forced:%#x_sub%d' % (state, sub), [R_AA(body, subtype=sub)], acts, 'states', quick=(state, sub) in ((0, 1), (2, 1), (5, 2), (7, 1), (8, 1)))
    for case in range(60):                               # state 2 (button pressed): the press deadline and the button that becomes the state
        pd = rng.choice((0, 1, 1000, 0xFFFFFC17, 0x7FFFFFFF, M32, 123456))
        ts = [(pd - 1) & M32, pd, (pd + 1) & M32, (pd + 0x80000000) & M32, (pd - 0x80000000) & M32, 0, M32]
        button = rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 8, 9, M32))
        body = mk(btn_snd='none')
        acts = [tk(), ('set', dict(state=2, pdl=pd, button=button, restore=rng.choice((0, 1, 5)), dirty=rng.choice((0, 1))))]
        for t in ts[:rng.randrange(3, 8)]:
            acts += [tk(tick=[t] * 2), ('set', dict(state=2, button=button))]
        S('state2_deadline:%d' % case, [R_AA(body)], acts, 'states', quick=case < 3)
    for case in range(48):                               # states 6, 5, 7: the final delay, the final sound, the busy answers
        delay = rng.choice((0, 1, 3, -2, 32767, -32768, 7))
        t0 = rng.choice((0, 1000, 0xFFFFFC17, 0x7FFFFFFF, M32, 123456))
        dl = (t0 + delay * 1000) & M32
        ts = [(dl - 1) & M32, dl, (dl + 1) & M32, (dl + 0x80000000) & M32, (dl - 0x80000000) & M32, 0, M32]
        fsnd = rng.choice(('none', 'real', 'real2', 'near1', 'none', 'near2', 'zero', 'near3'))
        fch = rng.choice((2, 0, -3, 32767, 0x4001))
        blk = pick_block()
        body = mk(fsnd=fsnd, fch=fch, fdelay=delay, set_blk=blk, set_flag=rng.choice(FLAGS), btn_snd=rng.choice(('none', 'real')))
        sub = rng.choice((1, 1, 2, 0, 3))
        acts = [tk(), ('set', dict(state=6)), tk(tick=[t0] * 2), tk(tick=[t0] * 2), tk(tick=[ts[0]] * 2), tk(tick=[ts[rng.randrange(1, 4)]] * 2),
                tk(tick=[ts[rng.randrange(4, 7)]] * 2), tk(busy=[1]), tk(busy=[2]), tk(busy=[M32]), tk(busy=[0]), tk(), tk()]
        S('final:%d_snd%s_d%d_sub%d' % (case, fsnd, delay, sub), [R_AA(body, subtype=sub)], acts, 'states', quick=case < 4)
    for b_ans in (0x100, 0x10000, 2, M32, 1, 0x80000000, 0xFF, 0):
        body = mk(fsnd='real', fch=rng.choice((2, 0, -3)), set_blk=rand_block(rng, 12), set_flag=rng.choice(FLAGS))
        S('state7_busy:%#x' % b_ans, [R_AA(body)], [tk(), ('set', dict(state=7, set=1)), tk(busy=[b_ans]), tk(busy=[b_ans]), tk(busy=[0]), tk()], 'states',
          quick=b_ans == 0x100)
    for ph in (3, 4, 9, M32):
        S('phase_other:%#x' % ph, [R_AA(mk(), phase=ph)], [tk(), tk()], 'phase_other', quick=ph == 3)
    for case in range(3):
        body = mk()
        S('rows_skipped:%d' % case, [R_AA(body, completed=1), R_AA(body, unloaded=1), R_AA(body, loaded=5)], [tk(), tk()], 'phase_other')

    # ---- phase 2: finish paths (cancel, set, both, neither), blocks, flags, sounds, completion subtypes ---------------------------------
    for case in range(80):
        blk_s, blk_c = pick_block(), pick_block()
        body = mk(set_blk=dict(blk_s, start=rng.choice((1, 0, 2, -1))), cancel_blk=dict(blk_c, start=rng.choice((1, 0, 2, -1))),
                  set_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS), btn_snd=rng.choice(('none', 'real', 'near1')),
                  layout=rng.choice(('grid', 'tight')))
        canceled, set_ = rng.choice(((1, 0), (0, 1), (1, 1), (0, 0), (0x7F, 0), (0, 0x80)))
        acts = [tk(), ('set', dict(canceled=canceled, set=set_, ahour=rng.choice((0, 5, 10, 11)), aam=rng.choice((0, 1)))), ('setphase', 0, 2), tk(),
                ('set', dict(mode=3)), tk()]
        if case % 3 == 0:
            acts = [tk(), ('set', dict(state=8)), tk(), tk(), ('set', dict(mode=3)), tk()]
        S('finish_path:%d_c%d_s%d' % (case, canceled, set_), [R_AA(body, subtype=rng.choice((1, 1, 2, 0, 3)))], acts, 'finish', quick=case < 6)
    if real is not None:
        S('finish_path:real_cancel', [R_AA(real)], [tk(), ('set', dict(state=8)), tk(), tk(), ('set', dict(mode=3)), tk()], 'finish', quick=True)
        S('finish_path:real_set', [R_AA(real)], [tk(), ('set', dict(state=6)), tk(tick=[1000] * 2), tk(tick=[1000] * 2), tk(tick=[2001] * 2), tk(busy=[0]), tk(busy=[0]),
                                                  ('set', dict(mode=3)), tk()], 'finish', quick=True)

    # ---- pointer sweeps: every rectangle edge in every state, active and inactive ------------------------------------------------------
    for layout in ('tight', 'grid', 'adjacent', 'overlap', 'neg', 'extreme', 'inverted', 'wide', 'real'):
        if layout == 'real' and real is None:
            continue
        for k in range(2 if layout in ('tight', 'grid', 'real') else 1):
            body = mk(layout=layout, cursor=rng.choice((4, 0, 1, 3, 7, -1, -32768, 32767, 12))) if layout != 'real' else \
                make_body(rng, base=real, cursor=rng.choice((4, 1, -1, 32767)), btn_snd=rng.choice(('real', 'none')))
            probes = probe_points(body, rng)
            states = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9) if layout in ('tight', 'real', 'adjacent', 'overlap') else (0, 1, 2, 8)
            for active in (1, 0):
                acts = [tk()]
                for st in (states if active else (0, 1)):
                    acts += [('set', dict(active=active, row=0, state=st, over=rng.choice((0, 1)), dirty=rng.choice((0, 1)),
                                          k0=rng.choice((0, 3, 9)), k1=rng.choice((0, 1)))), ('probes', probes)]
                S('pointer:%s_%d_a%d' % (layout, k, active), [R_AA(body)], acts, 'pointer',
                  quick=(layout, k, active) in (('tight', 0, 1), ('adjacent', 0, 1), ('overlap', 0, 1), ('tight', 0, 0), ('real', 0, 1)))

    # ---- clicks: every guard of 0x44d624, start flag, sound names, busy answers, press delay -------------------------------------------
    for name in SND_KINDS + ('long',):
        for start in (1, 0, 7, M32):
            for busy in (0, 1, 0x100, M32):
                body = mk(btn_snd=name, btn_ch=rng.choice((1, 0, -4, 32767, 0x4000)), press=rng.choice((1, 0, 3, -2, 32767, -32768)))
                acts = [tk(), ('set', dict(start=start, state=1, over=1)), ('click', dict(busy=[busy] * 2, tick=[1000] * 2)), ('render', 0, 0),
                        ('set', dict(state=1, over=1)), ('click', dict(busy=[busy] * 2, tick=[77] * 2)), tk(tick=[1000 + 600] * 3, busy=[busy])]
                S('click_sound:%s_start%d_busy%d' % (name, start, busy), [R_AA(body)], acts, 'click',
                  quick=(name, start, busy) in (('real', 1, 0), ('none', 1, 0), ('near1', 7, 0), ('real', 1, 0x100), ('real', 1, M32), ('zero', M32, 1)))
    for case in range(48):                               # the guard of the click: active / canceled / over / row phase
        active, canceled, over, ph = rng.choice((0, 1)), rng.choice((0, 1, 0x7F)), rng.choice((0, 1, 0x100)), rng.choice((1, 1, 0, 2, 3))
        body = mk(btn_snd=rng.choice(('real', 'none')), press=rng.choice((1, 5, 0)))
        S('click_gate:%d_a%d_c%d_o%d_p%d' % (case, active, canceled, over, ph), [R_AA(body)],
          [tk(), ('set', dict(active=active, row=0, canceled=canceled, over=over, state=rng.choice((0, 1, 2, 5, 9)), start=1)), ('setphase', 0, ph),
           ('click', dict(tick=[1000] * 2, busy=[0] * 2)), ('click', dict(tick=[2000] * 2, busy=[0] * 2))], 'click', quick=case < 4)

    # ---- render: forced states, buttons, restore, times, origins ---------------------------------------------------------------------
    for case in range(80):
        body = mk(layout=rng.choice(('grid', 'neg', 'overlap', 'extreme', 'tight')), btn_snd='none')
        org = rng.choice(((0, 0), (100, -50), (-300, 77), (0x7FFFFFF0, 0x7FFFFFFF), (-0x80000000, -0x80000000), (5, 6)))
        for_state = rng.choice((0, 1, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9))
        st = dict(state=for_state, button=rng.choice((0, 1, 2, 3, 4, 5, 6, 7, 8, 9)), restore=rng.choice((0, 1, 1, 0x100)),
                  thour=rng.randint(0, 11), tquarter=rng.randint(0, 3), tam=rng.choice((0, 1, 5)), ahour=rng.randint(0, 11),
                  aquarter=rng.randint(0, 3), aam=rng.choice((0, 1, 5)), dirty=rng.choice((0, 1, 0xFE)))
        acts = [tk(), ('set', st), ('render', org[0], org[1]), ('set', dict(st, restore=1)), ('render', 0, 0),
                ('set', dict(st, state=2, button=8)), ('render', org[1], org[0]), ('set', dict(st, state=2, button=rng.choice((0, 1, 3, 4, 6)))),
                ('render', 1, 1), ('set', dict(st, state=rng.choice((0, 1, 8)), restore=1, bg=rng.choice((0x1111, 0, M32)))), ('render', 2, 2)]
        S('render:%d_s%d' % (case, for_state), [R_AA(body)], acts, 'render', quick=case < 4)
    for case in range(12):                               # every shown hour index and quarter, both modes
        body = mk(layout='grid')
        acts = [tk()]
        for hr in range(12):
            for q in (0, 1, 2, 3):
                acts += [('set', dict(state=0, thour=hr, tquarter=q, tam=rng.choice((0, 1)))), ('render', 0, 0),
                         ('set', dict(state=1, ahour=hr, aquarter=q, aam=rng.choice((0, 1)))), ('render', 0, 0)]
        if case < 2:
            acts = acts[:200]
        S('render_digits:%d' % case, [R_AA(body)], acts, 'render', quick=case == 0)
    if real is not None:
        S('render:real_all', [R_AA(real)], [tk(), ('render', 0, 0), ('set', dict(state=1)), ('render', 3, 4)] +
          [a for button in (0, 1, 3, 4, 6, 8) for a in (('set', dict(state=2, button=button)), ('render', 0, 0), ('set', dict(state=1, restore=1)), ('render', 0, 0))],
          'render', quick=True)

    # ---- invalidate / cleanup on every kind of state -----------------------------------------------------------------------------------
    for case in range(20):
        body = mk(btn_snd=rng.choice(('none', 'real')))
        st = rng.choice((dict(active=0), dict(active=1, slot=-1), dict(active=1, slot=0x18), dict(active=1, slot=0x3F), dict(active=0, slot=0x20), dict(active=1, slot=0)))
        acts = [('set', dict(st, row=0)), ('invalidate',), tk(), ('invalidate',), ('cleanup',), ('invalidate',), ('rearm',), tk(), ('invalidate',), ('cleanup',), ('cleanup',)]
        S('invalidate:%d' % case, [R_AA(body)], acts, 'invalidate', init=dict(busy_slots=[0x18, 0x19], idle=rng.choice((0, 1))), quick=case < 3)
    for surface in (0, 0x4242):
        for slot in (-1, 0x1F, 0):
            for idle in (0, 1):
                S('cleanup:surface%#x_slot%d_idle%d' % (surface, slot, idle), [R_AA(mk())],
                  [('set', dict(surface=surface, slot=slot, active=1, row=0, canceled=1, set=1)), ('cleanup',), ('cleanup',)], 'invalidate',
                  init=dict(idle=idle), quick=(surface, slot, idle) in ((0x4242, 0x1F, 1), (0, -1, 0)))

    # ---- dependency tails, neighbours, passes stopped by the mode -----------------------------------------------------------------------
    for case in range(10):
        body = mk(btn_snd='real', set_blk=pick_block(), cancel_blk=pick_block(), set_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS))
        tail = event_tail(1003, 1)
        acts = [tk(), ('events', {1003: 1}), tk(), ('set', dict(state=8)), tk(), tk(tick=[1000] * 3), tk(tick=[9000] * 3), tk(), tk()]
        rows = [R67(), R_AA(body, tail=tail), R67(loaded=3)] if case % 2 else [R_AA(body, tail=tail), R67()]
        S('dep:%d' % case, rows, acts, 'dep', events={1003: 0 if case < 8 else 1}, quick=case in (0, 1))
    for case in range(8):          # a first clock's finish opens the second one through the event flag
        b0 = mk(set_blk=pick_block(), cancel_blk=pick_block() if case % 2 else block(9999), set_flag=(1003, 1), cancel_flag=(1003, 1), fsnd='none')
        b1 = mk(btn_snd='real')
        S('chain:%d' % case, [R_AA(b0), R_AA(b1, tail=event_tail(1003, 1)), R67()],
          [tk(), ('set', dict(state=8 if case % 2 else 6)), tk(), tk(), tk(), ('set', dict(mode=3)), tk(), tk(), ('set', dict(mode=3)), tk(), ('pointer', 0, 0),
           ('render', 0, 0), tk()], 'dep', events={1003: 0}, quick=case == 0)
    for case in range(6):
        body = mk(btn_snd=rng.choice(('none', 'real')))
        S('mode:%d' % case, [R67(), R_AA(body, subtype=1 + case % 2), R67(), R_AA(mk(), subtype=1, completed=1)],
          [tk(), ('set', dict(state=8)), tk(), tk(), tk(), ('set', dict(mode=3)), tk(), tk(tick=[1, 2]), tk()], 'mode', quick=case == 0)

    # ---- guided and random play ------------------------------------------------------------------------------------------------------
    for case in range(60):
        body = mk(layout=rng.choice(('tight', 'grid', 'tight', 'adjacent')), btn_snd=rng.choice(('none', 'real', 'near1')), fsnd=rng.choice(('none', 'real', 'near2')),
                  set_blk=pick_block(), cancel_blk=pick_block(), set_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS), fdelay=rng.choice((0, 1, 2)),
                  press=rng.choice((0, 1, 2)), btn_ch=rng.choice((0, 1, 9)), fch=rng.choice((0, 3)))
        S('win:%d' % case, [R_AA(body, subtype=rng.choice((1, 1, 2)))], [tk(handle=[HANDLES[case % 5]]), ('bot', 40, 'win')], 'bot',
          init=dict(start=rng.choice((1, 1, 0))), quick=case < 3)
    for case in range(140):
        body = mk(layout=rng.choice(('tight', 'grid', 'overlap', 'neg', 'adjacent')), btn_snd=rng.choice(('none', 'real', 'near1')), fsnd=rng.choice(('none', 'real', 'near2')),
                  set_blk=pick_block(), cancel_blk=pick_block(), set_flag=rng.choice(FLAGS), cancel_flag=rng.choice(FLAGS), fdelay=rng.choice((0, 1, 2)),
                  press=rng.choice((0, 1, 2)), btn_ch=rng.choice((0, 1, 9)), fch=rng.choice((0, 3)))
        rows = [R_AA(body, subtype=rng.choice((1, 1, 2, 0, 3)))]
        if case % 4 == 0:
            rows = [R67()] + rows + [R67(loaded=3)]
        S('random:%d' % case, rows, [tk(handle=[HANDLES[case % 5]]), ('bot', 60, rng.choice(('play', 'chaos', 'chaos')))], 'bot',
          init=dict(start=rng.choice((1, 1, 0, 5)), hour=rng.randint(-3, 30), minute=rng.randint(-2, 70)), quick=case < 3)
    if real is not None:
        for case in range(6):
            S('random:real_%d' % case, [R_AA(real, subtype=1 + case % 2)], [tk(), ('bot', 60, rng.choice(('play', 'win', 'chaos')))], 'bot',
              init=dict(start=1, hour=rng.randint(0, 24), minute=rng.randint(0, 59)), quick=case < 2)
    return scs


# ---------------------------------------------------------------------------------------------
# native-only checks (the safety layer; not comparable with the original)
# ---------------------------------------------------------------------------------------------
def snapshot(nat):
    return (nat.obj(), nat.extra(), nat.cells()[:8], nat.events(), nat.entries(), nat.idle(), nat.log(0), nat.log(1))


def refusal_checks(nat, stats):
    rng = random.Random(0xAA01)
    base = make_body(rng, btn_snd='real', fsnd='real', set_blk=rand_block(rng, 12), cancel_blk=rand_block(rng, 13), set_flag=(5, 9), cancel_flag=(6, 1))

    def fresh(**state):
        nat.reset()
        nat.set_queues(DEFAULT_Q)
        nat.clear_logs()
        img = bytearray(OBJ_LEN)
        put_fld(img, 'slot', -1)
        put_fld(img, 'row', -1)
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
    bad = {'short': base[:-1], 'long': base + b'\0', 'empty': b'', 'unterminated name': bytes([0x41] * 0x21) + base[0x21:],
           'button sound unterminated': patch(B_BTN_SOUND, bytes([0x42] * 0x21)), 'final sound unterminated': patch(B_FSOUND, bytes([0x43] * 0x21)),
           'name last byte': patch(0, bytes([0x41] * 0x21))}
    for name, b in bad.items():
        fresh(active=1, row=0)
        snap = snapshot(nat)
        expect('K1 validate ' + name, nat.validate(b), ERR_BODY)
        expect('K1 step ' + name, nat.step(b, 0, 0)[0], ERR_BODY)
        expect('K1 pointer ' + name, nat.pointer(b, 1, 1)[0], ERR_ARGUMENT)
        expect('K1 click ' + name, nat.click(b, 1)[0], ERR_ARGUMENT)
        expect('K1 render ' + name, nat.render(b)['status'], ERR_ARGUMENT)
        expect('K1 no effect ' + name, snapshot(nat), snap)
    expect('K1 valid body accepted', nat.validate(base), OK)
    expect('K1 terminator on the last byte accepted', nat.validate(patch(0x20, b'\0', patch(0, bytes([0x41] * 0x20)))), OK)
    expect('K1 phase 0 with a negative row', (fresh(), nat.step(base, -1, 0)[0])[1], ERR_ARGUMENT)
    # K2: phase 1 / 2 without initialisation, or for another row
    for ph in (1, 2):
        for variant in ('uninitialised', 'other row'):
            fresh(active=1 if variant == 'other row' else 0, row=3 if variant == 'other row' else 0, state=1)
            snap = snapshot(nat)
            expect('K2 phase %d %s' % (ph, variant), nat.step(base, 0, ph)[0], ERR_UNSUPPORTED)
            expect('K2 no effect', snapshot(nat), snap)
    # K3: event flag outside the host window (the cancel and the set path)
    for idx in (4096, -2, 32767, -32768):
        for name, st, off in (('cancel', dict(canceled=1), B_CANCEL + 22), ('set', dict(set=1), B_SET + 22)):
            body = patch(off, struct.pack('<h', idx))
            fresh(active=1, row=0, **st)
            snap = snapshot(nat)
            expect('K3 %s flag %d' % (name, idx), nat.step(body, 0, 2)[0], ERR_BOUNDS)
            expect('K3 no effect', snapshot(nat), snap)
    for idx in (-1, 0, 4095):
        for name, st, off in (('cancel', dict(canceled=1), B_CANCEL + 22), ('set', dict(set=1), B_SET + 22)):
            fresh(active=1, row=0, slot=0x18, **st)
            expect('K3 %s flag %d accepted' % (name, idx), nat.step(patch(off, struct.pack('<h', idx)), 0, 2)[0], OK)
    fresh(active=1, row=0, slot=0x18)           # neither taken: the unread flag words do not matter
    expect('K3 unread flags ignored', nat.step(patch(B_SET + 22, struct.pack('<h', 5000), patch(B_CANCEL + 22, struct.pack('<h', -9))), 0, 2)[0], OK)
    # K4: render with an hour / quarter outside the body tables, in the shown mode only
    for st in (dict(state=0, thour=12), dict(state=0, thour=-1), dict(state=0, tquarter=4), dict(state=0, tquarter=-1), dict(state=8, thour=100),
               dict(state=2, button=8, tquarter=9), dict(state=1, ahour=12), dict(state=1, aquarter=4), dict(state=3, ahour=-2), dict(state=5, aquarter=-1)):
        fresh(active=1, row=0, slot=0x18, **st)
        snap = snapshot(nat)
        expect('K4 render %r' % (st,), nat.render(base)['status'], ERR_BOUNDS)
        expect('K4 no effect', snapshot(nat), snap)
    for st in (dict(state=0, ahour=99, aquarter=99), dict(state=1, thour=99, tquarter=99), dict(state=2, button=1, thour=99, tquarter=99)):
        fresh(active=1, row=0, slot=0x18, **st)
        expect('K4 hidden mode not checked %r' % (st,), nat.render(base)['status'], OK)
    # K6: host failures, in every host call the kernel makes
    cases = [('phase0 alloc', F_ALLOC, 0, {}), ('phase0 register', F_REGISTER, 0, {}), ('phase0 load', F_LOAD, 0, {}), ('phase0 set surface', F_SETSURF, 0, {}),
             ('phase0 prepare', F_PREPARE, 0, {}), ('state5 prepare', F_PREPARE, 1, dict(state=5, fdl=0)), ('state5 play', F_PLAY, 1, dict(state=5, fdl=0)),
             ('state7 busy', F_BUSY, 1, dict(state=7)), ('state7 stop', F_STOP, 1, dict(state=7)), ('phase2 stop', F_STOP, 2, {}),
             ('phase2 transition', F_TRANSITION, 2, dict(set=1)), ('phase2 cancel transition', F_TRANSITION, 2, dict(canceled=1)),
             ('phase2 flag', F_FLAG, 2, dict(set=1)), ('phase2 release surface', F_RELEASE_SURFACE, 2, dict(surface=0x44, slot=0x20)),
             ('phase2 release slot', F_RELEASE_SLOT, 2, dict(slot=0x20)), ('phase2 idle', F_IDLE, 2, {})]
    for name, flag, ph, st in cases:
        fresh(active=1, row=0, **st)
        nat.set_queues({**DEFAULT_Q, 'busy': [0]})
        nat.set_fail(flag)
        status = nat.step(base, 0, ph)[0]
        nat.set_fail(0)
        expect('K6 ' + name, status, ERR_HOST)
    for name, flag in (('click busy', F_BUSY), ('click play', F_PLAY)):
        fresh(active=1, row=0, over=1)
        nat.set_queues({**DEFAULT_Q, 'busy': [0]})
        nat_set_start(nat, 1)
        nat.set_fail(flag)
        status = nat.click(base, 1)[0]
        nat.set_fail(0)
        expect('K6 ' + name, status, ERR_HOST)
    fresh(active=1, row=0, slot=0x18)
    nat.set_fail(F_ORIGIN)
    status = nat.render(base)['status']
    nat.set_fail(0)
    expect('K6 render origin', status, ERR_HOST)
    fresh(active=1, slot=0x18)
    nat.set_fail(F_DIRTY)
    status = nat.invalidate()
    nat.set_fail(0)
    expect('K6 invalidate mark dirty', status, ERR_HOST)
    for flag, st in ((F_RELEASE_SURFACE, dict(surface=0x44)), (F_RELEASE_SLOT, dict(slot=0x20)), (F_IDLE, {})):
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
    # K7: render with the slot -1: native does nothing
    fresh(active=1, row=0, slot=-1, state=0)
    snap = snapshot(nat)
    r = nat.render(base)
    expect('K7 render slot -1', (r['status'], r['valid'], r['count']), (OK, 0, 0))
    expect('K7 no effect', snapshot(nat), snap)
    # no-op arguments
    fresh()
    expect('invalidate on a power-on object', (nat.invalidate(), nat.log(1)), (OK, []))
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
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-52.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    # fast paths first: a failing mutant is caught by the quick set before the long scenarios
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_aa.so', strict=not args.lenient_build)
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
            args.result.write_text(json.dumps(dict(slice='RT-52', original_sha256=d9.EXE_HASH, stats=merged,
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    shard_k, shard_n = (0, 1)
    if args.shard:
        shard_k, shard_n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % shard_n == shard_k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_aa.so', strict=not args.lenient_build)
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
        args.result.write_text(json.dumps(dict(slice='RT-52', original_sha256=d9.EXE_HASH, stats=summary, pins=code,
                                              native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                         indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
