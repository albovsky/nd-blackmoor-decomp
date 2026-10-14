#!/usr/bin/env python3
"""Execute the original ACT loader to its dependency boundary, without logic hooks.

Use work/tools/oracle-python/bin/python. Evidence and resource bytes stay private.
The census is produced by work/analysis/slices/A-A1.1.discovery.py against the
unchanged native scene parser. No executable/resource bytes are embedded here.
"""
import argparse
import collections
import ctypes as C
import hashlib
import json
import struct
import time
from pathlib import Path

from autotext_original_oracle import (OriginalAutoText, _read_cvtx_payload,
    parse_entries, TABLE_VA, ALLOC_LIMIT, STACK_TOP, ALLOCATOR_VA)
from test_action_family_a1 import Decoded, Constructed, fixture, storage, load_native

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '9c29fd264444221ec8f417211caa5ff47c313a6bb146ef10f2c60688a38ceb0d'
CODE = [
    (0x40b34a, 0x40b44b, '79fbcef9c1b303a0b894dc6cbcf544102d0cab67c3b7832488537823daa5451d'),
    (0x40f069, 0x40f532, 'b8c1c6011f754a044bbcb2270d3d208232d4a18e04f541d641f73e7379046d6f'),
    (0x410f99, 0x41107f, '66213ccc0b5222fd241ed267229688698a430b4ba06d799544623c6f4ec73aa1'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x423097, 0x4230d1, '9ef78e5e90da3f4962a0ddc051cae69dc5052a7bf3c04653428f1a6347cb3e0f'),
    (0x423142, 0x423259, '6910fd42954f15d645d47b5092f2f8856dca626982d0c7e053a167083309f578'),
    (0x423259, 0x423310, 'e482a132a6a8391b0b8c3e69e2008669d9af3ed80c4e426de7da0d9b996d047e'),
]
INPUT = 0x24000000
GLOBAL_TABLE = 0x619a6b
BOUNDARY = 0x410a68


def sha(data):
    return hashlib.sha256(data).hexdigest()


class OriginalLoader(OriginalAutoText):
    def __init__(self):
        self.allocations = []
        super().__init__(ROOT / 'work/original/GAME.EXE')
        self.machine.mem_map(INPUT, 0x20000)

    def _on_code(self, uc, address, _size, _data):
        # The sole hook replaces allocation, never an original decision.
        if address != ALLOCATOR_VA:
            raise RuntimeError('unexpected hook')
        esp = uc.reg_read(self._reg['ESP'])
        requested = struct.unpack('<I', uc.mem_read(esp+4, 4))[0]
        start = ((self._allocator_cursor + 31) & ~15) + 16
        end = start + requested
        if requested == 0 or end+16 > ALLOC_LIMIT:
            raise RuntimeError(f'allocator boundary exceeded: {requested}')
        uc.mem_write(start-16, b'\xa5'*16 + b'\xcd'*requested + b'\xd7'*16)
        self._allocator_cursor = end+16
        self._allocator_calls += 1
        self.allocations.append((start, requested))
        uc.reg_write(self._reg['EAX'], start)
        self._return_from_intercepted_call(uc)

    def copy_table(self):
        self.machine.mem_write(GLOBAL_TABLE, bytes(self.machine.mem_read(TABLE_VA, 4096)))

    def invoke(self, payload):
        uc, r = self.machine, self._reg
        uc.mem_write(INPUT, b'\xa6'*16 + payload + b'\xd6'*16)
        uc.mem_write(0x5c39e3, b'\0\0')
        uc.mem_write(0x5bb5b3, bytes(0x8d))
        # Preserve the pinned image's zero debug flag; do not bypass logging.
        if bytes(uc.mem_read(0x63a4cd, 2)) != b'\0\0':
            raise RuntimeError('unexpected original debug flag')
        uc.mem_write(STACK_TOP-0x1000, b'\x3c'*16)
        uc.mem_write(STACK_TOP+32, b'\x7e'*16)
        args = struct.pack('<III', 0x30000000, INPUT+16, len(payload))
        uc.mem_write(STACK_TOP, args)
        initial = dict(EAX=0x11111111, EBX=0x22222222, ECX=0x33333333,
                       EDX=0x44444444, ESI=0x55555555, EDI=0x66666666, EBP=0x77777777)
        for key, value in initial.items():
            uc.reg_write(r[key], value)
        uc.reg_write(r['ESP'], STACK_TOP)
        uc.reg_write(r['EFLAGS'], 0x202)
        before = len(self.allocations)
        uc.emu_start(0x40b34a, BOUNDARY, count=4000000)
        if uc.reg_read(r['EIP']) != BOUNDARY:
            raise RuntimeError(f'loader failed to reach dependency boundary: {uc.reg_read(r["EIP"]):#x}')
        if len(self.allocations) != before+1:
            raise RuntimeError('expected exactly one runtime object allocation')
        addr, n = self.allocations[-1]
        ebp = uc.reg_read(r['EBP'])
        cursor = struct.unpack('<I', uc.mem_read(ebp-0x20, 4))[0]
        offset = struct.unpack('<I', uc.mem_read(ebp-0xcc, 4))[0]
        slot = struct.unpack('<I', uc.mem_read(0x5bb5e5, 4))[0]
        if slot != addr or bytes(uc.mem_read(0x5bb5e3, 2)) != payload[48:50]:
            raise RuntimeError('pData slot or raw type/subtype changed')
        for pos, expected in ((INPUT, b'\xa6'*16), (INPUT+16, payload),
                              (INPUT+16+len(payload), b'\xd6'*16),
                              (addr-16, b'\xa5'*16), (addr+n, b'\xd7'*16),
                              (STACK_TOP-0x1000, b'\x3c'*16), (STACK_TOP, args),
                              (STACK_TOP+32, b'\x7e'*16)):
            if bytes(uc.mem_read(pos, len(expected))) != expected:
                raise RuntimeError(f'input/allocation/stack guard changed at {pos:#x}')
        return bytes(uc.mem_read(addr, n)), cursor-(INPUT+16+50), offset


def check_record(lib, machine, body, payload, resolved, ordinal):
    src = storage(body)
    d, native = Decoded(), Constructed()
    if lib.action_family_a1_decode(src, len(body), C.byref(d)) != 0:
        raise RuntimeError(f'decoder rejected record {ordinal}')
    selector = struct.unpack_from('<h', body, 49)[0]
    typed = 84 if selector == -1 else 51+selector
    expect = (struct.unpack_from('<H', body, 33)[0], struct.unpack_from('<I', body,35)[0],
              struct.unpack_from('<H',body,39)[0],struct.unpack_from('<H',body,41)[0],
              body[43],struct.unpack_from('<H',body,44)[0],
              struct.unpack_from('<H',body,46)[0],body[48])
    actual = (d.option_21,d.word_23,d.option_27,d.option_29,d.option_2b,d.option_2c,d.option_2e,d.option_30)
    if actual != expect or d.text_selector != selector:
        raise RuntimeError(f'decoded field mismatch record {ordinal}')
    name = body[:33].split(b'\0')[0]
    if bytes(d.name) != name+bytes(33-len(name)):
        raise RuntimeError(f'decoded name mismatch record {ordinal}')
    if selector == -1:
        key = body[51:84].split(b'\0')[0]
        if bytes(d.text_key) != key+bytes(33-len(key)) or d.inline_text or d.inline_text_bytes:
            raise RuntimeError(f'decoded key mismatch record {ordinal}')
    elif d.inline_text != C.addressof(src)+51 or d.inline_text_bytes != selector:
        raise RuntimeError(f'decoded inline view mismatch record {ordinal}')
    if (d.body_bytes,d.dependency_count,d.dependency_bytes,d.available_body_bytes,d.dependency_records) != (
        typed,(len(body)-typed)//16,len(body)-typed,len(body),C.addressof(src)+typed):
        raise RuntimeError(f'decoded body/tail mismatch record {ordinal}')
    text = storage(resolved) if resolved else None
    status = lib.action_family_a1_construct(src,len(body),text,len(resolved or b''),50,0xa1000001,C.byref(native))
    if status != 0:
        raise RuntimeError(f'constructor rejected record {ordinal}: {status}')
    original, advance, offset = machine.invoke(payload)
    image = bytes(native.object_bytes[:native.allocation_bytes])
    if image != original:
        diff = next((i for i,(a,b) in enumerate(zip(image,original)) if a!=b), min(len(image),len(original)))
        raise RuntimeError(f'original/native object mismatch record {ordinal}, byte {diff:#x}, sizes {len(image)}/{len(original)}')
    if (advance,offset) != (typed,50+typed) or (native.body_bytes_consumed,native.payload_offset_after,
        native.dependency_records,native.dependency_count,native.result_slot_handle) != (
        advance,offset,C.addressof(src)+typed,(len(body)-typed)//16,0xa1000001):
        raise RuntimeError(f'original/native cursor or slot mismatch record {ordinal}')
    return image, original


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library', type=Path, default=ROOT/'outputs/blackmoor-decomp/build/libactionfamilya1.dylib')
    ap.add_argument('--result', type=Path, default=PRIVATE/'A-A1.1.original-oracle.json')
    args = ap.parse_args()
    started = time.monotonic()
    manifest_bytes = (ROOT/'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes = (PRIVATE/'A-A1.1.corpus.json').read_bytes()
    if sha(manifest_bytes) != MANIFEST_HASH or sha(corpus_bytes) != CORPUS_HASH:
        raise RuntimeError('pinned corpus/manifest mismatch')
    manifest, corpus = json.loads(manifest_bytes), json.loads(corpus_bytes)
    if (manifest['archive_sha256'] != ARCHIVE_HASH or corpus['archive_sha256'] != ARCHIVE_HASH
            or corpus['exe_sha256'] != EXE_HASH or corpus['manifest_sha256'] != MANIFEST_HASH
            or corpus['raw_0xa1_records'] != 565 or len(corpus['records']) != 565):
        raise RuntimeError('archive/corpus count mismatch')
    resources = {}
    for row in manifest['resources']:
        b = (ROOT/'work/analysis/hiff-resources'/f'{int(row["index"]):04d}.bin').read_bytes()
        if len(b)!=row['size'] or sha(b)!=row['sha256']:
            raise RuntimeError('resource manifest mismatch')
        resources[int(row['index'])] = b
    if len(resources)!=2267:
        raise RuntimeError('resource coverage mismatch')
    exe = (ROOT/'work/original/GAME.EXE').read_bytes()
    if sha(exe)!=EXE_HASH:
        raise RuntimeError('executable mismatch')
    for start,end,digest in CODE:
        if sha(exe[start-0x400000:end-0x400000])!=digest:
            raise RuntimeError('code window mismatch')
    lib = load_native(args.native_library)
    machine = OriginalLoader()
    machine.initialize()
    entries = parse_entries(_read_cvtx_payload(resources[1]))
    captions = {}
    for entry in entries:
        machine.insert(entry['key_field'],entry['raw_value'])
        captions.setdefault(entry['key'].lower(),entry['caption'])
    machine.copy_table()
    table_allocations = len(machine.allocations)
    native_digest, original_digest = hashlib.sha256(),hashlib.sha256()
    body_digest, tail_digest = hashlib.sha256(),hashlib.sha256()
    object_bytes = 0
    hist = collections.Counter()
    for ordinal,row in enumerate(corpus['records']):
        resource = resources[row['resource_index']]
        start,n = row['raw_body_offset'],row['raw_body_length']
        p = row['act_payload_offset']
        body = resource[start:start+n]
        payload = resource[p:p+row['act_payload_length']]
        if start != p+50 or len(payload)!=n+50 or payload[48]!=0xa1 or payload[49]!=row['subtype'] or sha(body)!=row['body_sha256']:
            raise RuntimeError('corpus row source disagreement')
        selector = struct.unpack_from('<h',body,49)[0]
        resolved = None
        if selector == -1:
            key = body[51:84].split(b'\0')[0].lower()
            if key not in captions:
                raise RuntimeError(f'unresolved corpus AUTOTEXT record {ordinal}')
            resolved = captions[key]
        image, original = check_record(lib,machine,body,payload,resolved,ordinal)
        if row['typed_body_length'] != (84 if selector==-1 else 51+selector):
            raise RuntimeError('census rule disagreement')
        tail = body[row['typed_body_length']:]
        if (row['dependency_tail_length'],row['dependency_tail_records']) != (len(tail),len(tail)//16):
            raise RuntimeError('census tail disagreement')
        native_digest.update(image); body_digest.update(body); object_bytes += len(image)
        original_digest.update(original)
        tail_digest.update(tail)
        hist[row['dependency_tail_records']] += 1
    synthetic = []
    for i,(selector,length) in enumerate([(0,0),(1,0),(9999,0),(-1,0),(-1,1),(-1,32591),(3,0),(-1,32)]):
        body = fixture(selector,2,name=bytes(range(1,33)))
        if i == 6:
            body = fixture(3,2,text=b'a\0b')
        resolved = None
        if selector == -1:
            key = b'K'*32 if i == 7 else f'A1SYNTH{i}'.encode()
            b = bytearray(body);b[51:84]=key+bytes(33-len(key));body=bytes(b)
            resolved = b'z'*length
            machine.insert(key+bytes(33-len(key)),resolved)
            machine.copy_table()
        payload = b'synthetic'+bytes(48-9)+bytes([0xa1,2 if i%2 else 1])+body
        image, _ = check_record(lib,machine,body,payload,resolved,f'synthetic-{i}')
        synthetic.append(dict(selector=selector,resolved_bytes=length,allocation_bytes=len(image)))
    result = dict(slice='A-A1.1', scope='original 0x40b34a through 0x410a68; generic dependency builder and runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH,resources_verified=len(resources),code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        corpus_records=565,synthetic_records=len(synthetic),mismatches=0,
        corpus_object_bytes_compared=object_bytes,corpus_object_sha256=native_digest.hexdigest(),
        original_object_sha256=original_digest.hexdigest(),
        corpus_raw_bodies_sha256=body_digest.hexdigest(),synthetic=synthetic,
        corpus_dependency_tails_sha256=tail_digest.hexdigest(),
        dependency_histogram=dict(sorted(hist.items())),
        oracle_hooks={'0x51dc43': 'allocation boundary only; guarded bump allocation, no original decisions replaced'},
        table_setup_allocations=table_allocations,total_allocation_hook_calls=len(machine.allocations),
        guards='raw payload including tail, allocation prefix/suffix, caller stack, distant stack canaries',
        runtime_type='0xa1 retained; subtype preserved; 0x9f shared branch has distinct prefix size',
        elapsed_seconds=round(time.monotonic()-started,3))
    args.result.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['corpus_records','synthetic_records','mismatches','corpus_object_bytes_compared','native_library_sha256','elapsed_seconds']}))


if __name__ == '__main__':
    main()
