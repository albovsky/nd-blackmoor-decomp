#!/usr/bin/env python3
"""Execute immutable raw-0x17 loader and original dependency-tail decisions.

Run with work/tools/oracle-python/bin/python, with Unicorn JIT permitted.
Only malloc and the shared tail logger are replaced; no decision is hooked.
Reports/builds use exclusive, unique private paths. No gameplay/matching claim.
"""
from __future__ import annotations
import argparse
from collections import Counter
import ctypes as C
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
from cif_original_oracle import PEImage, OracleError
from tail_oracle_common import (OriginalTail, compare_tail, check_short_body,
    sha, require, write_json, EXE_HASH, MANIFEST_HASH, ARCHIVE_HASH,
    HOOKS as TAIL_HOOKS, EXIT_POINTS, UNVERIFIED as TAIL_UNVERIFIED)
from test_action_family_17 import (Decoded, Constructed, body_fixture, storage, load_native)

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / 'outputs/blackmoor-decomp'
PRIVATE = ROOT / 'work/analysis/slices'
CORPUS_HASH = '2399859bd72e1b7e987adb6a7acf58319d9e7f24cc33e9b3c5340050a67b5537'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410e9c, 0x410f89, '87f4afb74f4d68e1b7167bfd96523240f5eb6c71871c4d33f605c37ef7f8dfec'),
    (0x410ca4, 0x410e9c, 'd28d81929e9f41e778c076814f7e22384ec2eb353716633eb9545b01217bab0d'),
    (0x40b98f, 0x40bafd, 'ff017c64100236f805794cf94d694fbf277aebacadbda74bd31ff5ea56245677'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT, ACT, ARENA = 0x20000000, 0x20000010, 0x30000000
SLOT, STACK, STOP, BOUNDARY, MALLOC = 0x5bb5b3, 0x9000, 0x51000000, 0x410a68, 0x51dc43
HOOKS = {
    'code:0x51dc43': 'cdecl malloc only: validate original size/caller, return guarded exact-size object; no allocation failure',
    'memory:input-read': 'observer only: fail on a read outside the exact ACT span',
    'memory:arena-write': 'observer only: fail on a write outside the exact allocation',
    **TAIL_HOOKS,
}
UNVERIFIED = [
    'Independent frozen-commit review and shared parser/runtime integration remain for root.',
    'Negative/overflowing count original malloc/copy behavior is not replayed; native rejects counts outside 0..1819.',
    'Allocation failure/fatal handling at 0x40b9e1, nonzero diagnostics at 0x40ba73, reused/nonzero scene slots.',
    'Runtime 0x42b07e, dependency reducer 0x423f57, rendering/host scene effects and subtype gameplay.',
    'No original C++ provenance, byte-matching rebuild or complete-game claim.',
] + TAIL_UNVERIFIED


class Original:
    def __init__(self):
        from unicorn import (Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE,
            UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_PROT_READ)
        from unicorn import x86_const as x
        pe = PEImage.parse_and_map(ROOT / 'work/original/GAME.EXE')
        require(len(pe.data) == 1511424 and sha(pe.data) == EXE_HASH, 'pinned original mismatch')
        for start, end, digest in CODE:
            require(sha(pe.image[start-pe.image_base:end-pe.image_base]) == digest, 'pinned loader code mismatch')
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.r = {n: getattr(x, 'UC_X86_REG_' + n) for n in
            ('EAX','EBX','ECX','EDX','ESI','EDI','EBP','ESP','EIP','EFLAGS','ES')}
        self.uc.mem_map(pe.image_base, (pe.size_of_image + 4095) & ~4095)
        self.uc.mem_write(pe.image_base, pe.image)
        self.uc.mem_map(0x1000, 0x10000)
        self.uc.mem_map(INPUT, 0x20000, UC_PROT_READ)
        self.uc.mem_map(ARENA-0x1000, 0x22000)
        self.uc.hook_add(UC_HOOK_CODE, self.allocate, begin=MALLOC, end=MALLOC)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.observe_input, begin=INPUT, end=INPUT+0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.observe_arena, begin=ARENA-0x1000, end=ARENA+0x20fff)
        self.calls = 0
        self.sizes = Counter()

    def observe_input(self, _uc, _access, address, size, _value, _user):
        require(ACT <= address and address+size <= ACT+len(self.payload), 'original read beyond exact ACT')

    def observe_arena(self, _uc, _access, address, size, _value, _user):
        require(self.allocations == 1 and ARENA <= address and address+size <= ARENA+self.typed,
                'original write beyond exact allocation')

    def allocate(self, uc, address, _size, _user):
        esp = uc.reg_read(self.r['ESP'])
        ret, size = struct.unpack('<II', uc.mem_read(esp, 8))
        require((address, ret, size, self.allocations) == (MALLOC, 0x40b9b6, self.typed, 0),
                'unexpected original malloc size/caller/count')
        uc.mem_write(ARENA-16, b'\xa5'*16 + b'\xcd'*size + b'\xd7'*16)
        self.allocations += 1
        self.sizes[size] += 1
        uc.reg_write(self.r['EAX'], ARENA)
        uc.reg_write(self.r['ESP'], esp+4)
        uc.reg_write(self.r['EIP'], ret)

    def invoke(self, payload, offset=50):
        uc, r = self.uc, self.r
        count = struct.unpack_from('<h', payload, 70)[0]
        self.typed = 22 + 18*count
        require(0 <= count <= 1819 and 50+self.typed <= len(payload) <= 0x1ff00,
                'original fixture outside nonnarrowing domain')
        require(payload[48] == 0x17, 'wrong family')
        self.payload, self.allocations = payload, 0
        uc.mem_write(INPUT, b'\xa6'*16 + payload + b'\xd6'*16)
        uc.mem_write(SLOT-16, b'\x91'*16 + bytes(0x8d) + b'\x92'*16)
        uc.mem_write(0x5c39e3, bytes(2))
        require(bytes(uc.mem_read(0x63a4cd, 2)) == bytes(2), 'original diagnostic flag nonzero')
        args = struct.pack('<III', STOP, ACT, len(payload))
        uc.mem_write(STACK, args)
        uc.mem_write(STACK-0x1000, b'\x71'*16)
        uc.mem_write(STACK+12, b'\x82'*16)
        for name, value in dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
            EDX=0x44444444, ESI=0x55555555, EDI=0x66666666, EBP=0x77777777,
            ESP=STACK, EFLAGS=0x202, ES=0).items():
            uc.reg_write(r[name], value)
        start = 0x40b34a
        if offset != 50:
            # Synthetic cursor-wrap probe: enter the identical original arm with
            # the loader's exact local layout. The source pointer is independent.
            start = 0x40b98f
            frame = STACK-4
            uc.reg_write(r['EBP'], frame)
            uc.reg_write(r['ESP'], frame-0x244)
            uc.mem_write(frame-0x20, struct.pack('<I', ACT+50))
            uc.mem_write(frame-0xcc, struct.pack('<I', offset))
            uc.mem_write(SLOT, payload[:50])
        uc.emu_start(start, BOUNDARY, count=1000000)
        require(uc.reg_read(r['EIP']) == BOUNDARY and self.allocations == 1,
                'original did not reach dependency boundary')
        frame = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(frame-0x20, 4))[0]
        after = struct.unpack('<I', uc.mem_read(frame-0xcc, 4))[0]
        expected = bytearray(0x8d)
        expected[:len(payload[:48].split(b'\0')[0])+1] = payload[:48].split(b'\0')[0]+b'\0'
        expected[48:50] = payload[48:50]
        expected[50:54] = struct.pack('<I', ARENA)
        if offset != 50:
            expected[:50] = payload[:50]
        for address, value in ((INPUT,b'\xa6'*16),(ACT,payload),(ACT+len(payload),b'\xd6'*16),
            (SLOT-16,b'\x91'*16),(SLOT,bytes(expected)),(SLOT+0x8d,b'\x92'*16),
            (ARENA-16,b'\xa5'*16),(ARENA+self.typed,b'\xd7'*16),
            (STACK-0x1000,b'\x71'*16),(STACK,args),(STACK+12,b'\x82'*16)):
            require(bytes(uc.mem_read(address,len(value))) == value, f'original guard/slot changed {address:#x}')
        require(uc.reg_read(r['ESP']) == frame-0x244, 'original stack imbalance')
        self.calls += 1
        return bytes(uc.mem_read(ARENA,self.typed)), cursor-ACT-50, after


class Native:
    family = '17'

    def __init__(self, library):
        self.lib = load_native(library)
        self.decode = self.lib.action_family_17_decode

    def invoke(self, body, length=None):
        raw, decoded = storage(body), Decoded()
        C.memset(C.byref(decoded), 0xa5, C.sizeof(decoded))
        before = bytes(decoded)
        status = self.decode(raw, len(body) if length is None else length, C.byref(decoded))
        return status, decoded, raw, before


def corpus_records():
    mb = (ROOT/'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE/'A-17.1.corpus.json').read_bytes()
    require(sha(mb) == MANIFEST_HASH and sha(cb) == CORPUS_HASH, 'pinned manifest/corpus mismatch')
    manifest, corpus = json.loads(mb), json.loads(cb)
    require((manifest['archive_sha256'], corpus['archive_sha256'], corpus['exe_sha256'],
        corpus['manifest_sha256'], corpus['resources_scanned'], corpus['scen_data_records'],
        corpus['scene_actions'],len(corpus['records'])) ==
        (ARCHIVE_HASH,ARCHIVE_HASH,EXE_HASH,MANIFEST_HASH,2267,2078,19612,10), 'corpus identity mismatch')
    # Verify EVERY resource before scanning selected rows.
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT/'work/analysis/hiff-resources'/f'{index:04d}.bin').read_bytes()
        require((len(data),sha(data)) == (row['size'],row['sha256']), 'resource identity mismatch')
        resources[index] = data
    records = []
    for row in corpus['records']:
        offset,size = row['act_payload_offset'],row['act_payload_length']
        payload = resources[row['resource_index']][offset:offset+size]
        require((len(payload), payload[48], payload[49], sha(payload[50:])) ==
                (size,0x17,row['subtype'],row['body_sha256']), 'corpus row mismatch')
        records.append((payload,row['typed_body_length']))
    return records


def compare(native, machine, payload, expected, offset=50):
    original, advance, after = machine.invoke(payload, offset)
    status, decoded, raw, _ = native.invoke(payload[50:])
    require(status == 0, 'native decoder rejected valid original')
    length = C.c_size_t(0xa5)
    require(native.lib.action_family_17_body_length(raw,len(payload)-50,C.byref(length)) == 0,
            'native body_length rejected valid original')
    require((length.value,decoded.body_bytes,advance) == (expected,expected,expected), 'body/cursor mismatch')
    require((tuple(decoded.words),decoded.count,decoded.records) ==
        (struct.unpack_from('<10H',original),struct.unpack_from('<h',original,20)[0],C.addressof(raw)+22),
        'decoded field/view mismatch')
    require((decoded.raw_type,decoded.runtime_type) == (payload[48],payload[48]), 'native type mismatch')
    arena = storage(b'\xa6'*(expected+16))
    model = Constructed()
    require(native.lib.action_family_17_construct(raw,len(payload)-50,offset,ARENA,arena,
        expected,C.byref(model)) == 0, 'native constructor rejected valid original')
    require(bytes(arena) == original + b'\xa6'*16, 'whole original/native object mismatch')
    dep = (C.addressof(raw)+advance,(len(payload)-50-advance)//16,len(payload)-50-advance,len(payload)-50)
    for obj in (decoded,model):
        require((obj.dependency_records,obj.dependency_count,obj.dependency_bytes,obj.available_body_bytes) == dep,
                'dependency view/count mismatch')
    require((model.body_bytes_consumed,model.allocation_bytes,model.payload_offset_before,
        model.payload_offset_after,model.result_slot_handle,model.raw_type,model.runtime_type) ==
        (advance,len(original),offset,after,ARENA,0x17,0x17), 'constructor state/cursor/type mismatch')
    require(bytes(raw) == payload[50:], 'native changed source')
    return sha(original),len(original)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native-library',type=Path)
    parser.add_argument('--result',type=Path)
    args = parser.parse_args()
    directory = Path(tempfile.mkdtemp(prefix='A-17.1.oracle-',dir=PRIVATE))
    result = args.result or directory/'report.json'
    require(not result.exists(), 'result must be unique')
    library = args.native_library
    if library is None:
        subprocess.run([str(PROJECT/'scripts/build_action_family_17.sh')],check=True,
            env=dict(os.environ,BUILD_DIR=str(directory)),capture_output=True)
        library = directory/'libactionfamily17.dylib'
    native,machine,tail = Native(library),Original(),OriginalTail()
    records = corpus_records()
    objects, corpus_bytes, synthetic_bytes = [],0,0
    tail_exits = Counter()
    tail_count = short_checks = 0
    header = b'fixture\0'+bytes(40)+bytes([0x17,1])
    synthetic = [(header+body_fixture(n,t),22+18*n,off) for n,t,off in
        ((0,0,50),(1,16,50),(2,32,50),(3,48,50),(1819,0,50),(1819,16,50),
         (7,0,0xfffffff0),(0,0,0xffffffff))]
    for payload,typed in records:
        digest,size = compare(native,machine,payload,typed)
        objects.append(digest);corpus_bytes += size
    for payload,typed,offset in synthetic:
        digest,size = compare(native,machine,payload,typed,offset)
        objects.append(digest);synthetic_bytes += size
    for payload,typed in records + [(p,t) for p,t,_ in synthetic]:
        prefix = payload[:50+typed]
        for data in [payload]+[prefix+bytes((i*37+11)&255 for i in range(n)) for n in range(41)]:
            original = compare_tail(native,tail,data,typed)
            # body_length success must report the observed original cursor.
            st,_d,raw,before = native.invoke(data[50:]); length = C.c_size_t(0xabcdef)
            status = native.lib.action_family_17_body_length(raw,len(data)-50,C.byref(length))
            require((status == 0) == original.accepted, 'body_length tail acceptance mismatch')
            require(length.value == (typed if original.accepted else 0xabcdef), 'body_length tail value mismatch')
            require(st == status, 'decode/body_length status mismatch')
            tail_exits[hex(original.exit_address)] += 1;tail_count += 1
        for logical in range(typed if typed < 128 else 22):
            check_short_body(native,tail,prefix,typed,logical)
            backing = storage(prefix[50:]); length = C.c_size_t(0xabcdef)
            require(native.lib.action_family_17_body_length(backing,logical,C.byref(length)) == 2 and
                    length.value == 0xabcdef, 'short body_length safety mismatch')
            short_checks += 1
    # DWORD dependency counts, beyond byte and word widths.
    prefix,typed = records[0];prefix=prefix[:50+typed]
    for count in (256,65536):
        original=compare_tail(native,tail,prefix+bytes(16*count),typed)
        tail_exits[hex(original.exit_address)] += 1;tail_count += 1
    count_safety_checks = 0
    for count in (1820,32767,32768,65535,3640,3641,3642):
        body=bytearray(body_fixture(0));struct.pack_into('<H',body,20,count)
        status,decoded,raw,before=native.invoke(bytes(body))
        length=C.c_size_t(0xabcdef);model=Constructed();arena=storage(b'\xa6'*22)
        C.memset(C.byref(model),0xa5,C.sizeof(model));model_before=bytes(model)
        require(status == 3 and bytes(decoded) == before, 'count safety mismatch')
        require(native.lib.action_family_17_body_length(raw,len(body),C.byref(length)) == 3 and
                length.value == 0xabcdef, 'count body_length safety mismatch')
        require(native.lib.action_family_17_construct(raw,len(body),50,ARENA,arena,22,C.byref(model)) == 3 and
                bytes(model) == model_before and bytes(arena) == b'\xa6'*22, 'count constructor safety mismatch')
        count_safety_checks += 1
    report = dict(slice='A-17.1',status='pass',original_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,
        archive_sha256=ARCHIVE_HASH,corpus_sha256=CORPUS_HASH,code_ranges=CODE,
        native_library=str(library),native_sha256=sha(library.read_bytes()),
        source_sha256=sha((PROJECT/'src/action_family_17.c').read_bytes()),
        oracle_sha256=sha(Path(__file__).read_bytes()),
        corpus_constructor_comparisons=len(records),synthetic_constructor_comparisons=len(synthetic),
        original_loader_calls=machine.calls,corpus_object_bytes=corpus_bytes,synthetic_object_bytes=synthetic_bytes,
        object_hashes_sha256=sha(''.join(objects).encode()),allocation_sizes=dict(machine.sizes),
        dependency_parity_comparisons=tail_count,tail_exit_counts=dict(tail_exits),
        native_short_body_safety_checks=short_checks,original_tail_calls=tail.calls,mismatches=0,
        native_count_safety_checks=count_safety_checks,
        hook_inventory=HOOKS,tail_exit_points=EXIT_POINTS,
        deliberate_safety_rejections=['counts outside 0..1819 (including wrapped positive sizes)',
            'short bodies (original unsigned tail arithmetic differs)','null/wrapped/overlapping spans',
            'undersized storage and zero handles'],unverified_branches=UNVERIFIED)
    write_json(result,report)
    print(json.dumps({k:report[k] for k in ('corpus_constructor_comparisons','synthetic_constructor_comparisons',
        'dependency_parity_comparisons','native_short_body_safety_checks','mismatches')}) + '\n' + str(result))


if __name__ == '__main__':
    main()
