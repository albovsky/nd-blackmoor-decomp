#!/usr/bin/env python3
"""A-6F.1 isolated original-x86 loader oracle; malloc is the sole replacement.

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

from cif_original_oracle import PEImage
from test_action_family_6f import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '845573a98968ff9138a090544844deb05e94b13c1b500a812d5ad511640e5a3c'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x40e314, 0x40e3d9, '08e3b0728b9ab74a933833edcf9f5739dc6e6f645210b5d67fc62f13bd6a29c0'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424c36, 0x424c5b, '54976eb552eedb39f9ea62c1c78d5f461cb4cd3d4babdd0990e910ceeb743d96'),
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
        require(len(payload) >= 51 and payload[48] == 0x6f, 'invalid oracle fixture')
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
            entry = 0x40e314
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
    raw = storage(body)
    d, native = Decoded(), Constructed()
    original, advance, consumed = machine.invoke(payload, offset, inline, seed)
    require((advance, consumed) == (1, (offset + 1) & 0xffffffff),
            f'original body rule mismatch record {ordinal}')
    require(lib.action_family_6f_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected record {ordinal}')
    require((d.option_00, pointer(d.dependency_records), d.body_bytes,
             d.available_body_bytes, d.dependency_bytes, d.dependency_count) ==
            (original[0], C.addressof(raw) + advance, advance, len(body),
             len(body) - advance, (len(body) - advance) // 16),
            f'decoded fields/tail mismatch record {ordinal}')
    require(lib.action_family_6f_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected record {ordinal}')
    require(bytes(native.object_bytes) == original, f'original/native object mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, (len(body) - 1) // 16,
             len(body) - 1, len(body)), f'original/native cursor/tail mismatch record {ordinal}')
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, next(iter(machine.sizes)), payload[48], payload[48]),
            f'original/native slot/constants mismatch record {ordinal}')
    require(bytes(raw) == body, 'native modified input')
    return bytes(native.object_bytes), original


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily6f.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result
    if result_path is None:
        result_path = Path(tempfile.mkdtemp(prefix='A-6F.1.oracle-', dir=PRIVATE)) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-6F.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['raw_0x6f_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 25, 25), 'input identity/count mismatch')
    require((corpus['scen_data_records'], corpus['scene_actions'], corpus['resources_scanned']) ==
            (2078, 19612, 2267), 'full corpus count mismatch')
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
    machine, lib = Original(pe), load_native(args.native_library)
    native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        require((row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['typed_body_sha256'],
                 row['dependency_tail_sha256']) ==
                (p + 50, len(body), sha(body), 0x6f, row['subtype'], 1, (len(body) - 1) // 16,
                 len(body) - 1, sha(body[:1]), sha(body[1:])), f'corpus row mismatch: {ordinal}')
        native, original = compare(lib, machine, payload, ordinal, seed=(ordinal * 31 + 7) & 255)
        native_hash.update(native)
        original_hash.update(original)
        bodies.update(body)
        tails.update(body[1:])
    corpus_calls = machine.allocations
    synthetic_hash = hashlib.sha256()
    synthetic_cases = 0
    # All byte encodings, empty/large tails, all subtype encodings and DWORD wrap.
    # No count exists in the body; 0x80/0xff are ordinary valid option bytes.
    for option in range(256):
        tail = (0, 1, 2, 255)[option % 4]
        body = body_fixture(option, tail)
        payload = b'synthetic' + bytes(39) + bytes([0x6f, option]) + body
        for inline in (False, True):
            offset = (0, 50, 0xfffffffe, 0xffffffff)[option % 4] if inline else 50
            native, original = compare(lib, machine, payload, f'synthetic-{option}-{inline}',
                                       offset, inline, seed=option ^ 0xA5)
            require(native == original, 'synthetic aggregate mismatch')
            synthetic_hash.update(native)
            synthetic_cases += 1
    result = dict(slice='A-6F.1', scope='successful original loader/inline arm to dependency CALL; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()), oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_records=25, corpus_original_calls=corpus_calls, synthetic_original_calls=synthetic_cases,
        original_calls=machine.allocations, mismatches=0, corpus_object_bytes_compared=25,
        synthetic_object_bytes_compared=synthetic_cases, corpus_object_sha256=native_hash.hexdigest(),
        original_object_sha256=original_hash.hexdigest(), synthetic_object_sha256=synthetic_hash.hexdigest(),
        corpus_raw_bodies_sha256=bodies.hexdigest(), corpus_dependency_tails_sha256=tails.hexdigest(),
        hooks=HOOKS, original_decisions_replaced=False, allocation_sizes=dict(machine.sizes),
        full_loader_calls=25 + 256, inline_basic_block_calls=256, stop_boundary=hex(BOUNDARY),
        deliberate_safety_rejections=['short body, partial dependency row, null/overlap/address wrap, zero handle',
            'no count field exists; count overflow/negative fixtures are inapplicable',
            'native safety statuses are not original return values; malformed-original parity is not claimed'],
        unverified=['allocation failure/fatal cleanup', 'nonzero diagnostics', 'prior action-slot reuse',
            'generic dependency construction/evaluation', 'scene-stack/runtime/lifecycle/render/host effects',
            'subtype gameplay beyond loader preservation', 'whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=25, synthetic_original_calls=synthetic_cases,
        original_calls=machine.allocations, object_bytes_compared=25 + synthetic_cases,
        mismatches=0, result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
