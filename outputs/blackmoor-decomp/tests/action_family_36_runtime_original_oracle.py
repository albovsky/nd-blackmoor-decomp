#!/usr/bin/env python3
"""RT-14: original-x86 oracle for the raw 0x36 static overlay runtime (COverlay).

Runs the unmodified original under Unicorn:

    0x428083  dispatcher arm 0x36 -> real dependency gate 0x423f57 (empty tree)
              -> 0x4899ca COverlay::Process (phase 0 registration + phase 1 +
                 phase 2) with its real callees 0x50d0bc, 0x4c948f, 0x4d39f9,
                 0x4d36ed, 0x50ce04 (x87), 0x42ba3a
    0x4897cd  COverlay hit test
    0x48a3db  render callback

Hooks (every one is enumerated in the report; none replaces a decision the
original makes):

  replacement  0x4c2790  CIFTREE surface load (ret 0x10), returns a surface id
                         derived from the name
  replacement  0x4fb77a  sound record start (ret 4), records record+word
  replacement  0x4fb2e3  sound start word (ret 4), folded into the record above
  replacement  0x4f6334  sound query (ret 4), scripted result
  replacement  0x4fba69  sound stop (ret 4), records the record
  replacement  0x4c5377 / 0x4c5d4b  blits (ret 0x14), record the arguments
  replacement  0x423d33  dependency tree reset (ret 4), recorded
  replacement  IAT 0x52a23c GetTickCount, scripted values
  fatal sinks  0x50ca3e 0x52139c 0x4c97b4 0x44a2b7: the original reports an
               error and tears down; reaching one stops the run. Used to PROVE
               the native rejections (list/slot/cache exhaustion, draw slot
               mismatch); no valid case may reach one.
  observation  every memory write (classified), provider-call state snapshots

Compared after EVERY operation: the ordered stream of provider calls (each with
a snapshot of the manager/render/cache/image state at that moment) merged with
the ordered stream of world stores, plus the full state: manager, list, render
table, surface cache, every row image (0xABA bytes), event array, world
scalars, row phase/completion/request cells. The original's complete write
footprint must stay inside those cells and the stack.

    work/tools/oracle-python/bin/python \\
      outputs/blackmoor-decomp/tests/action_family_36_runtime_original_oracle.py
"""
import argparse
import hashlib
import json
from pathlib import Path
import random
import struct
import sys
import time
import zlib

from cif_original_oracle import PEImage, align_up
import test_action_family_36_runtime as native

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'work/analysis/slices/RT-14.oracle.json'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

CODE_WINDOWS = [
    (0x428083, 0x4280be, 'dispatcher arm 0x36',
     '5e56dabcd602aa146d0b1874b5c784ef43f9f36dc5a97c29559828857f45131a'),
    (0x4899ca, 0x48a3cb, 'COverlay::Process 0x4899ca',
     '24525b7f7229a0202c810a031853f6a88ee033ac1e07b4d3c58bb87c755b1d66'),
    (0x48a3db, 0x48a5eb, 'render callback 0x48a3db',
     'fa1c571827b29129694af10d621255d0ababe74411e3f17c646165eb987f28d6'),
    (0x4897cd, 0x4899ca, 'COverlay hit test 0x4897cd',
     '715a602f9a6f12d750b580d6d7e6d51b73adab4e076b9bd4b531a3d96628423f'),
    (0x42ba3a, 0x42babf, 'finish helper 0x42ba3a',
     '066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909'),
    (0x4d39f9, 0x4d3a51, 'first free render slot 0x4d39f9',
     'cbbec82f09b8b5bd1e6a5bc6385c7bf610ab2596622448a2548366508e3f81ae'),
    (0x4c948f, 0x4c94ec, 'first free cache slot 0x4c948f',
     '0b8219b7d88ac84ec24522564e2fd3a1b319f6e14431ec3a68c70fb75e894bc6'),
    (0x4d36ed, 0x4d3705, 'redraw request 0x4d36ed',
     '9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd'),
    (0x50d0bc, 0x50d1f0, 'strupr 0x50d0bc',
     'fce171988109dc8585e9190c7cd14a5e9d392385a5c3f2fcf08be21100087666'),
    (0x50ce04, 0x50ce2b, 'float to int 0x50ce04',
     'd0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c'),
    (0x423f57, 0x423fbb, 'dependency gate 0x423f57',
     '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
    (0x4234c8, 0x4234dd, 'gate reset 0x4234c8',
     'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
]

STACK, STACK_SIZE = 0x10000000, 0x40000
OBJ_BASE, OBJ_SIZE, OBJ_STRIDE = 0x30000000, 0x100000, 0x1000
STUBS = 0x31000000
STUB_RET = STUBS + 0x10
STUB_TICK = STUBS + 0x100
FRAME = STACK + 0x30000
IAT_TICK = 0x52a23c

MGR = 0x619935
GATE_OBJECT, GATE_FLAG = 0x63786d, 0x5c3a47
ROW_BASE, ROW_STRIDE = 0x5bb5e3, 0x8d
RENDER_BASE, RENDER_STRIDE = 0x5d1591, 0x4a
CACHE_BASE = 0x5d02cb
EVENT_BASE = 0x585801
EVENT_COUNT = 1100

SINKS = {0x50ca3e: 'error report 0x50ca3e', 0x52139c: 'error report 0x52139c',
         0x4c97b4: 'teardown 0x4c97b4', 0x44a2b7: 'debug dump 0x44a2b7'}
REPLACE = {0x4c2790: ('load', 0x10), 0x4fb77a: ('sound_start', 4), 0x4fb2e3: ('sound_word', 4),
           0x4f6334: ('sound_query', 4), 0x4fba69: ('sound_stop', 4), 0x4c5377: ('blit_plain', 0x14),
           0x4c5d4b: ('blit_keyed', 0x14), 0x423d33: ('reset_deps', 4)}

# world cell name -> (address, size) ; written by the family
WORLD_OUT = {
    'start_flag_5bb1ca': (0x5bb1ca, 4), 'mode_583999': (0x583999, 4),
    'xfer_5bb57b': (0x5bb57b, 4), 'xfer_5bb599': (0x5bb599, 2), 'xfer_5bb595': (0x5bb595, 2),
    'xfer_5c39ff': (0x5c39ff, 2), 'xfer_5bb59b': (0x5bb59b, 4), 'xfer_5bb59f': (0x5bb59f, 4),
    'xfer_5bb5a3': (0x5bb5a3, 4), 'redraw_5831c8': (0x5831c8, 4), 'redraw_5831c6': (0x5831c6, 2),
    'cursor_index': (0x5b44f0, 4), 'cursor_variant': (0x5b44f4, 4), 'cursor_surface': (0x5d162d, 4),
    'cursor_table': (0x5d1631, 4), 'cursor_layer': (0x5d1639, 4), 'candidate': (0x5c39e5, 4),
}
# read-only inputs (the family never writes them)
WORLD_IN = {
    'selector': (0x5bb50b, 2), 'held_item': (0x583a29, 2), 'view_x': (0x583186, 4),
    'view_y': (0x58318a, 4), 'background_surface': (0x5d15e3, 4), 'item_flag_5b44f8': (0x5b44f8, 4),
    'cursor_surface_default': (0x5d0377, 4), 'cursor_surface_held': (0x571ad3, 4),
}
AUTOTEXT = (0x5d0397, 0x5d039b, 0x5d039f)
BACKBUFFER = 0x5cf665
ADDR_NAME = {address: name for name, (address, _) in WORLD_OUT.items()}
XFER_ORDER = ('xfer_5bb57b', 'xfer_5bb599', 'xfer_5bb595', 'xfer_5c39ff', 'xfer_5bb59b',
              'xfer_5bb59f', 'xfer_5bb5a3')
SIGNED = {2: '<h', 4: '<i'}


class OracleError(AssertionError):
    pass


def sha(data):
    return hashlib.sha256(data).hexdigest()


def surface_id(name):
    return 0x2000 + (zlib.crc32(bytes(name)) & 0xffff)


def obj_va(row):
    return OBJ_BASE + row * OBJ_STRIDE


def row_of_pointer(pointer):
    if OBJ_BASE <= pointer < OBJ_BASE + OBJ_SIZE:
        return (pointer - OBJ_BASE) // OBJ_STRIDE
    return -1


def record_of_pointer(pointer):
    row = row_of_pointer(pointer)
    if row < 0:
        return -1
    offset = pointer - obj_va(row) - 0x6ec
    return offset // 38 if offset >= 0 and offset % 38 == 0 else -2


def phase_va(row):
    return ROW_BASE + 0x4f + row * ROW_STRIDE


def complete_va(row):
    return ROW_BASE + 0x42 + row * ROW_STRIDE


def request_va(row):
    return ROW_BASE + 0x43 + row * ROW_STRIDE


def objptr_va(row):
    return ROW_BASE + 2 + row * ROW_STRIDE


def subtype_va(row):
    return ROW_BASE + 1 + row * ROW_STRIDE


def tree_va(row):
    return ROW_BASE + 6 + row * ROW_STRIDE


def render_va(slot):
    return RENDER_BASE + slot * RENDER_STRIDE


class Original:
    def __init__(self, pe, fpcw=0x27f):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
        from unicorn import x86_const as x
        self.regs = {n: getattr(x, 'UC_X86_REG_' + n) for n in
                     ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'FPCW')}
        self.uc = uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(pe.image_base, align_up(pe.size_of_image))
        uc.mem_write(pe.image_base, pe.image)
        uc.mem_map(STACK, STACK_SIZE)
        uc.mem_map(OBJ_BASE, OBJ_SIZE)
        uc.mem_map(STUBS, 0x1000)
        uc.mem_write(STUB_RET, b'\xc3')
        uc.mem_write(STUB_TICK, b'\xc3')
        uc.mem_write(IAT_TICK, struct.pack('<I', STUB_TICK))
        self.fpcw = fpcw
        self.R = x
        self.trace = []
        self.fatal = None
        self.hook_counts = {}
        self.write_log = []
        self.ticks = [0]
        self.query = 1
        self.snap_row = None
        self.observing = False
        self.window_hits = {}
        for address in list(SINKS) + list(REPLACE) + [STUB_TICK]:
            uc.hook_add(UC_HOOK_CODE, self.on_code, begin=address, end=address)
        for address in (0x4899ca, 0x48a3db, 0x4897cd, 0x42ba3a, 0x4d39f9, 0x4c948f, 0x4d36ed,
                        0x50d0bc, 0x50ce04, 0x423f57):
            uc.hook_add(UC_HOOK_CODE, self.on_observe, begin=address, end=address)
        uc.hook_add(UC_HOOK_MEM_WRITE, self.on_write)
        self.pe = pe

    # ---- helpers ------------------------------------------------------
    def r32(self, va):
        return struct.unpack('<I', self.uc.mem_read(va, 4))[0]

    def s32(self, va):
        return struct.unpack('<i', self.uc.mem_read(va, 4))[0]

    def s16(self, va):
        return struct.unpack('<h', self.uc.mem_read(va, 2))[0]

    def count(self, name):
        self.hook_counts[name] = self.hook_counts.get(name, 0) + 1

    def read_cstr(self, va, limit=64):
        data = bytes(self.uc.mem_read(va, limit))
        return data.split(b'\0')[0]

    def rect(self, va):
        return struct.unpack('<4i', self.uc.mem_read(va, 16))

    def snapshot(self):
        if not self.snapshotter:
            return None
        return self.snapshotter()

    # ---- hooks ----------------------------------------------------------
    def replace(self, pop, eax=None):
        uc, r = self.uc, self.regs
        esp = uc.reg_read(r['ESP'])
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        if eax is not None:
            uc.reg_write(r['EAX'], eax & 0xffffffff)
        uc.reg_write(r['ESP'], esp + 4 + pop)
        uc.reg_write(r['EIP'], ret)

    def on_observe(self, uc, address, size, user):
        self.count('observe 0x%x entry' % address)

    def on_code(self, uc, address, size, user):
        r = self.regs
        esp = uc.reg_read(r['ESP'])
        arg = lambda i: struct.unpack('<I', uc.mem_read(esp + 4 + 4 * i, 4))[0]
        if address in SINKS:
            self.fatal = SINKS[address]
            self.count('FATAL SINK ' + SINKS[address])
            uc.emu_stop()
            return
        if address == STUB_TICK:
            value = self.ticks.pop(0) if len(self.ticks) > 1 else self.ticks[0]
            self.trace.append(('hook', 'tick', value, self.snapshot()))
            self.count('REPLACE IAT 0x52a23c GetTickCount (scripted)')
            uc.reg_write(r['EAX'], value)
            return
        kind, pop = REPLACE[address]
        if kind == 'load':
            name = self.read_cstr(arg(1), 40)
            if self.read_cstr(arg(0), 16) != b'CIFTREE' or arg(2) != 6:
                raise OracleError('unexpected surface-load arguments')
            self.trace.append(('hook', 'load', name, self.snapshot()))
            self.count('REPLACE 0x4c2790 CIFTREE surface load')
            self.replace(pop, surface_id(name))
        elif kind == 'sound_start':
            self.pending_sound = bytes(uc.mem_read(arg(0), 9))
            self.count('REPLACE 0x4fb77a sound record start')
            self.replace(pop, 1)
        elif kind == 'sound_word':
            word = arg(0) & 0xffff
            self.trace.append(('hook', 'sound_start', self.pending_sound, word, self.snapshot()))
            self.count('REPLACE 0x4fb2e3 sound start word')
            self.replace(pop, 1)
        elif kind == 'sound_query':
            word = arg(0) & 0xffff
            self.trace.append(('hook', 'sound_playing', word, self.snapshot()))
            self.count('REPLACE 0x4f6334 sound query (scripted)')
            self.replace(pop, self.query)
        elif kind == 'sound_stop':
            self.trace.append(('hook', 'sound_stop', bytes(uc.mem_read(arg(0), 9)), self.snapshot()))
            self.count('REPLACE 0x4fba69 sound stop')
            self.replace(pop, 1)
        elif kind in ('blit_plain', 'blit_keyed'):
            src_surface, dst_surface, src_rect, dst_rect, label = arg(0), arg(1), arg(2), arg(3), arg(4)
            if dst_surface != self.r32(BACKBUFFER):
                raise OracleError('blit destination is not the back buffer')
            self.trace.append(('hook', 'blit', 1 if kind == 'blit_plain' else 2, src_surface,
                               self.rect(src_rect), self.rect(dst_rect),
                               self.read_cstr(label, 64), self.snapshot()))
            self.count('REPLACE 0x%x blit' % address)
            self.replace(pop, 1)
        elif kind == 'reset_deps':
            self.trace.append(('hook', 'reset_deps', arg(0), self.snapshot()))
            self.count('REPLACE 0x423d33 dependency tree reset')
            self.replace(pop)

    def on_write(self, uc, access, address, size, value, user):
        value &= (1 << (8 * size)) - 1
        self.write_log.append((address, size, value))
        if not self.observing or STACK <= address < STACK + STACK_SIZE:
            return
        signed = struct.unpack(SIGNED[size], struct.pack('<I' if size == 4 else '<H', value))[0] \
            if size in SIGNED else value
        if EVENT_BASE <= address < EVENT_BASE + 4 * EVENT_COUNT and size == 4 and (address - EVENT_BASE) % 4 == 0:
            self.trace.append(('w', 'ev', (address - EVENT_BASE) // 4, signed))
        elif address == 0x5bb1ca:
            self.trace.append(('w', 'start_flag', signed))
        elif address == 0x5831c8:
            self.trace.append(('w', 'redraw', signed))
        elif address == 0x5831c6:
            self.trace.append(('w', 'redraw6', signed))
        elif address in ADDR_NAME and ADDR_NAME[address] in XFER_ORDER:
            self.trace.append(('w', 'xfer', address, signed))
        elif address == 0x583999:
            self.trace.append(('w', 'mode', signed))
        elif address in (0x5b44f0, 0x5b44f4, 0x5d162d, 0x5d1631, 0x5d1639, 0x5c39e5):
            self.trace.append(('w', 'cur', address, signed))
        elif ROW_BASE <= address < ROW_BASE + self.rows * ROW_STRIDE:
            row, offset = divmod(address - ROW_BASE, ROW_STRIDE)
            name = {0x43: 'request', 0x4f: 'phase', 0x42: 'complete'}.get(offset)
            if name is not None:
                self.trace.append(('w', name, row, signed))

    # ---- state ----------------------------------------------------------
    def load(self, case):
        """Install the case's initial state (noise everywhere unmodeled)."""
        uc = self.uc
        rng = random.Random(case['seed'])
        self.rows = case['rows']
        self.snapshotter = None
        # unmodeled neighbourhood noise
        uc.mem_write(MGR + 0x2c + 40 * 4, bytes(rng.randrange(256) for _ in range(0x20)))
        uc.mem_write(GATE_OBJECT, bytes(rng.randrange(256) for _ in range(0x700)))
        uc.mem_write(GATE_FLAG, struct.pack('<I', 0x12345678))
        # Slots 0..23 belong to other users of the render table (the cursor layer words
        # 0x5d162d.. and the saved background 0x5d15e3 live in them); the overlay family
        # only allocates 24..63.
        for slot in range(24, 64):
            uc.mem_write(render_va(slot), bytes(rng.randrange(256) for _ in range(RENDER_STRIDE)))
        uc.mem_write(CACHE_BASE, bytes(rng.randrange(256) for _ in range(24 * 4)))
        # images
        for row in range(self.rows):
            image = case['images'].get(row)
            uc.mem_write(objptr_va(row), struct.pack('<I', obj_va(row) if image is not None else 0))
            if image is not None:
                uc.mem_write(obj_va(row), bytes(image))
            uc.mem_write(subtype_va(row), bytes([case['subtypes'].get(row, 1)]))
            uc.mem_write(phase_va(row), struct.pack('<I', case['phases'].get(row, 0)))
            uc.mem_write(complete_va(row), b'\0')
            uc.mem_write(request_va(row), struct.pack('<I', rng.randrange(1, 2 ** 32)))
            uc.mem_write(tree_va(row), struct.pack('<II', rng.randrange(2 ** 32), 0))
        # events
        uc.mem_write(EVENT_BASE, struct.pack('<%di' % EVENT_COUNT, *case['events']))
        # world
        for name, value in case['world'].items():
            if name in WORLD_OUT:
                address, size = WORLD_OUT[name]
            elif name in WORLD_IN:
                address, size = WORLD_IN[name]
            else:
                continue
            uc.mem_write(address, struct.pack(SIGNED[size], value))
        for i, address in enumerate(AUTOTEXT):
            uc.mem_write(address, struct.pack('<I', case['autotext'][i]))
        uc.mem_write(BACKBUFFER, struct.pack('<I', 0xBACF))
        # manager
        m = case['manager']
        uc.mem_write(MGR + 0xcc, struct.pack('<i', m['count']))
        for i in range(40):
            row = m['list'][i]
            uc.mem_write(MGR + 0x2c + 4 * i, struct.pack('<I', obj_va(row) if row >= 0 else 0))
        uc.mem_write(MGR + 0x1c, struct.pack('<II', 0, 0))
        uc.mem_write(MGR + 0x24, struct.pack('<I', 0))
        uc.mem_write(MGR + 0x28, struct.pack('<I', m['tick']))
        for slot in range(24, 64):
            e = m['render'][slot]
            base = render_va(slot)
            uc.mem_write(base, struct.pack('<iIIiiii', e['layer'], e['callback'], e['surface'],
                                           e['f0c'], e['f10'], e['visible'], e['active']))
            uc.mem_write(base + 0x1e, struct.pack('<I', obj_va(e['row']) if e['row'] >= 0 else 0))
            uc.mem_write(base + 0x22, bytes(e['tag']))
        for k in range(24):
            uc.mem_write(CACHE_BASE + 4 * k, struct.pack('<I', m['cache'][k]))
        self.baseline = None

    def modeled_ranges(self):
        ranges = [(MGR + 0x1c, 0x14), (MGR + 0x2c, 40 * 4), (MGR + 0xcc, 4),
                  (render_va(24), 40 * RENDER_STRIDE), (CACHE_BASE, 24 * 4),
                  (EVENT_BASE, 4 * EVENT_COUNT), (OBJ_BASE, OBJ_SIZE),
                  (GATE_OBJECT + 4, 4), (GATE_OBJECT + 0x614, 4), (GATE_FLAG, 4),
                  (STACK, STACK_SIZE)]
        for address, size in WORLD_OUT.values():
            ranges.append((address, size))
        for row in range(self.rows):
            ranges += [(request_va(row), 4), (phase_va(row), 4), (complete_va(row), 1)]
        return ranges

    def footprint_ok(self, writes):
        ranges = self.modeled_ranges()
        bad = []
        for address, size, _ in writes:
            if not any(start <= address and address + size <= start + length for start, length in ranges):
                bad.append((address, size))
        return bad

    def state(self):
        r32, s32, s16 = self.r32, self.s32, self.s16
        count = s32(MGR + 0xcc)
        state = dict(
            count=count,
            list=[row_of_pointer(r32(MGR + 0x2c + 4 * i)) for i in range(40)],
            cur_row=row_of_pointer(r32(MGR + 0x1c)),
            cur_row2=row_of_pointer(r32(MGR + 0x20)),
            cur_rec=record_of_pointer(r32(MGR + 0x24)),
            tick=r32(MGR + 0x28),
            render=[], cache=[r32(CACHE_BASE + 4 * k) for k in range(24)])
        for slot in range(24, 64):
            b = render_va(slot)
            state['render'].append((s32(b), 1 if r32(b + 4) else 0, r32(b + 8), s32(b + 0xc),
                                    s32(b + 0x10), s32(b + 0x14), s32(b + 0x18),
                                    row_of_pointer(r32(b + 0x1e)),
                                    bytes(self.uc.mem_read(b + 0x22, 16))))
        state['images'] = {row: bytes(self.uc.mem_read(obj_va(row), native.IMAGE_BYTES))
                           for row in range(self.rows) if r32(objptr_va(row)) != 0}
        state['events'] = list(struct.unpack('<%di' % EVENT_COUNT,
                                             self.uc.mem_read(EVENT_BASE, 4 * EVENT_COUNT)))
        world = {}
        for name, (address, size) in list(WORLD_OUT.items()) + list(WORLD_IN.items()):
            world[name] = struct.unpack(SIGNED[size], self.uc.mem_read(address, size))[0]
        state['world'] = world
        state['rows'] = {row: (r32(phase_va(row)), self.uc.mem_read(complete_va(row), 1)[0],
                               r32(request_va(row))) for row in range(self.rows)}
        return state

    # ---- execution --------------------------------------------------------
    def prime(self, rng):
        uc, r = self.uc, self.regs
        initial = dict(EAX=rng.randrange(2 ** 32), EBX=rng.randrange(2 ** 32), ECX=rng.randrange(2 ** 32),
                       EDX=rng.randrange(2 ** 32), ESI=rng.randrange(2 ** 32), EDI=rng.randrange(2 ** 32))
        for name, value in initial.items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['EFLAGS'], 0x202)
        uc.reg_write(r['FPCW'], self.fpcw)
        return initial

    def run(self, entry, until, esp, ebp, ecx=None, rng=None, preset=None):
        uc, r = self.uc, self.regs
        rng = rng or random.Random(0)
        initial = self.prime(rng)
        uc.reg_write(r['EBP'], ebp)
        uc.reg_write(r['ESP'], esp)
        if ecx is not None:
            uc.reg_write(r['ECX'], ecx)
        self.trace = []
        self.write_log = []
        self.fatal = None
        self.observing = True
        uc.emu_start(entry, until, count=3000000)
        self.observing = False
        if self.fatal:
            return 'fatal'
        if uc.reg_read(r['EIP']) != until:
            raise OracleError('original did not reach its stop address (%#x)' % uc.reg_read(r['EIP']))
        for name in ('EBX', 'ESI', 'EDI'):
            if uc.reg_read(r[name]) != initial[name]:
                raise OracleError('callee-saved %s changed' % name)
        return 'ok'

    def arm(self, row, rng):
        uc = self.uc
        uc.mem_write(STACK, bytes(STACK_SIZE))
        uc.mem_write(FRAME - 0x11c, struct.pack('<h', row))
        uc.mem_write(tree_va(row), struct.pack('<II', rng.randrange(2 ** 32), 0))
        esp = FRAME - 0x400
        status = self.run(0x428083, 0x42a9a9, esp, FRAME, rng=rng)
        if status == 'ok' and uc.reg_read(self.regs['ESP']) != esp:
            raise OracleError('arm left the stack unbalanced')
        return status

    def hit(self, x, y, rng):
        uc, r = self.uc, self.regs
        uc.mem_write(STACK, bytes(STACK_SIZE))
        esp = FRAME - 0x400
        # first push = Y (cursor +0x5a), second = X (cursor +0x5e); upper halves are noise
        y_arg = (rng.randrange(65536) << 16) | (y & 0xffff)
        x_arg = (rng.randrange(65536) << 16) | (x & 0xffff)
        esp -= 4
        uc.mem_write(esp, struct.pack('<I', y_arg))
        esp -= 4
        uc.mem_write(esp, struct.pack('<I', x_arg))
        esp -= 4
        uc.mem_write(esp, struct.pack('<I', STUB_RET))
        status = self.run(0x4897cd, STUB_RET, esp, FRAME, ecx=MGR, rng=rng)
        if status == 'ok':
            if uc.reg_read(r['ESP']) != esp + 12:
                raise OracleError('hit test left the stack unbalanced (ret 8)')
            return status, uc.reg_read(r['EAX'])
        return status, None

    def draw(self, slot, rng):
        uc, r = self.uc, self.regs
        uc.mem_write(STACK, bytes(STACK_SIZE))
        esp = FRAME - 0x400
        esp -= 4
        # the render pump pushes the slot as a full dword (`push edx`)
        uc.mem_write(esp, struct.pack('<I', slot))
        esp -= 4
        uc.mem_write(esp, struct.pack('<I', STUB_RET))
        status = self.run(0x48a3db, STUB_RET, esp, FRAME, rng=rng)
        if status == 'ok' and uc.reg_read(r['ESP']) != esp + 4:
            raise OracleError('draw callback must be cdecl')
        return status


# ---- case construction ------------------------------------------------------

def blank_manager(rng, tick=0):
    return dict(count=0, list=[-1] * 40, tick=tick, cache=[0] * 24,
                render=[dict(layer=rng.randrange(-5, 30), callback=rng.choice((0, 0x48a3db, 0x401000)),
                             surface=rng.randrange(2 ** 32), f0c=rng.randrange(100), f10=rng.randrange(100),
                             visible=rng.choice((0, 1)), active=0, row=-1,
                             tag=bytes(rng.randrange(256) for _ in range(16))) for _ in range(64)])


FOREIGN_TAG = b'UI FOREIGN ENTRY'


def occupy_foreign(case, rng, render_slots=(), cache_slots=()):
    for slot in render_slots:
        e = case['manager']['render'][slot]
        e.update(active=1, visible=1, callback=0x401000, row=-1, tag=FOREIGN_TAG,
                 surface=0xF000 + slot, layer=rng.randrange(0, 20))
    for k in cache_slots:
        case['manager']['cache'][k] = 0xE000 + k


def noisy_image(image, rng):
    """Initial runtime/uninitialised bytes are noise (malloc'd memory)."""
    out = bytearray(image)
    # the gap between the primary table and the secondary table, the tail up to the runtime
    # fields and the runtime fields themselves are not written by the constructor
    return bytes(out)


def base_case(seed, images, *, subtypes=None, phases=None, selector=0, held=-1, item_flag=0,
              event_values=None, rng=None, tick=0):
    rng = rng or random.Random(seed)
    rows = len(images)
    events = [rng.choice((0, 0, 0, 1, 2, 3, -1, 7)) for _ in range(EVENT_COUNT)]
    for index, value in (event_values or {}).items():
        events[index] = value
    case = dict(seed=seed, rows=rows, subtypes=dict(subtypes or {}), phases=dict(phases or {}),
                events=events, autotext=[0x501, 0x502, 0x503],
                world={name: rng.randrange(-1000, 1000) for name in WORLD_OUT},
                manager=blank_manager(rng, tick))
    case['images'] = {}
    for row, image in enumerate(images):
        if image is None:
            continue
        data = bytearray(image)
        # runtime bytes and every byte the constructor leaves alone start as noise
        for offset in range(0xaa2, 0xaba):
            data[offset] = rng.randrange(256)
        case['images'][row] = bytes(data)
    case['world'].update(selector=selector, held_item=held, view_x=10, view_y=10,
                         background_surface=0x700, item_flag_5b44f8=item_flag,
                         cursor_surface_default=0x1111, cursor_surface_held=0x2222)
    return case


class Pair:
    """Original machine + native rig driven by the same operations."""

    def __init__(self, pe, lib, case, fpcw=0x27f):
        self.case = case
        self.rng = random.Random(case['seed'] ^ 0x36)
        self.original = Original(pe, fpcw)
        self.original.load(case)
        images = [case['images'].get(row) for row in range(case['rows'])]
        self.rig = native.Rig(lib, images, event_count=EVENT_COUNT, selector=0, held=-1)
        self.lib = lib
        self.rig.surface_fn = surface_id
        for i, value in enumerate(case['events']):
            self.rig.events[i] = value
        w = self.rig.world
        for name in native_world_fields():
            if name in case['world']:
                setattr(w, NATIVE_NAME.get(name, name), case['world'][name])
        for i in range(3):
            w.autotext_surface[i] = case['autotext'][i]
        w.background_surface = case['world']['background_surface']
        w.view_x, w.view_y = case['world']['view_x'], case['world']['view_y']
        self.native_phases = dict(case['phases'])
        self.rig.phases = self.native_phases
        m = case['manager']
        nm = self.rig.manager
        nm.count = m['count']
        for i in range(40):
            nm.list[i] = m['list'][i]
        nm.current_row = -1
        nm.current_record = -1
        nm.tick = m['tick']
        for k in range(24):
            nm.cache[k] = m['cache'][k]
        for slot in range(64):
            e, ne = m['render'][slot], nm.render[slot]
            ne.layer, ne.callback, ne.surface = e['layer'], 1 if e['callback'] else 0, e['surface']
            ne.field_0c, ne.field_10, ne.visible, ne.active = e['f0c'], e['f10'], e['visible'], e['active']
            ne.row = e['row']
            set_tag(ne, e['tag'])
        self.rig.snapshotter = self.native_snapshot
        self.original.snapshotter = self.original_snapshot
        self.compares = 0
        self.steps = 0
        self.events_compared = 0

    # snapshots taken at provider calls: manager + render/cache + current-row runtime fields
    def original_snapshot(self):
        o = self.original
        count = o.s32(MGR + 0xcc)
        active = tuple((slot,) + tuple(o.state_render(slot)) for slot in range(24, 64)
                       if o.s32(render_va(slot) + 0x18) != 0)
        return (count, tuple(row_of_pointer(o.r32(MGR + 0x2c + 4 * i)) for i in range(max(0, min(count, 40)))),
                active, tuple(o.r32(CACHE_BASE + 4 * k) for k in range(24)),
                self.original_runtime(), self.original_world())

    def native_snapshot(self):
        m = self.rig.manager
        count = m.count
        active = tuple((slot,) + self.native_render(slot) for slot in range(24, 64)
                       if m.render[slot].active != 0)
        return (count, tuple(m.list[i] for i in range(max(0, min(count, 40)))), active,
                tuple(m.cache[k] for k in range(24)), self.native_runtime(), self.native_world())

    def native_render(self, slot):
        e = self.rig.manager.render[slot]
        return (e.layer, 1 if e.callback else 0, e.surface, e.visible, e.row)

    def original_runtime(self):
        o = self.original
        row = self.current_row
        if row is None or o.r32(objptr_va(row)) == 0:
            return None
        base = obj_va(row)
        return (o.s16(base + 0xab0), o.s16(base + 0xaa2), o.s16(base + 0xaa4), o.r32(base + 0xaa6),
                o.r32(base + 0xaaa), o.s16(base + 0xaae), o.r32(base + 0xab2), o.r32(base + 0xab6))

    def native_runtime(self):
        row = self.current_row
        if row is None or self.rig.buffers[row] is None:
            return None
        image = bytes(self.rig.buffers[row])
        return (native.image_s16(image, 0xab0), native.image_s16(image, 0xaa2),
                native.image_s16(image, 0xaa4), native.image_u32(image, 0xaa6),
                native.image_u32(image, 0xaaa), native.image_s16(image, 0xaae),
                native.image_u32(image, 0xab2), native.image_u32(image, 0xab6))

    def original_world(self):
        o = self.original
        return tuple(struct.unpack(SIGNED[size], o.uc.mem_read(address, size))[0]
                     for address, size in WORLD_OUT.values())

    def native_world(self):
        w = self.rig.world
        return tuple(getattr(w, NATIVE_NAME.get(name, name)) for name in WORLD_OUT)

    # ---- operations ----------------------------------------------------------
    def set_inputs(self, ticks=None, query=None):
        if ticks is not None:
            self.original.ticks = list(ticks)
            self.rig.ticks = list(ticks)
        if query is not None:
            self.original.query = query
            self.rig.playing = query

    def mutate(self, selector=None, held=None, item_flag=None, events=None, phases=None):
        o, w = self.original, self.rig.world
        if selector is not None:
            o.uc.mem_write(0x5bb50b, struct.pack('<h', selector))
            w.selector = selector
        if held is not None:
            o.uc.mem_write(0x583a29, struct.pack('<h', held))
            w.held_item = held
        if item_flag is not None:
            o.uc.mem_write(0x5b44f8, struct.pack('<i', item_flag))
            w.item_flag_5b44f8 = item_flag
        for index, value in (events or {}).items():
            o.uc.mem_write(EVENT_BASE + 4 * index, struct.pack('<i', value))
            self.rig.events[index] = value
        for row, phase in (phases or {}).items():
            o.uc.mem_write(phase_va(row), struct.pack('<I', phase))
            self.native_phases[row] = phase

    def check_state(self, label):
        got, mine = self.original.state(), self.native_state()
        for key in ('count', 'list', 'cur_row', 'cur_rec', 'tick', 'cache', 'events', 'world', 'rows'):
            if got[key] != mine[key]:
                raise OracleError((label, 'state mismatch', key, got[key], mine[key]))
        if got['cur_row'] != got['cur_row2']:
            raise OracleError((label, 'original scratch pointers +0x1c/+0x20 differ'))
        if got['render'] != mine['render']:
            for slot, (a, b) in enumerate(zip(got['render'], mine['render'])):
                if a != b:
                    raise OracleError((label, 'render entry mismatch', slot + 24, a, b))
        for row in got['images']:
            if got['images'][row] != mine['images'].get(row):
                diff = [i for i in range(native.IMAGE_BYTES) if got['images'][row][i] != mine['images'][row][i]]
                raise OracleError((label, 'image mismatch', row, diff[:16]))
        self.compares += 1

    def native_state(self):
        rig = self.rig
        m = rig.manager
        state = dict(count=m.count, list=[m.list[i] for i in range(40)], cur_row=m.current_row,
                     cur_rec=m.current_record, tick=m.tick, cache=[m.cache[k] for k in range(24)])
        state['render'] = [(e.layer, 1 if e.callback else 0, e.surface, e.field_0c, e.field_10,
                            e.visible, e.active, e.row, tag_bytes(e))
                           for e in (m.render[i] for i in range(24, 64))]
        state['images'] = {row: bytes(b) for row, b in enumerate(rig.buffers) if b is not None}
        state['events'] = list(rig.events)
        w = rig.world
        world = {}
        for name in list(WORLD_OUT) + list(WORLD_IN):
            world[name] = getattr(w, NATIVE_NAME.get(name, name))
        state['world'] = world
        state['rows'] = {row: (self.native_phases.get(row, 0), self.native_complete.get(row, 0),
                               self.native_request.get(row))
                         for row in range(self.case['rows'])}
        return state

    native_complete = {}
    native_request = {}

    def start(self):
        o = self.original
        # initial cells of the row bookkeeping the native side mirrors
        self.native_complete = {row: 0 for row in range(self.case['rows'])}
        self.native_request = {row: o.r32(request_va(row)) for row in range(self.case['rows'])}
        self.current_row = None
        self.check_state('initial')

    def canonical_native(self, row, subtype, trace):
        """Native trace -> the original's vocabulary."""
        out = []
        for entry in trace:
            if entry[0] == 'hook':
                out.append(entry)
                continue
            _, name, a, b = entry
            if name == 'start_flag':
                out.append(('w', 'start_flag', a))
            elif name == 'redraw':
                out += [('w', 'redraw', 1), ('w', 'redraw6', 0)]
            elif name == 'request_clear':
                out.append(('w', 'request', a, 0))
            elif name == 'phase':
                out.append(('w', 'phase', row, a))
            elif name == 'event_write':
                out.append(('w', 'ev', a, b))
            elif name == 'transfer':
                w = self.rig.world
                for field in XFER_ORDER:
                    out.append(('w', 'xfer', WORLD_OUT[field][0], getattr(w, NATIVE_NAME.get(field, field))))
                out.append(('w', 'mode', 4))
            elif name == 'finish':
                if subtype == 1:
                    out.append(('w', 'complete', row, 1))
                elif subtype == 2:
                    out.append(('w', 'complete', row, 0))
                    out.append(('hook', 'reset_deps', tree_va(row), None))
                out.append(('w', 'phase', row, 0))
        return out

    @staticmethod
    def strip_snapshots(trace):
        return [e[:-1] if e[0] == 'hook' else e for e in trace]

    def compare_logs(self, label, got, mine):
        if self.strip_snapshots(got) != self.strip_snapshots(mine):
            raise OracleError((label, 'ordered effect mismatch', self.strip_snapshots(got),
                               self.strip_snapshots(mine)))
        for g, m in zip(got, mine):
            if g[0] == 'hook' and m[0] == 'hook' and m[-1] is not None and g[-1] != m[-1]:
                raise OracleError((label, 'state at provider call differs', g[:-1], g[-1], m[-1]))
        self.events_compared += len(got)

    def step(self, row, ticks=None, query=None, expect_fatal=False):
        o, rig = self.original, self.rig
        self.set_inputs(ticks, query)
        subtype = o.uc.mem_read(subtype_va(row), 1)[0]
        phase = o.r32(phase_va(row))
        if phase != self.native_phases.get(row, 0):
            raise OracleError(('phase bookkeeping diverged', row, phase, self.native_phases.get(row)))
        self.current_row = row
        before_native = self.native_state() if expect_fatal else None
        rig.trace.clear()
        status = o.arm(row, self.rng)
        got = list(o.trace)
        bad = o.footprint_ok(o.write_log)
        if bad and status == 'ok':
            raise OracleError(('original write outside the allowed footprint', bad[:4]))
        n_status, result, why = rig.step(row, phase)
        label = 'step row %d phase %d' % (row, phase)
        if status == 'fatal':
            if not expect_fatal:
                raise OracleError((label, 'original reached an error sink', o.fatal))
            if n_status != native.BOUNDS:
                raise OracleError((label, 'native did not reject the unsafe visit', n_status, why))
            if self.native_state() != before_native:
                raise OracleError((label, 'native rejection changed state'))
            self.steps += 1
            return 'fatal', o.fatal, why
        if expect_fatal:
            raise OracleError((label, 'expected the original to reach an error sink'))
        if n_status != native.OK:
            raise OracleError((label, 'native rejected a parity case', n_status, why))
        mine = self.canonical_native(row, subtype, rig.trace)
        self.compare_logs(label, got, mine)
        # the executor-visible outcome
        new_phase = 0 if result.finished else result.phase_after
        if o.r32(phase_va(row)) != new_phase:
            raise OracleError((label, 'phase memory vs native phase', o.r32(phase_va(row)), new_phase))
        self.native_phases[row] = new_phase
        if result.finished:
            if subtype == 1:
                self.native_complete[row] = 1
            elif subtype == 2:
                self.native_complete[row] = 0
        if result.registered:
            self.native_request[row] = 0
        self.check_state(label)
        self.steps += 1
        return result

    def hit(self, x, y):
        o, rig = self.original, self.rig
        self.current_row = None
        rig.trace.clear()
        status, eax = o.hit(x, y, self.rng)
        if status == 'fatal':
            raise OracleError(('hit test reached an error sink', o.fatal))
        got = list(o.trace)
        bad = o.footprint_ok(o.write_log)
        if bad:
            raise OracleError(('hit test wrote outside the footprint', bad[:4]))
        n_status, hit, row, why = rig.hit(x, y)
        label = 'hit %d,%d' % (x, y)
        if n_status != native.OK:
            raise OracleError((label, 'native rejected', why))
        if bool(eax) != bool(hit) or eax not in (0, 1):
            raise OracleError((label, 'hit result', eax, hit))
        if hit:
            if o.s32(0x5c39e5) != row:
                raise OracleError((label, 'candidate row'))
        # cursor writes expected from the original's rule
        mine = []
        if hit:
            w = rig.world
            held, flag = w.held_item, w.item_flag_5b44f8
            if held != -1 and flag == 0:
                mine += [('w', 'cur', 0x5b44f0, w.cursor_index), ('w', 'cur', 0x5d162d, w.cursor_surface)]
            elif held == -1 and flag == 0:
                mine += [('w', 'cur', 0x5b44f0, w.cursor_index), ('w', 'cur', 0x5d162d, w.cursor_surface)]
            mine += [('w', 'cur', 0x5b44f4, w.cursor_variant), ('w', 'cur', 0x5d1631, w.cursor_table),
                     ('w', 'cur', 0x5d1639, w.cursor_layer), ('w', 'cur', 0x5c39e5, w.candidate)]
        self.compare_logs(label, got, mine)
        self.check_state(label)
        self.steps += 1
        return hit, row

    def draw(self, slot, expect_fatal=False):
        o, rig = self.original, self.rig
        self.current_row = None
        rig.trace.clear()
        before_native = self.native_state() if expect_fatal else None
        status = o.draw(slot, self.rng)
        got = list(o.trace)
        n_status, why = rig.draw(slot)
        label = 'draw slot %d' % slot
        if status == 'fatal':
            if not expect_fatal:
                raise OracleError((label, 'original reached an error sink', o.fatal))
            if n_status != native.BOUNDS or self.native_state() != before_native:
                raise OracleError((label, 'native did not reject the unsafe draw', n_status, why))
            self.steps += 1
            return 'fatal'
        if expect_fatal:
            raise OracleError((label, 'expected an error sink'))
        bad = o.footprint_ok(o.write_log)
        if bad:
            raise OracleError((label, 'draw wrote outside the footprint', bad[:4]))
        if n_status != native.OK:
            raise OracleError((label, 'native rejected', why))
        mine = [e for e in rig.trace if e[0] == 'hook']
        got = [e for e in got]
        self.compare_logs(label, got, [e for e in mine])
        self.check_state(label)
        self.steps += 1
        return 'ok'


NATIVE_NAME = {'view_x': 'view_x', 'view_y': 'view_y', 'cursor_layer': 'cursor_layer',
               'cursor_index': 'cursor_index', 'cursor_variant': 'cursor_variant',
               'cursor_surface': 'cursor_surface', 'cursor_table': 'cursor_table',
               'cursor_surface_default': 'cursor_surface_default', 'cursor_surface_held': 'cursor_surface_held',
               'background_surface': 'background_surface', 'candidate': 'candidate',
               'item_flag_5b44f8': 'item_flag_5b44f8'}


def tag_bytes(entry):
    import ctypes as c
    return c.string_at(c.addressof(entry) + native.Render.tag.offset, 16)


def set_tag(entry, tag):
    import ctypes as c
    c.memmove(c.addressof(entry) + native.Render.tag.offset, bytes(tag), 16)


def native_world_fields():
    return list(WORLD_OUT) + list(WORLD_IN)


# add helpers used above
def _state_render(self, slot):
    b = render_va(slot)
    return (self.s32(b), 1 if self.r32(b + 4) else 0, self.r32(b + 8), self.s32(b + 0x14),
            row_of_pointer(self.r32(b + 0x1e)))


Original.state_render = _state_render


# ---- image generators ---------------------------------------------------------

def sec(frame, primary, hot, src, dst):
    return native.secondary(frame, primary, hot, src, dst)


def random_image(rng, *, marker=None, name=None, force=None):
    marker = marker if marker is not None else rng.choice((1, 1, 2))
    if marker == 2:
        first = 0
        last = rng.randrange(0, 5)
        n = last - first + 1
    else:
        first = last = 0
        n = rng.randrange(1, 5)
    prims = [native.primary_record(rng.randrange(0, 600), rng.randrange(0, 400),
                                   rng.randrange(0, 600), rng.randrange(0, 400)) for _ in range(n)]
    secs = []
    frames = [0, 1, 2, 3, 5, 16]
    for _ in range(rng.randrange(1, 5)):
        left, top = rng.randrange(0, 500), rng.randrange(0, 300)
        secs.append(sec(rng.choice(frames), rng.randrange(0, n), rng.choice((0, 1, 1, 2)),
                        tuple(rng.randrange(-20, 100) for _ in range(4)),
                        (left, top, left + rng.randrange(0, 90), top + rng.randrange(0, 60))))
    names = [b'OVL_%d' % rng.randrange(6), b'Ovl_%d' % rng.randrange(6), b'USE_AUTOTEXT%d' % rng.randrange(1, 4),
             b'X' * 32, b'a', b'TUT_Next_OVL', b'tut_next_ovl']
    pairs = [(rng.randrange(0, 300), rng.randrange(-3, 5)) for _ in range(rng.choice((0, 0, 1, 2, 10)))]
    options = dict(layer=rng.choice((10, 11, 12, 0, 15)), marker=marker, plain=rng.choice((1, 1, 2)),
                   flag21=rng.choice((1, 2, 0)), action25=rng.choice((1, 2, 2)),
                   direction=rng.choice((1, 2)), loop=rng.choice((1, 2)),
                   init=rng.randrange(first, last + 1) if marker == 2 else rng.randrange(0, 4),
                   first=first, last=last, fps=rng.choice((15, 15, 8, 30, 1, 7, 100, 0, -5)),
                   event=rng.choice(((-1, 0), (-1, 0), (rng.randrange(0, 300), rng.randrange(-2, 4)))),
                   transfer=tuple(rng.randrange(-30000, 30000) for _ in range(4)) +
                            tuple(rng.randrange(-2 ** 31, 2 ** 31) for _ in range(3)),
                   pairs=pairs, sound=rng.choice((b'NO SOUND', b'NO SOUND', b'CLICK', b'a')),
                   sound_word=rng.randrange(0, 65536) - (65536 if rng.random() < 0.3 else 0))
    options['sound_word'] = options['sound_word'] & 0xffff if options['sound_word'] >= 0 else options['sound_word'] + 65536
    # sound word is a u16 in the image
    name = name if name is not None else rng.choice(names)
    if force:
        options.update(force)
    pre = native.prefix(name, primaries=n, secondaries=len(secs), **{
        k: v for k, v in options.items() if k != 'sound_word'}, sound_word=0)
    pre = bytearray(pre)
    struct.pack_into('<H', pre, 0x9a, options['sound_word'])
    return native.make_image(bytes(pre), prims, secs)


def corpus_images():
    corpus = json.loads((ROOT / 'work/analysis/slices/A-36.1.corpus.json').read_bytes())
    out = []
    for record in corpus['records']:
        data = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % record['resource_index'])).read_bytes()
        start = record['act_payload_offset']
        payload = data[start:start + record['act_payload_length']]
        body = payload[50:50 + record['raw_body_length']]
        n, m = record['primary_count'], record['secondary_count']
        image = bytearray(native.IMAGE_BYTES)
        image[0:0xAC] = body[:0xAC]
        image[0xAC:0xAC + 16 * n] = body[0xAC:0xAC + 16 * n]
        sec_start = 0xAC + 16 * n
        image[0x6EC:0x6EC + 38 * m] = body[sec_start:sec_start + 38 * m]
        out.append((record['resource_index'], record['action_index'], bytes(image), record['subtype']))
    return out


# ---- scenarios --------------------------------------------------------------------

def can_register(pair):
    m = pair.rig.manager
    return (m.count < 38 and any(not m.render[s].active for s in range(24, 64)) and
            any(m.cache[k] == 0 for k in range(24)))


def draw_in_domain(pair, slot):
    """Dry run on the native kernel: the original reads uninitialised primary
    records when a record names an index past the constructed table, which is
    outside the valid-input domain (native rejects it)."""
    rig = pair.rig
    saved = (list(rig.trace), list(rig.log))
    status, _ = rig.draw(slot)
    rig.trace[:] = saved[0]
    rig.log[:] = saved[1]
    return status == native.OK


def run_registration_script(pe, lib, case, rng, stats, *, ticks_pool=None, expect=None):
    pair = Pair(pe, lib, case)
    pair.start()
    rows = [row for row in range(case['rows']) if case['images'].get(row) is not None]
    order = list(rows)
    if rng.random() < 0.5:
        rng.shuffle(order)
    for row in order:
        if not can_register(pair):
            break
        ticks = [rng.randrange(0, 5000)] + [rng.randrange(0, 10000) for _ in range(3)]
        pair.step(row, ticks=ticks, query=rng.choice((0, 1)))
        stats['registrations'] += 1
    for _ in range(rng.randrange(2, 7)):
        selector = rng.choice((0, 1, 2, 3, 5, 16))
        events = {rng.randrange(0, 300): rng.randrange(-3, 5) for _ in range(rng.randrange(0, 4))}
        pair.mutate(selector=selector, events=events)
        for _ in range(3):
            row = rng.choice(order)
            if pair.native_complete.get(row):
                continue
            phase = pair.native_phases.get(row, 0)
            if phase == 0 and not can_register(pair):
                continue
            pair.step(row, ticks=[rng.randrange(0, 20000) for _ in range(3)], query=rng.choice((0, 1)))
            stats['visits'] += 1
        for row in order:
            image = case['images'][row]
            for index in range(native.image_s16(image, 0xaa)):
                rec = image[0x6EC + 38 * index:0x6EC + 38 * (index + 1)]
                left, top, right, bottom = struct.unpack_from('<4i', rec, 0x16)
                for x, y in ((left, top), (right, bottom), (left - 1, top), (left, top - 1),
                             (right + 1, bottom), (right, bottom + 1), ((left + right) // 2, (top + bottom) // 2)):
                    if -32768 <= x < 32768 and -32768 <= y < 32768:
                        pair.hit(x, y)
                        stats['hits'] += 1
        for slot in range(24, 64):
            e = pair.rig.manager.render[slot]
            if e.active and e.callback and e.row >= 0:
                if draw_in_domain(pair, slot):
                    pair.draw(slot)
                    stats['draws'] += 1
                else:
                    stats['draw_skipped_out_of_domain'] += 1
    # drive rows to phase 2: the event pair, or the candidate-accept store 0x43c054
    for row in order:
        if pair.native_complete.get(row) or pair.native_phases.get(row) != 1:
            continue
        image = case['images'][row]
        index = native.image_s16(image, 0x39)
        if index != -1 and rng.random() < 0.5:
            pair.mutate(events={index: native.image_s16(image, 0x3b)})
            pair.step(row, ticks=[100], query=0)
        else:
            pair.mutate(phases={row: 2})
    for row in order:
        if pair.native_phases.get(row) == 2 and not pair.native_complete.get(row):
            pair.step(row, ticks=[100], query=0)
            stats['finishes'] += 1
    stats['events'] += pair.events_compared
    return pair


def valid_images(rng, count):
    return [random_image(rng) for _ in range(count)]


def main(*, library=None, report_path=REPORT, quick=False, fps_sweep=True):
    started = time.monotonic()
    lib = native.bind(native.build_library() if library is None else native.library_path())
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    windows = []
    for start, end, label, digest in CODE_WINDOWS:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None and actual != digest:
            raise OracleError('code window mismatch: ' + label)
        windows.append(dict(start=hex(start), end=hex(end), label=label, sha256=actual))
    stats = dict(registrations=0, visits=0, hits=0, draws=0, finishes=0, events=0,
                 draw_skipped_out_of_domain=0)
    pairs = []
    families = {}

    def family(name):
        families[name] = dict(scripts=0, steps=0, state_compares=0, events=0)
        return families[name]

    def account(f, pair):
        f['scripts'] += 1
        f['steps'] += pair.steps
        f['state_compares'] += pair.compares
        f['events'] += pair.events_compared
        pairs.append(pair)

    rng = random.Random(0x36)

    # F1: random single and multiple overlays
    f = family('random-overlays')
    for seed in range(6 if quick else 160):
        r = random.Random(seed * 7919 + 1)
        count = r.choice((1, 1, 2, 3, 5))
        images = valid_images(r, count)
        case = base_case(seed, images, subtypes={i: r.choice((1, 1, 2, 0, 3)) for i in range(count)},
                         selector=r.choice((0, 1, 2)), held=r.choice((-1, -1, 4, 30)),
                         item_flag=r.choice((0, 0, 1)), rng=r, tick=r.randrange(2 ** 32))
        if r.random() < 0.4:
            occupy_foreign(case, r, render_slots=r.sample(range(24, 64), r.randrange(1, 12)),
                           cache_slots=r.sample(range(24), r.randrange(0, 8)))
        # the random images may hit sound providers; the oracle provides them
        account(f, run_registration_script(pe, lib, case, r, stats))

    # F2: corpus rows (the real overlays), registered per scene
    f = family('corpus-rows')
    scenes = {}
    for resource, action, image, subtype in corpus_images():
        scenes.setdefault(resource, []).append((action, image, subtype))
    for resource, rows in sorted(scenes.items()):
        images = [None] * (max(a for a, _, _ in rows) + 1)
        subtypes = {}
        for action, image, subtype in rows:
            images[action] = image
            subtypes[action] = subtype
        for selector in (0, 1, 2, 3, 16, 17):
            r = random.Random(resource * 100 + selector)
            case = base_case(resource * 100 + selector, images, subtypes=subtypes, selector=selector,
                             rng=r, tick=r.randrange(2 ** 32))
            account(f, run_registration_script(pe, lib, case, r, stats))
            if quick:
                break
        if quick:
            break

    # F3: the tutorial pair (live S6400 rows 16/17) end to end
    f = family('tutorial-s6400')
    live = ROOT / 'work/analysis/slices/RT-13.resources/S6400.live.bin'
    if live.exists():
        images = tutorial_images(lib, live)
        for selector in (0, 3, 19, 20):
            r = random.Random(6400 + selector)
            case = base_case(6400 + selector, images, subtypes={16: 1, 17: 1}, selector=selector,
                             rng=r, tick=r.randrange(2 ** 32))
            pair = Pair(pe, lib, case)
            pair.start()
            for row in (16, 17):
                if images[row] is not None:
                    pair.step(row, ticks=[1000])
            for x, y in ((540, 20), (612, 52), (539, 20), (613, 52), (10, 20), (30, 30)):
                pair.hit(x, y)
            pair.mutate(phases={17: 2})
            pair.step(17, ticks=[2000])
            for row in (16, 17):
                if pair.native_phases.get(row) == 1:
                    pair.step(row, ticks=[2100])
            account(f, pair)
            stats['events'] += pair.events_compared

    # F4: unsafe original behaviour -> native rejection, proven by the original's error sinks
    unsafe = {}
    r = random.Random(0xbad)
    image = random_image(r, marker=1, force=dict(sound=b'NO SOUND', marker=1, event=(-1, 0), fps=15))
    # list full
    case = base_case(900, [image], rng=r)
    case['manager']['count'] = 40
    pair = Pair(pe, lib, case)
    pair.start()
    unsafe['list_full_40'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    # render table full
    case = base_case(901, [image], rng=r)
    occupy_foreign(case, r, render_slots=range(24, 64))
    pair = Pair(pe, lib, case)
    pair.start()
    unsafe['render_table_full'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    # surface cache full
    case = base_case(902, [image], rng=r)
    occupy_foreign(case, r, cache_slots=range(24))
    pair = Pair(pe, lib, case)
    pair.start()
    unsafe['surface_cache_full'] = pair.step(0, ticks=[0], expect_fatal=True)[1]
    # draw callback with a slot that does not match the image
    case = base_case(903, [image], rng=r)
    pair = Pair(pe, lib, case)
    pair.start()
    pair.step(0, ticks=[0])
    for dst in (30,):
        e = pair.original.uc
        base = render_va(dst)
        e.mem_write(base, struct.pack('<iIIiiii', 10, 0x48a3db, 0x2222, 0, 0, 1, 1))
        e.mem_write(base + 0x1e, struct.pack('<I', obj_va(0)))
        e.mem_write(base + 0x22, b'OVERLAY ZRENDER\0')
        ne = pair.rig.manager.render[dst]
        ne.layer, ne.callback, ne.surface, ne.field_0c, ne.field_10 = 10, 1, 0x2222, 0, 0
        ne.visible = ne.active = 1
        ne.row = 0
        set_tag(ne, b'OVERLAY ZRENDER\0')
        unsafe['draw_slot_mismatch'] = pair.draw(dst, expect_fatal=True)
    families['unsafe-domain'] = dict(scripts=4, steps=4, state_compares=0, events=0)

    # F5: interval sweep (0x50ce04 x87 path) over the 16-bit fps domain
    sweep = {}
    if fps_sweep:
        sweep = fps_interval_sweep(pe, lib, quick)

    totals = dict(scripts=sum(f['scripts'] for f in families.values()),
                  steps=sum(f['steps'] for f in families.values()),
                  state_compares=sum(f['state_compares'] for f in families.values()),
                  ordered_events=sum(f['events'] for f in families.values()))
    hook_counts = {}
    for pair in pairs:
        for name, n in pair.original.hook_counts.items():
            hook_counts[name] = hook_counts.get(name, 0) + n
    report = dict(
        exe_sha256=EXE_HASH, code_windows=windows, families=families, totals=totals, stats=stats,
        unsafe_original_behaviour=unsafe, fps_interval_sweep=sweep, hook_counts=hook_counts,
        hooks=['REPLACE 0x4c2790 CIFTREE surface load (ret 0x10)',
               'REPLACE 0x4fb77a / 0x4fb2e3 sound record start + word (ret 4 each)',
               'REPLACE 0x4f6334 sound query (ret 4)', 'REPLACE 0x4fba69 sound stop (ret 4)',
               'REPLACE 0x4c5377 / 0x4c5d4b blits (ret 0x14)', 'REPLACE 0x423d33 dependency reset (ret 4)',
               'REPLACE IAT 0x52a23c GetTickCount (scripted)',
               'FATAL SINKS 0x50ca3e 0x52139c 0x4c97b4 0x44a2b7 (stop; only the unsafe-domain cases may reach them)',
               'OBSERVE memory writes (classified) and provider-call state snapshots'],
        real_code=['0x428083 dispatcher arm with real gate 0x423f57 on an empty tree',
                   '0x4899ca Process with real 0x50d0bc, 0x4c948f, 0x4d39f9, 0x4d36ed, 0x50ce04, 0x42ba3a',
                   '0x4897cd hit test', '0x48a3db render callback'],
        unmodeled=['sound manager 0x5c3a67 / 0x5cf1eb internals', 'surface manager 0x5cf659 internals',
                   'foreign users of the render table and surface cache (modeled only as occupancy)',
                   'dependency tree reset 0x423d33 internals', 'FPU control word (x87 PC=53, see sweep)'],
        elapsed_seconds=round(time.monotonic() - started, 1))
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    print(json.dumps(dict(totals=totals, stats=stats, unsafe=unsafe,
                          sweep={k: v for k, v in sweep.items() if k != 'mismatches'},
                          elapsed=report['elapsed_seconds']), indent=2))
    return report


def tutorial_images(lib, live):
    import ctypes as c
    import session_binding_support as session
    lib2 = session.load_library(native.library_path())
    lib2.scene_resource_action_at.argtypes = [c.c_void_p, c.c_size_t, c.POINTER(session.SceneActionInfo)]
    data = live.read_bytes()
    owner = (c.c_uint8 * len(data)).from_buffer_copy(data)
    error = c.create_string_buffer(256)
    scene = lib2.scene_resource_open_memory(owner, len(data), error, len(error))
    if not scene:
        raise OracleError('live S6400 did not open: ' + error.value.decode())
    images = [None] * 21
    for row in (16, 17):
        info = session.SceneActionInfo()
        if lib2.scene_resource_action_at(scene, row, c.byref(info)) != 0 or info.type != 0x36:
            raise OracleError('live S6400 row %d is not raw 0x36' % row)
        body = bytes(info.raw_body[:info.raw_body_length])
        n = native.image_s16(body, 0x2b)
        m = native.image_s16(body, 0xaa)
        image = bytearray(native.IMAGE_BYTES)
        image[0:0xAC] = body[:0xAC]
        image[0xAC:0xAC + 16 * n] = body[0xAC:0xAC + 16 * n]
        image[0x6EC:0x6EC + 38 * m] = body[0xAC + 16 * n:0xAC + 16 * n + 38 * m]
        images[row] = bytes(image)
    lib2.scene_resource_close(scene)
    return images


def fps_interval_sweep(pe, lib, quick):
    """Registration of one marker-2 overlay for each fps: the stored interval
    (real x87 path) must match the native value, for both x87 precision modes."""
    result = {}
    values = list(range(-40, 41)) + [1000, 2000, 32767, -32768, 3000, 999, 1001, 125, 250, 500]
    values += list(range(1, 2001, 1 if not quick else 97))
    values = sorted(set(values)) if quick else sorted(set(values) | set(range(-32768, 32768, 3)))
    for fpcw in (0x27f, 0x37f):
        o = Original(pe, fpcw)
        mismatches = []
        r = random.Random(7)
        for fps in values:
            image = native.simple_image(b'FPS_OVL', marker=2, first=0, last=1, init=0, fps=fps,
                                        primaries=[native.primary_record(), native.primary_record()],
                                        secondaries=[native.secondary(0)])
            case = base_case(fps & 0xffff, [image], rng=r)
            case['manager'] = blank_manager(r, 0)
            o.load(case)
            o.ticks = [1000]
            status = o.arm(0, r)
            if status != 'ok':
                raise OracleError('fps sweep reached a sink')
            interval = o.r32(obj_va(0) + 0xaa6)
            rig = native.Rig(lib, [case['images'][0]], ticks=[1000])
            rig.step(0, 0)
            mine = native.image_u32(bytearray(rig.buffers[0]), 0xaa6)
            if interval != mine:
                mismatches.append((fps, interval, mine))
        result['fpcw_%#x' % fpcw] = dict(values=len(values), mismatches=len(mismatches),
                                          first_mismatches=mismatches[:8])
    result['mismatches'] = []
    # the native kernel models PC=53; PC=64 differences are reported, not failures
    if result['fpcw_0x27f']['mismatches']:
        raise OracleError(('interval mismatch at PC=53', result['fpcw_0x27f']['first_mismatches']))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--quick', action='store_true')
    parser.add_argument('--no-sweep', action='store_true')
    args = parser.parse_args()
    main(quick=args.quick, fps_sweep=not args.no_sweep)
