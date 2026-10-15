#!/usr/bin/env python3
"""A-F6.1 original loader/allocation and dependency-boundary oracle.

Run using work/tools/oracle-python/bin/python with Unicorn JIT allowed.
Only malloc (0x51dc43) and the shared ragged-tail diagnostic boundary
(0x50ca3e, inside tail_oracle_common.OriginalTail) are replaced. Original
decisions execute unchanged; no executable is launched or patched. Reports
are exclusively created at unique paths under a temporary directory.

Stages: 'all' runs the full raw-type loader 0x40b34a (corpus + synthetic),
direct entries of the allocation function 0x45ddd0, then the dependency tail
stage; 'tail' runs only the tail stage (still driven by the original loader's
cursor advance).
"""
import argparse
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
from test_action_family_f6 import Decoded, Constructed, body_fixture, load_native, pointer, storage
from tail_oracle_common import (OriginalTail, NativeFamily, compare_tail, check_short_body,
                                EXIT_POINTS, HOOKS as TAIL_HOOKS, TAIL_LENGTHS, WIDTH_TAILS, require)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '0f365b52ada75de98e2905408c9b2b485bdc5a5458ad7f17fceafc3dd41018b4'
CODE = [
    (0x40b34a, 0x410ca4, '4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de'),
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x4109f8, 0x410a22, '75fcf9dcb02f234fa0c3d379a6aff803c7f52fe03f7a839408d8f59d8c2c7cb7'),
    (0x45ddd0, 0x45de8a, 'f94571a2f85d749d5a34e28bc17837b4eb13db7f9795438d17169a51559c6424'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT, INPUT_MAP = 0x20000000, 0x211000
OUT, OUT_MAP = 0x30000010, 0x2000
ACTION, SLOT, ALLOCATOR, BOUNDARY = 0x5bb5b3, 0x5bb5e5, 0x51dc43, 0x410aa5
THIS_F6, CTOR, CTOR_RET = 0x61f4b1, 0x45ddd0, 0x51000000
OBJECT, COPY = 0x1346, 0x1346
HOOKS = {
    'code:0x51dc43': 'only loader replacement: guarded successful malloc(0x1346) from caller 0x45dde5, cdecl return',
    'read:0x20000000..0x202110ff': 'observer only; reject reads outside the ACT header + exact 4,934-byte body span',
    'write:0x20000000..0x202110ff': 'observer only; reject any ACT input write',
    'write:0x30000000..0x30001fff': 'observer only; reject writes outside the 4,934-byte allocation, record coverage',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def pin_code(pe):
    rows = []
    for start, end, digest in CODE:
        got = sha(pe.image[start - pe.image_base:end - pe.image_base])
        if digest is not None:
            require(got == digest, f'code window mismatch: {start:#x}')
        rows.append((start, end, got))
    return rows


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
        from unicorn import x86_const as x
        self.r = {name: getattr(x, 'UC_X86_REG_' + name) for name in
                  ('EAX', 'EBX', 'ECX', 'EDX', 'ESI', 'EDI', 'EBP', 'ESP', 'EIP', 'EFLAGS', 'ES')}
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(0x1000, 0x10000)
        self.uc.mem_map(INPUT, INPUT_MAP)
        self.uc.mem_map(OUT - 16, OUT_MAP)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations = 0
        self.sizes = Counter()
        self.reads = bytearray()
        self.writes = bytearray()
        self.read_lo = self.read_hi = self.body_lo = self.body_hi = 0
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + INPUT_MAP - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + INPUT_MAP - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + OUT_MAP - 1)

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == 0x45dde5 and size == OBJECT,
                f'unexpected original allocation caller/size: {ret:#x}/{size}')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * OBJECT + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def read_input(self, _uc, _access, address, size, _value, _data):
        require(self.read_lo <= address and address + size <= self.read_hi,
                f'original read outside permitted ACT span: {address:#x}+{size}')
        if self.body_lo <= address < self.body_hi:
            require(address + size <= self.body_hi, 'original body read crosses the 4,934-byte body end')
            self.reads[address - self.body_lo:address - self.body_lo + size] = b'\1' * size

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise RuntimeError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + OBJECT,
                'original wrote outside 4,934-byte allocation')
        self.writes[address - OUT:address - OUT + size] = b'\1' * size

    def arm(self, read_lo, read_hi, body_lo):
        # Body-copy coverage: every body byte is read, none after it (the tail
        # is not read by the loader or by this stage).
        self.read_lo, self.read_hi, self.body_lo, self.body_hi = read_lo, read_hi, body_lo, body_lo + COPY
        self.reads = bytearray(COPY)
        self.writes = bytearray(OBJECT)

    def check_coverage(self):
        require(bytes(self.reads) == b'\1' * COPY, 'original did not read every body byte exactly in range')
        require(bytes(self.writes) == b'\1' * OBJECT, 'original did not write the entire allocation')

    def guards(self, payload_len):
        return [(INPUT, b'\xa6' * 16), (OUT - 16, b'\xa5' * 16), (OUT + OBJECT, b'\xd7' * 16),
                (ACTION - 16, b'\x91' * 16), (ACTION + 0x8d, b'\x92' * 16)]

    def invoke(self, payload, seed=0xcd):
        """Full raw-type loader entry 0x40b34a, stop at the dependency handoff."""
        uc, r = self.uc, self.r
        require(len(payload) >= 50 + OBJECT and payload[48] == 0xf6, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        require(len(payload) + 32 <= INPUT_MAP, 'oracle fixture exceeds mapped input budget')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        self.seed = seed
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        uc.mem_write(0x5c39e3, bytes(2))  # caller state: fresh action slot zero
        initial_action = bytearray((i * 19 + seed) & 255 for i in range(0x8d))
        uc.mem_write(ACTION - 16, b'\x91' * 16 + initial_action + b'\x92' * 16)
        stack = 0x5800
        args = struct.pack('<III', 0x51000000, INPUT + 16, len(payload))
        uc.mem_write(stack, args)
        uc.mem_write(stack - 0x1000, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, ESP=stack, EFLAGS=0x202).items():
            uc.reg_write(r[name], value)
        body_va = INPUT + 16 + 50
        self.arm(INPUT + 16, body_va + COPY, body_va)
        expected = bytearray(initial_action)
        name_end = payload.index(0, 0, 48) + 1
        expected[:name_end] = payload[:name_end]
        expected[0x30:0x32] = payload[48:50]
        before = self.allocations
        uc.emu_start(0x40b34a, BOUNDARY, count=5000000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original failed to reach dependency handoff with one allocation')
        self.check_coverage()
        frame = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        forwarded = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        require(forwarded == (ACTION, consumed, len(payload), cursor),
                'original dependency arguments do not reflect cursor/offset')
        expected[0x32:0x36] = struct.pack('<I', OUT)
        for address, data in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (OUT - 16, b'\xa5' * 16), (OUT + OBJECT, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)),
                              (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, OBJECT)), cursor - body_va, consumed

    def invoke_function(self, body, offset, pad=0, seed=0xcd):
        """Direct call of the real function 0x45ddd0 (thiscall, ret 0xc)."""
        uc, r = self.uc, self.r
        require(len(body) >= OBJECT and 0 <= pad < 16, 'invalid direct fixture')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        self.seed = seed
        cursor = INPUT + 16 + pad
        uc.mem_write(INPUT, b'\xa6' * 16 + bytes((i * 3 + 1) & 255 for i in range(pad)) + body + b'\xd6' * 16)
        uc.mem_write(0x5c39e3, bytes(2))
        initial_action = bytes((i * 29 + seed) & 255 for i in range(0x8d))
        uc.mem_write(ACTION - 16, b'\x91' * 16 + initial_action + b'\x92' * 16)
        stack, cursor_var, offset_var = 0x5800, 0x5a00, 0x5a04
        uc.mem_write(cursor_var, struct.pack('<II', cursor, offset))
        args = struct.pack('<4I', CTOR_RET, SLOT, cursor_var, offset_var)
        uc.mem_write(stack, args)
        uc.mem_write(stack - 0x100, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=THIS_F6,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, ESP=stack, EFLAGS=0x202).items():
            uc.reg_write(r[name], value)
        self.arm(cursor, cursor + COPY, cursor)
        before = self.allocations
        uc.emu_start(CTOR, CTOR_RET, count=5000000)
        require(uc.reg_read(r['EIP']) == CTOR_RET and self.allocations == before + 1,
                'original constructor did not return with one allocation')
        self.check_coverage()
        require(uc.reg_read(r['ESP']) == stack + 16, 'original did not pop return + 12 argument bytes')
        require((uc.reg_read(r['EBP']), uc.reg_read(r['ESI']), uc.reg_read(r['EDI'])) ==
                (0x77777777, 0x55555555, 0x66666666), 'original callee-saved registers changed')
        cursor_after, offset_after = struct.unpack('<II', uc.mem_read(cursor_var, 8))
        expected = bytearray(initial_action)
        expected[SLOT - ACTION:SLOT - ACTION + 4] = struct.pack('<I', OUT)
        for address, data in ((INPUT, b'\xa6' * 16), (OUT - 16, b'\xa5' * 16), (OUT + OBJECT, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)), (ACTION + 0x8d, b'\x92' * 16),
                              (stack - 0x100, b'\x93' * 16), (stack + 32, b'\x94' * 16),
                              (INPUT + 16 + pad, body), (INPUT + 16 + pad + len(body), b'\xd6' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original constructor guard mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, OBJECT)), cursor_after - cursor, offset_after


def compare(lib, machine, payload, ordinal, seed=0xcd):
    body, d, native, length = payload[50:], Decoded(), Constructed(), C.c_size_t()
    raw = storage(body)
    original, advance, consumed = machine.invoke(payload, seed)
    require(lib.action_family_f6_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected valid original record {ordinal}')
    require(bytes(d.body) == original, f'decoded body mismatch record {ordinal}')
    require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
             d.dependency_bytes, d.dependency_count) ==
            (advance, len(body), C.addressof(raw) + advance, len(body) - advance,
             (len(body) - advance) // 16), f'decoded body/tail mismatch record {ordinal}')
    require(lib.action_family_f6_body_length(raw, len(body), C.byref(length)) == 0 and
            length.value == advance, f'body_length/original cursor mismatch record {ordinal}')
    require(lib.action_family_f6_construct(raw, len(body), 50, OUT, C.byref(native)) == 0,
            f'native constructor rejected valid original record {ordinal}')
    require(bytes(native.object_bytes) == original,
            f'original/native allocation mismatch record {ordinal}')
    require((advance, consumed) == (OBJECT, (50 + OBJECT) & 0xffffffff),
            f'original body rule mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, 50, consumed, C.addressof(raw) + advance, (len(body) - advance) // 16,
             len(body) - advance, len(body)), f'original/native cursor/body rule mismatch record {ordinal}')
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, OBJECT, payload[48], payload[48]), f'original/native allocation constants mismatch record {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return bytes(native.object_bytes), original


def compare_function(lib, machine, body, offset, pad, ordinal, seed):
    raw = storage(body)
    original, advance, offset_after = machine.invoke_function(body, offset, pad, seed)
    native, d = Constructed(), Decoded()
    require(lib.action_family_f6_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected direct entry {ordinal}')
    require(lib.action_family_f6_decode(raw, len(body), C.byref(d)) == 0 and bytes(d.body) == original,
            f'direct entry decoded body mismatch {ordinal}')
    require(bytes(native.object_bytes) == original, f'direct entry allocation mismatch {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_after) == (advance, offset_after),
            f'direct entry cursor/offset mismatch {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return original


class NativeTail(NativeFamily):
    def __init__(self, library):
        # Reuse shared execution/guard discipline without changing its registry.
        self.family, self.library = 'f6', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(library)
        self.decode = self.lib.action_family_f6_decode
        self.body_length = self.lib.action_family_f6_body_length


def run_tails(library, records, loader):
    native, machine = NativeTail(library), OriginalTail()
    exits = Counter()
    digest = hashlib.sha256()
    counts = Counter()

    def one(payload):
        # typed extent is the ORIGINAL loader's cursor advance for this exact payload.
        _obj, advance, consumed = loader.invoke(payload)
        require(consumed == 50 + advance, 'original offset/cursor advance disagree')
        result = compare_tail(native, machine, payload, advance)
        raw, n = storage(payload[50:]), C.c_size_t(0xa5a5a5a5)
        before = n.value
        status = native.body_length(raw, len(payload) - 50, C.byref(n))
        require((status == 0) == result.accepted and
                (n.value == advance if result.accepted else n.value == before),
                'body_length/original tail exit mismatch')
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))
        return advance

    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))
    for ordinal, payload in enumerate(records):
        advance = one(payload)
        counts['corpus'] += 1
        prefix = payload[:50 + advance]
        for tail in TAIL_LENGTHS:
            one(prefix + pattern[:tail])
            counts['synthetic'] += 1
        logicals = range(advance) if ordinal == 0 else (0, 1, 15, 16, 17, advance - 17, advance - 16,
                                                         advance - 15, advance - 1)
        for logical in logicals:
            # Separate native safety contract; excluded from tail parity counts.
            check_short_body(native, machine, prefix, advance, logical)
            raw, n = storage(prefix[50:]), C.c_size_t(0xa5a5a5a5)
            status = native.body_length(raw, logical, C.byref(n))
            require(status == 2 and n.value == 0xa5a5a5a5, 'native short-body body_length safety mismatch')
            out = Constructed()
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); stale = bytes(out)
            status = native.lib.action_family_f6_construct(raw, logical, 50, OUT, C.byref(out))
            require(status == 2 and bytes(out) == stale, 'native short-body constructor safety mismatch')
            counts['short'] += 1
    prefix = records[0][:50 + OBJECT]
    for tail in WIDTH_TAILS:
        one(prefix + bytes(tail))
        counts['synthetic'] += 1
    # 8/16-bit count endpoints: rows 255, 256, 257, 65535, 65536, 65537
    for rows in (255, 257, 65535):
        one(prefix + bytes(rows * 16))
        counts['synthetic'] += 1
    require(sha(machine.uc.mem_read(CODE[-1][0], CODE[-1][1] - CODE[-1][0])) == CODE[-1][2],
            'emulated dependency code changed')
    return dict(corpus_records=counts['corpus'], tail_lengths=list(TAIL_LENGTHS),
                width_tail_bytes=list(WIDTH_TAILS) + [255 * 16, 257 * 16, 65535 * 16],
                synthetic_tail_comparisons=counts['synthetic'],
                parity_comparisons=counts['corpus'] + counts['synthetic'],
                loader_cursor_advances_used=counts['corpus'] + counts['synthetic'],
                native_short_body_checks=counts['short'], original_tail_calls=machine.calls,
                exit_counts=dict(exits), observed_exits_counts_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS, mismatches=0,
                scope='original empty/modulus/count/fatal boundary; stop before opcode construction')


def read_inputs():
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-F6.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0xf6_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 6, 6),
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
        require((len(payload), row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['typed_body_sha256'], row['dependency_tail_sha256']) ==
                (n, p + 50, len(body), sha(body), 0xf6, row['subtype'], OBJECT, (len(body) - OBJECT) // 16,
                 len(body) - OBJECT, sha(body[:OBJECT]), sha(body[OBJECT:])), f'corpus row mismatch: {ordinal}')
        records.append(payload)
    return resources, records


def synthetic_body(subtype, tail):
    lcg = (subtype * 2654435761 + 12345) & 0xffffffff
    out = bytearray()
    for _ in range(OBJECT):
        lcg = (lcg * 1664525 + 1013904223) & 0xffffffff
        out.append(lcg >> 24)
    mode = subtype % 8
    if mode == 0:
        out = bytearray(OBJECT)
    elif mode == 1:
        out = bytearray(b'\xff' * OBJECT)
    elif mode == 2:
        out[:] = bytes((subtype + i) & 255 for i in range(OBJECT))  # distinct, ASCII-ish prefix
    return bytes(out) + bytes((i * 7 + subtype) & 255 for i in range(tail * 16))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path, required=True)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--stage', choices=('all', 'tail'), default='all')
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-F6.1.oracle-', dir='/private/tmp')) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records = read_inputs()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    windows = pin_code(pe)
    machine = Original(pe)
    loader_result = None
    if args.stage == 'all':
        lib = load_native(args.native_library)
        native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
        for ordinal, payload in enumerate(records):
            native, original = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
            native_hash.update(native); original_hash.update(original)
            bodies.update(payload[50:]); tails.update(payload[50 + OBJECT:])
        synthetic_hash = hashlib.sha256()
        # All 256 subtype encodings through the full loader; body modes: zero, 0xff,
        # distinct and pseudo-random bytes (no NUL requirement); tail counts 0/1/2/255.
        for subtype in range(256):
            body = synthetic_body(subtype, (0, 1, 2, 255)[subtype % 4])
            payload = b'synthetic' + bytes(39) + bytes([0xf6, subtype]) + body
            native, original = compare(lib, machine, payload, f'synthetic-{subtype}', seed=subtype ^ 0xa5)
            synthetic_hash.update(native)
        # Dependency-count width endpoints through the full loader and native constructor.
        for rows in (255, 256, 257, 65535, 65536, 65537):
            payload = b'synthetic' + bytes(39) + bytes([0xf6, 1]) + synthetic_body(0x5a, 0) + bytes(rows * 16)
            native, original = compare(lib, machine, payload, f'width-{rows}', seed=rows & 255)
            synthetic_hash.update(native)
        # Direct entries of the real allocation function 0x45ddd0: offset (payload offset)
        # wrap, cursor alignment, allocator fill independence.
        direct_hash = hashlib.sha256()
        for subtype in range(256):
            body = synthetic_body(subtype ^ 0x55, 0)
            offset = (0, 50, 0xffffecba, 0xffffecbb, 0xffffffff, 0x80000000, 0x7fffffff, 1)[subtype % 8]
            direct_hash.update(compare_function(lib, machine, body, offset, subtype % 16,
                                                f'direct-{subtype}', subtype ^ 0x3c))
        rows = pin_code(pe)
        for (start, end, _), (_, _, digest) in zip(windows, rows):
            require(sha(machine.uc.mem_read(start, end - start)) == digest, 'emulated original code changed')
        loader_result = dict(corpus_records=6, corpus_original_calls=6, synthetic_original_calls=262,
            full_loader_calls=268, direct_constructor_entries=256,
            original_allocations=machine.allocations,
            corpus_object_bytes_compared=6 * OBJECT, synthetic_object_bytes_compared=(262 + 256) * OBJECT,
            corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
            synthetic_object_sha256=synthetic_hash.hexdigest(), direct_object_sha256=direct_hash.hexdigest(),
            corpus_raw_bodies_sha256=bodies.hexdigest(), corpus_dependency_tails_sha256=tails.hexdigest(),
            allocation_sizes=dict(machine.sizes), hooks=HOOKS, stop_boundary=hex(BOUNDARY), mismatches=0)
    tail_result = run_tails(args.native_library, records, machine)
    result = dict(slice='A-F6.1', status='pass', stage=args.stage,
        scope='successful loader/allocation and dependency boundary; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources),
                    code_windows=[dict(start=hex(a), end_exclusive=hex(b), sha256=c) for a, b, c in windows]),
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_f6.c').read_bytes()),
        header_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_f6.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_helper_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        loader=loader_result, tail=tail_result, mismatches=0, original_decisions_replaced=False,
        deliberate_safety_rejections=['all short extents 0..4933 (record 0) and edge extents (others); native ERR_BODY, including original DWORD underflow',
            'ragged dependency tail rejection is compared with original fatal exit, not an original return code',
            'null/overlap/address wrap/zero handle tested natively; not original valid-path parity',
            'there is no body count: negative/overflow counts are inapplicable; every body byte pattern is data'],
        unverified=['malloc failure and cleanup at 0x42639d/0x4c97b4 (0x45ddf3 null branch)',
            'nonzero diagnostics flag at 0x45de6a/0x44a2b7', 'prior action-slot reuse and nonzero action index',
            'generic dependency opcode construction/evaluation after 0x424c94, gate 0x423f57',
            'dispatcher arm 0x42a92b, runtime handler 0x45f0e6 and all field semantics of the 4,934-byte object',
            'subtype gameplay beyond header preservation, lifecycle/rendering, native gameplay and whole-file match'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=6,
        loader_calls=loader_result['full_loader_calls'] + loader_result['direct_constructor_entries'] if loader_result else 0,
        tail_parity_comparisons=tail_result['parity_comparisons'],
        native_short_body_checks=tail_result['native_short_body_checks'], mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
