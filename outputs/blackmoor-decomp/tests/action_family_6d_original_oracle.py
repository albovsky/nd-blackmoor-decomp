#!/usr/bin/env python3
"""A-6D.1 original loader/allocation and dependency-boundary oracle for raw 0x6d.

Run using work/tools/oracle-python/bin/python with Unicorn JIT allowed.
The unmodified loader 0x40b34a (whose raw-0x6d arm [0x40e18b,0x40e250) is
inline: no constructor call; dispatch is the loader's own index/jump tables at
0x410e9c/0x410ca4) executes under Unicorn. Only malloc (0x51dc43) and the shared
ragged-tail diagnostic boundary (0x50ca3e, inside tail_oracle_common) are
replaced; every original decision executes. The original generic dependency
loader 0x424aa8 is run through tail_oracle_common.OriginalTail for the corpus
tails, the shared TAIL_LENGTHS and WIDTH_TAILS rows. Reports are created with
exclusive open; the default report directory is unique under /private/tmp.
This is a behavioral oracle, not reconstructed source, byte matching or
runtime/gameplay coverage.
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
from test_action_family_6d import Decoded, Constructed, body_fixture, load_native, pointer, storage
import tail_oracle_common
from tail_oracle_common import (OriginalTail, NativeFamily, compare_tail, check_short_body,
                                EXIT_POINTS, HOOKS as TAIL_HOOKS, TAIL_LENGTHS, WIDTH_TAILS, require)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '30588e0a2c4eacc10ddb57b0ae6a49d314724915f5d907c437a99e9a7d55399c'
TYPE = 0x6d
BODY = 1
CODE = [
    (0x40b34a, 0x410ca4, '4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de'),
    (0x40e18b, 0x40e250, 'a5a60f31117899a2c0ea3297dc52b3e407153fe95a8300b2d30ba0fe1749f978'),   # raw-0x6d loader arm (inline allocation + copy)
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),   # loader jump table
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),   # loader index table
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),   # dependency handoff
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),   # generic dependency tail parser
]
# Static navigation only (never executed): normalised dispatcher arm for 0x6d.
STATIC_CODE = [
    (0x42a9b4, 0x42aba4, '6339877da46c0c1a66738bb918087a2cd4c0ceab39811427da4dff64f5c8f8da'),   # dispatcher jump table
    (0x42aba4, 0x42ac91, '7d726256e7d84d38c7d1677a579c09be3e2133becfbed78350302c683bec2d2e'),   # dispatcher index table
    (0x4290c0, 0x42916a, '505baa259be0d8410b6668a7c8e1c5c46aaf5dba9e2ca17575cf57eda4f5986f'),   # dispatcher arm for 0x6d
]
INPUT, OUT = 0x20000000, 0x30000010
ALLOCATOR, BOUNDARY, ARM, ARM_END = 0x51dc43, 0x410aa5, 0x40e18b, 0x40e250
ALLOC_CALLER_RET, NULL_LOG = 0x40e192, 0x40e1d6
ROW0, ROW_SIZE, INDEX_WORD = 0x5bb5b3, 0x8d, 0x5c39e3
STACK, FRAME = 0x5800, 0x7000
HOOKS = {
    'code:0x51dc43': 'only loader replacement: malloc(1) from caller return 0x40e192 (inside the loader arm); returns the guarded '
                     'allocation (or NULL in the allocation-failure probes); cdecl return',
    'code:0x40e18b': 'observer only: begin ordered-effect recording at the raw-0x6d arm',
    'code:0x40e1d6': 'observer/exit only: allocation-failure probe stops before the original diagnostic call',
    'read:0x20000000..0x2001ffff': 'observer only; reject reads outside exact ACT payload and record body coverage',
    'write:0x20000000..0x2001ffff': 'observer only; reject any ACT input write',
    'write:0x30000000..0x30001fff': 'observer only; reject writes outside the one-byte allocation',
    'write:all': 'observer only; ordered-effect list (slot store, allocation copy, offset, cursor)',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


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
        self.uc.mem_map(INPUT, 0x20000)
        self.uc.mem_map(OUT - 16, 0x2000)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations = 0
        self.sizes = Counter()
        self.recording = False
        self.fail_alloc = False
        self.events = []
        self.reads = bytearray()
        self.input_size = 0
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_CODE, self.begin_recording, begin=ARM, end=ARM)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + 0x1fff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.record_write)

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == ALLOC_CALLER_RET and size == BODY,
                f'unexpected original allocation caller/size: {ret:#x}/{size}')
        if not self.fail_alloc:
            uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * BODY + b'\xd7' * (16 + 0x2000 - 32 - BODY))
        uc.reg_write(self.r['EAX'], 0 if self.fail_alloc else OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def begin_recording(self, _uc, _address, _size, _data):
        self.recording = True
        self.events = []

    def read_input(self, _uc, _access, address, size, _value, _data):
        require(INPUT + 16 <= address and address + size <= INPUT + 16 + self.input_size,
                'original read outside exact ACT payload')
        start = address - INPUT - 16
        self.reads[start:start + size] = b'\1' * size

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise RuntimeError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + BODY,
                'original wrote outside the one-byte allocation')

    def record_write(self, _uc, _access, address, size, _value, _data):
        if self.recording:
            self.events.append((address, size))

    def classify(self, events, slot, offset_address, cursor_address, stack_floor):
        """Collapse the arm's writes into ordered categories; reject unknown writes.

        Writes below stack_floor are the arm's own pushes and the callee frame
        (saved registers, locals); every other write must be a named effect."""
        categories, object_writes, temporaries = [], [], 0
        for address, size in events:
            if address == slot and size == 4:
                kind = 'slot'
            elif OUT <= address < OUT + BODY:
                kind = 'object'
                object_writes.append((address, size))
            elif address == offset_address and size == 4:
                kind = 'offset'
            elif address == cursor_address and size == 4:
                kind = 'cursor'
            elif 0x1000 <= address < stack_floor:
                temporaries += 1
                continue
            else:
                raise RuntimeError(f'unexpected arm write {address:#x}/{size}')
            if not categories or categories[-1] != kind:
                categories.append(kind)
        return categories, object_writes

    def invoke(self, payload, offset=50, inline=False, seed=0xcd, index=0, fail=False):
        uc, r = self.uc, self.r
        require(len(payload) >= 50 + BODY and payload[48] == TYPE, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        require(len(payload) + 32 <= 0x20000, 'oracle fixture exceeds mapped input budget')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        require(0 <= index < 16, 'unsupported oracle action index')
        self.seed, self.fail_alloc = seed, fail
        self.input_size = len(payload)
        self.reads = bytearray(len(payload))
        self.recording = False
        row_address = ROW0 + index * ROW_SIZE
        slot = row_address + 0x32
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        # Caller state: rows below the chosen index are free (zero +0x85); the
        # loader's slot scan then keeps the index. Rows are guarded on both sides.
        uc.mem_write(INDEX_WORD, struct.pack('<H', index))
        uc.mem_write(ROW0, bytes(ROW_SIZE * index))
        initial_action = bytearray((i * 19 + seed) & 255 for i in range(ROW_SIZE))
        initial_action[0x85:0x89] = bytes(4)   # +0x85 (0x5bb638 for row 0) must be zero for a free slot
        # The previous row's +0x85 word must stay zero or the loader's slot scan would move the index.
        pre = bytearray(b'\x91' * 16)
        if index:
            pre[8:12] = bytes(4)
        pre = bytes(pre)
        uc.mem_write(row_address - 16, pre + initial_action + b'\x92' * 16)
        uc.mem_write(OUT - 16, b'\x00' * 0x2000)
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
            frame = FRAME
            ebp_frame = frame
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
        before = self.allocations
        if fail:
            uc.emu_start(entry, NULL_LOG, count=100000)
            require(uc.reg_read(r['EIP']) == NULL_LOG and self.allocations == before + 1,
                    'allocation-failure probe did not stop at the original diagnostic call')
            require(struct.unpack('<I', uc.mem_read(slot, 4))[0] == 0,
                    'original did not store the NULL allocation in the action slot')
            require(bytes(uc.mem_read(OUT - 16, 0x2000)) == bytes(0x2000),
                    'original wrote the allocation despite NULL')
            require(struct.unpack('<I', uc.mem_read(cursor_address, 4))[0] == body_va and
                    struct.unpack('<I', uc.mem_read(offset_address, 4))[0] == offset,
                    'original advanced cursor/offset despite NULL')
            categories, object_writes = self.classify(self.events, slot, offset_address, cursor_address, ebp_frame)
            require(categories == ['slot'] and not object_writes,
                    f'unexpected NULL-path effects: {categories}')
            logged = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
            scene = struct.unpack('<I', uc.mem_read(0x5bb57b, 4))[0]
            require(logged == (0x63888b, 0x540100, scene, index),
                    'unexpected NULL-path diagnostic arguments')
            return None
        uc.emu_start(entry, BOUNDARY, count=100000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original failed to reach dependency handoff with one allocation')
        frame = uc.reg_read(r['EBP'])
        require(frame == ebp_frame, 'unexpected loader frame')
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        forwarded = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        require(forwarded == (row_address, consumed, len(payload), cursor),
                'original dependency arguments do not reflect cursor/offset')
        expected[0x32:0x36] = struct.pack('<I', OUT)
        for address, data in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (OUT - 16, b'\xa5' * 16), (OUT + BODY, b'\xd7' * (0x2000 - 16 - BODY)),
                              (row_address - 16, pre), (row_address, bytes(expected)),
                              (row_address + ROW_SIZE, b'\x92' * 16), (STACK, args),
                              (STACK - 0x1000, b'\x93' * 16), (STACK + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        # Ordered effects: slot store before the copy, copy before offset, offset before cursor.
        categories, object_writes = self.classify(self.events, slot, offset_address, cursor_address, ebp_frame)
        require(categories == ['slot', 'object', 'offset', 'cursor'],
                f'unexpected ordered effects: {categories}')
        require(object_writes == [(OUT, 1)], 'original copy is not exactly one BYTE write')
        # The arm reads exactly the one body byte and never the dependency tail.
        require(bytes(self.reads[50:50 + BODY]) == b'\1' * BODY and not any(self.reads[50 + BODY:]),
                'original body/tail read coverage mismatch')
        require(any(self.reads[:50]) == (not inline), 'original header read coverage mismatch')
        self.recording = False
        return bytes(uc.mem_read(OUT, BODY)), cursor - body_va, consumed


def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xcd, index=0):
    body, d, native, length = payload[50:], Decoded(), Constructed(), C.c_size_t()
    raw = storage(body)
    original, advance, consumed = machine.invoke(payload, offset, inline, seed, index)
    require(lib.action_family_6d_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected valid original record {ordinal}')
    require(bytes([d.byte_0]) == original, f'decoded neutral field mismatch record {ordinal}')
    require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
             d.dependency_bytes, d.dependency_count) ==
            (advance, len(body), C.addressof(raw) + advance, len(body) - advance,
             (len(body) - advance) // 16), f'decoded body/tail mismatch record {ordinal}')
    require(lib.action_family_6d_body_length(raw, len(body), C.byref(length)) == 0 and
            length.value == advance, f'body_length/original cursor mismatch record {ordinal}')
    require(lib.action_family_6d_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected valid original record {ordinal}')
    require(bytes(native.object_bytes) == original,
            f'original/native allocation mismatch record {ordinal}')
    require((advance, consumed) == (BODY, (offset + BODY) & 0xffffffff),
            f'original body rule mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, (len(body) - advance) // 16,
             len(body) - advance, len(body)), f'original/native cursor/body rule mismatch record {ordinal}')
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, BODY, payload[48], payload[48]), f'original/native allocation constants mismatch record {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return bytes(native.object_bytes), original


class NativeTail(NativeFamily):
    def __init__(self, library):
        # Reuse shared execution/guard discipline without changing its registry.
        self.family, self.library = '6d', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(library)
        self.decode = self.lib.action_family_6d_decode
        self.body_length = self.lib.action_family_6d_body_length


def run_tails(library, records):
    native, machine = NativeTail(library), OriginalTail()
    exits = Counter()
    digest = hashlib.sha256()
    counts = dict(corpus=0, synthetic=0, short=0, width=0)

    def one(payload, typed):
        result = compare_tail(native, machine, payload, typed)
        # body_length acceptance must independently agree with the original tail
        # exit; its successful value must equal the original loader's cursor delta.
        raw, n = storage(payload[50:]), C.c_size_t(0xa5a5a5a5)
        before = n.value
        status = native.body_length(raw, len(payload) - 50, C.byref(n))
        require((status == 0) == result.accepted and
                (n.value == typed if result.accepted else n.value == before),
                'body_length/original tail exit mismatch')
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))

    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))
    for payload, typed in records:
        typed = native.validated_length(payload, typed)
        one(payload, typed)
        counts['corpus'] += 1
        prefix = payload[:50 + typed]
        for length in TAIL_LENGTHS:
            one(prefix + pattern[:length], typed)
            counts['synthetic'] += 1
        # Fully backed short probes avoid undefined host reads by missing-guard
        # mutants. Original arithmetic underflow can accept negative multiples of
        # 16; native ERR_BODY is a separate safety contract, not parity.
        for length in range(typed):
            check_short_body(native, machine, prefix, typed, length)
            raw, n = storage(prefix[50:]), C.c_size_t(0xa5a5a5a5)
            status = native.body_length(raw, length, C.byref(n))
            require(status == 2 and n.value == 0xa5a5a5a5, 'native short-body body_length safety mismatch')
            out = Constructed()
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            status = native.lib.action_family_6d_construct(raw, length, 50, OUT, C.byref(out))
            require(status == 2 and bytes(out) == before, 'native short-body constructor safety mismatch')
            counts['short'] += 1
    payload, typed = records[0]
    for tail in WIDTH_TAILS:
        one(payload[:50 + typed] + bytes(tail), typed)
        counts['width'] += 1
    require(sha(machine.uc.mem_read(CODE[-1][0], CODE[-1][1] - CODE[-1][0])) == CODE[-1][2],
            'emulated dependency code changed')
    parity = counts['corpus'] + counts['synthetic'] + counts['width']
    return dict(corpus_records=counts['corpus'], tail_lengths=list(TAIL_LENGTHS),
                width_tails=list(WIDTH_TAILS), synthetic_tail_comparisons=counts['synthetic'],
                width_comparisons=counts['width'], parity_comparisons=parity,
                native_short_body_checks=counts['short'], original_calls=machine.calls,
                exit_counts=dict(exits), observed_exits_counts_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS, mismatches=0,
                scope='original empty/modulus/count/fatal boundary; stop before opcode construction')


def run_shared_family(library):
    """Run the shared A-TAIL.2 stage with a runtime-registered '6d' entry.

    The shared module is read-only here; the entry is added to its in-memory
    registry only, with exactly the corpus pin proposed for FAMILIES."""
    tail_oracle_common.FAMILIES['6d'] = (1, CORPUS_HASH)
    native = NativeFamily('6d', library)
    corpus = tail_oracle_common.Corpus()
    result = tail_oracle_common.run_family(native, OriginalTail(), corpus.records('6d'))
    return dict(parity_comparisons=result['parity_comparisons'], corpus_records=result['corpus_records'],
                native_short_body_checks=result['native_short_body_checks'],
                exit_counts=result['exit_counts'], mismatches=result['mismatches'],
                observed_exits_counts_sha256=result['observed_exits_counts_sha256'])


def read_inputs():
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-6D.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x6d_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 1, 1),
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
                (n, p + 50, len(body), sha(body), TYPE, row['subtype'], BODY, (len(body) - BODY) // 16,
                 len(body) - BODY, sha(body[:BODY]), sha(body[BODY:])), f'corpus row mismatch: {ordinal}')
        records.append((payload, BODY))
    return resources, records, corpus


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily6d.dylib')
    ap.add_argument('--result', type=Path)
    ap.add_argument('--stage', choices=('all', 'tail'), default='all')
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-6D.1.oracle-', dir='/private/tmp')) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records, corpus = read_inputs()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    code = []
    for start, end, digest in CODE + STATIC_CODE:
        actual = sha(pe.image[start - pe.image_base:end - pe.image_base])
        require(digest is None or actual == digest, f'code window mismatch: {start:#x}')
        code.append(dict(start=hex(start), end_exclusive=hex(end), sha256=actual,
                         executed=(start, end, digest) in CODE))
    loader_result = None
    if args.stage == 'all':
        machine, lib = Original(pe), load_native(args.native_library)
        native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
        advances = []
        corpus_comparisons = 0
        for ordinal, (payload, typed) in enumerate(records):
            for index in (0, 3):   # full loader with a nonzero action index as well
                native, original = compare(lib, machine, payload, f'corpus-{ordinal}-row{index}',
                                           seed=(ordinal * 31 + 7) & 255, index=index)
                corpus_comparisons += 1
                if index == 0:
                    native_hash.update(native); original_hash.update(original)
            body = payload[50:]
            advances.append(BODY)
            bodies.update(body); tails.update(body[typed:])
        synthetic_hash = hashlib.sha256()
        # All 256 subtype encodings, every body byte value, empty and short/long tails,
        # allocation fill independence, offset wrap and action indexes for the direct
        # arm; the full loader (including its own type-table dispatch) for every subtype.
        full_calls = inline_calls = 0
        for subtype in range(256):
            value = subtype if subtype % 2 else (subtype * 37 + 5) & 255
            body = body_fixture(value, (0, 1, 2)[subtype % 3], seed=subtype)
            payload = b'synthetic' + bytes(39) + bytes([TYPE, subtype]) + body
            for inline in (False, True):
                offset = (0, 50, 0xffffffff, 0xfffffffe)[subtype % 4] if inline else 50
                index = (0, 1, 5, 15)[subtype % 4] if inline else (0, 2)[subtype % 2]
                native, original = compare(lib, machine, payload, f'synthetic-{subtype}-{inline}',
                                           offset, inline, seed=subtype ^ 0xa5, index=index)
                synthetic_hash.update(native)
                full_calls += not inline
                inline_calls += inline
        # Allocation failure: original stores NULL in the slot, writes nothing and enters its diagnostic.
        null_calls = 0
        for ordinal, (payload, _) in enumerate(records):
            for inline in (False, True):
                machine.invoke(payload, 50, inline, seed=0x11, index=0, fail=True)
                null_calls += 1
        for start, end, digest in CODE:
            require(digest is None or sha(machine.uc.mem_read(start, end - start)) == digest,
                    'emulated original code changed')
        loader_result = dict(corpus_records=len(records), corpus_loader_comparisons=corpus_comparisons,
            original_malloc_calls=machine.allocations - null_calls,
            full_loader_calls=corpus_comparisons + full_calls, inline_arm_calls=inline_calls,
            allocation_failure_probes=null_calls,
            corpus_object_bytes_compared=corpus_comparisons * BODY, synthetic_object_bytes_compared=512 * BODY,
            corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
            synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
            corpus_dependency_tails_sha256=tails.hexdigest(), allocation_sizes=dict(machine.sizes),
            original_advances=advances, ordered_effects=['slot', 'object', 'offset', 'cursor'],
            hooks=HOOKS, stop_boundary=hex(BOUNDARY), mismatches=0)
    tail_result = run_tails(args.native_library, records)
    shared_result = run_shared_family(args.native_library)
    result = dict(slice='A-6D.1', status='pass', stage=args.stage,
        scope='successful loader/allocation and dependency boundary; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=code),
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_6d.c').read_bytes()),
        header_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_6d.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_helper_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        loader=loader_result, tail=tail_result, shared_family_stage=shared_result,
        mismatches=0, original_decisions_replaced=False,
        deliberate_safety_rejections=['the zero-length body; native ERR_BODY, including original DWORD underflow in the tail count',
            'ragged dependency tail rejection is compared with original fatal exit, not an original return code',
            'null/overlap/address wrap/zero handle tested natively; not original valid-path parity',
            'a payload shorter than 50+1 would be an original out-of-bounds read; native rejects it',
            'there is no body count: negative/overflow counts are inapplicable; the body byte is unrestricted'],
        unverified=['malloc failure beyond the diagnostic call: 0x42639d/0x4c97b4 fatal cleanup not executed',
            'nonzero diagnostics flag: 0x40e23e -> 0x44a2b7 and 0x40b43e logging',
            'prior action-slot reuse ([row+0x85] != 0) and index scan beyond free rows',
            'generic dependency opcode construction/evaluation after 0x424c94, gate 0x423f57',
            'dispatcher arm 0x4290c0 -> gate 0x423f57 -> 0x4e303b/0x4eb96e/0x4e7d04/0x4fb018 runtime (static navigation only; the arm never reads the allocated byte)',
            'subtype gameplay beyond header preservation, lifecycle/rendering, native gameplay and whole-file match'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=len(records),
        loader_calls=(loader_result['full_loader_calls'] + loader_result['inline_arm_calls']) if loader_result else 0,
        tail_parity_comparisons=tail_result['parity_comparisons'],
        shared_family_comparisons=shared_result['parity_comparisons'],
        native_short_body_checks=tail_result['native_short_body_checks'], mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
