#!/usr/bin/env python3
"""RT-34: immutable x86 dispatcher 0x427a50 / handler 0x48c1c0 versus the native runtime-type-0xd8 kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of runtime type 0xd8 (the built records of 0x411b16,
pData length 0x868 - (100 - n) * 0x12) the REAL dispatcher 0x427a50 runs: arm 0x42a354, gate 0x423f57 (dependency
tree built by the real loader 0x424aa8), the handler 0x48c1c0 with ECX = singleton 0x624686 (the object is built the
way the original does: vtable word 0x52d960, then 0x48bb17 as original code), the generic Z entry allocator 0x4d39f9
and releaser 0x4d3992 on the table at 0x5d1591 (original code on the zeroed table), the completion 0x42ba3a and the
cleanup 0x48bb86 / reset 0x48bb17 (original code, so the generic completion and cleanup are compared), the CRT
_stricmp 0x516530 (its locale word 0x63cb14+8 is 0 in the image, so the ASCII fast path runs) and atoi
0x50cb1b -> 0x50ca90 (the static ctype table 0x568200 and mb_cur_max 0x56840c == 1 of the image) as ORIGINAL code.
The direct calls run the original methods: hit test 0x48bd91, click 0x48c0ac, press 0x48c148, redraw request
0x48bc38, cleanup 0x48bb86 and the render callback 0x48cc70. The native side is src/action_family_d8_runtime.c driven
by tests/action_family_d8_runtime_oracle_driver.c with a scripted host.

Compared for every scenario and step: the ORDERED externally visible effects (the kernel's D8_FX_* observer log plus
the host calls that have no observer effect, against the list derived from Unicorn write hooks and call hooks on the
object bytes +0x1c..+0x57, the 0x5bb1ca flag, the scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff 0x5bb59b
0x5bb59f 0x5bb5a3, 0x583999, 0x5d1a8f, the event flags 0x585801 + 4 * i, the entry-table cells, the GetTickCount
calls and the entries of 0x42ba3a / 0x4d3992 / 0x48bb86), the object image (32 fields), the process cells, the event
flag array (128 dwords), the whole 0x58 * 0x4a generic Z entry table byte for byte, every row's phase dword and
completion byte, and a write audit that fails if anything wrote outside the modelled object bytes, the permitted
row-table bytes (+0x72 completion byte, +0x73 dispatcher dword, +0x7f phase dword) or the permitted cells. The render
callback blits are compared against d8_render_plan (kind, source surface, rectangles, label string).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's `ret N` and returns),
 O = observed (recorded, the original body then runs), G = raising guard.
  R 0x4c2790 load_image(kind,name,6,label) thiscall ECX 0x5cf659, ret 0x10: checks "CIFTREE", 6 and the 25-byte label,
            returns the scripted handle (a record: name pointer, label)
  R 0x4c2dfb release_image(&handle) thiscall ECX 0x5cf659, ret 4: records the old value, zeroes *param (the real
            routine returns at once for 0 and otherwise frees; its frees and engine work are outside this slice)
  R 0x51dc43 malloc / 0x51dc6c free: bump arena in the oracle's own heap (OS/CRT boundary); reached only by the
            real dependency loader at row setup, never during a step (a step that reaches them fails the run)
  R 0x4c5377 / 0x4c5d4b render blits (ret 0x14, ECX 0x5cf659): recorders of the five pushed arguments (render run
            only; the surface handles are scenario-chosen distinct values, rectangles and label are read at call time)
  R (Windows imports, IAT slots patched to stubs) GetTickCount 0x52a23c: scripted values (shared by both sides);
            IsRectEmpty 0x52a4a8: Windows semantics (empty when right <= left or bottom <= top, signed 32 bit);
            InterlockedIncrement/Decrement, lstrlenA, Enter/Leave/InitializeCriticalSection (single thread);
            any other import fails the run
  O 0x48c1c0 handler entry (row, phase, ECX == 0x624686)      O 0x42ba3a completion (row)
  O 0x4d3992 release_entry(slot)                              O 0x48bb86 cleanup entry, 0x48bc34 end of cleanup
  O instruction boundaries inside 0x48c1c0 that only read memory: 0x48c442 / 0x48c6da (after the entry label copy of
            slot A / B), 0x48c46e 0x48c4ac 0x48c4ea (after the text surface store of USE_AUTOTEXT1/2/3), 0x48c589
            (the atoi result of USE_LISTPAGE<n>) and 0x48c593 (after its store), 0x48c5f9 / 0x48c757 (after the slot
            surface store of A / B), 0x48c80a (after the phase 1 store)
  UC_HOOK_MEM_WRITE observers (read-only): object 0x624686..+0x60, the whole row table, the process cells, the event
            flags, the entry table, the hit test output cells
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
            scenario expects the allocator's fatal path 0x52139c, which is then compared with the native host error);
            0x425b8b and 0x425b40 (debug tree printer / malformed tree) raise through the base.
 The debug flag 0x63a4cd is 0 (logging disabled). FS needs a TIB page (GDT). Everything else is plain original
 execution on the zeroed generic Z table (stride 0x4a), the text surface table 0x5d0397 (6 dwords) and heights
 0x619a53 (6 dwords) which the scenarios fill and the native text_surface callback returns the same values.

Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles, text surfaces
and heights, GetTickCount values, the render handles (saved frame, back buffer), the view origins, slot-busy seeds,
event flag and cell seeds.

DELIBERATE SAFETY DIVERGENCES (native rejections, excluded from parity and counted as `rejections`):
  S1 USE_LISTPAGE<n> whose page index 2 + atoi lies outside 0..5: the original reads the table out of range, the
     native kernel returns D8_ERR_BODY before any effect.
  S2 frame rate byte 0 in phase 1: the original executes `idiv` by 0 (verified: the Unicorn run faults with a
     divide error); native D8_ERR_BODY, no effect.
  S3 exit event flag index outside the event flag table (or < -1): the original stores at 0x585801 + 4 * index, the
     native binding refuses before any effect.
  S4 click on a link candidate with an invalid hot index: the original reads outside the entry array.
  S5 record validation: bad length, count above 100, unterminated names: the original trusts its loader.
  Cases of S1..S5 are checked for "native status D8_ERR_BODY and nothing changed" and never against the original.

Run (from outputs/blackmoor-decomp/tests):
  python3 -I action_family_d8_runtime_original_oracle.py --mutations --result <receipt.json>
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
from pathlib import Path

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

sys.path.insert(0, str(Path(__file__).resolve().parent))
import conditions_nested_original_oracle as deps  # noqa: E402
from cif_original_oracle import DEFAULT_EXE  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x624686
OBJ_SPAN = 0x60
ROWS = 0x5bb5b3
ROW = 0x8d
ROW_MAX = 232
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
SKIP_OFF = 0x85
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
CELL_ADDR = [0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3]
CELL_SIZE = [4, 2, 2, 2, 4, 4, 4]
G_MODE, G_ROWCOUNT, G_LOG, G_5D1A8F = 0x583999, 0x5c39e3, 0x63a4cd, 0x5d1a8f
G_ORIGIN_X, G_ORIGIN_Y = 0x583186, 0x58318a
G_SAVED, G_BACK = 0x5d15e3, 0x5cf665
G_CAND = 0x5c39e5
HIT_IN = dict(item=0x583a29, flag=0x5b44f8, v0377=0x5d0377, v571=0x571ad3)
HIT_OUT = [0x5b44f0, 0x5b44f4, 0x5c39e5, 0x5d162d, 0x5d1631, 0x5d1639]
TEXT_SURF, TEXT_HEIGHT = 0x5d0397, 0x619a53
EVENTS_VA = 0x585801
EVN = 128
TAIL_BASE = 0x2000a000
BODY_BASE = 0x22000000
BODY_STRIDE = 0x900
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x1000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
FPCW = 0x27f
LOAD_LABEL = b'DF PeepholePuzzle Surface'
VTABLE = 0x52d960
NO_SCENE = 9999

SRC_HEADER = PROJECT / 'src/action_family_d8_runtime.h'


def header_values():
    text = SRC_HEADER.read_text()
    fx = {m.group(1): int(m.group(2)) for m in re.finditer(r'\bD8_FX_(\w+)\s*=\s*(\d+)', text)}
    cand = {m.group(1): int(m.group(2), 0) for m in re.finditer(r'#define D8_CAND_(\w+)\s+(0x[0-9a-fA-F]+)', text)}
    return fx, cand


_FX, _CAND = header_values()
FX = dict(ENTER=0, **_FX, TICKCALL=20, CELL=21)
FXN = {v: k for k, v in FX.items()}
CAND = _CAND
assert FX['TICK'] == 18 and CAND['EXIT'] == 0x27a9, 'header drifted from the oracle'

# object image: (name, offset, struct format); same order as d8o_get_object in the driver
OBJ_FIELDS = [('dir', 0x1c, 'B'), ('visible', 0x1d, 'B'), ('surface1', 0x1e, 'i'), ('surface2', 0x22, 'i'),
              ('row', 0x26, 'h'), ('hot', 0x28, 'h'), ('slot_a', 0x2e, 'h'), ('slot_b', 0x30, 'h'),
              ('can0', 0x34, 'B'), ('can1', 0x35, 'B'), ('can2', 0x36, 'B'), ('can3', 0x37, 'B'),
              ('ina0', 0x38, 'B'), ('ina1', 0x39, 'B'), ('ina2', 0x3a, 'B'), ('ina3', 0x3b, 'B'),
              ('down0', 0x3c, 'B'), ('down1', 0x3d, 'B'), ('down2', 0x3e, 'B'), ('down3', 0x3f, 'B'),
              ('pressed', 0x40, 'B'), ('pos_41', 0x41, 'h'), ('pos_43', 0x43, 'h'), ('borrowed', 0x45, 'B'),
              ('active', 0x46, 'B'), ('exit_clicked', 0x47, 'B'), ('limit_48', 0x48, 'h'), ('limit_4a', 0x4a, 'h'),
              ('limit_4c', 0x4c, 'h'), ('limit_4e', 0x4e, 'h'), ('tick', 0x50, 'i'), ('target_scene', 0x54, 'h')]
OBJ_NAMES = [f[0] for f in OBJ_FIELDS]
OBJ_BYTES = set()
for _n, _o, _f in OBJ_FIELDS:
    OBJ_BYTES.update(range(_o, _o + struct.calcsize('<' + _f)))
assert len(OBJ_FIELDS) == 32

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
 (0x48bb17, 0x48bb86,
  '6641270acd0adc0dfa9724340851a5ebc3243d0b1b5a95a66bf021c6e2f76a25'),
 (0x48bb86, 0x48bc38,
  'ef85d7e0a7c773651e6453c2292fcb1ad8d105335367e51b32825d9314448b92'),
 (0x48bc38, 0x48bc9b,
  '3825de742d9dd36ce06526747de36286fb673641a7c19045212dfad5e0470b7b'),
 (0x48bd91, 0x48c0ac,
  '903a8e158b77aa0b552d58eb2f612b0f0a0e6c4569fbdcbdefe1ca16c1baccf9'),
 (0x48c0ac, 0x48c148,
  'f0383610f91321d60fec4a18f9f1beb4fdf082fc29a7ccbf6c7a4071be3e2666'),
 (0x48c148, 0x48c1c0,
  '2b105ddd7273f114a0822a0ff60de71c6ccbc25f7f9803be13d0dd0c9fad1de7'),
 (0x48c1c0, 0x48cc60,
  'bc541fa853be7d21c726ffe815f30981a49f2b212b99c4ddd7412fff622a0b2a'),
 (0x48cc70, 0x48cf50,
  'a0240d7b6135cc8d4e3d2e4f42cc80695fcf8c214dfc2d2f23000ab1495804fe'),
 (0x4c2790, 0x4c2898,
  '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
 (0x4c2dfb, 0x4c2e5b,
  '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
 (0x4c5377, 0x4c558b,
  'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
 (0x4c5d4b, 0x4c609b,
  'cfb7385d2efeb3e0fe986eb4812d22f3447e4b1134ff5086a655a0ccc10d5379'),
 (0x4d3992, 0x4d39f9,
  'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
 (0x4d39f9, 0x4d3a52,
  '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
 (0x50ca90, 0x50cb1b,
  '17e48db1ba16bebfd13d82208bc0e6278361248123cde90844002c26c0204e9a'),
 (0x50cb1b, 0x50cb26,
  'de8e53f3edb8d03fe276f4726fdf910ba2b7b005346cdbdad94cf3cb7728cff7'),
 (0x516530, 0x516600,
  'e6af09f84ddc920c21c56a52ba89bb6f2b2f43bf0db2a874f605dfdb9ca98a65'),
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


def s32v(v):
    v &= 0xffffffff
    return v - (1 << 32) if v & 0x80000000 else v


def s16v(v):
    v &= 0xffff
    return v - 0x10000 if v & 0x8000 else v


def cstr(data):
    return bytes(data).split(b'\0')[0]


# ---------------------------------------------------------------------------------------------
# records
# ---------------------------------------------------------------------------------------------
def rect(l, t, r, b):
    return struct.pack('<4i', l, t, r, b)


DEF_BUTTONS = [(10, 10, 40, 40), (50, 10, 80, 40), (10, 50, 40, 80), (50, 50, 80, 80)]
DEF_DOWNS = [(110, 10, 140, 40), (150, 10, 180, 40), (110, 50, 140, 80), (150, 50, 180, 80)]
DEF_INACTS = [(210, 10, 240, 40), (250, 10, 280, 40), (210, 50, 240, 80), (250, 50, 280, 80)]


def build_record(name=b'IMG_A', name2=b'', mode=0, lim=(0, 0, 800, 600), src=(0, 0, 200, 100), dst=(8, 16, 208, 116),
                 buttons=None, downs=None, inacts=None, fps=30, exit_scene=NO_SCENE, exit_words=(1, 2, 3),
                 exit_dwords=(4, 5, 6), flag149=0, exit_flag=-1, exit_val=0, exit_rect=(300, 10, 340, 50),
                 links=(), junk=0):
    rec = bytearray(0x160 + 0x12 * len(links))
    if junk:
        rec[:] = bytes((junk + i * 7) & 0xff for i in range(len(rec)))
    rec[0:0x42] = bytes(0x42)
    rec[0:len(name)] = name
    rec[0x21:0x21 + len(name2)] = name2
    rec[0x42] = mode
    rec[0x43] = 0
    struct.pack_into('<4i', rec, 0x44, *lim)
    struct.pack_into('<4i', rec, 0x54, *src)
    struct.pack_into('<4i', rec, 0x64, *dst)
    for base, rects, dflt in ((0x74, buttons, DEF_BUTTONS), (0xb4, downs, DEF_DOWNS), (0xf4, inacts, DEF_INACTS)):
        for i, r in enumerate(rects or dflt):
            struct.pack_into('<4i', rec, base + 16 * i, *r)
    rec[0x134] = fps
    struct.pack_into('<h', rec, 0x135, exit_scene)
    struct.pack_into('<3h', rec, 0x137, *exit_words)
    struct.pack_into('<3i', rec, 0x13d, *exit_dwords)
    struct.pack_into('<h', rec, 0x149, flag149)
    struct.pack_into('<h', rec, 0x14b, exit_flag)
    rec[0x14d] = exit_val
    struct.pack_into('<4i', rec, 0x14e, *exit_rect)
    struct.pack_into('<h', rec, 0x15e, len(links))
    for i, (scene, r) in enumerate(links):
        struct.pack_into('<h4i', rec, 0x160 + 0x12 * i, scene, *r)
    return bytes(rec)


def rec_limits(rec):
    """The four limits phase 0 derives (signed 16 bit of the int32 differences), in object order 48, 4a, 4c, 4e."""
    d = struct.unpack_from('<4i', rec, 0x44)
    s = struct.unpack_from('<4i', rec, 0x54)
    return dict(limit_4a=s16v(d[0] - s[0]), limit_4e=s16v(d[1] - s[1]), limit_48=s16v(d[2] - s[2]),
                limit_4c=s16v(d[3] - s[3]))


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_d8_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_d8_runtime.c'), '-o', str(out)]
    if os.environ.get('D8_SANITIZE'):
        # D8_SANITIZE=1 aborts on the first undefined behaviour; D8_SANITIZE=recover reports every site and goes on
        recover = '-fsanitize-recover=undefined' if os.environ['D8_SANITIZE'] == 'recover' else '-fno-sanitize-recover=undefined'
        cmd[1:1] = ['-fsanitize=address,undefined', recover, '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p, u32p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8), C.POINTER(C.c_uint32)
    i32p = C.POINTER(i32)
    lib.d8o_new.restype = p
    lib.d8o_free.argtypes = [p]
    lib.d8o_set_handles.argtypes = [p, u32p, C.c_int]
    lib.d8o_set_text.argtypes = [p, C.c_int, C.c_uint32, i32]
    lib.d8o_set_ticks.argtypes = [p, u32p, C.c_int]
    lib.d8o_tick_underrun.argtypes = [p]
    lib.d8o_ticks_used.argtypes = [p]
    lib.d8o_set_busy.argtypes = [p, C.c_int, C.c_int]
    lib.d8o_set_entry_u32.argtypes = [p, C.c_int, C.c_int, C.c_uint32]
    lib.d8o_set_cells.argtypes = [p, i32p]
    lib.d8o_get_cells.argtypes = [p, i32p]
    lib.d8o_set_event.argtypes = [p, C.c_int, i32]
    lib.d8o_get_events.argtypes = [p, i32p]
    lib.d8o_clear_log.argtypes = [p]
    lib.d8o_log_count.argtypes = [p]
    lib.d8o_log.argtypes = [p, C.c_int, i32p]
    lib.d8o_name_count.argtypes = [p]
    lib.d8o_name.argtypes = [p, C.c_int]
    lib.d8o_name.restype = C.c_char_p
    lib.d8o_label.argtypes = [p, C.c_int]
    lib.d8o_label.restype = C.c_char_p
    lib.d8o_bad_slot_calls.argtypes = [p]
    lib.d8o_bad_event_calls.argtypes = [p]
    lib.d8o_why.argtypes = [p]
    lib.d8o_why.restype = C.c_char_p
    lib.d8o_get_object.argtypes = [p, i32p]
    lib.d8o_set_object.argtypes = [p, i32p]
    lib.d8o_entries.argtypes = [p, u8p]
    lib.d8o_step.argtypes = [p, u8p, C.c_size_t, C.c_int, C.c_uint32, C.c_size_t, u32p]
    lib.d8o_step.restype = C.c_int
    lib.d8o_cleanup.argtypes = [p]
    lib.d8o_dirty.argtypes = [p]
    lib.d8o_hit.argtypes = [p, u8p, C.c_size_t, C.c_int, C.c_int, i32p, i32p]
    lib.d8o_hit.restype = C.c_int
    lib.d8o_click.argtypes = [p, u8p, C.c_size_t, i32, i32p]
    lib.d8o_click.restype = C.c_int
    lib.d8o_press.argtypes = [p, C.c_uint32, i32]
    lib.d8o_press.restype = C.c_int
    lib.d8o_plan.argtypes = [p, u8p, C.c_size_t, i32, i32, i32p]
    lib.d8o_plan.restype = C.c_int
    lib.d8o_plan_label.argtypes = [C.c_int]
    lib.d8o_plan_label.restype = C.c_char_p
    lib.d8o_record_bytes.argtypes = [C.c_int]
    lib.d8o_validate.argtypes = [u8p, C.c_size_t]
    return lib


def cbuf(b):
    return (C.c_uint8 * max(1, len(b))).from_buffer_copy(bytes(b) or b'\0')


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.d8o_new()

    def close(self):
        self.lib.d8o_free(self.h)

    def clear(self):
        self.lib.d8o_clear_log(self.h)

    def set_handles(self, hs):
        arr = (C.c_uint32 * max(1, len(hs)))(*[h & 0xffffffff for h in hs])
        self.lib.d8o_set_handles(self.h, arr, len(hs))

    def set_ticks(self, ts):
        arr = (C.c_uint32 * max(1, len(ts)))(*[t & 0xffffffff for t in ts])
        self.lib.d8o_set_ticks(self.h, arr, len(ts))

    def fx(self):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(self.lib.d8o_log_count(self.h)):
            self.lib.d8o_log(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        return out

    def names(self):
        return [(self.lib.d8o_name(self.h, i).decode('latin1'), self.lib.d8o_label(self.h, i).decode('latin1'))
                for i in range(self.lib.d8o_name_count(self.h))]

    def obj(self):
        t = (C.c_int32 * 32)()
        self.lib.d8o_get_object(self.h, t)
        return list(t)

    def set_obj(self, values):
        t = (C.c_int32 * 32)(*[s32v(v) for v in values])
        self.lib.d8o_set_object(self.h, t)

    def cells(self):
        t = (C.c_int32 * 10)()
        self.lib.d8o_get_cells(self.h, t)
        return list(t)

    def set_cells(self, v):
        t = (C.c_int32 * 10)(*[s32v(x) for x in v])
        self.lib.d8o_set_cells(self.h, t)

    def events(self):
        t = (C.c_int32 * EVN)()
        self.lib.d8o_get_events(self.h, t)
        return list(t)

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.d8o_entries(self.h, t)
        return bytes(t)

    def step(self, rec, row, phase, evn=EVN):
        self.clear()
        res = (C.c_uint32 * 3)()
        status = self.lib.d8o_step(self.h, cbuf(rec), len(rec), row, phase, evn, res)
        return status, (self.lib.d8o_why(self.h) or b'').decode(), self.fx(), self.names(), list(res)

    def plan(self, rec, ox, oy):
        t = (C.c_int32 * 64)()
        status = self.lib.d8o_plan(self.h, cbuf(rec), len(rec), ox, oy, t)
        v = list(t)
        blits = []
        for i in range(v[1]):
            q = v[2 + 10 * i:12 + 10 * i]
            blits.append(dict(kind=q[0], source=q[1], src=q[2:6], dst=q[6:10],
                              label=self.lib.d8o_plan_label(i).decode('latin1')))
        return status, dict(valid=v[0], blits=blits)


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


POPS = {0x4c2790: 0x10, 0x4c2dfb: 4, 0x51dc6c: 0, 0x4c5377: 0x14, 0x4c5d4b: 0x14}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]
RENDER_BLITS = (0x4c5377, 0x4c5d4b)

# per operation mode: which write categories are permitted by the audit
ALLOWED = {
    'step': {'obj', 'rows', 'cells', 'events', 'entries'},
    'press': {'obj'},
    'click': {'obj', 'rowphase'},
    'hit': {'obj', 'hit', 'entries'},
    'dirty': {'entries'},
    'cleanup': {'obj', 'entries'},
    'render': set(),
}


class X86(deps.OriginalMachine):
    def __init__(self, check_pins=True):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.pristine = bytes(self.pe.image)
        if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
            raise OracleError('executable identity mismatch')
        if check_pins:
            for a, z, digest in PINS_TABLE:
                if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                    raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
        uc.mem_map(HEAP_BASE, HEAP_SIZE)
        uc.mem_map(BODY_BASE, 0x10000)
        uc.mem_map(TIB, 0x1000)
        uc.mem_map(GDT, 0x1000)
        uc.mem_map(STUBS, 0x4000)
        uc.mem_write(STUBS, b'\xc3' * 0x4000)

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
        self.mode = None            # 'step' | 'press' | 'click' | 'hit' | 'dirty' | 'cleanup' | 'render' | None
        self.in_cleanup = False
        self.fx = []
        self.entered = []
        self.allocs = {}
        self.heap_cursor = HEAP_BASE
        self.heap_high = HEAP_BASE
        self.loaded = []
        self.handles = []
        self.handle_i = 0
        self.tick_script = []
        self.tick_i = 0
        self.blits = []
        self.writes = []
        self.audit = False
        self.atoi_ret = 0
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
        self.rec_addr = {}
        self._install_imports()
        self._install_hooks()

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
            if self.tick_i >= len(self.tick_script):
                raise OracleError('GetTickCount script exhausted')
            v = self.tick_script[self.tick_i] & 0xffffffff
            self.tick_i += 1
            if self.mode is not None:
                self.fx.append((FX['TICKCALL'], s32v(v), 0))
            self._ret(uc, 0, v)
        elif name == 'IsRectEmpty':
            left, top, right, bottom = struct.unpack('<4i', bytes(uc.mem_read(arg0, 16)))
            self._ret(uc, 4, 1 if (right <= left or bottom <= top) else 0)
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
            if self.mode is not None:
                raise OracleError('malloc reached during an operation')
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
        for a, name in (
                (0x48c1c0, '_entry'), (0x48c442, '_reg_a'), (0x48c6da, '_reg_b'), (0x48c46e, '_text0'),
                (0x48c4ac, '_text1'), (0x48c4ea, '_text2'), (0x48c589, '_atoi_at'), (0x48c593, '_text_list'),
                (0x48c5f9, '_surf_a'), (0x48c757, '_surf_b'), (0x48c80a, '_phase1'), (0x42ba3a, '_complete'),
                (0x4d3992, '_release_entry'), (0x48bb86, '_cleanup_in'), (0x48bc34, '_cleanup_out')):
            table[a] = getattr(self, name)
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        ranges = [(OBJ, OBJ + OBJ_SPAN - 1), (ROWS, ROWS + ROW * ROW_MAX - 1), (START_FLAG, START_FLAG + 3),
                  (0x5bb57b, 0x5bb5a6), (0x5c39ff, 0x5c3a00), (G_MODE, G_MODE + 3),
                  (EVENTS_VA, EVENTS_VA + 4 * EVN + 3), (ENTRY, ENTRY + NENT * STRIDE - 1),
                  (0x5b44f0, 0x5b44f7), (G_CAND, G_CAND + 3)]
        for lo, hi in ranges:
            uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=lo, end=hi)

    def _raise(self, uc, address, size, user):
        if address == self.expect_fatal:
            raise Fatal(address)
        raise OracleError('guarded original routine %#x reached' % address)

    # -- state access --------------------------------------------------------------------------
    def rd(self, a, n):
        return bytes(self.machine.mem_read(a, n))

    def s16(self, a):
        return struct.unpack('<h', self.rd(a, 2))[0]

    def s32(self, a):
        return struct.unpack('<i', self.rd(a, 4))[0]

    def wr(self, a, b):
        self.machine.mem_write(a, bytes(b))

    def w32(self, a, v):
        self.wr(a, struct.pack('<I', v & 0xffffffff))

    def object(self):
        r = self.rd(OBJ, OBJ_SPAN)
        return [struct.unpack_from('<' + f, r, o)[0] for _n, o, f in OBJ_FIELDS]

    def set_object(self, values):
        for (_n, o, f), v in zip(OBJ_FIELDS, values):
            if f == 'B':
                v &= 0xff
            elif f == 'h':
                v = s16v(v)
            else:
                v = s32v(v)
            self.wr(OBJ + o, struct.pack('<' + f, v))

    def cells(self):
        return [self.s32(START_FLAG), self.s32(0x5bb57b), self.s16(0x5bb599), self.s16(0x5bb595), self.s16(0x5c39ff),
                self.s32(0x5bb59b), self.s32(0x5bb59f), self.s32(0x5bb5a3), self.s32(G_MODE), self.s32(G_5D1A8F)]

    def set_cells(self, v):
        self.w32(START_FLAG, v[0])
        self.w32(0x5bb57b, v[1])
        self.wr(0x5bb599, struct.pack('<h', s16v(v[2])))
        self.wr(0x5bb595, struct.pack('<h', s16v(v[3])))
        self.wr(0x5c39ff, struct.pack('<h', s16v(v[4])))
        self.w32(0x5bb59b, v[5])
        self.w32(0x5bb59f, v[6])
        self.w32(0x5bb5a3, v[7])
        self.w32(G_MODE, v[8])
        self.w32(G_5D1A8F, v[9])

    def events(self):
        return list(struct.unpack('<%di' % EVN, self.rd(EVENTS_VA, 4 * EVN)))

    def entries(self):
        return self.rd(ENTRY, NENT * STRIDE)

    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def row_complete(self, row):
        return self.rd(ROWS + row * ROW + COMPLETE_OFF, 1)[0]

    def entry_surface(self, slot):
        return struct.unpack('<I', self.rd(ENTRY + slot * STRIDE + 8, 4))[0]

    # -- effects ---------------------------------------------------------------------------------
    def _on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        if self.audit:
            self.writes.append((address, size, value))
        mode = self.mode
        if mode is None or mode in ('render', 'hit', 'dirty', 'click'):
            return
        off = address - OBJ
        if 0 <= off < OBJ_SPAN:
            if self.in_cleanup:
                return
            if off == 0x46 and size == 1 and mode == 'step':
                self.fx.append((FX['ACTIVE'], value, 0))
            elif off == 0x26 and size == 2 and mode == 'step':
                self.fx.append((FX['ROW'], s16v(value), 0))
            elif off in (0x2e, 0x30) and size == 2 and mode == 'step':
                self.fx.append((FX['SLOT'], s16v(value), 0 if off == 0x2e else 1))
            elif off == 0x50 and size == 4:
                self.fx.append((FX['TICK'], s32v(value), 1 if mode == 'press' else 0))
            return
        if mode not in ('step', 'cleanup'):
            return
        if address == START_FLAG and size == 4:
            self.fx.append((FX['START_FLAG'], s32v(value), 0))
        elif address == G_5D1A8F and size == 4:
            self.fx.append((FX['CLEAR_5D1A8F'], s32v(value), 0))
        elif address in CELL_ADDR and size == CELL_SIZE[CELL_ADDR.index(address)]:
            idx = CELL_ADDR.index(address)
            self.fx.append((FX['CELL'], idx, s32v(value) if size == 4 else s16v(value)))
            if idx == 6:
                self.fx.append((FX['SCENE_CELLS'], self.s32(0x5bb57b), 0))
        elif address == G_MODE and size == 4:
            self.fx.append((FX['ENGINE_MODE'], s32v(value), 0))
        elif EVENTS_VA <= address < EVENTS_VA + 4 * EVN and size == 4 and (address - EVENTS_VA) % 4 == 0:
            self.fx.append((FX['EVENT_FLAG'], (address - EVENTS_VA) // 4, s32v(value)))

    def _entry(self, uc, address, size, user):
        if self.mode != 'step':
            raise OracleError('handler 0x48c1c0 entered outside the dispatcher')
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('handler entered with ECX != 0x624686')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        self.fx.append((FX['ENTER'], row, phase))

    def _reg_a(self, uc, address, size, user):
        slot = self.s16(OBJ + 0x2e)
        self.fx.append((FX['SLOT_REGISTER'], slot, s32v(self.entry_surface(slot))))

    def _reg_b(self, uc, address, size, user):
        slot = self.s16(OBJ + 0x30)
        self.fx.append((FX['SLOT_REGISTER'], slot, s32v(self.entry_surface(slot))))

    def _text(self, index):
        self.fx.append((FX['TEXT_SURFACE'], s32v(u32(self.machine, OBJ + 0x1e)), index))

    def _text0(self, uc, address, size, user):
        self._text(0)

    def _text1(self, uc, address, size, user):
        self._text(1)

    def _text2(self, uc, address, size, user):
        self._text(2)

    def _atoi_at(self, uc, address, size, user):
        self.atoi_ret = s32v(uc.reg_read(X.UC_X86_REG_EAX))

    def _text_list(self, uc, address, size, user):
        self._text(s32v(self.atoi_ret + 2))

    def _surf_a(self, uc, address, size, user):
        slot = self.s16(OBJ + 0x2e)
        self.fx.append((FX['SLOT_SURFACE'], slot, s32v(self.entry_surface(slot))))

    def _surf_b(self, uc, address, size, user):
        slot = self.s16(OBJ + 0x30)
        self.fx.append((FX['SLOT_SURFACE'], slot, s32v(self.entry_surface(slot))))

    def _phase1(self, uc, address, size, user):
        row = self.s16(OBJ + 0x26)
        self.fx.append((FX['PHASE'], self.row_phase(row), 0))

    def _complete(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.fx.append((FX['COMPLETE'], struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0], 0))

    def _release_entry(self, uc, address, size, user):
        if not self.in_cleanup:
            raise OracleError('0x4d3992 reached outside the cleanup')
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        slot = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.fx.append((FX['RELEASE_SLOT'], slot, 0 if slot == self.s16(OBJ + 0x2e) else 1))

    def _cleanup_in(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('cleanup with ECX != 0x624686')
        self.in_cleanup = True

    def _cleanup_out(self, uc, address, size, user):
        self.in_cleanup = False
        self.fx.append((FX['RESET'], 0, 0))

    def _replaced(self, uc, address, size, user):
        self.hooks_fired['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(6)]
        eax = 0
        if address == 0x51dc6c:
            raise OracleError('free reached during an operation')
        elif address == 0x4c2790:
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('image loader ECX')
            kind, name, six, label = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            if kind != b'CIFTREE' or six != 6 or label != LOAD_LABEL:
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.loaded.append((name.decode('latin1'), label.decode('latin1')))
            which = 0 if a[1] == self.rec_addr.get(self.s16(OBJ + 0x26), -1) else 1
            self.fx.append((FX['SURFACE_LOAD'], s32v(eax), which))
        elif address == 0x4c2dfb:
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('image release ECX')
            if a[0] not in (OBJ + 0x1e, OBJ + 0x22):
                raise OracleError('image release of an unexpected cell %#x' % a[0])
            old = u32(uc, a[0])
            if self.in_cleanup:
                self.fx.append((FX['RELEASE_SURFACE'], s32v(old), 0 if a[0] == OBJ + 0x22 else 1))
            self.wr(a[0], bytes(4))
        elif address in RENDER_BLITS:
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('blit ECX')
            if self.mode != 'render':
                raise OracleError('blit outside the render run')
            rc = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            self.blits.append(dict(kind='copy' if address == 0x4c5377 else 'trans', surface=a[0], dst_surface=a[1],
                                   src=rc(a[2]), dst=rc(a[3]), label=cstr(self.rd(a[4], 64)).decode('latin1')))
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
        uc.mem_write(BODY_BASE, bytes(0x10000))
        uc.mem_write(TIB, bytes(0x1000))
        uc.reg_write(X.UC_X86_REG_FPCW, FPCW)
        self.heap_cursor = self.heap_high = HEAP_BASE
        self.allocs.clear()
        self.loaded = []
        self.fx = []
        self.entered = []
        self.handle_i = 0
        self.mode = None
        self.in_cleanup = False
        self.audit = False
        self.expect_fatal = None
        self.rec_addr = {}
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.w32(OBJ, VTABLE)  # the vtable word, as the constructor 0x48baa7 writes it
        self.call(0x48bb17, [], OBJ)  # the constructor's reset, original code

    def install_rows(self, rows, first=0):
        """`rows`: list of dict(rec=bytes, tail=bytes, sub=int). Rows below `first` are completed dummies."""
        total = first + len(rows)
        if total > ROW_MAX:
            raise OracleError('row table too small')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        self.rec_addr = {}
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            body_at = BODY_BASE + BODY_STRIDE * k
            self.wr(body_at, spec['rec'])
            self.rec_addr[i] = body_at
            self.wr(base + 0x30, bytes([0xd8, spec.get('sub', 1)]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def begin(self, mode):
        self.fx = []
        self.entered = []
        self.writes = []
        self.audit = True
        self.mode = mode
        self.in_cleanup = False

    def end(self):
        self.audit = False
        self.mode = None
        self.in_cleanup = False

    def dispatch(self, ticks):
        self.tick_script = list(ticks)
        self.tick_i = 0
        self.wr(0x5c3a47, bytes(4))
        self.begin('step')
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.end()

    def run_mode(self, mode, address, args, ecx, ticks=()):
        self.tick_script = list(ticks)
        self.tick_i = 0
        self.begin(mode)
        try:
            return self.call(address, args, ecx)[0]
        finally:
            self.end()

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

    # -- write audit -------------------------------------------------------------------------------
    def audit_writes(self, mode, total_rows, row_for_click=None):
        """Raise Mismatch for a write outside the modelled set of `mode`. Returns the number of audited writes."""
        allowed = ALLOWED[mode]
        for address, size, value in self.writes:
            off = address - OBJ
            if 0 <= off < OBJ_SPAN:
                bad = [b for b in range(off, off + size) if b not in OBJ_BYTES]
                if 'obj' not in allowed or bad:
                    raise Mismatch('%s wrote object bytes outside the model: +%#x size %d' % (mode, off, size))
                continue
            if ROWS <= address < ROWS + ROW * ROW_MAX:
                row, roff = divmod(address - ROWS, ROW)
                ok_offs = set([COMPLETE_OFF]) | set(range(0x36, 0x3a)) | set(range(0x73, 0x77)) | set(range(PHASE_OFF, PHASE_OFF + 4))
                if mode == 'click':
                    ok = row == row_for_click and all(o in range(PHASE_OFF, PHASE_OFF + 4) for o in range(roff, roff + size))
                else:
                    ok = 'rows' in allowed and row < total_rows and all(o in ok_offs for o in range(roff, roff + size))
                if not ok:
                    raise Mismatch('%s wrote the row table at row %d +%#x size %d' % (mode, row, roff, size))
                continue
            if ENTRY <= address < ENTRY + NENT * STRIDE:
                if 'entries' not in allowed:
                    raise Mismatch('%s wrote the entry table at %#x' % (mode, address))
                continue
            if address in HIT_OUT and 'hit' in allowed:
                continue
            if 'cells' in allowed:
                if address in (START_FLAG, G_MODE, G_5D1A8F) and size == 4:
                    continue
                if address in CELL_ADDR and size == CELL_SIZE[CELL_ADDR.index(address)]:
                    continue
                if EVENTS_VA <= address < EVENTS_VA + 4 * EVN and size == 4 and (address - EVENTS_VA) % 4 == 0:
                    continue
            raise Mismatch('%s wrote outside the model at %#x size %d' % (mode, address, size))
        return len(self.writes)


# ---------------------------------------------------------------------------------------------
# comparison
# ---------------------------------------------------------------------------------------------
def fx_text(t):
    k, a, b = t
    return '%s(%d,%d)' % (FXN.get(k, k), a, b)


def norm_fx(seq):
    out = []
    for k, a, b in seq:
        if k == FX['START_FLAG']:
            b = 0
        out.append((k, s32v(a), s32v(b)))
    return out


def compare_fx(where, orig, nat):
    orig, nat = norm_fx(orig), norm_fx(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        extra = ''
        if os.environ.get('D8_DEBUG'):
            extra = '\n  original: ' + ' '.join(fx_text(t) for t in orig) + '\n  native:   ' + ' '.join(fx_text(t) for t in nat)
        raise Mismatch('%s effect %d: original %s vs native %s (original %d effects, native %d)%s' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None,
            len(orig), len(nat), extra))


CELL_NAMES = ['start_flag_5bb1ca', 'c_5bb57b', 'c_5bb599', 'c_5bb595', 'c_5c39ff', 'c_5bb59b', 'c_5bb59f',
              'c_5bb5a3', 'mode_583999', 'v_5d1a8f']


class Run:
    """One scenario: the original machine `x`, the native driver `nat` and the model of the rows."""

    def __init__(self, x, lib, sc, stats):
        self.x, self.lib, self.sc, self.stats = x, lib, sc, stats
        self.nat = Native(lib)
        self.rows = []
        self.first = 0
        self.phase = {}
        self.complete = {}
        self.sub = {}
        self.view = (0, 0)
        self.fatal_done = False
        self.where = sc['id']

    def close(self):
        self.nat.close()

    # -- setup ---------------------------------------------------------------------------------
    def setup(self):
        sc, x, nat = self.sc, self.x, self.nat
        x.hard_reset()
        x.expect_fatal = sc.get('expect_fatal')
        x.handles = list(sc['handles'])
        x.handle_i = 0
        nat.set_handles(x.handles)
        for i, (surf, height) in enumerate(sc['text']):
            x.w32(TEXT_SURF + 4 * i, surf)
            x.w32(TEXT_HEIGHT + 4 * i, height)
            self.lib.d8o_set_text(nat.h, i, surf & 0xffffffff, s32v(height))
        cells = [0x7a7a, 0x1111, 0x2222, 0x3333, 0x4444, 0x55555, 0x66666, 0x77777, 3, 0x55]
        x.set_cells(cells)
        nat.set_cells(cells)
        for i in range(EVN):
            v = 0x1000 + i * 0x101
            x.w32(EVENTS_VA + 4 * i, v)
            self.lib.d8o_set_event(nat.h, i, v)
        for i, v in sc['events'].items():
            x.w32(EVENTS_VA + 4 * i, v)
            self.lib.d8o_set_event(nat.h, i, v)
        for s in sc['busy']:
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            self.lib.d8o_set_busy(nat.h, s, 1)
        self.install(sc['rows'], sc['first'])
        self.compare_state('initial')

    def install(self, rows, first):
        self.rows = [dict(r, rec=bytearray(r['rec'])) for r in rows]
        self.first = first
        self.x.install_rows([dict(r, rec=bytes(r['rec'])) for r in self.rows], first)
        self.phase = {}
        self.complete = {}
        self.sub = {}
        for i in range(first + len(rows)):
            self.phase[i] = 0
            self.complete[i] = 1 if i < first else 0
            self.sub[i] = 1 if i < first else self.rows[i - first].get('sub', 1)

    def spec(self, row):
        return self.rows[row - self.first]

    def rec(self, row):
        return bytes(self.spec(row)['rec'])

    # -- state comparison ----------------------------------------------------------------------
    def compare_state(self, where, rows=True):
        x, nat, st = self.x, self.nat, self.stats
        oo, no = x.object(), nat.obj()
        st['state_compares'] += 1
        st['object_fields'] += len(oo)
        if oo != no:
            k = next(i for i in range(len(oo)) if oo[i] != no[i])
            raise Mismatch('%s object field %s: original %d native %d' % (where, OBJ_NAMES[k], oo[k], no[k]))
        oc, nc = x.cells(), nat.cells()
        st['cell_compares'] += len(oc)
        if oc != nc:
            k = next(i for i in range(len(oc)) if oc[i] != nc[i])
            raise Mismatch('%s cell %s: original %#x native %#x' % (where, CELL_NAMES[k], oc[k] & 0xffffffff, nc[k] & 0xffffffff))
        oe, ne = x.events(), nat.events()
        st['event_compares'] += EVN
        if oe != ne:
            k = next(i for i in range(EVN) if oe[i] != ne[i])
            raise Mismatch('%s event flag %d: original %d native %d' % (where, k, oe[k], ne[k]))
        ea, eb = x.entries(), nat.entries()
        st['entry_bytes'] += len(ea)
        if ea != eb:
            k = next(i for i in range(len(ea)) if ea[i] != eb[i])
            raise Mismatch('%s entry table slot %#x +%#x original %02x native %02x' % (where, k // STRIDE, k % STRIDE, ea[k], eb[k]))
        if rows:
            for i in range(self.first + len(self.rows)):
                st['row_compares'] += 1
                if x.row_phase(i) != self.phase[i]:
                    raise Mismatch('%s row %d phase: original %d native-model %d' % (where, i, x.row_phase(i), self.phase[i]))
                if x.row_complete(i) != self.complete[i]:
                    raise Mismatch('%s row %d completion byte: original %d native-model %d' % (where, i, x.row_complete(i), self.complete[i]))

    def audit(self, mode, row_for_click=None):
        n = self.x.audit_writes(mode, self.first + len(self.rows), row_for_click)
        self.stats['audited_writes'] += n

    # -- object helpers ------------------------------------------------------------------------
    def set_obj(self, **fields):
        cur = self.x.object()
        for k, v in fields.items():
            cur[OBJ_NAMES.index(k)] = v
        self.x.set_object(cur)
        self.nat.set_obj(self.x.object())

    # -- the dispatcher step -------------------------------------------------------------------
    def gate_open(self, spec, nat_events):
        t = spec.get('tail') or b''
        if not t:
            return True
        rec = struct.unpack_from('<8h', t, 0)
        return nat_events[rec[1]] == rec[2]

    def dispatch(self, ticks, where):
        x, nat, st = self.x, self.nat, self.stats
        ticks = list(ticks) + [ticks[-1]] * 8   # shared padding: both sides read the same values
        fatal = None
        x.loaded = []
        handles_before = x.handle_i
        try:
            x.dispatch(ticks)
        except Fatal as error:
            fatal = error.address
            x.end()
        del handles_before
        st['dispatches'] += 1
        entered = list(x.entered)
        ofx = list(x.fx)
        self.audit('step')
        nat.set_ticks(ticks)
        names_all, nfx = [], []
        expected, got = [], [r for r, _ in entered]
        n_done = 0
        for i in range(self.first + len(self.rows)):
            if nat.cells()[8] != 3:
                break
            if self.complete[i] or (i >= self.first and self.spec(i).get('skip')):
                continue
            if not self.gate_open(self.spec(i), nat.events()):
                continue
            expected.append(i)
            if n_done >= len(entered):
                if fatal is None:
                    raise Mismatch('%s the model expects row %d but the original did not enter the handler' % (where, i))
                break
            row, ophase = entered[n_done]
            if row != i:
                raise Mismatch('%s handler entries %s but the gate model says row %d next' % (where, got, i))
            if ophase != self.phase[i]:
                raise Mismatch('%s row %d entry phase: original %d native-model %d' % (where, i, ophase, self.phase[i]))
            rec = self.rec(i)
            status, why, fx, names, res = nat.step(rec, i, self.phase[i])
            nfx.append((FX['ENTER'], i, self.phase[i]))
            nfx.extend(fx)
            names_all.extend(names)
            st['steps'] += 1
            st['phase%d_steps' % self.phase[i] if self.phase[i] < 3 else 'phase_above_2_steps'] += 1
            n_done += 1
            if fatal is not None and n_done == len(entered):
                if status != 4:
                    raise Mismatch('%s original reached fatal path %#x but native status %d (%s)' % (where, fatal, status, why))
                break
            if status != 0:
                raise Mismatch('%s native refused (status %d: %s) where the original ran' % (where, status, why))
            if bool(res[1]) != (self.phase[i] == 0):
                raise Mismatch('%s initialized flag %d for phase %d' % (where, res[1], self.phase[i]))
            if bool(res[2]) != (self.phase[i] == 2):
                raise Mismatch('%s finished flag %d for phase %d' % (where, res[2], self.phase[i]))
            if self.phase[i] > 2:
                st['phase_above_2_visits'] += 1
            if res[2]:
                # 0x42ba3a completes the row the OBJECT holds (+0x26), which is the visited row in every normal flow
                r = next(a for k, a, _b in fx if k == FX['COMPLETE'])
                if r not in self.sub:
                    raise Mismatch('%s completion of row %d outside the table' % (where, r))
                self.complete[r] = 1 if self.sub[r] == 1 else 0
                self.phase[r] = 0
            else:
                self.phase[i] = res[0]
        if n_done != len(entered):
            raise Mismatch('%s handler entries %s but the model ran %s' % (where, got, expected[:n_done]))
        st['gate_open_rows' if entered else 'gate_closed_ticks'] += len(entered) or 1
        compare_fx(where, ofx, nfx)
        st['effects'] += len(nfx)
        for t in ofx:
            st['effect_kinds'][FXN[t[0]]] += 1
        if x.loaded != names_all:
            raise Mismatch('%s loaded image names/labels differ: original %r native %r' % (where, x.loaded, names_all))
        st['image_loads'] += len(names_all)
        if nat.lib.d8o_tick_underrun(nat.h):
            raise Mismatch('%s native used more GetTickCount values than the script holds' % where)
        used_o = x.tick_i
        used_n = nat.lib.d8o_ticks_used(nat.h)
        if used_o != used_n:
            raise Mismatch('%s GetTickCount calls: original %d native %d' % (where, used_o, used_n))
        st['tick_calls'] += used_o
        if nat.lib.d8o_bad_slot_calls(nat.h) or nat.lib.d8o_bad_event_calls(nat.h):
            raise Mismatch('%s native used an out-of-range slot or event index' % where)
        if fatal is not None:
            st['fatal_paths_matched'] += 1
            self.fatal_done = True
            if fatal != self.sc.get('expect_fatal'):
                raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
        self.compare_state(where)
        return entered

    # -- direct methods ------------------------------------------------------------------------
    def row_of_obj(self):
        return self.x.s16(OBJ + 0x26)

    def hit(self, where, px, py, g):
        x, nat, st = self.x, self.nat, self.stats
        saved = x.rd(0x5d162d, 16)
        rng = random.Random(px * 7919 + py * 104729 + g['cur'])
        sent = [rng.getrandbits(32) | 0x80000000 for _ in HIT_OUT]
        sent[0] = g['cur'] & 0xffffffff
        for a, v in zip(HIT_OUT, sent):
            x.w32(a, v)
        x.w32(HIT_IN['item'], (g['item'] & 0xffff) | 0x5a5a0000)
        x.w32(HIT_IN['flag'], g['flag'])
        x.w32(HIT_IN['v0377'], g['v0377'])
        x.w32(HIT_IN['v571'], g['v571'])
        ret = x.run_mode('hit', 0x48bd91, [(px & 0xffff) | 0xa5a50000, (py & 0xffff) | 0x5a5a0000], OBJ)
        self.audit('hit')
        out = [u32(x.machine, a) for a in HIT_OUT]
        x.wr(0x5d162d, saved)
        row = self.row_of_obj()
        rec = self.rec(row) if row in self.rows_index() else bytes(0x160)
        inp = (C.c_int32 * 5)(g['item'], s32v(g['flag']), s32v(g['v0377']), s32v(g['v571']), s32v(g['cur']))
        o = (C.c_int32 * 9)()
        status = nat.lib.d8o_hit(nat.h, cbuf(rec), len(rec), px, py, inp, o)
        if status != 0:
            raise Mismatch('%s native hit test status %d' % (where, status))
        if bool(ret & 0xff) != bool(o[0]):
            raise Mismatch('%s hit result: original %d native %d' % (where, ret & 0xff, o[0]))
        finals = [o[2] if o[1] else sent[0], o[3] if o[0] else sent[1], o[4] if o[0] else sent[2],
                  o[6] if o[5] else sent[3], o[7] if o[0] else sent[4], o[8] if o[0] else sent[5]]
        for k, a in enumerate(HIT_OUT):
            if out[k] != (finals[k] & 0xffffffff):
                raise Mismatch('%s cell %#x: original %#x native %#x' % (where, a, out[k], finals[k] & 0xffffffff))
        st['hit_calls'] += 1
        st['hits'] += 1 if o[0] else 0
        st['hit_cells'] += len(HIT_OUT)
        self.compare_state(where, rows=False)
        return bool(o[0])

    def rows_index(self):
        return range(self.first, self.first + len(self.rows))

    def click(self, where, cand):
        x, nat, st = self.x, self.nat, self.stats
        row = self.row_of_obj()
        rec = self.rec(row) if row in self.rows_index() else bytes(0x160)
        hot = x.s16(OBJ + 0x28)
        count = struct.unpack_from('<h', rec, 0x15e)[0]
        if cand == CAND['LINK'] and (hot < 0 or hot >= count or row not in self.rows_index()):
            # S4: the original reads outside the entry array; the native kernel rejects
            snap = (nat.obj(), nat.cells(), nat.entries(), nat.events())
            out = (C.c_int32 * 2)()
            status = nat.lib.d8o_click(nat.h, cbuf(rec), len(rec), cand, out)
            if status != 2:
                raise Mismatch('%s native click on an invalid link index returned %d' % (where, status))
            object_untouched(self, where, *snap)
            st['rejections'] += 1
            st['rejection_kinds']['click_hot'] += 1
            return
        if row not in self.rows_index() and cand in (CAND['EXIT'], CAND['LINK']):
            st['click_inactive_skipped'] += 1   # unreachable: the pointer cascade only calls the click after a hit
            return
        x.w32(G_CAND, cand)
        x.run_mode('click', 0x48c0ac, [], OBJ)
        self.audit('click', row_for_click=row)
        out = (C.c_int32 * 2)()
        status = nat.lib.d8o_click(nat.h, cbuf(rec), len(rec), cand, out)
        if status != 0:
            raise Mismatch('%s native click status %d' % (where, status))
        if out[0] and row in self.rows_index():
            self.phase[row] = out[1] & 0xffffffff
        st['click_calls'] += 1
        self.compare_state(where)

    def press(self, where, cand, ticks):
        x, nat, st = self.x, self.nat, self.stats
        x.w32(G_CAND, cand)
        row = self.row_of_obj()
        rph = self.phase[row] if row in self.rows_index() else 0
        nat.set_ticks(ticks)
        nat.clear()
        x.fx = []
        x.run_mode('press', 0x48c148, [], OBJ, ticks)
        self.audit('press')
        status = nat.lib.d8o_press(nat.h, rph, cand)
        if status != 0:
            raise Mismatch('%s native press status %d' % (where, status))
        compare_fx(where, x.fx, nat.fx())
        st['effects'] += len(x.fx)
        if x.tick_i != nat.lib.d8o_ticks_used(nat.h):
            raise Mismatch('%s press GetTickCount calls: original %d native %d' % (where, x.tick_i, nat.lib.d8o_ticks_used(nat.h)))
        st['tick_calls'] += x.tick_i
        st['press_calls'] += 1
        self.compare_state(where)

    def dirty(self, where):
        x, nat, st = self.x, self.nat, self.stats
        x.run_mode('dirty', 0x48bc38, [], OBJ)
        self.audit('dirty')
        if nat.lib.d8o_dirty(nat.h) != 0:
            raise Mismatch('%s native dirty status' % where)
        st['dirty_calls'] += 1
        self.compare_state(where)

    def cleanup(self, where):
        x, nat, st = self.x, self.nat, self.stats
        x.run_mode('cleanup', 0x48bb86, [], OBJ)
        self.audit('cleanup')
        ofx = list(x.fx)
        nat.clear()
        if nat.lib.d8o_cleanup(nat.h) != 0:
            raise Mismatch('%s native cleanup status' % where)
        compare_fx(where, ofx, nat.fx())
        st['effects'] += len(ofx)
        st['cleanups'] += 1
        self.compare_state(where)

    def render(self, where, ox, oy, saved, back, sa, sb):
        x, nat, st = self.x, self.nat, self.stats
        obj = x.object()
        visible, row = obj[1], obj[4]
        slot_a, slot_b = obj[6], obj[7]
        if row not in self.rows_index() or (visible and (slot_a == -1 or slot_b == -1)):
            st['render_skipped_unreachable'] += 1  # entry released: the engine never calls the callback
            return
        x.w32(G_ORIGIN_X, ox)
        x.w32(G_ORIGIN_Y, oy)
        x.w32(G_BACK, back)
        # distinct surface handles so that every blit source is identifiable
        x.w32(ENTRY + 1 * STRIDE + 8, saved)
        self.lib.d8o_set_entry_u32(nat.h, 1, 8, saved & 0xffffffff)
        if visible:
            x.w32(ENTRY + slot_a * STRIDE + 8, sa)
            x.w32(ENTRY + slot_b * STRIDE + 8, sb)
            self.lib.d8o_set_entry_u32(nat.h, slot_a, 8, sa & 0xffffffff)
            self.lib.d8o_set_entry_u32(nat.h, slot_b, 8, sb & 0xffffffff)
        x.blits = []
        x.run_mode('render', 0x48cc70, [], 0)
        self.audit('render')
        rec = self.rec(row) if row in self.rows_index() else self.rec(self.first)
        status, plan = nat.plan(rec, ox, oy)
        if status != 0:
            raise Mismatch('%s native plan status %d' % (where, status))
        st['render_calls'] += 1
        bl = x.blits
        if not plan['valid']:
            if bl:
                raise Mismatch('%s original blitted although the object is not visible' % where)
            return
        if len(bl) != len(plan['blits']):
            raise Mismatch('%s original issued %d blits, native plan has %d' % (where, len(bl), len(plan['blits'])))
        src_names = {saved: 0, sa: 1, sb: 2}
        for k, (o, n) in enumerate(zip(bl, plan['blits'])):
            if o['kind'] != ('copy' if n['kind'] == 0 else 'trans'):
                raise Mismatch('%s blit %d kind: original %s native %d' % (where, k, o['kind'], n['kind']))
            if src_names.get(o['surface'], -1) != n['source']:
                raise Mismatch('%s blit %d source surface: original %#x native source %d' % (where, k, o['surface'], n['source']))
            if o['dst_surface'] != (back & 0xffffffff):
                raise Mismatch('%s blit %d destination surface %#x' % (where, k, o['dst_surface']))
            if o['src'] != n['src'] or o['dst'] != n['dst']:
                raise Mismatch('%s blit %d rects: original src %s dst %s native src %s dst %s' % (where, k, o['src'], o['dst'], n['src'], n['dst']))
            if o['label'] != n['label']:
                raise Mismatch('%s blit %d label: original %r native %r' % (where, k, o['label'], n['label']))
            st['blit_args'] += 5
        st['blit_calls'] += len(bl)
        self.compare_state(where, rows=False)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def text_default():
    return [(0x5100 + 0x11 * i, h) for i, h in enumerate((300, 450, 0x7fff, -5, 100000, 77))]


def scenario_list(seed=34):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, steps, group, **kw):
        sc = dict(id=sid, rows=rows, steps=steps, group=group,
                  handles=kw.pop('handles', [0x7001 + 0x10 * i for i in range(24)]),
                  text=kw.pop('text', text_default()), first=kw.pop('first', 0), busy=kw.pop('busy', []),
                  quick=kw.pop('quick', False), expect_fatal=kw.pop('expect_fatal', None), events=kw.pop('events', {}))
        sc.update(kw)
        scs.append(sc)

    def R(rec, sub=1, tail=b''):
        return dict(rec=rec, sub=sub, tail=tail)

    INIT = [('dispatch', [100])]

    # -- phase 0: surface names ---------------------------------------------------------------------------
    names = [
        (b'MAP_A', b'MAP_B', 'diff', True), (b'MAP_A', b'', 'empty2', True), (b'MAP_A', b'map_a', 'case', True),
        (b'MAP_A', b'MAP_A', 'same', False), (b'USE_AUTOTEXT1', b'', 'at1', True), (b'USE_AUTOTEXT2', b'OVER', 'at2', True),
        (b'USE_AUTOTEXT3', b'use_autotext3', 'at3case', True), (b'USE_LISTPAGE0', b'', 'lp0', True),
        (b'USE_LISTPAGE1', b'OVER_B', 'lp1', False), (b'USE_LISTPAGE2', b'', 'lp2', False), (b'USE_LISTPAGE3', b'USE_LISTPAGE3', 'lp3', True),
        (b'USE_LISTPAGE-2', b'', 'lpm2', False), (b'USE_LISTPAGE-1', b'', 'lpm1', False), (b'USE_LISTPAGE', b'', 'lpbare', False),
        (b'USE_LISTPAGE 1', b'', 'lpspace', False), (b'USE_LISTPAGE+2', b'', 'lpplus', False), (b'USE_LISTPAGEabc', b'', 'lpabc', False),
        (b'USE_LISTPAGE0003', b'', 'lp0003', False), (b'USE_LISTPAGE2x', b'', 'lp2x', False),
        (b'USE_LISTPAGE4294967297', b'', 'lpwrap', False), (b'USE_LISTPAGE4294967295', b'', 'lpwrapm1', False),
        (b'USE_AUTOTEXT4', b'', 'at4', True), (b'USE_AUTOTEXT', b'', 'atbare', False), (b'use_autotext1', b'', 'atlower', False),
        (b'USE_AUTOTEXT1X', b'', 'at1x', False), (b'USE_AUTOTEXT10', b'', 'at10', False), (b'USE_LISTPAG', b'', 'lpshort', False),
        (b'USE_LISTPAGE3', b'Use_ListPage3', 'lp3case', False), (b'', b'', 'emptyname', False), (b'', b'X', 'emptyname_x', False),
        (b'A' * 32, b'a' * 32, 'long32', False), (b'A' * 32, b'B' * 32, 'long32b', False),
        (b'USE_AUTOTEXT1', b'USE_AUTOTEXT2', 'at1_at2', False), (b'MAP_A', b'USE_AUTOTEXT1', 'file_at', False),
        (b'USE_LISTPAGE2', b'USE_LISTPAGE2 ', 'trail', False), (b'MAP\xe9A', b'map\xc9a', 'highbit', False),
        (b'USE_LISTPAGE\xff', b'', 'lphigh', False),
    ]
    for k, (n1, n2, tag, quick) in enumerate(names):
        rec = build_record(n1, n2, mode=2 if k % 2 else 0, junk=0x40 if k % 3 == 0 else 0, fps=1 + k)
        S('p0:name_%s' % tag, [R(rec)], INIT + [('dispatch', [200]), ('dispatch', [300])], 'phase0', quick=quick)
    # out-of-range pages are deliberate safety rejections (S1)
    for n in (b'USE_LISTPAGE4', b'USE_LISTPAGE5', b'USE_LISTPAGE9', b'USE_LISTPAGE99', b'USE_LISTPAGE-3', b'USE_LISTPAGE-100',
              b'USE_LISTPAGE1073741824', b'USE_LISTPAGE-2147483648'):
        S('rej:page_%s' % n.decode(), [R(build_record(n))], [('reject_step', 0, 0, 'page')], 'reject', quick=n in (b'USE_LISTPAGE4', b'USE_LISTPAGE-3'))

    # -- phase 0: rect flags, mode byte, limits, start positions ------------------------------------------
    edge_rects = [(0, 0, 0, 0), (5, 5, 5, 9), (5, 5, 9, 5), (9, 9, 5, 5), (1, 1, 2, 2), (-5, -5, -4, -4), (10, 10, 11, 9),
                  (0x7fffffff - 1, 0, 0x7fffffff, 1), (-0x80000000, 0, -0x7fffffff, 1), (3, 4, 2, 9), (3, 4, 9, 3)]
    for k in range(10):
        inacts = [rng.choice(edge_rects) for _ in range(4)]
        downs = [rng.choice(edge_rects) for _ in range(4)]
        S('p0:rects_%d' % k, [R(build_record(b'MAP_R', b'MAP_S', mode=2, inacts=inacts, downs=downs))], INIT, 'phase0', quick=k < 2)
    S('p0:rects_all_empty', [R(build_record(b'MAP_R', inacts=[(0, 0, 0, 0)] * 4, downs=[(1, 1, 1, 1)] * 4))], INIT, 'phase0', quick=True)
    for k in range(16):
        inacts = [edge_rects[(k >> i) & 1] if (k >> i) & 1 == 0 else (0, 0, 9, 9) for i in range(4)]
        downs = [(0, 0, 9, 9) if (k >> i) & 1 == 0 else (4, 4, 4, 4) for i in range(4)]
        S('p0:rectflags_%d' % k, [R(build_record(b'MAP_R', inacts=inacts, downs=downs))], INIT, 'phase0')
    for k in range(12):
        lim = tuple(rng.choice([0, 1, -1, 200, 300, 0x7fff, 0x8000, 0x12345, -0x12345, 0x7fffffff, -0x80000000, rng.randrange(-5000, 5000)]) for _ in range(4))
        src = tuple(rng.choice([0, 7, 100, 0x7fff, -300, rng.randrange(-200, 900)]) for _ in range(4))
        pos = (rng.choice([0, 3, -7, 0x7ff0, -0x7ff0, 100]), rng.choice([0, 5, -9, 0x7ff0, 400]))
        pre = {'pos_41': pos[0], 'pos_43': pos[1]}
        S('p0:limits_%d' % k, [R(build_record(b'USE_AUTOTEXT%d' % (k % 3 + 1) if k % 2 else b'MAP_L', lim=lim, src=src))],
          [('setobj', pre)] + INIT, 'phase0', quick=k < 4)
    # start positions exactly around each limit
    base = build_record(b'MAP_P', lim=(10, 20, 700, 500), src=(0, 0, 200, 100))
    lims = rec_limits(base)
    for k, (p41, p43) in enumerate([(lims['limit_4a'], lims['limit_4e']), (lims['limit_4a'] - 1, lims['limit_4e'] - 1),
                                    (lims['limit_4a'] + 1, lims['limit_4e'] + 1), (lims['limit_48'], lims['limit_4c']),
                                    (lims['limit_48'] + 1, lims['limit_4c'] + 1), (lims['limit_48'] - 1, lims['limit_4c'] - 1),
                                    (lims['limit_4a'], lims['limit_4c']), (lims['limit_48'], lims['limit_4e']),
                                    (-0x8000, 0x7fff), (0x7fff, -0x8000)]):
        S('p0:startpos_%d' % k, [R(base)], [('setobj', {'pos_41': p41, 'pos_43': p43})] + INIT, 'phase0', quick=k < 4)
    # text height formula (the page height replaces the base limit)
    for k, h in enumerate((300, 450, 0x7fff, -5, 100000, 77)):
        S('p0:textheight_%d' % k, [R(build_record(b'USE_AUTOTEXT%d' % (k + 1) if k < 3 else b'USE_LISTPAGE%d' % (k - 2), src=(0, 0, 200, 100 + k)))],
          [('setobj', {'pos_43': 1000})] + INIT, 'phase0', quick=k < 4)

    # -- second visit of phase 0 while the object is still set up; second surface already set --------------
    for k, (n1, n2) in enumerate(((b'MAP_A', b'MAP_B'), (b'USE_AUTOTEXT1', b'MAP_B'), (b'USE_LISTPAGE2', b''), (b'MAP_A', b'map_a'), (b'MAP_A', b''))):
        S('p0:revisit_%d' % k, [R(build_record(n1, n2))],
          INIT + [('setphase', 0, 0), ('dispatch', [100]), ('setobj', {'pos_41': 55, 'pos_43': 66}), ('setphase', 0, 0), ('dispatch', [100]), ('dispatch', [500])],
          'phase0', quick=k < 3)
    S('p0:surface2_preset', [R(build_record(b'MAP_A', b'MAP_B'))], [('setobj', {'surface2': 0x9999}), ('dispatch', [10])], 'phase0', quick=True)
    S('p0:surface2_preset_same', [R(build_record(b'MAP_A', b'map_a'))], [('setobj', {'surface2': 0x9999}), ('dispatch', [10])], 'phase0')
    S('p0:surface1_preset', [R(build_record(b'MAP_A', b'MAP_B'))], [('setobj', {'surface1': 0x8888}), ('dispatch', [10])], 'phase0', quick=True)
    S('p0:both_preset', [R(build_record(b'MAP_A', b'MAP_B'))], [('setobj', {'surface1': 0x8888, 'surface2': 0x9999}), ('dispatch', [10])], 'phase0')
    S('p0:borrowed_preset', [R(build_record(b'USE_AUTOTEXT2', b'MAP_B'))], [('setobj', {'borrowed': 1}), ('dispatch', [10])], 'phase0')
    S('p0:handle_zero', [R(build_record(b'MAP_A', b'MAP_B'))], INIT + [('dispatch', [10])], 'phase0', handles=[0, 0])

    # -- phase > 2 does nothing -------------------------------------------------------------------------
    S('p0:phase_above_2', [R(build_record(b'MAP_A'))], INIT + [('setphase', 0, 3), ('dispatch', [1]), ('setphase', 0, 0xffffffff), ('dispatch', [1]),
                                                       ('setphase', 0, 0x100), ('dispatch', [1]), ('setphase', 0, 1), ('dispatch', [1000])], 'phase0', quick=True)

    # -- generic Z entry allocation: busy seeds, first free, exhaustion (fatal path of 0x4d39f9) -------------
    S('slots:busy_low', [R(build_record(b'MAP_A', b'MAP_B'))], INIT + [('cleanup',)], 'slots', busy=[0x18, 0x19, 0x1a], quick=True)
    S('slots:busy_gap', [R(build_record(b'MAP_A', b'MAP_B', mode=2)), R(build_record(b'MAP_C'))], INIT + [('dispatch', [5]), ('dirty',), ('cleanup',)], 'slots',
      busy=[0x18, 0x1a, 0x1b, 0x3e], quick=True)
    S('slots:last_two_free', [R(build_record(b'MAP_A', b'MAP_B'))], INIT + [('cleanup',)], 'slots', busy=list(range(0x18, 0x3e)))
    S('slots:one_free', [R(build_record(b'MAP_A', b'MAP_B'))], INIT, 'slots', busy=list(range(0x18, 0x3f)), expect_fatal=0x52139c, quick=True)
    S('slots:exhausted', [R(build_record(b'MAP_A'))], INIT, 'slots', busy=list(range(0x18, 0x40)), expect_fatal=0x52139c, quick=True)
    S('slots:below_range_ignored', [R(build_record(b'MAP_A'))], INIT + [('cleanup',)], 'slots', busy=[0x00, 0x10, 0x17, 0x40, 0x57], quick=True)

    # -- rows, gate, dependency tails -----------------------------------------------------------------------
    S('rows:row0', [R(build_record(b'MAP_A', b'MAP_B'))], INIT, 'rows', quick=True)
    for first in (1, 7, 100, 199):
        S('rows:first_%d' % first, [R(build_record(b'MAP_A', b'MAP_B')), R(build_record(b'USE_AUTOTEXT1'), sub=2)],
          INIT + [('dispatch', [5]), ('dispatch', [6])], 'rows', first=first, quick=first == 100)
    S('rows:two_singleton', [R(build_record(b'MAP_A', b'MAP_B')), R(build_record(b'MAP_C', b'MAP_D', lim=(0, 0, 500, 400)))],
      INIT + [('dispatch', [10]), ('dispatch', [20])], 'rows', quick=True)
    gate41 = struct.pack('<8h', 2, 41, 0, 0, 0, 0, 0, 0)
    S('rows:second_after_cleanup', [R(build_record(b'MAP_A', b'MAP_B'), sub=1), R(build_record(b'USE_AUTOTEXT3', b'MAP_Z'), sub=1, tail=gate41)],
      [('dispatch', [1]), ('setobj', {'exit_clicked': 1}), ('setphase', 0, 2), ('dispatch', [1]), ('events', {41: 0}), ('dispatch', [1]),
       ('dispatch', [2000]), ('setobj', {'exit_clicked': 1}), ('setphase', 1, 2), ('dispatch', [1]), ('dispatch', [1])], 'rows', events={41: 9}, quick=True)
    S('rows:second_after_cleanup_b', [R(build_record(b'MAP_A', b'MAP_B', exit_scene=77, exit_flag=5, exit_val=3), sub=2),
                                      R(build_record(b'USE_AUTOTEXT3', b'MAP_Z'), sub=2, tail=gate41)],
      [('dispatch', [1]), ('setobj', {'exit_clicked': 1}), ('setphase', 0, 2), ('dispatch', [1]), ('setmode', 3), ('events', {41: 0}), ('dispatch', [1]),
       ('dispatch', [1]), ('setphase', 1, 2), ('dispatch', [1]), ('dispatch', [1])], 'rows', events={41: 9})
    for gi, (gidx, gval) in enumerate(((40, 1), (41, 0), (42, 5))):
        tail = struct.pack('<8h', 2, gidx, gval, 0, 0, 0, 0, 0)
        S('rows:gate%d' % gi, [R(build_record(b'MAP_G%d' % gi), tail=tail), R(build_record(b'MAP_H', b'MAP_I'))],
          INIT + [('events', {gidx: gval}), ('dispatch', [1]), ('dispatch', [1]), ('events', {gidx: gval + 1}), ('dispatch', [1]), ('events', {gidx: gval}), ('dispatch', [1000])],
          'rows', events={gidx: gval + 7}, quick=gi == 0)
    S('rows:gate_exit_flag', [R(build_record(b'MAP_G', exit_flag=40, exit_val=1, exit_scene=NO_SCENE, flag149=3), sub=2,
                                tail=struct.pack('<8h', 2, 41, 0, 0, 0, 0, 0, 0))],
      [('events', {41: 0}), ('dispatch', [1]), ('setobj', {'exit_clicked': 1}), ('setphase', 0, 2), ('dispatch', [1]), ('dispatch', [1])], 'rows', events={40: 9})
    S('rows:mode4_blocks', [R(build_record(b'MAP_A'))], [('setmode', 4), ('dispatch', [1]), ('setmode', 2), ('dispatch', [1]), ('setmode', 3), ('dispatch', [1])], 'rows', quick=True)
    S('rows:skip_flag', [R(build_record(b'MAP_A')), R(build_record(b'MAP_B'))],
      [('skipflag', 0, 1), ('dispatch', [1]), ('skipflag', 0, 0), ('dispatch', [1])], 'rows')

    # -- phase 1: scrolling ---------------------------------------------------------------------------------------
    P1 = build_record(b'MAP_A', lim=(0, 0, 800, 600), src=(0, 0, 200, 100), fps=10)   # limits: x 0..600, y 0..500
    L1 = rec_limits(P1)
    p1_rows = [R(P1)]

    def p1(direction, p41, p43, tick, now, can=None, extra=None):
        d = dict(dir=direction, pos_41=p41, pos_43=p43, tick=tick, pressed=0)
        for i, c in enumerate(can or (1, 1, 1, 1)):
            d['can%d' % i] = c
        d.update(extra or {})
        return ('p1', d, now)

    # period behaviour: before, exactly, several periods; wraparound at 2^32; every direction
    steps = []
    for direction in (0, 1, 2, 3, 0xff, 4, 0x80):
        for elapsed in (0, 99, 100, 101, 199, 200, 250, 1000, 0xffffffff, 0x80000000):
            steps.append(p1(direction, 300, 250, 5000, (5000 + elapsed) & 0xffffffff))
        steps.append(p1(direction, 300, 250, 0xfffffff0, 0x40))       # wrap of the tick
        steps.append(p1(direction, 300, 250, 0xffffffff, 99))
        steps.append(p1(direction, 300, 250, 0xffffffff, 100))
    S('p1:periods', p1_rows, INIT + steps, 'phase1', quick=True)
    # fps sweep: every frame rate byte, around the period
    sweep = []
    for fps in range(1, 256):
        sweep.append(('setrec', 0, 0x134, bytes([fps])))
        period = 1000 // fps
        for elapsed in (period - 1, period, 2 * period + 1, 7 * period):
            sweep.append(p1(rng.choice((0, 1, 2, 3)), 300, 250, 7000, 7000 + elapsed))
    S('p1:fps_all', p1_rows, INIT + sweep, 'phase1')
    quick_fps = [('setrec', 0, 0x134, bytes([f])) for f in (1,)]
    qs = []
    for fps in (1, 2, 3, 7, 10, 33, 60, 100, 255):
        qs.append(('setrec', 0, 0x134, bytes([fps])))
        period = 1000 // fps
        for elapsed in (period - 1, period, 2 * period + 1, 5000):
            qs.append(p1(rng.choice((0, 1, 2, 3)), 300, 250, 7000, 7000 + elapsed))
    del quick_fps
    S('p1:fps_quick', p1_rows, INIT + qs, 'phase1', quick=True)
    # the 16-bit step count (elapsed / period above 65535) and position wrap
    big = []
    for fps in (255, 100, 10, 1):
        big.append(('setrec', 0, 0x134, bytes([fps])))
        for direction in (0, 1, 2, 3):
            for elapsed in (65535 * (1000 // fps), 65536 * (1000 // fps), 65537 * (1000 // fps) + 3, 0x7fffffff, 0xfffffff0):
                big.append(p1(direction, rng.randrange(-30000, 30000), rng.randrange(-30000, 30000), 0, elapsed & 0xffffffff))
    S('p1:step_wrap', p1_rows, INIT + big, 'phase1', quick=False)
    # clamps: each limit reached from both sides, with steps = elapsed / period (fps 10 -> period 100)
    cl = []
    lim = {0: ('pos_43', L1['limit_4e'], -1), 1: ('pos_43', L1['limit_4c'], +1), 2: ('pos_41', L1['limit_4a'], -1), 3: ('pos_41', L1['limit_48'], +1)}
    for direction, (field, limit, sign) in lim.items():
        for steps_n in (1, 2, 5):
            for delta in (-2, -1, 0, 1, 2):
                for can in ((1, 1, 1, 1), (0, 0, 0, 0), (1, 0, 1, 0), (0, 1, 0, 1)):
                    pos = limit - sign * steps_n + sign * delta * -1   # delta < 0: stops short; 0: exactly; > 0: passes the limit
                    pos = limit - sign * steps_n - sign * delta
                    p41, p43 = (300, pos) if field == 'pos_43' else (pos, 250)
                    cl.append(p1(direction, p41, p43, 1000, 1000 + 100 * steps_n, can))
    S('p1:clamps', p1_rows, INIT + cl, 'phase1', quick=True)
    # clamp reached from the wrong direction and positions already outside the limits
    out = []
    for direction in (0, 1, 2, 3):
        for p41, p43 in ((L1['limit_4a'] - 5, 250), (L1['limit_48'] + 5, 250), (300, L1['limit_4e'] - 5), (300, L1['limit_4c'] + 5),
                         (-0x8000, -0x8000), (0x7fff, 0x7fff)):
            out.append(p1(direction, p41, p43, 0, 100))
    S('p1:outside_limits', p1_rows, INIT + out, 'phase1')
    # pressed flag and the render/limit text surfaces keep the same logic
    S('p1:text_limits', [R(build_record(b'USE_AUTOTEXT1', lim=(0, 0, 800, 600), src=(0, 0, 200, 100), fps=10))],
      INIT + [p1(1, 300, 440, 100, 600), p1(1, 300, 440, 100, 600), p1(0, 300, 10, 100, 1100), p1(3, 590, 100, 100, 700)], 'phase1')
    # phase 1 sees repeated visits with no elapsed time (tick not written)
    S('p1:idle_visits', p1_rows, INIT + [p1(1, 10, 10, 100, 120)] + [('dispatch', [120 + i]) for i in range(5)] + [('dispatch', [260]), ('dispatch', [300])],
      'phase1', quick=True)
    # frame rate zero: the original divides by zero (S2)
    S('rej:fps_zero', [R(build_record(b'MAP_A', fps=0))], INIT + [('fps_zero', 0)], 'reject', quick=True)

    # -- phase 2: finish ---------------------------------------------------------------------------------------
    k = 0
    for ex_scene in (NO_SCENE, 55, 0, -1, 32767):
        for flag149 in (1, 0, 2, -1):
            for ex_flag, ex_val in ((-1, 0), (3, 1), (127, 0xff), (0, 0x80)):
                rec = build_record(b'MAP_E', b'MAP_F', exit_scene=ex_scene, exit_words=(11, -12, 13), exit_dwords=(0x10001, -2, 0x30003),
                                   flag149=flag149, exit_flag=ex_flag, exit_val=ex_val)
                k += 1
                steps = []
                for ec, tgt in ((1, NO_SCENE), (1, 5), (0, NO_SCENE), (0, 12), (0, -1)):
                    steps += [('dispatch', [100]), ('setobj', {'exit_clicked': ec, 'target_scene': tgt}), ('setphase', 0, 2), ('dispatch', [100]), ('setmode', 3)]
                S('p2:finish_%d' % k, [R(rec, sub=2)], steps, 'phase2', quick=(ex_scene, flag149, ex_flag) in ((55, 1, 3), (NO_SCENE, 0, 127), (55, 0, -1), (0, 2, 0)))
    S('p2:finish_subtype1', [R(build_record(b'MAP_E', exit_scene=55, exit_flag=3, exit_val=1, flag149=1), sub=1)],
      INIT + [('setobj', {'exit_clicked': 1}), ('setphase', 0, 2), ('dispatch', [1]), ('dispatch', [1])], 'phase2', quick=True)
    S('p2:finish_text', [R(build_record(b'USE_LISTPAGE3', b'MAP_Z', exit_scene=55, exit_flag=3, exit_val=1), sub=2)],
      INIT + [('setobj', {'exit_clicked': 1}), ('setphase', 0, 2), ('dispatch', [1]), ('setmode', 3), ('dispatch', [1])], 'phase2', quick=True)
    for ef in (128, 500, -2, -100):
        S('rej:exitflag_%d' % ef, [R(build_record(b'MAP_E', exit_flag=ef, exit_val=1, exit_scene=55), sub=2)],
          INIT + [('setobj', {'exit_clicked': 1}), ('reject_finish', 0)], 'reject', quick=ef == 128)

    # -- direct methods -------------------------------------------------------------------------------------------
    links = [(21, (100, 30, 160, 60)), (22, (120, 90, 140, 130)), (23, (-5, -5, 5, 5))]
    HR = build_record(b'MAP_H', b'MAP_I', links=links, exit_rect=(300, 10, 340, 50))

    def pts(rects):
        out_pts = []
        for (l, t, r, b) in rects:
            for x_ in (l - 1, l, (l + r) // 2, r, r + 1):
                for y_ in (t - 1, t, (t + b) // 2, b, b + 1):
                    out_pts.append((x_, y_))
        return out_pts
    dst = (8, 16)
    link_abs = [(l + dst[0], t + dst[1], r + dst[0], b + dst[1]) for _s, (l, t, r, b) in links]
    all_rects = [(300, 10, 340, 50)] + DEF_BUTTONS + link_abs
    hp = pts(all_rects)
    glob_cases = [dict(item=-1, flag=0, v0377=0x1111, v571=0x2222, cur=0x77), dict(item=3, flag=0, v0377=0x1112, v571=0x2223, cur=0x78),
                  dict(item=3, flag=1, v0377=0x1113, v571=0x2224, cur=0x79), dict(item=-1, flag=5, v0377=0x1114, v571=0x2225, cur=0x7a),
                  dict(item=0, flag=0, v0377=-5, v571=-6, cur=-1), dict(item=-2, flag=0, v0377=0, v571=0, cur=0), dict(item=0x7fff, flag=-1, v0377=7, v571=8, cur=9)]
    hsteps = []
    for i, (px, py) in enumerate(hp):
        hsteps.append(('hit', px, py, glob_cases[i % len(glob_cases)]))
    S('hit:boundaries', [R(HR)], INIT + hsteps, 'direct', quick=True)
    S('hit:globals_matrix', [R(HR)], INIT + [('hit', px, py, g) for (px, py) in ((20, 20), (310, 30), (110, 40), (60, 20), (500, 500), (-3, -3)) for g in glob_cases], 'direct', quick=True)
    S('hit:inactive', [R(HR)], [('hit', 20, 20, glob_cases[0]), ('hit', 310, 30, glob_cases[1])] + INIT + [('cleanup',), ('hit', 20, 20, glob_cases[0])], 'direct', quick=True)
    S('hit:overlap', [R(build_record(b'MAP_H', buttons=[(0, 0, 50, 50), (25, 25, 75, 75), (60, 60, 90, 90), (60, 60, 90, 90)], exit_rect=(40, 40, 70, 70),
                                    links=[(5, (0, 0, 100, 100)), (6, (10, 10, 20, 20))]))],
      INIT + [('hit', x_, y_, glob_cases[(x_ + y_) % len(glob_cases)]) for x_ in (0, 10, 20, 30, 45, 55, 65, 80, 95, 130) for y_ in (0, 10, 20, 30, 45, 55, 65, 80, 95, 130)],
      'direct')
    for k in range(8):
        r_rects = [tuple(sorted((rng.randrange(-20, 120), rng.randrange(-20, 120)))[i] for i in (0, 1)) for _ in range(0)]
        btn = []
        for _ in range(4):
            a, b = rng.randrange(-30, 150), rng.randrange(-30, 150)
            c, d = rng.randrange(-30, 150), rng.randrange(-30, 150)
            btn.append((min(a, b), min(c, d), max(a, b), max(c, d)) if rng.random() < 0.8 else (a, c, b, d))
        lk = []
        for j in range(rng.randrange(0, 5)):
            a, b = rng.randrange(-30, 150), rng.randrange(-30, 150)
            c, d = rng.randrange(-30, 150), rng.randrange(-30, 150)
            lk.append((rng.randrange(-5, 100), (min(a, b), min(c, d), max(a, b), max(c, d))))
        ea, eb, ec, ed = rng.randrange(-30, 150), rng.randrange(-30, 150), rng.randrange(-30, 150), rng.randrange(-30, 150)
        rec = build_record(b'MAP_H', buttons=btn, exit_rect=(min(ea, eb), min(ec, ed), max(ea, eb), max(ec, ed)), links=lk,
                           dst=(rng.randrange(-20, 60), rng.randrange(-20, 60), 100, 100))
        del r_rects
        S('hit:random_%d' % k, [R(rec)], INIT + [('hit', rng.randrange(-40, 200), rng.randrange(-40, 200), rng.choice(glob_cases)) for _ in range(120)],
          'direct', quick=k < 2)
    S('hit:extreme_coords', [R(HR)], INIT + [('hit', x_, y_, glob_cases[0]) for x_ in (-32768, -1, 0, 32767, 0x7fff) for y_ in (-32768, 0, 32767)], 'direct')
    S('hit:big_rects', [R(build_record(b'MAP_H', buttons=[(-0x80000000, -0x80000000, 0x7fffffff, 0x7fffffff)] * 4,
                                       exit_rect=(5, 5, 4, 4), links=[(5, (-0x80000000, -0x80000000, 0x7fffffff, 0x7fffffff))],
                                       dst=(0x7fffffff, 0x7fffffff, 1, 1)))],
      INIT + [('hit', 0, 0, glob_cases[0]), ('hit', -32768, 32767, glob_cases[1])], 'direct')

    # click / press / dirty sequences on a hit object
    csteps = INIT + [('hit', 20, 20, glob_cases[0]), ('click', CAND['BUTTON']), ('click', CAND['LINK']), ('hit', 120, 60, glob_cases[0]),
                     ('click', CAND['LINK']), ('hit', 310, 30, glob_cases[0]), ('click', CAND['EXIT']), ('click', 0x1234), ('click', 0),
                     ('click', -1), ('setphase', 0, 1), ('hit', 20, 20, glob_cases[0]), ('click', CAND['EXIT'])]
    S('click:basic', [R(HR)], csteps, 'direct', quick=True)
    cs2 = INIT
    for i in range(3):
        px, py = link_abs[i][0] + 1, link_abs[i][1] + 1
        cs2 = cs2 + [('hit', px, py, glob_cases[0]), ('setobj', {'dir': i, 'pressed': 1}), ('click', CAND['LINK']), ('setphase', 0, 1)]
    S('click:links', [R(HR)], cs2, 'direct', quick=True)
    ps = INIT
    for hot in range(4):
        px, py = DEF_BUTTONS[hot][0] + 1, DEF_BUTTONS[hot][1] + 1
        ps = ps + [('hit', px, py, glob_cases[0]), ('press', CAND['BUTTON'], [4000 + hot]), ('press', CAND['BUTTON'], [4100 + hot]),
                   ('setobj', {'pressed': 0, 'dir': 0xff}), ('setobj', {'can%d' % hot: 0}), ('press', CAND['BUTTON'], [4200]),
                   ('setobj', {'can%d' % hot: 1}), ('press', CAND['LINK'], [1]), ('press', 0, [1]), ('setphase', 0, 2), ('press', CAND['BUTTON'], [1]),
                   ('setphase', 0, 1), ('setobj', {'active': 0}), ('press', CAND['BUTTON'], [1]), ('setobj', {'active': 1, 'pressed': 0}),
                   ('click', CAND['BUTTON']), ('press', CAND['BUTTON'], [4300])]
    S('press:buttons', [R(HR)], ps, 'direct', quick=True)
    S('press:hot_unset', [R(HR)], INIT + [('setobj', {'hot': -1, 'pressed': 0}), ('press', CAND['BUTTON'], [5])]
      + [('reject_press', h) for h in (4, 5, 7, 100, -2, -100)], 'direct', quick=True)
    S('dirty:slots', [R(HR)], INIT + [('setentry', 'dirty0'), ('dirty',), ('setobj', {'active': 0}), ('setentry', 'dirty0'), ('dirty',),
                                  ('setobj', {'active': 1, 'slot_a': -1}), ('setentry', 'dirty0'), ('dirty',), ('setobj', {'slot_b': -1, 'slot_a': 0x20}), ('setentry', 'dirty0'),
                                  ('dirty',), ('setobj', {'slot_b': 0x21}), ('setentry', 'dirty0'), ('dirty',)], 'direct', quick=True)
    S('dirty:before_init', [R(HR)], [('dirty',), ('cleanup',), ('dirty',)], 'direct')
    S('cleanup:variants', [R(build_record(b'MAP_A', b'MAP_B'))],
      INIT + [('cleanup',), ('cleanup',), ('dispatch', [1]), ('setobj', {'surface2': 0xabc}), ('cleanup',), ('dispatch', [1]),
              ('setobj', {'surface1': 0xdef, 'surface2': 0xdef}), ('cleanup',), ('dispatch', [1]), ('setobj', {'borrowed': 1}), ('cleanup',),
              ('dispatch', [1]), ('setobj', {'borrowed': 0, 'surface1': 0}), ('cleanup',), ('dispatch', [1]), ('setobj', {'slot_a': -1}), ('cleanup',)],
      'direct', quick=True)
    S('cleanup:text_surface2', [R(build_record(b'USE_AUTOTEXT2', b'MAP_B'))], INIT + [('cleanup',)] + INIT + [('setobj', {'surface2': 0}), ('cleanup',)], 'direct', quick=True)
    S('cleanup:dirty_object', [R(build_record(b'MAP_A', b'MAP_B'))],
      INIT + [('setobj', {'pos_41': 33, 'pos_43': 44, 'pressed': 1, 'dir': 2, 'exit_clicked': 1, 'target_scene': 5, 'hot': 2}), ('cleanup',),
              ('dispatch', [1]), ('setobj', {'pos_41': -7, 'pos_43': 9, 'borrowed': 1, 'visible': 0}), ('cleanup',)], 'direct', quick=True)
    S('cleanup:before_init', [R(build_record(b'MAP_A'))], [('cleanup',), ('cleanup',)], 'direct', quick=True)

    # render callback over many object states, view origins, mode byte 2 and not 2
    render_steps = INIT[:]
    for k in range(30):
        st_ = dict(visible=rng.choice((1, 1, 1, 0)), pos_41=rng.randrange(-100, 700), pos_43=rng.randrange(-100, 600),
                   pressed=rng.choice((0, 1)), dir=rng.choice((0, 1, 2, 3, 0xff, 0xff)))
        for i in range(4):
            st_['can%d' % i] = rng.choice((0, 1))
            st_['ina%d' % i] = rng.choice((0, 1))
            st_['down%d' % i] = rng.choice((0, 1))
        render_steps += [('setobj', st_), ('render', rng.randrange(-50, 800), rng.randrange(-50, 600))]
    for mode_byte in (0, 1, 2, 3, 0xff):
        S('render:mode%d' % mode_byte, [R(build_record(b'MAP_A', b'MAP_B', mode=mode_byte, links=links))], render_steps, 'direct', quick=mode_byte in (0, 2))
    S('render:text_names', [R(build_record(b'USE_AUTOTEXT1', b'USE_AUTOTEXT1', mode=2))], render_steps[:30], 'direct')
    S('render:before_init', [R(build_record(b'MAP_A', mode=2))], [('render', 0, 0), ('render', 5, 5)] + INIT + [('render', 5, 5), ('cleanup',), ('render', 5, 5)], 'direct', quick=True)

    # -- natural flows: random gameplay scripts -------------------------------------------------------------------
    for n in range(10):
        frng = random.Random(seed * 1000 + n)
        nl = frng.randrange(0, 4)
        rec = build_record(frng.choice([b'MAP_N', b'USE_AUTOTEXT2', b'USE_LISTPAGE3', b'MAP_Q']), frng.choice([b'', b'MAP_N2', b'map_n']),
                           mode=frng.choice((0, 2)), lim=(0, 0, 500 + frng.randrange(300), 400 + frng.randrange(300)), fps=frng.choice((5, 10, 25, 60)),
                           links=[(frng.randrange(1, 90), (10 + 40 * j, 120, 40 + 40 * j, 150)) for j in range(nl)],
                           exit_scene=frng.choice((NO_SCENE, 66)), exit_flag=frng.choice((-1, 9)), exit_val=frng.randrange(256), flag149=frng.choice((0, 1)))
        clock = 1000
        fsteps = INIT[:]
        for _ in range(60):
            a = frng.random()
            if a < 0.35:
                b = frng.randrange(4)
                fsteps += [('hit', DEF_BUTTONS[b][0] + 1, DEF_BUTTONS[b][1] + 1, frng.choice(glob_cases)), ('press', CAND['BUTTON'], [clock])]
            elif a < 0.7:
                clock += frng.randrange(1, 400)
                fsteps += [('dispatch', [clock])]
            elif a < 0.8:
                fsteps += [('hit', frng.randrange(0, 300), frng.randrange(0, 200), frng.choice(glob_cases)), ('click', frng.choice((CAND['BUTTON'], CAND['LINK'], CAND['EXIT'])))]
            elif a < 0.9:
                fsteps += [('render', frng.randrange(0, 100), frng.randrange(0, 100)), ('dirty',)]
            else:
                fsteps += [('setmode', 3)]
        fsteps += [('hit', 310, 30, glob_cases[0]), ('click', CAND['EXIT']), ('dispatch', [clock + 5]), ('setmode', 3), ('dispatch', [clock + 9])]
        S('flow:%d' % n, [R(rec, sub=2)], fsteps, 'flow', quick=n < 2)
    # -- differential fuzz: random records, random object states, random times ------------------------------------
    for n in range(40):
        frng = random.Random(seed * 7000 + n)
        src = (frng.randrange(-50, 50), frng.randrange(-50, 50), frng.randrange(100, 400), frng.randrange(80, 300))
        lim = (frng.randrange(-100, 100), frng.randrange(-100, 100), src[2] + frng.randrange(0, 900), src[3] + frng.randrange(0, 900))
        rec = build_record(frng.choice([b'MAP_Z', b'USE_AUTOTEXT1', b'USE_LISTPAGE2']), frng.choice([b'', b'MAP_Y']), mode=frng.choice((0, 2)),
                           lim=lim, src=src, fps=frng.randrange(1, 256), junk=frng.choice((0, 0x11)),
                           inacts=[frng.choice(edge_rects + [(0, 0, 9, 9)]) for _ in range(4)], downs=[frng.choice(edge_rects + [(0, 0, 9, 9)]) for _ in range(4)])
        fl = rec_limits(rec)
        fz = INIT[:]
        for _ in range(120):
            period = 1000 // rec[0x134]
            direction = frng.choice((0, 1, 2, 3, 0xff))
            p41 = frng.choice([frng.randrange(min(fl['limit_4a'], fl['limit_48']) - 20, max(fl['limit_4a'], fl['limit_48']) + 20), fl['limit_4a'], fl['limit_48'], frng.randrange(-0x8000, 0x8000)])
            p43 = frng.choice([frng.randrange(min(fl['limit_4e'], fl['limit_4c']) - 20, max(fl['limit_4e'], fl['limit_4c']) + 20), fl['limit_4e'], fl['limit_4c'], frng.randrange(-0x8000, 0x8000)])
            tick = frng.choice([0, 1000, 0xfffffff0, frng.getrandbits(32)])
            elapsed = frng.choice([0, period - 1, period, 2 * period, frng.randrange(0, 20 * period), frng.getrandbits(32)])
            can = [frng.choice((0, 1)) for _ in range(4)]
            fz.append(p1(direction, p41, p43, tick, (tick + elapsed) & 0xffffffff, can))
        S('fuzz:p1_%d' % n, [R(rec)], fz, 'fuzz', quick=n < 2)
    return scs


def run_steps(run, sc, stats):
    x, nat, lib = run.x, run.nat, run.lib
    n_hit = 0
    for ai, act in enumerate(sc['steps']):
        kind = act[0]
        where = '%s step %d %s' % (sc['id'], ai, kind)
        run.where = where
        if kind == 'dispatch':
            run.dispatch(act[1], where)
        elif kind == 'p1':
            fields, now = act[1], act[2]
            run.set_obj(**fields)
            run.dispatch([now], where)
        elif kind == 'setobj':
            run.set_obj(**act[1])
            run.compare_state(where, rows=False)
        elif kind == 'setphase':
            row = run.first + act[1]
            x.w32(ROWS + row * ROW + PHASE_OFF, act[2])
            run.phase[row] = act[2] & 0xffffffff
        elif kind == 'skipflag':
            row = run.first + act[1]
            x.w32(ROWS + row * ROW + SKIP_OFF, act[2])
            run.rows[act[1]]['skip'] = act[2]
        elif kind == 'setmode':
            x.w32(G_MODE, act[1])
            c = nat.cells()
            c[8] = act[1]
            nat.set_cells(c)
        elif kind == 'events':
            for i, v in act[1].items():
                x.w32(EVENTS_VA + 4 * i, v)
                lib.d8o_set_event(nat.h, i, v)
        elif kind == 'setrec':
            row = run.first + act[1]
            off, data = act[2], act[3]
            run.rows[act[1]]['rec'][off:off + len(data)] = data
            x.wr(x.rec_addr[row] + off, data)
        elif kind == 'setentry':
            for s in (0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x20, 0x21, 0x3e):
                x.w32(ENTRY + s * STRIDE + 0x14, 0)
                lib.d8o_set_entry_u32(nat.h, s, 0x14, 0)
        elif kind == 'hit':
            n_hit += 1
            run.hit(where, act[1], act[2], act[3])
        elif kind == 'click':
            run.click(where, act[1])
        elif kind == 'press':
            run.press(where, act[1], act[2])
        elif kind == 'dirty':
            run.dirty(where)
        elif kind == 'cleanup':
            run.cleanup(where)
        elif kind == 'render':
            run.render(where, act[1], act[2], 0x1f0000 + ai, 0x2f0000 + ai, 0x3f0000 + ai, 0x4f0000 + ai)
        elif kind == 'reject_step':
            reject_step(run, where, act[1], act[2], act[3])
        elif kind == 'fps_zero':
            fps_zero(run, where)
        elif kind == 'reject_finish':
            reject_finish(run, where)
        elif kind == 'reject_press':
            reject_press(run, where, act[1])
        else:
            raise OracleError('unknown action ' + kind)
        if run.fatal_done:
            break
        stats['steps_total'] += 1


def object_untouched(run, where, before_obj, before_cells, before_entries, before_events):
    nat = run.nat
    if nat.obj() != before_obj or nat.cells() != before_cells or nat.entries() != before_entries or nat.events() != before_events:
        raise Mismatch('%s a rejected call changed the native state' % where)


def reject_step(run, where, row, phase, tag):
    nat, st = run.nat, run.stats
    snap = (nat.obj(), nat.cells(), nat.entries(), nat.events())
    status, why, fx, names, res = nat.step(run.rec(run.first + row), run.first + row, phase)
    if status != 2 or fx or names:
        raise Mismatch('%s native should reject with D8_ERR_BODY before any effect (status %d, %d effects, %s)' % (where, status, len(fx), why))
    object_untouched(run, where, *snap)
    st['rejections'] += 1
    st['rejection_kinds'][tag] += 1


def reject_finish(run, where):
    nat, st = run.nat, run.stats
    snap = (nat.obj(), nat.cells(), nat.entries(), nat.events())
    nat.set_ticks([1])
    status, why, fx, names, res = nat.step(run.rec(run.first), run.first, 2)
    if status != 2 or fx:
        raise Mismatch('%s native should reject the exit event flag before any effect (status %d, %d effects)' % (where, status, len(fx)))
    object_untouched(run, where, *snap)
    st['rejections'] += 1
    st['rejection_kinds']['exit_flag'] += 1


def reject_press(run, where, hot):
    """S6: a hot index outside 0..3 (unreachable: the hit test only writes 0..3 or -1). The original indexes the
    object bytes at +0x34 + hot; the native kernel refuses to act."""
    nat, st = run.nat, run.stats
    good = nat.obj()
    bad = list(good)
    bad[OBJ_NAMES.index('hot')] = hot
    bad[OBJ_NAMES.index('pressed')] = 0
    nat.set_obj(bad)
    snap = (nat.obj(), nat.cells(), nat.entries(), nat.events())
    nat.set_ticks([1])
    nat.clear()
    if nat.lib.d8o_press(nat.h, 1, CAND['BUTTON']) != 0 or nat.fx() or nat.obj() != snap[0]:
        raise Mismatch('%s native press with hot %d acted' % (where, hot))
    nat.set_obj(good)
    st['rejections'] += 1
    st['rejection_kinds']['press_hot'] += 1


def fps_zero(run, where):
    x, nat, st = run.x, run.nat, run.stats
    # the original executes idiv by zero: the emulation faults with a divide error
    x.tick_script = [500]
    x.tick_i = 0
    try:
        x.dispatch([500])
    except OracleError as error:
        if 'failed at' not in str(error):
            raise Mismatch('%s original did not fault as expected: %s' % (where, error))
        st['fps_zero_original_faults'] += 1
    else:
        raise Mismatch('%s original did not fault on frame rate 0' % where)
    snap = (nat.obj(), nat.cells(), nat.entries(), nat.events())
    nat.set_ticks([500])
    status, why, fx, names, res = nat.step(run.rec(run.first), run.first, 1)
    if status != 2 or fx:
        raise Mismatch('%s native should reject frame rate 0 before any effect (status %d)' % (where, status))
    object_untouched(run, where, *snap)
    st['rejections'] += 1
    st['rejection_kinds']['fps_zero'] += 1
    run.fatal_done = True  # the original machine is in a faulted state; the scenario ends here


def run_validation_rejections(lib, stats):
    """S5: the native record validation (no original counterpart: the original trusts its loader)."""
    good = build_record(b'A', links=[(1, (0, 0, 1, 1))])
    bad = []
    bad.append(good[:-1])
    bad.append(good + b'\0')
    bad.append(good[:0x15f])
    r = bytearray(good)
    struct.pack_into('<h', r, 0x15e, 101)
    bad.append(bytes(r))
    r = bytearray(good)
    struct.pack_into('<h', r, 0x15e, -1)
    bad.append(bytes(r))
    r = bytearray(good)
    r[0:0x21] = b'x' * 0x21
    bad.append(bytes(r))
    r = bytearray(good)
    r[0x21:0x42] = b'y' * 0x21
    bad.append(bytes(r))
    for b in bad:
        if lib.d8o_validate(cbuf(b), len(b)) != 2:
            raise Mismatch('validation accepted a bad record of length %d' % len(b))
        stats['rejections'] += 1
        stats['rejection_kinds']['validate'] += 1
    for n in (0, 1, 50, 100):
        want = 0x160 + 0x12 * n
        if lib.d8o_record_bytes(n) != want:
            raise Mismatch('record length of %d links: native %d, packet %d' % (n, lib.d8o_record_bytes(n), want))
        stats['record_length_checks'] += 1
    if lib.d8o_record_bytes(101) != 0 or lib.d8o_record_bytes(-1) != 0:
        raise Mismatch('record length outside 0..100 accepted')


def malformed_run(lib, stats, count=3000, seed=3434):
    """Bounded malformed inputs for the native kernel only (run it under ASan/UBSan with D8_SANITIZE=1): random
    records of random length, hostile object states, every entry point. Passes when nothing crashes and every status
    is OK or one of the documented rejections."""
    rng = random.Random(seed)
    nat = Native(lib)
    statuses = Counter()
    try:
        nat.set_handles([0x7001 + i for i in range(16)])
        for i in range(6):
            lib.d8o_set_text(nat.h, i, 0x5100 + i, rng.choice((0, 77, 100000, -9)))
        for case in range(count):
            n = rng.choice((0, 1, 3, 100, 101, 255, 1000, -1, rng.randrange(0, 120)))
            length = rng.choice((0x160 + 0x12 * max(n, 0), 0x160 + 0x12 * max(n, 0), 0x15f, 0, 1, 0x868, 0x900, rng.randrange(0, 0x900)))
            rec = bytearray(rng.getrandbits(8) for _ in range(length))
            if length >= 0x160 and rng.random() < 0.85:
                struct.pack_into('<h', rec, 0x15e, max(-32768, min(32767, n)) if rng.random() < 0.3 else (length - 0x160) // 0x12)
                if rng.random() < 0.9:
                    rec[0x20] = 0
                    rec[0x41] = 0
                for off in (0, 0x21):
                    if rng.random() < 0.5:
                        pre = rng.choice((b'USE_LISTPAGE', b'USE_AUTOTEXT', b'MAP'))
                        rec[off:off + len(pre)] = pre
                        tail = rng.choice((b'', b'0', b'3', b'9', b'-9', b'1', b'2', b'99999999999999', b'\xff'))
                        rec[off + len(pre):off + len(pre) + len(tail)] = tail
                        if off + len(pre) + len(tail) < off + 0x21 and rng.random() < 0.9:
                            rec[off + len(pre) + len(tail)] = 0
            obj = [rng.choice((0, 1, 2, 3, 4, 255, rng.getrandbits(8))), rng.choice((0, 1)), rng.choice((0, 1, 0x7fffffff, rng.getrandbits(32))),
                   rng.choice((0, 1, rng.getrandbits(32))), rng.randrange(-3, 300), rng.randrange(-5, 12), rng.randrange(-3, 0x60),
                   rng.randrange(-3, 0x60)] + [rng.choice((0, 1)) for _ in range(12)] + [rng.choice((0, 1)), rng.randrange(-32768, 32768),
                   rng.randrange(-32768, 32768), rng.choice((0, 1)), rng.choice((0, 1)), rng.choice((0, 1)), rng.randrange(-32768, 32768),
                   rng.randrange(-32768, 32768), rng.randrange(-32768, 32768), rng.randrange(-32768, 32768), rng.getrandbits(32), rng.randrange(-32768, 32768)]
            nat.set_obj(obj)
            nat.clear()
            nat.set_ticks([rng.getrandbits(32) for _ in range(4)])
            kind = rng.randrange(7)
            if kind <= 2:
                status, why, fx, names, res = nat.step(bytes(rec), rng.randrange(-5, 300), rng.choice((0, 1, 2, 3, 0xffffffff)), rng.choice((0, 5, 128, 1 << 40)))
                if status not in (0, 2, 4):
                    raise Mismatch('malformed step status %d (%s)' % (status, why))
            elif kind == 3:
                inp = (C.c_int32 * 5)(*[rng.choice((-1, 0, 1, 5, 0x7fff, rng.getrandbits(31))) for _ in range(5)])
                o = (C.c_int32 * 9)()
                status = lib.d8o_hit(nat.h, cbuf(bytes(rec)), len(rec), rng.randrange(-40000, 40000), rng.randrange(-40000, 40000), inp, o)
                if status not in (0, 2):
                    raise Mismatch('malformed hit status %d' % status)
            elif kind == 4:
                o = (C.c_int32 * 2)()
                status = lib.d8o_click(nat.h, cbuf(bytes(rec)), len(rec), rng.choice((CAND['BUTTON'], CAND['LINK'], CAND['EXIT'], 0, -1)), o)
                if status not in (0, 2):
                    raise Mismatch('malformed click status %d' % status)
            elif kind == 5:
                status, _plan = nat.plan(bytes(rec), rng.randrange(-2 ** 31, 2 ** 31), rng.randrange(-2 ** 31, 2 ** 31))
                if status not in (0, 2):
                    raise Mismatch('malformed plan status %d' % status)
            else:
                status = rng.choice((lib.d8o_cleanup(nat.h), lib.d8o_dirty(nat.h), lib.d8o_press(nat.h, rng.choice((0, 1, 2)), rng.choice((CAND['BUTTON'], 0)))))
            statuses[status] += 1
            stats['malformed_cases'] += 1
    finally:
        nat.close()
    stats['malformed_statuses'] = dict(statuses)


# ---------------------------------------------------------------------------------------------
# mutation check
# ---------------------------------------------------------------------------------------------
MUTANTS = {
 'phase1_clamp_ge_to_gt': ('o->dir == 1u && o->pos_43 >= o->limit_4c', 'o->dir == 1u && o->pos_43 > o->limit_4c'),
 'phase1_clamp_le_to_lt': ('o->dir == 0u && o->pos_43 <= o->limit_4e', 'o->dir == 0u && o->pos_43 < o->limit_4e'),
 'phase1_clamp_x_limit_swapped': ('o->dir == 3u && o->pos_41 >= o->limit_48', 'o->dir == 3u && o->pos_41 >= o->limit_4a'),
 'phase1_clamp_swapped_can_move': ('o->pos_41 = o->limit_4a;\n        o->can_move[2] = 0u;\n        o->dir = 0xffu;', 'o->pos_41 = o->limit_4a;\n        o->can_move[3] = 0u;\n        o->dir = 0xffu;'),
 'phase1_period_formula': ('period = (uint32_t)(1000 / (int)fps);', 'period = (uint32_t)(1000 / ((int)fps + 1));'),
 'phase1_period_le': ('if (now - o->tick < period) return D8_OK;', 'if (now - o->tick <= period) return D8_OK;'),
 'phase1_steps_off_by_one': ('const uint16_t steps = (uint16_t)((now - o->tick) / period);', 'const uint16_t steps = (uint16_t)((now - o->tick) / period + 1u);'),
 'phase1_steps_8bit': ('const uint16_t steps = (uint16_t)((now - o->tick) / period);', 'const uint16_t steps = (uint8_t)((now - o->tick) / period);'),
 'phase1_tick_not_stored': ('    o->tick = now;\n    fx(host, D8_FX_TICK, (int32_t)now, 0);', '    fx(host, D8_FX_TICK, (int32_t)now, 0);'),
 'phase1_dir1_can_move': ('case 1u: o->pos_43 = (int16_t)(o->pos_43 + steps); o->can_move[0] = 1u; break;', 'case 1u: o->pos_43 = (int16_t)(o->pos_43 + steps); o->can_move[1] = 1u; break;'),
 'phase1_dir2_sign': ('case 2u: o->pos_41 = (int16_t)(o->pos_41 - steps); o->can_move[3] = 1u; break;', 'case 2u: o->pos_41 = (int16_t)(o->pos_41 + steps); o->can_move[3] = 1u; break;'),
 'cleanup_second_surface_not_released': ('if (o->surface2 != o->surface1) {', 'if (0 && o->surface2 != o->surface1) {'),
 'cleanup_slot_b_not_released': ('if (o->slot_b != D8_NO_SLOT) {\n        if (host->release_slot', 'if (0 && o->slot_b != D8_NO_SLOT) {\n        if (host->release_slot'),
 'cleanup_release_tag_swapped': ('fx(host, D8_FX_RELEASE_SURFACE, (int32_t)o->surface1, 1);', 'fx(host, D8_FX_RELEASE_SURFACE, (int32_t)o->surface1, 0);'),
 'cleanup_borrowed_released': ('if (o->surface1 == 0u || o->borrowed != 0u) {', 'if (o->surface1 == 0u) {'),
 'cleanup_reset_keeps_pos': ('    o->pos_43 = 0;\n    o->pos_41 = 0;', '    o->pos_43 = o->pos_43;\n    o->pos_41 = 0;'),
 'exit_flag_value_off_by_one': ('const int32_t value = (int32_t)record[REC_EXIT_FLAG + 2];', 'const int32_t value = (int32_t)record[REC_EXIT_FLAG + 1];'),
 'exit_start_flag_inverted': ('start_flag = rds16(record + REC_EXIT_SCENE + 20) == 1 ? 0 : 1;', 'start_flag = rds16(record + REC_EXIT_SCENE + 20) == 1 ? 1 : 0;'),
 'target_scene_cells': ('change.word[2] = 1;\n        change.dword[2] = 1;', 'change.word[2] = 0;\n        change.dword[2] = 1;'),
 'hit_button_right_edge': ('y <= rds32(r + 12) && x >= rds32(r) && x <= rds32(r + 8)', 'y <= rds32(r + 12) && x >= rds32(r) && x < rds32(r + 8)'),
 'hit_exit_top_corner': ('if (y >= rds32(record + REC_EXIT_RECT + 4) && y <= rds32(record + REC_EXIT_RECT + 12) &&', 'if (y > rds32(record + REC_EXIT_RECT + 4) && y <= rds32(record + REC_EXIT_RECT + 12) &&'),
 'hit_link_uses_wrong_origin': ('(uint32_t)rds32(e + 6) + (uint32_t)oy', '(uint32_t)rds32(e + 6) + (uint32_t)ox'),
 'hit_exit_table_flag': ('out->table_5d1631 = cursor_table(9, 1);', 'out->table_5d1631 = cursor_table(9, 0);'),
 'hit_item_offset': ('out->cursor_5b44f0 = (int32_t)in->item_583a29 + 0x25;', 'out->cursor_5b44f0 = (int32_t)in->item_583a29 + 0x24;'),
 'init_rect_empty_lt': ('return r[2] <= r[0] || r[3] <= r[1]; /* IsRectEmpty */', 'return r[2] < r[0] || r[3] <= r[1]; /* IsRectEmpty */'),
 'init_start_clamp_gt': ('if (o->pos_43 >= o->limit_4c) {\n        o->pos_43 = o->limit_4c;\n        o->can_move[1] = 0u;', 'if (o->pos_43 > o->limit_4c) {\n        o->pos_43 = o->limit_4c;\n        o->can_move[1] = 0u;'),
 'init_text_height_plus': ('o->limit_4c = (int16_t)(text_height - rds32(record + REC_SRC + 12));', 'o->limit_4c = (int16_t)(text_height + rds32(record + REC_SRC + 12));'),
 'init_autotext_range': ("name[12] >= '1' && name[12] <= '3'", "name[12] >= '1' && name[12] <= '4'"),
 'init_listpage_base': ('*index = 2 + crt_atoi(rest);', '*index = 1 + crt_atoi(rest);'),
 'init_case_sensitive_names': ('if (strlen(name2) == 0u || ascii_equal_nocase(name, name2)) {\n        o->surface2 = o->surface1;', 'if (strlen(name2) == 0u || strcmp(name, name2) == 0) {\n        o->surface2 = o->surface1;'),
 'init_limit_4a_formula': ('o->limit_4a = (int16_t)(rds32(record + REC_44) - rds32(record + REC_SRC));', 'o->limit_4a = (int16_t)(rds32(record + REC_44) - rds32(record + REC_SRC + 8));'),
 'init_visit2_reclassifies': ('    if (o->surface1 == 0u) {\n        if (kind == NAME_FILE) {', '    if (1) {\n        if (kind == NAME_FILE) {'),
 'press_tick_always': ('if (o->pressed == 0u) {\n            if (host == NULL', 'if (1) {\n            if (host == NULL'),
 'press_can_move_inverted': ('o->can_move[o->hot] != 0u) {\n        if (o->pressed == 0u)', 'o->can_move[o->hot] == 0u) {\n        if (o->pressed == 0u)'),
 'click_link_scene_offset': ('o->target_scene = rds16(record + REC_ENTRY + D8_ENTRY_BYTES * (unsigned)o->hot);', 'o->target_scene = rds16(record + REC_ENTRY + 2 + D8_ENTRY_BYTES * (unsigned)o->hot);'),
 'click_exit_phase': ('o->exit_clicked = 1u;\n        out->phase_written = 1u;', 'o->exit_clicked = 1u;\n        out->phase_written = 0u;'),
 'dirty_slot_b_dropped': ('if (o->active != 0u && o->slot_b != D8_NO_SLOT && host->mark_dirty != NULL &&', 'if (0 && o->active != 0u && o->slot_b != D8_NO_SLOT && host->mark_dirty != NULL &&'),
 'render_down_dir_inverted': ('else if (o->pressed != 0u && o->down_rect[i] != 0u && i == o->dir) {', 'else if (o->pressed != 0u && o->down_rect[i] != 0u && i != o->dir) {'),
 'render_view_origin_swapped': ('shifted(record, REC_DST, view->origin_x, view->origin_y, dst);', 'shifted(record, REC_DST, view->origin_y, view->origin_x, dst);'),
 'render_inactive_needs_can_move': ('if (o->inactive_rect[i] != 0u && o->can_move[i] == 0u) {', 'if (o->inactive_rect[i] != 0u && o->can_move[i] != 0u) {'),
 'render_mode_restore': ('if (record[REC_MODE] == MODE_RESTORE) {', 'if (record[REC_MODE] != MODE_RESTORE) {'),
}


def mutation_check(args, workdir):
    source = (args.src / 'action_family_d8_runtime.c').read_text()
    report = []
    for name, (old, new) in MUTANTS.items():
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted (%d matches)' % source.count(old)))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / 'action_family_d8_runtime.c').write_text(source.replace(old, new))
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))
        except OracleError as error:
            report.append(dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:160]))
            continue
        cmd = [sys.executable, '-I', str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((ln for ln in done.stdout.splitlines() if ln.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=first[6:][:200] if first else None))
    return report


# ---------------------------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, dispatches=0, steps=0, steps_total=0, effects=0, state_compares=0, object_fields=0,
                entry_bytes=0, cell_compares=0, event_compares=0, row_compares=0, audited_writes=0, hit_calls=0, hits=0,
                hit_cells=0, click_calls=0, press_calls=0, dirty_calls=0, cleanups=0, render_calls=0, blit_calls=0,
                blit_args=0, render_skipped_unreachable=0, phase0_steps=0, phase1_steps=0, phase2_steps=0,
                phase_above_2_steps=0, phase_above_2_visits=0, image_loads=0, tick_calls=0, gate_open_rows=0,
                gate_closed_ticks=0, fatal_paths_matched=0, mismatches=0, rejections=0, fps_zero_original_faults=0,
                record_length_checks=0, click_inactive_skipped=0, malformed_cases=0, rejection_kinds=Counter(), effect_kinds=Counter(), groups={})


def run_scenario(x, lib, sc, stats):
    t0 = time.monotonic()
    before = (stats['steps'], stats['effects'])
    run = Run(x, lib, sc, stats)
    try:
        run.setup()
        run_steps(run, sc, stats)
        stats['scenarios'] += 1
    finally:
        run.close()
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['steps'] += stats['steps'] - before[0]
        g['effects'] += stats['effects'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


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
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-34.d8-oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib = open_lib(lib_path)
    x = X86(check_pins=not args.discover_pins)
    scs = scenario_list()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    stats = new_stats()
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52a000)
        scs = [s for s in scs if s['quick']]
    if args.quick_only:
        scs = [s for s in scs if s['quick']]
    if args.mutation_run:
        quick = [s for s in scs if s['quick']]
        bad = run_list(x, lib, quick, stats, fail_fast=True)
        if not bad:
            try:
                run_validation_rejections(lib, stats)
            except Mismatch as error:
                bad = [('validation', str(error))]
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    bad = run_list(x, lib, scs, stats, args.fail_fast)
    try:
        run_validation_rejections(lib, stats)
    except Mismatch as error:
        bad.append(('validation', str(error)))
        stats['mismatches'] += 1
    try:
        malformed_run(lib, stats)
    except Mismatch as error:
        bad.append(('malformed', str(error)))
        stats['mismatches'] += 1
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
        print('MISMATCH', sid, '::', msg[:500])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    print(json.dumps(summary, sort_keys=True))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:140])
    if args.result:
        sources = {n: sha((args.src / n).read_bytes()) for n in ('action_family_d8_runtime.c', 'action_family_d8_runtime.h')}
        killed = sum(1 for m in (mutations or []) if m['detected'])
        result = dict(slice='RT-34', oracle='d8', status='pass' if not bad else 'fail', mismatches=len(bad), exe_sha256=EXE_HASH,
                      source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_d8_runtime_oracle_driver.c').read_bytes()),
                      code_windows=[dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE],
                      scenarios=len(scs), stats=summary, mutations=mutations,
                      mutants_total=len(mutations or []), mutants_killed=killed, mismatch_list=bad[:50],
                      hooks_fired=dict(x.hooks_fired), counters=dict(x.counters), fpu_control_word=hex(FPCW),
                      elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
