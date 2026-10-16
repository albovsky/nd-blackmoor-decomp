#!/usr/bin/env python3
"""RT-32: immutable x86 dispatcher 0x427a50 (arm 0x429747, handler 0x4c36b2) versus the native raw-0x94 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x94 the REAL dispatcher 0x427a50 runs:
dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0), the arm (0x429747: gate, then the handler
0x4c36b2 with ECX = the CDirectDraw object 0x5cf659) and the handler's three phases: 0 (flag 0x5839a9 := 1, the redraw
request 0x4d36ed, phase := 2), 2 (the front-buffer lock 0x4c4067 and unlock 0x4c4202, the row copy 0x43f04b, the crop,
the 24-bit BMP writer 0x4c334f or the inline TGA writer, the 5-5-5 conversion 0x4c7481, _makepath 0x50cd72, flag := 0,
phase := 3) and 3 (the generic completion 0x42ba3a). All of it is original x86; the display is the original's own memory
back-buffer mode (CDirectDraw+8 == CDirectDraw+0xc), so the lock and unlock run unmodified.

Native side: src/session_bindings_a94.c with src/action_family_94_runtime.c, driven by
tests/action_family_94_runtime_oracle_driver.c with the executor's disposition mapping.

Compared after every dispatcher call (tick): which rows ran the handler (observed 0x4c36b2) against the open-row and gate
model, the completion byte and phase of every row, the ordered effects (stores to 0x5839a9, entries of 0x4d36ed, every
file the CRT was asked to open: path, mode, the concatenated fwrite bytes, with the BMP row padding bytes masked because
the original leaves them as uninitialised heap) against the native host callbacks.

HOOKS (everything else is original code): O = observed, R = replaced.
  O 0x429747 arm entry, 0x4c36b2 handler entry, 0x4d36ed redraw request, 0x42ba3a completion helper, 0x423d33 dependency
    reset, memory stores to 0x5839a9: entry observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap, zero or 0xCD filled), 0x51dc6c free (no-op, counted)
  R 0x50d0a9 fopen, 0x50e493 fwrite, 0x50cee4 fclose: the file boundary (path and mode strings read, data recorded)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

Not modelled / unverified: allocation failure inside the handler (0x4c37d1/0x4c3863, 0x4c334f), the DirectDraw COM lock path
(the oracle takes the memory back-buffer branch of 0x4c4067), a name without a NUL inside its 33 bytes (the original reads on
into the next body fields), rectangles outside the native domain (native refuses), 32-bit displays, and the scene loader
0x40b34a (the oracle builds the row in memory).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_94_runtime_original_oracle.py --mutations --result <receipt.json>
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

from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import action_family_d9_runtime_original_oracle as d9
import action_family_67_runtime_original_oracle as a67
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM_ENTRY = 0x429747
HANDLER = 0x4C36B2
REFRESH = 0x4D36ED
FLAG_VA = 0x5839A9
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
MAX_ROWS = 90
DD = 0x5CF659            # the CDirectDraw object
G_WIDTH, G_HEIGHT, G_BPP, G_BITS = 0x63988B, 0x63988D, 0x639895, 0x639893
G_DRIVE, G_DIR = 0x639A9F, 0x639AA2
FRAME = 0x58000000
FRAME_SIZE = 0x400000
FILE_BASE = 0x7D000000

PINS_TABLE = (
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423d33, 0x423da2, 'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x42ba3a, 0x42babf, '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x43f04b, 0x43f0a3, 'e005ddcc9f3e34a119142937bb379f199dae47b29b705fa05e05e753a2001a39'),
    (0x4c334f, 0x4c36b2, 'd127991781bff33e16f77c2761e0258814b6a509bc390a71ada60aa7124791ff'),
    (0x4c36b2, 0x4c3c5d, '3be3810a997ed70ad255cbc074570cf923de2644215f7569375f44d51619cdf1'),
    (0x4c4067, 0x4c4202, 'c3d39e5d72ef0f3d77a8eeac83b406cebd9049de3eec1ea559386293f0651df1'),
    (0x4c4202, 0x4c425e, '4759b7f595ea50378bb6643c9c222b560fece4f7b9c28c25fef32bd4a677007f'),
    (0x4c7481, 0x4c7623, 'c9fafe526715e93f5de672a4340002a5cffbff9e1473ba5de1ae462277a8673d'),
    (0x4d36ed, 0x4d3705, '9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd'),
    (0x50cd72, 0x50ce04, 'ae6f88ecc30d1b283ff1d35a00a365dae2c0b41a77a24d116bee97fc5753e294'),
    (0x50cee4, 0x50cf15, '74b05488da3454a55ad584855019c17f66a638720786e4de8e6bfb76eee07fa5'),
    (0x50d0a9, 0x50d0bc, '009e28bec388b5a3a6c6dd7d876ea8e0b3273502f59125715f63c1dd258be5b6'),
    (0x50e493, 0x50e4c2, '14015062d028d7a4fd6266c3d9648dda5b1c7434de796de29f786a1447f96d0b'),
    (0x511fab, 0x5120d4, '9625d85763583fad2e42d16733d25e398c51c127c716e7059d3680abb60d5157'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x94 observers."""

    def __init__(self):
        super().__init__()
        self.machine.mem_map(FRAME, FRAME_SIZE)
        self.arm_entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.events = []
        self.files = []
        self.fopen_fail = False
        self.alloc_fill = 0
        self.frees = 0
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    # -- hooks -------------------------------------------------------------------------------
    def _install_hooks(self):
        uc = self.machine
        table = {ARM_ENTRY: self._arm, HANDLER: self._handler, REFRESH: self._refresh, 0x423D33: self._reset_seen,
                 0x42BA3A: self._finish, 0x51DC6C: self._free, 0x50D0A9: self._fopen, 0x50E493: self._fwrite,
                 0x50CEE4: self._fclose}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._flag_store, begin=FLAG_VA, end=FLAG_VA + 3)

    def _arm(self, uc, address, size, user):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        self.arm_entries.append(struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0])

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.handler_rows.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])
        if uc.reg_read(X.UC_X86_REG_ECX) != DD:
            raise d9.OracleError('handler called with ECX %#x' % uc.reg_read(X.UC_X86_REG_ECX))

    def _refresh(self, uc, address, size, user):
        self.events.append(('refresh',))

    def _flag_store(self, uc, access, address, size, value, user):
        self.events.append(('flag', value & 0xFFFFFFFF if size == 4 else None))

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _cstring(self, uc, a):
        out = bytearray()
        while len(out) < 4096:
            b = uc.mem_read(a + len(out), 1)[0]
            if b == 0:
                return bytes(out)
            out.append(b)
        raise d9.OracleError('unterminated string at %#x' % a)

    def _free(self, uc, address, size, user):
        self.frees += 1
        self._ret(uc, 0, 0)

    def _fopen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        path = self._cstring(uc, u32(uc, sp + 4))
        mode = self._cstring(uc, u32(uc, sp + 8))
        handle = 0 if self.fopen_fail else FILE_BASE + 16 * len(self.files)
        self.files.append(dict(path=path, mode=mode, ok=handle != 0, handle=handle, data=bytearray(), closed=False))
        self.events.append(('file', len(self.files) - 1))
        self._ret(uc, 0, handle)

    def _fwrite(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        buf, each, count, handle = (u32(uc, sp + 4 * k) for k in (1, 2, 3, 4))
        target = next((f for f in self.files if f['handle'] == handle and f['ok']), None)
        if target is None or target['closed']:
            raise d9.OracleError('fwrite to an unopened handle %#x' % handle)
        target['data'] += bytes(uc.mem_read(buf, each * count))
        self._ret(uc, 0, count)

    def _fclose(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        handle = u32(uc, sp + 4)
        target = next((f for f in self.files if f['handle'] == handle and f['ok']), None)
        if target is None or target['closed']:
            raise d9.OracleError('fclose of an unopened handle %#x' % handle)
        target['closed'] = True
        self._ret(uc, 0, 0)

    def _malloc(self, uc):
        super()._malloc(uc)
        if self.alloc_fill:
            addr = uc.reg_read(X.UC_X86_REG_EAX)
            size = self.allocs[addr]
            uc.mem_write(addr, bytes([self.alloc_fill]) * size)

    # -- state ----------------------------------------------------------------------------------
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
        self.frees = 0
        self.mode = 'idle'
        self.expect_fatal = None
        self.files = []
        self.fopen_fail = False
        self.alloc_fill = 0
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_tick()

    def clear_tick(self):
        self.arm_entries, self.handler_rows, self.finish_entries, self.resets, self.events = [], [], [], [], []

    def setup_display(self, disp):
        """Write the display state the handler reads: sizes, pixel format, directory strings and the memory back buffer."""
        w, h, pitch = disp['width'], disp['height'], disp['pitch']
        self.wr(G_WIDTH, struct.pack('<h', w))
        self.wr(G_HEIGHT, struct.pack('<h', h))
        self.wr(G_BPP, struct.pack('<h', 2))
        self.wr(G_BITS, bytes([disp['bits']]))
        self.wr(DD + 0x38C0, bytes(disp['shifts']) + bytes(1) + bytes(disp['masks']) + bytes(1) + bytes(disp['chan']))
        self.wr(G_DRIVE, disp['drive'] + b'\0')
        self.wr(G_DIR, disp['dir'] + b'\0')
        # memory back-buffer mode of 0x4c4067 / 0x4c4202: CDirectDraw+8 == CDirectDraw+0xc skips the COM calls
        self.w32(DD + 0x08, FRAME)
        self.w32(DD + 0x0C, FRAME)
        self.w32(DD + 0x14, FRAME)
        self.w32(DD + 0x1C, pitch)
        self.wr(DD + 0x18, struct.pack('<hh', w, h))
        self.wr(DD + 0x20, struct.pack('<h', 2))
        rows = bytearray()
        for y in range(h):
            rows += disp['pixels'][y * w * 2:(y + 1) * w * 2] + bytes(pitch - w * 2)
        self.wr(FRAME, bytes(rows))

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
            self.wr(base + 0x30, bytes([0x94, spec['subtype']]) + struct.pack('<I', body_at))
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
        self.clear_tick()
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_94_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('session_bindings_a94.c', 'action_family_94_runtime.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A94_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a94o_new.restype = C.c_void_p
        lib.a94o_free.argtypes = [C.c_void_p]
        lib.a94o_setup.argtypes = [C.c_void_p, C.c_int, C.c_int, C.c_int, C.c_int, C.c_char_p, C.c_char_p, C.c_char_p,
                                   C.c_char_p, C.c_char_p, C.c_char_p, C.c_size_t, C.c_int]
        lib.a94o_setup.restype = C.c_int
        for n in ('a94o_event_count',):
            getattr(lib, n).argtypes = [C.c_void_p]
            getattr(lib, n).restype = C.c_uint
        lib.a94o_event_kind.argtypes = [C.c_void_p, C.c_uint]
        lib.a94o_event_kind.restype = C.c_int
        lib.a94o_event_value.argtypes = [C.c_void_p, C.c_uint]
        lib.a94o_event_value.restype = C.c_int32
        lib.a94o_clear_events.argtypes = [C.c_void_p]
        lib.a94o_path.argtypes = [C.c_void_p]
        lib.a94o_path.restype = C.c_char_p
        lib.a94o_file_length.argtypes = [C.c_void_p]
        lib.a94o_file_length.restype = C.c_size_t
        lib.a94o_file.argtypes = [C.c_void_p]
        lib.a94o_file.restype = C.c_void_p
        lib.a94o_visit.argtypes = [C.c_void_p, C.c_int, C.c_char_p, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a94o_visit.restype = C.c_int
        self.h = lib.a94o_new()

    def close(self):
        self.lib.a94o_free(self.h)

    def setup(self, disp, fail_write):
        status = self.lib.a94o_setup(self.h, disp['width'], disp['height'], 2, disp['bits'], bytes(disp['shifts']),
                                     bytes(disp['masks']), bytes(disp['chan']), disp['drive'], disp['dir'], disp['pixels'],
                                     len(disp['pixels']), 1 if fail_write else 0)
        if status != 0:
            raise d9.OracleError('native display setup failed')

    def events(self):
        out = []
        for i in range(self.lib.a94o_event_count(self.h)):
            out.append((self.lib.a94o_event_kind(self.h, i), self.lib.a94o_event_value(self.h, i)))
        return out

    def last_file(self):
        n = self.lib.a94o_file_length(self.h)
        ptr = self.lib.a94o_file(self.h)
        return self.lib.a94o_path(self.h), (C.string_at(ptr, n) if ptr and n else b'')

    def visit(self, subtype, body, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a94o_visit(self.h, subtype, body, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
FORMATS = {
    '565': ((0, 5, 11), (0x1F, 0x3F, 0x1F), (5, 6, 5)),
    '555': ((0, 5, 10), (0x1F, 0x1F, 0x1F), (5, 5, 5)),
    '655': ((0, 5, 10), (0x1F, 0x1F, 0x3F), (5, 5, 6)),
    '556': ((0, 6, 11), (0x3F, 0x1F, 0x1F), (6, 5, 5)),
}


def body_bytes(name=b'Award', x0=0, y0=0, x1=8, y1=6, fmt=0):
    b = bytearray(50)
    b[:len(name)] = name
    struct.pack_into('<iiii', b, 0x21, x0, y0, x1, y1)
    b[0x31] = fmt
    return bytes(b)


def make_display(rng, width=8, height=6, fmt='565', pitch_pad=0, drive=b'C:', dir_=b'SHOTS', bits=16, pixels=None):
    shifts, masks, chan = FORMATS[fmt] if isinstance(fmt, str) else fmt
    return dict(width=width, height=height, pitch=width * 2 + pitch_pad, bits=bits, shifts=shifts, masks=masks, chan=chan,
                drive=drive, dir=dir_, pixels=pixels if pixels is not None else bytes(rng.randrange(256) for _ in range(width * height * 2)))


def R(body, subtype=1, tail=b''):
    return dict(body=body, subtype=subtype, tail=tail)


def scenario_list(seed=32, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, disp, ticks=6, group='basic', **kw):
        scs.append(dict(id=sid, rows=rows, disp=disp, group=group, ticks=ticks, fill=kw.pop('fill', 0), fail_fopen=kw.pop('fail_fopen', False),
                        events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                        first=kw.pop('first', 0), acts=kw.pop('acts', None)))

    if corpus:
        for k, (st, body) in enumerate(corpus[:3]):
            S('corpus:%d' % k, [R(body, st)], make_display(rng, 640, 480, '565', pitch_pad=64 if k else 0), group='corpus', quick=k == 0)
        S('corpus:555', [R(corpus[0][1], corpus[0][0])], make_display(rng, 640, 480, '555'), group='corpus', fill=0xCD)
    d = lambda **kw: make_display(rng, **kw)  # noqa: E731
    for fmt in FORMATS:
        S('bmp:%s' % fmt, [R(body_bytes(b'Pic', 1, 1, 7, 5, 0))], d(fmt=fmt), group='bmp', quick=fmt in ('565', '655'))
        S('tga:%s' % fmt, [R(body_bytes(b'Pic', 2, 0, 8, 4, 1))], d(fmt=fmt), group='tga', quick=fmt in ('565', '556'))
    S('bmp:padding_widths', [R(body_bytes(b'W%d' % w, 0, 0, w, 3, 0)) for w in (1, 2, 3, 4, 5, 6, 7, 9)],
      d(width=10, height=4), group='bmp', fill=0xCD, quick=True)
    S('bmp:alloc_fill', [R(body_bytes(b'Fill', 0, 0, 5, 4, 0))], d(width=6, height=5), group='bmp', fill=0xAA)
    S('tga:format_bytes', [R(body_bytes(b'F%d' % f, 0, 0, 3, 3, f)) for f in (1, 2, 0x7F, 0x80, 0xFF)],
      d(width=4, height=4), group='tga', quick=True)
    S('tga:bits_per_pixel', [R(body_bytes(b'B', 0, 0, 4, 4, 1))], d(width=4, height=4, bits=15), group='tga')
    S('tga:wide_and_tall', [R(body_bytes(b'Wide', 1, 0, 300, 3, 1)), R(body_bytes(b'Tall', 0, 0, 3, 270, 1))], d(width=300, height=270),
      group='tga', quick=True)
    S('tga:full_screen', [R(body_bytes(b'Full', 0, 0, 8, 6, 1))], d(), group='tga', quick=True)
    S('bmp:full_screen_pitch', [R(body_bytes(b'Full', 0, 0, 8, 6, 0))], d(pitch_pad=6), group='bmp', quick=True)
    S('rect:beyond_width_waits', [R(body_bytes(b'A', 0, 0, 9, 6, 0))], d(), group='rect', quick=True)
    S('rect:beyond_height_waits', [R(body_bytes(b'A', 0, 0, 8, 7, 1))], d(), group='rect', quick=True)
    S('rect:single_pixel', [R(body_bytes(b'One', 3, 2, 4, 3, 1)), R(body_bytes(b'Two', 3, 2, 4, 3, 0))], d(), group='rect')
    S('name:path_variants', [R(body_bytes(b'n', 0, 0, 2, 2, 0))], d(drive=b'', dir_=b''), group='name')
    S('name:dir_slash', [R(body_bytes(b'n', 0, 0, 2, 2, 1))], d(drive=b'Z:', dir_=b'a\\b\\'), group='name', quick=True)
    S('name:dir_fwd_slash', [R(body_bytes(b'n.x', 0, 0, 2, 2, 0))], d(drive=b'', dir_=b'a/b/'), group='name')
    S('name:long_name', [R(body_bytes(b'N' * 32, 0, 0, 2, 2, 1))], d(drive=b'C:', dir_=b'D' * 120), group='name')
    S('fopen:fails', [R(body_bytes(b'Fail', 0, 0, 4, 4, 0)), R(body_bytes(b'Fail2', 0, 0, 4, 4, 1))], d(), group='fopen', fail_fopen=True, quick=True)
    for subtype in (0, 1, 2, 3, 255):
        S('subtype:%d' % subtype, [R(body_bytes(b'S', 0, 0, 3, 3, 1), subtype)], d(), ticks=8, group='subtype',
          quick=subtype in (1, 2))
    S('phases:others_do_nothing', [R(body_bytes(b'P', 0, 0, 3, 3, 1)), R(body_bytes(b'Q', 0, 0, 3, 3, 0))], d(), group='phases',
      acts=[('setphase', 0, 1), ('tick',), ('setphase', 0, 4), ('tick',), ('setphase', 1, 5), ('tick',), ('setphase', 1, 99),
            ('tick',), ('setphase', 0, 3), ('tick',), ('setphase', 1, 2), ('tick',), ('tick',)], quick=True)
    S('gate:event_false_then_true', [R(body_bytes(b'G', 0, 0, 3, 3, 1), 1, a67.event_tail(40, 1)), R(body_bytes(b'H', 0, 0, 3, 3, 0))],
      d(), group='gate', events={40: 7}, acts=[('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('tick',), ('tick',), ('tick',)], quick=True)
    S('gate:mode4_runs_nothing', [R(body_bytes(b'M', 0, 0, 3, 3, 1))], d(), group='gate', mode=4, acts=[('tick',), ('tick',), ('mode', 3),
                                                                                            ('tick',), ('tick',), ('tick',), ('tick',)])
    S('rows:offset_first_row', [R(body_bytes(b'O', 0, 0, 3, 3, 1)), R(body_bytes(b'P', 0, 0, 3, 3, 0))], d(), group='rows', first=3)
    S('rows:rearm_captures_again', [R(body_bytes(b'Re', 0, 0, 3, 3, 1), 2)], d(), group='rows',
      acts=[('tick',)] * 5 + [('rearm',)] + [('tick',)] * 4)
    for n in range(40):
        w, h = rng.randint(1, 24), rng.randint(1, 16)
        fmt = rng.choice(list(FORMATS) + ['random'])
        if fmt == 'random':
            fmt = (tuple(rng.randrange(32) for _ in range(3)), tuple(rng.randrange(256) for _ in range(3)),
                   tuple(rng.choice((4, 5, 5, 5, 6, 6, 7)) for _ in range(3)))
        rows = []
        for _ in range(rng.randint(1, 4)):
            x0 = rng.randrange(0, w)
            y0 = rng.randrange(0, h)
            x1 = rng.randint(x0 + 1, w + (1 if rng.random() < 0.15 else 0))
            y1 = rng.randint(y0 + 1, h + (1 if rng.random() < 0.15 else 0))
            name = bytes(rng.choice(b'ABCDEFabcdef0123_-') for _ in range(rng.randint(1, 32)))
            rows.append(R(body_bytes(name, x0, y0, x1, y1, rng.choice((0, 1, 1, 0, 2, 0x80))), rng.choice((0, 1, 1, 1, 2, 3))))
        disp = make_display(rng, w, h, fmt, pitch_pad=rng.choice((0, 0, 2, 8)), bits=rng.choice((15, 16, 16, 32, 8)),
                            drive=rng.choice((b'', b'C:', b'D:', b'x')), dir_=rng.choice((b'', b'S', b'S\\', b'a/b', b'a\\b\\c\\')))
        S('random:%d' % n, rows, disp, ticks=rng.randint(4, 9), group='random', fill=rng.choice((0, 0, 0xCD)), quick=n < 3)
    return scs


def load_corpus():
    """The decoded scene resources' raw-0x94 rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not resources.exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_94_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in ('session_bindings_a94.c', 'action_family_94_runtime.c', 'scene_resource.c', 'hiff.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
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
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, completions=0, files_compared=0, file_bytes=0,
                bmp_files=0, tga_files=0, fopen_refused=0, effect_compares=0, mismatches=0, phase2_waits=0, by_subtype=Counter(), groups={})


def mask_bmp(data):
    """Zero the row padding bytes of a 24-bit BMP (uninitialised heap in the original)."""
    if len(data) < 54 or data[:2] != b'BM':
        return data
    w, h = struct.unpack_from('<ii', data, 18)
    stride = (3 * w + 3) & 0xFFFC
    out = bytearray(data)
    for r in range(h):
        start = 54 + r * stride + 3 * w
        out[start:54 + (r + 1) * stride] = bytes(54 + (r + 1) * stride - start)
    return bytes(out)


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


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    x.setup_display(sc['disp'])
    nat.setup(sc['disp'], sc['fail_fopen'])
    x.fopen_fail = sc['fail_fopen']
    x.alloc_fill = sc['fill']
    state = dict(mode=sc['mode'])
    for idx, v in sc['events'].items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    actions = sc['acts'] if sc['acts'] is not None else [('tick',)] * sc['ticks']
    for ai, act in enumerate(actions):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, sc, rows, first, state, completed, phases, stats)
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


def native_effects(nat):
    """The native host callbacks of one visit as comparable tuples, files read back from the driver."""
    out = []
    for kind, value in nat.events():
        if kind == 1:
            out.append(('flag', value & 0xFFFFFFFF))
        elif kind == 2:
            out.append(('refresh',))
        elif kind == 4:
            path, data = nat.last_file()
            out.append(('file', path, value == 0, data))
    return out


def original_effects(x):
    out = []
    for ev in x.events:
        if ev[0] == 'file':
            f = x.files[ev[1]]
            out.append(('file', f['path'], f['ok'], bytes(f['data']), f['mode']))
        else:
            out.append(ev)
    return out


def tick(where, x, nat, sc, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    x.dispatch()
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(d9.EVENTS_VA + 4 * i, 4))[0]  # noqa: E731  rows never write flags
    expected_entered, expected = [], []
    native_fx = []
    finished_expected, resets_expected = [], []
    if state['mode'] == 3:
        for i in range(first, total):
            if completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if not a67.row_gate_open(spec, flags):
                continue
            expected.append(i)
            nat.lib.a94o_clear_events(nat.h)
            status, done, reset, phase, disposition = nat.visit(spec['subtype'], spec['body'], completed[i], phases[i])
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
            native_fx += native_effects(nat)
            if phases[i] == 3:
                finished_expected.append(i)
            if reset:
                resets_expected.append(i)
            if phases[i] == 2 and phase == 2:
                stats['phase2_waits'] += 1
            completed[i], phases[i] = done, phase
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (done, phase) != (o_done, o_phase):
                raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d)' %
                               (where, i, done, phase, reset, o_done, o_phase))
            stats['rows_visited'] += 1
            stats['completions'] += done
            stats['by_subtype'][spec['subtype']] += 1
    stats['rows_entered'] += len(x.arm_entries)
    if x.arm_entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for rows %s, the model expects %s' % (where, x.arm_entries, expected_entered))
    if x.handler_rows != expected:
        raise Mismatch('%s: the original ran the handler for rows %s, the gate model expects %s' % (where, x.handler_rows, expected))
    if x.finish_entries != finished_expected:
        raise Mismatch('%s: the generic completion ran for rows %s, expected %s' % (where, x.finish_entries, finished_expected))
    if x.resets != resets_expected:
        raise Mismatch('%s: the original reset the dependencies of rows %s, native asked for %s' % (where, x.resets, resets_expected))
    stats['rows_gated'] += len(expected_entered) - len(expected)
    # ordered effects: flag stores, redraw requests, files
    orig = original_effects(x)
    if len(orig) != len(native_fx):
        raise Mismatch('%s: the original produced %d effects %s, native %d %s' % (where, len(orig), [e[:2] for e in orig], len(native_fx), [e[:2] for e in native_fx]))
    for k, (o, n) in enumerate(zip(orig, native_fx)):
        stats['effect_compares'] += 1
        if o[0] != n[0]:
            raise Mismatch('%s: effect %d original %s native %s' % (where, k, o[0], n[0]))
        if o[0] == 'flag':
            if o[1] != n[1]:
                raise Mismatch('%s: effect %d flag store original %s native %s' % (where, k, o[1], n[1]))
        elif o[0] == 'file':
            if o[1] != n[1] or o[4] != b'wb' or o[2] != n[2]:
                raise Mismatch('%s: file %d original (path %r mode %r opened %s) native (path %r opened %s)' %
                               (where, k, o[1], o[4], o[2], n[1], n[2]))
            if o[2]:
                od, nd = mask_bmp(o[3]), mask_bmp(n[3])
                if od != nd:
                    first_diff = next((j for j in range(min(len(od), len(nd))) if od[j] != nd[j]), min(len(od), len(nd)))
                    raise Mismatch('%s: file %r differs at byte %d (original %d bytes, native %d bytes)' %
                                   (where, o[1], first_diff, len(od), len(nd)))
                stats['files_compared'] += 1
                stats['file_bytes'] += len(od)
                stats['bmp_files' if od[:2] == b'BM' else 'tga_files'] += 1
            else:
                stats['fopen_refused'] += 1
    for i in range(first, total):
        if i not in expected:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    flag_now = struct.unpack('<I', x.rd(FLAG_VA, 4))[0]
    native_flag = None
    for e in native_fx:
        if e[0] == 'flag':
            native_flag = e[1]
    if native_flag is not None and native_flag != flag_now:
        raise Mismatch('%s: capture flag original %d native %d' % (where, flag_now, native_flag))


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
    'phase 0 skips the flag': ('b->host.set_capture_flag(b->host.context, 1);  /* 0x4c3719 */', '(void)0;', 'session_bindings_a94.c'),
    'phase 0 skips the redraw request': ('b->host.request_refresh(b->host.context);       /* 0x4c3727 */', '(void)0;', 'session_bindings_a94.c'),
    'phase 0 goes to phase 1': ('out->phase = A94_PHASE_CAPTURE;                 /* 0x4c3730: phase 0 jumps to 2 */', 'out->phase = 1u;', 'session_bindings_a94.c'),
    'flag never cleared': ('b->host.set_capture_flag(b->host.context, 0);  /* 0x4c3c19 */', '(void)0;', 'session_bindings_a94.c'),
    'phase 3 not reached': ('out->phase = A94_PHASE_DONE;                    /* 0x4c3c23 */', 'out->phase = A94_PHASE_CAPTURE;', 'session_bindings_a94.c'),
    'completion without phase reset': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a */\n        out->phase = 0u;', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;\n        out->phase = 3u;', 'session_bindings_a94.c'),
    'phase 3 direct completion': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a */', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;', 'session_bindings_a94.c'),
    'oversized rectangle captured': ('if (!a94_capture_reachable(&display.screen, &request)) {', 'if (0) {', 'session_bindings_a94.c'),
    'wrong reachable test (width)': ('request->y1 <= (int32_t)screen->height && request->x1 <= (int32_t)screen->width', 'request->y1 <= (int32_t)screen->height && request->x1 < (int32_t)screen->width', 'action_family_94_runtime.c'),
    'wrong reachable test (height)': ('request->y1 <= (int32_t)screen->height && request->x1 <= (int32_t)screen->width', 'request->y1 < (int32_t)screen->height && request->x1 <= (int32_t)screen->width', 'action_family_94_runtime.c'),
    'extension swapped': ('return request->format == 0u ? ".BMP" : ".TGA";', 'return request->format == 0u ? ".TGA" : ".BMP";', 'action_family_94_runtime.c'),
    'format byte ignored': ('return request->format == 0u ? ".BMP" : ".TGA";', '(void)request;\n    return ".BMP";', 'action_family_94_runtime.c'),
    'bmp file size field': ('wr32(out + 2, (uint32_t)(data + 0x36u));', 'wr32(out + 2, (uint32_t)(data + 0x35u));', 'action_family_94_runtime.c'),
    'bmp width and height swapped': ('wr32(out + 18, (uint32_t)w);', 'wr32(out + 18, (uint32_t)h);', 'action_family_94_runtime.c'),
    'tga width truncated': ('wr16(out + 12, (uint16_t)w);', 'out[12] = (uint8_t)w;', 'action_family_94_runtime.c'),
    'dir backslash dropped': ("            PUT('\\\\');\n        }\n    }\n    if (name != NULL) {", "            (void)0;\n        }\n    }\n    if (name != NULL) {", 'action_family_94_runtime.c'),
    'drive colon dropped': ("        PUT(':');", "        (void)0;", 'action_family_94_runtime.c'),
    'rows not flipped': ('uint8_t *dst = rows + (h - 1u - y) * stride;', 'uint8_t *dst = rows + y * stride;', 'action_family_94_runtime.c'),
    'bmp stride unpadded': ('stride = (3u * w + 3u) & ~(size_t)3u;', 'stride = 3u * w;', 'action_family_94_runtime.c'),
    'bmp colour order': ('dst[3u * x + 0u] = (uint8_t)(v << 3);', 'dst[3u * x + 2u] = (uint8_t)(v << 3);', 'action_family_94_runtime.c'),
    'tga origin bit': ('out[17] = 0x20u;', 'out[17] = 0x00u;', 'action_family_94_runtime.c'),
    'tga bits per pixel constant': ('out[16] = screen->bits_per_pixel;', 'out[16] = 16u;', 'action_family_94_runtime.c'),
    'tga type': ('out[2] = 2u;', 'out[2] = 10u;', 'action_family_94_runtime.c'),
    'crop origin x ignored': ('+ (size_t)request->x0 * 2u;\n            for (x = 0u; x < w; ++x) {\n                wr16(rows', '+ 0u;\n            for (x = 0u; x < w; ++x) {\n                wr16(rows', 'action_family_94_runtime.c'),
    'green not narrowed': ('g = (uint16_t)(g >> 1);', 'g = (uint16_t)(g >> 0);', 'action_family_94_runtime.c'),
    'red mask wrong index': ('uint16_t r = (uint16_t)((pixel >> (s->shifts[2] & 0x1f)) & s->masks[2]);', 'uint16_t r = (uint16_t)((pixel >> (s->shifts[2] & 0x1f)) & s->masks[1]);', 'action_family_94_runtime.c'),
    'file written before capture check': ('if (b->host.write_file(b->host.context, path, file, length) != 0) {', 'if (0) {', 'session_bindings_a94.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-32.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver94.so')
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
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    summary['corpus_rows'] = len(corpus) if corpus else 0
    print(json.dumps(summary, sort_keys=True, default=str))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]
        args.result.write_text(json.dumps(dict(slice='RT-32', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True, default=str) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
