#!/usr/bin/env python3
"""RT-24: immutable x86 dispatcher 0x427a50 / handler 0x47d788 versus the native raw-0xd9 Mouselight kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For raw 0xd9 rows the REAL dispatcher 0x427a50
runs: gate 0x423f57 (dependency tree built by the real loader 0x424aa8), the handler 0x47d788 with
ECX = singleton 0x6246dc, and, as original x86 code: the generic Z entry allocator 0x4d39f9 and
releaser 0x4d3992 on the table at 0x5d1591, the CRT sqrt 0x50df94 and exp 0x50de00 -> 0x51397b (x87,
FPU control word 0x27f as a Win32 process starts), the pointer receiver 0x47d734, the invalidate
0x47d640, the cleanup 0x47d59b with the reset 0x47d4f7, and the render callback 0x47df57. The native
side is src/action_family_d9_runtime.c driven by tests/action_family_d9_runtime_oracle_driver.c with a
scripted host. Compared for every scenario and step: the ordered D9_FX_* effects, the object image
(+0x1c..+0x57 as D9Object mirrors it), the process flag 0x5bb1ca, the row phase dword, the alpha map and
mask (every cell, bitwise; float mismatches are counted and reported separately), the 0x58 generic Z
entry tables byte for byte, and for the render callback the recorded blit calls against d9_render_plan.

COMPLETE HOOK INVENTORY (code hooks at function ENTRY unless an address inside is stated).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's `ret N`
 and returns), O = observed (recorded, the original body then runs), G = raising guard.
  R 0x51dc43 malloc          bump arena in the oracle's own 64 MiB heap (OS/CRT boundary), zero filled
  R 0x51dc6c free            recorded (counted); the original handler never frees, the cleanup does
  R 0x4c2790 load_image(kind,name,6,label) thiscall, ECX 0x5cf659, ret 0x10: returns the scripted handle
  R 0x510dd3 _getptd         returns a zeroed 0x74-byte thread-data block (reached from the CRT math-error path of exp,
             GetLastError/TlsGetValue/calloc are OS boundary); only errno-type bookkeeping lives there
  R 0x4c2dfb release_image(&handle) thiscall, ret 4: records the old value, zeroes *param (as the real
             routine's final store 0x4c2e4f does; its frees/engine work are outside this slice)
  R 0x4c5377 restore blit (ret 0x14)  R 0x4c6929 mask blit (ret 0x1c)  R 0x4c62f0 alpha blit (ret 0x24)
             recorders for the render callback test; ECX must be 0x5cf659
  R (stretch run only) 0x4c4067 surface lock (fills the DDSURFACEDESC fields the blits read from a flat 16-bit
             surface), 0x4c4202 unlock, 0x4c952f present; the blit bodies 0x4c5377 / 0x4c6929 / 0x4c62f0 and the CRT
             _ftol 0x50ce04 then run as ORIGINAL x86 against d9_blit_copy / d9_blit_mask / d9_blit_alpha on random
             pixels in RGB555/RGB565/BGR variants (shifts and masks at 0x5d2f1b/1a/19 and 0x5d2f1f/1e/1d)
  O 0x47d788 handler entry (row, phase, ECX check)   O 0x4d3992 release_entry(slot)
  O 0x47dd18 / 0x47dd57 / 0x47dd6e  instruction boundaries inside 0x47d788 (after the entry label copy, the
             slot surface store and the phase store): they only read memory
  UC_HOOK_MEM_WRITE observers over singleton +0x23, +0x49..+0x54, +0x57 and 0x5bb1ca (read-only, they log the
             effects of the stores); everything else is plain original execution
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: the fatal/logging paths (reaching one fails the run unless the
             scenario expects the allocator's fatal path 0x52139c, which is then compared with the native
             host error); 0x425b8b and 0x425b40 (debug tree printer / malformed tree) raise through the base.
 Windows imports (OS boundary, IAT slots patched to stubs): InterlockedIncrement/Decrement, lstrlenA,
 Enter/Leave/InitializeCriticalSection (single thread); any other import fails the run.
 FS needs a TIB page (GDT) for the SEH frame of 0x47d788. Debug flag 0x63a4cd is 0 (logging disabled).
 The singleton is constructed the way the original does: vtable word, then 0x47d4f7 (original code).

KNOWN DIFFERENCES (tagged scenarios, counted in stats.known_observed, never as passes):
  D1 re-init in the OTHER mode (alpha then mask or mask then alpha, no cleanup in between): the original keeps the
     first mode's buffer pointer (+0x4d / +0x51) and frees it again at cleanup; the native kernel clears it. The
     scenarios tolerate exactly that (object pointer presence, FREE effects of the stale buffer) and compare the rest.
  D2 view bounds arithmetic: the original computes [0x583192] - [0x58318a] + 5 in int32 (wraps), native in int64.
  D3 load_image returning 0: the original stores 0 and goes on, native stops with D9_ERR_HOST.
  D4 radius 0: native safety rejection (the original allocates 0 bytes and runs).
  D5 row phase above 1: the original's switch does nothing, native returns D9_ERR_ARGUMENT.
  D2..D5 are unreachable in the game (pixel-sized view values, loader checks, phases 0 and 1 only).

Dependency tails (':dep' scenarios) use the real loader 0x424aa8 and the original gate 0x423f57.
Scripted values shared by both sides (the stand-ins' contract, not original decisions): image handles,
view globals, the saved frame and back buffer handles, slot-busy seeds.

Not modelled / unverified (see the receipt): the real image loader 0x4c2790 and releaser 0x4c2dfb (hooked),
the DirectDraw surface helpers behind the real blit bodies unless the stretch run is on, the pointer
cascade 0x4f0059 that calls 0x47d734, and the scene loader 0x40b34a that allocates the body.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_d9_runtime_original_oracle.py --mutations --result <receipt.json>
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

import numpy as np
from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UcError
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

OBJ = 0x6246dc
ROWS = 0x5bb5b3
ROW = 0x8d
PHASE_OFF = 0x7f
COMPLETE_OFF = 0x72
ENTRY = 0x5d1591
STRIDE = 0x4a
NENT = 0x58
START_FLAG = 0x5bb1ca
G_ORIGIN_X, G_ORIGIN_Y, G_BOTTOM, G_MAX_X, G_MAX_Y = 0x583186, 0x58318a, 0x583192, 0x5831ae, 0x5831b2
G_SAVED, G_BACK = 0x5d15e3, 0x5cf665
G_MODE, G_ROWCOUNT, G_LOG = 0x583999, 0x5c39e3, 0x63a4cd
EVENTS_VA = 0x585801
TAIL_BASE = 0x2000a000
BODY_BASE = 0x22000000
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x4000000
TIB, GDT, STUBS = 0x7ff00000, 0x7ff10000, 0x7e000000
SURF_HOST = 0x5cf659
FPCW = 0x27f
LOAD_LABEL_SHA = '54f49224c8da0f374363549214f349570956a0f9eed1921a5e816032c91a0928'  # 27-byte debug label of 0x4c2790
BODY_LEN = 0x23
PTD = BODY_BASE + 0xf000

# effect kinds (D9Effect) plus the oracle's own marker
FX = dict(ENTER=0, TRACKING=1, START_FLAG=2, ALLOC=3, SLOT=4, SLOT_REGISTER=5, SURFACE_LOAD=6,
          SLOT_SURFACE=7, PHASE=8, RELEASE_SURFACE=9, RELEASE_SLOT=10, FREE=11)
FXN = {v: k for k, v in FX.items()}

OBJECT_FIELDS = ['active', 'row', 'surface', 'slot', 'ptr_x', 'ptr_y', 'rect0', 'rect1', 'rect2', 'rect3',
                 'prev0', 'prev1', 'prev2', 'prev3', 'composite', 'alpha', 'mask', 'radius', 'tracking']

# Original code windows: SHA-256 of the unmodified image bytes (function spans of the paths run here).
PINS_TABLE = (
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
 (0x424346, 0x424aa8,
  '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
 (0x424aa8, 0x425b8b,
  'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
 (0x427a50, 0x42acad,
  '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
 (0x47d4f7, 0x47d59b,
  '295bb44405bcc175b4ed581b988a811feccc35173d60bef91f7a1d2ddad68985'),
 (0x47d59b, 0x47d640,
  '69064fa7ea2d8f7db908498d2b9c653602941b79fa2e06cc62d1a968dafe287b'),
 (0x47d640, 0x47d677,
  'f75314f967435c4dd7d572ed3b8ae278c98b79cd41d37eb19fb0133c8d2bad32'),
 (0x47d734, 0x47d77d,
  '0fc7266b0f4fb4b88be1752afc9bd634476b1f6945388becec1b1b3b3910d256'),
 (0x47d788, 0x47df47,
  'fae8787d34e83034840e9cc7e55966eea93602bf00255b34a5e4eeea6a6ae52b'),
 (0x47df57, 0x47e140,
  '7ae121db784ba4e6da42541e9caf156f7ff8aa665d9e42c71e13772265c67b56'),
 (0x4c2790, 0x4c2898,
  '7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf'),
 (0x4c2dfb, 0x4c2e5b,
  '6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455'),
 (0x4c5377, 0x4c558b,
  'c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b'),
 (0x4c62f0, 0x4c6929,
  '4ceeadff45d34858cb017ccd7176fa8443e84c6467ec2dd77ceaf50769030e7c'),
 (0x4c6929, 0x4c6c2a,
  '98cfa18028a1053964eab26e92661e919a6bb60deb799eeb13acf6c7c1b4c281'),
 (0x4d3992, 0x4d39f9,
  'b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9'),
 (0x4d39f9, 0x4d3a52,
  '48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b'),
 (0x50de00, 0x50de14,
  'cbcdda7c917da570d301cfabbbf2e471e66135f7e21d795585ee9f0b4f9b0678'),
 (0x50df94, 0x50df9d,
  'bb2d93be04097eee8168c41b39bd09980842772d62c7417d8e0b80865ad114e5'),
 (0x50df9d, 0x50e040,
  '3508c6b23d60ca9ba3134faac7582544e295ac385c3bd5a5d5d0fd69a2c7f3e9'),
 (0x50ea7e, 0x50ea87,
  '45f4085b9f5af22acdc172ccf64fdbe893c7f332ab3fabe68f50aacc25cbe47d'),
 (0x510dd3, 0x510e3a,
  '20cf859c5de096b4df74fcb2a62bf3fe20adc24e692782e53d071c8e8fea0893'),
 (0x513546, 0x513780,
  'cae5642c9fc4bd3267ac20eceb1eaa06de5428e3876e94218a34a4689f522136'),
 (0x513843, 0x51384a,
  'c80b5f12370575503df33ce7e3f902d20264e38a928d912510a69a13bae93fee'),
 (0x51384a, 0x51397b,
  '326072a4d3ee173c7b0f57ff2e1606951362f5d7fa5744b41f4adcbad4824f6f'),
 (0x51397b, 0x5139ae,
  '848ce949502d44921535d858bb025390f2c24f90f810f862c960d9515e0bc8bf'),
 (0x5139ae, 0x5139f0,
  'f13e6117a8db812e961cc700c00f1b7c99696631c2e5dde2d0582fb6d73bbf1f'),
 (0x5139f0, 0x513a57,
  'fc736a710900a9081a126a61344250d00742ffc3e15d08a61f56e54099112ae7'),
 (0x513a57, 0x513bc0,
  'd0196808f22e7da2a7a16aff618de832adc311c484470b8fb6d83a641bd649e6'),
 (0x513c65, 0x513ca8,
  '49756c88592603c59a91d5ecf8589dab665fc8a2ad0f138e5d6e3c3b05c21169'),
 (0x513ccb, 0x513dac,
  '1f6176013055a3631ad0b0b35b3d87558fcb54dc4bf98d39621482bb29d6452a'),
 (0x5144ef, 0x514517,
  '2344d29ba87c9fc101dc8b4832ad673b964a7d7d7be1e7efdedc2e5031d7c01c'),
 (0x5146dc, 0x5146ff,
  '84749c64e12c57ce2a4dec7bdb50573ab3dd9f851b65e73be2fba62d0cfec3b2'),
 (0x5187fb, 0x5188cb,
  'fdc9a1a0008572564196579be445ad049abbac26bf89c57b307b47cfa8ec2309'),
 (0x51dc43, 0x51dc6c,
  '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
 (0x51dc6c, 0x51dc77,
  '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
 (0x51e7ba, 0x51e7e4,
  '55e7e58804caf60fe8d384c84895fe88307f9f9de956834d5a82b6be929c689f'),
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


def body_bytes(name=b'PUZZLE1', radius=150, mode=1, fill=0xbb):
    b = bytearray(name[:32] + b'\0')
    b += bytes([fill]) * (0x21 - len(b))
    b += bytes([radius, mode])
    assert len(b) == BODY_LEN
    return bytes(b)


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_d9_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_d9_runtime.c'), '-lm', '-o', str(out)]
    if os.environ.get('D9_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


def open_lib(path):
    lib = C.CDLL(str(path))
    p, i32, u8p = C.c_void_p, C.c_int32, C.POINTER(C.c_uint8)
    lib.d9o_new.restype = p
    lib.d9o_free.argtypes = [p]
    lib.d9o_set_view.argtypes = [p, i32, i32, i32, i32, i32]
    lib.d9o_set_world_flag.argtypes = [p, i32]
    lib.d9o_get_world_flag.argtypes = [p]
    lib.d9o_get_world_flag.restype = i32
    lib.d9o_set_handles.argtypes = [p, C.POINTER(C.c_uint32), C.c_int]
    lib.d9o_set_busy.argtypes = [p, C.c_int, C.c_int]
    lib.d9o_clear_log.argtypes = [p]
    lib.d9o_set_entry_u32.argtypes = [p, C.c_int, C.c_int, C.c_uint32]
    lib.d9o_step.argtypes = [p, u8p, C.c_int, C.c_uint32, C.POINTER(C.c_uint32)]
    lib.d9o_step.restype = C.c_int
    lib.d9o_why.argtypes = [p]
    lib.d9o_why.restype = C.c_char_p
    lib.d9o_bad_slot_calls.argtypes = [p]
    lib.d9o_pointer.argtypes = [p, C.c_int, C.c_int]
    lib.d9o_invalidate.argtypes = [p]
    lib.d9o_cleanup.argtypes = [p]
    lib.d9o_log_count.argtypes = [p]
    lib.d9o_log.argtypes = [p, C.c_int, C.POINTER(i32)]
    lib.d9o_name_count.argtypes = [p]
    lib.d9o_name.argtypes = [p, C.c_int]
    lib.d9o_name.restype = C.c_char_p
    lib.d9o_object.argtypes = [p, C.POINTER(i32)]
    lib.d9o_alpha_bytes.argtypes = [p]
    lib.d9o_alpha_bytes.restype = C.c_size_t
    lib.d9o_mask_bytes.argtypes = [p]
    lib.d9o_mask_bytes.restype = C.c_size_t
    lib.d9o_alpha_copy.argtypes = [p, C.c_void_p]
    lib.d9o_mask_copy.argtypes = [p, C.c_void_p]
    lib.d9o_entries.argtypes = [p, u8p]
    lib.d9o_plan.argtypes = [p, u8p, C.POINTER(i32)]
    lib.d9o_plan.restype = C.c_int
    return lib


class Native:
    def __init__(self, lib):
        self.lib = lib
        self.h = lib.d9o_new()

    def close(self):
        self.lib.d9o_free(self.h)

    def set_view(self, v):
        self.lib.d9o_set_view(self.h, *v)

    def set_handles(self, hs):
        arr = (C.c_uint32 * max(1, len(hs)))(*hs)
        self.lib.d9o_set_handles(self.h, arr, len(hs))

    def step(self, body, row, phase):
        L = self.lib
        L.d9o_clear_log(self.h)
        buf = (C.c_uint8 * BODY_LEN).from_buffer_copy(body)
        res = (C.c_uint32 * 2)()
        status = L.d9o_step(self.h, buf, row, phase, res)
        return status, (L.d9o_why(self.h) or b'').decode(), self.fx(), self.names(), list(res)

    def fx(self):
        out = []
        t = (C.c_int32 * 3)()
        for i in range(self.lib.d9o_log_count(self.h)):
            self.lib.d9o_log(self.h, i, t)
            out.append((t[0], t[1], t[2]))
        return out

    def names(self):
        return [self.lib.d9o_name(self.h, i).decode('latin1') for i in range(self.lib.d9o_name_count(self.h))]

    def simple(self, fn):
        self.lib.d9o_clear_log(self.h)
        status = fn()
        return status, self.fx()

    def obj(self):
        t = (C.c_int32 * 25)()
        self.lib.d9o_object(self.h, t)
        return list(t)[:19]

    def entries(self):
        t = (C.c_uint8 * (NENT * STRIDE))()
        self.lib.d9o_entries(self.h, t)
        return bytes(t)

    def alpha(self):
        n = self.lib.d9o_alpha_bytes(self.h)
        if not n:
            return b''
        t = (C.c_uint8 * n)()
        self.lib.d9o_alpha_copy(self.h, t)
        return bytes(t)

    def mask(self):
        n = self.lib.d9o_mask_bytes(self.h)
        if not n:
            return b''
        t = (C.c_uint8 * n)()
        self.lib.d9o_mask_copy(self.h, t)
        return bytes(t)

    def plan(self, body):
        t = (C.c_int32 * 32)()
        buf = (C.c_uint8 * BODY_LEN).from_buffer_copy(body)
        status = self.lib.d9o_plan(self.h, buf, t)
        v = list(t)
        return status, dict(valid=v[0], restore_src=v[1:5], restore_dst=v[5:9], kind=v[9], surface=v[10] & 0xffffffff,
                            src=v[11:15], dst=v[15:19], map=v[19:23])


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


STRETCH_POPS = {0x4c4067: 0x14, 0x4c4202: 0x0c, 0x4c952f: 4}
BLITS = (0x4c5377, 0x4c6929, 0x4c62f0)
POPS = {0x510dd3: 0, 0x51dc6c: 0, 0x4c2790: 0x10, 0x4c2dfb: 4, 0x4c5377: 0x14, 0x4c6929: 0x1c, 0x4c62f0: 0x24}
GUARDS = [0x4c97b4, 0x42639d, 0x50ca3e, 0x52139c, 0x44a2b7]


class X86(deps.OriginalMachine):
    active = False

    def __init__(self):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.pristine = bytes(self.pe.image)
        if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
            raise OracleError('executable identity mismatch')
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
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
        self.mode = 'idle'          # 'step' | 'cleanup' | 'idle'
        self.fx = []
        self.entered = []
        self.allocs = {}
        self.heap_cursor = HEAP_BASE
        self.heap_high = HEAP_BASE
        self.frees = []
        self.blits = []
        self.loaded = []
        self.handles = []
        self.handle_i = 0
        self.counters = Counter()
        self.hooks_fired = Counter()
        self.imports = {}
        self._fatal = None
        self.expect_fatal = None
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
        for a in STRETCH_POPS:
            table[a] = self._stretch_helper
        for a in GUARDS:
            table[a] = self._raise
        table[0x47d788] = self._entry
        table[0x4d3992] = self._release_entry
        table[0x47dd18] = self._at_register
        table[0x47dd57] = self._at_slot_surface
        table[0x47dd6e] = self._at_phase
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=OBJ + 0x23, end=OBJ + 0x57)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=START_FLAG, end=START_FLAG + 3)

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
        r = self.rd(OBJ + 0x1c, 0x3c)  # +0x1c..+0x57
        g = lambda off, fmt: struct.unpack_from(fmt, r, off - 0x1c)[0]
        return [g(0x1c, '<B'), g(0x1d, '<h'), g(0x1f, '<i'), g(0x23, '<h'), g(0x25, '<h'), g(0x27, '<h'),
                g(0x29, '<i'), g(0x2d, '<i'), g(0x31, '<i'), g(0x35, '<i'),
                g(0x39, '<i'), g(0x3d, '<i'), g(0x41, '<i'), g(0x45, '<i'),
                int(g(0x49, '<I') != 0), int(g(0x4d, '<I') != 0), int(g(0x51, '<I') != 0),
                g(0x55, '<h'), g(0x57, '<B')]

    def entries(self):
        return self.rd(ENTRY, NENT * STRIDE)

    def row_phase(self, row):
        return struct.unpack('<I', self.rd(ROWS + row * ROW + PHASE_OFF, 4))[0]

    def buffer(self, field, size):
        p = struct.unpack('<I', self.rd(OBJ + field, 4))[0]
        return self.rd(p, size) if p else b''

    def entry_surface(self, slot):
        return struct.unpack('<I', self.rd(ENTRY + slot * STRIDE + 8, 4))[0]

    # -- effects ---------------------------------------------------------------------------------
    def log(self, kind, a=0, b=0):
        self.fx.append((kind, a & 0xffffffff if a >= 0 else a, b))

    def _on_write(self, uc, access, address, size, value, user):
        if self.mode != 'step':
            return
        off = address - OBJ
        if address == START_FLAG and size == 4:
            self.fx.append((FX['START_FLAG'], value & 0xffffffff, 0))
        elif off == 0x57:
            self.fx.append((FX['TRACKING'], value & 0xff, 0))
        elif off == 0x23 and size == 2:
            v = value & 0xffff
            self.fx.append((FX['SLOT'], v - 0x10000 if v & 0x8000 else v, 0))
        elif off in (0x49, 0x4d, 0x51) and size == 4:
            v = value & 0xffffffff
            if v:
                self.fx.append((FX['ALLOC'], self.allocs[v], (0x49, 0x4d, 0x51).index(off)))
            else:
                raise OracleError('zero buffer pointer stored in step mode')

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != OBJ:
            raise OracleError('handler entered with ECX != 0x6246dc')
        phase = self.row_phase(row)
        self.entered.append((row, phase))
        self.fx.append((FX['ENTER'], row, phase))

    def _at_register(self, uc, address, size, user):
        slot = self.s16(OBJ + 0x23)
        self.fx.append((FX['SLOT_REGISTER'], slot, self.entry_surface(slot)))
        self.registered = (slot, self.rd(ENTRY + slot * STRIDE, STRIDE))

    def _at_slot_surface(self, uc, address, size, user):
        self.fx.append((FX['SLOT_SURFACE'], self.entry_surface(self.s16(OBJ + 0x23)), 0))

    def _at_phase(self, uc, address, size, user):
        row = self.s16(OBJ + 0x1d)
        self.fx.append((FX['PHASE'], self.row_phase(row), 0))

    def _release_entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        slot = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if self.mode == 'cleanup':
            self.fx.append((FX['RELEASE_SLOT'], slot, 0))

    stretch = False

    def _stretch_helper(self, uc, address, size, user):
        # surface lock / unlock / present stand-ins, active only in the stretch run (flat 16-bit surfaces)
        if not self.stretch:
            raise OracleError('surface helper %#x reached outside the stretch run' % address)
        self.hooks_fired['S %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(5)]
        if address == 0x4c4067:  # lock(surface, rect, desc, name, flags) -> fills the DDSURFACEDESC fields the blits read
            surf, rect, desc = a[0], a[1], a[2]
            base = u32(uc, surf)
            pitch = struct.unpack('<h', bytes(uc.mem_read(surf + 0x2f, 2)))[0]
            left, top, right, bottom = struct.unpack('<4i', bytes(uc.mem_read(rect, 16)))
            uc.mem_write(desc, struct.pack('<I', 0x6c))
            uc.mem_write(desc + 8, struct.pack('<ii', bottom - top + 1, right - left + 1))
            uc.mem_write(desc + 0x10, struct.pack('<i', pitch))
            uc.mem_write(desc + 0x24, struct.pack('<I', base + top * pitch + left * 2))
        self._ret(uc, STRETCH_POPS[address])

    def _replaced(self, uc, address, size, user):
        if self.stretch and address in BLITS:
            return  # run the real blit body
        self.hooks_fired['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(9)]
        eax = 0
        if address == 0x510dd3:  # CRT _getptd: per-thread data block of the single oracle thread
            eax = PTD
        elif address == 0x51dc6c:
            self.frees.append(a[0])
            if self.mode == 'cleanup':
                idx = {struct.unpack('<I', self.rd(OBJ + f, 4))[0]: i for i, f in enumerate((0x49, 0x4d, 0x51))}
                if a[0] not in idx or a[0] == 0:
                    raise OracleError('free of a pointer that is not a d9 buffer')
                self.fx.append((FX['FREE'], 0, idx[a[0]]))
            elif self.mode == 'step':
                raise OracleError('the original handler never frees')
        elif address == 0x4c2790:
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('image loader ECX')
            kind, name, six, label = cstr(self.rd(a[0], 32)), cstr(self.rd(a[1], 64)), a[2], cstr(self.rd(a[3], 64))
            if kind != b'CIFTREE' or six != 6 or sha(label) != LOAD_LABEL_SHA:
                raise OracleError('image loader arguments differ from the packet')
            eax = self.handles[self.handle_i] if self.handle_i < len(self.handles) else 0
            self.handle_i += 1
            self.loaded.append(name.decode('latin1'))
            self.fx.append((FX['SURFACE_LOAD'], eax, 0))
        elif address == 0x4c2dfb:
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('image release ECX')
            old = u32(uc, a[0])
            if self.mode == 'cleanup':
                self.fx.append((FX['RELEASE_SURFACE'], old, 0))
            self.wr(a[0], bytes(4))
        elif address in (0x4c5377, 0x4c6929, 0x4c62f0):
            if uc.reg_read(X.UC_X86_REG_ECX) != SURF_HOST:
                raise OracleError('blit ECX')
            rect = lambda p: list(struct.unpack('<4i', self.rd(p, 16)))
            if address == 0x4c5377:
                self.blits.append(dict(kind='restore', src_surface=a[0], dst_surface=a[1], src=rect(a[2]),
                                       dst=rect(a[3]), src_ptr=a[2]))
            elif address == 0x4c6929:
                self.blits.append(dict(kind='mask', surface=a[0], dst_surface=a[1], map_ptr=a[2], src=rect(a[3]),
                                       dst=rect(a[4]), map=rect(a[5]), src_ptr=a[3]))
            else:
                self.blits.append(dict(kind='alpha', surface=a[0], saved=a[1], dst_surface=a[2], map_ptr=a[3],
                                       src=rect(a[4]), src2=rect(a[5]), dst=rect(a[6]), map=rect(a[7]),
                                       src_ptr=a[4], src2_ptr=a[5]))
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
        self.frees = []
        self.blits = []
        self.loaded = []
        self.fx = []
        self.entered = []
        self.handle_i = 0
        self.mode = 'idle'
        self.expect_fatal = None
        if self.rd(G_LOG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')
        self.w32(OBJ, 0x52d5a8)  # CObject vtable word, as the constructor 0x47d4b? writes it
        self.call(0x47d4f7, [], OBJ)  # the constructor's reset, original code

    def install_rows(self, rows, first=0):
        """`rows`: list of dict(body=bytes, tail=bytes). Rows below `first` are completed dummies."""
        total = first + len(rows)
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            body_at = BODY_BASE + 0x40 * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([0xd9, 2]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(G_ROWCOUNT, struct.pack('<h', total))

    def dispatch(self):
        self.fx = []
        self.entered = []
        self.wr(0x5c3a47, bytes(4))
        self.mode = 'step'
        try:
            self.call(0x427a50, [], 0)
        finally:
            self.mode = 'idle'

    def run_mode(self, mode, address, args, ecx):
        self.fx = []
        self.mode = mode
        try:
            return self.call(address, args, ecx)[0]
        finally:
            self.mode = 'idle'

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
    return '%s(%d,%d)' % (FXN.get(k, k), a if a < 0x80000000 or a < 0 else a - (1 << 32), b)


def norm_fx(seq):
    out = []
    for k, a, b in seq:
        a = a & 0xffffffff
        out.append((k, a - (1 << 32) if a & 0x80000000 else a, b))
    return out


def compare_fx(where, orig, nat, known=None, stats=None):
    orig, nat = norm_fx(orig), norm_fx(nat)
    if known:  # D1: the original also frees the stale buffer of the other mode at cleanup
        keep = lambda seq: [t for t in seq if t[0] != FX['FREE'] or t[2] == 0]
        if keep(orig) == keep(nat) and orig != nat:
            stats['known_observed'][known + ':free_effects'] += 1
        orig, nat = keep(orig), keep(nat)
    if orig != nat:
        k = next((i for i in range(min(len(orig), len(nat))) if orig[i] != nat[i]), min(len(orig), len(nat)))
        raise Mismatch('%s effect %d: original %s vs native %s' % (
            where, k, fx_text(orig[k]) if k < len(orig) else None, fx_text(nat[k]) if k < len(nat) else None))


def compare_alpha(where, x, nat, stats):
    r = x.s16(OBJ + 0x55)
    na, nm = nat.alpha(), nat.mask()
    if True:
        pa = struct.unpack('<I', x.rd(OBJ + 0x4d, 4))[0]
        pm = struct.unpack('<I', x.rd(OBJ + 0x51, 4))[0]
        oa = x.rd(pa, 16 * r * r) if pa else b''
        om = x.rd(pm, 4 * r * r) if pm else b''
        if x.known:  # only the maps the native kernel holds are comparable (D1 stale pointers)
            oa, om = (oa if na else b''), (om if nm else b'')
        if bool(oa) != bool(na) or bool(om) != bool(nm):
            raise Mismatch('%s map presence differs (alpha %s/%s, mask %s/%s)' % (where, bool(oa), bool(na), bool(om), bool(nm)))
        if om:
            stats['mask_cells'] += len(om)
            if om != nm:
                k = next(i for i in range(len(om)) if om[i] != nm[i])
                diff = sum(1 for i in range(len(om)) if om[i] != nm[i])
                raise Mismatch('%s mask differs at cell %d (dy=%d dx=%d) original %d native %d, %d cells' % (
                    where, k, k // (2 * r) - r, k % (2 * r) - r, om[k], nm[k], diff))
        if oa:
            ca, cb = np.frombuffer(oa, dtype=np.uint32), np.frombuffer(na, dtype=np.uint32)
            stats['alpha_cells'] += len(ca)
            bad = np.nonzero(ca != cb)[0]
            if len(bad):
                stats['float_mismatch_cells'] += int(len(bad))
                fa = ca[bad].view(np.float32).astype(np.float64)
                fb = cb[bad].view(np.float32).astype(np.float64)
                ulps = np.abs(ca[bad].astype(np.int64) - cb[bad].astype(np.int64))
                stats['float_max_ulp'] = max(stats['float_max_ulp'], int(ulps.max()))
                k = int(bad[0])
                raise Mismatch('FLOAT %s alpha differs at %d cells, first cell %d (dy=%d dx=%d) original %08x (%r) native %08x (%r)' % (
                    where, len(bad), k, k // (2 * r) - r, k % (2 * r) - r, ca[k], fa[0], cb[k], fb[0]))


def compare_state(where, x, nat, stats, buffers=False):
    oo, no = x.object(), nat.obj()
    stats['state_compares'] += 1
    stats['object_fields'] += len(oo)
    if oo != no:
        diff = [i for i in range(len(oo)) if oo[i] != no[i]]
        k = diff[0]
        if x.known and all(OBJECT_FIELDS[i] in ('alpha', 'mask') for i in diff):
            stats['known_observed'][x.known + ':object_pointer'] += 1  # stale buffer pointer, see KNOWN_DEFECTS
        else:
            raise Mismatch('%s object field %s: original %d native %d' % (where, OBJECT_FIELDS[k], oo[k], no[k]))
    if x.s32(START_FLAG) != C_flag(nat):
        raise Mismatch('%s flag 0x5bb1ca: original %d native %d' % (where, x.s32(START_FLAG), C_flag(nat)))
    ea, eb = x.entries(), nat.entries()
    stats['entry_bytes'] += len(ea)
    if ea != eb:
        k = next(i for i in range(len(ea)) if ea[i] != eb[i])
        raise Mismatch('%s entry table slot %#x +%#x original %02x native %02x' % (where, k // STRIDE, k % STRIDE, ea[k], eb[k]))
    if buffers:
        compare_alpha(where, x, nat, stats)


def C_flag(nat):
    return nat.lib.d9o_get_world_flag(nat.h)


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
VIEWS = {
    'v0': (0, 0, 340, 639, 339),
    'v1': (13, 21, 361, 652, 358),
    'small': (0, 0, 100, 30, 20),      # source rectangle smaller than the window
    'neg': (5, 5, 100, -3, -2),        # degenerate negative edges
    'wide': (0, 0, 480, 799, 599),
}


def pointer_sweep(rng, r, view, extra=0):
    ox, oy, bottom, mx, my = view
    lim = bottom - oy + 5
    pts = [(0, 0), (r, r), (r - 1, r - 1), (-1, -1), (-r, -r), (1, 1), (mx, my), (mx + 1, my + 1),
           (mx - r + 1, 0), (mx - r + 2, 0), (0, my - r + 1), (0, my - r + 2),
           (0, lim), (0, lim - 1), (0, lim + 1), (5, lim + 400), (32767, 32767), (-32768, -32768),
           (32767, -32768), (-32768, 32767), (-500, -500), (r, 0), (0, r), (r - 1, 0), (0, r - 1)]
    for _ in range(extra):
        pts.append((rng.randrange(-250, 760), rng.randrange(-250, 460)))
    return pts


def sweep_actions(rng, r, view_name, with_render=True, extra=0, every=1):
    view = VIEWS[view_name]
    acts = [('view', view_name)]
    for i, (px, py) in enumerate(pointer_sweep(rng, r, view, extra)):
        acts += [('ptr', px, py), ('tick',)]
        if with_render and i % every == 0:
            acts.append(('render', 0x11110000 + i, 0x22220000 + i))
    return acts


def scenario_list(seed=24, all_radii=False):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions, group, **kw):
        sc = dict(id=sid, rows=rows, actions=actions, group=group, handles=kw.pop('handles', [0x7001, 0x7002, 0x7003, 0x7004, 0x7005]),
                  first=kw.pop('first', 0), busy=kw.pop('busy', []), quick=kw.pop('quick', False),
                  expect_fatal=kw.pop('expect_fatal', None), world=kw.pop('world', {}), events=kw.pop('events', {}))
        sc.update(kw)
        scs.append(sc)

    def R(name, radius, mode, tail=b''):
        return dict(body=body_bytes(name, radius, mode), tail=tail)

    # -- pre-init behaviour: pointer ignored while not tracking, render without calls, plan not valid
    S('pre:pointer_before_init', [R(b'PZ_A', 12, 1)],
      [('ptr', 7, 9), ('render', 1, 2), ('tick',), ('ptr', 3, 4), ('tick',), ('render', 5, 6)], 'basic', quick=True)
    # -- the main shapes in miniature (quick set) and at corpus size
    small_shapes = [(1, 0), (1, 1), (2, 1), (3, 0), (4, 1), (7, 1), (12, 0), (16, 1), (23, 1), (31, 0), (40, 1), (50, 0)]
    for i, (r, mode) in enumerate(small_shapes):
        vn = ['v0', 'v1', 'small', 'neg', 'wide'][i % 5]
        S('shape:r%d_m%d_%s' % (r, mode, vn), [R(b'IMG_%d' % r, r, mode)],
          [('tick',)] + sweep_actions(rng, r, vn, extra=4, every=2) + [('invalidate',), ('cleanup',), ('invalidate',), ('ptr', 4, 4),
                                                              ('tick',), ('render', 9, 9)], 'shapes', quick=r <= 23)
    for r, mode in ((50, 1), (64, 1), (100, 0), (100, 1)):
        S('corpusish:r%d_m%d' % (r, mode), [R(b'MOUSE_%d' % r, r, mode)],
          [('tick',)] + sweep_actions(rng, r, 'v0', extra=2, every=3) + [('cleanup',)], 'shapes')
    # -- the corpus radii: 150/1 (245 rows), 200/1 (8), 50/0 (2)
    S('corpus:r150_m1', [R(b'MOUSELIGHT_PUZZLE_150', 150, 1)],
      [('tick',)] + sweep_actions(rng, 150, 'v0', extra=6, every=2) + [('view', 'v1'), ('ptr', 150, 150), ('tick',),
       ('render', 3, 4), ('cleanup',)], 'corpus')
    S('corpus:r200_m1', [R(b'MOUSELIGHT_PUZZLE_200', 200, 1)],
      [('tick',)] + sweep_actions(rng, 200, 'v1', extra=4, every=2) + [('cleanup',)], 'corpus')
    S('corpus:r50_m0', [R(b'MOUSELIGHT_PUZZLE_50', 50, 0)],
      [('tick',)] + sweep_actions(rng, 50, 'v0', extra=6, every=1) + [('cleanup',)], 'corpus')
    # -- radii where r^4 wraps int32 (>= 216) and exp overflows
    S('wrap:r216_m1', [R(b'WRAP216', 216, 1)], [('tick',), ('ptr', 100, 100), ('tick',), ('render', 1, 2)], 'wrap')
    S('wrap:r247_m1', [R(b'WRAP247', 247, 1)], [('tick',), ('ptr', 100, 100), ('tick',), ('render', 1, 2), ('cleanup',)], 'wrap', quick=True)  # only radius whose r^4/2 rounding is visible in float
    S('wrap:r217_m1', [R(b'WRAP217', 217, 1)], [('tick',), ('ptr', 100, 100), ('tick',), ('render', 1, 2)], 'wrap', quick=True)
    S('wrap:r255_m1', [R(b'WRAP255', 255, 1)], [('tick',), ('ptr', 300, 200), ('tick',), ('render', 1, 2), ('cleanup',)], 'wrap')
    S('wrap:r255_m0', [R(b'MASK255', 255, 0)], [('tick',), ('ptr', 300, 200), ('tick',), ('render', 1, 2), ('cleanup',)], 'wrap')
    # -- every radius 1..64 in both modes, and a stride through 65..255 plus the int32 wrap boundary
    sweep = list(range(1, 256)) if all_radii else list(range(1, 65)) + list(range(65, 256, 9)) + [214, 215, 217, 218, 247, 253, 254]
    for r in sorted(set(sweep)):
        for mode in (0, 1):
            vn = ('v0', 'v1', 'small', 'neg', 'wide')[(r + mode) % 5]
            S('radius:r%d_m%d' % (r, mode), [R(b'RS%d' % r, r, mode)],
              [('tick',), ('view', vn), ('ptr', r, r // 2), ('tick',), ('render', 1, 2), ('ptr', 3, 400), ('tick',),
               ('ptr', r + 1, -r), ('tick',), ('render', 3, 4), ('cleanup',)], 'radius', quick=(r in (1, 2, 3, 8) and mode == 1))
    # -- image names: empty first byte, 32 characters, short
    for k, nm in enumerate((b'A', b'0123456789ABCDEF0123456789ABCDEF', b'', b'x' * 5)):
        S('name:%d' % k, [R(nm, 5, 1)], [('tick',), ('tick',), ('cleanup',)], 'basic', quick=True)
    # -- phase 0 then many phase 1 visits without pointer movement (prev = rect, stable)
    S('phase1:repeat', [R(b'PZ', 9, 1)], [('tick',), ('ptr', 20, 30), ('tick',), ('tick',), ('tick',), ('render', 1, 1),
                                          ('ptr', 21, 31), ('tick',), ('render', 2, 2), ('tick',), ('render', 3, 3)], 'basic', quick=True)
    # -- two and three rows in one scene (singleton re-init), different shapes
    S('rows:two_alpha', [R(b'ROW_A', 12, 1), R(b'ROW_B', 7, 1)],
      [('tick',), ('ptr', 10, 11), ('tick',), ('render', 1, 2), ('tick',), ('cleanup',)], 'rows', quick=True)
    S('rows:two_mask', [R(b'ROW_A', 12, 0), R(b'ROW_B', 7, 0)],
      [('tick',), ('ptr', 10, 11), ('tick',), ('render', 1, 2), ('tick',), ('cleanup',)], 'rows', quick=True)
    S('rows:three_alpha', [R(b'ROW_A', 6, 1), R(b'ROW_B', 9, 1), R(b'ROW_C', 3, 1)],
      [('tick',), ('ptr', 4, 5), ('tick',), ('tick',), ('render', 1, 2), ('cleanup',), ('tick',), ('render', 1, 2)], 'rows', quick=True,
      handles=[0x7101, 0x7102, 0x7103, 0x7104])
    # D1 (known native defect): a re-init in the OTHER mode leaves the first mode's buffer pointer in place
    S('rows:mixed_alpha_then_mask', [R(b'ROW_A', 12, 1), R(b'ROW_B', 7, 0)],
      [('tick',), ('ptr', 10, 11), ('tick',), ('render', 1, 2), ('tick',), ('cleanup',)], 'known', known='D1', quick=False)
    S('rows:mixed_mask_then_alpha', [R(b'ROW_A', 6, 0), R(b'ROW_B', 9, 1), R(b'ROW_C', 3, 1)],
      [('tick',), ('ptr', 4, 5), ('tick',), ('tick',), ('render', 1, 2), ('cleanup',), ('tick',), ('render', 1, 2)], 'known', known='D1')
    S('known:corpus_pair_mixed', [R(b'MOUSE_PAIR_A', 150, 1), R(b'MOUSE_PAIR_B', 50, 0)],
      [('tick',), ('ptr', 200, 100), ('tick',), ('render', 1, 2), ('cleanup',)], 'known', known='D1')
    # D2..D5: documented, unreachable-in-the-game differences of the native safety layer (expected to mismatch)
    S('known:D2_view_int32_wrap', [R(b'KD2', 6, 1)], [('tick',), ('view_raw', (0, -2147483647, 2147483647, 639, 339)), ('ptr', 0, 100), ('tick',)],
      'known', expect_mismatch='D2')
    S('known:D3_load_returns_zero', [R(b'KD3', 6, 1)], [('tick',)], 'known', handles=[0], expect_mismatch='D3')
    S('known:D4_radius_zero', [R(b'KD4', 0, 1)], [('tick',)], 'known', expect_mismatch='D4')
    S('known:D5_phase_above_one', [R(b'KD5', 6, 1)], [('tick',), ('setphase', 0, 2), ('tick',)], 'known', expect_mismatch='D5')
    S('rows:offset_first_row', [R(b'ROW_A', 8, 1), R(b'ROW_B', 8, 1)],
      [('tick',), ('ptr', 1, 1), ('tick',), ('render', 4, 5)], 'rows', first=2, quick=True)
    S('rows:corpus_pair', [R(b'MOUSE_PAIR_A', 150, 1), R(b'MOUSE_PAIR_B', 200, 1)],
      [('tick',), ('ptr', 200, 100), ('tick',), ('render', 1, 2), ('cleanup',)], 'rows')
    # -- cleanup then re-init (new scene), flag and surface carried over exactly as the original does
    S('cleanup:reinit', [R(b'SCENE1', 10, 1)],
      [('tick',), ('ptr', 30, 40), ('tick',), ('cleanup',), ('tick',), ('rows', [R(b'SCENE2', 6, 0)], 0), ('tick',), ('ptr', 2, 2),
       ('tick',), ('render', 1, 2), ('invalidate',), ('cleanup',), ('cleanup',), ('invalidate',)], 'cleanup', quick=True)
    S('reinit:no_cleanup', [R(b'SCENE1', 10, 1)],
      [('tick',), ('ptr', 30, 40), ('tick',), ('tick',), ('rows', [R(b'SCENE2', 6, 1)], 0), ('render', 1, 2), ('tick',), ('render', 1, 2),
       ('ptr', 2, 2), ('tick',), ('cleanup',)], 'cleanup', quick=True)
    S('cleanup:phase1_after', [R(b'SCENE1', 10, 1)],
      [('tick',), ('ptr', 30, 40), ('tick',), ('cleanup',), ('tick',), ('tick',), ('ptr', 8, 8), ('tick',), ('invalidate',)], 'cleanup', quick=True)
    S('cleanup:before_init', [R(b'SCENE1', 10, 1)], [('cleanup',), ('invalidate',), ('tick',), ('invalidate',)], 'cleanup', quick=True)
    # -- generic Z entry allocation: busy seeds, first free, exhaustion (fatal path of 0x4d39f9)
    S('slots:busy_low', [R(b'SL', 5, 1)], [('tick',), ('invalidate',), ('cleanup',)], 'slots', busy=[0x18, 0x19, 0x1a], quick=True)
    S('slots:busy_gap', [R(b'SL', 5, 0), R(b'SM', 4, 0)], [('tick',), ('tick',), ('invalidate',), ('cleanup',)], 'slots',
      busy=[0x18, 0x1a, 0x1b, 0x3e], quick=True)
    S('slots:last_free', [R(b'SL', 5, 1)], [('tick',), ('ptr', 2, 2), ('tick',), ('render', 1, 1), ('cleanup',)], 'slots',
      busy=list(range(0x18, 0x3f)), quick=True)
    S('slots:exhausted', [R(b'SL', 5, 1)], [('tick',)], 'slots', busy=list(range(0x18, 0x40)), expect_fatal=0x52139c, quick=True)
    S('slots:below_range_ignored', [R(b'SL', 5, 1)], [('tick',), ('cleanup',)], 'slots', busy=[0x00, 0x10, 0x17, 0x40, 0x57], quick=True)
    # -- gate decisions: world mode, dependency tails through the real loader and gate
    S('gate:mode4', [R(b'GM', 5, 1)], [('tick',), ('tick',), ('mode', 3), ('tick',)], 'gate', world=dict(mode=4), quick=True)
    for gi, (gidx, gval, unlock) in enumerate(((40, 1, 3), (41, 0, 2), (42, 5, 1))):
        tail = struct.pack('<8h', 2, gidx, gval, 0, 0, 0, 0, 0)
        S('gate:dep%d' % gi, [R(b'GD%d' % gi, 6, 1, tail), R(b'GE', 4, 1)],
          [('tick',), ('tick',), ('events', {gidx: gval}), ('tick',), ('ptr', 3, 3), ('tick',), ('render', 1, 2), ('events', {gidx: gval + 1}),
           ('tick',), ('ptr', 4, 4), ('tick',), ('render', 3, 4)], 'gate', events={gidx: gval + 7}, quick=True)
    # -- view geometry matrix at one radius, many pointers (both alpha and mask)
    for vn in VIEWS:
        for mode in (0, 1):
            S('views:%s_m%d' % (vn, mode), [R(b'VIEW_%s' % vn.encode(), 18, mode)],
              [('tick',)] + sweep_actions(rng, 18, vn, extra=10, every=1) + [('view', vn), ('cleanup',)], 'views', quick=vn in ('v1', 'neg'))
    # -- random pointer streams with changing views
    for n in range(6):
        r = rng.choice([2, 5, 9, 14, 20, 28])
        acts = [('tick',)]
        for _ in range(30):
            if rng.random() < 0.15:
                acts.append(('view', rng.choice(list(VIEWS))))
            acts += [('ptr', rng.randrange(-60, 700), rng.randrange(-60, 420)), ('tick',)]
            if rng.random() < 0.4:
                acts.append(('render', rng.randrange(1 << 20), rng.randrange(1 << 20)))
            if rng.random() < 0.1:
                acts.append(('invalidate',))
        S('random:%d' % n, [R(b'RND%d' % n, r, rng.randrange(2))], acts + [('cleanup',)], 'random', quick=n < 2)
    return scs


def row_gate_open(spec, events):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return events.get(rec[1], 0) == rec[2]


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
    x.fatal_done = False
    x.known = sc.get('known')
    x.handles = list(sc['handles'])
    x.handle_i = 0
    first = sc['first']
    rows = list(sc['rows'])
    x.install_rows(rows, first)
    mode = sc['world'].get('mode', 3)
    x.wr(G_MODE, struct.pack('<i', mode))
    events = {}
    for idx, v in sc['events'].items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
        events[idx] = v
    view = VIEWS['v0']
    saved_back = (0, 0)

    def set_view(v):
        for addr, val in zip((G_ORIGIN_X, G_ORIGIN_Y, G_BOTTOM, G_MAX_X, G_MAX_Y), v):
            x.wr(addr, struct.pack('<i', val))
        nat.set_view(v)

    nat = Native(lib)
    try:
        nat.set_handles(x.handles)
        set_view(view)
        for s in sc['busy']:
            x.w32(ENTRY + s * STRIDE + 0x18, 1)
            lib.d9o_set_busy(nat.h, s, 1)
        compare_state('initial', x, nat, stats)
        inits = 0
        for ai, act in enumerate(sc['actions']):
            where = '%s action %d %s' % (sc['id'], ai, act[0])
            kind = act[0]
            if kind == 'view':
                view = VIEWS[act[1]]
                set_view(view)
            elif kind == 'view_raw':
                view = act[1]
                set_view(view)
            elif kind == 'setphase':
                x.w32(ROWS + act[1] * ROW + PHASE_OFF, act[2])
            elif kind == 'mode':
                x.wr(G_MODE, struct.pack('<i', act[1]))
            elif kind == 'events':
                for idx, v in act[1].items():
                    x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                    events[idx] = v
            elif kind == 'rows':
                rows, first = list(act[1]), act[2]
                x.install_rows(rows, first)
            elif kind == 'ptr':
                px, py = act[1], act[2]
                x.call(0x47d734, [(px & 0xffff) | 0x5a5a0000, (py & 0xffff) | 0xa5a50000], OBJ)
                nat.lib.d9o_pointer(nat.h, px, py)
                stats['pointer_moves'] += 1
                compare_state(where, x, nat, stats)
            elif kind == 'invalidate':
                x.call(0x47d640, [], OBJ)
                status, _ = nat.simple(lambda: nat.lib.d9o_invalidate(nat.h))
                if status != 0:
                    raise Mismatch('%s native invalidate status %d' % (where, status))
                stats['invalidates'] += 1
                compare_state(where, x, nat, stats)
            elif kind == 'cleanup':
                x.run_mode('cleanup', 0x47d59b, [], OBJ)
                ofx = list(x.fx)
                status, nfx = nat.simple(lambda: nat.lib.d9o_cleanup(nat.h))
                if status != 0:
                    raise Mismatch('%s native cleanup status %d' % (where, status))
                compare_fx(where, ofx, nfx, x.known, stats)
                stats['cleanups'] += 1
                stats['effects'] += len(nfx)
                compare_state(where, x, nat, stats)
            elif kind == 'render':
                run_render(where, x, nat, sc, act[1], act[2], view, rows, first, stats)
            elif kind == 'tick':
                inits += tick(where, x, nat, sc, rows, first, events, mode_now(x), stats)
            else:
                raise OracleError('unknown action ' + kind)
            if x.fatal_done:
                break
        compare_state(sc['id'] + ' end', x, nat, stats, buffers=True)
        stats['scenarios'] += 1
        stats['loaded_names'] += len(x.loaded)
        if lib.d9o_bad_slot_calls(nat.h):
            raise Mismatch('native used an out-of-range slot')
    finally:
        nat.close()


def mode_now(x):
    return struct.unpack('<i', x.rd(G_MODE, 4))[0]


X86.fatal_done = False
X86.known = None


def tick(where, x, nat, sc, rows, first, events, mode, stats):
    x.fatal_done = False
    fatal = None
    x.loaded = []
    handle_before = x.handle_i
    try:
        x.dispatch()
    except Fatal as error:
        fatal = error.address
        x.mode = 'idle'
    stats['ticks'] += 1
    entered = list(x.entered)
    expected = []
    if mode == 3:
        expected = [first + k for k, spec in enumerate(rows) if row_gate_open(spec, events)]
    got = [r for r, _ in entered]
    if fatal is None and got != expected:
        raise Mismatch('%s handler entries %s but the gate model says %s' % (where, got, expected))
    if fatal is not None and got != expected[:len(got)]:
        raise Mismatch('%s handler entries before the fatal path %s vs %s' % (where, got, expected))
    stats['gate_open_rows' if got else 'gate_closed_ticks'] += len(got) or 1
    nfx, names, inits = [], [], 0
    last_status = 0
    for n, (row, phase) in enumerate(entered):
        spec = rows[row - first]
        nat.lib.d9o_clear_log(nat.h)
        status, why, fx, nm, res = nat.step(spec['body'], row, phase)
        last_status = status
        nfx.append((FX['ENTER'], row, phase))
        nfx.extend(fx)
        names.extend(nm)
        stats['steps'] += 1
        if fatal is not None and n == len(entered) - 1:
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
        inits += res[1]
        stats['phase0_steps' if phase == 0 else 'phase1_steps'] += 1
    compare_fx(where, x.fx, nfx, x.known, stats)
    stats['effects'] += len(nfx)
    for k in range(len(x.loaded)):
        pass
    if x.loaded != names:
        raise Mismatch('%s loaded image names differ: original %r native %r' % (where, x.loaded, names))
    stats['image_loads'] += len(names)
    for t in x.fx:
        stats['effect_kinds'][FXN[t[0]]] += 1
    if fatal is not None:
        stats['fatal_paths_matched'] += 1
        x.fatal_done = True
        if fatal != sc.get('expect_fatal'):
            raise Mismatch('%s unexpected fatal path %#x' % (where, fatal))
        compare_state(where, x, nat, stats)
        return inits
    compare_state(where, x, nat, stats, buffers=bool(inits))
    return inits


def run_render(where, x, nat, sc, saved, back, view, rows, first, stats):
    row = x.s16(OBJ + 0x1d)
    active = x.rd(OBJ + 0x1c, 1)[0]
    slot = x.s16(OBJ + 0x23)
    if active and slot == -1:
        stats['render_skipped_unreachable'] += 1  # entry released: the engine never calls the callback
        return
    body = rows[row - first]['body'] if active and first <= row < first + len(rows) else rows[0]['body']
    x.w32(G_SAVED, saved)
    nat.lib.d9o_set_entry_u32(nat.h, 1, 8, saved)  # [0x5d15e3] is entry 1's surface field
    x.w32(G_BACK, back)
    x.blits = []
    x.call(0x47df57, [], 0)
    status, plan = nat.plan(body)
    if status != 0:
        raise Mismatch('%s native plan status %d' % (where, status))
    stats['render_calls'] += 1
    bl = x.blits
    if not plan['valid']:
        if bl:
            raise Mismatch('%s original blitted although the object is inactive' % where)
        return
    if [b['kind'] for b in bl] != ['restore', 'alpha' if plan['kind'] == 1 else 'mask']:
        raise Mismatch('%s blit sequence %s vs plan kind %d' % (where, [b['kind'] for b in bl], plan['kind']))
    rs, bt = bl
    stats['blit_calls'] += 2
    checks = [('restore_src', rs['src'], plan['restore_src']), ('restore_dst', rs['dst'], plan['restore_dst']),
              ('src', bt['src'], plan['src']), ('dst', bt['dst'], plan['dst']), ('map', bt['map'], plan['map'])]
    for name, a, b in checks:
        if a != b:
            raise Mismatch('%s render %s: original %s native %s' % (where, name, a, b))
    if rs['src_surface'] != saved or rs['dst_surface'] != back:
        raise Mismatch('%s restore surfaces' % where)
    if bt['surface'] != plan['surface'] or bt['surface'] != x.entry_surface(slot):
        raise Mismatch('%s puzzle surface original %#x plan %#x' % (where, bt['surface'], plan['surface']))
    if bt['dst_surface'] != back:
        raise Mismatch('%s destination surface' % where)
    if bt['kind'] == 'alpha':
        if bt['src2'] != bt['src'] or bt['saved'] != saved:
            raise Mismatch('%s alpha blit second source rectangle or saved frame' % where)
        if bt['map_ptr'] != struct.unpack('<I', x.rd(OBJ + 0x4d, 4))[0]:
            raise Mismatch('%s alpha pointer is not the whole map (offset)' % where)
    elif bt['map_ptr'] != struct.unpack('<I', x.rd(OBJ + 0x51, 4))[0]:
        raise Mismatch('%s mask pointer is not the whole map (offset)' % where)
    if bt['src_ptr'] != OBJ + 0x29 or rs['src_ptr'] != OBJ + 0x39:
        raise Mismatch('%s source rectangles are not the object windows' % where)
    cells = (plan['src'][2] - plan['src'][0] + 1) * (plan['src'][3] - plan['src'][1] + 1)
    stats['render_cells'] += max(cells, 0)



# ---------------------------------------------------------------------------------------------
# stretch: the real blit bodies 0x4c5377 / 0x4c6929 / 0x4c62f0 on flat 16-bit surfaces
# ---------------------------------------------------------------------------------------------
SURF_BASE = 0x50000000
SURF_SIZE = 0x800000
FORMATS = {
    'rgb555': ((10, 5, 0), (0x1f, 0x1f, 0x1f)),
    'rgb565': ((11, 5, 0), (0x1f, 0x3f, 0x1f)),
    'bgr555': ((0, 5, 10), (0x1f, 0x1f, 0x1f)),
    'bgr565': ((0, 5, 11), (0x1f, 0x3f, 0x1f)),
    'odd': ((11, 6, 1), (0x1f, 0x1f, 0x0f)),
}
SPECIAL_ALPHA = [0.0, 1.0, -0.5, 2.0, 1e-30, float('inf'), float('nan'), 1e9, 3e38, -1.0, 0.999999, 65537.5]


class Flat:
    def __init__(self, x, obj, buf, w, h, pad, rng, fill=None):
        self.obj, self.buf, self.w, self.h = obj, buf, w, h
        self.pitch = w * 2 + pad
        self.size = self.pitch * h
        data = bytes(rng.randrange(256) for _ in range(self.size)) if fill is None else fill
        x.wr(buf, data)
        x.wr(obj, struct.pack('<I', buf) + bytes(0x2b) + struct.pack('<h', self.pitch))
        self.initial = bytes(data)

    def read(self, x):
        return x.rd(self.buf, self.size)


def rand_rect(rng, w, h, rw, rh):
    left, top = rng.randrange(0, w - rw + 1), rng.randrange(0, h - rh + 1)
    return [left, top, left + rw - 1, top + rh - 1]


def stretch_run(x, lib, stats, rng, count):
    x.hard_reset()
    x.stretch = True
    uc = x.machine
    uc.mem_map(SURF_BASE, SURF_SIZE) if not getattr(x, '_surf_mapped', False) else None
    x._surf_mapped = True
    st = stats['stretch'] = Counter()
    bad = []
    f32 = lambda arr: np.asarray(arr, dtype=np.float32)
    for case in range(count):
        kind = ('copy', 'mask', 'alpha')[case % 3]
        fmt = list(FORMATS)[(case // 3) % len(FORMATS)]
        shifts, masks = FORMATS[fmt]
        for k in range(3):
            x.wr(0x5d2f1b - k, bytes([shifts[k]]))
            x.wr(0x5d2f1f - k, bytes([masks[k]]))
        x.wr(0x639895, struct.pack('<h', 2))
        x.wr(G_BACK, struct.pack('<I', 0))
        w, h = rng.randrange(4, 41), rng.randrange(4, 31)
        pad = rng.choice([0, 2, 6, 14])
        P = Flat(x, SURF_BASE + 0x000, SURF_BASE + 0x10000, w, h, pad, rng)
        S = Flat(x, SURF_BASE + 0x100, SURF_BASE + 0x30000, w, h, pad, rng)
        B = Flat(x, SURF_BASE + 0x200, SURF_BASE + 0x50000, w, h, pad, rng)
        rw, rh = rng.randrange(1, w + 1), rng.randrange(1, h + 1)
        r_src, r_bg, r_dst = rand_rect(rng, w, h, rw, rh), rand_rect(rng, w, h, rw, rh), rand_rect(rng, w, h, rw, rh)
        mw, mh = rng.randrange(rw, rw + 9), rng.randrange(rh, rh + 9)
        ml, mt = rng.randrange(0, mw - rw + 1), rng.randrange(0, mh - rh + 1)
        r_map = [ml, mt, mw - 1, mh - 1]
        R_SRC, R_BG, R_DST, R_MAP = SURF_BASE + 0x400, SURF_BASE + 0x420, SURF_BASE + 0x440, SURF_BASE + 0x460
        for addr, r in ((R_SRC, r_src), (R_BG, r_bg), (R_DST, r_dst), (R_MAP, r_map)):
            x.wr(addr, struct.pack('<4i', *r))
        MAPP = SURF_BASE + 0x70000
        mask = bytes(rng.choice([0, 0, 1, 1, 2, 0x80, 0xff]) for _ in range(mw * mh))
        alpha = f32([rng.choice(SPECIAL_ALPHA) if rng.random() < 0.3 else rng.random() for _ in range(mw * mh)])
        buf = lambda b, n=None: (C.c_uint8 * len(b)).from_buffer_copy(bytes(b))
        i4 = lambda r: (C.c_int32 * 4)(*r)
        before = (P.initial, S.initial, B.initial)
        if kind == 'copy':
            r_src2 = r_src
            x.wr(R_SRC, struct.pack('<4i', *r_src2))
            x.call(0x4c5377, [S.obj, B.obj, R_SRC, R_DST, SURF_BASE + 0x500], SURF_HOST)
            sp, dp = bytearray(S.initial), bytearray(B.initial)
            sbuf, dbuf = (C.c_uint8 * S.size).from_buffer_copy(S.initial), (C.c_uint8 * B.size).from_buffer_copy(B.initial)
            lib.d9o_blit_copy.argtypes = [C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_void_p]
            status = lib.d9o_blit_copy(C.addressof(sbuf), S.size, S.pitch, C.addressof(dbuf), B.size, B.pitch, i4(r_src2), i4(r_dst))
        elif kind == 'mask':
            x.wr(MAPP, mask)
            x.call(0x4c6929, [P.obj, B.obj, MAPP, R_SRC, R_DST, R_MAP, SURF_BASE + 0x500], SURF_HOST)
            sbuf, dbuf = (C.c_uint8 * P.size).from_buffer_copy(P.initial), (C.c_uint8 * B.size).from_buffer_copy(B.initial)
            mbuf = buf(mask)
            lib.d9o_blit_mask.argtypes = [C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_size_t, C.c_void_p, C.c_void_p, C.c_void_p]
            status = lib.d9o_blit_mask(C.addressof(sbuf), P.size, P.pitch, C.addressof(dbuf), B.size, B.pitch, C.addressof(mbuf), len(mask),
                                       i4(r_src), i4(r_dst), i4(r_map))
        else:
            x.wr(MAPP, alpha.tobytes())
            x.call(0x4c62f0, [P.obj, S.obj, B.obj, MAPP, R_SRC, R_BG, R_DST, R_MAP, SURF_BASE + 0x500], SURF_HOST)
            pb, sb, dbuf = (C.c_uint8 * P.size).from_buffer_copy(P.initial), (C.c_uint8 * S.size).from_buffer_copy(S.initial), (C.c_uint8 * B.size).from_buffer_copy(B.initial)
            abuf = (C.c_float * len(alpha)).from_buffer_copy(alpha.tobytes())
            lib.d9o_blit_alpha.argtypes = [C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_size_t, C.c_int, C.c_void_p, C.c_size_t, C.c_int,
                                           C.c_void_p, C.c_size_t, C.c_void_p, C.c_void_p, C.c_void_p, C.c_void_p, C.c_void_p, C.c_void_p]
            status = lib.d9o_blit_alpha(C.addressof(pb), P.size, P.pitch, C.addressof(sb), S.size, S.pitch, C.addressof(dbuf), B.size, B.pitch,
                                        C.addressof(abuf), len(alpha), i4(r_src), i4(r_bg), i4(r_dst), i4(r_map),
                                        (C.c_uint8 * 3)(*shifts), (C.c_uint8 * 3)(*masks))
        orig = B.read(x)
        nat = bytes(dbuf)
        st['cases'] += 1
        st[kind + '_cases'] += 1
        st['pixels'] += rw * rh
        st['surface_bytes'] += len(orig)
        st['dst_changed'] += int(orig != B.initial)
        if status != 0:
            bad.append('stretch case %d %s %s native status %d' % (case, kind, fmt, status))
        elif orig != nat:
            k = next(i for i in range(len(orig)) if orig[i] != nat[i])
            bad.append('stretch case %d %s %s differs at byte %d (row %d) original %02x native %02x (rect %s)' % (
                case, kind, fmt, k, k // B.pitch, orig[k], nat[k], r_dst))
        elif (P.read(x), S.read(x)) != before[:2]:
            bad.append('stretch case %d %s: original modified a source surface' % (case, kind))
        if bad:
            break
    x.stretch = False
    return bad

# ---------------------------------------------------------------------------------------------
# mutation check
# ---------------------------------------------------------------------------------------------
MUTANTS = {
 'clamp_left_off_by_one': ('object->rect[0] = px - r < 0 ? 0 : px - r;', 'object->rect[0] = px - r + 1 < 0 ? 0 : px - r + 1;'),
 'clamp_right_ge': ('if (px + r - 1 > view.max_x) object->rect[2] = view.max_x;', 'if (px + r - 1 >= view.max_x) object->rect[2] = view.max_x;'),
 'clamp_bottom_uses_max_x': ('if (py + r - 1 > view.max_y) object->rect[3] = view.max_y;', 'if (py + r - 1 > view.max_y) object->rect[3] = view.max_x;'),
 'bottom_limit_plus4': ('(int64_t)py > (int64_t)view.bottom - view.origin_y + 5', '(int64_t)py > (int64_t)view.bottom - view.origin_y + 4'),
 'bottom_limit_ge': ('(int64_t)py > (int64_t)view.bottom - view.origin_y + 5', '(int64_t)py >= (int64_t)view.bottom - view.origin_y + 5'),
 'mask_radius_le': ('sqrt((double)(y * y + x * x)) < (double)r ? 1u : 0u', 'sqrt((double)(y * y + x * x)) <= (double)r ? 1u : 0u'),
 'alpha_radius_le': ('if (!(sqrt((double)d2) < (double)radius)) return 0.0f;', 'if (!(sqrt((double)d2) <= (double)radius)) return 0.0f;'),
 'alpha_mask_swapped': ('const int alpha_mode = body[BODY_MODE] != 0u;', 'const int alpha_mode = body[BODY_MODE] == 0u;'),
 'plan_kind_swapped': ('plan->kind = body[BODY_MODE] == 0u ? D9_BLIT_MASK : D9_BLIT_ALPHA;', 'plan->kind = body[BODY_MODE] == 0u ? D9_BLIT_ALPHA : D9_BLIT_MASK;'),
 'restore_offset_missing': ('plan->restore_dst[i] = object->prev[i] + ox;', 'plan->restore_dst[i] = object->prev[i];'),
 'dst_offset_missing': ('plan->dst[i] = object->rect[i] + ox;', 'plan->dst[i] = object->rect[i];'),
 'slot_surface_store_dropped': ('if (host->set_slot_surface(host->context, slot, object->surface) != 0)', 'if (0 && host->set_slot_surface(host->context, slot, object->surface) != 0)'),
 'cleanup_clears_active': ('object->active = active;', 'object->active = 0u; (void)active;'),
 'cleanup_keeps_radius': ('object->radius = radius;', 'object->radius = 0; (void)radius;'),
 'exp_denominator_plus1': ('return (float)exp(-(double)numerator / (double)denominator);', 'return (float)exp(-(double)numerator / ((double)denominator + 1.0));'),
 'half_rounds_down': ('const int32_t half = (int32_t)((r4 - (r4 >> 31)) >> 1);', 'const int32_t half = r4 >> 1;'),
 'alpha_sign_dropped': ('return (float)exp(-(double)numerator / (double)denominator);', 'return (float)exp((double)numerator / (double)denominator);'),
 'alloc_mask_size': ('fx(host, D9_FX_ALLOC, (int32_t)(4u * radius * radius), 2);', 'fx(host, D9_FX_ALLOC, (int32_t)(3u * radius * radius), 2);'),
 'prev_copy_dropped': ('memcpy(object->prev, object->rect, sizeof(object->prev));', ''),
 'pointer_ignores_tracking': ('if (object != NULL && object->tracking != 0u) {\n        object->pointer_x = x;', 'if (object != NULL) {\n        object->pointer_x = x;'),
 'start_flag_not_set': ('world->start_flag_5bb1ca = 1;', 'world->start_flag_5bb1ca = 0;'),
 'map_left_without_edge_test': ('if (width < diameter && object->rect[0] == 0) plan->map[0] = diameter - width;', 'if (width < diameter) plan->map[0] = diameter - width;'),
 'map_top_off_by_one': ('if (height < diameter && object->rect[1] == 0) plan->map[1] = diameter - height;', 'if (height < diameter && object->rect[1] == 0) plan->map[1] = diameter - height + 1;'),
 'beyond_bottom_keeps_window': ('memset(object->rect, 0, sizeof(object->rect));\n            return D9_OK;', 'return D9_OK;'),
 'phase0_keeps_window': ('memset(object->rect, 0, sizeof(object->rect));\n        free(object->composite);', 'free(object->composite);'),
 'mask_blit_requires_one': ('if (m[x] != 0u) store16(', 'if (m[x] == 1u) store16('),
 'alpha_rounds_instead_of_chops': ('return (uint32_t)(int64_t)value;', 'return (uint32_t)(int64_t)(value + 0.5);'),
 'alpha_channel_mask_rotated': ('const int32_t bc = (int32_t)((bp >> sh) & format->mask[c]);', 'const int32_t bc = (int32_t)((bp >> sh) & format->mask[(c + 1) % 3]);'),
 'copy_drops_last_row': ('for (int32_t y = 0; y <= src_rect[3] - src_rect[1]; ++y)', 'for (int32_t y = 0; y < src_rect[3] - src_rect[1]; ++y)'),
 'map_stride_off_by_one': ('*stride = (size_t)map[2] + 1u;', '*stride = (size_t)map[2];'),
 'map_left_ignored': ('*base = (size_t)map[1] * *stride + (size_t)map[0];', '*base = (size_t)map[1] * *stride;'),
 'row_not_stored': ('object->row = row;', '(void)row;'),
 'pointer_init_zero': ('object->pointer_x = D9_POINTER_INIT;', 'object->pointer_x = 0;'),
}


def mutation_check(args, workdir):
    source = (args.src / 'action_family_d9_runtime.c').read_text()
    report = []
    for name, (old, new) in MUTANTS.items():
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted'))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / 'action_family_d9_runtime.c').write_text(source.replace(old, new))
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))
        except OracleError as error:
            report.append(dict(mutant=name, detected=None, how='mutant does not build: ' + str(error)[:120]))
            continue
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run']
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=first[6:][:200] if first else None))
    return report


# ---------------------------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, steps=0, effects=0, state_compares=0, object_fields=0, entry_bytes=0,
                mask_cells=0, alpha_cells=0, float_mismatch_cells=0, float_max_ulp=0, pointer_moves=0, invalidates=0,
                cleanups=0, render_calls=0, blit_calls=0, render_cells=0, render_skipped_unreachable=0,
                phase0_steps=0, phase1_steps=0, image_loads=0, loaded_names=0, gate_open_rows=0, gate_closed_ticks=0,
                fatal_paths_matched=0, mismatches=0, effect_kinds=Counter(), known_observed=Counter(), known_not_observed=Counter(), stretch={}, groups={})


def run_list(x, lib, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, lib, sc, stats)
            if sc.get('expect_mismatch'):
                stats['known_not_observed'][sc['expect_mismatch']] += 1  # native fixed, or the scenario is ineffective
        except (Mismatch, OracleError) as error:
            if sc.get('expect_mismatch'):
                stats['known_observed'][sc['expect_mismatch'] + ':' + sc['id']] += 1
                stats.setdefault('known_messages', {})[sc['expect_mismatch']] = str(error)[:200]
                continue
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
    ap.add_argument('--all-radii', action='store_true', help='radius scenarios for every r in 1..255, both modes')
    ap.add_argument('--stretch', type=int, default=900, help='cases of the real-blit pixel comparison (0 = off)')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-24.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib = open_lib(lib_path)
    x = X86()
    scs = scenario_list(all_radii=args.all_radii)
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
        if not bad and args.stretch:
            bad = [('stretch', m) for m in stretch_run(x, lib, stats, random.Random(2424), 90)]
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
    if args.stretch and not args.only and not args.discover_pins:
        for msg in stretch_run(x, lib, stats, random.Random(2424), args.stretch):
            bad.append(('stretch', msg))
            stats['mismatches'] += 1
        print('STRETCH', dict(stats.get('stretch', {})))
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    stats['stretch'] = dict(stats['stretch'])
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    print(json.dumps(summary, sort_keys=True))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        sources = {n: sha((args.src / n).read_bytes()) for n in ('action_family_d9_runtime.c', 'action_family_d9_runtime.h')}
        result = dict(slice='RT-24', status='pass' if not bad else 'fail', mismatches=len(bad), exe_sha256=EXE_HASH,
                      source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_d9_runtime_oracle_driver.c').read_bytes()),
                      code_windows=[dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE],
                      scenarios=len(scs), stats=summary, mutations=mutations, mismatch_list=bad[:50],
                      hooks_fired=dict(x.hooks_fired), counters=dict(x.counters), fpu_control_word=hex(FPCW),
                      elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
