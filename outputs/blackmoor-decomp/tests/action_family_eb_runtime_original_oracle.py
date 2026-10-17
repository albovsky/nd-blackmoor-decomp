#!/usr/bin/env python3
"""RT-56: immutable x86 dispatcher 0x427a50 / handler 0x480e02 versus the native raw-0xeb Multibuild puzzle kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For raw 0xeb rows the REAL dispatcher 0x427a50 runs: gate
0x423f57 (dependency tree built by the real loader 0x424aa8), the handler 0x480e02 (arm 0x42a794) with ECX = singleton
0x625ee8 and, as original x86 code: the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 on the table at
0x5d1591, the piece builder 0x47e582, the rectangle translator 0x47e52f, the rectangle test 0x47e99e, the top-piece
helpers 0x47e8fe / 0x47e9d3, the overlap and layer helpers 0x47ea73 / 0x47ed96, the near-piece test 0x47ec06, the clamp
0x47f19d, the follower 0x47f275, the rotation 0x47fa11, the multi pick 0x47fb76, the cursor/candidate writer 0x47fd65,
the sound blocks 0x4809a7 / 0x480a1d / 0x480abe, the save and solved check 0x480b34, the generic completion 0x42ba3a,
the cleanup 0x47e2a5 with the object reset 0x47e25a and the saved-state power-on reset 0x47e3f7. The entry points the
engine reaches through other callers are driven directly with ECX = 0x625ee8: the pointer receiver 0x47f421 (cascade
0x4f0059 at 0x4f0d90, `ret 0xc`, x = [event+0x5e], y = [event+0x5a], rect = event+0x4a), the accepted-release click
0x47ff0e (chain 0x43b331), the second-button event 0x47ef0f (0x43c129), the invalidate 0x47e440, the cleanup 0x47e2a5
and the render callback 0x481cb9 (blits 0x4c5377 / 0x4c5d4b recorded). The native side is src/action_family_eb_runtime.c
driven by tests/action_family_eb_runtime_oracle_driver.c with a scripted host.

Compared for every scenario step: the ordered host-call log (every replaced original call with its arguments against
the corresponding EbHost callback; sound, tick and AUTOTEXT calls included; the log kinds are listed in LOGKINDS), the
whole object image 0x144d bytes, the body image 2612 bytes of every row, the saved puzzle state block 0x5a055d..0x5a110b
(2990 bytes), the generic Z entry table (0x58 entries of 0x4a bytes), the row phase dword and the completion byte of
every row, the process flag 0x5bb1ca, the seven scene-change cells (0x5bb57b is also the scene the saved-state compare
reads), the engine mode 0x583999, the event flag table window (4096 dwords at 0x585801), the scripted queue
consumption (ticks and busy answers; there is no _rand in raw 0xeb), the pointer results (return value, [0x5b44f0],
[0x5b44f4], [0x5d1631], [0x5d1639], [0x5d162d], [0x5c39e5]) and, for the render callback, the recorded 0x4c5377 /
0x4c5d4b blits against eb_render_plan (blit list; the object after the call is compared by the state comparison).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard. ECX and `ret N` were read from the
 disassembly (asm/FUN_*.s) and the `ret` immediates are re-checked against the unmodified image at start-up.
  R 0x51dc43 malloc      bump arena (OS/CRT boundary, used by the dependency loader 0x424aa8), zero filled
  R 0x4c2790 load_image(kind, name, 6, tag)         thiscall ECX 0x5cf659, ret 0x10: returns the scripted handle
  R 0x4c2a8d create_surface(w, h, 6, tag)           thiscall ECX 0x5cf659, ret 0x10: returns a fake surface struct in
     emulated memory (data pointer +0, size dword +0x23 = 0x20, width +0x2b, height +0x2d, pitch +0x2f)
  R 0x4c51a5 blit(src, dst, src rect, dst rect, tag) thiscall ECX 0x5cf659, ret 0x14: records both rectangles
  R 0x4c7070 rotate(surface, 0x63a898)              thiscall ECX 0x5cf659, ret 8: records, swaps the struct's width and
     height and sets the pitch, as the real one does
  R 0x4c2dfb release_image(&handle)                 thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param
  R 0x4e8d96 clear pending item                     thiscall ECX 0x571442, ret 0
  R 0x4fb77a prepare sound(record ptr)              thiscall ECX 0x5c3a67, ret 4
  R 0x4fba69 stop sound(record ptr)                 thiscall ECX 0x5c3a67, ret 4
  R 0x4fb2e3 play sound(channel word)               thiscall ECX 0x5c3a67, ret 4 (upper half of the pushed dword ignored)
  R 0x4f6334 sound busy(channel)                    thiscall ECX 0x5cf1eb, ret 4: returns the scripted answer
  R 0x423259 AUTOTEXT lookup(key)                   thiscall ECX 0x619a6b, ret 4: scripted pointer in emulated memory or 0
  R 0x448d11 caption show(surface, text, -1, 0)     thiscall ECX 0x619a05, ret 0x10: records the text, checks the
     other three arguments against [0x5d03b3], -1 and 0
  R 0x4c5377 / 0x4c5d4b render blits (src, dst, src rect, dst rect, tag) thiscall ECX 0x5cf659, ret 0x14: recorders
  R GetTickCount (the IAT slot 0x52a23c, stub)      returns the next scripted tick value
  O 0x480e02 handler entry (row, phase, ECX check)  O 0x42ba3a generic completion  O 0x4d3992 release entry (slot)
  O 0x4d39f9 slot allocator entry  O 0x47e841 instruction boundary inside 0x47e582 (before the inline pixel copy of a
     rotated entry: records destination and source surface; the copy itself then runs as original code)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
     scenario expects the allocator's fatal path 0x52139c, which is then compared with the native host error);
     0x425b8b and 0x425b40 (debug tree printer / malformed tree) raise through the base.
 Windows imports (OS boundary, IAT slots patched to stubs): GetTickCount (scripted), InterlockedIncrement/Decrement,
 lstrlenA, Enter/Leave/InitializeCriticalSection (single thread); any other import fails the run.
 FS needs a TIB page (GDT) for the SEH frames. Debug flag 0x63a4cd is 0. The singleton is power-on reset by the
 original 0x47e25a (and the saved state by 0x47e3f7), both run as original code and compared with the native resets.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, the view origin
and clip globals, the tick values and busy answers, the captions flag [0x5bb202], the AUTOTEXT table, the slot-busy
seeds, the event flag table contents, the cursor source [0x5d0377], the caption surface [0x5d03b3], the current scene
[0x5bb57b] (seeded per scenario; the saved-state compare reads it as a dword against the saved word, sign extended).

EXPECTED DIFFERENCES (native safety layer; tagged scenarios, counted in stats.known_observed, never as passes; the
original is NOT run for these):
  K1 body validation (eb_validate_body): type count outside 0..20, piece size outside 1..4096, an unterminated
     name/key/text field, a zero grid column count with an animation area, a short body.
  K2 phase 1 / 2 on an object that was never initialised for the row: native EB_ERR_UNSUPPORTED.
  K3 a hand or list index outside the instances, an instance type byte outside 0..19, an instance count outside
     0..80 under a pointer move, click, rotate key or render: native EB_ERR_BOUNDS before the offending effect.
  K4 an event flag index outside the host window: the original stores through an arbitrary pointer; native refuses
     with EB_ERR_BOUNDS.
  K5 more than 20 pieces under the pointer, spawning an 81st instance, a zero grid column count in animation state
     4 (the original divides by zero), the z-level render loop guard of 0x4000.
  K6 a caption (AUTOTEXT text or body text) longer than the 204-byte (click) or 208-byte (win) local: the original
     overflows; native refuses with EB_ERR_BOUNDS. An AUTOTEXT text longer than 0x9c40 characters is a valid-domain
     case (the original falls back to the body text) and is compared.
  All of them are unreachable in the game (2 rows, loader-built bodies, one scene each).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.

Not modelled / unverified (see the receipt): the real image loader 0x4c2790, creator 0x4c2a8d, blitter 0x4c51a5,
rotator 0x4c7070 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69, 0x4fb2e3, 0x4f6334), 0x4e8d96, the blit
bodies 0x4c5377 / 0x4c5d4b, the AUTOTEXT table behind 0x423259 and the caption writer 0x448d11, GetTickCount, the
pointer cascade 0x4f0059 that calls 0x47f421, the accepted-release chain 0x43b331 that calls 0x47ff0e, the
second-button chain 0x43c129, the loader 0x47e477 / 0x40b34a that builds the body, and the engine consumer of the
scene-change cells.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_eb_runtime_original_oracle.py --quick-only
  python3 action_family_eb_runtime_original_oracle.py --workers 4 --result ../../../work/analysis/slices/RT-56.oracle-result.json
  python3 action_family_eb_runtime_original_oracle.py --discover-pins      (prints PINS_TABLE for the executed original code)
"""
from __future__ import annotations

import argparse
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
import ctypes as C
from collections import Counter
from pathlib import Path

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x625ee8
OBJ_LEN = 0x144d
BODY_LEN = 2612
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
SAVED_VA = 0x5a055d
SAVED_LEN = 2990
G_ORIGIN_X, G_ORIGIN_Y = 0x583186, 0x58318a
G_CLIP = (0x583196, 0x58319a, 0x58319e, 0x5831a2)
G_BACK, G_SAVED = 0x5cf665, 0x5d15e3
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
G_CAND, G_CURSOR, G_CURSOR2 = 0x5c39e5, 0x5b44f0, 0x5b44f4
G_E2_SRC, G_E2_REC, G_E2_FLAG = 0x5d162d, 0x5d1631, 0x5d1639
G_CAPTIONS, G_CAPSURF, G_CURSOR_SRC = 0x5bb202, 0x5d03b3, 0x5d0377
EVENTS_VA = 0x585801
EVENT_COUNT = 4096
CELLS = ((0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2), (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4))
TAIL_BASE = 0x2000a000
BODY_BASE = 0x22000000
BODY_STRIDE = 0x1000
MAX_ROWS = 8
SCRATCH = 0x24000000
SCRATCH_SIZE = 0x500000
PTR_RECT = SCRATCH + 0x100
TEXT_BASE = SCRATCH + 0x10000
TEXT_STRIDE = 0x10000
SURF_BASE = SCRATCH + 0x200000
SURF_STRIDE = 0x100
SURF_MAX = 8192
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
SOUND_THIS, BUSY_THIS, ITEM_THIS = 0x5c3a67, 0x5cf1eb, 0x571442
AUTO_THIS, CAP_THIS = 0x619a6b, 0x619a05
FPCW = 0x27f
MARK_SAVED, MARK_BACK, MARK_CAPSURF, MARK_CURSOR_SRC = 0x5d1111, 0x22220000, 0x5d1234, 0x5d4321

# log kinds, shared with the driver (ENTER is Python-only)
LOGKINDS = dict(LOAD=1, CREATE=2, BLIT=3, COPY=4, ROTATE=5, RELEASE=6, CLEAR_ITEM=7, SND_PREPARE=8, SND_STOP=9,
                SND_PLAY=10, SND_BUSY=11, TICK=12, AUTOTEXT=13, CAPTION=14, COMPLETE=15, ALLOC=16, RELEASE_SLOT=17,
                ENTER=18)
KN = {v: k for k, v in LOGKINDS.items()}

TAG_SRC = b'DF Piece Source Surface'
TAG_MULTI = b'Multi Piece Source Surface'
TAG_ANIM = b'Multi Anim Surface'
TAG_PIECE = b'pDFSurface for Multibuild Puzzle Piece'  # prefix; the original appends ", Orientation ..." texts
# the kernel passes the same load tags as the original; piece surface tags are compared by their common prefix class
LOAD_TAGS = {TAG_SRC: b'SRC', TAG_MULTI: b'MULTI', TAG_ANIM: b'ANIM'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4e8d96: (0x80, 0), 0x4fb77a: (0x300, 4),
             0x4fba69: (0x20, 4), 0x4fb2e3: (0x200, 4), 0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14),
             0x4c5d4b: (0x350, 0x14), 0x4c2a8d: (0x1ad, 0x10), 0x4c51a5: (0x1d2, 0x14), 0x4c7070: (0x189, 8),
             0x423259: (0x10f, 4), 0x448d11: (0xa21, 0x10)}
# replaced address -> (`ret N`, expected ECX or None)
REPLACED = {0x4c2790: (0x10, SURF_HOST), 0x4c2a8d: (0x10, SURF_HOST), 0x4c51a5: (0x14, SURF_HOST),
            0x4c7070: (8, SURF_HOST), 0x4c2dfb: (4, SURF_HOST), 0x4e8d96: (0, ITEM_THIS),
            0x4fb77a: (4, SOUND_THIS), 0x4fba69: (4, SOUND_THIS), 0x4fb2e3: (4, SOUND_THIS),
            0x4f6334: (4, BUSY_THIS), 0x423259: (4, AUTO_THIS), 0x448d11: (0x10, CAP_THIS),
            0x4c5377: (0x14, SURF_HOST), 0x4c5d4b: (0x14, SURF_HOST)}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
AT_COPY = 0x47e841
HANDLER = 0x480e02

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
# Filled from --discover-pins (every executed block mapped to its asm extent); empty list = no pin check.
PINS_TABLE = (
 (0x423259, 0x423368,
  '05577fdc25bbcff3f5b8e48c31cedc4836a90d77f41d1f59886594953693f7e3'),
 (0x4234c8, 0x4234dd,
  'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
 (0x4237f7, 0x423876,
  'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
 (0x423f57, 0x423fbb,
  '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
 (0x42406d, 0x424201,
  '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
 (0x424201, 0x424346,
  'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
 (0x424346, 0x424a3c,
  '6ef61d36effbd2005a44bc6657536230683d1b1e885449958c0f0a434f627704'),
 (0x424aa8, 0x425b8b,
  'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
 (0x427a50, 0x42a9b4,
  '41778bbe0b676916876808865a5ee44c660fb899fcbdd8994249c19ab934a895'),
 (0x42ba3a, 0x42babf,
  '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
 (0x448d11, 0x449732,
  '3ed26954bac96938c48dfeb74c9f534625016da93a46d7aa8b27fe8f1b5cd751'),
 (0x47e25a, 0x47e2a5,
  '04952f760b878ea3ba1b4dfc57b6712698aea36a5575255f03d512b7caab32a6'),
 (0x47e2a5, 0x47e3f7,
  'e6d3db96d20fd50d62d65e1cf99f7843b524ec8480134a2b08e7bf19e254104b'),
 (0x47e3f7, 0x47e440,
  'a682b25100fdf24046627d28fbb64538aba06efc02bf3e118b8a278e392be495'),
 (0x47e440, 0x47e477,
  '6e9316512425cebf2b9d69140ee024f2356da2e9489517ee8f814ccc81013ddc'),
 (0x47e52f, 0x47e582,
  '30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57'),
 (0x47e582, 0x47e8fe,
  '35316b5f3316d70ae40750c62c47839d22752540ac805edc105e6fe1b901acce'),
 (0x47e8fe, 0x47e99e,
  '1ddeb99e03ecbb86547e2a76f2e7e57bd47673cb4039efbf9649f98c7fd2388d'),
 (0x47e99e, 0x47e9d3,
  'c79a9aef8da7071bd7a7489b72ab12802f5aecc36e3c8e8a2e2ccca68cd760ea'),
 (0x47e9d3, 0x47ea73,
  '6b853c69409e513634d40120b1f49f54196392c50b43854d9c29597f71893a05'),
 (0x47ea73, 0x47ec06,
  'b7d749bd5a60867f2126f964406947e35fd016f4d473b9fa6e5ee5ed5070f092'),
 (0x47ec06, 0x47ed96,
  '4b171230db3dbb0c9c1e7d6cc6b0d518e1506f9d3319e6684061285263116129'),
 (0x47ed96, 0x47ef0f,
  'ad11166fc338a5d8e9841a0fc95da1d92a9f235767d24c6f2a901534495e7083'),
 (0x47ef0f, 0x47f19d,
  '0c6c8d351a99931dc42e062ce0e8d723958f482c0cd44a7c0082360fdcbf7e6b'),
 (0x47f19d, 0x47f275,
  'efe2f23539b342c092f2e420aec64754623d4d5435d8931b73ee0c408354c2be'),
 (0x47f275, 0x47f421,
  'a6636eadde63e888f92dbe53153a47cf804c321319e1089cc936510beca262f5'),
 (0x47f421, 0x47fa11,
  '9e496459dbcdb7480059d914af9ae193f5d8b7cf3d0058410a31f0df0eabbccf'),
 (0x47fa11, 0x47fb76,
  '730d152a958cda5bfee277d5f80305e3fa6b59677176a2e7b3e7c79e1f3092d0'),
 (0x47fb76, 0x47fd65,
  'a355c8c074dcf77e64eb218f2713d37fef4ecdeb1d63de05c3280d9f911aaa6c'),
 (0x47fd65, 0x47ff0e,
  '05a9653ac9793f62cc284140f22b9621eb2f64dafb70aacc30e54371a2085bb3'),
 (0x47ff0e, 0x4809a7,
  '19986566febb5109f5458ed6341eab19852391102aae71d8eb551559033c9fc7'),
 (0x4809a7, 0x480a1d,
  '45a848e9ec74f52695b3249b8455d0d851933f49f091d3d7c80d00895119a20c'),
 (0x480a1d, 0x480abe,
  '60934d9eddf35344af12cc62759f600282e35d7f19a89bc54d7054422b5f2fac'),
 (0x480abe, 0x480b34,
  'ba681aed048f368ca378977728503946fe6779cdc8521ed735098d751d2c2801'),
 (0x480b34, 0x480e02,
  'dd337888e31ab3ac16f302b7fcefbfdd65fe4ac77c9a63d2dbdec752b26bd7f4'),
 (0x480e02, 0x481c8d,
  'be1d795a3c0e32086eb2bd61891e5c988b17eaca53142a999d0029baf3d63eb5'),
 (0x481cb9, 0x482054,
  'd8fa449b774c615e75b3f0feef7343dc893a1fff6f122c5e6018db9dd8ad9a5f'),
 (0x4c2790, 0x4c2898,
  '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
 (0x4c2a8d, 0x4c2c3a,
  '9e30a70ee2613a1ea7fb608e88a98b56478e5c3e71814992f28c9609cc451f75'),
 (0x4c2dfb, 0x4c2e5b,
  '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
 (0x4c51a5, 0x4c5377,
  'dc7b9a9ed6c6241cef6a4b866d5beb55aa030f2a9263d521b3c28f917702eb0b'),
 (0x4c5377, 0x4c558b,
  'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
 (0x4c5d4b, 0x4c609b,
  'cfb7385d2efeb3e0fe986eb4812d22f3447e4b1134ff5086a655a0ccc10d5379'),
 (0x4c7070, 0x4c71f9,
  'e552c5024eccec8c520207f55e12e611a1909c7a3171c0357bbe85f6b6620cc9'),
 (0x4d3992, 0x4d39f9,
  'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
 (0x4d39f9, 0x4d3a52,
  '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
 (0x4e8d96, 0x4e8dc8,
  '0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85'),
 (0x4f6334, 0x4f646c,
  '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
 (0x4fb2e3, 0x4fb397,
  'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
 (0x4fb77a, 0x4fba69,
  '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
 (0x4fba69, 0x4fba86,
  '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
 (0x51dc43, 0x51dc6c,
  '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
 (0x52139c, 0x5213d4,
  '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)

# --- object layout (offsets verified against asm/FUN_0047*.s / FUN_00480*.s) -----------------------------------
O_SLOT, O_ROW, O_ENTRIES, O_COUNTS, O_PIECES = 0x1c, 0x1e, 0x20, 0x7a0, 0x7b4
O_DRAG, O_DROP, O_LIFT, O_HAND, O_PREV, O_MOVE, O_PREV_T, O_MOVE_T, O_SAVED = 0x1344, 0x1348, 0x134c, 0x1350, 0x1352, 0x1362, 0x1372, 0x1382, 0x1392
O_COUNT, O_SRC, O_MULTI, O_ANIM = 0x13a2, 0x13a4, 0x13a8, 0x13ac
O_HAS_MULTI, O_MULTI_HAND, O_ANIM_ON, O_ANIM_REST, O_HAS_ANIM, O_ANIM_SRC = 0x13b0, 0x13b1, 0x13b2, 0x13b3, 0x13b4, 0x13b5
O_ACTIVE, O_EXIT, O_STATE, O_DONE, O_PTR_RECT, O_HIT = 0x13c5, 0x13c9, 0x13ca, 0x13ce, 0x13cf, 0x13df
O_HW, O_HH, O_DEADLINE, O_DEADLINE2 = 0x13e3, 0x13e5, 0x13e7, 0x13eb
O_LIST1, O_COUNT1, O_LIST2, O_COUNT2, O_TOTAL = 0x13ef, 0x1417, 0x1419, 0x1441, 0x1443
O_ANIM_ROW, O_ANIM_FRAME, O_CELL_W, O_CELL_H = 0x1445, 0x1447, 0x1449, 0x144b
PIECE = 0x25

# --- body layout ---------------------------------------------------------------------------------------------
B_NAME, B_MULTI, B_PERSIST, B_NTYPES, B_TARGET, B_WINSND, B_ROT, B_LOCK = 0, 0x21, 0x42, 0x43, 0x45, 0x47, 0x48, 0x49
B_ZH, B_ZW, B_AREA, B_MODE, B_OVERLAP, B_ANIM_NAME, B_ANIM_AREA = 0x4a, 0x4c, 0x4e, 0x5e, 0x5f, 0x60, 0x81
B_GROWS, B_GCOLS, B_GGAP, B_GREP, B_TYPES = 0x91, 0x93, 0x95, 0x97, 0x99
BT = 0x53
SND = dict(rot=0x715, pick=0x746, good=0x777, bad=0x7a8, win=0x8e1)
B_KEY_BAD, B_TEXT_BAD, B_KEY_WIN, B_TEXT_WIN = 0x7d9, 0x7fa, 0x912, 0x933
B_CUR_PICK, B_CUR_A, B_CUR_B = 0x8c2, 0x8c4, 0x8c6
B_BLOCK_WIN, B_BLOCK_EXIT, B_BTN_A, B_BTN_B = 0x8c8, 0x9fb, 0xa14, 0xa24
SCENE_FMT = '<h3h3ihhB'
NO_SOUND = b'NO SOUND'
NO_FILE = b'NO_FILE'
CAND = dict(pick=0x278d, rotate=0x278e, exit_a=0x278f, exit_b=0x2790, drop=0x2791)
CANDS = tuple(CAND.values())


class OracleError(RuntimeError):
    pass


class Fatal(OracleError):
    def __init__(self, address):
        super().__init__('fatal original path %#x reached' % address)
        self.address = address


class Mismatch(Exception):
    pass


def sha(data):
    return hashlib.sha256(data).hexdigest()


def u32(uc, a):
    return struct.unpack('<I', bytes(uc.mem_read(a, 4)))[0]


def cstr(data):
    return bytes(data).split(b'\0')[0]


def s16(v):
    v &= 0xffff
    return v - 0x10000 if v & 0x8000 else v


def s32(v):
    v &= 0xffffffff
    return v - (1 << 32) if v & 0x80000000 else v


def clamp16(v):
    return max(-32768, min(32767, v))


# ---------------------------------------------------------------------------------------------
# body construction (synthetic), corpus bodies and parsing
# ---------------------------------------------------------------------------------------------
def scene_block(scene=9999, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return struct.pack(SCENE_FMT, scene, *words, *dwords, start, flag, value)


def put_name(b, off, name, span, rng=None):
    """NUL terminated name inside a span; the bytes after the NUL are random garbage (never read by a correct copy)."""
    raw = name[:span - 1] + b'\0'
    b[off:off + len(raw)] = raw
    if rng is not None:
        for k in range(off + len(raw), off + span - 1):
            b[k] = rng.randrange(0x20, 0x7f)
        b[off + span - 1] = 0
    else:
        b[off + len(raw):off + span] = bytes(span - len(raw))


def put_sound(b, off, name, chan, rng):
    put_name(b, off, name, 0x21, rng)
    struct.pack_into('<h', b, off + 0x21, chan)
    for k in range(off + 0x23, off + 0x31):
        b[k] = rng.randrange(256)


def rect_bytes(r):
    return struct.pack('<4i', *r)


def make_body(rng, n=5, name=b'PIECESRC', multi=b'NO_FILE', persist=0, target=0, winsnd=0, rot=0, lock=0, zone=(10, 12),
              area=(0, 0, 639, 479), mode=0, overlap=0, anim_name=b'NO_FILE', anim_area=(0, 0, 0, 0), grid=(2, 3, 5, 2),
              types=None, sounds=None, chans=None, keys=None, texts=None, cursors=(3, 4, 5), win=None, exit_=None,
              btn_a=(560, 420, 620, 460), btn_b=(0, 0, 0, 0), garbage=True, board=None):
    """A 2,612-byte typed body. `types` is a list of dict(A, B, C, D, E, spawn, req, forb); every unspecified field is
    deterministic from `rng`. Rects are (left, top, right, bottom) with inclusive edges (a zero-edge pair is 'invalid')."""
    b = bytearray(rng.randbytes(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    g = rng if garbage else None
    put_name(b, B_NAME, name, 0x21, g)
    put_name(b, B_MULTI, multi, 0x21, g)
    b[B_PERSIST] = persist
    struct.pack_into('<h', b, B_NTYPES, n)
    struct.pack_into('<h', b, B_TARGET, target)
    b[B_WINSND] = winsnd
    b[B_ROT], b[B_LOCK] = rot, lock
    struct.pack_into('<hh', b, B_ZH, zone[0], zone[1])
    b[B_AREA:B_AREA + 16] = rect_bytes(area)
    b[B_MODE], b[B_OVERLAP] = mode, overlap
    put_name(b, B_ANIM_NAME, anim_name, 0x21, g)
    b[B_ANIM_AREA:B_ANIM_AREA + 16] = rect_bytes(anim_area)
    struct.pack_into('<4h', b, B_GROWS, *grid)
    cnt = max(0, min(n, 20))
    if types is None:
        types = default_types(rng, cnt, board or area)
    for t in range(20):
        base = B_TYPES + BT * t
        p = types[t] if t < len(types) else None
        if p is None:
            if not garbage:
                b[base:base + BT] = bytes(BT)
            continue
        for k, key in enumerate('ABCDE'):
            b[base + 16 * k:base + 16 * k + 16] = rect_bytes(p[key])
        b[base + 0x50], b[base + 0x51], b[base + 0x52] = p.get('spawn', 0), p.get('req', 0), p.get('forb', 0)
    sounds = sounds or {}
    chans = chans or {}
    for k, off in SND.items():
        put_sound(b, off, sounds.get(k, NO_SOUND), chans.get(k, 10 + len(k)), rng)
    keys = keys or {}
    texts = texts or {}
    put_name(b, B_KEY_BAD, keys.get('bad', b''), 0x21, g)
    put_name(b, B_KEY_WIN, keys.get('win', b''), 0x21, g)
    put_name(b, B_TEXT_BAD, texts.get('bad', b''), 200, g)
    put_name(b, B_TEXT_WIN, texts.get('win', b''), 200, g)
    struct.pack_into('<3h', b, B_CUR_PICK, *cursors)
    b[B_BLOCK_WIN:B_BLOCK_WIN + 25] = win if win is not None else scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 1984, 1)
    b[B_BLOCK_EXIT:B_BLOCK_EXIT + 25] = exit_ if exit_ is not None else scene_block(4366, (7, 8, 9), (10, 11, 12), 1, -1, 0)
    b[B_BTN_A:B_BTN_A + 16] = rect_bytes(btn_a)
    b[B_BTN_B:B_BTN_B + 16] = rect_bytes(btn_b)
    return bytes(b)


def default_types(rng, cnt, board):
    out = []
    bl, bt, br, bb = board
    for i in range(cnt):
        w, h = rng.randrange(14, 56), rng.randrange(14, 56)
        sx, sy = rng.randrange(0, 300), rng.randrange(0, 300)
        a = (sx, sy, sx + w - 1, sy + h - 1)
        # home in the bin: left strip below the board; target C on the board; D / E in the multi source
        hx, hy = rng.randrange(bl, max(bl + 1, br - 60)), rng.randrange(max(bb - 100, bt), max(bb - 99, bt + 1))
        home = (hx, hy, hx + w - 1, hy + h - 1)
        tx, ty = rng.randrange(bl + 20, max(bl + 21, br - 80)), rng.randrange(bt + 20, max(bt + 21, bb - 120))
        c = (tx, ty, tx + w - 1, ty + h - 1) if rng.random() < 0.6 else (0, 0, 0, 0)
        d = (sx + 2, sy + 2, sx + w + 1, sy + h + 1) if rng.random() < 0.6 else (sx, sy, sx + w - 1, sy + h - 1)
        e = (0, 0, 0, 0) if rng.random() < 0.5 else (tx + 3, ty + 3, tx + w + 2, ty + h + 2)
        out.append(dict(A=a, B=home, C=c, D=d, E=e, spawn=1 if rng.random() < 0.25 else 0,
                        req=rng.choice([0, 0, 1, 1, 2]), forb=1 if rng.random() < 0.1 else 0))
    return out


def parse(body):
    """The geometry the player needs from a body."""
    g = lambda o, f: struct.unpack_from(f, body, o)[0]
    n = g(B_NTYPES, '<h')
    ts = []
    for t in range(max(0, min(n, 20))):
        base = B_TYPES + BT * t
        ts.append(dict(A=struct.unpack_from('<4i', body, base), B=struct.unpack_from('<4i', body, base + 16),
                       C=struct.unpack_from('<4i', body, base + 32), D=struct.unpack_from('<4i', body, base + 48),
                       E=struct.unpack_from('<4i', body, base + 64), spawn=body[base + 0x50], req=body[base + 0x51],
                       forb=body[base + 0x52]))
    return dict(n=n, types=ts, rot=body[B_ROT], lock=body[B_LOCK], mode=body[B_MODE], overlap=body[B_OVERLAP],
                persist=body[B_PERSIST], target=g(B_TARGET, '<h'), winsnd=body[B_WINSND],
                area=struct.unpack_from('<4i', body, B_AREA), anim_area=struct.unpack_from('<4i', body, B_ANIM_AREA),
                zone=(g(B_ZH, '<h'), g(B_ZW, '<h')), btn_a=struct.unpack_from('<4i', body, B_BTN_A),
                btn_b=struct.unpack_from('<4i', body, B_BTN_B), cols=g(B_GCOLS, '<h'),
                anim=cstr(body[B_ANIM_NAME:B_ANIM_NAME + 0x21]), multi=cstr(body[B_MULTI:B_MULTI + 0x21]))


_CORPUS = None


def corpus_rows():
    """The 2 raw 0xeb rows of the owner's local resources (never printed; only counts and hashes leave here)."""
    global _CORPUS
    if _CORPUS is None:
        c = json.loads((PRIVATE / 'A-EB.1.corpus.json').read_text())
        out = []
        for r in c['records']:
            data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % r['resource_index'])).read_bytes()
            p, n = r['raw_body_offset'], r['raw_body_length']
            body = data[p:p + n]
            if len(body) != BODY_LEN + r['dependency_tail_length'] or sha(body) != r['body_sha256'] or \
               data[r['act_payload_offset'] + 48] != 0xeb:
                raise OracleError('corpus row source mismatch')
            if sha(body[:BODY_LEN]) != r['typed_body_sha256']:
                raise OracleError('corpus typed body mismatch')
            out.append(dict(body=body[:BODY_LEN], tail=body[BODY_LEN:], subtype=data[r['act_payload_offset'] + 49],
                            resource=r['resource_index'], action=r['action_index']))
        _CORPUS = out
    return _CORPUS


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out, strict=True):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic'] + (['-Werror'] if strict else []) + [
        '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}', str(PROJECT / 'tests/action_family_eb_runtime_oracle_driver.c'),
        str(Path(src_dir) / 'action_family_eb_runtime.c'), '-o', str(out)]
    if os.environ.get('EB_SANITIZE'):
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p, u32p, i32p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8), C.POINTER(C.c_uint32), C.POINTER(C.c_int32)
    lib.ebo_new.restype = p
    for name, args, res in (
            ('ebo_free', [p], None), ('ebo_set_view', [p, i32p], None), ('ebo_set_world_flag', [p, i32], None),
            ('ebo_get_world_flag', [p], i32), ('ebo_set_captions', [p, i32], None),
            ('ebo_set_handles', [p, u32p, C.c_int], None), ('ebo_world', [p, u8p], None), ('ebo_set_world', [p, u8p], None),
            ('ebo_world_reset', [p], None),
            ('ebo_set_queues', [p, u32p, C.c_int, i32p, C.c_int], None),
            ('ebo_consumed', [p, i32p], None), ('ebo_clear_texts', [p], None),
            ('ebo_add_text', [p, C.c_char_p, C.c_char_p], None), ('ebo_set_busy_slot', [p, C.c_int, C.c_int], None),
            ('ebo_set_entry_u32', [p, C.c_int, C.c_int, C.c_uint32], None), ('ebo_set_cells', [p, i32p], None),
            ('ebo_get_cells', [p, i32p], None), ('ebo_set_events', [p, i32p], None), ('ebo_get_events', [p, i32p], None),
            ('ebo_entries', [p, u8p], None), ('ebo_set_entries', [p, u8p], None), ('ebo_clear_log', [p], None),
            ('ebo_log_count', [p], C.c_int), ('ebo_bad_slot_calls', [p], C.c_int), ('ebo_log', [p, C.c_int, i32p], None),
            ('ebo_log_text', [p, C.c_int], C.c_char_p), ('ebo_set_body', [p, C.c_int, u8p, C.c_size_t], C.c_int),
            ('ebo_get_body', [p, C.c_int, u8p, C.c_size_t], None), ('ebo_why', [p], C.c_char_p),
            ('ebo_object', [p, u8p], None), ('ebo_set_object', [p, u8p], None),
            ('ebo_step', [p, C.c_int, C.c_int, C.c_uint32, u32p], C.c_int),
            ('ebo_pointer', [p, C.c_int, C.c_int, C.c_int, i32p, i32p], C.c_int),
            ('ebo_click', [p, C.c_int, C.c_uint32, i32, u32p], C.c_int), ('ebo_rotkey', [p, C.c_int, C.c_uint32], C.c_int),
            ('ebo_invalidate', [p], C.c_int), ('ebo_cleanup', [p], C.c_int), ('ebo_plan', [p, C.c_int, i32p], C.c_int),
            ('ebo_validate', [u8p, C.c_size_t], C.c_int)):
        f = getattr(lib, name)
        f.argtypes = args
        f.restype = res
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


MAX_BLITS = 100


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.ebo_new()

    def close(self):
        self.lib.ebo_free(self.h)

    def set_view(self, v):
        self.lib.ebo_set_view(self.h, (C.c_int32 * 6)(*v))

    def set_handles(self, hs):
        self.lib.ebo_set_handles(self.h, (C.c_uint32 * max(1, len(hs)))(*hs), len(hs))

    def set_queues(self, ticks, busy):
        self.lib.ebo_set_queues(self.h, (C.c_uint32 * max(1, len(ticks)))(*[v & 0xffffffff for v in ticks]), len(ticks),
                                (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy]), len(busy))

    def consumed(self):
        t = (C.c_int32 * 8)()
        self.lib.ebo_consumed(self.h, t)
        return list(t)

    def set_texts(self, texts):
        self.lib.ebo_clear_texts(self.h)
        for k, v in texts.items():
            self.lib.ebo_add_text(self.h, k, v)

    def set_body(self, i, body):
        self.lib.ebo_set_body(self.h, i, cbuf(body), len(body))

    def body(self, i):
        t = (C.c_uint8 * BODY_LEN)()
        self.lib.ebo_get_body(self.h, i, t, BODY_LEN)
        return bytes(t)

    def log(self):
        out = []
        t = (C.c_int32 * 13)()
        for i in range(self.lib.ebo_log_count(self.h)):
            self.lib.ebo_log(self.h, i, t)
            out.append((t[0], tuple(t[1:13]), (self.lib.ebo_log_text(self.h, i) or b'')))
        return out

    def clear(self):
        self.lib.ebo_clear_log(self.h)

    def step(self, ri, row, phase):
        self.clear()
        res = (C.c_uint32 * 3)()
        status = self.lib.ebo_step(self.h, ri, row, phase, res)
        return status, (self.lib.ebo_why(self.h) or b'').decode(), self.log(), list(res)

    def pointer(self, ri, x, y, rect):
        self.clear()
        out = (C.c_int32 * 6)()
        status = self.lib.ebo_pointer(self.h, ri, x, y, (C.c_int32 * 4)(*rect), out)
        return status, list(out), self.log()

    def click(self, ri, row_phase, cand):
        self.clear()
        newp = C.c_uint32(0)
        status = self.lib.ebo_click(self.h, ri, row_phase, cand, C.byref(newp))
        return status, newp.value, self.log()

    def rotkey(self, ri, row_phase):
        self.clear()
        return self.lib.ebo_rotkey(self.h, ri, row_phase), self.log()

    def simple(self, fn):
        self.clear()
        status = fn(self.h)
        return status, self.log()

    def obj(self):
        t = (C.c_uint8 * OBJ_LEN)()
        self.lib.ebo_object(self.h, t)
        return bytes(t)

    def set_obj(self, raw):
        self.lib.ebo_set_object(self.h, cbuf(raw))

    def world(self):
        t = (C.c_uint8 * SAVED_LEN)()
        self.lib.ebo_world(self.h, t)
        return bytes(t)

    def set_world(self, raw):
        self.lib.ebo_set_world(self.h, cbuf(raw))

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.ebo_entries(self.h, t)
        return bytes(t)

    def set_entries(self, raw):
        self.lib.ebo_set_entries(self.h, cbuf(raw))

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.ebo_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        self.lib.ebo_set_cells(self.h, (C.c_int32 * 8)(*v))

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.ebo_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        self.lib.ebo_set_events(self.h, (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw))

    def plan(self, ri):
        t = (C.c_int32 * (2 + 11 * MAX_BLITS))()
        status = self.lib.ebo_plan(self.h, ri, t)
        v = list(t)
        blits = []
        for i in range(v[1] if 0 <= v[1] <= MAX_BLITS else 0):
            q = v[2 + 11 * i:13 + 11 * i]
            blits.append(dict(kind=q[0], src_kind=q[1], surface=q[2] & 0xffffffff, src=q[3:7], dst=q[7:11]))
        return status, dict(valid=v[0], count=v[1], blits=blits)


# ---------------------------------------------------------------------------------------------
# original side
# ---------------------------------------------------------------------------------------------
def parse_imports(path, base):
    data = Path(path).read_bytes()
    pe = struct.unpack_from('<I', data, 0x3c)[0]
    nsec = struct.unpack_from('<H', data, pe + 6)[0]
    opt = struct.unpack_from('<H', data, pe + 20)[0]
    secs = []
    for i in range(nsec):
        _n, vs, va, rs, ro = struct.unpack_from('<8sIIII', data, pe + 24 + opt + 40 * i)
        secs.append((va, max(vs, rs), ro))

    def off(rva):
        for va, sz, ro in secs:
            if va <= rva < va + sz:
                return ro + rva - va
        raise OracleError('rva %#x outside sections' % rva)
    imp_rva = struct.unpack_from('<I', data, pe + 24 + 96 + 8)[0]
    out = []
    o = off(imp_rva)
    while True:
        oft, _ts, _fc, name, ft = struct.unpack_from('<IIIII', data, o)
        if not name and not ft:
            break
        t = off(oft or ft)
        k = 0
        while True:
            thunk = struct.unpack_from('<I', data, t + 4 * k)[0]
            if not thunk:
                break
            nm = 'ord%d' % (thunk & 0xffff) if thunk & 0x80000000 else cstr(data[off(thunk) + 2:off(thunk) + 66]).decode()
            out.append((nm, base + ft + 4 * k))
            k += 1
        o += 20
    return out


def canon_tag(kind, tag):
    """Image loads must carry the original's exact tag; piece surface tags are compared by their common prefix."""
    if kind == b'LOAD':  # idempotent: an already canonical class passes through
        c = LOAD_TAGS.get(tag, tag if tag in LOAD_TAGS.values() else None)
        return c if c is not None else b'?' + tag
    return b'PIECE' if tag.startswith(TAG_PIECE) or tag == b'PIECE' else b'?' + tag


def pad12(v):
    v = list(v)[:12]
    return tuple(s32(a) for a in v) + (0,) * (12 - len(v))


class X86(deps.OriginalMachine):
    def __init__(self):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.pristine = bytes(self.pe.image)
        if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
            raise OracleError('executable identity mismatch')
        self.pins = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
            self.pins.append((a, z, digest))
        self._check_hook_rets()
        self._check_strings()
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(BODY_BASE, 0x10000)
        uc.mem_map(SCRATCH, SCRATCH_SIZE)
        uc.mem_map(TIB, 0x1000)
        uc.mem_map(GDT, 0x1000)
        uc.mem_map(STUBS, 0x1000)
        uc.mem_write(STUBS, b'\xc3' * 0x1000)

        def seg(base, limit, access, flags):
            return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access,
                               ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
        uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc)
                     + seg(TIB, 0xfff, 0x93, 0x4))
        uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
        uc.reg_write(X.UC_X86_REG_CS, 0x08)
        for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
            uc.reg_write(reg, 0x10)
        uc.reg_write(X.UC_X86_REG_FS, 0x18)
        self.rec = False
        self.fx = []
        self.entered = []
        self.entered_obj = []
        self.allocs = {}
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.blits = []
        self.handles, self.handle_i = [], 0
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.texts = {}
        self.surf_n = 0
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
        self._hook_error = None
        self.rowbase = 0
        self._install_imports()
        self._install_hooks()

    def _check_hook_rets(self):
        from capstone import Cs, CS_ARCH_X86, CS_MODE_32
        md = Cs(CS_ARCH_X86, CS_MODE_32)
        base = self.pe.image_base
        for a, (span, imm) in HOOK_RETS.items():
            rets = {int(i.op_str, 0) if i.op_str else 0
                    for i in md.disasm(self.pristine[a - base:a - base + span], a) if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise OracleError('hooked function %#x: ret immediates %s, expected %s' % (a, rets, imm))
        for a, (imm, _ecx) in REPLACED.items():
            if a in HOOK_RETS and HOOK_RETS[a][1] != imm:
                raise OracleError('REPLACED table disagrees at %#x' % a)
        # the entry points the oracle drives: `ret N` immediates of the 0xeb class (asm/FUN_*.s)
        for a, z, imm in ((0x47f421, 0x47fa11, 0xc), (0x47ff0e, 0x4809a7, 0), (0x47ef0f, 0x47f19d, 0), (0x47e440, 0x47e477, 0),
                          (0x47e2a5, 0x47e3f7, 0), (0x47e3f7, 0x47e440, 0), (0x47e25a, 0x47e2a5, 0), (0x481cb9, 0x482054, 0),
                          (0x480e02, 0x481c8d, 4)):
            rets = {int(i.op_str, 0) if i.op_str else 0 for i in md.disasm(self.pristine[a - base:z - base], a) if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise OracleError('entry %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def _check_strings(self):
        base = self.pe.image_base
        for va, text in ((0x54d5f4, b'CIFTREE'), (0x54d620, b'CIFTREE'), (0x54d644, b'CIFTREE'), (0x54d5dc, TAG_SRC),
                         (0x54d604, TAG_MULTI), (0x54d630, TAG_ANIM), (0x54d5fc, NO_FILE), (0x54d628, NO_FILE),
                         (0x54d64c, b'MULTIBUILD PUZZLE OVERLAYS'), (0x54d668, NO_SOUND)):
            have = cstr(self.pristine[va - base:va - base + 64])
            if have != text:
                raise OracleError('string at %#x differs from the packet' % va)
        for va in (0x54d4f0, 0x54d564):
            if not self.pristine[va - base:va - base + len(TAG_PIECE)] == TAG_PIECE:
                raise OracleError('piece tag at %#x differs from the packet' % va)

    # -- imports (OS boundary) ---------------------------------------------------------------
    def _install_imports(self):
        for idx, (nm, iat) in enumerate(parse_imports(DEFAULT_EXE, self.pe.image_base)):
            self.imports[STUBS + 16 * idx] = (nm, iat)
        for stub in self.imports:
            self.machine.hook_add(UC_HOOK_CODE, self._guard(self._on_import), begin=stub, end=stub)
        self._patch_iat()

    def _patch_iat(self):
        for stub, (_n, iat) in self.imports.items():
            self.machine.mem_write(iat, struct.pack('<I', stub))

    def _on_import(self, uc, address, size, user):
        name, _iat = self.imports[address]
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        arg0 = u32(uc, sp + 4)
        if name in ('InterlockedIncrement', 'InterlockedDecrement'):
            d = 1 if name.endswith('Increment') else -1
            v = (struct.unpack('<i', bytes(uc.mem_read(arg0, 4)))[0] + d) & 0xffffffff
            uc.mem_write(arg0, struct.pack('<I', v))
            self._ret(uc, 4, v)
        elif name in ('EnterCriticalSection', 'LeaveCriticalSection', 'InitializeCriticalSection'):
            self._ret(uc, 4, 0)
        elif name == 'lstrlenA':
            n = 0
            while uc.mem_read(arg0 + n, 1)[0] != 0:
                n += 1
            self._ret(uc, 4, n)
        elif name == 'GetTickCount':
            if self.tick_i >= len(self.tick_q):
                raise OracleError('tick queue underflow')
            v = self.tick_q[self.tick_i] & 0xffffffff
            self.tick_i += 1
            self.log(LOGKINDS['TICK'], (s32(v),))
            self._ret(uc, 0, v)
        else:
            raise OracleError('unexpected Windows import %s called from %#x' % (name, u32(uc, sp)))
        self.counters['os:' + name] += 1

    # -- hook plumbing -------------------------------------------------------------------------
    def _guard(self, fn):
        def run(uc, address, size, user):
            try:
                fn(uc, address, size, user)
            except Fatal as error:
                self._fatal = error.address
                self._hook_error = str(error)
                uc.emu_stop()
            except Exception as error:  # reported by call() after emu_stop
                self._hook_error = 'hook %#x: %r' % (address, error)
                uc.emu_stop()
        return run

    def _ret(self, uc, pop, eax=None):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ret = u32(uc, sp)
        uc.reg_write(X.UC_X86_REG_ESP, sp + 4 + pop)
        if eax is not None:
            uc.reg_write(X.UC_X86_REG_EAX, eax & 0xffffffff)
        uc.reg_write(X.UC_X86_REG_EIP, ret)

    def _on_code(self, uc, address, size, user):  # base-class hooks: allocator, debug printer, bad tree
        try:
            if address != deps.ORIGINAL_ALLOCATOR:
                raise OracleError('unexpected diagnostic/fatal path %#x' % address)
            self._malloc(uc)
        except Exception as error:
            self._hook_error = 'hook %#x: %r' % (address, error)
            uc.emu_stop()

    def _malloc(self, uc):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        size = u32(uc, sp + 4)
        start = (self.heap_cursor + 15) & ~15
        end = start + max(size, 1) + 16
        if end > HEAP_BASE + HEAP_SIZE:
            raise OracleError('oracle heap exhausted for %d bytes' % size)
        self.heap_cursor = end
        self.heap_high = max(self.heap_high, end)
        self.allocs[start] = size
        self.counters['malloc'] += 1
        uc.reg_write(X.UC_X86_REG_EAX, start)
        self._ret(uc, 0)

    def _install_hooks(self):
        uc = self.machine
        table = {}
        for a in REPLACED:
            table[a] = self._replaced
        for a in GUARDS:
            table[a] = self._raise
        table[HANDLER] = self._entry
        table[0x42ba3a] = self._complete
        table[0x4d3992] = self._release_entry
        table[0x4d39f9] = self._alloc_entry
        table[AT_COPY] = self._at_copy
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _raise(self, uc, address, size, user):
        if address == self.expect_fatal:
            raise Fatal(address)
        raise OracleError('guarded original routine %#x reached' % address)

    # -- state access --------------------------------------------------------------------------
    def rd(self, a, n):
        return bytes(self.machine.mem_read(a, n))

    def rs16(self, a):
        return struct.unpack('<h', self.rd(a, 2))[0]

    def rs32(self, a):
        return struct.unpack('<i', self.rd(a, 4))[0]

    def wr(self, a, b):
        self.machine.mem_write(a, bytes(b))

    def w32(self, a, v):
        self.wr(a, struct.pack('<I', v & 0xffffffff))

    def image(self):
        return self.rd(OBJ, OBJ_LEN)

    def saved(self):
        return self.rd(SAVED_VA, SAVED_LEN)

    def entries(self):
        return self.rd(ENTRY, NENT * STRIDE)

    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

    def body(self, ri):
        return self.rd(BODY_BASE + BODY_STRIDE * ri, BODY_LEN)

    def events_raw(self):
        return self.rd(EVENTS_VA, 4 * EVENT_COUNT)

    def cells(self):
        out = []
        for a, sz in CELLS:
            out.append(self.rs32(a) if sz == 4 else self.rs16(a))
        out.append(self.rs32(G_MODE))
        return out

    # -- effects ---------------------------------------------------------------------------------
    def log(self, kind, v=(), text=b''):
        if self.rec:
            self.fx.append((kind, pad12(v), bytes(text)))

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('handler entered with ECX != 0x625ee8')
        phase = self.row_phase(row)
        self.rowbase = BODY_BASE + BODY_STRIDE * row  # the body allocation the handler reads its sound records from
        self.entered.append((row, phase))
        self.entered_obj.append(self.rs16(OBJ + O_ROW))
        if phase == 1:
            self.counters['phase1_state_%d' % self.rs32(OBJ + O_STATE)] += 1
        self.fx.append((LOGKINDS['ENTER'], pad12((row, phase)), b''))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(LOGKINDS['COMPLETE'], (struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0],))

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(LOGKINDS['RELEASE_SLOT'], (struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0],))

    def _alloc_entry(self, uc, address, size, user):
        self.log(LOGKINDS['ALLOC'])

    def _at_copy(self, uc, address, size, user):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        dst = u32(uc, u32(uc, ebp - 0x14))
        src = uc.reg_read(X.UC_X86_REG_EAX)
        self.log(LOGKINDS['COPY'], (dst, src))

    def sound_id(self, ptr):
        if self.rowbase <= ptr < self.rowbase + BODY_LEN:
            return ptr - self.rowbase
        raise OracleError('sound record pointer %#x is not in the active body' % ptr)

    def surf_struct(self, handle):
        if not SURF_BASE <= handle < SURF_BASE + SURF_STRIDE * SURF_MAX or (handle - SURF_BASE) % SURF_STRIDE:
            raise OracleError('surface handle %#x is not a fake struct' % handle)

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        pop, want_ecx = REPLACED[address]
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if want_ecx is not None and ecx != want_ecx:
            raise OracleError('hook %#x entered with ECX %#x' % (address, ecx))
        eax = 0
        K = LOGKINDS
        if address == 0x4c2790:
            kind, name, six, tag = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            if kind != b'CIFTREE' or six != 6:
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.log(K['LOAD'], (eax,), name + b'|' + canon_tag(b'LOAD', tag))
        elif address == 0x4c2a8d:
            w, h, six, tag = s16(a[0]), s16(a[1]), a[2], cstr(self.rd(a[3], 64))
            if six != 6:
                raise OracleError('surface creator argument 6')
            if self.surf_n >= SURF_MAX:
                raise OracleError('too many fake surfaces')
            eax = SURF_BASE + SURF_STRIDE * self.surf_n
            self.surf_n += 1
            blob = bytearray(SURF_STRIDE)
            struct.pack_into('<I', blob, 0, eax + 0x80)
            struct.pack_into('<I', blob, 0x23, 0x20)
            struct.pack_into('<h', blob, 0x2b, w)
            struct.pack_into('<h', blob, 0x2d, h)
            struct.pack_into('<h', blob, 0x2f, w)
            for k in range(0x80, 0xa0):
                blob[k] = (eax >> 4 & 0xff) ^ k
            self.wr(eax, blob)
            self.log(K['CREATE'], (w, h, eax), canon_tag(b'CREATE', tag))
        elif address == 0x4c51a5:
            rect = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.log(K['BLIT'], [a[0], a[1]] + rect(a[2]) + rect(a[3]))
            tag = cstr(self.rd(a[4], 64))
            self.counters['blit_tag:' + sha(tag)[:8]] += 1
        elif address == 0x4c7070:
            s = a[0]
            self.surf_struct(s)
            w, h = self.rs16(s + 0x2b), self.rs16(s + 0x2d)
            self.wr(s + 0x2b, struct.pack('<h', h))
            self.wr(s + 0x2d, struct.pack('<h', w))
            self.wr(s + 0x2f, struct.pack('<h', h))
            self.log(K['ROTATE'], (s,))
        elif address == 0x4c2dfb:
            old = u32(uc, a[0])
            self.log(K['RELEASE'], (old,))
            self.wr(a[0], bytes(4))
        elif address == 0x4e8d96:
            self.log(K['CLEAR_ITEM'])
        elif address in (0x4fb77a, 0x4fba69):
            rec = self.rd(a[0], 0x31)
            self.log(K['SND_PREPARE'] if address == 0x4fb77a else K['SND_STOP'], (self.sound_id(a[0]),), rec.hex().encode())
        elif address == 0x4fb2e3:
            self.log(K['SND_PLAY'], (s16(a[0]),))
        elif address == 0x4f6334:
            if self.busy_i >= len(self.busy_q):
                raise OracleError('busy queue underflow')
            eax = self.busy_q[self.busy_i] & 0xffffffff
            self.busy_i += 1
            self.log(K['SND_BUSY'], (s16(a[0]), s32(eax)))
        elif address == 0x423259:
            key = cstr(self.rd(a[0], 0x40))
            found = key in self.texts
            if found:
                idx = list(self.texts).index(key)
                self.wr(TEXT_BASE + TEXT_STRIDE * idx, self.texts[key] + b'\0')
                eax = TEXT_BASE + TEXT_STRIDE * idx
            self.log(K['AUTOTEXT'], (1 if found else 0,), key)
        elif address == 0x448d11:
            if a[0] != MARK_CAPSURF or s32(a[2]) != -1 or a[3] != 0:
                raise OracleError('caption show arguments %s' % [hex(v) for v in a[:4]])
            self.log(K['CAPTION'], (), cstr(self.rd(a[1], 512)))
        elif address in (0x4c5377, 0x4c5d4b):
            rect = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.blits.append(dict(kind=0 if address == 0x4c5377 else 1, src_surface=a[0], dst_surface=a[1], src=rect(a[2]),
                                   dst=rect(a[3]), src_ptr=a[2], dst_ptr=a[3], tag=cstr(self.rd(a[4], 40))))
        else:
            raise OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, pop, eax)

    # -- scenario plumbing ------------------------------------------------------------------------
    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(HEAP_BASE, bytes(self.heap_high - HEAP_BASE))
        uc.mem_write(BODY_BASE, bytes(0x10000))
        uc.mem_write(SCRATCH, bytes(0x10000))
        uc.mem_write(TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, FPCW)
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.allocs.clear()
        self.blits = []
        self.fx = []
        self.entered = []
        self.handles, self.handle_i = [], 0
        self.tick_q, self.tick_i, self.busy_q, self.busy_i = [], 0, [], 0
        self.texts = {}
        self.surf_n = 0
        self.rec = False
        self.expect_fatal = None
        self.rowbase = 0
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.call(0x47e25a, [], OBJ)  # the object reset, original code
        self.call(0x47e3f7, [], OBJ)  # the saved-state power-on reset, original code
        self.w32(G_CAPSURF, MARK_CAPSURF)
        self.w32(G_CURSOR_SRC, MARK_CURSOR_SRC)
        self.w32(G_SAVED, MARK_SAVED)
        self.w32(G_BACK, MARK_BACK)

    def install_rows(self, rows, first=0):
        """`rows`: list of dict(body, tail, subtype). Rows below `first` are completed dummies."""
        total = first + len(rows)
        if total > MAX_ROWS:
            raise OracleError('too many rows')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            body_at = BODY_BASE + BODY_STRIDE * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([0xeb, spec.get('subtype', 1)]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = TAIL_BASE + i * 0x400
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def set_queues(self, ticks, busy):
        self.tick_q, self.tick_i = list(ticks), 0
        self.busy_q, self.busy_i = list(busy), 0

    def dispatch(self):
        self.fx = []
        self.entered = []
        self.entered_obj = []
        self.wr(0x5c3a47, bytes(4))
        self.rec = True
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.rec = False

    def run_op(self, address, args, ecx):
        """A directly driven entry point; the effects land in self.fx."""
        self.fx = []
        self.rec = True
        try:
            return self.call(address, args, ecx)[0]
        finally:
            self.rec = False

    def call(self, address, args, ecx):
        uc = self.machine
        self._hook_error = None
        self._fatal = None
        words = [deps.RETURN_SENTINEL, *[v & 0xFFFFFFFF for v in args]]
        uc.mem_write(TIB, bytes(8))  # empty SEH chain
        uc.mem_write(deps.STACK_TOP, struct.pack('<' + 'I' * len(words), *words))
        uc.reg_write(X.UC_X86_REG_ESP, deps.STACK_TOP)
        uc.reg_write(X.UC_X86_REG_ECX, ecx)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        try:
            uc.emu_start(address, deps.RETURN_SENTINEL, timeout=900_000_000, count=0)
        except UcError as error:
            eip = uc.reg_read(X.UC_X86_REG_EIP)
            if self._hook_error:
                raise OracleError(self._hook_error) from error
            raise OracleError('x86 call %#x failed at %#x: %s' % (address, eip, error)) from error
        if self._fatal is not None:
            raise Fatal(self._fatal)
        if self._hook_error:
            raise OracleError(self._hook_error)
        if uc.reg_read(X.UC_X86_REG_EIP) != deps.RETURN_SENTINEL:
            raise OracleError('x86 call %#x stopped at %#x' % (address, uc.reg_read(X.UC_X86_REG_EIP)))
        return uc.reg_read(X.UC_X86_REG_EAX), True


# ---------------------------------------------------------------------------------------------
# comparison
# ---------------------------------------------------------------------------------------------
def fx_text(t):
    k, v, s = t
    nz = [a for a in v]
    while nz and nz[-1] == 0:
        nz.pop()
    return '%s%s%s' % (KN.get(k, k), tuple(nz), (' ' + s.decode('latin1')[:60]) if s else '')


def norm_nat(seq):
    out = []
    for k, v, s in seq:
        s = bytes(s)
        if k == LOGKINDS['LOAD']:
            name, _, tag = s.partition(b'|')
            s = name + b'|' + canon_tag(b'LOAD', tag)
        elif k == LOGKINDS['CREATE']:
            s = canon_tag(b'CREATE', s)
        out.append((k, pad12(v), s))
    return out


def compare_log(where, orig, nat):
    orig, nat = list(orig), norm_nat(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        raise Mismatch('%s host call %d: original %s vs native %s (original %d calls, native %d)' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None,
            len(orig), len(nat)))


_OBJ_NAMES = sorted((v, k[2:].lower()) for k, v in globals().items() if k.startswith('O_') and isinstance(v, int)
                    and k not in ('O_ENTRIES', 'O_PIECES', 'O_COUNTS'))


def field_of(off):
    if O_PIECES <= off < O_PIECES + 80 * PIECE:
        i, r = divmod(off - O_PIECES, PIECE)
        return 'piece%d+%#x' % (i, r)
    if O_ENTRIES <= off < O_COUNTS:
        t, r = divmod(off - O_ENTRIES, 0x60)
        return 'entry%d.%d+%#x' % (t, r // 0x18, r % 0x18)
    if O_COUNTS <= off < O_PIECES:
        return 'counter%d' % (off - O_COUNTS)
    best = '?'
    for o, n in _OBJ_NAMES:
        if o <= off:
            best = '%s+%#x' % (n, off - o)
    return best


def saved_field(off):
    if off < 4:
        return 'saved_flag'
    if off < 6:
        return 'saved_scene'
    if off < 26:
        return 'saved_counter%d' % (off - 6)
    if off < 26 + 80 * PIECE:
        i, r = divmod(off - 26, PIECE)
        return 'saved_piece%d+%#x' % (i, r)
    return 'saved_count' if off < 26 + 80 * PIECE + 2 else 'saved_total'


def first_diff(a, b):
    return next(i for i in range(min(len(a), len(b))) if a[i] != b[i])


def compare_state(where, ctx):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['state_compares'] += 1
    oi, ni = x.image(), nat.obj()
    stats['object_bytes'] += len(oi)
    if oi != ni:
        k = first_diff(oi, ni)
        raise Mismatch('%s object %s (+%#x): original %02x native %02x' % (where, field_of(k), k, oi[k], ni[k]))
    sv, ns = x.saved(), nat.world()
    stats['saved_bytes'] += len(sv)
    if sv != ns:
        k = first_diff(sv, ns)
        raise Mismatch('%s saved state %s (+%#x): original %02x native %02x' % (where, saved_field(k), k, sv[k], ns[k]))
    for r in range(ctx.first + len(ctx.rows)):
        ob, nb = x.body(r), nat.body(r)
        stats['body_bytes'] += len(ob)
        if ob != nb:
            k = first_diff(ob, nb)
            raise Mismatch('%s body of row %d +%#x: original %02x native %02x' % (where, r, k, ob[k], nb[k]))
    if x.rs32(START_FLAG) != nat.lib.ebo_get_world_flag(nat.h):
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), nat.lib.ebo_get_world_flag(nat.h)))
    oc, nc = x.cells(), nat.cells()
    stats['cells'] += len(oc)
    if oc != nc:
        k = first_diff(oc, nc)
        raise Mismatch('%s scene-change cell %d: original %d native %d' % (where, k, oc[k], nc[k]))
    ea, eb = x.entries(), nat.entries()
    stats['entry_bytes'] += len(ea)
    if ea != eb:
        k = first_diff(ea, eb)
        raise Mismatch('%s entry table slot %#x +%#x original %02x native %02x' % (where, k // STRIDE, k % STRIDE, ea[k], eb[k]))
    ev, nv = x.events_raw(), nat.events()
    stats['event_bytes'] += len(ev)
    if ev != nv:
        k = first_diff(ev, nv)
        raise Mismatch('%s event flag %d: original %02x native %02x' % (where, k // 4, ev[k], nv[k]))
    for row in range(ctx.first + len(ctx.rows)):
        if x.row_phase(row) != ctx.phase.get(row, 0):
            raise Mismatch('%s row %d phase: original %d model %d' % (where, row, x.row_phase(row), ctx.phase.get(row, 0)))
        if x.row_complete(row) != ctx.complete.get(row, 0):
            raise Mismatch('%s row %d completion byte: original %d model %d' % (where, row, x.row_complete(row), ctx.complete.get(row, 0)))
    if x.rs32(G_CAND) != ctx.cand:
        raise Mismatch('%s candidate 0x5c39e5: original %d model %d' % (where, x.rs32(G_CAND), ctx.cand))


def resync(ctx):
    """After a native-only refusal (the original was not run): the native side takes the original's state again."""
    x, nat = ctx.x, ctx.nat
    nat.set_obj(x.image())
    nat.set_world(x.saved())
    nat.set_cells(x.cells())
    nat.set_events(x.events_raw())
    nat.set_entries(x.entries())
    nat.lib.ebo_set_world_flag(nat.h, x.rs32(START_FLAG))


# ---------------------------------------------------------------------------------------------
# scenario execution
# ---------------------------------------------------------------------------------------------
VIEWS = {'v0': (0, 0, 0, 0, 639, 479), 'v1': (13, 21, 0, 0, 639, 479), 'neg': (-40, -25, 10, 10, 500, 400),
         'tight': (0, 0, 60, 50, 300, 260), 'big': (300, 200, 0, 0, 1000, 800), 'edge': (0x7ffffff0, -0x7ffffff0, -50, -50, 700, 520)}
CLOCKS = {'low': 100, 'mid': 0x7fffff00, 'sign': 0x7ffffff0, 'wrap': 0xfffff000, 'top': 0xfffffff8}
CLK = {'ticks': 'clock'}


def gate_open(ctx, spec):
    t = spec.get('tail') or b''
    ok = True
    for r in range(len(t) // 16):
        rec = struct.unpack_from('<8h', t, 16 * r)
        ok = ok and ctx.x.rs32(EVENTS_VA + 4 * rec[1]) == rec[2]
    return ok


class Ctx:
    pass


def make_ctx(x, lib, sc, stats):
    ctx = Ctx()
    ctx.x, ctx.lib, ctx.stats, ctx.sc = x, lib, stats, sc
    ctx.nat = Native(lib)
    ctx.rows, ctx.first = list(sc['rows']), sc['first']
    ctx.phase, ctx.complete = {}, {}
    ctx.rng = random.Random(sc.get('seed', 1))
    ctx.clock = CLOCKS['low']
    ctx.cand = 0
    ctx.view = VIEWS['v0']
    ctx.stop = False
    ctx.skip_final = False
    ctx.tickno = 0
    return ctx


def row_body(ctx, row):
    k = row - ctx.first
    return ctx.rows[k]['body'] if 0 <= k < len(ctx.rows) else None


def obj_row(ctx):
    r = ctx.x.rs16(OBJ + O_ROW)
    return r if row_body(ctx, r) is not None else None


def active_ri(ctx):
    r = obj_row(ctx)
    return r if r is not None else ctx.first


def make_queues(ctx, spec):
    """Tick values and busy answers for one operation; both sides receive the same lists."""
    x, rng = ctx.x, ctx.rng
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 16)
    d1, d2 = struct.unpack('<II', x.rd(OBJ + O_DEADLINE, 4) + x.rd(OBJ + O_DEADLINE2, 4))
    if policy == 'clock':
        base = ctx.clock
        ticks = [(base + i) & 0xffffffff for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', (0, 1, 7, 100, 150, 300, 301, 800, 1500, 2500, 9000)))) & 0xffffffff
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 99, 100, 101, 199, 200, 201, 299, 300, 301, 349, 350, 351, 799, 800, 0x80000000, -0x80000000,
                0x7fffffff]
        dl = rng.choice([d1, d2, d1, d2, ctx.clock])
        ticks = [(dl + rng.choice(offs)) & 0xffffffff for _ in range(n)]
        if rng.random() < 0.5:
            ticks = sorted(ticks, key=lambda v: (v - dl) & 0xffffffff)
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, d1, d1 - 1, d2, d2 + 1, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)])
                 & 0xffffffff for _ in range(n)]
    else:
        ticks = list(policy) + [policy[-1]] * max(0, n - len(policy))
    b = spec.get('busy', 'rand')
    if b == 'zero':
        busy = [0] * 8
    elif b == 'one':
        busy = [1] * 8
    elif b == 'rand':
        busy = [rng.choice([0, 0, 1, 1, 1, 2, -1]) for _ in range(8)]
    else:
        busy = list(b) + [0] * 8
    return ticks, busy


def set_queues(ctx, spec):
    ticks, busy = make_queues(ctx, spec)
    ctx.x.set_queues(ticks, busy)
    ctx.nat.set_queues(ticks, busy)


def check_consumption(where, ctx):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    nc = nat.consumed()
    oc = (x.tick_i, x.busy_i)
    if oc != tuple(nc[:2]) or nc[2] or nc[3] or nc[4]:
        raise Mismatch('%s queue consumption original %s native %s' % (where, oc, nc))
    stats['ticks_consumed'] += x.tick_i
    stats['busy_consumed'] += x.busy_i
    if nat.lib.ebo_bad_slot_calls(nat.h):
        raise Mismatch('%s native used an out-of-range slot' % where)


def check_entry(ctx, mode, row, last_row):
    """Sanity of the original dispatcher's choice (the gate 0x423f57 is original code): ascending rows, engine mode 3,
    row not completed, not disabled."""
    x = ctx.x
    if mode != 3:
        return 'engine mode %d' % mode
    if row <= last_row or not ctx.first <= row < ctx.first + len(ctx.rows):
        return 'row %d out of order' % row
    if ctx.complete.get(row, 0):
        return 'row %d already complete' % row
    if x.rd(ROWS + row * ROW + 0x85, 4) != bytes(4):
        return 'row %d disabled' % row
    return None


def note_effects(stats, seq):
    for t in seq:
        stats['effect_kinds'][KN[t[0]]] += 1


def do_tick(ctx, where, spec):
    x, nat, stats, rows, first = ctx.x, ctx.nat, ctx.stats, ctx.rows, ctx.first
    set_queues(ctx, spec)
    mode_model = x.rs32(G_MODE)
    fatal = None
    snapshot_ok = True
    try:
        x.dispatch()
    except Fatal as error:
        fatal = error.address
        x.rec = False
    stats['ticks'] += 1
    entered = list(x.entered)
    nfx = []
    last_row = first - 1
    for n_i, (row, phase) in enumerate(entered):
        bad = check_entry(ctx, mode_model, row, last_row)
        if bad:
            raise Mismatch('%s unexpected handler entry: %s' % (where, bad))
        last_row = row
        if ctx.phase.get(row, 0) != phase:
            raise Mismatch('%s row %d entered with phase %d, model %d' % (where, row, phase, ctx.phase.get(row, 0)))
        nfx.append((LOGKINDS['ENTER'], pad12((row, phase)), b''))
        x.rowbase = BODY_BASE + BODY_STRIDE * row
        nat.lib.ebo_clear_log(nat.h)
        status, why, log, res = nat.step(row, row, phase)
        nfx.extend(norm_nat(log))
        stats['steps'] += 1
        if status == 3 and phase in (1, 2) and x.entered_obj[n_i] != row:
            # K2: a second row's phase 0 re-initialised the singleton; the original now runs this row's phase 1/2 on the
            # other row's object (mixing the bodies). Native refuses before any effect. Unreachable in the game (one row per scene).
            if log:
                raise Mismatch('%s K2 refusal had effects' % where)
            stats['known_observed']['K2:two-rows-active'] += 1
            ctx.stop = True
            ctx.skip_final = True
            return 0
        if fatal is not None and n_i == len(entered) - 1:
            if status != 4 or nat.consumed()[5] < 1:
                raise Mismatch('%s original reached fatal path %#x but native status %d (%s)' % (where, fatal, status, why))
            ctx.phase[row] = x.row_phase(row)  # the original stores the phase before the slot allocation
            continue
        if status != 0:
            raise Mismatch('%s native refused (status %d: %s) where the original ran' % (where, status, why))
        after = x.row_phase(row)
        # the generic completion 0x42ba3a (observed original code; the executor applies it for `completed`) ends by
        # storing phase 0 into the row, after the handler stored its own phase; phase_after is the handler's value
        want_phase = 0 if res[2] else res[0]
        if after != want_phase:
            raise Mismatch('%s row %d phase: original %d native %d (completed %d)' % (where, row, after, res[0], res[2]))
        if bool(res[1]) != (phase == 0):
            raise Mismatch('%s initialized flag %d for phase %d' % (where, res[1], phase))
        if bool(res[2]) != (phase == 2):
            raise Mismatch('%s completed flag %d for phase %d' % (where, res[2], phase))
        ctx.phase[row] = want_phase
        if res[2]:
            ctx.complete[row] = 1 if rows[row - first].get('subtype', 1) == 1 else 0
            stats['completions'] += 1
        stats['phase%d_steps' % phase if phase in (0, 1, 2) else 'phaseX_steps'] += 1
        if nat.cells()[7] != 3:
            mode_model = nat.cells()[7]
    if fatal is not None:
        stats['fatal_paths_matched'] += 1
        ctx.stop = True
        if fatal != ctx.sc.get('expect_fatal'):
            raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
    compare_log(where, x.fx, nfx)
    stats['host_calls'] += len(nfx)
    note_effects(stats, x.fx)
    check_consumption(where, ctx)
    if not entered:
        stats['gate_closed_ticks'] += 1
    compare_state(where, ctx)
    return len(entered)


# -- the original's object, read for the player and for the refusal predicates ---------------------------------
def inst_count(ctx):
    return ctx.x.rs16(OBJ + O_COUNT)


def inst_type(ctx, i):
    return ctx.x.rd(OBJ + O_PIECES + PIECE * i + 0x23, 1)[0]


def inst_rect(ctx, i):
    return struct.unpack('<4i', ctx.x.rd(OBJ + O_PIECES + PIECE * i + 2, 16))


def inst_flags(ctx, i):
    b = ctx.x.rd(OBJ + O_PIECES + PIECE * i, PIECE)
    return b[0x22], b[0x24]  # orientation, stamped


def valid_inst(ctx, i):
    """The instance indexes the native kernel is willing to touch (K3 otherwise)."""
    n = inst_count(ctx)
    return 0 <= i < n <= 80 and inst_type(ctx, i) < 20


def sane_instances(ctx):
    n = inst_count(ctx)
    return 0 <= n <= 80 and all(inst_type(ctx, j) < 20 for j in range(n))


def list_top(ctx, list_off, count_off):
    x = ctx.x
    n = x.rs16(OBJ + count_off)
    if n == 0:
        return -1
    best = x.rs16(OBJ + list_off)

    def z(i):
        return x.rs16(OBJ + O_PIECES + PIECE * i) if 0 <= i < 128 else 0
    for k in range(1, n):
        cand = x.rs16(OBJ + list_off + 2 * k)
        if z(best) < z(cand):
            best = cand
    return best


def obj_state(ctx):
    x = ctx.x
    row = obj_row(ctx)
    body = row_body(ctx, row) if row is not None else None
    return dict(row=row, active=x.rs32(OBJ + O_ACTIVE), drag=x.rs32(OBJ + O_DRAG), hand=x.rs16(OBJ + O_HAND),
                state=x.rs32(OBJ + O_STATE), done=x.rd(OBJ + O_DONE, 1)[0], n=inst_count(ctx), body=body,
                rp=ctx.phase.get(row, 0) if row is not None else 0, multi_hand=x.rd(OBJ + O_MULTI_HAND, 1)[0],
                has_multi=x.rd(OBJ + O_HAS_MULTI, 1)[0], count1=x.rs16(OBJ + O_COUNT1), count2=x.rs16(OBJ + O_COUNT2))


def under_pointer(ctx, st, px, py):
    """The two list lengths 0x47f421 builds for a pointer position (used only to predict the K5 list overflow)."""
    body = st['body']
    if body is None:
        return 0, 0
    rot, lock = body[B_ROT], body[B_LOCK]
    zh, zw = struct.unpack_from('<hh', body, B_ZH)
    n1 = n2 = 0
    for j in range(max(0, min(st['n'], 80))):
        t = inst_type(ctx, j)
        spawn = body[B_TYPES + BT * t + 0x50]
        _o, stamp = inst_flags(ctx, j)
        if (st['multi_hand'] == 0 or j == st['hand']) and (stamp == 0 or spawn == 0):
            l, tp, r, b = inst_rect(ctx, j)
            if rot == 0 or lock == 0 or py < tp or tp + zh < py or px < l or l + zw < px:
                if tp <= py <= b and l <= px <= r:
                    n1 += 1
            else:
                n2 += 1
    return n1, n2


def pointer_refusal(ctx, st, px, py):
    if not st['active']:
        return None
    if not sane_instances(ctx):
        return 'K3:instances'
    if st['drag'] and not st['multi_hand']:
        return None if valid_inst(ctx, st['hand']) else 'K3:hand'
    n1, n2 = under_pointer(ctx, st, px, py)
    if n1 > 20 or n2 > 20:
        return 'K5:list'
    return None


def do_pointer(ctx, where, px, py, rect=None):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    st = obj_state(ctx)
    ri = active_ri(ctx)
    px, py = s16(px), s16(py)
    if rect is None:
        rect = (px - 3, py - 3, px + 3, py + 3)
    rect = tuple(clamp16(v) if abs(v) < 1 << 31 else v for v in rect)
    why = pointer_refusal(ctx, st, px, py)
    if why:
        status, out, log = nat.pointer(ri, px, py, rect)
        if status != 6:
            raise Mismatch('%s %s expected EB_ERR_BOUNDS from the native pointer move, got %d' % (where, why, status))
        stats['known_observed'][why + ':pointer'] += 1
        resync(ctx)
        return
    x.wr(PTR_RECT, struct.pack('<4i', *rect))
    before = [x.rs32(a) for a in (G_CAND, G_CURSOR, G_CURSOR2, G_E2_SRC, G_E2_REC, G_E2_FLAG)]
    x.fx = []
    ret = x.run_op(0x47f421, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000, PTR_RECT], OBJ)
    after = [x.rs32(a) for a in (G_CAND, G_CURSOR, G_CURSOR2, G_E2_SRC, G_E2_REC, G_E2_FLAG)]
    status, out, log = nat.pointer(ri, px, py, rect)
    if status != 0:
        raise Mismatch('%s native pointer status %d' % (where, status))
    compare_log(where, x.fx, log)
    nhit, ncand, wrote, ncur, nflag, nrec = out
    if ret != nhit:
        raise Mismatch('%s pointer return: original %d native %d' % (where, ret, nhit))
    if wrote:
        want = [ncand, ncur, nflag, s32(MARK_CURSOR_SRC), s32(nrec), 1]
        if after != want:
            raise Mismatch('%s cursor/candidate: original %s native %s' % (where, [hex(v & 0xffffffff) for v in after],
                                                                          [hex(v & 0xffffffff) for v in want]))
        ctx.cand = after[0]
        stats['pointer_hits'] += 1
        for off, v in ((8, after[3]), (0xc, after[4]), (0x14, after[5])):
            nat.lib.ebo_set_entry_u32(nat.h, 2, off, v & 0xffffffff)
        stats['cand_%x' % (ncand & 0xffff)] += 1
    else:
        if after != before:
            raise Mismatch('%s original wrote cursor/candidate %s, native did not' % (where, after))
        if ncand != -1:
            raise Mismatch('%s native candidate %d without a write' % (where, ncand))
    stats['pointer_moves'] += 1
    stats['cursor_words'] += 6
    compare_state(where, ctx)


def click_refusal(ctx, st, cand):
    """Where the original would index an instance the native kernel refuses (K3) or overrun the instance array (K5)."""
    if not (st['active'] and not st['done'] and st['state'] == 0 and st['rp'] == 1):
        return None
    if cand in (CAND['exit_a'], CAND['exit_b']):
        return None
    if cand == CAND['rotate']:
        top = list_top(ctx, O_LIST2, O_COUNT2)
        return None if top == -1 or valid_inst(ctx, top) else 'K3:rotate-list'
    drag, multi_hand, has_multi = st['drag'], st['multi_hand'], st['has_multi']
    if (not drag and cand == CAND['pick']) or (drag and multi_hand):
        if has_multi and not multi_hand:
            return None if valid_inst(ctx, list_top(ctx, O_LIST1, O_COUNT1)) else 'K3:pick-list'
        hand = st['hand']
        if not has_multi:
            hand = list_top(ctx, O_LIST1, O_COUNT1)
            if not valid_inst(ctx, hand):
                return 'K3:pick-list'
        if not valid_inst(ctx, hand):
            return 'K3:hand'
        if st['body'][B_TYPES + BT * inst_type(ctx, hand) + 0x50] != 0 and st['n'] >= 80:
            return 'K5:spawn'
        return None
    if cand == CAND['drop']:
        return None if valid_inst(ctx, st['hand']) else 'K3:hand'
    return None


def do_click(ctx, where, cand=None, spec=CLK):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    if cand is not None:
        x.w32(G_CAND, cand)
        ctx.cand = s32(cand)
    st = obj_state(ctx)
    row = st['row']
    ri = active_ri(ctx)
    rp = st['rp']
    acts = bool(st['active'] and not st['done'] and st['state'] == 0 and rp == 1)
    why = click_refusal(ctx, st, ctx.cand)
    if why:
        status, newp, log = nat.click(ri, rp, ctx.cand)
        if status != 6:
            raise Mismatch('%s %s expected EB_ERR_BOUNDS from the native click, got %d' % (where, why, status))
        stats['known_observed'][why + ':click'] += 1
        resync(ctx)
        return
    set_queues(ctx, spec)
    x.rowbase = BODY_BASE + BODY_STRIDE * ri
    x.run_op(0x47ff0e, [], OBJ)
    status, newp, log = nat.click(ri, rp, ctx.cand)
    if status != 0:
        raise Mismatch('%s native click status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    check_consumption(where, ctx)
    if row is not None:
        after = x.row_phase(row)
        if after != newp:
            raise Mismatch('%s click row phase: original %d native %d' % (where, after, newp))
        ctx.phase[row] = newp
    stats['clicks'] += 1
    stats['clicks_acting' if acts else 'clicks_ignored'] += 1
    stats['click_cand_%x' % (ctx.cand & 0xffff)] += 1
    compare_state(where, ctx)


def do_rotkey(ctx, where, spec=CLK):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    st = obj_state(ctx)
    ri = active_ri(ctx)
    rp = st['rp']
    body = st['body'] if st['body'] is not None else ctx.rows[0]['body']
    acts = bool(st['active'] and body[B_ROT] != 0 and body[B_LOCK] == 0 and not st['done'] and st['state'] == 0 and rp == 1
                and st['count1'] != 0)
    if acts:
        piece = st['hand'] if st['drag'] else list_top(ctx, O_LIST1, O_COUNT1)
        if not valid_inst(ctx, piece):
            status, log = nat.rotkey(ri, rp)
            if status != 6:
                raise Mismatch('%s K3 expected EB_ERR_BOUNDS from the native rotate key, got %d' % (where, status))
            stats['known_observed']['K3:rotkey'] += 1
            resync(ctx)
            return
    set_queues(ctx, spec)
    x.rowbase = BODY_BASE + BODY_STRIDE * ri
    x.run_op(0x47ef0f, [], OBJ)
    status, log = nat.rotkey(ri, rp)
    if status != 0:
        raise Mismatch('%s native rotate-key status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    check_consumption(where, ctx)
    stats['rotkeys'] += 1
    stats['rotkeys_acting' if acts else 'rotkeys_ignored'] += 1
    compare_state(where, ctx)


def do_render(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    row = obj_row(ctx)
    slot = x.rs16(OBJ + O_SLOT)
    if row is None or slot == -1 or not x.rs32(OBJ + O_ACTIVE):
        stats['render_skipped_unreachable'] += 1  # the entry is released: the engine never calls the callback
        return
    st = obj_state(ctx)
    why = None
    if not sane_instances(ctx) or (st['drag'] and not valid_inst(ctx, st['hand'])):
        why = 'K3:render'
    elif any(not 0 <= x.rs16(OBJ + O_PIECES + PIECE * c) < 0x4000 for c in range(max(0, min(st['n'], 80)))
             if not (st['drag'] and c == st['hand'])):
        # a drawn piece whose z is outside the render loop's levels 0..0x3fff: the original keeps counting levels (16-bit wrap),
        # native stops at 0x4000
        why = 'K5:render-guard'
    if why:
        nat.clear()
        status, plan = nat.plan(row)
        if status != 6:
            raise Mismatch('%s %s expected EB_ERR_BOUNDS from the native render, got %d' % (where, why, status))
        stats['known_observed'][why] += 1
        resync(ctx)
        return
    objimg = x.image()
    x.blits = []
    x.fx = []
    x.call(0x481cb9, [], 0)
    nat.clear()
    status, plan = nat.plan(row)
    log = nat.log()
    if status != 0:
        raise Mismatch('%s native plan status %d' % (where, status))
    stats['render_calls'] += 1
    bl = x.blits
    if not plan['valid'] or plan['count'] != len(bl):
        raise Mismatch('%s blit count original %d plan valid %d count %d' % (where, len(bl), plan['valid'], plan['count']))
    sk = {0: MARK_SAVED, 1: struct.unpack_from('<I', objimg, O_ANIM)[0], 2: struct.unpack_from('<I', objimg, O_SRC)[0],
          3: struct.unpack_from('<I', objimg, O_MULTI)[0]}
    for i, b in enumerate(bl):
        p = plan['blits'][i]
        stats['blit_calls'] += 1
        if b['kind'] != p['kind'] or b['src'] != p['src'] or b['dst'] != p['dst']:
            raise Mismatch('%s blit %d: original kind %d %s -> %s native kind %d %s -> %s' % (
                where, i, b['kind'], b['src'], b['dst'], p['kind'], p['src'], p['dst']))
        want = sk.get(p['src_kind'], p['surface'])
        if b['src_surface'] != want or (p['src_kind'] == 0 and p['surface'] != 0) or b['dst_surface'] != MARK_BACK:
            raise Mismatch('%s blit %d surfaces original %#x/%#x plan kind %d surface %#x' % (
                where, i, b['src_surface'], b['dst_surface'], p['src_kind'], p['surface']))
        stats['blit_src_kind_%d' % p['src_kind']] += 1
        stats['blit_tag:' + sha(b['tag'])[:8]] += 1
    compare_log(where, x.fx, log)
    compare_state(where, ctx)


def do_cleanup(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    x.fx = []
    x.run_op(0x47e2a5, [], OBJ)
    status, log = nat.simple(nat.lib.ebo_cleanup)
    if status != 0:
        raise Mismatch('%s native cleanup status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['cleanups'] += 1
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = x.rs16(OBJ + O_SLOT)
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        nat.lib.ebo_set_entry_u32(nat.h, slot, 0x14, 0)
    x.fx = []
    x.run_op(0x47e440, [], OBJ)
    status, log = nat.simple(nat.lib.ebo_invalidate)
    if status != 0:
        raise Mismatch('%s native invalidate status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['invalidates'] += 1
    compare_state(where, ctx)


def do_world_reset(ctx, where):
    """0x47e3f7 against eb_world_reset."""
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    x.run_op(0x47e3f7, [], OBJ)
    nat.lib.ebo_world_reset(nat.h)
    stats['world_resets'] += 1
    compare_state(where, ctx)


def do_poke(ctx, where, pokes):
    """Force object bytes on both sides (states the game cannot reach, but the code paths are the original's)."""
    img = bytearray(ctx.nat.obj())
    for off, data in pokes.items():
        ctx.x.wr(OBJ + off, data)
        img[off:off + len(data)] = data
    ctx.nat.set_obj(bytes(img))
    ctx.stats['pokes'] += 1
    compare_state(where, ctx)


def sync_events(ctx):
    ctx.nat.set_events(ctx.x.events_raw())


def set_view(ctx, v):
    ctx.view = v
    ctx.x.w32(G_ORIGIN_X, v[0])
    ctx.x.w32(G_ORIGIN_Y, v[1])
    for a, c in zip(G_CLIP, v[2:6]):
        ctx.x.w32(a, c)
    ctx.nat.set_view(v)


def set_texts(ctx, texts):
    ctx.x.texts = dict(texts)
    ctx.nat.set_texts(texts)


def set_captions(ctx, v):
    ctx.x.w32(G_CAPTIONS, v)
    ctx.nat.lib.ebo_set_captions(ctx.nat.h, v)


def set_scene(ctx, v):
    ctx.x.w32(CELLS[0][0], v)
    c = ctx.nat.cells()
    c[0] = v
    ctx.nat.set_cells(c)


GEOM_XS = (-1, 0, 8, 40, 100, 116, 120, 124, 160, 200, 300, 396, 416, 420, 440)
GEOM_YS = (-1, 0, 8, 40, 100, 116, 120, 124, 160, 200, 300, 306, 316, 320, 340)
GEOM_W = (0, 3, 4, 8, 16, 24, 36)


def do_layer(ctx, where, st):
    """Put piece i (a square, so that a quarter turn keeps its rectangle) and three others on touching / -1-edged rectangles, then rotate i:
    the rotation re-layers it against the others (0x47ea73 / 0x47ed96)."""
    rng = ctx.rng
    nn = min(st['n'], 80)
    if nn < 2:
        return
    for rep in range(3):
        if ctx.stop:
            return
        st = obj_state(ctx)
        if not st['active'] or st['rp'] != 1 or st['drag'] or st['n'] < 2:
            return
        i = rng.randrange(nn)
        s_ = rng.choice([4, 8, 16, 24])
        lft = rng.choice((-1 - s_, -1, -1 - s_ // 2, -1 - s_, 40, 100, 200))
        top = rng.choice((-1 - s_, -1, -1 - s_ // 2, -1 - s_, 40, 100, 200))
        pokes = {O_PIECES + PIECE * i + 2: struct.pack('<4i', lft, top, lft + s_, top + s_), O_PIECES + PIECE * i: struct.pack('<h', 3),
                 O_PIECES + PIECE * i + 0x24: bytes([0]), O_STATE: struct.pack('<i', 0), O_DONE: b'\0', O_MULTI_HAND: b'\0'}
        ctx.stats['layers'] += 1
        special = rng.random() < 0.4  # the right edge of piece i is -1 and a higher piece overlaps its left part
        if special:
            lft, top = -1 - s_, rng.choice((40, 100))
            pokes[O_PIECES + PIECE * i + 2] = struct.pack('<4i', lft, top, lft + s_, top + s_)
        others = []
        for j in rng.sample([k for k in range(nn) if k != i], min(3, nn - 1)):
            wj, hj = rng.choice([4, 8, 16]), rng.choice([4, 8, 16])
            if special:
                wj, hj = 16 + 8 * (j % 2), 16
            e1, e2 = rng.choice([-2, -1, 0, 0, 1, 2]), rng.choice([-2, -1, 0, 0, 1, 2])
            xl = rng.choice([lft + s_ + e1, lft - wj + e1, lft + e1, lft + s_ + e1 - 1])
            yt = rng.choice([top + s_ + e2, top - hj + e2, top + e2, top + s_ + e2 - 1, top - hj + e2])
            if special:
                xl, yt = lft + min(e1, 0), top + e2
            pokes[O_PIECES + PIECE * j + 2] = struct.pack('<4i', xl, yt, xl + wj, yt + hj)
            pokes[O_PIECES + PIECE * j] = struct.pack('<h', rng.choice([4, 5, 6, 8, 8, 3, 1]))
            others.append((xl, yt, xl + wj, yt + hj))
        # a point of piece i that no poked piece contains, so that the quarter turn goes to i and not to a higher piece under the pointer
        pts = [center((lft, top, lft + s_, top + s_)), (lft, top), (lft + s_, top), (lft, top + s_), (lft + s_, top + s_)]
        free = [q for q in pts if not any(o_[0] <= q[0] <= o_[2] and o_[1] <= q[1] <= o_[3] for o_ in others)]
        if not free:
            continue
        do_poke(ctx, where + ' layer', pokes)
        do_pointer(ctx, where + ' layer', *free[0])
        do_pointer(ctx, where + ' layer', *free[0])
        do_rotkey(ctx, where + ' layer')
        if obj_state(ctx)['drag']:
            do_click(ctx, where + ' layer drop', CAND['drop'])


def do_sweep(ctx, where, st):
    """Pointer moves at the exact edges of the thresholds around the other pieces (overlap / near-piece / area tests)."""
    rng = ctx.rng
    nn = min(st['n'], 80)
    hw, hh = hand_half(ctx, st)
    xs, ys = set(), set()
    for j in rng.sample(range(nn), min(nn, 4)):
        lft, top, rgt, bot = inst_rect(ctx, j)
        for d in (-2, -1, 0, 1, 2):
            xs |= {lft + 3 - hw + d, rgt - 3 + hw + d, lft + hw + d, lft - 0x14 + hw + d, rgt + 0x14 - hw + d, (lft + rgt) // 2 + d}
            ys |= {top + 3 - hh + d, bot - 3 + hh + d, top - 4 - hh + d, top + d, top - hh + d, (top + bot) // 2 + d}
    for ar_x in (ctx.view[2], ctx.view[4]):
        xs |= {ar_x + hw, ar_x - hw}
    xs, ys = sorted(xs), sorted(ys)
    mids_x, mids_y = [], []
    for j in range(nn):
        lft, top, rgt, bot = inst_rect(ctx, j)
        mids_x += [(lft + rgt) // 2 + d for d in (-1, 0, 1)]
        mids_y += [(top + bot) // 2 + d for d in (-1, 0, 1)]
    for _ in range(90):
        if ctx.stop:
            return
        which = rng.randrange(3)
        px = clamp16(rng.choice(mids_x if which == 1 else xs))
        py = clamp16(rng.choice(mids_y if which == 2 else ys))
        rect = (px - 4, py - 4, px + 4, py + 4)
        do_pointer(ctx, where + ' sweep', px, py, rect)
        do_pointer(ctx, where + ' sweep', px, py, rect)


def fuzz_pokes(ctx, geom=False):
    """Safe pokes: states the game cannot reach but whose code paths are the original's. They never create an instance
    index the native kernel refuses (those are the K scenarios)."""
    r = ctx.rng
    st = obj_state(ctx)
    n = max(st['n'], 0)
    p = {}
    cols = struct.unpack_from('<h', st['body'], B_GCOLS)[0] if st['body'] else 1
    if r.random() < 0.7:
        # the animation step divides by the column count: with zero columns state 4 (and 5 -> 4) is unreachable by the game
        p[O_STATE] = struct.pack('<i', r.choice([0, 1, 1, 3, 4, 5, 5, 6, 6, -1, 7, 0x100] if cols else [0, 1, 3, 6, -1, 7]))
    for off in (O_DEADLINE, O_DEADLINE2):
        if r.random() < 0.5:
            p[off] = struct.pack('<I', r.choice([0, 1, 100, 0x7fffffff, 0x80000000, 0xffffffff, ctx.clock, (ctx.clock + 300) & 0xffffffff,
                                                 r.randrange(1 << 32)]))
    for off in (O_ANIM_ON, O_ANIM_REST, O_DONE, O_EXIT):
        if r.random() < 0.25:
            p[off] = bytes([r.choice([0, 1])])
    if r.random() < 0.15 and cols:
        p[O_HAS_ANIM] = bytes([r.choice([0, 1])])
    if r.random() < 0.4:
        p[O_ANIM_ROW] = struct.pack('<h', r.choice([0, 1, 2, 3, 5, 7, -1, 32767]))
    if r.random() < 0.4:
        p[O_ANIM_FRAME] = struct.pack('<h', r.choice([0, 1, 2, 3, 4, 5, 6, 7, 11, 12, -1, 32767]))
    if r.random() < 0.3:
        p[O_CELL_W] = struct.pack('<h', r.choice([0, 1, 20, 61, -3]))
    if r.random() < 0.3:
        p[O_TOTAL] = struct.pack('<h', r.randrange(-3, 40))
    for t in range(20):
        if r.random() < 0.05:
            p[O_COUNTS + t] = bytes([r.choice([0, 1, 2, 3, 255])])
    for i in range(min(n, 80)):
        base = O_PIECES + PIECE * i
        if r.random() < 0.05:
            p[base + 0x24] = bytes([r.choice([0, 1])])
        if r.random() < 0.05:
            p[base + 0x22] = bytes([r.choice([0, 1, 2, 3])])
        if r.random() < 0.05:
            p[base] = struct.pack('<h', r.choice([0, 1, 2, 3, 7, 100, -2]))
        if geom and r.random() < 0.3:
            # rectangles on a coarse grid (touching edges, an edge of -1): the overlap, layer and near-piece tests
            lft, top = r.choice(GEOM_XS), r.choice(GEOM_YS)
            wid, hei = r.choice(GEOM_W), r.choice(GEOM_W)
            right = -1 if r.random() < 0.08 else lft + wid
            p[base + 2] = struct.pack('<4i', lft, top, right, top + hei)
    if geom:
        for t in range(20):
            if r.random() < 0.3:
                p[O_COUNTS + t] = bytes([r.choice([0, 1, 1, 2])])
        if n < 78 and r.random() < 0.5:  # a stale stamp in the next free instance (a spawned piece is initialised over it)
            p[O_PIECES + PIECE * n + 0x24] = bytes([1])
    return p


def untilcheck(ctx, until):
    x = ctx.x
    row = obj_row(ctx)
    if until == 'idle':
        return row is not None and x.rs32(OBJ + O_STATE) == 0 and x.rs32(OBJ + O_ACTIVE) != 0 and ctx.phase.get(row, 0) == 1
    if until == 'inactive':
        return x.rs32(OBJ + O_ACTIVE) == 0
    if until == 'done':
        return all(ctx.complete.get(r, 0) for r in range(ctx.first, ctx.first + len(ctx.rows)))
    if until == 'phase2':
        return row is not None and ctx.phase.get(row, 0) == 2
    if until == 'phase1':
        return row is not None and ctx.phase.get(row, 0) == 1
    if until.startswith('state'):
        return x.rs32(OBJ + O_STATE) == int(until[5:])
    return False


# ---------------------------------------------------------------------------------------------
# the player: picks operations from the original's own state (the oracle never reads the native object to decide)
# ---------------------------------------------------------------------------------------------
def center(r):
    return clamp16((r[0] + r[2]) // 2), clamp16((r[1] + r[3]) // 2)


def pickable(ctx, st, j):
    t = inst_type(ctx, j)
    if t >= 20:
        return False
    spawn = st['body'][B_TYPES + BT * t + 0x50]
    return inst_flags(ctx, j)[1] == 0 or spawn == 0


def hand_half(ctx, st):
    if not valid_inst(ctx, st['hand']):
        return 10, 10
    r = inst_rect(ctx, st['hand'])
    return max(0, (r[2] - r[0]) // 2), max(0, (r[3] - r[1]) // 2)


def good_point(info, hw, hh, rng):
    l, t, r, b = info['area']
    xs = (l + hw + 1, r - hw - 1)
    ys = (t + hh + 1, b - hh - 1)
    x = rng.randrange(xs[0], xs[1] + 1) if xs[0] <= xs[1] else (l + r) // 2
    y = rng.randrange(ys[0], ys[1] + 1) if ys[0] <= ys[1] else (t + b) // 2
    return clamp16(x), clamp16(y)


def bad_point(info, hw, hh, rng):
    l, t, r, b = info['area']
    k = rng.randrange(6)
    if k == 0:
        return clamp16(l + hw - rng.randrange(0, 3)), clamp16((t + b) // 2)
    if k == 1:
        return clamp16(r - hw + rng.randrange(0, 3)), clamp16((t + b) // 2)
    if k == 2:
        return clamp16((l + r) // 2), clamp16(t + hh - rng.randrange(0, 3))
    if k == 3:
        return clamp16((l + r) // 2), clamp16(b - hh + rng.randrange(0, 3))
    if k == 4:
        return clamp16(l - 60 - hw), clamp16(t - 60 - hh)
    return clamp16(rng.randrange(-30, 700)), clamp16(rng.randrange(-30, 520))


LATE = {'ticks': 'clock', 'steps': (2500, 900, 2500)}


def settle(ctx, w, tries=4):
    for _ in range(tries):
        if ctx.x.rs32(OBJ + O_STATE) == 0 or ctx.stop:
            return
        do_tick(ctx, w + ' settle', LATE if ctx.rng.random() < 0.8 else {'ticks': 'dl'})


def cycle(ctx, w, info, st, good):
    """A whole interaction: pick a piece, wait out the sound, drop it (well or badly), wait out the feedback."""
    rng = ctx.rng
    loose = [j for j in range(min(st['n'], 80)) if pickable(ctx, st, j)]
    if not loose:
        return
    i = rng.choice(loose)
    cx, cy = center(inst_rect(ctx, i))
    do_pointer(ctx, w + ' pick', cx, cy)
    do_click(ctx, w + ' pick', None)
    settle(ctx, w)
    st = obj_state(ctx)
    if not (st['active'] and st['drag'] and valid_inst(ctx, st['hand'])):
        return
    hw, hh = hand_half(ctx, st)
    px, py = good_point(info, hw, hh, rng) if good else bad_point(info, hw, hh, rng)
    rect = (px - 4, py - 4, px + 4, py + 4)
    do_pointer(ctx, w + ' drop', px, py, rect)
    do_pointer(ctx, w + ' drop', px, py, rect)
    do_click(ctx, w + ' drop', None)
    settle(ctx, w + ' feedback', 6)


def play(ctx, where, n, policy):
    x, rng = ctx.x, ctx.rng
    solve = policy.get('solve', 0.5)
    for step in range(n):
        if ctx.stop:
            return
        st = obj_state(ctx)
        w = '%s play %d' % (where, step)
        if not st['active'] or st['row'] is None or st['rp'] != 1:
            do_tick(ctx, w, policy.get('tick', CLK))
            continue
        body = st['body']
        info = parse(body)
        nn = st['n']
        if not st['drag'] and st['state'] == 0 and nn and rng.random() < policy.get('cycle', 0.25):
            cycle(ctx, w, info, st, rng.random() < solve)
            continue
        roll = rng.random()
        if roll < 0.18:
            do_tick(ctx, w, rng.choice([CLK, {'ticks': 'dl'}, {'ticks': 'dl', 'busy': 'zero'}, {'ticks': 'dl', 'busy': 'one'},
                                        {'ticks': 'clock', 'steps': (900, 2500)}]))
        elif roll < 0.23:
            do_render(ctx, w)
        elif roll < 0.25:
            do_invalidate(ctx, w)
        elif roll < 0.26:
            set_captions(ctx, rng.choice([0, 1, 1, 7]))
        elif roll < 0.27:
            set_view(ctx, VIEWS[rng.choice(list(VIEWS))])
            ctx.stats['view_changes'] += 1
        elif st['drag']:
            if not valid_inst(ctx, st['hand']):
                do_tick(ctx, w, CLK)
                continue
            hw, hh = hand_half(ctx, st)
            if policy.get('sweep') and rng.random() < policy['sweep']:
                do_sweep(ctx, w, st)
                continue
            if roll < 0.40 and rng.random() < 0.7:
                do_rotkey(ctx, w)
            elif roll < 0.85:
                if rng.random() < 0.2:
                    # probe the clamp: the moving rectangle at, inside and outside the clip edges
                    cl, ct, cr, cb = ctx.view[2:6]
                    side = rng.randrange(4)
                    dd = rng.choice([-2, -1, 0, 1, 2])
                    px, py = (cl + dd + hw, (ct + cb) // 2) if side == 0 else (cr + dd - hw, (ct + cb) // 2) if side == 1 else \
                        ((cl + cr) // 2, ct + dd + hh) if side == 2 else ((cl + cr) // 2, cb + dd - hh)
                    px, py = clamp16(px), clamp16(py)
                elif rng.random() < solve:
                    px, py = good_point(info, hw, hh, rng)
                else:
                    px, py = bad_point(info, hw, hh, rng)
                rect = (px - 4, py - 4, px + 4, py + 4) if rng.random() < 0.8 else \
                    (px - rng.randrange(0, 9), py - rng.randrange(0, 9), px + rng.randrange(0, 9), py + rng.randrange(0, 9))
                do_pointer(ctx, w, px, py, rect)
                if rng.random() < 0.7:
                    do_pointer(ctx, w, px, py, rect)
                do_click(ctx, w, None if rng.random() < 0.85 else rng.choice(CANDS + (-1, 5, 0)))
            else:
                do_pointer(ctx, w, rng.randrange(-20, 700), rng.randrange(-20, 500))
                do_click(ctx, w, None if rng.random() < 0.7 else rng.choice(CANDS + (-1, 0)))
        else:
            if policy.get('layer') and rng.random() < policy['layer']:
                do_layer(ctx, w, st)
                continue
            kind = rng.choice(['pick', 'pick', 'pick', 'zone', 'zone', 'exit', 'out', 'rotkey', 'tickclick'])
            if kind == 'exit' and rng.random() < policy.get('exit', 0.15):
                ex = info['btn_a'] if rng.random() < 0.6 else info['btn_b']
                do_pointer(ctx, w + ' exit', *center(ex))
                do_click(ctx, w + ' exit')
            elif kind == 'rotkey' or nn == 0:
                if nn and rng.random() < 0.7:
                    j = rng.randrange(min(nn, 80))
                    do_pointer(ctx, w + ' rk', *center(inst_rect(ctx, j)))
                do_rotkey(ctx, w)
            elif kind == 'zone':
                j = rng.randrange(min(nn, 80))
                l, t, _r, _b = inst_rect(ctx, j)
                zh, zw = info['zone']
                do_pointer(ctx, w + ' zone', clamp16(l + rng.choice([0, 1, zw, zw + 1, -1, zw // 2])),
                           clamp16(t + rng.choice([0, 1, zh, zh + 1, -1, zh // 2])))
                do_click(ctx, w + ' zone', None if rng.random() < 0.85 else rng.choice(CANDS))
            elif kind == 'pick':
                loose = [j for j in range(min(nn, 80)) if pickable(ctx, st, j)] or list(range(min(nn, 80)))
                j = rng.choice(loose)
                r = inst_rect(ctx, j)
                cx, cy = center(r)
                if rng.random() < 0.15:
                    cx, cy = clamp16(r[0] + rng.choice([-1, 0])), clamp16(r[1] + rng.choice([-1, 0]))
                do_pointer(ctx, w + ' pick', cx, cy)
                do_click(ctx, w + ' pick', None if rng.random() < 0.9 else rng.choice(CANDS + (-1,)))
            else:
                do_pointer(ctx, w, rng.randrange(-10, 640), rng.randrange(-10, 480))
                do_click(ctx, w, None if rng.random() < 0.5 else rng.choice(CANDS))
        if rng.random() < policy.get('fuzz', 0.0):
            do_poke(ctx, w + ' fuzz', fuzz_pokes(ctx, bool(policy.get('geom'))))


def macro_solve(ctx, where, policy):
    """Pick every pickable piece once and drop it inside the area (a well-behaved player)."""
    rng = ctx.rng
    for k in range(policy.get('rounds', 12)):
        if ctx.stop:
            return
        st = obj_state(ctx)
        if not st['active'] or st['rp'] != 1 or st['done']:
            do_tick(ctx, where, LATE)
            continue
        if st['state'] != 0:
            do_tick(ctx, where + ' wait', LATE)
            continue
        info = parse(st['body'])
        cycle(ctx, '%s solve %d' % (where, k), info, st, rng.random() < policy.get('solve', 0.95))


def run_scenario(x, lib, sc, stats):
    t0 = time.monotonic()
    before = (stats['steps'], stats['host_calls'], stats['ticks'])
    try:
        run_scenario_inner(x, lib, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['steps'] += stats['steps'] - before[0]
        g['host_calls'] += stats['host_calls'] - before[1]
        g['ticks'] += stats['ticks'] - before[2]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, lib, sc, stats):
    x.hard_reset()
    x.expect_fatal = sc.get('expect_fatal')
    x.handles = list(sc.get('handles', [0x7001, 0x7002, 0x7003, 0x7004]))
    ctx = make_ctx(x, lib, sc, stats)
    nat = ctx.nat
    try:
        x.install_rows(ctx.rows, ctx.first)
        for r in range(ctx.first):
            ctx.complete[r] = 1
        for k, spec in enumerate(ctx.rows):
            nat.set_body(ctx.first + k, spec['body'])
        x.wr(G_MODE, struct.pack('<i', sc.get('mode', 3)))
        for idx, v in sc.get('events', {}).items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
        # seeds: the cells and the flag start non-zero so a skipped store cannot hide
        seeds = [sc.get('scene', 0x11111111), 0x2222, -0x3333, 0x4444, 0x55555555, 0x66666666 & 0x7fffffff, 0x77777777]
        for (a, sz), v in zip(CELLS, seeds):
            x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
        nat.set_cells(x.cells())
        x.w32(START_FLAG, 5)
        nat.lib.ebo_set_world_flag(nat.h, 5)
        x.w32(G_CAND, 0)
        x.w32(G_CURSOR, 0x77)
        x.w32(G_CURSOR2, 0x88)
        nat.set_handles(x.handles)
        set_view(ctx, VIEWS[sc.get('view', 'v0')])
        set_captions(ctx, sc.get('captions', 1))
        set_texts(ctx, sc.get('texts', {}))
        for s in sc.get('busy_slots', []):
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            nat.lib.ebo_set_busy_slot(nat.h, s, 1)
        nat.set_entries(x.entries())  # the engine's static table contents; the oracle compares what the handler changes
        # the power-on resets: the originals 0x47e25a / 0x47e3f7 against eb_object_reset / eb_world_reset
        oi, ni = x.image(), nat.obj()
        if oi[0x1c:] != ni[0x1c:]:
            k = first_diff(oi[0x1c:], ni[0x1c:]) + 0x1c
            raise Mismatch('power-on reset differs at %s (+%#x): original %02x native %02x' % (field_of(k), k, oi[k], ni[k]))
        nat.set_obj(oi)  # the unnamed leading bytes are the loader's
        sv, ns = x.saved(), nat.world()
        if sv != ns:
            k = first_diff(sv, ns)
            raise Mismatch('saved-state power-on reset differs at %s: original %02x native %02x' % (saved_field(k), sv[k], ns[k]))
        compare_state('initial', ctx)
        for ai, act in enumerate(sc['actions']):
            where = '%s action %d %s' % (sc['id'], ai, act[0])
            kind = act[0]
            if kind == 'view':
                set_view(ctx, VIEWS[act[1]] if isinstance(act[1], str) else act[1])
            elif kind == 'clock':
                ctx.clock = CLOCKS[act[1]] if isinstance(act[1], str) else act[1]
            elif kind == 'scene':
                set_scene(ctx, act[1])
            elif kind == 'setphase':
                x.w32(ROWS + act[1] * ROW + PHASE_OFF, act[2])
                ctx.phase[act[1]] = act[2]
            elif kind == 'mode':
                x.wr(G_MODE, struct.pack('<i', act[1]))
                c = nat.cells()
                c[7] = act[1]
                nat.set_cells(c)
            elif kind == 'flag':
                x.w32(START_FLAG, act[1])
                nat.lib.ebo_set_world_flag(nat.h, act[1])
            elif kind == 'captions':
                set_captions(ctx, act[1])
            elif kind == 'texts':
                set_texts(ctx, act[1])
            elif kind == 'events':
                for idx, v in act[1].items():
                    x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                sync_events(ctx)
            elif kind == 'rows':
                ctx.rows, ctx.first = list(act[1]), act[2]
                x.install_rows(ctx.rows, ctx.first)
                for k, spec in enumerate(ctx.rows):
                    nat.set_body(ctx.first + k, spec['body'])
                ctx.phase, ctx.complete = {}, {}
                for r in range(ctx.first):
                    ctx.complete[r] = 1
                sync_events(ctx)
            elif kind in ('poke', 'fuzz'):
                do_poke(ctx, where, act[1] if kind == 'poke' else fuzz_pokes(ctx))
            elif kind == 'ptr':
                do_pointer(ctx, where, *act[1:])
            elif kind == 'click':
                do_click(ctx, where, *act[1:])
            elif kind == 'rotkey':
                do_rotkey(ctx, where)
            elif kind == 'invalidate':
                do_invalidate(ctx, where)
            elif kind == 'slotinv':
                # invalidate with an active object without a slot, and with a slot but inactive (states the game does not reach)
                slot, act_ = x.rs16(OBJ + O_SLOT), x.rs32(OBJ + O_ACTIVE)
                do_poke(ctx, where, {O_SLOT: struct.pack('<h', -1)})
                do_invalidate(ctx, where + ' noslot')
                do_poke(ctx, where, {O_SLOT: struct.pack('<h', slot), O_ACTIVE: struct.pack('<i', 0)})
                do_invalidate(ctx, where + ' inactive')
                do_poke(ctx, where, {O_ACTIVE: struct.pack('<i', act_)})
            elif kind == 'world_reset':
                do_world_reset(ctx, where)
            elif kind == 'cleanup':
                do_cleanup(ctx, where)
                if len(act) < 2:  # the scene teardown of the engine: the rows go away with the object
                    for r in range(ctx.first, ctx.first + len(ctx.rows)):
                        x.wr(ROWS + r * ROW + COMPLETE_OFF, b'\1')
                        ctx.complete[r] = 1
            elif kind == 'revive':  # the scene is entered again: every row starts over
                for r in range(ctx.first, ctx.first + len(ctx.rows)):
                    x.wr(ROWS + r * ROW + COMPLETE_OFF, b'\0')
                    x.w32(ROWS + r * ROW + PHASE_OFF, 0)
                    ctx.complete[r] = 0
                    ctx.phase[r] = 0
            elif kind == 'render':
                do_render(ctx, where)
            elif kind == 'tick':
                ctx.tickno += 1
                do_tick(ctx, where, act[1] if len(act) > 1 else CLK)
            elif kind == 'run':
                spec, until, mx = act[1], act[2], act[3]
                for _ in range(mx):
                    ctx.tickno += 1
                    do_tick(ctx, where, spec)
                    if ctx.stop or untilcheck(ctx, until):
                        break
            elif kind == 'play':
                play(ctx, where, act[1], act[2] if len(act) > 2 else {})
            elif kind == 'solve':
                macro_solve(ctx, where, act[1] if len(act) > 1 else {})
            elif kind in ('k1', 'k2', 'k3', 'k4', 'k5', 'k6'):
                act_known(ctx, where, kind, act[1:] if len(act) > 1 else ())
            else:
                raise OracleError('unknown action ' + kind)
            if ctx.stop:
                break
        if not ctx.skip_final:
            compare_state(sc['id'] + ' end', ctx)
        stats['scenarios'] += 1
    finally:
        nat.close()


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def S(scs, sid, rows, actions, group, **kw):
    sc = dict(id=sid, rows=rows, actions=actions, group=group, quick=kw.pop('quick', False), first=kw.pop('first', 0))
    sc.update(kw)
    scs.append(sc)
    return sc


def R(body, subtype=1, tail=b''):
    return dict(body=body, tail=tail, subtype=subtype)


def sweep_points(info, st_rects=(), rng=None, extra=0):
    pts = []
    rects = [info['btn_a'], info['btn_b'], info['area'], info['anim_area']] + list(st_rects)
    for p in info['types']:
        rects += [p['B'], p['C']]
    for r in rects:
        l, t, rr, b = r
        for p in ((l, t), (rr, b), (l - 1, t), (l, t - 1), (rr + 1, b), (rr, b + 1), ((l + rr) // 2, (t + b) // 2), (l, b), (rr, t)):
            pts.append((clamp16(p[0]), clamp16(p[1])))
    z = info['zone']
    for p in info['types']:
        l, t = p['B'][0], p['B'][1]
        pts += [(clamp16(l + z[1]), clamp16(t + z[0])), (clamp16(l + z[1] + 1), clamp16(t + z[0])), (clamp16(l + z[1]), clamp16(t + z[0] + 1)),
                (clamp16(l - 1), t)]
    pts += [(0, 0), (-1, -1), (32767, 32767), (-32768, -32768)]
    if rng is not None:
        pts += [(rng.randrange(-80, 700), rng.randrange(-80, 520)) for _ in range(extra)]
    return pts


def sat_events(tail, ok=True):
    ev = {}
    for r in range(len(tail) // 16):
        rec = struct.unpack_from('<8h', tail, 16 * r)
        ev[rec[1]] = rec[2] if ok else rec[2] + 1
    return ev


def txt(rng, n):
    return bytes(rng.randrange(0x61, 0x7b) for _ in range(n))


SOUND_NAMES = [b'NO SOUND', b'NO SOUND', b'SFX_A', b'SFX_B', b'S' * 32, b'NO SOUNDS', b'NO SOUND ', b'no sound']


def rand_block(rng, flags=True):
    return scene_block(rng.choice([9999, 9999, 4377, 1, 0, 2305, -1]), tuple(rng.randrange(-5, 99) for _ in range(3)),
                       tuple(rng.randrange(-1000, 1000) for _ in range(3)), rng.choice([0, 1, 2]),
                       rng.choice([-1, -1, 5, 100, 4095, 0, 1984]) if flags else -1, rng.randrange(256))


def rand_body(rng, n=None, **ov):
    n = rng.choice([0, 1, 2, 3, 4, 5, 5, 6, 8, 10, 20]) if n is None else n
    area = ov.pop('area', rng.choice([(0, 0, 639, 479), (0, 0, 639, 479), (20, 20, 600, 440), (100, 100, 400, 330)]))
    types = default_types(rng, max(0, min(n, 20)), area)
    for t in types:
        if rng.random() < 0.1:  # a piece whose target rectangle has another size than its home rectangle
            l, tp = t['C'][0] if t['C'][2] != t['C'][0] else t['B'][0], t['C'][1] if t['C'][3] != t['C'][1] else t['B'][1]
            w, h = rng.randrange(10, 80), rng.randrange(10, 80)
            t['C'] = (l, tp, l + w - 1, tp + h - 1)
    anim = rng.choice([b'NO_FILE', b'', b'ANIMSRC', b'ANIMSRC', b'NO_FILES'])
    kw = dict(n=n, area=area, board=area, types=types, persist=rng.choice([0, 0, 1]), target=rng.choice([0, 1, 2, n, n + 1, n + 3, 40]),
              winsnd=rng.choice([0, 0, 1]), rot=rng.choice([0, 1, 1]), lock=rng.choice([0, 0, 1, 1]),
              zone=(rng.choice([0, 6, 10, 20]), rng.choice([0, 8, 12, 30])), mode=rng.choice([0, 0, 0, 1, 2]), overlap=rng.choice([0, 1, 1]),
              multi=rng.choice([b'NO_FILE', b'', b'MULTISRC', b'MULTISRC']), anim_name=anim,
              anim_area=rng.choice([(0, 0, 0, 0), (560, 20, 619, 79), (560, 20, 619, 20), (300, 20, 361, 120)]),
              grid=(rng.randrange(1, 5), rng.randrange(1, 5) if anim not in (b'ANIMSRC', b'NO_FILES') else rng.randrange(1, 5),
                    rng.randrange(0, 40), rng.randrange(0, 4)))
    kw['sounds'] = {k: rng.choice(SOUND_NAMES) for k in SND}
    kw['chans'] = {k: rng.randrange(-2, 40) for k in SND}
    kw['keys'] = {k: rng.choice([b'', b'KEY_A', b'KEY_B', b'K' * 32]) for k in ('bad', 'win')}
    kw['texts'] = {k: rng.choice([b'', b'Good job', b'Nope', txt(rng, 60), txt(rng, 199)]) for k in ('bad', 'win')}
    kw['cursors'] = tuple(rng.randrange(0, 12) for _ in range(3))
    kw['win'] = rand_block(rng)
    kw['exit_'] = rand_block(rng)
    kw['btn_a'] = rng.choice([(560, 420, 620, 460), (0, 0, 40, 30), (300, 200, 301, 201), (0, 0, 0, 0)])
    kw['btn_b'] = rng.choice([(0, 0, 0, 0), (500, 380, 540, 410), (560, 420, 620, 460)])
    kw.update(ov)
    return make_body(rng, **kw)


def rand_texts(rng, body):
    """AUTOTEXT answers for a random subset of the body's keys."""
    out = {}
    for off in (B_KEY_BAD, B_KEY_WIN):
        key = cstr(body[off:off + 0x21])
        if key and rng.random() < 0.6:
            out[key] = rng.choice([b'', b'Auto text', txt(rng, 60), txt(rng, 150), txt(rng, 199)])
    return out


def good_body(rng, n=5, **ov):
    """A body the player can finish: names for every sound, an animation area and an exit button."""
    types = default_types(rng, n, ov.get('area', (0, 0, 639, 479)))
    for t in types:
        t['req'] = 0 if rng.random() < 0.8 else 1
        t['forb'] = 0
    kw = dict(n=n, types=types, target=rng.choice([1, 2, n - 1 if n > 1 else 1]), req_ok=True,
              sounds={'pick': b'SFX_P', 'good': b'SFX_G', 'bad': b'SFX_B', 'win': b'SFX_W', 'rot': b'SFX_R'},
              keys={'bad': b'KEY_B0', 'win': b'KEY_W'}, texts={'bad': b'Wrong', 'win': b'You win'},
              anim_name=b'ANIMSRC', anim_area=(560, 20, 619, 79), btn_a=(560, 420, 620, 460), btn_b=(500, 380, 540, 410),
              mode=0, overlap=rng.choice([0, 1]), rot=rng.choice([0, 1]), lock=rng.choice([0, 1]), winsnd=rng.choice([0, 1]))
    kw.pop('req_ok')
    kw.update(ov)
    return rand_body(rng, **kw)


# dependency tails in the real records' shape (opcode 15: another row's state, opcode 2: an event flag)
TAIL_SEQ = struct.pack('<8h', 15, 0, 2, 0, 0, 0, 0, 0) + struct.pack('<8h', 2, 1429, 0, 0, 0, 0, 0, 0)
TAIL_EV = struct.pack('<8h', 2, 1984, 1, 0, 0, 0, 0, 0)


def scenario_list(seed=56):
    scs = []
    CL = corpus_rows()
    # -- the 2 corpus bodies -----------------------------------------------------------------------------------
    for k, row in enumerate(CL):
        info = parse(row['body'])
        ev = sat_events(row['tail'])
        acts = [('scene', row['resource']), ('tick', CLK), ('render',), ('invalidate',)]
        acts += [('ptr',) + p for p in sweep_points(info, (), random.Random(k), 20)]
        acts += [('play', 220, dict(solve=0.8)), ('run', {'ticks': 'dl'}, 'done', 30)]
        S(scs, 'corpus:%d' % k, [R(row['body'], row['subtype'], row['tail'])], acts, 'corpus', quick=(k == 0), seed=100 + k, events=ev,
          view=['v0', 'v1'][k], texts=rand_texts(random.Random(k), row['body']))
        S(scs, 'corpus:%d:play2' % k, [R(row['body'], row['subtype'], row['tail'])],
          [('scene', row['resource']), ('tick', CLK), ('play', 260, dict(solve=0.95, exit=0.05)), ('run', {'ticks': 'dl'}, 'done', 40)],
          'corpus', seed=200 + k, events=ev, captions=[1, 0][k])
        S(scs, 'corpus:%d:solve' % k, [R(row['body'], row['subtype'], row['tail'])],
          [('scene', row['resource']), ('tick', CLK), ('solve', dict(rounds=30)), ('run', LATE, 'done', 60),
           ('cleanup', 'keep'), ('revive',), ('tick', CLK), ('play', 80, dict(solve=0.9)), ('run', LATE, 'done', 60)],
          'corpus', seed=300 + k, events=ev)
    scenario_groups(scs, random.Random(seed))
    return scs


def tcenter(body, i, key='B'):
    return center(parse(body)['types'][i][key])


def pick_acts(body, i=0):
    return [('ptr',) + tcenter(body, i), ('click', None)]


def drop_acts(body, good=True, hw=30, at=None):
    a = parse(body)['area']
    x, y = at if at else (((a[0] + a[2]) // 2, (a[1] + a[3]) // 2) if good else (a[0] - 90, a[1] - 90))
    r = (x - 4, y - 4, x + 4, y + 4)
    return [('ptr', x, y, r), ('ptr', x, y, r), ('click', None)]


SYN_SOUNDS = {'pick': b'SFX_P', 'good': b'SFX_G', 'bad': b'SFX_B', 'win': b'SFX_W', 'rot': b'SFX_R'}
EXIT_A = lambda body: [('ptr',) + center(parse(body)['btn_a']), ('click', None)]


def spawn_types(types, flag=1):
    return [dict(t, spawn=flag) for t in types]


def scenario_groups(scs, rng):
    q = lambda *a: a  # quick marker helper for readability
    # -- phase 0 matrix: type counts, spawn flag, persist byte, rotation, source/animation names, sounds -------------------
    multis = [b'NO_FILE', b'', b'MULTISRC']
    anims = [b'NO_FILE', b'', b'ANIMSRC']
    for n in (0, 1, 2, 5, 20):
        for spawn in (0, 1):
            for persist in (0, 1):
                for rot, lock in ((0, 0), (1, 0), (1, 1)):
                    idx = len(scs)
                    types = spawn_types(default_types(rng, n, (0, 0, 639, 479)), spawn)
                    sounds = ({k: NO_SOUND for k in SND}, SYN_SOUNDS, dict(SYN_SOUNDS, good=NO_SOUND, rot=NO_SOUND))[idx % 3]
                    body = make_body(rng, n=n, types=types, persist=persist, rot=rot, lock=lock, multi=multis[idx % 3],
                                     anim_name=anims[(idx // 3) % 3], grid=(2, 3, 4, 1), anim_area=(560, 20, 619, 79),
                                     sounds=sounds, target=rng.choice([0, 1, n]), btn_a=(560, 420, 620, 460))
                    acts = [('scene', 700 + n), ('tick', CLK), ('render',), ('invalidate',), ('tick', CLK), ('tick', {'ticks': 'dl'}),
                            ('render',), ('cleanup', 'keep'), ('render',)]
                    if persist:
                        acts += [('revive',), ('tick', CLK), ('render',), ('cleanup',)]
                    S(scs, 'phase0:n%d:sp%d:pe%d:r%d%d' % (n, spawn, persist, rot, lock), [R(body)], acts, 'phase0',
                      quick=(n == 5 and spawn == 0 and persist == 1 and rot == 1 and lock == 0), seed=idx)
    # -- type table geometry: rect C / E valid or zero, with and without the multi source ------------------------------------
    for cz in (0, 1):
        for ez in (0, 1):
            for multi in (b'NO_FILE', b'MULTISRC'):
                n = 4
                types = default_types(rng, n, (0, 0, 639, 479))
                for t in types:
                    if cz:
                        t['C'] = (0, 0, 0, 0)
                    if ez:
                        t['E'] = (0, 0, 0, 0)
                    else:
                        t['E'] = (t['E'][0] or 50, t['E'][1] or 60, t['E'][2] or 90, t['E'][3] or 100)
                body = good_body(rng, n=n, types=types, multi=multi, rot=1, lock=0, mode=0, persist=0)
                acts = [('tick', CLK)] + pick_acts(body, 0) + [('tick', LATE)] + drop_acts(body, False) + [('tick', LATE)] + \
                    pick_acts(body, 1) + [('tick', LATE), ('rotkey',), ('render',)] + drop_acts(body, True) + [('tick', LATE), ('render',)]
                acts += pick_acts(body, 2) + [('ptr', 100, 100), ('click', None), ('tick', LATE), ('render',)] + drop_acts(body, True) + \
                    [('play', 60, dict(solve=0.7))]
                S(scs, 'rects:c%d:e%d:%s' % (cz, ez, multi.decode()), [R(body)], acts, 'rects', seed=rng.randrange(1 << 20), quick=(cz == 0 and ez == 0 and multi == b'MULTISRC'))
    # -- modes 0 / 1 / 2 with the overlap byte --------------------------------------------------------------------------------
    for mode in (0, 1, 2):
        for overlap in (0, 1):
            for variant in range(2):
                body = good_body(rng, n=5 if variant == 0 else 3, mode=mode, overlap=overlap, persist=0, target=2, winsnd=variant)
                S(scs, 'modes:m%d:o%d:v%d' % (mode, overlap, variant), [R(body)],
                  [('tick', CLK), ('solve', dict(rounds=14, solve=0.9)), ('play', 120, dict(solve=0.7, cycle=0.4, exit=0.05)),
                   ('run', LATE, 'done', 30)], 'modes', seed=rng.randrange(1 << 20), quick=(mode == 1 and overlap == 1 and variant == 0))
    # -- rotation: allowed / locked (click zone) x spawn --------------------------------------------------------------------------
    for rot, lock in ((0, 0), (1, 0), (0, 1), (1, 1)):
        for spawn in (0, 1):
            types = spawn_types(default_types(rng, 4, (0, 0, 639, 479)), spawn)
            body = good_body(rng, n=4, types=types, rot=rot, lock=lock, zone=(14, 18), persist=0, sounds=SYN_SOUNDS)
            info = parse(body)
            acts = [('tick', CLK)]
            for i in range(3):
                l, t = info['types'][i]['B'][:2]
                acts += pick_acts(body, i) + [('tick', LATE)] + [('rotkey',), ('rotkey',), ('tick', LATE), ('rotkey',), ('render',)]
                acts += drop_acts(body, True, at=(200 + 60 * i, 200)) + [('tick', LATE), ('render',)]
                # the click zone of the placed piece and of a bin piece
                acts += [('ptr', 200 + 60 * i, 200), ('rotkey',)]
                zl, zt = 200 + 60 * i - 15, 200 - 15
                acts += [('ptr', clamp16(zl + 1), clamp16(zt + 1)), ('click', None), ('tick', LATE), ('rotkey',), ('click', CAND['drop']), ('tick', LATE)]
                acts += [('ptr', clamp16(l + 1), clamp16(t + 1)), ('click', None), ('tick', LATE), ('render',)]
            acts += [('play', 100, dict(solve=0.6, cycle=0.1))]
            S(scs, 'rotation:r%d:l%d:sp%d' % (rot, lock, spawn), [R(body)], acts, 'rotation', seed=rng.randrange(1 << 20),
              quick=(rot == 1 and lock == 1 and spawn == 0))
    # -- animation: grids 1..4, NO_FILE / empty names, animation area valid or zero ---------------------------------------------------
    for rows_ in (1, 2, 3, 4):
        for cols_ in (1, 2, 4):
            for name in (b'ANIMSRC', b'NO_FILE', b''):
                if rows_ == 3 and cols_ == 2:
                    continue
                body = good_body(rng, n=2, target=1, anim_name=name, grid=(rows_, cols_, rng.randrange(0, 8), rng.choice([1, 2, 3])),
                                 anim_area=rng.choice([(560, 20, 619, 79), (560, 20, 619, 20), (0, 0, 0, 0)]),
                                 sounds=rng.choice([SYN_SOUNDS, dict(SYN_SOUNDS, good=NO_SOUND)]), winsnd=rng.choice([0, 1]))
                S(scs, 'anim:g%dx%d:%s' % (rows_, cols_, name.decode() or 'empty'), [R(body)],
                  [('tick', CLK), ('solve', dict(rounds=6, solve=1.0)), ('render',), ('run', {'ticks': 'dl', 'busy': 'rand'}, 'done', 60)],
                  'anim', seed=rng.randrange(1 << 20), quick=(rows_ == 2 and cols_ == 2 and name == b'ANIMSRC'))
    # -- sounds: NO SOUND vs real in every record ----------------------------------------------------------------------------------
    for rec in SND:
        for real in (0, 1):
            sounds = {k: (b'SFX_' + k.encode()) for k in SND}
            for k in SND:
                if k == rec:
                    sounds[k] = b'SFX_' + k.encode() if real else NO_SOUND
            body = good_body(rng, n=3, target=1, sounds=sounds, winsnd=1, rot=1, lock=0, persist=0)
            S(scs, 'sounds:%s:%s' % (rec, 'real' if real else 'none'), [R(body)],
              [('tick', CLK), ('rotkey',)] + pick_acts(body, 0) + [('tick', LATE), ('rotkey',), ('tick', LATE)] + drop_acts(body, False) +
              [('tick', LATE), ('solve', dict(rounds=8, solve=1.0)), ('run', {'ticks': 'dl', 'busy': 'rand'}, 'done', 60)],
              'sounds', seed=rng.randrange(1 << 20), quick=(rec == 'good' and real == 1))
    # -- captions: enabled / disabled x AUTOTEXT found / not found / too long x body text ------------------------------------------
    for caps in (1, 0):
        for auto in ('found', 'none', 'empty', 'long', 'huge'):
            for text in (b'Wrong here', b''):
                body = good_body(rng, n=3, target=1, winsnd=1, keys={'bad': b'KEY_B0', 'win': b'KEY_W'},
                                 texts={'bad': text or b'', 'win': text or b''}, persist=0)
                tx = {'found': {b'KEY_B0': b'Auto bad text', b'KEY_W': b'Auto win text'}, 'none': {},
                      'empty': {b'KEY_B0': b'', b'KEY_W': b''},
                      'long': {b'KEY_B0': txt(rng, 40001), b'KEY_W': txt(rng, 40001)},
                      'huge': {b'KEY_B0': txt(rng, 199), b'KEY_W': txt(rng, 150)}}[auto]
                S(scs, 'captions:c%d:%s:%s' % (caps, auto, 'text' if text else 'notext'), [R(body)],
                  [('tick', CLK)] + pick_acts(body, 0) + [('tick', LATE)] + drop_acts(body, False) + [('tick', LATE)] +
                  [('solve', dict(rounds=8, solve=1.0)), ('run', {'ticks': 'dl', 'busy': 'zero'}, 'done', 60)],
                  'captions', seed=rng.randrange(1 << 20), captions=caps, texts=tx, quick=(caps == 1 and auto == 'found' and text == b'Wrong here'))
    # -- finish blocks: win / exit scene 9999 and others, flag index -1 and valid, win sound byte, targets, required / forbidden --
    blocks = [scene_block(), scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 1984, 1), scene_block(1, (-5, 99, 7), (-1000, 0, 7), 1, -1, 0),
              scene_block(2305, (0, 0, 0), (0, 0, 0), 2, 5, 255), scene_block(9999, (7, 7, 7), (7, 7, 7), 1, 4095, 3),
              scene_block(0, (1, 2, 3), (1, 2, 3), 1, 0, 0)]
    for wi, win in enumerate(blocks):
        for xi, ex in enumerate(blocks):
            if (wi + xi) % 2 and wi > 1:
                continue
            for winsnd in (0, 1):
                body = good_body(rng, n=3, target=1, winsnd=winsnd, win=win, exit_=ex, persist=0)
                body_acts = [('tick', CLK), ('solve', dict(rounds=6, solve=1.0)), ('run', {'ticks': 'dl', 'busy': 'rand'}, 'done', 60)]
                S(scs, 'finish:win%d:exit%d:s%d:win' % (wi, xi, winsnd), [R(body)], body_acts, 'finish', seed=rng.randrange(1 << 20),
                  quick=(wi == 1 and xi == 2 and winsnd == 1))
                # not solved: the exit button stops the puzzle (exit block), also after a bad drop and after a partial solution
                S(scs, 'finish:win%d:exit%d:s%d:exit' % (wi, xi, winsnd), [R(body)],
                  [('tick', CLK)] + pick_acts(body, 0) + [('tick', LATE)] + drop_acts(body, False) + [('tick', LATE)] + EXIT_A(body) +
                  [('run', LATE, 'done', 30)], 'finish', seed=rng.randrange(1 << 20))
                # solved, then the exit button before the state machine reaches the win sound
                S(scs, 'finish:win%d:exit%d:s%d:solved-exit' % (wi, xi, winsnd), [R(body)],
                  [('tick', CLK), ('solve', dict(rounds=3, solve=1.0))] + EXIT_A(body) + [('run', LATE, 'done', 40)], 'finish',
                  seed=rng.randrange(1 << 20))
    for variant in range(10):
        n = rng.choice([2, 3, 4, 5])
        types = default_types(rng, n, (0, 0, 639, 479))
        for t in types:
            t['req'] = rng.choice([0, 1, 1, 2, 3])
            t['forb'] = rng.choice([0, 0, 1])
            t['spawn'] = rng.choice([0, 0, 1])
        body = good_body(rng, n=n, types=types, target=rng.choice([0, 1, 2, 3]), winsnd=rng.choice([0, 1]), mode=rng.choice([0, 0, 2]),
                         persist=0)
        S(scs, 'reqforb:%d' % variant, [R(body)],
          [('tick', CLK), ('solve', dict(rounds=14, solve=1.0)), ('play', 100, dict(solve=0.9, cycle=0.4, exit=0.0)), ('solve', dict(rounds=8)),
           ('run', {'ticks': 'dl', 'busy': 'rand'}, 'done', 40)] + EXIT_A(body) + [('run', LATE, 'done', 30)], 'reqforb',
          seed=rng.randrange(1 << 20), quick=(variant == 0))
    # -- persistence across rows and scenes (the saved puzzle state 0x5a055d..) ------------------------------------------------------
    for variant in range(15):
        same_scene = variant % 3 != 2
        ex_scene = scene_block(9999) if same_scene else scene_block(5000, (1, 2, 3), (4, 5, 6), 0, -1, 0)
        n = 4
        types = default_types(rng, n, (0, 0, 639, 479))
        for t in types:
            t['spawn'] = 1 if variant % 2 else 0
            t['req'] = 0
        a = good_body(rng, n=n, types=types, persist=1, target=rng.choice([1, 3, 9]), exit_=ex_scene, win=ex_scene, winsnd=variant % 2,
                      **(dict(rot=1, lock=0) if variant >= 12 else {}))
        b2 = a if variant % 4 < 2 else good_body(rng, n=rng.choice([2, 3, 6]), persist=1, exit_=ex_scene, win=ex_scene)
        if variant >= 12:  # rotated pieces restored into a body that does not allow rotation
            b2 = good_body(rng, n=n, persist=1, exit_=ex_scene, win=ex_scene, rot=0, lock=0)
        acts = [('scene', 321), ('tick', CLK), ('solve', dict(rounds=4, solve=1.0))] + EXIT_A(a) + [('run', LATE, 'done', 20), ('cleanup', 'keep')]
        if variant % 3 == 1:
            acts += [('world_reset',)]
        acts += [('revive',), ('tick', CLK), ('render',), ('solve', dict(rounds=3, solve=1.0)), ('play', 60, dict(solve=0.8, cycle=0.5)),
                 ('cleanup', 'keep'), ('scene', 321 if same_scene else 322), ('revive',), ('tick', CLK), ('play', 40, dict(cycle=0.5)), ('invalidate',),
                 ('render',)]
        rows = [R(a), R(b2)] if variant % 4 >= 2 or variant >= 12 else [R(a)]
        if len(rows) == 2:
            # the second row is gated on an event flag that the test opens by hand once the first row's puzzle is over
            rows[1]['tail'] = TAIL_EV
            acts = [('scene', 321), ('tick', CLK)] + ([('poke', {O_PIECES + PIECE * 0 + 0x22: bytes([2])})] if variant >= 12 else []) + \
                   [('solve', dict(rounds=5, solve=1.0)), ('play', 60, dict(solve=0.7, cycle=0.1))] + EXIT_A(a) + [('run', LATE, 'inactive', 30),
                    ('events', {1984: 1}), ('scene', 321 if same_scene else 399), ('tick', CLK), ('tick', CLK), ('solve', dict(rounds=3)),
                    ('play', 60, dict(cycle=0.4)), ('cleanup', 'keep'), ('revive',), ('events', {1984: 0}), ('tick', CLK), ('events', {1984: 1}),
                    ('tick', CLK), ('play', 30, dict(cycle=0.3))]
        S(scs, 'persist:%d:%s' % (variant, 'same' if same_scene else 'other'), rows, acts, 'persist', seed=rng.randrange(1 << 20),
          quick=(variant == 4))
    # -- piece geometry: touching rectangles, -1 edges, pointer sweeps at the thresholds of the overlap and near-piece tests ------------------------
    for k in range(30):
        mode = (0, 0, 1, 1, 2, 0)[k % 6]
        n = rng.choice([4, 6, 8])
        types = spawn_types(default_types(rng, n, (0, 0, 639, 479)), 1 if k % 5 == 4 else 0)
        for t in types:  # rectangles with only one pair of equal edges (invalid for the original's 0x47e99e)
            for key in ('C', 'E'):
                if rng.random() < 0.4:
                    ll, tt, rr, bb = t[key] if t[key] != (0, 0, 0, 0) else t['A']
                    t[key] = (ll, tt, rr, tt) if rng.random() < 0.5 else (ll, tt, ll, bb)
        for t in types:  # narrow pieces (the hand rectangle narrower than the 3-pixel overlap margin)
            if rng.random() < 0.3:
                nw = rng.choice([1, 2])
                for key in 'ABC':
                    if t[key] != (0, 0, 0, 0):
                        t[key] = (t[key][0], t[key][1], t[key][0] + nw - 1, t[key][3])
        body = good_body(rng, n=n, types=types, mode=mode, overlap=1 if (k % 2 == 0 or mode == 0) else 0, rot=1, lock=0 if k % 4 else 1,
                         area=(120, 120, 420, 320), multi=b'MULTISRC' if k % 3 else b'NO_FILE', persist=0, sounds=SYN_SOUNDS, target=n + 3)
        S(scs, 'geom:%d:m%d' % (k, mode), [R(body)],
          ([('view', (0, 0, -60, -60, 640, 480))] if k % 2 == 0 else []) +
          [('tick', CLK), ('play', 260, dict(solve=0.5, cycle=0.45, fuzz=0.35, geom=True, sweep=0.35, layer=0.5, exit=0.0)), ('slotinv',)],
          'geom', seed=rng.randrange(1 << 20), quick=(k == 2))
    pb = good_body(rng, n=3, persist=1, target=9, rot=0, lock=0)
    S(scs, 'persist:total-poke', [R(pb)],
      [('scene', 43), ('tick', CLK), ('solve', dict(rounds=3, solve=1.0)), ('cleanup',), ('poke', {O_TOTAL: struct.pack('<h', 77)}), ('revive',),
       ('tick', CLK), ('render',), ('play', 30, dict(solve=0.8))], 'persist', seed=41)
    # -- timing: ticks before / after the deadlines, the 2^32 wrap, busy answers 0 / 1 ------------------------------------------------
    for ci, clock in enumerate(('low', 'mid', 'sign', 'wrap', 'top')):
        for busy in ('zero', 'one', 'rand'):
            body = good_body(rng, n=3, target=1, winsnd=1, sounds=SYN_SOUNDS, persist=0, anim_name=b'ANIMSRC', grid=(2, 2, 3, 2))
            S(scs, 'timing:%s:%s' % (clock, busy), [R(body)],
              [('clock', clock), ('tick', CLK)] + pick_acts(body, 0) + [('run', {'ticks': 'dl', 'busy': busy}, 'idle', 6)] +
              drop_acts(body, False) + [('run', {'ticks': 'dl', 'busy': busy}, 'idle', 6)] +
              [('solve', dict(rounds=5, solve=1.0)), ('run', {'ticks': 'dl', 'busy': busy}, 'done', 80)], 'timing',
              seed=rng.randrange(1 << 20), quick=(clock == 'wrap' and busy == 'rand'))
    # -- candidates 0x278d..0x2791 and stray values in idle / busy / finished states -----------------------------------------------------
    for sound in (0, 1):
        body = good_body(rng, n=4, target=1, winsnd=1, sounds=SYN_SOUNDS if sound else {}, persist=0, rot=1, lock=0)
        acts = [('tick', CLK)]
        for cand in CANDS + (0x278c, 0x2792, 0, -1):
            acts += [('ptr',) + tcenter(body, 0), ('click', cand), ('click', cand)]
        acts += pick_acts(body, 0)
        for cand in CANDS + (0x278c, 0x2792):
            acts += [('click', cand)]  # busy (state 1 with a real pick sound) or dragging
        acts += [('tick', LATE)] + drop_acts(body, True)
        for cand in CANDS:
            acts += [('click', cand)]
        acts += [('solve', dict(rounds=5, solve=1.0)), ('tick', LATE)]
        for cand in CANDS:
            acts += [('ptr',) + tcenter(body, 1), ('click', cand), ('rotkey',)]
        acts += [('run', {'ticks': 'dl'}, 'done', 40)]
        S(scs, 'candidates:s%d' % sound, [R(body)], acts, 'candidates', seed=rng.randrange(1 << 20), quick=(sound == 1))
    # -- pointer regions while idle and while dragging (inside / outside the area, around the rotate zone and the buttons) ------------------
    for variant in range(6):
        body = good_body(rng, n=4, target=2, persist=0, rot=variant % 2, lock=(variant // 2) % 2, mode=(0, 0, 1, 2, 0, 1)[variant],
                         area=rng.choice([(0, 0, 639, 479), (100, 100, 400, 330)]), zone=(12, 16), overlap=1)
        info = parse(body)
        acts = [('tick', CLK)] + [('ptr',) + p for p in sweep_points(info, (), rng, 30)] + pick_acts(body, 1) + [('tick', LATE)]
        acts += [('ptr',) + p for p in sweep_points(info, (), rng, 30)] + [('rotkey',), ('render',)]
        acts += drop_acts(body, True, at=(250, 250)) + [('tick', LATE)] + pick_acts(body, 2) + [('tick', LATE)]
        acts += [('ptr',) + p for p in sweep_points(info, (), rng, 20)]
        acts += [('ptr', 250, 250, (240, 240, 260, 260)), ('click', None), ('tick', LATE), ('render',)]
        S(scs, 'regions:%d' % variant, [R(body)], acts, 'regions', seed=rng.randrange(1 << 20), view=['v0', 'v1', 'neg', 'tight', 'big', 'edge'][variant],
          quick=(variant == 0))
    # -- two rows in one scene, a false gate, cleanup then re-init, the slot allocator's fatal path -------------------------------------------
    a = good_body(rng, n=3, target=1, winsnd=1, persist=1, win=scene_block(9999, flag=1984, value=1), exit_=scene_block(9999))
    b2 = good_body(rng, n=2, target=1, winsnd=0, persist=1, win=scene_block(9999), exit_=scene_block(9999))
    S(scs, 'rows:two:open', [R(a), R(b2, tail=TAIL_EV)],
      [('scene', 40), ('tick', CLK), ('solve', dict(rounds=5, solve=1.0)), ('run', LATE, 'done', 60), ('tick', CLK), ('tick', CLK), ('solve', dict(rounds=5)),
       ('run', LATE, 'done', 60)], 'rows', seed=7, quick=True)
    S(scs, 'rows:two:gate-false', [R(a), R(b2, tail=TAIL_EV)],
      [('tick', CLK), ('tick', CLK), ('play', 40, dict(solve=0.4, exit=0.0)), ('tick', CLK)] + EXIT_A(a) + [('run', LATE, 'done', 10), ('tick', CLK)],
      'rows', seed=8)
    S(scs, 'rows:two:both-open', [R(a), R(b2)],
      [('scene', 41), ('tick', CLK), ('tick', CLK), ('play', 60, dict(solve=0.8)), ('run', LATE, 'done', 30)], 'rows', seed=9)
    S(scs, 'rows:cleanup-reinit', [R(a)],
      [('scene', 42), ('tick', CLK), ('solve', dict(rounds=3)), ('cleanup',), ('render',), ('invalidate',), ('revive',), ('tick', CLK), ('render',),
       ('cleanup', 'keep'), ('cleanup', 'keep'), ('revive',), ('tick', CLK), ('play', 40, dict(solve=0.8))], 'rows', seed=10)
    S(scs, 'rows:alloc-fatal', [R(a)], [('tick', CLK)], 'rows', seed=11, busy_slots=list(range(0x18, 0x40)), expect_fatal=0x52139c)
    S(scs, 'rows:alloc-second-slot', [R(a)], [('tick', CLK), ('render',), ('invalidate',), ('play', 30, dict(solve=0.5))], 'rows', seed=12,
      busy_slots=[0x18, 0x19, 0x1a])
    # -- 80 instances: the state-0 test of the handler (count > 0x4f ends the puzzle without a block) --------------------------------------
    types = spawn_types(default_types(rng, 2, (0, 0, 639, 479)), 1)
    for t in types:
        t['req'] = 0
    body = good_body(rng, n=2, types=types, target=200, winsnd=0, persist=0, mode=0, overlap=0)
    S(scs, 'rows:spawn-grind', [R(body)],
      [('tick', CLK), ('play', 700, dict(solve=1.0, cycle=0.95, exit=0.0, tick=LATE)), ('run', LATE, 'done', 60)], 'rows', seed=13)
    S(scs, 'rows:count-80-poke', [R(body)],
      [('tick', CLK), ('flag', 0), ('poke', {O_COUNT: struct.pack('<h', 80)}), ('tick', CLK), ('tick', CLK), ('run', LATE, 'done', 10)], 'rows', seed=14)
    S(scs, 'rows:count-79-poke', [R(body)],
      [('tick', CLK), ('poke', {O_COUNT: struct.pack('<h', 79)}), ('tick', CLK), ('tick', CLK), ('slotinv',), ('run', LATE, 'done', 10)], 'rows', seed=40)
    # -- the two kinds of bodies not in the corpus: tiny / maximal --------------------------------------------------------------------------
    for n in (0, 1, 20):
        body = good_body(rng, n=n, target=n, winsnd=1, persist=0)
        S(scs, 'rows:size%d' % n, [R(body)],
          [('tick', CLK), ('solve', dict(rounds=22, solve=1.0)), ('play', 60, dict(solve=0.9, cycle=0.3, fuzz=0.05)), ('run', LATE, 'done', 40)], 'rows',
          seed=rng.randrange(1 << 20))
    # -- native-only refusals (K1..K6): the original is not run ---------------------------------------------------------------------------
    known = []
    base = good_body(rng, n=3, target=1, winsnd=1, persist=0, anim_name=b'ANIMSRC', grid=(2, 2, 3, 2), keys={'bad': b'KEY_B0', 'win': b'KEY_W'})

    def patched(off, data, *more):
        b = bytearray(base)
        b[off:off + len(data)] = data
        for o2, d2 in more:
            b[o2:o2 + len(d2)] = d2
        return bytes(b)
    t0 = B_TYPES
    b20 = bytearray(good_body(rng, n=20, target=1, winsnd=1, persist=0))  # every type valid, so that only the count (21) is wrong
    struct.pack_into('<h', b20, B_NTYPES, 21)
    b20[B_TYPES + BT * 20 + 0x10:B_TYPES + BT * 20 + 0x20] = rect_bytes((10, 10, 49, 49))
    b20[B_TYPES + BT * 20 + 0x20:B_TYPES + BT * 20 + 0x30] = rect_bytes((0, 0, 0, 0))
    base20 = bytes(b20)
    t20 = B_TYPES + BT * 20  # type 20 overlaps the first sound record: give it a valid piece rectangle so that only the count is wrong
    known += [('type count 21', patched(B_NTYPES, struct.pack('<h', 21))),
              ('type count 21, valid type 20', base20), ('type count -1', patched(B_NTYPES, struct.pack('<h', -1))),
              ('piece size 0', patched(t0 + 0x10, rect_bytes((10, 10, 9, 9)), (t0 + 0x20, rect_bytes((0, 0, 0, 0))))),
              ('piece too wide', patched(t0 + 0x10, rect_bytes((0, 0, 5000, 20)), (t0 + 0x20, rect_bytes((0, 0, 0, 0))))),
              ('piece too wide via C', patched(t0 + 0x20, rect_bytes((0, 0, 4096, 20)))),
              ('unterminated name', patched(B_NAME, b'A' * 0x21)), ('unterminated multi', patched(B_MULTI, b'B' * 0x21)),
              ('unterminated sound', patched(SND['pick'], b'C' * 0x21)), ('unterminated key', patched(B_KEY_BAD, b'D' * 0x21)),
              ('unterminated text', patched(B_TEXT_WIN, b'E' * 200)), ('unterminated anim name', patched(B_ANIM_NAME, b'F' * 0x21)),
              ('zero grid columns', base), ('short body', base[:2000]), ('long body', base + b'\0'),
              ('piece width 0 only', patched(t0 + 0x10, rect_bytes((10, 10, 9, 20)), (t0 + 0x20, rect_bytes((0, 0, 0, 0))))),
              ('unterminated rot sound', patched(SND['rot'], b'G' * 0x21)), ('unterminated good sound', patched(SND['good'], b'H' * 0x21)),
              ('unterminated bad sound', patched(SND['bad'], b'I' * 0x21)), ('unterminated win sound', patched(SND['win'], b'J' * 0x21)),
              ('unterminated win key', patched(B_KEY_WIN, b'K' * 0x21)), ('unterminated bad text', patched(B_TEXT_BAD, b'L' * 200))]
    # the zero-columns case needs an animation area: patch both
    zc = bytearray(base)
    zc[B_ANIM_AREA:B_ANIM_AREA + 16] = rect_bytes((10, 10, 50, 50))
    struct.pack_into('<h', zc, B_GCOLS, 0)
    known[[w for w, _b in known].index('zero grid columns')] = ('zero grid columns', bytes(zc))
    acts = [('tick', CLK)] + [('k1', w, b) for w, b in known]
    S(scs, 'known:K1', [R(base)], acts, 'known', seed=15, quick=True)
    S(scs, 'known:K2', [R(base)], [('k2',)], 'known', seed=16)
    k3 = good_body(rng, n=3, persist=0, rot=1, lock=0)
    S(scs, 'known:K3', [R(k3)], [('tick', CLK), ('k3',)], 'known', seed=17, quick=True)
    kb = good_body(rng, n=3, target=1, winsnd=1, persist=0, win=scene_block(9999, flag=5000, value=1), exit_=scene_block(9999, flag=5000, value=1))
    S(scs, 'known:K4', [R(kb)], [('tick', CLK), ('k4',)], 'known', seed=18)
    spawn1 = good_body(rng, n=3, types=spawn_types(default_types(rng, 3, (0, 0, 639, 479)), 1), persist=0)
    zero_cols = good_body(rng, n=3, anim_name=b'ANIMSRC', grid=(2, 0, 3, 2), anim_area=(0, 0, 0, 0))
    S(scs, 'known:K5:list', [R(spawn1)], [('tick', CLK), ('k5', 'list')], 'known', seed=19)
    S(scs, 'known:K5:spawn81', [R(spawn1)], [('tick', CLK), ('k5', 'spawn81')], 'known', seed=20)
    S(scs, 'known:K5:zero-cols', [R(zero_cols)], [('tick', CLK), ('k5', 'zero-cols')], 'known', seed=21)
    S(scs, 'known:K5:render-guard', [R(spawn1)], [('tick', CLK), ('k5', 'render-guard')], 'known', seed=22)
    k6 = good_body(rng, n=3, target=1, winsnd=1, persist=0, multi=b'NO_FILE', mode=0, sounds=SYN_SOUNDS, keys={'bad': b'KEY_B0', 'win': b'KEY_W'})
    S(scs, 'known:K6:bad', [R(k6)], [('tick', CLK)] + pick_acts(k6, 0) + [('tick', LATE)] + [('ptr', -100, -100), ('ptr', -100, -100), ('k6', 'bad', txt(rng, 260))],
      'known', seed=23)
    S(scs, 'known:K6:win', [R(k6)], [('tick', CLK), ('k6', 'win', txt(rng, 260))], 'known', seed=24)
    S(scs, 'known:K6:bad215', [R(k6)], [('tick', CLK)] + pick_acts(k6, 0) + [('tick', LATE)] + [('ptr', -100, -100), ('ptr', -100, -100), ('k6', 'bad', txt(rng, 215))],
      'known', seed=25)
    S(scs, 'known:K6:win215', [R(k6)], [('tick', CLK), ('k6', 'win', txt(rng, 215))], 'known', seed=26)
    # -- maximal-length names, keys and texts in an accepted body (the validator must not refuse a 32-character name) -------------------
    ml = good_body(rng, n=3, target=1, winsnd=1, persist=0, name=b'N' * 32, multi=b'M' * 32, anim_name=b'A' * 32, grid=(2, 2, 3, 2),
                   sounds={k_: (c * 32) for k_, c in zip(('pick', 'good', 'bad', 'win', 'rot'), (b'p', b'g', b'b', b'w', b'r'))},
                   keys={'bad': b'k' * 32, 'win': b'K' * 32}, texts={'bad': b't' * 199, 'win': b'T' * 199})
    S(scs, 'rows:maxlen', [R(ml)], [('tick', CLK), ('solve', dict(rounds=4, solve=1.0)), ('play', 60, dict(solve=0.6, cycle=0.3)), ('run', LATE, 'done', 40)],
      'rows', seed=27, quick=True)


# ---------------------------------------------------------------------------------------------
# native-only safety checks (expected differences): the original is NOT run for these
# ---------------------------------------------------------------------------------------------
def act_known(ctx, where, kind, args=()):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    ri = active_ri(ctx)
    if kind == 'k1':
        what, body = args[0], args[1]
        v = nat.lib.ebo_validate(cbuf(body), len(body))
        status, why, log = 2, 'validate only', []
        if len(body) == BODY_LEN:  # the driver's step always passes the full body size
            nat.set_body(7, body)
            status, why, log, res = nat.step(7, 0, 0)
        if status != 2 or v != 2 or log:
            raise Mismatch('%s K1 expected EB_ERR_BODY without effects, got step %d validate %d (%s) / %s' % (where, status, v, why, log))
        stats['known_observed']['K1:' + what] += 1
    elif kind == 'k2':
        nat.set_body(0, ctx.rows[0]['body'])
        for ph in (1, 2):
            st, why, log, res = nat.step(0, 0, ph)
            if st != 3 or log:
                raise Mismatch('%s K2 expected EB_ERR_UNSUPPORTED without effects, got %d (%s) / %s' % (where, st, why, log))
            stats['known_observed']['K2:phase%d' % ph] += 1
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k3':
        # a hand / list index outside the instances and an instance type outside 0..19: each entry point refuses
        do_poke(ctx, where, {O_DRAG: struct.pack('<i', 1), O_HAND: struct.pack('<h', -1), O_STATE: struct.pack('<i', 0),
                             O_DONE: b'\0', O_MULTI_HAND: b'\0', O_COUNT1: struct.pack('<h', 1), O_COUNT2: struct.pack('<h', 1)})
        ctx.phase[ri] = 1
        x.w32(ROWS + ri * ROW + PHASE_OFF, 1)
        do_pointer(ctx, where + ' ptr', 10, 10)
        do_click(ctx, where + ' drop', CAND['drop'])
        do_rotkey(ctx, where + ' rotkey')
        do_render(ctx, where + ' render')
        do_poke(ctx, where, {O_DRAG: struct.pack('<i', 0), O_HAND: struct.pack('<h', -1), O_COUNT1: struct.pack('<h', 0)})
        do_click(ctx, where + ' stale drop', CAND['drop'])
        do_click(ctx, where + ' stale pick', CAND['pick'])
        do_poke(ctx, where, {O_PIECES + 0x23: bytes([25]), O_COUNT: struct.pack('<h', max(1, ctx.x.rs16(OBJ + O_COUNT)))})
        do_pointer(ctx, where + ' ptr2', 10, 10)
        do_render(ctx, where + ' render2')
        for need in ('K3:hand:pointer', 'K3:render', 'K3:rotkey', 'K3:instances:pointer', 'K3:hand:click', 'K3:pick-list:click'):
            if stats['known_observed'][need] < 1:
                raise Mismatch('%s %s refusals not observed: %s' % (where, need, dict(stats['known_observed'])))
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k4':
        # the flag index of a finish block outside the host window: the exit button path and the good drop path
        do_poke(ctx, where, {O_STATE: struct.pack('<i', 0), O_DONE: b'\0', O_DRAG: struct.pack('<i', 0)})
        ctx.phase[ri] = 1
        x.w32(ROWS + ri * ROW + PHASE_OFF, 1)
        status, newp, log = nat.click(ri, 1, CAND['exit_a'])
        if status != 6:
            raise Mismatch('%s K4 expected EB_ERR_BOUNDS from the exit click, got %d' % (where, status))
        stats['known_observed']['K4:exit-flag'] += 1
        resync(ctx)
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k5':
        what = args[0]
        if what == 'list':
            # 22 unplaced pieces under one point: the original's 20-word list overruns, native refuses
            img = {O_COUNT: struct.pack('<h', 22)}
            for i in range(22):
                base = O_PIECES + PIECE * i
                img[base + 2] = struct.pack('<4i', 100, 100, 140, 140)
                img[base] = struct.pack('<h', 0)
                img[base + 0x22] = bytes([0, 0])
                img[base + 0x23] = bytes([0])
                img[base + 0x24] = bytes([0])
            do_poke(ctx, where, img)
            do_pointer(ctx, where + ' ptr', 120, 120)
        elif what == 'spawn81':
            img = {O_COUNT: struct.pack('<h', 80), O_DRAG: struct.pack('<i', 0), O_STATE: struct.pack('<i', 0),
                   O_COUNT1: struct.pack('<h', 1), O_LIST1: struct.pack('<h', 0), O_DONE: b'\0'}
            for i in range(80):
                base = O_PIECES + PIECE * i
                img[base + 0x23] = bytes([0])
                img[base + 0x24] = bytes([0])
            do_poke(ctx, where, img)
            ctx.phase[ri] = 1
            x.w32(ROWS + ri * ROW + PHASE_OFF, 1)
            do_click(ctx, where + ' pick', CAND['pick'])
        elif what == 'zero-cols':
            do_poke(ctx, where, {O_STATE: struct.pack('<i', 4), O_HAS_ANIM: b'\1', O_DEADLINE: struct.pack('<I', 0)})
            nat.set_queues([1 << 30] * 8, [0] * 8)
            st, why, log, res = nat.step(ri, ri, 1)
            if st != 6:
                raise Mismatch('%s K5 expected EB_ERR_BOUNDS for zero grid columns, got %d' % (where, st))
            stats['known_observed']['K5:zero-cols'] += 1
            resync(ctx)
        elif what == 'render-guard':
            do_poke(ctx, where, {O_PIECES: struct.pack('<h', 0x4000), O_COUNT: struct.pack('<h', 1), O_DRAG: struct.pack('<i', 0)})
            nat.clear()
            st, plan = nat.plan(ri)
            if st != 6:
                raise Mismatch('%s K5 expected EB_ERR_BOUNDS from the render loop guard, got %d' % (where, st))
            stats['known_observed']['K5:render-guard'] += 1
            resync(ctx)
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k6':
        which, text = args[0], args[1]
        if which == 'bad':
            nat.set_texts({b'KEY_B0': text})
            # the held piece is dropped outside the area: a bad drop with captions on
            st = obj_state(ctx)
            if not (st['drag'] and valid_inst(ctx, st['hand'])):
                raise OracleError('K6 needs a piece in hand')
            nat.set_queues([1 << 30] * 8, [0] * 8)
            status, newp, log = nat.click(ri, 1, CAND['drop'])
            if status != 6 or any(k == LOGKINDS['CAPTION'] for k, _, _ in norm_nat(log)):
                raise Mismatch('%s K6 expected EB_ERR_BOUNDS without a caption, got %d' % (where, status))
        else:
            do_poke(ctx, where, {O_STATE: struct.pack('<i', 6)})
            nat.set_texts({b'KEY_W': text})
            nat.set_queues([1 << 30] * 8, [0] * 8)
            status, why, log, res = nat.step(ri, ri, 1)
            if status != 6 or any(k == LOGKINDS['CAPTION'] for k, _, _ in norm_nat(log)):
                raise Mismatch('%s K6 expected EB_ERR_BOUNDS without a caption, got %d (%s)' % (where, status, why))
        stats['known_observed']['K6:' + which] += 1
        ctx.skip_final = True
        ctx.stop = True


# ---------------------------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------------------------
class Stats(dict):
    def __missing__(self, key):
        return 0


def new_stats():
    return Stats(scenarios=0, ticks=0, steps=0, host_calls=0, state_compares=0, object_bytes=0, saved_bytes=0, body_bytes=0,
                 entry_bytes=0, event_bytes=0, cells=0, pointer_moves=0, pointer_hits=0, cursor_words=0, clicks=0,
                 clicks_acting=0, clicks_ignored=0, rotkeys=0, rotkeys_acting=0, rotkeys_ignored=0, invalidates=0, cleanups=0,
                 render_calls=0, blit_calls=0, render_skipped_unreachable=0, phase0_steps=0, phase1_steps=0, phase2_steps=0,
                 phaseX_steps=0, completions=0, gate_closed_ticks=0, fatal_paths_matched=0, ticks_consumed=0, busy_consumed=0,
                 pokes=0, world_resets=0, mismatches=0, effect_kinds=Counter(), known_observed=Counter(), groups={})


def run_list(x, lib, scs, stats, fail_fast=False, first_only=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, lib, sc, stats)
        except (Mismatch, OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


def merge(a, b):
    out = dict(a)
    for k, v in b.items():
        if k not in out:
            out[k] = v
        elif isinstance(v, dict):
            out[k] = merge(out[k], v)
        elif isinstance(v, (int, float)):
            out[k] = out[k] + v
    return out


def to_plain(stats):
    return {k: (to_plain(v) if isinstance(v, dict) else v) for k, v in stats.items()}


def asm_extents():
    import re
    out = []
    for f in sorted((PROJECT / 'asm').glob('FUN_*.s')):
        with open(f) as fh:
            for line in fh:
                m = re.match(r'# extent:\s+0x([0-9a-f]+)-0x([0-9a-f]+)', line)
                if m:
                    out.append((int(m.group(1), 16), int(m.group(2), 16)))
                    break
    return sorted(out)


def discover_pins(x, blocks):
    import bisect
    ext = asm_extents()
    starts = [a for a, _ in ext]
    funcs = set()
    for a, _sz in blocks:
        i = bisect.bisect_right(starts, a) - 1
        if i >= 0 and ext[i][0] <= a < ext[i][1]:
            funcs.add(ext[i])
    out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs)]
    return 'PINS_TABLE = (\n' + ''.join(' (%#x, %#x,\n  %r),\n' % t for t in out) + ')'


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
    ap.add_argument('--random', type=int, default=160, help='random scenarios (fixed seed)')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    ap.add_argument('--mutation-run', action='store_true', help='internal: stop at the first mismatch and print FIRST <id> :: <message>')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-56.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list() + random_scenarios(args.random)
    if args.list:
        print(len(scs), dict(Counter(s['group'] for s in scs)))
        return 0
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    # fast paths first: a failing mutant is caught by the quick set before the long scenarios
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_eb.so', strict=not args.lenient_build)
        procs = []
        for k in range(args.workers):
            res = work / ('shard%d.json' % k)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--shard', '%d/%d' % (k, args.workers),
                   '--result', str(res), '--show', str(args.show), '--random', str(args.random)]
            for flag in ('--fail-fast', '--quick-only'):
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
            args.result.write_text(json.dumps(dict(slice='RT-56', status='pass' if not code and not merged['mismatches'] else 'fail',
                                                   original_sha256=EXE_HASH, stats=merged, scenarios_total=len(scs),
                                                   oracle_sha256=sha(Path(__file__).read_bytes()),
                                                   driver_source_sha256=sha((PROJECT / 'tests/action_family_eb_runtime_oracle_driver.c').read_bytes()),
                                                   source_sha256={n: sha((args.src / n).read_bytes()) for n in
                                                                  ('action_family_eb_runtime.c', 'action_family_eb_runtime.h')},
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    if args.shard:
        k, n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % n == k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_eb.so', strict=not args.lenient_build)
    lib = open_lib(lib_path)
    x = X86()
    stats = new_stats()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52a000)
    bad = run_list(x, lib, scs, stats, fail_fast=args.fail_fast or args.mutation_run)
    if args.mutation_run:
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    if args.discover_pins:
        print(discover_pins(x, blocks))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:600])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = to_plain(stats)
    summary['seconds'] = round(time.monotonic() - started, 1)
    summary['hooks_fired'] = dict(x.hooks_fired)
    summary['counters'] = dict(x.counters)
    if not args.shard:
        print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-56', original_sha256=EXE_HASH, stats=summary,
                                               native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                          indent=2, sort_keys=True, default=str) + '\n')
    return 1 if bad else 0


def random_scenarios(count, seed=5656):
    scs = []
    rng = random.Random(seed)
    for i in range(count):
        two = rng.random() < 0.2
        bodies = [rand_body(rng) for _ in range(2 if two else 1)]
        if rng.random() < 0.5:
            bodies = [good_body(rng, n=rng.choice([2, 3, 4, 5, 8])) for _ in bodies]
        rows = [R(b) for b in bodies]
        if two:
            rows[1]['tail'] = TAIL_SEQ
        policy = dict(solve=rng.choice([0.2, 0.5, 0.8, 1.0]), fuzz=rng.choice([0.0, 0.0, 0.03, 0.08]), exit=rng.choice([0.02, 0.1, 0.3]))
        acts = [('tick', CLK), ('play', rng.randrange(60, 150), policy)]
        if rng.random() < 0.3:
            acts += [('cleanup', 'keep'), ('revive',), ('tick', CLK), ('play', rng.randrange(20, 60), policy)]
        acts += [('run', {'ticks': 'dl'}, 'done', 12)]
        S(scs, 'random:%03d' % i, rows, acts, 'random', seed=rng.randrange(1 << 30), view=rng.choice(list(VIEWS)),
          captions=rng.choice([0, 1, 1]), texts=rand_texts(rng, bodies[0]), busy_slots=rng.choice([[], [], [0x18], [0x18, 0x19, 0x3f]]),
          scene=rng.choice([0x11111111, 2305, 1600, 7]))
    return scs


if __name__ == '__main__':
    sys.exit(main())
