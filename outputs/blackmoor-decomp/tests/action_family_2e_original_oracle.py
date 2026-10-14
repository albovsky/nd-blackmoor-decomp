#!/usr/bin/env python3
"""Immutable x86 raw2e constructor and dependency-boundary parity.

Use work/tools/oracle-python/bin/python with Unicorn JIT permitted. Only malloc
is replaced; bounds and structural-stop hooks observe original execution.
Dependency tree construction and gameplay are excluded. Reports use unique paths.
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
from test_action_family_2e import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '7dd8fec67f090f7256d1939c73aae3a0aecb613959b8d3d0867e0d0737f3dedf'
CODE = [(4240202, 4240646, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'), (4263076, 4263817, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'), (4243732, 4243778, '512bbbd98dccb6916b769a8c3ed670c8a4b4069cb81264e382e1082c74707152'), (5035589, 5035775, '0f0161224236457434b4c1668f0ca708e6ab408374ae437ada9dfb76c0f74309'), (5042660, 5042806, '57fc0c8e764630811d7505589b50b6507a779ee276fd3909722ded614a7be88e'), (4262504, 4262570, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'), (4344488, 4344980, '3dea175ad43be94e993582562641213d1f7169205a4d7b65fe937b3c5a831311')]
INPUT, DATA, STACK = 0x20000000, 0x30000000, 0x5800
OWNER, SLOT, CURSOR, OFFSET, OUT = (DATA + x for x in (0x1000, 0x2000, 0x2400, 0x2404, 0x5000))
STOP, ALLOCATOR, DEPENDENCY_BOUNDARY = 0x51000000, 0x51dc43, 0x410a68
OBJECT_BYTES = 15


class OracleError(RuntimeError):
    pass


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
        self.uc.mem_map(DATA, 0x10000)
        self.uc.reg_write(self.r['ES'], 0)
        self.allocations = 0
        self.sizes = Counter()
        self.source_span = (0, 0)
        self.seed = bytes([0xcd]) * OBJECT_BYTES
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=OUT - 16, end=OUT + OBJECT_BYTES + 15)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_input_write, begin=INPUT, end=INPUT + 0x1ffff)
        self.dependency_stop = None
        self.dependency_calls = 0
        for boundary in (0x424c31, 0x424c5b, 0x424c94):
            self.uc.hook_add(UC_HOOK_CODE, self.stop_dependency, begin=boundary, end=boundary)

    def observe_input_write(self, _uc, _access, _address, _size, _value, _data):
        raise OracleError('original wrote immutable ACT input')

    def stop_dependency(self, uc, address, _size, _data):
        # Observe the branch already chosen by unchanged x86 instructions.
        self.dependency_stop = address
        uc.emu_stop()

    def dependency(self, body):
        """Execute the original structural tail decision, before tree building.

        No tail contents are read before these three stops. The stored count,
        empty-tail ready flag and owner sequence increment are original writes.
        """
        uc, r = self.uc, self.r
        tail = len(body) - OBJECT_BYTES
        if tail < 0:
            raise OracleError('dependency harness requires a complete typed body')
        action, owner = DATA + 0x7000, DATA + 0x8000
        uc.mem_write(action, bytes(0x8d))  # +0x3a must be a fresh empty root
        uc.mem_write(owner, bytes(0x610))
        self.source_span = (INPUT + 16, INPUT + 16 + len(body))
        uc.mem_write(INPUT, b'\xa6' * 16 + body + b'\xd6' * 16)
        uc.mem_write(STACK, struct.pack('<5I', STOP, action, 50 + OBJECT_BYTES,
            50 + len(body), INPUT + 16 + OBJECT_BYTES))
        uc.reg_write(r['ESP'], STACK)
        uc.reg_write(r['ECX'], owner)
        uc.reg_write(r['EFLAGS'], 0x202)
        self.dependency_stop = None
        uc.emu_start(0x424aa8, STOP, count=100000)
        stops = {0x424c31: 'empty', 0x424c5b: 'reject', 0x424c94: 'accept'}
        if self.dependency_stop not in stops:
            raise OracleError('dependency original did not reach a structural stop')
        count = struct.unpack('<I', uc.mem_read(action + 0x6a, 4))[0]
        ready = struct.unpack('<I', uc.mem_read(action + 0x36, 4))[0]
        sequence = struct.unpack('<I', uc.mem_read(owner + 0x60c, 4))[0]
        if sequence != 1 or ready != int(self.dependency_stop == 0x424c31):
            raise OracleError('dependency initialization effect mismatch')
        if bytes(uc.mem_read(INPUT + 16, len(body))) != body:
            raise OracleError('dependency original input mutation')
        self.dependency_calls += 1
        return stops[self.dependency_stop], count

    def observe_read(self, _uc, _access, address, size, _value, _data):
        if address < self.source_span[0] or address + size > self.source_span[1]:
            raise OracleError(f'original read outside exact fixture at {address:#x}, size {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        if address < OUT or address + size > OUT + OBJECT_BYTES:
            raise OracleError(f'original write outside 15-byte allocation at {address:#x}')

    def allocate(self, uc, address, _size, _data):
        if address != ALLOCATOR:
            raise OracleError('unexpected replacement hook')
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        if size != OBJECT_BYTES:
            raise OracleError(f'unexpected original allocation size {size}')
        uc.mem_write(OUT - 16, b'\xa5' * 16 + self.seed + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], OUT)
        uc.reg_write(self.r['ESP'], esp + 4)  # cdecl caller removes size
        uc.reg_write(self.r['EIP'], ret)
        self.allocations += 1
        self.sizes[size] += 1

    def invoke(self, body, seed, payload=None, payload_offset=50):
        uc, r = self.uc, self.r
        if len(seed) != OBJECT_BYTES:
            raise OracleError('invalid allocator seed')
        self.seed = seed
        loader = payload is not None
        source = payload if loader else bytes(50) + body
        if len(source) + 32 > 0x20000:
            raise OracleError('fixture exceeds oracle mapping')
        body_va = INPUT + 16 + 50
        self.source_span = (INPUT + 16, INPUT + 16 + len(source))
        uc.mem_write(INPUT, b'\xa6' * 16 + source + b'\xd6' * 16)
        owner = 0x63821d if loader else OWNER
        slot = 0x5bb5e5 if loader else SLOT
        owner_before = b'\x5a' * 0x100
        uc.mem_write(owner - 16, b'\x91' * 16 + owner_before + b'\x92' * 16)
        if bytes(uc.mem_read(0x63a4cd, 2)) != bytes(2):
            raise OracleError('pinned diagnostic flag is nonzero')
        uc.mem_write(0x5c39e3, bytes(2))
        if loader:
            uc.mem_write(0x5bb5b3, bytes(0x8d))
        else:
            uc.mem_write(slot - 16, b'\x93' * 16 + b'\x69' * 0x100 + b'\x94' * 16)
            uc.mem_write(CURSOR, struct.pack('<II', body_va, payload_offset))
        args = (INPUT + 16, len(source)) if loader else (slot, CURSOR, OFFSET)
        stack_args = struct.pack('<' + 'I' * (len(args) + 1), STOP, *args)
        uc.mem_write(STACK - 0x1000, b'\x3c' * 16)
        uc.mem_write(STACK + 32, b'\x7e' * 16)
        uc.mem_write(STACK, stack_args)
        initial = dict(EAX=0x11111111, EBX=0x22222222, ECX=owner, EDX=0x33333333,
                       ESI=0x44444444, EDI=0x55555555, EBP=0x66666666)
        for name, value in initial.items():
            uc.reg_write(r[name], value)
        uc.reg_write(r['ESP'], STACK)
        uc.reg_write(r['EFLAGS'], 0x202)
        entry, boundary = (0x40b34a, DEPENDENCY_BOUNDARY) if loader else (0x4cd645, STOP)
        before = self.allocations
        uc.emu_start(entry, boundary, count=1000000)
        if uc.reg_read(r['EIP']) != boundary or self.allocations != before + 1:
            raise OracleError('original did not reach boundary with one allocation')
        if loader:
            ebp = uc.reg_read(r['EBP'])
            cursor = struct.unpack('<I', uc.mem_read(ebp - 0x20, 4))[0]
            offset = struct.unpack('<I', uc.mem_read(ebp - 0xcc, 4))[0]
            expected_table = bytearray(0x8d)
            name_bytes = payload[:48].index(0) + 1
            expected_table[:name_bytes] = payload[:name_bytes]
            expected_table[48:50] = bytes([0x2e, payload[49]])
            expected_table[50:54] = struct.pack('<I', OUT)
            if bytes(uc.mem_read(0x5bb5b3, 0x8d)) != bytes(expected_table):
                raise OracleError('original runtime type/subtype/table effect mismatch')
        else:
            cursor, offset = struct.unpack('<II', uc.mem_read(CURSOR, 8))
            if uc.reg_read(r['ESP']) != STACK + 16:
                raise OracleError('constructor RET cleanup mismatch')
            for name in ('EBX', 'ESI', 'EDI', 'EBP'):
                if uc.reg_read(r[name]) != initial[name]:
                    raise OracleError('constructor changed callee-saved register')
        guards = [(INPUT, b'\xa6' * 16), (INPUT + 16, source),
                  (INPUT + 16 + len(source), b'\xd6' * 16), (OUT - 16, b'\xa5' * 16),
                  (OUT + OBJECT_BYTES, b'\xd7' * 16), (owner - 16, b'\x91' * 16),
                  (owner, owner_before), (owner + 0x100, b'\x92' * 16),
                  (STACK - 0x1000, b'\x3c' * 16), (STACK, stack_args), (STACK + 32, b'\x7e' * 16)]
        if not loader:
            guards.extend([(slot - 16, b'\x93' * 16), (slot + 4, b'\x69' * 0xfc),
                           (slot + 0x100, b'\x94' * 16)])
        for address, value in guards:
            if bytes(uc.mem_read(address, len(value))) != value:
                raise OracleError(f'original guard or input/owner changed at {address:#x}')
        handle = struct.unpack('<I', uc.mem_read(slot, 4))[0]
        if handle != OUT:
            raise OracleError('original output slot mismatch')
        return bytes(uc.mem_read(OUT, OBJECT_BYTES)), cursor - body_va, offset, handle


def compare(lib, machine, body, seed, ordinal, payload=None, payload_offset=50):
    raw = storage(body)
    d, native = Decoded(), Constructed()
    if lib.action_family_2e_decode(raw, len(body), C.byref(d)) != 0:
        raise OracleError(f'native decoder rejected record {ordinal}')
    original, advance, offset, original_handle = machine.invoke(body, seed, payload, payload_offset)
    if advance != 15 or offset != (payload_offset + advance) & 0xffffffff:
        raise OracleError(f'original cursor/body rule mismatch record {ordinal}')
    if list(d.word) != list(struct.unpack('<7H', original[1:15])) or d.option_00 != original[0]:
        raise OracleError(f'decoded neutral field mismatch record {ordinal}')
    tail_bytes = len(body) - advance
    if (pointer(d.dependency_records), d.dependency_count, d.available_body_bytes,
        d.body_bytes, d.dependency_bytes) != (C.addressof(raw) + advance, tail_bytes // 16,
                                            len(body), advance, tail_bytes):
        raise OracleError(f'decoded body/tail mismatch record {ordinal}')
    # Using the same opaque model address permits comparison of the slot write.
    result = lib.action_family_2e_construct(raw, len(body), payload_offset, original_handle, C.byref(native))
    if result != 0:
        raise OracleError(f'native constructor rejected record {ordinal}: {result}')
    image = bytes(native.object_bytes)
    if image != original:
        raise OracleError(f'original/native allocation mismatch record {ordinal}')
    if (native.body_bytes_consumed, native.payload_offset_before, native.payload_offset_after,
        pointer(native.dependency_records), native.dependency_count, native.dependency_bytes,
        native.available_body_bytes) != (advance, payload_offset, offset, C.addressof(raw) + advance,
                                         tail_bytes // 16, tail_bytes, len(body)):
        raise OracleError(f'original/native cursor/body rule mismatch record {ordinal}')
    if (native.output_handle, native.result_slot_handle, native.output_allocation_bytes) != (
        original_handle, original_handle, OBJECT_BYTES):
        raise OracleError(f'original/native allocation rule mismatch record {ordinal}')
    if bytes(raw) != body:
        raise OracleError('native mutated input')
    return image, original


def compare_dependency(lib, machine, body, ordinal):
    decision, original_count = machine.dependency(body)
    expected_status = 3 if decision == 'reject' else 0
    raw = storage(body)
    for cls in (Decoded, Constructed):
        out = cls()
        C.memset(C.byref(out), 0xa5, C.sizeof(out))
        before = bytes(out)
        status = (lib.action_family_2e_decode(raw, len(body), C.byref(out)) if cls is Decoded else
            lib.action_family_2e_construct(raw, len(body), 50, OUT, C.byref(out)))
        if status != expected_status:
            raise OracleError(f'dependency original/native accept/reject mismatch record {ordinal}')
        if status == 0:
            length = out.body_bytes if cls is Decoded else out.body_bytes_consumed
            if (out.dependency_count, out.dependency_bytes, length, pointer(out.dependency_records)) != (
                    original_count, len(body) - OBJECT_BYTES, OBJECT_BYTES, C.addressof(raw) + OBJECT_BYTES):
                raise OracleError(f'dependency original/native count/boundary mismatch record {ordinal}')
        elif bytes(out) != before:
            raise OracleError(f'dependency rejection mutated output record {ordinal}')
    if bytes(raw) != body:
        raise OracleError('dependency native input mutation')
    return dict(case=str(ordinal), tail_bytes=len(body) - OBJECT_BYTES,
                original_decision=decision, original_stored_count=original_count)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path, default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily2e.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-2E.1.oracle-', dir=PRIVATE)) / 'report.json'
    if result_path.exists():
        raise OracleError('result path must be unique')
    started = time.monotonic()
    manifest_bytes = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE / 'A-2E.1.corpus.json').read_bytes()
    if sha(manifest_bytes) != MANIFEST_HASH or sha(corpus_bytes) != CORPUS_HASH:
        raise OracleError('pinned corpus/manifest mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    if (manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
        corpus['manifest_sha256'], corpus['raw_0x2e_records'], len(corpus['records']),
        corpus['scene_actions'], corpus['scen_data_records']) != (
            ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 10, 10, 19612, 2078):
        raise OracleError('corpus identity/count mismatch')
    resources = {}
    for resource in manifest['resources']:
        index = int(resource['index'])
        data = (ROOT / 'work/analysis/hiff-resources' / f'{index:04d}.bin').read_bytes()
        if len(data) != resource['size'] or sha(data) != resource['sha256']:
            raise OracleError(f'resource manifest mismatch: {index}')
        resources[index] = data
    if len(resources) != 2267:
        raise OracleError('resource coverage mismatch')
    pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
    if sha(pe.data) != EXE_HASH:
        raise OracleError('executable mismatch')
    for start, end, digest in CODE:
        if sha(pe.image[start - pe.image_base:end - pe.image_base]) != digest:
            raise OracleError(f'code window mismatch: {start:#x}')
    machine, lib = Original(pe), load_native(args.native_library)
    native_digest, original_digest = hashlib.sha256(), hashlib.sha256()
    bodies, tails = hashlib.sha256(), hashlib.sha256()
    subtypes, lengths = Counter(), Counter()
    dependency_cases = []
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        if (row['raw_body_offset'], row['raw_body_length'], row['body_sha256'], payload[48], payload[49],
            row['typed_body_length'], row['dependency_tail_length'], row['dependency_tail_records'],
            row['prefix_sha256'], row['dependency_tail_sha256']) != (
                p + 50, len(body), sha(body), 0x2e, row['subtype'], 15, len(body) - 15,
                (len(body) - 15) // 16, sha(body[:15]), sha(body[15:])):
            raise OracleError(f'corpus row source mismatch: {ordinal}')
        seed = bytes((ordinal * 31 + j * 19 + 7) & 255 for j in range(OBJECT_BYTES))
        native, original = compare(lib, machine, body, seed, ordinal, payload)
        native_digest.update(native)
        original_digest.update(original)
        bodies.update(body)
        tails.update(body[15:])
        subtypes[payload[49]] += 1
        lengths[len(body)] += 1
        dependency_cases.append(compare_dependency(lib, machine, body, f'corpus-{ordinal}'))
    synthetic = []
    cases = [(0, 0), (1, 1), (0x7fff, 2), (0x8000, 0), (0xffff, 1),
             (0xb17e, 9), (0x0102, 1000), (0xff01, 3)]
    for i, (word, tail) in enumerate(cases):
        body = body_fixture(word, tail)
        seed = bytes([0xcd if i % 2 else 0]) * OBJECT_BYTES
        offset = (0, 50, 0xfffffffe, 0xffffffff)[i % 4]
        image, _ = compare(lib, machine, body, seed, f'synthetic-direct-{i}', payload_offset=offset)
        subtype = (0, 1, 2, 255)[i % 4]
        payload = b'synthetic' + bytes(39) + bytes([0x2e, subtype]) + body
        compare(lib, machine, body, seed, f'synthetic-loader-{i}', payload)
        synthetic.append(dict(word_bits=word, tail_records=tail, subtype=subtype,
                              payload_offset=offset, object_sha256=sha(image)))
    for tail_bytes in range(41):
        body = body_fixture() + bytes((i * 23 + 7) & 255 for i in range(tail_bytes))
        dependency_cases.append(compare_dependency(lib, machine, body, f'tail-{tail_bytes}'))
    # Short constructor reads are unsafe in the original; test the deliberate
    # native rejection separately, without executing invalid original reads.
    for length in range(OBJECT_BYTES):
        raw = storage(bytes(length))
        for cls in (Decoded, Constructed):
            out = cls()
            C.memset(C.byref(out), 0xa5, C.sizeof(out))
            before = bytes(out)
            status = (lib.action_family_2e_decode(raw, length, C.byref(out)) if cls is Decoded else
                lib.action_family_2e_construct(raw, length, 50, OUT, C.byref(out)))
            if status != 2 or bytes(out) != before:
                raise OracleError(f'short-body native safety mismatch record {length}')
    result = dict(slice='A-2E.1', scope='original loader/constructor plus dependency structural decision; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()), corpus_records=10,
        synthetic_records=len(synthetic), synthetic_original_calls=2 * len(synthetic),
        original_calls=machine.allocations, full_loader_calls=10 + len(synthetic),
        direct_constructor_calls=len(synthetic), mismatches=0, corpus_object_bytes_compared=10 * OBJECT_BYTES,
        dependency_original_calls=machine.dependency_calls, dependency_cases=dependency_cases,
        total_original_invocations=machine.allocations + machine.dependency_calls,
        synthetic_object_bytes_compared=2 * len(synthetic) * OBJECT_BYTES,
        dependency_decisions=dict(Counter(row['original_decision'] for row in dependency_cases)),
        short_body_safety_cases=OBJECT_BYTES,
        corpus_object_sha256=native_digest.hexdigest(), original_object_sha256=original_digest.hexdigest(),
        corpus_raw_bodies_sha256=bodies.hexdigest(), corpus_dependency_tails_sha256=tails.hexdigest(),
        raw_body_length_distribution=dict(lengths), subtype_distribution=dict(subtypes), synthetic=synthetic,
        hooks=[dict(address=hex(ALLOCATOR), kind='replacement', purpose='malloc only: exactly 15 bytes; seeded contents and guards'),
               dict(range='0x20000000..0x2001ffff', kind='observation', purpose='reads confined to exact ACT fixture'),
               dict(range='0x30004ff0..0x3000501e', kind='observation', purpose='allocation writes confined to 15 bytes'),
               dict(range='0x20000000..0x2001ffff', kind='observation', purpose='reject original input writes'),
               dict(addresses=['0x424c31', '0x424c5b', '0x424c94'], kind='stop observation',
                    purpose='original empty/reject/accept branches before diagnostics/tree construction')],
        original_decisions_replaced=False, allocation_sizes=dict(machine.sizes),
        stop_boundaries=[hex(DEPENDENCY_BOUNDARY), hex(STOP), '0x424c31', '0x424c5b', '0x424c94'],
        deliberate_safety_rejections=['short prefix; fractional dependency tail; null/overlap/span wrap; zero model handle',
                                     'no body count exists; every 15-byte pattern is constructor data'],
        unverified=['allocation failure and fatal diagnostics', 'nonzero diagnostic flag',
                    'dependency content construction/evaluation beyond structural stop', 'runtime/movie/render/host effects',
                    'live subtype behavior beyond loader preservation', 'whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=10, synthetic_records=len(synthetic), original_calls=machine.allocations,
                         dependency_original_calls=machine.dependency_calls,
                         total_original_invocations=machine.allocations + machine.dependency_calls,
                         object_bytes_compared=10 * OBJECT_BYTES, mismatches=0, result=str(result_path),
                         result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
