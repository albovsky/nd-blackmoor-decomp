#!/usr/bin/env python3
"""Immutable original-x86 raw79 loader/constructor parity; runtime excluded.

Use work/tools/oracle-python/bin/python with Unicorn JIT permitted. Only malloc
is replaced; read/write hooks observe bounds. Reports use unique private paths.
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
from test_action_family_79 import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = 'd4fa3f9bafb5da4b59b297c82f08991d16ca720d0090bcc2a45eabc6ae53dfbd'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40e597, 0x40e5c4, 'de6ede612c2e2fa3a48e9717e7581db1368b9f6112319e4b2f9ac7915a33ba4c'),
    (0x4e9add, 0x4e9b87, '6b4e9e91064d62efa10f6c7a9980648dd825b4b678a1e815347eea8175be91d2'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT, DATA, STACK = 0x20000000, 0x30000000, 0x5800
OWNER, SLOT, CURSOR, OFFSET, OUT = (DATA + x for x in (0x1000, 0x2000, 0x2400, 0x2404, 0x5000))
STOP, ALLOCATOR, DEPENDENCY_BOUNDARY = 0x51000000, 0x51dc43, 0x410a68
OBJECT_BYTES = 2


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
        self.seed = b'\xcd\x9e'
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=INPUT, end=INPUT + 0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=OUT - 16, end=OUT + 17)

    def observe_read(self, _uc, _access, address, size, _value, _data):
        if address < self.source_span[0] or address + size > self.source_span[1]:
            raise OracleError(f'original read outside exact fixture at {address:#x}, size {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        if address < OUT or address + size > OUT + OBJECT_BYTES:
            raise OracleError(f'original write outside two-byte allocation at {address:#x}')

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
        owner = 0x571442 if loader else OWNER
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
        entry, boundary = (0x40b34a, DEPENDENCY_BOUNDARY) if loader else (0x4e9add, STOP)
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
            expected_table[48:50] = bytes([0x79, payload[49]])
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
    if lib.action_family_79_decode(raw, len(body), C.byref(d)) != 0:
        raise OracleError(f'native decoder rejected record {ordinal}')
    original, advance, offset, original_handle = machine.invoke(body, seed, payload, payload_offset)
    if advance != 2 or offset != (payload_offset + advance) & 0xffffffff:
        raise OracleError(f'original cursor/body rule mismatch record {ordinal}')
    if d.word_0 != struct.unpack('<H', original)[0]:
        raise OracleError(f'decoded neutral field mismatch record {ordinal}')
    tail_bytes = len(body) - advance
    if (pointer(d.dependency_records), d.dependency_count, d.available_body_bytes,
        d.body_bytes, d.dependency_bytes) != (C.addressof(raw) + advance, tail_bytes // 16,
                                            len(body), advance, tail_bytes):
        raise OracleError(f'decoded body/tail mismatch record {ordinal}')
    # Using the same opaque model address permits comparison of the slot write.
    result = lib.action_family_79_construct(raw, len(body), payload_offset, original_handle, C.byref(native))
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path, default=ROOT / 'outputs/blackmoor-decomp/build/libactionfamily79.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-79.1.oracle-', dir=PRIVATE)) / 'report.json'
    if result_path.exists():
        raise OracleError('result path must be unique')
    started = time.monotonic()
    manifest_bytes = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE / 'A-79.1.corpus.json').read_bytes()
    if sha(manifest_bytes) != MANIFEST_HASH or sha(corpus_bytes) != CORPUS_HASH:
        raise OracleError('pinned corpus/manifest mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    if (manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
        corpus['manifest_sha256'], corpus['raw_0x79_records'], len(corpus['records']),
        corpus['scene_actions'], corpus['scen_data_records']) != (
            ARCHIVE_HASH, ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, 38, 38, 19612, 2078):
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
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p, n = row['act_payload_offset'], row['act_payload_length']
        payload = data[p:p + n]
        body = payload[50:]
        if (row['raw_body_offset'], row['raw_body_length'], row['body_sha256'], payload[48], payload[49],
            row['typed_body_length'], row['dependency_tail_length'], row['dependency_tail_records'],
            row['prefix_sha256'], row['dependency_tail_sha256']) != (
                p + 50, len(body), sha(body), 0x79, row['subtype'], 2, len(body) - 2,
                (len(body) - 2) // 16, sha(body[:2]), sha(body[2:])):
            raise OracleError(f'corpus row source mismatch: {ordinal}')
        seed = bytes([(ordinal * 31 + 7) & 255, (ordinal * 19 + 91) & 255])
        native, original = compare(lib, machine, body, seed, ordinal, payload)
        native_digest.update(native)
        original_digest.update(original)
        bodies.update(body)
        tails.update(body[2:])
        subtypes[payload[49]] += 1
        lengths[len(body)] += 1
    synthetic = []
    cases = [(0, 0), (1, 1), (0x7fff, 2), (0x8000, 0), (0xffff, 1),
             (0xb17e, 9), (0x0102, 1000), (0xff01, 3)]
    for i, (word, tail) in enumerate(cases):
        body = body_fixture(word, tail)
        seed = bytes([0xcd if i % 2 else 0]) * 2
        offset = (0, 50, 0xfffffffe, 0xffffffff)[i % 4]
        image, _ = compare(lib, machine, body, seed, f'synthetic-direct-{i}', payload_offset=offset)
        subtype = (0, 1, 2, 255)[i % 4]
        payload = b'synthetic' + bytes(39) + bytes([0x79, subtype]) + body
        compare(lib, machine, body, seed, f'synthetic-loader-{i}', payload)
        synthetic.append(dict(word_bits=word, tail_records=tail, subtype=subtype,
                              payload_offset=offset, object_sha256=sha(image)))
    result = dict(slice='A-79.1', scope='original loader to 0x410a68 and direct constructor; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH, manifest_sha256=MANIFEST_HASH, archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH, resources_verified=len(resources), code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()), corpus_records=38,
        synthetic_records=len(synthetic), synthetic_original_calls=2 * len(synthetic),
        original_calls=machine.allocations, full_loader_calls=38 + len(synthetic),
        direct_constructor_calls=len(synthetic), mismatches=0, corpus_object_bytes_compared=38 * OBJECT_BYTES,
        corpus_object_sha256=native_digest.hexdigest(), original_object_sha256=original_digest.hexdigest(),
        corpus_raw_bodies_sha256=bodies.hexdigest(), corpus_dependency_tails_sha256=tails.hexdigest(),
        raw_body_length_distribution=dict(lengths), subtype_distribution=dict(subtypes), synthetic=synthetic,
        hooks=[dict(address=hex(ALLOCATOR), kind='replacement', purpose='malloc only: exactly two bytes; seeded contents and guards'),
               dict(range='0x20000000..0x2001ffff', kind='observation', purpose='reads confined to exact ACT fixture'),
               dict(range='0x30004ff0..0x30005011', kind='observation', purpose='allocation writes confined to two bytes')],
        original_decisions_replaced=False, allocation_sizes=dict(machine.sizes),
        stop_boundaries=[hex(DEPENDENCY_BOUNDARY), hex(STOP)],
        deliberate_safety_rejections=['short prefix; fractional dependency tail; null/overlap/span wrap; zero model handle',
                                     'no body count exists; all word bit patterns are valid constructor data'],
        unverified=['allocation failure and fatal diagnostics', 'nonzero diagnostic flag',
                    'dependency construction/evaluation beyond loader stop', 'runtime/inventory/render/host effects',
                    'live subtype behavior beyond loader preservation', 'whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic() - started, 3))
    with result_path.open('x') as output:
        output.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(corpus_records=38, synthetic_records=len(synthetic), original_calls=machine.allocations,
                         object_bytes_compared=38 * OBJECT_BYTES, mismatches=0, result=str(result_path),
                         result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
