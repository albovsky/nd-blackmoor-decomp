#!/usr/bin/env python3
"""RT-41: immutable x86 dispatcher 0x427a50 (arm 0x42950b -> 0x4eb5f2) versus the native raw-0x7d runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x7d the REAL dispatcher 0x427a50 runs: dependency
trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm itself, the view method 0x4eb5f2 that turns the
second saved-scene record at 0x5c3a1b..0x5c3a30 into a scene-change request (the globals 0x5bb57b/0x5bb57f/0x5bb599/0x5bb595/
0x5bb59b/0x5bb59f/0x5bb5a3/0x5c39ff/0x5bb1ca, engine mode 0x583999 := 4), re-adds the item named by the selector word 0x583f1d
with the real inventory add step 0x4e9e84 (flag 0), requests the real UI animation 0x4e0559 and sets the inventory flag 0x583232;
the arm then stores -1 into the selector and the completion byte. The real saver 0x4eb70f is called directly. All of it is
original x86 except the view rebuild 0x4e812f (replaced, see HOOKS).

Native side: src/session_bindings_a7d.c over src/action_family_7d_runtime.c and the RT-19 add step (action_family_78_runtime.c),
driven by tests/action_family_7d_runtime_oracle_driver.c with the executor's disposition mapping. The host callbacks log their
calls in order and snapshot the inventory at the rebuild.

Compared after every dispatcher call (tick):
 * which rows entered the arm (observed entries), against a gate model (event flag dependency records, the world mode word) that
   also stops the pass after a visit (mode 4: the dispatcher's loop needs mode 3 at every row, 0x427a8e);
 * the completion byte and phase dword of every row (the arm sets the byte directly and never touches the phase), and that
   neither the generic completion 0x42ba3a nor the dependency reset 0x423d33 ever ran;
 * the 22 bytes of the record, the selector word, the held word, the count, all 70 list words and all 70 presence dwords, the view
   bytes; the rebuild calls and the inventory at that moment (count, every list word, every presence dword, held); the add calls
   (item, flag 0) and the UI animation call (this 0x570508, index 1, enable 0, sub 0) against the native host's calls in order;
 * memory windows around the destination globals (seeded with random bytes): every byte must equal the pre-tick byte unless the
   visit writes it, and then the native result decides the value (pop globals, the inventory flag 0x583232, the selector);
 * the scene-change request the host was handed against the globals the original wrote.
Direct calls compare the saver 0x4eb70f with scene_restore_slot_save on random sources, and the method 0x4eb5f2 (no selector item)
with scene_restore_slot_pop on random records, including the empty record (marker 9999): the original carries on there (no fatal
path with the debug flag 0), the kernel reproduces it, and the native visit refuses it before any effect (a tagged expected
difference: the original would request scene 9999).

HOOKS (everything else is original code): O = observed, R = replaced, G = guarded.
  O 0x42950b arm entry (the row is the signed word at [ebp-0x11c]), 0x4eb5f2 method entry, 0x4e9e84 add entry (item, flag),
    0x4e0559 UI animation entry (this, three arguments; the real code runs on), 0x42ba3a completion, 0x423d33 dependency reset
  R 0x4e812f the view rebuild: the inventory at the call is logged and the call returns (it has its own oracles, RT-19/RT-22)
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7 0x4fb2e3: fatal, logging and sound paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: the scene loader 0x40b34a that allocates the body (the oracle builds the row in memory; the 4 corpus rows
are checked against the decoded scene resources separately), the view rebuild 0x4e812f, the effects of 0x4e0559 (UI cells, bar
object counter) and the main loop's consumer of 0x583232, the view scratch the add step uses (+0x822e/+0x8316/+0x828a), the
corpus rows' real dependency records (replayed without them and behind a stand-in event record, the gate is shared verified code).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_7d_runtime_original_oracle.py --mutations --result <receipt.json>
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM = 0x42950B
METHOD = 0x4EB5F2
SAVER = 0x4EB70F
ADD = 0x4E9E84
REBUILD = 0x4E812F
UI = 0x4E0559
SOUND = 0x4FB2E3
VIEW = 0x571442
BAR = 0x570508
SLOT_VA = 0x5C3A1B
SLOT_BYTES = 22
EMPTY = 0x270F
SELECTOR = 0x583F1D
HELD = 0x583A29
COUNT = 0x583A2B
LIST = 0x583A31
PRESENCE = 0x583BD5
CAP = 70
OPEN_FLAG = 0x583232
VIEW_SLOT_FLAG, VIEW_CLOSE_FLAG, VIEW_MODE = VIEW + 0x7010, VIEW + 0x7011, VIEW + 0x764C
# the running-scene globals the saver 0x4eb70f reads: (address, width)
SOURCES = ((0x5BB57B, 4), (0x5BB57F, 4), (0x5BB50B, 2), (0x5BB593, 2), (0x5BB5A7, 4), (0x5BB5AB, 4), (0x5BB5AF, 4))
# memory around the destinations, seeded with random bytes and compared byte for byte after every tick
WINDOWS = ((0x5BB500, 0x5BB5B3), (0x583960, 0x583D00), (0x583F10, 0x583F30), (0x5BB1C0, 0x5BB1E0), (0x5C39F0, 0x5C3A60),
           (0x583220, 0x583240), (0x578440, 0x578470), (0x578A80, 0x578AA0))
SKIP = ((SLOT_VA, SLOT_VA + SLOT_BYTES), (0x5C3A47, 0x5C3A4B))  # the slot is compared separately; the gate writes 0x5c3a47
# the globals the visit writes: (address, width, index into the native pop result)
POP_STORES = ((0x5BB57B, 4, 0), (0x5BB57F, 4, 1), (0x5BB599, 2, 2), (0x5BB595, 2, 3), (0x5C39FF, 2, 4), (0x5BB59B, 4, 5),
              (0x5BB59F, 4, 6), (0x5BB5A3, 4, 7), (0x5BB1CA, 4, 8), (0x583999, 4, 9))
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
MAX_ROWS = 60
TYPE = 0x7D
VIEW_MODES = ((0, 0), (2, 1), (2, 0), (0, 1), (3, 1), (2, 255), (1, 1), (2, 2))
GUARDS = list(d9.GUARDS) + [SOUND]

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x4e0559, 0x4e0619, '3588d6413d5da5a05d2f2b95f48f83c09d778652ca01c5c4d85d9345377831b1'),
    (0x4e812f, 0x4e8622, '99a57706af8058a563258127a1a24d08079729ea1f699bfeebb30cfaf182bfe0'),
    (0x4e9e84, 0x4ea06c, '2474b155759c56581a8aa3345ba306834fe612ce2eaaa47db2052e61f046e932'),
    (0x4eb5f2, 0x4eb70f, '7884369d3edbec9444c08ae9879e15a745b78dc3a7be42092dc77cf1a8df6ba1'),
    (0x4eb70f, 0x4eb77d, 'd86463bff0ef936e8280f6fe2915253b072e6b3f063733a8849a233d6c4e24f5'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)


class Mismatch(Exception):
    pass


def s16(value):
    return struct.unpack('<h', struct.pack('<H', value & 0xFFFF))[0]


def s_int(value, width):
    value &= (1 << (8 * width)) - 1
    return value - (1 << (8 * width)) if value >> (8 * width - 1) else value


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the raw 0x7d observers."""

    def __init__(self):
        super().__init__()
        self.pins = []
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))
        self.clear_logs()

    def clear_logs(self):
        self.entries, self.method_entries, self.adds, self.rebuilds, self.uis = [], [], [], [], []
        self.finish_entries, self.resets, self.order = [], [], []

    def _row_at_arm(self, uc):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        return struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0]

    def _install_hooks(self):
        uc = self.machine
        table = {ARM: self._arm, METHOD: self._method, ADD: self._add, REBUILD: self._rebuild, UI: self._ui,
                 0x423D33: self._reset_seen, 0x42BA3A: self._finish}
        for a in GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _arm(self, uc, address, size, user):
        self.entries.append(self._row_at_arm(uc))

    def _method(self, uc, address, size, user):
        self.method_entries.append(uc.reg_read(X.UC_X86_REG_ECX))

    def _add(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.adds.append((uc.reg_read(X.UC_X86_REG_ECX), u32(uc, sp + 4) & 0xFFFF, u32(uc, sp + 8)))

    def _rebuild(self, uc, address, size, user):
        self.rebuilds.append((uc.reg_read(X.UC_X86_REG_ECX), self.inventory_now()))
        self.order.append('R')
        self._ret(uc, 0)   # thiscall, no stack arguments: ret

    def _ui(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.uis.append((uc.reg_read(X.UC_X86_REG_ECX), u32(uc, sp + 4) & 0xFFFF, u32(uc, sp + 8), u32(uc, sp + 12) & 0xFFFF))
        self.order.append('U')

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    # -- state --------------------------------------------------------------------------------
    def inventory_now(self):
        """(selector, held, count, list words, presence dwords) as the original's memory holds them."""
        return (s16(struct.unpack('<H', self.rd(SELECTOR, 2))[0]), s16(struct.unpack('<H', self.rd(HELD, 2))[0]),
                s16(struct.unpack('<H', self.rd(COUNT, 2))[0]),
                struct.unpack('<%dH' % CAP, self.rd(LIST, 2 * CAP)), struct.unpack('<%di' % CAP, self.rd(PRESENCE, 4 * CAP)))

    def set_world(self, selector, held, count, items, presence, mode, slot_flag, close_flag):
        self.wr(SELECTOR, struct.pack('<h', selector))
        self.wr(HELD, struct.pack('<h', held))
        self.wr(COUNT, struct.pack('<h', count))
        self.wr(LIST, struct.pack('<%dH' % CAP, *items))
        self.wr(PRESENCE, struct.pack('<%di' % CAP, *presence))
        self.wr(VIEW_MODE, struct.pack('<i', mode))
        self.wr(VIEW_SLOT_FLAG, bytes([slot_flag]))
        self.wr(VIEW_CLOSE_FLAG, bytes([close_flag]))

    def view_bytes(self):
        return (struct.unpack('<i', self.rd(VIEW_MODE, 4))[0], self.rd(VIEW_SLOT_FLAG, 1)[0], self.rd(VIEW_CLOSE_FLAG, 1)[0])

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
        self.frees = []
        self.mode = 'idle'
        self.expect_fatal = None
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_logs()

    def set_sources(self, vals):
        for (addr, width), v in zip(SOURCES, vals):
            self.wr(addr, (v & ((1 << (8 * width)) - 1)).to_bytes(width, 'little'))

    def slot(self):
        return self.rd(SLOT_VA, SLOT_BYTES)

    def set_slot(self, data):
        self.wr(SLOT_VA, data)

    def window_bytes(self):
        return [self.rd(a, z - a) for a, z in WINDOWS]

    def seed_windows(self, rng):
        for a, z in WINDOWS:
            data = bytearray(rng.randrange(256) for _ in range(z - a))
            for lo, hi in SKIP:
                for k in range(max(lo, a), min(hi, z)):
                    data[k - a] = 0
            self.wr(a, bytes(data))

    def install_rows(self, rows, first=0):
        total = first + len(rows)
        if total > MAX_ROWS:
            raise d9.OracleError('too many rows for the oracle storage')
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            body_at = d9.BODY_BASE + 0x40 * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([TYPE, spec['subtype']]) + struct.pack('<I', body_at))
            tail = spec.get('tail') or b''
            storage = d9.TAIL_BASE + i * 0x80
            self.wr(storage, tail or bytes(16))
            _, ok = self.call(0x424AA8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
            if not ok:
                raise d9.OracleError('original dependency construction failed')
            self.wr(base + COMPLETE_OFF, b'\0')
            self.w32(base + PHASE_OFF, 0)
        self.wr(d9.G_ROWCOUNT, struct.pack('<h', total))

    def dispatch(self):
        self.clear_logs()
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'

    def direct(self, address, args):
        self.clear_logs()
        self.mode = 'step'
        try:
            self.call(address, args, VIEW)
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_7d_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('scene_stack.c', 'session_bindings_a7d.c', 'action_family_7d_runtime.c',
                                              'action_family_78_runtime.c', 'action_family_79_runtime.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A7D_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a7do_new.restype = C.c_void_p
        lib.a7do_free.argtypes = [C.c_void_p]
        lib.a7do_set_current.argtypes = [C.c_void_p, C.c_int32, C.c_int32, C.c_int, C.c_int, C.c_int32, C.c_int32, C.c_int32]
        lib.a7do_set_refuse.argtypes = [C.c_void_p, C.c_int]
        lib.a7do_applies.argtypes = [C.c_void_p]
        lib.a7do_applies.restype = C.c_int
        lib.a7do_opens.argtypes = [C.c_void_p]
        lib.a7do_opens.restype = C.c_int
        lib.a7do_get_slot.argtypes = [C.c_void_p, C.c_char_p]
        lib.a7do_set_slot.argtypes = [C.c_void_p, C.c_char_p]
        lib.a7do_set_world.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int, C.POINTER(C.c_uint16), C.POINTER(C.c_int32), C.c_int32,
                                       C.c_int, C.c_int]
        lib.a7do_get_world.argtypes = [C.c_void_p, C.POINTER(C.c_int16), C.POINTER(C.c_uint16), C.POINTER(C.c_int32)]
        lib.a7do_clear_events.argtypes = [C.c_void_p]
        lib.a7do_get_events.argtypes = [C.c_void_p, C.c_char_p]
        lib.a7do_get_snapshot.argtypes = [C.c_void_p, C.POINTER(C.c_int16), C.POINTER(C.c_uint16), C.POINTER(C.c_int32)]
        lib.a7do_rebuilds.argtypes = [C.c_void_p]
        lib.a7do_rebuilds.restype = C.c_int
        lib.a7do_ui_calls.argtypes = [C.c_void_p]
        lib.a7do_ui_calls.restype = C.c_int
        lib.a7do_get_ui.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a7do_get_pop.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a7do_get_request.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a7do_pop_direct.argtypes = [C.c_void_p, C.POINTER(C.c_int32)]
        lib.a7do_pop_direct.restype = C.c_int
        lib.a7do_save_direct.argtypes = [C.c_void_p, C.c_int32]
        lib.a7do_visit.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a7do_visit.restype = C.c_int
        self.h = lib.a7do_new()

    def close(self):
        self.lib.a7do_free(self.h)

    def set_sources(self, v):
        self.lib.a7do_set_current(self.h, s_int(v[0], 4), s_int(v[1], 4), s_int(v[2], 2), s_int(v[3], 2), s_int(v[4], 4),
                                  s_int(v[5], 4), s_int(v[6], 4))

    def slot(self):
        buf = C.create_string_buffer(SLOT_BYTES)
        self.lib.a7do_get_slot(self.h, buf)
        return buf.raw

    def set_slot(self, data):
        self.lib.a7do_set_slot(self.h, bytes(data))

    def set_world(self, selector, held, count, items, presence, mode, slot_flag, close_flag):
        self.lib.a7do_set_world(self.h, selector, held, count, (C.c_uint16 * CAP)(*items), (C.c_int32 * CAP)(*presence), mode,
                                slot_flag, close_flag)

    def world(self):
        words = (C.c_int16 * 3)()
        items = (C.c_uint16 * CAP)()
        presence = (C.c_int32 * CAP)()
        self.lib.a7do_get_world(self.h, words, items, presence)
        return (words[0], words[1], words[2], tuple(items), tuple(presence))

    def snapshot(self):
        words = (C.c_int16 * 3)()
        items = (C.c_uint16 * CAP)()
        presence = (C.c_int32 * CAP)()
        self.lib.a7do_get_snapshot(self.h, words, items, presence)
        return words[0], (None, words[2], words[1], tuple(items), tuple(presence))

    def events(self):
        buf = C.create_string_buffer(16)
        self.lib.a7do_get_events(self.h, buf)
        return buf.value.decode()

    def ui(self):
        out = (C.c_int32 * 3)()
        self.lib.a7do_get_ui(self.h, out)
        return list(out)

    def pop_result(self):
        out = (C.c_int32 * 10)()
        self.lib.a7do_get_pop(self.h, out)
        return list(out)

    def request(self):
        out = (C.c_int32 * 7)()
        self.lib.a7do_get_request(self.h, out)
        return list(out)

    def pop_direct(self):
        out = (C.c_int32 * 10)()
        rc = self.lib.a7do_pop_direct(self.h, out)
        return rc, list(out)

    def visit(self, subtype, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a7do_visit(self.h, subtype, completed, phase, C.byref(done), C.byref(reset), C.byref(new_phase),
                                     C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
INTERESTING = (0, 1, 2, 3, 4, 100, 255, 0x270F, 0x2710, 4700, 6400, 0x7FFF, 0x8000, 0xFFFF, 0x10000, 0x12345678, 0x7FFFFFFF,
               0x80000000, 0xFFFFFFFF, 0xFFFFFFFE)


def rand_sources(rng):
    def word():
        return rng.choice(INTERESTING) & 0xFFFF if rng.random() < 0.5 else rng.randrange(0x10000)

    def dword():
        return rng.choice(INTERESTING) if rng.random() < 0.5 else rng.randrange(1 << 32)
    return (dword(), dword(), word(), word(), dword(), dword(), dword())


def rand_slot(rng, empty=False):
    """A saved record. Unless `empty`, the marker word 0x5c3a1b is never 9999 (an empty record is a native refusal)."""
    data = bytearray(rng.randrange(256) for _ in range(SLOT_BYTES))
    if rng.random() < 0.3:  # exercise the type word 1 / small values
        data[8:10] = struct.pack('<h', rng.choice((0, 1, 1, 2, 3, -1, 0x101, 0x100, -0x7FFF)))
    if rng.random() < 0.1:  # words that share a byte with the empty marker
        data[0:2] = struct.pack('<H', rng.choice((0x000F, 0x260F, 0x2700, 0x270E, 0x2710, 0x0F27)))
    if rng.random() < 0.1:  # the scene word alone holding 9999 is not an empty record
        data[2:4] = struct.pack('<H', EMPTY)
    word = struct.unpack_from('<h', data, 0)[0]
    if empty:
        data[0:2] = struct.pack('<H', EMPTY)
    elif word == EMPTY:
        data[0:2] = struct.pack('<H', 0x270E)
    return bytes(data)


def rand_world(rng, selector=None, count=None, close=None, view=None):
    """(selector, held, count, items, presence, mode, slot_flag, close_flag) in the oracle's domain: list ids and the
    selector inside the presence array, room for one more entry."""
    n = rng.randrange(0, 66) if count is None else count
    ids = rng.sample(range(CAP), min(n, CAP)) if rng.random() < 0.8 else [rng.randrange(CAP) for _ in range(n)]
    items = [ids[i] if i < n else rng.randrange(0x10000) for i in range(CAP)]
    presence = [rng.choice((0, 1, 1, 2, -1, 0x7FFFFFFF, rng.randrange(-5, 5))) for _ in range(CAP)]
    if selector is None:
        pick = rng.random()
        if pick < 0.35:
            selector = -1
        elif pick < 0.55 and n:
            selector = items[rng.randrange(n)]           # a duplicate
        elif pick < 0.62:
            selector = rng.choice((0, CAP - 1))
        else:
            absent = [v for v in range(CAP) if v not in ids[:n]]
            selector = rng.choice(absent) if absent else -1
    mode, slot_flag = rng.choice(VIEW_MODES) if view is None else view
    held = rng.choice((-1, -1, 0, 5, rng.randrange(-3, CAP), rng.randrange(-32768, 32768)))
    return (selector, held, n, items, presence, mode, slot_flag, rng.choice((0, 1, 0xFF, 7, 0, 0)) if close is None else close)


def R(subtype=1, tail=b'', body=b'\0'):
    return dict(type=TYPE, body=body, subtype=subtype, tail=tail)


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def scenario_list(seed=41, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group,
                        sources=kw.pop('sources', (4700, 4701, 12, 3, 5, 6, 7)), slot=kw.pop('slot', None),
                        world=kw.pop('world', None), events=kw.pop('events', {}), mode=kw.pop('mode', 3),
                        quick=kw.pop('quick', False), first=kw.pop('first', 0), seed=kw.pop('seed', len(scs))))

    def refill(**kw):  # a fresh non-empty record and world, mode back to 3, the next tick visits the next row
        return [('slot', rand_slot(rng)), ('world', rand_world(rng, **kw)), ('mode', 3)]

    if corpus:
        chunk = corpus
        acts = []
        for _ in chunk:  # one visit per tick: each tick visits the first row still open
            acts += refill() + [('tick',)]
        S('corpus', [R(st, b'', body) for st, body in chunk], acts, group='corpus', quick=True)
        tails = [R(st, event_tail(1000 + k, 1), body) for k, (st, body) in enumerate(chunk)]
        acts = [('events', {1000 + k: 1 for k in range(0, len(chunk), 2)})]
        for _ in chunk:
            acts += refill() + [('tick',)]
        acts += [('events', {1000 + k: 1 for k in range(len(chunk))}), ('rearm',)]
        for _ in chunk:
            acts += refill() + [('tick',)]
        S('corpus_gated', tails, acts, group='corpus', quick=True)
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(subtype), R(subtype)],
          [('setphase', 0, 5), ('setphase', 1, 9)] + refill() + [('tick',)] + refill() + [('tick',), ('setphase', 0, 3), ('rearm',)] + refill() +
          [('tick',)], group='subtype', quick=subtype in (0, 1, 2))
    S('body:values', [R(1, event_tail(1003, 1) if v & 1 else b'', bytes([v])) for v in (0, 1, 2, 0x80, 0xFF)],
      [('events', {1003: 1})] + refill() + [('tick',)] + refill() + [('tick',)], group='body', quick=True)
    S('gate:event_false_then_true', [R(1, event_tail(40, 1)), R(1)], refill() + [('tick',), ('events', {40: 1})] + refill() +
      [('tick',)] + refill() + [('tick',)], group='gate', events={40: 7}, quick=True)
    S('gate:two_rows_one_tick', [R(1), R(1, event_tail(70, 1)), R(0)], refill() + [('tick',), ('events', {70: 1}), ('rearm',)] + refill() +
      [('tick',)], group='gate', quick=True)
    S('gate:mode4_runs_nothing', [R(1), R(1)], [('slot', rand_slot(rng)), ('world', rand_world(rng)), ('tick',)] + refill() + [('tick',)],
      group='gate', mode=4, quick=True)
    S('pass:stops_after_the_visit', [R(1), R(1), R(1)], refill() + [('tick',)] + refill() + [('tick',)] + refill() + [('tick',)],
      group='pass', quick=True)
    S('rows:offset_first_row', [R(1), R(1)], refill() + [('tick',)] + refill() + [('tick',)], group='rows', first=3, quick=True)
    # the selector item
    for name, want, count in (('none', -1, 5), ('item_zero', 0, 5), ('last_id', CAP - 1, 5), ('absent', 33, 5), ('empty_list', 12, 0),
                              ('last_slot_free', 12, 68), ('duplicate_first', None, 5), ('duplicate_last', None, 6)):
        for view in ((0, 0), (2, 1), (2, 0)):
            w = rand_world(rng, selector=-1, count=count, view=view, close=0)
            items = list(w[3])
            selector = want
            if want is None:
                selector = items[0] if name == 'duplicate_first' else items[count - 1]
            elif want != -1 and want in items[:count]:
                items[0] = 99     # a list word outside the presence array: the add step never indexes it
            w = (selector,) + w[1:3] + (items,) + w[4:]
            S('item:%s:%d:%d' % (name, view[0], view[1]), [R(1)], [('slot', rand_slot(rng)), ('world', w), ('tick',)], group='item',
              quick=name in ('absent', 'duplicate_first') and view == (2, 1))
    for close in (0, 1, 2, 0x80, 0xFF):
        S('close:%d' % close, [R(1)], [('slot', rand_slot(rng)), ('world', rand_world(rng, close=close, selector=7 if close % 2 else -1)), ('tick',)],
          group='close', quick=close in (0, 1, 2, 0x80))
    for k, (name, slot) in enumerate((
            ('init_values', struct.pack('<hhhhh', EMPTY, EMPTY, 0, 0, 2) + bytes(12)),
            ('zero_record', bytes(SLOT_BYTES)),
            ('scene_word_only_9999', struct.pack('<hh', 4700, EMPTY) + bytes(18)),
            ('type_word_1', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 1) + bytes(12)),
            ('type_word_2', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 2) + bytes(12)),
            ('type_word_0x101', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 0x101) + bytes(12)),
            ('type_word_0x100', struct.pack('<hh', 4700, 4710) + struct.pack('<hhh', 5, 6, 0x100) + bytes(12)),
            ('marker_shares_the_low_byte', struct.pack('<hh', 0x000F, 4710) + bytes(18)),
            ('marker_shares_the_high_byte', struct.pack('<hh', 0x2700, 4710) + bytes(18)),
            ('scene_negative', struct.pack('<hh', 4700, -2) + bytes(18)))):
        # an empty record is a native refusal: the initializer's record keeps its marker and is checked as such
        S('slot:' + name, [R(1)], [('world', rand_world(rng, selector=-1)), ('tick',)], group='slot', slot=slot,
          quick=name in ('init_values', 'type_word_1', 'scene_word_only_9999', 'type_word_0x101', 'marker_shares_the_low_byte'))
    S('roundtrip:save_then_restore', [R(1)], [('save', (4700, 4701, 12, 3, 5, 6, 7), 1), ('world', rand_world(rng, selector=9, count=4)), ('tick',),
                                             ('sources', (6400, 6401, 1, 2, 3, 4, 5)), ('save', (6400, 6401, 1, 2, 3, 4, 5), 2),
                                             ('world', rand_world(rng, selector=-1)), ('mode', 3), ('rearm',), ('tick',)],
      group='roundtrip', slot=bytes(SLOT_BYTES), quick=True)
    S('empty:after_init', [R(1)], [('world', rand_world(rng, selector=-1)), ('tick',)], group='empty',
      slot=struct.pack('<hhhhh', EMPTY, EMPTY, 0, 0, 2) + bytes(12), quick=True)
    S('empty:random_tail', [R(1)], [('slot', rand_slot(rng, empty=True)), ('world', rand_world(rng, selector=-1)), ('tick',)], group='empty')
    S('empty:after_a_visit', [R(1), R(1)], refill() + [('tick',), ('mode', 3), ('world', rand_world(rng, selector=-1)), ('tick',)], group='empty')
    for n in range(400):
        rows = []
        for _ in range(rng.randint(1, 30)):
            rows.append(R(rng.choice((0, 1, 1, 1, 2, 3)), event_tail(rng.randrange(1600), rng.randrange(-3, 4)) if rng.random() < 0.3 else b''))
        acts = []
        for _ in range(rng.randint(2, 6)):
            empty = rng.random() < 0.08
            acts += [('sources', rand_sources(rng)), ('slot', rand_slot(rng, empty=empty)),
                     ('world', rand_world(rng, selector=-1 if empty else None)), ('mode', 3), ('tick',)]
            if rng.random() < 0.5:
                acts.append(('events', {r['tail'] and struct.unpack_from('<h', r['tail'], 2)[0] or 0: rng.randrange(-3, 4) for r in rows[:6]}))
            if rng.random() < 0.5:
                acts.append(('rearm',))
        S('random:%d' % n, rows, acts, group='random', sources=rand_sources(rng), quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw-0x7d rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_7d_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('scene_stack.c', 'session_bindings_a7d.c', 'action_family_7d_runtime.c',
                                                                    'action_family_78_runtime.c', 'action_family_79_runtime.c', 'action_core.c',
                                                                    'scene_resource.c', 'hiff.c')], '-lm', '-o', str(exe)],
                               capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', *map(str, sorted(resources.glob('*.bin')))], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        st, _, hexbody = line.partition(' ')
        rows.append((int(st), bytes.fromhex(hexbody)))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_visited=0, rows_gated=0, completions=0, slot_compares=0, window_compares=0, world_compares=0,
                request_compares=0, visits=0, adds=0, readds=0, duplicates=0, rebuild_compares=0, ui_compares=0, inventory_opens=0,
                empty_refusals=0, direct_saves=0, direct_pops=0, direct_empty=0, mismatches=0, gate_model_checks=0, by_view=Counter(),
                by_subtype=Counter(), groups={})


def row_gate_open(spec, flag_of):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return flag_of(rec[1]) == rec[2]


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += stats['rows_visited'] - before[1]
        g['seconds'] += round(time.monotonic() - t0, 2)


def apply_world(x, nat, state, world):
    state['world'] = world
    x.set_world(*world)
    nat.set_world(*world)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    x.seed_windows(random.Random(sc['seed'] * 7919 + 1))
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    state = dict(mode=sc['mode'], sources=tuple(sc['sources']), stop=False, world=None)
    x.set_sources(state['sources'])
    nat.set_sources(state['sources'])
    slot = sc['slot'] if sc['slot'] is not None else bytes(SLOT_BYTES)
    x.set_slot(slot)
    nat.set_slot(slot)
    world = sc['world'] or (-1, -1, 0, [0] * CAP, [0] * CAP, 0, 0, 1)
    apply_world(x, nat, state, world)
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    compare_state(sc['id'] + ' initial', x, nat, state, stats)
    for ai, act in enumerate(sc['actions']):
        if state['stop']:
            break  # a native refusal (the empty record): the original went on, the native side did not
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, rows, first, state, completed, phases, stats)
        elif kind == 'sources':
            state['sources'] = tuple(act[1])
            x.set_sources(act[1])
            nat.set_sources(act[1])
        elif kind == 'slot':
            x.set_slot(act[1])
            nat.set_slot(act[1])
        elif kind == 'world':
            apply_world(x, nat, state, act[1])
        elif kind == 'save':
            # the real saver 0x4eb70f against scene_restore_slot_save, on the running-scene globals of this action
            x.set_sources(act[1])
            nat.set_sources(act[1])
            state['sources'] = tuple(act[1])
            x.direct(SAVER, [act[2]])
            nat.lib.a7do_save_direct(nat.h, act[2])
            stats['direct_saves'] += 1
            compare_state(where, x, nat, state, stats)
        elif kind == 'rearm':
            for i in range(first, first + len(rows)):
                completed[i] = 0
                phases[i] = 0
                x.wr(ROWS + i * ROW + COMPLETE_OFF, b'\0')
                x.w32(ROWS + i * ROW + PHASE_OFF, 0)
        elif kind == 'setphase':
            x.w32(ROWS + (first + act[1]) * ROW + PHASE_OFF, act[2])
            phases[first + act[1]] = act[2]
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
        elif kind == 'mode':
            state['mode'] = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', act[1]))
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def slot_is_empty(slot):
    return struct.unpack_from('<h', slot, 0)[0] == EMPTY


def patch_window(patched, addr, width, value):
    for wi, (a, z) in enumerate(WINDOWS):
        if a <= addr and addr + width <= z:
            patched[wi][addr - a:addr - a + width] = (value & ((1 << (8 * width)) - 1)).to_bytes(width, 'little')


def compare_windows(where, x, pre, patched, stats, extra_skip=()):
    now = x.window_bytes()
    stats['window_compares'] += 1
    for wi, (a, z) in enumerate(WINDOWS):
        for off in range(z - a):
            va = a + off
            if any(lo <= va < hi for lo, hi in SKIP + tuple(extra_skip)):
                continue
            if patched[wi][off] != now[wi][off]:
                raise Mismatch('%s: byte %#x original %02x expected %02x (window %#x..%#x)' % (where, va, now[wi][off], patched[wi][off], a, z))


def tick(where, x, nat, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(d9.EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    pre = x.window_bytes()
    pre_slot = x.slot()
    pre_world = x.inventory_now()
    if pre_world != nat.world():
        raise Mismatch('%s: the worlds differ before the tick: original %s native %s' % (where, pre_world[:3], nat.world()[:3]))
    # --- the model: which row runs, until the visit (mode 4) ---
    plan = None
    if state['mode'] == 3:
        for i in range(first, total):
            if completed[i]:
                continue
            if row_gate_open(rows[i - first], flags):
                plan = i
                break
    x.dispatch()
    if x.finish_entries or x.resets:
        raise Mismatch('%s: the generic completion %s or a dependency reset %s ran for a 0x7d row' % (where, x.finish_entries, x.resets))
    # the arm label 0x42950b precedes the gate: every open row up to the first true gate (mode 3 only) enters it
    exp_entries = []
    if state['mode'] == 3:
        last = plan if plan is not None else total - 1
        exp_entries = [i for i in range(first, last + 1) if not completed[i]]
    exp_methods = [] if plan is None else [VIEW]
    if x.entries != exp_entries or x.method_entries != exp_methods:
        raise Mismatch('%s: original arm entries %s method entries %s, the model expects %s and %s' %
                       (where, x.entries, x.method_entries, exp_entries, exp_methods))
    stats['gate_model_checks'] += 1
    stats['rows_gated'] += sum(1 for i in range(first, total) if not completed[i]) if state['mode'] == 3 else 0
    visited = []
    patched = [bytearray(w) for w in pre]
    if plan is not None:
        i = plan
        spec = rows[i - first]
        empty = slot_is_empty(pre_slot)
        nat.lib.a7do_clear_events(nat.h)
        applies = nat.lib.a7do_applies(nat.h)
        close = state['world'][7]
        if empty:
            # tagged expected difference: the original carries on with the empty record's values and requests scene 9999; the native
            # visit is refused before any effect. The kernel pop reproduces the original's globals and record.
            if pre_world[0] != -1:
                raise Mismatch('%s: the oracle only plans an empty record without a selector item' % where)
            status, done, reset, phase, disposition = nat.visit(spec['subtype'], completed[i], phases[i])
            if status != 2 or nat.slot() != pre_slot or nat.world() != pre_world or nat.lib.a7do_applies(nat.h) != applies or nat.events():
                raise Mismatch('%s: native visit of an empty record: status %d (want ERROR 2) or state changed' % (where, status))
            rc, res = nat.pop_direct()
            if rc != 1:
                raise Mismatch('%s: scene_restore_slot_pop returned %d for an empty record' % (where, rc))
            stats['empty_refusals'] += 1
            popped = res
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            if o_done != 1:
                raise Mismatch('%s: the original did not complete the row of the empty record' % where)
            state['stop'] = True
            visited_ok = False
        else:
            status, done, reset, phase, disposition = nat.visit(spec['subtype'], completed[i], phases[i])
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            completed[i], phases[i] = done, phase
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (done, phase) != (o_done, o_phase) or reset != 0:
                raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d, no reset)' %
                               (where, i, done, phase, reset, o_done, o_phase))
            visited.append(i)
            visited_ok = True
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['visits'] += 1
            stats['by_subtype'][spec['subtype']] += 1
            popped = nat.pop_result()
            # --- the inventory path: add calls, rebuild, UI request, in order ---
            selector = pre_world[0]
            events = nat.events()
            adds_expected = [(VIEW, selector & 0xFFFF, 0)] if selector != -1 else []
            if x.adds != adds_expected:
                raise Mismatch('%s: original add calls %s, expected %s' % (where, x.adds, adds_expected))
            stats['adds'] += len(x.adds)
            want_ui = [(BAR, 1, 0, 0)] if selector != -1 else []
            if x.uis != want_ui:
                raise Mismatch('%s: original UI animation calls %s, expected %s' % (where, x.uis, want_ui))
            native_ui = nat.ui() if nat.lib.a7do_ui_calls(nat.h) else None
            if (native_ui is not None) != bool(want_ui) or (native_ui is not None and native_ui != [1, 0, 0]):
                raise Mismatch('%s: native UI request %s, original %s' % (where, native_ui, x.uis))
            stats['ui_compares'] += len(want_ui)
            # the rebuild calls (order and the inventory at the call) against the native host's
            n_rebuilds = nat.lib.a7do_rebuilds(nat.h)
            if n_rebuilds != len(x.rebuilds):
                raise Mismatch('%s: original rebuilds %d native %d' % (where, len(x.rebuilds), n_rebuilds))
            if n_rebuilds:
                _, snap = nat.snapshot()
                if x.rebuilds[0][0] != VIEW or x.rebuilds[0][1][1:] != snap[1:]:
                    o = x.rebuilds[0][1]
                    diff = [('list', k, o[3][k], snap[3][k]) for k in range(CAP) if o[3][k] != snap[3][k]][:4] + \
                           [('presence', k, o[4][k], snap[4][k]) for k in range(CAP) if o[4][k] != snap[4][k]][:4]
                    raise Mismatch('%s: the inventory at the rebuild differs: original %s native %s; first differences %s' %
                                   (where, o[1:3], snap[1:3], diff))
                stats['rebuild_compares'] += 1
                stats['readds'] += 1
            elif selector != -1:
                stats['duplicates'] += 1
            exp_events = ('R' if n_rebuilds else '') + ('U' if want_ui else '') + 'C' + ('O' if close == 0 else '')
            if events != exp_events or ''.join(x.order) != ('R' if n_rebuilds else '') + ('U' if want_ui else ''):
                raise Mismatch('%s: native call order %r (want %r), original rebuild/UI order %r' % (where, events, exp_events, ''.join(x.order)))
            if close == 0:
                stats['inventory_opens'] += 1
        # --- the globals: the pre-tick window bytes patched with the native result must equal the original's ---
        for addr, width, k in POP_STORES:
            patch_window(patched, addr, width, popped[k])
        if visited_ok:
            patch_window(patched, SELECTOR, 2, 0xFFFF)
            if close == 0:
                patch_window(patched, OPEN_FLAG, 1, 1)
            w = nat.world()
            patch_window(patched, COUNT, 2, w[2] & 0xFFFF)
            for k in range(CAP):
                patch_window(patched, LIST + 2 * k, 2, w[3][k])
                patch_window(patched, PRESENCE + 4 * k, 4, w[4][k])
            state['sources'] = (popped[0] & 0xFFFFFFFF, popped[1] & 0xFFFFFFFF) + tuple(state['sources'][2:])
            nat.set_sources(state['sources'])
            state['mode'] = popped[9]
            req = nat.request()
            want = [s_int(popped[0], 2), popped[2], popped[3], popped[4], popped[5], popped[6], popped[7]]
            if req != want:
                raise Mismatch('%s: scene-change request %s does not match the pop result %s' % (where, req, want))
            stats['request_compares'] += 1
        else:
            # the original also writes the selector -1 and the flag; for the empty record the selector was -1 and the flag follows the byte
            patch_window(patched, SELECTOR, 2, 0xFFFF)
            if close == 0:
                patch_window(patched, OPEN_FLAG, 1, 1)
            state['sources'] = (popped[0] & 0xFFFFFFFF, popped[1] & 0xFFFFFFFF) + tuple(state['sources'][2:])
    for i in range(first, total):
        if i not in visited and not (plan is not None and not visited and i == plan):
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    compare_windows(where, x, pre, patched, stats)
    compare_state(where, x, nat, state, stats)


def compare_state(where, x, nat, state, stats):
    stats['slot_compares'] += 1
    if x.slot() != nat.slot():
        raise Mismatch('%s: saved scene record differs: original %s native %s' % (where, x.slot().hex(), nat.slot().hex()))
    stats['world_compares'] += 1
    orig = x.inventory_now()
    if orig != nat.world():
        raise Mismatch('%s: inventory/selector differ: original %s native %s' % (where, orig[:3], nat.world()[:3]))
    stats['by_view'][x.view_bytes()] += 1
    expected = tuple(int(v) & ((1 << (8 * w)) - 1) for v, (_, w) in zip(state['sources'], SOURCES))
    got = tuple(int.from_bytes(x.rd(addr, width), 'little') for addr, width in SOURCES)
    if got != expected:
        raise Mismatch('%s: the original\'s running-scene globals %s differ from the model %s' % (where, got, expected))


def run_direct(x, nat, stats, count=240, seed=4100):
    """The saver 0x4eb70f and the method 0x4eb5f2 (no selector item) called directly on random records and sources."""
    rng = random.Random(seed)
    for n in range(count):
        x.hard_reset()
        x.seed_windows(random.Random(seed + n))
        srcs = rand_sources(rng)
        arg = rng.choice((0, 1, 2, 3, -1, 0x10001, 0x7FFFFFFF, rng.randrange(1 << 32))) & 0xFFFFFFFF
        slot0 = rand_slot(rng)
        x.set_sources(srcs)
        nat.set_sources(srcs)
        x.set_slot(slot0)
        nat.set_slot(slot0)
        pre = x.window_bytes()
        x.direct(SAVER, [arg])
        nat.lib.a7do_save_direct(nat.h, s_int(arg, 4))
        if x.slot() != nat.slot():
            raise Mismatch('direct save %d: record original %s native %s' % (n, x.slot().hex(), nat.slot().hex()))
        compare_windows('direct save %d' % n, x, pre, [bytearray(w) for w in pre], stats)
        stats['direct_saves'] += 1
        stats['slot_compares'] += 1
        # the pop on a random record (a third of them empty), with the selector holding no item
        empty = n % 3 == 2
        slot = rand_slot(rng, empty=empty)
        close = rng.choice((0, 1, 0xFF, 5))
        world = rand_world(rng, selector=-1, close=close)
        x.set_slot(slot)
        nat.set_slot(slot)
        x.set_world(*world)
        nat.set_world(*world)
        pre = x.window_bytes()
        x.direct(METHOD, [])
        rc, res = nat.pop_direct()
        if rc != (1 if empty else 0) or len(x.method_entries) != 1:
            raise Mismatch('direct pop %d: native rc %d, original method entries %d' % (n, rc, len(x.method_entries)))
        patched = [bytearray(w) for w in pre]
        for addr, width, k in POP_STORES:
            patch_window(patched, addr, width, res[k])
        if close == 0:
            patch_window(patched, OPEN_FLAG, 1, 1)
        compare_windows('direct pop %d' % n, x, pre, patched, stats)
        if x.slot() != nat.slot():
            raise Mismatch('direct pop %d: record original %s native %s' % (n, x.slot().hex(), nat.slot().hex()))
        stats['direct_pops'] += 1
        stats['direct_empty'] += 1 if empty else 0
        stats['slot_compares'] += 1


def run_refusals(nat, stats):
    """Native-only refusals the original has no counterpart for (it would read or write outside its arrays): ERROR, nothing changes."""
    rng = random.Random(77)
    full = rand_world(rng, selector=33, count=70, view=(0, 0), close=0)
    full = full[:3] + ([i if i != 33 else 34 for i in range(CAP)],) + full[4:]
    cases = {
        'full list, new item': full,
        'selector below -1': rand_world(rng, selector=-2, count=5, view=(0, 0), close=0),
        'selector past the presence array': rand_world(rng, selector=CAP, count=5, view=(0, 0), close=0),
    }
    for name, world in cases.items():
        nat.set_slot(rand_slot(rng))
        nat.set_world(*world)
        before = (nat.slot(), nat.world())
        nat.lib.a7do_clear_events(nat.h)
        applies = nat.lib.a7do_applies(nat.h)
        status = nat.visit(1, 0, 0)[0]
        if status != 2:
            raise Mismatch('refusal %s: native status %d, want ERROR' % (name, status))
        if (nat.slot(), nat.world()) != before or nat.events() or nat.lib.a7do_applies(nat.h) != applies:
            raise Mismatch('refusal %s: state changed' % name)
        stats['native_refusals'] = stats.get('native_refusals', 0) + 1


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


# native mutants: each must be caught by the quick scenario set
MUTANTS = {
    'scene taken from the marker word': ('r.scene_5bb57b = slot->scene_5c3a1d;                        /* 0x4eb629',
                                         'r.scene_5bb57b = slot->marker_5c3a1b;                        /* 0x4eb629', 'action_family_7d_runtime.c'),
    'second scene global from the marker word': ('r.scene_5bb57f = slot->scene_5c3a1d;', 'r.scene_5bb57f = slot->marker_5c3a1b;',
                                                 'action_family_7d_runtime.c'),
    'scene word zero extended': ('r.scene_5bb57b = slot->scene_5c3a1d;', 'r.scene_5bb57b = (uint16_t)slot->scene_5c3a1d;',
                                 'action_family_7d_runtime.c'),
    'words 599 and 595 swapped': ('r.word_5bb599 = slot->word_5c3a1f;', 'r.word_5bb599 = slot->word_5c3a21;', 'action_family_7d_runtime.c'),
    'word 595 taken from 1f': ('r.word_5bb595 = slot->word_5c3a21;', 'r.word_5bb595 = slot->word_5c3a1f;', 'action_family_7d_runtime.c'),
    'dword 59b taken from 29': ('r.dword_5bb59b = slot->dword_5c3a25;', 'r.dword_5bb59b = slot->dword_5c3a29;', 'action_family_7d_runtime.c'),
    'dword 59f taken from 25': ('r.dword_5bb59f = slot->dword_5c3a29;', 'r.dword_5bb59f = slot->dword_5c3a25;', 'action_family_7d_runtime.c'),
    'dword 5a3 not read': ('r.dword_5bb5a3 = slot->dword_5c3a2d;', 'r.dword_5bb5a3 = 0;', 'action_family_7d_runtime.c'),
    'flag 5c39ff zero': ('r.word_5c39ff = 1;', 'r.word_5c39ff = 0;', 'action_family_7d_runtime.c'),
    'start flag inverted': ('slot->word_5c3a23 == 1 ? 0 : 1', 'slot->word_5c3a23 == 1 ? 1 : 0', 'action_family_7d_runtime.c'),
    'start flag for type words up to 1': ('slot->word_5c3a23 == 1 ? 0 : 1', 'slot->word_5c3a23 <= 1 ? 0 : 1', 'action_family_7d_runtime.c'),
    'start flag tests the low byte': ('slot->word_5c3a23 == 1 ? 0 : 1', '(slot->word_5c3a23 & 0xff) == 1 ? 0 : 1', 'action_family_7d_runtime.c'),
    'mode 3': ('r.mode_583999 = 4;', 'r.mode_583999 = 3;', 'action_family_7d_runtime.c'),
    'record marker kept': ('    slot->marker_5c3a1b = SCENE_RESTORE_EMPTY_MARKER;           /* 0x4eb6e3 */\n', '', 'action_family_7d_runtime.c'),
    'record scene word kept': ('    slot->scene_5c3a1d = SCENE_RESTORE_EMPTY_MARKER;            /* 0x4eb6ec */\n', '', 'action_family_7d_runtime.c'),
    'record emptied with zero': ('slot->marker_5c3a1b = SCENE_RESTORE_EMPTY_MARKER;           /* 0x4eb6e3 */', 'slot->marker_5c3a1b = 0;',
                                 'action_family_7d_runtime.c'),
    'dwords cleared by the pop': ('slot->scene_5c3a1d = SCENE_RESTORE_EMPTY_MARKER;            /* 0x4eb6ec */',
                                  'slot->scene_5c3a1d = SCENE_RESTORE_EMPTY_MARKER; slot->dword_5c3a2d = 0;', 'action_family_7d_runtime.c'),
    'empty test on the scene word': ('if (slot->marker_5c3a1b == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9',
                                     'if (slot->scene_5c3a1d == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9', 'action_family_7d_runtime.c'),
    'empty test on the low byte': ('if (slot->marker_5c3a1b == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9',
                                   'if ((slot->marker_5c3a1b & 0xff) == (SCENE_RESTORE_EMPTY_MARKER & 0xff)) {   /* 0x4eb5f9', 'action_family_7d_runtime.c'),
    'saver keeps the first dword store': ('    slot->dword_5c3a29 = current->dword_5bb5af;             /* 0x4eb76b..0x4eb771 overwrites the line above */\n', '',
                                          'action_family_7d_runtime.c'),
    'saver writes the third dword': ('slot->dword_5c3a29 = current->dword_5bb5af;', 'slot->dword_5c3a2d = current->dword_5bb5af;',
                                     'action_family_7d_runtime.c'),
    'saver type word dropped': ('slot->word_5c3a23 = (int16_t)type_argument;', 'slot->word_5c3a23 = (int16_t)(type_argument & 0);', 'action_family_7d_runtime.c'),
    'selector tested against zero': ('taken = item != -1;', 'taken = item != 0;', 'action_family_7d_runtime.c'),
    'item added with flag 1': ('action78_add_item(item, 0, &model->inventory', 'action78_add_item(item, 1, &model->inventory', 'action_family_7d_runtime.c'),
    'UI request skipped': ('if (host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {',
                           'if (0) {', 'action_family_7d_runtime.c'),
    'UI request enable 1': ('request_ui_animation(host->inventory.context, 1, 0, 0)', 'request_ui_animation(host->inventory.context, 1, 1, 0)',
                            'action_family_7d_runtime.c'),
    'UI request index 0': ('request_ui_animation(host->inventory.context, 1, 0, 0)', 'request_ui_animation(host->inventory.context, 0, 0, 0)',
                           'action_family_7d_runtime.c'),
    'UI request only for a new item': ('if (host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {',
                                       'if (result->readded && host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {',
                                       'action_family_7d_runtime.c'),
    'inventory flag always': ('open_inventory = *model->view_close_flag == 0u;', 'open_inventory = 1;', 'action_family_7d_runtime.c'),
    'inventory flag inverted': ('open_inventory = *model->view_close_flag == 0u;', 'open_inventory = *model->view_close_flag != 0u;',
                                'action_family_7d_runtime.c'),
    'inventory flag tests the low bit': ('open_inventory = *model->view_close_flag == 0u;', 'open_inventory = (*model->view_close_flag & 1u) == 0u;',
                                         'action_family_7d_runtime.c'),
    'selector kept': ('    *model->held_selector = -1;                          /* 0x429539 */\n', '', 'action_family_7d_runtime.c'),
    'selector cleared early': ('    item = *model->held_selector;', '    item = *model->held_selector; *model->held_selector = -1;', 'action_family_7d_runtime.c'),
    'record cleared before the host answers': ('    popped = *model->slot;', '    popped = *model->slot; *model->slot = popped; (void)scene_restore_slot_pop(model->slot, &pop);',
                                               'action_family_7d_runtime.c'),
    'phase cleared': ('out->phase = before->phase;', 'out->phase = 0u;', 'session_bindings_a7d.c'),
    'generic completion used': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;',
                                'session_bindings_a7d.c'),
    'row left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;',
                         'session_bindings_a7d.c'),
    'subtype 2 resets': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                         'out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                         'session_bindings_a7d.c'),
    'request target from the wrong scene': ('request.target_scene = (int16_t)pop->scene_5bb57b;', 'request.target_scene = (int16_t)(pop->scene_5bb57b + 1);',
                                            'session_bindings_a7d.c'),
    'request dword 1 dropped': ('request.opaque_dwords[1] = pop->dword_5bb59f;', 'request.opaque_dwords[1] = pop->dword_5bb59b;', 'session_bindings_a7d.c'),
    'empty record accepted': ('        *failure = "the second saved-scene record is empty (nothing was saved by the examine branch 0x4ea269)";\n        return ACTION7D_ERR_EMPTY;',
                              '        *failure = "x";', 'action_family_7d_runtime.c'),
}


def mutation_check(args, workdir):
    report = []
    for name, (old, new, filename) in MUTANTS.items():
        source = (args.src / filename).read_text()
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, how='mutation anchor drifted'))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / filename).write_text(source.replace(old, new))
        try:
            lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))
        except d9.OracleError as error:
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
    work = Path(tempfile.mkdtemp(prefix='RT-41.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver7d.so')
    nat = Native(lib_path)
    x = Oracle()
    corpus = load_corpus()
    scs = scenario_list(corpus=corpus)
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    if args.quick_only or args.mutation_run:
        scs = [s for s in scs if s['quick']]
    blocks = set()
    if args.discover_pins:
        x.machine.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: blocks.add((a, sz)), begin=0x401000, end=0x52A000)
    stats = new_stats()
    bad = run_list(x, nat, scs, stats, fail_fast=args.fail_fast or args.mutation_run)
    if not bad and not args.only:
        try:
            run_direct(x, nat, stats, count=24 if (args.quick_only or args.mutation_run) else 240)
            run_refusals(nat, stats)
        except (Mismatch, d9.OracleError) as error:
            bad.append(('direct', str(error)))
            stats['mismatches'] += 1
    if args.mutation_run:
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
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
    summary = {k: (({str(kk): vv for kk, vv in v.items()}) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]
        args.result.write_text(json.dumps(dict(slice='RT-41', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
