#!/usr/bin/env python3
"""A-94.1 original-x86 loader/object and dependency-boundary oracle.

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
from test_action_family_94 import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '5d16292229dcb86d91b896f4b6138361512b2d709a943754c31c1acf99a314d3'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40ea5e, 0x40eb28, 'd2ddacceb8ed005e8b4211080d5e35370f803c2c9d0965c02a0c52fce2a8052f'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x424c94, '3dea175ad43be94e993582562641213d1f7169205a4d7b65fe937b3c5a831311'),
]
DEPENDENCY_STOPS = {0x424c31: 'empty', 0x424c5b: 'reject', 0x424c94: 'accept'}
INPUT = 0x20000000
OUT = 0x30000010
ACTION = 0x5bb5b3
SLOT = ACTION + 0x32
ALLOCATOR = 0x51dc43
BOUNDARY = 0x410aa5  # object handoff; generic dependency entry is executed separately
HOOKS = {
    'code:0x51dc43': 'only replacement: guarded successful malloc(50), cdecl return',
    'read:0x20000000..0x2001ffff': 'observer only; reject reads outside exact ACT payload',
    'write:0x20000000..0x2001ffff': 'observer only; reject any input write',
    'write:0x30000000..0x30000fff': 'observer only; reject writes outside 50-byte allocation',
    'code:0x424c31,0x424c5b,0x424c94': 'observation stops at original empty/reject/accept decisions before construction or error logging',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OracleError(RuntimeError):
    pass


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
        self.dependency_active = False
        self.dependency_calls = 0
        self.dependency_outcomes = Counter()
        for stop in DEPENDENCY_STOPS:
            self.uc.hook_add(UC_HOOK_CODE, self.stop_dependency, begin=stop, end=stop)
        self.allocations = 0
        self.sizes = Counter()
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.read_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_input, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.write_object, begin=OUT - 16, end=OUT - 16 + 0xfff)

    def stop_dependency(self, uc, _address, _size, _data):
        if self.dependency_active:
            uc.emu_stop()

    def allocate(self, uc, address, _size, _data):
        require(address == ALLOCATOR, 'unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(size == 50, f'original allocation size is {size}, expected 50')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + bytes([self.seed]) * 50 + b'\xd7' * 16)
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
        require(OUT <= address and address + size <= OUT + 50,
                'original wrote outside 50-byte allocation')

    def invoke(self, payload, offset=50, inline=False, seed=0xCD):
        uc, r = self.uc, self.r
        require(len(payload) >= 100 and payload[48] == 0x94, 'invalid oracle fixture')
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
            entry = 0x40ea5e
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
                              (OUT - 16, b'\xa5' * 16), (OUT + 50, b'\xd7' * 16),
                              (ACTION - 16, b'\x91' * 16), (ACTION, bytes(expected)),
                              (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                              (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(data))) == data,
                    f'original action/input/stack/allocation guard mismatch at {address:#x}')
        return bytes(uc.mem_read(OUT, 50)), cursor - body_va, consumed, expected[0x30]

    def dependency_boundary(self, payload, consumed):
        """Execute entry 0x424aa8, including its original count and remainder.

        Observe the decision before dependency construction/logging. Never
        replace arithmetic or branches. Read the count the original stored.
        These inputs have proven fixed bodies; short-body safety is native only.
        """
        uc, r = self.uc, self.r
        require(100 <= consumed <= len(payload), 'unsafe original tail fixture')
        self.input_size = len(payload)
        source = b'\xa6' * 16 + payload + b'\xd6' * 16
        uc.mem_write(INPUT, source)
        row = bytearray(0x8d)
        row[48:50] = payload[48:50]
        uc.mem_write(ACTION - 16, b'\x91' * 16 + row + b'\x92' * 16)
        owner = 0x63786d
        uc.mem_write(owner + 0x60c, struct.pack('<I', 0x12345678))
        stack = 0x5800
        args = struct.pack('<5I', 0x51000000, ACTION, consumed, len(payload),
                           INPUT + 16 + consumed)
        uc.mem_write(stack, args)
        uc.mem_write(stack - 0x1000, b'\x93' * 16)
        uc.mem_write(stack + 32, b'\x94' * 16)
        for name, value in dict(EAX=0, EBX=0, ECX=owner, EDX=0, ESI=0, EDI=0,
                                EBP=0, ESP=stack, EFLAGS=0x202).items():
            uc.reg_write(r[name], value)
        self.dependency_active = True
        allocations_before = self.allocations
        try:
            uc.emu_start(0x424aa8, 0x51000000, count=100000)
        finally:
            self.dependency_active = False
        stop = uc.reg_read(r['EIP'])
        require(stop in DEPENDENCY_STOPS, 'original dependency decision stop not reached')
        require(self.allocations == allocations_before, 'tail boundary unexpectedly allocated')
        outcome = DEPENDENCY_STOPS[stop]
        stored_count = struct.unpack('<I', uc.mem_read(ACTION + 0x6a, 4))[0]
        stored_empty = struct.unpack('<I', uc.mem_read(ACTION + 0x36, 4))[0]
        require(stored_empty == (1 if outcome == 'empty' else 0),
                'original empty-tail flag mismatch')
        require(bytes(uc.mem_read(owner + 0x60c, 4)) == struct.pack('<I', 0x12345679),
                'original dependency owner counter effect mismatch')
        for address, expected in ((INPUT, source), (ACTION - 16, b'\x91' * 16),
                (ACTION + 0x8d, b'\x92' * 16), (stack, args),
                (stack - 0x1000, b'\x93' * 16), (stack + 32, b'\x94' * 16)):
            require(bytes(uc.mem_read(address, len(expected))) == expected,
                    'original dependency input/slot/stack guard changed')
        self.dependency_calls += 1
        self.dependency_outcomes[outcome] += 1
        return outcome != 'reject', stored_count, stop


def compare(lib, machine, payload, ordinal, offset=50, inline=False, seed=0xcd):
    body = payload[50:]
    raw, d, native = storage(body), Decoded(), Constructed()
    require(lib.action_family_94_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected record {ordinal}')
    original, advance, consumed, runtime_type = machine.invoke(payload, offset, inline, seed)
    require(advance == 50 and consumed == (offset + advance) & 0xffffffff,
            f'original body rule mismatch record {ordinal}')
    require((bytes(d.option_00), d.word_21, d.word_25, d.word_29, d.word_2d, d.option_31) ==
            (original[:33], *struct.unpack_from('<4I', original, 33), original[49]),
            f'decoded neutral field mismatch record {ordinal}')
    tail = len(body) - advance
    require((d.body_bytes, d.available_body_bytes, pointer(d.dependency_records),
             d.dependency_bytes, d.dependency_count) ==
            (advance, len(body), C.addressof(raw) + advance, tail, tail // 16),
            f'decoded body/tail mismatch record {ordinal}')
    require(lib.action_family_94_construct(raw, len(body), offset, OUT, C.byref(native)) == 0,
            f'native constructor rejected record {ordinal}')
    require(bytes(native.object_bytes) == original,
            f'original/native object mismatch record {ordinal}')
    require((native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
             pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
             native.available_body_bytes) ==
            (advance, offset, consumed, C.addressof(raw) + advance, tail // 16, tail, len(body)),
            f'original/native cursor/tail mismatch record {ordinal}')
    require((native.result_slot_handle, native.allocation_bytes, native.raw_type, native.runtime_type) ==
            (OUT, len(original), payload[48], runtime_type),
            f'original/native slot/constants mismatch record {ordinal}')
    require(bytes(raw)[:len(body)] == body, 'native modified input')
    return bytes(native.object_bytes), original, advance


def compare_tail(lib, machine, payload, advance, ordinal):
    accepted, count, stop = machine.dependency_boundary(payload, 50 + advance)
    body = payload[50:]
    raw = storage(body)
    for kind, function in ((Decoded, lib.action_family_94_decode),
                           (Constructed, lib.action_family_94_construct)):
        out = kind()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        status = function(raw, len(body), C.byref(out)) if kind is Decoded else function(
            raw, len(body), 50, OUT, C.byref(out))
        require(status == (0 if accepted else 3),
                f'original/native tail accept/reject mismatch record {ordinal} at {stop:#x}')
        if accepted:
            body_length = out.body_bytes if kind is Decoded else out.body_bytes_consumed
            require(body_length == advance, 'original/native body_length cursor mismatch')
            require((out.dependency_count, out.dependency_bytes, pointer(out.dependency_records)) ==
                    (count, len(body) - advance, C.addressof(raw) + advance),
                    f'original/native stored tail count mismatch record {ordinal}')
        else:
            require(bytes(out) == before, 'native fractional tail rejection mutated output')
    require(bytes(raw)[:len(body)] == body, 'native tail comparison mutated input')


def check_short_safety(lib):
    """Deliberate native safety check, never execute unsafe original copies."""
    for length in range(50):
        raw = storage(body_fixture()[:length])
        for kind in (Decoded, Constructed):
            out = kind()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            status = lib.action_family_94_decode(raw, length, C.byref(out)) if kind is Decoded else (
                lib.action_family_94_construct(raw, length, 50, OUT, C.byref(out)))
            require(status == 2 and bytes(out) == before, 'native short-body safety mismatch')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path,
                    default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily94.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-94.1.oracle-', dir=PRIVATE)) / 'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE / 'A-94.1.corpus.json').read_bytes()
    require((sha(mb), sha(cb)) == (MANIFEST_HASH, CORPUS_HASH), 'pinned manifest/corpus hash mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
             corpus['manifest_sha256'], corpus['raw_0x94_records'], len(corpus['records']),
             corpus['scen_data_records'], corpus['scene_actions']) ==
            (ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 12, 12, 2078, 19612),
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
    machine, lib = Original(pe), load_native(args.native_library)
    native_hash, original_hash, bodies, tails = [hashlib.sha256() for _ in range(4)]
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        require((row['raw_body_offset'], row['raw_body_length'], row['body_sha256'],
                 payload[48], payload[49], row['typed_body_length'], row['dependency_tail_records'],
                 row['dependency_tail_length'], row['prefix_sha256'], row['dependency_tail_sha256']) ==
                (p + 50, len(body), sha(body), 0x94, row['subtype'], 50,
                 (len(body) - 50) // 16, len(body) - 50, sha(body[:50]), sha(body[50:])),
                f'corpus row mismatch: {ordinal}')
        native, original, advance = compare(lib, machine, payload, ordinal, seed=ordinal * 17)
        compare_tail(lib, machine, payload, advance, f'corpus-{ordinal}')
        native_hash.update(native)
        original_hash.update(original)
        bodies.update(body)
        tails.update(body[advance:])
    # Advance is observed from the unchanged original arm, then used by the
    # dependency entry. Include every tail byte length, not just valid rows.
    fixed = body_fixture()
    for tail_length in range(41):
        payload = b'tail-fixture' + bytes(36) + bytes([0x94, 1]) + fixed + bytes(
            (i * 13 + 7) & 255 for i in range(tail_length))
        _object, advance, _consumed, _type = machine.invoke(payload, seed=tail_length)
        compare_tail(lib, machine, payload, advance, f'tail-bytes-{tail_length}')
    synthetic_hash = hashlib.sha256()
    synthetic_cases = 0
    # All final-byte/subtype patterns, signed-looking DWORD bits, arbitrary
    # non-NUL prefixes, empty and large tails, and modulo-2^32 offset effects.
    for option in range(256):
        word = (0, 1, 0x7fff, 0x8000, 0xffff, 0x7fffffff, 0x80000000, 0xffffffff)[option % 8]
        body = body_fixture(words=(word, word ^ 0xffffffff, word ^ 0x12345678, word ^ 0x87654321),
                            option=option, tail=(0, 1, 2, 4096)[option % 4],
                            prefix=bytes((i * 31 + option) & 255 for i in range(33)))
        payload = b'synthetic' + bytes(39) + bytes([0x94, option]) + body
        for inline in (False, True):
            offset = (0, 50, 0xffffffce, 0xffffffff)[option % 4] if inline else 50
            native, original, _advance = compare(lib, machine, payload, f'synthetic-{option}-{inline}',
                                                offset, inline, seed=option ^ 0xa5)
            require(native == original, 'synthetic aggregate mismatch')
            synthetic_hash.update(native)
            synthetic_cases += 1
    check_short_safety(lib)
    result = dict(slice='A-94.1', scope='inline object construction and generic dependency boundary decisions; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()), oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_records=12, corpus_object_bytes_compared=600, synthetic_object_original_calls=synthetic_cases,
        synthetic_object_bytes_compared=synthetic_cases * 50,
        original_object_calls=machine.allocations, dependency_boundary_calls=machine.dependency_calls,
        dependency_boundary_outcomes=dict(machine.dependency_outcomes), synthetic_tail_byte_lengths=list(range(41)),
        native_short_body_safety_checks=100, mismatches=0,
        corpus_object_sha256=native_hash.hexdigest(), original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(), corpus_raw_bodies_sha256=bodies.hexdigest(),
        corpus_dependency_tails_sha256=tails.hexdigest(), hooks=HOOKS, allocation_sizes=dict(machine.sizes),
        object_stop_boundary=hex(BOUNDARY), dependency_stops={hex(k): v for k, v in DEPENDENCY_STOPS.items()},
        deliberate_safety_rejections=['short body, fractional dependency row, null/overlap/address wrap, zero handle',
            'no body count; negative/overflow-looking DWORDs and all byte patterns are retained',
            'short-body safety checks do not execute unsafe original copies; safety statuses are native'],
        unverified=['allocation failure/fatal cleanup', 'nonzero diagnostics', 'prior action-slot reuse',
            'dependency construction/evaluation after the boundary', 'runtime/lifecycle/render/host effects',
            'subtype gameplay beyond loader preservation', 'whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=12, original_object_calls=machine.allocations,
        dependency_boundary_calls=machine.dependency_calls, mismatches=0,
        result=str(result_path), result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
