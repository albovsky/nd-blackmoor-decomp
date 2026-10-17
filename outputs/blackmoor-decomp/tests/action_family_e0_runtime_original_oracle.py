#!/usr/bin/env python3
"""RT-51: immutable x86 dispatcher 0x427a50 / handler 0x471722 versus the native raw-0xd6 / raw-0xe0 keypad puzzle kernel.

The unmodified GAME.EXE image is mapped under Unicorn. Rows reach the singleton (0x62387c) through the REAL scene loader
0x40b34a (arms 0x41050b / 0x41053a, body copy 0x470e8e, dependency construction 0x424aa8): the oracle builds a payload (48
byte header, type 0xd6 / 0xe0, subtype, typed body of 1,733 / 294 bytes, 16 byte dependency records) and runs the loader
for each row. The REAL dispatcher 0x427a50 then runs (gate 0x423f57, arms 0x42a2c0 / 0x42a2fc, handler 0x471722 with ECX =
0x62387c, flag 0 / 1) together with, as ORIGINAL x86 code: the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992
(table 0x5d1591), the generic completion 0x42ba3a (and 0x423d33 for subtype 2), the constructor 0x470d0a / reset 0x470d7a,
and for raw 0xe0 the layout arithmetic with the CRT floor 0x50e19e and __ftol 0x50ce04 (they run under Unicorn as they are).
The entry points the engine reaches through other callers are driven directly with ECX = 0x62387c: pointer 0x470ffe
(`ret 8`, x then y as dwords of which the low word counts), click 0x4712bd (row phase and [0x5c39e5] set first), invalidate
0x470e31, cleanup 0x470ddc, scene reset 0x470e71 and the render callback 0x472a5c (no arguments, plain `ret`). The native
side is src/action_family_e0_runtime.c driven by tests/action_family_e0_runtime_oracle_driver.c with a scripted host.

Compared for every scenario step: the ordered E0_FX_* effects (every tick, sound, slot, surface, cell and event flag with
its arguments), a second ordered log of the host calls (what the kernel really asked of the host: tick values, busy
answers, sound record hashes, image name hash, handles, slots, label hash), the packed object image (e0_object_pack, only
the bytes its mask declares modelled, original offsets 0x00..0xe09), the process words 0x5957b5 / 0x5957b7, the typed body
bytes of every row (phase 0 of raw 0xe0 stores N at +0x21), the generic Z entry table (0x58 entries of 0x4a bytes, byte for
byte), the row phase dword and the completion byte of every row, the process flag 0x5bb1ca, the seven scene-change cells,
the engine mode 0x583999, 0x5d1a8f, the event flag window (4096 dwords at 0x585801), the image names asked of the loader,
the scripted queue consumption (ticks, busy answers) and, for the pointer receiver, the return value, [0x5b44f0],
[0x5c39e5], the sprite cells 0x5d1631 / 0x5d1639 / 0x5d162d, 0x5b44f4 and, for the render callback, the recorded blits
(0x4c5377 / 0x4c5d4b) against e0_render_plan (kind, source rectangle, destination rectangle; the label of every blit is
checked to be one of the seven site labels of the original and to map to a single kind). After every operation the whole
.data / .bss image is diffed against the previous snapshot: any byte the original changed outside the modelled cells and
the harness's own writes fails the run (a missing effect or an unmodelled store cannot hide).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard.
  R 0x51dc43 malloc        bump arena of ZEROED storage, every block padded to >= 0x800 bytes so the reads past the 294 byte
                           raw 0xe0 allocation (+0x24e, +0x24f.., +0x2d3, +0x2ec) read zeros (OS/CRT boundary)
  R 0x51dc6c free         recorded and ignored (CRT boundary)
  R 0x4c2790 load_image("CIFTREE", body+0, 6, "DF KeyPadPuzzle Surface")  thiscall ECX 0x5cf659, ret 0x10: returns the
                           scripted handle; the argument strings are compared with the exe's own strings
  R 0x4c2dfb release_image(&obj+0xd24)  thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param
  R 0x4fb77a prepare / R 0x4fba69 stop (record pointer = body+0x66 or body+0xb2)  thiscall ECX 0x5c3a67, ret 4
  R 0x4fb2e3 play(channel word)  thiscall ECX 0x5c3a67, ret 4      R 0x4f6334 busy(channel)  thiscall ECX 0x5cf1eb, ret 4
  R 0x4c5377 opaque blit / R 0x4c5d4b keyed blit  thiscall ECX 0x5cf659, ret 0x14: recorders for the render callback
  R GetTickCount (IAT slot 0x52a23c, stub)  returns the next scripted tick value
  O 0x471722 handler entry (row, phase, ECX check), 0x42ba3a generic completion, 0x4d3992 release entry (slot);
    0x4d39f9 (allocator) runs as original code and is observed at its return site;
    instruction boundaries inside 0x471722 that only read memory: 0x471c24 (slot returned), 0x471cea (entry stores done,
    before the label copy), 0x471d6b (slot surface stored) and 0x470e63 inside 0x470e31 (the redraw store)
  UC_HOOK_MEM_WRITE observers (read-only, they log the effects of the stores): obj+0xd2c (state), the row phase dwords,
    0x5bb1ca, the seven scene-change cells, 0x583999, 0x5d1a8f and the event flag window
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the scenario
    expects the allocator's fatal path 0x52139c)
 Windows imports (OS boundary, IAT slots patched to stubs): GetTickCount (scripted), InterlockedIncrement/Decrement,
 lstrlenA, Enter/Leave/InitializeCriticalSection; any other import fails the run. FS has a TIB page (GDT) for the SEH
 frames. Debug flag 0x63a4cd is 0. The x87 control word is 0x27f. The singleton is built by the original constructor 0x470d0a.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, the view origin
globals, the tick values and busy answers, slot-busy seeds, the event flag table contents, [0x5d0377] (cursor cell),
[0x5cf665] / [0x5d15e3] (blit surfaces), the stale value of 0x5bb57b.

EXPECTED DIFFERENCES (native safety layer; tagged, counted in stats.known_observed, never as passes):
  D1 raw 0xe0 reads body bytes past the 294 byte allocation (+0x24e blink byte, round records +0x24f.., +0x2ec only on the
     code-set path): heap garbage in the original; both sides read ZEROS here (zeroed malloc, zero-extended native body).
  D2 N > 100, K > 30, ordered mode with N > 30, 0xd6 code sets with N > 29, a code set that starts with a zero byte among
     the first set_count (uninitialised local), negative or 16-bit-overflowing N: refused by e0_validate_body (the original
     overruns the 100-entry arrays / reads an uninitialised local / runs on an empty set); checked natively only.
  D3 a key click whose hover index is outside 0..99 (E0_ERR_BOUNDS): the original indexes past the lit array.
  D4 event flag index outside the host window (-1 is "none"; 0..4095 valid): the original stores through an arbitrary
     pointer; native refuses before the first effect of the visit.
  D5 phase 1 / 2 on an object phase 0 did not initialise for the row (the original keeps stepping row A's body on the
     state row B built; two rows share the singleton): native E0_ERR_UNSUPPORTED before any effect (tag G1).
  D6 the length-292 body of resource 1737: the loader's fixed 294 byte copy would read two bytes past it; native refuses.
  D7 a round record whose code length is outside 0..30 (the original copies whatever lies there): reached only with round 0
     and rounds > 0 in state 3 / 4 (a scene reset 0x470e71 while the puzzle is live); native E0_ERR_BOUNDS after the effects
     the original also produced before it (checked to be a prefix of the original's visit).
  E1 the original stores obj+0xd2c (state) many times; the native kernel has no STATE effect. State is compared through the
     object image after every step instead (nothing about the order of the state stores is lost: the image is compared).
  E2 phase 2: the native kernel reports phase_after 2 with completed=1 (the executor applies 0x42ba3a); the original ran
     0x42ba3a itself, which stored phase 0. The oracle requires exactly that pair.
  E3 render sites: four call sites share the label text "Keypad buttons down"; the native role of a blit is checked against
     the label text of its site, so those four sites are told apart by order, kind and rectangles only.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_e0_runtime_original_oracle.py --original-only            (PART A: original alone)
  python3 action_family_e0_runtime_original_oracle.py --result ../../../work/analysis/slices/RT-51.oracle-result.json
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
import time
import zlib
import ctypes as C
from collections import Counter
from pathlib import Path

from unicorn import UC_ERR_EXCEPTION, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x62387c
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
BODY_PTR_OFF = 0x32
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
G_ORIGIN_X, G_ORIGIN_Y = 0x583186, 0x58318a
G_BACK, G_BG = 0x5cf665, 0x5d15e3          # blit destination surface, restore source surface
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
G_CAND, G_CURSOR, G_CURSOR2 = 0x5c39e5, 0x5b44f0, 0x5b44f4
G_CURSOR_CELL = 0x5d0377
W57B5, W57B7, ENTRY17 = 0x5957b5, 0x5957b7, 0x5d1a8f
EVENTS_VA = 0x585801
EVENT_COUNT = 4096
CELLS = ((0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2), (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4))
PAYLOAD_BASE = 0x22000000
PAYLOAD_STRIDE = 0x2000
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
SOUND_THIS, BUSY_THIS = 0x5c3a67, 0x5cf1eb
FPCW = 0x27f
BODY_LEN = {0: 1733, 1: 294}
IMG_BYTES = 0xe0a
NO_SOUND = b'NO SOUND\0'
MAX_ROWS = 8
INSN_CAP = 6_000_000
DATA_LO, DATA_HI = 0x537000, 0x63f000
STR_KIND, STR_LABEL, STR_ENTRY = 0x54c4c8, 0x54c4b0, 0x54c498
BLIT_LABELS = (0x54c4f4, 0x54c508, 0x54c524, 0x54c538, 0x54c54c, 0x54c560, 0x54c57c)

# E0_FX_* of the header (src/action_family_e0_runtime.h)
FX = dict(START_FLAG=1, SLOT=2, SLOT_REGISTER=3, SURFACE_LOAD=4, SLOT_SURFACE=5, SOUND_PREPARE=6, SOUND_STOP=7, SOUND_PLAY=8,
          SOUND_BUSY=9, TICK=10, PHASE=11, STATE=12, EVENT_FLAG=13, XFER_5BB57B=14, XFER_5BB599=15, XFER_5BB595=16,
          XFER_5C39FF=17, XFER_5BB59B=18, XFER_5BB59F=19, XFER_5BB5A3=20, ENGINE_MODE=21, ENTRY17_ACTIVE=22, COMPLETE=23,
          RELEASE_SURFACE=24, RELEASE_SLOT=25, MARK_DIRTY=26)
ENTER = 0           # oracle-only marker: handler entry (row, phase)
FXN = {v: k for k, v in FX.items()}
FXN[ENTER] = 'ENTER'
CELL_FX = [FX['XFER_5BB57B'], FX['XFER_5BB599'], FX['XFER_5BB595'], FX['XFER_5C39FF'], FX['XFER_5BB59B'],
           FX['XFER_5BB59F'], FX['XFER_5BB5A3']]
# host-call trace vocabulary (kernel -> host calls)
H = dict(TICK=1, BUSY=2, PLAY=3, PREPARE=4, STOP=5, LOAD=6, RELEASE_SURFACE=7, ALLOC=8, REGISTER=9, SET_SURFACE=10,
         RELEASE_SLOT=11, MARK_DIRTY=12, LABEL=13)
HN = {v: k for k, v in H.items()}
HN[ENTER] = 'ENTER'

HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4fb77a: (0x300, 4), 0x4fba69: (0x20, 4),
             0x4fb2e3: (0x200, 4), 0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14), 0x51dc6c: (0xc, 0),
             0x4c5d4b: (0x4c6098 + 3 - 0x4c5d4b, 0x14),
             0x471722: (0x1316, 8), 0x470ffe: (0x2b2, 8), 0x4712bd: (0x465, 0), 0x470e31: (0x40, 0), 0x470ddc: (0x55, 0),
             0x470e71: (0x1d, 0), 0x472a5c: (0x46b, 0)}

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
CODE_WINDOWS = ((0x470d0a, 0x470d5e), (0x470d7a, 0x470ddc), (0x470ddc, 0x470e31), (0x470e31, 0x470e71), (0x470e71, 0x470e8e),
                (0x470e8e, 0x470ffe), (0x470ffe, 0x4712bd), (0x4712bd, 0x471722), (0x471722, 0x472a38), (0x472a5c, 0x472ec7),
                (0x40b34a, 0x410ca4), (0x4234c8, 0x4234dd), (0x4237f7, 0x423876), (0x423d33, 0x423da2), (0x423f57, 0x423fbb),
                (0x42406d, 0x424aa8), (0x424aa8, 0x425b8b), (0x427a50, 0x42acad), (0x42ba3a, 0x42babf), (0x4d3992, 0x4d39f9),
                (0x4d39f9, 0x4d3a52), (0x50ce04, 0x50ce2b), (0x51dc43, 0x51dc6c), (0x52139c, 0x5213d4))

AT_SLOT, AT_REGISTER, AT_SLOT_SURFACE, AT_DIRTY = 0x471c24, 0x471cea, 0x471d6b, 0x470e63
HANDLER = 0x471722
LOADER = 0x40b34a
POPS = {0x4c2790: 0x10, 0x4c2dfb: 4, 0x4fb77a: 4, 0x4fba69: 4, 0x4fb2e3: 4, 0x4f6334: 4, 0x4c5377: 0x14, 0x4c5d4b: 0x14}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
FREE = 0x51dc6c

# addresses the original may legitimately change (stray-write check); everything else in .data / .bss is a mismatch
ALLOWED = [(OBJ, OBJ + 0x1000), (ROWS, ROWS + (MAX_ROWS + 1) * ROW), (ENTRY, ENTRY + NENT * STRIDE),
           (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT), (START_FLAG, START_FLAG + 4), (G_MODE, G_MODE + 4), (W57B5, W57B5 + 4),
           (ENTRY17, ENTRY17 + 4), (G_CAND, G_CAND + 4), (G_CURSOR, G_CURSOR + 8), (G_ROWCOUNT, G_ROWCOUNT + 2),
           (0x5d162d, 0x5d162d + 4), (0x5d1631, 0x5d1631 + 4), (0x5d1639, 0x5d1639 + 4), (0x5c3a47, 0x5c3a4b)] + \
          [(a, a + sz) for a, sz in CELLS]


class OracleError(RuntimeError):
    pass


class Fatal(OracleError):
    def __init__(self, address):
        super().__init__('fatal original path %#x reached' % address)
        self.address = address


class Hang(OracleError):
    pass


class OrigFault(OracleError):
    pass


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


def crc(b):
    return zlib.crc32(bytes(b)) & 0xffffffff


def clamp16(v):
    return max(-32768, min(32767, v))


# ---------------------------------------------------------------------------------------------
# body layout (offsets of the typed body, see the header comment of src/action_family_e0_runtime.h)
# ---------------------------------------------------------------------------------------------
B_NAME, B_N, B_ORD, B_EXIT, B_EXIT_SRC, B_EXIT_RECT, B_REC0 = 0x00, 0x21, 0x23, 0x24, 0x25, 0x35, 0x45
B_SND_A, B_CLICK_CH, B_FAIL, B_DELAY, B_SND_B, B_CH_B, B_XBLOCK, B_XRECT, B_R = 0x66, 0x87, 0x97, 0xb0, 0xb2, 0xd3, 0xe3, 0xfc, 0x10c
B_E0_LAYOUT = 0x10e
B_D6_LIGHT_SRC, B_D6_LIGHT_DST, B_D6_ACT_SRC, B_D6_ACT_DST, B_D6_BLINK, B_D6_REC1, B_D6_SETS, B_D6_ALL, B_D6_KEY_SRC, B_D6_KEY_DST = \
    0x10e, 0x15e, 0x1ae, 0x1fe, 0x24e, 0x24f, 0x2d3, 0x2ec, 0x305, 0x4e5


def block(scene=9999, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return struct.pack('<h3h3ihhB', scene, *words, *dwords, start, flag, value)


def rect(l, t, r, b):
    return struct.pack('<4i', l, t, r, b)


def put_name(b, off, text, width=0x21):
    t = text[:width - 1] + b'\0'
    b[off:off + width] = t + bytes(width - len(t))


def record(k, ordered, code):
    return struct.pack('<hB', k, ordered) + bytes(code[:30]) + bytes(30 - len(code[:30]))


def finish_blocks():
    return [block(), block(9999, (1, 1, 1), (2, 2, 2), 1, 5, 7), block(1234, (-1, -2, -3), (-4, 0x7fffffff, -0x80000000), 1, 4095, 255),
            block(-5, (32767, -32768, 0), (1, 2, 3), 0, 9, 0), block(0, (0, 0, 0), (0, 0, 0), 2, -1, 3),
            block(4377, (9, 8, 7), (6, 5, 4), -1, 77, 1)]


def grid_rects(n, x0, y0, w, h, gx, gy, cols):
    out = []
    for i in range(n):
        l = x0 + (w + gx) * (i % cols)
        t = y0 + (h + gy) * (i // cols)
        out.append((l, t, l + w, t + h))
    return out


def make_body(rng, flag, N=6, ordered=0, exit_btn=True, rec=None, snd_a=NO_SOUND, snd_b=NO_SOUND, click_ch=2, ch_b=3, delay=1,
              fail=None, xblock=None, xrect=(500, 10, 560, 40), R=2, layout=None, blink=0, rounds=None, sets=(), allb=None,
              name=b'KEYPAD SHEET', exit_pr=(600, 5, 640, 30), exit_rect=(300, 400, 360, 440), garbage=False):
    """A synthetic typed body (1,733 bytes for flag 0, 294 for flag 1). `rec` = (K, ordered_byte, code); `rounds` = the four
    extra records of raw 0xd6; `sets` = up to five code sets (1-based key numbers)."""
    b = bytearray(rng.randbytes(BODY_LEN[0])) if garbage else bytearray(BODY_LEN[0])
    put_name(b, B_NAME, name)
    struct.pack_into('<h', b, B_N, N)
    b[B_ORD] = ordered
    b[B_EXIT] = 1 if exit_btn else 0
    b[B_EXIT_SRC:B_EXIT_SRC + 16] = rect(*exit_pr)
    b[B_EXIT_RECT:B_EXIT_RECT + 16] = rect(*exit_rect)
    rec = rec or (3, 0, [0, 1, 2])
    b[B_REC0:B_REC0 + 33] = record(*rec)
    b[B_SND_A:B_SND_A + 9] = snd_a[:9].ljust(9, b'\0')
    struct.pack_into('<h', b, B_CLICK_CH, click_ch)
    b[B_FAIL:B_FAIL + 25] = fail or block()
    struct.pack_into('<h', b, B_DELAY, delay)
    b[B_SND_B:B_SND_B + 9] = snd_b[:9].ljust(9, b'\0')
    struct.pack_into('<h', b, B_CH_B, ch_b)
    b[B_XBLOCK:B_XBLOCK + 25] = xblock or block()
    b[B_XRECT:B_XRECT + 16] = rect(*xrect)
    struct.pack_into('<h', b, B_R, R)
    if flag == 1:
        lay = dict(cols=3, rows=2, kw=30, kh=20, x0=20, y0=40, xg=5, yg=7, x0b=220, y0b=40, xgb=5, ygb=7)
        lay.update(layout or {})
        struct.pack_into('<12h', b, B_E0_LAYOUT, lay['cols'], lay['rows'], lay['kw'], lay['kh'], lay['x0'], lay['y0'], lay['xg'],
                         lay['yg'], lay['x0b'], lay['y0b'], lay['xgb'], lay['ygb'])
        return bytes(b[:BODY_LEN[1]])
    for i in range(5):
        b[B_D6_LIGHT_SRC + 16 * i:B_D6_LIGHT_SRC + 16 * i + 16] = rect(10 + 12 * i, 300, 20 + 12 * i, 312)
        b[B_D6_LIGHT_DST + 16 * i:B_D6_LIGHT_DST + 16 * i + 16] = rect(10 + 12 * i, 340, 20 + 12 * i, 352)
        b[B_D6_ACT_SRC + 16 * i:B_D6_ACT_SRC + 16 * i + 16] = rect(110 + 12 * i, 300, 120 + 12 * i, 312)
        b[B_D6_ACT_DST + 16 * i:B_D6_ACT_DST + 16 * i + 16] = rect(110 + 12 * i, 340, 120 + 12 * i, 352)
    b[B_D6_BLINK] = blink
    for j, r_ in enumerate(rounds or []):
        b[B_D6_REC1 + 33 * j:B_D6_REC1 + 33 * j + 33] = record(*r_)
    for j, st in enumerate(sets):
        b[B_D6_SETS + 5 * j:B_D6_SETS + 5 * j + 5] = bytes(st[:5]).ljust(5, b'\0')
    b[B_D6_ALL:B_D6_ALL + 25] = allb or block()
    lay = layout or {}
    cols = lay.get('cols', 5)
    src = grid_rects(30, 20, 400, 28, 18, 4, 4, cols)
    dst = grid_rects(30, 20, 40, 28, 18, 4, 4, cols)
    for i in range(30):
        b[B_D6_KEY_SRC + 16 * i:B_D6_KEY_SRC + 16 * i + 16] = rect(*src[i])
        b[B_D6_KEY_DST + 16 * i:B_D6_KEY_DST + 16 * i + 16] = rect(*dst[i])
    return bytes(b)


def make_payload(flag, body, subtype=1, tail=b'', desc=b'E0 ORACLE ROW'):
    return desc[:47] + b'\0' * (48 - len(desc[:47])) + bytes([0xd6 if flag == 0 else 0xe0, subtype]) + body + tail


_CORPUS = None


def corpus_rows():
    """The real raw 0xd6 / 0xe0 rows of the owner's local resources (never printed; counts and hashes only)."""
    global _CORPUS
    if _CORPUS is None:
        out = []
        for name, flag in (('A-E0.1', 1), ('A-D6.1', 0)):
            rec_json = json.loads((PRIVATE / (name + '.corpus.json')).read_text())
            for r_ in rec_json['records']:
                data = (RESOURCES / ('%04d.bin' % r_['resource_index'])).read_bytes()
                payload = data[r_['act_payload_offset']:r_['act_payload_offset'] + r_['act_payload_length']]
                n = r_['typed_body_length']
                if r_['typed_body_sha256'] is None:      # resource 1737 action 0: a 292 byte body, no tail (the loader cannot take it)
                    body, tail = payload[50:], b''
                    if len(body) != r_['raw_body_length']:
                        raise OracleError('corpus row %s/%s length' % (r_['resource_index'], r_['action_index']))
                    n = len(body)
                else:
                    body, tail = payload[50:50 + n], payload[50 + n:]
                    if sha(body) != r_['typed_body_sha256'] or len(tail) != r_['dependency_tail_length']:
                        raise OracleError('corpus row %s/%s differs from its record' % (r_['resource_index'], r_['action_index']))
                if payload[48] != (0xd6 if flag == 0 else 0xe0) or payload[49] != r_['subtype']:
                    raise OracleError('corpus payload header')
                out.append(dict(flag=flag, body=body, tail=tail, subtype=r_['subtype'], payload=payload, valid=n == BODY_LEN[flag],
                                id='%d_%d' % (r_['resource_index'], r_['action_index']), body_sha=sha(body)))
        if len(out) != 4:
            raise OracleError('expected 4 corpus rows, found %d' % len(out))
        _CORPUS = out
    return _CORPUS


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


class X86(deps.OriginalMachine):
    def __init__(self):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.pristine = bytes(self.pe.image)
        if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
            raise OracleError('executable identity mismatch')
        self.window_hashes = [(a, z, sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]))
                              for a, z in CODE_WINDOWS]
        self.str_kind = cstr(self.pristine[STR_KIND - self.pe.image_base:STR_KIND - self.pe.image_base + 32])
        self.str_label = cstr(self.pristine[STR_LABEL - self.pe.image_base:STR_LABEL - self.pe.image_base + 40])
        self.str_entry = cstr(self.pristine[STR_ENTRY - self.pe.image_base:STR_ENTRY - self.pe.image_base + 40])
        self.site_text = {a: cstr(self.pristine[a - self.pe.image_base:a - self.pe.image_base + 40]) for a in BLIT_LABELS}
        self.blit_labels = {cstr(self.pristine[a - self.pe.image_base:a - self.pe.image_base + 40]): a for a in BLIT_LABELS}
        self._check_hook_rets()
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(PAYLOAD_BASE, PAYLOAD_STRIDE * (MAX_ROWS + 1))
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
        self.cur_phase = None
        self.fx = []                 # ordered E0_FX_* effects (kind, a, b)
        self.calls = []              # ordered host-call trace (kind, a, b)
        self.entered = []
        self.allocs = {}
        self.frees = 0
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.blits = []
        self.loaded = []             # image names asked of 0x4c2790
        self.handles, self.handle_i = [], 0
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
        self.states_seen = set()
        self.hw = []
        self._hook_error = None
        self._hook_exc = None
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
            self.log(FX['TICK'], v)
            self.call_log(H['TICK'], v)
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
                self._hook_exc = error
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
        end = start + max(size, 0x800) + 16
        if end > HEAP_BASE + HEAP_SIZE:
            raise OracleError('oracle heap exhausted for %d bytes' % size)
        self.heap_cursor = end
        self.heap_high = max(self.heap_high, end)
        self.allocs[start] = size
        self.counters['malloc'] += 1
        uc.reg_write(X.UC_X86_REG_EAX, start)
        self._ret(uc, 0)

    def _free(self, uc, address, size, user):
        self.frees += 1
        self.counters['free'] += 1
        self._ret(uc, 0, 0)

    def _install_hooks(self):
        uc = self.machine
        table = {}
        for a in POPS:
            table[a] = self._replaced
        for a in GUARDS:
            table[a] = self._raise
        table[HANDLER] = self._entry
        table[0x42ba3a] = self._complete
        table[0x4d3992] = self._release_entry
        table[AT_SLOT] = self._at_slot
        table[AT_REGISTER] = self._at_register
        table[AT_SLOT_SURFACE] = self._at_slot_surface
        table[AT_DIRTY] = self._at_dirty
        table[FREE] = self._free
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        w = self._guard_write
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=OBJ + 0xd2c, end=OBJ + 0xd2f)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=START_FLAG, end=START_FLAG + 3)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=G_MODE, end=G_MODE + 3)
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=ENTRY17, end=ENTRY17 + 3)
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
        b = bytes(b)
        self.hw.append((a, a + len(b)))
        self.machine.mem_write(a, b)

    def w32(self, a, v):
        self.wr(a, struct.pack('<I', v & 0xffffffff))

    def image(self):
        return self.rd(OBJ, IMG_BYTES)

    def entries(self):
        return self.rd(ENTRY, NENT * STRIDE)

    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

    def row_body_ptr(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + BODY_PTR_OFF, 4))[0]

    def row_body(self, row, flag):
        return self.rd(self.row_body_ptr(row), BODY_LEN[flag])

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

    # -- stray-write check ----------------------------------------------------------------------
    def snap(self):
        return bytes(self.machine.mem_read(DATA_LO, DATA_HI - DATA_LO))

    def stray(self, before, after):
        """Addresses (word granularity) changed outside the modelled cells and the harness's own writes."""
        if before == after:
            return []
        allowed = ALLOWED + self.hw
        out = []
        for off in range(0, len(before), 4096):
            if before[off:off + 4096] == after[off:off + 4096]:
                continue
            for j in range(0, 4096, 4):
                if before[off + j:off + j + 4] != after[off + j:off + j + 4]:
                    a = DATA_LO + off + j
                    if not any(lo <= a + 3 and a < hi for lo, hi in allowed):
                        out.append(a)
        return out

    # -- effects ---------------------------------------------------------------------------------
    def log(self, kind, a=0, b=0):
        if self.rec:
            self.fx.append((kind, s32(a), s32(b)))

    def call_log(self, kind, a=0, b=0):
        if self.rec:
            self.calls.append((kind, s32(a), s32(b)))

    def _guard_write(self, uc, access, address, size, value, user):
        try:
            self._on_write(uc, access, address, size, value, user)
        except Exception as error:
            self._hook_error = 'write hook %#x: %r' % (address, error)
            uc.emu_stop()

    def _on_write(self, uc, access, address, size, value, user):
        if not self.rec:
            return
        if OBJ + 0xd2c <= address < OBJ + 0xd30:
            pass  # state is compared through the object image; the native kernel has no STATE effect (tag E1)
        elif address == START_FLAG and size == 4:
            self.log(FX['START_FLAG'], s32(value))
        elif address == G_MODE and size == 4:
            self.log(FX['ENGINE_MODE'], s32(value))
        elif address == ENTRY17 and size == 4:
            self.log(FX['ENTRY17_ACTIVE'], s32(value))
        elif ROWS <= address < ROWS + MAX_ROWS * ROW + 4:
            if address >= ROWS + PHASE_OFF and (address - ROWS - PHASE_OFF) % ROW == 0 and size == 4:
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
            raise OracleError('handler entered with ECX != 0x62387c')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        self.cur_phase = phase
        if phase == 1:
            self.counters['phase1_state_%d' % self.rs32(OBJ + 0xd2c)] += 1
            self.states_seen.add(self.rs32(OBJ + 0xd2c))
        elif phase == 2:
            self.states_seen.add('phase2')
        self.fx.append((ENTER, row, phase))
        self.calls.append((ENTER, row, phase))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(FX['COMPLETE'], struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _at_slot(self, uc, address, size, user):
        slot = s16(uc.reg_read(X.UC_X86_REG_EAX))
        self.log(FX['SLOT'], slot)
        self.call_log(H['ALLOC'], slot)

    def _at_register(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0xd38)
        surf = self.entry_surface(slot)
        self.log(FX['SLOT_REGISTER'], slot, surf)
        self.call_log(H['REGISTER'], slot, surf)
        self.call_log(H['LABEL'], crc(self.str_entry))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0xd38)
        surf = self.entry_surface(slot)
        self.log(FX['SLOT_SURFACE'], slot, surf)
        self.call_log(H['SET_SURFACE'], slot, surf)

    def _at_dirty(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0xd38)
        self.log(FX['MARK_DIRTY'], slot)
        self.call_log(H['MARK_DIRTY'], slot)

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        slot = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.log(FX['RELEASE_SLOT'], slot)
        self.call_log(H['RELEASE_SLOT'], slot)

    def sound_offset(self, ptr):
        for r in range(MAX_ROWS):
            base = self.row_body_ptr(r)
            if base and ptr - base in (B_SND_A, B_SND_B):
                return ptr - base
        raise OracleError('sound record pointer %#x is not body+0x66 / body+0xb2 of any row' % ptr)

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)

        def need(want, what):
            if ecx != want:
                raise OracleError(what + ' ECX')
        eax = 0
        if address == 0x4c2790:
            need(SURF_HOST, 'image loader')
            kind, name, six, label = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            row = self.rs16(OBJ + 0xd28)
            if kind != self.str_kind or six != 6 or label != self.str_label or a[1] != self.row_body_ptr(row):
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.loaded.append(name.decode('latin1'))
            self.log(FX['SURFACE_LOAD'], eax)
            self.call_log(H['LOAD'], crc(name), eax)
        elif address == 0x4c2dfb:
            need(SURF_HOST, 'image release')
            if a[0] != OBJ + 0xd24:
                raise OracleError('image release parameter is not &obj+0xd24')
            old = u32(uc, a[0])
            self.log(FX['RELEASE_SURFACE'], old)
            self.call_log(H['RELEASE_SURFACE'], old)
            self.wr(a[0], bytes(4))
        elif address in (0x4fb77a, 0x4fba69):
            need(SOUND_THIS, 'sound prepare/stop')
            off = self.sound_offset(a[0])
            fx = FX['SOUND_PREPARE'] if address == 0x4fb77a else FX['SOUND_STOP']
            self.log(fx, off)
            self.call_log(H['PREPARE'] if address == 0x4fb77a else H['STOP'], crc(self.rd(a[0], 9)))
        elif address == 0x4fb2e3:
            need(SOUND_THIS, 'sound play')
            self.log(FX['SOUND_PLAY'], s16(a[0]))
            self.call_log(H['PLAY'], s16(a[0]))
        elif address == 0x4f6334:
            need(BUSY_THIS, 'sound busy')
            if self.busy_i >= len(self.busy_q):
                raise OracleError('busy queue underflow')
            eax = self.busy_q[self.busy_i] & 0xffffffff
            self.busy_i += 1
            self.log(FX['SOUND_BUSY'], s16(a[0]), s32(eax))
            self.call_log(H['BUSY'], s16(a[0]), s32(eax))
        elif address in (0x4c5377, 0x4c5d4b):
            need(SURF_HOST, 'blit')
            rc = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.blits.append(dict(fn=address, src_surface=a[0], dst_surface=a[1], src=rc(a[2]), dst=rc(a[3]),
                                   label=cstr(self.rd(a[4], 40))))
        else:
            raise OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    # -- scenario plumbing ------------------------------------------------------------------------
    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(HEAP_BASE, bytes(self.heap_high - HEAP_BASE))
        uc.mem_write(PAYLOAD_BASE, bytes(PAYLOAD_STRIDE * (MAX_ROWS + 1)))
        uc.mem_write(TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, FPCW)
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.allocs.clear()
        self.blits, self.loaded, self.fx, self.calls, self.entered = [], [], [], [], []
        self.handle_i = 0
        self.tick_q, self.tick_i, self.busy_q, self.busy_i = [], 0, [], 0
        self.rec = False
        self.cur_phase = None
        self.expect_fatal = None
        self.states_seen = set()
        self.hw = []
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        if any(self.rd(OBJ, IMG_BYTES)):
            raise OracleError('object storage is not zero before the constructor')
        self.call(0x470d0a, [], OBJ)  # the original constructor (vtable word, base init, reset 0x470d7a)

    def install_rows(self, rows, first=0):
        """`rows`: list of dict(flag, body, tail, subtype[, payload]). Rows below `first` are completed dummies. Every row is
        built by the real scene loader 0x40b34a (arms 0x41050b / 0x41053a, body copy 0x470e8e, dependencies 0x424aa8)."""
        total = first + len(rows)
        if total > MAX_ROWS:
            raise OracleError('too many rows')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            payload = spec.get('payload') or make_payload(spec['flag'], spec['body'], spec.get('subtype', 1),
                                                          spec.get('tail') or b'', b'E0 ORACLE ROW %d' % i)
            at = PAYLOAD_BASE + i * PAYLOAD_STRIDE
            if len(payload) > PAYLOAD_STRIDE:
                raise OracleError('payload too large')
            self.wr(at, payload)
            self.wr(G_ROWCOUNT, struct.pack('<h', i))
            self.call(LOADER, [at, len(payload)], 0)
            base = ROWS + i * ROW
            want = bytes([0xd6 if spec['flag'] == 0 else 0xe0, spec.get('subtype', 1)])
            if self.rd(base + 0x30, 2) != want:
                raise OracleError('loader did not store the row type')
            ptr = struct.unpack('<I', self.rd(base + BODY_PTR_OFF, 4))[0]
            if self.rd(ptr, BODY_LEN[spec['flag']]) != spec['body'][:BODY_LEN[spec['flag']]]:
                raise OracleError('loader body copy differs')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def set_queues(self, ticks, busy):
        self.tick_q, self.tick_i = list(ticks), 0
        self.busy_q, self.busy_i = list(busy), 0

    def _reset_logs(self):
        self.fx, self.calls, self.entered, self.blits, self.loaded = [], [], [], [], []

    def dispatch(self):
        self._reset_logs()
        self.wr(0x5c3a47, bytes(4))
        self.rec = True
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.rec = False
            self.cur_phase = None

    def run_op(self, address, args, ecx, phase_tag=None):
        """A directly driven entry point; the effects land in self.fx / self.calls."""
        self._reset_logs()
        self.rec = True
        self.cur_phase = phase_tag
        try:
            return self.call(address, args, ecx)[0]
        finally:
            self.rec = False
            self.cur_phase = None

    def call(self, address, args, ecx):
        uc = self.machine
        self._hook_error = None
        self._hook_exc = None
        self._fatal = None
        words = [deps.RETURN_SENTINEL, *[v & 0xFFFFFFFF for v in args]]
        uc.mem_write(TIB, bytes(8))  # empty SEH chain
        uc.mem_write(deps.STACK_TOP, struct.pack('<' + 'I' * len(words), *words))
        uc.reg_write(X.UC_X86_REG_ESP, deps.STACK_TOP)
        uc.reg_write(X.UC_X86_REG_ECX, ecx)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        try:
            uc.emu_start(address, deps.RETURN_SENTINEL, timeout=0, count=INSN_CAP)
        except UcError as error:
            eip = uc.reg_read(X.UC_X86_REG_EIP)
            if isinstance(self._hook_exc, Hang):
                raise self._hook_exc from error
            if self._hook_error:
                raise OracleError(self._hook_error) from error
            if error.errno == UC_ERR_EXCEPTION:   # #DE and friends
                raise OrigFault('original faulted at %#x (%s)' % (eip, error)) from error
            raise OracleError('x86 call %#x failed at %#x: %s' % (address, eip, error)) from error
        if self._fatal is not None:
            raise Fatal(self._fatal)
        if isinstance(self._hook_exc, Hang):
            raise self._hook_exc
        if self._hook_error:
            raise OracleError(self._hook_error)
        if uc.reg_read(X.UC_X86_REG_EIP) != deps.RETURN_SENTINEL:
            raise Hang('instruction cap %d reached at %#x' % (INSN_CAP, uc.reg_read(X.UC_X86_REG_EIP)))
        return uc.reg_read(X.UC_X86_REG_EAX), True


# ---------------------------------------------------------------------------------------------
# native side (scripted-host driver)
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out, kernel_sources=('action_family_e0_runtime.c',)):
    cc = os.environ.get('CC') or shutil.which('cc') or shutil.which('clang')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_e0_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / k) for k in kernel_sources], '-o', str(out)]
    if os.environ.get('E0_SANITIZE'):
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-1200:])
    return out


MAX_PLAN_BLITS = 112


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u32p, u8p, ip = C.c_void_p, C.c_int32, C.POINTER(C.c_uint32), C.POINTER(C.c_uint8), C.POINTER(C.c_int32)
    lib.e0o_new.restype = p
    lib.e0o_free.argtypes = [p]
    lib.e0o_set_view.argtypes = [p, i32, i32]
    lib.e0o_set_world.argtypes = [p, i32, i32, i32]
    lib.e0o_get_world.argtypes = [p, ip]
    lib.e0o_set_handles.argtypes = [p, u32p, C.c_int]
    lib.e0o_set_queues.argtypes = [p, u32p, C.c_int, ip, C.c_int]
    lib.e0o_consumed.argtypes = [p, ip]
    lib.e0o_set_busy_slot.argtypes = [p, C.c_int, C.c_int]
    lib.e0o_set_entry_u32.argtypes = [p, C.c_int, C.c_int, C.c_uint32]
    lib.e0o_set_cells.argtypes = [p, ip]
    lib.e0o_get_cells.argtypes = [p, ip]
    lib.e0o_set_events.argtypes = [p, ip]
    lib.e0o_get_events.argtypes = [p, ip]
    lib.e0o_load_body.argtypes = [p, C.c_int, C.c_int, u8p, C.c_int]
    lib.e0o_load_body.restype = C.c_int
    lib.e0o_get_body.argtypes = [p, C.c_int, u8p]
    lib.e0o_clear_log.argtypes = [p]
    lib.e0o_step.argtypes = [p, C.c_int, C.c_uint32, u32p]
    lib.e0o_step.restype = C.c_int
    lib.e0o_why.argtypes = [p]
    lib.e0o_why.restype = C.c_char_p
    lib.e0o_pointer.argtypes = [p, C.c_int, C.c_int, C.c_int, ip]
    lib.e0o_pointer.restype = C.c_int
    lib.e0o_click.argtypes = [p, C.c_int, C.c_uint32, i32, i32, u32p]
    lib.e0o_click.restype = C.c_int
    lib.e0o_invalidate.argtypes = [p]
    lib.e0o_invalidate.restype = C.c_int
    lib.e0o_cleanup.argtypes = [p]
    lib.e0o_cleanup.restype = C.c_int
    lib.e0o_scene_reset.argtypes = [p]
    lib.e0o_log_count.argtypes = [p]
    lib.e0o_log.argtypes = [p, C.c_int, ip]
    lib.e0o_call_count.argtypes = [p]
    lib.e0o_call.argtypes = [p, C.c_int, ip]
    lib.e0o_name_count.argtypes = [p]
    lib.e0o_name.argtypes = [p, C.c_int]
    lib.e0o_name.restype = C.c_char_p
    lib.e0o_image.argtypes = [p, u8p, u8p]
    lib.e0o_set_image.argtypes = [p, u8p]
    lib.e0o_words.argtypes = [p, ip]
    lib.e0o_set_words.argtypes = [p, i32, i32]
    lib.e0o_entries.argtypes = [p, u8p]
    lib.e0o_plan.argtypes = [p, C.c_int, ip]
    lib.e0o_plan.restype = C.c_int
    lib.e0o_validate.argtypes = [C.c_int, u8p, C.c_int]
    lib.e0o_validate.restype = C.c_int
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.e0o_new()

    def close(self):
        self.lib.e0o_free(self.h)

    def set_view(self, x, y):
        self.lib.e0o_set_view(self.h, x, y)

    def set_handles(self, hs):
        arr = (C.c_uint32 * max(1, len(hs)))(*hs)
        self.lib.e0o_set_handles(self.h, arr, len(hs))

    def set_queues(self, ticks, busy):
        t = (C.c_uint32 * max(1, len(ticks)))(*[v & 0xffffffff for v in ticks])
        b = (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy])
        self.lib.e0o_set_queues(self.h, t, len(ticks), b, len(busy))

    def consumed(self):
        t = (C.c_int32 * 8)()
        self.lib.e0o_consumed(self.h, t)
        return list(t)

    def _triples(self, count, get):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(count):
            get(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        return out

    def fx(self):
        return self._triples(self.lib.e0o_log_count(self.h), self.lib.e0o_log)

    def calls(self):
        return self._triples(self.lib.e0o_call_count(self.h), self.lib.e0o_call)

    def names(self):
        return [self.lib.e0o_name(self.h, i).decode('latin1') for i in range(self.lib.e0o_name_count(self.h))]

    def load_body(self, row, flag, body):
        return self.lib.e0o_load_body(self.h, row, flag, cbuf(body), len(body))

    def body(self, row, n):
        t = (C.c_uint8 * 1733)()
        self.lib.e0o_get_body(self.h, row, t)
        return bytes(t)[:n]

    def _collect(self):
        return self.fx(), self.calls(), self.names()

    def step(self, row, phase):
        L = self.lib
        L.e0o_clear_log(self.h)
        res = (C.c_uint32 * 3)()
        status = L.e0o_step(self.h, row, phase, res)
        return (status, (L.e0o_why(self.h) or b'').decode(), *self._collect(), list(res))

    def pointer(self, row, x, y):
        self.lib.e0o_clear_log(self.h)
        out = (C.c_int32 * 3)()
        status = self.lib.e0o_pointer(self.h, row, x, y, out)
        return status, list(out)

    def click(self, row, row_phase, candidate, start_flag):
        self.lib.e0o_clear_log(self.h)
        newp = C.c_uint32(0)
        status = self.lib.e0o_click(self.h, row, row_phase, candidate, start_flag, C.byref(newp))
        return (status, newp.value, *self._collect())

    def simple(self, fn):
        self.lib.e0o_clear_log(self.h)
        status = fn()
        return (status, *self._collect())

    def image(self):
        img, mask = (C.c_uint8 * IMG_BYTES)(), (C.c_uint8 * IMG_BYTES)()
        self.lib.e0o_image(self.h, img, mask)
        return bytes(img), bytes(mask)

    def set_image(self, raw):
        self.lib.e0o_set_image(self.h, cbuf(raw))

    def words(self):
        t = (C.c_int32 * 4)()
        self.lib.e0o_words(self.h, t)
        return list(t)

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.e0o_entries(self.h, t)
        return bytes(t)

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.e0o_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        self.lib.e0o_set_cells(self.h, (C.c_int32 * 8)(*v))

    def world(self):
        t = (C.c_int32 * 3)()
        self.lib.e0o_get_world(self.h, t)
        return list(t)

    def set_world(self, start, scene, e17):
        self.lib.e0o_set_world(self.h, start, scene, e17)

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.e0o_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        self.lib.e0o_set_events(self.h, (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw))

    def plan(self, row):
        t = (C.c_int32 * (3 + 10 * MAX_PLAN_BLITS))()
        status = self.lib.e0o_plan(self.h, row, t)
        v = list(t)
        n = min(v[2], MAX_PLAN_BLITS)
        blits = [(v[3 + 10 * i], tuple(v[5 + 10 * i:9 + 10 * i]), tuple(v[9 + 10 * i:13 + 10 * i])) for i in range(n)]
        roles = [v[4 + 10 * i] for i in range(n)]
        return status, dict(valid=v[0], surface=v[1] & 0xffffffff, count=v[2], blits=blits, roles=roles)


# ---------------------------------------------------------------------------------------------
# comparison
# ---------------------------------------------------------------------------------------------
def compare_seq(where, what, orig, nat, names=FXN):
    orig, nat = [(k, s32(a), s32(b)) for k, a, b in orig], [(k, s32(a), s32(b)) for k, a, b in nat]
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        f = lambda t: '%s(%d,%d)' % (names.get(t[0], t[0]), t[1], t[2])
        raise Mismatch('%s %s %d: original %s vs native %s; original sequence %s; native sequence %s' % (
            where, what, k, f(orig[k]) if k < len(orig) else None, f(nat[k]) if k < len(nat) else None,
            ' '.join(f(t) for t in orig[:12]), ' '.join(f(t) for t in nat[:12])))


def segments(seq):
    """Split an effect / call list at the ENTER markers: [(row, phase, [items])]."""
    out, cur = [], None
    for k, a, b in seq:
        if k == ENTER:
            cur = (a, b, [])
            out.append(cur)
        elif cur is not None:
            cur[2].append((k, a, b))
    return out


FIELDS = [(0x1c, 0x640, 'rect_a'), (0x65c, 0x640, 'rect_b'), (0xc9c, 100, 'lit'), (0xd00, 1, 'tiles_visible'), (0xd01, 2, 'code_len'),
          (0xd03, 1, 'code_ordered'), (0xd04, 30, 'code'), (0xd22, 2, 'rounds'), (0xd24, 4, 'surface'), (0xd28, 2, 'row'),
          (0xd2a, 2, 'hover'), (0xd2c, 4, 'state'), (0xd30, 2, 'recorded'), (0xd32, 2, 'typed'), (0xd38, 2, 'slot'),
          (0xd3a, 1, 'exit_pending'), (0xd3b, 1, 'waiting'), (0xd3c, 1, 'blink'), (0xd3d, 1, 'flag'), (0xd3e, 1, 'active'),
          (0xd3f, 1, 'exit_asked'), (0xd40, 4, 'blink_deadline'), (0xd44, 4, 'show_deadline'), (0xd48, 2, 'pad_d48'),
          (0xd4a, 60, 'player'), (0xd86, 60, 'scratch'), (0xdc2, 60, 'record'), (0xdfe, 1, 'solved'), (0xdff, 1, 'solved_sets'),
          (0xe00, 4, 'wait_deadline'), (0xe06, 2, 'set_count'), (0xe08, 2, 'scene')]


def field_of(off):
    for o, n, name in FIELDS:
        if o <= off < o + n:
            return '%s+%#x (obj+%#x)' % (name, off - o, off)
    return '? (obj+%#x)' % off


def compare_state(where, ctx, entries=True):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['state_compares'] += 1
    for row in range(ctx.first + len(ctx.rows)):
        if x.row_phase(row) != ctx.phase.get(row, 0):
            raise Mismatch('%s row %d phase: original %d model %d' % (where, row, x.row_phase(row), ctx.phase.get(row, 0)))
        if x.row_complete(row) != ctx.complete.get(row, 0):
            raise Mismatch('%s row %d completion byte: original %d model %d' % (where, row, x.row_complete(row), ctx.complete.get(row, 0)))
    if x.rs32(G_CAND) != ctx.cand:
        raise Mismatch('%s candidate 0x5c39e5: original %d model %d' % (where, x.rs32(G_CAND), ctx.cand))
    if ctx.sc.get('stray', True):
        after = x.snap()
        bad = x.stray(ctx.snap, after) if ctx.snap is not None else []
        ctx.snap = after
        x.hw = []
        if bad:
            raise Mismatch('%s the original changed memory outside the modelled cells: %s' % (where, ', '.join('%#x' % a for a in bad[:6])))
        stats['stray_checks'] += 1
    if nat is None:
        return
    oi = x.image()
    ni, mask = nat.image()
    stats['object_bytes_compared'] += sum(mask)
    stats['object_bytes_unmodelled'] += IMG_BYTES - sum(mask)
    for k in range(IMG_BYTES):
        if mask[k] and oi[k] != ni[k]:
            raise Mismatch('%s object field %s: original %02x native %02x' % (where, field_of(k), oi[k], ni[k]))
    ow = [x.rs16(W57B7), x.rs16(W57B5)]
    nw = nat.words()
    if ow != [nw[0], nw[1]]:
        raise Mismatch('%s process words 0x5957b7/0x5957b5: original %s native %s' % (where, ow, nw[:2]))
    wd = nat.world()
    if x.rs32(START_FLAG) != wd[0]:
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), wd[0]))
    if x.rs32(ENTRY17) != wd[2]:
        raise Mismatch('%s 0x5d1a8f: original %d native %d' % (where, x.rs32(ENTRY17), wd[2]))
    oc, nc = x.cells(), nat.cells()
    stats['cells'] += len(oc)
    if oc != nc:
        k = next(i for i in range(len(oc)) if oc[i] != nc[i])
        raise Mismatch('%s scene-change cell %d: original %d native %d' % (where, k, oc[k], nc[k]))
    if wd[1] != nc[0]:
        raise Mismatch('%s world scene cell %d differs from the transition cell %d' % (where, wd[1], nc[0]))
    for row, flag in ctx.row_flags.items():
        ob, nb = x.row_body(row, flag), nat.body(row, BODY_LEN[flag])
        stats['body_bytes'] += len(ob)
        if ob != nb:
            k = next(i for i in range(len(ob)) if ob[i] != nb[i])
            raise Mismatch('%s row %d body byte +%#x: original %02x native %02x' % (where, row, k, ob[k], nb[k]))
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


# ---------------------------------------------------------------------------------------------
# scenario execution
# ---------------------------------------------------------------------------------------------
VIEWS = {'v0': (0, 0), 'v1': (13, 21), 'neg': (-40, -25), 'big': (300, 200), 'edge': (0x7ffffff0, -0x7ffffff0)}
CLOCKS = {'low': 100, 'mid': 0x7fffff00, 'sign': 0x7ffffff0, 'wrap': 0xfffff000, 'top': 0xfffffff8}
BG_SURFACE = 0x33330000
STEPS = (0, 1, 7, 60, 150, 301, 400, 1500, 2600, 9000)


class Ctx:
    pass


def make_ctx(x, lib, sc, stats):
    ctx = Ctx()
    ctx.x, ctx.stats, ctx.sc = x, stats, sc
    ctx.lib = lib
    ctx.nat = Native(lib) if lib is not None and sc.get('native', True) else None
    ctx.rows, ctx.first = list(sc['rows']), sc['first']
    ctx.row_flags = {ctx.first + k: r['flag'] for k, r in enumerate(ctx.rows)}
    ctx.phase, ctx.complete = {}, {}
    ctx.rng = random.Random(sc.get('seed', 1))
    ctx.clock = CLOCKS['low']
    ctx.cand = 0
    ctx.view = VIEWS['v0']
    ctx.stop = False
    ctx.skip_final = False
    ctx.tickno = 0
    ctx.pending_busy = [0] * 8
    ctx.states = set()
    ctx.snap = None
    return ctx


def row_spec(ctx, row):
    k = row - ctx.first
    return ctx.rows[k] if 0 <= k < len(ctx.rows) else None


def obj_row(ctx):
    r = ctx.x.rs16(OBJ + 0xd28)
    return r if row_spec(ctx, r) is not None else None


def active_row(ctx):
    r = obj_row(ctx)
    return r if r is not None else ctx.first


def gen_queues(ctx, spec):
    """Tick values and busy answers for one operation; both sides receive the same lists."""
    x, rng = ctx.x, ctx.rng
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 48)
    d = [struct.unpack('<I', x.rd(OBJ + off, 4))[0] for off in (0xd40, 0xd44, 0xe00)]
    if policy == 'clock':
        base = ctx.clock
        ticks = [(base + i) & 0xffffffff for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', STEPS))) & 0xffffffff
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 1000, 0x80000000, -0x80000000, 0x7fffffff]
        ticks = [(rng.choice(d) + rng.choice(offs)) & 0xffffffff for _ in range(n)]
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, d[0], d[1], d[2], d[0] - 1, d[1] + 1, d[2] + 1, 0x7fffffff, 0x80000000, 0xffffffff,
                             rng.randrange(1 << 32)]) & 0xffffffff for _ in range(n)]
    else:
        ticks = list(policy) + [policy[-1]] * n
    b = spec.get('busy', 'rand')
    if b == 'zero':
        busy = [0] * 32
    elif b == 'one':
        busy = [1] * 32
    elif b == 'rand':
        busy = [rng.choice([0, 0, 1, 1, 1, 2, -1]) for _ in range(32)]
    else:
        busy = list(b) + [0] * 32
    return ticks, busy


def load_queues(ctx, ticks, busy):
    ctx.x.set_queues(ticks, busy)
    if ctx.nat:
        ctx.nat.set_queues(ticks, busy)


def gate_open(ctx, spec):
    if spec.get('gate') == 'free':
        return True
    t = spec.get('tail') or b''
    ok = True
    for r in range(len(t) // 16):
        rec = struct.unpack_from('<8h', t, 16 * r)
        ok = ok and ctx.x.rs32(EVENTS_VA + 4 * rec[1]) == rec[2]
    return ok


def next_expected(ctx, mode, start_row):
    """First row at or after `start_row` the dispatcher enters (engine mode 3, not completed, gate open)."""
    if mode != 3:
        return None
    x = ctx.x
    for k in range(max(start_row - ctx.first, 0), len(ctx.rows)):
        row = ctx.first + k
        if ctx.complete.get(row, 0):
            continue
        if x.rd(ROWS + row * ROW + 0x85, 4) != bytes(4):
            continue
        if ctx.rows[k].get('gate') == 'unknown':
            return 'unknown'
        if gate_open(ctx, ctx.rows[k]):
            return row
    return None


def check_consumption(where, ctx):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['ticks_consumed'] += x.tick_i
    stats['busy_consumed'] += x.busy_i
    if nat is None:
        return
    nc = nat.consumed()
    if (x.tick_i, x.busy_i) != tuple(nc[:2]) or nc[2] or nc[3] or nc[4] or nc[5] or nc[6]:
        raise Mismatch('%s queue consumption original %s native %s (underflows tick %d busy %d, host_error %d alloc_fail %d bad_slot %d)' % (
            where, (x.tick_i, x.busy_i), nc[:2], nc[2], nc[3], nc[4], nc[5], nc[6]))


def count_effects(stats, fx):
    stats['effects'] += len(fx)
    for t in fx:
        stats['effect_kinds'][FXN[t[0]]] += 1


def do_tick(ctx, where, spec):
    x, nat, stats, rows, first = ctx.x, ctx.nat, ctx.stats, ctx.rows, ctx.first
    ticks, busy = gen_queues(ctx, spec)
    load_queues(ctx, ticks, busy)
    mode_model = x.rs32(G_MODE)
    fatal = hang = fault = None
    try:
        x.dispatch()
    except Fatal as error:
        fatal = error.address
    except Hang as error:
        hang = str(error)
        stats['hang_detail'][hang[:90]] += 1
    except OrigFault as error:
        fault = str(error)
        stats['fault_detail'][fault[:90]] += 1
    stats['ticks'] += 1
    segs = segments(x.fx)
    csegs = segments(x.calls)
    entered = [(r, p) for r, p, _ in segs]
    if len(csegs) != len(segs):
        raise OracleError('effect / call segmentation differs')
    expected_i = first
    nfx, names = [], []
    broken = fatal is not None or hang is not None or fault is not None
    stopped_early = False
    for n_i, (row, phase, fxs) in enumerate(segs):
        last = n_i == len(segs) - 1
        spec_r = rows[row - first]
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt != 'unknown' and (nxt is None or nxt != row):
            raise Mismatch('%s handler entry row %s but the gate model says %s' % (where, row, nxt))
        expected_i = row + 1
        if ctx.phase.get(row, 0) != phase:
            raise Mismatch('%s row %d entered with phase %d, model %d' % (where, row, phase, ctx.phase.get(row, 0)))
        stats['steps'] += 1
        stats['phase%d_steps' % phase if phase in (0, 1, 2) else 'phaseX_steps'] += 1
        if nat is None:
            if not (last and broken):
                after = x.row_phase(row)
                ctx.phase[row] = after
                if phase == 2:
                    ctx.complete[row] = 1 if spec_r.get('subtype', 1) == 1 else 0
                    stats['completions'] += 1
                if x.cells()[7] != 3:
                    mode_model = x.cells()[7]
            continue
        status, why, fx, cl, nm, res = nat.step(row, phase)
        if last and broken:
            kind = 'H1' if hang else ('H2' if fault else 'FATAL')
            if hang or fault:
                ok = status != 0
            else:
                ok = status == 4
            if not ok:
                raise Mismatch('%s original %s (%s) but native status %d (%s)' % (where, kind, hang or fault or hex(fatal), status, why))
            stats['known_observed'][kind + ':' + ctx.sc['id']] += 1
            ctx.stop = True
            ctx.skip_final = True
            continue
        if status == 3 and phase in (1, 2) and ctx.sc['group'] == 'rows':
            # D5/G1: two rows share the singleton. The original keeps stepping row A's body on the state row B built;
            # the native e0_step refuses it as UNSUPPORTED before any effect.
            if fx:
                raise Mismatch('%s native refused (UNSUPPORTED) but logged %d effects' % (where, len(fx)))
            stats['known_observed']['D5:phase-not-owner:' + ctx.sc['id']] += 1
            stopped_early = True
            break
        if status == 5 and not ctx.sc.get('bounds_ok') and not (0 <= x.rs16(OBJ + 0xd01) <= 30):
            # D7: the original loaded a round record whose code length is outside 0..30 (a round index no reachable play
            # produces: round 0 with rounds > 0); native E0_ERR_BOUNDS before the first effect.
            # the effects before the refusal (a tick, a sound probe) must be exactly the original's first effects
            if [(k, s32(a), s32(b)) for k, a, b in fx] != [(k, s32(a), s32(b)) for k, a, b in fxs[:len(fx)]]:
                raise Mismatch('%s native BOUNDS after %d effects that are not a prefix of the original visit' % (where, len(fx)))
            stats['known_observed']['D7:round-record:' + ctx.sc['id']] += 1
            stopped_early = True
            break
        if status == 5 and ctx.sc.get('bounds_ok'):
            stats['known_observed']['D4:bounds:' + ctx.sc['id']] += 1
            stopped_early = True
            break
        if status != 0:
            raise Mismatch('%s native refused (status %d: %s) where the original ran: row %d phase %d, original obj state %d round %d K %d' % (
                where, status, why, row, phase, x.rs32(OBJ + 0xd2c), x.rs16(0x5957b7), x.rs16(OBJ + 0xd01)))
        dbg = ' [orig obj state %d show %d scene %d typed %d solved %d | native image state %d show %d scene %d typed %d solved %d]' % (
            x.rs32(OBJ + 0xd2c), x.rs32(OBJ + 0xd44), x.rs16(OBJ + 0xe08), x.rs16(OBJ + 0xd32), x.rd(OBJ + 0xdfe, 1)[0],
            *[struct.unpack_from(f, nat.image()[0], o_)[0] for f, o_ in (('<i', 0xd2c), ('<i', 0xd44), ('<h', 0xe08), ('<h', 0xd32), ('<B', 0xdfe))])
        try:
            compare_seq('%s entry %d' % (where, n_i), 'effect', [(ENTER, row, phase)] + fxs, [(ENTER, row, phase)] + fx)
        except Mismatch as err:
            raise Mismatch(str(err) + dbg)
        compare_seq('%s entry %d' % (where, n_i), 'host call', [(ENTER, row, phase)] + csegs[n_i][2], [(ENTER, row, phase)] + cl, HN)
        nfx.extend(fx)
        names.extend(nm)
        after = x.row_phase(row)
        # phase 2: the native kernel reports phase_after 2 and completed (the executor then applies 0x42ba3a); the original ran
        # 0x42ba3a itself, which stored 0 (tag E2). Every other visit must agree exactly.
        if res[2]:
            if res[0] != 2 or after != 0:
                raise Mismatch('%s row %d completion: original phase %d native phase_after %d' % (where, row, after, res[0]))
            stats['known_observed']['E2:completion-phase:' + ctx.sc['id']] += 1
            res = (0, res[1], res[2])
        elif after != res[0]:
            raise Mismatch('%s row %d phase: original %d native %d' % (where, row, after, res[0]))
        if bool(res[1]) != (phase == 0):
            raise Mismatch('%s initialized flag %d for phase %d' % (where, res[1], phase))
        if bool(res[2]) != (phase == 2):
            raise Mismatch('%s completed flag %d for phase %d' % (where, res[2], phase))
        ctx.phase[row] = res[0]
        if res[2]:
            ctx.complete[row] = 1 if spec_r.get('subtype', 1) == 1 else 0
            stats['completions'] += 1
        if nat.cells()[7] != 3:
            mode_model = nat.cells()[7]
    if stopped_early:
        ctx.stop = ctx.skip_final = True
        return len(entered)
    if not broken:
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt not in (None, 'unknown'):
            raise Mismatch('%s handler not entered for row %s although the gate model opens it' % (where, nxt))
    else:
        ctx.stop = True
        if nat is None:
            stats['known_observed'][('H1' if hang else 'H2' if fault else 'FATAL') + ':' + ctx.sc['id']] += 1
        elif fatal is not None and fatal != ctx.sc.get('expect_fatal'):
            raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
    count_effects(stats, [t for t in x.fx if t[0] != ENTER])
    stats['host_calls'] += len([t for t in x.calls if t[0] != ENTER])
    stats['image_loads'] += len(x.loaded)
    if nat is not None and not broken:
        if x.loaded != names:
            raise Mismatch('%s loaded image names differ: original %r native %r' % (where, x.loaded, names))
    if not broken:
        check_consumption(where, ctx)
    if not entered:
        stats['gate_closed_ticks'] += 1
    for st in x.states_seen:
        ctx.states.add(st)
    if not broken:
        compare_state(where, ctx)
    return len(entered)


# -- pointer / click / render / cleanup / invalidate ------------------------------------------------
def do_pointer(ctx, where, px, py):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    row = active_row(ctx)
    canary = {G_CAND: 0xfeedface, G_CURSOR: 0x77, G_CURSOR2: 0x88, 0x5d1631: 0x99, 0x5d1639: 0xaa, 0x5d162d: 0xbb}
    save = {a: x.rd(a, 4) for a in canary}
    for a, v in canary.items():
        x.w32(a, v)
    load_queues(ctx, [], [])
    hit = x.run_op(0x470ffe, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000], OBJ)
    got = {a: x.rs32(a) & 0xffffffff for a in canary}
    written = {a: got[a] != v for a, v in canary.items()}
    if len(set(written.values())) != 1:
        raise Mismatch('%s original wrote the cursor cells partially %s' % (where, written))
    cand_written = written[G_CAND]
    if hit not in (0, 1) or bool(hit) != cand_written:
        raise Mismatch('%s pointer return %d but cells written %s' % (where, hit, cand_written))
    if x.fx or x.calls:
        raise Mismatch('%s original pointer receiver logged effects' % where)
    cur = got[G_CURSOR]
    cand = s32(got[G_CAND])
    if cand_written:
        cell = x.rs32(G_CURSOR_CELL) & 0xffffffff
        ok = (got[G_CURSOR2] == 1 and got[0x5d1639] == 1 and got[0x5d162d] == cell and
              got[0x5d1631] == (0x5b160c + (cur << 5) + 16) and cur in (9, 0x16) and cand in (0x27a6, 0x27ad) and
              (cur == 9) == (cand == 0x27ad))
        if not ok:
            # the exit button also writes 0x16 / 0x27a6; only the exit rectangle writes 9 / 0x27ad
            raise Mismatch('%s original cursor cells violate the 0x470ffe contract: %s' % (where, {hex(a): hex(v) for a, v in got.items()}))
        ctx.cand = cand
        stats['pointer_hits'] += 1
        stats['pointer_cand_%x' % cand] += 1
    else:
        for a, v in save.items():
            x.wr(a, v)
    if nat is not None:
        status, out = nat.pointer(row, px, py)
        if status != 0:
            raise Mismatch('%s native pointer status %d' % (where, status))
        nhit, ncand, ncur = out
        if hit != nhit:
            raise Mismatch('%s pointer return: original %d native %d' % (where, hit, nhit))
        if cand_written:
            if (cand, cur) != (ncand, ncur):
                raise Mismatch('%s cursor/candidate: original %#x/%d native %#x/%d' % (where, cand, cur, ncand, ncur))
            nat.lib.e0o_set_entry_u32(nat.h, 2, 8, x.rs32(G_CURSOR_CELL) & 0xffffffff)
            nat.lib.e0o_set_entry_u32(nat.h, 2, 0xc, got[0x5d1631])
            nat.lib.e0o_set_entry_u32(nat.h, 2, 0x14, 1)
        elif ncand != -1 or ncur != 0:
            raise Mismatch('%s native wrote cursor/candidate %d/%d, original did not' % (where, ncand, ncur))
    stats['pointer_moves'] += 1
    compare_state(where, ctx)
    return hit


def do_click(ctx, where, cand=None, rowphase=None, flag=None):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    if cand is not None:
        x.w32(G_CAND, cand)
        ctx.cand = s32(cand)
    if flag is not None:
        x.w32(START_FLAG, flag)
        if nat:
            w = nat.world()
            nat.set_world(flag, w[1], w[2])
    row = obj_row(ctx)
    if rowphase is not None and row is not None:
        x.w32(ROWS + row * ROW + PHASE_OFF, rowphase)
        ctx.phase[row] = rowphase
    rp = ctx.phase.get(row, 0) if row is not None else 0
    img = x.image()
    acts = bool(img[0xd3e] and struct.unpack_from('<i', img, 0xd2c)[0] == 0 and rp == 1)
    ticks, busy = gen_queues(ctx, dict(ticks='clock', count=4, steps=(0,), busy='zero'))
    load_queues(ctx, ticks, busy)
    hover = struct.unpack_from('<h', img, 0xd2a)[0]
    if acts and ctx.cand == 0x27a6 and hover != 0x28 and not 0 <= hover <= 99:
        stats['known_observed']['D3:click-hover:' + ctx.sc['id']] += 1
        if nat is not None:
            st = nat.click(row if row is not None else ctx.first, rp, ctx.cand, x.rs32(START_FLAG))
            if st[0] != 5 or st[2]:
                raise Mismatch('%s native click with hover %d: status %d effects %d (expected BOUNDS, none)' % (where, hover, st[0], len(st[2])))
        return
    try:
        x.run_op(0x4712bd, [], OBJ)
    except Hang:
        stats['known_observed']['H1:click:' + ctx.sc['id']] += 1
        ctx.stop = ctx.skip_final = True
        return
    if nat is not None:
        status, newp, fx, cl, nm = nat.click(row if row is not None else ctx.first, rp, ctx.cand, x.rs32(START_FLAG))
        if status != 0:
            raise Mismatch('%s native click status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
        compare_seq(where, 'host call', x.calls, cl, HN)
        if row is not None and x.row_phase(row) != newp:
            raise Mismatch('%s click row phase: original %d native %d' % (where, x.row_phase(row), newp))
    check_consumption(where, ctx)
    count_effects(stats, x.fx)
    stats['host_calls'] += len(x.calls)
    if row is not None:
        ctx.phase[row] = x.row_phase(row)
    stats['clicks'] += 1
    stats['clicks_acting' if acts else 'clicks_ignored'] += 1
    compare_state(where, ctx)


def blit_kind(b, bg):
    return 2 if (b['fn'] == 0x4c5d4b and b['src_surface'] == bg) else (1 if b['fn'] == 0x4c5d4b else 0)


def do_render(ctx, where, back=0x22220000):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    row = x.rs16(OBJ + 0xd28)
    slot = x.rs16(OBJ + 0xd38)
    if not x.rd(OBJ + 0xd3e, 1)[0] or slot == -1 or row_spec(ctx, row) is None:
        stats['render_skipped_unreachable'] += 1  # the entry is released: the engine never calls the callback
        return
    x.w32(G_BACK, back)
    x.w32(G_BG, BG_SURFACE)
    if nat:
        nat.lib.e0o_set_entry_u32(nat.h, 1, 8, BG_SURFACE)    # Z entry 1 +8 is 0x5d15e3, the restore source
    x._reset_logs()
    x.call(0x472a5c, [], 0)
    stats['render_calls'] += 1
    bl = x.blits
    stats['blit_calls'] += len(bl)
    for b in bl:
        stats['blit_kind_%d' % blit_kind(b, BG_SURFACE)] += 1
        if b['dst_surface'] != back:
            raise Mismatch('%s blit destination surface %#x' % (where, b['dst_surface']))
        if b['label'] not in x.blit_labels:
            raise Mismatch('%s blit label is not one of the seven site labels' % where)
        ctx.label_kind.setdefault(b['label'], set()).add(blit_kind(b, BG_SURFACE))
    if x.fx:
        raise Mismatch('%s render logged effects' % where)
    if nat is not None:
        status, plan = nat.plan(row)
        if status != 0:
            raise Mismatch('%s native plan status %d' % (where, status))
        want = [(blit_kind(b, BG_SURFACE), tuple(b['src']), tuple(b['dst'])) for b in bl]
        if plan['count'] != len(bl) or want != plan['blits'] or (len(bl) > 0 and not plan['valid']):
            k = next((i for i in range(min(len(want), len(plan['blits']))) if want[i] != plan['blits'][i]), None)
            raise Mismatch('%s render plan valid %d: original %d blits, native %d; first difference %s: %s vs %s' % (
                where, plan['valid'], len(bl), plan['count'], k, want[k] if k is not None else None,
                plan['blits'][k] if k is not None else None))
        if not bl and plan['valid']:
            stats['render_valid_empty'] += 1
        sheet = x.entry_surface(slot)
        for b in bl:
            if b['src_surface'] not in (BG_SURFACE, sheet):
                raise Mismatch('%s blit source surface %#x' % (where, b['src_surface']))
        if bl and plan['surface'] != sheet:
            raise Mismatch('%s plan surface %#x vs sheet %#x' % (where, plan['surface'], sheet))
        # the native role of every blit must be the original call site that drew it (the site label the call passed)
        for i, b in enumerate(bl):
            # several sites share one label text ("Keypad buttons down"), so the text is what identifies the site
            if x.site_text[BLIT_LABELS[plan['roles'][i]]] != b['label']:
                raise Mismatch('%s blit %d: original label %r, native role %d (label %r)' % (
                    where, i, b['label'], plan['roles'][i], x.site_text[BLIT_LABELS[plan['roles'][i]]]))
        stats['blit_roles_checked'] += len(bl)
        for (k_, s_, d_), b in zip(plan['blits'], bl):
            if k_ != blit_kind(b, BG_SURFACE):
                raise Mismatch('%s blit kind' % where)
    compare_state(where, ctx)


def do_cleanup(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    load_queues(ctx, [], [])
    x.run_op(0x470ddc, [], OBJ)
    if nat is not None:
        status, fx, cl, nm = nat.simple(lambda: nat.lib.e0o_cleanup(nat.h))
        if status != 0:
            raise Mismatch('%s native cleanup status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
        compare_seq(where, 'host call', x.calls, cl, HN)
    stats['cleanups'] += 1
    count_effects(stats, x.fx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = x.rs16(OBJ + 0xd38)
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        if nat:
            nat.lib.e0o_set_entry_u32(nat.h, slot, 0x14, 0)
    x.run_op(0x470e31, [], OBJ)
    if nat is not None:
        status, fx, cl, nm = nat.simple(lambda: nat.lib.e0o_invalidate(nat.h))
        if status != 0:
            raise Mismatch('%s native invalidate status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
        compare_seq(where, 'host call', x.calls, cl, HN)
    stats['invalidates'] += 1
    count_effects(stats, x.fx)
    compare_state(where, ctx)


def do_scene_reset(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    x.run_op(0x470e71, [], OBJ)
    if nat is not None:
        nat.lib.e0o_scene_reset(nat.h)
    if x.fx or x.calls:
        raise Mismatch('%s scene reset logged effects' % where)
    stats['scene_resets'] += 1
    compare_state(where, ctx)


def do_poke(ctx, where, pokes, words=None):
    """Force object bytes on both sides (states the game cannot reach; the code paths are the original's)."""
    for off, data in pokes.items():
        ctx.x.wr(OBJ + off, data)
    if words:
        for a, v in words.items():
            ctx.x.wr(a, struct.pack('<h', v))
    if ctx.nat:
        img = bytearray(ctx.nat.image()[0])
        for off, data in pokes.items():
            img[off:off + len(data)] = data
        ctx.nat.set_image(bytes(img))
        w = ctx.nat.words()
        if words:
            ctx.nat.lib.e0o_set_words(ctx.nat.h, words.get(W57B7, w[0]), words.get(W57B5, w[1]))
    ctx.stats['pokes'] += 1
    compare_state(where, ctx)


def pk16(v):
    return struct.pack('<h', v)


def fuzz_pokes(ctx):
    """Plausible but arbitrary object states: every case of the state switch is entered with real data."""
    r, x = ctx.rng, ctx.x
    row = active_row(ctx)
    flag = ctx.row_flags.get(row, 1)
    body = x.row_body(row, flag)
    N = max(0, min(struct.unpack_from('<h', body, B_N)[0], 100))
    K = max(0, min(struct.unpack_from('<h', body, B_REC0)[0], 30))
    p, words = {}, {}
    p[0xd2c] = struct.pack('<i', r.choice([0, 1, 2, 3, 4, 3, 4, 1, 5, 7]))
    for off in (0xdfe, 0xdff, 0xd3a, 0xd3b, 0xd3c, 0xd3f):
        if r.random() < 0.3:
            p[off] = bytes([r.randrange(2)])
    if r.random() < 0.5:
        p[0xd32] = pk16(r.choice([0, 0, 1, K, max(K - 1, 0)]))
        lit = bytearray(x.rd(OBJ + 0xc9c, 100))
        for i in range(N):
            lit[i] = int(r.random() < 0.3)
        p[0xc9c] = bytes(lit)
    if r.random() < 0.4:
        p[0xd30] = pk16(r.choice([0, 0, 1, 2, max(N - 1, 0)]))
    for off in (0xd40, 0xd44, 0xe00):
        if r.random() < 0.6:
            p[off] = struct.pack('<I', (ctx.clock + r.choice([-3000, -1, 0, 1, 5, 400, 3000, 0x80000000])) & 0xffffffff)
    if r.random() < 0.4:
        p[0xe08] = pk16(r.choice([9999, 0, 5, -3, 1234]))
    if r.random() < 0.3:
        # a set count the body supports: the leading code sets that start with a non-zero byte (the original reads an
        # uninitialised local for an empty set among the first set_count, tag D2)
        lead = 0
        while flag == 0 and lead < 5 and len(body) > B_D6_SETS + 5 * lead and body[B_D6_SETS + 5 * lead] != 0:
            lead += 1
        p[0xe06] = pk16(r.randrange(lead + 1))
    if r.random() < 0.3 and N > 0:
        p[0xd2a] = pk16(r.choice([-1, 0x28, r.randrange(N)]))
    if r.random() < 0.3:
        words[W57B7] = (r.choice([1, 2, 3]) if struct.unpack_from('<h', body, B_R)[0] > 0 else 0) if flag == 0 else 0  # records 0..4 only; round 0 with rounds > 0 is unreachable (D7)
    return p, words


def untilcheck(ctx, until):
    x = ctx.x
    row = obj_row(ctx)
    if until == 'done':
        return all(ctx.complete.get(r, 0) for r in range(ctx.first, ctx.first + len(ctx.rows)))
    if until == 'phase2':
        return row is not None and ctx.phase.get(row, 0) == 2
    return False


# -- dynamic targets and the auto-player ---------------------------------------------------------------
def center(r):
    return clamp16((r[0] + r[2]) // 2), clamp16((r[1] + r[3]) // 2)


def key_rect(x, i):
    return struct.unpack('<4i', x.rd(OBJ + 0x65c + 16 * i, 16))


def pointer_target(ctx, style):
    x, r = ctx.x, ctx.rng
    row = active_row(ctx)
    flag = ctx.row_flags.get(row, 1)
    body = x.row_body(row, flag)
    N = max(0, min(struct.unpack_from('<h', body, B_N)[0], 100))
    img = x.image()
    K = struct.unpack_from('<h', img, 0xd01)[0]
    code = img[0xd04:0xd04 + 30]
    ordered = img[0xd03]
    typed = struct.unpack_from('<h', img, 0xd32)[0]
    lit = img[0xc9c:0xc9c + 100]
    exit_rect = struct.unpack_from('<4i', body, B_XRECT)
    exit_btn = struct.unpack_from('<4i', body, B_EXIT_RECT)
    roll = r.random()
    if roll < style.get('exit_p', 0.02):
        return center(exit_rect)
    if roll < style.get('exit_p', 0.02) + style.get('btn_p', 0.03):
        return center(exit_btn)
    if roll < 0.9 and N > 0:
        goal = style.get('goal', 'code')
        if goal == 'set' and flag == 0:
            sets = [list(body[B_D6_SETS + 5 * j:B_D6_SETS + 5 * j + 5]) for j in range(5)]
            sets = [s for s in sets if s[0]]
            if sets and r.random() < 0.85:
                s = r.choice(sets)
                ks = [v - 1 for v in s if v and 0 <= v - 1 < N]
                if ks:
                    return center(key_rect(x, r.choice(ks)))
        if r.random() < style.get('correct', 0.8) and 0 < K <= 30:
            if ordered or body[B_ORD]:
                want = code[typed] if 0 <= typed < K else code[r.randrange(K)]
            else:
                todo = [c for c in code[:K] if c < N and not lit[c]] or list(code[:K])
                want = r.choice(todo)
            if want < N:
                return center(key_rect(x, want))
        return center(key_rect(x, r.randrange(N)))
    if roll < 0.93 and N > 0:
        l, t, rr, b = key_rect(x, r.randrange(N))
        return clamp16(r.choice([l, rr, l - 1, rr + 1])), clamp16(r.choice([t, b, t - 1, b + 1]))
    if roll < 0.96:
        return -9, -9
    return r.randrange(-50, 700), r.randrange(-50, 760)


def play(ctx, where, n, style):
    """The auto-player: `n` iterations of ticks, pointer moves, clicks, renders and invalidates chosen from the
    ORIGINAL's current memory (so the native side is driven with exactly the same inputs)."""
    r = ctx.rng
    fast = dict(ticks='clock', busy=style.get('busy', 'zero'), steps=style.get('steps', STEPS))
    for i in range(n):
        if ctx.stop:
            return
        ctx.tickno += 1
        roll = r.random()
        w = '%s play %d' % (where, i)
        if roll < style.get('p_tick', 0.5):
            do_tick(ctx, w, fast if r.random() < 0.85 else dict(fast, busy='rand', ticks=r.choice(['dl', 'rand', 'clock'])))
        elif roll < 0.84:
            px, py = pointer_target(ctx, style)
            hit = do_pointer(ctx, w, px, py)
            if hit and r.random() < 0.9:
                do_click(ctx, w + ' click', r.choice([None, 0x27a6, 0x27ad, -1, 7]) if r.random() < style.get('wild_click', 0.05) else None,
                         None, r.choice([0, 1]) if r.random() < style.get('flag_p', 0.1) else None)  # 0x5bb1ca = 0 mutes the click sound
            elif not hit and r.random() < 0.05:
                do_click(ctx, w + ' stale-click')     # the candidate of the previous hit is still retained
        elif roll < 0.89:
            do_render(ctx, w + ' render', 0x22220000 + i)
        elif roll < 0.92:
            do_invalidate(ctx, w + ' invalidate')
        elif roll < 0.94 and style.get('fuzz', False):
            do_poke(ctx, w + ' fuzz', *fuzz_pokes(ctx))
        else:
            px, py = pointer_target(ctx, dict(style, exit_p=0, btn_p=0))
            do_pointer(ctx, w, px, py)
        if style.get('until', 'done') != 'never' and untilcheck(ctx, style.get('until', 'done')):
            return


def sync_events(ctx):
    if ctx.nat:
        ctx.nat.set_events(ctx.x.events_raw())


def set_view(ctx, v):
    ctx.view = v
    ctx.x.w32(G_ORIGIN_X, v[0])
    ctx.x.w32(G_ORIGIN_Y, v[1])
    if ctx.nat:
        ctx.nat.set_view(*v)


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
    ctx.label_kind = {}
    nat = ctx.nat
    try:
        x.install_rows(ctx.rows, ctx.first)
        for r in range(ctx.first):
            ctx.complete[r] = 1
        if nat:
            for k, spec in enumerate(ctx.rows):
                if nat.load_body(ctx.first + k, spec['flag'], spec['body']) != 0:
                    raise Mismatch('%s native refused to load the body of row %d' % (sc['id'], ctx.first + k))
        x.wr(G_MODE, struct.pack('<i', sc.get('mode', 3)))
        for idx, v in sc.get('events', {}).items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
        # seeds: the cells and the flag start non-zero so a skipped store cannot hide
        seeds = [sc.get('stale_5bb57b', 0x11111111), 0x2222, -0x3333, 0x4444, 0x55555555, 0x66666666, 0x77777777]
        for (a, sz), v in zip(CELLS, seeds):
            x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
        if nat:
            nat.set_cells(x.cells())
        x.w32(START_FLAG, 5)
        x.w32(G_CAND, 0)
        x.w32(G_CURSOR_CELL, sc.get('cursor_cell', 0x1234))
        x.w32(ENTRY17, 0x55)
        if nat:
            nat.set_world(5, x.rs32(0x5bb57b), 0x55)
            nat.set_handles(x.handles)
        set_view(ctx, VIEWS['v0'])
        for s in sc.get('busy_slots', []):
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            if nat:
                nat.lib.e0o_set_busy_slot(nat.h, s, 1)
        compare_state('initial', ctx)
        for ai, act in enumerate(sc['actions']):
            exec_action(ctx, '%s action %d %s' % (sc['id'], ai, act[0]), act)
            if ctx.stop:
                break
        if not ctx.skip_final:
            compare_state(sc['id'] + ' end', ctx)
        stats['scenarios'] += 1
        for st in ctx.states:
            stats['scenarios_reaching_%s' % st] += 1
        stats['states_per_scenario'][len([s for s in ctx.states if isinstance(s, int)])] += 1
        for lab, kinds in ctx.label_kind.items():
            stats['label_site_%x_kind_%d' % (x.blit_labels[lab], max(kinds))] += 1
    finally:
        if nat:
            nat.close()


def exec_action(ctx, where, act):
    x, nat = ctx.x, ctx.nat
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
        if nat:
            c = nat.cells()
            c[7] = act[1]
            nat.set_cells(c)
    elif kind == 'flag':
        x.w32(START_FLAG, act[1])
        if nat:
            w = nat.world()
            nat.set_world(act[1], w[1], w[2])
    elif kind == 'stale':          # the stale value of the dword 0x5bb57b
        x.w32(0x5bb57b, act[1])
        if nat:
            c = nat.cells()
            c[0] = s32(act[1])
            nat.set_cells(c)
            w = nat.world()
            nat.set_world(w[0], s32(act[1]), w[2])
    elif kind == 'events':
        for idx, v in act[1].items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
    elif kind == 'busy':
        ctx.pending_busy = list(act[1])
    elif kind == 'poke':
        do_poke(ctx, where, act[1], act[2] if len(act) > 2 else None)
    elif kind == 'fuzz':
        do_poke(ctx, where, *fuzz_pokes(ctx))
    elif kind == 'ptr':
        do_pointer(ctx, where, act[1], act[2])
    elif kind == 'ptr_dyn':
        px, py = pointer_target(ctx, act[1] if len(act) > 1 else {})
        do_pointer(ctx, where, px, py)
    elif kind == 'click':
        do_click(ctx, where, *act[1:])
    elif kind == 'invalidate':
        do_invalidate(ctx, where)
    elif kind == 'scene_reset':
        do_scene_reset(ctx, where)
    elif kind == 'cleanup':
        do_cleanup(ctx, where)       # the scene teardown of the engine: the rows go away with the object
        if len(act) < 2:
            for r in range(ctx.first, ctx.first + len(ctx.rows)):
                x.wr(ROWS + r * ROW + COMPLETE_OFF, b'\1')
                ctx.complete[r] = 1
    elif kind == 'revive':           # the scene is entered again: every row starts over
        for r in range(ctx.first, ctx.first + len(ctx.rows)):
            x.wr(ROWS + r * ROW + COMPLETE_OFF, b'\0')
            x.w32(ROWS + r * ROW + PHASE_OFF, 0)
            ctx.complete[r] = 0
            ctx.phase[r] = 0
    elif kind == 'render':
        do_render(ctx, where, *act[1:])
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
    elif kind == 'refuse':
        do_refuse(ctx, where, act)
    else:
        raise OracleError('unknown action ' + kind)


def do_refuse(ctx, where, act):
    """D2/D6: the body is refused by the native validator before any effect (the original overruns or runs on garbage)."""
    flag, body, tag = act[1], act[2], act[3]
    if ctx.lib is not None:
        st = ctx.lib.e0o_validate(flag, cbuf(body), len(body))
        if st != 2:
            raise Mismatch('%s expected E0_ERR_BODY from the validator, got %d' % (where, st))
        n = Native(ctx.lib)
        try:
            if n.load_body(0, flag, body) == 0:
                st2, why, fx, cl, nm, res = n.step(0, 0)
                if st2 == 0 or fx:
                    raise Mismatch('%s native ran a refused body (status %d, %d effects)' % (where, st2, len(fx)))
        finally:
            n.close()
    ctx.stats['known_observed']['D2:validate:' + tag] += 1


CLK = dict(ticks='clock', busy='zero')
CLKR = dict(ticks='clock', busy='rand')


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def S(scs, sid, rows, actions, group, **kw):
    sc = dict(id=sid, rows=rows, actions=actions, group=group, quick=kw.pop('quick', False), first=kw.pop('first', 0))
    sc.update(kw)
    scs.append(sc)
    return sc


def R(flag, body, subtype=1, tail=b'', **kw):
    d = dict(flag=flag, body=body, tail=tail, subtype=subtype)
    d.update(kw)
    return d


def patch(body, flag, **fields):
    """A corpus / synthetic body with scalar fields replaced."""
    b = bytearray(body)
    for k, v in fields.items():
        if k == 'N':
            struct.pack_into('<h', b, B_N, v)
        elif k == 'ordered':
            b[B_ORD] = v
        elif k == 'exit_btn':
            b[B_EXIT] = v
        elif k == 'rec':
            b[B_REC0:B_REC0 + 33] = record(*v)
        elif k == 'snd_a':
            b[B_SND_A:B_SND_A + 9] = v.ljust(9, b'\0')[:9]
        elif k == 'snd_b':
            b[B_SND_B:B_SND_B + 9] = v.ljust(9, b'\0')[:9]
        elif k == 'delay':
            struct.pack_into('<h', b, B_DELAY, v)
        elif k == 'fail':
            b[B_FAIL:B_FAIL + 25] = v
        elif k == 'xblock':
            b[B_XBLOCK:B_XBLOCK + 25] = v
        elif k == 'R':
            struct.pack_into('<h', b, B_R, v)
        elif k == 'blink' and flag == 0:
            b[B_D6_BLINK] = v
        elif k == 'sets' and flag == 0:
            for j in range(5):
                b[B_D6_SETS + 5 * j:B_D6_SETS + 5 * j + 5] = bytes((v[j] if j < len(v) else [])[:5]).ljust(5, b'\0')
        elif k == 'allb' and flag == 0:
            b[B_D6_ALL:B_D6_ALL + 25] = v
        elif k == 'rounds' and flag == 0:
            for j, r_ in enumerate(v):
                b[B_D6_REC1 + 33 * j:B_D6_REC1 + 33 * j + 33] = record(*r_)
        elif k == 'layout' and flag == 1:
            struct.pack_into('<12h', b, B_E0_LAYOUT, *v)
        elif k == 'click_ch':
            struct.pack_into('<h', b, B_CLICK_CH, v)
        elif k == 'ch_b':
            struct.pack_into('<h', b, B_CH_B, v)
        else:
            raise OracleError('patch field ' + k)
    return bytes(b)


def snd_cases():
    return [NO_SOUND, b'REAL_SOUND', b'NO SOUNDX', b'NO SOUN\0\0', b'', b'no sound\0', b'NO SOUND\0'[::-1], b'\0NO SOUND']


def rand_code(rng, K, N):
    return [rng.randrange(max(N, 1)) for _ in range(K)]


def random_body(rng, flag):
    N = rng.choice([0, 1, 2, 3, 6, 9, 12, 20, 29, 30, 40, 100] if flag == 0 else [0, 1, 4, 6, 6, 9, 12])
    ordered = rng.randrange(2)
    if ordered and N > 30:
        N = rng.choice([6, 12, 30])
    nsets = rng.choice([0, 0, 1, 2, 3, 5]) if flag == 0 else 0
    if nsets and N > 29:
        N = rng.choice([6, 12, 29])
    K = rng.choice([0, 1, 3, 3, 5, 10, 29, 30])
    sets = []
    for _ in range(nsets):
        sets.append([rng.randrange(1, max(N, 1) + 1) for _ in range(rng.randrange(1, 6))])
    lay = {}
    if flag == 1:
        cols = rng.choice([1, 2, 3, 3, 4, 5, 6, 12, -2, 7])
        rows = rng.choice([1, 2, 3, 2, -1, 4])
        if not (0 <= (cols * rows) <= 100) or (cols == 0):
            cols, rows = 3, 2
        N = cols * rows
        lay = dict(cols=cols, rows=rows, kw=rng.choice([10, 30, 0, -5]), kh=rng.choice([10, 20, 0]), x0=rng.choice([0, 20, -30]),
                   y0=rng.choice([0, 40, -10]), xg=rng.choice([0, 5, -3]), yg=rng.choice([0, 7, 3]), x0b=rng.choice([100, 200]),
                   y0b=rng.choice([0, 60]), xgb=rng.choice([0, 5]), ygb=rng.choice([0, 7]))
        if ordered and N > 30:
            ordered = 0
    else:
        lay = dict(cols=rng.choice([3, 5, 7]))
    blocks = finish_blocks()
    rounds = [(rng.choice([0, 1, 2, 3, 5]), rng.randrange(2), rand_code(rng, 5, max(N, 1))) for _ in range(4)] if flag == 0 else None
    rec = (K, rng.randrange(2), rand_code(rng, K, max(N, 1)))
    return make_body(rng, flag, N=N, ordered=ordered, exit_btn=rng.random() < 0.7, rec=rec, snd_a=rng.choice(snd_cases()[:4]),
                     snd_b=rng.choice(snd_cases()[:4]), click_ch=rng.choice([0, 2, -1, 300]), ch_b=rng.choice([0, 3, -2]),
                     delay=rng.choice([0, 1, 2, 3, 30, -1, 32000]), fail=rng.choice(blocks), xblock=rng.choice(blocks),
                     R=rng.choice([0, 1, 2, 3, 4]) if flag == 0 else rng.choice([9999, 0, 4377, 1234, 3]),
                     layout=lay, blink=rng.randrange(2), rounds=rounds, sets=sets, allb=rng.choice(blocks),
                     exit_rect=rng.choice([(300, 400, 360, 440), (0, 0, 0, 0), (-10, -10, 10, 10)]))


def scenario_list(seed=51, n_random=220):
    rng = random.Random(seed)
    scs = []
    cb = corpus_rows()
    PL = dict(until='done', exit_p=0.02)
    blocks = finish_blocks()

    # -- before init: everything is inert
    b0 = make_body(rng, 1)
    S(scs, 'pre:inert', [R(1, b0)], [('ptr', 5, 5), ('click',), ('click', 0x27a6), ('click', 0x27ad), ('invalidate',), ('cleanup',), ('render', 0x2222),
                                      ('ptr', 7, 9), ('scene_reset',), ('cleanup',), ('invalidate',)], 'basic', quick=True)
    S(scs, 'pre:inert_d6', [R(0, make_body(rng, 0))], [('ptr', 5, 5), ('click',), ('scene_reset',), ('cleanup',)], 'basic')

    # -- the real corpus rows: auto-play to the end, a pointer sweep, exits, abandon and re-enter
    for i, spec in enumerate(cb):
        if not spec['valid']:
            continue
        flag, body = spec['flag'], spec['body']
        free = dict(spec, tail=b'', payload=None)
        for style_n, style in (('code', dict(PL, goal='code', correct=0.9)), ('mixed', dict(PL, goal='code', correct=0.5, exit_p=0.05)),
                               ('set', dict(PL, goal='set', correct=0.3)), ('wild', dict(PL, correct=0.3, wild_click=0.3, fuzz=True))):
            S(scs, 'corpus:%s_play_%s' % (spec['id'], style_n), [R(flag, body, spec['subtype'])],
              [('tick', CLK), ('tick', CLK), ('play', 900, dict(style, p_tick=0.45))], 'corpus', seed=100 * i + len(scs),
              quick=(i == 0 and style_n == 'code'))
        S(scs, 'corpus:%s_sweep_exit' % spec['id'], [R(flag, body, spec['subtype'])],
          [('tick', CLK), ('tick', CLK)] + [('ptr_dyn', dict(exit_p=0.3, btn_p=0.2)) for _ in range(10)] +
          [('render', 1), ('play', 60, dict(PL, exit_p=0.3)), ('run', CLK, 'phase2', 4), ('tick', CLK)], 'corpus', seed=i)
        S(scs, 'corpus:%s_abandon' % spec['id'], [R(flag, body, spec['subtype'])],
          [('tick', CLK), ('play', 150, dict(PL, until='never')), ('cleanup',), ('tick', CLK), ('invalidate',), ('revive',), ('tick', CLK),
           ('tick', CLK), ('play', 200, dict(PL, until='never')), ('render', 3), ('cleanup', 'keep'), ('invalidate',), ('render', 5)],
          'corpus', seed=7 + i)
        # the real dependency tail through the real gate (modelled by the original itself)
        S(scs, 'corpus:%s_real_tail' % spec['id'], [R(flag, body, spec['subtype'], spec['tail'], payload=spec['payload'], gate='unknown')],
          [('tick', CLK), ('tick', CLK), ('play', 120, dict(PL, until='never'))], 'corpus', seed=11 + i, quick=(i == 0))

    # -- the length-292 body of resource 1737 (refused natively; the original loader reads a fixed 294 bytes)
    for spec in cb:
        if not spec['valid']:
            S(scs, 'known:D6_%s' % spec['id'], [R(1, bytes(294))], [('refuse', 1, spec['body'], 'len%d' % len(spec['body']))], 'known', native=True,
              quick=True)

    # -- e0 matrix: layout x ordered x K x per-record ordered byte
    mi = 0
    for cols, rows in ((1, 1), (3, 2), (6, 5), (10, 10), (2, 15), (-2, -3), (4, 0), (0, 5), (512, 128)):
        for ordered in (0, 1):
            for K in (0, 1, 3, 29, 30):
                for rord in (0, 1):
                    mi += 1
                    if (mi % 3) and (cols, rows) not in ((3, 2), (1, 1)):
                        continue
                    N = (cols * rows) & 0xffff
                    if N >= 0x8000 or N > 100:
                        continue
                    if ordered and N > 30:
                        continue
                    layout = dict(cols=cols, rows=rows, kw=24, kh=16, x0=10, y0=20, xg=4, yg=6, x0b=200, y0b=20, xgb=4, ygb=6)
                    code = rand_code(rng, K, max(N, 1))
                    body = make_body(rng, 1, ordered=ordered, rec=(K, rord, code), layout=layout, blink=0,
                                     snd_a=rng.choice(snd_cases()[:3]), snd_b=rng.choice(snd_cases()[:3]),
                                     fail=blocks[1 + mi % 5], xblock=blocks[mi % 6], R=rng.choice([9999, 4377, 0]), delay=mi % 3)
                    S(scs, 'matrix_e0:c%d_r%d_o%d_k%d_r%d' % (cols, rows, ordered, K, rord), [R(1, body)],
                      [('tick', CLK), ('tick', CLK), ('play', 500, dict(PL, p_tick=0.5, correct=0.85))], 'matrix_e0', seed=mi,
                      quick=(cols, rows, ordered, K, rord) in ((3, 2, 0, 3, 0), (3, 2, 1, 3, 1), (1, 1, 0, 30, 0)))
    # layout arithmetic: sizes, gaps and origins drawn at random, negative values included
    for k in range(18):
        cols = rng.choice([1, 2, 3, 5, 7, -1, -4])
        rows = rng.choice([1, 2, 3, -1, -2, 6])
        if cols * rows < 0 or cols * rows > 100 or cols == 0:
            cols, rows = 4, 3
        layout = dict(cols=cols, rows=rows, kw=rng.choice([-20, -1, 0, 1, 30, 4000, 32767]), kh=rng.choice([-20, 0, 15, 32767]),
                      x0=rng.choice([-32768, -100, 0, 50, 32767]), y0=rng.choice([-32768, -3, 0, 99, 32767]),
                      xg=rng.choice([-32768, -50, 0, 9, 32767]), yg=rng.choice([-9, 0, 31, 32767]),
                      x0b=rng.choice([-5, 0, 300, 32767]), y0b=rng.choice([-5, 0, 1, 32767]),
                      xgb=rng.choice([-7, 0, 7, 32767]), ygb=rng.choice([-1, 0, 8, 32767]))
        body = make_body(rng, 1, ordered=0, rec=(3, 0, [0, 1, rng.randrange(max(cols * rows, 1))]), layout=layout)
        S(scs, 'layout_e0:%d' % k, [R(1, body)], [('tick', CLK), ('tick', CLK), ('render', 1), ('play', 200, dict(PL, until='never')),
                                                  ('render', 2)], 'layout_e0', seed=k, quick=k < 2)

    # -- d6 matrix: rounds, code sets, blink, exit button, sounds, delays
    mi = 0
    for R_ in (0, 1, 2, 3, 5, 9999):
        for nsets in (0, 1, 3, 5):
            for blink in (0, 1):
                for exit_btn in (False, True):
                    mi += 1
                    if (mi % 3) and not (R_, nsets, blink) in ((2, 0, 0), (3, 2, 1)):
                        continue
                    N = 12
                    rounds = [(rng.choice([1, 3, 5]), rng.randrange(2), rand_code(rng, 5, N)) for _ in range(4)]
                    sets = [[rng.randrange(1, N + 1) for _ in range(rng.randrange(1, 4))] for _ in range(nsets)]
                    body = make_body(rng, 0, N=N, ordered=mi % 2, exit_btn=exit_btn, rec=(3, rng.randrange(2), rand_code(rng, 3, N)),
                                     snd_a=snd_cases()[mi % 3], snd_b=snd_cases()[(mi + 1) % 3], delay=rng.choice([0, 1, 2]),
                                     fail=blocks[1 + mi % 5], xblock=blocks[mi % 6], R=R_, blink=blink, rounds=rounds, sets=sets,
                                     allb=blocks[(mi + 2) % 6])
                    S(scs, 'matrix_d6:R%d_s%d_b%d_x%d' % (R_, nsets, blink, exit_btn), [R(0, body)],
                      [('tick', CLK), ('tick', CLK), ('play', 700, dict(PL, p_tick=0.5, goal='set' if nsets else 'code', correct=0.8))],
                      'matrix_d6', seed=mi, quick=(R_, nsets, blink, exit_btn) in ((2, 0, 0, True), (3, 3, 1, False), (5, 5, 1, True)))

    # -- sound records: NO SOUND at A and B in every spelling, both flags
    for ai, sa in enumerate(snd_cases()):
        for bi, sb in enumerate(snd_cases()):
            if (ai + bi) % 3 and not (ai == 0 and bi == 0):
                continue
            for flag in (0, 1):
                body = make_body(rng, flag, N=6, rec=(2, 0, [0, 1]), snd_a=sa, snd_b=sb, delay=0, R=2 if flag == 0 else 9999,
                                 rounds=[(2, 0, [2, 3])] * 4 if flag == 0 else None)
                S(scs, 'sound:a%d_b%d_f%d' % (ai, bi, flag), [R(flag, body)], [('tick', CLK), ('tick', CLK), ('play', 400, dict(PL, p_tick=0.5, correct=0.95))],
                  'sound', seed=ai * 10 + bi, quick=(ai, bi, flag) in ((0, 0, 1), (1, 1, 0), (2, 3, 1)))

    # -- delays and clocks: delay 0 / large / negative, wrap past 2^32
    for delay in (0, 1, 5, 32767, -1, -32768):
        for cname in ('low', 'sign', 'wrap', 'top'):
            body = make_body(rng, 1, N=6, rec=(2, 0, [0, 1]), snd_b=b'REAL', delay=delay, R=9999)
            S(scs, 'clock:d%d_%s' % (delay, cname), [R(1, body)], [('clock', cname), ('tick', CLK), ('tick', CLK),
                                                                    ('play', 300, dict(PL, correct=0.95, steps=(1, 60, 301, 1500, 9000)))],
              'clock', seed=len(scs), quick=(delay, cname) in ((1, 'wrap'), (0, 'sign')))
    for pol in ('dl', 'rand'):
        for cnt in range(4):
            body = make_body(rng, cnt % 2, N=6, rec=(2, 0, [0, 1]), R=2 if cnt % 2 == 0 else 9999, blink=1,
                             rounds=[(2, 0, [2, 3])] * 4 if cnt % 2 == 0 else None, snd_b=b'REAL' if cnt > 1 else NO_SOUND)
            S(scs, 'clock:policy_%s_%d' % (pol, cnt), [R(cnt % 2, body)],
              [('tick', CLK), ('play', 120, dict(PL, correct=0.95, until='never')), ('run', dict(ticks=pol, busy='rand'), 'phase2', 150)],
              'clock', seed=cnt, quick=(pol == 'dl' and cnt == 0))

    # -- busy scripts in the sound wait (state 4)
    for nb, busy in enumerate(([0] * 8, [1, 1, 0, 0] + [0] * 4, [1] * 8, [0, 1, 1, 0, 1, 0, 0, 0], [2, -1, 0, 0])):
        for flag in (0, 1):
            body = make_body(rng, flag, N=6, rec=(2, 0, [0, 1]), snd_b=b'REAL SOUND', delay=0, R=2 if flag == 0 else 9999, blink=1,
                             rounds=[(2, 0, [2, 3])] * 4 if flag == 0 else None)
            S(scs, 'busy:script%d_f%d' % (nb, flag), [R(flag, body)], [('tick', CLK), ('play', 500, dict(PL, busy=busy, correct=0.95, p_tick=0.55))],
              'busy', seed=nb, quick=nb in (1, 3) and flag == 0)

    # -- phase 2 branches with real data: exit asked / sets solved / failed (with and without clicks), stale-cell test
    scene_cases = [9999, 0, 5, -3, 1234]
    for flag in (0, 1):
        for ex in (0, 1):
            for ss in (0, 1):
                for typed in (0, 2):
                    for scene in scene_cases:
                        for fi, fblk in enumerate((blocks[0], blocks[1], blocks[2], blocks[5])):
                            for stale in (9999, 77):
                                if flag == 1 and ss:
                                    continue
                                if rng.random() < 0.8 and not (scene in (9999, 5) and stale == 9999 and fi in (0, 1)):
                                    continue
                                body = make_body(rng, flag, N=6, rec=(2, 0, [0, 1]), snd_a=rng.choice([NO_SOUND, b'REAL A']), snd_b=NO_SOUND,
                                                 fail=fblk, xblock=blocks[(fi + ex) % 6], R=2 if flag == 0 else scene,
                                                 allb=blocks[(fi + 2) % 6], rounds=[(2, 0, [2, 3])] * 4 if flag == 0 else None,
                                                 sets=[[1, 2]] if flag == 0 else ())
                                pokes = {0xd32: pk16(typed), 0xe08: pk16(scene), 0xd3f: bytes([ex]), 0xdff: bytes([ss]), 0xdfe: bytes([0]),
                                         0xd2c: struct.pack('<i', 1)}
                                S(scs, 'phase2:f%d_x%d_s%d_t%d_sc%d_b%d_st%d' % (flag, ex, ss, typed, scene, fi, stale), [R(flag, body)],
                                  [('tick', CLK), ('tick', CLK), ('stale', stale), ('poke', pokes), ('setphase', 0, 2),
                                   ('events', {5: 9, 77: 3, 4095: 1}), ('tick', CLK), ('tick', CLK)],
                                  'phase2', seed=len(scs), quick=(flag, ex, ss, typed, scene, fi, stale) in (
                                      (0, 0, 0, 0, 9999, 0, 9999), (1, 1, 0, 2, 5, 1, 77), (0, 0, 1, 2, 0, 2, 9999)))

    # -- forced states: every case of the state switch with real data, both flags
    for st in range(0, 7):
        for flag in (0, 1):
            for pl in (0, 1):
                body = make_body(rng, flag, N=6, ordered=pl, rec=(3, pl, [0, 1, 2]), snd_b=b'REAL' if pl else NO_SOUND, R=2 if flag == 0 else 9999,
                                 rounds=[(3, 0, [2, 3, 4])] * 4 if flag == 0 else None, blink=1, delay=pl)
                acts = [('tick', CLK), ('tick', CLK)]
                for k in range(6):
                    acts += [('poke', {0xd2c: struct.pack('<i', st), 0xd40: struct.pack('<I', 0), 0xd44: struct.pack('<I', 0)}),
                             ('fuzz',) if k % 2 else ('tick', CLK), ('tick', CLKR), ('tick', CLKR)]
                S(scs, 'state:%d_f%d_p%d' % (st, flag, pl), [R(flag, body)], acts + [('play', 150, dict(PL, fuzz=False, until='never'))], 'state',
                  seed=st * 4 + flag * 2 + pl, quick=(st, flag, pl) in ((1, 0, 0), (3, 1, 1), (4, 0, 1)))
    for k in range(24):
        flag = k % 2
        body = random_body(rng, flag)
        S(scs, 'fuzz:%d' % k, [R(flag, body)], [('tick', CLK), ('tick', CLK), ('play', 300, dict(PL, fuzz=True, until='never', p_tick=0.5, correct=0.7))], 'fuzz',
          seed=k, quick=k < 3)

    # -- rows: re-init, chains, false gates, subtype 2, rows that share the singleton
    ba = make_body(rng, 1, N=6, rec=(2, 0, [0, 1]), R=100, fail=blocks[1], xblock=blocks[2])
    bb = make_body(rng, 0, N=6, rec=(2, 0, [0, 1]), R=2, rounds=[(2, 0, [2, 3])] * 4, fail=blocks[3])
    tail_b = struct.pack('<8h', 2, 7, 1, 0, 0, 0, 0, 0)
    S(scs, 'rows:chain_dep', [R(1, ba), R(0, bb, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('play', 300, PL), ('tick', CLK), ('events', {7: 1}),
                                                              ('play', 300, PL), ('tick', CLK)], 'rows', quick=True, handles=[0x7101, 0x7102, 0x7103])
    S(scs, 'rows:chain_subtype2', [R(1, ba, 2), R(0, bb, 2, tail_b)], [('tick', CLK), ('play', 150, dict(PL, until='never')), ('tick', CLK), ('events', {7: 1}),
                                                                        ('tick', CLK), ('tick', CLK), ('run', CLK, 'phase2', 10), ('tick', CLK)], 'rows',
      handles=[0x7101, 0x7102, 0x7103, 0x7104])
    S(scs, 'rows:reinit_no_cleanup', [R(1, ba)], [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('revive',), ('tick', CLK), ('ptr', 11, 22), ('tick', CLK),
                                                  ('render', 3), ('cleanup',)], 'rows', quick=True)
    S(scs, 'rows:cleanup_reinit', [R(0, bb)], [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('cleanup',), ('tick', CLK), ('revive',), ('tick', CLK), ('tick', CLK),
                                               ('render', 1), ('invalidate',), ('cleanup',), ('cleanup',), ('invalidate',), ('tick', CLK)], 'rows', quick=True)
    S(scs, 'rows:offset_first_row', [R(1, ba), R(0, bb, 1, tail_b)], [('tick', CLK), ('ptr', 1, 1), ('tick', CLK), ('play', 200, PL), ('tick', CLK)], 'rows',
      first=2, handles=[0x7101, 0x7102, 0x7103])
    S(scs, 'gate:false_dep', [R(1, ba, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',), ('events', {7: 1}), ('tick', CLK), ('tick', CLK),
                                                     ('events', {7: 0}), ('tick', CLK), ('events', {7: 1}), ('tick', CLK)], 'gate', quick=True)
    S(scs, 'gate:mode4', [R(1, ba)], [('mode', 4), ('tick', CLK), ('tick', CLK), ('mode', 3), ('tick', CLK), ('tick', CLK)], 'gate', mode=4)
    S(scs, 'slots:busy_low', [R(1, ba)], [('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x19, 0x1a], quick=True)
    S(scs, 'slots:busy_gap', [R(0, bb)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x1a, 0x1b, 0x3e])
    S(scs, 'slots:all_busy_fatal', [R(1, ba)], [('tick', CLK), ('tick', CLK)], 'slots', busy_slots=list(range(0x18, 0x40)), expect_fatal=0x52139c, quick=True)
    for vname in ('v1', 'neg', 'big', 'edge'):
        for flag in (0, 1):
            S(scs, 'view:%s_f%d' % (vname, flag), [R(flag, make_body(rng, flag, N=6, rec=(2, 0, [0, 1]), blink=1, rounds=[(2, 0, [2, 3])] * 4 if flag == 0 else None))],
              [('view', vname), ('tick', CLK), ('render', 1), ('play', 120, PL), ('render', 2)], 'view', seed=len(scs), quick=(vname, flag) == ('neg', 1))

    # -- D2 / D4: bodies the native layer refuses (the original overruns, reads an uninitialised local or runs on an empty set)
    ref = [('N101_d6', 0, make_body(rng, 0, N=101)), ('Nneg_d6', 0, make_body(rng, 0, N=-1)),
           ('K31', 0, make_body(rng, 0, N=6, rec=(31, 0, [0] * 30))), ('Kneg', 0, make_body(rng, 0, N=6, rec=(-1, 0, [0] * 30))),
           ('ord_N31', 0, make_body(rng, 0, N=31, ordered=1)), ('sets_N30', 0, make_body(rng, 0, N=30, sets=[[1, 2]])),
           ('set_zero_first', 0, make_body(rng, 0, N=6, sets=[[0, 2], [1]])),
           ('e0_N101', 1, make_body(rng, 1, layout=dict(cols=101, rows=1))), ('e0_Nneg', 1, make_body(rng, 1, layout=dict(cols=-3, rows=3))),
           ('e0_overflow_pos', 1, make_body(rng, 1, layout=dict(cols=257, rows=256))),
           ('e0_overflow_neg', 1, make_body(rng, 1, layout=dict(cols=257, rows=255))),
           ('e0_ord_N31', 1, make_body(rng, 1, ordered=1, layout=dict(cols=31, rows=1)))]
    nm = bytearray(make_body(rng, 1))
    nm[0:0x21] = b'X' * 0x21
    ref.append(('name_no_nul', 1, bytes(nm)))
    ref.append(('short_body', 1, make_body(rng, 1)[:200]))
    for tag, flag, body in ref:
        S(scs, 'known:D2_%s' % tag, [R(flag, make_body(rng, flag))], [('refuse', flag, body, tag)], 'known', quick=tag in ('K31', 'e0_N101'))
    # the original on the same refused bodies where it does not misbehave (D2 is a native-side rejection): it must run
    for tag, flag, body in ref:
        if tag in ('Nneg_d6', 'e0_Nneg', 'e0_overflow_neg', 'set_zero_first', 'e0_overflow_pos'):
            full = body if len(body) == BODY_LEN[flag] else None
            if full:
                S(scs, 'known:D2_original_runs_%s' % tag, [R(flag, full)], [('tick', CLK), ('tick', CLK), ('play', 60, dict(PL, until='never'))], 'known',
                  native=False, stray=(tag != 'e0_overflow_pos'))  # the 256 key overrun runs past the object (D2): not checked
    # D4: event flag index outside the host window (native refuses before the first effect of the finish visit)
    for idx in (-2, 4096, 5000, 32767, -32768):
        body = make_body(rng, 0, N=6, rec=(2, 0, [0, 1]), fail=block(5, (1, 2, 3), (4, 5, 6), 1, idx, 9), xblock=block(9999, (0, 0, 0), (0, 0, 0), 0, idx, 9),
                         rounds=[(2, 0, [2, 3])] * 4)
        S(scs, 'known:D4_event_index_%d' % idx, [R(0, body)],
          [('tick', CLK), ('tick', CLK), ('poke', {0xd2c: struct.pack('<i', 1), 0xdfe: b'\0', 0xd3f: b'\1'}), ('setphase', 0, 2), ('tick', CLK)], 'known',
          bounds_ok=True, quick=idx == 4096)

    # -- random scenarios with a fixed seed
    for k in range(n_random):
        flag = rng.randrange(2)
        if rng.random() < 0.25:
            spec = rng.choice([c for c in cb if c['valid'] and c['flag'] == flag] or [c for c in cb if c['valid']])
            flag = spec['flag']
            body = patch(spec['body'], flag, ordered=rng.randrange(2), delay=rng.choice([0, 1, 2]),
                         snd_b=rng.choice(snd_cases()[:3]), snd_a=rng.choice(snd_cases()[:3]), fail=rng.choice(blocks), xblock=rng.choice(blocks))
            if flag == 0:
                body = patch(body, 0, blink=rng.randrange(2))
            N = struct.unpack_from('<h', body, B_N)[0]
            if body[B_ORD] and N > 30:
                body = patch(body, flag, ordered=0)
        else:
            body = random_body(rng, flag)
        style = dict(until=rng.choice(['done', 'done', 'never']), exit_p=rng.choice([0.0, 0.02, 0.1]), btn_p=rng.choice([0.0, 0.03, 0.1]),
                     p_tick=rng.choice([0.3, 0.5, 0.7]), busy=rng.choice(['zero', 'zero', 'rand', 'one']), fuzz=rng.random() < 0.3,
                     wild_click=rng.choice([0.0, 0.05, 0.3]), correct=rng.choice([0.2, 0.6, 0.9, 1.0]), goal=rng.choice(['code', 'set']))
        acts = [('tick', CLK), ('tick', CLK)]
        for seg in range(rng.randrange(1, 4)):
            acts.append(('play', rng.randrange(80, 420), style))
            if rng.random() < 0.25:
                acts += [('cleanup',), ('tick', CLK), ('revive',)]
            if rng.random() < 0.15:
                acts += [('view', rng.choice(list(VIEWS))), ('render', seg)]
            if rng.random() < 0.1:
                acts += [('scene_reset',)]
            if rng.random() < 0.1:
                acts += [('stale', rng.choice([9999, 5, 0, -1]))]
        S(scs, 'random:%03d' % k, [R(flag, body, rng.choice([1, 1, 2]))], acts, 'random', seed=1000 + k, quick=k < 6)
    return scs


# ---------------------------------------------------------------------------------------------
# runner
# ---------------------------------------------------------------------------------------------
def make_stats():
    s = Counter()
    s['groups'] = {}
    s['known_observed'] = Counter()
    s['effect_kinds'] = Counter()
    s['states_per_scenario'] = Counter()
    s['hang_detail'] = Counter()
    s['fault_detail'] = Counter()
    return s


def merge_stats(dst, src):
    for k, v in src.items():
        if k == 'groups':
            for g, c in v.items():
                dst['groups'].setdefault(g, Counter()).update(c)
        elif isinstance(v, Counter):
            dst[k].update(v)
        else:
            dst[k] = dst.get(k, 0) + v


def worker(args):
    shard, workers, scs_args, lib_path, fail_fast, original_only = args
    scs = scenario_list(*scs_args[0], **scs_args[1])
    if scs_args[2]:
        scs = [s for s in scs if scs_args[2](s)]
    lib = None if original_only else open_lib(lib_path)
    x = X86()
    local = make_stats()
    fails = []
    for idx in range(shard, len(scs), workers):
        sc = scs[idx]
        try:
            run_scenario(x, lib, sc, local)
        except Mismatch as error:
            fails.append((sc['id'], 'mismatch', str(error)))
        except (OracleError, UcError) as error:
            fails.append((sc['id'], 'oracle-error', str(error)))
        if fail_fast and fails:
            break
    for k, v in x.counters.items():
        local['counter:' + k] += v
    return local, fails, [(a, z, h) for a, z, h in x.window_hashes], x.hooks_fired


class Filter:
    def __init__(self, quick, group, only, limit_ids):
        self.quick, self.group, self.only = quick, group, only

    def __call__(self, s):
        return (not self.quick or s['quick']) and (not self.group or s['group'] == self.group) and (not self.only or self.only in s['id'])


def run_all(scs_args, n, lib_path, workers, fail_fast, original_only):
    from concurrent.futures import ProcessPoolExecutor
    stats = make_stats()
    failures = []
    windows = None
    fired = Counter()
    jobs = [(i, workers, scs_args, lib_path, fail_fast, original_only) for i in range(workers)]
    if workers == 1:
        results = [worker(jobs[0])]
    else:
        with ProcessPoolExecutor(max_workers=workers) as pool:
            results = list(pool.map(worker, jobs))
    for local, fails, windows, hf in results:
        merge_stats(stats, local)
        failures.extend(fails)
        fired.update(hf)
    return stats, failures, windows, fired


def summarize(stats, failures, n_scs, original_only):
    states = {str(s): stats.get('scenarios_reaching_%s' % s, 0) for s in list(range(0, 5)) + ['phase2']}
    visits = {str(s): stats.get('counter:phase1_state_%d' % s, 0) for s in range(0, 5)}
    out = dict(mode='original-only' if original_only else 'native-vs-original', scenarios_total=n_scs,
               scenarios_completed=stats.get('scenarios', 0), failures=len(failures),
               ticks=stats['ticks'], handler_steps=stats['steps'], phase_steps={k: stats['phase%s_steps' % k] for k in '012'},
               effects=stats['effects'], host_calls=stats['host_calls'],
               pointer_moves=stats['pointer_moves'], pointer_hits=stats['pointer_hits'], clicks=stats['clicks'],
               clicks_acting=stats['clicks_acting'], renders=stats['render_calls'], blits=stats['blit_calls'],
               cleanups=stats['cleanups'], invalidates=stats['invalidates'], scene_resets=stats['scene_resets'], pokes=stats['pokes'],
               completions=stats['completions'], stray_checks=stats['stray_checks'],
               scenarios_reaching_state=states, handler_visits_per_state=visits,
               effect_kinds=dict(stats['effect_kinds']), hang_detail=dict(stats['hang_detail']), fault_detail=dict(stats['fault_detail']),
               known_observed=dict(stats['known_observed']),
               scenarios_by_distinct_states=dict(sorted(stats['states_per_scenario'].items())),
               groups={g: dict(c) for g, c in sorted(stats['groups'].items())},
               consumed=dict(ticks=stats['ticks_consumed'], busy=stats['busy_consumed']),
               pointer_candidates={k: v for k, v in stats.items() if isinstance(k, str) and k.startswith('pointer_cand_')},
               blit_kinds={k: v for k, v in stats.items() if isinstance(k, str) and k.startswith('blit_kind_')})
    if not original_only:
        out.update(state_compares=stats['state_compares'], object_bytes_compared=stats['object_bytes_compared'],
                   object_bytes_unmodelled=stats['object_bytes_unmodelled'], entry_bytes=stats['entry_bytes'],
                   event_bytes=stats['event_bytes'], body_bytes=stats['body_bytes'], cells=stats['cells'])
    out['failure_sample'] = [dict(id=i, kind=k, message=m[:300]) for i, k, m in failures[:8]]
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--original-only', action='store_true', help='run every scenario on the original alone')
    ap.add_argument('--native-library', type=Path, help='prebuilt driver library (default: build from --kernel-src)')
    ap.add_argument('--kernel-src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--kernel-sources', default='action_family_e0_runtime.c')
    ap.add_argument('--quick', action='store_true')
    ap.add_argument('--group')
    ap.add_argument('--only', help='run scenarios whose id contains this text')
    ap.add_argument('--random', type=int, default=220)
    ap.add_argument('--seed', type=int, default=51)
    ap.add_argument('--workers', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    ap.add_argument('--fail-fast', action='store_true', help='stop at the first mismatch (mutation runs)')
    ap.add_argument('--list', action='store_true')
    a = ap.parse_args()
    flt = Filter(a.quick, a.group, a.only, None)
    scs_args = ((a.seed, a.random), {}, flt)
    scs = [s for s in scenario_list(a.seed, a.random) if flt(s)]
    if a.list:
        print(json.dumps(Counter(s['group'] for s in scs)))
        return 0
    lib_path = None
    native_hash = None
    if not a.original_only:
        if a.native_library:
            lib_path = a.native_library
        else:
            if not (a.kernel_src / a.kernel_sources.split(',')[0]).exists():
                print('kernel source %s is missing; use --original-only' % (a.kernel_src / a.kernel_sources.split(',')[0]), file=sys.stderr)
                return 2
            tmp = Path(os.environ.get('TMPDIR', '/tmp')) / ('e0_oracle_driver_%d.so' % os.getpid())
            lib_path = build_driver(a.kernel_src, tmp, tuple(a.kernel_sources.split(',')))
        native_hash = sha(Path(lib_path).read_bytes())
    t0 = time.monotonic()
    workers = max(1, min(a.workers, len(scs)))
    stats, failures, windows, fired = run_all(scs_args, len(scs), lib_path, workers, a.fail_fast, a.original_only)
    out = summarize(stats, failures, len(scs), a.original_only)
    out['seconds'] = round(time.monotonic() - t0, 1)
    out['exe_sha256'] = EXE_HASH
    out['native_library_sha256'] = native_hash
    out['oracle_script_sha256'] = sha(Path(__file__).read_bytes())
    dp = PROJECT / 'tests/action_family_e0_runtime_oracle_driver.c'
    out['driver_sha256'] = sha(dp.read_bytes()) if dp.exists() else None
    ks = a.kernel_src / a.kernel_sources.split(',')[0]
    out['kernel_source_sha256'] = sha(ks.read_bytes()) if ks.exists() else None
    out['corpus_body_sha256'] = {c['id']: c['body_sha'] for c in corpus_rows()}
    out['code_windows'] = [dict(start=hex(s), end=hex(e), sha256=h) for s, e, h in (windows or [])]
    out['hook_rets_checked'] = {hex(k): v[1] for k, v in HOOK_RETS.items()}
    out['hooks_fired'] = dict(fired)
    print(json.dumps({k: v for k, v in out.items() if k not in ('code_windows', 'hooks_fired', 'corpus_body_sha256')}, indent=1, sort_keys=True))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
