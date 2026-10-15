#!/usr/bin/env python3
"""A-EA.1 original loader/allocation and dependency-boundary oracle for raw 0xea.

Run using work/tools/oracle-python/bin/python with Unicorn JIT allowed.
Only malloc (0x51dc43) and the shared ragged-tail diagnostic boundary
(0x50ca3e, via tail_oracle_common.OriginalTail) are replaced. Original decisions
execute unchanged; no executable is launched or patched. Reports are created
exclusively at unique paths under /private/tmp unless --result is given.

Stages per payload: (1) the original full raw-type loader 0x40b34a runs to its
dependency hand-off at 0x410aa5 (dispatch through 0x410e9c/0x410ca4 to arm
0x410893 and method 0x484110); the body extent is the original cursor advance
(cursor - body_va). (2) That extent is fed to the original generic dependency
loader 0x424aa8 (OriginalTail) and native accept/reject, dependency_count and
body_length are compared with what the original does.
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
from test_action_family_ea import Decoded, Constructed, body_fixture, load_native, pointer, storage
from tail_oracle_common import (OriginalTail, NativeFamily, compare_tail, check_short_body,
                                EXIT_POINTS, HOOKS as TAIL_HOOKS, TAIL_LENGTHS, WIDTH_TAILS, require)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_NAME = 'A-EA.1.corpus.json'
CORPUS_HASH = '236b9cf767ac272b09dff01e6408bc868a8855636995ce7001efaa4d754be4a6'
BODY = 3847
CODE = [
    (0x40b34a, 0x410ca4, '4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de'),  # raw-type loader
    (0x410893, 0x4108c0, 'f3a5787327551304d8a067c4dd5dfe890e7af7ce07129d9ab342b1024db6f313'),  # 0xea arm
    (0x484110, 0x4841cb, 'f2b4c99b905fd4f8d1bf46b915e7827d0a7df2b8a16d018ad593a10b25e61dd0'),  # 0xea body method
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),  # jump table
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),  # index table
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),  # dependency hand-off
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),  # generic tail loader
]
STATIC_FOLLOWUP_CODE = [
    (0x42a759, 0x42a794, '244be071c70d97af26ddee0850fe496ee6fb305f383b1d58d081c669e156f344'),  # dispatcher arm (not executed)
]
INPUT, INPUT_SPAN, OUT = 0x20000000, 0x201000, 0x30000010
ACTION0, ROW, INDEX, ALLOCATOR, BOUNDARY = 0x5bb5b3, 0x8d, 0x5c39e3, 0x51dc43, 0x410aa5
METHOD, METHOD_THIS, RETURN = 0x484110, 0x6252ad, 0x51000000
ALLOC_CALLER = 0x484125
ACTION_INDICES = (0, 1, 15, 16, 100, 200)
HOOKS = {
    'code:0x51dc43': 'only loader replacement: guarded successful malloc(0xf07), cdecl return to 0x484125',
    'read:input': 'observer only; reject reads outside exact ACT payload',
    'write:input': 'observer only; reject any ACT input write',
    'write:allocation': 'observer only; reject writes outside the 3,847-byte allocation',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


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
        self.uc.mem_map(INPUT, INPUT_SPAN)
        self.uc.mem_map(OUT - 16, 0x2000)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations = 0
        self.sizes = Counter()
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + INPUT_SPAN - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + INPUT_SPAN - 1)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + 0x1fff)

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == ALLOC_CALLER and size == BODY,
                f'unexpected original allocation caller/size: {ret:#x}/{size}')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * BODY + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def read_input(self, _uc, _access, address, size, _value, _data):
        require(INPUT + 16 <= address and address + size <= INPUT + 16 + self.input_size,
                'original read outside exact ACT payload')

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise RuntimeError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(OUT <= address and address + size <= OUT + BODY,
                'original wrote outside 3,847-byte allocation')

    def reset(self, payload, seed, index):
        uc = self.uc
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        require(len(payload) + 32 <= INPUT_SPAN - 16, 'oracle fixture exceeds mapped input budget')
        self.seed = seed
        self.input_size = len(payload)
        self.row_address = ACTION0 + index * ROW
        uc.mem_write(INPUT, b'\xa6' * 16 + payload + b'\xd6' * 16)
        # Caller state: all earlier action rows are fresh (zero), as in a scene
        # being loaded; the loader's first-nonzero-row scan therefore keeps the
        # current index. The current row is seeded with a seed-dependent pattern.
        uc.mem_write(ACTION0, bytes(ROW * index))
        uc.mem_write(INDEX, struct.pack('<H', index))
        self.initial_row = bytearray((i * 19 + seed) & 255 for i in range(ROW))
        # Lower guard: for index > 0 the 16 bytes below the row belong to the
        # zeroed previous row (its +0x85 word is read by the loader), so the
        # guard there is the zero fill itself.
        self.low_guard = b'\x91' * 16 if index == 0 else bytes(16)
        uc.mem_write(self.row_address - 16, self.low_guard + bytes(self.initial_row) + b'\x92' * 16)
        # The loader tests row+0x85 of every earlier index only (below the
        # current index), so the seeded current row does not influence it.
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                                EDX=0x44444444, ESI=0x55555555, EDI=0x66666666,
                                EBP=0x77777777, EFLAGS=0x202).items():
            uc.reg_write(self.r[name], value)

    def guards(self, payload, extra=()):
        uc = self.uc
        regions = [(INPUT, b'\xa6' * 16), (INPUT + 16, payload), (INPUT + 16 + len(payload), b'\xd6' * 16),
                   (OUT - 16, b'\xa5' * 16), (OUT + BODY, b'\xd7' * 16),
                   (self.row_address - 16, self.low_guard), (self.row_address + ROW, b'\x92' * 16)]
        for address, data in list(regions) + list(extra):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')

    def invoke_full(self, payload, index=0, seed=0xcd):
        """Full raw-type loader 0x40b34a up to the dependency hand-off."""
        uc, r = self.uc, self.r
        require(len(payload) >= 50 + BODY and payload[48] == 0xea, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        self.reset(payload, seed, index)
        stack = 0x5800
        args = struct.pack('<III', RETURN, INPUT + 16, len(payload))
        uc.mem_write(stack, args)
        uc.mem_write(stack - 0x1000, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        uc.reg_write(r['ESP'], stack)
        name_end = payload.index(0, 0, 48) + 1
        expected = bytearray(self.initial_row)
        expected[:name_end] = payload[:name_end]
        expected[0x30:0x32] = payload[48:50]
        before = self.allocations
        uc.emu_start(0x40b34a, BOUNDARY, count=200000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original failed to reach dependency handoff with one allocation')
        require(struct.unpack('<H', uc.mem_read(INDEX, 2))[0] == index,
                'original loader changed the current action index')
        frame = uc.reg_read(r['EBP'])
        body_va = INPUT + 16 + 50
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        forwarded = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        require(forwarded == (self.row_address, consumed, len(payload), cursor),
                'original dependency arguments do not reflect cursor/offset')
        expected[0x32:0x36] = struct.pack('<I', OUT)
        self.guards(payload, ((self.row_address, bytes(expected)), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)))
        return bytes(uc.mem_read(OUT, BODY)), cursor - body_va, consumed

    def invoke_method(self, payload, offset, index=0, seed=0xcd):
        """Direct entry of the real function 0x484110 (not a basic block)."""
        uc, r = self.uc, self.r
        require(len(payload) >= 50 + BODY, 'invalid oracle fixture')
        self.reset(payload, seed, index)
        stack, cursor_cell, offset_cell = 0x5800, 0x5700, 0x5704
        body_va = INPUT + 16 + 50
        slot = self.row_address + 0x32
        args = struct.pack('<IIII', RETURN, slot, cursor_cell, offset_cell)
        uc.mem_write(stack, args)
        uc.mem_write(cursor_cell, struct.pack('<II', body_va, offset))
        uc.mem_write(stack - 0x1000, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        uc.reg_write(r['ESP'], stack)
        uc.reg_write(r['ECX'], METHOD_THIS)
        before = self.allocations
        uc.emu_start(METHOD, RETURN, count=100000)
        require(uc.reg_read(r['EIP']) == RETURN and self.allocations == before + 1,
                'original method did not return with exactly one allocation')
        # ret 0xc: callee-cleaned three arguments; callee-saved registers restored.
        require(uc.reg_read(r['ESP']) == stack + 16, 'original method stack cleanup mismatch')
        require((uc.reg_read(r['EBP']), uc.reg_read(r['ESI']), uc.reg_read(r['EDI'])) ==
                (0x77777777, 0x55555555, 0x66666666), 'original method callee-saved registers mismatch')
        cursor, new_offset = struct.unpack('<II', uc.mem_read(cursor_cell, 8))
        expected = bytearray(self.initial_row)
        expected[0x32:0x36] = struct.pack('<I', OUT)
        self.guards(payload, ((self.row_address, bytes(expected)), (stack - 0x1000, b'\x93' * 16),
                              (stack + 32, b'\x94' * 16)))
        require(bytes(uc.mem_read(stack, 16)) == args, 'original changed method arguments')
        return bytes(uc.mem_read(OUT, BODY)), cursor - body_va, new_offset


def compare(lib, machine, payload, ordinal, offset=50, method=False, seed=0xcd, index=0):
    body, d, native, length = payload[50:], Decoded(), Constructed(), C.c_size_t()
    raw = storage(body)
    if method:
        original, advance, consumed = machine.invoke_method(payload, offset, index, seed)
    else:
        require(offset == 50, 'full loader starts at offset 50')
        original, advance, consumed = machine.invoke_full(payload, index, seed)
    require(lib.action_family_ea_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected valid original record {ordinal}')
    require(bytes(d.byte) == original, f'decoded neutral field mismatch record {ordinal}')
    require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
             d.dependency_bytes, d.dependency_count) ==
            (advance, len(body), C.addressof(raw) + advance, len(body) - advance,
             (len(body) - advance) // 16), f'decoded body/tail mismatch record {ordinal}')
    require(lib.action_family_ea_body_length(raw, len(body), C.byref(length)) == 0 and
            length.value == advance, f'body_length/original cursor mismatch record {ordinal}')
    require(lib.action_family_ea_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
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
    # invoke_* checks the complete action row, including the type/subtype bytes
    # for the full loader and an untouched row for the direct method entry.
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, BODY, payload[48], payload[48]), f'original/native allocation constants mismatch record {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return bytes(native.object_bytes), original


class NativeTail(NativeFamily):
    def __init__(self, library):
        # Reuse the shared execution/guard discipline without changing its registry.
        self.family, self.library = 'ea', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(library)
        self.decode = self.lib.action_family_ea_decode
        self.body_length = self.lib.action_family_ea_body_length


def run_tails(library, pe, records):
    native, tail_machine, loader = NativeTail(library), OriginalTail(), Original(pe)
    exits = Counter()
    digest = hashlib.sha256()
    counts = Counter()
    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))

    def one(payload, label):
        # Body extent comes from the original loader's own cursor advance.
        original_object, advance, _ = loader.invoke_full(payload, 0, 0x5a)
        require(original_object == payload[50:50 + BODY] and advance == BODY,
                f'original loader body rule mismatch ({label})')
        counts['original_loader_runs'] += 1
        result = compare_tail(native, tail_machine, payload, advance)
        # body_length acceptance must independently agree with the original tail
        # exit; its success value must equal the original loader's cursor delta.
        raw, n = storage(payload[50:]), C.c_size_t(0xa5a5a5a5)
        status = native.body_length(raw, len(payload) - 50, C.byref(n))
        require((status == 0) == result.accepted and
                (n.value == advance if result.accepted else n.value == 0xa5a5a5a5),
                f'body_length/original tail exit mismatch ({label})')
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<III', result.exit_address, result.count, advance))
        return advance

    for ordinal, (payload, _) in enumerate(records):
        advance = one(payload, f'corpus {ordinal}')
        counts['corpus'] += 1
        prefix = payload[:50 + advance]
        for tail in TAIL_LENGTHS:
            one(prefix + pattern[:tail], f'record {ordinal} tail {tail}')
            counts['synthetic_tail'] += 1
        # Fully backed short probes avoid undefined host reads by missing-guard
        # mutants. Original DWORD arithmetic can accept negative multiples of 16
        # for short extents; native ERR_BODY is a separate safety contract, not
        # original parity. Every extent below the typed length is probed natively;
        # the original tail stage is executed for every extent too.
        for length in range(advance):
            check_short_body(native, tail_machine, prefix, advance, length)
            raw, n = storage(prefix[50:]), C.c_size_t(0xa5a5a5a5)
            status = native.body_length(raw, length, C.byref(n))
            require(status == 2 and n.value == 0xa5a5a5a5, 'native short-body body_length safety mismatch')
            out = Constructed()
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            status = native.lib.action_family_ea_construct(raw, length, 50, OUT, C.byref(out))
            require(status == 2 and bytes(out) == before, 'native short-body constructor safety mismatch')
            counts['short_body'] += 1
    payload = records[0][0]
    for tail in WIDTH_TAILS:
        one(payload[:50 + BODY] + bytes(tail), f'width tail {tail}')
        counts['width_tail'] += 1
    for start, end, expected in CODE:
        for name, machine in (('tail', tail_machine.uc), ('loader', loader.uc)):
            if start == 0x424aa8 or name == 'loader':
                require(sha(machine.mem_read(start, end - start)) == expected,
                        f'emulated original code changed ({name} {start:#x})')
    return dict(corpus_records=counts['corpus'], tail_lengths=list(TAIL_LENGTHS),
                width_tail_bytes=list(WIDTH_TAILS),
                synthetic_tail_comparisons=counts['synthetic_tail'] + counts['width_tail'],
                parity_comparisons=counts['corpus'] + counts['synthetic_tail'] + counts['width_tail'],
                original_loader_runs=counts['original_loader_runs'],
                native_short_body_checks=counts['short_body'], original_tail_calls=tail_machine.calls,
                exit_counts=dict(exits), observed_exits_counts_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS, mismatches=0,
                scope='original loader cursor advance + empty/modulus/count/fatal tail boundary; stops before opcode construction')


def read_inputs():
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / CORPUS_NAME).read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0xea_records'], len(corpus['records'])) ==
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
                (n, p + 50, len(body), sha(body), 0xea, row['subtype'], BODY, (len(body) - BODY) // 16,
                 len(body) - BODY, sha(body[:BODY]), sha(body[BODY:])), f'corpus row mismatch: {ordinal}')
        records.append((payload, row['action_index']))
    return resources, records


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamilyea.dylib')
    ap.add_argument('--result', type=Path)
    ap.add_argument('--stage', choices=('all', 'tail'), default='all')
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-EA.1.oracle-', dir='/private/tmp')) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records = read_inputs()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    for start, end, digest in CODE + STATIC_FOLLOWUP_CODE:
        require(sha(pe.image[start - pe.image_base:end - pe.image_base]) == digest,
                f'code window mismatch: {start:#x}')
    loader_result = None
    if args.stage == 'all':
        machine, lib = Original(pe), load_native(args.native_library)
        native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
        for ordinal, (payload, action_index) in enumerate(records):
            seed = (ordinal * 31 + 7) & 255
            # Actual corpus action indices (15, 16) as well as index 0.
            for index in sorted({0, action_index}):
                native, original = compare(lib, machine, payload, f'{ordinal}@{index}', seed=seed, index=index)
            native_hash.update(native); original_hash.update(original)
            bodies.update(payload[50:]); tails.update(payload[50 + BODY:])
            for offset in (50, 0xfffff0f9):
                compare(lib, machine, payload, f'{ordinal}-method-{offset:#x}', offset, True, seed, action_index)
        synthetic_hash = hashlib.sha256()
        full_synth = method_synth = 0
        # All 256 subtype encodings, boundary byte patterns, empty and long
        # tails, whole-object fill independence, action indices and offset wrap.
        for subtype in range(256):
            body = body_fixture(subtype, (0, 1, 2, 255)[subtype % 4], seed=subtype)
            if subtype in (0, 255):
                body = bytes([subtype]) * BODY + body[BODY:]
            payload = b'synthetic' + bytes(39) + bytes([0xea, subtype]) + body
            index = ACTION_INDICES[subtype % len(ACTION_INDICES)]
            native, original = compare(lib, machine, payload, f'synthetic-full-{subtype}', 50, False,
                                       subtype ^ 0xa5, index)
            synthetic_hash.update(native)
            full_synth += 1
            offset = (0, 50, 0xfffff0f9, 0xffffffff, 0x80000000, 0x7ffff0f9)[subtype % 6]
            native, original = compare(lib, machine, payload, f'synthetic-method-{subtype}', offset, True,
                                       subtype ^ 0x5a, index)
            synthetic_hash.update(native)
            method_synth += 1
        for start, end, digest in CODE:
            if start != 0x424aa8:  # generic tail loader is not executed by this Original instance
                require(sha(machine.uc.mem_read(start, end - start)) == digest, 'emulated original code changed')
        loader_result = dict(corpus_records=len(records),
            corpus_full_loader_calls=len(records) + sum(1 for _, i in records if i), corpus_method_calls=2 * len(records),
            full_loader_calls=len(records) + sum(1 for _, i in records if i) + full_synth,
            method_entry_calls=2 * len(records) + method_synth,
            synthetic_full_loader_calls=full_synth, synthetic_method_calls=method_synth,
            original_allocations=machine.allocations,
            corpus_object_bytes_compared=len(records) * BODY,
            corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
            synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
            corpus_dependency_tails_sha256=tails.hexdigest(), allocation_sizes=dict(machine.sizes),
            action_indices=list(ACTION_INDICES), hooks=HOOKS, stop_boundary=hex(BOUNDARY), mismatches=0)
    tail_result = run_tails(args.native_library, pe, records)
    result = dict(slice='A-EA.1', status='pass', stage=args.stage,
        scope='successful loader/allocation and dependency boundary; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources),
                    code_windows=CODE, static_followup_windows=STATIC_FOLLOWUP_CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_ea.c').read_bytes()),
        header_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_ea.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_helper_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        loader=loader_result, tail=tail_result, mismatches=0, original_decisions_replaced=False,
        deliberate_safety_rejections=['all short extents 0..3846; native ERR_BODY, including original DWORD underflow',
            'ragged dependency tail rejection is compared with original fatal exit, not an original return code',
            'null/overlap/address wrap/zero handle tested natively; not original valid-path parity',
            'there is no body count: negative/overflow counts are inapplicable; all body bytes are data'],
        unverified=['malloc failure and cleanup at 0x42639d/0x4c97b4 (guarded hook never returns NULL)',
            'nonzero diagnostics flag at 0x4841b6/0x44a2b7', 'prior action-slot reuse (row+0x3a nonzero) and rows with +0x85 set',
            'generic dependency opcode construction/evaluation after 0x424c94, gate 0x423f57',
            'runtime handler 0x4867bd and the 0x6252ad object methods (0x4841cb..0x484f0d region), host effects',
            'subtype gameplay beyond header preservation, lifecycle/rendering, native gameplay and whole-file match'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=len(records),
        loader_calls=(loader_result['full_loader_calls'] + loader_result['method_entry_calls']) if loader_result else 0,
        tail_parity_comparisons=tail_result['parity_comparisons'],
        native_short_body_checks=tail_result['native_short_body_checks'], mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
