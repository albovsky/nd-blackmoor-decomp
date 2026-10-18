#!/usr/bin/env python3
"""RT-45: immutable x86 dispatcher 0x427a50 / handler 0x4867bd versus the native raw-0xea Onebuild puzzle kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For raw 0xea rows the REAL dispatcher 0x427a50 runs: gate
0x423f57 (dependency tree built by the real loader 0x424aa8), the handler 0x4867bd with ECX = singleton 0x6252ad and,
as original x86 code: the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 on the table at 0x5d1591, the piece
builder 0x48421e, the rectangle translator 0x4841cb, the rectangle test 0x484f0d, the solved check 0x486725, the area
test 0x4866b4, the good and bad drop handlers 0x48633c / 0x485fb6, the sound helpers 0x485ca1 / 0x485d52 / 0x485f12,
the generic completion 0x42ba3a (and 0x423d33 for subtype 2), the cleanup 0x483fb5 with the reset 0x483f6a. The entry
points the engine reaches through other callers are driven directly with ECX = 0x6252ad: the pointer receiver
0x484f42 (cascade 0x4f0059, `ret 0xc`; with the cursor/candidate writer 0x4854fb, the follower 0x484d87, the clamp
0x484caf, the layer helpers 0x484622 / 0x4846c2 / 0x484762 / 0x484935 and the rotation 0x4853b0 as original code),
the accepted-release click 0x48569e (chain 0x43b327), the second-button event 0x484ac0 (0x43c11f), the invalidate
0x4840d9, the cleanup 0x483fb5 and the render callback 0x4876ed (blits 0x4c5377 / 0x4c5d4b recorded). The native side
is src/action_family_ea_runtime.c driven by tests/action_family_ea_runtime_oracle_driver.c with a scripted host.

Compared for every scenario step: the ordered host-call log (every replaced original call with its arguments against
the corresponding EaHost callback; sound, tick, rand and AUTOTEXT calls included; the log kinds are listed in
LOGKINDS), the whole object image 0xc3b bytes, the body image 3847 bytes of every row (0x484f42 clears the tolerance
word), the generic Z entry table (0x58 entries of 0x4a bytes), the row phase dword and the completion byte of every
row, the process flag 0x5bb1ca, the seven scene-change cells, the engine mode 0x583999, the event flag table window
(4096 dwords at 0x585801), the scripted queue consumption (ticks, busy answers, rand values), the pointer results
(return value, [0x5b44f0], [0x5b44f4], [0x5d1631], [0x5d1639], [0x5d162d], [0x5c39e5]) and, for the render callback,
the recorded 0x4c5377 / 0x4c5d4b blits against ea_render_plan (blit list; the object after the call is compared by the
state comparison).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard. ECX and `ret N` were read from the
 disassembly (asm/FUN_*.s) and the `ret` immediates are re-checked against the unmodified image at start-up.
  R 0x51dc43 malloc      bump arena (OS/CRT boundary, used by the dependency loader 0x424aa8), zero filled
  R 0x4c2790 load_image(kind, name, 6, tag)         thiscall ECX 0x5cf659, ret 0x10: returns the scripted handle
  R 0x4c2a8d create_surface(w, h, 6, tag)           thiscall ECX 0x5cf659, ret 0x10: returns a fake surface struct in
     emulated memory (data pointer +0, size dword +0x23 = 0x20, width +0x2b, height +0x2d, pitch +0x2f)
  R 0x4c51a5 blit(src, dst, src rect, dst rect, tag) thiscall ECX 0x5cf659, ret 0x14: records both rectangles
  R 0x4c7070 rotate(surface, 0x63a8a4)              thiscall ECX 0x5cf659, ret 8: records, swaps the struct's width and
     height and sets the pitch, as the real one does at 0x4c70d0
  R 0x4c2dfb release_image(&handle)                 thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param
  R 0x4e8d96 clear pending item                     thiscall ECX 0x571442, ret 0
  R 0x4fb77a prepare sound(record ptr)              thiscall ECX 0x5c3a67, ret 4
  R 0x4fba69 stop sound(record ptr)                 thiscall ECX 0x5c3a67, ret 4
  R 0x4fb2e3 play sound(channel word)               thiscall ECX 0x5c3a67, ret 4 (upper half of the pushed dword ignored)
  R 0x4f6334 sound busy(channel)                    thiscall ECX 0x5cf1eb, ret 4: returns the scripted answer
  R 0x50cd50 _rand                                  plain, ret 0: returns the next scripted value
  R 0x423259 AUTOTEXT lookup(key)                   thiscall ECX 0x619a6b, ret 4: scripted pointer in emulated memory or 0
  R 0x448d11 caption show(surface, text, -1, 0)     thiscall ECX 0x619a05, ret 0x10: records the text, checks the
     other three arguments against [0x5d03b3], -1 and 0
  R 0x4c5377 / 0x4c5d4b render blits (src, dst, src rect, dst rect, tag) thiscall ECX 0x5cf659, ret 0x14: recorders
  R GetTickCount (the IAT slot 0x52a23c, stub)      returns the next scripted tick value
  O 0x4867bd handler entry (row, phase, ECX check)  O 0x42ba3a generic completion  O 0x4d3992 release entry (slot)
  O 0x4d39f9 slot allocator entry  O 0x48455a instruction boundary inside 0x48421e (before the inline pixel copy of a
     rotated entry: records destination and source surface; the copy itself then runs as original code)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
     scenario expects the allocator's fatal path 0x52139c, which is then compared with the native host error);
     0x425b8b and 0x425b40 (debug tree printer / malformed tree) raise through the base.
 Windows imports (OS boundary, IAT slots patched to stubs): GetTickCount (scripted), InterlockedIncrement/Decrement,
 lstrlenA, Enter/Leave/InitializeCriticalSection (single thread); any other import fails the run.
 FS needs a TIB page (GDT) for the SEH frames. Debug flag 0x63a4cd is 0. The singleton is constructed the way the
 original does: vtable word, then 0x483f6a (original code); the base constructor 0x51d716 is not run.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, the view origin
and clip globals, the tick values, busy answers and rand values, the captions flag [0x5bb202], the AUTOTEXT table, the
slot-busy seeds, the event flag table contents, the cursor source [0x5d0377], the caption surface [0x5d03b3].

EXPECTED DIFFERENCES (native safety layer; tagged scenarios, counted in stats.known_observed, never as passes):
  K1 two rows active at once: row B re-initialises the singleton, then row A's phase 1/2 runs in the original on B's
     object (it mixes A's body with B's object); native refuses (EA_ERR_UNSUPPORTED, no effect).
  K2 body validation: piece count outside 0..20, piece size outside 1..4096, an unterminated name/text field, a zero
     animation-grid column count with an animation area, a short body.
  K3 a drop click, rotate key or pointer move whose piece in hand names no piece (index outside 0..count-1): the
     original indexes out of range, native refuses with EA_ERR_BOUNDS before any effect.
  K4 an event flag index outside the host window: the original stores through an arbitrary pointer; native refuses
     with EA_ERR_BOUNDS before any effect.
  K5 phase 1 / 2 on an object that was never initialised for the row: native EA_ERR_UNSUPPORTED.
  K6 a caption (AUTOTEXT text or body text) longer than 199 characters: the original overflows its 204-byte local;
     native refuses with EA_ERR_BOUNDS. An AUTOTEXT text longer than 0x9c40 characters is a valid-domain case (the
     original falls back to the body text) and is compared.
  All six are unreachable in the game (6 rows, loader-built bodies, two rows per scene gated against each other).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.

Not modelled / unverified (see the receipt): the real image loader 0x4c2790, creator 0x4c2a8d, blitter 0x4c51a5,
rotator 0x4c7070 and releaser 0x4c2dfb, the sound engine (0x4fb77a, 0x4fba69, 0x4fb2e3, 0x4f6334), 0x4e8d96, the blit
bodies 0x4c5377 / 0x4c5d4b, the AUTOTEXT table behind 0x423259 and the caption writer 0x448d11, _rand, GetTickCount,
the pointer cascade 0x4f0059 that calls 0x484f42, the accepted-release chain 0x43b327 that calls 0x48569e, the
second-button chain 0x43c11f, the scene loader / type loader 0x484110 that build the body, and the engine consumer
of the scene-change cells.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_ea_runtime_original_oracle.py --mutations --result ../../../work/analysis/slices/RT-45.oracle-result.json
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import random
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import time
import ctypes as C
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x6252ad
OBJ_LEN = 0xc3b
BODY_LEN = 3847
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
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
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
SOUND_THIS, BUSY_THIS, ITEM_THIS = 0x5c3a67, 0x5cf1eb, 0x571442
AUTO_THIS, CAP_THIS = 0x619a6b, 0x619a05
FPCW = 0x27f
MARK_SAVED, MARK_BACK, MARK_CAPSURF, MARK_CURSOR_SRC = 0x5d1111, 0x22220000, 0x5d1234, 0x5d4321
VTABLE = 0x52d740

# log kinds, shared with the driver
LOGKINDS = dict(LOAD=1, CREATE=2, BLIT=3, COPY=4, ROTATE=5, RELEASE=6, CLEAR_ITEM=7, SND_PREPARE=8, SND_STOP=9,
                SND_PLAY=10, SND_BUSY=11, TICK=12, RAND=13, AUTOTEXT=14, CAPTION=15, COMPLETE=16, ALLOC=17,
                RELEASE_SLOT=18, ENTER=19)
KN = {v: k for k, v in LOGKINDS.items()}

TAG_SRC = b'DF Piece Source Surface'
TAG_MULTI = b'Multi Anim Surface'
TAG_PIECE = b'pDFSurface for Onebuild Puzzle Piece'  # prefix; the original appends ", Orientation ..." texts
# the kernel's host tags are identifier-like stand-ins (underscores, a shorter piece tag): compared by class (E7)
NATIVE_TAG_CLASS = {b'DF Piece Source Surface': b'SRC', b'Multi Anim Surface': b'MULTI'}

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4e8d96: (0x80, 0), 0x4fb77a: (0x300, 4),
             0x4fba69: (0x20, 4), 0x4fb2e3: (0x200, 4), 0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14),
             0x4c5d4b: (0x350, 0x14), 0x4c2a8d: (0x1ad, 0x10), 0x4c51a5: (0x1d2, 0x14), 0x4c7070: (0x189, 8),
             0x423259: (0x10f, 4), 0x448d11: (0xa21, 0x10), 0x50cd50: (0x22, 0)}
# replaced address -> (`ret N`, expected ECX or None)
REPLACED = {0x4c2790: (0x10, SURF_HOST), 0x4c2a8d: (0x10, SURF_HOST), 0x4c51a5: (0x14, SURF_HOST),
            0x4c7070: (8, SURF_HOST), 0x4c2dfb: (4, SURF_HOST), 0x4e8d96: (0, ITEM_THIS),
            0x4fb77a: (4, SOUND_THIS), 0x4fba69: (4, SOUND_THIS), 0x4fb2e3: (4, SOUND_THIS),
            0x4f6334: (4, BUSY_THIS), 0x50cd50: (0, None), 0x423259: (4, AUTO_THIS), 0x448d11: (0x10, CAP_THIS),
            0x4c5377: (0x14, SURF_HOST), 0x4c5d4b: (0x14, SURF_HOST)}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
AT_COPY = 0x48455a

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
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
 (0x483f6a, 0x483fb5,
  'ba788905e75086f9b1f4b580463e82a115a71f94cda011b5c77ede5734fcc623'),
 (0x483fb5, 0x4840d9,
  '711a0b51a366e8e3159629aa7186ac2d530bf8f385202de40b8657b0c9bf9413'),
 (0x4840d9, 0x484110,
  'bfc4645bf50fb5904256fba0e7a07ec3c0e013770086c7a66f912648de055c6e'),
 (0x4841cb, 0x48421e,
  '30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57'),
 (0x48421e, 0x484622,
  'd0106e6bfe32c4c95139a4b90978007858e27baaeb2c17f400beae1668eaeaf9'),
 (0x484622, 0x4846c2,
  '26068d405e89ae2e3abfc6f8adad7507b4364a2c8909872bb283c7ac3efd25f6'),
 (0x4846c2, 0x484762,
  'afbc1b372e487fedc24fdbe351e9220c6997945c75a6094c91fd3c68efa00eea'),
 (0x484762, 0x484935,
  '18857f1882b6325bbd9f20668785eb0a93c1edd406423aeb122c200b7f5a6fb5'),
 (0x484935, 0x484ac0,
  '5eea9362fc92307b461fc2ac854f414992eba0b1233a8e84eb0023ba0382b022'),
 (0x484ac0, 0x484caf,
  'd4cadc5e8a635142bbb45e5c8cf6b3d41e61b5bb3668796faec47b365653a004'),
 (0x484caf, 0x484d87,
  'efe2f23539b342c092f2e420aec64754623d4d5435d8931b73ee0c408354c2be'),
 (0x484d87, 0x484f0d,
  'cd2af4863633ab6d2638e2b3ee1332d9199e004cf9ae737fab7bb52df66ff661'),
 (0x484f0d, 0x484f42,
  'c79a9aef8da7071bd7a7489b72ab12802f5aecc36e3c8e8a2e2ccca68cd760ea'),
 (0x484f42, 0x4853b0,
  '3ff2ddbbdc87a871d5cdce79ebaa3e75c65b35d79062294f7ba36c9f9252da5d'),
 (0x4853b0, 0x4854fb,
  'e0c5f1405c21fb9884ddb1c5e578ecea09bcea61b8e2f3a2348b982815d27ed3'),
 (0x4854fb, 0x48569e,
  '81850f86de93ecda5129d44a2ff1c9323cf536507db7631f5a8a5554c3c699e1'),
 (0x48569e, 0x485ca1,
  '1a7f0c74498a1030be7456da172cb166b303699e5e9344ca604eb160e484a600'),
 (0x485ca1, 0x485d52,
  '4c63a7987297a76e795c3140f0aac896ebbe5018fb598c1a86b3c57bec5e8ec1'),
 (0x485d52, 0x485f12,
  'aad3960dbe028697511f500ad7e2328e726a6483d6d83ae0ed0bbe257ae15e10'),
 (0x485f12, 0x485fb6,
  '45433610cb358442f3fafa12020499d743a8936f8953521a61676289147a49a7'),
 (0x485fb6, 0x48633c,
  'f94e4166037ec6fa5531a630ce23fba29000e2c9db565fcfd68b51b4476a9648'),
 (0x48633c, 0x4866b4,
  '0fb74a55768eca84e6e4fc7b1bc1d917226cd471256cfa864179ab5f767b36d9'),
 (0x4866b4, 0x486725,
  '38379eb29665b615dc33cc66ddbfaea8c0067eb1132ca15870b30a45e0e93f5b'),
 (0x486725, 0x4867bd,
  'a1bdcd83e0540a10a1494cec790ec67b6dfd6a00488342849cdbe5b55b9488ab'),
 (0x4867bd, 0x4876c1,
  '98e222e5451740e8032b2c2e66e5fec3289b0272c199ec01f56920facab8afde'),
 (0x4876ed, 0x4879f7,
  '3b2a9a30c50cd1aaaf6b0b1bc7158a8fa5d452bb399a7e67245f3ba28eff56de'),
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
 (0x50cd50, 0x50cd72,
  '0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477'),
 (0x51dc43, 0x51dc6c,
  '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
 (0x52139c, 0x5213d4,
  '4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6'),
)

# --- body layout (offsets verified against asm/FUN_004867bd.s and the helpers) ---------------------------------------
B_NAME, B_COUNT, B_FLAG23, B_ROT, B_ROTLOCK, B_ZH, B_ZW = 0, 0x21, 0x23, 0x24, 0x25, 0x26, 0x28
B_TOLON, B_TOL, B_ORDERED, B_ORDER, B_LAYON, B_LAYER, B_PIECES = 0x2a, 0x2b, 0x2d, 0x2e, 0x56, 0x57, 0x7f
BP_STRIDE = 0x42
B_AREA, B_DROP, B_ANIM_NAME, B_ANIM_AREA, B_EXIT_AREA, B_GRID = 0x5a7, 0x5b7, 0x5c7, 0x5e8, 0x5f8, 0x608
SND = dict(anim=0x614, done=0x645, rot=0x676, pick=0x6a7, drop=0x6d8, good=0x74b, bad=0xa79, win=0xdc4)
ALT = dict(drop=(0x709, 0x72a), good=(0x77c, 0x79d), bad=(0xaaa, 0xacb))
KEYS = dict(good=0x7be, bad=0xaec, win=0xdf5)
TEXTS = dict(good=0x821, bad=0xb4f, win=0xe16)
B_CURSOR_PICK, B_CURSOR_EXIT, B_BLOCK_WIN, B_BLOCK_EXIT, B_EXIT_RECT = 0xda7, 0xda9, 0xdab, 0xede, 0xef7
SCENE_FMT = '<h3h3ihhB'
NO_SOUND = b'NO SOUND'


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


def make_body(rng, n=6, name=b'PIECESRC', pieces=None, rot=0, rotlock=0, flag23=0, zone=(10, 12), tol=(1, 6), ordered=0,
              order=None, layer=None, area=(0, 0, 639, 479), drop=(0, 0, 0, 0), anim_name=b'', anim_area=(0, 0, 0, 0),
              exit_area=(0, 0, 0, 0), grid=(2, 3, 5, 7, 1, 2), sounds=None, alts=None, keys=None, texts=None, chans=None,
              cursors=(3, 4), win=None, exit_=None, exit_rect=(560, 420, 620, 460), garbage=True, board=None):
    """A 3,847-byte typed body. `pieces` is a list of dict(A, B, C, D, orient, loose); every unspecified field is
    deterministic from `rng`. Rects are (left, top, right, bottom) with inclusive edges."""
    b = bytearray(rng.randbytes(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    put_name(b, B_NAME, name, 0x21, rng if garbage else None)
    struct.pack_into('<h', b, B_COUNT, n)
    b[B_FLAG23] = flag23
    b[B_ROT], b[B_ROTLOCK] = rot, rotlock
    struct.pack_into('<hh', b, B_ZH, zone[0], 0)
    struct.pack_into('<h', b, B_ZW, zone[1])
    b[B_TOLON] = tol[0]
    struct.pack_into('<h', b, B_TOL, tol[1])
    b[B_ORDERED] = ordered
    order = order if order is not None else list(range(1, 21))
    for i in range(20):
        struct.pack_into('<h', b, B_ORDER + 2 * i, order[i] if i < len(order) else rng.randrange(0, 22))
    b[B_LAYON] = 1 if layer is not None else 0
    for i in range(20):
        struct.pack_into('<h', b, B_LAYER + 2 * i, layer[i] if layer is not None and i < len(layer) else rng.randrange(0, 22))
    cnt = max(n, 0)
    if pieces is None:
        pieces = default_pieces(rng, cnt, board or area)
    for i in range(20):
        p = pieces[i] if i < len(pieces) else None
        base = B_PIECES + BP_STRIDE * i
        if p is None:
            if garbage:
                for k in range(0x42):
                    b[base + k] = rng.randrange(256)
            else:
                b[base:base + 0x42] = bytes(0x42)
            continue
        b[base:base + 0x10] = rect_bytes(p['A'])
        b[base + 0x10:base + 0x20] = rect_bytes(p['B'])
        b[base + 0x20:base + 0x30] = rect_bytes(p['C'])
        b[base + 0x30:base + 0x40] = rect_bytes(p['D'])
        b[base + 0x40] = p.get('orient', 0)
        b[base + 0x41] = p.get('loose', 0)
    b[B_AREA:B_AREA + 16] = rect_bytes(area)
    b[B_DROP:B_DROP + 16] = rect_bytes(drop)
    put_name(b, B_ANIM_NAME, anim_name, 0x21, rng if garbage else None)
    b[B_ANIM_AREA:B_ANIM_AREA + 16] = rect_bytes(anim_area)
    b[B_EXIT_AREA:B_EXIT_AREA + 16] = rect_bytes(exit_area)
    struct.pack_into('<6h', b, B_GRID, *grid)
    sounds = sounds or {}
    chans = chans or {}
    for k, off in SND.items():
        put_sound(b, off, sounds.get(k, NO_SOUND), chans.get(k, 10 + len(k)), rng)
    for k, (o1, o2) in ALT.items():
        a1, a2 = (alts or {}).get(k, (NO_SOUND, NO_SOUND))
        put_name(b, o1, a1, 0x21, rng)
        put_name(b, o2, a2, 0x21, rng)
    for k, off in KEYS.items():
        for j in range(3 if k != 'win' else 1):
            ks = (keys or {}).get(k, [b'', b'', b''])
            put_name(b, off + 0x21 * j, ks[j] if j < len(ks) else b'', 0x21, rng)
    for k, off in TEXTS.items():
        for j in range(3 if k != 'win' else 1):
            ts = (texts or {}).get(k, [b'', b'', b''])
            put_name(b, off + 200 * j, ts[j] if j < len(ts) else b'', 200, rng)
    struct.pack_into('<hh', b, B_CURSOR_PICK, *cursors)
    b[B_BLOCK_WIN:B_BLOCK_WIN + 25] = win if win is not None else scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 1984, 1)
    b[B_BLOCK_EXIT:B_BLOCK_EXIT + 25] = exit_ if exit_ is not None else scene_block(4366, (7, 8, 9), (10, 11, 12), 1, -1, 0)
    b[B_EXIT_RECT:B_EXIT_RECT + 16] = rect_bytes(exit_rect)
    return bytes(b)


def default_pieces(rng, cnt, board):
    out = []
    bl, bt, br, bb = board
    for i in range(cnt):
        w, h = rng.randrange(14, 56), rng.randrange(14, 56)
        sx, sy = rng.randrange(0, 300), rng.randrange(0, 300)
        a = (sx, sy, sx + w - 1, sy + h - 1)
        tx, ty = rng.randrange(bl + 20, max(bl + 21, br - 80)), rng.randrange(bt + 20, max(bt + 21, bb - 120))
        c = (tx, ty, tx + w - 1, ty + h - 1)
        dx, dy = rng.randrange(bl, max(bl + 1, br - 60)), rng.randrange(max(bb - 100, bt), max(bb - 99, bt + 1))
        d = (dx, dy, dx + w - 1, dy + h - 1)
        bz = (0, 0, 0, 0) if rng.random() < 0.5 else (sx + 3, sy + 3, sx + 3 + w - 1, sy + 3 + h - 1)
        out.append(dict(A=a, B=bz, C=c, D=d, orient=rng.choice([0, 0, 1, 2, 3]) if rng.random() < 0.3 else 0,
                        loose=1 if rng.random() < 0.15 else 0))
    return out


def parse(body):
    g = lambda o, f: struct.unpack_from(f, body, o)[0]
    n = g(B_COUNT, '<h')
    pcs = []
    for i in range(max(0, min(n, 20))):
        base = B_PIECES + BP_STRIDE * i
        pcs.append(dict(A=struct.unpack_from('<4i', body, base), B=struct.unpack_from('<4i', body, base + 0x10),
                        C=struct.unpack_from('<4i', body, base + 0x20), D=struct.unpack_from('<4i', body, base + 0x30),
                        orient=body[base + 0x40], loose=body[base + 0x41]))
    return dict(n=n, pieces=pcs, rot=body[B_ROT], rotlock=body[B_ROTLOCK], tolon=body[B_TOLON], tol=g(B_TOL, '<h'),
                ordered=body[B_ORDERED], area=struct.unpack_from('<4i', body, B_AREA), drop=struct.unpack_from('<4i', body, B_DROP),
                anim_area=struct.unpack_from('<4i', body, B_ANIM_AREA), exit_area=struct.unpack_from('<4i', body, B_EXIT_AREA),
                exit_rect=struct.unpack_from('<4i', body, B_EXIT_RECT), zone=(g(B_ZH, '<h'), g(B_ZW, '<h')),
                order=[g(B_ORDER + 2 * i, '<h') for i in range(20)])


_CORPUS = None


def corpus_rows():
    """The 6 raw 0xea rows of the owner's local resources (never printed; only counts and hashes leave here)."""
    global _CORPUS
    if _CORPUS is None:
        c = json.loads((PRIVATE / 'A-EA.1.corpus.json').read_text())
        out = []
        for r in c['records']:
            data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % r['resource_index'])).read_bytes()
            p, n = r['raw_body_offset'], r['raw_body_length']
            body = data[p:p + n]
            if len(body) != BODY_LEN + r['dependency_tail_length'] or sha(body) != r['body_sha256'] or \
               data[r['act_payload_offset'] + 48] != 0xea:
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
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_ea_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_ea_runtime.c'), '-o', str(out)]
    if os.environ.get('EA_SANITIZE'):
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p, u32p, i32p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8), C.POINTER(C.c_uint32), C.POINTER(C.c_int32)
    lib.eao_new.restype = p
    for name, args, res in (
            ('eao_free', [p], None), ('eao_set_view', [p, i32p], None), ('eao_set_world_flag', [p, i32], None),
            ('eao_get_world_flag', [p], i32), ('eao_set_captions', [p, i32], None),
            ('eao_set_handles', [p, u32p, C.c_int], None),
            ('eao_set_queues', [p, u32p, C.c_int, i32p, C.c_int, i32p, C.c_int], None),
            ('eao_consumed', [p, i32p], None), ('eao_clear_texts', [p], None),
            ('eao_add_text', [p, C.c_char_p, C.c_char_p], None), ('eao_set_busy_slot', [p, C.c_int, C.c_int], None),
            ('eao_set_entry_u32', [p, C.c_int, C.c_int, C.c_uint32], None), ('eao_set_cells', [p, i32p], None),
            ('eao_get_cells', [p, i32p], None), ('eao_set_events', [p, i32p], None), ('eao_get_events', [p, i32p], None),
            ('eao_entries', [p, u8p], None), ('eao_set_entries', [p, u8p], None), ('eao_clear_log', [p], None), ('eao_log_count', [p], C.c_int),
            ('eao_bad_slot_calls', [p], C.c_int), ('eao_log', [p, C.c_int, i32p], None),
            ('eao_log_text', [p, C.c_int], C.c_char_p), ('eao_set_body', [p, C.c_int, u8p, C.c_size_t], C.c_int),
            ('eao_get_body', [p, C.c_int, u8p, C.c_size_t], None), ('eao_why', [p], C.c_char_p),
            ('eao_object', [p, u8p], None), ('eao_set_object', [p, u8p], None),
            ('eao_step', [p, C.c_int, C.c_int, C.c_uint32, u32p], C.c_int),
            ('eao_pointer', [p, C.c_int, C.c_int, C.c_int, i32p, i32p], C.c_int),
            ('eao_click', [p, C.c_int, C.c_uint32, i32, u32p], C.c_int), ('eao_rotkey', [p, C.c_int, C.c_uint32], C.c_int),
            ('eao_invalidate', [p], C.c_int), ('eao_cleanup', [p], C.c_int), ('eao_plan', [p, C.c_int, i32p], C.c_int),
            ('eao_validate', [u8p, C.c_size_t], C.c_int)):
        f = getattr(lib, name)
        f.argtypes = args
        f.restype = res
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.eao_new()
        self.nrows = 0

    def close(self):
        self.lib.eao_free(self.h)

    def set_view(self, v):
        self.lib.eao_set_view(self.h, (C.c_int32 * 6)(*v))

    def set_handles(self, hs):
        self.lib.eao_set_handles(self.h, (C.c_uint32 * max(1, len(hs)))(*hs), len(hs))

    def set_queues(self, ticks, busy, rands):
        self.lib.eao_set_queues(self.h, (C.c_uint32 * max(1, len(ticks)))(*[v & 0xffffffff for v in ticks]), len(ticks),
                                (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy]), len(busy),
                                (C.c_int32 * max(1, len(rands)))(*[s32(v) for v in rands]), len(rands))

    def consumed(self):
        t = (C.c_int32 * 8)()
        self.lib.eao_consumed(self.h, t)
        return list(t)

    def set_texts(self, texts):
        self.lib.eao_clear_texts(self.h)
        for k, v in texts.items():
            self.lib.eao_add_text(self.h, k, v)

    def set_body(self, i, body):
        self.lib.eao_set_body(self.h, i, cbuf(body), len(body))

    def body(self, i):
        t = (C.c_uint8 * BODY_LEN)()
        self.lib.eao_get_body(self.h, i, t, BODY_LEN)
        return bytes(t)

    def log(self):
        out = []
        t = (C.c_int32 * 13)()
        for i in range(self.lib.eao_log_count(self.h)):
            self.lib.eao_log(self.h, i, t)
            out.append((t[0], tuple(t[1:13]), (self.lib.eao_log_text(self.h, i) or b'')))
        return out

    def clear(self):
        self.lib.eao_clear_log(self.h)

    def step(self, ri, row, phase):
        self.clear()
        res = (C.c_uint32 * 3)()
        status = self.lib.eao_step(self.h, ri, row, phase, res)
        return status, (self.lib.eao_why(self.h) or b'').decode(), self.log(), list(res)

    def pointer(self, ri, x, y, rect):
        self.clear()
        out = (C.c_int32 * 6)()
        status = self.lib.eao_pointer(self.h, ri, x, y, (C.c_int32 * 4)(*rect), out)
        return status, list(out), self.log()

    def click(self, ri, row_phase, cand):
        self.clear()
        newp = C.c_uint32(0)
        status = self.lib.eao_click(self.h, ri, row_phase, cand, C.byref(newp))
        return status, newp.value, self.log()

    def rotkey(self, ri, row_phase):
        self.clear()
        return self.lib.eao_rotkey(self.h, ri, row_phase), self.log()

    def simple(self, fn):
        self.clear()
        status = fn(self.h)
        return status, self.log()

    def obj(self):
        t = (C.c_uint8 * OBJ_LEN)()
        self.lib.eao_object(self.h, t)
        return bytes(t)

    def set_obj(self, raw):
        self.lib.eao_set_object(self.h, cbuf(raw))

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.eao_entries(self.h, t)
        return bytes(t)

    def set_entries(self, raw):
        self.lib.eao_set_entries(self.h, cbuf(raw))

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.eao_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        self.lib.eao_set_cells(self.h, (C.c_int32 * 8)(*v))

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.eao_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        self.lib.eao_set_events(self.h, (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw))

    def plan(self, ri):
        t = (C.c_int32 * (2 + 11 * 40))()
        status = self.lib.eao_plan(self.h, ri, t)
        v = list(t)
        blits = []
        for i in range(v[1] if 0 <= v[1] <= 40 else 0):
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


def canon_tag(kind, tag, native):
    if kind == b'LOAD':
        c = NATIVE_TAG_CLASS.get(tag, tag if tag in (b'SRC', b'MULTI') else None) if native else \
            {TAG_SRC: b'SRC', TAG_MULTI: b'MULTI'}.get(tag)
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
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
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
        self.allocs = {}
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.blits = []
        self.handles, self.handle_i = [], 0
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.rand_q, self.rand_i = [], 0
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

    def _check_strings(self):
        base = self.pe.image_base
        for va, text in ((0x54dbf4, b'CIFTREE'), (0x54dc18, b'CIFTREE'), (0x54dbdc, TAG_SRC), (0x54dc04, TAG_MULTI)):
            have = cstr(self.pristine[va - base:va - base + 64])
            if have != text:
                raise OracleError('string at %#x differs from the packet' % va)
        for va in (0x54da9c, 0x54db0c):
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
        table[0x4867bd] = self._entry
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
            raise OracleError('handler entered with ECX != 0x6252ad')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        if phase == 1:
            self.counters['phase1_state_%d' % self.rs32(OBJ + 0xbac)] += 1
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
        if OBJ <= ptr < OBJ + OBJ_LEN:
            return 0x10000 + ptr - OBJ
        if self.rowbase <= ptr < self.rowbase + BODY_LEN:
            return ptr - self.rowbase
        raise OracleError('sound record pointer %#x is neither in the object nor in the active body' % ptr)

    def surf_struct(self, handle):
        if not SURF_BASE <= handle < SURF_BASE + SURF_STRIDE * 4096 or (handle - SURF_BASE) % SURF_STRIDE:
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
            self.log(K['LOAD'], (eax,), name + b'|' + canon_tag(b'LOAD', tag, False))
        elif address == 0x4c2a8d:
            w, h, six, tag = s16(a[0]), s16(a[1]), a[2], cstr(self.rd(a[3], 64))
            if six != 6:
                raise OracleError('surface creator argument 6')
            if self.surf_n >= 4096:
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
            self.log(K['CREATE'], (w, h, eax), canon_tag(b'CREATE', tag, False))
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
        elif address == 0x50cd50:
            if self.rand_i >= len(self.rand_q):
                raise OracleError('rand queue underflow')
            eax = self.rand_q[self.rand_i] & 0xffffffff
            self.rand_i += 1
            self.log(K['RAND'], (s32(eax),))
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
        self.tick_q, self.tick_i, self.busy_q, self.busy_i, self.rand_q, self.rand_i = [], 0, [], 0, [], 0
        self.texts = {}
        self.surf_n = 0
        self.rec = False
        self.expect_fatal = None
        self.rowbase = 0
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.w32(OBJ, VTABLE)
        self.call(0x483f6a, [], OBJ)  # the constructor's reset, original code
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
            self.wr(base + 0x30, bytes([0xea, spec.get('subtype', 1)]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = TAIL_BASE + i * 0x400
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def set_queues(self, ticks, busy, rands):
        self.tick_q, self.tick_i = list(ticks), 0
        self.busy_q, self.busy_i = list(busy), 0
        self.rand_q, self.rand_i = list(rands), 0

    def dispatch(self):
        self.fx = []
        self.entered = []
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
            s = name + b'|' + canon_tag(b'LOAD', tag, True)
        elif k == LOGKINDS['CREATE']:
            s = canon_tag(b'CREATE', s, True)
        out.append((k, pad12(v), s))
    return out


def compare_log(where, orig, nat):
    orig, nat = list(orig), norm_nat(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        raise Mismatch('%s host call %d: original %s vs native %s (original %d calls, native %d)' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None,
            len(orig), len(nat)))


OBJ_NAMES = [(0x1c, 'slot'), (0x1e, 'multi_surf'), (0x22, 'src_surf'), (0x26, 'row'), (0x28, 'piece'), (0xa92, 'drag'),
             (0xa96, 'drop'), (0xa9a, 'lift'), (0xa9e, 'hand'), (0xaa0, 'prev'), (0xab0, 'move'), (0xac0, 'prev_t'),
             (0xad0, 'move_t'), (0xae0, 'saved'), (0xb21, 'snd_a'), (0xb52, 'snd_b'), (0xb83, 'placed_ok'),
             (0xb87, 'drop_snd'), (0xb8b, 'has_anim'), (0xb8f, 'anim_rest'), (0xb93, 'anim_on'), (0xb97, 'anim_src'),
             (0xba7, 'active'), (0xbab, 'exit'), (0xbac, 'state'), (0xbb0, 'done'), (0xbb1, 'ptr_rect'),
             (0xbc1, 'caption'), (0xbc5, 'pw'), (0xbc7, 'ph'), (0xbc9, 'deadline'), (0xbcd, 'deadline2'),
             (0xbd1, 'list_unplaced'), (0xbf9, 'n_unplaced'), (0xbfb, 'list_placed'), (0xc23, 'n_placed'),
             (0xc25, 'placed_n'), (0xc27, 'exit_area'), (0xc2b, 'click_anim'), (0xc2f, 'flag_2f'), (0xc33, 'anim_col'),
             (0xc35, 'anim_frame'), (0xc37, 'cell_w'), (0xc39, 'cell_h')]


def field_of(off):
    best = '?'
    for o, n in OBJ_NAMES:
        if o <= off:
            best = '%s+%#x' % (n, off - o)
    if 0x28 <= off < 0xa92:
        i, r = divmod(off - 0x28, 0x85)
        return 'piece%d+%#x' % (i, r)
    return best


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
    for r in range(ctx.first + len(ctx.rows)):
        ob, nb = x.body(r), nat.body(r)
        stats['body_bytes'] += len(ob)
        if ob != nb:
            k = first_diff(ob, nb)
            raise Mismatch('%s body of row %d +%#x: original %02x native %02x' % (where, r, k, ob[k], nb[k]))
    if x.rs32(START_FLAG) != nat.lib.eao_get_world_flag(nat.h):
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), nat.lib.eao_get_world_flag(nat.h)))
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
    r = ctx.x.rs16(OBJ + 0x26)
    return r if row_body(ctx, r) is not None else None


def active_ri(ctx):
    r = obj_row(ctx)
    return r if r is not None else ctx.first


def make_queues(ctx, spec):
    """Tick values, busy answers and rand values for one operation; both sides receive the same lists."""
    x, rng = ctx.x, ctx.rng
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 8)
    d1, d2 = struct.unpack('<II', x.rd(OBJ + 0xbc9, 8))
    if policy == 'clock':
        base = ctx.clock
        ticks = [(base + i) & 0xffffffff for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', (0, 1, 7, 100, 300, 800, 1500, 2500, 9000)))) & 0xffffffff
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 99, 100, 299, 300, 301, 799, 800, 1999, 2000, 2001, 0x80000000, -0x80000000, 0x7fffffff]
        dl = rng.choice([d1, d2, d1, d2, ctx.clock])
        ticks = [(dl + rng.choice(offs)) & 0xffffffff for _ in range(n)]
        if rng.random() < 0.5:
            ticks = sorted(ticks, key=lambda v: (v - dl) & 0xffffffff)
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, d1, d1 - 1, d2, d2 + 1, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)])
                 & 0xffffffff for _ in range(n)]
    else:
        ticks = list(policy)
    b = spec.get('busy', 'rand')
    if b == 'zero':
        busy = [0] * 8
    elif b == 'one':
        busy = [1] * 8
    elif b == 'rand':
        busy = [rng.choice([0, 0, 1, 1, 1, 2, -1]) for _ in range(8)]
    else:
        busy = list(b) + [0] * 8
    r = spec.get('rand', getattr(ctx, 'rand_default', 'rand'))
    if r == 'zero':
        rands = []
    elif r == 'rand':
        rands = [rng.choice([0, 1, 2, 3, 4, 5, 7, 8, 32767, 16384, rng.randrange(32768)]) for _ in range(rng.randrange(0, 8))]
    else:
        rands = list(r)
    rands = rands + [0] * 24
    return ticks, busy, rands


def set_queues(ctx, spec):
    ticks, busy, rands = make_queues(ctx, spec)
    ctx.x.set_queues(ticks, busy, rands)
    ctx.nat.set_queues(ticks, busy, rands)


def check_consumption(where, ctx):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    nc = nat.consumed()
    oc = (x.tick_i, x.busy_i, x.rand_i)
    if oc != tuple(nc[:3]) or nc[3] or nc[4] or nc[5] or nc[6]:
        raise Mismatch('%s queue consumption original %s native %s' % (where, oc, nc))
    stats['ticks_consumed'] += x.tick_i
    stats['busy_consumed'] += x.busy_i
    stats['rands_consumed'] += x.rand_i
    if nat.lib.eao_bad_slot_calls(nat.h):
        raise Mismatch('%s native used an out-of-range slot' % where)


def check_entry(ctx, mode, row, last_row):
    """Sanity of the original dispatcher's choice (the gate 0x423f57 is original code): ascending rows, engine mode 3,
    row not completed, not disabled, and the dependency tail not contradicted by the tail model when it is a plain list."""
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
        nat.lib.eao_clear_log(nat.h)
        status, why, log, res = nat.step(row, row, phase)
        nfx.extend(norm_nat(log))
        stats['steps'] += 1
        if status in (3, 6, 2) and ctx.sc.get('known') in ('K1', 'K4', 'K5'):
            if log:
                raise Mismatch('%s %s refusal had effects' % (where, ctx.sc['known']))
            stats['known_observed']['%s:%s' % (ctx.sc['known'], ctx.sc['id'])] += 1
            ctx.stop = True
            ctx.skip_final = True
            return 0
        if fatal is not None and n_i == len(entered) - 1:
            if status != 4 or nat.consumed()[7] < 1:
                raise Mismatch('%s original reached fatal path %#x but native status %d (%s)' % (where, fatal, status, why))
            ctx.phase[row] = x.row_phase(row)  # the original stores the phase before the slot allocation
            continue
        if status != 0:
            raise Mismatch('%s native refused (status %d: %s) where the original ran' % (where, status, why))
        after = x.row_phase(row)
        if after != res[0]:
            raise Mismatch('%s row %d phase: original %d native %d' % (where, row, after, res[0]))
        if bool(res[1]) != (phase == 0):
            raise Mismatch('%s initialized flag %d for phase %d' % (where, res[1], phase))
        if bool(res[2]) != (phase == 2):
            raise Mismatch('%s completed flag %d for phase %d' % (where, res[2], phase))
        ctx.phase[row] = res[0]
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


def obj_state(ctx):
    x = ctx.x
    row = obj_row(ctx)
    body = row_body(ctx, row) if row is not None else None
    n = struct.unpack_from('<h', body, B_COUNT)[0] if body else 0
    return dict(row=row, active=x.rs32(OBJ + 0xba7), drag=x.rs32(OBJ + 0xa92), hand=x.rs16(OBJ + 0xa9e),
                state=x.rs32(OBJ + 0xbac), done=x.rd(OBJ + 0xbb0, 1)[0], n=n, body=body,
                rp=ctx.phase.get(row, 0) if row is not None else 0)


def do_pointer(ctx, where, px, py, rect=None):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    st = obj_state(ctx)
    ri = active_ri(ctx)
    if rect is None:
        rect = (px - 3, py - 3, px + 3, py + 3)
    rect = tuple(clamp16(v) if abs(v) < 1 << 31 else v for v in rect)
    x.wr(PTR_RECT, struct.pack('<4i', *rect))
    before = [x.rs32(a) for a in (G_CAND, G_CURSOR, G_CURSOR2, G_E2_SRC, G_E2_REC, G_E2_FLAG)]
    if st['active'] and st['drag'] and not (0 <= st['hand'] < st['n']):
        status, out, log = nat.pointer(ri, px, py, rect)
        if status != 6 or log:
            raise Mismatch('%s K3 expected EA_ERR_BOUNDS without effects, got %d / %s' % (where, status, log))
        stats['known_observed']['K3:pointer'] += 1
        x.wr(OBJ, nat.obj())  # the native kernel had stored the pointer rectangle before it refused
        return
    x.fx = []
    ret = x.run_op(0x484f42, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000, PTR_RECT], OBJ)
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
            nat.lib.eao_set_entry_u32(nat.h, 2, off, v & 0xffffffff)
        stats['cand_%d' % ncand] += 1
    else:
        if after != before:
            raise Mismatch('%s original wrote cursor/candidate %s, native did not' % (where, after))
        if ncand != -1:
            raise Mismatch('%s native candidate %d without a write' % (where, ncand))
    stats['pointer_moves'] += 1
    stats['cursor_words'] += 6
    compare_state(where, ctx)


def hand_ok(st):
    return 0 <= st['hand'] < st['n']


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
    if acts and ctx.cand in (0x277a, 0x277b) and not hand_ok(st):
        status, newp, log = nat.click(ri, rp, ctx.cand)
        if status != 6 or log:
            raise Mismatch('%s K3 expected EA_ERR_BOUNDS without effects, got %d / %s' % (where, status, log))
        stats['known_observed']['K3:click'] += 1
        return
    set_queues(ctx, spec)
    x.rowbase = BODY_BASE + BODY_STRIDE * ri
    x.run_op(0x48569e, [], OBJ)
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
    rot, lock = body[B_ROT], body[B_ROTLOCK]
    nun = x.rs16(OBJ + 0xbf9)
    acts = bool(st['active'] and rot != 0 and lock == 0 and not st['done'] and st['state'] == 0 and rp == 1 and nun != 0)
    if acts and st['drag'] and not hand_ok(st):
        status, log = nat.rotkey(ri, rp)
        if status != 6 or log:
            raise Mismatch('%s K3 expected EA_ERR_BOUNDS without effects, got %d / %s' % (where, status, log))
        stats['known_observed']['K3:rotkey'] += 1
        return
    set_queues(ctx, spec)
    x.rowbase = BODY_BASE + BODY_STRIDE * ri
    x.run_op(0x484ac0, [], OBJ)
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
    slot = x.rs16(OBJ + 0x1c)
    if row is None or slot == -1 or not x.rs32(OBJ + 0xba7):
        stats['render_skipped_unreachable'] += 1  # the entry is released: the engine never calls the callback
        return
    st = obj_state(ctx)
    if st['drag'] and not hand_ok(st):
        nat.clear()
        status, plan = nat.plan(row)
        if status != 6:
            raise Mismatch('%s K3 render expected EA_ERR_BOUNDS, got %d' % (where, status))
        stats['known_observed']['K3:render'] += 1
        x.wr(OBJ, nat.obj())  # the native plan had consumed the drop/lift flags before it refused
        return
    multi, src = x.rs32(OBJ + 0x1e) & 0xffffffff, x.rs32(OBJ + 0x22) & 0xffffffff
    x.blits = []
    x.fx = []
    x.call(0x4876ed, [], 0)
    nat.clear()
    status, plan = nat.plan(row)
    log = nat.log()
    if status != 0:
        raise Mismatch('%s native plan status %d' % (where, status))
    stats['render_calls'] += 1
    bl = x.blits
    if not plan['valid'] or plan['count'] != len(bl):
        raise Mismatch('%s blit count original %d plan valid %d count %d' % (where, len(bl), plan['valid'], plan['count']))
    for i, b in enumerate(bl):
        p = plan['blits'][i]
        stats['blit_calls'] += 1
        if b['kind'] != p['kind'] or b['src'] != p['src'] or b['dst'] != p['dst']:
            raise Mismatch('%s blit %d: original kind %d %s -> %s native kind %d %s -> %s' % (
                where, i, b['kind'], b['src'], b['dst'], p['kind'], p['src'], p['dst']))
        want = {0: MARK_SAVED, 1: multi, 2: src}.get(p['src_kind'], p['surface'])
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
    x.run_op(0x483fb5, [], OBJ)
    status, log = nat.simple(nat.lib.eao_cleanup)
    if status != 0:
        raise Mismatch('%s native cleanup status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['cleanups'] += 1
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = x.rs16(OBJ + 0x1c)
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        nat.lib.eao_set_entry_u32(nat.h, slot, 0x14, 0)
    x.fx = []
    x.run_op(0x4840d9, [], OBJ)
    status, log = nat.simple(nat.lib.eao_invalidate)
    if status != 0:
        raise Mismatch('%s native invalidate status %d' % (where, status))
    compare_log(where, x.fx, log)
    stats['invalidates'] += 1
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


def fuzz_pokes(ctx):
    r = ctx.rng
    st = obj_state(ctx)
    n = max(st['n'], 1)
    p = {}
    cols = struct.unpack_from('<h', st['body'], B_GRID + 2)[0] if st['body'] else 1
    if r.random() < 0.7:
        # the animation step divides by the column count: with zero columns state 3 (and 4 with the flag clear) is
        # unreachable by the game and the original would trap
        p[0xbac] = struct.pack('<i', r.choice([0, 1, 2, 3, 4, 5, 5, 6, 6, -1, 7, 0x100] if cols else [0, 1, 2, 5, 6, -1, 7]))
        if not cols:
            p[0xc2f] = struct.pack('<i', 1)
    for off in (0xbc9, 0xbcd):
        if r.random() < 0.5:
            p[off] = struct.pack('<I', r.choice([0, 1, 100, 0x7fffffff, 0x80000000, 0xffffffff, ctx.clock, (ctx.clock + 300) & 0xffffffff,
                                                 r.randrange(1 << 32)]))
    for off in (0xc2b, 0xc2f, 0xb83, 0xb87, 0xb8b, 0xb8f, 0xb93, 0xc27, 0xbc1):
        if r.random() < 0.3 and (cols or off not in (0xc2f, 0xc2b, 0xb8b)):
            p[off] = struct.pack('<i', r.choice([0, 1, 1, 2, -1]))
    for off in (0xbb0, 0xbab):
        if r.random() < 0.25:
            p[off] = bytes([r.choice([0, 1])])
    if r.random() < 0.4:
        p[0xc33] = struct.pack('<h', r.choice([0, 1, 2, 3, 5, 7, -1, 32767]))
    if r.random() < 0.4:
        p[0xc35] = struct.pack('<h', r.choice([0, 1, 2, 3, 4, 5, 6, 7, 11, 12, -1, 32767]))
    if r.random() < 0.3:
        p[0xc25] = struct.pack('<h', r.randrange(0, n + 1))
    if r.random() < 0.3:
        p[0xb21 + 0x21] = struct.pack('<h', r.randrange(-3, 40))
    if r.random() < 0.3:
        p[0xb52 + 0x21] = struct.pack('<h', r.randrange(-3, 40))
    for i in range(min(n, 20)):
        base = 0x28 + 0x85 * i
        if r.random() < 0.15:
            p[base + 0x23] = bytes([r.choice([0, 1])])
        if r.random() < 0.15:
            p[base + 0x22] = bytes([r.choice([0, 1, 2, 3])])
        if r.random() < 0.15:
            p[base] = struct.pack('<h', r.randrange(0, n + 2))
    return p


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
    ctx.nat.lib.eao_set_captions(ctx.nat.h, v)


def untilcheck(ctx, until):
    x = ctx.x
    row = obj_row(ctx)
    if until == 'idle':
        return row is not None and x.rs32(OBJ + 0xbac) == 0 and x.rs32(OBJ + 0xba7) != 0 and ctx.phase.get(row, 0) == 1
    if until == 'inactive':
        return x.rs32(OBJ + 0xba7) == 0
    if until == 'done':
        return all(ctx.complete.get(r, 0) for r in range(ctx.first, ctx.first + len(ctx.rows)))
    if until == 'phase2':
        return row is not None and ctx.phase.get(row, 0) == 2
    if until == 'phase1':
        return row is not None and ctx.phase.get(row, 0) == 1
    if until.startswith('state'):
        return x.rs32(OBJ + 0xbac) == int(until[5:])
    return False


# ---------------------------------------------------------------------------------------------
# the player: picks operations from the original's own state (the oracle never reads the native object to decide)
# ---------------------------------------------------------------------------------------------
def piece_rect(ctx, i):
    return struct.unpack('<4i', ctx.x.rd(OBJ + 0x28 + 0x85 * i + 2, 16))


def piece_flags(ctx, i):
    b = ctx.x.rd(OBJ + 0x28 + 0x85 * i, 0x85)
    return b[0x22], b[0x23]


def center(r):
    return clamp16((r[0] + r[2]) // 2), clamp16((r[1] + r[3]) // 2)


LATE = {'ticks': 'clock', 'steps': (2500, 900, 2500)}


def cycle(ctx, w, info, good, avoid=(), order=()):
    """A whole interaction: pick an unplaced piece, wait out the sound, drop it (well or badly), wait out the feedback."""
    rng, x = ctx.rng, ctx.x
    nn = info['n']
    loose = [i for i in range(nn) if not piece_flags(ctx, i)[1] and i not in avoid]
    if not loose:
        return
    i = rng.choice(loose)
    first = [j for j in order if j in loose]
    if first and rng.random() < 0.85:
        i = first[0]
    cx, cy = center(piece_rect(ctx, i))
    do_pointer(ctx, w + ' pick', cx, cy)
    do_click(ctx, w + ' pick', 0x2777 if rng.random() < 0.95 else None)
    for _ in range(3):
        if x.rs32(OBJ + 0xbac) == 0:
            break
        do_tick(ctx, w + ' wait', LATE if rng.random() < 0.8 else {'ticks': 'dl'})
    st = obj_state(ctx)
    if not (st['active'] and st['drag'] and hand_ok(st)):
        return
    pc = info['pieces'][st['hand']]
    tx, ty = center(pc['C'])
    if rng.random() < 0.3 and info['tolon']:
        tx, ty = clamp16(tx + rng.choice([-1, 1, info['tol'], -info['tol']])), clamp16(ty + rng.choice([0, 1, -1]))
    if not good:
        tx, ty = clamp16(tx + rng.choice([-90, -20, 30, 120])), clamp16(ty + rng.choice([-70, 0, 50]))
    dl, dt, dr, db = info['drop']
    px, py = (clamp16(min(max(tx, dl), dr)), clamp16(min(max(ty, dt), db))) if dr != dl and rng.random() < 0.8 else (tx, ty)
    rect = (tx - 4, ty - 4, tx + 4, ty + 4)
    do_pointer(ctx, w + ' drop', px, py, rect)
    do_pointer(ctx, w + ' drop', px, py, rect)
    do_click(ctx, w + ' drop', None)
    for _ in range(6):
        if x.rs32(OBJ + 0xbac) == 0 or ctx.stop:
            break
        do_tick(ctx, w + ' feedback', LATE if rng.random() < 0.7 else {'ticks': 'dl', 'busy': 'rand'})


def play(ctx, where, n, policy):
    x, rng = ctx.x, ctx.rng
    solve = policy.get('solve', 0.5)
    ctx.rand_default = policy.get('rand', 'rand')
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
        nn = info['n']
        if not st['drag'] and st['state'] == 0 and nn and rng.random() < policy.get('cycle', 0.18):
            cycle(ctx, w, info, rng.random() < solve, policy.get('avoid', ()), policy.get('order', ()))
            continue
        roll = rng.random()
        if roll < 0.20:
            do_tick(ctx, w, rng.choice([CLK, {'ticks': 'dl'}, {'ticks': 'dl', 'busy': 'zero'}, {'ticks': 'clock', 'steps': (900, 2500)}]))
        elif roll < 0.25:
            do_render(ctx, w)
        elif roll < 0.27:
            do_invalidate(ctx, w)
        elif roll < 0.28:
            set_captions(ctx, rng.choice([0, 1, 1, 7]))
        elif roll < 0.29:
            set_view(ctx, VIEWS[rng.choice(list(VIEWS))])
        elif st['drag']:
            if not hand_ok(st):
                do_tick(ctx, w, CLK)
                continue
            hand = st['hand']
            pc = info['pieces'][hand]
            if roll < 0.40 and rng.random() < 0.7:
                do_rotkey(ctx, w)
            elif roll < 0.85:
                good = rng.random() < solve
                C = pc['C']
                cx, cy = center(C)
                if rng.random() < 0.18:
                    # probe the clamp: the moving rectangle at, inside and outside the clip edges
                    pw, ph = x.rs16(OBJ + 0xbc5), x.rs16(OBJ + 0xbc7)
                    cl, ct, cr, cb = ctx.view[2:6]
                    side = rng.randrange(4)
                    dl = rng.choice([-2, -1, 0, 1, 2])
                    if side == 0:
                        cx = cl + dl + int(pw / 2)
                    elif side == 1:
                        cx = cr + dl - pw + int(pw / 2)
                    elif side == 2:
                        cy = ct + dl + int(ph / 2)
                    else:
                        cy = cb + dl - ph + int(ph / 2)
                    cx, cy = clamp16(cx), clamp16(cy)
                elif not good:
                    cx, cy = clamp16(cx + rng.choice([-80, -30, -9, -4, 0, 4, 9, 30, 80])), clamp16(cy + rng.choice([-60, -9, 0, 9, 60]))
                else:
                    tol = info['tol'] if info['tolon'] else 0
                    jit = rng.choice([0, 0, 0, 1, -1, tol, -tol, tol + 1, -tol - 1, tol + 2])
                    cx, cy = clamp16(cx + jit), clamp16(cy + rng.choice([0, 0, jit]))
                dl, dt, dr, db = info['drop']
                px, py = cx, cy
                if rng.random() < 0.7 and dr != dl:
                    px, py = clamp16(min(max(cx, dl), dr)), clamp16(min(max(cy, dt), db))
                rect = (cx - 4, cy - 4, cx + 4, cy + 4) if rng.random() < 0.8 else (cx - rng.randrange(0, 9), cy - rng.randrange(0, 9),
                                                                                   cx + rng.randrange(0, 9), cy + rng.randrange(0, 9))
                do_pointer(ctx, w, px, py, rect)
                do_pointer(ctx, w, px, py, rect)
                do_click(ctx, w, None if rng.random() < 0.85 else rng.choice([0x277a, 0x277b, 0x2777, 0x2778, 0x2779, 0x277c, -1, 5]))
            else:
                px, py = rng.randrange(-20, 700), rng.randrange(-20, 500)
                do_pointer(ctx, w, px, py)
                do_click(ctx, w, None if rng.random() < 0.7 else rng.choice([0x277a, 0x277b, 0x2777, 0x2778, 0x2779, 0x277c, -1]))
        else:
            if nn == 0 or roll < 0.34:
                # exit area / animation / exit button / outside
                kind = rng.choice(['anim', 'anim', 'anim', 'exit', 'out', 'rotkey'])
                if kind == 'anim' and info['exit_area'][3] != info['exit_area'][1]:
                    ex = info['exit_area']
                    do_pointer(ctx, w, clamp16(ex[0] + rng.choice([0, 1, (ex[2] - ex[0]) // 2])), clamp16(ex[1] + rng.choice([0, 1, (ex[3] - ex[1]) // 2, ex[3] - ex[1]])))
                    do_click(ctx, w)
                elif kind == 'exit' and rng.random() < policy.get('exit', 0.15):
                    ex = info['exit_rect']
                    do_pointer(ctx, w, *center(ex))
                    do_click(ctx, w)
                elif kind == 'rotkey':
                    do_rotkey(ctx, w)
                else:
                    do_pointer(ctx, w, rng.randrange(-40, 700), rng.randrange(-40, 500))
                    if rng.random() < 0.5:
                        do_click(ctx, w)
            elif roll < 0.47:
                do_rotkey(ctx, w)
            elif roll < 0.60:
                # a placed piece's rotate zone
                placed = [i for i in range(nn) if piece_flags(ctx, i)[1]]
                if placed:
                    i = rng.choice(placed)
                    r = piece_rect(ctx, i)
                    z = info['zone']
                    do_pointer(ctx, w, clamp16(r[0] + rng.choice([0, 1, z[1], z[1] + 1, -1])), clamp16(r[1] + rng.choice([0, 1, z[0], z[0] + 1, -1])))
                else:
                    do_pointer(ctx, w, rng.randrange(-10, 640), rng.randrange(-10, 480))
                do_click(ctx, w, None if rng.random() < 0.8 else rng.choice([0x2778, 0x2777, 0x277a, 0x277b]))
            else:
                loose = [i for i in range(nn) if not piece_flags(ctx, i)[1] and i not in policy.get('avoid', ())]
                if loose:
                    i = rng.choice(loose)
                    r = piece_rect(ctx, i)
                    cx, cy = center(r)
                    if rng.random() < 0.15:
                        cx, cy = clamp16(r[0] + rng.choice([-1, 0])), clamp16(r[1] + rng.choice([-1, 0]))
                    do_pointer(ctx, w, cx, cy)
                    do_click(ctx, w, None if rng.random() < 0.9 else rng.choice([0x2777, 0x2778, 0x277a, 0x277b, -1, 0x2779]))
                else:
                    do_pointer(ctx, w, rng.randrange(-10, 640), rng.randrange(-10, 480))
                    do_click(ctx, w)
        if rng.random() < policy.get('fuzz', 0.0):
            do_poke(ctx, w + ' fuzz', fuzz_pokes(ctx))


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
        seeds = [0x11111111, 0x2222, -0x3333, 0x4444, 0x55555555, 0x66666666 & 0x7fffffff, 0x77777777]
        for (a, sz), v in zip(CELLS, seeds):
            x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
        nat.set_cells(x.cells())
        x.w32(START_FLAG, 5)
        nat.lib.eao_set_world_flag(nat.h, 5)
        x.w32(G_CAND, 0)
        x.w32(G_CURSOR, 0x77)
        x.w32(G_CURSOR2, 0x88)
        nat.set_handles(x.handles)
        set_view(ctx, VIEWS[sc.get('view', 'v0')])
        set_captions(ctx, sc.get('captions', 1))
        set_texts(ctx, sc.get('texts', {}))
        for s in sc.get('busy_slots', []):
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            nat.lib.eao_set_busy_slot(nat.h, s, 1)
        nat.set_entries(x.entries())  # the engine's static table contents; the oracle compares what the handler changes
        # the power-on reset: the original 0x483f6a against ea_object_reset
        oi, ni = x.image(), nat.obj()
        if oi[0x1c:] != ni[0x1c:]:
            k = first_diff(oi[0x1c:], ni[0x1c:]) + 0x1c
            raise Mismatch('power-on reset differs at %s (+%#x): original %02x native %02x' % (field_of(k), k, oi[k], ni[k]))
        nat.set_obj(oi)  # the vtable word and the unnamed leading bytes are the constructor's
        compare_state('initial', ctx)
        for ai, act in enumerate(sc['actions']):
            where = '%s action %d %s' % (sc['id'], ai, act[0])
            kind = act[0]
            if kind == 'view':
                set_view(ctx, VIEWS[act[1]] if isinstance(act[1], str) else act[1])
            elif kind == 'clock':
                ctx.clock = CLOCKS[act[1]] if isinstance(act[1], str) else act[1]
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
                nat.lib.eao_set_world_flag(nat.h, act[1])
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
            elif kind in ('k3', 'k4', 'k5', 'k6'):
                act_known(ctx, where, kind, act[1] if len(act) > 1 else None)
            elif kind == 'refuse':  # native-only safety checks (K2/K6): refused before any effect
                do_refuse(ctx, where, act)
            else:
                raise OracleError('unknown action ' + kind)
            if ctx.stop:
                break
        if not ctx.skip_final:
            compare_state(sc['id'] + ' end', ctx)
        stats['scenarios'] += 1
    finally:
        nat.close()


def do_refuse(ctx, where, act):
    nat, stats = ctx.nat, ctx.stats
    what, body = act[1], act[2]
    if what == 'body':
        nat.set_body(7, body)
        status, why, log, res = nat.step(7, 0, 0)
        if status != 2 or log:
            raise Mismatch('%s K2 expected EA_ERR_BODY without effects, got %d (%s) / %s' % (where, status, why, log))
        stats['known_observed']['K2:' + act[3]] += 1
    elif what == 'validate':
        st = nat.lib.eao_validate(cbuf(body), len(body))
        if st != 2:
            raise Mismatch('%s K2 expected EA_ERR_BODY for a short body, got %d' % (where, st))
        stats['known_observed']['K2:' + act[3]] += 1
    else:
        raise OracleError('unknown refusal ' + what)


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


def sweep_points(info, rng=None, extra=0):
    pts = []
    rects = [info['exit_area'], info['exit_rect'], info['drop'], info['area'], info['anim_area']]
    for p in info['pieces']:
        rects += [p['C'], p['D']]
    for r in rects:
        l, t, rr, b = r
        for p in ((l, t), (rr, b), (l - 1, t), (l, t - 1), (rr + 1, b), (rr, b + 1), ((l + rr) // 2, (t + b) // 2), (l, b), (rr, t)):
            pts.append((clamp16(p[0]), clamp16(p[1])))
    z = info['zone']
    for p in info['pieces']:
        l, t = p['D'][0], p['D'][1]
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


def rand_body(rng, n=None, **ov):
    n = rng.choice([0, 1, 2, 3, 4, 5, 5, 6, 8, 10, 20]) if n is None else n
    area = ov.pop('area', rng.choice([(0, 0, 639, 479), (0, 0, 639, 479), (20, 20, 600, 440), (100, 100, 400, 330)]))
    kw = dict(n=n, area=area, board=area, rot=rng.choice([0, 1, 1]), rotlock=rng.choice([0, 0, 1]), flag23=rng.choice([0, 0, 1]),
              zone=(rng.choice([0, 6, 10, 20]), rng.choice([0, 8, 12, 30])), tol=(rng.choice([0, 1, 1]), rng.choice([0, 1, 3, 8, -2])),
              ordered=rng.choice([0, 0, 1]))
    if kw['ordered'] and rng.random() < 0.7:
        order = list(range(1, n + 1))
        if rng.random() < 0.4:
            rng.shuffle(order)
        kw['order'] = order
    if rng.random() < 0.35:
        lay = list(range(1, n + 1))
        rng.shuffle(lay)
        if rng.random() < 0.3 and n > 1:
            lay[rng.randrange(n)] = rng.randrange(0, 22)
        kw['layer'] = lay
    kw['drop'] = rng.choice([(0, 0, 0, 0), (0, 0, 0, 0), area, (50, 50, 560, 400), (0, 0, 300, 300)])
    kw['anim_name'] = rng.choice([b'', b'NO_FILE', b'ANIMSRC', b'ANIMSRC'])
    kw['anim_area'] = rng.choice([(0, 0, 0, 0), (560, 20, 619, 79), (560, 20, 619, 20), (300, 20, 361, 120)])
    kw['exit_area'] = rng.choice([(0, 0, 0, 0), (560, 20, 619, 79), (500, 300, 620, 460), (10, 10, 100, 60), (560, 20, 619, 20), (0, 0, 0, 40)])
    kw['grid'] = (rng.randrange(1, 5), rng.randrange(1, 5), rng.randrange(0, 40), rng.randrange(0, 40), rng.randrange(0, 4), rng.randrange(1, 5))
    names = [b'NO SOUND', b'NO SOUND', b'SFX_A', b'SFX_B', b'S' * 32, b'NO SOUNDS', b'NO SOUND ']
    kw['sounds'] = {k: rng.choice(names) for k in SND}
    kw['alts'] = {k: (rng.choice(names), rng.choice(names)) for k in ALT}
    keys = [b'', b'KEY_A', b'KEY_B', b'KEY_C', b'K' * 32]
    tx = [b'', b'Good job', b'Nope', txt(rng, 60), txt(rng, 199)]
    kw['keys'] = {k: [rng.choice(keys) for _ in range(3)] for k in KEYS}
    kw['texts'] = {k: [rng.choice(tx) for _ in range(3)] for k in TEXTS}
    kw['chans'] = {k: rng.randrange(-2, 40) for k in SND}
    kw['cursors'] = (rng.randrange(0, 12), rng.randrange(0, 12))
    kw['win'] = scene_block(rng.choice([9999, 4377, 1, 0]), tuple(rng.randrange(-5, 99) for _ in range(3)),
                            tuple(rng.randrange(-1000, 1000) for _ in range(3)), rng.choice([0, 1, 2]),
                            rng.choice([-1, -1, 5, 100, 4095, 0]), rng.randrange(256))
    kw['exit_'] = scene_block(rng.choice([9999, 4366, 2]), tuple(rng.randrange(-5, 99) for _ in range(3)),
                              tuple(rng.randrange(-1000, 1000) for _ in range(3)), rng.choice([0, 1, 2]),
                              rng.choice([-1, -1, 7, 4095]), rng.randrange(256))
    kw['exit_rect'] = rng.choice([(560, 420, 620, 460), (0, 0, 40, 30), (300, 200, 301, 201)])
    kw.update(ov)
    return make_body(rng, **kw)


def rand_texts(rng, body):
    """AUTOTEXT answers for a random subset of the body's keys."""
    out = {}
    for off, cnt in ((KEYS['good'], 3), (KEYS['bad'], 3), (KEYS['win'], 1)):
        for j in range(cnt):
            key = cstr(body[off + 0x21 * j:off + 0x21 * j + 0x21])
            if key and rng.random() < 0.6:
                out[key] = rng.choice([b'', b'Auto text', txt(rng, 60), txt(rng, 150), txt(rng, 199)])
    return out


def good_body(rng, n=5, **ov):
    """A body the player can finish: names for every sound, an animation area and an exit area."""
    kw = dict(n=n, sounds={'pick': b'SFX_P', 'drop': b'SFX_D', 'good': b'SFX_G', 'bad': b'SFX_B', 'win': b'SFX_W', 'rot': b'SFX_R',
                           'anim': b'SFX_A', 'done': b'SFX_N'},
              keys={'good': [b'KEY_G0', b'KEY_G1', b''], 'bad': [b'KEY_B0', b'', b'KEY_B2'], 'win': [b'KEY_W']},
              texts={'good': [b'Fine', b'', b'Great'], 'bad': [b'', b'Wrong', b'Hmm'], 'win': [b'You win']},
              anim_name=b'ANIMSRC', anim_area=(560, 20, 619, 79), exit_area=(560, 100, 619, 160), drop=(0, 0, 639, 479))
    kw.update(ov)
    return rand_body(rng, **kw)


# dependency tails in the real records' shape (opcode 15: another row's state, opcode 2: an event flag)
TAIL_SEQ = struct.pack('<8h', 15, 0, 2, 0, 0, 0, 0, 0) + struct.pack('<8h', 2, 1429, 0, 0, 0, 0, 0, 0)
TAIL_EV = struct.pack('<8h', 2, 1984, 1, 0, 0, 0, 0, 0)


def scenario_list(seed=45):
    scs = []
    CL = [x for x in corpus_rows()]
    # -- the six corpus bodies ---------------------------------------------------------------------------------
    for k, row in enumerate(CL):
        info = parse(row['body'])
        ev = sat_events(row['tail'])
        acts = [('tick', CLK), ('render',), ('invalidate',)]
        acts += [('ptr',) + p for p in sweep_points(info, random.Random(k), 20)]
        acts += [('play', 220, dict(solve=0.8, fuzz=0.0)), ('run', {'ticks': 'dl'}, 'done', 30)]
        S(scs, 'corpus:%d' % k, [R(row['body'], row['subtype'], row['tail'])], acts, 'corpus', quick=(k == 0), seed=100 + k, events=ev,
          view=['v0', 'v1', 'neg', 'tight', 'v0', 'v1'][k], texts=rand_texts(random.Random(k), row['body']))
        S(scs, 'corpus:%d:play2' % k, [R(row['body'], row['subtype'], row['tail'])],
          [('tick', CLK), ('play', 260, dict(solve=0.95, fuzz=0.02, exit=0.05)), ('run', {'ticks': 'dl'}, 'done', 40)], 'corpus', seed=200 + k,
          events=ev, captions=[1, 0, 1, 1, 0, 1][k])
    # pairs per scene: the second row is gated until the first has stored its flag (real dependency tails)
    for res in sorted({r['resource'] for r in CL}):
        rows = [r for r in CL if r['resource'] == res]
        ev = sat_events(rows[0]['tail'])
        for v, e in (('open0', ev), ('closed', {})):
            S(scs, 'corpus:scene%d:%s' % (res, v), [R(r['body'], r['subtype'], r['tail']) for r in rows],
              [('tick', CLK), ('play', 120, dict(solve=0.9)), ('run', {'ticks': 'dl'}, 'done', 25),
               ('events', sat_events(rows[1]['tail'])), ('run', {'ticks': 'dl'}, 'done', 25), ('play', 120, dict(solve=0.9)),
               ('run', {'ticks': 'dl'}, 'done', 25)],
              'corpus', seed=300 + res, events=e)
    # -- phase 0 matrix ------------------------------------------------------------------------------------------
    rng = random.Random(seed)
    for n in (0, 1, 2, 5, 20):
        for rot, lock in ((0, 0), (1, 0), (1, 1)):
            for flag23 in (0, 1):
                body = good_body(rng, n=n, rot=rot, rotlock=lock, flag23=flag23)
                info = parse(body)
                acts = [('tick', CLK), ('render',), ('invalidate',)]
                acts += [('ptr',) + p for p in sweep_points(info, rng, 6)]
                acts += [('play', 60, dict(solve=0.6, fuzz=0.02)), ('cleanup', 'keep'), ('revive',), ('tick', CLK), ('render',),
                         ('play', 30, {})]
                S(scs, 'phase0:n%d:r%d%d:f%d' % (n, rot, lock, flag23), [R(body)], acts, 'phase0', quick=(n == 5 and rot == 1 and lock == 0 and flag23 == 0),
                  seed=rng.randrange(1 << 30), texts=rand_texts(rng, body), view=rng.choice(list(VIEWS)))
    # rect B valid / zero, loose pieces, start orientations 1..3, layer table on / off, size extremes
    for variant in range(12):
        n = 6
        pcs = default_pieces(rng, n, (0, 0, 639, 479))
        for i, p in enumerate(pcs):
            w, h = p['A'][2] - p['A'][0] + 1, p['A'][3] - p['A'][1] + 1
            if variant % 3 == 0:
                p['B'] = (0, 0, 0, 0)
            elif variant % 3 == 1:
                p['B'] = (p['A'][0] + 5, p['A'][1] + 5, p['A'][0] + 5 + w, p['A'][1] + 5 + h)
            else:
                p['B'] = (0, 7, 0, 9) if i % 2 else (4, 0, 9, 0)  # degenerate B (one edge pair equal) -> invalid
            p['loose'] = int(variant >= 6 and i % 2 == 0)
            p['orient'] = (variant + i) % 4
        body = good_body(rng, n=n, pieces=pcs, rot=variant % 2, rotlock=0, layer=(list(range(n, 0, -1)) if variant % 4 == 3 else None))
        S(scs, 'pieces:%d' % variant, [R(body)], [('tick', CLK), ('render',), ('play', 70, dict(solve=0.6, fuzz=0.02))], 'phase0',
          seed=rng.randrange(1 << 30), texts=rand_texts(rng, body))
    # animation names and grids
    for k, an in enumerate((b'', b'NO_FILE', b'NO_FILEX', b'ANIM1')):
        for ar in ((0, 0, 0, 0), (560, 20, 619, 79)):
            body = good_body(rng, n=3, anim_name=an, anim_area=ar)
            S(scs, 'anim:%d:%d' % (k, ar[3]), [R(body)], [('tick', CLK), ('render',), ('play', 50, {}), ('run', CLK, 'idle', 3)], 'phase0',
              seed=rng.randrange(1 << 30))
    for cols in range(1, 5):
        for rows_ in range(1, 5):
            for rep in (1, 3):
                body = good_body(rng, n=2, grid=(rows_, cols, 3, 9, cols % 3, rep), anim_area=(300, 20, 359, 79))
                ex = parse(body)['exit_area']
                acts = [('tick', CLK)]
                for _ in range(3 if cols * rows_ * rep < 6 else 2):
                    acts += [('ptr', (ex[0] + ex[2]) // 2, (ex[1] + ex[3]) // 2), ('click',), ('run', {'ticks': 'dl', 'busy': 'rand'}, 'idle', 40), ('render',)]
                S(scs, 'grid:%dx%dx%d' % (cols, rows_, rep), [R(body)], acts, 'anim', quick=(cols == 2 and rows_ == 2 and rep == 3),
                  seed=rng.randrange(1 << 30))
    # -- sounds, captions, alternates and the re-roll paths -------------------------------------------------------
    for k in range(10):
        alts = {kk: (rng.choice([b'NO SOUND', b'ALT_A']), rng.choice([b'NO SOUND', b'ALT_B'])) for kk in ALT}
        body = good_body(rng, n=3, alts=alts, tol=(0, 0), drop=(0, 0, 0, 0))
        rands = [[1, 0, 2, 5, 1, 2], [2, 2, 2, 1, 4, 7], [0], [4, 5, 8, 11, 3], [1, 1, 1, 1, 2], [2], [7, 8, 2, 0], [32767, 16383, 16384], [1, 2], [2, 1, 0]][k]
        acts = [('tick', CLK), ('play', 140, dict(solve=0.7, rand=rands, fuzz=0.0))]
        S(scs, 'sound:%d' % k, [R(body)], acts, 'sound', seed=rng.randrange(1 << 30), texts=rand_texts(rng, body), captions=k % 3 != 0)
    for k, (found, tlen, cap) in enumerate(((True, 10, 1), (True, 199, 1), (False, 0, 1), (True, 0, 1), (False, 0, 0), (True, 40001, 1))):
        body = good_body(rng, n=3, drop=(0, 0, 0, 0))
        texts = {b'KEY_G0': txt(rng, tlen), b'KEY_G1': txt(rng, tlen), b'KEY_B0': txt(rng, tlen), b'KEY_B2': txt(rng, tlen),
                 b'KEY_W': txt(rng, tlen)} if found else {}
        S(scs, 'caption:%d' % k, [R(body)], [('tick', CLK), ('play', 450, dict(solve=0.5, tick={'ticks': 'dl'}))], 'sound', seed=rng.randrange(1 << 30), texts=texts,
          captions=cap, quick=(k == 0))
    # -- finish: win and exit blocks ----------------------------------------------------------------------------------
    for k, (wsc, wflag, wstart, esc, eflag, estart) in enumerate((
            (9999, -1, 0, 9999, -1, 0), (4377, 1984, 0, 4366, -1, 1), (4377, -1, 1, 4366, 7, 0), (9999, 12, 2, 9999, 4095, 1),
            (5, 0, 1, 6, 0, 2), (5, 4095, 0, 6, -1, 1))):
        body = good_body(rng, n=3, win=scene_block(wsc, (1, 2, 3), (4, 5, 6), wstart, wflag, 77),
                         exit_=scene_block(esc, (-7, 8, 9), (-10, 11, 12), estart, eflag, 33), exit_rect=(300, 400, 360, 440))
        info = parse(body)
        win = [('tick', CLK), ('play', 150, dict(solve=1.0, exit=0.0)), ('run', {'ticks': 'dl'}, 'done', 40)]
        S(scs, 'finish:win:%d' % k, [R(body)], win, 'finish', quick=(k == 1), seed=rng.randrange(1 << 30))
        ex = [('tick', CLK), ('play', 20, dict(solve=0.4, exit=0.0)), ('ptr',) + center(info['exit_rect']), ('click',),
              ('run', {'ticks': 'dl'}, 'done', 10)]
        S(scs, 'finish:exit:%d' % k, [R(body)], ex, 'finish', seed=rng.randrange(1 << 30))
    # ordered mode with matching and non matching lists
    for k in range(4):
        n = 4
        order = [[1, 2, 3, 4], [4, 3, 2, 1], [1, 3, 2, 4], [2, 2, 2, 2]][k]
        body = good_body(rng, n=n, ordered=1, order=order, tol=(0, 0))
        S(scs, 'ordered:%d' % k, [R(body)], [('tick', CLK), ('play', 160, dict(solve=0.9)), ('run', {'ticks': 'dl'}, 'done', 30)], 'finish',
          seed=rng.randrange(1 << 30))
    # tolerance values
    for k, tol in enumerate(((0, 0), (0, 9), (1, 0), (1, 1), (1, 5), (1, -3), (1, 30))):
        body = good_body(rng, n=3, tol=tol, drop=(0, 0, 639, 479) if k % 2 else (0, 0, 0, 0))
        S(scs, 'tolerance:%d' % k, [R(body)], [('tick', CLK), ('play', 120, dict(solve=0.8))], 'drag', seed=rng.randrange(1 << 30),
          texts=rand_texts(rng, body))
    # -- multiple rows, gates, cleanup, fatal paths, ticks that wrap ----------------------------------------------------------
    b1, b2 = good_body(rng, n=3), good_body(rng, n=4, win=scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 1984, 1))
    t2 = TAIL_SEQ  # the second row opens when the first row has completed
    S(scs, 'multi:sequential', [R(b1), R(b2, tail=t2)],
      [('tick', CLK), ('play', 100, dict(solve=1.0)), ('run', {'ticks': 'dl'}, 'phase2', 40), ('run', {'ticks': 'dl'}, 'done', 12),
       ('tick', CLK), ('play', 150, dict(solve=1.0)), ('run', {'ticks': 'dl'}, 'done', 40)], 'multi', seed=7,
      texts=rand_texts(rng, b1))
    S(scs, 'multi:overlap(K1)', [R(b1), R(b2)], [('tick', CLK), ('tick', CLK)], 'known', known='K1', seed=8)
    S(scs, 'multi:gate', [R(b1, tail=TAIL_EV)], [('tick', CLK), ('tick', CLK), ('events', {1984: 1}), ('tick', CLK), ('play', 40, {})], 'multi', seed=9)
    S(scs, 'multi:mode', [R(b1)], [('mode', 1), ('tick', CLK), ('mode', 3), ('tick', CLK), ('play', 40, {})], 'multi', seed=10)
    S(scs, 'multi:first1', [R(b1), R(b2)], [('tick', CLK), ('play', 40, {})], 'multi', first=2, seed=11, known='K1')
    S(scs, 'fatal:slots', [R(b1)], [('tick', CLK)], 'known', busy_slots=list(range(0x18, 0x40)), expect_fatal=0x52139c, seed=12)
    S(scs, 'slots:some', [R(b1)], [('tick', CLK), ('render',), ('invalidate',), ('play', 30, {}), ('cleanup', 'keep'), ('invalidate',),
                                   ('render',)], 'multi', busy_slots=[0x18, 0x19, 0x1a, 0x3f], seed=13)
    for name, start in (('low', 'low'), ('wrap', 'wrap'), ('top', 'top'), ('sign', 'sign'), ('mid', 'mid')):
        S(scs, 'clock:%s' % name, [R(b1)], [('clock', start), ('tick', CLK), ('play', 120, dict(solve=0.8, tick={'ticks': 'dl'}))], 'multi', seed=14,
          texts=rand_texts(rng, b1))
    S(scs, 'cleanup:phase', [R(b1)], [('tick', CLK), ('cleanup', 'keep'), ('invalidate',), ('revive',), ('tick', CLK), ('play', 30, {}),
                                      ('cleanup',), ('invalidate',), ('render',)], 'multi', seed=15)
    # abutting piece rectangles (layer assignment) and one-sided / zero targets (solved check)
    grid = [(100, 100, 149, 149), (149, 100, 198, 149), (100, 149, 149, 198), (150, 150, 199, 199), (199, 199, 240, 240), (60, 100, 100, 100)]
    for k in range(4):
        pcs = [dict(A=(10 + 60 * i, 10, 59 + 60 * i, 59), B=(0, 0, 0, 0), C=grid[i], D=(300 + 10 * i, 300, 349 + 10 * i, 349), orient=0, loose=0)
               for i in range(6)]
        body = good_body(rng, n=6, pieces=pcs, tol=(0, 0), layer=None, drop=(0, 0, 639, 479), rot=k % 2, rotlock=0, area=(0, 0, 639, 479))
        order = [[1, 0, 4, 3, 2, 5], [4, 3, 5, 2, 1, 0], [0, 1, 3, 4, 5, 2], [5, 2, 3, 0, 4, 1]][k]
        S(scs, 'overlap:%d' % k, [R(body)], [('tick', CLK), ('play', 200, dict(solve=1.0, exit=0.0, cycle=0.7, order=order)), ('run', {'ticks': 'dl'}, 'done', 30)],
          'drag', seed=rng.randrange(1 << 30), view=['v0', 'v1', 'neg', 'tight'][k])
    for k, c2 in enumerate(((300, 40, 340, 0), (300, 0, 340, 60), (0, 0, 0, 0), (300, 40, 340, 60))):
        pcs = [dict(A=(10 + 60 * i, 10, 59 + 60 * i, 59), B=(0, 0, 0, 0), C=(100 + 80 * i, 100, 149 + 80 * i, 149), D=(300 + 10 * i, 300, 349 + 10 * i, 349),
                    orient=0, loose=0) for i in range(3)]
        pcs[2]['C'] = c2
        body = good_body(rng, n=3, pieces=pcs, tol=(0, 0), layer=None, drop=(0, 0, 639, 479), rot=0, rotlock=0,
                         exit_area=(560, 100, 619, 160) if k % 2 == 0 else (0, 0, 0, 0))
        S(scs, 'decoy:%d' % k, [R(body)], [('tick', CLK), ('play', 260, dict(solve=1.0, exit=0.0, avoid=(2,))), ('run', {'ticks': 'dl'}, 'done', 30)],
          'finish', seed=rng.randrange(1 << 30), quick=(k == 0))
    # bad drops with AUTOTEXT hits, the caption cleared after the feedback sound
    for k, rands in enumerate(([0], [2, 0], [1], [2, 2, 2, 1], [0, 2, 1, 2, 0])):
        body = good_body(rng, n=3, tol=(0, 0), drop=(0, 0, 639, 479))
        texts = {b'KEY_B0': b'bad zero', b'KEY_B2': txt(rng, 150), b'KEY_G0': b'good zero', b'KEY_G1': txt(rng, 199), b'KEY_W': b'win'}
        S(scs, 'captionbad:%d' % k, [R(body)], [('tick', CLK), ('play', 150, dict(solve=0.0 if k < 3 else 0.4, rand=rands, tick={'ticks': 'dl'}))],
          'sound', seed=rng.randrange(1 << 30), texts=texts, captions=1)
    # -- native safety layer (expected differences) ------------------------------------------------------------------
    good = good_body(rng, n=3)
    bad = []
    g = bytearray(good)
    struct.pack_into('<h', g, B_COUNT, 21)
    bad.append(('piece_count_21', bytes(g)))
    g = bytearray(good)
    struct.pack_into('<h', g, B_COUNT, -1)
    bad.append(('piece_count_neg', bytes(g)))
    g = bytearray(good)
    g[B_PIECES:B_PIECES + 16] = rect_bytes((5, 5, 3, 3))
    g[B_PIECES + 0x10:B_PIECES + 0x20] = bytes(16)
    bad.append(('piece_size_zero', bytes(g)))
    g = bytearray(good)
    g[B_NAME:B_NAME + 0x21] = b'x' * 0x21
    bad.append(('name_unterminated', bytes(g)))
    g = bytearray(good)
    g[TEXTS['good']:TEXTS['good'] + 200] = b'y' * 200
    bad.append(('text_unterminated', bytes(g)))
    g = bytearray(good)
    struct.pack_into('<h', g, B_GRID + 2, 0)
    bad.append(('grid_columns_zero', bytes(g)))
    acts = [('refuse', 'body', b, k) for k, b in bad] + [('refuse', 'validate', good[:BODY_LEN - 1], 'short'), ('refuse', 'validate', b'', 'empty')]
    S(scs, 'known:K2', [R(good)], acts, 'known', seed=16)
    S(scs, 'known:K3', [R(good_body(rng, n=3, drop=(0, 0, 639, 479), rot=1, rotlock=0))],
      [('tick', CLK), ('play', 40, dict(solve=0.5)), ('k3',)], 'known', seed=17)
    S(scs, 'known:K4', [R(good_body(rng, n=2, win=scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 5000, 1)))], [('tick', CLK), ('k4',)], 'known', seed=18)
    S(scs, 'known:K5', [R(good)], [('k5',)], 'known', seed=19)
    S(scs, 'known:K6', [R(good_body(rng, n=3, texts={'good': [txt(rng, 199)] * 3, 'bad': [b''] * 3, 'win': [b'']}))],
      [('tick', CLK), ('k6', txt(rng, 260))], 'known', seed=20)
    # FL-15: the pointer lists every piece whose rotate zone holds it, and a rotate click calls the original 0x484622 (top piece of
    # that list). Pre-placed (loose) overlapping pieces take their layer from the body's table. Scenarios 0 and 3 make the loop
    # replace the best piece; the others keep the first entry (a smaller layer, or all layers equal).
    for k, lay in enumerate(([1, 2, 3], [3, 2, 1], [2, 3, 1], [1, 3, 2], None, [2, 1, 3])):
        pcs = [dict(A=(10 + 60 * i, 10, 59 + 60 * i, 59), B=(0, 0, 0, 0), C=(100 + 3 * i, 100 + 2 * i, 149 + 3 * i, 149 + 2 * i),
                    D=(300 + 80 * i, 300, 349 + 80 * i, 349), orient=0, loose=int(k != 5 or i < 2)) for i in range(3)]
        body = good_body(rng, n=3, pieces=pcs, tol=(0, 0), layer=None if lay is None else lay + [0] * 17, drop=(0, 0, 639, 479), rot=1,
                         rotlock=1, area=(0, 0, 639, 479), zone=(10, 12))
        S(scs, 'rotate:placed%d' % k, [R(body)],
          [('tick', CLK), ('ptr', 106, 106), ('click',), ('tick', CLK), ('play', 10, dict(solve=1.0, cycle=0.0)), ('ptr', 104, 104),
           ('click',), ('play', 10, dict(solve=1.0, cycle=0.0))], 'rotate', seed=900 + k)
    return scs


def random_scenarios(count, seed=4545):
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
          events={} if not two else {})
    return scs


# ---------------------------------------------------------------------------------------------
# native-only safety checks (expected differences)
# ---------------------------------------------------------------------------------------------
def act_known(ctx, where, kind, arg=None):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    ri = active_ri(ctx)
    if kind == 'k3':
        do_poke(ctx, where, {0xa92: struct.pack('<i', 1), 0xa9e: struct.pack('<h', -1), 0xbac: struct.pack('<i', 0), 0xbb0: b'\0',
                             0xbf9: struct.pack('<h', 1)})
        ctx.phase[ri] = 1
        x.w32(ROWS + ri * ROW + PHASE_OFF, 1)
        do_pointer(ctx, where + ' ptr', 10, 10)
        do_click(ctx, where + ' drop good', 0x277b)
        do_click(ctx, where + ' drop bad', 0x277a)
        do_rotkey(ctx, where + ' rotkey')
        do_render(ctx, where + ' render')
        if stats['known_observed']['K3:pointer'] < 1 or stats['known_observed']['K3:click'] < 2 or stats['known_observed']['K3:rotkey'] < 1:
            raise Mismatch('%s K3 refusals not observed: %s' % (where, dict(stats['known_observed'])))
    elif kind == 'k4':
        do_poke(ctx, where, {0xbb0: b'\1'})
        st, why, log, res = nat.step(ri, ri, 2)
        if st != 6 or log:
            raise Mismatch('%s K4 expected EA_ERR_BOUNDS without effects, got %d (%s) / %s' % (where, st, why, log))
        stats['known_observed']['K4'] += 1
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k5':
        nat.set_body(0, ctx.rows[0]['body'])
        for ph in (1, 2):
            st, why, log, res = nat.step(0, 0, ph)
            if st != 3 or log:
                raise Mismatch('%s K5 expected EA_ERR_UNSUPPORTED without effects, got %d (%s) / %s' % (where, st, why, log))
            stats['known_observed']['K5:phase%d' % ph] += 1
        ctx.skip_final = True
        ctx.stop = True
    elif kind == 'k6':
        img = bytearray(nat.obj())
        struct.pack_into('<i', img, 0xbac, 1)
        struct.pack_into('<i', img, 0xb87, 1)
        struct.pack_into('<i', img, 0xb83, 1)
        struct.pack_into('<I', img, 0xbc9, 0)
        nat.set_obj(bytes(img))
        nat.set_texts({b'KEY_G0': arg, b'KEY_G1': arg})
        nat.set_queues([1 << 30] * 4, [0] * 4, [0] * 24)
        st, why, log, res = nat.step(ri, ri, 1)
        if st != 6 or any(k == LOGKINDS['CAPTION'] for k, _, _ in log):
            raise Mismatch('%s K6 expected EA_ERR_BOUNDS without a caption, got %d (%s)' % (where, st, why))
        stats['known_observed']['K6'] += 1
        ctx.skip_final = True
        ctx.stop = True


# ---------------------------------------------------------------------------------------------
# mutation check
# ---------------------------------------------------------------------------------------------
MUTANTS = {
    'deadline_pick_drop_300': ('now(host) + 300u', 'now(host) + 301u'),
    'deadline_feedback_2000': ('now(host) + 2000u', 'now(host) + 1999u'),
    'deadline_done_800_idle': ('now(host) + 800u', 'now(host) + 799u', 0),
    'deadline_done_800_animend': ('now(host) + 800u', 'now(host) + 801u', 1),
    'deadline_anim_100_idle': ('now(host) + 100u', 'now(host) + 101u', 0),
    'deadline_anim_100_wait': ('now(host) + 100u', 'now(host) + 99u', 1),
    'compare_drop_wait_le': ('if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;\n        HOST(host->sound_stop',
                             'if (now(host) <= (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;\n        HOST(host->sound_stop'),
    'feedback_busy_or': ('if (busy != 0 && now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;',
                         'if (busy != 0 || now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;'),
    'wait_compare_le': ('if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE2)) return EA_OK;',
                        'if (now(host) <= (uint32_t)rd_s32(obj, O_DEADLINE2)) return EA_OK;'),
    'skipped_piece_sound_play': ('HOST(host->sound_play(host->context, rd_s16(obj, O_CHAN_B)));', ';'),
    'caption_suffix_dropped': ('memcpy(buf + n, "<e>", 4);', 'memcpy(buf + n, "", 1);'),
    'top_piece_z_compare': ('rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)',
                            'rd_s16(obj, piece_off(best) + P_Z) <= rd_s16(obj, piece_off(cand) + P_Z)'),
    'rotation_wrap_at_3': ('if (obj[P + P_ORIENT] == 4) obj[P + P_ORIENT] = 0;', 'if (obj[P + P_ORIENT] == 3) obj[P + P_ORIENT] = 0;'),
    'tolerance_sign': ('sub32(rd_s32(body, bp + BP_RECT_C + 4), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV + 4)',
                       'add32(rd_s32(body, bp + BP_RECT_C + 4), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV + 4)'),
    'tolerance_edge_bottom': ('rd_s32(obj, O_PREV + 12) <= add32(', 'rd_s32(obj, O_PREV + 12) < add32('),
    'clamp_top_off_by_one': ('if (rd_s32(obj, off + 4) < v.clip[1]) {', 'if (rd_s32(obj, off + 4) < v.clip[1] - 1) {'),
    'clamp_right_off_by_one': ('if (v.clip[2] < rd_s32(obj, off + 8)) {', 'if (v.clip[2] + 1 < rd_s32(obj, off + 8)) {'),
    'clamp_bottom_off_by_one': ('if (v.clip[3] < rd_s32(obj, off + 12)) {', 'if (v.clip[3] + 1 < rd_s32(obj, off + 12)) {'),
    'clamp_left_uses_top': ('wr_32(obj, off, v.clip[0]);', 'wr_32(obj, off, v.clip[1]);'),
    'entry_surface_height': ('add32(sub32(rd_s32(obj, ent + ENT_RECT + 4), 1), h)', 'add32(sub32(rd_s32(obj, ent + ENT_RECT + 4), 1), h + 1)'),
    'rotated_entry_size_kept': ('w = rw;', ';'),
    'drop_does_not_wait': ('if (is_pick || is_drop) wr_32(obj, O_STATE, EA_STATE_DROP_WAIT);',
                           'if (is_pick) wr_32(obj, O_STATE, EA_STATE_DROP_WAIT);'),
    'feedback_state_transition': ('wr_32(obj, O_STATE, EA_STATE_FEEDBACK);\n    if (good)', 'wr_32(obj, O_STATE, EA_STATE_DROP_WAIT);\n    if (good)'),
    'alternate_one_takes_two': ('copy_name(obj, to, body, alt1);', 'copy_name(obj, to, body, alt2);'),
    'no_sound_compares_eight': ('return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8) == 0;', 1),
    'no_file_compares_seven': ('return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 7) == 0;', 0),
    'solved_top_test_inverted': ('if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 4) != 0) return;', 'if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 4) == 0) return;'),
    'solved_bottom_test_dropped': ('if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 12) != 0) return;', ';'),
    'inside_area_bottom_edge': ('rd_s32(body, B_AREA + 12) < rd_s32(obj, off + 12)', 'rd_s32(body, B_AREA + 12) <= rd_s32(obj, off + 12)'),
    'exit_click_keeps_phase': ('*new_phase = 2u;', '*new_phase = 1u;'),
    'start_flag_word_inverted': ('world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 0 ? 1 : 0;'),
    'event_flag_value_off_by_one': ('host->store_event_flag(host->context, flag, blk[SB_VALUE])', 'host->store_event_flag(host->context, flag, blk[SB_VALUE] + 1u)'),
    'placed_list_threshold': ('if (rd_s16(obj, O_COUNT_PLACED) != 0) {', 'if (rd_s16(obj, O_COUNT_PLACED) > 1) {'),
    'exit_area_right_edge': ('(int32_t)x < rd_s32(body, B_EXIT_AREA + 8)', '(int32_t)x <= rd_s32(body, B_EXIT_AREA + 8)'),
    'exit_rect_right_edge': ('(int32_t)x <= rd_s32(body, B_EXIT_RECT + 8)', '(int32_t)x < rd_s32(body, B_EXIT_RECT + 8)'),
    'rotate_cursor_index': ('out->cursor = 0x14;', 'out->cursor = 0x15;'),
    'anim_cell_column': ('frame % (int32_t)cols', 'frame / (int32_t)cols'),
    'rotate_centre_half': ('(int32_t)sw / 2);', '(int32_t)sw / 2 + 1);'),
    'layer_increment': ('wr_16(obj, P + P_Z, (int16_t)(rd_s16(obj, P + P_Z) + 1));', 'wr_16(obj, P + P_Z, (int16_t)(rd_s16(obj, P + P_Z) + 2));'),
    'overlap_left_edge': ('if (ar < bl) return 0;', 'if (ar <= bl) return 0;'),
    'good_drop_exit_area_skips_check': ('if (rd_s32(obj, O_EXIT_AREA) != 0) return EA_OK;\n            check_solved', 'if (rd_s32(obj, O_EXIT_AREA) == 0) return EA_OK;\n            check_solved'),
    'caption_flag_not_set': ('if (flag_on_show) wr_32(obj, O_CAPTION, 1);', ';', 0),
    'autotext_length_limit': ('strlen(t) < 0x9c41u', 'strlen(t) < 0x9c42u', 0),
    'feedback_busy_channel': ('HOST(host->sound_busy(host->context, rd_s16(obj, O_CHAN_A), &busy));', 'HOST(host->sound_busy(host->context, rd_s16(obj, O_CHAN_B), &busy));'),
    'render_dragged_piece_kind': ('plan_blit(plan, 1, 3, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 'plan_blit(plan, 0, 3, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', 0),
    'loose_piece_orientation': ('HOST(translate(obj, P + P_RECT, P + P_RECT2, host));\n        obj[P + P_ORIENT] = 0;', 'HOST(translate(obj, P + P_RECT, P + P_RECT2, host));\n        obj[P + P_ORIENT] = 1;'),
    'exit_area_flag_edge': ('wr_32(obj, O_EXIT_AREA, rd_s32(body, B_EXIT_AREA + 12) != rd_s32(body, B_EXIT_AREA + 4));', 'wr_32(obj, O_EXIT_AREA, rd_s32(body, B_EXIT_AREA + 8) != rd_s32(body, B_EXIT_AREA + 4));'),
    'ordered_compares_piece_index': ('== (int32_t)cur + 1))', '== (int32_t)cur))'),
    'flag23_inverted': ('if (body[B_FLAG23] == 0) {', 'if (body[B_FLAG23] != 0) {'),
}


def mutation_check(args, workdir):
    source = (args.src / 'action_family_ea_runtime.c').read_text()
    jobs = []
    for i, (name, spec) in enumerate(MUTANTS.items()):
        old, new = spec[0], spec[1]
        occ = spec[2] if len(spec) > 2 else None
        if (occ is None and source.count(old) != 1) or (occ is not None and source.count(old) <= occ):
            jobs.append((name, None, 'mutation anchor drifted (%d matches)' % source.count(old)))
            continue
        d = Path(workdir) / ('mut%02d' % i)
        d.mkdir(parents=True, exist_ok=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        if occ is None:
            mutated = source.replace(old, new)
        else:
            pos = -1
            for _ in range(occ + 1):
                pos = source.index(old, pos + 1)
            mutated = source[:pos] + new + source[pos + len(old):]
        (d / 'action_family_ea_runtime.c').write_text(mutated)
        try:
            lib_path = build_driver(d, d / 'libmut.so')
        except OracleError as error:
            jobs.append((name, None, 'mutant does not build: ' + str(error)[:160]))
            continue
        jobs.append((name, lib_path, None))

    def run(job):
        name, lib_path, err = job
        if err:
            return dict(mutant=name, detected=None, how=err)
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        return dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                    first=first[6:][:220] if first else None)
    with ThreadPoolExecutor(max_workers=min(4, os.cpu_count() or 1)) as pool:
        return list(pool.map(run, jobs))


# ---------------------------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------------------------
class Stats(dict):
    def __missing__(self, key):
        return 0


def new_stats():
    return Stats(scenarios=0, ticks=0, steps=0, host_calls=0, state_compares=0, object_bytes=0, body_bytes=0, entry_bytes=0,
                event_bytes=0, cells=0, pointer_moves=0, pointer_hits=0, cursor_words=0, clicks=0, clicks_acting=0,
                clicks_ignored=0, rotkeys=0, rotkeys_acting=0, rotkeys_ignored=0, invalidates=0, cleanups=0, render_calls=0,
                blit_calls=0, render_skipped_unreachable=0, phase0_steps=0, phase1_steps=0, phase2_steps=0, phaseX_steps=0,
                completions=0, gate_closed_ticks=0, fatal_paths_matched=0, ticks_consumed=0, busy_consumed=0,
                rands_consumed=0, pokes=0, mismatches=0, effect_kinds=Counter(), known_observed=Counter(), groups={})


def run_list(x, lib, scs, stats, fail_fast=False):
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


def native_fuzz(lib, count, seed, stats):
    """Bounded malformed bodies against the native kernel alone (no original): every call must return a status (no crash,
    no sanitizer report under EA_SANITIZE=1); a body that validate refuses must also be refused by ea_step without any
    host call. Reported as native_fuzz in the receipt."""
    rng = random.Random(seed)
    hist = Counter()
    for i in range(count):
        b = bytearray(rand_body(rng) if rng.random() < 0.8 else corpus_rows()[rng.randrange(6)]['body'])
        for _ in range(rng.choice([1, 2, 4, 12, 60])):
            b[rng.randrange(BODY_LEN)] = rng.choice([0, 0xff, 0x7f, 0x80, rng.randrange(256)])
        if rng.random() < 0.2:
            struct.pack_into('<h', b, B_COUNT, rng.choice([-1, 0, 20, 21, 255, -32768, 32767]))
        nat = Native(lib)
        try:
            nat.set_view((rng.randrange(-50, 50), rng.randrange(-50, 50), rng.randrange(-20, 20), rng.randrange(-20, 20), rng.randrange(300, 700), rng.randrange(300, 700)))
            nat.set_handles([0x7001, 0x7002, 0x7003])
            nat.set_texts({b'KEY_A': txt(rng, rng.choice([5, 150, 260, 41000]))})
            nat.set_body(0, bytes(b))
            nat.lib.eao_set_captions(nat.h, rng.choice([0, 1]))
            nat.set_queues([1 << 20] * 8, [rng.choice([0, 1]) for _ in range(8)], [rng.randrange(4) for _ in range(4)] + [0] * 40)
            v = nat.lib.eao_validate(cbuf(b), len(b))
            hist['validate:%d' % v] += 1
            st, why, log, res = nat.step(0, 0, 0)
            hist['phase0:%d' % st] += 1
            if v != 0 and (st != 2 or log):
                raise Mismatch('native fuzz %d: refused body ran (validate %d step %d)' % (i, v, st))
            if v != 0 or st != 0:
                continue
            for k in range(rng.randrange(4, 30)):
                nat.set_queues([(1 << 20) + 1000 * k] * 8, [rng.choice([0, 1])] * 8, [rng.randrange(4) for _ in range(4)] + [0] * 40)
                op = rng.randrange(6)
                if op == 0:
                    r = nat.step(0, 0, 1)[0]
                elif op == 1:
                    r = nat.pointer(0, rng.randrange(-40, 700), rng.randrange(-40, 500), (rng.randrange(0, 600),) * 2 + (rng.randrange(0, 700),) * 2)[0]
                elif op == 2:
                    r = nat.click(0, 1, rng.choice([0x2777, 0x2778, 0x2779, 0x277a, 0x277b, 0x277c, -1, 0, 9]))[0]
                elif op == 3:
                    r = nat.rotkey(0, 1)[0]
                elif op == 4:
                    nat.clear()
                    r = nat.plan(0)[0]
                else:
                    r = nat.simple(nat.lib.eao_invalidate)[0]
                hist['op%d:%d' % (op, r)] += 1
            hist['phase2:%d' % nat.step(0, 0, 2)[0]] += 1
            hist['cleanup:%d' % nat.simple(nat.lib.eao_cleanup)[0]] += 1
        finally:
            nat.close()
        stats['native_fuzz_bodies'] += 1
    stats['native_fuzz_statuses'] = dict(hist)


def asm_extents():
    out = []
    for f in sorted((PROJECT / 'asm').glob('FUN_*.s')):
        with open(f) as fh:
            for line in fh:
                m = re.match(r'# extent:\s+0x([0-9a-f]+)-0x([0-9a-f]+)', line)
                if m:
                    out.append((int(m.group(1), 16), int(m.group(2), 16)))
                    break
    return sorted(out)


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
    ap.add_argument('--random', type=int, default=160, help='random scenarios (fixed seed)')
    ap.add_argument('--native-fuzz', type=int, default=400, help='malformed bodies against the native kernel alone')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-45.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib = open_lib(lib_path)
    x = X86()
    scs = scenario_list()
    scs += random_scenarios(args.random)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    stats = new_stats()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add(a), begin=0x401000, end=0x52a000)
    if args.mutation_run:
        quick = [s for s in scs if s['group'] != 'random'] + [s for s in scs if s['group'] == 'random'][:40]
        bad = run_list(x, lib, quick, stats, fail_fast=True)
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    bad = run_list(x, lib, scs, stats, args.fail_fast)
    try:
        native_fuzz(lib, args.native_fuzz, 4545, stats)
    except Mismatch as error:
        bad.append(('native_fuzz', str(error)))
        stats['mismatches'] += 1
    if args.discover_pins:
        import bisect
        ext = asm_extents()
        starts = [a for a, _ in ext]
        funcs = set()
        for a in blocks:
            i = bisect.bisect_right(starts, a) - 1
            if i >= 0 and ext[i][0] <= a < ext[i][1]:
                funcs.add(ext[i])
        out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs)]
        print('PINS_TABLE = (' + ','.join('(%#x,%#x,%r)' % t for t in out) + ',)')
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    print(json.dumps(summary, sort_keys=True))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        sources = {n: sha((args.src / n).read_bytes()) for n in ('action_family_ea_runtime.c', 'action_family_ea_runtime.h')}
        killed = sum(1 for m in (mutations or []) if m['detected'])
        result = dict(slice='RT-45', status='pass' if not bad and (mutations is None or killed == len(mutations)) else 'fail',
                      mismatches=len(bad), exe_sha256=EXE_HASH, source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_ea_runtime_oracle_driver.c').read_bytes()),
                      code_windows=[dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE],
                      scenarios=len(scs), stats=summary, mutants=len(mutations or []), mutants_killed=killed, mutations=mutations,
                      mismatch_list=bad[:50], hooks_fired=dict(x.hooks_fired), counters=dict(x.counters), fpu_control_word=hex(FPCW),
                      corpus_rows=len(corpus_rows()), elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
