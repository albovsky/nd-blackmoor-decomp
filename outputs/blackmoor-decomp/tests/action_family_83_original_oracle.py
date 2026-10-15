#!/usr/bin/env python3
"""A-83.1 original loader/allocation and dependency-boundary oracle.

Run using work/tools/oracle-python/bin/python with Unicorn JIT allowed.
Only malloc and the shared ragged-tail diagnostic boundary are replaced.
Original decisions execute unchanged; no executable is launched or patched.
Reports are exclusively created at unique private paths.
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
from test_action_family_83 import Decoded, Constructed, body_fixture, load_native, pointer, storage
from tail_oracle_common import (OriginalTail, NativeFamily, compare_tail, check_short_body,
                                EXIT_POINTS, HOOKS as TAIL_HOOKS, require)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = 'e45d78dd50efe45e8b53b781100e9fe17b8c513b797c0fd039a032b054891236'
CODE = [
    (0x40b34a, 0x410ca4, '4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de'),
    (0x40e995, 0x40ea5e, '46cdfb5bcb0376098f16e4845c1896e7554060b792cec5d0f6054c03cc73d685'),
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT, OUT = 0x20000000, 0x30000010
ACTION, ALLOCATOR, BOUNDARY = 0x5bb5b3, 0x51dc43, 0x410aa5
HOOKS = {
    'code:0x51dc43': 'only loader replacement: guarded successful malloc(74), cdecl return',
    'read:0x20000000..0x2001ffff': 'observer only; reject reads outside exact ACT payload',
    'write:0x20000000..0x2001ffff': 'observer only; reject any ACT input write',
    'write:0x30000000..0x30000fff': 'observer only; reject writes outside 74-byte allocation',
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
        self.uc.mem_map(INPUT, 0x20000)
        self.uc.mem_map(OUT - 16, 0x1000)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations = 0
        self.sizes = Counter()
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + 0xfff)

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(ret == 0x40e99c and size == 74,
                f'unexpected original allocation caller/size: {ret:#x}/{size}')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * 74 + b'\xd7' * 16)
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
        require(OUT <= address and address + size <= OUT + 74,
                'original wrote outside 74-byte allocation')

    def invoke(self, payload, offset=50, inline=False, seed=0xCD):
        uc, r = self.uc, self.r
        require(len(payload) >= 124 and payload[48] == 0x83, 'invalid oracle fixture')
        require(b'\0' in payload[:48], 'oracle description must terminate inside header')
        require(len(payload) + 32 <= 0x20000, 'oracle fixture exceeds mapped input budget')
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'pinned diagnostic flag is nonzero')
        self.seed = seed
        self.input_size = len(payload)
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
        expected = bytearray(initial_action)
        if inline:
            # A direct basic-block entry is not a separate original function.
            # Supply the same caller frame, then execute the unchanged arm.
            frame = 0x7000
            uc.reg_write(r['EBP'], frame)
            uc.reg_write(r['ESP'], frame - 0x300)
            for address, value in ((frame - 0x20, body_va), (frame - 0xcc, offset),
                                   (frame - 0x108, 1), (frame - 0xf8, 1),
                                   (frame + 0xc, len(payload))):
                uc.mem_write(address, struct.pack('<I', value))
            expected[0x30:0x32] = payload[48:50]
            uc.mem_write(ACTION + 0x30, payload[48:50])
            entry = 0x40e995
        else:
            require(offset == 50, 'full loader starts at offset 50')
            name_end = payload.index(0, 0, 48) + 1
            expected[:name_end] = payload[:name_end]
            expected[0x30:0x32] = payload[48:50]
            entry = 0x40b34a
        before = self.allocations
        uc.emu_start(entry, BOUNDARY, count=100000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == before + 1,
                'original failed to reach dependency handoff with one allocation')
        frame = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(frame - 0x20, 4))[0]
        consumed = struct.unpack('<I', uc.mem_read(frame - 0xcc, 4))[0]
        forwarded = struct.unpack('<4I', uc.mem_read(uc.reg_read(r['ESP']), 16))
        require(forwarded == (ACTION, consumed, len(payload), cursor),
                'original dependency arguments do not reflect cursor/offset')
        expected[0x32:0x36] = struct.pack('<I', OUT)
        for address, data in ((INPUT, b'\xa6' * 16), (INPUT + 16, payload),
                              (INPUT + 16 + len(payload), b'\xd6' * 16),
                              (OUT - 16, b'\xa5' * 16), (OUT + 74, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)),
                              (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, 74)), cursor - body_va, consumed



def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xcd):
    body, d, native, length = payload[50:], Decoded(), Constructed(), C.c_size_t()
    raw = storage(body)
    original, advance, consumed = machine.invoke(payload, offset, inline, seed)
    require(lib.action_family_83_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected valid original record {ordinal}')
    require(struct.pack('<37H', *d.word) == original,
            f'decoded neutral field mismatch record {ordinal}')
    require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
             d.dependency_bytes, d.dependency_count) ==
            (advance, len(body), C.addressof(raw) + advance, len(body) - advance,
             (len(body) - advance) // 16), f'decoded body/tail mismatch record {ordinal}')
    require(lib.action_family_83_body_length(raw, len(body), C.byref(length)) == 0 and
            length.value == advance, f'body_length/original cursor mismatch record {ordinal}')
    require(lib.action_family_83_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected valid original record {ordinal}')
    require(bytes(native.object_bytes) == original,
            f'original/native allocation mismatch record {ordinal}')
    require((advance, consumed) == (74, (offset + 74) & 0xffffffff),
            f'original body rule mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, (len(body) - advance) // 16,
             len(body) - advance, len(body)), f'original/native cursor/body rule mismatch record {ordinal}')
    # Original.invoke checks the entire action row, including its type and slot.
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, 74, payload[48], payload[48]), f'original/native allocation constants mismatch record {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return bytes(native.object_bytes), original


class NativeTail(NativeFamily):
    def __init__(self, library):
        # Reuse shared execution/guard discipline without changing its registry.
        self.family, self.library = '83', Path(library)
        self.Decoded = Decoded
        self.lib = load_native(library)
        self.decode = self.lib.action_family_83_decode
        self.body_length = self.lib.action_family_83_body_length


def run_tails(library, records):
    native, machine = NativeTail(library), OriginalTail()
    exits = Counter()
    digest = hashlib.sha256()
    corpus_calls = synthetic_calls = short_calls = 0

    def one(payload, typed):
        result = compare_tail(native, machine, payload, typed)
        # body_length acceptance must independently agree with original tail
        # exit; successful length must equal the original loader's cursor delta.
        raw, n = storage(payload[50:]), C.c_size_t(0xa5a5a5a5)
        before = n.value
        status = native.body_length(raw, len(payload) - 50, C.byref(n))
        require((status == 0) == result.accepted and
                (n.value == typed if result.accepted else n.value == before),
                'body_length/original tail exit mismatch')
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))

    for payload, typed in records:
        typed = native.validated_length(payload, typed)
        one(payload, typed)
        corpus_calls += 1
        prefix = payload[:50 + typed]
        for length in range(41):
            one(prefix + bytes((i * 37 + 11) & 255 for i in range(length)), typed)
            synthetic_calls += 1
        # Fully backed short probes avoid undefined host reads by missing-guard
        # mutants. Original arithmetic underflow can accept negative multiples
        # of 16; native ERR_BODY is a separate safety contract, not parity.
        for length in range(typed):
            check_short_body(native, machine, prefix, typed, length)
            raw, n = storage(prefix[50:]), C.c_size_t(0xa5a5a5a5)
            status = native.body_length(raw, length, C.byref(n))
            require(status == 2 and n.value == 0xa5a5a5a5, 'native short-body body_length safety mismatch')
            out = Constructed()
            C.memset(C.byref(out), 0xa5, C.sizeof(out)); before = bytes(out)
            status = native.lib.action_family_83_construct(raw, length, 50, OUT, C.byref(out))
            require(status == 2 and bytes(out) == before, 'native short-body constructor safety mismatch')
            short_calls += 1
    payload, typed = records[0]
    for count in (256, 65536):
        one(payload[:50 + typed] + bytes(count * 16), typed)
        synthetic_calls += 1
    require(sha(machine.uc.mem_read(CODE[-1][0], CODE[-1][1] - CODE[-1][0])) == CODE[-1][2],
            'emulated dependency code changed')
    return dict(corpus_records=corpus_calls, tail_lengths=list(range(41)),
                synthetic_tail_comparisons=synthetic_calls,
                parity_comparisons=corpus_calls + synthetic_calls,
                native_short_body_checks=short_calls, original_calls=machine.calls,
                exit_counts=dict(exits), observed_exits_counts_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS, mismatches=0,
                scope='original empty/modulus/count/fatal boundary; stop before opcode construction')


def read_inputs():
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-83.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x83_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 9, 9),
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
                (n, p + 50, len(body), sha(body), 0x83, row['subtype'], 74, (len(body) - 74) // 16,
                 len(body) - 74, sha(body[:74]), sha(body[74:])), f'corpus row mismatch: {ordinal}')
        records.append((payload, 74))
    return resources, records


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily83.dylib')
    ap.add_argument('--result', type=Path)
    ap.add_argument('--stage', choices=('all', 'tail'), default='all')
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-83.1.oracle-', dir=PRIVATE)) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    resources, records = read_inputs()
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    for start, end, digest in CODE:
        require(sha(pe.image[start - pe.image_base:end - pe.image_base]) == digest,
                f'code window mismatch: {start:#x}')
    loader_result = None
    if args.stage == 'all':
        machine, lib = Original(pe), load_native(args.native_library)
        native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
        for ordinal, (payload, typed) in enumerate(records):
            native, original = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
            native_hash.update(native); original_hash.update(original)
            bodies.update(payload[50:]); tails.update(payload[50 + typed:])
        synthetic_hash = hashlib.sha256()
        # All 256 subtype encodings, signed-looking neutral words, non-NUL
        # bodies, empty and long tails, whole object fill independence and wrap.
        for subtype in range(256):
            word = (0, 1, 0x7fff, 0x8000, 0xffff)[subtype % 5]
            body = body_fixture(word, (0, 1, 2, 255)[subtype % 4], seed=subtype)
            if subtype in (0, 255):
                body = bytes([subtype]) * 74 + body[74:]
            payload = b'synthetic' + bytes(39) + bytes([0x83, subtype]) + body
            for inline in (False, True):
                offset = (0, 50, 0xffffffb5, 0xffffffff)[subtype % 4] if inline else 50
                native, original = compare(lib, machine, payload, f'synthetic-{subtype}-{inline}',
                                           offset, inline, seed=subtype ^ 0xa5)
                synthetic_hash.update(native)
        for start, end, digest in CODE:
            require(sha(machine.uc.mem_read(start, end - start)) == digest, 'emulated original code changed')
        loader_result = dict(corpus_records=9, corpus_original_calls=9, synthetic_original_calls=512,
            original_calls=machine.allocations, full_loader_calls=265, inline_arm_calls=256,
            corpus_object_bytes_compared=9 * 74, synthetic_object_bytes_compared=512 * 74,
            corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
            synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
            corpus_dependency_tails_sha256=tails.hexdigest(), allocation_sizes=dict(machine.sizes),
            hooks=HOOKS, stop_boundary=hex(BOUNDARY), mismatches=0)
    tail_result = run_tails(args.native_library, records)
    result = dict(slice='A-83.1', status='pass', stage=args.stage,
        scope='successful loader/allocation and dependency boundary; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        source_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_83.c').read_bytes()),
        header_sha256=sha((ROOT / 'outputs/blackmoor-decomp/src/action_family_83.h').read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        shared_tail_helper_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        loader=loader_result, tail=tail_result, mismatches=0, original_decisions_replaced=False,
        deliberate_safety_rejections=['all short extents 0..73; native ERR_BODY, including original DWORD underflow',
            'ragged dependency tail rejection is compared with original fatal exit, not an original return code',
            'null/overlap/address wrap/zero handle tested natively; not original valid-path parity',
            'there is no body count: negative/overflow counts are inapplicable; word bits are unrestricted'],
        unverified=['malloc failure and cleanup at 0x42639d/0x4c97b4', 'nonzero diagnostics at 0x44a2b7',
            'prior action-slot reuse and nonzero action index',
            'generic dependency opcode construction/evaluation after 0x424c94, gate 0x423f57',
            'runtime 0x4e72fb, lookup 0x4e444d, host effects 0x4e0559',
            'subtype gameplay beyond header preservation, lifecycle/rendering, native gameplay and whole-file match'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='pass', corpus_records=9,
        loader_calls=loader_result['original_calls'] if loader_result else 0,
        tail_parity_comparisons=tail_result['parity_comparisons'],
        native_short_body_checks=tail_result['native_short_body_checks'], mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
