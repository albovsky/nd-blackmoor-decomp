#!/usr/bin/env python3
"""Immutable original-x86 0x1b loader/constructor AND generic tail oracle.

Run with work/tools/oracle-python/bin/python with Unicorn JIT allowed.
Only malloc and the shared tail diagnostic boundary are replaced. No original
decision is replaced. Reports are exclusive, in unique per-run directories.
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
from cif_original_oracle import PEImage, OracleError
from test_action_family_1b import Decoded, Constructed, body_fixture, load_native, pointer, storage
from tail_oracle_common import OriginalTail, HOOKS as TAIL_HOOKS, EXIT_POINTS, TAIL_LENGTHS, WIDTH_TAILS

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '665db35adf2a335892255588d94d1ac2dde6b5e3b14e4294bbd6865da3649f02'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40bbed, 0x40bc1a, '48386914d6bde74ae645b237d48c209379ded436f5983eb34266480ba3dd1aaa'),
    (0x414692, 0x414947, 'a14081d6c878930bce560a0ee3bc9e67b11c07f016e3d583ca133dde909f8966'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x424aa8, 0x425b8b, 'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
]
INPUT, DATA, STACK = 0x20000000, 0x30000000, 0x5800
OWNER, SLOT, CURSOR, OFFSET, OUT = (DATA + x for x in (0x1000, 0x2000, 0x2400, 0x2404, 0x5000))
PRIMARY, SECONDARY = DATA + 0x10000, DATA + 0x110000
STOP, ALLOCATOR, BOUNDARY = 0x51000000, 0x51dc43, 0x410a68


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
        self.uc.mem_map(INPUT, 0x200000)
        self.uc.mem_map(DATA, 0x200000)
        self.uc.reg_write(self.r['ES'], 0)
        self.calls = 0
        self.allocations = 0
        self.sizes = Counter()
        self.source_span = (0, 0)
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=ALLOCATOR, end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.observe_read, begin=INPUT, end=INPUT + 0x1fffff)
        for start, end in [(OUT-16, OUT+34+15), (PRIMARY-16, PRIMARY+0xc0000),
                           (SECONDARY-16, SECONDARY+0xa0000)]:
            self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_write, begin=start, end=end)

    def observe_read(self, _uc, _access, address, size, _value, _data):
        require(self.source_span[0] <= address and address + size <= self.source_span[1],
                f'original read outside exact ACT: {address:#x}, size {size}')

    def observe_write(self, _uc, _access, address, size, _value, _data):
        require(any(a <= address and address + size <= a+n for a, n in self.expected),
                f'original write outside allocation: {address:#x}, size {size}')

    def allocate(self, uc, address, _size, _data):
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require(address == ALLOCATOR and self.next_allocation < 3, 'unexpected allocation hook')
        handle, expected = self.expected[self.next_allocation]
        require(size == expected, f'original allocation request mismatch: {size} != {expected}')
        uc.mem_write(handle - 16, b'\xa5' * 16 + self.seed * size + b'\xd7' * 16)
        uc.reg_write(self.r['EAX'], handle)
        uc.reg_write(self.r['ESP'], esp + 4)
        uc.reg_write(self.r['EIP'], ret)
        self.next_allocation += 1
        self.allocations += 1
        self.sizes[size] += 1

    def invoke(self, body, payload=None, payload_offset=50, seed=b'\xcd'):
        uc, r = self.uc, self.r
        p = struct.unpack_from('<h', body)[0]
        s = struct.unpack_from('<h', body, 24 + 22*p)[0]
        require(0 <= p <= 32767 and 0 <= s <= 32767 and len(seed) == 1, 'invalid oracle fixture')
        self.expected = [(OUT, 34), (PRIMARY, p*22), (SECONDARY, s*18)]
        self.seed, self.next_allocation = seed, 0
        loader = payload is not None
        source = payload if loader else bytes(50) + body
        require(len(source) + 32 <= 0x200000, 'fixture exceeds source mapping')
        body_va = INPUT + 16 + 50
        self.source_span = (INPUT+16, INPUT+16+len(source))
        uc.mem_write(INPUT, b'\xa6'*16 + source + b'\xd6'*16)
        owner, slot = (0x6385db, 0x5bb5e5) if loader else (OWNER, SLOT)
        owner_before = b'\x5a' * 0x100
        uc.mem_write(owner-16, b'\x91'*16 + owner_before + b'\x92'*16)
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'nonzero diagnostic flag')
        uc.mem_write(0x5c39e3, bytes(2))
        if loader:
            uc.mem_write(0x5bb5b3, bytes(0x8d))
        else:
            uc.mem_write(slot-16, b'\x93'*16 + b'\x69'*0x100 + b'\x94'*16)
            uc.mem_write(CURSOR, struct.pack('<II', body_va, payload_offset))
        args = (INPUT+16, len(source)) if loader else (slot, CURSOR, OFFSET)
        stack_args = struct.pack('<' + 'I'*(len(args)+1), STOP, *args)
        uc.mem_write(STACK-0x1000, b'\x3c'*16)
        uc.mem_write(STACK+32, b'\x7e'*16)
        uc.mem_write(STACK, stack_args)
        initial = dict(EAX=0x11111111, EBX=0x22222222, ECX=owner, EDX=0x33333333,
                       ESI=0x44444444, EDI=0x55555555, EBP=0x66666666)
        for name, value in initial.items(): uc.reg_write(r[name], value)
        uc.reg_write(r['ESP'], STACK)
        uc.reg_write(r['EFLAGS'], 0x202)
        entry, boundary = (0x40b34a, BOUNDARY) if loader else (0x414692, STOP)
        uc.emu_start(entry, boundary, count=2000000)
        require(uc.reg_read(r['EIP']) == boundary and self.next_allocation == 3,
                'original did not reach boundary with three allocations')
        if loader:
            ebp = uc.reg_read(r['EBP'])
            cursor = struct.unpack('<I', uc.mem_read(ebp-0x20, 4))[0]
            offset = struct.unpack('<I', uc.mem_read(ebp-0xcc, 4))[0]
            table = bytearray(0x8d)
            count = payload[:48].index(0)+1
            table[:count] = payload[:count]
            table[48:50] = bytes([0x1b, payload[49]])
            struct.pack_into('<I', table, 50, OUT)
            require(bytes(uc.mem_read(0x5bb5b3, 0x8d)) == table,
                    'original runtime type/subtype/table mismatch')
        else:
            cursor, offset = struct.unpack('<II', uc.mem_read(CURSOR, 8))
            require(uc.reg_read(r['ESP']) == STACK+16, 'original RET cleanup mismatch')
            for name in ('EBX', 'ESI', 'EDI', 'EBP'):
                require(uc.reg_read(r[name]) == initial[name], 'original callee-saved register mismatch')
        expected_owner = bytearray(owner_before)
        struct.pack_into('<III', expected_owner, 0x1c, OUT, PRIMARY, SECONDARY)
        require(bytes(uc.mem_read(owner, 0x100)) == expected_owner, 'original owner write mismatch')
        guards = [(INPUT, b'\xa6'*16), (INPUT+16, source), (INPUT+16+len(source), b'\xd6'*16),
                  (owner-16, b'\x91'*16), (owner+0x100, b'\x92'*16),
                  (STACK-0x1000, b'\x3c'*16), (STACK, stack_args), (STACK+32, b'\x7e'*16)]
        for a, n in self.expected: guards.extend([(a-16, b'\xa5'*16), (a+n, b'\xd7'*16)])
        if not loader:
            guards.extend([(slot-16, b'\x93'*16), (slot+4, b'\x69'*0xfc), (slot+0x100, b'\x94'*16)])
        for a, value in guards:
            require(bytes(uc.mem_read(a, len(value))) == value, f'original guard changed at {a:#x}')
        require(struct.unpack('<I', uc.mem_read(slot, 4))[0] == OUT, 'original output slot mismatch')
        self.calls += 1
        return dict(object=bytes(uc.mem_read(OUT, 34)), primary=bytes(uc.mem_read(PRIMARY, p*22)),
                    secondary=bytes(uc.mem_read(SECONDARY, s*18)),
                    advance=cursor-body_va, offset=offset, allocations=[n for _, n in self.expected])


def compare(lib, machine, body, ordinal, payload=None, payload_offset=50, seed=b'\xcd'):
    raw, d, c, n = storage(body), Decoded(), Constructed(), C.c_size_t()
    original = machine.invoke(body, payload, payload_offset, seed)
    advance = original['advance']
    require(lib.action_family_1b_decode(raw, len(body), C.byref(d)) == 0,
            f'native decoder rejected original-valid fixture {ordinal}')
    require(lib.action_family_1b_body_length(raw, len(body), C.byref(n)) == 0 and n.value == advance,
            'native body_length/original cursor mismatch')
    obj = original['object']
    require((d.raw_type, d.runtime_type, d.primary_count, d.secondary_count,
             list(d.fixed_words), list(d.fixed_dwords)) ==
            (27, 27, struct.unpack_from('<h', obj)[0], struct.unpack_from('<h', obj, 28)[0],
             list(struct.unpack_from('<5H', obj, 6)), list(struct.unpack_from('<3I', obj, 16))),
            'decoded field mismatch')
    require((d.primary_bytes, d.secondary_bytes, d.body_bytes, d.available_body_bytes,
             pointer(d.primary_records), pointer(d.secondary_records), pointer(d.dependency_records)) ==
            (len(original['primary']), len(original['secondary']), advance, len(body),
             C.addressof(raw)+2, C.addressof(raw)+26+len(original['primary']), C.addressof(raw)+advance),
            'decoded body/view mismatch')
    require(d.dependency_bytes == len(body)-advance and d.dependency_count == (len(body)-advance)//16,
            'decoded dependency count mismatch')
    require(lib.action_family_1b_construct(raw, len(body), payload_offset, OUT, PRIMARY, SECONDARY,
                                         C.byref(c)) == 0, 'native constructor rejected original-valid fixture')
    require(bytes(c.object_bytes) == obj, 'original/native object mismatch')
    require(C.string_at(c.primary_records, c.primary_bytes) == original['primary'] and
            C.string_at(c.secondary_records, c.secondary_bytes) == original['secondary'],
            'original/native array mismatch')
    require((c.result_slot_handle, c.owner_field_1c, c.owner_field_20, c.owner_field_24) ==
            (OUT, OUT, PRIMARY, SECONDARY), 'original/native owner fields mismatch')
    require((c.output_allocation_bytes, c.primary_allocation_bytes, c.secondary_allocation_bytes,
             c.allocation_count) == (*original['allocations'], 3), 'original/native allocation rule mismatch')
    require((c.body_bytes_consumed, c.payload_offset_before, c.payload_offset_after) ==
            (advance, payload_offset, original['offset']), 'original/native cursor mismatch')
    require((pointer(c.primary_records), c.primary_bytes, pointer(c.secondary_records), c.secondary_bytes,
             pointer(c.dependency_records), c.dependency_count, c.dependency_bytes, c.available_body_bytes) ==
            (pointer(d.primary_records), d.primary_bytes, pointer(d.secondary_records), d.secondary_bytes,
             pointer(d.dependency_records), d.dependency_count, d.dependency_bytes, len(body)),
            'original/native constructed view mismatch')
    require(bytes(raw) == body, 'native mutated input')
    return original


def compare_tail(lib, machine, payload, typed):
    original = machine.invoke(payload, typed)
    raw, d, c, n = storage(payload[50:]), Decoded(), Constructed(), C.c_size_t()
    for value in (d, c, n): C.memset(C.byref(value), 0xa5, C.sizeof(value))
    before = (bytes(d), bytes(c), bytes(n))
    status = lib.action_family_1b_decode(raw, len(payload)-50, C.byref(d))
    length_status = lib.action_family_1b_body_length(raw, len(payload)-50, C.byref(n))
    ctor_status = lib.action_family_1b_construct(raw, len(payload)-50, 50, OUT, PRIMARY, SECONDARY, C.byref(c))
    require((status == 0) == original.accepted and status == length_status == ctor_status,
            'tail acceptance mismatch')
    if original.accepted:
        require(d.body_bytes == n.value == c.body_bytes_consumed == typed,
                'tail body_length mismatch')
        require(d.dependency_count == c.dependency_count == original.count,
                'tail count mismatch')
        require(pointer(d.dependency_records) == pointer(c.dependency_records) == C.addressof(raw)+typed and
                d.dependency_bytes == c.dependency_bytes == len(payload)-50-typed,
                'tail view mismatch')
    else:
        require((bytes(d), bytes(c), bytes(n)) == before, 'tail rejection mutated output')
    return original


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path, default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily1b.dylib')
    ap.add_argument('--result', type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-1B.1.oracle-', dir='/private/tmp'))/'report.json'
    require(not result_path.exists(), 'result path must be unique')
    started = time.monotonic()
    mb, cb = (ROOT/'work/analysis/hiff-resources.json').read_bytes(), (PRIVATE/'A-1B.1.corpus.json').read_bytes()
    require(sha(mb) == MANIFEST_HASH and sha(cb) == CORPUS_HASH, 'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['exe_sha256'], corpus['manifest_sha256'],
             corpus['archive_sha256'], corpus['scene_actions'], corpus['scen_data_records'],
             corpus['raw_0x1b_records'], len(corpus['records'])) ==
            (ARCHIVE_HASH, EXE_HASH, MANIFEST_HASH, ARCHIVE_HASH, 19612, 2078, 4, 4), 'corpus identity mismatch')
    resources = {}
    for r in manifest['resources']:
        index = int(r['index'])
        data = (ROOT/'work/analysis/hiff-resources'/f'{index:04d}.bin').read_bytes()
        require(len(data) == r['size'] and sha(data) == r['sha256'], f'resource mismatch: {index}')
        resources[index] = data
    require(len(resources) == 2267, 'resource count mismatch')
    pe = PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    require(len(pe.data) == 1511424 and sha(pe.data) == EXE_HASH, 'executable mismatch')
    for a, b, digest in CODE:
        require(sha(pe.image[a-pe.image_base:b-pe.image_base]) == digest, f'code mismatch {a:#x}')
    machine, tail, lib = Original(pe), OriginalTail(), load_native(args.native_library)
    objects, arrays, bodies = hashlib.sha256(), hashlib.sha256(), hashlib.sha256()
    bytes_compared = 0
    exits = Counter()
    for ordinal, row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        at, length = row['act_payload_offset'], row['act_payload_length']
        payload = data[at:at+length]; body = payload[50:]; typed = row['typed_body_length']
        require((payload[48], payload[49], row['body_sha256'], row['prefix_sha256'],
                 row['dependency_tail_sha256'], row['raw_body_offset'], row['raw_body_length'],
                 row['dependency_tail_length'], row['dependency_tail_records']) ==
                (27, row['subtype'], sha(body), sha(body[:typed]), sha(body[typed:]), at+50,
                 len(body), len(body)-typed, (len(body)-typed)//16), 'corpus row source mismatch')
        original = compare(lib, machine, body, ordinal, payload, seed=bytes([ordinal*31+7]))
        require(original['advance'] == typed, 'corpus original cursor mismatch')
        require((struct.unpack_from('<h', original['object'])[0],
                 struct.unpack_from('<h', original['object'], 28)[0]) ==
                (row['primary_count'], row['secondary_count']), 'corpus count mismatch')
        objects.update(original['object']); bodies.update(body)
        arrays.update(original['primary']); arrays.update(original['secondary'])
        bytes_compared += 34 + len(original['primary']) + len(original['secondary'])
        exits[hex(compare_tail(lib, tail, payload, original['advance']).exit_address)] += 1
    synthetic = []
    cases = [(0, 0, 0), (0, 1, 1), (1, 0, 2), (2, 3, 9), (255, 256, 0),
             (256, 255, 1), (32767, 0, 0), (0, 32767, 1), (32767, 32767, 2)]
    for i, (p, s, t) in enumerate(cases):
        body = body_fixture(p, s, t)
        offset = (0, 50, 0xfffffffe, 0xffffffff)[i % 4]
        compare(lib, machine, body, f'direct-{i}', payload_offset=offset, seed=b'\x9e')
        subtype = (0, 1, 2, 255)[i % 4]
        payload = b'synthetic'+bytes(39)+bytes([27, subtype])+body
        original = compare(lib, machine, body, f'loader-{i}', payload, seed=b'\x00')
        exits[hex(compare_tail(lib, tail, payload, original['advance']).exit_address)] += 1
        synthetic.append(dict(primary=p, secondary=s, tail_records=t, subtype=subtype, offset=offset))
    # Every typed extent below comes from the original constructor cursor. Tail
    # lengths are the shared oracle's full set (0..300, 1023..1025, 4079..4097)
    # plus its width rows (4096, 1,048,576 and 1,048,592 tail bytes, i.e.
    # 256, 65,536 and 65,537 sixteen-byte records).
    tail_synthetic = 0
    pattern = bytes((i * 37 + 11) & 255 for i in range(max(TAIL_LENGTHS)))

    def sweep(prefix_payload, typed_len):
        nonlocal tail_synthetic
        for length in TAIL_LENGTHS:
            exits[hex(compare_tail(lib, tail, prefix_payload + pattern[:length], typed_len).exit_address)] += 1
            tail_synthetic += 1
        for length in WIDTH_TAILS:
            exits[hex(compare_tail(lib, tail, prefix_payload + bytes(length), typed_len).exit_address)] += 1
            tail_synthetic += 1

    for row in corpus['records']:
        data = resources[row['resource_index']]
        at = row['act_payload_offset']
        sweep(data[at:at + 50 + row['typed_body_length']], row['typed_body_length'])
    for p, s in [(0, 0), (1, 1), (2, 3)]:
        body = body_fixture(p, s)
        typed = compare(lib, machine, body, 'tail-base')['advance']
        sweep(b'tail' + bytes(44) + bytes([27, 1]) + body, typed)
    # Short/count-invalid constructors are NOT executed: original has no bounds
    # guards. Backing storage remains full while the native advertised span is
    # shortened, so short-guard mutants fail without undefined host reads.
    short_cases = 0
    for p, s in [(0, 0), (1, 1), (2, 3)]:
        raw = storage(body_fixture(p, s))
        for length in range(len(raw)):
            d, c, n = Decoded(), Constructed(), C.c_size_t()
            for value in (d, c, n): C.memset(C.byref(value), 0xa5, C.sizeof(value))
            before = (bytes(d), bytes(c), bytes(n))
            require(lib.action_family_1b_decode(raw, length, C.byref(d)) == 2 and
                    lib.action_family_1b_body_length(raw, length, C.byref(n)) == 2 and
                    lib.action_family_1b_construct(raw, length, 50, OUT, PRIMARY, SECONDARY, C.byref(c)) == 2,
                    'native short-body safety rejection mismatch')
            require((bytes(d), bytes(c), bytes(n)) == before, 'short-body rejection mutated output')
            short_cases += 1
    count_safety_cases = 0
    for slot in (0, 24):
        for bits in (0x8000, 0xffff):
            data = bytearray(body_fixture(0, 0))
            struct.pack_into('<H', data, slot, bits)
            raw = storage(data)
            d, c, n = Decoded(), Constructed(), C.c_size_t()
            for value in (d, c, n): C.memset(C.byref(value), 0xa5, C.sizeof(value))
            before = (bytes(d), bytes(c), bytes(n))
            require(lib.action_family_1b_decode(raw, len(data), C.byref(d)) == 3 and
                    lib.action_family_1b_body_length(raw, len(data), C.byref(n)) == 3 and
                    lib.action_family_1b_construct(raw, len(data), 50, OUT, PRIMARY, SECONDARY, C.byref(c)) == 3,
                    'native negative-count safety rejection mismatch')
            require((bytes(d), bytes(c), bytes(n)) == before, 'negative-count rejection mutated output')
            count_safety_cases += 1
    report = dict(slice='A-1B.1', status='pass', mismatches=0, corpus_records=4,
        resources_verified=2267, scene_count=2078, action_count=19612,
        original_calls=machine.calls, original_allocations=machine.allocations,
        full_loader_calls=4+len(cases), direct_constructor_calls=len(cases)+3,
        synthetic=synthetic, corpus_bytes_compared=bytes_compared,
        corpus_object_sha256=objects.hexdigest(), corpus_arrays_sha256=arrays.hexdigest(),
        corpus_raw_bodies_sha256=bodies.hexdigest(), allocation_sizes=dict(machine.sizes),
        dependency_original_calls=tail.calls, dependency_synthetic_cases=tail_synthetic,
        tail_lengths=list(TAIL_LENGTHS), width_tail_bytes=list(WIDTH_TAILS),
        dependency_exits=dict(exits), native_short_safety_cases=short_cases,
        native_negative_count_safety_cases=count_safety_cases,
        hashes=dict(exe=EXE_HASH, manifest=MANIFEST_HASH, archive=ARCHIVE_HASH, corpus=CORPUS_HASH,
            native=sha(args.native_library.read_bytes()), oracle=sha(Path(__file__).read_bytes()),
            tail_common=sha((Path(__file__).parent/'tail_oracle_common.py').read_bytes())),
        code_windows=CODE, hooks=[
            dict(address=hex(ALLOCATOR), kind='replacement', purpose='malloc only: validate size/order; return successful guarded allocations, including zero-byte requests'),
            dict(range='0x20000000..0x201fffff', kind='observation', purpose='exact ACT reads'),
            dict(range='0x30004ff0..0x30005031; 0x3000fff0..0x300d0000; 0x3010fff0..0x301b0000',
                 kind='observation', purpose='exact allocation writes'),
            dict(kind='replacement', stage='dependency', inventory=TAIL_HOOKS)],
        stop_boundaries=[hex(BOUNDARY), hex(STOP)], tail_stop_boundaries=EXIT_POINTS,
        original_decisions_replaced=False,
        deliberate_safety_rejections=['negative signed counts, truncated bodies, fractional tails',
            'null/overlap/wrapped native spans; null or wrapping model allocation handles',
            'invalid original constructor reads and negative-size allocations not executed'],
        unverified=['allocation failure/fatal cleanup and actual malloc(0) null return',
            'nonzero diagnostic flag; prior dependency slot reuse; dependency opcode/tree construction and evaluation',
            'runtime 0x414947 phases/effects, subtype behavior, owner construction/destruction, rendering/host effects',
            'shared parser registration, live integration, independent frozen-commit review, whole-file matching and gameplay'],
        elapsed_seconds=round(time.monotonic()-started, 3))
    with result_path.open('x') as output: json.dump(report, output, indent=2); output.write('\n')
    print(json.dumps(dict(status='pass', corpus=4, original_calls=machine.calls, dependency_calls=tail.calls,
                         bytes_compared=bytes_compared, mismatches=0, result=str(result_path),
                         result_sha256=sha(result_path.read_bytes()))))


if __name__ == '__main__':
    main()
