#!/usr/bin/env python3
"""RT-25: immutable x86 dispatcher 0x427a50 / handler 0x420c17 (cel arms), reader thread 0x422e4a and
render callback 0x422a0a versus the native raw-0x3e cel-video arm of src/action_family_3f_runtime.c.

The unmodified GAME.EXE image is mapped under Unicorn (the machine, import stubs, SEH page, write
classification and the dispatcher plumbing are those of tests/action_family_3f_runtime_original_oracle.py,
imported and subclassed here). For raw 0x3e rows the REAL dispatcher 0x427a50 runs: gate 0x423f57
(dependency tree built by the real loader 0x424aa8) and the handler 0x420c17 with ECX = manager 0x6177e8.
As ORIGINAL x86 code run: 0x420c17 itself (phase 0 incl. the shared part, states 1/4/5/6, phase 2), the cache
routines 0x41de29 (reset), 0x41e043 (first free), 0x41e1e4 (find), 0x41dfd2 (eviction pass), 0x41e0b4 (load
slot), 0x41e250 (evict), 0x4c2e5b (free decoded layer), the frame bookkeeping 0x422970 / 0x4229b5, the sound
frame choice 0x4f6ef4 with its channel readiness probe 0x4f709c on a channel state block built in emulated
memory, the CRT _ftol 0x50ce04 (x87, control word 0x27f = 53-bit precision as a Win32 process starts), the lock
helpers 0x44c479 / 0x44c4ab, the reader thread body 0x422e4a (exactly ONE pass per call: it is called with a
pointer to a zero dword and stopped when its Sleep import is reached) and the render callback 0x422a0a.

COMPLETE HOOK INVENTORY (code hooks at function ENTRY; nothing else is replaced).
 R = replaced (records the call, applies the scripted effect, pops the original's `ret N`, returns),
 O = observed (recorded, the original body then runs), G = raising guard (reaching one fails the run unless
 the scenario expects that fatal path and the native kernel must refuse it too).
  Shared with the RT-23 oracle (documented in its docstring):
  R 0x4eb96e 0x4e7d04 0x4db993 0x4e9e84 0x4ea06c 0x4c948f 0x4c2898 0x4c946b 0x41e3c0 0x41e647 0x4c51a5
    0x420b9e 0x4dadff 0x4fb2e3 0x4fba69 0x4ee673 0x41db40   O 0x4edf96 0x4edfaf 0x42e493 0x4e7757
  R 0x4f6334 sound is_playing (scripted answer; also called by the ORIGINAL 0x4f6ef4 and by state 6)
  R 0x4fb77a sound load(descriptor): records the descriptor; stand-in: marks the channel state of the descriptor's
    channel as loaded (+0x162, +0x28f nonzero) when the scenario's sound resource exists
  R 0x51dc6c CRT free: counted; a free of the CIFTREE block is the effect `cel_release_header`
  base harness: 0x51dc43 malloc replaced by a bounded zero-filled arena (OS/CRT boundary)
  New for the cel arm:
  R 0x418e52 CIFTREE header load (thiscall 0x5d2f31, ret 0xc): scripted block in emulated memory, size stored
    through the third argument; NULL for the missing-header scenario
  R 0x41a216 CIFTREE directory index of a layer name (ret 4): scripted per name, -1 for the fatal case
  R 0x417b04 decode one layer image (ret 0xc): fills the 0x55-byte header object (data pointer +0x00, word +0x2f,
    rectangles +0x35 and +0x45) from decode_layer(tree, frame, layer); frame/layer come from the name pointer
  R 0x4497a0 thread create (ret 0x10; returns a thread object whose vtable word points to a stub),
    R 0x449bff resume (ret 0), R 0x449a94 terminate (ret 0), R VDELETE the virtual delete call (ret 4)
  R 0x4f6cdc sound sync init (ret 0xc): records channel/frames/param; stand-in: stores the channel state fields
    +0x176 (bytes per frame), +0x17a (frames), +0x17e, +0x182 (0), +0x186 (param) and returns 1, or 0 when the
    scenario has no resource or fails the init
  R 0x4f81fa raw sound position (ret 4): scripted sequence, -1 unreadable
  R 0x4c5377 0x4c609b 0x4c5770 blit recorders of the render test (ECX must be 0x5cf659; ret 0x14, 0x18, 0x18)
  O 0x4c2e5b free decoded layer: records `cel_free slot layer surface` (decoded from the header object address)
  R 0x50ca3e sprintf of the thread name buffer 0x63888b at 0x4216e5 (cdecl, no read-back), any other caller raises
  (any other caller of 0x50ca3e is a fatal-path log line: the visit must then end in the guarded abort)
  G 0x52139c 0x4c97b4 0x44a2b7 0x42639d 0x51ec84 and the guards of the RT-23 oracle that the cel arm does
    not need to run (the fatal/logging paths; 0x51ec84 is the thread exit when the stop flag is set)
 Windows imports (OS boundary, IAT slots patched to stubs): InterlockedIncrement/Decrement, lstrlenA,
 Enter/Leave/InitializeCriticalSection (one thread), Sleep (only as the stop of a reader pass, return address
 0x422f8d); any other import fails the run. Observers (never write): UC_HOOK_MEM_WRITE over the image classifies every
 store into a named region; unclassified stores fail the run. Debug flag 0x63a4cd is 0.

Scripted values shared by BOTH sides (the stand-ins' contract, not original decisions): the CIFTREE block, the
directory indexes and kind/transparency bytes, decode_layer, the sound position/is-playing scripts, the channel
bytes per frame, key bytes, surface slots, layout sound names, scene stack words. Inputs the original never writes
and the game leaves at 0 ([0x5b028e] stall limit, +0x786 table index, view origin [0x583186]/[0x58318a]) are also
varied as SYNTHETIC inputs (tagged in the scenario id) to exercise the kernel's boost/decay and table rules.

Compared: after EVERY recorded effect the modelled light state (manager, world, cel fields, slot frames, header
data pointers); at the end of every visit/pass/render the full state (plus lock word, header object data, response
texts, sound-name table, events, presence, the object image), the row phase/completion words and result flags.
Fatal paths (missing header, missing layer, no sound resource at sync init, failing sync init) require the
original to reach the guarded abort 0x52139c AND the native kernel to refuse; the native effect list must be a
prefix of the original's (native validates earlier). Deliberate native differences (tagged, not mismatches):
bounds checks returning ERR_BOUNDS where the original reads out of range (layer count above 2, negative frames),
host failures instead of aborts.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_3e_runtime_original_oracle.py --mutations --result <receipt.json>
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

sys.path.insert(0, str(Path(__file__).resolve().parent))

from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
import test_action_family_3f as n3f
import action_family_3f_runtime_original_oracle as o3f
from action_family_3f_runtime_original_oracle import (OracleError, Mismatch, sha, u32, cstr, diff_fields,
                                                      MGR, SLOT, ROW, PHASE, COMPLETE, OBJ_BASE, EXE_HASH)

ROOT = o3f.ROOT
PROJECT = o3f.PROJECT
PRIVATE = o3f.PRIVATE
DEFAULT_EXE = o3f.DEFAULT_EXE
FPCW = 0x27f

# memory map of the cel stand-ins (outside the image and the object arena, unobserved)
CEL_BASE = 0x23000000
CEL_SIZE = 0x800000
VTABLE = CEL_BASE + 0x100
STOPVAR = CEL_BASE + 0x200
CHAN_BASE = CEL_BASE + 0x10000
HDR_BASE = CEL_BASE + 0x20000
BLOCK_VA = CEL_BASE + 0x100000
VDELETE = CEL_BASE + 0x300  # a `ret` byte in the stand-in region (not among the import stubs)
SND_MGR = 0x5cf1eb
HDR_OBJ = 0x55
CHAN_STRIDE = 0x5bb
SLOTS = 0x4b
FRAME_STRIDE = 0x8c

# SHA-256 of the unmodified code windows the cel arm adds to the RT-23 pins (PINS_TABLE of that oracle is
# checked at startup too; it contains the handler window 0x420c17..0x422970 with the cel arms).
PINS_3E = (
 (0x41dfd2, 0x41e043, 'e6119539c101d67c53dc9ef7cf8051e7fbcd58438db29a55db4115fa1f7ab0d2'),
 (0x41e043, 0x41e0b4, 'c97e79b69d60e63e262f9dc96e8b52d0e4ee70db736f61e9b4fd0c90ceae472e'),
 (0x41e0b4, 0x41e1e4, '8b8cd13d302c2c426cac07f36c2fd364da72428c4b2acb83b6e9963ba39a1b55'),
 (0x41e1e4, 0x41e250, '9bbe379f0523d99fe874ac3a10302d21fda25564610e3b28743877298d1655db'),
 (0x41e250, 0x41e33b, '28fe16f9d2ba495cd2a03299064b8f4e39557efc4a6dde6f7cef06f939f880b2'),
 (0x422970, 0x4229b5, '75d3362ef8d75eab01e531fcaff9a4c833d880487c621aed8a9bed70c5e4635a'),
 (0x4229b5, 0x4229f8, 'b82b736683fc499dd6223cc4163ae24368b544867bb68cdc414936c5cf559bd4'),
 (0x422a0a, 0x422e3a, '55a946d3d5d46d7c6b95716f51888b3eb92663d424f6f5b63243b1a9c7550bd6'),
 (0x422e4a, 0x422fa1, 'a1fc9156c1c91e54e28ceb99c14d8e8f77f7c4a338459a4e70f5fcd4db1aa0fa'),
 (0x4f6cdc, 0x4f6ef4, '206cc5c712e3dadcf61cfc307b2ae56da41c55993a12e6615b3780f8d4ee1c21'),
 (0x4f6ef4, 0x4f709c, 'c68cffc7ff7cab44a5e0d8cd127ab4c68bdb9252eabd15c6983dcc5062bd4e74'),
 (0x4f709c, 0x4f70b0, 'f4378d19b5c3ab0dbd39cba983f59f6dc52989a4d7f3e5211057cd34d287503e'),
 (0x44c479, 0x44c4ab, '54c215e74ea4051a44fbcde7dd6a5d1412ae20c4c8a2d0a2d814175ddbd3d377'),
 (0x44c4ab, 0x44c4c1, '20a525f4e4af04f5ad5548f1023fd4864472cabd7bcccc9fecae0b90781c0b93'),
 (0x50ce04, 0x50ce2b, 'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
)

NEW_POPS = {0x418e52: 12, 0x41a216: 4, 0x417b04: 12, 0x4497a0: 0x10, 0x449bff: 0, 0x449a94: 0,
            0x4f6cdc: 0xc, 0x4f81fa: 4, 0x4c5377: 0x14, 0x4c609b: 0x18, 0x4c5770: 0x18}
POPS = dict(o3f.POPS)
POPS.update(NEW_POPS)
# guards the cel arm legitimately passes through are NOT guards here (they run as original code or are replaced)
RUN_ORIGINAL = {0x44c479, 0x44c4ab, 0x449a94, 0x449bff, 0x4497a0, 0x418e52, 0x41a216, 0x41e1e4, 0x422970,
                0x4229b5, 0x4f6cdc, 0x4f6ef4, 0x50ce04}
GUARDS = [a for a in o3f.GUARDS if a not in RUN_ORIGINAL and a != 0x50ca3e] + [0x51ec84]

CF = {'c.loaded': (0x68e, 2), 'c.slot': (0x690, 2), 'c.next': (0x692, 2), 'c.forced': (0x694, 2),
      'c.cap': (0x696, 2), 'c.lock': (0x698, 4), 'c.frame': (0x69c, 2), 'c.syncp': (0x69e, 4),
      'c.first': (0x6a2, 2), 'c.last': (0x6a4, 2), 'c.drawn': (0x77e, 2), 'c.target': (0x782, 2),
      'c.final': (0x784, 2), 'c.i786': (0x786, 2), 'c.stall': (0x788, 2), 'c.relax': (0x78a, 2),
      'c.boost': (0x78c, 2), 'c.layers': (0xf9b, 2), 'c.tree': (0xfb5, 4), 'c.header': (0xf77, 0x2a),
      'c.saved_src': (0x6da, 64), 'c.saved_dst': (0x71a, 64)}
WX = {'w.stall': (0x5b028e, 2), 'w.vx': (0x583186, 4), 'w.vy': (0x58318a, 4)}


# ---------------------------------------------------------------------------------------------
# scripted cel host: the decode function shared with the driver
# ---------------------------------------------------------------------------------------------
def decode_layer(tree, frame, layer):
    """Header object contents 0x417b04 produces in the stand-in (mirrors h_cel_load of the driver)."""
    surface = (0x10000 + tree * 0x400 + frame * 4 + layer + 1) & 0xffffffff
    key = (frame * 517 + layer * 91 + tree * 13 - 4000) & 0xffff
    src = [frame, layer * 2, frame + 16 + layer, 8 + layer + tree % 5]
    dst = [frame * 3 + layer - 20, 2 * layer + tree, frame * 3 + layer + 40, 2 * layer + tree + 30]
    return surface, key, src, dst


SL = 512


class Script(C.Structure):
    _fields_ = [('playing_c', C.c_int32 * SL), ('playing_d', C.c_int32 * SL), ('n_c', C.c_int32),
                ('n_d', C.c_int32), ('key_skip', C.c_uint8 * SL), ('key_other', C.c_uint8 * SL),
                ('n_keys', C.c_int32), ('names', (C.c_uint8 * 41) * 30), ('hotspot', C.c_int32),
                ('slots', C.c_int16 * 8), ('n_slots', C.c_int32), ('stack_marker', C.c_int16),
                ('stack_scene', C.c_int16), ('stack_w09', C.c_int16), ('stack_w0b', C.c_int16),
                ('stack_w0d', C.c_int16), ('stack_pad', C.c_int16), ('stack_d0f', C.c_int32),
                ('stack_d13', C.c_int32), ('stack_d17', C.c_int32), ('fail_pop', C.c_int32),
                ('raw', C.c_int32 * SL), ('n_raw', C.c_int32), ('load_status', C.c_int32),
                ('bytes_per_frame', C.c_int32), ('fail_sync_init', C.c_int32), ('fail_header', C.c_int32),
                ('kind', C.c_uint8 * 64), ('transp', C.c_uint8 * 64), ('tree_name', (C.c_uint8 * 33) * 2),
                ('tree_idx', C.c_int16 * 2), ('n_tree', C.c_int16)]


def make_script(d):
    s = Script()
    for key in ('playing_c', 'playing_d', 'key_skip', 'key_other', 'slots', 'raw'):
        for i, v in enumerate(d.get(key, [])):
            getattr(s, key)[i] = v
    s.n_c, s.n_d, s.n_keys, s.n_slots, s.n_raw = (len(d.get('playing_c', [])), len(d.get('playing_d', [])),
                                                  len(d.get('key_skip', [])), len(d.get('slots', [])),
                                                  len(d.get('raw', [])))
    for i, name in enumerate(d.get('names', [])):
        raw = (name + b'\0').ljust(41, b'\xbb')[:41]
        for k, b in enumerate(raw):
            s.names[i][k] = b
    s.hotspot = d.get('hotspot', 0)
    st = d.get('stack', (0x1234, 321, 2, 3, 0, 0x11111111, 0x22222222, 0x33333333))
    (s.stack_marker, s.stack_scene, s.stack_w09, s.stack_w0b, s.stack_w0d, s.stack_d0f, s.stack_d13,
     s.stack_d17) = st
    s.fail_pop = d.get('fail_pop', 0)
    s.load_status = 0 if d.get('load_ok', True) else 1
    s.bytes_per_frame = d.get('bpf', 1000)
    s.fail_sync_init = 1 if d.get('fail_sync') else 0
    s.fail_header = 1 if d.get('fail_header') else 0
    for idx, v in d.get('kind', {}).items():
        s.kind[idx] = v
    for idx, v in d.get('transp', {}).items():
        s.transp[idx] = v
    tree = d.get('tree', [])
    s.n_tree = len(tree)
    for i, (name, idx) in enumerate(tree):
        for k, b in enumerate((name + b'\0').ljust(33, b'\0')[:33]):
            s.tree_name[i][k] = b
        s.tree_idx[i] = idx
    return s


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_3e_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_3f_runtime.c'), str(Path(src_dir) / 'action_family_3f.c'),
           str(Path(src_dir) / 'action_family_3e.c'), '-o', str(out)]
    if os.environ.get('A3E_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    @classmethod
    def open(cls, path):
        lib = C.CDLL(str(path))
        p = C.c_void_p
        lib.a3e_new.restype = p
        lib.a3e_new.argtypes = [C.c_void_p, C.c_size_t, C.c_uint32, C.POINTER(Script)]
        lib.a3e_free.argtypes = [p]
        lib.a3e_set_block.argtypes = [p, C.c_void_p, C.c_size_t]
        lib.a3e_visit.argtypes = [p, C.c_int32, C.c_uint32]
        lib.a3e_visit.restype = C.c_int
        lib.a3e_pass.argtypes = [p, C.POINTER(C.c_int)]
        lib.a3e_pass.restype = C.c_int
        lib.a3e_render.argtypes = [p]
        lib.a3e_render.restype = C.c_int
        lib.a3e_why.argtypes = [p]
        lib.a3e_why.restype = C.c_char_p
        lib.a3e_log_count.argtypes = [p]
        lib.a3e_log_text.argtypes = [p, C.c_int]
        lib.a3e_log_text.restype = C.c_char_p
        lib.a3e_log_snapshot.argtypes = [p, C.c_int, C.c_void_p]
        lib.a3e_clear_log.argtypes = [p]
        lib.a3e_result.argtypes = [p, C.c_void_p]
        lib.a3e_arena.argtypes = [p, C.c_void_p]
        lib.a3e_store.argtypes = [p, C.c_void_p, C.c_int]
        lib.a3e_load.argtypes = [p, C.c_void_p]
        lib.a3e_snapshot_size.argtypes = [p, C.c_int]
        lib.a3e_snapshot_size.restype = C.c_size_t
        lib.a3e_set_chosen.argtypes = [p, C.c_int, C.c_int32]
        lib.a3e_set_event.argtypes = [p, C.c_int, C.c_int32]
        lib.a3e_set_presence.argtypes = [p, C.c_int, C.c_int32]
        lib.a3e_layout.argtypes = [C.c_char_p, C.c_size_t]
        lib.a3e_layout.restype = C.c_size_t
        lib.a3e_script_size.restype = C.c_size_t
        if lib.a3e_script_size() != C.sizeof(Script):
            raise OracleError('script struct layout mismatch')
        buf = C.create_string_buffer(1 << 16)
        n = lib.a3e_layout(buf, len(buf))
        spec = [(a, int(b), int(c)) for a, b, c in (ln.split() for ln in buf.raw[:n].decode().splitlines())]
        return lib, spec

    def __init__(self, lib, spec, image, handle_base, script, block):
        self.lib, self.spec = lib, spec
        self.arena_bytes = len(image)
        buf = (C.c_uint8 * len(image)).from_buffer_copy(image)
        self.script = make_script(script)
        self.h = lib.a3e_new(buf, len(image), handle_base, C.byref(self.script))
        if block:
            b = (C.c_uint8 * len(block)).from_buffer_copy(block)
            lib.a3e_set_block(self.h, b, len(block))
        self.light = lib.a3e_snapshot_size(self.h, 0)
        self.full = lib.a3e_snapshot_size(self.h, 1)

    def close(self):
        self.lib.a3e_free(self.h)

    def store(self, full=True):
        out = (C.c_uint8 * (self.full if full else self.light))()
        self.lib.a3e_store(self.h, out, 1 if full else 0)
        return bytes(out)

    def load(self, blob):
        buf = (C.c_uint8 * len(blob)).from_buffer_copy(blob)
        self.lib.a3e_load(self.h, buf)

    def events(self):
        out = []
        for i in range(self.lib.a3e_log_count(self.h)):
            snap = (C.c_uint8 * self.light)()
            self.lib.a3e_log_snapshot(self.h, i, snap)
            out.append((self.lib.a3e_log_text(self.h, i).decode('latin1'), bytes(snap)))
        return out

    def why(self):
        return (self.lib.a3e_why(self.h) or b'').decode()

    def visit(self, row, phase):
        self.lib.a3e_clear_log(self.h)
        status = self.lib.a3e_visit(self.h, row, phase)
        res = (C.c_uint32 * 8)()
        self.lib.a3e_result(self.h, res)
        return status, self.why(), self.events(), list(res)

    def pass_(self):
        self.lib.a3e_clear_log(self.h)
        ran = C.c_int(0)
        status = self.lib.a3e_pass(self.h, C.byref(ran))
        return status, self.why(), self.events(), ran.value

    def render(self):
        self.lib.a3e_clear_log(self.h)
        status = self.lib.a3e_render(self.h)
        return status, self.why(), self.events()

    def arena(self):
        out = (C.c_uint8 * self.arena_bytes)()
        self.lib.a3e_arena(self.h, out)
        return bytes(out)


class Constructor3e:
    """Native A-3E.1 constructor (original-verified by action_family_3e_original_oracle)."""
    def __init__(self, lib):
        self.lib = lib
        lib.action_family_3e_construct.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(n3f.Text), C.c_size_t,
                                                   C.c_uint32, C.c_uint32, C.c_void_p, C.c_size_t,
                                                   C.POINTER(n3f.Constructed)]
        lib.action_family_3e_construct.restype = C.c_int

    def build(self, body, texts, handle, fill=0xcd):
        src = n3f.storage(body)
        texts = [t.encode() if isinstance(t, str) else t for t in texts]
        rows, keep = n3f.texts(texts)
        out = n3f.Constructed()
        if self.lib.action_family_3e_construct(src, len(src), rows, len(rows), 50, handle, None, 0,
                                               C.byref(out)) != 0:
            raise OracleError('native 0x3e constructor refused the fixture')
        arena = n3f.storage(bytes([fill]) * out.arena_bytes)
        if self.lib.action_family_3e_construct(src, len(src), rows, len(rows), 50, handle, arena,
                                               out.arena_bytes, C.byref(out)) != 0:
            raise OracleError('native 0x3e constructor failed')
        return bytes(arena)


# ---------------------------------------------------------------------------------------------
# original side
# ---------------------------------------------------------------------------------------------
class X86Cel(o3f.X86):
    def __init__(self, spec):
        super().__init__(spec)
        uc = self.machine
        for a, z, digest in PINS_3E:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
        uc.mem_map(CEL_BASE, CEL_SIZE)
        uc.mem_write(VTABLE, struct.pack('<I', VDELETE))
        uc.mem_write(VDELETE, b'\xc3')
        self._caches = []
        self._in_pass = False
        self._sleep_hit = False
        self._fatal_log = 0
        self._block_len = 0
        self.thread_obj = 0
        for name, (off, size) in CF.items():
            self.named.append((MGR + off, MGR + off + size, name))
        self.named.append((MGR + 0x1c, MGR + 0x1c + SLOTS * 0x16, 'cel slot table'))
        for name, (addr, size) in WX.items():
            self.named.append((addr, addr + size, name))
        self.named.append((MGR + 0x6aa, MGR + 0x6ae, 'c.sndoff'))
        self.named.append((MGR + 0x6a6, MGR + 0x6aa, 'c.steptab'))
        self.named.append((MGR + 0xfa5, MGR + 0xfad, 'c.blk/c.blksz'))
        self.regions = sorted(self.regions + [(SND_MGR + 0x3b0, SND_MGR + 0x3d0, 'sound manager error words')])
        self.read_6ba = Counter()
        self.machine.hook_add(o3f.UC_HOOK_MEM_READ, self._on_6ba_read, begin=MGR + 0x6ba, end=MGR + 0x6d9)

    def _on_6ba_read(self, uc, access, address, size, value, user):
        if self.active:
            self.read_6ba[(address, uc.reg_read(X.UC_X86_REG_EIP))] += 1

    # -- hook plumbing -----------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        table = {}
        for a in POPS:
            table[a] = self._replaced
        for a in o3f.OBSERVED:
            table[a] = self._observed
        table[0x4c2e5b] = self._observed_free
        for a in GUARDS:
            table[a] = self._raise
        table[0x420c17] = self._entry
        table[VDELETE] = self._vdelete
        table[0x50ca3e] = self._sprintf
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _on_import(self, uc, address, size, user):
        name, _iat = self.imports[address]
        if name == 'Sleep':
            ret = u32(uc, uc.reg_read(X.UC_X86_REG_ESP))
            if self._in_pass and ret == 0x422f8d:
                self._sleep_hit = True
                uc.emu_stop()
                return
            raise OracleError('Sleep reached from %#x (a lock was held across a wait)' % ret)
        super()._on_import(uc, address, size, user)

    def _sprintf(self, uc, address, size, user):
        # CRT sprintf(0x63888b, fmt, [0x5bb57b]) at 0x4216e5: formats the thread name buffer (never read back by the
        # cel arm). Every other caller of 0x50ca3e sits behind the debug flag 0x63a4cd == 0.
        ret = u32(uc, uc.reg_read(X.UC_X86_REG_ESP))
        if ret != 0x4216ef:
            self._fatal_log = ret  # a fatal-path log line: the run must end in the guarded abort 0x52139c
        self.counters_total['R 0x50ca3e'] += 1
        self._ret(uc, 0, 0)

    def _vdelete(self, uc, address, size, user):
        self.counters_total['R vdelete'] += 1
        if uc.reg_read(X.UC_X86_REG_ECX) != self.thread_obj or self.thread_obj == 0:
            raise OracleError('virtual delete on an unknown object')
        self._ret(uc, 4, 0)

    def _observed_free(self, uc, address, size, user):
        self.counters_total['O 0x4c2e5b'] += 1
        hdr = u32(uc, uc.reg_read(X.UC_X86_REG_ESP) + 4)
        if uc.reg_read(X.UC_X86_REG_ECX) != 0x5cf659:
            raise OracleError('0x4c2e5b with ECX != 0x5cf659')
        if HDR_BASE <= hdr < HDR_BASE + SLOTS * 4 * HDR_OBJ and u32(uc, hdr) != 0:
            idx = (hdr - HDR_BASE) // HDR_OBJ
            self.log('cel_free %d %d %u' % (idx // 4, idx % 4, u32(uc, hdr)))

    def _replaced(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [u32(uc, sp + 4 + 4 * i) for i in range(6)]
        s16 = lambda v: struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]
        s32 = lambda v: struct.unpack('<i', struct.pack('<I', v))[0]
        sc = self.script
        ecx = uc.reg_read(X.UC_X86_REG_ECX)
        rect = lambda p: ','.join(str(v) for v in struct.unpack('<4i', self.rd(p, 16)))
        eax = 0
        if address in NEW_POPS or address in (0x4fb77a, 0x51dc6c):
            self.counters_total['R %#x' % address] += 1
        if address == 0x4fb77a:
            d = self.rd(a[0], 0x31)
            ch = struct.unpack_from('<H', d, 0x21)[0]
            if sc.get('load_ok', True) and ch < 32:
                base = CHAN_BASE + ch * CHAN_STRIDE
                self.wr(base + 0x162, struct.pack('<I', 1))
                self.wr(base + 0x28f, struct.pack('<I', 1))
            return super()._replaced(uc, address, size, user)
        if address == 0x51dc6c:
            if a[0] == BLOCK_VA:
                self.log('cel_release_header')
                self._ret(uc, 0, 0)
                return
            return super()._replaced(uc, address, size, user)
        if address in NEW_POPS:
            pass
        else:
            return super()._replaced(uc, address, size, user)
        if address == 0x418e52:
            if ecx != 0x5d2f31:
                raise OracleError('0x418e52 with ECX != 0x5d2f31')
            self.log('cel_header %s' % cstr(self.rd(a[1], 33)).decode('latin1'))
            block = sc.get('block')
            if not sc.get('fail_header') and block:
                self.wr(a[2], struct.pack('<I', len(block)))
                eax = BLOCK_VA
        elif address == 0x41a216:
            name = cstr(self.rd(a[0], 33))
            idx = -1
            for nm, i in sc.get('tree', []):
                if nm == name:
                    idx = i
                    break
            self.log('cel_tree %s -> %d' % (name.decode('latin1'), idx))
            eax = idx
        elif address == 0x417b04:
            tree, nameptr, hdr = s16(a[0]), a[1], a[2]
            self.log('cel_load tree=%d name=%s' % (tree, cstr(self.rd(nameptr, 33)).decode('latin1')))
            off = nameptr - BLOCK_VA - 0x2a
            frame, layer = off // FRAME_STRIDE, (off % FRAME_STRIDE) // 0x21
            surface, key, src, dst = decode_layer(tree, frame, layer)
            self.wr(hdr, struct.pack('<I', surface))
            self.wr(hdr + 0x2f, struct.pack('<H', key))
            self.wr(hdr + 0x35, struct.pack('<4i', *src))
            self.wr(hdr + 0x45, struct.pack('<4i', *dst))
        elif address == 0x4497a0:
            if a[0] != 0x422e4a or ecx == 0:
                raise OracleError('reader thread created with an unexpected body')
            self.wr(ecx, struct.pack('<I', VTABLE))
            self.thread_obj = ecx
            self.log('reader_create')
            eax = ecx
        elif address == 0x449bff:
            self.log('reader_resume')
        elif address == 0x449a94:
            self.log('reader_destroy')
        elif address == 0x4f6cdc:
            if ecx != SND_MGR:
                raise OracleError('0x4f6cdc with ECX != 0x5cf1eb')
            ch, frames, param = a[0] & 0xffff, a[1] & 0xffff, a[2]
            self.log('sync_init ch=%u frames=%u param=%u' % (ch, frames, param))
            base = CHAN_BASE + ch * CHAN_STRIDE
            ok = sc.get('load_ok', True) and not sc.get('fail_sync') and frames > 0
            if ok:
                self.wr(base + 0x176, struct.pack('<I', sc.get('bpf', 1000)))
                self.wr(base + 0x17a, struct.pack('<I', frames))
                self.wr(base + 0x17e, struct.pack('<I', 0))
                self.wr(base + 0x182, struct.pack('<I', 0))
                self.wr(base + 0x186, struct.pack('<I', param))
                eax = 1
        elif address == 0x4f81fa:
            i = self.counters['raw']
            self.counters['raw'] += 1
            seq = sc.get('raw', [])
            raw = seq[i] if i < len(seq) else -1
            self.log('snd_pos %u -> %d' % (a[0] & 0xffff, raw))
            eax = raw
        elif address == 0x4c5377:
            self._check_blit(ecx)
            self.events.append(('blit 1 s=0 k=0 src=%s dst=%s' % (rect(a[2]), rect(a[3])), None))
        elif address in (0x4c609b, 0x4c5770):
            self._check_blit(ecx)
            kind = 2 if address == 0x4c609b else 3
            self.events.append(('blit %d s=%u k=%d src=%s dst=%s' % (kind, a[0], s16(a[4]), rect(a[2]),
                                                                    rect(a[3])), None))
        self._ret(uc, POPS[address], eax)

    def _check_blit(self, ecx):
        if ecx != 0x5cf659:
            raise OracleError('blit with ECX != 0x5cf659')

    # -- state access ---------------------------------------------------------------------------
    def rd(self, a, n):
        for base, buf in self._caches:
            if base <= a and a + n <= base + len(buf):
                return buf[a - base:a - base + n]
        return super().rd(a, n)

    def snapshot(self, full):
        uc = self.machine
        self._caches = [(MGR, bytes(uc.mem_read(MGR, 0x2200))),
                        (HDR_BASE, bytes(uc.mem_read(HDR_BASE, SLOTS * 4 * HDR_OBJ))),
                        (CHAN_BASE + 0xc * CHAN_STRIDE, bytes(uc.mem_read(CHAN_BASE + 0xc * CHAN_STRIDE, 0x400)))]
        try:
            return super().snapshot(full)
        finally:
            self._caches = []

    def field(self, name, size, nil):
        if name == 'm.cel':
            return struct.pack('<I', 1 if struct.unpack('<I', self.rd(MGR + 0x6b2, 4))[0] else 0)
        if name in CF:
            off, sz = CF[name]
            assert sz == size, name
            return self.rd(MGR + off, sz)
        if name in WX:
            addr, sz = WX[name]
            return self.rd(addr, sz)
        if name == 'c.steptab':
            p = struct.unpack('<I', self.rd(MGR + 0x6a6, 4))[0]
            return self.rd(p, 4) if OBJ_BASE <= p < OBJ_BASE + o3f.OBJ_SIZE - 4 else bytes(4)
        if name == 'c.sndoff':
            p = struct.unpack('<I', self.rd(MGR + 0x6aa, 4))[0]
            obj = struct.unpack('<I', self.rd(MGR + 0xfad, 4))[0]
            return struct.pack('<I', (p - obj) & 0xffffffff if p else 0)
        if name == 'c.blk':
            return struct.pack('<I', 1 if struct.unpack('<I', self.rd(MGR + 0xfa5, 4))[0] else 0)
        if name == 'c.blksz':
            return self.rd(MGR + 0xfa9, 4)
        if name == 'c.syncn':
            return self.rd(CHAN_BASE + 0xc * CHAN_STRIDE + 0x17a, 4)
        if name == 'c.synclast':
            return self.rd(CHAN_BASE + 0xc * CHAN_STRIDE + 0x182, 4)
        if name == 'c.sf':
            return b''.join(self.rd(MGR + 0x1c + i * 0x16, 2) for i in range(SLOTS))
        if name == 'c.surf':
            return b''.join(self.rd(HDR_BASE + i * HDR_OBJ, 4) for i in range(SLOTS * 4))
        if name == 'c.hdrdata':
            out = bytearray()
            for i in range(SLOTS * 4):
                o = HDR_BASE + i * HDR_OBJ
                out += self.rd(o + 0x2f, 2) + self.rd(o + 0x35, 16) + self.rd(o + 0x45, 16)
            return bytes(out)
        return super().field(name, size, nil)

    # -- scenario plumbing ----------------------------------------------------------------------
    def hard_reset(self):
        super().hard_reset()
        self.machine.mem_write(CEL_BASE + 0x100, bytes(0x30000 - 0x100))
        if self._block_len:
            self.machine.mem_write(BLOCK_VA, bytes(self._block_len))
        self._block_len = 0
        self.thread_obj = 0
        self.machine.mem_write(VTABLE, struct.pack('<I', VDELETE))
        self.machine.mem_write(VDELETE, b'\xc3')
        self.machine.reg_write(X.UC_X86_REG_FPCW, FPCW)

    def install_rows(self, row, tail, handle):
        self.wr(SLOT, bytes(8 * ROW))
        for i in range(row):
            self.wr(SLOT + i * ROW + COMPLETE, b'\1')
        base = SLOT + row * ROW
        self.wr(base + 0x30, bytes([0x3e, 2]) + struct.pack('<I', handle))
        storage = o3f.TAIL_BASE + row * 0x80
        self.wr(storage, tail or bytes(16))
        _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
        if not ok:
            raise OracleError('original dependency construction failed')
        self.wr(base + COMPLETE, b'\0')
        self.wr(base + PHASE, struct.pack('<I', 0))
        self.wr(0x5c39e3, struct.pack('<h', row + 1))

    def install_cel(self, sc):
        self.wr(SND_MGR + 0x3ce, struct.pack('<I', CHAN_BASE))
        self.wr(SND_MGR + 0x1a0, struct.pack('<I', 1))
        for s in range(SLOTS):
            for l in range(4):
                self.wr(MGR + 0x22 + s * 0x16 + l * 4, struct.pack('<I', HDR_BASE + (s * 4 + l) * HDR_OBJ))
        block = sc['script'].get('block') or b''
        self.wr(BLOCK_VA, block)
        self._block_len = len(block)
        for idx, v in sc['script'].get('kind', {}).items():
            self.wr(0x5d34ef + idx * 0x84d, bytes([v]))
        for idx, v in sc['script'].get('transp', {}).items():
            self.wr(0x5d34f0 + idx * 0x84d, bytes([v]))
        self.wr(0x5d15e3, struct.pack('<I', 0x70001000))
        self.wr(0x5cf665, struct.pack('<I', 0x70002000))
        self.wr(0x5b028e, struct.pack('<h', sc.get('stall', 0)))
        vx, vy = sc.get('view', (0, 0))
        self.wr(0x583186, struct.pack('<i', vx))
        self.wr(0x58318a, struct.pack('<i', vy))
        self.wr(MGR + 0x786, struct.pack('<h', sc.get('i786', 0)))

    def seed_cache(self, seeds, loaded=None):
        """Write cached frames (slot, frame) with decoded header objects for the layers of the row."""
        nl = struct.unpack('<h', self.rd(MGR + 0xf9b, 2))[0]
        trees = struct.unpack('<2h', self.rd(MGR + 0xfb5, 4))
        for s in range(SLOTS):
            self.wr(MGR + 0x1c + s * 0x16, struct.pack('<h', -1))
            for l in range(4):
                self.wr(HDR_BASE + (s * 4 + l) * HDR_OBJ, bytes(4))
        for slot, frame in seeds:
            self.wr(MGR + 0x1c + slot * 0x16, struct.pack('<h', frame))
            for l in range(max(0, min(nl, 2))):
                surface, key, src, dst = decode_layer(trees[l], frame, l)
                o = HDR_BASE + (slot * 4 + l) * HDR_OBJ
                self.wr(o, struct.pack('<I', surface))
                self.wr(o + 0x2f, struct.pack('<H', key))
                self.wr(o + 0x35, struct.pack('<4i', *src))
                self.wr(o + 0x45, struct.pack('<4i', *dst))
        self.wr(MGR + 0x68e, struct.pack('<h', len(seeds) if loaded is None else loaded))

    def run_raw(self, address, stack_args, ecx, stop_on_sleep):
        from unicorn import UcError
        uc = self.machine
        self._hook_error = None
        self._sleep_hit = False
        words = [deps.RETURN_SENTINEL, *[v & 0xFFFFFFFF for v in stack_args]]
        uc.mem_write(deps.STACK_TOP, struct.pack('<' + 'I' * len(words), *words))
        uc.reg_write(X.UC_X86_REG_ESP, deps.STACK_TOP)
        uc.reg_write(X.UC_X86_REG_ECX, ecx)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        self._in_pass = stop_on_sleep
        try:
            uc.emu_start(address, deps.RETURN_SENTINEL, timeout=60_000_000, count=40_000_000)
        except UcError as error:
            if self._hook_error:
                raise OracleError(self._hook_error) from error
            raise OracleError('x86 run %#x failed at %#x: %s' % (address, uc.reg_read(X.UC_X86_REG_EIP), error))
        finally:
            self._in_pass = False
        if self._hook_error:
            raise OracleError(self._hook_error)
        if stop_on_sleep:
            if not self._sleep_hit:
                raise OracleError('reader pass ended without reaching Sleep')
        elif uc.reg_read(X.UC_X86_REG_EIP) != deps.RETURN_SENTINEL:
            raise OracleError('x86 run %#x stopped at %#x' % (address, uc.reg_read(X.UC_X86_REG_EIP)))

    def dispatch(self):
        self._fatal_log = 0
        super().dispatch()
        if self._fatal_log:
            raise OracleError('log line of a fatal path (from %#x) without the abort' % self._fatal_log)

    def _begin(self):
        self.events = []
        self.writes.clear()
        self.unclassified.clear()
        self.active = True

    def _end(self):
        self.active = False
        if self.unclassified:
            items = ', '.join('%#x/%d' % k for k in sorted(self.unclassified)[:24])
            raise OracleError('unclassified original stores: ' + items)

    def reader_pass(self):
        self._begin()
        self.counters_total.update(['pass'])
        try:
            self.wr(STOPVAR, bytes(4))
            self.run_raw(0x422e4a, [STOPVAR], 0, True)
        finally:
            self.active = False
        self._end()

    def render(self):
        self._begin()
        self.counters_total.update(['render'])
        try:
            self.run_raw(0x422a0a, [], 0, False)
        finally:
            self.active = False
        self._end()


# ---------------------------------------------------------------------------------------------
# images and scenarios
# ---------------------------------------------------------------------------------------------
def make_block(layers, param, last, names='all'):
    """CIFTREE file image: 0x2a header (layer count +0x24, sync param +0x26), then 0x8c bytes per frame."""
    n = last + 1
    b = bytearray(0x2a + n * FRAME_STRIDE)
    struct.pack_into('<h', b, 0x24, layers)
    struct.pack_into('<I', b, 0x26, param)
    for f in range(n):
        if names == 'tail' and f < n - 6:
            continue
        for l in range(2):
            nm = ('F%05d_%d' % (f, l)).encode()
            b[0x2a + f * FRAME_STRIDE + l * 0x21:0x2a + f * FRAME_STRIDE + l * 0x21 + len(nm)] = nm
    return bytes(b)


def body3e(file=b'CELHDR', layers=(b'LAYER_A', b'LAYER_B'), last=20, sound=b'TALK_LINE', key=b'K',
           hooks=(0x14, 0x14), opt=0, primary=(), secondary=(), tail=b''):
    b = bytearray(178)
    for off, nm in ((0, file), (33, layers[0]), (66, layers[1]), (101, sound), (136, key)):
        b[off:off + len(nm)] = nm
    struct.pack_into('<H', b, 99, last & 0xffff)
    b[134] = 85
    struct.pack_into('<BBBHHh', b, 169, hooks[0], hooks[1], opt, 9999, 0, len(primary))
    return bytes(b) + o3f.body_bytes(primary=primary, secondary=secondary, tail=tail)[77:]


def image_for(ctor, sc):
    body = body3e(last=sc['last'], layers=sc.get('layer_names', (b'LAYER_A', b'LAYER_B')),
                  sound=sc.get('sound', b'TALK_LINE'), primary=sc.get('primary', ()),
                  secondary=sc.get('secondary', ()))
    texts = ['caption text'] + [p.get('text', 'resp %d' % i) for i, p in enumerate(sc.get('primary', ()))]
    image = bytearray(ctor.build(body, texts, OBJ_BASE))
    struct.pack_into('<h', image, 0xa8, sc.get('first', 0))
    struct.pack_into('<h', image, 0xaa, sc['last'])
    image[0xa5:0xa8] = bytes(sc.get('steps_tab', (1, 2, 3)))
    for i, v in enumerate(sc.get('pct', (1, 2, 3))):
        struct.pack_into('<h', image, 0xac + 2 * i, v)
    for off, data in sc.get('patch', {}).items():
        image[off:off + len(data)] = data
    return bytes(image)


def standard_script(sc, rng, n_state4=60):
    d = dict(sc.get('script', {}))
    d.setdefault('tree', [(b'LAYER_A', 5), (b'LAYER_B', 9)][:max(0, min(2, sc.get('layers', 2)))])
    d.setdefault('kind', {5: 0, 9: 1})
    d.setdefault('transp', {5: 1, 9: 2})
    d['block'] = make_block(sc.get('layers', 2), sc.get('param', 12345), sc['last'], sc.get('block_names', 'all'))
    d.setdefault('bpf', 1000)
    d.setdefault('slots', [3, 4])
    d.setdefault('names', [b'NO SOUND'] * 3)
    return d


def raw_sequence(rng, count, bpf, nframes, mode):
    """Scripted raw sound positions (bytes). mode: smooth, jumpy, mixed, stuck, unreadable, back."""
    out, pos = [], 0
    for _ in range(count):
        if mode == 'smooth':
            pos += rng.randrange(0, 2 * bpf)
        elif mode == 'jumpy':
            pos += rng.randrange(0, 6 * bpf)
        elif mode == 'stuck':
            pos += rng.randrange(0, bpf // 4 + 1)
        elif mode == 'back':
            pos = max(-bpf, pos + rng.randrange(-3 * bpf, 4 * bpf))
        else:
            pos += rng.randrange(0, 3 * bpf)
        v = pos
        r = rng.random()
        if mode in ('mixed', 'unreadable') and r < (0.15 if mode == 'mixed' else 0.4):
            v = -1
        elif mode == 'mixed' and r < 0.2:
            v = rng.choice([0, -7, 1, bpf - 1, bpf, bpf + 1])
        out.append(int(min(v, (nframes + 3) * bpf)))
    return out


def scenario(sid, seed, **kw):
    sc = dict(id=sid, seed=seed, row=0, first=0, last=20, layers=2, world={}, steps=[], script={})
    sc.update(kw)
    return sc


def finish_scenario(sc):
    rng = random.Random(sc['seed'])
    w = o3f.default_world(rng)
    w.update(sc.get('world', {}))
    sc['world'] = w
    sc['script'] = standard_script(sc, rng)
    return sc


def visit(**kw):
    return dict(op='visit', **kw)


def capacity_scenarios():
    out = []
    for n in (1, 3, 4, 8, 20, 25, 40, 50, 100, 125, 150, 200, 250, 300, 400, 1000, 1500, 3000):
        for pct in (-3, 0, 1, 2, 3, 5, 7, 10, 15, 20, 25, 30, 33, 50, 60, 70, 75, 90, 99, 100, 101, 150, 400):
            first = 0 if (n + pct) % 3 else 2
            last = first + n - 1
            sc = scenario('cap:n%d:p%d' % (n, pct), n * 1000 + pct + 7, first=first, last=last,
                          pct=(pct, 2, 3), param=7, block_names='tail',
                          steps=[visit()])
            sc['quick'] = (n * 7 + pct) % 9 == 0 or (n, pct) in ((3, 100), (8, 50), (4, 100), (20, 15), (50, 6), (1, 400))
            out.append(sc)
    # the second and third table entries (synthetic index 1 and 2: the game never writes +0x786)
    for idx in (1, 2):
        for n, pct in ((40, 25), (100, 3), (333, 30), (1000, 7), (60, 200)):
            sc = scenario('cap:syn_i786_%d:n%d:p%d' % (idx, n, pct), n + idx, last=n - 1, i786=idx,
                          pct=(1, pct, pct + 1), block_names='tail', steps=[visit()])
            out.append(sc)
    return out


def phase0_scenarios():
    out = []
    base = dict(first=0, last=12)
    out.append(scenario('p0:happy2', 1, **base, steps=[visit(), dict(op='pass', n=3), visit()]))
    out.append(scenario('p0:happy1', 2, **base, layers=1, steps=[visit(), dict(op='pass', n=2), visit()]))
    out.append(scenario('p0:happy0', 3, **base, layers=0, steps=[visit(), dict(op='pass', n=2), visit()]))
    out.append(scenario('p0:underscore', 4, **base, sound=b'A_B_C_D', steps=[visit()]))
    out.append(scenario('p0:view', 5, **base, view=(17, -9), steps=[visit()]))
    out.append(scenario('p0:held_item', 6, **base, world=dict(held=7, c106=0, l788=5, e204=3, capt=1),
                        steps=[visit()]))
    out.append(scenario('p0:captions', 7, **base, world=dict(capt=1, e204=4), steps=[visit()]))
    # existing reader: row phase rewound to 0 after a first conversation (teardown 0x449a94 + delete)
    out.append(scenario('p0:existing_reader', 8, **base,
                        steps=[visit(), dict(op='pass', n=4), dict(op='rewind'), dict(op='inject', world=dict(f9=0, fd=0)),
                               visit(), dict(op='pass', n=2), visit()]))
    out.append(scenario('p0:existing_reader_view', 9, **base, view=(5, 6),
                        steps=[visit(), dict(op='pass', n=2), dict(op='rewind'),
                               dict(op='inject', world=dict(f9=0, fd=0)), visit()]))
    out.append(scenario('p0:existing_reader_cached', 16, first=0, last=30, pct=(60, 2, 3),
                        steps=[visit(), dict(op='pass', n=9), dict(op='rewind'),
                               dict(op='inject', world=dict(f9=0, fd=0)), visit(), dict(op='pass', n=3)]))
    # fatal paths: the original aborts (0x52139c), the native kernel refuses
    out.append(scenario('p0:fatal_missing_header', 10, **base, script=dict(fail_header=True),
                        steps=[visit(fatal=0x52139c)]))
    out.append(scenario('p0:fatal_missing_layer0', 11, **base, script=dict(tree=[(b'LAYER_A', -1), (b'LAYER_B', 9)]),
                        steps=[visit(fatal=0x52139c)]))
    out.append(scenario('p0:fatal_missing_layer1', 12, **base, script=dict(tree=[(b'LAYER_A', 5), (b'LAYER_B', -1)]),
                        steps=[visit(fatal=0x52139c)]))
    out.append(scenario('p0:fatal_no_sound_resource', 13, **base, script=dict(load_ok=False),
                        steps=[visit(), dict(op='pass', n=6), visit(fatal=0x52139c)]))
    out.append(scenario('p0:fatal_sync_init', 14, **base, script=dict(fail_sync=True),
                        steps=[visit(), dict(op='pass', n=6), visit(fatal=0x52139c)]))
    out.append(scenario('p0:existing_reader_twice', 17, **base,
                        steps=[visit(), dict(op='pass', n=3), dict(op='rewind'),
                               dict(op='inject', world=dict(f9=0, fd=0)), visit(), dict(op='pass', n=3),
                               dict(op='rewind'), dict(op='inject', world=dict(f9=0, fd=0)), visit()]))
    out.append(scenario('p0:native_layer_count_3', 15, **base, layers=3, script=dict(tree=[(b'LAYER_A', 5), (b'LAYER_B', 9)]),
                        steps=[visit(fatal=0x52139c)]))
    for sc in out:
        sc['quick'] = True
    return out


def seeded_states(rng, sc_id, count):
    """Reader passes over randomized cache states (phase 0 first, then arbitrary cache contents)."""
    out = []
    for n in range(count):
        first = rng.choice([0, 0, 0, 3])
        last = first + rng.choice([3, 5, 9, 14, 20, 33, 60, 90, 130])
        nframes = last - first + 1
        cap = rng.choice([4, 4, 5, 6, 8, 10, 16, 30, 75])
        steps_tab = (rng.choice([0, 1, 2, 3, 5]), rng.choice([0, 1, 2]), 3)
        i786 = rng.choice([0, 0, 0, 1, 2])
        mode = rng.choice(['full', 'below', 'forced', 'sparse', 'empty', 'boost', 'lock'])
        cur = rng.randrange(first, last + 1)
        slots = list(range(75))
        rng.shuffle(slots)
        count_c = {'full': cap, 'below': rng.randrange(1, cap + 1), 'forced': rng.randrange(0, cap),
                   'sparse': rng.randrange(0, cap), 'empty': 0, 'boost': rng.randrange(0, cap),
                   'lock': rng.randrange(0, cap)}[mode]
        frames = set()
        want = min(count_c, nframes, (cur + 2 - first) if mode == 'below' else nframes)
        while len(frames) < want:
            if mode == 'below':
                frames.add(rng.randrange(first, max(first + 1, cur + 2)))
            else:
                frames.add(rng.randrange(first, last + 1))
        seeds = [(i, f) for i, f in enumerate(sorted(frames))]  # slots 0.. stay below the capacity
        nxt = rng.choice([first, cur, cur + 1, last, min(last, cur + 3), first + (nframes // 2)])
        forced = -1 if mode != 'forced' else rng.choice([first, cur, last, min(last, cur + 2), last + 4])
        cur_slot = -1 if not seeds or rng.random() < 0.3 else rng.randrange(len(seeds))
        mgr = {0x696: (cap, 2), 0x69c: (cur, 2), 0x692: (nxt, 2), 0x694: (forced, 2),
               0x690: (cur_slot, 2), 0x78c: (rng.randrange(0, 6) if mode == 'boost' else 0, 2)}
        sc = scenario('%s:%d:%s' % (sc_id, n, mode), 70000 + n, first=first, last=last,
                      steps_tab=steps_tab, i786=i786, pct=(100, 100, 100), param=99, block_names='all',
                      stall=rng.choice([0, 0, 1, 2]))
        npass = rng.randrange(1, 7)
        ops = [visit(), dict(op='pass', n=0),
               dict(op='inject', seeds=seeds, mgr=mgr, loaded=len(seeds))]
        if mode == 'lock':
            ops.append(dict(op='inject', mgr={0x698: (2, 4)}))
        ops.append(dict(op='pass', n=npass))
        if mode == 'lock':
            ops.append(dict(op='inject', mgr={0x698: (0, 4)}))
            ops.append(dict(op='pass', n=2))
        sc['steps'] = ops
        sc['quick'] = n % 4 == 0
        out.append(sc)
    return out


def wrap_scenarios():
    out = []
    for n, (first, last, tab) in enumerate(((32700, 32767, (3, 2, 3)), (32760, 32767, (1, 2, 3)),
                                           (32000, 32767, (3, 3, 3)), (0, 32767, (3, 2, 3)))):
        sc = scenario('rdr_wrap:%d' % n, 71000 + n, first=first, last=last, steps_tab=tab, pct=(100, 100, 100),
                      block_names='tail', param=5)
        sc['steps'] = [visit(), dict(op='pass', n=0),
                       dict(op='inject', seeds=[(0, last - 1)], loaded=1,
                            mgr={0x696: (8, 2), 0x69c: (last - 2, 2), 0x692: (last, 2), 0x694: (-1, 2),
                                 0x690: (0, 2)}),
                       dict(op='pass', n=1)]
        sc['quick'] = n == 0
        out.append(sc)
    return out


def flow_scenarios(rng, count):
    out = []
    for n in range(count):
        first = rng.choice([0, 0, 0, 0, 2])
        last = first + rng.choice([4, 7, 11, 19, 29, 44, 70])
        nframes = last - first + 1
        bpf = rng.choice([50, 441, 1000, 2205, 7])
        pct = rng.choice([1, 5, 10, 20, 35, 50, 75, 100])
        layers = rng.choice([2, 2, 2, 1, 0])
        rmode = rng.choice(['smooth', 'smooth', 'jumpy', 'mixed', 'stuck', 'unreadable', 'back'])
        stall = rng.choice([0, 0, 0, 1, 2, 3])
        i786 = rng.choice([0, 0, 0, 0, 1, 2])
        fast = rng.choice([0, 0, 0, 1])
        resp = rng.choice([0, 0, 1, 2])
        view = rng.choice([(0, 0), (0, 0), (13, -4)])
        primary = [dict(text='resp %d' % k, scene=100 + k, sound=b'SOUND%d' % k) for k in range(resp)]
        steps_tab = (rng.choice([1, 2, 3]), 2, 3)
        sid = 'flow:%d:%s:f%d:r%d:s%d' % (n, rmode, fast, resp, stall)
        sc = scenario(sid, 80000 + n, first=first, last=last, layers=layers, pct=(pct, 2, 3), steps_tab=steps_tab,
                      bpf_=bpf, stall=stall, i786=i786, view=view, primary=primary,
                      world=dict(fast=fast, capt=1 if resp else rng.choice([0, 0, 1])),
                      param=rng.randrange(1, 1 << 20))
        names = [b'NO SOUND', b'', b'RSP_%d' % n, b'NO SOUND', b'', b'X' * 32]
        nvis = 70
        sc['script'] = dict(bpf=bpf, raw=raw_sequence(rng, 200, bpf, nframes, rmode),
                            playing_c=[1 if rng.random() > 0.04 else 0 for _ in range(200)],
                            playing_d=[1, 1, 0], names=names[:max(resp, 1)] if resp else names,
                            key_skip=[rng.choice([0, 0, 1, 2]) for _ in range(nvis)], slots=[3, 4])
        ops = [visit()]
        for t in range(nvis):
            k = rng.choice([0, 0, 1, 1, 2, 3])
            if k:
                ops.append(dict(op='pass', n=k))
            if t % 11 == 5:
                ops.append(dict(op='render'))
            v = visit()
            if resp and t == 12:
                v['choose'] = (lambda c, n=n: None if c == 0 else n % c)
            ops.append(v)
        sc['steps'] = ops
        sc['quick'] = n % 5 == 0
        out.append(sc)
    return out


def sync_scenarios():
    """Single-frame cels and scripted sound positions with decreases, repeats and jumps over the last frame."""
    out = []
    for n, (first, last) in enumerate(((0, 0), (0, 1), (0, 2), (4, 4))):
        sc = scenario('sync_single:%d' % n, 97000 + n, first=first, last=last, pct=(100, 2, 3), param=11)
        sc['script'] = dict(bpf=100, raw=[40, 140, 40, -1, 0, 250, 5, 99, 100, 101] * 6, playing_c=[1] * 60)
        sc['steps'] = [visit(), dict(op='pass', n=2)] + [visit() for _ in range(14)]
        sc['quick'] = True
        out.append(sc)
    patterns = (
        [350, 520, 190, 0, 90, 700, 640, 300, 1000, 900, 1100, 800],
        [150, 150, 150, 450, 250, 250, 650, 640, 1200, 200, 2000, 100],
        [-1, 50, -1, 450, 100, 300, 100, 0, -9, 600, 200, 1000],
    )
    for n, raws in enumerate(patterns):
        sc = scenario('sync_back:%d' % n, 97100 + n, first=0, last=9, pct=(100, 2, 3), param=11)
        sc['script'] = dict(bpf=100, raw=raws * 5, playing_c=[1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1] * 5)
        sc['steps'] = [visit(), dict(op='pass', n=12)] + [item for _ in range(12) for item in (dict(op='pass', n=1), visit())]
        sc['quick'] = True
        out.append(sc)
    return out


def smooth_finish_scenarios():
    """Frame-synchronous run to the last frame with plenty of reader passes (completion, phase 2 with a loaded
    cache, response sound paths)."""
    out = []
    for n, (resp, fast, layers, with_view) in enumerate(((0, 0, 2, False), (0, 0, 1, True), (1, 0, 2, False),
                                                           (2, 1, 2, False), (0, 1, 2, False), (1, 1, 0, False),
                                                           (0, 0, 0, False), (2, 0, 2, True))):
        last, bpf = 14, 100
        primary = [dict(text='resp %d' % k, scene=200 + k, sound=b'SND%d' % k) for k in range(resp)]
        sc = scenario('finish:%d:r%d:f%d:l%d' % (n, resp, fast, layers), 90000 + n, last=last, layers=layers,
                      pct=(100, 2, 3), primary=primary, view=(3, 4) if with_view else (0, 0),
                      world=dict(fast=fast, capt=1 if resp else 0), param=77)
        sc['script'] = dict(bpf=bpf, raw=[i * 100 + 40 for i in range(200)], playing_c=[1] * 200,
                            playing_d=[1, 1, 0], names=[b'RESP_A', b'NO SOUND', b'RESP_B'][:max(resp, 1)] if resp else [],
                            key_skip=[0, 0, 0, 1, 1, 1] * 12, slots=[3, 4])
        ops = [visit(), dict(op='pass', n=5)]
        for t in range(40):
            ops.append(dict(op='pass', n=2))
            if t % 3 == 1:
                ops.append(dict(op='render'))
            v = visit()
            if resp and t == 18:
                v['choose'] = (lambda c: None if c == 0 else 0)
            ops.append(v)
        sc['steps'] = ops
        sc['quick'] = True
        out.append(sc)
    return out


def render_scenarios(rng):
    out = []
    n = 0
    for k0 in (0, 1, 2, 3):
        for t0 in (1, 2):
            for k1 in (0, 1, 2, 3):
                for t1 in (1, 2):
                    for view in ((0, 0), (23, -11)):
                        mode2 = rng.random() < 0.35
                        order = rng.choice([(1, 0, 2, 3), (0, 1, 2, 3), (1, 0, 2, 3), (5, 1, 2, 3), (1, 5, 2, 3), (3, 2, 2, 3)])
                        patch = {0xb2: bytes(order)}
                        if mode2:
                            patch[0xb6] = bytes([rng.choice([1, 2]), rng.choice([1, 2]), 1, 1])
                            patch[0xba] = struct.pack('<8i', *[rng.randrange(-5, 80) for _ in range(8)])
                            patch[0xfa] = struct.pack('<8i', *[rng.randrange(-5, 80) for _ in range(8)])
                        sc = scenario('render:k%d%d_t%d%d_v%d:%d' % (k0, k1, t0, t1, view[0], n), 95000 + n,
                                      last=9, view=view, patch=patch, param=3,
                                      script=dict(kind={5: k0, 9: k1}, transp={5: t0, 9: t1}))
                        sc['steps'] = [visit(), dict(op='pass', n=6),
                                       dict(op='inject', mgr={0x690: (rng.randrange(0, 6), 2)}),
                                       dict(op='render'),
                                       dict(op='inject', mgr={0x690: (rng.randrange(0, 6), 2)}),
                                       dict(op='render'), dict(op='render')]
                        sc['quick'] = n % 6 == 0
                        out.append(sc)
                        n += 1
    for n2, prio in enumerate(((0, 0, 2, 3), (1, 1, 2, 3))):
        # Equal priorities: the original abandons the layer scan after drawing one layer of an order value
        # (0x422e20 -> 0x422e27 -> 0x422a4a); the kernel does the same since the K1 fix. Unreachable in the game.
        sc = scenario('render_dup:%d' % n2, 96500 + n2, last=9, view=(1, 2), patch={0xb2: bytes(prio)}, param=3,
                      script=dict(kind={5: 0, 9: 1}, transp={5: 1, 9: 2}))
        sc['steps'] = [visit(), dict(op='pass', n=6), dict(op='inject', mgr={0x690: (2, 2)}), dict(op='render')]
        out.append(sc)
    for layers in (0, 1):
        for k in (0, 1, 2, 3):
            sc = scenario('render:layers%d_k%d' % (layers, k), 96000 + layers * 10 + k, last=9, layers=layers,
                          view=(2, 3), script=dict(kind={5: k, 9: k}, transp={5: 1, 9: 1}))
            sc['steps'] = [visit(), dict(op='pass', n=3), dict(op='inject', mgr={0x690: (1, 2)}),
                           dict(op='render'), dict(op='render')]
            out.append(sc)
    return out


def build_scenarios(args):
    rng = random.Random(25)
    scs = capacity_scenarios() + phase0_scenarios() + seeded_states(rng, 'rdr', args.rdr) + wrap_scenarios()
    scs += flow_scenarios(rng, args.flow) + smooth_finish_scenarios() + sync_scenarios() + render_scenarios(rng)
    for sc in scs:
        finish_scenario(sc)
        if 'bpf_' in sc:
            sc['script']['bpf'] = sc['bpf_']
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    return scs


# ---------------------------------------------------------------------------------------------
# running
# ---------------------------------------------------------------------------------------------
def resync(x, nat, spec):
    blob = x.snapshot(True)
    nat.load(blob)
    back = nat.store(True)
    if back != blob:
        raise Mismatch('state import round trip: ' + '; '.join(diff_fields(spec, blob, back, True)[:4]))


def compare_events(where, x, ev, nev, spec, stats, prefix_only=False, ignore=()):
    a = [t for t, _ in ev]
    b = [t for t, _ in nev]
    if prefix_only:
        if len(b) > len(a) or a[:len(b)] != b:
            k = next((i for i in range(min(len(a), len(b))) if a[i] != b[i]), min(len(a), len(b)))
            raise Mismatch('%s effect %d: original %r vs native %r' % (where, k, a[k] if k < len(a) else None,
                                                                       b[k] if k < len(b) else None))
        ev = ev[:len(b)]
    elif a != b:
        k = next((i for i in range(min(len(a), len(b))) if a[i] != b[i]), min(len(a), len(b)))
        extra = ' [original %s | native %s]' % (a[-4:], b[-4:]) if len(a) != len(b) else ''
        raise Mismatch('%s effect %d: original %r vs native %r%s' % (where, k, a[k] if k < len(a) else None,
                                                                     b[k] if k < len(b) else None, extra))
    light = sum(1 for f in spec if not f[2])
    for k, ((t, sa), (_, sb)) in enumerate(zip(ev, nev)):
        stats['effects'] += 1
        stats['effect_kinds'][t.split()[0].split('=')[0]] += 1
        if sa is None:
            continue
        stats['light_snapshots'] += 1
        stats['fields_compared'] += light
        d = diff_fields(spec, sa, sb, False)
        if ignore:
            kept = [v for v in d if not v.startswith(tuple(ignore))]
            if len(kept) != len(d):
                stats['known']['K2'] += 1
            d = kept
        if d:
            raise Mismatch('%s effect %d (%s): %s' % (where, k, t, '; '.join(d[:5])))


def compare_end(where, x, nat, spec, image, stats, check_image=True, ignore=()):
    fa, fb = x.snapshot(True), nat.store(True)
    stats['full_snapshots'] += 1
    stats['fields_compared'] += len(spec)
    stats['bytes_compared'] += len(fa)
    d = diff_fields(spec, fa, fb, True)
    if ignore:
        kept = [v for v in d if not v.startswith(tuple(ignore))]
        if len(kept) != len(d):
            stats['known']['K3'] += 1
        d = kept
    if d:
        raise Mismatch('%s end of step: %s' % (where, '; '.join(d[:6])))
    if check_image:
        ia, ib = x.rd(OBJ_BASE, len(image)), nat.arena()
        stats['bytes_compared'] += len(ia)
        if ia != ib:
            k = next(i for i in range(len(ia)) if ia[i] != ib[i])
            raise Mismatch('%s object image differs at +%#x' % (where, k))


def cov_state(x):
    g = lambda off, n=2: int.from_bytes(x.rd(MGR + off, n), 'little', signed=(n == 2))
    chan = CHAN_BASE + 0xc * CHAN_STRIDE
    return dict(boost=g(0x78c), forced=g(0x694), stall=g(0x788), relax=g(0x78a), drawn=g(0x77e), target=g(0x782),
                final=g(0x784), sub=g(0x6b6, 4) & 0xffff, loaded=g(0x68e), next=g(0x692), slot=g(0x690),
                frame=g(0x69c), last=g(0x6a4), cap=g(0x696),
                sync_last=int.from_bytes(x.rd(chan + 0x182, 4), 'little', signed=True),
                sync_count=int.from_bytes(x.rd(chan + 0x17a, 4), 'little', signed=True))


def observe(stats, kind, b, a):
    c = stats['coverage']
    c[kind] += 1
    if a['boost'] > b['boost']:
        c['boost_up'] += 1
    if a['boost'] < b['boost']:
        c['boost_down'] += 1
    if a['boost'] == 5:
        c['boost_at_cap'] += 1
    if b['forced'] == -1 and a['forced'] != -1:
        c['forced_set'] += 1
    if b['forced'] != -1 and a['forced'] == -1:
        c['forced_consumed'] += 1
    if a['stall'] > b['stall']:
        c['stall_up'] += 1
    if a['relax'] > b['relax']:
        c['relax_up'] += 1
    if a['final'] and not b['final']:
        c['final_seen_set'] += 1
    if a['sub'] != b['sub']:
        c['sub_%d_to_%d' % (b['sub'], a['sub'])] += 1
    if a['loaded'] < b['loaded']:
        c['evictions'] += 1
    if a['loaded'] > b['loaded']:
        c['frame_loads'] += 1
    if kind == 'pass' and a['next'] != b['next']:
        c['reader_advance'] += 1
    if kind == 'pass' and a['next'] == b['next'] and a['loaded'] == b['loaded']:
        c['reader_idle'] += 1
    if kind == 'visit' and a['target'] != b['target']:
        c['frame_shown'] += 1
    if kind == 'visit' and a['sync_count'] > 0 and a['sync_last'] == a['sync_count'] - 1:
        c['sync_at_last_frame'] += 1
    if kind == 'visit' and a['drawn'] == a['last'] and a['drawn'] >= 0:
        c['drawn_is_last'] += 1
    if kind == 'visit' and a['slot'] == -1 and b['sub'] == 4:
        c['state4_without_slot'] += 1


def run_visit(x, nat, spec, sc, op, ctx, stats, image, tag):
    row = sc['row']
    for idx, v in op.get('events', {}).items():
        x.wr(o3f.EVENTS_VA + 4 * idx, struct.pack('<i', v))
        nat.lib.a3e_set_event(nat.h, idx, v)
    ct = op.get('choose')
    if ct is not None:
        count = struct.unpack('<h', x.rd(MGR + 0xf21, 2))[0]
        idx = ct(count) if callable(ct) else ct
        if idx is not None and 0 <= idx < 30:
            x.wr(0x5839b1 + 4 * idx, struct.pack('<i', 1))
            nat.lib.a3e_set_chosen(nat.h, idx, 1)
    before = dict(phase=x.phase(row), done=x.completed(row), mode=x.s32(0x583999))
    cov_b = cov_state(x)
    fatal = op.get('fatal')
    err = None
    try:
        x.dispatch()
    except OracleError as error:
        err = error
    if err is not None:
        if not fatal or ('%#x' % fatal) not in str(err):
            raise Mismatch('%s: original failed unexpectedly: %s' % (tag, str(err)[:200]))
        status, why, nev, res = nat.visit(row, before['phase'])
        if status == 0:
            raise Mismatch('%s: native accepted a path where the original aborts at %#x' % (tag, fatal))
        stats['fatal_agreed'] += 1
        compare_events(tag, x, x.events, nev, spec, stats, prefix_only=True)
        ctx['done'] = True
        return
    if fatal:
        raise Mismatch('%s: original did not abort at %#x' % (tag, fatal))
    if x.entered != [row]:
        raise Mismatch('%s: handler entered %s' % (tag, x.entered))
    status, why, nev, res = nat.visit(row, before['phase'])
    stats['native_status'][status] += 1
    if status != 0:
        raise Mismatch('%s: native refused (status %d: %s) where the original ran' % (tag, status, why))
    if res[5]:
        nev.append(('release row=%d' % row, None))
    compare_events(tag, x, x.events, nev, spec, stats)
    compare_end(tag, x, nat, spec, image, stats)
    after = dict(phase=x.phase(row), done=x.completed(row), mode=x.s32(0x583999))
    if after['phase'] != res[0]:
        raise Mismatch('%s phase: original %d native %d' % (tag, after['phase'], res[0]))
    if (after['done'] and not before['done']) != bool(res[3]):
        raise Mismatch('%s completion byte: original %d native finished=%d' % (tag, after['done'], res[3]))
    if (before['phase'], after['phase']) == (0, 1) and not res[2]:
        raise Mismatch('%s started flag' % tag)
    if any(t.startswith('release') for t, _ in x.events) != bool(res[5]):
        raise Mismatch('%s release flag' % tag)
    if (after['mode'] == 4 and before['mode'] == 3) != bool(res[4]):
        raise Mismatch('%s scene_change flag' % tag)
    stats['visits'] += 1
    observe(stats, 'visit', cov_b, cov_state(x))
    stats['phases'][(before['phase'], after['phase'])] += 1
    if after['done'] or after['mode'] != 3:
        ctx['done'] = True


def run_pass(x, nat, spec, sc, op, ctx, stats, image, tag):
    for k in range(op['n']):
        if struct.unpack('<I', x.rd(MGR + 0x6b2, 4))[0] == 0:
            stats['passes_skipped'] += 1
            continue
        cov_b = cov_state(x)
        x.reader_pass()
        status, why, nev, ran = nat.pass_()
        if status != 0:
            raise Mismatch('%s pass %d: native refused (status %d: %s)' % (tag, k, status, why))
        compare_events('%s pass %d' % (tag, k), x, x.events, nev, spec, stats)
        compare_end('%s pass %d' % (tag, k), x, nat, spec, image, stats, check_image=False)
        stats['passes'] += 1
        stats['pass_ran'] += 1 if ran else 0
        observe(stats, 'pass', cov_b, cov_state(x))


def run_render(x, nat, spec, sc, op, ctx, stats, image, tag):
    if struct.unpack('<h', x.rd(MGR + 0x690, 2))[0] < 0 or struct.unpack('<I', x.rd(MGR + 0x6b2, 4))[0] == 0:
        stats['renders_skipped'] += 1  # slot -1: the original reads a header pointer outside the slot table
        return
    x.render()
    status, why, nev = nat.render()
    if status != 0:
        raise Mismatch('%s render: native refused (status %d: %s)' % (tag, status, why))
    compare_events('%s render' % tag, x, x.events, nev, spec, stats)
    compare_end('%s render' % tag, x, nat, spec, image, stats, check_image=False)
    stats['renders'] += 1
    stats['blits'] += len(nev)


def run_inject(x, nat, spec, sc, op, ctx, stats, image, tag):
    for off, (v, size) in op.get('mgr', {}).items():
        x.wr(MGR + off, struct.pack({2: '<h', 4: '<i'}[size], v))
    if 'seeds' in op:
        x.seed_cache(op['seeds'], op.get('loaded'))
    for k, v in op.get('world', {}).items():
        addr, size = o3f.WORLD[o3f.WORLD_KEYS[k]]
        x.wr(addr, bytes([v & 0xff]) if size == 1 else struct.pack('<h' if size == 2 else '<i', v))
    resync(x, nat, spec)
    stats['injections'] += 1


def run_scenario(x, lib, spec, ctor, sc, stats):
    before = (stats['visits'], stats['effects'], stats['passes'], stats['renders'])
    group = sc['id'].split(':')[0]
    try:
        return run_scenario_inner(x, lib, spec, ctor, sc, stats)
    finally:
        g = stats['groups'].setdefault(group, Counter())
        g['scenarios'] += 1
        g['visits'] += stats['visits'] - before[0]
        g['effects'] += stats['effects'] - before[1]
        g['passes'] += stats['passes'] - before[2]
        g['renders'] += stats['renders'] - before[3]


def run_scenario_inner(x, lib, spec, ctor, sc, stats):
    image = image_for(ctor, sc)
    if sc.get('native_only'):
        nat = Native(lib, spec, image, OBJ_BASE, sc['script'], sc['script'].get('block'))
        try:
            status, why, nev, res = nat.visit(sc['row'], 0)
            if status == 0:
                raise Mismatch('%s: native accepted a layer count above 2' % sc['id'])
            stats['native_rejections'] += 1
            return
        finally:
            nat.close()
    x.hard_reset()
    x.script = sc['script']
    x.counters.clear()
    x.install_object(image)
    x.install_rows(sc['row'], b'', OBJ_BASE)
    o3f.apply_world(x, sc, random.Random(sc['seed']))
    x.install_cel(sc)
    nat = Native(lib, spec, image, OBJ_BASE, sc['script'], sc['script'].get('block'))
    ctx = dict(done=False)
    try:
        resync(x, nat, spec)
        for i, op in enumerate(sc['steps']):
            tag = '%s#%d:%s' % (sc['id'], i, op['op'])
            if ctx['done'] and op['op'] in ('visit', 'pass', 'render'):
                continue
            if op['op'] == 'visit':
                run_visit(x, nat, spec, sc, op, ctx, stats, image, tag)
            elif op['op'] == 'pass':
                run_pass(x, nat, spec, sc, op, ctx, stats, image, tag)
            elif op['op'] == 'render':
                run_render(x, nat, spec, sc, op, ctx, stats, image, tag)
            elif op['op'] == 'inject':
                run_inject(x, nat, spec, sc, op, ctx, stats, image, tag)
            elif op['op'] == 'rewind':
                x.wr(SLOT + sc['row'] * ROW + PHASE, struct.pack('<I', 0))
                x.wr(SLOT + sc['row'] * ROW + COMPLETE, b'\0')
                resync(x, nat, spec)
            else:
                raise OracleError('unknown op ' + op['op'])
        stats['scenarios'] += 1
        stats['writes'].update(x.writes)
    finally:
        nat.close()


def new_stats():
    return dict(scenarios=0, visits=0, passes=0, pass_ran=0, passes_skipped=0, renders_skipped=0, renders=0, blits=0, injections=0,
                effects=0, light_snapshots=0, full_snapshots=0, fields_compared=0, bytes_compared=0,
                mismatches=0, known=Counter(), known_not_observed=Counter(), fatal_agreed=0, native_rejections=0, native_status=Counter(),
                effect_kinds=Counter(), coverage=Counter(), phases=Counter(), writes=Counter(), groups={})


def run_list(x, lib, spec, ctor, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, lib, spec, ctor, sc, stats)
            if sc.get('known'):
                stats['known_not_observed'][sc['known']] += 1
        except (Mismatch, OracleError) as error:
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


# ---------------------------------------------------------------------------------------------
# mutation check
# ---------------------------------------------------------------------------------------------
MUTANTS = {
    'capacity floor lowered': ('if (c->capacity < CONVO3F_CEL_MIN_SLOTS) {', 'if (c->capacity < CONVO3F_CEL_MIN_SLOTS - 1) {'),
    'capacity ceiling dropped': ('if (c->capacity > CONVO3F_CEL_SLOTS) {', 'if (c->capacity > CONVO3F_CEL_SLOTS + 5) {'),
    'boost cap 5 -> 6': ('if (c->boost > 5) {\n                    c->boost = 5;', 'if (c->boost > 6) {\n                    c->boost = 6;'),
    'relax counts as stall': ('++c->relax;\n            if (w->stall_limit_5b028e <= c->relax) {',
                              '++c->stall;\n            if (w->stall_limit_5b028e <= c->stall) {'),
    'forced jump dropped': ('c->next = c->forced;\n                c->forced = -1;', 'c->forced = -1;'),
    'evict < becomes <=': ('m->cel.slots[i].frame < m->cel.frame && i != m->cel.slot',
                           'm->cel.slots[i].frame <= m->cel.frame && i != m->cel.slot'),
    'advance without boost': ('(uint16_t)c->boost));', '0u));'),
    'row end on target': ('playing = m->cel.drawn != m->cel.last;', 'playing = m->cel.target != m->cel.last;'),
    'sync lower bound dropped': ('v = raw > c->sync_last ? raw : c->sync_last;', 'v = raw;'),
    'restore blit skipped': ('blit_add(plan, CONVO3F_BLIT_RESTORE, 0u, 0, restore, dst);\n                    ', ''),
    'view origin wrong axis': ('dst[1] = (int32_t)((uint32_t)dst[1] + (uint32_t)w->view_y_58318a);',
                               'dst[1] = (int32_t)((uint32_t)dst[1] + (uint32_t)w->view_x_583186);'),
    'saved rects not updated': ('memcpy(c->saved_src[layer], hdr->dst, sizeof(hdr->dst));', ''),
    'teardown skipped': ('    if (m->cel_thread != 0) { /* 0x420e... reader teardown: lock := 2, 0x449a94, delete, lock := 0 */\n'
                         '        m->cel.lock = 2;\n        HOST_CALL(h->cel_reader_destroy(h->context), "cel_reader_destroy failed");\n'
                         '        m->cel_thread = 0;\n        m->cel.lock = 0;\n    }\n    {   /* saved layer rectangles',
                         '    {   /* saved layer rectangles'),
    'header not released': ('HOST_CALL(h->cel_release_header(h->context), "cel_release_header failed");\n        m->cel.block = NULL;\n        m->cel.block_bytes = 0u;\n    }\n    memset(m->cel.header',
                            'm->cel.block = NULL;\n        m->cel.block_bytes = 0u;\n    }\n    memset(m->cel.header'),
    'state 1 || becomes &&': ('(c->loaded == c->capacity || c->last <= c->loaded)', '(c->loaded == c->capacity && c->last <= c->loaded)'),
    'forced jump not clamped': ('if (c->last < c->forced) {\n                c->forced = c->last;\n            }', ''),
    'next not clamped': ('if (c->next > c->last) {\n                c->next = c->last;\n            }\n            if (ran',
                         'if (ran'),
    'stall never boosts': ('if (w->stall_limit_5b028e <= c->stall) {', 'if (0) {'),
    'boost never decays': ('if (w->stall_limit_5b028e <= c->relax) {', 'if (0) {'),
    'lock 2 not honoured': ('if (m->cel_thread == 0 || c->lock == 2) {', 'if (m->cel_thread == 0) {'),
    'entry flag not raised': ('c->drawn = c->target;\n        w->ui_5d191d = 1;', 'c->drawn = c->target;'),
    'priority order ignored': ('if (img[C3E_PRIORITY + layer] != (uint8_t)order) {', 'if (0) {'),
    'sync clamp to count dropped': ('if (c->sync_count - 1 < v) {', 'if (0) {'),
    'mode 2 rectangles ignored': ('if (img[C3E_MODE + layer] == 2u) {', 'if (0) {'),
    'evict forgets shown slot': ('m->cel.slots[i].frame < m->cel.frame && i != m->cel.slot',
                                 'm->cel.slots[i].frame < m->cel.frame'),
}


def mutation_check(args, workdir):
    source = (args.src / 'action_family_3f_runtime.c').read_text()
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
        (d / 'action_family_3f_runtime.c').write_text(source.replace(old, new))
        lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run',
               '--flow', str(args.flow), '--rdr', str(args.rdr)]
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=first[6:300] if first else None))
        print('MUTANT', name, 'detected=%s' % report[-1]['detected'], how, (first or '')[6:140], flush=True)
    return report


def code_windows():
    return ([dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in o3f.PINS_TABLE] +
            [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_3E])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--only', default='', help='substring filter of scenario ids (debug)')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--flow', type=int, default=120)
    ap.add_argument('--rdr', type=int, default=160)
    ap.add_argument('--mutations', action='store_true', help='also run the native mutation check')
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    PRIVATE.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='RT-25.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib, spec = Native.open(lib_path)
    ctor = Constructor3e(lib)
    if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
        raise OracleError('executable identity mismatch')
    x = X86Cel(spec)
    scs = build_scenarios(args)
    stats = new_stats()
    if args.mutation_run:
        quick = [s for s in scs if s.get('quick')]
        bad = run_list(x, lib, spec, ctor, quick, stats, fail_fast=True)
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    bad = run_list(x, lib, spec, ctor, scs, stats, args.fail_fast)
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:500])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['phases'] = {str(k): v for k, v in stats['phases'].items()}
    print('KNOWN', dict(stats['known']), 'known_not_observed', dict(stats['known_not_observed']))
    print(json.dumps(summary, sort_keys=True, default=str))
    print('READS of +0x6ba..+0x6da (unmodelled cel timing words):', sum(x.read_6ba.values()),
          sorted({(hex(a), hex(e)) for a, e in x.read_6ba})[:12])
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
    if args.result:
        sources = {n: sha((args.src / n).read_bytes()) for n in
                   ('action_family_3f_runtime.c', 'action_family_3f_runtime.h', 'action_family_3f.c',
                    'action_family_3e.c')}
        killed = sum(1 for m in (mutations or []) if m.get('detected'))
        result = dict(slice='RT-25', task='oracle', status='pass' if not bad else 'fail', mismatches=len(bad),
                      exe_sha256=EXE_HASH, source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_3e_runtime_oracle_driver.c').read_bytes()),
                      fpu_control_word=hex(FPCW), code_windows=code_windows(), scenarios=len(scs), stats=summary,
                      mutants=len(mutations or []), mutants_killed=killed, mutations=mutations,
                      mismatch_list=bad[:50], hooks_fired=dict(x.counters_total),
                      unmodelled_reads_6ba=sum(x.read_6ba.values()),
                      elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    shutil.rmtree(work, ignore_errors=True)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
