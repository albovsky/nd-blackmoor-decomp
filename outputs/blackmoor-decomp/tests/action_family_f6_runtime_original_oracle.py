#!/usr/bin/env python3
"""RT-47: immutable x86 dispatcher 0x427a50 / handler 0x45f0e6 versus the native raw-0xf6 card puzzle kernel.

The unmodified GAME.EXE image is mapped under Unicorn. Bodies reach the object through the REAL scene loader 0x40b34a
(arm 0x4109f8, constructor 0x45ddd0, dependency construction 0x424aa8): the oracle builds a payload (48 byte header, type
0xf6, subtype, 4,934 byte typed body, 16 byte dependency records) and runs the loader for each row. For raw 0xf6 rows
the REAL dispatcher 0x427a50 runs: gate 0x423f57, the handler 0x45f0e6 with ECX = singleton 0x61f4b1 and, as original
x86 code: the generic Z entry allocator 0x4d39f9 and releaser 0x4d3992 (table 0x5d1591), the helpers 0x45de8a (deal),
0x45e67d (real-sound test), 0x45e6bd (pick and play a line), 0x45e906 (move a card), 0x45e9db (find a card), 0x45ea4a /
0x45eadc (refill checks), 0x45eb76 (computer column pick), 0x45ed60 / 0x45ef5a (start a card slide), 0x45dd4d (cleanup),
0x45dc8a (reset), the constructor 0x45dc1a, the generic completion 0x42ba3a (and 0x423d33 for subtype 2), the view
translation 0x4d3a52. The entry points the engine reaches through other callers are driven directly with ECX = 0x61f4b1:
the pointer receiver 0x45e1ca (`ret 8`, args x then y as words; it calls the real cursor writer 0x45e4d4, `ret 4`), the
click 0x45e587, the invalidate 0x45dd96, the cleanup 0x45dd4d and the render callback 0x460f26 (no arguments, reads the
object through fixed addresses). The native side is src/action_family_f6_runtime.c driven by
tests/action_family_f6_runtime_oracle_driver.c with a scripted host.

Compared for every scenario step: the ordered F6_FX_* effects (every rand, tick, sound and caption call with its
arguments), a second ordered log of the host calls (value / hash of every argument the kernel hands the host), the
packed object image (f6_object_pack, only the bytes its mask declares modelled, original offsets 0x00..0x3ae), the
generic Z entry table (0x58 entries of 0x4a bytes, byte for byte), the row phase dword and the completion byte of every
row, the process flag 0x5bb1ca, the seven scene-change cells (0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b,
0x5bb59f, 0x5bb5a3), the engine mode 0x583999, the event flag window (4096 dwords at 0x585801), the surface names asked
of the image loader, the caption texts, the scripted queue consumption (ticks, busy answers, rand values) and, for the
pointer receiver, the return value, [0x5b44f0], [0x5c39e5], the sprite cell 0x5d1631, 0x5d1639, 0x5b44f4, 0x5d162d and,
for the render callback, the recorded blits (0x4c5377 / 0x4c5d4b) against f6_render_plan (kind, source and destination).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard.
  R 0x51dc43 malloc          bump arena, zero filled (OS/CRT boundary; loader 0x45ddd0 and dependency loader 0x424aa8)
  R 0x4c2790 load_image(kind, name, 6, label)   thiscall ECX 0x5cf659, ret 0x10: returns the scripted handle
  R 0x4c2dfb release_image(&handle)             thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param
  R 0x4e8d96 clear pending item                 thiscall ECX 0x571442, ret 0
  R 0x4fb77a prepare sound(record ptr)          thiscall ECX 0x5c3a67, ret 4 (pointer must be obj+0x326)
  R 0x4fb2e3 play sound(channel word)           thiscall ECX 0x5c3a67, ret 4
  R 0x4f6334 sound busy(channel)                thiscall ECX 0x5cf1eb, ret 4: returns the scripted answer
  R 0x50cd50 _rand                              cdecl, ret 0: returns the next scripted value (0..32767)
  R 0x423259 autotext(key)                      thiscall ECX 0x619a6b, ret 4: key -> scripted text arena pointer or 0
  R 0x448d11 caption(object, text, -1, 0)       thiscall ECX 0x619a05, ret 0x10: records the text (with its "<e>" suffix)
  R 0x4c5377 opaque blit / R 0x4c5d4b keyed blit  thiscall ECX 0x5cf659, ret 0x14: recorders for the render callback
  R GetTickCount (IAT slot 0x52a23c, stub)      returns the next scripted tick value
  O 0x45f0e6 handler entry (row, phase, ECX check)      O 0x42ba3a generic completion   O 0x4d3992 release entry (slot)
  O 0x45f340 / 0x45f385  instruction boundaries inside 0x45f0e6 (after the Z entry label copy, after the slot surface
     store) and 0x45ddb8 inside 0x45dd96 (the redraw store): they only read memory
  UC_HOOK_MEM_WRITE observers over object +0x1c, the row phase dwords, 0x5bb1ca, the seven scene-change cells,
     0x583999 and the event flag window (read-only, they log the effects of the stores)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
     scenario expects the allocator's fatal path 0x52139c); 0x425b8b and 0x425b40 raise through the base.
 Windows imports (OS boundary, IAT slots patched to stubs): GetTickCount (scripted), InterlockedIncrement/Decrement,
 lstrlenA, Enter/Leave/InitializeCriticalSection; any other import fails the run. FS has a TIB page (GDT) for the SEH
 frames. Debug flag 0x63a4cd is 0. The singleton is constructed by the original constructor 0x45dc1a.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, the view origin
globals, the tick values, busy answers and rand values, the autotext table (sound name -> text or absent), slot-busy
seeds, the event flag table contents, [0x5d0377] (cursor cell), [0x5cf665] / [0x5d15e3] (blit surfaces).

EXPECTED DIFFERENCES (native safety layer; tagged, counted in stats.known_observed, never as passes):
  H1 the original hangs (a `_rand` pick loop of 0x45de8a / 0x45e6bd / 0x45eb76 never finds a valid pick): the scripted
     rand queue runs dry or the instruction cap trips; native must end with F6_ERR_STUCK or a rand underflow.
  H2 division by zero (columns or rows 0, frames 0): original #DE; native f6_validate_body refuses the body.
  H3 event flag index outside the host window (0..4095): the original stores through an arbitrary pointer.
  H4 a caption longer than 200 characters overflows the 204 byte stack buffer of 0x45e6bd (not generated).
  H5 phase 1 / 2 on an object never initialised for the row (not generated).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_f6_runtime_original_oracle.py --original-only                      (PART A: original alone)
  python3 action_family_f6_runtime_original_oracle.py --result ../../../work/analysis/slices/RT-47.oracle-result.json
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
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x61f4b1
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
G_ORIGIN_X, G_ORIGIN_Y = 0x583186, 0x58318a
G_BACK, G_BG = 0x5cf665, 0x5d15e3          # blit destination surface, restore source surface
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
G_CAND, G_CURSOR, G_CURSOR2 = 0x5c39e5, 0x5b44f0, 0x5b44f4
G_CURSOR_CELL = 0x5d0377
EVENTS_VA = 0x585801
EVENT_COUNT = 4096
CELLS = ((0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2), (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4))
PAYLOAD_BASE = 0x22000000
PAYLOAD_STRIDE = 0x2000
TEXT_BASE = 0x23000000
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
SOUND_THIS, BUSY_THIS, ITEM_THIS = 0x5c3a67, 0x5cf1eb, 0x571442
AUTOTEXT_THIS, CAPTION_THIS = 0x619a6b, 0x619a05
FPCW = 0x27f
BODY_LEN = 4934
IMG_BYTES = 0x3af
LABEL_KIND = b'CIFTREE'
NO_SOUND = b'NO SOUND'
MAX_ROWS = 8
INSN_CAP = 6_000_000

# F6_FX_* of the header (src/action_family_f6_runtime.h)
FX = dict(START_FLAG=1, CLEAR_ITEM=2, SLOT=3, SLOT_REGISTER=4, SURFACE_LOAD=5, SLOT_SURFACE=6, SOUND_PREPARE=7,
          SOUND_BUSY=8, SOUND_PLAY=9, TICK=10, RAND=11, AUTOTEXT=12, CAPTION=13, PHASE=14, XFER_5BB57B=15,
          XFER_5BB599=16, XFER_5BB595=17, XFER_5C39FF=18, XFER_5BB59B=19, XFER_5BB59F=20, XFER_5BB5A3=21,
          ENGINE_MODE=22, EVENT_FLAG=23, COMPLETE=24, RELEASE_SURFACE=25, RELEASE_SLOT=26, MARK_DIRTY=27)
ENTER = 0           # oracle-only marker: handler entry (row, phase)
FXN = {v: k for k, v in FX.items()}
FXN[ENTER] = 'ENTER'
CELL_FX = [FX['XFER_5BB57B'], FX['XFER_5BB599'], FX['XFER_5BB595'], FX['XFER_5C39FF'], FX['XFER_5BB59B'],
           FX['XFER_5BB59F'], FX['XFER_5BB5A3']]
# host-call trace vocabulary (kernel -> host calls, hashes over the argument bytes)
H = dict(TICK=1, RAND=2, BUSY=3, PLAY=4, PREPARE=5, AUTOTEXT=6, CAPTION=7, LOAD=8, RELEASE_SURFACE=9, CLEAR=10)
HN = {v: k for k, v in H.items()}

HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4e8d96: (0x80, 0), 0x4fb77a: (0x300, 4),
             0x4fb2e3: (0x200, 4), 0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14), 0x50cd50: (0x40, 0),
             0x423259: (0x200, 4), 0x448d11: (0x44972f + 3 - 0x448d11, 0x10), 0x4c5d4b: (0x4c6098 + 3 - 0x4c5d4b, 0x14),
             0x45e1ca: (0x340, 8), 0x45e4d4: (0xb4, 4), 0x45e587: (0x100, 0), 0x460f26: (0x7f0, 0)}

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
CODE_WINDOWS = ((0x45dc1a, 0x45f0e6), (0x45f0e6, 0x460ee4), (0x460f26, 0x461708), (0x40b34a, 0x410ca4),
                (0x4234c8, 0x4234dd), (0x4237f7, 0x423876), (0x423d33, 0x423da2), (0x423f57, 0x423fbb),
                (0x42406d, 0x424aa8), (0x424aa8, 0x425b8b), (0x427a50, 0x42acad), (0x42ba3a, 0x42babf),
                (0x4d3992, 0x4d39f9), (0x4d39f9, 0x4d3a52), (0x4d3a52, 0x4d3a89), (0x51dc43, 0x51dc6c),
                (0x52139c, 0x5213d4))


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


# ---------------------------------------------------------------------------------------------
# body layout (offsets of the typed body, see the header comment of src/action_family_f6_runtime.h)
# ---------------------------------------------------------------------------------------------
B_NAME, B_A, B_B, B_C, B_MODE, B_COLS, B_ROWS, B_DEAL = 0x00, 0x21, 0x22, 0x23, 0x24, 0x25, 0x27, 0x29
B_TURN_SRC, B_TURN_DST, B_FACE, B_DOWN, B_SCORE_SRC, B_SCORE_DST = 0x2b, 0x4b, 0x6b, 0x3ab, 0x47b, 0x48b
B_SL_STEPS, B_SL_STEP, B_SL_INT, B_DISPLAY, B_BUTTON, B_CARD = 0x62b, 0x62d, 0x62f, 0x633, 0x653, 0x723
B_DV_FRAMES, B_DV_PASSES, B_DV_INT, B_DV_RECTS, B_DV_RECT = 0x993, 0x995, 0x997, 0x99b, 0xa8b
B_NC_FRAMES, B_NC_PASSES, B_NC_INT, B_NC_RECTS, B_NC_RECT = 0xa9b, 0xa9d, 0xa9f, 0xaa3, 0xb93
B_L_BUTTON, B_L_2, B_L_3, B_L_4, B_L_PICK = 0xba3, 0xbc4, 0xbe5, 0xc06, 0xc2b    # single names and the 13 name list
B_L_HUMAN, B_L_NOCARD, B_L_GOT, B_L_MIS, B_L_LOSE = 0xdd8, 0xe7d, 0xee0, 0xf22, 0x125f
B_SND_W1, B_SND_W2, B_L_NAMES, B_L_DRAW = 0xf64, 0xf66, 0xf68, 0x12a1
B_WIN, B_DRAW, B_WIN_CELLS, B_FLAG_WIN, B_FLAG_DRAW, B_EXIT, B_EXIT_RECT = 0x1304, 0x1306, 0x1308, 0x131c, 0x131e, 0x1320, 0x1336
OTHER = 0x33d


def scene_cells(scene=9999, words=(0, 0, 0), dwords=(0, 0, 0), start=0):
    return struct.pack('<h3h3ih', scene, *words, *dwords, start)


def rect(l, t, r, b):
    return struct.pack('<4i', l, t, r, b)


def put_name(b, off, text):
    t = text[:0x20] + b'\0'
    b[off:off + len(t)] = t
    for i in range(len(t), 0x21):
        b[off + i] = 0


def make_body(rng, cols=3, rows=3, deal=2, mode=1, A=1, B=1, C=0, names=None, slide=(4, 6, 20), deliver=(3, 1, 30),
              nocard=(3, 1, 30), win=None, draw=None, exitb=None, flags=(-1, -1), buttons=True, display=True,
              turn=True, scores=True, exit_rect=(500, 10, 560, 40), overlay=b'CARD GAME SHEET', garbage=False,
              wins=None):
    """A synthetic typed body. `names` maps a list key to a list of names (bytes); see NAMES below."""
    b = bytearray(rng.randbytes(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    put_name(b, B_NAME, overlay)
    b[B_A], b[B_B], b[B_C], b[B_MODE] = A, B, C, mode
    struct.pack_into('<hhh', b, B_COLS, cols, rows, deal)
    for p in range(2):
        b[B_TURN_SRC + 16 * p:B_TURN_SRC + 16 * p + 16] = rect(600 + 20 * p, 5, 620 + 20 * p, 25) if turn else rect(0, 0, 0, 0)
        b[B_TURN_DST + 16 * p:B_TURN_DST + 16 * p + 16] = rect(10, 5 + 30 * p, 30, 25 + 30 * p) if turn else rect(0, 0, 0, 0)
    for r in range(4):
        for c in range(13):
            o = B_FACE + 0xd0 * r + 16 * c
            b[o:o + 16] = rect(c * 40, 400 + r * 60, c * 40 + 35, 400 + r * 60 + 55)
    for c in range(13):
        b[B_DOWN + 16 * c:B_DOWN + 16 * c + 16] = rect(c * 30, 700, c * 30 + 25, 740)
        o = B_BUTTON + 16 * c
        b[o:o + 16] = rect(20 + 40 * c, 300, 20 + 40 * c + 35, 340) if buttons else rect(0, 0, 0, 0)
    b[B_SCORE_SRC:B_SCORE_SRC + 16] = rect(1, 2, 3, 4) if scores else rect(0, 0, 0, 0)
    for p in range(2):
        for c in range(13):
            o = B_SCORE_DST + 0xd0 * p + 16 * c
            b[o:o + 16] = rect(30 * c, 200 + 20 * p, 30 * c + 20, 215 + 20 * p)
    struct.pack_into('<hhi', b, B_SL_STEPS, *slide)
    for i in range(2):
        o = B_DISPLAY + 16 * i
        b[o:o + 16] = rect(100 + 50 * i, 100, 140 + 50 * i, 150) if display else rect(0, 0, 0, 0)
    for r in range(3):
        for c in range(13):
            o = B_CARD + 0xd0 * r + 16 * c
            b[o:o + 16] = rect(20 + 40 * c, 40 + 60 * r, 20 + 40 * c + 35, 40 + 60 * r + 55)
    struct.pack_into('<hhi', b, B_DV_FRAMES, *deliver)
    struct.pack_into('<hhi', b, B_NC_FRAMES, *nocard)
    for i in range(15):
        b[B_DV_RECTS + 16 * i:B_DV_RECTS + 16 * i + 16] = rect(5 * i, 600, 5 * i + 20, 620)
        b[B_NC_RECTS + 16 * i:B_NC_RECTS + 16 * i + 16] = rect(5 * i, 640, 5 * i + 20, 660)
    b[B_DV_RECT:B_DV_RECT + 16] = rect(300, 400, 340, 440)
    b[B_NC_RECT:B_NC_RECT + 16] = rect(300, 450, 340, 490)
    nm = dict(NAMES_DEFAULT)
    nm.update(names or {})

    def lst(base, key, count, other=0):
        for i in range(count):
            put_name(b, base + other + 0x21 * i, nm[key][i % len(nm[key])] if nm[key] else b'')
    put_name(b, B_L_BUTTON, nm['button'][0])
    put_name(b, B_L_2, nm['b2'][0])
    put_name(b, B_L_3, nm['b3'][0])
    put_name(b, B_L_4, nm['b4'][0])
    lst(B_L_PICK, 'pick', 13)
    for key, base, cnt in (('human', B_L_HUMAN, 5), ('nocard', B_L_NOCARD, 3), ('got', B_L_GOT, 2), ('mis', B_L_MIS, 2)):
        lst(base, key, cnt)
        lst(base, key + '2', cnt, OTHER)
    lst(B_L_NAMES, 'names', 13)
    lst(B_L_LOSE, 'lose', 2)
    lst(B_L_DRAW, 'draw', 3)
    struct.pack_into('<hh', b, B_SND_W1, 8, 2)
    b[B_WIN:B_WIN + 2] = struct.pack('<h', win[0] if win else 9999)
    b[B_DRAW:B_DRAW + 2] = struct.pack('<h', draw[0] if draw else 9999)
    cells_src = win or draw
    if cells_src:     # the win and the draw block share the cells at +0x1308 (0x460d90..0x460e21)
        b[B_WIN_CELLS:B_WIN_CELLS + 20] = struct.pack('<3h3ih', *cells_src[1], *cells_src[2], cells_src[3])
    struct.pack_into('<hh', b, B_FLAG_WIN, flags[0], flags[1])
    b[B_EXIT:B_EXIT + 22] = scene_cells(*(exitb or (9999, (0, 0, 0), (0, 0, 0), 0)))
    b[B_EXIT_RECT:B_EXIT_RECT + 16] = rect(*exit_rect)
    return bytes(b)


NAMES_DEFAULT = dict(button=[b'SND_BUTTON'], b2=[b'SND_B2'], b3=[b'SND_B3'], b4=[b'SND_B4'],
                     pick=[b'PICK_%d' % i for i in range(13)],
                     human=[b'HU_%d' % i for i in range(5)], human2=[b'CU_%d' % i for i in range(5)],
                     nocard=[b'NC_%d' % i for i in range(3)], nocard2=[b'NX_%d' % i for i in range(3)],
                     got=[b'GOT_%d' % i for i in range(2)], got2=[b'GOX_%d' % i for i in range(2)],
                     mis=[b'MIS_%d' % i for i in range(2)], mis2=[b'MIX_%d' % i for i in range(2)],
                     names=[b'NAME_%d' % i for i in range(13)], lose=[b'LOSE_0', b'LOSE_1'],
                     draw=[b'DRAW_0', b'DRAW_1', b'DRAW_2'])


def parse(body):
    g = lambda o, f: struct.unpack_from(f, body, o)[0]
    cols, rows = g(B_COLS, '<h'), g(B_ROWS, '<h')
    ncol = max(0, min(cols, 13))
    return dict(cols=cols, rows=rows, deal=g(B_DEAL, '<h'), mode=body[B_MODE], A=body[B_A], B=body[B_B], C=body[B_C],
                button=[struct.unpack_from('<4i', body, B_BUTTON + 16 * c) for c in range(ncol)],
                card=[[struct.unpack_from('<4i', body, B_CARD + 0xd0 * r + 16 * c) for c in range(ncol)] for r in range(3)],
                exit_rect=struct.unpack_from('<4i', body, B_EXIT_RECT),
                has_buttons=struct.unpack_from('<4i', body, B_BUTTON)[1] != struct.unpack_from('<4i', body, B_BUTTON)[3],
                names=sorted({cstr(body[o:o + 0x21]) for o in name_offsets(body)} - {b''}))


def name_offsets(body):
    offs = [B_L_BUTTON, B_L_2, B_L_3, B_L_4, B_L_LOSE, B_L_DRAW] + [B_L_PICK + 0x21 * i for i in range(13)] + \
           [B_L_NAMES + 0x21 * i for i in range(13)]
    for base, cnt in ((B_L_HUMAN, 5), (B_L_NOCARD, 3), (B_L_GOT, 2), (B_L_MIS, 2)):
        for other in (0, OTHER):
            offs += [base + other + 0x21 * i for i in range(cnt)]
    return offs


def center(r):
    return clamp16((r[0] + r[2]) // 2), clamp16((r[1] + r[3]) // 2)


def clamp16(v):
    return max(-32768, min(32767, v))


_CORPUS = None


def corpus_bodies():
    """The 6 raw 0xf6 bodies of the owner's local resources (never printed; only counts and hashes leave here)."""
    global _CORPUS
    if _CORPUS is None:
        out = []
        for p in sorted((ROOT / 'work/f6').glob('body_*.bin')):
            data = p.read_bytes()
            if len(data) != BODY_LEN:
                raise OracleError('corpus body size')
            out.append(dict(body=data, res=p.stem, subtype=1))
        if len(out) != 6:
            raise OracleError('expected 6 corpus bodies, found %d' % len(out))
        _CORPUS = out
    return _CORPUS


def make_payload(body, subtype=1, tail=b'', desc=b'F6 ORACLE ROW'):
    return desc[:47] + b'\0' * (48 - len(desc[:47])) + bytes([0xf6, subtype]) + body + tail


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


POPS = {0x4c2790: 0x10, 0x4c2dfb: 4, 0x4e8d96: 0, 0x4fb77a: 4, 0x4fb2e3: 4, 0x4f6334: 4, 0x4c5377: 0x14, 0x4c5d4b: 0x14,
        0x50cd50: 0, 0x423259: 4, 0x448d11: 0x10}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
AT_REGISTER, AT_SLOT_SURFACE, AT_DIRTY = 0x45f340, 0x45f385, 0x45ddb8
HANDLER = 0x45f0e6
LOADER = 0x40b34a


class X86(deps.OriginalMachine):
    def __init__(self):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.pristine = bytes(self.pe.image)
        if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
            raise OracleError('executable identity mismatch')
        self.window_hashes = [(a, z, sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]))
                              for a, z in CODE_WINDOWS]
        self._check_hook_rets()
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(PAYLOAD_BASE, PAYLOAD_STRIDE * (MAX_ROWS + 1))
        uc.mem_map(TEXT_BASE, 0x200000)
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
        self.fx = []                 # ordered F6_FX_* effects (kind, a, b)
        self.calls = []              # ordered host-call trace (kind, a, b)
        self.entered = []
        self.allocs = {}
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.blits = []
        self.loaded = []             # image names asked of 0x4c2790
        self.captions = []           # caption texts
        self.handles, self.handle_i = [], 0
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.rand_q, self.rand_i = [], 0
        self.texts = {}              # sound name (bytes) -> text (bytes) or None
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
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
        table[HANDLER] = self._entry
        table[0x42ba3a] = self._complete
        table[0x4d3992] = self._release_entry
        table[AT_REGISTER] = self._at_register
        table[AT_SLOT_SURFACE] = self._at_slot_surface
        table[AT_DIRTY] = self._at_dirty
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        w = self._guard_write
        uc.hook_add(UC_HOOK_MEM_WRITE, w, begin=OBJ + 0x1c, end=OBJ + 0x1d)
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
        return self.rd(OBJ, IMG_BYTES)

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
        if address == OBJ + 0x1c and size == 2:
            if self.cur_phase == 0:
                self.log(FX['SLOT'], s16(value))
        elif address == START_FLAG and size == 4:
            self.log(FX['START_FLAG'], s32(value))
        elif address == G_MODE and size == 4:
            self.log(FX['ENGINE_MODE'], s32(value))
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
            raise OracleError('handler entered with ECX != 0x61f4b1')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        self.cur_phase = phase
        if phase == 1:
            self.counters['phase1_state_%d' % self.rs32(OBJ + 0x39e)] += 1
            self.states_seen.add(self.rs32(OBJ + 0x39e))
        elif phase == 2:
            self.states_seen.add('phase2')
        self.fx.append((ENTER, row, phase))
        self.calls.append((ENTER, row, phase))

    states_seen = set()

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(FX['COMPLETE'], struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _at_register(self, uc, address, size, user):
        self.log(FX['SLOT_REGISTER'], self.rs16(OBJ + 0x1c))

    def _at_slot_surface(self, uc, address, size, user):
        slot = self.rs16(OBJ + 0x1c)
        self.log(FX['SLOT_SURFACE'], slot, self.entry_surface(slot))

    def _at_dirty(self, uc, address, size, user):
        self.log(FX['MARK_DIRTY'], self.rs16(OBJ + 0x1c))

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(FX['RELEASE_SLOT'], struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        eax = 0
        need = lambda want, what: (_ for _ in ()).throw(OracleError(what + ' ECX')) if ecx != want else None
        if address == 0x4c2790:
            need(SURF_HOST, 'image loader')
            kind, name, six, label = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            if kind != LABEL_KIND or six != 6 or label != b'CARD GAME Puzzle Surface':
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.loaded.append(name.decode('latin1'))
            self.log(FX['SURFACE_LOAD'], eax)
            self.call_log(H['LOAD'], crc(name), eax)
        elif address == 0x4c2dfb:
            need(SURF_HOST, 'image release')
            old = u32(uc, a[0])
            self.log(FX['RELEASE_SURFACE'], old)
            self.call_log(H['RELEASE_SURFACE'], old)
            self.wr(a[0], bytes(4))
        elif address == 0x4e8d96:
            need(ITEM_THIS, 'clear item')
            self.log(FX['CLEAR_ITEM'])
            self.call_log(H['CLEAR'])
        elif address == 0x4fb77a:
            need(SOUND_THIS, 'sound prepare')
            if a[0] != OBJ + 0x326:
                raise OracleError('sound record pointer %#x is not obj+0x326' % a[0])
            self.log(FX['SOUND_PREPARE'])
            self.call_log(H['PREPARE'], crc(self.rd(a[0], 0x31)))
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
        elif address == 0x50cd50:
            if self.rand_i >= len(self.rand_q):
                raise Hang('scripted rand queue exhausted (the original is looping on _rand) at caller %#x' % u32(uc, sp))
            eax = self.rand_q[self.rand_i]
            self.rand_i += 1
            self.log(FX['RAND'], eax)
            self.call_log(H['RAND'], eax)
        elif address == 0x423259:
            need(AUTOTEXT_THIS, 'autotext')
            key = cstr(self.rd(a[0], 0x40))
            text = self.texts.get(key)
            if text is None:
                eax = 0
            else:
                eax = TEXT_BASE
                self.wr(eax, text + b'\0')
            self.log(FX['AUTOTEXT'], 1 if eax else 0)
            self.call_log(H['AUTOTEXT'], crc(key), 1 if eax else 0)
        elif address == 0x448d11:
            need(CAPTION_THIS, 'caption')
            if s32(a[2]) != -1 or a[3] != 0:
                raise OracleError('caption call arguments differ from the packet')
            text = self.read_cstr(a[1])
            self.captions.append(text)
            self.log(FX['CAPTION'], len(text) - 3 if text.endswith(b'<e>') else len(text))   # header: length before the suffix
            self.call_log(H['CAPTION'], len(text), crc(text))
        elif address in (0x4c5377, 0x4c5d4b):
            need(SURF_HOST, 'blit')
            rc = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.blits.append(dict(fn=address, src_surface=a[0], dst_surface=a[1], src=rc(a[2]), dst=rc(a[3]),
                                   src_ptr=a[2], dst_ptr=a[3], label=cstr(self.rd(a[4], 40))))
        else:
            raise OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    def read_cstr(self, addr, limit=0x10000):
        out = bytearray()
        while len(out) < limit:
            ch = self.rd(addr + len(out), 1)[0]
            if ch == 0:
                break
            out.append(ch)
        return bytes(out)

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
        self.blits, self.loaded, self.captions, self.fx, self.calls, self.entered = [], [], [], [], [], []
        self.handle_i = 0
        self.tick_q, self.tick_i, self.busy_q, self.busy_i, self.rand_q, self.rand_i = [], 0, [], 0, [], 0
        self.texts = {}
        self.rec = False
        self.cur_phase = None
        self.expect_fatal = None
        self.states_seen = set()
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.call(0x45dc1a, [], OBJ)  # the original constructor (vtable word, base init, reset 0x45dc8a)

    def install_rows(self, rows, first=0):
        """`rows`: list of dict(body, tail, subtype). Rows below `first` are completed dummies. Every row is built by
        the real scene loader 0x40b34a (typed body copy 0x45ddd0, dependency construction 0x424aa8)."""
        total = first + len(rows)
        if total > MAX_ROWS:
            raise OracleError('too many rows')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            payload = make_payload(spec['body'], spec.get('subtype', 1), spec.get('tail') or b'', b'F6 ORACLE ROW %d' % i)
            at = PAYLOAD_BASE + i * PAYLOAD_STRIDE
            if len(payload) > PAYLOAD_STRIDE:
                raise OracleError('payload too large')
            self.wr(at, payload)
            self.wr(G_ROWCOUNT, struct.pack('<h', i))
            self.call(LOADER, [at, len(payload)], 0)
            base = ROWS + i * ROW
            if self.rd(base + 0x30, 2) != bytes([0xf6, spec.get('subtype', 1)]):
                raise OracleError('loader did not store the row type')
            ptr = struct.unpack('<I', self.rd(base + 0x32, 4))[0]
            if self.rd(ptr, BODY_LEN) != spec['body']:
                raise OracleError('loader body copy differs')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def set_queues(self, ticks, busy, rand, texts):
        self.tick_q, self.tick_i = list(ticks), 0
        self.busy_q, self.busy_i = list(busy), 0
        self.rand_q, self.rand_i = list(rand), 0
        self.texts = dict(texts)

    def _reset_logs(self):
        self.fx, self.calls, self.entered, self.captions, self.blits, self.loaded = [], [], [], [], [], []

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
            if error.errno == UC_ERR_EXCEPTION:   # UC_ERR_EXCEPTION: #DE and friends
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
def build_driver(src_dir, out, kernel_sources=('action_family_f6_runtime.c',)):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_f6_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / k) for k in kernel_sources], '-o', str(out)]
    if os.environ.get('F6_SANITIZE'):
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


MAX_PLAN_BLITS = 160


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u32p, u8p, ip = C.c_void_p, C.c_int32, C.POINTER(C.c_uint32), C.POINTER(C.c_uint8), C.POINTER(C.c_int32)
    lib.f6o_new.restype = p
    lib.f6o_free.argtypes = [p]
    lib.f6o_set_view.argtypes = [p, i32, i32]
    lib.f6o_set_world_flag.argtypes = [p, i32]
    lib.f6o_get_world_flag.argtypes = [p]
    lib.f6o_get_world_flag.restype = i32
    lib.f6o_set_handles.argtypes = [p, u32p, C.c_int]
    lib.f6o_set_queues.argtypes = [p, u32p, C.c_int, ip, C.c_int, ip, C.c_int]
    lib.f6o_clear_texts.argtypes = [p]
    lib.f6o_add_text.argtypes = [p, C.c_char_p, C.c_char_p]
    lib.f6o_consumed.argtypes = [p, ip]
    lib.f6o_set_busy_slot.argtypes = [p, C.c_int, C.c_int]
    lib.f6o_set_entry_u32.argtypes = [p, C.c_int, C.c_int, C.c_uint32]
    lib.f6o_set_cells.argtypes = [p, ip]
    lib.f6o_get_cells.argtypes = [p, ip]
    lib.f6o_set_events.argtypes = [p, ip]
    lib.f6o_get_events.argtypes = [p, ip]
    lib.f6o_clear_log.argtypes = [p]
    lib.f6o_step.argtypes = [p, u8p, C.c_int, C.c_uint32, u32p]
    lib.f6o_step.restype = C.c_int
    lib.f6o_why.argtypes = [p]
    lib.f6o_why.restype = C.c_char_p
    lib.f6o_pointer.argtypes = [p, u8p, C.c_int, C.c_int, ip]
    lib.f6o_pointer.restype = C.c_int
    lib.f6o_click.argtypes = [p, u8p, C.c_uint32, i32, i32, u32p]
    lib.f6o_click.restype = C.c_int
    lib.f6o_invalidate.argtypes = [p]
    lib.f6o_cleanup.argtypes = [p]
    lib.f6o_log_count.argtypes = [p]
    lib.f6o_log.argtypes = [p, C.c_int, ip]
    lib.f6o_call_count.argtypes = [p]
    lib.f6o_call.argtypes = [p, C.c_int, ip]
    lib.f6o_name_count.argtypes = [p]
    lib.f6o_name.argtypes = [p, C.c_int]
    lib.f6o_name.restype = C.c_char_p
    lib.f6o_caption_count.argtypes = [p]
    lib.f6o_caption.argtypes = [p, C.c_int]
    lib.f6o_caption.restype = C.c_char_p
    lib.f6o_image.argtypes = [p, u8p, u8p]
    lib.f6o_set_image.argtypes = [p, u8p]
    lib.f6o_entries.argtypes = [p, u8p]
    lib.f6o_plan.argtypes = [p, u8p, ip]
    lib.f6o_plan.restype = C.c_int
    lib.f6o_validate.argtypes = [u8p, C.c_size_t]
    lib.f6o_validate.restype = C.c_int
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.f6o_new()

    def close(self):
        self.lib.f6o_free(self.h)

    def set_view(self, x, y):
        self.lib.f6o_set_view(self.h, x, y)

    def set_handles(self, hs):
        arr = (C.c_uint32 * max(1, len(hs)))(*hs)
        self.lib.f6o_set_handles(self.h, arr, len(hs))

    def set_queues(self, ticks, busy, rand):
        t = (C.c_uint32 * max(1, len(ticks)))(*[v & 0xffffffff for v in ticks])
        b = (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy])
        r = (C.c_int32 * max(1, len(rand)))(*[s32(v) for v in rand])
        self.lib.f6o_set_queues(self.h, t, len(ticks), b, len(busy), r, len(rand))

    def set_texts(self, texts):
        self.lib.f6o_clear_texts(self.h)
        for k, v in texts.items():
            self.lib.f6o_add_text(self.h, k, v)

    def consumed(self):
        t = (C.c_int32 * 8)()
        self.lib.f6o_consumed(self.h, t)
        return list(t)

    def _triples(self, count, get):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(count):
            get(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        return out

    def fx(self):
        return self._triples(self.lib.f6o_log_count(self.h), self.lib.f6o_log)

    def calls(self):
        return self._triples(self.lib.f6o_call_count(self.h), self.lib.f6o_call)

    def names(self):
        return [self.lib.f6o_name(self.h, i).decode('latin1') for i in range(self.lib.f6o_name_count(self.h))]

    def captions(self):
        return [self.lib.f6o_caption(self.h, i) for i in range(self.lib.f6o_caption_count(self.h))]

    def _collect(self):
        return self.fx(), self.calls(), self.names(), self.captions()

    def step(self, body, row, phase):
        L = self.lib
        L.f6o_clear_log(self.h)
        res = (C.c_uint32 * 3)()
        status = L.f6o_step(self.h, cbuf(body), row, phase, res)
        return (status, (L.f6o_why(self.h) or b'').decode(), *self._collect(), list(res))

    def pointer(self, body, x, y):
        self.lib.f6o_clear_log(self.h)
        out = (C.c_int32 * 4)()
        status = self.lib.f6o_pointer(self.h, cbuf(body), x, y, out)
        return status, list(out)

    def click(self, body, row_phase, candidate, start_flag):
        self.lib.f6o_clear_log(self.h)
        newp = C.c_uint32(0)
        status = self.lib.f6o_click(self.h, cbuf(body), row_phase, candidate, start_flag, C.byref(newp))
        return (status, newp.value, *self._collect())

    def simple(self, fn):
        self.lib.f6o_clear_log(self.h)
        status = fn()
        return (status, *self._collect())

    def image(self):
        img, mask = (C.c_uint8 * IMG_BYTES)(), (C.c_uint8 * IMG_BYTES)()
        self.lib.f6o_image(self.h, img, mask)
        return bytes(img), bytes(mask)

    def set_image(self, raw):
        self.lib.f6o_set_image(self.h, cbuf(raw))

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.f6o_entries(self.h, t)
        return bytes(t)

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.f6o_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        self.lib.f6o_set_cells(self.h, (C.c_int32 * 8)(*v))

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.f6o_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        self.lib.f6o_set_events(self.h, (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw))

    def world_flag(self):
        return self.lib.f6o_get_world_flag(self.h)

    def plan(self, body):
        t = (C.c_int32 * (3 + 9 * MAX_PLAN_BLITS))()
        status = self.lib.f6o_plan(self.h, cbuf(body), t)
        v = list(t)
        blits = [(v[3 + 9 * i], tuple(v[4 + 9 * i:8 + 9 * i]), tuple(v[8 + 9 * i:12 + 9 * i])) for i in range(min(v[2], MAX_PLAN_BLITS))]
        return status, dict(valid=v[0], surface=v[1] & 0xffffffff, count=v[2], blits=blits)


# ---------------------------------------------------------------------------------------------
# comparison
# ---------------------------------------------------------------------------------------------
def fx_text(t):
    k, a, b = t
    return '%s(%d,%d)' % (FXN.get(k, k), a, b)


def compare_seq(where, what, orig, nat, names=FXN):
    orig, nat = [(k, s32(a), s32(b)) for k, a, b in orig], [(k, s32(a), s32(b)) for k, a, b in nat]
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        f = lambda t: '%s(%d,%d)' % (names.get(t[0], t[0]), t[1], t[2])
        raise Mismatch('%s %s %d: original %s vs native %s' % (
            where, what, k, f(orig[k]) if k < len(orig) else None, f(nat[k]) if k < len(nat) else None))


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


FIELDS = [(0x1c, 2, 'slot'), (0x1e, 2, 'row'), (0x20, 4, 'surface'), (0x24, 0xd0, 'card'), (0xf4, 0x1a, 'count0'),
          (0x10e, 0x34, 'mark0'), (0x142, 2, 'score0'), (0x144, 0xd0, 'card1'), (0x214, 0x1a, 'count1'),
          (0x22e, 0x34, 'mark1'), (0x262, 2, 'score1'), (0x264, 0x34, 'deck'), (0x298, 1, 'redraw'),
          (0x299, 1, 'button_down'), (0x29a, 2, 'selected'), (0x29c, 1, 'deliver'), (0x29d, 1, 'no_card'),
          (0x29e, 1, 'clear'), (0x29f, 2, 'anim_frame'), (0x2a1, 1, 'has_scores'), (0x2a2, 1, 'has_display'),
          (0x2a3, 1, 'has_turn'), (0x2a4, 2, 'player'), (0x2a6, 2, 'deck_left'), (0x2a8, 1, 'outcome_2a8'),
          (0x2a9, 1, 'outcome_2a9'), (0x2aa, 1, 'finished'), (0x2ab, 1, 'flip_2ab'), (0x2ac, 1, 'flip_2ac'),
          (0x2ad, 0x20, 'display'), (0x2cd, 2, 'display_count'), (0x2cf, 2, 'delivery_step'), (0x2d1, 2, 'blink'),
          (0x2d3, 1, 'slide_forward'), (0x2d4, 1, 'slide_2d4'), (0x2d5, 2, 'slide_step'), (0x2d7, 2, 'slide_index'),
          (0x2d9, 4, 'after_slide'), (0x2dd, 0x20, 'slide_src'), (0x2fd, 0x20, 'slide_dst'), (0x321, 1, 'active'),
          (0x322, 5, 'has_*'), (0x326, 0x31, 'record'), (0x371, 2, 'row371'), (0x373, 2, 'channel'),
          (0x375, 4, 'deadline_state'), (0x379, 4, 'deadline_anim'), (0x37d, 4, 'interval'), (0x381, 2, 'order_count'),
          (0x383, 0x1a, 'order'), (0x39d, 1, 'exit_taken'), (0x39e, 4, 'state'), (0x3a2, 4, 'next_state'),
          (0x3a6, 4, 'wait_state'), (0x3aa, 1, 'caption_shown'), (0x3ab, 1, 'warned'), (0x3ac, 1, 'picked_3ac'),
          (0x3ad, 1, 'picked_3ad'), (0x3ae, 1, 'has_exit')]


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
    if nat is None:
        return
    oi = x.image()
    ni, mask = nat.image()
    stats['object_bytes_compared'] += sum(mask)
    stats['object_bytes_unmodelled'] += IMG_BYTES - sum(mask)
    for k in range(IMG_BYTES):
        if mask[k] and oi[k] != ni[k]:
            raise Mismatch('%s object field %s: original %02x native %02x' % (where, field_of(k), oi[k], ni[k]))
    if x.rs32(START_FLAG) != nat.world_flag():
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), nat.world_flag()))
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


# ---------------------------------------------------------------------------------------------
# scenario execution
# ---------------------------------------------------------------------------------------------
VIEWS = {'v0': (0, 0), 'v1': (13, 21), 'neg': (-40, -25), 'big': (300, 200), 'edge': (0x7ffffff0, -0x7ffffff0)}
CLOCKS = {'low': 100, 'mid': 0x7fffff00, 'sign': 0x7ffffff0, 'wrap': 0xfffff000, 'top': 0xfffffff8}
BG_SURFACE = 0x33330000
STATE_NAMES = list(range(1, 13))


class Ctx:
    pass


def make_ctx(x, lib, sc, stats):
    ctx = Ctx()
    ctx.x, ctx.stats, ctx.sc = x, stats, sc
    ctx.lib = lib
    ctx.nat = Native(lib) if lib is not None and sc.get('native', True) else None
    ctx.rows, ctx.first = list(sc['rows']), sc['first']
    ctx.phase, ctx.complete = {}, {}
    ctx.rng = random.Random(sc.get('seed', 1))
    ctx.clock = CLOCKS['low']
    ctx.cand = 0
    ctx.view = VIEWS['v0']
    ctx.stop = False
    ctx.skip_final = False
    ctx.tickno = 0
    ctx.pending_busy = [0] * 8
    ctx.texts = {}
    ctx.states = set()
    return ctx


def row_body(ctx, row):
    k = row - ctx.first
    return ctx.rows[k]['body'] if 0 <= k < len(ctx.rows) else None


def obj_row(ctx):
    r = ctx.x.rs16(OBJ + 0x1e)
    return r if row_body(ctx, r) is not None else None


def active_body(ctx):
    r = obj_row(ctx)
    return ctx.rows[r - ctx.first]['body'] if r is not None else (ctx.rows[0]['body'] if ctx.rows else None)


def gen_rand(rng, policy, n=3000):
    if policy == 'uniform':
        return [rng.randrange(32768) for _ in range(n)]
    if policy == 'low':
        return [rng.choice([0, 1, 2, 3, 12, 13, 38, 39]) for _ in range(n)]
    if policy == 'zeros':
        return [0] * n
    if policy == 'max':
        return [32767] * n
    if policy == 'cycle':
        return [(7 * i + 3) % 32768 for i in range(n)]
    if policy == 'edge':       # exercises the signed idiv at its limits
        return [rng.choice([0, 1, 32767, 32766, 16384, 12, 13, 39, 40]) for _ in range(n)]
    return list(policy) + [rng.randrange(32768) for _ in range(n)]


def make_queues(ctx, spec):
    """Tick values, busy answers and rand values for one dispatch; both sides receive the same lists."""
    x, rng = ctx.x, ctx.rng
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 48)
    d1, d2 = struct.unpack('<I', x.rd(OBJ + 0x375, 4))[0], struct.unpack('<I', x.rd(OBJ + 0x379, 4))[0]
    if policy == 'clock':
        base = ctx.clock
        ticks = [(base + i) & 0xffffffff for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', (0, 1, 7, 300, 1500, 2600, 9000)))) & 0xffffffff
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 1000, 0x80000000, -0x80000000, 0x7fffffff]
        ticks = [(rng.choice((d1, d2)) + rng.choice(offs)) & 0xffffffff for _ in range(n)]
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, d1, d2, d1 - 1, d2 + 1, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)])
                 & 0xffffffff for _ in range(n)]
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
    return ticks, busy, gen_rand(rng, spec.get('rand', 'uniform'))


def load_queues(ctx, ticks, busy, rand):
    ctx.x.set_queues(ticks, busy, rand, ctx.texts)
    if ctx.nat:
        ctx.nat.set_queues(ticks, busy, rand)


def set_texts(ctx, texts):
    ctx.texts = dict(texts)
    if ctx.nat:
        ctx.nat.set_texts(ctx.texts)


def gate_open(ctx, spec):
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
        if gate_open(ctx, ctx.rows[k]):
            return row
    return None


def check_consumption(where, ctx, qlist=('ticks', 'busy', 'rand')):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['ticks_consumed'] += x.tick_i
    stats['busy_consumed'] += x.busy_i
    stats['rand_consumed'] += x.rand_i
    if nat is None:
        return
    nc = nat.consumed()
    if (x.tick_i, x.busy_i, x.rand_i) != tuple(nc[:3]) or nc[3] or nc[4] or nc[5] or nc[6] or nc[7]:
        raise Mismatch('%s queue consumption original %s native %s (underflows %s host_error %d alloc_fail %d)' % (
            where, (x.tick_i, x.busy_i, x.rand_i), nc[:3], nc[3:6], nc[6], nc[7]))


def count_effects(stats, fx):
    stats['effects'] += len(fx)
    for t in fx:
        stats['effect_kinds'][FXN[t[0]]] += 1


def do_tick(ctx, where, spec):
    x, nat, stats, rows, first = ctx.x, ctx.nat, ctx.stats, ctx.rows, ctx.first
    ticks, busy, rand = make_queues(ctx, spec)
    load_queues(ctx, ticks, busy, rand)
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
    nfx, ncalls, names, captions = [], [], [], []
    broken = fatal is not None or hang is not None or fault is not None
    stopped_early = False
    for n_i, (row, phase, fxs) in enumerate(segs):
        last = n_i == len(segs) - 1
        body = rows[row - first]['body']
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt is None or nxt != row:
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
                    ctx.complete[row] = 1 if rows[row - first].get('subtype', 1) == 1 else 0
                    stats['completions'] += 1
                if x.cells()[7] != 3:
                    mode_model = x.cells()[7]
            continue
        status, why, fx, cl, nm, cap, res = nat.step(body, row, phase)
        if last and broken:
            kind = 'H1' if hang else ('H2' if fault else 'FATAL')
            if hang:
                nc = nat.consumed()
                ok = status == 7 or nc[5] > 0
            elif fault:
                ok = status == 2 and not fx
            else:
                ok = status == 4
            if not ok:
                raise Mismatch('%s original %s (%s) but native status %d (%s) underflow %s' % (
                    where, kind, hang or fault or hex(fatal), status, why, nat.consumed()[3:6]))
            stats['known_observed'][kind + ':' + ctx.sc['id']] += 1
            ctx.stop = True
            ctx.skip_final = True
            continue
        if status == 6 and 'order' in why and x.rs16(OBJ + 0x381) > 12:
            # B1: the original increments the order count past 12 and writes order[13] over +0x39d / +0x39e (overrun)
            stats['known_observed']['B1:order-index:' + ctx.sc['id']] += 1
            stopped_early = True
            break
        if status == 3 and why == '0xf6-phase-1-without-init' and phase == 1 and ctx.sc['group'] == 'rows':
            # G1: two rows share the singleton. The original (0x45f61b) tests neither the owner row nor the active
            # flag and keeps stepping row A's body on the state row B initialised; the native f6_step refuses it as
            # UNSUPPORTED. With that one guard removed the native matches the original on this scenario
            # (verified on a scratch copy; the unit test case host_failure_and_phase_guard pins the guard).
            stats['known_observed']['G1:phase1-not-owner:' + ctx.sc['id']] += 1
            stopped_early = True
            break
        if status != 0:
            raise Mismatch('%s native refused (status %d: %s) where the original ran' % (where, status, why))
        compare_seq('%s entry %d' % (where, n_i), 'effect', [(ENTER, row, phase)] + fxs, [(ENTER, row, phase)] + fx)
        compare_seq('%s entry %d' % (where, n_i), 'host call', [(ENTER, row, phase)] + csegs[n_i][2], [(ENTER, row, phase)] + cl, HN)
        nfx.extend(fx)
        names.extend(nm)
        captions.extend(cap)
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
        if nat.cells()[7] != 3:
            mode_model = nat.cells()[7]
    if stopped_early:
        ctx.stop = ctx.skip_final = True
        return len(entered)
    if not broken:
        nxt = next_expected(ctx, mode_model, expected_i)
        if nxt is not None:
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
    stats['captions'] += len(x.captions)
    if nat is not None and not broken:
        if x.loaded != names:
            raise Mismatch('%s loaded image names differ: original %r native %r' % (where, x.loaded, names))
        if x.captions != captions:
            first = next((i for i in range(min(len(x.captions), len(captions))) if x.captions[i] != captions[i]),
                         min(len(x.captions), len(captions)))
            raise Mismatch('%s captions differ at index %d (original %d captions, native %d): original %r native %r' % (
                where, first, len(x.captions), len(captions), x.captions[first:first + 1], captions[first:first + 1]))
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
    body = active_body(ctx)
    canary = {G_CAND: 0xfeedface, G_CURSOR: 0x77, G_CURSOR2: 0x88, 0x5d1631: 0x99, 0x5d1639: 0xaa, 0x5d162d: 0xbb}
    save = {a: x.rd(a, 4) for a in canary}
    for a, v in canary.items():
        x.w32(a, v)
    load_queues(ctx, [], [], [])
    hit = x.run_op(0x45e1ca, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000], OBJ)
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
        sprite = 1 if cur == 9 else 2
        ok = (got[G_CURSOR2] == 1 and got[0x5d1639] == 1 and got[0x5d162d] == cell and
              got[0x5d1631] == (0x5b160c + (cur << 5) + 16) and cur in (9, 0x16) and cand in (0x27ec, 0x27ed, 0x27ef) and
              (cur == 9) == (cand == 0x27ef))
        if not ok:
            raise Mismatch('%s original cursor cells violate the 0x45e4d4 contract: %s' % (where, {hex(a): hex(v) for a, v in got.items()}))
        ctx.cand = cand
        stats['pointer_hits'] += 1
        stats['pointer_cand_%x' % cand] += 1
    else:
        sprite = 0
        for a, v in save.items():
            x.wr(a, v)
    if nat is not None:
        status, out = nat.pointer(body, px, py)
        if status != 0:
            raise Mismatch('%s native pointer status %d' % (where, status))
        nhit, ncand, ncur, nsprite = out
        if hit != nhit:
            raise Mismatch('%s pointer return: original %d native %d' % (where, hit, nhit))
        if cand_written:
            if (cand, cur, sprite) != (ncand, ncur, nsprite):
                raise Mismatch('%s cursor/candidate/sprite: original %#x/%d/%d native %#x/%d/%d' % (where, cand, cur, sprite, ncand, ncur, nsprite))
            nat.lib.f6o_set_entry_u32(nat.h, 2, 8, x.rs32(G_CURSOR_CELL) & 0xffffffff)
            nat.lib.f6o_set_entry_u32(nat.h, 2, 0xc, got[0x5d1631])
            nat.lib.f6o_set_entry_u32(nat.h, 2, 0x14, 1)
        elif ncand != -1 or ncur != 0 or nsprite != 0:
            raise Mismatch('%s native wrote cursor/candidate %d/%d/%d, original did not' % (where, ncand, ncur, nsprite))
    stats['pointer_moves'] += 1
    compare_state(where, ctx)


def do_click(ctx, where, cand=None, rowphase=None, flag=None):
    x, nat, stats, rows = ctx.x, ctx.nat, ctx.stats, ctx.rows
    if cand is not None:
        x.w32(G_CAND, cand)
        ctx.cand = s32(cand)
    if flag is not None:
        x.w32(START_FLAG, flag)
        if nat:
            nat.lib.f6o_set_world_flag(nat.h, flag)
    row = obj_row(ctx)
    if rowphase is not None and row is not None:
        x.w32(ROWS + row * ROW + PHASE_OFF, rowphase)
        ctx.phase[row] = rowphase
    rp = ctx.phase.get(row, 0) if row is not None else 0
    body = row_body(ctx, row) if row is not None else active_body(ctx)
    acts = bool(x.rd(OBJ + 0x321, 1)[0] and not x.rd(OBJ + 0x2aa, 1)[0] and x.rs32(OBJ + 0x39e) != 10 and rp == 1)
    ticks, busy, rand = make_queues(ctx, dict(ticks=[0] * 4, busy=ctx.pending_busy, count=4))
    load_queues(ctx, ticks, busy, rand)
    try:
        x.run_op(0x45e587, [], OBJ)
    except Hang as error:
        stats['known_observed']['H1:click:' + ctx.sc['id']] += 1
        ctx.stop = ctx.skip_final = True
        return
    if nat is not None:
        status, newp, fx, cl, nm, cap = nat.click(body, rp, ctx.cand, x.rs32(START_FLAG))
        if status != 0:
            raise Mismatch('%s native click status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
        compare_seq(where, 'host call', x.calls, cl, HN)
        if x.captions != cap:
            raise Mismatch('%s click captions differ' % where)
    check_consumption(where, ctx)
    count_effects(stats, x.fx)
    stats['host_calls'] += len(x.calls)
    stats['captions'] += len(x.captions)
    if row is not None:
        after = x.row_phase(row)
        if nat is not None and after != newp:
            raise Mismatch('%s click row phase: original %d native %d' % (where, after, newp))
        ctx.phase[row] = after
    stats['clicks'] += 1
    stats['clicks_acting' if acts else 'clicks_ignored'] += 1
    compare_state(where, ctx)


def blit_kind(b, bg):
    return 2 if b['fn'] == 0x4c5d4b else (0 if b['src_surface'] == bg else 1)


def do_render(ctx, where, back=0x22220000):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    row = x.rs16(OBJ + 0x1e)
    slot = x.rs16(OBJ + 0x1c)
    if not x.rd(OBJ + 0x321, 1)[0] or slot == -1 or row_body(ctx, row) is None:
        stats['render_skipped_unreachable'] += 1  # the entry is released: the engine never calls the callback
        return
    body = row_body(ctx, row)
    x.w32(G_BACK, back)
    x.w32(G_BG, BG_SURFACE)
    if nat:
        nat.lib.f6o_set_entry_u32(nat.h, 1, 8, BG_SURFACE)    # Z entry 1 +8 is 0x5d15e3, the restore source
    x._reset_logs()
    x.call(0x460f26, [], 0)
    stats['render_calls'] += 1
    bl = x.blits
    stats['blit_calls'] += len(bl)
    for b in bl:
        stats['blit_kind_%d' % blit_kind(b, BG_SURFACE)] += 1
        if b['dst_surface'] != back:
            raise Mismatch('%s blit destination surface %#x' % (where, b['dst_surface']))
    if x.fx:
        raise Mismatch('%s render logged effects' % where)
    if nat is not None:
        status, plan = nat.plan(body)
        if status == 6:
            sel, af = x.rs16(OBJ + 0x29a), x.rs16(OBJ + 0x29f)
            si, dc = x.rs16(OBJ + 0x2d7), x.rs16(OBJ + 0x2cd)
            if not (0 <= sel < 13) or not (0 <= af <= 14) or not (0 <= si <= 1) or not (0 <= dc <= 1):
                # B2: the original indexes the body rectangles with an out-of-range index (reads other body bytes)
                stats['known_observed']['B2:render-index:' + ctx.sc['id']] += 1
                ctx.stop = ctx.skip_final = True
                return
        if status != 0:
            raise Mismatch('%s native plan status %d' % (where, status))
        want = [(blit_kind(b, BG_SURFACE), tuple(b['src']), tuple(b['dst'])) for b in bl]
        if not plan['valid'] or plan['count'] != len(bl) or want != plan['blits']:
            k = next((i for i in range(min(len(want), len(plan['blits']))) if want[i] != plan['blits'][i]), None)
            raise Mismatch('%s render plan valid %d: original %d blits, native %d; first difference %s: %s vs %s' % (
                where, plan['valid'], len(bl), plan['count'], k, want[k] if k is not None else None,
                plan['blits'][k] if k is not None else None))
        sheet = x.entry_surface(slot)
        for b in bl:
            if b['src_surface'] not in (BG_SURFACE, sheet):
                raise Mismatch('%s blit source surface %#x' % (where, b['src_surface']))
        if plan['surface'] != sheet:
            raise Mismatch('%s plan surface %#x vs sheet %#x' % (where, plan['surface'], sheet))
    compare_state(where, ctx)


def do_cleanup(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    x.run_op(0x45dd4d, [], OBJ)
    if nat is not None:
        status, fx, cl, nm, cap = nat.simple(lambda: nat.lib.f6o_cleanup(nat.h))
        if status != 0:
            raise Mismatch('%s native cleanup status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
        compare_seq(where, 'host call', x.calls, cl, HN)
    stats['cleanups'] += 1
    count_effects(stats, x.fx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = x.rs16(OBJ + 0x1c)
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        if nat:
            nat.lib.f6o_set_entry_u32(nat.h, slot, 0x14, 0)
    x.run_op(0x45dd96, [], OBJ)
    if nat is not None:
        status, fx, cl, nm, cap = nat.simple(lambda: nat.lib.f6o_invalidate(nat.h))
        if status != 0:
            raise Mismatch('%s native invalidate status %d' % (where, status))
        compare_seq(where, 'effect', x.fx, fx)
    stats['invalidates'] += 1
    count_effects(stats, x.fx)
    compare_state(where, ctx)


def do_poke(ctx, where, pokes):
    """Force object bytes on both sides (states the game cannot reach; the code paths are the original's)."""
    for off, data in pokes.items():
        ctx.x.wr(OBJ + off, data)
    if ctx.nat:
        img = bytearray(ctx.nat.image()[0])
        for off, data in pokes.items():
            img[off:off + len(data)] = data
        ctx.nat.set_image(bytes(img))
    ctx.stats['pokes'] += 1
    compare_state(where, ctx)


def fuzz_pokes(ctx):
    """Plausible but arbitrary object states: every case of the state switch is entered with real data."""
    r, x = ctx.rng, ctx.x
    body = active_body(ctx)
    info = parse(body) if body else dict(cols=3, rows=3)
    cols = max(1, min(info['cols'], 13))
    nrows = max(1, min(info['rows'], 3))
    p = {}
    dv_frames = struct.unpack_from('<h', body, B_DV_FRAMES)[0] if body else 0
    nc_frames = struct.unpack_from('<h', body, B_NC_FRAMES)[0] if body else 0
    allowed = [s_ for s_ in range(1, 13) if not (s_ == 1 and dv_frames <= 0) and not (s_ == 2 and nc_frames <= 0)]
    st = r.choice(allowed * 2 + [4, 5, 6, 8, 9, 10, 11, 12])
    p[0x39e] = struct.pack('<i', st)
    if r.random() < 0.7:
        p[0x2a4] = struct.pack('<h', r.randrange(2))
    if r.random() < 0.6:
        p[0x29a] = struct.pack('<h', r.randrange(cols))
    for off in (0x3a2, 0x3a6):
        if r.random() < 0.6:
            p[off] = struct.pack('<i', r.choice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]))
    if r.random() < 0.5:
        p[0x2cf] = struct.pack('<h', r.choice([-1, 0, 1, 2, 3, 5, 14, 40]))
    if r.random() < 0.4:
        p[0x29f] = struct.pack('<h', r.choice([0, 1, 2, 14]))
    if r.random() < 0.5:
        p[0x2cd] = struct.pack('<h', r.randrange(2))
    if r.random() < 0.4:
        p[0x2d7] = struct.pack('<h', r.randrange(2))
        p[0x2d5] = struct.pack('<h', r.choice([-1, 0, 1, 2, 5, 6]))
        p[0x2d3] = bytes([r.randrange(2)])
    if r.random() < 0.3:
        p[0x2d9] = struct.pack('<i', r.choice([5, 6, 7, 1, 8]))
    if r.random() < 0.4:
        p[0x381] = struct.pack('<h', r.choice([-1, 0, 1, 2]))
    if r.random() < 0.4:
        p[0x383] = struct.pack('<hhh', r.randrange(cols), r.randrange(cols), r.randrange(cols))
    for off in (0x375, 0x379):
        if r.random() < 0.6:
            p[off] = struct.pack('<I', (ctx.clock + r.choice([-3000, -1, 0, 1, 5, 400, 3000, 0x80000000])) & 0xffffffff)
    for off in (0x299, 0x29c, 0x29d, 0x29e, 0x2aa, 0x2ab, 0x2ac, 0x2d4, 0x3aa, 0x3ab, 0x3ac, 0x3ad, 0x298):
        if r.random() < 0.25:
            p[off] = bytes([r.randrange(2)])
    for off in (0x2a8, 0x2a9):
        if r.random() < 0.2:
            p[off] = bytes([r.randrange(2)])
    if r.random() < 0.4:
        p[0x2a6] = struct.pack('<h', r.choice([0, 0, 1, 2, cols * nrows]))
    if r.random() < 0.4:
        p[0x373] = struct.pack('<h', r.choice([8, 3, 0, -1]))
    if r.random() < 0.5:   # hands
        for pl in range(2):
            cnt = [0] * cols
            for rr in range(nrows):
                for cc in range(cols):
                    have = int(r.random() < 0.25)
                    p[0x24 + 0x120 * pl + 0x34 * rr + 4 * cc] = struct.pack('<i', have)
                    cnt[cc] += have
            for cc in range(cols):
                p[0xf4 + 0x120 * pl + 2 * cc] = struct.pack('<h', cnt[cc])
                p[0x10e + 0x120 * pl + 4 * cc] = struct.pack('<i', int(cnt[cc] == 3))
    if r.random() < 0.3:
        p[0x142] = struct.pack('<h', r.randrange(4))
        p[0x262] = struct.pack('<h', r.randrange(4))
    return p


def untilcheck(ctx, until):
    x = ctx.x
    row = obj_row(ctx)
    if until == 'idle':
        return row is not None and x.rs32(OBJ + 0x39e) == 4 and ctx.phase.get(row, 0) == 1
    if until == 'done':
        return all(ctx.complete.get(r, 0) for r in range(ctx.first, ctx.first + len(ctx.rows)))
    if until == 'phase2':
        return row is not None and ctx.phase.get(row, 0) == 2
    if until == 'phase1':
        return row is not None and ctx.phase.get(row, 0) == 1
    return False


# -- dynamic targets and the auto-player ---------------------------------------------------------------
def pointer_target(ctx, exit_p=0.02):
    x, r = ctx.x, ctx.rng
    body = active_body(ctx)
    info = parse(body)
    cols = max(0, min(info['cols'], 13))
    nrows = max(0, min(info['rows'], 3))
    roll = r.random()
    count1 = [x.rs16(OBJ + 0x214 + 2 * c) for c in range(cols)]
    if roll < exit_p:
        return center(info['exit_rect'])
    if roll < 0.52 and cols:
        if info['has_buttons']:
            cs = [c for c in range(cols) if 0 < count1[c] < 3] or list(range(cols))
            return center(info['button'][r.choice(cs)])
        cards = [(rr, c) for rr in range(nrows) for c in range(cols)
                 if x.rs32(OBJ + 0x144 + 0x34 * rr + 4 * c) == 1 and count1[c] < 3]
        if cards:
            rr, c = r.choice(cards)
            return center(info['card'][rr][c])
    if roll < 0.6 and cols:
        rect_ = r.choice([info['button'][r.randrange(cols)], info['card'][r.randrange(3)][r.randrange(cols)], info['exit_rect']])
        l, t, rr_, b = rect_
        return clamp16(r.choice([l, rr_, l - 1, rr_ + 1])), clamp16(r.choice([t, b, t - 1, b + 1]))
    if roll < 0.7:
        return -9, -9
    return r.randrange(-50, 700), r.randrange(-50, 760)


def play(ctx, where, n, style):
    """The auto-player: `n` iterations of ticks, pointer moves, clicks, renders and invalidates chosen from the
    ORIGINAL's current memory (so the native side is driven with exactly the same inputs)."""
    r = ctx.rng
    fast = dict(ticks='clock', busy=style.get('busy', 'zero'), steps=style.get('steps', (1500, 2600, 400, 9000, 1)),
                rand=style.get('rand', 'uniform'))
    for i in range(n):
        if ctx.stop:
            return
        ctx.tickno += 1
        roll = r.random()
        w = '%s play %d' % (where, i)
        if roll < style.get('p_tick', 0.5):
            do_tick(ctx, w, fast if r.random() < 0.85 else dict(fast, busy='rand', ticks=r.choice(['dl', 'rand', 'clock'])))
        elif roll < 0.82:
            px, py = pointer_target(ctx, style.get('exit_p', 0.02))
            do_pointer(ctx, w, px, py)
            if r.random() < 0.85:
                do_click(ctx, w + ' click', r.choice([None, None, None, 0x27ec, 0x27ed, 0x27ef, -1, 7])
                         if r.random() < style.get('wild_click', 0.1) else None)
        elif roll < 0.88:
            do_render(ctx, w + ' render', 0x22220000 + i)
        elif roll < 0.91:
            do_invalidate(ctx, w + ' invalidate')
        elif roll < 0.93 and style.get('fuzz', False):
            do_poke(ctx, w + ' fuzz', fuzz_pokes(ctx))
        else:
            px, py = pointer_target(ctx, 0)
            do_pointer(ctx, w, px, py)
        if untilcheck(ctx, style.get('until', 'done')) and style.get('until', 'done') != 'never':
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


def text_table(rng, names, mode):
    """Scripted autotext table: sound name -> text bytes or absent."""
    out = {}
    for n in names:
        if mode == 'none':
            out[n] = None
        elif mode == 'all':
            out[n] = b'caption of ' + n
        elif mode == 'empty':
            out[n] = b''
        elif mode == 'long':
            out[n] = (b'X' * 200)[:200]
        elif mode == 'mixed':
            out[n] = rng.choice([None, b'', b'short', b'a' * 199, b'b' * 200, b'caption ' + n])
    return out


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
    nat = ctx.nat
    try:
        x.install_rows(ctx.rows, ctx.first)
        for r in range(ctx.first):
            ctx.complete[r] = 1
        x.wr(G_MODE, struct.pack('<i', sc.get('mode', 3)))
        for idx, v in sc.get('events', {}).items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
        # seeds: the cells and the flag start non-zero so a skipped store cannot hide
        seeds = [0x11111111, 0x2222, -0x3333, 0x4444, 0x55555555, 0x66666666, 0x77777777]
        for (a, sz), v in zip(CELLS, seeds):
            x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
        if nat:
            nat.set_cells(x.cells())
        x.w32(START_FLAG, 5)
        x.w32(G_CAND, 0)
        x.w32(G_CURSOR_CELL, sc.get('cursor_cell', 0x1234))
        if nat:
            nat.lib.f6o_set_world_flag(nat.h, 5)
            nat.set_handles(x.handles)
        set_view(ctx, VIEWS['v0'])
        infos = [parse(r['body']) for r in ctx.rows]
        allnames = sorted({n for i in infos for n in i['names']})
        set_texts(ctx, text_table(ctx.rng, allnames, sc.get('texts', 'none')))
        for s in sc.get('busy_slots', []):
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            if nat:
                nat.lib.f6o_set_busy_slot(nat.h, s, 1)
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
            nat.lib.f6o_set_world_flag(nat.h, act[1])
    elif kind == 'events':
        for idx, v in act[1].items():
            x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        sync_events(ctx)
    elif kind == 'texts':
        names = sorted({n for r in ctx.rows for n in parse(r['body'])['names']})
        set_texts(ctx, text_table(ctx.rng, names, act[1]))
    elif kind == 'rows':
        ctx.rows, ctx.first = list(act[1]), act[2]
        x.install_rows(ctx.rows, ctx.first)
        ctx.phase, ctx.complete = {}, {}
        for r in range(ctx.first):
            ctx.complete[r] = 1
        sync_events(ctx)
    elif kind == 'busy':
        ctx.pending_busy = list(act[1])
    elif kind == 'poke':
        do_poke(ctx, where, act[1])
    elif kind == 'fuzz':
        do_poke(ctx, where, fuzz_pokes(ctx))
    elif kind == 'ptr':
        do_pointer(ctx, where, act[1], act[2])
    elif kind == 'ptr_dyn':
        px, py = pointer_target(ctx, act[1] if len(act) > 1 else 0.02)
        do_pointer(ctx, where, px, py)
    elif kind == 'click':
        do_click(ctx, where, *act[1:])
    elif kind == 'invalidate':
        do_invalidate(ctx, where)
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
    """H2: the body is refused by the native validator before any effect (the original divides by zero)."""
    stats = ctx.stats
    body = act[1]
    if ctx.lib is not None:
        st = ctx.lib.f6o_validate(cbuf(body), len(body))
        if st != 2:
            raise Mismatch('%s expected F6_ERR_BODY from the validator, got %d' % (where, st))
    stats['known_observed']['H2:validate:' + act[2]] += 1


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


def R(body, subtype=1, tail=b''):
    return dict(body=body, tail=tail, subtype=subtype)


def patch(body, **fields):
    """A corpus / synthetic body with scalar fields replaced (cols, rows, deal, mode, A, B, C, slide, deliver, nocard)."""
    b = bytearray(body)
    for k, v in fields.items():
        if k in ('cols', 'rows', 'deal'):
            struct.pack_into('<h', b, {'cols': B_COLS, 'rows': B_ROWS, 'deal': B_DEAL}[k], v)
        elif k in ('A', 'B', 'C', 'mode'):
            b[{'A': B_A, 'B': B_B, 'C': B_C, 'mode': B_MODE}[k]] = v
        elif k == 'slide':
            struct.pack_into('<hhi', b, B_SL_STEPS, *v)
        elif k == 'deliver':
            struct.pack_into('<hhi', b, B_DV_FRAMES, *v)
        elif k == 'nocard':
            struct.pack_into('<hhi', b, B_NC_FRAMES, *v)
        elif k == 'names':
            for off, nm in v.items():
                put_name(b, off, nm)
        elif k == 'win':
            b[B_WIN:B_WIN + 2] = struct.pack('<h', v[0])
            b[B_WIN_CELLS:B_WIN_CELLS + 20] = struct.pack('<3h3ih', *v[1], *v[2], v[3])
        elif k == 'draw':
            b[B_DRAW:B_DRAW + 2] = struct.pack('<h', v[0])
        elif k == 'flags':
            struct.pack_into('<hh', b, B_FLAG_WIN, *v)
        elif k == 'exitb':
            b[B_EXIT:B_EXIT + 22] = scene_cells(*v)
        elif k == 'exit_rect':
            b[B_EXIT_RECT:B_EXIT_RECT + 16] = rect(*v)
        else:
            raise OracleError('patch field ' + k)
    return bytes(b)


def names_cfg(kind, rng):
    no = NO_SOUND
    keys = list(NAMES_DEFAULT)
    if kind == 'allreal':
        return {}
    if kind == 'allno':
        return {k: [no] for k in keys}
    if kind == 'empty':
        return {k: [b''] for k in keys}
    if kind == 'mixed':
        return {k: [rng.choice([no, b'REAL_%s_%d' % (k.encode(), i), b'', b'NO SOUNDX', b'NO SOUN']) for i in range(13)] for k in keys}
    if kind.startswith('pos:'):
        i = int(kind[4:])
        return {k: [(b'ONLY_%s_%d' % (k.encode(), i)) if j == i else no for j in range(13)] for k in keys}
    if kind.startswith('solo:'):
        i = int(kind[5:])
        return {k: [(b'SOLO_%s_%d' % (k.encode(), i)) if j == i else b'' for j in range(13)] for k in keys}
    if kind.startswith('only:'):
        want = kind[5:]
        return {k: ([b'REAL_' + k.encode()] if k == want else [no]) for k in keys}
    raise OracleError('names kind ' + kind)


def finish_blocks():
    return [(9999, (0, 0, 0), (0, 0, 0), 0), (9999, (1, 1, 1), (2, 2, 2), 1), (1234, (-1, -2, -3), (-4, 0x7fffffff, -0x80000000), 1),
            (-5, (32767, -32768, 0), (1, 2, 3), 0), (0, (0, 0, 0), (0, 0, 0), 2), (4377, (9, 8, 7), (6, 5, 4), -1)]


def random_scenario_parts(rng, i):
    cols = rng.choice([1, 2, 3, 3, 5, 10, 13])
    rows = rng.choice([1, 2, 3, 3])
    kw = dict(cols=cols, rows=rows, deal=rng.choice([0, 1, 2, 3, 5, 40]), mode=rng.choice([0, 1, 2, 255]),
              A=rng.randrange(2), B=rng.randrange(2), C=rng.randrange(2),
              names=names_cfg(rng.choice(['allreal', 'allreal', 'allno', 'mixed', 'mixed', 'empty', 'pos:%d' % rng.randrange(13)]), rng),
              slide=(rng.choice([0, 1, 2, 4, 6]), rng.choice([0, 1, 8, 20, -3]), rng.choice([0, 20, 500, -1])),
              deliver=(rng.choice([0, 1, 3, 14]), rng.choice([0, 1, 2]), rng.choice([0, 30, 4000])),
              nocard=(rng.choice([0, 1, 3, 14]), rng.choice([0, 1, 2]), rng.choice([0, 30, 4000])),
              buttons=rng.random() < 0.5, display=rng.random() < 0.7, turn=rng.random() < 0.8, scores=rng.random() < 0.7)
    blocks = finish_blocks()
    kw['win'] = rng.choice(blocks)
    kw['draw'] = rng.choice(blocks)
    kw['exitb'] = rng.choice(blocks)
    kw['flags'] = (rng.choice([-1, 5, 4095]), rng.choice([-1, 6, 0]))
    return kw


def scenario_list(seed=47, n_random=160):
    rng = random.Random(seed)
    scs = []
    cb = corpus_bodies()
    PL = dict(until='done', exit_p=0.02)

    # -- before init: everything is inert
    b0 = make_body(rng)
    S(scs, 'pre:inert', [R(b0)], [('ptr', 5, 5), ('click',), ('click', 0x27ec), ('click', 0x27ed), ('click', 0x27ef), ('invalidate',),
                                  ('cleanup',), ('render', 0x2222), ('ptr', 7, 9), ('cleanup',), ('invalidate',)], 'basic', quick=True)

    # -- the 6 corpus bodies: auto-play to the end, a pointer sweep, exits, abandon and re-enter
    for i, spec in enumerate(cb):
        body = spec['body']
        info = parse(body)
        sweep = []
        pts = []
        for r_ in info['button'] + [info['exit_rect']] + [c for row in info['card'] for c in row]:
            l, t, rr, b = r_
            for pnt in ((l, t), (rr, b), (l - 1, t), (l, t - 1), (rr + 1, b), (rr, b + 1), center(r_)):
                pts.append((clamp16(pnt[0]), clamp16(pnt[1])))
        for k, (px, py) in enumerate(pts[::3]):
            sweep.append(('ptr', px, py))
            if k % 25 == 0:
                sweep.append(('tick', CLK))
        for style, tx in (('all', 'all'), ('mixed', 'mixed'), ('none', 'none')):
            S(scs, 'corpus:%s_play_%s' % (spec['res'], style), [R(body, spec['subtype'])],
              [('texts', tx), ('tick', CLK), ('tick', CLK), ('play', 700, dict(PL, p_tick=0.45))], 'corpus', seed=100 * i + len(scs),
              quick=(i == 0 and style == 'all'), texts=tx)
        S(scs, 'corpus:%s_sweep_exit' % spec['res'], [R(body, spec['subtype'])],
          [('tick', CLK), ('tick', CLK)] + sweep + [('render', 1), ('play', 60, dict(PL, exit_p=0.3)), ('run', CLK, 'phase2', 4), ('tick', CLK)],
          'corpus', seed=i, texts='all')
        S(scs, 'corpus:%s_abandon' % spec['res'], [R(body, spec['subtype'])],
          [('tick', CLK), ('play', 120, dict(PL, until='never')), ('cleanup',), ('tick', CLK), ('invalidate',), ('revive',), ('tick', CLK),
           ('tick', CLK), ('play', 150, dict(PL, until='never')), ('render', 3), ('cleanup', 'keep'), ('invalidate',), ('render', 5)],
          'corpus', seed=7 + i, texts='mixed')

    # -- matrix: columns x rows x deal x mode x A,B,C
    mi = 0
    for cols in (1, 2, 10, 13):
        for rows in (1, 2, 3):
            for deal in (0, 1, 5, 40):
                for mode in (0, 2, 1, 255):
                    mi += 1
                    if (mi % 3) and not (cols, rows) in ((1, 1), (2, 2), (1, 3)):
                        continue
                    kw = dict(cols=cols, rows=rows, deal=deal, mode=mode, A=mi % 2, B=(mi // 2) % 2, C=(mi // 4) % 2,
                              win=finish_blocks()[1 + mi % 5], draw=finish_blocks()[1 + (mi + 2) % 5], exitb=finish_blocks()[mi % 6])
                    body = make_body(rng, **kw)
                    S(scs, 'matrix:c%d_r%d_d%d_m%d' % (cols, rows, deal, mode), [R(body)],
                      [('tick', CLK), ('play', 420, dict(PL, p_tick=0.5))], 'matrix', seed=mi, texts='all' if mi % 2 else 'mixed',
                      quick=(cols, rows, deal, mode) in ((1, 1, 0, 0), (2, 2, 1, 2), (1, 3, 5, 1), (2, 1, 40, 255)))
    # byte flags A, B, C and the mode byte on a mid-size table, both players starting
    for A in (0, 1):
        for B in (0, 1):
            for C in (0, 1):
                for mode in (0, 1, 2, 255):
                    body = make_body(rng, cols=3, rows=2, deal=2, mode=mode, A=A, B=B, C=C, win=finish_blocks()[2], draw=finish_blocks()[5],
                                     flags=(5, 6))
                    S(scs, 'flags:A%d_B%d_C%d_m%d' % (A, B, C, mode), [R(body)], [('tick', CLK), ('play', 380, PL)], 'flags',
                      seed=A * 8 + B * 4 + C * 2 + mode, texts='all', quick=(A, B, C, mode) in ((1, 1, 0, 2), (0, 0, 1, 0), (1, 0, 0, 255)))

    # -- sound name lists: NO SOUND at every position, all real, mixed, empty
    for kind in ['allno', 'allreal', 'empty', 'mixed'] + ['pos:%d' % i for i in (0, 1, 2, 4, 12)] + ['solo:0', 'solo:12'] + \
                ['only:button', 'only:pick', 'only:human', 'only:nocard', 'only:got', 'only:mis', 'only:names', 'only:lose', 'only:draw']:
        for C in (0, 1):
            body = make_body(rng, cols=3, rows=2, deal=2, mode=1, B=1, C=C, names=names_cfg(kind, rng), win=finish_blocks()[5], flags=(7, 8))
            S(scs, 'names:%s_C%d' % (kind.replace(':', '_'), C), [R(body)], [('tick', CLK), ('play', 380, PL)], 'names', seed=len(scs),
              texts='all', quick=(kind, C) in (('allno', 0), ('mixed', 1), ('allreal', 1)))

    # -- captions: autotext keys present / absent / empty / 200 characters / mixed
    for tx in ('none', 'all', 'empty', 'long', 'mixed'):
        for C in (0, 1):
            body = make_body(rng, cols=2, rows=2, deal=2, mode=2, C=C, B=1)
            S(scs, 'captions:%s_C%d' % (tx, C), [R(body)], [('tick', CLK), ('play', 300, PL)], 'captions', seed=len(scs), texts=tx,
              quick=(tx, C) in (('long', 1), ('mixed', 0)))

    # -- slide, delivery and no-card animation parameters
    for steps in (0, 1, 2, 6):
        for step in (0, 1, 8, -3):
            for interval in (0, 20, 5000):
                if rng.random() < 0.7 and (steps, step, interval) not in ((0, 0, 0), (6, 8, 20), (2, 1, 0)):
                    continue
                body = make_body(rng, cols=3, rows=2, deal=2, mode=1, slide=(steps, step, interval))
                S(scs, 'slide:s%d_d%d_i%d' % (steps, step, interval), [R(body)], [('tick', CLK), ('play', 300, PL)], 'slide', seed=len(scs),
                  texts='all', quick=(steps, step, interval) in ((6, 8, 20), (0, 0, 0)))
    for frames in (0, 1, 14):
        for passes in (0, 1, 3):
            for interval in (0, 30, 4000):
                if rng.random() < 0.75 and (frames, passes, interval) not in ((0, 0, 0), (14, 3, 30), (1, 1, 0)):
                    continue
                body = make_body(rng, cols=3, rows=2, deal=2, mode=1, deliver=(frames, passes, interval), nocard=(frames, passes, interval))
                S(scs, 'anim:f%d_p%d_i%d' % (frames, passes, interval), [R(body)], [('tick', CLK), ('play', 300, PL)], 'anim', seed=len(scs),
                  texts='all', quick=(frames, passes, interval) in ((14, 3, 30), (1, 1, 0)))

    # -- finish blocks: scene 9999 / valid, event flag -1 / valid, start-flag word 1 / other, each of +0x2a8 / +0x2a9
    blocks = finish_blocks()
    for bi, blk in enumerate(blocks):
        for oi in (0, 2, 4):
            for o8, o9 in ((1, 0), (0, 0), (0, 1), (1, 1)):
                body = make_body(rng, cols=2, rows=1, deal=0, mode=1, win=blk, draw=blocks[(bi + 3) % 6], exitb=blocks[oi], flags=(5, 4095 if bi % 2 else 9))
                acts = [('tick', CLK), ('poke', {0x2a8: bytes([o8]), 0x2a9: bytes([o9]), 0x2aa: b'\1', 0x39e: struct.pack('<i', 12)}),
                        ('events', {5: 77, 9: 66, 4095: 55}), ('run', CLK, 'done', 6)]
                S(scs, 'finish:b%d_o%d_%d%d' % (bi, oi, o8, o9), [R(body)], acts, 'finish', seed=bi, quick=(bi, oi, o8, o9) in ((1, 0, 1, 0), (2, 2, 0, 1), (5, 4, 1, 1)))
            # the exit block: clicks on the exit rectangle in the middle of play
            body = make_body(rng, cols=2, rows=1, deal=0, mode=1, win=blk, exitb=blocks[bi])
            S(scs, 'finish:exit_b%d_o%d' % (bi, oi), [R(body, 1 + (oi == 2))], [('tick', CLK), ('ptr', 520, 20), ('click',), ('run', CLK, 'done', 4), ('tick', CLK)],
              'finish', seed=bi, quick=(bi, oi) in ((1, 0), (2, 2)))
    body = make_body(rng, cols=2, rows=1, deal=0, win=blocks[2], exitb=blocks[1], draw=blocks[3], flags=(5, 6))
    S(scs, 'finish:phase2_unplayed', [R(body)], [('tick', CLK), ('setphase', 0, 2), ('tick', CLK), ('tick', CLK)], 'finish', quick=True)
    S(scs, 'finish:phase3_noop', [R(body)], [('tick', CLK), ('setphase', 0, 3), ('tick', CLK), ('setphase', 0, 9), ('tick', CLK)], 'finish', quick=True)
    S(scs, 'finish:subtype2_exit_repeat', [R(body, 2)], [('tick', CLK), ('ptr', 520, 20), ('click',), ('run', CLK, 'done', 3), ('tick', CLK), ('tick', CLK)],
      'finish', quick=True)

    # -- clock policies: wrap past 2^32, sign boundary, tick values around the deadlines
    for cname in CLOCKS:
        body = make_body(rng, cols=3, rows=2, deal=2, mode=1, C=0)
        S(scs, 'clock:%s' % cname, [R(body)], [('clock', cname), ('tick', CLK), ('play', 260, dict(PL, steps=(1, 50, 600, 3000)))], 'clock',
          seed=len(scs), texts='all', quick=cname in ('wrap', 'sign'))
    for pol in ('dl', 'rand'):
        for cnt in range(3):
            body = make_body(rng, cols=3, rows=2, deal=2, mode=1, C=cnt % 2)
            S(scs, 'clock:policy_%s_%d' % (pol, cnt), [R(body)],
              [('tick', CLK), ('run', dict(ticks=pol, busy='rand'), 'phase2', 200)], 'clock', seed=cnt, texts='all', quick=(pol == 'dl' and cnt == 0))

    # -- rand streams: low values, zeros (the retry loops spin: tagged H1), maximal values, signed edge values
    for policy in ('low', 'cycle', 'edge', 'max', 'zeros'):
        body = make_body(rng, cols=3, rows=2, deal=2, mode=1, C=0)
        S(scs, 'rand:%s' % policy, [R(body)], [('tick', CLK), ('play', 300, dict(PL, rand=policy))], 'rand', seed=len(scs), texts='all',
          quick=policy in ('low', 'zeros'))

    # -- busy scripts in the waiting states
    for nb, busy in enumerate(([0] * 8, [1, 1, 0, 0] + [0] * 4, [1] * 8, [0, 1, 1, 0, 1, 0, 0, 0], [2, -1, 0, 0])):
        body = make_body(rng, cols=3, rows=2, deal=2, mode=1, C=nb % 2)
        S(scs, 'busy:script%d' % nb, [R(body)], [('tick', CLK), ('play', 300, dict(PL, busy=busy))], 'busy', seed=nb, texts='all', quick=nb in (1, 3))

    # -- forced object states: every case of the state switch with real data
    for st in range(1, 13):
        for pl in (0, 1):
            body = make_body(rng, cols=3, rows=2, deal=2, mode=1, B=pl, C=pl, win=blocks[1], draw=blocks[3], flags=(5, 6))   # frames > 0
            acts = [('tick', CLK), ('tick', CLK)]
            for k in range(6):
                acts += [('poke', {0x39e: struct.pack('<i', st), 0x2a4: struct.pack('<h', pl), 0x3a2: struct.pack('<i', 4 + k % 6),
                                   0x3a6: struct.pack('<i', 4 + (k + 2) % 6), 0x375: struct.pack('<I', 0), 0x379: struct.pack('<I', 0)}),
                         ('fuzz',) if k % 2 else ('tick', CLK), ('tick', CLKR), ('tick', CLKR)]
            S(scs, 'state:%d_p%d' % (st, pl), [R(body)], acts + [('play', 150, dict(PL, fuzz=False))], 'state', seed=st * 2 + pl, texts='all',
              quick=(st, pl) in ((1, 0), (2, 1), (3, 0), (6, 1), (8, 0), (10, 1), (12, 0)))
    for k in range(24):
        kw = random_scenario_parts(rng, k)
        body = make_body(rng, **kw)
        S(scs, 'fuzz:%d' % k, [R(body)], [('tick', CLK), ('tick', CLK), ('play', 260, dict(PL, fuzz=True, until='never', p_tick=0.5))], 'fuzz',
          seed=k, texts=rng.choice(['all', 'mixed']), quick=k < 3)

    # -- rows: re-init, chains, false gates, subtype 2
    ba = make_body(rng, cols=2, rows=1, deal=0, mode=1, C=0, win=(100, (1, 2, 3), (4, 5, 6), 0), flags=(7, 8))
    bb = make_body(rng, cols=2, rows=1, deal=0, mode=1, C=0, win=(200, (1, 2, 3), (4, 5, 6), 1), flags=(8, 9))
    tail_b = struct.pack('<8h', 2, 7, 1, 0, 0, 0, 0, 0)
    S(scs, 'rows:chain_dep', [R(ba), R(bb, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('play', 300, PL), ('tick', CLK), ('events', {7: 1}),
                                                         ('play', 300, PL), ('tick', CLK)], 'rows', quick=True, handles=[0x7101, 0x7102, 0x7103], texts='all')
    S(scs, 'rows:chain_subtype2', [R(ba, 2), R(bb, 2, tail_b)], [('tick', CLK), ('play', 150, dict(PL, until='never')), ('tick', CLK), ('events', {7: 1}),
                                                                  ('tick', CLK), ('tick', CLK), ('run', CLK, 'phase2', 10), ('tick', CLK)], 'rows',
      handles=[0x7101, 0x7102, 0x7103, 0x7104], texts='all')
    S(scs, 'rows:reinit_no_cleanup', [R(ba)],
      [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('rows', [R(bb)], 0), ('tick', CLK), ('ptr', 11, 22), ('tick', CLK), ('render', 3), ('cleanup',)], 'rows', quick=True)
    S(scs, 'rows:cleanup_reinit', [R(ba)],
      [('tick', CLK), ('ptr', 30, 40), ('tick', CLK), ('cleanup',), ('tick', CLK), ('revive',), ('tick', CLK), ('tick', CLK), ('rows', [R(bb)], 0), ('tick', CLK),
       ('render', 1), ('invalidate',), ('cleanup',), ('cleanup',), ('invalidate',), ('tick', CLK)], 'rows', quick=True)
    S(scs, 'rows:offset_first_row:dep', [R(ba), R(bb, 1, tail_b)], [('tick', CLK), ('ptr', 1, 1), ('tick', CLK), ('play', 200, PL), ('tick', CLK)], 'rows',
      first=2, handles=[0x7101, 0x7102, 0x7103], texts='all')
    S(scs, 'gate:false_dep', [R(ba, 1, tail_b)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',), ('events', {7: 1}), ('tick', CLK), ('tick', CLK),
                                                   ('events', {7: 0}), ('tick', CLK), ('events', {7: 1}), ('tick', CLK)], 'gate', quick=True)
    S(scs, 'gate:mode4', [R(ba)], [('mode', 4), ('tick', CLK), ('tick', CLK), ('mode', 3), ('tick', CLK), ('tick', CLK)], 'gate', mode=4)
    S(scs, 'slots:busy_low', [R(ba)], [('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x19, 0x1a], quick=True)
    S(scs, 'slots:busy_gap', [R(ba)], [('tick', CLK), ('tick', CLK), ('invalidate',), ('cleanup',)], 'slots', busy_slots=[0x18, 0x1a, 0x1b, 0x3e])
    for vname in ('v1', 'neg', 'big', 'edge'):
        S(scs, 'view:%s' % vname, [R(make_body(rng, cols=3, rows=2, deal=2))], [('view', vname), ('tick', CLK), ('render', 1), ('play', 120, PL), ('render', 2)],
          'view', seed=len(scs), texts='all', quick=vname == 'neg')

    # -- H2: columns / rows zero (the original divides by zero; native refuses the body)
    for cols, rows in ((0, 3), (3, 0), (0, 0), (14, 3), (3, 4), (-1, 3)):
        body = make_body(rng, cols=cols, rows=rows, deal=1)
        S(scs, 'known:H2_c%d_r%d' % (cols, rows), [R(body)], [('refuse', body, 'c%d_r%d' % (cols, rows)), ('tick', CLK), ('tick', CLK), ('tick', CLK)], 'known',
          native=False, quick=True)

    # -- random scenarios with a fixed seed
    for k in range(n_random):
        kw = random_scenario_parts(rng, k)
        if rng.random() < 0.4:
            spec = rng.choice(cb)
            body = patch(spec['body'], cols=kw['cols'], rows=kw['rows'], deal=kw['deal'], mode=kw['mode'], A=kw['A'], B=kw['B'], C=kw['C'],
                         slide=kw['slide'], deliver=kw['deliver'], nocard=kw['nocard'])
        else:
            body = make_body(rng, **kw)
        style = dict(until=rng.choice(['done', 'done', 'never']), exit_p=rng.choice([0.0, 0.02, 0.1]), p_tick=rng.choice([0.3, 0.5, 0.7]),
                     rand=rng.choice(['uniform'] * 5 + ['low', 'edge', 'cycle']), busy=rng.choice(['zero', 'zero', 'rand', 'one']),
                     fuzz=rng.random() < 0.3, wild_click=rng.choice([0.0, 0.1, 0.4]))
        acts = [('tick', CLK), ('tick', CLK)]
        for seg in range(rng.randrange(1, 4)):
            acts.append(('play', rng.randrange(60, 360), style))
            if rng.random() < 0.25:
                acts += [('cleanup',), ('tick', CLK), ('revive',)]
            if rng.random() < 0.15:
                acts += [('view', rng.choice(list(VIEWS))), ('render', seg)]
            if rng.random() < 0.15:
                acts.append(('texts', rng.choice(['none', 'all', 'mixed', 'long'])))
        S(scs, 'random:%03d' % k, [R(body, rng.choice([1, 1, 2]))], acts, 'random', seed=1000 + k, texts=rng.choice(['all', 'mixed', 'none']),
          quick=k < 6)
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


def run_all(scs, lib, workers, progress=True, fail_fast=False):
    from concurrent.futures import ThreadPoolExecutor
    import threading
    stop = threading.Event()
    stats = make_stats()
    failures = []
    order = list(range(len(scs)))
    shards = [order[i::workers] for i in range(workers)]

    def work(shard):
        x = X86()
        local = make_stats()
        fails = []
        for idx in shard:
            if stop.is_set():
                break
            sc = scs[idx]
            try:
                run_scenario(x, lib, sc, local)
            except Mismatch as error:
                fails.append((sc['id'], 'mismatch', str(error)))
            except (OracleError, UcError) as error:
                fails.append((sc['id'], 'oracle-error', str(error)))
            if fail_fast and fails:
                stop.set()
        for k, v in x.counters.items():
            local['counter:' + k] += v
        return local, fails, [(a, z, h) for a, z, h in x.window_hashes]
    windows = None
    with ThreadPoolExecutor(max_workers=workers) as pool:
        for local, fails, windows in pool.map(work, shards):
            merge_stats(stats, local)
            failures.extend(fails)
    return stats, failures, windows


def summarize(stats, failures, scs, original_only):
    states = {str(s): stats.get('scenarios_reaching_%s' % s, 0) for s in list(range(1, 13)) + ['phase2']}
    visits = {str(s): stats.get('counter:phase1_state_%d' % s, 0) for s in range(1, 13)}
    out = dict(mode='original-only' if original_only else 'native-vs-original', scenarios_total=len(scs),
               scenarios_completed=stats.get('scenarios', 0), failures=len(failures),
               ticks=stats['ticks'], handler_steps=stats['steps'], phase_steps={k: stats['phase%s_steps' % k] for k in '012'},
               effects=stats['effects'], host_calls=stats['host_calls'], captions=stats['captions'],
               pointer_moves=stats['pointer_moves'], pointer_hits=stats['pointer_hits'], clicks=stats['clicks'],
               clicks_acting=stats['clicks_acting'], renders=stats['render_calls'], blits=stats['blit_calls'],
               cleanups=stats['cleanups'], invalidates=stats['invalidates'], pokes=stats['pokes'], completions=stats['completions'],
               scenarios_reaching_state=states, handler_visits_per_state=visits,
               effect_kinds=dict(stats['effect_kinds']), hang_detail=dict(stats['hang_detail']), fault_detail=dict(stats['fault_detail']), known_observed=dict(stats['known_observed']),
               scenarios_by_distinct_states=dict(sorted(stats['states_per_scenario'].items())),
               groups={g: dict(c) for g, c in sorted(stats['groups'].items())},
               consumed=dict(ticks=stats['ticks_consumed'], busy=stats['busy_consumed'], rand=stats['rand_consumed']))
    if not original_only:
        out.update(state_compares=stats['state_compares'], object_bytes_compared=stats['object_bytes_compared'],
                   object_bytes_unmodelled=stats['object_bytes_unmodelled'], entry_bytes=stats['entry_bytes'],
                   event_bytes=stats['event_bytes'], cells=stats['cells'])
    out['failure_sample'] = [dict(id=i, kind=k, message=m[:300]) for i, k, m in failures[:8]]
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--original-only', action='store_true', help='run every scenario on the original alone')
    ap.add_argument('--native-library', type=Path, help='prebuilt driver library (default: build from --kernel-src)')
    ap.add_argument('--kernel-src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--kernel-sources', default='action_family_f6_runtime.c')
    ap.add_argument('--quick', action='store_true')
    ap.add_argument('--group')
    ap.add_argument('--only', help='run scenarios whose id contains this text')
    ap.add_argument('--limit', type=int)
    ap.add_argument('--random', type=int, default=160)
    ap.add_argument('--seed', type=int, default=47)
    ap.add_argument('--workers', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    ap.add_argument('--fail-fast', action='store_true', help='stop at the first mismatch (mutation runs)')
    ap.add_argument('--list', action='store_true')
    a = ap.parse_args()
    scs = scenario_list(a.seed, a.random)
    if a.quick:
        scs = [s for s in scs if s['quick']]
    if a.group:
        scs = [s for s in scs if s['group'] == a.group]
    if a.only:
        scs = [s for s in scs if a.only in s['id']]
    if a.limit:
        scs = scs[:a.limit]
    if a.list:
        print(json.dumps(Counter(s['group'] for s in scs)))
        return 0
    lib = None
    native_hash = None
    if not a.original_only:
        if a.native_library:
            path = a.native_library
        else:
            tmp = Path(os.environ.get('TMPDIR', '/tmp')) / ('f6_oracle_driver_%d.so' % os.getpid())
            path = build_driver(a.kernel_src, tmp, tuple(a.kernel_sources.split(',')))
        native_hash = sha(Path(path).read_bytes())
        lib = open_lib(path)
    t0 = time.monotonic()
    stats, failures, windows = run_all(scs, lib, a.workers, fail_fast=a.fail_fast)
    out = summarize(stats, failures, scs, a.original_only)
    out['seconds'] = round(time.monotonic() - t0, 1)
    out['exe_sha256'] = EXE_HASH
    out['native_library_sha256'] = native_hash
    out['oracle_script_sha256'] = sha(Path(__file__).read_bytes())
    out['code_windows'] = [dict(start=hex(s), end=hex(e), sha256=h) for s, e, h in (windows or [])]
    out['hook_rets_checked'] = {hex(k): v[1] for k, v in HOOK_RETS.items()}
    print(json.dumps(out, indent=1, sort_keys=True))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
