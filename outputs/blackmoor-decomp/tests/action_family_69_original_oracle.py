#!/usr/bin/env python3
"""A-69.1 original loader and tail oracle; only malloc/logging are replaced.

Use work/tools/oracle-python/bin/python with Unicorn JIT allowed. No executable
is launched. Each report path is unique; original files are only read.
"""
import argparse
from collections import Counter
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import tempfile
import time
import sys
sys.dont_write_bytecode = True

from tail_oracle_common import (OriginalTail, compare_tail, check_short_body,
                                HOOKS as TAIL_HOOKS, EXIT_POINTS, OracleError)

from cif_original_oracle import PEImage
from test_action_family_69 import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '831e18116acf939610c743a386609733643fb6099032412b2af2aa79f2c13f3b'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40d428, 0x40d4ed, '4401d3e015d03a04fddfcc934e526688d41b8bad350470f961293f689ae785f9'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT = 0x20000000
OUT = 0x30000010
ACTION = 0x5bb5b3
SLOT = ACTION + 0x32
ALLOCATOR = 0x51dc43
BOUNDARY = 0x410aa5  # stop before CALL 0x424aa8; do not substitute dependency logic
HOOKS = {
    'code:0x51dc43': 'only replacement: guarded successful malloc(1), cdecl return',
    'read:0x20000000..0x2001ffff': 'observer only; reject reads outside exact ACT payload',
    'write:0x20000000..0x2001ffff': 'observer only; reject any input write',
    'write:0x30000000..0x30000fff': 'observer only; reject writes outside one-byte allocation',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(condition, message):
    if not condition:
        raise OracleError(message)


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
        require(size == 1, f'original allocation size is {size}, expected 1')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def read_input(self, _uc, _access, address, size, _value, _data):
        require(INPUT + 16 <= address and address + size <= INPUT + 16 + self.input_size,
                'original read outside exact ACT payload')

    def write_input(self, _uc, _access, _address, _size, _value, _data):
        raise OracleError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(address == OUT and size == 1, 'original wrote outside one-byte allocation')

    def invoke(self, payload, offset=50, inline=False, seed=0xCD):
        uc, r = self.uc, self.r
        require(len(payload) >= 51 and payload[48] == 0x69, 'invalid oracle fixture')
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
            entry = 0x40d428
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
                              (OUT - 16, b'\xa5' * 16), (OUT + 1, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)),
                              (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, 1)), cursor - body_va, consumed


def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xCD):
    body = payload[50:]
    # Fully backed guard bytes keep deliberately wrong source-offset mutants
    # defined on the host. ASan separately checks exact-size valid allocations.
    raw = storage(body + bytes([0xc7]) * 16)
    original, advance, consumed = machine.invoke(payload, offset, inline, seed)
    d, native = Decoded(), Constructed()
    require(lib.action_family_69_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected record {ordinal}')
    require((d.option_00, pointer(d.dependency_records), d.body_bytes,
             d.available_body_bytes, d.dependency_bytes, d.dependency_count) ==
            (body[0], C.addressof(raw) + 1, 1, len(body), len(body) - 1, (len(body) - 1) // 16),
            f'decoded fields/tail mismatch record {ordinal}')
    require(lib.action_family_69_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected record {ordinal}')
    require(bytes(native.object_bytes) == original, f'original/native object mismatch record {ordinal}')
    length = C.c_size_t(0xa5)
    require(lib.action_family_69_body_length(raw, len(body), C.byref(length)) == 0
            and length.value == advance, f'body_length/original cursor mismatch record {ordinal}')
    require((advance, consumed) == (1, (offset + 1) & 0xffffffff),
            f'original body rule mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, (len(body) - 1) // 16,
             len(body) - 1, len(body)), f'original/native cursor/tail mismatch record {ordinal}')
    require((native.output_handle, native.result_slot_handle, native.output_allocation_bytes) ==
            (OUT, OUT, 1), f'original/native slot/constants mismatch record {ordinal}')
    require(bytes(raw) == body + bytes([0xc7]) * 16, 'native modified input')
    return bytes(native.object_bytes), original



class NativeTail:
    family = '69'

    def __init__(self, lib):
        self.lib = lib

    def invoke(self, body, length=None):
        raw = storage(body)
        length = len(body) if length is None else length
        decoded = Decoded()
        C.memset(C.byref(decoded), 0xa5, C.sizeof(decoded))
        before = bytes(decoded)
        status = self.lib.action_family_69_decode(raw, length, C.byref(decoded))
        extent = C.c_size_t(0x12345678)
        length_status = self.lib.action_family_69_body_length(raw, length, C.byref(extent))
        require(length_status == status, 'tail body_length acceptance mismatch')
        if status == 0:
            require(extent.value == 1, 'tail body_length cursor mismatch')
        else:
            require(extent.value == 0x12345678, 'tail body_length rejection mutated output')
        return status, decoded, raw, before


def run_tails(lib, payloads):
    # Direct entry executes the real dependency loader. No original branch,
    # modulus, count calculation or decision is replaced. Reuse reviewed stops.
    machine, native = OriginalTail(), NativeTail(lib)
    exits, digest = Counter(), hashlib.sha256()
    corpus_calls = synthetic_calls = short_calls = 0

    def record(result):
        exits[hex(result.exit_address)] += 1
        digest.update(struct.pack('<II', result.exit_address, result.count))

    for payload in payloads:
        record(compare_tail(native, machine, payload, 1))
        corpus_calls += 1
        for tail in range(41):
            prefix = payload[:51]
            candidate = prefix + bytes((i * 37 + 11) & 255 for i in range(tail))
            record(compare_tail(native, machine, candidate, 1))
            synthetic_calls += 1
        check_short_body(native, machine, payload[:51], 1, 0)
        short_calls += 1
    # Ensure count remains a DWORD instead of narrowing to byte or WORD.
    for records in (256, 65536, 65537):
        record(compare_tail(native, machine, payloads[0][:51] + bytes(16 * records), 1))
        synthetic_calls += 1
    return dict(corpus_tail_comparisons=corpus_calls,
                synthetic_tail_comparisons=synthetic_calls,
                synthetic_tail_lengths=list(range(41)), width_tail_counts=[256, 65536, 65537],
                short_body_safety_checks=short_calls, original_tail_calls=machine.calls,
                parity_exits=dict(exits), result_sha256=digest.hexdigest(),
                hooks=TAIL_HOOKS, exit_points=EXIT_POINTS,
                original_decisions_replaced=False, mismatches=0)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily69.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-69.1.oracle-', dir=PRIVATE)) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-69.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x69_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 7, 7),
            'input identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch: {index}')
        require(index not in resources, 'duplicate resource index')
        resources[index] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require((sha(pe.data), len(pe.data)) == (EXE_HASH, 1511424), 'executable mismatch')
    for start, end, digest in CODE:
        require(sha(pe.image[start - pe.image_base:end - pe.image_base]) == digest,
                f'code window mismatch: {start:#x}')
    machine, lib = Original(pe), load_native(args.native_library)
    native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
    payloads = []
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        require((len(payload), row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['prefix_sha256'], row['dependency_tail_sha256']) ==
                (n, p + 50, len(body), sha(body), 0x69, row['subtype'], 1,
                 (len(body) - 1) // 16, len(body) - 1, sha(body[:1]), sha(body[1:])),
                f'corpus row mismatch: {ordinal}')
        native, original = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
        native_hash.update(native)
        original_hash.update(original)
        bodies.update(body)
        tails.update(body[1:])
        payloads.append(payload)
    corpus_calls = machine.allocations
    tail_results = run_tails(lib, payloads)
    synthetic_hash = hashlib.sha256()
    synthetic_calls = 0
    # Every byte and subtype, four cursor offsets, empty and nonempty tails.
    for option in range(256):
        body = body_fixture(option, (0, 1, 2, 255)[option % 4])
        payload = b'synthetic' + bytes(39) + bytes([0x69, option]) + body
        for inline in (False, True):
            offset = (0, 50, 0xfffffffe, 0xffffffff)[option % 4] if inline else 50
            native, _ = compare(lib, machine, payload, f'synthetic-{option}-{inline}',
                                offset, inline, seed=option ^ 0xa5)
            synthetic_hash.update(native)
            synthetic_calls += 1
    result = dict(slice='A-69.1', scope='original raw69 loader/allocation/cursor and generic tail boundary/count',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()), oracle_script_sha256=sha(Path(__file__).read_bytes()),
        tail_common_sha256=sha((Path(__file__).parent / 'tail_oracle_common.py').read_bytes()),
        corpus_records=7, corpus_original_calls=corpus_calls, synthetic_original_calls=synthetic_calls,
        original_loader_calls=machine.allocations, full_loader_calls=7 + 256, inline_arm_calls=256,
        total_original_calls=machine.allocations + tail_results['original_tail_calls'], mismatches=0,
        corpus_object_bytes_compared=7, synthetic_object_bytes_compared=synthetic_calls,
        corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
        corpus_dependency_tails_sha256=tails.hexdigest(), hooks=HOOKS, allocation_sizes=dict(machine.sizes),
        stop_boundary=hex(BOUNDARY), dependency_tail=tail_results,
        deliberate_safety_rejections=['short body, partial dependency row, null/overlap/address wrap, zero handle',
            'no body count field exists; all byte patterns are valid; negative/overflow counts are inapplicable',
            'native short-body rejection is distinct from original unsigned arithmetic and is not malformed-original parity'],
        unverified=['allocation failure/fatal cleanup', 'nonzero diagnostics', 'prior dependency-slot reuse',
            'dependency opcode/tree construction/evaluation beyond accept/empty stops',
            'runtime/lifecycle/timer/render/host effects', 'subtype gameplay beyond loader preservation',
            'independent frozen-commit review, parser registration and combined integration',
            'whole-file matching, original C++ provenance and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=7, synthetic_original_calls=synthetic_calls,
        original_loader_calls=machine.allocations, original_tail_calls=tail_results['original_tail_calls'],
        mismatches=0, result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
