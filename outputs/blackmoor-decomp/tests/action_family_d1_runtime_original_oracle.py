#!/usr/bin/env python3
"""RT-35: immutable x86 dispatcher 0x427a50 / handler 0x4b64a9 versus the native raw-0xd1 Turning Puzzle kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For raw 0xd1 rows the REAL dispatcher 0x427a50 runs: gate
0x423f57 (dependency tree built by the real loader 0x424aa8), the handler 0x4b64a9 with ECX = singleton 0x61d449, and,
as original x86 code: the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 on the table at 0x5d1591, the tile
geometry 0x4b6355, the solved check 0x4b642d, the generic completion 0x42ba3a (and 0x423d33 for subtype 2), the cursor
and candidate writer 0x4b6097, the cleanup 0x4b5bc8 with the reset 0x4b5b8a. The entry points the engine reaches
through other callers are driven directly with ECX = 0x61d449: the pointer receiver 0x4b5d17 (cascade 0x4f0059,
`ret 8`), the click 0x4b617a (accepted-release chain 0x43b287), the invalidate 0x4b5c11, the cleanup 0x4b5bc8 and the
render callback 0x4b7051 (one 0x4c5377 per tile, recorded). The native side is src/action_family_d1_runtime.c driven by
tests/action_family_d1_runtime_oracle_driver.c with a scripted host.

Compared for every scenario step: the ordered D1_FX_* effects (sound and tick calls with their arguments included), the
object image +0x1c..+0x277 byte for byte as D1Object mirrors it (rectangles, flags, counters, moving and frame arrays,
state), the generic Z entry table (0x58 entries of 0x4a bytes, byte for byte), the row phase dword and the completion
byte of every row, the process flag 0x5bb1ca, the seven scene-change cells (0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff,
0x5bb59b, 0x5bb59f, 0x5bb5a3), the engine mode 0x583999, the event flag table window (4096 dwords at 0x585801), the
names the image loader was asked for, the scripted queue consumption (ticks and busy answers), the pointer results
(return value, [0x5b44f0], [0x5c39e5], +0x252) and, for the render callback, the recorded 0x4c5377 blits against
d1_render_plan.

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard.
  R 0x51dc43 malloc      bump arena (OS/CRT boundary, used by the dependency loader 0x424aa8), zero filled
  R 0x4c2790 load_image(kind, name, 6, label)  thiscall ECX 0x5cf659, ret 0x10: returns the scripted handle
  R 0x4c2dfb release_image(&handle)             thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param
  R 0x4e8d96 clear pending item                 thiscall ECX 0x571442, ret 0 (no stack argument)
  R 0x4fb77a prepare sound(record ptr)          thiscall ECX 0x5c3a67, ret 4
  R 0x4fba69 stop sound(record ptr)             thiscall ECX 0x5c3a67, ret 4
  R 0x4fb2e3 play sound(channel word)           thiscall ECX 0x5c3a67, ret 4 (upper half of the pushed dword ignored)
  R 0x4f6334 sound busy(channel)                thiscall ECX 0x5cf1eb, ret 4: returns the scripted answer
  R 0x4c5377 opaque blit (ret 0x14)             recorder for the render callback, ECX 0x5cf659
  R GetTickCount (the import thunk, stub)       returns the next scripted tick value
  O 0x4b64a9 handler entry (row, phase, ECX check)   O 0x42ba3a generic completion   O 0x4d3992 release entry (slot)
  O 0x4b6757 / 0x4b6796  instruction boundaries inside 0x4b64a9 (after the entry label copy, after the slot surface
     store): they only read memory
  UC_HOOK_MEM_WRITE observers over singleton +0x1c, +0x225, +0x274, the row phase dwords, 0x5bb1ca, the seven
     scene-change cells, 0x583999 and the event flag window (read-only, they log the effects of the stores); everything
     else is plain original execution
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
     scenario expects the allocator's fatal path 0x52139c, which is then compared with the native host error);
     0x425b8b and 0x425b40 (debug tree printer / malformed tree) raise through the base.
 Windows imports (OS boundary, IAT slots patched to stubs): GetTickCount (scripted), InterlockedIncrement/Decrement,
 lstrlenA, Enter/Leave/InitializeCriticalSection (single thread); any other import fails the run.
 FS needs a TIB page (GDT) for the SEH frames. Debug flag 0x63a4cd is 0 (logging disabled). The singleton is
 constructed the way the original does: vtable word, then 0x4b5b8a (original code).

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, view origin
globals, the tick values and busy answers, slot-busy seeds, the event flag table contents.

EXPECTED DIFFERENCES (native safety layer; tagged scenarios, counted in stats.known_observed, never as passes):
  K1 two rows active at once: row B re-initialises the singleton, then row A's phase 1 runs in the original on B's
     object (it mixes A's body with B's tile data); native refuses (D1_ERR_UNSUPPORTED, no effect).
  K2 body validation: S == 0 (the original divides by zero), tile count above 16, link number above 16, short body.
  K3 a tile click whose retained tile index names no tile (+0x252 == -1 or >= N): the original indexes out of range,
     native refuses with D1_ERR_BOUNDS before any effect.
  K4 an event flag index outside the host window: the original stores through an arbitrary pointer; native refuses
     with D1_ERR_BOUNDS before any effect.
  K5 phase 1 / 2 on an object that was never initialised for the row: native D1_ERR_UNSUPPORTED.
  All five are unreachable in the game (11 rows, one per scene, loader-built bodies).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb, the sound engine
(0x4fb77a, 0x4fba69, 0x4fb2e3, 0x4f6334), 0x4e8d96, the blit body 0x4c5377, the pointer cascade 0x4f0059 that calls
0x4b5d17, the accepted-release chain 0x43b287 that calls 0x4b617a, the scene loader 0x40b34a / type loader 0x4b5c5c
that build the body, and the engine consumer of the scene-change cells.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_d1_runtime_original_oracle.py --mutations --result ../../../work/analysis/slices/RT-35.oracle-result.json
"""
from __future__ import annotations

import argparse
import hashlib
import itertools
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
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x61d449
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
G_ORIGIN_X, G_ORIGIN_Y = 0x583186, 0x58318a
G_BACK = 0x5cf665
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
G_CAND, G_CURSOR, G_CURSOR2 = 0x5c39e5, 0x5b44f0, 0x5b44f4
EVENTS_VA = 0x585801
EVENT_COUNT = 4096
CELLS = ((0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2), (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4))
TAIL_BASE = 0x2000a000
BODY_BASE = 0x22000000
BODY_STRIDE = 0x400
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
SOUND_THIS, BUSY_THIS, ITEM_THIS = 0x5c3a67, 0x5cf1eb, 0x571442
FPCW = 0x27f
BODY_LEN = 927
IMG_FIRST, IMG_END = 0x1c, 0x278
LABEL_KIND = b'CIFTREE'
LABEL_SURFACE = b'Turning Puzzle Surface'
LABEL_BLIT = b'Turning Puzzle Overlays'
NO_SOUND = b'NO SOUND'
MAX_ROWS = 40

FX = dict(ENTER=0, ACTIVE=1, START_FLAG=2, CLEAR_ITEM=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6, SLOT_SURFACE=7,
          SOUND_PREPARE=8, PHASE=9, SOUND_BUSY=10, SOUND_PLAY=11, SOUND_STOP=12, TICK=13, STATE=14,
          XFER_5BB57B=15, XFER_5BB599=16, XFER_5BB595=17, XFER_5C39FF=18, XFER_5BB59B=19, XFER_5BB59F=20,
          XFER_5BB5A3=21, ENGINE_MODE=22, EVENT_FLAG=23, COMPLETE=24, RELEASE_SURFACE=25, RELEASE_SLOT=26)
FXN = {v: k for k, v in FX.items()}
CELL_FX = [FX['XFER_5BB57B'], FX['XFER_5BB599'], FX['XFER_5BB595'], FX['XFER_5C39FF'], FX['XFER_5BB59B'],
           FX['XFER_5BB59F'], FX['XFER_5BB5A3']]

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4e8d96: (0x80, 0), 0x4fb77a: (0x300, 4),
             0x4fba69: (0x20, 4), 0x4fb2e3: (0x200, 4), 0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14)}

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
PINS_TABLE = (
 (0x4234c8, 0x4234dd,
  'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
 (0x4237f7, 0x423876,
  'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
 (0x423d33, 0x423da2,
  'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
 (0x423f57, 0x423fbb,
  '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
 (0x42406d, 0x424201,
  '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
 (0x424201, 0x424346,
  'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
 (0x424346, 0x424aa8,
  '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
 (0x424aa8, 0x425b8b,
  'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
 (0x427a50, 0x42acad,
  '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
 (0x42ba3a, 0x42babf,
  '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
 (0x4b5b8a, 0x4b5bc8,
  '739d01b29369b06b2f4168435b360a251a3fc289e72b38ed622b63a72cda33f0'),
 (0x4b5bc8, 0x4b5c11,
  '5b3869359ee352e569fe26b92f70979cacdca293644d889def2f8456c387d1b9'),
 (0x4b5c11, 0x4b5c48,
  '5a68c808cd2bff8a32a6f4b4ce48766d38c60b4a1fde722802702275f02fa056'),
 (0x4b5d17, 0x4b6097,
  'e117e759992c878ceac68d51b408bd7c1cdc673925c349a406aafa96ae8bb92a'),
 (0x4b6097, 0x4b617a,
  'a0063d1bb7d74e0545e449d4f3adee69828fe57c639d3cb36ac47c9e55edd4d0'),
 (0x4b617a, 0x4b6355,
  '8fbbf29fc408c2ecc47c6b647f72e8e8c01301b3825e1c08362be2d4ff36f4cb'),
 (0x4b6355, 0x4b642d,
  'a4b9ee6370d0b14edfdf342a3cb3235a987d95adc50e01b7e08e5576a5c71c01'),
 (0x4b642d, 0x4b64a9,
  '1aaafd4c98845479bc0202ccb02559ed6bc3abdd65d33bf28d5a2f6c028efa0c'),
 (0x4b64a9, 0x4b7041,
  '114911ba8e78801ffdb8a37c39f61732388cf3052abd590307d57e525d97c83f'),
 (0x4b7051, 0x4b70e0,
  'd5fde6419cd819593f262d8d3e6b7a47535f3068876b29b1453012f2d84011ca'),
 (0x4c2790, 0x4c2898,
  '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
 (0x4c2dfb, 0x4c2e5b,
  '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
 (0x4c5377, 0x4c558b,
  'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
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


# ---------------------------------------------------------------------------------------------
# body construction (synthetic) and parsing
# ---------------------------------------------------------------------------------------------
B_COUNT, B_FRAMES, B_SUBSTEPS, B_INITIAL, B_DST, B_HIT = 0x21, 0x23, 0x25, 0x27, 0x47, 0x147
B_ROW_FLAG, B_ORIGIN_X, B_ORIGIN_Y, B_TILE_W, B_TILE_H, B_LINKS = 0x247, 0x248, 0x24c, 0x250, 0x252, 0x254
B_PACE_T, B_SOUND_FLAG, B_PACE_M, B_SOUND0, B_CHANNEL0, B_TARGET = 0x2d4, 0x2d6, 0x2d7, 0x2d9, 0x2fa, 0x30a
B_WIN, B_SOUND1, B_CHANNEL1, B_EXIT, B_EXIT_RECT = 0x32a, 0x345, 0x366, 0x376, 0x38f
SCENE_FMT = '<h3h3ihhB'


def scene_block(scene=9999, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return struct.pack(SCENE_FMT, scene, *words, *dwords, start, flag, value)


def parse(body):
    g = lambda o, f: struct.unpack_from(f, body, o)[0]
    n = g(B_COUNT, '<h')
    info = dict(n=n, F=g(B_FRAMES, '<h'), S=g(B_SUBSTEPS, '<h'), T=g(B_PACE_T, '<h'), M=g(B_PACE_M, '<h'),
                rowflag=body[B_ROW_FLAG], sflag=body[B_SOUND_FLAG], tw=g(B_TILE_W, '<h'), th=g(B_TILE_H, '<h'),
                ox=g(B_ORIGIN_X, '<i'), oy=g(B_ORIGIN_Y, '<i'),
                init=[g(B_INITIAL + 2 * i, '<h') for i in range(max(n, 0))],
                target=[g(B_TARGET + 2 * i, '<h') for i in range(max(n, 0))],
                links=[[g(B_LINKS + 8 * i + 2 * k, '<h') for k in range(4)] for i in range(max(n, 0))],
                hit=[list(struct.unpack_from('<4i', body, B_HIT + 16 * i)) for i in range(max(n, 0))],
                dst=[list(struct.unpack_from('<4i', body, B_DST + 16 * i)) for i in range(max(n, 0))],
                exit_rect=list(struct.unpack_from('<4i', body, B_EXIT_RECT)),
                snd0=body[B_SOUND0:B_SOUND0 + 9] == NO_SOUND + b'\0', snd1=body[B_SOUND1:B_SOUND1 + 9] == NO_SOUND + b'\0')
    return info


def turn(info, frames, k):
    """The frames after one click on tile k: the tile and its link targets advance one frame (mod F)."""
    F = info['F']
    idx = {k} | {l - 1 for l in info['links'][k] if l}
    out = list(frames)
    for i in idx:
        if i < len(out):
            out[i] = (out[i] + 1) % F if F > 0 else out[i]
    return out


def solve_clicks(info, limit=250000):
    """Minimal click counts per tile that bring init to target (brute force), or None."""
    n, F = info['n'], info['F']
    if n <= 0 or F <= 1:
        return [0] * max(n, 0) if info['init'] == info['target'] else None
    if F ** n > limit:
        return None
    vec = []
    for k in range(n):
        v = [0] * n
        for i in ({k} | {l - 1 for l in info['links'][k] if l}):
            if i < n:
                v[i] = 1
        vec.append(v)
    need = [(t - i) % F for i, t in zip(info['init'], info['target'])]
    best = None
    for combo in itertools.product(range(F), repeat=n):
        tot = [0] * n
        for k, c in enumerate(combo):
            if c:
                vk = vec[k]
                for i in range(n):
                    tot[i] += c * vk[i]
        if all(tot[i] % F == need[i] for i in range(n)):
            s = sum(combo)
            if best is None or s < best[0]:
                best = (s, combo)
    return list(best[1]) if best else None


def make_body(rng, name=b'WORDLOCK_SURFACE', n=6, F=7, S=1, init=None, target=None, rowflag=1, origin=(0, 0), tile=(51, 67),
              links=None, T=1, flag=0, M=1, snd0=NO_SOUND, ch0=7, snd1=NO_SOUND, ch1=8, win=None, exit_=None,
              dst=None, hit=None, exit_rect=None, garbage=True):
    b = bytearray(rng.randbytes(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    nm = name[:0x20] + b'\0'
    b[0:len(nm)] = nm
    struct.pack_into('<hhh', b, B_COUNT, n, F, S)
    cnt = max(n, 0)
    if init is None:
        init = [rng.randrange(max(F, 1)) for _ in range(cnt)]
    if target is None:
        target = list(init)
    for i, v in enumerate(init[:16]):
        struct.pack_into('<h', b, B_INITIAL + 2 * i, v)
    for i, v in enumerate(target[:16]):
        struct.pack_into('<h', b, B_TARGET + 2 * i, v)
    if dst is None:
        dst = [(10 + 60 * i, 20 + 5 * i, 10 + 60 * i + 50, 20 + 5 * i + 66) for i in range(min(cnt, 16))]
    if hit is None:
        hit = [(r[0] + 2, r[1] + 2, r[2] - 2, r[3] - 2) for r in dst]
    for i in range(min(cnt, 16)):
        struct.pack_into('<4i', b, B_DST + 16 * i, *dst[i])
        struct.pack_into('<4i', b, B_HIT + 16 * i, *hit[i])
    b[B_ROW_FLAG] = rowflag
    struct.pack_into('<ii', b, B_ORIGIN_X, origin[0], origin[1])
    struct.pack_into('<hh', b, B_TILE_W, tile[0], tile[1])
    if links is None:
        links = [[0, 0, 0, 0] for _ in range(cnt)]
    for i in range(min(cnt, 16)):
        struct.pack_into('<4h', b, B_LINKS + 8 * i, *links[i])
    struct.pack_into('<h', b, B_PACE_T, T)
    b[B_SOUND_FLAG] = flag
    struct.pack_into('<h', b, B_PACE_M, M)

    def rec(off, ch_off, name_, ch):
        nm_ = name_[:0x20] + b'\0'
        b[off:off + len(nm_)] = nm_
        struct.pack_into('<h', b, ch_off, ch)
    rec(B_SOUND0, B_CHANNEL0, snd0, ch0)
    rec(B_SOUND1, B_CHANNEL1, snd1, ch1)
    b[B_WIN:B_WIN + 25] = win if win is not None else scene_block(4377, (1, 2, 3), (4, 5, 6), 0, 1984, 1)
    b[B_EXIT:B_EXIT + 25] = exit_ if exit_ is not None else scene_block(4366, (7, 8, 9), (10, 11, 12), 1, -1, 0)
    if exit_rect is None:
        exit_rect = (400, 300, 460, 340)
    struct.pack_into('<4i', b, B_EXIT_RECT, *exit_rect)
    return bytes(b)


_CORPUS = None


def corpus_bodies():
    """The 11 raw 0xd1 bodies of the owner's local resources (never printed; only counts and hashes leave here)."""
    global _CORPUS
    if _CORPUS is None:
        c = json.loads((PRIVATE / 'A-D1.1.corpus.json').read_text())
        out = []
        for r in c['records']:
            data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % r['resource_index'])).read_bytes()
            p, n = r['act_payload_offset'], r['act_payload_length']
            payload = data[p:p + n]
            body = payload[50:]
            if len(body) != BODY_LEN + r['dependency_tail_length'] or sha(body) != r['body_sha256'] or \
               payload[48] != 0xd1:
                raise OracleError('corpus row source mismatch')
            out.append(dict(body=body[:BODY_LEN], tail=body[BODY_LEN:], subtype=payload[49], resource=r['resource_index']))
        _CORPUS = out
    return _CORPUS


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_d1_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_d1_runtime.c'), '-o', str(out)]
    if os.environ.get('D1_SANITIZE'):
        # ASan cannot be preloaded under this Python (capstone is loaded with RTLD_DEEPBIND); UBSan with bounds works
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8)
    lib.d1o_new.restype = p
    lib.d1o_free.argtypes = [p]
    lib.d1o_set_view.argtypes = [p, i32, i32]
    lib.d1o_set_world_flag.argtypes = [p, i32]
    lib.d1o_get_world_flag.argtypes = [p]
    lib.d1o_get_world_flag.restype = i32
    lib.d1o_set_handles.argtypes = [p, C.POINTER(C.c_uint32), C.c_int]
    lib.d1o_set_ticks.argtypes = [p, C.POINTER(C.c_uint32), C.c_int]
    lib.d1o_set_busy.argtypes = [p, C.POINTER(i32), C.c_int]
    lib.d1o_consumed.argtypes = [p, C.POINTER(i32)]
    lib.d1o_set_busy_slot.argtypes = [p, C.c_int, C.c_int]
    lib.d1o_set_entry_u32.argtypes = [p, C.c_int, C.c_int, C.c_uint32]
    lib.d1o_set_cells.argtypes = [p, C.POINTER(i32)]
    lib.d1o_get_cells.argtypes = [p, C.POINTER(i32)]
    lib.d1o_transitions.argtypes = [p]
    lib.d1o_set_events.argtypes = [p, C.POINTER(i32)]
    lib.d1o_get_events.argtypes = [p, C.POINTER(i32)]
    lib.d1o_event_count.restype = C.c_int
    lib.d1o_clear_log.argtypes = [p]
    lib.d1o_step.argtypes = [p, u8p, C.c_int, C.c_uint32, C.POINTER(C.c_uint32)]
    lib.d1o_step.restype = C.c_int
    lib.d1o_why.argtypes = [p]
    lib.d1o_why.restype = C.c_char_p
    lib.d1o_bad_slot_calls.argtypes = [p]
    lib.d1o_pointer.argtypes = [p, u8p, C.c_int, C.c_int, C.POINTER(i32)]
    lib.d1o_pointer.restype = C.c_int
    lib.d1o_click.argtypes = [p, u8p, C.c_uint32, i32, i32, C.POINTER(C.c_uint32)]
    lib.d1o_click.restype = C.c_int
    lib.d1o_invalidate.argtypes = [p]
    lib.d1o_cleanup.argtypes = [p]
    lib.d1o_log_count.argtypes = [p]
    lib.d1o_log.argtypes = [p, C.c_int, C.POINTER(i32)]
    lib.d1o_name_count.argtypes = [p]
    lib.d1o_name.argtypes = [p, C.c_int]
    lib.d1o_name.restype = C.c_char_p
    lib.d1o_image.argtypes = [p, u8p]
    lib.d1o_entries.argtypes = [p, u8p]
    lib.d1o_set_image.argtypes = [p, u8p]
    lib.d1o_plan.argtypes = [p, u8p, C.POINTER(i32)]
    lib.d1o_plan.restype = C.c_int
    lib.d1o_geometry.argtypes = [u8p, C.c_int, C.c_int, C.c_int, C.POINTER(i32)]
    lib.d1o_validate.argtypes = [u8p, C.c_size_t]
    lib.d1o_validate.restype = C.c_int
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.d1o_new()
        self.state_bytes = IMG_END - IMG_FIRST

    def close(self):
        self.lib.d1o_free(self.h)

    def set_view(self, x, y):
        self.lib.d1o_set_view(self.h, x, y)

    def set_handles(self, hs):
        arr = (C.c_uint32 * max(1, len(hs)))(*hs)
        self.lib.d1o_set_handles(self.h, arr, len(hs))

    def set_queues(self, ticks, busy):
        t = (C.c_uint32 * max(1, len(ticks)))(*[v & 0xffffffff for v in ticks])
        self.lib.d1o_set_ticks(self.h, t, len(ticks))
        bz = (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy])
        self.lib.d1o_set_busy(self.h, bz, len(busy))

    def consumed(self):
        t = (C.c_int32 * 6)()
        self.lib.d1o_consumed(self.h, t)
        return list(t)

    def fx(self):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(self.lib.d1o_log_count(self.h)):
            self.lib.d1o_log(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        return out

    def names(self):
        return [self.lib.d1o_name(self.h, i).decode('latin1') for i in range(self.lib.d1o_name_count(self.h))]

    def step(self, body, row, phase):
        L = self.lib
        L.d1o_clear_log(self.h)
        res = (C.c_uint32 * 3)()
        status = L.d1o_step(self.h, cbuf(body), row, phase, res)
        return status, (L.d1o_why(self.h) or b'').decode(), self.fx(), self.names(), list(res)

    def pointer(self, body, x, y):
        self.lib.d1o_clear_log(self.h)
        out = (C.c_int32 * 3)()
        status = self.lib.d1o_pointer(self.h, cbuf(body), x, y, out)
        return status, list(out)

    def click(self, body, row_phase, candidate, start_flag):
        self.lib.d1o_clear_log(self.h)
        newp = C.c_uint32(0)
        status = self.lib.d1o_click(self.h, cbuf(body), row_phase, candidate, start_flag, C.byref(newp))
        return status, newp.value, self.fx()

    def simple(self, fn):
        self.lib.d1o_clear_log(self.h)
        status = fn()
        return status, self.fx()

    def image(self):
        t = (C.c_uint8 * (IMG_END - IMG_FIRST))()
        self.lib.d1o_image(self.h, t)
        return bytes(t)

    def set_image(self, raw):
        self.lib.d1o_set_image(self.h, cbuf(raw))

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.d1o_entries(self.h, t)
        return bytes(t)

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.d1o_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        t = (C.c_int32 * 8)(*v)
        self.lib.d1o_set_cells(self.h, t)

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.d1o_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        t = (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw)
        self.lib.d1o_set_events(self.h, t)

    def plan(self, body):
        t = (C.c_int32 * 131)()
        status = self.lib.d1o_plan(self.h, cbuf(body), t)
        v = list(t)
        return status, dict(valid=v[0], surface=v[1] & 0xffffffff, count=v[2],
                            src=[v[3 + 4 * i:7 + 4 * i] for i in range(16)],
                            dst=[v[67 + 4 * i:71 + 4 * i] for i in range(16)])


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
            if thunk & 0x80000000:
                nm = 'ord%d' % (thunk & 0xffff)
            else:
                nm = cstr(data[off(thunk) + 2:off(thunk) + 66]).decode()
            out.append((nm, base + ft + 4 * k))
            k += 1
        o += 20
    return out


POPS = {0x4c2790: 0x10, 0x4c2dfb: 4, 0x4e8d96: 0, 0x4fb77a: 4, 0x4fba69: 4, 0x4fb2e3: 4, 0x4f6334: 4, 0x4c5377: 0x14}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
AT_REGISTER, AT_SLOT_SURFACE = 0x4b6757, 0x4b6796


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
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(BODY_BASE, 0x10000)
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
        self.rec = False            # effects are recorded while True
        self.cur_phase = None       # phase of the handler visit being run (None outside the dispatcher)
        self.fx = []
        self.entered = []
        self.allocs = {}
        self.heap_cursor = HEAP_BASE
        self.heap_high = HEAP_BASE
        self.blits = []
        self.loaded = []
        self.handles = []
        self.handle_i = 0
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
        self.fatal_done = False
        self.known = None
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

    # -- imports (OS boundary) ---------------------------------------------------------------
    def _install_imports(self):
        for idx, (nm, iat) in enumerate(parse_imports(DEFAULT_EXE, self.pe.image_base)):
            stub = STUBS + 16 * idx
            self.imports[stub] = (nm, iat)
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
            self.log(FX['TICK'], v)
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
        for a in POPS:
            table[a] = self._replaced
        for a in GUARDS:
            table[a] = self._raise
        table[0x4b64a9] = self._entry
        table[0x42ba3a] = self._complete
        table[0x4d3992] = self._release_entry
        table[AT_REGISTER] = self._at_register
        table[AT_SLOT_SURFACE] = self._at_slot_surface
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        w = self._guard_write
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=OBJ + 0x1c, end=OBJ + 0x1d)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=OBJ + 0x225, end=OBJ + 0x228)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=OBJ + 0x274, end=OBJ + 0x277)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=START_FLAG, end=START_FLAG + 3)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=G_MODE, end=G_MODE + 3)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=ROWS, end=ROWS + MAX_ROWS * ROW + 3)
        for a, sz in CELLS:
            uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=a, end=a + sz - 1)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=EVENTS_VA, end=EVENTS_VA + 4 * EVENT_COUNT - 1)

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
        return self.rd(OBJ + IMG_FIRST, IMG_END - IMG_FIRST)

    def entries(self):
        return self.rd(ENTRY, NENT * STRIDE)

    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

    def entry_surface(self, slot):
        return struct.unpack('<I', self.rd(ENTRY + slot * STRIDE + 8, 4))[0]

    def events_raw(self):
        return self.rd(EVENTS_VA, 4 * EVENT_COUNT)

    def cells(self):
        out = []
        for a, sz in CELLS:
            out.append(self.rs32(a) if sz == 4 else self.rs16(a))
        out.append(self.rs32(G_MODE))
        return out

    # -- effects ---------------------------------------------------------------------------------
    def log(self, kind, a=0, b=0):
        if self.rec:
            self.fx.append((kind, s32(a), s32(b)))

    def _guard_write(self, uc, access, address, size, value, user):
        try:
            self._on_write(uc, access, address, size, value, user)
        except Exception as error:
            self._hook_error = 'write hook %#x: %r' % (address, error)
            uc.emu_stop()

    def _on_write(self, uc, access, address, size, value, user):
        if not self.rec:
            return
        if address == OBJ + 0x1c and size == 2:
            if self.cur_phase == 0:
                self.log(FX['SLOT'], s16(value))
        elif address == OBJ + 0x225 and size == 4:
            if value & 0xffffffff:
                self.log(FX['ACTIVE'], 1)
        elif address == OBJ + 0x274 and size == 4:
            if self.cur_phase != 0:
                self.log(FX['STATE'], s32(value))
        elif address == START_FLAG and size == 4:
            self.log(FX['START_FLAG'], s32(value))
        elif address == G_MODE and size == 4:
            self.log(FX['ENGINE_MODE'], s32(value))
        elif ROWS <= address < ROWS + MAX_ROWS * ROW + 4:
            if (address - ROWS - PHASE_OFF) % ROW == 0 and address >= ROWS + PHASE_OFF and size == 4:
                if value & 0xffffffff:  # the generic completion's store of 0 is the COMPLETE effect
                    self.log(FX['PHASE'], s32(value))
        elif EVENTS_VA <= address < EVENTS_VA + 4 * EVENT_COUNT:
            if (address - EVENTS_VA) % 4 or size != 4:
                raise OracleError('unaligned event flag store %#x' % address)
            self.log(FX['EVENT_FLAG'], (address - EVENTS_VA) // 4, value & 0xffffffff)
        else:
            for k, (a, sz) in enumerate(CELLS):
                if address == a and size == sz:
                    self.log(CELL_FX[k], s16(value) if sz == 2 else s32(value))
                    return
            raise OracleError('unclassified write hook hit %#x size %d' % (address, size))

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('handler entered with ECX != 0x61d449')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        self.cur_phase = phase
        if phase == 1:
            self.counters['phase1_state_%d' % self.rs32(OBJ + 0x274)] += 1
        self.fx.append((FX['ENTER'], row, phase))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.log(FX['COMPLETE'], row)

    def _at_register(self, uc, address, size, user):
        self.log(FX['SLOT_REGISTER'], self.rs16(OBJ + 0x1c))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0x1c)
        self.log(FX['SLOT_SURFACE'], slot, self.entry_surface(slot))

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(FX['RELEASE_SLOT'], struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        if address == 0x4c2790:
            if ecx != SURF_HOST:
                raise OracleError('image loader ECX')
            kind, name, six, label = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            if kind != LABEL_KIND or six != 6 or label != LABEL_SURFACE:
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.loaded.append(name.decode('latin1'))
            self.log(FX['SURFACE_LOAD'], eax)
        elif address == 0x4c2dfb:
            if ecx != SURF_HOST:
                raise OracleError('image release ECX')
            old = u32(uc, a[0])
            self.log(FX['RELEASE_SURFACE'], old)
            self.wr(a[0], bytes(4))
        elif address == 0x4e8d96:
            if ecx != ITEM_THIS:
                raise OracleError('clear item ECX')
            self.log(FX['CLEAR_ITEM'])
        elif address in (0x4fb77a, 0x4fba69):
            if ecx != SOUND_THIS:
                raise OracleError('sound ECX')
            rec = self.record_index(a[0])
            self.log(FX['SOUND_PREPARE'] if address == 0x4fb77a else FX['SOUND_STOP'], rec)
        elif address == 0x4fb2e3:
            if ecx != SOUND_THIS:
                raise OracleError('sound play ECX')
            self.log(FX['SOUND_PLAY'], s16(a[0]))
        elif address == 0x4f6334:
            if ecx != BUSY_THIS:
                raise OracleError('sound busy ECX')
            if self.busy_i >= len(self.busy_q):
                raise OracleError('busy queue underflow')
            eax = self.busy_q[self.busy_i] & 0xffffffff
            self.busy_i += 1
            self.log(FX['SOUND_BUSY'], s16(a[0]), s32(eax))
        elif address == 0x4c5377:
            if ecx != SURF_HOST:
                raise OracleError('blit ECX')
            rect = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.blits.append(dict(src_surface=a[0], dst_surface=a[1], src=rect(a[2]), dst=rect(a[3]), src_ptr=a[2],
                                   dst_ptr=a[3], label=cstr(self.rd(a[4], 40))))
        else:
            raise OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    cur_body = 0

    def record_index(self, ptr):
        off = (ptr - BODY_BASE) % BODY_STRIDE
        if not BODY_BASE <= ptr < BODY_BASE + MAX_ROWS * BODY_STRIDE:
            raise OracleError('sound record pointer %#x is outside the bodies' % ptr)
        if off == B_SOUND0:
            return 0
        if off == B_SOUND1:
            return 1
        raise OracleError('sound record pointer %#x is not a body record' % ptr)

    # -- scenario plumbing ------------------------------------------------------------------------
    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(HEAP_BASE, bytes(self.heap_high - HEAP_BASE))
        uc.mem_write(BODY_BASE, bytes(0x10000))
        uc.mem_write(TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, FPCW)
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.allocs.clear()
        self.blits = []
        self.loaded = []
        self.fx = []
        self.entered = []
        self.handle_i = 0
        self.tick_q, self.tick_i, self.busy_q, self.busy_i = [], 0, [], 0
        self.rec = False
        self.cur_phase = None
        self.expect_fatal = None
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.w32(OBJ, 0x52e120)  # CObject vtable word, as the constructor writes it
        self.call(0x4b5b8a, [], OBJ)  # the constructor's reset, original code

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
            self.wr(base + 0x30, bytes([0xd1, spec.get('subtype', 1)]) + struct.pack('<I', body_at))
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
        self.wr(0x5c3a47, bytes(4))
        self.rec = True
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.rec = False
            self.cur_phase = None

    def run_op(self, address, args, ecx):
        """A directly driven entry point; the effects land in self.fx."""
        self.fx = []
        self.rec = True
        self.cur_phase = None
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
    k, a, b = t
    return '%s(%d,%d)' % (FXN.get(k, k), a, b)


def norm_fx(seq):
    return [(k, s32(a), s32(b)) for k, a, b in seq]


def compare_fx(where, orig, nat):
    orig, nat = norm_fx(orig), norm_fx(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        raise Mismatch('%s effect %d: original %s vs native %s' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None))


OBJ_FIELDS = [(0x1c, 2, 'slot'), (0x1e, 2, 'row'), (0x20, 4, 'surface'), (0x24, 256, 'src'), (0x124, 256, 'dst'),
              (0x224, 1, 'dirty'), (0x225, 4, 'active'), (0x229, 1, 'exit_taken'), (0x22a, 1, 'solved'),
              (0x22b, 1, 'counter'), (0x22c, 2, 'step'), (0x22e, 4, 'deadline'), (0x232, 32, 'moving'),
              (0x252, 2, 'last_tile'), (0x254, 32, 'frame'), (0x274, 4, 'state')]


def field_of(off):
    for o, n, name in OBJ_FIELDS:
        if o <= off < o + n:
            return '%s+%d' % (name, off - o)
    return '?'


class Model:
    """Harness state both sides are driven from (what the engine and the executor own)."""
    pass


def compare_state(where, ctx, entries=True):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['state_compares'] += 1
    oi, ni = x.image(), nat.image()
    stats['object_bytes'] += len(oi)
    if oi != ni:
        k = next(i for i in range(len(oi)) if oi[i] != ni[i])
        raise Mismatch('%s object field %s: original %02x native %02x' % (where, field_of(IMG_FIRST + k), oi[k], ni[k]))
    if x.rs32(START_FLAG) != nat.lib.d1o_get_world_flag(nat.h):
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), nat.lib.d1o_get_world_flag(nat.h)))
    oc, nc = x.cells(), nat.cells()
    stats['cells'] += len(oc)
    if oc != nc:
        k = next(i for i in range(len(oc)) if oc[i] != nc[i])
        raise Mismatch('%s scene-change cell %d: original %d native %d' % (where, k, oc[k], nc[k]))
    if entries:
        ea, eb = x.entries(), nat.entries()
        stats['entry_bytes'] += len(ea)
        if ea != eb:
            k = next(i for i in range(len(ea)) if ea[i] != eb[i])
            raise Mismatch('%s entry table slot %#x +%#x original %02x native %02x' % (where, k // STRIDE, k % STRIDE, ea[k], eb[k]))
    ev, nv = x.events_raw(), nat.events()
    stats['event_bytes'] += len(ev)
    if ev != nv:
        k = next(i for i in range(len(ev)) if ev[i] != nv[i])
        raise Mismatch('%s event flag %d: original %02x native %02x' % (where, k // 4, ev[k], nv[k]))
    for row in range(ctx.first + len(ctx.rows)):
        if x.row_phase(row) != ctx.phase.get(row, 0):
            raise Mismatch('%s row %d phase: original %d model %d' % (where, row, x.row_phase(row), ctx.phase.get(row, 0)))
        if x.row_complete(row) != ctx.complete.get(row, 0):
            raise Mismatch('%s row %d completion byte: original %d model %d' % (where, row, x.row_complete(row), ctx.complete.get(row, 0)))
    if x.rs32(G_CAND) != ctx.cand:
        raise Mismatch('%s candidate 0x5c39e5: original %d native model %d' % (where, x.rs32(G_CAND), ctx.cand))


# ---------------------------------------------------------------------------------------------
# scenario execution
# ---------------------------------------------------------------------------------------------
VIEWS = {'v0': (0, 0), 'v1': (13, 21), 'neg': (-40, -25), 'big': (300, 200), 'edge': (0x7ffffff0, -0x7ffffff0)}
CLOCKS = {'low': 100, 'mid': 0x7fffff00, 'sign': 0x7ffffff0, 'wrap': 0xfffff000, 'top': 0xfffffff8}


def gate_open(ctx, spec):
    t = spec.get('tail') or b''
    if not t:
        return True
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
    return ctx


def row_body(ctx, row):
    k = row - ctx.first
    return ctx.rows[k]['body'] if 0 <= k < len(ctx.rows) else None


def obj_row(ctx):
    r = ctx.x.rs16(OBJ + 0x1e)
    return r if row_body(ctx, r) is not None else None


def active_body(ctx):
    r = obj_row(ctx)
    return (ctx.rows[r - ctx.first]['body'] if r is not None else (ctx.rows[0]['body'] if ctx.rows else None))


def make_queues(ctx, spec):
    """Tick values and busy answers for one dispatch; both sides receive the same lists."""
    x, rng = ctx.x, ctx.rng
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 8)
    dl = struct.unpack('<I', x.rd(OBJ + 0x22e, 4))[0]
    if policy == 'clock':
        base = ctx.clock
        ticks = [(base + i) & 0xffffffff for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', (0, 1, 7, 300, 1500, 9000)))) & 0xffffffff
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 1000, 0x80000000, -0x80000000, 0x7fffffff]
        ticks = [(dl + rng.choice(offs)) & 0xffffffff for _ in range(n)]
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, dl, dl - 1, dl + 1, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)])
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
    return ticks, busy


def do_tick(ctx, where, spec):
    x, nat, stats, rows, first = ctx.x, ctx.nat, ctx.stats, ctx.rows, ctx.first
    ticks, busy = make_queues(ctx, spec)
    x.set_queues(ticks, busy)
    nat.set_queues(ticks, busy)
    x.loaded = []
    mode_model = x.rs32(G_MODE)
    fatal = None
    try:
        x.dispatch()
    except Fatal as error:
        fatal = error.address
        x.rec = False
    stats['ticks'] += 1
    # the gate / completion model of the dispatcher: rows in order, only while the engine mode is 3
    entered = list(x.entered)
    nfx, names, expected_i = [], [], first
    last_status = 0
    pending = []
    for n_i, (row, phase) in enumerate(entered):
        spec_row = rows[row - first]
        body = spec_row['body']
        # every row before this one that the model says must run has to be in the list in order
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt is None or nxt != row:
            raise Mismatch('%s handler entry row %s but the gate model says %s' % (where, row, nxt))
        expected_i = row + 1
        if ctx.phase.get(row, 0) != phase:
            raise Mismatch('%s row %d entered with phase %d, model %d' % (where, row, phase, ctx.phase.get(row, 0)))
        nfx.append((FX['ENTER'], row, phase))
        status, why, fx, nm, res = nat.step(body, row, phase)
        last_status = status
        nfx.extend(fx)
        names.extend(nm)
        stats['steps'] += 1
        known_k1 = ctx.sc.get('known') == 'K1' and status == 3 and ctx.sc.get('k1_at') == ctx.tickno
        if known_k1:
            stats['known_observed']['K1:' + ctx.sc['id']] += 1
            if fx:
                raise Mismatch('%s K1 refusal had effects' % where)
            ctx.stop = True
            ctx.skip_final = True
            return 0
        if fatal is not None and n_i == len(entered) - 1:
            if status != 4:
                raise Mismatch('%s original reached fatal path %#x but native status %d (%s)' % (where, fatal, status, why))
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
    if fatal is None:
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt is not None:
            raise Mismatch('%s handler not entered for row %s although the gate model opens it' % (where, nxt))
    else:
        stats['fatal_paths_matched'] += 1
        ctx.stop = True
        if fatal != ctx.sc.get('expect_fatal'):
            raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
    compare_fx(where, x.fx, nfx)
    stats['effects'] += len(nfx)
    for t in x.fx:
        stats['effect_kinds'][FXN[t[0]]] += 1
    if x.loaded != names:
        raise Mismatch('%s loaded image names differ: original %r native %r' % (where, x.loaded, names))
    stats['image_loads'] += len(names)
    oc = (x.tick_i, x.busy_i)
    nc = nat.consumed()
    if oc != (nc[0], nc[1]) or nc[2] or nc[3] or nc[4]:
        raise Mismatch('%s queue consumption original %s native %s' % (where, oc, nc))
    stats['ticks_consumed'] += x.tick_i
    stats['busy_consumed'] += x.busy_i
    if nat.lib.d1o_bad_slot_calls(nat.h):
        raise Mismatch('%s native used an out-of-range slot' % where)
    if not entered:
        stats['gate_closed_ticks'] += 1
    compare_state(where, ctx)
    return len(entered)


def next_expected(ctx, mode, start_index):
    """First row at or after `start_index` (a row number minus `first`... as absolute row) the dispatcher enters."""
    if mode != 3:
        return None
    x = ctx.x
    for k in range(max(start_index - ctx.first, 0), len(ctx.rows)):
        row = ctx.first + k
        if ctx.complete.get(row, 0):
            continue
        if x.rd(ROWS + row * ROW + 0x85, 4) != bytes(4):
            continue
        if gate_open(ctx, ctx.rows[k]):
            return row
    return None


def do_pointer(ctx, where, px, py):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    body = active_body(ctx)
    save_c, save_cu, save_c2 = x.rs32(G_CAND), x.rd(G_CURSOR, 4), x.rd(G_CURSOR2, 4)
    x.w32(G_CAND, 0xfeedface)
    x.w32(G_CURSOR, 0x77)
    x.w32(G_CURSOR2, 0x88)
    hit = x.run_op(0x4b5d17, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000], OBJ) & 0xff
    c_new, cur_new, cur2 = x.rs32(G_CAND), x.rs32(G_CURSOR), x.rs32(G_CURSOR2)
    cand_written = c_new != s32(0xfeedface)
    cur_written = cur_new != 0x77
    if cand_written != cur_written or (cur2 != 0x88) != cur_written:
        raise Mismatch('%s original wrote cursor/candidate partially' % where)
    if not cand_written:
        x.w32(G_CAND, save_c)
        x.wr(G_CURSOR, save_cu)
        x.wr(G_CURSOR2, save_c2)
    if x.fx:
        raise Mismatch('%s original pointer receiver logged effects %s' % (where, x.fx))
    status, out = nat.pointer(body, px, py)
    if status != 0:
        raise Mismatch('%s native pointer status %d' % (where, status))
    nhit, ncand, ncur = out
    if hit != nhit:
        raise Mismatch('%s pointer return: original %d native %d' % (where, hit, nhit))
    if bool(hit) != cand_written:
        raise Mismatch('%s pointer return %d but candidate written %s' % (where, hit, cand_written))
    if cand_written:
        if c_new != ncand or cur_new != ncur or cur2 != 1:
            raise Mismatch('%s cursor/candidate: original %#x/%d/%d native %#x/%d' % (where, c_new, cur_new, cur2, ncand, ncur))
        ctx.cand = c_new
        stats['pointer_hits'] += 1
        # 0x4b6097 also fills the cursor entry (generic Z slot 2: +8 := [0x5d0377], +0xc := 0x5b160c + (index << 5) +
        # (1 << 4), +0x14 := 1); the engine owns it, the harness derives it from the cursor index the kernel reported
        nat.lib.d1o_set_entry_u32(nat.h, 2, 8, x.rs32(0x5d0377) & 0xffffffff)
        nat.lib.d1o_set_entry_u32(nat.h, 2, 0xc, (0x5b160c + (ncur << 5) + 16) & 0xffffffff)
        nat.lib.d1o_set_entry_u32(nat.h, 2, 0x14, 1)
    elif ncand != -1 or ncur != 0:
        raise Mismatch('%s native wrote cursor/candidate %d/%d, original did not' % (where, ncand, ncur))
    stats['pointer_moves'] += 1
    compare_state(where, ctx)


def do_click(ctx, where, cand=None, rowphase=None, flag=None):
    x, nat, stats, rows = ctx.x, ctx.nat, ctx.stats, ctx.rows
    if cand is not None:
        x.w32(G_CAND, cand)
        ctx.cand = s32(cand)
    if flag is not None:
        x.w32(START_FLAG, flag)
        nat.lib.d1o_set_world_flag(nat.h, flag)
    row = obj_row(ctx)
    if rowphase is not None and row is not None:
        x.w32(ROWS + row * ROW + PHASE_OFF, rowphase)
        ctx.phase[row] = rowphase
    rp = ctx.phase.get(row, 0) if row is not None else 0
    body = row_body(ctx, row) if row is not None else active_body(ctx)
    info = parse(body)
    last_tile = x.rs16(OBJ + 0x252)
    active, solved, state = x.rs32(OBJ + 0x225), x.rd(OBJ + 0x22a, 1)[0], x.rs32(OBJ + 0x274)
    acts = bool(active and not solved and state == 0 and rp == 1)
    if acts and ctx.cand == 0x276c and not (0 <= last_tile < info['n']):
        # K3: the original indexes out of range; native refuses before any effect
        status, newp, fx = nat.click(body, rp, ctx.cand, x.rs32(START_FLAG))
        if status != 6 or fx:
            raise Mismatch('%s K3 expected D1_ERR_BOUNDS without effects, got %d / %s' % (where, status, fx))
        stats['known_observed']['K3'] += 1
        return
    busy = ctx.pending_busy
    x.set_queues([], busy)
    nat.set_queues([], busy)
    x.run_op(0x4b617a, [], OBJ)
    status, newp, nfx = nat.click(body, rp, ctx.cand, x.rs32(START_FLAG))
    if status != 0:
        raise Mismatch('%s native click status %d' % (where, status))
    compare_fx(where, x.fx, nfx)
    stats['effects'] += len(nfx)
    for t in x.fx:
        stats['effect_kinds'][FXN[t[0]]] += 1
    nc = nat.consumed()
    if (x.busy_i, x.tick_i) != (nc[1], nc[0]) or nc[3] or nc[4]:
        raise Mismatch('%s click queue consumption original %s native %s' % (where, (x.busy_i, x.tick_i), nc))
    if row is not None:
        after = x.row_phase(row)
        if after != newp:
            raise Mismatch('%s click row phase: original %d native %d' % (where, after, newp))
        ctx.phase[row] = newp
    stats['clicks'] += 1
    stats['clicks_acting' if acts else 'clicks_ignored'] += 1
    compare_state(where, ctx)


def do_render(ctx, where, saved=0, back=0x22220000):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    row = x.rs16(OBJ + 0x1e)
    slot = x.rs16(OBJ + 0x1c)
    active = x.rs32(OBJ + 0x225)
    if not active or slot == -1 or row_body(ctx, row) is None:
        stats['render_skipped_unreachable'] += 1  # the entry is released: the engine never calls the callback
        return
    body = row_body(ctx, row)
    x.w32(G_BACK, back)
    x.blits = []
    x.fx = []
    x.call(0x4b7051, [], 0)
    status, plan = nat.plan(body)
    if status != 0:
        raise Mismatch('%s native plan status %d' % (where, status))
    stats['render_calls'] += 1
    bl = x.blits
    n = parse(body)['n']
    if not plan['valid'] or plan['count'] != len(bl) or len(bl) != n:
        raise Mismatch('%s blit count %d vs plan valid %d count %d (n=%d)' % (where, len(bl), plan['valid'], plan['count'], n))
    for i, b in enumerate(bl):
        stats['blit_calls'] += 1
        if b['src'] != plan['src'][i] or b['dst'] != plan['dst'][i]:
            raise Mismatch('%s blit %d rectangles: original %s/%s native %s/%s' % (where, i, b['src'], b['dst'], plan['src'][i], plan['dst'][i]))
        if b['src_surface'] != plan['surface'] or b['src_surface'] != x.entry_surface(slot):
            raise Mismatch('%s blit %d surface original %#x plan %#x' % (where, i, b['src_surface'], plan['surface']))
        if b['dst_surface'] != back:
            raise Mismatch('%s blit %d destination surface' % (where, i))
        if b['src_ptr'] != OBJ + 0x24 + 16 * i or b['dst_ptr'] != OBJ + 0x124 + 16 * i:
            raise Mismatch('%s blit %d rectangles are not the object windows' % (where, i))
        if b['label'] != LABEL_BLIT:
            raise Mismatch('%s blit %d label' % (where, i))
    if x.fx:
        raise Mismatch('%s render logged effects' % where)


def do_cleanup(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    x.run_op(0x4b5bc8, [], OBJ)
    status, nfx = nat.simple(lambda: nat.lib.d1o_cleanup(nat.h))
    if status != 0:
        raise Mismatch('%s native cleanup status %d' % (where, status))
    compare_fx(where, x.fx, nfx)
    stats['cleanups'] += 1
    stats['effects'] += len(nfx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = x.rs16(OBJ + 0x1c)
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        nat.lib.d1o_set_entry_u32(nat.h, slot, 0x14, 0)
    x.run_op(0x4b5c11, [], OBJ)
    status, nfx = nat.simple(lambda: nat.lib.d1o_invalidate(nat.h))
    if status != 0:
        raise Mismatch('%s native invalidate status %d' % (where, status))
    compare_fx(where, x.fx, nfx)
    stats['invalidates'] += 1
    compare_state(where, ctx)


def do_poke(ctx, where, pokes):
    """Force object bytes on both sides (states the game cannot reach, but the code paths are the original's)."""
    img = bytearray(ctx.nat.image())
    for off, data in pokes.items():
        ctx.x.wr(OBJ + off, data)
        img[off - IMG_FIRST:off - IMG_FIRST + len(data)] = data
    ctx.nat.set_image(bytes(img))
    ctx.stats['pokes'] += 1
    compare_state(where, ctx)


def fuzz_pokes(ctx):
    r = ctx.rng
    body = active_body(ctx)
    info = parse(body) if body else None
    n = info['n'] if info else 0
    F = info['F'] if info else 1
    S_ = info['S'] if info else 1
    p = {}
    if r.random() < 0.7:
        p[0x274] = struct.pack('<i', r.choice([0, 1, 2, 3, 4, 5, 5, 6, -1, 0x100]))
    if r.random() < 0.6:
        p[0x22c] = struct.pack('<h', r.choice([1, 1, 2, S_, S_ + 1, S_ - 1, 0, -1, 0x7fff]))
    if r.random() < 0.5:
        p[0x22b] = bytes([r.choice([0, 1, 2, 254, 255, r.randrange(256)])])
    if r.random() < 0.5:
        p[0x22a] = bytes([r.choice([0, 1])])
    if r.random() < 0.4:
        p[0x229] = bytes([r.choice([0, 1])])
    if r.random() < 0.3:
        p[0x224] = bytes([r.randrange(2)])
    if r.random() < 0.4:
        p[0x22e] = struct.pack('<I', r.choice([0, 1, 0x7fffffff, 0x80000000, 0xffffffff, r.randrange(1 << 32)]))
    if r.random() < 0.4:
        p[0x252] = struct.pack('<h', r.choice([-1, 0, 1, max(n - 1, 0), n, n + 1, 15, 16, -2]))
    for i in range(min(n + 1, 16)):
        if r.random() < 0.25:
            p[0x232 + 2 * i] = struct.pack('<h', r.choice([0, 1, 1, 2, -1, 0x100]))
        if r.random() < 0.3:
            p[0x254 + 2 * i] = struct.pack('<h', r.choice([-1, 0, 1, F - 2, F - 1, F, F + 1, r.randrange(-32768, 32768)]))
    return p


def sync_events(ctx):
    ctx.nat.set_events(ctx.x.events_raw())


def set_view(ctx, v):
    ctx.view = v
    ctx.x.w32(G_ORIGIN_X, v[0])
    ctx.x.w32(G_ORIGIN_Y, v[1])
    ctx.nat.set_view(*v)


def untilcheck(ctx, until):
    x = ctx.x
    row = obj_row(ctx)
    if until == 'idle':
        return row is not None and x.rs32(OBJ + 0x274) == 0 and x.rs32(OBJ + 0x225) != 0 and ctx.phase.get(row, 0) == 1 \
            and x.rd(OBJ + 0x22a, 1)[0] == 0
    if until == 'inactive':
        return x.rs32(OBJ + 0x225) == 0
    if until == 'done':
        return all(ctx.complete.get(r, 0) for r in range(ctx.first, ctx.first + len(ctx.rows)))
    if until == 'phase2':
        return row is not None and ctx.phase.get(row, 0) == 2
    if until == 'phase1':
        return row is not None and ctx.phase.get(row, 0) == 1
    return False


def run_scenario(x, lib, sc, stats):
    t0 = time.monotonic()
    before = (stats['steps'], stats['effects'], stats['ticks'])
    try:
        run_scenario_inner(x, lib, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['steps'] += stats['steps'] - before[0]
        g['effects'] += stats['effects'] - before[1]
        g['ticks'] += stats['ticks'] - before[2]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, lib, sc, stats):
    x.hard_reset()
    x.expect_fatal = sc.get('expect_fatal')
    x.handles = list(sc.get('handles', [0x7001, 0x7002, 0x7003, 0x7004]))
    x.handle_i = 0
    ctx = make_ctx(x, lib, sc, stats)
    ctx.stop = False
    ctx.skip_final = False
    ctx.tickno = 0
    ctx.pending_busy = [0] * 8
    nat = ctx.nat
    try:
        x.install_rows(ctx.rows, ctx.first)
        for r in range(ctx.first):
            ctx.complete[r] = 1
        x.cur_body = 0
        x.wr(G_MODE, struct.pack('<i', sc.get('mode', 3)))
        for idx, v in sc.get('events', {}).items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
        # seeds: the cells and the flag start non-zero so a skipped store cannot hide
        seeds = [0x11111111, 0x2222, -0x3333, 0x4444, 0x55555555, -0x66666666 & 0x7fffffff, 0x77777777]
        for (a, sz), v in zip(CELLS, seeds):
            x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
        cells = x.cells()
        nat.set_cells(cells)
        x.w32(START_FLAG, 5)
        nat.lib.d1o_set_world_flag(nat.h, 5)
        x.w32(G_CAND, 0)
        nat.set_handles(x.handles)
        set_view(ctx, VIEWS['v0'])
        for s in sc.get('busy_slots', []):
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            nat.lib.d1o_set_busy_slot(nat.h, s, 1)
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
                nat.lib.d1o_set_world_flag(nat.h, act[1])
            elif kind == 'events':
                for idx, v in act[1].items():
                    x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                sync_events(ctx)
            elif kind == 'rows':
                ctx.rows, ctx.first = list(act[1]), act[2]
                x.install_rows(ctx.rows, ctx.first)
                ctx.phase, ctx.complete = {}, {}
                for r in range(ctx.first):
                    ctx.complete[r] = 1
                sync_events(ctx)
            elif kind == 'busy':
                ctx.pending_busy = list(act[1])
            elif kind in ('poke', 'fuzz'):
                do_poke(ctx, where, act[1] if kind == 'poke' else fuzz_pokes(ctx))
            elif kind == 'ptr':
                do_pointer(ctx, where, act[1], act[2])
            elif kind == 'click':
                do_click(ctx, where, *act[1:])
            elif kind == 'invalidate':
                do_invalidate(ctx, where)
            elif kind == 'cleanup':
                # the scene teardown of the engine (0x438b76 / 0x43de6b): the rows go away with the object
                do_cleanup(ctx, where)
                if len(act) < 2:
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
                do_render(ctx, where, *act[1:])
            elif kind == 'tick':
                ctx.tickno += 1
                do_tick(ctx, where, act[1] if len(act) > 1 else {})
            elif kind == 'run':
                spec, until, mx = act[1], act[2], act[3]
                for _ in range(mx):
                    ctx.tickno += 1
                    do_tick(ctx, where, spec)
                    if ctx.stop or untilcheck(ctx, until):
                        break
            elif kind == 'refuse':  # native-only safety check (K2/K4/K5): the body is refused before any effect
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
        status, why, fx, nm, res = nat.step(body, 0, act[3])
        if status != 2 or fx:
            raise Mismatch('%s K2 expected D1_ERR_BODY without effects, got %d (%s) / %s' % (where, status, why, fx))
        stats['known_observed']['K2:' + act[4]] += 1
    elif what == 'unwound':
        status, why, fx, nm, res = nat.step(body, 0, act[3])
        if status != 3 or fx:
            raise Mismatch('%s K5 expected D1_ERR_UNSUPPORTED without effects, got %d (%s) / %s' % (where, status, why, fx))
        stats['known_observed']['K5:' + act[4]] += 1
    elif what == 'flag_index':
        # drive the native kernel to the solved finish (no sound, flag byte 0): phase 0, solved check, start, then phase 2
        ctx.skip_final = True
        ctx.nat.set_queues([], [])
        for ph in (0, 1, 1):
            st, why, fx, nm, res = nat.step(body, 0, ph)
            if st != 0:
                raise Mismatch('%s K4 setup step failed %d (%s)' % (where, st, why))
        st, why, fx, nm, res = nat.step(body, 0, 2)
        if st != 6 or fx:
            raise Mismatch('%s K4 expected D1_ERR_BOUNDS without effects, got %d (%s) / %s' % (where, st, why, fx))
        stats['known_observed']['K4'] += 1
    elif what == 'validate':
        st = nat.lib.d1o_validate(cbuf(body), len(body))
        if st != 2:
            raise Mismatch('%s K2 expected D1_ERR_BODY for a short body, got %d' % (where, st))
        stats['known_observed']['K2:' + act[4]] += 1
    else:
        raise OracleError('unknown refusal ' + what)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def clamp16(v):
    return max(-32768, min(32767, v))


def ptr_points(info, extra_rng=None, extra=0):
    pts = []
    for r in info['hit'] + [info['exit_rect']]:
        l, t, rr, b = r
        for p in ((l, t), (rr, b), (l - 1, t), (l, t - 1), (rr + 1, b), (rr, b + 1), ((l + rr) // 2, (t + b) // 2),
                  (l, b), (rr, t), (l - 1, b + 1), (rr + 1, t - 1)):
            pts.append((clamp16(p[0]), clamp16(p[1])))
    pts += [(0, 0), (-1, -1), (32767, 32767), (-32768, -32768), (5, 5)]
    if extra_rng is not None:
        for _ in range(extra):
            pts.append((extra_rng.randrange(-80, 700), extra_rng.randrange(-80, 420)))
    return pts


def center(r):
    return clamp16((r[0] + r[2]) // 2), clamp16((r[1] + r[3]) // 2)


def S(scs, sid, rows, actions, group, **kw):
    sc = dict(id=sid, rows=rows, actions=actions, group=group, quick=kw.pop('quick', False), first=kw.pop('first', 0))
    sc.update(kw)
    scs.append(sc)
    return sc


def R(body, subtype=1, tail=b''):
    return dict(body=body, tail=tail, subtype=subtype)


CLK = dict(ticks='clock', busy='zero')
CLKR = dict(ticks='clock', busy='rand')


def play_to_solution(info, rng, spec=CLK, reps=1):
    """Clicks that solve the puzzle (when a solution is known), each followed by ticks until idle."""
    sol = solve_clicks(info)
    acts = []
    if sol is None:
        return acts
    for k, cnt in enumerate(sol):
        for _ in range(cnt):
            acts += [('ptr',) + center(info['hit'][k]), ('click',), ('run', spec, 'idle', 40)]
    return acts


def tour(rng, info, solve=True, exit_at_end=False, sweeps=True, renders=True, spec=CLK):
    """init, pointer sweep over the edges of every rectangle, turn each tile once, then solve or exit."""
    acts = [('tick', spec), ('tick', spec)]
    if sweeps:
        for i, (px, py) in enumerate(ptr_points(info, rng, 3)):
            acts.append(('ptr', px, py))
            if renders and i % 5 == 0:
                acts.append(('render', 0x1000 + i, 0x22220000 + i))
            if i % 9 == 0:
                acts.append(('tick', spec))
    for k in range(min(info['n'], 3)):
        acts += [('ptr',) + center(info['hit'][k]), ('click',), ('tick', spec), ('ptr',) + center(info['hit'][k]),
                 ('render', 1, 0x22220000), ('run', spec, 'idle', 40)]
    acts.append(('invalidate',))
    if solve:
        acts += play_to_solution(parse_after(info, acts_turns=min(info['n'], 3)), rng, spec)
        acts += [('run', spec, 'done', 120)]
    elif exit_at_end:
        acts += [('ptr',) + center(info['exit_rect']), ('click',), ('run', spec, 'done', 30)]
    return acts


def parse_after(info, acts_turns):
    """Info whose init is the frames after the first `acts_turns` single turns of tour()."""
    f = list(info['init'])
    for k in range(acts_turns):
        f = turn(info, f, k)
    out = dict(info)
    out['init'] = f
    return out


def scenario_list(seed=35):
    rng = random.Random(seed)
    scs = []
    nat_names = [b'NO SOUND', b'TURN_CLICK', b'NO SOUNDX', b'NO SOUN', b'']

    # -- before init: everything is inert
    b0 = make_body(rng, n=3, F=4)
    S(scs, 'pre:inert', [R(b0)], [('ptr', 5, 5), ('click',), ('click', 0x276c), ('click', 0x276d), ('invalidate',),
                                  ('cleanup',), ('render', 1, 2), ('ptr', 7, 9), ('cleanup',), ('invalidate',)], 'basic', quick=True)

    # -- the 11 corpus bodies
    cb = corpus_bodies()
    for i, spec in enumerate(cb):
        info = parse(spec['body'])
        solve = i % 2 == 0
        acts = tour(rng, info, solve=solve, exit_at_end=not solve)
        if solve:
            acts += [('tick', CLK), ('tick', CLK)]
        S(scs, 'corpus:%02d_%s' % (i, 'solve' if solve else 'exit'), [R(spec['body'], spec['subtype'], spec['tail'])], acts,
          'corpus', quick=i in (0, 3, 6), seed=i)
    # corpus bodies: random clicks and ticks without a solution, then abandoned by cleanup and re-entered
    for i in (1, 5, 8):
        spec = cb[i]
        info = parse(spec['body'])
        acts = [('tick', CLK)]
        for r in range(14):
            k = rng.randrange(info['n'])
            acts += [('ptr',) + center(info['hit'][k]), ('click',), ('run', CLKR, 'idle', 30)]
        acts += [('cleanup',), ('tick', CLK), ('invalidate',), ('revive',), ('tick', CLK), ('tick', CLK)]
        S(scs, 'corpus:%02d_random_abandon' % i, [R(spec['body'], spec['subtype'], spec['tail'])], acts, 'corpus', seed=100 + i)
    # all corpus rows in one scene (singleton re-init across completions: each one completes subtype 1)
    rows = [R(cb[0]['body'], cb[0]['subtype'], cb[0]['tail'])] + \
           [R(c['body'], c['subtype'], struct.pack('<8h', 2, 100 + k, 1, 0, 0, 0, 0, 0)) for k, c in enumerate(cb[1:3])]
    acts = []
    for r in range(3):
        acts += [('events', {99 + r: 1}), ('tick', CLK), ('tick', CLK), ('ptr',) + center(parse(cb[r]['body'])['exit_rect']), ('click',),
                 ('run', CLK, 'phase2', 5), ('tick', CLK)]
    S(scs, 'corpus:three_rows_exit_chain:dep', rows, [('events', {99: 0, 100: 0, 101: 0}), ('tick', CLK), ('ptr', 1, 1)] + acts, 'corpus', seed=7,
      handles=[0x7201, 0x7202, 0x7203, 0x7204])

    # -- matrix over tile count, frames, sub-steps, row flag
    mi = 0
    for n in (0, 1, 6, 16):
        for F in (1, 2, 7):
            for Sx in (1, 2, 4):
                for rowflag in (0, 1):
                    mi += 1
                    links = [[(rng.randrange(0, n + 1) if rng.random() < 0.5 else 0) for _ in range(4)] for _ in range(n)]
                    init = [rng.randrange(F) for _ in range(n)]
                    # the target is reached after one turn of tile 0 (or is the initial state when n == 0)
                    tgt = turn(dict(n=n, F=F, links=links), init, 0) if n else []
                    body = make_body(rng, n=n, F=F, S=Sx, init=init, target=tgt, rowflag=rowflag, links=links,
                                     T=rng.choice([1, 3, 20]), M=rng.choice([1, 2]), flag=rng.randrange(2))
                    info = parse(body)
                    acts = [('tick', CLK), ('tick', CLK)]
                    if n:
                        acts += [('ptr',) + center(info['hit'][0]), ('click',), ('run', CLK, 'done', 90)]
                    else:
                        acts += [('run', CLK, 'done', 90)]
                    acts += [('tick', CLK)]
                    S(scs, 'matrix:n%d_F%d_S%d_rf%d' % (n, F, Sx, rowflag), [R(body)], acts, 'matrix',
                      quick=(n, F, Sx, rowflag) in ((6, 7, 2, 1), (16, 2, 4, 0), (1, 1, 1, 1), (0, 7, 1, 0), (6, 2, 1, 0)),
                      seed=mi)

    # -- the same shapes with interaction (pointer sweep + clicks, no solution -> exit)
    for n, F, Sx in ((6, 7, 1), (6, 2, 2), (16, 7, 4), (1, 2, 1), (3, 4, 3)):
        links = [[(rng.randrange(0, n + 1) if rng.random() < 0.6 else 0) for _ in range(4)] for _ in range(n)]
        body = make_body(rng, n=n, F=F, S=Sx, links=links, target=[(rng.randrange(F)) for _ in range(n)], T=2, M=2)
        info = parse(body)
        S(scs, 'interact:n%d_F%d_S%d' % (n, F, Sx), [R(body)], tour(rng, info, solve=True, exit_at_end=True), 'interact',
          seed=n * 10 + F, quick=(n, F, Sx) in ((6, 7, 1),))

    # -- sound names x flag byte x win-sound presence
    for snd0 in nat_names[:4]:
        for snd1 in (b'NO SOUND', b'WIN_FANFARE', b'NO SOUNDX'):
            for flag in (0, 1):
                for ch0, ch1 in ((7, 8), (-3, 0x7fff)):
                    n = 3
                    init = [1, 2, 0]
                    body = make_body(rng, n=n, F=3, S=2, init=init, target=init if flag == 0 else turn(dict(n=3, F=3, links=[[0] * 4] * 3), init, 1),
                                     flag=flag, snd0=snd0, snd1=snd1, ch0=ch0, ch1=ch1, T=1, M=1)
                    info = parse(body)
                    acts = [('tick', CLK), ('tick', CLK), ('ptr',) + center(info['hit'][1]), ('click',), ('run', CLKR, 'done', 80)]
                    S(scs, 'sound:%s_%s_f%d_c%d' % (snd0.decode().replace(' ', '_') or 'empty', snd1.decode().replace(' ', '_'), flag, ch0),
                      [R(body)], acts, 'sound', seed=len(scs),
                      quick=(snd0, snd1, flag, ch0) in ((b'TURN_CLICK', b'WIN_FANFARE', 1, 7), (b'NO SOUND', b'WIN_FANFARE', 0, 7),
                                                        (b'TURN_CLICK', b'NO SOUND', 1, -3), (b'NO SOUNDX', b'NO SOUND', 0, 7)))

    # -- the win-sound busy script: busy answers 1,1,0 etc. in the waiting states
    body = make_body(rng, n=2, F=3, S=2, init=[0, 1], target=[0, 1], flag=1, snd0=b'TURN_CLICK', snd1=b'WIN_FANFARE', T=2, M=1)
    for nb, busy in enumerate(([0] * 8, [1, 1, 0, 0] + [0] * 4, [1] * 8, [0, 1, 1, 0, 1, 0, 0, 0], [2, -1, 0, 0])):
        S(scs, 'sound:busy_script%d' % nb, [R(body)],
          [('tick', CLK), ('busy', busy), ('run', dict(ticks='clock', busy=busy), 'done', 100), ('tick', CLK)], 'sound', seed=nb,
          quick=nb in (1, 3))

    # -- finish blocks: scene 9999 / valid, flag -1 / valid, start word 1 / other, solved vs exit
    blocks = [scene_block(9999, (0, 0, 0), (0, 0, 0), 0, -1, 0), scene_block(9999, (1, 1, 1), (2, 2, 2), 1, 5, 200),
              scene_block(1234, (-1, -2, -3), (-4, 0x7fffffff, -0x80000000), 1, -1, 7),
              scene_block(-5, (32767, -32768, 0), (1, 2, 3), 0, 4095, 255),
              scene_block(0, (0, 0, 0), (0, 0, 0), 2, 0, 0), scene_block(4377, (9, 8, 7), (6, 5, 4), -1, 1984, 1)]
    for bi, blk in enumerate(blocks):
        for solved in (True, False):
            for other in (blocks[0], blocks[2]):
                init = [1, 1]
                body = make_body(rng, n=2, F=3, S=1, init=init, target=init if solved else [2, 2], win=blk, exit_=other, T=1)
                info = parse(body)
                acts = [('tick', CLK)]
                acts += [('run', CLK, 'done', 80)] if solved else [('ptr',) + center(info['exit_rect']), ('click',), ('run', CLK, 'done', 10)]
                if bi % 2:
                    acts = [('events', {5: 77, 4095: 66, 1984: 55})] + acts
                S(scs, 'finish:b%d_%s_o%d' % (bi, 'win' if solved else 'exit', blocks.index(other)), [R(body)], acts, 'finish',
                  quick=bi in (1, 2, 3), seed=bi)
    # exit block applied even when solved earlier is impossible (click ignored once solved); forced phase 2 variants
    body = make_body(rng, n=2, F=3, init=[1, 1], target=[2, 2], win=blocks[2], exit_=blocks[1])
    S(scs, 'finish:forced_phase2_unsolved', [R(body)], [('tick', CLK), ('setphase', 0, 2), ('tick', CLK), ('tick', CLK)], 'finish', quick=True)
    S(scs, 'finish:forced_phase2_after_clicks', [R(body)],
      [('tick', CLK), ('ptr',) + center(parse(body)['hit'][0]), ('click',), ('run', CLK, 'idle', 20), ('setphase', 0, 2), ('tick', CLK)], 'finish')
    S(scs, 'finish:phase3_noop', [R(body)], [('tick', CLK), ('setphase', 0, 3), ('tick', CLK), ('tick', CLK), ('setphase', 0, 9), ('tick', CLK)], 'finish', quick=True)
    S(scs, 'finish:subtype2_repeat', [R(body, 2)],
      [('tick', CLK), ('ptr',) + center(parse(body)['exit_rect']), ('click',), ('run', CLK, 'done', 4), ('tick', CLK), ('tick', CLK),
       ('ptr',) + center(parse(body)['exit_rect']), ('click',), ('run', CLK, 'phase2', 6), ('tick', CLK), ('tick', CLK)], 'finish', quick=True)

    # -- deadlines and clocks: T, M, S, base values (wrap, sign), step sizes
    for cname in CLOCKS:
        for T in (0, 1, 20, 32767, -7):
            for Sx in (1, 3):
                body = make_body(rng, n=2, F=3, S=Sx, init=[0, 1], target=[1, 2], links=[[2, 0, 0, 0], [0, 0, 0, 0]], T=T, M=2, flag=0)
                info = parse(body)
                acts = [('clock', cname), ('tick', CLK), ('ptr',) + center(info['hit'][0]), ('click',), ('run', dict(ticks='clock', busy='zero', steps=(0, 1, 2, 50, 4000, 1 << 31)), 'done', 150)]
                S(scs, 'clock:%s_T%d_S%d' % (cname, T, Sx), [R(body)], acts, 'clock', seed=T + Sx,
                  quick=(cname, T, Sx) in (('sign', 20, 1), ('wrap', 20, 3), ('mid', 1, 1), ('top', 0, 1)))
    # tick policies relative to the deadline in every waiting state
    body = make_body(rng, n=3, F=3, S=2, init=[0, 1, 2], target=[1, 2, 0], links=[[2, 3, 0, 0], [0, 0, 0, 0], [1, 0, 0, 0]], T=5, M=3, flag=0)
    info = parse(body)
    for pol in ('dl', 'rand'):
        for cnt in range(3):
            acts = [('tick', CLK), ('ptr',) + center(info['hit'][0]), ('click',)]
            acts += [('run', dict(ticks=pol, busy='rand'), 'done', 150)]
            S(scs, 'clock:policy_%s_%d' % (pol, cnt), [R(body)], acts, 'clock', seed=cnt, quick=(pol == 'dl' and cnt == 0))
    # auto-turn counters: M and F so that the counter byte passes 255
    for M, F in ((1, 2), (3, 7), (80, 5), (127, 3), (200, 3), (0, 4), (-2, 4)):
        body = make_body(rng, n=2, F=F, S=1, init=[0, 1], target=[0, 1], T=0, M=M, flag=0)
        S(scs, 'auto:M%d_F%d' % (M, F), [R(body)], [('tick', CLK), ('run', dict(ticks='clock', busy='zero', steps=(1,)), 'done', 1200)], 'auto',
          quick=(M, F) in ((3, 7), (200, 3), (0, 4)))

    # -- geometry: sizes, origins, row flag, view origins incl. negative / wrapping values
    geo = [((51, 67), (0, 0), 0), ((51, 67), (100, 200), 1), ((-5, -9), (-300, -400), 1), ((0, 0), (0, 0), 1), ((1, 1), (5, 5), 0),
           ((32767, 32767), (0x7fffff00, 0x7ffffff0), 1), ((-32768, 32767), (-0x7fffff00, -0x7ffffff0), 1), ((300, 200), (-1, -1), 0)]
    for gi, (tile, origin, rf) in enumerate(geo):
        for vname in ('v0', 'neg', 'edge'):
            body = make_body(rng, n=4, F=5, S=3, tile=tile, origin=origin, rowflag=rf, init=[0, 1, 2, 3], target=[1, 1, 2, 3],
                             links=[[2, 0, 0, 0], [0] * 4, [4, 3, 0, 0], [0] * 4], dst=[(-100 + 7 * i, -50 + 9 * i, 0x7fffff00 if gi == 5 else 80 + i, 90) for i in range(4)])
            info = parse(body)
            acts = [('view', vname), ('tick', CLK), ('ptr',) + center(info['hit'][0]), ('click',), ('render', 1, 0x22220000),
                    ('run', CLK, 'done', 60), ('render', 2, 0x22220000)]
            S(scs, 'geometry:%d_%s' % (gi, vname), [R(body)], acts, 'geometry', seed=gi, quick=(gi, vname) in ((1, 'v0'), (2, 'neg'), (5, 'edge'), (6, 'neg')))

    # -- pointer matrix: rectangle edges, overlap, exit, moving tile, coordinates at the short limits
    for ov in (False, True):
        dst = [(10, 20, 60, 90), (70, 20, 120, 90), (130, 20, 180, 90), (190, 20, 240, 90)]
        hit = [(10, 20, 60, 90), (55, 20, 120, 90), (125, 25, 185, 95), (-5, -5, 5, 5)] if ov else \
              [(10, 20, 60, 90), (70, 20, 120, 90), (130, 20, 180, 90), (190, 20, 240, 90)]
        body = make_body(rng, n=4, F=4, S=2, dst=dst, hit=hit, exit_rect=(300, 300, 340, 330), init=[0, 1, 2, 3], target=[1, 1, 2, 3],
                         links=[[2, 3, 0, 0], [0] * 4, [4, 0, 0, 0], [0] * 4], T=1)
        info = parse(body)
        acts = [('tick', CLK)]
        for i, (px, py) in enumerate(ptr_points(info, rng, 10)):
            acts.append(('ptr', px, py))
        acts += [('ptr',) + center(info['hit'][0]), ('click',)]
        for i, (px, py) in enumerate(ptr_points(info, rng, 4)):          # while a tile is turning
            acts += [('ptr', px, py), ('tick', CLK)]
        acts += [('run', CLK, 'idle', 60)]
        S(scs, 'pointer:%s' % ('overlap' if ov else 'grid'), [R(body)], acts, 'pointer', quick=ov, seed=int(ov))
    # exit rectangle degenerate / inverted / negative, hit rectangles inverted
    body = make_body(rng, n=2, F=3, S=1, hit=[(50, 50, 10, 10), (-20, -20, -10, -10)], exit_rect=(5, 5, 5, 5), dst=[(0, 0, 9, 9)] * 2)
    S(scs, 'pointer:degenerate', [R(body)], [('tick', CLK)] + [('ptr', px, py) for px, py in ptr_points(parse(body), rng, 8)] +
      [('ptr', 5, 5), ('click',), ('run', CLK, 'done', 8)], 'pointer', quick=True)

    # -- click matrix: candidates x state x row phase x start flag
    body = make_body(rng, n=3, F=4, S=2, init=[0, 1, 2], target=[3, 3, 3], links=[[2, 0, 0, 0], [0] * 4, [1, 0, 0, 0]], snd0=b'TURN_CLICK', flag=1)
    info = parse(body)
    for cand in (0x276c, 0x276d, 0, 5, -1, 0x276e, 0x2760):
        for rp in (None, 0, 2, 3):
            for flg in (0, 1, 7):
                if (cand, rp, flg) not in ((0x276c, None, 1), (0x276c, None, 0), (0x276d, None, 1), (0x276d, 2, 0), (0, None, 1), (-1, None, 1), (0x276c, 0, 1), (0x276c, 3, 7), (0x276e, None, 1), (0x2760, 2, 1), (5, 3, 0)) \
                        and rng.random() < 0.75:
                    continue
                acts = [('tick', CLK), ('ptr',) + center(info['hit'][1])]
                acts += [('click', cand, rp, flg), ('tick', CLK), ('click', cand, rp, flg), ('run', CLK, 'idle', 20),
                         ('ptr',) + center(info['hit'][2]), ('click', 0x276c, None, 1)]
                S(scs, 'click:c%x_rp%s_f%d' % (cand & 0xffffffff, rp, flg), [R(body)], acts, 'click', seed=cand,
                  quick=(cand, rp, flg) in ((0x276c, None, 1), (0x276d, 2, 0), (0, None, 1), (0x276c, 0, 1), (0x276c, 3, 7)))
    # clicks while moving, while solved, with busy answers
    S(scs, 'click:while_moving', [R(body)],
      [('tick', CLK), ('ptr',) + center(info['hit'][0]), ('click',), ('click',), ('tick', CLK), ('click',), ('ptr',) + center(info['hit'][2]), ('click',), ('tick', CLK),
       ('click',), ('run', CLK, 'idle', 20), ('click',)], 'click', quick=True)
    for busy in ([1, 1, 1, 1], [0], [1, 0], [2], [-1]):
        S(scs, 'click:busy%s' % ''.join(map(str, [abs(b) for b in busy])), [R(body)],
          [('tick', CLK), ('ptr',) + center(info['hit'][0]), ('busy', busy), ('click',), ('click',), ('tick', CLK), ('run', CLK, 'idle', 10), ('click',)], 'click',
          quick=busy == [1, 0])
    body_s = make_body(rng, n=2, F=3, S=1, init=[1, 1], target=[1, 1], snd1=b'WIN', snd0=b'TURN')
    # unreachable object states forced on both sides (the code paths are still the original's)
    bx = make_body(rng, n=2, F=3, S=2, init=[1, 1], target=[1, 1], win=blocks[2], exit_=blocks[1], snd0=b'TURN', snd1=b'WIN')
    S(scs, 'poke:exit_and_solved', [R(bx)], [('tick', CLK), ('poke', {0x229: b'\1', 0x22a: b'\1'}), ('setphase', 0, 2), ('tick', CLK), ('tick', CLK)], 'poke', quick=True)
    S(scs, 'poke:solved_no_exit', [R(bx)], [('tick', CLK), ('poke', {0x22a: b'\1'}), ('setphase', 0, 2), ('tick', CLK), ('tick', CLK)], 'poke')
    S(scs, 'poke:invalidate_inactive_with_slot', [R(bx)], [('tick', CLK), ('poke', {0x225: struct.pack('<i', 0)}), ('invalidate',), ('poke', {0x1c: struct.pack('<h', -1), 0x225: struct.pack('<i', 1)}), ('invalidate',)], 'poke', quick=True)
    for k in range(10):
        S(scs, 'poke:fuzz%d' % k, [R(make_body(rng, n=rng.choice([2, 4, 6]), F=rng.choice([2, 3, 7]), S=rng.choice([1, 2, 3]), T=rng.choice([1, 5]), M=rng.choice([1, 3]),
                                              flag=rng.randrange(2), snd0=rng.choice([b'NO SOUND', b'TURN']), snd1=rng.choice([b'NO SOUND', b'WIN'])))],
          [('tick', CLK), ('tick', CLK)] + [a for _ in range(25) for a in (('fuzz',), ('tick', CLKR), ('tick', CLKR), ('click', 0x276c, None, 1))] +
          [('run', CLK, 'done', 60)], 'poke', seed=k, quick=k < 3)
    # the counter byte survives a re-init: two solved-at-once puzzles in a row with the auto-turn on
    for M, F in ((2, 3), (1, 4)):
        b1 = make_body(rng, n=2, F=F, S=1, init=[0, 1], target=[0, 1], flag=1, snd0=b'TURN', M=M, T=0, win=scene_block(9999, (0, 0, 0), (0, 0, 0), 0, 11, 1))
        b2 = make_body(rng, n=2, F=F, S=1, init=[1, 1], target=[1, 1], flag=1, snd0=b'TURN', M=M, T=0, win=scene_block(9999, (0, 0, 0), (0, 0, 0), 0, 12, 1))
        S(scs, 'auto:counter_survives_reinit_M%d' % M, [R(b1, 1), R(b2, 1, struct.pack('<8h', 2, 11, 1, 0, 0, 0, 0, 0))],
          [('tick', CLK), ('run', dict(ticks='clock', busy='zero', steps=(1,)), 'done', 400)], 'auto', quick=M == 2, handles=[0x7301, 0x7302, 0x7303])
    # K3: the retained tile index names no tile (the pointer left every rectangle, or sits on the exit), then a tile click
    S(scs, 'click:K3_no_tile', [R(body)], [('tick', CLK), ('ptr', -500, -500), ('click', 0x276c), ('ptr',) + center(info['exit_rect']), ('click', 0x276c, None, 1),
                                           ('ptr',) + center(info['hit'][1]), ('click', 0x276c, None, 1), ('run', CLK, 'idle', 20)], 'click', quick=True)
    S(scs, 'click:when_solved', [R(body_s)], [('tick', CLK), ('tick', CLK), ('ptr',) + center(parse(body_s)['hit'][0]), ('click',), ('click', 0x276d), ('run', CLK, 'done', 50)], 'click')

    # -- rows: singleton re-init, chains, re-entry, false gates
    ba = make_body(rng, name=b'ROW_A', n=3, F=3, S=1, init=[0, 1, 2], target=[0, 1, 2], win=scene_block(100, (1, 2, 3), (4, 5, 6), 0, 7, 9))
    bb = make_body(rng, name=b'ROW_B', n=2, F=4, S=2, init=[3, 3], target=[3, 3], win=scene_block(200, (1, 2, 3), (4, 5, 6), 1, 8, 3))
    tail_b = struct.pack('<8h', 2, 7, 9, 0, 0, 0, 0, 0)
    S(scs, 'rows:chain_dep', [R(ba), R(bb, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('run', CLK, 'done', 90), ('tick', CLK), ('events', {7: 9}),
                                                         ('run', CLK, 'done', 90), ('tick', CLK)], 'rows', quick=True, handles=[0x7101, 0x7102, 0x7103])
    S(scs, 'rows:chain_subtype2', [R(ba, 2), R(bb, 2, tail_b)], [('tick', CLK), ('run', CLK, 'done', 8), ('tick', CLK), ('events', {7: 9}), ('tick', CLK),
                                                                  ('tick', CLK), ('run', CLK, 'phase2', 10), ('tick', CLK)], 'rows', handles=[0x7101, 0x7102, 0x7103, 0x7104])
    S(scs, 'rows:reinit_no_cleanup', [R(ba)],
      [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('rows', [R(bb)], 0), ('tick', CLK), ('ptr', 11, 22), ('tick', CLK), ('render', 3, 4), ('cleanup',)], 'rows', quick=True)
    S(scs, 'rows:cleanup_reinit', [R(ba)],
      [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('cleanup',), ('tick', CLK), ('revive',), ('tick', CLK), ('tick', CLK), ('rows', [R(bb)], 0), ('tick', CLK), ('tick', CLK),
       ('render', 1, 2), ('invalidate',), ('cleanup',), ('cleanup',), ('invalidate',), ('tick', CLK)], 'rows', quick=True)
    S(scs, 'rows:offset_first_row:dep', [R(ba), R(bb, 1, tail_b)], [('tick', CLK), ('ptr', 1, 1), ('tick', CLK), ('run', CLK, 'done', 90), ('tick', CLK)], 'rows', first=2,
      handles=[0x7101, 0x7102, 0x7103])
    S(scs, 'rows:K1_two_active', [R(ba), R(bb)], [('tick', CLK), ('tick', CLK)], 'known', known='K1', k1_at=2)
    S(scs, 'gate:false_dep', [R(ba, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',), ('events', {7: 9}), ('tick', CLK), ('tick', CLK),
                                                   ('events', {7: 8}), ('tick', CLK), ('events', {7: 9}), ('tick', CLK)], 'gate', quick=True)
    S(scs, 'gate:mode4', [R(ba)], [('mode', 4), ('tick', CLK), ('tick', CLK), ('mode', 3), ('tick', CLK), ('tick', CLK)], 'gate', mode=4)
    ba2 = make_body(rng, name=b'ROW_A2', n=3, F=3, S=1, init=[0, 1, 2], target=[0, 1, 2], win=scene_block(9999, (1, 2, 3), (4, 5, 6), 0, 7, 9))
    S(scs, 'gate:opens_in_same_dispatch:dep', [R(ba2), R(bb, 1, tail_b)], [('tick', CLK), ('run', CLK, 'done', 90), ('tick', CLK), ('run', CLK, 'done', 90)],
      'gate', handles=[0x7101, 0x7102, 0x7103], quick=True)
    S(scs, 'gate:mode4_blocks_same_dispatch:dep', [R(ba), R(bb, 1, tail_b)], [('tick', CLK), ('run', CLK, 'done', 90), ('mode', 3), ('tick', CLK), ('run', CLK, 'done', 90)],
      'gate', handles=[0x7101, 0x7102, 0x7103])

    # -- invalidate with and without a slot, cleanup on every state
    S(scs, 'invalidate:slot_states', [R(ba)], [('invalidate',), ('tick', CLK), ('invalidate',), ('tick', CLK), ('cleanup',), ('invalidate',), ('tick', CLK),
                                               ('revive',), ('invalidate',), ('tick', CLK), ('invalidate',)], 'cleanup', quick=True)
    mv = make_body(rng, n=3, F=4, S=3, init=[0, 1, 2], target=[3, 3, 3], links=[[2, 3, 0, 0], [0] * 4, [0] * 4])
    mvi = parse(mv)
    for stage in range(6):
        acts = [('tick', CLK), ('ptr',) + center(mvi['hit'][0]), ('click',)]
        acts += [('tick', CLK)] * stage
        acts += [('cleanup',), ('invalidate',), ('tick', CLK), ('revive',), ('tick', CLK), ('tick', CLK), ('render', 1, 2), ('ptr', 4, 4)]
        S(scs, 'cleanup:moving_stage%d' % stage, [R(mv)], acts, 'cleanup', quick=stage == 2)

    # -- generic Z entry allocation: busy seeds, first free, exhaustion
    S(scs, 'slots:busy_low', [R(ba)], [('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x19, 0x1a], quick=True)
    S(scs, 'slots:busy_gap', [R(ba)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x1a, 0x1b, 0x3e])
    S(scs, 'slots:last_free', [R(ba)], [('tick', CLK), ('ptr', 2, 2), ('render', 1, 1), ('run', CLK, 'done', 80)], 'slots', busy_slots=list(range(0x18, 0x3f)), quick=True)
    S(scs, 'slots:exhausted', [R(ba)], [('tick', CLK)], 'slots', busy_slots=list(range(0x18, 0x40)), expect_fatal=0x52139c, quick=True)
    S(scs, 'slots:below_range_ignored', [R(ba)], [('tick', CLK), ('cleanup',)], 'slots', busy_slots=[0x00, 0x10, 0x17, 0x40, 0x57])

    # -- image names and handles
    for k, nm in enumerate((b'A', b'0123456789ABCDEF0123456789ABCDEF', b'', b'x' * 5)):
        body = make_body(rng, name=nm, n=2, F=2)
        S(scs, 'name:%d' % k, [R(body)], [('tick', CLK), ('tick', CLK), ('cleanup',), ('tick', CLK), ('revive',), ('tick', CLK)], 'basic', quick=k == 1)
    S(scs, 'surface:handle_zero', [R(ba, 2)], [('tick', CLK), ('run', CLK, 'phase2', 4), ('tick', CLK), ('tick', CLK)], 'basic', handles=[0, 0x55, 0x66])

    # -- native safety layer (expected differences)
    good = make_body(rng, n=3, F=3, S=2)
    bad = bytearray(good)
    struct.pack_into('<h', bad, B_SUBSTEPS, 0)
    S(scs, 'known:K2_substeps_zero', [R(good)], [('refuse', 'body', bytes(bad), 0, 'substeps')], 'known')
    bad = bytearray(good)
    struct.pack_into('<h', bad, B_COUNT, 17)
    S(scs, 'known:K2_tiles_17', [R(good)], [('refuse', 'body', bytes(bad), 0, 'tiles')], 'known')
    bad = bytearray(good)
    struct.pack_into('<h', bad, B_LINKS, 17)
    S(scs, 'known:K2_link_17', [R(good)], [('refuse', 'body', bytes(bad), 1, 'link')], 'known')
    S(scs, 'known:K5_phase1_uninit', [R(good)], [('refuse', 'unwound', good, 1, 'phase1'), ('refuse', 'unwound', good, 2, 'phase2')], 'known')
    badf = make_body(rng, n=2, F=2, S=1, init=[0, 0], target=[0, 0], win=scene_block(9999, (0, 0, 0), (0, 0, 0), 0, 5000, 1))
    S(scs, 'known:K4_flag_index', [R(badf)], [('refuse', 'flag_index', badf)], 'known')
    S(scs, 'known:K2_short_validate', [R(good)], [('refuse', 'validate', good[:926], 2, 'short2')], 'known')
    return scs, rng


def random_scenarios(count, seed=3535):
    rng = random.Random(seed)
    scs = []
    for n in range(count):
        r = random.Random(rng.randrange(1 << 30))
        nn = r.choice([0, 1, 2, 3, 4, 6, 6, 8, 12, 16])
        F = r.choice([1, 2, 3, 4, 7, 7, 9])
        Sx = r.choice([1, 1, 2, 3, 4])
        init = [r.randrange(F) for _ in range(nn)]
        links = [[(r.randrange(0, min(nn + 3, 16) + 1) if r.random() < 0.4 and nn else 0) for _ in range(4)] for _ in range(nn)]
        info0 = dict(n=nn, F=F, links=links)
        mode = r.random()
        if mode < 0.2:
            tgt = list(init)
        elif mode < 0.7 and nn:
            tgt = turn(info0, init, r.randrange(nn))
            if r.random() < 0.5:
                tgt = turn(info0, tgt, r.randrange(nn))
        else:
            tgt = [r.randrange(F) for _ in range(nn)]
        tile = (r.choice([51, 10, 1, -3, 0, 200]), r.choice([67, 10, 1, -3, 0, 200]))
        origin = (r.choice([0, 17, -50, 5000, 0x7ffffff0]), r.choice([0, 9, -33, 77, -0x7ffffff0]))
        names = [b'NO SOUND', b'TURN', b'NO SOUND', b'WIN_SND', b'NO SOUNDX']
        body = make_body(r, n=nn, F=F, S=Sx, init=init, target=tgt, rowflag=r.randrange(2), origin=origin, tile=tile, links=links,
                         T=r.choice([0, 1, 2, 9, 120, 32767, -4]), flag=r.randrange(2), M=r.choice([0, 1, 2, 5, 90, -1]),
                         snd0=r.choice(names), snd1=r.choice(names), ch0=r.choice([0, 3, -1, 32767]), ch1=r.choice([1, 9, -2]),
                         win=scene_block(r.choice([9999, 10, -3, 4377]), (r.randrange(-9, 9),) * 3, (r.randrange(-5, 5),) * 3, r.choice([0, 1, 2, -1]),
                                         r.choice([-1, r.randrange(0, 4096)]), r.randrange(256)),
                         exit_=scene_block(r.choice([9999, 11, 5000]), (1, 2, 3), (4, 5, 6), r.choice([0, 1]), r.choice([-1, r.randrange(0, 4096)]), r.randrange(256)))
        info = parse(body)
        acts = [('clock', r.choice(list(CLOCKS))), ('view', r.choice(list(VIEWS)))]
        pts = ptr_points(info, r, 6)
        acts.append(('tick', CLK))
        steps = r.randrange(40, 90)
        for _ in range(steps):
            c = r.random()
            if c < 0.30:
                acts.append(('tick', dict(ticks=r.choice(['clock', 'clock', 'dl', 'rand']), busy=r.choice(['rand', 'zero', 'one']),
                                          steps=r.choice([(0, 1, 7), (50, 300, 4000), (1 << 31, 1), (0, 0, 1)]))))
            elif c < 0.50:
                acts.append(('ptr',) + r.choice(pts))
            elif c < 0.68:
                acts.append(('click',))
            elif c < 0.72:
                acts.append(('click', r.choice([0x276c, 0x276d, 0, -1, 99]), r.choice([None, None, 0, 1, 2, 3]), r.choice([None, 0, 1])))
            elif c < 0.78:
                acts.append(('render', r.randrange(1 << 20), r.randrange(1 << 30)))
            elif c < 0.81:
                acts.append(('invalidate',))
            elif c < 0.83:
                acts.append(('cleanup',))
            elif c < 0.86:
                acts.append(('busy', [r.choice([0, 1, 2]) for _ in range(6)]))
            elif c < 0.88:
                acts.append(('flag', r.choice([0, 1, 3])))
            elif c < 0.91:
                acts.append(('fuzz',))
            elif c < 0.96 and nn:
                k = r.randrange(nn)
                acts += [('ptr',) + center(info['hit'][k]), ('click',), ('run', dict(ticks='clock', busy=r.choice(['rand', 'zero'])), 'idle', 25)]
            else:
                acts.append(('run', dict(ticks='clock', busy='rand'), 'done', 12))
        acts += [('ptr',) + center(info['exit_rect']), ('click',), ('run', dict(ticks='clock', busy='zero'), 'done', 80)]
        S(scs, 'random:%03d' % n, [R(body, r.choice([1, 1, 2]))], acts, 'random', quick=n < 14, seed=n)
    return scs


# ---------------------------------------------------------------------------------------------
# mutation check
# ---------------------------------------------------------------------------------------------
MUTANTS = {
 'm01_frame_wrap_off_by_one': ('if ((int32_t)o->frame[i] == (int32_t)frames - 1) {', 'if ((int32_t)o->frame[i] == (int32_t)frames) {'),
 'm02_deadline_factor_1000_to_8000': ('((int32_t)rd_s16(body, B_PACE_T) * 1000) / (int32_t)substeps', '((int32_t)rd_s16(body, B_PACE_T) * 8000) / (int32_t)substeps'),
 'm03_auto_deadline_factor_swapped': ('((int32_t)rd_s16(body, B_PACE_T) * 8000) / (int32_t)rd_s16(body, B_SUBSTEPS)', '((int32_t)rd_s16(body, B_PACE_T) * 1000) / (int32_t)rd_s16(body, B_SUBSTEPS)'),
 'm04_link_turn_missing': ('if (link != 0) object->moving[link - 1] = 1;', 'if (link != 0) (void)link;'),
 'm05_link_off_by_one': ('if (link != 0) object->moving[link - 1] = 1;', 'if (link != 0) object->moving[link] = 1;'),
 'm06_hit_right_edge_exclusive': ('rd_s32(body, h) <= x && x <= rd_s32(body, h + 8)', 'rd_s32(body, h) <= x && x < rd_s32(body, h + 8)'),
 'm07_hit_top_edge_exclusive': ('if (rd_s32(body, h + 4) <= y &&', 'if (rd_s32(body, h + 4) < y &&'),
 'm08_exit_bottom_edge_exclusive': ('y <= rd_s32(body, B_EXIT_RECT + 12) &&', 'y < rd_s32(body, B_EXIT_RECT + 12) &&'),
 'm09_turn_sound_skipped': ('static int play_turn_sound(const uint8_t *body, const D1Host *host)\n{\n    if (!no_sound(body + B_SOUND0)) {',
                            'static int play_turn_sound(const uint8_t *body, const D1Host *host)\n{\n    if (0 && !no_sound(body + B_SOUND0)) {'),
 'm10_win_block_on_exit': ('if (o->exit_taken == 0) {\n        if (o->solved != 0) {', 'if (o->exit_taken == 0 || o->solved != 0) {\n        if (o->solved != 0) {'),
 'm11_cleanup_keeps_slot': ('    object->slot = D1_NO_SLOT; /* 0x4b5b8a */', '    /* slot kept */'),
 'm12_geometry_sign': ('out[2] = (int32_t)(x - 2u + w);', 'out[2] = (int32_t)(x + 2u + w);'),
 'm13_geometry_row_flag_inverted': ('if (body[B_ROW_FLAG] != 0) y += (uint32_t)(int32_t)tile * h;', 'if (body[B_ROW_FLAG] == 0) y += (uint32_t)(int32_t)tile * h;'),
 'm14_state_after_animation_wait': ('o->state = D1_STATE_WAIT;\n            fx(host, D1_FX_STATE, o->state, 0);\n            o->step = (int16_t)(o->step + 1);',
                                  'o->state = D1_STATE_ANIMATE;\n            fx(host, D1_FX_STATE, o->state, 0);\n            o->step = (int16_t)(o->step + 1);'),
 'm15_deadline_signed_compare': ('if (o->deadline <= now) {', 'if ((int32_t)o->deadline <= (int32_t)now) {'),
 'm16_deadline_strict': ('if (o->deadline <= now) {', 'if (o->deadline < now) {'),
 'm17_win_start_flag_inverted': ('world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = rd_s16(blk, SB_START) == 1 ? 1 : 0;'),
 'm18_scene_9999_not_skipped': ('static int block_scene(const uint8_t *blk) { return rd_s16(blk, SB_SCENE) != D1_NO_SCENE; }', 'static int block_scene(const uint8_t *blk) { (void)blk; return 1; }'),
 'm19_flag_minus_one_stored': ('if (flag != D1_NO_FLAG) {\n            if (host->store_event_flag', 'if (1) {\n            if (host->store_event_flag'),
 'm20_exit_click_keeps_phase': ('object->exit_taken = 1;\n        *new_phase = 2u;', 'object->exit_taken = 1;\n        *new_phase = row_phase;'),
 'm21_click_ignores_state': ('object->solved == 0 && object->state == D1_STATE_IDLE && row_phase == 1u', 'object->solved == 0 && row_phase == 1u'),
 'm22_click_ignores_busy': ('if (busy == 0) {\n            object->state = D1_STATE_ANIMATE;', 'if (1) {\n            object->state = D1_STATE_ANIMATE;'),
 'm23_solved_wins_state_wrong': ('o->solved = 1;\n        o->state = D1_STATE_START_SOLVED;', 'o->solved = 1;\n        o->state = D1_STATE_AUTO;'),
 'm24_auto_counter_not_incremented': ('o->counter = (uint8_t)(o->counter + 1u);', ''),
 'm25_auto_frame_compare_le': ('if ((int32_t)o->frame[0] < frames - 1 ||', 'if ((int32_t)o->frame[0] <= frames - 1 ||'),
 'm26_win_sound_busy_inverted': ('        if (busy == 0) {\n            HOST(host->sound_stop(host->context, 1, body + B_SOUND1));', '        if (busy != 0) {\n            HOST(host->sound_stop(host->context, 1, body + B_SOUND1));'),
 'm27_moving_not_cleared_when_idle': ('if (o->solved == 0)\n                for (int16_t i = 0; i < n; ++i) o->moving[i] = 0;', ''),
 'm28_pointer_uses_step': ('set_src(object, body, i, object->frame[i], (int16_t)(object->step - 1));', 'set_src(object, body, i, object->frame[i], object->step);'),
 'm29_phase0_surface_always_loaded': ('if (o->surface == 0u) {', 'if (1) {'),
 'm30_phase0_view_origin_dropped': ('o->dst[i][0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);', 'o->dst[i][0] = rd_s32(body, d);'),
 'm31_sound_prepare_second_skipped': ('if (!no_sound(body + B_SOUND1)) {\n        HOST(host->sound_prepare(host->context, 1, body + B_SOUND1));', 'if (0 && !no_sound(body + B_SOUND1)) {\n        HOST(host->sound_prepare(host->context, 1, body + B_SOUND1));'),
 'm32_no_sound_compares_eight_bytes': ('return memcmp(name, k, sizeof k) == 0;', 'return memcmp(name, k, 8u) == 0;'),
 'm33_invalidate_ignores_active': ('if (object->active != 0 && object->slot != D1_NO_SLOT) HOST', 'if (object->slot != D1_NO_SLOT) HOST'),
 'm34_cleanup_keeps_surface': ('        object->surface = 0u;\n        fx(host, D1_FX_RELEASE_SURFACE', '        fx(host, D1_FX_RELEASE_SURFACE'),
 'm35_complete_not_reported': ('fx(host, D1_FX_COMPLETE, row, 0);\n            result->completed = 1u;', 'fx(host, D1_FX_COMPLETE, row, 0);\n            result->completed = 0u;'),
 'm36_phase2_sound_stop_skipped': ('    if (!no_sound(body + B_SOUND0)) {\n        HOST(host->sound_stop(host->context, 0, body + B_SOUND0));', '    if (0 && !no_sound(body + B_SOUND0)) {\n        HOST(host->sound_stop(host->context, 0, body + B_SOUND0));'),
 'm37_solved_check_uses_wrong_target': ('while (i < n && o->frame[i] == rd_s16(body, B_TARGET + (size_t)i * 2u)) ++i;', 'while (i < n && o->frame[i] == rd_s16(body, B_TARGET + (size_t)i * 2u + 2u)) ++i;'),
 'm38_exit_rect_x_swapped': ('rd_s32(body, B_EXIT_RECT) <= x && x <= rd_s32(body, B_EXIT_RECT + 8)', 'rd_s32(body, B_EXIT_RECT) <= y && y <= rd_s32(body, B_EXIT_RECT + 8)'),
 'm39_step_not_reset_on_idle': ('o->state = D1_STATE_IDLE;\n            fx(host, D1_FX_STATE, o->state, 0);\n            o->step = 1;', 'o->state = D1_STATE_IDLE;\n            fx(host, D1_FX_STATE, o->state, 0);'),
 'm40_begin_turn_counter_kept': ('o->step = 1;\n    o->counter = 0;', 'o->step = 1;'),
}


def mutation_check(args, workdir):
    source = (args.src / 'action_family_d1_runtime.c').read_text()
    jobs = []
    for i, (name, (old, new)) in enumerate(MUTANTS.items()):
        if source.count(old) != 1:
            jobs.append((name, None, 'mutation anchor drifted (%d matches)' % source.count(old)))
            continue
        d = Path(workdir) / ('mut%02d' % i)
        d.mkdir(parents=True, exist_ok=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / 'action_family_d1_runtime.c').write_text(source.replace(old, new))
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
def new_stats():
    return dict(scenarios=0, ticks=0, steps=0, effects=0, state_compares=0, object_bytes=0, entry_bytes=0, event_bytes=0, cells=0,
                pointer_moves=0, pointer_hits=0, clicks=0, clicks_acting=0, clicks_ignored=0, invalidates=0, cleanups=0,
                render_calls=0, blit_calls=0, render_skipped_unreachable=0, phase0_steps=0, phase1_steps=0, phase2_steps=0,
                phaseX_steps=0, completions=0, image_loads=0, gate_closed_ticks=0, fatal_paths_matched=0, ticks_consumed=0,
                busy_consumed=0, pokes=0, mismatches=0, effect_kinds=Counter(), known_observed=Counter(), known_not_observed=Counter(),
                groups={})


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
    ap.add_argument('--random', type=int, default=160, help='random scenarios (fixed seed)')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-35.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib = open_lib(lib_path)
    x = X86()
    scs, _ = scenario_list()
    scs += random_scenarios(args.random)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    stats = new_stats()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52a000)
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    if args.mutation_run:
        quick = [s for s in scs if s['quick']]
        bad = run_list(x, lib, quick, stats, fail_fast=True)
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    bad = run_list(x, lib, scs, stats, args.fail_fast)
    if args.discover_pins:
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
        out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
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
        sources = {n: sha((args.src / n).read_bytes()) for n in ('action_family_d1_runtime.c', 'action_family_d1_runtime.h')}
        killed = sum(1 for m in (mutations or []) if m['detected'])
        result = dict(slice='RT-35', status='pass' if not bad and (mutations is None or killed == len(mutations)) else 'fail',
                      mismatches=len(bad), exe_sha256=EXE_HASH, source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_d1_runtime_oracle_driver.c').read_bytes()),
                      code_windows=[dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE],
                      scenarios=len(scs), stats=summary, mutants=len(mutations or []), mutants_killed=killed, mutations=mutations,
                      mismatch_list=bad[:50], hooks_fired=dict(x.hooks_fired), counters=dict(x.counters), fpu_control_word=hex(FPCW),
                      corpus_rows=len(corpus_bodies()), elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
