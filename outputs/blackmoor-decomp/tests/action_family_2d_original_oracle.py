#!/usr/bin/env python3
"""A-2D.1 original loader/allocation and dependency-boundary oracle for raw 0x2d.

Run using work/tools/oracle-python/bin/python with Unicorn JIT allowed.
The unmodified loader 0x40b34a (and its raw-0x2d arm 0x40c0e0, which calls
FUN_004cd243 with this = 0x63821d, and the allocate-and-zero-fill wrapper
FUN_004cf1e4) executes under Unicorn. Only malloc (0x51dc43) and the shared
ragged-tail diagnostic boundary (0x50ca3e, inside tail_oracle_common) are
replaced; every original decision executes. The original generic dependency
loader 0x424aa8 is run through tail_oracle_common.OriginalTail for the corpus
tails, the shared TAIL_LENGTHS and WIDTH_TAILS rows. Reports are created with
exclusive open; the default report directory is unique under /private/tmp.
Every corpus record (3) satisfies the recovered body rule and is compared in
full: byte-exact allocation images, owner fields, ordered write effects, exact
body read coverage and the cursor/offset advance. Negative counts and forced
allocation failures run the original up to its diagnostic call.
This is a behavioral oracle, not reconstructed source, byte matching or
runtime/gameplay coverage.
"""
import argparse
from bisect import bisect_right
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import sys
import tempfile
import time

sys.dont_write_bytecode = True
from cif_original_oracle import PEImage
from test_action_family_2d import (Decoded, Entry, Record35, Record34, Constructed, make_body, load_native,
                                   pointer, storage, typed_length, expected_image, handle_array)
from tail_oracle_common import (OriginalTail, NativeFamily, compare_tail, check_short_body,
                                EXIT_POINTS, HOOKS as TAIL_HOOKS, TAIL_LENGTHS, WIDTH_TAILS, require)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_NAME = 'A-2D.1.corpus.json'
CORPUS_HASH = '95a4c6d245185ec179d2c9059f7ddfba99af3b85731c550dafd87579fb0df8c5'
EXPECT_RECORDS = 3
CODE = [
    (0x40b34a, 0x410ca4, '4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de'),
    (0x40c0e0, 0x40c114, None),   # raw-0x2d loader arm
    (0x4cd243, 0x4cd645, None),   # FUN_004cd243 (3-stage constructor)
    (0x4cf1e4, 0x4cf276, None),   # FUN_004cf1e4 (malloc, store, zero-fill)
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x410a68, 0x410c07, None),   # handoff plus the reject path
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT, INPUT_SIZE = 0x20000000, 0x400000
HEAP, HEAP_SIZE = 0x30000000, 0x1000000
ALLOCATOR, BOUNDARY, ARM, REJECT_EXIT = 0x51dc43, 0x410aa5, 0x40c0e0, 0x410c07
WRAPPER_RET, NULL_LOG = 0x4cf1f7, 0x4cf215
STAGE_RET = dict(header=0x4cd2b1, table=0x4cd35a, record=0x4cd4a8, group=0x4cd56a)
OWNER = 0x63821d
OWNER_WINDOW = (0x200, 0x60)            # bytes [OWNER+0x200, OWNER+0x260) are guarded
OWNER_FLAG = OWNER + 0x216
ROW0, ROW_SIZE, INDEX_WORD = 0x5bb5b3, 0x8d, 0x5c39e3
STACK, FRAME = 0x5800, 0x7000
STACK_LOW, STACK_HIGH = 0x1000, 0x11000
HOOKS = {
    'code:0x51dc43': 'only loader replacement: malloc(size) from wrapper return 0x4cf1f7; returns a guarded, '
                     'seed-filled block (or NULL in forced/oversize failure probes); cdecl return',
    'code:0x40c0e0': 'observer only: begin ordered-effect recording at the raw-0x2d arm',
    'code:0x4cf215': 'observer/exit only: allocation-failure probes stop before the original diagnostic call',
    'code:0x410c07': 'observer/exit only: owner-already-active probe stops after the original reject path',
    'read:0x20000000..0x2003ffff': 'observer only; reject reads outside the exact ACT payload and record body coverage',
    'write:0x20000000..0x2003ffff': 'observer only; reject any ACT input write',
    'write:0x30000000..0x30ffffff': 'observer only; reject writes outside a live allocation',
    'write:all': 'observer only; ordered-effect list (stack temporaries excluded by address range)',
}
ASSUMPTIONS = [
    'a request of >= 0x80000000 bytes is not satisfiable in the 32-bit process (hook returns NULL)',
    'malloc(0) returns a distinct non-NULL pointer (CRT 0x50eace maps size 0 to a 16-byte block; not executed)',
]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def ebp_for(inline):
    return FRAME if inline else STACK - 4


def i16(value):
    return struct.pack('<h', value)


def layout(body):
    """Independent (oracle-side) walk of a well-formed body: allocation sizes in request order."""
    entries, groups = struct.unpack_from('<hh', body, 0x23)
    cursor, ns = 39, []
    for _ in range(entries):
        n = struct.unpack_from('<h', body, cursor + 0x2f)[0]
        ns.append(n)
        cursor += 49 + 35 * n
    return ns, groups, cursor + 34 * groups


class Original:
    def __init__(self, pe):
        from unicorn import (Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ,
                             UC_HOOK_MEM_WRITE)
        from unicorn import x86_const as x
        self.r = {name: getattr(x, 'UC_X86_REG_' + name) for name in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(0x1000, 0x10000)
        self.uc.mem_map(INPUT, INPUT_SIZE)
        self.uc.mem_map(HEAP, HEAP_SIZE)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocs = []            # [ptr, size, stage_ret, wrapper_slot]
        self.starts = []
        self.heap_used = 0
        self.fail_mode = None       # None | ('ordinal', k) | 'oversize'
        self.requests = []
        self.recording = False
        self.record_reads = True
        self.watch = ()
        self.events = []
        self.reads = bytearray()
        self.input_size = 0
        self.seed = 0
        self.total_allocations = 0
        self.sizes = Counter()
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_CODE, self.begin_recording, begin=ARM, end=ARM)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + INPUT_SIZE - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + INPUT_SIZE - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_heap, begin=HEAP, end=HEAP + HEAP_SIZE - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.record_write)

    # ---- hooks -------------------------------------------------------------------------------
    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == WRAPPER_RET, f'unexpected original allocation caller: {ret:#x}')
        # The wrapper's own frame: saved EBP at esp+20, its caller's return at esp+24, its two args above.
        wrapper_ebp = esp + 20
        stage_ret, slot, wanted = struct.unpack('<III', uc.mem_read(wrapper_ebp + 4, 12))
        require(wanted == size, 'wrapper size argument differs from malloc argument')
        ordinal = len(self.requests)
        self.requests.append((size, stage_ret, slot))
        fail = (self.fail_mode == 'oversize' and size >= 0x80000000) or \
               (isinstance(self.fail_mode, tuple) and self.fail_mode[1] == ordinal)
        if fail:
            uc.reg_write(self.r['EAX'], 0)
        else:
            require(size < 0x80000000, 'unexpected oversize allocation without a failure probe')
            base = (self.heap_used + 15) & ~15
            ptr = HEAP + base + 16
            rounded = (size + 15) & ~15
            span = 16 + max(rounded, 16 if size == 0 else 0) + 16
            require(base + span <= HEAP_SIZE, 'oracle heap exhausted')
            uc.mem_write(HEAP + base, b'\xa5' * 16 + bytes([self.seed]) * size +
                         b'\xd7' * (span - 16 - size))
            self.heap_used = base + span
            self.allocs.append([ptr, size, stage_ret, slot])
            self.starts.append(ptr)
            uc.reg_write(self.r['EAX'], ptr)
            self.total_allocations += 1
            self.sizes[size] += 1
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)

    def begin_recording(self, _uc, _address, _size, _data):
        self.recording = True
        self.events = []

    def read_input(self, _uc, _access, address, size, _value, _data):
        if not self.record_reads:
            return
        require(INPUT + 16 <= address and address + size <= INPUT + 16 + self.input_size,
                'original read outside exact ACT payload')
        start = address - INPUT - 16
        self.reads[start:start + size] = b'\1' * size

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise RuntimeError('original wrote input')

    def write_heap(self, _uc, _access, address, size, _value, _data):
        index = bisect_right(self.starts, address) - 1
        require(index >= 0, f'original wrote below every allocation: {address:#x}')
        ptr, length = self.allocs[index][0], self.allocs[index][1]
        require(ptr <= address and address + size <= ptr + length,
                f'original wrote outside allocation {index}: {address:#x}/{size}')

    def record_write(self, _uc, _access, address, size, value, _data):
        if self.recording and (address in self.watch or not (STACK_LOW <= address < STACK_HIGH)):
            self.events.append((address, size, value & ((1 << (8 * size)) - 1)))

    # ---- one invocation ----------------------------------------------------------------------
    def reset_heap(self):
        if self.heap_used:
            self.uc.mem_write(HEAP, bytes(self.heap_used))
        self.heap_used = 0
        self.allocs, self.starts, self.requests = [], [], []

    def invoke(self, payload, offset=50, inline=False, seed=0xcd, index=0, fail=None, record=True,
               owner_active=False, stop=None):
        uc, r = self.uc, self.r
        require(len(payload) >= 50 and payload[48] == 0x2d, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        require(len(payload) + 32 <= INPUT_SIZE, 'oracle fixture exceeds mapped input budget')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        require(-3 <= index < 16, 'unsupported oracle action index')
        self.seed, self.fail_mode = seed, fail
        self.input_size = len(payload)
        self.reads = bytearray(len(payload))
        self.record_reads = record
        self.recording = False
        self.events = []
        self.watch = (ebp_for(inline) - 0xcc, ebp_for(inline) - 0x20)   # offset and cursor locals
        self.reset_heap()
        row_address = ROW0 + index * ROW_SIZE
        slot = row_address + 0x32
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        uc.mem_write(INDEX_WORD, struct.pack('<H', index & 0xffff))   # negative: MOVSX sign-extends it
        uc.mem_write(ROW0, bytes(ROW_SIZE * max(0, index)))
        initial_action = bytearray((i * 19 + seed) & 255 for i in range(ROW_SIZE))
        initial_action[0x85:0x89] = bytes(4)
        pre = bytearray(b'\x91' * 16)
        if index > 0:
            pre[8:12] = bytes(4)
        pre = bytes(pre)
        uc.mem_write(row_address - 16, pre + initial_action + b'\x92' * 16)
        owner_window = bytes((i * 7 + seed + 3) & 255 for i in range(OWNER_WINDOW[1]))
        owner_window = bytearray(owner_window)
        owner_window[0x16:0x1a] = struct.pack('<I', 1 if owner_active else 0)   # +0x216
        owner_window = bytes(owner_window)
        uc.mem_write(OWNER + OWNER_WINDOW[0], owner_window)
        args = struct.pack('<III', 0x51000000, INPUT + 16, len(payload))
        uc.mem_write(STACK, args)
        uc.mem_write(STACK - 0x1000, b'\x93' * 16)
        uc.mem_write(STACK + 32, b'\x94' * 16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, ESP=STACK, EFLAGS=0x202).items():
            uc.reg_write(r[name], value)
        body_va = INPUT + 16 + 50
        expected = bytearray(initial_action)
        if inline:
            frame = ebp_frame = FRAME
            uc.reg_write(r['EBP'], frame)
            uc.reg_write(r['ESP'], frame - 0x300)
            for address, value in ((frame - 0x20, body_va), (frame - 0xcc, offset),
                                   (frame - 0x108, 1), (frame - 0xf8, 1),
                                   (frame + 0xc, len(payload))):
                uc.mem_write(address, struct.pack('<I', value))
            expected[0x30:0x32] = payload[48:50]
            uc.mem_write(row_address + 0x30, payload[48:50])
            entry = ARM
        else:
            require(offset == 50, 'full loader starts at offset 50')
            ebp_frame = STACK - 4
            name_end = payload.index(0, 0, 48) + 1
            expected[:name_end] = payload[:name_end]
            expected[0x30:0x32] = payload[48:50]
            entry = 0x40b34a
        offset_address, cursor_address = ebp_frame - 0xcc, ebp_frame - 0x20
        info = dict(row_address=row_address, slot=slot, ebp_frame=ebp_frame, offset_address=offset_address,
                    cursor_address=cursor_address, body_va=body_va, pre=pre, args=args,
                    initial_action=bytes(initial_action), expected=expected, owner_window=owner_window,
                    offset=offset, index=index)
        if stop is not None:       # failure / reject probes
            uc.emu_start(entry, stop, count=40_000_000)
            require(uc.reg_read(r['EIP']) == stop, 'probe did not reach its stop address')
            return info
        uc.emu_start(entry, BOUNDARY, count=40_000_000)
        require(uc.reg_read(r['EIP']) == BOUNDARY, 'original failed to reach the dependency handoff')
        frame = uc.reg_read(r['EBP'])
        require(frame == ebp_frame, 'unexpected loader frame')
        info['cursor'] = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        info['consumed'] = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        info['forwarded'] = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        return info

    def owner_fields(self):
        base = OWNER
        return {off: struct.unpack('<I', self.uc.mem_read(base + off, 4))[0]
                for off in (0x222, 0x226, 0x22a, 0x23e)}


# ---- expected ordered effects, derived from the recovered rule (FUN_004cd243 disassembly) -----
def zero_fill(kind, ptr, size):
    return [(kind, ptr + 4 * k, 4, 0) for k in range(size >> 2)] + \
           [(kind, ptr + 4 * (size >> 2) + j, 1, 0) for j in range(size & 3)]


def block_copy(ptr, size):
    return [('copy', ptr + 4 * k, 4, None) for k in range(size >> 2)] + \
           [('copy', ptr + 4 * (size >> 2) + j, 1, None) for j in range(size & 3)]


def expected_effects(body, allocs, info, index):
    """Return (events, store_positions). allocs: [(ptr,size)] in request order."""
    ns, groups, typed = layout(body)
    ev, stores = [], []
    mask = 0xffffffff
    offset, cursor = info['offset'], info['body_va']
    slot = info['slot']

    def advance(amount):
        nonlocal offset, cursor
        offset = (offset + amount) & mask
        ev.append(('offset', info['offset_address'], 4, offset))
        cursor = (cursor + amount) & mask
        ev.append(('cursor', info['cursor_address'], 4, cursor))

    ev.append(('owner', OWNER + 0x23e, 4, index & mask))
    p0, s0 = allocs[0]
    stores.append(len(ev)); ev.append(('slot', slot, 4, p0))
    ev += zero_fill('zero', p0, s0)
    ev += [('copy', p0 + 4 * k, 4, None) for k in range(9)] + [('copy', p0 + 36, 2, None), ('copy', p0 + 38, 1, None)]
    advance(0x27)
    ev.append(('owner', OWNER + 0x222, 4, p0))
    pt, st = allocs[1]
    stores.append(len(ev)); ev.append(('owner', OWNER + 0x226, 4, pt))
    ev += zero_fill('zero', pt, st)
    consumed = 0
    for i, n in enumerate(ns):
        e = pt + 53 * i
        ev += [('copy', e + 4 * k, 4, None) for k in range(8)] + [('copy', e + 32, 1, None)]
        ev += [('copy', e + 0x21, 2, None), ('copy', e + 0x23, 2, None), ('copy', e + 0x25, 4, None),
               ('copy', e + 0x29, 4, None), ('copy', e + 0x2d, 2, None), ('copy', e + 0x2f, 2, None)]
        pr, sr = allocs[2 + i]
        stores.append(len(ev)); ev.append(('ptr', e + 0x31, 4, pr))
        ev += zero_fill('zero', pr, sr)
        ev += block_copy(pr, sr)
        consumed += 49 + sr
    advance(consumed)
    pg, sg = allocs[2 + len(ns)]
    stores.append(len(ev)); ev.append(('owner', OWNER + 0x22a, 4, pg))
    ev += zero_fill('zero', pg, sg)
    ev += block_copy(pg, sg)
    advance(sg)
    return ev, stores


class Checker:
    def __init__(self, lib, machine):
        self.lib, self.machine = lib, machine
        self.calls = Counter()

    def compare(self, payload, label, offset=50, inline=False, seed=0xcd, index=0, record=True):
        m, lib = self.machine, self.lib
        body = payload[50:]
        ns, groups, typed = layout(body)
        info = m.invoke(payload, offset, inline, seed, index, record=record)
        uc = m.uc
        require(len(m.allocs) == 3 + len(ns), f'{label}: original allocation count mismatch')
        sizes = [39, 53 * len(ns)] + [35 * n for n in ns] + [34 * groups]
        require([a[1] for a in m.allocs] == sizes and [q[0] for q in m.requests] == sizes,
                f'{label}: original allocation sizes mismatch')
        returns = [STAGE_RET['header'], STAGE_RET['table']] + [STAGE_RET['record']] * len(ns) + [STAGE_RET['group']]
        require([q[1] for q in m.requests] == returns, f'{label}: allocation request stages mismatch')
        slots = [info['slot'], OWNER + 0x226] + [m.allocs[1][0] + 53 * i + 0x31 for i in range(len(ns))] + [OWNER + 0x22a]
        require([q[2] for q in m.requests] == slots, f'{label}: allocation destination slots mismatch')
        original = b''.join(bytes(uc.mem_read(a[0], a[1])) for a in m.allocs)
        handles = [a[0] for a in m.allocs]
        # guards around every block and the rest of the heap
        for ptr, size, _, _ in m.allocs:
            base = ptr - 16
            require(bytes(uc.mem_read(base, 16)) == b'\xa5' * 16, f'{label}: lower heap guard overwritten')
            tail = 32 if size == 0 else ((size + 15) & ~15) - size + 16
            require(bytes(uc.mem_read(ptr + size, tail)) == b'\xd7' * tail, f'{label}: upper heap guard overwritten')
        # input / row / stack / owner integrity and the arm's exact effects
        ebp, row = info['ebp_frame'], info['row_address']
        require(info['forwarded'] == (row, info['consumed'], len(payload), info['cursor']),
                f'{label}: original dependency arguments do not reflect cursor/offset')
        advance = info['cursor'] - info['body_va']
        require(advance == typed and info['consumed'] == (offset + typed) & 0xffffffff,
                f'{label}: original cursor/offset advance differs from the recovered rule')
        expected_row = bytearray(info['expected'])
        expected_row[0x32:0x36] = struct.pack('<I', handles[0])
        for address, data in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (row - 16, info['pre']), (row, bytes(expected_row)),
                              (row + ROW_SIZE, b'\x92' * 16), (STACK, info['args']),
                              (STACK - 0x1000, b'\x93' * 16), (STACK + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'{label}: original action/input/stack guard mismatch at {address:#x}')
        window = bytearray(info['owner_window'])
        owner = m.owner_fields()
        expected_owner = {0x222: handles[0], 0x226: handles[1], 0x22a: handles[-1], 0x23e: index & 0xffffffff}
        for off, value in expected_owner.items():
            window[off - OWNER_WINDOW[0]:off - OWNER_WINDOW[0] + 4] = struct.pack('<I', value)
        require(bytes(uc.mem_read(OWNER + OWNER_WINDOW[0], OWNER_WINDOW[1])) == bytes(window) and
                owner == expected_owner, f'{label}: original owner object differs from expected fields')
        if record:
            events, _ = expected_effects(body, [(a[0], a[1]) for a in m.allocs], info, index)
            got = m.events
            require(len(got) == len(events) and all((g[0], g[1]) == (e[1], e[2]) for g, e in zip(got, events)),
                    f'{label}: ordered write effects differ (original {len(got)} vs expected {len(events)})')
            for g, e in zip(got, events):
                if e[3] is not None:
                    require(g[2] == e[3], f'{label}: write value mismatch {e[0]} at {g[0]:#x}: {g[2]:#x} != {e[3]:#x}')
            # reads: exactly the typed body (plus the header text in the full loader), never the tail
            require(bytes(m.reads[50:50 + typed]) == b'\1' * typed and not any(m.reads[50 + typed:]),
                    f'{label}: original body/tail read coverage mismatch')
            require(any(m.reads[:50]) == (not inline), f'{label}: original header read coverage mismatch')
        # ---- native side ----
        raw = storage(body)
        d, c = Decoded(), Constructed()
        C.memset(C.byref(d), 0xa5, C.sizeof(d))
        require(lib.action_family_2d_decode(raw, len(body), C.byref(d)) == 0,
                f'{label}: native decoder rejected a valid original record')
        require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
                 d.dependency_bytes, d.dependency_count) ==
                (advance, len(body), C.addressof(raw) + advance, len(body) - advance, (len(body) - advance) // 16),
                f'{label}: decoded body/tail mismatch')
        header = original[:39]
        require(bytes(d.name) == header[:33] and
                (d.word_21, d.entry_count, d.record34_count) == struct.unpack_from('<Hhh', header, 0x21) and
                (d.entries_bytes, d.record35_total, d.records_34_bytes) ==
                (sum(49 + 35 * n for n in ns), sum(ns), 34 * groups),
                f'{label}: decoded header mismatch with the original header block')
        table = original[39:39 + 53 * len(ns)]
        sample = range(len(ns)) if len(ns) <= 200 else sorted(
            {0, 1, 2, 3, len(ns) - 1, len(ns) - 2, len(ns) // 2, 12345 % len(ns), 777 % len(ns)})
        for i in sample:
            n = ns[i]
            e = Entry()
            require(lib.action_family_2d_entry_at(raw, len(body), i, C.byref(e)) == 0, f'{label}: entry_at failed')
            mem = table[53 * i:53 * i + 53]
            require(bytes(e.name) == mem[:33] and (e.word_21, e.word_23, e.dword_25, e.dword_29, e.word_2d,
                    e.record35_count) == struct.unpack_from('<HHIIHh', mem, 33) and
                    struct.unpack_from('<I', mem, 49)[0] == handles[2 + i] and e.records_35_bytes == 35 * n,
                    f'{label}: decoded entry {i} mismatch with the original entry table')
            position = 39 + 53 * len(ns) + 35 * sum(ns[:i])
            block = original[position:position + 35 * n]
            require(C.string_at(e.records_35, 35 * n) == block, f'{label}: entry {i} record view mismatch')
            for k in (0, n - 1):
                if 0 <= k < n:
                    rec = Record35()
                    require(lib.action_family_2d_record35_at(raw, len(body), i, k, C.byref(rec)) == 0 and
                            bytes(rec.bytes) == block[35 * k:35 * k + 35], f'{label}: record35 mismatch')
        group_block = original[len(original) - 34 * groups:]
        for k in (0, groups - 1):
            if 0 <= k < groups:
                rec = Record34()
                require(lib.action_family_2d_record34_at(raw, len(body), k, C.byref(rec)) == 0 and
                        bytes(rec.bytes) == group_block[34 * k:34 * k + 34], f'{label}: record34 mismatch')
        length = C.c_size_t()
        require(lib.action_family_2d_body_length(raw, len(body), C.byref(length)) == 0 and length.value == advance,
                f'{label}: body_length/original cursor mismatch')
        image = (C.c_uint8 * (len(original) + 8))(*[0x5a] * (len(original) + 8))
        hs = (C.c_uint32 * len(handles))(*handles)
        require(lib.action_family_2d_construct(raw, len(body), offset, index, hs, len(handles),
                                               image, len(image), C.byref(c)) == 0,
                f'{label}: native constructor rejected a valid original record')
        require(bytes(image)[:len(original)] == original and bytes(image)[len(original):] == b'\x5a' * 8,
                f'{label}: original/native allocation image mismatch')
        require((c.allocation_count, c.image_bytes, c.body_bytes_consumed, c.payload_offset_before,
                 c.payload_offset_after, pointer(c.dependency_records), c.dependency_count, c.dependency_bytes,
                 c.available_body_bytes) ==
                (len(m.allocs), len(original), advance, offset, info['consumed'], C.addressof(raw) + advance,
                 (len(body) - advance) // 16, len(body) - advance, len(body)),
                f'{label}: original/native cursor/body rule mismatch')
        require((c.result_slot_handle, c.owner_header_handle, c.owner_entry_table_handle, c.owner_group_handle,
                 c.owner_action_index & 0xffffffff, c.raw_type, c.runtime_type) ==
                (struct.unpack('<I', uc.mem_read(info['slot'], 4))[0], owner[0x222], owner[0x226], owner[0x22a],
                 owner[0x23e], payload[48], payload[48]),
                f'{label}: original/native owner/slot metadata mismatch')
        require(bytes(raw) == body, f'{label}: native modified input')
        self.calls[('inline' if inline else 'full')] += 1
        return original, bytes(image)[:len(original)], len(m.events)

    def rejects(self, body):
        """Native atomic rejection for a body; returns the status set (all four entry points agree)."""
        lib, raw = self.lib, storage(body)
        d, c, n = Decoded(), Constructed(), C.c_size_t(0xa5a5a5a5)
        statuses = set()
        for out, call in ((d, lambda o: lib.action_family_2d_decode(raw, len(body), C.byref(o))),
                          (n, lambda o: lib.action_family_2d_body_length(raw, len(body), C.byref(o))),
                          (c, lambda o: lib.action_family_2d_construct(raw, len(body), 50, 0, handle_array(8), 8,
                                                                       (C.c_uint8 * 4096)(), 4096, C.byref(o)))):
            C.memset(C.byref(out), 0xa5, C.sizeof(out)) if out is not n else None
            before = bytes(out)
            statuses.add(call(out))
            require(bytes(out) == before, 'native rejection mutated its output')
        require(bytes(raw) == body, 'native rejection modified input')
        return statuses


def fixture(ns, groups, seed=7, subtype=1, tail=0, **kw):
    body = make_body(ns, groups, seed=seed, tail=tail, **kw)
    return b'synthetic' + bytes(39) + bytes([0x2d, subtype]) + body


def failure_probe(machine, checker, payload, kind, ordinal=None, index=0, inline=False):
    """Run the original up to the wrapper's NULL diagnostic. Returns observed stage facts."""
    body = payload[50:]
    uc, r = machine.uc, machine.r
    fail = 'oversize' if kind == 'oversize' else ('ordinal', ordinal)
    info = machine.invoke(payload, 50, inline, seed=0x33, index=index, fail=fail, stop=NULL_LOG)
    ebp = uc.reg_read(r['EBP'])
    stage_ret, slot, size = struct.unpack('<III', uc.mem_read(ebp + 4, 12))
    esp = uc.reg_read(r['ESP'])
    logged = struct.unpack('<2I', uc.mem_read(esp, 8))
    require(logged == (0x63888b, 0x559b94), 'unexpected NULL-path diagnostic arguments')
    require(struct.unpack('<I', uc.mem_read(slot, 4))[0] == 0, 'original did not store the NULL allocation')
    require(len(machine.requests) == len(machine.allocs) + 1, 'failed request is not the last request')
    ns, groups = layout_unchecked(body)
    # expected prefix up to and including the failing store (built from a synthetic complete allocation list
    # that uses the real addresses of the allocations that succeeded)
    return dict(stage_ret=stage_ret, slot=slot, size=size, requests=list(machine.requests),
                allocs=[(a[0], a[1]) for a in machine.allocs], events=list(machine.events), info=info)


def layout_unchecked(body):
    entries, groups = struct.unpack_from('<hh', body, 0x23)
    return entries, groups


class NativeTail(NativeFamily):
    def __init__(self, library):
        self.family, self.library = '2d', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(library)
        self.decode = self.lib.action_family_2d_decode
        self.body_length = self.lib.action_family_2d_body_length


def run_tails(library, records):
    native, machine = NativeTail(library), OriginalTail()
    exits = Counter()
    digest = hashlib.sha256()
    counts = dict(corpus=0, synthetic=0, short=0, width=0, synthetic_bodies=0)

    def one(payload, typed):
        result = compare_tail(native, machine, payload, typed)
        raw, n = storage(payload[50:]), C.c_size_t(0xa5a5a5a5)
        before = n.value
        status = native.body_length(raw, len(payload) - 50, C.byref(n))
        require((status == 0) == result.accepted and (n.value == typed if result.accepted else n.value == before),
                'body_length/original tail exit mismatch')
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))
        return result

    def short_lengths(typed):
        if typed <= 2048:
            return list(range(typed))
        edge = set(range(0, 130)) | set(range(typed - 130, typed))
        edge |= set(range(130, typed - 130, 37))
        return sorted(x for x in edge if 0 <= x < typed)

    def short_checks(prefix, typed):
        done = 0
        for length in short_lengths(typed):
            check_short_body(native, machine, prefix, typed, length)
            raw, n = storage(prefix[50:]), C.c_size_t(0xa5a5a5a5)
            status = native.body_length(raw, length, C.byref(n))
            require(status == 2 and n.value == 0xa5a5a5a5, 'native short-body body_length safety mismatch')
            out = Constructed()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            status = native.lib.action_family_2d_construct(raw, length, 50, 0, handle_array(8), 8,
                                                           (C.c_uint8 * 4096)(), 4096, C.byref(out))
            require(status == 2 and bytes(out) == before, 'native short-body constructor safety mismatch')
            done += 1
        return done

    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))
    seen = set()
    for payload, typed in records:
        typed = native.validated_length(payload, typed)
        one(payload, typed)
        counts['corpus'] += 1
        prefix = payload[:50 + typed]
        if sha(prefix) in seen:
            continue            # identical corpus bodies add no new tail inputs
        seen.add(sha(prefix))
        for length in TAIL_LENGTHS:
            one(prefix + pattern[:length], typed)
            counts['synthetic'] += 1
        counts['short'] += short_checks(prefix, typed)
    # synthetic bodies that exercise the same tail stage with other typed extents
    for ns, groups in (([], 0), ([0], 0), ([2, 0, 3], 2), ([1] * 9, 1)):
        payload = fixture(ns, groups)
        typed = typed_length(ns, groups)
        for length in tuple(range(0, 66)) + (255, 256, 257):
            one(payload + pattern[:length], typed)
            counts['synthetic'] += 1
        counts['synthetic_bodies'] += 1
        counts['short'] += short_checks(payload, typed)
    payload, typed = records[0]
    for tail in WIDTH_TAILS:
        one(payload[:50 + typed] + bytes(tail), typed)
        counts['width'] += 1
    require(sha(machine.uc.mem_read(0x424aa8, 0x425b8b - 0x424aa8)) == CODE[-1][2],
            'emulated dependency code changed')
    parity = counts['corpus'] + counts['synthetic'] + counts['width']
    return dict(corpus_records=counts['corpus'], tail_lengths=list(TAIL_LENGTHS), width_tails=list(WIDTH_TAILS),
                synthetic_tail_comparisons=counts['synthetic'], width_comparisons=counts['width'],
                synthetic_bodies=counts['synthetic_bodies'], parity_comparisons=parity,
                native_short_body_checks=counts['short'], original_calls=machine.calls,
                exit_counts=dict(exits), observed_exits_counts_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS, mismatches=0,
                scope='original empty/modulus/count/fatal boundary; stop before opcode construction')


def read_inputs():
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / CORPUS_NAME).read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x2d_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, EXPECT_RECORDS, EXPECT_RECORDS),
            'input identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch: {index}')
        resources[index] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    records = []
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        ns, groups, typed = layout(body)
        require(row['explained_by_rule'] and (len(payload), row['raw_body_offset'], row['raw_body_length'],
                row['body_sha256'], payload[48], payload[49], row['typed_body_length'],
                row['dependency_tail_length']) ==
                (n, p + 50, len(body), sha(body), 0x2d, row['subtype'], typed, len(body) - typed) and
                typed == row['typed_body_length'] and sha(body[:typed]) == row['typed_body_sha256'],
                f'corpus row mismatch: {ordinal}')
        require(all(x >= 0 for x in ns) and groups >= 0 and (len(body) - typed) % 16 == 0 and typed <= len(body),
                f'corpus row {ordinal} does not satisfy the recovered rule')
        records.append((payload, typed))
    return resources, records, corpus, sha(cb)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily2d.dylib')
    ap.add_argument('--result', type=Path)
    ap.add_argument('--stage', choices=('all', 'loader', 'quick', 'tail'), default='all')
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-2D.1.oracle-', dir='/private/tmp')) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records, corpus, corpus_hash = read_inputs()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    code = []
    for start, end, digest in CODE:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        require(digest is None or actual == digest, f'code window mismatch: {start:#x}')
        code.append(dict(start=hex(start), end_exclusive=hex(end), sha256=actual))
    loader_result = None
    if args.stage in ('all', 'loader', 'quick'):
        machine, lib = Original(pe), load_native(args.native_library)
        check = Checker(lib, machine)
        native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
        advances, effect_counts = [], 0
        for ordinal, (payload, typed) in enumerate(records):
            for index in (0, 3, -1):
                original, native, events = check.compare(payload, f'corpus-{ordinal}-row{index}',
                                                         seed=(ordinal * 31 + 7) & 255, index=index)
                original_hash.update(original)
                native_hash.update(native)
                effect_counts += events
            body = payload[50:]
            advances.append(typed)
            bodies.update(body)
            tails.update(body[typed:])
        corpus_runs = check.calls['full']
        # synthetic matrix: structure x subtype x entry mode x index x allocator fill
        synthetic_hash = hashlib.sha256()
        shapes = [([], 0), ([0], 0), ([], 1), ([1], 0), ([0], 1), ([0, 0], 3), ([2, 0, 3], 2), ([1, 1, 1, 1], 7),
                  ([4, 3, 4, 3], 1), ([2] * 9, 1), ([3] * 12, 0), ([0] * 40, 1), ([5, 0, 1, 0, 9, 2], 4),
                  ([7], 11), (list(range(0, 12)), 2), ([35, 1], 3), ([1] * 64, 5), ([120, 0, 121], 130)]
        object_bytes = 0
        synthetic_runs = 0
        for number in range(256):
            ns, groups = shapes[number % len(shapes)]
            subtype = number
            payload = fixture(ns, groups, seed=number, subtype=subtype,
                              word21=(0, 1, 0x7fff, 0x8000, 0xffff)[number % 5],
                              tail=(0, 1, 2, 5)[number % 4])
            for inline in (False, True):
                offset = (0, 50, 0xffffffff - 400, 0xffffffff)[number % 4] if inline else 50
                index = (0, 1, 5, 15, -1, -3)[number % 6] if inline else (0, 2, -1)[number % 3]
                original, native, events = check.compare(payload, f'synthetic-{number}-{inline}', offset, inline,
                                                         seed=number ^ 0xa5, index=index)
                require(original == native, 'synthetic image mismatch')
                synthetic_hash.update(native)
                object_bytes += len(original)
                synthetic_runs += 1
        # all-ones / all-zero filled bodies (no NUL in any 33-byte span, extreme word values)
        for fill in (0x00, 0xff):
            payload = fixture([1, 2], 1)
            body = bytearray(payload[50:])
            for pos in range(len(body)):
                if pos not in (0x23, 0x24, 0x25, 0x26) and not (39 + 0x2f <= pos <= 39 + 0x30) and \
                   not (39 + 49 + 35 + 0x2f <= pos <= 39 + 49 + 35 + 0x30):
                    body[pos] = fill
            payload = payload[:50] + bytes(body)
            original, native, events = check.compare(payload, f'fill-{fill}', 50, False, seed=fill, index=1)
            synthetic_hash.update(native)
            synthetic_runs += 1
        # large counts: whole-image comparison without per-event recording
        large = []
        if args.stage in ('all', 'loader'):
            for ns, groups in (([0] * 32767, 0), ([32767], 0), ([], 32767), ([0, 3000, 0, 1], 700)):
                payload = fixture(ns, groups, seed=3)
                original, native, events = check.compare(payload, f'large-{len(ns)}-{sum(ns)}-{groups}', 50, False,
                                                         seed=0x6e, index=0, record=False)
                large.append(dict(entries=len(ns), record35_total=sum(ns), record34=groups,
                                  image_bytes=len(original)))
        # ---- failure probes: forced allocation failure at each ordinal for small bodies ----
        forced = []
        for ns, groups in (([], 0), ([2, 0], 1), ([1, 1, 1], 0)):
            payload = fixture(ns, groups, seed=5)
            total = 3 + len(ns)
            for k in range(total):
                for inline in (False, True):
                    probe = failure_probe(machine, check, payload, 'ordinal', k, index=(0, 4)[k % 2], inline=inline)
                    stage = [STAGE_RET['header'], STAGE_RET['table']] + [STAGE_RET['record']] * len(ns) + \
                            [STAGE_RET['group']]
                    sizes = [39, 53 * len(ns)] + [35 * n for n in ns] + [34 * groups]
                    require(probe['stage_ret'] == stage[k] and probe['size'] == sizes[k] and
                            len(probe['requests']) == k + 1, f'forced failure {k}: wrong stage/size')
                    events, stores = expected_effects(
                        payload[50:], [(p, s) for p, s in probe['allocs']] + [(0, sizes[k])] +
                        [(0x30800000 + 0x1000 * j, sizes[j]) for j in range(k + 1, total)], probe['info'],
                        probe['info']['index'])
                    prefix = events[:stores[k] + 1]
                    got = machine.events
                    require(len(got) == len(prefix) and
                            all((g[0], g[1]) == (e[1], e[2]) for g, e in zip(got, prefix)) and
                            got[-1][2] == 0,
                            f'forced failure {k}: ordered effects before the diagnostic differ')
                    forced.append(dict(body_entries=len(ns), ordinal=k, stage_return=hex(probe['stage_ret']),
                                       requested=probe['size'], inline=inline))
        # ---- negative counts: the original asks for an unsatisfiable allocation and reaches the diagnostic ----
        negative = []
        for label, ns, groups, kw, stage_ret, size in (
                ('entry_count=-1', [1], 1, dict(entry_count=-1), STAGE_RET['table'], (-1 * 53) & 0xffffffff),
                ('entry_count=-32768', [1], 1, dict(entry_count=-32768), STAGE_RET['table'], (-32768 * 53) & 0xffffffff),
                ('record35_count=-1', [1, 2], 1, dict(), STAGE_RET['record'], (-1 * 35) & 0xffffffff),
                ('record35_count=-32768', [1, 2], 1, dict(), STAGE_RET['record'], (-32768 * 35) & 0xffffffff),
                ('record34_count=-1', [1, 2], 1, dict(group_count=-1), STAGE_RET['group'], (-1 * 34) & 0xffffffff),
                ('record34_count=-32768', [3], 0, dict(group_count=-32768), STAGE_RET['group'],
                 (-32768 * 34) & 0xffffffff)):
            body = make_body(ns, groups, seed=9, **kw)
            if label.startswith('record35'):
                # patch the second entry's count: its bytes follow entry 0
                patched = bytearray(body)
                value = -1 if label.endswith('-1') else -32768
                struct.pack_into('<h', patched, 39 + 49 + 35 + 0x2f, value)
                body = bytes(patched)
            payload = b'synthetic' + bytes(39) + bytes([0x2d, 1]) + body
            probe = failure_probe(machine, check, payload, 'oversize', index=0)
            require(probe['stage_ret'] == stage_ret and probe['size'] == size and size >= 0x80000000,
                    f'negative {label}: original request is not the expected oversize allocation')
            statuses = check.rejects(body)
            require(statuses == {3}, f'negative {label}: native did not reject with ERR_COUNT: {statuses}')
            negative.append(dict(case=label, original_requested_bytes=hex(size), stage_return=hex(stage_ret),
                                 native_status='ERR_COUNT'))
        # ---- owner already built: the original rejects without any allocation ----
        payload = fixture([1], 1, seed=1)
        info = machine.invoke(payload, 50, False, seed=0x21, index=2, owner_active=True, stop=REJECT_EXIT)
        uc = machine.uc
        require(not machine.requests and not machine.allocs, 'owner-active probe allocated')
        row = info['row_address']
        row_bytes = bytes(uc.mem_read(row, ROW_SIZE))
        require(row_bytes[0x30] == 0 and struct.unpack_from('<I', row_bytes, 0x85)[0] == 1 and
                struct.unpack_from('<I', row_bytes, 0x32)[0] == struct.unpack_from('<I', info['initial_action'], 0x32)[0],
                'owner-active probe: unexpected reject-path row state')
        require(struct.unpack('<I', uc.mem_read(info['ebp_frame'] - 0xcc, 4))[0] == 50 and
                struct.unpack('<I', uc.mem_read(info['ebp_frame'] - 0x20, 4))[0] == info['body_va'],
                'owner-active probe: cursor/offset advanced')
        require(machine.owner_fields() == {off: struct.unpack('<I', info['owner_window'][off - 0x200:off - 0x1fc])[0]
                                           for off in (0x222, 0x226, 0x22a, 0x23e)},
                'owner-active probe changed owner fields')
        for start, end, digest in CODE:
            require(digest is None or sha(machine.uc.mem_read(start, end - start)) == digest,
                    'emulated original code changed')
        loader_result = dict(
            corpus_records=len(records), corpus_loader_comparisons=corpus_runs,
            synthetic_loader_comparisons=synthetic_runs, large_count_comparisons=large,
            original_malloc_calls=machine.total_allocations, forced_allocation_failure_probes=len(forced),
            negative_count_probes=negative, owner_active_probes=1,
            corpus_ordered_events_compared=effect_counts, synthetic_image_bytes_compared=object_bytes,
            corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
            synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
            corpus_dependency_tails_sha256=tails.hexdigest(), original_advances=advances,
            allocation_size_classes=len(machine.sizes), hooks=HOOKS, assumptions=ASSUMPTIONS,
            stop_boundary=hex(BOUNDARY), mismatches=0)
        forced_summary = Counter((f['stage_return'], f['inline']) for f in forced)
        loader_result['forced_failure_stage_counts'] = {f'{k[0]}/inline={k[1]}': v for k, v in sorted(forced_summary.items())}
    tail_result = run_tails(args.native_library, records) if args.stage in ('all', 'tail') else None
    result = dict(slice='A-2D.1', status='pass', stage=args.stage,
        scope='successful loader/allocation graph and dependency boundary; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=corpus_hash, resources_verified=len(resources), code_windows=code),
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_2d.c').read_bytes()),
        header_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_2d.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_helper_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        loader=loader_result, tail=tail_result, mismatches=0, original_decisions_replaced=False,
        deliberate_safety_rejections=[
            'negative entry_count/record35_count/record34_count: the original requests >= 0xFFE58000 bytes (> 2 GiB); '
            'native ERR_COUNT (original behaviour observed only up to its diagnostic call)',
            'every short extent below the typed body: native ERR_BODY, including original DWORD underflow',
            'ragged dependency tail rejection is compared with the original fatal exit, not an original return code',
            'null/overlap/address wrap/zero handle/handle count/capacity tested natively; not original valid-path parity',
            'a payload shorter than 50+typed would be an original out-of-bounds read; native rejects it'],
        unverified=[
            'malloc failure beyond the diagnostic call: 0x4264e8/0x4c97b4 fatal cleanup not executed',
            'nonzero diagnostics flag: 0x4cd25a..0x4cd289, 0x4cd618..0x4cd635, 0x4cf276 dump and 0x40b43e logging',
            'owner-already-built state: only the loader reject path to 0x410c07 is observed; who sets +0x216 is not recovered',
            'prior action-slot reuse ([row+0x85] != 0) and index scan beyond free rows',
            'generic dependency opcode construction/evaluation after 0x424c94, gate 0x423f57',
            'runtime consumers of the owner object 0x63821d (0x4cd6ff, 0x4ced84, 0x4cd218, 0x4cecf7) and dispatcher arms',
            'subtype gameplay beyond header preservation, lifecycle/rendering, native gameplay and whole-file match'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=len(records),
        loader_calls=(loader_result['corpus_loader_comparisons'] + loader_result['synthetic_loader_comparisons'])
        if loader_result else 0,
        tail_parity_comparisons=tail_result['parity_comparisons'] if tail_result else 0,
        native_short_body_checks=tail_result['native_short_body_checks'] if tail_result else 0, mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
