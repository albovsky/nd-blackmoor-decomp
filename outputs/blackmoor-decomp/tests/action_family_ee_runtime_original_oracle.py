#!/usr/bin/env python3
"""RT-60: immutable x86 dispatcher 0x427a50 / handler 0x47c0f0 (raw 0xee, the Memory puzzle, CMemoryPuzzle) versus the native kernel
src/action_family_ee_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0xee the REAL dispatcher 0x427a50 runs: dependency trees
built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm 0x42a5f9 and the handler 0x47c0f0 (ECX = singleton 0x61e398) with
every phase (0 init, 1 with the inner states 0..4, 2 finish) and the generic completion 0x42ba3a. As ORIGINAL code: the flip-back timer
0x47ba79, the win / lose check 0x47badf, the deal 0x47bb56 with the picture picker 0x47c049 and the zeroed allocation 0x47d1c3, the sound
pickers 0x47cd90 / 0x47ce6f / 0x47cf4e, the sound player 0x47d02d, the clear 0x47b321 and reset 0x47b23b, the z entry allocator 0x4d39f9 and
releaser 0x4d3992, `_stricmp` 0x516530 (C locale: 0x63cb1c == 0) and `__ftol` 0x50ce04 (FPU control word 0x027f, as the RT-47 oracle).
The entry points the engine reaches through other callers are driven directly with ECX = 0x61e398: the pointer receiver 0x47b4aa (cascade
0x4f0059 at 0x4f0fb4, `ret 8`, x = word [event+0x5e], y = word [event+0x5a]) with the candidate writer 0x47b709, the accepted-release click
0x47b767 (chain 0x43b3a9), the invalidate 0x47b3bc, the clear 0x47b321 (scene cleanup / new game), the constructor 0x47b200 and the render
callback 0x47d24e (blits 0x4c5377 recorded). The native side is src/action_family_ee_runtime.c driven by
tests/action_family_ee_runtime_oracle_driver.c with a scripted host; the driver decides nothing the kernel decides.

Compared after EVERY call (dispatcher pass, pointer, click, invalidate, cleanup, render, power-on reset):
 * the whole 0x2c4-byte object image 0x61e398 against MpObject.b;
 * the tile cells (3 dwords each) and the picture-id table, while the object's pointers are nonzero, against MpObject.cells / used;
 * the typed body of every row (5,826 bytes) against the input, except byte +0x346 (the original stores 0 for one page: checked);
 * the start flag 0x5bb1ca, the seven scene-change cells, the engine mode 0x583999, the whole event flag window (4096 dwords at 0x585801),
   the candidate 0x5c39e5, the cursor cells 0x5b44f0 / 0x5b44f4, the whole generic Z entry table (0x58 entries of 0x4a bytes), the row
   phase dword and completion byte of every row against a model fed by the native outputs;
 * every byte written in the data region 0x52a000..0x63f000 that no modelled cell owns fails the run (apart from the gate's pinned scratch);
 * the exact ordered effect sequence of the original (handler entries with row and phase, start flag stores, the scene-change block as one
   transition, event flag stores, the clear-item / recenter / z slot calls, the surface load and release, _rand, GetTickCount, the sound
   prepare / play / busy calls, AUTOTEXT, caption text, the completion) against the sequence the native kernel reports for the same visit,
   entry for entry; the scripted queues (ticks, busy answers, _rand values) are consumed identically by both sides;
 * the heap traffic of the original (malloc sizes and free pointers of every visit and clear) against the object image;
 * render: every recorded 0x4c5377 blit (source surface, destination, rectangle contents, label pointer) in order against mp_render_plan.

HOOKS (everything else is original code): R = replaced (records the call, applies the scripted effect, pops the original's `ret N` and
returns), O = observed (recorded, the original then runs), G = raising guard.
  R 0x51dc43 malloc (the FIRST request of a handler visit returns MP_GUEST_CELLS, the SECOND MP_GUEST_USED; sizes recorded; other callers:
    the loader's bump arena)   R 0x51dc6c free (recorded)   R 0x50cd50 _rand (scripted stream, the native host callback consumes the same
    stream)   R 0x4c2790 load image (ECX 0x5cf659, ret 0x10: fixed nonzero handle, name and tag recorded)   R 0x4c2dfb release surface
    (ret 4: records and zeroes *arg)   R 0x4e8d96 clear pending item (ECX 0x571442)   R 0x4db870 cursor recenter (ECX 0x5830ce)
    R 0x4fb77a / 0x4fb2e3 / 0x4f6334 sound prepare / play / busy (ECX 0x5c3a67 / 0x5c3a67 / 0x5cf1eb, ret 4; busy scripted)
    R 0x423259 AUTOTEXT lookup (ECX 0x619a6b)   R 0x448d11 caption show (ECX 0x619a05, ret 0x10)   R 0x4c5377 render blit (ECX 0x5cf659,
    ret 0x14)   R GetTickCount (import stub)   O 0x47c0f0 handler entry   O 0x42ba3a generic completion   O 0x4d3992 / 0x4d39f9 z slot
    release / allocate   G 0x50ca3e 0x4264e8 0x44a2b7 0x4c97b4 0x42639d 0x52139c: the error paths (the native kernel refuses those bodies;
    0x52139c, the allocator's out-of-slots path, is expected only by the scenario that fills the table).
 Windows imports are stubbed (single thread); any other import fails the run. The debug flag 0x63a4cd is 0.

NATIVE-ONLY REFUSALS (never run against the original; checked natively in refusal_checks(), counted separately): mp_validate_body failures,
phase 1 / 2 without phase 0, a tab index outside the pages or a tile index outside the table at a click (the original indexes memory
outside the table), a flipped-cell pointer that is not a cell, an event flag index the host refuses, a caption longer than the 104-byte
local, a random-pick loop beyond MP_PICK_LIMIT, host failures.

Modes: --quick-only runs the scenarios flagged quick; the default is every scenario plus the native-only checks; --workers N shards the
scenario list over N processes; --src DIR builds the driver from another copy of the kernel (the mutation check does this);
--discover-pins prints nothing new (the pins are fixed windows verified at start-up).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_ee_runtime_original_oracle.py --quick-only
  python3 action_family_ee_runtime_original_oracle.py --workers 4 --result ../../../work/rt60/RT-60.oracle-result.json
"""
from __future__ import annotations

import argparse
import ctypes as C
import hashlib
import json
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import time
import os
from collections import Counter
from pathlib import Path

from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
RESOURCES = ROOT / 'work/analysis/hiff-resources'
CORPUS = ROOT / 'work/analysis/slices/A-EE.1.corpus.json'

OBJ, OBJ_LEN = 0x61e398, 0x2c4
BODY_LEN = 5826
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = 0x5bb5b3, 0x8d, 0x7f, 0x72
ENTRY, STRIDE, NENT = 0x5d1591, 0x4a, 0x58
START_FLAG = 0x5bb1ca
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
G_VIEW = (0x583186, 0x58318a, 0x58318e, 0x583192)
G_CLIP = (0x583196, 0x58319a, 0x58319e, 0x5831a2)
G_BACK, G_SAVED = 0x5cf665, 0x5d15e3
G_CAND, G_CURSOR, G_CURSOR2 = 0x5c39e5, 0x5b44f0, 0x5b44f4
G_E2_SRC, G_E2_REC, G_E2_FLAG = 0x5d162d, 0x5d1631, 0x5d1639
G_CAPTIONS, G_CAPSURF, G_CURSOR_SRC = 0x5bb202, 0x5d03b3, 0x5d0377
EVENTS_VA, EVENT_COUNT = 0x585801, 4096
CELLS = ((0x5bb57b, 4), (0x5bb599, 2), (0x5bb595, 2), (0x5c39ff, 2), (0x5bb59b, 4), (0x5bb59f, 4), (0x5bb5a3, 4))
XFER_ORDER = [(a, s) for a, s in CELLS] + [(START_FLAG, 4), (G_MODE, 4)]
TAIL_BASE, BODY_BASE, BODY_STRIDE, MAX_ROWS = 0x2000a000, 0x22000000, 0x2000, 4
SCRATCH, SCRATCH_SIZE = 0x24000000, 0x500000
TEXT_BASE, TEXT_STRIDE = SCRATCH + 0x10000, 0x10000
HEAP_BASE, HEAP_SIZE = 0x40000000, 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
MP_CELLS, MP_USED = 0x30000000, 0x30010000
SURF_HOST, SOUND_THIS, BUSY_THIS, ITEM_THIS, CURSOR_THIS = 0x5cf659, 0x5c3a67, 0x5cf1eb, 0x571442, 0x5830ce
AUTO_THIS, CAP_THIS = 0x619a6b, 0x619a05
FPCW = 0x27f
MARK_SAVED, MARK_BACK, MARK_CAPSURF, MARK_CURSOR_SRC = 0x5d1111, 0x22220000, 0x5d1234, 0x5d4321
DATA_LO, DATA_HI = 0x52a000, 0x63f000
GATE_SCRATCH = ((0x5c3a47, 4), (0x637871, 4), (0x637875, 4), (0x63787d, 4), (0x637e81, 4))
CAND_TAB, CAND_TILE = 0x2768, 0x2769
TAG_SURFACE = b'Memory Puzzle Overlay Surface'
BLIT_LABELS = {0: 0x54d1a0, 1: 0x54d1c8, 2: 0x54d1e4, 3: 0x54d20c}
HANDLER, GENERIC_COMPLETION = 0x47c0f0, 0x42ba3a

LOGKINDS = dict(START=1, CLEAR_ITEM=2, RECENTER=3, ALLOC=4, RELEASE_SLOT=5, LOAD=6, RELEASE=7, RAND=8, TICK=9, SND_PREPARE=10,
                SND_PLAY=11, SND_BUSY=12, AUTOTEXT=13, CAPTION=14, TRANSITION=15, FLAG=16, COMPLETE=17, ENTER=18)
KN = {v: k for k, v in LOGKINDS.items()}
K = LOGKINDS

# hooked functions: address -> (scan span, `ret N` immediate), checked against the unmodified image at start-up
HOOK_RETS = {0x4c2790: (0x108, 0x10), 0x4c2dfb: (0x60, 4), 0x4e8d96: (0x80, 0), 0x4fb77a: (0x300, 4), 0x4fb2e3: (0x200, 4),
             0x4f6334: (0x200, 4), 0x4c5377: (0x214, 0x14), 0x423259: (0x10f, 4), 0x448d11: (0xa21, 0x10), 0x50cd50: (0x22, 0),
             0x51dc6c: (0xb, 0)}
# replaced address -> (`ret N`, expected ECX or None)
REPLACED = {0x4c2790: (0x10, SURF_HOST), 0x4c2dfb: (4, SURF_HOST), 0x4e8d96: (0, ITEM_THIS), 0x4db870: (0, CURSOR_THIS),
            0x4fb77a: (4, SOUND_THIS), 0x4fb2e3: (4, SOUND_THIS), 0x4f6334: (4, BUSY_THIS), 0x423259: (4, AUTO_THIS),
            0x448d11: (0x10, CAP_THIS), 0x4c5377: (0x14, SURF_HOST), 0x50cd50: (0, None), 0x51dc6c: (0, None)}
GUARDS = [0x50ca3e, 0x4264e8, 0x44a2b7, 0x4c97b4, 0x42639d, 0x52139c]
# entry points the oracle drives: (begin, end, `ret N`)
ENTRY_RETS = ((0x47b4aa, 0x47b709, 8), (0x47c0f0, 0x47cd90, 4), (0x47b767, 0x47ba79, 0), (0x47b3bc, 0x47b3f0, 0), (0x47b321, 0x47b3bc, 0),
              (0x47b200, 0x47b21f, 0), (0x47d24e, 0x47d3e0, 0), (0x4db870, 0x4db993, 0))
# original code windows executed here: SHA-256 of the unmodified image bytes
PINS_TABLE = (
    (0x47b200, 0x47d3e0, '5f6c3ed52a16978db192b1fba192bb14d88dd56eec2acd7ac237cd7a5e8b4fa6'),
    (0x4d3992, 0x4d3a52, '68ba11a13ab1fc6a04738090dca7f80182a9944dcd4ea6fb140fe695474ba4f2'),
    (0x42ba3a, 0x42babf, '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x427a50, 0x42a9b4, '41778bbe0b676916876808865a5ee44c660fb899fcbdd8994249c19ab934a895'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x516530, 0x516600, 'e6af09f84ddc920c21c56a52ba89bb6f2b2f43bf0db2a874f605dfdb9ca98a65'),
    (0x50ce04, 0x50ce2b, 'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
)

# object layout (the kernel's O_* enum; verified against the disassembly by the oracle's image comparison)
O = dict(vtable=0, slot=4, row=6, surface=8, body=0xc, state=0x10, cells=0x14, used=0x18, first=0x1c, second=0x20, active=0x24, won=0x28,
         lost=0x2c, redraw=0x30, flipback=0x34, deadline=0x38, tiles=0x3c, tabtarget=0x1bc, tabhot=0x1cc, viewcopy=0x25c, view=0x26c,
         hit=0x27c, per_page=0x280, total=0x284, slots=0x288, page=0x28c, pairs=0x290, tries=0x294, half_total=0x298, half_page=0x29c,
         needed=0x2a0, ids=0x2a4, unused=0x2a8, loop_i=0x2ac, loop_j=0x2b0, cell=0x2b4, snd_match=0x2b8, snd_wrong=0x2bc, snd_win=0x2c0)
_OBJ_NAMES = sorted((v, k) for k, v in O.items())
# body layout
B = dict(name=0, pictures=0x21, tab_src=0xe1, tiles=0x111, tab_target=0x291, tab_hot=0x2a1, delay=0x331, pct_ids=0x335, pct_needed=0x339,
         needed=0x33d, tries=0x341, recenter=0x345, shuffle=0x346, pages=0x347, cols=0x34b, rows=0x34f, slot_cols=0x353, slot_rows=0x357,
         tabs=0x35b, flip1=0x35c, flip2=0x412, match=0x4c8, wrong=0x856, win=0xf72, block_win=0x168e, block_lose=0x16a8)
SND = 0xb6
NO_SOUND = b'NO SOUND'
M32 = 0xffffffff


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
    v &= M32
    return v - (1 << 32) if v & 0x80000000 else v


def clamp16(v):
    return max(-32768, min(32767, v))


# ---------------------------------------------------------------------------------------------
# bodies
# ---------------------------------------------------------------------------------------------
def rect_bytes(r):
    return struct.pack('<4i', *r)


def put_name(b, off, name, span, rng=None):
    """NUL terminated name inside a span; the bytes after the NUL are random printable garbage (never read by a correct copy)."""
    raw = name[:span - 1] + b'\0'
    b[off:off + len(raw)] = raw
    if rng is not None:
        for k in range(off + len(raw), off + span - 1):
            b[k] = rng.randrange(0x20, 0x7f)
        b[off + span - 1] = 0
    else:
        b[off + len(raw):off + span] = bytes(span - len(raw))


def put_sound(b, off, name, chan, key, text, rng):
    put_name(b, off, name, 0x21, rng)
    struct.pack_into('<h', b, off + 0x21, chan)
    for k in range(off + 0x23, off + 0x31):
        b[k] = rng.randrange(256)
    put_name(b, off + 0x31, key, 0x21, rng)
    put_name(b, off + 0x52, text, 0x64, rng)


def block_bytes(scene=9999, words=(0, 0, 0), dwords=(0, 0, 0), start=0, flag=-1, value=0):
    return struct.pack('<h3h3ihhh', scene, *words, *dwords, start, flag, value)


def parse(body):
    g = lambda o, f='<i': struct.unpack_from(f, body, o)[0]  # noqa: E731
    pages, cols, rows = g(B['pages']), g(B['cols']), g(B['rows'])
    per_page = cols * rows
    return dict(pages=pages, cols=cols, rows=rows, per_page=per_page, tabs=body[B['tabs']] != 0, shuffle=body[B['shuffle']],
                tiles=[struct.unpack_from('<4i', body, B['tiles'] + 16 * i) for i in range(max(0, min(per_page, 24)))],
                hot=[[struct.unpack_from('<4i', body, B['tab_hot'] + 0x30 * p + 0x10 * j) for j in range(3)] for p in range(3)],
                tries=g(B['tries']), delay=g(B['delay']), slot_cols=g(B['slot_cols']), slot_rows=g(B['slot_rows']))


_CORPUS = None


def corpus_rows():
    """The 2 raw 0xee rows of the owner's local resource 926 (never printed; only counts and hashes leave here)."""
    global _CORPUS
    if _CORPUS is None:
        c = json.loads(CORPUS.read_text())
        out = []
        for r in c['records']:
            data = (RESOURCES / ('%04d.bin' % r['resource_index'])).read_bytes()
            p, n = r['raw_body_offset'], r['raw_body_length']
            body = data[p:p + n]
            if len(body) != BODY_LEN + r['dependency_tail_length'] or sha(body) != r['body_sha256'] or \
               data[r['act_payload_offset'] + 48] != 0xee:
                raise OracleError('corpus row source mismatch')
            if sha(body[:BODY_LEN]) != r['typed_body_sha256']:
                raise OracleError('corpus typed body mismatch')
            out.append(dict(body=body[:BODY_LEN], tail=body[BODY_LEN:], subtype=data[r['act_payload_offset'] + 49]))
        _CORPUS = out
    return _CORPUS


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
SOURCES = ('action_family_ee_runtime.c',)


def build_driver(src_dir, out, strict=True, sanitize=False):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('gcc') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic'] + (['-Werror'] if strict else []) + [
        '-O1', '-g', '-fPIC', '-shared', f'-I{src_dir}', str(PROJECT / 'tests/action_family_ee_runtime_oracle_driver.c'),
        *[str(Path(src_dir) / s) for s in SOURCES], '-o', str(out)]
    if sanitize or os.environ.get('EE_SANITIZE'):
        cmd[1:1] = ['-fsanitize=undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p, u32p, i32p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8), C.POINTER(C.c_uint32), C.POINTER(C.c_int32)
    lib.mpo_new.restype = p
    for name, args, res in (
            ('mpo_free', [p], None), ('mpo_set_view', [p, i32p], None), ('mpo_reset_object', [p], None),
            ('mpo_set_handle', [p, C.c_uint32], None), ('mpo_set_start_flag', [p, i32], None), ('mpo_get_start_flag', [p], i32),
            ('mpo_set_captions', [p, i32], None), ('mpo_set_queues', [p, u32p, C.c_int, i32p, C.c_int, i32p, C.c_int], None),
            ('mpo_consumed', [p, i32p], None), ('mpo_clear_texts', [p], None), ('mpo_add_text', [p, C.c_char_p, C.c_char_p], None),
            ('mpo_set_entry_u32', [p, C.c_int, C.c_int, C.c_uint32], None), ('mpo_set_cells', [p, i32p], None),
            ('mpo_get_cells', [p, i32p], None), ('mpo_set_events', [p, i32p], None), ('mpo_get_events', [p, i32p], None),
            ('mpo_entries', [p, u8p], None), ('mpo_set_entries', [p, u8p], None), ('mpo_clear_log', [p], None),
            ('mpo_log_count', [p], C.c_int), ('mpo_bad_slot_calls', [p], C.c_int), ('mpo_log', [p, C.c_int, i32p], None),
            ('mpo_log_text', [p, C.c_int], C.c_char_p), ('mpo_set_body', [p, C.c_int, u8p, C.c_size_t], C.c_int),
            ('mpo_get_body', [p, C.c_int, u8p, C.c_size_t], None), ('mpo_why', [p], C.c_char_p),
            ('mpo_object', [p, u8p], None), ('mpo_set_object', [p, u8p], None), ('mpo_heap', [p, u8p, u8p], None),
            ('mpo_set_heap', [p, u8p, u8p], None), ('mpo_step', [p, C.c_int, C.c_int, C.c_uint32, C.c_uint32, u32p], C.c_int),
            ('mpo_pointer', [p, C.c_int, C.c_int, C.c_int, i32p], C.c_int),
            ('mpo_click', [p, C.c_int, C.c_uint32, C.c_uint32, i32], C.c_int), ('mpo_invalidate', [p], C.c_int),
            ('mpo_cleanup', [p], C.c_int), ('mpo_plan', [p, C.c_int, i32p], C.c_int),
            ('mpo_validate', [u8p, C.c_size_t, C.c_char_p], C.c_int), ('mpo_null_checks', [p, i32p], None),
            ('mpo_constants', [i32p], None), ('mpo_set_fail', [p, C.c_int], None)):
        f = getattr(lib, name)
        f.argtypes = args
        f.restype = res
    return lib


def cbuf(b):
    return (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))


MAX_BLITS = 40
CELL_BYTES, MAX_CELLS, MAX_IDS = 12, 72, 12


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.mpo_new()

    def close(self):
        self.lib.mpo_free(self.h)

    def set_view(self, v):
        self.lib.mpo_set_view(self.h, (C.c_int32 * 8)(*v))

    def set_queues(self, ticks, busy, rands):
        self.lib.mpo_set_queues(self.h, (C.c_uint32 * max(1, len(ticks)))(*[v & M32 for v in ticks]), len(ticks),
                                (C.c_int32 * max(1, len(busy)))(*[s32(v) for v in busy]), len(busy),
                                (C.c_int32 * max(1, len(rands)))(*rands), len(rands))

    def consumed(self):
        t = (C.c_int32 * 8)()
        self.lib.mpo_consumed(self.h, t)
        return list(t)

    def set_texts(self, texts):
        self.lib.mpo_clear_texts(self.h)
        for k, v in texts.items():
            self.lib.mpo_add_text(self.h, k, v)

    def set_body(self, i, body):
        self.lib.mpo_set_body(self.h, i, cbuf(body), len(body))

    def body(self, i):
        t = (C.c_uint8 * BODY_LEN)()
        self.lib.mpo_get_body(self.h, i, t, BODY_LEN)
        return bytes(t)

    def log(self):
        out = []
        t = (C.c_int32 * 13)()
        for i in range(self.lib.mpo_log_count(self.h)):
            self.lib.mpo_log(self.h, i, t)
            out.append((t[0], tuple(t[1:13]), (self.lib.mpo_log_text(self.h, i) or b'')))
        return out

    def clear(self):
        self.lib.mpo_clear_log(self.h)

    def step(self, ri, row, handle, phase):
        self.clear()
        res = (C.c_uint32 * 3)()
        status = self.lib.mpo_step(self.h, ri, row, handle, phase, res)
        return status, (self.lib.mpo_why(self.h) or b'').decode(), self.log(), list(res)

    def pointer(self, ri, x, y):
        self.clear()
        out = (C.c_int32 * 5)()
        status = self.lib.mpo_pointer(self.h, ri, x, y, out)
        return status, list(out)

    def click(self, ri, handle, row_phase, cand):
        self.clear()
        status = self.lib.mpo_click(self.h, ri, handle & M32, row_phase & M32, s32(cand))
        return status, self.log()

    def simple(self, fn):
        self.clear()
        status = fn(self.h)
        return status, self.log()

    def obj(self):
        t = (C.c_uint8 * OBJ_LEN)()
        self.lib.mpo_object(self.h, t)
        return bytes(t)

    def set_obj(self, raw):
        self.lib.mpo_set_object(self.h, cbuf(raw))

    def heap(self):
        c = (C.c_uint8 * (MAX_CELLS * CELL_BYTES))()
        u = (C.c_uint8 * (MAX_IDS * 4))()
        self.lib.mpo_heap(self.h, c, u)
        return bytes(c), bytes(u)

    def set_heap(self, cells, used):
        self.lib.mpo_set_heap(self.h, cbuf(cells), cbuf(used))

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.mpo_entries(self.h, t)
        return bytes(t)

    def set_entries(self, raw):
        self.lib.mpo_set_entries(self.h, cbuf(raw))

    def cells(self):
        t = (C.c_int32 * 8)()
        self.lib.mpo_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        self.lib.mpo_set_cells(self.h, (C.c_int32 * 8)(*v))

    def events(self):
        t = (C.c_int32 * EVENT_COUNT)()
        self.lib.mpo_get_events(self.h, t)
        return bytes(memoryview(t).cast('B'))

    def set_events(self, raw):
        self.lib.mpo_set_events(self.h, (C.c_int32 * EVENT_COUNT).from_buffer_copy(raw))

    def plan(self, ri):
        t = (C.c_int32 * (2 + 10 * MAX_BLITS))()
        status = self.lib.mpo_plan(self.h, ri, t)
        v = list(t)
        blits = []
        for i in range(v[1] if 0 <= v[1] <= MAX_BLITS else 0):
            q = v[2 + 10 * i:12 + 10 * i]
            blits.append(dict(src_kind=q[0], label=q[1], src=tuple(q[2:6]), dst=tuple(q[6:10])))
        return status, dict(valid=v[0], count=v[1], blits=blits)

    def validate(self, body, length=None):
        buf = C.create_string_buffer(64)
        rc = self.lib.mpo_validate(cbuf(body), len(body) if length is None else length, buf)
        return rc, buf.value.decode()


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


def pad12(v):
    v = list(v)[:12]
    return tuple(s32(a) for a in v) + (0,) * (12 - len(v))


def allowed_write(addr):
    if OBJ <= addr < OBJ + OBJ_LEN:
        return True
    for lo, hi in ((START_FLAG, START_FLAG + 4), (0x5bb57b, 0x5bb5a7), (0x5c39ff, 0x5c3a01), (G_MODE, G_MODE + 4), (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT),
                   (G_CAND, G_CAND + 4), (G_CURSOR, G_CURSOR + 8), (ENTRY, ENTRY + NENT * STRIDE)):
        if lo <= addr < hi:
            return True
    for a, n in GATE_SCRATCH:
        if a <= addr < a + n:
            return True
    if ROWS <= addr < ROWS + MAX_ROWS * ROW:
        return 0x36 <= (addr - ROWS) % ROW < 0x84
    return False


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
        self._check_constants()
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(BODY_BASE, 0x10000)
        uc.mem_map(SCRATCH, SCRATCH_SIZE)
        uc.mem_map(MP_USED, 0x1000)
        uc.mem_map(TIB, 0x1000)
        uc.mem_map(GDT, 0x1000)
        uc.mem_map(STUBS, 0x1000)
        uc.mem_write(STUBS, b'\xc3' * 0x1000)

        def seg(base, limit, access, flags):
            return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access,
                               ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
        uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc) + seg(TIB, 0xfff, 0x93, 0x4))
        uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
        uc.reg_write(X.UC_X86_REG_CS, 0x08)
        for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
            uc.reg_write(reg, 0x10)
        uc.reg_write(X.UC_X86_REG_FS, 0x18)
        self.rec = False
        self.fx = []
        self.steps = []
        self.loose = dict(mallocs=[], frees=[])
        self.in_dispatch = False
        self.no_alloc = False
        self.visit_allocs = 0
        self.allocs = {}
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.blits = []
        self.handle = 0x7001
        self.tick_q, self.tick_i = [], 0
        self.busy_q, self.busy_i = [], 0
        self.rand_q, self.rand_i = [], 0
        self.texts = {}
        self.pending = None
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
        self._hook_error = None
        self.rowbase = 0
        self.snapshot = None
        self._install_imports()
        self._install_hooks()

    def _check_hook_rets(self):
        from capstone import CS_ARCH_X86, CS_MODE_32, Cs
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
        for a, z, imm in ENTRY_RETS:
            rets = {int(i.op_str, 0) if i.op_str else 0 for i in md.disasm(self.pristine[a - base:z - base], a) if i.mnemonic == 'ret'}
            if rets != {imm}:
                raise OracleError('entry %#x: ret immediates %s, expected %s' % (a, rets, imm))

    def _check_constants(self):
        base = self.pe.image_base

        def img(va, n):
            return bytes(self.pristine[va - base:va - base + n])
        for va, data in ((0x54d0ec, b'NO SOUND\0'), (0x54d0f8, b'NO SOUND\0'), (0x54d104, b'NO SOUND\0'), (0x54d110, b'NO SOUND\0'),
                         (0x54d14c, b'NO SOUND\0'), (0x54d158, b'<n><e>\0'), (0x54d160, b'<n><e>\0'),
                         (0x54d0a0, b'WHALESURVIVOR GAME PUZZLE OVERLAYS\0'), (0x54d0c4, TAG_SURFACE + b'\0'), (0x54d0e4, b'CIFTREE\0')):
            if img(va, len(data)) != data:
                raise OracleError('image constant at %#x differs from the kernel assumption' % va)
        for va, n in ((0x63cb1c, 4), (G_LOG, 2)):
            if img(va, n) != bytes(n):
                raise OracleError('process cell %#x is not zero in the image' % va)

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
            v = (struct.unpack('<i', bytes(uc.mem_read(arg0, 4)))[0] + d) & M32
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
            v = self.tick_q[self.tick_i] & M32
            self.tick_i += 1
            self.log(K['TICK'], (s32(v),))
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
            uc.reg_write(X.UC_X86_REG_EAX, eax & M32)
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
        if self.in_dispatch:
            if self.visit_allocs >= 2:
                raise OracleError('a handler visit asked for a third allocation')
            start = (MP_CELLS, MP_USED)[self.visit_allocs]
            self.visit_allocs += 1
            (self.steps[-1] if self.steps else self.loose)['mallocs'].append(size)
            uc.reg_write(X.UC_X86_REG_EAX, start)
            self._ret(uc, 0)
            return
        if self.no_alloc:
            raise OracleError('unexpected allocation outside a handler visit')
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
        table[GENERIC_COMPLETION] = self._complete
        table[0x4d3992] = self._release_entry
        table[0x4d39f9] = self._alloc_entry
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        for lo, hi in ((0x5bb57b, 0x5bb5a6), (0x5c39ff, 0x5c3a00), (START_FLAG, START_FLAG + 3), (G_MODE, G_MODE + 3), (EVENTS_VA, EVENTS_VA + 4 * EVENT_COUNT - 1)):
            uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=lo, end=hi)

    def _raise(self, uc, address, size, user):
        if address == self.expect_fatal:
            raise Fatal(address)
        raise OracleError('guarded original routine %#x reached' % address)

    def _on_write(self, uc, access, address, size, value, user):
        if not self.rec:
            return
        value &= (1 << (8 * size)) - 1
        if EVENTS_VA <= address < EVENTS_VA + 4 * EVENT_COUNT:
            if size != 4 or (address - EVENTS_VA) % 4:
                raise OracleError('unexpected event flag write %#x/%d' % (address, size))
            self.log(K['FLAG'], ((address - EVENTS_VA) // 4, s32(value)))
            return
        if self.pending is None:
            if (address, size) == XFER_ORDER[0]:
                self.pending = [value]
            elif (address, size) == (START_FLAG, 4):
                self.log(K['START'], (s32(value),))
            else:
                raise OracleError('unmodelled cell write %#x/%d' % (address, size))
            return
        i = len(self.pending)
        if (address, size) != XFER_ORDER[i]:
            raise OracleError('scene-change block out of order: write %#x/%d at position %d' % (address, size, i))
        self.pending.append(value)
        if len(self.pending) == len(XFER_ORDER):
            p = self.pending
            self.pending = None
            self.log(K['TRANSITION'], (s32(p[0]), s16(p[1]), s16(p[2]), s16(p[3]), s32(p[4]), s32(p[5]), s32(p[6]), s32(p[8]), s32(p[7])))

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
        self.wr(a, struct.pack('<I', v & M32))

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

    def heap_blocks(self):
        """The original's cell array and id table bytes while the object's pointers are nonzero (else None)."""
        img = self.image()
        cp, up = struct.unpack_from('<II', img, O['cells'])[0], struct.unpack_from('<I', img, O['used'])[0]
        total, ids = struct.unpack_from('<ii', img, O['total'])[0], struct.unpack_from('<i', img, O['ids'])[0]
        cells = self.rd(cp, total * CELL_BYTES) if cp == MP_CELLS and 0 <= total <= MAX_CELLS else None
        used = self.rd(up, ids * 4) if up == MP_USED and 0 <= ids <= MAX_IDS else None
        return cells, used

    # -- data region watch -------------------------------------------------------------------
    def take_snapshot(self):
        self.snapshot = self.rd(DATA_LO, DATA_HI - DATA_LO)

    def check_unmodelled_writes(self, where):
        new = self.rd(DATA_LO, DATA_HI - DATA_LO)
        old = self.snapshot
        if new != old:
            for c in range(0, len(new), 4096):
                if new[c:c + 4096] != old[c:c + 4096]:
                    for k in range(c, min(c + 4096, len(new))):
                        if new[k] != old[k] and not allowed_write(DATA_LO + k):
                            raise Mismatch('%s unmodelled write at %#x (%02x -> %02x)' % (where, DATA_LO + k, old[k], new[k]))
        self.snapshot = new

    # -- effects ---------------------------------------------------------------------------------
    def log(self, kind, v=(), text=b''):
        if self.rec:
            self.fx.append((kind, pad12(v), bytes(text)))

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('handler entered with ECX != 0x61e398')
        phase = self.row_phase(row)
        self.rowbase = BODY_BASE + BODY_STRIDE * row
        self.visit_allocs = 0
        pre = self.image()
        if self.steps:
            self.steps[-1]['post'] = pre
        self.steps.append(dict(row=row, phase=phase, pre=pre, post=None, mallocs=[], frees=[], obj_row=s16(struct.unpack_from('<H', pre, O['row'])[0])))
        self.counters['phase%d_state%d' % (phase, struct.unpack_from('<i', pre, O['state'])[0])] += 1 if phase == 1 else 0
        self.fx.append((K['ENTER'], pad12((row, phase)), b''))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(K['COMPLETE'], (struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0],))

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.log(K['RELEASE_SLOT'], (struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0],))

    def _alloc_entry(self, uc, address, size, user):
        self.log(K['ALLOC'])

    def sound_id(self, ptr):
        if self.rowbase <= ptr < self.rowbase + BODY_LEN:
            return ptr - self.rowbase
        raise OracleError('sound record pointer %#x is not in the active body' % ptr)

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        pop, want_ecx = REPLACED[address]
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        if want_ecx is not None and ecx != want_ecx:
            raise OracleError('hook %#x entered with ECX %#x' % (address, ecx))
        eax = 0
        if address == 0x4c2790:
            kind, name, six, tag = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 0x21)), a[2], cstr(self.rd(a[3], 64))
            if kind != b'CIFTREE' or six != 6 or tag != TAG_SURFACE or a[1] != self.rowbase:
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handle
            self.log(K['LOAD'], (eax,), name + b'|' + tag)
        elif address == 0x4c2dfb:
            self.log(K['RELEASE'], (u32(uc, a[0]),))
            self.wr(a[0], bytes(4))
        elif address == 0x4e8d96:
            self.log(K['CLEAR_ITEM'])
        elif address == 0x4db870:
            self.log(K['RECENTER'])
        elif address == 0x4fb77a:
            rec = self.rd(a[0], 0x31)
            self.log(K['SND_PREPARE'], (self.sound_id(a[0]),), rec.hex().encode())
        elif address == 0x4fb2e3:
            self.log(K['SND_PLAY'], (s16(a[0]),))
        elif address == 0x4f6334:
            if self.busy_i >= len(self.busy_q):
                raise OracleError('busy queue underflow')
            eax = self.busy_q[self.busy_i] & M32
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
        elif address == 0x4c5377:
            rect = lambda p: tuple(struct.unpack('<4i', self.rd(p, 16)))  # noqa: E731
            self.blits.append(dict(src_surface=a[0], dst_surface=a[1], src=rect(a[2]), dst=rect(a[3]), tag_ptr=a[4]))
        elif address == 0x50cd50:
            if self.rand_i >= len(self.rand_q):
                raise OracleError('rand queue underflow')
            eax = self.rand_q[self.rand_i]
            self.rand_i += 1
            self.log(K['RAND'], (eax,))
        elif address == 0x51dc6c:
            (self.steps[-1] if self.in_dispatch and self.steps else self.loose)['frees'].append(a[0])
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
        uc.mem_write(SCRATCH, bytes(0x100000))
        uc.mem_write(MP_CELLS, bytes(0x1000))
        uc.mem_write(MP_USED, bytes(0x1000))
        uc.mem_write(TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, FPCW)
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.allocs.clear()
        self.blits = []
        self.fx = []
        self.steps = []
        self.loose = dict(mallocs=[], frees=[])
        self.handle = 0x7001
        self.tick_q, self.tick_i, self.busy_q, self.busy_i, self.rand_q, self.rand_i = [], 0, [], 0, [], 0
        self.texts = {}
        self.rec = False
        self.pending = None
        self.in_dispatch = self.no_alloc = False
        self.expect_fatal = None
        self.rowbase = 0
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.call(0x47b200, [], OBJ)  # the constructor, original code
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
            self.wr(base + 0x30, bytes([0xee, spec.get('subtype', 1)]) + struct.pack('<I', body_at))
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
        self.steps = []
        self.wr(0x5c3a47, bytes(4))
        self.rec = True
        self.in_dispatch = True
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.rec = False
            self.in_dispatch = False
            if self.steps and self.steps[-1]['post'] is None:
                self.steps[-1]['post'] = self.image()
        if self.pending is not None:
            raise OracleError('scene-change block left open')

    def run_op(self, address, args, ecx):
        """A directly driven entry point; the effects land in self.fx."""
        self.fx = []
        self.loose = dict(mallocs=[], frees=[])
        self.rec = True
        self.no_alloc = True
        try:
            return self.call(address, args, ecx)[0]
        finally:
            self.rec = False
            self.no_alloc = False

    def call(self, address, args, ecx):
        uc = self.machine
        self._hook_error = None
        self._fatal = None
        words = [deps.RETURN_SENTINEL, *[v & M32 for v in args]]
        uc.mem_write(TIB, bytes(8))  # empty SEH chain
        uc.mem_write(deps.STACK_TOP, struct.pack('<' + 'I' * len(words), *words))
        uc.reg_write(X.UC_X86_REG_ESP, deps.STACK_TOP)
        uc.reg_write(X.UC_X86_REG_ECX, ecx)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        try:
            uc.emu_start(address, deps.RETURN_SENTINEL, timeout=120_000_000, count=0)
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
    nz = list(v)
    while nz and nz[-1] == 0:
        nz.pop()
    return '%s%s%s' % (KN.get(k, k), tuple(nz), (' len%d' % len(s)) if s else '')


def norm_nat(seq):
    return [(k, pad12(v), bytes(s)) for k, v, s in seq]


def compare_log(where, orig, nat):
    orig, nat = list(orig), norm_nat(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        raise Mismatch('%s host call %d: original %s vs native %s (original %d calls, native %d)' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None, len(orig), len(nat)))


def field_of(off):
    if O['tiles'] <= off < O['tabtarget']:
        return 'tile%d.%d' % ((off - O['tiles']) // 16, (off - O['tiles']) % 16 // 4)
    if O['tabhot'] <= off < O['viewcopy']:
        return 'tabhot+%#x' % (off - O['tabhot'])
    best = '?'
    for o, n in _OBJ_NAMES:
        if o <= off:
            best = '%s+%#x' % (n, off - o)
    return best


def first_diff(a, b):
    return next(i for i in range(min(len(a), len(b))) if a[i] != b[i])


class Ctx:
    pass


def make_ctx(x, lib, sc, stats):
    ctx = Ctx()
    ctx.x, ctx.lib, ctx.stats, ctx.sc = x, lib, stats, sc
    ctx.nat = Native(lib)
    ctx.rows, ctx.first = list(sc['rows']), sc['first']
    ctx.phase, ctx.complete = {}, {}
    ctx.rng = random.Random(sc.get('seed', 1))
    ctx.clock = 100
    ctx.cand = 0
    ctx.cursor = [0x77, 0x88]
    ctx.view = (0, 0, 0, 0, 0, 0, 639, 479)
    ctx.stop = False
    ctx.skip_final = False
    ctx.tickno = 0
    ctx.body_zero = {}
    return ctx


def row_body(ctx, row):
    k = row - ctx.first
    return ctx.rows[k]['body'] if 0 <= k < len(ctx.rows) else None


def obj_row(ctx):
    r = s16(struct.unpack_from('<H', ctx.x.image(), O['row'])[0])
    return r if row_body(ctx, r) is not None else None


def active_ri(ctx):
    r = obj_row(ctx)
    return r if r is not None else ctx.first


def obj_state(ctx):
    img = ctx.x.image()
    g = lambda n: struct.unpack_from('<i', img, O[n])[0]  # noqa: E731
    gu = lambda n: struct.unpack_from('<I', img, O[n])[0]  # noqa: E731
    st = {n: g(n) for n in ('state', 'active', 'won', 'lost', 'redraw', 'flipback', 'hit', 'per_page', 'total', 'page', 'pairs', 'tries',
                            'needed', 'ids', 'slots')}
    st.update(first=gu('first'), second=gu('second'), deadline=gu('deadline'), cells=gu('cells'), used=gu('used'),
              row=s16(struct.unpack_from('<H', img, O['row'])[0]), slot=s16(struct.unpack_from('<H', img, O['slot'])[0]), img=img)
    return st


def cell_bytes(ctx):
    st = obj_state(ctx)
    if st['cells'] != MP_CELLS or not 0 < st['total'] <= MAX_CELLS:
        return None
    raw = ctx.x.rd(MP_CELLS, st['total'] * CELL_BYTES)
    return [struct.unpack_from('<iii', raw, CELL_BYTES * i) for i in range(st['total'])]


def compare_state(where, ctx):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    stats['state_compares'] += 1
    oi, ni = x.image(), nat.obj()
    stats['object_bytes'] += len(oi)
    if oi != ni:
        k = first_diff(oi, ni)
        raise Mismatch('%s object %s (+%#x): original %02x native %02x' % (where, field_of(k), k, oi[k], ni[k]))
    oc, ou = x.heap_blocks()
    nc, nu = nat.heap()
    if oc is not None:
        stats['cell_bytes'] += len(oc)
        if oc != nc[:len(oc)]:
            k = first_diff(oc, nc)
            raise Mismatch('%s cell array byte %d (cell %d): original %02x native %02x' % (where, k, k // 12, oc[k], nc[k]))
    if ou is not None:
        stats['id_bytes'] += len(ou)
        if ou != nu[:len(ou)]:
            k = first_diff(ou, nu)
            raise Mismatch('%s id table byte %d: original %02x native %02x' % (where, k, ou[k], nu[k]))
    for r in range(ctx.first, ctx.first + len(ctx.rows)):
        ob, init = x.body(r), ctx.rows[r - ctx.first]['body']
        stats['body_bytes'] += len(ob)
        nb = nat.body(r)
        if nb != init:
            raise Mismatch('%s native body of row %d changed' % (where, r))
        masked = lambda b: b[:B['shuffle']] + b[B['shuffle'] + 1:]  # noqa: E731
        if masked(ob) != masked(init):
            k = first_diff(masked(ob), masked(init))
            raise Mismatch('%s body of row %d +%#x: original %02x input %02x' % (where, r, k, ob[k], init[k]))
        if ob[B['shuffle']] not in (init[B['shuffle']], 0):
            raise Mismatch('%s body byte +0x346 is neither the input nor 0' % where)
        want = ctx.body_zero.get(r)
        if want is not None and ob[B['shuffle']] != want:
            raise Mismatch('%s body byte +0x346 is %d, expected %d' % (where, ob[B['shuffle']], want))
    if x.rs32(START_FLAG) != nat.lib.mpo_get_start_flag(nat.h):
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.rs32(START_FLAG), nat.lib.mpo_get_start_flag(nat.h)))
    occ, ncc = x.cells(), nat.cells()
    stats['cells'] += len(occ)
    if occ != ncc:
        k = first_diff(occ, ncc)
        raise Mismatch('%s scene-change cell %d: original %d native %d' % (where, k, occ[k], ncc[k]))
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
    cur = [x.rs32(G_CURSOR), x.rs32(G_CURSOR2)]
    if cur != ctx.cursor:
        raise Mismatch('%s cursor cells: original %s model %s' % (where, cur, ctx.cursor))
    x.check_unmodelled_writes(where)


def resync(ctx):
    """After a native-only refusal (the original was not run): the native side takes the original's state again."""
    x, nat = ctx.x, ctx.nat
    nat.set_obj(x.image())
    c, u = x.heap_blocks()
    oc, ou = nat.heap()
    nat.set_heap((c or b'') + oc[len(c or b''):], (u or b'') + ou[len(u or b''):])
    nat.set_cells(x.cells())
    nat.set_events(x.events_raw())
    nat.set_entries(x.entries())
    nat.lib.mpo_set_start_flag(nat.h, x.rs32(START_FLAG))


# ---------------------------------------------------------------------------------------------
# operations
# ---------------------------------------------------------------------------------------------
VIEWS = {'v0': (0, 0, 639, 479, 0, 0, 639, 479), 'v1': (13, 21, 653, 501, 5, 6, 600, 400), 'neg': (-40, -25, 600, 450, 10, 10, 500, 400),
         'tight': (0, 0, 60, 50, 60, 50, 300, 260), 'big': (300, 200, 1300, 900, 0, 0, 1000, 800),
         'edge': (0x7ffffff0, -0x7ffffff0, 100, 100, -50, -50, 700, 520)}
CLOCKS = {'low': 100, 'mid': 0x7fffff00, 'sign': 0x7ffffff0, 'wrap': 0xfffff000, 'top': 0xfffffff8}
CLK = {'ticks': 'clock'}


def make_queues(ctx, spec):
    """Tick values, busy answers and _rand values for one operation; both sides receive the same lists."""
    rng = ctx.rng
    img = ctx.x.image()
    d = struct.unpack_from('<I', img, O['deadline'])[0]
    policy = spec.get('ticks', 'clock')
    n = spec.get('count', 16)
    if policy == 'clock':
        ticks = [(ctx.clock + i) & M32 for i in range(n)]
        ctx.clock = (ctx.clock + rng.choice(spec.get('steps', (0, 1, 7, 100, 150, 300, 301, 599, 600, 601, 800, 1500, 2500, 9000)))) & M32
    elif policy == 'dl':
        offs = [-1000000, -1, 0, 1, 5, 99, 100, 101, 599, 600, 601, 0x80000000, -0x80000000, 0x7fffffff, -0x7fffffff]
        dl = rng.choice([d, d, ctx.clock])
        ticks = [(dl + rng.choice(offs)) & M32 for _ in range(n)]
        if rng.random() < 0.5:
            ticks = sorted(ticks, key=lambda v: (v - dl) & M32)
    elif policy == 'rand':
        ticks = [rng.choice([0, 1, d, d - 1, d + 1, 0x7fffffff, 0x80000000, 0xffffffff, rng.randrange(1 << 32)]) & M32 for _ in range(n)]
    else:
        ticks = list(policy) + [policy[-1]] * max(0, n - len(policy))
    b = spec.get('busy', 'rand')
    if b == 'zero':
        busy = [0] * 8
    elif b == 'one':
        busy = [1] * 8
    elif b == 'rand':
        busy = [rng.choice([0, 0, 1, 1, 1, 2, -1, 0x100, -0x80000000]) for _ in range(8)]
    else:
        busy = list(b) + [0] * 8
    rm = spec.get('rand', ctx.sc.get('rand', 'wide'))
    count = spec.get('rcount', 6000)
    if rm == 'wide':
        rands = [rng.randrange(32768) for _ in range(count)]
    elif rm == 'small':
        rands = [rng.randrange(200) for _ in range(count)]
    elif rm == 'seq':
        base = rng.randrange(32768)
        rands = [(base + i) & 0x7fff for i in range(count)]
    elif rm == 'mid':
        rands = [rng.randrange(8192, 8192 + 90) for _ in range(count)]
    else:
        rands = list(rm) + [rng.randrange(32768) for _ in range(count)]
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
    stats['rand_consumed'] += x.rand_i
    if nat.lib.mpo_bad_slot_calls(nat.h):
        raise Mismatch('%s native used an out-of-range slot' % where)


def note_effects(stats, seq):
    for t in seq:
        stats['effect_kinds'][KN[t[0]]] += 1


def check_entry(ctx, mode, row, last_row):
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


def expected_frees(pre):
    cp, up = struct.unpack_from('<II', pre, O['cells'])[0], struct.unpack_from('<I', pre, O['used'])[0]
    return [p for p in (cp, up) if p != 0]


def check_heap(where, ctx, step_phase, pre, post, mallocs, frees):
    """The allocator traffic of one handler visit or clear against the object images."""
    stats = ctx.stats
    if step_phase == 0:
        want_free = expected_frees(pre)
        total, ids = struct.unpack_from('<ii', post, O['total'])[0], struct.unpack_from('<i', post, O['ids'])[0]
        want_alloc = [total * CELL_BYTES, ids * 4]
    elif step_phase == 2:
        want_free, want_alloc = expected_frees(pre), []
    else:
        want_free, want_alloc = [], []
    if frees != want_free or mallocs != want_alloc:
        raise Mismatch('%s heap traffic: original frees %s mallocs %s, expected frees %s mallocs %s' % (
            where, [hex(f) for f in frees], mallocs, [hex(f) for f in want_free], want_alloc))
    stats['heap_frees'] += len(frees)
    stats['heap_mallocs'] += len(mallocs)


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
        x.in_dispatch = False
    stats['ticks'] += 1
    steps = list(x.steps)
    nfx = []
    last_row = first - 1
    for n_i, st in enumerate(steps):
        row, phase = st['row'], st['phase']
        bad = check_entry(ctx, mode_model, row, last_row)
        if bad:
            raise Mismatch('%s unexpected handler entry: %s' % (where, bad))
        last_row = row
        if ctx.phase.get(row, 0) != phase:
            raise Mismatch('%s row %d entered with phase %d, model %d' % (where, row, phase, ctx.phase.get(row, 0)))
        nfx.append((K['ENTER'], pad12((row, phase)), b''))
        x.rowbase = BODY_BASE + BODY_STRIDE * row
        status, why, log, res = nat.step(row, row, BODY_BASE + BODY_STRIDE * row, phase)
        nfx.extend(norm_nat(log))
        stats['steps'] += 1
        if status == 3 and phase in (1, 2) and st['obj_row'] != row:
            # a second row's phase 0 re-initialised the singleton; the original now runs this row's phase 1/2 on the other row's
            # object. Native refuses before any effect (phase 1 / 2 without phase 0): native-only refusal.
            if log:
                raise Mismatch('%s native refusal had effects' % where)
            stats['native_refusal_observed']['two-rows-active'] += 1
            ctx.stop = True
            ctx.skip_final = True
            return 0
        if fatal is not None and n_i == len(steps) - 1:
            if status != 4 or nat.consumed()[7] < 1:
                raise Mismatch('%s original reached fatal path %#x but native status %d (%s)' % (where, fatal, status, why))
            ctx.phase[row] = x.row_phase(row)
            continue
        if status != 0:
            raise Mismatch('%s native refused (status %d: %s) where the original ran' % (where, status, why))
        after = x.row_phase(row)
        want_phase = 0 if res[2] else res[0]
        if after != want_phase:
            raise Mismatch('%s row %d phase: original %d native %d (completed %d)' % (where, row, after, res[0], res[2]))
        if bool(res[1]) != (phase == 0):
            raise Mismatch('%s initialized flag %d for phase %d' % (where, res[1], phase))
        if bool(res[2]) != (phase == 2):
            raise Mismatch('%s completed flag %d for phase %d' % (where, res[2], phase))
        check_heap(where, ctx, phase, st['pre'], st['post'], st['mallocs'], st['frees'])
        pre_i = lambda n, im=st['pre']: struct.unpack_from('<i', im, O[n])[0]  # noqa: E731
        post_i = lambda n, im=st['post']: struct.unpack_from('<i', im, O[n])[0]  # noqa: E731
        if phase == 1:
            stats['inner_state_%d' % pre_i('state')] += 1
            stats['flipback_expired'] += 1 if pre_i('flipback') and not post_i('flipback') else 0
            stats['flipback_pending_kept'] += 1 if pre_i('flipback') and post_i('flipback') else 0
            stats['to_win_pick'] += 1 if post_i('state') == 1 and pre_i('state') == 0 else 0
            stats['to_lose_pick'] += 1 if post_i('state') == 2 and pre_i('state') == 0 else 0
        if phase == 2:
            stats['finish_won'] += 1 if pre_i('won') else 0
            stats['finish_lost'] += 1 if pre_i('lost') and not pre_i('won') else 0
            stats['finish_neither'] += 1 if not pre_i('lost') and not pre_i('won') else 0
        ctx.phase[row] = want_phase
        if phase == 0:
            if parse(rows[row - first]['body'])['pages'] == 1:
                ctx.body_zero[row] = 0
            stats['deals'] += 1
        if res[2]:
            ctx.complete[row] = 1 if rows[row - first].get('subtype', 1) == 1 else 0
            stats['completions'] += 1
            if not x.row_complete(row) == ctx.complete[row]:
                raise Mismatch('%s completion byte differs' % where)
        stats['phase%d_steps' % phase if phase in (0, 1, 2) else 'phaseX_steps'] += 1
        if nat.cells()[7] != 3:
            mode_model = nat.cells()[7]
    if fatal is not None:
        stats['fatal_paths_matched'] += 1
        ctx.stop = True
        ctx.skip_final = True
        if fatal != ctx.sc.get('expect_fatal'):
            raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
        compare_log(where, x.fx, nfx)
        return len(steps)
    compare_log(where, x.fx, nfx)
    stats['host_calls'] += len(nfx)
    note_effects(stats, x.fx)
    check_consumption(where, ctx)
    if not steps:
        stats['gate_closed_ticks'] += 1
    compare_state(where, ctx)
    return len(steps)


def body_handle_of_obj(ctx):
    img = ctx.x.image()
    row = s16(struct.unpack_from('<H', img, O['row'])[0])
    return struct.unpack('<I', ctx.x.rd(0x5bb5e5 + row * 0x8d, 4))[0], struct.unpack('<I', ctx.x.rd(0x5bb632 + row * 0x8d, 4))[0]


def do_pointer(ctx, where, px, py):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    ri = active_ri(ctx)
    px, py = s16(px), s16(py)
    before = [x.rs32(a) for a in (G_CAND, G_CURSOR, G_CURSOR2, G_E2_SRC, G_E2_REC, G_E2_FLAG)]
    x.fx = []
    ret = x.run_op(0x47b4aa, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000], OBJ)
    after = [x.rs32(a) for a in (G_CAND, G_CURSOR, G_CURSOR2, G_E2_SRC, G_E2_REC, G_E2_FLAG)]
    status, out = nat.pointer(ri, px, py)
    if status != 0:
        raise Mismatch('%s native pointer status %d' % (where, status))
    if x.fx:
        raise Mismatch('%s the original pointer receiver made host calls' % where)
    nhit, ncand, wrote, ncur, nflag = out
    if ret != nhit:
        raise Mismatch('%s pointer return: original %d native %d' % (where, ret, nhit))
    if wrote:
        want = [ncand, ncur, nflag, s32(MARK_CURSOR_SRC), 0x5b161c, 1]
        if after != want:
            raise Mismatch('%s cursor/candidate: original %s native %s' % (where, [hex(v & M32) for v in after], [hex(v & M32) for v in want]))
        ctx.cand = after[0]
        ctx.cursor = [after[1], after[2]]
        stats['pointer_hits'] += 1
        for off, v in ((8, after[3]), (0xc, after[4]), (0x14, after[5])):
            nat.lib.mpo_set_entry_u32(nat.h, 2, off, v & M32)
        stats['cand_%x' % (ncand & 0xffff)] += 1
    else:
        if after != before:
            raise Mismatch('%s original wrote cursor/candidate %s, native did not' % (where, after))
        if ncand != -1:
            raise Mismatch('%s native candidate %d without a write' % (where, ncand))
    stats['pointer_moves'] += 1
    compare_state(where, ctx)


def click_refusal(ctx, st, rp, cand):
    """Where the original indexes memory the native kernel refuses."""
    if not (st['active'] and rp == 1 and st['state'] == 0):
        return None
    pages = parse(ctx.rows[0]['body'])['pages'] if False else None
    body = row_body(ctx, st['row'])
    if body is None:
        return None
    pages = struct.unpack_from('<i', body, B['pages'])[0]
    if cand == CAND_TAB:
        return 'tab-index' if not 0 <= st['hit'] < pages else None
    if cand == CAND_TILE:
        idx = st['page'] * st['per_page'] + st['hit']
        return 'tile-index' if not 0 <= idx < st['total'] else None
    return None


def do_click(ctx, where, cand=None, spec=CLK):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    if cand is not None:
        x.w32(G_CAND, cand)
        ctx.cand = s32(cand)
    st = obj_state(ctx)
    ri = active_ri(ctx)
    bh, rp = body_handle_of_obj(ctx)
    acts = bool(st['active'] and rp == 1 and st['state'] == 0 and ctx.cand in (CAND_TAB, CAND_TILE))
    why = click_refusal(ctx, st, rp, ctx.cand)
    if why:
        status, log = nat.click(ri, bh, rp, ctx.cand)
        if status != 5:
            raise Mismatch('%s %s: expected MP_ERR_BOUNDS from the native click, got %d' % (where, why, status))
        stats['native_refusal_observed'][why + ':click'] += 1
        resync(ctx)
        return
    set_queues(ctx, spec)
    x.rowbase = bh
    x.run_op(0x47b767, [], OBJ)
    status, log = nat.click(ri, bh, rp, ctx.cand)
    if status != 0:
        raise Mismatch('%s native click status %d' % (where, status))
    compare_log(where, x.fx, log)
    check_heap(where, ctx, 1, st['img'], st['img'], x.loose['mallocs'], x.loose['frees'])
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    check_consumption(where, ctx)
    stats['clicks'] += 1
    stats['clicks_acting' if acts else 'clicks_ignored'] += 1
    stats['click_cand_%x' % (ctx.cand & 0xffff)] += 1
    compare_state(where, ctx)


def do_render(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    st = obj_state(ctx)
    ri = active_ri(ctx)
    objimg = st['img']
    x.blits = []
    x.fx = []
    x.call(0x47d24e, [], 0)
    nat.clear()
    status, plan = nat.plan(ri)
    log = nat.log()
    if status != 0:
        raise Mismatch('%s native plan status %d' % (where, status))
    stats['render_calls'] += 1
    bl = x.blits
    if bool(plan['valid']) != bool(st['active']) or plan['count'] != len(bl):
        raise Mismatch('%s blit count original %d plan valid %d count %d' % (where, len(bl), plan['valid'], plan['count']))
    slot = st['slot']
    entry_surface = struct.unpack_from('<I', x.entries(), slot * STRIDE + 8)[0] if 0 <= slot < NENT else None
    for i, b in enumerate(bl):
        p = plan['blits'][i]
        stats['blit_calls'] += 1
        if b['src'] != p['src'] or b['dst'] != p['dst']:
            raise Mismatch('%s blit %d: original %s -> %s native %s -> %s' % (where, i, b['src'], b['dst'], p['src'], p['dst']))
        want = MARK_SAVED if p['src_kind'] == 0 else entry_surface
        if b['src_surface'] != want or b['dst_surface'] != MARK_BACK or b['tag_ptr'] != BLIT_LABELS[p['label']]:
            raise Mismatch('%s blit %d surfaces/label original %#x/%#x/%#x plan kind %d label %d' % (
                where, i, b['src_surface'], b['dst_surface'], b['tag_ptr'], p['src_kind'], p['label']))
        if p['src_kind'] == 1 and b['src_surface'] != struct.unpack_from('<I', objimg, O['surface'])[0]:
            raise Mismatch('%s blit %d overlay surface differs from the object surface' % (where, i))
        stats['blit_label_%d' % p['label']] += 1
    compare_log(where, x.fx, log)
    compare_state(where, ctx)


def do_cleanup(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    pre = x.image()
    x.fx = []
    x.run_op(0x47b321, [], OBJ)
    status, log = nat.simple(nat.lib.mpo_cleanup)
    if status != 0:
        raise Mismatch('%s native cleanup status %d' % (where, status))
    compare_log(where, x.fx, log)
    check_heap(where, ctx, 2, pre, pre, x.loose['mallocs'], x.loose['frees'])
    stats['cleanups'] += 1
    stats['host_calls'] += len(log)
    note_effects(stats, x.fx)
    compare_state(where, ctx)


def do_invalidate(ctx, where):
    x, nat, stats = ctx.x, ctx.nat, ctx.stats
    slot = s16(struct.unpack_from('<H', x.image(), O['slot'])[0])
    if 0 <= slot < NENT:  # the engine clears the redraw request after drawing; make the request observable
        x.w32(ENTRY + slot * STRIDE + 0x14, 0)
        nat.lib.mpo_set_entry_u32(nat.h, slot, 0x14, 0)
    x.fx = []
    x.run_op(0x47b3bc, [], OBJ)
    status, log = nat.simple(nat.lib.mpo_invalidate)
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
    ctx.x.take_snapshot()
    ctx.stats['pokes'] += 1
    compare_state(where, ctx)


def sync_events(ctx):
    ctx.nat.set_events(ctx.x.events_raw())


def set_view(ctx, v):
    ctx.view = v
    for a, c in zip(G_VIEW + G_CLIP, v):
        ctx.x.w32(a, c)
    ctx.nat.set_view(v)
    ctx.x.take_snapshot()


def set_texts(ctx, texts):
    ctx.x.texts = dict(texts)
    ctx.nat.set_texts(texts)


def set_captions(ctx, v):
    ctx.x.w32(G_CAPTIONS, v)
    ctx.nat.lib.mpo_set_captions(ctx.nat.h, v)
    ctx.x.take_snapshot()


# ---------------------------------------------------------------------------------------------
# the player
# ---------------------------------------------------------------------------------------------
def center(r):
    return (r[0] + r[2]) // 2, (r[1] + r[3]) // 2


def info_of(ctx):
    st = obj_state(ctx)
    body = row_body(ctx, st['row']) if st['row'] >= 0 else None
    if body is None:
        body = ctx.rows[0]['body']
    return st, parse(body)


def tile_points(info, rng):
    pts = []
    for r in info['tiles']:
        pts.append(center(r))
        l, t, rr, b = r
        pts += [(l + 3, t + 3), (rr - 3, b - 3), (l + 2, t + 3), (l + 3, t + 2), (rr - 2, b - 3), (rr - 3, b - 2), (l, t), (rr, b),
                (rr - 3, t + 3), (l + 3, b - 3)]
    return pts


def play(ctx, where, n, policy):
    rng, x, stats = ctx.rng, ctx.x, ctx.stats
    for step in range(n):
        if ctx.stop:
            return
        st, info = info_of(ctx)
        w = '%s play %d' % (where, step)
        r = rng.random()
        solve, miss, chaos = policy.get('solve', 0.3), policy.get('miss', 0.1), policy.get('chaos', 0.3)
        cells = cell_bytes(ctx) if st['active'] else None
        if r < 0.10:
            do_tick(ctx, w + ' tick', {'ticks': rng.choice(['clock', 'dl', 'dl', 'rand'])})
        elif r < 0.10 + solve and cells and not st['won'] and not st['lost']:
            play_pair(ctx, w, st, info, cells, same=True)
        elif r < 0.10 + solve + miss and cells and not st['won'] and not st['lost']:
            play_pair(ctx, w, st, info, cells, same=False)
        elif r < 0.10 + solve + miss + chaos:
            k = rng.random()
            pts = tile_points(info, rng)
            if k < 0.35 and pts:
                do_pointer(ctx, w + ' ptr-tile', *rng.choice(pts))
            elif k < 0.5 and info['tabs']:
                hot = info['hot'][st['page'] if 0 <= st['page'] < 3 else 0]
                j = rng.randrange(3)
                l, t, rr, b = hot[j]
                do_pointer(ctx, w + ' ptr-tab', *rng.choice([center(hot[j]), (l, t), (rr, b), (l - 1, t), (rr + 1, b), (l, b + 1)]))
            elif k < 0.7:
                do_pointer(ctx, w + ' ptr-any', rng.randrange(-20, 700), rng.randrange(-20, 520))
            elif k < 0.9:
                do_click(ctx, w + ' click', None, CLK)
            elif k < 0.95:
                do_click(ctx, w + ' click-cand', rng.choice([CAND_TAB, CAND_TILE, 0x2767, 0x276a, 0, -1, 0x12768]), CLK)
            elif k < 0.98:
                do_render(ctx, w + ' render')
            else:
                do_invalidate(ctx, w + ' invalidate')
        else:
            do_click(ctx, w + ' click', None, CLK)


def play_pair(ctx, w, st, info, cells, same):
    rng = ctx.rng
    page_cells = [st['page'] * st['per_page'] + j for j in range(st['per_page']) if 0 <= st['page'] * st['per_page'] + j < len(cells)]
    free = [c for c in page_cells if cells[c][1] == 0 and cells[c][2] == 0]
    if not free:
        return
    a = rng.choice(free)
    others = [c for c in free if c != a and ((cells[c][0] == cells[a][0]) == same)]
    if not others:
        return
    b = rng.choice(others)
    first_page, first_pp = st['page'], st['per_page']
    for c in (a, b):
        j = c - first_page * first_pp
        if not 0 <= j < len(info['tiles']):
            return
        do_pointer(ctx, w + ' pair-ptr', *center(info['tiles'][j]))
        do_click(ctx, w + ' pair-click', None, CLK)
        if ctx.stop:
            return
        st = obj_state(ctx)
        if st['flipback'] and rng.random() < 0.3:
            break


def run_until(ctx, where, mx, until='done', spec=None):
    for i in range(mx):
        ctx.tickno += 1
        do_tick(ctx, '%s run %d' % (where, i), spec or {'ticks': 'dl'})
        if ctx.stop:
            return
        if until == 'done' and all(ctx.complete.get(r, 0) or False for r in range(ctx.first, ctx.first + len(ctx.rows))):
            return


def macro_win(ctx, where, miss=0.2, limit=400):
    """Flip matching pairs (some mismatches first) until the puzzle is won or the object is gone."""
    rng, x = ctx.rng, ctx.x
    for step in range(limit):
        if ctx.stop:
            return
        st, info = info_of(ctx)
        if not st['active'] or st['won'] or st['lost']:
            return
        cells = cell_bytes(ctx)
        if cells is None:
            return
        w = '%s win %d' % (where, step)
        if st['flipback']:
            do_tick(ctx, w + ' flip-back', {'ticks': 'dl'})
            continue
        remaining = [c for c in range(len(cells)) if cells[c][2] == 0]
        if not remaining:
            return
        on_page = [c for c in remaining if st['page'] * st['per_page'] <= c < (st['page'] + 1) * st['per_page']]
        if not on_page:
            if not info['tabs']:
                return
            tab = rng.randrange(3)
            do_pointer(ctx, w + ' tab-ptr', *center(info['hot'][st['page']][tab]))
            do_click(ctx, w + ' tab-click', None, CLK)
            continue
        play_pair(ctx, w, st, info, cells, same=rng.random() >= miss)


def macro_lose(ctx, where, limit=400):
    rng = ctx.rng
    for step in range(limit):
        if ctx.stop:
            return
        st, info = info_of(ctx)
        if not st['active'] or st['won'] or st['lost']:
            return
        cells = cell_bytes(ctx)
        if cells is None:
            return
        w = '%s lose %d' % (where, step)
        if st['flipback']:
            do_tick(ctx, w + ' flip-back', {'ticks': 'dl'})
            continue
        play_pair(ctx, w, st, info, cells, same=False)
        if st['flipback'] == 0 and not st['active']:
            return
        if step > 6 and rng.random() < 0.1:
            do_tick(ctx, w + ' tick', {'ticks': 'clock'})


# ---------------------------------------------------------------------------------------------
# scenario execution
# ---------------------------------------------------------------------------------------------
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


def seed_world(ctx, sc):
    x, nat = ctx.x, ctx.nat
    x.wr(G_MODE, struct.pack('<i', sc.get('mode', 3)))
    for idx, v in sc.get('events', {}).items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    sync_events(ctx)
    seeds = [sc.get('scene', 0x11111111), 0x2222, -0x3333, 0x4444, 0x55555555, 0x66666666 & 0x7fffffff, 0x77777777]
    for (a, sz), v in zip(CELLS, seeds):
        x.wr(a, struct.pack('<i', v)[:sz] if sz == 4 else struct.pack('<h', v & 0x7fff))
    nat.set_cells(x.cells())
    x.w32(START_FLAG, 5)
    nat.lib.mpo_set_start_flag(nat.h, 5)
    x.w32(G_CAND, 0)
    x.w32(G_CURSOR, 0x77)
    x.w32(G_CURSOR2, 0x88)
    x.handle = sc.get('handle', 0x7001)
    nat.lib.mpo_set_handle(nat.h, x.handle)
    set_view(ctx, VIEWS[sc.get('view', 'v0')] if isinstance(sc.get('view', 'v0'), str) else sc['view'])
    set_captions(ctx, sc.get('captions', 1))
    set_texts(ctx, sc.get('texts', {}))
    for s in sc.get('busy_slots', []):
        x.w32(ENTRY + s * STRIDE + 0x18, 1)
    nat.set_entries(x.entries())


def run_scenario_inner(x, lib, sc, stats):
    x.hard_reset()
    x.expect_fatal = sc.get('expect_fatal')
    ctx = make_ctx(x, lib, sc, stats)
    nat = ctx.nat
    try:
        x.install_rows(ctx.rows, ctx.first)
        for r in range(ctx.first):
            ctx.complete[r] = 1
        for k, spec in enumerate(ctx.rows):
            nat.set_body(ctx.first + k, spec['body'])
            rc, why = nat.validate(spec['body'])
            if rc != 0 and not sc.get('invalid_ok'):
                raise OracleError('scenario body is refused by the native validator: %s' % why)
        seed_world(ctx, sc)
        # the power-on constructor: the original 0x47b200 against mp_object_reset
        oi, ni = x.image(), nat.obj()
        if oi != ni:
            k = first_diff(oi, ni)
            raise Mismatch('power-on reset differs at %s (+%#x): original %02x native %02x' % (field_of(k), k, oi[k], ni[k]))
        x.take_snapshot()
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
                x.take_snapshot()
            elif kind == 'mode':
                x.wr(G_MODE, struct.pack('<i', act[1]))
                c = nat.cells()
                c[7] = act[1]
                nat.set_cells(c)
                x.take_snapshot()
            elif kind == 'flag':
                x.w32(START_FLAG, act[1])
                nat.lib.mpo_set_start_flag(nat.h, act[1])
                x.take_snapshot()
            elif kind == 'captions':
                set_captions(ctx, act[1])
            elif kind == 'texts':
                set_texts(ctx, act[1])
            elif kind == 'events':
                for idx, v in act[1].items():
                    x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                sync_events(ctx)
                x.take_snapshot()
            elif kind == 'poke':
                do_poke(ctx, where, act[1])
            elif kind == 'ptr':
                do_pointer(ctx, where, *act[1:])
            elif kind == 'click':
                do_click(ctx, where, *act[1:])
            elif kind == 'invalidate':
                do_invalidate(ctx, where)
            elif kind == 'cleanup':
                do_cleanup(ctx, where)
            elif kind == 'revive':  # the scene is entered again: every row starts over
                for r in range(ctx.first, ctx.first + len(ctx.rows)):
                    x.wr(ROWS + r * ROW + COMPLETE_OFF, b'\0')
                    x.w32(ROWS + r * ROW + PHASE_OFF, 0)
                    ctx.complete[r] = 0
                    ctx.phase[r] = 0
                x.take_snapshot()
            elif kind == 'render':
                do_render(ctx, where)
            elif kind == 'tick':
                ctx.tickno += 1
                do_tick(ctx, where, act[1] if len(act) > 1 else CLK)
            elif kind == 'run':
                run_until(ctx, where, act[2], act[1] if isinstance(act[1], str) else 'done', act[3] if len(act) > 3 else None)
            elif kind == 'play':
                play(ctx, where, act[1], act[2] if len(act) > 2 else {})
            elif kind == 'win':
                macro_win(ctx, where, **(act[1] if len(act) > 1 else {}))
            elif kind == 'lose':
                macro_lose(ctx, where)
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
# synthetic bodies
# ---------------------------------------------------------------------------------------------
SOUND_NAMES = [b'NO SOUND', b'NO SOUND', b'no sound', b'No Sound', b'nO sOuNd', b'NO SOUNDS', b'NO SOUN', b'NO SOUND ', b'S%d', b'S%d', b'S%d',
               b'S%d', b'WAV_%d']
CHANNELS = [-5, -1, 0, 1, 3, 7, 17, 23, 255, 4096, 32767, -32768]
DELAYS = [0, 1, 100, 600, 600, 5000, 100000, 0x7fffffff, -1, -600, -0x80000000]
TRIES = [0, 1, 2, 3, 5, 10, 25, 40, 60]
SCENES = [9999, 9999, 1207, 4377, 0, -1, 32767, -32768]
FLAGS = [-1, -1, 0, 5, 1984, 1988, 4095, 255]
START_FLAGS = [0, 1, 1, 2, -1, 255]


def rnd_text(rng, n):
    return bytes(rng.choice(b'abcdefghijklmnopqrstuvwxyz ABCDEFGH.,!') for _ in range(n))


def rand_block(rng):
    return block_bytes(rng.choice(SCENES), tuple(rng.randrange(-32768, 32768) for _ in range(3)),
                       tuple(rng.randrange(-(1 << 31), 1 << 31) for _ in range(3)), rng.choice(START_FLAGS), rng.choice(FLAGS),
                       rng.choice([0, 1, 7, -1, 32767, -32768]))


def sound_list(rng, count, mode):
    """`mode`: 'real' every record plays, 'mixed', 'none' every record is a NO SOUND spelling."""
    out = []
    for i in range(count):
        if mode == 'real':
            name = b'SND%d' % i
        elif mode == 'none':
            name = rng.choice([b'NO SOUND', b'no sound', b'No Sound'])
        else:
            name = rng.choice(SOUND_NAMES)
            if b'%d' in name:
                name = name % i
        key = rng.choice([b'', b'', b'KEY%d' % rng.randrange(4), b'KEY%d' % rng.randrange(4)])
        text = rng.choice([b'', rnd_text(rng, rng.randrange(1, 40)), rnd_text(rng, rng.randrange(40, 98))])
        out.append((name, rng.choice(CHANNELS), key, text))
    return out


def make_body(rng, pages=None, cols=None, rows=None, shuffle=None, slot_cols=None, slot_rows=None, tabs=None, tries=None, delay=None,
              pct_ids=None, pct_needed=None, needed=None, recenter=None, tile=None, snd='mixed', win=None, lose=None, garbage=True,
              name=b'MEMSRC', gap=8):
    b = bytearray(rng.randbytes(BODY_LEN)) if garbage else bytearray(BODY_LEN)
    pages = pages if pages is not None else rng.choice([1, 1, 2, 3])
    shuffle = shuffle if shuffle is not None else rng.choice([0, 0, 1, 255])
    if cols is None or rows is None:
        while True:
            cols, rows = rng.randint(1, 6), rng.randint(1, 4)
            tot = cols * rows * pages
            if (tot % 2 == 0) if (shuffle and pages > 1) else ((cols * rows) % 2 == 0):
                break
    per_page = cols * rows
    put_name(b, B['name'], name, 0x21, rng if garbage else None)
    tw, th = tile if tile else (rng.choice([6, 7, 9, 20, 40, 60]), rng.choice([6, 7, 9, 20, 40, 60]))
    for i in range(24):
        if i < per_page:
            l, t = 20 + (i % cols) * (tw + gap) + rng.choice([0, 0, 0, 1, -1]), 40 + (i // cols) * (th + gap)
            r = (l, t, l + tw, t + th)
        else:
            r = tuple(rng.randrange(-100, 700) for _ in range(4))
        b[B['tiles'] + 16 * i:B['tiles'] + 16 * i + 16] = rect_bytes(r)
    for i in range(12):
        x0, y0 = rng.randrange(0, 600), rng.randrange(0, 400)
        b[B['pictures'] + 16 * i:B['pictures'] + 16 * i + 16] = rect_bytes((x0, y0, x0 + rng.randrange(0, 80), y0 + rng.randrange(0, 80)))
    for i in range(3):
        x0, y0 = rng.randrange(0, 600), rng.randrange(0, 400)
        b[B['tab_src'] + 16 * i:B['tab_src'] + 16 * i + 16] = rect_bytes((x0, y0, x0 + 30, y0 + 20))
    b[B['tab_target']:B['tab_target'] + 16] = rect_bytes((rng.randrange(0, 600), rng.randrange(0, 20), rng.randrange(600, 640), 40))
    for p in range(3):
        for j in range(3):
            if rng.random() < 0.3:    # on top of the tiles: the tab test wins
                l, t = 20 + rng.randrange(0, 80), 40 + rng.randrange(0, 60)
            else:
                l, t = 500 + 40 * j + rng.choice([0, 0, 3]), 5 + 25 * p
            b[B['tab_hot'] + 0x30 * p + 0x10 * j:B['tab_hot'] + 0x30 * p + 0x10 * j + 16] = rect_bytes((l, t, l + rng.choice([0, 20, 34]), t + 20))
    struct.pack_into('<i', b, B['delay'], delay if delay is not None else rng.choice(DELAYS))
    struct.pack_into('<i', b, B['pct_ids'], pct_ids if pct_ids is not None else rng.choice([-1, -50, 0, 1, 25, 50, 75, 100, 150, 300]))
    struct.pack_into('<i', b, B['pct_needed'], pct_needed if pct_needed is not None else rng.choice([-1, -1, 0, 10, 50, 100, 100, 200, 300]))
    struct.pack_into('<i', b, B['needed'], needed if needed is not None else rng.randrange(-5, 40))
    struct.pack_into('<i', b, B['tries'], tries if tries is not None else rng.choice(TRIES))
    b[B['recenter']] = recenter if recenter is not None else rng.choice([0, 1, 1, 2, 255])
    b[B['shuffle']] = shuffle
    struct.pack_into('<i', b, B['pages'], pages)
    struct.pack_into('<i', b, B['cols'], cols)
    struct.pack_into('<i', b, B['rows'], rows)
    struct.pack_into('<i', b, B['slot_cols'], slot_cols if slot_cols is not None else rng.randint(1, 6))
    struct.pack_into('<i', b, B['slot_rows'], slot_rows if slot_rows is not None else rng.randint(1, 2))
    b[B['tabs']] = tabs if tabs is not None else rng.choice([0, 1, 1, 3])
    modes = snd if isinstance(snd, dict) else {}
    for base, count in (('flip1', 1), ('flip2', 1), ('match', 5), ('wrong', 10), ('win', 10)):
        mode = modes.get(base, snd if isinstance(snd, str) else 'mixed')
        for i, rec in enumerate(sound_list(rng, count, mode)):
            put_sound(b, B[base] + SND * i, *rec, rng)
    b[B['block_win']:B['block_win'] + 26] = win if win is not None else rand_block(rng)
    b[B['block_lose']:B['block_lose'] + 26] = lose if lose is not None else rand_block(rng)
    return bytes(b)


def rand_texts(rng):
    out = {}
    for d in range(4):
        r = rng.random()
        if r < 0.3:
            continue
        out[b'KEY%d' % d] = rnd_text(rng, rng.choice([0, 1, 20, 90, 97])) if r < 0.9 else rnd_text(rng, 40001)
    return out


def R(body, subtype=1, tail=b''):
    return dict(body=body, subtype=subtype, tail=tail)


def S(scs, sid, rows, actions, group, **kw):
    sc = dict(id=sid, rows=rows, actions=actions, group=group, quick=kw.pop('quick', False), first=kw.pop('first', 0))
    sc.update(kw)
    scs.append(sc)
    return sc


def scenario_list(seed=0x60ee):
    scs = []
    rng = random.Random(seed)
    real = corpus_rows()
    r0, r1 = dict(real[0]), dict(real[1])
    # ---- the two real rows
    S(scs, 'real0:win', [R(r0['body'], r0['subtype'], r0['tail'])], [('tick',), ('win', {'miss': 0.15}), ('run', 'done', 40)], 'real',
      quick=True, seed=11, texts={}, captions=1)
    S(scs, 'real1:lose', [R(r1['body'], r1['subtype'], r1['tail'])], [('tick',), ('lose',), ('run', 'done', 40)], 'real', quick=True, seed=12,
      events={0: 2}, view='v1')
    for k in range(6):
        row = real[k % 2]
        S(scs, 'real%d:chaos%d' % (k % 2, k), [R(row['body'], row['subtype'], row['tail'])],
          [('tick',), ('play', 120, {'solve': 0.35, 'miss': 0.15, 'chaos': 0.3}), ('win', {'miss': 0.3}), ('run', 'done', 40)], 'real',
          seed=20 + k, events={0: 2 * (k % 2)}, view=rng.choice(list(VIEWS)), captions=rng.choice([0, 1]), rand=rng.choice(['wide', 'small', 'seq']))
    S(scs, 'real:both-rows', [R(r0['body'], 1, r0['tail']), R(r1['body'], 1, r1['tail'])],
      [('tick',), ('win', {'miss': 0.1}), ('run', 'done', 30), ('events', {0: 2}), ('tick',), ('play', 60, {'solve': 0.4}), ('win',), ('run', 'done', 30)],
      'real', seed=31)
    # ---- one-page, multi-page, shuffle-all, tabs
    S(scs, 'syn:onepage-win', [R(make_body(rng, pages=1, cols=4, rows=3, tabs=0, tile=(40, 30), tries=40, pct_needed=100, snd='real'))],
      [('tick',), ('win', {'miss': 0.2}), ('run', 'done', 40)], 'synthetic', quick=True, seed=41, captions=1,
      texts={b'KEY0': b'first text', b'KEY1': b'second text', b'KEY2': b'third', b'KEY3': b'4'})
    S(scs, 'syn:tabs-pages3', [R(make_body(rng, pages=3, cols=3, rows=2, shuffle=0, tabs=1, tile=(40, 30), tries=60, pct_needed=100))],
      [('tick',), ('play', 100, {'solve': 0.3, 'miss': 0.1, 'chaos': 0.4}), ('win', {'miss': 0.2}), ('run', 'done', 40)], 'synthetic',
      quick=True, seed=42)
    S(scs, 'syn:shuffle-all', [R(make_body(rng, pages=2, cols=3, rows=3, shuffle=1, tabs=1, tile=(40, 30), tries=60, pct_needed=100))],
      [('tick',), ('play', 100, {'solve': 0.3, 'miss': 0.1, 'chaos': 0.4}), ('win', {'miss': 0.2}), ('run', 'done', 40)], 'synthetic', seed=43)
    S(scs, 'syn:shuffle-all-255', [R(make_body(rng, pages=3, cols=1, rows=4, shuffle=255, tabs=1, tile=(40, 30), tries=60, pct_needed=100))],
      [('tick',), ('play', 100, {'solve': 0.3, 'miss': 0.1, 'chaos': 0.4}), ('win',), ('run', 'done', 40)], 'synthetic', seed=44)
    S(scs, 'syn:shuffle-byte-onepage', [R(make_body(rng, pages=1, cols=2, rows=2, shuffle=1, tabs=0, tile=(40, 30)))],
      [('tick',), ('play', 40, {}), ('run', 'done', 30)], 'synthetic', seed=45)
    S(scs, 'syn:one-tile-pair', [R(make_body(rng, pages=1, cols=1, rows=2, tabs=0, tile=(40, 30), slot_cols=1, slot_rows=1, pct_ids=100))],
      [('tick',), ('win',), ('run', 'done', 30)], 'synthetic', seed=46)
    S(scs, 'syn:max-board', [R(make_body(rng, pages=3, cols=6, rows=4, shuffle=1, tabs=1, tile=(30, 20), tries=60, pct_needed=100,
                                          slot_cols=6, slot_rows=2, pct_ids=300))],
      [('tick',), ('play', 60, {'solve': 0.5}), ('run', 'done', 20)], 'synthetic', seed=47, rand='wide')
    # ---- clamps of the id count and the pairs needed
    for k, (pi, pn, nd, sc_, sr_) in enumerate(((-1, -1, -5, 6, 2), (0, 0, 0, 1, 1), (1, 1, 2, 3, 2), (25, 10, 3, 6, 2), (50, 50, 7, 5, 2),
                                                (100, 100, 40, 6, 2), (300, 300, 99, 6, 2), (150, -1, 40, 2, 1), (33, 33, 1, 4, 1))):
        S(scs, 'syn:clamp%d' % k, [R(make_body(rng, pages=rng.choice([1, 2]), cols=4, rows=2, shuffle=rng.choice([0, 1]), tabs=1, tile=(40, 30),
                                               pct_ids=pi, pct_needed=pn, needed=nd, slot_cols=sc_, slot_rows=sr_, tries=30, snd='real'))],
          [('tick',), ('win', {'miss': 0.1}), ('run', 'done', 30)], 'synthetic', seed=50 + k)
    # ---- the deadline arithmetic: delays and clocks around the 32-bit wrap
    for k, (delay, clock) in enumerate(((600, 'wrap'), (0x7fffffff, 'sign'), (-1, 'top'), (-0x80000000, 'mid'), (5000, 'top'), (0, 'low'),
                                         (100, 'wrap'))):
        S(scs, 'syn:deadline%d' % k, [R(make_body(rng, pages=1, cols=2, rows=3, tabs=0, tile=(40, 30), delay=delay, tries=60, snd='real'))],
          [('clock', clock), ('tick',), ('play', 80, {'solve': 0.2, 'miss': 0.4, 'chaos': 0.2}), ('run', 'done', 30)], 'synthetic', seed=60 + k)
    # ---- sound lists: every spelling of NO SOUND, all NO SOUND, captions with and without AUTOTEXT
    for k, mode in enumerate(('none', 'mixed', 'real', {'win': 'none', 'wrong': 'real', 'match': 'none'}, {'win': 'real', 'wrong': 'none'},
                              {'flip1': 'none', 'flip2': 'none', 'win': 'mixed', 'wrong': 'mixed', 'match': 'mixed'})):
        S(scs, 'syn:sounds%d' % k, [R(make_body(rng, pages=1, cols=3, rows=2, tabs=0, tile=(40, 30), snd=mode, tries=rng.choice([3, 40])))],
          [('tick',), ('play', 60, {'solve': 0.3, 'miss': 0.2}), ('win', {'miss': 0.1}), ('lose',), ('run', 'done', 40)], 'synthetic', seed=70 + k,
          captions=rng.choice([0, 1]), texts=rand_texts(rng), busy_all=True)
    S(scs, 'syn:long-autotext', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), snd='real', tries=3))],
      [('tick',), ('play', 40, {'solve': 0.3, 'miss': 0.3}), ('run', 'done', 30)], 'synthetic', seed=80, captions=1,
      texts={b'KEY0': rnd_text(rng, 40001), b'KEY1': rnd_text(rng, 40001), b'KEY2': rnd_text(rng, 97), b'KEY3': rnd_text(rng, 97)})
    # ---- finish blocks: scene 9999 / other, start flag, event flag
    for k, (win, lose) in enumerate(((block_bytes(9999, flag=-1), block_bytes(9999, flag=-1)),
                                     (block_bytes(1207, (1, -2, 3), (4, -5, 6), 1, 77, -9), block_bytes(4377, (7, 8, 9), (10, 11, 12), 0, 4095, 5)),
                                     (block_bytes(-1, (0, 0, 0), (0, 0, 0), 2, 0, 1), block_bytes(0, (-1, -1, -1), (-1, -1, -1), -1, -1, 0)),
                                     (block_bytes(9999, flag=3, value=-4), block_bytes(32767, (32767,) * 3, (0x7fffffff,) * 3, 255, 1988, 32767)))):
        for outcome in ('win', 'lose'):
            S(scs, 'syn:block%d-%s' % (k, outcome), [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), win=win, lose=lose, tries=4,
                                                                  snd='none'))],
              [('tick',), (outcome, {}) if outcome == 'win' else ('lose',), ('run', 'done', 30)], 'synthetic', seed=90 + k, scene=2305,
              events={77: 99})
    # ---- repeated visits: subtype 2 / 0 rows start over after every completion; cleanup + revive
    for k, sub in enumerate((2, 0)):
        S(scs, 'syn:repeat-sub%d' % sub, [R(make_body(rng, pages=1, cols=2, rows=2, tabs=1, tile=(40, 30), tries=5, snd='real'), sub)],
          [('tick',), ('win',), ('run', 'done', 6), ('tick',), ('lose',), ('run', 'done', 6), ('tick',), ('play', 30, {}), ('tick',)],
          'synthetic', seed=100 + k, captions=1, texts=rand_texts(rng))
    S(scs, 'syn:cleanup-revive', [R(make_body(rng, pages=2, cols=2, rows=2, shuffle=1, tabs=1, tile=(40, 30), tries=9, snd='real'))],
      [('tick',), ('play', 25, {'solve': 0.4}), ('cleanup',), ('render',), ('ptr', 50, 50), ('click',), ('invalidate',), ('revive',), ('tick',),
       ('play', 25, {'solve': 0.4}), ('win',), ('run', 'done', 20)], 'synthetic', seed=110)
    S(scs, 'syn:two-rows', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30))), R(make_body(rng, pages=1, cols=2, rows=1, tabs=0,
                                                                                                       tile=(40, 30)))],
      [('tick',), ('tick',)], 'synthetic', seed=111)
    S(scs, 'syn:dummy-first-row', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=1, tile=(40, 30), tries=9, snd='real'))],
      [('tick',), ('win',), ('run', 'done', 20)], 'synthetic', seed=112, first=2)
    S(scs, 'syn:slots-busy', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=1, tile=(40, 30), tries=9, snd='real'))],
      [('tick',), ('win',), ('run', 'done', 20)], 'synthetic', seed=113, busy_slots=[0x18, 0x19, 0x1a])
    S(scs, 'syn:slots-full-fatal', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30)))],
      [('tick',)], 'synthetic', seed=114, busy_slots=list(range(0x18, 0x40)), expect_fatal=0x52139c)
    S(scs, 'syn:gate-closed', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30)), tail=struct.pack('<8h', 15, 5, 1, 0, 0, 0, 0, 0))],
      [('tick',), ('ptr', 50, 50), ('click',), ('events', {5: 1}), ('tick',), ('win',), ('run', 'done', 20)], 'synthetic', seed=115)
    S(scs, 'syn:mode-not-3', [R(make_body(rng, pages=1, cols=2, rows=2, tabs=0, tile=(40, 30)))],
      [('mode', 2), ('tick',), ('mode', 3), ('tick',), ('play', 20, {})], 'synthetic', seed=116)
    S(scs, 'syn:view-changes', [R(make_body(rng, pages=1, cols=3, rows=2, tabs=1, tile=(40, 30), tries=9, snd='real'))],
      [('view', 'v1'), ('tick',), ('render',), ('view', 'neg'), ('render',), ('play', 30, {'solve': 0.4}), ('view', 'edge'), ('render',),
       ('view', 'big'), ('render',), ('win',), ('run', 'done', 20)], 'synthetic', seed=117)
    # ---- states the player can reach in odd orders: pokes of the flags and the inner state
    base = [R(make_body(rng, pages=1, cols=3, rows=2, tabs=1, tile=(40, 30), tries=9, snd='real'))]
    S(scs, 'syn:poke-flags', base, [
        ('tick',), ('poke', {O['won']: struct.pack('<i', 1), O['lost']: struct.pack('<i', 1)}), ('ptr', 50, 50), ('click',), ('render',),
        ('tick',), ('tick',), ('tick',), ('tick',)], 'synthetic', seed=118)
    S(scs, 'syn:poke-states', base, [
        ('tick',), ('poke', {O['state']: struct.pack('<i', 5)}), ('tick',), ('render',), ('poke', {O['state']: struct.pack('<i', 7)}), ('tick',),
        ('poke', {O['state']: struct.pack('<i', 1)}), ('tick',), ('poke', {O['state']: struct.pack('<i', 2), O['snd_wrong']: struct.pack('<i', 3)}),
        ('tick',), ('tick',), ('tick',)], 'synthetic', seed=119)
    S(scs, 'syn:poke-wait-states', base, [
        ('tick',), ('poke', {O['state']: struct.pack('<i', 3), O['snd_win']: struct.pack('<i', 4)}), ('tick',), ('tick',),
        ('poke', {O['state']: struct.pack('<i', 4), O['snd_wrong']: struct.pack('<i', 9)}), ('tick',), ('tick',), ('tick',)], 'synthetic',
      seed=120, captions=0)
    S(scs, 'syn:poke-inactive', base, [
        ('tick',), ('poke', {O['active']: struct.pack('<i', 0)}), ('ptr', 50, 50), ('click', CAND_TILE), ('click', CAND_TAB), ('render',),
        ('invalidate',), ('poke', {O['active']: struct.pack('<i', 5)}), ('render',), ('invalidate',), ('ptr', 50, 50), ('click',)], 'synthetic',
      seed=121)
    S(scs, 'syn:poke-slot', base, [
        ('tick',), ('poke', {O['slot']: struct.pack('<h', -1)}), ('invalidate',), ('poke', {O['slot']: struct.pack('<h', 0x18)}), ('invalidate',),
        ('poke', {O['slot']: struct.pack('<h', 0x18)}), ('render',)], 'synthetic', seed=122)
    # ---- the pointer receiver: edges of the 3-pixel shrink, tabs on top of tiles, every candidate value
    S(scs, 'syn:pointer-sweep', [R(make_body(rng, pages=1, cols=3, rows=2, tabs=1, tile=(20, 16), tries=9, snd='real'))],
      [('tick',)] + [('ptr', px, py) for py in range(34, 120, 3) for px in range(14, 130, 4)] + [('click',)], 'synthetic', seed=123, quick=False)
    S(scs, 'syn:click-candidates', [R(make_body(rng, pages=2, cols=2, rows=2, tabs=1, tile=(40, 30), tries=9, snd='real'))],
      [('tick',), ('click', 0), ('click', -1), ('click', 0x2767), ('click', 0x276a), ('click', 0x12769), ('ptr', 30, 50), ('click', CAND_TAB),
       ('click', CAND_TILE), ('click', CAND_TILE), ('click', CAND_TILE)], 'synthetic', seed=124)
    # ---- random bodies
    for i in range(int(os.environ.get('EE_RANDOM', '140'))):
        sub = rng.choice([1, 1, 1, 2, 0])
        body = make_body(rng, tile=(rng.choice([6, 7, 9, 20, 40, 60]), rng.choice([6, 7, 9, 20, 40, 60])))
        policy = dict(solve=rng.choice([0.1, 0.3, 0.5]), miss=rng.choice([0.05, 0.15, 0.3]), chaos=rng.choice([0.2, 0.4]))
        acts = [('tick',), ('play', rng.randrange(30, 140), policy)]
        if rng.random() < 0.5:
            acts += [('win', {'miss': rng.choice([0.0, 0.2, 0.5])})]
        elif rng.random() < 0.5:
            acts += [('lose',)]
        acts += [('run', 'done', 24)]
        if sub != 1 and rng.random() < 0.5:
            acts += [('play', 30, policy), ('tick',)]
        S(scs, 'random:%03d' % i, [R(body, sub)], acts, 'random', seed=rng.randrange(1 << 30), view=rng.choice(list(VIEWS)),
          captions=rng.choice([0, 1, 1, 5]), texts=rand_texts(rng) if rng.random() < 0.7 else {}, handle=rng.choice([0x7001, 1, 0x80000001, M32]),
          busy_slots=rng.choice([[], [], [0x18], [0x18, 0x19, 0x3f]]), rand=rng.choice(['wide', 'wide', 'small', 'seq', 'mid']),
          scene=rng.choice([0x11111111, 2305, 1600, 7]), quick=(i < 3))
    return scs


# ---------------------------------------------------------------------------------------------
# native-only checks
# ---------------------------------------------------------------------------------------------
def _rand_stream():
    r = random.Random(7)
    return [r.randrange(32768) for _ in range(6000)]


def fresh(lib, body, rands=None, view=None):
    nat = Native(lib)
    nat.set_body(0, body)
    nat.set_view(view or VIEWS['v0'])
    nat.set_queues([100] * 8, [0] * 8, rands if rands is not None else _rand_stream())
    return nat


def refusal_checks(lib, stats):
    chk = stats['native_checks']
    rng = random.Random(0x6060)

    def want(what, got, expect):
        chk[what] += 1
        if got != expect:
            raise Mismatch('native-only check %s: got %r, expected %r' % (what, got, expect))

    good = make_body(rng, pages=1, cols=2, rows=2, tabs=1, tile=(40, 30), snd='real', tries=9)
    nat = Native(lib)
    want('validate-good', nat.validate(good)[0], 0)
    for r in corpus_rows():
        want('validate-real', nat.validate(r['body'])[0], 0)
    consts = (C.c_int32 * 18)()
    lib.mpo_constants(consts)
    want('constants', list(consts), [0xee, BODY_LEN, OBJ_LEN, 24, MAX_CELLS, MAX_IDS, 12, SND, 9999, -1, 0x17, CAND_TAB, CAND_TILE,
                                     MP_CELLS, MP_USED, 0x52d568, MAX_BLITS, OBJ_LEN + MAX_CELLS * 12 + MAX_IDS * 4])

    def mut(**fields):
        b = bytearray(good)
        for off, data in fields.items():
            o = int(off[1:], 16)
            b[o:o + len(data)] = data
        return bytes(b)

    def i32(v):
        return struct.pack('<i', v)
    cases = [('short', good[:BODY_LEN - 1], '0xee-short-body'), ('empty', b'', '0xee-short-body'),
             ('name', mut(x0=b'A' * 0x21), '0xee-unterminated-name'),
             ('pages0', mut(**{'x%x' % B['pages']: i32(0)}), '0xee-pages'), ('pages4', mut(**{'x%x' % B['pages']: i32(4)}), '0xee-pages'),
             ('pages-1', mut(**{'x%x' % B['pages']: i32(-1)}), '0xee-pages'),
             ('cols0', mut(**{'x%x' % B['cols']: i32(0)}), '0xee-columns'), ('cols7', mut(**{'x%x' % B['cols']: i32(7)}), '0xee-columns'),
             ('rows0', mut(**{'x%x' % B['rows']: i32(0)}), '0xee-rows'), ('rows5', mut(**{'x%x' % B['rows']: i32(5)}), '0xee-rows'),
             ('slotc0', mut(**{'x%x' % B['slot_cols']: i32(0)}), '0xee-picture-columns'),
             ('slotc7', mut(**{'x%x' % B['slot_cols']: i32(7)}), '0xee-picture-columns'),
             ('slotr0', mut(**{'x%x' % B['slot_rows']: i32(0)}), '0xee-picture-rows'),
             ('slotr3', mut(**{'x%x' % B['slot_rows']: i32(3)}), '0xee-picture-rows'),
             ('odd-page', mut(**{'x%x' % B['cols']: i32(3), 'x%x' % B['rows']: i32(1)}), '0xee-odd-cell-count'),
             ('odd-total', mut(**{'x%x' % B['cols']: i32(3), 'x%x' % B['rows']: i32(1), 'x%x' % B['pages']: i32(3),
                                  'x%x' % B['shuffle']: b'\1'}), '0xee-odd-cell-count')]
    for base in ('flip1', 'flip2', 'match', 'wrong', 'win'):
        count = {'flip1': 1, 'flip2': 1, 'match': 5, 'wrong': 10, 'win': 10}[base]
        for i in (0, count - 1):
            o = B[base] + SND * i
            cases += [('%s%d-name' % (base, i), mut(**{'x%x' % o: b'A' * 0x21}), '0xee-unterminated-sound-name'),
                      ('%s%d-key' % (base, i), mut(**{'x%x' % (o + 0x31): b'K' * 0x21}), '0xee-unterminated-caption-key'),
                      ('%s%d-text' % (base, i), mut(**{'x%x' % (o + 0x52): b'T' * 0x64}), '0xee-unterminated-caption-text')]
    for name, body, why in cases:
        rc, text = nat.validate(body)
        want('validate-' + name, (rc, text), (2, why))
    # odd single page is accepted when shuffle-all spans an even total
    want('validate-odd-page-even-total', nat.validate(mut(**{'x%x' % B['cols']: i32(3), 'x%x' % B['rows']: i32(1), 'x%x' % B['pages']: i32(2),
                                                             'x%x' % B['shuffle']: b'\1'}))[0], 0)
    nat.close()
    # the NULL / missing callback guards
    nat = fresh(lib, good)
    out = (C.c_int32 * 16)()
    lib.mpo_null_checks(nat.h, out)
    want('null-guards', list(out)[:14], [1] * 14)
    # phase contract
    for ph, rowarg, label in ((1, 0, 'phase1-first'), (2, 0, 'phase2-first'), (3, 0, 'phase3'), (0xffffffff, 0, 'phase-ffffffff')):
        want(label, nat.step(0, rowarg, BODY_BASE, ph)[0], 3)
    nat.close()
    nat = fresh(lib, good)
    want('phase0', nat.step(0, 0, BODY_BASE, 0)[0], 0)
    want('phase1-other-row', nat.step(0, 1, BODY_BASE, 1)[0], 3)
    want('phase2-other-row', nat.step(0, 1, BODY_BASE, 2)[0], 3)
    # a validation failure precedes the first effect
    nat.set_body(1, mut(**{'x%x' % B['pages']: i32(9)}))
    nat.clear()
    st = nat.step(1, 0, BODY_BASE, 0)
    want('phase0-invalid-no-effect', (st[0], st[2]), (2, []))
    # click with a tab / tile index outside the pages and the table
    nat.close()
    nat = fresh(lib, good)
    nat.step(0, 0, BODY_BASE, 0)
    img = bytearray(nat.obj())
    struct.pack_into('<i', img, O['hit'], 5)
    nat.set_obj(bytes(img))
    want('click-tab-out-of-pages', nat.click(0, BODY_BASE, 1, CAND_TAB)[0], 5)
    want('click-tile-out-of-table', nat.click(0, BODY_BASE, 1, CAND_TILE)[0], 5)
    struct.pack_into('<i', img, O['hit'], -1)
    nat.set_obj(bytes(img))
    want('click-tab-negative', nat.click(0, BODY_BASE, 1, CAND_TAB)[0], 5)
    want('click-tile-negative', nat.click(0, BODY_BASE, 1, CAND_TILE)[0], 5)
    want('click-ignored-wrong-phase', nat.click(0, BODY_BASE, 2, CAND_TILE)[0], 0)
    # a flipped-cell pointer that is not a cell
    img = bytearray(nat.obj())
    struct.pack_into('<i', img, O['flipback'], 1)
    struct.pack_into('<I', img, O['deadline'], 0)
    struct.pack_into('<I', img, O['first'], 0xdead)
    struct.pack_into('<I', img, O['second'], MP_CELLS)
    nat.set_obj(bytes(img))
    nat.lib.mpo_clear_log(nat.h)
    want('flipback-bad-pointer', nat.step(0, 0, BODY_BASE, 1)[0], 5)
    # an event flag index the host refuses in a finish block
    for idx, expect in ((4096, 5), (-2, 5), (-1, 0), (4095, 0), (0, 0)):
        for outcome in ('win', 'lose'):
            blk = block_bytes(1207, flag=idx, value=3)
            b2 = make_body(random.Random(3), pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), win=blk, lose=blk, snd='none')
            n2 = fresh(lib, b2)
            n2.step(0, 0, BODY_BASE, 0)
            img = bytearray(n2.obj())
            struct.pack_into('<i', img, O['won' if outcome == 'win' else 'lost'], 1)
            n2.set_obj(bytes(img))
            before = n2.obj()
            st = n2.step(0, 0, BODY_BASE, 2)
            want('finish-flag-%d-%s' % (idx, outcome), st[0], expect)
            if expect:
                want('finish-flag-%d-%s-no-effect' % (idx, outcome), (st[2], n2.obj()), ([], before))
            n2.close()
    # a caption longer than the 104-byte local
    for n_chars, expect in ((97, 0), (98, 5), (99, 5)):
        b3 = bytearray(make_body(random.Random(4), pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), snd='real'))
        o = B['flip1']
        put_name(b3, o + 0x31, b'', 0x21)
        put_name(b3, o + 0x52, b'x' * n_chars, 0x64)
        n3 = fresh(lib, bytes(b3))
        n3.lib.mpo_set_captions(n3.h, 1)
        n3.step(0, 0, BODY_BASE, 0)
        p = parse(bytes(b3))
        n3.pointer(0, *center(p['tiles'][0]))
        want('caption-%d' % n_chars, n3.click(0, BODY_BASE, 1, CAND_TILE)[0], expect)
        n3.close()
    # random-pick loops beyond MP_PICK_LIMIT
    n4 = fresh(lib, good, rands=[0] * 6000)
    want('deal-stuck', n4.step(0, 0, BODY_BASE, 0)[0], 6)
    n4.close()
    b5 = bytearray(make_body(random.Random(5), pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), snd='real'))
    for i in range(0, 9):
        put_name(b5, B['wrong'] + SND * i, b'NO SOUND', 0x21)
    n5 = fresh(lib, bytes(b5))
    n5.step(0, 0, BODY_BASE, 0)
    img = bytearray(n5.obj())
    struct.pack_into('<i', img, O['state'], 2)
    n5.set_obj(bytes(img))
    n5.lib.mpo_set_queues(n5.h, (C.c_uint32 * 1)(0), 0, (C.c_int32 * 1)(0), 0, (C.c_int32 * 1000)(*([3] * 1000)), 1000)
    want('pick-sound-stuck', n5.step(0, 0, BODY_BASE, 1)[0], 6)
    n5.close()
    # render with a picture id outside the table, cells that are not dealt
    n6 = fresh(lib, good)
    n6.step(0, 0, BODY_BASE, 0)
    cells, used = n6.heap()
    cb = bytearray(cells)
    struct.pack_into('<ii', cb, 0, 99, 1)
    n6.set_heap(bytes(cb), used)
    want('render-bad-id', n6.plan(0)[0], 5)
    n6.close()
    # host failures: every host call of the phases fails once, nothing may crash and the status is MP_ERR_HOST
    for label, setup in (('phase0', None),):
        base_calls = None
        for n in range(1, 60):
            n7 = fresh(lib, good)
            n7.lib.mpo_set_fail(n7.h, n)
            rc = n7.step(0, 0, BODY_BASE, 0)[0]
            n7.close()
            if rc == 0:
                base_calls = n
                break
            want('fail-%s-%d' % (label, n), rc, 4)
        want('fail-%s-has-end' % label, base_calls is not None, True)
    for mode_name, body in (('win', 'win'), ('lose', 'lose')):
        blk = block_bytes(1207, (1, 2, 3), (4, 5, 6), 1, 5, 2)
        b8 = make_body(random.Random(8), pages=1, cols=2, rows=2, tabs=0, tile=(40, 30), win=blk, lose=blk, snd='real')
        for n in range(1, 60):
            n8 = fresh(lib, b8)
            n8.lib.mpo_set_captions(n8.h, 1)
            n8.step(0, 0, BODY_BASE, 0)
            img = bytearray(n8.obj())
            struct.pack_into('<i', img, O['won' if mode_name == 'win' else 'lost'], 1)
            struct.pack_into('<i', img, O['state'], 1)
            n8.set_obj(bytes(img))
            n8.lib.mpo_set_fail(n8.h, n)
            rc = 0
            for ph in (1, 1, 1, 2):
                rc = n8.step(0, 0, BODY_BASE, ph)[0]
                if rc != 0:
                    break
            n8.close()
            if rc == 0:
                break
            want('fail-finish-%s-%d' % (mode_name, n), rc, 4)
    # a click path with sounds, captions and a matching / mismatching pair
    pb = parse(good)
    for n in range(1, 40):
        n9 = fresh(lib, good)
        n9.lib.mpo_set_captions(n9.h, 1)
        n9.step(0, 0, BODY_BASE, 0)
        cells, used = n9.heap()
        ids = [struct.unpack_from('<i', cells, 12 * i)[0] for i in range(4)]
        partner = next(i for i in range(1, 4) if ids[i] == ids[0])
        n9.lib.mpo_set_fail(n9.h, n)
        rc = 0
        for c in (0, partner):
            n9.pointer(0, *center(pb['tiles'][c]))
            rc = n9.click(0, BODY_BASE, 1, CAND_TILE)[0]
            if rc != 0:
                break
        n9.close()
        if rc == 0:
            break
        want('fail-click-%d' % n, rc, 4)
    return stats


# ---------------------------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------------------------
class Stats(dict):
    def __missing__(self, key):
        return 0


def new_stats():
    return Stats(scenarios=0, ticks=0, steps=0, host_calls=0, state_compares=0, object_bytes=0, cell_bytes=0, id_bytes=0, body_bytes=0,
                 entry_bytes=0, event_bytes=0, cells=0, pointer_moves=0, pointer_hits=0, clicks=0, clicks_acting=0, clicks_ignored=0,
                 invalidates=0, cleanups=0, render_calls=0, blit_calls=0, phase0_steps=0, phase1_steps=0, phase2_steps=0, deals=0,
                 completions=0, gate_closed_ticks=0, fatal_paths_matched=0, ticks_consumed=0, busy_consumed=0, rand_consumed=0, pokes=0,
                 heap_frees=0, heap_mallocs=0, mismatches=0, effect_kinds=Counter(), native_refusal_observed=Counter(),
                 native_checks=Counter(), groups={})


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
        except Exception as error:  # an oracle defect: reported, never silent
            import traceback
            bad.append((sc['id'], 'ORACLE CRASH ' + ''.join(traceback.format_exception_only(type(error), error)).strip() + ' @ ' +
                        traceback.extract_tb(error.__traceback__)[-1].name))
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
    ap.add_argument('--quick-only', action='store_true')
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--sanitize', action='store_true')
    ap.add_argument('--lenient-build', action='store_true', help='build the driver without -Werror (mutants)')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    tmp = tempfile.TemporaryDirectory(prefix='RT-60.oracle-', dir=PRIVATE)
    work = Path(tmp.name)
    scs = scenario_list()
    if args.list:
        print(len(scs), dict(Counter(s['group'] for s in scs)))
        return 0
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    scs = [s for s in scs if s['quick']] + [s for s in scs if not s['quick']]
    if args.workers > 1 and not args.shard:
        lib_path = args.native_library or build_driver(args.src, work / 'libdriver_ee.so', strict=not args.lenient_build, sanitize=args.sanitize)
        procs = []
        for k in range(args.workers):
            res = work / ('shard%d.json' % k)
            cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--shard', '%d/%d' % (k, args.workers),
                   '--result', str(res), '--show', str(args.show)]
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
        merged['scenarios_total'] = len(scs)
        print(json.dumps(merged, sort_keys=True, default=str))
        if args.result:
            args.result.parent.mkdir(parents=True, exist_ok=True)
            args.result.write_text(json.dumps(dict(slice='RT-60', status='pass' if not code and not merged['mismatches'] else 'fail',
                                                   original_sha256=EXE_HASH, stats=merged,
                                                   oracle_sha256=sha(Path(__file__).read_bytes()),
                                                   driver_source_sha256=sha((PROJECT / 'tests/action_family_ee_runtime_oracle_driver.c').read_bytes()),
                                                   source_sha256={n: sha((args.src / n).read_bytes()) for n in
                                                                  ('action_family_ee_runtime.c', 'action_family_ee_runtime.h')},
                                                   native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=merged['seconds']),
                                              indent=2, sort_keys=True, default=str) + '\n')
        return 1 if code or merged['mismatches'] else 0
    if args.shard:
        k, n = [int(v) for v in args.shard.split('/')]
        scs = [s for i, s in enumerate(scs) if i % n == k]
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver_ee.so', strict=not args.lenient_build, sanitize=args.sanitize)
    lib = open_lib(lib_path)
    x = X86()
    stats = new_stats()
    bad = run_list(x, lib, scs, stats, fail_fast=args.fail_fast)
    if not args.only and (not args.shard or args.shard.startswith('0/')):
        try:
            refusal_checks(lib, stats)
        except Mismatch as error:
            bad.append(('native-only', str(error)))
            stats['mismatches'] += 1
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:700])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = to_plain(stats)
    summary['seconds'] = round(time.monotonic() - started, 1)
    summary['hooks_fired'] = dict(x.hooks_fired)
    if not args.shard:
        print(json.dumps(summary, sort_keys=True, default=str))
    if args.result:
        args.result.parent.mkdir(parents=True, exist_ok=True)
        args.result.write_text(json.dumps(dict(slice='RT-60', original_sha256=EXE_HASH, stats=summary,
                                               native_library_sha256=sha(Path(lib_path).read_bytes()), seconds=summary['seconds']),
                                          indent=2, sort_keys=True, default=str) + '\n')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
