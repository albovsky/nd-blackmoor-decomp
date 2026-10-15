#!/usr/bin/env python3
"""A-7D.1 isolated original loader and generic dependency-tail oracle.

Loader replacement: malloc only. Generic stage reuses tail_oracle_common,
including its validated diagnostic logger and fatal/accept/empty exit points.

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
import sys
import tempfile
import time

sys.dont_write_bytecode = True
from cif_original_oracle import PEImage
import tail_oracle_common as tail_common
from test_action_family_7d import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '1ce509e19688dcf758393a0fbc38adb789de0b62788c5a8fbe0612c2a85a1eae'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x40e61e, 0x40e6e3, '43d4a867c887ccd32535f61a21bfbd660c0f4dda0abba51505c7785fe0704472'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT = 0x20000000
OUT = 0x30000010
ACTION = 0x5bb5b3
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
        raise RuntimeError(message)


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
        self.full_calls = self.inline_calls = 0
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
        raise RuntimeError('original wrote input')

    def write_object(self, _uc, _access, address, size, _value, _data):
        require(address == OUT and size == 1, 'original wrote outside one-byte allocation')

    def invoke(self, payload, offset=50, inline=False, seed=0xCD):
        uc, r = self.uc, self.r
        require(len(payload) >= 51 and payload[48] == 0x7d, 'invalid oracle fixture')
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
            entry = 0x40e61e
            self.inline_calls += 1
        else:
            require(offset == 50, 'full loader starts at offset 50')
            name_end = payload.index(0, 0, 48) + 1
            expected[:name_end] = payload[:name_end]
            expected[0x30:0x32] = payload[48:50]
            entry = 0x40b34a
            self.full_calls += 1
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


class Native:
    family = '7d'

    def __init__(self, library):
        self.library = library
        self.lib = load_native(library)
        self.body_length = self.lib.action_family_7d_body_length

    def invoke(self, body, length=None):
        # Backing guards allow wrong-offset mutants to be diagnosed without
        # undefined host reads. The ASan driver separately uses exact mallocs.
        backing = storage((body or b'\0') + bytes([0xD3]) * 16)
        raw = (C.c_uint8 * max(1, len(body))).from_buffer(backing)
        decoded = Decoded()
        C.memset(C.byref(decoded), 0xA6, C.sizeof(decoded))
        before = bytes(decoded)
        status = self.lib.action_family_7d_decode(
            raw, len(body) if length is None else length, C.byref(decoded))
        return status, decoded, raw, before


def compare(native, machine, tails, payload, ordinal, offset=50, inline=False, seed=0xCD):
    # Execute unchanged original decisions before consulting native values.
    original, advance, consumed = machine.invoke(payload, offset, inline, seed)
    require(advance == 1 and consumed == (offset + advance) & 0xFFFFFFFF,
            f'original cursor mismatch record {ordinal}')
    tail = tail_common.compare_tail(native, tails, payload, advance)
    body = payload[50:]
    status, decoded, raw, _ = native.invoke(body)
    length = C.c_size_t(0xA6A6)
    length_status = native.body_length(raw, len(body), C.byref(length))
    require((length_status == 0) == tail.accepted,
            f'body_length acceptance mismatch record {ordinal}')
    constructed = Constructed()
    C.memset(C.byref(constructed), 0xA6, C.sizeof(constructed))
    before = bytes(constructed)
    construct_status = native.lib.action_family_7d_construct(
        raw, len(body), offset, OUT, C.byref(constructed))
    require((construct_status == 0) == tail.accepted,
            f'constructor acceptance mismatch record {ordinal}')
    if tail.accepted:
        require(status == 0 and decoded.option_00 == original[0],
                f'original/native decoded field mismatch record {ordinal}')
        require(length.value == advance, f'body_length cursor mismatch record {ordinal}')
        require(bytes(constructed.object_bytes) == original,
                f'original/native object mismatch record {ordinal}')
        require((constructed.body_bytes_consumed, constructed.payload_offset_before,
                 constructed.payload_offset_after, pointer(constructed.dependency_records),
                 constructed.dependency_count, constructed.dependency_bytes,
                 constructed.available_body_bytes) ==
                (advance, offset, consumed, C.addressof(raw) + advance, tail.count,
                 len(body) - advance, len(body)),
                f'original/native cursor/tail mismatch record {ordinal}')
        original_row = bytes(machine.uc.mem_read(ACTION, 0x8D))
        require((constructed.result_slot_handle, constructed.allocation_bytes,
                 constructed.raw_type, constructed.runtime_type) ==
                (struct.unpack_from('<I', original_row, 0x32)[0], 1, payload[48], original_row[48]),
                f'original/native slot/constants mismatch record {ordinal}')
        native_object = bytes(constructed.object_bytes)
    else:
        require(status == length_status == construct_status == 3,
                f'ragged status mismatch record {ordinal}')
        require(length.value == 0xA6A6 and bytes(constructed) == before,
                f'ragged rejection mutated output record {ordinal}')
        native_object = b''
    require(bytes(raw) == body, 'native modified input')
    return native_object, original, tail


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily7d.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result
    if result_path is None:
        result_path = Path(tempfile.mkdtemp(prefix='A-7D.1.oracle-', dir='/private/tmp')) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-7D.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
             corpus['scene_actions'], corpus['raw_0x7d_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 2267, 2078, 19612, 4, 4),
            'input identity/count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        require((len(data), sha(data)) == (row['size'], row['sha256']), f'resource mismatch: {index}')
        resources[index] = data
    require(len(resources) == 2267, 'resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424, 'executable mismatch')
    for start, end, digest in CODE:
        require(sha(pe.image[start - pe.image_base:end - pe.image_base]) == digest,
                f'code window mismatch: {start:#x}')
    machine, native, tails = Original(pe), Native(args.native_library), tail_common.OriginalTail()
    native_hash, original_hash, bodies, tail_hash = [hashlib.sha256() for _ in range(4)]
    exits = Counter()
    payloads = []
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        require((len(payload), row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['prefix_sha256'], row['dependency_tail_sha256']) ==
                (n, p + 50, len(body), sha(body), 0x7D, row['subtype'], 1, (len(body) - 1) // 16,
                 len(body) - 1, sha(body[:1]), sha(body[1:])), f'corpus row mismatch: {ordinal}')
        obj, original, tail = compare(native, machine, tails, payload, ordinal,
                                      seed=(ordinal * 31 + 7) & 255)
        require(tail.accepted, 'original rejected corpus tail')
        exits[hex(tail.exit_address)] += 1
        native_hash.update(obj)
        original_hash.update(original)
        bodies.update(body)
        tail_hash.update(body[1:])
        payloads.append(payload)
    corpus_calls = machine.allocations
    synthetic_hash = hashlib.sha256()
    # All option/subtype byte patterns; no signed count exists in this body.
    for option in range(256):
        body = body_fixture(option, (0, 1, 2, 255)[option % 4])
        payload = b'synthetic' + bytes(39) + bytes([0x7D, option]) + body
        for inline in (False, True):
            offset = (0, 50, 0xFFFFFFFE, 0xFFFFFFFF)[option % 4] if inline else 50
            obj, original, tail = compare(native, machine, tails, payload,
                f'synthetic-{option}-{inline}', offset, inline, seed=option ^ 0xA5)
            require(obj == original and tail.accepted, 'synthetic object mismatch')
            synthetic_hash.update(obj)
            exits[hex(tail.exit_address)] += 1
    synthetic_calls = 512
    # Each corpus prefix against the shared tail-length set (0..300, 1023..1025,
    # 4079..4097: modulus, 8-bit and 4096 boundaries), original accept and fatal exits.
    tail_accepts = tail_rejects = 0
    for ordinal, prefix in enumerate(payloads):
        for length in tail_common.TAIL_LENGTHS:
            payload = prefix[:51] + bytes((i * 37 + 11) & 255 for i in range(length))
            _, _, tail = compare(native, machine, tails, payload, f'tail-{ordinal}-{length}')
            exits[hex(tail.exit_address)] += 1
            if tail.accepted:
                tail_accepts += 1
            else:
                tail_rejects += 1
    tail_comparisons = len(payloads) * len(tail_common.TAIL_LENGTHS)
    require(tail_accepts + tail_rejects == tail_comparisons, 'tail accounting')
    # Count width is the original DWORD, not a byte/WORD; exclude from loader
    # budget (the generic stage never reads dependency records themselves).
    for length in tail_common.WIDTH_TAILS:
        tail = tail_common.compare_tail(native, tails, payloads[0][:51] + bytes(length), 1)
        require(tail.accepted and tail.count == length // 16, 'original count-width tail mismatch')
        exits[hex(tail.exit_address)] += 1
        raw = storage(payloads[0][50:51] + bytes(length))
        typed = C.c_size_t(0)
        require(native.body_length(raw, len(raw), C.byref(typed)) == 0 and typed.value == 1,
                'large-tail body_length mismatch')
    # No original short-body load is safe. Execute only generic arithmetic
    # with trusted typed=1, as the shared helper does, and label native safety.
    for payload in payloads:
        tail_common.check_short_body(native, tails, payload[:51], 1, 0)
        raw = storage(payload[50:51])
        typed, constructed = C.c_size_t(0xA6A6), Constructed()
        C.memset(C.byref(constructed), 0xA6, C.sizeof(constructed))
        before = bytes(constructed)
        require(native.body_length(raw, 0, C.byref(typed)) == 2 and typed.value == 0xA6A6,
                'short-body body_length safety mismatch')
        require(native.lib.action_family_7d_construct(raw, 0, 50, OUT, C.byref(constructed)) == 2 and
                bytes(constructed) == before, 'short-body constructor safety mismatch')
    # Input executable, loaded code and generic loader code remain immutable.
    for start, end, digest in CODE:
        require(sha(machine.uc.mem_read(start, end - start)) == digest, 'emulated loader code changed')
    require(sha(tails.uc.mem_read(tail_common.CODE_START,
                tail_common.CODE_END - tail_common.CODE_START)) == tail_common.CODE_HASH,
            'emulated tail code changed')
    require(sha((ROOT / 'work/original/GAME.EXE').read_bytes()) == EXE_HASH, 'original file changed')
    result = dict(slice='A-7D.1', status='pass', scope='loader/object and generic tail accept/count stage only',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE,
                    dependency_code_sha256=tail_common.CODE_HASH),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        tail_helper_sha256=sha(Path(tail_common.__file__).read_bytes()),
        corpus_records=4, corpus_original_calls=corpus_calls, synthetic_original_calls=synthetic_calls,
        synthetic_tail_lengths=list(tail_common.TAIL_LENGTHS),
        synthetic_tail_comparisons=tail_comparisons, tail_accepted=tail_accepts,
        tail_rejected_fatal=tail_rejects,
        count_width_tail_bytes=list(tail_common.WIDTH_TAILS),
        count_width_comparisons=len(tail_common.WIDTH_TAILS), short_body_safety_checks=4,
        loader_original_calls=machine.allocations, full_loader_calls=machine.full_calls,
        inline_arm_calls=machine.inline_calls,
        dependency_original_calls=tails.calls,
        original_calls=machine.allocations + tails.calls, mismatches=0,
        corpus_object_bytes_compared=4, synthetic_object_bytes_compared=512,
        accepted_tail_object_bytes_compared=tail_accepts,
        corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
        corpus_dependency_tails_sha256=tail_hash.hexdigest(), dependency_exit_counts=dict(exits),
        hooks=dict(loader=HOOKS, dependency=tail_common.HOOKS),
        dependency_exit_points=tail_common.EXIT_POINTS, allocation_sizes=dict(machine.sizes),
        loader_stop_boundary=hex(BOUNDARY), original_decisions_replaced=False,
        deliberate_safety_rejections=['short body, null/overlap/span wrap, zero model handle',
            'short native bodies rejected before reads; no original short-body loader parity claimed',
            'no count field exists; negative and overflow body counts inapplicable',
            'ragged native status is a safety result; original reaches diagnostic/fatal exit'],
        unverified=['allocation failure/fatal cleanup', 'nonzero diagnostics', 'prior action-slot reuse',
            'dependency opcode/tree construction/evaluation after accept exit',
            'runtime/lifecycle/render/host effects', 'subtype gameplay beyond loader preservation',
            'shared parser registration/integration', 'whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps({key: result[key] for key in ('corpus_records', 'loader_original_calls',
        'dependency_original_calls', 'original_calls', 'mismatches')} |
        dict(result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
