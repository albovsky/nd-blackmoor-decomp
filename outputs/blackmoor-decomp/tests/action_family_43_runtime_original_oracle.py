#!/usr/bin/env python3
"""RT-32: immutable x86 dispatcher 0x427a50 (arm 0x428465, handler 0x411f24) versus the native raw-0x43 runtime.

The unmodified GAME.EXE image is mapped under Unicorn. For rows of raw type 0x43 the REAL dispatcher 0x427a50 runs:
dependency trees built by the real loader 0x424aa8, the gate 0x423f57 (mode 0) and the arm (0x428465), which calls the
handler 0x411f24 (ECX = the text owner 0x619a41, argument = the row). The handler is original x86 end to end except the
text writer: it renders the row's text with 0x413187, runs the generic completion 0x42ba3a, builds a 0xABA overlay image
(allocator 0x51dc43, defaults 0x48945b, _itoa 0x5193ca, string copies), frees the old object and stores type 0x36,
subtype 1, completion 0 and phase 0 into the row.

Native side: src/session_bindings_a43.c (with src/session_bindings_a36.c for the adopted row), driven by
tests/action_family_43_runtime_oracle_driver.c with the executor's disposition mapping. The row objects the original
receives are assembled here from the same raw bodies and AUTOTEXT strings the native side parses (the constructor 0x41137f
has its own oracle, A-43.1); the rendering writer 0x413187 is REPLACED on the original side by a recorder, and the native
side records what it hands to its writer through the binding's write_text seam. The writer itself is verified separately
(tests/autotext_writer_original_oracle.py).

Compared after every dispatcher call (tick): which rows ran the handler (observed 0x411f24) against the open-row and gate
model, the arguments of the writer call (the 301-byte entry and the text), the generic completion 0x42ba3a (once per
visited row, with the row), the dependency reset 0x423d33 (only subtype 2), the two frees (old object, scratch image), the
row's new type/subtype/completion/phase, the whole 0xABA overlay image against the native image, and the native
disposition (PENDING phase 0, or RESET_DEPENDENCIES for subtype 2) against the original's completion byte and phase.

HOOKS (everything else is original code): O = observed, R = replaced.
  O 0x428465 arm entry, 0x411f24 handler entry, 0x42ba3a completion helper, 0x423d33 dependency reset: entry observers
  R 0x413187 the text writer (recorded, returns), 0x51dc43 malloc (bump arena, zero or filled), 0x51dc6c free (recorded)
  G 0x4c97b4 0x42639d 0x50ca3e 0x52139c 0x44a2b7: fatal and logging paths, reaching one fails the run
 Windows imports are stubbed as in the 0xd9 oracle; any unexpected import fails the run. The debug flag 0x63a4cd is 0.

After a row has been compared the oracle marks it complete in the original so later ticks skip it: the row is then a
runtime-0x36 overlay whose arm (COverlay::Process) belongs to the raw 0x36 oracle.

Not modelled / unverified: allocation failure inside the handler (0x411f4d, 0x411fd8), a key missing from AUTOTEXT, the loader
0x40b34a (the oracle builds the row in memory), the writer's rendering (own oracle), objects whose text is not NUL
terminated, and the later overlay visits (raw 0x36 oracle).

Run (from outputs/blackmoor-decomp/tests):
  python3 action_family_43_runtime_original_oracle.py --mutations --result <receipt.json>
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
import action_family_67_runtime_original_oracle as a67
import conditions_nested_original_oracle as deps

ROOT = d9.ROOT
PROJECT = d9.PROJECT
PRIVATE = d9.PRIVATE
sha = d9.sha
u32 = d9.u32

ARM_ENTRY = 0x428465
HANDLER = 0x411F24
WRITER = 0x413187
FINISH = 0x42BA3A
RESET = 0x423D33
OWNER = 0x619A41
ROWS, ROW, PHASE_OFF, COMPLETE_OFF = d9.ROWS, d9.ROW, d9.PHASE_OFF, d9.COMPLETE_OFF
MAX_ROWS = 90
IMAGE = 0xABA
PREFIX = 301

PINS_TABLE = (
    (0x411f24, 0x4121b8, 'fb55837c218fe7fb72c2f3eaa899d8061c0f2cdd32c5550b6868551bf76e8635'),
    (0x413187, 0x414490, '50d8a1ab8a296ad627d4842d3915ca391ab3c4d0e6a73591dbd3de9c39b8f6b6'),
    (0x4234c8, 0x4234dd, 'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
    (0x4237f7, 0x423876, 'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
    (0x423d33, 0x423da2, 'b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e'),
    (0x423da2, 0x423f57, '10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160'),
    (0x423f57, 0x423fbb, '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x42406d, 0x424201, '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
    (0x424201, 0x424346, 'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
    (0x424346, 0x424aa8, '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
    (0x427a50, 0x42acad, '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
    (0x42ba3a, 0x42babf, '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x48945b, 0x4895cc, '799385eaa2201dd5e8137d0e30f1e96fe0d6a0cbaf4390fe3966bf987464f79a'),
    (0x5193ca, 0x5193f7, '0b10051bfe983a39084ed57ab72f0bd42db98bbb410280c695c0bf184fb02308'),
    (0x5193f7, 0x519453, '54f936226be9f51f7f9ab44240f5dbece70134c0aa2cd2fcbf98441ee7e33527'),
    (0x51dc43, 0x51dc6c, '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
    (0x51dc6c, 0x51dc77, '8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea'),
)


class Mismatch(Exception):
    pass


class Oracle(d9.X86):
    """The 0xd9 oracle's machine (imports, GDT/TIB, allocator, loader plumbing) with the 0x43 observers."""

    def __init__(self):
        super().__init__()
        self.arm_entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.writer_calls, self.freed = [], []
        self.alloc_fill = 0
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise d9.OracleError('code window pin mismatch %#x..%#x' % (a, z))

    def _install_hooks(self):
        uc = self.machine
        table = {ARM_ENTRY: self._arm, HANDLER: self._handler, WRITER: self._writer, RESET: self._reset_seen,
                 FINISH: self._finish, 0x51DC6C: self._free}
        for a in d9.GUARDS:
            table[a] = self._raise
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _arm(self, uc, address, size, user):
        ebp = uc.reg_read(X.UC_X86_REG_EBP)
        self.arm_entries.append(struct.unpack('<h', bytes(uc.mem_read(ebp - 0x11C, 2)))[0])

    def _handler(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.handler_rows.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])
        if uc.reg_read(X.UC_X86_REG_ECX) != OWNER:
            raise d9.OracleError('handler called with ECX %#x' % uc.reg_read(X.UC_X86_REG_ECX))

    def _writer(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        entry, text, rects, count = (u32(uc, sp + 4 * k) for k in (1, 2, 3, 4))
        if uc.reg_read(X.UC_X86_REG_ECX) != OWNER:
            raise d9.OracleError('writer called with ECX %#x' % uc.reg_read(X.UC_X86_REG_ECX))
        self.writer_calls.append(dict(entry=bytes(uc.mem_read(entry, PREFIX)), text=self._cstring(uc, text),
                                      text_offset=text - entry, rects=rects, count=count, entry_ptr=entry))
        self._ret(uc, 0x10, 0)

    def _reset_seen(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.resets.append((u32(uc, sp + 4) - 0x5BB5E9) // ROW)

    def _finish(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.finish_entries.append(struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0])

    def _cstring(self, uc, a, limit=70000):
        out = bytearray()
        while len(out) < limit:
            b = uc.mem_read(a + len(out), 1)[0]
            if b == 0:
                return bytes(out)
            out.append(b)
        raise d9.OracleError('unterminated string at %#x' % a)

    def _free(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        self.freed.append(u32(uc, sp + 4))
        self._ret(uc, 0, 0)

    def _malloc(self, uc):
        super()._malloc(uc)
        if self.alloc_fill:
            addr = uc.reg_read(X.UC_X86_REG_EAX)
            uc.mem_write(addr, bytes([self.alloc_fill]) * self.allocs[addr])

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
        self.mode = 'idle'
        self.expect_fatal = None
        self.alloc_fill = 0
        if self.rd(d9.G_LOG, 2) != b'\0\0':
            raise d9.OracleError('original debug flag nonzero')
        self.clear_tick()

    def clear_tick(self):
        self.arm_entries, self.handler_rows, self.finish_entries, self.resets = [], [], [], []
        self.writer_calls, self.freed = [], []

    def heap_copy(self, data):
        """Place the bytes in the oracle heap (a row object as the loader's allocation would be)."""
        start = (self.heap_cursor + 15) & ~15
        end = start + len(data) + 16
        if end > d9.HEAP_BASE + d9.HEAP_SIZE:
            raise d9.OracleError('oracle heap exhausted')
        self.heap_cursor = end
        self.heap_high = max(self.heap_high, end)
        self.wr(start, bytes(data))
        return start

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
            obj = self.heap_copy(spec['object'])
            spec['object_ptr'] = obj
            self.wr(base + 0x30, bytes([0x43, spec['subtype']]) + struct.pack('<I', obj))
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
NATIVE_SOURCES = ('session_bindings_a43.c', 'session_bindings_a36.c', 'action_family_43.c', 'action_family_37.c',
                  'action_family_36.c', 'action_family_38.c', 'action_family_36_runtime.c', 'scene_resource.c',
                  'action_core.c', 'hiff.c', 'autotext_writer.c', 'caption_layout.c')


def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_43_runtime_oracle_driver.c'),
           *[str(Path(src_dir) / s) for s in NATIVE_SOURCES], '-lm', '-o', str(out)]
    cmd[1:1] = os.environ.get('A43_CFLAGS', '').split()
    if os.environ.get('A43_SANITIZE'):
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise d9.OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    def __init__(self, path):
        self.lib = lib = C.CDLL(str(path))
        lib.a43o_new.restype = C.c_void_p
        lib.a43o_free.argtypes = [C.c_void_p]
        lib.a43o_key.argtypes = [C.c_void_p, C.c_char_p, C.c_char_p, C.c_size_t]
        lib.a43o_key.restype = C.c_int
        lib.a43o_clear_keys.argtypes = [C.c_void_p]
        lib.a43o_scene.argtypes = [C.c_void_p, C.c_uint, C.c_char_p, C.c_char_p, C.POINTER(C.c_size_t)]
        lib.a43o_scene.restype = C.c_int
        lib.a43o_fail_writes.argtypes = [C.c_void_p, C.c_int]
        lib.a43o_write_calls.argtypes = [C.c_void_p]
        lib.a43o_write_calls.restype = C.c_uint
        for name in ('a43o_entry', 'a43o_text'):
            getattr(lib, name).argtypes = [C.c_void_p]
            getattr(lib, name).restype = C.c_void_p
        lib.a43o_text_length.argtypes = [C.c_void_p]
        lib.a43o_text_length.restype = C.c_size_t
        lib.a43o_text_capacity.argtypes = [C.c_void_p]
        lib.a43o_text_capacity.restype = C.c_size_t
        lib.a43o_entry_pointer_ok.argtypes = [C.c_void_p]
        lib.a43o_entry_pointer_ok.restype = C.c_int
        lib.a43o_image.argtypes = [C.c_void_p, C.c_size_t]
        lib.a43o_image.restype = C.c_void_p
        lib.a43o_failure.argtypes = [C.c_void_p]
        lib.a43o_failure.restype = C.c_char_p
        lib.a43o_visit.argtypes = [C.c_void_p, C.c_uint, C.c_int, C.c_uint32, C.POINTER(C.c_int), C.POINTER(C.c_int),
                                   C.POINTER(C.c_uint32), C.POINTER(C.c_int), C.POINTER(C.c_int)]
        lib.a43o_visit.restype = C.c_int
        self.h = lib.a43o_new()

    def close(self):
        self.lib.a43o_free(self.h)

    def setup(self, rows, first=0):
        self.lib.a43o_clear_keys(self.h)
        placeholder = dict(body=bytes(make_prefix(random.Random(0), 0, 1, b'PLACEHOLDER')), subtype=1, key=b'PLACEHOLDER', text=b'p')
        rows = [placeholder] * first + list(rows)
        for r in rows:
            if r.get('key') is not None:
                self.lib.a43o_key(self.h, r['key'], r['text'], len(r['text']))
        bodies = b''.join(r['body'] for r in rows)
        lengths = (C.c_size_t * len(rows))(*[len(r['body']) for r in rows])
        subtypes = bytes(r['subtype'] for r in rows)
        status = self.lib.a43o_scene(self.h, len(rows), subtypes, bodies, lengths)
        if status != 0:
            raise d9.OracleError('native scene setup failed (%d)' % status)

    def visit(self, row, completed, phase):
        done, reset, new_phase, disposition, become = C.c_int(), C.c_int(), C.c_uint32(), C.c_int(), C.c_int()
        status = self.lib.a43o_visit(self.h, row, completed, phase, C.byref(done), C.byref(reset), C.byref(new_phase),
                                     C.byref(disposition), C.byref(become))
        return status, done.value, reset.value, new_phase.value, disposition.value, become.value

    def writer(self):
        n = self.lib.a43o_text_length(self.h)
        return (C.string_at(self.lib.a43o_entry(self.h), PREFIX),
                C.string_at(self.lib.a43o_text(self.h), n) if n else b'',
                self.lib.a43o_entry_pointer_ok(self.h))

    def image(self, row):
        ptr = self.lib.a43o_image(self.h, row)
        return C.string_at(ptr, IMAGE) if ptr else None


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def make_prefix(rng, surface=0, selector=1, key=b'KEY', fill='random', options=None, rect=None, geometry=None):
    """A 301-byte raw prefix. Bytes the handler does not read are random so a stray read or write shows."""
    if fill == 'random':
        p = bytearray(rng.randrange(256) for _ in range(PREFIX))
    else:
        p = bytearray([fill]) * PREFIX
    struct.pack_into('<h', p, 2, surface)
    p[0x109] = selector
    if selector:
        p[0x10A:0x10A + 33] = key[:32].ljust(33, b'\0')
    if options is not None:
        struct.pack_into('<HH', p, 0, options[0], 0) if False else None
        p[0:2] = struct.pack('<H', options[0])
        p[0xE7:0xE9] = struct.pack('<H', options[1])
    if rect is not None:
        p[0xE9:0xF9] = struct.pack('<4i', *rect)
    if geometry is not None:
        p[0xF9:0x109] = struct.pack('<4i', *geometry)
    return p


_KEYS = [0]


def keyed_row(rng, text, key=None, surface=0, subtype=1, tail=b'', **kw):
    if key is None:
        _KEYS[0] += 1
        key = b'KEY%d' % _KEYS[0]
    p = make_prefix(rng, surface, 1, key, **kw)
    obj = bytearray(p)
    obj[0x12B:0x12D] = struct.pack('<H', len(text) & 0xFFFF)
    obj += text + b'\0'
    return dict(body=bytes(p) + tail, object=bytes(obj), subtype=subtype, tail=tail, key=key, text=text)


def inline_row(rng, text, surface=0, subtype=1, tail=b'', pad=0, **kw):
    p = make_prefix(rng, surface, 0, **kw)
    count = len(text) + 1 + pad
    p[0x12B:0x12D] = struct.pack('<H', count)
    body = bytes(p) + text + b'\0' + bytes(rng.randrange(1, 256) for _ in range(pad))
    return dict(body=body + tail, object=body, subtype=subtype, tail=tail, key=None, text=text)


def scenario_list(seed=43, corpus=None):
    rng = random.Random(seed)
    scs = []

    def S(sid, rows, group='basic', ticks=4, **kw):
        scs.append(dict(id=sid, rows=rows, group=group, ticks=ticks, fill=kw.pop('fill', 0), events=kw.pop('events', {}),
                        mode=kw.pop('mode', 3), quick=kw.pop('quick', False), first=kw.pop('first', 0), acts=kw.pop('acts', None)))

    def text(n, high=False):
        return bytes(rng.randrange(1, 256 if high else 127) for _ in range(n))

    for k, (subtype, body, txt, key) in enumerate(corpus or []):
        S('corpus:%d' % k, [dict(body=body, object=corpus_object(body, txt), subtype=subtype, tail=b'', key=key, text=txt)],
          group='corpus', ticks=2, quick=k == 0)
    S('keyed:basic', [keyed_row(rng, b'Hello world')], quick=True)
    S('keyed:empty_text', [keyed_row(rng, b'')], group='text')
    S('keyed:long_text', [keyed_row(rng, text(5000))], group='text', quick=True)
    S('keyed:max_text', [keyed_row(rng, text(40000))], group='text')
    S('keyed:high_bytes', [keyed_row(rng, text(300, True))], group='text')
    S('inline:basic', [inline_row(rng, b'Inline text', surface=2)], quick=True)
    S('inline:padding', [inline_row(rng, b'abc', surface=-3, pad=40)], group='text')
    S('inline:negative_surface', [inline_row(rng, b'n', surface=-32768)], group='text')
    for surface in (0, 1, 2, 3, 4, 5, 6, 9, 0x7FFF, -1, -2, -32768):
        S('name:surface_%d' % surface, [keyed_row(rng, b'x', surface=surface)], group='name', quick=surface in (0, 5, -1, 0x7FFF))
    S('fields:options_rect_geometry', [keyed_row(rng, b'f', options=(0xFFFF, 0x8001), rect=(-5, -6, 70000, 90000),
                                                  geometry=(1, -2, 3, -4))], group='fields', quick=True)
    S('fields:zero_prefix', [keyed_row(rng, b'z', fill=0, surface=0)], group='fields')
    S('fields:ff_prefix', [keyed_row(rng, b'z', fill=0xFF, surface=7)], group='fields')
    S('alloc:fill_cd', [keyed_row(rng, b'cd', options=(1, 2), rect=(1, 2, 3, 4), geometry=(5, 6, 7, 8))], group='alloc', fill=0xCD, quick=True)
    S('alloc:fill_aa_inline', [inline_row(rng, b'aa', surface=1)], group='alloc', fill=0xAA)
    for subtype in (0, 1, 2, 3, 255):
        S('subtype:%d' % subtype, [keyed_row(rng, b's', subtype=subtype, tail=a67.event_tail(40, 1)), keyed_row(rng, b't', subtype=subtype)],
          group='subtype', events={40: 1}, quick=subtype in (1, 2))
    S('gate:event_false_then_true', [keyed_row(rng, b'g', tail=a67.event_tail(40, 1), key=b'G'), keyed_row(rng, b'h', key=b'H')],
      group='gate', events={40: 7}, acts=[('tick',), ('tick',), ('events', {40: 1}), ('tick',), ('tick',)], quick=True)
    S('gate:mode4_runs_nothing', [keyed_row(rng, b'm')], group='gate', mode=4,
      acts=[('tick',), ('tick',), ('mode', 3), ('tick',), ('tick',)])
    S('phase:preset_ignored', [keyed_row(rng, b'p'), keyed_row(rng, b'q')], group='phase',
      acts=[('setphase', 0, 2), ('setphase', 1, 77), ('tick',), ('tick',)], quick=True)
    S('rows:offset_first_row', [keyed_row(rng, b'o', key=b'A'), inline_row(rng, b'p')], group='rows', first=3)
    S('rows:many', [keyed_row(rng, text(rng.randint(1, 60)), key=b'K%d' % n, surface=n % 7 - 1) if n % 2 else
                    inline_row(rng, text(rng.randint(1, 60)), surface=n % 3 - 1) for n in range(8)], group='rows', quick=True)
    for n in range(40):
        rows = []
        for r in range(rng.randint(1, 4)):
            tail = a67.event_tail(rng.choice((40, 41)), rng.choice((1, 2))) if rng.random() < 0.3 else b''
            sub = rng.choice((0, 1, 1, 1, 2, 3))
            txt = text(rng.choice((0, 1, 5, 100, 700)), rng.random() < 0.3)
            if rng.random() < 0.6:
                rows.append(keyed_row(rng, txt, key=b'R%d_%d' % (n, r), surface=rng.randint(-3, 8), subtype=sub, tail=tail))
            else:
                rows.append(inline_row(rng, txt, surface=rng.randint(-3, 2), subtype=sub, tail=tail, pad=rng.choice((0, 0, 3))))
        S('random:%d' % n, rows, group='random', ticks=rng.randint(3, 5), fill=rng.choice((0, 0, 0xCD)),
          events={40: rng.choice((1, 2)), 41: rng.choice((1, 2))}, quick=n < 3)
    return scs


def corpus_object(body, txt):
    obj = bytearray(body[:PREFIX])
    if body[0x109] != 0:
        obj[0x12B:0x12D] = struct.pack('<H', len(txt) & 0xFFFF)
        return bytes(obj) + txt + b'\0'
    count = struct.unpack_from('<H', body, 0x12B)[0]
    return bytes(body[:PREFIX + count])


def load_corpus():
    """The decoded scene resources' raw-0x43 rows (derived by the production parser), or None when absent."""
    resources = ROOT / 'work/analysis/hiff-resources'
    if not (resources / '0001.bin').exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / 'corpus'
        built = subprocess.run([os.environ.get('CC') or shutil.which('clang') or shutil.which('cc'), '-std=c11', '-O1', f'-I{PROJECT / "src"}',
                                str(PROJECT / 'tests/action_family_43_runtime_corpus.c'),
                                *[str(PROJECT / 'src' / s) for s in (*NATIVE_SOURCES, 'autotext.c')],
                                '-lm', '-o', str(exe)], capture_output=True, text=True)
        if built.returncode != 0:
            return None
        out = subprocess.run([str(exe), '--dump', str(resources / '0001.bin'), *map(str, sorted(resources.glob('*.bin')))],
                             capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        st, body_hex, text_hex = line.split(' ')
        body = bytes.fromhex(body_hex)
        key = body[0x10A:0x10A + 33].split(b'\0')[0] if body[0x109] else None
        rows.append((int(st), body, bytes.fromhex(text_hex), key))
    return rows or None


# ---------------------------------------------------------------------------------------------
# execution and comparison
# ---------------------------------------------------------------------------------------------
def new_stats():
    return dict(scenarios=0, ticks=0, rows_entered=0, rows_visited=0, rows_gated=0, images_compared=0, image_bytes=0,
                writer_calls=0, text_bytes=0, resets=0, keyed=0, inline=0, mismatches=0, by_subtype=Counter(), groups={})


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
    nat.setup(rows, first)
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


def tick(where, x, nat, sc, rows, first, state, completed, phases, stats):
    stats['ticks'] += 1
    x.dispatch()
    total = first + len(rows)
    flags = lambda i: struct.unpack('<i', x.rd(d9.EVENTS_VA + 4 * i, 4))[0]  # noqa: E731
    expected_entered, expected = [], []
    finished_expected, resets_expected = [], []
    visits = []
    if state['mode'] == 3:
        for i in range(first, total):
            if completed[i]:
                continue
            spec = rows[i - first]
            expected_entered.append(i)
            if not a67.row_gate_open(spec, flags):
                continue
            expected.append(i)
            status, done, reset, phase, disposition, become = nat.visit(i, completed[i], phases[i])
            if status != 0:
                raise Mismatch('%s: native handler status %d for row %d (%s)' % (where, status, i, (nat.lib.a43o_failure(nat.h) or b'').decode()))
            visits.append((i, spec, done, reset, phase, become, nat.writer(), nat.image(i)))
            finished_expected.append(i)
            if reset:
                resets_expected.append(i)
    stats['rows_entered'] += len(x.arm_entries)
    if x.arm_entries != expected_entered:
        raise Mismatch('%s: the original entered the arm for rows %s, the model expects %s' % (where, x.arm_entries, expected_entered))
    if x.handler_rows != expected:
        raise Mismatch('%s: the original ran the handler for rows %s, the gate model expects %s' % (where, x.handler_rows, expected))
    if x.finish_entries != finished_expected:
        raise Mismatch('%s: the generic completion ran for rows %s, expected %s' % (where, x.finish_entries, finished_expected))
    if x.resets != resets_expected:
        raise Mismatch('%s: the original reset the dependencies of rows %s, native asked for %s' % (where, x.resets, resets_expected))
    if len(x.writer_calls) != len(expected):
        raise Mismatch('%s: %d writer calls, expected %d' % (where, len(x.writer_calls), len(expected)))
    if len(x.freed) != 2 * len(expected):
        raise Mismatch('%s: %d frees, expected %d' % (where, len(x.freed), 2 * len(expected)))
    stats['rows_gated'] += len(expected_entered) - len(expected)
    for (i, spec, done, reset, phase, become, (entry, text, entry_ok), image), call, (old_ptr, scratch) in zip(
            visits, x.writer_calls, zip(x.freed[0::2], x.freed[1::2])):
        base = ROWS + i * ROW
        o_type, o_sub = x.rd(base + 0x30, 2)
        o_ptr = struct.unpack('<I', x.rd(base + 0x32, 4))[0]
        o_done = x.rd(base + COMPLETE_OFF, 1)[0]
        o_phase = struct.unpack('<I', x.rd(base + PHASE_OFF, 4))[0]
        o_image = bytes(x.rd(o_ptr, IMAGE))
        what = '%s row %d (subtype %d)' % (where, i, spec['subtype'])
        if call['rects'] != 0 or call['count'] != 0 or call['text_offset'] != 0x12D or call['entry_ptr'] != spec['object_ptr']:
            raise Mismatch('%s: writer called with unexpected arguments %r' % (what, {k: v for k, v in call.items() if k not in ('entry', 'text')}))
        if old_ptr != spec['object_ptr']:
            raise Mismatch('%s: the original freed %#x first, expected the old object %#x' % (what, old_ptr, spec['object_ptr']))
        if (o_type, o_sub) != (0x36, 1) or o_done != 0 or o_phase != 0:
            raise Mismatch('%s: original row after the visit type %#x subtype %d completed %d phase %d' % (what, o_type, o_sub, o_done, o_phase))
        if become != 1:
            raise Mismatch('%s: native did not convert the row' % what)
        if (done, phase) != (o_done, o_phase):
            raise Mismatch('%s: native (completed %d phase %d reset %d) original (completed %d phase %d)' % (what, done, phase, reset, o_done, o_phase))
        if not entry_ok or call['entry'] != entry:
            raise Mismatch('%s: the entry handed to the writer differs' % what)
        if call['text'] != text:
            raise Mismatch('%s: the text handed to the writer differs (original %d bytes, native %d bytes)' % (what, len(call['text']), len(text)))
        if image is None or image != o_image:
            j = next((k for k in range(IMAGE) if image is None or image[k] != o_image[k]), -1)
            raise Mismatch('%s: overlay image differs at byte %#x' % (what, j))
        stats['images_compared'] += 1
        stats['image_bytes'] += IMAGE
        stats['writer_calls'] += 1
        stats['text_bytes'] += len(text)
        stats['resets'] += reset
        stats['rows_visited'] += 1
        stats['keyed' if spec['key'] is not None else 'inline'] += 1
        stats['by_subtype'][spec['subtype']] += 1
        # the row is a runtime-0x36 overlay now: mark it complete in the original so later ticks skip it
        completed[i] = 1
        phases[i] = 0
        x.wr(base + COMPLETE_OFF, b'\1')
    for i in range(first, total):
        if i not in expected and not completed[i]:
            o_done = x.rd(ROWS + i * ROW + COMPLETE_OFF, 1)[0]
            o_phase = struct.unpack('<I', x.rd(ROWS + i * ROW + PHASE_OFF, 4))[0]
            if (o_done, o_phase) != (0, phases[i]) or x.rd(ROWS + i * ROW + 0x30, 1)[0] != 0x43:
                raise Mismatch('%s: unvisited row %d changed in the original' % (where, i))


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
    'no subtype-2 dependency reset': ('out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_BECOME_OVERLAY36\n                                              : SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36;', 'session_bindings_a43.c'),
    'dependency reset for every subtype': ('out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_BECOME_OVERLAY36\n                                              : SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36;', 'out->disposition = SCENE_ACTION_HANDLER_RESET_BECOME_OVERLAY36;', 'session_bindings_a43.c'),
    'phase kept': ('out->phase = 0u;\n    return SCENE_ACTION_HANDLER_OK;', 'out->phase = before->phase;\n    return SCENE_ACTION_HANDLER_OK;', 'session_bindings_a43.c'),
    'row not converted': ('SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36;', 'SCENE_ACTION_HANDLER_PENDING;', 'session_bindings_a43.c'),
    'surface number off by one': ('(int)(int16_t)rd16(object + 2u) + 1;', '(int)(int16_t)rd16(object + 2u) + 0;', 'session_bindings_a43.c'),
    'name prefix': ('"USE_AUTOTEXT%d"', '"USE_AUTOTEXT_%d"', 'session_bindings_a43.c'),
    'first option word offset': ('memcpy(body + 0x21u, object + 0u, 2u);', 'memcpy(body + 0x21u, object + 2u, 2u);', 'session_bindings_a43.c'),
    'second option word offset': ('memcpy(body + 0x23u, object + 0xe7u, 2u);', 'memcpy(body + 0x23u, object + 0xe5u, 2u);', 'session_bindings_a43.c'),
    'rectangle offset': ('memcpy(body + 0x25u, object + 0xe9u, 16u);', 'memcpy(body + 0x25u, object + 0xedu, 16u);', 'session_bindings_a43.c'),
    'geometry offset': ('memcpy(body + 0x35u, object + 0xf9u, 16u);', 'memcpy(body + 0x35u, object + 0xfdu, 16u);', 'session_bindings_a43.c'),
    'text start': ('status = b->host.write_text(b->host.context, object,\n                                    (const char *)object + ACTION_FAMILY_43_PREFIX_BYTES,', 'status = b->host.write_text(b->host.context, object,\n                                    (const char *)object + ACTION_FAMILY_43_PREFIX_BYTES + 1u,', 'session_bindings_a43.c'),
    'keyed text without its NUL': ('resolved_length += 1u;', 'resolved_length += 0u;', 'session_bindings_a43.c'),
    'key length overshoots': ('++key_length;', 'key_length += 2u;', 'session_bindings_a43.c'),
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
    work = Path(tempfile.mkdtemp(prefix='RT-32b.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver43.so')
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
