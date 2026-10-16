#!/usr/bin/env python3
"""RT-26: immutable x86 dispatcher 0x427a50 (arm 0x429e41) versus the native raw-0x95 "Set Volume" runtime.

The unmodified GAME.EXE image is mapped under Unicorn and the REAL dispatcher 0x427a50 runs over rows of
raw type 0x95: dependency trees built by the real loader 0x424aa8, the gate 0x423f57, the arm that turns the
body byte into two float arguments (x87 fild/fdiv 100.0), the setter 0x4fca60 (stores both scalars, two
attenuations through the category master and the CRT _ftol 0x50ce04), the DirectSound volume helper 0x4f684a
(clamps, SetVolume on the channel's buffer, error states 0x3ea/0x3ef/0x408), the completion helper 0x42ba3a and,
for subtype 2, the dependency reset 0x423d33. All of it is original x86; x87 control word 0x027f as a Win32
process starts.

Native side: src/session_bindings_a95.c (the executor's handler contract) over src/action_family_95.c and the
sound_control kernel (src/sound_control.c, sound_control_set_scalars), driven by
tests/action_family_95_runtime_oracle_driver.c with a recording SetVolume stand-in. The driver derives the
row's completion byte, dependency reset and phase from the handler's disposition with the executor's own
helper (action_core_finish_action).

Compared after every dispatcher call (tick), for the rows the original visited and the ones it did not:
 * which rows were visited: the original's observed setter entries and 0x42ba3a entries against the gate
   expectation (event-flag dependency records, the world mode word) and against the native visits;
 * the row completion byte, the row phase dword and whether 0x423d33 reset the row's dependencies;
 * for ALL 32 channel slots: first and second scalar (bit patterns) and first and second attenuation;
 * CDirectSound device error 0x3c2, device state 0x3be and host result 0x3ca;
 * the ordered SetVolume calls (channel and attenuation).

HOOKS (everything else is original code): R = replaced, O = observed.
  R DirectSound IDirectSoundBuffer::SetVolume (vtable +0x3c of each channel's buffer): records and returns the
    scripted HRESULT (COM/OS boundary)
  O 0x4fca60 setter, 0x4f684a volume helper, 0x42ba3a completion helper, 0x423d33 dependency reset: entry
    observers, they only read memory
  R 0x51dc43 malloc (bump arena in the oracle heap) for the dependency loader
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag
 0x63a4cd is 0.

KNOWN DIFFERENCE (counted in stats.known_observed, never as a pass):
  K1 a channel outside 0..31: the original indexes the slot array unchecked (channel 32 lands on the volume
     master table), native refuses the row before any effect. No corpus row has a channel above 12.

Not modelled / unverified: the real DirectSound buffer and what SetVolume does to the audible output (stand-in),
the LiveAudio adapter that blackmoor_app.mm binds (macOS only, gain model is the adapter's, not the original dB
curve), the scene loader 0x40b34a that allocates the body (the oracle builds the body in memory; the native
decoder is checked against the corpus separately), the render-thread/IDirectSound notifications.

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_95_runtime_original_oracle.py --mutations --result <receipt.json>
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

CSOUND = 0x5C3A67
CDS = 0x5CF1EB
SLOT = 0x5BB
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
BUFFERS = 0x20100000   # 0x10 bytes per channel: [vtable]
VTABLE = 0x20101000
VOL_STUB = 0x20102000
SKIP_LOOP = 0x5BB638 - 0x5BB5B3  # row +0x85: nonzero rows are skipped by the dispatcher (always 0 here)

CATEGORY = {c: 0 for c in (12, 13, 30)}
CATEGORY.update({c: 1 for c in (0, 1, 2, 26, 27, 29, 19)})
CATEGORY.update({c: 2 for c in (3, 4, 5, 6, 7, 8, 9, 10, 11, 20, 24, 25, 23, 22, 21, 31, 18, 17)})
CORPUS_CHANNELS = (0, 4, 5, 6, 7, 11, 12)
CORPUS_VOLUMES = (0, 15, 20, 25, 35, 40, 45, 50, 60, 65, 70, 75, 85, 100)

# Executed original code, as function spans (SHA-256 of the unmodified image bytes), discovered over every scenario with
# --discover-pins and verified at start-up.
PINS_TABLE = (
    (0x4234c8, 0x4234dd,
     'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876,
     'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423d33, 0x423da2,
     'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
    (0x423da2, 0x423f57,
     '10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160'),
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
    (0x4f684a, 0x4f6a7e,
     'ec0a5c5d12137f671987aea9599e247b21fbc05d82f194c3af9ded151225a56e'),
    (0x4f709c, 0x4f70b0,
     'f4378d19b5c3ab0dbd39cba983f59f6dc52989a4d7f3e5211057cd34d287503e'),
    (0x4fca60, 0x4fcb5c,
     '372547ba566f69952091001f1df3930506bf6bfd712b16180a16e8b6f6f67255'),
    (0x50ce04, 0x50ce2b,
     'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
    (0x51dc43, 0x51dc6c,
     '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
)

F32 = struct.Struct('<f')
HOST_OK, HOST_ERROR, HOST_UNSUPPORTED = 0, 1, 2


def f32bits(value):
    return struct.unpack('<I', F32.pack(value))[0]


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the sound hooks."""

    def __init__(self):
        super().__init__()
        self.volume_hresult = 0
        self.volume_trace = []
        self.resets = []
        self.setter_entries = []
        self.finish_entries = []
        self.helper_entries = 0
        self.buffer_channel = {}
        for pin in PINS_TABLE:
            a, z, digest = pin
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    def _install_hooks(self):
        uc = self.machine
        table = {VOL_STUB: self._volume, 0x423D33: self._reset_seen, 0x4FCA60: self._setter,
                 0x42BA3A: self._finish, 0x4F684A: self._helper}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _volume(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        buffer = u32(uc, sp + 4)
        attenuation = struct.unpack('<i', bytes(uc.mem_read(sp + 8, 4)))[0]
        if buffer not in self.buffer_channel:
            raise d9.OracleError('SetVolume on an unknown buffer %#x' % buffer)
        self.volume_trace.append((self.buffer_channel[buffer], attenuation))
        self._ret(uc, 8, self.volume_hresult & 0xFFFFFFFF)

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        arg = u32(uc, sp + 4)
        self.resets.append((arg - 0x5BB5E9) // ROW)

    def _setter(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        if uc.reg_read(X.UC_X86_REG_ECX) != CSOUND:
            raise d9.OracleError('0x4fca60 entered with ECX != CSound')
        channel = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        self.setter_entries.append((channel, u32(uc, sp + 8), u32(uc, sp + 12)))

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _helper(self, uc, address, size, user):
        if uc.reg_read(X.UC_X86_REG_ECX) != CDS:
            raise d9.OracleError('0x4f684a entered with ECX != CDirectSound')
        self.helper_entries += 1

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
        # DirectSound plumbing: one buffer object per channel, one shared vtable whose +0x3c is the stand-in
        self.wr(VTABLE, bytes(0x54))
        self.w32(VTABLE + 0x3C, VOL_STUB)
        self.buffer_channel = {}
        for channel in range(32):
            buffer = BUFFERS + 0x10 * channel
            self.w32(buffer, VTABLE)
            self.buffer_channel[buffer] = channel
        self.w32(CDS + 0x1A0, 1)
        self.w32(CDS + 0x3CE, CSOUND + 4)
        self.volume_hresult = 0
        self.volume_trace, self.resets, self.setter_entries, self.finish_entries = [], [], [], []
        self.helper_entries = 0

    def install_rows(self, rows, first=0):
        total = first + len(rows)
        self.wr(ROWS, bytes(max(total, 8) * ROW))
        for i in range(first):
            self.wr(ROWS + i * ROW + COMPLETE_OFF, b'\1')
        for k, spec in enumerate(rows):
            i = first + k
            base = ROWS + i * ROW
            body_at = d9.BODY_BASE + 0x40 * i
            self.wr(body_at, spec['body'])
            self.wr(base + 0x30, bytes([0x95, spec['subtype']]) + struct.pack('<I', body_at))
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
        self.setter_entries, self.finish_entries, self.resets, self.volume_trace = [], [], [], []
        self.helper_entries = 0
        self.mode = 'step'
        self.wr(0x5C3A47, bytes(4))
        try:
            self.call(0x427A50, [], 0)
        finally:
            self.mode = 'idle'

    # -- sound state ------------------------------------------------------------------------------
    def seed_channel(self, ch, category, buffer, first_bits, second_bits, first_att, second_att):
        self.wr(CSOUND + 0x10C + ch * SLOT, struct.pack('<H', category))
        self.w32(CSOUND + 4 + ch * SLOT + 0x28F, BUFFERS + 0x10 * ch if buffer else 0)
        self.w32(CSOUND + 0x138 + ch * SLOT, first_bits)
        self.w32(CSOUND + 0x13C + ch * SLOT, second_bits)
        self.wr(CSOUND + 0x140 + ch * SLOT, struct.pack('<i', first_att))
        self.wr(CSOUND + 0x144 + ch * SLOT, struct.pack('<i', second_att))

    def channels(self):
        out = []
        for ch in range(32):
            out.append((u32(self.machine, CSOUND + 0x138 + ch * SLOT), u32(self.machine, CSOUND + 0x13C + ch * SLOT),
                        self.s32(CSOUND + 0x140 + ch * SLOT), self.s32(CSOUND + 0x144 + ch * SLOT)))
        return out

    def device(self):
        return (u32(self.machine, CDS + 0x3C2), u32(self.machine, CDS + 0x3BE), self.s32(CDS + 0x3CA))


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-ffp-contract=off', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_95_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in ('action_family_95.c', 'session_bindings_a95.c', 'sound_control.c', 'action_core.c')],
           '-lm', '-o', str(out)]
    if os.environ.get('A95_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a95o_new.restype = C.c_void_p
        for name, args in (('a95o_free', [C.c_void_p]), ('a95o_reset', [C.c_void_p]),
                           ('a95o_seed', [C.c_void_p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.c_uint32, C.c_int32, C.c_int32]),
                           ('a95o_master', [C.c_void_p, C.c_int, C.c_uint32]), ('a95o_device_ready', [C.c_void_p, C.c_int]),
                           ('a95o_volume_result', [C.c_void_p, C.c_int, C.c_int32]),
                           ('a95o_channel', [C.c_void_p, C.c_int] + [C.POINTER(C.c_uint32)] * 2 + [C.POINTER(C.c_int32)] * 2),
                           ('a95o_device', [C.c_void_p, C.POINTER(C.c_uint32), C.POINTER(C.c_uint32), C.POINTER(C.c_int32)]),
                           ('a95o_volume_at', [C.c_void_p, C.c_int, C.POINTER(C.c_int), C.POINTER(C.c_int32)]),
                           ('a95o_volume_clear', [C.c_void_p])):
            getattr(lib, name).argtypes = args
        lib.a95o_visit.argtypes = [C.c_void_p, C.c_char_p, C.c_int, C.c_int, C.c_int, C.c_uint32, C.POINTER(C.c_int),
                                   C.POINTER(C.c_int), C.POINTER(C.c_uint32), C.POINTER(C.c_int)]
        lib.a95o_visit.restype = C.c_int
        lib.a95o_volume_count.argtypes = [C.c_void_p]
        lib.a95o_set_calls.argtypes = [C.c_void_p]
        lib.a95o_set_failed.argtypes = [C.c_void_p]
        self.h = lib.a95o_new()
        lib.a95o_reset(self.h)

    def close(self):
        self.lib.a95o_free(self.h)

    def visit(self, body, subtype, completed, phase):
        done, reset, new_phase, disposition = C.c_int(), C.c_int(), C.c_uint32(), C.c_int()
        status = self.lib.a95o_visit(self.h, bytes(body), len(body), subtype, completed, phase, C.byref(done), C.byref(reset),
                                     C.byref(new_phase), C.byref(disposition))
        return status, done.value, reset.value, new_phase.value, disposition.value

    def channels(self):
        out = []
        for ch in range(32):
            a, b, c, d = C.c_uint32(), C.c_uint32(), C.c_int32(), C.c_int32()
            self.lib.a95o_channel(self.h, ch, C.byref(a), C.byref(b), C.byref(c), C.byref(d))
            out.append((a.value, b.value, c.value, d.value))
        return out

    def device(self):
        e, s, r = C.c_uint32(), C.c_uint32(), C.c_int32()
        self.lib.a95o_device(self.h, C.byref(e), C.byref(s), C.byref(r))
        return (e.value, s.value, r.value)

    def volumes(self):
        out = []
        for i in range(self.lib.a95o_volume_count(self.h)):
            ch, att = C.c_int(), C.c_int32()
            self.lib.a95o_volume_at(self.h, i, C.byref(ch), C.byref(att))
            out.append((ch.value, att.value))
        return out


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def R(ch, vol, subtype=1, tail=b'', body=None):
    return dict(ch=ch, vol=vol, subtype=subtype, tail=tail, body=body if body is not None else struct.pack('<HB', ch & 0xFFFF, vol))


def event_tail(index, value):
    return struct.pack('<8h', 2, index, value, 0, 0, 0, 0, 0)


def scenario_list(seed=26):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, actions=None, group='basic', **kw):
        sc = dict(id=sid, rows=rows, actions=actions or [('tick',)], group=group, master=kw.pop('master', {}),
                  seeds=kw.pop('seeds', {}), device=kw.pop('device', 1), volres=kw.pop('volres', (HOST_OK, 0)),
                  events=kw.pop('events', {}), mode=kw.pop('mode', 3), quick=kw.pop('quick', False),
                  first=kw.pop('first', 0), buffers=kw.pop('buffers', None), known=kw.pop('known', None))
        scs.append(sc)

    # corpus: the seven channels and the fourteen volumes the 123 rows use, real category table, one master per category
    masters = {0: 0.85, 1: 0.85, 2: 0.85, 3: 0.85}
    for ch in CORPUS_CHANNELS:
        S('corpus:ch%d' % ch, [R(ch, v) for v in CORPUS_VOLUMES], group='corpus', master=masters, quick=ch in (5, 12))
    # every volume byte on one channel, four masters; subtype 0 keeps the row alive so every tick revisits it
    for master in (1.0, 0.85, 0.5, 0.0):
        acts = [('tick',)]
        for v in range(1, 256):
            acts += [('vol', 0, v), ('tick',)]
        S('sweep:master%s' % master, [R(5, 0, subtype=0)], acts, group='sweep', master={2: master}, quick=master == 0.85)
    # every channel (the category table), one volume
    S('channels:all32', [R(ch, 37) for ch in range(32)], group='channels', master={0: 0.7, 1: 0.8, 2: 0.9, 3: 0.6}, quick=True)
    # category x master x volume matrix
    for cat in range(4):
        ch = [12, 0, 3, 14][cat]
        for master in (0.0, 0.1, 0.25, 0.3333, 0.5, 0.85, 1.0):
            S('matrix:cat%d_m%s' % (cat, master), [R(ch, v) for v in (0, 1, 50, 99, 100, 101, 128, 255)], group='matrix',
              master={cat: master}, quick=(cat == 2 and master in (0.25, 1.0)))
    # subtype and phase: 1 completes, 2 resets, 0 and 3 leave the completion byte; the phase returns to 0 for all
    for subtype in (0, 1, 2, 3, 4, 255):
        S('subtype:%d' % subtype, [R(7, 60, subtype), R(8, 61, subtype)],
          [('setphase', 0, 5), ('setphase', 1, 9), ('tick',), ('tick',), ('setphase', 0, 3), ('tick',)], group='subtype',
          master=masters, quick=subtype in (0, 1, 2))
    # device and buffer states: not ready (0x3ea), no buffer (0x3ef), SetVolume failure (0x408), recovery
    S('device:not_ready', [R(4, 25), R(5, 45, subtype=0)], [('tick',), ('device', 1), ('tick',), ('tick',)], group='device',
      device=0, master=masters, quick=True)
    S('device:no_buffer', [R(4, 25, subtype=0), R(5, 45, subtype=0)], [('tick',), ('buffer', 4, 1), ('tick',), ('buffer', 5, 0), ('tick',)],
      group='device', buffers={4: 0, 5: 1}, master=masters, quick=True)
    for hres in (-1, -2147467259, 0x7FFFFFFF, 5):
        S('device:setvolume_hresult_%d' % hres, [R(6, 15, subtype=0), R(7, 85, subtype=0)],
          [('tick',), ('volres', HOST_OK, 0), ('tick',)], group='device', volres=(HOST_ERROR, hres), master=masters,
          quick=hres == -1)
    # gates: a false dependency record leaves the row untouched; opening it later runs the arm; world mode != 3 runs nothing
    S('gate:event_false_then_true', [R(4, 25, tail=event_tail(40, 1)), R(5, 45)],
      [('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('tick',)], group='gate', events={40: 7}, master=masters, quick=True)
    S('gate:event_closes_again', [R(4, 25, subtype=0, tail=event_tail(41, 0)), R(5, 45)],
      [('tick',), ('events', {41: 3}), ('tick',), ('events', {41: 0}), ('tick',)], group='gate', events={41: 0}, master=masters)
    S('gate:mode4_runs_nothing', [R(4, 25), R(5, 45)], [('tick',), ('mode', 3), ('tick',)], group='gate', mode=4, master=masters,
      quick=True)
    S('gate:subtype2_behind_event', [R(6, 20, subtype=2, tail=event_tail(42, 5))], [('events', {42: 5}), ('tick',), ('tick',)],
      group='gate', events={42: 1}, master=masters, quick=True)
    # completed rows are skipped; two rows on one channel; a completed first row does not stop the second
    S('rows:complete_then_skip', [R(4, 25), R(4, 75, subtype=0), R(5, 45)], [('tick',), ('tick',), ('tick',)], group='rows',
      master=masters, quick=True)
    S('rows:offset_first_row', [R(11, 35), R(12, 100)], [('tick',), ('tick',)], group='rows', first=3, master=masters, quick=True)
    S('rows:body_rewritten_between_ticks', [R(5, 10, subtype=0)], [('tick',), ('vol', 0, 90), ('tick',), ('ch', 0, 6), ('tick',)],
      group='rows', master=masters)
    # tail longer than the body (the corpus has rows with one or two dependency records after the three typed bytes)
    S('rows:body_with_tail_bytes', [R(4, 25, body=struct.pack('<HB', 4, 25) + bytes(range(16)))], group='rows', master=masters, quick=True)
    # random scenarios
    for n in range(40):
        rows = []
        for _ in range(rng.randint(1, 5)):
            rows.append(R(rng.randrange(32), rng.randrange(256), rng.choice((0, 1, 1, 2, 3))))
        acts = []
        for _ in range(rng.randint(2, 4)):
            acts.append(('tick',))
            if rng.random() < 0.4:
                acts.append(('vol', rng.randrange(len(rows)), rng.randrange(256)))
            if rng.random() < 0.2:
                acts.append(('device', rng.randrange(2)))
        seeds = {ch: dict(cat=rng.randrange(4), buffer=rng.random() < 0.8) for ch in range(32)}
        S('random:%d' % n, rows, acts, group='random', master={c: rng.choice((0.0, 0.2, 0.5, 0.85, 1.0, rng.random())) for c in range(4)},
          seeds=seeds, device=int(rng.random() < 0.9), volres=(HOST_OK, 0) if rng.random() < 0.85 else (HOST_ERROR, -1), quick=n < 3)
    # K1: channel outside the recovered slot array
    S('known:K1_channel_32', [R(32, 25)], group='known', known='K1', quick=False)
    return scs


def row_gate_open(spec, events):
    t = spec.get('tail') or b''
    if not t:
        return True
    rec = struct.unpack_from('<8h', t, 0)
    return events.get(rec[1], 0) == rec[2]


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_visited=0, rows_gated=0, completions=0, resets=0, state_compares=0, channel_fields=0,
                volume_calls=0, helper_entries=0, setter_entries=0, mismatches=0, gate_model_checks=0, error_states=Counter(),
                known_observed=Counter(), groups={})


def seed_values(rng_state, ch):
    return (f32bits(0.3 + 0.01 * (ch % 7)), f32bits(0.7 - 0.01 * (ch % 5)), -111 - ch, -222 - ch)


def run_scenario(x, nat, sc, stats):
    t0 = time.monotonic()
    before = (stats['ticks'], stats['rows_visited'], stats['volume_calls'])
    try:
        run_scenario_inner(x, nat, sc, stats)
    finally:
        g = stats['groups'].setdefault(sc['group'], Counter())
        g['scenarios'] += 1
        g['ticks'] += stats['ticks'] - before[0]
        g['rows_visited'] += stats['rows_visited'] - before[1]
        g['volume_calls'] += stats['volume_calls'] - before[2]
        g['seconds'] += round(time.monotonic() - t0, 2)


def run_scenario_inner(x, nat, sc, stats):
    x.hard_reset()
    nat.lib.a95o_reset(nat.h)
    rows = [dict(r) for r in sc['rows']]
    first = sc['first']
    if sc.get('known') == 'K1':
        # The original runs the row against memory the native model does not own; native must refuse before any effect.
        body = rows[0]['body']
        status, done, reset, phase, disp = nat.visit(body, rows[0]['subtype'], 0, 0)
        if status == 0 or nat.volumes() or nat.lib.a95o_set_calls(nat.h) != 0:
            raise Mismatch('native did not refuse the out-of-range channel (status %d)' % status)
        stats['known_observed']['K1'] += 1
        stats['scenarios'] += 1
        return
    x.install_rows(rows, first)
    x.wr(d9.G_MODE, struct.pack('<i', sc['mode']))
    mode = sc['mode']
    events = dict(sc['events'])
    for idx, v in events.items():
        x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
    x.volume_hresult = sc['volres'][1]
    nat.lib.a95o_volume_result(nat.h, sc['volres'][0], sc['volres'][1])
    device = sc['device']
    x.w32(CDS + 0x1A0, device)
    nat.lib.a95o_device_ready(nat.h, device)
    for cat, value in sc['master'].items():
        x.wr(CSOUND + 0xB764 + 4 * cat, F32.pack(value))
        nat.lib.a95o_master(nat.h, cat, f32bits(value))
    for cat in range(4):
        if cat not in sc['master']:
            x.wr(CSOUND + 0xB764 + 4 * cat, F32.pack(1.0))
    buffers = dict(sc['buffers'] or {})
    for ch in range(32):
        seed = sc['seeds'].get(ch, {})
        category = seed.get('cat', CATEGORY.get(ch, 3))
        has_buffer = buffers.get(ch, seed.get('buffer', True))
        f, s, fa, sa = seed_values(None, ch)
        x.seed_channel(ch, category, has_buffer, f, s, fa, sa)
        nat.lib.a95o_seed(nat.h, ch, category, int(has_buffer), f, s, fa, sa)
    completed = [0] * (first + len(rows))
    for i in range(first):
        completed[i] = 1
    phases = [0] * (first + len(rows))
    compare_state(sc['id'] + ' initial', x, nat, stats)
    for ai, act in enumerate(sc['actions']):
        where = '%s action %d %s' % (sc['id'], ai, act[0])
        kind = act[0]
        if kind == 'tick':
            tick(where, x, nat, sc, rows, first, events, mode, completed, phases, stats)
        elif kind == 'vol':
            row = rows[act[1]]
            row['vol'] = act[2]
            row['body'] = struct.pack('<HB', row['ch'] & 0xFFFF, act[2]) + row['body'][3:]
            x.wr(d9.BODY_BASE + 0x40 * (first + act[1]), row['body'])
        elif kind == 'ch':
            row = rows[act[1]]
            row['ch'] = act[2]
            row['body'] = struct.pack('<HB', act[2], row['vol']) + row['body'][3:]
            x.wr(d9.BODY_BASE + 0x40 * (first + act[1]), row['body'])
        elif kind == 'setphase':
            x.w32(ROWS + (first + act[1]) * ROW + PHASE_OFF, act[2])
            phases[first + act[1]] = act[2]
        elif kind == 'events':
            for idx, v in act[1].items():
                x.wr(d9.EVENTS_VA + 4 * idx, struct.pack('<i', v))
                events[idx] = v
        elif kind == 'mode':
            mode = act[1]
            x.wr(d9.G_MODE, struct.pack('<i', mode))
        elif kind == 'device':
            device = act[1]
            x.w32(CDS + 0x1A0, device)
            nat.lib.a95o_device_ready(nat.h, device)
        elif kind == 'buffer':
            ch, present = act[1], act[2]
            x.w32(CSOUND + 4 + ch * SLOT + 0x28F, BUFFERS + 0x10 * ch if present else 0)
            category = sc['seeds'].get(ch, {}).get('cat', CATEGORY.get(ch, 3))
            f, s, fa, sa = (struct.unpack('<I', x.rd(CSOUND + 0x138 + ch * SLOT, 4))[0], struct.unpack('<I', x.rd(CSOUND + 0x13C + ch * SLOT, 4))[0],
                            x.s32(CSOUND + 0x140 + ch * SLOT), x.s32(CSOUND + 0x144 + ch * SLOT))
            nat.lib.a95o_seed(nat.h, ch, category, int(present), f, s, fa, sa)
        elif kind == 'volres':
            x.volume_hresult = act[2]
            nat.lib.a95o_volume_result(nat.h, act[1], act[2])
        else:
            raise d9.OracleError('unknown action ' + kind)
    stats['scenarios'] += 1


def tick(where, x, nat, sc, rows, first, events, mode, completed, phases, stats):
    stats['ticks'] += 1
    nat.lib.a95o_volume_clear(nat.h)
    x.dispatch()
    visited = list(x.finish_entries)
    total = first + len(rows)
    # gate model: which rows the original visited, against the expectation from the dependency records and the mode
    expected = []
    if mode == 3:
        for i in range(total):
            if i < first or completed[i]:
                continue
            if row_gate_open(rows[i - first], events):
                expected.append(i)
    stats['gate_model_checks'] += 1
    if visited != expected:
        raise Mismatch('%s: original visited rows %s, the gate model expects %s' % (where, visited, expected))
    if len(x.setter_entries) != len(visited) or x.helper_entries != len(visited):
        raise Mismatch('%s: setter/helper entries %d/%d for %d visits' % (where, len(x.setter_entries), x.helper_entries, len(visited)))
    stats['setter_entries'] += len(x.setter_entries)
    stats['helper_entries'] += x.helper_entries
    stats['rows_gated'] += sum(1 for i in range(first, total) if not completed[i] and i not in visited) if mode == 3 else 0
    # native: the same rows, in the same order, through the binding and the executor's disposition mapping
    for i in expected:
        spec = rows[i - first]
        status, done, reset, phase, disposition = nat.visit(spec['body'], spec['subtype'], completed[i], phases[i])
        if status != 0:
            raise Mismatch('%s: native handler status %d for row %d' % (where, status, i))
        completed[i], phases[i] = done, phase
        o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
        o_reset = x.resets.count(i)
        if (done, phase) != (o_done, o_phase) or reset != o_reset:
            raise Mismatch('%s: row %d native (completed %d phase %d reset %d) original (completed %d phase %d reset %d)' %
                           (where, i, done, phase, reset, o_done, o_phase, o_reset))
        stats['rows_visited'] += 1
        stats['completions'] += done
        stats['resets'] += reset
    if sorted(x.resets) != [i for i in expected if rows[i - first]['subtype'] == 2]:
        raise Mismatch('%s: dependency reset calls %s do not match the subtype-2 visits' % (where, x.resets))
    # rows the original did not visit are unchanged
    for i in range(first, total):
        if i not in expected:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (completed[i], phases[i]):
                raise Mismatch('%s: unvisited row %d changed in the original (completed %d phase %d)' % (where, i, o_done, o_phase))
    compare_state(where, x, nat, stats)
    original_volumes, native_volumes = list(x.volume_trace), nat.volumes()
    if original_volumes != native_volumes:
        raise Mismatch('%s: SetVolume calls original %s native %s' % (where, original_volumes[:6], native_volumes[:6]))
    stats['volume_calls'] += len(native_volumes)
    err = x.device()[0]
    stats['error_states'][hex(err)] += 1


def compare_state(where, x, nat, stats):
    stats['state_compares'] += 1
    original, native = x.channels(), nat.channels()
    for ch in range(32):
        stats['channel_fields'] += 4
        if original[ch] != native[ch]:
            raise Mismatch('%s: channel %d original (scalar bits %#x/%#x, attenuation %d/%d) native (%#x/%#x, %d/%d)' %
                           (where, ch, *original[ch][:2], *original[ch][2:], *native[ch][:2], *native[ch][2:]))
    if x.device() != nat.device():
        raise Mismatch('%s: device (error, state, host result) original %s native %s' % (where, x.device(), nat.device()))


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
    'scalar divisor 99': ('quotient = (double)body[2] / 100.0;', 'quotient = (double)body[2] / 99.0;', 'action_family_95.c'),
    'second scalar not stored': ('slot->second_scalar = second_scalar;', 'slot->second_scalar = slot->second_scalar;', 'sound_control.c'),
    'attenuation uses wrong constant': ('product2 = product1 * 2857.142822265625;\n    expression = product2 - 2857.142857142857;\n    return (int32_t)expression;',
                                        'product2 = product1 * 2857.0;\n    expression = product2 - 2857.142857142857;\n    return (int32_t)expression;', 'sound_control.c'),
    'master of the wrong category': ('master = state->master[slot->volume_category];', 'master = state->master[0];', 'sound_control.c'),
    'phase kept': ('out->phase = 0u; /* 0x42ba3a', 'out->phase = before->phase; /* 0x42ba3a', 'session_bindings_a95.c'),
    'row completed directly': ('out->disposition = SCENE_ACTION_HANDLER_COMPLETED;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;',
                               'session_bindings_a95.c'),
    'positive attenuation not clamped': ('if (value >= 0) return 0;', 'if (value >= 0) return value;', 'sound_control.c'),
    'volume byte read from the wrong offset': ('out->volume_percent = body[2];', 'out->volume_percent = body[1];', 'action_family_95.c'),
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
        if name == 'volume byte read from the wrong offset':
            # the decoder mutation only changes volume_percent, which the scalar does not use: mutate the scalar source too
            text = (d / filename).read_text().replace('quotient = (double)body[2] / 100.0;', 'quotient = (double)out->volume_percent / 100.0;')
            (d / filename).write_text(text)
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
    work = Path(tempfile.mkdtemp(prefix='RT-26.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver95.so')
    nat = Native(lib_path)
    x = Oracle()
    scs = scenario_list()
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
    print(json.dumps(summary, sort_keys=True))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or '')[:120])
    if args.result:
        code = [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]
        args.result.write_text(json.dumps(dict(slice='RT-26', original_sha256=d9.EXE_HASH, stats=summary, mutations=mutations,
                                              pins=code, native_library_sha256=sha(Path(lib_path).read_bytes()),
                                              seconds=round(time.monotonic() - started, 1)), indent=2, sort_keys=True) + '\n')
    nat.close()
    return 1 if bad or (mutations and any(not m['detected'] for m in mutations)) else 0


if __name__ == '__main__':
    sys.exit(main())
